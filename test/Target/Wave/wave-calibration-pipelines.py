# RUN: %python %s %wave_pipelines | FileCheck %s

# CHECK: matmul_pipeline: ok
# CHECK: fa_pipeline: ok
# CHECK: matmul_explicit_gfx950_wave_size: ok
# CHECK: matmul_auto_gfx950_wave_size: ok
# CHECK: matmul_runner_gfx950_wave_size: ok
# CHECK: matmul_bf16_forwarding: ok
# CHECK: matmul_mxfp4_forwarding_and_trip_count: ok
# CHECK: matmul_mxfp4_dma_forwarding: ok
# CHECK: matmul_mxfp4_scale_regs_forwarding: ok
# CHECK: matmul_mxfp4_profile_kernel_only_target_waves: ok
# CHECK: matmul_profile_cli_override: ok
# CHECK: matmul_mxfp4_4wave_profile: ok
# CHECK: matmul_dynamic_lds_forwarding: ok
# CHECK: matmul_f16_dma_buffer_count: ok
# CHECK: matmul_dma_sim_trip_count: ok
# CHECK: matmul_v9_perf_golden_profile: ok
# CHECK: matmul_v9_transposed_perf_golden_profile: ok
# CHECK: matmul_a4w4_mxfp_k16k_1_profile: ok
# CHECK: matmul_a4w4_mxfp_k16k_2_profile: ok
# CHECK: matmul_a4w4_mxfp_k16k_3_profile: ok
# CHECK: matmul_perf_sweep_v9_defaults: ok
# CHECK: matmul_perf_sweep_precompile_plan: ok
# CHECK: calibration_scheduler_region_cap: ok
# CHECK: matmul_pingpong_removed: ok

from __future__ import annotations

import argparse
import importlib.util
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
PIPELINE_PATH = Path(sys.argv[1])
BUILD_DIR = PIPELINE_PATH.parents[3]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def require(label: str, condition: bool, message: str) -> None:
    if not condition:
        print(f"{label}: {message}", file=sys.stderr)
        raise SystemExit(1)


def find_named_sequence(ir, module, name: str):
    for op in module.body.operations:
        attr = op.attributes.get("sym_name")
        if attr is not None and ir.StringAttr(attr).value == name:
            return op
    return None


def body_ops(named_sequence):
    return list(named_sequence.regions[0].blocks[0].operations)


def applied_passes(ir, named_sequence) -> list[str]:
    out: list[str] = []
    for op in body_ops(named_sequence):
        if op.name != "transform.apply_registered_pass":
            continue
        out.append(ir.StringAttr(op.attributes["pass_name"]).value)
    return out


def included_sequences(ir, named_sequence) -> list[str]:
    out: list[str] = []
    for op in body_ops(named_sequence):
        if op.name != "transform.include":
            continue
        out.append(ir.FlatSymbolRefAttr(op.attributes["target"]).value)
    return out


def require_pass_order(label: str, passes: list[str], names: list[str], message: str):
    try:
        positions = [passes.index(name) for name in names]
    except ValueError as err:
        require(label, False, f"missing pass: {err}")
    require(label, positions == sorted(positions), message)


def require_sequence(ir, parsed, label: str, name: str):
    sequence = find_named_sequence(ir, parsed, name)
    require(label, sequence is not None, f"missing {name}")
    return sequence


def check_backend_entry(label: str, ir, entry) -> None:
    includes = included_sequences(ir, entry)
    require(
        label,
        "waveamd_backend_preschedule" in includes,
        "no preschedule include",
    )
    require(
        label,
        "waveamd_backend_postschedule" in includes,
        "no postschedule include",
    )
    require(
        label,
        includes.index("waveamd_backend_preschedule")
        < includes.index("waveamd_backend_postschedule"),
        "backend include order drifted",
    )
    entry_passes = applied_passes(ir, entry)
    require_pass_order(
        label,
        entry_passes,
        ["waveamd-machine-schedule-report", "waveamd-machine-schedule"],
        "scheduler report/order drifted",
    )
    require(
        label,
        "waveamd-insert-hazard-waits" not in entry_passes,
        "entry spells hazard waits",
    )


def check_preschedule(label: str, ir, preschedule) -> None:
    includes = included_sequences(ir, preschedule)
    require(label, "waveamd_backend_lower" in includes, "no lower include")
    preschedule_passes = applied_passes(ir, preschedule)
    require_pass_order(
        label,
        preschedule_passes,
        [
            "waveamd-split-barriers",
            "waveamd-mma-reuse-preschedule",
            "waveamd-scalar-mask-preschedule",
            "waveamd-hazard-repair",
        ],
        "preschedule pass order drifted",
    )


def check_postschedule(label: str, ir, postschedule) -> None:
    postschedule_passes = applied_passes(ir, postschedule)
    require_pass_order(
        label,
        postschedule_passes,
        ["waveamd-barrier-cleanup", "waveamd-materialize-split-barriers"],
        "postschedule pass order drifted",
    )
    includes = included_sequences(ir, postschedule)
    require(label, "waveamd_backend_finish" in includes, "no finish include")


