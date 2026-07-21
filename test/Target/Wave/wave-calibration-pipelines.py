# RUN: %python %s %wave_pipelines | FileCheck %s

# CHECK: matmul_pipeline: ok
# CHECK: fa_pipeline: ok
# CHECK: shared_calibration_support: ok
# CHECK: matmul_explicit_gfx950_wave_size: ok
# CHECK: matmul_auto_gfx950_wave_size: ok
# CHECK: matmul_gfx1250_profile: ok
# CHECK: matmul_gfx1250_selection_rejection: ok
# CHECK: matmul_runner_gfx950_wave_size: ok
# CHECK: matmul_runner_output_layout: ok
# CHECK: matmul_bf16_forwarding: ok
# CHECK: matmul_multi_wave_specialization_forwarding: ok
# CHECK: matmul_rand_int_forwarding: ok
# CHECK: matmul_hpl_forwarding: ok
# CHECK: matmul_streamk_profile: ok
# CHECK: matmul_mxfp4_forwarding_and_trip_count: ok
# CHECK: matmul_mxfp4_dma_forwarding: ok
# CHECK: matmul_mxfp4_scale_regs_forwarding: ok
# CHECK: matmul_mxfp4_profile_kernel_only_target_waves: ok
# CHECK: matmul_profile_cli_override: ok
# CHECK: matmul_f16_8wave_profile: ok
# CHECK: matmul_f16_spatial_profile: ok
# CHECK: matmul_mxfp4_4wave_profile: ok
# CHECK: matmul_mxfp4_aiter_profiles: ok
# CHECK: matmul_runtime_count_validation: ok
# CHECK: matmul_dynamic_lds_forwarding: ok
# CHECK: matmul_f16_dma_buffer_count: ok
# CHECK: matmul_dma_sim_trip_count: ok
# CHECK: matmul_v9_perf_golden_profile: ok
# CHECK: matmul_v9_transposed_perf_golden_profile: ok
# CHECK: matmul_a4w4_mxfp_k16k_profile: ok
# CHECK: matmul_perf_sweep_v9_defaults: ok
# CHECK: matmul_perf_sweep_f16_profiles: ok
# CHECK: matmul_perf_sweep_spatial: ok
# CHECK: matmul_perf_sweep_streamk: ok
# CHECK: matmul_perf_sweep_precompile_plan: ok
# CHECK: matmul_perf_sweep_mxfp4_aiter: ok
# CHECK: perf_sweep_fa_8wave: ok
# CHECK: matmul_perf_sweep_rand_int_forwarding: ok
# CHECK: calibration_scheduler_options: ok
# CHECK: matmul_pingpong_removed: ok

from __future__ import annotations

import argparse
import importlib.util
import subprocess
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
        [
            "waveamd-machine-schedule-report",
            "waveamd-machine-multi-wave-specialize",
            "waveamd-machine-schedule",
        ],
        "scheduler order drifted",
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
            "canonicalize",
            "cse",
            "waveamd-late-tuples",
            "waveamd-prepare-regalloc",
            "waveamd-pack-vgpr-zero-moves",
            "waveamd-hazard-repair",
            "waveamd-preserve-hw-regs",
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
            "waveamd-clear-regalloc-transform-state",
        ],
        "post-regalloc pass order drifted",
    )


def check_emit_only(label: str, emit_only) -> None:
    ops = body_ops(emit_only)
    require(label, len(ops) == 1, "emit-only entry should only yield")
    require(label, ops[0].name == "transform.yield", "emit-only entry mutates IR")


def check_calibration_entry(label: str, module) -> None:
    kwargs = {
        "schedule_options": {"apply-schedule": True},
        "report_options": {"print-candidates": True},
    }
    text = module.pipeline_text(BUILD_DIR, **kwargs)
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
        emit_only = require_sequence(ir, parsed, label, module.EMIT_ONLY_ENTRY_POINT)
        check_backend_entry(label, ir, entry)
        check_preschedule(label, ir, preschedule)
        check_postschedule(label, ir, postschedule)
        check_backend_lower(label, applied_passes(ir, lower))
        check_default_finish(label, ir, finish)
        check_transform_finish(label, ir, transform_finish)
        check_post_regalloc(label, applied_passes(ir, post))
        check_emit_only(label, emit_only)
    print(f"{label}: ok")


def check_shared_calibration_support(common, matmul, fa) -> None:
    names = (
        "run",
        "detect_chip",
        "schedule_pass_options",
        "schedule_report_options",
        "backend_pipeline_path",
        "read_backend_pipeline",
        "import_mlir_bindings",
        "erase_default_entry",
        "append_calibration_entry",
        "pipeline_text",
        "write_pipeline",
        "parse_total_cycles",
        "parse_hw",
        "run_hw_repeats",
        "parse_variants",
    )
    for name in names:
        shared = getattr(common, name)
        require(
            "shared_calibration_support",
            getattr(matmul, name) is shared and getattr(fa, name) is shared,
            f"{name} is not shared",
        )
    require(
        "shared_calibration_support",
        matmul.Variant is common.Variant and fa.Variant is common.Variant,
        "Variant is not shared",
    )
    require(
        "shared_calibration_support",
        matmul.VARIANTS is common.VARIANTS and fa.VARIANTS is common.VARIANTS,
        "VARIANTS is not shared",
    )
    print("shared_calibration_support: ok")


