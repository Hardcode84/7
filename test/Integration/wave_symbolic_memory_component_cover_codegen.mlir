// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: symbolic_memory_component_cover_codegen:
// CHECK-NOT: buffer_store_short
// CHECK: buffer_store_dword
// CHECK-NOT: buffer_store_short
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_component_cover_codegen(
    %src: !wave.ptr<#wave.global, f16>,
    %dst: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel, wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"16 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<22xf16>, 64>, !wave.mem.token)
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"16 * Piecewise((0, slot == 0), (1, slot == 1), (1, slot == 2), (2, slot == 3), (28 + slot, True))">>
      bindings []() packet_bindings []() after %read
      : (!wave.simd<vector<22xf16>, 64>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}
}
