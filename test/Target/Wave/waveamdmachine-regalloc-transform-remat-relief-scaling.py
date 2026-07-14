# RUN: %python %s wave-opt | FileCheck %s

# CHECK: large shared-leaf bundle: 40 roots

from __future__ import annotations

import subprocess
import sys
import time

REG = "!waveamdmachine.reg<vgpr, 1>"


def build_source() -> str:
    returns = ", ".join([REG for _ in range(40)])
    values = ", ".join([f"%root{i}" for i in range(40)])
    types = ", ".join([REG for _ in range(40)])
    lines = [
        "module attributes {transform.with_named_sequence} {",
        "  transform.named_sequence @match_func(",
        "      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {",
        '    transform.match.operation_name %root ["func.func"] : !transform.any_op',
        "    transform.yield %root : !transform.any_op",
        "  }",
        "  transform.named_sequence @remat_relief(",
        "      %root: !transform.any_op {transform.readonly}) {",
        "    %func = transform.collect_matching @match_func in %root",
        "        : (!transform.any_op) -> !transform.any_op",
        "    %r0 = wave.transform.regalloc_build_alias_state from %func",
        "        : (!transform.any_op) -> !transform.any_op",
        "    %r1 = wave.transform.regalloc_linear_scan from %r0",
        "        : (!transform.any_op) -> !transform.any_op",
        "    %r2 = wave.transform.regalloc_agpr_relief from %r1",
        "        : (!transform.any_op) -> !transform.any_op",
        "    %r3 = wave.transform.regalloc_remat_relief from %r2",
        "        : (!transform.any_op) -> !transform.any_op",
        "    transform.yield",
        "  }",
        (
            "  module @payload_module attributes "
            '{waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {'
        ),
        "    func.func @large_shared_leaf_bundle()",
        f"        -> ({returns})",
        "        attributes {waveamdmachine.vgpr_count_max = 41 : i64,",
        "                    waveamdmachine.agpr_count_max = 0 : i64} {",
        "      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
        "      %one = waveamdmachine.imm 1 : !waveamdmachine.imm",
        "      %leaf0 = waveamdmachine.v_workitem_id_x",
        f"          : {REG}",
        "      %root0 = waveamdmachine.v_xor_b32 %leaf0, %one",
        f"          : ({REG}, !waveamdmachine.imm) -> {REG}",
    ]
    for i in range(1, 39):
        lines.extend(
            [
                f"      %leaf{i} = waveamdmachine.v_workitem_id_x",
                f"          : {REG}",
                f"      %root{i} = waveamdmachine.v_xor_b32 %leaf{i - 1}, %leaf{i}",
                f"          : ({REG}, {REG}) -> {REG}",
            ]
        )
    lines.extend(
        [
            "      %root39 = waveamdmachine.v_xor_b32 %leaf38, %one",
            f"          : ({REG}, !waveamdmachine.imm) -> {REG}",
            "      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one",
            "          : (!waveamdmachine.imm, !waveamdmachine.imm)",
            "            -> !waveamdmachine.reg<scc, 1>",
            (
                "      waveamdmachine.uniform_loop if %cond "
                ": !waveamdmachine.reg<scc, 1> {"
            ),
            "        %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}",
            f"            : {REG}",
            "        %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}",
            f"            : {REG}",
            "        %sum = waveamdmachine.v_add_u32 %a, %b",
            f"            : ({REG}, {REG}) -> {REG}",
            "        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>",
            "      }",
            f"      return {values} : {types}",
            "    }",
            "  }",
            "}",
        ]
    )
    return "\n".join(lines) + "\n"


def main() -> None:
    start = time.perf_counter()
    proc = subprocess.run(
        [
            sys.argv[1],
            "-",
            "--pass-pipeline=builtin.module(transform-interpreter{entry-point=remat_relief})",
        ],
        input=build_source(),
        text=True,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        print(proc.stderr, file=sys.stderr)
        raise SystemExit(proc.returncode)
    metadata = 'name = "wave.regalloc.remat.dwords", value = 40 : i64'
    if metadata not in proc.stdout:
        raise SystemExit("40-root remat bundle was not selected")
    if "waveamdmachine.regalloc_transform_state" in proc.stdout:
        raise SystemExit("remat state survived 40-root bundle materialization")
    if proc.stdout.count("waveamdmachine.v_xor_b32") != 40:
        raise SystemExit("40-root remat bundle rebuilt the wrong DAG")
    elapsed = time.perf_counter() - start
    print(f"large shared-leaf bundle: 40 roots ({elapsed:.3f}s)")


if __name__ == "__main__":
    main()
