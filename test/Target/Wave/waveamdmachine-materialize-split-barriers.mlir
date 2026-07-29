// RUN: wave-opt %s --split-input-file --waveamd-materialize-split-barriers | FileCheck %s --implicit-check-not=waveamdmachine.barrier_

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @materialize_split_barrier(
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK: [[ZERO_IMM:%.*]] = waveamdmachine.imm 0 :
// CHECK-NEXT: [[ZERO:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO_IMM]]
// CHECK-NEXT: [[ONE:%.*]] = waveamdmachine.s_mov_b64_imm 1
// CHECK-NEXT: [[INIT_SAVE:%.*]], {{%.*}} = waveamdmachine.s_and_saveexec_b64 [[ONE]]
// CHECK-NEXT: [[INIT_ADDR_IMM:%.*]] = waveamdmachine.imm 16 :
// CHECK-NEXT: [[INIT_ADDR:%.*]] = waveamdmachine.v_mov_b32_tuple [[INIT_ADDR_IMM]]
// CHECK-NEXT: [[INIT:%.*]] = waveamdmachine.ds_store_b32 [[INIT_ADDR]], [[ZERO]]
// CHECK-NEXT: waveamdmachine.s_mov_exec_b64 [[INIT_SAVE]]
// CHECK-NEXT: waveamdmachine.s_barrier [[INIT]]
// CHECK: [[DYN_STORE:%.*]] = waveamdmachine.ds_store_b32
// CHECK: [[ARRIVE_DEP:%.*]] = waveamdmachine.after [[DYN_STORE]]
// CHECK: [[ARRIVE_SAVE:%.*]], {{%.*}} = waveamdmachine.s_and_saveexec_b64
// CHECK-NEXT: [[OLD:%.*]], [[ATOMIC:%.*]] = waveamdmachine.ds_add_rtn_u32 {{%.*}}, {{%.*}} after [[ARRIVE_DEP]]
// CHECK-NEXT: waveamdmachine.s_mov_exec_b64 [[ARRIVE_SAVE]]
// CHECK-NEXT: [[TICKET:%.*]] = waveamdmachine.v_readfirstlane_b32 [[OLD]]
// CHECK: [[MASK:%.*]] = waveamdmachine.imm 4294967292 :
// CHECK: [[BASE:%.*]], {{%.*}} = waveamdmachine.s_and_b32 [[TICKET]], [[MASK]]
// CHECK: [[COUNT:%.*]] = waveamdmachine.imm 4 :
// CHECK: [[TARGET:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[BASE]], [[COUNT]]
// CHECK: [[POLL_ONE:%.*]] = waveamdmachine.s_mov_b64_imm 1
// CHECK-NEXT: [[POLL_SAVE:%.*]], {{%.*}} = waveamdmachine.s_and_saveexec_b64 [[POLL_ONE]]
// CHECK: [[FAST_SEEN:%.*]], [[FAST_POLL:%.*]] = waveamdmachine.ds_load_b32 {{%.*}} after [[ATOMIC]]
// CHECK-NEXT: [[ALL_ONES:%.*]] = waveamdmachine.imm 4294967295 :
// CHECK-NEXT: [[NOT_TARGET:%.*]], {{%.*}} = waveamdmachine.s_xor_b32 [[TARGET]], [[ALL_ONES]]
// CHECK-NEXT: [[ONE_IMM:%.*]] = waveamdmachine.imm 1 :
// CHECK-NEXT: [[NEG_TARGET:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[NOT_TARGET]], [[ONE_IMM]]
// CHECK-NEXT: [[FAST_SEEN_SCALAR:%.*]] = waveamdmachine.v_readfirstlane_b32 [[FAST_SEEN]]
// CHECK-NEXT: [[FAST_DELTA:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[FAST_SEEN_SCALAR]], [[NEG_TARGET]]
// CHECK-NEXT: [[FAST_HALF:%.*]] = waveamdmachine.imm 2147483648 :
// CHECK-NEXT: [[FAST_CONT:%.*]] = waveamdmachine.s_cmp_ge_u32 [[FAST_DELTA]], [[FAST_HALF]]
// CHECK-NEXT: [[READY:%.*]] = waveamdmachine.uniform_if [[FAST_CONT]] {
// CHECK-NEXT: [[LOOP_READY:%.*]] = waveamdmachine.uniform_loop carries([[FAST_POLL]] : !waveamdmachine.mem.token) {
// CHECK: ^bb0([[POLL_ARG:%.*]]: !waveamdmachine.mem.token):
// CHECK-NEXT: [[SLEEP:%.*]] = waveamdmachine.imm 1 :
// CHECK-NEXT: waveamdmachine.s_sleep [[SLEEP]]
// CHECK: [[SEEN:%.*]], [[POLL:%.*]] = waveamdmachine.ds_load_b32 {{%.*}} after [[POLL_ARG]]
// CHECK-NEXT: [[SEEN_SCALAR:%.*]] = waveamdmachine.v_readfirstlane_b32 [[SEEN]]
// CHECK-NEXT: [[DELTA:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[SEEN_SCALAR]], [[NEG_TARGET]]
// CHECK-NEXT: [[HALF:%.*]] = waveamdmachine.imm 2147483648 :
// CHECK-NEXT: [[CONT:%.*]] = waveamdmachine.s_cmp_ge_u32 [[DELTA]], [[HALF]]
// CHECK-NEXT: waveamdmachine.continue_if [[CONT]] : !waveamdmachine.reg<scc, 1> carries([[POLL]]
// CHECK: waveamdmachine.yield [[LOOP_READY]]
// CHECK: } otherwise {
// CHECK-NEXT: waveamdmachine.yield [[FAST_POLL]]
// CHECK: waveamdmachine.s_mov_exec_b64 [[POLL_SAVE]]
// CHECK-NEXT: waveamdmachine.token_join [[READY]]
func.func @materialize_split_barrier()
    attributes {wave.kernel, wave.lds_size = 16 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %store
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @materialize_native_split_barrier(
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_b32
// CHECK-NEXT: [[SIGNAL:%.*]] = waveamdmachine.s_barrier_signal [[STORE]]
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: [[WAIT:%.*]] = waveamdmachine.s_barrier_wait [[SIGNAL]]
// CHECK-NEXT: waveamdmachine.token_join [[WAIT]]
// CHECK-NOT: waveamdmachine.ds_add_rtn_u32
// CHECK-NOT: waveamdmachine.ds_load_b32
// CHECK-NOT: waveamdmachine.s_sleep
func.func @materialize_native_split_barrier()
    attributes {wave.kernel, wave.lds_size = 16 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %store
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %addr, %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @dynamic_vgpr_shift(
// CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[ADDR:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[SIXTEEN:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[SHIFT:%.*]] = waveamdmachine.v_add_u32 [[ADDR]], [[SIXTEEN]]
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[SHIFT]]
func.func @dynamic_vgpr_shift()
    attributes {wave.kernel, wave.dynamic_lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %store
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @dynamic_m0_shift(
// CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[BASE:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
// CHECK: [[SIXTEEN:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[BASE]], [[SIXTEEN]]
// CHECK-NEXT: [[FILLER:%.*]] = waveamdmachine.v_add_u32
// CHECK-NOT: waveamdmachine.s_mov_m0 [[BASE]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 [[FILLER]], {{%.*}}, {{%.*}}, [[M0]]
func.func @dynamic_m0_shift()
    attributes {wave.kernel, wave.dynamic_lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %filler = waveamdmachine.v_add_u32 %addr, %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %dma = waveamdmachine.buffer_load_lds_b32 %filler, %desc, %zero, %m0
      after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %dma
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @dynamic_m0_chain_shift(
// CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[BASE:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
// CHECK: [[SIXTEEN:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[BASE]], [[SIXTEEN]]
// CHECK: [[DMA0:%.*]] = waveamdmachine.buffer_load_lds_b32 {{.*}}, [[M0]]
// CHECK-NEXT: [[M1:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[M0]], {{%.*}}
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 {{.*}}, [[M1]] after [[DMA0]]
func.func @dynamic_m0_chain_shift()
    attributes {wave.kernel, wave.dynamic_lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %dma0 = waveamdmachine.buffer_load_lds_b32
      %addr, %desc, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %m1, %unused = waveamdmachine.s_add_m0_i32 %m0, %step
      : (!waveamdmachine.m0, !waveamdmachine.imm)
        -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %dma1 = waveamdmachine.buffer_load_lds_b32
      %addr, %desc, %zero, %m1 after %dma0
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %dma1
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @shared_m0_shift(
// CHECK: [[FILL0:%.*]] = waveamdmachine.v_add_u32
// CHECK-NEXT: [[SIXTEEN0:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[M0A:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 {{%.*}}, [[SIXTEEN0]]
// CHECK-NEXT: [[DMA0:%.*]] = waveamdmachine.buffer_load_lds_b32 [[FILL0]], {{%.*}}, {{%.*}}, [[M0A]]
// CHECK-NEXT: [[FILL1:%.*]] = waveamdmachine.v_xor_b32
// CHECK-NEXT: [[SIXTEEN1:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[M0B:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 {{%.*}}, [[SIXTEEN1]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 [[FILL1]], {{%.*}}, {{%.*}}, [[M0B]] after [[DMA0]]
func.func @shared_m0_shift()
    attributes {wave.kernel, wave.dynamic_lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %filler0 = waveamdmachine.v_add_u32 %addr, %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %dma0 = waveamdmachine.buffer_load_lds_b32
      %filler0, %desc, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %filler1 = waveamdmachine.v_xor_b32 %addr, %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %dma1 = waveamdmachine.buffer_load_lds_b32
      %filler1, %desc, %zero, %m0 after %dma0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @split_barrier_3d_workgroup(
// CHECK: [[COUNT:%.*]] = waveamdmachine.imm 4 :
// CHECK: waveamdmachine.s_add_i32 {{%.*}}, [[COUNT]]
func.func @split_barrier_3d_workgroup()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 16, 8, 2>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %root
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

// No split ops: no target query required.
module {
  func.func @no_split_no_target() {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @dynamic_delayed_m0_chain_shift(
// CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[BASE:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
// CHECK: [[SIXTEEN:%.*]] = waveamdmachine.imm 16
// CHECK-NEXT: [[M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[BASE]], [[SIXTEEN]]
// CHECK: [[DMA0:%.*]] = waveamdmachine.buffer_load_lds_b32 {{.*}}, [[M0]]
// CHECK-NEXT: [[M1:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[M0]], {{%.*}}
// CHECK-NEXT: [[DELAYED:%.*]] = waveamdmachine.dma_issue_delay [[DMA0]], [[M1]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 {{.*}}, [[DELAYED]] after [[DMA0]]
func.func @dynamic_delayed_m0_chain_shift()
    attributes {wave.kernel, wave.dynamic_lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
  %addr = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %dma0 = waveamdmachine.buffer_load_lds_b32
      %addr, %desc, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %m1, %unused = waveamdmachine.s_add_m0_i32 %m0, %step
      : (!waveamdmachine.m0, !waveamdmachine.imm)
        -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %delayed = waveamdmachine.dma_issue_delay %dma0, %m1 {cycles = 17 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  %dma1 = waveamdmachine.buffer_load_lds_b32
      %addr, %desc, %zero, %delayed after %dma0
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %dma1
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}