def check_backend_lower(label: str, lower_passes: list[str]) -> None:
    try:
        decompose = lower_passes.index("waveamd-decompose-mem-tuples")
        pair_ds = lower_passes.index("waveamd-pair-ds-ops")
        fused = lower_passes.index("waveamd-form-fused-int")
        cross_lane = lower_passes.index("waveamd-cross-lane-peepholes")
        cleanup = lower_passes.index("waveamd-machine-cleanup")
        cleanup_canon = lower_passes.index("canonicalize", cleanup)
        cleanup_cse = lower_passes.index("cse", cleanup_canon)
        cleanup_licm = lower_passes.index("loop-invariant-code-motion", cleanup_cse)
        cleanup_final_cse = lower_passes.index("cse", cleanup_licm)
    except ValueError as err:
        require(label, False, f"missing lower pass: {err}")
    require(
        label,
        decompose
        < pair_ds
        < fused
        < cross_lane
        < cleanup
        < cleanup_canon
        < cleanup_cse
        < cleanup_licm
        < cleanup_final_cse,
        "cleanup pass order drifted",
    )


def check_default_finish(label: str, ir, finish) -> None:
    finish_includes = included_sequences(ir, finish)
    require(
        label,
        "waveamd_backend_finish_transform_regalloc" in finish_includes,
        "default finish does not use transform regalloc",
    )


def check_transform_finish(label: str, ir, transform_finish) -> None:
    transform_finish_passes = applied_passes(ir, transform_finish)
    require_pass_order(
        label,
        transform_finish_passes,
        [
            "waveamd-clear-regalloc-assignments",
            "waveamd-preserve-hw-regs",
            "canonicalize",
            "cse",
        ],
        "transform finish cleanup order drifted",
    )
    transform_finish_includes = included_sequences(ir, transform_finish)
    require(
        label,
        "waveamd_regalloc_transform_loop" in transform_finish_includes,
        "transform finish does not include regalloc loop",
    )
    require(
        label,
        "waveamd_backend_post_regalloc" in transform_finish_includes,
        "transform finish skips post-regalloc tail",
    )
    require(
        label,
        transform_finish_includes.index("waveamd_regalloc_transform_loop")
        < transform_finish_includes.index("waveamd_backend_post_regalloc"),
        "transform finish include order drifted",
    )


def check_post_regalloc(label: str, post_passes: list[str]) -> None:
    require_pass_order(
        label,
        post_passes,
        [
            "waveamd-decompose-mem-tuples",
            "waveamd-pair-ds-ops",
            "waveamd-pack-vgpr-zero-moves",
            "waveamd-insert-ticket-waits",
            "waveamd-insert-hazard-waits",
            "waveamd-resource-info",
            "waveamd-verify-machine-operands",
            "waveamd-metadata",
        ],
        "post-regalloc pass order drifted",
    )


def check_calibration_entry(label: str, module) -> None:
    text = module.pipeline_text(
        BUILD_DIR,
        schedule_options={"apply-schedule": True},
        report_options={"print-candidates": True},
    )
    ir, _, register_dialects = module.import_mlir_bindings(BUILD_DIR)
    with ir.Context() as ctx:
        register_dialects(ctx)
        parsed = ir.Module.parse(text)
        entry = require_sequence(ir, parsed, label, "__transform_main")
        preschedule = require_sequence(ir, parsed, label, "waveamd_backend_preschedule")
        postschedule = require_sequence(
            ir, parsed, label, "waveamd_backend_postschedule"
        )
        lower = require_sequence(ir, parsed, label, "waveamd_backend_lower")
        finish = require_sequence(ir, parsed, label, "waveamd_backend_finish")
        transform_finish = require_sequence(
            ir, parsed, label, "waveamd_backend_finish_transform_regalloc"
        )
        post = require_sequence(ir, parsed, label, "waveamd_backend_post_regalloc")
        require_sequence(ir, parsed, label, "waveamd_regalloc_transform_loop")
        check_backend_entry(label, ir, entry)
        check_preschedule(label, ir, preschedule)
        check_postschedule(label, ir, postschedule)
        check_backend_lower(label, applied_passes(ir, lower))
        check_default_finish(label, ir, finish)
        check_transform_finish(label, ir, transform_finish)
        check_post_regalloc(label, applied_passes(ir, post))
    print(f"{label}: ok")


def check_matmul_wave_size(matmul) -> None:
    explicit = argparse.Namespace(chip="gfx950", matrix_intrinsic="auto")
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.kernel_wave_size(explicit) == 64,
        "explicit gfx950 should use wave64",
    )
    forced = argparse.Namespace(chip="gfx1100", matrix_intrinsic="mfma_gfx950")
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.kernel_wave_size(forced) == 64,
        "explicit mfma_gfx950 should use wave64",
    )
    rdna = argparse.Namespace(chip="gfx1100", matrix_intrinsic="auto")
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.kernel_wave_size(rdna) == 32,
        "gfx1100 auto should use wave32",
    )
    print("matmul_explicit_gfx950_wave_size: ok")

    auto = argparse.Namespace(chip="", matrix_intrinsic="auto")
    old_detect = matmul.detect_chip
    try:
        matmul.detect_chip = lambda: "gfx950"
        chip = matmul.resolve_chip(auto)
    finally:
        matmul.detect_chip = old_detect
    require("matmul_auto_gfx950_wave_size", chip == "gfx950", "bad resolved chip")
    require(
        "matmul_auto_gfx950_wave_size",
        auto.chip == "gfx950",
        "resolved chip not stored",
    )
    require(
        "matmul_auto_gfx950_wave_size",
        matmul.kernel_wave_size(auto) == 64,
        "auto gfx950 should use wave64",
    )
    print("matmul_auto_gfx950_wave_size: ok")


