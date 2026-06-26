// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REGALLOC-LABEL: func.func @agpr_mfma_chain
// REGALLOC-SAME: waveamdmachine.agpr_count = 12 : i64
// REGALLOC: %[[A:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[B:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[ACC:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[RESULT:.+]] = waveamdmachine.mfma_f32_16x16x32_f16 %[[A]], %[[B]], %[[ACC]]
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4
// REGALLOC: waveamdmachine.v_accvgpr_read_b32_tuple %[[RESULT]]

// ASM-LABEL: agpr_mfma_chain:
// ASM: v_accvgpr_write_b32 [[A0:a[0-9]+]], {{v[0-9]+}}
// ASM: v_accvgpr_write_b32 [[B0:a[0-9]+]], {{v[0-9]+}}
// ASM: v_mfma_f32_16x16x32_f16 [[DST:a\[[0-9]+:[0-9]+\]]], [[A:a\[[0-9]+:[0-9]+\]]], [[B:a\[[0-9]+:[0-9]+\]]], [[C:a\[[0-9]+:[0-9]+\]]]
// ASM: v_accvgpr_read_b32 {{v[0-9]+}}, {{a[0-9]+}}
// ASM: .amdhsa_next_free_vgpr 28
// ASM: .amdhsa_accum_offset 16
// ASM: .set .Lagpr_mfma_chain.num_agpr, 12
// ASM: .agpr_count:     12
func.func @agpr_mfma_chain() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a = waveamdmachine.v_accvgpr_write_b32_tuple %a_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.v_accvgpr_write_b32_tuple %b_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %result = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %result
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %elem:4 = waveamdmachine.tuple_to_elements %read
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %elem#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// REGALLOC-LABEL: func.func @mfma_loop_carried_accumulator
// REGALLOC: %[[INIT:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT:[0-9]+]]>
// REGALLOC: %[[RESULTS:.+]]:2 = waveamdmachine.uniform_loop
// REGALLOC-SAME: carries(%{{.*}}, %[[INIT]] : {{.*}}, !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>)
// REGALLOC: ^bb0({{.*}}, %[[ACC_ARG:[A-Za-z0-9_]+]]: !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>):
// REGALLOC-NOT: waveamdmachine.v_mov_b32_tuple
// REGALLOC: %[[MFMA:.+]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[ACC_ARG]]
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>
// REGALLOC-NOT: waveamdmachine.v_mov_b32_tuple
// REGALLOC: waveamdmachine.continue_if {{.*}}carries({{.*}}, %[[MFMA]]
// REGALLOC: waveamdmachine.v_accvgpr_read_b32_tuple %[[RESULTS]]#1
// REGALLOC-SAME: (!waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>)
func.func @mfma_loop_carried_accumulator() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %init = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init : !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<agpr, 4>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %acc: !waveamdmachine.reg<agpr, 4>):
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
           !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
    %next_iv, %add_scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %next_iv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%next_iv, %mfma : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<agpr, 4>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<agpr, 4>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %results#1
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @scaled_mfma_accumulator_alias
// REGALLOC: %[[ACC:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT:[0-9]+]]>
// REGALLOC: %[[RESULT:.+]] = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 {{.*}}, {{.*}}, %[[ACC]]
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>
// REGALLOC: waveamdmachine.v_accvgpr_read_b32_tuple %[[RESULT]]
// REGALLOC-SAME: (!waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>)
func.func @scaled_mfma_accumulator_alias() {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %scale_a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %scale_b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %result = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
      %a, %b, %acc, %scale_a, %scale_b
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<agpr, 4>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %result
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @shared_agpr_mfma_acc_no_prep_bridge
// REGALLOC: %[[ACC_V:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4
// REGALLOC: %[[ACC:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[ACC_V]]
// REGALLOC-NOT: waveamdmachine.v_accvgpr_read_b32_tuple %[[ACC]]
// REGALLOC-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[ACC]]
// REGALLOC-NOT: waveamdmachine.v_accvgpr_read_b32_tuple %[[ACC]]
// REGALLOC-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[ACC]]
func.func @shared_agpr_mfma_acc_no_prep_bridge() {
  %a0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %a1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %r0 = waveamdmachine.v_accvgpr_read_b32_tuple %mfma0
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.v_accvgpr_read_b32_tuple %mfma1
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @duplicate_agpr_loop_init_clones_source_write
// REGALLOC: %[[SRC:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4
// REGALLOC: %[[INIT:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[SRC]]
// REGALLOC-NOT: waveamdmachine.v_accvgpr_read_b32_tuple %[[INIT]]
// REGALLOC: %[[DUP:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[SRC]]
// REGALLOC: waveamdmachine.uniform_loop
// REGALLOC-SAME: carries({{.*}}, %[[INIT]], %[[DUP]]
func.func @duplicate_agpr_loop_init_clones_source_write() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %init = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init, %init : !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %acc0: !waveamdmachine.reg<agpr, 4>,
       %acc1: !waveamdmachine.reg<agpr, 4>):
    %a0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
    %b0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
    %a1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
    %b1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
    %next0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc0
        : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
           !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
    %next1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc1
        : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
           !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
    %next_iv, %add_scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %next_iv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%next_iv, %next0, %next1 : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<agpr, 4>,
       !waveamdmachine.reg<agpr, 4>
  %r0 = waveamdmachine.v_accvgpr_read_b32_tuple %results#1
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.v_accvgpr_read_b32_tuple %results#2
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @shared_mfma_acc
// REGALLOC: %[[COPY0:[A-Za-z0-9_]+]] = waveamdmachine.v_mov_b32_tuple %[[ACC:[A-Za-z0-9_]+]]
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[COPY0]]
// REGALLOC: %[[COPY1:[A-Za-z0-9_]+]] = waveamdmachine.v_mov_b32_tuple %[[ACC]]
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[COPY1]]
func.func @shared_mfma_acc() {
  %a0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @mfma_accumulator_tuple_slot
// REGALLOC: %[[PARTS:[A-Za-z0-9_]+]]:2 = waveamdmachine.tuple_to_elements
// REGALLOC-SAME: -> (!waveamdmachine.reg<agpr, 4, {{[0-9]+}}>, !waveamdmachine.reg<agpr, 4, [[ACC_SLOT:[0-9]+]]>)
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[PARTS]]#1
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>
func.func @mfma_accumulator_tuple_slot() {
  %lo = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %hi = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %tuple = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
      -> !waveamdmachine.reg<agpr, 8>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<agpr, 8>)
      -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %parts#1
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %read_lo = waveamdmachine.v_accvgpr_read_b32_tuple %parts#0
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %read_mfma = waveamdmachine.v_accvgpr_read_b32_tuple %mfma
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
