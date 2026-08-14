// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: symbolic_memory_component_cover_codegen:
// CHECK-NOT: buffer_store_short
// CHECK: buffer_store_dword
// CHECK-NOT: buffer_store_short
// CHECK: s_endpgm

// CHECK-LABEL: symbolic_memory_exact_packet_codegen:
// CHECK-NOT: store_short
// CHECK: buffer_store_dword
// CHECK-NOT: store_short
// CHECK: s_endpgm

// CHECK-LABEL: symbolic_memory_signed_remainder_codegen:
// CHECK-NOT: store_short
// CHECK: buffer_store_dword
// CHECK-NOT: store_short
// CHECK: s_endpgm

// CHECK-LABEL: symbolic_memory_scalarized_packet_codegen:
// CHECK-NOT: global_store_byte
// CHECK: buffer_store_dwordx2
// CHECK-NOT: global_store_byte
// CHECK: s_endpgm

// CHECK-LABEL: symbolic_memory_signed_remainder_unknown_sign_codegen:
// CHECK-NOT: buffer_store_dword
// CHECK: global_store_short
// CHECK: global_store_short
// CHECK-NOT: buffer_store_dword
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_component_cover_codegen(
    %src: !wave.ptr<#wave.global, f16>,
    %dst: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel, wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"16 * slot">>
      bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<22xf16>, 64>, !wave.mem.token)
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"16 * slot">>
      bindings []() after %read
      : (!wave.simd<vector<22xf16>, 64>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_exact_packet_codegen(
    %src: !wave.ptr<#wave.global, f16>,
    %dst: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"16 * slot">>
      bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %i0 = wave.index_expr
      <"64*floor(1/8*raw0) + 8*xor(1/8*(8*Mod(raw0, 2) + 32*Mod(floor(1/4*raw0), 2) + 16*Mod(floor(1/2*raw0), 2)), Mod(floor(1/16*raw0), 8))">
      ["raw0"](%bounded)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"16 * (origin + slot)">>
      bindings ["origin"](%i0) after %read
      : (!wave.simd<vector<2xf16>, 64>, !wave.ptr<#wave.global, f16>,
         !wave.simd<index, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_signed_remainder_codegen(
    %src: !wave.ptr<#wave.global, f16>,
    %dst: !wave.ptr<#wave.global, f16>, %origin_raw: i32, %extent_raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"16 * slot">>
      bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741822">,
       #wave.pred<"Mod(x, 2) == 0">] : i32
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= 4">, #wave.pred<"Mod(d, 4) == 0">] : i32
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"16 * (Mod(origin, extent) + slot)">>
      bindings ["origin", "extent"](%origin, %extent)
      after %read
      : (!wave.simd<vector<2xf16>, 64>, !wave.ptr<#wave.global, f16>,
         i32, i32, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_scalarized_packet_codegen(
    %dst: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %v0 = wave.constant 1.0 : f16 -> !wave.simd<f16, 64>
  %v1 = wave.constant 2.0 : f16 -> !wave.simd<f16, 64>
  %v2 = wave.constant 3.0 : f16 -> !wave.simd<f16, 64>
  %v3 = wave.constant 4.0 : f16 -> !wave.simd<f16, 64>
  %packet = wave.pack %v0, %v1, %v2, %v3
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<4xf16>, 64>
  %written = wave.scatter %packet to %dst mapping
      <bit_offset = <"16 * (4 * item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.simd<vector<4xf16>, 64>, !wave.ptr<#wave.global, f16>,
         !wave.simd<i32, 64>)
      -> !wave.mem.token
  return
}

func.func @symbolic_memory_signed_remainder_unknown_sign_codegen(
    %src: !wave.ptr<#wave.global, f16>,
    %dst: !wave.ptr<#wave.global, f16>, %origin_raw: i32, %extent_raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"16 * slot">>
      bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= -1073741822">, #wave.pred<"x <= 1073741822">,
       #wave.pred<"Mod(x, 2) == 0">] : i32
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= 4">, #wave.pred<"Mod(d, 4) == 0">] : i32
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"16 * (origin + slot - extent*Trunc((origin + slot)/extent))">>
      bindings ["origin", "extent"](%origin, %extent)
      after %read
      : (!wave.simd<vector<2xf16>, 64>, !wave.ptr<#wave.global, f16>,
         i32, i32, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
