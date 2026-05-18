// RUN: wave-opt --int-range-optimizations %s | FileCheck %s

// `wave.assume_range` + the InferIntRangeInterface implementations on
// `wave.addi` / `wave.muli` / `wave.shli` together let upstream
// `IntRangeAnalysis` see ranges flow through the wave-arith layer.
// `int-range-optimizations` consumes that range info; a comparison
// whose result is provably constant collapses to `arith.constant`.

// CHECK-LABEL: func.func @addi_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @addi_propagation(%v: i32) -> i1 {
  %a = wave.assume_range %v, [0, 10] : i32
  %sum = wave.addi %a, %a : i32, i32 -> i32    // proves to [0, 20]
  %hundred = arith.constant 100 : i32
  %cmp = arith.cmpi slt, %sum, %hundred : i32  // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @muli_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @muli_propagation(%v: i32) -> i1 {
  %a = wave.assume_range %v, [0, 5] : i32
  %prod = wave.muli %a, %a : i32, i32 -> i32   // proves to [0, 25]
  %hundred = arith.constant 100 : i32
  %cmp = arith.cmpi slt, %prod, %hundred : i32 // always true
  return %cmp : i1
}

// CHECK-LABEL: func.func @shli_propagation
// CHECK-NEXT: %[[T:.*]] = arith.constant true
// CHECK-NEXT: return %[[T]] : i1
func.func @shli_propagation(%v: i32, %s: i32) -> i1 {
  %a = wave.assume_range %v, [0, 5] : i32
  %sh = wave.assume_range %s, [2, 2] : i32     // exactly 2
  %shifted = wave.shli %a, %sh : i32, i32 -> i32  // proves to [0, 20]
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
  %a = wave.assume_range %v, [0, 3] : i32
  %b = wave.assume_range %w, [0, 3] : i32
  %sum = wave.addi %a, %b : i32, i32 -> i32        // [0, 6]
  %prod = wave.muli %sum, %sum : i32, i32 -> i32   // [0, 36]
  %fifty = arith.constant 50 : i32
  %cmp = arith.cmpi slt, %prod, %fifty : i32       // always true
  return %cmp : i1
}