def check_matmul_runner_wave_size(matmul) -> None:
    args = argparse.Namespace(
        m=32,
        n=32,
        k=64,
        bm=1,
        bn=2,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=1,
        matrix_intrinsic="auto",
        chip="gfx950",
        input_type="f16",
        output_type="f32",
        iters=1,
        warmup=0,
        no_check=True,
    )
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require("matmul_runner_gfx950_wave_size", bool(captured), "runner not called")
    cmd = captured[0]
    require(
        "matmul_runner_gfx950_wave_size",
        "--wave-size" in cmd,
        "missing --wave-size",
    )
    index = cmd.index("--wave-size")
    require(
        "matmul_runner_gfx950_wave_size",
        cmd[index + 1] == "64",
        "runner should receive wave64",
    )
    print("matmul_runner_gfx950_wave_size: ok")


def check_matmul_bf16_forwarding(matmul) -> None:
    args = argparse.Namespace(
        m=32,
        n=32,
        k=64,
        bm=1,
        bn=2,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=1,
        use_buffer=False,
        use_dma_lds=False,
        matrix_intrinsic="mfma_gfx950",
        chip="gfx950",
        input_type="bf16",
        output_type="f32",
        target_waves=0,
        iters=1,
        warmup=0,
        no_check=True,
    )
    example_cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_bf16_forwarding",
        "--input-type=bf16" in example_cmd,
        "example command missing bf16 input type",
    )

    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require("matmul_bf16_forwarding", bool(captured), "runner not called")
    cmd = captured[0]
    require(
        "matmul_bf16_forwarding",
        "--input-type" in cmd,
        "runner command missing --input-type",
    )
    index = cmd.index("--input-type")
    require(
        "matmul_bf16_forwarding",
        cmd[index + 1] == "bf16",
        "runner should receive bf16",
    )
    print("matmul_bf16_forwarding: ok")


def make_mxfp4_args() -> argparse.Namespace:
    return argparse.Namespace(
        m=16,
        n=16,
        k=256,
        bm=1,
        bn=1,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=1,
        use_buffer=False,
        use_dma_lds=False,
        matrix_intrinsic="auto",
        chip="gfx950",
        input_type="mxfp4",
        output_type="f32",
        mxfp4_scale_path="dma",
        cta_swizzle_xcds=1,
        cta_group_m=1,
        target_waves=0,
        iters=1,
        warmup=0,
        no_check=True,
    )


def check_mxfp4_trip_count(matmul, args: argparse.Namespace) -> None:
    example_cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        "--input-type=mxfp4" in example_cmd,
        "example command missing mxfp4 input type",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        matmul.mma_k_tile(args) == 128,
        "MXFP4 should use K tile 128",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        matmul.compute_kernel_arg_trip_count(args) == 1,
        "MXFP4 kernel arg trip count should be K/128 - 1",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        matmul.compute_sim_loop_trip_count(args) == 1,
        "MXFP4 sim trip count should be K/128 - 1",
    )


def check_mxfp4_target_validation(matmul, args: argparse.Namespace) -> None:
    validate_args = argparse.Namespace(
        **vars(args),
        repeats=1,
        calibration_file=None,
        pressure_vgpr_budget=-1,
        pressure_sgpr_budget=-1,
        pressure_critical_vgpr_budget=-1,
        pressure_critical_sgpr_budget=-1,
    )
    validate_args.chip = "gfx1100"
    try:
        matmul.validate_args(validate_args)
    except SystemExit:
        pass
    else:
        require(
            "matmul_mxfp4_forwarding_and_trip_count",
            False,
            "MXFP4 should reject non-gfx950 targets",
        )


def check_mxfp4_runner_forwarding(matmul, args: argparse.Namespace) -> None:
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        bool(captured),
        "runner not called",
    )
    cmd = captured[0]
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        "--input-type" in cmd,
        "runner command missing --input-type",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        cmd[cmd.index("--input-type") + 1] == "mxfp4",
        "runner should receive mxfp4",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        "--wave-size" in cmd,
        "runner command missing --wave-size",
    )
    require(
        "matmul_mxfp4_forwarding_and_trip_count",
        cmd[cmd.index("--wave-size") + 1] == "64",
        "runner should receive wave64",
    )


def check_matmul_mxfp4_forwarding_and_trip_count(matmul) -> None:
    args = make_mxfp4_args()
    check_mxfp4_trip_count(matmul, args)
    check_mxfp4_target_validation(matmul, args)
    check_mxfp4_runner_forwarding(matmul, args)
    print("matmul_mxfp4_forwarding_and_trip_count: ok")


