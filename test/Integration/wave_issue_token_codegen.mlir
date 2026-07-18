// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: issue_token_codegen:
// ASM: buffer_load_dwordx4
// ASM-NEXT: s_barrier
// ASM: s_endpgm
func.func @issue_token_codegen(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "wi"
      [#wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %dma = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %issued = wave.issue_token %dma
      : !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %issued
      : (!wave.mem.token) -> !wave.mem.token
  return
}

}
