// RUN: wave-opt --split-input-file --verify-diagnostics %s

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

func.func @load_bad_ptr_simd_width(%p: !wave.simd<!wave.ptr<i32, #wave.global>, 64>) {
  // expected-error @+1 {{pointer SIMD width must match result SIMD width}}
  %v, %t = wave.load %p : (!wave.simd<!wave.ptr<i32, #wave.global>, 64>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_scalar_width(%p: !wave.ptr<i32, #wave.global>) {
  // expected-error @+1 {{per-lane payload must be a multiple of the pointer element bit width}}
  %v, %t = wave.load %p : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<i16, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_vector_element(%p: !wave.ptr<i32, #wave.global>) {
  // expected-error @+1 {{vector element type must be 32 bits wide}}
  %v, %t = wave.load %p : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_ptr_kind(%p: i64) {
  // expected-error @+1 {{expected wave pointer operand}}
  %v, %t = wave.load %p : (i64) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @assume_range_on_ptr(%p: !wave.ptr<i32, #wave.global>) -> !wave.ptr<i32, #wave.global> {
  // expected-error @+1 {{operand #0 must be signless integer or wave SIMD of signless integer}}
  %r = wave.assume_range %p, [0, 100] : !wave.ptr<i32, #wave.global>
  return %r : !wave.ptr<i32, #wave.global>
}

// -----

func.func @assume_range_on_signed(%v: si32) -> si32 {
  // expected-error @+1 {{operand #0 must be signless integer or wave SIMD of signless integer}}
  %r = wave.assume_range %v, [0, 100] : si32
  return %r : si32
}

// -----

func.func @addi_width_mismatch(%a: i32, %b: i64) {
  // expected-error @+1 {{operand element bit-widths must match}}
  %0 = wave.addi %a, %b : i32, i64 -> i32
  return
}

// -----

func.func @addi_simd_width_mismatch(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 64>) {
  // expected-error @+1 {{SIMD wave widths must match}}
  %0 = wave.addi %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 64> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @addi_simd_result_required(%a: !wave.simd<i32, 32>, %b: i32) {
  // expected-error @+1 {{result must be SIMD because at least one operand is SIMD}}
  %0 = wave.addi %a, %b : !wave.simd<i32, 32>, i32 -> i32
  return
}

// -----

func.func @addi_uniform_result_int(%a: i32, %b: i32) {
  // expected-error @+1 {{result must be a signless integer}}
  %0 = "wave.addi"(%a, %b) : (i32, i32) -> !wave.simd<i32, 32>
  return
}

// -----

func.func @muli_simd_element_bits(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result SIMD element width must match operands}}
  %0 = "wave.muli"(%a, %b) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<i64, 32>
  return
}

// -----

func.func @index_expr_count_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{expected one name per binding}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "x"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_unbound_symbol(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{free symbol 'K' has no binding}}
  %v = wave.index_expr #wave.expr<"lid + K"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_stray_binding(%lane: !wave.simd<i32, 32>, %k: i32) {
  // expected-error @+1 {{binding name 'K' is not a free symbol of the expression}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "K"] (%lane, %k) : (!wave.simd<i32, 32>, i32) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_duplicate_name(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{duplicate binding name 'lid'}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "lid"] (%lane, %lane) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_width_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result width 0 disagrees with binding lane width 32}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index
  return
}

// -----

func.func @index_expr_conflicting_widths(%lane32: !wave.simd<i32, 32>, %lane64: !wave.simd<i32, 64>) {
  // expected-error @+1 {{conflicting lane-varying binding widths}}
  %v = wave.index_expr #wave.expr<"a + b"> ["a", "b"] (%lane32, %lane64) : (!wave.simd<i32, 32>, !wave.simd<i32, 64>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_empty_name(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{binding name must be non-empty}}
  %v = wave.index_expr #wave.expr<"lid"> [""] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
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
  // expected-error @+1 {{operands and result must have the same SIMD type}}
  %r = wave.binary "add" %a, %b : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 64>
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

func.func @cast_non_numeric(%p: !wave.ptr<i32, #wave.global>) {
  // expected-error @+1 {{cast type must be a signless integer or float}}
  %r = wave.cast intconvert %p : !wave.ptr<i32, #wave.global> -> i32
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

func.func @lds_base_wrong_address_space() {
  // expected-error @+1 {{result pointer must live in the shared address space}}
  %p = wave.lds_base : !wave.ptr<i32, #wave.global>
  return
}

// -----

func.func @read_first_element_mismatch(%v: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result type must match SIMD element type}}
  %r = wave.read_first %v : !wave.simd<i32, 32> -> i64
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
  // expected-error @+1 {{only wave32 and wave64 are supported for now}}
  %s = wave.splat %v : i32 -> !wave.simd<i32, 16>
  return
}

// -----

func.func @workitem_id_unsupported_wave_width() {
  // expected-error @+1 {{only wave32 and wave64 workitem_id are supported}}
  %x = wave.workitem_id 0 : !wave.simd<i32, 16>
  return
}
