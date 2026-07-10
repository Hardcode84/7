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
		v_mov_b32_e32 v4, 0
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
		s_and_b32 s21, s16, 7
		s_lshr_b32 s16, s16, 3
		s_lshr_b32 s22, s16, 2
		s_mul_i32 s22, s22, 32
		s_mul_i32 s21, s21, 4
		s_add_i32 s21, s22, s21
		s_and_b32 s16, s16, 3
		s_add_i32 s20, s21, s16
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
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v5, 1, v8
		v_mov_b32_e32 v6, 32
		v_mul_lo_u32 v6, v6, v5
		v_mad_u32_u24 v3, v3, 16, v6
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v6, 1, v5
		v_mad_u32_u24 v3, v6, 64, v3
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v9, 1, v7
		v_lshrrev_b32_e32 v10, 7, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v11
		v_add3_u32 v3, v3, v9, v12
		v_lshrrev_b32_e32 v11, 8, v0
		v_and_b32_e32 v13, 1, v11
		v_mad_u32_u24 v3, v13, 4, v3
		v_and_b32_e32 v14, 15, v5
		v_add_u32_e32 v15, 0x50, v14
		v_add_u32_e32 v16, 0x60, v14
		v_add_u32_e32 v17, 0x70, v14
		v_add_u32_e32 v18, s1, v3
		s_mov_b32 s16, 0
		v_cmp_lt_i32_e64 vcc, v18, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v19, v18, -1, 1
		v_add3_u32 v3, 8, v3, s1
		v_cndmask_b32_e32 v18, v18, v19, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		s_add_i32 s28, s28, 1
		v_mov_b32_e32 v19, s12
		v_mov_b32_e32 v20, s28
		v_cndmask_b32_e64 v19, v19, v20, s[26:27]
		v_cvt_f32_u32_e32 v20, v19
		v_rcp_iflag_f32_e32 v20, v20
		v_xad_u32 v21, v19, -1, 1
		v_mul_f32_e32 v20, v2, v20
		v_cvt_u32_f32_e32 v20, v20
		v_mul_lo_u32 v22, v21, v20
		v_mul_hi_u32 v22, v20, v22
		v_add_u32_e32 v20, v20, v22
		v_mul_hi_u32 v22, v18, v20
		v_mul_lo_u32 v22, v22, v19
		v_xor_b32_e32 v22, -1, v22
		v_add3_u32 v18, 1, v22, v18
		v_add_u32_e32 v22, v18, v21
		v_cmp_ge_u32_e64 vcc, v18, v19
		v_add_u32_e32 v23, s1, v14
		v_add3_u32 v24, 16, v14, s1
		v_cndmask_b32_e32 v18, v18, v22, vcc
		v_add_u32_e32 v22, v18, v21
		v_cmp_ge_u32_e64 vcc, v18, v19
		v_add3_u32 v25, 32, v14, s1
		v_add3_u32 v26, 48, v14, s1
		v_cndmask_b32_e32 v18, v18, v22, vcc
		v_xad_u32 v22, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v3, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v27, v3, -1, 1
		v_add3_u32 v14, 64, v14, s1
		v_cndmask_b32_e32 v3, v3, v27, vcc
		v_mul_hi_u32 v27, v3, v20
		v_mul_lo_u32 v27, v27, v19
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v3, 1, v27, v3
		v_add_u32_e32 v27, v3, v21
		v_cmp_ge_u32_e64 vcc, v3, v19
		v_add_u32_e32 v15, s1, v15
		v_add_u32_e32 v16, s1, v16
		v_cndmask_b32_e32 v3, v3, v27, vcc
		v_add_u32_e32 v27, v3, v21
		v_cmp_ge_u32_e64 vcc, v3, v19
		v_add_u32_e32 v17, s1, v17
		v_cndmask_b32_e64 v18, v18, v22, s[20:21]
		v_cndmask_b32_e32 v3, v3, v27, vcc
		v_xad_u32 v22, v3, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v27, v23, -1, 1
		v_cndmask_b32_e64 v3, v3, v22, s[26:27]
		v_cndmask_b32_e32 v22, v23, v27, vcc
		v_mul_hi_u32 v23, v22, v20
		v_mul_lo_u32 v23, v23, v19
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v22, 1, v23, v22
		v_cmp_ge_u32_e64 vcc, v22, v19
		v_add_u32_e32 v23, v22, v21
		s_waitcnt lgkmcnt(0)
		s_lshl_b32 s1, s17, 8
		v_cndmask_b32_e32 v22, v22, v23, vcc
		v_cmp_ge_u32_e64 vcc, v22, v19
		v_add_u32_e32 v23, v22, v21
		s_mul_i32 s12, 0xc0, s17
		v_cndmask_b32_e32 v22, v22, v23, vcc
		v_xad_u32 v23, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v27, v24, -1, 1
		v_cndmask_b32_e64 v22, v22, v23, s[20:21]
		v_cndmask_b32_e32 v23, v24, v27, vcc
		v_mul_hi_u32 v24, v23, v20
		v_mul_lo_u32 v24, v24, v19
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v23, 1, v24, v23
		v_cmp_ge_u32_e64 vcc, v23, v19
		v_add_u32_e32 v24, v23, v21
		s_lshl_b32 s20, s17, 7
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_cmp_ge_u32_e64 vcc, v23, v19
		v_add_u32_e32 v24, v23, v21
		s_lshl_b32 s21, s17, 6
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_xad_u32 v24, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v27, v25, -1, 1
		v_cndmask_b32_e64 v23, v23, v24, s[26:27]
		v_cndmask_b32_e32 v24, v25, v27, vcc
		v_mul_hi_u32 v25, v24, v20
		v_mul_lo_u32 v25, v25, v19
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v24, 1, v25, v24
		v_cmp_ge_u32_e64 vcc, v24, v19
		v_add_u32_e32 v25, v24, v21
		s_lshl_b32 s26, s17, 3
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_cmp_ge_u32_e64 vcc, v24, v19
		v_add_u32_e32 v25, v24, v21
		v_and_b32_e32 v27, 1, v5
		v_cndmask_b32_e32 v5, v24, v25, vcc
		v_xad_u32 v24, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v26, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v25, v26, -1, 1
		v_cndmask_b32_e64 v24, v5, v24, s[28:29]
		v_cndmask_b32_e32 v5, v26, v25, vcc
		v_mul_hi_u32 v25, v5, v20
		v_mul_lo_u32 v25, v25, v19
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v5, 1, v25, v5
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v25, v5, v21
		v_and_b32_e32 v26, 1, v7
		v_cndmask_b32_e32 v5, v5, v25, vcc
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v25, v5, v21
		v_and_b32_e32 v10, 1, v10
		v_cndmask_b32_e32 v5, v5, v25, vcc
		v_xad_u32 v25, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v28, v14, -1, 1
		v_cndmask_b32_e64 v25, v5, v25, s[30:31]
		v_cndmask_b32_e32 v5, v14, v28, vcc
		v_mul_hi_u32 v14, v5, v20
		v_mul_lo_u32 v14, v14, v19
		v_xor_b32_e32 v14, -1, v14
		v_add3_u32 v5, 1, v14, v5
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v14, v5, v21
		v_mul_lo_u32 v28, s17, v11
		v_cndmask_b32_e32 v5, v5, v14, vcc
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v14, v5, v21
		v_mul_lo_u32 v29, s15, v3
		v_cndmask_b32_e32 v5, v5, v14, vcc
		v_xad_u32 v14, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v30, v15, -1, 1
		v_cndmask_b32_e64 v14, v5, v14, s[28:29]
		v_cndmask_b32_e32 v5, v15, v30, vcc
		v_mul_hi_u32 v15, v5, v20
		v_mul_lo_u32 v15, v15, v19
		v_xor_b32_e32 v15, -1, v15
		v_add3_u32 v5, 1, v15, v5
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v15, v5, v21
		v_lshrrev_b32_e32 v30, 1, v0
		v_cndmask_b32_e32 v5, v5, v15, vcc
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v15, v5, v21
		v_mov_b32_e32 v31, s13
		v_cndmask_b32_e32 v5, v5, v15, vcc
		v_xad_u32 v15, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v32, v16, -1, 1
		v_cndmask_b32_e64 v15, v5, v15, s[30:31]
		v_cndmask_b32_e32 v5, v16, v32, vcc
		v_mul_hi_u32 v16, v5, v20
		v_mul_lo_u32 v16, v16, v19
		v_xor_b32_e32 v16, -1, v16
		v_add3_u32 v5, 1, v16, v5
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v16, v5, v21
		s_xor_b32 s27, s13, -1
		v_cndmask_b32_e32 v5, v5, v16, vcc
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v16, v5, v21
		v_and_b32_e32 v32, 15, v8
		v_cndmask_b32_e32 v5, v5, v16, vcc
		v_xad_u32 v16, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v33, v17, -1, 1
		v_cndmask_b32_e64 v16, v5, v16, s[28:29]
		v_cndmask_b32_e32 v5, v17, v33, vcc
		v_mul_hi_u32 v17, v5, v20
		v_mul_lo_u32 v17, v17, v19
		v_xor_b32_e32 v17, -1, v17
		v_add3_u32 v5, 1, v17, v5
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v17, v5, v21
		v_and_b32_e32 v20, 31, v0
		v_cndmask_b32_e32 v5, v5, v17, vcc
		v_cmp_ge_u32_e64 vcc, v5, v19
		v_add_u32_e32 v17, v5, v21
		s_mul_i32 s0, s0, 0x100
		v_cndmask_b32_e32 v5, v5, v17, vcc
		v_xad_u32 v17, v5, -1, 1
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v32
		v_add_u32_e32 v21, 0x80, v19
		v_add_u32_e32 v32, 0xc0, v19
		v_mad_u32_u24 v20, v20, 8, s0
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v33, v20, -1, 1
		v_cndmask_b32_e64 v17, v5, v17, s[30:31]
		v_cndmask_b32_e32 v5, v20, v33, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s30, s22, s24
		s_cselect_b32 s31, s23, s25
		s_add_i32 s13, s27, 1
		v_mov_b32_e32 v20, s13
		v_cndmask_b32_e64 v20, v31, v20, s[30:31]
		v_cvt_f32_u32_e32 v31, v20
		v_rcp_iflag_f32_e32 v31, v31
		v_xad_u32 v33, v20, -1, 1
		v_mul_f32_e32 v2, v2, v31
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v31, v33, v2
		v_mul_hi_u32 v31, v2, v31
		v_add_u32_e32 v2, v2, v31
		v_mul_hi_u32 v31, v5, v2
		v_mul_lo_u32 v31, v31, v20
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v5, 1, v31, v5
		v_add_u32_e32 v31, v5, v33
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v34, s0, v19
		v_add3_u32 v19, 64, v19, s0
		v_cndmask_b32_e32 v5, v5, v31, vcc
		v_add_u32_e32 v31, v5, v33
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v21, s0, v21
		v_add_u32_e32 v32, s0, v32
		v_cndmask_b32_e32 v5, v5, v31, vcc
		v_xad_u32 v31, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v35, v34, -1, 1
		v_cndmask_b32_e64 v31, v5, v31, s[28:29]
		v_cndmask_b32_e32 v5, v34, v35, vcc
		v_mul_hi_u32 v34, v5, v2
		v_mul_lo_u32 v34, v34, v20
		v_xor_b32_e32 v34, -1, v34
		v_add3_u32 v5, 1, v34, v5
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v34, v5, v33
		v_lshrrev_b32_e32 v35, 2, v0
		v_cndmask_b32_e32 v5, v5, v34, vcc
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v34, v5, v33
		v_and_b32_e32 v36, 1, v0
		v_cndmask_b32_e32 v5, v5, v34, vcc
		v_xad_u32 v34, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v37, v19, -1, 1
		v_cndmask_b32_e64 v34, v5, v34, s[22:23]
		v_cndmask_b32_e32 v5, v19, v37, vcc
		v_mul_hi_u32 v19, v5, v2
		v_mul_lo_u32 v19, v19, v20
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v5, 1, v19, v5
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v19, v5, v33
		v_mul_lo_u32 v37, s15, v18
		v_cndmask_b32_e32 v5, v5, v19, vcc
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v19, v5, v33
		s_mov_b32 s30, 0x7fffffff
		v_cndmask_b32_e32 v5, v5, v19, vcc
		v_xad_u32 v19, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v38, v21, -1, 1
		v_cndmask_b32_e64 v19, v5, v19, s[24:25]
		v_cndmask_b32_e32 v5, v21, v38, vcc
		v_mul_hi_u32 v21, v5, v2
		v_mul_lo_u32 v21, v21, v20
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v5, 1, v21, v5
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v21, v5, v33
		v_mov_b32_e32 v38, 16
		v_mul_lo_u32 v38, v38, v6
		v_cndmask_b32_e32 v5, v5, v21, vcc
		v_cmp_ge_u32_e64 vcc, v5, v20
		v_add_u32_e32 v6, v5, v33
		v_and_b32_e32 v21, 7, v0
		v_cndmask_b32_e32 v5, v5, v6, vcc
		v_xad_u32 v6, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v32, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v39, v32, -1, 1
		v_cndmask_b32_e64 v40, v5, v6, s[22:23]
		v_cndmask_b32_e32 v5, v32, v39, vcc
		v_mul_hi_u32 v2, v5, v2
		v_mul_lo_u32 v2, v2, v20
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v5
		v_cmp_ge_u32_e64 vcc, v2, v20
		v_add_u32_e32 v5, v2, v33
		s_mov_b32 s0, 63
		v_cndmask_b32_e32 v2, v2, v5, vcc
		v_cmp_ge_u32_e64 vcc, v2, v20
		v_add_u32_e32 v5, v2, v33
		s_add_i32 s13, s14, 63
		v_cndmask_b32_e32 v2, v2, v5, vcc
		v_xad_u32 v5, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v5, s[24:25]
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s0, s0, 0
		s_add_i32 s0, s13, s0
		s_ashr_i32 s0, s0, 6
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v21
		v_add3_u32 v5, v38, v9, v12
		v_mad_u32_u24 v9, v13, 8, v5
		v_add_u32_e32 v12, 4, v9
		v_add_u32_e32 v13, 32, v9
		v_add_u32_e32 v21, 36, v9
		v_cmp_lt_i32_e64 vcc, v20, s14
		s_mov_b64 s[22:23], vcc
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_readfirstlane_b32 s2, v0
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s2, 0x420, s2
		v_lshlrev_b32_e32 v5, 4, v36
		v_lshl_add_u32 v6, v37, 1, v5
		v_and_b32_e32 v32, 1, v35
		v_lshl_add_u32 v6, v32, 6, v6
		v_and_b32_e32 v30, 1, v30
		v_lshl_add_u32 v6, v30, 5, v6
		s_mov_b32 m0, s2
		s_and_saveexec_b64 s[36:37], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[36:37]
		v_lshl_add_u32 v5, v29, 1, v5
		v_lshl_add_u32 v5, v32, 6, v5
		v_lshl_add_u32 v5, v30, 5, v5
		s_add_i32 m0, s2, 0x2100
		s_and_saveexec_b64 s[36:37], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[36:37]
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_lshlrev_b32_e32 v28, 4, v28
		v_lshl_add_u32 v28, v31, 1, v28
		v_mul_lo_u32 v29, s17, v10
		v_lshl_add_u32 v28, v29, 2, v28
		v_mul_lo_u32 v29, s17, v26
		v_lshl_add_u32 v28, v29, 1, v28
		v_mul_lo_u32 v29, s17, v27
		v_lshl_add_u32 v33, v29, 5, v28
		v_cmp_lt_i32_e64 vcc, v9, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0xc5e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_2
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_2:
		s_mov_b64 exec, s[36:37]
		v_lshlrev_b32_e32 v29, 5, v29
		v_add3_u32 v33, v28, v29, s26
		v_cmp_lt_i32_e64 vcc, v12, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0xe6e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_3
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_3:
		s_mov_b64 exec, s[36:37]
		v_add3_u32 v33, v28, v29, s21
		v_cmp_lt_i32_e64 vcc, v13, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x107e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_4
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_4:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s3, 0x48, s17
		v_add3_u32 v33, v28, v29, s3
		v_cmp_lt_i32_e64 vcc, v21, s14
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x128e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_5
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_5:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s3, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v20, s3
		s_mov_b64 s[4:5], vcc
		v_add_u32_e32 v33, 0x80, v6
		s_add_i32 m0, s2, 0x4200
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_6
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_6:
		s_mov_b64 exec, s[36:37]
		v_add_u32_e32 v33, 0x80, v5
		s_add_i32 m0, s2, 0x6300
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_7
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_7:
		s_mov_b64 exec, s[36:37]
		v_add3_u32 v33, v28, v29, s20
		v_cmp_lt_i32_e64 vcc, v9, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x149e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_8
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_8:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s4, 0x88, s17
		v_add3_u32 v33, v28, v29, s4
		v_cmp_lt_i32_e64 vcc, v12, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x16ae0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_9
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_9:
		s_mov_b64 exec, s[36:37]
		v_add3_u32 v33, v28, v29, s12
		v_cmp_lt_i32_e64 vcc, v13, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x18be0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_10
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_10:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s4, 0xc8, s17
		v_add3_u32 v33, v28, v29, s4
		v_cmp_lt_i32_e64 vcc, v21, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x1ace0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_11
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_11:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s3, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v20, s3
		s_mov_b64 s[4:5], vcc
		v_add_u32_e32 v6, 0x100, v6
		s_add_i32 m0, s2, 0x8400
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_12
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_12:
		s_mov_b64 exec, s[36:37]
		v_add_u32_e32 v5, 0x100, v5
		s_add_i32 m0, s2, 0xa500
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_13
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_13:
		s_mov_b64 exec, s[36:37]
		v_add3_u32 v5, v28, v29, s1
		v_cmp_lt_i32_e64 vcc, v9, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x1cde0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_14
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_14:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s1, 0x108, s17
		v_add3_u32 v5, v28, v29, s1
		v_cmp_lt_i32_e64 vcc, v12, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x1eee0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_15
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_15:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s1, 0x140, s17
		v_add3_u32 v5, v28, v29, s1
		v_cmp_lt_i32_e64 vcc, v13, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x20fe0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_16
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_16:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s1, 0x148, s17
		v_add3_u32 v5, v28, v29, s1
		v_cmp_lt_i32_e64 vcc, v21, s3
		s_mov_b64 s[4:5], vcc
		s_add_i32 m0, s2, 0x230e0
		s_and_saveexec_b64 s[36:37], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_17
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_17:
		s_mov_b64 exec, s[36:37]
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshlrev_b32_e32 v33, 7, v11
		v_and_b32_e32 v0, 63, v0
		v_lshrrev_b32_e32 v5, 4, v0
		v_lshlrev_b32_e32 v35, 4, v5
		v_and_b32_e32 v6, 15, v0
		v_mov_b32_e32 v37, 0x420
		v_mul_lo_u32 v37, v37, v6
		v_add3_u32 v38, v33, v35, v37
		ds_read_b128 v[44:47], v38
		ds_read_b128 v[48:51], v38 offset:64
		ds_read_b128 v[52:55], v38 offset:256
		ds_read_b128 v[56:59], v38 offset:320
		ds_read_b128 v[60:63], v38 offset:512
		ds_read_b128 v[64:67], v38 offset:576
		ds_read_b128 v[68:71], v38 offset:768
		ds_read_b128 v[72:75], v38 offset:832
		v_lshrrev_b32_e32 v0, 5, v0
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshrrev_b32_e32 v39, 2, v6
		v_mov_b32_e32 v41, 0x420
		v_mul_lo_u32 v41, v41, v39
		v_and_b32_e32 v7, 3, v7
		v_lshlrev_b32_e32 v39, 5, v7
		v_add3_u32 v7, v0, v41, v39
		v_and_b32_e32 v5, 1, v5
		v_mov_b32_e32 v42, 0x1080
		v_mul_lo_u32 v42, v42, v5
		v_and_b32_e32 v5, 3, v6
		v_lshlrev_b32_e32 v43, 3, v5
		v_add3_u32 v76, v7, v42, v43
		ds_read_b64_tr_b16 v[80:81], v76 offset:50656
		ds_read_b64_tr_b16 v[82:83], v76 offset:59104
		v_add_u32_e32 v5, 0x10000, v0
		v_add3_u32 v5, v5, v41, v39
		v_add3_u32 v5, v5, v42, v43
		ds_read_b64_tr_b16 v[84:85], v5 offset:2016
		ds_read_b64_tr_b16 v[86:87], v5 offset:10464
		ds_read_b64_tr_b16 v[88:89], v76 offset:50784
		ds_read_b64_tr_b16 v[90:91], v76 offset:59232
		ds_read_b64_tr_b16 v[92:93], v5 offset:2144
		ds_read_b64_tr_b16 v[94:95], v5 offset:10592
		ds_read_b64_tr_b16 v[96:97], v76 offset:50912
		ds_read_b64_tr_b16 v[98:99], v76 offset:59360
		ds_read_b64_tr_b16 v[100:101], v5 offset:2272
		ds_read_b64_tr_b16 v[102:103], v5 offset:10720
		ds_read_b64_tr_b16 v[104:105], v76 offset:51040
		ds_read_b64_tr_b16 v[106:107], v76 offset:59488
		ds_read_b64_tr_b16 v[108:109], v5 offset:2400
		ds_read_b64_tr_b16 v[110:111], v5 offset:10848
		s_add_i32 s1, s0, -3
		v_lshlrev_b32_e32 v5, 6, v32
		v_lshl_add_u32 v5, v36, 4, v5
		v_lshl_add_u32 v5, v30, 5, v5
		v_add_u32_e32 v5, 0x180, v5
		s_lshl_b32 s3, s15, 1
		v_mul_lo_u32 v6, s3, v18
		v_add_u32_e32 v18, v5, v6
		v_mul_lo_u32 v3, s3, v3
		v_add_u32_e32 v77, v5, v3
		s_mul_i32 s3, 0x180, s17
		s_mul_i32 s4, 0x188, s17
		s_mul_i32 s5, 0x1c0, s17
		s_mul_i32 s12, 0x1c8, s17
		s_cmp_lt_i32 0, s1
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		v_mov_b32_e32 v112, v4
		v_mov_b32_e32 v113, v5
		v_mov_b32_e32 v114, v6
		v_mov_b32_e32 v115, v7
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		s_lshl_b32 s13, s16, 7
		s_add_i32 s15, s16, 3
		s_mul_i32 s15, s15, 64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[48:51], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		s_xor_b32 s15, s15, -1
		s_add_i32 s15, s15, 1
		s_add_i32 s15, s14, s15
		v_cmp_lt_i32_e64 vcc, v20, s15
		s_mov_b64 s[20:21], vcc
		s_barrier
		s_mul_hi_u32 s22, s16, 0xaaaaaaab
		s_lshr_b32 s22, s22, 1
		s_mul_i32 s22, s22, 3
		s_xor_b32 s22, s22, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s16, s22
		s_mul_i32 s23, 0x4200, s22
		s_add_i32 m0, s2, s23
		s_and_saveexec_b64 s[36:37], s[20:21]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_18
		buffer_load_dwordx4 v18, s[28:31], s13 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_18:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s23, s2, s23
		s_add_i32 m0, s23, 0x2100
		s_and_saveexec_b64 s[36:37], s[20:21]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_19
		buffer_load_dwordx4 v77, s[28:31], s13 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_19:
		s_mov_b64 exec, s[36:37]
		s_mul_i32 s13, 0x8400, s22
		s_add_i32 s13, s2, s13
		s_mul_i32 s20, s17, s16
		s_lshl_b32 s20, s20, 7
		s_add_i32 s21, s3, s20
		v_add3_u32 v3, v28, v29, s21
		v_cmp_lt_i32_e64 vcc, v9, s15
		s_mov_b64 s[22:23], vcc
		s_add_i32 m0, s13, 0xc5e0
		s_and_saveexec_b64 s[36:37], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_20
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_20:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s21, s4, s20
		v_add3_u32 v3, v28, v29, s21
		v_cmp_lt_i32_e64 vcc, v12, s15
		s_mov_b64 s[22:23], vcc
		s_add_i32 m0, s13, 0xe6e0
		s_and_saveexec_b64 s[36:37], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_21
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_21:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s21, s5, s20
		v_add3_u32 v3, v28, v29, s21
		v_cmp_lt_i32_e64 vcc, v13, s15
		s_mov_b64 s[22:23], vcc
		s_add_i32 m0, s13, 0x107e0
		s_and_saveexec_b64 s[36:37], s[22:23]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_22
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_22:
		s_mov_b64 exec, s[36:37]
		s_add_i32 s20, s12, s20
		v_add3_u32 v3, v28, v29, s20
		v_cmp_lt_i32_e64 vcc, v21, s15
		s_mov_b64 s[20:21], vcc
		s_add_i32 m0, s13, 0x128e0
		s_and_saveexec_b64 s[36:37], s[20:21]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_23
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_23:
		s_mov_b64 exec, s[36:37]
		s_waitcnt vmcnt(6)
		s_barrier
		s_add_i32 s16, s16, 1
		s_mul_hi_u32 s13, s16, 0xaaaaaaab
		s_lshr_b32 s13, s13, 1
		s_mul_i32 s13, s13, 3
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s16, s13
		s_mul_i32 s15, 0x4200, s13
		v_add_u32_e32 v3, s15, v33
		v_add3_u32 v3, v3, v35, v37
		ds_read_b128 v[44:47], v3
		ds_read_b128 v[48:51], v3 offset:64
		ds_read_b128 v[52:55], v3 offset:256
		ds_read_b128 v[56:59], v3 offset:320
		ds_read_b128 v[60:63], v3 offset:512
		ds_read_b128 v[64:67], v3 offset:576
		ds_read_b128 v[68:71], v3 offset:768
		ds_read_b128 v[72:75], v3 offset:832
		s_mul_i32 s13, 0x8400, s13
		v_add_u32_e32 v3, s13, v0
		v_add3_u32 v3, v3, v41, v39
		v_add3_u32 v3, v3, v42, v43
		ds_read_b64_tr_b16 v[80:81], v3 offset:50656
		ds_read_b64_tr_b16 v[82:83], v3 offset:59104
		s_add_i32 s13, s13, 0x10000
		v_add_u32_e32 v78, s13, v0
		v_add3_u32 v78, v78, v41, v39
		v_add3_u32 v78, v78, v42, v43
		ds_read_b64_tr_b16 v[84:85], v78 offset:2016
		ds_read_b64_tr_b16 v[86:87], v78 offset:10464
		ds_read_b64_tr_b16 v[88:89], v3 offset:50784
		ds_read_b64_tr_b16 v[90:91], v3 offset:59232
		ds_read_b64_tr_b16 v[92:93], v78 offset:2144
		ds_read_b64_tr_b16 v[94:95], v78 offset:10592
		ds_read_b64_tr_b16 v[96:97], v3 offset:50912
		ds_read_b64_tr_b16 v[98:99], v3 offset:59360
		ds_read_b64_tr_b16 v[100:101], v78 offset:2272
		ds_read_b64_tr_b16 v[102:103], v78 offset:10720
		ds_read_b64_tr_b16 v[104:105], v3 offset:51040
		ds_read_b64_tr_b16 v[106:107], v3 offset:59488
		ds_read_b64_tr_b16 v[108:109], v78 offset:2400
		ds_read_b64_tr_b16 v[110:111], v78 offset:10848
		s_cmp_lt_i32 s16, s1
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[48:51], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		s_add_i32 s1, s0, -2
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s3, s1, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s1, s3, s1
		s_cselect_b32 s2, 1, 0
		s_and_b32 s3, s1, 0xffff
		s_lshr_b32 s4, s1, 16
		s_mul_i32 s5, s3, 0xaaab
		s_mul_i32 s3, s3, 0xaaaa
		s_mul_i32 s12, s4, 0xaaab
		s_mul_i32 s4, s4, 0xaaaa
		s_lshr_b32 s5, s5, 16
		s_and_b32 s13, s3, 0xffff
		s_and_b32 s14, s12, 0xffff
		s_add_i32 s5, s5, s13
		s_add_i32 s5, s5, s14
		s_lshr_b32 s3, s3, 16
		s_add_i32 s3, s4, s3
		s_lshr_b32 s4, s12, 16
		s_add_i32 s3, s3, s4
		s_lshr_b32 s4, s5, 16
		s_add_i32 s3, s3, s4
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s1, s1, s3
		s_xor_b32 s3, s1, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s1, s3, s1
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s2, 0x4200, s1
		v_add_u32_e32 v0, s2, v38
		ds_read_b128 v[44:47], v0
		ds_read_b128 v[48:51], v0 offset:64
		ds_read_b128 v[52:55], v0 offset:256
		ds_read_b128 v[56:59], v0 offset:320
		ds_read_b128 v[60:63], v0 offset:512
		ds_read_b128 v[64:67], v0 offset:576
		ds_read_b128 v[68:71], v0 offset:768
		ds_read_b128 v[72:75], v0 offset:832
		s_mul_i32 s1, 0x8400, s1
		v_add_u32_e32 v0, s1, v76
		ds_read_b64_tr_b16 v[80:81], v0 offset:50656
		ds_read_b64_tr_b16 v[82:83], v0 offset:59104
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v3, s1, v76
		ds_read_b64_tr_b16 v[84:85], v3 offset:2016
		ds_read_b64_tr_b16 v[86:87], v3 offset:10464
		ds_read_b64_tr_b16 v[88:89], v0 offset:50784
		ds_read_b64_tr_b16 v[90:91], v0 offset:59232
		ds_read_b64_tr_b16 v[92:93], v3 offset:2144
		ds_read_b64_tr_b16 v[94:95], v3 offset:10592
		ds_read_b64_tr_b16 v[96:97], v0 offset:50912
		ds_read_b64_tr_b16 v[98:99], v0 offset:59360
		ds_read_b64_tr_b16 v[100:101], v3 offset:2272
		ds_read_b64_tr_b16 v[102:103], v3 offset:10720
		ds_read_b64_tr_b16 v[104:105], v0 offset:51040
		ds_read_b64_tr_b16 v[106:107], v0 offset:59488
		ds_read_b64_tr_b16 v[108:109], v3 offset:2400
		ds_read_b64_tr_b16 v[110:111], v3 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[48:51], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		s_add_i32 s0, s0, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s2, s0, -1
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s2, s0
		s_cselect_b32 s1, 1, 0
		s_and_b32 s2, s0, 0xffff
		s_lshr_b32 s3, s0, 16
		s_mul_i32 s4, s2, 0xaaab
		s_mul_i32 s2, s2, 0xaaaa
		s_mul_i32 s5, s3, 0xaaab
		s_mul_i32 s3, s3, 0xaaaa
		s_lshr_b32 s4, s4, 16
		s_and_b32 s12, s2, 0xffff
		s_and_b32 s13, s5, 0xffff
		s_add_i32 s4, s4, s12
		s_add_i32 s4, s4, s13
		s_lshr_b32 s2, s2, 16
		s_add_i32 s2, s3, s2
		s_lshr_b32 s3, s5, 16
		s_add_i32 s2, s2, s3
		s_lshr_b32 s3, s4, 16
		s_add_i32 s2, s2, s3
		s_lshr_b32 s2, s2, 1
		s_mul_i32 s2, s2, 3
		s_xor_b32 s2, s2, -1
		s_add_i32 s2, s2, 1
		s_add_i32 s0, s0, s2
		s_xor_b32 s2, s0, -1
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s2, s0
		s_mul_i32 s1, 0x4200, s0
		v_add_u32_e32 v0, s1, v38
		ds_read_b128 v[44:47], v0
		ds_read_b128 v[48:51], v0 offset:64
		ds_read_b128 v[52:55], v0 offset:256
		ds_read_b128 v[56:59], v0 offset:320
		ds_read_b128 v[60:63], v0 offset:512
		ds_read_b128 v[64:67], v0 offset:576
		ds_read_b128 v[68:71], v0 offset:768
		ds_read_b128 v[72:75], v0 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v0, s0, v76
		ds_read_b64_tr_b16 v[80:81], v0 offset:50656
		ds_read_b64_tr_b16 v[82:83], v0 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v3, s0, v76
		ds_read_b64_tr_b16 v[76:77], v3 offset:2016
		ds_read_b64_tr_b16 v[78:79], v3 offset:10464
		ds_read_b64_tr_b16 v[84:85], v0 offset:50784
		ds_read_b64_tr_b16 v[86:87], v0 offset:59232
		ds_read_b64_tr_b16 v[88:89], v3 offset:2144
		ds_read_b64_tr_b16 v[90:91], v3 offset:10592
		ds_read_b64_tr_b16 v[92:93], v0 offset:50912
		ds_read_b64_tr_b16 v[94:95], v0 offset:59360
		ds_read_b64_tr_b16 v[96:97], v3 offset:2272
		ds_read_b64_tr_b16 v[98:99], v3 offset:10720
		ds_read_b64_tr_b16 v[100:101], v0 offset:51040
		ds_read_b64_tr_b16 v[102:103], v0 offset:59488
		ds_read_b64_tr_b16 v[104:105], v3 offset:2400
		ds_read_b64_tr_b16 v[106:107], v3 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[48:51], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[48:51], v[116:119]
		v_lshlrev_b32_e32 v0, 1, v34
		s_mov_b32 s0, s6
		s_mov_b32 s1, s7
		s_mov_b32 s2, s30
		s_mov_b32 s3, s31
		buffer_load_dwordx2 v[12:13], v0, s[0:3], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[56:59], v[136:139]
		v_lshlrev_b32_e32 v0, 1, v19
		buffer_load_dwordx2 v[18:19], v0, s[0:3], 0 offen
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[56:59], v[128:131]
		v_lshlrev_b32_e32 v0, 1, v40
		buffer_load_dwordx2 v[20:21], v0, s[0:3], 0 offen
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[64:67], v[148:151]
		v_lshlrev_b32_e32 v0, 1, v2
		buffer_load_dwordx2 v[2:3], v0, s[0:3], 0 offen
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[72:75], v[164:167]
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v40, v12
		v_cvt_f32_f16_sdwa v41, v12 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v13
		v_cvt_f32_f16_sdwa v43, v13 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v44, v18
		v_cvt_f32_f16_sdwa v45, v18 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v46, v19
		v_cvt_f32_f16_sdwa v47, v19 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v48, v20
		v_cvt_f32_f16_sdwa v49, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v50, v21
		v_cvt_f32_f16_sdwa v51, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v52, v2
		v_cvt_f32_f16_sdwa v53, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v54, v3
		v_cvt_f32_f16_sdwa v55, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_lshlrev_b32_e32 v0, 1, v31
		v_mul_lo_u32 v2, s18, v22
		v_lshl_add_u32 v2, v2, 1, v0
		s_mov_b32 s0, s8
		s_mov_b32 s1, s9
		s_mov_b32 s2, s30
		s_mov_b32 s3, s31
		buffer_load_dwordx4 v[56:59], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v23
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[60:63], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v24
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[64:67], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v25
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[68:71], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v14
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[72:75], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v15
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[76:79], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v16
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[80:83], v2, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v2, s18, v17
		v_lshl_add_u32 v2, v2, 1, v0
		buffer_load_dwordx4 v[84:87], v2, s[0:3], 0 offen sc0 nt
		s_barrier
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v2, v56
		v_cvt_f32_f16_sdwa v3, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v12, v57
		v_cvt_f32_f16_sdwa v13, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v18, v58
		v_cvt_f32_f16_sdwa v19, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v20, v59
		v_cvt_f32_f16_sdwa v21, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v28, v60
		v_cvt_f32_f16_sdwa v29, v60 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v34, v61
		v_cvt_f32_f16_sdwa v35, v61 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v38, v62
		v_cvt_f32_f16_sdwa v39, v62 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v56, v63
		v_cvt_f32_f16_sdwa v57, v63 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v58, v64
		v_cvt_f32_f16_sdwa v59, v64 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v60, v65
		v_cvt_f32_f16_sdwa v61, v65 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v62, v66
		v_cvt_f32_f16_sdwa v63, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v67
		v_cvt_f32_f16_sdwa v65, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v66, v68
		v_cvt_f32_f16_sdwa v67, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v69
		v_cvt_f32_f16_sdwa v89, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v70
		v_cvt_f32_f16_sdwa v69, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v71
		v_cvt_f32_f16_sdwa v91, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v70, v72
		v_cvt_f32_f16_sdwa v71, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v92, v73
		v_cvt_f32_f16_sdwa v93, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v74
		v_cvt_f32_f16_sdwa v73, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v75
		v_cvt_f32_f16_sdwa v95, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v74, v76
		v_cvt_f32_f16_sdwa v75, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v77
		v_cvt_f32_f16_sdwa v97, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v76, v78
		v_cvt_f32_f16_sdwa v77, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v79
		v_cvt_f32_f16_sdwa v99, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v78, v80
		v_cvt_f32_f16_sdwa v79, v80 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v100, v81
		v_cvt_f32_f16_sdwa v101, v81 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v80, v82
		v_cvt_f32_f16_sdwa v81, v82 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v83
		v_cvt_f32_f16_sdwa v103, v83 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v82, v84
		v_cvt_f32_f16_sdwa v83, v84 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v85
		v_cvt_f32_f16_sdwa v105, v85 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v84, v86
		v_cvt_f32_f16_sdwa v85, v86 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v106, v87
		v_cvt_f32_f16_sdwa v107, v87 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[86:87], v[40:41]
		v_mov_b64_e32 v[40:41], v[4:5]
		v_pk_add_f32 v[108:109], v[40:41], v[86:87]
		v_mov_b64_e32 v[4:5], v[42:43]
		v_mov_b64_e32 v[40:41], v[6:7]
		v_pk_add_f32 v[110:111], v[40:41], v[4:5]
		v_mov_b64_e32 v[6:7], v[44:45]
		v_mov_b64_e32 v[40:41], v[112:113]
		v_pk_add_f32 v[172:173], v[40:41], v[6:7]
		v_mov_b64_e32 v[40:41], v[46:47]
		v_mov_b64_e32 v[42:43], v[114:115]
		v_pk_add_f32 v[174:175], v[42:43], v[40:41]
		v_mov_b64_e32 v[42:43], v[48:49]
		v_mov_b64_e32 v[44:45], v[116:117]
		v_pk_add_f32 v[112:113], v[44:45], v[42:43]
		v_mov_b64_e32 v[44:45], v[50:51]
		v_mov_b64_e32 v[46:47], v[118:119]
		v_pk_add_f32 v[114:115], v[46:47], v[44:45]
		v_mov_b64_e32 v[46:47], v[52:53]
		v_mov_b64_e32 v[48:49], v[120:121]
		v_pk_add_f32 v[116:117], v[48:49], v[46:47]
		v_mov_b64_e32 v[48:49], v[54:55]
		v_mov_b64_e32 v[50:51], v[122:123]
		v_pk_add_f32 v[118:119], v[50:51], v[48:49]
		v_mov_b64_e32 v[50:51], v[124:125]
		v_pk_add_f32 v[52:53], v[50:51], v[86:87]
		v_mov_b64_e32 v[50:51], v[126:127]
		v_pk_add_f32 v[54:55], v[50:51], v[4:5]
		v_mov_b64_e32 v[50:51], v[128:129]
		v_pk_add_f32 v[120:121], v[50:51], v[6:7]
		v_mov_b64_e32 v[50:51], v[130:131]
		v_pk_add_f32 v[122:123], v[50:51], v[40:41]
		v_mov_b64_e32 v[50:51], v[132:133]
		v_pk_add_f32 v[124:125], v[50:51], v[42:43]
		v_mov_b64_e32 v[50:51], v[134:135]
		v_pk_add_f32 v[126:127], v[50:51], v[44:45]
		v_mov_b64_e32 v[50:51], v[136:137]
		v_pk_add_f32 v[128:129], v[50:51], v[46:47]
		v_mov_b64_e32 v[50:51], v[138:139]
		v_pk_add_f32 v[130:131], v[50:51], v[48:49]
		v_mov_b64_e32 v[50:51], v[140:141]
		v_pk_add_f32 v[132:133], v[50:51], v[86:87]
		v_mov_b64_e32 v[50:51], v[142:143]
		v_pk_add_f32 v[134:135], v[50:51], v[4:5]
		v_mov_b64_e32 v[50:51], v[144:145]
		v_pk_add_f32 v[136:137], v[50:51], v[6:7]
		v_mov_b64_e32 v[50:51], v[146:147]
		v_pk_add_f32 v[138:139], v[50:51], v[40:41]
		v_mov_b64_e32 v[50:51], v[148:149]
		v_pk_add_f32 v[140:141], v[50:51], v[42:43]
		v_mov_b64_e32 v[50:51], v[150:151]
		v_pk_add_f32 v[142:143], v[50:51], v[44:45]
		v_mov_b64_e32 v[50:51], v[152:153]
		v_pk_add_f32 v[144:145], v[50:51], v[46:47]
		v_mov_b64_e32 v[50:51], v[154:155]
		v_pk_add_f32 v[146:147], v[50:51], v[48:49]
		v_mov_b64_e32 v[50:51], v[156:157]
		v_pk_add_f32 v[148:149], v[50:51], v[86:87]
		v_mov_b64_e32 v[50:51], v[158:159]
		v_pk_add_f32 v[150:151], v[50:51], v[4:5]
		v_mov_b64_e32 v[4:5], v[160:161]
		v_pk_add_f32 v[152:153], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[162:163]
		v_pk_add_f32 v[154:155], v[4:5], v[40:41]
		v_mov_b64_e32 v[4:5], v[164:165]
		v_pk_add_f32 v[156:157], v[4:5], v[42:43]
		v_mov_b64_e32 v[4:5], v[166:167]
		v_pk_add_f32 v[158:159], v[4:5], v[44:45]
		v_mov_b64_e32 v[4:5], v[168:169]
		v_pk_add_f32 v[40:41], v[4:5], v[46:47]
		v_mov_b64_e32 v[4:5], v[170:171]
		v_pk_add_f32 v[42:43], v[4:5], v[48:49]
		v_lshlrev_b32_e32 v4, 8, v11
		v_lshlrev_b32_e32 v5, 7, v10
		v_mov_b32_e32 v6, 0x408
		v_mul_lo_u32 v6, v6, v26
		v_lshlrev_b32_e32 v7, 2, v36
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v9, 6, v8
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v31, 5, v1
		v_add3_u32 v33, v7, v9, v31
		v_lshlrev_b32_e32 v37, 4, v32
		v_lshlrev_b32_e32 v44, 3, v30
		v_add3_u32 v33, v33, v37, v44
		v_mov_b32_e32 v45, 0x204
		v_mul_lo_u32 v45, v45, v27
		v_bitop3_b32 v33, v6, v33, v45 bitop3:0x96
		v_bitop3_b32 v33, v4, v5, v33 bitop3:0x96
		v_lshlrev_b32_e32 v33, 2, v33
		ds_write_b128 v33, v[108:111]
		v_add_u32_e32 v46, 0x810, v7
		v_bitop3_b32 v46, v37, v46, v44 bitop3:0x96
		v_bitop3_b32 v46, v9, v31, v46 bitop3:0x96
		v_bitop3_b32 v46, v6, v45, v46 bitop3:0x96
		v_bitop3_b32 v46, v4, v5, v46 bitop3:0x96
		v_lshlrev_b32_e32 v46, 2, v46
		ds_write_b128 v46, v[172:175]
		v_add_u32_e32 v47, 0x1020, v7
		v_bitop3_b32 v47, v37, v47, v44 bitop3:0x96
		v_bitop3_b32 v47, v9, v31, v47 bitop3:0x96
		v_bitop3_b32 v47, v6, v45, v47 bitop3:0x96
		v_bitop3_b32 v47, v4, v5, v47 bitop3:0x96
		v_lshlrev_b32_e32 v47, 2, v47
		ds_write_b128 v47, v[112:115]
		v_add_u32_e32 v7, 0x1830, v7
		v_bitop3_b32 v7, v37, v7, v44 bitop3:0x96
		v_bitop3_b32 v7, v9, v31, v7 bitop3:0x96
		v_bitop3_b32 v6, v6, v45, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v5, v6 bitop3:0x96
		v_lshlrev_b32_e32 v4, 2, v4
		ds_write_b128 v4, v[116:119]
		v_lshlrev_b32_e32 v5, 5, v11
		v_lshlrev_b32_e32 v6, 4, v10
		v_lshlrev_b32_e32 v7, 3, v26
		v_lshlrev_b32_e32 v9, 2, v27
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b32_e32 v10, 0x1020
		v_mul_lo_u32 v10, v10, v8
		v_mov_b32_e32 v8, 0x810
		v_mul_lo_u32 v8, v8, v1
		v_lshlrev_b32_e32 v1, 7, v32
		v_mov_b32_e32 v11, 0x204
		v_mul_lo_u32 v11, v11, v36
		v_mov_b32_e32 v26, 0x408
		v_mul_lo_u32 v26, v26, v30
		v_bitop3_b32 v27, v1, v11, v26 bitop3:0x96
		v_bitop3_b32 v27, v10, v8, v27 bitop3:0x96
		v_bitop3_b32 v27, v7, v9, v27 bitop3:0x96
		v_bitop3_b32 v27, v5, v6, v27 bitop3:0x96
		v_lshlrev_b32_e32 v27, 2, v27
		ds_read_b128 v[48:51], v27
		v_xor_b32_e32 v30, 64, v11
		v_bitop3_b32 v30, v1, v26, v30 bitop3:0x96
		v_bitop3_b32 v30, v10, v8, v30 bitop3:0x96
		v_bitop3_b32 v30, v7, v9, v30 bitop3:0x96
		v_bitop3_b32 v30, v5, v6, v30 bitop3:0x96
		v_lshlrev_b32_e32 v30, 2, v30
		ds_read_b128 v[108:111], v30
		v_xor_b32_e32 v31, 0x100, v11
		v_bitop3_b32 v31, v1, v26, v31 bitop3:0x96
		v_bitop3_b32 v31, v10, v8, v31 bitop3:0x96
		v_bitop3_b32 v31, v7, v9, v31 bitop3:0x96
		v_bitop3_b32 v31, v5, v6, v31 bitop3:0x96
		v_lshlrev_b32_e32 v31, 2, v31
		ds_read_b128 v[112:115], v31
		v_xor_b32_e32 v11, 0x140, v11
		v_bitop3_b32 v1, v1, v26, v11 bitop3:0x96
		v_bitop3_b32 v1, v10, v8, v1 bitop3:0x96
		v_bitop3_b32 v1, v7, v9, v1 bitop3:0x96
		v_bitop3_b32 v1, v5, v6, v1 bitop3:0x96
		v_lshlrev_b32_e32 v1, 2, v1
		ds_read_b128 v[8:11], v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v33, v[52:55]
		ds_write_b128 v46, v[120:123]
		ds_write_b128 v47, v[124:127]
		ds_write_b128 v4, v[128:131]
		v_mov_b64_e32 v[6:7], v[48:49]
		v_pk_fma_f32 v[120:121], v[6:7], v[2:3], v[6:7]
		v_mov_b64_e32 v[2:3], v[50:51]
		v_pk_fma_f32 v[122:123], v[2:3], v[12:13], v[2:3]
		v_mov_b64_e32 v[2:3], v[108:109]
		v_pk_fma_f32 v[124:125], v[2:3], v[18:19], v[2:3]
		v_mov_b64_e32 v[2:3], v[110:111]
		v_pk_fma_f32 v[126:127], v[2:3], v[20:21], v[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v27
		ds_read_b128 v[52:55], v30
		ds_read_b128 v[108:111], v31
		ds_read_b128 v[116:119], v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v33, v[132:135]
		ds_write_b128 v46, v[136:139]
		ds_write_b128 v47, v[140:143]
		ds_write_b128 v4, v[144:147]
		v_mov_b64_e32 v[2:3], v[112:113]
		v_pk_fma_f32 v[128:129], v[2:3], v[28:29], v[2:3]
		v_mov_b64_e32 v[2:3], v[114:115]
		v_pk_fma_f32 v[130:131], v[2:3], v[34:35], v[2:3]
		v_mov_b64_e32 v[2:3], v[8:9]
		v_pk_fma_f32 v[132:133], v[2:3], v[38:39], v[2:3]
		v_mov_b64_e32 v[2:3], v[10:11]
		v_pk_fma_f32 v[134:135], v[2:3], v[56:57], v[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v27
		ds_read_b128 v[36:39], v30
		ds_read_b128 v[112:115], v31
		ds_read_b128 v[136:139], v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v33, v[148:151]
		ds_write_b128 v46, v[152:155]
		ds_write_b128 v47, v[156:159]
		ds_write_b128 v4, v[40:43]
		v_mov_b64_e32 v[2:3], v[48:49]
		v_pk_fma_f32 v[40:41], v[2:3], v[58:59], v[2:3]
		v_mov_b64_e32 v[2:3], v[50:51]
		v_pk_fma_f32 v[42:43], v[2:3], v[60:61], v[2:3]
		v_mov_b64_e32 v[2:3], v[52:53]
		v_pk_fma_f32 v[44:45], v[2:3], v[62:63], v[2:3]
		v_mov_b64_e32 v[2:3], v[54:55]
		v_pk_fma_f32 v[46:47], v[2:3], v[64:65], v[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v27
		ds_read_b128 v[32:35], v30
		ds_read_b128 v[48:51], v31
		ds_read_b128 v[28:31], v1
		v_mov_b64_e32 v[2:3], v[108:109]
		v_pk_fma_f32 v[56:57], v[2:3], v[66:67], v[2:3]
		v_mov_b64_e32 v[2:3], v[110:111]
		v_pk_fma_f32 v[58:59], v[2:3], v[88:89], v[2:3]
		v_mov_b64_e32 v[2:3], v[116:117]
		v_pk_fma_f32 v[60:61], v[2:3], v[68:69], v[2:3]
		v_mov_b64_e32 v[2:3], v[118:119]
		v_pk_fma_f32 v[62:63], v[2:3], v[90:91], v[2:3]
		v_mov_b64_e32 v[2:3], v[8:9]
		v_pk_fma_f32 v[144:145], v[2:3], v[70:71], v[2:3]
		v_mov_b64_e32 v[2:3], v[10:11]
		v_pk_fma_f32 v[146:147], v[2:3], v[92:93], v[2:3]
		v_mov_b64_e32 v[2:3], v[36:37]
		v_pk_fma_f32 v[148:149], v[2:3], v[72:73], v[2:3]
		v_mov_b64_e32 v[2:3], v[38:39]
		v_pk_fma_f32 v[150:151], v[2:3], v[94:95], v[2:3]
		v_mov_b64_e32 v[2:3], v[112:113]
		v_pk_fma_f32 v[64:65], v[2:3], v[74:75], v[2:3]
		v_mov_b64_e32 v[2:3], v[114:115]
		v_pk_fma_f32 v[66:67], v[2:3], v[96:97], v[2:3]
		v_mov_b64_e32 v[2:3], v[136:137]
		v_pk_fma_f32 v[68:69], v[2:3], v[76:77], v[2:3]
		v_mov_b64_e32 v[2:3], v[138:139]
		v_pk_fma_f32 v[70:71], v[2:3], v[98:99], v[2:3]
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[2:3], v[4:5]
		v_pk_fma_f32 v[88:89], v[2:3], v[78:79], v[2:3]
		v_mov_b64_e32 v[2:3], v[6:7]
		v_pk_fma_f32 v[90:91], v[2:3], v[100:101], v[2:3]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[2:3], v[32:33]
		v_pk_fma_f32 v[92:93], v[2:3], v[80:81], v[2:3]
		v_mov_b64_e32 v[2:3], v[34:35]
		v_pk_fma_f32 v[94:95], v[2:3], v[102:103], v[2:3]
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[2:3], v[48:49]
		v_pk_fma_f32 v[32:33], v[2:3], v[82:83], v[2:3]
		v_mov_b64_e32 v[2:3], v[50:51]
		v_pk_fma_f32 v[34:35], v[2:3], v[104:105], v[2:3]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[2:3], v[28:29]
		v_pk_fma_f32 v[36:37], v[2:3], v[84:85], v[2:3]
		v_mov_b64_e32 v[2:3], v[30:31]
		v_pk_fma_f32 v[38:39], v[2:3], v[106:107], v[2:3]
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		v_cvt_pk_f16_f32 v6, v124, v125
		v_cvt_pk_f16_f32 v7, v126, v127
		v_mul_lo_u32 v1, s19, v22
		v_lshl_add_u32 v1, v1, 1, v0
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s30
		s_mov_b32 s3, s31
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v23
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v128, v129
		v_cvt_pk_f16_f32 v5, v130, v131
		v_cvt_pk_f16_f32 v6, v132, v133
		v_cvt_pk_f16_f32 v7, v134, v135
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v24
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v40, v41
		v_cvt_pk_f16_f32 v5, v42, v43
		v_cvt_pk_f16_f32 v6, v44, v45
		v_cvt_pk_f16_f32 v7, v46, v47
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v25
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v56, v57
		v_cvt_pk_f16_f32 v5, v58, v59
		v_cvt_pk_f16_f32 v6, v60, v61
		v_cvt_pk_f16_f32 v7, v62, v63
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v14
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v144, v145
		v_cvt_pk_f16_f32 v5, v146, v147
		v_cvt_pk_f16_f32 v6, v148, v149
		v_cvt_pk_f16_f32 v7, v150, v151
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v15
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v64, v65
		v_cvt_pk_f16_f32 v5, v66, v67
		v_cvt_pk_f16_f32 v6, v68, v69
		v_cvt_pk_f16_f32 v7, v70, v71
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v16
		v_lshl_add_u32 v1, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v88, v89
		v_cvt_pk_f16_f32 v5, v90, v91
		v_cvt_pk_f16_f32 v6, v92, v93
		v_cvt_pk_f16_f32 v7, v94, v95
		buffer_store_dwordx4 v[4:7], v1, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v1, s19, v17
		v_lshl_add_u32 v0, v1, 1, v0
		v_cvt_pk_f16_f32 v4, v32, v33
		v_cvt_pk_f16_f32 v5, v34, v35
		v_cvt_pk_f16_f32 v6, v36, v37
		v_cvt_pk_f16_f32 v7, v38, v39
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen sc0 nt
		s_waitcnt vmcnt(0)
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
		.amdhsa_next_free_vgpr 176
		.amdhsa_next_free_sgpr 38
		.amdhsa_accum_offset 176
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
	.set .Ltlx_addmm_glu_kernel_optimized.num_vgpr, 176
	.set .Ltlx_addmm_glu_kernel_optimized.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 38
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
    .sgpr_count:     38
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized.kd
    .uses_dynamic_stack: false
    .vgpr_count:     176
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