def check_matmul_mxfp4_dma_forwarding(matmul) -> None:
    args = make_mxfp4_args()
    args.use_dma_lds = True
    validate_args = argparse.Namespace(
        **vars(args),
        repeats=1,
        calibration_file=None,
        pressure_vgpr_budget=-1,
        pressure_sgpr_budget=-1,
        pressure_critical_vgpr_budget=-1,
        pressure_critical_sgpr_budget=-1,
    )
    matmul.validate_args(validate_args)
    example_cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_mxfp4_dma_forwarding",
        "--input-type=mxfp4" in example_cmd,
        "example command missing mxfp4 input type",
    )
    require(
        "matmul_mxfp4_dma_forwarding",
        "--use-dma-lds" in example_cmd,
        "example command missing DMA LDS flag",
    )
    require(
        "matmul_mxfp4_dma_forwarding",
        matmul.compute_sim_loop_trip_count(args) == 0,
        "MXFP4 DMA sim trip count should use V - 2",
    )
    print("matmul_mxfp4_dma_forwarding: ok")


def check_matmul_mxfp4_scale_regs_forwarding(matmul) -> None:
    args = make_mxfp4_args()
    args.use_dma_lds = True
    args.mxfp4_scale_path = "regs"
    matmul.validate_args(
        argparse.Namespace(
            **vars(args),
            repeats=1,
            calibration_file=None,
            pressure_vgpr_budget=-1,
            pressure_sgpr_budget=-1,
            pressure_critical_vgpr_budget=-1,
            pressure_critical_sgpr_budget=-1,
        )
    )
    example_cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_mxfp4_scale_regs_forwarding",
        "--mxfp4-scale-path=regs" in example_cmd,
        "example command missing MXFP4 scale regs flag",
    )
    print("matmul_mxfp4_scale_regs_forwarding: ok")


def check_matmul_mxfp4_profile_kernel_only_target_waves(matmul) -> None:
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-mxfp4-256x256-8wave",
            "--k=256",
            "--skip-hw",
            "--no-check",
        ]
    )
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        args.bm == 4 and args.bn == 2,
        "bad MXFP4 profile workgroup shape",
    )
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        args.input_type == "mxfp4" and args.output_type == "f16",
        "bad MXFP4 profile dtypes",
    )
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        matmul.effective_target_waves(args) == 2,
        "8-wave workgroup should derive 2 target waves per SIMD",
    )
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        matmul.compute_dynamic_lds_bytes(args) == 81920,
        "bad MXFP4 DMA LDS byte accounting",
    )
    example_cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        "--kernel-only" in example_cmd,
        "calibration should request kernel-only example IR",
    )
    require(
        "matmul_mxfp4_profile_kernel_only_target_waves",
        "--target-waves=2" in example_cmd,
        "calibration should forward derived target waves",
    )
    print("matmul_mxfp4_profile_kernel_only_target_waves: ok")


def check_matmul_profile_cli_override(matmul) -> None:
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-mxfp4-256x256-8wave",
            "--wave-k-tiles=1",
            "--skip-hw",
        ]
    )
    require(
        "matmul_profile_cli_override",
        args.input_type == "mxfp4" and args.output_type == "f16",
        "profile defaults not applied",
    )
    require(
        "matmul_profile_cli_override",
        args.wave_k_tiles == 1,
        "explicit wave_k_tiles should override profile default",
    )
    print("matmul_profile_cli_override: ok")


def check_matmul_mxfp4_4wave_profile(matmul) -> None:
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-mxfp4-256x256-4wave",
            "--m=256",
            "--n=256",
            "--k=256",
            "--skip-hw",
        ]
    )
    require(
        "matmul_mxfp4_4wave_profile",
        args.bm == 2 and args.bn == 2,
        "bad 4-wave workgroup shape",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        args.wave_m_tiles == 8 and args.wave_n_tiles == 8,
        "bad 4-wave wave tile shape",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        args.wave_k_tiles == 2,
        "bad 4-wave K tile shape",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        args.input_type == "mxfp4" and args.output_type == "f16",
        "bad 4-wave dtypes",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        args.mxfp4_scale_path == "regs",
        "bad 4-wave scale path",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        matmul.effective_target_waves(args) == 1,
        "4-wave profile should request one wave per SIMD",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        matmul.compute_lds_bytes(args) == 81920,
        "bad 4-wave LDS byte accounting",
    )
    print("matmul_mxfp4_4wave_profile: ok")


