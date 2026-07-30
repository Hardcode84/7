// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: buffer_dma_wide_address_codegen:
// ASM-NOT: buffer_load_dwordx4
// ASM: global_load_lds_dwordx4
// ASM: s_endpgm
func.func @buffer_dma_wide_address_codegen(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 2147483647 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "u"
      [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "wi"
      [#wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"1073741824*u + wi"> ["u", "wi"](%u, %wi)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %dma = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
