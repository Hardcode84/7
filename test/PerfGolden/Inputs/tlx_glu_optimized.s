	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	tlx_addmm_glu_kernel_optimized
	.p2align	8
	.type	tlx_addmm_glu_kernel_optimized,@function
tlx_addmm_glu_kernel_optimized:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .Ltlx_addmm_glu_kernel_optimized.kernarg_preload_entry
	.p2align	8
.Ltlx_addmm_glu_kernel_optimized.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s18, s[0:1], 0x3c
		s_load_dword s19, s[0:1], 0x40
		s_add_i32 s0, s12, 0x7f
		s_mov_b32 s1, 0x7f
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s0, s0, s1
		s_ashr_i32 s0, s0, 7
		s_add_i32 s1, s13, 0xff
		s_mov_b32 s20, 0xff
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, s20, 0
		s_add_i32 s1, s1, s20
		s_ashr_i32 s1, s1, 8
		s_mul_i32 s20, s0, s1
		s_mov_b32 s21, 31
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s21, s21, 0
		s_add_i32 s20, s20, s21
		s_ashr_i32 s20, s20, 5
		s_mul_i32 s20, s20, 32
		s_cmp_ge_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.if_else_0
		s_mov_b32 s20, s16
		s_branch .Ltlx_addmm_glu_kernel_optimized.if_end_0
.Ltlx_addmm_glu_kernel_optimized.if_else_0:
		s_and_b32 s20, s16, 7
		s_lshr_b32 s16, s16, 3
		s_lshr_b32 s21, s16, 2
		s_mul_i32 s21, s21, 32
		s_mul_i32 s20, s20, 4
		s_add_i32 s20, s21, s20
		s_and_b32 s16, s16, 3
		s_add_i32 s20, s20, s16
