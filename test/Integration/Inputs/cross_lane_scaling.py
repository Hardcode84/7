# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Bound cross-lane matching on live unmatched candidates and a shared DAG."""

import argparse
import subprocess

from cross_lane_exec import binary, prelude

HEADER = """!v = !waveamdmachine.reg<vgpr, 1>
!s = !waveamdmachine.reg<sgpr, 2>
!s1 = !waveamdmachine.reg<sgpr, 1>
!c = !waveamdmachine.reg<scc, 1>
!cc = !waveamdmachine.reg<vcc, 1>
!i = !waveamdmachine.imm
!t = !waveamdmachine.mem.token
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
"""


def unmatched_candidates(kind, size, depth):
    code = ""
    address = "lo_addr"
    if kind == "shared":
        for index in range(depth):
            name = f"prefix{index}"
            code += binary(name, "v_add_u32", address, "c0", "!i")
            address = name
    if kind == "select":
        for data in ("a", "b"):
            code += binary(f"{data}_lo", "ds_bpermute_b32", "lo_addr", data)
    for index in range(size):
        if kind == "shared":
            name = f"address{index}"
            code += binary(name, "v_add_u32", address, "c0", "!i")
            code += binary(f"result{index}", "ds_bpermute_b32", name, "a")
        elif kind == "broadcast":
            code += binary(f"result{index}", "ds_bpermute_b32", address, "a")
        else:
            code += (
                f"  %result{index} = waveamdmachine.v_cndmask_b32_tuple "
                "%a_lo, %b_lo, %condition : (!v, !v, !s) -> !v\n"
            )
    return code


def stress_module(kind, size, depth):
    code = HEADER + prelude(kind, "scaling")
    if kind == "dag":
        code += "  %opaque = waveamdmachine.v_mov_b32_tuple %c0 : (!i) -> !v\n"
        previous = "opaque"
        for index in range(depth):
            name = f"dag{index}"
            code += binary(name, "v_add_u32", previous, previous)
            previous = name
        code += binary("result0", "ds_bpermute_b32", previous, "a")
        count = 1
    else:
        count = size
        code += unmatched_candidates(kind, size, depth)
    for index in range(count):
        dependency = f" after %store{index - 1}" if index else ""
        token_type = ", !t" if index else ""
        code += (
            f"  %store{index} = waveamdmachine.global_store_b32 "
            f"%item_addr, %result{index}, %base{dependency} "
            f": (!v, !v, !s{token_type}) -> !t\n"
        )
    code += f"  waveamdmachine.s_endpgm after %store{count - 1} : !t\n"
    return code + "  return\n}\n}\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--wave-opt", required=True)
    parser.add_argument("--size", type=int, default=2048)
    parser.add_argument("--depth", type=int, default=48)
    args = parser.parse_args()
    for kind in ("dag", "broadcast", "select", "shared"):
        result = subprocess.run(
            [args.wave_opt, "--waveamd-cross-lane-peepholes"],
            input=stress_module(kind, args.size, args.depth),
            text=True,
            capture_output=True,
            timeout=30,
            check=True,
        )
        counts = {"dag": 1, "broadcast": args.size, "select": 2, "shared": args.size}
        assert result.stdout.count("waveamdmachine.ds_bpermute_b32") == counts[kind]
        assert "waveamdmachine.v_permlane32_swap" not in result.stdout
        if kind == "select":
            assert result.stdout.count("waveamdmachine.v_cndmask") == args.size
        print(f"{kind}: passed")


if __name__ == "__main__":
    main()
