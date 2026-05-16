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

    with dsl.module() as builder:
        with builder.gpu_module("kernels"):
            with builder.kernel("k", [dsl.ptr_type()]):
                ...

        with builder.host_main():
            ...

    print(str(builder.module))
"""

from __future__ import annotations

from collections.abc import Iterator, Sequence
from contextlib import contextmanager

from mlir._mlir_libs._waveDialectsNanobind import register_dialects
from mlir.dialects import arith, func, gpu, memref, scf, wave, waveamd
from mlir.ir import (
    Attribute,
    Context,
    F16Type,
    F32Type,
    IndexType,
    InsertionPoint,
    IntegerType,
    Location,
    MemRefType,
    Module,
    Type,
    UnitAttr,
    UnrankedMemRefType,
    Value,
)

# ---------------------------------------------------------------------------
# Type helpers
# ---------------------------------------------------------------------------


def i8() -> IntegerType:
    return IntegerType.get_signless(8)


def i32() -> IntegerType:
    return IntegerType.get_signless(32)


def index_type() -> IndexType:
    return IndexType.get()


def simd_type(element_type: Type | None = None, width: int = 32) -> Type:
    return Type.parse(f"!wave.simd<{element_type or i32()}, {width}>")


def mask_type(width: int = 32) -> Type:
    return Type.parse(f"!wave.mask<{width}>")


def mem_token_type() -> Type:
    return Type.parse("!wave.mem.token")


def ptr_type(
    element_type: Type | None = None, address_space: str = "#wave.global"
) -> Type:
    return Type.parse(f"!wave.ptr<{element_type or i32()}, {address_space}>")


def buffer_ptr_type(element_type: Type | None = None) -> Type:
    return ptr_type(element_type, "#waveamd.buffer")


def simd_ptr_type(
    element_type: Type | None = None,
    address_space: str = "#wave.global",
    width: int = 32,
) -> Type:
    return Type.parse(
        f"!wave.simd<!wave.ptr<{element_type or i32()}, {address_space}>, {width}>"
    )


def fragment_type(
    role: int,
    element_type: Type,
    rows: int = 16,
    columns: int = 16,
    wave_size: int = 32,
    registers: int = 4,
) -> Type:
    return Type.parse(
        f"!waveamd.fragment<{role}, {element_type}, {rows}, {columns}, "
        f"{wave_size}, {registers}>"
    )


def unranked_memref_type(element_type: Type) -> Type:
    return UnrankedMemRefType.get(element_type, Attribute.parse("0"))


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

    def __exit__(self, exc_type, exc, tb) -> None:
        self._ip.__exit__(exc_type, exc, tb)
        self.location.__exit__(exc_type, exc, tb)
        self.context.__exit__(exc_type, exc, tb)

    def __str__(self) -> str:
        assert self.module is not None
        return self.module.operation.get_asm(assume_verified=True)

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
    ) -> Iterator[FunctionBuilder]:
        op = func.FuncOp(name, (list(inputs), list(results)))
        op.attributes["gpu.kernel"] = UnitAttr.get()
        op.attributes["wave.kernel"] = UnitAttr.get()
        block = op.add_entry_block()
        with InsertionPoint(block):
            yield FunctionBuilder(block)
            func.ReturnOp([])


class FunctionBuilder:
    """Per-function helper that wires common arith / Wave / WaveAMD ops."""

    def __init__(self, block) -> None:
        self.block = block

    @property
    def args(self):
        return self.block.arguments

    # --- arith / index constants ------------------------------------------

    def constant(self, value: int, result_type: Type | None = None) -> Value:
        result_type = result_type or i32()
        return arith.ConstantOp(result_type, value).result

    def constant_i32(self, value: int) -> Value:
        return self.constant(value, i32())

    def constant_index(self, value: int) -> Value:
        return self.constant(value, index_type())

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

    def ptr_add(
        self, base: Value, offset: Value, result_type: Type | None = None
    ) -> Value:
        if result_type is None:
            # Mirror the verifier: a SIMD-of-pointer result is required as
            # soon as either operand is SIMD, otherwise the result is the
            # plain pointer type. We peek at the type names to stay
            # decoupled from the `wave` dialect Python type hierarchy.
            base_ty = str(base.type)
            off_ty = str(offset.type)
            if base_ty.startswith("!wave.simd<") or off_ty.startswith("!wave.simd<"):
                # Inherit the pointer element type / address space from the
                # base; default to a 32-wide pointer SIMD.
                if base_ty.startswith("!wave.simd<"):
                    result_type = base.type
                else:
                    result_type = Type.parse(f"!wave.simd<{base_ty}, 32>")
            else:
                result_type = base.type
        return wave.PtrAddOp(result_type, base, offset).result

    def store(self, value: Value, ptr: Value, *, after: Value | None = None) -> Value:
        return wave.StoreOp(mem_token_type(), value, ptr, dependency=after).token

    def wait(self, *tokens: Value) -> None:
        wave.WaitOp(list(tokens))

    def token(self) -> Value:
        return wave.TokenOp(mem_token_type()).result

    def after(self, *tokens: Value) -> Value:
        return wave.AfterOp(mem_token_type(), list(tokens)).result

    def join(self, *tokens: Value) -> Value:
        return wave.JoinOp(mem_token_type(), list(tokens)).result

    # --- WaveAMD ops -------------------------------------------------------

    def fragment_fill(self, value: Value, frag_type: Type) -> Value:
        return waveamd.FragmentFillOp(frag_type, value).result

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

    @contextmanager
    def for_loop(self, lower: Value, upper: Value, step: Value) -> Iterator[Value]:
        forop = scf.ForOp(lower, upper, step)
        with InsertionPoint(forop.body):
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
    "F16Type",
    "F32Type",
    "FunctionBuilder",
    "IndexType",
    "IntegerType",
    "MemRefType",
    "ModuleBuilder",
    "buffer_ptr_type",
    "fragment_type",
    "i8",
    "i32",
    "index_type",
    "mask_type",
    "mem_token_type",
    "module",
    "ptr_type",
    "simd_ptr_type",
    "simd_type",
    "unranked_memref_type",
]
