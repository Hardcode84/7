// RUN: wave-opt %s --waveamd-cross-lane-peepholes | FileCheck %s
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

!v = !waveamdmachine.reg<vgpr, 1>
!s = !waveamdmachine.reg<sgpr, 2>
!s1 = !waveamdmachine.reg<sgpr, 1>
!c = !waveamdmachine.reg<scc, 1>
!cc = !waveamdmachine.reg<vcc, 1>
!i = !waveamdmachine.imm
!t = !waveamdmachine.mem.token
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK-LABEL: func.func @broadcast_order_index(
// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: [[THIRD:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#0,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#1,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[THIRD]],
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @broadcast_order_index(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %c2 = waveamdmachine.imm 2 : !i
  %c31 = waveamdmachine.imm 31 : !i
  %c32 = waveamdmachine.imm 32 : !i
  %c63 = waveamdmachine.imm 63 : !i
  %c1065353216 = waveamdmachine.imm 1065353216 : !i
  %a = waveamdmachine.v_add_u32 %item, %c1065353216 : (!v, !i) -> !v
  %lane = waveamdmachine.v_and_b32 %item, %c63 : (!v, !i) -> !v
  %lo = waveamdmachine.v_and_b32 %lane, %c31 : (!v, !i) -> !v
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!v, !i) -> !v
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!v, !i) -> !v
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!v, !i) -> !v
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!v, !i) -> !v
  %first = waveamdmachine.ds_bpermute_b32 %lo_addr, %a : (!v, !v) -> !v
  %second = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %third = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %store0 = waveamdmachine.global_store_b32 %item_addr, %first, %base : (!v, !v, !s) -> !t
  %store1 = waveamdmachine.global_store_b32 %item_addr, %second, %base after %store0 offset 1024 : (!v, !v, !s, !t) -> !t
  %store2 = waveamdmachine.global_store_b32 %item_addr, %third, %base after %store1 offset 2048 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %store2 : !t
  return
}
// CHECK-LABEL: func.func @broadcast_barrier_index(
// CHECK: [[FIRST:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NEXT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: [[LAST:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[FIRST]],
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#0,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#1,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[LAST]],
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @broadcast_barrier_index(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %c2 = waveamdmachine.imm 2 : !i
  %c31 = waveamdmachine.imm 31 : !i
  %c32 = waveamdmachine.imm 32 : !i
  %c63 = waveamdmachine.imm 63 : !i
  %c1065353216 = waveamdmachine.imm 1065353216 : !i
  %c1073741824 = waveamdmachine.imm 1073741824 : !i
  %a = waveamdmachine.v_add_u32 %item, %c1065353216 : (!v, !i) -> !v
  %b = waveamdmachine.v_add_u32 %item, %c1073741824 : (!v, !i) -> !v
  %lane = waveamdmachine.v_and_b32 %item, %c63 : (!v, !i) -> !v
  %lo = waveamdmachine.v_and_b32 %lane, %c31 : (!v, !i) -> !v
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!v, !i) -> !v
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!v, !i) -> !v
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!v, !i) -> !v
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!v, !i) -> !v
  %first = waveamdmachine.ds_bpermute_b32 %lo_addr, %a : (!v, !v) -> !v
  %inner0 = waveamdmachine.ds_bpermute_b32 %lo_addr, %b : (!v, !v) -> !v
  %inner1 = waveamdmachine.ds_bpermute_b32 %hi_addr, %b : (!v, !v) -> !v
  %last = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %store0 = waveamdmachine.global_store_b32 %item_addr, %first, %base : (!v, !v, !s) -> !t
  %store1 = waveamdmachine.global_store_b32 %item_addr, %inner0, %base after %store0 offset 1024 : (!v, !v, !s, !t) -> !t
  %store2 = waveamdmachine.global_store_b32 %item_addr, %inner1, %base after %store1 offset 2048 : (!v, !v, !s, !t) -> !t
  %store3 = waveamdmachine.global_store_b32 %item_addr, %last, %base after %store2 offset 3072 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %store3 : !t
  return
}
// CHECK-LABEL: func.func @select_order_index(
// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NEXT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: [[THIRD:%.*]] = waveamdmachine.v_cndmask_b32_tuple
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#0,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#1,
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[THIRD]],
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @select_order_index(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %c1 = waveamdmachine.imm 1 : !i
  %c2 = waveamdmachine.imm 2 : !i
  %c5 = waveamdmachine.imm 5 : !i
  %c31 = waveamdmachine.imm 31 : !i
  %c32 = waveamdmachine.imm 32 : !i
  %c63 = waveamdmachine.imm 63 : !i
  %c1065353216 = waveamdmachine.imm 1065353216 : !i
  %c1073741824 = waveamdmachine.imm 1073741824 : !i
  %a = waveamdmachine.v_add_u32 %item, %c1065353216 : (!v, !i) -> !v
  %b = waveamdmachine.v_add_u32 %item, %c1073741824 : (!v, !i) -> !v
  %lane = waveamdmachine.v_and_b32 %item, %c63 : (!v, !i) -> !v
  %lo = waveamdmachine.v_and_b32 %lane, %c31 : (!v, !i) -> !v
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!v, !i) -> !v
  %half = waveamdmachine.v_lshrrev_b32 %lane, %c5 : (!v, !i) -> !v
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!v, !i) -> !v
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!v, !i) -> !v
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!v, !i) -> !v
  %one = waveamdmachine.s_mov_b32_value %c1 : (!i) -> !s1
  %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one : (!v, !s1) -> !cc
  %condition = waveamdmachine.s_read_vcc_b64 %vcc : (!cc) -> !s
  %a_lo = waveamdmachine.ds_bpermute_b32 %lo_addr, %a : (!v, !v) -> !v
  %b_lo = waveamdmachine.ds_bpermute_b32 %lo_addr, %b : (!v, !v) -> !v
  %a_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %b_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %b : (!v, !v) -> !v
  %first = waveamdmachine.v_cndmask_b32_tuple %a_lo, %b_lo, %condition : (!v, !v, !s) -> !v
  %second = waveamdmachine.v_cndmask_b32_tuple %a_hi, %b_hi, %condition : (!v, !v, !s) -> !v
  %third = waveamdmachine.v_cndmask_b32_tuple %a_hi, %b_hi, %condition : (!v, !v, !s) -> !v
  %store0 = waveamdmachine.global_store_b32 %item_addr, %first, %base : (!v, !v, !s) -> !t
  %store1 = waveamdmachine.global_store_b32 %item_addr, %second, %base after %store0 offset 1024 : (!v, !v, !s, !t) -> !t
  %store2 = waveamdmachine.global_store_b32 %item_addr, %third, %base after %store1 offset 2048 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %store2 : !t
  return
}
// CHECK-LABEL: func.func @select_barrier_index(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_cndmask_b32_tuple
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NEXT: waveamdmachine.tuple_to_elements
// CHECK-NEXT: [[SUM:%.*]] = waveamdmachine.v_add_f32
// CHECK-NEXT: waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: [[LAST:%.*]] = waveamdmachine.v_cndmask_b32_tuple
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[FIRST]],
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SUM]],
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[LAST]],
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @select_barrier_index(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %c1 = waveamdmachine.imm 1 : !i
  %c2 = waveamdmachine.imm 2 : !i
  %c5 = waveamdmachine.imm 5 : !i
  %c31 = waveamdmachine.imm 31 : !i
  %c32 = waveamdmachine.imm 32 : !i
  %c63 = waveamdmachine.imm 63 : !i
  %c1065353216 = waveamdmachine.imm 1065353216 : !i
  %c1073741824 = waveamdmachine.imm 1073741824 : !i
  %a = waveamdmachine.v_add_u32 %item, %c1065353216 : (!v, !i) -> !v
  %b = waveamdmachine.v_add_u32 %item, %c1073741824 : (!v, !i) -> !v
  %lane = waveamdmachine.v_and_b32 %item, %c63 : (!v, !i) -> !v
  %lo = waveamdmachine.v_and_b32 %lane, %c31 : (!v, !i) -> !v
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!v, !i) -> !v
  %other = waveamdmachine.v_xor_b32 %lane, %c32 : (!v, !i) -> !v
  %half = waveamdmachine.v_lshrrev_b32 %lane, %c5 : (!v, !i) -> !v
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!v, !i) -> !v
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!v, !i) -> !v
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!v, !i) -> !v
  %other_addr = waveamdmachine.v_lshlrev_b32 %other, %c2 : (!v, !i) -> !v
  %one = waveamdmachine.s_mov_b32_value %c1 : (!i) -> !s1
  %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one : (!v, !s1) -> !cc
  %condition = waveamdmachine.s_read_vcc_b64 %vcc : (!cc) -> !s
  %a_lo = waveamdmachine.ds_bpermute_b32 %lo_addr, %a : (!v, !v) -> !v
  %b_lo = waveamdmachine.ds_bpermute_b32 %lo_addr, %b : (!v, !v) -> !v
  %first = waveamdmachine.v_cndmask_b32_tuple %a_lo, %b_lo, %condition : (!v, !v, !s) -> !v
  %peer = waveamdmachine.ds_bpermute_b32 %other_addr, %a : (!v, !v) -> !v
  %sum = waveamdmachine.v_add_f32 %a, %peer : (!v, !v) -> !v
  %a_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %b_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %b : (!v, !v) -> !v
  %last = waveamdmachine.v_cndmask_b32_tuple %a_hi, %b_hi, %condition : (!v, !v, !s) -> !v
  %store0 = waveamdmachine.global_store_b32 %item_addr, %first, %base : (!v, !v, !s) -> !t
  %store1 = waveamdmachine.global_store_b32 %item_addr, %sum, %base after %store0 offset 1024 : (!v, !v, !s, !t) -> !t
  %store2 = waveamdmachine.global_store_b32 %item_addr, %last, %base after %store1 offset 2048 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %store2 : !t
  return
}
// CHECK-LABEL: func.func @payload_loss_index(
// CHECK: [[HI:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NEXT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: [[FIRST:%.*]] = waveamdmachine.v_cndmask_b32_tuple [[HI]], [[SPLIT]]#1,
// CHECK-NEXT: [[SECOND:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[FIRST]],
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SECOND]],
// CHECK-NEXT: waveamdmachine.global_store_b32 {{%.*}}, [[SPLIT]]#0,
// CHECK-NEXT: waveamdmachine.s_endpgm
// CHECK-NEXT: return
func.func @payload_loss_index(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !s
  %item = waveamdmachine.v_workitem_id_x : !v
  %c1 = waveamdmachine.imm 1 : !i
  %c2 = waveamdmachine.imm 2 : !i
  %c5 = waveamdmachine.imm 5 : !i
  %c31 = waveamdmachine.imm 31 : !i
  %c32 = waveamdmachine.imm 32 : !i
  %c63 = waveamdmachine.imm 63 : !i
  %c1065353216 = waveamdmachine.imm 1065353216 : !i
  %c1073741824 = waveamdmachine.imm 1073741824 : !i
  %a = waveamdmachine.v_add_u32 %item, %c1065353216 : (!v, !i) -> !v
  %b = waveamdmachine.v_add_u32 %item, %c1073741824 : (!v, !i) -> !v
  %lane = waveamdmachine.v_and_b32 %item, %c63 : (!v, !i) -> !v
  %lo = waveamdmachine.v_and_b32 %lane, %c31 : (!v, !i) -> !v
  %hi = waveamdmachine.v_add_u32 %lo, %c32 : (!v, !i) -> !v
  %half = waveamdmachine.v_lshrrev_b32 %lane, %c5 : (!v, !i) -> !v
  %item_addr = waveamdmachine.v_lshlrev_b32 %item, %c2 : (!v, !i) -> !v
  %lo_addr = waveamdmachine.v_lshlrev_b32 %lo, %c2 : (!v, !i) -> !v
  %hi_addr = waveamdmachine.v_lshlrev_b32 %hi, %c2 : (!v, !i) -> !v
  %one = waveamdmachine.s_mov_b32_value %c1 : (!i) -> !s1
  %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one : (!v, !s1) -> !cc
  %condition = waveamdmachine.s_read_vcc_b64 %vcc : (!cc) -> !s
  %a_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %a : (!v, !v) -> !v
  %b_hi = waveamdmachine.ds_bpermute_b32 %hi_addr, %b : (!v, !v) -> !v
  %first = waveamdmachine.v_cndmask_b32_tuple %a_hi, %b_hi, %condition : (!v, !v, !s) -> !v
  %second = waveamdmachine.ds_bpermute_b32 %lo_addr, %a : (!v, !v) -> !v
  %third = waveamdmachine.ds_bpermute_b32 %lo_addr, %b : (!v, !v) -> !v
  %store0 = waveamdmachine.global_store_b32 %item_addr, %first, %base : (!v, !v, !s) -> !t
  %store1 = waveamdmachine.global_store_b32 %item_addr, %second, %base after %store0 offset 1024 : (!v, !v, !s, !t) -> !t
  %store2 = waveamdmachine.global_store_b32 %item_addr, %third, %base after %store1 offset 2048 : (!v, !v, !s, !t) -> !t
  waveamdmachine.s_endpgm after %store2 : !t
  return
}
}
