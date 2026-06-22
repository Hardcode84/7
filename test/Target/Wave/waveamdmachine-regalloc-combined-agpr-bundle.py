# RUN: %python %s %wave_obj_root/bin/wave-opt

from __future__ import annotations

import subprocess
import sys


def build_module() -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        (
            "func.func @combined_pressure_bundles_agpr_spills() "
            "attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>, "
            "waveamdmachine.target_waves = 8 : i64} {"
        ),
        "  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
    ]
    for index in range(10):
        lines.append(
            f"  %ag{index} = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>"
        )
    for index in range(4):
        lines.extend(
            [
                (
                    f"  %src{index} = waveamdmachine.v_mov_b32_tuple %zero "
                    "{registers = 1 : i64, waveamdmachine.regalloc_debug_temp} "
                    ": (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>"
                ),
                (
                    f"  %ag_spill{index} = waveamdmachine.v_accvgpr_write_b32_tuple "
                    f"%src{index} {{waveamdmachine.regalloc_debug_temp}} "
                    ": (!waveamdmachine.reg<vgpr, 1>) -> "
                    "!waveamdmachine.reg<agpr, 1>"
                ),
            ]
        )
    for index in range(18):
        lines.append(
            f"  %v{index} = waveamdmachine.v_mov_b32_tuple %zero "
            "{registers = 1 : i64, waveamdmachine.regalloc_debug_temp} "
            ": (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>"
        )
    for index in range(4):
        lines.append(
            f"  %read{index} = waveamdmachine.v_accvgpr_read_b32_tuple "
            f"%ag_spill{index} : (!waveamdmachine.reg<agpr, 1>) -> "
            "!waveamdmachine.reg<vgpr, 1>"
        )
    lines.append(
        "  %use0 = waveamdmachine.v_add_u32 %read0, %read1 "
        ": (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) "
        "-> !waveamdmachine.reg<vgpr, 1>"
    )
    lines.append(
        "  %use1 = waveamdmachine.v_add_u32 %use0, %read2 "
        ": (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) "
        "-> !waveamdmachine.reg<vgpr, 1>"
    )
    lines.append(
        "  %use2 = waveamdmachine.v_add_u32 %use1, %read3 "
        ": (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) "
        "-> !waveamdmachine.reg<vgpr, 1>"
    )
    for index in range(9):
        lhs = index * 2
        rhs = lhs + 1
        lines.append(
            f"  %sum{index} = waveamdmachine.v_add_u32 %v{lhs}, %v{rhs} "
            ": (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) "
            "-> !waveamdmachine.reg<vgpr, 1>"
        )
    lines.append(
        "  %usev = waveamdmachine.v_add_u32 %sum8, %use2 "
        ": (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) "
        "-> !waveamdmachine.reg<vgpr, 1>"
    )
    lines.append(
        "  %acc0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} "
        ": (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>"
    )
    previous = "%acc0"
    for index in range(10):
        lhs = f"%ag{index}"
        rhs = f"%ag{(index + 1) % 10}"
        lines.append(
            f"  %mfma{index} = waveamdmachine.mfma_f32_16x16x32_f16 "
            f"{lhs}, {rhs}, {previous} : (!waveamdmachine.reg<agpr, 4>, "
            "!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<vgpr, 4>) "
            "-> !waveamdmachine.reg<vgpr, 4>"
        )
        previous = f"%mfma{index}"
    lines.extend(["  waveamdmachine.s_endpgm", "  return", "}", "}"])
    return "\n".join(lines) + "\n"


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


def main() -> int:
    if len(sys.argv) != 2:
        fail("expected path to wave-opt")
    result = subprocess.run(
        [
            sys.argv[1],
            "--waveamd-reg-alloc=mark-overflow=true",
            "--waveamd-resource-info",
            "-",
        ],
        input=build_module(),
        text=True,
        capture_output=True,
        timeout=20,
        check=False,
    )
    if result.returncode != 0:
        fail(result.stderr or result.stdout)
    if "waveamdmachine.regalloc_overflowed = 1" in result.stdout:
        fail("bundled AGPR scratch spill did not solve combined pressure")
    if "waveamdmachine.scratch_spill_bytes = 8 : i64" not in result.stdout:
        fail("expected bundled one-dword AGPR scratch spills")
    if "waveamdmachine.lds_spill_bytes" in result.stdout:
        fail("AGPR bundle should not select LDS spill")
    if result.stdout.count("waveamdmachine.scratch_store_b32") < 2:
        fail("expected scratch stores for bundled AGPR spills")
    if result.stdout.count("waveamdmachine.scratch_load_b32") < 2:
        fail("expected scratch reloads for bundled AGPR spills")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
