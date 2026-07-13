// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-opt --canonicalize %s | FileCheck %s --check-prefix=CANON

// Pure SSA renames between a VGPR tuple and its per-slot scalar VGPRs.
// The selector / decomposition pass builds these around scalar memory
// ops; the regalloc coalesces each element into the tuple's physical
// block at `tuple_phys + slot`. Asm emit then skips them entirely.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

  // CANON-LABEL: func.func @fold_single_from
  // CANON-SAME: %[[X:.*]]: !waveamdmachine.reg<vgpr, 4>
  // CANON-NOT: waveamdmachine.tuple_from_elements
  // CANON: return %[[X]]
  func.func @fold_single_from(%x: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 4> {
    %tuple = waveamdmachine.tuple_from_elements %x
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %tuple : !waveamdmachine.reg<vgpr, 4>
  }

  // CANON-LABEL: func.func @fold_single_to
  // CANON-SAME: %[[X:.*]]: !waveamdmachine.reg<vgpr, 4>
  // CANON-NOT: waveamdmachine.tuple_to_elements
  // CANON: return %[[X]]
  func.func @fold_single_to(%x: !waveamdmachine.reg<vgpr, 4>)
      -> !waveamdmachine.reg<vgpr, 4> {
    %elem = waveamdmachine.tuple_to_elements %x
        : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    return %elem : !waveamdmachine.reg<vgpr, 4>
  }

  // CHECK-LABEL: func.func @round_trip_tuple_elements
  // CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple
  // CHECK: %[[E:.+]]:8 = waveamdmachine.tuple_to_elements %[[T]]
  // CHECK: %{{.+}} = waveamdmachine.tuple_from_elements %[[E]]#0, %[[E]]#1, %[[E]]#2, %[[E]]#3, %[[E]]#4, %[[E]]#5, %[[E]]#6, %[[E]]#7
  // CANON-LABEL: func.func @round_trip_tuple_elements
  // CANON: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple
  // CANON-NOT: waveamdmachine.tuple_to_elements
  // CANON-NOT: waveamdmachine.tuple_from_elements
  // CANON: return %[[T]]
  func.func @round_trip_tuple_elements()
      -> !waveamdmachine.reg<vgpr, 8> {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
    %elems:8 = waveamdmachine.tuple_to_elements %tuple
        : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>,
                                             !waveamdmachine.reg<vgpr, 1>)
    %rebuilt = waveamdmachine.tuple_from_elements
        %elems#0, %elems#1, %elems#2, %elems#3,
        %elems#4, %elems#5, %elems#6, %elems#7
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 8>
    return %rebuilt : !waveamdmachine.reg<vgpr, 8>
  }

  // Splitting a tuple assembled from the exact same element shape is also an
  // SSA-only round trip. Folding it keeps independent payload chunks out of a
  // single wide alias set before register allocation.
  // CANON-LABEL: func.func @fold_join_then_split
  // CANON-SAME: %[[A:.*]]: !waveamdmachine.reg<vgpr, 2>
  // CANON-SAME: %[[B:.*]]: !waveamdmachine.reg<vgpr, 4>
  // CANON-NOT: waveamdmachine.tuple_from_elements
  // CANON-NOT: waveamdmachine.tuple_to_elements
  // CANON: return %[[A]], %[[B]]
  func.func @fold_join_then_split(
      %a: !waveamdmachine.reg<vgpr, 2>,
      %b: !waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>) {
    %tuple = waveamdmachine.tuple_from_elements %a, %b
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>)
          -> !waveamdmachine.reg<vgpr, 6>
    %split:2 = waveamdmachine.tuple_to_elements %tuple
        : (!waveamdmachine.reg<vgpr, 6>)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>)
    return %split#0, %split#1
        : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 4>
  }

}
