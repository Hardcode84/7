// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @wave_ops
func.func @wave_ops(%pred: i1, %value: i32, %out: !wave.ptr<i32, #wave.global>) -> i32 {
  // CHECK: wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.splat
  %vvalue = wave.splat %value : i32 -> !wave.simd<i32, 32>
  // CHECK: wave.addi
  %sum = wave.addi %lane, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.cmpi
  %mask = wave.cmpi ult %lane, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: wave.subgroup_id
  %subgroup = wave.subgroup_id
  // CHECK: wave.subgroup_size
  %size = wave.subgroup_size
  // CHECK: wave.workgroup_id 0
  %wg_x = wave.workgroup_id 0
  // CHECK: wave.workgroup_id 1
  %wg_y = wave.workgroup_id 1
  // CHECK: wave.workgroup_id 2
  %wg_z = wave.workgroup_id 2
  // CHECK: wave.workitem_id 0 : !wave.simd<i32, 32>
  %wi_x = wave.workitem_id 0 : !wave.simd<i32, 32>
  // CHECK: wave.ballot {{.*}} : !wave.mask<32> -> i32
  %bits = wave.ballot %mask : !wave.mask<32> -> i32
  // CHECK: wave.read_first {{.*}} : !wave.simd<i32, 32> -> i32
  %first = wave.read_first %sum : !wave.simd<i32, 32> -> i32
  // CHECK: wave.store
  %tok = wave.store %sum -> %out : (!wave.simd<i32, 32>, !wave.ptr<i32, #wave.global>) -> !wave.mem.token

  // CHECK: wave.load {{.*}} : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ld, %ld_tok = wave.load %out : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.ptr<i32, #wave.global>, !wave.mem.token) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %ld8, %ld8_tok = wave.load %out after %ld_tok : (!wave.ptr<i32, #wave.global>, !wave.mem.token) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)

  // CHECK: wave.where
  wave.where %mask {
    wave.yield
  } otherwise {
    wave.yield
  } : !wave.mask<32>

  func.return %first : i32
}

// CHECK-LABEL: func.func @wave_int_arith
func.func @wave_int_arith(%uA: i32, %uB: i32, %vA: !wave.simd<i32, 32>, %vB: !wave.simd<i32, 32>) {
  // Uniform-uniform: result is the bare iN.
  // CHECK: wave.addi {{.*}} : i32, i32 -> i32
  %0 = wave.addi %uA, %uB : i32, i32 -> i32
  // CHECK: wave.muli {{.*}} : i32, i32 -> i32
  %1 = wave.muli %uA, %uB : i32, i32 -> i32
  // CHECK: wave.shli {{.*}} : i32, i32 -> i32
  %2 = wave.shli %uA, %uB : i32, i32 -> i32

  // SIMD-SIMD: result is SIMD<iN, W>.
  // CHECK: wave.addi {{.*}} : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %3 = wave.addi %vA, %vB : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>

  // Mixed: SIMD operand pins the result width.
  // CHECK: wave.addi {{.*}} : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %4 = wave.addi %uA, %vA : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.muli {{.*}} : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %5 = wave.muli %vA, %uA : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>

  // i64 surface is type-system legal even though lowering rejects it.
  %u64a = arith.constant 1 : i64
  %u64b = arith.constant 2 : i64
  // CHECK: wave.addi {{.*}} : i64, i64 -> i64
  %6 = wave.addi %u64a, %u64b : i64, i64 -> i64

  func.return
}

// CHECK-LABEL: func.func @wave_f32_ops
// CHECK-SAME: ([[A:%.*]]: !wave.simd<f32, 32>, [[B:%.*]]: !wave.simd<f32, 32>)
func.func @wave_f32_ops(%a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>) -> !wave.simd<f32, 32> {
  // CHECK: [[ADD:%.*]] = wave.fadd [[A]], [[B]] : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %add = wave.fadd %a, %b : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[SUB:%.*]] = wave.fsub [[ADD]], [[B]] : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %sub = wave.fsub %add, %b : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[MUL:%.*]] = wave.fmul [[SUB]], [[A]] : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %mul = wave.fmul %sub, %a : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[MAX:%.*]] = wave.fmax [[MUL]], [[ADD]] : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %max = wave.fmax %mul, %add : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[EXP:%.*]] = wave.fexp2 [[MAX]] : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %exp = wave.fexp2 %max : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[RCP:%.*]] = wave.frcp [[EXP]] : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %rcp = wave.frcp %exp : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  func.return %rcp : !wave.simd<f32, 32>
}

// CHECK-LABEL: func.func @wave_cast_ops
// CHECK-SAME: ([[VF32:%.*]]: !wave.simd<f32, 32>, [[VF16:%.*]]: !wave.simd<f16, 32>, [[VI32:%.*]]: !wave.simd<i32, 32>, [[VI16:%.*]]: !wave.simd<i16, 32>,
// CHECK-SAME: [[SF32:%.*]]: f32)
func.func @wave_cast_ops(%vf32: !wave.simd<f32, 32>, %vf16: !wave.simd<f16, 32>,
                         %vi32: !wave.simd<i32, 32>, %vi16: !wave.simd<i16, 32>,
                         %sf32: f32) {
  // CHECK: [[FPCVT:%.*]] = wave.cast fpconvert [[VF32]] : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %fp = wave.cast fpconvert %vf32 : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  // CHECK: [[ICVT:%.*]] = wave.cast intconvert [[VI16]] : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  %int = wave.cast intconvert %vi16 : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  // CHECK: [[ITOF:%.*]] = wave.cast int_to_fp [[VI32]] : !wave.simd<i32, 32> -> !wave.simd<f32, 32>
  %itof = wave.cast int_to_fp %vi32 : !wave.simd<i32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[FTOI:%.*]] = wave.cast fp_to_int [[VF16]] : !wave.simd<f16, 32> -> !wave.simd<i32, 32>
  %ftoi = wave.cast fp_to_int %vf16 : !wave.simd<f16, 32> -> !wave.simd<i32, 32>
  // CHECK: [[SFP:%.*]] = wave.cast fpconvert [[SF32]] : f32 -> f16
  %scalar_fp = wave.cast fpconvert %sf32 : f32 -> f16
  func.return
}