def check_matmul_wave_size(matmul) -> None:
    explicit = argparse.Namespace(chip="gfx950", matrix_intrinsic="auto")
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.kernel_wave_size(explicit) == 64,
        "explicit gfx950 should use wave64",
    )
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.accumulator_layout(explicit) == "mfma",
        "explicit gfx950 should use MFMA accumulator layout",
    )
    forced = argparse.Namespace(chip="gfx1100", matrix_intrinsic="mfma_gfx950")
    try:
        matmul.kernel_wave_size(forced)
    except SystemExit as exc:
        require(
            "matmul_explicit_gfx950_wave_size",
            "incompatible with gfx1100" in str(exc),
            f"bad diagnostic: {exc}",
        )
    else:
        require(
            "matmul_explicit_gfx950_wave_size",
            False,
            "gfx1100 accepted gfx950 MFMA",
        )
    rdna = argparse.Namespace(chip="gfx1100", matrix_intrinsic="auto")
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.kernel_wave_size(rdna) == 32,
        "gfx1100 auto should use wave32",
    )
    require(
        "matmul_explicit_gfx950_wave_size",
        matmul.accumulator_layout(rdna) == "wmma",
        "gfx1100 auto should use WMMA accumulator layout",
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


def check_matmul_gfx1250_profile(matmul) -> None:
    args = matmul.parse_args(["--chip=gfx1250", "--skip-hw"])
    profile = matmul.matmul_target_profile(args)
    require("matmul_gfx1250_profile", profile is not None, "profile missing")
    for input_type in ("f16", "bf16"):
        args.input_type = input_type
        mma = profile.mma(input_type)
        require(
            "matmul_gfx1250_profile",
            matmul.selected_matrix_intrinsic(args) == profile.matrix_intrinsic,
            f"{input_type} selected wrong intrinsic",
        )
        require(
            "matmul_gfx1250_profile",
            matmul.mma_k_tile(args) == mma.k_tile,
            f"{input_type} selected wrong K tile",
        )
        require(
            "matmul_gfx1250_profile",
            matmul.lds_dwords_per_frag(args) == mma.operand_dwords * profile.wave_size,
            f"{input_type} selected wrong LDS fragment size",
        )
    require(
        "matmul_gfx1250_profile",
        matmul.kernel_wave_size(args) == profile.wave_size,
        "selected wrong wave size",
    )
    require(
        "matmul_gfx1250_profile",
        matmul.accumulator_layout(args) == "wmma",
        "selected wrong accumulator layout",
    )
    require(
        "matmul_gfx1250_profile",
        profile.local_memory_bytes > 0
        and profile.local_memory_bank_count > 0
        and profile.max_waves_per_eu > 0,
        "LLVM target capacities missing",
    )
    matmul.validate_args(args)
    print("matmul_gfx1250_profile: ok")


def check_matmul_gfx1250_selection_rejection(matmul) -> None:
    cases = (
        (
            ["--chip=gfx1250", "--matrix-intrinsic=wmma", "--skip-hw"],
            "incompatible with gfx1250",
        ),
        (["--chip=gfx1251", "--skip-hw"], "no matrix intrinsic profile"),
    )
    for argv, message in cases:
        args = matmul.parse_args(argv)
        try:
            matmul.validate_args(args)
        except SystemExit as exc:
            require(
                "matmul_gfx1250_selection_rejection",
                message in str(exc),
                f"bad diagnostic: {exc}",
            )
        else:
            require(
                "matmul_gfx1250_selection_rejection",
                False,
                f"accepted {' '.join(argv)}",
            )
    print("matmul_gfx1250_selection_rejection: ok")


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
    require(
        "matmul_runner_gfx950_wave_size",
        "--accumulator-layout" in cmd,
        "missing --accumulator-layout",
    )
    index = cmd.index("--accumulator-layout")
    require(
        "matmul_runner_gfx950_wave_size",
        cmd[index + 1] == "mfma",
        "runner should receive MFMA accumulator layout",
    )
    print("matmul_runner_gfx950_wave_size: ok")


def matmul_output_layout_cases():
    return (
        ("automatic", ["--chip=gfx950", "--no-check"], "row-major"),
        (
            "tile-packed",
            ["--chip=gfx950", "--output-layout=tile-packed", "--no-check"],
            "tile-packed",
        ),
        (
            "column-major",
            ["--chip=gfx950", "--output-layout=column-major", "--no-check"],
            "column-major",
        ),
        (
            "coalesced",
            [
                "--chip=gfx950",
                "--kernel-profile=gfx950-f16-256x256-4wave",
                "--m=256",
                "--n=256",
                "--k=64",
                "--cta-swizzle-xcds=1",
                "--cta-group-m=1",
                "--no-check",
            ],
            "column-major",
        ),
        (
            "aiter",
            [
                "--chip=gfx950",
                "--kernel-profile=gfx950-mxfp4-aiter-32x128",
                "--m=32",
                "--n=128",
                "--k=256",
                "--cta-swizzle-xcds=1",
                "--cta-group-m=1",
                "--no-check",
            ],
            "row-major",
        ),
    )


def capture_matmul_runner_commands(matmul, args_list) -> list[list[str]]:
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return "per_launch_cycles_wallclock: 1\nper_launch_us: 1.0\n"

        matmul.run = fake_run
        for args in args_list:
            matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    return captured


def require_invalid_matmul_output_layout(matmul, argv, message, label) -> None:
    args = matmul.parse_args(argv)
    try:
        matmul.validate_args(args)
    except SystemExit as exc:
        require(
            "matmul_runner_output_layout",
            str(exc) == message,
            f"bad {label} output diagnostic: {exc}",
        )
        return
    require(
        "matmul_runner_output_layout",
        False,
        f"accepted invalid {label} output options: {argv}",
    )


def check_matmul_output_layout_rejections(matmul) -> None:
    aiter_argv = [
        "--chip=gfx950",
        "--kernel-profile=gfx950-mxfp4-aiter-32x128",
        "--m=32",
        "--n=128",
        "--k=256",
        "--cta-swizzle-xcds=1",
        "--cta-group-m=1",
        "--skip-hw",
    ]
    aiter_invalid = (
        (
            ["--output-layout=tile-packed"],
            "AITER input layout requires row-major output",
        ),
        (
            ["--output-layout=column-major"],
            "AITER input layout requires row-major output",
        ),
        (
            ["--coalesced-mfma-output"],
            "AITER input layout does not support coalesced output",
        ),
    )
    for options, message in aiter_invalid:
        require_invalid_matmul_output_layout(
            matmul, [*aiter_argv, *options], message, "AITER"
        )

    coalesced_argv = [
        "--chip=gfx950",
        "--kernel-profile=gfx950-f16-256x256-4wave",
        "--m=256",
        "--n=256",
        "--k=64",
        "--cta-swizzle-xcds=1",
        "--cta-group-m=1",
        "--skip-hw",
    ]
    message = "coalesced MFMA output requires column-major output"
    for layout in ("row-major", "tile-packed"):
        require_invalid_matmul_output_layout(
            matmul,
            [*coalesced_argv, f"--output-layout={layout}"],
            message,
            "coalesced",
        )


def check_matmul_runner_output_layout(matmul) -> None:
    cases = matmul_output_layout_cases()
    parsed = [(label, matmul.parse_args(argv), layout) for label, argv, layout in cases]
    for label, args, layout in parsed:
        require(
            "matmul_runner_output_layout",
            matmul.effective_output_layout(args) == layout,
            f"bad {label} effective layout",
        )
        generator = matmul.build_matmul_example_args(args, "gfx950")
        output_args = [arg for arg in generator if arg.startswith("--output-layout=")]
        require(
            "matmul_runner_output_layout",
            output_args == [f"--output-layout={layout}"],
            f"generator should receive one {layout} layout",
        )

    captured = capture_matmul_runner_commands(matmul, [args for _, args, _ in parsed])
    require(
        "matmul_runner_output_layout",
        len(captured) == len(cases),
        "runner call count mismatch",
    )
    for cmd, (_, _, layout) in zip(captured, parsed, strict=True):
        require(
            "matmul_runner_output_layout",
            cmd.count("--output-layout") == 1,
            "runner should receive one --output-layout",
        )
        index = cmd.index("--output-layout")
        require(
            "matmul_runner_output_layout",
            cmd[index + 1] == layout,
            f"runner should receive {layout}",
        )

    check_matmul_output_layout_rejections(matmul)
    print("matmul_runner_output_layout: ok")


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


def check_matmul_multi_wave_specialization_forwarding(matmul) -> None:
    args = matmul.parse_args(["--chip=gfx950", "--multi-wave-specialize", "--skip-hw"])
    cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_multi_wave_specialization_forwarding",
        "--multi-wave-specialize" in cmd,
        "matmul command missing specialization marker flag",
    )
    args.example = "tensilelite-subtile"
    cmd = matmul.build_example_args(args, "gfx950")
    require(
        "matmul_multi_wave_specialization_forwarding",
        "--multi-wave-specialize" in cmd,
        "TensileLite command missing specialization marker flag",
    )
    print("matmul_multi_wave_specialization_forwarding: ok")