def check_matmul_dynamic_lds_forwarding(matmul) -> None:
    args = argparse.Namespace(
        m=64,
        n=64,
        k=64,
        bm=4,
        bn=4,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=2,
        use_buffer=False,
        use_dma_lds=False,
        matrix_intrinsic="mfma_gfx950",
        chip="gfx950",
        input_type="f16",
        output_type="f32",
        cta_swizzle_xcds=1,
        cta_group_m=1,
        target_waves=0,
        iters=1,
        warmup=0,
        no_check=True,
    )
    require(
        "matmul_dynamic_lds_forwarding",
        matmul.compute_lds_bytes(args) == 65536,
        "bad dynamic LDS fixture",
    )
    require(
        "matmul_dynamic_lds_forwarding",
        matmul.compute_dynamic_lds_bytes(args) == 65536,
        "dynamic LDS threshold not applied",
    )
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require("matmul_dynamic_lds_forwarding", bool(captured), "runner not called")
    cmd = captured[0]
    require(
        "matmul_dynamic_lds_forwarding",
        "--dynamic-lds" in cmd,
        "runner command missing --dynamic-lds",
    )
    require(
        "matmul_dynamic_lds_forwarding",
        cmd[cmd.index("--dynamic-lds") + 1] == "65536",
        "runner should receive dynamic LDS bytes",
    )
    print("matmul_dynamic_lds_forwarding: ok")


def check_matmul_f16_dma_buffer_count(matmul) -> None:
    args = argparse.Namespace(
        m=4096,
        n=4096,
        k=8192,
        bm=4,
        bn=4,
        wave_m_tiles=4,
        wave_n_tiles=4,
        wave_k_tiles=1,
        use_buffer=True,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        chip="gfx950",
        input_type="f16",
        output_type="f16",
        cta_swizzle_xcds=8,
        cta_group_m=4,
        target_waves=0,
        iters=1,
        warmup=0,
        no_check=True,
    )
    require(
        "matmul_f16_dma_buffer_count",
        matmul.dma_buffer_count(args) == 4,
        "f16 DMA profile should use four data buffers",
    )
    require(
        "matmul_f16_dma_buffer_count",
        matmul.compute_dynamic_lds_bytes(args) == 131072,
        "bad f16 DMA LDS byte accounting",
    )
    print("matmul_f16_dma_buffer_count: ok")


def check_matmul_dma_sim_trip_count(matmul) -> None:
    base = argparse.Namespace(k=64, wave_k_tiles=2, use_dma_lds=False)
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_kernel_arg_trip_count(base) == 1,
        "kernel arg trip count drifted",
    )
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_sim_loop_trip_count(base) == 1,
        "non-DMA sim trip count should be V - 1",
    )

    dma = argparse.Namespace(k=64, wave_k_tiles=2, use_dma_lds=True)
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_kernel_arg_trip_count(dma) == 1,
        "DMA launch trip count should stay V - 1",
    )
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_sim_loop_trip_count(dma) == 0,
        "DMA sim trip count should be V - 2",
    )

    large = argparse.Namespace(
        k=32768,
        wave_k_tiles=1,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        chip="gfx950",
        input_type="f16",
    )
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_sim_loop_trip_count(large) == 1022,
        "large natural sim trip count should stay exact",
    )
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_report_trip_count(large) == matmul.DEFAULT_SIM_TRIP_COUNT,
        "default report trip count should be capped",
    )
    large.sim_trip_count = 7
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_report_trip_count(large) == 7,
        "explicit report trip count should override default cap",
    )
    large.sim_trip_count = -1
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_report_trip_count(large) == 1022,
        "negative report trip count should request full natural count",
    )

    gfx950 = argparse.Namespace(
        k=64,
        wave_k_tiles=1,
        use_dma_lds=False,
        matrix_intrinsic="auto",
        chip="gfx950",
        input_type="f16",
    )
    require(
        "matmul_dma_sim_trip_count",
        matmul.compute_kernel_arg_trip_count(gfx950) == 1,
        "gfx950 f16 should use K/32 - 1",
    )

    report_args = argparse.Namespace(
        k=96,
        wave_k_tiles=2,
        use_dma_lds=True,
        bm=2,
        bn=2,
        calibration_file=None,
    )
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "total_cycles: 7\n"

        matmul.run = fake_run
        matmul.run_sim_report(Path("build"), Path("machine.mlir"), report_args)
    finally:
        matmul.run = old_run
    require("matmul_dma_sim_trip_count", bool(captured), "sim report not called")
    require(
        "matmul_dma_sim_trip_count",
        all("--trip-count=1" in cmd for cmd in captured),
        "DMA sim reports should use V - 2",
    )
    print("matmul_dma_sim_trip_count: ok")


def make_v9_perf_golden_args(
    matmul, profile: str = "v9-4096-original-wave"
) -> argparse.Namespace:
    return matmul.parse_args(
        [
            "--chip=gfx950",
            f"--kernel-profile={profile}",
            "--skip-hw",
            "--no-check",
        ]
    )


def check_v9_profile_shape(matmul, args: argparse.Namespace) -> None:
    require(
        "matmul_v9_perf_golden_profile",
        args.example == "v9-perf-golden",
        "profile should select v9 golden IR",
    )
    require(
        "matmul_v9_perf_golden_profile",
        args.m == 4096 and args.n == 4096 and args.k == 4096,
        "bad v9 default shape",
    )
    require(
        "matmul_v9_perf_golden_profile",
        args.bm == 4
        and args.bn == 2
        and args.wave_m_tiles == 4
        and args.wave_n_tiles == 8
        and args.wave_k_tiles == 2,
        "bad v9 tile shape",
    )
    require(
        "matmul_v9_perf_golden_profile",
        matmul.kernel_name(args) == "v9_beyond_hotloop",
        "bad v9 kernel symbol",
    )
    require(
        "matmul_v9_perf_golden_profile",
        matmul.kernel_abi(args) == "v9-golden",
        "bad v9 kernel ABI",
    )


