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
		v_lshrrev_b32_e32 v12, 8, v0
		v_and_b32_e32 v14, 1, v12
		v_mad_u32_u24 v6, v14, 4, v6
		v_and_b32_e32 v15, 15, v0
		v_and_b32_e32 v16, 63, v0
		v_and_b32_e32 v17, 15, v4
		v_mov_b32_e32 v18, 4
		v_mul_lo_u32 v18, v18, v17
		v_and_b32_e32 v17, 7, v9
		v_add_u32_e32 v19, 0x48, v17
		v_add_u32_e32 v20, 0x50, v17
		v_add_u32_e32 v21, 0x58, v17
		v_add_u32_e32 v22, 0x60, v17
		v_add_u32_e32 v23, 0x68, v17
		v_add_u32_e32 v24, 0x70, v17
		v_add_u32_e32 v25, 0x78, v17
		v_and_b32_e32 v26, 1, v0
		v_lshrrev_b32_e32 v27, 1, v0
		v_and_b32_e32 v28, 1, v27
		v_mad_u32_u24 v26, v28, 2, v26
		v_lshrrev_b32_e32 v28, 2, v0
		v_and_b32_e32 v29, 1, v28
		v_mad_u32_u24 v26, v29, 4, v26
		v_mad_u32_u24 v3, v3, 8, v26
		v_mad_u32_u24 v3, v14, 16, v3
		v_add_u32_e32 v26, 0x60, v3
		v_add_u32_e32 v29, s16, v6
		s_mul_i32 s20, s0, 0x80
		s_mov_b32 s22, 0
		v_cmp_lt_i32_e64 vcc, v29, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v30, v29, -1, 1
		v_add3_u32 v6, 8, v6, s16
		v_cndmask_b32_e32 v29, v29, v30, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s26, -1
		s_mov_b32 s27, -1
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_xor_b32 s23, s12, -1
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v30, s12
		v_mov_b32_e32 v31, s23
		v_cndmask_b32_e64 v30, v30, v31, s[30:31]
		v_cvt_f32_u32_e32 v31, v30
		v_rcp_iflag_f32_e32 v31, v31
		v_xad_u32 v32, v30, -1, 1
		v_mul_f32_e32 v31, v2, v31
		v_cvt_u32_f32_e32 v31, v31
		v_mul_lo_u32 v33, v32, v31
		v_mul_hi_u32 v33, v31, v33
		v_add_u32_e32 v31, v31, v33
		v_mul_hi_u32 v33, v29, v31
		v_mul_lo_u32 v33, v33, v30
		v_xor_b32_e32 v33, -1, v33
		v_add3_u32 v29, 1, v33, v29
		v_add_u32_e32 v33, v29, v32
		v_cmp_ge_u32_e64 vcc, v29, v30
		v_add_u32_e32 v34, s16, v17
		v_add3_u32 v35, 8, v17, s16
		v_cndmask_b32_e32 v29, v29, v33, vcc
		v_add_u32_e32 v33, v29, v32
		v_cmp_ge_u32_e64 vcc, v29, v30
		v_add3_u32 v36, 16, v17, s16
		v_add3_u32 v37, 24, v17, s16
		v_cndmask_b32_e32 v29, v29, v33, vcc
		v_xad_u32 v33, v29, -1, 1
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v38, v6, -1, 1
		v_add3_u32 v39, 32, v17, s16
		v_cndmask_b32_e32 v6, v6, v38, vcc
		v_mul_hi_u32 v38, v6, v31
		v_mul_lo_u32 v38, v38, v30
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v6, 1, v38, v6
		v_add_u32_e32 v38, v6, v32
		v_cmp_ge_u32_e64 vcc, v6, v30
		v_add3_u32 v40, 40, v17, s16
		v_add3_u32 v41, 48, v17, s16
		v_cndmask_b32_e32 v6, v6, v38, vcc
		v_add_u32_e32 v38, v6, v32
		v_cmp_ge_u32_e64 vcc, v6, v30
		v_add3_u32 v42, 56, v17, s16
		v_add3_u32 v17, 64, v17, s16
		v_cndmask_b32_e32 v6, v6, v38, vcc
		v_xad_u32 v38, v6, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v43, v34, -1, 1
		v_add_u32_e32 v19, s16, v19
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_mul_hi_u32 v43, v34, v31
		v_mul_lo_u32 v43, v43, v30
		v_xor_b32_e32 v43, -1, v43
		v_add3_u32 v34, 1, v43, v34
		v_add_u32_e32 v43, v34, v32
		v_cmp_ge_u32_e64 vcc, v34, v30
		v_add_u32_e32 v20, s16, v20
		v_add_u32_e32 v21, s16, v21
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_add_u32_e32 v43, v34, v32
		v_cmp_ge_u32_e64 vcc, v34, v30
		v_add_u32_e32 v22, s16, v22
		v_add_u32_e32 v23, s16, v23
		v_cndmask_b32_e32 v34, v34, v43, vcc
		v_xad_u32 v43, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v44, v35, -1, 1
		v_add_u32_e32 v24, s16, v24
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_mul_hi_u32 v44, v35, v31
		v_mul_lo_u32 v44, v44, v30
		v_xor_b32_e32 v44, -1, v44
		v_add3_u32 v35, 1, v44, v35
		v_add_u32_e32 v44, v35, v32
		v_cmp_ge_u32_e64 vcc, v35, v30
		v_add_u32_e32 v25, s16, v25
		v_add_u32_e32 v45, s16, v3
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_add_u32_e32 v44, v35, v32
		v_cmp_ge_u32_e64 vcc, v35, v30
		v_add3_u32 v46, 32, v3, s16
		v_add3_u32 v3, 64, v3, s16
		v_cndmask_b32_e32 v35, v35, v44, vcc
		v_xad_u32 v44, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v47, v36, -1, 1
		v_add_u32_e32 v26, s16, v26
		v_cndmask_b32_e32 v36, v36, v47, vcc
		v_mul_hi_u32 v47, v36, v31
		v_mul_lo_u32 v47, v47, v30
		v_xor_b32_e32 v47, -1, v47
		v_add3_u32 v36, 1, v47, v36
		v_add_u32_e32 v47, v36, v32
		v_cmp_ge_u32_e64 vcc, v36, v30
		v_mad_u32_u24 v15, v15, 8, s20
		v_mad_u32_u24 v16, v16, 2, s20
		v_cndmask_b32_e32 v36, v36, v47, vcc
		v_add_u32_e32 v47, v36, v32
		v_cmp_ge_u32_e64 vcc, v36, v30
		v_add_u32_e32 v48, s20, v18
		v_add3_u32 v18, 64, v18, s20
		v_cndmask_b32_e32 v36, v36, v47, vcc
		v_xad_u32 v47, v36, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s22
		s_mov_b64 s[38:39], vcc
		v_xad_u32 v49, v37, -1, 1
		v_cndmask_b32_e64 v29, v29, v33, s[24:25]
		v_cndmask_b32_e32 v33, v37, v49, vcc
		v_mul_hi_u32 v37, v33, v31
		v_mul_lo_u32 v37, v37, v30
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v33, 1, v37, v33
		v_add_u32_e32 v37, v33, v32
		v_cmp_ge_u32_e64 vcc, v33, v30
		v_cndmask_b32_e64 v6, v6, v38, s[30:31]
		v_cndmask_b32_e64 v34, v34, v43, s[32:33]
		v_cndmask_b32_e32 v33, v33, v37, vcc
		v_add_u32_e32 v37, v33, v32
		v_cmp_ge_u32_e64 vcc, v33, v30
		v_cndmask_b32_e64 v35, v35, v44, s[34:35]
		v_cndmask_b32_e64 v36, v36, v47, s[36:37]
		v_cndmask_b32_e32 v33, v33, v37, vcc
		v_xad_u32 v37, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v39, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v38, v39, -1, 1
		v_cndmask_b32_e64 v33, v33, v37, s[38:39]
		v_cndmask_b32_e32 v37, v39, v38, vcc
		v_mul_hi_u32 v38, v37, v31
		v_mul_lo_u32 v38, v38, v30
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v37, 1, v38, v37
		v_cmp_ge_u32_e64 vcc, v37, v30
		v_add_u32_e32 v38, v37, v32
		v_and_b32_e32 v39, 15, v4
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_cmp_ge_u32_e64 vcc, v37, v30
		v_add_u32_e32 v38, v37, v32
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v43, s19, v12
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_xad_u32 v38, v37, -1, 1
		v_cmp_lt_i32_e64 vcc, v40, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v44, v40, -1, 1
		v_cndmask_b32_e64 v37, v37, v38, s[24:25]
		v_cndmask_b32_e32 v38, v40, v44, vcc
		v_mul_hi_u32 v40, v38, v31
		v_mul_lo_u32 v40, v40, v30
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v38, 1, v40, v38
		v_cmp_ge_u32_e64 vcc, v38, v30
		v_add_u32_e32 v40, v38, v32
		s_mul_i32 s16, s21, s19
		v_cndmask_b32_e32 v38, v38, v40, vcc
		v_cmp_ge_u32_e64 vcc, v38, v30
		v_add_u32_e32 v40, v38, v32
		s_mul_i32 s1, s1, s19
		v_cndmask_b32_e32 v38, v38, v40, vcc
		v_xad_u32 v40, v38, -1, 1
		v_cmp_lt_i32_e64 vcc, v41, s22
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v44, v41, -1, 1
		v_cndmask_b32_e64 v38, v38, v40, s[30:31]
		v_cndmask_b32_e32 v40, v41, v44, vcc
		v_mul_hi_u32 v41, v40, v31
		v_mul_lo_u32 v41, v41, v30
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v40, 1, v41, v40
		v_cmp_ge_u32_e64 vcc, v40, v30
		v_add_u32_e32 v41, v40, v32
		s_lshl_b32 s0, s0, 8
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_cmp_ge_u32_e64 vcc, v40, v30
		v_add_u32_e32 v41, v40, v32
		v_lshlrev_b32_e32 v44, 4, v12
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_xad_u32 v41, v40, -1, 1
		v_cmp_lt_i32_e64 vcc, v42, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v47, v42, -1, 1
		v_cndmask_b32_e64 v40, v40, v41, s[20:21]
		v_cndmask_b32_e32 v41, v42, v47, vcc
		v_mul_hi_u32 v42, v41, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v41, 1, v42, v41
		v_cmp_ge_u32_e64 vcc, v41, v30
		v_add_u32_e32 v42, v41, v32
		v_and_b32_e32 v1, 1, v1
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_cmp_ge_u32_e64 vcc, v41, v30
		v_add_u32_e32 v42, v41, v32
		v_mul_lo_u32 v40, s18, v40
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_xad_u32 v42, v41, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s22
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v47, v17, -1, 1
		v_cndmask_b32_e64 v41, v41, v42, s[24:25]
		v_cndmask_b32_e32 v17, v17, v47, vcc
		v_mul_hi_u32 v42, v17, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v17, 1, v42, v17
		v_cmp_ge_u32_e64 vcc, v17, v30
		v_add_u32_e32 v42, v17, v32
		v_mul_lo_u32 v38, s18, v38
		v_cndmask_b32_e32 v17, v17, v42, vcc
		v_cmp_ge_u32_e64 vcc, v17, v30
		v_add_u32_e32 v42, v17, v32
		v_mul_lo_u32 v37, s18, v37
		v_cndmask_b32_e32 v17, v17, v42, vcc
		v_xad_u32 v42, v17, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v47, v19, -1, 1
		v_cndmask_b32_e64 v17, v17, v42, s[20:21]
		v_cndmask_b32_e32 v19, v19, v47, vcc
		v_mul_hi_u32 v42, v19, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v19, 1, v42, v19
		v_cmp_ge_u32_e64 vcc, v19, v30
		v_add_u32_e32 v42, v19, v32
		v_mul_lo_u32 v33, s18, v33
		v_cndmask_b32_e32 v19, v19, v42, vcc
		v_cmp_ge_u32_e64 vcc, v19, v30
		v_add_u32_e32 v42, v19, v32
		v_mul_lo_u32 v36, s18, v36
		v_cndmask_b32_e32 v19, v19, v42, vcc
		v_xad_u32 v42, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v47, v20, -1, 1
		v_cndmask_b32_e64 v19, v19, v42, s[24:25]
		v_cndmask_b32_e32 v20, v20, v47, vcc
		v_mul_hi_u32 v42, v20, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v20, 1, v42, v20
		v_cmp_ge_u32_e64 vcc, v20, v30
		v_add_u32_e32 v42, v20, v32
		v_mul_lo_u32 v35, s18, v35
		v_cndmask_b32_e32 v20, v20, v42, vcc
		v_cmp_ge_u32_e64 vcc, v20, v30
		v_add_u32_e32 v42, v20, v32
		v_mul_lo_u32 v34, s18, v34
		v_cndmask_b32_e32 v20, v20, v42, vcc
		v_xad_u32 v42, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v47, v21, -1, 1
		v_cndmask_b32_e64 v20, v20, v42, s[20:21]
		v_cndmask_b32_e32 v21, v21, v47, vcc
		v_mul_hi_u32 v42, v21, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v21, 1, v42, v21
		v_cmp_ge_u32_e64 vcc, v21, v30
		v_add_u32_e32 v42, v21, v32
		s_lshl_b32 s20, s17, 3
		v_cndmask_b32_e32 v21, v21, v42, vcc
		v_cmp_ge_u32_e64 vcc, v21, v30
		v_add_u32_e32 v42, v21, v32
		v_and_b32_e32 v4, 1, v4
		v_cndmask_b32_e32 v21, v21, v42, vcc
		v_xad_u32 v42, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v47, v22, -1, 1
		v_cndmask_b32_e64 v21, v21, v42, s[24:25]
		v_cndmask_b32_e32 v22, v22, v47, vcc
		v_mul_hi_u32 v42, v22, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v22, 1, v42, v22
		v_cmp_ge_u32_e64 vcc, v22, v30
		v_add_u32_e32 v42, v22, v32
		v_and_b32_e32 v7, 1, v7
		v_cndmask_b32_e32 v22, v22, v42, vcc
		v_cmp_ge_u32_e64 vcc, v22, v30
		v_add_u32_e32 v42, v22, v32
		v_and_b32_e32 v47, 1, v9
		v_cndmask_b32_e32 v22, v22, v42, vcc
		v_xad_u32 v42, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v49, v23, -1, 1
		v_cndmask_b32_e64 v22, v22, v42, s[30:31]
		v_cndmask_b32_e32 v23, v23, v49, vcc
		v_mul_hi_u32 v42, v23, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v23, 1, v42, v23
		v_cmp_ge_u32_e64 vcc, v23, v30
		v_add_u32_e32 v42, v23, v32
		v_and_b32_e32 v11, 1, v11
		v_cndmask_b32_e32 v23, v23, v42, vcc
		v_cmp_ge_u32_e64 vcc, v23, v30
		v_add_u32_e32 v42, v23, v32
		v_mul_lo_u32 v49, s17, v12
		v_cndmask_b32_e32 v23, v23, v42, vcc
		v_xad_u32 v42, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v50, v24, -1, 1
		v_cndmask_b32_e64 v23, v23, v42, s[24:25]
		v_cndmask_b32_e32 v24, v24, v50, vcc
		v_mul_hi_u32 v42, v24, v31
		v_mul_lo_u32 v42, v42, v30
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v24, 1, v42, v24
		v_cmp_ge_u32_e64 vcc, v24, v30
		v_add_u32_e32 v42, v24, v32
		v_mul_lo_u32 v50, s15, v6
		v_cndmask_b32_e32 v24, v24, v42, vcc
		v_cmp_ge_u32_e64 vcc, v24, v30
		v_add_u32_e32 v42, v24, v32
		v_and_b32_e32 v27, 1, v27
		v_cndmask_b32_e32 v24, v24, v42, vcc
		v_xad_u32 v42, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v51, v25, -1, 1
		v_cndmask_b32_e64 v24, v24, v42, s[30:31]
		v_cndmask_b32_e32 v25, v25, v51, vcc
		v_mul_hi_u32 v31, v25, v31
		v_mul_lo_u32 v31, v31, v30
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v25, 1, v31, v25
		v_cmp_ge_u32_e64 vcc, v25, v30
		v_add_u32_e32 v31, v25, v32
		v_mov_b32_e32 v42, s13
		v_cndmask_b32_e32 v25, v25, v31, vcc
		v_cmp_ge_u32_e64 vcc, v25, v30
		v_add_u32_e32 v30, v25, v32
		s_xor_b32 s21, s13, -1
		v_cndmask_b32_e32 v25, v25, v30, vcc
		v_xad_u32 v30, v25, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v31, v15, -1, 1
		v_cndmask_b32_e64 v25, v25, v30, s[24:25]
		v_cndmask_b32_e32 v15, v15, v31, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s24, s26, s28
		s_cselect_b32 s25, s27, s29
		s_add_i32 s21, s21, 1
		v_mov_b32_e32 v30, s21
		v_cndmask_b32_e64 v30, v42, v30, s[24:25]
		v_cvt_f32_u32_e32 v31, v30
		v_rcp_iflag_f32_e32 v31, v31
		v_xad_u32 v32, v30, -1, 1
		v_mul_f32_e32 v2, v2, v31
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v31, v32, v2
		v_mul_hi_u32 v31, v2, v31
		v_add_u32_e32 v2, v2, v31
		v_mul_hi_u32 v31, v15, v2
		v_mul_lo_u32 v31, v31, v30
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v15, 1, v31, v15
		v_cmp_ge_u32_e64 vcc, v15, v30
		v_add_u32_e32 v31, v15, v32
		v_and_b32_e32 v28, 1, v28
		v_cndmask_b32_e32 v15, v15, v31, vcc
		v_cmp_ge_u32_e64 vcc, v15, v30
		v_add_u32_e32 v31, v15, v32
		v_and_b32_e32 v42, 1, v0
		v_cndmask_b32_e32 v15, v15, v31, vcc
		v_xad_u32 v31, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v51, v16, -1, 1
		v_cndmask_b32_e64 v15, v15, v31, s[30:31]
		v_cndmask_b32_e32 v16, v16, v51, vcc
		v_mul_hi_u32 v31, v16, v2
		v_mul_lo_u32 v31, v31, v30
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v16, 1, v31, v16
		v_cmp_ge_u32_e64 vcc, v16, v30
		v_add_u32_e32 v31, v16, v32
		v_mul_lo_u32 v51, s15, v29
		v_cndmask_b32_e32 v16, v16, v31, vcc
		v_cmp_ge_u32_e64 vcc, v16, v30
		v_add_u32_e32 v31, v16, v32
		s_mov_b32 s30, 0x7fffffff
		v_cndmask_b32_e32 v16, v16, v31, vcc
		v_xad_u32 v31, v16, -1, 1
		v_cmp_lt_i32_e64 vcc, v48, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v52, v48, -1, 1
		v_cndmask_b32_e64 v16, v16, v31, s[24:25]
		v_cndmask_b32_e32 v31, v48, v52, vcc
		v_mul_hi_u32 v52, v31, v2
		v_mul_lo_u32 v52, v52, v30
		v_xor_b32_e32 v52, -1, v52
		v_add3_u32 v31, 1, v52, v31
		v_cmp_ge_u32_e64 vcc, v31, v30
		v_add_u32_e32 v52, v31, v32
		v_mov_b32_e32 v53, 32
		v_mul_lo_u32 v53, v53, v8
		v_cndmask_b32_e32 v8, v31, v52, vcc
		v_cmp_ge_u32_e64 vcc, v8, v30
		v_add_u32_e32 v31, v8, v32
		v_and_b32_e32 v52, 7, v0
		v_cndmask_b32_e32 v8, v8, v31, vcc
		v_xad_u32 v31, v8, -1, 1
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v54, v18, -1, 1
		v_cndmask_b32_e64 v8, v8, v31, s[26:27]
		v_cndmask_b32_e32 v31, v18, v54, vcc
		v_mul_hi_u32 v2, v31, v2
		v_mul_lo_u32 v2, v2, v30
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v31
		v_cmp_ge_u32_e64 vcc, v2, v30
		v_add_u32_e32 v31, v2, v32
		s_mov_b32 s21, 63
		v_cndmask_b32_e32 v2, v2, v31, vcc
		v_cmp_ge_u32_e64 vcc, v2, v30
		v_add_u32_e32 v30, v2, v32
		s_add_i32 s23, s14, 63
		v_cndmask_b32_e32 v2, v2, v30, vcc
		v_xad_u32 v30, v2, -1, 1
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s21, s21, 0
		v_mov_b32_e32 v31, 8
		v_mul_lo_u32 v31, v31, v52
		v_mad_u32_u24 v5, v5, 16, v53
		v_add3_u32 v5, v5, v10, v13
		v_mad_u32_u24 v5, v14, 8, v5
		v_cmp_lt_i32_e64 vcc, v31, s14
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v10, 4, v42
		v_lshl_add_u32 v13, v51, 1, v10
		v_lshlrev_b32_e32 v14, 6, v28
		v_lshlrev_b32_e32 v32, 5, v27
		v_add3_u32 v13, v13, v14, v32
		v_mov_b32_e32 v51, 0x80000000
		v_cndmask_b32_e32 v52, v51, v13, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		v_mov_b32_e32 v53, 0
		buffer_load_dwordx4 v52, s[28:31], 0 offen lds
		v_lshl_add_u32 v50, v50, 1, v10
		v_add3_u32 v50, v50, v14, v32
		v_cndmask_b32_e32 v52, v51, v50, vcc
		s_add_i32 m0, s3, 0x2100
		s_add_i32 s4, s23, s21
		buffer_load_dwordx4 v52, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v5, s14
		s_mov_b64 s[26:27], vcc
		v_lshlrev_b32_e32 v49, 4, v49
		v_lshl_add_u32 v15, v15, 1, v49
		v_mul_lo_u32 v49, s17, v11
		v_lshl_add_u32 v15, v49, 2, v15
		v_mul_lo_u32 v49, s17, v47
		v_lshl_add_u32 v15, v49, 1, v15
		v_mul_lo_u32 v49, s17, v7
		v_lshl_add_u32 v15, v49, 6, v15
		v_mul_lo_u32 v49, s17, v4
		v_lshl_add_u32 v15, v49, 5, v15
		v_cndmask_b32_e64 v49, v51, v15, s[26:27]
		s_add_i32 m0, s3, 0xc5e0
		v_cndmask_b32_e64 v2, v2, v30, s[24:25]
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		v_add_u32_e32 v30, 4, v5
		v_cmp_lt_i32_e64 vcc, v30, s14
		v_add_u32_e32 v49, s20, v15
		v_lshlrev_b32_e32 v16, 1, v16
		v_cndmask_b32_e32 v49, v51, v49, vcc
		s_add_i32 m0, s3, 0xe6e0
		s_ashr_i32 s4, s4, 6
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		s_add_i32 s5, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v31, s5
		v_add_u32_e32 v49, 0x80, v13
		s_lshl_b32 s15, s15, 1
		v_cndmask_b32_e32 v49, v51, v49, vcc
		s_add_i32 m0, s3, 0x4200
		v_mov_b32_e32 v52, 1
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		v_add_u32_e32 v49, 0x80, v50
		v_cndmask_b32_e32 v49, v51, v49, vcc
		s_add_i32 m0, s3, 0x6300
		s_lshl_b32 s20, s17, 7
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v5, s5
		s_mov_b64 s[24:25], vcc
		v_add_u32_e32 v49, s20, v15
		s_add_i32 m0, s3, 0x107e0
		v_cndmask_b32_e64 v49, v51, v49, s[24:25]
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		s_mul_i32 s20, 0x88, s17
		v_cmp_lt_i32_e64 vcc, v30, s5
		v_add_u32_e32 v49, s20, v15
		v_add3_u32 v10, v10, v14, v32
		v_cndmask_b32_e32 v14, v51, v49, vcc
		s_add_i32 m0, s3, 0x128e0
		v_mbcnt_lo_u32_b32 v32, -1, 0
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_add_i32 s5, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v31, s5
		v_add_u32_e32 v13, 0x100, v13
		v_and_b32_e32 v9, 3, v9
		v_cndmask_b32_e32 v13, v51, v13, vcc
		s_add_i32 m0, s3, 0x8400
		v_add_u32_e32 v14, 0x100, v50
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cndmask_b32_e32 v13, v51, v14, vcc
		s_add_i32 m0, s3, 0xa500
		s_lshl_b32 s20, s17, 8
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v5, s5
		s_mov_b64 s[24:25], vcc
		v_add_u32_e32 v13, s20, v15
		s_add_i32 m0, s3, 0x149e0
		v_cndmask_b32_e64 v13, v51, v13, s[24:25]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_mul_i32 s20, 0x108, s17
		v_cmp_lt_i32_e64 vcc, v30, s5
		v_add_u32_e32 v13, s20, v15
		v_and_b32_e32 v0, 63, v0
		v_cndmask_b32_e32 v13, v51, v13, vcc
		s_add_i32 m0, s3, 0x16ae0
		v_lshlrev_b32_e32 v14, 7, v12
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_lshrrev_b32_e32 v13, 4, v0
		v_lshlrev_b32_e32 v49, 4, v13
		v_and_b32_e32 v50, 15, v0
		v_mov_b32_e32 v54, 0x420
		v_mul_lo_u32 v54, v54, v50
		v_add3_u32 v14, v14, v49, v54
		ds_read_b128 v[56:59], v14
		ds_read_b128 v[60:63], v14 offset:64
		ds_read_b128 v[64:67], v14 offset:256
		ds_read_b128 v[68:71], v14 offset:320
		ds_read_b128 v[72:75], v14 offset:512
		ds_read_b128 v[76:79], v14 offset:576
		ds_read_b128 v[80:83], v14 offset:768
		ds_read_b128 v[84:87], v14 offset:832
		v_lshrrev_b32_e32 v0, 5, v0
		v_lshrrev_b32_e32 v49, 2, v50
		v_mov_b32_e32 v54, 0x420
		v_mul_lo_u32 v54, v54, v49
		v_lshl_add_u32 v0, v0, 8, v54
		v_lshlrev_b32_e32 v9, 5, v9
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v49, 0x1080
		v_mul_lo_u32 v49, v49, v13
		v_add3_u32 v0, v0, v9, v49
		v_and_b32_e32 v9, 3, v50
		v_lshl_add_u32 v0, v9, 3, v0
		ds_read_b64_tr_b16 v[88:89], v0 offset:50656
		ds_read_b64_tr_b16 v[90:91], v0 offset:59104
		ds_read_b64_tr_b16 v[92:93], v0 offset:51168
		ds_read_b64_tr_b16 v[94:95], v0 offset:59616
		ds_read_b64_tr_b16 v[96:97], v0 offset:50784
		ds_read_b64_tr_b16 v[98:99], v0 offset:59232
		ds_read_b64_tr_b16 v[100:101], v0 offset:51296
		ds_read_b64_tr_b16 v[102:103], v0 offset:59744
		s_add_i32 s5, s4, -3
		v_mbcnt_hi_u32_b32 v9, -1, v32
		v_add_u32_e32 v10, 0x180, v10
		v_mul_lo_u32 v13, s15, v29
		v_add_u32_e32 v29, v10, v13
		v_mul_lo_u32 v6, s15, v6
		v_add_u32_e32 v13, v10, v6
		s_mul_i32 s15, 0x180, s17
		s_mul_i32 s20, 0x188, s17
		s_cmp_lt_i32 0, s5
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
		s_mov_b32 s21, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		s_cmp_ge_u32 s21, 2
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s21, -2
		s_add_i32 s25, s21, 1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s24, s25
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s22, 3
		s_mul_i32 s27, s27, 64
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s27, s14, s27
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		v_cmp_lt_i32_e64 vcc, v31, s27
		s_lshl_b32 s36, s22, 7
		v_add_u32_e32 v6, s22, v9
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		v_cndmask_b32_e32 v10, v53, v52, vcc
		v_add_u32_e32 v10, v10, v6
		v_add_u32_e32 v32, 1, v6
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		v_cmp_eq_u32_e64 vcc, v10, v32
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[84:87], v[128:131]
		s_barrier
		s_mul_i32 s21, 0x4200, s21
		v_cndmask_b32_e32 v10, v51, v29, vcc
		s_add_i32 s21, s3, s21
		s_mov_b32 m0, s21
		v_cndmask_b32_e32 v49, v51, v13, vcc
		buffer_load_dwordx4 v10, s[28:31], s36 offen lds
		s_add_i32 m0, s21, 0x2100
		v_cmp_lt_i32_e64 vcc, v5, s27
		buffer_load_dwordx4 v49, s[28:31], s36 offen lds
		s_mul_i32 s36, s17, s22
		v_cndmask_b32_e32 v10, v53, v52, vcc
		v_add_u32_e32 v10, v10, v6
		v_cmp_eq_u32_e64 vcc, v10, v32
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v30, s27
		s_lshl_b32 s27, s36, 7
		s_add_i32 s36, s15, s27
		v_cndmask_b32_e32 v10, v53, v52, vcc
		v_add_u32_e32 v49, s36, v15
		s_add_i32 m0, s21, 0xc5e0
		v_cndmask_b32_e64 v49, v51, v49, s[38:39]
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		v_add_u32_e32 v6, v10, v6
		s_add_i32 s27, s20, s27
		v_cmp_eq_u32_e64 vcc, v6, v32
		v_add_u32_e32 v6, s27, v15
		s_add_i32 s22, s22, 1
		v_cndmask_b32_e32 v6, v51, v6, vcc
		s_add_i32 m0, s21, 0xe6e0
		s_mul_i32 s21, 0x4200, s23
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_add_u32_e32 v6, s21, v14
		ds_read_b128 v[56:59], v6
		ds_read_b128 v[60:63], v6 offset:64
		ds_read_b128 v[64:67], v6 offset:256
		ds_read_b128 v[68:71], v6 offset:320
		ds_read_b128 v[72:75], v6 offset:512
		ds_read_b128 v[76:79], v6 offset:576
		ds_read_b128 v[80:83], v6 offset:768
		ds_read_b128 v[84:87], v6 offset:832
		v_add_u32_e32 v6, s21, v0
		ds_read_b64_tr_b16 v[88:89], v6 offset:50656
		ds_read_b64_tr_b16 v[90:91], v6 offset:59104
		ds_read_b64_tr_b16 v[92:93], v6 offset:51168
		ds_read_b64_tr_b16 v[94:95], v6 offset:59616
		ds_read_b64_tr_b16 v[96:97], v6 offset:50784
		ds_read_b64_tr_b16 v[98:99], v6 offset:59232
		ds_read_b64_tr_b16 v[100:101], v6 offset:51296
		ds_read_b64_tr_b16 v[102:103], v6 offset:59744
		s_waitcnt vmcnt(4)
		s_barrier
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s21, s24, s25
		s_cmp_lt_i32 s22, s5
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_mul_i32 s2, 0x108, s2
		s_add_i32 m0, s2, 0x18bc0
		v_lshl_add_u32 v5, v34, 1, v16
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s30
		s_mov_b32 s23, s31
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x19400
		v_lshl_add_u32 v5, v35, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x19c40
		v_lshl_add_u32 v5, v36, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1a480
		v_lshl_add_u32 v5, v33, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1acc0
		v_lshl_add_u32 v5, v37, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1b500
		v_lshl_add_u32 v5, v38, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1bd40
		v_lshl_add_u32 v5, v40, 1, v16
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1c580
		v_mul_lo_u32 v5, s18, v41
		v_lshl_add_u32 v5, v5, 1, v16
		v_mul_lo_u32 v6, s18, v17
		v_lshl_add_u32 v6, v6, 1, v16
		v_mul_lo_u32 v9, s18, v19
		v_lshl_add_u32 v9, v9, 1, v16
		v_mul_lo_u32 v10, s18, v20
		v_lshl_add_u32 v10, v10, 1, v16
		v_mul_lo_u32 v13, s18, v21
		v_lshl_add_u32 v13, v13, 1, v16
		v_mul_lo_u32 v15, s18, v22
		v_lshl_add_u32 v15, v15, 1, v16
		v_mul_lo_u32 v17, s18, v23
		v_lshl_add_u32 v17, v17, 1, v16
		v_mul_lo_u32 v19, s18, v24
		v_lshl_add_u32 v19, v19, 1, v16
		v_mul_lo_u32 v20, s18, v25
		v_lshl_add_u32 v16, v20, 1, v16
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[56:59], v[104:107]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		buffer_load_dword v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1cdc0
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		buffer_load_dword v6, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1d600
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[60:63], v[104:107]
		buffer_load_dword v9, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1de40
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[60:63], v[108:111]
		buffer_load_dword v10, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1e680
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[68:71], v[116:119]
		buffer_load_dword v13, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1eec0
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[68:71], v[112:115]
		buffer_load_dword v15, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1f700
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[76:79], v[120:123]
		buffer_load_dword v17, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x1ff40
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[84:87], v[128:131]
		v_lshlrev_b32_e32 v5, 1, v8
		v_lshlrev_b32_e32 v2, 1, v2
		v_mov_b32_e32 v6, 0x1080
		v_mul_lo_u32 v6, v6, v12
		v_add_u32_e32 v6, 0x10000, v6
		v_mov_b32_e32 v8, 0x108
		v_mul_lo_u32 v8, v8, v42
		v_add_u32_e32 v6, v6, v8
		v_lshlrev_b32_e32 v8, 6, v11
		v_add_u32_e32 v9, v6, v8
		v_lshlrev_b32_e32 v10, 5, v47
		v_lshlrev_b32_e32 v12, 4, v7
		v_add3_u32 v9, v9, v10, v12
		v_lshlrev_b32_e32 v13, 3, v4
		v_mov_b32_e32 v15, 0x840
		v_mul_lo_u32 v15, v15, v1
		v_add3_u32 v9, v9, v13, v15
		v_mov_b32_e32 v17, 0x420
		v_mul_lo_u32 v17, v17, v28
		v_mov_b32_e32 v20, 0x210
		v_mul_lo_u32 v20, v20, v27
		v_add3_u32 v9, v9, v17, v20
		v_lshlrev_b32_e32 v11, 5, v11
		v_lshlrev_b32_e32 v21, 4, v47
		v_lshl_add_u32 v4, v4, 2, 64
		v_lshlrev_b32_e32 v7, 3, v7
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dword v19, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x20780
		s_add_i32 s2, s4, -2
		buffer_load_dword v16, s[20:23], 0 offen lds
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
		v_add_u32_e32 v7, s2, v14
		v_add_u32_e32 v16, s2, v0
		s_add_i32 s2, s4, -1
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s22, s30
		s_mov_b32 s23, s31
		buffer_load_dwordx2 v[22:23], v5, s[20:23], 0 offen
		buffer_load_dwordx2 v[24:25], v2, s[20:23], 0 offen
		ds_read_b128 v[32:35], v7
		ds_read_b128 v[52:55], v7 offset:64
		ds_read_b128 v[56:59], v7 offset:256
		ds_read_b128 v[60:63], v7 offset:320
		ds_read_b128 v[64:67], v7 offset:512
		ds_read_b128 v[68:71], v7 offset:576
		ds_read_b128 v[72:75], v7 offset:768
		ds_read_b128 v[76:79], v7 offset:832
		ds_read_b64_tr_b16 v[80:81], v16 offset:50656
		ds_read_b64_tr_b16 v[82:83], v16 offset:59104
		ds_read_b64_tr_b16 v[84:85], v16 offset:51168
		ds_read_b64_tr_b16 v[86:87], v16 offset:59616
		ds_read_b64_tr_b16 v[88:89], v16 offset:50784
		ds_read_b64_tr_b16 v[90:91], v16 offset:59232
		ds_read_b64_tr_b16 v[92:93], v16 offset:51296
		ds_read_b64_tr_b16 v[94:95], v16 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[56:59], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[32:35], v[108:111]
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[56:59], v[116:119]
		s_cselect_b32 s4, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[64:67], v[120:123]
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		s_xor_b32 s3, s2, -1
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[64:67], v[124:127]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s2, s3, s2
		s_mul_i32 s2, 0x4200, s2
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[72:75], v[132:135]
		v_add_u32_e32 v2, s2, v14
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[72:75], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[52:55], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[52:55], v2 offset:64
		ds_read_b128 v[56:59], v2 offset:256
		ds_read_b128 v[60:63], v2 offset:320
		ds_read_b128 v[64:67], v2 offset:512
		ds_read_b128 v[68:71], v2 offset:576
		ds_read_b128 v[72:75], v2 offset:768
		ds_read_b128 v[76:79], v2 offset:832
		v_add_u32_e32 v0, s2, v0
		ds_read_b64_tr_b16 v[80:81], v0 offset:50656
		ds_read_b64_tr_b16 v[82:83], v0 offset:59104
		ds_read_b64_tr_b16 v[84:85], v0 offset:51168
		ds_read_b64_tr_b16 v[86:87], v0 offset:59616
		ds_read_b64_tr_b16 v[88:89], v0 offset:50784
		ds_read_b64_tr_b16 v[90:91], v0 offset:59232
		ds_read_b64_tr_b16 v[92:93], v0 offset:51296
		ds_read_b64_tr_b16 v[94:95], v0 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[56:59], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[64:67], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[64:67], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[72:75], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[72:75], v[128:131]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[52:55], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v30, v22
		v_cvt_f32_f16_sdwa v31, v22 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v32, v23
		v_cvt_f32_f16_sdwa v33, v23 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v22, v24
		v_cvt_f32_f16_sdwa v23, v24 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v34, v25
		v_cvt_f32_f16_sdwa v35, v25 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[24:25], v[104:105], v[30:31]
		v_pk_add_f32 v[36:37], v[106:107], v[32:33]
		v_pk_add_f32 v[40:41], v[108:109], v[22:23]
		v_pk_add_f32 v[52:53], v[110:111], v[34:35]
		v_pk_add_f32 v[54:55], v[112:113], v[30:31]
		v_pk_add_f32 v[56:57], v[114:115], v[32:33]
		v_pk_add_f32 v[58:59], v[116:117], v[22:23]
		v_pk_add_f32 v[60:61], v[118:119], v[34:35]
		v_pk_add_f32 v[62:63], v[120:121], v[30:31]
		v_pk_add_f32 v[64:65], v[122:123], v[32:33]
		v_pk_add_f32 v[66:67], v[124:125], v[22:23]
		v_pk_add_f32 v[68:69], v[126:127], v[34:35]
		v_pk_add_f32 v[30:31], v[128:129], v[30:31]
		v_pk_add_f32 v[32:33], v[130:131], v[32:33]
		v_pk_add_f32 v[22:23], v[132:133], v[22:23]
		v_pk_add_f32 v[34:35], v[134:135], v[34:35]
		ds_read_b64 v[70:71], v9 offset:35776
		v_bitop3_b32 v0, v11, v21, v4 bitop3:0x96
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v4, 6, v4
		v_add3_u32 v5, v6, v2, v4
		v_lshrrev_b32_e32 v6, 4, v0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 5, v6
		v_add3_u32 v5, v5, v6, v15
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v5, v5, v7, v17
		v_lshrrev_b32_e32 v9, 2, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_add3_u32 v5, v5, v9, v20
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v5, v5, v11, v0
		ds_read_b64 v[14:15], v5 offset:35776
		v_add_u32_e32 v5, 0x10000, v8
		v_add_u32_e32 v5, v5, v10
		v_lshlrev_b32_e32 v8, 3, v1
		v_lshlrev_b32_e32 v10, 2, v28
		v_add_u32_e32 v16, 32, v42
		v_lshlrev_b32_e32 v17, 1, v27
		v_bitop3_b32 v16, v10, v16, v17 bitop3:0x96
		v_bitop3_b32 v16, v44, v8, v16 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v16
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 0x4200
		v_mul_lo_u32 v20, v20, v19
		v_add_u32_e32 v19, v5, v20
		v_lshrrev_b32_e32 v21, 5, v16
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v29, 0x2100
		v_mul_lo_u32 v29, v29, v21
		v_add3_u32 v19, v19, v12, v29
		v_lshrrev_b32_e32 v21, 4, v16
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v38, 0x1080
		v_mul_lo_u32 v38, v38, v21
		v_add3_u32 v19, v19, v13, v38
		v_lshrrev_b32_e32 v21, 3, v16
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v47, 0x840
		v_mul_lo_u32 v47, v47, v21
		v_lshrrev_b32_e32 v21, 2, v16
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v49, 0x420
		v_mul_lo_u32 v49, v49, v21
		v_add3_u32 v19, v19, v47, v49
		v_lshrrev_b32_e32 v21, 1, v16
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v50, 0x210
		v_mul_lo_u32 v50, v50, v21
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v21, 0x108
		v_mul_lo_u32 v21, v21, v16
		v_add3_u32 v16, v19, v50, v21
		ds_read_b64 v[72:73], v16 offset:35776
		v_add_u32_e32 v16, 0x10000, v20
		v_add_u32_e32 v16, v16, v2
		v_add3_u32 v16, v16, v29, v4
		v_add3_u32 v16, v16, v38, v6
		v_add3_u32 v16, v16, v47, v7
		v_add3_u32 v16, v16, v49, v9
		v_add3_u32 v16, v16, v50, v11
		v_add3_u32 v16, v16, v21, v0
		ds_read_b64 v[20:21], v16 offset:35776
		v_add_u32_e32 v16, 64, v42
		v_bitop3_b32 v16, v10, v16, v17 bitop3:0x96
		v_bitop3_b32 v16, v44, v8, v16 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v16
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v29, 0x4200
		v_mul_lo_u32 v29, v29, v19
		v_add_u32_e32 v19, v5, v29
		v_lshrrev_b32_e32 v38, 5, v16
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v47, 0x2100
		v_mul_lo_u32 v47, v47, v38
		v_add3_u32 v19, v19, v12, v47
		v_lshrrev_b32_e32 v38, 4, v16
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v49, 0x1080
		v_mul_lo_u32 v49, v49, v38
		v_add3_u32 v19, v19, v13, v49
		v_lshrrev_b32_e32 v38, 3, v16
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v50, 0x840
		v_mul_lo_u32 v50, v50, v38
		v_lshrrev_b32_e32 v38, 2, v16
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v74, 0x420
		v_mul_lo_u32 v74, v74, v38
		v_add3_u32 v19, v19, v50, v74
		v_lshrrev_b32_e32 v38, 1, v16
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v75, 0x210
		v_mul_lo_u32 v75, v75, v38
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v38, 0x108
		v_mul_lo_u32 v38, v38, v16
		v_add3_u32 v16, v19, v75, v38
		ds_read_b64 v[76:77], v16 offset:35776
		v_add_u32_e32 v16, 0x10000, v29
		v_add_u32_e32 v16, v16, v2
		v_add3_u32 v16, v16, v47, v4
		v_add3_u32 v16, v16, v49, v6
		v_add3_u32 v16, v16, v50, v7
		v_add3_u32 v16, v16, v74, v9
		v_add3_u32 v16, v16, v75, v11
		v_add3_u32 v16, v16, v38, v0
		ds_read_b64 v[74:75], v16 offset:35776
		v_add_u32_e32 v16, 0x60, v42
		v_bitop3_b32 v10, v10, v16, v17 bitop3:0x96
		v_bitop3_b32 v8, v44, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v10, 6, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x4200
		v_mul_lo_u32 v16, v16, v10
		v_add_u32_e32 v5, v5, v16
		v_lshrrev_b32_e32 v10, 5, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v17, 0x2100
		v_mul_lo_u32 v17, v17, v10
		v_add3_u32 v5, v5, v12, v17
		v_lshrrev_b32_e32 v10, 4, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v12, 0x1080
		v_mul_lo_u32 v12, v12, v10
		v_add3_u32 v5, v5, v13, v12
		v_lshrrev_b32_e32 v10, 3, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v13, 0x840
		v_mul_lo_u32 v13, v13, v10
		v_lshrrev_b32_e32 v10, 2, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v19, 0x420
		v_mul_lo_u32 v19, v19, v10
		v_add3_u32 v5, v5, v13, v19
		v_lshrrev_b32_e32 v10, 1, v8
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v29, 0x210
		v_mul_lo_u32 v29, v29, v10
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 0x108
		v_mul_lo_u32 v10, v10, v8
		v_add3_u32 v5, v5, v29, v10
		ds_read_b64 v[78:79], v5 offset:35776
		v_add_u32_e32 v5, 0x10000, v16
		v_add_u32_e32 v2, v5, v2
		v_add3_u32 v2, v2, v17, v4
		v_add3_u32 v2, v2, v12, v6
		v_add3_u32 v2, v2, v13, v7
		v_add3_u32 v2, v2, v19, v9
		v_add3_u32 v2, v2, v29, v11
		v_add3_u32 v0, v2, v10, v0
		ds_read_b64 v[4:5], v0 offset:35776
		s_waitcnt lgkmcnt(7)
		v_cvt_f32_f16_e32 v6, v70
		v_cvt_f32_f16_sdwa v7, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v8, v71
		v_cvt_f32_f16_sdwa v9, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(6)
		v_cvt_f32_f16_e32 v10, v14
		v_cvt_f32_f16_sdwa v11, v14 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v12, v15
		v_cvt_f32_f16_sdwa v13, v15 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(5)
		v_cvt_f32_f16_e32 v14, v72
		v_cvt_f32_f16_sdwa v15, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v16, v73
		v_cvt_f32_f16_sdwa v17, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(4)
		v_cvt_f32_f16_e32 v70, v20
		v_cvt_f32_f16_sdwa v71, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v21
		v_cvt_f32_f16_sdwa v73, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v20, v76
		v_cvt_f32_f16_sdwa v21, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v80, v77
		v_cvt_f32_f16_sdwa v81, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v76, v74
		v_cvt_f32_f16_sdwa v77, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v75
		v_cvt_f32_f16_sdwa v83, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v74, v78
		v_cvt_f32_f16_sdwa v75, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v84, v79
		v_cvt_f32_f16_sdwa v85, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v78, v4
		v_cvt_f32_f16_sdwa v79, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v5
		v_cvt_f32_f16_sdwa v87, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_fma_f32 v[4:5], v[24:25], v[6:7], v[24:25]
		v_pk_fma_f32 v[6:7], v[36:37], v[8:9], v[36:37]
		v_pk_fma_f32 v[8:9], v[40:41], v[10:11], v[40:41]
		v_pk_fma_f32 v[10:11], v[52:53], v[12:13], v[52:53]
		v_pk_fma_f32 v[12:13], v[54:55], v[14:15], v[54:55]
		v_pk_fma_f32 v[14:15], v[56:57], v[16:17], v[56:57]
		v_pk_fma_f32 v[16:17], v[58:59], v[70:71], v[58:59]
		v_pk_fma_f32 v[24:25], v[60:61], v[72:73], v[60:61]
		v_pk_fma_f32 v[36:37], v[62:63], v[20:21], v[62:63]
		v_pk_fma_f32 v[20:21], v[64:65], v[80:81], v[64:65]
		v_pk_fma_f32 v[40:41], v[66:67], v[76:77], v[66:67]
		v_pk_fma_f32 v[52:53], v[68:69], v[82:83], v[68:69]
		v_pk_fma_f32 v[54:55], v[30:31], v[74:75], v[30:31]
		v_pk_fma_f32 v[30:31], v[32:33], v[84:85], v[32:33]
		v_pk_fma_f32 v[32:33], v[22:23], v[78:79], v[22:23]
		v_pk_fma_f32 v[22:23], v[34:35], v[86:87], v[34:35]
		v_cmp_lt_i32_e64 vcc, v45, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v48, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v18, s13
		s_mov_b64 s[8:9], vcc
		s_and_b32 s14, s2, s8
		s_and_b32 s15, s3, s9
		v_cmp_lt_i32_e64 vcc, v46, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s20, s2, s4
		s_and_b32 s21, s3, s5
		s_and_b32 s22, s2, s8
		s_and_b32 s23, s3, s9
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s24, s2, s4
		s_and_b32 s25, s3, s5
		s_and_b32 s26, s2, s8
		s_and_b32 s27, s3, s9
		v_cmp_lt_i32_e64 vcc, v26, s12
		s_mov_b64 s[2:3], vcc
		s_and_b32 s12, s2, s4
		s_and_b32 s13, s3, s5
		s_and_b32 s4, s2, s8
		s_and_b32 s5, s3, s9
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_cvt_pk_f16_f32 v4, v8, v9
		v_cvt_pk_f16_f32 v5, v10, v11
		v_cvt_pk_f16_f32 v6, v12, v13
		v_cvt_pk_f16_f32 v7, v14, v15
		v_cvt_pk_f16_f32 v8, v16, v17
		v_cvt_pk_f16_f32 v9, v24, v25
		v_cvt_pk_f16_f32 v10, v36, v37
		v_cvt_pk_f16_f32 v11, v20, v21
		v_cvt_pk_f16_f32 v12, v40, v41
		v_cvt_pk_f16_f32 v13, v52, v53
		v_cvt_pk_f16_f32 v14, v54, v55
		v_cvt_pk_f16_f32 v15, v30, v31
		v_cvt_pk_f16_f32 v16, v32, v33
		v_cvt_pk_f16_f32 v17, v22, v23
		s_lshl_b32 s1, s1, 10
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s16, 8
		s_add_i32 s2, s2, s3
		v_lshlrev_b32_e32 v0, 5, v43
		v_mul_lo_u32 v18, s19, v42
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v19, s2, v0, v18
		v_mul_lo_u32 v1, s19, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v20, s19, v28
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v19, v19, v1, v20
		v_mul_lo_u32 v21, s19, v27
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshlrev_b32_e32 v22, 3, v39
		v_add3_u32 v19, v19, v21, v22
		v_cndmask_b32_e64 v19, v51, v19, s[6:7]
		s_mov_b32 s32, s10
		s_mov_b32 s33, s11
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		buffer_store_dwordx2 v[2:3], v19, s[32:35], 0 offen sc0 nt
		s_add_i32 s2, s0, 0x80
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		v_add3_u32 v2, s2, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[14:15]
		buffer_store_dwordx2 v[4:5], v2, s[32:35], 0 offen sc0 nt
		s_lshl_b32 s2, s19, 6
		s_add_i32 s6, s2, s0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		v_add3_u32 v2, s6, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[20:21]
		buffer_store_dwordx2 v[6:7], v2, s[32:35], 0 offen sc0 nt
		s_add_i32 s2, s2, 0x80
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		v_add3_u32 v2, s2, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[22:23]
		buffer_store_dwordx2 v[8:9], v2, s[32:35], 0 offen sc0 nt
		s_lshl_b32 s2, s19, 7
		s_add_i32 s6, s2, s0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		v_add3_u32 v2, s6, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[24:25]
		buffer_store_dwordx2 v[10:11], v2, s[32:35], 0 offen sc0 nt
		s_add_i32 s2, s2, 0x80
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		v_add3_u32 v2, s2, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[26:27]
		buffer_store_dwordx2 v[12:13], v2, s[32:35], 0 offen sc0 nt
		s_mul_i32 s2, 0xc0, s19
		s_add_i32 s6, s2, s0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		v_add3_u32 v2, s6, v0, v18
		v_add3_u32 v2, v2, v1, v20
		v_add3_u32 v2, v2, v21, v22
		v_cndmask_b32_e64 v2, v51, v2, s[12:13]
		buffer_store_dwordx2 v[14:15], v2, s[32:35], 0 offen sc0 nt
		s_add_i32 s2, s2, 0x80
		s_add_i32 s0, s2, s0
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		v_add3_u32 v0, s0, v0, v18
		v_add3_u32 v0, v0, v1, v20
		v_add3_u32 v0, v0, v21, v22
		v_cndmask_b32_e64 v0, v51, v0, s[4:5]
		buffer_store_dwordx2 v[16:17], v0, s[32:35], 0 offen sc0 nt
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
