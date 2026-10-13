// RUN: wave-opt %s --waveamd-expand-materialization-variants | FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants

// CHECK-LABEL: func.func @dependent_tuples
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_store_b64
// CHECK-NOT: waveamdmachine.buffer_
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_store_b64
// CHECK-NOT: waveamdmachine.buffer_
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_store_b64
// CHECK-NOT: waveamdmachine.buffer_
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.buffer_store_b64
// CHECK-NOT: waveamdmachine.buffer_
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return

func.func @dependent_tuples(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.mem.token {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %alternate = waveamdmachine.v_add_u32 %zero, %off
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %a, %ta = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.buffer_load_b32 %off, %desc, %zero offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %first = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  %c, %tc = waveamdmachine.buffer_load_b32 %alternate, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %d, %td = waveamdmachine.buffer_load_b32 %alternate, %desc, %zero offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %second = waveamdmachine.tuple_from_elements %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  %value = waveamdmachine.materialization_variants %first, %second
      : !waveamdmachine.reg<vgpr, 2>
  %stored0 = waveamdmachine.buffer_store_b64 %off, %value, %desc, %zero offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.mem.token
  %stored1 = waveamdmachine.buffer_store_b64 %alternate, %value, %desc, %zero offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.mem.token
  %done = waveamdmachine.materialization_variants %stored0, %stored1
      : !waveamdmachine.mem.token
  return %done : !waveamdmachine.mem.token
}