def check_v9_profile_counts(matmul, args: argparse.Namespace) -> None:
    require(
        "matmul_v9_perf_golden_profile",
        matmul.compute_dynamic_lds_bytes(args) == 0,
        "v9 golden has static LDS",
    )
    require(
        "matmul_v9_perf_golden_profile",
        matmul.compute_kernel_arg_trip_count(args) == 0,
        "v9 golden should not expose generated-matmul trip arg",
    )
    require(
        "matmul_v9_perf_golden_profile",
        matmul.compute_sim_loop_trip_count(args) == 31,
        "v9 golden should report step-2 loop body count",
    )
    require(
        "matmul_v9_perf_golden_profile",
        matmul.compute_report_trip_count(args) == 31,
        "v9 golden report count should use natural loop count",
    )


def check_v9_source_isolation(matmul, args: argparse.Namespace) -> None:
    source = matmul.generate_kernel_module(args, "gfx950")
    require(
        "matmul_v9_perf_golden_profile",
        "func.func @v9_beyond_hotloop" in source
        and "gpu.module @kernels" not in source,
        "v9 source should be isolated for wave-translate",
    )


def check_v9_runner_forwarding(matmul, args: argparse.Namespace) -> None:
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require("matmul_v9_perf_golden_profile", bool(captured), "runner not called")
    cmd = captured[0]
    require(
        "matmul_v9_perf_golden_profile",
        "--kernel-abi" in cmd and cmd[cmd.index("--kernel-abi") + 1] == "v9-golden",
        "runner should receive v9 ABI",
    )
    require(
        "matmul_v9_perf_golden_profile",
        cmd[-1] == "v9_beyond_hotloop",
        "runner should launch v9 symbol",
    )
    require(
        "matmul_v9_perf_golden_profile",
        "--dynamic-lds" in cmd and cmd[cmd.index("--dynamic-lds") + 1] == "0",
        "v9 runner should not request dynamic LDS",
    )


def check_v9_validation(matmul, args: argparse.Namespace) -> None:
    bad_k_values = vars(args).copy()
    bad_k_values["k"] = 8192
    bad_k = argparse.Namespace(**bad_k_values)
    try:
        matmul.validate_args(bad_k)
    except SystemExit:
        pass
    else:
        require(
            "matmul_v9_perf_golden_profile",
            False,
            "v9 golden should reject non-frozen K",
        )


def check_matmul_v9_perf_golden_profile(matmul) -> None:
    args = make_v9_perf_golden_args(matmul)
    check_v9_profile_shape(matmul, args)
    check_v9_profile_counts(matmul, args)
    check_v9_source_isolation(matmul, args)
    check_v9_runner_forwarding(matmul, args)
    check_v9_validation(matmul, args)
    print("matmul_v9_perf_golden_profile: ok")


def check_matmul_v9_transposed_perf_golden_profile(matmul) -> None:
    args = make_v9_perf_golden_args(matmul, "v9-4096-transposed-wave")
    require(
        "matmul_v9_transposed_perf_golden_profile",
        args.example == "v9-perf-golden",
        "profile should select v9 golden IR",
    )
    require(
        "matmul_v9_transposed_perf_golden_profile",
        args.v9_golden_name == matmul.V9_TRANSPOSED_GOLDEN_NAME,
        "profile should select transposed v9 source",
    )
    require(
        "matmul_v9_transposed_perf_golden_profile",
        matmul.v9_golden_source(args).name == "v9_4096.transposed.wave.mlir",
        "bad transposed v9 source path",
    )
    check_v9_profile_shape(matmul, args)
    check_v9_profile_counts(matmul, args)
    check_v9_source_isolation(matmul, args)
    print("matmul_v9_transposed_perf_golden_profile: ok")


def make_tlx_mxfp_perf_golden_args(matmul) -> argparse.Namespace:
    return matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=a4w4-mxfp-k16k-1",
            "--skip-hw",
            "--no-check",
        ]
    )


def check_tlx_mxfp_profile_shape(
    matmul, args: argparse.Namespace, check_name: str
) -> None:
    require(
        check_name,
        args.example == "tlx-mxfp-perf-golden",
        "profile should select TLX MXFP golden IR",
    )
    require(
        check_name,
        args.m == 4096 and args.n == 4096 and args.k == 16384,
        "bad TLX MXFP default shape",
    )
    require(
        check_name,
        args.bm == 2
        and args.bn == 2
        and args.wave_m_tiles == 8
        and args.wave_n_tiles == 8
        and args.wave_k_tiles == 2,
        "bad TLX MXFP tile shape",
    )
    require(
        check_name,
        args.input_type == "mxfp4" and args.output_type == "bf16",
        "bad TLX MXFP dtypes",
    )
    require(
        check_name,
        matmul.kernel_name(args) == "_a4w4_kernel",
        "bad TLX MXFP kernel symbol",
    )
    require(
        check_name,
        matmul.kernel_abi(args) == "tlx-mxfp",
        "bad TLX MXFP kernel ABI",
    )