def check_matmul_rand_int_forwarding(matmul) -> None:
    args = matmul.parse_args(
        ["--chip=gfx950", "--input-type=bf16", "--rand-int", "--variants=baseline"]
    )
    hpl_args = matmul.parse_args(
        ["--chip=gfx950", "--input-type=f16", "--hpl", "--variants=baseline"]
    )
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return (
                "per_launch_cycles_wallclock: 1\n"
                "per_launch_us: 1.0\n"
                "output_check: passed\n"
            )

        matmul.run = fake_run
        _, _, check = matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
        _, _, hpl_check = matmul.run_hw(
            Path("runner"), Path("kernel.hsaco"), hpl_args, "/tmp"
        )
    finally:
        matmul.run = old_run
    require(
        "matmul_rand_int_forwarding",
        bool(captured) and "--rand-int" in captured[0],
        "runner command missing --rand-int",
    )
    require(
        "matmul_rand_int_forwarding",
        check == "passed" and matmul.input_mode_name(args) == "rand-int",
        "rand_int should retain CPU checking and header mode",
    )
    require(
        "matmul_rand_int_forwarding",
        len(captured) == 2 and "--hpl" in captured[1],
        "runner command missing --hpl",
    )
    require(
        "matmul_rand_int_forwarding",
        hpl_check == "passed" and matmul.input_mode_name(hpl_args) == "hpl",
        "HPL should retain CPU checking and header mode",
    )

    try:
        matmul.parse_args(["--all-ones", "--rand-int"])
    except SystemExit:
        pass
    else:
        require(
            "matmul_rand_int_forwarding",
            False,
            "calibrator accepted conflicting input modes",
        )

    bad = matmul.parse_args(["--chip=gfx950", "--input-type=mxfp4", "--rand-int"])
    try:
        matmul.validate_args(bad)
    except SystemExit:
        pass
    else:
        require(
            "matmul_rand_int_forwarding",
            False,
            "calibrator accepted MXFP4 rand_int",
        )
    bad = matmul.parse_args(["--chip=gfx950", "--input-type=mxfp4", "--hpl"])
    try:
        matmul.validate_args(bad)
    except SystemExit:
        pass
    else:
        require(
            "matmul_rand_int_forwarding",
            False,
            "calibrator accepted MXFP4 HPL",
        )
    print("matmul_rand_int_forwarding: ok")


def check_matmul_hpl_forwarding(matmul) -> None:
    args = matmul.parse_args(
        ["--chip=gfx950", "--input-type=bf16", "--hpl", "--variants=baseline"]
    )
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return (
                "per_launch_cycles_wallclock: 1\n"
                "per_launch_us: 1.0\n"
                "output_check: passed\n"
            )

        matmul.run = fake_run
        _, _, check = matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    require(
        "matmul_hpl_forwarding",
        bool(captured) and "--hpl" in captured[0],
        "runner command missing --hpl",
    )
    require(
        "matmul_hpl_forwarding",
        check == "passed" and matmul.input_mode_name(args) == "hpl",
        "HPL should retain CPU checking and header mode",
    )

    bad = matmul.parse_args(["--chip=gfx950", "--input-type=mxfp4", "--hpl"])
    try:
        matmul.validate_args(bad)
    except SystemExit:
        pass
    else:
        require(
            "matmul_hpl_forwarding",
            False,
            "calibrator accepted MXFP4 HPL",
        )
    print("matmul_hpl_forwarding: ok")


def make_streamk_profile_args(matmul) -> argparse.Namespace:
    return matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave-streamk",
            "--m=512",
            "--n=512",
            "--k=256",
            "--streamk-workers=5",
            "--cta-swizzle-xcds=4",
            "--cta-group-m=2",
            "--variants=scheduled",
            "--hpl",
            "--skip-hw",
        ]
    )


def check_streamk_profile_metadata(matmul, args, label: str) -> None:
    matmul.validate_args(args)
    require(
        label,
        (matmul.kernel_name(args), matmul.kernel_abi(args))
        == ("gfx950_f16_streamk_gemm", "streamk"),
        "bad kernel name or ABI",
    )
    require(
        label,
        (args.output_layout, matmul.compute_dynamic_lds_bytes(args))
        == ("column-major", 133152),
        "bad output layout or LDS size",
    )
    require(
        label,
        (
            matmul.compute_kernel_arg_trip_count(args),
            matmul.kernel_arg_trip_count_text(args),
        )
        == (0, "n/a"),
        "Stream-K should not forward a trip count",
    )
    require(
        label,
        matmul.streamk_workspace_sizes(args.m, args.n, args.streamk_workers)
        == (2621440, 16),
        "bad workspace sizes",
    )
    example = matmul.build_example_args(args, "gfx950")
    for expected in (
        "--workers=5",
        "--cta-swizzle-xcds=4",
        "--cta-group-m=2",
    ):
        require(label, expected in example, f"generator command missing {expected}")


def check_streamk_module_isolation(matmul, args, label: str) -> None:
    generated = """
module {
    func.func @wmma_f16_matmul_tiled() attributes {gpu.kernel} {
      return
    }
    func.func @gfx950_f16_streamk_gemm() attributes {gpu.kernel} {
      return
    }
}
"""
    old_run = matmul.run
    try:
        matmul.run = lambda cmd, env=None: generated
        isolated = matmul.generate_kernel_module(args, "gfx950")
    finally:
        matmul.run = old_run
    require(
        label,
        "@gfx950_f16_streamk_gemm" in isolated
        and "@wmma_f16_matmul_tiled" not in isolated,
        "wrong generated kernel isolated",
    )


def capture_streamk_runner_command(matmul, args) -> list[str]:
    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return (
                "per_launch_cycles_wallclock: 1\n"
                "per_launch_us: 1.0\n"
                "output_check: passed\n"
            )

        matmul.run = fake_run
        matmul.run_hw(Path("runner"), Path("kernel.hsaco"), args, "/tmp")
    finally:
        matmul.run = old_run
    return captured[0]


def check_streamk_runner_command(runner: list[str], label: str) -> None:
    expected_pairs = (
        ("--kernel-abi", "streamk"),
        ("--output-layout", "column-major"),
        ("--streamk-workers", "5"),
    )
    for option, value in expected_pairs:
        require(
            label,
            option in runner and runner[runner.index(option) + 1] == value,
            f"runner command missing {option}={value}",
        )
    require(label, "--hpl" in runner, "runner command missing HPL mode")


def require_invalid_args(matmul, label: str, argv: list[str]) -> None:
    bad = matmul.parse_args(argv)
    try:
        matmul.validate_args(bad)
    except SystemExit:
        return
    require(label, False, f"accepted invalid Stream-K args: {argv}")


def check_streamk_invalid_args(matmul, label: str) -> None:
    invalid = (
        ["--streamk-workers=2"],
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave-streamk",
            "--m=512",
            "--n=512",
            "--k=256",
            "--streamk-workers=0",
        ],
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave-streamk",
            "--m=512",
            "--n=512",
            "--k=256",
            "--streamk-workers=5",
            "--output-layout=row-major",
        ],
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave-streamk",
            f"--m={1 << 31}",
            "--n=256",
            "--k=256",
        ],
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave-streamk",
            "--m=2147481600",
            "--n=256",
            "--k=64",
        ],
    )
    for argv in invalid:
        require_invalid_args(matmul, label, argv)
    try:
        matmul.streamk_workspace_sizes(256, 256, 1 << 63)
    except OverflowError:
        pass
    else:
        require(label, False, "workspace overflow accepted")


def check_matmul_streamk_profile(matmul) -> None:
    label = "matmul_streamk_profile"
    args = make_streamk_profile_args(matmul)
    check_streamk_profile_metadata(matmul, args, label)
    check_streamk_module_isolation(matmul, args, label)
    runner = capture_streamk_runner_command(matmul, args)
    check_streamk_runner_command(runner, label)
    check_streamk_invalid_args(matmul, label)
    print(f"{label}: ok")


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
        mxfp4_input_layout="canonical",
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


