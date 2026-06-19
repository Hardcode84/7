# RUN: %python %s %wave_obj_root/bin/wave-opt

from __future__ import annotations

import subprocess
import sys


def build_module(interval_count: int) -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {',
        (
            "func.func @combined_pressure_scan_smoke() "
            "attributes {waveamdmachine.target_waves = 4 : i64} {"
        ),
        "  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
        (
            "  %v = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} "
            ": (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>"
        ),
    ]
    last_vgpr = "%v"
    for index in range(interval_count):
        lines.extend(
            [
                (
                    f"  %s{index} = waveamdmachine.s_mov_b32_value %zero "
                    ": (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>"
                ),
                (
                    f"  %u{index} = waveamdmachine.s_mov_b32_tuple %s{index} "
                    "{registers = 1 : i64} : (!waveamdmachine.reg<sgpr, 1>) "
                    "-> !waveamdmachine.reg<sgpr, 1>"
                ),
            ]
        )
        if index % 512 == 0:
            lines.append(
                f"  %vv{index} = waveamdmachine.v_mov_b32_tuple {last_vgpr} "
                "{registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1>) "
                "-> !waveamdmachine.reg<vgpr, 1>"
            )
            last_vgpr = f"%vv{index}"
    lines.extend(["  waveamdmachine.s_endpgm", "  return", "}", "}"])
    return "\n".join(lines) + "\n"


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


def main() -> int:
    if len(sys.argv) != 2:
        fail("expected path to wave-opt")
    wave_opt = sys.argv[1]

    try:
        result = subprocess.run(
            [wave_opt, "--waveamd-reg-alloc", "--waveamd-resource-info", "-"],
            input=build_module(8192),
            text=True,
            capture_output=True,
            timeout=20,
            check=False,
        )
    except subprocess.TimeoutExpired:
        fail("waveamd-reg-alloc timed out on combined-pressure scan repro")

    if result.returncode != 0:
        fail(result.stderr or result.stdout)
    if "func.func @combined_pressure_scan_smoke" not in result.stdout:
        fail("missing generated repro function in regalloc output")
    if "waveamdmachine.regalloc_overflowed" in result.stdout:
        fail("generated repro unexpectedly overflowed register allocation")
    if "waveamdmachine.vgpr_count" not in result.stdout:
        fail("resource info did not annotate VGPR usage")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