.Ltlx_addmm_glu_kernel_optimized.if_end_0:
		s_mul_i32 s1, s1, 8
		s_ashr_i32 s16, s20, 31
		s_xor_b32 s20, s20, s16
		s_sub_i32 s20, s20, s16
		s_ashr_i32 s21, s1, 31
		s_xor_b32 s1, s1, s21
		s_sub_i32 s1, s1, s21
		s_xor_b32 s21, s16, s21
		v_mov_b32_e32 v1, s1
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mov_b32 s22, 0
		v_readfirstlane_b32 s23, v1
		s_sub_i32 s24, s22, s1
		s_mul_i32 s24, s24, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s20, s23
		s_mul_i32 s24, s23, s1
		s_sub_i32 s20, s20, s24
		s_add_i32 s24, s23, 1
		s_sub_i32 s25, s20, s1
		s_cmp_ge_u32 s20, s1
		s_cselect_b32 s23, s24, s23
		s_cselect_b32 s20, s25, s20
		s_add_i32 s24, s23, 1
		s_cmp_ge_u32 s20, s1
		s_cselect_b32 s23, s24, s23
		s_cselect_b32 s24, 1, 0
		s_xor_b32 s23, s23, s21
		s_sub_i32 s21, s23, s21
		s_mul_i32 s21, s21, 8
		s_sub_i32 s0, s0, s21
		s_cmp_lt_i32 s0, 8
		s_cselect_b32 s0, s0, 8
		s_sub_i32 s1, s20, s1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s1, s1, s20
		s_xor_b32 s1, s1, s16
		s_sub_i32 s1, s1, s16
		s_ashr_i32 s16, s1, 31
		s_xor_b32 s1, s1, s16
		s_sub_i32 s1, s1, s16
		s_ashr_i32 s20, s0, 31
		s_xor_b32 s0, s0, s20
		s_sub_i32 s0, s0, s20
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_sub_i32 s23, s22, s0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		v_readfirstlane_b32 s24, v0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s23, s23, s25
		s_mul_hi_u32 s23, s25, s23
		s_add_i32 s23, s25, s23
		s_mul_hi_u32 s23, s1, s23
		s_mul_i32 s25, s23, s0
		s_sub_i32 s1, s1, s25
		s_sub_i32 s25, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s1, s25, s1
		s_cselect_b32 s25, 1, 0
		s_sub_i32 s26, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s0, s26, s1
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s0, s0, s16
		s_sub_i32 s0, s0, s16
		s_add_i32 s0, s21, s0
		s_xor_b32 s16, s16, s20
		s_add_i32 s20, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s20, s23
		s_add_i32 s21, s20, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s21, s20
		s_xor_b32 s1, s1, s16
		s_mul_i32 s0, s0, 0x80
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v3, 1, v1
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 32
		v_mul_lo_u32 v6, v6, v5
		v_mad_u32_u24 v3, v3, 16, v6
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v6, 1, v5
		v_mad_u32_u24 v3, v6, 64, v3
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_add3_u32 v3, v3, v7, v9
		v_lshrrev_b32_e32 v8, 8, v0
		v_and_b32_e32 v10, 1, v8
		v_mad_u32_u24 v3, v10, 4, v3
		v_and_b32_e32 v11, 15, v5
		v_add_u32_e32 v12, 0x50, v11
		v_add_u32_e32 v13, 0x60, v11
		v_add_u32_e32 v14, 0x70, v11
		v_add_u32_e32 v15, s0, v3
		v_ashrrev_i32_e32 v16, 31, v15
		v_xor_b32_e32 v15, v15, v16
		v_sub_u32_e32 v15, v15, v16
		s_ashr_i32 s20, s12, 31
		s_xor_b32 s12, s12, s20
		s_sub_i32 s12, s12, s20
		v_mov_b32_e32 v17, s12
		v_cvt_f32_u32_e32 v18, v17
		v_rcp_iflag_f32_e32 v18, v18
		v_add3_u32 v3, 8, v3, s0
		v_mul_f32_e32 v18, v2, v18
		v_cvt_u32_f32_e32 v18, v18
		s_sub_i32 s20, s22, s12
		v_mul_lo_u32 v19, s20, v18
		s_sub_i32 s1, s1, s16
		v_mul_hi_u32 v19, v18, v19
		v_add_u32_e32 v18, v18, v19
		v_mul_hi_u32 v19, v15, v18
		v_mul_lo_u32 v19, v19, s12
		v_sub_u32_e32 v15, v15, v19
		v_sub_u32_e32 v19, v15, v17
		v_cmp_ge_u32_e64 vcc, v15, s12
		s_lshr_b32 s16, s24, 6
		v_add_u32_e32 v12, s0, v12
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_sub_u32_e32 v19, v15, v17
		v_cmp_ge_u32_e64 vcc, v15, s12
		v_add_u32_e32 v20, s0, v11
		v_add_u32_e32 v13, s0, v13
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_xor_b32_e32 v15, v15, v16
		v_ashrrev_i32_e32 v19, 31, v3
		v_xor_b32_e32 v3, v3, v19
		v_sub_u32_e32 v3, v3, v19
		v_mul_hi_u32 v21, v3, v18
		v_mul_lo_u32 v21, v21, s12
		v_sub_u32_e32 v3, v3, v21
		v_sub_u32_e32 v21, v3, v17
		v_cmp_ge_u32_e64 vcc, v3, s12
		v_add3_u32 v22, 16, v11, s0
		v_add3_u32 v23, 32, v11, s0
		v_cndmask_b32_e32 v3, v3, v21, vcc
		v_sub_u32_e32 v21, v3, v17
		v_cmp_ge_u32_e64 vcc, v3, s12
		v_add3_u32 v24, 48, v11, s0
		v_add3_u32 v11, 64, v11, s0
		v_add_u32_e32 v14, s0, v14
		v_cndmask_b32_e32 v3, v3, v21, vcc
		v_xor_b32_e32 v3, v3, v19
		v_ashrrev_i32_e32 v21, 31, v20
		v_xor_b32_e32 v20, v20, v21
		v_sub_u32_e32 v20, v20, v21
		v_mul_hi_u32 v25, v20, v18
		v_mul_lo_u32 v25, v25, s12
		v_sub_u32_e32 v20, v20, v25
		v_sub_u32_e32 v25, v20, v17
		v_cmp_ge_u32_e64 vcc, v20, s12
		v_sub_u32_e32 v15, v15, v16
		v_sub_u32_e32 v3, v3, v19
		v_cndmask_b32_e32 v16, v20, v25, vcc
		v_sub_u32_e32 v19, v16, v17
		v_cmp_ge_u32_e64 vcc, v16, s12
		s_mul_i32 s0, s1, 0x100
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v6
		v_cndmask_b32_e32 v6, v16, v19, vcc
		v_xor_b32_e32 v6, v6, v21
		v_ashrrev_i32_e32 v16, 31, v22
		v_xor_b32_e32 v19, v22, v16
		v_sub_u32_e32 v19, v19, v16
		v_mul_hi_u32 v22, v19, v18
		v_mul_lo_u32 v22, v22, s12
		v_sub_u32_e32 v19, v19, v22
		v_sub_u32_e32 v22, v19, v17
		v_cmp_ge_u32_e64 vcc, v19, s12
		v_mov_b32_e32 v25, 8
		v_mul_lo_u32 v25, v25, v10
		v_cndmask_b32_e32 v10, v19, v22, vcc
		v_cmp_ge_u32_e64 vcc, v10, s12
		v_sub_u32_e32 v19, v10, v17
		v_ashrrev_i32_e32 v22, 31, v23
		v_cndmask_b32_e32 v10, v10, v19, vcc
		v_xor_b32_e32 v10, v10, v16
		v_xor_b32_e32 v19, v23, v22
		v_sub_u32_e32 v19, v19, v22
		v_mul_hi_u32 v23, v19, v18
		v_mul_lo_u32 v23, v23, s12
		v_sub_u32_e32 v19, v19, v23
		v_cmp_ge_u32_e64 vcc, v19, s12
		v_sub_u32_e32 v10, v10, v16
		v_sub_u32_e32 v16, v19, v17
		v_cndmask_b32_e32 v16, v19, v16, vcc
		v_cmp_ge_u32_e64 vcc, v16, s12
		v_sub_u32_e32 v19, v16, v17
		v_ashrrev_i32_e32 v23, 31, v24
		v_cndmask_b32_e32 v16, v16, v19, vcc
		v_xor_b32_e32 v16, v16, v22
		v_xor_b32_e32 v19, v24, v23
		v_sub_u32_e32 v19, v19, v23
		v_mul_hi_u32 v24, v19, v18
		v_mul_lo_u32 v24, v24, s12
		v_sub_u32_e32 v19, v19, v24
		v_cmp_ge_u32_e64 vcc, v19, s12
		v_sub_u32_e32 v16, v16, v22
		v_sub_u32_e32 v22, v19, v17
		v_cndmask_b32_e32 v19, v19, v22, vcc
		v_cmp_ge_u32_e64 vcc, v19, s12
		v_sub_u32_e32 v22, v19, v17
		v_ashrrev_i32_e32 v24, 31, v11
		v_cndmask_b32_e32 v19, v19, v22, vcc
		v_xor_b32_e32 v19, v19, v23
		v_xor_b32_e32 v11, v11, v24
		v_sub_u32_e32 v11, v11, v24
		v_mul_hi_u32 v22, v11, v18
		v_mul_lo_u32 v22, v22, s12
		v_sub_u32_e32 v11, v11, v22
		v_cmp_ge_u32_e64 vcc, v11, s12
		v_sub_u32_e32 v19, v19, v23
		v_sub_u32_e32 v22, v11, v17
		v_cndmask_b32_e32 v11, v11, v22, vcc
		v_cmp_ge_u32_e64 vcc, v11, s12
		v_sub_u32_e32 v22, v11, v17
		v_ashrrev_i32_e32 v23, 31, v12
		v_cndmask_b32_e32 v11, v11, v22, vcc
		v_xor_b32_e32 v11, v11, v24
		v_xor_b32_e32 v12, v12, v23
		v_sub_u32_e32 v12, v12, v23
		v_mul_hi_u32 v22, v12, v18
		v_mul_lo_u32 v22, v22, s12
		v_sub_u32_e32 v12, v12, v22
		v_cmp_ge_u32_e64 vcc, v12, s12
		v_sub_u32_e32 v11, v11, v24
		v_sub_u32_e32 v22, v12, v17
		v_cndmask_b32_e32 v12, v12, v22, vcc
		v_cmp_ge_u32_e64 vcc, v12, s12
		v_sub_u32_e32 v22, v12, v17
		v_ashrrev_i32_e32 v24, 31, v13
		v_cndmask_b32_e32 v12, v12, v22, vcc
		v_xor_b32_e32 v12, v12, v23
		v_xor_b32_e32 v13, v13, v24
		v_sub_u32_e32 v13, v13, v24
		v_mul_hi_u32 v22, v13, v18
		v_mul_lo_u32 v22, v22, s12
		v_sub_u32_e32 v13, v13, v22
		v_cmp_ge_u32_e64 vcc, v13, s12
		v_sub_u32_e32 v12, v12, v23
		v_sub_u32_e32 v22, v13, v17
		v_cndmask_b32_e32 v13, v13, v22, vcc
		v_cmp_ge_u32_e64 vcc, v13, s12
		v_sub_u32_e32 v22, v13, v17
		v_ashrrev_i32_e32 v23, 31, v14
		v_cndmask_b32_e32 v13, v13, v22, vcc
		v_xor_b32_e32 v13, v13, v24
		v_xor_b32_e32 v14, v14, v23
		v_sub_u32_e32 v14, v14, v23
		v_mul_hi_u32 v18, v14, v18
		v_mul_lo_u32 v18, v18, s12
		v_sub_u32_e32 v14, v14, v18
		v_cmp_ge_u32_e64 vcc, v14, s12
		v_sub_u32_e32 v13, v13, v24
		v_sub_u32_e32 v18, v14, v17
		v_cndmask_b32_e32 v14, v14, v18, vcc
		v_cmp_ge_u32_e64 vcc, v14, s12
		v_sub_u32_e32 v17, v14, v17
		v_and_b32_e32 v5, 1, v5
		v_cndmask_b32_e32 v14, v14, v17, vcc
		v_xor_b32_e32 v14, v14, v23
		v_and_b32_e32 v17, 31, v0
		v_mov_b32_e32 v18, 8
		v_mul_lo_u32 v18, v18, v17
		v_add_u32_e32 v17, s0, v18
		v_ashrrev_i32_e32 v22, 31, v17
		v_xor_b32_e32 v17, v17, v22
		v_sub_u32_e32 v17, v17, v22
		s_ashr_i32 s1, s13, 31
		s_xor_b32 s12, s13, s1
		s_sub_i32 s1, s12, s1
		v_mov_b32_e32 v24, s1
		v_cvt_f32_u32_e32 v26, v24
		v_rcp_iflag_f32_e32 v26, v26
		s_nop 0
		v_mul_f32_e32 v2, v2, v26
		v_cvt_u32_f32_e32 v2, v2
		s_sub_i32 s12, s22, s1
		v_mul_lo_u32 v26, s12, v2
		v_mul_hi_u32 v26, v2, v26
		v_add_u32_e32 v2, v2, v26
		v_mul_hi_u32 v26, v17, v2
		v_mul_lo_u32 v26, v26, s1
		v_sub_u32_e32 v17, v17, v26
		v_sub_u32_e32 v26, v17, v24
		v_cmp_ge_u32_e64 vcc, v17, s1
		v_add3_u32 v27, 1, v18, s0
		v_and_b32_e32 v4, 1, v4
		v_cndmask_b32_e32 v17, v17, v26, vcc
		v_sub_u32_e32 v26, v17, v24
		v_cmp_ge_u32_e64 vcc, v17, s1
		v_add3_u32 v28, 2, v18, s0
		v_add3_u32 v29, 3, v18, s0
		v_cndmask_b32_e32 v17, v17, v26, vcc
		v_xor_b32_e32 v17, v17, v22
		v_ashrrev_i32_e32 v26, 31, v27
		v_xor_b32_e32 v27, v27, v26
		v_sub_u32_e32 v27, v27, v26
		v_mul_hi_u32 v30, v27, v2
		v_mul_lo_u32 v30, v30, s1
		v_sub_u32_e32 v27, v27, v30
		v_sub_u32_e32 v30, v27, v24
		v_cmp_ge_u32_e64 vcc, v27, s1
		v_add3_u32 v31, 4, v18, s0
		v_add3_u32 v32, 5, v18, s0
		v_cndmask_b32_e32 v27, v27, v30, vcc
		v_sub_u32_e32 v30, v27, v24
		v_cmp_ge_u32_e64 vcc, v27, s1
		v_add3_u32 v33, 6, v18, s0
		v_add3_u32 v18, 7, v18, s0
		v_cndmask_b32_e32 v27, v27, v30, vcc
		v_xor_b32_e32 v27, v27, v26
		v_ashrrev_i32_e32 v30, 31, v28
		v_xor_b32_e32 v28, v28, v30
		v_sub_u32_e32 v28, v28, v30
		v_mul_hi_u32 v34, v28, v2
		v_mul_lo_u32 v34, v34, s1
		v_sub_u32_e32 v28, v28, v34
		v_sub_u32_e32 v34, v28, v24
		v_cmp_ge_u32_e64 vcc, v28, s1
		v_sub_u32_e32 v17, v17, v22
		v_sub_u32_e32 v22, v27, v26
		v_cndmask_b32_e32 v26, v28, v34, vcc
		v_cmp_ge_u32_e64 vcc, v26, s1
		v_sub_u32_e32 v27, v26, v24
		v_ashrrev_i32_e32 v28, 31, v29
		v_cndmask_b32_e32 v26, v26, v27, vcc
		v_xor_b32_e32 v26, v26, v30
		v_xor_b32_e32 v27, v29, v28
		v_sub_u32_e32 v27, v27, v28
		v_mul_hi_u32 v29, v27, v2
		v_mul_lo_u32 v29, v29, s1
		v_sub_u32_e32 v27, v27, v29
		v_cmp_ge_u32_e64 vcc, v27, s1
		v_sub_u32_e32 v26, v26, v30
		v_sub_u32_e32 v29, v27, v24
		v_cndmask_b32_e32 v27, v27, v29, vcc
		v_cmp_ge_u32_e64 vcc, v27, s1
		v_sub_u32_e32 v29, v27, v24
		v_ashrrev_i32_e32 v30, 31, v31
		v_cndmask_b32_e32 v27, v27, v29, vcc
		v_xor_b32_e32 v27, v27, v28
		v_xor_b32_e32 v29, v31, v30
		v_sub_u32_e32 v29, v29, v30
		v_mul_hi_u32 v31, v29, v2
		v_mul_lo_u32 v31, v31, s1
		v_sub_u32_e32 v29, v29, v31
		v_cmp_ge_u32_e64 vcc, v29, s1
		v_sub_u32_e32 v27, v27, v28
		v_sub_u32_e32 v28, v29, v24
		v_cndmask_b32_e32 v28, v29, v28, vcc
		v_cmp_ge_u32_e64 vcc, v28, s1
		v_sub_u32_e32 v29, v28, v24
		v_ashrrev_i32_e32 v31, 31, v32
		v_cndmask_b32_e32 v28, v28, v29, vcc
		v_xor_b32_e32 v28, v28, v30
		v_xor_b32_e32 v29, v32, v31
		v_sub_u32_e32 v29, v29, v31
		v_mul_hi_u32 v32, v29, v2
		v_mul_lo_u32 v32, v32, s1
		v_sub_u32_e32 v29, v29, v32
		v_cmp_ge_u32_e64 vcc, v29, s1
		v_sub_u32_e32 v28, v28, v30
		v_sub_u32_e32 v30, v29, v24
		v_cndmask_b32_e32 v29, v29, v30, vcc
		v_cmp_ge_u32_e64 vcc, v29, s1
		v_sub_u32_e32 v30, v29, v24
		v_ashrrev_i32_e32 v32, 31, v33
		v_cndmask_b32_e32 v29, v29, v30, vcc
		v_xor_b32_e32 v29, v29, v31
		v_xor_b32_e32 v30, v33, v32
		v_sub_u32_e32 v30, v30, v32
		v_mul_hi_u32 v33, v30, v2
		v_mul_lo_u32 v33, v33, s1
		v_sub_u32_e32 v30, v30, v33
		v_cmp_ge_u32_e64 vcc, v30, s1
		v_sub_u32_e32 v29, v29, v31
		v_sub_u32_e32 v31, v30, v24
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_cmp_ge_u32_e64 vcc, v30, s1
		v_sub_u32_e32 v31, v30, v24
		v_ashrrev_i32_e32 v33, 31, v18
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_xor_b32_e32 v30, v30, v32
		v_xor_b32_e32 v18, v18, v33
		v_sub_u32_e32 v18, v18, v33
		v_mul_hi_u32 v2, v18, v2
		v_mul_lo_u32 v2, v2, s1
		v_sub_u32_e32 v2, v18, v2
		v_cmp_ge_u32_e64 vcc, v2, s1
		v_sub_u32_e32 v18, v30, v32
		v_sub_u32_e32 v30, v2, v24
		v_cndmask_b32_e32 v2, v2, v30, vcc
		v_cmp_ge_u32_e64 vcc, v2, s1
		v_sub_u32_e32 v24, v2, v24
		s_add_i32 s0, s14, 63
		v_cndmask_b32_e32 v2, v2, v24, vcc
		v_xor_b32_e32 v2, v2, v33
		s_mov_b32 s1, 63
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s0, s0, s1
		v_and_b32_e32 v24, 1, v0
		v_mov_b32_e32 v30, 8
		v_mul_lo_u32 v30, v30, v24
		v_lshrrev_b32_e32 v24, 1, v0
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v31, 16
		v_mul_lo_u32 v31, v31, v24
		v_lshrrev_b32_e32 v24, 2, v0
		v_and_b32_e32 v32, 1, v24
		v_mov_b32_e32 v34, 32
		v_mul_lo_u32 v34, v34, v32
		v_bitop3_b32 v30, v30, v31, v34 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v30, s14
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_readfirstlane_b32 s1, v0
		v_mul_lo_u32 v31, s15, v15
		v_lshlrev_b32_e32 v31, 1, v31
		v_and_b32_e32 v32, 7, v0
		v_lshlrev_b32_e32 v32, 4, v32
		v_add_u32_e32 v34, v31, v32
		v_mov_b32_e32 v35, 0x80000000
		v_cndmask_b32_e32 v34, v35, v34, vcc
		s_lshr_b32 s1, s1, 6
		s_mul_i32 s1, 0x420, s1
		s_mov_b32 m0, s1
		v_sub_u32_e32 v6, v6, v21
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		v_mul_lo_u32 v21, s15, v3
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v34, v21, v32
		v_cndmask_b32_e32 v34, v35, v34, vcc
		s_add_i32 m0, m0, 0x2100
		v_sub_u32_e32 v14, v14, v23
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		v_bitop3_b32 v23, v20, v7, v9 bitop3:0x96
		v_xor_b32_e32 v23, v23, v25
		v_bitop3_b32 v34, 4, v20, v7 bitop3:0x96
		v_bitop3_b32 v36, 32, v20, v7 bitop3:0x96
		v_bitop3_b32 v36, v36, v9, v25 bitop3:0x96
		v_bitop3_b32 v7, 36, v20, v7 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v23, s14
		v_cmp_lt_i32_e64 vcc, v36, s14
		s_lshr_b32 s4, s16, 2
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s5, s17, s4
		s_lshl_b32 s5, s5, 3
		s_mul_i32 s12, s17, s16
		s_lshl_b32 s12, s12, 1
		s_add_i32 s13, s5, s12
		v_lshlrev_b32_e32 v20, 1, v17
		v_mul_lo_u32 v37, s17, v5
		v_lshlrev_b32_e32 v37, 5, v37
		v_add3_u32 v38, s13, v20, v37
		v_cndmask_b32_e64 v38, v35, v38, s[2:3]
		s_add_i32 m0, m0, 0xa4e0
		v_sub_u32_e32 v2, v2, v33
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_lshl_b32 s13, s17, 3
		s_add_i32 s13, s13, s5
		s_add_i32 s13, s13, s12
		v_add3_u32 v33, s13, v20, v37
		v_cndmask_b32_e64 v33, v35, v33, s[2:3]
		s_add_i32 m0, m0, 0x2100
		s_ashr_i32 s0, s0, 6
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		s_lshl_b32 s2, s17, 6
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v33, s2, v20, v37
		v_cndmask_b32_e32 v33, v35, v33, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v34, v34, v9, v25 bitop3:0x96
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		s_mul_i32 s2, 0x48, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v33, s2, v20, v37
		v_cndmask_b32_e32 v33, v35, v33, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v7, v7, v9, v25 bitop3:0x96
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		s_sub_i32 s2, s14, 64
		v_cmp_lt_i32_e64 vcc, v30, s2
		v_add_u32_e32 v9, 0x80, v31
		v_add_u32_e32 v9, v9, v32
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0xffff1920
		s_lshl_b32 s3, s17, 7
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_add_u32_e32 v9, 0x80, v21
		v_add_u32_e32 v9, v9, v32
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[20:21], v23, s2
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v36, s2
		s_add_i32 s2, s3, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v9, v35, v9, s[20:21]
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s2, 0x88, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		v_cndmask_b32_e64 v9, v35, v9, s[20:21]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v25, 0x100, v31
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s2, 0xc0, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s2, s17, 8
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s13, 0xc8, s17
		s_add_i32 s13, s13, s5
		s_add_i32 s13, s13, s12
		v_add3_u32 v9, s13, v20, v37
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		s_sub_i32 s13, s14, 0x80
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v30, s13
		v_add_u32_e32 v9, v25, v32
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v9, v35, v9, vcc
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_add_u32_e32 v9, 0x100, v21
		v_add_u32_e32 v9, v9, v32
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[20:21], v23, s13
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v36, s13
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		s_add_i32 m0, m0, 0x128e0
		v_cndmask_b32_e64 v9, v35, v9, s[20:21]
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s2, 0x108, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		v_cndmask_b32_e64 v9, v35, v9, s[20:21]
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v5, 9, v5
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s2, 0x140, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v21, 63, v0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_mul_i32 s2, 0x148, s17
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s12
		v_add3_u32 v9, s2, v20, v37
		v_cndmask_b32_e32 v9, v35, v9, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s2, s4, 7
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshrrev_b32_e32 v9, 4, v21
		v_lshlrev_b32_e32 v9, 4, v9
		v_and_b32_e32 v25, 15, v21
		v_mov_b32_e32 v31, 0x420
		v_mul_lo_u32 v31, v31, v25
		v_add3_u32 v25, s2, v9, v31
		ds_read_b128 v[40:43], v25
		ds_read_b128 v[44:47], v25 offset:64
		ds_read_b128 v[48:51], v25 offset:256
		ds_read_b128 v[52:55], v25 offset:320
		ds_read_b128 v[56:59], v25 offset:512
		ds_read_b128 v[60:63], v25 offset:576
		ds_read_b128 v[64:67], v25 offset:768
		ds_read_b128 v[68:71], v25 offset:832
		s_lshr_b32 s13, s16, 1
		s_and_b32 s13, s13, 1
		s_lshl_b32 s13, s13, 6
		s_and_b32 s20, s16, 1
		s_lshl_b32 s20, s20, 5
		s_add_i32 s21, s13, s20
		v_and_b32_e32 v25, 3, v0
		v_lshlrev_b32_e32 v25, 3, v25
		v_add_u32_e32 v33, s21, v25
		v_mov_b32_e32 v38, 0x1080
		v_mul_lo_u32 v38, v38, v4
		v_add3_u32 v4, v33, v5, v38
		v_and_b32_e32 v33, 1, v1
		v_mov_b32_e32 v39, 0x840
		v_mul_lo_u32 v39, v39, v33
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v33, 0x420
		v_mul_lo_u32 v33, v33, v24
		v_add3_u32 v4, v4, v39, v33
		ds_read_b64_tr_b16 v[72:73], v4 offset:50656
		ds_read_b64_tr_b16 v[74:75], v4 offset:59104
		s_add_i32 s23, s13, 0x10000
		s_add_i32 s23, s23, s20
		v_add_u32_e32 v24, s23, v25
		v_add3_u32 v24, v24, v5, v38
		v_add3_u32 v24, v24, v39, v33
		ds_read_b64_tr_b16 v[76:77], v24 offset:2016
		ds_read_b64_tr_b16 v[78:79], v24 offset:10464
		ds_read_b64_tr_b16 v[80:81], v4 offset:50784
		ds_read_b64_tr_b16 v[82:83], v4 offset:59232
		ds_read_b64_tr_b16 v[84:85], v24 offset:2144
		ds_read_b64_tr_b16 v[86:87], v24 offset:10592
		ds_read_b64_tr_b16 v[88:89], v4 offset:50912
		ds_read_b64_tr_b16 v[90:91], v4 offset:59360
		ds_read_b64_tr_b16 v[92:93], v24 offset:2272
		ds_read_b64_tr_b16 v[94:95], v24 offset:10720
		ds_read_b64_tr_b16 v[96:97], v4 offset:51040
		ds_read_b64_tr_b16 v[98:99], v4 offset:59488
		ds_read_b64_tr_b16 v[100:101], v24 offset:2400
		ds_read_b64_tr_b16 v[102:103], v24 offset:10848
		s_sub_i32 s32, s0, 3
		v_cmp_ne_u32_e64 vcc, v8, s22
		v_cmp_eq_u32_e64 s[34:35], v8, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[40:41], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[40:41]
		s_setprio 0
		s_mul_i32 s33, 0x180, s17
		s_add_i32 s33, s33, s5
		s_add_i32 s33, s33, s12
		v_add3_u32 v4, s33, v20, v37
		s_mul_i32 s33, 0x188, s17
		s_add_i32 s33, s33, s5
		s_add_i32 s33, s33, s12
		v_add3_u32 v8, s33, v20, v37
		s_mul_i32 s33, 0x1c0, s17
		s_add_i32 s33, s33, s5
		s_add_i32 s33, s33, s12
		v_add3_u32 v24, s33, v20, v37
		s_mul_i32 s17, 0x1c8, s17
		s_add_i32 s5, s17, s5
		s_add_i32 s5, s5, s12
		v_add3_u32 v104, s5, v20, v37
		v_add3_u32 v5, v25, v5, v38
		v_add_u32_e32 v9, v9, v31
		v_add_u32_e32 v25, 0x180, v32
		s_lshl_b32 s5, s15, 1
		v_mul_lo_u32 v15, s5, v15
		v_mul_lo_u32 v3, s5, v3
		v_add3_u32 v5, v5, v39, v33
		v_add_u32_e32 v15, v25, v15
		v_add_u32_e32 v3, v25, v3
		s_cmp_lt_i32 0, s32
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
		v_mov_b64_e32 v[116:117], 0
		v_mov_b64_e32 v[118:119], 0
		v_mov_b64_e32 v[120:121], 0
		v_mov_b64_e32 v[122:123], 0
		v_mov_b64_e32 v[124:125], 0
		v_mov_b64_e32 v[126:127], 0
		v_mov_b64_e32 v[128:129], 0
		v_mov_b64_e32 v[130:131], 0
		v_mov_b64_e32 v[132:133], 0
		v_mov_b64_e32 v[134:135], 0
		v_mov_b64_e32 v[136:137], 0
		v_mov_b64_e32 v[138:139], 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_mov_b64_e32 v[144:145], 0
		v_mov_b64_e32 v[146:147], 0
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		v_mov_b64_e32 v[152:153], 0
		v_mov_b64_e32 v[154:155], 0
		v_mov_b64_e32 v[156:157], 0
		v_mov_b64_e32 v[158:159], 0
		v_mov_b64_e32 v[160:161], 0
		v_mov_b64_e32 v[162:163], 0
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		s_mov_b32 s5, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[40:43], v[112:115]
		s_lshl_b32 s12, s22, 7
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[40:43], v[120:123]
		s_cmp_ge_u32 s5, 2
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		s_cselect_b32 s15, 1, 0
		s_sub_i32 s17, s5, 2
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		s_add_i32 s33, s5, 1
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s15, s17, s33
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		s_add_i32 s17, s22, 3
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		s_mul_i32 s17, s17, 64
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[68:71], v[160:163]
		s_setprio 1
		s_barrier
		v_add_u32_e32 v25, s12, v15
		v_add_u32_e32 v31, s12, v3
		s_sub_i32 s12, s14, s17
		v_cmp_lt_i32_e64 vcc, v30, s12
		v_cmp_lt_i32_e64 s[36:37], v23, s12
		s_mul_i32 s17, 0x4200, s5
		v_cndmask_b32_e32 v25, v35, v25, vcc
		v_cndmask_b32_e64 v32, v35, v4, s[36:37]
		v_cndmask_b32_e32 v31, v35, v31, vcc
		s_add_i32 s17, s1, s17
		v_cmp_lt_i32_e64 vcc, v7, s12
		s_mov_b32 m0, s17
		s_mul_i32 s5, 0x8400, s5
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_add_i32 s5, s1, s5
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s17, 0x4200, s15
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_add_i32 s17, s2, s17
		s_add_i32 m0, s5, 0xc5e0
		v_add_u32_e32 v25, s17, v9
		buffer_load_dwordx4 v32, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[36:37], v34, s12
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[38:39], v36, s12
		v_cndmask_b32_e64 v31, v35, v8, s[36:37]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v31, v35, v24, s[38:39]
		v_cndmask_b32_e32 v32, v35, v104, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s5, 0x8400, s15
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_add_i32 s12, s21, s5
		v_add_u32_e32 v31, s12, v5
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s5, s23, s5
		v_add_u32_e32 v33, s5, v5
		buffer_load_dwordx4 v32, s[28:31], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(6)
		ds_read_b128 v[40:43], v25
		ds_read_b128 v[44:47], v25 offset:64
		ds_read_b128 v[48:51], v25 offset:256
		ds_read_b128 v[52:55], v25 offset:320
		ds_read_b128 v[56:59], v25 offset:512
		ds_read_b128 v[60:63], v25 offset:576
		ds_read_b128 v[64:67], v25 offset:768
		ds_read_b128 v[68:71], v25 offset:832
		ds_read_b64_tr_b16 v[72:73], v31 offset:50656
		ds_read_b64_tr_b16 v[74:75], v31 offset:59104
		ds_read_b64_tr_b16 v[76:77], v33 offset:2016
		ds_read_b64_tr_b16 v[78:79], v33 offset:10464
		ds_read_b64_tr_b16 v[80:81], v31 offset:50784
		ds_read_b64_tr_b16 v[82:83], v31 offset:59232
		ds_read_b64_tr_b16 v[84:85], v33 offset:2144
		ds_read_b64_tr_b16 v[86:87], v33 offset:10592
		ds_read_b64_tr_b16 v[88:89], v31 offset:50912
		ds_read_b64_tr_b16 v[90:91], v31 offset:59360
		ds_read_b64_tr_b16 v[92:93], v33 offset:2272
		ds_read_b64_tr_b16 v[94:95], v33 offset:10720
		ds_read_b64_tr_b16 v[96:97], v31 offset:51040
		ds_read_b64_tr_b16 v[98:99], v31 offset:59488
		ds_read_b64_tr_b16 v[100:101], v33 offset:2400
		ds_read_b64_tr_b16 v[102:103], v33 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s3, v4
		v_add_u32_e32 v8, s3, v8
		v_add_u32_e32 v24, s3, v24
		v_add_u32_e32 v104, s3, v104
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s32
		s_mov_b32 s5, s15
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[40:41], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[40:41]
		v_bitop3_b32 v0, v0, 4, v1 bitop3:0x78
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		buffer_load_ushort v1, v20, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v22
		buffer_load_ushort v4, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v26
		buffer_load_ushort v7, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v27
		buffer_load_ushort v8, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v28
		buffer_load_ushort v15, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v29
		buffer_load_ushort v20, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v18
		buffer_load_ushort v23, v3, s[28:31], 0 offen
		v_lshlrev_b32_e32 v3, 1, v2
		buffer_load_ushort v24, v3, s[28:31], 0 offen
		v_mul_lo_u32 v3, s18, v6
		v_add_lshl_u32 v25, v17, v3, 1
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		buffer_load_ushort v30, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v22, v3, 1
		buffer_load_ushort v31, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v26, v3, 1
		buffer_load_ushort v32, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v27, v3, 1
		buffer_load_ushort v33, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v28, v3, 1
		buffer_load_ushort v34, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v29, v3, 1
		buffer_load_ushort v35, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v25, v18, v3, 1
		buffer_load_ushort v36, v25, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v25, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v10
		v_add_lshl_u32 v37, v17, v3, 1
		buffer_load_ushort v38, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v22, v3, 1
		buffer_load_ushort v39, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v26, v3, 1
		buffer_load_ushort v104, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v27, v3, 1
		buffer_load_ushort v105, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v28, v3, 1
		buffer_load_ushort v106, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v29, v3, 1
		buffer_load_ushort v107, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v37, v18, v3, 1
		buffer_load_ushort v172, v37, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v37, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v16
		v_add_lshl_u32 v173, v17, v3, 1
		buffer_load_ushort v174, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v22, v3, 1
		buffer_load_ushort v175, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v26, v3, 1
		buffer_load_ushort v176, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v27, v3, 1
		buffer_load_ushort v177, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v28, v3, 1
		buffer_load_ushort v178, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v29, v3, 1
		buffer_load_ushort v179, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v173, v18, v3, 1
		buffer_load_ushort v180, v173, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v173, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v19
		v_add_lshl_u32 v181, v17, v3, 1
		buffer_load_ushort v182, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v22, v3, 1
		buffer_load_ushort v183, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v26, v3, 1
		buffer_load_ushort v184, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v27, v3, 1
		buffer_load_ushort v185, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v28, v3, 1
		buffer_load_ushort v186, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v29, v3, 1
		buffer_load_ushort v187, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v181, v18, v3, 1
		buffer_load_ushort v188, v181, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v181, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v11
		v_add_lshl_u32 v189, v17, v3, 1
		buffer_load_ushort v190, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v22, v3, 1
		buffer_load_ushort v191, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v26, v3, 1
		buffer_load_ushort v192, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v27, v3, 1
		buffer_load_ushort v193, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v28, v3, 1
		buffer_load_ushort v194, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v29, v3, 1
		buffer_load_ushort v195, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v189, v18, v3, 1
		buffer_load_ushort v196, v189, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v189, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v12
		v_add_lshl_u32 v197, v17, v3, 1
		buffer_load_ushort v198, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v22, v3, 1
		buffer_load_ushort v199, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v26, v3, 1
		buffer_load_ushort v200, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v27, v3, 1
		buffer_load_ushort v201, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v28, v3, 1
		buffer_load_ushort v202, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v29, v3, 1
		buffer_load_ushort v203, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v197, v18, v3, 1
		buffer_load_ushort v204, v197, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v197, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v13
		v_add_lshl_u32 v205, v17, v3, 1
		buffer_load_ushort v206, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v22, v3, 1
		buffer_load_ushort v207, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v26, v3, 1
		buffer_load_ushort v208, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v27, v3, 1
		buffer_load_ushort v209, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v28, v3, 1
		buffer_load_ushort v210, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v29, v3, 1
		buffer_load_ushort v211, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v205, v18, v3, 1
		buffer_load_ushort v212, v205, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v205, v3, s[28:31], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v14
		v_add_lshl_u32 v213, v17, v3, 1
		buffer_load_ushort v214, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v22, v3, 1
		buffer_load_ushort v215, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v26, v3, 1
		buffer_load_ushort v216, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v27, v3, 1
		buffer_load_ushort v217, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v28, v3, 1
		buffer_load_ushort v218, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v29, v3, 1
		buffer_load_ushort v219, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v213, v18, v3, 1
		buffer_load_ushort v220, v213, s[28:31], 0 offen sc0 nt
		v_add_lshl_u32 v3, v2, v3, 1
		buffer_load_ushort v213, v3, s[28:31], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[68:71], v[160:163]
		s_sub_i32 s1, s0, 2
		s_ashr_i32 s3, s1, 31
		s_xor_b32 s1, s1, s3
		s_sub_i32 s1, s1, s3
		s_mul_hi_u32 s5, s1, 0xaaaaaaab
		s_lshr_b32 s5, s5, 1
		s_mul_i32 s5, s5, 3
		s_sub_i32 s1, s1, s5
		s_xor_b32 s1, s1, s3
		s_sub_i32 s1, s1, s3
		s_waitcnt vmcnt(62)
		s_barrier
		s_mul_i32 s3, 0x4200, s1
		s_add_i32 s3, s3, s2
		v_add_u32_e32 v3, s3, v9
		ds_read_b128 v[40:43], v3
		ds_read_b128 v[44:47], v3 offset:64
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:320
		ds_read_b128 v[56:59], v3 offset:512
		ds_read_b128 v[60:63], v3 offset:576
		ds_read_b128 v[64:67], v3 offset:768
		ds_read_b128 v[68:71], v3 offset:832
		s_mul_i32 s1, 0x8400, s1
		s_add_i32 s3, s1, s13
		s_add_i32 s3, s3, s20
		v_add_u32_e32 v3, s3, v5
		ds_read_b64_tr_b16 v[72:73], v3 offset:50656
		ds_read_b64_tr_b16 v[74:75], v3 offset:59104
		s_add_i32 s1, s1, 0x10000
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s20
		v_add_u32_e32 v76, s1, v5
		ds_read_b64_tr_b16 v[80:81], v76 offset:2016
		ds_read_b64_tr_b16 v[82:83], v76 offset:10464
		ds_read_b64_tr_b16 v[84:85], v3 offset:50784
		ds_read_b64_tr_b16 v[86:87], v3 offset:59232
		ds_read_b64_tr_b16 v[88:89], v76 offset:2144
		ds_read_b64_tr_b16 v[90:91], v76 offset:10592
		ds_read_b64_tr_b16 v[92:93], v3 offset:50912
		ds_read_b64_tr_b16 v[94:95], v3 offset:59360
		ds_read_b64_tr_b16 v[96:97], v76 offset:2272
		ds_read_b64_tr_b16 v[98:99], v76 offset:10720
		ds_read_b64_tr_b16 v[100:101], v3 offset:51040
		ds_read_b64_tr_b16 v[102:103], v3 offset:59488
		ds_read_b64_tr_b16 v[224:225], v76 offset:2400
		ds_read_b64_tr_b16 v[226:227], v76 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[40:43], v[108:111]
		s_add_i32 s0, s0, -1
		s_ashr_i32 s1, s0, 31
		s_xor_b32 s0, s0, s1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[40:43], v[112:115]
		s_sub_i32 s0, s0, s1
		s_mul_hi_u32 s3, s0, 0xaaaaaaab
		s_lshr_b32 s3, s3, 1
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[40:43], v[116:119]
		s_mul_i32 s3, s3, 3
		s_sub_i32 s0, s0, s3
		s_xor_b32 s0, s0, s1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[40:43], v[120:123]
		s_sub_i32 s0, s0, s1
		s_mul_i32 s1, 0x4200, s0
		s_add_i32 s1, s1, s2
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[48:51], v[136:139]
		v_add_u32_e32 v3, s1, v9
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[224:227], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[224:227], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[224:227], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[224:227], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		ds_read_b128 v[40:43], v3
		ds_read_b128 v[44:47], v3 offset:64
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:320
		ds_read_b128 v[56:59], v3 offset:512
		ds_read_b128 v[60:63], v3 offset:576
		ds_read_b128 v[64:67], v3 offset:768
		ds_read_b128 v[68:71], v3 offset:832
		s_mul_i32 s0, 0x8400, s0
		s_add_i32 s1, s0, s13
		s_add_i32 s1, s1, s20
		v_add_u32_e32 v3, s1, v5
		ds_read_b64_tr_b16 v[72:73], v3 offset:50656
		ds_read_b64_tr_b16 v[74:75], v3 offset:59104
		s_add_i32 s0, s0, 0x10000
		s_add_i32 s0, s0, s13
		s_add_i32 s0, s0, s20
		v_add_u32_e32 v5, s0, v5
		ds_read_b64_tr_b16 v[76:77], v5 offset:2016
		ds_read_b64_tr_b16 v[78:79], v5 offset:10464
		ds_read_b64_tr_b16 v[80:81], v3 offset:50784
		ds_read_b64_tr_b16 v[82:83], v3 offset:59232
		ds_read_b64_tr_b16 v[84:85], v5 offset:2144
		ds_read_b64_tr_b16 v[86:87], v5 offset:10592
		ds_read_b64_tr_b16 v[88:89], v3 offset:50912
		ds_read_b64_tr_b16 v[90:91], v3 offset:59360
		ds_read_b64_tr_b16 v[92:93], v5 offset:2272
		ds_read_b64_tr_b16 v[94:95], v5 offset:10720
		ds_read_b64_tr_b16 v[96:97], v3 offset:51040
		ds_read_b64_tr_b16 v[98:99], v3 offset:59488
		ds_read_b64_tr_b16 v[100:101], v5 offset:2400
		ds_read_b64_tr_b16 v[102:103], v5 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[40:43], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[40:43], v[120:123]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[68:71], v[160:163]
		v_lshlrev_b32_e32 v3, 4, v0
		ds_write_b128 v3, v[108:111]
		v_xor_b32_e32 v5, 1, v0
		v_lshlrev_b32_e32 v5, 4, v5
		ds_write_b128 v5, v[112:115] offset:8192
		v_xor_b32_e32 v9, 2, v0
		v_lshlrev_b32_e32 v9, 4, v9
		ds_write_b128 v9, v[116:119] offset:16384
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[120:123] offset:24576
		s_lshl_b32 s0, s16, 1
		s_add_i32 s1, s0, 16
		s_add_i32 s2, s0, 0x100
		s_add_i32 s3, s0, 0x110
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v40, 3, v21
		v_and_b32_e32 v40, 3, v40
		v_lshlrev_b32_e32 v41, 13, v40
		v_lshrrev_b32_e32 v42, 5, v21
		v_and_b32_e32 v21, 7, v21
		v_lshlrev_b32_e32 v43, 5, v21
		v_add3_u32 v44, s0, v42, v43
		v_lshlrev_b32_e32 v21, 2, v21
		v_add_u32_e32 v45, s4, v21
		v_and_b32_e32 v45, 4, v45
		v_bitop3_b32 v44, v44, v40, v45 bitop3:0x96
		v_lshl_add_u32 v44, v44, 4, v41
		ds_read_b128 v[48:51], v44
		v_add3_u32 v45, s1, v42, v43
		v_add3_u32 v46, s4, 2, v21
		v_and_b32_e32 v46, 4, v46
		v_bitop3_b32 v45, v45, v40, v46 bitop3:0x96
		v_lshl_add_u32 v45, v45, 4, v41
		ds_read_b128 v[52:55], v45
		v_add3_u32 v46, s2, v42, v43
		v_add3_u32 v42, s3, v42, v43
		v_add3_u32 v43, s4, 32, v21
		v_and_b32_e32 v43, 4, v43
		v_bitop3_b32 v43, v46, v40, v43 bitop3:0x96
		v_lshl_add_u32 v43, v43, 4, v41
		ds_read_b128 v[56:59], v43
		v_add3_u32 v21, s4, 34, v21
		v_and_b32_e32 v21, 4, v21
		v_bitop3_b32 v21, v42, v40, v21 bitop3:0x96
		v_lshl_add_u32 v21, v21, 4, v41
		ds_read_b128 v[60:63], v21
		v_cvt_f32_f16_e32 v40, v1
		v_cvt_f32_f16_e32 v41, v4
		v_cvt_f32_f16_e32 v46, v7
		v_cvt_f32_f16_e32 v47, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[124:127]
		ds_write_b128 v5, v[128:131] offset:8192
		ds_write_b128 v9, v[132:135] offset:16384
		ds_write_b128 v0, v[136:139] offset:24576
		v_cvt_f32_f16_e32 v64, v15
		v_cvt_f32_f16_e32 v65, v20
		v_cvt_f32_f16_e32 v66, v23
		v_cvt_f32_f16_e32 v67, v24
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v44
		ds_read_b128 v[72:75], v45
		ds_read_b128 v[76:79], v43
		ds_read_b128 v[80:83], v21
		v_cvt_f32_f16_e32 v84, v30
		v_cvt_f32_f16_e32 v85, v31
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v30, v32
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v31, v33
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[140:143]
		ds_write_b128 v5, v[144:147] offset:8192
		ds_write_b128 v9, v[148:151] offset:16384
		ds_write_b128 v0, v[152:155] offset:24576
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v32, v34
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v33, v35
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v34, v36
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v35, v25
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[88:91], v44
		ds_read_b128 v[92:95], v45
		ds_read_b128 v[96:99], v43
		ds_read_b128 v[100:103], v21
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v24, v38
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v25, v39
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v38, v104
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v39, v105
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[156:159]
		ds_write_b128 v5, v[160:163] offset:8192
		ds_write_b128 v9, v[164:167] offset:16384
		ds_write_b128 v0, v[168:171] offset:24576
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v0, v106
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v1, v107
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v4, v172
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v5, v37
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[104:107], v44
		ds_read_b128 v[108:111], v45
		ds_read_b128 v[112:115], v43
		ds_read_b128 v[116:119], v21
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v8, v174
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v9, v175
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v20, v176
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v21, v177
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v36, v178
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v37, v179
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v42, v180
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v43, v173
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v44, v182
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v45, v183
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v86, v184
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v87, v185
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v120, v186
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v121, v187
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v122, v188
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v123, v181
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v124, v190
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v125, v191
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v126, v192
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v127, v193
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v128, v194
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v129, v195
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v130, v196
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v131, v189
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v132, v198
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v133, v199
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v134, v200
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v135, v201
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v136, v202
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v137, v203
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v138, v204
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v139, v197
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v140, v206
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v141, v207
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v142, v208
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v143, v209
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v144, v210
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v145, v211
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v146, v212
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v147, v205
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v148, v214
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v149, v215
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v150, v216
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v151, v217
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v152, v218
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v153, v219
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v154, v220
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v155, v213
		v_pk_add_f32 v[48:49], v[48:49], v[40:41]
		v_pk_fma_f32 v[156:157], v[48:49], v[84:85], v[48:49]
		v_cvt_pk_f16_f32 v3, v156, v157
		v_pk_add_f32 v[48:49], v[50:51], v[46:47]
		v_pk_fma_f32 v[50:51], v[48:49], v[30:31], v[48:49]
		v_cvt_pk_f16_f32 v7, v50, v51
		v_pk_add_f32 v[30:31], v[52:53], v[64:65]
		v_pk_fma_f32 v[48:49], v[30:31], v[32:33], v[30:31]
		v_cvt_pk_f16_f32 v15, v48, v49
		v_pk_add_f32 v[30:31], v[54:55], v[66:67]
		v_pk_fma_f32 v[32:33], v[30:31], v[34:35], v[30:31]
		v_cvt_pk_f16_f32 v23, v32, v33
		v_pk_add_f32 v[30:31], v[56:57], v[40:41]
		v_pk_fma_f32 v[32:33], v[30:31], v[24:25], v[30:31]
		v_cvt_pk_f16_f32 v24, v32, v33
		v_pk_add_f32 v[30:31], v[58:59], v[46:47]
		v_pk_fma_f32 v[32:33], v[30:31], v[38:39], v[30:31]
		v_cvt_pk_f16_f32 v25, v32, v33
		v_pk_add_f32 v[30:31], v[60:61], v[64:65]
		v_pk_fma_f32 v[32:33], v[30:31], v[0:1], v[30:31]
		v_cvt_pk_f16_f32 v0, v32, v33
		v_pk_add_f32 v[30:31], v[62:63], v[66:67]
		v_pk_fma_f32 v[32:33], v[30:31], v[4:5], v[30:31]
		v_cvt_pk_f16_f32 v1, v32, v33
		v_pk_add_f32 v[4:5], v[68:69], v[40:41]
		v_pk_fma_f32 v[30:31], v[4:5], v[8:9], v[4:5]
		v_cvt_pk_f16_f32 v4, v30, v31
		v_pk_add_f32 v[8:9], v[70:71], v[46:47]
		v_pk_fma_f32 v[30:31], v[8:9], v[20:21], v[8:9]
		v_cvt_pk_f16_f32 v5, v30, v31
		v_pk_add_f32 v[8:9], v[72:73], v[64:65]
		v_pk_fma_f32 v[20:21], v[8:9], v[36:37], v[8:9]
		v_cvt_pk_f16_f32 v8, v20, v21
		v_pk_add_f32 v[20:21], v[74:75], v[66:67]
		v_pk_fma_f32 v[30:31], v[20:21], v[42:43], v[20:21]
		v_cvt_pk_f16_f32 v9, v30, v31
		v_pk_add_f32 v[20:21], v[76:77], v[40:41]
		v_pk_fma_f32 v[30:31], v[20:21], v[44:45], v[20:21]
		v_cvt_pk_f16_f32 v20, v30, v31
		v_pk_add_f32 v[30:31], v[78:79], v[46:47]
		v_pk_fma_f32 v[32:33], v[30:31], v[86:87], v[30:31]
		v_cvt_pk_f16_f32 v21, v32, v33
		v_pk_add_f32 v[30:31], v[80:81], v[64:65]
		v_pk_fma_f32 v[32:33], v[30:31], v[120:121], v[30:31]
		v_cvt_pk_f16_f32 v30, v32, v33
		v_pk_add_f32 v[32:33], v[82:83], v[66:67]
		v_pk_fma_f32 v[34:35], v[32:33], v[122:123], v[32:33]
		v_cvt_pk_f16_f32 v31, v34, v35
		v_pk_add_f32 v[32:33], v[88:89], v[40:41]
		v_pk_fma_f32 v[34:35], v[32:33], v[124:125], v[32:33]
		v_cvt_pk_f16_f32 v32, v34, v35
		v_pk_add_f32 v[34:35], v[90:91], v[46:47]
		v_pk_fma_f32 v[36:37], v[34:35], v[126:127], v[34:35]
		v_cvt_pk_f16_f32 v33, v36, v37
		v_pk_add_f32 v[34:35], v[92:93], v[64:65]
		v_pk_fma_f32 v[36:37], v[34:35], v[128:129], v[34:35]
		v_cvt_pk_f16_f32 v34, v36, v37
		v_pk_add_f32 v[36:37], v[94:95], v[66:67]
		v_pk_fma_f32 v[38:39], v[36:37], v[130:131], v[36:37]
		v_cvt_pk_f16_f32 v35, v38, v39
		v_pk_add_f32 v[36:37], v[96:97], v[40:41]
		v_pk_fma_f32 v[38:39], v[36:37], v[132:133], v[36:37]
		v_cvt_pk_f16_f32 v36, v38, v39
		v_pk_add_f32 v[38:39], v[98:99], v[46:47]
		v_pk_fma_f32 v[42:43], v[38:39], v[134:135], v[38:39]
		v_cvt_pk_f16_f32 v37, v42, v43
		v_pk_add_f32 v[38:39], v[100:101], v[64:65]
		v_pk_fma_f32 v[42:43], v[38:39], v[136:137], v[38:39]
		v_cvt_pk_f16_f32 v38, v42, v43
		v_pk_add_f32 v[42:43], v[102:103], v[66:67]
		v_pk_fma_f32 v[44:45], v[42:43], v[138:139], v[42:43]
		v_cvt_pk_f16_f32 v39, v44, v45
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[42:43], v[104:105], v[40:41]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[40:41], v[112:113], v[40:41]
		v_pk_fma_f32 v[44:45], v[42:43], v[140:141], v[42:43]
		v_pk_fma_f32 v[42:43], v[40:41], v[148:149], v[40:41]
		v_cvt_pk_f16_f32 v40, v44, v45
		v_cvt_pk_f16_f32 v41, v42, v43
		v_pk_add_f32 v[42:43], v[106:107], v[46:47]
		v_pk_add_f32 v[44:45], v[114:115], v[46:47]
		v_pk_fma_f32 v[46:47], v[42:43], v[142:143], v[42:43]
		v_pk_fma_f32 v[42:43], v[44:45], v[150:151], v[44:45]
		v_cvt_pk_f16_f32 v44, v46, v47
		v_cvt_pk_f16_f32 v42, v42, v43
		v_pk_add_f32 v[46:47], v[108:109], v[64:65]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[48:49], v[116:117], v[64:65]
		v_pk_fma_f32 v[50:51], v[46:47], v[144:145], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[152:153], v[48:49]
		v_cvt_pk_f16_f32 v43, v50, v51
		v_cvt_pk_f16_f32 v45, v46, v47
		v_pk_add_f32 v[46:47], v[110:111], v[66:67]
		v_pk_add_f32 v[48:49], v[118:119], v[66:67]
		v_pk_fma_f32 v[50:51], v[46:47], v[146:147], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[154:155], v[48:49]
		v_cvt_pk_f16_f32 v48, v50, v51
		v_cvt_pk_f16_f32 v46, v46, v47
		v_and_b32_e32 v47, 0xffff, v3
		v_mul_lo_u32 v6, s19, v6
		v_add_lshl_u32 v49, v17, v6, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s26
		s_mov_b32 s3, s27
		buffer_store_short v47, v49, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v47, v22, v6, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v7
		v_add_lshl_u32 v47, v26, v6, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v7
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v7, v27, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v15
		v_add_lshl_u32 v7, v28, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v15
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v7, v29, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v23
		v_add_lshl_u32 v7, v18, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v23
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v6, v2, v6, 1
		buffer_store_short v3, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v24
		v_mul_lo_u32 v6, s19, v10
		v_add_lshl_u32 v7, v17, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v24
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v7, v22, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v25
		v_add_lshl_u32 v7, v26, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v25
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v7, v27, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v0
		v_add_lshl_u32 v7, v28, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v0
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v6, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v1
		v_add_lshl_u32 v3, v18, v6, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v1
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v6, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v4
		v_mul_lo_u32 v1, s19, v16
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v4
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v22, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v5
		v_add_lshl_u32 v3, v26, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v5
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v27, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v8
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v8
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v9
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v9
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v20
		v_mul_lo_u32 v1, s19, v19
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v20
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v22, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v21
		v_add_lshl_u32 v3, v26, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v21
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v27, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v30
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v30
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v31
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v31
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v32
		v_mul_lo_u32 v1, s19, v11
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v32
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v22, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v33
		v_add_lshl_u32 v3, v26, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v33
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v27, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v34
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v34
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v35
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v35
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v36
		v_mul_lo_u32 v1, s19, v12
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v36
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v22, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v37
		v_add_lshl_u32 v3, v26, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v37
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v27, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v38
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v38
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v39
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v39
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v40
		v_mul_lo_u32 v1, s19, v13
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v40
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v22, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v44
		v_add_lshl_u32 v3, v26, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v44
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v27, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v43
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v43
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v48
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v14
		v_lshrrev_b32_e32 v3, 16, v48
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v3, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v41
		v_add_lshl_u32 v3, v17, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v41
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v22, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v42
		v_add_lshl_u32 v3, v26, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v42
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v27, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v45
		v_add_lshl_u32 v3, v28, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v45
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v29, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v46
		v_add_lshl_u32 v3, v18, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v46
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v0, v2, v0, 1
		buffer_store_short v1, v0, s[0:3], 0 offen sc0 nt
		s_endpgm
	.size	tlx_addmm_glu_kernel_optimized, .-tlx_addmm_glu_kernel_optimized
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel tlx_addmm_glu_kernel_optimized
		.amdhsa_group_segment_fixed_size 152000
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 72
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 228
		.amdhsa_next_free_sgpr 42
		.amdhsa_accum_offset 228
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .Ltlx_addmm_glu_kernel_optimized.num_vgpr, 228
	.set .Ltlx_addmm_glu_kernel_optimized.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 42
	.set .Ltlx_addmm_glu_kernel_optimized.num_named_barrier, 0
	.set .Ltlx_addmm_glu_kernel_optimized.private_seg_size, 0
	.set .Ltlx_addmm_glu_kernel_optimized.uses_vcc, 1
	.set .Ltlx_addmm_glu_kernel_optimized.uses_flat_scratch, 0
	.set .Ltlx_addmm_glu_kernel_optimized.has_dyn_sized_stack, 0
	.set .Ltlx_addmm_glu_kernel_optimized.has_recursion, 0
	.set .Ltlx_addmm_glu_kernel_optimized.has_indirect_call, 0
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .name:           arg0
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .name:           arg1
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .name:           arg2
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .name:           arg3
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .name:           arg4
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
      - .name:           arg5
        .offset:         40
        .size:           4
        .value_kind:     by_value
      - .name:           arg6
        .offset:         44
        .size:           4
        .value_kind:     by_value
      - .name:           arg7
        .offset:         48
        .size:           4
        .value_kind:     by_value
      - .name:           arg8
        .offset:         52
        .size:           4
        .value_kind:     by_value
      - .name:           arg9
        .offset:         56
        .size:           4
        .value_kind:     by_value
      - .name:           arg10
        .offset:         60
        .size:           4
        .value_kind:     by_value
      - .name:           arg11
        .offset:         64
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 152000
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_optimized
    .private_segment_fixed_size: 0
    .sgpr_count:     42
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized.kd
    .uses_dynamic_stack: false
    .vgpr_count:     228
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 1
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 0
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
