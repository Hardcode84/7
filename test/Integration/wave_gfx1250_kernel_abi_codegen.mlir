// RUN: wave-opt %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:       wave-translate --wave-to-amdgpu-asm - > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj -o %t.wave.o %t.s 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj -o %t.reference.o \
// RUN:   %S/Inputs/gfx1250_kernel_abi_reference.s
// RUN: llvm-objcopy --dump-section=.rodata=%t.wave.rodata %t.wave.o
// RUN: llvm-objcopy --dump-section=.rodata=%t.reference.rodata %t.reference.o
// RUN: cmp %t.wave.rodata %t.reference.rodata
// RUN: llvm-objcopy --dump-section=.note=%t.wave.note %t.wave.o
// RUN: llvm-objcopy --dump-section=.note=%t.reference.note %t.reference.o
// RUN: cmp %t.wave.note %t.reference.note
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.wave.o \
// RUN:   | FileCheck %s --check-prefix=DIS
// RUN: llvm-objdump -D -j .rodata --mcpu=gfx1250 %t.wave.o \
// RUN:   | FileCheck %s --check-prefix=KD
// RUN: llvm-readobj --notes %t.wave.o \
// RUN:   | FileCheck %s --check-prefix=META

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: no_scratch:
// ASM-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// ASM-NEXT: v_nop
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// ASM-NEXT: s_mov_b32 s2, ttmp9
// ASM-NEXT: s_lshr_b32 s5, ttmp6, 12
// ASM: s_delay_alu instid0(SALU_CYCLE_1)
// ASM: s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM-NEXT: s_cmp_eq_u32 s5, 0
// ASM-NEXT: s_cselect_b32 s2, s2, s6
// ASM: s_cselect_b32 s3, s3, s6
// ASM: s_cselect_b32 s4, s4, s6
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM: s_add_co_i32 s5, s4, 1
// ASM-NEXT: s_endpgm
// ASM: .amdhsa_kernel no_scratch
// ASM: .amdhsa_enable_private_segment 0
// ASM: .amdhsa_next_free_vgpr 1
// ASM: .amdhsa_next_free_sgpr 7
// ASM: .amdhsa_named_barrier_count 0
// ASM-NOT: .amdhsa_dx10_clamp
// ASM-NOT: .amdhsa_ieee_mode
// ASM-NOT: .amdhsa_workgroup_processor_mode
// ASM-NOT: .amdhsa_shared_vgpr_count
// ASM: .amdhsa_inst_pref_size instprefsize(.Lno_scratch.end-no_scratch)
// ASM-NEXT: .amdhsa_round_robin_scheduling 0
// ASM: .end_amdhsa_kernel
func.func @no_scratch() attributes {wave.kernel} {
  %x = waveamdmachine.s_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1, 2>
  %y = waveamdmachine.s_workgroup_id_y
      : !waveamdmachine.reg<sgpr, 1, 3>
  %z = waveamdmachine.s_workgroup_id_z
      : !waveamdmachine.reg<sgpr, 1, 4>
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %z, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: z_only:
// ASM-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// ASM-NEXT: v_nop
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// ASM-NEXT: s_lshr_b32 s4, ttmp7, 16
// ASM-NEXT: s_lshr_b32 s5, ttmp6, 20
// ASM: s_cselect_b32 s4, s4, s6
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM: s_add_co_i32 s5, s4, 1
// ASM-NEXT: s_endpgm
// ASM: .amdhsa_kernel z_only
// ASM: .amdhsa_system_sgpr_workgroup_id_y 0
// ASM-NEXT: .amdhsa_system_sgpr_workgroup_id_z 1
// ASM: .amdhsa_next_free_sgpr 7
// ASM: .end_amdhsa_kernel
func.func @z_only() attributes {wave.kernel} {
  %z = waveamdmachine.s_workgroup_id_z
      : !waveamdmachine.reg<sgpr, 1, 4>
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %z, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: with_scratch:
// ASM-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// ASM-NEXT: v_nop
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// ASM: .amdhsa_kernel with_scratch
// ASM: .amdhsa_private_segment_fixed_size 8
// ASM: .amdhsa_enable_private_segment 1
// ASM: .amdhsa_named_barrier_count 0
// ASM-NOT: .amdhsa_dx10_clamp
// ASM-NOT: .amdhsa_ieee_mode
// ASM-NOT: .amdhsa_workgroup_processor_mode
// ASM-NOT: .amdhsa_shared_vgpr_count
// ASM: .amdhsa_round_robin_scheduling 0
// ASM: .end_amdhsa_kernel
func.func @with_scratch() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 8 : i64,
    waveamdmachine.uses_flat_scratch = true
  } {
  waveamdmachine.s_endpgm
  return
}

}

// DIS-LABEL: <no_scratch>:
// DIS-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// DIS-NEXT: v_nop
// DIS-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// DIS-NEXT: s_mov_b32 s2, ttmp9
// DIS-NEXT: s_lshr_b32 s5, ttmp6, 12
// DIS: s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
// DIS: s_cselect_b32 s2, s2, s6
// DIS: s_cselect_b32 s3, s3, s6
// DIS: s_cselect_b32 s4, s4, s6
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS-NEXT: s_add_co_i32 s5, s4, 1
// DIS-NEXT: s_endpgm
// DIS-LABEL: <z_only>:
// DIS-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// DIS-NEXT: v_nop
// DIS-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// DIS-NEXT: s_lshr_b32 s4, ttmp7, 16
// DIS: s_cselect_b32 s4, s4, s6
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS-NEXT: s_add_co_i32 s5, s4, 1
// DIS-NEXT: s_endpgm
// DIS-LABEL: <with_scratch>:
// DIS-NEXT: global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
// DIS-NEXT: v_nop
// DIS-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
// DIS: s_endpgm

// KD-LABEL: <no_scratch.kd>:
// KD: .amdhsa_private_segment_fixed_size 0
// KD: .amdhsa_inst_pref_size 2
// KD: .amdhsa_named_barrier_count 0
// KD: .amdhsa_next_free_vgpr 16
// KD: .amdhsa_next_free_sgpr 8
// KD: .amdhsa_round_robin_scheduling 0
// KD: .amdhsa_enable_private_segment 0
// KD: .amdhsa_system_sgpr_workgroup_id_y 1
// KD: .amdhsa_system_sgpr_workgroup_id_z 1
// KD-LABEL: <z_only.kd>:
// KD: .amdhsa_inst_pref_size 1
// KD: .amdhsa_next_free_sgpr 8
// KD: .amdhsa_system_sgpr_workgroup_id_y 0
// KD: .amdhsa_system_sgpr_workgroup_id_z 1
// KD-LABEL: <with_scratch.kd>:
// KD: .amdhsa_private_segment_fixed_size 8
// KD: .amdhsa_inst_pref_size 1
// KD: .amdhsa_named_barrier_count 0
// KD: .amdhsa_next_free_vgpr 16
// KD: .amdhsa_next_free_sgpr 8
// KD: .amdhsa_round_robin_scheduling 0
// KD: .amdhsa_enable_private_segment 1

// META: .name: no_scratch
// META: .private_segment_fixed_size: 0
// META: .sgpr_count: 7
// META: .vgpr_count: 1
// META: .name: z_only
// META: .private_segment_fixed_size: 0
// META: .sgpr_count: 7
// META: .vgpr_count: 1
// META: .name: with_scratch
// META: .private_segment_fixed_size: 8
// META: .sgpr_count: 6
// META: .vgpr_count: 1