def check_matmul_f16_8wave_profile(matmul) -> None:
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-8wave",
            "--m=256",
            "--n=256",
            "--k=256",
            "--skip-hw",
        ]
    )
    require(
        "matmul_f16_8wave_profile",
        args.bm == 2
        and args.bn == 4
        and args.wave_m_tiles == 8
        and args.wave_n_tiles == 4
        and args.wave_k_tiles == 2,
        "bad 8-wave tile shape",
    )
    require(
        "matmul_f16_8wave_profile",
        args.kernel_profile == "gfx950-f16-256x256-8wave",
        "wrong selected profile",
    )
    require(
        "matmul_f16_8wave_profile",
        args.output_layout == "column-major" and args.output_store_cache == "none",
        "8-wave output contract changed",
    )
    require(
        "matmul_f16_8wave_profile",
        matmul.effective_target_waves(args) == 2,
        "8-wave profile should request two waves per SIMD",
    )
    require(
        "matmul_f16_8wave_profile",
        matmul.dma_buffer_count(args) == 2
        and matmul.compute_dynamic_lds_bytes(args) == 131072,
        "bad phased DMA LDS byte accounting",
    )
    cmd = matmul.build_matmul_example_args(args, "gfx950")
    forbidden = (
        "dma-lds-issue-group-size",
        "dma-lds-initial-delay-cycles",
        "dma-lds-loop-delay-cycles",
        "dma-lds-loop-overlap-cycles",
        "dma-lds-loop-delay-waves",
    )
    require(
        "matmul_f16_8wave_profile",
        "--kernel-profile=gfx950-f16-256x256-8wave" in cmd,
        "calibrator did not forward the named profile",
    )
    require(
        "matmul_f16_8wave_profile",
        not any(any(name in arg for name in forbidden) for arg in cmd),
        "calibrator exposed scalar timing flags",
    )
    print("matmul_f16_8wave_profile: ok")


def check_matmul_f16_spatial_profile(matmul) -> None:
    argv = [
        "--chip=gfx950",
        "--kernel-profile=gfx950-f16-256x256-8wave-spatial",
        "--m=2048",
        "--n=256",
        "--k=128",
        "--skip-hw",
    ]
    args = matmul.parse_args(argv)
    matmul.validate_args(args)
    require(
        "matmul_f16_spatial_profile",
        (
            args.bm,
            args.bn,
            args.wave_m_tiles,
            args.wave_n_tiles,
            args.wave_k_tiles,
            matmul.effective_target_waves(args),
        )
        == (2, 4, 8, 4, 2, 2),
        "bad spatial tile shape",
    )
    require(
        "matmul_f16_spatial_profile",
        args.output_layout == "column-major"
        and matmul.dma_buffer_count(args) == 2
        and matmul.compute_dynamic_lds_bytes(args) == 131072,
        "bad spatial output layout or LDS accounting",
    )
    command = matmul.build_matmul_example_args(args, "gfx950")
    require(
        "matmul_f16_spatial_profile",
        command == matmul.build_matmul_example_args(matmul.parse_args(argv), "gfx950"),
        "spatial generator command is not deterministic",
    )
    require(
        "matmul_f16_spatial_profile",
        "--kernel-profile=gfx950-f16-256x256-8wave-spatial" in command,
        "calibrator did not forward the spatial profile",
    )

    captured: list[list[str]] = []
    old_run = matmul.run
    try:

        def fake_run(cmd, env=None):
            captured.append(cmd)
            return (
                "per_launch_cycles_wallclock: 1\n"
                "per_launch_us: 1.0\n"
                "output_check: passed mode=strict\n"
            )

        matmul.run = fake_run
        result = matmul.run_hw(
            Path("runner"), Path("kernel.hsaco"), args, "/tmp/rocm-lib"
        )
    finally:
        matmul.run = old_run

    runner = captured[0]
    require(
        "matmul_f16_spatial_profile",
        result == (1, 1.0, "passed")
        and runner.count("--output-layout") == 1
        and runner[runner.index("--output-layout") + 1] == "column-major"
        and "--no-check" not in runner,
        "spatial runner lost column-major strict checking",
    )
    print("matmul_f16_spatial_profile: ok")


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
        args.mxfp4_scale_path == "regs" and args.output_layout == "column-major",
        "bad 4-wave scale path or output contract",
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


def check_matmul_mxfp4_aiter_example_profile(
    matmul, matmul_example, args, profile: str, shape: tuple[int, ...]
) -> None:
    command = matmul.build_matmul_example_args(args, "gfx950")
    require(
        "matmul_mxfp4_aiter_profiles",
        "--mxfp4-input-layout=aiter" in command,
        f"{profile} lost AITER ABI",
    )
    example_defaults = matmul_example.profile_defaults([f"--kernel-profile={profile}"])
    example_shape = tuple(
        example_defaults[key]
        for key in (
            "bm",
            "bn",
            "wave_m_tiles",
            "wave_n_tiles",
            "wave_k_tiles",
            "cta_swizzle_xcds",
            "cta_group_m",
        )
    )
    require(
        "matmul_mxfp4_aiter_profiles",
        example_shape == shape and example_defaults["mxfp4_input_layout"] == "aiter",
        f"direct example profile drifted for {profile}",
    )


def check_matmul_mxfp4_aiter_profiles(matmul, matmul_example) -> None:
    expected = {
        "gfx950-mxfp4-aiter-32x128": (
            (1, 4, 2, 2, 2, 8, 4),
            16384,
            24576,
            0,
        ),
        "gfx950-mxfp4-aiter-64x128": (
            (1, 4, 4, 2, 2, 8, 4),
            16384,
            32768,
            0,
        ),
        "gfx950-mxfp4-aiter-128x128": (
            (1, 4, 8, 2, 2, 8, 4),
            16384,
            49152,
            0,
        ),
        "gfx950-mxfp4-aiter-128x256": (
            (1, 4, 8, 4, 4, 8, 4),
            24576,
            90112,
            90112,
        ),
        "gfx950-mxfp4-aiter-256x256": (
            (1, 4, 16, 4, 4, 1, 4),
            16384,
            147456,
            147456,
        ),
    }
    for profile, (shape, scale_lds, total_lds, dynamic_lds) in expected.items():
        args = matmul.parse_args(
            [
                "--chip=gfx950",
                f"--kernel-profile={profile}",
                "--m=2048",
                "--n=8192",
                "--k=4096",
                "--skip-hw",
            ]
        )
        actual = (
            args.bm,
            args.bn,
            args.wave_m_tiles,
            args.wave_n_tiles,
            args.wave_k_tiles,
            args.cta_swizzle_xcds,
            args.cta_group_m,
        )
        require("matmul_mxfp4_aiter_profiles", actual == shape, f"bad {profile}")
        require(
            "matmul_mxfp4_aiter_profiles",
            matmul.dma_buffer_count(args) == 2,
            f"bad {profile} LDS pipeline",
        )
        require(
            "matmul_mxfp4_aiter_profiles",
            args.mxfp4_input_layout == "aiter"
            and args.output_layout == "row-major"
            and args.output_store_cache == "cs"
            and matmul.effective_target_waves(args) == 1,
            f"bad {profile} mode",
        )
        require(
            "matmul_mxfp4_aiter_profiles",
            matmul.mxfp4_scale_lds_bytes(args) == scale_lds
            and matmul.compute_lds_bytes(args) == total_lds
            and matmul.compute_dynamic_lds_bytes(args) == dynamic_lds,
            f"bad {profile} LDS accounting",
        )
        check_matmul_mxfp4_aiter_example_profile(
            matmul, matmul_example, args, profile, shape
        )
    print("matmul_mxfp4_aiter_profiles: ok")


