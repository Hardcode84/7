	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	tlx_addmm_glu_kernel_optimized_async
	.p2align	8
	.type	tlx_addmm_glu_kernel_optimized_async,@function
tlx_addmm_glu_kernel_optimized_async:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .Ltlx_addmm_glu_kernel_optimized_async.kernarg_preload_entry
	.p2align	8
.Ltlx_addmm_glu_kernel_optimized_async.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s18, s[0:1], 0x3c
		s_load_dword s19, s[0:1], 0x40
		s_add_i32 s0, s12, 0x7f
		s_mov_b32 s1, 0x7f
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s20, s1, 0
		s_add_i32 s0, s0, s20
		s_ashr_i32 s0, s0, 7
		s_add_i32 s20, s13, 0x7f
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s20, s1
		s_ashr_i32 s1, s1, 7
		s_mul_i32 s20, s0, s1
		s_mov_b32 s21, 31
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s21, s21, 0
		s_add_i32 s20, s20, s21
		s_ashr_i32 s20, s20, 5
		s_mul_i32 s20, s20, 32
		s_cmp_ge_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.if_else_0
		s_mov_b32 s20, s16
		s_branch .Ltlx_addmm_glu_kernel_optimized_async.if_end_0
.Ltlx_addmm_glu_kernel_optimized_async.if_else_0:
		s_and_b32 s20, s16, 7
		s_lshr_b32 s16, s16, 3
		s_lshr_b32 s21, s16, 2
		s_mul_i32 s21, s21, 32
		s_mul_i32 s20, s20, 4
		s_add_i32 s20, s21, s20
		s_and_b32 s16, s16, 3
		s_add_i32 s20, s20, s16
