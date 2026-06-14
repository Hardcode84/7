# RUN: %python %s %wave_pipelines | FileCheck %s

# CHECK: matmul_pipeline: ok
# CHECK: fa_pipeline: ok
# CHECK: matmul_explicit_gfx950_wave_size: ok
# CHECK: matmul_auto_gfx950_wave_size: ok
# CHECK: matmul_runner_gfx950_wave_size: ok
# CHECK: matmul_bf16_forwarding: ok
# CHECK: matmul_mxfp4_forwarding_and_trip_count: ok
# CHECK: matmul_mxfp4_dma_forwarding: ok
# CHECK: matmul_mxfp4_profile_kernel_only_target_waves: ok
# CHECK: matmul_profile_cli_override: ok
# CHECK: matmul_mxfp4_4wave_profile: ok
# CHECK: matmul_dynamic_lds_forwarding: ok
# CHECK: matmul_dma_sim_trip_count: ok
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


def check_calibration_entry(label: str, module) -> None:
    text = module.pipeline_text(
        BUILD_DIR,
        schedule_options={"apply-schedule": True, "pressure-aware-selection": True},
        report_options={"print-candidates": True},
    )
    ir, _ = module.import_mlir_bindings(BUILD_DIR)
    with ir.Context():
        parsed = ir.Module.parse(text)
        entry = find_named_sequence(ir, parsed, "__transform_main")
        finish = find_named_sequence(ir, parsed, "waveamd_backend_finish")
        require(label, entry is not None, "missing __transform_main")
        require(label, finish is not None, "missing backend finish")
        includes = included_sequences(ir, entry)
        require(label, "waveamd_backend_lower" in includes, "no lower include")
        require(label, "waveamd_backend_finish" in includes, "no finish include")
        entry_passes = applied_passes(ir, entry)
        require(label, "waveamd-reg-alloc" not in entry_passes, "entry spells regalloc")
        require(
            label,
            "waveamd-insert-hazard-waits" not in entry_passes,
            "entry spells hazard waits",
        )
        finish_passes = applied_passes(ir, finish)
        try:
            ticket = finish_passes.index("waveamd-insert-ticket-waits")
            regalloc = finish_passes.index("waveamd-reg-alloc")
            hazard = finish_passes.index("waveamd-insert-hazard-waits")
        except ValueError as err:
            require(label, False, f"missing finish pass: {err}")
        require(label, ticket < regalloc < hazard, "finish pass order drifted")
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
            "--k=128",
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
        args.input_type == "mxfp4" and args.output_type == "f16",
        "bad 4-wave dtypes",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        matmul.effective_target_waves(args) == 1,
        "4-wave profile should request one wave per SIMD",
    )
    require(
        "matmul_mxfp4_4wave_profile",
        matmul.compute_lds_bytes(args) == 40960,
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
        matmul.run_sim_reports(Path("build"), Path("machine.mlir"), report_args)
    finally:
        matmul.run = old_run
    require("matmul_dma_sim_trip_count", bool(captured), "sim report not called")
    require(
        "matmul_dma_sim_trip_count",
        all("--trip-count=1" in cmd for cmd in captured),
        "DMA sim reports should use V - 2",
    )
    print("matmul_dma_sim_trip_count: ok")


def main() -> int:
    matmul = load_module(
        "wave_matmul_calibrate",
        REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py",
    )
    fa = load_module(
        "wave_fa_calibrate",
        REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-calibrate.py",
    )
    check_calibration_entry("matmul_pipeline", matmul)
    check_calibration_entry("fa_pipeline", fa)
    check_matmul_wave_size(matmul)
    check_matmul_runner_wave_size(matmul)
    check_matmul_bf16_forwarding(matmul)
    check_matmul_mxfp4_forwarding_and_trip_count(matmul)
    check_matmul_mxfp4_dma_forwarding(matmul)
    check_matmul_mxfp4_profile_kernel_only_target_waves(matmul)
    check_matmul_profile_cli_override(matmul)
    check_matmul_mxfp4_4wave_profile(matmul)
    check_matmul_dynamic_lds_forwarding(matmul)
    check_matmul_dma_sim_trip_count(matmul)
    try:
        matmul.parse_variants("pingpong")
    except argparse.ArgumentTypeError:
        print("matmul_pingpong_removed: ok")
        return 0
    print("matmul_pingpong_removed: still accepted", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
