// RUN: wave-opt --waveamd-to-machine -split-input-file -verify-diagnostics %s

func.func @unsupported_op(%x: i32, %y: i32) attributes {wave.kernel} {
  // expected-error @below {{unsupported operation in WaveAMDMachine selection}}
  %sum = arith.addi %x, %y : i32
  return
}

// -----

func.func @unsupported_raw_arith_addi(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %wgid = wave.workgroup_id 0
  %two = arith.constant 2 : i32
  // expected-error @below {{unsupported operation in WaveAMDMachine selection}}
  %sum = arith.addi %wgid, %two : i32
  %off = wave.index_expr <"S"> ["S"](%sum) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// -----

func.func @residual_wavemeta_op() attributes {wave.kernel} {
  // expected-error @below {{WaveAMDMachine lowering requires wavemeta-specialize; residual wavemeta operation remains}}
  %n = wavemeta.param "n" : index
  return
}

// -----

// expected-error @below {{unsupported type for WaveAMDMachine lowering: '!wavemeta.ptuple<i32, "n">'}}
func.func @residual_wavemeta_type(%t: !wavemeta.ptuple<i32, "n">) attributes {wave.kernel} {
  return
}

// -----

// expected-error @below {{unsupported type for WaveAMDMachine lowering: 'memref<4xi32>'}}
func.func @unsupported_source_type(%m: memref<4xi32>) attributes {wave.kernel} {
  return
}

// -----

func.func @unsupported_lane_id_width() {
  // expected-error @below {{WaveAMDMachine backend supports only !wave.simd<i32, 32/64> lane_id}}
  %lane = wave.lane_id : !wave.simd<i64, 64>
  return
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_i16_cmpi(%x: !wave.simd<i16, 32>) {
  // expected-error @below {{WaveAMDMachine backend supports only !wave.simd<i32/i64/index, W> cmpi operands}}
  %mask = wave.cmpi slt %x, %x
      : !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.mask<32>
  return
}
}

// -----

func.func @unsupported_divisor() {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %five = arith.constant 5 : i32
  %v5 = wave.splat %five : i32 -> !wave.simd<i32, 32>
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divui %lane, %v5 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @unsupported_signed_dividend(%x: i32) {
  %two = arith.constant 2 : i32
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divsi %x, %two : i32, i32 -> i32
  return
}

// -----

func.func @unsupported_signed_wrapping_product_dividend(%x: i32, %y: i32) {
  %a = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %b = wave.assume %y as "x" [#wave.pred<"x >= 0">] : i32
  %prod = wave.binary muli %a, %b : i32, i32 -> i32
  %thirty_two = arith.constant 32 : i32
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divsi %prod, %thirty_two : i32, i32 -> i32
  return
}

// -----

func.func @unsupported_signed_unbounded_index_product_dividend(%x: i32, %y: i32, %z: i32) {
  %a = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %b = wave.assume %y as "x" [#wave.pred<"x >= 0">] : i32
  %c = wave.assume %z as "x" [#wave.pred<"x >= 0">] : i32
  %prod = wave.index_expr <"a*b*c"> ["a", "b", "c"](%a, %b, %c) : (i32, i32, i32) -> index
  %thirty_two = arith.constant 32 : index
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divsi %prod, %thirty_two : index, index -> index
  return
}

// -----

func.func @unsupported_signed_divisor() {
  %value = arith.constant 16 : i32
  %neg = arith.constant -2 : i32
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divsi %value, %neg : i32, i32 -> i32
  return
}

// -----

func.func @unsupported_signed_dynamic_pow2_or_zero_divisor(%x: i32, %d: i32) {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pow2_or_zero = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">] : i32
  // expected-error @below {{must be expanded before WaveAMDMachine selection}}
  %bad = wave.binary divsi %nonneg, %pow2_or_zero : i32, i32 -> i32
  return
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_packed_f16_fmax(%a: !wave.simd<vector<2xf16>, 32>, %b: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @below {{packed f16 fmax lowering is not implemented}}
  %max = wave.fmax %a, %b : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_packed_f32_to_f16_rounding(%x: !wave.simd<vector<2xf32>, 32>) {
  // expected-error @below {{packed f32 to f16 lowering supports only rtz rounding}}
  %h = wave.cast fpconvert %x policy {rounding = #wave.cast_rounding<rne>} : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {
func.func @unsupported_packed_f16_target(%a: !wave.simd<vector<2xf16>, 64>, %b: !wave.simd<vector<2xf16>, 64>) {
  // expected-error @below {{packed f16 fadd lowering requires gfx9/gfx11}}
  %sum = wave.fadd %a, %b : !wave.simd<vector<2xf16>, 64>, !wave.simd<vector<2xf16>, 64> -> !wave.simd<vector<2xf16>, 64>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @unsupported_packed_f32_to_f16_target(%x: !wave.simd<vector<2xf32>, 64>) {
  // expected-error @below {{packed f32 to f16 lowering requires gfx11}}
  %h = wave.cast fpconvert %x policy {rounding = #wave.cast_rounding<rtz>} : !wave.simd<vector<2xf32>, 64> -> !wave.simd<vector<2xf16>, 64>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1030",
                   waveamdmachine.wavefront_size = 32 : i64} {
func.func @unsupported_wmma_target(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{wmma.i32.16x16x16.iu8 lowering requires gfx11}}
  %result = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<1, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1200",
                   waveamdmachine.wavefront_size = 32 : i64} {
func.func @unsupported_wmma_gfx12_target(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  // expected-error @below {{wmma.i32.16x16x16.iu8 lowering requires gfx11}}
  %result = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<1, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
func.func @unsupported_mfma_gfx950_target(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{mfma.f32.16x16x32.f16 lowering requires gfx950}}
  %result = waveamd.mma "mfma.f32.16x16x32.f16" %a, %b, %acc : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
func.func @unsupported_scaled_mfma_gfx950_target(%x: i32) {
  %scale = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  // expected-error @below {{mfma.scale.f32.16x16x128.f4.f4 lowering requires gfx950}}
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %scale, %acc : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<i32, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
func.func @unsupported_transpose_load_gfx950_target()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  // expected-error @below {{transpose load lowering requires gfx950}}
  %v, %tok = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_mfma_family(%x: i32) {
  %a = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 2>
  %b = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 2>
  %acc = waveamd.fragment_fill %x : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  // expected-error @below {{mfma.f32.16x16x16.f16 lowering requires gfx90a+}}
  %result = waveamd.mma "mfma.f32.16x16x16.f16" %a, %b, %acc : !waveamd.fragment<0, f16, 16, 16, 32, 2>, !waveamd.fragment<1, f16, 16, 16, 32, 2>, !waveamd.fragment<2, f32, 16, 16, 32, 4> -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// expected-error @below {{WaveAMDMachine backend target gfx1100 uses wave32 but function requires wave64}}
func.func @gfx1100_rejects_wave64(%x: i32) {
  %v = wave.splat %x : i32 -> !wave.simd<i32, 64>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
// expected-error @below {{WaveAMDMachine backend target gfx942 uses wave64 but function requires wave32}}
func.func @gfx942_rejects_wave32(%x: i32) {
  %v = wave.splat %x : i32 -> !wave.simd<i32, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
// expected-error @below {{WaveAMDMachine backend target gfx942 uses wave64 but function requires wave32}}
func.func @gfx942_rejects_where_wave32_mask(%active: !wave.mask<32>) {
  wave.where %active {
    wave.yield
  } : !wave.mask<32>
  return
}
}

// -----

// expected-error @below {{WaveAMDMachine selection target gfx942 does not support wave32}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942",
                   waveamdmachine.wavefront_size = 32 : i64} {
func.func @gfx942_rejects_wave32_override(%x: i32) {
  %v = wave.splat %x : i32 -> !wave.simd<i32, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @where_otherwise_pointer_different_base(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>,
    %limit: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // expected-error @below {{wave.where pointer otherwise requires matching pointer bases}}
  %ptrs = wave.where %active {
    %then_ptr = wave.ptr_add %a, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %then_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } otherwise {
    %else_ptr = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %else_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

func.func @kernel_return_value(%x: i32) -> i32 attributes {wave.kernel} {
  // expected-error @below {{kernel functions must return void}}
  return %x : i32
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @index_expr_byte_scale_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"4611686018427387904 + lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // expected-error @below {{pointer offset byte scale overflows i64}}
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @floor_unknown_value(%x: i32) -> index {
  // expected-error @below {{index_expr floor shift lowering needs nonnegative operand}}
  %off = wave.index_expr <"floor(1/2*x)"> ["x"](%x) : (i32) -> index
  return %off : index
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @floor_dynamic_denominator_buffer(%out: !wave.ptr<#wave.global, i32>,
                                            %u_raw: i32) attributes {wave.kernel} {
  %lane_raw = wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.assume %lane_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 1">, #wave.pred<"x <= 31">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"floor(lid/u)"> ["lid", "u"](%lane, %u)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{wave.index_expr floor needs a static denominator}}
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_store_offset_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %range = arith.constant 64 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_load_offset_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %range = arith.constant 64 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %value, %tok = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_unbounded_uniform_needs_range(%out: !wave.ptr<#wave.global, i32>, %u: i32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"lid + 16*u"> ["lid", "u"] (%lane, %u)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_raw_unbounded_offset_needs_range(%out: !wave.ptr<#wave.global, i32>, %raw: i32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buf, %raw
      : !wave.ptr<#waveamd.buffer, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_raw_overwide_offset_errors(%out: !wave.ptr<#wave.global, i32>, %raw_base: i32) attributes {wave.kernel} {
  %raw = wave.assume %raw_base as "x" [#wave.pred<"x >= 1073741824">, #wave.pred<"x <= 1073741824">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buf, %raw
      : !wave.ptr<#waveamd.buffer, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @buffer_dma_lds_unbounded_source_offset_needs_range(
    %in: !wave.ptr<#wave.global, i32>, %u: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"wi + 16*u"> ["wi", "u"](%wi, %u)
      : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{buffer memory op offset must fit proven unsigned 32-bit}}
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @global_dma_lds_lane_wide_source_needs_range(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"4294967296*w"> ["w"](%wi)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %in, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  // expected-error @below {{global DMA LDS source offset must fit proven unsigned 32-bit voffset field}}
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_loop_dynamic_carry_needs_bound(%out: !wave.ptr<#wave.global, i32>, %delta: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // expected-error @below {{scf.for pointer carry offset must fit proven unsigned 32-bit for every iteration}}
  %res = scf.for %i = %c0 to %c4 step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) : i32 {
    %tok = wave.store %lane -> %q
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    %next = wave.ptr_add %q, %delta
        : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @global_loop_dynamic_carry_unbounded_rejected(%out: !wave.ptr<#wave.global, f16>,
                                                        %n: i32, %delta: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  // expected-error @below {{scf.for pointer carry offset must fit proven unsigned 32-bit for every iteration}}
  scf.for %i = %c0 to %n step %c1 iter_args(%q = %ptr)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %next = wave.ptr_add %q, %delta
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @global_loop_dynamic_carry_negative_rejected(%out: !wave.ptr<#wave.global, f16>,
                                                       %n: i32,
                                                       %delta_raw: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %delta = wave.assume %delta_raw as "x" [#wave.pred<"x >= -4">, #wave.pred<"x <= 32">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  // expected-error @below {{scf.for pointer carry offset must fit proven unsigned 32-bit for every iteration}}
  scf.for %i = %c0 to %n step %c1 iter_args(%q = %ptr)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %next = wave.ptr_add %q, %delta
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}
