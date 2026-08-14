// RUN: split-file %s %t
// RUN: not wave-opt --wave-lower-symbolic-memory --mlir-print-ir-after-failure %t/address.mlir 2>&1 | FileCheck %s --check-prefix=ADDRESS

//--- address.mlir

// Final direct-address validation rolls back packet and inactive-value
// extracts. Repeating the same condition makes this one SSA-carried predicate.
// ADDRESS: error: 'wave.gather' op mapping is not a byte-addressable local memory point
// ADDRESS-LABEL: func.func @hard_failure_rolls_back_packet_preparation(
// ADDRESS: [[DEPENDENCY:%.*]] = wave.token
// ADDRESS-NOT: wave.token
// ADDRESS-NOT: wave.extract
// ADDRESS: wave.where
// ADDRESS: wave.gather
// ADDRESS-SAME: after [[DEPENDENCY]]
// ADDRESS-NOT: wave.extract
// ADDRESS-NOT: wave.token
// ADDRESS: return
func.func @hard_failure_rolls_back_packet_preparation(
    %base: !wave.ptr<#wave.global, i32>,
    %indices: !wave.simd<vector<2xi32>, 32>,
    %fallback: !wave.simd<vector<2xi32>, 32>,
    %active0: !wave.mask<32>, %active1: !wave.mask<32>) {
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active0, %active0 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"1 + 32*slot">> bindings []()
        after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return
}
