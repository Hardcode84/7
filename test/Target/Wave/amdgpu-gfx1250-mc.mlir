// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=META
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: cluster_ids:
// ASM: s_mov_b32 s6, ttmp9
// ASM: s_and_b32 s7, ttmp7, 0xffff
// ASM: s_lshr_b32 s8, ttmp7, 16
// ASM: s_and_b32 s9, ttmp6, 15
// ASM: s_bfe_u32 s10, ttmp6, 0x40004
// ASM: s_bfe_u32 s11, ttmp6, 0x40008
// ASM: s_bfe_u32 s12, ttmp6, 0x4000c
// ASM: s_bfe_u32 s13, ttmp6, 0x40010
// ASM: s_bfe_u32 s14, ttmp6, 0x40014
// ASM: s_endpgm
// ASM: .amdhsa_system_sgpr_workgroup_id_y 1
// ASM: .amdhsa_system_sgpr_workgroup_id_z 1
// META-COUNT-1: .cluster_dims: [ 2, 2, 1 ]
// DIS-LABEL: <cluster_ids>:
// DIS: s_mov_b32 s6, ttmp9
// DIS: s_and_b32 s7, ttmp7, 0xffff
// DIS: s_lshr_b32 s8, ttmp7, 16
// DIS: s_and_b32 s9, ttmp6, 15
// DIS: s_bfe_u32 s10, ttmp6, 0x40004
// DIS: s_bfe_u32 s11, ttmp6, 0x40008
// DIS: s_bfe_u32 s12, ttmp6, 0x4000c
// DIS: s_bfe_u32 s13, ttmp6, 0x40010
// DIS: s_bfe_u32 s14, ttmp6, 0x40014
// DIS: s_endpgm
func.func @cluster_ids() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 2, 1>,
    waveamdmachine.sgpr_count = 15 : i64
  } {
  %cluster_x = waveamdmachine.s_cluster_id_x
      : !waveamdmachine.reg<sgpr, 1, 6>
  %cluster_y, %cluster_y_scc = waveamdmachine.s_cluster_id_y
      : !waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.reg<scc, 1>
  %cluster_z, %cluster_z_scc = waveamdmachine.s_cluster_id_z
      : !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.reg<scc, 1>
  %local_x, %local_x_scc = waveamdmachine.s_cluster_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1, 9>, !waveamdmachine.reg<scc, 1>
  %local_y, %local_y_scc = waveamdmachine.s_cluster_workgroup_id_y
      : !waveamdmachine.reg<sgpr, 1, 10>, !waveamdmachine.reg<scc, 1>
  %local_z, %local_z_scc = waveamdmachine.s_cluster_workgroup_id_z
      : !waveamdmachine.reg<sgpr, 1, 11>, !waveamdmachine.reg<scc, 1>
  %max_x, %max_x_scc = waveamdmachine.s_cluster_workgroup_max_id_x
      : !waveamdmachine.reg<sgpr, 1, 12>, !waveamdmachine.reg<scc, 1>
  %max_y, %max_y_scc = waveamdmachine.s_cluster_workgroup_max_id_y
      : !waveamdmachine.reg<sgpr, 1, 13>, !waveamdmachine.reg<scc, 1>
  %max_z, %max_z_scc = waveamdmachine.s_cluster_workgroup_max_id_z
      : !waveamdmachine.reg<sgpr, 1, 14>, !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: fixed_cluster_workgroup_id:
// ASM: s_mov_b32 s2, ttmp9
// ASM-NEXT: s_and_b32 s5, ttmp6, 15
// ASM-NEXT: s_mul_i32 s2, s2, 2
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM-NEXT: s_add_co_i32 s2, s2, s5
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM: s_endpgm
// ASM: .amdhsa_next_free_sgpr 6
// DIS-LABEL: <fixed_cluster_workgroup_id>:
// DIS: s_mov_b32 s2, ttmp9
// DIS-NEXT: s_and_b32 s5, ttmp6, 15
// DIS-NEXT: s_mul_i32 s2, s2, 2
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS-NEXT: s_add_co_i32 s2, s2, s5
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS: s_endpgm
func.func @fixed_cluster_workgroup_id() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 1, 1>
  } {
  %x = waveamdmachine.s_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1, 2>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: scalar_vector_control:
// ASM: s_add_co_i32 s5, s4, 1
// ASM: s_cbranch_scc1 control_taken
// ASM: control_taken:
// ASM: v_add_nc_u32_e32 v2, v0, v1
// ASM: v_cmp_eq_u32_e64 vcc_lo, v2, v1
// ASM: s_and_saveexec_b32 s6, s5
// ASM: s_mov_b32 exec_lo, s6
// ASM: s_endpgm
// DIS-LABEL: <scalar_vector_control>:
// DIS: s_add_co_i32 s5, s4, 1
// DIS: s_cbranch_scc1
// DIS: v_add_nc_u32_e32 v2, v0, v1
// DIS: v_cmp_eq_u32_e64 vcc_lo, v2, v1
// DIS: s_and_saveexec_b32 s6, s5
// DIS: s_mov_b32 exec_lo, s6
// DIS: s_endpgm
func.func @scalar_vector_control() {
  %s4 = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 1, 4>
  %v0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %v1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s4, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc
      : !waveamdmachine.reg<scc, 1>, "control_taken"
  waveamdmachine.label "control_taken"
  %vsum = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 2>
  %mask, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %vsum, %v1
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 7>,
            !waveamdmachine.reg<vcc, 1>)
  %saved, %exec_scc = waveamdmachine.s_and_saveexec_b32 %sum
      : (!waveamdmachine.reg<sgpr, 1, 5>)
        -> (!waveamdmachine.reg<sgpr, 1, 6>,
            !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_mov_exec_lo %saved
      : (!waveamdmachine.reg<sgpr, 1, 6>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: memory_and_sync:
// ASM: s_load_b32 s12, s[0:1], 0x0{{$}}
// ASM: global_load_b32 v3, v0, s[0:1]{{$}}
// ASM: global_store_b32 v0, v3, s[0:1]{{$}}
// ASM: buffer_load_b32 v4, v0, s[8:11], null offen{{$}}
// ASM: buffer_store_b32 v4, v0, s[8:11], null offen{{$}}
// ASM: buffer_load_d16_u8 v7, v0, s[8:11], null offen{{$}}
// ASM: buffer_load_d16_hi_u8 v7, v0, s[8:11], null offen{{$}}
// ASM: ds_load_b32 v5, v0
// ASM: ds_store_b32 v0, v5
// ASM: scratch_load_b32 v6, off, s13 nv
// ASM: scratch_store_b32 off, v6, s13 nv
// ASM: s_barrier_signal -1
// ASM-NEXT: s_barrier_wait -1
// ASM-NEXT: s_endpgm
// DIS-LABEL: <memory_and_sync>:
// DIS: s_load_b32 s12, s[0:1], 0x0{{[[:space:]]*//}}
// DIS: global_load_b32 v3, v0, s[0:1]{{[[:space:]]*//}}
// DIS: global_store_b32 v0, v3, s[0:1]{{[[:space:]]*//}}
// DIS: buffer_load_b32 v4, v0, s[8:11], null offen{{[[:space:]]*//}}
// DIS: buffer_store_b32 v4, v0, s[8:11], null offen{{[[:space:]]*//}}
// DIS: buffer_load_d16_u8 v7, v0, s[8:11], null offen{{[[:space:]]*//}}
// DIS: buffer_load_d16_hi_u8 v7, v0, s[8:11], null offen{{[[:space:]]*//}}
// DIS: ds_load_b32 v5, v0
// DIS: ds_store_b32 v0, v5
// DIS: scratch_load_b32 v6, off, s13 nv
// DIS: scratch_store_b32 off, v6, s13 nv
// DIS: s_barrier_signal -1
// DIS-NEXT: s_barrier_wait 0xffff
// DIS-NEXT: s_endpgm
func.func @memory_and_sync() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %desc = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 4, 8>
  %saddr = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 1, 13>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 1, 12>
  %global = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  waveamdmachine.global_store_b32 %off, %global, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  %buffer = waveamdmachine.buffer_load_b32 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 4, 8>,
         !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  waveamdmachine.buffer_store_b32 %off, %buffer, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<sgpr, 4, 8>,
         !waveamdmachine.imm) -> ()
  %d16_lo = waveamdmachine.buffer_load_u8_d16 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 4, 8>,
         !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  %d16_hi = waveamdmachine.buffer_load_u8_d16_hi
      %off, %d16_lo, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 7>,
         !waveamdmachine.reg<sgpr, 4, 8>,
         !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  %lds = waveamdmachine.ds_load_b32 %off
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  waveamdmachine.ds_store_b32 %off, %lds
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 5>) -> ()
  %scratch = waveamdmachine.scratch_load_b32 %zero, %saddr
      : (!waveamdmachine.imm,
         !waveamdmachine.reg<sgpr, 1, 13>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  waveamdmachine.scratch_store_b32 %zero, %scratch, %saddr
      : (!waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 6>,
         !waveamdmachine.reg<sgpr, 1, 13>) -> ()
  %barrier_root = waveamdmachine.token : !waveamdmachine.mem.token
  %barrier_signal = waveamdmachine.s_barrier_signal %barrier_root
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %barrier_ready = waveamdmachine.s_barrier_wait %barrier_signal
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: split_barrier_phases:
// ASM: s_barrier_signal -1
// ASM-NEXT: v_add_nc_u32_e32 v2, v0, v1
// ASM-NEXT: s_barrier_wait -1
// ASM-NEXT: s_endpgm
// DIS-LABEL: <split_barrier_phases>:
// DIS: s_barrier_signal -1
// DIS-NEXT: v_add_nc_u32_e32 v2, v0, v1
// DIS-NEXT: s_barrier_wait 0xffff
// DIS-NEXT: s_endpgm
func.func @split_barrier_phases() {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %signal = waveamdmachine.s_barrier_signal %root
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 2>
  %wait = waveamdmachine.s_barrier_wait %signal
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: cluster_barrier_instructions:
// ASM: s_cmp_eq_u32 0, 0
// ASM-NEXT: s_barrier_signal_isfirst -1
// ASM-NEXT: s_barrier_wait -1
// ASM-NEXT: s_barrier_signal -3
// ASM-NEXT: s_barrier_wait -3
// ASM-NEXT: s_endpgm
// DIS-LABEL: <cluster_barrier_instructions>:
// DIS: s_cmp_eq_u32 0, 0
// DIS-NEXT: s_barrier_signal_isfirst -1
// DIS-NEXT: s_barrier_wait 0xffff
// DIS-NEXT: s_barrier_signal -3
// DIS-NEXT: s_barrier_wait 0xfffd
// DIS-NEXT: s_endpgm
func.func @cluster_barrier_instructions() {
  %seed = waveamdmachine.s_cmp_eq_u32_barrier_seed
      : !waveamdmachine.reg<scc, 1>
  %first, %local = waveamdmachine.s_barrier_signal_isfirst %seed
      : (!waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %local_ready = waveamdmachine.s_barrier_wait %local
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %cluster = waveamdmachine.s_barrier_signal %local_ready scope cluster
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ready = waveamdmachine.s_barrier_wait %cluster scope cluster
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: exact_extensions:
// ASM: v_cvt_pk_rtz_f16_f32_e32 v3, v0, v1
// ASM: v_pk_add_f16 v4, v3, v0
// ASM: v_bitop3_b32 v5, v0, v1, v2 bitop3:0x6a
// ASM: s_endpgm
// DIS-LABEL: <exact_extensions>:
// DIS: v_cvt_pk_rtz_f16_f32_e32 v3, v0, v1
// DIS: v_pk_add_f16 v4, v3, v0
// DIS: v_bitop3_b32 v5, v0, v1, v2 bitop3:0x6a
// DIS: s_endpgm
func.func @exact_extensions() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %c = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  %rtz = waveamdmachine.v_cvt_pk_rtz_f16_f32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %sum = waveamdmachine.v_pk_add_f16 %rtz, %a
      : (!waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %bits = waveamdmachine.v_bitop3_b32 %a, %b, %c bitop3 106
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: wmma_f16_tied:
// ASM: v_wmma_f32_16x16x32_f16 v[16:23], v[0:7], v[8:15], v[16:23]
// DIS-LABEL: <wmma_f16_tied>:
// DIS: v_wmma_f32_16x16x32_f16 v[16:23], v[0:7], v[8:15], v[16:23]
func.func @wmma_f16_tied() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 16>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: wmma_f16_distinct:
// ASM: v_wmma_f32_16x16x32_f16 v[24:31], v[0:7], v[8:15], v[16:23]
// DIS-LABEL: <wmma_f16_distinct>:
// DIS: v_wmma_f32_16x16x32_f16 v[24:31], v[0:7], v[8:15], v[16:23]
func.func @wmma_f16_distinct() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 24>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: wmma_bf16_tied:
// ASM: v_wmma_f32_16x16x32_bf16 v[16:23], v[0:7], v[8:15], v[16:23]
// DIS-LABEL: <wmma_bf16_tied>:
// DIS: v_wmma_f32_16x16x32_bf16 v[16:23], v[0:7], v[8:15], v[16:23]
func.func @wmma_bf16_tied() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  %result = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 16>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: wmma_bf16_distinct:
// ASM: v_wmma_f32_16x16x32_bf16 v[24:31], v[0:7], v[8:15], v[16:23]
// DIS-LABEL: <wmma_bf16_distinct>:
// DIS: v_wmma_f32_16x16x32_bf16 v[24:31], v[0:7], v[8:15], v[16:23]
func.func @wmma_bf16_distinct() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 0>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 8>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 16>
  %result = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 0>,
         !waveamdmachine.reg<vgpr, 8, 8>,
         !waveamdmachine.reg<vgpr, 8, 16>)
     -> !waveamdmachine.reg<vgpr, 8, 24>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: tdm_sgpr_tuple_base_four:
// ASM: tensor_load_to_lds s[0:3], s[4:11]
// DIS-LABEL: <tdm_sgpr_tuple_base_four>:
// DIS: tensor_load_to_lds s[0:3], s[4:11]
func.func @tdm_sgpr_tuple_base_four() {
  %d0 = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 4, 0>
  %d1 = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 8, 4>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.reg<sgpr, 8, 4>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
