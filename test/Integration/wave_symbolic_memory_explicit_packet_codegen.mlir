// RUN: wave-opt --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// LOWER-LABEL: func.func @explicit_packet_offset_codegen(
// LOWER-NOT: wave.scatter
// LOWER-COUNT-1: wave.where
// LOWER-COUNT-1: wave.store
// LOWER-SAME: !wave.simd<vector<4xf16>, 64>
// LOWER-NOT: wave.store
// LOWER-NOT: wave.scatter

// ASM-LABEL: explicit_packet_offset_codegen:
// ASM-COUNT-1: buffer_store_dwordx2
// ASM-NOT: buffer_store_short
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @explicit_packet_offset_codegen(
    %destination: !wave.ptr<#wave.global, f16>, %tile: i32,
    %column_limit_raw: i32, %row_limit_raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %c128_i32 = arith.constant 128 : i32
  %c2147483647_i32 = arith.constant 2147483647 : i32
  %base = waveamd.make_buffer %destination, %c2147483647_i32
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %bounded_tile = wave.assume %tile as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 65535">] : i32
  %scaled = wave.binary muli %bounded_tile, %c128_i32 overflow<nsw>
      : i32, i32 -> i32
  %origin = wave.binary addi %scaled, %c128_i32 overflow<nsw>
      : i32, i32 -> i32
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 64>
  %zero = wave.constant 0.000000e+00 : f16 -> !wave.simd<f16, 64>
  %value = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<4xf16>, 64>
  %lane4 = wave.binary muli %lane, %four overflow<nsw, nuw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %origin_packet = wave.splat %origin : i32 -> !wave.simd<i32, 64>
  %column0 = wave.binary addi %origin_packet, %lane4 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %column1 = wave.binary addi %column0, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %column2 = wave.binary addi %column1, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %column3 = wave.binary addi %column2, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %column_limit = wave.assume %column_limit_raw as "x"
      [#wave.pred<"2147483648 + x >= 0">,
       #wave.pred<"-2147483647 + x <= 0">,
       #wave.pred<"Mod(x, 4) == 0">] : i32
  %column_limit_packet = wave.splat %column_limit
      : i32 -> !wave.simd<i32, 64>
  %row_limit = wave.splat %row_limit_raw : i32 -> !wave.simd<i32, 64>
  %row_active = wave.cmpi slt %lane, %row_limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %column_active0 = wave.cmpi slt %column0, %column_limit_packet
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %column_active1 = wave.cmpi slt %column1, %column_limit_packet
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %column_active2 = wave.cmpi slt %column2, %column_limit_packet
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %column_active3 = wave.cmpi slt %column3, %column_limit_packet
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %false = wave.constant false -> !wave.mask<64>
  %active0 = wave.select %row_active, %column_active0, %false
      : !wave.mask<64>, !wave.mask<64>
  %active1 = wave.select %row_active, %column_active1, %false
      : !wave.mask<64>, !wave.mask<64>
  %active2 = wave.select %row_active, %column_active2, %false
      : !wave.mask<64>, !wave.mask<64>
  %active3 = wave.select %row_active, %column_active3, %false
      : !wave.mask<64>, !wave.mask<64>
  %offset0_full = wave.index_expr <"origin + 4*wi">
      ["origin", "wi"](%origin, %lane)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset0_assumed = wave.assume %offset0_full as "x"
      [#wave.pred<"x >= -2147483648">,
       #wave.pred<"x <= 2147483647">] : !wave.simd<index, 64>
  %offset0 = wave.index_expr <"x">
      assuming [#wave.pred<"x >= -2147483648">,
                #wave.pred<"x <= 2147483647">]
      ["x"](%offset0_assumed)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  %offset1_full = wave.index_expr <"1 + origin + 4*wi">
      ["origin", "wi"](%origin, %lane)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset1_assumed = wave.assume %offset1_full as "x"
      [#wave.pred<"x >= -2147483648">,
       #wave.pred<"x <= 2147483647">] : !wave.simd<index, 64>
  %offset1 = wave.index_expr <"x">
      assuming [#wave.pred<"x >= -2147483648">,
                #wave.pred<"x <= 2147483647">]
      ["x"](%offset1_assumed)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  %offset2_full = wave.index_expr <"2 + origin + 4*wi">
      ["origin", "wi"](%origin, %lane)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset2_assumed = wave.assume %offset2_full as "x"
      [#wave.pred<"x >= -2147483648">,
       #wave.pred<"x <= 2147483647">] : !wave.simd<index, 64>
  %offset2 = wave.index_expr <"x">
      assuming [#wave.pred<"x >= -2147483648">,
                #wave.pred<"x <= 2147483647">]
      ["x"](%offset2_assumed)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  %offset3_full = wave.index_expr <"3 + origin + 4*wi">
      ["origin", "wi"](%origin, %lane)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset3_assumed = wave.assume %offset3_full as "x"
      [#wave.pred<"x >= -2147483648">,
       #wave.pred<"x <= 2147483647">] : !wave.simd<index, 64>
  %offset3 = wave.index_expr <"x">
      assuming [#wave.pred<"x >= -2147483648">,
                #wave.pred<"x <= 2147483647">]
      ["x"](%offset3_assumed)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  wave.where %active0, %active1, %active2, %active3 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset =
          <"16*Piecewise((offset0, slot == 0), (offset1, slot == 1), (offset2, slot == 2), (offset3, True))">>
        bindings ["offset0", "offset1", "offset2", "offset3"]
                 (%offset0, %offset1, %offset2, %offset3)
        : (!wave.simd<vector<4xf16>, 64>,
           !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>,
           !wave.simd<index, 64>, !wave.simd<index, 64>,
           !wave.simd<index, 64>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
  return
}
}
