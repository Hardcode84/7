// RUN: wave-opt %s --waveamd-machine-schedule='print-candidates=1' 2>&1 | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @matmul_loop_candidate(%off: !waveamdmachine.reg<vgpr, 1>,
                                 %base: !waveamdmachine.reg<sgpr, 2>,
                                 %va: !waveamdmachine.reg<vgpr, 1>,
                                 %vb: !waveamdmachine.reg<vgpr, 1>,
                                 %a_frag: !waveamdmachine.reg<vgpr, 8>,
                                 %b_frag: !waveamdmachine.reg<vgpr, 8>,
                                 %acc: !waveamdmachine.reg<vgpr, 8>,
                                 %iv0: !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %r:2 = waveamdmachine.uniform_loop carries(%iv0, %acc :
      !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>,
       %acc_iter: !waveamdmachine.reg<vgpr, 8>):
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %ind = waveamdmachine.v_add_u32 %va, %vb : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %wmma = waveamdmachine.wmma_f32_16x16x16_f16 %a_frag, %b_frag, %acc_iter
        : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %dep = waveamdmachine.v_add_u32 %loaded, %ind : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %next:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next#0, %wmma : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>
  return
}
}

// DIAG: waveamd-machine-schedule candidate func=matmul_loop_candidate region=1 name=original cycles=326 delta=0 issued_ops=6 order=0,1,2,3,4,5,6
// DIAG: waveamd-machine-schedule candidate func=matmul_loop_candidate region=1 name=critical_path cycles=325 delta=-1 issued_ops=6 order=0,2,1,3,4,5,6
// DIAG: waveamd-machine-schedule candidate func=matmul_loop_candidate region=1 name=wmma_feed cycles=326 delta=0 issued_ops=6 order=3,0,2,1,4,5,6
// DIAG: waveamd-machine-schedule selected func=matmul_loop_candidate region=1 name=critical_path original_cycles=326 selected_cycles=325 delta=-1 action=keep order=0,2,1,3,4,5,6
