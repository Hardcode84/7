// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-wavemachine --waveamd-abi-lowering --waveamd-reg-alloc %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @mfma_f16xf32_kernel
// SELECT: wavemachine.mfma_f32_16x16x16_f16{{.*}} : (!wavemachine.reg<vgpr, 2>, !wavemachine.reg<vgpr, 2>, !wavemachine.reg<vgpr, 4>) -> !wavemachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_f16xf32_kernel
// PIPELINE: wavemachine.mfma_f32_16x16x16_f16{{.*}} -> !wavemachine.reg<vgpr, 4,

// ASM-LABEL: mfma_f16xf32_kernel:
// ASM: v_mfma_f32_16x16x16_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]]
func.func @mfma_f16xf32_kernel(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 2>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 2>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  %result = waveamd.mma "mfma.f32.16x16x16.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 2>,
        !waveamd.fragment<1, f16, 16, 16, 32, 2>,
        !waveamd.fragment<2, f32, 16, 16, 32, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  %store_token = waveamd.fragment_store %result -> %out
      : (!waveamd.fragment<2, f32, 16, 16, 32, 4>,
         !wave.ptr<i32, #wave.global>) -> !wave.mem.token
  return
}

}
