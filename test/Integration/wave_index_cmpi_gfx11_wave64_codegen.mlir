// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -mattr=+wavefrontsize64 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.wavefront_size = 64 : i64} {

// ASM-LABEL: index_cmpi_gfx11_wave64_codegen:
// ASM: s_cmp_ge_i32
// ASM: s_and_saveexec_b64
// ASM: global_store_b32
// ASM: .amdhsa_kernel index_cmpi_gfx11_wave64_codegen
// ASM-NOT: .amdhsa_wavefront_size32
// ASM: .wavefront_size: 64
func.func @index_cmpi_gfx11_wave64_codegen(
    %out: !wave.ptr<#wave.global, i32>, %lhs: index, %rhs: index)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlhs = wave.splat %lhs : index -> !wave.simd<index, 64>
  %vrhs = wave.splat %rhs : index -> !wave.simd<index, 64>
  %active = wave.cmpi sge %vlhs, %vrhs
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}
