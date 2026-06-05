// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @wave_ops
func.func @wave_ops(%pred: i1, %value: i32, %out: !wave.ptr<#wave.global, i32>) -> i32 {
  // CHECK: wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.splat
  %vvalue = wave.splat %value : i32 -> !wave.simd<i32, 32>
  // CHECK: wave.binary addi
  %sum = wave.binary addi %lane, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
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
  // CHECK: wave.select {{.*}} : i32
  %selected = wave.select %pred, %value, %first : i32
  // CHECK: wave.select {{.*}} : !wave.simd<i32, 32>
  %whole_simd = wave.select %pred, %sum, %vvalue : !wave.simd<i32, 32>
  // CHECK: wave.select {{.*}} : !wave.mask<32>, !wave.simd<i32, 32>
  %lane_select = wave.select %mask, %sum, %vvalue : !wave.mask<32>, !wave.simd<i32, 32>
  // CHECK: wave.select {{.*}} : !wave.mask<32>, !wave.mask<32>
  %mask_select = wave.select %mask, %mask, %mask : !wave.mask<32>, !wave.mask<32>
  // CHECK: wave.store
  %tok = wave.store %sum -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token

  // CHECK: wave.load {{.*}} : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ld, %ld_tok = wave.load %out : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.ptr<#wave.global, i32>, !wave.mem.token) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %ld8, %ld8_tok = wave.load %out after %ld_tok : (!wave.ptr<#wave.global, i32>, !wave.mem.token) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)

  // CHECK: wave.where
  wave.where %mask {
    wave.yield
  } otherwise {
    wave.yield
  } : !wave.mask<32>

  // CHECK: [[WHERE:%.*]]:2 = wave.where
  %where_sum, %where_tok = wave.where %mask {
    %inc = wave.binary addi %sum, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield %inc, %ld_tok : !wave.simd<i32, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<i32, 32>, !wave.mem.token
  // CHECK: wave.store [[WHERE]]#0
  %where_store = wave.store %where_sum -> %out after %where_tok : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>, !wave.mem.token) -> !wave.mem.token

  func.return %first : i32
}

