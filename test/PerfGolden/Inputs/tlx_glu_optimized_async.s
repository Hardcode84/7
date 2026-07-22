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
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s21, s20, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s21, s20
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, s22, s1
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s23, s22, -1
		v_readfirstlane_b32 s24, v1
		s_add_i32 s23, s23, 1
		s_mul_i32 s25, s23, s24
		s_mul_hi_u32 s25, s24, s25
		s_add_i32 s24, s24, s25
		s_mul_hi_u32 s24, s16, s24
		s_mul_i32 s25, s24, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s16, s16, s25
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s24, s26, s24
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s16, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s16, s26, s16
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s24, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s24
		s_cselect_b32 s24, 1, 0
		s_xor_b32 s1, s20, s1
		s_xor_b32 s20, s22, -1
		s_add_i32 s20, s20, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s20, s22
		s_mul_i32 s20, s1, 4
		s_xor_b32 s22, s20, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s0, s0, s22
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s22, s16, s23
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s16, s22, s16
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s16
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s0, -1
		s_add_i32 s23, s23, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s23, s23, s0
		v_mov_b32_e32 v1, s23
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s24, s23, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s24, s24, 1
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s26, s24, s25
		s_mul_hi_u32 s26, s25, s26
		s_add_i32 s25, s25, s26
		s_mul_hi_u32 s25, s21, s25
		s_mul_i32 s26, s25, s23
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		s_add_i32 s21, s21, s26
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s21, s24
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s21, s27, s21
		s_cselect_b32 s26, 1, 0
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s21, s24
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s24, s21
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s24, s21, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s21, s24, s21
		s_add_i32 s20, s20, s21
		s_add_i32 s22, s25, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s22, s22, s25
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s0, s16, s0
		s_xor_b32 s16, s22, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s16, s22
		s_mul_i32 s16, s20, 0x80
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
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 2
		v_mul_lo_u32 v13, v13, v12
		v_add3_u32 v6, v6, v10, v13
		v_lshrrev_b32_e32 v14, 8, v0
		v_and_b32_e32 v15, 1, v14
		v_mad_u32_u24 v6, v15, 4, v6
		v_and_b32_e32 v16, 15, v0
		v_and_b32_e32 v17, 63, v0
		v_and_b32_e32 v18, 7, v9
		v_add_u32_e32 v19, 0x48, v18
		v_add_u32_e32 v20, 0x50, v18
		v_add_u32_e32 v21, 0x58, v18
		v_add_u32_e32 v22, 0x60, v18
		v_add_u32_e32 v23, 0x68, v18
		v_add_u32_e32 v24, 0x70, v18
		v_add_u32_e32 v25, 0x78, v18
		v_add_u32_e32 v26, s16, v6
		s_mul_i32 s20, s0, 0x80
		s_mov_b32 s22, 0
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v27, v26, -1, 1
		v_add3_u32 v6, 8, v6, s16
		v_cndmask_b32_e32 v26, v26, v27, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s26, -1
		s_mov_b32 s27, -1
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_xor_b32 s23, s12, -1
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v27, s12
		v_mov_b32_e32 v28, s23
		v_cndmask_b32_e64 v27, v27, v28, s[30:31]
		v_cvt_f32_u32_e32 v28, v27
		v_rcp_iflag_f32_e32 v28, v28
		v_xad_u32 v29, v27, -1, 1
		v_mul_f32_e32 v28, v2, v28
		v_cvt_u32_f32_e32 v28, v28
		v_mul_lo_u32 v30, v29, v28
		v_mul_hi_u32 v30, v28, v30
		v_add_u32_e32 v28, v28, v30
		v_mul_hi_u32 v30, v26, v28
		v_mul_lo_u32 v30, v30, v27
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v26, 1, v30, v26
		v_add_u32_e32 v30, v26, v29
		v_cmp_ge_u32_e64 vcc, v26, v27
		v_add_u32_e32 v31, s16, v18
		v_add3_u32 v32, 8, v18, s16
		v_cndmask_b32_e32 v26, v26, v30, vcc
		v_add_u32_e32 v30, v26, v29
		v_cmp_ge_u32_e64 vcc, v26, v27
		v_add3_u32 v33, 16, v18, s16
		v_add3_u32 v34, 24, v18, s16
		v_cndmask_b32_e32 v26, v26, v30, vcc
		v_xad_u32 v30, v26, -1, 1
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v35, v6, -1, 1
		v_add3_u32 v36, 32, v18, s16
		v_cndmask_b32_e32 v6, v6, v35, vcc
		v_mul_hi_u32 v35, v6, v28
		v_mul_lo_u32 v35, v35, v27
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v6, 1, v35, v6
		v_add_u32_e32 v35, v6, v29
		v_cmp_ge_u32_e64 vcc, v6, v27
		v_add3_u32 v37, 40, v18, s16
		v_add3_u32 v38, 48, v18, s16
		v_cndmask_b32_e32 v6, v6, v35, vcc
		v_add_u32_e32 v35, v6, v29
		v_cmp_ge_u32_e64 vcc, v6, v27
		v_add3_u32 v39, 56, v18, s16
		v_add3_u32 v18, 64, v18, s16
		v_cndmask_b32_e32 v6, v6, v35, vcc
		v_xad_u32 v35, v6, -1, 1
		v_cmp_lt_i32_e64 vcc, v31, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v40, v31, -1, 1
		v_add_u32_e32 v19, s16, v19
		v_cndmask_b32_e32 v31, v31, v40, vcc
		v_mul_hi_u32 v40, v31, v28
		v_mul_lo_u32 v40, v40, v27
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v31, 1, v40, v31
		v_add_u32_e32 v40, v31, v29
		v_cmp_ge_u32_e64 vcc, v31, v27
		v_add_u32_e32 v20, s16, v20
		v_add_u32_e32 v21, s16, v21
		v_cndmask_b32_e32 v31, v31, v40, vcc
		v_add_u32_e32 v40, v31, v29
		v_cmp_ge_u32_e64 vcc, v31, v27
		v_add_u32_e32 v22, s16, v22
		v_add_u32_e32 v23, s16, v23
		v_cndmask_b32_e32 v31, v31, v40, vcc
		v_xad_u32 v40, v31, -1, 1
		v_cmp_lt_i32_e64 vcc, v32, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v41, v32, -1, 1
		v_add_u32_e32 v24, s16, v24
		v_cndmask_b32_e32 v32, v32, v41, vcc
		v_mul_hi_u32 v41, v32, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v32, 1, v41, v32
		v_add_u32_e32 v41, v32, v29
		v_cmp_ge_u32_e64 vcc, v32, v27
		v_add_u32_e32 v25, s16, v25
		v_mad_u32_u24 v16, v16, 8, s20
		v_cndmask_b32_e32 v32, v32, v41, vcc
		v_add_u32_e32 v41, v32, v29
		v_cmp_ge_u32_e64 vcc, v32, v27
		v_mad_u32_u24 v17, v17, 2, s20
		v_cndmask_b32_e64 v26, v26, v30, s[24:25]
		v_cndmask_b32_e32 v30, v32, v41, vcc
		v_xad_u32 v32, v30, -1, 1
		v_cmp_lt_i32_e64 vcc, v33, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v41, v33, -1, 1
		v_cndmask_b32_e64 v6, v6, v35, s[30:31]
		v_cndmask_b32_e32 v33, v33, v41, vcc
		v_mul_hi_u32 v35, v33, v28
		v_mul_lo_u32 v35, v35, v27
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v33, 1, v35, v33
		v_add_u32_e32 v35, v33, v29
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_cndmask_b32_e64 v31, v31, v40, s[32:33]
		v_cndmask_b32_e64 v30, v30, v32, s[34:35]
		v_cndmask_b32_e32 v32, v33, v35, vcc
		v_cmp_ge_u32_e64 vcc, v32, v27
		v_add_u32_e32 v33, v32, v29
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s21, s21, s19
		v_cndmask_b32_e32 v32, v32, v33, vcc
		v_xad_u32 v33, v32, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v35, v34, -1, 1
		v_cndmask_b32_e64 v32, v32, v33, s[24:25]
		v_cndmask_b32_e32 v33, v34, v35, vcc
		v_mul_hi_u32 v34, v33, v28
		v_mul_lo_u32 v34, v34, v27
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v33, 1, v34, v33
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_add_u32_e32 v34, v33, v29
		s_mul_i32 s1, s1, s19
		v_cndmask_b32_e32 v33, v33, v34, vcc
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_add_u32_e32 v34, v33, v29
		s_lshl_b32 s0, s0, 8
		v_cndmask_b32_e32 v33, v33, v34, vcc
		v_xad_u32 v34, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v35, v36, -1, 1
		v_cndmask_b32_e64 v33, v33, v34, s[30:31]
		v_cndmask_b32_e32 v34, v36, v35, vcc
		v_mul_hi_u32 v35, v34, v28
		v_mul_lo_u32 v35, v35, v27
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v34, 1, v35, v34
		v_cmp_ge_u32_e64 vcc, v34, v27
		v_add_u32_e32 v35, v34, v29
		v_lshlrev_b32_e32 v36, 4, v14
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_cmp_ge_u32_e64 vcc, v34, v27
		v_add_u32_e32 v35, v34, v29
		v_and_b32_e32 v1, 1, v1
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_xad_u32 v35, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v40, v37, -1, 1
		v_cndmask_b32_e64 v34, v34, v35, s[24:25]
		v_cndmask_b32_e32 v35, v37, v40, vcc
		v_mul_hi_u32 v37, v35, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v35, 1, v37, v35
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_xor_b32_e32 v40, 0x60, v5
		v_cndmask_b32_e32 v35, v35, v37, vcc
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_mov_b32_e32 v41, 64
		v_mul_lo_u32 v41, v41, v3
		v_cndmask_b32_e32 v3, v35, v37, vcc
		v_xad_u32 v35, v3, -1, 1
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v37, v38, -1, 1
		v_cndmask_b32_e64 v3, v3, v35, s[30:31]
		v_cndmask_b32_e32 v35, v38, v37, vcc
		v_mul_hi_u32 v37, v35, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v35, 1, v37, v35
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_mov_b32_e32 v38, 16
		v_mul_lo_u32 v38, v38, v15
		v_cndmask_b32_e32 v35, v35, v37, vcc
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_mov_b32_e32 v42, 8
		v_mul_lo_u32 v42, v42, v12
		v_cndmask_b32_e32 v12, v35, v37, vcc
		v_xad_u32 v35, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v39, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v37, v39, -1, 1
		v_cndmask_b32_e64 v12, v12, v35, s[24:25]
		v_cndmask_b32_e32 v35, v39, v37, vcc
		v_mul_hi_u32 v37, v35, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v35, 1, v37, v35
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_mov_b32_e32 v39, 4
		v_mul_lo_u32 v39, v39, v10
		v_cndmask_b32_e32 v35, v35, v37, vcc
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v37, v35, v29
		v_mov_b32_e32 v43, 2
		v_mul_lo_u32 v43, v43, v8
		v_cndmask_b32_e32 v35, v35, v37, vcc
		v_xad_u32 v37, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v44, v18, -1, 1
		v_cndmask_b32_e64 v35, v35, v37, s[30:31]
		v_cndmask_b32_e32 v18, v18, v44, vcc
		v_mul_hi_u32 v37, v18, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v18, 1, v37, v18
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v37, v18, v29
		v_mul_lo_u32 v31, s18, v31
		v_cndmask_b32_e32 v18, v18, v37, vcc
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v37, v18, v29
		v_and_b32_e32 v44, 1, v9
		v_cndmask_b32_e32 v18, v18, v37, vcc
		v_xad_u32 v37, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v45, v19, -1, 1
		v_cndmask_b32_e64 v18, v18, v37, s[24:25]
		v_cndmask_b32_e32 v19, v19, v45, vcc
		v_mul_hi_u32 v37, v19, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v19, 1, v37, v19
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v37, v19, v29
		v_and_b32_e32 v45, 1, v4
		v_cndmask_b32_e32 v19, v19, v37, vcc
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v37, v19, v29
		v_and_b32_e32 v7, 1, v7
		v_cndmask_b32_e32 v19, v19, v37, vcc
		v_xad_u32 v37, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v46, v20, -1, 1
		v_cndmask_b32_e64 v19, v19, v37, s[30:31]
		v_cndmask_b32_e32 v20, v20, v46, vcc
		v_mul_hi_u32 v37, v20, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v20, 1, v37, v20
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v37, v20, v29
		v_and_b32_e32 v11, 1, v11
		v_cndmask_b32_e32 v20, v20, v37, vcc
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v37, v20, v29
		v_lshlrev_b32_e32 v46, 3, v14
		v_cndmask_b32_e32 v20, v20, v37, vcc
		v_xad_u32 v37, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v47, v21, -1, 1
		v_cndmask_b32_e64 v20, v20, v37, s[24:25]
		v_cndmask_b32_e32 v21, v21, v47, vcc
		v_mul_hi_u32 v37, v21, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v21, 1, v37, v21
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v37, v21, v29
		v_mov_b32_e32 v47, 8
		v_mul_lo_u32 v47, v47, v15
		v_cndmask_b32_e32 v15, v21, v37, vcc
		v_cmp_ge_u32_e64 vcc, v15, v27
		v_add_u32_e32 v21, v15, v29
		v_mov_b32_e32 v37, 32
		v_mul_lo_u32 v37, v37, v8
		v_cndmask_b32_e32 v8, v15, v21, vcc
		v_xad_u32 v15, v8, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v21, v22, -1, 1
		v_cndmask_b32_e64 v8, v8, v15, s[30:31]
		v_cndmask_b32_e32 v15, v22, v21, vcc
		v_mul_hi_u32 v21, v15, v28
		v_mul_lo_u32 v21, v21, v27
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v15, 1, v21, v15
		v_cmp_ge_u32_e64 vcc, v15, v27
		v_add_u32_e32 v21, v15, v29
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v5
		v_cndmask_b32_e32 v15, v15, v21, vcc
		v_cmp_ge_u32_e64 vcc, v15, v27
		v_add_u32_e32 v21, v15, v29
		v_mul_lo_u32 v48, s15, v6
		v_cndmask_b32_e32 v15, v15, v21, vcc
		v_xad_u32 v21, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v49, v23, -1, 1
		v_cndmask_b32_e64 v15, v15, v21, s[24:25]
		v_cndmask_b32_e32 v21, v23, v49, vcc
		v_mul_hi_u32 v23, v21, v28
		v_mul_lo_u32 v23, v23, v27
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v21, 1, v23, v21
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v23, v21, v29
		v_and_b32_e32 v49, 1, v0
		v_cndmask_b32_e32 v21, v21, v23, vcc
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v23, v21, v29
		v_mul_lo_u32 v50, s15, v26
		v_cndmask_b32_e32 v21, v21, v23, vcc
		v_xad_u32 v23, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v51, v24, -1, 1
		v_cndmask_b32_e64 v21, v21, v23, s[30:31]
		v_cndmask_b32_e32 v23, v24, v51, vcc
		v_mul_hi_u32 v24, v23, v28
		v_mul_lo_u32 v24, v24, v27
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v23, 1, v24, v23
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v24, v23, v29
		s_mov_b32 s34, 0x7fffffff
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v24, v23, v29
		v_lshrrev_b32_e32 v51, 2, v0
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_xad_u32 v24, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v52, v25, -1, 1
		v_cndmask_b32_e64 v23, v23, v24, s[24:25]
		v_cndmask_b32_e32 v24, v25, v52, vcc
		v_mul_hi_u32 v25, v24, v28
		v_mul_lo_u32 v25, v25, v27
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v24, 1, v25, v24
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v25, v24, v29
		v_mov_b32_e32 v28, s13
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v25, v24, v29
		s_xor_b32 s23, s13, -1
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_xad_u32 v25, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v27, v16, -1, 1
		v_cndmask_b32_e64 v24, v24, v25, s[30:31]
		v_cndmask_b32_e32 v16, v16, v27, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v25, s23
		v_cndmask_b32_e64 v25, v28, v25, s[30:31]
		v_cvt_f32_u32_e32 v27, v25
		v_rcp_iflag_f32_e32 v27, v27
		v_xad_u32 v28, v25, -1, 1
		v_mul_f32_e32 v2, v2, v27
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v27, v28, v2
		v_mul_hi_u32 v27, v2, v27
		v_add_u32_e32 v2, v2, v27
		v_mul_hi_u32 v27, v16, v2
		v_mul_lo_u32 v27, v27, v25
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v16, 1, v27, v16
		v_cmp_ge_u32_e64 vcc, v16, v25
		v_add_u32_e32 v27, v16, v28
		v_lshrrev_b32_e32 v29, 1, v0
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_cmp_ge_u32_e64 vcc, v16, v25
		v_add_u32_e32 v27, v16, v28
		v_and_b32_e32 v52, 1, v0
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_xad_u32 v27, v16, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v53, v17, -1, 1
		v_cndmask_b32_e64 v16, v16, v27, s[24:25]
		v_cndmask_b32_e32 v17, v17, v53, vcc
		v_mul_hi_u32 v2, v17, v2
		v_mul_lo_u32 v2, v2, v25
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v17
		v_cmp_ge_u32_e64 vcc, v2, v25
		v_add_u32_e32 v17, v2, v28
		s_mov_b32 s23, 63
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_cmp_ge_u32_e64 vcc, v2, v25
		v_add_u32_e32 v17, v2, v28
		s_add_i32 s24, s14, 63
		v_cndmask_b32_e32 v2, v2, v17, vcc
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v52
		v_and_b32_e32 v25, 1, v29
		v_mov_b32_e32 v27, 16
		v_mul_lo_u32 v27, v27, v25
		v_and_b32_e32 v25, 1, v51
		v_mov_b32_e32 v28, 32
		v_mul_lo_u32 v28, v28, v25
		v_bitop3_b32 v17, v17, v27, v28 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v17, s14
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s34
		s_mov_b32 s31, s35
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v25, 4, v49
		v_lshl_add_u32 v27, v50, 1, v25
		v_and_b32_e32 v28, 1, v51
		v_lshlrev_b32_e32 v28, 6, v28
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 5, v29
		v_add3_u32 v27, v27, v28, v29
		v_mov_b32_e32 v49, 0x80000000
		v_cndmask_b32_e32 v50, v49, v27, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		v_xad_u32 v52, v2, -1, 1
		buffer_load_dwordx4 v50, s[32:35], 0 offen lds
		v_lshl_add_u32 v48, v48, 1, v25
		v_add3_u32 v48, v48, v28, v29
		v_cndmask_b32_e32 v50, v49, v48, vcc
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s4, s24, s23
		buffer_load_dwordx4 v50, s[32:35], 0 offen lds
		v_bitop3_b32 v50, v22, v37, v10 bitop3:0x96
		v_bitop3_b32 v50, v50, v13, v47 bitop3:0x96
		v_bitop3_b32 v22, 4, v22, v37 bitop3:0x96
		v_xor_b32_e32 v10, v22, v10
		v_cmp_lt_i32_e64 vcc, v50, s14
		s_mov_b64 s[24:25], vcc
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v22, 1, v11
		v_lshlrev_b32_e32 v37, 4, v45
		v_lshl_add_u32 v37, v7, 5, v37
		v_xor_b32_e32 v37, v37, v44
		v_bitop3_b32 v22, v46, v22, v37 bitop3:0x96
		v_mul_lo_u32 v37, s17, v22
		v_lshl_add_u32 v37, v37, 1, v16
		v_cndmask_b32_e64 v46, v49, v37, s[24:25]
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v2, v2, v52, s[26:27]
		buffer_load_dwordx4 v46, s[28:31], 0 offen lds
		v_bitop3_b32 v10, v10, v13, v47 bitop3:0x96
		v_xor_b32_e32 v13, 4, v22
		v_mul_lo_u32 v13, s17, v13
		v_cmp_lt_i32_e64 vcc, v10, s14
		v_lshl_add_u32 v13, v13, 1, v16
		s_lshl_b32 s5, s15, 1
		v_cndmask_b32_e32 v22, v49, v13, vcc
		s_add_i32 m0, m0, 0x2100
		s_ashr_i32 s4, s4, 6
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 s15, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v17, s15
		v_add_u32_e32 v22, 0x80, v27
		v_and_b32_e32 v46, 7, v51
		v_cndmask_b32_e32 v22, v49, v22, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_add3_u32 v47, v25, v28, v29
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_add_u32_e32 v22, 0x80, v48
		v_cndmask_b32_e32 v22, v49, v22, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s23, s17, 7
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v50, s15
		s_mov_b64 s[24:25], vcc
		v_add_u32_e32 v22, s23, v37
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v22, v49, v22, s[24:25]
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v10, s15
		v_add_u32_e32 v22, s23, v13
		v_lshlrev_b32_e32 v51, 8, v7
		v_cndmask_b32_e32 v22, v49, v22, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v9, 3, v9
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 s15, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v17, s15
		v_add_u32_e32 v22, 0x100, v27
		v_and_b32_e32 v27, 3, v0
		v_cndmask_b32_e32 v22, v49, v22, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_add_u32_e32 v48, 0x100, v48
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v22, v49, v48, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s23, s17, 8
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v50, s15
		s_mov_b64 s[24:25], vcc
		v_add_u32_e32 v22, s23, v37
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v22, v49, v22, s[24:25]
		v_cmp_lt_i32_e64 vcc, v10, s15
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_add_u32_e32 v22, s23, v13
		v_and_b32_e32 v48, 63, v0
		v_cndmask_b32_e32 v22, v49, v22, vcc
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v52, 7, v14
		v_lshrrev_b32_e32 v53, 4, v48
		v_lshlrev_b32_e32 v54, 4, v53
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_and_b32_e32 v22, 15, v48
		v_mov_b32_e32 v55, 0x420
		v_mul_lo_u32 v55, v55, v22
		v_add3_u32 v22, v52, v54, v55
		ds_read_b128 v[56:59], v22
		ds_read_b128 v[60:63], v22 offset:64
		ds_read_b128 v[64:67], v22 offset:256
		ds_read_b128 v[68:71], v22 offset:320
		ds_read_b128 v[72:75], v22 offset:512
		ds_read_b128 v[76:79], v22 offset:576
		ds_read_b128 v[80:83], v22 offset:768
		ds_read_b128 v[84:87], v22 offset:832
		v_lshlrev_b32_e32 v9, 5, v9
		v_lshl_add_u32 v9, v27, 3, v9
		v_mov_b32_e32 v27, 0x420
		v_mul_lo_u32 v27, v27, v46
		v_add3_u32 v9, v9, v51, v27
		ds_read_b64_tr_b16 v[88:89], v9 offset:50656
		ds_read_b64_tr_b16 v[90:91], v9 offset:59104
		ds_read_b64_tr_b16 v[92:93], v9 offset:51168
		ds_read_b64_tr_b16 v[94:95], v9 offset:59616
		ds_read_b64_tr_b16 v[96:97], v9 offset:50784
		ds_read_b64_tr_b16 v[98:99], v9 offset:59232
		ds_read_b64_tr_b16 v[100:101], v9 offset:51296
		ds_read_b64_tr_b16 v[102:103], v9 offset:59744
		s_add_i32 s15, s4, -3
		v_cmp_eq_u32_e64 vcc, v14, s22
		s_mov_b64 s[24:25], vcc
		v_cmp_ne_u32_e64 vcc, v14, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[42:43], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[42:43]
		s_setprio 0
		v_add_u32_e32 v27, 0x180, v47
		v_mul_lo_u32 v26, s5, v26
		v_add_u32_e32 v46, v27, v26
		v_mul_lo_u32 v6, s5, v6
		v_add_u32_e32 v26, v27, v6
		s_mul_i32 s5, 0x180, s17
		s_cmp_lt_i32 0, s15
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
		v_mov_b64_e32 v[132:133], 0
		v_mov_b64_e32 v[134:135], 0
		s_mov_b32 s23, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		s_cmp_ge_u32 s23, 2
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s23, -2
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		s_add_i32 s36, s23, 1
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s27, s36
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		s_cselect_b32 s37, 1, 0
		s_add_i32 s38, s22, 3
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		s_mul_i32 s38, s38, 64
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[84:87], v[128:131]
		s_setprio 1
		s_barrier
		s_xor_b32 s38, s38, -1
		s_add_i32 s38, s38, 1
		s_add_i32 s38, s14, s38
		v_cmp_lt_i32_e64 vcc, v17, s38
		s_lshl_b32 s39, s22, 7
		s_mul_i32 s23, 0x4200, s23
		v_cndmask_b32_e32 v6, v49, v46, vcc
		v_cndmask_b32_e32 v27, v49, v26, vcc
		s_add_i32 s23, s3, s23
		v_cmp_lt_i32_e64 vcc, v50, s38
		s_mov_b64 s[40:41], vcc
		s_mov_b32 m0, s23
		s_mul_i32 s23, s17, s22
		buffer_load_dwordx4 v6, s[32:35], s39 offen lds
		s_lshl_b32 s23, s23, 7
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s23, s5, s23
		buffer_load_dwordx4 v27, s[32:35], s39 offen lds
		v_add_u32_e32 v6, s23, v37
		v_cndmask_b32_e64 v6, v49, v6, s[40:41]
		s_add_i32 m0, m0, 0xa4e0
		v_cmp_lt_i32_e64 vcc, v10, s38
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add_u32_e32 v6, s23, v13
		v_cndmask_b32_e32 v6, v49, v6, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s23, 0x4200, s26
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_barrier
		v_add_u32_e32 v6, s23, v22
		s_waitcnt vmcnt(4)
		ds_read_b128 v[56:59], v6
		ds_read_b128 v[60:63], v6 offset:64
		ds_read_b128 v[64:67], v6 offset:256
		ds_read_b128 v[68:71], v6 offset:320
		ds_read_b128 v[72:75], v6 offset:512
		ds_read_b128 v[76:79], v6 offset:576
		ds_read_b128 v[80:83], v6 offset:768
		ds_read_b128 v[84:87], v6 offset:832
		v_add_u32_e32 v6, s23, v9
		ds_read_b64_tr_b16 v[88:89], v6 offset:50656
		ds_read_b64_tr_b16 v[90:91], v6 offset:59104
		ds_read_b64_tr_b16 v[92:93], v6 offset:51168
		ds_read_b64_tr_b16 v[94:95], v6 offset:59616
		ds_read_b64_tr_b16 v[96:97], v6 offset:50784
		ds_read_b64_tr_b16 v[98:99], v6 offset:59232
		ds_read_b64_tr_b16 v[100:101], v6 offset:51296
		ds_read_b64_tr_b16 v[102:103], v6 offset:59744
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s23, s27, s36
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s15
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[42:43], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[42:43]
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s34
		s_mov_b32 s27, s35
		s_mul_i32 s2, 0x108, s2
		s_add_i32 m0, s2, 0x18bc0
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshl_add_u32 v6, v31, 1, v2
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s34
		s_mov_b32 s31, s35
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v30
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v6, v6, 1, v2
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v32
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v6, v6, 1, v2
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v33
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v6, v6, 1, v2
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v34
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v6, v6, 1, v2
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v3, s18, v3
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dword v3, s[28:31], 0 offen lds
		v_mul_lo_u32 v3, s18, v12
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dword v3, s[28:31], 0 offen lds
		v_mul_lo_u32 v3, s18, v35
		s_add_i32 m0, m0, 0x840
		v_lshl_add_u32 v3, v3, 1, v2
		v_mul_lo_u32 v6, s18, v18
		v_lshl_add_u32 v6, v6, 1, v2
		v_mul_lo_u32 v10, s18, v19
		v_lshl_add_u32 v10, v10, 1, v2
		v_mul_lo_u32 v12, s18, v20
		v_lshl_add_u32 v12, v12, 1, v2
		v_mul_lo_u32 v8, s18, v8
		v_lshl_add_u32 v8, v8, 1, v2
		v_mul_lo_u32 v13, s18, v15
		v_lshl_add_u32 v13, v13, 1, v2
		v_mul_lo_u32 v15, s18, v21
		v_lshl_add_u32 v15, v15, 1, v2
		v_mul_lo_u32 v18, s18, v23
		v_lshl_add_u32 v18, v18, 1, v2
		v_mul_lo_u32 v19, s18, v24
		v_lshl_add_u32 v2, v19, 1, v2
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		buffer_load_dword v3, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		buffer_load_dword v10, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		buffer_load_dword v8, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[60:63], v[108:111]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[68:71], v[116:119]
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		buffer_load_dword v15, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[76:79], v[124:127]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[84:87], v[128:131]
		v_lshlrev_b32_e32 v3, 3, v11
		v_lshlrev_b32_e32 v6, 2, v44
		v_lshlrev_b32_e32 v8, 1, v7
		v_xor_b32_e32 v0, v0, v8
		v_bitop3_b32 v0, v3, v6, v0 bitop3:0x96
		v_lshlrev_b32_e32 v10, 4, v0
		v_xor_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshrrev_b32_e32 v12, 3, v48
		v_and_b32_e32 v12, 1, v12
		v_lshrrev_b32_e32 v13, 1, v48
		v_and_b32_e32 v13, 1, v13
		v_and_b32_e32 v15, 1, v53
		v_and_b32_e32 v19, 1, v48
		v_lshl_add_u32 v15, v19, 5, v15
		v_lshrrev_b32_e32 v19, 5, v48
		buffer_load_dword v18, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v18, 1, v19
		s_add_i32 m0, m0, 0x840
		s_add_i32 s2, s4, -2
		buffer_load_dword v2, s[28:31], 0 offen lds
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s5, s2, -1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s5, s2
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_cselect_b32 s5, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		s_xor_b32 s3, s2, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s2, s3, s2
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v2, s2, v22
		v_add_u32_e32 v19, s2, v9
		s_add_i32 s2, s4, -1
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s34
		s_mov_b32 s11, s35
		buffer_load_dwordx4 v[32:35], v16, s[8:11], 0 offen
		ds_read_b128 v[52:55], v2
		ds_read_b128 v[56:59], v2 offset:64
		ds_read_b128 v[60:63], v2 offset:256
		ds_read_b128 v[64:67], v2 offset:320
		ds_read_b128 v[68:71], v2 offset:512
		ds_read_b128 v[72:75], v2 offset:576
		ds_read_b128 v[76:79], v2 offset:768
		ds_read_b128 v[80:83], v2 offset:832
		ds_read_b64_tr_b16 v[84:85], v19 offset:50656
		ds_read_b64_tr_b16 v[86:87], v19 offset:59104
		ds_read_b64_tr_b16 v[88:89], v19 offset:51168
		ds_read_b64_tr_b16 v[90:91], v19 offset:59616
		ds_read_b64_tr_b16 v[92:93], v19 offset:50784
		ds_read_b64_tr_b16 v[94:95], v19 offset:59232
		ds_read_b64_tr_b16 v[96:97], v19 offset:51296
		ds_read_b64_tr_b16 v[98:99], v19 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[52:55], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[52:55], v[108:111]
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		s_cselect_b32 s4, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		s_xor_b32 s3, s2, -1
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s2, s3, s2
		s_mul_i32 s2, 0x4200, s2
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_add_u32_e32 v2, s2, v22
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[52:55], v2 offset:64
		ds_read_b128 v[56:59], v2 offset:256
		ds_read_b128 v[60:63], v2 offset:320
		ds_read_b128 v[64:67], v2 offset:512
		ds_read_b128 v[68:71], v2 offset:576
		ds_read_b128 v[72:75], v2 offset:768
		ds_read_b128 v[76:79], v2 offset:832
		v_add_u32_e32 v2, s2, v9
		ds_read_b64_tr_b16 v[80:81], v2 offset:50656
		ds_read_b64_tr_b16 v[82:83], v2 offset:59104
		ds_read_b64_tr_b16 v[84:85], v2 offset:51168
		ds_read_b64_tr_b16 v[86:87], v2 offset:59616
		ds_read_b64_tr_b16 v[88:89], v2 offset:50784
		ds_read_b64_tr_b16 v[90:91], v2 offset:59232
		ds_read_b64_tr_b16 v[92:93], v2 offset:51296
		ds_read_b64_tr_b16 v[94:95], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[56:59], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[56:59], v[116:119]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[64:67], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[64:67], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[72:75], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[72:75], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[52:55], v[104:107]
		s_nop 7
		ds_write_b128 v10, v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[52:55], v[108:111]
		s_nop 7
		ds_write_b128 v0, v[108:111] offset:8192
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		v_xor_b32_e32 v2, v15, v18
		v_bitop3_b32 v2, v3, v6, v2 bitop3:0x96
		v_lshlrev_b32_e32 v9, 6, v13
		v_add_u32_e32 v15, v9, v2
		v_lshrrev_b32_e32 v15, 7, v15
		v_lshrrev_b32_e32 v16, 2, v48
		v_and_b32_e32 v16, 1, v16
		v_add_u32_e32 v15, v15, v16
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v18, 6, v2
		v_add_u32_e32 v13, v18, v13
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshlrev_b32_e32 v16, 7, v16
		v_lshl_add_u32 v16, v14, 8, v16
		v_add3_u32 v9, v16, v9, v2
		v_lshrrev_b32_e32 v2, 5, v2
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_bitop3_b32 v2, v13, v9, v2 bitop3:0x96
		v_bitop3_b32 v2, v12, v15, v2 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_lshl_add_u32 v2, v12, 13, v2
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[48:51], v2 offset:256
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v12, v32
		v_cvt_f32_f16_sdwa v13, v32 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v18, v33
		v_cvt_f32_f16_sdwa v19, v33 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v10, v[112:115]
		ds_write_b128 v0, v[116:119] offset:8192
		v_cvt_f32_f16_e32 v26, v34
		v_cvt_f32_f16_sdwa v27, v34 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v30, v35
		v_cvt_f32_f16_sdwa v31, v35 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[52:55], v2 offset:256
		v_pk_add_f32 v[20:21], v[20:21], v[12:13]
		v_pk_add_f32 v[22:23], v[22:23], v[18:19]
		v_pk_add_f32 v[46:47], v[48:49], v[26:27]
		v_pk_add_f32 v[48:49], v[50:51], v[30:31]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v10, v[120:123]
		ds_write_b128 v0, v[124:127] offset:8192
		v_pk_add_f32 v[32:33], v[32:33], v[12:13]
		v_pk_add_f32 v[34:35], v[34:35], v[18:19]
		v_pk_add_f32 v[50:51], v[52:53], v[26:27]
		v_pk_add_f32 v[52:53], v[54:55], v[30:31]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v2
		ds_read_b128 v[60:63], v2 offset:256
		v_bitop3_b32 v9, v5, v43, v39 bitop3:0x96
		v_xor_b32_e32 v9, v9, v42
		v_bitop3_b32 v15, 32, v5, v43 bitop3:0x96
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[54:55], v[56:57], v[12:13]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v10, v[128:131]
		ds_write_b128 v0, v[132:135] offset:8192
		v_pk_add_f32 v[56:57], v[58:59], v[18:19]
		v_pk_add_f32 v[58:59], v[60:61], v[26:27]
		v_pk_add_f32 v[60:61], v[62:63], v[30:31]
		v_bitop3_b32 v0, v15, v39, v42 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v2
		ds_read_b128 v[68:71], v2 offset:256
		v_bitop3_b32 v2, 64, v5, v43 bitop3:0x96
		v_bitop3_b32 v2, v2, v39, v42 bitop3:0x96
		v_xor_b32_e32 v5, v40, v43
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[12:13], v[64:65], v[12:13]
		v_pk_add_f32 v[18:19], v[66:67], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[26:27], v[68:69], v[26:27]
		v_pk_add_f32 v[30:31], v[70:71], v[30:31]
		v_xor_b32_e32 v5, v5, v39
		v_xor_b32_e32 v5, v5, v42
		v_mov_b32_e32 v10, 0x108
		v_mul_lo_u32 v10, v10, v4
		v_add_u32_e32 v4, 0x10000, v10
		v_lshlrev_b32_e32 v1, 7, v1
		v_add3_u32 v4, v4, v25, v1
		v_add3_u32 v4, v4, v28, v29
		ds_read_b128 v[64:67], v4 offset:35776
		v_add_u32_e32 v4, 0x10000, v25
		v_add_u32_e32 v10, 32, v45
		v_bitop3_b32 v10, v6, v10, v8 bitop3:0x96
		v_bitop3_b32 v10, v36, v3, v10 bitop3:0x96
		v_lshrrev_b32_e32 v15, 6, v10
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 0x4200
		v_mul_lo_u32 v16, v16, v15
		v_lshrrev_b32_e32 v15, 5, v10
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v24, 0x2100
		v_mul_lo_u32 v24, v24, v15
		v_add3_u32 v15, v4, v16, v24
		v_lshrrev_b32_e32 v16, 4, v10
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v24, 0x1080
		v_mul_lo_u32 v24, v24, v16
		v_add3_u32 v15, v15, v24, v1
		v_lshrrev_b32_e32 v16, 3, v10
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v24, 0x840
		v_mul_lo_u32 v24, v24, v16
		v_add3_u32 v15, v15, v24, v28
		v_lshrrev_b32_e32 v16, 2, v10
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v24, 0x420
		v_mul_lo_u32 v24, v24, v16
		v_add3_u32 v15, v15, v24, v29
		v_lshrrev_b32_e32 v16, 1, v10
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v24, 0x210
		v_mul_lo_u32 v24, v24, v16
		v_and_b32_e32 v16, 1, v10
		v_mov_b32_e32 v37, 0x108
		v_mul_lo_u32 v37, v37, v16
		v_add3_u32 v15, v15, v24, v37
		ds_read_b128 v[68:71], v15 offset:35776
		v_add_u32_e32 v15, 64, v45
		v_bitop3_b32 v15, v6, v15, v8 bitop3:0x96
		v_bitop3_b32 v15, v36, v3, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 6, v15
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v24, 0x4200
		v_mul_lo_u32 v24, v24, v16
		v_lshrrev_b32_e32 v16, 5, v15
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v37, 0x2100
		v_mul_lo_u32 v37, v37, v16
		v_add3_u32 v16, v4, v24, v37
		v_lshrrev_b32_e32 v24, 4, v15
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v37, 0x1080
		v_mul_lo_u32 v37, v37, v24
		v_add3_u32 v16, v16, v37, v1
		v_lshrrev_b32_e32 v24, 3, v15
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v37, 0x840
		v_mul_lo_u32 v37, v37, v24
		v_add3_u32 v16, v16, v37, v28
		v_lshrrev_b32_e32 v24, 2, v15
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v37, 0x420
		v_mul_lo_u32 v37, v37, v24
		v_add3_u32 v16, v16, v37, v29
		v_lshrrev_b32_e32 v24, 1, v15
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v37, 0x210
		v_mul_lo_u32 v37, v37, v24
		v_and_b32_e32 v24, 1, v15
		v_mov_b32_e32 v39, 0x108
		v_mul_lo_u32 v39, v39, v24
		v_add3_u32 v16, v16, v37, v39
		ds_read_b128 v[72:75], v16 offset:35776
		v_add_u32_e32 v16, 0x60, v45
		v_bitop3_b32 v6, v6, v16, v8 bitop3:0x96
		v_bitop3_b32 v3, v36, v3, v6 bitop3:0x96
		v_lshrrev_b32_e32 v6, 6, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 0x4200
		v_mul_lo_u32 v8, v8, v6
		v_lshrrev_b32_e32 v6, 5, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v16, 0x2100
		v_mul_lo_u32 v16, v16, v6
		v_add3_u32 v4, v4, v8, v16
		v_lshrrev_b32_e32 v6, 4, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 0x1080
		v_mul_lo_u32 v8, v8, v6
		v_add3_u32 v4, v4, v8, v1
		v_lshrrev_b32_e32 v6, 3, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 0x840
		v_mul_lo_u32 v8, v8, v6
		v_add3_u32 v4, v4, v8, v28
		v_lshrrev_b32_e32 v6, 2, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 0x420
		v_mul_lo_u32 v8, v8, v6
		v_add3_u32 v4, v4, v8, v29
		v_lshrrev_b32_e32 v6, 1, v3
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 0x210
		v_mul_lo_u32 v8, v8, v6
		v_and_b32_e32 v6, 1, v3
		v_mov_b32_e32 v16, 0x108
		v_mul_lo_u32 v16, v16, v6
		v_add3_u32 v4, v4, v8, v16
		ds_read_b128 v[76:79], v4 offset:35776
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v36, v64
		v_cvt_f32_f16_sdwa v37, v64 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v65
		v_cvt_f32_f16_sdwa v43, v65 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v62, v66
		v_cvt_f32_f16_sdwa v63, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v67
		v_cvt_f32_f16_sdwa v65, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v66, v68
		v_cvt_f32_f16_sdwa v67, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v80, v69
		v_cvt_f32_f16_sdwa v81, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v70
		v_cvt_f32_f16_sdwa v69, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v71
		v_cvt_f32_f16_sdwa v83, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v70, v72
		v_cvt_f32_f16_sdwa v71, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v84, v73
		v_cvt_f32_f16_sdwa v85, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v74
		v_cvt_f32_f16_sdwa v73, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v75
		v_cvt_f32_f16_sdwa v87, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v74, v76
		v_cvt_f32_f16_sdwa v75, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v77
		v_cvt_f32_f16_sdwa v89, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v76, v78
		v_cvt_f32_f16_sdwa v77, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v79
		v_cvt_f32_f16_sdwa v91, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[78:79], v[20:21], v[36:37], v[20:21]
		v_pk_fma_f32 v[20:21], v[22:23], v[42:43], v[22:23]
		v_pk_fma_f32 v[22:23], v[46:47], v[62:63], v[46:47]
		v_pk_fma_f32 v[36:37], v[48:49], v[64:65], v[48:49]
		v_pk_fma_f32 v[42:43], v[32:33], v[66:67], v[32:33]
		v_pk_fma_f32 v[32:33], v[34:35], v[80:81], v[34:35]
		v_pk_fma_f32 v[34:35], v[50:51], v[68:69], v[50:51]
		v_pk_fma_f32 v[46:47], v[52:53], v[82:83], v[52:53]
		v_pk_fma_f32 v[48:49], v[54:55], v[70:71], v[54:55]
		v_pk_fma_f32 v[50:51], v[56:57], v[84:85], v[56:57]
		v_pk_fma_f32 v[52:53], v[58:59], v[72:73], v[58:59]
		v_pk_fma_f32 v[54:55], v[60:61], v[86:87], v[60:61]
		v_pk_fma_f32 v[56:57], v[12:13], v[74:75], v[12:13]
		v_pk_fma_f32 v[12:13], v[18:19], v[88:89], v[18:19]
		v_pk_fma_f32 v[18:19], v[26:27], v[76:77], v[26:27]
		v_pk_fma_f32 v[26:27], v[30:31], v[90:91], v[30:31]
		v_xad_u32 v4, v9, v38, s16
		v_xad_u32 v0, v0, v38, s16
		v_xad_u32 v2, v2, v38, s16
		v_xad_u32 v5, v5, v38, s16
		v_xad_u32 v6, v17, v41, s20
		v_cmp_lt_i32_e64 vcc, v4, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v6, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v0, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s8, s2, s4
		s_and_b32 s9, s3, s5
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		v_cmp_lt_i32_e64 vcc, v5, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s12, s2, s4
		s_and_b32 s13, s3, s5
		v_cvt_pk_f16_f32 v60, v78, v79
		v_cvt_pk_f16_f32 v61, v20, v21
		v_cvt_pk_f16_f32 v62, v22, v23
		v_cvt_pk_f16_f32 v63, v36, v37
		s_lshl_b32 s1, s1, 10
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s21, 8
		s_add_i32 s0, s0, s1
		v_mul_lo_u32 v0, s19, v14
		v_lshl_add_u32 v0, v0, 5, s0
		v_mul_lo_u32 v2, s19, v11
		v_lshl_add_u32 v0, v2, 4, v0
		v_mul_lo_u32 v2, s19, v44
		v_lshl_add_u32 v0, v2, 3, v0
		v_mul_lo_u32 v2, s19, v7
		v_lshl_add_u32 v0, v2, 2, v0
		v_mul_lo_u32 v2, s19, v45
		v_lshl_add_u32 v0, v2, 1, v0
		v_add3_u32 v0, v0, v25, v1
		v_add3_u32 v0, v0, v28, v29
		s_and_saveexec_b64 s[42:43], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_2
		buffer_store_dwordx4 v[60:63], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_2:
		s_andn2_b64 exec, s[42:43], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2:
		s_mov_b64 exec, s[42:43]
		v_cvt_pk_f16_f32 v4, v42, v43
		v_cvt_pk_f16_f32 v5, v32, v33
		v_cvt_pk_f16_f32 v6, v34, v35
		v_cvt_pk_f16_f32 v7, v46, v47
		v_mul_lo_u32 v0, s19, v10
		v_lshl_add_u32 v0, v0, 1, s0
		v_add3_u32 v0, v0, v25, v1
		v_add3_u32 v0, v0, v28, v29
		s_and_saveexec_b64 s[42:43], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_3
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_3:
		s_andn2_b64 exec, s[42:43], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3:
		s_mov_b64 exec, s[42:43]
		s_nop 0
		v_cvt_pk_f16_f32 v4, v48, v49
		v_cvt_pk_f16_f32 v5, v50, v51
		v_cvt_pk_f16_f32 v6, v52, v53
		v_cvt_pk_f16_f32 v7, v54, v55
		v_mul_lo_u32 v0, s19, v15
		v_lshl_add_u32 v0, v0, 1, s0
		v_add3_u32 v0, v0, v25, v1
		v_add3_u32 v0, v0, v28, v29
		s_and_saveexec_b64 s[42:43], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_4
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_4:
		s_andn2_b64 exec, s[42:43], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4:
		s_mov_b64 exec, s[42:43]
		s_nop 0
		v_cvt_pk_f16_f32 v4, v56, v57
		v_cvt_pk_f16_f32 v5, v12, v13
		v_cvt_pk_f16_f32 v6, v18, v19
		v_cvt_pk_f16_f32 v7, v26, v27
		v_mul_lo_u32 v0, s19, v3
		v_lshl_add_u32 v0, v0, 1, s0
		v_add3_u32 v0, v0, v25, v1
		v_add3_u32 v0, v0, v28, v29
		s_and_saveexec_b64 s[42:43], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_5
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_5:
		s_andn2_b64 exec, s[42:43], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5:
		s_mov_b64 exec, s[42:43]
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
		.amdhsa_next_free_vgpr 136
		.amdhsa_next_free_sgpr 44
		.amdhsa_accum_offset 136
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_vgpr, 136
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 44
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
    .sgpr_count:     44
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized_async.kd
    .uses_dynamic_stack: false
    .vgpr_count:     136
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
