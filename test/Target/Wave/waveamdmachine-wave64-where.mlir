// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// SELECT-LABEL: func.func @where_wave64_else
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.s_and_saveexec_b64
// SELECT: waveamdmachine.s_andn2_exec_b64
// SELECT: waveamdmachine.s_mov_exec_b64
//
// ASM-LABEL: where_wave64_else:
// ASM-NOT: s_load_dword
// ASM: s_and_saveexec_b64 [[SAVE:s\[[0-9]+:[0-9]+\]]], s[4:5]
// ASM: s_andn2_b64 exec, [[SAVE]], s[4:5]
// ASM: s_mov_b64 exec, [[SAVE]]
// ASM: .amdhsa_kernel where_wave64_else
// ASM: .amdhsa_user_sgpr_kernarg_preload_length 4
// ASM: .amdhsa_user_sgpr_kernarg_preload_offset 0
// ASM: .wavefront_size: 64
func.func @where_wave64_else(%out: !wave.ptr<#wave.global, i32>,
                             %active: !wave.mask<64>)
    attributes {wave.kernel} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume_range %wi_raw, [0, 63] : !wave.simd<i32, 64>
  %one = arith.constant 1 : i32
  %vone = wave.splat %one : i32 -> !wave.simd<i32, 64>
  %other = wave.addi %wi, %vone
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  wave.where %active {
    %tok0 = wave.store %wi -> %ptrs
        : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } otherwise {
    %tok1 = wave.store %other -> %ptrs
        : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}
