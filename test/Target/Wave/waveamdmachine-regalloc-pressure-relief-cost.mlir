// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3 agpr-limit=0' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        scratch_latency_does_not_override_lower_bridge
// REMARK: provider:        scratch-spill
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=5, loop_ops=0, latency=32, instability=0}{{.*}}selected{{.*}}cost={ops=8, loop_ops=0, latency=16, instability=0}{{.*}}'
// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        scratch_loop_latency_scaled
// REMARK: provider:        scratch-spill
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=1, loop_ops=16, latency=128, instability=0}{{.*}}cost={ops=2, loop_ops=0, latency=8, instability=0}{{.*}}selected{{.*}}'
// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        lds_loop_latency_scaled
// REMARK: provider:        lds-spill
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=2, loop_ops=32, latency=32, instability=0}{{.*}}cost={ops=4, loop_ops=0, latency=2, instability=0}{{.*}}selected{{.*}}'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @scratch_latency_does_not_override_lower_bridge()
    attributes {wave.kernel, wave.private_segment_fixed_size = 4096 : i64,
                waveamdmachine.target_waves = 4 : i64} {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %low = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %t0 = waveamdmachine.global_store_b32 %off, %low, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t1 = waveamdmachine.global_store_b32 %off, %low, %base after %t0
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b32 %off, %low, %base after %t1
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %t3 = waveamdmachine.global_store_b32 %off, %low, %base after %t2
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %t4 = waveamdmachine.global_store_tuple_b32 %off, %wide, %base after %t3
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

func.func @scratch_loop_latency_scaled()
    attributes {wave.kernel, wave.private_segment_fixed_size = 4096 : i64,
                waveamdmachine.target_waves = 4 : i64} {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %hot = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %cold = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %hold = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %t0 = waveamdmachine.global_store_b32 %off, %hot, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %t1 = waveamdmachine.global_store_b32 %off, %cold, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b32 %off, %hold, %base after %t1
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

func.func @lds_loop_latency_scaled()
    attributes {wave.kernel, wave.private_segment_fixed_size = 4096 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %hot = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %cold = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %hold = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %t0 = waveamdmachine.global_store_b32 %off, %hot, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %t1 = waveamdmachine.global_store_b32 %off, %cold, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b32 %off, %hold, %base after %t1
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
