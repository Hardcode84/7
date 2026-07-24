#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""HW microbench harness for wave-mlir (Stage 3 of the AMDGPU scheduler design).

Takes an MLIR kernel (a `func.func @kernel_name(%out: !wave.ptr<i32, ...>)`),
lowers it to an hsaco via the project's wave-translate pipeline, compiles
the generic runner with hipcc, and runs the kernel in a timed loop.
Reports wallclock-derived cycles per launch + the predicted cycles from
`wave.transform.estimate_cycles` if `--predict` is set.

Usage:
    wave-microbench [options] <kernel.mlir>

Defaults assume the project layout (build/ at repo root, tools/wave-microbench
source colocated). Override via env or CLI flags.

This is a first-cut harness; rocprofv3 PMC counter capture (`GRBM_GUI_ACTIVE`
for cycle-exact measurement) is a follow-up. The wallclock estimate is good
enough for ranking microbench variants on the same host.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
RUNNER_SRC = REPO_ROOT / "tools/wave-microbench/wave-microbench-runner.cpp"
sys.path.insert(0, str(REPO_ROOT / "examples/wave"))

from common import default_build_dir, resolve_llvm_tool, resolve_wave_tool  # noqa: E402


def detect_chip() -> str:
    rocminfo = shutil.which("rocminfo")
    if rocminfo is None:
        sys.exit("no rocminfo on PATH; cannot detect AMDGPU chip")
    out = subprocess.run([rocminfo], capture_output=True, text=True, check=True).stdout
    for line in out.splitlines():
        line = line.strip()
        if line.startswith("Name:") and "gfx" in line:
            return line.split()[-1]
    sys.exit("rocminfo did not report a gfx Name")


def compile_runner(build_dir: Path, hipcc: str, tmp: Path) -> Path:
    runner_bin = tmp / "wave-microbench-runner"
    cmd = [hipcc, "-O2", str(RUNNER_SRC), "-o", str(runner_bin)]
    subprocess.run(cmd, check=True)
    return runner_bin


def lower_to_hsaco(build_dir: Path, chip: str, mlir_in: Path, tmp: Path) -> Path:
    """Drive the wave-translate -> llvm-mc -> ld.lld pipeline that
    test/Target/Wave/waveamdmachine-buffer-hw.mlir uses, parameterised
    on the detected chip."""
    wave_translate = resolve_wave_tool("wave-translate", build_dir)
    llvm_mc = resolve_llvm_tool("llvm-mc", build_dir)
    ld_lld = resolve_llvm_tool("ld.lld", build_dir)
    for tool in (wave_translate, llvm_mc, ld_lld):
        if not tool.exists():
            sys.exit(f"required tool missing: {tool}")

    # Substitute the chip token so the input MLIR can carry a placeholder.
    text = mlir_in.read_text()
    text = re.sub(r"gfx\d+", chip, text)
    munged = tmp / (mlir_in.stem + ".chip.mlir")
    munged.write_text(text)

    asm = tmp / (mlir_in.stem + ".s")
    obj = tmp / (mlir_in.stem + ".o")
    hsaco = tmp / (mlir_in.stem + ".hsaco")

    with asm.open("w") as f:
        subprocess.run(
            [str(wave_translate), "--wave-to-amdgpu-asm", str(munged)],
            check=True,
            stdout=f,
        )
    subprocess.run(
        [
            str(llvm_mc),
            "-triple=amdgcn-amd-amdhsa",
            f"-mcpu={chip}",
            "-filetype=obj",
            "-o",
            str(obj),
            str(asm),
        ],
        check=True,
    )
    subprocess.run([str(ld_lld), "-shared", str(obj), "-o", str(hsaco)], check=True)
    return hsaco


