# RUN: %python %s %wave_pipelines wave-opt wave-translate llvm-mc | FileCheck %s

# CHECK: resource sgpr_count = 102
# CHECK: s_and_saveexec_b64 s[100:101],
# CHECK: exec_if_sgpr_budget: ok

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


def build_source() -> str:
    returns = ", ".join(["!waveamdmachine.reg<sgpr, 2>" for _ in range(50)])
    values = ", ".join([f"%s{i}" for i in range(50)])
    types = ", ".join(["!waveamdmachine.reg<sgpr, 2>" for _ in range(50)])
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        "  func.func @exec_if_save_stack_sgpr_budget_results()",
        f"      -> ({returns}) {{",
        "    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
        "    %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>",
    ]
    for i in range(50):
        lines.append(
            f"    %s{i} = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>"
        )
    lines.extend(
        [
            "    waveamdmachine.exec_if %cond {",
            "      waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()",
            "      waveamdmachine.yield",
            "    } : !waveamdmachine.reg<sgpr, 2>",
            f"    return {values} : {types}",
            "  }",
            "  func.func @exec_if_condition_liveness() attributes {wave.kernel} {",
            "    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
            "    %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>",
            "    %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>",
            "    waveamdmachine.exec_if %cond {",
            "      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>",
            "      %value, %token = waveamdmachine.buffer_load_b32 %off, %desc, %zero",
            "          : (!waveamdmachine.reg<vgpr, 1>,",
            "             !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)",
            "            -> (!waveamdmachine.reg<vgpr, 1>,",
            "                !waveamdmachine.mem.token)",
            "      waveamdmachine.yield",
            "    } otherwise {",
            "      waveamdmachine.yield",
            "    } : !waveamdmachine.reg<sgpr, 2>",
            "    return",
            "  }",
            "  func.func @exec_if_result_liveness() -> (",
            "      !waveamdmachine.reg<vgpr, 1>,",
            "      !waveamdmachine.reg<vgpr, 1>) {",
            "    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
            "    %one = waveamdmachine.imm 1 : !waveamdmachine.imm",
            "    %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>",
            "    %fallback = waveamdmachine.v_mov_b32_tuple %zero",
            "        {registers = 1 : i64} : (!waveamdmachine.imm)",
            "        -> !waveamdmachine.reg<vgpr, 1>",
            "    %r0 = waveamdmachine.exec_if %cond {",
            "      %then0 = waveamdmachine.v_mov_b32_tuple %one",
            "          {registers = 1 : i64} : (!waveamdmachine.imm)",
            "          -> !waveamdmachine.reg<vgpr, 1>",
            "      waveamdmachine.yield %then0 : !waveamdmachine.reg<vgpr, 1>",
            "    } otherwise {",
            "      waveamdmachine.yield %fallback : !waveamdmachine.reg<vgpr, 1>",
            "    } : !waveamdmachine.reg<sgpr, 2>",
            "        -> !waveamdmachine.reg<vgpr, 1>",
            "    %r1 = waveamdmachine.exec_if %cond {",
            "      %then1 = waveamdmachine.v_mov_b32_tuple %one",
            "          {registers = 1 : i64} : (!waveamdmachine.imm)",
            "          -> !waveamdmachine.reg<vgpr, 1>",
            "      waveamdmachine.yield %then1 : !waveamdmachine.reg<vgpr, 1>",
            "    } otherwise {",
            "      waveamdmachine.yield %fallback : !waveamdmachine.reg<vgpr, 1>",
            "    } : !waveamdmachine.reg<sgpr, 2>",
            "        -> !waveamdmachine.reg<vgpr, 1>",
            "    return %r0, %r1 : !waveamdmachine.reg<vgpr, 1>,",
            "        !waveamdmachine.reg<vgpr, 1>",
            "  }",
            "}",
        ]
    )
    return "\n".join(lines) + "\n"


def run(cmd: list[str], stdin: str) -> str:
    proc = subprocess.run(
        cmd,
        input=stdin,
        text=True,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        print(proc.stderr, file=sys.stderr)
        raise SystemExit(proc.returncode)
    return proc.stdout


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(message)


def main() -> None:
    pipeline_path = Path(sys.argv[1])
    wave_opt = sys.argv[2]
    wave_translate = sys.argv[3]
    llvm_mc = sys.argv[4]
    pipeline = (
        "builtin.module("
        f"transform-preload-library{{transform-library-paths={pipeline_path}}},"
        "transform-interpreter{entry-point=waveamd_regalloc_transform_loop},"
        "waveamd-resource-info)"
    )
    mlir = run([wave_opt, "-", f"--pass-pipeline={pipeline}"], build_source())
    require(
        "waveamdmachine.sgpr_count = 102 : i64" in mlir,
        "resource-info did not reserve exec_if save stack inside gfx950 limit",
    )
    result_liveness = re.search(
        r"func\.func @exec_if_result_liveness\(\)\s*->\s*\("
        r"!waveamdmachine\.reg<vgpr, 1, (\d+)>,\s*"
        r"!waveamdmachine\.reg<vgpr, 1, (\d+)>",
        mlir,
    )
    require(result_liveness is not None, "missing allocated exec_if results")
    require(
        result_liveness.group(1) != result_liveness.group(2),
        "simultaneously live exec_if results share a physical VGPR",
    )

    asm = run([wave_translate, "--wave-to-amdgpu-asm", "-"], mlir)
    require("s[102:103]" not in asm, "exec_if save stack escaped gfx950 SGPRs")
    save_line = next(
        line.strip() for line in asm.splitlines() if "s_and_saveexec_b64" in line
    )
    require(
        "s[100:101]" in save_line,
        f"unexpected exec_if save register: {save_line}",
    )
    run(
        [
            llvm_mc,
            "-triple=amdgcn-amd-amdhsa",
            "-mcpu=gfx950",
            "-filetype=obj",
            "-o",
            "/dev/null",
        ],
        asm,
    )
    print("resource sgpr_count = 102")
    print(save_line)
    print("exec_if_sgpr_budget: ok")


if __name__ == "__main__":
    main()
