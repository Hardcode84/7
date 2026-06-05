// RUN: wave-opt --waveamd-reg-alloc='agpr-bank-spill=true vgpr-limit=16' -split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @agpr_bank_spill_retries
// CHECK: %[[A:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr
// CHECK: %[[B:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr
// CHECK: %[[ACC:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr
// CHECK: %[[MFMA:.*]] = waveamdmachine.mfma_f32_16x16x32_f16 %[[A]], %[[B]], %[[ACC]]
// CHECK-SAME: -> !waveamdmachine.reg<agpr
// CHECK: %[[GENERIC:.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: %[[SPILLED:.*]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[GENERIC]]
// CHECK: %[[MFMA_READ:.*]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[MFMA]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[MFMA_READ]]
// CHECK: %[[GENERIC_READ:.*]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[SPILLED]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[GENERIC_READ]]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @agpr_bank_spill_retries() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_mfma = waveamdmachine.v_mov_b32_tuple %mfma {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

// CHECK-LABEL: func.func @existing_agpr_write_replaced
// CHECK: %[[CAND:.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: %[[SPILLED:.*]] = waveamdmachine.v_accvgpr_write_b32_tuple %[[CAND]]
// CHECK: %[[CAND_READ:.*]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[SPILLED]]
// CHECK: waveamdmachine.v_mov_b32_tuple %[[CAND_READ]]
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple %[[CAND]]
// CHECK: return

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @existing_agpr_write_replaced() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %candidate = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %other0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %other1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %other2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %request = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %use_candidate = waveamdmachine.v_mov_b32_tuple %candidate {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other0_a = waveamdmachine.v_mov_b32_tuple %other0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other0_b = waveamdmachine.v_mov_b32_tuple %other0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other0_c = waveamdmachine.v_mov_b32_tuple %other0 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other1_a = waveamdmachine.v_mov_b32_tuple %other1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other1_b = waveamdmachine.v_mov_b32_tuple %other1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other1_c = waveamdmachine.v_mov_b32_tuple %other1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other2_a = waveamdmachine.v_mov_b32_tuple %other2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other2_b = waveamdmachine.v_mov_b32_tuple %other2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %use_other2_c = waveamdmachine.v_mov_b32_tuple %other2 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %old_agpr = waveamdmachine.v_accvgpr_write_b32_tuple %candidate
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %old_read = waveamdmachine.v_accvgpr_read_b32_tuple %old_agpr
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %old_use = waveamdmachine.v_mov_b32_tuple %old_read {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

// CHECK-LABEL: func.func @loop_carried_mfma_accumulator_bank_spill
// CHECK: %[[LOOP:[^:]+]]:2 = waveamdmachine.uniform_loop
// CHECK-SAME: carries({{.*}}, %[[INIT_ACC:[^ ]+]] : {{.*}}, !waveamdmachine.reg<agpr, 4
// CHECK: ^bb0({{.*}}, %[[CUR_ACC:[^:]+]]: !waveamdmachine.reg<agpr, 4
// CHECK: %[[MFMA:[^ ]+]] = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[CUR_ACC]]
// CHECK-SAME: -> !waveamdmachine.reg<agpr, 4
// CHECK: waveamdmachine.continue_if {{.*}} carries({{.*}}, %[[MFMA]] : {{.*}}, !waveamdmachine.reg<agpr, 4
// CHECK: waveamdmachine.v_accvgpr_read_b32_tuple %[[LOOP]]#1

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @loop_carried_mfma_accumulator_bank_spill() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r:2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %acc :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %cur_acc: !waveamdmachine.reg<vgpr, 4>):
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %cur_acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic3 = waveamdmachine.v_mov_b32_tuple %generic3 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %mfma :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 4>
  %use = waveamdmachine.v_mov_b32_tuple %r#1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

// CHECK-LABEL: func.func @generic_loop_carry_not_agpr
// CHECK: %[[LOOP:[^:]+]]:2 = waveamdmachine.uniform_loop
// CHECK-SAME: !waveamdmachine.reg<vgpr, 4
// CHECK: ^bb0({{.*}}, %[[CUR:[^:]+]]: !waveamdmachine.reg<vgpr, 4
// CHECK: waveamdmachine.continue_if {{.*}} carries({{.*}}, %{{[^ ]+}} : {{.*}}, !waveamdmachine.reg<vgpr, 4
// CHECK: waveamdmachine.v_mov_b32_tuple %[[LOOP]]#1

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @generic_loop_carry_not_agpr() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %carry = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r:2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %carry :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %cur: !waveamdmachine.reg<vgpr, 4>):
    %next = waveamdmachine.v_mov_b32_tuple %cur {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %generic0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %generic2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    %use_generic0 = waveamdmachine.v_mov_b32_tuple %generic0 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic1 = waveamdmachine.v_mov_b32_tuple %generic1 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %use_generic2 = waveamdmachine.v_mov_b32_tuple %generic2 {registers = 4 : i64}
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %next :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 4>
  %use = waveamdmachine.v_mov_b32_tuple %r#1 {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
