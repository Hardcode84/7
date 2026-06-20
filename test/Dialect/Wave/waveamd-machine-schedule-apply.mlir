// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1' --waveamd-machine-schedule='apply-schedule=1' 2>&1 | FileCheck %s --check-prefixes=DIAG,NOBEAM,APPLY
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 beam-search=1' 2>&1 | FileCheck %s --check-prefix=BEAM
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 max-region-ops=3' 2>&1 | FileCheck %s --check-prefix=REGIONCAP
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 beam-search=1 max-beam-work=1000' 2>&1 | FileCheck %s --check-prefix=BEAMCAP
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-candidates=1' | FileCheck %s --check-prefix=NOAPPLY
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 max-region-ops=3' 2>&1 | FileCheck %s --check-prefixes=NOAPPLY,SCHEDREGIONCAP
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 beam-search=1 max-beam-work=1000' 2>&1 | FileCheck %s --check-prefix=SCHEDBEAMCAP
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' --waveamd-insert-ticket-waits --waveamd-reg-alloc --waveamd-insert-hazard-waits | FileCheck %s --check-prefix=PIPE

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

// DIAG: waveamd-machine-schedule-report candidate func=candidate_lower region=0 name=original cycles=86 delta=0 issued_ops=3 max_vgpr=3 max_sgpr=0 order=0,1,2,3
// DIAG: waveamd-machine-schedule-report candidate func=candidate_lower region=0 name=critical_path cycles=85 delta=-1 issued_ops=3 max_vgpr=3 max_sgpr=0 order=0,2,1,3
// NOBEAM-NOT: name=beam_0
// DIAG: waveamd-machine-schedule-report selected func=candidate_lower region=0 name=critical_path original_cycles=86 selected_cycles=85 delta=-1 action=keep order=0,2,1,3
// BEAM: waveamd-machine-schedule-report candidate func=candidate_lower region=0 name=beam_0 cycles=86 delta=0 issued_ops=3 max_vgpr=3 max_sgpr=0 order=1,0,2,3
// REGIONCAP: waveamd-machine-schedule-report skipped func=candidate_lower region=0 reason=max_region_ops ops=4 instruction_ops=3 limit=3
// BEAMCAP: waveamd-machine-schedule-report skipped func=candidate_lower region=0 reason=max_beam_work estimated_work=1536 limit=1000
// BEAMCAP-NOT: name=beam_0
// BEAMCAP: waveamd-machine-schedule-report selected func=candidate_lower region=0 name=critical_path
// SCHEDREGIONCAP: remark: skipped WaveAMDMachine scheduling region: reason=max_region_ops ops=4 instruction_ops=3 limit=3
// SCHEDBEAMCAP: remark: skipped WaveAMDMachine beam search: reason=max_beam_work estimated_work=1536 limit=1000

// APPLY-LABEL: func.func @candidate_lower
// APPLY: [[TOK:%.*]] = waveamdmachine.token
// APPLY-NEXT: [[LOADED:%.*]], [[LOADTOK:%.*]] = waveamdmachine.global_load_b32
// APPLY-NEXT: [[IND:%.*]] = waveamdmachine.v_add_u32
// APPLY-NEXT: waveamdmachine.v_add_u32 [[LOADED]], [[IND]]

// NOAPPLY-LABEL: func.func @candidate_lower
// NOAPPLY: [[TOK:%.*]] = waveamdmachine.token
// NOAPPLY-NEXT: [[IND:%.*]] = waveamdmachine.v_add_u32
// NOAPPLY-NEXT: [[LOADED:%.*]], [[LOADTOK:%.*]] = waveamdmachine.global_load_b32
// NOAPPLY-NEXT: waveamdmachine.v_add_u32 [[LOADED]], [[IND]]

// PIPE-LABEL: func.func @candidate_lower
// PIPE: waveamdmachine.global_load_b32
// PIPE: waveamdmachine.s_waitcnt
// PIPE: return