def check_matmul_runtime_count_validation(matmul) -> None:
    check_name = "matmul_runtime_count_validation"
    cases = (
        (["--iters=0"], "--iters must be positive"),
        (["--warmup=-1"], "--warmup must be non-negative"),
    )
    for options, message in cases:
        args = matmul.parse_args(["--chip=gfx950", "--skip-hw", *options])
        try:
            matmul.validate_args(args)
        except SystemExit as exc:
            require(check_name, str(exc) == message, f"bad diagnostic: {exc}")
            continue
        require(check_name, False, f"accepted {' '.join(options)}")
    print(f"{check_name}: ok")


def check_matmul_f16_4wave_profile(matmul) -> None:
    args = matmul.parse_args(
        [
            "--chip=gfx950",
            "--kernel-profile=gfx950-f16-256x256-4wave",
            "--m=256",
            "--n=256",
            "--k=256",
            "--skip-hw",
        ]
    )
    require(
        "matmul_f16_4wave_profile",
        args.bm == 2 and args.bn == 2,
        "bad 4-wave workgroup shape",
    )
    require(
        "matmul_f16_4wave_profile",
        args.wave_m_tiles == 8 and args.wave_n_tiles == 8 and args.wave_k_tiles == 2,
        "bad 4-wave tile shape",
    )
    require(
        "matmul_f16_4wave_profile",
        args.input_type == "f16" and args.output_type == "f16",
        "bad 4-wave dtypes",
    )
    require(
        "matmul_f16_4wave_profile",
        args.output_store_cache == "cs",
        "bad 4-wave output-store cache policy",
    )
    require(
        "matmul_f16_4wave_profile",
        matmul.effective_target_waves(args) == 1,
        "4-wave profile should request one wave per SIMD",
    )
    require(
        "matmul_f16_4wave_profile",
        matmul.dma_buffer_count(args) == 2 and matmul.compute_lds_bytes(args) == 133120,
        "bad 4-wave LDS byte accounting",
    )
    cmd = matmul.build_matmul_example_args(args, "gfx950")
    require(
        "matmul_f16_4wave_profile",
        "--kernel-profile=gfx950-f16-256x256-4wave" in cmd,
        "calibrator did not forward the named 4-wave profile",
    )
    require(
        "matmul_f16_4wave_profile",
        "--coalesced-mfma-output" in cmd,
        "calibrator did not forward coalesced output",
    )
    require(
        "matmul_f16_4wave_profile",
        "--output-store-cache=cs" in cmd,
        "calibrator did not forward output-store cache policy",
    )
    print("matmul_f16_4wave_profile: ok")


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
            "--kernel-profile=a4w4-mxfp-k16k",
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
        matmul.tlx_mxfp_golden_source(args).name == "a4w4_mxfp_k16k.mlir",
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
        "--output-layout" in cmd
        and cmd[cmd.index("--output-layout") + 1] == "row-major",
        "runner should receive row-major output",
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
    for layout in ("tile-packed", "column-major"):
        bad_layout_values = vars(args).copy()
        bad_layout_values["output_layout"] = layout
        try:
            matmul.validate_args(argparse.Namespace(**bad_layout_values))
        except SystemExit as exc:
            require(
                check_name,
                str(exc) == "--example=tlx-mxfp-perf-golden requires row-major output",
                f"bad {layout} output diagnostic: {exc}",
            )
        else:
            require(
                check_name,
                False,
                f"accepted incompatible {layout} output",
            )


def check_matmul_a4w4_mxfp_k16k_profile(matmul) -> None:
    check_name = "matmul_a4w4_mxfp_k16k_profile"
    args = make_tlx_mxfp_perf_golden_args(matmul)
    check_tlx_mxfp_profile_shape(matmul, args, check_name)
    check_tlx_mxfp_profile_counts(matmul, args, check_name)
    check_tlx_mxfp_source(matmul, args, check_name)
    check_tlx_mxfp_runner_forwarding(matmul, args, check_name)
    check_tlx_mxfp_validation(matmul, args, check_name)
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


def check_matmul_perf_sweep_f16_profiles(perf_sweep) -> None:
    default_kernels = perf_sweep.parse_kernel_csv("all")
    default_profiles = {kernel.profile for kernel in default_kernels}
    require(
        "matmul_perf_sweep_f16_profiles",
        "gfx950-f16-256x256-8wave" in default_profiles
        and "gfx950-f16-256x256-8wave-spatial" in default_profiles
        and "gfx950-f16-256x256-4wave" in default_profiles
        and "gfx950-f16-256x256-4wave-streamk" in default_profiles,
        "default sweep should include all f16 profiles",
    )
    spatial = perf_sweep.parse_kernel_csv("f16-spatial")
    require(
        "matmul_perf_sweep_f16_profiles",
        len(spatial) == 1 and spatial[0].profile == "gfx950-f16-256x256-8wave-spatial",
        "f16 spatial alias should select only its profile",
    )
    four_wave = perf_sweep.parse_kernel_csv("f16-4wave")
    require(
        "matmul_perf_sweep_f16_profiles",
        len(four_wave) == 1 and four_wave[0].profile == "gfx950-f16-256x256-4wave",
        "f16 four-wave alias should select only its profile",
    )
    streamk = perf_sweep.parse_kernel_csv("f16-streamk")
    require(
        "matmul_perf_sweep_f16_profiles",
        len(streamk) == 1 and streamk[0].profile == "gfx950-f16-256x256-4wave-streamk",
        "f16 Stream-K alias should select only its profile",
    )
    print("matmul_perf_sweep_f16_profiles: ok")


def spatial_sweep_args(perf_sweep, *, k_values: str, check: bool) -> argparse.Namespace:
    argv = [
        "--kernels=f16-spatial",
        "--m=4096",
        "--n=4096",
        f"--k-values={k_values}",
        "--dry-run",
        "--skip-rebuild",
        "--artifact-dir=/tmp/wave-sweep-artifacts",
    ]
    if check:
        argv.append("--check")
    args = perf_sweep.build_argparser().parse_args(argv)
    perf_sweep.validate_args(args)
    return args


def check_spatial_sweep_specs(perf_sweep, args: argparse.Namespace):
    specs = perf_sweep.build_run_specs(args)
    actual = [
        (
            spec.kernel.profile,
            spec.variants,
            spec.streamk_workers,
            spec.shape.k,
        )
        for spec in specs
    ]
    expected = [
        ("gfx950-f16-256x256-8wave-spatial", "scheduled", 0, 64),
        ("gfx950-f16-256x256-8wave-spatial", "scheduled", 0, 128),
    ]
    require(
        "matmul_perf_sweep_spatial",
        specs == perf_sweep.build_run_specs(args) and actual == expected,
        "spatial dry-run matrix is not deterministic",
    )
    return specs


