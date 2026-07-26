#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Calibrate matmul scheduling variants against simulator + hardware timing."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from statistics import median

REPO_ROOT = Path(__file__).resolve().parents[2]
EXAMPLE = REPO_ROOT / "examples/wave/wmma_matmul_tiled.py"
STREAMK_EXAMPLE = REPO_ROOT / "examples/wave/streamk_f16_gemm.py"
PERSISTENT_EXAMPLE = REPO_ROOT / "examples/wave/persistent_wave_gemm.py"
TENSILELITE_EXAMPLE = REPO_ROOT / "examples/wave/tensilelite_mxfp4_subtile.py"
RUNNER_SRC = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"
KERNEL_NAME = "wmma_f16_matmul_tiled"
STREAMK_KERNEL_NAME = "gfx950_f16_streamk_gemm"
PERSISTENT_KERNEL_NAME = "gfx950_persistent_f16_gemm"
PERSISTENT_LDS_BYTES = 98_336
V9_GOLDEN_NAME = "v9_4096.original.wave"
V9_TRANSPOSED_GOLDEN_NAME = "v9_4096.transposed.wave"
V9_GOLDEN_KERNEL_NAME = "v9_beyond_hotloop"
A4W4_MXFP_K16K_GOLDEN_NAME = "a4w4_mxfp_k16k"
TLX_MXFP_GOLDEN_KERNEL_NAME = "_a4w4_kernel"
V9_GOLDEN_INPUT_DIR = REPO_ROOT / "test/PerfGolden/Inputs"
V9_GOLDEN_SOURCE = V9_GOLDEN_INPUT_DIR / f"{V9_GOLDEN_NAME}.mlir"
STATIC_LDS_LIMIT = 64 * 1024
DEFAULT_SIM_TRIP_COUNT = 32
EMIT_ONLY_ENTRY_POINT = "waveamd_backend_emit_only"
_INT32_MAX = (1 << 31) - 1
_UINT32_MAX = (1 << 32) - 1
_SIZE_T_MAX = 2 * sys.maxsize + 1
_STREAMK_TILE_ELEMENTS = 256 * 256
_STREAMK_PARTIAL_SLOTS = 2
sys.path.insert(0, str(REPO_ROOT / "tools"))
sys.path.insert(0, str(REPO_ROOT / "examples" / "wave"))

from common import (  # noqa: E402
    default_build_dir,
    ensure_package_on_path,
    resolve_llvm_tool,
)
from wave_calibration import (  # noqa: E402, F401
    VARIANTS,
    Variant,
    append_calibration_entry,
    backend_pipeline_path,
    detect_chip,
    erase_default_entry,
    import_mlir_bindings,
    parse_hw,
    parse_total_cycles,
    parse_variants,
    pipeline_text,
    read_backend_pipeline,
    run,
    run_hw_repeats,
    schedule_pass_options,
    schedule_report_options,
    write_pipeline,
)


@dataclass
class VariantResult:
    name: str
    sim_cycles: int | None
    hw_cycles_samples: list[int]
    hw_us_samples: list[float]
    hw_check: str | None

    @property
    def hw_cycles(self) -> int | None:
        if not self.hw_cycles_samples:
            return None
        return round(median(self.hw_cycles_samples))

    @property
    def hw_us(self) -> float | None:
        if not self.hw_us_samples:
            return None
        return median(self.hw_us_samples)


ProfileValue = bool | int | str
_PHASED_DMA_PROFILE = "gfx950-f16-256x256-8wave"
_SPATIAL_DMA_PROFILE = "gfx950-f16-256x256-8wave-spatial"
_FOUR_WAVE_PHASED_DMA_PROFILE = "gfx950-f16-256x256-4wave"
_STREAMK_PROFILE = "gfx950-f16-256x256-4wave-streamk"
_PHASED_DMA_PROFILES = frozenset(
    (
        _PHASED_DMA_PROFILE,
        _SPATIAL_DMA_PROFILE,
        _FOUR_WAVE_PHASED_DMA_PROFILE,
        _STREAMK_PROFILE,
    )
)

_MXFP4_AITER_PROFILE: dict[str, ProfileValue] = {
    "target_waves": 1,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "mxfp4",
    "output_type": "f16",
    "output_layout": "row-major",
    "output_store_cache": "cs",
    "mxfp4_input_layout": "aiter",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
}

