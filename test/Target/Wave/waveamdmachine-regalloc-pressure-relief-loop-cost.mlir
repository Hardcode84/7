// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        remat_loop_weighted_candidate
// REMARK: provider:        remat
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=0, loop_ops=16, latency=0, instability=0}{{.*}}cost={ops=3, loop_ops=0, latency=0, instability=0}{{.*}}selected{{.*}}'
// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        remat_loop_weighted_candidate
// REMARK: position:        '11'
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=1, loop_ops=0, latency=0, instability=0}{{.*}}rebuild_pos=12{{.*}}selected{{.*}}'
// REMARK: Name:            regalloc-pressure-relief-selection
// REMARK: Function:        remat_nested_loop_weighted_candidate
// REMARK: provider:        remat
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=0, loop_ops=256, latency=0, instability=0}{{.*}}cost={ops=3, loop_ops=0, latency=0, instability=0}{{.*}}selected{{.*}}'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @remat_loop_weighted_candidate()
    attributes {wave.kernel, wave.private_segment_fixed_size = 4096 : i64,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %outer = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %anchor0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %anchor1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_add_u32 %outer, %anchor0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %use1 = waveamdmachine.v_add_u32 %looped, %anchor1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %sink0 = waveamdmachine.v_add_u32 %use0, %outer
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sink1 = waveamdmachine.v_add_u32 %sink0, %looped
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @remat_nested_loop_weighted_candidate()
    attributes {wave.kernel, wave.private_segment_fixed_size = 4096 : i64,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %outer = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %anchor0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %anchor1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_add_u32 %outer, %anchor0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %use1 = waveamdmachine.v_add_u32 %looped, %anchor1
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %sink0 = waveamdmachine.v_add_u32 %use0, %outer
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sink1 = waveamdmachine.v_add_u32 %sink0, %looped
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
