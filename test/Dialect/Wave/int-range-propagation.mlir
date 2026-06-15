// RUN: wave-opt --int-range-optimizations %s | FileCheck %s
// RUN: wave-opt --int-range-optimizations %s | wave-opt | FileCheck %s

// `wave.assume` + the InferIntRangeInterface implementations on
// `wave.binary addi` / `wave.binary muli` / `wave.binary shli` together let upstream
// `IntRangeAnalysis` see ranges flow through the wave-arith layer.
// `int-range-optimizations` consumes that range info; a comparison
// whose result is provably constant collapses to `arith.constant`.

// CHECK-LABEL: func.func @addi_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @addi_propagation(%v: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 10">] : i32
  %sum = wave.binary addi %a, %a : i32, i32 -> i32    // proves to [0, 20]
  %hundred = arith.constant 100 : i32
  %cmp = arith.cmpi slt, %sum, %hundred : i32  // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @one_sided_lower_assume_range
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @one_sided_lower_assume_range(%v: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">] : i32
  %zero = arith.constant 0 : i32
  %cmp = arith.cmpi sge, %a, %zero : i32
  return %cmp : i1
}

// CHECK-LABEL: func.func @one_sided_upper_assume_range
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @one_sided_upper_assume_range(%v: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x <= 10">] : i32
  %limit = arith.constant 11 : i32
  %cmp = arith.cmpi slt, %a, %limit : i32
  return %cmp : i1
}

// CHECK-LABEL: func.func @chained_assume_range
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @chained_assume_range(%v: i32) -> i1 {
  %lo = wave.assume %v as "x" [#wave.pred<"x >= 0">] : i32
  %bounded = wave.assume %lo as "x" [#wave.pred<"-2147483647 + x <= 0">] : i32
  %zero = arith.constant 0 : i32
  %cmp = arith.cmpi sge, %bounded, %zero : i32
  return %cmp : i1
}

// CHECK-LABEL: func.func @muli_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @muli_propagation(%v: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 5">] : i32
  %prod = wave.binary muli %a, %a : i32, i32 -> i32   // proves to [0, 25]
  %hundred = arith.constant 100 : i32
  %cmp = arith.cmpi slt, %prod, %hundred : i32 // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @shli_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @shli_propagation(%v: i32, %s: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 5">] : i32
  %sh = wave.assume %s as "x" [#wave.pred<"x >= 2">, #wave.pred<"x <= 2">] : i32     // exactly 2
  %shifted = wave.binary shli %a, %sh : i32, i32 -> i32  // proves to [0, 20]
  %hundred = arith.constant 100 : i32
  %cmp = arith.cmpi slt, %shifted, %hundred : i32 // always true
  return %cmp : i1
}

// Combined chain: addi then muli then comparison. The bound flows
// across multiple wave-arith hops.
// CHECK-LABEL: func.func @chain_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @chain_propagation(%v: i32, %w: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 3">] : i32
  %b = wave.assume %w as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 3">] : i32
  %sum = wave.binary addi %a, %b : i32, i32 -> i32        // [0, 6]
  %prod = wave.binary muli %sum, %sum : i32, i32 -> i32   // [0, 36]
  %fifty = arith.constant 50 : i32
  %cmp = arith.cmpi slt, %prod, %fifty : i32       // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @index_assume
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @index_assume(%v: index) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 10">] : index
  %hundred = arith.constant 100 : index
  %cmp = arith.cmpi slt, %a, %hundred : index
  return %cmp : i1
}

// CHECK-LABEL: func.func @index_expr_range
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @index_expr_range(%v: i32) -> i1 {
  %a = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 10">] : i32
  %off = wave.index_expr <"1 + 4*x"> ["x"](%a) : (i32) -> index
  %limit = arith.constant 42 : index
  %cmp = arith.cmpi slt, %off, %limit : index  // [1, 41] < 42
  return %cmp : i1
}

// CHECK-LABEL: func.func @index_expr_simd_no_crash
// CHECK: wave.index_expr
// CHECK: return
func.func @index_expr_simd_no_crash() -> !wave.simd<index, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1 + 2*lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// Id-op range seeds: workgroup_id contributes [0, INT32_MAX] without
// any `wave.assume`. The lower bound alone is enough for the
// non-negativity check to fold.
// CHECK-LABEL: func.func @workgroup_id_nonneg
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @workgroup_id_nonneg() -> i1 {
  %wg = wave.workgroup_id 0
  %zero = arith.constant 0 : i32
  %cmp = arith.cmpi sge, %wg, %zero : i32          // always true
  return %cmp : i1
}

// Upper bound also propagates: workgroup_id <= INT32_MAX.
// CHECK-LABEL: func.func @workgroup_id_bounded
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @workgroup_id_bounded() -> i1 {
  %wg = wave.workgroup_id 1
  %big = arith.constant 2147483647 : i32           // INT32_MAX
  %cmp = arith.cmpi sle, %wg, %big : i32           // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @read_first_range
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @read_first_range() -> i1 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %first = wave.read_first %lane : !wave.simd<i32, 32> -> i32
  %limit = arith.constant 64 : i32
  %cmp = arith.cmpi slt, %first, %limit : i32
  return %cmp : i1
}

// SIMD chains: the wave-arith ops normalize incoming arg ranges to
// the result's element bit-width before forwarding to the upstream
// helpers, so a `wave.lane_id`-seeded `[0, W-1]` range happily flows
// through `wave.binary addi` even when the other operand's lattice is at
// upstream-side width 0 (SIMD entry state). int-range-optimizations
// can't fold a SIMD-typed result to a constant -- nothing visible to
// CHECK for -- but the pass must not crash.
// CHECK-LABEL: func.func @simd_chain_no_crash
// CHECK: wave.lane_id
// CHECK: wave.binary addi
// CHECK: return
func.func @simd_chain_no_crash(%v: !wave.simd<i32, 32>)
    -> !wave.simd<i32, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %sum = wave.binary addi %lane, %v
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %sum : !wave.simd<i32, 32>
}
