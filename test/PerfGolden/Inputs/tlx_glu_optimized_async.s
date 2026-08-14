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
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v16
		v_and_b32_e32 v16, 63, v0
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
		v_mov_b32_e32 v27, s23
		v_mov_b32_e32 v28, s12
		v_cndmask_b32_e64 v27, v28, v27, s[30:31]
		v_cvt_f32_u32_e32 v28, v27
		v_rcp_iflag_f32_e32 v28, v28
		v_add3_u32 v6, 8, v6, s16
		v_mul_f32_e32 v28, v2, v28
		v_cvt_u32_f32_e32 v28, v28
		v_xad_u32 v29, v27, -1, 1
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
		v_add_u32_e32 v19, s16, v19
		v_cndmask_b32_e32 v26, v26, v30, vcc
		v_add_u32_e32 v30, v26, v29
		v_cmp_ge_u32_e64 vcc, v26, v27
		v_add3_u32 v32, 8, v18, s16
		v_add3_u32 v33, 16, v18, s16
		v_cndmask_b32_e32 v26, v26, v30, vcc
		v_xad_u32 v30, v26, -1, 1
		v_cndmask_b32_e64 v26, v26, v30, s[24:25]
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v30, v6, -1, 1
		v_cndmask_b32_e32 v6, v6, v30, vcc
		v_mul_hi_u32 v30, v6, v28
		v_mul_lo_u32 v30, v30, v27
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v6, 1, v30, v6
		v_add_u32_e32 v30, v6, v29
		v_cmp_ge_u32_e64 vcc, v6, v27
		v_add3_u32 v34, 24, v18, s16
		v_add3_u32 v35, 32, v18, s16
		v_cndmask_b32_e32 v6, v6, v30, vcc
		v_add_u32_e32 v30, v6, v29
		v_cmp_ge_u32_e64 vcc, v6, v27
		v_add3_u32 v36, 40, v18, s16
		v_add3_u32 v37, 48, v18, s16
		v_cndmask_b32_e32 v6, v6, v30, vcc
		v_xad_u32 v30, v6, -1, 1
		v_cndmask_b32_e64 v6, v6, v30, s[24:25]
		v_cmp_lt_i32_e64 vcc, v31, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v30, v31, -1, 1
		v_cndmask_b32_e32 v30, v31, v30, vcc
		v_mul_hi_u32 v31, v30, v28
		v_mul_lo_u32 v31, v31, v27
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v30, 1, v31, v30
		v_add_u32_e32 v31, v30, v29
		v_cmp_ge_u32_e64 vcc, v30, v27
		v_add3_u32 v38, 56, v18, s16
		v_add3_u32 v18, 64, v18, s16
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_add_u32_e32 v31, v30, v29
		v_cmp_ge_u32_e64 vcc, v30, v27
		v_add_u32_e32 v20, s16, v20
		v_add_u32_e32 v21, s16, v21
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_xad_u32 v31, v30, -1, 1
		v_cmp_lt_i32_e64 vcc, v32, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v39, v32, -1, 1
		v_cndmask_b32_e32 v32, v32, v39, vcc
		v_mul_hi_u32 v39, v32, v28
		v_mul_lo_u32 v39, v39, v27
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v32, 1, v39, v32
		v_add_u32_e32 v39, v32, v29
		v_cmp_ge_u32_e64 vcc, v32, v27
		v_add_u32_e32 v22, s16, v22
		v_add_u32_e32 v23, s16, v23
		v_cndmask_b32_e32 v32, v32, v39, vcc
		v_add_u32_e32 v39, v32, v29
		v_cmp_ge_u32_e64 vcc, v32, v27
		v_add_u32_e32 v24, s16, v24
		v_add_u32_e32 v25, s16, v25
		v_cndmask_b32_e32 v32, v32, v39, vcc
		v_xad_u32 v39, v32, -1, 1
		v_cmp_lt_i32_e64 vcc, v33, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v40, v33, -1, 1
		v_cndmask_b32_e32 v33, v33, v40, vcc
		v_mul_hi_u32 v40, v33, v28
		v_mul_lo_u32 v40, v40, v27
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v33, 1, v40, v33
		v_add_u32_e32 v40, v33, v29
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_add_u32_e32 v41, s20, v17
		v_mad_u32_u24 v16, v16, 2, s20
		v_cndmask_b32_e32 v33, v33, v40, vcc
		v_add_u32_e32 v40, v33, v29
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_add3_u32 v42, 1, v17, s20
		v_and_b32_e32 v7, 1, v7
		v_cndmask_b32_e32 v33, v33, v40, vcc
		v_xad_u32 v40, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v43, v34, -1, 1
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_mul_hi_u32 v43, v34, v28
		v_mul_lo_u32 v43, v43, v27
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v34, 1, v43, v34
		v_add_u32_e32 v43, v34, v29
		v_cmp_ge_u32_e64 vcc, v34, v27
		v_add3_u32 v44, 2, v17, s20
		v_add3_u32 v45, 3, v17, s20
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_add_u32_e32 v43, v34, v29
		v_cmp_ge_u32_e64 vcc, v34, v27
		v_add3_u32 v46, 4, v17, s20
		v_add3_u32 v47, 5, v17, s20
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_xad_u32 v43, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v48, v35, -1, 1
		v_cndmask_b32_e32 v35, v35, v48, vcc
		v_mul_hi_u32 v48, v35, v28
		v_mul_lo_u32 v48, v48, v27
		v_xor_b32_e32 v48, -1, v48
		v_add3_u32 v35, 1, v48, v35
		v_add_u32_e32 v48, v35, v29
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add3_u32 v49, 6, v17, s20
		v_add3_u32 v17, 7, v17, s20
		v_cndmask_b32_e32 v35, v35, v48, vcc
		v_add_u32_e32 v48, v35, v29
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_and_b32_e32 v11, 1, v11
		v_and_b32_e32 v1, 1, v1
		v_cndmask_b32_e32 v35, v35, v48, vcc
		v_xad_u32 v48, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[38:39], vcc
		v_xad_u32 v50, v36, -1, 1
		v_cndmask_b32_e32 v36, v36, v50, vcc
		v_mul_hi_u32 v50, v36, v28
		v_mul_lo_u32 v50, v50, v27
		v_xor_b32_e32 v50, -1, v50
		v_add3_u32 v36, 1, v50, v36
		v_add_u32_e32 v50, v36, v29
		v_cmp_ge_u32_e64 vcc, v36, v27
		v_mov_b32_e32 v51, 0x840
		v_mul_lo_u32 v51, v51, v1
		v_cndmask_b32_e32 v1, v36, v50, vcc
		v_add_u32_e32 v36, v1, v29
		v_cmp_ge_u32_e64 vcc, v1, v27
		s_waitcnt lgkmcnt(0)
		s_lshl_b32 s23, s17, 3
		s_xor_b32 s40, s13, -1
		v_cndmask_b32_e32 v1, v1, v36, vcc
		v_xad_u32 v36, v1, -1, 1
		v_cndmask_b32_e64 v1, v1, v36, s[38:39]
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[38:39], vcc
		v_xad_u32 v36, v37, -1, 1
		v_cndmask_b32_e32 v36, v37, v36, vcc
		v_mul_hi_u32 v37, v36, v28
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v36, 1, v37, v36
		v_add_u32_e32 v37, v36, v29
		v_cmp_ge_u32_e64 vcc, v36, v27
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s42, s26, s28
		s_cselect_b32 s43, s27, s29
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_cmp_ge_u32_e64 vcc, v36, v27
		v_add_u32_e32 v37, v36, v29
		s_add_i32 s26, s40, 1
		v_mov_b32_e32 v50, s26
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_xad_u32 v37, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v37, s[38:39]
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v37, v38, -1, 1
		v_cndmask_b32_e32 v37, v38, v37, vcc
		v_mul_hi_u32 v38, v37, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v37, 1, v38, v37
		v_cmp_ge_u32_e64 vcc, v37, v27
		v_add_u32_e32 v38, v37, v29
		s_mov_b32 s46, 0x7fffffff
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_cmp_ge_u32_e64 vcc, v37, v27
		v_add_u32_e32 v38, v37, v29
		v_and_b32_e32 v52, 1, v4
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_xad_u32 v38, v37, -1, 1
		v_cndmask_b32_e64 v37, v37, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v18, -1, 1
		v_cndmask_b32_e32 v18, v18, v38, vcc
		v_mul_hi_u32 v38, v18, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v18, 1, v38, v18
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v38, v18, v29
		s_mov_b32 s28, 63
		v_cndmask_b32_e32 v18, v18, v38, vcc
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v38, v18, v29
		s_add_i32 s29, s14, 63
		v_cndmask_b32_e32 v18, v18, v38, vcc
		v_xad_u32 v38, v18, -1, 1
		v_cndmask_b32_e64 v18, v18, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v19, -1, 1
		v_cndmask_b32_e32 v19, v19, v38, vcc
		v_mul_hi_u32 v38, v19, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v19, 1, v38, v19
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v38, v19, v29
		s_cmp_lt_i32 s29, 0
		v_cndmask_b32_e32 v19, v19, v38, vcc
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v38, v19, v29
		v_mul_lo_u32 v53, s17, v9
		v_cndmask_b32_e32 v19, v19, v38, vcc
		v_xad_u32 v38, v19, -1, 1
		v_cndmask_b32_e64 v19, v19, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v20, -1, 1
		v_cndmask_b32_e32 v20, v20, v38, vcc
		v_mul_hi_u32 v38, v20, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v20, 1, v38, v20
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v38, v20, v29
		s_cselect_b32 s28, s28, 0
		s_add_i32 s28, s29, s28
		v_cndmask_b32_e32 v20, v20, v38, vcc
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v38, v20, v29
		v_mul_lo_u32 v54, s17, v14
		v_cndmask_b32_e32 v20, v20, v38, vcc
		v_xad_u32 v38, v20, -1, 1
		v_cndmask_b32_e64 v20, v20, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v21, -1, 1
		v_cndmask_b32_e32 v21, v21, v38, vcc
		v_mul_hi_u32 v38, v21, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v21, 1, v38, v21
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v38, v21, v29
		v_lshlrev_b32_e32 v54, 3, v54
		v_cndmask_b32_e32 v21, v21, v38, vcc
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v38, v21, v29
		v_mov_b32_e32 v55, 8
		v_mul_lo_u32 v55, v55, v15
		v_cndmask_b32_e32 v21, v21, v38, vcc
		v_xad_u32 v38, v21, -1, 1
		v_cndmask_b32_e64 v21, v21, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v22, -1, 1
		v_cndmask_b32_e32 v22, v22, v38, vcc
		v_mul_hi_u32 v38, v22, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v22, 1, v38, v22
		v_cmp_ge_u32_e64 vcc, v22, v27
		v_add_u32_e32 v38, v22, v29
		v_lshlrev_b32_e32 v53, 1, v53
		v_cndmask_b32_e32 v22, v22, v38, vcc
		v_cmp_ge_u32_e64 vcc, v22, v27
		v_add_u32_e32 v38, v22, v29
		v_mov_b32_e32 v56, 32
		v_mul_lo_u32 v56, v56, v8
		v_cndmask_b32_e32 v22, v22, v38, vcc
		v_xad_u32 v38, v22, -1, 1
		v_cndmask_b32_e64 v22, v22, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v23, -1, 1
		v_cndmask_b32_e32 v23, v23, v38, vcc
		v_mul_hi_u32 v38, v23, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v23, 1, v38, v23
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v38, v23, v29
		v_and_b32_e32 v9, 1, v9
		v_cndmask_b32_e32 v23, v23, v38, vcc
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v38, v23, v29
		v_mov_b32_e32 v57, 16
		v_mul_lo_u32 v57, v57, v5
		v_cndmask_b32_e32 v23, v23, v38, vcc
		v_xad_u32 v38, v23, -1, 1
		v_cndmask_b32_e64 v23, v23, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v24, -1, 1
		v_cndmask_b32_e32 v24, v24, v38, vcc
		v_mul_hi_u32 v38, v24, v28
		v_mul_lo_u32 v38, v38, v27
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v24, 1, v38, v24
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v38, v24, v29
		v_readfirstlane_b32 s29, v0
		v_cndmask_b32_e32 v24, v24, v38, vcc
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v38, v24, v29
		v_mov_b32_e32 v58, s13
		v_cndmask_b32_e64 v50, v58, v50, s[42:43]
		v_cndmask_b32_e32 v24, v24, v38, vcc
		v_xad_u32 v38, v24, -1, 1
		v_cndmask_b32_e64 v24, v24, v38, s[26:27]
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v25, -1, 1
		v_cndmask_b32_e32 v25, v25, v38, vcc
		v_mul_hi_u32 v28, v25, v28
		v_mul_lo_u32 v28, v28, v27
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v25, 1, v28, v25
		v_cmp_ge_u32_e64 vcc, v25, v27
		v_add_u32_e32 v28, v25, v29
		s_lshr_b32 s29, s29, 6
		v_cndmask_b32_e32 v25, v25, v28, vcc
		v_cmp_ge_u32_e64 vcc, v25, v27
		v_add_u32_e32 v27, v25, v29
		s_mul_i32 s38, 0x420, s29
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_xad_u32 v27, v25, -1, 1
		v_cndmask_b32_e64 v25, v25, v27, s[26:27]
		v_cmp_lt_i32_e64 vcc, v41, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v27, v41, -1, 1
		v_cndmask_b32_e32 v27, v41, v27, vcc
		v_cvt_f32_u32_e32 v28, v50
		v_rcp_iflag_f32_e32 v28, v28
		s_mov_b32 m0, s38
		v_mul_f32_e32 v2, v2, v28
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v28, v50, -1, 1
		v_mul_lo_u32 v29, v28, v2
		v_mul_hi_u32 v29, v2, v29
		v_add_u32_e32 v2, v2, v29
		v_mul_hi_u32 v29, v27, v2
		v_mul_lo_u32 v29, v29, v50
		v_xor_b32_e32 v29, -1, v29
		v_add3_u32 v27, 1, v29, v27
		v_cmp_ge_u32_e64 vcc, v27, v50
		v_add_u32_e32 v29, v27, v28
		s_mul_i32 s39, 0x88, s17
		v_cndmask_b32_e32 v27, v27, v29, vcc
		v_cmp_ge_u32_e64 vcc, v27, v50
		v_add_u32_e32 v29, v27, v28
		v_mul_lo_u32 v38, s15, v6
		v_cndmask_b32_e32 v27, v27, v29, vcc
		v_xad_u32 v29, v27, -1, 1
		v_cndmask_b32_e64 v27, v27, v29, s[26:27]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v29, v16, -1, 1
		v_cndmask_b32_e32 v16, v16, v29, vcc
		v_mul_hi_u32 v29, v16, v2
		v_mul_lo_u32 v29, v29, v50
		v_xor_b32_e32 v29, -1, v29
		v_add3_u32 v16, 1, v29, v16
		v_cmp_ge_u32_e64 vcc, v16, v50
		v_add_u32_e32 v29, v16, v28
		v_lshlrev_b32_e32 v27, 1, v27
		v_add_u32_e32 v41, s23, v27
		v_add_u32_e32 v58, s39, v27
		v_cndmask_b32_e32 v16, v16, v29, vcc
		v_cmp_ge_u32_e64 vcc, v16, v50
		v_add_u32_e32 v29, v16, v28
		v_and_b32_e32 v59, 7, v0
		v_cndmask_b32_e32 v16, v16, v29, vcc
		v_xad_u32 v29, v16, -1, 1
		v_cndmask_b32_e64 v16, v16, v29, s[26:27]
		v_cmp_lt_i32_e64 vcc, v42, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v29, v42, -1, 1
		v_cndmask_b32_e32 v29, v42, v29, vcc
		v_mul_hi_u32 v42, v29, v2
		v_mul_lo_u32 v42, v42, v50
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v29, 1, v42, v29
		v_cmp_ge_u32_e64 vcc, v29, v50
		v_add_u32_e32 v42, v29, v28
		v_add3_u32 v41, v41, v54, v53
		v_cndmask_b32_e32 v29, v29, v42, vcc
		v_cmp_ge_u32_e64 vcc, v29, v50
		v_add_u32_e32 v42, v29, v28
		v_mul_lo_u32 v60, s15, v26
		v_cndmask_b32_e32 v29, v29, v42, vcc
		v_xad_u32 v42, v29, -1, 1
		v_cndmask_b32_e64 v29, v29, v42, s[26:27]
		v_cmp_lt_i32_e64 vcc, v44, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v42, v44, -1, 1
		v_cndmask_b32_e32 v42, v44, v42, vcc
		v_mul_hi_u32 v44, v42, v2
		v_mul_lo_u32 v44, v44, v50
		v_xor_b32_e32 v44, -1, v44
		v_add3_u32 v42, 1, v44, v42
		v_cmp_ge_u32_e64 vcc, v42, v50
		v_add_u32_e32 v44, v42, v28
		v_add3_u32 v58, v58, v54, v53
		v_cndmask_b32_e32 v42, v42, v44, vcc
		v_cmp_ge_u32_e64 vcc, v42, v50
		v_add_u32_e32 v44, v42, v28
		s_mul_i32 s23, 0x108, s17
		v_add_u32_e32 v61, s23, v27
		v_cndmask_b32_e32 v42, v42, v44, vcc
		v_xad_u32 v44, v42, -1, 1
		v_cndmask_b32_e64 v42, v42, v44, s[26:27]
		v_cmp_lt_i32_e64 vcc, v45, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v44, v45, -1, 1
		v_cndmask_b32_e32 v44, v45, v44, vcc
		v_mul_hi_u32 v45, v44, v2
		v_mul_lo_u32 v45, v45, v50
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v44, 1, v45, v44
		v_cmp_ge_u32_e64 vcc, v44, v50
		v_add_u32_e32 v45, v44, v28
		v_add3_u32 v61, v61, v54, v53
		v_cndmask_b32_e32 v44, v44, v45, vcc
		v_cmp_ge_u32_e64 vcc, v44, v50
		v_add_u32_e32 v45, v44, v28
		v_lshrrev_b32_e32 v62, 2, v0
		v_cndmask_b32_e32 v44, v44, v45, vcc
		v_xad_u32 v45, v44, -1, 1
		v_cndmask_b32_e64 v44, v44, v45, s[26:27]
		v_cmp_lt_i32_e64 vcc, v46, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v45, v46, -1, 1
		v_cndmask_b32_e32 v45, v46, v45, vcc
		v_mul_hi_u32 v46, v45, v2
		v_mul_lo_u32 v46, v46, v50
		v_xor_b32_e32 v46, -1, v46
		v_add3_u32 v45, 1, v46, v45
		v_cmp_ge_u32_e64 vcc, v45, v50
		v_add_u32_e32 v46, v45, v28
		v_cmp_eq_u32_e64 s[40:41], v14, s22
		v_cndmask_b32_e32 v45, v45, v46, vcc
		v_cmp_ge_u32_e64 vcc, v45, v50
		v_add_u32_e32 v46, v45, v28
		v_lshrrev_b32_e32 v63, 1, v0
		v_cndmask_b32_e32 v45, v45, v46, vcc
		v_xad_u32 v46, v45, -1, 1
		v_cndmask_b32_e64 v45, v45, v46, s[26:27]
		v_cmp_lt_i32_e64 vcc, v47, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v46, v47, -1, 1
		v_cndmask_b32_e32 v46, v47, v46, vcc
		v_mul_hi_u32 v47, v46, v2
		v_mul_lo_u32 v47, v47, v50
		v_xor_b32_e32 v47, -1, v47
		v_add3_u32 v46, 1, v47, v46
		v_cmp_ge_u32_e64 vcc, v46, v50
		v_add_u32_e32 v47, v46, v28
		v_and_b32_e32 v63, 1, v63
		v_cndmask_b32_e32 v46, v46, v47, vcc
		v_cmp_ge_u32_e64 vcc, v46, v50
		v_add_u32_e32 v47, v46, v28
		v_and_b32_e32 v64, 1, v0
		v_cndmask_b32_e32 v46, v46, v47, vcc
		v_xad_u32 v47, v46, -1, 1
		v_cndmask_b32_e64 v46, v46, v47, s[26:27]
		v_cmp_lt_i32_e64 vcc, v49, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v47, v49, -1, 1
		v_cndmask_b32_e32 v47, v49, v47, vcc
		v_mul_hi_u32 v49, v47, v2
		v_mul_lo_u32 v49, v49, v50
		v_xor_b32_e32 v49, -1, v49
		v_add3_u32 v47, 1, v49, v47
		v_cmp_ge_u32_e64 vcc, v47, v50
		v_add_u32_e32 v49, v47, v28
		v_mov_b32_e32 v65, 8
		v_mul_lo_u32 v65, v65, v64
		v_cndmask_b32_e32 v47, v47, v49, vcc
		v_cmp_ge_u32_e64 vcc, v47, v50
		v_add_u32_e32 v49, v47, v28
		v_mov_b32_e32 v64, 16
		v_mul_lo_u32 v64, v64, v63
		v_cndmask_b32_e32 v47, v47, v49, vcc
		v_xad_u32 v49, v47, -1, 1
		v_cndmask_b32_e64 v47, v47, v49, s[26:27]
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v49, v17, -1, 1
		v_cndmask_b32_e32 v17, v17, v49, vcc
		v_mul_hi_u32 v2, v17, v2
		v_mul_lo_u32 v2, v2, v50
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v17
		v_cmp_ge_u32_e64 vcc, v2, v50
		v_add_u32_e32 v17, v2, v28
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s44, s2
		s_mov_b32 s45, s3
		s_mov_b32 s48, s4
		s_mov_b32 s49, s5
		s_mov_b32 s50, s46
		s_mov_b32 s51, s47
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_cmp_ge_u32_e64 vcc, v2, v50
		v_add_u32_e32 v17, v2, v28
		v_and_b32_e32 v28, 1, v62
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_xad_u32 v17, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v17, s[26:27]
		v_mov_b32_e32 v17, 32
		v_mul_lo_u32 v17, v17, v28
		v_bitop3_b32 v28, v65, v64, v17 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v28, s14
		v_lshlrev_b32_e32 v49, 3, v59
		v_add_lshl_u32 v50, v60, v49, 1
		v_mov_b32_e32 v63, 0x80000000
		v_cndmask_b32_e32 v50, v63, v50, vcc
		buffer_load_dwordx4 v50, s[44:47], 0 offen lds
		v_add_lshl_u32 v50, v38, v49, 1
		v_cndmask_b32_e32 v50, v63, v50, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v30, v30, v31, s[24:25]
		buffer_load_dwordx4 v50, s[44:47], 0 offen lds
		s_ashr_i32 s2, s28, 6
		v_bitop3_b32 v31, v57, v56, v10 bitop3:0x96
		v_bitop3_b32 v31, v31, v13, v55 bitop3:0x96
		v_bitop3_b32 v50, 4, v57, v56 bitop3:0x96
		v_xor_b32_e32 v50, v50, v10
		v_cmp_lt_i32_e64 vcc, v31, s14
		v_add3_u32 v56, v27, v54, v53
		v_mul_lo_u32 v57, s17, v7
		v_lshlrev_b32_e32 v57, 6, v57
		v_mul_lo_u32 v66, s17, v52
		v_lshlrev_b32_e32 v66, 5, v66
		v_add3_u32 v56, v56, v57, v66
		v_cndmask_b32_e32 v56, v63, v56, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v32, v32, v39, s[30:31]
		buffer_load_dwordx4 v56, s[48:51], 0 offen lds
		v_bitop3_b32 v13, v50, v13, v55 bitop3:0x96
		v_add3_u32 v39, v41, v57, v66
		v_cndmask_b32_e32 v39, v63, v39, vcc
		s_add_i32 m0, m0, 0x2100
		v_add3_u32 v41, v58, v57, v66
		buffer_load_dwordx4 v39, s[48:51], 0 offen lds
		s_add_i32 s3, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v28, s3
		v_add_u32_e32 v39, 64, v60
		v_add_lshl_u32 v39, v39, v49, 1
		v_cndmask_b32_e32 v39, v63, v39, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e64 v33, v33, v40, s[32:33]
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		v_add_u32_e32 v39, 64, v38
		v_add_lshl_u32 v39, v39, v49, 1
		v_cndmask_b32_e32 v39, v63, v39, vcc
		v_cmp_lt_i32_e64 vcc, v31, s3
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v34, v34, v43, s[34:35]
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		s_lshl_b32 s3, s17, 7
		v_add_u32_e32 v39, s3, v27
		v_add3_u32 v39, v39, v54, v53
		v_add3_u32 v39, v39, v57, v66
		v_cndmask_b32_e32 v39, v63, v39, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e32 v40, v63, v41, vcc
		buffer_load_dwordx4 v39, s[48:51], 0 offen lds
		v_add_u32_e32 v39, 0x80, v60
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v35, v35, v48, s[36:37]
		buffer_load_dwordx4 v40, s[48:51], 0 offen lds
		v_and_b32_e32 v40, 3, v0
		s_add_i32 s3, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v28, s3
		v_add_lshl_u32 v39, v39, v49, 1
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e32 v39, v63, v39, vcc
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		v_add_u32_e32 v38, 0x80, v38
		v_add_lshl_u32 v38, v38, v49, 1
		v_cndmask_b32_e32 v38, v63, v38, vcc
		v_cmp_lt_i32_e64 vcc, v31, s3
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s3, s17, 8
		v_add_u32_e32 v39, s3, v27
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		v_add3_u32 v38, v39, v54, v53
		v_add3_u32 v38, v38, v57, v66
		v_cndmask_b32_e32 v38, v63, v38, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_and_b32_e32 v39, 63, v0
		buffer_load_dwordx4 v38, s[48:51], 0 offen lds
		v_add3_u32 v38, v61, v57, v66
		v_cndmask_b32_e32 v38, v63, v38, vcc
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v41, 7, v14
		v_and_b32_e32 v43, 1, v62
		buffer_load_dwordx4 v38, s[48:51], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v38, 4, v39
		v_lshlrev_b32_e32 v48, 4, v38
		v_and_b32_e32 v49, 15, v39
		v_mov_b32_e32 v50, 0x420
		v_mul_lo_u32 v50, v50, v49
		v_add3_u32 v41, v41, v48, v50
		ds_read_b128 v[68:71], v41
		ds_read_b128 v[72:75], v41 offset:64
		ds_read_b128 v[76:79], v41 offset:256
		ds_read_b128 v[80:83], v41 offset:320
		ds_read_b128 v[84:87], v41 offset:512
		ds_read_b128 v[88:91], v41 offset:576
		ds_read_b128 v[92:95], v41 offset:768
		ds_read_b128 v[96:99], v41 offset:832
		v_lshlrev_b32_e32 v48, 6, v11
		v_lshl_add_u32 v40, v40, 3, v48
		v_lshl_add_u32 v40, v9, 5, v40
		v_lshlrev_b32_e32 v48, 8, v7
		v_mov_b32_e32 v49, 0x1080
		v_mul_lo_u32 v49, v49, v52
		v_add3_u32 v40, v40, v48, v49
		v_mov_b32_e32 v48, 0x420
		v_mul_lo_u32 v48, v48, v43
		v_add3_u32 v40, v40, v51, v48
		ds_read_b64_tr_b16 v[48:49], v40 offset:50656
		ds_read_b64_tr_b16 v[50:51], v40 offset:59104
		ds_read_b64_tr_b16 v[100:101], v40 offset:51168
		ds_read_b64_tr_b16 v[102:103], v40 offset:59616
		ds_read_b64_tr_b16 v[104:105], v40 offset:50784
		ds_read_b64_tr_b16 v[106:107], v40 offset:59232
		ds_read_b64_tr_b16 v[108:109], v40 offset:51296
		ds_read_b64_tr_b16 v[110:111], v40 offset:59744
		s_add_i32 s3, s2, -3
		v_cmp_ne_u32_e64 vcc, v14, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[76:77], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[76:77]
		s_setprio 0
		v_lshlrev_b32_e32 v43, 4, v59
		v_add_u32_e32 v43, 0x180, v43
		s_lshl_b32 s4, s15, 1
		v_mul_lo_u32 v26, s4, v26
		v_mul_lo_u32 v6, s4, v6
		v_add_u32_e32 v52, v43, v26
		v_add_u32_e32 v26, v43, v6
		s_mul_i32 s4, 0x180, s17
		s_mul_i32 s5, 0x188, s17
		s_cmp_lt_i32 0, s3
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
		s_mov_b32 s15, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[112:115], v[48:51], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[76:79], v[120:123]
		s_lshl_b32 s23, s22, 7
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[92:95], v[136:139]
		s_cmp_ge_u32 s15, 2
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[72:75], v[112:115]
		s_cselect_b32 s24, 1, 0
		s_add_i32 s25, s15, -2
		v_mfma_f32_16x16x32_f16 v[116:119], v[108:111], v[72:75], v[116:119]
		s_add_i32 s26, s15, 1
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s24, s25, s26
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[80:83], v[120:123]
		s_add_i32 s25, s22, 3
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[88:91], v[128:131]
		s_mul_i32 s25, s25, 64
		v_mfma_f32_16x16x32_f16 v[132:135], v[108:111], v[88:91], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[96:99], v[136:139]
		s_setprio 1
		s_barrier
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s25, s14, s25
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_mul_i32 s26, -1, s23
		s_add_i32 s26, s26, 0x80000000
		v_mov_b32_e32 v6, s26
		v_cndmask_b32_e32 v43, v6, v52, vcc
		v_cndmask_b32_e32 v6, v6, v26, vcc
		v_cmp_lt_i32_e64 vcc, v13, s25
		s_mul_i32 s15, 0x4200, s15
		s_add_i32 s15, s38, s15
		s_mov_b32 m0, s15
		v_cmp_lt_i32_e64 s[26:27], v31, s25
		buffer_load_dwordx4 v43, s[44:47], s23 offen lds
		s_mul_i32 s15, s17, s22
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s15, s15, 7
		buffer_load_dwordx4 v6, s[44:47], s23 offen lds
		s_add_i32 s23, s4, s15
		v_add_u32_e32 v6, s23, v27
		v_add3_u32 v6, v6, v54, v53
		v_add3_u32 v6, v6, v57, v66
		v_cndmask_b32_e64 v6, v63, v6, s[26:27]
		s_add_i32 m0, m0, 0xa4e0
		s_add_i32 s15, s5, s15
		v_add_u32_e32 v43, s15, v27
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		v_add3_u32 v6, v43, v54, v53
		v_add3_u32 v6, v6, v57, v66
		v_cndmask_b32_e32 v6, v63, v6, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s15, 0x4200, s24
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_barrier
		v_add_u32_e32 v6, s15, v41
		v_add_u32_e32 v43, s15, v40
		s_waitcnt vmcnt(4)
		ds_read_b128 v[68:71], v6
		ds_read_b128 v[72:75], v6 offset:64
		ds_read_b128 v[76:79], v6 offset:256
		ds_read_b128 v[80:83], v6 offset:320
		ds_read_b128 v[84:87], v6 offset:512
		ds_read_b128 v[88:91], v6 offset:576
		ds_read_b128 v[92:95], v6 offset:768
		ds_read_b128 v[96:99], v6 offset:832
		ds_read_b64_tr_b16 v[48:49], v43 offset:50656
		ds_read_b64_tr_b16 v[50:51], v43 offset:59104
		ds_read_b64_tr_b16 v[100:101], v43 offset:51168
		ds_read_b64_tr_b16 v[102:103], v43 offset:59616
		ds_read_b64_tr_b16 v[104:105], v43 offset:50784
		ds_read_b64_tr_b16 v[106:107], v43 offset:59232
		ds_read_b64_tr_b16 v[108:109], v43 offset:51296
		ds_read_b64_tr_b16 v[110:111], v43 offset:59744
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s3
		s_mov_b32 s15, s24
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[76:77], s[40:41]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[76:77]
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s46
		s_mov_b32 s27, s47
		s_mul_i32 s3, 0x108, s29
		s_add_i32 m0, s3, 0x18bc0
		v_mul_lo_u32 v6, s18, v30
		v_add_lshl_u32 v6, v16, v6, 1
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s46
		s_mov_b32 s31, s47
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v32
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v16, v6, 1
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v33
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v16, v6, 1
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v34
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v16, v6, 1
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v6, s18, v35
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v6, v16, v6, 1
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mul_lo_u32 v1, s18, v1
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v1, v16, v1, 1
		buffer_load_dword v1, s[28:31], 0 offen lds
		v_mul_lo_u32 v1, s18, v36
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v1, v16, v1, 1
		buffer_load_dword v1, s[28:31], 0 offen lds
		v_mul_lo_u32 v1, s18, v37
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v1, v16, v1, 1
		v_mul_lo_u32 v6, s18, v18
		v_add_lshl_u32 v6, v16, v6, 1
		v_mul_lo_u32 v13, s18, v19
		v_add_lshl_u32 v13, v16, v13, 1
		v_mul_lo_u32 v18, s18, v20
		v_add_lshl_u32 v18, v16, v18, 1
		v_mul_lo_u32 v19, s18, v21
		v_add_lshl_u32 v19, v16, v19, 1
		v_mul_lo_u32 v20, s18, v22
		v_add_lshl_u32 v20, v16, v20, 1
		v_mul_lo_u32 v21, s18, v23
		v_add_lshl_u32 v21, v16, v21, 1
		v_mul_lo_u32 v22, s18, v24
		v_add_lshl_u32 v22, v16, v22, 1
		v_mul_lo_u32 v23, s18, v25
		v_add_lshl_u32 v16, v16, v23, 1
		v_mfma_f32_16x16x32_f16 v[112:115], v[48:51], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		buffer_load_dword v1, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[76:79], v[120:123]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[92:95], v[136:139]
		buffer_load_dword v6, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[108:111], v[72:75], v[116:119]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[80:83], v[120:123]
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[88:91], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[108:111], v[88:91], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[96:99], v[136:139]
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v1, 1, v7
		buffer_load_dword v18, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v6, 2, v9
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v7, 3, v11
		buffer_load_dword v19, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v9, 8, v14
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v11, 1, v29
		buffer_load_dword v20, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v13, 1, v42
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v14, 1, v44
		buffer_load_dword v21, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v18, 1, v45
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v19, 1, v46
		v_lshlrev_b32_e32 v20, 1, v47
		v_lshlrev_b32_e32 v2, 1, v2
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v8
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v12
		buffer_load_dword v22, s[28:31], 0 offen lds
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v15
		s_add_i32 m0, m0, 0x840
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v3
		v_xad_u32 v3, v28, v15, s20
		s_add_i32 s3, s2, -2
		buffer_load_dword v16, s[28:31], 0 offen lds
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s4, 1, 0
		s_xor_b32 s5, s3, -1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s3, s5, s3
		s_mul_hi_u32 s4, s3, 0xaaaaaaab
		s_cselect_b32 s5, 1, 0
		s_lshr_b32 s4, s4, 1
		s_mul_i32 s4, s4, 3
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s3, s3, s4
		s_xor_b32 s4, s3, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s3, s4, s3
		v_cmp_lt_i32_e64 s[4:5], v3, s13
		s_mul_i32 s3, 0x4200, s3
		s_add_i32 s2, s2, -1
		s_cmp_lt_i32 s2, 0
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s46
		s_mov_b32 s11, s47
		buffer_load_ushort v3, v27, s[8:11], 0 offen
		buffer_load_ushort v16, v11, s[8:11], 0 offen
		s_waitcnt vmcnt(2)
		s_barrier
		buffer_load_ushort v11, v13, s[8:11], 0 offen
		buffer_load_ushort v13, v14, s[8:11], 0 offen
		buffer_load_ushort v14, v18, s[8:11], 0 offen
		buffer_load_ushort v18, v19, s[8:11], 0 offen
		buffer_load_ushort v19, v20, s[8:11], 0 offen
		buffer_load_ushort v20, v2, s[8:11], 0 offen
		v_add_u32_e32 v2, s3, v41
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:64
		ds_read_b128 v[32:35], v2 offset:256
		ds_read_b128 v[44:47], v2 offset:320
		ds_read_b128 v[48:51], v2 offset:512
		ds_read_b128 v[52:55], v2 offset:576
		ds_read_b128 v[56:59], v2 offset:768
		ds_read_b128 v[60:63], v2 offset:832
		v_add_u32_e32 v2, s3, v40
		ds_read_b64_tr_b16 v[68:69], v2 offset:50656
		ds_read_b64_tr_b16 v[70:71], v2 offset:59104
		ds_read_b64_tr_b16 v[72:73], v2 offset:51168
		ds_read_b64_tr_b16 v[74:75], v2 offset:59616
		ds_read_b64_tr_b16 v[76:77], v2 offset:50784
		ds_read_b64_tr_b16 v[78:79], v2 offset:59232
		ds_read_b64_tr_b16 v[80:81], v2 offset:51296
		ds_read_b64_tr_b16 v[82:83], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[32:35], v[120:123]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[24:27], v[116:119]
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s6, s2, -1
		s_add_i32 s6, s6, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s6, s2
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[32:35], v[124:127]
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_cselect_b32 s6, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[48:51], v[128:131]
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[48:51], v[132:135]
		s_xor_b32 s3, s2, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s6, 0
		s_cselect_b32 s2, s3, s2
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[56:59], v[140:143]
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v2, s2, v41
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[28:31], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[60:63], v[136:139]
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:64
		ds_read_b128 v[32:35], v2 offset:256
		ds_read_b128 v[44:47], v2 offset:320
		ds_read_b128 v[48:51], v2 offset:512
		ds_read_b128 v[52:55], v2 offset:576
		ds_read_b128 v[56:59], v2 offset:768
		ds_read_b128 v[60:63], v2 offset:832
		v_add_u32_e32 v2, s2, v40
		ds_read_b64_tr_b16 v[40:41], v2 offset:50656
		ds_read_b64_tr_b16 v[42:43], v2 offset:59104
		ds_read_b64_tr_b16 v[68:69], v2 offset:51168
		ds_read_b64_tr_b16 v[70:71], v2 offset:59616
		ds_read_b64_tr_b16 v[72:73], v2 offset:50784
		ds_read_b64_tr_b16 v[74:75], v2 offset:59232
		ds_read_b64_tr_b16 v[76:77], v2 offset:51296
		ds_read_b64_tr_b16 v[78:79], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[40:43], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[32:35], v[120:123]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[32:35], v[124:127]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], v[40:43], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[40:43], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[60:63], v[136:139]
		v_xor_b32_e32 v2, v6, v7
		v_bitop3_b32 v1, v0, v1, v2 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v1
		ds_write_b128 v2, v[112:115]
		v_xor_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 4, v1
		ds_write_b128 v1, v[116:119] offset:8192
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v22, v3
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v23, v16
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v24, v11
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v25, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v3, 3, v39
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v11, 13, v3
		v_add3_u32 v13, v9, v38, v7
		v_and_b32_e32 v16, 7, v39
		v_lshlrev_b32_e32 v26, 5, v16
		v_add3_u32 v13, v13, v6, v26
		v_and_b32_e32 v27, 1, v0
		v_lshlrev_b32_e32 v27, 1, v27
		v_lshrrev_b32_e32 v28, 1, v39
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 2, v28
		v_lshrrev_b32_e32 v16, 2, v16
		v_lshlrev_b32_e32 v16, 3, v16
		v_xor_b32_e32 v3, v16, v3
		v_bitop3_b32 v3, v27, v28, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v3
		v_lshl_add_u32 v13, v13, 4, v11
		ds_read_b128 v[28:31], v13
		v_add_u32_e32 v9, 16, v9
		v_add3_u32 v7, v9, v38, v7
		v_add3_u32 v6, v7, v6, v26
		v_xor_b32_e32 v3, v6, v3
		v_lshl_add_u32 v3, v3, 4, v11
		ds_read_b128 v[32:35], v3
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v6, v14
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v7, v18
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v26, v19
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v27, v20
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[120:123]
		ds_write_b128 v1, v[124:127] offset:8192
		v_pk_add_f32 v[18:19], v[28:29], v[22:23]
		v_pk_add_f32 v[28:29], v[30:31], v[24:25]
		v_pk_add_f32 v[30:31], v[32:33], v[6:7]
		v_pk_add_f32 v[32:33], v[34:35], v[26:27]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v13
		ds_read_b128 v[40:43], v3
		v_bitop3_b32 v9, v5, v21, v8 bitop3:0x96
		v_xor_b32_e32 v9, v9, v10
		v_xad_u32 v9, v9, v12, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[34:35], v[36:37], v[22:23]
		v_cmp_lt_i32_e64 s[2:3], v9, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[128:131]
		ds_write_b128 v1, v[132:135] offset:8192
		v_pk_add_f32 v[36:37], v[38:39], v[24:25]
		v_pk_add_f32 v[38:39], v[40:41], v[6:7]
		v_pk_add_f32 v[40:41], v[42:43], v[26:27]
		s_and_b64 s[6:7], s[2:3], s[4:5]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v13
		ds_read_b128 v[48:51], v3
		v_bitop3_b32 v9, 1, v65, v64 bitop3:0x96
		v_xor_b32_e32 v9, v9, v17
		v_xad_u32 v9, v9, v15, s20
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[42:43], v[44:45], v[22:23]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[136:139]
		ds_write_b128 v1, v[140:143] offset:8192
		v_cmp_lt_i32_e64 s[8:9], v9, s13
		v_pk_add_f32 v[44:45], v[46:47], v[24:25]
		v_pk_add_f32 v[46:47], v[48:49], v[6:7]
		v_pk_add_f32 v[48:49], v[50:51], v[26:27]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[52:55], v13
		ds_read_b128 v[56:59], v3
		s_and_b64 s[10:11], s[2:3], s[8:9]
		v_bitop3_b32 v1, 2, v65, v64 bitop3:0x96
		v_xor_b32_e32 v1, v1, v17
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[2:3], v[52:53], v[22:23]
		v_pk_add_f32 v[22:23], v[54:55], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[6:7], v[56:57], v[6:7]
		v_pk_add_f32 v[24:25], v[58:59], v[26:27]
		v_bitop3_b32 v9, 3, v65, v64 bitop3:0x96
		v_xor_b32_e32 v9, v9, v17
		v_bitop3_b32 v11, 4, v65, v64 bitop3:0x96
		v_xor_b32_e32 v11, v11, v17
		v_bitop3_b32 v13, 5, v65, v64 bitop3:0x96
		v_xor_b32_e32 v13, v13, v17
		v_bitop3_b32 v14, 6, v65, v64 bitop3:0x96
		v_xor_b32_e32 v14, v14, v17
		v_bitop3_b32 v16, 7, v65, v64 bitop3:0x96
		v_xor_b32_e32 v16, v16, v17
		v_bitop3_b32 v17, 32, v5, v21 bitop3:0x96
		v_bitop3_b32 v17, v17, v8, v10 bitop3:0x96
		v_bitop3_b32 v20, 64, v5, v21 bitop3:0x96
		v_bitop3_b32 v20, v20, v8, v10 bitop3:0x96
		v_xor_b32_e32 v5, 0x60, v5
		v_xor_b32_e32 v5, v5, v21
		v_xor_b32_e32 v5, v5, v8
		v_xor_b32_e32 v5, v5, v10
		v_lshlrev_b32_e32 v8, 4, v0
		v_add_u32_e32 v8, 0x10000, v8
		v_lshl_add_u32 v8, v4, 3, v8
		ds_read_u16 v10, v8 offset:35776
		ds_read_u16 v21, v8 offset:35778
		ds_read_u16 v26, v8 offset:35780
		ds_read_u16 v27, v8 offset:35782
		ds_read_u16 v50, v8 offset:35784
		ds_read_u16 v51, v8 offset:35786
		ds_read_u16 v52, v8 offset:35788
		ds_read_u16 v53, v8 offset:35790
		v_mov_b32_e32 v8, 0x108
		v_mul_lo_u32 v8, v8, v4
		v_add_u32_e32 v8, 0x10000, v8
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v8, v8, v0
		ds_read_u16 v54, v8 offset:44224
		ds_read_u16 v55, v8 offset:44226
		ds_read_u16 v56, v8 offset:44228
		ds_read_u16 v57, v8 offset:44230
		ds_read_u16 v58, v8 offset:44232
		ds_read_u16 v59, v8 offset:44234
		ds_read_u16 v60, v8 offset:44236
		ds_read_u16 v61, v8 offset:44238
		ds_read_u16 v62, v8 offset:52672
		ds_read_u16 v63, v8 offset:52674
		ds_read_u16 v64, v8 offset:52676
		ds_read_u16 v65, v8 offset:52678
		ds_read_u16 v66, v8 offset:52680
		ds_read_u16 v67, v8 offset:52682
		ds_read_u16 v68, v8 offset:52684
		ds_read_u16 v69, v8 offset:52686
		ds_read_u16 v70, v8 offset:61120
		ds_read_u16 v71, v8 offset:61122
		ds_read_u16 v72, v8 offset:61124
		ds_read_u16 v73, v8 offset:61126
		ds_read_u16 v74, v8 offset:61128
		ds_read_u16 v75, v8 offset:61130
		ds_read_u16 v76, v8 offset:61132
		ds_read_u16 v77, v8 offset:61134
		s_waitcnt lgkmcnt(14)
		v_cvt_f32_f16_e32 v78, v10
		v_cvt_f32_f16_e32 v79, v21
		v_pk_fma_f32 v[80:81], v[18:19], v[78:79], v[18:19]
		v_cvt_f32_f16_e32 v18, v26
		v_cvt_f32_f16_e32 v19, v27
		v_pk_fma_f32 v[26:27], v[28:29], v[18:19], v[28:29]
		v_cvt_f32_f16_e32 v18, v50
		v_cvt_f32_f16_e32 v19, v51
		v_pk_fma_f32 v[28:29], v[30:31], v[18:19], v[30:31]
		v_cvt_f32_f16_e32 v18, v52
		v_cvt_f32_f16_e32 v19, v53
		v_pk_fma_f32 v[30:31], v[32:33], v[18:19], v[32:33]
		v_cvt_f32_f16_e32 v18, v54
		v_cvt_f32_f16_e32 v19, v55
		v_pk_fma_f32 v[32:33], v[34:35], v[18:19], v[34:35]
		v_cvt_f32_f16_e32 v18, v56
		v_cvt_f32_f16_e32 v19, v57
		v_cvt_f32_f16_e32 v34, v58
		v_cvt_f32_f16_e32 v35, v59
		v_cvt_f32_f16_e32 v50, v60
		v_cvt_f32_f16_e32 v51, v61
		v_cvt_f32_f16_e32 v52, v62
		v_cvt_f32_f16_e32 v53, v63
		s_waitcnt lgkmcnt(13)
		v_cvt_f32_f16_e32 v54, v64
		s_waitcnt lgkmcnt(12)
		v_cvt_f32_f16_e32 v55, v65
		s_waitcnt lgkmcnt(11)
		v_cvt_f32_f16_e32 v56, v66
		s_waitcnt lgkmcnt(10)
		v_cvt_f32_f16_e32 v57, v67
		s_waitcnt lgkmcnt(9)
		v_cvt_f32_f16_e32 v58, v68
		s_waitcnt lgkmcnt(8)
		v_cvt_f32_f16_e32 v59, v69
		s_waitcnt lgkmcnt(7)
		v_cvt_f32_f16_e32 v60, v70
		s_waitcnt lgkmcnt(6)
		v_cvt_f32_f16_e32 v61, v71
		s_waitcnt lgkmcnt(5)
		v_cvt_f32_f16_e32 v62, v72
		s_waitcnt lgkmcnt(4)
		v_cvt_f32_f16_e32 v63, v73
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v64, v74
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v65, v75
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v66, v76
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v67, v77
		v_pk_fma_f32 v[68:69], v[36:37], v[18:19], v[36:37]
		v_pk_fma_f32 v[18:19], v[38:39], v[34:35], v[38:39]
		v_pk_fma_f32 v[34:35], v[40:41], v[50:51], v[40:41]
		v_pk_fma_f32 v[36:37], v[42:43], v[52:53], v[42:43]
		v_pk_fma_f32 v[38:39], v[44:45], v[54:55], v[44:45]
		v_pk_fma_f32 v[40:41], v[46:47], v[56:57], v[46:47]
		v_pk_fma_f32 v[42:43], v[48:49], v[58:59], v[48:49]
		v_pk_fma_f32 v[44:45], v[2:3], v[60:61], v[2:3]
		v_pk_fma_f32 v[2:3], v[22:23], v[62:63], v[22:23]
		v_pk_fma_f32 v[22:23], v[6:7], v[64:65], v[6:7]
		v_pk_fma_f32 v[6:7], v[24:25], v[66:67], v[24:25]
		v_xad_u32 v8, v17, v12, s16
		v_xad_u32 v10, v20, v12, s16
		v_xad_u32 v5, v5, v12, s16
		v_cmp_lt_i32_e64 s[14:15], v8, s12
		v_cmp_lt_i32_e64 s[16:17], v10, s12
		v_cmp_lt_i32_e64 s[22:23], v5, s12
		v_xad_u32 v1, v1, v15, s20
		v_xad_u32 v5, v9, v15, s20
		v_xad_u32 v8, v11, v15, s20
		v_xad_u32 v9, v13, v15, s20
		v_xad_u32 v10, v14, v15, s20
		v_xad_u32 v11, v16, v15, s20
		v_cmp_lt_i32_e64 s[28:29], v1, s13
		v_cmp_lt_i32_e64 s[30:31], v5, s13
		v_cmp_lt_i32_e64 s[32:33], v8, s13
		v_cmp_lt_i32_e64 s[34:35], v9, s13
		v_cmp_lt_i32_e64 s[36:37], v10, s13
		v_cmp_lt_i32_e64 s[38:39], v11, s13
		s_and_b64 s[12:13], s[2:3], s[28:29]
		s_and_b64 s[40:41], s[2:3], s[30:31]
		s_and_b64 s[42:43], s[2:3], s[32:33]
		s_and_b64 s[44:45], s[2:3], s[34:35]
		s_and_b64 s[46:47], s[2:3], s[36:37]
		s_and_b64 s[2:3], s[2:3], s[38:39]
		s_and_b64 s[48:49], s[14:15], s[4:5]
		s_and_b64 s[50:51], s[14:15], s[8:9]
		s_and_b64 s[52:53], s[14:15], s[28:29]
		s_and_b64 s[54:55], s[14:15], s[30:31]
		s_and_b64 s[56:57], s[14:15], s[32:33]
		s_and_b64 s[58:59], s[14:15], s[34:35]
		s_and_b64 s[60:61], s[14:15], s[36:37]
		s_and_b64 s[14:15], s[14:15], s[38:39]
		s_and_b64 s[62:63], s[16:17], s[4:5]
		s_and_b64 s[64:65], s[16:17], s[8:9]
		s_and_b64 s[66:67], s[16:17], s[28:29]
		s_and_b64 s[68:69], s[16:17], s[30:31]
		s_and_b64 s[70:71], s[16:17], s[32:33]
		s_and_b64 s[72:73], s[16:17], s[34:35]
		s_and_b64 s[74:75], s[16:17], s[36:37]
		s_and_b64 s[16:17], s[16:17], s[38:39]
		s_and_b64 s[4:5], s[22:23], s[4:5]
		s_and_b64 s[8:9], s[22:23], s[8:9]
		s_and_b64 s[28:29], s[22:23], s[28:29]
		s_and_b64 s[30:31], s[22:23], s[30:31]
		s_and_b64 s[32:33], s[22:23], s[32:33]
		s_and_b64 s[34:35], s[22:23], s[34:35]
		s_and_b64 s[36:37], s[22:23], s[36:37]
		s_and_b64 s[22:23], s[22:23], s[38:39]
		v_cvt_f16_f32_e64 v1, v80
		v_cvt_f16_f32_e64 v5, v81
		v_cvt_f16_f32_e64 v8, v26
		v_cvt_f16_f32_e64 v9, v27
		v_cvt_f16_f32_e64 v10, v28
		v_cvt_f16_f32_e64 v11, v29
		v_cvt_f16_f32_e64 v12, v30
		v_cvt_f16_f32_e64 v13, v31
		v_cvt_f16_f32_e64 v14, v32
		v_cvt_f16_f32_e64 v15, v33
		v_cvt_f16_f32_e64 v16, v68
		v_cvt_f16_f32_e64 v17, v69
		v_cvt_f16_f32_e64 v18, v18
		v_cvt_f16_f32_e64 v19, v19
		v_cvt_f16_f32_e64 v20, v34
		v_cvt_f16_f32_e64 v21, v35
		v_cvt_f16_f32_e64 v24, v36
		v_cvt_f16_f32_e64 v25, v37
		v_cvt_f16_f32_e64 v26, v38
		v_cvt_f16_f32_e64 v27, v39
		v_cvt_f16_f32_e64 v28, v40
		v_cvt_f16_f32_e64 v29, v41
		v_cvt_f16_f32_e64 v30, v42
		v_cvt_f16_f32_e64 v31, v43
		v_cvt_f16_f32_e64 v32, v44
		v_cvt_f16_f32_e64 v33, v45
		v_cvt_f16_f32_e64 v2, v2
		v_cvt_f16_f32_e64 v3, v3
		v_cvt_f16_f32_e64 v22, v22
		v_cvt_f16_f32_e64 v23, v23
		v_cvt_f16_f32_e64 v6, v6
		v_cvt_f16_f32_e64 v7, v7
		s_lshl_b32 s0, s0, 8
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 10
		s_add_i32 s18, s0, s1
		s_mul_i32 s20, s21, s19
		s_lshl_b32 s20, s20, 8
		s_add_i32 s18, s18, s20
		v_mul_lo_u32 v4, s19, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add3_u32 v34, s18, v4, v0
		s_and_saveexec_b64 s[76:77], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_2
		buffer_store_short v1, v34, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_2:
		s_andn2_b64 exec, s[76:77], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s6, s0, 2
		s_add_i32 s7, s6, s1
		s_add_i32 s7, s7, s20
		v_add3_u32 v1, s7, v4, v0
		s_and_saveexec_b64 s[76:77], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_3
		buffer_store_short v5, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_3:
		s_andn2_b64 exec, s[76:77], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s7, s0, 4
		s_add_i32 s10, s7, s1
		s_add_i32 s10, s10, s20
		v_add3_u32 v1, s10, v4, v0
		s_and_saveexec_b64 s[76:77], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_4
		buffer_store_short v8, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_4:
		s_andn2_b64 exec, s[76:77], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s10, s0, 6
		s_add_i32 s11, s10, s1
		s_add_i32 s11, s11, s20
		v_add3_u32 v1, s11, v4, v0
		s_and_saveexec_b64 s[76:77], s[40:41]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_5
		buffer_store_short v9, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_5:
		s_andn2_b64 exec, s[76:77], s[40:41]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s11, s0, 8
		s_add_i32 s12, s11, s1
		s_add_i32 s12, s12, s20
		v_add3_u32 v1, s12, v4, v0
		s_and_saveexec_b64 s[76:77], s[42:43]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_6
		buffer_store_short v10, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_6:
		s_andn2_b64 exec, s[76:77], s[42:43]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_6
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_6:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s12, s0, 10
		s_add_i32 s13, s12, s1
		s_add_i32 s13, s13, s20
		v_add3_u32 v1, s13, v4, v0
		s_and_saveexec_b64 s[76:77], s[44:45]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_7
		buffer_store_short v11, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_7:
		s_andn2_b64 exec, s[76:77], s[44:45]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_7
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_7:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s13, s0, 12
		s_add_i32 s18, s13, s1
		s_add_i32 s18, s18, s20
		v_add3_u32 v1, s18, v4, v0
		s_and_saveexec_b64 s[76:77], s[46:47]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_8
		buffer_store_short v12, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_8:
		s_andn2_b64 exec, s[76:77], s[46:47]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_8
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_8:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s18, s0, 14
		s_add_i32 s21, s18, s1
		s_add_i32 s21, s21, s20
		v_add3_u32 v1, s21, v4, v0
		s_and_saveexec_b64 s[76:77], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_9
		buffer_store_short v13, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_9:
		s_andn2_b64 exec, s[76:77], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_9
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_9:
		s_mov_b64 exec, s[76:77]
		s_lshl_b32 s2, s19, 6
		s_add_i32 s3, s0, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[48:49]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_10
		buffer_store_short v14, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_10:
		s_andn2_b64 exec, s[76:77], s[48:49]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_10
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_10:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s6, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[50:51]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_11
		buffer_store_short v15, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_11:
		s_andn2_b64 exec, s[76:77], s[50:51]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_11
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_11:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s7, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[52:53]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_12
		buffer_store_short v16, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_12:
		s_andn2_b64 exec, s[76:77], s[52:53]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_12
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_12:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s10, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[54:55]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_13
		buffer_store_short v17, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_13:
		s_andn2_b64 exec, s[76:77], s[54:55]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_13
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_13:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s11, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[56:57]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_14
		buffer_store_short v18, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_14:
		s_andn2_b64 exec, s[76:77], s[56:57]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_14
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_14:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s12, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[58:59]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_15
		buffer_store_short v19, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_15:
		s_andn2_b64 exec, s[76:77], s[58:59]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_15
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_15:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s13, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[60:61]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_16
		buffer_store_short v20, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_16:
		s_andn2_b64 exec, s[76:77], s[60:61]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_16
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_16:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s2, s18, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s20
		v_add3_u32 v1, s2, v4, v0
		s_and_saveexec_b64 s[76:77], s[14:15]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_17
		buffer_store_short v21, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_17:
		s_andn2_b64 exec, s[76:77], s[14:15]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_17
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_17:
		s_mov_b64 exec, s[76:77]
		s_lshl_b32 s2, s19, 7
		s_add_i32 s3, s0, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[62:63]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_18
		buffer_store_short v24, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_18:
		s_andn2_b64 exec, s[76:77], s[62:63]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_18
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_18:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s6, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[64:65]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_19
		buffer_store_short v25, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_19:
		s_andn2_b64 exec, s[76:77], s[64:65]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_19
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_19:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s7, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_20
		buffer_store_short v26, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_20:
		s_andn2_b64 exec, s[76:77], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_20
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_20:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s10, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_21
		buffer_store_short v27, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_21:
		s_andn2_b64 exec, s[76:77], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_21
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_21:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s11, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_22
		buffer_store_short v28, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_22:
		s_andn2_b64 exec, s[76:77], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_22
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_22:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s12, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_23
		buffer_store_short v29, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_23:
		s_andn2_b64 exec, s[76:77], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_23
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_23:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s3, s13, s2
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s20
		v_add3_u32 v1, s3, v4, v0
		s_and_saveexec_b64 s[76:77], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_24
		buffer_store_short v30, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_24:
		s_andn2_b64 exec, s[76:77], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_24
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_24:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s2, s18, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s20
		v_add3_u32 v1, s2, v4, v0
		s_and_saveexec_b64 s[76:77], s[16:17]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_25
		buffer_store_short v31, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_25:
		s_andn2_b64 exec, s[76:77], s[16:17]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_25
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_25:
		s_mov_b64 exec, s[76:77]
		s_mul_i32 s2, 0xc0, s19
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_26
		buffer_store_short v32, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_26:
		s_andn2_b64 exec, s[76:77], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_26
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_26:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s6, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_27
		buffer_store_short v33, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_27:
		s_andn2_b64 exec, s[76:77], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_27
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_27:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s7, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_28
		buffer_store_short v2, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_28:
		s_andn2_b64 exec, s[76:77], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_28
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_28:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s10, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_29
		buffer_store_short v3, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_29:
		s_andn2_b64 exec, s[76:77], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_29
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_29:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s11, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[32:33]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_30
		buffer_store_short v22, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_30:
		s_andn2_b64 exec, s[76:77], s[32:33]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_30
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_30:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s12, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_31
		buffer_store_short v23, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_31:
		s_andn2_b64 exec, s[76:77], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_31
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_31:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s13, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v1, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[36:37]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_32
		buffer_store_short v6, v1, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_32:
		s_andn2_b64 exec, s[76:77], s[36:37]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_32
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_32:
		s_mov_b64 exec, s[76:77]
		s_add_i32 s0, s18, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v0, s0, v4, v0
		s_and_saveexec_b64 s[76:77], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_33
		buffer_store_short v7, v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_33:
		s_andn2_b64 exec, s[76:77], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_33
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_33:
		s_mov_b64 exec, s[76:77]
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
		.amdhsa_next_free_vgpr 144
		.amdhsa_next_free_sgpr 78
		.amdhsa_accum_offset 144
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_vgpr, 144
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 78
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
    .sgpr_count:     78
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized_async.kd
    .uses_dynamic_stack: false
    .vgpr_count:     144
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
