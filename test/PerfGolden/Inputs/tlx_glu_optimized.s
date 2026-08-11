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
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v3, 4, v0
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v4, 32
		v_mul_lo_u32 v4, v4, v3
		v_mad_u32_u24 v1, v1, 16, v4
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v4, 1, v3
		v_mad_u32_u24 v1, v4, 64, v1
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v6, 1, v5
		v_lshrrev_b32_e32 v7, 7, v0
		v_and_b32_e32 v8, 1, v7
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_add3_u32 v1, v1, v6, v9
		v_lshrrev_b32_e32 v8, 8, v0
		v_and_b32_e32 v10, 1, v8
		v_mad_u32_u24 v1, v10, 4, v1
		v_and_b32_e32 v11, 15, v3
		v_add_u32_e32 v12, 0x50, v11
		v_add_u32_e32 v13, 0x60, v11
		v_add_u32_e32 v14, 0x70, v11
		v_add_u32_e32 v15, s1, v1
		s_mov_b32 s16, 0
		v_cmp_lt_i32_e64 vcc, v15, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v16, v15, -1, 1
		v_cndmask_b32_e32 v15, v15, v16, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		v_mov_b32_e32 v16, s12
		s_add_i32 s12, s28, 1
		v_mov_b32_e32 v17, s12
		v_cndmask_b32_e64 v16, v16, v17, s[26:27]
		v_cvt_f32_u32_e32 v17, v16
		v_rcp_iflag_f32_e32 v17, v17
		v_add3_u32 v1, 8, v1, s1
		v_mul_f32_e32 v17, v2, v17
		v_cvt_u32_f32_e32 v17, v17
		v_xad_u32 v18, v16, -1, 1
		v_mul_lo_u32 v19, v18, v17
		v_mul_hi_u32 v19, v17, v19
		v_add_u32_e32 v17, v17, v19
		v_mul_hi_u32 v19, v15, v17
		v_mul_lo_u32 v19, v19, v16
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v15, 1, v19, v15
		v_add_u32_e32 v19, v15, v18
		v_cmp_ge_u32_e64 vcc, v15, v16
		v_add_u32_e32 v20, s1, v11
		v_add_u32_e32 v12, s1, v12
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_add_u32_e32 v19, v15, v18
		v_cmp_ge_u32_e64 vcc, v15, v16
		v_add3_u32 v21, 16, v11, s1
		v_add3_u32 v22, 32, v11, s1
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_xad_u32 v19, v15, -1, 1
		v_cndmask_b32_e64 v15, v15, v19, s[20:21]
		v_cmp_lt_i32_e64 vcc, v1, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v19, v1, -1, 1
		v_cndmask_b32_e32 v1, v1, v19, vcc
		v_mul_hi_u32 v19, v1, v17
		v_mul_lo_u32 v19, v19, v16
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v1, 1, v19, v1
		v_add_u32_e32 v19, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add3_u32 v23, 48, v11, s1
		v_add3_u32 v11, 64, v11, s1
		v_cndmask_b32_e32 v1, v1, v19, vcc
		v_add_u32_e32 v19, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add_u32_e32 v13, s1, v13
		v_add_u32_e32 v14, s1, v14
		v_cndmask_b32_e32 v1, v1, v19, vcc
		v_xad_u32 v19, v1, -1, 1
		v_cndmask_b32_e64 v1, v1, v19, s[20:21]
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v19, v20, -1, 1
		v_cndmask_b32_e32 v19, v20, v19, vcc
		v_mul_hi_u32 v20, v19, v17
		v_mul_lo_u32 v20, v20, v16
		v_xor_b32_e32 v20, -1, v20
		v_add3_u32 v19, 1, v20, v19
		v_add_u32_e32 v20, v19, v18
		v_cmp_ge_u32_e64 vcc, v19, v16
		s_mul_i32 s0, s0, 0x100
		v_mov_b32_e32 v24, 16
		v_mul_lo_u32 v24, v24, v4
		v_cndmask_b32_e32 v4, v19, v20, vcc
		v_cmp_ge_u32_e64 vcc, v4, v16
		v_add_u32_e32 v19, v4, v18
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v10
		v_cndmask_b32_e32 v4, v4, v19, vcc
		v_xad_u32 v10, v4, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v19, v21, -1, 1
		v_cndmask_b32_e32 v19, v21, v19, vcc
		v_mul_hi_u32 v21, v19, v17
		v_mul_lo_u32 v21, v21, v16
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v19, 1, v21, v19
		v_cmp_ge_u32_e64 vcc, v19, v16
		v_add_u32_e32 v21, v19, v18
		v_and_b32_e32 v3, 1, v3
		v_cndmask_b32_e32 v19, v19, v21, vcc
		v_cmp_ge_u32_e64 vcc, v19, v16
		v_add_u32_e32 v21, v19, v18
		v_mul_lo_u32 v25, s15, v1
		v_cndmask_b32_e32 v19, v19, v21, vcc
		v_xad_u32 v21, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v26, v22, -1, 1
		v_cndmask_b32_e32 v22, v22, v26, vcc
		v_mul_hi_u32 v26, v22, v17
		v_mul_lo_u32 v26, v26, v16
		v_xor_b32_e32 v26, -1, v26
		v_add3_u32 v22, 1, v26, v22
		v_cmp_ge_u32_e64 vcc, v22, v16
		v_add_u32_e32 v26, v22, v18
		s_xor_b32 s1, s13, -1
		v_cndmask_b32_e32 v22, v22, v26, vcc
		v_cmp_ge_u32_e64 vcc, v22, v16
		v_add_u32_e32 v26, v22, v18
		v_and_b32_e32 v27, 7, v0
		v_cndmask_b32_e32 v22, v22, v26, vcc
		v_xad_u32 v26, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v28, v23, -1, 1
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_mul_hi_u32 v28, v23, v17
		v_mul_lo_u32 v28, v28, v16
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v23, 1, v28, v23
		v_cmp_ge_u32_e64 vcc, v23, v16
		v_add_u32_e32 v28, v23, v18
		s_cmp_lt_i32 s13, 0
		v_mov_b32_e32 v29, s13
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_cmp_ge_u32_e64 vcc, v23, v16
		v_add_u32_e32 v28, v23, v18
		v_mul_lo_u32 v30, s15, v15
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_xad_u32 v28, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v11, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v31, v11, -1, 1
		v_cndmask_b32_e32 v11, v11, v31, vcc
		v_mul_hi_u32 v31, v11, v17
		v_mul_lo_u32 v31, v31, v16
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v11, 1, v31, v11
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v31, v11, v18
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v32, s1
		v_cndmask_b32_e64 v29, v29, v32, s[12:13]
		v_cndmask_b32_e32 v11, v11, v31, vcc
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v31, v11, v18
		v_lshlrev_b32_e32 v27, 4, v27
		v_cndmask_b32_e32 v11, v11, v31, vcc
		v_xad_u32 v31, v11, -1, 1
		v_cmp_lt_i32_e64 vcc, v12, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v32, v12, -1, 1
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_mul_hi_u32 v32, v12, v17
		v_mul_lo_u32 v32, v32, v16
		v_xor_b32_e32 v32, -1, v32
		v_add3_u32 v12, 1, v32, v12
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v32, v12, v18
		v_lshl_add_u32 v30, v30, 1, v27
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v32, v12, v18
		v_lshl_add_u32 v25, v25, 1, v27
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_xad_u32 v32, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v33, v13, -1, 1
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_mul_hi_u32 v33, v13, v17
		v_mul_lo_u32 v33, v33, v16
		v_xor_b32_e32 v33, -1, v33
		v_add3_u32 v13, 1, v33, v13
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v33, v13, v18
		s_mov_b32 s34, 0x7fffffff
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v33, v13, v18
		v_and_b32_e32 v34, 31, v0
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_xad_u32 v33, v13, -1, 1
		v_cndmask_b32_e64 v13, v13, v33, s[24:25]
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v33, v14, -1, 1
		v_cndmask_b32_e32 v14, v14, v33, vcc
		v_mul_hi_u32 v17, v14, v17
		v_mul_lo_u32 v17, v17, v16
		v_xor_b32_e32 v17, -1, v17
		v_add3_u32 v14, 1, v17, v14
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v17, v14, v18
		v_mov_b32_e32 v33, 8
		v_mul_lo_u32 v33, v33, v34
		v_cndmask_b32_e32 v14, v14, v17, vcc
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v16, v14, v18
		s_mov_b32 s1, 63
		v_cndmask_b32_e32 v14, v14, v16, vcc
		v_xad_u32 v16, v14, -1, 1
		v_cndmask_b32_e64 v14, v14, v16, s[24:25]
		v_add_u32_e32 v16, s0, v33
		v_cmp_lt_i32_e64 vcc, v16, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v17, v16, -1, 1
		v_cndmask_b32_e32 v16, v16, v17, vcc
		v_cvt_f32_u32_e32 v17, v29
		v_rcp_iflag_f32_e32 v17, v17
		s_add_i32 s32, s14, 63
		v_mul_f32_e32 v2, v2, v17
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v17, v29, -1, 1
		v_mul_lo_u32 v18, v17, v2
		v_mul_hi_u32 v18, v2, v18
		v_add_u32_e32 v2, v2, v18
		v_mul_hi_u32 v18, v16, v2
		v_mul_lo_u32 v18, v18, v29
		v_xor_b32_e32 v18, -1, v18
		v_add3_u32 v16, 1, v18, v16
		v_add_u32_e32 v18, v16, v17
		v_cmp_ge_u32_e64 vcc, v16, v29
		v_add3_u32 v34, 1, v33, s0
		s_cmp_lt_i32 s32, 0
		v_cndmask_b32_e32 v16, v16, v18, vcc
		v_add_u32_e32 v18, v16, v17
		v_cmp_ge_u32_e64 vcc, v16, v29
		v_add3_u32 v35, 2, v33, s0
		v_add3_u32 v36, 3, v33, s0
		v_cndmask_b32_e32 v16, v16, v18, vcc
		v_xad_u32 v18, v16, -1, 1
		v_cndmask_b32_e64 v16, v16, v18, s[24:25]
		v_cmp_lt_i32_e64 vcc, v34, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v18, v34, -1, 1
		v_cndmask_b32_e32 v18, v34, v18, vcc
		v_mul_hi_u32 v34, v18, v2
		v_mul_lo_u32 v34, v34, v29
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v18, 1, v34, v18
		v_add_u32_e32 v34, v18, v17
		v_cmp_ge_u32_e64 vcc, v18, v29
		v_add3_u32 v37, 4, v33, s0
		v_add3_u32 v38, 5, v33, s0
		v_cndmask_b32_e32 v18, v18, v34, vcc
		v_add_u32_e32 v34, v18, v17
		v_cmp_ge_u32_e64 vcc, v18, v29
		v_add3_u32 v39, 6, v33, s0
		v_add3_u32 v33, 7, v33, s0
		v_cndmask_b32_e32 v18, v18, v34, vcc
		v_xad_u32 v34, v18, -1, 1
		v_cndmask_b32_e64 v18, v18, v34, s[24:25]
		v_cmp_lt_i32_e64 vcc, v35, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v34, v35, -1, 1
		v_cndmask_b32_e32 v34, v35, v34, vcc
		v_mul_hi_u32 v35, v34, v2
		v_mul_lo_u32 v35, v35, v29
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v34, 1, v35, v34
		v_add_u32_e32 v35, v34, v17
		v_cmp_ge_u32_e64 vcc, v34, v29
		s_cselect_b32 s0, s1, 0
		s_add_i32 s0, s32, s0
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_cmp_ge_u32_e64 vcc, v34, v29
		v_add_u32_e32 v35, v34, v17
		v_readfirstlane_b32 s1, v0
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_xad_u32 v35, v34, -1, 1
		v_cndmask_b32_e64 v34, v34, v35, s[24:25]
		v_cmp_lt_i32_e64 vcc, v36, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v35, v36, -1, 1
		v_cndmask_b32_e32 v35, v36, v35, vcc
		v_mul_hi_u32 v36, v35, v2
		v_mul_lo_u32 v36, v36, v29
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v35, 1, v36, v35
		v_cmp_ge_u32_e64 vcc, v35, v29
		v_add_u32_e32 v36, v35, v17
		s_lshr_b32 s1, s1, 6
		v_cndmask_b32_e32 v35, v35, v36, vcc
		v_cmp_ge_u32_e64 vcc, v35, v29
		v_add_u32_e32 v36, v35, v17
		v_lshrrev_b32_e32 v40, 2, v0
		v_cndmask_b32_e32 v35, v35, v36, vcc
		v_xad_u32 v36, v35, -1, 1
		v_cndmask_b32_e64 v35, v35, v36, s[24:25]
		v_cmp_lt_i32_e64 vcc, v37, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v36, v37, -1, 1
		v_cndmask_b32_e32 v36, v37, v36, vcc
		v_mul_hi_u32 v37, v36, v2
		v_mul_lo_u32 v37, v37, v29
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v36, 1, v37, v36
		v_cmp_ge_u32_e64 vcc, v36, v29
		v_add_u32_e32 v37, v36, v17
		s_mul_i32 s36, 0x420, s1
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_cmp_ge_u32_e64 vcc, v36, v29
		v_add_u32_e32 v37, v36, v17
		v_lshrrev_b32_e32 v41, 1, v0
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_xad_u32 v37, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v37, s[24:25]
		v_cmp_lt_i32_e64 vcc, v38, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v37, v38, -1, 1
		v_cndmask_b32_e32 v37, v38, v37, vcc
		v_mul_hi_u32 v38, v37, v2
		v_mul_lo_u32 v38, v38, v29
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v37, 1, v38, v37
		v_cmp_ge_u32_e64 vcc, v37, v29
		v_add_u32_e32 v38, v37, v17
		v_and_b32_e32 v41, 1, v41
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_cmp_ge_u32_e64 vcc, v37, v29
		v_add_u32_e32 v38, v37, v17
		v_and_b32_e32 v42, 1, v0
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_xad_u32 v38, v37, -1, 1
		v_cndmask_b32_e64 v37, v37, v38, s[24:25]
		v_cmp_lt_i32_e64 vcc, v39, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v38, v39, -1, 1
		v_cndmask_b32_e32 v38, v39, v38, vcc
		v_mul_hi_u32 v39, v38, v2
		v_mul_lo_u32 v39, v39, v29
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v38, 1, v39, v38
		v_cmp_ge_u32_e64 vcc, v38, v29
		v_add_u32_e32 v39, v38, v17
		v_mov_b32_e32 v43, 8
		v_mul_lo_u32 v43, v43, v42
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_cmp_ge_u32_e64 vcc, v38, v29
		v_add_u32_e32 v39, v38, v17
		v_mov_b32_e32 v42, 16
		v_mul_lo_u32 v42, v42, v41
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_xad_u32 v39, v38, -1, 1
		v_cndmask_b32_e64 v38, v38, v39, s[24:25]
		v_cmp_lt_i32_e64 vcc, v33, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v39, v33, -1, 1
		v_cndmask_b32_e32 v33, v33, v39, vcc
		v_mul_hi_u32 v2, v33, v2
		v_mul_lo_u32 v2, v2, v29
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v33
		v_cmp_ge_u32_e64 vcc, v2, v29
		v_add_u32_e32 v33, v2, v17
		s_mov_b32 m0, s36
		v_cndmask_b32_e32 v2, v2, v33, vcc
		v_cmp_ge_u32_e64 vcc, v2, v29
		v_add_u32_e32 v17, v2, v17
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s37, 0x48, s17
		v_cndmask_b32_e32 v2, v2, v17, vcc
		v_xad_u32 v17, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v17, s[24:25]
		v_and_b32_e32 v17, 1, v40
		v_mov_b32_e32 v29, 32
		v_mul_lo_u32 v29, v29, v17
		v_bitop3_b32 v17, v43, v42, v29 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v17, s14
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 s40, s4
		s_mov_b32 s41, s5
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		v_mov_b32_e32 v29, 0x80000000
		v_cndmask_b32_e32 v33, v29, v30, vcc
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v33, v29, v25, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v4, v4, v10, s[20:21]
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_ashr_i32 s0, s0, 6
		v_bitop3_b32 v10, v24, v6, v9 bitop3:0x96
		v_xor_b32_e32 v10, v10, v20
		v_bitop3_b32 v6, 32, v24, v6 bitop3:0x96
		v_bitop3_b32 v6, v6, v9, v20 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v10, s14
		v_cmp_lt_i32_e64 vcc, v6, s14
		v_lshlrev_b32_e32 v9, 1, v16
		v_mul_lo_u32 v20, s17, v8
		v_lshl_add_u32 v20, v20, 3, v9
		v_mul_lo_u32 v24, s17, v5
		v_lshl_add_u32 v20, v24, 1, v20
		v_mul_lo_u32 v24, s17, v3
		v_lshl_add_u32 v20, v24, 5, v20
		v_add_u32_e32 v24, s37, v20
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v33, v29, v20, s[2:3]
		buffer_load_dwordx4 v33, s[40:43], 0 offen lds
		s_lshl_b32 s4, s17, 3
		v_add_u32_e32 v33, s4, v20
		v_cndmask_b32_e64 v33, v29, v33, s[2:3]
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v24, v29, v24, vcc
		buffer_load_dwordx4 v33, s[40:43], 0 offen lds
		s_lshl_b32 s2, s17, 6
		v_add_u32_e32 v33, s2, v20
		v_cndmask_b32_e32 v33, v29, v33, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v19, v19, v21, s[26:27]
		buffer_load_dwordx4 v33, s[40:43], 0 offen lds
		v_cmp_eq_u32_e64 s[2:3], v8, s16
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v21, v22, v26, s[28:29]
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		v_and_b32_e32 v22, 7, v40
		s_add_i32 s4, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v17, s4
		v_add_u32_e32 v24, 0x80, v30
		s_lshl_b32 s5, s17, 7
		v_add_u32_e32 v26, s5, v20
		v_cndmask_b32_e32 v24, v29, v24, vcc
		s_add_i32 m0, m0, 0xffff1920
		v_cndmask_b32_e64 v23, v23, v28, s[30:31]
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_add_u32_e32 v24, 0x80, v25
		v_cndmask_b32_e32 v24, v29, v24, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v11, v11, v31, s[22:23]
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[20:21], v10, s4
		v_cmp_lt_i32_e64 vcc, v6, s4
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v24, v29, v26, s[20:21]
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		s_mul_i32 s4, 0x88, s17
		v_add_u32_e32 v24, s4, v20
		v_cndmask_b32_e64 v24, v29, v24, s[20:21]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v26, 0x100, v30
		v_add_u32_e32 v25, 0x100, v25
		v_mov_b32_e32 v28, 0x420
		v_mul_lo_u32 v28, v28, v22
		s_mul_i32 s4, 0xc0, s17
		v_add_u32_e32 v22, s4, v20
		v_cndmask_b32_e32 v22, v29, v22, vcc
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		s_mul_i32 s4, 0xc8, s17
		v_add_u32_e32 v24, s4, v20
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v30, 3, v5
		v_cndmask_b32_e32 v24, v29, v24, vcc
		buffer_load_dwordx4 v22, s[40:43], 0 offen lds
		s_mul_i32 s4, 0x108, s17
		v_add_u32_e32 v22, s4, v20
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v31, 3, v0
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		s_add_i32 s4, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v17, s4
		s_lshl_b32 s5, s17, 8
		v_add_u32_e32 v24, s5, v20
		v_cndmask_b32_e32 v26, v29, v26, vcc
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v25, v29, v25, vcc
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v6, s4
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[20:21], v10, s4
		buffer_load_dwordx4 v25, s[32:35], 0 offen lds
		v_lshlrev_b32_e32 v25, 3, v31
		s_add_i32 m0, m0, 0x128e0
		v_cndmask_b32_e64 v24, v29, v24, s[20:21]
		v_cndmask_b32_e64 v22, v29, v22, s[20:21]
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		s_mul_i32 s4, 0x140, s17
		v_add_u32_e32 v24, s4, v20
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v12, v12, v32, s[12:13]
		buffer_load_dwordx4 v22, s[40:43], 0 offen lds
		v_cndmask_b32_e32 v22, v29, v24, vcc
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v24, 63, v0
		s_mul_i32 s4, 0x148, s17
		v_add_u32_e32 v26, s4, v20
		v_cndmask_b32_e32 v26, v29, v26, vcc
		v_cmp_ne_u32_e64 vcc, v8, s16
		v_lshlrev_b32_e32 v8, 7, v8
		v_lshrrev_b32_e32 v31, 4, v24
		v_lshlrev_b32_e32 v32, 4, v31
		v_and_b32_e32 v33, 15, v24
		buffer_load_dwordx4 v22, s[40:43], 0 offen lds
		v_mov_b32_e32 v22, 0x420
		v_mul_lo_u32 v22, v22, v33
		s_add_i32 m0, m0, 0x2100
		v_add3_u32 v8, v8, v32, v22
		s_add_i32 s4, s0, -3
		buffer_load_dwordx4 v26, s[40:43], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[40:43], v8
		ds_read_b128 v[44:47], v8 offset:64
		ds_read_b128 v[48:51], v8 offset:256
		ds_read_b128 v[52:55], v8 offset:320
		ds_read_b128 v[56:59], v8 offset:512
		ds_read_b128 v[60:63], v8 offset:576
		ds_read_b128 v[64:67], v8 offset:768
		ds_read_b128 v[68:71], v8 offset:832
		v_lshl_add_u32 v22, v30, 5, v25
		v_lshlrev_b32_e32 v26, 9, v3
		v_add3_u32 v22, v22, v26, v28
		ds_read_b64_tr_b16 v[72:73], v22 offset:50656
		ds_read_b64_tr_b16 v[74:75], v22 offset:59104
		v_add_u32_e32 v25, 0x10000, v25
		v_lshl_add_u32 v25, v30, 5, v25
		v_add3_u32 v25, v25, v26, v28
		ds_read_b64_tr_b16 v[76:77], v25 offset:2016
		ds_read_b64_tr_b16 v[78:79], v25 offset:10464
		ds_read_b64_tr_b16 v[80:81], v22 offset:50784
		ds_read_b64_tr_b16 v[82:83], v22 offset:59232
		ds_read_b64_tr_b16 v[84:85], v25 offset:2144
		ds_read_b64_tr_b16 v[86:87], v25 offset:10592
		ds_read_b64_tr_b16 v[88:89], v22 offset:50912
		ds_read_b64_tr_b16 v[90:91], v22 offset:59360
		ds_read_b64_tr_b16 v[92:93], v25 offset:2272
		ds_read_b64_tr_b16 v[94:95], v25 offset:10720
		ds_read_b64_tr_b16 v[96:97], v22 offset:51040
		ds_read_b64_tr_b16 v[98:99], v22 offset:59488
		ds_read_b64_tr_b16 v[100:101], v25 offset:2400
		ds_read_b64_tr_b16 v[102:103], v25 offset:10848
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[44:45], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[44:45]
		s_setprio 0
		v_add_u32_e32 v25, 0x180, v27
		s_lshl_b32 s5, s15, 1
		v_mul_lo_u32 v15, s5, v15
		v_add_u32_e32 v26, v25, v15
		v_mul_lo_u32 v1, s5, v1
		v_add_u32_e32 v15, v25, v1
		s_mul_i32 s5, 0x180, s17
		s_mul_i32 s12, 0x188, s17
		s_mul_i32 s13, 0x1c0, s17
		s_mul_i32 s15, 0x1c8, s17
		s_cmp_lt_i32 0, s4
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
		s_mov_b32 s20, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		s_cmp_ge_u32 s20, 2
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s20, -2
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		s_add_i32 s23, s20, 1
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s23
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		s_add_i32 s22, s16, 3
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		s_mul_i32 s22, s22, 64
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[68:71], v[156:159]
		s_setprio 1
		s_barrier
		s_xor_b32 s22, s22, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s14, s22
		v_cmp_lt_i32_e64 vcc, v17, s22
		v_cmp_lt_i32_e64 s[24:25], v10, s22
		s_lshl_b32 s23, s16, 7
		v_cndmask_b32_e32 v1, v29, v26, vcc
		s_mul_i32 s26, 0x4200, s20
		v_cndmask_b32_e32 v25, v29, v15, vcc
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_add_i32 s22, s36, s26
		s_mov_b32 m0, s22
		s_mul_i32 s20, 0x8400, s20
		buffer_load_dwordx4 v1, s[32:35], s23 offen lds
		s_mul_i32 s22, s17, s16
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s22, s22, 7
		buffer_load_dwordx4 v25, s[32:35], s23 offen lds
		v_add_u32_e32 v1, s22, v20
		s_add_i32 s22, s5, s22
		v_add_u32_e32 v25, s22, v20
		v_cndmask_b32_e64 v25, v29, v25, s[24:25]
		v_add_u32_e32 v27, s12, v1
		v_cndmask_b32_e64 v27, v29, v27, s[24:25]
		s_add_i32 s20, s36, s20
		v_add_u32_e32 v28, s13, v1
		s_add_i32 m0, s20, 0xc5e0
		v_cndmask_b32_e32 v28, v29, v28, vcc
		buffer_load_dwordx4 v25, s[40:43], 0 offen lds
		v_add_u32_e32 v1, s15, v1
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v1, v29, v1, vcc
		buffer_load_dwordx4 v27, s[40:43], 0 offen lds
		s_mul_i32 s20, 0x4200, s21
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s22, 0x8400, s21
		buffer_load_dwordx4 v28, s[40:43], 0 offen lds
		s_add_i32 s23, s22, 0x10000
		v_add_u32_e32 v25, s22, v22
		v_add_u32_e32 v27, s23, v22
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v28, s20, v8
		buffer_load_dwordx4 v1, s[40:43], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(6)
		ds_read_b128 v[40:43], v28
		ds_read_b128 v[44:47], v28 offset:64
		ds_read_b128 v[48:51], v28 offset:256
		ds_read_b128 v[52:55], v28 offset:320
		ds_read_b128 v[56:59], v28 offset:512
		ds_read_b128 v[60:63], v28 offset:576
		ds_read_b128 v[64:67], v28 offset:768
		ds_read_b128 v[68:71], v28 offset:832
		ds_read_b64_tr_b16 v[72:73], v25 offset:50656
		ds_read_b64_tr_b16 v[74:75], v25 offset:59104
		ds_read_b64_tr_b16 v[76:77], v27 offset:2016
		ds_read_b64_tr_b16 v[78:79], v27 offset:10464
		ds_read_b64_tr_b16 v[80:81], v25 offset:50784
		ds_read_b64_tr_b16 v[82:83], v25 offset:59232
		ds_read_b64_tr_b16 v[84:85], v27 offset:2144
		ds_read_b64_tr_b16 v[86:87], v27 offset:10592
		ds_read_b64_tr_b16 v[88:89], v25 offset:50912
		ds_read_b64_tr_b16 v[90:91], v25 offset:59360
		ds_read_b64_tr_b16 v[92:93], v27 offset:2272
		ds_read_b64_tr_b16 v[94:95], v27 offset:10720
		ds_read_b64_tr_b16 v[96:97], v25 offset:51040
		ds_read_b64_tr_b16 v[98:99], v25 offset:59488
		ds_read_b64_tr_b16 v[100:101], v27 offset:2400
		ds_read_b64_tr_b16 v[102:103], v27 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s4
		s_mov_b32 s20, s21
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[44:45], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[44:45]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s34
		s_mov_b32 s15, s35
		buffer_load_dwordx4 v[168:171], v9, s[12:15], 0 offen
		v_mul_lo_u32 v1, s18, v4
		v_add_lshl_u32 v6, v16, v1, 1
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s34
		s_mov_b32 s7, s35
		buffer_load_ushort v9, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v18, v1, 1
		buffer_load_ushort v10, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v34, v1, 1
		buffer_load_ushort v15, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v35, v1, 1
		buffer_load_ushort v17, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v36, v1, 1
		buffer_load_ushort v20, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v37, v1, 1
		buffer_load_ushort v25, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v6, v38, v1, 1
		buffer_load_ushort v26, v6, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v6, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v19
		v_add_lshl_u32 v27, v16, v1, 1
		buffer_load_ushort v28, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v18, v1, 1
		buffer_load_ushort v29, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v34, v1, 1
		buffer_load_ushort v30, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v35, v1, 1
		buffer_load_ushort v32, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v36, v1, 1
		buffer_load_ushort v33, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v37, v1, 1
		buffer_load_ushort v39, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v27, v38, v1, 1
		buffer_load_ushort v172, v27, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v27, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v21
		v_add_lshl_u32 v173, v16, v1, 1
		buffer_load_ushort v174, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v18, v1, 1
		buffer_load_ushort v175, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v34, v1, 1
		buffer_load_ushort v176, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v35, v1, 1
		buffer_load_ushort v177, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v36, v1, 1
		buffer_load_ushort v178, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v37, v1, 1
		buffer_load_ushort v179, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v38, v1, 1
		buffer_load_ushort v180, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v173, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v23
		v_add_lshl_u32 v181, v16, v1, 1
		buffer_load_ushort v182, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v18, v1, 1
		buffer_load_ushort v183, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v34, v1, 1
		buffer_load_ushort v184, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v35, v1, 1
		buffer_load_ushort v185, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v36, v1, 1
		buffer_load_ushort v186, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v37, v1, 1
		buffer_load_ushort v187, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v38, v1, 1
		buffer_load_ushort v188, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v181, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v11
		v_add_lshl_u32 v189, v16, v1, 1
		buffer_load_ushort v190, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v18, v1, 1
		buffer_load_ushort v191, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v34, v1, 1
		buffer_load_ushort v192, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v35, v1, 1
		buffer_load_ushort v193, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v36, v1, 1
		buffer_load_ushort v194, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v37, v1, 1
		buffer_load_ushort v195, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v38, v1, 1
		buffer_load_ushort v196, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v189, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v12
		v_add_lshl_u32 v197, v16, v1, 1
		buffer_load_ushort v198, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v18, v1, 1
		buffer_load_ushort v199, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v34, v1, 1
		buffer_load_ushort v200, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v35, v1, 1
		buffer_load_ushort v201, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v36, v1, 1
		buffer_load_ushort v202, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v37, v1, 1
		buffer_load_ushort v203, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v38, v1, 1
		buffer_load_ushort v204, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v197, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v13
		v_add_lshl_u32 v205, v16, v1, 1
		buffer_load_ushort v206, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v18, v1, 1
		buffer_load_ushort v207, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v34, v1, 1
		buffer_load_ushort v208, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v35, v1, 1
		buffer_load_ushort v209, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v36, v1, 1
		buffer_load_ushort v210, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v37, v1, 1
		buffer_load_ushort v211, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v38, v1, 1
		buffer_load_ushort v212, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v205, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v14
		v_add_lshl_u32 v213, v16, v1, 1
		buffer_load_ushort v214, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v18, v1, 1
		buffer_load_ushort v215, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v34, v1, 1
		buffer_load_ushort v216, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v35, v1, 1
		buffer_load_ushort v217, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v36, v1, 1
		buffer_load_ushort v218, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v37, v1, 1
		buffer_load_ushort v219, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v38, v1, 1
		buffer_load_ushort v220, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v213, v1, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[68:71], v[156:159]
		s_add_i32 s2, s0, -2
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_mul_hi_u32 s3, s2, 0xaaaaaaab
		s_cselect_b32 s4, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s2, s2, s3
		s_xor_b32 s3, s2, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s2, s3, s2
		s_waitcnt vmcnt(62)
		s_barrier
		s_mul_i32 s3, 0x4200, s2
		v_add_u32_e32 v1, s3, v8
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:320
		ds_read_b128 v[56:59], v1 offset:512
		ds_read_b128 v[60:63], v1 offset:576
		ds_read_b128 v[64:67], v1 offset:768
		ds_read_b128 v[68:71], v1 offset:832
		s_mul_i32 s2, 0x8400, s2
		v_add_u32_e32 v1, s2, v22
		ds_read_b64_tr_b16 v[72:73], v1 offset:50656
		ds_read_b64_tr_b16 v[74:75], v1 offset:59104
		s_add_i32 s2, s2, 0x10000
		v_add_u32_e32 v76, s2, v22
		ds_read_b64_tr_b16 v[80:81], v76 offset:2016
		ds_read_b64_tr_b16 v[82:83], v76 offset:10464
		ds_read_b64_tr_b16 v[84:85], v1 offset:50784
		ds_read_b64_tr_b16 v[86:87], v1 offset:59232
		ds_read_b64_tr_b16 v[88:89], v76 offset:2144
		ds_read_b64_tr_b16 v[90:91], v76 offset:10592
		ds_read_b64_tr_b16 v[92:93], v1 offset:50912
		ds_read_b64_tr_b16 v[94:95], v1 offset:59360
		ds_read_b64_tr_b16 v[96:97], v76 offset:2272
		ds_read_b64_tr_b16 v[98:99], v76 offset:10720
		ds_read_b64_tr_b16 v[100:101], v1 offset:51040
		ds_read_b64_tr_b16 v[102:103], v1 offset:59488
		ds_read_b64_tr_b16 v[224:225], v76 offset:2400
		ds_read_b64_tr_b16 v[226:227], v76 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		s_add_i32 s0, s0, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s3, s0, -1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s0, s3, s0
		s_mul_hi_u32 s2, s0, 0xaaaaaaab
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_cselect_b32 s3, 1, 0
		s_lshr_b32 s2, s2, 1
		s_mul_i32 s2, s2, 3
		s_xor_b32 s2, s2, -1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		s_add_i32 s2, s2, 1
		s_add_i32 s0, s0, s2
		s_xor_b32 s2, s0, -1
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[48:51], v[132:135]
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s0, s2, s0
		s_mul_i32 s2, 0x4200, s0
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_add_u32_e32 v1, s2, v8
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[224:227], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[224:227], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[224:227], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[224:227], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[68:71], v[156:159]
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:320
		ds_read_b128 v[56:59], v1 offset:512
		ds_read_b128 v[60:63], v1 offset:576
		ds_read_b128 v[64:67], v1 offset:768
		ds_read_b128 v[68:71], v1 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v1, s0, v22
		ds_read_b64_tr_b16 v[72:73], v1 offset:50656
		ds_read_b64_tr_b16 v[74:75], v1 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v8, s0, v22
		ds_read_b64_tr_b16 v[76:77], v8 offset:2016
		ds_read_b64_tr_b16 v[78:79], v8 offset:10464
		ds_read_b64_tr_b16 v[80:81], v1 offset:50784
		ds_read_b64_tr_b16 v[82:83], v1 offset:59232
		ds_read_b64_tr_b16 v[84:85], v8 offset:2144
		ds_read_b64_tr_b16 v[86:87], v8 offset:10592
		ds_read_b64_tr_b16 v[88:89], v1 offset:50912
		ds_read_b64_tr_b16 v[90:91], v1 offset:59360
		ds_read_b64_tr_b16 v[92:93], v8 offset:2272
		ds_read_b64_tr_b16 v[94:95], v8 offset:10720
		ds_read_b64_tr_b16 v[96:97], v1 offset:51040
		ds_read_b64_tr_b16 v[98:99], v1 offset:59488
		ds_read_b64_tr_b16 v[100:101], v8 offset:2400
		ds_read_b64_tr_b16 v[102:103], v8 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[68:71], v[156:159]
		v_lshlrev_b32_e32 v1, 1, v3
		v_and_b32_e32 v3, 1, v5
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v5, 1, v7
		v_lshlrev_b32_e32 v5, 3, v5
		v_xor_b32_e32 v3, v3, v5
		v_bitop3_b32 v1, v0, v1, v3 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v1
		ds_write_b128 v3, v[104:107]
		v_xor_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 4, v1
		ds_write_b128 v1, v[108:111] offset:8192
		ds_write_b128 v3, v[112:115] offset:16384
		ds_write_b128 v1, v[116:119] offset:24576
		v_and_b32_e32 v5, 1, v31
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_cvt_f32_f16_e32 v40, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v7, 3, v24
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v8, 13, v7
		v_lshl_add_u32 v5, v5, 14, v8
		v_lshrrev_b32_e32 v8, 5, v24
		v_lshl_add_u32 v8, s1, 1, v8
		v_and_b32_e32 v9, 7, v24
		v_lshl_add_u32 v8, v9, 5, v8
		v_lshrrev_b32_e32 v22, 1, v24
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 2, v22
		v_lshrrev_b32_e32 v9, 2, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_bitop3_b32 v7, v22, v9, v7 bitop3:0x96
		v_bitop3_b32 v0, v8, v0, v7 bitop3:0x96
		v_lshl_add_u32 v0, v0, 4, v5
		ds_read_b128 v[44:47], v0
		ds_read_b128 v[48:51], v0 offset:256
		ds_read_b128 v[52:55], v0 offset:4096
		ds_read_b128 v[56:59], v0 offset:4352
		v_cvt_f32_f16_e32 v41, v10
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v8, v15
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v9, v17
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v42, v20
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[120:123]
		ds_write_b128 v1, v[124:127] offset:8192
		ds_write_b128 v3, v[128:131] offset:16384
		ds_write_b128 v1, v[132:135] offset:24576
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v43, v25
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v24, v26
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v25, v6
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v6, v28
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v0
		ds_read_b128 v[64:67], v0 offset:256
		ds_read_b128 v[68:71], v0 offset:4096
		ds_read_b128 v[72:75], v0 offset:4352
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v7, v29
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v28, v30
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v29, v32
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v30, v33
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[136:139]
		ds_write_b128 v1, v[140:143] offset:8192
		ds_write_b128 v3, v[144:147] offset:16384
		ds_write_b128 v1, v[148:151] offset:24576
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v31, v39
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v32, v172
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v33, v27
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v26, v174
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v0
		ds_read_b128 v[80:83], v0 offset:256
		ds_read_b128 v[84:87], v0 offset:4096
		ds_read_b128 v[88:91], v0 offset:4352
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v27, v175
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v92, v176
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v93, v177
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v94, v178
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[152:155]
		ds_write_b128 v1, v[156:159] offset:8192
		ds_write_b128 v3, v[160:163] offset:16384
		ds_write_b128 v1, v[164:167] offset:24576
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v95, v179
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v96, v180
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v97, v173
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v98, v182
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[100:103], v0
		ds_read_b128 v[104:107], v0 offset:256
		ds_read_b128 v[108:111], v0 offset:4096
		ds_read_b128 v[112:115], v0 offset:4352
		v_cvt_f32_f16_e32 v0, v168
		v_cvt_f32_f16_sdwa v1, v168 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v116, v169
		v_cvt_f32_f16_sdwa v117, v169 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v118, v170
		v_cvt_f32_f16_sdwa v119, v170 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v120, v171
		v_cvt_f32_f16_sdwa v121, v171 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v99, v183
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v122, v184
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v123, v185
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v124, v186
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v125, v187
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v126, v188
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v127, v181
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v128, v190
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v129, v191
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v130, v192
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v131, v193
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v132, v194
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v133, v195
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v134, v196
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v135, v189
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v136, v198
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v137, v199
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v138, v200
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v139, v201
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v140, v202
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v141, v203
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v142, v204
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v143, v197
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v144, v206
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v145, v207
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v146, v208
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v147, v209
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v148, v210
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v149, v211
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v150, v212
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v151, v205
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v152, v214
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v153, v215
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v154, v216
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v155, v217
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v156, v218
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v157, v219
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v158, v220
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v159, v213
		v_pk_add_f32 v[44:45], v[44:45], v[0:1]
		v_pk_fma_f32 v[160:161], v[44:45], v[40:41], v[44:45]
		v_cvt_pk_f16_f32 v3, v160, v161
		v_pk_add_f32 v[40:41], v[46:47], v[116:117]
		v_pk_fma_f32 v[44:45], v[40:41], v[8:9], v[40:41]
		v_cvt_pk_f16_f32 v5, v44, v45
		v_pk_add_f32 v[8:9], v[48:49], v[118:119]
		v_pk_fma_f32 v[40:41], v[8:9], v[42:43], v[8:9]
		v_cvt_pk_f16_f32 v8, v40, v41
		v_pk_add_f32 v[40:41], v[50:51], v[120:121]
		v_pk_fma_f32 v[42:43], v[40:41], v[24:25], v[40:41]
		v_cvt_pk_f16_f32 v9, v42, v43
		v_pk_add_f32 v[24:25], v[52:53], v[0:1]
		v_pk_fma_f32 v[40:41], v[24:25], v[6:7], v[24:25]
		v_cvt_pk_f16_f32 v6, v40, v41
		v_pk_add_f32 v[24:25], v[54:55], v[116:117]
		v_pk_fma_f32 v[40:41], v[24:25], v[28:29], v[24:25]
		v_cvt_pk_f16_f32 v7, v40, v41
		v_pk_add_f32 v[24:25], v[56:57], v[118:119]
		v_pk_fma_f32 v[28:29], v[24:25], v[30:31], v[24:25]
		v_cvt_pk_f16_f32 v10, v28, v29
		v_pk_add_f32 v[24:25], v[58:59], v[120:121]
		v_pk_fma_f32 v[28:29], v[24:25], v[32:33], v[24:25]
		v_cvt_pk_f16_f32 v15, v28, v29
		v_pk_add_f32 v[24:25], v[60:61], v[0:1]
		v_pk_fma_f32 v[28:29], v[24:25], v[26:27], v[24:25]
		v_cvt_pk_f16_f32 v17, v28, v29
		v_pk_add_f32 v[24:25], v[62:63], v[116:117]
		v_pk_fma_f32 v[26:27], v[24:25], v[92:93], v[24:25]
		v_cvt_pk_f16_f32 v20, v26, v27
		v_pk_add_f32 v[24:25], v[64:65], v[118:119]
		v_pk_fma_f32 v[26:27], v[24:25], v[94:95], v[24:25]
		v_cvt_pk_f16_f32 v22, v26, v27
		v_pk_add_f32 v[24:25], v[66:67], v[120:121]
		v_pk_fma_f32 v[26:27], v[24:25], v[96:97], v[24:25]
		v_cvt_pk_f16_f32 v24, v26, v27
		v_pk_add_f32 v[26:27], v[68:69], v[0:1]
		v_pk_fma_f32 v[28:29], v[26:27], v[98:99], v[26:27]
		v_cvt_pk_f16_f32 v25, v28, v29
		v_pk_add_f32 v[26:27], v[70:71], v[116:117]
		v_pk_fma_f32 v[28:29], v[26:27], v[122:123], v[26:27]
		v_cvt_pk_f16_f32 v26, v28, v29
		v_pk_add_f32 v[28:29], v[72:73], v[118:119]
		v_pk_fma_f32 v[30:31], v[28:29], v[124:125], v[28:29]
		v_cvt_pk_f16_f32 v27, v30, v31
		v_pk_add_f32 v[28:29], v[74:75], v[120:121]
		v_pk_fma_f32 v[30:31], v[28:29], v[126:127], v[28:29]
		v_cvt_pk_f16_f32 v28, v30, v31
		v_pk_add_f32 v[30:31], v[76:77], v[0:1]
		v_pk_fma_f32 v[32:33], v[30:31], v[128:129], v[30:31]
		v_cvt_pk_f16_f32 v29, v32, v33
		v_pk_add_f32 v[30:31], v[78:79], v[116:117]
		v_pk_fma_f32 v[32:33], v[30:31], v[130:131], v[30:31]
		v_cvt_pk_f16_f32 v30, v32, v33
		v_pk_add_f32 v[32:33], v[80:81], v[118:119]
		v_pk_fma_f32 v[40:41], v[32:33], v[132:133], v[32:33]
		v_cvt_pk_f16_f32 v31, v40, v41
		v_pk_add_f32 v[32:33], v[82:83], v[120:121]
		v_pk_fma_f32 v[40:41], v[32:33], v[134:135], v[32:33]
		v_cvt_pk_f16_f32 v32, v40, v41
		v_pk_add_f32 v[40:41], v[84:85], v[0:1]
		v_pk_fma_f32 v[42:43], v[40:41], v[136:137], v[40:41]
		v_cvt_pk_f16_f32 v33, v42, v43
		v_pk_add_f32 v[40:41], v[86:87], v[116:117]
		v_pk_fma_f32 v[42:43], v[40:41], v[138:139], v[40:41]
		v_cvt_pk_f16_f32 v39, v42, v43
		v_pk_add_f32 v[40:41], v[88:89], v[118:119]
		v_pk_fma_f32 v[42:43], v[40:41], v[140:141], v[40:41]
		v_cvt_pk_f16_f32 v40, v42, v43
		v_pk_add_f32 v[42:43], v[90:91], v[120:121]
		v_pk_fma_f32 v[44:45], v[42:43], v[142:143], v[42:43]
		v_cvt_pk_f16_f32 v41, v44, v45
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[42:43], v[100:101], v[0:1]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[0:1], v[108:109], v[0:1]
		v_pk_fma_f32 v[44:45], v[42:43], v[144:145], v[42:43]
		v_pk_fma_f32 v[42:43], v[0:1], v[152:153], v[0:1]
		v_cvt_pk_f16_f32 v0, v44, v45
		v_cvt_pk_f16_f32 v1, v42, v43
		v_pk_add_f32 v[42:43], v[102:103], v[116:117]
		v_pk_add_f32 v[44:45], v[110:111], v[116:117]
		v_pk_fma_f32 v[46:47], v[42:43], v[146:147], v[42:43]
		v_pk_fma_f32 v[42:43], v[44:45], v[154:155], v[44:45]
		v_cvt_pk_f16_f32 v44, v46, v47
		v_cvt_pk_f16_f32 v42, v42, v43
		v_pk_add_f32 v[46:47], v[104:105], v[118:119]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[48:49], v[112:113], v[118:119]
		v_pk_fma_f32 v[50:51], v[46:47], v[148:149], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[156:157], v[48:49]
		v_cvt_pk_f16_f32 v43, v50, v51
		v_cvt_pk_f16_f32 v45, v46, v47
		v_pk_add_f32 v[46:47], v[106:107], v[120:121]
		v_pk_add_f32 v[48:49], v[114:115], v[120:121]
		v_pk_fma_f32 v[50:51], v[46:47], v[150:151], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[158:159], v[48:49]
		v_cvt_pk_f16_f32 v48, v50, v51
		v_cvt_pk_f16_f32 v46, v46, v47
		v_and_b32_e32 v47, 0xffff, v3
		v_mul_lo_u32 v4, s19, v4
		v_add_lshl_u32 v49, v16, v4, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s34
		s_mov_b32 s3, s35
		buffer_store_short v47, v49, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v47, v18, v4, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v5
		v_add_lshl_u32 v47, v34, v4, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v5
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v8
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v8
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v9
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v9
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v6
		v_mul_lo_u32 v4, s19, v19
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v6
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v7
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v7
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v10
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v10
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v15
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v15
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v17
		v_mul_lo_u32 v4, s19, v21
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v17
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v20
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v20
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v22
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v22
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v24
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v24
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v25
		v_mul_lo_u32 v4, s19, v23
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v25
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v26
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v26
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v27
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v27
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v28
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v28
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v29
		v_mul_lo_u32 v4, s19, v11
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v29
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v30
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v30
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v31
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v31
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v32
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v32
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v33
		v_mul_lo_u32 v4, s19, v12
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v33
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v39
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v39
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v35, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v40
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v40
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v41
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v41
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v0
		v_mul_lo_u32 v4, s19, v13
		v_add_lshl_u32 v5, v16, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v0
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v18, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v44
		v_add_lshl_u32 v3, v34, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v44
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v35, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v43
		v_add_lshl_u32 v3, v36, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v43
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v37, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v48
		v_add_lshl_u32 v3, v38, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v14
		v_lshrrev_b32_e32 v3, 16, v48
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v1
		v_add_lshl_u32 v4, v16, v0, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v1
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v18, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v42
		v_add_lshl_u32 v3, v34, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v42
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v35, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v45
		v_add_lshl_u32 v3, v36, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v45
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v37, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v46
		v_add_lshl_u32 v3, v38, v0, 1
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
		.amdhsa_next_free_sgpr 46
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
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 46
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
    .sgpr_count:     46
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
