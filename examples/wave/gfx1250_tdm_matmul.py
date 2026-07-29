#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit a gfx1250 f16 GEMM using TDM loads and stores."""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass
from typing import TYPE_CHECKING

from common import (
    add_execution_args,
    compare_values,
    dump_kernel_asm,
    ensure_package_on_path,
    parse_runner_values,
    run_module,
)

if TYPE_CHECKING:
    from mlir.dialects.wave_dsl import Expr, FunctionBuilder
    from mlir.ir import Module, Type, Value

_Inputs = tuple[tuple[float, ...], tuple[float, ...]]
_KERNEL_NAME = "gfx1250_tdm_f16_gemm"
_GPU_MODULE_NAME = "kernels"


@dataclass(frozen=True)
class _KernelConfig:
    mma_kind: str
    tile_m: int
    tile_n: int
    tile_k: int
    operand_dwords: int
    accumulator_dwords: int
    lane_k_elements: int
    wave_size: int

    @property
    def a_lds_offset(self) -> int:
        return 0

    @property
    def b_lds_offset(self) -> int:
        return self.tile_m * self.tile_k * 2

    @property
    def c_lds_offset(self) -> int:
        return self.b_lds_offset + self.tile_n * self.tile_k * 2

    @property
    def lds_bytes(self) -> int:
        return self.c_lds_offset + self.tile_m * self.tile_n * 4


def _validate_shape(config: _KernelConfig, M: int, N: int, K: int) -> None:
    if M <= 0 or M % config.tile_m:
        raise ValueError(f"M must be a positive multiple of {config.tile_m}; got {M}")
    if N <= 0 or N % config.tile_n:
        raise ValueError(f"N must be a positive multiple of {config.tile_n}; got {N}")
    if K <= 0 or K % config.tile_k:
        raise ValueError(f"K must be a positive multiple of {config.tile_k}; got {K}")


def _emit_input_lds_pointers(
    builder: FunctionBuilder, config: _KernelConfig, lane: Value
) -> tuple[Value, Value, Expr]:
    from mlir.dialects import wave_dsl as w

    lane_sym = w.sym("tdm_lane")
    input_lds_index = builder.index_expr(
        config.lane_k_elements * w.mod(lane_sym, config.tile_m)
        + config.operand_dwords * w.floor(lane_sym / config.tile_m),
        {lane_sym: lane},
    )
    a_lds = builder.ptr_add(
        builder.shared_memory_base(w.i32(), offset=config.a_lds_offset),
        input_lds_index,
    )
    b_lds = builder.ptr_add(
        builder.shared_memory_base(w.i32(), offset=config.b_lds_offset),
        input_lds_index,
    )
    return a_lds, b_lds, lane_sym


def _fragment_types(config: _KernelConfig) -> tuple[Type, Type, Type, Type]:
    from mlir.dialects import wave_dsl as w

    a_type = w.fragment_type(
        0,
        w.f16(),
        config.tile_m,
        config.tile_n,
        config.wave_size,
        config.operand_dwords,
    )
    b_type = w.fragment_type(
        1,
        w.f16(),
        config.tile_m,
        config.tile_n,
        config.wave_size,
        config.operand_dwords,
    )
    acc_type = w.fragment_type(
        2,
        w.f32(),
        config.tile_m,
        config.tile_n,
        config.wave_size,
        config.accumulator_dwords,
    )
    registers_type = w.simd_type(
        w.vector_type(config.operand_dwords, w.i32()), width=config.wave_size
    )
    return a_type, b_type, acc_type, registers_type


