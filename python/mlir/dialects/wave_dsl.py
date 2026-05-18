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
from types import TracebackType

import ixsimpl
from mlir._mlir_libs._waveDialectsNanobind import (
    BufferAddressSpaceAttr,
    ExprAttr,
    FragmentType,
    GlobalAddressSpaceAttr,
    MaskType,
    MemTokenType,
    PrivateAddressSpaceAttr,
    PtrType,
    SharedAddressSpaceAttr,
    SimdType,
    WaveIndexType,
    register_dialects,
)
from mlir.dialects import arith, func, gpu, memref, scf, wave, waveamd
from mlir.ir import (
    ArrayAttr,
    Attribute,
    Block,
    Context,
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

# Process-wide ixsimpl context for symbolic offset expressions. The DSL
# hands callers symbols / literals out of this context and the
# `index_expr` builder structurally imports the resulting `Expr` into the
# Wave dialect's per-MLIRContext symbol store at the FFI boundary.
# Sharing one Python-side context across the process keeps symbol
# identity stable (e.g. `sym("lane")` is the same node for every kernel
# in this interpreter), which the bucketizer's hash-consed equality
# relies on.
sym_ctx: ixsimpl.Context = ixsimpl.Context()


def sym(name: str) -> ixsimpl.Expr:
    """Return the `sym_ctx`-rooted symbol leaf with this name."""
    return sym_ctx.sym(name)


# ---------------------------------------------------------------------------
# Type helpers
# ---------------------------------------------------------------------------


def i8() -> IntegerType:
    return IntegerType.get_signless(8)


def i32() -> IntegerType:
    return IntegerType.get_signless(32)


def i64() -> IntegerType:
    return IntegerType.get_signless(64)


def i64_attr(value: int) -> IntegerAttr:
    return IntegerAttr.get(i64(), value)


def f16() -> F16Type:
    return F16Type.get()


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


def wave_index_type(width: int = 0) -> Type:
    """Build a `!wave.index` value type.

    `width=0` is the uniform (scalar) form. A non-zero `width` denotes the
    lane-varying form: one per-lane element across a subgroup of that
    width.
    """
    return WaveIndexType.get(width=width, context=_current_context())


def global_address_space() -> Attribute:
    return GlobalAddressSpaceAttr.get(context=_current_context())


def shared_address_space() -> Attribute:
    return SharedAddressSpaceAttr.get(context=_current_context())


def private_address_space() -> Attribute:
    return PrivateAddressSpaceAttr.get(context=_current_context())


def buffer_address_space() -> Attribute:
    return BufferAddressSpaceAttr.get(context=_current_context())


def ptr_type(
    element_type: Type | None = None,
    address_space: Attribute | None = None,
) -> Type:
    return PtrType.get(element_type or i32(), address_space or global_address_space())


def buffer_ptr_type(element_type: Type | None = None) -> Type:
    return ptr_type(element_type, buffer_address_space())


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
    """Infer the result type for `wave.addi`/`muli`/`shli`.

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


def _binding_lane_width(values: Iterable[Value]) -> int:
    """Reduce binding operand types to a single non-zero lane width.

    Uniform operands (`index`, signless int, uniform `!wave.index`)
    contribute zero. Lane-varying operands (`!wave.simd<i32, W>`,
    `!wave.index<W>`) must agree on `W`.
    """
    lane = 0
    for v in values:
        ty = v.type
        if SimdType.isinstance(ty):
            width = SimdType(ty).width
        elif WaveIndexType.isinstance(ty):
            width = WaveIndexType(ty).width
        else:
            width = 0
        if width == 0:
            continue
        if lane and lane != width:
            raise ValueError(
                f"conflicting lane-varying binding widths: {lane} vs {width}"
            )
        lane = width
    return lane


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
    ) -> Iterator[FunctionBuilder]:
        op = func.FuncOp(name, (list(inputs), list(results)))
        op.attributes["gpu.kernel"] = UnitAttr.get()
        op.attributes["wave.kernel"] = UnitAttr.get()
        if lds_size is not None:
            op.attributes["wave.lds_size"] = i64_attr(lds_size)
        block = op.add_entry_block()
        with InsertionPoint(block):
            yield FunctionBuilder(block)
            func.ReturnOp([])


class FunctionBuilder:
    """Per-function helper that wires common arith / Wave / WaveAMD ops."""

    def __init__(self, block: Block) -> None:
        self.block = block

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

    def splat(
        self, value: Value, element_type: Type | None = None, width: int = 32
    ) -> Value:
        return wave.SplatOp(simd_type(element_type or value.type, width), value).result

    def binary(self, kind: str, lhs: Value, rhs: Value) -> Value:
        return wave.BinaryOp(lhs.type, kind, lhs, rhs).result

    def addi(self, lhs: Value, rhs: Value) -> Value:
        return wave.AddiOp(_arith_result_type(lhs, rhs), lhs, rhs).result

    def muli(self, lhs: Value, rhs: Value) -> Value:
        return wave.MuliOp(_arith_result_type(lhs, rhs), lhs, rhs).result

    def shli(self, lhs: Value, rhs: Value) -> Value:
        return wave.ShliOp(_arith_result_type(lhs, rhs), lhs, rhs).result

    def index_expr(
        self,
        expr: ixsimpl.Expr,
        bindings: Mapping[str, Value] | None = None,
        result_type: Type | None = None,
    ) -> Value:
        """Build a `wave.index_expr` from a symbolic expression.

        `expr` is an :class:`ixsimpl.Expr` built via the module-level
        :data:`sym_ctx`. We hand the dialect the canonical binary
        serialization (`sym_ctx.serialize(expr)`) which it deserializes
        into its own symbol store -- the structural bridge ixsimpl
        documents for cross-context transfer, with no text on the FFI
        path. Each free symbol must appear as a key in `bindings`;
        conversely every binding name must be a free symbol.

        When `result_type` is omitted the lane width is inferred from
        the binding operand types: a `!wave.simd<i32, W>` or
        `!wave.index<W>` binding pins the result to `!wave.index<W>`;
        otherwise the result is the uniform `!wave.index`.
        """
        bindings = dict(bindings or {})
        if result_type is None:
            result_type = wave_index_type(_binding_lane_width(bindings.values()))
        expr_attr = ExprAttr.get_from_bytes(
            sym_ctx.serialize(expr), context=_current_context()
        )
        names_attr = ArrayAttr.get([StringAttr.get(n) for n in bindings])
        return wave.IndexExprOp(
            result_type, expr_attr, names_attr, list(bindings.values())
        ).result

    def ptr_add(
        self, base: Value, offset: Value, result_type: Type | None = None
    ) -> Value:
        if result_type is None:
            # Mirror the verifier: a SIMD-of-pointer result is required
            # whenever the base or offset is lane-varying. `!wave.simd<>`
            # is the obvious carrier; `!wave.index<W>` (the offset that
            # `wave.index_expr` produces) is the same lane-varying
            # contract on the index side, so it forces a SIMD result
            # too. We peek at the type names to stay decoupled from the
            # `wave` dialect Python type hierarchy.
            base_ty = str(base.type)
            off_ty = str(offset.type)
            base_simd = base_ty.startswith("!wave.simd<")
            off_lane_varying = off_ty.startswith(("!wave.simd<", "!wave.index<"))
            if base_simd or off_lane_varying:
                if base_simd:
                    result_type = base.type
                else:
                    result_type = Type.parse(f"!wave.simd<{base_ty}, 32>")
            else:
                result_type = base.type
        return wave.PtrAddOp(result_type, base, offset).result

    def store(self, value: Value, ptr: Value, *, after: Value | None = None) -> Value:
        return wave.StoreOp(mem_token_type(), value, ptr, dependency=after).token

    def load(
        self,
        ptr: Value,
        result_type: Type,
        *,
        after: Value | None = None,
    ) -> tuple[Value, Value]:
        """Emit ``wave.load`` and return ``(value, token)``.

        ``result_type`` is the SIMD result type and is what drives the
        lowering: a plain ``!wave.simd<T, W>`` produces a single per-lane
        dword load; a ``!wave.simd<vector<R x T>, W>`` produces ``R``
        consecutive dword loads merged into one VGPR tuple.
        """
        op = wave.LoadOp(result_type, mem_token_type(), ptr, dependency=after)
        return op.value, op.token

    def wait(self, *tokens: Value) -> None:
        wave.WaitOp(list(tokens))

    def token(self) -> Value:
        return wave.TokenOp(mem_token_type()).result

    def after(self, *tokens: Value) -> Value:
        return wave.AfterOp(mem_token_type(), list(tokens)).result

    def join(self, *tokens: Value) -> Value:
        return wave.JoinOp(mem_token_type(), list(tokens)).result

    def lds_base(
        self,
        element_type: Type | None = None,
        *,
        offset: int = 0,
    ) -> Value:
        """Return a pointer to the start of the workgroup's LDS arena.

        ``element_type`` defaults to ``i32``; the byte offset into the
        arena (``offset``) defaults to 0. Combine with ``ptr_add`` to
        materialize per-lane addresses, or with a uniform offset to
        partition the arena.
        """
        ty = ptr_type(element_type or i32(), shared_address_space())
        return wave.LdsBaseOp(ty, offset=offset).result

    def barrier(self, *dependencies: Value) -> Value:
        """Emit a workgroup-wide barrier sequenced after ``dependencies``."""
        return wave.BarrierOp(mem_token_type(), list(dependencies)).token

    # --- WaveAMD ops -------------------------------------------------------

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

    def fragment_load(
        self,
        ptr: Value,
        frag_type: Type,
        *,
        after: Value | None = None,
    ) -> tuple[Value, Value]:
        """Load a fragment by stitching a tuple ``wave.load`` and pack.

        ``ptr`` must already encode the per-lane base address (typically
        a ``!wave.simd<!wave.ptr<T, space>, W>`` produced by
        ``ptr_add`` of a uniform base and a lane-varying offset). The
        helper widens the load to the fragment's register count and
        threads the resulting memory token back to the caller so it can
        be chained into a subsequent ``mma`` or store.

        Returns ``(fragment, token)``.
        """
        frag = FragmentType(frag_type)
        load_type = simd_type(vector_type(frag.registers, i32()), width=frag.wave_size)
        regs, token = self.load(ptr, load_type, after=after)
        return self.fragment_pack(regs, frag_type), token

    def mma(self, kind: str, a: Value, b: Value, acc: Value) -> Value:
        return waveamd.MmaOp(acc.type, kind, a, b, acc).result

    def fragment_store(
        self, fragment: Value, ptr: Value, *, after: Value | None = None
    ) -> Value:
        return waveamd.FragmentStoreOp(
            mem_token_type(), fragment, ptr, dependency=after
        ).token

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

    @contextmanager
    def for_loop(
        self,
        lower: Value,
        upper: Value,
        step: Value,
        init_args: Sequence[Value] = (),
        nonzero_trip: bool = False,
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
        `forop.results`. The caller is responsible for emitting an
        `scf.yield` with the next-iteration carry values.

        `nonzero_trip=True` attaches a `wave.nonzero_trip` unit attr on
        the `scf.for`, which the selector uses to skip the pre-test
        compare and lower to a do/while-shaped `wavemachine.uniform_loop`
        instead of the (potentially-zero-trip) pre-tested form.
        """
        forop = scf.ForOp(lower, upper, step, iter_args=list(init_args))
        if nonzero_trip:
            forop.operation.attributes["wave.nonzero_trip"] = UnitAttr.get()
        with InsertionPoint(forop.body):
            if init_args:
                yield forop
            else:
                yield forop.induction_variable
                scf.YieldOp([])

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
    ) -> None:
        gpu.LaunchFuncOp(
            kernel=[gpu_module, kernel],
            grid_size=grid,
            block_size=block,
            kernel_operands=list(operands),
        )

    def host_register(self, unranked_ref: Value) -> None:
        gpu.HostRegisterOp(unranked_ref)


def module() -> ModuleBuilder:
    return ModuleBuilder()


__all__ = [
    "BufferAddressSpaceAttr",
    "ExprAttr",
    "F16Type",
    "F32Type",
    "FragmentType",
    "FunctionBuilder",
    "GlobalAddressSpaceAttr",
    "IndexType",
    "IntegerType",
    "MaskType",
    "MemRefType",
    "MemTokenType",
    "ModuleBuilder",
    "PrivateAddressSpaceAttr",
    "PtrType",
    "SharedAddressSpaceAttr",
    "SimdType",
    "WaveIndexType",
    "buffer_address_space",
    "buffer_ptr_type",
    "f16",
    "f32",
    "fragment_type",
    "global_address_space",
    "i8",
    "i32",
    "index_type",
    "mask_type",
    "mem_token_type",
    "module",
    "private_address_space",
    "ptr_type",
    "shared_address_space",
    "simd_ptr_type",
    "simd_type",
    "sym",
    "sym_ctx",
    "unranked_memref_type",
    "vector_type",
    "wave_index_type",
]
