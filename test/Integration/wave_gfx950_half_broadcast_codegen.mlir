// RUN: wave-opt %s --waveamd-cross-lane-peepholes | FileCheck %s --check-prefix=IR
// RUN: wave-translate %s --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// IR-LABEL: func.func @lower_first
// IR-NOT: waveamdmachine.ds_bpermute_b32
// IR: waveamdmachine.v_permlane32_swap_b32_tuple
// IR-NOT: waveamdmachine.ds_bpermute_b32
// ASM-LABEL: lower_first:
// ASM-NOT: ds_bpermute
// ASM: v_permlane32_swap_b32
// ASM-NOT: ds_bpermute
func.func @lower_first(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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

// IR-LABEL: func.func @upper_first
// IR-NOT: waveamdmachine.ds_bpermute_b32
// IR: waveamdmachine.v_permlane32_swap_b32_tuple
// IR-NOT: waveamdmachine.ds_bpermute_b32
// ASM-LABEL: upper_first:
// ASM-NOT: ds_bpermute
// ASM: v_permlane32_swap_b32
// ASM-NOT: ds_bpermute
func.func @upper_first(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// IR-LABEL: func.func @active_lower
// IR-NOT: waveamdmachine.v_permlane32_swap
// IR-COUNT-2: waveamdmachine.ds_bpermute_b32
// IR-NOT: waveamdmachine.v_permlane32_swap
// ASM-LABEL: active_lower:
// ASM-NOT: v_permlane32_swap
// ASM-COUNT-2: ds_bpermute_b32
// ASM-NOT: v_permlane32_swap
func.func @active_lower(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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
  %saved, %scc = waveamdmachine.s_and_saveexec_b64 %mask : (!waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// IR-LABEL: func.func @active_upper
// IR-NOT: waveamdmachine.v_permlane32_swap
// IR-COUNT-2: waveamdmachine.ds_bpermute_b32
// IR-NOT: waveamdmachine.v_permlane32_swap
// ASM-LABEL: active_upper:
// ASM-NOT: v_permlane32_swap
// ASM-COUNT-2: ds_bpermute_b32
// ASM-NOT: v_permlane32_swap
func.func @active_upper(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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
  %mask = waveamdmachine.s_mov_b64_imm -4294967296 : !waveamdmachine.reg<sgpr, 2>
  %saved, %scc = waveamdmachine.s_and_saveexec_b64 %mask : (!waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// IR-LABEL: func.func @active_sparse
// IR-NOT: waveamdmachine.v_permlane32_swap
// IR-COUNT-2: waveamdmachine.ds_bpermute_b32
// IR-NOT: waveamdmachine.v_permlane32_swap
// ASM-LABEL: active_sparse:
// ASM-NOT: v_permlane32_swap
// ASM-COUNT-2: ds_bpermute_b32
// ASM-NOT: v_permlane32_swap
func.func @active_sparse(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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
  %mask = waveamdmachine.s_mov_b64_imm 6148914692668172970 : !waveamdmachine.reg<sgpr, 2>
  %saved, %scc = waveamdmachine.s_and_saveexec_b64 %mask : (!waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// IR-LABEL: func.func @changed_exec
// IR-NOT: waveamdmachine.v_permlane32_swap
// IR-COUNT-2: waveamdmachine.ds_bpermute_b32
// IR-NOT: waveamdmachine.v_permlane32_swap
// ASM-LABEL: changed_exec:
// ASM-NOT: v_permlane32_swap
// ASM-COUNT-2: ds_bpermute_b32
// ASM-NOT: v_permlane32_swap
func.func @changed_exec(%dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
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
  %hi_value = waveamdmachine.ds_bpermute_b32 %hi_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.s_mov_b64_imm 4294967295 : !waveamdmachine.reg<sgpr, 2>
  %saved, %scc = waveamdmachine.s_and_saveexec_b64 %mask : (!waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %lo_value = waveamdmachine.ds_bpermute_b32 %lo_addr, %data : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %stored_lo = waveamdmachine.global_store_b32 %item_addr, %lo_value, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %stored_hi = waveamdmachine.global_store_b32 %item_addr, %hi_value, %base after %stored_lo offset 1024 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %stored_hi : !waveamdmachine.mem.token
  return
}

// IR-LABEL: func.func @redistribute_broadcast_pair
// ASM-LABEL: redistribute_broadcast_pair:
// ASM-NOT: ds_bpermute
// ASM: v_permlane32_swap_b32
// ASM-NOT: ds_bpermute
// ASM: buffer_store_dwordx2
func.func @redistribute_broadcast_pair(%dst: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>, wave.waves_per_workgroup = 4 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %salt = wave.constant 324508639 : i32 -> !wave.simd<i32, 64>
  %seventeen = wave.constant 17 : i32 -> !wave.simd<i32, 64>
  %bits = wave.binary xori %item, %salt : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %data = wave.binary addi %bits, %seventeen : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %pair = wave.redistribute %data,
      <blocks = 1, items = 256, source_block = "block",
       source_item = "64*floor(item/64) + Mod(item, 32) + 32*slot", source_slot = "0">
      : !wave.simd<i32, 64> -> !wave.simd<vector<2xi32>, 64>
  %offset = wave.index_expr <"2*x"> ["x"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %dst, %offset : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %done = wave.store %pair -> %ptr : (!wave.simd<vector<2xi32>, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return %done : !wave.mem.token
}
}
