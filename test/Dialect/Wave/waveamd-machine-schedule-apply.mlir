// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 print-candidates=1' 2>&1 | FileCheck %s --check-prefixes=DIAG,APPLY
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-reg-alloc | FileCheck %s --check-prefix=PIPE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @candidate_lower(%off: !waveamdmachine.reg<vgpr, 1>,
                           %base: !waveamdmachine.reg<sgpr, 2>,
                           %a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %ind = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %dep = waveamdmachine.v_add_u32 %loaded, %ind : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// DIAG: waveamd-machine-schedule candidate func=candidate_lower region=0 name=original cycles=326 delta=0 issued_ops=3 order=0,1,2,3
// DIAG: waveamd-machine-schedule candidate func=candidate_lower region=0 name=critical_path cycles=325 delta=-1 issued_ops=3 order=0,2,1,3
// DIAG: waveamd-machine-schedule selected func=candidate_lower region=0 name=critical_path original_cycles=326 selected_cycles=325 delta=-1 action=apply order=0,2,1,3

// APPLY-LABEL: func.func @candidate_lower
// APPLY: [[TOK:%.*]] = waveamdmachine.token
// APPLY-NEXT: [[LOADED:%.*]], [[LOADTOK:%.*]] = waveamdmachine.global_load_b32
// APPLY-NEXT: [[IND:%.*]] = waveamdmachine.v_add_u32
// APPLY-NEXT: waveamdmachine.v_add_u32 [[LOADED]], [[IND]]

// PIPE-LABEL: func.func @candidate_lower
// PIPE: waveamdmachine.global_load_b32
// PIPE: waveamdmachine.s_waitcnt
// PIPE: return
