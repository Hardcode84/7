// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3 agpr-limit=0' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        scratch_latency_does_not_override_lower_bridge
// REMARK: provider:        scratch-spill
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=5, loop_ops=0, latency=32, instability=0}{{.*}}selected{{.*}}cost={ops=8, loop_ops=0, latency=16, instability=0}{{.*}}'

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

}
