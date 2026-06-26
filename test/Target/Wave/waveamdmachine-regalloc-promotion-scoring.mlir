// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=256' --waveamd-resource-info %s | FileCheck %s
// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=8 agpr-limit=256' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REMARK: Function:        prefer_accumulator_over_loop_load
// REMARK: provider:        bank-promotion
// REMARK: pressure_relief_candidates: '{{.*}}cost={ops=0, loop_ops=16, latency=0, instability=0}{{.*}}bridges=1, loop_cost=16{{.*}}cost={ops=0, loop_ops=0, latency=0, instability=0}{{.*}}selected{{.*}}'

// CHECK-LABEL: func.func @prefer_accumulator_over_loop_load
// CHECK-SAME: waveamdmachine.agpr_count = 4 : i64
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.ds_load_b128
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 4,
// CHECK: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
// CHECK-SAME: !waveamdmachine.reg<agpr, 4,
// CHECK-SAME: -> !waveamdmachine.reg<agpr, 4,
// CHECK: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
// CHECK-SAME: !waveamdmachine.reg<agpr, 4,
// CHECK-SAME: -> !waveamdmachine.reg<agpr, 4,
func.func @prefer_accumulator_over_loop_load() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %frag = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %scale = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%acc, %frag :
              !waveamdmachine.reg<vgpr, 4>,
              !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%cur: !waveamdmachine.reg<vgpr, 4>,
       %old_frag: !waveamdmachine.reg<vgpr, 4>):
    %new_frag, %tok = waveamdmachine.ds_load_b128 %addr
        : (!waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %m0 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %new_frag, %new_frag, %cur, %scale, %scale
        {scale_idx_a = 0 : i64, scale_idx_b = 0 : i64}
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    %m1 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %new_frag, %new_frag, %m0, %scale, %scale
        {scale_idx_a = 0 : i64, scale_idx_b = 0 : i64}
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%m1, %new_frag :
                !waveamdmachine.reg<vgpr, 4>,
                !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

}
