// RUN: wave-opt --waveamd-reg-alloc --split-input-file --verify-diagnostics %s
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true' --split-input-file %s 2>/dev/null | FileCheck %s --check-prefix=MARK

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @target_waves_class_limit(%base_arg: !wave.ptr<#wave.global>)
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 64 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 64>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 64 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 64>
  %tok0 = waveamdmachine.global_store_tuple_b32 %off, %a, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 64>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %tok1 = waveamdmachine.global_store_tuple_b32 %off, %b, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 64>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}

// MARK-LABEL: func.func @target_waves_class_limit
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @target_waves_total_vgpr_nonoverlap(%base_arg: !wave.ptr<#wave.global>)
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 64 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 64>
  %tok = waveamdmachine.global_store_tuple_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 64>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

}

// MARK-LABEL: func.func @target_waves_total_vgpr_nonoverlap
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @target_waves_total_vgpr_limit(%base_arg: !wave.ptr<#wave.global>)
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 64 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 64>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %acc
      : (!waveamdmachine.reg<agpr, 64>) -> !waveamdmachine.reg<vgpr, 64>
  %tok = waveamdmachine.global_store_tuple_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 64>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %tok1 = waveamdmachine.global_store_tuple_b32 %off, %read, %base after %tok
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 64>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}

// MARK-LABEL: func.func @target_waves_total_vgpr_limit
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @target_waves_fixed_high_agpr_footprint(%base_arg: !wave.ptr<#wave.global>)
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 127>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %acc
      : (!waveamdmachine.reg<agpr, 1, 127>) -> !waveamdmachine.reg<vgpr, 1>
  %tok = waveamdmachine.global_store_tuple_b32 %off, %read, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

}

// MARK-LABEL: func.func @target_waves_fixed_high_agpr_footprint
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc SGPR count exceeds register budget}}
func.func @target_waves_pinned_sgpr()
    attributes {wave.kernel, waveamdmachine.target_waves = 8 : i64} {
  %pinned = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 100>
  return
}

}

// MARK-LABEL: func.func @target_waves_pinned_sgpr
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx908"} {

// expected-error @below {{waveamd-reg-alloc AGPR count exceeds register budget}}
func.func @target_waves_pinned_agpr()
    attributes {wave.kernel, waveamdmachine.target_waves = 8 : i64} {
  %pinned = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 100>
  return
}

}

// MARK-LABEL: func.func @target_waves_pinned_agpr
// MARK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
