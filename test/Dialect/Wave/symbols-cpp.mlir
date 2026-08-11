// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: wave-symbols-test | FileCheck %s

// CHECK: int: -42
// CHECK: unit-rat: 7
// CHECK: non-unit-rat: none
// CHECK: symbol: none

// Expansion and u32 range wrappers stay behind WaveSymbols.
// CHECK: expanded-product: 2 + 3*x + x**2
// CHECK: endpoint-floor: -2
// CHECK: endpoint-ceil: -1
// CHECK: endpoint-invalid: none
// CHECK: endpoint-compare-wide: -1
// CHECK: fits-u32: true
// CHECK: fits-u32-unbounded: false
// CHECK: fits-u32-compound: true
// CHECK: sentinel-expr-invalid: true
// CHECK: sentinel-expr-neg-propagates: true
// CHECK: sentinel-expr-add-propagates: true
// CHECK: sentinel-expr-simplify-propagates: true
// CHECK: sentinel-analysis-add-propagates: true
// CHECK: sentinel-analysis-simplify-propagates: true
// CHECK: sentinel-analysis-batch-propagates: true
// CHECK: sentinel-expr-expand-propagates: true
// CHECK: sentinel-pred-invalid: true
// CHECK: sentinel-pred-not-propagates: true

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
// CHECK: view-trunc-kind: trunc
// CHECK: view-trunc-arg-kind: mul
// CHECK: view-mod-lhs-kind: mul
// CHECK: view-mod-rhs: 5
// CHECK: view-and-kind: and
// CHECK: view-and-args: 3
// CHECK: view-or-kind: or
// CHECK: view-or-args: 3
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
// CHECK: analysis-range-upper: 784
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
// CHECK: analysis-substituted-upper: 28
// CHECK: analysis-substituted-congruence: true
// CHECK: analysis-batch-mutator-joint-success: true
// CHECK: analysis-query-cache-assume-invalidated: true
// CHECK: analysis-query-cache-substitute-invalidated: true
// CHECK: analysis-query-cache-range-invalidated: true
// CHECK: analysis-query-cache-batch-assume-invalidated: true
// CHECK: analysis-query-cache-derive-invalidated: true
// CHECK: analysis-direct-batch-closure: unknown
// CHECK: analysis-create-batch-closure: true
// CHECK: analysis-assume-batch-closure: true
// CHECK: analysis-ordered-grid-equivalent: true
// CHECK: analysis-or-factory-rejected: true
// CHECK: analysis-partial-factory-rejected: true
// CHECK: analysis-or-mutator-rejected: true
// CHECK: analysis-poisoned-query: unknown
// CHECK: analysis-poisoned-expand: true
// CHECK: analysis-singleton-simplified: floor(1/128*raw0)
// CHECK: analysis-singleton-source-cost: none
// CHECK: analysis-singleton-simplified-cost: 2
// CHECK: analysis-singleton-prefers-simplified: true
// CHECK: material-cost-rational: none
// CHECK: material-cost-nonpow2-floor: none
// CHECK: material-cost-wide-nonpow2-mod: none
// CHECK: material-cost-nonpow2-exact: none
// CHECK: material-cost-product-denominator-overflow: none
// CHECK: material-cost-piecewise: none
// CHECK: material-cost-pow2-floor: 2
// CHECK: material-cost-max-pow2-mod: 1

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
