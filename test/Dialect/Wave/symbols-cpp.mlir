// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: wave-symbols-test | FileCheck %s

// CHECK: int: -42
// CHECK: unit-rat: 7
// CHECK: non-unit-rat: none
// CHECK: symbol: none

// Two independently-constructed expressions that ixsimpl folds to the
// same canonical form. Both `floor((4*x + 2*x) / 3)` and `floor((6*x) / 3)`
// must simplify to `2*x`, and the simplifier must return the exact same
// hash-consed node pointer.
// CHECK: lhs-simplified: {{.*}}
// CHECK: rhs-simplified: {{.*}}
// CHECK: pointer-equal-after-simplify: true

// Leaf symbols dedup on structure: two `ixs_sym(.., "x")` calls in the same
// store return the same pointer.
// CHECK: hash-consed-symbol: true

// Range queries via `sym::provablyInRange`. Assumption `x in [0, 31]`
// flattens through the AND-of-CMPs wrapper into two CMP leaves; the
// `4*x+1` linear expression then ranges over [1, 125].
// CHECK: x-nonneg: true
// CHECK: fits-tight: true
// CHECK: fits-loose: true
// CHECK: overflows-upper: false
// CHECK: no-assumptions: false