def check_tlx_mxfp_profile_counts(
    matmul, args: argparse.Namespace, check_name: str
) -> None:
    require(
        check_name,
        matmul.compute_dynamic_lds_bytes(args) == 0,
        "TLX MXFP golden has static LDS",
    )
    require(
        check_name,
        matmul.compute_kernel_arg_trip_count(args) == 0,
        "TLX MXFP golden should not expose generated-matmul trip arg",
    )
    require(
        check_name,
        matmul.compute_sim_loop_trip_count(args) == 31,
        "TLX MXFP golden should report step-2 loop body count",
    )
    require(
        check_name,
        matmul.compute_report_trip_count(args) == 31,
        "TLX MXFP golden report count should use natural loop count",
    )


def check_tlx_mxfp_source(matmul, args: argparse.Namespace, check_name: str) -> None:
    source = matmul.generate_kernel_module(args, "gfx950")
    require(
        check_name,
        "func.func @_a4w4_kernel" in source and "gpu.module @kernels" not in source,
        "TLX MXFP source should be isolated for wave-translate",
    )
    require(
        check_name,
        matmul.tlx_mxfp_golden_source(args).name == "a4w4_mxfp_k16k_1.mlir",
        "bad TLX MXFP source path",
    )


def check_tlx_mxfp_runner_forwarding(
    matmul, args: argparse.Namespace, check_name: str
) -> None:
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require(
        check_name,
        bool(captured),
        "runner not called",
    )
    cmd = captured[0]
    require(
        check_name,
        "--kernel-abi" in cmd and cmd[cmd.index("--kernel-abi") + 1] == "tlx-mxfp",
        "runner should receive TLX MXFP ABI",
    )
    require(
        check_name,
        "--c-type" in cmd and cmd[cmd.index("--c-type") + 1] == "bf16",
        "runner should receive BF16 output",
    )
    require(
        check_name,
        "--dynamic-lds" in cmd and cmd[cmd.index("--dynamic-lds") + 1] == "0",
        "TLX MXFP runner should not request dynamic LDS",
    )
    require(
        check_name,
        cmd[-1] == "_a4w4_kernel",
        "runner should launch TLX MXFP symbol",
    )


def check_tlx_mxfp_validation(
    matmul, args: argparse.Namespace, check_name: str
) -> None:
    bad_k_values = vars(args).copy()
    bad_k_values["k"] = 8192
    bad_k = argparse.Namespace(**bad_k_values)
    try:
        matmul.validate_args(bad_k)
    except SystemExit:
        pass
    else:
        require(
            check_name,
            False,
            "TLX MXFP golden should reject non-frozen K",
        )


def check_matmul_a4w4_mxfp_k16k_1_profile(matmul) -> None:
    check_name = "matmul_a4w4_mxfp_k16k_1_profile"
    args = make_tlx_mxfp_perf_golden_args(matmul)
    check_tlx_mxfp_profile_shape(matmul, args, check_name)
    check_tlx_mxfp_profile_counts(matmul, args, check_name)
    check_tlx_mxfp_source(matmul, args, check_name)
    check_tlx_mxfp_runner_forwarding(matmul, args, check_name)
    check_tlx_mxfp_validation(matmul, args, check_name)
    print(f"{check_name}: ok")


def check_matmul_a4w4_mxfp_k16k_2_profile(matmul) -> None:
    check_name = "matmul_a4w4_mxfp_k16k_2_profile"
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=a4w4-mxfp-k16k-2",
            "--skip-hw",
            "--no-check",
        ]
    )
    check_tlx_mxfp_profile_shape(matmul, args, check_name)
    check_tlx_mxfp_profile_counts(matmul, args, check_name)
    require(
        check_name,
        matmul.tlx_mxfp_golden_source(args).name == "a4w4_mxfp_k16k_2.mlir",
        "bad TLX MXFP 4096 source path",
    )
    source = matmul.generate_kernel_module(args, "gfx950")
    require(
        check_name,
        "func.func @_a4w4_kernel" in source and "gpu.module @kernels" not in source,
        "TLX MXFP 4096 source should be isolated for wave-translate",
    )
    print(f"{check_name}: ok")


def check_matmul_a4w4_mxfp_k16k_3_profile(matmul) -> None:
    check_name = "matmul_a4w4_mxfp_k16k_3_profile"
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=a4w4-mxfp-k16k-3",
            "--skip-hw",
            "--no-check",
        ]
    )
    check_tlx_mxfp_profile_shape(matmul, args, check_name)
    check_tlx_mxfp_profile_counts(matmul, args, check_name)
    require(
        check_name,
        matmul.tlx_mxfp_golden_source(args).name == "a4w4_mxfp_k16k_3.mlir",
        "bad canonicalize+cse TLX MXFP source path",
    )
    source = matmul.generate_kernel_module(args, "gfx950")
    require(
        check_name,
        "func.func @_a4w4_kernel" in source and "gpu.module @kernels" not in source,
        "canonicalize+cse TLX MXFP source should be isolated for wave-translate",
    )
    print(f"{check_name}: ok")


