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
		v_add3_u32 v3, 8, v3, s1
		v_cndmask_b32_e32 v17, v17, v18, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		s_add_i32 s28, s28, 1
		v_mov_b32_e32 v18, s12
		v_mov_b32_e32 v19, s28
		v_cndmask_b32_e64 v18, v18, v19, s[26:27]
		v_cvt_f32_u32_e32 v19, v18
		v_rcp_iflag_f32_e32 v19, v19
		v_xad_u32 v20, v18, -1, 1
		v_mul_f32_e32 v19, v2, v19
		v_cvt_u32_f32_e32 v19, v19
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
		v_add3_u32 v23, 16, v13, s1
		v_cndmask_b32_e32 v17, v17, v21, vcc
		v_add_u32_e32 v21, v17, v20
		v_cmp_ge_u32_e64 vcc, v17, v18
		v_add3_u32 v24, 32, v13, s1
		v_add3_u32 v25, 48, v13, s1
		v_cndmask_b32_e32 v17, v17, v21, vcc
		v_xad_u32 v21, v17, -1, 1
		v_cmp_lt_i32_e64 vcc, v3, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v26, v3, -1, 1
		v_add3_u32 v13, 64, v13, s1
		v_cndmask_b32_e32 v3, v3, v26, vcc
		v_mul_hi_u32 v26, v3, v19
		v_mul_lo_u32 v26, v26, v18
		v_xor_b32_e32 v26, -1, v26
		v_add3_u32 v3, 1, v26, v3
		v_add_u32_e32 v26, v3, v20
		v_cmp_ge_u32_e64 vcc, v3, v18
		v_add_u32_e32 v14, s1, v14
		v_add_u32_e32 v15, s1, v15
		v_cndmask_b32_e32 v3, v3, v26, vcc
		v_add_u32_e32 v26, v3, v20
		v_cmp_ge_u32_e64 vcc, v3, v18
		v_add_u32_e32 v16, s1, v16
		v_cndmask_b32_e64 v17, v17, v21, s[20:21]
		v_cndmask_b32_e32 v3, v3, v26, vcc
		v_xad_u32 v21, v3, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v26, v22, -1, 1
		v_cndmask_b32_e64 v3, v3, v21, s[26:27]
		v_cndmask_b32_e32 v21, v22, v26, vcc
		v_mul_hi_u32 v22, v21, v19
		v_mul_lo_u32 v22, v22, v18
		v_xor_b32_e32 v22, -1, v22
		v_add3_u32 v21, 1, v22, v21
		v_cmp_ge_u32_e64 vcc, v21, v18
		v_add_u32_e32 v22, v21, v20
		v_and_b32_e32 v26, 1, v4
		v_cndmask_b32_e32 v21, v21, v22, vcc
		v_cmp_ge_u32_e64 vcc, v21, v18
		v_add_u32_e32 v22, v21, v20
		v_lshlrev_b32_e32 v27, 6, v10
		v_cndmask_b32_e32 v21, v21, v22, vcc
		v_xad_u32 v22, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v28, v23, -1, 1
		v_cndmask_b32_e64 v21, v21, v22, s[20:21]
		v_cndmask_b32_e32 v22, v23, v28, vcc
		v_mul_hi_u32 v23, v22, v19
		v_mul_lo_u32 v23, v23, v18
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v22, 1, v23, v22
		v_cmp_ge_u32_e64 vcc, v22, v18
		v_add_u32_e32 v23, v22, v20
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v28, s18, v21
		v_cndmask_b32_e32 v22, v22, v23, vcc
		v_cmp_ge_u32_e64 vcc, v22, v18
		v_add_u32_e32 v23, v22, v20
		s_lshl_b32 s1, s17, 6
		v_cndmask_b32_e32 v22, v22, v23, vcc
		v_xad_u32 v23, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v29, v24, -1, 1
		v_cndmask_b32_e64 v22, v22, v23, s[26:27]
		v_cndmask_b32_e32 v23, v24, v29, vcc
		v_mul_hi_u32 v24, v23, v19
		v_mul_lo_u32 v24, v24, v18
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v23, 1, v24, v23
		v_cmp_ge_u32_e64 vcc, v23, v18
		v_add_u32_e32 v24, v23, v20
		s_lshl_b32 s12, s17, 3
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_cmp_ge_u32_e64 vcc, v23, v18
		v_add_u32_e32 v24, v23, v20
		v_and_b32_e32 v5, 1, v5
		v_cndmask_b32_e32 v23, v23, v24, vcc
		v_xad_u32 v24, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v29, v25, -1, 1
		v_cndmask_b32_e64 v23, v23, v24, s[20:21]
		v_cndmask_b32_e32 v24, v25, v29, vcc
		v_mul_hi_u32 v25, v24, v19
		v_mul_lo_u32 v25, v25, v18
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v24, 1, v25, v24
		v_cmp_ge_u32_e64 vcc, v24, v18
		v_add_u32_e32 v25, v24, v20
		v_and_b32_e32 v29, 1, v7
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_cmp_ge_u32_e64 vcc, v24, v18
		v_add_u32_e32 v25, v24, v20
		v_and_b32_e32 v9, 1, v9
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_xad_u32 v25, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v30, v13, -1, 1
		v_cndmask_b32_e64 v24, v24, v25, s[26:27]
		v_cndmask_b32_e32 v13, v13, v30, vcc
		v_mul_hi_u32 v25, v13, v19
		v_mul_lo_u32 v25, v25, v18
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v13, 1, v25, v13
		v_cmp_ge_u32_e64 vcc, v13, v18
		v_add_u32_e32 v25, v13, v20
		v_mul_lo_u32 v30, s17, v10
		v_cndmask_b32_e32 v13, v13, v25, vcc
		v_cmp_ge_u32_e64 vcc, v13, v18
		v_add_u32_e32 v25, v13, v20
		v_mul_lo_u32 v31, s15, v3
		v_cndmask_b32_e32 v13, v13, v25, vcc
		v_xad_u32 v25, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v32, v14, -1, 1
		v_cndmask_b32_e64 v13, v13, v25, s[20:21]
		v_cndmask_b32_e32 v14, v14, v32, vcc
		v_mul_hi_u32 v25, v14, v19
		v_mul_lo_u32 v25, v25, v18
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v14, 1, v25, v14
		v_cmp_ge_u32_e64 vcc, v14, v18
		v_add_u32_e32 v25, v14, v20
		v_lshrrev_b32_e32 v32, 1, v0
		v_cndmask_b32_e32 v14, v14, v25, vcc
		v_cmp_ge_u32_e64 vcc, v14, v18
		v_add_u32_e32 v25, v14, v20
		v_mov_b32_e32 v33, s13
		v_cndmask_b32_e32 v14, v14, v25, vcc
		v_xad_u32 v25, v14, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v34, v15, -1, 1
		v_cndmask_b32_e64 v14, v14, v25, s[26:27]
		v_cndmask_b32_e32 v15, v15, v34, vcc
		v_mul_hi_u32 v25, v15, v19
		v_mul_lo_u32 v25, v25, v18
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v15, 1, v25, v15
		v_cmp_ge_u32_e64 vcc, v15, v18
		v_add_u32_e32 v25, v15, v20
		s_xor_b32 s26, s13, -1
		v_cndmask_b32_e32 v15, v15, v25, vcc
		v_cmp_ge_u32_e64 vcc, v15, v18
		v_add_u32_e32 v25, v15, v20
		v_and_b32_e32 v4, 15, v4
		v_cndmask_b32_e32 v15, v15, v25, vcc
		v_xad_u32 v25, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v34, v16, -1, 1
		v_cndmask_b32_e64 v15, v15, v25, s[20:21]
		v_cndmask_b32_e32 v16, v16, v34, vcc
		v_mul_hi_u32 v19, v16, v19
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v19, -1, v19
		v_add3_u32 v16, 1, v19, v16
		v_cmp_ge_u32_e64 vcc, v16, v18
		v_add_u32_e32 v19, v16, v20
		v_and_b32_e32 v25, 31, v0
		v_cndmask_b32_e32 v16, v16, v19, vcc
		v_cmp_ge_u32_e64 vcc, v16, v18
		v_add_u32_e32 v18, v16, v20
		s_mul_i32 s0, s0, 0x100
		v_cndmask_b32_e32 v16, v16, v18, vcc
		v_xad_u32 v18, v16, -1, 1
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v4
		v_add_u32_e32 v4, 0x80, v19
		v_add_u32_e32 v20, 0xc0, v19
		v_mad_u32_u24 v25, v25, 8, s0
		v_cmp_lt_i32_e64 vcc, v25, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v34, v25, -1, 1
		v_cndmask_b32_e64 v16, v16, v18, s[28:29]
		v_cndmask_b32_e32 v18, v25, v34, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s28, s22, s24
		s_cselect_b32 s29, s23, s25
		s_add_i32 s13, s26, 1
		v_mov_b32_e32 v25, s13
		v_cndmask_b32_e64 v25, v33, v25, s[28:29]
		v_cvt_f32_u32_e32 v33, v25
		v_rcp_iflag_f32_e32 v33, v33
		v_xad_u32 v34, v25, -1, 1
		v_mul_f32_e32 v2, v2, v33
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v33, v34, v2
		v_mul_hi_u32 v33, v2, v33
		v_add_u32_e32 v2, v2, v33
		v_mul_hi_u32 v33, v18, v2
		v_mul_lo_u32 v33, v33, v25
		v_xor_b32_e32 v33, -1, v33
		v_add3_u32 v18, 1, v33, v18
		v_add_u32_e32 v33, v18, v34
		v_cmp_ge_u32_e64 vcc, v18, v25
		v_add_u32_e32 v35, s0, v19
		v_add3_u32 v19, 64, v19, s0
		v_cndmask_b32_e32 v18, v18, v33, vcc
		v_add_u32_e32 v33, v18, v34
		v_cmp_ge_u32_e64 vcc, v18, v25
		v_add_u32_e32 v4, s0, v4
		v_add_u32_e32 v20, s0, v20
		v_cndmask_b32_e32 v18, v18, v33, vcc
		v_xad_u32 v33, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v36, v35, -1, 1
		v_cndmask_b32_e64 v18, v18, v33, s[20:21]
		v_cndmask_b32_e32 v33, v35, v36, vcc
		v_mul_hi_u32 v35, v33, v2
		v_mul_lo_u32 v35, v35, v25
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v33, 1, v35, v33
		v_cmp_ge_u32_e64 vcc, v33, v25
		v_add_u32_e32 v35, v33, v34
		v_lshrrev_b32_e32 v36, 2, v0
		v_cndmask_b32_e32 v33, v33, v35, vcc
		v_cmp_ge_u32_e64 vcc, v33, v25
		v_add_u32_e32 v35, v33, v34
		v_and_b32_e32 v37, 1, v0
		v_cndmask_b32_e32 v33, v33, v35, vcc
		v_xad_u32 v35, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v38, v19, -1, 1
		v_cndmask_b32_e64 v33, v33, v35, s[22:23]
		v_cndmask_b32_e32 v19, v19, v38, vcc
		v_mul_hi_u32 v35, v19, v2
		v_mul_lo_u32 v35, v35, v25
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v19, 1, v35, v19
		v_cmp_ge_u32_e64 vcc, v19, v25
		v_add_u32_e32 v35, v19, v34
		v_mul_lo_u32 v38, s15, v17
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_cmp_ge_u32_e64 vcc, v19, v25
		v_add_u32_e32 v35, v19, v34
		s_mov_b32 s26, 0x7fffffff
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_xad_u32 v35, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v4, s16
		s_mov_b64 s[22:23], vcc
		v_xad_u32 v39, v4, -1, 1
		v_cndmask_b32_e64 v19, v19, v35, s[20:21]
		v_cndmask_b32_e32 v4, v4, v39, vcc
		v_mul_hi_u32 v35, v4, v2
		v_mul_lo_u32 v35, v35, v25
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v4, 1, v35, v4
		v_cmp_ge_u32_e64 vcc, v4, v25
		v_add_u32_e32 v35, v4, v34
		v_mov_b32_e32 v39, 16
		v_mul_lo_u32 v39, v39, v6
		v_cndmask_b32_e32 v4, v4, v35, vcc
		v_cmp_ge_u32_e64 vcc, v4, v25
		v_add_u32_e32 v6, v4, v34
		v_and_b32_e32 v35, 7, v0
		v_cndmask_b32_e32 v4, v4, v6, vcc
		v_xad_u32 v6, v4, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v40, v20, -1, 1
		v_cndmask_b32_e64 v4, v4, v6, s[22:23]
		v_cndmask_b32_e32 v6, v20, v40, vcc
		v_mul_hi_u32 v2, v6, v2
		v_mul_lo_u32 v2, v2, v25
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v6
		v_cmp_ge_u32_e64 vcc, v2, v25
		v_add_u32_e32 v6, v2, v34
		s_mov_b32 s0, 63
		v_cndmask_b32_e32 v2, v2, v6, vcc
		v_cmp_ge_u32_e64 vcc, v2, v25
		v_add_u32_e32 v6, v2, v34
		s_add_i32 s13, s14, 63
		v_cndmask_b32_e32 v2, v2, v6, vcc
		v_xad_u32 v6, v2, -1, 1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s0, s0, 0
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v35
		v_add3_u32 v8, v39, v8, v11
		v_mad_u32_u24 v8, v12, 8, v8
		v_add_u32_e32 v11, 4, v8
		v_add_u32_e32 v12, 32, v8
		v_cmp_lt_i32_e64 vcc, v20, s14
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v25, 4, v37
		v_lshl_add_u32 v34, v38, 1, v25
		v_and_b32_e32 v35, 1, v36
		v_lshlrev_b32_e32 v36, 6, v35
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v38, 5, v32
		v_add3_u32 v34, v34, v36, v38
		v_mov_b32_e32 v39, 0x80000000
		v_cndmask_b32_e32 v40, v39, v34, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s2, 0x420, s2
		s_mov_b32 m0, s2
		v_mov_b32_e32 v44, 0
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		v_lshl_add_u32 v31, v31, 1, v25
		v_add3_u32 v31, v31, v36, v38
		v_cndmask_b32_e32 v40, v39, v31, vcc
		s_add_i32 m0, s2, 0x2100
		s_add_i32 s0, s13, s0
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v8, s14
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v11, s14
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v12, s14
		s_mov_b64 s[32:33], vcc
		v_lshlrev_b32_e32 v18, 1, v18
		v_lshl_add_u32 v30, v30, 4, v18
		v_mul_lo_u32 v40, s17, v9
		v_lshl_add_u32 v30, v40, 2, v30
		v_mul_lo_u32 v40, s17, v29
		v_lshl_add_u32 v30, v40, 1, v30
		v_mul_lo_u32 v40, s17, v5
		v_lshl_add_u32 v30, v40, 5, v30
		v_cndmask_b32_e64 v40, v39, v30, s[4:5]
		s_add_i32 m0, s2, 0xc5e0
		v_cndmask_b32_e64 v2, v2, v6, s[20:21]
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		v_add_u32_e32 v6, 36, v8
		v_add_u32_e32 v40, s12, v30
		s_add_i32 m0, s2, 0xe6e0
		v_cndmask_b32_e64 v40, v39, v40, s[22:23]
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		v_add_u32_e32 v40, s1, v30
		s_add_i32 m0, s2, 0x107e0
		v_cndmask_b32_e64 v40, v39, v40, s[32:33]
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_mul_i32 s1, 0x48, s17
		v_cmp_lt_i32_e64 vcc, v6, s14
		v_add_u32_e32 v40, s1, v30
		v_lshlrev_b32_e32 v33, 1, v33
		v_cndmask_b32_e32 v40, v39, v40, vcc
		s_add_i32 m0, s2, 0x128e0
		s_ashr_i32 s0, s0, 6
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_add_i32 s1, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v20, s1
		v_add_u32_e32 v40, 0x80, v34
		s_mul_i32 s3, 0xc0, s17
		v_cndmask_b32_e32 v40, v39, v40, vcc
		s_add_i32 m0, s2, 0x4200
		s_add_i32 s4, s0, -1
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		v_add_u32_e32 v40, 0x80, v31
		v_cndmask_b32_e32 v40, v39, v40, vcc
		s_add_i32 m0, s2, 0x6300
		s_lshl_b32 s5, s17, 7
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v8, s1
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v11, s1
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_i32_e64 vcc, v12, s1
		s_mov_b64 s[22:23], vcc
		v_add_u32_e32 v40, s5, v30
		s_add_i32 m0, s2, 0x149e0
		v_cndmask_b32_e64 v40, v39, v40, s[12:13]
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_mul_i32 s5, 0x88, s17
		v_add_u32_e32 v40, s5, v30
		s_add_i32 m0, s2, 0x16ae0
		v_cndmask_b32_e64 v40, v39, v40, s[20:21]
		v_add_u32_e32 v41, s3, v30
		v_cndmask_b32_e64 v41, v39, v41, s[22:23]
		s_mul_i32 s3, 0xc8, s17
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x18be0
		v_cmp_lt_i32_e64 vcc, v6, s1
		v_add_u32_e32 v40, s3, v30
		s_lshl_b32 s1, s15, 1
		buffer_load_dwordx4 v41, s[28:31], 0 offen lds
		v_cndmask_b32_e32 v40, v39, v40, vcc
		s_add_i32 m0, s2, 0x1ace0
		v_add3_u32 v25, v25, v36, v38
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_add_i32 s3, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v20, s3
		v_add_u32_e32 v34, 0x100, v34
		v_and_b32_e32 v7, 3, v7
		v_cndmask_b32_e32 v34, v39, v34, vcc
		s_add_i32 m0, s2, 0x8400
		v_add_u32_e32 v31, 0x100, v31
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		v_cndmask_b32_e32 v31, v39, v31, vcc
		s_add_i32 m0, s2, 0xa500
		s_lshl_b32 s5, s17, 8
		v_cmp_lt_i32_e64 vcc, v8, s3
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v11, s3
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_i32_e64 vcc, v12, s3
		s_mov_b64 s[22:23], vcc
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_add_u32_e32 v31, s5, v30
		s_add_i32 m0, s2, 0x1cde0
		v_cndmask_b32_e64 v31, v39, v31, s[12:13]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_mul_i32 s5, 0x108, s17
		v_add_u32_e32 v31, s5, v30
		s_add_i32 m0, s2, 0x1eee0
		v_cndmask_b32_e64 v31, v39, v31, s[20:21]
		s_mul_i32 s5, 0x140, s17
		v_add_u32_e32 v34, s5, v30
		v_cndmask_b32_e64 v34, v39, v34, s[22:23]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x20fe0
		s_mul_i32 s5, 0x148, s17
		v_cmp_lt_i32_e64 vcc, v6, s3
		v_add_u32_e32 v31, s5, v30
		v_and_b32_e32 v0, 63, v0
		v_cndmask_b32_e32 v31, v39, v31, vcc
		v_lshlrev_b32_e32 v36, 7, v10
		buffer_load_dwordx4 v34, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x230e0
		v_lshrrev_b32_e32 v34, 4, v0
		v_lshlrev_b32_e32 v38, 4, v34
		v_and_b32_e32 v40, 15, v0
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_mov_b32_e32 v31, 0x420
		v_mul_lo_u32 v31, v31, v40
		v_add3_u32 v31, v36, v38, v31
		ds_read_b128 v[48:51], v31
		ds_read_b128 v[52:55], v31 offset:64
		ds_read_b128 v[56:59], v31 offset:256
		ds_read_b128 v[60:63], v31 offset:320
		ds_read_b128 v[64:67], v31 offset:512
		ds_read_b128 v[68:71], v31 offset:576
		ds_read_b128 v[72:75], v31 offset:768
		ds_read_b128 v[76:79], v31 offset:832
		v_lshrrev_b32_e32 v0, 5, v0
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshrrev_b32_e32 v36, 2, v40
		v_mov_b32_e32 v38, 0x420
		v_mul_lo_u32 v38, v38, v36
		v_lshlrev_b32_e32 v7, 5, v7
		v_add3_u32 v36, v0, v38, v7
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v41, 0x1080
		v_mul_lo_u32 v41, v41, v34
		v_and_b32_e32 v34, 3, v40
		v_lshlrev_b32_e32 v34, 3, v34
		v_add3_u32 v36, v36, v41, v34
		ds_read_b64_tr_b16 v[80:81], v36 offset:50656
		ds_read_b64_tr_b16 v[82:83], v36 offset:59104
		v_add_u32_e32 v0, 0x10000, v0
		v_add3_u32 v0, v0, v38, v7
		v_add3_u32 v0, v0, v41, v34
		ds_read_b64_tr_b16 v[40:41], v0 offset:2016
		ds_read_b64_tr_b16 v[42:43], v0 offset:10464
		ds_read_b64_tr_b16 v[84:85], v36 offset:50784
		ds_read_b64_tr_b16 v[86:87], v36 offset:59232
		ds_read_b64_tr_b16 v[88:89], v0 offset:2144
		ds_read_b64_tr_b16 v[90:91], v0 offset:10592
		ds_read_b64_tr_b16 v[92:93], v36 offset:50912
		ds_read_b64_tr_b16 v[94:95], v36 offset:59360
		ds_read_b64_tr_b16 v[96:97], v0 offset:2272
		ds_read_b64_tr_b16 v[98:99], v0 offset:10720
		ds_read_b64_tr_b16 v[100:101], v36 offset:51040
		ds_read_b64_tr_b16 v[102:103], v36 offset:59488
		ds_read_b64_tr_b16 v[104:105], v0 offset:2400
		ds_read_b64_tr_b16 v[106:107], v0 offset:10848
		s_add_i32 s3, s0, -3
		v_add_u32_e32 v0, 0x180, v25
		v_mul_lo_u32 v7, s1, v17
		v_add_u32_e32 v17, v0, v7
		v_mul_lo_u32 v3, s1, v3
		v_add_u32_e32 v7, v0, v3
		s_mul_i32 s1, 0x180, s17
		s_mul_i32 s5, 0x188, s17
		s_mul_i32 s12, 0x1c0, s17
		s_mul_i32 s13, 0x1c8, s17
		s_cmp_lt_i32 0, s3
		v_mov_b32_e32 v45, 0
		v_mov_b64_e32 v[46:47], 0
		v_mov_b32_e32 v108, v44
		v_mov_b32_e32 v109, v45
		v_mov_b32_e32 v110, v46
		v_mov_b32_e32 v111, v47
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
		s_mov_b32 s15, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		s_cmp_ge_u32 s15, 2
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s15, -2
		s_add_i32 s22, s15, 1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[48:51], v[108:111]
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s21, s22
		s_cselect_b32 s23, 1, 0
		s_add_i32 s32, s16, 3
		s_mul_i32 s32, s32, 64
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		s_xor_b32 s32, s32, -1
		s_add_i32 s32, s32, 1
		s_add_i32 s32, s14, s32
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		v_cmp_lt_i32_e64 vcc, v20, s32
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[44:47], v[40:43], v[52:55], v[44:47]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[52:55], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[40:43], v[68:71], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[68:71], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[76:79], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[40:43], v[76:79], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[76:79], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[76:79], v[160:163]
		s_barrier
		v_cndmask_b32_e32 v0, v39, v17, vcc
		s_mul_i32 s33, 0x4200, s15
		s_add_i32 s33, s2, s33
		s_mov_b32 m0, s33
		s_lshl_b32 s34, s16, 7
		buffer_load_dwordx4 v0, s[24:27], s34 offen lds
		v_cndmask_b32_e32 v0, v39, v7, vcc
		s_add_i32 m0, s33, 0x2100
		s_mul_i32 s15, 0x8400, s15
		buffer_load_dwordx4 v0, s[24:27], s34 offen lds
		s_mul_i32 s33, s17, s16
		v_cmp_lt_i32_e64 vcc, v8, s32
		s_mov_b64 s[34:35], vcc
		v_cmp_lt_i32_e64 vcc, v11, s32
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v12, s32
		s_mov_b64 s[38:39], vcc
		s_lshl_b32 s33, s33, 7
		s_add_i32 s40, s1, s33
		v_add_u32_e32 v0, s40, v30
		s_add_i32 s15, s2, s15
		s_add_i32 m0, s15, 0xc5e0
		v_cndmask_b32_e64 v0, v39, v0, s[34:35]
		buffer_load_dwordx4 v0, s[28:31], 0 offen lds
		v_add_u32_e32 v0, s33, v30
		v_add_u32_e32 v3, s5, v0
		s_add_i32 m0, s15, 0xe6e0
		v_cndmask_b32_e64 v3, v39, v3, s[36:37]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s12, v0
		s_add_i32 m0, s15, 0x107e0
		v_cndmask_b32_e64 v3, v39, v3, s[38:39]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v6, s32
		v_add_u32_e32 v0, s13, v0
		s_mul_i32 s32, 0x8400, s20
		v_cndmask_b32_e32 v0, v39, v0, vcc
		s_add_i32 m0, s15, 0x128e0
		s_mul_i32 s15, 0x4200, s20
		buffer_load_dwordx4 v0, s[28:31], 0 offen lds
		v_add_u32_e32 v0, s15, v31
		ds_read_b128 v[48:51], v0
		ds_read_b128 v[52:55], v0 offset:64
		ds_read_b128 v[56:59], v0 offset:256
		ds_read_b128 v[60:63], v0 offset:320
		ds_read_b128 v[64:67], v0 offset:512
		ds_read_b128 v[68:71], v0 offset:576
		ds_read_b128 v[72:75], v0 offset:768
		ds_read_b128 v[76:79], v0 offset:832
		v_add_u32_e32 v0, s32, v36
		ds_read_b64_tr_b16 v[80:81], v0 offset:50656
		ds_read_b64_tr_b16 v[82:83], v0 offset:59104
		s_add_i32 s15, s32, 0x10000
		v_add_u32_e32 v3, s15, v36
		ds_read_b64_tr_b16 v[40:41], v3 offset:2016
		ds_read_b64_tr_b16 v[42:43], v3 offset:10464
		ds_read_b64_tr_b16 v[84:85], v0 offset:50784
		ds_read_b64_tr_b16 v[86:87], v0 offset:59232
		s_waitcnt vmcnt(6)
		s_barrier
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
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s15, s21, s22
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s3
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s26
		s_mov_b32 s15, s27
		buffer_load_dwordx2 v[6:7], v33, s[12:15], 0 offen
		v_lshlrev_b32_e32 v0, 1, v19
		buffer_load_dwordx2 v[38:39], v0, s[12:15], 0 offen
		v_lshlrev_b32_e32 v0, 1, v4
		buffer_load_dwordx2 v[168:169], v0, s[12:15], 0 offen
		v_lshlrev_b32_e32 v0, 1, v2
		buffer_load_dwordx2 v[2:3], v0, s[12:15], 0 offen
		v_lshl_add_u32 v0, v28, 1, v18
		s_mov_b32 s12, s8
		s_mov_b32 s13, s9
		s_mov_b32 s14, s26
		s_mov_b32 s15, s27
		buffer_load_dwordx4 v[172:175], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v22
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[176:179], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v23
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[180:183], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v24
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[184:187], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v13
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[188:191], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v14
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[192:195], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v15
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[196:199], v0, s[12:15], 0 offen sc0 nt
		v_mul_lo_u32 v0, s18, v16
		v_lshl_add_u32 v0, v0, 1, v18
		buffer_load_dwordx4 v[200:203], v0, s[12:15], 0 offen sc0 nt
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[48:51], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[44:47], v[40:43], v[52:55], v[44:47]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[52:55], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[40:43], v[68:71], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[68:71], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[76:79], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[40:43], v[76:79], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[76:79], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[76:79], v[160:163]
		s_add_i32 s0, s0, -2
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
		s_waitcnt vmcnt(12)
		s_barrier
		s_mul_i32 s1, 0x4200, s0
		v_add_u32_e32 v0, s1, v31
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[48:51], v0 offset:64
		ds_read_b128 v[52:55], v0 offset:256
		ds_read_b128 v[56:59], v0 offset:320
		ds_read_b128 v[60:63], v0 offset:512
		ds_read_b128 v[64:67], v0 offset:576
		ds_read_b128 v[68:71], v0 offset:768
		ds_read_b128 v[72:75], v0 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v0, s0, v36
		ds_read_b64_tr_b16 v[76:77], v0 offset:50656
		ds_read_b64_tr_b16 v[78:79], v0 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v4, s0, v36
		ds_read_b64_tr_b16 v[80:81], v4 offset:2016
		ds_read_b64_tr_b16 v[82:83], v4 offset:10464
		ds_read_b64_tr_b16 v[84:85], v0 offset:50784
		ds_read_b64_tr_b16 v[86:87], v0 offset:59232
		ds_read_b64_tr_b16 v[88:89], v4 offset:2144
		ds_read_b64_tr_b16 v[90:91], v4 offset:10592
		ds_read_b64_tr_b16 v[92:93], v0 offset:50912
		ds_read_b64_tr_b16 v[94:95], v0 offset:59360
		ds_read_b64_tr_b16 v[96:97], v4 offset:2272
		ds_read_b64_tr_b16 v[98:99], v4 offset:10720
		ds_read_b64_tr_b16 v[100:101], v0 offset:51040
		ds_read_b64_tr_b16 v[102:103], v0 offset:59488
		ds_read_b64_tr_b16 v[104:105], v4 offset:2400
		ds_read_b64_tr_b16 v[106:107], v4 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[44:47], v[76:79], v[40:43], v[44:47]
		s_cmp_lt_i32 s4, 0
		s_cselect_b32 s0, 1, 0
		s_xor_b32 s1, s4, -1
		s_add_i32 s1, s1, 1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s1, s4
		s_mul_hi_u32 s1, s0, 0xaaaaaaab
		s_cselect_b32 s2, 1, 0
		s_lshr_b32 s1, s1, 1
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_mul_i32 s1, s1, 3
		s_xor_b32 s1, s1, -1
		s_add_i32 s1, s1, 1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		s_add_i32 s0, s0, s1
		s_xor_b32 s1, s0, -1
		s_add_i32 s1, s1, 1
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[52:55], v[132:135]
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s0, s1, s0
		s_mul_i32 s1, 0x4200, s0
		v_add_u32_e32 v0, s1, v31
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[48:51], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[72:75], v[160:163]
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[48:51], v0 offset:64
		ds_read_b128 v[52:55], v0 offset:256
		ds_read_b128 v[56:59], v0 offset:320
		ds_read_b128 v[60:63], v0 offset:512
		ds_read_b128 v[64:67], v0 offset:576
		ds_read_b128 v[68:71], v0 offset:768
		ds_read_b128 v[72:75], v0 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v0, s0, v36
		ds_read_b64_tr_b16 v[76:77], v0 offset:50656
		ds_read_b64_tr_b16 v[78:79], v0 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v4, s0, v36
		ds_read_b64_tr_b16 v[80:81], v4 offset:2016
		ds_read_b64_tr_b16 v[82:83], v4 offset:10464
		ds_read_b64_tr_b16 v[84:85], v0 offset:50784
		ds_read_b64_tr_b16 v[86:87], v0 offset:59232
		ds_read_b64_tr_b16 v[88:89], v4 offset:2144
		ds_read_b64_tr_b16 v[90:91], v4 offset:10592
		ds_read_b64_tr_b16 v[92:93], v0 offset:50912
		ds_read_b64_tr_b16 v[94:95], v0 offset:59360
		ds_read_b64_tr_b16 v[96:97], v4 offset:2272
		ds_read_b64_tr_b16 v[98:99], v4 offset:10720
		ds_read_b64_tr_b16 v[100:101], v0 offset:51040
		ds_read_b64_tr_b16 v[102:103], v0 offset:59488
		ds_read_b64_tr_b16 v[104:105], v4 offset:2400
		ds_read_b64_tr_b16 v[106:107], v4 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[44:47], v[76:79], v[40:43], v[44:47]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[44:47], v[80:83], v[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[56:59], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[72:75], v[160:163]
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v40, v6
		v_cvt_f32_f16_sdwa v41, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v7
		v_cvt_f32_f16_sdwa v43, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v48, v38
		v_cvt_f32_f16_sdwa v49, v38 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v50, v39
		v_cvt_f32_f16_sdwa v51, v39 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v52, v168
		v_cvt_f32_f16_sdwa v53, v168 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v54, v169
		v_cvt_f32_f16_sdwa v55, v169 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v56, v2
		v_cvt_f32_f16_sdwa v57, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v58, v3
		v_cvt_f32_f16_sdwa v59, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v2, v172
		v_cvt_f32_f16_sdwa v3, v172 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v6, v173
		v_cvt_f32_f16_sdwa v7, v173 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v30, v174
		v_cvt_f32_f16_sdwa v31, v174 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v38, v175
		v_cvt_f32_f16_sdwa v39, v175 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v60, v176
		v_cvt_f32_f16_sdwa v61, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v62, v177
		v_cvt_f32_f16_sdwa v63, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v178
		v_cvt_f32_f16_sdwa v65, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v66, v179
		v_cvt_f32_f16_sdwa v67, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v68, v180
		v_cvt_f32_f16_sdwa v69, v180 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v70, v181
		v_cvt_f32_f16_sdwa v71, v181 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v182
		v_cvt_f32_f16_sdwa v73, v182 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v74, v183
		v_cvt_f32_f16_sdwa v75, v183 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v76, v184
		v_cvt_f32_f16_sdwa v77, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v78, v185
		v_cvt_f32_f16_sdwa v79, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v80, v186
		v_cvt_f32_f16_sdwa v81, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v187
		v_cvt_f32_f16_sdwa v83, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v84, v188
		v_cvt_f32_f16_sdwa v85, v188 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v189
		v_cvt_f32_f16_sdwa v87, v189 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v190
		v_cvt_f32_f16_sdwa v89, v190 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v191
		v_cvt_f32_f16_sdwa v91, v191 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v92, v192
		v_cvt_f32_f16_sdwa v93, v192 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v193
		v_cvt_f32_f16_sdwa v95, v193 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v194
		v_cvt_f32_f16_sdwa v97, v194 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v195
		v_cvt_f32_f16_sdwa v99, v195 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v100, v196
		v_cvt_f32_f16_sdwa v101, v196 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v197
		v_cvt_f32_f16_sdwa v103, v197 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v198
		v_cvt_f32_f16_sdwa v105, v198 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v106, v199
		v_cvt_f32_f16_sdwa v107, v199 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v168, v200
		v_cvt_f32_f16_sdwa v169, v200 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v170, v201
		v_cvt_f32_f16_sdwa v171, v201 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v172, v202
		v_cvt_f32_f16_sdwa v173, v202 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v174, v203
		v_cvt_f32_f16_sdwa v175, v203 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[176:177], v[44:45], v[40:41]
		v_pk_add_f32 v[178:179], v[46:47], v[42:43]
		v_pk_add_f32 v[44:45], v[108:109], v[48:49]
		v_pk_add_f32 v[46:47], v[110:111], v[50:51]
		v_pk_add_f32 v[108:109], v[112:113], v[52:53]
		v_pk_add_f32 v[110:111], v[114:115], v[54:55]
		v_pk_add_f32 v[112:113], v[116:117], v[56:57]
		v_pk_add_f32 v[114:115], v[118:119], v[58:59]
		v_pk_add_f32 v[116:117], v[120:121], v[40:41]
		v_pk_add_f32 v[118:119], v[122:123], v[42:43]
		v_pk_add_f32 v[120:121], v[124:125], v[48:49]
		v_pk_add_f32 v[122:123], v[126:127], v[50:51]
		v_pk_add_f32 v[124:125], v[128:129], v[52:53]
		v_pk_add_f32 v[126:127], v[130:131], v[54:55]
		v_pk_add_f32 v[128:129], v[132:133], v[56:57]
		v_pk_add_f32 v[130:131], v[134:135], v[58:59]
		v_pk_add_f32 v[132:133], v[136:137], v[40:41]
		v_pk_add_f32 v[134:135], v[138:139], v[42:43]
		v_pk_add_f32 v[136:137], v[140:141], v[48:49]
		v_pk_add_f32 v[138:139], v[142:143], v[50:51]
		v_pk_add_f32 v[140:141], v[144:145], v[52:53]
		v_pk_add_f32 v[142:143], v[146:147], v[54:55]
		v_pk_add_f32 v[144:145], v[148:149], v[56:57]
		v_pk_add_f32 v[146:147], v[150:151], v[58:59]
		v_pk_add_f32 v[148:149], v[152:153], v[40:41]
		v_pk_add_f32 v[150:151], v[154:155], v[42:43]
		v_pk_add_f32 v[40:41], v[156:157], v[48:49]
		v_pk_add_f32 v[42:43], v[158:159], v[50:51]
		v_pk_add_f32 v[48:49], v[160:161], v[52:53]
		v_pk_add_f32 v[50:51], v[162:163], v[54:55]
		v_pk_add_f32 v[52:53], v[164:165], v[56:57]
		v_pk_add_f32 v[54:55], v[166:167], v[58:59]
		v_lshlrev_b32_e32 v0, 8, v9
		v_lshlrev_b32_e32 v4, 3, v29
		v_lshlrev_b32_e32 v8, 2, v5
		v_lshlrev_b32_e32 v11, 7, v26
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v12, 0x1020
		v_mul_lo_u32 v12, v12, v1
		v_mov_b32_e32 v17, 0x810
		v_mul_lo_u32 v17, v17, v35
		v_mov_b32_e32 v19, 0x204
		v_mul_lo_u32 v19, v19, v37
		v_mov_b32_e32 v20, 0x408
		v_mul_lo_u32 v20, v20, v32
		v_bitop3_b32 v17, v17, v19, v20 bitop3:0x96
		v_bitop3_b32 v11, v11, v12, v17 bitop3:0x96
		v_bitop3_b32 v4, v4, v8, v11 bitop3:0x96
		v_bitop3_b32 v0, v27, v0, v4 bitop3:0x96
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b128 v4, v[176:179]
		v_xor_b32_e32 v8, 16, v0
		v_lshlrev_b32_e32 v8, 2, v8
		ds_write_b128 v8, v[44:47]
		v_xor_b32_e32 v11, 32, v0
		v_lshlrev_b32_e32 v11, 2, v11
		ds_write_b128 v11, v[108:111]
		v_xor_b32_e32 v0, 48, v0
		v_lshlrev_b32_e32 v0, 2, v0
		ds_write_b128 v0, v[112:115]
		v_mov_b32_e32 v12, 0x1020
		v_mul_lo_u32 v12, v12, v10
		v_mov_b32_e32 v10, 0x810
		v_mul_lo_u32 v10, v10, v9
		v_mov_b32_e32 v9, 0x408
		v_mul_lo_u32 v9, v9, v29
		v_mov_b32_e32 v17, 0x204
		v_mul_lo_u32 v17, v17, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v5, 5, v26
		v_lshlrev_b32_e32 v19, 8, v35
		v_lshl_add_u32 v19, v37, 2, v19
		v_lshl_add_u32 v19, v32, 3, v19
		v_lshlrev_b32_e32 v1, 4, v1
		v_bitop3_b32 v1, v5, v19, v1 bitop3:0x96
		v_bitop3_b32 v1, v9, v17, v1 bitop3:0x96
		v_bitop3_b32 v1, v12, v10, v1 bitop3:0x96
		v_lshlrev_b32_e32 v1, 2, v1
		ds_read_b128 v[32:35], v1
		ds_read_b128 v[44:47], v1 offset:512
		ds_read_b128 v[56:59], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:768
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[116:119]
		ds_write_b128 v8, v[120:123]
		ds_write_b128 v11, v[124:127]
		ds_write_b128 v0, v[128:131]
		v_pk_fma_f32 v[112:113], v[32:33], v[2:3], v[32:33]
		v_pk_fma_f32 v[114:115], v[34:35], v[6:7], v[34:35]
		v_pk_fma_f32 v[116:117], v[44:45], v[30:31], v[44:45]
		v_pk_fma_f32 v[118:119], v[46:47], v[38:39], v[46:47]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[32:35], v1 offset:512
		ds_read_b128 v[36:39], v1 offset:256
		ds_read_b128 v[44:47], v1 offset:768
		v_pk_fma_f32 v[120:121], v[56:57], v[60:61], v[56:57]
		v_pk_fma_f32 v[122:123], v[58:59], v[62:63], v[58:59]
		v_pk_fma_f32 v[124:125], v[108:109], v[64:65], v[108:109]
		v_pk_fma_f32 v[126:127], v[110:111], v[66:67], v[110:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[132:135]
		ds_write_b128 v8, v[136:139]
		ds_write_b128 v11, v[140:143]
		ds_write_b128 v0, v[144:147]
		v_pk_fma_f32 v[56:57], v[28:29], v[68:69], v[28:29]
		v_pk_fma_f32 v[58:59], v[30:31], v[70:71], v[30:31]
		v_pk_fma_f32 v[60:61], v[32:33], v[72:73], v[32:33]
		v_pk_fma_f32 v[62:63], v[34:35], v[74:75], v[34:35]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[32:35], v1 offset:512
		ds_read_b128 v[64:67], v1 offset:256
		ds_read_b128 v[68:71], v1 offset:768
		v_pk_fma_f32 v[128:129], v[36:37], v[76:77], v[36:37]
		v_pk_fma_f32 v[130:131], v[38:39], v[78:79], v[38:39]
		v_pk_fma_f32 v[132:133], v[44:45], v[80:81], v[44:45]
		v_pk_fma_f32 v[134:135], v[46:47], v[82:83], v[46:47]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[148:151]
		ds_write_b128 v8, v[40:43]
		ds_write_b128 v11, v[48:51]
		ds_write_b128 v0, v[52:55]
		v_pk_fma_f32 v[40:41], v[28:29], v[84:85], v[28:29]
		v_pk_fma_f32 v[42:43], v[30:31], v[86:87], v[30:31]
		v_pk_fma_f32 v[44:45], v[32:33], v[88:89], v[32:33]
		v_pk_fma_f32 v[46:47], v[34:35], v[90:91], v[34:35]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v1
		ds_read_b128 v[8:11], v1 offset:512
		ds_read_b128 v[28:31], v1 offset:256
		ds_read_b128 v[32:35], v1 offset:768
		v_pk_fma_f32 v[48:49], v[64:65], v[92:93], v[64:65]
		v_pk_fma_f32 v[50:51], v[66:67], v[94:95], v[66:67]
		v_pk_fma_f32 v[52:53], v[68:69], v[96:97], v[68:69]
		v_pk_fma_f32 v[54:55], v[70:71], v[98:99], v[70:71]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[64:65], v[4:5], v[100:101], v[4:5]
		v_pk_fma_f32 v[66:67], v[6:7], v[102:103], v[6:7]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[68:69], v[8:9], v[104:105], v[8:9]
		v_pk_fma_f32 v[70:71], v[10:11], v[106:107], v[10:11]
		s_waitcnt lgkmcnt(1)
		v_pk_fma_f32 v[0:1], v[28:29], v[168:169], v[28:29]
		v_pk_fma_f32 v[2:3], v[30:31], v[170:171], v[30:31]
		s_waitcnt lgkmcnt(0)
		v_pk_fma_f32 v[4:5], v[32:33], v[172:173], v[32:33]
		v_pk_fma_f32 v[6:7], v[34:35], v[174:175], v[34:35]
		v_cvt_pk_f16_f32 v8, v112, v113
		v_cvt_pk_f16_f32 v9, v114, v115
		v_cvt_pk_f16_f32 v10, v116, v117
		v_cvt_pk_f16_f32 v11, v118, v119
		v_mul_lo_u32 v12, s19, v21
		v_lshl_add_u32 v12, v12, 1, v18
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s26
		s_mov_b32 s3, s27
		buffer_store_dwordx4 v[8:11], v12, s[0:3], 0 offen sc0 nt
		s_nop 1
		v_mul_lo_u32 v8, s19, v22
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v28, v120, v121
		v_cvt_pk_f16_f32 v29, v122, v123
		v_cvt_pk_f16_f32 v30, v124, v125
		v_cvt_pk_f16_f32 v31, v126, v127
		buffer_store_dwordx4 v[28:31], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v23
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v20, v56, v57
		v_cvt_pk_f16_f32 v21, v58, v59
		v_cvt_pk_f16_f32 v22, v60, v61
		v_cvt_pk_f16_f32 v23, v62, v63
		buffer_store_dwordx4 v[20:23], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v24
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v20, v128, v129
		v_cvt_pk_f16_f32 v21, v130, v131
		v_cvt_pk_f16_f32 v22, v132, v133
		v_cvt_pk_f16_f32 v23, v134, v135
		buffer_store_dwordx4 v[20:23], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v13
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v20, v40, v41
		v_cvt_pk_f16_f32 v21, v42, v43
		v_cvt_pk_f16_f32 v22, v44, v45
		v_cvt_pk_f16_f32 v23, v46, v47
		buffer_store_dwordx4 v[20:23], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v14
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v20, v48, v49
		v_cvt_pk_f16_f32 v21, v50, v51
		v_cvt_pk_f16_f32 v22, v52, v53
		v_cvt_pk_f16_f32 v23, v54, v55
		buffer_store_dwordx4 v[20:23], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v15
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v12, v64, v65
		v_cvt_pk_f16_f32 v13, v66, v67
		v_cvt_pk_f16_f32 v14, v68, v69
		v_cvt_pk_f16_f32 v15, v70, v71
		buffer_store_dwordx4 v[12:15], v8, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v8, s19, v16
		v_lshl_add_u32 v8, v8, 1, v18
		v_cvt_pk_f16_f32 v12, v0, v1
		v_cvt_pk_f16_f32 v13, v2, v3
		v_cvt_pk_f16_f32 v14, v4, v5
		v_cvt_pk_f16_f32 v15, v6, v7
		buffer_store_dwordx4 v[12:15], v8, s[0:3], 0 offen sc0 nt
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
		.amdhsa_next_free_vgpr 204
		.amdhsa_next_free_sgpr 41
		.amdhsa_accum_offset 204
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
	.set .Ltlx_addmm_glu_kernel_optimized.num_vgpr, 204
	.set .Ltlx_addmm_glu_kernel_optimized.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 41
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
    .sgpr_count:     41
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized.kd
    .uses_dynamic_stack: false
    .vgpr_count:     204
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
