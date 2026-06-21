// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        scalar_vgpr_loop_carry_no_memory_spill
// REMARK: class:           VGPR
// REMARK: memory_spill_reject: loop_carry
// REMARK: pressure_relief_providers: '{{.*}}provider=scratch-spill{{.*}}reject=loop_carry{{.*}}'
// REMARK: pressure_relief_candidates: '[]'
// REMARK: loop_carry:      '1'
// REMARK: total:           '2'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @scalar_vgpr_loop_carry_no_memory_spill()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %scalar = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %loop = waveamdmachine.uniform_loop if %ec
      : !waveamdmachine.reg<scc, 1>
      carries(%scalar : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%cur : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_mov_b32_tuple %loop {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %parts:4 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  waveamdmachine.s_endpgm
  return
}

}