.Ltlx_addmm_glu_kernel_optimized_async.if_end_0:
		s_mul_i32 s1, s1, 4
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
		s_mul_i32 s23, s21, 4
		s_sub_i32 s0, s0, s23
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
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
		s_sub_i32 s24, s22, s0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		v_readfirstlane_b32 s25, v0
		v_readfirstlane_b32 s26, v1
		s_mul_i32 s24, s24, s26
		s_mul_hi_u32 s24, s26, s24
		s_add_i32 s24, s26, s24
		s_mul_hi_u32 s24, s1, s24
		s_mul_i32 s26, s24, s0
		s_sub_i32 s1, s1, s26
		s_sub_i32 s26, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s1, s26, s1
		s_cselect_b32 s26, 1, 0
		s_sub_i32 s27, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s0, s27, s1
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s0, s0, s16
		s_sub_i32 s0, s0, s16
		s_add_i32 s23, s23, s0
		s_xor_b32 s16, s16, s20
		s_add_i32 s20, s24, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s20, s20, s24
		s_add_i32 s24, s20, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s24, s20
		s_xor_b32 s1, s1, s16
		s_sub_i32 s1, s1, s16
		s_mul_i32 s16, s23, 0x80
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v3, 1, v1
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 32
		v_mul_lo_u32 v6, v6, v5
		v_mad_u32_u24 v6, v3, 16, v6
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v8, 1, v7
		v_mad_u32_u24 v6, v8, 64, v6
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v10, 1, v9
		v_lshrrev_b32_e32 v11, 7, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v11
		v_add3_u32 v6, v6, v10, v12
		v_lshrrev_b32_e32 v13, 8, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v6, v14, 4, v6
		v_and_b32_e32 v15, 15, v0
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v15
		v_and_b32_e32 v15, 63, v0
		v_and_b32_e32 v9, 7, v9
		v_add_u32_e32 v17, 0x48, v9
		v_add_u32_e32 v18, 0x50, v9
		v_add_u32_e32 v19, 0x58, v9
		v_add_u32_e32 v20, 0x60, v9
		v_add_u32_e32 v21, 0x68, v9
		v_add_u32_e32 v22, 0x70, v9
		v_add_u32_e32 v23, 0x78, v9
		v_add_u32_e32 v24, s16, v6
		s_mul_i32 s20, s1, 0x80
		v_ashrrev_i32_e32 v25, 31, v24
		v_xor_b32_e32 v24, v24, v25
		v_sub_u32_e32 v24, v24, v25
		s_ashr_i32 s23, s12, 31
		s_xor_b32 s24, s12, s23
		s_sub_i32 s23, s24, s23
		v_mov_b32_e32 v26, s23
		v_cvt_f32_u32_e32 v27, v26
		v_rcp_iflag_f32_e32 v27, v27
		v_add3_u32 v6, 8, v6, s16
		v_mul_f32_e32 v27, v2, v27
		v_cvt_u32_f32_e32 v27, v27
		s_sub_i32 s24, s22, s23
		v_mul_lo_u32 v28, s24, v27
		v_mul_hi_u32 v28, v27, v28
		v_add_u32_e32 v27, v27, v28
		v_mul_hi_u32 v28, v24, v27
		v_mul_lo_u32 v28, v28, s23
		v_sub_u32_e32 v24, v24, v28
		v_sub_u32_e32 v28, v24, v26
		v_cmp_ge_u32_e64 vcc, v24, s23
		s_lshr_b32 s24, s25, 6
		v_add_u32_e32 v17, s16, v17
		v_cndmask_b32_e32 v24, v24, v28, vcc
		v_sub_u32_e32 v28, v24, v26
		v_cmp_ge_u32_e64 vcc, v24, s23
		v_add_u32_e32 v29, s16, v9
		v_add3_u32 v30, 8, v9, s16
		v_cndmask_b32_e32 v24, v24, v28, vcc
		v_xor_b32_e32 v24, v24, v25
		v_ashrrev_i32_e32 v28, 31, v6
		v_xor_b32_e32 v6, v6, v28
		v_sub_u32_e32 v6, v6, v28
		v_mul_hi_u32 v31, v6, v27
		v_mul_lo_u32 v31, v31, s23
		v_sub_u32_e32 v6, v6, v31
		v_sub_u32_e32 v31, v6, v26
		v_cmp_ge_u32_e64 vcc, v6, s23
		v_add3_u32 v32, 16, v9, s16
		v_add3_u32 v33, 24, v9, s16
		v_cndmask_b32_e32 v6, v6, v31, vcc
		v_sub_u32_e32 v31, v6, v26
		v_cmp_ge_u32_e64 vcc, v6, s23
		v_add3_u32 v34, 32, v9, s16
		v_add3_u32 v35, 40, v9, s16
		v_cndmask_b32_e32 v6, v6, v31, vcc
		v_xor_b32_e32 v6, v6, v28
		v_ashrrev_i32_e32 v31, 31, v29
		v_xor_b32_e32 v29, v29, v31
		v_sub_u32_e32 v29, v29, v31
		v_mul_hi_u32 v36, v29, v27
		v_mul_lo_u32 v36, v36, s23
		v_sub_u32_e32 v29, v29, v36
		v_sub_u32_e32 v36, v29, v26
		v_cmp_ge_u32_e64 vcc, v29, s23
		v_add3_u32 v37, 48, v9, s16
		v_add3_u32 v38, 56, v9, s16
		v_cndmask_b32_e32 v29, v29, v36, vcc
		v_sub_u32_e32 v36, v29, v26
		v_cmp_ge_u32_e64 vcc, v29, s23
		v_add3_u32 v9, 64, v9, s16
		v_sub_u32_e32 v24, v24, v25
		v_cndmask_b32_e32 v25, v29, v36, vcc
		v_xor_b32_e32 v25, v25, v31
		v_ashrrev_i32_e32 v29, 31, v30
		v_xor_b32_e32 v30, v30, v29
		v_sub_u32_e32 v30, v30, v29
		v_mul_hi_u32 v36, v30, v27
		v_mul_lo_u32 v36, v36, s23
		v_sub_u32_e32 v30, v30, v36
		v_sub_u32_e32 v36, v30, v26
		v_cmp_ge_u32_e64 vcc, v30, s23
		v_add_u32_e32 v18, s16, v18
		v_add_u32_e32 v19, s16, v19
		v_cndmask_b32_e32 v30, v30, v36, vcc
		v_sub_u32_e32 v36, v30, v26
		v_cmp_ge_u32_e64 vcc, v30, s23
		v_add_u32_e32 v20, s16, v20
		v_add_u32_e32 v21, s16, v21
		v_cndmask_b32_e32 v30, v30, v36, vcc
		v_xor_b32_e32 v30, v30, v29
		v_ashrrev_i32_e32 v36, 31, v32
		v_xor_b32_e32 v32, v32, v36
		v_sub_u32_e32 v32, v32, v36
		v_mul_hi_u32 v39, v32, v27
		v_mul_lo_u32 v39, v39, s23
		v_sub_u32_e32 v32, v32, v39
		v_sub_u32_e32 v39, v32, v26
		v_cmp_ge_u32_e64 vcc, v32, s23
		v_add_u32_e32 v22, s16, v22
		v_add_u32_e32 v23, s16, v23
		v_cndmask_b32_e32 v32, v32, v39, vcc
		v_sub_u32_e32 v39, v32, v26
		v_cmp_ge_u32_e64 vcc, v32, s23
		v_add_u32_e32 v40, s20, v16
		v_mad_u32_u24 v15, v15, 2, s20
		v_cndmask_b32_e32 v32, v32, v39, vcc
		v_xor_b32_e32 v32, v32, v36
		v_ashrrev_i32_e32 v39, 31, v33
		v_xor_b32_e32 v33, v33, v39
		v_sub_u32_e32 v33, v33, v39
		v_mul_hi_u32 v41, v33, v27
		v_mul_lo_u32 v41, v41, s23
		v_sub_u32_e32 v33, v33, v41
		v_sub_u32_e32 v41, v33, v26
		v_cmp_ge_u32_e64 vcc, v33, s23
		v_add3_u32 v42, 1, v16, s20
		v_add3_u32 v43, 2, v16, s20
		v_cndmask_b32_e32 v33, v33, v41, vcc
		v_sub_u32_e32 v41, v33, v26
		v_cmp_ge_u32_e64 vcc, v33, s23
		v_add3_u32 v44, 3, v16, s20
		v_add3_u32 v45, 4, v16, s20
		v_cndmask_b32_e32 v33, v33, v41, vcc
		v_xor_b32_e32 v33, v33, v39
		v_ashrrev_i32_e32 v41, 31, v34
		v_xor_b32_e32 v34, v34, v41
		v_sub_u32_e32 v34, v34, v41
		v_mul_hi_u32 v46, v34, v27
		v_mul_lo_u32 v46, v46, s23
		v_sub_u32_e32 v34, v34, v46
		v_sub_u32_e32 v46, v34, v26
		v_cmp_ge_u32_e64 vcc, v34, s23
		v_add3_u32 v47, 5, v16, s20
		v_add3_u32 v48, 6, v16, s20
		v_cndmask_b32_e32 v34, v34, v46, vcc
		v_sub_u32_e32 v46, v34, v26
		v_cmp_ge_u32_e64 vcc, v34, s23
		v_add3_u32 v16, 7, v16, s20
		v_sub_u32_e32 v6, v6, v28
		v_cndmask_b32_e32 v28, v34, v46, vcc
		v_xor_b32_e32 v28, v28, v41
		v_ashrrev_i32_e32 v34, 31, v35
		v_xor_b32_e32 v35, v35, v34
		v_sub_u32_e32 v35, v35, v34
		v_mul_hi_u32 v46, v35, v27
		v_mul_lo_u32 v46, v46, s23
		v_sub_u32_e32 v35, v35, v46
		v_sub_u32_e32 v46, v35, v26
		v_cmp_ge_u32_e64 vcc, v35, s23
		v_sub_u32_e32 v25, v25, v31
		v_sub_u32_e32 v29, v30, v29
		v_cndmask_b32_e32 v30, v35, v46, vcc
		v_sub_u32_e32 v31, v30, v26
		v_cmp_ge_u32_e64 vcc, v30, s23
		v_sub_u32_e32 v32, v32, v36
		v_sub_u32_e32 v33, v33, v39
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_xor_b32_e32 v30, v30, v34
		v_ashrrev_i32_e32 v31, 31, v37
		v_xor_b32_e32 v35, v37, v31
		v_sub_u32_e32 v35, v35, v31
		v_mul_hi_u32 v36, v35, v27
		v_mul_lo_u32 v36, v36, s23
		v_sub_u32_e32 v35, v35, v36
		v_sub_u32_e32 v36, v35, v26
		v_cmp_ge_u32_e64 vcc, v35, s23
		v_sub_u32_e32 v28, v28, v41
		v_sub_u32_e32 v30, v30, v34
		v_cndmask_b32_e32 v34, v35, v36, vcc
		v_cmp_ge_u32_e64 vcc, v34, s23
		v_sub_u32_e32 v35, v34, v26
		s_ashr_i32 s25, s13, 31
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_xor_b32_e32 v34, v34, v31
		v_ashrrev_i32_e32 v35, 31, v38
		v_xor_b32_e32 v36, v38, v35
		v_sub_u32_e32 v36, v36, v35
		v_mul_hi_u32 v37, v36, v27
		v_mul_lo_u32 v37, v37, s23
		v_sub_u32_e32 v36, v36, v37
		v_cmp_ge_u32_e64 vcc, v36, s23
		v_sub_u32_e32 v31, v34, v31
		v_sub_u32_e32 v34, v36, v26
		v_cndmask_b32_e32 v34, v36, v34, vcc
		v_cmp_ge_u32_e64 vcc, v34, s23
		v_sub_u32_e32 v36, v34, v26
		v_ashrrev_i32_e32 v37, 31, v9
		v_cndmask_b32_e32 v34, v34, v36, vcc
		v_xor_b32_e32 v34, v34, v35
		v_xor_b32_e32 v9, v9, v37
		v_sub_u32_e32 v9, v9, v37
		v_mul_hi_u32 v36, v9, v27
		v_mul_lo_u32 v36, v36, s23
		v_sub_u32_e32 v9, v9, v36
		v_cmp_ge_u32_e64 vcc, v9, s23
		v_sub_u32_e32 v34, v34, v35
		v_sub_u32_e32 v35, v9, v26
		v_cndmask_b32_e32 v9, v9, v35, vcc
		v_cmp_ge_u32_e64 vcc, v9, s23
		v_sub_u32_e32 v35, v9, v26
		v_ashrrev_i32_e32 v36, 31, v17
		v_cndmask_b32_e32 v9, v9, v35, vcc
		v_xor_b32_e32 v9, v9, v37
		v_xor_b32_e32 v17, v17, v36
		v_sub_u32_e32 v17, v17, v36
		v_mul_hi_u32 v35, v17, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v17, v17, v35
		v_cmp_ge_u32_e64 vcc, v17, s23
		v_sub_u32_e32 v9, v9, v37
		v_sub_u32_e32 v35, v17, v26
		v_cndmask_b32_e32 v17, v17, v35, vcc
		v_cmp_ge_u32_e64 vcc, v17, s23
		v_sub_u32_e32 v35, v17, v26
		v_ashrrev_i32_e32 v37, 31, v18
		v_cndmask_b32_e32 v17, v17, v35, vcc
		v_xor_b32_e32 v17, v17, v36
		v_xor_b32_e32 v18, v18, v37
		v_sub_u32_e32 v18, v18, v37
		v_mul_hi_u32 v35, v18, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v18, v18, v35
		v_cmp_ge_u32_e64 vcc, v18, s23
		v_sub_u32_e32 v17, v17, v36
		v_sub_u32_e32 v35, v18, v26
		v_cndmask_b32_e32 v18, v18, v35, vcc
		v_cmp_ge_u32_e64 vcc, v18, s23
		v_sub_u32_e32 v35, v18, v26
		v_ashrrev_i32_e32 v36, 31, v19
		v_cndmask_b32_e32 v18, v18, v35, vcc
		v_xor_b32_e32 v18, v18, v37
		v_xor_b32_e32 v19, v19, v36
		v_sub_u32_e32 v19, v19, v36
		v_mul_hi_u32 v35, v19, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v19, v19, v35
		v_cmp_ge_u32_e64 vcc, v19, s23
		v_sub_u32_e32 v18, v18, v37
		v_sub_u32_e32 v35, v19, v26
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_cmp_ge_u32_e64 vcc, v19, s23
		v_sub_u32_e32 v35, v19, v26
		v_ashrrev_i32_e32 v37, 31, v20
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_xor_b32_e32 v19, v19, v36
		v_xor_b32_e32 v20, v20, v37
		v_sub_u32_e32 v20, v20, v37
		v_mul_hi_u32 v35, v20, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v20, v20, v35
		v_cmp_ge_u32_e64 vcc, v20, s23
		v_sub_u32_e32 v19, v19, v36
		v_sub_u32_e32 v35, v20, v26
		v_cndmask_b32_e32 v20, v20, v35, vcc
		v_cmp_ge_u32_e64 vcc, v20, s23
		v_sub_u32_e32 v35, v20, v26
		v_ashrrev_i32_e32 v36, 31, v21
		v_cndmask_b32_e32 v20, v20, v35, vcc
		v_xor_b32_e32 v20, v20, v37
		v_xor_b32_e32 v21, v21, v36
		v_sub_u32_e32 v21, v21, v36
		v_mul_hi_u32 v35, v21, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v21, v21, v35
		v_cmp_ge_u32_e64 vcc, v21, s23
		v_sub_u32_e32 v20, v20, v37
		v_sub_u32_e32 v35, v21, v26
		v_cndmask_b32_e32 v21, v21, v35, vcc
		v_cmp_ge_u32_e64 vcc, v21, s23
		v_sub_u32_e32 v35, v21, v26
		v_ashrrev_i32_e32 v37, 31, v22
		v_cndmask_b32_e32 v21, v21, v35, vcc
		v_xor_b32_e32 v21, v21, v36
		v_xor_b32_e32 v22, v22, v37
		v_sub_u32_e32 v22, v22, v37
		v_mul_hi_u32 v35, v22, v27
		v_mul_lo_u32 v35, v35, s23
		v_sub_u32_e32 v22, v22, v35
		v_cmp_ge_u32_e64 vcc, v22, s23
		v_sub_u32_e32 v21, v21, v36
		v_sub_u32_e32 v35, v22, v26
		v_cndmask_b32_e32 v22, v22, v35, vcc
		v_cmp_ge_u32_e64 vcc, v22, s23
		v_sub_u32_e32 v35, v22, v26
		v_ashrrev_i32_e32 v36, 31, v23
		v_cndmask_b32_e32 v22, v22, v35, vcc
		v_xor_b32_e32 v22, v22, v37
		v_xor_b32_e32 v23, v23, v36
		v_sub_u32_e32 v23, v23, v36
		v_mul_hi_u32 v27, v23, v27
		v_mul_lo_u32 v27, v27, s23
		v_sub_u32_e32 v23, v23, v27
		v_cmp_ge_u32_e64 vcc, v23, s23
		v_sub_u32_e32 v22, v22, v37
		v_sub_u32_e32 v27, v23, v26
		v_cndmask_b32_e32 v23, v23, v27, vcc
		v_cmp_ge_u32_e64 vcc, v23, s23
		v_sub_u32_e32 v26, v23, v26
		v_ashrrev_i32_e32 v27, 31, v40
		v_cndmask_b32_e32 v23, v23, v26, vcc
		v_xor_b32_e32 v23, v23, v36
		v_xor_b32_e32 v26, v40, v27
		v_sub_u32_e32 v26, v26, v27
		s_xor_b32 s23, s13, s25
		s_sub_i32 s23, s23, s25
		v_mov_b32_e32 v35, s23
		v_cvt_f32_u32_e32 v37, v35
		v_rcp_iflag_f32_e32 v37, v37
		s_nop 0
		v_mul_f32_e32 v2, v2, v37
		v_cvt_u32_f32_e32 v2, v2
		s_sub_i32 s25, s22, s23
		v_mul_lo_u32 v37, s25, v2
		v_mul_hi_u32 v37, v2, v37
		v_add_u32_e32 v2, v2, v37
		v_mul_hi_u32 v37, v26, v2
		v_mul_lo_u32 v37, v37, s23
		v_sub_u32_e32 v26, v26, v37
		v_cmp_ge_u32_e64 vcc, v26, s23
		v_sub_u32_e32 v37, v26, v35
		s_add_i32 s25, s14, 63
		v_cndmask_b32_e32 v26, v26, v37, vcc
		v_cmp_ge_u32_e64 vcc, v26, s23
		v_sub_u32_e32 v37, v26, v35
		v_ashrrev_i32_e32 v38, 31, v15
		v_cndmask_b32_e32 v26, v26, v37, vcc
		v_xor_b32_e32 v26, v26, v27
		v_xor_b32_e32 v15, v15, v38
		v_sub_u32_e32 v15, v15, v38
		v_mul_hi_u32 v37, v15, v2
		v_mul_lo_u32 v37, v37, s23
		v_sub_u32_e32 v15, v15, v37
		v_cmp_ge_u32_e64 vcc, v15, s23
		v_sub_u32_e32 v26, v26, v27
		v_sub_u32_e32 v27, v15, v35
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_cmp_ge_u32_e64 vcc, v15, s23
		v_sub_u32_e32 v27, v15, v35
		v_ashrrev_i32_e32 v37, 31, v42
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_xor_b32_e32 v15, v15, v38
		v_xor_b32_e32 v27, v42, v37
		v_sub_u32_e32 v27, v27, v37
		v_mul_hi_u32 v39, v27, v2
		v_mul_lo_u32 v39, v39, s23
		v_sub_u32_e32 v27, v27, v39
		v_cmp_ge_u32_e64 vcc, v27, s23
		v_sub_u32_e32 v15, v15, v38
		v_sub_u32_e32 v38, v27, v35
		v_cndmask_b32_e32 v27, v27, v38, vcc
		v_cmp_ge_u32_e64 vcc, v27, s23
		v_sub_u32_e32 v38, v27, v35
		v_ashrrev_i32_e32 v39, 31, v43
		v_cndmask_b32_e32 v27, v27, v38, vcc
		v_xor_b32_e32 v27, v27, v37
		v_xor_b32_e32 v38, v43, v39
		v_sub_u32_e32 v38, v38, v39
		v_mul_hi_u32 v40, v38, v2
		v_mul_lo_u32 v40, v40, s23
		v_sub_u32_e32 v38, v38, v40
		v_cmp_ge_u32_e64 vcc, v38, s23
		v_sub_u32_e32 v27, v27, v37
		v_sub_u32_e32 v37, v38, v35
		v_cndmask_b32_e32 v37, v38, v37, vcc
		v_cmp_ge_u32_e64 vcc, v37, s23
		v_sub_u32_e32 v38, v37, v35
		v_ashrrev_i32_e32 v40, 31, v44
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_xor_b32_e32 v37, v37, v39
		v_xor_b32_e32 v38, v44, v40
		v_sub_u32_e32 v38, v38, v40
		v_mul_hi_u32 v41, v38, v2
		v_mul_lo_u32 v41, v41, s23
		v_sub_u32_e32 v38, v38, v41
		v_cmp_ge_u32_e64 vcc, v38, s23
		v_sub_u32_e32 v37, v37, v39
		v_sub_u32_e32 v39, v38, v35
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_cmp_ge_u32_e64 vcc, v38, s23
		v_sub_u32_e32 v39, v38, v35
		v_ashrrev_i32_e32 v41, 31, v45
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_xor_b32_e32 v38, v38, v40
		v_xor_b32_e32 v39, v45, v41
		v_sub_u32_e32 v39, v39, v41
		v_mul_hi_u32 v42, v39, v2
		v_mul_lo_u32 v42, v42, s23
		v_sub_u32_e32 v39, v39, v42
		v_cmp_ge_u32_e64 vcc, v39, s23
		v_sub_u32_e32 v38, v38, v40
		v_sub_u32_e32 v40, v39, v35
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_cmp_ge_u32_e64 vcc, v39, s23
		v_sub_u32_e32 v40, v39, v35
		v_ashrrev_i32_e32 v42, 31, v47
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_xor_b32_e32 v39, v39, v41
		v_xor_b32_e32 v40, v47, v42
		v_sub_u32_e32 v40, v40, v42
		v_mul_hi_u32 v43, v40, v2
		v_mul_lo_u32 v43, v43, s23
		v_sub_u32_e32 v40, v40, v43
		v_cmp_ge_u32_e64 vcc, v40, s23
		v_sub_u32_e32 v39, v39, v41
		v_sub_u32_e32 v41, v40, v35
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_cmp_ge_u32_e64 vcc, v40, s23
		v_sub_u32_e32 v41, v40, v35
		v_ashrrev_i32_e32 v43, 31, v48
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_xor_b32_e32 v40, v40, v42
		v_xor_b32_e32 v41, v48, v43
		v_sub_u32_e32 v41, v41, v43
		v_mul_hi_u32 v44, v41, v2
		v_mul_lo_u32 v44, v44, s23
		v_sub_u32_e32 v41, v41, v44
		v_cmp_ge_u32_e64 vcc, v41, s23
		v_sub_u32_e32 v40, v40, v42
		v_sub_u32_e32 v42, v41, v35
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_cmp_ge_u32_e64 vcc, v41, s23
		v_sub_u32_e32 v42, v41, v35
		v_ashrrev_i32_e32 v44, 31, v16
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_xor_b32_e32 v41, v41, v43
		v_xor_b32_e32 v16, v16, v44
		v_sub_u32_e32 v16, v16, v44
		v_mul_hi_u32 v2, v16, v2
		v_mul_lo_u32 v2, v2, s23
		v_sub_u32_e32 v2, v16, v2
		v_cmp_ge_u32_e64 vcc, v2, s23
		v_sub_u32_e32 v16, v41, v43
		v_sub_u32_e32 v41, v2, v35
		v_cndmask_b32_e32 v2, v2, v41, vcc
		v_cmp_ge_u32_e64 vcc, v2, s23
		v_sub_u32_e32 v35, v2, v35
		s_cmp_lt_i32 s25, 0
		v_cndmask_b32_e32 v2, v2, v35, vcc
		v_xor_b32_e32 v2, v2, v44
		s_mov_b32 s23, 63
		s_cselect_b32 s23, s23, 0
		v_and_b32_e32 v35, 1, v0
		v_mov_b32_e32 v41, 8
		v_mul_lo_u32 v41, v41, v35
		v_lshrrev_b32_e32 v35, 1, v0
		v_and_b32_e32 v35, 1, v35
		v_mov_b32_e32 v42, 16
		v_mul_lo_u32 v42, v42, v35
		v_lshrrev_b32_e32 v35, 2, v0
		v_and_b32_e32 v43, 1, v35
		v_mov_b32_e32 v45, 32
		v_mul_lo_u32 v45, v45, v43
		v_bitop3_b32 v41, v41, v42, v45 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v41, s14
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s2, v0
		v_mul_lo_u32 v42, s15, v24
		v_lshlrev_b32_e32 v42, 1, v42
		v_and_b32_e32 v43, 7, v0
		v_lshlrev_b32_e32 v43, 4, v43
		v_add_u32_e32 v45, v42, v43
		v_mov_b32_e32 v46, 0x80000000
		v_cndmask_b32_e32 v45, v46, v45, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		v_sub_u32_e32 v23, v23, v36
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		v_mul_lo_u32 v36, s15, v6
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v45, v36, v43
		v_cndmask_b32_e32 v45, v46, v45, vcc
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s4, s25, s23
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		v_mov_b32_e32 v45, 16
		v_mul_lo_u32 v45, v45, v5
		v_mov_b32_e32 v47, 32
		v_mul_lo_u32 v47, v47, v8
		v_bitop3_b32 v48, v45, v47, v10 bitop3:0x96
		v_mov_b32_e32 v49, 8
		v_mul_lo_u32 v49, v49, v14
		v_bitop3_b32 v48, v48, v12, v49 bitop3:0x96
		v_bitop3_b32 v45, 4, v45, v47 bitop3:0x96
		v_xor_b32_e32 v45, v45, v10
		v_cmp_lt_i32_e64 vcc, v48, s14
		s_lshr_b32 s5, s24, 2
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s23, s17, s5
		s_lshl_b32 s23, s23, 3
		s_mul_i32 s25, s17, s24
		s_lshl_b32 s25, s25, 1
		s_add_i32 s26, s23, s25
		v_lshlrev_b32_e32 v26, 1, v26
		v_add_u32_e32 v47, s26, v26
		v_and_b32_e32 v50, 1, v7
		v_mul_lo_u32 v51, s17, v50
		v_lshlrev_b32_e32 v51, 6, v51
		v_and_b32_e32 v52, 1, v4
		v_mul_lo_u32 v53, s17, v52
		v_lshlrev_b32_e32 v53, 5, v53
		v_add3_u32 v47, v47, v51, v53
		v_cndmask_b32_e32 v47, v46, v47, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_sub_u32_e32 v2, v2, v44
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		s_lshl_b32 s26, s17, 3
		s_add_i32 s26, s26, s23
		s_add_i32 s26, s26, s25
		v_add_u32_e32 v44, s26, v26
		v_add3_u32 v44, v44, v51, v53
		v_cndmask_b32_e32 v44, v46, v44, vcc
		s_add_i32 m0, m0, 0x2100
		s_ashr_i32 s4, s4, 6
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_sub_i32 s26, s14, 64
		v_cmp_lt_i32_e64 vcc, v41, s26
		v_add_u32_e32 v44, 0x80, v42
		v_add_u32_e32 v44, v44, v43
		v_cndmask_b32_e32 v44, v46, v44, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_bitop3_b32 v12, v45, v12, v49 bitop3:0x96
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		v_add_u32_e32 v44, 0x80, v36
		v_add_u32_e32 v44, v44, v43
		v_cndmask_b32_e32 v44, v46, v44, vcc
		v_cmp_lt_i32_e64 vcc, v48, s26
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s26, s17, 7
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_add_i32 s27, s26, s23
		s_add_i32 s27, s27, s25
		v_add_u32_e32 v44, s27, v26
		v_add3_u32 v44, v44, v51, v53
		v_cndmask_b32_e32 v44, v46, v44, vcc
		s_add_i32 m0, m0, 0xa4e0
		s_lshr_b32 s27, s24, 1
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_mul_i32 s36, 0x88, s17
		s_add_i32 s36, s36, s23
		s_add_i32 s36, s36, s25
		v_add_u32_e32 v44, s36, v26
		v_add3_u32 v44, v44, v51, v53
		v_cndmask_b32_e32 v44, v46, v44, vcc
		s_add_i32 m0, m0, 0x2100
		s_sub_i32 s36, s14, 0x80
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v41, s36
		v_add_u32_e32 v42, 0x100, v42
		v_add_u32_e32 v42, v42, v43
		v_cndmask_b32_e32 v42, v46, v42, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_add_u32_e32 v36, 0x100, v36
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		v_add_u32_e32 v36, v36, v43
		v_cndmask_b32_e32 v36, v46, v36, vcc
		v_cmp_lt_i32_e64 vcc, v48, s36
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s36, s17, 8
		buffer_load_dwordx4 v36, s[28:31], 0 offen lds
		s_add_i32 s36, s36, s23
		s_add_i32 s36, s36, s25
		v_add_u32_e32 v36, s36, v26
		v_add3_u32 v36, v36, v51, v53
		v_cndmask_b32_e32 v36, v46, v36, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_and_b32_e32 v42, 63, v0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_mul_i32 s36, 0x108, s17
		s_add_i32 s36, s36, s23
		s_add_i32 s36, s36, s25
		v_add_u32_e32 v36, s36, v26
		v_add3_u32 v36, v36, v51, v53
		v_cndmask_b32_e32 v36, v46, v36, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s36, s5, 7
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v36, 4, v42
		v_lshlrev_b32_e32 v44, 4, v36
		v_and_b32_e32 v45, 15, v42
		v_mov_b32_e32 v47, 0x420
		v_mul_lo_u32 v47, v47, v45
		v_add3_u32 v45, s36, v44, v47
		ds_read_b128 v[56:59], v45
		ds_read_b128 v[60:63], v45 offset:64
		ds_read_b128 v[64:67], v45 offset:256
		ds_read_b128 v[68:71], v45 offset:320
		ds_read_b128 v[72:75], v45 offset:512
		ds_read_b128 v[76:79], v45 offset:576
		ds_read_b128 v[80:83], v45 offset:768
		ds_read_b128 v[84:87], v45 offset:832
		s_and_b32 s37, s27, 1
		s_lshl_b32 s38, s37, 6
		s_and_b32 s24, s24, 1
		s_lshl_b32 s39, s24, 5
		s_add_i32 s40, s38, s39
		v_and_b32_e32 v45, 3, v0
		v_lshlrev_b32_e32 v45, 3, v45
		v_add_u32_e32 v49, s40, v45
		v_lshlrev_b32_e32 v50, 8, v50
		v_mov_b32_e32 v54, 0x1080
		v_mul_lo_u32 v54, v54, v52
		v_add3_u32 v49, v49, v50, v54
		v_and_b32_e32 v52, 1, v1
		v_mov_b32_e32 v55, 0x840
		v_mul_lo_u32 v55, v55, v52
		v_and_b32_e32 v35, 1, v35
		v_mov_b32_e32 v52, 0x420
		v_mul_lo_u32 v52, v52, v35
		v_add3_u32 v35, v49, v55, v52
		ds_read_b64_tr_b16 v[88:89], v35 offset:50656
		ds_read_b64_tr_b16 v[90:91], v35 offset:59104
		ds_read_b64_tr_b16 v[92:93], v35 offset:51168
		ds_read_b64_tr_b16 v[94:95], v35 offset:59616
		ds_read_b64_tr_b16 v[96:97], v35 offset:50784
		ds_read_b64_tr_b16 v[98:99], v35 offset:59232
		ds_read_b64_tr_b16 v[100:101], v35 offset:51296
		ds_read_b64_tr_b16 v[102:103], v35 offset:59744
		s_sub_i32 s41, s4, 3
		v_cmp_ne_u32_e64 vcc, v13, s22
		v_cmp_eq_u32_e64 s[42:43], v13, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[46:47], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[46:47]
		s_setprio 0
		s_mul_i32 s44, 0x180, s17
		s_add_i32 s44, s44, s23
		s_add_i32 s44, s44, s25
		v_add_u32_e32 v13, s44, v26
		v_add3_u32 v35, v13, v51, v53
		s_mul_i32 s17, 0x188, s17
		s_add_i32 s17, s17, s23
		s_add_i32 s17, s17, s25
		v_add_u32_e32 v13, s17, v26
		v_add3_u32 v49, v13, v51, v53
		v_add_u32_e32 v13, 0x180, v43
		s_lshl_b32 s15, s15, 1
		v_mul_lo_u32 v24, s15, v24
		v_mul_lo_u32 v6, s15, v6
		v_add_u32_e32 v24, v13, v24
		v_add_u32_e32 v6, v13, v6
		v_add_u32_e32 v13, v44, v47
		v_add3_u32 v43, v45, v50, v54
		v_add3_u32 v43, v43, v55, v52
		s_cmp_lt_i32 0, s41
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
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
		s_mov_b32 s15, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[52:55], v[88:91], v[56:59], v[52:55]
		v_mfma_f32_16x16x32_f16 v[104:107], v[96:99], v[56:59], v[104:107]
		s_lshl_b32 s17, s22, 7
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[64:67], v[112:115]
		s_cmp_ge_u32 s15, 2
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[64:67], v[108:111]
		s_cselect_b32 s23, 1, 0
		s_sub_i32 s25, s15, 2
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[72:75], v[116:119]
		s_add_i32 s44, s15, 1
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[72:75], v[120:123]
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s25, s44
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[80:83], v[128:131]
		s_add_i32 s25, s22, 3
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[80:83], v[124:127]
		s_mul_i32 s25, s25, 64
		v_mfma_f32_16x16x32_f16 v[52:55], v[92:95], v[60:63], v[52:55]
		v_mfma_f32_16x16x32_f16 v[104:107], v[100:103], v[60:63], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[68:71], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[76:79], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[84:87], v[124:127]
		s_setprio 1
		s_barrier
		v_add_u32_e32 v44, s17, v24
		v_add_u32_e32 v45, s17, v6
		s_sub_i32 s17, s14, s25
		v_cmp_lt_i32_e64 vcc, v41, s17
		v_cmp_lt_i32_e64 s[44:45], v48, s17
		s_mul_i32 s15, 0x4200, s15
		v_cndmask_b32_e32 v44, v46, v44, vcc
		v_cndmask_b32_e32 v45, v46, v45, vcc
		v_cmp_lt_i32_e64 vcc, v12, s17
		s_add_i32 s15, s3, s15
		s_mov_b32 m0, s15
		s_mul_i32 s15, 0x4200, s23
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_add_i32 s17, s36, s15
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s15, s40, s15
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		v_cndmask_b32_e32 v44, v46, v49, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v45, v46, v35, s[44:45]
		buffer_load_dwordx4 v45, s[32:35], 0 offen lds
		v_add_u32_e32 v45, s17, v13
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v47, s15, v43
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(4)
		ds_read_b128 v[56:59], v45
		ds_read_b128 v[60:63], v45 offset:64
		ds_read_b128 v[64:67], v45 offset:256
		ds_read_b128 v[68:71], v45 offset:320
		ds_read_b128 v[72:75], v45 offset:512
		ds_read_b128 v[76:79], v45 offset:576
		ds_read_b128 v[80:83], v45 offset:768
		ds_read_b128 v[84:87], v45 offset:832
		ds_read_b64_tr_b16 v[88:89], v47 offset:50656
		ds_read_b64_tr_b16 v[90:91], v47 offset:59104
		ds_read_b64_tr_b16 v[92:93], v47 offset:51168
		ds_read_b64_tr_b16 v[94:95], v47 offset:59616
		ds_read_b64_tr_b16 v[96:97], v47 offset:50784
		ds_read_b64_tr_b16 v[98:99], v47 offset:59232
		ds_read_b64_tr_b16 v[100:101], v47 offset:51296
		ds_read_b64_tr_b16 v[102:103], v47 offset:59744
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v35, s26, v35
		v_add_u32_e32 v49, s26, v49
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s41
		s_mov_b32 s15, s23
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[46:47], s[42:43]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[46:47]
		s_mul_i32 s2, 0x108, s2
		s_add_i32 m0, s2, 0x18bc0
		v_mul_lo_u32 v6, s18, v25
		v_add_lshl_u32 v6, v15, v6, 1
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v29
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v32
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v33
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v28
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v30
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v31
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mul_lo_u32 v6, s18, v34
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v15, v6, 1
		v_mul_lo_u32 v9, s18, v9
		v_add_lshl_u32 v9, v15, v9, 1
		v_mul_lo_u32 v12, s18, v17
		v_add_lshl_u32 v12, v15, v12, 1
		v_mul_lo_u32 v17, s18, v18
		v_add_lshl_u32 v17, v15, v17, 1
		v_mul_lo_u32 v18, s18, v19
		v_add_lshl_u32 v18, v15, v18, 1
		v_mul_lo_u32 v19, s18, v20
		v_add_lshl_u32 v19, v15, v19, 1
		v_mul_lo_u32 v20, s18, v21
		v_add_lshl_u32 v20, v15, v20, 1
		v_mul_lo_u32 v21, s18, v22
		v_add_lshl_u32 v21, v15, v21, 1
		v_mul_lo_u32 v22, s18, v23
		v_add_lshl_u32 v15, v15, v22, 1
		v_mfma_f32_16x16x32_f16 v[52:55], v[88:91], v[56:59], v[52:55]
		v_mfma_f32_16x16x32_f16 v[104:107], v[96:99], v[56:59], v[104:107]
		buffer_load_dword v6, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[64:67], v[108:111]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[72:75], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[80:83], v[124:127]
		buffer_load_dword v9, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[52:55], v[92:95], v[60:63], v[52:55]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[104:107], v[100:103], v[60:63], v[104:107]
		buffer_load_dword v12, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[68:71], v[112:115]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[68:71], v[108:111]
		buffer_load_dword v17, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[76:79], v[116:119]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[76:79], v[120:123]
		buffer_load_dword v18, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[84:87], v[124:127]
		buffer_load_dword v19, s[32:35], 0 offen lds
		v_lshlrev_b32_e32 v6, 1, v27
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v9, 1, v37
		buffer_load_dword v20, s[32:35], 0 offen lds
		v_lshlrev_b32_e32 v12, 1, v38
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v17, 1, v39
		v_lshlrev_b32_e32 v18, 1, v40
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v2, 1, v2
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v8
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v11
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v14
		v_mov_b32_e32 v14, 64
		v_mul_lo_u32 v14, v14, v3
		v_xad_u32 v3, v41, v14, s20
		buffer_load_dword v21, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[2:3], v3, s13
		s_add_i32 m0, m0, 0x840
		s_sub_i32 s8, s4, 2
		s_ashr_i32 s9, s8, 31
		s_xor_b32 s8, s8, s9
		s_sub_i32 s8, s8, s9
		buffer_load_dword v15, s[32:35], 0 offen lds
		s_mul_hi_u32 s13, s8, 0xaaaaaaab
		s_lshr_b32 s13, s13, 1
		s_mul_i32 s13, s13, 3
		s_sub_i32 s8, s8, s13
		s_xor_b32 s8, s8, s9
		s_sub_i32 s8, s8, s9
		s_mul_i32 s8, 0x4200, s8
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		buffer_load_ushort v3, v26, s[32:35], 0 offen
		buffer_load_ushort v14, v6, s[32:35], 0 offen
		buffer_load_ushort v6, v9, s[32:35], 0 offen
		buffer_load_ushort v9, v12, s[32:35], 0 offen
		buffer_load_ushort v12, v17, s[32:35], 0 offen
		buffer_load_ushort v15, v18, s[32:35], 0 offen
		buffer_load_ushort v17, v16, s[32:35], 0 offen
		buffer_load_ushort v16, v2, s[32:35], 0 offen
		s_add_i32 s6, s8, s36
		v_add_u32_e32 v2, s6, v13
		s_add_i32 s6, s8, s38
		s_add_i32 s6, s6, s39
		v_add_u32_e32 v18, s6, v43
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[24:27], v2 offset:64
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:320
		ds_read_b128 v[44:47], v2 offset:512
		ds_read_b128 v[48:51], v2 offset:576
		ds_read_b128 v[56:59], v2 offset:768
		ds_read_b128 v[60:63], v2 offset:832
		ds_read_b64_tr_b16 v[64:65], v18 offset:50656
		ds_read_b64_tr_b16 v[66:67], v18 offset:59104
		ds_read_b64_tr_b16 v[68:69], v18 offset:51168
		ds_read_b64_tr_b16 v[70:71], v18 offset:59616
		ds_read_b64_tr_b16 v[72:73], v18 offset:50784
		ds_read_b64_tr_b16 v[74:75], v18 offset:59232
		ds_read_b64_tr_b16 v[76:77], v18 offset:51296
		ds_read_b64_tr_b16 v[78:79], v18 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[52:55], v[64:67], v[20:23], v[52:55]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[28:31], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		s_add_i32 s4, s4, -1
		s_ashr_i32 s6, s4, 31
		s_xor_b32 s4, s4, s6
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[28:31], v[112:115]
		s_sub_i32 s4, s4, s6
		s_mul_hi_u32 s7, s4, 0xaaaaaaab
		s_lshr_b32 s7, s7, 1
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[44:47], v[116:119]
		s_mul_i32 s7, s7, 3
		s_sub_i32 s4, s4, s7
		s_xor_b32 s4, s4, s6
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[44:47], v[120:123]
		s_sub_i32 s4, s4, s6
		s_mul_i32 s4, 0x4200, s4
		s_add_i32 s6, s4, s36
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[56:59], v[128:131]
		v_add_u32_e32 v2, s6, v13
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[52:55], v[68:71], v[24:27], v[52:55]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[60:63], v[124:127]
		s_add_i32 s4, s4, s38
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[24:27], v2 offset:64
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:320
		ds_read_b128 v[44:47], v2 offset:512
		ds_read_b128 v[48:51], v2 offset:576
		ds_read_b128 v[56:59], v2 offset:768
		ds_read_b128 v[60:63], v2 offset:832
		s_add_i32 s4, s4, s39
		v_add_u32_e32 v2, s4, v43
		ds_read_b64_tr_b16 v[64:65], v2 offset:50656
		ds_read_b64_tr_b16 v[66:67], v2 offset:59104
		ds_read_b64_tr_b16 v[68:69], v2 offset:51168
		ds_read_b64_tr_b16 v[70:71], v2 offset:59616
		ds_read_b64_tr_b16 v[72:73], v2 offset:50784
		ds_read_b64_tr_b16 v[74:75], v2 offset:59232
		ds_read_b64_tr_b16 v[76:77], v2 offset:51296
		ds_read_b64_tr_b16 v[78:79], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[52:55], v[64:67], v[20:23], v[52:55]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[28:31], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[28:31], v[112:115]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[52:55], v[68:71], v[24:27], v[52:55]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[60:63], v[124:127]
		s_and_b32 s4, 1, s27
		v_and_b32_e32 v2, 8, v4
		v_bitop3_b32 v1, 4, v1, v2 bitop3:0x6a
		v_bitop3_b32 v1, 2, v7, v1 bitop3:0x6a
		v_bitop3_b32 v1, v0, s4, v1 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		ds_write_b128 v1, v[52:55]
		ds_write_b128 v1, v[104:107] offset:8192
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v20, v3
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v21, v14
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v2, v6
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v3, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v6, 3, v42
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 13, v6
		s_lshl_b32 s4, s5, 8
		s_lshl_b32 s6, s37, 3
		s_add_i32 s4, s4, s6
		s_lshl_b32 s6, s24, 2
		s_add_i32 s4, s4, s6
		v_and_b32_e32 v7, 7, v42
		v_lshlrev_b32_e32 v9, 5, v7
		v_add3_u32 v13, s4, v36, v9
		s_lshl_b32 s6, s5, 1
		v_lshrrev_b32_e32 v14, 2, v7
		v_add_u32_e32 v14, s6, v14
		v_and_b32_e32 v14, 1, v14
		s_lshl_b32 s6, s5, 3
		v_add_u32_e32 v18, s6, v7
		v_and_b32_e32 v18, 2, v18
		s_lshl_b32 s6, s5, 5
		s_add_i32 s6, s6, s37
		v_lshlrev_b32_e32 v22, 2, v7
		v_add_u32_e32 v23, s6, v22
		s_lshl_b32 s5, s5, 4
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v24, s5, v7
		v_and_b32_e32 v24, 8, v24
		v_bitop3_b32 v23, 4, v23, v24 bitop3:0x6a
		v_xor_b32_e32 v23, v18, v23
		v_bitop3_b32 v13, v13, v14, v23 bitop3:0x96
		v_lshl_add_u32 v13, v13, 4, v6
		ds_read_b128 v[24:27], v13
		s_add_i32 s4, s4, 16
		v_add3_u32 v9, s4, v36, v9
		v_add3_u32 v22, s6, 2, v22
		v_add3_u32 v7, s5, 1, v7
		v_and_b32_e32 v7, 8, v7
		v_bitop3_b32 v7, 4, v22, v7 bitop3:0x6a
		v_xor_b32_e32 v7, v18, v7
		v_bitop3_b32 v7, v9, v14, v7 bitop3:0x96
		v_lshl_add_u32 v6, v7, 4, v6
		ds_read_b128 v[28:31], v6
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v22, v12
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v23, v15
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v14, v17
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v15, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[108:111]
		ds_write_b128 v1, v[112:115] offset:8192
		v_pk_add_f32 v[16:17], v[24:25], v[20:21]
		v_pk_add_f32 v[24:25], v[26:27], v[2:3]
		v_pk_add_f32 v[26:27], v[28:29], v[22:23]
		v_pk_add_f32 v[28:29], v[30:31], v[14:15]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v13
		ds_read_b128 v[36:39], v6
		v_bitop3_b32 v7, v5, v19, v8 bitop3:0x96
		v_xor_b32_e32 v7, v7, v10
		v_xad_u32 v7, v7, v11, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[30:31], v[32:33], v[20:21]
		v_cmp_lt_i32_e64 s[4:5], v7, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[116:119]
		ds_write_b128 v1, v[120:123] offset:8192
		v_pk_add_f32 v[32:33], v[34:35], v[2:3]
		v_pk_add_f32 v[34:35], v[36:37], v[22:23]
		v_pk_add_f32 v[36:37], v[38:39], v[14:15]
		s_and_b64 s[4:5], s[4:5], s[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v13
		ds_read_b128 v[44:47], v6
		v_bitop3_b32 v7, 32, v5, v19 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v10 bitop3:0x96
		v_xad_u32 v7, v7, v11, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[38:39], v[40:41], v[20:21]
		v_cmp_lt_i32_e64 s[6:7], v7, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[124:127]
		ds_write_b128 v1, v[128:131] offset:8192
		v_pk_add_f32 v[40:41], v[42:43], v[2:3]
		v_pk_add_f32 v[42:43], v[44:45], v[22:23]
		v_pk_add_f32 v[44:45], v[46:47], v[14:15]
		s_and_b64 s[6:7], s[6:7], s[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v13
		ds_read_b128 v[52:55], v6
		v_bitop3_b32 v1, 64, v5, v19 bitop3:0x96
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_xor_b32_e32 v5, 0x60, v5
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[6:7], v[48:49], v[20:21]
		v_pk_add_f32 v[2:3], v[50:51], v[2:3]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[12:13], v[52:53], v[22:23]
		v_pk_add_f32 v[14:15], v[54:55], v[14:15]
		v_xor_b32_e32 v5, v5, v19
		v_xor_b32_e32 v5, v5, v8
		v_xor_b32_e32 v5, v5, v10
		v_lshlrev_b32_e32 v8, 4, v0
		v_add_u32_e32 v8, 0x10000, v8
		v_lshl_add_u32 v8, v4, 3, v8
		ds_read_b128 v[20:23], v8 offset:35776
		v_mov_b32_e32 v8, 0x108
		v_mul_lo_u32 v8, v8, v4
		v_add_u32_e32 v8, 0x10000, v8
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v8, v8, v0
		ds_read_b128 v[48:51], v8 offset:44224
		ds_read_b128 v[52:55], v8 offset:52672
		ds_read_b128 v[56:59], v8 offset:61120
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v8, v20
		v_cvt_f32_f16_sdwa v9, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[18:19], v[16:17], v[8:9], v[16:17]
		v_cvt_pk_f16_f32 v60, v18, v19
		v_cvt_f32_f16_e32 v8, v21
		v_cvt_f32_f16_sdwa v9, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[16:17], v[24:25], v[8:9], v[24:25]
		v_cvt_pk_f16_f32 v61, v16, v17
		v_cvt_f32_f16_e32 v8, v22
		v_cvt_f32_f16_sdwa v9, v22 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[16:17], v[26:27], v[8:9], v[26:27]
		v_cvt_f32_f16_e32 v8, v23
		v_cvt_f32_f16_sdwa v9, v23 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[18:19], v[28:29], v[8:9], v[28:29]
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v8, v48
		v_cvt_f32_f16_sdwa v9, v48 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v20, v49
		v_cvt_f32_f16_sdwa v21, v49 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[22:23], v[30:31], v[8:9], v[30:31]
		v_cvt_f32_f16_e32 v8, v50
		v_cvt_f32_f16_sdwa v9, v50 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v24, v51
		v_cvt_f32_f16_sdwa v25, v51 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[26:27], v[32:33], v[20:21], v[32:33]
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v20, v52
		v_cvt_f32_f16_sdwa v21, v52 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v28, v53
		v_cvt_f32_f16_sdwa v29, v53 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[30:31], v[34:35], v[8:9], v[34:35]
		v_cvt_f32_f16_e32 v8, v54
		v_cvt_f32_f16_sdwa v9, v54 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v32, v55
		v_cvt_f32_f16_sdwa v33, v55 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[34:35], v[36:37], v[24:25], v[36:37]
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v24, v56
		v_cvt_f32_f16_sdwa v25, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v36, v57
		v_cvt_f32_f16_sdwa v37, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[46:47], v[38:39], v[20:21], v[38:39]
		v_cvt_f32_f16_e32 v20, v58
		v_cvt_f32_f16_sdwa v21, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v38, v59
		v_cvt_f32_f16_sdwa v39, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[48:49], v[40:41], v[28:29], v[40:41]
		v_pk_fma_f32 v[28:29], v[42:43], v[8:9], v[42:43]
		v_pk_fma_f32 v[8:9], v[44:45], v[32:33], v[44:45]
		v_pk_fma_f32 v[32:33], v[6:7], v[24:25], v[6:7]
		v_pk_fma_f32 v[6:7], v[2:3], v[36:37], v[2:3]
		v_pk_fma_f32 v[2:3], v[12:13], v[20:21], v[12:13]
		v_pk_fma_f32 v[12:13], v[14:15], v[38:39], v[14:15]
		v_xad_u32 v1, v1, v11, s16
		v_xad_u32 v5, v5, v11, s16
		v_cmp_lt_i32_e64 s[8:9], v1, s12
		v_cmp_lt_i32_e64 s[14:15], v5, s12
		s_and_b64 s[8:9], s[8:9], s[2:3]
		s_and_b64 s[2:3], s[14:15], s[2:3]
		v_cvt_pk_f16_f32 v62, v16, v17
		v_cvt_pk_f16_f32 v63, v18, v19
		s_lshl_b32 s1, s1, 8
		s_mul_i32 s12, s21, s19
		s_lshl_b32 s12, s12, 10
		s_add_i32 s13, s1, s12
		s_mul_i32 s0, s0, s19
		s_lshl_b32 s0, s0, 8
		s_add_i32 s13, s13, s0
		v_mul_lo_u32 v1, s19, v4
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v4, s13, v1, v0
		v_mov_b32_e32 v5, 0x7fffffff
		v_cndmask_b32_e64 v4, v5, v4, s[4:5]
		s_mov_b32 s20, s10
		s_mov_b32 s21, s11
		s_mov_b32 s22, s30
		s_mov_b32 s23, s31
		buffer_store_dwordx4 v[60:63], v4, s[20:23], 0 offen sc0 nt
		s_lshl_b32 s4, s19, 6
		s_add_i32 s4, s1, s4
		v_cvt_pk_f16_f32 v16, v22, v23
		v_cvt_pk_f16_f32 v17, v26, v27
		v_cvt_pk_f16_f32 v18, v30, v31
		v_cvt_pk_f16_f32 v19, v34, v35
		s_add_i32 s4, s4, s12
		s_add_i32 s4, s4, s0
		v_add3_u32 v4, s4, v1, v0
		v_cndmask_b32_e64 v4, v5, v4, s[6:7]
		buffer_store_dwordx4 v[16:19], v4, s[20:23], 0 offen sc0 nt
		s_lshl_b32 s4, s19, 7
		s_add_i32 s4, s1, s4
		v_cvt_pk_f16_f32 v16, v46, v47
		v_cvt_pk_f16_f32 v17, v48, v49
		v_cvt_pk_f16_f32 v18, v28, v29
		v_cvt_pk_f16_f32 v19, v8, v9
		s_add_i32 s4, s4, s12
		s_add_i32 s4, s4, s0
		v_add3_u32 v4, s4, v1, v0
		v_cndmask_b32_e64 v4, v5, v4, s[8:9]
		buffer_store_dwordx4 v[16:19], v4, s[20:23], 0 offen sc0 nt
		s_mul_i32 s4, 0xc0, s19
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s12
		s_add_i32 s0, s1, s0
		v_add3_u32 v0, s0, v1, v0
		v_cndmask_b32_e64 v0, v5, v0, s[2:3]
		v_cvt_pk_f16_f32 v8, v32, v33
		v_cvt_pk_f16_f32 v9, v6, v7
		v_cvt_pk_f16_f32 v10, v2, v3
		v_cvt_pk_f16_f32 v11, v12, v13
		buffer_store_dwordx4 v[8:11], v0, s[20:23], 0 offen sc0 nt
		s_endpgm
	.size	tlx_addmm_glu_kernel_optimized_async, .-tlx_addmm_glu_kernel_optimized_async
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel tlx_addmm_glu_kernel_optimized_async
		.amdhsa_group_segment_fixed_size 135104
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
		.amdhsa_next_free_vgpr 132
		.amdhsa_next_free_sgpr 48
		.amdhsa_accum_offset 132
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_vgpr, 132
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 48
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_named_barrier, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.private_seg_size, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.uses_vcc, 1
	.set .Ltlx_addmm_glu_kernel_optimized_async.uses_flat_scratch, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_dyn_sized_stack, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_recursion, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_indirect_call, 0
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
    .group_segment_fixed_size: 135104
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_optimized_async
    .private_segment_fixed_size: 0
    .sgpr_count:     48
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized_async.kd
    .uses_dynamic_stack: false
    .vgpr_count:     132
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