// CHECK-LABEL: func.func @wave_assume_range
func.func @wave_assume_range(%u32: i32, %u64: i64,
                             %v: !wave.simd<i32, 32>) {
  // CHECK: wave.assume_range {{.*}}, [0, 31] : i32
  %0 = wave.assume_range %u32, [0, 31] : i32

  // CHECK: wave.assume_range {{.*}}, [-128, 127] : i64
  %1 = wave.assume_range %u64, [-128, 127] : i64

  // SIMD operand: per-lane assertion. Interface stays dormant on this
  // path (upstream IntRangeAnalysis is scalar-only), but the op
  // round-trips and the attribute is readable by symbolic-engine
  // consumers.
  // CHECK: wave.assume_range {{.*}}, [0, 31] : !wave.simd<i32, 32>
  %2 = wave.assume_range %v, [0, 31] : !wave.simd<i32, 32>

  // Empty range (lo > hi) is legal -- signals an unreachable branch.
  // CHECK: wave.assume_range {{.*}}, [10, 5] : i32
  %3 = wave.assume_range %u32, [10, 5] : i32

  func.return
}

// CHECK-LABEL: func.func @wave_index_expr
func.func @wave_index_expr(%lane: !wave.simd<i32, 32>,
                           %k: i32,
                           %wgid: i32,
                           %buffer: !wave.ptr<i32, #wave.global>) {
  // Uniform-only bindings collapse to !wave.index (no width).
  // CHECK: wave.index_expr <"K + wgid_y"> ["K", "wgid_y"](%{{.*}}, %{{.*}}) : (i32, i32) -> !wave.index
  %u = wave.index_expr #wave.expr<"K + wgid_y"> ["K", "wgid_y"] (%k, %wgid) : (i32, i32) -> !wave.index

  // Lane-varying binding pins the result to !wave.index<32>. The printer
  // emits the ixsimpl canonical form of the expr text (terms reordered).
  // CHECK: wave.index_expr <"K + 4*lid"> ["K", "lid"](%{{.*}}, %{{.*}}) : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
  %v = wave.index_expr #wave.expr<"4*lid + K"> ["K", "lid"] (%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.index<32>

  // Constant expression: zero bindings.
  // CHECK: wave.index_expr <"42"> []() : () -> !wave.index
  %c = wave.index_expr #wave.expr<"42"> [] () : () -> !wave.index

  // The lane-varying index feeds straight into ptr_add as the offset.
  // CHECK: wave.ptr_add {{.*}} : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %ptrs = wave.ptr_add %buffer, %v : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>

  func.return
}