def check_spatial_sweep_artifacts(perf_sweep, args, specs) -> None:
    runners = {perf_sweep.Workload.MATMUL: Path("/tmp/wave-sweep-artifacts/runner")}
    prepared = perf_sweep.prepare_runs(args, specs, runners)
    require(
        "matmul_perf_sweep_spatial",
        prepared == perf_sweep.prepare_runs(args, specs, runners)
        and [run.hsaco.name for run in prepared]
        == [
            "000-f16-spatial-m4096-n4096-k64-scheduled.hsaco",
            "001-f16-spatial-m4096-n4096-k128-scheduled.hsaco",
        ],
        "spatial artifact plan is not deterministic",
    )
    command_modes = [
        (
            "--no-check" in run.compile_command,
            "--no-check" in run.run_command,
            "--streamk-workers" in run.compile_command,
            run.run_command[-1],
        )
        for run in prepared
    ]
    require(
        "matmul_perf_sweep_spatial",
        command_modes
        == [
            (False, False, False, "/tmp/wave-sweep-artifacts/runner"),
            (False, False, False, "/tmp/wave-sweep-artifacts/runner"),
        ],
        "checked spatial command plan changed",
    )


def check_spatial_sweep_modes(perf_sweep) -> None:
    unchecked = spatial_sweep_args(perf_sweep, k_values="64", check=False)
    unchecked_spec = perf_sweep.build_run_specs(unchecked)[0]
    require(
        "matmul_perf_sweep_spatial",
        "--no-check" in perf_sweep.calibrator_command(unchecked, unchecked_spec),
        "default spatial perf command should skip output checking",
    )
    default_keys = [kernel.key for kernel in perf_sweep.parse_kernel_csv("all")]
    deduplicated = [
        kernel.key for kernel in perf_sweep.parse_kernel_csv("all,f16-spatial")
    ]
    require(
        "matmul_perf_sweep_spatial",
        (default_keys.count("f16-spatial"), deduplicated) == (1, default_keys),
        "spatial alias should not duplicate or reorder the full sweep",
    )


def check_matmul_perf_sweep_spatial(perf_sweep) -> None:
    args = spatial_sweep_args(perf_sweep, k_values="64,128", check=True)
    specs = check_spatial_sweep_specs(perf_sweep, args)
    check_spatial_sweep_artifacts(perf_sweep, args, specs)
    check_spatial_sweep_modes(perf_sweep)
    print("matmul_perf_sweep_spatial: ok")


def streamk_sweep_args(
    perf_sweep, *, m: int, n: int, k: int, workers: int, input_mode: str
) -> argparse.Namespace:
    args = perf_sweep.build_argparser().parse_args(
        [
            "--kernels=f16-streamk",
            f"--m={m}",
            f"--n={n}",
            f"--k-values={k}",
            f"--streamk-workers={workers}",
            f"--{input_mode}",
            "--skip-rebuild",
            "--dry-run",
            "--artifact-dir=/tmp/wave-sweep-artifacts",
        ]
    )
    perf_sweep.validate_args(args)
    return args


def check_streamk_sweep_plan(
    perf_sweep,
    args: argparse.Namespace,
    *,
    workers: int,
    input_mode: str,
) -> None:
    check_name = "matmul_perf_sweep_streamk"
    specs = perf_sweep.build_run_specs(args)
    require(
        check_name,
        len(specs) == 1 and specs == perf_sweep.build_run_specs(args),
        "Stream-K dry-run matrix is not deterministic",
    )
    spec = specs[0]
    require(
        check_name,
        spec.kernel.profile == "gfx950-f16-256x256-4wave-streamk"
        and spec.streamk_workers == workers,
        "Stream-K profile or worker count mismatch",
    )
    command = perf_sweep.calibrator_command(args, spec)
    require(
        check_name,
        command[command.index("--streamk-workers") + 1] == str(workers)
        and f"--{input_mode}" in command,
        "Stream-K worker count or input mode not forwarded",
    )
    runners = {perf_sweep.Workload.MATMUL: Path("/tmp/wave-sweep-artifacts/runner")}
    prepared = perf_sweep.prepare_runs(args, specs, runners)
    require(
        check_name,
        prepared == perf_sweep.prepare_runs(args, specs, runners)
        and f"-w{workers}-" in prepared[0].hsaco.name,
        "Stream-K artifact plan is not deterministic",
    )


def check_matmul_perf_sweep_streamk(perf_sweep) -> None:
    check_name = "matmul_perf_sweep_streamk"
    default_keys = [kernel.key for kernel in perf_sweep.parse_kernel_csv("all")]
    require(
        check_name,
        default_keys.count("f16-streamk") == 1,
        "default sweep should include Stream-K exactly once",
    )
    deduplicated = [
        kernel.key
        for kernel in perf_sweep.parse_kernel_csv("all,f16-streamk,f16-streamk")
    ]
    require(
        check_name,
        deduplicated == default_keys,
        "Stream-K aliases should not duplicate or reorder the full sweep",
    )
    default_args = perf_sweep.build_argparser().parse_args(
        ["--k-values=8192", "--skip-rebuild", "--dry-run"]
    )
    perf_sweep.validate_args(default_args)
    default_streamk = [
        spec
        for spec in perf_sweep.build_run_specs(default_args)
        if spec.kernel.key == "f16-streamk"
    ]
    require(
        check_name,
        len(default_streamk) == 1 and default_streamk[0].streamk_workers == 256,
        "default run matrix should contain one 256-worker Stream-K run",
    )

    aligned = streamk_sweep_args(
        perf_sweep,
        m=8192,
        n=8192,
        k=8192,
        workers=256,
        input_mode="hpl",
    )
    check_streamk_sweep_plan(perf_sweep, aligned, workers=256, input_mode="hpl")
    split = streamk_sweep_args(
        perf_sweep,
        m=2048,
        n=2048,
        k=8192,
        workers=128,
        input_mode="rand-int",
    )
    check_streamk_sweep_plan(perf_sweep, split, workers=128, input_mode="rand-int")

    regular = perf_sweep.build_argparser().parse_args(
        ["--kernels=f16", "--k-values=8192", "--dry-run", "--skip-rebuild"]
    )
    perf_sweep.validate_args(regular)
    regular_spec = perf_sweep.build_run_specs(regular)[0]
    require(
        check_name,
        "--streamk-workers" not in perf_sweep.calibrator_command(regular, regular_spec),
        "regular f16 sweep gained Stream-K controls",
    )

    for argv in (
        ["--kernels=f16-streamk", "--streamk-workers=0"],
        ["--kernels=f16", "--streamk-workers=128"],
    ):
        bad = perf_sweep.build_argparser().parse_args(argv)
        try:
            perf_sweep.validate_args(bad)
        except SystemExit:
            continue
        require(check_name, False, f"accepted invalid Stream-K sweep args: {argv}")
    print(f"{check_name}: ok")


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
        args,
        specs,
        {perf_sweep.Workload.MATMUL: Path("/tmp/wave-sweep-artifacts/runner")},
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


MXFP4_AITER_SWEEP_KEYS = (
    "mxfp4-aiter-32x128",
    "mxfp4-aiter-64x128",
    "mxfp4-aiter-128x128",
    "mxfp4-aiter-128x256",
    "mxfp4-aiter-256x256",
)

DEFAULT_SWEEP_KEYS = (
    "f16",
    "f16-spatial",
    "f16-4wave",
    "f16-streamk",
    "mxfp4",
    "mxfp4-4wave",
    *MXFP4_AITER_SWEEP_KEYS,
    "v9",
    "v9-transposed",
    "fa-8wave",
)


