// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm --verify-diagnostics \
// RUN:     --split-input-file %s

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @old_wait() {
  // expected-error @below {{s_waitcnt requires split-wait lowering}}
  waveamdmachine.s_waitcnt vmcnt(0)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @oversized_split_wait() {
  // expected-error @below {{loadcnt value 64 exceeds target maximum 63}}
  waveamdmachine.s_waitcnt_split loadcnt(64)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @old_store_wait() {
  // expected-error @below {{s_waitcnt_vscnt requires split-wait lowering}}
  waveamdmachine.s_waitcnt_vscnt vscnt(0)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @old_lds_dma() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %m0_source = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 1, 2>
  %m0 = waveamdmachine.s_mov_m0 %m0_source
      : (!waveamdmachine.reg<sgpr, 1, 2>)
        -> !waveamdmachine.m0
  %dependency = waveamdmachine.token
      : !waveamdmachine.mem.token
  // expected-error @below {{no legacy VMEM-to-LDS MC mapping for target gfx1250: waveamdmachine.global_load_lds_b32}}
  %token = waveamdmachine.global_load_lds_b32
      %off, %base, %m0 after %dependency
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unsupported_cache() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  // expected-error @below {{gfx1250 load cache modifier is not implemented: cg}}
  %value = waveamdmachine.global_load_b32 %off, %base
      {cache = #waveamd.load_cache<cg>}
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wide_switch_immediate() {
  %mode = waveamdmachine.imm 65536 : !waveamdmachine.imm
  // expected-error @below {{s_set_vgpr_msb immediate must fit u16}}
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @truncated_switch_immediate() {
  %mode = waveamdmachine.imm 4294967296 : !waveamdmachine.imm
  // expected-error @below {{s_set_vgpr_msb immediate must fit u16}}
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @negative_switch_immediate() {
  %mode = waveamdmachine.imm -1 : !waveamdmachine.imm
  // expected-error @below {{s_set_vgpr_msb immediate must fit u16}}
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wide_setreg_value() {
  // expected-error @below {{value must fit u32}}
  waveamdmachine.s_setreg_imm32_b32
      value 4294967296 hwreg(1, 0, 32)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wide_setreg_hwreg() {
  // expected-error @below {{hardware register ID exceeds LLVM encoding}}
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(64, 0, 32)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wide_setreg_offset() {
  // expected-error @below {{offset exceeds LLVM encoding}}
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(1, 32, 1)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @invalid_setreg_width() {
  // expected-error @below {{width must be in [1, 32 - offset]}}
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(1, 31, 2)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @short_clause() {
  // expected-error @below {{length must be in [2, 63]}}
  waveamdmachine.s_clause length 1 breaks 0
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @negative_clause_length() {
  // expected-error @below {{length must be in [2, 63]}}
  waveamdmachine.s_clause length -1 breaks 0
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wide_clause_breaks() {
  // expected-error @below {{breaks must be in [0, 15]}}
  waveamdmachine.s_clause length 2 breaks 16
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @negative_clause_breaks() {
  // expected-error @below {{breaks must be in [0, 15]}}
  waveamdmachine.s_clause length 2 breaks -1
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @out_of_range_vgpr() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  // expected-error @below {{wave-to-amdgpu-asm found VGPR register range [1024, 1025) beyond target addressable count 1024}}
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 1024>
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unmapped_high_vgpr() {
  %src = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 300>
  // expected-error @below {{high VGPR operand 1 (MSBs 1) of S_MOV_B32_gfx12 emitted by waveamdmachine.s_mov_b32 has no LLVM VGPR-window mapping}}
  waveamdmachine.s_mov_b32 "s0", %src
      : (!waveamdmachine.reg<vgpr, 1, 300>) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unaligned_wide_vgpr() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  // expected-error @below {{wave-to-amdgpu-asm found VGPR tuple at v1 with width 2 misaligned; target requires base alignment 2}}
  %value = waveamdmachine.global_load_b64 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 2, 1>
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

func.func @switch_without_windows() {
  %mode = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{s_set_vgpr_msb unsupported on target}}
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// expected-error @below {{wave-to-amdgpu-asm sgpr_count 5 does not cover kernel ABI register count 6}}
func.func @short_sgpr_count() attributes {
    wave.kernel,
    waveamdmachine.sgpr_count = 5 : i64
  } {
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// expected-error @below {{wave-to-amdgpu-asm sgpr_count 6 does not cover kernel ABI register count 7}}
func.func @short_cluster_workgroup_sgpr_count() attributes {
    wave.kernel,
    waveamdmachine.sgpr_count = 6 : i64
  } {
  %x = waveamdmachine.s_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1, 2>
  waveamdmachine.s_endpgm
  return
}

}
