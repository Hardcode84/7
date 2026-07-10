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
		v_mov_b32_e32 v4, 0
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
		s_and_b32 s21, s16, 7
		s_lshr_b32 s16, s16, 3
		s_lshr_b32 s22, s16, 2
		s_mul_i32 s22, s22, 32
		s_mul_i32 s21, s21, 4
		s_add_i32 s21, s22, s21
		s_and_b32 s16, s16, 3
		s_add_i32 s20, s21, s16
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
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v5, 1, v8
		v_mov_b32_e32 v6, 32
		v_mul_lo_u32 v6, v6, v5
		v_mad_u32_u24 v6, v3, 16, v6
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v9, 1, v7
		v_mad_u32_u24 v6, v9, 64, v6
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v11, 1, v10
		v_lshrrev_b32_e32 v12, 7, v0
		v_and_b32_e32 v13, 1, v12
		v_mov_b32_e32 v14, 2
		v_mul_lo_u32 v14, v14, v13
		v_add3_u32 v6, v6, v11, v14
		v_lshrrev_b32_e32 v13, 8, v0
		v_and_b32_e32 v15, 1, v13
		v_mad_u32_u24 v6, v15, 4, v6
		v_and_b32_e32 v16, 15, v0
		v_and_b32_e32 v17, 63, v0
		v_and_b32_e32 v18, 15, v8
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v18
		v_and_b32_e32 v18, 7, v10
		v_add_u32_e32 v20, 0x48, v18
		v_add_u32_e32 v21, 0x50, v18
		v_add_u32_e32 v22, 0x58, v18
		v_add_u32_e32 v23, 0x60, v18
		v_add_u32_e32 v24, 0x68, v18
		v_add_u32_e32 v25, 0x70, v18
		v_add_u32_e32 v26, 0x78, v18
		v_and_b32_e32 v27, 1, v0
		v_lshrrev_b32_e32 v28, 1, v0
		v_and_b32_e32 v29, 1, v28
		v_mad_u32_u24 v27, v29, 2, v27
		v_lshrrev_b32_e32 v29, 2, v0
		v_and_b32_e32 v30, 1, v29
		v_mad_u32_u24 v27, v30, 4, v27
		v_mad_u32_u24 v3, v3, 8, v27
		v_mad_u32_u24 v3, v15, 16, v3
		v_add_u32_e32 v27, 0x60, v3
		v_add_u32_e32 v30, s16, v6
		s_mul_i32 s20, s0, 0x80
		s_mov_b32 s22, 0
		v_cmp_lt_i32_e64 vcc, v30, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v31, v30, -1, 1
		v_add3_u32 v6, 8, v6, s16
		v_cndmask_b32_e32 v30, v30, v31, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s26, -1
		s_mov_b32 s27, -1
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_xor_b32 s23, s12, -1
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v31, s12
		v_mov_b32_e32 v32, s23
		v_cndmask_b32_e64 v31, v31, v32, s[30:31]
		v_cvt_f32_u32_e32 v32, v31
		v_rcp_iflag_f32_e32 v32, v32
		v_xad_u32 v33, v31, -1, 1
		v_mul_f32_e32 v32, v2, v32
		v_cvt_u32_f32_e32 v32, v32
		v_mul_lo_u32 v34, v33, v32
		v_mul_hi_u32 v34, v32, v34
		v_add_u32_e32 v32, v32, v34
		v_mul_hi_u32 v34, v30, v32
		v_mul_lo_u32 v34, v34, v31
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v30, 1, v34, v30
		v_add_u32_e32 v34, v30, v33
		v_cmp_ge_u32_e64 vcc, v30, v31
		v_add_u32_e32 v35, s16, v18
		v_add3_u32 v36, 8, v18, s16
		v_cndmask_b32_e32 v30, v30, v34, vcc
		v_add_u32_e32 v34, v30, v33
		v_cmp_ge_u32_e64 vcc, v30, v31
		v_add3_u32 v37, 16, v18, s16
		v_add3_u32 v38, 24, v18, s16
		v_cndmask_b32_e32 v30, v30, v34, vcc
		v_xad_u32 v34, v30, -1, 1
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v39, v6, -1, 1
		v_add3_u32 v40, 32, v18, s16
		v_cndmask_b32_e32 v6, v6, v39, vcc
		v_mul_hi_u32 v39, v6, v32
		v_mul_lo_u32 v39, v39, v31
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v6, 1, v39, v6
		v_add_u32_e32 v39, v6, v33
		v_cmp_ge_u32_e64 vcc, v6, v31
		v_add3_u32 v41, 40, v18, s16
		v_add3_u32 v42, 48, v18, s16
		v_cndmask_b32_e32 v6, v6, v39, vcc
		v_add_u32_e32 v39, v6, v33
		v_cmp_ge_u32_e64 vcc, v6, v31
		v_add3_u32 v43, 56, v18, s16
		v_add3_u32 v18, 64, v18, s16
		v_cndmask_b32_e32 v6, v6, v39, vcc
		v_xad_u32 v39, v6, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v44, v35, -1, 1
		v_add_u32_e32 v20, s16, v20
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_mul_hi_u32 v44, v35, v32
		v_mul_lo_u32 v44, v44, v31
		v_xor_b32_e32 v44, -1, v44
		v_add3_u32 v35, 1, v44, v35
		v_add_u32_e32 v44, v35, v33
		v_cmp_ge_u32_e64 vcc, v35, v31
		v_add_u32_e32 v21, s16, v21
		v_add_u32_e32 v22, s16, v22
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_add_u32_e32 v44, v35, v33
		v_cmp_ge_u32_e64 vcc, v35, v31
		v_add_u32_e32 v23, s16, v23
		v_add_u32_e32 v24, s16, v24
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_xad_u32 v44, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v45, v36, -1, 1
		v_add_u32_e32 v25, s16, v25
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_mul_hi_u32 v45, v36, v32
		v_mul_lo_u32 v45, v45, v31
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v36, 1, v45, v36
		v_add_u32_e32 v45, v36, v33
		v_cmp_ge_u32_e64 vcc, v36, v31
		v_add_u32_e32 v26, s16, v26
		v_add_u32_e32 v46, s16, v3
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_add_u32_e32 v45, v36, v33
		v_cmp_ge_u32_e64 vcc, v36, v31
		v_add3_u32 v47, 32, v3, s16
		v_add3_u32 v3, 64, v3, s16
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_xad_u32 v45, v36, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v48, v37, -1, 1
		v_add_u32_e32 v27, s16, v27
		v_cndmask_b32_e32 v37, v37, v48, vcc
		v_mul_hi_u32 v48, v37, v32
		v_mul_lo_u32 v48, v48, v31
		v_xor_b32_e32 v48, -1, v48
		v_add3_u32 v37, 1, v48, v37
		v_add_u32_e32 v48, v37, v33
		v_cmp_ge_u32_e64 vcc, v37, v31
		v_mad_u32_u24 v16, v16, 8, s20
		v_mad_u32_u24 v17, v17, 2, s20
		v_cndmask_b32_e32 v37, v37, v48, vcc
		v_add_u32_e32 v48, v37, v33
		v_cmp_ge_u32_e64 vcc, v37, v31
		v_add_u32_e32 v49, s20, v19
		v_add3_u32 v19, 64, v19, s20
		v_cndmask_b32_e32 v37, v37, v48, vcc
		v_xad_u32 v48, v37, -1, 1
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[38:39], vcc
		v_xad_u32 v50, v38, -1, 1
		v_cndmask_b32_e64 v30, v30, v34, s[24:25]
		v_cndmask_b32_e32 v34, v38, v50, vcc
		v_mul_hi_u32 v38, v34, v32
		v_mul_lo_u32 v38, v38, v31
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v34, 1, v38, v34
		v_add_u32_e32 v38, v34, v33
		v_cmp_ge_u32_e64 vcc, v34, v31
		v_cndmask_b32_e64 v6, v6, v39, s[30:31]
		v_cndmask_b32_e64 v35, v35, v44, s[32:33]
		v_cndmask_b32_e32 v34, v34, v38, vcc
		v_add_u32_e32 v38, v34, v33
		v_cmp_ge_u32_e64 vcc, v34, v31
		v_cndmask_b32_e64 v36, v36, v45, s[34:35]
		v_cndmask_b32_e64 v37, v37, v48, s[36:37]
		v_cndmask_b32_e32 v34, v34, v38, vcc
		v_xad_u32 v38, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v40, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v39, v40, -1, 1
		v_cndmask_b32_e64 v34, v34, v38, s[38:39]
		v_cndmask_b32_e32 v38, v40, v39, vcc
		v_mul_hi_u32 v39, v38, v32
		v_mul_lo_u32 v39, v39, v31
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v38, 1, v39, v38
		v_cmp_ge_u32_e64 vcc, v38, v31
		v_add_u32_e32 v39, v38, v33
		s_lshl_b32 s0, s0, 8
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_cmp_ge_u32_e64 vcc, v38, v31
		v_add_u32_e32 v39, v38, v33
		v_lshlrev_b32_e32 v40, 4, v13
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_xad_u32 v39, v38, -1, 1
		v_cmp_lt_i32_e64 vcc, v41, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v44, v41, -1, 1
		v_cndmask_b32_e64 v38, v38, v39, s[24:25]
		v_cndmask_b32_e32 v39, v41, v44, vcc
		v_mul_hi_u32 v41, v39, v32
		v_mul_lo_u32 v41, v41, v31
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v39, 1, v41, v39
		v_cmp_ge_u32_e64 vcc, v39, v31
		v_add_u32_e32 v41, v39, v33
		v_and_b32_e32 v1, 1, v1
		v_cndmask_b32_e32 v39, v39, v41, vcc
		v_cmp_ge_u32_e64 vcc, v39, v31
		v_add_u32_e32 v41, v39, v33
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v38, s18, v38
		v_cndmask_b32_e32 v39, v39, v41, vcc
		v_xad_u32 v41, v39, -1, 1
		v_cmp_lt_i32_e64 vcc, v42, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v44, v42, -1, 1
		v_cndmask_b32_e64 v39, v39, v41, s[30:31]
		v_cndmask_b32_e32 v41, v42, v44, vcc
		v_mul_hi_u32 v42, v41, v32
		v_mul_lo_u32 v42, v42, v31
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v41, 1, v42, v41
		v_cmp_ge_u32_e64 vcc, v41, v31
		v_add_u32_e32 v42, v41, v33
		v_mul_lo_u32 v34, s18, v34
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_cmp_ge_u32_e64 vcc, v41, v31
		v_add_u32_e32 v42, v41, v33
		v_mul_lo_u32 v37, s18, v37
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_xad_u32 v42, v41, -1, 1
		v_cmp_lt_i32_e64 vcc, v43, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v44, v43, -1, 1
		v_cndmask_b32_e64 v41, v41, v42, s[24:25]
		v_cndmask_b32_e32 v42, v43, v44, vcc
		v_mul_hi_u32 v43, v42, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v42, 1, v43, v42
		v_cmp_ge_u32_e64 vcc, v42, v31
		v_add_u32_e32 v43, v42, v33
		v_mul_lo_u32 v36, s18, v36
		v_cndmask_b32_e32 v42, v42, v43, vcc
		v_cmp_ge_u32_e64 vcc, v42, v31
		v_add_u32_e32 v43, v42, v33
		v_mul_lo_u32 v35, s18, v35
		v_cndmask_b32_e32 v42, v42, v43, vcc
		v_xad_u32 v43, v42, -1, 1
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v44, v18, -1, 1
		v_cndmask_b32_e64 v42, v42, v43, s[30:31]
		v_cndmask_b32_e32 v18, v18, v44, vcc
		v_mul_hi_u32 v43, v18, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v18, 1, v43, v18
		v_cmp_ge_u32_e64 vcc, v18, v31
		v_add_u32_e32 v43, v18, v33
		s_lshl_b32 s16, s15, 1
		v_cndmask_b32_e32 v18, v18, v43, vcc
		v_cmp_ge_u32_e64 vcc, v18, v31
		v_add_u32_e32 v43, v18, v33
		v_and_b32_e32 v44, 3, v10
		v_cndmask_b32_e32 v18, v18, v43, vcc
		v_xad_u32 v43, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v45, v20, -1, 1
		v_cndmask_b32_e64 v18, v18, v43, s[24:25]
		v_cndmask_b32_e32 v20, v20, v45, vcc
		v_mul_hi_u32 v43, v20, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v20, 1, v43, v20
		v_cmp_ge_u32_e64 vcc, v20, v31
		v_add_u32_e32 v43, v20, v33
		v_and_b32_e32 v45, 63, v0
		v_cndmask_b32_e32 v20, v20, v43, vcc
		v_cmp_ge_u32_e64 vcc, v20, v31
		v_add_u32_e32 v43, v20, v33
		v_lshlrev_b32_e32 v48, 7, v13
		v_cndmask_b32_e32 v20, v20, v43, vcc
		v_xad_u32 v43, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v50, v21, -1, 1
		v_cndmask_b32_e64 v20, v20, v43, s[30:31]
		v_cndmask_b32_e32 v21, v21, v50, vcc
		v_mul_hi_u32 v43, v21, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v21, 1, v43, v21
		v_cmp_ge_u32_e64 vcc, v21, v31
		v_add_u32_e32 v43, v21, v33
		s_lshl_b32 s20, s17, 8
		v_cndmask_b32_e32 v21, v21, v43, vcc
		v_cmp_ge_u32_e64 vcc, v21, v31
		v_add_u32_e32 v43, v21, v33
		s_lshl_b32 s23, s17, 7
		v_cndmask_b32_e32 v21, v21, v43, vcc
		v_xad_u32 v43, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v50, v22, -1, 1
		v_cndmask_b32_e64 v21, v21, v43, s[24:25]
		v_cndmask_b32_e32 v22, v22, v50, vcc
		v_mul_hi_u32 v43, v22, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v22, 1, v43, v22
		v_cmp_ge_u32_e64 vcc, v22, v31
		v_add_u32_e32 v43, v22, v33
		s_lshl_b32 s24, s17, 3
		v_cndmask_b32_e32 v22, v22, v43, vcc
		v_cmp_ge_u32_e64 vcc, v22, v31
		v_add_u32_e32 v43, v22, v33
		v_and_b32_e32 v50, 1, v8
		v_cndmask_b32_e32 v22, v22, v43, vcc
		v_xad_u32 v43, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v51, v23, -1, 1
		v_cndmask_b32_e64 v22, v22, v43, s[30:31]
		v_cndmask_b32_e32 v23, v23, v51, vcc
		v_mul_hi_u32 v43, v23, v32
		v_mul_lo_u32 v43, v43, v31
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v23, 1, v43, v23
		v_cmp_ge_u32_e64 vcc, v23, v31
		v_add_u32_e32 v43, v23, v33
		v_and_b32_e32 v51, 1, v7
		v_cndmask_b32_e32 v7, v23, v43, vcc
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v23, v7, v33
		v_and_b32_e32 v10, 1, v10
		v_cndmask_b32_e32 v7, v7, v23, vcc
		v_xad_u32 v23, v7, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v43, v24, -1, 1
		v_cndmask_b32_e64 v23, v7, v23, s[32:33]
		v_cndmask_b32_e32 v7, v24, v43, vcc
		v_mul_hi_u32 v24, v7, v32
		v_mul_lo_u32 v24, v24, v31
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v7, 1, v24, v7
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v24, v7, v33
		v_and_b32_e32 v12, 1, v12
		v_cndmask_b32_e32 v7, v7, v24, vcc
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v24, v7, v33
		v_mul_lo_u32 v43, s17, v13
		v_cndmask_b32_e32 v7, v7, v24, vcc
		v_xad_u32 v24, v7, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v52, v25, -1, 1
		v_cndmask_b32_e64 v24, v7, v24, s[30:31]
		v_cndmask_b32_e32 v7, v25, v52, vcc
		v_mul_hi_u32 v25, v7, v32
		v_mul_lo_u32 v25, v25, v31
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v7, 1, v25, v7
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v25, v7, v33
		v_mul_lo_u32 v52, s15, v6
		v_cndmask_b32_e32 v7, v7, v25, vcc
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v25, v7, v33
		v_and_b32_e32 v28, 1, v28
		v_cndmask_b32_e32 v7, v7, v25, vcc
		v_xad_u32 v25, v7, -1, 1
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v53, v26, -1, 1
		v_cndmask_b32_e64 v25, v7, v25, s[32:33]
		v_cndmask_b32_e32 v7, v26, v53, vcc
		v_mul_hi_u32 v26, v7, v32
		v_mul_lo_u32 v26, v26, v31
		v_xor_b32_e32 v26, -1, v26
		v_add3_u32 v7, 1, v26, v7
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v26, v7, v33
		v_mov_b32_e32 v32, s13
		v_cndmask_b32_e32 v7, v7, v26, vcc
		v_cmp_ge_u32_e64 vcc, v7, v31
		v_add_u32_e32 v26, v7, v33
		s_xor_b32 s25, s13, -1
		v_cndmask_b32_e32 v7, v7, v26, vcc
		v_xad_u32 v26, v7, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v31, v16, -1, 1
		v_cndmask_b32_e64 v26, v7, v26, s[30:31]
		v_cndmask_b32_e32 v7, v16, v31, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_add_i32 s25, s25, 1
		v_mov_b32_e32 v16, s25
		v_cndmask_b32_e64 v16, v32, v16, s[30:31]
		v_cvt_f32_u32_e32 v31, v16
		v_rcp_iflag_f32_e32 v31, v31
		v_xad_u32 v32, v16, -1, 1
		v_mul_f32_e32 v2, v2, v31
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v31, v32, v2
		v_mul_hi_u32 v31, v2, v31
		v_add_u32_e32 v2, v2, v31
		v_mul_hi_u32 v31, v7, v2
		v_mul_lo_u32 v31, v31, v16
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v7, 1, v31, v7
		v_cmp_ge_u32_e64 vcc, v7, v16
		v_add_u32_e32 v31, v7, v32
		v_and_b32_e32 v29, 1, v29
		v_cndmask_b32_e32 v7, v7, v31, vcc
		v_cmp_ge_u32_e64 vcc, v7, v16
		v_add_u32_e32 v31, v7, v32
		v_and_b32_e32 v33, 1, v0
		v_cndmask_b32_e32 v7, v7, v31, vcc
		v_xad_u32 v31, v7, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v53, v17, -1, 1
		v_cndmask_b32_e64 v7, v7, v31, s[32:33]
		v_cndmask_b32_e32 v17, v17, v53, vcc
		v_mul_hi_u32 v31, v17, v2
		v_mul_lo_u32 v31, v31, v16
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v17, 1, v31, v17
		v_cmp_ge_u32_e64 vcc, v17, v16
		v_add_u32_e32 v31, v17, v32
		v_mul_lo_u32 v53, s15, v30
		v_cndmask_b32_e32 v17, v17, v31, vcc
		v_cmp_ge_u32_e64 vcc, v17, v16
		v_add_u32_e32 v31, v17, v32
		s_mov_b32 s30, 0x7fffffff
		v_cndmask_b32_e32 v17, v17, v31, vcc
		v_xad_u32 v31, v17, -1, 1
		v_cmp_lt_i32_e64 vcc, v49, s22
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v54, v49, -1, 1
		v_cndmask_b32_e64 v17, v17, v31, s[26:27]
		v_cndmask_b32_e32 v31, v49, v54, vcc
		v_mul_hi_u32 v54, v31, v2
		v_mul_lo_u32 v54, v54, v16
		v_xor_b32_e32 v54, -1, v54
		v_add3_u32 v31, 1, v54, v31
		v_cmp_ge_u32_e64 vcc, v31, v16
		v_add_u32_e32 v54, v31, v32
		v_mov_b32_e32 v55, 32
		v_mul_lo_u32 v55, v55, v9
		v_cndmask_b32_e32 v9, v31, v54, vcc
		v_cmp_ge_u32_e64 vcc, v9, v16
		v_add_u32_e32 v31, v9, v32
		v_and_b32_e32 v54, 7, v0
		v_cndmask_b32_e32 v9, v9, v31, vcc
		v_xad_u32 v31, v9, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v56, v19, -1, 1
		v_cndmask_b32_e64 v9, v9, v31, s[28:29]
		v_cndmask_b32_e32 v31, v19, v56, vcc
		v_mul_hi_u32 v2, v31, v2
		v_mul_lo_u32 v2, v2, v16
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v31
		v_cmp_ge_u32_e64 vcc, v2, v16
		v_add_u32_e32 v31, v2, v32
		s_mov_b32 s15, 63
		v_cndmask_b32_e32 v2, v2, v31, vcc
		v_cmp_ge_u32_e64 vcc, v2, v16
		v_add_u32_e32 v16, v2, v32
		s_add_i32 s25, s14, 63
		v_cndmask_b32_e32 v2, v2, v16, vcc
		v_xad_u32 v16, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v16, s[26:27]
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s15, s15, 0
		s_add_i32 s15, s25, s15
		s_ashr_i32 s15, s15, 6
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v54
		v_mad_u32_u24 v5, v5, 16, v55
		v_add3_u32 v5, v5, v11, v14
		v_mad_u32_u24 v11, v15, 8, v5
		v_add_u32_e32 v14, 4, v11
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_readfirstlane_b32 s2, v0
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		v_lshlrev_b32_e32 v0, 4, v33
		v_lshl_add_u32 v5, v53, 1, v0
		v_lshlrev_b32_e32 v15, 6, v29
		v_lshlrev_b32_e32 v31, 5, v28
		v_add3_u32 v5, v5, v15, v31
		v_lshl_add_u32 v0, v52, 1, v0
		v_add3_u32 v0, v0, v15, v31
		v_cmp_lt_i32_e64 vcc, v16, s14
		s_mov_b64 s[26:27], vcc
		s_mov_b32 m0, s3
		s_and_saveexec_b64 s[40:41], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x2100
		s_nop 0
		buffer_load_dwordx4 v0, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[40:41]
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_lshlrev_b32_e32 v31, 4, v43
		v_lshl_add_u32 v7, v7, 1, v31
		v_mul_lo_u32 v31, s17, v12
		v_lshl_add_u32 v7, v31, 2, v7
		v_mul_lo_u32 v31, s17, v10
		v_lshl_add_u32 v7, v31, 1, v7
		v_mul_lo_u32 v31, s17, v51
		v_lshl_add_u32 v31, v31, 6, v7
		v_mul_lo_u32 v7, s17, v50
		v_lshl_add_u32 v32, v7, 5, v31
		v_cmp_lt_i32_e64 vcc, v11, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s3, 0xc5e0
		s_and_saveexec_b64 s[40:41], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[40:41]
		v_lshlrev_b32_e32 v32, 5, v7
		v_add3_u32 v7, v31, v32, s24
		v_cmp_lt_i32_e64 vcc, v14, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s3, 0xe6e0
		s_and_saveexec_b64 s[40:41], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2:
		s_mov_b64 exec, s[40:41]
		s_add_i32 s4, s14, 0xffffffc0
		v_add_u32_e32 v7, 0x80, v5
		v_cmp_lt_i32_e64 vcc, v16, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x4200
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x6300
		v_add_u32_e32 v7, 0x80, v0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3:
		s_mov_b64 exec, s[40:41]
		v_add3_u32 v7, v31, v32, s23
		v_cmp_lt_i32_e64 vcc, v11, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x107e0
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4:
		s_mov_b64 exec, s[40:41]
		s_mul_i32 s5, 0x88, s17
		v_add3_u32 v7, v31, v32, s5
		v_cmp_lt_i32_e64 vcc, v14, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x128e0
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5:
		s_mov_b64 exec, s[40:41]
		s_add_i32 s4, s14, 0xffffff80
		v_add_u32_e32 v5, 0x100, v5
		v_cmp_lt_i32_e64 vcc, v16, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x8400
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_6
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0xa500
		v_add_u32_e32 v0, 0x100, v0
		buffer_load_dwordx4 v0, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_6:
		s_mov_b64 exec, s[40:41]
		v_add3_u32 v0, v31, v32, s20
		v_cmp_lt_i32_e64 vcc, v11, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x149e0
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_7
		buffer_load_dwordx4 v0, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_7:
		s_mov_b64 exec, s[40:41]
		s_mul_i32 s5, 0x108, s17
		v_add3_u32 v0, v31, v32, s5
		v_cmp_lt_i32_e64 vcc, v14, s4
		s_mov_b64 s[24:25], vcc
		s_add_i32 m0, s3, 0x16ae0
		s_and_saveexec_b64 s[40:41], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_8
		buffer_load_dwordx4 v0, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_8:
		s_mov_b64 exec, s[40:41]
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v0, 4, v45
		v_lshlrev_b32_e32 v43, 4, v0
		v_and_b32_e32 v5, 15, v45
		v_mov_b32_e32 v52, 0x420
		v_mul_lo_u32 v52, v52, v5
		v_add3_u32 v53, v48, v43, v52
		ds_read_b128 v[56:59], v53
		ds_read_b128 v[60:63], v53 offset:64
		ds_read_b128 v[64:67], v53 offset:256
		ds_read_b128 v[68:71], v53 offset:320
		ds_read_b128 v[72:75], v53 offset:512
		ds_read_b128 v[76:79], v53 offset:576
		ds_read_b128 v[80:83], v53 offset:768
		ds_read_b128 v[84:87], v53 offset:832
		v_lshrrev_b32_e32 v7, 5, v45
		v_lshlrev_b32_e32 v45, 8, v7
		v_lshrrev_b32_e32 v7, 2, v5
		v_mov_b32_e32 v54, 0x420
		v_mul_lo_u32 v54, v54, v7
		v_lshlrev_b32_e32 v44, 5, v44
		v_add3_u32 v7, v45, v54, v44
		v_and_b32_e32 v0, 1, v0
		v_mov_b32_e32 v55, 0x1080
		v_mul_lo_u32 v55, v55, v0
		v_and_b32_e32 v0, 3, v5
		v_lshlrev_b32_e32 v0, 3, v0
		v_add3_u32 v88, v7, v55, v0
		ds_read_b64_tr_b16 v[92:93], v88 offset:50656
		ds_read_b64_tr_b16 v[94:95], v88 offset:59104
		ds_read_b64_tr_b16 v[96:97], v88 offset:51168
		ds_read_b64_tr_b16 v[98:99], v88 offset:59616
		ds_read_b64_tr_b16 v[100:101], v88 offset:50784
		ds_read_b64_tr_b16 v[102:103], v88 offset:59232
		ds_read_b64_tr_b16 v[104:105], v88 offset:51296
		ds_read_b64_tr_b16 v[106:107], v88 offset:59744
		s_add_i32 s4, s15, -3
		v_lshl_add_u32 v5, v33, 4, v15
		v_lshl_add_u32 v5, v28, 5, v5
		v_add_u32_e32 v5, 0x180, v5
		v_mul_lo_u32 v7, s16, v30
		v_add_u32_e32 v15, v5, v7
		v_mul_lo_u32 v6, s16, v6
		v_add_u32_e32 v30, v5, v6
		s_mul_i32 s5, 0x180, s17
		s_mul_i32 s16, 0x188, s17
		s_cmp_lt_i32 0, s4
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		v_mov_b32_e32 v108, v4
		v_mov_b32_e32 v109, v5
		v_mov_b32_e32 v110, v6
		v_mov_b32_e32 v111, v7
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		s_lshl_b32 s20, s22, 7
		s_add_i32 s23, s22, 3
		s_mul_i32 s23, s23, 64
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[92:95], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[96:99], v[60:63], v[4:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[104:107], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s14, s23
		s_barrier
		s_mul_hi_u32 s24, s22, 0xaaaaaaab
		s_lshr_b32 s24, s24, 1
		s_mul_i32 s24, s24, 3
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s22, s24
		s_mul_i32 s24, 0x4200, s24
		s_add_i32 s24, s3, s24
		v_cmp_lt_i32_e64 vcc, v16, s23
		s_mov_b64 s[26:27], vcc
		s_mov_b32 m0, s24
		s_and_saveexec_b64 s[40:41], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_9
		buffer_load_dwordx4 v15, s[28:31], s20 offen lds
		s_add_i32 m0, s24, 0x2100
		s_nop 0
		buffer_load_dwordx4 v30, s[28:31], s20 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_9:
		s_mov_b64 exec, s[40:41]
		s_mul_i32 s20, s17, s22
		s_lshl_b32 s20, s20, 7
		s_add_i32 s25, s5, s20
		v_add3_u32 v56, v31, v32, s25
		v_cmp_lt_i32_e64 vcc, v11, s23
		s_mov_b64 s[26:27], vcc
		s_add_i32 m0, s24, 0xc5e0
		s_and_saveexec_b64 s[40:41], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_10
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_10:
		s_mov_b64 exec, s[40:41]
		s_add_i32 s20, s16, s20
		v_add3_u32 v56, v31, v32, s20
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[26:27], vcc
		s_add_i32 m0, s24, 0xe6e0
		s_and_saveexec_b64 s[40:41], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_11
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_11:
		s_mov_b64 exec, s[40:41]
		s_waitcnt vmcnt(4)
		s_barrier
		s_add_i32 s22, s22, 1
		s_mul_hi_u32 s20, s22, 0xaaaaaaab
		s_lshr_b32 s20, s20, 1
		s_mul_i32 s20, s20, 3
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s20, s22, s20
		s_mul_i32 s20, 0x4200, s20
		v_add_u32_e32 v56, s20, v48
		v_add3_u32 v89, v56, v43, v52
		ds_read_b128 v[56:59], v89
		ds_read_b128 v[60:63], v89 offset:64
		ds_read_b128 v[64:67], v89 offset:256
		ds_read_b128 v[68:71], v89 offset:320
		ds_read_b128 v[72:75], v89 offset:512
		ds_read_b128 v[76:79], v89 offset:576
		ds_read_b128 v[80:83], v89 offset:768
		ds_read_b128 v[84:87], v89 offset:832
		v_add_u32_e32 v89, s20, v45
		v_add3_u32 v89, v89, v54, v44
		v_add3_u32 v89, v89, v55, v0
		ds_read_b64_tr_b16 v[92:93], v89 offset:50656
		ds_read_b64_tr_b16 v[94:95], v89 offset:59104
		ds_read_b64_tr_b16 v[96:97], v89 offset:51168
		ds_read_b64_tr_b16 v[98:99], v89 offset:59616
		ds_read_b64_tr_b16 v[100:101], v89 offset:50784
		ds_read_b64_tr_b16 v[102:103], v89 offset:59232
		ds_read_b64_tr_b16 v[104:105], v89 offset:51296
		ds_read_b64_tr_b16 v[106:107], v89 offset:59744
		s_cmp_lt_i32 s22, s4
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_mul_i32 s2, 0x108, s2
		s_add_i32 m0, s2, 0x18bc0
		v_lshlrev_b32_e32 v0, 1, v17
		v_lshl_add_u32 v11, v35, 1, v0
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x19400
		v_lshl_add_u32 v11, v36, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x19c40
		v_lshl_add_u32 v11, v37, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1a480
		v_lshl_add_u32 v11, v34, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1acc0
		v_lshl_add_u32 v11, v38, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1b500
		v_mul_lo_u32 v11, s18, v39
		v_lshl_add_u32 v11, v11, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1bd40
		v_mul_lo_u32 v11, s18, v41
		v_lshl_add_u32 v11, v11, 1, v0
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1c580
		v_mul_lo_u32 v11, s18, v42
		v_lshl_add_u32 v11, v11, 1, v0
		v_mul_lo_u32 v14, s18, v18
		v_lshl_add_u32 v14, v14, 1, v0
		v_mul_lo_u32 v15, s18, v20
		v_lshl_add_u32 v15, v15, 1, v0
		v_mul_lo_u32 v16, s18, v21
		v_lshl_add_u32 v16, v16, 1, v0
		v_mul_lo_u32 v17, s18, v22
		v_lshl_add_u32 v17, v17, 1, v0
		v_mul_lo_u32 v18, s18, v23
		v_lshl_add_u32 v18, v18, 1, v0
		v_mul_lo_u32 v20, s18, v24
		v_lshl_add_u32 v20, v20, 1, v0
		v_mul_lo_u32 v21, s18, v25
		v_lshl_add_u32 v21, v21, 1, v0
		v_mul_lo_u32 v22, s18, v26
		v_lshl_add_u32 v0, v22, 1, v0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[92:95], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[72:75], v[120:123]
		buffer_load_dword v11, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1cdc0
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[72:75], v[124:127]
		buffer_load_dword v14, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1d600
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[80:83], v[132:135]
		buffer_load_dword v15, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1de40
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[80:83], v[128:131]
		buffer_load_dword v16, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1e680
		v_mfma_f32_16x16x32_f16 v[4:7], v[96:99], v[60:63], v[4:7]
		buffer_load_dword v17, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1eec0
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[104:107], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		buffer_load_dword v18, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1f700
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[76:79], v[120:123]
		buffer_load_dword v20, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ff40
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		v_lshlrev_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v2, 1, v2
		v_mov_b32_e32 v11, 0x1080
		v_mul_lo_u32 v11, v11, v13
		v_add_u32_e32 v11, 0x10000, v11
		v_mov_b32_e32 v14, 0x108
		v_mul_lo_u32 v14, v14, v33
		v_add_u32_e32 v11, v11, v14
		v_lshlrev_b32_e32 v14, 6, v12
		v_add_u32_e32 v15, v11, v14
		v_lshlrev_b32_e32 v16, 5, v10
		v_lshlrev_b32_e32 v17, 4, v51
		v_add3_u32 v15, v15, v16, v17
		v_lshlrev_b32_e32 v18, 3, v50
		v_mov_b32_e32 v20, 0x840
		v_mul_lo_u32 v20, v20, v1
		v_add3_u32 v15, v15, v18, v20
		v_mov_b32_e32 v22, 0x420
		v_mul_lo_u32 v22, v22, v29
		v_mov_b32_e32 v23, 0x210
		v_mul_lo_u32 v23, v23, v28
		v_add3_u32 v15, v15, v22, v23
		v_lshlrev_b32_e32 v12, 5, v12
		v_lshlrev_b32_e32 v10, 4, v10
		v_lshl_add_u32 v24, v50, 2, 64
		buffer_load_dword v21, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x20780
		s_add_i32 s2, s15, -2
		buffer_load_dword v0, s[24:27], 0 offen lds
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_cselect_b32 s3, 1, 0
		s_and_b32 s4, s2, 0xffff
		s_lshr_b32 s5, s2, 16
		s_mul_i32 s8, s4, 0xaaab
		s_mul_i32 s4, s4, 0xaaaa
		s_mul_i32 s9, s5, 0xaaab
		s_mul_i32 s5, s5, 0xaaaa
		s_lshr_b32 s8, s8, 16
		s_and_b32 s14, s4, 0xffff
		s_and_b32 s16, s9, 0xffff
		s_add_i32 s8, s8, s14
		s_add_i32 s8, s8, s16
		s_lshr_b32 s4, s4, 16
		s_add_i32 s4, s5, s4
		s_lshr_b32 s5, s9, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s8, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s4, s4, 1
		s_mul_i32 s4, s4, 3
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s2, s2, s4
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v0, s2, v53
		ds_read_b128 v[36:39], v0
		ds_read_b128 v[56:59], v0 offset:64
		ds_read_b128 v[60:63], v0 offset:256
		ds_read_b128 v[64:67], v0 offset:320
		ds_read_b128 v[68:71], v0 offset:512
		ds_read_b128 v[72:75], v0 offset:576
		ds_read_b128 v[76:79], v0 offset:768
		ds_read_b128 v[80:83], v0 offset:832
		v_add_u32_e32 v0, s2, v88
		ds_read_b64_tr_b16 v[84:85], v0 offset:50656
		ds_read_b64_tr_b16 v[86:87], v0 offset:59104
		ds_read_b64_tr_b16 v[92:93], v0 offset:51168
		ds_read_b64_tr_b16 v[94:95], v0 offset:59616
		ds_read_b64_tr_b16 v[96:97], v0 offset:50784
		ds_read_b64_tr_b16 v[98:99], v0 offset:59232
		ds_read_b64_tr_b16 v[100:101], v0 offset:51296
		ds_read_b64_tr_b16 v[102:103], v0 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[36:39], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[92:95], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[80:83], v[128:131]
		s_add_i32 s2, s15, -1
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_cselect_b32 s3, 1, 0
		s_and_b32 s4, s2, 0xffff
		s_lshr_b32 s5, s2, 16
		s_mul_i32 s8, s4, 0xaaab
		s_mul_i32 s4, s4, 0xaaaa
		s_mul_i32 s9, s5, 0xaaab
		s_mul_i32 s5, s5, 0xaaaa
		s_lshr_b32 s8, s8, 16
		s_and_b32 s14, s4, 0xffff
		s_and_b32 s15, s9, 0xffff
		s_add_i32 s8, s8, s14
		s_add_i32 s8, s8, s15
		s_lshr_b32 s4, s4, 16
		s_add_i32 s4, s5, s4
		s_lshr_b32 s5, s9, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s8, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s4, s4, 1
		s_mul_i32 s4, s4, 3
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s2, s2, s4
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v0, s2, v53
		ds_read_b128 v[36:39], v0
		ds_read_b128 v[52:55], v0 offset:64
		ds_read_b128 v[56:59], v0 offset:256
		ds_read_b128 v[60:63], v0 offset:320
		ds_read_b128 v[64:67], v0 offset:512
		ds_read_b128 v[68:71], v0 offset:576
		ds_read_b128 v[72:75], v0 offset:768
		ds_read_b128 v[76:79], v0 offset:832
		v_add_u32_e32 v0, s2, v88
		ds_read_b64_tr_b16 v[80:81], v0 offset:50656
		ds_read_b64_tr_b16 v[82:83], v0 offset:59104
		ds_read_b64_tr_b16 v[84:85], v0 offset:51168
		ds_read_b64_tr_b16 v[86:87], v0 offset:59616
		ds_read_b64_tr_b16 v[88:89], v0 offset:50784
		ds_read_b64_tr_b16 v[90:91], v0 offset:59232
		s_mov_b32 s24, s6
		s_mov_b32 s25, s7
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		buffer_load_dwordx2 v[30:31], v9, s[24:27], 0 offen
		ds_read_b64_tr_b16 v[92:93], v0 offset:51296
		ds_read_b64_tr_b16 v[94:95], v0 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[36:39], v[4:7]
		buffer_load_dwordx2 v[34:35], v2, s[24:27], 0 offen
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[56:59], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[64:67], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[64:67], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[72:75], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[72:75], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[52:55], v[4:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v36, v30
		v_cvt_f32_f16_sdwa v37, v30 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v38, v31
		v_cvt_f32_f16_sdwa v39, v31 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v52, v34
		v_cvt_f32_f16_sdwa v53, v34 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v54, v35
		v_cvt_f32_f16_sdwa v55, v35 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[30:31], v[36:37]
		v_mov_b64_e32 v[34:35], v[4:5]
		v_pk_add_f32 v[56:57], v[34:35], v[30:31]
		v_mov_b64_e32 v[4:5], v[38:39]
		v_mov_b64_e32 v[34:35], v[6:7]
		v_pk_add_f32 v[58:59], v[34:35], v[4:5]
		v_mov_b64_e32 v[6:7], v[52:53]
		v_mov_b64_e32 v[34:35], v[108:109]
		v_pk_add_f32 v[36:37], v[34:35], v[6:7]
		v_mov_b64_e32 v[34:35], v[54:55]
		v_mov_b64_e32 v[42:43], v[110:111]
		v_pk_add_f32 v[38:39], v[42:43], v[34:35]
		v_mov_b64_e32 v[42:43], v[112:113]
		v_pk_add_f32 v[52:53], v[42:43], v[30:31]
		v_mov_b64_e32 v[42:43], v[114:115]
		v_pk_add_f32 v[54:55], v[42:43], v[4:5]
		v_mov_b64_e32 v[42:43], v[116:117]
		v_pk_add_f32 v[60:61], v[42:43], v[6:7]
		v_mov_b64_e32 v[42:43], v[118:119]
		v_pk_add_f32 v[62:63], v[42:43], v[34:35]
		v_mov_b64_e32 v[42:43], v[120:121]
		v_pk_add_f32 v[64:65], v[42:43], v[30:31]
		v_mov_b64_e32 v[42:43], v[122:123]
		v_pk_add_f32 v[66:67], v[42:43], v[4:5]
		v_mov_b64_e32 v[42:43], v[124:125]
		v_pk_add_f32 v[68:69], v[42:43], v[6:7]
		v_mov_b64_e32 v[42:43], v[126:127]
		v_pk_add_f32 v[70:71], v[42:43], v[34:35]
		v_mov_b64_e32 v[42:43], v[128:129]
		v_pk_add_f32 v[72:73], v[42:43], v[30:31]
		v_mov_b64_e32 v[30:31], v[130:131]
		v_pk_add_f32 v[74:75], v[30:31], v[4:5]
		v_mov_b64_e32 v[4:5], v[132:133]
		v_pk_add_f32 v[76:77], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[134:135]
		v_pk_add_f32 v[78:79], v[4:5], v[34:35]
		ds_read_b64 v[4:5], v15 offset:35776
		v_lshlrev_b32_e32 v0, 3, v51
		v_xor_b32_e32 v0, v24, v0
		v_bitop3_b32 v0, v12, v10, v0 bitop3:0x96
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 6, v6
		v_add3_u32 v7, v11, v2, v6
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_add3_u32 v7, v7, v9, v20
		v_lshrrev_b32_e32 v10, 3, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 4, v10
		v_add3_u32 v7, v7, v10, v22
		v_lshrrev_b32_e32 v11, 2, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 3, v11
		v_add3_u32 v7, v7, v11, v23
		v_lshrrev_b32_e32 v12, 1, v0
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 2, v12
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v7, v7, v12, v0
		ds_read_b64 v[20:21], v7 offset:35776
		v_add_u32_e32 v7, 0x10000, v14
		v_add_u32_e32 v7, v7, v16
		v_lshlrev_b32_e32 v14, 3, v1
		v_lshlrev_b32_e32 v15, 2, v29
		v_add_u32_e32 v16, 32, v33
		v_lshlrev_b32_e32 v22, 1, v28
		v_bitop3_b32 v16, v15, v16, v22 bitop3:0x96
		v_bitop3_b32 v16, v40, v14, v16 bitop3:0x96
		v_lshrrev_b32_e32 v23, 6, v16
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v24, 0x4200
		v_mul_lo_u32 v24, v24, v23
		v_add_u32_e32 v23, v7, v24
		v_lshrrev_b32_e32 v25, 5, v16
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v26, 0x2100
		v_mul_lo_u32 v26, v26, v25
		v_add3_u32 v23, v23, v17, v26
		v_lshrrev_b32_e32 v25, 4, v16
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v30, 0x1080
		v_mul_lo_u32 v30, v30, v25
		v_add3_u32 v23, v23, v18, v30
		v_lshrrev_b32_e32 v25, 3, v16
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v31, 0x840
		v_mul_lo_u32 v31, v31, v25
		v_lshrrev_b32_e32 v25, 2, v16
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v32, 0x420
		v_mul_lo_u32 v32, v32, v25
		v_add3_u32 v23, v23, v31, v32
		v_lshrrev_b32_e32 v25, 1, v16
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v34, 0x210
		v_mul_lo_u32 v34, v34, v25
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v25, 0x108
		v_mul_lo_u32 v25, v25, v16
		v_add3_u32 v16, v23, v34, v25
		ds_read_b64 v[42:43], v16 offset:35776
		v_add_u32_e32 v16, 0x10000, v24
		v_add_u32_e32 v16, v16, v2
		v_add3_u32 v16, v16, v26, v6
		v_add3_u32 v16, v16, v30, v9
		v_add3_u32 v16, v16, v31, v10
		v_add3_u32 v16, v16, v32, v11
		v_add3_u32 v16, v16, v34, v12
		v_add3_u32 v16, v16, v25, v0
		ds_read_b64 v[24:25], v16 offset:35776
		v_add_u32_e32 v16, 64, v33
		v_bitop3_b32 v16, v15, v16, v22 bitop3:0x96
		v_bitop3_b32 v16, v40, v14, v16 bitop3:0x96
		v_lshrrev_b32_e32 v23, 6, v16
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v26, 0x4200
		v_mul_lo_u32 v26, v26, v23
		v_add_u32_e32 v23, v7, v26
		v_lshrrev_b32_e32 v30, 5, v16
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v31, 0x2100
		v_mul_lo_u32 v31, v31, v30
		v_add3_u32 v23, v23, v17, v31
		v_lshrrev_b32_e32 v30, 4, v16
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v32, 0x1080
		v_mul_lo_u32 v32, v32, v30
		v_add3_u32 v23, v23, v18, v32
		v_lshrrev_b32_e32 v30, 3, v16
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v34, 0x840
		v_mul_lo_u32 v34, v34, v30
		v_lshrrev_b32_e32 v30, 2, v16
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v35, 0x420
		v_mul_lo_u32 v35, v35, v30
		v_add3_u32 v23, v23, v34, v35
		v_lshrrev_b32_e32 v30, 1, v16
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v41, 0x210
		v_mul_lo_u32 v41, v41, v30
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v30, 0x108
		v_mul_lo_u32 v30, v30, v16
		v_add3_u32 v16, v23, v41, v30
		ds_read_b64 v[44:45], v16 offset:35776
		v_add_u32_e32 v16, 0x10000, v26
		v_add_u32_e32 v16, v16, v2
		v_add3_u32 v16, v16, v31, v6
		v_add3_u32 v16, v16, v32, v9
		v_add3_u32 v16, v16, v34, v10
		v_add3_u32 v16, v16, v35, v11
		v_add3_u32 v16, v16, v41, v12
		v_add3_u32 v16, v16, v30, v0
		ds_read_b64 v[30:31], v16 offset:35776
		v_add_u32_e32 v16, 0x60, v33
		v_bitop3_b32 v15, v15, v16, v22 bitop3:0x96
		v_bitop3_b32 v14, v40, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v15, 6, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 0x4200
		v_mul_lo_u32 v16, v16, v15
		v_add_u32_e32 v7, v7, v16
		v_lshrrev_b32_e32 v15, 5, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v22, 0x2100
		v_mul_lo_u32 v22, v22, v15
		v_add3_u32 v7, v7, v17, v22
		v_lshrrev_b32_e32 v15, 4, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v17, 0x1080
		v_mul_lo_u32 v17, v17, v15
		v_add3_u32 v7, v7, v18, v17
		v_lshrrev_b32_e32 v15, 3, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 0x840
		v_mul_lo_u32 v18, v18, v15
		v_lshrrev_b32_e32 v15, 2, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v23, 0x420
		v_mul_lo_u32 v23, v23, v15
		v_add3_u32 v7, v7, v18, v23
		v_lshrrev_b32_e32 v15, 1, v14
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v26, 0x210
		v_mul_lo_u32 v26, v26, v15
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x108
		v_mul_lo_u32 v15, v15, v14
		v_add3_u32 v7, v7, v26, v15
		ds_read_b64 v[34:35], v7 offset:35776
		v_add_u32_e32 v7, 0x10000, v16
		v_add_u32_e32 v2, v7, v2
		v_add3_u32 v2, v2, v22, v6
		v_add3_u32 v2, v2, v17, v9
		v_add3_u32 v2, v2, v18, v10
		v_add3_u32 v2, v2, v23, v11
		v_add3_u32 v2, v2, v26, v12
		v_add3_u32 v0, v2, v15, v0
		ds_read_b64 v[6:7], v0 offset:35776
		s_waitcnt lgkmcnt(7)
		v_cvt_f32_f16_e32 v80, v4
		v_cvt_f32_f16_sdwa v81, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v5
		v_cvt_f32_f16_sdwa v83, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(6)
		v_cvt_f32_f16_e32 v84, v20
		v_cvt_f32_f16_sdwa v85, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v21
		v_cvt_f32_f16_sdwa v87, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(5)
		v_cvt_f32_f16_e32 v20, v42
		v_cvt_f32_f16_sdwa v21, v42 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v22, v43
		v_cvt_f32_f16_sdwa v23, v43 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(4)
		v_cvt_f32_f16_e32 v40, v24
		v_cvt_f32_f16_sdwa v41, v24 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v25
		v_cvt_f32_f16_sdwa v43, v25 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v88, v44
		v_cvt_f32_f16_sdwa v89, v44 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v45
		v_cvt_f32_f16_sdwa v91, v45 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v92, v30
		v_cvt_f32_f16_sdwa v93, v30 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v31
		v_cvt_f32_f16_sdwa v95, v31 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v96, v34
		v_cvt_f32_f16_sdwa v97, v34 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v35
		v_cvt_f32_f16_sdwa v99, v35 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v100, v6
		v_cvt_f32_f16_sdwa v101, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v7
		v_cvt_f32_f16_sdwa v103, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[4:5], v[80:81]
		v_mov_b64_e32 v[6:7], v[56:57]
		v_pk_fma_f32 v[104:105], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[82:83]
		v_mov_b64_e32 v[6:7], v[58:59]
		v_pk_fma_f32 v[106:107], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[84:85]
		v_mov_b64_e32 v[6:7], v[36:37]
		v_pk_fma_f32 v[56:57], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[86:87]
		v_mov_b64_e32 v[6:7], v[38:39]
		v_pk_fma_f32 v[58:59], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[20:21]
		v_mov_b64_e32 v[6:7], v[52:53]
		v_pk_fma_f32 v[36:37], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[22:23]
		v_mov_b64_e32 v[6:7], v[54:55]
		v_pk_fma_f32 v[38:39], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[40:41]
		v_mov_b64_e32 v[6:7], v[60:61]
		v_pk_fma_f32 v[20:21], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[42:43]
		v_mov_b64_e32 v[6:7], v[62:63]
		v_pk_fma_f32 v[22:23], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[88:89]
		v_mov_b64_e32 v[6:7], v[64:65]
		v_pk_fma_f32 v[40:41], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[90:91]
		v_mov_b64_e32 v[6:7], v[66:67]
		v_pk_fma_f32 v[42:43], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[92:93]
		v_mov_b64_e32 v[6:7], v[68:69]
		v_pk_fma_f32 v[52:53], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[94:95]
		v_mov_b64_e32 v[6:7], v[70:71]
		v_pk_fma_f32 v[54:55], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[96:97]
		v_mov_b64_e32 v[6:7], v[72:73]
		v_pk_fma_f32 v[60:61], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[98:99]
		v_mov_b64_e32 v[6:7], v[74:75]
		v_pk_fma_f32 v[62:63], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[100:101]
		v_mov_b64_e32 v[6:7], v[76:77]
		v_pk_fma_f32 v[64:65], v[6:7], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[102:103]
		v_mov_b64_e32 v[6:7], v[78:79]
		v_pk_fma_f32 v[66:67], v[6:7], v[4:5], v[6:7]
		v_cvt_pk_f16_f32 v4, v104, v105
		v_cvt_pk_f16_f32 v5, v106, v107
		v_cvt_pk_f16_f32 v6, v56, v57
		v_cvt_pk_f16_f32 v7, v58, v59
		v_cvt_pk_f16_f32 v10, v36, v37
		v_cvt_pk_f16_f32 v11, v38, v39
		v_cvt_pk_f16_f32 v14, v20, v21
		v_cvt_pk_f16_f32 v15, v22, v23
		v_cvt_pk_f16_f32 v16, v40, v41
		v_cvt_pk_f16_f32 v17, v42, v43
		v_cvt_pk_f16_f32 v20, v52, v53
		v_cvt_pk_f16_f32 v21, v54, v55
		v_cvt_pk_f16_f32 v22, v60, v61
		v_cvt_pk_f16_f32 v23, v62, v63
		v_cvt_pk_f16_f32 v24, v64, v65
		v_cvt_pk_f16_f32 v25, v66, v67
		v_cmp_lt_i32_e64 vcc, v46, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v49, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 10
		s_add_i32 s8, s0, s1
		s_mul_i32 s9, s21, s19
		s_lshl_b32 s9, s9, 8
		s_add_i32 s8, s8, s9
		v_mul_lo_u32 v0, s19, v13
		v_lshlrev_b32_e32 v0, 5, v0
		v_mul_lo_u32 v2, s19, v33
		v_lshlrev_b32_e32 v2, 1, v2
		v_add3_u32 v9, s8, v0, v2
		v_mul_lo_u32 v1, s19, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v12, s19, v29
		v_lshlrev_b32_e32 v12, 3, v12
		v_add3_u32 v9, v9, v1, v12
		v_mul_lo_u32 v13, s19, v28
		v_lshlrev_b32_e32 v13, 2, v13
		v_and_b32_e32 v8, 15, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_add3_u32 v9, v9, v13, v8
		v_mov_b32_e32 v18, 0x80000000
		v_cndmask_b32_e64 v9, v18, v9, s[6:7]
		s_mov_b32 s20, s10
		s_mov_b32 s21, s11
		s_mov_b32 s22, s30
		s_mov_b32 s23, s31
		buffer_store_dwordx2 v[4:5], v9, s[20:23], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v19, s13
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		s_add_i32 s2, s0, 0x80
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s9
		v_add3_u32 v4, s2, v0, v2
		v_add3_u32 v4, v4, v1, v12
		v_add3_u32 v4, v4, v13, v8
		v_cndmask_b32_e64 v4, v18, v4, s[10:11]
		buffer_store_dwordx2 v[6:7], v4, s[20:23], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v47, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		s_lshl_b32 s8, s19, 6
		s_add_i32 s13, s8, s0
		s_add_i32 s13, s13, s1
		s_add_i32 s13, s13, s9
		v_add3_u32 v4, s13, v0, v2
		v_add3_u32 v4, v4, v1, v12
		v_add3_u32 v4, v4, v13, v8
		v_cndmask_b32_e64 v4, v18, v4, s[10:11]
		buffer_store_dwordx2 v[10:11], v4, s[20:23], 0 offen sc0 nt
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		s_add_i32 s2, s8, 0x80
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s9
		v_add3_u32 v4, s2, v0, v2
		v_add3_u32 v4, v4, v1, v12
		v_add3_u32 v4, v4, v13, v8
		v_cndmask_b32_e64 v4, v18, v4, s[10:11]
		buffer_store_dwordx2 v[14:15], v4, s[20:23], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		s_lshl_b32 s8, s19, 7
		s_add_i32 s13, s8, s0
		s_add_i32 s13, s13, s1
		s_add_i32 s13, s13, s9
		v_add3_u32 v3, s13, v0, v2
		v_add3_u32 v3, v3, v1, v12
		v_add3_u32 v3, v3, v13, v8
		v_cndmask_b32_e64 v3, v18, v3, s[10:11]
		buffer_store_dwordx2 v[16:17], v3, s[20:23], 0 offen sc0 nt
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		s_add_i32 s2, s8, 0x80
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s9
		v_add3_u32 v3, s2, v0, v2
		v_add3_u32 v3, v3, v1, v12
		v_add3_u32 v3, v3, v13, v8
		v_cndmask_b32_e64 v3, v18, v3, s[10:11]
		buffer_store_dwordx2 v[20:21], v3, s[20:23], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v27, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		s_mul_i32 s4, 0xc0, s19
		s_add_i32 s5, s4, s0
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s9
		v_add3_u32 v3, s5, v0, v2
		v_add3_u32 v3, v3, v1, v12
		v_add3_u32 v3, v3, v13, v8
		v_cndmask_b32_e64 v3, v18, v3, s[10:11]
		buffer_store_dwordx2 v[22:23], v3, s[20:23], 0 offen sc0 nt
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		s_add_i32 s2, s4, 0x80
		s_add_i32 s0, s2, s0
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s9
		v_add3_u32 v0, s0, v0, v2
		v_add3_u32 v0, v0, v1, v12
		v_add3_u32 v0, v0, v13, v8
		v_cndmask_b32_e64 v0, v18, v0, s[10:11]
		buffer_store_dwordx2 v[24:25], v0, s[20:23], 0 offen sc0 nt
		s_waitcnt vmcnt(0)
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
		.amdhsa_next_free_sgpr 42
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 42
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
    .sgpr_count:     42
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
