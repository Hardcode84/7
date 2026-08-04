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
		s_add_i32 s28, s28, 1
		v_mov_b32_e32 v16, s12
		v_mov_b32_e32 v17, s28
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
		v_cmp_lt_i32_e64 vcc, v1, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v23, v1, -1, 1
		v_cndmask_b32_e32 v1, v1, v23, vcc
		v_mul_hi_u32 v23, v1, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v1, 1, v23, v1
		v_add_u32_e32 v23, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add3_u32 v24, 48, v11, s1
		v_add3_u32 v11, 64, v11, s1
		v_cndmask_b32_e32 v1, v1, v23, vcc
		v_add_u32_e32 v23, v1, v18
		v_cmp_ge_u32_e64 vcc, v1, v16
		v_add_u32_e32 v13, s1, v13
		v_cndmask_b32_e64 v15, v15, v19, s[20:21]
		v_cndmask_b32_e32 v1, v1, v23, vcc
		v_xad_u32 v19, v1, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v23, v20, -1, 1
		v_cndmask_b32_e32 v20, v20, v23, vcc
		v_mul_hi_u32 v23, v20, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v20, 1, v23, v20
		v_add_u32_e32 v23, v20, v18
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v14, s1, v14
		v_cndmask_b32_e64 v1, v1, v19, s[26:27]
		v_cndmask_b32_e32 v19, v20, v23, vcc
		v_cmp_ge_u32_e64 vcc, v19, v16
		v_add_u32_e32 v20, v19, v18
		s_mul_i32 s0, s0, 0x100
		v_cndmask_b32_e32 v19, v19, v20, vcc
		v_xad_u32 v20, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v23, v21, -1, 1
		v_cndmask_b32_e32 v21, v21, v23, vcc
		v_mul_hi_u32 v23, v21, v17
		v_mul_lo_u32 v23, v23, v16
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v21, 1, v23, v21
		v_cmp_ge_u32_e64 vcc, v21, v16
		v_cndmask_b32_e64 v19, v19, v20, s[20:21]
		v_add_u32_e32 v20, v21, v18
		v_cndmask_b32_e32 v20, v21, v20, vcc
		v_cmp_ge_u32_e64 vcc, v20, v16
		v_add_u32_e32 v21, v20, v18
		v_mul_lo_u32 v23, s15, v1
		v_cndmask_b32_e32 v20, v20, v21, vcc
		v_xad_u32 v21, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v25, v22, -1, 1
		v_cndmask_b32_e32 v22, v22, v25, vcc
		v_mul_hi_u32 v25, v22, v17
		v_mul_lo_u32 v25, v25, v16
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v22, 1, v25, v22
		v_cmp_ge_u32_e64 vcc, v22, v16
		v_cndmask_b32_e64 v20, v20, v21, s[26:27]
		v_add_u32_e32 v21, v22, v18
		v_cndmask_b32_e32 v21, v22, v21, vcc
		v_cmp_ge_u32_e64 vcc, v21, v16
		v_add_u32_e32 v22, v21, v18
		v_and_b32_e32 v25, 1, v0
		v_cndmask_b32_e32 v21, v21, v22, vcc
		v_xad_u32 v22, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v26, v24, -1, 1
		v_cndmask_b32_e32 v24, v24, v26, vcc
		v_mul_hi_u32 v26, v24, v17
		v_mul_lo_u32 v26, v26, v16
		v_xor_b32_e32 v26, -1, v26
		v_add3_u32 v24, 1, v26, v24
		v_cmp_ge_u32_e64 vcc, v24, v16
		v_cndmask_b32_e64 v21, v21, v22, s[20:21]
		v_add_u32_e32 v22, v24, v18
		v_cndmask_b32_e32 v22, v24, v22, vcc
		v_cmp_ge_u32_e64 vcc, v22, v16
		v_add_u32_e32 v24, v22, v18
		v_mul_lo_u32 v26, s15, v15
		v_cndmask_b32_e32 v22, v22, v24, vcc
		v_xad_u32 v24, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v11, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v27, v11, -1, 1
		v_cndmask_b32_e32 v11, v11, v27, vcc
		v_mul_hi_u32 v27, v11, v17
		v_mul_lo_u32 v27, v27, v16
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v11, 1, v27, v11
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_cndmask_b32_e64 v22, v22, v24, s[26:27]
		v_add_u32_e32 v24, v11, v18
		v_cndmask_b32_e32 v11, v11, v24, vcc
		v_cmp_ge_u32_e64 vcc, v11, v16
		v_add_u32_e32 v24, v11, v18
		v_mov_b32_e32 v27, s13
		v_cndmask_b32_e32 v11, v11, v24, vcc
		v_xad_u32 v24, v11, -1, 1
		v_cmp_lt_i32_e64 vcc, v12, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v28, v12, -1, 1
		v_cndmask_b32_e32 v12, v12, v28, vcc
		v_mul_hi_u32 v28, v12, v17
		v_mul_lo_u32 v28, v28, v16
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v12, 1, v28, v12
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_cndmask_b32_e64 v11, v11, v24, s[20:21]
		v_add_u32_e32 v24, v12, v18
		v_cndmask_b32_e32 v12, v12, v24, vcc
		v_cmp_ge_u32_e64 vcc, v12, v16
		v_add_u32_e32 v24, v12, v18
		s_xor_b32 s1, s13, -1
		v_cndmask_b32_e32 v12, v12, v24, vcc
		v_xad_u32 v24, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v13, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v28, v13, -1, 1
		v_cndmask_b32_e32 v13, v13, v28, vcc
		v_mul_hi_u32 v28, v13, v17
		v_mul_lo_u32 v28, v28, v16
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v13, 1, v28, v13
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_cndmask_b32_e64 v12, v12, v24, s[26:27]
		v_add_u32_e32 v24, v13, v18
		v_cndmask_b32_e32 v13, v13, v24, vcc
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v24, v13, v18
		v_and_b32_e32 v28, 31, v0
		v_cndmask_b32_e32 v13, v13, v24, vcc
		v_xad_u32 v24, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v29, v14, -1, 1
		v_cndmask_b32_e32 v14, v14, v29, vcc
		v_mul_hi_u32 v17, v14, v17
		v_mul_lo_u32 v17, v17, v16
		v_xor_b32_e32 v17, -1, v17
		v_add3_u32 v14, 1, v17, v14
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_cndmask_b32_e64 v13, v13, v24, s[20:21]
		v_add_u32_e32 v17, v14, v18
		v_cndmask_b32_e32 v14, v14, v17, vcc
		v_cmp_ge_u32_e64 vcc, v14, v16
		v_add_u32_e32 v16, v14, v18
		s_cmp_lt_i32 s13, 0
		v_cndmask_b32_e32 v14, v14, v16, vcc
		v_xad_u32 v16, v14, -1, 1
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v28
		v_add_u32_e32 v18, s0, v17
		v_cmp_lt_i32_e64 vcc, v18, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v24, v18, -1, 1
		v_cndmask_b32_e32 v18, v18, v24, vcc
		s_cselect_b32 s20, s22, s24
		s_cselect_b32 s21, s23, s25
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v24, s1
		v_cndmask_b32_e64 v24, v27, v24, s[20:21]
		v_cvt_f32_u32_e32 v27, v24
		v_rcp_iflag_f32_e32 v27, v27
		s_nop 0
		v_mul_f32_e32 v2, v2, v27
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v27, v24, -1, 1
		v_mul_lo_u32 v28, v27, v2
		v_mul_hi_u32 v28, v2, v28
		v_add_u32_e32 v2, v2, v28
		v_mul_hi_u32 v28, v18, v2
		v_mul_lo_u32 v28, v28, v24
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v18, 1, v28, v18
		v_add_u32_e32 v28, v18, v27
		v_cmp_ge_u32_e64 vcc, v18, v24
		v_add3_u32 v29, 1, v17, s0
		v_lshlrev_b32_e32 v25, 4, v25
		v_cndmask_b32_e32 v18, v18, v28, vcc
		v_add_u32_e32 v28, v18, v27
		v_cmp_ge_u32_e64 vcc, v18, v24
		v_add3_u32 v30, 2, v17, s0
		v_add3_u32 v31, 3, v17, s0
		v_cndmask_b32_e32 v18, v18, v28, vcc
		v_xad_u32 v28, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v29, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v32, v29, -1, 1
		v_cndmask_b32_e32 v29, v29, v32, vcc
		v_mul_hi_u32 v32, v29, v2
		v_mul_lo_u32 v32, v32, v24
		v_xor_b32_e32 v32, -1, v32
		v_add3_u32 v29, 1, v32, v29
		v_add_u32_e32 v32, v29, v27
		v_cmp_ge_u32_e64 vcc, v29, v24
		v_add3_u32 v33, 4, v17, s0
		v_add3_u32 v34, 5, v17, s0
		v_cndmask_b32_e32 v29, v29, v32, vcc
		v_add_u32_e32 v32, v29, v27
		v_cmp_ge_u32_e64 vcc, v29, v24
		v_add3_u32 v35, 6, v17, s0
		v_add3_u32 v17, 7, v17, s0
		v_cndmask_b32_e32 v29, v29, v32, vcc
		v_xad_u32 v32, v29, -1, 1
		v_cmp_lt_i32_e64 vcc, v30, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v36, v30, -1, 1
		v_cndmask_b32_e32 v30, v30, v36, vcc
		v_mul_hi_u32 v36, v30, v2
		v_mul_lo_u32 v36, v36, v24
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v30, 1, v36, v30
		v_add_u32_e32 v36, v30, v27
		v_cmp_ge_u32_e64 vcc, v30, v24
		v_cndmask_b32_e64 v18, v18, v28, s[12:13]
		v_cndmask_b32_e64 v28, v29, v32, s[20:21]
		v_cndmask_b32_e32 v29, v30, v36, vcc
		v_cmp_ge_u32_e64 vcc, v29, v24
		v_add_u32_e32 v30, v29, v27
		s_mov_b32 s22, 0x7fffffff
		v_cndmask_b32_e32 v29, v29, v30, vcc
		v_xad_u32 v30, v29, -1, 1
		v_cmp_lt_i32_e64 vcc, v31, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v32, v31, -1, 1
		v_cndmask_b32_e32 v31, v31, v32, vcc
		v_mul_hi_u32 v32, v31, v2
		v_mul_lo_u32 v32, v32, v24
		v_xor_b32_e32 v32, -1, v32
		v_add3_u32 v31, 1, v32, v31
		v_cmp_ge_u32_e64 vcc, v31, v24
		v_cndmask_b32_e64 v29, v29, v30, s[0:1]
		v_add_u32_e32 v30, v31, v27
		v_cndmask_b32_e32 v30, v31, v30, vcc
		v_cmp_ge_u32_e64 vcc, v30, v24
		v_add_u32_e32 v31, v30, v27
		v_lshrrev_b32_e32 v32, 2, v0
		v_cndmask_b32_e32 v30, v30, v31, vcc
		v_xad_u32 v31, v30, -1, 1
		v_cmp_lt_i32_e64 vcc, v33, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v36, v33, -1, 1
		v_cndmask_b32_e32 v33, v33, v36, vcc
		v_mul_hi_u32 v36, v33, v2
		v_mul_lo_u32 v36, v36, v24
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v33, 1, v36, v33
		v_cmp_ge_u32_e64 vcc, v33, v24
		v_cndmask_b32_e64 v30, v30, v31, s[12:13]
		v_add_u32_e32 v31, v33, v27
		v_cndmask_b32_e32 v31, v33, v31, vcc
		v_cmp_ge_u32_e64 vcc, v31, v24
		v_add_u32_e32 v33, v31, v27
		v_lshrrev_b32_e32 v36, 1, v0
		v_cndmask_b32_e32 v31, v31, v33, vcc
		v_xad_u32 v33, v31, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v37, v34, -1, 1
		v_cndmask_b32_e32 v34, v34, v37, vcc
		v_mul_hi_u32 v37, v34, v2
		v_mul_lo_u32 v37, v37, v24
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v34, 1, v37, v34
		v_cmp_ge_u32_e64 vcc, v34, v24
		v_cndmask_b32_e64 v31, v31, v33, s[0:1]
		v_add_u32_e32 v33, v34, v27
		v_cndmask_b32_e32 v33, v34, v33, vcc
		v_cmp_ge_u32_e64 vcc, v33, v24
		v_add_u32_e32 v34, v33, v27
		v_and_b32_e32 v37, 1, v0
		v_cndmask_b32_e32 v33, v33, v34, vcc
		v_xad_u32 v34, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v35, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v38, v35, -1, 1
		v_cndmask_b32_e32 v35, v35, v38, vcc
		v_mul_hi_u32 v38, v35, v2
		v_mul_lo_u32 v38, v38, v24
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v35, 1, v38, v35
		v_cmp_ge_u32_e64 vcc, v35, v24
		v_cndmask_b32_e64 v33, v33, v34, s[12:13]
		v_add_u32_e32 v34, v35, v27
		v_cndmask_b32_e32 v34, v35, v34, vcc
		v_cmp_ge_u32_e64 vcc, v34, v24
		v_add_u32_e32 v35, v34, v27
		s_mov_b32 s12, 63
		v_cndmask_b32_e32 v34, v34, v35, vcc
		v_xad_u32 v35, v34, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v38, v17, -1, 1
		v_cndmask_b32_e32 v17, v17, v38, vcc
		v_mul_hi_u32 v2, v17, v2
		v_mul_lo_u32 v2, v2, v24
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v17
		v_cmp_ge_u32_e64 vcc, v2, v24
		v_cndmask_b32_e64 v17, v34, v35, s[0:1]
		v_add_u32_e32 v34, v2, v27
		v_cndmask_b32_e32 v2, v2, v34, vcc
		v_cmp_ge_u32_e64 vcc, v2, v24
		v_add_u32_e32 v24, v2, v27
		s_add_i32 s0, s14, 63
		v_cndmask_b32_e32 v2, v2, v24, vcc
		v_xad_u32 v24, v2, -1, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, s12, 0
		v_mov_b32_e32 v27, 8
		v_mul_lo_u32 v27, v27, v37
		v_and_b32_e32 v34, 1, v36
		v_mov_b32_e32 v35, 16
		v_mul_lo_u32 v35, v35, v34
		v_and_b32_e32 v34, 1, v32
		v_mov_b32_e32 v37, 32
		v_mul_lo_u32 v37, v37, v34
		v_bitop3_b32 v27, v27, v35, v37 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v27, s14
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s2, v0
		v_lshl_add_u32 v26, v26, 1, v25
		v_and_b32_e32 v34, 1, v32
		v_lshlrev_b32_e32 v34, 6, v34
		v_and_b32_e32 v35, 1, v36
		v_lshlrev_b32_e32 v35, 5, v35
		v_add3_u32 v26, v26, v34, v35
		v_mov_b32_e32 v36, 0x80000000
		v_cndmask_b32_e32 v37, v36, v26, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		v_cndmask_b32_e64 v14, v14, v16, s[26:27]
		buffer_load_dwordx4 v37, s[20:23], 0 offen lds
		v_lshl_add_u32 v16, v23, 1, v25
		v_add3_u32 v16, v16, v34, v35
		v_cndmask_b32_e32 v23, v36, v16, vcc
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s0, s0, s1
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		v_mov_b32_e32 v23, 16
		v_mul_lo_u32 v23, v23, v4
		v_bitop3_b32 v4, v23, v6, v9 bitop3:0x96
		v_mov_b32_e32 v37, 8
		v_mul_lo_u32 v37, v37, v10
		v_xor_b32_e32 v4, v4, v37
		v_bitop3_b32 v10, 4, v23, v6 bitop3:0x96
		v_bitop3_b32 v38, 32, v23, v6 bitop3:0x96
		v_bitop3_b32 v38, v38, v9, v37 bitop3:0x96
		v_bitop3_b32 v6, 36, v23, v6 bitop3:0x96
		v_cmp_lt_i32_e64 s[4:5], v4, s14
		v_cmp_lt_i32_e64 vcc, v38, s14
		v_lshlrev_b32_e32 v23, 1, v18
		v_lshlrev_b32_e32 v39, 3, v8
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v40, 1, v7
		v_and_b32_e32 v41, 1, v5
		v_add3_u32 v39, v39, v40, v41
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v39, v3, 4, v39
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v40, s17, v39
		v_lshl_add_u32 v40, v40, 1, v23
		v_cndmask_b32_e64 v42, v36, v40, s[4:5]
		s_add_i32 m0, m0, 0xa4e0
		v_cndmask_b32_e64 v2, v2, v24, s[24:25]
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		v_add_u32_e32 v24, 4, v39
		v_mul_lo_u32 v24, s17, v24
		v_lshl_add_u32 v24, v24, 1, v23
		v_cndmask_b32_e64 v42, v36, v24, s[4:5]
		s_add_i32 m0, m0, 0x2100
		s_ashr_i32 s0, s0, 6
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		v_add_u32_e32 v42, 32, v39
		v_mul_lo_u32 v42, s17, v42
		v_lshl_add_u32 v42, v42, 1, v23
		v_cndmask_b32_e32 v43, v36, v42, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v10, v10, v9, v37 bitop3:0x96
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		v_add_u32_e32 v39, 36, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshl_add_u32 v39, v39, 1, v23
		v_cndmask_b32_e32 v43, v36, v39, vcc
		s_add_i32 m0, m0, 0x2100
		v_bitop3_b32 v6, v6, v9, v37 bitop3:0x96
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		s_add_i32 s1, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v27, s1
		v_add_u32_e32 v9, 0x80, v26
		s_lshl_b32 s4, s17, 7
		v_cndmask_b32_e32 v9, v36, v9, vcc
		s_add_i32 m0, m0, 0xffff1920
		v_and_b32_e32 v37, 3, v0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_add_u32_e32 v9, 0x80, v16
		v_cndmask_b32_e32 v9, v36, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[12:13], v4, s1
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v38, s1
		v_add_u32_e32 v9, s4, v40
		s_add_i32 m0, m0, 0xe6e0
		v_cndmask_b32_e64 v9, v36, v9, s[12:13]
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_add_u32_e32 v9, s4, v24
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v9, v36, v9, s[12:13]
		v_add_u32_e32 v26, 0x100, v26
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_add_u32_e32 v9, s4, v42
		v_cndmask_b32_e32 v9, v36, v9, vcc
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v43, s4, v39
		v_cndmask_b32_e32 v43, v36, v43, vcc
		v_add_u32_e32 v16, 0x100, v16
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v9, 3, v37
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v37, 63, v0
		v_and_b32_e32 v5, 3, v5
		v_and_b32_e32 v32, 7, v32
		s_add_i32 s1, s14, 0xffffff80
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v27, s1
		s_lshl_b32 s4, s17, 8
		s_add_i32 m0, m0, 0xfffed720
		v_cndmask_b32_e32 v26, v36, v26, vcc
		v_cndmask_b32_e32 v16, v36, v16, vcc
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v38, s1
		s_add_i32 m0, m0, 0x2100
		v_cmp_lt_i32_e64 s[12:13], v4, s1
		v_mov_b32_e32 v26, 0x420
		v_mul_lo_u32 v26, v26, v32
		v_cmp_eq_u32_e64 s[24:25], v8, s16
		v_add_u32_e32 v32, s4, v40
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_cndmask_b32_e64 v16, v36, v32, s[12:13]
		s_add_i32 m0, m0, 0x128e0
		v_add_u32_e32 v32, s4, v24
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v16, v36, v32, s[12:13]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v32, s4, v42
		v_cndmask_b32_e32 v32, v36, v32, vcc
		v_add_u32_e32 v43, s4, v39
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_cndmask_b32_e32 v16, v36, v43, vcc
		s_add_i32 m0, m0, 0x2100
		v_cmp_ne_u32_e64 vcc, v8, s16
		v_lshlrev_b32_e32 v8, 7, v8
		buffer_load_dwordx4 v32, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v32, 4, v37
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s1, s0, -3
		v_lshlrev_b32_e32 v43, 4, v32
		v_and_b32_e32 v44, 15, v37
		v_lshl_add_u32 v45, v5, 5, v9
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_mov_b32_e32 v16, 0x420
		v_mul_lo_u32 v16, v16, v44
		v_add3_u32 v8, v8, v43, v16
		ds_read_b128 v[48:51], v8
		ds_read_b128 v[52:55], v8 offset:64
		ds_read_b128 v[56:59], v8 offset:256
		ds_read_b128 v[60:63], v8 offset:320
		ds_read_b128 v[64:67], v8 offset:512
		ds_read_b128 v[68:71], v8 offset:576
		ds_read_b128 v[72:75], v8 offset:768
		ds_read_b128 v[76:79], v8 offset:832
		v_lshlrev_b32_e32 v16, 9, v3
		v_add3_u32 v43, v45, v16, v26
		ds_read_b64_tr_b16 v[44:45], v43 offset:50656
		ds_read_b64_tr_b16 v[46:47], v43 offset:59104
		v_add_u32_e32 v9, 0x10000, v9
		v_lshl_add_u32 v5, v5, 5, v9
		v_add3_u32 v5, v5, v16, v26
		ds_read_b64_tr_b16 v[80:81], v5 offset:2016
		ds_read_b64_tr_b16 v[82:83], v5 offset:10464
		ds_read_b64_tr_b16 v[84:85], v43 offset:50784
		ds_read_b64_tr_b16 v[86:87], v43 offset:59232
		ds_read_b64_tr_b16 v[88:89], v5 offset:2144
		ds_read_b64_tr_b16 v[90:91], v5 offset:10592
		ds_read_b64_tr_b16 v[92:93], v43 offset:50912
		ds_read_b64_tr_b16 v[94:95], v43 offset:59360
		ds_read_b64_tr_b16 v[96:97], v5 offset:2272
		ds_read_b64_tr_b16 v[98:99], v5 offset:10720
		ds_read_b64_tr_b16 v[100:101], v43 offset:51040
		ds_read_b64_tr_b16 v[102:103], v43 offset:59488
		ds_read_b64_tr_b16 v[104:105], v5 offset:2400
		ds_read_b64_tr_b16 v[106:107], v5 offset:10848
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[38:39], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[38:39]
		s_setprio 0
		v_add3_u32 v5, v25, v34, v35
		v_add_u32_e32 v5, 0x180, v5
		s_lshl_b32 s4, s15, 1
		v_mul_lo_u32 v9, s4, v15
		v_add_u32_e32 v15, v5, v9
		v_mul_lo_u32 v1, s4, v1
		v_add_u32_e32 v9, v5, v1
		s_mul_i32 s4, 0x180, s17
		s_cmp_lt_i32 0, s1
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
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		s_mov_b32 s5, s16
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[108:111], v[44:47], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[48:51], v[112:115]
		s_cmp_ge_u32 s5, 2
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[48:51], v[116:119]
		s_cselect_b32 s12, 1, 0
		s_add_i32 s13, s5, -2
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[48:51], v[120:123]
		s_add_i32 s15, s5, 1
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[56:59], v[136:139]
		s_cmp_lg_u32 s12, 0
		s_cselect_b32 s12, s13, s15
		v_mfma_f32_16x16x32_f16 v[124:127], v[44:47], v[56:59], v[124:127]
		s_add_i32 s13, s16, 3
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[56:59], v[128:131]
		s_mul_i32 s13, s13, 64
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[44:47], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[44:47], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[68:71], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[76:79], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[76:79], v[164:167]
		s_setprio 1
		s_barrier
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s14, s13
		v_cmp_lt_i32_e64 vcc, v27, s13
		v_cmp_lt_i32_e64 s[26:27], v10, s13
		s_lshl_b32 s15, s16, 7
		v_cmp_lt_i32_e64 s[32:33], v4, s13
		s_mul_i32 s34, 0x4200, s5
		v_cndmask_b32_e32 v1, v36, v15, vcc
		v_cmp_lt_i32_e64 s[36:37], v38, s13
		s_add_i32 s34, s3, s34
		v_cndmask_b32_e32 v5, v36, v9, vcc
		s_mov_b32 m0, s34
		v_cmp_lt_i32_e64 vcc, v6, s13
		buffer_load_dwordx4 v1, s[20:23], s15 offen lds
		s_mul_i32 s5, 0x8400, s5
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s5, s3, s5
		buffer_load_dwordx4 v5, s[20:23], s15 offen lds
		s_mul_i32 s13, s17, s16
		s_lshl_b32 s13, s13, 7
		s_add_i32 s13, s4, s13
		v_add_u32_e32 v1, s13, v40
		v_cndmask_b32_e64 v1, v36, v1, s[32:33]
		v_add_u32_e32 v5, s13, v24
		s_add_i32 m0, s5, 0xc5e0
		v_cndmask_b32_e64 v5, v36, v5, s[26:27]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_mul_i32 s5, 0x8400, s12
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s15, 0x4200, s12
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_add_u32_e32 v1, s13, v42
		v_cndmask_b32_e64 v1, v36, v1, s[36:37]
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s26, s5, 0x10000
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_add_u32_e32 v1, s13, v39
		v_cndmask_b32_e32 v1, v36, v1, vcc
		v_add_u32_e32 v5, s15, v8
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v16, s5, v43
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(6)
		ds_read_b128 v[48:51], v5
		ds_read_b128 v[52:55], v5 offset:64
		ds_read_b128 v[56:59], v5 offset:256
		ds_read_b128 v[60:63], v5 offset:320
		ds_read_b128 v[64:67], v5 offset:512
		ds_read_b128 v[68:71], v5 offset:576
		ds_read_b128 v[72:75], v5 offset:768
		ds_read_b128 v[76:79], v5 offset:832
		ds_read_b64_tr_b16 v[44:45], v16 offset:50656
		ds_read_b64_tr_b16 v[46:47], v16 offset:59104
		v_add_u32_e32 v1, s26, v43
		ds_read_b64_tr_b16 v[80:81], v1 offset:2016
		ds_read_b64_tr_b16 v[82:83], v1 offset:10464
		ds_read_b64_tr_b16 v[84:85], v16 offset:50784
		ds_read_b64_tr_b16 v[86:87], v16 offset:59232
		ds_read_b64_tr_b16 v[88:89], v1 offset:2144
		ds_read_b64_tr_b16 v[90:91], v1 offset:10592
		ds_read_b64_tr_b16 v[92:93], v16 offset:50912
		ds_read_b64_tr_b16 v[94:95], v16 offset:59360
		ds_read_b64_tr_b16 v[96:97], v1 offset:2272
		ds_read_b64_tr_b16 v[98:99], v1 offset:10720
		ds_read_b64_tr_b16 v[100:101], v16 offset:51040
		ds_read_b64_tr_b16 v[102:103], v16 offset:59488
		ds_read_b64_tr_b16 v[104:105], v1 offset:2400
		ds_read_b64_tr_b16 v[106:107], v1 offset:10848
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s16, s1
		s_mov_b32 s5, s12
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[38:39], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[38:39]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s22
		s_mov_b32 s15, s23
		buffer_load_dwordx4 v[24:27], v23, s[12:15], 0 offen
		v_mul_lo_u32 v1, s18, v19
		v_add_lshl_u32 v4, v18, v1, 1
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s22
		s_mov_b32 s7, s23
		buffer_load_ushort v5, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v28, v1, 1
		buffer_load_ushort v6, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v29, v1, 1
		buffer_load_ushort v9, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v30, v1, 1
		buffer_load_ushort v10, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v31, v1, 1
		buffer_load_ushort v15, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v33, v1, 1
		buffer_load_ushort v16, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v4, v17, v1, 1
		buffer_load_ushort v23, v4, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v4, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v20
		v_add_lshl_u32 v34, v18, v1, 1
		buffer_load_ushort v35, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v28, v1, 1
		buffer_load_ushort v36, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v29, v1, 1
		buffer_load_ushort v38, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v30, v1, 1
		buffer_load_ushort v39, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v31, v1, 1
		buffer_load_ushort v40, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v33, v1, 1
		buffer_load_ushort v42, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v34, v17, v1, 1
		buffer_load_ushort v172, v34, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v34, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v21
		v_add_lshl_u32 v173, v18, v1, 1
		buffer_load_ushort v174, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v28, v1, 1
		buffer_load_ushort v175, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v29, v1, 1
		buffer_load_ushort v176, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v30, v1, 1
		buffer_load_ushort v177, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v31, v1, 1
		buffer_load_ushort v178, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v33, v1, 1
		buffer_load_ushort v179, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v173, v17, v1, 1
		buffer_load_ushort v180, v173, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v173, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v22
		v_add_lshl_u32 v181, v18, v1, 1
		buffer_load_ushort v182, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v28, v1, 1
		buffer_load_ushort v183, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v29, v1, 1
		buffer_load_ushort v184, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v30, v1, 1
		buffer_load_ushort v185, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v31, v1, 1
		buffer_load_ushort v186, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v33, v1, 1
		buffer_load_ushort v187, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v181, v17, v1, 1
		buffer_load_ushort v188, v181, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v181, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v11
		v_add_lshl_u32 v189, v18, v1, 1
		buffer_load_ushort v190, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v28, v1, 1
		buffer_load_ushort v191, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v29, v1, 1
		buffer_load_ushort v192, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v30, v1, 1
		buffer_load_ushort v193, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v31, v1, 1
		buffer_load_ushort v194, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v33, v1, 1
		buffer_load_ushort v195, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v189, v17, v1, 1
		buffer_load_ushort v196, v189, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v189, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v12
		v_add_lshl_u32 v197, v18, v1, 1
		buffer_load_ushort v198, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v28, v1, 1
		buffer_load_ushort v199, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v29, v1, 1
		buffer_load_ushort v200, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v30, v1, 1
		buffer_load_ushort v201, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v31, v1, 1
		buffer_load_ushort v202, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v33, v1, 1
		buffer_load_ushort v203, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v197, v17, v1, 1
		buffer_load_ushort v204, v197, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v197, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v13
		v_add_lshl_u32 v205, v18, v1, 1
		buffer_load_ushort v206, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v28, v1, 1
		buffer_load_ushort v207, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v29, v1, 1
		buffer_load_ushort v208, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v30, v1, 1
		buffer_load_ushort v209, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v31, v1, 1
		buffer_load_ushort v210, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v33, v1, 1
		buffer_load_ushort v211, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v205, v17, v1, 1
		buffer_load_ushort v212, v205, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v205, v1, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v1, s18, v14
		v_add_lshl_u32 v213, v18, v1, 1
		buffer_load_ushort v214, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v28, v1, 1
		buffer_load_ushort v215, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v29, v1, 1
		buffer_load_ushort v216, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v30, v1, 1
		buffer_load_ushort v217, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v31, v1, 1
		buffer_load_ushort v218, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v33, v1, 1
		buffer_load_ushort v219, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v213, v17, v1, 1
		buffer_load_ushort v220, v213, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_load_ushort v213, v1, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[108:111], v[44:47], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[44:47], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[44:47], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[44:47], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[72:75], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[68:71], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[68:71], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[76:79], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[76:79], v[164:167]
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
		s_waitcnt vmcnt(62)
		s_barrier
		s_mul_i32 s3, 0x4200, s1
		v_add_u32_e32 v1, s3, v8
		ds_read_b128 v[44:47], v1
		ds_read_b128 v[48:51], v1 offset:64
		ds_read_b128 v[52:55], v1 offset:256
		ds_read_b128 v[56:59], v1 offset:320
		ds_read_b128 v[60:63], v1 offset:512
		ds_read_b128 v[64:67], v1 offset:576
		ds_read_b128 v[68:71], v1 offset:768
		ds_read_b128 v[72:75], v1 offset:832
		s_mul_i32 s1, 0x8400, s1
		v_add_u32_e32 v1, s1, v43
		ds_read_b64_tr_b16 v[76:77], v1 offset:50656
		ds_read_b64_tr_b16 v[78:79], v1 offset:59104
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v80, s1, v43
		ds_read_b64_tr_b16 v[84:85], v80 offset:2016
		ds_read_b64_tr_b16 v[86:87], v80 offset:10464
		ds_read_b64_tr_b16 v[88:89], v1 offset:50784
		ds_read_b64_tr_b16 v[90:91], v1 offset:59232
		ds_read_b64_tr_b16 v[92:93], v80 offset:2144
		ds_read_b64_tr_b16 v[94:95], v80 offset:10592
		ds_read_b64_tr_b16 v[96:97], v1 offset:50912
		ds_read_b64_tr_b16 v[98:99], v1 offset:59360
		ds_read_b64_tr_b16 v[100:101], v80 offset:2272
		ds_read_b64_tr_b16 v[102:103], v80 offset:10720
		ds_read_b64_tr_b16 v[104:105], v1 offset:51040
		ds_read_b64_tr_b16 v[106:107], v1 offset:59488
		ds_read_b64_tr_b16 v[224:225], v80 offset:2400
		ds_read_b64_tr_b16 v[226:227], v80 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[44:47], v[108:111]
		s_add_i32 s0, s0, -1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s3, s0, -1
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[44:47], v[112:115]
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s3, s0
		s_mul_hi_u32 s1, s0, 0xaaaaaaab
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[44:47], v[116:119]
		s_cselect_b32 s3, 1, 0
		s_lshr_b32 s1, s1, 1
		s_mul_i32 s1, s1, 3
		s_xor_b32 s1, s1, -1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[44:47], v[120:123]
		s_add_i32 s1, s1, 1
		s_add_i32 s0, s0, s1
		s_xor_b32 s1, s0, -1
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[52:55], v[136:139]
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s0, s1, s0
		s_mul_i32 s1, 0x4200, s0
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[52:55], v[124:127]
		v_add_u32_e32 v1, s1, v8
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[48:51], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[224:227], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[224:227], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[224:227], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[224:227], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[72:75], v[164:167]
		ds_read_b128 v[44:47], v1
		ds_read_b128 v[48:51], v1 offset:64
		ds_read_b128 v[52:55], v1 offset:256
		ds_read_b128 v[56:59], v1 offset:320
		ds_read_b128 v[60:63], v1 offset:512
		ds_read_b128 v[64:67], v1 offset:576
		ds_read_b128 v[68:71], v1 offset:768
		ds_read_b128 v[72:75], v1 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v1, s0, v43
		ds_read_b64_tr_b16 v[76:77], v1 offset:50656
		ds_read_b64_tr_b16 v[78:79], v1 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v8, s0, v43
		ds_read_b64_tr_b16 v[80:81], v8 offset:2016
		ds_read_b64_tr_b16 v[82:83], v8 offset:10464
		ds_read_b64_tr_b16 v[84:85], v1 offset:50784
		ds_read_b64_tr_b16 v[86:87], v1 offset:59232
		ds_read_b64_tr_b16 v[88:89], v8 offset:2144
		ds_read_b64_tr_b16 v[90:91], v8 offset:10592
		ds_read_b64_tr_b16 v[92:93], v1 offset:50912
		ds_read_b64_tr_b16 v[94:95], v1 offset:59360
		ds_read_b64_tr_b16 v[96:97], v8 offset:2272
		ds_read_b64_tr_b16 v[98:99], v8 offset:10720
		ds_read_b64_tr_b16 v[100:101], v1 offset:51040
		ds_read_b64_tr_b16 v[102:103], v1 offset:59488
		ds_read_b64_tr_b16 v[104:105], v8 offset:2400
		ds_read_b64_tr_b16 v[106:107], v8 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[44:47], v[108:111]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[136:139], v[100:103], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[100:103], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[100:103], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[56:59], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[96:99], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[88:91], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[72:75], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[72:75], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[72:75], v[164:167]
		v_lshlrev_b32_e32 v1, 1, v3
		v_lshlrev_b32_e32 v3, 2, v41
		v_lshlrev_b32_e32 v7, 3, v7
		v_xor_b32_e32 v3, v3, v7
		v_bitop3_b32 v0, v0, v1, v3 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v0
		ds_write_b128 v1, v[108:111]
		v_xor_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[112:115] offset:8192
		ds_write_b128 v1, v[116:119] offset:16384
		ds_write_b128 v0, v[120:123] offset:24576
		v_and_b32_e32 v3, 1, v32
		v_cvt_f32_f16_e32 v44, v5
		v_cvt_f32_f16_e32 v45, v6
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v6, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v5, 3, v37
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v7, 13, v5
		v_lshl_add_u32 v3, v3, 14, v7
		v_lshrrev_b32_e32 v7, 5, v37
		v_lshl_add_u32 v7, s2, 1, v7
		v_lshrrev_b32_e32 v8, 2, v37
		v_and_b32_e32 v8, 1, v8
		v_lshl_add_u32 v7, v8, 7, v7
		v_lshrrev_b32_e32 v9, 1, v37
		v_and_b32_e32 v9, 1, v9
		v_lshl_add_u32 v7, v9, 6, v7
		v_and_b32_e32 v32, 1, v37
		v_lshl_add_u32 v7, v32, 5, v7
		v_lshlrev_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v9, 2, v9
		v_lshlrev_b32_e32 v8, 3, v8
		v_bitop3_b32 v5, v9, v8, v5 bitop3:0x96
		v_bitop3_b32 v5, v7, v32, v5 bitop3:0x96
		v_lshl_add_u32 v3, v5, 4, v3
		ds_read_b128 v[48:51], v3
		ds_read_b128 v[52:55], v3 offset:256
		ds_read_b128 v[56:59], v3 offset:4096
		ds_read_b128 v[60:63], v3 offset:4352
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v7, v10
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v8, v15
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v9, v16
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v46, v23
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[124:127]
		ds_write_b128 v0, v[128:131] offset:8192
		ds_write_b128 v1, v[132:135] offset:16384
		ds_write_b128 v0, v[136:139] offset:24576
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v47, v4
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v4, v35
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v5, v36
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v36, v38
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v3
		ds_read_b128 v[68:71], v3 offset:256
		ds_read_b128 v[72:75], v3 offset:4096
		ds_read_b128 v[76:79], v3 offset:4352
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v37, v39
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v38, v40
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v39, v42
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v40, v172
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[140:143]
		ds_write_b128 v0, v[144:147] offset:8192
		ds_write_b128 v1, v[148:151] offset:16384
		ds_write_b128 v0, v[152:155] offset:24576
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v41, v34
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v34, v174
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v35, v175
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v42, v176
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v3
		ds_read_b128 v[84:87], v3 offset:256
		ds_read_b128 v[88:91], v3 offset:4096
		ds_read_b128 v[92:95], v3 offset:4352
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v43, v177
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v96, v178
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v97, v179
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v98, v180
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[156:159]
		ds_write_b128 v0, v[160:163] offset:8192
		ds_write_b128 v1, v[164:167] offset:16384
		ds_write_b128 v0, v[168:171] offset:24576
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v99, v173
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v0, v182
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v1, v183
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v100, v184
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[104:107], v3
		ds_read_b128 v[108:111], v3 offset:256
		ds_read_b128 v[112:115], v3 offset:4096
		ds_read_b128 v[116:119], v3 offset:4352
		v_cvt_f32_f16_e32 v102, v24
		v_cvt_f32_f16_sdwa v103, v24 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v120, v25
		v_cvt_f32_f16_sdwa v121, v25 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v24, v26
		v_cvt_f32_f16_sdwa v25, v26 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v122, v27
		v_cvt_f32_f16_sdwa v123, v27 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v101, v185
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v26, v186
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v27, v187
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v124, v188
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v125, v181
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v126, v190
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v127, v191
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v128, v192
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v129, v193
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v130, v194
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v131, v195
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v132, v196
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v133, v189
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v134, v198
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v135, v199
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v136, v200
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v137, v201
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v138, v202
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v139, v203
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v140, v204
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v141, v197
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v142, v206
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v143, v207
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v144, v208
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v145, v209
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v146, v210
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v147, v211
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v148, v212
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v149, v205
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v150, v214
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v151, v215
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v152, v216
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v153, v217
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v154, v218
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v155, v219
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v156, v220
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v157, v213
		v_pk_add_f32 v[48:49], v[48:49], v[102:103]
		v_pk_add_f32 v[50:51], v[50:51], v[120:121]
		v_pk_add_f32 v[52:53], v[52:53], v[24:25]
		v_pk_add_f32 v[54:55], v[54:55], v[122:123]
		v_pk_add_f32 v[56:57], v[56:57], v[102:103]
		v_pk_add_f32 v[58:59], v[58:59], v[120:121]
		v_pk_add_f32 v[60:61], v[60:61], v[24:25]
		v_pk_add_f32 v[62:63], v[62:63], v[122:123]
		v_pk_add_f32 v[64:65], v[64:65], v[102:103]
		v_pk_add_f32 v[66:67], v[66:67], v[120:121]
		v_pk_add_f32 v[68:69], v[68:69], v[24:25]
		v_pk_add_f32 v[70:71], v[70:71], v[122:123]
		v_pk_add_f32 v[72:73], v[72:73], v[102:103]
		v_pk_add_f32 v[74:75], v[74:75], v[120:121]
		v_pk_add_f32 v[76:77], v[76:77], v[24:25]
		v_pk_add_f32 v[78:79], v[78:79], v[122:123]
		v_pk_add_f32 v[80:81], v[80:81], v[102:103]
		v_pk_add_f32 v[82:83], v[82:83], v[120:121]
		v_pk_add_f32 v[84:85], v[84:85], v[24:25]
		v_pk_add_f32 v[86:87], v[86:87], v[122:123]
		v_pk_add_f32 v[88:89], v[88:89], v[102:103]
		v_pk_add_f32 v[90:91], v[90:91], v[120:121]
		v_pk_add_f32 v[92:93], v[92:93], v[24:25]
		v_pk_add_f32 v[94:95], v[94:95], v[122:123]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[104:105], v[104:105], v[102:103]
		v_pk_add_f32 v[106:107], v[106:107], v[120:121]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[108:109], v[108:109], v[24:25]
		v_pk_add_f32 v[110:111], v[110:111], v[122:123]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[102:103], v[112:113], v[102:103]
		v_pk_add_f32 v[112:113], v[114:115], v[120:121]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[24:25], v[116:117], v[24:25]
		v_pk_add_f32 v[114:115], v[118:119], v[122:123]
		v_pk_fma_f32 v[116:117], v[48:49], v[44:45], v[48:49]
		v_pk_fma_f32 v[44:45], v[50:51], v[6:7], v[50:51]
		v_pk_fma_f32 v[6:7], v[52:53], v[8:9], v[52:53]
		v_pk_fma_f32 v[8:9], v[54:55], v[46:47], v[54:55]
		v_pk_fma_f32 v[46:47], v[56:57], v[4:5], v[56:57]
		v_pk_fma_f32 v[4:5], v[58:59], v[36:37], v[58:59]
		v_pk_fma_f32 v[36:37], v[60:61], v[38:39], v[60:61]
		v_pk_fma_f32 v[38:39], v[62:63], v[40:41], v[62:63]
		v_pk_fma_f32 v[40:41], v[64:65], v[34:35], v[64:65]
		v_pk_fma_f32 v[34:35], v[66:67], v[42:43], v[66:67]
		v_pk_fma_f32 v[42:43], v[68:69], v[96:97], v[68:69]
		v_pk_fma_f32 v[48:49], v[70:71], v[98:99], v[70:71]
		v_pk_fma_f32 v[50:51], v[72:73], v[0:1], v[72:73]
		v_pk_fma_f32 v[0:1], v[74:75], v[100:101], v[74:75]
		v_pk_fma_f32 v[52:53], v[76:77], v[26:27], v[76:77]
		v_pk_fma_f32 v[26:27], v[78:79], v[124:125], v[78:79]
		v_pk_fma_f32 v[54:55], v[80:81], v[126:127], v[80:81]
		v_pk_fma_f32 v[56:57], v[82:83], v[128:129], v[82:83]
		v_pk_fma_f32 v[58:59], v[84:85], v[130:131], v[84:85]
		v_pk_fma_f32 v[60:61], v[86:87], v[132:133], v[86:87]
		v_pk_fma_f32 v[62:63], v[88:89], v[134:135], v[88:89]
		v_pk_fma_f32 v[64:65], v[90:91], v[136:137], v[90:91]
		v_pk_fma_f32 v[66:67], v[92:93], v[138:139], v[92:93]
		v_pk_fma_f32 v[68:69], v[94:95], v[140:141], v[94:95]
		v_pk_fma_f32 v[70:71], v[104:105], v[142:143], v[104:105]
		v_pk_fma_f32 v[72:73], v[106:107], v[144:145], v[106:107]
		v_pk_fma_f32 v[74:75], v[108:109], v[146:147], v[108:109]
		v_pk_fma_f32 v[76:77], v[110:111], v[148:149], v[110:111]
		v_pk_fma_f32 v[78:79], v[102:103], v[150:151], v[102:103]
		v_pk_fma_f32 v[80:81], v[112:113], v[152:153], v[112:113]
		v_pk_fma_f32 v[82:83], v[24:25], v[154:155], v[24:25]
		v_pk_fma_f32 v[24:25], v[114:115], v[156:157], v[114:115]
		v_cvt_pk_f16_f32 v3, v116, v117
		v_cvt_pk_f16_f32 v10, v44, v45
		v_cvt_pk_f16_f32 v6, v6, v7
		v_cvt_pk_f16_f32 v7, v8, v9
		v_cvt_pk_f16_f32 v8, v46, v47
		v_cvt_pk_f16_f32 v4, v4, v5
		v_cvt_pk_f16_f32 v5, v36, v37
		v_cvt_pk_f16_f32 v9, v38, v39
		v_cvt_pk_f16_f32 v15, v40, v41
		v_cvt_pk_f16_f32 v16, v34, v35
		v_cvt_pk_f16_f32 v23, v42, v43
		v_cvt_pk_f16_f32 v32, v48, v49
		v_cvt_pk_f16_f32 v34, v50, v51
		v_cvt_pk_f16_f32 v0, v0, v1
		v_cvt_pk_f16_f32 v1, v52, v53
		v_cvt_pk_f16_f32 v26, v26, v27
		v_cvt_pk_f16_f32 v27, v54, v55
		v_cvt_pk_f16_f32 v35, v56, v57
		v_cvt_pk_f16_f32 v36, v58, v59
		v_cvt_pk_f16_f32 v37, v60, v61
		v_cvt_pk_f16_f32 v38, v62, v63
		v_cvt_pk_f16_f32 v39, v64, v65
		v_cvt_pk_f16_f32 v40, v66, v67
		v_cvt_pk_f16_f32 v41, v68, v69
		v_cvt_pk_f16_f32 v42, v70, v71
		v_cvt_pk_f16_f32 v43, v72, v73
		v_cvt_pk_f16_f32 v44, v74, v75
		v_cvt_pk_f16_f32 v45, v76, v77
		v_cvt_pk_f16_f32 v46, v78, v79
		v_cvt_pk_f16_f32 v47, v80, v81
		v_cvt_pk_f16_f32 v48, v82, v83
		v_cvt_pk_f16_f32 v24, v24, v25
		v_and_b32_e32 v25, 0xffff, v3
		v_mul_lo_u32 v19, s19, v19
		v_add_lshl_u32 v49, v18, v19, 1
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s22
		s_mov_b32 s3, s23
		buffer_store_short v25, v49, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v25, v28, v19, 1
		buffer_store_short v3, v25, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v10
		v_add_lshl_u32 v25, v29, v19, 1
		buffer_store_short v3, v25, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v10
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v10, v30, v19, 1
		buffer_store_short v3, v10, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v6
		v_add_lshl_u32 v10, v31, v19, 1
		buffer_store_short v3, v10, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v6
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v6, v33, v19, 1
		buffer_store_short v3, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v7
		v_add_lshl_u32 v6, v17, v19, 1
		buffer_store_short v3, v6, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v7
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v6, v2, v19, 1
		buffer_store_short v3, v6, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v8
		v_mul_lo_u32 v6, s19, v20
		v_add_lshl_u32 v7, v18, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v8
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v7, v28, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v4
		v_add_lshl_u32 v7, v29, v6, 1
		buffer_store_short v3, v7, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v4
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v30, v6, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v5
		v_add_lshl_u32 v4, v31, v6, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v5
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v33, v6, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v9
		v_add_lshl_u32 v4, v17, v6, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v9
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v6, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v15
		v_mul_lo_u32 v4, s19, v21
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v15
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v28, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v16
		v_add_lshl_u32 v5, v29, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v16
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v30, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v23
		v_add_lshl_u32 v5, v31, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v23
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v33, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v32
		v_add_lshl_u32 v5, v17, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v32
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v4, v2, v4, 1
		buffer_store_short v3, v4, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v34
		v_mul_lo_u32 v4, s19, v22
		v_add_lshl_u32 v5, v18, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v3, 16, v34
		v_and_b32_e32 v3, 0xffff, v3
		v_add_lshl_u32 v5, v28, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v3, 0xffff, v0
		v_add_lshl_u32 v5, v29, v4, 1
		buffer_store_short v3, v5, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v0
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v30, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v1
		v_add_lshl_u32 v3, v31, v4, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v1
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v33, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v26
		v_add_lshl_u32 v1, v17, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v26
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v4, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v27
		v_mul_lo_u32 v1, s19, v11
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v27
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v35
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v35
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v30, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v36
		v_add_lshl_u32 v3, v31, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v36
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v33, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v37
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v37
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v38
		v_mul_lo_u32 v1, s19, v12
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v38
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v39
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v39
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v30, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v40
		v_add_lshl_u32 v3, v31, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v40
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v33, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v41
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v41
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v42
		v_mul_lo_u32 v1, s19, v13
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v42
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v43
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v43
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v30, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v44
		v_add_lshl_u32 v3, v31, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v44
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v33, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v45
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v45
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v46
		v_mul_lo_u32 v1, s19, v14
		v_add_lshl_u32 v3, v18, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v46
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v28, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v47
		v_add_lshl_u32 v3, v29, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v47
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v30, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v48
		v_add_lshl_u32 v3, v31, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v48
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v3, v33, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_and_b32_e32 v0, 0xffff, v24
		v_add_lshl_u32 v3, v17, v1, 1
		buffer_store_short v0, v3, s[0:3], 0 offen sc0 nt
		v_lshrrev_b32_e32 v0, 16, v24
		v_and_b32_e32 v0, 0xffff, v0
		v_add_lshl_u32 v1, v2, v1, 1
		buffer_store_short v0, v1, s[0:3], 0 offen sc0 nt
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
		.amdhsa_next_free_sgpr 40
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
