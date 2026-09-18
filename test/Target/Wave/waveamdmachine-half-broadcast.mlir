// RUN: wave-opt %s --split-input-file --waveamd-cross-lane-peepholes | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK-LABEL: func.func @unknown_entry
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @unknown_entry(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @later_wave_differs
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @later_wave_differs(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c63 = waveamdmachine.imm 95 : !waveamdmachine.imm
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c63 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @region_between
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @region_between(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_eq_i32 %c2, %c2 : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_if %cond {
    waveamdmachine.v_nop
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @label_between
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @label_between(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.label "join"
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @partial_workgroup
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @partial_workgroup(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 96, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @uniform_loop
// CHECK-NOT: waveamdmachine.ds_bpermute
// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NOT: waveamdmachine.ds_bpermute
func.func @uniform_loop(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lg_i32 %c2, %c2 : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:2 = waveamdmachine.uniform_loop carries(%data, %data : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry_lo: !waveamdmachine.reg<vgpr, 1>, %carry_hi: !waveamdmachine.reg<vgpr, 1>):
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%lo_value, %hi_value : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %results#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %results#1, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @masked_loop_backedge
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @masked_loop_backedge(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lg_i32 %c2, %c2 : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:2 = waveamdmachine.uniform_loop carries(%data, %data : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry_lo: !waveamdmachine.reg<vgpr, 1>, %carry_hi: !waveamdmachine.reg<vgpr, 1>):
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %mask = waveamdmachine.s_mov_b64_imm 4294967295 : !waveamdmachine.reg<sgpr, 2>
    waveamdmachine.s_mov_exec_b64 %mask : (!waveamdmachine.reg<sgpr, 2>) -> ()
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%lo_value, %hi_value : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %results#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %results#1, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @nested_exec_if
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @nested_exec_if(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.s_mov_b64_imm 4294967295 : !waveamdmachine.reg<sgpr, 2>
  %results:2 = waveamdmachine.exec_if %mask {
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %lo_value, %hi_value : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 2> -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %results#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %results#1, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

}

// -----
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
// CHECK-LABEL: func.func @unsupported_target
// CHECK-NOT: waveamdmachine.v_permlane32_swap
// CHECK-COUNT-2: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_permlane32_swap
func.func @unsupported_target(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %item = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %salt = waveamdmachine.imm 324508639 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %bits = waveamdmachine.v_xor_b32 %item, %salt : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_add_u32 %bits, %c17 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.v_and_b32 %item, %c31 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}
}
