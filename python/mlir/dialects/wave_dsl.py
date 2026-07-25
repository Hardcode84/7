#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Light builder helpers around the Wave/WaveAMD MLIR Python bindings.

The DSL is intentionally thin: it exposes a small set of context managers
that wrap an MLIR :class:`Context` + :class:`Module` and a couple of
mini-builders that map directly onto the generated dialect ops. It is
the foundation that :mod:`wave_matmul` uses to assemble the tiled WMMA
kernel, but it is also useful on its own for writing one-off Wave
kernels in Python.

Usage::

    from mlir.dialects import wave_dsl as dsl

    with dsl.module() as bld:
        with bld.gpu_module("kernels"):
            with bld.kernel("k", [dsl.ptr_type()]):
                ...

        with bld.host_main():
            ...

    print(str(bld.module))
"""

from __future__ import annotations

from collections.abc import Iterable, Iterator, Mapping, Sequence
from contextlib import contextmanager
from enum import Enum, auto
from types import TracebackType
from typing import Any

import ixsimpl
from mlir._mlir_libs._waveDialectsNanobind import (
    BufferAddressSpaceAttr,
    ExprAttr,
    FragmentType,
    GlobalAddressSpaceAttr,
    LoadCacheAttr,
    MaskType,
    MemoryMappingAttr,
    MemTokenType,
    PredAttr,
    PrivateAddressSpaceAttr,
    PtrType,
    RedistributionAttr,
    SharedAddressSpaceAttr,
    SimdType,
    StoreCacheAttr,
    register_dialects,
    register_passes,
)
from mlir.dialects import arith, func, gpu, memref, scf, wave, waveamd, wavemeta
from mlir.dialects.arith import CmpFPredicate, CmpIPredicate
from mlir.ir import (
    ArrayAttr,
    Attribute,
    BF16Type,
    Block,
    Context,
    DenseI32ArrayAttr,
    F16Type,
    F32Type,
    IndexType,
    InsertionPoint,
    IntegerAttr,
    IntegerType,
    Location,
    MemRefType,
    Module,
    ShapedType,
    StringAttr,
    Type,
    UnitAttr,
    UnrankedMemRefType,
    Value,
    VectorType,
)
from mlir.passmanager import PassManager

# Make wave passes discoverable to PassManager.parse(...) on first
# import. The underlying TableGen registration de-dups, so re-imports
# are free.
register_passes()

# Process-wide ixsimpl context for symbolic offset expressions. The DSL
# hands callers symbols / literals out of this context and the
# `index_expr` builder structurally imports the resulting `Expr` into the
# Wave dialect's per-MLIRContext symbol store at the FFI boundary.
# Sharing one Python-side context across the process keeps symbol
# identity stable (e.g. `sym("lane")` is the same node for every kernel
# in this interpreter), keeping structural imports deterministic.
sym_ctx: ixsimpl.Context = ixsimpl.Context()
Expr = ixsimpl.Expr


def sym(name: str) -> ixsimpl.Expr:
    """Return the `sym_ctx`-rooted symbol leaf with this name."""
    return sym_ctx.sym(name)


def _ixsimpl_node_ptr(expr: ixsimpl.Expr) -> int:
    try:
        return int(expr.node_ptr)
    except AttributeError as exc:
        raise RuntimeError("ixsimpl Expr.node_ptr required") from exc


def _pred_attr(pred: ixsimpl.Expr) -> PredAttr:
    if not pred.is_pred:
        raise TypeError("wave.assume expects ixsimpl predicate nodes")
    return PredAttr.get_from_node_ptr(
        _ixsimpl_node_ptr(pred), context=_current_context()
    )


# Re-export the ixsimpl algebraic helpers callers reach for when
# building `wave.index_expr` expressions. Keeps the DSL the single
# import point for kernel builders -- no separate `import ixsimpl`.
floor = ixsimpl.floor
ceil = ixsimpl.ceil
mod = ixsimpl.mod
xor = ixsimpl.xor_


# ---------------------------------------------------------------------------
# Type helpers
# ---------------------------------------------------------------------------


BinaryKind = wave.BinaryKind
CastKind = wave.CastKind


class _YieldKind(Enum):
    SCF = auto()
    WAVE = auto()
    WAVEMETA = auto()


def _ends_with(block: Block, op_type: type) -> bool:
    return len(block.operations) > 0 and isinstance(block.operations[-1], op_type)


def _finish_wave_region(block: Block, result_types: Sequence[Type]) -> None:
    if _ends_with(block, wave.YieldOp):
        return
    if result_types:
        raise RuntimeError("result-bearing wave.where region must yield values")
    wave.YieldOp([])


def _finish_scf_region(block: Block, result_types: Sequence[Type]) -> None:
    if _ends_with(block, scf.YieldOp):
        return
    if result_types:
        raise RuntimeError("result-bearing scf.if region must yield values")
    scf.YieldOp([])


def i1() -> IntegerType:
    return IntegerType.get_signless(1)


def i8() -> IntegerType:
    return IntegerType.get_signless(8)


def i16() -> IntegerType:
    return IntegerType.get_signless(16)


def i32() -> IntegerType:
    return IntegerType.get_signless(32)


def i64() -> IntegerType:
    return IntegerType.get_signless(64)


def i64_attr(value: int) -> IntegerAttr:
    return IntegerAttr.get(i64(), value)


def i32_array_attr(values: Sequence[int]) -> DenseI32ArrayAttr:
    return DenseI32ArrayAttr.get(values)


def f16() -> F16Type:
    return F16Type.get()


def bf16() -> BF16Type:
    return BF16Type.get()


def f32() -> F32Type:
    return F32Type.get()


def index_type() -> IndexType:
    return IndexType.get()


def simd_type(element_type: Type | None = None, width: int = 32) -> Type:
    return SimdType.get(element_type or i32(), width=width)


def vector_type(elements: int, element_type: Type | None = None) -> Type:
    """Build a 1-D MLIR vector type.

    Handy when composing ``simd_type(vector_type(R, i32()))`` for the
    multi-register ``wave.load`` / ``waveamd.fragment_pack`` shape.
    """
    return VectorType.get([elements], element_type or i32())


def mask_type(width: int = 32) -> Type:
    return MaskType.get(width=width, context=_current_context())


def mem_token_type() -> Type:
    return MemTokenType.get(context=_current_context())


def global_address_space() -> Attribute:
    return GlobalAddressSpaceAttr.get(context=_current_context())


def shared_address_space() -> Attribute:
    return SharedAddressSpaceAttr.get(context=_current_context())


def private_address_space() -> Attribute:
    return PrivateAddressSpaceAttr.get(context=_current_context())


def buffer_address_space() -> Attribute:
    return BufferAddressSpaceAttr.get(context=_current_context())


def load_cache(kind: int) -> Attribute:
    return LoadCacheAttr.get(kind, context=_current_context())


def store_cache(kind: int) -> Attribute:
    return StoreCacheAttr.get(kind, context=_current_context())


def ptr_type(
    element_type: Type | None = None,
    address_space: Attribute | None = None,
) -> Type:
    return PtrType.get(element_type or i32(), address_space or global_address_space())


def opaque_ptr_type(address_space: Attribute | None = None) -> Type:
    return PtrType.get_opaque(address_space or global_address_space())


def buffer_ptr_type(element_type: Type | None = None) -> Type:
    return ptr_type(element_type, buffer_address_space())


def opaque_buffer_ptr_type() -> Type:
    return opaque_ptr_type(buffer_address_space())


def simd_ptr_type(
    element_type: Type | None = None,
    address_space: Attribute | None = None,
    width: int = 32,
) -> Type:
    return simd_type(ptr_type(element_type, address_space), width=width)


def fragment_type(
    role: int,
    element_type: Type,
    rows: int = 16,
    columns: int = 16,
    wave_size: int = 32,
    registers: int = 4,
) -> Type:
    return FragmentType.get(
        role,
        element_type,
        rows=rows,
        columns=columns,
        wave_size=wave_size,
        registers=registers,
        context=_current_context(),
    )


def _current_context() -> Context:
    """Return the active MLIR context for the current thread.

    The typed `MemTokenType.get(...)` etc. require an explicit
    `MlirContext`. Inside a `ModuleBuilder` / `with ctx` block, MLIR
    Python keeps the active context on a thread-local; surface that to
    the type helpers so callers don't have to pass `ctx` everywhere.
    """
    return Context.current


def _arith_result_type(lhs: Value, rhs: Value) -> Type:
    """Infer the result type for integer `wave.binary`.

    Result is SIMD if any operand is SIMD; element type follows the
    operands' shared bit-width (we trust the verifier to reject
    mismatches).
    """
    lhs_simd = SimdType.isinstance(lhs.type)
    rhs_simd = SimdType.isinstance(rhs.type)
    if not (lhs_simd or rhs_simd):
        return lhs.type
    simd = SimdType(lhs.type if lhs_simd else rhs.type)
    return simd_type(simd.element_type, simd.width)


def _overflow_flags_attr(nsw: bool, nuw: bool) -> Attribute | None:
    flags = []
    if nsw:
        flags.append("nsw")
    if nuw:
        flags.append("nuw")
    if not flags:
        return None
    return Attribute.parse(f"#arith.overflow<{', '.join(flags)}>")


def _binding_lane_width(values: Iterable[Value]) -> int:
    """Reduce binding operand types to a single non-zero lane width.

    Uniform scalars contribute zero. Lane-varying SIMD operands must agree on
    `W`.
    """
    lane = 0
    for v in values:
        ty = v.type
        width = SimdType(ty).width if SimdType.isinstance(ty) else 0
        if width == 0:
            continue
        if lane and lane != width:
            raise ValueError(
                f"conflicting lane-varying binding widths: {lane} vs {width}"
            )
        lane = width
    return lane


def _lane_width(type_: Type) -> int:
    if SimdType.isinstance(type_):
        return int(SimdType(type_).width)
    return 0


def _index_expr_result_type(width: int) -> Type:
    if width == 0:
        return index_type()
    return simd_type(index_type(), width)


def _index_expr_bindings(
    expr: ixsimpl.Expr, bindings: Mapping[ixsimpl.Expr, Value] | None
) -> dict[str, Value]:
    binding_map = {key.sym_name: value for key, value in (bindings or {}).items()}
    free_names = {symbol.sym_name for symbol in expr.free_symbols}
    unknown = free_names - binding_map.keys()
    if unknown:
        raise ValueError(f"free symbols missing from bindings: {sorted(unknown)}")
    return {name: binding_map[name] for name in binding_map if name in free_names}


def _index_expr_result_type_from_bindings(
    bindings: Mapping[str, Value], result_type: Type | None
) -> Type:
    if result_type is not None:
        return result_type
    return _index_expr_result_type(_binding_lane_width(bindings.values()))


def _index_expr_assumptions_attr(
    assumptions: Sequence[ixsimpl.Expr] | None,
) -> ArrayAttr | None:
    if assumptions is None:
        return None
    return ArrayAttr.get([_pred_attr(pred) for pred in assumptions])


_MEMORY_MAPPING_RESERVED_SYMBOLS = frozenset({"block", "item", "slot"})


def _memory_mapping_required_names(
    expressions: Sequence[ixsimpl.Expr],
) -> set[str]:
    return {
        symbol.sym_name
        for expr in expressions
        for symbol in expr.free_symbols
        if symbol.sym_name not in _MEMORY_MAPPING_RESERVED_SYMBOLS
    }


def _named_memory_mapping_values(
    values: Mapping[ixsimpl.Expr, Value | Sequence[Value]] | None,
    kind: str,
    required_names: set[str],
) -> dict[str, Value | Sequence[Value]]:
    named: dict[str, Value | Sequence[Value]] = {}
    for symbol, value in (values or {}).items():
        try:
            name = symbol.sym_name
        except (AttributeError, RuntimeError, TypeError) as exc:
            raise TypeError(f"{kind} keys must be symbol expressions") from exc
        if name in _MEMORY_MAPPING_RESERVED_SYMBOLS:
            raise ValueError(f"{kind} name {name!r} is reserved")
        if name in named:
            raise ValueError(f"duplicate {kind} name {name!r}")
        if name in required_names:
            named[name] = value
    return dict(sorted(named.items()))


def _memory_mapping_expr_attr(expr: ixsimpl.Expr | None) -> ExprAttr | None:
    if expr is None:
        return None
    return ExprAttr.get_from_node_ptr(
        _ixsimpl_node_ptr(expr), context=_current_context()
    )


def _memory_mapping_parts(
    bit_offset: ixsimpl.Expr,
    base: ixsimpl.Expr | None,
    target_block: ixsimpl.Expr | None,
    bindings: Mapping[ixsimpl.Expr, Value] | None,
    packet_bindings: Mapping[ixsimpl.Expr, Value | Sequence[Value]] | None,
) -> tuple[
    MemoryMappingAttr,
    dict[str, Value],
    dict[str, Value | Sequence[Value]],
]:
    """Import a symbolic memory map and its bindings structurally."""
    expressions = tuple(
        expr for expr in (base, target_block, bit_offset) if expr is not None
    )
    required_names = _memory_mapping_required_names(expressions)
    bound_values = _named_memory_mapping_values(bindings, "binding", required_names)
    explicit_packet_values = _named_memory_mapping_values(
        packet_bindings, "packet binding", required_names
    )
    overlap = bound_values.keys() & explicit_packet_values.keys()
    if overlap:
        raise ValueError(
            f"symbols cannot be both scalar and packet bindings: {sorted(overlap)}"
        )
    missing = required_names - bound_values.keys() - explicit_packet_values.keys()
    if missing:
        raise ValueError(f"mapping symbols missing from bindings: {sorted(missing)}")

    scalar_values: dict[str, Value] = {}
    packet_values = dict(explicit_packet_values)
    for name, value in bound_values.items():
        if not isinstance(value, Value):
            raise TypeError(f"binding {name!r} must be one SSA value")
        if SimdType.isinstance(value.type) and isinstance(
            SimdType(value.type).element_type, VectorType
        ):
            packet_values[name] = value
        else:
            scalar_values[name] = value

    mapping = MemoryMappingAttr.get(
        _memory_mapping_expr_attr(bit_offset),
        base=_memory_mapping_expr_attr(base),
        target_block=_memory_mapping_expr_attr(target_block),
    )
    return mapping, scalar_values, packet_values


def _flatten_packet_mapping_values(
    packet_values: Mapping[str, Value | Sequence[Value]],
) -> tuple[list[str], list[Value]]:
    names: list[str] = []
    values: list[Value] = []
    for name, binding in packet_values.items():
        components = [binding] if isinstance(binding, Value) else list(binding)
        if not components:
            raise ValueError(f"packet binding {name!r} must not be empty")
        if not all(isinstance(component, Value) for component in components):
            raise TypeError(f"packet binding {name!r} components must be SSA values")
        names.extend([name] * len(components))
        values.extend(components)
    return names, values


def specialize_wavemeta(module: Module) -> None:
    """Bind module-level `wavemeta.params` and run `wavemeta-specialize`
    in place. After the call no `wavemeta.*` op survives in `module`.
    """
    with module.context:
        pm = PassManager.parse("builtin.module(wavemeta-specialize)")
        pm.run(module.operation)


def unranked_memref_type(element_type: Type) -> Type:
    return UnrankedMemRefType.get(element_type, Attribute.parse("0"))


def dynamic_1d_memref_type(element_type: Type) -> Type:
    """Build a ``memref<?xT>`` (1-D, dynamic-size) shape-erased memref.

    Useful when declaring a runtime helper that takes any 1-D buffer of
    ``element_type``; callers can ``memref_cast`` the static-shape
    storage they hold over to this type.
    """
    return MemRefType.get([ShapedType.get_dynamic_size()], element_type)


# ---------------------------------------------------------------------------
# Module / function builders
# ---------------------------------------------------------------------------


class ModuleBuilder:
    """Owns a Wave-aware :class:`mlir.ir.Context` and a builtin module.

    The module is wrapped with ``gpu.container_module`` so it is ready to
    host both a kernel-side ``gpu.module`` and a host-side ``func.func``.
    """

    def __init__(self) -> None:
        self.context = Context()
        register_dialects(self.context)
        self.location = Location.unknown(context=self.context)
        self.module: Module | None = None
        self._ctx_token = None
        self._loc_token = None
        self._ip_token = None
        self._ip: InsertionPoint | None = None

    def __enter__(self) -> ModuleBuilder:
        self.context.__enter__()
        self.location.__enter__()
        self.module = Module.create()
        self.module.operation.attributes["gpu.container_module"] = UnitAttr.get()
        self._ip = InsertionPoint(self.module.body)
        self._ip.__enter__()
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        assert self._ip is not None
        self._ip.__exit__(exc_type, exc, tb)
        self.location.__exit__(exc_type, exc, tb)
        self.context.__exit__(exc_type, exc, tb)

    def __str__(self) -> str:
        assert self.module is not None
        asm: str = self.module.operation.get_asm(assume_verified=True)
        return asm

    # --- GPU module / kernel -----------------------------------------------

    @contextmanager
    def gpu_module(self, name: str) -> Iterator[_GpuModuleBuilder]:
        gmod = gpu.GPUModuleOp(name)
        body = gmod.bodyRegion.blocks.append()
        with InsertionPoint(body):
            yield _GpuModuleBuilder(gmod)

    @contextmanager
    def function(
        self,
        name: str,
        inputs: Sequence[Type],
        results: Sequence[Type] = (),
        *,
        kernel: bool = False,
        lds_size: int | None = None,
        workgroup_size: Sequence[int] | None = None,
        attrs: Mapping[str, Attribute] | None = None,
    ) -> Iterator[FunctionBuilder]:
        """Generic ``func.func`` builder at module scope.

        When ``kernel=True`` the function is tagged with ``wave.kernel``
        so the Wave passes treat it as a kernel entry point. This
        intentionally does *not* wrap the function in a ``gpu.module``
        since some Wave tests want a free-standing kernel-shaped func.
        """
        op = func.FuncOp(name, (list(inputs), list(results)))
        if kernel:
            op.attributes["wave.kernel"] = UnitAttr.get()
        if lds_size is not None:
            op.attributes["wave.lds_size"] = i64_attr(lds_size)
        if workgroup_size is not None:
            attr = i32_array_attr(workgroup_size)
            op.attributes["wave.workgroup_size"] = attr
            op.attributes["gpu.known_block_size"] = attr
        if attrs is not None:
            for attr_name, attr in attrs.items():
                op.attributes[attr_name] = attr
        block = op.add_entry_block()
        with InsertionPoint(block):
            yield FunctionBuilder(block)
            func.ReturnOp([])

    @contextmanager
    def host_main(
        self,
        name: str = "main",
        inputs: Sequence[Type] = (),
        results: Sequence[Type] = (),
    ) -> Iterator[FunctionBuilder]:
        op = func.FuncOp(name, (list(inputs), list(results)))
        block = op.add_entry_block()
        with InsertionPoint(block):
            yield FunctionBuilder(block)
            func.ReturnOp([])

    def declare_external(
        self,
        name: str,
        inputs: Sequence[Type],
        results: Sequence[Type],
        *,
        emit_c_interface: bool = True,
    ) -> func.FuncOp:
        op = func.FuncOp(name, (list(inputs), list(results)), visibility="private")
        if emit_c_interface:
            op.attributes["llvm.emit_c_interface"] = UnitAttr.get()
        return op


class _GpuModuleBuilder:
    """Helper context that adds ``func.func`` ops into a ``gpu.module``."""

    def __init__(self, gpu_module: gpu.GPUModuleOp) -> None:
        self.gpu_module = gpu_module

    @contextmanager
    def kernel(
        self,
        name: str,
        inputs: Sequence[Type],
        results: Sequence[Type] = (),
        *,
        lds_size: int | None = None,
        workgroup_size: Sequence[int] | None = None,
        attrs: Mapping[str, Attribute] | None = None,
    ) -> Iterator[FunctionBuilder]:
        op = func.FuncOp(name, (list(inputs), list(results)))
        op.attributes["gpu.kernel"] = UnitAttr.get()
        op.attributes["wave.kernel"] = UnitAttr.get()
        if lds_size is not None:
            op.attributes["wave.lds_size"] = i64_attr(lds_size)
        if workgroup_size is not None:
            attr = i32_array_attr(workgroup_size)
            op.attributes["wave.workgroup_size"] = attr
            op.attributes["gpu.known_block_size"] = attr
        if attrs is not None:
            for attr_name, attr in attrs.items():
                op.attributes[attr_name] = attr
        block = op.add_entry_block()
        with InsertionPoint(block):
            yield FunctionBuilder(block)
            func.ReturnOp([])


class _WhereBuilder:
    def __init__(
        self,
        builder: FunctionBuilder,
        op: wave.WhereOp,
        result_types: Sequence[Type],
        then_block: Block,
    ) -> None:
        self.builder = builder
        self.op = op
        self.result_types = list(result_types)
        self.then_block = then_block
        self.else_block: Block | None = None

    def __getattr__(self, name: str) -> Any:
        return getattr(self.op, name)

    @contextmanager
    def otherwise(self) -> Iterator[_WhereBuilder]:
        if self.else_block is not None:
            raise RuntimeError("wave.where otherwise region already exists")
        self.else_block = self.op.elseRegion.blocks.append()
        with InsertionPoint(self.else_block):
            self.builder._yield_stack.append(_YieldKind.WAVE)
            try:
                yield self
                _finish_wave_region(self.else_block, self.result_types)
            finally:
                self.builder._yield_stack.pop()


class _IfBuilder:
    def __init__(
        self,
        builder: FunctionBuilder,
        op: scf.IfOp,
        result_types: Sequence[Type],
        has_else: bool,
    ) -> None:
        self.builder = builder
        self.op = op
        self.result_types = list(result_types)
        self.has_else = has_else
        self.else_entered = False

    def __getattr__(self, name: str) -> Any:
        return getattr(self.op, name)

    @contextmanager
    def otherwise(self) -> Iterator[_IfBuilder]:
        if not self.has_else:
            raise RuntimeError("scf.if was created without an else region")
        if self.else_entered:
            raise RuntimeError("scf.if else region already entered")
        self.else_entered = True
        with InsertionPoint(self.op.else_block):
            self.builder._yield_stack.append(_YieldKind.SCF)
            try:
                yield self
                _finish_scf_region(self.op.else_block, self.result_types)
            finally:
                self.builder._yield_stack.pop()


class FunctionBuilder:
    """Per-function helper that wires common arith / Wave / WaveAMD ops."""

    def __init__(self, block: Block) -> None:
        self.block = block
        self._yield_stack: list[_YieldKind] = []

    @property
    def args(self) -> Sequence[Value]:
        return list(self.block.arguments)

    # --- arith / index constants ------------------------------------------

    def constant(self, result_type: Type, value: int | float) -> Value:
        return arith.ConstantOp(result_type, value).result

    def index_cast(self, value: Value, result_type: Type) -> Value:
        return arith.IndexCastOp(result_type, value).result

    # --- Wave ops ----------------------------------------------------------

    def lane_id(self, element_type: Type | None = None, width: int = 32) -> Value:
        return wave.LaneIdOp(simd_type(element_type, width)).result

    def workgroup_id(self, axis: int = 0) -> Value:
        return wave.WorkgroupIdOp(i32(), axis).result

    def workitem_id(
        self, axis: int = 0, element_type: Type | None = None, width: int = 32
    ) -> Value:
        return wave.WorkitemIdOp(simd_type(element_type, width), axis).result

    def assume(
        self,
        value: Value,
        assumptions: Sequence[ixsimpl.Expr],
        *,
        name: str = "x",
    ) -> Value:
        """Identity at runtime; asserts ixsimpl predicates over `name`."""
        attrs = ArrayAttr.get([_pred_attr(pred) for pred in assumptions])
        return wave.AssumeOp(value.type, value, name, attrs).result

    def assume_range(self, value: Value, lo: int, hi: int) -> Value:
        """Identity at runtime; asserts `lo <= value <= hi`."""
        x = sym_ctx.sym("x")
        return self.assume(value, [x >= lo, x <= hi], name="x")

    def assume_divisible(self, value: Value, divisor: int) -> Value:
        """Identity at runtime; asserts `value % divisor == 0`."""
        x = sym_ctx.sym("x")
        return self.assume(value, [sym_ctx.eq(x % divisor, 0)], name="x")

    def splat(
        self, value: Value, element_type: Type | None = None, width: int = 32
    ) -> Value:
        return wave.SplatOp(simd_type(element_type or value.type, width), value).result

    def binary(
        self,
        kind: object,
        lhs: Value,
        rhs: Value,
        *,
        nsw: bool = False,
        nuw: bool = False,
    ) -> Value:
        overflow_flags = _overflow_flags_attr(nsw, nuw)
        result_type = _arith_result_type(lhs, rhs)
        if overflow_flags is None:
            return wave.BinaryOp(result_type, kind, lhs, rhs).result
        return wave.BinaryOp(
            result_type,
            kind,
            lhs,
            rhs,
            overflowFlags=overflow_flags,
        ).result

    def cast(
        self,
        source: Value,
        result_type: Type,
        kind: object = CastKind.FpConvert,
        *,
        policy: Attribute | None = None,
    ) -> Value:
        return wave.CastOp(result_type, kind, source, policy=policy).result

    def fpconvert(self, source: Value, result_type: Type) -> Value:
        return self.cast(source, result_type, CastKind.FpConvert)

    def select(self, condition: Value, true_value: Value, false_value: Value) -> Value:
        return wave.SelectOp(true_value.type, condition, true_value, false_value).result

    def cmpi(
        self,
        predicate: CmpIPredicate | str,
        lhs: Value,
        rhs: Value,
    ) -> Value:
        """Emit `wave.cmpi`; result mask width tracks the SIMD operand width."""
        if isinstance(predicate, str):
            predicate = CmpIPredicate[predicate]
        width = SimdType(lhs.type).width
        return wave.CmpIOp(mask_type(width), predicate, lhs, rhs).result

    def cmpf(
        self,
        predicate: CmpFPredicate | str,
        lhs: Value,
        rhs: Value,
    ) -> Value:
        """Emit `wave.cmpf`; result mask width tracks the SIMD operands."""
        if isinstance(predicate, str):
            predicate = CmpFPredicate[predicate.upper()]
        width = SimdType(lhs.type).width
        return wave.CmpFOp(mask_type(width), predicate, lhs, rhs).result

    def ballot(self, mask: Value, result_type: Type | None = None) -> Value:
        """Materialize `!wave.mask<W>` as integer bits via `wave.ballot`."""
        result_type = result_type or IntegerType.get_signless(32)
        return wave.BallotOp(result_type, mask).result

    def read_first(self, value: Value, result_type: Type | None = None) -> Value:
        """`wave.read_first` -- broadcast the first active lane to uniform."""
        if result_type is None:
            simd = SimdType(value.type)
            result_type = simd.element_type
        return wave.ReadFirstOp(result_type, value).result

    @contextmanager
    def if_(
        self,
        condition: Value,
        result_types: Sequence[Type] = (),
        *,
        otherwise: bool = False,
    ) -> Iterator[_IfBuilder]:
        if result_types and not otherwise:
            raise ValueError("result-bearing scf.if requires otherwise=True")
        op = scf.IfOp(condition, list(result_types), has_else=otherwise)
        if_builder = _IfBuilder(self, op, result_types, otherwise)
        with InsertionPoint(op.then_block):
            self._yield_stack.append(_YieldKind.SCF)
            try:
                yield if_builder
                _finish_scf_region(op.then_block, result_types)
            finally:
                self._yield_stack.pop()
        if otherwise and not if_builder.else_entered:
            with InsertionPoint(op.else_block):
                _finish_scf_region(op.else_block, result_types)

    @contextmanager
    def where(
        self,
        condition: Value | Sequence[Value],
        result_types: Sequence[Type] = (),
    ) -> Iterator[_WhereBuilder]:
        """Open `wave.where`; call `.otherwise()` for the else arm."""
        conditions = [condition] if isinstance(condition, Value) else list(condition)
        op = wave.WhereOp(list(result_types), conditions)
        block = op.thenRegion.blocks.append()
        where_builder = _WhereBuilder(self, op, result_types, block)
        with InsertionPoint(block):
            self._yield_stack.append(_YieldKind.WAVE)
            try:
                yield where_builder
                _finish_wave_region(block, result_types)
            finally:
                self._yield_stack.pop()

    def addi(
        self, lhs: Value, rhs: Value, *, nsw: bool = False, nuw: bool = False
    ) -> Value:
        return self.binary(BinaryKind.AddI, lhs, rhs, nsw=nsw, nuw=nuw)

    def subi(
        self, lhs: Value, rhs: Value, *, nsw: bool = False, nuw: bool = False
    ) -> Value:
        return self.binary(BinaryKind.SubI, lhs, rhs, nsw=nsw, nuw=nuw)

    def muli(
        self, lhs: Value, rhs: Value, *, nsw: bool = False, nuw: bool = False
    ) -> Value:
        return self.binary(BinaryKind.MulI, lhs, rhs, nsw=nsw, nuw=nuw)

    def shli(
        self, lhs: Value, rhs: Value, *, nsw: bool = False, nuw: bool = False
    ) -> Value:
        return self.binary(BinaryKind.ShLI, lhs, rhs, nsw=nsw, nuw=nuw)

    def fadd(self, lhs: Value, rhs: Value) -> Value:
        return wave.FAddOp(lhs.type, lhs, rhs).result

    def fsub(self, lhs: Value, rhs: Value) -> Value:
        return wave.FSubOp(lhs.type, lhs, rhs).result

    def fmul(self, lhs: Value, rhs: Value) -> Value:
        return wave.FMulOp(lhs.type, lhs, rhs).result

    def fmax(self, lhs: Value, rhs: Value) -> Value:
        return wave.FMaxOp(lhs.type, lhs, rhs).result

    def fexp2(self, value: Value) -> Value:
        return wave.FExp2Op(value.type, value).result

    def frcp(self, value: Value) -> Value:
        return wave.FRcpOp(value.type, value).result

    def index_expr(
        self,
        expr: ixsimpl.Expr,
        bindings: Mapping[ixsimpl.Expr, Value] | None = None,
        assumptions: Sequence[ixsimpl.Expr] | None = None,
        result_type: Type | None = None,
    ) -> Value:
        """Build a `wave.index_expr` from a symbolic expression.

        `expr` is an :class:`ixsimpl.Expr` built via the module-level
        :data:`sym_ctx`; `bindings` maps the symbol leaves used in
        `expr` (the :class:`ixsimpl.Expr` objects returned by
        :func:`sym`) to their per-kernel :class:`mlir.ir.Value`
        operand. Keying on the symbol object itself keeps the
        Python-side data model fully structural -- no string names
        crossing between the expression builder and the binding map.

        The dialect imports `expr.node_ptr` into its own symbol store.
        Bindings are filtered to actual free symbols, so callers can pass a
        superset without tracking which symbols simplification dropped.

        When `result_type` is omitted the lane width is inferred from
        the binding operand types: lane-varying bindings produce
        `!wave.simd<index, W>`, otherwise the result is builtin
        `index`.
        """
        filtered = _index_expr_bindings(expr, bindings)
        result_type = _index_expr_result_type_from_bindings(filtered, result_type)
        expr_attr = ExprAttr.get_from_node_ptr(
            _ixsimpl_node_ptr(expr), context=_current_context()
        )
        names_attr = ArrayAttr.get([StringAttr.get(n) for n in filtered])
        return wave.IndexExprOp(
            result_type,
            expr_attr,
            names_attr,
            list(filtered.values()),
            assumptions=_index_expr_assumptions_attr(assumptions),
        ).result

    def gather(
        self,
        bases: Value | Sequence[Value],
        result_type: Type,
        *,
        bit_offset: ixsimpl.Expr,
        bindings: Mapping[ixsimpl.Expr, Value] | None = None,
        packet_bindings: Mapping[ixsimpl.Expr, Value | Sequence[Value]] | None = None,
        base: ixsimpl.Expr | None = None,
        target_block: ixsimpl.Expr | None = None,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> tuple[Value, Value]:
        """Build target-neutral symbolic packet gather."""
        mapping, scalar_values, packet_values = _memory_mapping_parts(
            bit_offset, base, target_block, bindings, packet_bindings
        )
        packet_names, packet_operands = _flatten_packet_mapping_values(packet_values)
        sources = [bases] if isinstance(bases, Value) else list(bases)
        op = wave.GatherOp(
            result_type,
            mem_token_type(),
            sources,
            list(scalar_values.values()),
            packet_operands,
            mapping,
            dependency=after,
            binding_names=list(scalar_values),
            packet_binding_names=packet_names,
            cache=cache,
        )
        return op.value, op.token

    def scatter(
        self,
        value: Value,
        bases: Value | Sequence[Value],
        *,
        bit_offset: ixsimpl.Expr,
        bindings: Mapping[ixsimpl.Expr, Value] | None = None,
        packet_bindings: Mapping[ixsimpl.Expr, Value | Sequence[Value]] | None = None,
        base: ixsimpl.Expr | None = None,
        target_block: ixsimpl.Expr | None = None,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> Value:
        """Build target-neutral symbolic packet scatter."""
        mapping, scalar_values, packet_values = _memory_mapping_parts(
            bit_offset, base, target_block, bindings, packet_bindings
        )
        packet_names, packet_operands = _flatten_packet_mapping_values(packet_values)
        destinations = [bases] if isinstance(bases, Value) else list(bases)
        return wave.ScatterOp(
            mem_token_type(),
            value,
            destinations,
            list(scalar_values.values()),
            packet_operands,
            mapping,
            dependency=after,
            binding_names=list(scalar_values),
            packet_binding_names=packet_names,
            cache=cache,
        ).token

    def redistribute(
        self,
        source: Value,
        result_type: Type,
        *,
        items: int,
        source_item: ixsimpl.Expr,
        source_slot: ixsimpl.Expr,
        blocks: int = 1,
        source_block: ixsimpl.Expr | None = None,
    ) -> Value:
        """Build symbolic cluster packet redistribution."""
        if source_block is None:
            source_block = sym("block")
        block_attr = ExprAttr.get_from_node_ptr(
            _ixsimpl_node_ptr(source_block), context=_current_context()
        )
        item_attr = ExprAttr.get_from_node_ptr(
            _ixsimpl_node_ptr(source_item), context=_current_context()
        )
        slot_attr = ExprAttr.get_from_node_ptr(
            _ixsimpl_node_ptr(source_slot), context=_current_context()
        )
        relation = RedistributionAttr.get(
            blocks, items, block_attr, item_attr, slot_attr
        )
        return wave.RedistributeOp(result_type, source, relation).result

    def ptr_add(
        self, base: Value, offset: Value, result_type: Type | None = None
    ) -> Value:
        if result_type is None:
            base_simd = SimdType.isinstance(base.type)
            offset_width = _lane_width(offset.type)
            if base_simd:
                result_type = base.type
            elif offset_width:
                result_type = simd_type(base.type, offset_width)
            else:
                result_type = base.type
        return wave.PtrAddOp(result_type, base, offset).result

    def ptr_cast(self, source: Value, result_type: Type) -> Value:
        return wave.PtrCastOp(result_type, source).result

    def store(
        self,
        value: Value,
        ptr: Value,
        *,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> Value:
        return wave.StoreOp(
            mem_token_type(), value, ptr, dependency=after, cache=cache
        ).token

    def load(
        self,
        ptr: Value,
        result_type: Type,
        *,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> tuple[Value, Value]:
        """Emit ``wave.load`` and return ``(value, token)``.

        ``result_type`` is the SIMD result type and is what drives the
        lowering: a plain ``!wave.simd<T, W>`` produces a single per-lane
        dword load; a ``!wave.simd<vector<R x T>, W>`` produces ``R``
        consecutive dword loads merged into one VGPR tuple.
        """
        op = wave.LoadOp(
            result_type, mem_token_type(), ptr, dependency=after, cache=cache
        )
        return op.value, op.token

    def token(self) -> Value:
        return wave.TokenOp(mem_token_type()).result

    def issue_token(self, *tokens: Value) -> Value:
        """Keep issue ordering without carrying completion."""
        return wave.IssueTokenOp(mem_token_type(), list(tokens)).result

    def sched_barrier(self) -> None:
        """Cut greedy machine scheduling at this point."""
        wave.SchedBarrierOp()

    def after(self, *tokens: Value) -> Value:
        return wave.AfterOp(mem_token_type(), list(tokens)).result

    def join(self, *tokens: Value) -> Value:
        return wave.JoinOp(mem_token_type(), list(tokens)).result

    def shared_memory_base(
        self,
        element_type: Type | None = None,
        *,
        offset: int = 0,
    ) -> Value:
        """Return a pointer to the start of workgroup shared memory.

        ``element_type`` defaults to ``i32``; the byte offset into the
        memory (``offset``) defaults to 0. Combine with ``ptr_add`` to
        materialize per-lane addresses, or with a uniform offset to
        partition shared memory.
        """
        ty = ptr_type(element_type or i32(), shared_address_space())
        return wave.SharedMemoryBaseOp(ty, offset=offset).result

    def workgroup_alloc(
        self,
        bytesize: int,
        align: int,
        element_type: Type | None = None,
    ) -> Value:
        """Emit ``wave.alloc``."""
        ty = ptr_type(element_type or i32(), shared_address_space())
        return wave.AllocOp(ty, bytesize=bytesize, align=align).result

    def release_alloc(self, allocation: Value, *, after: Value) -> Value:
        """End a ``wave.alloc`` lifetime after a memory dependency."""
        return wave.AllocReleaseOp(mem_token_type(), allocation, after).token

    def barrier(self, *dependencies: Value) -> Value:
        """Emit a workgroup-wide barrier sequenced after ``dependencies``."""
        return wave.BarrierOp(mem_token_type(), list(dependencies)).token

    # --- WaveAMD ops -------------------------------------------------------

    def set_priority(self, priority: int) -> None:
        """Set hardware issue priority for the current wave."""
        waveamd.SetPriorityOp(priority)

    def dma_load_lds(
        self,
        source: Value,
        dest: Value,
        *,
        after: Value,
        bytes: int = 4,
        aux: int = 0,
        zero_fill_inactive: bool = False,
        issue_delay_cycles: int | None = None,
        issue_delay_overlap_cycles: int | None = None,
        issue_delay_skip_thread_threshold: int | None = None,
    ) -> Value:
        op = waveamd.DmaLoadLdsOp(
            mem_token_type(),
            source,
            dest,
            after,
            bytes=bytes,
            aux=aux,
            zero_fill_inactive=zero_fill_inactive,
            issue_delay_cycles=issue_delay_cycles,
            issue_delay_overlap_cycles=issue_delay_overlap_cycles,
            issue_delay_skip_thread_threshold=issue_delay_skip_thread_threshold,
        )
        return op.token

    def transpose_load(
        self,
        source: Value,
        result_type: Type | None = None,
        *,
        after: Value | None = None,
    ) -> tuple[Value, Value]:
        result_type = result_type or simd_type(vector_type(8, i8()), width=64)
        op = waveamd.TransposeLoadOp(
            result_type, mem_token_type(), source, dependency=after
        )
        return op.value, op.token

    def fragment_fill(self, value: Value, frag_type: Type) -> Value:
        return waveamd.FragmentFillOp(frag_type, value).result

    def fragment_pack(self, registers: Value, frag_type: Type) -> Value:
        """Bind a SIMD-of-vector value into a WMMA fragment.

        ``registers`` must be ``!wave.simd<vector<R x T>, W>`` where ``R``
        equals the fragment's per-lane register count and ``T`` is 32 bits
        wide; ``W`` must match the fragment wave size. The op is a
        zero-cost rename in the AMDGPU lowering (no instructions
        emitted): the same VGPR tuple becomes the fragment.
        """
        return waveamd.FragmentPackOp(frag_type, registers).result

    def fragment_unpack(self, fragment: Value) -> Value:
        """Expose a WMMA fragment as a SIMD-of-vector register tuple.

        Inverse rename for :meth:`fragment_pack`: surfaces a
        ``!waveamd.fragment<role, T, M, N, W, R>`` as
        ``!wave.simd<vector<R x i32>, W>`` so the per-lane VGPR tuple
        can flow through generic wave plumbing (e.g. ``wave.store``)
        without a dedicated fragment-store op. Zero-cost at the
        WaveAMDMachine level.
        """
        frag = FragmentType(fragment.type)
        result_type = simd_type(
            vector_type(frag.registers, i32()), width=frag.wave_size
        )
        return waveamd.FragmentUnpackOp(result_type, fragment).result

    def fragment_load(
        self,
        ptr: Value,
        frag_type: Type,
        *,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> tuple[Value, Value]:
        """Load a fragment by stitching a tuple ``wave.load`` and pack.

        ``ptr`` must already encode the per-lane base address (typically
        a ``!wave.simd<!wave.ptr<space, T>, W>`` produced by
        ``ptr_add`` of a uniform base and a lane-varying offset). The
        helper widens the load to the fragment's register count and
        threads the resulting memory token back to the caller so it can
        be chained into a subsequent ``mma`` or store.

        Returns ``(fragment, token)``.
        """
        frag = FragmentType(frag_type)
        load_type = simd_type(vector_type(frag.registers, i32()), width=frag.wave_size)
        regs, token = self.load(ptr, load_type, after=after, cache=cache)
        return self.fragment_pack(regs, frag_type), token

    def mma(self, kind: str, a: Value, b: Value, acc: Value) -> Value:
        return waveamd.MmaOp(acc.type, kind, a, b, acc).result

    def mma_scale(
        self,
        kind: str,
        a: Value,
        a_scale: Value,
        b: Value,
        b_scale: Value,
        acc: Value,
        *,
        scale_idx_a: int = 0,
        scale_idx_b: int = 0,
    ) -> Value:
        return waveamd.MmaScaleOp(
            acc.type,
            kind,
            a,
            a_scale,
            b,
            b_scale,
            acc,
            scale_idx_a=scale_idx_a,
            scale_idx_b=scale_idx_b,
        ).result

    def fragment_store(
        self,
        fragment: Value,
        ptr: Value,
        *,
        after: Value | None = None,
        cache: Attribute | None = None,
    ) -> Value:
        """Symmetric to :meth:`fragment_load`: unpack the fragment and
        store the resulting per-lane R-dword tuple via ``wave.store``.

        ``ptr`` must address lane 0's slot of the fragment row (the
        lane-`L` slot lives at ``ptr + L * R`` in element units of the
        pointer). The helper layers on the per-lane ``lane * R``
        offset where ``lane = workitem_id_x mod wave_size`` (single
        ``v_lshrrev`` / ``v_and`` pair on AMDGPU since both ``R`` and
        ``wave_size`` are powers of two), passes the result through a
        ``wave.index_expr`` so address planning folds the per-element
        scale into a single shift, and emits a tuple ``wave.store``.
        The WaveAMDMachine backend serializes that into ``R`` per-component
        ``*_store_tuple_b32`` ops.
        """
        frag = FragmentType(fragment.type)
        wi_sym = sym("__wave_dsl_frag_wi")
        wi_val = self.workitem_id(axis=0, width=frag.wave_size)
        lane_off = self.index_expr(
            mod(wi_sym, frag.wave_size) * frag.registers,
            {wi_sym: wi_val},
        )
        tuple_ptr = self.ptr_add(ptr, lane_off)
        regs = self.fragment_unpack(fragment)
        return self.store(regs, tuple_ptr, after=after, cache=cache)

    def make_buffer(
        self,
        base: Value,
        range_bytes: Value,
        result_type: Type | None = None,
    ) -> Value:
        return waveamd.MakeBufferOp(
            result_type or buffer_ptr_type(), base, range_bytes
        ).result

    # --- memref / scf helpers ---------------------------------------------

    def alloc(self, shape: Sequence[int], element_type: Type) -> Value:
        return memref.AllocOp(MemRefType.get(list(shape), element_type), [], []).result

    def memref_store(self, value: Value, buf: Value, indices: Sequence[Value]) -> None:
        memref.StoreOp(value, buf, list(indices))

    def cast_unranked(self, buf: Value) -> Value:
        return memref.CastOp(unranked_memref_type(buf.type.element_type), buf).result

    def memref_cast(self, buf: Value, result_type: Type) -> Value:
        return memref.CastOp(result_type, buf).result

    def static_param(self, name: str, ty: Type) -> Value:
        """`wavemeta.param "name" : T` -- a typed SSA value bound by the
        specialiser via the module's `wavemeta.params` dict.
        """
        return wavemeta.ParamOp(ty, name).result

    @contextmanager
    def static_for(
        self,
        lower: Value,
        upper: Value,
        step: Value,
        init_args: Sequence[Value] = (),
    ) -> Iterator[wavemeta.StaticForOp]:
        """`wavemeta.static_for` shaped like `scf.for`. Bounds must be
        `index`; the specialiser unrolls the loop once they fold to
        constants. The caller emits the body and a `wavemeta.YieldOp`.
        Yields the op so callers can reach for `induction_variable`,
        `inner_iter_args`, and (post-`with`) `results`.
        """
        op = wavemeta.StaticForOp(lower, upper, step, init_args)
        with InsertionPoint(op.body_block):
            self._yield_stack.append(_YieldKind.WAVEMETA)
            try:
                yield op
            finally:
                self._yield_stack.pop()

    @contextmanager
    def for_loop(
        self,
        lower: Value,
        upper: Value,
        step: Value,
        init_args: Sequence[Value] = (),
        nonzero_trip: bool = False,
        unroll: int | Value | None = None,
    ) -> Iterator[Value]:
        """Yield an `scf.for`'s induction variable inside a context
        manager (no carries) or the `scf.ForOp` itself when `init_args`
        is non-empty.

        When `init_args` is empty (the historical contract) the helper
        yields a bare induction variable and emits an empty `scf.yield`
        on context exit.

        When `init_args` is non-empty the helper yields the underlying
        `scf.ForOp` so the caller can access `forop.induction_variable`,
        `forop.inner_iter_args`, and (after the `with` exits)
        `forop.results`. The caller is responsible for emitting
        `bld.yield_(...)` with next-iteration carry values.

        `nonzero_trip=True` attaches a `wave.nonzero_trip` unit attr on
        the `scf.for`, which the selector uses to skip the pre-test
        compare and lower to a do/while-shaped `waveamdmachine.uniform_loop`
        instead of the (potentially-zero-trip) pre-tested form.

        `unroll=N` emits `wavemeta.unrolled_for`; specialization expands it
        into an unrolled main loop plus scalar tail.
        """
        if unroll is not None:
            if nonzero_trip:
                raise ValueError("nonzero_trip is not supported with unroll")
            if isinstance(unroll, int):
                unroll = self.constant(lower.type, unroll)
            forop = wavemeta.UnrolledForOp(
                lower, upper, step, unroll, iter_args=list(init_args)
            )
            with InsertionPoint(forop.body_block):
                self._yield_stack.append(_YieldKind.WAVEMETA)
                try:
                    if init_args:
                        yield forop
                    else:
                        yield forop.induction_variable
                        self.yield_()
                finally:
                    self._yield_stack.pop()
            return

        forop = scf.ForOp(lower, upper, step, iter_args=list(init_args))
        if nonzero_trip:
            forop.operation.attributes["wave.nonzero_trip"] = UnitAttr.get()
        with InsertionPoint(forop.body):
            self._yield_stack.append(_YieldKind.SCF)
            try:
                if init_args:
                    yield forop
                else:
                    yield forop.induction_variable
                    self.yield_()
            finally:
                self._yield_stack.pop()

    def yield_(self, values: Sequence[Value] = ()) -> None:
        if self._yield_stack and self._yield_stack[-1] is _YieldKind.WAVE:
            wave.YieldOp(list(values))
            return
        if self._yield_stack and self._yield_stack[-1] is _YieldKind.WAVEMETA:
            wavemeta.YieldOp(list(values))
            return
        scf.YieldOp(list(values))

    def call(
        self,
        callee: str | func.FuncOp,
        arguments: Sequence[Value],
        result_types: Sequence[Type] = (),
    ) -> list[Value]:
        if isinstance(callee, func.FuncOp):
            return list(func.CallOp(callee, list(arguments)).results)
        return list(func.CallOp(list(result_types), callee, list(arguments)).results)

    def launch(
        self,
        gpu_module: str,
        kernel: str,
        grid: tuple[Value, Value, Value],
        block: tuple[Value, Value, Value],
        operands: Sequence[Value] = (),
        dynamic_shared_memory_size: Value | None = None,
    ) -> None:
        gpu.LaunchFuncOp(
            kernel=[gpu_module, kernel],
            grid_size=grid,
            block_size=block,
            kernel_operands=list(operands),
            dynamic_shared_memory_size=dynamic_shared_memory_size,
        )

    def host_register(self, unranked_ref: Value) -> None:
        gpu.HostRegisterOp(unranked_ref)


def module() -> ModuleBuilder:
    return ModuleBuilder()


__all__ = [
    "BF16Type",
    "BinaryKind",
    "BufferAddressSpaceAttr",
    "CastKind",
    "CmpIPredicate",
    "Expr",
    "ExprAttr",
    "F16Type",
    "F32Type",
    "FragmentType",
    "FunctionBuilder",
    "GlobalAddressSpaceAttr",
    "IndexType",
    "IntegerType",
    "LoadCacheAttr",
    "MaskType",
    "MemRefType",
    "MemTokenType",
    "MemoryMappingAttr",
    "ModuleBuilder",
    "PredAttr",
    "PrivateAddressSpaceAttr",
    "PtrType",
    "RedistributionAttr",
    "SharedAddressSpaceAttr",
    "SimdType",
    "StoreCacheAttr",
    "bf16",
    "buffer_address_space",
    "buffer_ptr_type",
    "ceil",
    "f16",
    "f32",
    "floor",
    "fragment_type",
    "global_address_space",
    "i8",
    "i32",
    "index_type",
    "load_cache",
    "mask_type",
    "mem_token_type",
    "mod",
    "module",
    "opaque_buffer_ptr_type",
    "opaque_ptr_type",
    "private_address_space",
    "ptr_type",
    "shared_address_space",
    "simd_ptr_type",
    "simd_type",
    "store_cache",
    "sym",
    "sym_ctx",
    "unranked_memref_type",
    "vector_type",
]
