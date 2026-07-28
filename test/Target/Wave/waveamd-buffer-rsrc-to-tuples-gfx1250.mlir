// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @make_buffer_rsrc_gfx1250(
// CHECK-SAME: %[[BASE:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK-SAME: %[[RANGE:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[BASE_MASK_IMM:.*]] = waveamdmachine.s_mov_b64_imm 144115188075855871
// CHECK: %[[BASE_MASKED:.*]], %{{.*}} = waveamdmachine.s_and_b64 %[[BASE]], %[[BASE_MASK_IMM]]
// CHECK: %[[RANGE_MASK_IMM:.*]] = waveamdmachine.s_mov_b64_imm 35184372088831
// CHECK: %[[RANGE_MASKED:.*]], %{{.*}} = waveamdmachine.s_and_b64 %[[RANGE]], %[[RANGE_MASK_IMM]]
// CHECK: %[[SHIFT57:.*]] = waveamdmachine.imm 57
// CHECK: %[[RANGE_LOW:.*]], %{{.*}} = waveamdmachine.s_lshl_b64 %[[RANGE_MASKED]], %[[SHIFT57]]
// CHECK: %[[LOW:.*]], %{{.*}} = waveamdmachine.s_or_b64 %[[BASE_MASKED]], %[[RANGE_LOW]]
// CHECK: %[[SHIFT7:.*]] = waveamdmachine.imm 7
// CHECK: %[[RANGE_HIGH:.*]], %{{.*}} = waveamdmachine.s_lshr_b64 %[[RANGE_MASKED]], %[[SHIFT7]]
// CHECK: %[[FLAGS:.*]] = waveamdmachine.s_mov_b64_imm 3531209135951446016
// CHECK: %[[HIGH:.*]], %{{.*}} = waveamdmachine.s_or_b64 %[[RANGE_HIGH]], %[[FLAGS]]
// CHECK: %[[DESC:.*]] = waveamdmachine.tuple_from_elements %[[LOW]], %[[HIGH]]
// CHECK-NOT: waveamdmachine.make_buffer_rsrc
func.func @make_buffer_rsrc_gfx1250(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %range: !waveamdmachine.reg<sgpr, 2>) {
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}

// CHECK-LABEL: func.func @make_buffer_rsrc_wide_imm(
// CHECK: %[[RANGE_IMM:.*]] = waveamdmachine.imm 4294967296
// CHECK: %[[RANGE_WIDE:.*]] = waveamdmachine.s_mov_b64_imm 4294967296
// CHECK: waveamdmachine.s_and_b64 %[[RANGE_WIDE]]
func.func @make_buffer_rsrc_wide_imm(
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %range = waveamdmachine.imm 4294967296 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}

// CHECK-LABEL: func.func @make_buffer_rsrc_field_maxima(
// CHECK: %[[BASE:.*]] = waveamdmachine.s_mov_b64_imm 144115188075855871
// CHECK: %[[RANGE:.*]] = waveamdmachine.s_mov_b64_imm 35184372088831
// CHECK: %[[LOW:.*]] = waveamdmachine.s_mov_b64_imm -1
// dword3 0x3101603f: range high 0x3f, format 0x16, level 1, OOB 3.
// CHECK: %[[HIGH:.*]] = waveamdmachine.s_mov_b64_imm 3531209410829352959
// CHECK: waveamdmachine.tuple_from_elements %[[LOW]], %[[HIGH]]
// CHECK-NOT: waveamdmachine.s_and_b64
func.func @make_buffer_rsrc_field_maxima() {
  %base = waveamdmachine.s_mov_b64_imm 144115188075855871
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.s_mov_b64_imm 35184372088831
      : !waveamdmachine.reg<sgpr, 2>
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}

// CHECK-LABEL: func.func @update_buffer_rsrc_base_gfx1250(
// CHECK-SAME: %[[DESC:[^:]+]]: !waveamdmachine.reg<sgpr, 4>
// CHECK-SAME: %[[BASE:[^:]+]]: !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[PARTS:.*]]:2 = waveamdmachine.tuple_to_elements %[[DESC]]
// CHECK: %[[BASE_MASK_IMM:.*]] = waveamdmachine.s_mov_b64_imm 144115188075855871
// CHECK: %[[BASE_MASKED:.*]], %{{.*}} = waveamdmachine.s_and_b64 %[[BASE]], %[[BASE_MASK_IMM]]
// CHECK: %[[KEEP_MASK:.*]] = waveamdmachine.s_mov_b64_imm -144115188075855872
// CHECK: %[[KEPT:.*]], %{{.*}} = waveamdmachine.s_and_b64 %[[PARTS]]#0, %[[KEEP_MASK]]
// CHECK: %[[LOW:.*]], %{{.*}} = waveamdmachine.s_or_b64 %[[BASE_MASKED]], %[[KEPT]]
// CHECK: %[[UPDATED:.*]] = waveamdmachine.tuple_from_elements %[[LOW]], %[[PARTS]]#1
// CHECK-NOT: waveamdmachine.update_buffer_rsrc_base
func.func @update_buffer_rsrc_base_gfx1250(
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %updated = waveamdmachine.update_buffer_rsrc_base %desc, %base
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<sgpr, 4>
  return
}

}
