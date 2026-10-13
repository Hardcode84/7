// RUN: wave-opt --wave-lower-symbolic-memory %s | FileCheck %s --check-prefix=LOWER
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// LOWER-LABEL: func.func @recurrence
// LOWER: scf.for
// LOWER: wave.index_expr <"Mod(4*
// LOWER: wave.load
// LOWER: wave.index_expr <"Mod(4*
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter

// ASM-LABEL: recurrence:
// ASM: buffer_load_dword
// ASM: buffer_store_dword
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @recurrence(%src: !wave.ptr<#wave.global, i32>,
      %dst: !wave.ptr<#wave.global, i32>, %stride: i32) -> !wave.mem.token
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %zero = arith.constant 0 : i32
    %one = arith.constant 1 : i32
    %four = arith.constant 4 : i32
    %range = arith.constant 2147483647 : i32
    %srcbuf = waveamd.make_buffer %src, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %dstbuf = waveamd.make_buffer %dst, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %lane = wave.lane_id : !wave.simd<i32, 64>
    %delta = wave.splat %stride : i32 -> !wave.simd<i32, 64>
    %seed = wave.token : !wave.mem.token
    %done:2 = scf.for %i = %zero to %four step %one
        iter_args(%offset = %lane, %dep = %seed)
        -> (!wave.simd<i32, 64>, !wave.mem.token) : i32 {
      %value, %read = wave.gather %srcbuf mapping
          <bit_offset = <"8*Mod(4*offset, 4294967296)">>
          bindings ["offset"](%offset) after %dep
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>,
             !wave.mem.token)
          -> (!wave.simd<vector<1xi32>, 64>, !wave.mem.token)
      %stored = wave.scatter %value to %dstbuf mapping
          <bit_offset = <"8*Mod(4*offset, 4294967296)">>
          bindings ["offset"](%offset) after %read
          : (!wave.simd<vector<1xi32>, 64>, !wave.ptr<#waveamd.buffer, i32>,
             !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %next = wave.binary addi %offset, %delta
          : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      scf.yield %next, %stored : !wave.simd<i32, 64>, !wave.mem.token
    }
    return %done#1 : !wave.mem.token
  }
}
