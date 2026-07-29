// RUN: wave-opt --waveamd-insert-ticket-waits %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits %s \
// RUN:   | wave-opt --waveamd-insert-ticket-waits \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @overlapping_partial_async_completion
// CHECK: [[FIRST:%.*]] = waveamdmachine.global_load_async_to_lds_b8
// CHECK-NEXT: [[SECOND:%.*]] = waveamdmachine.global_load_async_to_lds_b32
// CHECK-NEXT: [[THIRD:%.*]] = waveamdmachine.global_load_async_to_lds_b64
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(2)
// CHECK-NEXT: waveamdmachine.s_barrier [[FIRST]]
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(1)
// CHECK-NEXT: waveamdmachine.s_barrier [[SECOND]]
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier [[THIRD]]
func.func @overlapping_partial_async_completion(
    %lds: !waveamdmachine.reg<vgpr, 1>,
    %offset: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.global_load_async_to_lds_b32
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %third = waveamdmachine.global_load_async_to_lds_b64
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %first
      : (!waveamdmachine.mem.token) -> ()
  waveamdmachine.s_barrier %second
      : (!waveamdmachine.mem.token) -> ()
  waveamdmachine.s_barrier %third
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @cluster_async_partial_completion
// CHECK: [[FIRST:%.*]] = waveamdmachine.cluster_load_async_to_lds_b8
// CHECK-NEXT: [[SECOND:%.*]] = waveamdmachine.cluster_load_async_to_lds_b32
// CHECK-NEXT: [[THIRD:%.*]] = waveamdmachine.cluster_load_async_to_lds_b64
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(2)
// CHECK-NEXT: waveamdmachine.s_barrier [[FIRST]]
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(1)
// CHECK-NEXT: waveamdmachine.s_barrier [[SECOND]]
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier [[THIRD]]
func.func @cluster_async_partial_completion(
    %lds: !waveamdmachine.reg<vgpr, 1>,
    %offset: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %m0: !waveamdmachine.m0) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.cluster_load_async_to_lds_b8
      %lds, %offset, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.cluster_load_async_to_lds_b32
      %lds, %offset, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %third = waveamdmachine.cluster_load_async_to_lds_b64
      %lds, %offset, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %first
      : (!waveamdmachine.mem.token) -> ()
  waveamdmachine.s_barrier %second
      : (!waveamdmachine.mem.token) -> ()
  waveamdmachine.s_barrier %third
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @explicit_async_issue_order
// CHECK: [[FIRST:%.*]] = waveamdmachine.global_load_async_to_lds_b8
// CHECK-NEXT: waveamdmachine.s_waitcnt_split asynccnt(0)
// CHECK-NEXT: waveamdmachine.global_load_async_to_lds_b32
func.func @explicit_async_issue_order(
    %lds: !waveamdmachine.reg<vgpr, 1>,
    %offset: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %ordered_first = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ordered_second = waveamdmachine.global_load_async_to_lds_b32
      %lds, %offset, %base after %ordered_first
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// CHECK-LABEL: func.func @saturated_async_requirement_is_clamped
// CHECK: [[OLDEST:%.*]] = waveamdmachine.global_load_async_to_lds_b8
// CHECK: waveamdmachine.s_waitcnt_split asynccnt(62)
// CHECK-NEXT: waveamdmachine.s_barrier [[OLDEST]]
func.func @saturated_async_requirement_is_clamped(
    %lds: !waveamdmachine.reg<vgpr, 1>,
    %offset: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %a0 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a1 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a2 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a3 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a4 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a5 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a6 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a7 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a8 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a9 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a10 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a11 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a12 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a13 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a14 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a15 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a16 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a17 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a18 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a19 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a20 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a21 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a22 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a23 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a24 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a25 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a26 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a27 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a28 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a29 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a30 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a31 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a32 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a33 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a34 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a35 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a36 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a37 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a38 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a39 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a40 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a41 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a42 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a43 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a44 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a45 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a46 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a47 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a48 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a49 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a50 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a51 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a52 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a53 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a54 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a55 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a56 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a57 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a58 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a59 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a60 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a61 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a62 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a63 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %a0
      : (!waveamdmachine.mem.token) -> ()
  return
}

}
