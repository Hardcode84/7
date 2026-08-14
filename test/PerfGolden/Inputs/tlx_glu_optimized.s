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
		s_mul_i32 s1, s1, 8
		s_xor_b32 s20, s1, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 8
		s_cselect_b32 s0, s0, 8
		s_add_i32 s20, s16, s23
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s16, s20, s16
		s_xor_b32 s20, s16, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s20, s16
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s20, 1, 0
		s_xor_b32 s21, s16, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s21, s16
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s22, s22, s0
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s23, s22, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s23, s23, 1
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s25, s23, s24
		s_mul_hi_u32 s25, s24, s25
		s_add_i32 s24, s24, s25
		s_mul_hi_u32 s24, s20, s24
		s_mul_i32 s25, s24, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s20, s20, s25
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s20, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s26, s20
		s_cselect_b32 s25, 1, 0
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s20, s23
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s20, s23, s20
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s20, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s23, s20
		s_add_i32 s1, s1, s20
		s_add_i32 s20, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s20, s24
		s_add_i32 s21, s20, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s20, s21, s20
		s_xor_b32 s0, s16, s0
		s_xor_b32 s16, s20, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s16, s20
		s_mul_i32 s1, s1, 0x80
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
		v_and_b32_e32 v8, 1, v7
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v10
		v_add3_u32 v3, v3, v8, v11
		v_lshrrev_b32_e32 v10, 8, v0
		v_and_b32_e32 v12, 1, v10
		v_mad_u32_u24 v3, v12, 4, v3
		v_and_b32_e32 v13, 15, v5
		v_add_u32_e32 v14, 0x50, v13
		v_add_u32_e32 v15, 0x60, v13
		v_add_u32_e32 v16, 0x70, v13
		v_add_u32_e32 v17, s1, v3
		s_mov_b32 s16, 0
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v18, v17, -1, 1
		v_cndmask_b32_e32 v17, v17, v18, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		v_mov_b32_e32 v18, s12
		s_add_i32 s12, s28, 1
		v_mov_b32_e32 v19, s12
		v_cndmask_b32_e64 v18, v18, v19, s[26:27]
		v_cvt_f32_u32_e32 v19, v18
		v_rcp_iflag_f32_e32 v19, v19
		v_add3_u32 v3, 8, v3, s1
		v_mul_f32_e32 v19, v2, v19
		v_cvt_u32_f32_e32 v19, v19
		v_xad_u32 v20, v18, -1, 1
		v_mul_lo_u32 v21, v20, v19
		v_mul_hi_u32 v21, v19, v21
		v_add_u32_e32 v19, v19, v21
		v_mul_hi_u32 v21, v17, v19
		v_mul_lo_u32 v21, v21, v18
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v17, 1, v21, v17
		v_add_u32_e32 v21, v17, v20
		v_cmp_ge_u32_e64 vcc, v17, v18
		v_add_u32_e32 v22, s1, v13
		v_add_u32_e32 v14, s1, v14
		v_cndmask_b32_e32 v17, v17, v21, vcc
		v_add_u32_e32 v21, v17, v20
		v_cmp_ge_u32_e64 vcc, v17, v18
		v_add3_u32 v23, 16, v13, s1
		v_add3_u32 v24, 32, v13, s1
		v_cndmask_b32_e32 v17, v17, v21, vcc
		v_xad_u32 v21, v17, -1, 1
		v_cndmask_b32_e64 v17, v17, v21, s[20:21]
		v_cmp_lt_i32_e64 vcc, v3, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v21, v3, -1, 1
		v_cndmask_b32_e32 v3, v3, v21, vcc
		v_mul_hi_u32 v21, v3, v19
		v_mul_lo_u32 v21, v21, v18
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v3, 1, v21, v3
		v_add_u32_e32 v21, v3, v20
		v_cmp_ge_u32_e64 vcc, v3, v18
		v_add3_u32 v25, 48, v13, s1
		v_add3_u32 v13, 64, v13, s1
		v_cndmask_b32_e32 v3, v3, v21, vcc
		v_add_u32_e32 v21, v3, v20
		v_cmp_ge_u32_e64 vcc, v3, v18
		v_add_u32_e32 v15, s1, v15
		v_add_u32_e32 v16, s1, v16
		v_cndmask_b32_e32 v3, v3, v21, vcc
		v_xad_u32 v21, v3, -1, 1
		v_cndmask_b32_e64 v3, v3, v21, s[20:21]
		v_cmp_lt_i32_e64 vcc, v22, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v21, v22, -1, 1
		v_cndmask_b32_e32 v21, v22, v21, vcc
		v_mul_hi_u32 v22, v21, v19
		v_mul_lo_u32 v22, v22, v18
		v_xor_b32_e32 v22, -1, v22
		v_add3_u32 v21, 1, v22, v21
		v_add_u32_e32 v22, v21, v20
		v_cmp_ge_u32_e64 vcc, v21, v18
		s_mul_i32 s0, s0, 0x100
		v_mov_b32_e32 v26, 16
		v_mul_lo_u32 v26, v26, v6
		v_cndmask_b32_e32 v6, v21, v22, vcc
		v_cmp_ge_u32_e64 vcc, v6, v18
		v_add_u32_e32 v21, v6, v20
		v_mov_b32_e32 v22, 8
		v_mul_lo_u32 v22, v22, v12
		v_cndmask_b32_e32 v6, v6, v21, vcc
		v_xad_u32 v12, v6, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v21, v23, -1, 1
		v_cndmask_b32_e32 v21, v23, v21, vcc
		v_mul_hi_u32 v23, v21, v19
		v_mul_lo_u32 v23, v23, v18
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v21, 1, v23, v21
		v_cmp_ge_u32_e64 vcc, v21, v18
		v_add_u32_e32 v23, v21, v20
		v_and_b32_e32 v5, 1, v5
		v_cndmask_b32_e32 v21, v21, v23, vcc
		v_cmp_ge_u32_e64 vcc, v21, v18
		v_add_u32_e32 v23, v21, v20
		v_mul_lo_u32 v27, s15, v3
		v_cndmask_b32_e32 v21, v21, v23, vcc
		v_xad_u32 v23, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v28, v24, -1, 1
		v_cndmask_b32_e32 v24, v24, v28, vcc
		v_mul_hi_u32 v28, v24, v19
		v_mul_lo_u32 v28, v28, v18
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v24, 1, v28, v24
		v_cmp_ge_u32_e64 vcc, v24, v18
		v_add_u32_e32 v28, v24, v20
		v_and_b32_e32 v9, 1, v9
		v_cndmask_b32_e32 v24, v24, v28, vcc
		v_cmp_ge_u32_e64 vcc, v24, v18
		v_add_u32_e32 v28, v24, v20
		v_and_b32_e32 v29, 7, v0
		v_cndmask_b32_e32 v24, v24, v28, vcc
		v_xad_u32 v28, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v30, v25, -1, 1
		v_cndmask_b32_e32 v25, v25, v30, vcc
		v_mul_hi_u32 v30, v25, v19
		v_mul_lo_u32 v30, v30, v18
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v25, 1, v30, v25
		v_cmp_ge_u32_e64 vcc, v25, v18
		v_add_u32_e32 v30, v25, v20
		v_lshlrev_b32_e32 v9, 6, v9
		v_cndmask_b32_e32 v25, v25, v30, vcc
		v_cmp_ge_u32_e64 vcc, v25, v18
		v_add_u32_e32 v30, v25, v20
		v_mul_lo_u32 v31, s15, v17
		v_cndmask_b32_e32 v25, v25, v30, vcc
		v_xad_u32 v30, v25, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v32, v13, -1, 1
		v_cndmask_b32_e32 v13, v13, v32, vcc
		v_mul_hi_u32 v32, v13, v19
		v_mul_lo_u32 v32, v32, v18
		v_xor_b32_e32 v32, -1, v32
		v_add3_u32 v13, 1, v32, v13
		v_cmp_ge_u32_e64 vcc, v13, v18
		v_add_u32_e32 v32, v13, v20
		v_and_b32_e32 v4, 1, v4
		v_cndmask_b32_e32 v13, v13, v32, vcc
		v_cmp_ge_u32_e64 vcc, v13, v18
		v_add_u32_e32 v32, v13, v20
		v_mov_b32_e32 v33, s13
		v_cndmask_b32_e32 v13, v13, v32, vcc
		v_xad_u32 v32, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v34, v14, -1, 1
		v_cndmask_b32_e32 v14, v14, v34, vcc
		v_mul_hi_u32 v34, v14, v19
		v_mul_lo_u32 v34, v34, v18
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v14, 1, v34, v14
		v_cmp_ge_u32_e64 vcc, v14, v18
		v_add_u32_e32 v34, v14, v20
		v_mov_b32_e32 v35, 0x1080
		v_mul_lo_u32 v35, v35, v4
		v_cndmask_b32_e32 v4, v14, v34, vcc
		v_cmp_ge_u32_e64 vcc, v4, v18
		v_add_u32_e32 v14, v4, v20
		s_xor_b32 s1, s13, -1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		v_cndmask_b32_e32 v4, v4, v14, vcc
		v_xad_u32 v14, v4, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v34, v15, -1, 1
		v_cndmask_b32_e32 v15, v15, v34, vcc
		v_mul_hi_u32 v34, v15, v19
		v_mul_lo_u32 v34, v34, v18
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v15, 1, v34, v15
		v_cmp_ge_u32_e64 vcc, v15, v18
		v_add_u32_e32 v34, v15, v20
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v36, s1
		v_cndmask_b32_e64 v33, v33, v36, s[12:13]
		v_cndmask_b32_e32 v15, v15, v34, vcc
		v_cmp_ge_u32_e64 vcc, v15, v18
		v_add_u32_e32 v34, v15, v20
		v_and_b32_e32 v36, 31, v0
		v_cndmask_b32_e32 v15, v15, v34, vcc
		v_xad_u32 v34, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v37, v16, -1, 1
		v_cndmask_b32_e32 v16, v16, v37, vcc
		v_mul_hi_u32 v19, v16, v19
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v16, 1, v19, v16
		v_cmp_ge_u32_e64 vcc, v16, v18
		v_add_u32_e32 v19, v16, v20
		v_mov_b32_e32 v37, 8
		v_mul_lo_u32 v37, v37, v36
		v_cndmask_b32_e32 v16, v16, v19, vcc
		v_cmp_ge_u32_e64 vcc, v16, v18
		v_add_u32_e32 v18, v16, v20
		v_and_b32_e32 v1, 1, v1
		v_cndmask_b32_e32 v16, v16, v18, vcc
		v_xad_u32 v18, v16, -1, 1
		v_cndmask_b32_e64 v16, v16, v18, s[12:13]
		v_add_u32_e32 v18, s0, v37
		v_cmp_lt_i32_e64 vcc, v18, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v19, v18, -1, 1
		v_cndmask_b32_e32 v18, v18, v19, vcc
		v_cvt_f32_u32_e32 v19, v33
		v_rcp_iflag_f32_e32 v19, v19
		v_mov_b32_e32 v20, 0x840
		v_mul_lo_u32 v20, v20, v1
		v_mul_f32_e32 v1, v2, v19
		v_cvt_u32_f32_e32 v1, v1
		v_xad_u32 v2, v33, -1, 1
		v_mul_lo_u32 v19, v2, v1
		v_mul_hi_u32 v19, v1, v19
		v_add_u32_e32 v1, v1, v19
		v_mul_hi_u32 v19, v18, v1
		v_mul_lo_u32 v19, v19, v33
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v18, 1, v19, v18
		v_add_u32_e32 v19, v18, v2
		v_cmp_ge_u32_e64 vcc, v18, v33
		v_add3_u32 v36, 1, v37, s0
		s_mov_b32 s38, 0x7fffffff
		v_cndmask_b32_e32 v18, v18, v19, vcc
		v_add_u32_e32 v19, v18, v2
		v_cmp_ge_u32_e64 vcc, v18, v33
		v_add3_u32 v38, 2, v37, s0
		v_add3_u32 v39, 3, v37, s0
		v_cndmask_b32_e32 v18, v18, v19, vcc
		v_xad_u32 v19, v18, -1, 1
		v_cndmask_b32_e64 v18, v18, v19, s[12:13]
		v_cmp_lt_i32_e64 vcc, v36, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v19, v36, -1, 1
		v_cndmask_b32_e32 v19, v36, v19, vcc
		v_mul_hi_u32 v36, v19, v1
		v_mul_lo_u32 v36, v36, v33
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v19, 1, v36, v19
		v_add_u32_e32 v36, v19, v2
		v_cmp_ge_u32_e64 vcc, v19, v33
		v_add3_u32 v40, 4, v37, s0
		v_add3_u32 v41, 5, v37, s0
		v_cndmask_b32_e32 v19, v19, v36, vcc
		v_add_u32_e32 v36, v19, v2
		v_cmp_ge_u32_e64 vcc, v19, v33
		v_add3_u32 v42, 6, v37, s0
		v_add3_u32 v37, 7, v37, s0
		v_cndmask_b32_e32 v19, v19, v36, vcc
		v_xad_u32 v36, v19, -1, 1
		v_cndmask_b32_e64 v19, v19, v36, s[12:13]
		v_cmp_lt_i32_e64 vcc, v38, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v36, v38, -1, 1
		v_cndmask_b32_e32 v36, v38, v36, vcc
		v_mul_hi_u32 v38, v36, v1
		v_mul_lo_u32 v38, v38, v33
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v36, 1, v38, v36
		v_add_u32_e32 v38, v36, v2
		v_cmp_ge_u32_e64 vcc, v36, v33
		s_mov_b32 s12, 63
		s_add_i32 s13, s14, 63
		v_cndmask_b32_e32 v36, v36, v38, vcc
		v_cmp_ge_u32_e64 vcc, v36, v33
		v_add_u32_e32 v38, v36, v2
		s_cmp_lt_i32 s13, 0
		v_cndmask_b32_e32 v36, v36, v38, vcc
		v_xad_u32 v38, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v38, s[0:1]
		v_cmp_lt_i32_e64 vcc, v39, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v38, v39, -1, 1
		v_cndmask_b32_e32 v38, v39, v38, vcc
		v_mul_hi_u32 v39, v38, v1
		v_mul_lo_u32 v39, v39, v33
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v38, 1, v39, v38
		v_cmp_ge_u32_e64 vcc, v38, v33
		v_add_u32_e32 v39, v38, v2
		s_cselect_b32 s12, s12, 0
		s_add_i32 s12, s13, s12
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_cmp_ge_u32_e64 vcc, v38, v33
		v_add_u32_e32 v39, v38, v2
		v_lshrrev_b32_e32 v43, 2, v0
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_xad_u32 v39, v38, -1, 1
		v_cndmask_b32_e64 v38, v38, v39, s[0:1]
		v_cmp_lt_i32_e64 vcc, v40, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v39, v40, -1, 1
		v_cndmask_b32_e32 v39, v40, v39, vcc
		v_mul_hi_u32 v40, v39, v1
		v_mul_lo_u32 v40, v40, v33
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v39, 1, v40, v39
		v_cmp_ge_u32_e64 vcc, v39, v33
		v_add_u32_e32 v40, v39, v2
		v_readfirstlane_b32 s13, v0
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_cmp_ge_u32_e64 vcc, v39, v33
		v_add_u32_e32 v40, v39, v2
		v_lshrrev_b32_e32 v44, 1, v0
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_xad_u32 v40, v39, -1, 1
		v_cndmask_b32_e64 v39, v39, v40, s[0:1]
		v_cmp_lt_i32_e64 vcc, v41, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v40, v41, -1, 1
		v_cndmask_b32_e32 v40, v41, v40, vcc
		v_mul_hi_u32 v41, v40, v1
		v_mul_lo_u32 v41, v41, v33
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v40, 1, v41, v40
		v_cmp_ge_u32_e64 vcc, v40, v33
		v_add_u32_e32 v41, v40, v2
		v_and_b32_e32 v44, 1, v44
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_cmp_ge_u32_e64 vcc, v40, v33
		v_add_u32_e32 v41, v40, v2
		v_and_b32_e32 v45, 1, v0
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_xad_u32 v41, v40, -1, 1
		v_cndmask_b32_e64 v40, v40, v41, s[0:1]
		v_cmp_lt_i32_e64 vcc, v42, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v41, v42, -1, 1
		v_cndmask_b32_e32 v41, v42, v41, vcc
		v_mul_hi_u32 v42, v41, v1
		v_mul_lo_u32 v42, v42, v33
		v_xor_b32_e32 v42, -1, v42
		v_add3_u32 v41, 1, v42, v41
		v_cmp_ge_u32_e64 vcc, v41, v33
		v_add_u32_e32 v42, v41, v2
		v_mov_b32_e32 v46, 8
		v_mul_lo_u32 v46, v46, v45
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_cmp_ge_u32_e64 vcc, v41, v33
		v_add_u32_e32 v42, v41, v2
		v_mov_b32_e32 v45, 16
		v_mul_lo_u32 v45, v45, v44
		v_cndmask_b32_e32 v41, v41, v42, vcc
		v_xad_u32 v42, v41, -1, 1
		v_cndmask_b32_e64 v41, v41, v42, s[0:1]
		v_cmp_lt_i32_e64 vcc, v37, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v42, v37, -1, 1
		v_cndmask_b32_e32 v37, v37, v42, vcc
		v_mul_hi_u32 v1, v37, v1
		v_mul_lo_u32 v1, v1, v33
		v_xor_b32_e32 v1, -1, v1
		v_add3_u32 v1, 1, v1, v37
		v_cmp_ge_u32_e64 vcc, v1, v33
		v_add_u32_e32 v37, v1, v2
		s_lshr_b32 s13, s13, 6
		v_cndmask_b32_e32 v1, v1, v37, vcc
		v_cmp_ge_u32_e64 vcc, v1, v33
		v_add_u32_e32 v2, v1, v2
		s_mul_i32 s13, 0x420, s13
		v_cndmask_b32_e32 v1, v1, v2, vcc
		v_xad_u32 v2, v1, -1, 1
		v_cndmask_b32_e64 v1, v1, v2, s[0:1]
		v_and_b32_e32 v2, 1, v43
		v_mov_b32_e32 v33, 32
		v_mul_lo_u32 v33, v33, v2
		v_bitop3_b32 v2, v46, v45, v33 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v2, s14
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s38
		s_mov_b32 s3, s39
		v_lshlrev_b32_e32 v33, 3, v29
		v_add_lshl_u32 v37, v31, v33, 1
		v_mov_b32_e32 v42, 0x80000000
		v_cndmask_b32_e32 v37, v42, v37, vcc
		s_mov_b32 m0, s13
		v_and_b32_e32 v43, 1, v43
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		v_add_lshl_u32 v37, v27, v33, 1
		v_cndmask_b32_e32 v37, v42, v37, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v6, v6, v12, s[20:21]
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		s_ashr_i32 s4, s12, 6
		v_bitop3_b32 v12, v26, v8, v11 bitop3:0x96
		v_xor_b32_e32 v12, v12, v22
		v_bitop3_b32 v37, 4, v26, v8 bitop3:0x96
		v_bitop3_b32 v44, 32, v26, v8 bitop3:0x96
		v_bitop3_b32 v44, v44, v11, v22 bitop3:0x96
		v_bitop3_b32 v8, 36, v26, v8 bitop3:0x96
		v_cmp_lt_i32_e64 s[20:21], v12, s14
		v_cmp_lt_i32_e64 vcc, v44, s14
		v_lshlrev_b32_e32 v26, 1, v18
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v45, s17, v10
		v_lshlrev_b32_e32 v45, 3, v45
		v_add_u32_e32 v46, v26, v45
		v_mul_lo_u32 v47, s17, v7
		v_lshlrev_b32_e32 v47, 1, v47
		v_mul_lo_u32 v48, s17, v5
		v_lshlrev_b32_e32 v48, 5, v48
		v_add3_u32 v46, v46, v47, v48
		v_cndmask_b32_e64 v46, v42, v46, s[20:21]
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v21, v21, v23, s[26:27]
		buffer_load_dwordx4 v46, s[0:3], 0 offen lds
		v_bitop3_b32 v23, v37, v11, v22 bitop3:0x96
		s_lshl_b32 s5, s17, 3
		v_add3_u32 v37, v26, v45, v47
		v_add3_u32 v46, v48, v37, s5
		v_cndmask_b32_e64 v46, v42, v46, s[20:21]
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v24, v24, v28, s[28:29]
		buffer_load_dwordx4 v46, s[0:3], 0 offen lds
		v_bitop3_b32 v8, v8, v11, v22 bitop3:0x96
		s_lshl_b32 s5, s17, 6
		v_add3_u32 v11, v48, v37, s5
		v_cndmask_b32_e32 v11, v42, v11, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v22, v25, v30, s[30:31]
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_add3_u32 v11, v26, v45, v47
		s_mul_i32 s5, 0x48, s17
		v_add3_u32 v25, v48, v37, s5
		v_cndmask_b32_e32 v25, v42, v25, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v13, v13, v32, s[32:33]
		buffer_load_dwordx4 v25, s[0:3], 0 offen lds
		s_lshl_b32 s5, s17, 7
		v_add3_u32 v25, s5, v26, v45
		s_add_i32 s5, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v2, s5
		v_add_u32_e32 v28, 64, v31
		v_add_lshl_u32 v28, v28, v33, 1
		v_cndmask_b32_e32 v28, v42, v28, vcc
		s_add_i32 m0, m0, 0xffff1920
		v_cndmask_b32_e64 v4, v4, v14, s[34:35]
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_add_u32_e32 v14, 64, v27
		v_add_lshl_u32 v14, v14, v33, 1
		v_cndmask_b32_e32 v14, v42, v14, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v15, v15, v34, s[22:23]
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_cmp_lt_i32_e64 s[20:21], v12, s5
		v_cmp_lt_i32_e64 vcc, v44, s5
		v_add3_u32 v14, v25, v47, v48
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v14, v42, v14, s[20:21]
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mul_i32 s5, 0x88, s17
		v_add3_u32 v14, v48, v11, s5
		v_cndmask_b32_e64 v14, v42, v14, s[20:21]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v25, 0x80, v31
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mul_i32 s5, 0xc0, s17
		v_add3_u32 v14, v48, v11, s5
		v_cndmask_b32_e32 v14, v42, v14, vcc
		s_add_i32 m0, m0, 0x2100
		v_add3_u32 v28, v26, v45, v47
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mul_i32 s5, 0xc8, s17
		v_add3_u32 v11, v48, v11, s5
		v_cndmask_b32_e32 v11, v42, v11, vcc
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s5, s17, 8
		v_add3_u32 v14, s5, v26, v45
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 s5, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v2, s5
		v_add_lshl_u32 v11, v25, v33, 1
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v11, v42, v11, vcc
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_add_u32_e32 v11, 0x80, v27
		v_add_lshl_u32 v11, v11, v33, 1
		v_cndmask_b32_e32 v11, v42, v11, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[20:21], v12, s5
		v_cmp_lt_i32_e64 vcc, v44, s5
		v_add3_u32 v14, v14, v47, v48
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v11, v42, v14, s[20:21]
		s_add_i32 m0, m0, 0x128e0
		v_mov_b32_e32 v14, 0x420
		v_mul_lo_u32 v14, v14, v43
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_mul_i32 s5, 0x108, s17
		v_add3_u32 v11, v48, v28, s5
		v_cndmask_b32_e64 v11, v42, v11, s[20:21]
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s5, 0x140, s17
		v_add3_u32 v25, v48, v28, s5
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_cndmask_b32_e32 v11, v42, v25, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v25, 63, v0
		s_mul_i32 s5, 0x148, s17
		v_add3_u32 v27, v48, v28, s5
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_cndmask_b32_e32 v11, v42, v27, vcc
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v27, 7, v10
		v_cmp_ne_u32_e64 vcc, v10, s16
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshrrev_b32_e32 v11, 4, v25
		v_lshlrev_b32_e32 v11, 4, v11
		v_and_b32_e32 v28, 15, v25
		v_mov_b32_e32 v30, 0x420
		v_mul_lo_u32 v30, v30, v28
		v_add3_u32 v11, v27, v11, v30
		ds_read_b128 v[52:55], v11
		ds_read_b128 v[56:59], v11 offset:64
		ds_read_b128 v[60:63], v11 offset:256
		ds_read_b128 v[64:67], v11 offset:320
		ds_read_b128 v[68:71], v11 offset:512
		ds_read_b128 v[72:75], v11 offset:576
		ds_read_b128 v[76:79], v11 offset:768
		ds_read_b128 v[80:83], v11 offset:832
		v_and_b32_e32 v27, 3, v0
		v_lshlrev_b32_e32 v27, 3, v27
		v_and_b32_e32 v28, 1, v7
		v_lshlrev_b32_e32 v28, 5, v28
		v_add3_u32 v30, v27, v9, v28
		v_lshlrev_b32_e32 v31, 9, v5
		v_add3_u32 v30, v30, v31, v35
		v_add3_u32 v30, v30, v20, v14
		v_cmp_eq_u32_e64 s[20:21], v10, s16
		ds_read_b64_tr_b16 v[84:85], v30 offset:50656
		ds_read_b64_tr_b16 v[86:87], v30 offset:59104
		v_add_u32_e32 v10, 0x10000, v27
		v_add3_u32 v9, v10, v9, v28
		v_add3_u32 v9, v9, v31, v35
		v_add3_u32 v9, v9, v20, v14
		ds_read_b64_tr_b16 v[32:33], v9 offset:2016
		ds_read_b64_tr_b16 v[34:35], v9 offset:10464
		ds_read_b64_tr_b16 v[88:89], v30 offset:50784
		ds_read_b64_tr_b16 v[90:91], v30 offset:59232
		ds_read_b64_tr_b16 v[92:93], v9 offset:2144
		ds_read_b64_tr_b16 v[94:95], v9 offset:10592
		ds_read_b64_tr_b16 v[96:97], v30 offset:50912
		ds_read_b64_tr_b16 v[98:99], v30 offset:59360
		ds_read_b64_tr_b16 v[100:101], v9 offset:2272
		ds_read_b64_tr_b16 v[102:103], v9 offset:10720
		ds_read_b64_tr_b16 v[104:105], v30 offset:51040
		ds_read_b64_tr_b16 v[106:107], v30 offset:59488
		ds_read_b64_tr_b16 v[108:109], v9 offset:2400
		ds_read_b64_tr_b16 v[110:111], v9 offset:10848
		s_add_i32 s5, s4, -3
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[40:41], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[40:41]
		s_setprio 0
		v_lshlrev_b32_e32 v9, 4, v29
		v_add_u32_e32 v9, 0x180, v9
		s_lshl_b32 s12, s15, 1
		v_mul_lo_u32 v10, s12, v17
		v_add_u32_e32 v14, v9, v10
		v_mul_lo_u32 v3, s12, v3
		v_add_u32_e32 v10, v9, v3
		s_mul_i32 s12, 0x180, s17
		s_mul_i32 s15, 0x188, s17
		s_mul_i32 s22, 0x1c0, s17
		s_mul_i32 s23, 0x1c8, s17
		v_add3_u32 v3, v26, v45, v47
		s_cmp_lt_i32 0, s5
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
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		s_mov_b32 s24, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[52:55], v[116:119]
		s_lshl_b32 s25, s16, 7
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[52:55], v[124:127]
		s_cmp_ge_u32 s24, 2
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[60:63], v[140:143]
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s24, -2
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[60:63], v[128:131]
		s_add_i32 s28, s24, 1
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[60:63], v[136:139]
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s27, s28
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[76:79], v[168:171]
		s_add_i32 s27, s16, 3
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[76:79], v[160:163]
		s_mul_i32 s27, s27, 64
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[104:107], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[104:107], v[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[76:79], v[164:167]
		v_mfma_f32_16x16x32_f16 v[112:115], v[32:35], v[56:59], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[32:35], v[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[64:67], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[80:83], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[32:35], v[72:75], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[32:35], v[80:83], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[72:75], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[80:83], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[80:83], v[164:167]
		s_setprio 1
		s_barrier
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s27, s14, s27
		v_cmp_lt_i32_e64 vcc, v2, s27
		v_cmp_lt_i32_e64 s[28:29], v23, s27
		s_mul_i32 s30, -1, s25
		v_cmp_lt_i32_e64 s[32:33], v12, s27
		s_add_i32 s30, s30, 0x80000000
		v_mov_b32_e32 v9, s30
		v_cndmask_b32_e32 v17, v9, v14, vcc
		v_cndmask_b32_e32 v9, v9, v10, vcc
		s_mul_i32 s30, 0x4200, s24
		v_cmp_lt_i32_e64 vcc, v8, s27
		s_add_i32 s30, s13, s30
		v_cmp_lt_i32_e64 s[34:35], v44, s27
		s_mov_b32 m0, s30
		s_mul_i32 s24, 0x8400, s24
		buffer_load_dwordx4 v17, s[36:39], s25 offen lds
		s_add_i32 s24, s13, s24
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s27, s17, s16
		buffer_load_dwordx4 v9, s[36:39], s25 offen lds
		s_lshl_b32 s25, s27, 7
		s_add_i32 s27, s12, s25
		v_add3_u32 v9, s27, v26, v45
		v_add3_u32 v9, v9, v47, v48
		v_cndmask_b32_e64 v9, v42, v9, s[32:33]
		s_add_i32 m0, s24, 0xc5e0
		s_add_i32 s24, s15, s25
		v_add3_u32 v17, v48, v3, s24
		v_cndmask_b32_e64 v17, v42, v17, s[28:29]
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 s24, s22, s25
		v_add3_u32 v9, v48, v3, s24
		v_cndmask_b32_e64 v9, v42, v9, s[34:35]
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s24, s23, s25
		v_add3_u32 v20, v48, v3, s24
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_cndmask_b32_e32 v17, v42, v20, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s24, 0x8400, s26
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_mul_i32 s25, 0x4200, s26
		v_add_u32_e32 v9, s25, v11
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s25, s24, 0x10000
		v_add_u32_e32 v20, s24, v30
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_add_u32_e32 v17, s25, v30
		s_barrier
		s_waitcnt vmcnt(6)
		ds_read_b128 v[52:55], v9
		ds_read_b128 v[56:59], v9 offset:64
		ds_read_b128 v[60:63], v9 offset:256
		ds_read_b128 v[64:67], v9 offset:320
		ds_read_b128 v[68:71], v9 offset:512
		ds_read_b128 v[72:75], v9 offset:576
		ds_read_b128 v[76:79], v9 offset:768
		ds_read_b128 v[80:83], v9 offset:832
		ds_read_b64_tr_b16 v[84:85], v20 offset:50656
		ds_read_b64_tr_b16 v[86:87], v20 offset:59104
		ds_read_b64_tr_b16 v[32:33], v17 offset:2016
		ds_read_b64_tr_b16 v[34:35], v17 offset:10464
		ds_read_b64_tr_b16 v[88:89], v20 offset:50784
		ds_read_b64_tr_b16 v[90:91], v20 offset:59232
		ds_read_b64_tr_b16 v[92:93], v17 offset:2144
		ds_read_b64_tr_b16 v[94:95], v17 offset:10592
		ds_read_b64_tr_b16 v[96:97], v20 offset:50912
		ds_read_b64_tr_b16 v[98:99], v20 offset:59360
		ds_read_b64_tr_b16 v[100:101], v17 offset:2272
		ds_read_b64_tr_b16 v[102:103], v17 offset:10720
		ds_read_b64_tr_b16 v[104:105], v20 offset:51040
		ds_read_b64_tr_b16 v[106:107], v20 offset:59488
		ds_read_b64_tr_b16 v[108:109], v17 offset:2400
		ds_read_b64_tr_b16 v[110:111], v17 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s5
		s_mov_b32 s24, s26
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[40:41], s[20:21]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[40:41]
		s_mov_b32 s0, s6
		s_mov_b32 s1, s7
		s_mov_b32 s2, s38
		s_mov_b32 s3, s39
		buffer_load_ushort v2, v26, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v19
		buffer_load_ushort v8, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v36
		buffer_load_ushort v9, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v38
		buffer_load_ushort v10, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v39
		buffer_load_ushort v12, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v40
		buffer_load_ushort v14, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v41
		buffer_load_ushort v17, v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v1
		buffer_load_ushort v20, v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v6
		v_add_lshl_u32 v23, v18, v3, 1
		s_mov_b32 s0, s8
		s_mov_b32 s1, s9
		s_mov_b32 s2, s38
		s_mov_b32 s3, s39
		buffer_load_ushort v26, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v19, v3, 1
		buffer_load_ushort v27, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v36, v3, 1
		buffer_load_ushort v28, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v38, v3, 1
		buffer_load_ushort v29, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v39, v3, 1
		buffer_load_ushort v31, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v40, v3, 1
		buffer_load_ushort v37, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v23, v41, v3, 1
		buffer_load_ushort v42, v23, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v23, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v21
		v_add_lshl_u32 v43, v18, v3, 1
		buffer_load_ushort v44, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v19, v3, 1
		buffer_load_ushort v45, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v36, v3, 1
		buffer_load_ushort v46, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v38, v3, 1
		buffer_load_ushort v47, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v39, v3, 1
		buffer_load_ushort v48, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v40, v3, 1
		buffer_load_ushort v49, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v43, v41, v3, 1
		buffer_load_ushort v50, v43, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v43, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v24
		v_add_lshl_u32 v51, v18, v3, 1
		buffer_load_ushort v176, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v19, v3, 1
		buffer_load_ushort v177, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v36, v3, 1
		buffer_load_ushort v178, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v38, v3, 1
		buffer_load_ushort v179, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v39, v3, 1
		buffer_load_ushort v180, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v40, v3, 1
		buffer_load_ushort v181, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v51, v41, v3, 1
		buffer_load_ushort v182, v51, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v51, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v22
		v_add_lshl_u32 v183, v18, v3, 1
		buffer_load_ushort v184, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v19, v3, 1
		buffer_load_ushort v185, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v36, v3, 1
		buffer_load_ushort v186, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v38, v3, 1
		buffer_load_ushort v187, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v39, v3, 1
		buffer_load_ushort v188, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v40, v3, 1
		buffer_load_ushort v189, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v183, v41, v3, 1
		buffer_load_ushort v190, v183, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v183, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v13
		v_add_lshl_u32 v191, v18, v3, 1
		buffer_load_ushort v192, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v19, v3, 1
		buffer_load_ushort v193, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v36, v3, 1
		buffer_load_ushort v194, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v38, v3, 1
		buffer_load_ushort v195, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v39, v3, 1
		buffer_load_ushort v196, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v40, v3, 1
		buffer_load_ushort v197, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v191, v41, v3, 1
		buffer_load_ushort v198, v191, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v191, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v4
		v_add_lshl_u32 v199, v18, v3, 1
		buffer_load_ushort v200, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v19, v3, 1
		buffer_load_ushort v201, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v36, v3, 1
		buffer_load_ushort v202, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v38, v3, 1
		buffer_load_ushort v203, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v39, v3, 1
		buffer_load_ushort v204, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v40, v3, 1
		buffer_load_ushort v205, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v199, v41, v3, 1
		buffer_load_ushort v206, v199, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v199, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v15
		v_add_lshl_u32 v207, v18, v3, 1
		buffer_load_ushort v208, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v19, v3, 1
		buffer_load_ushort v209, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v36, v3, 1
		buffer_load_ushort v210, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v38, v3, 1
		buffer_load_ushort v211, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v39, v3, 1
		buffer_load_ushort v212, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v40, v3, 1
		buffer_load_ushort v213, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v207, v41, v3, 1
		buffer_load_ushort v214, v207, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v207, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s18, v16
		v_add_lshl_u32 v215, v18, v3, 1
		buffer_load_ushort v216, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v19, v3, 1
		buffer_load_ushort v217, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v36, v3, 1
		buffer_load_ushort v218, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v38, v3, 1
		buffer_load_ushort v219, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v39, v3, 1
		buffer_load_ushort v220, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v40, v3, 1
		buffer_load_ushort v221, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v215, v41, v3, 1
		buffer_load_ushort v222, v215, s[0:3], 0 offen sc0 nt
		v_add_lshl_u32 v3, v1, v3, 1
		buffer_load_ushort v215, v3, s[0:3], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[104:107], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[104:107], v[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[76:79], v[164:167]
		v_mfma_f32_16x16x32_f16 v[112:115], v[32:35], v[56:59], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[32:35], v[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[64:67], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[80:83], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[32:35], v[72:75], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[32:35], v[80:83], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[72:75], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[80:83], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[80:83], v[164:167]
		s_add_i32 s0, s4, -2
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s2, s0, -1
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s2, s0
		s_mul_hi_u32 s1, s0, 0xaaaaaaab
		s_cselect_b32 s2, 1, 0
		s_lshr_b32 s1, s1, 1
		s_mul_i32 s1, s1, 3
		s_xor_b32 s1, s1, -1
		s_add_i32 s1, s1, 1
		s_add_i32 s0, s0, s1
		s_xor_b32 s1, s0, -1
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s0, s1, s0
		s_waitcnt vmcnt(62)
		s_barrier
		s_mul_i32 s1, 0x4200, s0
		v_add_u32_e32 v3, s1, v11
		ds_read_b128 v[32:35], v3
		ds_read_b128 v[52:55], v3 offset:64
		ds_read_b128 v[56:59], v3 offset:256
		ds_read_b128 v[60:63], v3 offset:320
		ds_read_b128 v[64:67], v3 offset:512
		ds_read_b128 v[68:71], v3 offset:576
		ds_read_b128 v[72:75], v3 offset:768
		ds_read_b128 v[76:79], v3 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v3, s0, v30
		ds_read_b64_tr_b16 v[80:81], v3 offset:50656
		ds_read_b64_tr_b16 v[82:83], v3 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v84, s0, v30
		ds_read_b64_tr_b16 v[88:89], v84 offset:2016
		ds_read_b64_tr_b16 v[90:91], v84 offset:10464
		ds_read_b64_tr_b16 v[92:93], v3 offset:50784
		ds_read_b64_tr_b16 v[94:95], v3 offset:59232
		ds_read_b64_tr_b16 v[96:97], v84 offset:2144
		ds_read_b64_tr_b16 v[98:99], v84 offset:10592
		ds_read_b64_tr_b16 v[100:101], v3 offset:50912
		ds_read_b64_tr_b16 v[102:103], v3 offset:59360
		ds_read_b64_tr_b16 v[104:105], v84 offset:2272
		ds_read_b64_tr_b16 v[106:107], v84 offset:10720
		ds_read_b64_tr_b16 v[108:109], v3 offset:51040
		ds_read_b64_tr_b16 v[110:111], v3 offset:59488
		ds_read_b64_tr_b16 v[224:225], v84 offset:2400
		ds_read_b64_tr_b16 v[226:227], v84 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		s_add_i32 s0, s4, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s2, s0, -1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[32:35], v[116:119]
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s2, s0
		s_mul_hi_u32 s1, s0, 0xaaaaaaab
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[32:35], v[120:123]
		s_cselect_b32 s2, 1, 0
		s_lshr_b32 s1, s1, 1
		s_mul_i32 s1, s1, 3
		s_xor_b32 s1, s1, -1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[32:35], v[124:127]
		s_add_i32 s1, s1, 1
		s_add_i32 s0, s0, s1
		s_xor_b32 s1, s0, -1
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[56:59], v[140:143]
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s0, s1, s0
		s_mul_i32 s1, 0x4200, s0
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[56:59], v[128:131]
		v_add_u32_e32 v3, s1, v11
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[72:75], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[52:55], v[120:123]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[224:227], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[224:227], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[224:227], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[224:227], v[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[76:79], v[164:167]
		ds_read_b128 v[32:35], v3
		ds_read_b128 v[52:55], v3 offset:64
		ds_read_b128 v[56:59], v3 offset:256
		ds_read_b128 v[60:63], v3 offset:320
		ds_read_b128 v[64:67], v3 offset:512
		ds_read_b128 v[68:71], v3 offset:576
		ds_read_b128 v[72:75], v3 offset:768
		ds_read_b128 v[76:79], v3 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v3, s0, v30
		ds_read_b64_tr_b16 v[80:81], v3 offset:50656
		ds_read_b64_tr_b16 v[82:83], v3 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v11, s0, v30
		ds_read_b64_tr_b16 v[84:85], v11 offset:2016
		ds_read_b64_tr_b16 v[86:87], v11 offset:10464
		ds_read_b64_tr_b16 v[88:89], v3 offset:50784
		ds_read_b64_tr_b16 v[90:91], v3 offset:59232
		ds_read_b64_tr_b16 v[92:93], v11 offset:2144
		ds_read_b64_tr_b16 v[94:95], v11 offset:10592
		ds_read_b64_tr_b16 v[96:97], v3 offset:50912
		ds_read_b64_tr_b16 v[98:99], v3 offset:59360
		ds_read_b64_tr_b16 v[100:101], v11 offset:2272
		ds_read_b64_tr_b16 v[102:103], v11 offset:10720
		ds_read_b64_tr_b16 v[104:105], v3 offset:51040
		ds_read_b64_tr_b16 v[106:107], v3 offset:59488
		ds_read_b64_tr_b16 v[108:109], v11 offset:2400
		ds_read_b64_tr_b16 v[110:111], v11 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[32:35], v[116:119]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[32:35], v[120:123]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[32:35], v[124:127]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[104:107], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[104:107], v[72:75], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[76:79], v[164:167]
		v_lshlrev_b32_e32 v3, 1, v5
		v_xor_b32_e32 v3, v0, v3
		v_lshlrev_b32_e32 v5, 4, v3
		ds_write_b128 v5, v[112:115]
		v_xor_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 4, v3
		ds_write_b128 v3, v[116:119] offset:8192
		ds_write_b128 v5, v[120:123] offset:16384
		ds_write_b128 v3, v[124:127] offset:24576
		v_lshlrev_b32_e32 v7, 1, v7
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_cvt_f32_f16_e32 v32, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v2, 3, v25
		v_and_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v11, 13, v2
		v_bitop3_b32 v0, v0, v2, 1 bitop3:0x78
		v_lshrrev_b32_e32 v2, 5, v25
		v_and_b32_e32 v25, 7, v25
		v_lshlrev_b32_e32 v25, 5, v25
		v_add3_u32 v30, v7, v2, v25
		v_xor_b32_e32 v30, v30, v0
		v_lshl_add_u32 v30, v30, 4, v11
		ds_read_b128 v[52:55], v30
		v_add_u32_e32 v33, 16, v7
		v_add3_u32 v33, v33, v2, v25
		v_xor_b32_e32 v33, v33, v0
		v_lshl_add_u32 v34, v33, 4, v11
		ds_read_b128 v[56:59], v34
		v_add_u32_e32 v33, 0x100, v7
		v_add3_u32 v33, v33, v2, v25
		v_xor_b32_e32 v33, v33, v0
		v_lshl_add_u32 v35, v33, 4, v11
		ds_read_b128 v[60:63], v35
		v_add_u32_e32 v7, 0x110, v7
		v_add3_u32 v2, v7, v2, v25
		v_xor_b32_e32 v0, v2, v0
		v_lshl_add_u32 v0, v0, 4, v11
		ds_read_b128 v[64:67], v0
		v_cvt_f32_f16_e32 v33, v8
		v_cvt_f32_f16_e32 v68, v9
		v_cvt_f32_f16_e32 v69, v10
		v_cvt_f32_f16_e32 v8, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[128:131]
		ds_write_b128 v3, v[132:135] offset:8192
		ds_write_b128 v5, v[136:139] offset:16384
		ds_write_b128 v3, v[140:143] offset:24576
		v_cvt_f32_f16_e32 v9, v14
		v_cvt_f32_f16_e32 v10, v17
		v_cvt_f32_f16_e32 v11, v20
		v_cvt_f32_f16_e32 v70, v26
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v30
		ds_read_b128 v[76:79], v34
		ds_read_b128 v[80:83], v35
		ds_read_b128 v[84:87], v0
		v_cvt_f32_f16_e32 v71, v27
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v26, v28
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v27, v29
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v28, v31
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[144:147]
		ds_write_b128 v3, v[148:151] offset:8192
		ds_write_b128 v5, v[152:155] offset:16384
		ds_write_b128 v3, v[156:159] offset:24576
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v29, v37
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v88, v42
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v89, v23
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v90, v44
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v30
		ds_read_b128 v[96:99], v34
		ds_read_b128 v[100:103], v35
		ds_read_b128 v[104:107], v0
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v91, v45
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v44, v46
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v45, v47
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v46, v48
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[160:163]
		ds_write_b128 v3, v[164:167] offset:8192
		ds_write_b128 v5, v[168:171] offset:16384
		ds_write_b128 v3, v[172:175] offset:24576
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v47, v49
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v2, v50
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v3, v43
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v42, v176
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v30
		ds_read_b128 v[112:115], v34
		ds_read_b128 v[116:119], v35
		ds_read_b128 v[120:123], v0
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v43, v177
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v30, v178
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v31, v179
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v34, v180
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v35, v181
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v48, v182
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v49, v51
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v50, v184
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v51, v185
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v124, v186
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v125, v187
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v126, v188
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v127, v189
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v128, v190
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v129, v183
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v130, v192
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v131, v193
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v132, v194
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v133, v195
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v134, v196
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v135, v197
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v136, v198
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v137, v191
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v138, v200
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v139, v201
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v140, v202
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v141, v203
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v142, v204
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v143, v205
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v144, v206
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v145, v199
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v146, v208
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v147, v209
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v148, v210
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v149, v211
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v150, v212
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v151, v213
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v152, v214
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v153, v207
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v154, v216
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v155, v217
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v156, v218
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v157, v219
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v158, v220
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v159, v221
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v160, v222
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v161, v215
		v_pk_add_f32 v[52:53], v[52:53], v[32:33]
		v_pk_fma_f32 v[162:163], v[52:53], v[70:71], v[52:53]
		v_cvt_pk_f16_f32 v0, v162, v163
		v_pk_add_f32 v[52:53], v[54:55], v[68:69]
		v_pk_fma_f32 v[54:55], v[52:53], v[26:27], v[52:53]
		v_cvt_pk_f16_f32 v5, v54, v55
		v_pk_add_f32 v[26:27], v[56:57], v[8:9]
		v_pk_fma_f32 v[52:53], v[26:27], v[28:29], v[26:27]
		v_cvt_pk_f16_f32 v7, v52, v53
		v_pk_add_f32 v[26:27], v[58:59], v[10:11]
		v_pk_fma_f32 v[28:29], v[26:27], v[88:89], v[26:27]
		v_cvt_pk_f16_f32 v12, v28, v29
		v_pk_add_f32 v[26:27], v[60:61], v[32:33]
		v_pk_fma_f32 v[28:29], v[26:27], v[90:91], v[26:27]
		v_cvt_pk_f16_f32 v14, v28, v29
		v_pk_add_f32 v[26:27], v[62:63], v[68:69]
		v_pk_fma_f32 v[28:29], v[26:27], v[44:45], v[26:27]
		v_cvt_pk_f16_f32 v17, v28, v29
		v_pk_add_f32 v[26:27], v[64:65], v[8:9]
		v_pk_fma_f32 v[28:29], v[26:27], v[46:47], v[26:27]
		v_cvt_pk_f16_f32 v20, v28, v29
		v_pk_add_f32 v[26:27], v[66:67], v[10:11]
		v_pk_fma_f32 v[28:29], v[26:27], v[2:3], v[26:27]
		v_cvt_pk_f16_f32 v2, v28, v29
		v_pk_add_f32 v[26:27], v[72:73], v[32:33]
		v_pk_fma_f32 v[28:29], v[26:27], v[42:43], v[26:27]
		v_cvt_pk_f16_f32 v3, v28, v29
		v_pk_add_f32 v[26:27], v[74:75], v[68:69]
		v_pk_fma_f32 v[28:29], v[26:27], v[30:31], v[26:27]
		v_cvt_pk_f16_f32 v23, v28, v29
		v_pk_add_f32 v[26:27], v[76:77], v[8:9]
		v_pk_fma_f32 v[28:29], v[26:27], v[34:35], v[26:27]
		v_cvt_pk_f16_f32 v25, v28, v29
		v_pk_add_f32 v[26:27], v[78:79], v[10:11]
		v_pk_fma_f32 v[28:29], v[26:27], v[48:49], v[26:27]
		v_cvt_pk_f16_f32 v26, v28, v29
		v_pk_add_f32 v[28:29], v[80:81], v[32:33]
		v_pk_fma_f32 v[30:31], v[28:29], v[50:51], v[28:29]
		v_cvt_pk_f16_f32 v27, v30, v31
		v_pk_add_f32 v[28:29], v[82:83], v[68:69]
		v_pk_fma_f32 v[30:31], v[28:29], v[124:125], v[28:29]
		v_cvt_pk_f16_f32 v28, v30, v31
		v_pk_add_f32 v[30:31], v[84:85], v[8:9]
		v_pk_fma_f32 v[34:35], v[30:31], v[126:127], v[30:31]
		v_cvt_pk_f16_f32 v29, v34, v35
		v_pk_add_f32 v[30:31], v[86:87], v[10:11]
		v_pk_fma_f32 v[34:35], v[30:31], v[128:129], v[30:31]
		v_cvt_pk_f16_f32 v30, v34, v35
		v_pk_add_f32 v[34:35], v[92:93], v[32:33]
		v_pk_fma_f32 v[42:43], v[34:35], v[130:131], v[34:35]
		v_cvt_pk_f16_f32 v31, v42, v43
		v_pk_add_f32 v[34:35], v[94:95], v[68:69]
		v_pk_fma_f32 v[42:43], v[34:35], v[132:133], v[34:35]
		v_cvt_pk_f16_f32 v34, v42, v43
		v_pk_add_f32 v[42:43], v[96:97], v[8:9]
		v_pk_fma_f32 v[44:45], v[42:43], v[134:135], v[42:43]
		v_cvt_pk_f16_f32 v35, v44, v45
		v_pk_add_f32 v[42:43], v[98:99], v[10:11]
		v_pk_fma_f32 v[44:45], v[42:43], v[136:137], v[42:43]
		v_cvt_pk_f16_f32 v37, v44, v45
		v_pk_add_f32 v[42:43], v[100:101], v[32:33]
		v_pk_fma_f32 v[44:45], v[42:43], v[138:139], v[42:43]
		v_cvt_pk_f16_f32 v42, v44, v45
		v_pk_add_f32 v[44:45], v[102:103], v[68:69]
		v_pk_fma_f32 v[46:47], v[44:45], v[140:141], v[44:45]
		v_cvt_pk_f16_f32 v43, v46, v47
		v_pk_add_f32 v[44:45], v[104:105], v[8:9]
		v_pk_fma_f32 v[46:47], v[44:45], v[142:143], v[44:45]
		v_cvt_pk_f16_f32 v44, v46, v47
		v_pk_add_f32 v[46:47], v[106:107], v[10:11]
		v_pk_fma_f32 v[48:49], v[46:47], v[144:145], v[46:47]
		v_cvt_pk_f16_f32 v45, v48, v49
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[46:47], v[108:109], v[32:33]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[32:33], v[116:117], v[32:33]
		v_pk_fma_f32 v[48:49], v[46:47], v[146:147], v[46:47]
		v_pk_fma_f32 v[46:47], v[32:33], v[154:155], v[32:33]
		v_cvt_pk_f16_f32 v32, v48, v49
		v_cvt_pk_f16_f32 v33, v46, v47
		v_pk_add_f32 v[46:47], v[110:111], v[68:69]
		v_pk_add_f32 v[48:49], v[118:119], v[68:69]
		v_pk_fma_f32 v[50:51], v[46:47], v[148:149], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[156:157], v[48:49]
		v_cvt_pk_f16_f32 v48, v50, v51
		v_cvt_pk_f16_f32 v46, v46, v47
		v_pk_add_f32 v[50:51], v[112:113], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[8:9], v[120:121], v[8:9]
		v_pk_fma_f32 v[52:53], v[50:51], v[150:151], v[50:51]
		v_pk_fma_f32 v[50:51], v[8:9], v[158:159], v[8:9]
		v_cvt_pk_f16_f32 v8, v52, v53
		v_cvt_pk_f16_f32 v9, v50, v51
		v_pk_add_f32 v[50:51], v[114:115], v[10:11]
		v_pk_add_f32 v[10:11], v[122:123], v[10:11]
		v_pk_fma_f32 v[52:53], v[50:51], v[152:153], v[50:51]
		v_pk_fma_f32 v[50:51], v[10:11], v[160:161], v[10:11]
		v_cvt_pk_f16_f32 v10, v52, v53
		v_cvt_pk_f16_f32 v11, v50, v51
		v_and_b32_e32 v47, 0xffff, v0
		v_mul_lo_u32 v6, s19, v6
		v_add_lshl_u32 v49, v18, v6, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s38
		s_mov_b32 s3, s39
		buffer_store_short v47, v49, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v0
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v47, v19, v6, 1
		buffer_store_short v0, v47, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v5
		v_add_lshl_u32 v47, v36, v6, 1
		buffer_store_short v0, v47, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v5
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v5, v38, v6, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v7
		v_add_lshl_u32 v5, v39, v6, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v7
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v5, v40, v6, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v12
		v_add_lshl_u32 v5, v41, v6, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v12
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v5, v1, v6, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v14
		v_mul_lo_u32 v5, s19, v21
		v_add_lshl_u32 v6, v18, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v14
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v6, v19, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v17
		v_add_lshl_u32 v6, v36, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v17
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v6, v38, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v20
		v_add_lshl_u32 v6, v39, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v20
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v6, v40, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v2
		v_add_lshl_u32 v6, v41, v5, 1
		buffer_store_short v0, v6, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v2
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v2, v1, v5, 1
		buffer_store_short v0, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v3
		v_mul_lo_u32 v2, s19, v24
		v_add_lshl_u32 v5, v18, v2, 1
		buffer_store_short v0, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v3
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v19, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v23
		v_add_lshl_u32 v3, v36, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v23
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v38, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v25
		v_add_lshl_u32 v3, v39, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v25
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v40, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v26
		v_add_lshl_u32 v3, v41, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v26
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v2, v1, v2, 1
		buffer_store_short v0, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v27
		v_mul_lo_u32 v2, s19, v22
		v_add_lshl_u32 v3, v18, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v27
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v19, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v28
		v_add_lshl_u32 v3, v36, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v28
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v38, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v29
		v_add_lshl_u32 v3, v39, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v29
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v40, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v30
		v_add_lshl_u32 v3, v41, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v30
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v2, v1, v2, 1
		buffer_store_short v0, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v31
		v_mul_lo_u32 v2, s19, v13
		v_add_lshl_u32 v3, v18, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v31
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v19, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v34
		v_add_lshl_u32 v3, v36, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v34
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v38, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v35
		v_add_lshl_u32 v3, v39, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v35
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v40, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v37
		v_add_lshl_u32 v3, v41, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v37
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v2, v1, v2, 1
		buffer_store_short v0, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v42
		v_mul_lo_u32 v2, s19, v4
		v_add_lshl_u32 v3, v18, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v42
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v19, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v43
		v_add_lshl_u32 v3, v36, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v43
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v38, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v44
		v_add_lshl_u32 v3, v39, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v44
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v40, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v45
		v_add_lshl_u32 v3, v41, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v45
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v2, v1, v2, 1
		buffer_store_short v0, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v32
		v_mul_lo_u32 v2, s19, v15
		v_add_lshl_u32 v3, v18, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v32
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v19, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v48
		v_add_lshl_u32 v3, v36, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v48
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v38, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v8
		v_add_lshl_u32 v3, v39, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v8
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v40, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v10
		v_add_lshl_u32 v3, v41, v2, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v16
		v_lshrrev_b32_e32 v3, 16, v10
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v2, v1, v2, 1
		buffer_store_short v3, v2, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v2, 0xffff, v33
		v_add_lshl_u32 v3, v18, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v2, 16, v33
		v_and_b32_e32 v2, 0xffff, v2
		v_add_lshl_u32 v3, v19, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v2, 0xffff, v46
		v_add_lshl_u32 v3, v36, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v2, 16, v46
		v_and_b32_e32 v2, 0xffff, v2
		v_add_lshl_u32 v3, v38, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v2, 0xffff, v9
		v_add_lshl_u32 v3, v39, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v2, 16, v9
		v_and_b32_e32 v2, 0xffff, v2
		v_add_lshl_u32 v3, v40, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v2, 0xffff, v11
		v_add_lshl_u32 v3, v41, v0, 1
		buffer_store_short v2, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v2, 16, v11
		v_and_b32_e32 v2, 0xffff, v2
		v_add_lshl_u32 v0, v1, v0, 1
		buffer_store_short v2, v0, s[0:3], 0 offen sc0 nt
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
