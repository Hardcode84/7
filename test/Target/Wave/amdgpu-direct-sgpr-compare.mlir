// RUN: split-file %s %t
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx803.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX803
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx803.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx803 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx942.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX942
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx942.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx950.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX950
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx950.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx1100-wave32.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX1100-W32
// RUN: wave-opt --waveamd-scalar-mask-preschedule %t/gfx1100-wave32.mlir \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// GFX803-LABEL: direct_gfx803:
// GFX803: v_cmp_ge_i32_e64 s[4:5], v0, v1
// GFX803-NOT: s_mov_b64
// GFX803: .size direct_gfx803
// GFX803-LABEL: direct_f32_gfx803:
// GFX803: v_cmp_lt_f32_e64 s[8:9], v0, v1
// GFX803-NOT: s_mov_b64
// GFX803: .size direct_f32_gfx803
// GFX803-LABEL: narrow_gfx803:
// GFX803: v_cmp_lt_u32
// GFX803-NEXT: s_mov_b32 s6, vcc_lo

// GFX942-LABEL: direct_gfx942:
// GFX942: v_cmp_le_u32_e64 s[4:5], v0, v1
// GFX942-NOT: s_mov_b64
// GFX942: .size direct_gfx942
// GFX942-LABEL: direct_f32_gfx942:
// GFX942: v_cmp_lt_f32_e64 s[8:9], v0, v1
// GFX942-NOT: s_mov_b64
// GFX942: .size direct_f32_gfx942

// GFX950-LABEL: direct_gfx950:
// GFX950: v_cmp_ne_u32_e64 s[4:5], v0, v1
// GFX950-NOT: s_mov_b64
// GFX950: .size direct_gfx950
// GFX950-LABEL: direct_f32_gfx950:
// GFX950: v_cmp_lt_f32_e64 s[8:9], v0, v1
// GFX950-NOT: s_mov_b64
// GFX950: .size direct_f32_gfx950

// GFX1100-W32-LABEL: direct_gfx1100_wave32:
// GFX1100-W32: v_cmp_lt_i32_e64 s4, v0, v1
// GFX1100-W32-NOT: s_mov_b32
// GFX1100-W32: .size direct_gfx1100_wave32
// GFX1100-W32-LABEL: direct_f32_gfx1100_wave32:
// GFX1100-W32: v_cmp_lt_f32_e64 s8, v0, v1
// GFX1100-W32-NOT: s_mov_b32
// GFX1100-W32: .size direct_f32_gfx1100_wave32
// GFX1100-W32-LABEL: wide_gfx1100_wave32:
// GFX1100-W32: v_cmp_ge_u32
// GFX1100-W32-NEXT: s_mov_b64 s[4:5], vcc

//--- gfx803.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {
  func.func @direct_gfx803(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 4> {
    %mask, %vcc = waveamdmachine.v_cmp_ge_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 4>
  }

  func.func @direct_f32_gfx803(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 8> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_f32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 8>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 8>
  }

  func.func @narrow_gfx803(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 1, 6> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 6>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 1, 6>
  }
}

//--- gfx942.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
  func.func @direct_gfx942(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 4> {
    %mask, %vcc = waveamdmachine.v_cmp_le_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 4>
  }

  func.func @direct_f32_gfx942(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 8> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_f32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 8>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 8>
  }
}

//--- gfx950.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @direct_gfx950(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 4> {
    %mask, %vcc = waveamdmachine.v_cmp_ne_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 4>
  }

  func.func @direct_f32_gfx950(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 8> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_f32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 8>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 8>
  }
}

//--- gfx1100-wave32.mlir

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @direct_gfx1100_wave32(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 1, 4> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_i32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 4>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 1, 4>
  }

  func.func @direct_f32_gfx1100_wave32(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 1, 8> {
    %mask, %vcc = waveamdmachine.v_cmp_lt_f32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 8>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 1, 8>
  }

  func.func @wide_gfx1100_wave32(
      %a: !waveamdmachine.reg<vgpr, 1, 0>,
      %b: !waveamdmachine.reg<vgpr, 1, 1>)
      -> !waveamdmachine.reg<sgpr, 2, 4> {
    %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>,
            !waveamdmachine.reg<vcc, 1>)
    return %mask : !waveamdmachine.reg<sgpr, 2, 4>
  }
}
