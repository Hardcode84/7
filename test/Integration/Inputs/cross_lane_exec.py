# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Initialized cross-lane kernels and independent lane reference."""

import argparse
from itertools import product

import numpy as np

FULL = (1 << 64) - 1
MASKS = {
    "full": FULL,
    "lower": (1 << 32) - 1,
    "upper": FULL << 32 & FULL,
    "sparse": 0x55555555AAAAAAAA,
}
SCENARIOS = (
    *MASKS,
    "between",
    "consumer",
    "region",
    "nested",
    "restored",
    "after_exec",
    "loop_exec",
    "loop_partial",
)
CASES = (
    *product(("direct", "pair", "broadcast", "broadcast_pair", "select"), SCENARIOS),
    ("select", "split_exec"),
    ("select", "split_region"),
)


def binary(name, opcode, lhs, rhs, rhs_type="!v"):
    return (
        f"  %{name} = waveamdmachine.{opcode} %{lhs}, %{rhs} "
        f": (!v, {rhs_type}) -> !v\n"
    )


def mask_exec():
    return """  %saved, %masked_scc = waveamdmachine.s_and_saveexec_b64 %mask
      : (!s) -> (!s, !c)
"""


def select(name, half):
    return (
        f"  %{name} = waveamdmachine.v_cndmask_b32_tuple %a_{half}, "
        f"%b_{half}, %condition : (!v, !v, !s) -> !v\n"
    )


def barrier_region():
    return (
        """  waveamdmachine.uniform_if %uniform {
"""
        + mask_exec()
        + """    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !c
"""
    )


def prelude(kind, scenario):
    mask = MASKS.get(scenario, MASKS["lower"])
    if mask >= 1 << 63:
        mask -= 1 << 64
    code = f"""func.func @{kind}_{scenario}(%dst: !wave.ptr<#wave.global, i32>)
    attributes {{wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64}} {{
  %base = waveamdmachine.arg {{index = 0 : i64, pointer = true}} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %mask = waveamdmachine.s_mov_b64_imm {mask} : !s
"""
    for value in (0, 1, 2, 5, 31, 32, 63, 1065353216, 1073741824):
        code += f"  %c{value} = waveamdmachine.imm {value} : !i\n"
    for name, opcode, lhs, rhs in (
        ("a", "v_add_u32", "item", "c1065353216"),
        ("b", "v_add_u32", "item", "c1073741824"),
        ("lane", "v_and_b32", "item", "c63"),
        ("lo", "v_and_b32", "lane", "c31"),
        ("hi", "v_add_u32", "lo", "c32"),
        ("other", "v_xor_b32", "lane", "c32"),
        ("half", "v_lshrrev_b32", "lane", "c5"),
    ):
        code += binary(name, opcode, lhs, rhs, "!i")
    for name in ("item", "lane", "lo", "hi", "other"):
        code += binary(f"{name}_addr", "v_lshlrev_b32", name, "c2", "!i")
    code += """  %one = waveamdmachine.s_mov_b32_value %c1 : (!i) -> !s1
  %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one : (!v, !s1) -> !cc
  %condition = waveamdmachine.s_read_vcc_b64 %vcc : (!cc) -> !s
  %uniform = waveamdmachine.s_cmp_eq_u32 %c0, %c0 : (!i, !i) -> !c
"""
    return code


def producers(kind):
    if kind == "direct":
        return "", binary("second", "ds_bpermute_b32", "other_addr", "a")
    if kind in ("pair", "broadcast", "broadcast_pair"):
        first, second = ("lane", "other") if kind == "pair" else ("lo", "hi")
        names = (
            ("result0", "result1") if kind == "broadcast_pair" else ("first", "second")
        )
        return (
            binary(names[0], "ds_bpermute_b32", f"{first}_addr", "a"),
            binary(names[1], "ds_bpermute_b32", f"{second}_addr", "a"),
        )
    halves = []
    for half in ("lo", "hi"):
        halves.append(
            "".join(
                binary(f"{data}_{half}", "ds_bpermute_b32", f"{half}_addr", data)
                for data in ("a", "b")
            )
        )
    return tuple(halves)


def consumers(kind):
    if kind == "broadcast_pair":
        return ""
    if kind == "select":
        return select("result0", "lo") + select("result1", "hi")
    first = "a" if kind == "direct" else "first"
    return binary("result0", "v_add_f32", first, "second") + binary(
        "result1", "v_max_f32", first, "second"
    )


def stores():
    return """  %stored0 = waveamdmachine.global_store_b32 %item_addr, %result0, %base
      : (!v, !v, !s) -> !t
  %stored1 = waveamdmachine.global_store_b32 %item_addr, %result1, %base
      after %stored0 offset 1024 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %stored1 : !t
"""


def exec_region():
    return """  waveamdmachine.exec_if %mask {
    waveamdmachine.v_nop
    waveamdmachine.yield
  } : !s
"""


