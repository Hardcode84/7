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
		v_mad_u32_u24 v16, v16, 8, s20
		v_mad_u32_u24 v17, v17, 2, s20
		v_cndmask_b32_e32 v33, v33, v40, vcc
		v_add_u32_e32 v40, v33, v29
		v_cmp_ge_u32_e64 vcc, v33, v27
		v_and_b32_e32 v11, 1, v11
		v_and_b32_e32 v7, 1, v7
		v_cndmask_b32_e32 v33, v33, v40, vcc
		v_xad_u32 v40, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v41, v34, -1, 1
		v_cndmask_b32_e32 v34, v34, v41, vcc
		v_mul_hi_u32 v41, v34, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v34, 1, v41, v34
		v_add_u32_e32 v41, v34, v29
		v_cmp_ge_u32_e64 vcc, v34, v27
		s_mov_b32 s38, 0x7fffffff
		s_xor_b32 s23, s13, -1
		v_cndmask_b32_e32 v34, v34, v41, vcc
		v_add_u32_e32 v41, v34, v29
		v_cmp_ge_u32_e64 vcc, v34, v27
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s36, s26, s28
		s_cselect_b32 s37, s27, s29
		v_cndmask_b32_e32 v34, v34, v41, vcc
		v_xad_u32 v41, v34, -1, 1
		v_cndmask_b32_e64 v34, v34, v41, s[34:35]
		v_cmp_lt_i32_e64 vcc, v35, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v35, -1, 1
		v_cndmask_b32_e32 v35, v35, v41, vcc
		v_mul_hi_u32 v41, v35, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v35, 1, v41, v35
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v41, v35, v29
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v42, s23
		v_cndmask_b32_e32 v35, v35, v41, vcc
		v_cmp_ge_u32_e64 vcc, v35, v27
		v_add_u32_e32 v41, v35, v29
		v_mov_b32_e32 v43, 8
		v_mul_lo_u32 v43, v43, v15
		v_cndmask_b32_e32 v35, v35, v41, vcc
		v_xad_u32 v41, v35, -1, 1
		v_cndmask_b32_e64 v35, v35, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v36, -1, 1
		v_cndmask_b32_e32 v36, v36, v41, vcc
		v_mul_hi_u32 v41, v36, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v36, 1, v41, v36
		v_cmp_ge_u32_e64 vcc, v36, v27
		v_add_u32_e32 v41, v36, v29
		s_mov_b32 s23, 63
		v_cndmask_b32_e32 v36, v36, v41, vcc
		v_cmp_ge_u32_e64 vcc, v36, v27
		v_add_u32_e32 v41, v36, v29
		v_mov_b32_e32 v44, 32
		v_mul_lo_u32 v44, v44, v8
		v_cndmask_b32_e32 v36, v36, v41, vcc
		v_xad_u32 v41, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v37, -1, 1
		v_cndmask_b32_e32 v37, v37, v41, vcc
		v_mul_hi_u32 v41, v37, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v37, 1, v41, v37
		v_cmp_ge_u32_e64 vcc, v37, v27
		v_add_u32_e32 v41, v37, v29
		s_add_i32 s28, s14, 63
		v_cndmask_b32_e32 v37, v37, v41, vcc
		v_cmp_ge_u32_e64 vcc, v37, v27
		v_add_u32_e32 v41, v37, v29
		v_mov_b32_e32 v45, 16
		v_mul_lo_u32 v45, v45, v5
		v_cndmask_b32_e32 v37, v37, v41, vcc
		v_xad_u32 v41, v37, -1, 1
		v_cndmask_b32_e64 v37, v37, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v38, -1, 1
		v_cndmask_b32_e32 v38, v38, v41, vcc
		v_mul_hi_u32 v41, v38, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v38, 1, v41, v38
		v_cmp_ge_u32_e64 vcc, v38, v27
		v_add_u32_e32 v41, v38, v29
		s_cmp_lt_i32 s28, 0
		v_cndmask_b32_e32 v38, v38, v41, vcc
		v_cmp_ge_u32_e64 vcc, v38, v27
		v_add_u32_e32 v41, v38, v29
		v_mul_lo_u32 v46, s15, v6
		v_cndmask_b32_e32 v38, v38, v41, vcc
		v_xad_u32 v41, v38, -1, 1
		v_cndmask_b32_e64 v38, v38, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v18, -1, 1
		v_cndmask_b32_e32 v18, v18, v41, vcc
		v_mul_hi_u32 v41, v18, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v18, 1, v41, v18
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v41, v18, v29
		s_cselect_b32 s23, s23, 0
		s_add_i32 s23, s28, s23
		v_cndmask_b32_e32 v18, v18, v41, vcc
		v_cmp_ge_u32_e64 vcc, v18, v27
		v_add_u32_e32 v41, v18, v29
		v_and_b32_e32 v47, 1, v0
		v_cndmask_b32_e32 v18, v18, v41, vcc
		v_xad_u32 v41, v18, -1, 1
		v_cndmask_b32_e64 v18, v18, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v19, -1, 1
		v_cndmask_b32_e32 v19, v19, v41, vcc
		v_mul_hi_u32 v41, v19, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v19, 1, v41, v19
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v41, v19, v29
		v_lshlrev_b32_e32 v47, 4, v47
		v_cndmask_b32_e32 v19, v19, v41, vcc
		v_cmp_ge_u32_e64 vcc, v19, v27
		v_add_u32_e32 v41, v19, v29
		v_mul_lo_u32 v48, s15, v26
		v_cndmask_b32_e32 v19, v19, v41, vcc
		v_xad_u32 v41, v19, -1, 1
		v_cndmask_b32_e64 v19, v19, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v20, -1, 1
		v_cndmask_b32_e32 v20, v20, v41, vcc
		v_mul_hi_u32 v41, v20, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v20, 1, v41, v20
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v41, v20, v29
		v_lshl_add_u32 v48, v48, 1, v47
		v_cndmask_b32_e32 v20, v20, v41, vcc
		v_cmp_ge_u32_e64 vcc, v20, v27
		v_add_u32_e32 v41, v20, v29
		v_lshl_add_u32 v46, v46, 1, v47
		v_cndmask_b32_e32 v20, v20, v41, vcc
		v_xad_u32 v41, v20, -1, 1
		v_cndmask_b32_e64 v20, v20, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v21, -1, 1
		v_cndmask_b32_e32 v21, v21, v41, vcc
		v_mul_hi_u32 v41, v21, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v21, 1, v41, v21
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v41, v21, v29
		v_readfirstlane_b32 s28, v0
		v_cndmask_b32_e32 v21, v21, v41, vcc
		v_cmp_ge_u32_e64 vcc, v21, v27
		v_add_u32_e32 v41, v21, v29
		v_lshrrev_b32_e32 v49, 2, v0
		v_cndmask_b32_e32 v21, v21, v41, vcc
		v_xad_u32 v41, v21, -1, 1
		v_cndmask_b32_e64 v21, v21, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v22, -1, 1
		v_cndmask_b32_e32 v22, v22, v41, vcc
		v_mul_hi_u32 v41, v22, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v22, 1, v41, v22
		v_cmp_ge_u32_e64 vcc, v22, v27
		v_add_u32_e32 v41, v22, v29
		s_lshr_b32 s28, s28, 6
		v_cndmask_b32_e32 v22, v22, v41, vcc
		v_cmp_ge_u32_e64 vcc, v22, v27
		v_add_u32_e32 v41, v22, v29
		v_lshrrev_b32_e32 v50, 1, v0
		v_cndmask_b32_e32 v22, v22, v41, vcc
		v_xad_u32 v41, v22, -1, 1
		v_cndmask_b32_e64 v22, v22, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v23, -1, 1
		v_cndmask_b32_e32 v23, v23, v41, vcc
		v_mul_hi_u32 v41, v23, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v23, 1, v41, v23
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v41, v23, v29
		s_mul_i32 s29, 0x420, s28
		v_cndmask_b32_e32 v23, v23, v41, vcc
		v_cmp_ge_u32_e64 vcc, v23, v27
		v_add_u32_e32 v41, v23, v29
		v_and_b32_e32 v51, 1, v0
		v_cndmask_b32_e32 v23, v23, v41, vcc
		v_xad_u32 v41, v23, -1, 1
		v_cndmask_b32_e64 v23, v23, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v24, -1, 1
		v_cndmask_b32_e32 v24, v24, v41, vcc
		v_mul_hi_u32 v41, v24, v28
		v_mul_lo_u32 v41, v41, v27
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v24, 1, v41, v24
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v41, v24, v29
		v_mov_b32_e32 v52, 8
		v_mul_lo_u32 v52, v52, v51
		v_cndmask_b32_e32 v24, v24, v41, vcc
		v_cmp_ge_u32_e64 vcc, v24, v27
		v_add_u32_e32 v41, v24, v29
		v_mov_b32_e32 v51, s13
		v_cndmask_b32_e64 v42, v51, v42, s[36:37]
		v_cndmask_b32_e32 v24, v24, v41, vcc
		v_xad_u32 v41, v24, -1, 1
		v_cndmask_b32_e64 v24, v24, v41, s[26:27]
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v41, v25, -1, 1
		v_cndmask_b32_e32 v25, v25, v41, vcc
		v_mul_hi_u32 v28, v25, v28
		v_mul_lo_u32 v28, v28, v27
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v25, 1, v28, v25
		v_cmp_ge_u32_e64 vcc, v25, v27
		v_add_u32_e32 v28, v25, v29
		s_mov_b32 m0, s29
		v_cndmask_b32_e32 v25, v25, v28, vcc
		v_cmp_ge_u32_e64 vcc, v25, v27
		v_add_u32_e32 v27, v25, v29
		v_cmp_eq_u32_e64 s[34:35], v14, s22
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_xad_u32 v27, v25, -1, 1
		v_cndmask_b32_e64 v25, v25, v27, s[26:27]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v27, v16, -1, 1
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_cvt_f32_u32_e32 v27, v42
		v_rcp_iflag_f32_e32 v27, v27
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s40, s4
		s_mov_b32 s41, s5
		s_mov_b32 s42, s38
		s_mov_b32 s43, s39
		v_mul_f32_e32 v2, v2, v27
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v27, v42, -1, 1
		v_mul_lo_u32 v28, v27, v2
		v_mul_hi_u32 v28, v2, v28
		v_add_u32_e32 v2, v2, v28
		v_mul_hi_u32 v28, v16, v2
		v_mul_lo_u32 v28, v28, v42
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v16, 1, v28, v16
		v_cmp_ge_u32_e64 vcc, v16, v42
		v_add_u32_e32 v28, v16, v27
		v_xad_u32 v29, v17, -1, 1
		v_cndmask_b32_e32 v16, v16, v28, vcc
		v_cmp_ge_u32_e64 vcc, v16, v42
		v_add_u32_e32 v28, v16, v27
		v_and_b32_e32 v41, 1, v50
		v_cndmask_b32_e32 v16, v16, v28, vcc
		v_xad_u32 v28, v16, -1, 1
		v_cndmask_b32_e64 v16, v16, v28, s[26:27]
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[2:3], vcc
		v_mov_b32_e32 v28, 16
		v_mul_lo_u32 v28, v28, v41
		v_cndmask_b32_e32 v17, v17, v29, vcc
		v_mul_hi_u32 v2, v17, v2
		v_mul_lo_u32 v2, v2, v42
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v17
		v_cmp_ge_u32_e64 vcc, v2, v42
		v_add_u32_e32 v17, v2, v27
		v_and_b32_e32 v29, 1, v50
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_cmp_ge_u32_e64 vcc, v2, v42
		v_add_u32_e32 v17, v2, v27
		v_lshlrev_b32_e32 v27, 5, v29
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_xad_u32 v17, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v17, s[2:3]
		v_and_b32_e32 v17, 1, v49
		v_mov_b32_e32 v29, 32
		v_mul_lo_u32 v29, v29, v17
		v_bitop3_b32 v17, v52, v28, v29 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v17, s14
		v_and_b32_e32 v28, 1, v49
		v_lshlrev_b32_e32 v28, 6, v28
		v_add3_u32 v29, v48, v28, v27
		v_mov_b32_e32 v41, 0x80000000
		v_cndmask_b32_e32 v42, v41, v29, vcc
		buffer_load_dwordx4 v42, s[36:39], 0 offen lds
		v_add3_u32 v42, v46, v28, v27
		v_cndmask_b32_e32 v46, v41, v42, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v30, v30, v31, s[24:25]
		buffer_load_dwordx4 v46, s[36:39], 0 offen lds
		s_ashr_i32 s2, s23, 6
		v_bitop3_b32 v31, v45, v44, v10 bitop3:0x96
		v_bitop3_b32 v31, v31, v13, v43 bitop3:0x96
		v_bitop3_b32 v44, 4, v45, v44 bitop3:0x96
		v_xor_b32_e32 v44, v44, v10
		v_cmp_lt_i32_e64 vcc, v31, s14
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v45, 3, v14
		v_lshlrev_b32_e32 v46, 1, v11
		v_and_b32_e32 v48, 1, v9
		v_add3_u32 v45, v45, v46, v48
		v_lshl_add_u32 v45, v7, 5, v45
		v_and_b32_e32 v46, 1, v4
		v_lshl_add_u32 v45, v46, 4, v45
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v46, s17, v45
		v_lshl_add_u32 v46, v46, 1, v16
		v_cndmask_b32_e32 v50, v41, v46, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v32, v32, v39, s[30:31]
		buffer_load_dwordx4 v50, s[40:43], 0 offen lds
		v_bitop3_b32 v13, v44, v13, v43 bitop3:0x96
		v_add_u32_e32 v39, 4, v45
		v_mul_lo_u32 v39, s17, v39
		v_lshl_add_u32 v39, v39, 1, v16
		v_cndmask_b32_e32 v43, v41, v39, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v44, 7, v49
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		s_add_i32 s3, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v17, s3
		v_add_u32_e32 v43, 0x80, v29
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e32 v43, v41, v43, vcc
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		v_add_u32_e32 v43, 0x80, v42
		v_cndmask_b32_e32 v43, v41, v43, vcc
		v_cmp_lt_i32_e64 vcc, v31, s3
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v33, v33, v40, s[32:33]
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		v_lshlrev_b32_e32 v40, 8, v7
		s_lshl_b32 s3, s17, 7
		v_add_u32_e32 v43, s3, v46
		v_add_u32_e32 v45, s3, v39
		v_cndmask_b32_e32 v43, v41, v43, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e32 v45, v41, v45, vcc
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		v_and_b32_e32 v9, 3, v9
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v29, 0x100, v29
		buffer_load_dwordx4 v45, s[40:43], 0 offen lds
		s_add_i32 s3, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v17, s3
		v_and_b32_e32 v43, 3, v0
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e32 v29, v41, v29, vcc
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		v_add_u32_e32 v29, 0x100, v42
		v_cndmask_b32_e32 v29, v41, v29, vcc
		v_cmp_lt_i32_e64 vcc, v31, s3
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v42, 63, v0
		v_lshlrev_b32_e32 v9, 5, v9
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_lshl_b32 s3, s17, 8
		v_add_u32_e32 v29, s3, v46
		v_add_u32_e32 v45, s3, v39
		v_cndmask_b32_e32 v29, v41, v29, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_lshl_add_u32 v9, v43, 3, v9
		v_cndmask_b32_e32 v43, v41, v45, vcc
		buffer_load_dwordx4 v29, s[40:43], 0 offen lds
		v_mov_b32_e32 v29, 0x420
		v_mul_lo_u32 v29, v29, v44
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v44, 7, v14
		v_add3_u32 v9, v9, v40, v29
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v29, 4, v42
		v_lshlrev_b32_e32 v40, 4, v29
		v_and_b32_e32 v43, 15, v42
		v_mov_b32_e32 v45, 0x420
		v_mul_lo_u32 v45, v45, v43
		v_add3_u32 v40, v44, v40, v45
		ds_read_b128 v[52:55], v40
		ds_read_b128 v[56:59], v40 offset:64
		ds_read_b128 v[60:63], v40 offset:256
		ds_read_b128 v[64:67], v40 offset:320
		ds_read_b128 v[68:71], v40 offset:512
		ds_read_b128 v[72:75], v40 offset:576
		ds_read_b128 v[76:79], v40 offset:768
		ds_read_b128 v[80:83], v40 offset:832
		ds_read_b64_tr_b16 v[84:85], v9 offset:50656
		ds_read_b64_tr_b16 v[86:87], v9 offset:59104
		ds_read_b64_tr_b16 v[88:89], v9 offset:51168
		ds_read_b64_tr_b16 v[90:91], v9 offset:59616
		ds_read_b64_tr_b16 v[92:93], v9 offset:50784
		ds_read_b64_tr_b16 v[94:95], v9 offset:59232
		ds_read_b64_tr_b16 v[96:97], v9 offset:51296
		ds_read_b64_tr_b16 v[98:99], v9 offset:59744
		s_add_i32 s3, s2, -3
		v_cmp_ne_u32_e64 vcc, v14, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[44:45], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[44:45]
		s_setprio 0
		v_add3_u32 v43, v47, v28, v27
		v_add_u32_e32 v43, 0x180, v43
		s_lshl_b32 s4, s15, 1
		v_mul_lo_u32 v26, s4, v26
		v_mul_lo_u32 v6, s4, v6
		v_add_u32_e32 v44, v43, v26
		v_add_u32_e32 v26, v43, v6
		s_mul_i32 s4, 0x180, s17
		s_cmp_lt_i32 0, s3
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
		s_mov_b32 s5, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[52:55], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[52:55], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[60:63], v[108:111]
		s_cmp_ge_u32 s5, 2
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[68:71], v[120:123]
		s_cselect_b32 s15, 1, 0
		s_add_i32 s23, s5, -2
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[76:79], v[128:131]
		s_add_i32 s24, s5, 1
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[76:79], v[124:127]
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s15, s23, s24
		v_mfma_f32_16x16x32_f16 v[100:103], v[88:91], v[56:59], v[100:103]
		s_add_i32 s23, s22, 3
		v_mfma_f32_16x16x32_f16 v[104:107], v[96:99], v[56:59], v[104:107]
		s_mul_i32 s23, s23, 64
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[64:67], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[72:75], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[80:83], v[124:127]
		s_setprio 1
		s_barrier
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s14, s23
		v_cmp_lt_i32_e64 vcc, v17, s23
		v_cmp_lt_i32_e64 s[24:25], v31, s23
		s_lshl_b32 s26, s22, 7
		v_cndmask_b32_e32 v6, v41, v44, vcc
		s_mul_i32 s5, 0x4200, s5
		v_cndmask_b32_e32 v43, v41, v26, vcc
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_add_i32 s5, s29, s5
		s_mov_b32 m0, s5
		s_nop 0
		buffer_load_dwordx4 v6, s[36:39], s26 offen lds
		s_mul_i32 s5, s17, s22
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s5, s5, 7
		buffer_load_dwordx4 v43, s[36:39], s26 offen lds
		s_add_i32 s5, s4, s5
		v_add_u32_e32 v6, s5, v46
		v_cndmask_b32_e64 v6, v41, v6, s[24:25]
		v_add_u32_e32 v43, s5, v39
		v_cndmask_b32_e32 v43, v41, v43, vcc
		s_add_i32 m0, m0, 0xa4e0
		s_mul_i32 s5, 0x4200, s15
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		v_add_u32_e32 v6, s5, v9
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v45, s5, v40
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(4)
		ds_read_b128 v[52:55], v45
		ds_read_b128 v[56:59], v45 offset:64
		ds_read_b128 v[60:63], v45 offset:256
		ds_read_b128 v[64:67], v45 offset:320
		ds_read_b128 v[68:71], v45 offset:512
		ds_read_b128 v[72:75], v45 offset:576
		ds_read_b128 v[76:79], v45 offset:768
		ds_read_b128 v[80:83], v45 offset:832
		ds_read_b64_tr_b16 v[84:85], v6 offset:50656
		ds_read_b64_tr_b16 v[86:87], v6 offset:59104
		ds_read_b64_tr_b16 v[88:89], v6 offset:51168
		ds_read_b64_tr_b16 v[90:91], v6 offset:59616
		ds_read_b64_tr_b16 v[92:93], v6 offset:50784
		ds_read_b64_tr_b16 v[94:95], v6 offset:59232
		ds_read_b64_tr_b16 v[96:97], v6 offset:51296
		ds_read_b64_tr_b16 v[98:99], v6 offset:59744
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s3
		s_mov_b32 s5, s15
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[44:45], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[44:45]
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_lshl_add_u32 v6, v14, 8, v29
		s_mul_i32 s3, 0x108, s28
		s_add_i32 m0, s3, 0x18bc0
		v_mul_lo_u32 v13, s18, v30
		v_add_lshl_u32 v13, v2, v13, 1
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s38
		s_mov_b32 s31, s39
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v32
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v33
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v34
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v35
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v36
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v37
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s18, v38
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v13, v2, v13, 1
		v_mul_lo_u32 v14, s18, v18
		v_add_lshl_u32 v14, v2, v14, 1
		v_mul_lo_u32 v18, s18, v19
		v_add_lshl_u32 v18, v2, v18, 1
		v_mul_lo_u32 v19, s18, v20
		v_add_lshl_u32 v19, v2, v19, 1
		v_mul_lo_u32 v20, s18, v21
		v_add_lshl_u32 v20, v2, v20, 1
		v_mul_lo_u32 v21, s18, v22
		v_add_lshl_u32 v21, v2, v21, 1
		v_mul_lo_u32 v22, s18, v23
		v_add_lshl_u32 v22, v2, v22, 1
		v_mul_lo_u32 v23, s18, v24
		v_add_lshl_u32 v23, v2, v23, 1
		v_mul_lo_u32 v24, s18, v25
		v_add_lshl_u32 v2, v2, v24, 1
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[52:55], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[52:55], v[104:107]
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[60:63], v[108:111]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[76:79], v[124:127]
		buffer_load_dword v14, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[100:103], v[88:91], v[56:59], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[96:99], v[56:59], v[104:107]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[64:67], v[108:111]
		buffer_load_dword v18, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[72:75], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[80:83], v[124:127]
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v7, 1, v7
		buffer_load_dword v19, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v13, 2, v48
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v11, 3, v11
		buffer_load_dword v20, s[28:31], 0 offen lds
		v_add3_u32 v6, v6, v11, v13
		s_add_i32 m0, m0, 0x840
		v_xor_b32_e32 v11, v13, v11
		buffer_load_dword v21, s[28:31], 0 offen lds
		v_bitop3_b32 v7, v0, v7, v11 bitop3:0x96
		s_add_i32 m0, m0, 0x840
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v8
		buffer_load_dword v22, s[28:31], 0 offen lds
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v10
		s_add_i32 m0, m0, 0x840
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v12
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v15
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v3
		v_xad_u32 v3, v17, v13, s20
		buffer_load_dword v23, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[4:5], v3, s13
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v0, 0x10000, v0
		v_lshl_add_u32 v0, v4, 3, v0
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 7, v1
		buffer_load_dword v2, s[28:31], 0 offen lds
		s_add_i32 s3, s2, -2
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s8, 1, 0
		s_xor_b32 s9, s3, -1
		s_add_i32 s9, s9, 1
		s_cmp_lg_u32 s8, 0
		s_cselect_b32 s3, s9, s3
		s_mul_hi_u32 s8, s3, 0xaaaaaaab
		s_cselect_b32 s9, 1, 0
		s_lshr_b32 s8, s8, 1
		s_mul_i32 s8, s8, 3
		s_xor_b32 s8, s8, -1
		s_add_i32 s8, s8, 1
		s_add_i32 s3, s3, s8
		s_xor_b32 s8, s3, -1
		s_add_i32 s8, s8, 1
		s_cmp_lg_u32 s9, 0
		s_cselect_b32 s3, s8, s3
		s_mul_i32 s3, 0x4200, s3
		s_add_i32 s2, s2, -1
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s8, 1, 0
		s_xor_b32 s9, s2, -1
		s_add_i32 s9, s9, 1
		s_cmp_lg_u32 s8, 0
		s_cselect_b32 s2, s9, s2
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s38
		s_mov_b32 s11, s39
		buffer_load_dwordx4 v[20:23], v16, s[8:11], 0 offen
		v_add_u32_e32 v2, s3, v40
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[32:35], v2 offset:64
		ds_read_b128 v[36:39], v2 offset:256
		ds_read_b128 v[48:51], v2 offset:320
		ds_read_b128 v[52:55], v2 offset:512
		ds_read_b128 v[56:59], v2 offset:576
		ds_read_b128 v[60:63], v2 offset:768
		ds_read_b128 v[64:67], v2 offset:832
		v_add_u32_e32 v2, s3, v9
		ds_read_b64_tr_b16 v[68:69], v2 offset:50656
		ds_read_b64_tr_b16 v[70:71], v2 offset:59104
		ds_read_b64_tr_b16 v[72:73], v2 offset:51168
		ds_read_b64_tr_b16 v[74:75], v2 offset:59616
		ds_read_b64_tr_b16 v[76:77], v2 offset:50784
		ds_read_b64_tr_b16 v[78:79], v2 offset:59232
		ds_read_b64_tr_b16 v[80:81], v2 offset:51296
		ds_read_b64_tr_b16 v[82:83], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_cselect_b32 s6, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[36:39], v[112:115]
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[52:55], v[116:119]
		s_xor_b32 s3, s2, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s6, 0
		s_cselect_b32 s2, s3, s2
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v2, s2, v40
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[64:67], v[124:127]
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[32:35], v2 offset:64
		ds_read_b128 v[36:39], v2 offset:256
		ds_read_b128 v[48:51], v2 offset:320
		ds_read_b128 v[52:55], v2 offset:512
		ds_read_b128 v[56:59], v2 offset:576
		ds_read_b128 v[60:63], v2 offset:768
		ds_read_b128 v[64:67], v2 offset:832
		v_add_u32_e32 v2, s2, v9
		ds_read_b64_tr_b16 v[68:69], v2 offset:50656
		ds_read_b64_tr_b16 v[70:71], v2 offset:59104
		ds_read_b64_tr_b16 v[72:73], v2 offset:51168
		ds_read_b64_tr_b16 v[74:75], v2 offset:59616
		ds_read_b64_tr_b16 v[76:77], v2 offset:50784
		ds_read_b64_tr_b16 v[78:79], v2 offset:59232
		ds_read_b64_tr_b16 v[80:81], v2 offset:51296
		ds_read_b64_tr_b16 v[82:83], v2 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[64:67], v[124:127]
		v_lshlrev_b32_e32 v2, 4, v7
		ds_write_b128 v2, v[100:103]
		v_xor_b32_e32 v3, 1, v7
		v_lshlrev_b32_e32 v3, 4, v3
		ds_write_b128 v3, v[104:107] offset:8192
		v_lshrrev_b32_e32 v7, 3, v42
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v9, 2, v42
		v_and_b32_e32 v9, 1, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v6, v9, 7, v6
		v_lshrrev_b32_e32 v13, 1, v42
		v_and_b32_e32 v13, 1, v13
		v_lshl_add_u32 v6, v13, 6, v6
		v_and_b32_e32 v14, 1, v42
		v_lshl_add_u32 v6, v14, 5, v6
		v_lshlrev_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshlrev_b32_e32 v9, 3, v9
		v_bitop3_b32 v9, v13, v9, v7 bitop3:0x96
		v_bitop3_b32 v6, v6, v14, v9 bitop3:0x96
		v_lshlrev_b32_e32 v6, 4, v6
		v_lshl_add_u32 v6, v7, 13, v6
		ds_read_b128 v[16:19], v6
		ds_read_b128 v[32:35], v6 offset:256
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v14, v20
		v_cvt_f32_f16_sdwa v15, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v24, v21
		v_cvt_f32_f16_sdwa v25, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[108:111]
		ds_write_b128 v3, v[112:115] offset:8192
		v_pk_add_f32 v[16:17], v[16:17], v[14:15]
		v_pk_add_f32 v[18:19], v[18:19], v[24:25]
		v_cvt_f32_f16_e32 v20, v22
		v_cvt_f32_f16_sdwa v21, v22 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v6
		ds_read_b128 v[40:43], v6 offset:256
		v_pk_add_f32 v[30:31], v[32:33], v[20:21]
		v_cvt_f32_f16_e32 v32, v23
		v_cvt_f32_f16_sdwa v33, v23 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[22:23], v[34:35], v[32:33]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[116:119]
		ds_write_b128 v3, v[120:123] offset:8192
		v_pk_add_f32 v[34:35], v[36:37], v[14:15]
		v_pk_add_f32 v[36:37], v[38:39], v[24:25]
		v_pk_add_f32 v[38:39], v[40:41], v[20:21]
		v_pk_add_f32 v[40:41], v[42:43], v[32:33]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v6
		ds_read_b128 v[52:55], v6 offset:256
		v_bitop3_b32 v7, v5, v11, v8 bitop3:0x96
		v_xor_b32_e32 v7, v7, v10
		v_xad_u32 v7, v7, v12, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[42:43], v[48:49], v[14:15]
		v_cmp_lt_i32_e64 s[2:3], v7, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[124:127]
		ds_write_b128 v3, v[128:131] offset:8192
		v_pk_add_f32 v[2:3], v[50:51], v[24:25]
		v_pk_add_f32 v[44:45], v[52:53], v[20:21]
		v_pk_add_f32 v[48:49], v[54:55], v[32:33]
		s_and_b64 s[2:3], s[2:3], s[4:5]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[52:55], v6
		ds_read_b128 v[56:59], v6 offset:256
		v_bitop3_b32 v6, 32, v5, v11 bitop3:0x96
		v_bitop3_b32 v6, v6, v8, v10 bitop3:0x96
		v_xad_u32 v6, v6, v12, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[14:15], v[52:53], v[14:15]
		v_pk_add_f32 v[24:25], v[54:55], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[20:21], v[56:57], v[20:21]
		v_pk_add_f32 v[32:33], v[58:59], v[32:33]
		v_bitop3_b32 v7, 64, v5, v11 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v10 bitop3:0x96
		v_xor_b32_e32 v5, 0x60, v5
		v_xor_b32_e32 v5, v5, v11
		v_xor_b32_e32 v5, v5, v8
		v_xor_b32_e32 v5, v5, v10
		ds_read_b128 v[8:11], v0 offset:35776
		v_mov_b32_e32 v0, 0x108
		v_mul_lo_u32 v0, v0, v4
		v_add_u32_e32 v0, 0x10000, v0
		v_add3_u32 v0, v0, v47, v1
		v_add3_u32 v0, v0, v28, v27
		v_cmp_lt_i32_e64 s[6:7], v6, s12
		ds_read_b128 v[52:55], v0 offset:44224
		ds_read_b128 v[56:59], v0 offset:52672
		ds_read_b128 v[60:63], v0 offset:61120
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v50, v8
		v_cvt_f32_f16_sdwa v51, v8 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[64:65], v[16:17], v[50:51], v[16:17]
		v_cvt_pk_f16_f32 v68, v64, v65
		v_cvt_f32_f16_e32 v16, v9
		v_cvt_f32_f16_sdwa v17, v9 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[8:9], v[18:19], v[16:17], v[18:19]
		v_cvt_pk_f16_f32 v69, v8, v9
		v_cvt_f32_f16_e32 v8, v10
		v_cvt_f32_f16_sdwa v9, v10 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[16:17], v[30:31], v[8:9], v[30:31]
		v_cvt_pk_f16_f32 v70, v16, v17
		v_cvt_f32_f16_e32 v8, v11
		v_cvt_f32_f16_sdwa v9, v11 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[10:11], v[22:23], v[8:9], v[22:23]
		v_cvt_pk_f16_f32 v71, v10, v11
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v8, v52
		v_cvt_f32_f16_sdwa v9, v52 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[10:11], v[34:35], v[8:9], v[34:35]
		v_cvt_f32_f16_e32 v8, v53
		v_cvt_f32_f16_sdwa v9, v53 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v16, v54
		v_cvt_f32_f16_sdwa v17, v54 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[18:19], v[36:37], v[8:9], v[36:37]
		v_cvt_f32_f16_e32 v8, v55
		v_cvt_f32_f16_sdwa v9, v55 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v22, v56
		v_cvt_f32_f16_sdwa v23, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[30:31], v[38:39], v[16:17], v[38:39]
		v_cvt_f32_f16_e32 v16, v57
		v_cvt_f32_f16_sdwa v17, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v34, v58
		v_cvt_f32_f16_sdwa v35, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[36:37], v[40:41], v[8:9], v[40:41]
		v_cvt_f32_f16_e32 v8, v59
		v_cvt_f32_f16_sdwa v9, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v38, v60
		v_cvt_f32_f16_sdwa v39, v60 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[40:41], v[42:43], v[22:23], v[42:43]
		v_cvt_f32_f16_e32 v22, v61
		v_cvt_f32_f16_sdwa v23, v61 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v62
		v_cvt_f32_f16_sdwa v43, v62 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[50:51], v[2:3], v[16:17], v[2:3]
		v_cvt_f32_f16_e32 v2, v63
		v_cvt_f32_f16_sdwa v3, v63 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[16:17], v[44:45], v[34:35], v[44:45]
		v_pk_fma_f32 v[34:35], v[48:49], v[8:9], v[48:49]
		v_pk_fma_f32 v[8:9], v[14:15], v[38:39], v[14:15]
		v_pk_fma_f32 v[14:15], v[24:25], v[22:23], v[24:25]
		v_pk_fma_f32 v[22:23], v[20:21], v[42:43], v[20:21]
		v_pk_fma_f32 v[20:21], v[32:33], v[2:3], v[32:33]
		v_xad_u32 v0, v7, v12, s16
		v_xad_u32 v2, v5, v12, s16
		v_cmp_lt_i32_e64 s[8:9], v0, s12
		v_cmp_lt_i32_e64 s[10:11], v2, s12
		s_and_b64 s[6:7], s[6:7], s[4:5]
		s_and_b64 s[8:9], s[8:9], s[4:5]
		s_and_b64 s[4:5], s[10:11], s[4:5]
		s_lshl_b32 s0, s0, 8
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 10
		s_add_i32 s10, s0, s1
		s_mul_i32 s11, s21, s19
		s_lshl_b32 s11, s11, 8
		s_add_i32 s10, s10, s11
		v_mul_lo_u32 v0, s19, v4
		v_lshl_add_u32 v2, v0, 1, s10
		v_add3_u32 v2, v2, v47, v1
		v_add3_u32 v2, v2, v28, v27
		s_and_saveexec_b64 s[44:45], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_2
		buffer_store_dwordx4 v[68:71], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_2:
		s_andn2_b64 exec, s[44:45], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2:
		s_mov_b64 exec, s[44:45]
		v_cvt_pk_f16_f32 v4, v10, v11
		v_cvt_pk_f16_f32 v5, v18, v19
		v_cvt_pk_f16_f32 v6, v30, v31
		v_cvt_pk_f16_f32 v7, v36, v37
		s_lshl_b32 s2, s19, 6
		s_add_i32 s2, s0, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s11
		v_lshl_add_u32 v2, v0, 1, s2
		v_add3_u32 v2, v2, v47, v1
		v_add3_u32 v2, v2, v28, v27
		s_and_saveexec_b64 s[44:45], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_3
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_3:
		s_andn2_b64 exec, s[44:45], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3:
		s_mov_b64 exec, s[44:45]
		s_nop 0
		v_cvt_pk_f16_f32 v4, v40, v41
		v_cvt_pk_f16_f32 v5, v50, v51
		v_cvt_pk_f16_f32 v6, v16, v17
		v_cvt_pk_f16_f32 v7, v34, v35
		s_lshl_b32 s2, s19, 7
		s_add_i32 s2, s0, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s11
		v_lshl_add_u32 v2, v0, 1, s2
		v_add3_u32 v2, v2, v47, v1
		v_add3_u32 v2, v2, v28, v27
		s_and_saveexec_b64 s[44:45], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_4
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_4:
		s_andn2_b64 exec, s[44:45], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4:
		s_mov_b64 exec, s[44:45]
		s_nop 0
		v_cvt_pk_f16_f32 v4, v8, v9
		v_cvt_pk_f16_f32 v5, v14, v15
		v_cvt_pk_f16_f32 v6, v22, v23
		v_cvt_pk_f16_f32 v7, v20, v21
		s_mul_i32 s2, 0xc0, s19
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s11
		v_lshl_add_u32 v0, v0, 1, s0
		v_add3_u32 v0, v0, v47, v1
		v_add3_u32 v0, v0, v28, v27
		s_and_saveexec_b64 s[44:45], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_5
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_5:
		s_andn2_b64 exec, s[44:45], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5:
		s_mov_b64 exec, s[44:45]
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
		.amdhsa_next_free_sgpr 46
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 46
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
    .sgpr_count:     46
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
