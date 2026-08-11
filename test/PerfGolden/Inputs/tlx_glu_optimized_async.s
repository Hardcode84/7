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
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v3, 4, v0
		v_and_b32_e32 v4, 1, v3
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v4
		v_mad_u32_u24 v5, v1, 16, v5
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v7, 1, v6
		v_mad_u32_u24 v5, v7, 64, v5
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v9, 1, v8
		v_lshrrev_b32_e32 v10, 7, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v11
		v_add3_u32 v5, v5, v9, v12
		v_lshrrev_b32_e32 v13, 8, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v5, v14, 4, v5
		v_and_b32_e32 v15, 15, v0
		v_and_b32_e32 v16, 63, v0
		v_and_b32_e32 v17, 7, v8
		v_add_u32_e32 v18, 0x48, v17
		v_add_u32_e32 v19, 0x50, v17
		v_add_u32_e32 v20, 0x58, v17
		v_add_u32_e32 v21, 0x60, v17
		v_add_u32_e32 v22, 0x68, v17
		v_add_u32_e32 v23, 0x70, v17
		v_add_u32_e32 v24, 0x78, v17
		v_add_u32_e32 v25, s16, v5
		s_mul_i32 s20, s0, 0x80
		s_mov_b32 s22, 0
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v26, v25, -1, 1
		v_cndmask_b32_e32 v25, v25, v26, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s26, -1
		s_mov_b32 s27, -1
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_xor_b32 s23, s12, -1
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v26, s23
		v_mov_b32_e32 v27, s12
		v_cndmask_b32_e64 v26, v27, v26, s[30:31]
		v_cvt_f32_u32_e32 v27, v26
		v_rcp_iflag_f32_e32 v27, v27
		v_add3_u32 v5, 8, v5, s16
		v_mul_f32_e32 v27, v2, v27
		v_cvt_u32_f32_e32 v27, v27
		v_xad_u32 v28, v26, -1, 1
		v_mul_lo_u32 v29, v28, v27
		v_mul_hi_u32 v29, v27, v29
		v_add_u32_e32 v27, v27, v29
		v_mul_hi_u32 v29, v25, v27
		v_mul_lo_u32 v29, v29, v26
		v_xor_b32_e32 v29, -1, v29
		v_add3_u32 v25, 1, v29, v25
		v_add_u32_e32 v29, v25, v28
		v_cmp_ge_u32_e64 vcc, v25, v26
		v_add_u32_e32 v30, s16, v17
		v_add_u32_e32 v18, s16, v18
		v_cndmask_b32_e32 v25, v25, v29, vcc
		v_add_u32_e32 v29, v25, v28
		v_cmp_ge_u32_e64 vcc, v25, v26
		v_add3_u32 v31, 8, v17, s16
		v_add3_u32 v32, 16, v17, s16
		v_cndmask_b32_e32 v25, v25, v29, vcc
		v_xad_u32 v29, v25, -1, 1
		v_cndmask_b32_e64 v25, v25, v29, s[24:25]
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v29, v5, -1, 1
		v_cndmask_b32_e32 v5, v5, v29, vcc
		v_mul_hi_u32 v29, v5, v27
		v_mul_lo_u32 v29, v29, v26
		v_xor_b32_e32 v29, -1, v29
		v_add3_u32 v5, 1, v29, v5
		v_add_u32_e32 v29, v5, v28
		v_cmp_ge_u32_e64 vcc, v5, v26
		v_add3_u32 v33, 24, v17, s16
		v_add3_u32 v34, 32, v17, s16
		v_cndmask_b32_e32 v5, v5, v29, vcc
		v_add_u32_e32 v29, v5, v28
		v_cmp_ge_u32_e64 vcc, v5, v26
		v_add3_u32 v35, 40, v17, s16
		v_add3_u32 v36, 48, v17, s16
		v_cndmask_b32_e32 v5, v5, v29, vcc
		v_xad_u32 v29, v5, -1, 1
		v_cndmask_b32_e64 v5, v5, v29, s[24:25]
		v_cmp_lt_i32_e64 vcc, v30, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v29, v30, -1, 1
		v_cndmask_b32_e32 v29, v30, v29, vcc
		v_mul_hi_u32 v30, v29, v27
		v_mul_lo_u32 v30, v30, v26
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v29, 1, v30, v29
		v_add_u32_e32 v30, v29, v28
		v_cmp_ge_u32_e64 vcc, v29, v26
		v_add3_u32 v37, 56, v17, s16
		v_add3_u32 v17, 64, v17, s16
		v_cndmask_b32_e32 v29, v29, v30, vcc
		v_add_u32_e32 v30, v29, v28
		v_cmp_ge_u32_e64 vcc, v29, v26
		v_add_u32_e32 v19, s16, v19
		v_add_u32_e32 v20, s16, v20
		v_cndmask_b32_e32 v29, v29, v30, vcc
		v_xad_u32 v30, v29, -1, 1
		v_cndmask_b32_e64 v29, v29, v30, s[24:25]
		v_cmp_lt_i32_e64 vcc, v31, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v30, v31, -1, 1
		v_cndmask_b32_e32 v30, v31, v30, vcc
		v_mul_hi_u32 v31, v30, v27
		v_mul_lo_u32 v31, v31, v26
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v30, 1, v31, v30
		v_add_u32_e32 v31, v30, v28
		v_cmp_ge_u32_e64 vcc, v30, v26
		v_add_u32_e32 v21, s16, v21
		v_add_u32_e32 v22, s16, v22
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_add_u32_e32 v31, v30, v28
		v_cmp_ge_u32_e64 vcc, v30, v26
		v_add_u32_e32 v23, s16, v23
		v_add_u32_e32 v24, s16, v24
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_xad_u32 v31, v30, -1, 1
		v_cmp_lt_i32_e64 vcc, v32, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v38, v32, -1, 1
		v_cndmask_b32_e32 v32, v32, v38, vcc
		v_mul_hi_u32 v38, v32, v27
		v_mul_lo_u32 v38, v38, v26
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v32, 1, v38, v32
		v_add_u32_e32 v38, v32, v28
		v_cmp_ge_u32_e64 vcc, v32, v26
		v_mad_u32_u24 v15, v15, 8, s20
		v_mad_u32_u24 v16, v16, 2, s20
		v_cndmask_b32_e32 v32, v32, v38, vcc
		v_add_u32_e32 v38, v32, v28
		v_cmp_ge_u32_e64 vcc, v32, v26
		v_and_b32_e32 v6, 1, v6
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v29, s18, v29
		v_cndmask_b32_e32 v32, v32, v38, vcc
		v_xad_u32 v38, v32, -1, 1
		v_cmp_lt_i32_e64 vcc, v33, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v39, v33, -1, 1
		v_cndmask_b32_e32 v33, v33, v39, vcc
		v_mul_hi_u32 v39, v33, v27
		v_mul_lo_u32 v39, v39, v26
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v33, 1, v39, v33
		v_add_u32_e32 v39, v33, v28
		v_cmp_ge_u32_e64 vcc, v33, v26
		s_mov_b32 s38, 0x7fffffff
		s_xor_b32 s23, s13, -1
		v_cndmask_b32_e32 v33, v33, v39, vcc
		v_add_u32_e32 v39, v33, v28
		v_cmp_ge_u32_e64 vcc, v33, v26
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s34, s26, s28
		s_cselect_b32 s35, s27, s29
		v_cndmask_b32_e32 v33, v33, v39, vcc
		v_xad_u32 v39, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v40, v34, -1, 1
		v_cndmask_b32_e32 v34, v34, v40, vcc
		v_mul_hi_u32 v40, v34, v27
		v_mul_lo_u32 v40, v40, v26
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v34, 1, v40, v34
		v_cmp_ge_u32_e64 vcc, v34, v26
		v_add_u32_e32 v40, v34, v28
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v41, s23
		v_cndmask_b32_e32 v34, v34, v40, vcc
		v_cmp_ge_u32_e64 vcc, v34, v26
		v_add_u32_e32 v40, v34, v28
		v_mov_b32_e32 v42, 8
		v_mul_lo_u32 v42, v42, v14
		v_cndmask_b32_e32 v34, v34, v40, vcc
		v_xad_u32 v40, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s22
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v43, v35, -1, 1
		v_cndmask_b32_e32 v35, v35, v43, vcc
		v_mul_hi_u32 v43, v35, v27
		v_mul_lo_u32 v43, v43, v26
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v35, 1, v43, v35
		v_cmp_ge_u32_e64 vcc, v35, v26
		v_add_u32_e32 v43, v35, v28
		s_mov_b32 s23, 63
		v_cndmask_b32_e32 v35, v35, v43, vcc
		v_cmp_ge_u32_e64 vcc, v35, v26
		v_add_u32_e32 v43, v35, v28
		v_mov_b32_e32 v44, 32
		v_mul_lo_u32 v44, v44, v7
		v_cndmask_b32_e32 v35, v35, v43, vcc
		v_xad_u32 v43, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v45, v36, -1, 1
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_mul_hi_u32 v45, v36, v27
		v_mul_lo_u32 v45, v45, v26
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v36, 1, v45, v36
		v_cmp_ge_u32_e64 vcc, v36, v26
		v_add_u32_e32 v45, v36, v28
		s_add_i32 s39, s14, 63
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_cmp_ge_u32_e64 vcc, v36, v26
		v_add_u32_e32 v45, v36, v28
		v_mov_b32_e32 v46, 16
		v_mul_lo_u32 v46, v46, v4
		v_cndmask_b32_e32 v36, v36, v45, vcc
		v_xad_u32 v45, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v45, s[36:37]
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v45, v37, -1, 1
		v_cndmask_b32_e32 v37, v37, v45, vcc
		v_mul_hi_u32 v45, v37, v27
		v_mul_lo_u32 v45, v45, v26
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v37, 1, v45, v37
		v_cmp_ge_u32_e64 vcc, v37, v26
		v_add_u32_e32 v45, v37, v28
		v_bitop3_b32 v44, v46, v44, v9 bitop3:0x96
		v_cndmask_b32_e32 v37, v37, v45, vcc
		v_cmp_ge_u32_e64 vcc, v37, v26
		v_add_u32_e32 v45, v37, v28
		v_mul_lo_u32 v46, s15, v5
		v_cndmask_b32_e32 v37, v37, v45, vcc
		v_xad_u32 v45, v37, -1, 1
		v_cndmask_b32_e64 v37, v37, v45, s[36:37]
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v45, v17, -1, 1
		v_cndmask_b32_e32 v17, v17, v45, vcc
		v_mul_hi_u32 v45, v17, v27
		v_mul_lo_u32 v45, v45, v26
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v17, 1, v45, v17
		v_cmp_ge_u32_e64 vcc, v17, v26
		v_add_u32_e32 v45, v17, v28
		v_bitop3_b32 v12, v44, v12, v42 bitop3:0x96
		v_cndmask_b32_e32 v17, v17, v45, vcc
		v_cmp_ge_u32_e64 vcc, v17, v26
		v_add_u32_e32 v42, v17, v28
		v_and_b32_e32 v44, 7, v0
		v_cndmask_b32_e32 v17, v17, v42, vcc
		v_xad_u32 v42, v17, -1, 1
		v_cndmask_b32_e64 v17, v17, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v18, -1, 1
		v_cndmask_b32_e32 v18, v18, v42, vcc
		v_mul_hi_u32 v42, v18, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v18, 1, v42, v18
		v_cmp_ge_u32_e64 vcc, v18, v26
		v_add_u32_e32 v42, v18, v28
		s_cmp_lt_i32 s39, 0
		v_cndmask_b32_e32 v18, v18, v42, vcc
		v_cmp_ge_u32_e64 vcc, v18, v26
		v_add_u32_e32 v42, v18, v28
		v_mul_lo_u32 v45, s15, v25
		v_cndmask_b32_e32 v18, v18, v42, vcc
		v_xad_u32 v42, v18, -1, 1
		v_cndmask_b32_e64 v18, v18, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v19, -1, 1
		v_cndmask_b32_e32 v19, v19, v42, vcc
		v_mul_hi_u32 v42, v19, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v19, 1, v42, v19
		v_cmp_ge_u32_e64 vcc, v19, v26
		v_add_u32_e32 v42, v19, v28
		s_cselect_b32 s23, s23, 0
		s_add_i32 s23, s39, s23
		v_cndmask_b32_e32 v19, v19, v42, vcc
		v_cmp_ge_u32_e64 vcc, v19, v26
		v_add_u32_e32 v42, v19, v28
		v_lshlrev_b32_e32 v44, 4, v44
		v_cndmask_b32_e32 v19, v19, v42, vcc
		v_xad_u32 v42, v19, -1, 1
		v_cndmask_b32_e64 v19, v19, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v20, -1, 1
		v_cndmask_b32_e32 v20, v20, v42, vcc
		v_mul_hi_u32 v42, v20, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v20, 1, v42, v20
		v_cmp_ge_u32_e64 vcc, v20, v26
		v_add_u32_e32 v42, v20, v28
		v_lshl_add_u32 v45, v45, 1, v44
		v_cndmask_b32_e32 v20, v20, v42, vcc
		v_cmp_ge_u32_e64 vcc, v20, v26
		v_add_u32_e32 v42, v20, v28
		v_lshrrev_b32_e32 v47, 2, v0
		v_cndmask_b32_e32 v20, v20, v42, vcc
		v_xad_u32 v42, v20, -1, 1
		v_cndmask_b32_e64 v20, v20, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v21, -1, 1
		v_cndmask_b32_e32 v21, v21, v42, vcc
		v_mul_hi_u32 v42, v21, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v21, 1, v42, v21
		v_cmp_ge_u32_e64 vcc, v21, v26
		v_add_u32_e32 v42, v21, v28
		v_lshl_add_u32 v46, v46, 1, v44
		v_cndmask_b32_e32 v21, v21, v42, vcc
		v_cmp_ge_u32_e64 vcc, v21, v26
		v_add_u32_e32 v42, v21, v28
		v_lshrrev_b32_e32 v48, 1, v0
		v_cndmask_b32_e32 v21, v21, v42, vcc
		v_xad_u32 v42, v21, -1, 1
		v_cndmask_b32_e64 v21, v21, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v22, -1, 1
		v_cndmask_b32_e32 v22, v22, v42, vcc
		v_mul_hi_u32 v42, v22, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v22, 1, v42, v22
		v_cmp_ge_u32_e64 vcc, v22, v26
		v_add_u32_e32 v42, v22, v28
		v_and_b32_e32 v48, 1, v48
		v_cndmask_b32_e32 v22, v22, v42, vcc
		v_cmp_ge_u32_e64 vcc, v22, v26
		v_add_u32_e32 v42, v22, v28
		v_and_b32_e32 v49, 1, v0
		v_cndmask_b32_e32 v22, v22, v42, vcc
		v_xad_u32 v42, v22, -1, 1
		v_cndmask_b32_e64 v22, v22, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v42, v23, -1, 1
		v_cndmask_b32_e32 v23, v23, v42, vcc
		v_mul_hi_u32 v42, v23, v27
		v_mul_lo_u32 v42, v42, v26
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v23, 1, v42, v23
		v_cmp_ge_u32_e64 vcc, v23, v26
		v_add_u32_e32 v42, v23, v28
		v_mov_b32_e32 v50, 8
		v_mul_lo_u32 v50, v50, v49
		v_cndmask_b32_e32 v23, v23, v42, vcc
		v_cmp_ge_u32_e64 vcc, v23, v26
		v_add_u32_e32 v42, v23, v28
		v_mov_b32_e32 v49, s13
		v_cndmask_b32_e64 v41, v49, v41, s[34:35]
		v_cndmask_b32_e32 v23, v23, v42, vcc
		v_xad_u32 v42, v23, -1, 1
		v_cndmask_b32_e64 v23, v23, v42, s[36:37]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v42, v24, -1, 1
		v_cndmask_b32_e32 v24, v24, v42, vcc
		v_mul_hi_u32 v27, v24, v27
		v_mul_lo_u32 v27, v27, v26
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v24, 1, v27, v24
		v_cmp_ge_u32_e64 vcc, v24, v26
		v_add_u32_e32 v27, v24, v28
		v_mov_b32_e32 v42, 16
		v_mul_lo_u32 v42, v42, v48
		v_cndmask_b32_e32 v24, v24, v27, vcc
		v_cmp_ge_u32_e64 vcc, v24, v26
		v_add_u32_e32 v26, v24, v28
		v_readfirstlane_b32 s36, v0
		v_cndmask_b32_e32 v24, v24, v26, vcc
		v_xad_u32 v26, v24, -1, 1
		v_cndmask_b32_e64 v24, v24, v26, s[34:35]
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v26, v15, -1, 1
		v_cndmask_b32_e32 v15, v15, v26, vcc
		v_cvt_f32_u32_e32 v26, v41
		v_rcp_iflag_f32_e32 v26, v26
		s_lshr_b32 s40, s36, 6
		v_mul_f32_e32 v2, v2, v26
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v26, v41, -1, 1
		v_mul_lo_u32 v27, v26, v2
		v_mul_hi_u32 v27, v2, v27
		v_add_u32_e32 v2, v2, v27
		v_mul_hi_u32 v27, v15, v2
		v_mul_lo_u32 v27, v27, v41
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v15, 1, v27, v15
		v_cmp_ge_u32_e64 vcc, v15, v41
		v_add_u32_e32 v27, v15, v26
		s_mul_i32 s41, 0x420, s40
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_cmp_ge_u32_e64 vcc, v15, v41
		v_add_u32_e32 v27, v15, v26
		s_mov_b32 m0, s41
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_xad_u32 v27, v15, -1, 1
		v_cndmask_b32_e64 v15, v15, v27, s[34:35]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v27, v16, -1, 1
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_mul_hi_u32 v2, v16, v2
		v_mul_lo_u32 v2, v2, v41
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v16
		v_cmp_ge_u32_e64 vcc, v2, v41
		v_add_u32_e32 v16, v2, v26
		v_lshlrev_b32_e32 v15, 1, v15
		v_cndmask_b32_e32 v2, v2, v16, vcc
		v_cmp_ge_u32_e64 vcc, v2, v41
		v_add_u32_e32 v16, v2, v26
		s_mul_i32 s42, 0x88, s17
		v_cndmask_b32_e32 v2, v2, v16, vcc
		v_xad_u32 v16, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v16, s[34:35]
		v_and_b32_e32 v16, 1, v47
		v_mov_b32_e32 v26, 32
		v_mul_lo_u32 v26, v26, v16
		v_bitop3_b32 v16, v50, v42, v26 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s14
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s44, s4
		s_mov_b32 s45, s5
		s_mov_b32 s46, s38
		s_mov_b32 s47, s39
		v_mov_b32_e32 v26, 0x80000000
		v_cndmask_b32_e32 v27, v26, v45, vcc
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		v_cndmask_b32_e32 v27, v26, v46, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v28, v30, v31, s[24:25]
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_ashr_i32 s2, s23, 6
		v_cmp_lt_i32_e64 vcc, v12, s14
		v_mul_lo_u32 v27, s17, v13
		v_lshl_add_u32 v27, v27, 3, v15
		v_mul_lo_u32 v30, s17, v8
		v_lshl_add_u32 v27, v30, 1, v27
		v_mul_lo_u32 v30, s17, v6
		v_lshl_add_u32 v27, v30, 6, v27
		v_and_b32_e32 v30, 1, v3
		v_mul_lo_u32 v30, s17, v30
		v_lshl_add_u32 v27, v30, 5, v27
		v_add_u32_e32 v30, s42, v27
		v_cndmask_b32_e32 v31, v26, v27, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v32, v32, v38, s[30:31]
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_lshl_b32 s3, s17, 3
		v_add_u32_e32 v31, s3, v27
		v_cndmask_b32_e32 v31, v26, v31, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v38, 7, v47
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_add_i32 s3, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v16, s3
		v_add_u32_e32 v31, 0x80, v45
		s_lshl_b32 s4, s15, 1
		v_cndmask_b32_e32 v31, v26, v31, vcc
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e64 v33, v33, v39, s[32:33]
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		v_add_u32_e32 v31, 0x80, v46
		v_cndmask_b32_e32 v31, v26, v31, vcc
		v_cmp_lt_i32_e64 vcc, v12, s3
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v34, v34, v40, s[26:27]
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		v_cmp_eq_u32_e64 s[24:25], v13, s22
		s_lshl_b32 s3, s17, 7
		v_add_u32_e32 v31, s3, v27
		v_cndmask_b32_e32 v31, v26, v31, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e32 v30, v26, v30, vcc
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		v_add_u32_e32 v31, 0x100, v45
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v35, v35, v43, s[28:29]
		buffer_load_dwordx4 v30, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v30, 8, v6
		s_add_i32 s3, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v16, s3
		v_and_b32_e32 v39, 3, v8
		s_add_i32 m0, m0, 0xffff5b20
		v_cndmask_b32_e32 v31, v26, v31, vcc
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		v_add_u32_e32 v31, 0x100, v46
		v_cndmask_b32_e32 v31, v26, v31, vcc
		v_cmp_lt_i32_e64 vcc, v12, s3
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v40, 3, v0
		v_lshlrev_b32_e32 v39, 5, v39
		v_lshl_add_u32 v39, v40, 3, v39
		s_lshl_b32 s3, s17, 8
		v_add_u32_e32 v40, s3, v27
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		v_cndmask_b32_e32 v31, v26, v40, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_and_b32_e32 v40, 63, v0
		s_mul_i32 s3, 0x108, s17
		v_add_u32_e32 v41, s3, v27
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v31, v26, v41, vcc
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v41, 7, v13
		v_mov_b32_e32 v42, 0x420
		v_mul_lo_u32 v42, v42, v38
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v31, 4, v40
		v_lshlrev_b32_e32 v38, 4, v31
		v_and_b32_e32 v43, 15, v40
		v_mov_b32_e32 v45, 0x420
		v_mul_lo_u32 v45, v45, v43
		v_add3_u32 v38, v41, v38, v45
		ds_read_b128 v[48:51], v38
		ds_read_b128 v[52:55], v38 offset:64
		ds_read_b128 v[56:59], v38 offset:256
		ds_read_b128 v[60:63], v38 offset:320
		ds_read_b128 v[64:67], v38 offset:512
		ds_read_b128 v[68:71], v38 offset:576
		ds_read_b128 v[72:75], v38 offset:768
		ds_read_b128 v[76:79], v38 offset:832
		v_add3_u32 v30, v39, v30, v42
		ds_read_b64_tr_b16 v[80:81], v30 offset:50656
		ds_read_b64_tr_b16 v[82:83], v30 offset:59104
		ds_read_b64_tr_b16 v[84:85], v30 offset:51168
		ds_read_b64_tr_b16 v[86:87], v30 offset:59616
		ds_read_b64_tr_b16 v[88:89], v30 offset:50784
		ds_read_b64_tr_b16 v[90:91], v30 offset:59232
		ds_read_b64_tr_b16 v[92:93], v30 offset:51296
		ds_read_b64_tr_b16 v[94:95], v30 offset:59744
		s_add_i32 s3, s2, -3
		v_cmp_ne_u32_e64 vcc, v13, s22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_0:
		s_mov_b64 exec, s[48:49]
		s_setprio 0
		v_add_u32_e32 v39, 0x180, v44
		v_mul_lo_u32 v25, s4, v25
		v_mul_lo_u32 v5, s4, v5
		v_add_u32_e32 v41, v39, v25
		v_add_u32_e32 v25, v39, v5
		s_mul_i32 s4, 0x180, s17
		s_mul_i32 s5, 0x188, s17
		s_cmp_lt_i32 0, s3
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
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
		s_mov_b32 s15, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[96:99], v[88:91], v[48:51], v[96:99]
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[56:59], v[100:103]
		s_cmp_ge_u32 s15, 2
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[64:67], v[108:111]
		s_cselect_b32 s23, 1, 0
		s_add_i32 s26, s15, -2
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		s_add_i32 s27, s15, 1
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s26, s27
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[72:75], v[116:119]
		s_add_i32 s26, s22, 3
		v_mfma_f32_16x16x32_f16 v[44:47], v[84:87], v[52:55], v[44:47]
		s_mul_i32 s26, s26, 64
		v_mfma_f32_16x16x32_f16 v[96:99], v[92:95], v[52:55], v[96:99]
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[60:63], v[100:103]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[68:71], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[76:79], v[116:119]
		s_setprio 1
		s_barrier
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		s_add_i32 s26, s14, s26
		v_cmp_lt_i32_e64 vcc, v16, s26
		s_lshl_b32 s27, s22, 7
		s_mul_i32 s15, 0x4200, s15
		v_cndmask_b32_e32 v5, v26, v41, vcc
		v_cndmask_b32_e32 v39, v26, v25, vcc
		v_cmp_lt_i32_e64 vcc, v12, s26
		s_add_i32 s15, s41, s15
		s_mov_b32 m0, s15
		s_mul_i32 s15, 0x4200, s23
		buffer_load_dwordx4 v5, s[36:39], s27 offen lds
		s_mul_i32 s26, s17, s22
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s26, s26, 7
		buffer_load_dwordx4 v39, s[36:39], s27 offen lds
		s_add_i32 s27, s4, s26
		v_add_u32_e32 v5, s27, v27
		v_cndmask_b32_e32 v5, v26, v5, vcc
		s_add_i32 m0, m0, 0xa4e0
		v_add_u32_e32 v39, s15, v38
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		s_add_i32 s26, s5, s26
		v_add_u32_e32 v5, s26, v27
		v_cndmask_b32_e32 v5, v26, v5, vcc
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v42, s15, v30
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(4)
		ds_read_b128 v[48:51], v39
		ds_read_b128 v[52:55], v39 offset:64
		ds_read_b128 v[56:59], v39 offset:256
		ds_read_b128 v[60:63], v39 offset:320
		ds_read_b128 v[64:67], v39 offset:512
		ds_read_b128 v[68:71], v39 offset:576
		ds_read_b128 v[72:75], v39 offset:768
		ds_read_b128 v[76:79], v39 offset:832
		ds_read_b64_tr_b16 v[80:81], v42 offset:50656
		ds_read_b64_tr_b16 v[82:83], v42 offset:59104
		ds_read_b64_tr_b16 v[84:85], v42 offset:51168
		ds_read_b64_tr_b16 v[86:87], v42 offset:59616
		ds_read_b64_tr_b16 v[88:89], v42 offset:50784
		ds_read_b64_tr_b16 v[90:91], v42 offset:59232
		ds_read_b64_tr_b16 v[92:93], v42 offset:51296
		ds_read_b64_tr_b16 v[94:95], v42 offset:59744
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s22, s3
		s_mov_b32 s15, s23
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[48:49], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_1:
		s_mov_b64 exec, s[48:49]
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_lshl_add_u32 v5, v13, 8, v31
		s_mul_i32 s3, 0x108, s40
		s_add_i32 m0, s3, 0x18bc0
		v_add_lshl_u32 v12, v2, v29, 1
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s38
		s_mov_b32 s31, s39
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v28
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v32
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v33
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v34
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v35
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v36
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mul_lo_u32 v12, s18, v37
		s_add_i32 m0, m0, 0x840
		v_add_lshl_u32 v12, v2, v12, 1
		v_mul_lo_u32 v13, s18, v17
		v_add_lshl_u32 v13, v2, v13, 1
		v_mul_lo_u32 v17, s18, v18
		v_add_lshl_u32 v17, v2, v17, 1
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
		v_add_lshl_u32 v2, v2, v23, 1
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[96:99], v[88:91], v[48:51], v[96:99]
		buffer_load_dword v12, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[56:59], v[100:103]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[64:67], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[72:75], v[116:119]
		buffer_load_dword v13, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[44:47], v[84:87], v[52:55], v[44:47]
		v_mfma_f32_16x16x32_f16 v[96:99], v[92:95], v[52:55], v[96:99]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[60:63], v[100:103]
		buffer_load_dword v17, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[68:71], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		s_add_i32 m0, m0, 0x840
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[76:79], v[116:119]
		buffer_load_dword v18, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v6, 1, v6
		s_add_i32 m0, m0, 0x840
		v_and_b32_e32 v8, 1, v8
		buffer_load_dword v19, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v8, 2, v8
		s_add_i32 m0, m0, 0x840
		v_and_b32_e32 v10, 1, v10
		buffer_load_dword v20, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v10, 3, v10
		s_add_i32 m0, m0, 0x840
		v_add3_u32 v5, v5, v10, v8
		buffer_load_dword v21, s[28:31], 0 offen lds
		v_xor_b32_e32 v8, v8, v10
		s_add_i32 m0, m0, 0x840
		v_bitop3_b32 v6, v0, v6, v8 bitop3:0x96
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v7
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v9
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v11
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v14
		v_lshlrev_b32_e32 v11, 4, v6
		buffer_load_dword v22, s[28:31], 0 offen lds
		v_xor_b32_e32 v6, 1, v6
		s_add_i32 m0, m0, 0x840
		v_lshlrev_b32_e32 v6, 4, v6
		v_mov_b32_e32 v12, 64
		v_mul_lo_u32 v12, v12, v1
		v_xad_u32 v1, v16, v12, s20
		s_add_i32 s3, s2, -2
		buffer_load_dword v2, s[28:31], 0 offen lds
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
		v_cmp_lt_i32_e64 s[4:5], v1, s13
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
		buffer_load_dwordx4 v[16:19], v15, s[8:11], 0 offen
		v_add_u32_e32 v1, s3, v38
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[20:23], v1 offset:64
		ds_read_b128 v[24:27], v1 offset:256
		ds_read_b128 v[32:35], v1 offset:320
		ds_read_b128 v[48:51], v1 offset:512
		ds_read_b128 v[52:55], v1 offset:576
		ds_read_b128 v[56:59], v1 offset:768
		ds_read_b128 v[60:63], v1 offset:832
		v_add_u32_e32 v1, s3, v30
		ds_read_b64_tr_b16 v[64:65], v1 offset:50656
		ds_read_b64_tr_b16 v[66:67], v1 offset:59104
		ds_read_b64_tr_b16 v[68:69], v1 offset:51168
		ds_read_b64_tr_b16 v[70:71], v1 offset:59616
		ds_read_b64_tr_b16 v[72:73], v1 offset:50784
		ds_read_b64_tr_b16 v[74:75], v1 offset:59232
		ds_read_b64_tr_b16 v[76:77], v1 offset:51296
		ds_read_b64_tr_b16 v[78:79], v1 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[44:47], v[64:67], v[12:15], v[44:47]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[24:27], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[12:15], v[96:99]
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_cselect_b32 s6, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[24:27], v[104:107]
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[48:51], v[108:111]
		s_xor_b32 s3, s2, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s6, 0
		s_cselect_b32 s2, s3, s2
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[48:51], v[112:115]
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v1, s2, v38
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[44:47], v[68:71], v[20:23], v[44:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[60:63], v[116:119]
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[20:23], v1 offset:64
		ds_read_b128 v[24:27], v1 offset:256
		ds_read_b128 v[32:35], v1 offset:320
		ds_read_b128 v[36:39], v1 offset:512
		ds_read_b128 v[48:51], v1 offset:576
		ds_read_b128 v[52:55], v1 offset:768
		ds_read_b128 v[56:59], v1 offset:832
		v_add_u32_e32 v1, s2, v30
		ds_read_b64_tr_b16 v[28:29], v1 offset:50656
		ds_read_b64_tr_b16 v[30:31], v1 offset:59104
		ds_read_b64_tr_b16 v[60:61], v1 offset:51168
		ds_read_b64_tr_b16 v[62:63], v1 offset:59616
		ds_read_b64_tr_b16 v[64:65], v1 offset:50784
		ds_read_b64_tr_b16 v[66:67], v1 offset:59232
		ds_read_b64_tr_b16 v[68:69], v1 offset:51296
		ds_read_b64_tr_b16 v[70:71], v1 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[44:47], v[28:31], v[12:15], v[44:47]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[24:27], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[24:27], v[104:107]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[108:111], v[28:31], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[28:31], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[44:47], v[60:63], v[20:23], v[44:47]
		s_nop 7
		ds_write_b128 v11, v[44:47]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		s_nop 7
		ds_write_b128 v6, v[96:99] offset:8192
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[60:63], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[48:51], v[112:115]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[60:63], v[56:59], v[116:119]
		v_lshrrev_b32_e32 v1, 3, v40
		v_and_b32_e32 v1, 1, v1
		v_and_b32_e32 v2, 7, v40
		v_lshl_add_u32 v5, v2, 5, v5
		v_and_b32_e32 v12, 1, v0
		v_lshlrev_b32_e32 v12, 1, v12
		v_lshrrev_b32_e32 v13, 1, v40
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshrrev_b32_e32 v2, 2, v2
		v_lshlrev_b32_e32 v2, 3, v2
		v_bitop3_b32 v2, v13, v2, v1 bitop3:0x96
		v_bitop3_b32 v2, v5, v12, v2 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_lshl_add_u32 v1, v1, 13, v2
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[20:23], v1 offset:256
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v24, v16
		v_cvt_f32_f16_sdwa v25, v16 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v26, v17
		v_cvt_f32_f16_sdwa v27, v17 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v11, v[100:103]
		ds_write_b128 v6, v[104:107] offset:8192
		v_pk_add_f32 v[12:13], v[12:13], v[24:25]
		v_pk_add_f32 v[14:15], v[14:15], v[26:27]
		v_cvt_f32_f16_e32 v16, v18
		v_cvt_f32_f16_sdwa v17, v18 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[32:35], v1 offset:256
		v_pk_add_f32 v[20:21], v[20:21], v[16:17]
		v_cvt_f32_f16_e32 v36, v19
		v_cvt_f32_f16_sdwa v37, v19 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[18:19], v[22:23], v[36:37]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v11, v[108:111]
		ds_write_b128 v6, v[112:115] offset:8192
		v_pk_add_f32 v[22:23], v[28:29], v[24:25]
		v_pk_add_f32 v[28:29], v[30:31], v[26:27]
		v_pk_add_f32 v[30:31], v[32:33], v[16:17]
		v_pk_add_f32 v[32:33], v[34:35], v[36:37]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:256
		v_bitop3_b32 v2, v4, v8, v7 bitop3:0x96
		v_xor_b32_e32 v2, v2, v9
		v_xad_u32 v2, v2, v10, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[34:35], v[40:41], v[24:25]
		v_cmp_lt_i32_e64 s[2:3], v2, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v11, v[116:119]
		ds_write_b128 v6, v[120:123] offset:8192
		v_pk_add_f32 v[38:39], v[42:43], v[26:27]
		v_pk_add_f32 v[40:41], v[44:45], v[16:17]
		v_pk_add_f32 v[42:43], v[46:47], v[36:37]
		s_and_b64 s[2:3], s[2:3], s[4:5]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v1
		ds_read_b128 v[48:51], v1 offset:256
		v_bitop3_b32 v1, 32, v4, v8 bitop3:0x96
		v_bitop3_b32 v1, v1, v7, v9 bitop3:0x96
		v_xad_u32 v1, v1, v10, s16
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[24:25], v[44:45], v[24:25]
		v_pk_add_f32 v[26:27], v[46:47], v[26:27]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[16:17], v[48:49], v[16:17]
		v_pk_add_f32 v[36:37], v[50:51], v[36:37]
		v_bitop3_b32 v2, 64, v4, v8 bitop3:0x96
		v_bitop3_b32 v2, v2, v7, v9 bitop3:0x96
		v_xor_b32_e32 v4, 0x60, v4
		v_xor_b32_e32 v4, v4, v8
		v_xor_b32_e32 v4, v4, v7
		v_xor_b32_e32 v4, v4, v9
		v_lshlrev_b32_e32 v5, 4, v0
		v_add_u32_e32 v5, 0x10000, v5
		v_lshl_add_u32 v5, v3, 3, v5
		ds_read_b128 v[44:47], v5 offset:35776
		v_mov_b32_e32 v5, 0x108
		v_mul_lo_u32 v5, v5, v3
		v_add_u32_e32 v5, 0x10000, v5
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v5, v5, v0
		ds_read_b128 v[48:51], v5 offset:44224
		v_cmp_lt_i32_e64 s[6:7], v1, s12
		ds_read_b128 v[52:55], v5 offset:52672
		ds_read_b128 v[56:59], v5 offset:61120
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v6, v44
		v_cvt_f32_f16_sdwa v7, v44 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[8:9], v[12:13], v[6:7], v[12:13]
		v_cvt_pk_f16_f32 v60, v8, v9
		v_cvt_f32_f16_e32 v6, v45
		v_cvt_f32_f16_sdwa v7, v45 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[8:9], v[14:15], v[6:7], v[14:15]
		v_cvt_pk_f16_f32 v61, v8, v9
		v_cvt_f32_f16_e32 v6, v46
		v_cvt_f32_f16_sdwa v7, v46 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[8:9], v[20:21], v[6:7], v[20:21]
		v_cvt_f32_f16_e32 v6, v47
		v_cvt_f32_f16_sdwa v7, v47 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[12:13], v[18:19], v[6:7], v[18:19]
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v6, v48
		v_cvt_f32_f16_sdwa v7, v48 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v14, v49
		v_cvt_f32_f16_sdwa v15, v49 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[18:19], v[22:23], v[6:7], v[22:23]
		v_cvt_f32_f16_e32 v6, v50
		v_cvt_f32_f16_sdwa v7, v50 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v20, v51
		v_cvt_f32_f16_sdwa v21, v51 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[22:23], v[28:29], v[14:15], v[28:29]
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v14, v52
		v_cvt_f32_f16_sdwa v15, v52 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v28, v53
		v_cvt_f32_f16_sdwa v29, v53 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[44:45], v[30:31], v[6:7], v[30:31]
		v_cvt_f32_f16_e32 v6, v54
		v_cvt_f32_f16_sdwa v7, v54 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v30, v55
		v_cvt_f32_f16_sdwa v31, v55 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[46:47], v[32:33], v[20:21], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v20, v56
		v_cvt_f32_f16_sdwa v21, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v32, v57
		v_cvt_f32_f16_sdwa v33, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[48:49], v[34:35], v[14:15], v[34:35]
		v_cvt_f32_f16_e32 v14, v58
		v_cvt_f32_f16_sdwa v15, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v34, v59
		v_cvt_f32_f16_sdwa v35, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[50:51], v[38:39], v[28:29], v[38:39]
		v_pk_fma_f32 v[28:29], v[40:41], v[6:7], v[40:41]
		v_pk_fma_f32 v[6:7], v[42:43], v[30:31], v[42:43]
		v_pk_fma_f32 v[30:31], v[24:25], v[20:21], v[24:25]
		v_pk_fma_f32 v[20:21], v[26:27], v[32:33], v[26:27]
		v_pk_fma_f32 v[24:25], v[16:17], v[14:15], v[16:17]
		v_pk_fma_f32 v[14:15], v[36:37], v[34:35], v[36:37]
		v_xad_u32 v1, v2, v10, s16
		v_xad_u32 v2, v4, v10, s16
		v_cmp_lt_i32_e64 s[8:9], v1, s12
		v_cmp_lt_i32_e64 s[10:11], v2, s12
		s_and_b64 s[6:7], s[6:7], s[4:5]
		s_and_b64 s[8:9], s[8:9], s[4:5]
		s_and_b64 s[4:5], s[10:11], s[4:5]
		v_cvt_pk_f16_f32 v62, v8, v9
		v_cvt_pk_f16_f32 v63, v12, v13
		s_lshl_b32 s0, s0, 8
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 10
		s_add_i32 s10, s0, s1
		s_mul_i32 s11, s21, s19
		s_lshl_b32 s11, s11, 8
		s_add_i32 s10, s10, s11
		v_mul_lo_u32 v1, s19, v3
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v2, s10, v1, v0
		s_and_saveexec_b64 s[48:49], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_2
		buffer_store_dwordx4 v[60:63], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_2:
		s_andn2_b64 exec, s[48:49], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_2:
		s_mov_b64 exec, s[48:49]
		v_cvt_pk_f16_f32 v8, v18, v19
		v_cvt_pk_f16_f32 v9, v22, v23
		v_cvt_pk_f16_f32 v10, v44, v45
		v_cvt_pk_f16_f32 v11, v46, v47
		s_lshl_b32 s2, s19, 6
		s_add_i32 s2, s0, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s11
		v_add3_u32 v2, s2, v1, v0
		s_and_saveexec_b64 s[48:49], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_3
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_3:
		s_andn2_b64 exec, s[48:49], s[6:7]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_3:
		s_mov_b64 exec, s[48:49]
		s_nop 0
		v_cvt_pk_f16_f32 v8, v48, v49
		v_cvt_pk_f16_f32 v9, v50, v51
		v_cvt_pk_f16_f32 v10, v28, v29
		v_cvt_pk_f16_f32 v11, v6, v7
		s_lshl_b32 s2, s19, 7
		s_add_i32 s2, s0, s2
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s11
		v_add3_u32 v2, s2, v1, v0
		s_and_saveexec_b64 s[48:49], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_4
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_4:
		s_andn2_b64 exec, s[48:49], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_4:
		s_mov_b64 exec, s[48:49]
		v_cvt_pk_f16_f32 v4, v30, v31
		v_cvt_pk_f16_f32 v5, v20, v21
		v_cvt_pk_f16_f32 v6, v24, v25
		v_cvt_pk_f16_f32 v7, v14, v15
		s_mul_i32 s2, 0xc0, s19
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s11
		v_add3_u32 v0, s0, v1, v0
		s_and_saveexec_b64 s[48:49], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_else_5
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_optimized_async.exec_else_5:
		s_andn2_b64 exec, s[48:49], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5
.Ltlx_addmm_glu_kernel_optimized_async.exec_endif_5:
		s_mov_b64 exec, s[48:49]
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
		.amdhsa_next_free_vgpr 124
		.amdhsa_next_free_sgpr 50
		.amdhsa_accum_offset 124
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_vgpr, 124
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 50
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
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized_async.kd
    .uses_dynamic_stack: false
    .vgpr_count:     124
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
