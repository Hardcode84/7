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
		v_and_b32_e32 v7, 1, v7
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
		v_and_b32_e32 v3, 1, v3
		v_cndmask_b32_e32 v22, v22, v26, vcc
		v_cmp_ge_u32_e64 vcc, v22, v16
		v_add_u32_e32 v26, v22, v18
		v_and_b32_e32 v27, 1, v0
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
		v_lshlrev_b32_e32 v27, 4, v27
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_cmp_ge_u32_e64 vcc, v23, v16
		v_add_u32_e32 v28, v23, v18
		v_mul_lo_u32 v29, s15, v15
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_xad_u32 v28, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v11, s16
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v30, v11, -1, 1
		v_cndmask_b32_e32 v11, v11, v30, vcc
		v_mul_hi_u32 v30, v11, v17
		v_mul_lo_u32 v30, v30, v16
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v11, 1, v30, v11
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v30, v11, v18
		v_lshl_add_u32 v29, v29, 1, v27
		v_cndmask_b32_e32 v11, v11, v30, vcc
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v30, v11, v18
		v_mov_b32_e32 v31, s13
		v_cndmask_b32_e32 v11, v11, v30, vcc
		v_xad_u32 v30, v11, -1, 1
		v_cmp_lt_i32_e64 vcc, v12, s16
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v32, v12, -1, 1
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_mul_hi_u32 v32, v12, v17
		v_mul_lo_u32 v32, v32, v16
		v_xor_b32_e32 v32, -1, v32
		v_add3_u32 v12, 1, v32, v12
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v32, v12, v18
		v_lshl_add_u32 v25, v25, 1, v27
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v32, v12, v18
		s_xor_b32 s1, s13, -1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		v_cndmask_b32_e32 v12, v12, v32, vcc
		v_xad_u32 v32, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v33, v13, -1, 1
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_mul_hi_u32 v33, v13, v17
		v_mul_lo_u32 v33, v33, v16
		v_xor_b32_e32 v33, -1, v33
		v_add3_u32 v13, 1, v33, v13
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v33, v13, v18
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v34, s1
		v_cndmask_b32_e64 v31, v31, v34, s[12:13]
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v33, v13, v18
		v_and_b32_e32 v34, 31, v0
		v_cndmask_b32_e32 v13, v13, v33, vcc
		v_xad_u32 v33, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v35, v14, -1, 1
		v_cndmask_b32_e32 v14, v14, v35, vcc
		v_mul_hi_u32 v17, v14, v17
		v_mul_lo_u32 v17, v17, v16
		v_xor_b32_e32 v17, -1, v17
		v_add3_u32 v14, 1, v17, v14
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v17, v14, v18
		v_mov_b32_e32 v35, 8
		v_mul_lo_u32 v35, v35, v34
		v_cndmask_b32_e32 v14, v14, v17, vcc
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v16, v14, v18
		s_mov_b32 s38, 0x7fffffff
		v_cndmask_b32_e32 v14, v14, v16, vcc
		v_xad_u32 v16, v14, -1, 1
		v_add_u32_e32 v17, s0, v35
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v18, v17, -1, 1
		v_cndmask_b32_e32 v17, v17, v18, vcc
		v_cvt_f32_u32_e32 v18, v31
		v_rcp_iflag_f32_e32 v18, v18
		s_mov_b32 s1, 63
		v_mul_f32_e32 v2, v2, v18
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v18, v31, -1, 1
		v_mul_lo_u32 v34, v18, v2
		v_mul_hi_u32 v34, v2, v34
		v_add_u32_e32 v2, v2, v34
		v_mul_hi_u32 v34, v17, v2
		v_mul_lo_u32 v34, v34, v31
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v17, 1, v34, v17
		v_add_u32_e32 v34, v17, v18
		v_cmp_ge_u32_e64 vcc, v17, v31
		v_add3_u32 v36, 1, v35, s0
		s_add_i32 s36, s14, 63
		v_cndmask_b32_e32 v17, v17, v34, vcc
		v_add_u32_e32 v34, v17, v18
		v_cmp_ge_u32_e64 vcc, v17, v31
		v_add3_u32 v37, 2, v35, s0
		v_add3_u32 v38, 3, v35, s0
		v_cndmask_b32_e32 v17, v17, v34, vcc
		v_xad_u32 v34, v17, -1, 1
		v_cndmask_b32_e64 v17, v17, v34, s[24:25]
		v_cmp_lt_i32_e64 vcc, v36, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v34, v36, -1, 1
		v_cndmask_b32_e32 v34, v36, v34, vcc
		v_mul_hi_u32 v36, v34, v2
		v_mul_lo_u32 v36, v36, v31
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v34, 1, v36, v34
		v_add_u32_e32 v36, v34, v18
		v_cmp_ge_u32_e64 vcc, v34, v31
		v_add3_u32 v39, 4, v35, s0
		v_add3_u32 v40, 5, v35, s0
		v_cndmask_b32_e32 v34, v34, v36, vcc
		v_add_u32_e32 v36, v34, v18
		v_cmp_ge_u32_e64 vcc, v34, v31
		v_add3_u32 v41, 6, v35, s0
		v_add3_u32 v35, 7, v35, s0
		v_cndmask_b32_e32 v34, v34, v36, vcc
		v_xad_u32 v36, v34, -1, 1
		v_cndmask_b32_e64 v34, v34, v36, s[24:25]
		v_cmp_lt_i32_e64 vcc, v37, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v36, v37, -1, 1
		v_cndmask_b32_e32 v36, v37, v36, vcc
		v_mul_hi_u32 v37, v36, v2
		v_mul_lo_u32 v37, v37, v31
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v36, 1, v37, v36
		v_add_u32_e32 v37, v36, v18
		v_cmp_ge_u32_e64 vcc, v36, v31
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s0, s1, 0
		s_add_i32 s0, s36, s0
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_cmp_ge_u32_e64 vcc, v36, v31
		v_add_u32_e32 v37, v36, v18
		v_readfirstlane_b32 s1, v0
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_xad_u32 v37, v36, -1, 1
		v_cndmask_b32_e64 v36, v36, v37, s[24:25]
		v_cmp_lt_i32_e64 vcc, v38, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v37, v38, -1, 1
		v_cndmask_b32_e32 v37, v38, v37, vcc
		v_mul_hi_u32 v38, v37, v2
		v_mul_lo_u32 v38, v38, v31
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v37, 1, v38, v37
		v_cmp_ge_u32_e64 vcc, v37, v31
		v_add_u32_e32 v38, v37, v18
		s_lshr_b32 s1, s1, 6
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_cmp_ge_u32_e64 vcc, v37, v31
		v_add_u32_e32 v38, v37, v18
		v_lshrrev_b32_e32 v42, 2, v0
		v_cndmask_b32_e32 v37, v37, v38, vcc
		v_xad_u32 v38, v37, -1, 1
		v_cndmask_b32_e64 v37, v37, v38, s[24:25]
		v_cmp_lt_i32_e64 vcc, v39, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v38, v39, -1, 1
		v_cndmask_b32_e32 v38, v39, v38, vcc
		v_mul_hi_u32 v39, v38, v2
		v_mul_lo_u32 v39, v39, v31
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v38, 1, v39, v38
		v_cmp_ge_u32_e64 vcc, v38, v31
		v_add_u32_e32 v39, v38, v18
		s_mul_i32 s40, 0x420, s1
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_cmp_ge_u32_e64 vcc, v38, v31
		v_add_u32_e32 v39, v38, v18
		v_lshrrev_b32_e32 v43, 1, v0
		v_cndmask_b32_e32 v38, v38, v39, vcc
		v_xad_u32 v39, v38, -1, 1
		v_cndmask_b32_e64 v38, v38, v39, s[24:25]
		v_cmp_lt_i32_e64 vcc, v40, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v39, v40, -1, 1
		v_cndmask_b32_e32 v39, v40, v39, vcc
		v_mul_hi_u32 v40, v39, v2
		v_mul_lo_u32 v40, v40, v31
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v39, 1, v40, v39
		v_cmp_ge_u32_e64 vcc, v39, v31
		v_add_u32_e32 v40, v39, v18
		s_mov_b32 m0, s40
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_cmp_ge_u32_e64 vcc, v39, v31
		v_add_u32_e32 v40, v39, v18
		v_and_b32_e32 v44, 1, v0
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_xad_u32 v40, v39, -1, 1
		v_cndmask_b32_e64 v39, v39, v40, s[24:25]
		v_cmp_lt_i32_e64 vcc, v41, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v40, v41, -1, 1
		v_cndmask_b32_e32 v40, v41, v40, vcc
		v_mul_hi_u32 v41, v40, v2
		v_mul_lo_u32 v41, v41, v31
		v_xor_b32_e32 v41, -1, v41
		v_add3_u32 v40, 1, v41, v40
		v_cmp_ge_u32_e64 vcc, v40, v31
		v_add_u32_e32 v41, v40, v18
		v_mov_b32_e32 v45, 8
		v_mul_lo_u32 v45, v45, v44
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_cmp_ge_u32_e64 vcc, v40, v31
		v_add_u32_e32 v41, v40, v18
		v_cmp_eq_u32_e64 s[42:43], v8, s16
		v_cndmask_b32_e32 v40, v40, v41, vcc
		v_xad_u32 v41, v40, -1, 1
		v_cndmask_b32_e64 v40, v40, v41, s[24:25]
		v_cmp_lt_i32_e64 vcc, v35, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v41, v35, -1, 1
		v_cndmask_b32_e32 v35, v35, v41, vcc
		v_mul_hi_u32 v2, v35, v2
		v_mul_lo_u32 v2, v2, v31
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v35
		v_cmp_ge_u32_e64 vcc, v2, v31
		v_add_u32_e32 v35, v2, v18
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s44, s4
		s_mov_b32 s45, s5
		s_mov_b32 s46, s38
		s_mov_b32 s47, s39
		v_cndmask_b32_e32 v2, v2, v35, vcc
		v_cmp_ge_u32_e64 vcc, v2, v31
		v_add_u32_e32 v18, v2, v18
		v_and_b32_e32 v31, 1, v43
		v_cndmask_b32_e32 v2, v2, v18, vcc
		v_xad_u32 v18, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v18, s[24:25]
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v31
		v_and_b32_e32 v31, 1, v42
		v_mov_b32_e32 v35, 32
		v_mul_lo_u32 v35, v35, v31
		v_bitop3_b32 v18, v45, v18, v35 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v18, s14
		v_and_b32_e32 v31, 1, v42
		v_lshlrev_b32_e32 v31, 6, v31
		v_and_b32_e32 v35, 1, v43
		v_lshlrev_b32_e32 v35, 5, v35
		v_add3_u32 v29, v29, v31, v35
		v_mov_b32_e32 v41, 0x80000000
		v_cndmask_b32_e32 v43, v41, v29, vcc
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		v_add3_u32 v25, v25, v31, v35
		v_cndmask_b32_e32 v43, v41, v25, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v4, v4, v10, s[20:21]
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		s_ashr_i32 s0, s0, 6
		v_bitop3_b32 v10, v24, v6, v9 bitop3:0x96
		v_xor_b32_e32 v10, v10, v20
		v_bitop3_b32 v43, 4, v24, v6 bitop3:0x96
		v_bitop3_b32 v44, 32, v24, v6 bitop3:0x96
		v_bitop3_b32 v44, v44, v9, v20 bitop3:0x96
		v_bitop3_b32 v6, 36, v24, v6 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v10, s14
		v_cmp_lt_i32_e64 vcc, v44, s14
		v_lshlrev_b32_e32 v24, 1, v17
		v_lshlrev_b32_e32 v45, 3, v8
		v_lshlrev_b32_e32 v46, 1, v7
		v_and_b32_e32 v47, 1, v5
		v_add3_u32 v45, v45, v46, v47
		v_lshl_add_u32 v45, v3, 4, v45
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v46, s17, v45
		v_lshl_add_u32 v46, v46, 1, v24
		v_cndmask_b32_e64 v48, v41, v46, s[2:3]
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v19, v19, v21, s[26:27]
		buffer_load_dwordx4 v48, s[44:47], 0 offen lds
		v_bitop3_b32 v21, v43, v9, v20 bitop3:0x96
		v_add_u32_e32 v43, 4, v45
		v_mul_lo_u32 v43, s17, v43
		v_lshl_add_u32 v43, v43, 1, v24
		v_cndmask_b32_e64 v48, v41, v43, s[2:3]
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v22, v22, v26, s[28:29]
		buffer_load_dwordx4 v48, s[44:47], 0 offen lds
		v_bitop3_b32 v6, v6, v9, v20 bitop3:0x96
		v_add_u32_e32 v9, 32, v45
		v_mul_lo_u32 v9, s17, v9
		v_lshl_add_u32 v9, v9, 1, v24
		v_cndmask_b32_e32 v20, v41, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v23, v23, v28, s[30:31]
		buffer_load_dwordx4 v20, s[44:47], 0 offen lds
		v_add_u32_e32 v20, 36, v45
		v_mul_lo_u32 v20, s17, v20
		v_lshl_add_u32 v20, v20, 1, v24
		v_cndmask_b32_e32 v26, v41, v20, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v11, v11, v30, s[32:33]
		buffer_load_dwordx4 v26, s[44:47], 0 offen lds
		v_and_b32_e32 v26, 3, v0
		s_add_i32 s2, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v18, s2
		v_add_u32_e32 v28, 0x80, v29
		s_lshl_b32 s3, s17, 7
		v_cndmask_b32_e32 v28, v41, v28, vcc
		s_add_i32 m0, m0, 0xffff1920
		v_cndmask_b32_e64 v12, v12, v32, s[34:35]
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_add_u32_e32 v28, 0x80, v25
		v_cndmask_b32_e32 v28, v41, v28, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v13, v13, v33, s[22:23]
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_cmp_lt_i32_e64 s[4:5], v10, s2
		v_cmp_lt_i32_e64 vcc, v44, s2
		v_add_u32_e32 v28, s3, v46
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v28, v41, v28, s[4:5]
		buffer_load_dwordx4 v28, s[44:47], 0 offen lds
		v_add_u32_e32 v28, s3, v43
		v_cndmask_b32_e64 v28, v41, v28, s[4:5]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v29, 0x100, v29
		buffer_load_dwordx4 v28, s[44:47], 0 offen lds
		v_add_u32_e32 v28, s3, v9
		v_add_u32_e32 v30, s3, v20
		v_cndmask_b32_e32 v28, v41, v28, vcc
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v30, v41, v30, vcc
		v_add_u32_e32 v25, 0x100, v25
		buffer_load_dwordx4 v28, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v26, 3, v26
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v28, 63, v0
		v_and_b32_e32 v5, 3, v5
		v_and_b32_e32 v32, 7, v42
		s_add_i32 s2, s14, 0xffffff80
		buffer_load_dwordx4 v30, s[44:47], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v18, s2
		s_lshl_b32 s3, s17, 8
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v29, v41, v29, vcc
		v_cndmask_b32_e32 v25, v41, v25, vcc
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v44, s2
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[4:5], v10, s2
		v_mov_b32_e32 v29, 0x420
		v_mul_lo_u32 v29, v29, v32
		v_add_u32_e32 v30, s3, v46
		v_cndmask_b32_e64 v30, v41, v30, s[4:5]
		buffer_load_dwordx4 v25, s[36:39], 0 offen lds
		v_add_u32_e32 v25, s3, v43
		v_cndmask_b32_e64 v25, v41, v25, s[4:5]
		s_add_i32 m0, m0, 0x128e0
		v_cndmask_b32_e64 v14, v14, v16, s[12:13]
		buffer_load_dwordx4 v30, s[44:47], 0 offen lds
		v_add_u32_e32 v16, s3, v9
		v_add_u32_e32 v30, s3, v20
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v16, v41, v16, vcc
		v_cndmask_b32_e32 v30, v41, v30, vcc
		buffer_load_dwordx4 v25, s[44:47], 0 offen lds
		v_cmp_ne_u32_e64 vcc, v8, s16
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v8, 7, v8
		v_lshrrev_b32_e32 v25, 4, v28
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v16, 4, v25
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s2, s0, -3
		v_and_b32_e32 v32, 15, v28
		v_mov_b32_e32 v33, 0x420
		v_mul_lo_u32 v33, v33, v32
		buffer_load_dwordx4 v30, s[44:47], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_add3_u32 v8, v8, v16, v33
		ds_read_b128 v[48:51], v8
		ds_read_b128 v[52:55], v8 offset:64
		ds_read_b128 v[56:59], v8 offset:256
		ds_read_b128 v[60:63], v8 offset:320
		ds_read_b128 v[64:67], v8 offset:512
		ds_read_b128 v[68:71], v8 offset:576
		ds_read_b128 v[72:75], v8 offset:768
		ds_read_b128 v[76:79], v8 offset:832
		v_lshl_add_u32 v16, v5, 5, v26
		v_lshlrev_b32_e32 v30, 9, v3
		v_add3_u32 v16, v16, v30, v29
		ds_read_b64_tr_b16 v[80:81], v16 offset:50656
		ds_read_b64_tr_b16 v[82:83], v16 offset:59104
		v_add_u32_e32 v26, 0x10000, v26
		v_lshl_add_u32 v5, v5, 5, v26
		v_add3_u32 v5, v5, v30, v29
		ds_read_b64_tr_b16 v[84:85], v5 offset:2016
		ds_read_b64_tr_b16 v[86:87], v5 offset:10464
		ds_read_b64_tr_b16 v[88:89], v16 offset:50784
		ds_read_b64_tr_b16 v[90:91], v16 offset:59232
		ds_read_b64_tr_b16 v[92:93], v5 offset:2144
		ds_read_b64_tr_b16 v[94:95], v5 offset:10592
		ds_read_b64_tr_b16 v[96:97], v16 offset:50912
		ds_read_b64_tr_b16 v[98:99], v16 offset:59360
		ds_read_b64_tr_b16 v[100:101], v5 offset:2272
		ds_read_b64_tr_b16 v[102:103], v5 offset:10720
		ds_read_b64_tr_b16 v[104:105], v16 offset:51040
		ds_read_b64_tr_b16 v[106:107], v16 offset:59488
		ds_read_b64_tr_b16 v[108:109], v5 offset:2400
		ds_read_b64_tr_b16 v[110:111], v5 offset:10848
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[48:49], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[48:49]
		s_setprio 0
		v_add3_u32 v5, v27, v31, v35
		v_add_u32_e32 v5, 0x180, v5
		s_lshl_b32 s3, s15, 1
		v_mul_lo_u32 v15, s3, v15
		v_add_u32_e32 v26, v5, v15
		v_mul_lo_u32 v1, s3, v1
		v_add_u32_e32 v15, v5, v1
		s_mul_i32 s3, 0x180, s17
		s_cmp_lt_i32 0, s2
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
		s_mov_b32 s4, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[48:51], v[116:119]
		s_cmp_ge_u32 s4, 2
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[48:51], v[124:127]
		s_cselect_b32 s5, 1, 0
		s_add_i32 s12, s4, -2
		v_mfma_f32_16x16x32_f16 v[140:143], v[104:107], v[56:59], v[140:143]
		s_add_i32 s13, s4, 1
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[56:59], v[128:131]
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s5, s12, s13
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[56:59], v[136:139]
		s_add_i32 s12, s16, 3
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[72:75], v[168:171]
		s_mul_i32 s12, s12, 64
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
		s_setprio 1
		s_barrier
		s_xor_b32 s12, s12, -1
		s_add_i32 s12, s12, 1
		s_add_i32 s12, s14, s12
		v_cmp_lt_i32_e64 vcc, v18, s12
		v_cmp_lt_i32_e64 s[20:21], v21, s12
		s_lshl_b32 s13, s16, 7
		v_cmp_lt_i32_e64 s[22:23], v10, s12
		s_mul_i32 s15, 0x4200, s4
		v_cndmask_b32_e32 v1, v41, v26, vcc
		v_cmp_lt_i32_e64 s[24:25], v44, s12
		s_add_i32 s15, s40, s15
		v_cndmask_b32_e32 v5, v41, v15, vcc
		s_mov_b32 m0, s15
		v_cmp_lt_i32_e64 vcc, v6, s12
		buffer_load_dwordx4 v1, s[36:39], s13 offen lds
		s_mul_i32 s4, 0x8400, s4
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s4, s40, s4
		buffer_load_dwordx4 v5, s[36:39], s13 offen lds
		s_mul_i32 s12, s17, s16
		s_lshl_b32 s12, s12, 7
		s_add_i32 s12, s3, s12
		v_add_u32_e32 v1, s12, v46
		v_cndmask_b32_e64 v1, v41, v1, s[22:23]
		v_add_u32_e32 v5, s12, v43
		v_cndmask_b32_e64 v5, v41, v5, s[20:21]
		s_add_i32 m0, s4, 0xc5e0
		s_mul_i32 s4, 0x8400, s5
		buffer_load_dwordx4 v1, s[44:47], 0 offen lds
		s_mul_i32 s13, 0x4200, s5
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s15, s4, 0x10000
		v_add_u32_e32 v1, s4, v16
		v_add_u32_e32 v27, s15, v16
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		v_add_u32_e32 v5, s12, v9
		v_cndmask_b32_e64 v5, v41, v5, s[24:25]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v29, s12, v20
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v5, v41, v29, vcc
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v29, s13, v8
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(6)
		ds_read_b128 v[48:51], v29
		ds_read_b128 v[52:55], v29 offset:64
		ds_read_b128 v[56:59], v29 offset:256
		ds_read_b128 v[60:63], v29 offset:320
		ds_read_b128 v[64:67], v29 offset:512
		ds_read_b128 v[68:71], v29 offset:576
		ds_read_b128 v[72:75], v29 offset:768
		ds_read_b128 v[76:79], v29 offset:832
		ds_read_b64_tr_b16 v[80:81], v1 offset:50656
		ds_read_b64_tr_b16 v[82:83], v1 offset:59104
		ds_read_b64_tr_b16 v[84:85], v27 offset:2016
		ds_read_b64_tr_b16 v[86:87], v27 offset:10464
		ds_read_b64_tr_b16 v[88:89], v1 offset:50784
		ds_read_b64_tr_b16 v[90:91], v1 offset:59232
		ds_read_b64_tr_b16 v[92:93], v27 offset:2144
		ds_read_b64_tr_b16 v[94:95], v27 offset:10592
		ds_read_b64_tr_b16 v[96:97], v1 offset:50912
		ds_read_b64_tr_b16 v[98:99], v1 offset:59360
		ds_read_b64_tr_b16 v[100:101], v27 offset:2272
		ds_read_b64_tr_b16 v[102:103], v27 offset:10720
		ds_read_b64_tr_b16 v[104:105], v1 offset:51040
		ds_read_b64_tr_b16 v[106:107], v1 offset:59488
		ds_read_b64_tr_b16 v[108:109], v27 offset:2400
		ds_read_b64_tr_b16 v[110:111], v27 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s2
		s_mov_b32 s4, s5
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[48:49], s[42:43]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[48:49]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s38
		s_mov_b32 s15, s39
		buffer_load_dwordx4 v[176:179], v24, s[12:15], 0 offen
		v_mul_lo_u32 v1, s18, v4
		v_add_lshl_u32 v5, v17, v1, 1
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s38
		s_mov_b32 s7, s39
		buffer_load_ushort v6, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v34, v1, 1
		buffer_load_ushort v9, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v36, v1, 1
		buffer_load_ushort v10, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v37, v1, 1
		buffer_load_ushort v15, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v38, v1, 1
		buffer_load_ushort v18, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v39, v1, 1
		buffer_load_ushort v20, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v5, v40, v1, 1
		buffer_load_ushort v21, v5, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v5, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v19
		v_add_lshl_u32 v24, v17, v1, 1
		buffer_load_ushort v26, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v34, v1, 1
		buffer_load_ushort v27, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v36, v1, 1
		buffer_load_ushort v29, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v37, v1, 1
		buffer_load_ushort v30, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v38, v1, 1
		buffer_load_ushort v31, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v39, v1, 1
		buffer_load_ushort v32, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v24, v40, v1, 1
		buffer_load_ushort v33, v24, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v24, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v22
		v_add_lshl_u32 v35, v17, v1, 1
		buffer_load_ushort v41, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v34, v1, 1
		buffer_load_ushort v42, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v36, v1, 1
		buffer_load_ushort v43, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v37, v1, 1
		buffer_load_ushort v44, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v38, v1, 1
		buffer_load_ushort v45, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v39, v1, 1
		buffer_load_ushort v46, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v35, v40, v1, 1
		buffer_load_ushort v180, v35, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v35, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v23
		v_add_lshl_u32 v181, v17, v1, 1
		buffer_load_ushort v182, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v34, v1, 1
		buffer_load_ushort v183, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v36, v1, 1
		buffer_load_ushort v184, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v37, v1, 1
		buffer_load_ushort v185, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v38, v1, 1
		buffer_load_ushort v186, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v39, v1, 1
		buffer_load_ushort v187, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v40, v1, 1
		buffer_load_ushort v188, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v181, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v11
		v_add_lshl_u32 v189, v17, v1, 1
		buffer_load_ushort v190, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v34, v1, 1
		buffer_load_ushort v191, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v36, v1, 1
		buffer_load_ushort v192, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v37, v1, 1
		buffer_load_ushort v193, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v38, v1, 1
		buffer_load_ushort v194, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v39, v1, 1
		buffer_load_ushort v195, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v40, v1, 1
		buffer_load_ushort v196, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v189, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v12
		v_add_lshl_u32 v197, v17, v1, 1
		buffer_load_ushort v198, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v34, v1, 1
		buffer_load_ushort v199, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v36, v1, 1
		buffer_load_ushort v200, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v37, v1, 1
		buffer_load_ushort v201, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v38, v1, 1
		buffer_load_ushort v202, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v39, v1, 1
		buffer_load_ushort v203, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v40, v1, 1
		buffer_load_ushort v204, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v197, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v13
		v_add_lshl_u32 v205, v17, v1, 1
		buffer_load_ushort v206, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v34, v1, 1
		buffer_load_ushort v207, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v36, v1, 1
		buffer_load_ushort v208, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v37, v1, 1
		buffer_load_ushort v209, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v38, v1, 1
		buffer_load_ushort v210, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v39, v1, 1
		buffer_load_ushort v211, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v40, v1, 1
		buffer_load_ushort v212, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v205, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v14
		v_add_lshl_u32 v213, v17, v1, 1
		buffer_load_ushort v214, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v34, v1, 1
		buffer_load_ushort v215, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v36, v1, 1
		buffer_load_ushort v216, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v37, v1, 1
		buffer_load_ushort v217, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v38, v1, 1
		buffer_load_ushort v218, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v39, v1, 1
		buffer_load_ushort v219, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v40, v1, 1
		buffer_load_ushort v220, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v213, v1, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[48:51], v[124:127]
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
		ds_read_b128 v[48:51], v1
		ds_read_b128 v[52:55], v1 offset:64
		ds_read_b128 v[56:59], v1 offset:256
		ds_read_b128 v[60:63], v1 offset:320
		ds_read_b128 v[64:67], v1 offset:512
		ds_read_b128 v[68:71], v1 offset:576
		ds_read_b128 v[72:75], v1 offset:768
		ds_read_b128 v[76:79], v1 offset:832
		s_mul_i32 s2, 0x8400, s2
		v_add_u32_e32 v1, s2, v16
		ds_read_b64_tr_b16 v[80:81], v1 offset:50656
		ds_read_b64_tr_b16 v[82:83], v1 offset:59104
		s_add_i32 s2, s2, 0x10000
		v_add_u32_e32 v84, s2, v16
		ds_read_b64_tr_b16 v[88:89], v84 offset:2016
		ds_read_b64_tr_b16 v[90:91], v84 offset:10464
		ds_read_b64_tr_b16 v[92:93], v1 offset:50784
		ds_read_b64_tr_b16 v[94:95], v1 offset:59232
		ds_read_b64_tr_b16 v[96:97], v84 offset:2144
		ds_read_b64_tr_b16 v[98:99], v84 offset:10592
		ds_read_b64_tr_b16 v[100:101], v1 offset:50912
		ds_read_b64_tr_b16 v[102:103], v1 offset:59360
		ds_read_b64_tr_b16 v[104:105], v84 offset:2272
		ds_read_b64_tr_b16 v[106:107], v84 offset:10720
		ds_read_b64_tr_b16 v[108:109], v1 offset:51040
		ds_read_b64_tr_b16 v[110:111], v1 offset:59488
		ds_read_b64_tr_b16 v[224:225], v84 offset:2400
		ds_read_b64_tr_b16 v[226:227], v84 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		s_add_i32 s0, s0, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s3, s0, -1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[48:51], v[116:119]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s0, s3, s0
		s_mul_hi_u32 s2, s0, 0xaaaaaaab
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[48:51], v[120:123]
		s_cselect_b32 s3, 1, 0
		s_lshr_b32 s2, s2, 1
		s_mul_i32 s2, s2, 3
		s_xor_b32 s2, s2, -1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[48:51], v[124:127]
		s_add_i32 s2, s2, 1
		s_add_i32 s0, s0, s2
		s_xor_b32 s2, s0, -1
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[56:59], v[140:143]
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s0, s2, s0
		s_mul_i32 s2, 0x4200, s0
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[56:59], v[128:131]
		v_add_u32_e32 v1, s2, v8
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
		ds_read_b128 v[48:51], v1
		ds_read_b128 v[52:55], v1 offset:64
		ds_read_b128 v[56:59], v1 offset:256
		ds_read_b128 v[60:63], v1 offset:320
		ds_read_b128 v[64:67], v1 offset:512
		ds_read_b128 v[68:71], v1 offset:576
		ds_read_b128 v[72:75], v1 offset:768
		ds_read_b128 v[76:79], v1 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v1, s0, v16
		ds_read_b64_tr_b16 v[80:81], v1 offset:50656
		ds_read_b64_tr_b16 v[82:83], v1 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v8, s0, v16
		ds_read_b64_tr_b16 v[84:85], v8 offset:2016
		ds_read_b64_tr_b16 v[86:87], v8 offset:10464
		ds_read_b64_tr_b16 v[88:89], v1 offset:50784
		ds_read_b64_tr_b16 v[90:91], v1 offset:59232
		ds_read_b64_tr_b16 v[92:93], v8 offset:2144
		ds_read_b64_tr_b16 v[94:95], v8 offset:10592
		ds_read_b64_tr_b16 v[96:97], v1 offset:50912
		ds_read_b64_tr_b16 v[98:99], v1 offset:59360
		ds_read_b64_tr_b16 v[100:101], v8 offset:2272
		ds_read_b64_tr_b16 v[102:103], v8 offset:10720
		ds_read_b64_tr_b16 v[104:105], v1 offset:51040
		ds_read_b64_tr_b16 v[106:107], v1 offset:59488
		ds_read_b64_tr_b16 v[108:109], v8 offset:2400
		ds_read_b64_tr_b16 v[110:111], v8 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[48:51], v[112:115]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[48:51], v[116:119]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[48:51], v[120:123]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[48:51], v[124:127]
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
		v_lshlrev_b32_e32 v1, 1, v3
		v_lshlrev_b32_e32 v3, 2, v47
		v_lshlrev_b32_e32 v7, 3, v7
		v_xor_b32_e32 v3, v3, v7
		v_bitop3_b32 v0, v0, v1, v3 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v0
		ds_write_b128 v1, v[112:115]
		v_xor_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[116:119] offset:8192
		ds_write_b128 v1, v[120:123] offset:16384
		ds_write_b128 v0, v[124:127] offset:24576
		v_and_b32_e32 v3, 1, v25
		v_cvt_f32_f16_e32 v48, v6
		v_cvt_f32_f16_e32 v49, v9
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v6, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v7, 3, v28
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v8, 13, v7
		v_lshl_add_u32 v3, v3, 14, v8
		v_lshrrev_b32_e32 v8, 5, v28
		v_lshl_add_u32 v8, s1, 1, v8
		v_lshrrev_b32_e32 v9, 2, v28
		v_and_b32_e32 v9, 1, v9
		v_lshl_add_u32 v8, v9, 7, v8
		v_lshrrev_b32_e32 v10, 1, v28
		v_and_b32_e32 v10, 1, v10
		v_lshl_add_u32 v8, v10, 6, v8
		v_and_b32_e32 v16, 1, v28
		v_lshl_add_u32 v8, v16, 5, v8
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshlrev_b32_e32 v9, 3, v9
		v_bitop3_b32 v7, v10, v9, v7 bitop3:0x96
		v_bitop3_b32 v7, v8, v16, v7 bitop3:0x96
		v_lshl_add_u32 v3, v7, 4, v3
		ds_read_b128 v[52:55], v3
		ds_read_b128 v[56:59], v3 offset:256
		ds_read_b128 v[60:63], v3 offset:4096
		ds_read_b128 v[64:67], v3 offset:4352
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v7, v15
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v8, v18
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v9, v20
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v50, v21
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[128:131]
		ds_write_b128 v0, v[132:135] offset:8192
		ds_write_b128 v1, v[136:139] offset:16384
		ds_write_b128 v0, v[140:143] offset:24576
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v51, v5
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v20, v26
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v21, v27
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v26, v29
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v3
		ds_read_b128 v[72:75], v3 offset:256
		ds_read_b128 v[76:79], v3 offset:4096
		ds_read_b128 v[80:83], v3 offset:4352
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v27, v30
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v28, v31
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v29, v32
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v30, v33
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[144:147]
		ds_write_b128 v0, v[148:151] offset:8192
		ds_write_b128 v1, v[152:155] offset:16384
		ds_write_b128 v0, v[156:159] offset:24576
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v31, v24
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v24, v41
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v25, v42
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v32, v43
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v3
		ds_read_b128 v[88:91], v3 offset:256
		ds_read_b128 v[92:95], v3 offset:4096
		ds_read_b128 v[96:99], v3 offset:4352
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v33, v44
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v42, v45
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v43, v46
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v44, v180
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[160:163]
		ds_write_b128 v0, v[164:167] offset:8192
		ds_write_b128 v1, v[168:171] offset:16384
		ds_write_b128 v0, v[172:175] offset:24576
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v45, v35
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v0, v182
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v1, v183
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v46, v184
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[100:103], v3
		ds_read_b128 v[104:107], v3 offset:256
		ds_read_b128 v[108:111], v3 offset:4096
		ds_read_b128 v[112:115], v3 offset:4352
		v_cvt_f32_f16_e32 v116, v176
		v_cvt_f32_f16_sdwa v117, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v118, v177
		v_cvt_f32_f16_sdwa v119, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v120, v178
		v_cvt_f32_f16_sdwa v121, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v122, v179
		v_cvt_f32_f16_sdwa v123, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v47, v185
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
		v_pk_add_f32 v[52:53], v[52:53], v[116:117]
		v_pk_fma_f32 v[160:161], v[52:53], v[48:49], v[52:53]
		v_cvt_pk_f16_f32 v3, v160, v161
		v_pk_add_f32 v[48:49], v[54:55], v[118:119]
		v_pk_fma_f32 v[52:53], v[48:49], v[6:7], v[48:49]
		v_cvt_pk_f16_f32 v5, v52, v53
		v_pk_add_f32 v[6:7], v[56:57], v[120:121]
		v_pk_fma_f32 v[48:49], v[6:7], v[8:9], v[6:7]
		v_cvt_pk_f16_f32 v6, v48, v49
		v_pk_add_f32 v[8:9], v[58:59], v[122:123]
		v_pk_fma_f32 v[48:49], v[8:9], v[50:51], v[8:9]
		v_cvt_pk_f16_f32 v7, v48, v49
		v_pk_add_f32 v[8:9], v[60:61], v[116:117]
		v_pk_fma_f32 v[48:49], v[8:9], v[20:21], v[8:9]
		v_cvt_pk_f16_f32 v8, v48, v49
		v_pk_add_f32 v[20:21], v[62:63], v[118:119]
		v_pk_fma_f32 v[48:49], v[20:21], v[26:27], v[20:21]
		v_cvt_pk_f16_f32 v9, v48, v49
		v_pk_add_f32 v[20:21], v[64:65], v[120:121]
		v_pk_fma_f32 v[26:27], v[20:21], v[28:29], v[20:21]
		v_cvt_pk_f16_f32 v10, v26, v27
		v_pk_add_f32 v[20:21], v[66:67], v[122:123]
		v_pk_fma_f32 v[26:27], v[20:21], v[30:31], v[20:21]
		v_cvt_pk_f16_f32 v15, v26, v27
		v_pk_add_f32 v[20:21], v[68:69], v[116:117]
		v_pk_fma_f32 v[26:27], v[20:21], v[24:25], v[20:21]
		v_cvt_pk_f16_f32 v16, v26, v27
		v_pk_add_f32 v[20:21], v[70:71], v[118:119]
		v_pk_fma_f32 v[24:25], v[20:21], v[32:33], v[20:21]
		v_cvt_pk_f16_f32 v18, v24, v25
		v_pk_add_f32 v[20:21], v[72:73], v[120:121]
		v_pk_fma_f32 v[24:25], v[20:21], v[42:43], v[20:21]
		v_cvt_pk_f16_f32 v20, v24, v25
		v_pk_add_f32 v[24:25], v[74:75], v[122:123]
		v_pk_fma_f32 v[26:27], v[24:25], v[44:45], v[24:25]
		v_cvt_pk_f16_f32 v21, v26, v27
		v_pk_add_f32 v[24:25], v[76:77], v[116:117]
		v_pk_fma_f32 v[26:27], v[24:25], v[0:1], v[24:25]
		v_cvt_pk_f16_f32 v0, v26, v27
		v_pk_add_f32 v[24:25], v[78:79], v[118:119]
		v_pk_fma_f32 v[26:27], v[24:25], v[46:47], v[24:25]
		v_cvt_pk_f16_f32 v1, v26, v27
		v_pk_add_f32 v[24:25], v[80:81], v[120:121]
		v_pk_fma_f32 v[26:27], v[24:25], v[124:125], v[24:25]
		v_cvt_pk_f16_f32 v24, v26, v27
		v_pk_add_f32 v[26:27], v[82:83], v[122:123]
		v_pk_fma_f32 v[28:29], v[26:27], v[126:127], v[26:27]
		v_cvt_pk_f16_f32 v25, v28, v29
		v_pk_add_f32 v[26:27], v[84:85], v[116:117]
		v_pk_fma_f32 v[28:29], v[26:27], v[128:129], v[26:27]
		v_cvt_pk_f16_f32 v26, v28, v29
		v_pk_add_f32 v[28:29], v[86:87], v[118:119]
		v_pk_fma_f32 v[30:31], v[28:29], v[130:131], v[28:29]
		v_cvt_pk_f16_f32 v27, v30, v31
		v_pk_add_f32 v[28:29], v[88:89], v[120:121]
		v_pk_fma_f32 v[30:31], v[28:29], v[132:133], v[28:29]
		v_cvt_pk_f16_f32 v28, v30, v31
		v_pk_add_f32 v[30:31], v[90:91], v[122:123]
		v_pk_fma_f32 v[32:33], v[30:31], v[134:135], v[30:31]
		v_cvt_pk_f16_f32 v29, v32, v33
		v_pk_add_f32 v[30:31], v[92:93], v[116:117]
		v_pk_fma_f32 v[32:33], v[30:31], v[136:137], v[30:31]
		v_cvt_pk_f16_f32 v30, v32, v33
		v_pk_add_f32 v[32:33], v[94:95], v[118:119]
		v_pk_fma_f32 v[42:43], v[32:33], v[138:139], v[32:33]
		v_cvt_pk_f16_f32 v31, v42, v43
		v_pk_add_f32 v[32:33], v[96:97], v[120:121]
		v_pk_fma_f32 v[42:43], v[32:33], v[140:141], v[32:33]
		v_cvt_pk_f16_f32 v32, v42, v43
		v_pk_add_f32 v[42:43], v[98:99], v[122:123]
		v_pk_fma_f32 v[44:45], v[42:43], v[142:143], v[42:43]
		v_cvt_pk_f16_f32 v33, v44, v45
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[42:43], v[100:101], v[116:117]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[44:45], v[108:109], v[116:117]
		v_pk_fma_f32 v[46:47], v[42:43], v[144:145], v[42:43]
		v_pk_fma_f32 v[42:43], v[44:45], v[152:153], v[44:45]
		v_cvt_pk_f16_f32 v35, v46, v47
		v_cvt_pk_f16_f32 v41, v42, v43
		v_pk_add_f32 v[42:43], v[102:103], v[118:119]
		v_pk_add_f32 v[44:45], v[110:111], v[118:119]
		v_pk_fma_f32 v[46:47], v[42:43], v[146:147], v[42:43]
		v_pk_fma_f32 v[42:43], v[44:45], v[154:155], v[44:45]
		v_cvt_pk_f16_f32 v44, v46, v47
		v_cvt_pk_f16_f32 v42, v42, v43
		v_pk_add_f32 v[46:47], v[104:105], v[120:121]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[48:49], v[112:113], v[120:121]
		v_pk_fma_f32 v[50:51], v[46:47], v[148:149], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[156:157], v[48:49]
		v_cvt_pk_f16_f32 v43, v50, v51
		v_cvt_pk_f16_f32 v45, v46, v47
		v_pk_add_f32 v[46:47], v[106:107], v[122:123]
		v_pk_add_f32 v[48:49], v[114:115], v[122:123]
		v_pk_fma_f32 v[50:51], v[46:47], v[150:151], v[46:47]
		v_pk_fma_f32 v[46:47], v[48:49], v[158:159], v[48:49]
		v_cvt_pk_f16_f32 v48, v50, v51
		v_cvt_pk_f16_f32 v46, v46, v47
		v_and_b32_e32 v47, 0xffff, v3
		v_mul_lo_u32 v4, s19, v4
		v_add_lshl_u32 v49, v17, v4, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s38
		s_mov_b32 s3, s39
		buffer_store_short v47, v49, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v47, v34, v4, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v5
		v_add_lshl_u32 v47, v36, v4, 1
		buffer_store_short v3, v47, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v5
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v6
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v6
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v39, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v7
		v_add_lshl_u32 v5, v40, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v7
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v8
		v_mul_lo_u32 v4, s19, v19
		v_add_lshl_u32 v5, v17, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v8
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v9
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v9
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v10
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v10
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v39, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v15
		v_add_lshl_u32 v5, v40, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v15
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v16
		v_mul_lo_u32 v4, s19, v22
		v_add_lshl_u32 v5, v17, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v16
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v34, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v18
		v_add_lshl_u32 v5, v36, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v18
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v37, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v20
		v_add_lshl_u32 v5, v38, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v20
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v39, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v21
		v_add_lshl_u32 v5, v40, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v21
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v0
		v_mul_lo_u32 v4, s19, v23
		v_add_lshl_u32 v5, v17, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v0
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v34, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v1
		v_add_lshl_u32 v3, v36, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v1
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v37, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v24
		v_add_lshl_u32 v1, v38, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v24
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v39, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v25
		v_add_lshl_u32 v1, v40, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v25
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v26
		v_mul_lo_u32 v1, s19, v11
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v26
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v34, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v27
		v_add_lshl_u32 v3, v36, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v27
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v37, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v28
		v_add_lshl_u32 v3, v38, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v28
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v39, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v29
		v_add_lshl_u32 v3, v40, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v29
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v30
		v_mul_lo_u32 v1, s19, v12
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v30
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v34, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v31
		v_add_lshl_u32 v3, v36, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v31
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v37, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v32
		v_add_lshl_u32 v3, v38, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v32
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v39, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v33
		v_add_lshl_u32 v3, v40, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v33
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v35
		v_mul_lo_u32 v1, s19, v13
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v35
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v34, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v44
		v_add_lshl_u32 v3, v36, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v44
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v37, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v43
		v_add_lshl_u32 v3, v38, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v43
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v39, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v48
		v_add_lshl_u32 v3, v40, v1, 1
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
		v_add_lshl_u32 v3, v34, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v42
		v_add_lshl_u32 v3, v36, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v42
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v37, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v45
		v_add_lshl_u32 v3, v38, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v1, 16, v45
		v_and_b32_e32 v1, 0xffff, v1
		v_add_lshl_u32 v3, v39, v0, 1
		buffer_store_short v1, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v1, 0xffff, v46
		v_add_lshl_u32 v3, v40, v0, 1
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
		.amdhsa_next_free_sgpr 50
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
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 50
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
    .sgpr_count:     50
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
