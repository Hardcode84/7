// RUN: wave-opt %s --wavemeta-specialize | FileCheck %s

// Module-level `wavemeta.params` dict binds `unroll` to 4. The
// pre-bound `use_lds` already had `$value` attached; both fold to
// arith.constant via the dialect's materialiser.

// CHECK-LABEL: func.func @bound_via_dict
// CHECK-NOT: wavemeta.param
// CHECK: %[[C:.+]] = arith.constant 4 : index
// CHECK: return %[[C]] : index

// CHECK-LABEL: func.func @bound_via_attr
// CHECK-NOT: wavemeta.param
// CHECK: %[[T:.+]] = arith.constant true
// CHECK: return %[[T]] : i1

module attributes {wavemeta.params = {unroll = 4 : index, use_lds = true}} {
  func.func @bound_via_dict() -> index {
    %v = wavemeta.param "unroll" : index
    return %v : index
  }

  func.func @bound_via_attr() -> i1 {
    %v = wavemeta.param "use_lds" : i1
    return %v : i1
  }
}
