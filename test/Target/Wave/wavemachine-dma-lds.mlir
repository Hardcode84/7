// RUN: wave-opt --split-input-file --waveamd-to-wavemachine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --split-input-file --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --split-input-file --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @global_dma_lds
// SELECT: wavemachine.s_mov_m0
// SELECT: wavemachine.global_load_lds_b32
// SELECT-SAME: !wavemachine.m0

// ASM-LABEL: global_dma_lds:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dword
func.func @global_dma_lds(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>,
         !wave.ptr<i32, #wave.shared>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_b128
// SELECT: wavemachine.s_mov_m0
// SELECT: wavemachine.global_load_lds_b128
// SELECT-SAME: !wavemachine.m0

// ASM-LABEL: global_dma_lds_b128:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_b128(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>,
         !wave.ptr<i32, #wave.shared>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds
// SELECT: wavemachine.s_mov_m0
// SELECT: wavemachine.buffer_load_lds_b32
// SELECT-SAME: !wavemachine.m0

// ASM-LABEL: buffer_dma_lds:
// ASM: s_mov_b32 m0,
// ASM: buffer_load_dword {{.*}} lds
func.func @buffer_dma_lds(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>,
         !wave.ptr<i32, #wave.shared>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_b128
// SELECT: wavemachine.s_mov_m0
// SELECT: wavemachine.buffer_load_lds_b128
// SELECT-SAME: !wavemachine.m0

// ASM-LABEL: buffer_dma_lds_b128:
// ASM: s_mov_b32 m0,
// ASM: buffer_load_dwordx4 {{.*}} lds
func.func @buffer_dma_lds_b128(%in: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>,
         !wave.ptr<i32, #wave.shared>, !wave.mem.token) -> !wave.mem.token
  return
}

}
