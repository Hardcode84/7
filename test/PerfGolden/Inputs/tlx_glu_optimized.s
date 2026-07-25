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
		v_add3_u32 v1, 8, v1, s1
		v_cndmask_b32_e32 v15, v15, v16, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		s_add_i32 s28, s28, 1
		v_mov_b32_e32 v16, s12
		v_mov_b32_e32 v17, s28
		v_cndmask_b32_e64 v16, v16, v17, s[26:27]
		v_cvt_f32_u32_e32 v17, v16
		v_rcp_iflag_f32_e32 v17, v17
		v_xad_u32 v18, v16, -1, 1
		v_mul_f32_e32 v17, v2, v17
		v_cvt_u32_f32_e32 v17, v17
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
		v_add3_u32 v21, 16, v11, s1
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_add_u32_e32 v19, v15, v18
		v_cmp_ge_u32_e64 vcc, v15, v16
		v_add3_u32 v22, 32, v11, s1
		v_add3_u32 v23, 48, v11, s1
		v_cndmask_b32_e32 v15, v15, v19, vcc
		v_xad_u32 v19, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v1, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v24, v1, -1, 1
		v_add3_u32 v11, 64, v11, s1
		v_cndmask_b32_e32 v1, v1, v24, vcc
		v_mul_hi_u32 v24, v1, v17
		v_mul_lo_u32 v24, v24, v16
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v1, 1, v24, v1
		v_add_u32_e32 v24, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add_u32_e32 v12, s1, v12
		v_add_u32_e32 v13, s1, v13
		v_cndmask_b32_e32 v1, v1, v24, vcc
		v_add_u32_e32 v24, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add_u32_e32 v14, s1, v14
		v_cndmask_b32_e64 v15, v15, v19, s[20:21]
		v_cndmask_b32_e32 v1, v1, v24, vcc
		v_xad_u32 v19, v1, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v24, v20, -1, 1
		v_cndmask_b32_e64 v1, v1, v19, s[26:27]
		v_cndmask_b32_e32 v19, v20, v24, vcc
		v_mul_hi_u32 v20, v19, v17
		v_mul_lo_u32 v20, v20, v16
		v_xor_b32_e32 v20, -1, v20
		v_add3_u32 v19, 1, v20, v19
		v_cmp_ge_u32_e64 vcc, v19, v16
		v_add_u32_e32 v20, v19, v18
		v_and_b32_e32 v24, 1, v5
		v_cndmask_b32_e32 v19, v19, v20, vcc
		v_cmp_ge_u32_e64 vcc, v19, v16
		v_add_u32_e32 v20, v19, v18
		v_and_b32_e32 v7, 1, v7
		v_cndmask_b32_e32 v19, v19, v20, vcc
		v_xad_u32 v20, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v25, v21, -1, 1
		v_cndmask_b32_e64 v19, v19, v20, s[20:21]
		v_cndmask_b32_e32 v20, v21, v25, vcc
		v_mul_hi_u32 v21, v20, v17
		v_mul_lo_u32 v21, v21, v16
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v20, 1, v21, v20
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v21, v20, v18
		v_lshlrev_b32_e32 v25, 3, v8
		v_cndmask_b32_e32 v20, v20, v21, vcc
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v21, v20, v18
		v_mov_b32_e32 v26, 8
		v_mul_lo_u32 v26, v26, v10
		v_cndmask_b32_e32 v10, v20, v21, vcc
		v_xad_u32 v20, v10, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v21, v22, -1, 1
		v_cndmask_b32_e64 v10, v10, v20, s[26:27]
		v_cndmask_b32_e32 v20, v22, v21, vcc
		v_mul_hi_u32 v21, v20, v17
		v_mul_lo_u32 v21, v21, v16
		v_xor_b32_e32 v21, -1, v21
		v_add3_u32 v20, 1, v21, v20
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v21, v20, v18
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v4
		v_cndmask_b32_e32 v4, v20, v21, vcc
		v_cmp_ge_u32_e64 vcc, v4, v16
		v_add_u32_e32 v20, v4, v18
		v_mul_lo_u32 v21, s15, v1
		v_cndmask_b32_e32 v4, v4, v20, vcc
		v_xad_u32 v20, v4, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v27, v23, -1, 1
		v_cndmask_b32_e64 v4, v4, v20, s[20:21]
		v_cndmask_b32_e32 v20, v23, v27, vcc
		v_mul_hi_u32 v23, v20, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v20, 1, v23, v20
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v23, v20, v18
		v_and_b32_e32 v27, 1, v0
		v_cndmask_b32_e32 v20, v20, v23, vcc
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v23, v20, v18
		v_mul_lo_u32 v28, s15, v15
		v_cndmask_b32_e32 v20, v20, v23, vcc
		v_xad_u32 v23, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v11, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v29, v11, -1, 1
		v_cndmask_b32_e64 v20, v20, v23, s[26:27]
		v_cndmask_b32_e32 v11, v11, v29, vcc
		v_mul_hi_u32 v23, v11, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v11, 1, v23, v11
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v23, v11, v18
		s_mov_b32 s30, 0x7fffffff
		v_cndmask_b32_e32 v11, v11, v23, vcc
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v23, v11, v18
		v_lshrrev_b32_e32 v29, 2, v0
		v_cndmask_b32_e32 v11, v11, v23, vcc
		v_xad_u32 v23, v11, -1, 1
		v_cmp_lt_i32_e64 vcc, v12, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v30, v12, -1, 1
		v_cndmask_b32_e64 v11, v11, v23, s[20:21]
		v_cndmask_b32_e32 v12, v12, v30, vcc
		v_mul_hi_u32 v23, v12, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v12, 1, v23, v12
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v23, v12, v18
		v_lshrrev_b32_e32 v30, 1, v0
		v_cndmask_b32_e32 v12, v12, v23, vcc
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v23, v12, v18
		v_and_b32_e32 v31, 1, v0
		v_cndmask_b32_e32 v12, v12, v23, vcc
		v_xad_u32 v23, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v32, v13, -1, 1
		v_cndmask_b32_e64 v12, v12, v23, s[26:27]
		v_cndmask_b32_e32 v13, v13, v32, vcc
		v_mul_hi_u32 v23, v13, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v13, 1, v23, v13
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v23, v13, v18
		v_mov_b32_e32 v32, s13
		v_cndmask_b32_e32 v13, v13, v23, vcc
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v23, v13, v18
		s_xor_b32 s1, s13, -1
		v_cndmask_b32_e32 v13, v13, v23, vcc
		v_xad_u32 v23, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v33, v14, -1, 1
		v_cndmask_b32_e64 v13, v13, v23, s[20:21]
		v_cndmask_b32_e32 v14, v14, v33, vcc
		v_mul_hi_u32 v17, v14, v17
		v_mul_lo_u32 v17, v17, v16
		v_xor_b32_e32 v17, -1, v17
		v_add3_u32 v14, 1, v17, v14
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v17, v14, v18
		v_and_b32_e32 v23, 31, v0
		v_cndmask_b32_e32 v14, v14, v17, vcc
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v16, v14, v18
		s_mul_i32 s0, s0, 0x100
		v_cndmask_b32_e32 v14, v14, v16, vcc
		v_xad_u32 v16, v14, -1, 1
		v_mad_u32_u24 v17, v23, 8, s0
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v18, v17, -1, 1
		v_cndmask_b32_e64 v14, v14, v16, s[26:27]
		v_cndmask_b32_e32 v16, v17, v18, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		s_add_i32 s0, s1, 1
		v_mov_b32_e32 v17, s0
		v_cndmask_b32_e64 v17, v32, v17, s[12:13]
		v_cvt_f32_u32_e32 v18, v17
		v_rcp_iflag_f32_e32 v18, v18
		v_xad_u32 v23, v17, -1, 1
		v_mul_f32_e32 v2, v2, v18
		v_cvt_u32_f32_e32 v2, v2
		v_mul_lo_u32 v18, v23, v2
		v_mul_hi_u32 v18, v2, v18
		v_add_u32_e32 v2, v2, v18
		v_mul_hi_u32 v2, v16, v2
		v_mul_lo_u32 v2, v2, v17
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v16
		v_cmp_ge_u32_e64 vcc, v2, v17
		v_add_u32_e32 v16, v2, v23
		s_mov_b32 s0, 63
		v_cndmask_b32_e32 v2, v2, v16, vcc
		v_cmp_ge_u32_e64 vcc, v2, v17
		v_add_u32_e32 v16, v2, v23
		s_add_i32 s1, s14, 63
		v_cndmask_b32_e32 v2, v2, v16, vcc
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s0, s0, 0
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v31
		v_and_b32_e32 v17, 1, v30
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v17
		v_and_b32_e32 v17, 1, v29
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v17
		v_bitop3_b32 v16, v16, v18, v23 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s14
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v17, 4, v27
		v_lshl_add_u32 v18, v28, 1, v17
		v_and_b32_e32 v23, 1, v29
		v_lshlrev_b32_e32 v23, 6, v23
		v_and_b32_e32 v27, 1, v30
		v_lshlrev_b32_e32 v27, 5, v27
		v_add3_u32 v18, v18, v23, v27
		v_mov_b32_e32 v28, 0x80000000
		v_cndmask_b32_e32 v30, v28, v18, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		v_xad_u32 v31, v2, -1, 1
		buffer_load_dwordx4 v30, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v2, v2, v31, s[20:21]
		v_lshl_add_u32 v21, v21, 1, v17
		v_add3_u32 v21, v21, v23, v27
		v_cndmask_b32_e32 v30, v28, v21, vcc
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s0, s1, s0
		buffer_load_dwordx4 v30, s[28:31], 0 offen lds
		v_bitop3_b32 v30, v22, v6, v9 bitop3:0x96
		v_xor_b32_e32 v30, v30, v26
		v_bitop3_b32 v31, 4, v22, v6 bitop3:0x96
		v_bitop3_b32 v32, 32, v22, v6 bitop3:0x96
		v_bitop3_b32 v32, v32, v9, v26 bitop3:0x96
		v_cmp_lt_i32_e64 s[4:5], v30, s14
		v_cmp_lt_i32_e64 vcc, v32, s14
		v_lshlrev_b32_e32 v33, 1, v2
		v_lshlrev_b32_e32 v34, 1, v7
		v_add3_u32 v25, v25, v34, v24
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v25, v3, 4, v25
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v34, s17, v25
		v_lshl_add_u32 v34, v34, 1, v33
		v_cndmask_b32_e64 v35, v28, v34, s[4:5]
		s_add_i32 m0, m0, 0xa4e0
		s_ashr_i32 s0, s0, 6
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		v_add_u32_e32 v35, 4, v25
		v_mul_lo_u32 v35, s17, v35
		v_lshl_add_u32 v35, v35, 1, v33
		v_cndmask_b32_e64 v36, v28, v35, s[4:5]
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v6, 36, v22, v6 bitop3:0x96
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_add_u32_e32 v22, 32, v25
		v_mul_lo_u32 v22, s17, v22
		v_lshl_add_u32 v22, v22, 1, v33
		v_cndmask_b32_e32 v36, v28, v22, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v31, v31, v9, v26 bitop3:0x96
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_add_u32_e32 v25, 36, v25
		v_mul_lo_u32 v25, s17, v25
		v_lshl_add_u32 v25, v25, 1, v33
		v_cndmask_b32_e32 v36, v28, v25, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v6, v6, v9, v26 bitop3:0x96
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		s_add_i32 s1, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v16, s1
		v_add_u32_e32 v9, 0x80, v18
		s_lshl_b32 s4, s17, 7
		v_cndmask_b32_e32 v9, v28, v9, vcc
		s_add_i32 m0, m0, 0xffff1920
		v_and_b32_e32 v26, 3, v0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_add_u32_e32 v9, 0x80, v21
		v_cndmask_b32_e32 v9, v28, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[12:13], v30, s1
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v32, s1
		v_add_u32_e32 v9, s4, v34
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v9, v28, v9, s[12:13]
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_add_u32_e32 v9, s4, v35
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v9, v28, v9, s[12:13]
		v_add_u32_e32 v36, s4, v22
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_cndmask_b32_e32 v9, v28, v36, vcc
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v36, s4, v25
		v_cndmask_b32_e32 v36, v28, v36, vcc
		v_and_b32_e32 v37, 63, v0
		v_add_u32_e32 v18, 0x100, v18
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_add_u32_e32 v9, 0x100, v21
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s1, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v16, s1
		s_lshl_b32 s4, s17, 8
		v_cmp_lt_i32_e64 s[12:13], v30, s1
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_cndmask_b32_e32 v18, v28, v18, vcc
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v9, v28, v9, vcc
		v_cmp_lt_i32_e64 vcc, v32, s1
		v_add_u32_e32 v21, s4, v34
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v18, v28, v21, s[12:13]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v21, s4, v35
		v_cndmask_b32_e64 v21, v28, v21, s[12:13]
		v_add_u32_e32 v36, s4, v22
		v_cndmask_b32_e32 v36, v28, v36, vcc
		v_add_u32_e32 v38, s4, v25
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_cndmask_b32_e32 v9, v28, v38, vcc
		s_add_i32 m0, m0, 0x128e0
		v_lshlrev_b32_e32 v38, 7, v8
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v18, 4, v37
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v39, 4, v18
		v_and_b32_e32 v40, 15, v37
		v_lshlrev_b32_e32 v26, 3, v26
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		v_mov_b32_e32 v21, 0x420
		v_mul_lo_u32 v21, v21, v40
		s_add_i32 m0, m0, 0x2100
		v_add3_u32 v21, v38, v39, v21
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_and_b32_e32 v5, 3, v5
		s_add_i32 m0, m0, 0x2100
		v_lshl_add_u32 v36, v5, 5, v26
		v_lshlrev_b32_e32 v38, 9, v3
		v_and_b32_e32 v29, 7, v29
		v_add_u32_e32 v26, 0x10000, v26
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[40:43], v21
		ds_read_b128 v[44:47], v21 offset:64
		ds_read_b128 v[48:51], v21 offset:256
		ds_read_b128 v[52:55], v21 offset:320
		ds_read_b128 v[56:59], v21 offset:512
		ds_read_b128 v[60:63], v21 offset:576
		ds_read_b128 v[64:67], v21 offset:768
		ds_read_b128 v[68:71], v21 offset:832
		v_mov_b32_e32 v9, 0x420
		v_mul_lo_u32 v9, v9, v29
		v_add3_u32 v29, v36, v38, v9
		ds_read_b64_tr_b16 v[72:73], v29 offset:50656
		ds_read_b64_tr_b16 v[74:75], v29 offset:59104
		v_lshl_add_u32 v5, v5, 5, v26
		v_add3_u32 v5, v5, v38, v9
		ds_read_b64_tr_b16 v[76:77], v5 offset:2016
		ds_read_b64_tr_b16 v[78:79], v5 offset:10464
		ds_read_b64_tr_b16 v[80:81], v29 offset:50784
		ds_read_b64_tr_b16 v[82:83], v29 offset:59232
		ds_read_b64_tr_b16 v[84:85], v5 offset:2144
		ds_read_b64_tr_b16 v[86:87], v5 offset:10592
		ds_read_b64_tr_b16 v[88:89], v29 offset:50912
		ds_read_b64_tr_b16 v[90:91], v29 offset:59360
		ds_read_b64_tr_b16 v[92:93], v5 offset:2272
		ds_read_b64_tr_b16 v[94:95], v5 offset:10720
		ds_read_b64_tr_b16 v[96:97], v29 offset:51040
		ds_read_b64_tr_b16 v[98:99], v29 offset:59488
		ds_read_b64_tr_b16 v[100:101], v5 offset:2400
		ds_read_b64_tr_b16 v[102:103], v5 offset:10848
		s_add_i32 s1, s0, -3
		v_cmp_eq_u32_e64 s[4:5], v8, s16
		v_cmp_ne_u32_e64 vcc, v8, s16
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[38:39], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[38:39]
		s_setprio 0
		v_add3_u32 v5, v17, v23, v27
		v_add_u32_e32 v5, 0x180, v5
		s_lshl_b32 s12, s15, 1
		v_mul_lo_u32 v8, s12, v15
		v_add_u32_e32 v9, v5, v8
		v_mul_lo_u32 v1, s12, v1
		v_add_u32_e32 v8, v5, v1
		s_mul_i32 s12, 0x180, s17
		s_cmp_lt_i32 0, s1
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
		s_mov_b32 s13, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		s_cmp_ge_u32 s13, 2
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		s_cselect_b32 s15, 1, 0
		s_add_i32 s20, s13, -2
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		s_add_i32 s21, s13, 1
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s15, s20, s21
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s16, 3
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		s_mul_i32 s23, s23, 64
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
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
		s_setprio 1
		s_barrier
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s14, s23
		v_cmp_lt_i32_e64 vcc, v16, s23
		v_cmp_lt_i32_e64 s[32:33], v31, s23
		s_lshl_b32 s34, s16, 7
		v_cndmask_b32_e32 v1, v28, v9, vcc
		s_mul_i32 s35, 0x4200, s13
		v_cndmask_b32_e32 v5, v28, v8, vcc
		s_add_i32 s35, s3, s35
		v_cmp_lt_i32_e64 s[36:37], v30, s23
		s_mov_b32 m0, s35
		s_mul_i32 s35, s17, s16
		buffer_load_dwordx4 v1, s[28:31], s34 offen lds
		s_lshl_b32 s35, s35, 7
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s35, s12, s35
		buffer_load_dwordx4 v5, s[28:31], s34 offen lds
		v_add_u32_e32 v1, s35, v34
		v_cndmask_b32_e64 v1, v28, v1, s[36:37]
		v_cmp_lt_i32_e64 s[36:37], v32, s23
		s_mul_i32 s13, 0x8400, s13
		v_add_u32_e32 v5, s35, v35
		s_add_i32 s13, s3, s13
		v_cndmask_b32_e64 v5, v28, v5, s[32:33]
		s_add_i32 m0, s13, 0xc5e0
		v_add_u32_e32 v15, s35, v22
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_cndmask_b32_e64 v1, v28, v15, s[36:37]
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 vcc, v6, s23
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add_u32_e32 v5, s35, v25
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s13, 0x8400, s15
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_cndmask_b32_e32 v1, v28, v5, vcc
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v5, s13, v29
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_barrier
		s_mul_i32 s15, 0x4200, s15
		v_add_u32_e32 v1, s15, v21
		s_waitcnt vmcnt(6)
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:320
		ds_read_b128 v[56:59], v1 offset:512
		ds_read_b128 v[60:63], v1 offset:576
		ds_read_b128 v[64:67], v1 offset:768
		ds_read_b128 v[68:71], v1 offset:832
		ds_read_b64_tr_b16 v[72:73], v5 offset:50656
		ds_read_b64_tr_b16 v[74:75], v5 offset:59104
		s_add_i32 s13, s13, 0x10000
		v_add_u32_e32 v1, s13, v29
		ds_read_b64_tr_b16 v[76:77], v1 offset:2016
		ds_read_b64_tr_b16 v[78:79], v1 offset:10464
		ds_read_b64_tr_b16 v[80:81], v5 offset:50784
		ds_read_b64_tr_b16 v[82:83], v5 offset:59232
		ds_read_b64_tr_b16 v[84:85], v1 offset:2144
		ds_read_b64_tr_b16 v[86:87], v1 offset:10592
		ds_read_b64_tr_b16 v[88:89], v5 offset:50912
		ds_read_b64_tr_b16 v[90:91], v5 offset:59360
		ds_read_b64_tr_b16 v[92:93], v1 offset:2272
		ds_read_b64_tr_b16 v[94:95], v1 offset:10720
		ds_read_b64_tr_b16 v[96:97], v5 offset:51040
		ds_read_b64_tr_b16 v[98:99], v5 offset:59488
		ds_read_b64_tr_b16 v[100:101], v1 offset:2400
		ds_read_b64_tr_b16 v[102:103], v1 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s13, s20, s21
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s1
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[38:39], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[38:39]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s30
		s_mov_b32 s15, s31
		buffer_load_dwordx4 v[168:171], v33, s[12:15], 0 offen
		v_mul_lo_u32 v1, s18, v19
		v_add_lshl_u32 v1, v2, v1, 1
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s30
		s_mov_b32 s7, s31
		buffer_load_dwordx4 v[32:35], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v10
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[172:175], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v4
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[176:179], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v20
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[180:183], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v11
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[184:187], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v12
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[188:191], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v13
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[192:195], v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v14
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_dwordx4 v[196:199], v1, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
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
		s_add_i32 s1, s0, -2
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s1, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s1, s4, s1
		s_mul_hi_u32 s3, s1, 0xaaaaaaab
		s_cselect_b32 s4, 1, 0
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s1, s1, s3
		s_xor_b32 s3, s1, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s1, s3, s1
		s_waitcnt vmcnt(9)
		s_barrier
		s_mul_i32 s3, 0x4200, s1
		v_add_u32_e32 v1, s3, v21
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:320
		ds_read_b128 v[56:59], v1 offset:512
		ds_read_b128 v[60:63], v1 offset:576
		ds_read_b128 v[64:67], v1 offset:768
		ds_read_b128 v[68:71], v1 offset:832
		s_mul_i32 s1, 0x8400, s1
		v_add_u32_e32 v1, s1, v29
		ds_read_b64_tr_b16 v[72:73], v1 offset:50656
		ds_read_b64_tr_b16 v[74:75], v1 offset:59104
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v5, s1, v29
		ds_read_b64_tr_b16 v[76:77], v5 offset:2016
		ds_read_b64_tr_b16 v[78:79], v5 offset:10464
		ds_read_b64_tr_b16 v[80:81], v1 offset:50784
		ds_read_b64_tr_b16 v[82:83], v1 offset:59232
		ds_read_b64_tr_b16 v[84:85], v5 offset:2144
		ds_read_b64_tr_b16 v[86:87], v5 offset:10592
		ds_read_b64_tr_b16 v[88:89], v1 offset:50912
		ds_read_b64_tr_b16 v[90:91], v1 offset:59360
		ds_read_b64_tr_b16 v[92:93], v5 offset:2272
		ds_read_b64_tr_b16 v[94:95], v5 offset:10720
		ds_read_b64_tr_b16 v[96:97], v1 offset:51040
		ds_read_b64_tr_b16 v[98:99], v1 offset:59488
		ds_read_b64_tr_b16 v[100:101], v5 offset:2400
		ds_read_b64_tr_b16 v[102:103], v5 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		s_add_i32 s0, s0, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s3, s0, -1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s3, s0
		s_mul_hi_u32 s1, s0, 0xaaaaaaab
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		s_cselect_b32 s3, 1, 0
		s_lshr_b32 s1, s1, 1
		s_mul_i32 s1, s1, 3
		s_xor_b32 s1, s1, -1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[40:43], v[116:119]
		s_add_i32 s1, s1, 1
		s_add_i32 s0, s0, s1
		s_xor_b32 s1, s0, -1
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[48:51], v[132:135]
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s0, s1, s0
		s_mul_i32 s1, 0x4200, s0
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_add_u32_e32 v1, s1, v21
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[44:47], v[116:119]
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
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:320
		ds_read_b128 v[56:59], v1 offset:512
		ds_read_b128 v[60:63], v1 offset:576
		ds_read_b128 v[64:67], v1 offset:768
		ds_read_b128 v[68:71], v1 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v1, s0, v29
		ds_read_b64_tr_b16 v[72:73], v1 offset:50656
		ds_read_b64_tr_b16 v[74:75], v1 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v5, s0, v29
		ds_read_b64_tr_b16 v[28:29], v5 offset:2016
		ds_read_b64_tr_b16 v[30:31], v5 offset:10464
		ds_read_b64_tr_b16 v[76:77], v1 offset:50784
		ds_read_b64_tr_b16 v[78:79], v1 offset:59232
		ds_read_b64_tr_b16 v[80:81], v5 offset:2144
		ds_read_b64_tr_b16 v[82:83], v5 offset:10592
		ds_read_b64_tr_b16 v[84:85], v1 offset:50912
		ds_read_b64_tr_b16 v[86:87], v1 offset:59360
		ds_read_b64_tr_b16 v[88:89], v5 offset:2272
		ds_read_b64_tr_b16 v[90:91], v5 offset:10720
		ds_read_b64_tr_b16 v[92:93], v1 offset:51040
		ds_read_b64_tr_b16 v[94:95], v1 offset:59488
		ds_read_b64_tr_b16 v[96:97], v5 offset:2400
		ds_read_b64_tr_b16 v[98:99], v5 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[40:43], v[116:119]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[28:31], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[28:31], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[28:31], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		v_lshlrev_b32_e32 v1, 3, v7
		v_lshlrev_b32_e32 v5, 2, v24
		v_lshlrev_b32_e32 v3, 1, v3
		v_xor_b32_e32 v0, v0, v3
		v_bitop3_b32 v0, v1, v5, v0 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v0
		ds_write_b128 v1, v[104:107]
		v_xor_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[108:111] offset:8192
		ds_write_b128 v1, v[112:115] offset:16384
		ds_write_b128 v0, v[116:119] offset:24576
		v_and_b32_e32 v3, 1, v18
		v_lshrrev_b32_e32 v5, 3, v37
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v6, 13, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v3, v3, 14, v6
		v_lshrrev_b32_e32 v6, 2, v37
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v7, 3, v6
		v_lshrrev_b32_e32 v8, 1, v37
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v9, 2, v8
		v_lshrrev_b32_e32 v15, 5, v37
		v_lshl_add_u32 v15, s2, 1, v15
		v_lshl_add_u32 v6, v6, 7, v15
		v_lshl_add_u32 v6, v8, 6, v6
		v_and_b32_e32 v8, 1, v37
		v_lshl_add_u32 v6, v8, 5, v6
		v_lshlrev_b32_e32 v8, 1, v8
		v_bitop3_b32 v6, v9, v6, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v7, v6 bitop3:0x96
		v_lshl_add_u32 v3, v5, 4, v3
		ds_read_b128 v[24:27], v3
		ds_read_b128 v[28:31], v3 offset:256
		ds_read_b128 v[36:39], v3 offset:4096
		ds_read_b128 v[40:43], v3 offset:4352
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v6, v168
		v_cvt_f32_f16_sdwa v7, v168 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v8, v169
		v_cvt_f32_f16_sdwa v9, v169 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[120:123]
		ds_write_b128 v0, v[124:127] offset:8192
		ds_write_b128 v1, v[128:131] offset:16384
		ds_write_b128 v0, v[132:135] offset:24576
		v_cvt_f32_f16_e32 v16, v170
		v_cvt_f32_f16_sdwa v17, v170 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v22, v171
		v_cvt_f32_f16_sdwa v23, v171 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v3
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:4096
		ds_read_b128 v[56:59], v3 offset:4352
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v60, v32
		v_cvt_f32_f16_sdwa v61, v32 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v62, v33
		v_cvt_f32_f16_sdwa v63, v33 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[136:139]
		ds_write_b128 v0, v[140:143] offset:8192
		ds_write_b128 v1, v[144:147] offset:16384
		ds_write_b128 v0, v[148:151] offset:24576
		v_cvt_f32_f16_e32 v32, v34
		v_cvt_f32_f16_sdwa v33, v34 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v35
		v_cvt_f32_f16_sdwa v65, v35 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v3
		ds_read_b128 v[72:75], v3 offset:256
		ds_read_b128 v[76:79], v3 offset:4096
		ds_read_b128 v[80:83], v3 offset:4352
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v34, v172
		v_cvt_f32_f16_sdwa v35, v172 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v66, v173
		v_cvt_f32_f16_sdwa v67, v173 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[152:155]
		ds_write_b128 v0, v[156:159] offset:8192
		ds_write_b128 v1, v[160:163] offset:16384
		ds_write_b128 v0, v[164:167] offset:24576
		v_cvt_f32_f16_e32 v0, v174
		v_cvt_f32_f16_sdwa v1, v174 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v84, v175
		v_cvt_f32_f16_sdwa v85, v175 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[88:91], v3
		ds_read_b128 v[92:95], v3 offset:256
		ds_read_b128 v[96:99], v3 offset:4096
		ds_read_b128 v[100:103], v3 offset:4352
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v86, v176
		v_cvt_f32_f16_sdwa v87, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v177
		v_cvt_f32_f16_sdwa v105, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v106, v178
		v_cvt_f32_f16_sdwa v107, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v108, v179
		v_cvt_f32_f16_sdwa v109, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v110, v180
		v_cvt_f32_f16_sdwa v111, v180 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v112, v181
		v_cvt_f32_f16_sdwa v113, v181 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v114, v182
		v_cvt_f32_f16_sdwa v115, v182 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v116, v183
		v_cvt_f32_f16_sdwa v117, v183 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v118, v184
		v_cvt_f32_f16_sdwa v119, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v120, v185
		v_cvt_f32_f16_sdwa v121, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v122, v186
		v_cvt_f32_f16_sdwa v123, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v124, v187
		v_cvt_f32_f16_sdwa v125, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v126, v188
		v_cvt_f32_f16_sdwa v127, v188 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v128, v189
		v_cvt_f32_f16_sdwa v129, v189 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v130, v190
		v_cvt_f32_f16_sdwa v131, v190 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v132, v191
		v_cvt_f32_f16_sdwa v133, v191 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v134, v192
		v_cvt_f32_f16_sdwa v135, v192 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v136, v193
		v_cvt_f32_f16_sdwa v137, v193 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v138, v194
		v_cvt_f32_f16_sdwa v139, v194 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v140, v195
		v_cvt_f32_f16_sdwa v141, v195 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v142, v196
		v_cvt_f32_f16_sdwa v143, v196 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v144, v197
		v_cvt_f32_f16_sdwa v145, v197 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v146, v198
		v_cvt_f32_f16_sdwa v147, v198 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v148, v199
		v_cvt_f32_f16_sdwa v149, v199 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[24:25], v[24:25], v[6:7]
		v_pk_add_f32 v[26:27], v[26:27], v[8:9]
		v_pk_add_f32 v[28:29], v[28:29], v[16:17]
		v_pk_add_f32 v[30:31], v[30:31], v[22:23]
		v_pk_add_f32 v[36:37], v[36:37], v[6:7]
		v_pk_add_f32 v[38:39], v[38:39], v[8:9]
		v_pk_add_f32 v[40:41], v[40:41], v[16:17]
		v_pk_add_f32 v[42:43], v[42:43], v[22:23]
		v_pk_add_f32 v[44:45], v[44:45], v[6:7]
		v_pk_add_f32 v[46:47], v[46:47], v[8:9]
		v_pk_add_f32 v[48:49], v[48:49], v[16:17]
		v_pk_add_f32 v[50:51], v[50:51], v[22:23]
		v_pk_add_f32 v[52:53], v[52:53], v[6:7]
		v_pk_add_f32 v[54:55], v[54:55], v[8:9]
		v_pk_add_f32 v[56:57], v[56:57], v[16:17]
		v_pk_add_f32 v[58:59], v[58:59], v[22:23]
		v_pk_add_f32 v[68:69], v[68:69], v[6:7]
		v_pk_add_f32 v[70:71], v[70:71], v[8:9]
		v_pk_add_f32 v[72:73], v[72:73], v[16:17]
		v_pk_add_f32 v[74:75], v[74:75], v[22:23]
		v_pk_add_f32 v[76:77], v[76:77], v[6:7]
		v_pk_add_f32 v[78:79], v[78:79], v[8:9]
		v_pk_add_f32 v[80:81], v[80:81], v[16:17]
		v_pk_add_f32 v[82:83], v[82:83], v[22:23]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[88:89], v[88:89], v[6:7]
		v_pk_add_f32 v[90:91], v[90:91], v[8:9]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[92:93], v[92:93], v[16:17]
		v_pk_add_f32 v[94:95], v[94:95], v[22:23]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[6:7], v[96:97], v[6:7]
		v_pk_add_f32 v[8:9], v[98:99], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[16:17], v[100:101], v[16:17]
		v_pk_add_f32 v[22:23], v[102:103], v[22:23]
		v_pk_fma_f32 v[96:97], v[24:25], v[60:61], v[24:25]
		v_pk_fma_f32 v[24:25], v[26:27], v[62:63], v[26:27]
		v_pk_fma_f32 v[26:27], v[28:29], v[32:33], v[28:29]
		v_pk_fma_f32 v[28:29], v[30:31], v[64:65], v[30:31]
		v_pk_fma_f32 v[30:31], v[36:37], v[34:35], v[36:37]
		v_pk_fma_f32 v[32:33], v[38:39], v[66:67], v[38:39]
		v_pk_fma_f32 v[34:35], v[40:41], v[0:1], v[40:41]
		v_pk_fma_f32 v[0:1], v[42:43], v[84:85], v[42:43]
		v_pk_fma_f32 v[36:37], v[44:45], v[86:87], v[44:45]
		v_pk_fma_f32 v[38:39], v[46:47], v[104:105], v[46:47]
		v_pk_fma_f32 v[40:41], v[48:49], v[106:107], v[48:49]
		v_pk_fma_f32 v[42:43], v[50:51], v[108:109], v[50:51]
		v_pk_fma_f32 v[44:45], v[52:53], v[110:111], v[52:53]
		v_pk_fma_f32 v[46:47], v[54:55], v[112:113], v[54:55]
		v_pk_fma_f32 v[48:49], v[56:57], v[114:115], v[56:57]
		v_pk_fma_f32 v[50:51], v[58:59], v[116:117], v[58:59]
		v_pk_fma_f32 v[52:53], v[68:69], v[118:119], v[68:69]
		v_pk_fma_f32 v[54:55], v[70:71], v[120:121], v[70:71]
		v_pk_fma_f32 v[56:57], v[72:73], v[122:123], v[72:73]
		v_pk_fma_f32 v[58:59], v[74:75], v[124:125], v[74:75]
		v_pk_fma_f32 v[60:61], v[76:77], v[126:127], v[76:77]
		v_pk_fma_f32 v[62:63], v[78:79], v[128:129], v[78:79]
		v_pk_fma_f32 v[64:65], v[80:81], v[130:131], v[80:81]
		v_pk_fma_f32 v[66:67], v[82:83], v[132:133], v[82:83]
		v_pk_fma_f32 v[68:69], v[88:89], v[134:135], v[88:89]
		v_pk_fma_f32 v[70:71], v[90:91], v[136:137], v[90:91]
		v_pk_fma_f32 v[72:73], v[92:93], v[138:139], v[92:93]
		v_pk_fma_f32 v[74:75], v[94:95], v[140:141], v[94:95]
		v_pk_fma_f32 v[76:77], v[6:7], v[142:143], v[6:7]
		v_pk_fma_f32 v[6:7], v[8:9], v[144:145], v[8:9]
		v_pk_fma_f32 v[8:9], v[16:17], v[146:147], v[16:17]
		v_pk_fma_f32 v[16:17], v[22:23], v[148:149], v[22:23]
		v_cvt_pk_f16_f32 v80, v96, v97
		v_cvt_pk_f16_f32 v81, v24, v25
		v_cvt_pk_f16_f32 v82, v26, v27
		v_cvt_pk_f16_f32 v83, v28, v29
		v_mul_lo_u32 v3, s19, v19
		v_add_lshl_u32 v3, v2, v3, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s30
		s_mov_b32 s3, s31
		buffer_store_dwordx4 v[80:83], v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v3, s19, v10
		v_add_lshl_u32 v3, v2, v3, 1
		v_cvt_pk_f16_f32 v24, v30, v31
		v_cvt_pk_f16_f32 v25, v32, v33
		v_cvt_pk_f16_f32 v26, v34, v35
		v_cvt_pk_f16_f32 v27, v0, v1
		buffer_store_dwordx4 v[24:27], v3, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v4
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v24, v36, v37
		v_cvt_pk_f16_f32 v25, v38, v39
		v_cvt_pk_f16_f32 v26, v40, v41
		v_cvt_pk_f16_f32 v27, v42, v43
		buffer_store_dwordx4 v[24:27], v0, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v20
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v20, v44, v45
		v_cvt_pk_f16_f32 v21, v46, v47
		v_cvt_pk_f16_f32 v22, v48, v49
		v_cvt_pk_f16_f32 v23, v50, v51
		buffer_store_dwordx4 v[20:23], v0, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v11
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v20, v52, v53
		v_cvt_pk_f16_f32 v21, v54, v55
		v_cvt_pk_f16_f32 v22, v56, v57
		v_cvt_pk_f16_f32 v23, v58, v59
		buffer_store_dwordx4 v[20:23], v0, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v12
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v20, v60, v61
		v_cvt_pk_f16_f32 v21, v62, v63
		v_cvt_pk_f16_f32 v22, v64, v65
		v_cvt_pk_f16_f32 v23, v66, v67
		buffer_store_dwordx4 v[20:23], v0, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v13
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v20, v68, v69
		v_cvt_pk_f16_f32 v21, v70, v71
		v_cvt_pk_f16_f32 v22, v72, v73
		v_cvt_pk_f16_f32 v23, v74, v75
		buffer_store_dwordx4 v[20:23], v0, s[0:3], 0 offen sc0 nt
		v_mul_lo_u32 v0, s19, v14
		v_add_lshl_u32 v0, v2, v0, 1
		v_cvt_pk_f16_f32 v12, v76, v77
		v_cvt_pk_f16_f32 v13, v6, v7
		v_cvt_pk_f16_f32 v14, v8, v9
		v_cvt_pk_f16_f32 v15, v16, v17
		buffer_store_dwordx4 v[12:15], v0, s[0:3], 0 offen sc0 nt
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
		.amdhsa_next_free_vgpr 200
		.amdhsa_next_free_sgpr 40
		.amdhsa_accum_offset 200
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
	.set .Ltlx_addmm_glu_kernel_optimized.num_vgpr, 200
	.set .Ltlx_addmm_glu_kernel_optimized.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 40
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
    .sgpr_count:     40
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized.kd
    .uses_dynamic_stack: false
    .vgpr_count:     200
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
