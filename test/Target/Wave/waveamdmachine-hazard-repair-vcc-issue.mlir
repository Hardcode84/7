// RUN: split-file %s %t
// RUN: wave-opt %t/gfx803.mlir --waveamd-hazard-repair | FileCheck %s --check-prefix=GFX803
// RUN: wave-opt %t/gfx1100-wave32.mlir --waveamd-hazard-repair | FileCheck %s --check-prefix=GFX1100-W32
// RUN: wave-opt %t/gfx1100-wave64.mlir --waveamd-hazard-repair | FileCheck %s --check-prefix=GFX1100-W64

// GFX803-LABEL: func.func @repair_gfx803
// GFX803: [[MASK:%.*]] = waveamdmachine.v_cmp_eq_u32
// GFX803-NEXT: [[VCC:%.*]] = waveamdmachine.s_mov_vcc_b32
// GFX803-NEXT: [[FILL0:%.*]] = waveamdmachine.v_xor_b32
// GFX803-NEXT: [[FILL1:%.*]] = waveamdmachine.v_xor_b32
// GFX803-NEXT: [[FILL2:%.*]] = waveamdmachine.v_xor_b32
// GFX803-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// GFX803-NEXT: [[FILL3:%.*]] = waveamdmachine.v_xor_b32

// GFX1100-W32-LABEL: func.func @repair_gfx1100_wave32
// GFX1100-W32: [[MASK:%.*]] = waveamdmachine.v_cmp_eq_u32
// GFX1100-W32-NEXT: [[VCC:%.*]] = waveamdmachine.s_mov_vcc_b32
// GFX1100-W32-NEXT: [[FILL0:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W32-NEXT: [[FILL1:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W32-NEXT: [[FILL2:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W32-NEXT: [[FILL3:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W32-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.buffer_load_b32

// GFX1100-W64-LABEL: func.func @repair_gfx1100_wave64
// GFX1100-W64: [[MASK:%.*]] = waveamdmachine.v_cmp_eq_u32
// GFX1100-W64-NEXT: [[VCC:%.*]] = waveamdmachine.s_mov_vcc_b32
// GFX1100-W64-NEXT: [[FILL0:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W64-NEXT: [[FILL1:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W64-NEXT: [[FILL2:%.*]] = waveamdmachine.v_xor_b32
// GFX1100-W64-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// GFX1100-W64-NEXT: [[FILL3:%.*]] = waveamdmachine.v_xor_b32

//--- gfx803.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {
  func.func @repair_gfx803(
      %x: !waveamdmachine.reg<vgpr, 1, 0>,
      %y: !waveamdmachine.reg<vgpr, 1, 1>,
      %off: !waveamdmachine.reg<vgpr, 1, 2>,
      %base: !waveamdmachine.reg<sgpr, 2, 6>,
      %flag: !waveamdmachine.reg<sgpr, 1, 4>,
      %dep: !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>) {
    %mask = waveamdmachine.v_cmp_eq_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<sgpr, 2, 20>
    %vcc = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    %loaded, %tok = waveamdmachine.global_load_b32 %off, %mask after %dep
        : (!waveamdmachine.reg<vgpr, 1, 2>,
           !waveamdmachine.reg<sgpr, 2, 20>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 30>,
              !waveamdmachine.mem.token)
    %fill0 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 10>
    %fill1 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 11>
    %fill2 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 12>
    %fill3 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 13>
    return %fill0, %fill1, %fill2, %fill3, %loaded
        : !waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>
  }
}

//--- gfx1100-wave32.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @repair_gfx1100_wave32(
      %x: !waveamdmachine.reg<vgpr, 1, 0>,
      %y: !waveamdmachine.reg<vgpr, 1, 1>,
      %off: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 8>,
      %flag: !waveamdmachine.reg<sgpr, 1, 4>,
      %dep: !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>) {
    %soffset = waveamdmachine.v_cmp_eq_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<sgpr, 1, 20>
    %vcc = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    %loaded, %tok = waveamdmachine.buffer_load_b32
        %off, %desc, %soffset after %dep
        : (!waveamdmachine.reg<vgpr, 1, 2>,
           !waveamdmachine.reg<sgpr, 4, 8>,
           !waveamdmachine.reg<sgpr, 1, 20>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 30>,
              !waveamdmachine.mem.token)
    %fill0 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 10>
    %fill1 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 11>
    %fill2 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 12>
    %fill3 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 13>
    return %fill0, %fill1, %fill2, %fill3, %loaded
        : !waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>
  }
}

//--- gfx1100-wave64.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.wavefront_size = 64 : i64} {
  func.func @repair_gfx1100_wave64(
      %x: !waveamdmachine.reg<vgpr, 1, 0>,
      %y: !waveamdmachine.reg<vgpr, 1, 1>,
      %off: !waveamdmachine.reg<vgpr, 1, 2>,
      %base: !waveamdmachine.reg<sgpr, 2, 6>,
      %flag: !waveamdmachine.reg<sgpr, 1, 4>,
      %dep: !waveamdmachine.mem.token)
      -> (!waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>) {
    %mask = waveamdmachine.v_cmp_eq_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<sgpr, 2, 20>
    %vcc = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    %loaded, %tok = waveamdmachine.global_load_b32 %off, %mask after %dep
        : (!waveamdmachine.reg<vgpr, 1, 2>,
           !waveamdmachine.reg<sgpr, 2, 20>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1, 30>,
              !waveamdmachine.mem.token)
    %fill0 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 10>
    %fill1 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 11>
    %fill2 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 12>
    %fill3 = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>)
          -> !waveamdmachine.reg<vgpr, 1, 13>
    return %fill0, %fill1, %fill2, %fill3, %loaded
        : !waveamdmachine.reg<vgpr, 1, 10>,
          !waveamdmachine.reg<vgpr, 1, 11>,
          !waveamdmachine.reg<vgpr, 1, 12>,
          !waveamdmachine.reg<vgpr, 1, 13>,
          !waveamdmachine.reg<vgpr, 1, 30>
  }
}
