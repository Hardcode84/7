# RUN: %python %s wave-opt | FileCheck %s

# CHECK: multi-wave specialization: 2049-op loop cloned

from __future__ import annotations

import subprocess
import sys

OP_COUNT = 2049


def build_source() -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        "  func.func @large_loop(%cond: !waveamdmachine.reg<scc, 1>)",
        "      attributes {gpu.known_block_size = array<i32: 256, 1, 1>,",
        "                  wave.kernel,",
        "                  wave.workgroup_size = array<i32: 256, 1, 1>,",
        "                  waveamdmachine.enable_multi_wave_specialization,",
        "                  waveamdmachine.schedule_input,",
        "                  waveamdmachine.target_waves = 1 : i64} {",
        "    waveamdmachine.uniform_loop {",
    ]
    lines.extend(
        f"      %value{i} = waveamdmachine.imm 1 : !waveamdmachine.imm"
        for i in range(OP_COUNT)
    )
    lines.extend(
        [
            "      waveamdmachine.continue_if %cond",
            "          : !waveamdmachine.reg<scc, 1>",
            "    }",
            "    return",
            "  }",
            "}",
        ]
    )
    return "\n".join(lines) + "\n"


def main() -> None:
    proc = subprocess.run(
        [
            sys.argv[1],
            "-",
            "--pass-pipeline=builtin.module("
            "waveamd-machine-multi-wave-specialize,"
            "waveamd-machine-schedule{apply-schedule=true "
            "require-selected-input=true max-region-ops=0})",
        ],
        input=build_source(),
        text=True,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        print(proc.stderr, file=sys.stderr)
        raise SystemExit(proc.returncode)
    if proc.stdout.count("waveamdmachine.uniform_loop") != 2:
        raise SystemExit("large loop was not cloned")
    if "waveamdmachine.multi_wave_schedule" in proc.stdout:
        raise SystemExit("large loop scheduling marker was not consumed")
    if proc.stdout.count("waveamdmachine.imm 1") != 2 * OP_COUNT:
        raise SystemExit("large loop clone lost operations")
    print(f"multi-wave specialization: {OP_COUNT}-op loop cloned and scheduled")


if __name__ == "__main__":
    main()