def check_mxfp4_aiter_sweep_aliases(perf_sweep, check_name: str) -> None:
    aiter_alias = perf_sweep.KERNEL_ALIASES["mxfp4-aiter"]
    default_alias = perf_sweep.KERNEL_ALIASES["all"]
    require(
        check_name,
        aiter_alias == MXFP4_AITER_SWEEP_KEYS
        and len(aiter_alias) == len(set(aiter_alias)),
        "AITER alias has missing, duplicate, or reordered profiles",
    )
    require(
        check_name,
        default_alias == DEFAULT_SWEEP_KEYS
        and len(default_alias) == len(set(default_alias)),
        "default sweep has missing, duplicate, or reordered profiles",
    )
    kernels = perf_sweep.parse_kernel_csv("mxfp4-aiter")
    aiter_keys = tuple(kernel.key for kernel in kernels)
    require(
        check_name,
        aiter_keys == MXFP4_AITER_SWEEP_KEYS,
        "AITER alias expansion changed",
    )
    default_keys = tuple(kernel.key for kernel in perf_sweep.parse_kernel_csv("all"))
    deduplicated = tuple(
        kernel.key
        for kernel in perf_sweep.parse_kernel_csv("all,mxfp4-aiter,mxfp4-aiter")
    )
    require(
        check_name,
        default_keys == DEFAULT_SWEEP_KEYS and deduplicated == default_keys,
        "AITER default expansion is missing or duplicated",
    )


def check_mxfp4_aiter_sweep_commands(
    perf_sweep, matmul, args: argparse.Namespace, specs, check_name: str
) -> None:
    commands = [perf_sweep.calibrator_command(args, spec) for spec in specs]
    resolved_args = [matmul.parse_args(command[2:]) for command in commands]
    require(
        check_name,
        all("--kernel-profile" in command for command in commands),
        "AITER sweep lost named profiles",
    )
    require(
        check_name,
        all(
            resolved.mxfp4_input_layout == "aiter"
            and resolved.mxfp4_scale_path == "dma"
            for resolved in resolved_args
        ),
        "AITER sweep lost input layout or packed DMA scales",
    )


def check_matmul_perf_sweep_mxfp4_aiter(perf_sweep, matmul) -> None:
    check_name = "matmul_perf_sweep_mxfp4_aiter"
    check_mxfp4_aiter_sweep_aliases(perf_sweep, check_name)
    args = perf_sweep.build_argparser().parse_args(
        ["--kernels=mxfp4-aiter", "--skip-rebuild", "--dry-run"]
    )
    perf_sweep.validate_args(args)
    specs = perf_sweep.build_run_specs(args)
    profile_shapes = [
        (spec.kernel.profile, (spec.shape.m, spec.shape.n, spec.shape.k))
        for spec in specs
    ]
    require(
        check_name,
        profile_shapes
        == [
            ("gfx950-mxfp4-aiter-32x128", (256, 4096, 4096)),
            ("gfx950-mxfp4-aiter-64x128", (256, 8192, 4096)),
            ("gfx950-mxfp4-aiter-64x128", (512, 4096, 4096)),
            ("gfx950-mxfp4-aiter-128x128", (512, 8192, 4096)),
            ("gfx950-mxfp4-aiter-128x256", (2048, 4096, 8192)),
            ("gfx950-mxfp4-aiter-256x256", (2048, 8192, 4096)),
            ("gfx950-mxfp4-aiter-256x256", (2048, 8192, 8192)),
        ],
        "AITER profile-to-shape matrix changed",
    )
    check_mxfp4_aiter_sweep_commands(perf_sweep, matmul, args, specs, check_name)
    print(f"{check_name}: ok")


def make_perf_sweep_fa_args(perf_sweep) -> argparse.Namespace:
    args = perf_sweep.build_argparser().parse_args(
        [
            "--kernels=fa",
            "--fa-batch=3",
            "--fa-heads=5",
            "--fa-sequence=1024",
            "--fa-xcds=2",
            "--rocm-lib=/tmp/rocm-lib",
            "--check",
            "--skip-rebuild",
            "--dry-run",
            "--artifact-dir=/tmp/wave-sweep-artifacts",
        ]
    )
    perf_sweep.validate_args(args)
    return args


def check_perf_sweep_fa_shape(perf_sweep, spec, check_name: str) -> None:
    shape = spec.shape
    valid_shape = (
        isinstance(shape, perf_sweep.FlashAttentionShape)
        and shape.batch == 3
        and shape.heads == 5
        and shape.sequence == 1024
        and shape.head_dim == 128
        and shape.xcds == 2
        and shape.waves == 8
    )
    require(check_name, valid_shape, "FA sweep shape mismatch")
    require(
        check_name,
        spec.flops == 4 * 3 * 5 * 1024 * 1024 * 128,
        "FA sweep FLOP count mismatch",
    )


def check_perf_sweep_fa_plan(perf_sweep, args, spec, check_name: str):
    command = perf_sweep.calibrator_command(args, spec)
    has_shape_args = all(
        option in command for option in ("--batch", "--heads", "--sequence", "--waves")
    )
    require(
        check_name,
        has_shape_args
        and "--check" in command
        and "--kernel-profile" not in command
        and command[command.index("--rocm-lib") + 1] == "/tmp/rocm-lib",
        "FA calibrator command mismatch",
    )
    runners = {
        perf_sweep.Workload.FLASH_ATTENTION: Path("/tmp/wave-sweep-artifacts/fa-runner")
    }
    prepared = perf_sweep.prepare_runs(args, [spec], runners)[0]
    repeated = perf_sweep.prepare_runs(args, [spec], runners)[0]
    require(check_name, prepared == repeated, "FA command plan is not deterministic")
    require(
        check_name,
        "--emit-hsaco" in prepared.compile_command
        and "--run-hsaco" in prepared.run_command
        and prepared.run_command[-1] == "/tmp/wave-sweep-artifacts/fa-runner",
        "FA precompile plan mismatch",
    )
    require(
        check_name,
        prepared.hsaco.name == "000-fa-8wave-b3-h5-s1024-d128-w8-scheduled.hsaco",
        "FA artifact name mismatch",
    )
    return prepared


def check_perf_sweep_fa_result(perf_sweep, spec, prepared, check_name: str) -> None:
    output = "output_check: passed max_abs_diff=0.001\nmedian_per_launch_us: 100.000\n"
    result = perf_sweep.parse_result(
        spec,
        prepared.run_command,
        subprocess.CompletedProcess(prepared.run_command, 0, output, ""),
    )
    require(
        check_name,
        result.micros == 100.0
        and result.check == "passed"
        and result.tflops == spec.flops / 100.0 * 1.0e-6,
        "FA result parsing mismatch",
    )


def check_perf_sweep_fa_validation(perf_sweep, check_name: str) -> None:
    bad_args = (
        ["--kernels=fa", "--all-ones"],
        ["--kernels=fa", "--chip=gfx1100"],
        ["--kernels=fa", "--variants=baseline"],
    )
    for argv in bad_args:
        bad = perf_sweep.build_argparser().parse_args(argv)
        try:
            perf_sweep.validate_args(bad)
        except SystemExit:
            continue
        require(check_name, False, f"FA sweep accepted invalid args: {argv}")