def _emit_k_loop(
    builder: FunctionBuilder,
    config: _KernelConfig,
    K: int,
    a_base: Value,
    b_base: Value,
    wg_m_wide: Value,
    wg_n_wide: Value,
    a_lds: Value,
    b_lds: Value,
) -> tuple[Value, Value]:
    from mlir.dialects import wave_dsl as w

    a_type, b_type, acc_type, registers_type = _fragment_types(config)
    accumulator = builder.fragment_fill(builder.constant(w.i32(), 0), acc_type)
    zero = builder.constant(w.i32(), 0)
    steps = builder.constant(w.i32(), K // config.tile_k)
    one = builder.constant(w.i32(), 1)

    with builder.for_loop(
        zero,
        steps,
        one,
        init_args=[accumulator, builder.token()],
        nonzero_trip=True,
    ) as loop:
        k_iter = loop.induction_variable
        accumulator, reusable = loop.inner_iter_args
        k_iter_wide = builder.intconvert(
            k_iter, w.i64(), extension=w.CastExtension.Zero
        )
        a_offset = builder.muli(
            builder.addi(
                builder.muli(wg_m_wide, builder.constant(w.i64(), config.tile_m * K)),
                builder.muli(k_iter_wide, builder.constant(w.i64(), config.tile_k)),
            ),
            builder.constant(w.i64(), 2),
        )
        b_offset = builder.muli(
            builder.addi(
                builder.muli(wg_n_wide, builder.constant(w.i64(), config.tile_n * K)),
                builder.muli(k_iter_wide, builder.constant(w.i64(), config.tile_k)),
            ),
            builder.constant(w.i64(), 2),
        )
        a_address = builder.addi(a_base, a_offset)
        b_address = builder.addi(b_base, b_offset)
        a_descriptor = builder.gfx1250_tdm_descriptor(
            a_address,
            [config.tile_m, config.tile_k],
            [K, 1],
            [config.tile_m, config.tile_k],
            element_bit_width=16,
            lds_address=config.a_lds_offset,
        )
        b_descriptor = builder.gfx1250_tdm_descriptor(
            b_address,
            [config.tile_n, config.tile_k],
            [K, 1],
            [config.tile_n, config.tile_k],
            element_bit_width=16,
            lds_address=config.b_lds_offset,
        )
        a_loaded = builder.tdm_load(a_descriptor, after=reusable)
        b_loaded = builder.tdm_load(b_descriptor, after=reusable)
        ready = builder.barrier(a_loaded, b_loaded)
        a_registers, a_read = builder.load(a_lds, registers_type, after=ready)
        b_registers, b_read = builder.load(b_lds, registers_type, after=ready)
        accumulator = builder.mma(
            config.mma_kind,
            builder.fragment_pack(a_registers, a_type),
            builder.fragment_pack(b_registers, b_type),
            accumulator,
        )
        builder.yield_([accumulator, builder.join(a_read, b_read)])

    return loop.results[0], loop.results[1]


def _emit_output(
    builder: FunctionBuilder,
    config: _KernelConfig,
    N: int,
    c_base: Value,
    wg_m_wide: Value,
    wg_n_wide: Value,
    lane: Value,
    lane_sym: Expr,
    accumulator: Value,
    reusable: Value,
) -> None:
    from mlir.dialects import wave_dsl as w

    unpacked = builder.fragment_unpack(accumulator)
    output_stores = []
    for register in range(config.accumulator_dwords):
        output_index = builder.index_expr(
            config.tile_n
            * config.accumulator_dwords
            * w.floor(lane_sym / config.tile_n)
            + config.tile_n * register
            + w.mod(lane_sym, config.tile_n),
            {lane_sym: lane},
        )
        output_ptr = builder.ptr_add(
            builder.shared_memory_base(w.i32(), offset=config.c_lds_offset),
            output_index,
        )
        value = builder.extract(
            unpacked,
            register,
            w.simd_type(w.i32(), width=config.wave_size),
        )
        output_stores.append(builder.store(value, output_ptr, after=reusable))

    output_ready = builder.barrier(*output_stores)
    c_offset = builder.muli(
        builder.addi(
            builder.muli(wg_m_wide, builder.constant(w.i64(), config.tile_m * N)),
            builder.muli(wg_n_wide, builder.constant(w.i64(), config.tile_n)),
        ),
        builder.constant(w.i64(), 4),
    )
    c_descriptor = builder.gfx1250_tdm_descriptor(
        builder.addi(c_base, c_offset),
        [config.tile_m, config.tile_n],
        [N, 1],
        [config.tile_m, config.tile_n],
        element_bit_width=32,
        lds_address=config.c_lds_offset,
        is_store=True,
    )
    stored = builder.tdm_store(c_descriptor, after=output_ready)
    builder.barrier(stored)


def _emit_kernel(
    builder: FunctionBuilder, config: _KernelConfig, M: int, N: int, K: int
) -> None:
    from mlir.dialects import wave_dsl as w

    a_base, b_base, c_base = builder.args
    wg_m = builder.assume_range(builder.workgroup_id(0), 0, M // config.tile_m - 1)
    wg_n = builder.assume_range(builder.workgroup_id(1), 0, N // config.tile_n - 1)
    lane = builder.workitem_id(0, width=config.wave_size)
    wg_m_wide = builder.intconvert(wg_m, w.i64(), extension=w.CastExtension.Zero)
    wg_n_wide = builder.intconvert(wg_n, w.i64(), extension=w.CastExtension.Zero)
    a_lds, b_lds, lane_sym = _emit_input_lds_pointers(builder, config, lane)
    accumulator, reusable = _emit_k_loop(
        builder,
        config,
        K,
        a_base,
        b_base,
        wg_m_wide,
        wg_n_wide,
        a_lds,
        b_lds,
    )
    _emit_output(
        builder,
        config,
        N,
        c_base,
        wg_m_wide,
        wg_n_wide,
        lane,
        lane_sym,
        accumulator,
        reusable,
    )


def _emit_values(
    builder: FunctionBuilder,
    buffer: Value,
    values: tuple[float, ...],
    element_type: Type,
) -> None:
    from mlir.dialects import wave_dsl as w

    index_type = w.index_type()
    for index, value in enumerate(values):
        builder.memref_store(
            builder.constant(element_type, value),
            buffer,
            [builder.constant(index_type, index)],
        )


def _emit_host(
    builder: FunctionBuilder,
    config: _KernelConfig,
    M: int,
    N: int,
    K: int,
    *,
    random_data: bool,
    seed: int,
) -> _Inputs:
    from mlir.dialects import wave_dsl as w
    from mlir.dialects.wave_matmul import generate_wmma_f16_matmul_inputs

    a_values, b_values = generate_wmma_f16_matmul_inputs(
        M,
        N,
        K,
        random_data=random_data,
        random_seed=seed,
    )
    a = builder.alloc([M * K], w.f16())
    b = builder.alloc([N * K], w.f16())
    c = builder.alloc([M * N], w.f32())
    _emit_values(builder, a, a_values, w.f16())
    _emit_values(builder, b, b_values, w.f16())

    index_type = w.index_type()
    zero = builder.constant(index_type, 0)
    end = builder.constant(index_type, M * N)
    one = builder.constant(index_type, 1)
    with builder.for_loop(zero, end, one) as index:
        builder.memref_store(builder.constant(w.f32(), 0.0), c, [index])

    a_ref = builder.cast_unranked(a)
    b_ref = builder.cast_unranked(b)
    c_ref = builder.cast_unranked(c)
    builder.host_register(a_ref)
    builder.host_register(b_ref)
    builder.host_register(c_ref)
    addresses = [
        builder.index_cast(builder.aligned_pointer_as_index(buffer), w.i64())
        for buffer in (a, b, c)
    ]
    blocks_m = builder.constant(index_type, M // config.tile_m)
    blocks_n = builder.constant(index_type, N // config.tile_n)
    threads = builder.constant(index_type, config.wave_size)
    builder.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(blocks_m, blocks_n, one),
        block=(threads, one, one),
        operands=addresses,
    )
    builder.call("printMemrefF32", [c_ref])
    return a_values, b_values


def build_gfx1250_tdm_f16_gemm_module(
    M: int,
    N: int,
    K: int,
    *,
    random_data: bool = False,
    seed: int = 0,
) -> tuple[Module, _Inputs]:
    ensure_package_on_path("mlir.dialects.wave_dsl")
    from mlir.dialects import wave_dsl as w
    from mlir.dialects.wave_target import (
        GFX1250_CHIP,
        require_matmul_target_profile,
    )

    profile = require_matmul_target_profile(GFX1250_CHIP)
    mma = profile.mma("f16")
    config = _KernelConfig(
        mma_kind=mma.kind_name,
        tile_m=mma.m_tile,
        tile_n=mma.n_tile,
        tile_k=mma.k_tile,
        operand_dwords=mma.operand_dwords,
        accumulator_dwords=mma.accumulator_dwords,
        lane_k_elements=mma.lane_k_elements,
        wave_size=profile.wave_size,
    )
    _validate_shape(config, M, N, K)
    module_builder = w.ModuleBuilder()
    with module_builder:
        module_builder.declare_external(
            "printMemrefF32",
            [w.unranked_memref_type(w.f32())],
            [],
        )
        with (
            module_builder.gpu_module(_GPU_MODULE_NAME) as gpu_module,
            gpu_module.kernel(
                _KERNEL_NAME,
                [w.i64(), w.i64(), w.i64()],
                lds_size=config.lds_bytes,
                workgroup_size=[config.wave_size, 1, 1],
            ) as kernel,
        ):
            _emit_kernel(kernel, config, M, N, K)
        with module_builder.host_main() as host:
            inputs = _emit_host(
                host,
                config,
                M,
                N,
                K,
                random_data=random_data,
                seed=seed,
            )
    return module_builder.module, inputs


def _reference(
    M: int,
    N: int,
    K: int,
    a_values: tuple[float, ...],
    b_values: tuple[float, ...],
) -> tuple[float, ...]:
    return tuple(
        sum(a_values[m * K + k] * b_values[n * K + k] for k in range(K))
        for m in range(M)
        for n in range(N)
    )


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--m", type=int, default=16)
    parser.add_argument("--n", type=int, default=16)
    parser.add_argument("--k", type=int, default=32)
    parser.add_argument("--random-data", action="store_true")
    add_execution_args(parser, default_atol=1.0e-3, default_rtol=1.0e-3)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    random_data = args.random_data or args.compare_cpu
    try:
        module, inputs = build_gfx1250_tdm_f16_gemm_module(
            args.m,
            args.n,
            args.k,
            random_data=random_data,
            seed=args.seed,
        )
    except ValueError as exc:
        raise SystemExit(str(exc)) from exc
    module_text = str(module)
    if args.dump_asm:
        sys.stdout.write(
            dump_kernel_asm(
                module_text,
                chip=args.chip,
                wave_translate=args.wave_translate,
                kernel_regex=rf"(func\.func @{_KERNEL_NAME}.*?\n    \}})",
                kernel_name=_KERNEL_NAME,
                missing_message="could not isolate TDM GEMM kernel",
            )
        )
        return 0
    if not args.run and not args.compare_cpu:
        sys.stdout.write(module_text)
        return 0

    output = run_module(
        module_text,
        chip=args.chip,
        wave_opt=args.wave_opt,
        mlir_runner=args.mlir_runner,
        shared_libs=args.shared_lib,
    )
    if not args.compare_cpu:
        sys.stdout.write(output)
        return 0

    actual = parse_runner_values(output)
    expected = _reference(args.m, args.n, args.k, *inputs)
    ok, message = compare_values(
        actual,
        expected,
        atol=args.atol,
        rtol=args.rtol,
    )
    if not ok:
        sys.stderr.write(f"CPU comparison failed: {message}\n")
        return 1
    sys.stdout.write(f"CPU comparison passed: {message}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