KERNEL_PROFILES: dict[str, dict[str, ProfileValue]] = {
    "gfx950-f16-256x256-16wave-persistent": {
        "example": "persistent-gemm",
        "bm": 4,
        "bn": 4,
        "wave_m_tiles": 4,
        "wave_n_tiles": 4,
        "wave_k_tiles": 1,
        "target_waves": 4,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
        "persistent_completion": "poll",
        "persistent_poll_sleep_cycles": 1,
    },
    "gfx950-f16-256x256-16wave": {
        "bm": 4,
        "bn": 4,
        "wave_m_tiles": 4,
        "wave_n_tiles": 4,
        "wave_k_tiles": 1,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "gfx950-f16-256x256-8wave": {
        "bm": 2,
        "bn": 4,
        "wave_m_tiles": 8,
        "wave_n_tiles": 4,
        "wave_k_tiles": 2,
        "target_waves": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    _SPATIAL_DMA_PROFILE: {
        "bm": 2,
        "bn": 4,
        "wave_m_tiles": 8,
        "wave_n_tiles": 4,
        "wave_k_tiles": 2,
        "target_waves": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "gfx950-f16-256x256-4wave": {
        "bm": 2,
        "bn": 2,
        "wave_m_tiles": 8,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 1,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_layout": "column-major",
        "output_store_cache": "cs",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
        "coalesced_mfma_output": True,
    },
    _STREAMK_PROFILE: {
        "example": "streamk-gemm",
        "bm": 2,
        "bn": 2,
        "wave_m_tiles": 8,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 1,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "output_store_cache": "cs",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
        "coalesced_mfma_output": True,
        "streamk_workers": 256,
    },
    "gfx950-mxfp4-256x256-8wave": {
        "bm": 4,
        "bn": 2,
        "wave_m_tiles": 4,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "mxfp4",
        "output_type": "f16",
        "output_layout": "column-major",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "gfx950-mxfp4-256x256-4wave": {
        "bm": 2,
        "bn": 2,
        "wave_m_tiles": 8,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 1,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "mxfp4",
        "output_type": "f16",
        "output_layout": "column-major",
        "mxfp4_scale_path": "regs",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "gfx950-mxfp4-aiter-32x128": {
        **_MXFP4_AITER_PROFILE,
        "bm": 1,
        "bn": 4,
        "wave_m_tiles": 2,
        "wave_n_tiles": 2,
        "wave_k_tiles": 2,
    },
    "gfx950-mxfp4-aiter-64x128": {
        **_MXFP4_AITER_PROFILE,
        "bm": 1,
        "bn": 4,
        "wave_m_tiles": 4,
        "wave_n_tiles": 2,
        "wave_k_tiles": 2,
    },
    "gfx950-mxfp4-aiter-128x128": {
        **_MXFP4_AITER_PROFILE,
        "bm": 1,
        "bn": 4,
        "wave_m_tiles": 8,
        "wave_n_tiles": 2,
        "wave_k_tiles": 2,
    },
    "gfx950-mxfp4-aiter-128x256": {
        **_MXFP4_AITER_PROFILE,
        "bm": 1,
        "bn": 4,
        "wave_m_tiles": 8,
        "wave_n_tiles": 4,
        "wave_k_tiles": 4,
    },
    "gfx950-mxfp4-aiter-256x256": {
        **_MXFP4_AITER_PROFILE,
        "bm": 1,
        "bn": 4,
        "wave_m_tiles": 16,
        "wave_n_tiles": 4,
        "wave_k_tiles": 4,
        "cta_swizzle_xcds": 1,
        "cta_group_m": 4,
    },
    "v9-4096-original-wave": {
        "example": "v9-perf-golden",
        "v9_golden_name": V9_GOLDEN_NAME,
        "m": 4096,
        "n": 4096,
        "k": 4096,
        "bm": 4,
        "bn": 2,
        "wave_m_tiles": 4,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "v9-4096-transposed-wave": {
        "example": "v9-perf-golden",
        "v9_golden_name": V9_TRANSPOSED_GOLDEN_NAME,
        "m": 4096,
        "n": 4096,
        "k": 4096,
        "bm": 4,
        "bn": 2,
        "wave_m_tiles": 4,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "f16",
        "output_type": "f16",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
    "a4w4-mxfp-k16k": {
        "example": "tlx-mxfp-perf-golden",
        "tlx_mxfp_golden_name": A4W4_MXFP_K16K_GOLDEN_NAME,
        "m": 4096,
        "n": 4096,
        "k": 16384,
        "bm": 2,
        "bn": 2,
        "wave_m_tiles": 8,
        "wave_n_tiles": 8,
        "wave_k_tiles": 2,
        "target_waves": 1,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "mxfp4",
        "output_type": "bf16",
        "mxfp4_scale_path": "regs",
        "cta_swizzle_xcds": 8,
        "cta_group_m": 4,
    },
}


def resolve_chip(args: argparse.Namespace) -> str:
    chip = args.chip or detect_chip()
    args.chip = chip
    return chip


def selected_example(args: argparse.Namespace) -> str:
    return getattr(args, "example", "matmul")


def is_v9_perf_golden(args: argparse.Namespace) -> bool:
    return selected_example(args) == "v9-perf-golden"


def is_tlx_mxfp_perf_golden(args: argparse.Namespace) -> bool:
    return selected_example(args) == "tlx-mxfp-perf-golden"


def is_checked_in_perf_golden(args: argparse.Namespace) -> bool:
    return is_v9_perf_golden(args) or is_tlx_mxfp_perf_golden(args)


def is_streamk_gemm(args: argparse.Namespace) -> bool:
    return selected_example(args) == "streamk-gemm"


def is_persistent_gemm(args: argparse.Namespace) -> bool:
    return selected_example(args) == "persistent-gemm"


def kernel_name(args: argparse.Namespace) -> str:
    if is_streamk_gemm(args):
        return STREAMK_KERNEL_NAME
    if is_persistent_gemm(args):
        return PERSISTENT_KERNEL_NAME
    if is_v9_perf_golden(args):
        return V9_GOLDEN_KERNEL_NAME
    if is_tlx_mxfp_perf_golden(args):
        return TLX_MXFP_GOLDEN_KERNEL_NAME
    return KERNEL_NAME


def kernel_abi(args: argparse.Namespace) -> str:
    if is_streamk_gemm(args):
        return "streamk"
    if is_v9_perf_golden(args):
        return "v9-golden"
    if is_tlx_mxfp_perf_golden(args):
        return "tlx-mxfp"
    return "matmul"


def selected_scale_input(args: argparse.Namespace) -> str:
    return getattr(args, "scale_input", "canonical")


def input_mode_name(args: argparse.Namespace) -> str:
    if getattr(args, "all_ones", False):
        return "all-ones"
    if getattr(args, "rand_int", False):
        return "rand-int"
    if getattr(args, "hpl", False):
        return "hpl"
    return "random"


def effective_output_layout(args: argparse.Namespace) -> str:
    output_layout = getattr(args, "output_layout", "automatic")
    if output_layout != "automatic":
        return output_layout
    if is_v9_perf_golden(args):
        return "row-major"
    if selected_example(args) == "tensilelite-subtile":
        return "tile-packed"
    if is_streamk_gemm(args) or getattr(args, "coalesced_mfma_output", False):
        return "column-major"
    if getattr(args, "mxfp4_input_layout", "canonical") == "aiter":
        return "row-major"
    return "row-major"


def append_option_if(cmd: list[str], enabled: bool, option: str) -> None:
    if enabled:
        cmd.append(option)


def append_target_waves(cmd: list[str], args: argparse.Namespace) -> None:
    target_waves = effective_target_waves(args)
    append_option_if(cmd, target_waves != 0, f"--target-waves={target_waves}")


def build_tensilelite_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    cmd = [
        sys.executable,
        str(TENSILELITE_EXAMPLE),
        f"--chip={chip}",
        f"--m={args.m}",
        f"--n={args.n}",
        f"--k={args.k}",
        f"--bm={args.bm}",
        f"--bn={args.bn}",
        f"--wave-m-tiles={args.wave_m_tiles}",
        f"--wave-n-tiles={args.wave_n_tiles}",
        f"--wave-k-tiles={args.wave_k_tiles}",
        f"--scale-input={selected_scale_input(args)}",
    ]
    append_target_waves(cmd, args)
    append_option_if(
        cmd, getattr(args, "multi_wave_specialize", False), "--multi-wave-specialize"
    )
    return cmd


def build_matmul_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    cmd = [
        sys.executable,
        str(EXAMPLE),
        f"--chip={chip}",
        f"--m={args.m}",
        f"--n={args.n}",
        f"--k={args.k}",
        f"--bm={args.bm}",
        f"--bn={args.bn}",
        f"--wave-m-tiles={args.wave_m_tiles}",
        f"--wave-n-tiles={args.wave_n_tiles}",
        f"--wave-k-tiles={args.wave_k_tiles}",
        "--kernel-only",
    ]
    append_option_if(cmd, args.use_buffer, "--use-buffer")
    append_option_if(cmd, args.use_dma_lds, "--use-dma-lds")
    append_option_if(
        cmd,
        args.matrix_intrinsic != "auto",
        f"--matrix-intrinsic={args.matrix_intrinsic}",
    )
    append_option_if(cmd, args.input_type != "f16", f"--input-type={args.input_type}")
    append_option_if(
        cmd, args.output_type != "f32", f"--output-type={args.output_type}"
    )
    cmd.append(f"--output-layout={effective_output_layout(args)}")
    output_store_cache = getattr(args, "output_store_cache", "none")
    append_option_if(
        cmd,
        output_store_cache != "none",
        f"--output-store-cache={output_store_cache}",
    )
    mxfp4_scale_path = getattr(args, "mxfp4_scale_path", "dma")
    append_option_if(
        cmd,
        mxfp4_scale_path != "dma",
        f"--mxfp4-scale-path={mxfp4_scale_path}",
    )
    mxfp4_input_layout = getattr(args, "mxfp4_input_layout", "canonical")
    append_option_if(
        cmd,
        mxfp4_input_layout != "canonical",
        f"--mxfp4-input-layout={mxfp4_input_layout}",
    )
    cta_swizzle_xcds = getattr(args, "cta_swizzle_xcds", 1)
    cta_group_m = getattr(args, "cta_group_m", 1)
    cmd.append(f"--cta-swizzle-xcds={cta_swizzle_xcds}")
    cmd.append(f"--cta-group-m={cta_group_m}")
    append_target_waves(cmd, args)
    append_option_if(
        cmd, getattr(args, "enable_split_barriers", False), "--enable-split-barriers"
    )
    append_option_if(
        cmd, getattr(args, "multi_wave_specialize", False), "--multi-wave-specialize"
    )
    append_option_if(
        cmd,
        getattr(args, "coalesced_mfma_output", False),
        "--coalesced-mfma-output",
    )
    kernel_profile = getattr(args, "kernel_profile", "manual")
    append_option_if(
        cmd,
        kernel_profile in _PHASED_DMA_PROFILES,
        f"--kernel-profile={kernel_profile}",
    )
    return cmd


def build_streamk_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    return [
        sys.executable,
        str(STREAMK_EXAMPLE),
        f"--chip={chip}",
        f"--m={args.m}",
        f"--n={args.n}",
        f"--k={args.k}",
        f"--workers={args.streamk_workers}",
        f"--cta-swizzle-xcds={args.cta_swizzle_xcds}",
        f"--cta-group-m={args.cta_group_m}",
    ]


def build_persistent_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    return [
        sys.executable,
        str(PERSISTENT_EXAMPLE),
        f"--chip={chip}",
        f"--m={args.m}",
        f"--n={args.n}",
        f"--k={args.k}",
        f"--completion={args.persistent_completion}",
        f"--poll-sleep-cycles={args.persistent_poll_sleep_cycles}",
    ]


def build_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    if is_streamk_gemm(args):
        return build_streamk_example_args(args, chip)
    if is_persistent_gemm(args):
        return build_persistent_example_args(args, chip)
    if selected_example(args) == "tensilelite-subtile":
        return build_tensilelite_example_args(args, chip)
    if is_checked_in_perf_golden(args):
        sys.exit(f"--example={selected_example(args)} uses checked-in IR")
    return build_matmul_example_args(args, chip)


def v9_golden_source(args: argparse.Namespace) -> Path:
    name = getattr(args, "v9_golden_name", V9_GOLDEN_NAME)
    return V9_GOLDEN_INPUT_DIR / f"{name}.mlir"


def tlx_mxfp_golden_source(args: argparse.Namespace) -> Path:
    name = getattr(args, "tlx_mxfp_golden_name", A4W4_MXFP_K16K_GOLDEN_NAME)
    return V9_GOLDEN_INPUT_DIR / f"{name}.mlir"


def isolate_v9_golden_module(args: argparse.Namespace, chip: str) -> str:
    source = v9_golden_source(args)
    text = source.read_text()
    match = re.search(rf"(func\.func @{V9_GOLDEN_KERNEL_NAME}.*?\n    \}})", text, re.S)
    if not match:
        sys.exit(f"could not isolate {V9_GOLDEN_KERNEL_NAME} from {source}")
    kernel = re.sub(r"^    ", "  ", match.group(1).lstrip(), flags=re.M)
    target = f"amdgcn-amd-amdhsa--{chip}"
    return (
        f'module attributes {{waveamdmachine.target = "{target}"}} '
        f"{{\n{kernel}\n}}\n"
    )


def isolate_tlx_mxfp_golden_module(args: argparse.Namespace, chip: str) -> str:
    source = tlx_mxfp_golden_source(args)
    text = source.read_text()
    match = re.search(
        rf"(func\.func @{TLX_MXFP_GOLDEN_KERNEL_NAME}.*?\n    \}})", text, re.S
    )
    if not match:
        sys.exit(f"could not isolate {TLX_MXFP_GOLDEN_KERNEL_NAME} from {source}")
    kernel = re.sub(r"^    ", "  ", match.group(1).lstrip(), flags=re.M)
    target = f"amdgcn-amd-amdhsa--{chip}"
    return (
        f'module attributes {{waveamdmachine.target = "{target}"}} '
        f"{{\n{kernel}\n}}\n"
    )


def generate_kernel_module(args: argparse.Namespace, chip: str) -> str:
    if is_v9_perf_golden(args):
        return isolate_v9_golden_module(args, chip)
    if is_tlx_mxfp_perf_golden(args):
        return isolate_tlx_mxfp_golden_module(args, chip)

    env = os.environ.copy()
    package_path = args.build_dir / "python_packages/wave_mlir"
    env["PYTHONPATH"] = (
        str(package_path)
        if not env.get("PYTHONPATH")
        else str(package_path) + os.pathsep + env["PYTHONPATH"]
    )
    module_text = run(build_example_args(args, chip), env=env)
    name = re.escape(kernel_name(args))
    pretty = rf"(func\.func @{name}\w*.*?\n    \}})"
    generic = (
        rf'(\s+"func\.func"\(\).*?sym_name = "{name}".*?'
        r"\n\s+\}\) \{gpu\.kernel[^\n]*\} : \(\) -> \(\))"
    )
    match = re.search(pretty, module_text, re.S) or re.search(
        generic, module_text, re.S
    )
    if not match:
        sys.exit(f"could not isolate {kernel_name(args)} from generated module")
    kernel = re.sub(r"^    ", "  ", match.group(1).lstrip(), flags=re.M)
    target = f"amdgcn-amd-amdhsa--{chip}"
    return (
        f'module attributes {{waveamdmachine.target = "{target}"}} '
        f"{{\n{kernel}\n}}\n"
    )


def waves_per_workgroup(args: argparse.Namespace) -> int:
    return args.bm * args.bn


def spread_simds(args: argparse.Namespace) -> int:
    return min(max(waves_per_workgroup(args), 1), 4)


def required_target_waves(args: argparse.Namespace) -> int:
    waves = waves_per_workgroup(args)
    simds = spread_simds(args)
    return (waves + simds - 1) // simds


def effective_target_waves(args: argparse.Namespace) -> int:
    return max(args.target_waves, required_target_waves(args))


def lower_machine(
    build_dir: Path, source: Path, pipeline: Path, tmp: Path, name: str
) -> Path:
    out = tmp / f"{name}.machine.mlir"
    wave_opt = build_dir / "bin/wave-opt"
    text = run(
        [
            str(wave_opt),
            str(source),
            "--pass-pipeline=builtin.module("
            f"transform-preload-library{{transform-library-paths={pipeline}}},"
            "transform-interpreter)",
        ]
    )
    out.write_text(text)
    return out


def lower_asm(
    build_dir: Path,
    source: Path,
    pipeline: Path,
    tmp: Path,
    name: str,
    *,
    entry_point: str | None = None,
) -> Path:
    variant_tmp = tmp / name
    variant_tmp.mkdir(parents=True, exist_ok=True)
    wave_translate = build_dir / "bin/wave-translate"
    if not wave_translate.exists():
        sys.exit(f"required tool missing: {wave_translate}")
    env = os.environ.copy()
    env["WAVE_PIPELINES_DIR"] = str(pipeline.parent)
    if entry_point is not None:
        env["WAVE_PIPELINE_ENTRY_POINT"] = entry_point
    asm = variant_tmp / f"{name}.s"
    asm.write_text(
        run([str(wave_translate), "--wave-to-amdgpu-asm", str(source)], env=env)
    )
    return asm


def emit_machine_asm(
    build_dir: Path, machine: Path, pipeline: Path, tmp: Path, name: str
) -> Path:
    return lower_asm(
        build_dir,
        machine,
        pipeline,
        tmp,
        name,
        entry_point=EMIT_ONLY_ENTRY_POINT,
    )


def ensure_machine_asm(
    build_dir: Path,
    machine: Path,
    pipeline: Path,
    tmp: Path,
    name: str,
    asm: Path | None,
) -> Path:
    if asm is not None:
        return asm
    return emit_machine_asm(build_dir, machine, pipeline, tmp, name)


def assemble_hsaco(
    build_dir: Path, asm: Path, target_ir: Path, tmp: Path, name: str
) -> Path:
    variant_tmp = tmp / name
    variant_tmp.mkdir(parents=True, exist_ok=True)
    llvm_mc = resolve_llvm_tool("llvm-mc", build_dir)
    ld_lld = resolve_llvm_tool("ld.lld", build_dir)
    for tool in (llvm_mc, ld_lld):
        if not tool.exists():
            sys.exit(f"required tool missing: {tool}")
    obj = variant_tmp / f"{name}.o"
    hsaco = variant_tmp / f"{name}.hsaco"
    run(
        [
            str(llvm_mc),
            "-triple=amdgcn-amd-amdhsa",
            f"-mcpu={detect_asm_chip(target_ir)}",
            "-filetype=obj",
            "-o",
            str(obj),
            str(asm),
        ]
    )
    run([str(ld_lld), "-shared", str(obj), "-o", str(hsaco)])
    return hsaco


def lower_hsaco(
    build_dir: Path, source: Path, pipeline: Path, tmp: Path, name: str
) -> Path:
    asm = lower_asm(build_dir, source, pipeline, tmp, name)
    return assemble_hsaco(build_dir, asm, source, tmp, name)


def detect_asm_chip(source: Path) -> str:
    text = source.read_text()
    match = re.search(r'waveamdmachine\.target = "amdgcn-amd-amdhsa--([^"]+)"', text)
    if not match:
        sys.exit("source missing waveamdmachine.target")
    return match.group(1)


def selected_matrix_intrinsic(args: argparse.Namespace) -> str:
    requested = getattr(args, "matrix_intrinsic", "auto")
    chip = getattr(args, "chip", "")
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import select_matrix_intrinsic

    try:
        return select_matrix_intrinsic(chip, requested)
    except ValueError as exc:
        sys.exit(str(exc))


def matmul_target_profile(args: argparse.Namespace):
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import get_matmul_target_profile

    return get_matmul_target_profile(getattr(args, "chip", ""))


def target_mma_profile(args: argparse.Namespace):
    profile = matmul_target_profile(args)
    if profile is None:
        return None
    try:
        return profile.mma(getattr(args, "input_type", "f16"))
    except ValueError as exc:
        sys.exit(str(exc))


def mma_k_tile(args: argparse.Namespace) -> int:
    if getattr(args, "input_type", "f16") == "mxfp4":
        return 128
    if mma := target_mma_profile(args):
        return mma.k_tile
    if selected_matrix_intrinsic(args) == "mfma_gfx950":
        return 32
    return 16


def compute_virtual_k_steps(args: argparse.Namespace) -> int:
    return div_exact(args.k, mma_k_tile(args) * args.wave_k_tiles, "bad K blocking")


def compute_kernel_arg_trip_count(args: argparse.Namespace) -> int:
    if is_checked_in_perf_golden(args) or is_streamk_gemm(args):
        return 0
    virtual_k_steps = compute_virtual_k_steps(args)
    return max(virtual_k_steps - 1, 0)


def kernel_arg_trip_count_text(args: argparse.Namespace) -> str:
    if is_checked_in_perf_golden(args) or is_streamk_gemm(args):
        return "n/a"
    return str(compute_kernel_arg_trip_count(args))


def compute_sim_loop_trip_count(args: argparse.Namespace) -> int:
    virtual_k_steps = compute_virtual_k_steps(args)
    if is_checked_in_perf_golden(args):
        return max((virtual_k_steps - 2) // 2, 0)
    if is_persistent_gemm(args):
        return virtual_k_steps
    if (
        selected_example(args) == "tensilelite-subtile"
        and selected_scale_input(args) == "tensilelite"
    ):
        return max((virtual_k_steps - 2) // 2, 0)
    if args.use_dma_lds:
        return max(virtual_k_steps - 2, 0)
    return max(virtual_k_steps - 1, 0)


def compute_report_trip_count(args: argparse.Namespace) -> int:
    natural = compute_sim_loop_trip_count(args)
    override = getattr(args, "sim_trip_count", DEFAULT_SIM_TRIP_COUNT)
    if override < 0:
        return natural
    return min(natural, override)


def compute_loop_trip_count(args: argparse.Namespace) -> int:
    return compute_sim_loop_trip_count(args)


def kernel_wave_size(args: argparse.Namespace) -> int:
    intrinsic = selected_matrix_intrinsic(args)
    if profile := matmul_target_profile(args):
        return profile.wave_size
    return 64 if intrinsic == "mfma_gfx950" else 32


def accumulator_layout(args: argparse.Namespace) -> str:
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import GFX1250_MATRIX_INTRINSIC

    intrinsic = selected_matrix_intrinsic(args)
    return "wmma" if intrinsic in ("wmma", GFX1250_MATRIX_INTRINSIC) else "mfma"


def div_exact(num: int, den: int, what: str) -> int:
    if den <= 0 or num % den != 0:
        sys.exit(what)
    return num // den


def lds_dwords_per_frag(args: argparse.Namespace) -> int:
    if mma := target_mma_profile(args):
        selected_matrix_intrinsic(args)
        return mma.operand_dwords * kernel_wave_size(args)
    intrinsic = selected_matrix_intrinsic(args)
    if intrinsic == "mfma_gfx950":
        regs = 4
    elif intrinsic == "mfma":
        regs = 2
    else:
        regs = 8
    return regs * kernel_wave_size(args)


def mxfp4_scale_tiles_per_wave(tile_count: int) -> int:
    return tile_count // 4 if tile_count % 4 == 0 else tile_count


def mxfp4_scale_lds_bytes(args: argparse.Namespace) -> int:
    if getattr(args, "mxfp4_input_layout", "canonical") == "aiter":
        k_pairs = args.wave_k_tiles // 2
        a_blocks = k_pairs * (args.wave_m_tiles // 2)
        b_blocks = k_pairs * (args.wave_n_tiles // 2)
        a_groups = (a_blocks + 3) // 4
        b_groups = (b_blocks + 3) // 4
        waves = args.bm * args.bn
        if (
            args.bm * a_groups == waves
            and args.bn * b_groups == waves
            and a_blocks % 4 == 0
            and b_blocks % 4 == 0
        ):
            dma_groups = args.bm * a_groups + args.bn * b_groups
        else:
            dma_groups = waves * (a_groups + b_groups)
        return 2 * dma_groups * 1024
    if selected_example(args) == "tensilelite-subtile":
        k_groups = args.wave_k_tiles // 2
        scale_tiles = (
            args.bm * (args.wave_m_tiles // 2) * k_groups
            + args.bn * (args.wave_n_tiles // 2) * k_groups
        )
        return 2 * scale_tiles * 256

    scale_tiles = args.bm * mxfp4_scale_tiles_per_wave(
        args.wave_m_tiles
    ) + args.bn * mxfp4_scale_tiles_per_wave(args.wave_n_tiles)
    if getattr(args, "use_dma_lds", False):
        return 2 * args.wave_k_tiles * scale_tiles * 512
    return scale_tiles * 512


def dma_buffer_count(args: argparse.Namespace) -> int:
    if selected_example(args) == "tensilelite-subtile":
        return 2
    if not getattr(args, "use_dma_lds", False) or compute_virtual_k_steps(args) <= 1:
        return 1
    if (
        getattr(args, "input_type", "f16") != "mxfp4"
        and getattr(args, "kernel_profile", "manual") not in _PHASED_DMA_PROFILES
        and compute_virtual_k_steps(args) > 2
    ):
        return 4
    return 2


def compute_lds_bytes(args: argparse.Namespace) -> int:
    if is_persistent_gemm(args):
        return PERSISTENT_LDS_BYTES
    if selected_example(args) == "tensilelite-subtile":
        slots = args.wave_k_tiles * (
            args.bm * args.wave_m_tiles + args.bn * args.wave_n_tiles
        )
        data_lds = 2 * slots * lds_dwords_per_frag(args) * 4
        return data_lds + mxfp4_scale_lds_bytes(args)

    if getattr(args, "use_dma_lds", False):
        block_tiles = args.bm * args.wave_m_tiles
        if getattr(args, "mxfp4_input_layout", "canonical") != "aiter":
            block_tiles += args.bn * args.wave_n_tiles
        slots = args.wave_k_tiles * block_tiles
        dwords_per_slot = lds_dwords_per_frag(args)
        if getattr(args, "coalesced_mfma_output", False):
            dwords_per_slot += 4
        one_buffer = slots * dwords_per_slot * 4
        data_lds = one_buffer * dma_buffer_count(args)
        if getattr(args, "input_type", "f16") != "mxfp4":
            if is_streamk_gemm(args):
                return (data_lds + 4 + 31) // 32 * 32
            return data_lds
        return data_lds + mxfp4_scale_lds_bytes(args)
    slots = (
        args.wave_k_tiles * (args.wave_m_tiles + args.wave_n_tiles) * args.bm * args.bn
    )
    data_lds = slots * lds_dwords_per_frag(args) * 4
    if getattr(args, "input_type", "f16") != "mxfp4":
        return data_lds
    return data_lds + mxfp4_scale_lds_bytes(args)


def compute_dynamic_lds_bytes(args: argparse.Namespace) -> int:
    if is_checked_in_perf_golden(args):
        return 0
    lds_bytes = compute_lds_bytes(args)
    return lds_bytes if lds_bytes >= STATIC_LDS_LIMIT else 0


def run_sim_report(
    build_dir: Path, machine_mlir: Path, args: argparse.Namespace
) -> int:
    wave_sim = build_dir / "bin/wave-sim-report"
    trip_count = compute_report_trip_count(args)
    text = run(
        [
            str(wave_sim),
            f"--func={kernel_name(args)}",
            f"--trip-count={trip_count}",
            *(
                [f"--calibration-file={args.calibration_file}"]
                if args.calibration_file
                else []
            ),
            str(machine_mlir),
        ]
    )
    return parse_total_cycles(text)


def compile_runner(args: argparse.Namespace, tmp: Path) -> Path:
    runner = getattr(args, "runner", None)
    if runner is not None:
        if not runner.exists():
            sys.exit(f"runner not found: {runner}")
        return runner
    hipcc = args.hipcc
    if not Path(hipcc).exists() and shutil.which(hipcc) is None:
        sys.exit(f"hipcc not found: {hipcc}")
    runner = tmp / "wave-matmul-calibrate-runner"
    run([hipcc, "-O2", str(RUNNER_SRC), "-o", str(runner)])
    return runner


def append_hw_runner_options(cmd: list[str], args: argparse.Namespace) -> None:
    if is_streamk_gemm(args):
        cmd.extend(["--streamk-workers", str(args.streamk_workers)])
    if selected_scale_input(args) == "tensilelite":
        cmd.extend(["--scale-layout", "tensilelite"])
    if getattr(args, "mxfp4_input_layout", "canonical") != "canonical":
        cmd.extend(["--mxfp4-input-layout", args.mxfp4_input_layout])
    if getattr(args, "all_ones", False):
        cmd.append("--all-ones")
    if getattr(args, "rand_int", False):
        cmd.append("--rand-int")
    if getattr(args, "hpl", False):
        cmd.append("--hpl")
    if args.no_check:
        cmd.append("--no-check")


def run_hw(
    runner: Path, hsaco: Path, args: argparse.Namespace, rocm_lib: str
) -> tuple[int, float, str]:
    env = os.environ.copy()
    existing_ld = env.get("LD_LIBRARY_PATH", "")
    env["LD_LIBRARY_PATH"] = rocm_lib + (":" + existing_ld if existing_ld else "")
    cmd = [
        str(runner),
        "--m",
        str(args.m),
        "--n",
        str(args.n),
        "--k",
        str(args.k),
        "--bm",
        str(args.bm),
        "--bn",
        str(args.bn),
        "--wave-m-tiles",
        str(args.wave_m_tiles),
        "--wave-n-tiles",
        str(args.wave_n_tiles),
        "--wave-k-tiles",
        str(args.wave_k_tiles),
        "--wave-size",
        str(kernel_wave_size(args)),
        "--accumulator-layout",
        accumulator_layout(args),
        "--output-layout",
        effective_output_layout(args),
        "--input-type",
        args.input_type,
        "--c-type",
        args.output_type,
        "--kernel-abi",
        kernel_abi(args),
        "--dynamic-lds",
        str(compute_dynamic_lds_bytes(args)),
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
        "--seed",
        str(getattr(args, "seed", 0)),
    ]
    append_hw_runner_options(cmd, args)
    cmd += [str(hsaco), kernel_name(args)]
    stdout = run(cmd, env=env)
    sys.stdout.write(stdout)
    return parse_hw(stdout, check_output=not args.no_check)


def run_variant(
    variant: Variant,
    args: argparse.Namespace,
    source: Path | None,
    runner: Path | None,
    tmp: Path,
    emit_asm: Path | None = None,
    emit_hsaco: Path | None = None,
) -> VariantResult:
    run_hsaco = getattr(args, "run_hsaco", None)
    if run_hsaco is not None:
        if runner is None:
            sys.exit("--run-hsaco requires hardware timing")
        hw_cycles, hw_us, hw_check = run_hw_repeats(
            runner, run_hsaco, args, run_hw=run_hw
        )
        return VariantResult(variant.name, {}, hw_cycles, hw_us, hw_check)
    if source is None:
        sys.exit("internal error: source missing for compile path")
    pipeline = write_pipeline(tmp, variant, args)
    if emit_hsaco is not None:
        hsaco = lower_hsaco(args.build_dir, source, pipeline, tmp, variant.name)
        emit_hsaco.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(hsaco, emit_hsaco)
        if emit_asm is not None:
            asm = tmp / variant.name / f"{variant.name}.s"
            emit_asm.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(asm, emit_asm)
        return VariantResult(variant.name, None, [], [], None)
    if runner is None and emit_asm is not None:
        asm = lower_asm(args.build_dir, source, pipeline, tmp, variant.name)
        emit_asm.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(asm, emit_asm)
        return VariantResult(variant.name, None, [], [], None)
    machine = lower_machine(args.build_dir, source, pipeline, tmp, variant.name)
    asm = None
    if emit_asm is not None:
        asm = emit_machine_asm(args.build_dir, machine, pipeline, tmp, variant.name)
        emit_asm.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(asm, emit_asm)
    sim_cycles = run_simulation(args, machine)
    if runner is None:
        return VariantResult(variant.name, sim_cycles, [], [], None)
    asm = ensure_machine_asm(args.build_dir, machine, pipeline, tmp, variant.name, asm)
    hsaco = assemble_hsaco(args.build_dir, asm, machine, tmp, variant.name)
    hw_cycles, hw_us, hw_check = run_hw_repeats(runner, hsaco, args, run_hw=run_hw)
    return VariantResult(variant.name, sim_cycles, hw_cycles, hw_us, hw_check)


def run_simulation(args: argparse.Namespace, machine: Path) -> int | None:
    if is_streamk_gemm(args):
        return None
    return run_sim_report(args.build_dir, machine, args)


def print_result(result: VariantResult) -> None:
    print(f"variant: {result.name}")
    if result.sim_cycles is not None:
        print(f"  sim_cycles: {result.sim_cycles}")
    if result.hw_cycles_samples and result.hw_us_samples:
        if len(result.hw_cycles_samples) > 1:
            cycles = ",".join(str(x) for x in result.hw_cycles_samples)
            micros = ",".join(f"{x:.3f}" for x in result.hw_us_samples)
            print(f"  hw_cycles_wallclock_samples: {cycles}")
            print(f"  hw_per_launch_us_samples: {micros}")
        print(f"  hw_per_launch_us: {result.hw_us:.3f}")
        print(f"  hw_cycles_wallclock: {result.hw_cycles}")
    if result.hw_check is not None:
        print(f"  hw_output_check: {result.hw_check}")


def print_delta(results: list[VariantResult]) -> None:
    by_name = {r.name: r for r in results}
    base = by_name.get("baseline")
    if not base:
        return
    for result in results:
        if result.name == "baseline":
            continue
        print(f"delta: {result.name} - baseline")
        if base.sim_cycles is not None and result.sim_cycles is not None:
            print(f"  sim_cycles: {result.sim_cycles - base.sim_cycles:+d}")
        if base.hw_cycles is not None and result.hw_cycles is not None:
            delta = result.hw_cycles - base.hw_cycles
            pct = 100.0 * delta / max(base.hw_cycles, 1)
            print(f"  hw_cycles_wallclock: {delta:+d} ({pct:+.1f}%)")


def add_kernel_shape_args(ap: argparse.ArgumentParser) -> None:
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import MATRIX_INTRINSIC_CHOICES

    ap.add_argument("--chip", default="", help="gfx target; default from rocminfo")
    ap.add_argument(
        "--example",
        choices=(
            "matmul",
            "streamk-gemm",
            "persistent-gemm",
            "tensilelite-subtile",
            "v9-perf-golden",
            "tlx-mxfp-perf-golden",
        ),
        default="matmul",
        help="kernel generator to benchmark",
    )
    ap.add_argument(
        "--kernel-profile",
        choices=("manual", *KERNEL_PROFILES),
        default="manual",
        help="preload a known kernel shape; manual leaves tile args unchanged",
    )
    ap.add_argument("--m", type=int, default=32)
    ap.add_argument("--n", type=int, default=32)
    ap.add_argument("--k", type=int, default=32)
    ap.add_argument("--bm", type=int, default=1)
    ap.add_argument("--bn", type=int, default=2)
    ap.add_argument("--wave-m-tiles", type=int, default=1)
    ap.add_argument("--wave-n-tiles", type=int, default=1)
    ap.add_argument("--wave-k-tiles", type=int, default=1)
    ap.add_argument(
        "--target-waves",
        type=int,
        default=0,
        help="minimum waves per SIMD for regalloc; 0 derives from workgroup shape",
    )
    ap.add_argument("--use-buffer", action="store_true")
    ap.add_argument("--use-dma-lds", action="store_true")
    ap.add_argument(
        "--matrix-intrinsic",
        choices=MATRIX_INTRINSIC_CHOICES,
        default="auto",
    )
    ap.add_argument("--output-type", choices=("f32", "f16", "bf16"), default="f32")
    ap.add_argument(
        "--output-store-cache",
        choices=("none", "wb", "cg", "cs", "wt"),
        default="none",
    )
    ap.add_argument("--input-type", choices=("f16", "bf16", "mxfp4"), default="f16")
    ap.add_argument("--mxfp4-scale-path", choices=("dma", "regs"), default="dma")
    ap.add_argument(
        "--mxfp4-input-layout", choices=("canonical", "aiter"), default="canonical"
    )
    ap.add_argument(
        "--scale-input",
        choices=("canonical", "tensilelite"),
        default="canonical",
        help="scale buffer contract for --example=tensilelite-subtile",
    )
    ap.add_argument("--cta-swizzle-xcds", type=int, default=1)
    ap.add_argument("--cta-group-m", type=int, default=1)
    ap.add_argument(
        "--enable-split-barriers",
        action="store_true",
        help="stamp waveamdmachine.enable_split_barriers on generated matmul kernels",
    )
    ap.add_argument("--coalesced-mfma-output", action="store_true")
    ap.add_argument("--streamk-workers", type=int, default=1)
    ap.add_argument(
        "--persistent-completion",
        choices=("poll", "waitcnt"),
        default="poll",
    )
    ap.add_argument("--persistent-poll-sleep-cycles", type=int, default=1)


def add_runtime_args(ap: argparse.ArgumentParser) -> None:
    ap.add_argument("--iters", type=int, default=1000)
    ap.add_argument("--warmup", type=int, default=10)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument(
        "--output-layout",
        choices=("automatic", "tile-packed", "row-major", "column-major"),
        default="automatic",
    )
    input_mode = ap.add_mutually_exclusive_group()
    input_mode.add_argument(
        "--all-ones",
        action="store_true",
        help="fill A/B with ones and MXFP4 scales with 1 for debug runs",
    )
    input_mode.add_argument(
        "--rand-int",
        action="store_true",
        help="match hipBLASLt f16/bf16 rand_int inputs",
    )
    input_mode.add_argument(
        "--hpl",
        action="store_true",
        help="match hipBLASLt f16/bf16 HPL inputs",
    )
    ap.add_argument(
        "--repeats",
        type=int,
        default=1,
        help="hardware timing repeats per variant; reports median",
    )
    ap.add_argument(
        "--variants",
        type=parse_variants,
        default=parse_variants("baseline,scheduled"),
        help="comma-separated variants: baseline, scheduled",
    )
    ap.add_argument("--print-candidates", action="store_true")
    ap.add_argument("--print-score", action="store_true")
    ap.add_argument("--print-regions", action="store_true")
    ap.add_argument(
        "--sim-trip-count",
        type=int,
        default=DEFAULT_SIM_TRIP_COUNT,
        help="wave-sim-report loop trips; -1 uses the full kernel trip count",
    )


def add_scheduler_args(ap: argparse.ArgumentParser) -> None:
    ap.add_argument("--calibration-file", type=Path, default=None)
    ap.add_argument(
        "--multi-wave-specialize",
        action="store_true",
        help=(
            "stamp waveamdmachine.enable_multi_wave_specialization on generated kernels"
        ),
    )


def add_tool_args(ap: argparse.ArgumentParser) -> None:
    ap.add_argument("--skip-hw", action="store_true")
    ap.add_argument("--no-check", action="store_true")
    ap.add_argument("--emit-asm", type=Path)
    ap.add_argument("--emit-hsaco", type=Path)
    ap.add_argument("--run-hsaco", type=Path)
    ap.add_argument("--emit-mlir", type=Path)
    ap.add_argument("--keep-tmp", action="store_true")
    ap.add_argument("--runner", type=Path)
    ap.add_argument(
        "--build-dir",
        type=Path,
        default=default_build_dir(REPO_ROOT),
    )
    ap.add_argument(
        "--hipcc",
        default=os.environ.get("HIPCC", "/opt/rocm/bin/hipcc"),
    )
    ap.add_argument(
        "--rocm-lib",
        default=os.environ.get("ROCM_LIB", "/opt/rocm/lib"),
    )


def build_argparser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__)
    add_kernel_shape_args(ap)
    add_runtime_args(ap)
    add_scheduler_args(ap)
    add_tool_args(ap)
    return ap


def profile_defaults(argv: list[str]) -> dict[str, bool | int | str]:
    parser = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    parser.add_argument(
        "--kernel-profile",
        choices=("manual", *KERNEL_PROFILES),
        default="manual",
    )
    args, _ = parser.parse_known_args(argv)
    if args.kernel_profile == "manual":
        return {}
    return KERNEL_PROFILES[args.kernel_profile]


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = build_argparser()
    parser.set_defaults(**profile_defaults(argv))
    return parser.parse_args(argv)


def validate_aiter_mxfp4_args(args: argparse.Namespace) -> None:
    mxfp4_scale_path = getattr(args, "mxfp4_scale_path", "dma")
    mxfp4_input_layout = getattr(args, "mxfp4_input_layout", "canonical")
    if mxfp4_input_layout != "aiter":
        return
    if args.input_type != "mxfp4":
        sys.exit("--mxfp4-input-layout=aiter requires --input-type=mxfp4")
    if mxfp4_scale_path != "dma":
        sys.exit("--mxfp4-input-layout=aiter requires --mxfp4-scale-path=dma")
    if args.coalesced_mfma_output:
        sys.exit("AITER input layout does not support coalesced output")
    if effective_output_layout(args) != "row-major":
        sys.exit("AITER input layout requires row-major output")


def validate_mxfp4_args(args: argparse.Namespace) -> None:
    mxfp4_scale_path = getattr(args, "mxfp4_scale_path", "dma")
    if args.input_type == "mxfp4":
        if args.chip != "gfx950":
            sys.exit("--input-type=mxfp4 requires gfx950")
        if selected_matrix_intrinsic(args) != "mfma_gfx950":
            sys.exit("--input-type=mxfp4 requires gfx950 MFMA")
    else:
        if mxfp4_scale_path != "dma":
            sys.exit("--mxfp4-scale-path=regs requires --input-type=mxfp4")
    validate_aiter_mxfp4_args(args)


def validate_output_layout_args(args: argparse.Namespace) -> None:
    if (
        getattr(args, "coalesced_mfma_output", False)
        and effective_output_layout(args) != "column-major"
    ):
        sys.exit("coalesced MFMA output requires column-major output")


def _require_arg(condition: bool, message: str) -> None:
    if not condition:
        sys.exit(message)


def _has_valid_tensilelite_virtual_k(args: argparse.Namespace) -> bool:
    virtual_k_steps = compute_virtual_k_steps(args)
    return virtual_k_steps <= 1 or virtual_k_steps % 2 == 0


def _validate_tensilelite_example_args(args: argparse.Namespace) -> None:
    _require_arg(
        args.input_type == "mxfp4",
        "--example=tensilelite-subtile requires --input-type=mxfp4",
    )
    _require_arg(
        args.output_type == "f16",
        "--example=tensilelite-subtile requires --output-type=f16",
    )
    _require_arg(
        args.wave_k_tiles % 2 == 0,
        "--example=tensilelite-subtile requires even --wave-k-tiles",
    )
    _require_arg(
        args.wave_m_tiles % 2 == 0 and args.wave_n_tiles % 2 == 0,
        "--example=tensilelite-subtile requires even wave tile counts",
    )
    if selected_scale_input(args) == "tensilelite":
        _require_arg(
            _has_valid_tensilelite_virtual_k(args),
            "--scale-input=tensilelite requires even virtual K steps",
        )


def _checked_size_product(*values: int) -> int:
    result = 1
    for value in values:
        if value < 0 or (value and result > _SIZE_T_MAX // value):
            raise OverflowError("Stream-K workspace size exceeds size_t")
        result *= value
    return result


def streamk_workspace_sizes(m: int, n: int, workers: int) -> tuple[int, int]:
    scratch_bytes = _checked_size_product(
        workers,
        _STREAMK_PARTIAL_SLOTS,
        _STREAMK_TILE_ELEMENTS,
        4,
    )
    counter_bytes = _checked_size_product(m // 256, n // 256, 4)
    return scratch_bytes, counter_bytes


def _validate_streamk_target_and_shape(args: argparse.Namespace) -> None:
    _require_arg(args.chip == "gfx950", "--example=streamk-gemm requires gfx950")
    _require_arg(
        (args.input_type, args.output_type) == ("f16", "f16"),
        "--example=streamk-gemm requires f16 input and output",
    )
    _require_arg(
        selected_matrix_intrinsic(args) == "mfma_gfx950",
        "--example=streamk-gemm requires gfx950 MFMA",
    )
    _require_arg(
        all(0 < value <= _INT32_MAX for value in (args.m, args.n, args.k)),
        "--example=streamk-gemm dimensions must fit positive i32",
    )
    _require_arg(
        (args.m % 256, args.n % 256, args.k % 64) == (0, 0, 0),
        "--example=streamk-gemm requires M/N multiples of 256 and K of 64",
    )
    _require_arg(
        (
            args.bm,
            args.bn,
            args.wave_m_tiles,
            args.wave_n_tiles,
            args.wave_k_tiles,
        )
        == (2, 2, 8, 8, 2),
        "--example=streamk-gemm requires the 256x256x64 four-wave shape",
    )


def _validate_streamk_topology(args: argparse.Namespace, tile_count: int) -> None:
    _require_arg(
        args.cta_swizzle_xcds in (1, 2, 4, 8)
        and tile_count % args.cta_swizzle_xcds == 0,
        "--example=streamk-gemm requires a dividing gfx950 XCD count",
    )
    _require_arg(
        (args.m // 256) % args.cta_group_m == 0,
        "--example=streamk-gemm requires GROUP_SIZE_M to divide M tiles",
    )
    _require_arg(
        effective_output_layout(args) == "column-major",
        "--example=streamk-gemm requires column-major output",
    )


def _validate_streamk_buffer_ranges(args: argparse.Namespace) -> None:
    ranges = (
        ("A", args.m * args.k),
        ("B", args.n * args.k),
        ("C", args.m * args.n),
    )
    for name, elements in ranges:
        _require_arg(
            elements * 2 <= _UINT32_MAX,
            f"--example=streamk-gemm {name} buffer range exceeds u32",
        )


def _validate_streamk_work(args: argparse.Namespace, tile_count: int) -> None:
    total_iterations = tile_count * (args.k // 64)
    _require_arg(
        total_iterations <= _INT32_MAX,
        "--example=streamk-gemm work index exceeds i32",
    )
    _require_arg(
        1 <= args.streamk_workers <= total_iterations,
        f"--streamk-workers must be in [1, {total_iterations}]",
    )
    try:
        streamk_workspace_sizes(args.m, args.n, args.streamk_workers)
    except OverflowError as exc:
        raise SystemExit(str(exc)) from exc


def _validate_streamk_gemm_args(args: argparse.Namespace) -> None:
    _validate_streamk_target_and_shape(args)
    tile_count = (args.m // 256) * (args.n // 256)
    _validate_streamk_topology(args, tile_count)
    _validate_streamk_buffer_ranges(args)
    _validate_streamk_work(args, tile_count)


def _validate_persistent_gemm_args(args: argparse.Namespace) -> None:
    _require_arg(args.chip == "gfx950", "--example=persistent-gemm requires gfx950")
    _require_arg(
        args.input_type == "f16" and args.output_type == "f16",
        "--example=persistent-gemm requires f16 input and output",
    )
    _require_arg(
        selected_matrix_intrinsic(args) == "mfma_gfx950",
        "--example=persistent-gemm requires gfx950 MFMA",
    )
    _require_arg(
        args.m % 256 == 0 and args.n % 256 == 0 and args.k % 32 == 0,
        "--example=persistent-gemm requires M/N multiples of 256 and K of 32",
    )
    _require_arg(
        (
            args.bm == 4
            and args.bn == 4
            and args.wave_m_tiles == 4
            and args.wave_n_tiles == 4
            and args.wave_k_tiles == 1
        ),
        "--example=persistent-gemm requires the 256x256x32 16-wave shape",
    )
    _require_arg(
        args.cta_swizzle_xcds == 8 and args.cta_group_m == 4,
        "--example=persistent-gemm requires NUM_XCDS=8 and GROUP_SIZE_M=4",
    )
    _require_arg(
        args.output_layout == "column-major",
        "--example=persistent-gemm requires column-major output",
    )
    _require_arg(
        0 <= args.persistent_poll_sleep_cycles <= 15,
        "--persistent-poll-sleep-cycles must be in [0, 15]",
    )


def _validate_v9_perf_golden_args(args: argparse.Namespace) -> None:
    _require_arg(args.chip == "gfx950", "--example=v9-perf-golden requires gfx950")
    _require_arg(
        args.input_type == "f16",
        "--example=v9-perf-golden requires --input-type=f16",
    )
    _require_arg(
        args.output_type == "f16",
        "--example=v9-perf-golden requires --output-type=f16",
    )
    _require_arg(
        selected_matrix_intrinsic(args) == "mfma_gfx950",
        "--example=v9-perf-golden requires gfx950 MFMA",
    )
    _require_arg(args.k == 4096, "--example=v9-perf-golden is frozen for --k=4096")
    _require_arg(
        args.m % 256 == 0 and args.n % 256 == 0,
        "--example=v9-perf-golden requires M/N multiples of 256",
    )
    _require_arg(
        (
            args.bm == 4
            and args.bn == 2
            and args.wave_m_tiles == 4
            and args.wave_n_tiles == 8
            and args.wave_k_tiles == 2
        ),
        "--example=v9-perf-golden requires the v9 256x256x64 tile shape",
    )
    _require_arg(
        args.cta_swizzle_xcds == 8 and args.cta_group_m == 4,
        "--example=v9-perf-golden requires NUM_XCDS=8 and GROUP_SIZE_M=4",
    )


def _validate_tlx_mxfp_perf_golden_args(args: argparse.Namespace) -> None:
    _require_arg(
        args.chip == "gfx950",
        "--example=tlx-mxfp-perf-golden requires gfx950",
    )
    _require_arg(
        args.input_type == "mxfp4",
        "--example=tlx-mxfp-perf-golden requires --input-type=mxfp4",
    )
    _require_arg(
        args.output_type == "bf16",
        "--example=tlx-mxfp-perf-golden requires --output-type=bf16",
    )
    _require_arg(
        selected_matrix_intrinsic(args) == "mfma_gfx950",
        "--example=tlx-mxfp-perf-golden requires gfx950 MFMA",
    )
    _require_arg(
        args.k == 16384,
        "--example=tlx-mxfp-perf-golden is frozen for --k=16384",
    )
    _require_arg(
        args.m % 256 == 0 and args.n % 256 == 0,
        "--example=tlx-mxfp-perf-golden requires M/N multiples of 256",
    )
    _require_arg(
        effective_output_layout(args) == "row-major",
        "--example=tlx-mxfp-perf-golden requires row-major output",
    )
    _require_arg(
        (
            args.bm == 2
            and args.bn == 2
            and args.wave_m_tiles == 8
            and args.wave_n_tiles == 8
            and args.wave_k_tiles == 2
        ),
        "--example=tlx-mxfp-perf-golden requires the TLX 256x256x256 tile shape",
    )
    _require_arg(
        args.cta_swizzle_xcds == 8 and args.cta_group_m == 4,
        "--example=tlx-mxfp-perf-golden requires NUM_XCDS=8 and GROUP_SIZE_M=4",
    )


def validate_example_args(args: argparse.Namespace) -> None:
    if is_streamk_gemm(args):
        _validate_streamk_gemm_args(args)
        return
    if is_persistent_gemm(args):
        _validate_persistent_gemm_args(args)
        return
    if selected_example(args) == "matmul":
        _require_arg(
            selected_scale_input(args) == "canonical",
            "--scale-input=tensilelite requires --example=tensilelite-subtile",
        )
        _require_arg(
            args.output_type != "bf16",
            "--output-type=bf16 requires --example=tlx-mxfp-perf-golden",
        )
        return
    if is_v9_perf_golden(args):
        _validate_v9_perf_golden_args(args)
        return
    if is_tlx_mxfp_perf_golden(args):
        _validate_tlx_mxfp_perf_golden_args(args)
        return
    _validate_tensilelite_example_args(args)


def validate_tool_output_args(args: argparse.Namespace) -> None:
    emit_asm = getattr(args, "emit_asm", None)
    emit_hsaco = getattr(args, "emit_hsaco", None)
    run_hsaco = getattr(args, "run_hsaco", None)
    has_tool_output = (
        emit_asm is not None or emit_hsaco is not None or run_hsaco is not None
    )
    if has_tool_output and len(args.variants) != 1:
        sys.exit("--emit-asm/--emit-hsaco/--run-hsaco require one --variants entry")
    validate_run_hsaco_args(args, emit_asm, emit_hsaco, run_hsaco)


def validate_run_hsaco_args(
    args: argparse.Namespace,
    emit_asm: Path | None,
    emit_hsaco: Path | None,
    run_hsaco: Path | None,
) -> None:
    if run_hsaco is None:
        return
    if args.skip_hw:
        sys.exit("--run-hsaco cannot be combined with --skip-hw")
    if emit_asm is not None or emit_hsaco is not None:
        sys.exit("--run-hsaco cannot be combined with --emit-asm/--emit-hsaco")
    if getattr(args, "emit_mlir", None) is not None:
        sys.exit("--run-hsaco cannot be combined with --emit-mlir")
    if not run_hsaco.exists():
        sys.exit(f"HSACO not found: {run_hsaco}")


def validate_streamk_runtime_args(args: argparse.Namespace) -> None:
    if not is_streamk_gemm(args) and getattr(args, "streamk_workers", 1) != 1:
        sys.exit("--streamk-workers requires --example=streamk-gemm")


def validate_input_mode_args(args: argparse.Namespace) -> None:
    if input_mode_name(args) in ("rand-int", "hpl") and args.input_type == "mxfp4":
        sys.exit("--rand-int/--hpl support f16/bf16 inputs only")


def validate_matmul_target_args(args: argparse.Namespace) -> None:
    profile = matmul_target_profile(args)
    selected_matrix_intrinsic(args)
    if profile is None:
        return
    requires_dma_lds = profile.staging.value != "base"
    _require_arg(
        args.use_dma_lds == requires_dma_lds,
        f"{profile.chip} profile requires {profile.staging.value} staging",
    )
    _require_arg(
        effective_target_waves(args) <= profile.max_waves_per_eu,
        f"target waves exceed {profile.chip} capacity",
    )
    _require_arg(
        compute_lds_bytes(args) <= profile.static_lds_limit_bytes,
        f"LDS allocation exceeds {profile.chip} capacity",
    )


def validate_args(args: argparse.Namespace) -> None:
    if args.iters <= 0:
        sys.exit("--iters must be positive")
    if args.warmup < 0:
        sys.exit("--warmup must be non-negative")
    if args.repeats <= 0:
        sys.exit("--repeats must be positive")
    if args.target_waves < 0:
        sys.exit("--target-waves must be non-negative")
    if args.cta_swizzle_xcds < 1:
        sys.exit("--cta-swizzle-xcds must be >= 1")
    if args.cta_group_m < 1:
        sys.exit("--cta-group-m must be >= 1")
    if getattr(args, "sim_trip_count", DEFAULT_SIM_TRIP_COUNT) < -1:
        sys.exit("--sim-trip-count must be >= -1")
    if args.calibration_file is not None and not args.calibration_file.exists():
        sys.exit(f"--calibration-file does not exist: {args.calibration_file}")
    validate_streamk_runtime_args(args)
    validate_input_mode_args(args)
    validate_tool_output_args(args)
    validate_example_args(args)
    validate_mxfp4_args(args)
    validate_output_layout_args(args)
    validate_matmul_target_args(args)


def prepare_source(args: argparse.Namespace, chip: str, tmp: Path) -> Path | None:
    if args.run_hsaco is not None:
        return None
    source = tmp / "matmul_kernel.mlir"
    source.write_text(generate_kernel_module(args, chip))
    if args.emit_mlir is not None:
        args.emit_mlir.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, args.emit_mlir)
    return source


def prepare_runner(args: argparse.Namespace, tmp: Path) -> Path | None:
    if args.skip_hw or args.emit_hsaco is not None:
        return None
    return compile_runner(args, tmp)


def print_header(args: argparse.Namespace, chip: str) -> None:
    print(
        f"chip: {chip}\n"
        f"shape: m={args.m} n={args.n} k={args.k} bm={args.bm} bn={args.bn} "
        f"wave_m_tiles={args.wave_m_tiles} wave_n_tiles={args.wave_n_tiles} "
        f"wave_k_tiles={args.wave_k_tiles} "
        f"target_waves={effective_target_waves(args)} "
        f"input_type={args.input_type} output_type={args.output_type} "
        f"mxfp4_scale_path={args.mxfp4_scale_path} "
        f"mxfp4_input_layout={args.mxfp4_input_layout} "
        f"output_store_cache={args.output_store_cache} "
        f"example={selected_example(args)} "
        f"scale_input={selected_scale_input(args)} "
        f"kernel_abi={kernel_abi(args)} "
        f"seed={args.seed} input_mode={input_mode_name(args)}\n"
        f"cta_swizzle_xcds={args.cta_swizzle_xcds} "
        f"cta_group_m={args.cta_group_m}\n"
        f"kernel_arg_trip_count: {kernel_arg_trip_count_text(args)}\n"
        f"sim_loop_trip_count: {compute_sim_loop_trip_count(args)}\n"
        f"sim_report_trip_count: {compute_report_trip_count(args)}"
    )
    if is_streamk_gemm(args):
        scratch_bytes, counter_bytes = streamk_workspace_sizes(
            args.m, args.n, args.streamk_workers
        )
        print(
            f"streamk_workers={args.streamk_workers} "
            f"scratch_bytes={scratch_bytes} counter_bytes={counter_bytes}"
        )
    if is_persistent_gemm(args):
        print(
            f"persistent_completion={args.persistent_completion} "
            f"poll_sleep_cycles={args.persistent_poll_sleep_cycles}"
        )


def run_variants(
    args: argparse.Namespace,
    source: Path | None,
    runner: Path | None,
    tmp: Path,
) -> list[VariantResult]:
    results: list[VariantResult] = []
    for variant in args.variants:
        result = run_variant(
            variant,
            args,
            source,
            runner,
            tmp,
            emit_asm=args.emit_asm,
            emit_hsaco=args.emit_hsaco,
        )
        print_result(result)
        results.append(result)
    return results


def main() -> int:
    args = parse_args(sys.argv[1:])
    chip = resolve_chip(args)
    validate_args(args)
    tmp_ctx = None if args.keep_tmp else tempfile.TemporaryDirectory()
    tmp = Path(tempfile.mkdtemp() if args.keep_tmp else tmp_ctx.name)
    try:
        source = prepare_source(args, chip, tmp)
        if (
            args.emit_mlir is not None
            and args.emit_asm is None
            and args.emit_hsaco is None
        ):
            return 0
        runner = prepare_runner(args, tmp)
        print_header(args, chip)
        results = run_variants(args, source, runner, tmp)
        print_delta(results)
        if args.keep_tmp:
            print(f"tmp: {tmp}")
    finally:
        if tmp_ctx is not None:
            tmp_ctx.cleanup()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
