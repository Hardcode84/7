// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: symbolic_memory_3d:
// ASM: v_and_b32_e32
// ASM: v_bfe_u32
// ASM: v_bfe_u32
// ASM: buffer_load_dword
// ASM: buffer_store_dword
// ASM: .amdhsa_system_vgpr_workitem_id 2

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_3d(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 16, 2, 2>,
                wave.waves_per_workgroup = 1 : i64} {
  %value, %read = wave.gather %src mapping
      <bit_offset = <"32 * item">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<vector<1xi32>, 64>, !wave.mem.token)
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"32 * item">>
      bindings []() packet_bindings []() after %read
      : (!wave.simd<vector<1xi32>, 64>, !wave.ptr<#wave.global, i32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}
}
