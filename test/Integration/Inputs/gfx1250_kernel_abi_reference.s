	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
	.amdhsa_code_object_version 6

	.globl	no_scratch
	.p2align	8
	.type	no_scratch,@function
no_scratch:
	global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
	v_nop
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
	s_mov_b32 s2, ttmp9
	s_lshr_b32 s5, ttmp6, 12
	s_lshr_b32 s6, ttmp6, 0
	s_and_b32 s5, s5, 15
	s_and_b32 s6, s6, 15
	s_add_co_i32 s5, s5, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s5, s2, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s6, s6, s5
	s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s2, s2, s6
	s_and_b32 s3, ttmp7, 0xffff
	s_lshr_b32 s5, ttmp6, 16
	s_lshr_b32 s6, ttmp6, 4
	s_and_b32 s5, s5, 15
	s_and_b32 s6, s6, 15
	s_add_co_i32 s5, s5, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s5, s3, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s6, s6, s5
	s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s3, s3, s6
	s_lshr_b32 s4, ttmp7, 16
	s_lshr_b32 s5, ttmp6, 20
	s_lshr_b32 s6, ttmp6, 8
	s_and_b32 s5, s5, 15
	s_and_b32 s6, s6, 15
	s_add_co_i32 s5, s5, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s5, s4, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s6, s6, s5
	s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s4, s4, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s5, s4, 1
	s_endpgm
.Lno_scratch.end:
	.size	no_scratch, .Lno_scratch.end-no_scratch
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel no_scratch
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 8
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 1
		.amdhsa_next_free_sgpr 7
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size instprefsize(.Lno_scratch.end-no_scratch)
		.amdhsa_round_robin_scheduling 0
	.end_amdhsa_kernel
	.text
	.set .Lno_scratch.num_vgpr, 1
	.set .Lno_scratch.num_agpr, 0
	.set .Lno_scratch.numbered_sgpr, 7
	.set .Lno_scratch.num_named_barrier, 0
	.set .Lno_scratch.private_seg_size, 0
	.set .Lno_scratch.uses_vcc, 0
	.set .Lno_scratch.uses_flat_scratch, 0
	.set .Lno_scratch.has_dyn_sized_stack, 0
	.set .Lno_scratch.has_recursion, 0
	.set .Lno_scratch.has_indirect_call, 0

	.globl	z_only
	.p2align	8
	.type	z_only,@function
z_only:
	global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
	v_nop
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
	s_lshr_b32 s4, ttmp7, 16
	s_lshr_b32 s5, ttmp6, 20
	s_lshr_b32 s6, ttmp6, 8
	s_and_b32 s5, s5, 15
	s_and_b32 s6, s6, 15
	s_add_co_i32 s5, s5, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s5, s4, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s6, s6, s5
	s_getreg_b32 s5, hwreg(HW_REG_IB_STS2, 6, 4)
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_eq_u32 s5, 0
	s_cselect_b32 s4, s4, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s5, s4, 1
	s_endpgm
.Lz_only.end:
	.size	z_only, .Lz_only.end-z_only
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel z_only
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 8
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 1
		.amdhsa_next_free_sgpr 7
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size instprefsize(.Lz_only.end-z_only)
		.amdhsa_round_robin_scheduling 0
	.end_amdhsa_kernel
	.text
	.set .Lz_only.num_vgpr, 1
	.set .Lz_only.num_agpr, 0
	.set .Lz_only.numbered_sgpr, 7
	.set .Lz_only.num_named_barrier, 0
	.set .Lz_only.private_seg_size, 0
	.set .Lz_only.uses_vcc, 0
	.set .Lz_only.uses_flat_scratch, 0
	.set .Lz_only.has_dyn_sized_stack, 0
	.set .Lz_only.has_recursion, 0
	.set .Lz_only.has_indirect_call, 0

	.globl	with_scratch
	.p2align	8
	.type	with_scratch,@function
with_scratch:
	global_prefetch_b8 v0, s[0:1] scope:SCOPE_SE
	v_nop
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
	s_endpgm
.Lwith_scratch.end:
	.size	with_scratch, .Lwith_scratch.end-with_scratch
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel with_scratch
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 8
		.amdhsa_kernarg_size 8
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 1
		.amdhsa_next_free_sgpr 6
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size instprefsize(.Lwith_scratch.end-with_scratch)
		.amdhsa_round_robin_scheduling 0
	.end_amdhsa_kernel
	.text
	.set .Lwith_scratch.num_vgpr, 1
	.set .Lwith_scratch.num_agpr, 0
	.set .Lwith_scratch.numbered_sgpr, 6
	.set .Lwith_scratch.num_named_barrier, 0
	.set .Lwith_scratch.private_seg_size, 8
	.set .Lwith_scratch.uses_vcc, 0
	.set .Lwith_scratch.uses_flat_scratch, 1
	.set .Lwith_scratch.has_dyn_sized_stack, 0
	.set .Lwith_scratch.has_recursion, 0
	.set .Lwith_scratch.has_indirect_call, 0
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:           []
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 8
    .max_flat_workgroup_size: 1024
    .name:           no_scratch
    .private_segment_fixed_size: 0
    .sgpr_count:     7
    .sgpr_spill_count: 0
    .symbol:         no_scratch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     1
    .vgpr_spill_count: 0
    .wavefront_size: 32
  - .args:           []
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 8
    .max_flat_workgroup_size: 1024
    .name:           z_only
    .private_segment_fixed_size: 0
    .sgpr_count:     7
    .sgpr_spill_count: 0
    .symbol:         z_only.kd
    .uses_dynamic_stack: false
    .vgpr_count:     1
    .vgpr_spill_count: 0
    .wavefront_size: 32
  - .args:           []
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 8
    .max_flat_workgroup_size: 1024
    .name:           with_scratch
    .private_segment_fixed_size: 8
    .sgpr_count:     6
    .sgpr_spill_count: 0
    .symbol:         with_scratch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     1
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