def check_matmul_perf_sweep_v9_defaults(perf_sweep) -> None:
    require(
        "matmul_perf_sweep_v9_defaults",
        perf_sweep.KERNELS["v9"].variants == "scheduled",
        "v9 sweep should time scheduled golden",
    )
    require(
        "matmul_perf_sweep_v9_defaults",
        perf_sweep.KERNELS["v9-transposed"].variants == "scheduled",
        "transposed v9 sweep should time scheduled golden",
    )
    print("matmul_perf_sweep_v9_defaults: ok")


def check_matmul_perf_sweep_precompile_plan(perf_sweep) -> None:
    args = perf_sweep.build_argparser().parse_args(
        [
            "--kernels=v9",
            "--skip-rebuild",
            "--dry-run",
            "--artifact-dir=/tmp/wave-sweep-artifacts",
        ]
    )
    perf_sweep.validate_args(args)
    specs = perf_sweep.build_run_specs(args)
    prepared = perf_sweep.prepare_runs(
        args, specs, Path("/tmp/wave-sweep-artifacts/runner")
    )
    require(
        "matmul_perf_sweep_precompile_plan",
        len(prepared) == 1,
        "v9 dry-run should prepare one command pair",
    )
    compile_cmd = prepared[0].compile_command
    run_cmd = prepared[0].run_command
    require(
        "matmul_perf_sweep_precompile_plan",
        "--emit-hsaco" in compile_cmd and "--run-hsaco" not in compile_cmd,
        "compile command should emit HSACO only",
    )
    require(
        "matmul_perf_sweep_precompile_plan",
        "--run-hsaco" in run_cmd and "--runner" in run_cmd,
        "run command should consume precompiled HSACO through a runner",
    )
    print("matmul_perf_sweep_precompile_plan: ok")


def check_calibration_scheduler_region_cap(matmul, fa) -> None:
    matmul_args = matmul.parse_args(["--chip=gfx950", "--skip-hw"])
    matmul_variant = matmul.VARIANTS["scheduled"]
    matmul_pass = matmul.schedule_pass_options(matmul_variant, matmul_args)
    matmul_report = matmul.schedule_report_options(matmul_variant, matmul_args)
    require(
        "calibration_scheduler_region_cap",
        "max-region-ops" not in matmul_pass,
        "matmul apply pipeline should not set scheduler region cap",
    )
    require(
        "calibration_scheduler_region_cap",
        matmul_report == {},
        "matmul report should stay empty without report flags",
    )

    fa_args = fa.build_argparser().parse_args(
        ["--chip=gfx950", "--print-candidates", "--skip-hw"]
    )
    fa_variant = fa.VARIANTS["scheduled"]
    fa_pass = fa.schedule_pass_options(fa_variant, fa_args)
    fa_report = fa.schedule_report_options(fa_variant, fa_args)
    require(
        "calibration_scheduler_region_cap",
        "max-region-ops" not in fa_pass,
        "FA apply pipeline should not set scheduler region cap",
    )
    require(
        "calibration_scheduler_region_cap",
        "max-region-ops" not in fa_report,
        "FA report pipeline should not set scheduler region cap",
    )
    print("calibration_scheduler_region_cap: ok")


def main() -> int:
    matmul = load_module(
        "wave_matmul_calibrate",
        REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py",
    )
    fa = load_module(
        "wave_fa_calibrate",
        REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-calibrate.py",
    )
    perf_sweep = load_module(
        "wave_matmul_perf_sweep",
        REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py",
    )
    check_calibration_entry("matmul_pipeline", matmul)
    check_calibration_entry("fa_pipeline", fa)
    check_matmul_wave_size(matmul)
    check_matmul_runner_wave_size(matmul)
    check_matmul_bf16_forwarding(matmul)
    check_matmul_mxfp4_forwarding_and_trip_count(matmul)
    check_matmul_mxfp4_dma_forwarding(matmul)
    check_matmul_mxfp4_scale_regs_forwarding(matmul)
    check_matmul_mxfp4_profile_kernel_only_target_waves(matmul)
    check_matmul_profile_cli_override(matmul)
    check_matmul_mxfp4_4wave_profile(matmul)
    check_matmul_dynamic_lds_forwarding(matmul)
    check_matmul_f16_dma_buffer_count(matmul)
    check_matmul_dma_sim_trip_count(matmul)
    check_matmul_v9_perf_golden_profile(matmul)
    check_matmul_v9_transposed_perf_golden_profile(matmul)
    check_matmul_a4w4_mxfp_k16k_1_profile(matmul)
    check_matmul_a4w4_mxfp_k16k_2_profile(matmul)
    check_matmul_a4w4_mxfp_k16k_3_profile(matmul)
    check_matmul_perf_sweep_v9_defaults(perf_sweep)
    check_matmul_perf_sweep_precompile_plan(perf_sweep)
    check_calibration_scheduler_region_cap(matmul, fa)
    try:
        matmul.parse_variants("pingpong")
    except argparse.ArgumentTypeError:
        print("matmul_pingpong_removed: ok")
        return 0
    print("matmul_pingpong_removed: still accepted", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
