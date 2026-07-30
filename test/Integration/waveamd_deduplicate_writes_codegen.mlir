// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: distinct_identical_dma_codegen:
// ASM-COUNT-1: buffer_load_dwordx4
// ASM: s_barrier
// ASM: s_endpgm

// ASM-LABEL: repeated_token_dma_codegen:
// ASM-COUNT-1: buffer_load_dwordx4
// ASM: s_barrier
// ASM: s_endpgm

// ASM-LABEL: external_dma_token_use_codegen:
// ASM-COUNT-2: buffer_load_dwordx4
// ASM: s_barrier
// ASM: s_endpgm

// ASM-LABEL: distinct_identical_store_codegen:
// ASM-COUNT-1: buffer_store_dword
// ASM: s_barrier
// ASM: s_endpgm

// ASM-LABEL: external_store_token_use_codegen:
// ASM-COUNT-2: buffer_store_dword
// ASM: s_barrier
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @distinct_identical_dma_codegen(
    %input: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %source = wave.ptr_add %buffer, %item
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %duplicate = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %first, %duplicate
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %joined
      : (!wave.mem.token) -> !wave.mem.token
  return
}

func.func @repeated_token_dma_codegen(
    %input: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %source = wave.ptr_add %buffer, %item
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %dma = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %dma, %dma
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %joined
      : (!wave.mem.token) -> !wave.mem.token
  return
}

func.func @external_dma_token_use_codegen(
    %input: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %source = wave.ptr_add %buffer, %item
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %first = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %second = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %joined = wave.join %first, %second
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %first
      : (!wave.mem.token) -> !wave.mem.token
  return
}

func.func @distinct_identical_store_codegen(
    %output: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %destination = wave.ptr_add %output, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %root = wave.token : !wave.mem.token
  %first = wave.store %item -> %destination after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %duplicate = wave.store %item -> %destination after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %first, %duplicate
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %joined
      : (!wave.mem.token) -> !wave.mem.token
  return
}

func.func @external_store_token_use_codegen(
    %output: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %destination = wave.ptr_add %output, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %root = wave.token : !wave.mem.token
  %first = wave.store %item -> %destination after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %item -> %destination after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %joined = wave.join %first, %second
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %barrier = wave.barrier %first, %joined
      : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
  return
}
}