def check_perf_sweep_fa_8wave(perf_sweep) -> None:
    check_name = "perf_sweep_fa_8wave"
    default_keys = [kernel.key for kernel in perf_sweep.parse_kernel_csv("all")]
    require(
        check_name,
        default_keys.count("fa-8wave") == 1,
        "default sweep should include 8-wave FA exactly once",
    )
    deduplicated = [
        kernel.key for kernel in perf_sweep.parse_kernel_csv("all,fa,fa-8wave")
    ]
    require(
        check_name,
        deduplicated == default_keys,
        "FA aliases should not duplicate or reorder the full sweep",
    )
    args = make_perf_sweep_fa_args(perf_sweep)
    specs = perf_sweep.build_run_specs(args)
    require(
        check_name,
        len(specs) == 1 and specs == perf_sweep.build_run_specs(args),
        "FA alias should select one deterministic run",
    )
    spec = specs[0]
    check_perf_sweep_fa_shape(perf_sweep, spec, check_name)
    prepared = check_perf_sweep_fa_plan(perf_sweep, args, spec, check_name)
    check_perf_sweep_fa_result(perf_sweep, spec, prepared, check_name)
    check_perf_sweep_fa_validation(perf_sweep, check_name)
    print(f"{check_name}: ok")


def check_matmul_perf_sweep_rand_int_forwarding(perf_sweep) -> None:
    args = perf_sweep.build_argparser().parse_args(
        [
            "--kernels=f16",
            "--rand-int",
            "--multi-wave-specialize",
            "--skip-rebuild",
            "--dry-run",
        ]
    )
    perf_sweep.validate_args(args)
    spec = perf_sweep.build_run_specs(args)[0]
    cmd = perf_sweep.calibrator_command(args, spec)
    require(
        "matmul_perf_sweep_rand_int_forwarding",
        "--rand-int" in cmd,
        "perf sweep command missing --rand-int",
    )
    require(
        "matmul_perf_sweep_rand_int_forwarding",
        "--multi-wave-specialize" in cmd,
        "perf sweep command missing specialization flag",
    )
    hpl_args = perf_sweep.build_argparser().parse_args(
        ["--kernels=f16", "--hpl", "--skip-rebuild", "--dry-run"]
    )
    perf_sweep.validate_args(hpl_args)
    hpl_spec = perf_sweep.build_run_specs(hpl_args)[0]
    hpl_cmd = perf_sweep.calibrator_command(hpl_args, hpl_spec)
    require(
        "matmul_perf_sweep_rand_int_forwarding",
        "--hpl" in hpl_cmd,
        "perf sweep command missing --hpl",
    )

    try:
        perf_sweep.build_argparser().parse_args(["--all-ones", "--rand-int"])
    except SystemExit:
        pass
    else:
        require(
            "matmul_perf_sweep_rand_int_forwarding",
            False,
            "perf sweep accepted conflicting input modes",
        )

    bad = perf_sweep.build_argparser().parse_args(["--kernels=mxfp4", "--rand-int"])
    try:
        perf_sweep.validate_args(bad)
    except SystemExit:
        pass
    else:
        require(
            "matmul_perf_sweep_rand_int_forwarding",
            False,
            "perf sweep accepted MXFP4 rand_int",
        )
    bad = perf_sweep.build_argparser().parse_args(["--kernels=mxfp4", "--hpl"])
    try:
        perf_sweep.validate_args(bad)
    except SystemExit:
        pass
    else:
        require(
            "matmul_perf_sweep_rand_int_forwarding",
            False,
            "perf sweep accepted MXFP4 HPL",
        )
    print("matmul_perf_sweep_rand_int_forwarding: ok")


def check_calibration_scheduler_options(matmul, fa) -> None:
    matmul_args = matmul.parse_args(["--chip=gfx950", "--skip-hw"])
    matmul_variant = matmul.VARIANTS["scheduled"]
    matmul_pass = matmul.schedule_pass_options(matmul_variant)
    matmul_report = matmul.schedule_report_options(matmul_variant, matmul_args)
    require(
        "calibration_scheduler_options",
        matmul_pass == {"apply-schedule": True},
        "matmul apply options drifted",
    )
    require(
        "calibration_scheduler_options",
        matmul_report == {},
        "matmul report should stay empty without report flags",
    )

    fa_args = fa.build_argparser().parse_args(
        ["--chip=gfx950", "--print-candidates", "--skip-hw"]
    )
    fa_variant = fa.VARIANTS["scheduled"]
    fa_pass = fa.schedule_pass_options(fa_variant)
    fa_report = fa.schedule_report_options(fa_variant, fa_args)
    require(
        "calibration_scheduler_options",
        fa_pass == {"apply-schedule": True},
        "FA apply options drifted",
    )
    require(
        "calibration_scheduler_options",
        fa_report == {"print-candidates": True},
        "FA report options drifted",
    )
    print("calibration_scheduler_options: ok")


def main() -> int:
    common = load_module(
        "wave_calibration",
        REPO_ROOT / "tools/wave_calibration.py",
    )
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
    matmul_example = load_module(
        "wave_matmul_example",
        REPO_ROOT / "examples/wave/wmma_matmul_tiled.py",
    )
    check_calibration_entry("matmul_pipeline", matmul)
    check_calibration_entry("fa_pipeline", fa)
    check_shared_calibration_support(common, matmul, fa)
    check_matmul_wave_size(matmul)
    check_matmul_gfx1250_profile(matmul)
    check_matmul_gfx1250_selection_rejection(matmul)
    check_matmul_runner_wave_size(matmul)
    check_matmul_runner_output_layout(matmul)
    check_matmul_bf16_forwarding(matmul)
    check_matmul_multi_wave_specialization_forwarding(matmul)
    check_matmul_rand_int_forwarding(matmul)
    check_matmul_hpl_forwarding(matmul)
    check_matmul_streamk_profile(matmul)
    check_matmul_mxfp4_forwarding_and_trip_count(matmul)
    check_matmul_mxfp4_dma_forwarding(matmul)
    check_matmul_mxfp4_scale_regs_forwarding(matmul)
    check_matmul_mxfp4_profile_kernel_only_target_waves(matmul)
    check_matmul_profile_cli_override(matmul)
    check_matmul_f16_8wave_profile(matmul)
    check_matmul_f16_spatial_profile(matmul)
    check_matmul_mxfp4_4wave_profile(matmul)
    check_matmul_mxfp4_aiter_profiles(matmul, matmul_example)
    check_matmul_runtime_count_validation(matmul)
    check_matmul_f16_4wave_profile(matmul)
    check_matmul_dynamic_lds_forwarding(matmul)
    check_matmul_f16_dma_buffer_count(matmul)
    check_matmul_dma_sim_trip_count(matmul)
    check_matmul_v9_perf_golden_profile(matmul)
    check_matmul_v9_transposed_perf_golden_profile(matmul)
    check_matmul_a4w4_mxfp_k16k_profile(matmul)
    check_matmul_perf_sweep_v9_defaults(perf_sweep)
    check_matmul_perf_sweep_f16_profiles(perf_sweep)
    check_matmul_perf_sweep_spatial(perf_sweep)
    check_matmul_perf_sweep_streamk(perf_sweep)
    check_matmul_perf_sweep_precompile_plan(perf_sweep)
    check_matmul_perf_sweep_mxfp4_aiter(perf_sweep, matmul)
    check_perf_sweep_fa_8wave(perf_sweep)
    check_matmul_perf_sweep_rand_int_forwarding(perf_sweep)
    check_calibration_scheduler_options(matmul, fa)
    try:
        matmul.parse_variants("pingpong")
    except argparse.ArgumentTypeError:
        print("matmul_pingpong_removed: ok")
        return 0
    print("matmul_pingpong_removed: still accepted", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
