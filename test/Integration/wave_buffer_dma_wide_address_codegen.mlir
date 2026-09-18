// RUN: wave-opt %S/Inputs/wide_dma.mlir --wave-set-target-attr=chip=gfx950 -o %t.loop
// RUN: wave-opt %t.loop --waveamd-dma-zero-fill --wave-extract-loop-strides --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm -o %t.before.s
// RUN: wave-opt %t.loop --wave-extract-loop-strides --waveamd-dma-zero-fill --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm -o %t.after.s
// RUN: diff %t.before.s %t.after.s
// RUN: FileCheck %s --check-prefix=LOOP < %t.before.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.before.s -o /dev/null
// LOOP-LABEL: wide_dma:
// LOOP: s_and_saveexec_b64
// LOOP-NOT: buffer_load
// LOOP: global_load_lds_dword
// LOOP: s_{{(or|mov)}}_b64 exec
// LOOP: s_cbranch_scc1
// LOOP: s_endpgm
// RUN: wave-opt %s --waveamd-dma-zero-fill --wave-extract-loop-strides --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --wave-extract-loop-strides --waveamd-dma-zero-fill --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-dma-zero-fill --wave-extract-loop-strides --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-dma-zero-fill | FileCheck %s --check-prefix=EXEC
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
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32) -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 2147483647 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "u"
      [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "wi"
      [#wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"1073741824*u + wi">
      assuming [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">,
                #wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      ["u", "wi"](%u, %wi)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %dma = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return %dma : !wave.mem.token
}

// EXEC-LABEL: func.func @predicated_wide_dma
// EXEC-NOT: wave.select
// EXEC: wave.where
// EXEC: waveamd.dma_load_lds {{.*}}zero_fill_inactive
// EXEC: otherwise
// EXEC: return
// ASM-LABEL: predicated_wide_dma:
// ASM-NOT: buffer_load_dwordx4
// ASM: s_and_saveexec_b64
// ASM: global_load_lds_dwordx4
// ASM: s_{{(or|mov)}}_b64 exec
// ASM: s_endpgm
func.func @predicated_wide_dma(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32) -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 2147483647 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "u"
      [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "wi"
      [#wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"1073741824*u + wi">
      assuming [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">,
                #wave.pred<"wi >= 0">, #wave.pred<"wi <= 63">]
      ["u", "wi"](%u, %wi)
      : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %lim = wave.splat %u : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi ult %wi, %lim : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %result = wave.where %mask {
  %dma = waveamd.dma_load_lds %src -> %lds after %root {bytes = 16 : i64, zero_fill_inactive}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  wave.yield %dma : !wave.mem.token
  } otherwise {
  wave.yield %root : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

}
