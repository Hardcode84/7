// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @bad_simd_constant_type() {
  // expected-error @+1 {{value type must match the result payload type}}
  %c = wave.constant 1 : i64 -> !wave.simd<i32, 32>
  return
}

// -----

func.func @bad_mask_constant_type() {
  // expected-error @+1 {{value type must match the result payload type}}
  %m = wave.constant 1 : i32 -> !wave.mask<32>
  return
}

// -----

func.func @bad_workgroup_axis() -> i32 {
  // expected-error @+1 {{axis must be 0 (x), 1 (y), or 2 (z)}}
  %x = wave.workgroup_id 3
  return %x : i32
}

// -----

func.func @bad_workitem_axis() {
  // expected-error @+1 {{axis must be 0 (x), 1 (y), or 2 (z)}}
  %x = wave.workitem_id 4 : !wave.simd<i32, 32>
  return
}

// -----

func.func @bad_workitem_element_type() {
  // expected-error @+1 {{result SIMD element type must be i32}}
  %x = wave.workitem_id 0 : !wave.simd<i64, 32>
  return
}

// -----

func.func @load_bad_ptr_simd_width(%p: !wave.simd<!wave.ptr<#wave.global, i32>, 64>) {
  // expected-error @+1 {{pointer SIMD width must match result SIMD width}}
  %v, %t = wave.load %p : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_scalar_width(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{per-lane payload must be a multiple of the pointer element bit width}}
  %v, %t = wave.load %p : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i16, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_vector_element(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{vector payload must be 16 bits or a multiple of 32 bits}}
  %v, %t = wave.load %p : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<vector<3xi16>, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_vector_i24_element(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{vector element type must be 4, 8, 16, or 32 bits wide}}
  %v, %t = wave.load %p : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<vector<4xi24>, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_scalar_i64(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{scalar payload element type must be 8, 16, or 32 bits wide}}
  %v, %t = wave.load %p : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i64, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_vector_i8_width(%p: !wave.ptr<#wave.global, i8>) {
  // expected-error @+1 {{vector payload must be 16 bits or a multiple of 32 bits}}
  %v, %t = wave.load %p : (!wave.ptr<#wave.global, i8>) -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_ptr_kind(%p: i64) {
  // expected-error @+1 {{expected wave pointer operand}}
  %v, %t = wave.load %p : (i64) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @assume_on_ptr(%p: !wave.ptr<#wave.global, i32>) -> !wave.ptr<#wave.global, i32> {
  // expected-error @+1 {{operand #0 must be signless integer or wave SIMD of signless integer}}
  %r = wave.assume %p as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 100">] : !wave.ptr<#wave.global, i32>
  return %r : !wave.ptr<#wave.global, i32>
}

// -----

func.func @assume_on_signed(%v: si32) -> si32 {
  // expected-error @+1 {{operand #0 must be signless integer or wave SIMD of signless integer}}
  %r = wave.assume %v as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 100">] : si32
  return %r : si32
}

// -----

func.func @assume_empty_name(%v: i32) -> i32 {
  // expected-error @+1 {{symbol name must be non-empty}}
  %r = wave.assume %v as "" [#wave.pred<"x >= 0">] : i32
  return %r : i32
}

// -----

func.func @assume_empty_predicates(%v: i32) -> i32 {
  // expected-error @+1 {{requires at least one predicate}}
  %r = wave.assume %v as "x" [] : i32
  return %r : i32
}

// -----

func.func @assume_undeclared_symbol(%v: i32) -> i32 {
  // expected-error @+1 {{references undeclared symbol `y`}}
  %r = wave.assume %v as "x" [#wave.pred<"y >= 0">] : i32
  return %r : i32
}

// -----

func.func @assume_or_predicate(%v: i32) -> i32 {
  // expected-error @+1 {{predicate #0 must be a comparison or AND of comparisons}}
  %r = wave.assume %v as "x" [#wave.pred<"x >= 0 | x <= 10">] : i32
  return %r : i32
}

// -----

func.func @where_yield_arity_mismatch(%mask: !wave.mask<32>, %v: !wave.simd<i32, 32>) {
  // expected-error @below {{then region yield operand count must match op result count}}
  %r = wave.where %mask {
    wave.yield
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @where_yield_type_mismatch(%mask: !wave.mask<32>, %v: !wave.simd<i64, 32>) {
  // expected-error @below {{then region yield operand #0 type '!wave.simd<i64, 32>' must match result type '!wave.simd<i32, 32>'}}
  %r = wave.where %mask {
    wave.yield %v : !wave.simd<i64, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @where_bad_terminator(%mask: !wave.mask<32>) {
  // expected-error @below {{then region must be terminated by wave.yield}}
  "wave.where"(%mask) ({
    "scf.yield"() : () -> ()
  }, {
    "wave.yield"() : () -> ()
  }) : (!wave.mask<32>) -> ()
  return
}

// -----

func.func @addi_width_mismatch(%a: i32, %b: i64) {
  // expected-error @+1 {{operand element types must match}}
  %0 = wave.binary addi %a, %b : i32, i64 -> i32
  return
}

// -----

func.func @addi_simd_width_mismatch(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 64>) {
  // expected-error @+1 {{SIMD wave widths must match}}
  %0 = wave.binary addi %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 64> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @addi_simd_result_required(%a: !wave.simd<i32, 32>, %b: i32) {
  // expected-error @+1 {{result must be SIMD because at least one operand is SIMD}}
  %0 = wave.binary addi %a, %b : !wave.simd<i32, 32>, i32 -> i32
  return
}

// -----

func.func @addi_uniform_result_int(%a: i32, %b: i32) {
  // expected-error @+1 {{result type must match operands}}
  %0 = "wave.binary"(%a, %b) {kind = 0 : i32} : (i32, i32) -> !wave.simd<i32, 32>
  return
}

// -----

func.func @muli_simd_element_bits(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result SIMD element type must match operands}}
  %0 = "wave.binary"(%a, %b) {kind = 2 : i32} : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<i64, 32>
  return
}

// -----

func.func @xori_overflow_flags(%a: i32, %b: i32) {
  // expected-error @+1 {{overflow flags require addi, subi, muli, or shli}}
  %0 = wave.binary xori %a, %b overflow<nsw> : i32, i32 -> i32
  return
}

// -----

func.func @index_expr_count_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{expected one name per binding}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "x"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_unbound_symbol(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{free symbol 'K' has no binding}}
  %v = wave.index_expr #wave.expr<"lid + K"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_stray_binding(%lane: !wave.simd<i32, 32>, %k: i32) {
  // expected-error @+1 {{binding name 'K' is not a free symbol of the expression}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "K"] (%lane, %k) : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_assumption_undeclared_symbol(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{assumption #0 references undeclared symbol `x`}}
  %v = wave.index_expr #wave.expr<"lid"> assuming [#wave.pred<"x >= 0">] ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_duplicate_name(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{duplicate binding name 'lid'}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "lid"] (%lane, %lane) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_width_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{lane-varying result must be !wave.simd<index, W>}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> index
  return
}

// -----

func.func @index_expr_uniform_new_result_mismatch(%k: i32) {
  // expected-error @+1 {{uniform result must be index}}
  %v = wave.index_expr #wave.expr<"K"> ["K"] (%k) : (i32) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_new_width_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result width 64 disagrees with binding lane width 32}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 64>
  return
}

// -----

func.func @index_expr_lane_new_result_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{lane-varying result must be !wave.simd<index, W>}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> index
  return
}

// -----

func.func @index_expr_conflicting_widths(%lane32: !wave.simd<i32, 32>, %lane64: !wave.simd<i32, 64>) {
  // expected-error @+1 {{conflicting lane-varying binding widths}}
  %v = wave.index_expr #wave.expr<"a + b"> ["a", "b"] (%lane32, %lane64) : (!wave.simd<i32, 32>, !wave.simd<i32, 64>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @index_expr_empty_name(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{binding name must be non-empty}}
  %v = wave.index_expr #wave.expr<"lid"> [""] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

func.func @ballot_width_mismatch(%m: !wave.mask<32>) -> i64 {
  // expected-error @+1 {{result integer width must match mask width}}
  %r = wave.ballot %m : !wave.mask<32> -> i64
  return %r : i64
}

// -----

func.func @binary_result_type_mismatch(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result SIMD wave width must match operands}}
  %r = wave.binary addi %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 64>
  return
}

// -----

func.func @urecip_type_mismatch(%x: i32) {
  // expected-error @+1 {{source and result types must match}}
  %r = wave.urecip %x : i32 -> i64
  return
}

// -----

func.func @urecip_bad_type(%x: i64) {
  // expected-error @+1 {{requires i32 or !wave.simd<i32, W>}}
  %r = wave.urecip %x : i64 -> i64
  return
}

// -----

func.func @ctz_type_mismatch(%x: i32) {
  // expected-error @+1 {{source and result types must match}}
  %r = wave.ctz %x : i32 -> i64
  return
}

// -----

func.func @ctz_bad_type(%x: f32) {
  // expected-error @+1 {{requires i32, i64, index, or matching SIMD type}}
  %r = wave.ctz %x : f32 -> f32
  return
}

// -----

func.func @cast_scalar_simd_mismatch(%x: f32) {
  // expected-error @+1 {{source and result must both be scalar or both be SIMD}}
  %r = wave.cast fpconvert %x : f32 -> !wave.simd<f16, 32>
  return
}

// -----

func.func @cast_simd_width_mismatch(%x: !wave.simd<f32, 32>) {
  // expected-error @+1 {{source and result SIMD widths must match}}
  %r = wave.cast fpconvert %x : !wave.simd<f32, 32> -> !wave.simd<f16, 64>
  return
}

// -----

func.func @cast_vector_rank_mismatch(%x: !wave.simd<vector<2x2xf32>, 32>) {
  // expected-error @+1 {{numeric vector payload must be 1-D}}
  %r = wave.cast fpconvert %x : !wave.simd<vector<2x2xf32>, 32> -> !wave.simd<vector<4xf16>, 32>
  return
}

// -----

func.func @cast_vector_length_mismatch(%x: !wave.simd<vector<2xf32>, 32>) {
  // expected-error @+1 {{source and result vector lengths must match}}
  %r = wave.cast fpconvert %x : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<3xf16>, 32>
  return
}

// -----

func.func @cast_bad_fpconvert_kind(%x: !wave.simd<i32, 32>) {
  // expected-error @+1 {{fpconvert requires float source and result}}
  %r = wave.cast fpconvert %x : !wave.simd<i32, 32> -> !wave.simd<i16, 32>
  return
}

// -----

func.func @cast_bad_fp_to_int_kind(%x: !wave.simd<i32, 32>) {
  // expected-error @+1 {{fp_to_int requires float source and integer result}}
  %r = wave.cast fp_to_int %x : !wave.simd<i32, 32> -> !wave.simd<i16, 32>
  return
}

// -----

func.func @cast_widening_intconvert_missing_extension(%x: !wave.simd<i16, 32>) {
  // expected-error @+1 {{extension policy required for widening intconvert}}
  %r = wave.cast intconvert %x : !wave.simd<i16, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @cast_intconvert_trunc_with_extension(%x: !wave.simd<i32, 32>) {
  // expected-error @+1 {{extension policy only valid for widening intconvert}}
  %r = wave.cast intconvert %x policy {extension = #wave.cast_extension<sign>} : !wave.simd<i32, 32> -> !wave.simd<i16, 32>
  return
}

// -----

func.func @cast_int_to_fp_missing_signedness(%x: !wave.simd<i32, 32>) {
  // expected-error @+1 {{signedness policy required for int_to_fp}}
  %r = wave.cast int_to_fp %x : !wave.simd<i32, 32> -> !wave.simd<f32, 32>
  return
}

// -----

func.func @cast_fp_to_int_missing_signedness(%x: !wave.simd<f32, 32>) {
  // expected-error @+1 {{signedness policy required for fp_to_int}}
  %r = wave.cast fp_to_int %x : !wave.simd<f32, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @cast_rounding_on_fp_to_int(%x: !wave.simd<f32, 32>) {
  // expected-error @+1 {{rounding policy requires fpconvert or int_to_fp}}
  %r = wave.cast fp_to_int %x policy {rounding = #wave.cast_rounding<rne>, signedness = #wave.cast_signedness<signed>} : !wave.simd<f32, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @cast_signedness_on_fpconvert(%x: !wave.simd<f32, 32>) {
  // expected-error @+1 {{signedness policy requires int_to_fp or fp_to_int}}
  %r = wave.cast fpconvert %x policy {signedness = #wave.cast_signedness<signed>} : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  return
}

// -----

func.func @cast_non_numeric(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{cast type must be a signless integer or float}}
  %r = wave.cast intconvert %p : !wave.ptr<#wave.global, i32> -> i32
  return
}

// -----

func.func @ptr_cast_non_pointer(%x: i32) {
  // expected-error @+1 {{ptr_cast type must be a wave pointer or SIMD of pointers}}
  %r = wave.ptr_cast %x : i32 -> !wave.ptr<#wave.global, i32>
  return
}

// -----

func.func @ptr_cast_address_space_mismatch(%p: !wave.ptr<#wave.global, i32>) {
  // expected-error @+1 {{source and result address spaces must match}}
  %r = wave.ptr_cast %p : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.shared, i32>
  return
}

// -----

func.func @cast_unknown_policy(%x: f32) {
  // expected-error @+1 {{unknown policy field 'round'}}
  %r = wave.cast fpconvert %x policy {round = #wave.cast_rounding<rne>} : f32 -> f16
  return
}

// -----

func.func @cast_wrong_policy_type(%x: f32) {
  // expected-error @+1 {{policy 'rounding' must be #wave.cast_rounding}}
  %r = wave.cast fpconvert %x policy {rounding = "rne"} : f32 -> f16
  return
}

// -----

func.func @fadd_packed_bad_element(%a: !wave.simd<vector<2xi16>, 32>, %b: !wave.simd<vector<2xi16>, 32>) {
  // expected-error @+1 {{SIMD element type must be f32, f16, vector<2^nxf16>, or vector<2^nxf32> with at least two f32 elements}}
  %r = wave.fadd %a, %b : !wave.simd<vector<2xi16>, 32>, !wave.simd<vector<2xi16>, 32> -> !wave.simd<vector<2xi16>, 32>
  return
}

// -----

func.func @fadd_packed_f32_too_short(%a: !wave.simd<vector<1xf32>, 32>, %b: !wave.simd<vector<1xf32>, 32>) {
  // expected-error @+1 {{SIMD element type must be f32, f16, vector<2^nxf16>, or vector<2^nxf32> with at least two f32 elements}}
  %r = wave.fadd %a, %b : !wave.simd<vector<1xf32>, 32>, !wave.simd<vector<1xf32>, 32> -> !wave.simd<vector<1xf32>, 32>
  return
}

// -----

func.func @fsub_packed_f16_rejected(%a: !wave.simd<vector<2xf16>, 32>, %b: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @+1 {{SIMD element type must be f32}}
  %r = wave.fsub %a, %b : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}

// -----

func.func @fma_result_type_mismatch(%a: !wave.simd<vector<2xf16>, 32>, %b: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @+1 {{operands and result must have the same SIMD type}}
  %r = wave.fma %a, %b, %a : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 64>
  return
}

// -----

func.func @pack_empty() {
  // expected-error @+1 {{requires at least one input}}
  %r = "wave.pack"() : () -> vector<1xf16>
  return
}

// -----

func.func @pack_scalar_type_mismatch(%a: f16, %b: i16) {
  // expected-error @+1 {{requires all operands to have the same type}}
  %r = wave.pack %a, %b : f16, i16 -> vector<2xf16>
  return
}

// -----

func.func @pack_scalar_result_not_vector(%a: f16, %b: f16) {
  // expected-error @+1 {{result #0 must be 1-D vector or wave SIMD of 1-D vector}}
  %r = "wave.pack"(%a, %b) : (f16, f16) -> f16
  return
}

// -----

func.func @pack_result_length_mismatch(%a: f16, %b: f16) {
  // expected-error @+1 {{input element count must match result vector length}}
  %r = wave.pack %a, %b : f16, f16 -> vector<3xf16>
  return
}

// -----

func.func @pack_vector_chunk_result_length_mismatch(%a: vector<2xi8>, %b: vector<2xi8>) {
  // expected-error @+1 {{input element count must match result vector length}}
  %r = wave.pack %a, %b : vector<2xi8>, vector<2xi8> -> vector<5xi8>
  return
}

// -----

func.func @pack_vector_chunk_rank_mismatch(%a: vector<1x2xi8>, %b: vector<1x2xi8>) {
  // expected-error @+1 {{input vector chunks must be 1-D}}
  %r = wave.pack %a, %b : vector<1x2xi8>, vector<1x2xi8> -> vector<4xi8>
  return
}

// -----

func.func @pack_scalar_result_simd(%a: f16, %b: f16) {
  // expected-error @+1 {{result must not be SIMD when inputs are scalar}}
  %r = "wave.pack"(%a, %b) : (f16, f16) -> !wave.simd<vector<2xf16>, 32>
  return
}

// -----

func.func @pack_scalar_result_element_mismatch(%a: f16, %b: f16) {
  // expected-error @+1 {{result vector element type must match inputs}}
  %r = wave.pack %a, %b : f16, f16 -> vector<2xi16>
  return
}

// -----

func.func @pack_simd_width_mismatch(%a: !wave.simd<f16, 32>, %b: !wave.simd<f16, 64>) {
  // expected-error @+1 {{requires all operands to have the same type}}
  %r = wave.pack %a, %b : !wave.simd<f16, 32>, !wave.simd<f16, 64> -> !wave.simd<vector<2xf16>, 32>
  return
}

// -----

func.func @pack_simd_result_not_simd(%a: !wave.simd<f16, 32>, %b: !wave.simd<f16, 32>) {
  // expected-error @+1 {{result must be SIMD when inputs are SIMD}}
  %r = "wave.pack"(%a, %b) : (!wave.simd<f16, 32>, !wave.simd<f16, 32>) -> vector<2xf16>
  return
}

// -----

func.func @pack_simd_result_width_mismatch(%a: !wave.simd<f16, 32>, %b: !wave.simd<f16, 32>) {
  // expected-error @+1 {{result SIMD width must match inputs}}
  %r = wave.pack %a, %b : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 64>
  return
}

// -----

func.func @pack_mixed_scalar_simd(%a: f16, %b: !wave.simd<f16, 32>) {
  // expected-error @+1 {{requires all operands to have the same type}}
  %r = "wave.pack"(%a, %b) : (f16, !wave.simd<f16, 32>) -> vector<2xf16>
  return
}

// -----

func.func @extract_scalar_source_not_vector(%a: f16) {
  // expected-error @+1 {{operand #0 must be 1-D vector or wave SIMD of 1-D vector}}
  %r = wave.extract %a[0] : f16 -> f16
  return
}

// -----

func.func @extract_out_of_bounds(%a: vector<2xf16>) {
  // expected-error @+1 {{index must be in source vector bounds}}
  %r = wave.extract %a[2] : vector<2xf16> -> f16
  return
}

// -----

func.func @extract_slice_out_of_bounds(%a: vector<4xi8>) {
  // expected-error @+1 {{slice must be in source vector bounds}}
  %r = wave.extract %a[3] : vector<4xi8> -> vector<2xi8>
  return
}

// -----

func.func @extract_slice_rank_mismatch(%a: vector<4xi8>) {
  // expected-error @+1 {{result vector slice must be 1-D}}
  %r = wave.extract %a[1] : vector<4xi8> -> vector<1x2xi8>
  return
}

// -----

func.func @extract_negative_index(%a: vector<2xf16>) {
  // expected-error @+1 {{attribute 'index' failed to satisfy constraint}}
  %r = wave.extract %a[-1] : vector<2xf16> -> f16
  return
}

// -----

func.func @extract_result_type_mismatch(%a: vector<2xf16>) {
  // expected-error @+1 {{result type must match source vector element}}
  %r = wave.extract %a[1] : vector<2xf16> -> i16
  return
}

// -----

func.func @extract_simd_result_width_mismatch(%a: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @+1 {{result SIMD width must match source}}
  %r = wave.extract %a[1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 64>
  return
}

// -----

func.func @extract_simd_result_required(%a: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @+1 {{result must be SIMD when source is SIMD}}
  %r = wave.extract %a[1] : !wave.simd<vector<2xf16>, 32> -> f16
  return
}

// -----

func.func @extract_simd_result_element_mismatch(%a: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @+1 {{result type must match source vector element}}
  %r = wave.extract %a[1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<i16, 32>
  return
}

// -----

func.func @extract_simd_slice_element_mismatch(%a: !wave.simd<vector<4xi8>, 32>) {
  // expected-error @+1 {{result vector element type must match source vector element}}
  %r = wave.extract %a[1] : !wave.simd<vector<4xi8>, 32> -> !wave.simd<vector<2xi16>, 32>
  return
}

// -----

func.func @cmpi_operand_simd_mismatch(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 64>) {
  // expected-error @+1 {{operands must have the same SIMD type}}
  %m = wave.cmpi ult %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 64> -> !wave.mask<32>
  return
}

// -----

func.func @cmpi_result_mask_width(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result mask width must match operand SIMD width}}
  %m = wave.cmpi ult %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<64>
  return
}

// -----

func.func @select_rejects_bad_condition(%pred: i32, %a: i32, %b: i32) {
  // expected-error @+1 {{condition must be i1 or !wave.mask}}
  %r = "wave.select"(%pred, %a, %b) : (i32, i32, i32) -> i32
  return
}

// -----

func.func @select_rejects_token(%pred: i1) {
  %t0 = wave.token : !wave.mem.token
  %t1 = wave.token : !wave.mem.token
  // expected-error @+1 {{cannot select memory tokens}}
  %r = wave.select %pred, %t0, %t1 : !wave.mem.token
  return
}

// -----

func.func @select_mask_requires_lane_shaped_result(%m: !wave.mask<32>, %a: i32, %b: i32) {
  // expected-error @+1 {{mask condition requires SIMD or mask result}}
  %r = wave.select %m, %a, %b : !wave.mask<32>, i32
  return
}

// -----

func.func @select_mask_simd_width_mismatch(%m: !wave.mask<64>,
                                           %a: !wave.simd<i32, 32>,
                                           %b: !wave.simd<i32, 32>) {
  // expected-error @+1 {{SIMD result width must match mask width}}
  %r = wave.select %m, %a, %b : !wave.mask<64>, !wave.simd<i32, 32>
  return
}

// -----

func.func @select_mask_result_width_mismatch(%m: !wave.mask<64>,
                                             %a: !wave.mask<32>,
                                             %b: !wave.mask<32>) {
  // expected-error @+1 {{result mask width must match condition mask width}}
  %r = wave.select %m, %a, %b : !wave.mask<64>, !wave.mask<32>
  return
}

// -----

func.func @lds_base_wrong_address_space() {
  // expected-error @+1 {{result pointer must live in the shared address space}}
  %p = wave.shared_memory_base : !wave.ptr<#wave.global, i32>
  return
}

// -----

func.func @alloc_wrong_address_space() {
  // expected-error @+1 {{result pointer must live in the shared address space}}
  %p = wave.alloc() {align = 4 : i64, bytesize = 16 : i64} : !wave.ptr<#wave.global, i32>
  return
}

// -----

func.func @alloc_zero_bytesize() {
  // expected-error @+1 {{bytesize must be positive}}
  %p = wave.alloc() {align = 4 : i64, bytesize = 0 : i64} : !wave.ptr<#wave.shared, i32>
  return
}

// -----

func.func @alloc_bad_align() {
  // expected-error @+1 {{align must be a positive power of two}}
  %p = wave.alloc() {align = 3 : i64, bytesize = 16 : i64} : !wave.ptr<#wave.shared, i32>
  return
}

// -----

func.func @read_first_element_mismatch(%v: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result type must match SIMD element type}}
  %r = wave.read_first %v : !wave.simd<i32, 32> -> i64
  return
}

// -----

func.func @shuffle_result_type_mismatch(%v: !wave.simd<i32, 32>,
                                        %lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{source and result SIMD types must match}}
  %r = wave.shuffle %v from %lane : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 64>
  return
}

// -----

func.func @shuffle_lane_width_mismatch(%v: !wave.simd<i32, 32>,
                                       %lane: !wave.simd<i32, 64>) {
  // expected-error @+1 {{source lane SIMD width must match source SIMD width}}
  %r = wave.shuffle %v from %lane : !wave.simd<i32, 32>, !wave.simd<i32, 64> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @shuffle_bad_scalar_lane_type(%v: !wave.simd<i32, 32>,
                                        %lane: i64) {
  // expected-error @+1 {{source lane scalar type must be index or signless i32}}
  %r = wave.shuffle %v from %lane : !wave.simd<i32, 32>, i64 -> !wave.simd<i32, 32>
  return
}

// -----

func.func @shuffle_bad_simd_lane_type(%v: !wave.simd<i32, 32>,
                                      %lane: !wave.simd<f32, 32>) {
  // expected-error @+1 {{source lane SIMD element type must be index or signless i32}}
  %r = wave.shuffle %v from %lane : !wave.simd<i32, 32>, !wave.simd<f32, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @splat_element_mismatch(%v: i32) {
  // expected-error @+1 {{source type must match SIMD element type}}
  %s = wave.splat %v : i32 -> !wave.simd<i64, 32>
  return
}

// -----

func.func @splat_unsupported_wave_width(%v: i32) {
  // expected-error @+1 {{wave SIMD width must be 32 or 64}}
  %s = wave.splat %v : i32 -> !wave.simd<i32, 16>
  return
}

// -----

func.func @workitem_id_unsupported_wave_width() {
  // expected-error @+1 {{wave SIMD width must be 32 or 64}}
  %x = wave.workitem_id 0 : !wave.simd<i32, 16>
  return
}