// CHECK-LABEL: func.func @wave_vector_memory_payloads
func.func @wave_vector_memory_payloads(%p8: !wave.ptr<#wave.global, i8>,
                                       %p16: !wave.ptr<#wave.global, i16>,
                                       %pbf16: !wave.ptr<#wave.global, bf16>,
                                       %pf32: !wave.ptr<#wave.global, f32>) {
  // CHECK: wave.load {{.*}} : (!wave.ptr<#wave.global, i8>) -> (!wave.simd<vector<2xi8>, 32>, !wave.mem.token)
  %i8x2, %t0 = wave.load %p8
      : (!wave.ptr<#wave.global, i8>)
      -> (!wave.simd<vector<2xi8>, 32>, !wave.mem.token)
  // CHECK: wave.store {{.*}} : (!wave.simd<vector<2xi8>, 32>, !wave.ptr<#wave.global, i8>, !wave.mem.token) -> !wave.mem.token
  %t1 = wave.store %i8x2 -> %p8 after %t0
      : (!wave.simd<vector<2xi8>, 32>, !wave.ptr<#wave.global, i8>,
         !wave.mem.token)
      -> !wave.mem.token

  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.ptr<#wave.global, i16>, !wave.mem.token) -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  %i16x4, %t2 = wave.load %p16 after %t1
      : (!wave.ptr<#wave.global, i16>, !wave.mem.token)
      -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  // CHECK: wave.store {{.*}} : (!wave.simd<vector<4xi16>, 32>, !wave.ptr<#wave.global, i16>, !wave.mem.token) -> !wave.mem.token
  %t3 = wave.store %i16x4 -> %p16 after %t2
      : (!wave.simd<vector<4xi16>, 32>, !wave.ptr<#wave.global, i16>,
         !wave.mem.token)
      -> !wave.mem.token

  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.ptr<#wave.global, bf16>, !wave.mem.token) -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  %bf16x2, %t4 = wave.load %pbf16 after %t3
      : (!wave.ptr<#wave.global, bf16>, !wave.mem.token)
      -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  // CHECK: wave.store {{.*}} : (!wave.simd<vector<2xbf16>, 32>, !wave.ptr<#wave.global, bf16>, !wave.mem.token) -> !wave.mem.token
  %t5 = wave.store %bf16x2 -> %pbf16 after %t4
      : (!wave.simd<vector<2xbf16>, 32>, !wave.ptr<#wave.global, bf16>,
         !wave.mem.token)
      -> !wave.mem.token

  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.ptr<#wave.global, f32>, !wave.mem.token) -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  %f32x2, %t6 = wave.load %pf32 after %t5
      : (!wave.ptr<#wave.global, f32>, !wave.mem.token)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  // CHECK: wave.store {{.*}} : (!wave.simd<vector<2xf32>, 32>, !wave.ptr<#wave.global, f32>, !wave.mem.token) -> !wave.mem.token
  %t7 = wave.store %f32x2 -> %pf32 after %t6
      : (!wave.simd<vector<2xf32>, 32>, !wave.ptr<#wave.global, f32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @wave_opaque_pointers
func.func @wave_opaque_pointers(%raw: !wave.ptr<#wave.global>, %x: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.ptr_add {{.*}} : !wave.ptr<#wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global>, 32>
  %ptrs = wave.ptr_add %raw, %lane
      : !wave.ptr<#wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: wave.store {{.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global>, 32>) -> !wave.mem.token
  %t0 = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global>, 32>)
      -> !wave.mem.token
  // CHECK: wave.load {{.*}} after {{.*}} : (!wave.simd<!wave.ptr<#wave.global>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %loaded, %t1 = wave.load %ptrs after %t0
      : (!wave.simd<!wave.ptr<#wave.global>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// CHECK-LABEL: func.func @wave_int_arith
func.func @wave_int_arith(%uA: i32, %uB: i32, %vA: !wave.simd<i32, 32>, %vB: !wave.simd<i32, 32>) {
  // Uniform-uniform: result is the bare iN.
  // CHECK: wave.binary addi {{.*}} : i32, i32 -> i32
  %0 = wave.binary addi %uA, %uB : i32, i32 -> i32
  // CHECK: wave.binary muli {{.*}} : i32, i32 -> i32
  %1 = wave.binary muli %uA, %uB : i32, i32 -> i32
  // CHECK: wave.binary shli {{.*}} : i32, i32 -> i32
  %2 = wave.binary shli %uA, %uB : i32, i32 -> i32

  // SIMD-SIMD: result is SIMD<iN, W>.
  // CHECK: wave.binary addi {{.*}} : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %3 = wave.binary addi %vA, %vB : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>

  // Mixed: SIMD operand pins the result width.
  // CHECK: wave.binary addi {{.*}} : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %4 = wave.binary addi %uA, %vA : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.binary muli {{.*}} : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %5 = wave.binary muli %vA, %uA : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>

  // i64 surface is type-system legal even though lowering rejects it.
  %u64a = arith.constant 1 : i64
  %u64b = arith.constant 2 : i64
  // CHECK: wave.binary addi {{.*}} : i64, i64 -> i64
  %6 = wave.binary addi %u64a, %u64b : i64, i64 -> i64

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
  // CHECK: [[FMA:%.*]] = wave.fma [[MUL]], [[ADD]], [[MAX]] : !wave.simd<f32, 32>, !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %fma = wave.fma %mul, %add, %max : !wave.simd<f32, 32>, !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[EXP:%.*]] = wave.fexp2 [[FMA]] : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %exp = wave.fexp2 %fma : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[RCP:%.*]] = wave.frcp [[EXP]] : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %rcp = wave.frcp %exp : !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  func.return %rcp : !wave.simd<f32, 32>
}

// CHECK-LABEL: func.func @wave_packed_f16_ops
// CHECK-SAME: ([[A:%.*]]: !wave.simd<vector<2xf16>, 32>, [[B:%.*]]: !wave.simd<vector<2xf16>, 32>, [[C:%.*]]: !wave.simd<vector<2xf16>, 32>)
func.func @wave_packed_f16_ops(%a: !wave.simd<vector<2xf16>, 32>,
                               %b: !wave.simd<vector<2xf16>, 32>,
                               %c: !wave.simd<vector<2xf16>, 32>)
    -> !wave.simd<vector<2xf16>, 32> {
  // CHECK: [[ADD:%.*]] = wave.fadd [[A]], [[B]] : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  %add = wave.fadd %a, %b : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: [[MUL:%.*]] = wave.fmul [[ADD]], [[C]] : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  %mul = wave.fmul %add, %c : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: [[MAX:%.*]] = wave.fmax [[MUL]], [[ADD]] : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  %max = wave.fmax %mul, %add : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: [[FMA:%.*]] = wave.fma [[ADD]], [[MUL]], [[MAX]] : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  %fma = wave.fma %add, %mul, %max : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  func.return %fma : !wave.simd<vector<2xf16>, 32>
}

// CHECK-LABEL: func.func @wave_cast_ops
// CHECK-SAME: ([[VF32:%.*]]: !wave.simd<f32, 32>, [[VF16:%.*]]: !wave.simd<f16, 32>, [[VI32:%.*]]: !wave.simd<i32, 32>, [[VI16:%.*]]: !wave.simd<i16, 32>,
// CHECK-SAME: [[SF32:%.*]]: f32)
func.func @wave_cast_ops(%vf32: !wave.simd<f32, 32>, %vf16: !wave.simd<f16, 32>,
                         %vi32: !wave.simd<i32, 32>, %vi16: !wave.simd<i16, 32>,
                         %sf32: f32) {
  // CHECK: [[FPCVT:%.*]] = wave.cast fpconvert [[VF32]] policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %fp = wave.cast fpconvert %vf32 policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  // CHECK: [[ICVT:%.*]] = wave.cast intconvert [[VI16]] policy {extension = #wave.cast_extension<sign>} : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  %int = wave.cast intconvert %vi16 policy {extension = #wave.cast_extension<sign>} : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  // CHECK: [[ICVTZ:%.*]] = wave.cast intconvert [[VI16]] policy {extension = #wave.cast_extension<zero>} : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  %int_zero = wave.cast intconvert %vi16 policy {extension = #wave.cast_extension<zero>} : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  // CHECK: [[ITOF:%.*]] = wave.cast int_to_fp [[VI32]] policy {rounding = #wave.cast_rounding<rtz>, signedness = #wave.cast_signedness<unsigned>} : !wave.simd<i32, 32> -> !wave.simd<f32, 32>
  %itof = wave.cast int_to_fp %vi32 policy {rounding = #wave.cast_rounding<rtz>, signedness = #wave.cast_signedness<unsigned>} : !wave.simd<i32, 32> -> !wave.simd<f32, 32>
  // CHECK: [[FTOI:%.*]] = wave.cast fp_to_int [[VF16]] policy {signedness = #wave.cast_signedness<signed>} : !wave.simd<f16, 32> -> !wave.simd<i32, 32>
  %ftoi = wave.cast fp_to_int %vf16 policy {signedness = #wave.cast_signedness<signed>} : !wave.simd<f16, 32> -> !wave.simd<i32, 32>
  // CHECK: [[SFP:%.*]] = wave.cast fpconvert [[SF32]] policy {rounding = #wave.cast_rounding<rtp>} : f32 -> f16
  %scalar_fp = wave.cast fpconvert %sf32 policy {rounding = #wave.cast_rounding<rtp>} : f32 -> f16
  // CHECK: [[SFPD:%.*]] = wave.cast fpconvert [[SF32]] policy {rounding = #wave.cast_rounding<rtn>} : f32 -> f16
  %scalar_fp_down = wave.cast fpconvert %sf32 policy {rounding = #wave.cast_rounding<rtn>} : f32 -> f16
  func.return
}

// CHECK-LABEL: func.func @wave_ptr_cast_ops
// CHECK-SAME: ([[PTR:%.*]]: !wave.ptr<#wave.global, f32>, [[VPTR:%.*]]: !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
func.func @wave_ptr_cast_ops(%ptr: !wave.ptr<#wave.global, f32>,
                             %vptr: !wave.simd<!wave.ptr<#wave.global, f32>, 32>) {
  // CHECK: [[VEC_PTR:%.*]] = wave.ptr_cast [[PTR]] : !wave.ptr<#wave.global, f32> -> !wave.ptr<#wave.global, vector<8xf32>>
  %vec_ptr = wave.ptr_cast %ptr : !wave.ptr<#wave.global, f32> -> !wave.ptr<#wave.global, vector<8xf32>>
  // CHECK: [[SIMD_VEC_PTR:%.*]] = wave.ptr_cast [[VPTR]] : !wave.simd<!wave.ptr<#wave.global, f32>, 32> -> !wave.simd<!wave.ptr<#wave.global, vector<8xf32>>, 32>
  %simd_vec_ptr = wave.ptr_cast %vptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32> -> !wave.simd<!wave.ptr<#wave.global, vector<8xf32>>, 32>
  func.return
}

// CHECK-LABEL: func.func @wave_packed_cast_ops
// CHECK-SAME: ([[VF32:%.*]]: !wave.simd<vector<2xf32>, 32>, [[VF16:%.*]]: !wave.simd<vector<2xf16>, 32>)
func.func @wave_packed_cast_ops(%vf32: !wave.simd<vector<2xf32>, 32>,
                                %vf16: !wave.simd<vector<2xf16>, 32>) {
  // CHECK: [[DOWN:%.*]] = wave.cast fpconvert [[VF32]] policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  %down = wave.cast fpconvert %vf32 policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: [[UP:%.*]] = wave.cast fpconvert [[VF16]] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf32>, 32>
  %up = wave.cast fpconvert %vf16 : !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf32>, 32>
  func.return
}

// CHECK-LABEL: func.func @wave_pack_extract_ops
// CHECK-SAME: ([[A:%.*]]: f16, [[B:%.*]]: f16, [[C:%.*]]: f16, [[VA:%.*]]: !wave.simd<f16, 32>, [[VB:%.*]]: !wave.simd<f16, 32>)
func.func @wave_pack_extract_ops(%a: f16, %b: f16, %c: f16,
                                 %va: !wave.simd<f16, 32>,
                                 %vb: !wave.simd<f16, 32>)
    -> (vector<3xf16>, f16, !wave.simd<vector<2xf16>, 32>,
        !wave.simd<f16, 32>) {
  // CHECK: [[PACK:%.*]] = wave.pack [[A]], [[B]], [[C]] : f16, f16, f16 -> vector<3xf16>
  %pack = wave.pack %a, %b, %c : f16, f16, f16 -> vector<3xf16>
  // CHECK: [[EXTRACT:%.*]] = wave.extract [[PACK]][2] : vector<3xf16> -> f16
  %extract = wave.extract %pack[2] : vector<3xf16> -> f16
  // CHECK: [[VPACK:%.*]] = wave.pack [[VA]], [[VB]] : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 32>
  %vpack = wave.pack %va, %vb : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: [[VEXTRACT:%.*]] = wave.extract [[VPACK]][1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  %vextract = wave.extract %vpack[1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  func.return %pack, %extract, %vpack, %vextract
      : vector<3xf16>, f16, !wave.simd<vector<2xf16>, 32>,
        !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @wave_assume
func.func @wave_assume(%u32: i32, %u64: i64,
                       %idx: index, %v: !wave.simd<i32, 32>,
                       %vidx: !wave.simd<index, 32>) {
  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : i32
  %u32_bounded = wave.assume %u32 as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32

  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : i64
  %i64_bounded = wave.assume %u64 as "x" [#wave.pred<"x >= -128">, #wave.pred<"x <= 127">] : i64

  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : index
  %idx0 = wave.assume %idx as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : index

  // SIMD operand: per-lane assertion. Interface stays dormant on this
  // path (upstream IntRangeAnalysis is scalar-only), but the op
  // round-trips and the attribute is readable by symbolic-engine
  // consumers.
  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : !wave.simd<i32, 32>
  %simd_bounded = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>

  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : !wave.simd<index, 32>
  %vidx0 = wave.assume %vidx as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<index, 32>

  // Empty range (lo > hi) is legal -- signals an unreachable branch.
  // CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : i32
  %empty = wave.assume %u32 as "x" [#wave.pred<"x >= 10">, #wave.pred<"x <= 5">] : i32

  // CHECK: wave.assume {{.*}} as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
  %divisible = wave.assume %u32 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32

  func.return
}

// CHECK-LABEL: func.func @wave_index_expr
func.func @wave_index_expr(%lane: !wave.simd<i32, 32>,
                           %k: i32,
                           %wgid: i32,
                           %buffer: !wave.ptr<#wave.global, i32>) {
  // Uniform-only bindings collapse to index (no width).
  // CHECK: wave.index_expr <"K + wgid_y"> ["K", "wgid_y"](%{{.*}}, %{{.*}}) : (i32, i32) -> index
  %u = wave.index_expr #wave.expr<"K + wgid_y"> ["K", "wgid_y"] (%k, %wgid) : (i32, i32) -> index

  // Lane-varying binding pins the result to !wave.simd<index, 32>. The printer
  // emits the ixsimpl canonical form of the expr text (terms reordered).
  // CHECK: wave.index_expr <"K + 4*lid"> ["K", "lid"](%{{.*}}, %{{.*}}) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %v = wave.index_expr #wave.expr<"4*lid + K"> ["K", "lid"] (%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>

  // CHECK: wave.index_expr <"xor(31, lid)"> ["lid"](%{{.*}}) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %x = wave.index_expr #wave.expr<"xor(lid, 31)"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>

  // Constant expression: zero bindings.
  // CHECK: wave.index_expr <"42"> []() : () -> index
  %c = wave.index_expr #wave.expr<"42"> [] () : () -> index

  // The lane-varying index feeds straight into ptr_add as the offset.
  // CHECK: wave.ptr_add {{.*}} : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %ptrs = wave.ptr_add %buffer, %v : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>

  func.return
}

// CHECK-LABEL: func.func @wave_index_expr_index_shaped
func.func @wave_index_expr_index_shaped(%lane_i32: !wave.simd<i32, 32>,
                                        %lane_idx: !wave.simd<index, 32>,
                                        %k: index,
                                        %buffer: !wave.ptr<#wave.global, i32>) {
  // CHECK: wave.index_expr <"K"> ["K"](%{{.*}}) : (index) -> index
  %u = wave.index_expr #wave.expr<"K"> ["K"] (%k) : (index) -> index

  // CHECK: wave.index_expr <"K + lid"> ["K", "lid"](%{{.*}}, %{{.*}}) : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %v = wave.index_expr #wave.expr<"K + lid"> ["K", "lid"] (%k, %lane_i32) : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>

  // CHECK: wave.index_expr <"idx"> ["idx"](%{{.*}}) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %w = wave.index_expr #wave.expr<"idx"> ["idx"] (%lane_idx) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>

  // CHECK: wave.ptr_add {{.*}} : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %ptrs = wave.ptr_add %buffer, %v : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>

  func.return
}