def loop_body(kind, scenario):
    first, second = producers(kind)
    code = """  %zero = waveamdmachine.s_mov_b32_value %c0 : (!i) -> !s1
  %results:3 = waveamdmachine.uniform_loop carries(%zero, %a, %a : !s1, !v, !v) {
  ^bb0(%iv: !s1, %carry0: !v, %carry1: !v):
"""
    if scenario == "loop_exec":
        code += exec_region()
    code += first + second + consumers(kind)
    if scenario == "loop_partial":
        code += "  waveamdmachine.s_mov_exec_b64 %mask : (!s) -> ()\n"
    code += """    %next, %scc = waveamdmachine.s_add_i32 %iv, %c1
        : (!s1, !i) -> (!s1, !c)
    %again = waveamdmachine.s_cmp_lt_i32 %next, %c2 : (!s1, !i) -> !c
    waveamdmachine.continue_if %again : !c
        carries(%next, %result0, %result1 : !s1, !v, !v)
  } -> !s1, !v, !v
"""
    return code + stores().replace("%result0", "%results#1").replace(
        "%result1", "%results#2"
    )


def kernel(kind, scenario):
    code = prelude(kind, scenario)
    first, second = producers(kind)
    if scenario == "after_exec":
        code += exec_region()
    if scenario in ("loop_exec", "loop_partial"):
        return code + loop_body(kind, scenario) + "  return\n}\n"
    if scenario in (*MASKS, "restored") and scenario != "full":
        code += mask_exec()
    code += first
    if scenario.startswith("split_"):
        code += select("result0", "lo")
    if scenario in ("between", "split_exec"):
        code += mask_exec()
    if scenario in ("region", "split_region"):
        code += barrier_region()
    code += second
    return code + consume_and_store(kind, scenario) + "  return\n}\n"


def consume_and_store(kind, scenario):
    code = ""
    if scenario == "consumer":
        code += mask_exec()
    if scenario == "restored":
        code += "  waveamdmachine.s_mov_exec_b64 %saved : (!s) -> ()\n"
    if scenario == "nested":
        code += "  waveamdmachine.uniform_if %uniform {\n" + mask_exec()
        code += consumers(kind) + stores()
        code += """    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !c
"""
    elif scenario.startswith("split_"):
        code += select("result1", "hi") + stores()
    else:
        code += consumers(kind)
        if scenario == "restored":
            code += "  waveamdmachine.s_mov_exec_b64 %mask : (!s) -> ()\n"
        code += stores()
    return code


def emit_mlir():
    print("""!v = !waveamdmachine.reg<vgpr, 1>
!s = !waveamdmachine.reg<sgpr, 2>
!s1 = !waveamdmachine.reg<sgpr, 1>
!c = !waveamdmachine.reg<scc, 1>
!cc = !waveamdmachine.reg<vcc, 1>
!i = !waveamdmachine.imm
!t = !waveamdmachine.mem.token
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {""")
    for kind, scenario in CASES:
        print(f"// CHECK-LABEL: func.func @{kind}_{scenario}(")
        if scenario in ("full", "after_exec", "loop_exec"):
            print("// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple")
        elif kind in ("select", "broadcast", "broadcast_pair") and scenario in (
            "consumer",
            "nested",
        ):
            opcode = {
                "select": "v_cndmask_b32_tuple",
                "broadcast": "v_add_f32",
                "broadcast_pair": "v_permlane32_swap_b32_tuple",
            }[kind]
            print(f"// CHECK: waveamdmachine.{opcode}")
        else:
            print("// CHECK-NOT: waveamdmachine.v_permlane32_swap")
            print("// CHECK: waveamdmachine.ds_bpermute_b32")
            print("// CHECK-NOT: waveamdmachine.v_permlane32_swap")
        print("// CHECK: return")
        print(kernel(kind, scenario))
    print("}")


def reference_lane(kind, item, lane, a, b, first_mask, second_mask):
    def read(data, source, mask):
        return data[item - lane + source] if mask >> source & 1 else 0

    if kind in ("select", "broadcast_pair"):
        data = b if kind == "select" and lane >= 32 else a
        return (
            read(data, lane % 32, first_mask),
            read(data, lane % 32 + 32, second_mask),
        )
    first, second = (
        (lane % 32, lane % 32 + 32) if kind == "broadcast" else (lane, lane ^ 32)
    )
    lhs = read(a, first, first_mask)
    rhs = read(a, second, second_mask)
    return lhs + rhs, max(lhs, rhs)


def expected_output(kind, scenario):
    mask = (
        FULL
        if scenario in ("after_exec", "loop_exec")
        else MASKS.get(scenario, MASKS["lower"])
    )
    first_mask = mask if scenario in (*MASKS, "restored", "loop_partial") else FULL
    second_mask = FULL if scenario in ("consumer", "nested") else mask
    values = np.arange(256, dtype=np.uint32)
    a = (values + 0x3F800000).view(np.float32)
    b = (values + 0x40000000).view(np.float32)
    output = np.full((2, 256), -1, dtype=np.int32)
    floats = output.view(np.float32)
    for item in range(256):
        lane = item % 64
        if not (mask >> lane & 1):
            continue
        floats[:, item] = reference_lane(
            kind, item, lane, a, b, first_mask, second_mask
        )
    return output.flatten()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit-mlir", action="store_true", required=True)
    parser.parse_args()
    emit_mlir()