def predict_cycles(
    build_dir: Path, mlir_in: Path, chip: str, kernel: str, tmp: Path
) -> int | None:
    """Run wave.transform.estimate_cycles on the kernel via wave-opt.
    Returns the predicted i64 from the transform output, or None on
    failure."""
    wave_opt = resolve_wave_tool("wave-opt", build_dir)
    if not wave_opt.exists():
        return None
    text = mlir_in.read_text()
    text = re.sub(r"gfx\d+", chip, text)
    # Inject a transform sequence that runs estimate_cycles and stamps
    # the result back as a module attribute we can parse out.
    snippet = f"""
module attributes {{transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--{chip}"}} {{
{text}

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {{transform.readonly}}) {{
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    transform.print %c : !transform.param<i64>
    transform.yield
  }}
}}
"""
    src = tmp / (mlir_in.stem + ".predict.mlir")
    src.write_text(snippet)
    try:
        out = subprocess.run(
            [
                str(wave_opt),
                str(src),
                "--pass-pipeline=builtin.module(transform-interpreter)",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        print("predict failed:", e.stderr, file=sys.stderr)
        return None
    # transform.print emits something like "<<<i64 : N>>>" -- grab the int.
    m = re.search(r"\bi64\b[^0-9-]*(-?\d+)", out.stdout + out.stderr)
    if not m:
        return None
    return int(m.group(1))


def build_argparser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("mlir", type=Path, help="input MLIR kernel")
    ap.add_argument("--kernel", default=None, help="kernel name (default: first func)")
    ap.add_argument("--iters", type=int, default=1000)
    ap.add_argument("--warmup", type=int, default=10)
    ap.add_argument("--grid", default="1,1,1")
    ap.add_argument("--block", default="32,1,1")
    ap.add_argument(
        "--buf-elems",
        type=int,
        default=None,
        help="i32 output buffer size; defaults to grid*block on the runner",
    )
    ap.add_argument(
        "--build-dir",
        type=Path,
        default=default_build_dir(REPO_ROOT),
    )
    ap.add_argument(
        "--hipcc",
        default=os.environ.get("HIPCC", "/opt/rocm/bin/hipcc"),
        help="hipcc path (default /opt/rocm/bin/hipcc)",
    )
    ap.add_argument(
        "--rocm-lib",
        default=os.environ.get("ROCM_LIB", "/opt/rocm/lib"),
        help="ROCm lib dir for LD_LIBRARY_PATH at run time",
    )
    ap.add_argument(
        "--predict",
        action="store_true",
        help="run wave.transform.estimate_cycles and print predicted vs measured",
    )
    ap.add_argument(
        "--inner",
        type=int,
        default=None,
        help="inner-loop trip count for repeat-body kernels"
        " (passed as the 2nd i32 arg; runner sees --args=2 --x N)",
    )
    ap.add_argument(
        "--in-kernel-cycles",
        action="store_true",
        help="for kernels that store t0/t1 in out[0]/out[1] via"
        " wave.read_cycles, dump those slots and report dt"
        " (gfx11 20-bit shader-cycles wrap is unwrapped)",
    )
    return ap


def detect_kernel(mlir_path: Path, override: str | None) -> str:
    if override:
        return override
    for line in mlir_path.read_text().splitlines():
        m = re.search(r"func\.func\s+@(\w+)", line)
        if m:
            return m.group(1)
    sys.exit("could not detect kernel name; pass --kernel")


def run_kernel(
    runner_bin: Path, hsaco: Path, kernel: str, args: argparse.Namespace
) -> str:
    env = os.environ.copy()
    existing_ld = env.get("LD_LIBRARY_PATH", "")
    env["LD_LIBRARY_PATH"] = args.rocm_lib + (":" + existing_ld if existing_ld else "")
    cmd = [
        str(runner_bin),
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
        "--grid",
        args.grid,
        "--block",
        args.block,
    ]
    if args.buf_elems is not None:
        cmd += ["--buf-elems", str(args.buf_elems)]
    if args.inner is not None:
        cmd += ["--args", "2", "--x", str(args.inner)]
    if args.in_kernel_cycles:
        cmd += ["--dump-out", "2"]
    cmd += [str(hsaco), kernel]
    result = subprocess.run(cmd, check=True, capture_output=True, text=True, env=env)
    return result.stdout


def report_in_kernel_cycles(runner_stdout: str) -> None:
    """Parse out[0]=t0 and out[1]=t1 from runner stdout and report dt.
    gfx11 HW_REG_SHADER_CYCLES is 20 bits; we unwrap with mod 2^20."""
    slots: dict[int, int] = {}
    for line in runner_stdout.splitlines():
        m = re.match(r"out\[(\d+)\]: (-?\d+)", line)
        if m:
            slots[int(m.group(1))] = int(m.group(2))
    if 0 not in slots or 1 not in slots:
        return
    t0, t1 = slots[0], slots[1]
    mask = (1 << 20) - 1
    dt = (t1 - t0) & mask
    print(
        f"in_kernel_cycles_t0: {t0 & mask}\n"
        f"in_kernel_cycles_t1: {t1 & mask}\n"
        f"in_kernel_cycles_dt: {dt}"
    )


def report_predicted_vs_measured(runner_stdout: str, predicted: int) -> None:
    measured = None
    for line in runner_stdout.splitlines():
        m = re.match(r"per_launch_cycles_wallclock: (\d+)", line)
        if m:
            measured = int(m.group(1))
            break
    if measured is None:
        print(f"predicted_cycles: {predicted}")
        return
    delta_pct = 100.0 * (measured - predicted) / max(predicted, 1)
    print(
        f"predicted_cycles: {predicted}\n"
        f"delta_vs_predicted: {measured - predicted}"
        f" ({delta_pct:+.1f}%)"
    )


def main() -> int:
    args = build_argparser().parse_args()
    if not args.mlir.exists():
        sys.exit(f"no such file: {args.mlir}")
    if not Path(args.hipcc).exists() and shutil.which(args.hipcc) is None:
        sys.exit(f"hipcc not found: {args.hipcc}")

    chip = detect_chip()
    kernel = detect_kernel(args.mlir, args.kernel)
    print(f"chip: {chip}\nkernel: {kernel}")

    with tempfile.TemporaryDirectory() as tmpstr:
        tmp = Path(tmpstr)
        runner_bin = compile_runner(args.build_dir, args.hipcc, tmp)
        hsaco = lower_to_hsaco(args.build_dir, chip, args.mlir, tmp)
        predicted: int | None = None
        if args.predict:
            predicted = predict_cycles(args.build_dir, args.mlir, chip, kernel, tmp)
        out = run_kernel(runner_bin, hsaco, kernel, args)
        print(out, end="")
        if predicted is not None:
            report_predicted_vs_measured(out, predicted)
        if args.in_kernel_cycles:
            report_in_kernel_cycles(out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
