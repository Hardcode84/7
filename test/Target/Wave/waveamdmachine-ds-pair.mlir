// RUN: wave-opt --waveamd-pair-ds-ops --split-input-file %s | FileCheck %s

module {

// CHECK-LABEL: func.func @load_chain_b32(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[PAIR:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load2_b32 [[ADDR]] after [[ROOT]] offsets(0, 2)
// CHECK-NEXT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements [[PAIR]]
// CHECK-NOT: waveamdmachine.ds_load_b32
// CHECK: return [[SPLIT]]#0, [[SPLIT]]#1, [[TOK]]
func.func @load_chain_b32(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.mem.token) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a, %ta = waveamdmachine.ds_load_b32 %addr after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.ds_load_b32 %addr after %ta offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  func.return %a, %b, %tb
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @load_chain_b64(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[PAIR:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load2_b64 [[ADDR]] after [[ROOT]] offsets(0, 2)
// CHECK-NEXT: [[SPLIT:%.*]]:2 = waveamdmachine.tuple_to_elements [[PAIR]]
// CHECK-NOT: waveamdmachine.ds_load_b64
// CHECK: return [[SPLIT]]#0, [[SPLIT]]#1, [[TOK]]
func.func @load_chain_b64(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
        !waveamdmachine.mem.token) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a, %ta = waveamdmachine.ds_load_b64 %addr after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.ds_load_b64 %addr after %ta offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  func.return %a, %b, %tb
      : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
        !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @store_chain_b32(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[A:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[TOK:%.*]] = waveamdmachine.ds_store2_b32 [[ADDR]], [[B]], [[A]] after [[ROOT]] offsets(0, 2)
// CHECK-NOT: waveamdmachine.ds_store_b32
// CHECK: return [[TOK]]
func.func @store_chain_b32(%addr: !waveamdmachine.reg<vgpr, 1>,
                           %a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.mem.token {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %ta = waveamdmachine.ds_store_b32 %addr, %a after %root offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %tb = waveamdmachine.ds_store_b32 %addr, %b after %ta offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  func.return %tb : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @load_common_join(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[PAIR:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load2_b32 [[ADDR]] after [[ROOT]] offsets(0, 1)
// CHECK-NEXT: waveamdmachine.tuple_to_elements [[PAIR]]
// CHECK-NEXT: [[JOIN:%.*]] = waveamdmachine.token_join [[TOK]], [[TOK]]
// CHECK: return [[JOIN]]
func.func @load_common_join(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.mem.token {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a, %ta = waveamdmachine.ds_load_b32 %addr after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.ds_load_b32 %addr after %root offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %joined = waveamdmachine.token_join %ta, %tb
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  func.return %joined : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @load_common_yield(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[COND:%.*]]: !waveamdmachine.reg<scc, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[IF:%.*]]:2 = waveamdmachine.uniform_if [[COND]]
// CHECK: [[PAIR:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load2_b32 [[ADDR]] after [[ROOT]] offsets(0, 1)
// CHECK-NEXT: waveamdmachine.tuple_to_elements [[PAIR]]
// CHECK-NEXT: waveamdmachine.yield [[TOK]], [[TOK]]
// CHECK: otherwise
// CHECK: waveamdmachine.yield [[ROOT]], [[ROOT]]
// CHECK: [[JOIN:%.*]] = waveamdmachine.token_join [[IF]]#0, [[IF]]#1
// CHECK: return [[JOIN]]
func.func @load_common_yield(%addr: !waveamdmachine.reg<vgpr, 1>,
                             %cond: !waveamdmachine.reg<scc, 1>)
    -> !waveamdmachine.mem.token {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %t0, %t1 = waveamdmachine.uniform_if %cond {
    %a, %ta = waveamdmachine.ds_load_b32 %addr after %root offset 0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %b, %tb = waveamdmachine.ds_load_b32 %addr after %root offset 4
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.yield %ta, %tb
        : !waveamdmachine.mem.token, !waveamdmachine.mem.token
  } otherwise {
    waveamdmachine.yield %root, %root
        : !waveamdmachine.mem.token, !waveamdmachine.mem.token
  } : !waveamdmachine.reg<scc, 1>
      -> !waveamdmachine.mem.token, !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %t0, %t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  func.return %joined : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @store_common_join_through_unary_joins(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1, 9>, [[A:%.*]]: !waveamdmachine.reg<vgpr, 2, 12>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 2, 4>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[TOK:%.*]] = waveamdmachine.ds_store2_b64 [[ADDR]], [[A]], [[B]] after [[ROOT]] offsets(0, 1) {st64 = true}
// CHECK-NEXT: [[JOIN:%.*]] = waveamdmachine.token_join [[TOK]], [[TOK]]
// CHECK: return [[JOIN]]
func.func @store_common_join_through_unary_joins(
    %addr: !waveamdmachine.reg<vgpr, 1, 9>, %a: !waveamdmachine.reg<vgpr, 2, 12>,
    %b: !waveamdmachine.reg<vgpr, 2, 4>) -> !waveamdmachine.mem.token {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %ta = waveamdmachine.ds_store_b64 %addr, %a after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.reg<vgpr, 2, 12>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ja = waveamdmachine.token_join %ta
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %tb = waveamdmachine.ds_store_b64 %addr, %b after %root offset 512
      : (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.reg<vgpr, 2, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %jb = waveamdmachine.token_join %tb
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %ja, %jb
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  func.return %joined : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @load_different_consumers(
// CHECK: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.ds_load_b32
// CHECK-NOT: waveamdmachine.ds_load2_b32
// CHECK: waveamdmachine.token_join
// CHECK: waveamdmachine.token_join
func.func @load_different_consumers(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.mem.token, !waveamdmachine.mem.token) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a, %ta = waveamdmachine.ds_load_b32 %addr after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.ds_load_b32 %addr after %root offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ja = waveamdmachine.token_join %ta, %root
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %jb = waveamdmachine.token_join %tb, %root
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  func.return %ja, %jb : !waveamdmachine.mem.token, !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @load_chain_st64(
// CHECK-SAME: [[ADDR:%.*]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: {{%.*}}, [[TOK:%.*]] = waveamdmachine.ds_load2_b32 [[ADDR]] after [[ROOT]] offsets(0, 64) {st64 = true}
// CHECK: return [[TOK]]
func.func @load_chain_st64(%addr: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.mem.token {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a, %ta = waveamdmachine.ds_load_b32 %addr after %root offset 0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b, %tb = waveamdmachine.ds_load_b32 %addr after %ta offset 16384
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  func.return %tb : !waveamdmachine.mem.token
}

}
