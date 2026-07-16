// RUN: wave-opt %s --waveamd-to-machine | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @phased_dma_loop
// CHECK: [[WI:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32 [[WI]]
// CHECK: [[SIX:%.*]] = waveamdmachine.imm 6
// CHECK: [[WAVE:%.*]], %{{.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SIX]]
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[HIGH:%.*]] = waveamdmachine.s_cmp_ge_u32 [[WAVE]], [[ONE]]
// CHECK: [[FLAG:%.*]] = waveamdmachine.s_cselect_b32 [[HIGH]],
// CHECK: [[VCC:%.*]] = waveamdmachine.s_mov_vcc_b32 [[FLAG]]
// CHECK: waveamdmachine.uniform_loop carries({{.*}}[[VCC]] : {{.*}}!waveamdmachine.reg<vcc, 1>)
// CHECK: ^bb0({{.*}}[[LOOP_VCC:%.*]]: !waveamdmachine.reg<vcc, 1>):
// CHECK: [[DMA0:%.*]] = waveamdmachine.global_load_lds_b128
// CHECK-SAME: {waveamdmachine.dma_issue_timing}
// CHECK: [[NEXT_M0:%.*]], %{{.*}} = waveamdmachine.s_add_m0_i32
// CHECK: [[DELAYED:%.*]] = waveamdmachine.dma_issue_delay [[DMA0]], [[NEXT_M0]] unless [[LOOP_VCC]]
// CHECK-SAME: cycles = 17 : i64
// CHECK: waveamdmachine.global_load_lds_b128 {{.*}}, [[DELAYED]] after
// CHECK-SAME: {waveamdmachine.dma_issue_timing}
// CHECK: waveamdmachine.global_load_lds_b128
// CHECK-SAME: {waveamdmachine.dma_issue_after_delay, waveamdmachine.dma_issue_timing}
// CHECK: waveamdmachine.continue_if {{.*}}carries({{.*}}[[LOOP_VCC]] : {{.*}}!waveamdmachine.reg<vcc, 1>)
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.global_load_lds_b128
// CHECK-NOT: waveamdmachine.dma_issue_timing
// CHECK: waveamdmachine.continue_if
func.func @phased_dma_loop(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64,
                wave.workgroup_size = array<i32: 128, 1, 1>} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c256 = arith.constant 256 : index
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 127">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %next_lds = wave.ptr_add %lds, %c256
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  scf.for %i = %c0 to %c2 step %c1 {
    %first = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %second = waveamd.dma_load_lds %src -> %next_lds after %root
        {bytes = 16 : i64, issue_delay_cycles = 17 : i64,
         issue_delay_overlap_cycles = 3 : i64,
         issue_delay_skip_thread_threshold = 64 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %third = waveamd.dma_load_lds %src -> %next_lds after %root
        {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  }
  scf.for %i = %c0 to %c2 step %c1 {
    %ordinary = waveamd.dma_load_lds %src -> %lds after %root
        {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  }
  return
}

}
