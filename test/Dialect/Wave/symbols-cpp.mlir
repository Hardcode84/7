// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: wave-symbols-test | FileCheck %s

// CHECK: int: -42
// CHECK: unit-rat: 7
// CHECK: non-unit-rat: none
// CHECK: symbol: none

// Expansion, denominator-LCM, and u32 range wrappers stay behind WaveSymbols.
// CHECK: expanded-product: 2 + 3*x + x**2
// CHECK: denominator-lcm: 4
// CHECK: denominator-mod-rational: 4
// CHECK: denominator-piecewise: 4
// CHECK: fits-u32: true
// CHECK: fits-u32-unbounded: false

// Const-correct facade over ixsimpl ADD/MUL/unary/binary/predicate nodes.
// CHECK: view-add-valid: true
// CHECK: view-add-kind: add
// CHECK: view-add-constant: 5
// CHECK: view-add-terms: 1
// CHECK: view-add-term-coeff: 3
// CHECK: view-add-term-symbol: x
// CHECK: view-mul-kind: mul
// CHECK: view-mul-coeff: 3
// CHECK: view-mul-factors: 1
// CHECK: view-mul-factor-symbol: x
// CHECK: view-mul-factor-exp: 1
// CHECK: view-floor-arg-kind: mul
// CHECK: view-mod-lhs-kind: mul
// CHECK: view-mod-rhs: 5
// CHECK: view-pred-valid: true
// CHECK: view-pred-kind: and
// CHECK: view-pred-args: 2
// CHECK: view-pred-first-kind: cmp

// Reusable facts serve construction, proof, algebra, and substitution queries.
// CHECK: analysis-batch-pointer-equal: true
// CHECK: analysis-undefined-self-equivalent: unknown
// CHECK: analysis-check: true
// CHECK: analysis-equivalent-mod: true
// CHECK: analysis-defined: true
// CHECK: analysis-integer-valued: true
// CHECK: analysis-divisible: true
// CHECK: analysis-congruent: true
// CHECK: analysis-xor-cancellation: true
// CHECK: analysis-compound-check: true
// CHECK: analysis-exact-divide: proven
// CHECK: analysis-known-zero-low2: 3
// CHECK: analysis-symbol-congruence: 4,0
// CHECK: analysis-range-lower: 0
// CHECK: analysis-range-upper: 961
// CHECK: analysis-constant-difference: 4
// CHECK: analysis-split-constant: 5
// CHECK: analysis-wrapper-xor-cancellation: true
// CHECK: analysis-wrapper-compound-check: true
// CHECK: analysis-simplified-mod: 0
// CHECK: analysis-exact-quotient: 1/4*x
// CHECK: analysis-affine-coefficient: 3
// CHECK: analysis-affine-residual: 5
// CHECK: analysis-finite-difference: 4
// CHECK: analysis-nonlinear-difference: 16 + 8*x
// CHECK: analysis-split-residual: 3*x
// CHECK: analysis-derived-lower: 5
// CHECK: analysis-derived-upper: 9
// CHECK: analysis-substituted-upper: 31
// CHECK: analysis-substituted-congruence: true
// CHECK: analysis-or-factory-rejected: true
// CHECK: analysis-partial-factory-rejected: true
// CHECK: analysis-or-mutator-rejected: true
// CHECK: analysis-poisoned-query: unknown
// CHECK: analysis-poisoned-expand: true
// CHECK: analysis-invalid-handle-rejected: true
// CHECK: analysis-invalid-handle-diagnostic: expected non-null wave.pred

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
// feeds `ixs_range`; `4*x+1` then ranges over [1, 125].
// CHECK: x-nonneg: true
// CHECK: range-lower: 1
// CHECK: range-upper: 125
// CHECK: range-u32-upper: 125
// CHECK: fits-tight: true
// CHECK: fits-loose: true
// CHECK: overflows-upper: false
// CHECK: no-assumptions: false
// CHECK: pow2-unknown: unknown
// CHECK: pow2-or-zero: or-zero
// CHECK: pow2-positive: positive
// CHECK: defined-safe-div: true
// CHECK: defined-literal-denominator: true
// CHECK: defined-partial-div: false
// CHECK: defined-uncovered-piecewise: false
// CHECK: defined-mod-negative: false
// CHECK: defined-mod-positive: true
