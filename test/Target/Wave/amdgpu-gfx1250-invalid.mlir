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
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

// expected-error @below {{wave-to-amdgpu-asm target does not support clusters}}
func.func @cluster_dims_without_cluster_target() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 1, 1>
  } {
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @oversized_dependency_wait() {
  // expected-error @below {{s_wait_alu dependency count out of range}}
  waveamdmachine.s_wait_alu vm_vsrc(8)
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

func.func @oversized_tensor_wait() {
  // expected-error @below {{tensorcnt value 64 exceeds target maximum 63}}
  waveamdmachine.s_waitcnt_split tensorcnt(64)
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @oversized_async_wait() {
  // expected-error @below {{asynccnt value 64 exceeds target maximum 63}}
  waveamdmachine.s_waitcnt_split asynccnt(64)
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
  // expected-error @below {{wave-to-amdgpu-asm found VGPR tuple at base 1 with width 2 unsupported by target register classes}}
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

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @wmma_wrong_tuple_width() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  // expected-error @below {{A operand must be !waveamdmachine.reg<vgpr, 8>}}
  %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 24>
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

func.func @wmma_wrong_target() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  // expected-error @below {{gfx1250 WMMA unsupported on target}}
  %result = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 24>
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @packed_delay_crosses_label() {
  %delay = waveamdmachine.imm 273 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{packed s_delay_alu crosses a label}}
  waveamdmachine.s_delay_alu %delay
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.label "packed_target"
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @packed_delay_invalid_id() {
  %delay = waveamdmachine.imm 1537 : !waveamdmachine.imm
  // expected-error @below {{invalid packed s_delay_alu instruction ID}}
  waveamdmachine.s_delay_alu %delay
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @packed_delay_crosses_control_flow() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %delay = waveamdmachine.imm 273 : !waveamdmachine.imm
  // expected-error @below {{packed s_delay_alu crosses control flow}}
  waveamdmachine.s_delay_alu %delay
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.uniform_if %cond {
    waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @tdm_illegal_sgpr_tuple_base() {
  %d0 = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 4, 0>
  // expected-error @below {{wave-to-amdgpu-asm found SGPR tuple at base 6 with width 8 unsupported by target register classes}}
  %d1 = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 8, 6>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 8, 6>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unsupported_named_sgpr_tuple() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{LLVM MC has no SGPR tuple at base 6 with width 8 on gfx1250}}
  waveamdmachine.s_mov_b32 "s[6:13]", %zero
      : (!waveamdmachine.imm) -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unmaterialized_workgroup_barrier() {
  // expected-error @below {{s_barrier must be materialized before MC}}
  waveamdmachine.s_barrier : () -> ()
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @unmaterialized_cluster_barrier() {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{cluster_barrier must be materialized before MC}}
  %ready = waveamdmachine.cluster_barrier %root
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

func.func @unsupported_set_priority_inc_wg() {
  // expected-error @below {{s_setprio_inc_wg unsupported on target}}
  waveamdmachine.s_setprio_inc_wg 100
  return
}

}
