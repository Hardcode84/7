// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s \
// RUN:   | wave-opt --waveamd-insert-ticket-waits -split-input-file \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @disabled_by_default
// CHECK-NOT: waveamdmachine.s_set_sched_mode
// CHECK-NOT: waveamdmachine.s_wait_alu
func.func @disabled_by_default() attributes {wave.kernel} {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %value = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  waveamdmachine.global_store_b32 %x, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @partial_va
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK: [[OLD:%.*]] = waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(1)
// CHECK-NEXT: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.s_endpgm
// CHECK-NOT: waveamdmachine.s_set_sched_mode normal
func.func @partial_va() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  %new = waveamdmachine.v_exp_f32 %y
      : (!waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 301>
  waveamdmachine.global_store_b32 %x, %old, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @mixed_va_families_drain
// CHECK: [[EXP:%.*]] = waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0)
// CHECK-NEXT: waveamdmachine.global_store_b32
func.func @mixed_va_families_drain() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  %newer = waveamdmachine.v_add_u32 %y, %y
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 301>
  waveamdmachine.global_store_b32 %x, %old, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @expanded_valu_issue_count
// CHECK: [[OLD:%.*]], %{{.*}} = waveamdmachine.v_add_u64
// CHECK-NEXT: waveamdmachine.v_add_u64
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(2)
// CHECK-NEXT: waveamdmachine.global_store_b64
func.func @expanded_valu_issue_count() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 2>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 4>
  %offset = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 6>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old, %old_vcc = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 2, 2>)
        -> (!waveamdmachine.reg<vgpr, 2, 300>,
            !waveamdmachine.reg<vcc, 1>)
  %newer, %newer_vcc = waveamdmachine.v_add_u64 %a, %c
      : (!waveamdmachine.reg<vgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 2, 4>)
        -> (!waveamdmachine.reg<vgpr, 2, 302>,
            !waveamdmachine.reg<vcc, 1>)
  waveamdmachine.global_store_b64 %offset, %old, %base
      : (!waveamdmachine.reg<vgpr, 1, 6>,
         !waveamdmachine.reg<vgpr, 2, 300>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @valu_raw_is_hardware_managed
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK: [[EXP:%.*]] = waveamdmachine.v_exp_f32
// CHECK-NOT: waveamdmachine.s_wait_alu
// CHECK-NEXT: waveamdmachine.v_add_u32 [[EXP]]
func.func @valu_raw_is_hardware_managed() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %exp = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  %sum = waveamdmachine.v_add_u32 %exp, %x
      : (!waveamdmachine.reg<vgpr, 1, 300>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 301>
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @partial_prefetch_source
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK: waveamdmachine.tdm_prefetch
// CHECK-NEXT: waveamdmachine.tdm_prefetch
// CHECK-NEXT: waveamdmachine.s_wait_alu vm_vsrc(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NOT: tensorcnt
func.func @partial_prefetch_source() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 512>
  %newer = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 513>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.tdm_prefetch %base, %old after %root
      : (!waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.tdm_prefetch %base, %newer after %root
      : (!waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 1, 513>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %overwrite = waveamdmachine.v_add_u32 %x, %x
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 512>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @mixed_vm_families_drain
// CHECK: waveamdmachine.tdm_prefetch
// CHECK-NEXT: waveamdmachine.buffer_store_b32
// CHECK-NEXT: waveamdmachine.s_wait_alu vm_vsrc(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @mixed_vm_families_drain() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 512>
  %newer = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 513>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %prefetch = waveamdmachine.tdm_prefetch %base, %old after %root
      : (!waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.buffer_store_b32 %x, %newer, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 513>,
         !waveamdmachine.reg<sgpr, 4, 4>,
         !waveamdmachine.imm) -> ()
  %overwrite = waveamdmachine.v_add_u32 %x, %x
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 512>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @cfg_join_uses_oldest_position
// CHECK: waveamdmachine.tdm_prefetch
// CHECK: scf.if
// CHECK: waveamdmachine.tdm_prefetch
// CHECK: waveamdmachine.s_wait_alu vm_vsrc(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @cfg_join_uses_oldest_position(%condition: i1) attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 512>
  %newer = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 513>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.tdm_prefetch %base, %old after %root
      : (!waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  scf.if %condition {
    %second = waveamdmachine.tdm_prefetch %base, %newer after %root
        : (!waveamdmachine.reg<sgpr, 2, 0>,
           !waveamdmachine.reg<vgpr, 1, 513>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  }
  %overwrite = waveamdmachine.v_add_u32 %x, %x
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 512>
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @tdm_does_not_shift_vm_source
// CHECK: waveamdmachine.buffer_store_b32
// CHECK-NEXT: waveamdmachine.tdm_load
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_wait_alu vm_vsrc(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NOT: tensorcnt
func.func @tdm_does_not_shift_vm_source() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 768>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 0>
  %d0 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %d1 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 8, 8>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  waveamdmachine.buffer_store_b32 %x, %old, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 768>,
         !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.imm) -> ()
  %tensor = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4, 4>,
         !waveamdmachine.reg<sgpr, 8, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %overwrite = waveamdmachine.v_add_u32 %x, %x
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @synchronous_atomic_does_not_shift_vm_source
// CHECK: waveamdmachine.tdm_prefetch
// CHECK-NEXT: {{.*}} = waveamdmachine.global_atomic_add_acq_rel_u32
// CHECK-NEXT: waveamdmachine.s_wait_alu vm_vsrc(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @synchronous_atomic_does_not_shift_vm_source() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 512>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %offset = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %prefetch = waveamdmachine.tdm_prefetch %base, %old after %root
      : (!waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %atomic_old, %atomic = waveamdmachine.global_atomic_add_acq_rel_u32
      %offset, %value, %base after %root
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 3>,
            !waveamdmachine.mem.token)
  %overwrite = waveamdmachine.v_add_u32 %x, %x
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 512>
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

func.func private @callee()

// CHECK-LABEL: func.func @caller_protocol
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK: waveamdmachine.buffer_store_b32
// CHECK-NEXT: waveamdmachine.v_exp_f32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split storecnt(0)
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0) vm_vsrc(0)
// CHECK-NEXT: waveamdmachine.s_set_sched_mode normal
// CHECK-NEXT: call @callee()
// CHECK-NEXT: waveamdmachine.s_set_sched_mode expert2
func.func @caller_protocol() attributes {
    wave.kernel,
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %old = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 512>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.buffer_store_b32 %x, %old, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.imm) -> ()
  %value = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  func.call @callee() : () -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @callable_protocol
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(0) dscnt(0) kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0) vm_vsrc(0)
// CHECK: waveamdmachine.s_wait_alu va_vdst(0)
// CHECK-NEXT: waveamdmachine.s_set_sched_mode normal
// CHECK-NEXT: waveamdmachine.s_setpc_b64
func.func @callable_protocol() attributes {
    waveamdmachine.expert_scheduling_mode
  } {
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %value = waveamdmachine.v_exp_f32 %x
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 300>
  waveamdmachine.s_setpc_b64
  return
}

// CHECK-LABEL: func.func @callable_tdm_return
// CHECK: waveamdmachine.s_set_sched_mode expert2
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(0) dscnt(0) kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_wait_alu va_vdst(0) vm_vsrc(0)
// CHECK: waveamdmachine.tdm_load
// CHECK-NOT: tensorcnt
// CHECK-NEXT: waveamdmachine.s_set_sched_mode normal
// CHECK-NEXT: waveamdmachine.s_setpc_b64
func.func @callable_tdm_return() attributes {
    waveamdmachine.expert_scheduling_mode
  } {
  %d0 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 0>
  %d1 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 8, 8>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %tensor = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 8, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_setpc_b64
  return
}

}
