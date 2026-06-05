// RUN: wavec %S/../../wavec/test/e2e/good/integer_index_ops.wave | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @integer_index_ops
// CHECK: wave.binary ori
// CHECK: wave.binary divui
// CHECK: wave.binary remui
// CHECK: wave.binary andi
// CHECK: wave.binary subi
// CHECK-NOT: wave.binary shrsi
// CHECK: wave.binary shrui
// CHECK: wave.binary xori
// CHECK-NOT: wave.binary shrsi
// CHECK: arith.index_castui
// CHECK: scf.for
// CHECK: wave.store
