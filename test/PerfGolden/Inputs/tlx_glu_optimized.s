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
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s16, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s16, s16, s25
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s23, s26, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s16, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s16, s26, s16
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s23
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s1, s20, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s20, s22, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s20, s22
		s_mul_i32 s1, s1, 8
		s_xor_b32 s20, s1, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 8
		s_cselect_b32 s0, s0, 8
		s_add_i32 s20, s16, s24
		s_cmp_lg_u32 s23, 0
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
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s0, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s0
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s20, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s20, s20, s25
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s20, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s26, s20
		s_cselect_b32 s25, 1, 0
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s24, s20, s24
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s20, s24, s20
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s24, s20, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s24, s20
		s_add_i32 s1, s1, s20
		s_add_i32 s20, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s20, s23
		s_add_i32 s21, s20, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s20, s21, s20
		s_xor_b32 s0, s16, s0
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, 1, 0
		s_xor_b32 s16, s20, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s16, s20
		s_mul_i32 s1, s1, 0x80
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v3, 1, v1
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v5, 1, v8
		v_mov_b32_e32 v6, 32
		v_mul_lo_u32 v6, v6, v5
		v_mad_u32_u24 v3, v3, 16, v6
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v5, 1, v9
		v_mad_u32_u24 v3, v5, 64, v3
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v7, 1, v6
		v_lshrrev_b32_e32 v10, 7, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v11
		v_add3_u32 v3, v3, v7, v12
		v_lshrrev_b32_e32 v11, 8, v0
		v_and_b32_e32 v13, 1, v11
		v_mad_u32_u24 v3, v13, 4, v3
		v_and_b32_e32 v14, 15, v9
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
		s_nop 0
		v_mul_f32_e32 v20, v2, v20
		v_cvt_u32_f32_e32 v20, v20
		v_xad_u32 v21, v19, -1, 1
		v_mul_lo_u32 v22, v21, v20
		v_mul_hi_u32 v22, v20, v22
		v_add_u32_e32 v20, v20, v22
		v_mul_hi_u32 v22, v18, v20
		v_mul_lo_u32 v22, v22, v19
		v_xor_b32_e32 v22, -1, v22
		v_add3_u32 v18, 1, v22, v18
		v_add_u32_e32 v22, v18, v21
		v_add_u32_e32 v23, s1, v14
		v_cmp_ge_u32_e64 vcc, v18, v19
		s_nop 1
		v_cndmask_b32_e32 v18, v18, v22, vcc
		v_add_u32_e32 v22, v18, v21
		v_add3_u32 v24, 16, v14, s1
		v_cmp_ge_u32_e64 vcc, v18, v19
		s_nop 1
		v_cndmask_b32_e32 v18, v18, v22, vcc
		v_xad_u32 v22, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v3, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v25, v3, -1, 1
		v_add3_u32 v26, 32, v14, s1
		v_cndmask_b32_e32 v3, v3, v25, vcc
		v_mul_hi_u32 v25, v3, v20
		v_mul_lo_u32 v25, v25, v19
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v3, 1, v25, v3
		v_add_u32_e32 v25, v3, v21
		v_add3_u32 v27, 48, v14, s1
		v_cmp_ge_u32_e64 vcc, v3, v19
		s_nop 1
		v_cndmask_b32_e32 v3, v3, v25, vcc
		v_add_u32_e32 v25, v3, v21
		v_add3_u32 v14, 64, v14, s1
		v_cmp_ge_u32_e64 vcc, v3, v19
		s_nop 1
		v_cndmask_b32_e32 v3, v3, v25, vcc
		v_xad_u32 v25, v3, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v28, v23, -1, 1
		v_add_u32_e32 v15, s1, v15
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_mul_hi_u32 v28, v23, v20
		v_mul_lo_u32 v28, v28, v19
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v23, 1, v28, v23
		v_add_u32_e32 v28, v23, v21
		v_add_u32_e32 v16, s1, v16
		v_cmp_ge_u32_e64 vcc, v23, v19
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_add_u32_e32 v28, v23, v21
		v_add_u32_e32 v17, s1, v17
		v_cmp_ge_u32_e64 vcc, v23, v19
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v28, vcc
		v_xad_u32 v28, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v29, v24, -1, 1
		v_cndmask_b32_e64 v18, v18, v22, s[20:21]
		v_cndmask_b32_e32 v22, v24, v29, vcc
		v_mul_hi_u32 v24, v22, v20
		v_mul_lo_u32 v24, v24, v19
		v_xor_b32_e32 v24, -1, v24
		v_add3_u32 v22, 1, v24, v22
		v_add_u32_e32 v24, v22, v21
		v_cndmask_b32_e64 v3, v3, v25, s[26:27]
		v_cmp_ge_u32_e64 vcc, v22, v19
		s_nop 1
		v_cndmask_b32_e32 v22, v22, v24, vcc
		v_add_u32_e32 v24, v22, v21
		v_cndmask_b32_e64 v23, v23, v28, s[28:29]
		v_cmp_ge_u32_e64 vcc, v22, v19
		s_nop 1
		v_cndmask_b32_e32 v22, v22, v24, vcc
		v_xad_u32 v24, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v26, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v25, v26, -1, 1
		v_cndmask_b32_e64 v22, v22, v24, s[30:31]
		v_cndmask_b32_e32 v24, v26, v25, vcc
		v_mul_hi_u32 v25, v24, v20
		v_mul_lo_u32 v25, v25, v19
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v24, 1, v25, v24
		v_add_u32_e32 v25, v24, v21
		v_and_b32_e32 v26, 1, v6
		v_cmp_ge_u32_e64 vcc, v24, v19
		s_nop 1
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_add_u32_e32 v25, v24, v21
		v_and_b32_e32 v10, 1, v10
		v_cmp_ge_u32_e64 vcc, v24, v19
		s_nop 1
		v_cndmask_b32_e32 v24, v24, v25, vcc
		v_xad_u32 v25, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v27, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v28, v27, -1, 1
		v_cndmask_b32_e64 v24, v24, v25, s[20:21]
		v_cndmask_b32_e32 v25, v27, v28, vcc
		v_mul_hi_u32 v27, v25, v20
		v_mul_lo_u32 v27, v27, v19
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v25, 1, v27, v25
		v_add_u32_e32 v27, v25, v21
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v28, s17, v11
		v_cmp_ge_u32_e64 vcc, v25, v19
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_add_u32_e32 v27, v25, v21
		v_mul_lo_u32 v29, s15, v3
		v_cmp_ge_u32_e64 vcc, v25, v19
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_xad_u32 v27, v25, -1, 1
		v_cmp_lt_i32_e64 vcc, v14, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v30, v14, -1, 1
		v_cndmask_b32_e64 v25, v25, v27, s[26:27]
		v_cndmask_b32_e32 v14, v14, v30, vcc
		v_mul_hi_u32 v27, v14, v20
		v_mul_lo_u32 v27, v27, v19
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v14, 1, v27, v14
		v_add_u32_e32 v27, v14, v21
		v_lshrrev_b32_e32 v30, 1, v0
		v_cmp_ge_u32_e64 vcc, v14, v19
		s_nop 1
		v_cndmask_b32_e32 v14, v14, v27, vcc
		v_add_u32_e32 v27, v14, v21
		v_lshrrev_b32_e32 v31, 2, v0
		v_cmp_ge_u32_e64 vcc, v14, v19
		s_nop 1
		v_cndmask_b32_e32 v14, v14, v27, vcc
		v_xad_u32 v27, v14, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v32, v15, -1, 1
		v_cndmask_b32_e64 v14, v14, v27, s[20:21]
		v_cndmask_b32_e32 v15, v15, v32, vcc
		v_mul_hi_u32 v27, v15, v20
		v_mul_lo_u32 v27, v27, v19
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v15, 1, v27, v15
		v_add_u32_e32 v27, v15, v21
		v_and_b32_e32 v32, 1, v0
		v_cmp_ge_u32_e64 vcc, v15, v19
		s_nop 1
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_add_u32_e32 v27, v15, v21
		v_mov_b32_e32 v33, s13
		v_cmp_ge_u32_e64 vcc, v15, v19
		s_nop 1
		v_cndmask_b32_e32 v15, v15, v27, vcc
		v_xad_u32 v27, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v16, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v34, v16, -1, 1
		v_cndmask_b32_e64 v15, v15, v27, s[26:27]
		v_cndmask_b32_e32 v16, v16, v34, vcc
		v_mul_hi_u32 v27, v16, v20
		v_mul_lo_u32 v27, v27, v19
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v16, 1, v27, v16
		v_add_u32_e32 v27, v16, v21
		s_xor_b32 s1, s13, -1
		v_cmp_ge_u32_e64 vcc, v16, v19
		s_nop 1
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_add_u32_e32 v27, v16, v21
		v_and_b32_e32 v34, 15, v8
		v_cmp_ge_u32_e64 vcc, v16, v19
		s_nop 1
		v_cndmask_b32_e32 v16, v16, v27, vcc
		v_xad_u32 v27, v16, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v35, v17, -1, 1
		v_cndmask_b32_e64 v16, v16, v27, s[20:21]
		v_cndmask_b32_e32 v17, v17, v35, vcc
		v_mul_hi_u32 v20, v17, v20
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v20, -1, v20
		v_add3_u32 v17, 1, v20, v17
		v_add_u32_e32 v20, v17, v21
		v_and_b32_e32 v27, 31, v0
		v_cmp_ge_u32_e64 vcc, v17, v19
		s_nop 1
		v_cndmask_b32_e32 v17, v17, v20, vcc
		v_add_u32_e32 v20, v17, v21
		s_mul_i32 s0, s0, 0x100
		v_cmp_ge_u32_e64 vcc, v17, v19
		s_nop 1
		v_cndmask_b32_e32 v17, v17, v20, vcc
		v_xad_u32 v19, v17, -1, 1
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v34
		v_add_u32_e32 v21, 0x80, v20
		v_add_u32_e32 v34, 0xc0, v20
		v_mad_u32_u24 v27, v27, 8, s0
		v_cmp_lt_i32_e64 vcc, v27, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v35, v27, -1, 1
		v_cndmask_b32_e64 v17, v17, v19, s[26:27]
		v_cndmask_b32_e32 v19, v27, v35, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v27, s1
		v_cndmask_b32_e64 v27, v33, v27, s[12:13]
		v_cvt_f32_u32_e32 v33, v27
		v_rcp_iflag_f32_e32 v33, v33
		s_nop 0
		v_mul_f32_e32 v2, v2, v33
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v33, v27, -1, 1
		v_mul_lo_u32 v35, v33, v2
		v_mul_hi_u32 v35, v2, v35
		v_add_u32_e32 v2, v2, v35
		v_mul_hi_u32 v35, v19, v2
		v_mul_lo_u32 v35, v35, v27
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v19, 1, v35, v19
		v_add_u32_e32 v35, v19, v33
		v_add_u32_e32 v36, s0, v20
		v_cmp_ge_u32_e64 vcc, v19, v27
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_add_u32_e32 v35, v19, v33
		v_add3_u32 v20, 64, v20, s0
		v_cmp_ge_u32_e64 vcc, v19, v27
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v35, vcc
		v_xad_u32 v35, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v36, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v37, v36, -1, 1
		v_add_u32_e32 v21, s0, v21
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_mul_hi_u32 v37, v36, v2
		v_mul_lo_u32 v37, v37, v27
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v36, 1, v37, v36
		v_add_u32_e32 v37, v36, v33
		v_add_u32_e32 v34, s0, v34
		v_cmp_ge_u32_e64 vcc, v36, v27
		s_nop 1
		v_cndmask_b32_e32 v36, v36, v37, vcc
		v_add_u32_e32 v37, v36, v33
		v_cndmask_b32_e64 v19, v19, v35, s[20:21]
		v_cmp_ge_u32_e64 vcc, v36, v27
		s_nop 1
		v_cndmask_b32_e32 v35, v36, v37, vcc
		v_xad_u32 v36, v35, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v37, v20, -1, 1
		v_cndmask_b32_e64 v35, v35, v36, s[12:13]
		v_cndmask_b32_e32 v20, v20, v37, vcc
		v_mul_hi_u32 v36, v20, v2
		v_mul_lo_u32 v36, v36, v27
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v20, 1, v36, v20
		v_add_u32_e32 v36, v20, v33
		v_mul_lo_u32 v37, s15, v18
		v_cmp_ge_u32_e64 vcc, v20, v27
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v36, vcc
		v_add_u32_e32 v36, v20, v33
		s_mov_b32 s22, 0x7fffffff
		v_cmp_ge_u32_e64 vcc, v20, v27
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v36, vcc
		v_xad_u32 v36, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v38, v21, -1, 1
		v_cndmask_b32_e64 v20, v20, v36, s[0:1]
		v_cndmask_b32_e32 v21, v21, v38, vcc
		v_mul_hi_u32 v36, v21, v2
		v_mul_lo_u32 v36, v36, v27
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v21, 1, v36, v21
		v_add_u32_e32 v36, v21, v33
		v_mov_b32_e32 v38, 16
		v_mul_lo_u32 v38, v38, v5
		v_cmp_ge_u32_e64 vcc, v21, v27
		s_nop 1
		v_cndmask_b32_e32 v5, v21, v36, vcc
		v_add_u32_e32 v21, v5, v33
		v_and_b32_e32 v36, 7, v0
		v_cmp_ge_u32_e64 vcc, v5, v27
		s_nop 1
		v_cndmask_b32_e32 v5, v5, v21, vcc
		v_xad_u32 v21, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v34, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v39, v34, -1, 1
		v_cndmask_b32_e64 v21, v5, v21, s[12:13]
		v_cndmask_b32_e32 v5, v34, v39, vcc
		v_mul_hi_u32 v2, v5, v2
		v_mul_lo_u32 v2, v2, v27
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v5
		v_add_u32_e32 v5, v2, v33
		s_mov_b32 s12, 63
		v_cmp_ge_u32_e64 vcc, v2, v27
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v5, vcc
		v_add_u32_e32 v5, v2, v33
		s_add_i32 s13, s14, 63
		v_cmp_ge_u32_e64 vcc, v2, v27
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v5, vcc
		v_xad_u32 v5, v2, -1, 1
		v_cndmask_b32_e64 v2, v2, v5, s[0:1]
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s0, s12, 0
		s_add_i32 s0, s13, s0
		s_ashr_i32 s0, s0, 6
		v_mov_b32_e32 v27, 8
		v_mul_lo_u32 v27, v27, v36
		v_add3_u32 v5, v38, v7, v12
		v_mad_u32_u24 v12, v13, 8, v5
		v_add_u32_e32 v13, 4, v12
		v_add_u32_e32 v33, 32, v12
		v_add_u32_e32 v34, 36, v12
		v_cmp_lt_i32_e64 vcc, v27, s14
		s_mov_b64 s[12:13], vcc
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		v_readfirstlane_b32 s1, v0
		s_lshr_b32 s1, s1, 6
		s_mul_i32 s1, 0x420, s1
		v_lshlrev_b32_e32 v5, 4, v32
		v_lshl_add_u32 v7, v37, 1, v5
		v_and_b32_e32 v31, 1, v31
		v_lshl_add_u32 v7, v31, 6, v7
		v_and_b32_e32 v30, 1, v30
		v_lshl_add_u32 v7, v30, 5, v7
		s_and_saveexec_b64 s[32:33], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_0
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_0:
		s_mov_b64 exec, s[32:33]
		v_lshl_add_u32 v5, v29, 1, v5
		v_lshl_add_u32 v5, v31, 6, v5
		v_lshl_add_u32 v5, v30, 5, v5
		s_and_saveexec_b64 s[32:33], s[12:13]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_1
		s_add_i32 m0, s1, 0x2100
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_1:
		s_mov_b64 exec, s[32:33]
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		v_lshlrev_b32_e32 v28, 4, v28
		v_lshl_add_u32 v28, v19, 1, v28
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v10, v10, 2, v28
		v_mul_lo_u32 v26, s17, v26
		v_lshl_add_u32 v10, v26, 1, v10
		v_and_b32_e32 v26, 1, v9
		v_mul_lo_u32 v26, s17, v26
		v_cmp_lt_i32_e64 vcc, v12, s14
		s_mov_b64 s[2:3], vcc
		s_and_saveexec_b64 s[32:33], s[2:3]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_2
		s_add_i32 m0, s1, 0xc5e0
		v_lshl_add_u32 v28, v26, 5, v10
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_2:
		s_mov_b64 exec, s[32:33]
		v_lshlrev_b32_e32 v26, 5, v26
		s_lshl_b32 s2, s17, 3
		v_cmp_lt_i32_e64 vcc, v13, s14
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_3
		s_add_i32 m0, s1, 0xe6e0
		v_add3_u32 v28, v10, v26, s2
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_3:
		s_mov_b64 exec, s[32:33]
		s_lshl_b32 s2, s17, 6
		v_cmp_lt_i32_e64 vcc, v33, s14
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_4
		s_add_i32 m0, s1, 0x107e0
		v_add3_u32 v28, v10, v26, s2
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_4:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s2, 0x48, s17
		v_cmp_lt_i32_e64 vcc, v34, s14
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_5
		s_add_i32 m0, s1, 0x128e0
		v_add3_u32 v28, v10, v26, s2
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_5:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s2, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v27, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_6
		s_add_i32 m0, s1, 0x4200
		v_add_u32_e32 v28, 0x80, v7
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_6:
		s_mov_b64 exec, s[32:33]
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_7
		s_add_i32 m0, s1, 0x6300
		v_add_u32_e32 v28, 0x80, v5
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_7:
		s_mov_b64 exec, s[32:33]
		s_lshl_b32 s3, s17, 7
		v_cmp_lt_i32_e64 vcc, v12, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_8
		s_add_i32 m0, s1, 0x149e0
		v_add3_u32 v28, v10, v26, s3
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_8:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0x88, s17
		v_cmp_lt_i32_e64 vcc, v13, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_9
		s_add_i32 m0, s1, 0x16ae0
		v_add3_u32 v28, v10, v26, s3
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_9:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0xc0, s17
		v_cmp_lt_i32_e64 vcc, v33, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_10
		s_add_i32 m0, s1, 0x18be0
		v_add3_u32 v28, v10, v26, s3
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_10:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0xc8, s17
		v_cmp_lt_i32_e64 vcc, v34, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_11
		s_add_i32 m0, s1, 0x1ace0
		v_add3_u32 v28, v10, v26, s3
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_11:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s2, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v27, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_12
		s_add_i32 m0, s1, 0x8400
		v_add_u32_e32 v7, 0x100, v7
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_12:
		s_mov_b64 exec, s[32:33]
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_13
		s_add_i32 m0, s1, 0xa500
		v_add_u32_e32 v5, 0x100, v5
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_13:
		s_mov_b64 exec, s[32:33]
		s_lshl_b32 s3, s17, 8
		v_cmp_lt_i32_e64 vcc, v12, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_14
		s_add_i32 m0, s1, 0x1cde0
		v_add3_u32 v5, v10, v26, s3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_14:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0x108, s17
		v_cmp_lt_i32_e64 vcc, v13, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_15
		s_add_i32 m0, s1, 0x1eee0
		v_add3_u32 v5, v10, v26, s3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_15:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0x140, s17
		v_cmp_lt_i32_e64 vcc, v33, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_16
		s_add_i32 m0, s1, 0x20fe0
		v_add3_u32 v5, v10, v26, s3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_16:
		s_mov_b64 exec, s[32:33]
		s_mul_i32 s3, 0x148, s17
		v_cmp_lt_i32_e64 vcc, v34, s2
		s_mov_b64 s[4:5], vcc
		s_and_saveexec_b64 s[32:33], s[4:5]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_17
		s_add_i32 m0, s1, 0x230e0
		v_add3_u32 v5, v10, v26, s3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_17:
		s_mov_b64 exec, s[32:33]
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshlrev_b32_e32 v11, 7, v11
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v7, 4, v5
		v_lshlrev_b32_e32 v28, 4, v7
		v_and_b32_e32 v29, 15, v5
		v_mov_b32_e32 v36, 0x420
		v_mul_lo_u32 v36, v36, v29
		v_add3_u32 v37, v11, v28, v36
		ds_read_b128 v[40:43], v37
		ds_read_b128 v[44:47], v37 offset:64
		ds_read_b128 v[48:51], v37 offset:256
		ds_read_b128 v[52:55], v37 offset:320
		ds_read_b128 v[56:59], v37 offset:512
		ds_read_b128 v[60:63], v37 offset:576
		ds_read_b128 v[64:67], v37 offset:768
		ds_read_b128 v[68:71], v37 offset:832
		v_lshrrev_b32_e32 v5, 5, v5
		v_lshlrev_b32_e32 v38, 9, v5
		v_lshrrev_b32_e32 v5, 2, v29
		v_mov_b32_e32 v39, 0x420
		v_mul_lo_u32 v39, v39, v5
		v_and_b32_e32 v5, 3, v6
		v_lshlrev_b32_e32 v72, 5, v5
		v_add3_u32 v5, v38, v39, v72
		v_and_b32_e32 v6, 1, v7
		v_mov_b32_e32 v73, 0x1080
		v_mul_lo_u32 v73, v73, v6
		v_and_b32_e32 v6, 3, v29
		v_lshlrev_b32_e32 v29, 3, v6
		v_add3_u32 v74, v5, v73, v29
		ds_read_b64_tr_b16 v[76:77], v74 offset:50656
		ds_read_b64_tr_b16 v[78:79], v74 offset:59104
		v_add_u32_e32 v5, 0x10000, v38
		v_add3_u32 v5, v5, v39, v72
		v_add3_u32 v5, v5, v73, v29
		ds_read_b64_tr_b16 v[80:81], v5 offset:2016
		ds_read_b64_tr_b16 v[82:83], v5 offset:10464
		ds_read_b64_tr_b16 v[84:85], v74 offset:50784
		ds_read_b64_tr_b16 v[86:87], v74 offset:59232
		ds_read_b64_tr_b16 v[88:89], v5 offset:2144
		ds_read_b64_tr_b16 v[90:91], v5 offset:10592
		ds_read_b64_tr_b16 v[92:93], v74 offset:50912
		ds_read_b64_tr_b16 v[94:95], v74 offset:59360
		ds_read_b64_tr_b16 v[96:97], v5 offset:2272
		ds_read_b64_tr_b16 v[98:99], v5 offset:10720
		ds_read_b64_tr_b16 v[100:101], v74 offset:51040
		ds_read_b64_tr_b16 v[102:103], v74 offset:59488
		ds_read_b64_tr_b16 v[104:105], v5 offset:2400
		ds_read_b64_tr_b16 v[106:107], v5 offset:10848
		s_add_i32 s2, s0, -3
		v_lshlrev_b32_e32 v5, 6, v31
		v_lshl_add_u32 v5, v32, 4, v5
		v_lshl_add_u32 v5, v30, 5, v5
		v_add_u32_e32 v5, 0x180, v5
		s_lshl_b32 s3, s15, 1
		v_mul_lo_u32 v6, s3, v18
		v_add_u32_e32 v18, v5, v6
		v_mul_lo_u32 v3, s3, v3
		v_add_u32_e32 v75, v5, v3
		s_mul_i32 s3, 0x180, s17
		s_mul_i32 s4, 0x188, s17
		s_mul_i32 s5, 0x1c0, s17
		s_mul_i32 s12, 0x1c8, s17
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		v_mov_b32_e32 v108, v4
		v_mov_b32_e32 v109, v5
		v_mov_b32_e32 v110, v6
		v_mov_b32_e32 v111, v7
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
		s_cmp_lt_i32 0, s2
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		s_waitcnt lgkmcnt(14)
		s_barrier
		s_lshl_b32 s13, s16, 7
		s_add_i32 s15, s16, 3
		s_mul_i32 s15, s15, 64
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[68:71], v[160:163]
		s_xor_b32 s15, s15, -1
		s_add_i32 s15, s15, 1
		s_add_i32 s15, s14, s15
		v_cmp_lt_i32_e64 vcc, v27, s15
		s_mov_b64 s[28:29], vcc
		s_mul_hi_u32 s30, s16, 0xaaaaaaab
		s_lshr_b32 s30, s30, 1
		s_mul_i32 s30, s30, 3
		s_xor_b32 s30, s30, -1
		s_add_i32 s30, s30, 1
		s_add_i32 s30, s16, s30
		s_mul_i32 s31, 0x4200, s30
		s_and_saveexec_b64 s[32:33], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_18
		s_add_i32 m0, s1, s31
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], s13 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_18:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s31, s1, s31
		s_and_saveexec_b64 s[32:33], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_19
		s_add_i32 m0, s31, 0x2100
		s_nop 0
		buffer_load_dwordx4 v75, s[20:23], s13 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_19:
		s_mov_b64 exec, s[32:33]
		s_barrier
		s_mul_i32 s13, 0x8400, s30
		s_add_i32 s13, s1, s13
		s_mul_i32 s28, s17, s16
		s_lshl_b32 s28, s28, 7
		s_add_i32 s29, s3, s28
		v_cmp_lt_i32_e64 vcc, v12, s15
		s_mov_b64 s[30:31], vcc
		s_and_saveexec_b64 s[32:33], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_20
		s_add_i32 m0, s13, 0xc5e0
		v_add3_u32 v3, v10, v26, s29
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_20:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s29, s4, s28
		v_cmp_lt_i32_e64 vcc, v13, s15
		s_mov_b64 s[30:31], vcc
		s_and_saveexec_b64 s[32:33], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_21
		s_add_i32 m0, s13, 0xe6e0
		v_add3_u32 v3, v10, v26, s29
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_21:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s29, s5, s28
		v_cmp_lt_i32_e64 vcc, v33, s15
		s_mov_b64 s[30:31], vcc
		s_and_saveexec_b64 s[32:33], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_22
		s_add_i32 m0, s13, 0x107e0
		v_add3_u32 v3, v10, v26, s29
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_22:
		s_mov_b64 exec, s[32:33]
		s_add_i32 s28, s12, s28
		v_cmp_lt_i32_e64 vcc, v34, s15
		s_mov_b64 s[30:31], vcc
		s_and_saveexec_b64 s[32:33], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_optimized.exec_endif_23
		s_add_i32 m0, s13, 0x128e0
		v_add3_u32 v3, v10, v26, s28
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
.Ltlx_addmm_glu_kernel_optimized.exec_endif_23:
		s_mov_b64 exec, s[32:33]
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
		v_add_u32_e32 v3, s15, v11
		v_add3_u32 v3, v3, v28, v36
		ds_read_b128 v[40:43], v3
		ds_read_b128 v[44:47], v3 offset:64
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:320
		ds_read_b128 v[56:59], v3 offset:512
		ds_read_b128 v[60:63], v3 offset:576
		ds_read_b128 v[64:67], v3 offset:768
		ds_read_b128 v[68:71], v3 offset:832
		s_mul_i32 s13, 0x8400, s13
		v_add_u32_e32 v3, s13, v38
		v_add3_u32 v3, v3, v39, v72
		v_add3_u32 v3, v3, v73, v29
		ds_read_b64_tr_b16 v[76:77], v3 offset:50656
		ds_read_b64_tr_b16 v[78:79], v3 offset:59104
		s_add_i32 s13, s13, 0x10000
		v_add_u32_e32 v80, s13, v38
		v_add3_u32 v80, v80, v39, v72
		v_add3_u32 v168, v80, v73, v29
		ds_read_b64_tr_b16 v[80:81], v168 offset:2016
		ds_read_b64_tr_b16 v[82:83], v168 offset:10464
		ds_read_b64_tr_b16 v[84:85], v3 offset:50784
		ds_read_b64_tr_b16 v[86:87], v3 offset:59232
		ds_read_b64_tr_b16 v[88:89], v168 offset:2144
		ds_read_b64_tr_b16 v[90:91], v168 offset:10592
		ds_read_b64_tr_b16 v[92:93], v3 offset:50912
		ds_read_b64_tr_b16 v[94:95], v3 offset:59360
		ds_read_b64_tr_b16 v[96:97], v168 offset:2272
		ds_read_b64_tr_b16 v[98:99], v168 offset:10720
		ds_read_b64_tr_b16 v[100:101], v3 offset:51040
		ds_read_b64_tr_b16 v[102:103], v3 offset:59488
		ds_read_b64_tr_b16 v[104:105], v168 offset:2400
		ds_read_b64_tr_b16 v[106:107], v168 offset:10848
		s_cmp_lt_i32 s16, s2
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[68:71], v[160:163]
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
		v_add_u32_e32 v3, s2, v37
		ds_read_b128 v[40:43], v3
		ds_read_b128 v[44:47], v3 offset:64
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:320
		ds_read_b128 v[56:59], v3 offset:512
		ds_read_b128 v[60:63], v3 offset:576
		ds_read_b128 v[64:67], v3 offset:768
		ds_read_b128 v[68:71], v3 offset:832
		s_barrier
		s_mul_i32 s1, 0x8400, s1
		v_add_u32_e32 v3, s1, v74
		ds_read_b64_tr_b16 v[76:77], v3 offset:50656
		ds_read_b64_tr_b16 v[78:79], v3 offset:59104
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v10, s1, v74
		ds_read_b64_tr_b16 v[80:81], v10 offset:2016
		ds_read_b64_tr_b16 v[82:83], v10 offset:10464
		ds_read_b64_tr_b16 v[84:85], v3 offset:50784
		ds_read_b64_tr_b16 v[86:87], v3 offset:59232
		ds_read_b64_tr_b16 v[88:89], v10 offset:2144
		ds_read_b64_tr_b16 v[90:91], v10 offset:10592
		ds_read_b64_tr_b16 v[92:93], v3 offset:50912
		ds_read_b64_tr_b16 v[94:95], v3 offset:59360
		ds_read_b64_tr_b16 v[96:97], v10 offset:2272
		ds_read_b64_tr_b16 v[98:99], v10 offset:10720
		ds_read_b64_tr_b16 v[100:101], v3 offset:51040
		ds_read_b64_tr_b16 v[102:103], v3 offset:59488
		ds_read_b64_tr_b16 v[104:105], v10 offset:2400
		ds_read_b64_tr_b16 v[106:107], v10 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[92:95], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[4:7], v[80:83], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[44:47], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[68:71], v[160:163]
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
		v_add_u32_e32 v3, s1, v37
		ds_read_b128 v[36:39], v3
		ds_read_b128 v[40:43], v3 offset:64
		ds_read_b128 v[44:47], v3 offset:256
		ds_read_b128 v[48:51], v3 offset:320
		ds_read_b128 v[52:55], v3 offset:512
		ds_read_b128 v[56:59], v3 offset:576
		ds_read_b128 v[60:63], v3 offset:768
		ds_read_b128 v[64:67], v3 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v3, s0, v74
		ds_read_b64_tr_b16 v[68:69], v3 offset:50656
		ds_read_b64_tr_b16 v[70:71], v3 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v10, s0, v74
		ds_read_b64_tr_b16 v[72:73], v10 offset:2016
		ds_read_b64_tr_b16 v[74:75], v10 offset:10464
		ds_read_b64_tr_b16 v[76:77], v3 offset:50784
		ds_read_b64_tr_b16 v[78:79], v3 offset:59232
		ds_read_b64_tr_b16 v[80:81], v10 offset:2144
		ds_read_b64_tr_b16 v[82:83], v10 offset:10592
		ds_read_b64_tr_b16 v[84:85], v3 offset:50912
		ds_read_b64_tr_b16 v[86:87], v3 offset:59360
		ds_read_b64_tr_b16 v[88:89], v10 offset:2272
		ds_read_b64_tr_b16 v[90:91], v10 offset:10720
		ds_read_b64_tr_b16 v[92:93], v3 offset:51040
		ds_read_b64_tr_b16 v[94:95], v3 offset:59488
		ds_read_b64_tr_b16 v[96:97], v10 offset:2400
		ds_read_b64_tr_b16 v[98:99], v10 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[36:39], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[60:63], v[160:163]
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[40:43], v[112:115]
		s_waitcnt lgkmcnt(0)
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
		v_lshlrev_b32_e32 v3, 1, v35
		s_mov_b32 s0, s6
		s_mov_b32 s1, s7
		s_mov_b32 s2, s22
		s_mov_b32 s3, s23
		buffer_load_dwordx2 v[10:11], v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v20
		buffer_load_dwordx2 v[12:13], v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v3, 1, v21
		buffer_load_dwordx2 v[20:21], v3, s[0:3], 0 offen
		v_lshlrev_b32_e32 v2, 1, v2
		buffer_load_dwordx2 v[26:27], v2, s[0:3], 0 offen
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v36, v10
		v_cvt_f32_f16_sdwa v37, v10 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v38, v11
		v_cvt_f32_f16_sdwa v39, v11 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v40, v12
		v_cvt_f32_f16_sdwa v41, v12 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v42, v13
		v_cvt_f32_f16_sdwa v43, v13 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v44, v20
		v_cvt_f32_f16_sdwa v45, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v46, v21
		v_cvt_f32_f16_sdwa v47, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v48, v26
		v_cvt_f32_f16_sdwa v49, v26 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v50, v27
		v_cvt_f32_f16_sdwa v51, v27 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_lshlrev_b32_e32 v2, 1, v19
		v_mul_lo_u32 v3, s18, v23
		v_lshl_add_u32 v3, v3, 1, v2
		s_mov_b32 s0, s8
		s_mov_b32 s1, s9
		s_mov_b32 s2, s22
		s_mov_b32 s3, s23
		buffer_load_dwordx4 v[52:55], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v22
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[56:59], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v24
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[60:63], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v25
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[64:67], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v14
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[68:71], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v15
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[72:75], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v16
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[76:79], v3, s[0:3], 0 offen
		v_mul_lo_u32 v3, s18, v17
		v_lshl_add_u32 v3, v3, 1, v2
		buffer_load_dwordx4 v[80:83], v3, s[0:3], 0 offen
		s_barrier
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v10, v52
		v_cvt_f32_f16_sdwa v11, v52 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v12, v53
		v_cvt_f32_f16_sdwa v13, v53 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v18, v54
		v_cvt_f32_f16_sdwa v19, v54 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v20, v55
		v_cvt_f32_f16_sdwa v21, v55 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v26, v56
		v_cvt_f32_f16_sdwa v27, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v28, v57
		v_cvt_f32_f16_sdwa v29, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v34, v58
		v_cvt_f32_f16_sdwa v35, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v52, v59
		v_cvt_f32_f16_sdwa v53, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v54, v60
		v_cvt_f32_f16_sdwa v55, v60 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v56, v61
		v_cvt_f32_f16_sdwa v57, v61 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v58, v62
		v_cvt_f32_f16_sdwa v59, v62 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v60, v63
		v_cvt_f32_f16_sdwa v61, v63 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v62, v64
		v_cvt_f32_f16_sdwa v63, v64 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v84, v65
		v_cvt_f32_f16_sdwa v85, v65 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v66
		v_cvt_f32_f16_sdwa v65, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v67
		v_cvt_f32_f16_sdwa v87, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v66, v68
		v_cvt_f32_f16_sdwa v67, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v69
		v_cvt_f32_f16_sdwa v89, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v70
		v_cvt_f32_f16_sdwa v69, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v71
		v_cvt_f32_f16_sdwa v91, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v70, v72
		v_cvt_f32_f16_sdwa v71, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v92, v73
		v_cvt_f32_f16_sdwa v93, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v74
		v_cvt_f32_f16_sdwa v73, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v75
		v_cvt_f32_f16_sdwa v95, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v74, v76
		v_cvt_f32_f16_sdwa v75, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v77
		v_cvt_f32_f16_sdwa v97, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v76, v78
		v_cvt_f32_f16_sdwa v77, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v79
		v_cvt_f32_f16_sdwa v99, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v78, v80
		v_cvt_f32_f16_sdwa v79, v80 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v100, v81
		v_cvt_f32_f16_sdwa v101, v81 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v80, v82
		v_cvt_f32_f16_sdwa v81, v82 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v83
		v_cvt_f32_f16_sdwa v103, v83 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[82:83], v[36:37]
		v_mov_b64_e32 v[36:37], v[4:5]
		v_pk_add_f32 v[104:105], v[36:37], v[82:83]
		v_mov_b64_e32 v[4:5], v[38:39]
		v_mov_b64_e32 v[36:37], v[6:7]
		v_pk_add_f32 v[106:107], v[36:37], v[4:5]
		v_mov_b64_e32 v[6:7], v[40:41]
		v_mov_b64_e32 v[36:37], v[108:109]
		v_pk_add_f32 v[168:169], v[36:37], v[6:7]
		v_mov_b64_e32 v[36:37], v[42:43]
		v_mov_b64_e32 v[38:39], v[110:111]
		v_pk_add_f32 v[170:171], v[38:39], v[36:37]
		v_mov_b64_e32 v[38:39], v[44:45]
		v_mov_b64_e32 v[40:41], v[112:113]
		v_pk_add_f32 v[108:109], v[40:41], v[38:39]
		v_mov_b64_e32 v[40:41], v[46:47]
		v_mov_b64_e32 v[42:43], v[114:115]
		v_pk_add_f32 v[110:111], v[42:43], v[40:41]
		v_mov_b64_e32 v[42:43], v[48:49]
		v_mov_b64_e32 v[44:45], v[116:117]
		v_pk_add_f32 v[112:113], v[44:45], v[42:43]
		v_mov_b64_e32 v[44:45], v[50:51]
		v_mov_b64_e32 v[46:47], v[118:119]
		v_pk_add_f32 v[114:115], v[46:47], v[44:45]
		v_mov_b64_e32 v[46:47], v[120:121]
		v_pk_add_f32 v[48:49], v[46:47], v[82:83]
		v_mov_b64_e32 v[46:47], v[122:123]
		v_pk_add_f32 v[50:51], v[46:47], v[4:5]
		v_mov_b64_e32 v[46:47], v[124:125]
		v_pk_add_f32 v[116:117], v[46:47], v[6:7]
		v_mov_b64_e32 v[46:47], v[126:127]
		v_pk_add_f32 v[118:119], v[46:47], v[36:37]
		v_mov_b64_e32 v[46:47], v[128:129]
		v_pk_add_f32 v[120:121], v[46:47], v[38:39]
		v_mov_b64_e32 v[46:47], v[130:131]
		v_pk_add_f32 v[122:123], v[46:47], v[40:41]
		v_mov_b64_e32 v[46:47], v[132:133]
		v_pk_add_f32 v[124:125], v[46:47], v[42:43]
		v_mov_b64_e32 v[46:47], v[134:135]
		v_pk_add_f32 v[126:127], v[46:47], v[44:45]
		v_mov_b64_e32 v[46:47], v[136:137]
		v_pk_add_f32 v[128:129], v[46:47], v[82:83]
		v_mov_b64_e32 v[46:47], v[138:139]
		v_pk_add_f32 v[130:131], v[46:47], v[4:5]
		v_mov_b64_e32 v[46:47], v[140:141]
		v_pk_add_f32 v[132:133], v[46:47], v[6:7]
		v_mov_b64_e32 v[46:47], v[142:143]
		v_pk_add_f32 v[134:135], v[46:47], v[36:37]
		v_mov_b64_e32 v[46:47], v[144:145]
		v_pk_add_f32 v[136:137], v[46:47], v[38:39]
		v_mov_b64_e32 v[46:47], v[146:147]
		v_pk_add_f32 v[138:139], v[46:47], v[40:41]
		v_mov_b64_e32 v[46:47], v[148:149]
		v_pk_add_f32 v[140:141], v[46:47], v[42:43]
		v_mov_b64_e32 v[46:47], v[150:151]
		v_pk_add_f32 v[142:143], v[46:47], v[44:45]
		v_mov_b64_e32 v[46:47], v[152:153]
		v_pk_add_f32 v[144:145], v[46:47], v[82:83]
		v_mov_b64_e32 v[46:47], v[154:155]
		v_pk_add_f32 v[146:147], v[46:47], v[4:5]
		v_mov_b64_e32 v[4:5], v[156:157]
		v_pk_add_f32 v[148:149], v[4:5], v[6:7]
		v_mov_b64_e32 v[4:5], v[158:159]
		v_pk_add_f32 v[150:151], v[4:5], v[36:37]
		v_mov_b64_e32 v[4:5], v[160:161]
		v_pk_add_f32 v[152:153], v[4:5], v[38:39]
		v_mov_b64_e32 v[4:5], v[162:163]
		v_pk_add_f32 v[154:155], v[4:5], v[40:41]
		v_mov_b64_e32 v[4:5], v[164:165]
		v_pk_add_f32 v[36:37], v[4:5], v[42:43]
		v_mov_b64_e32 v[4:5], v[166:167]
		v_pk_add_f32 v[38:39], v[4:5], v[44:45]
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[104:107]
		ds_write_b128 v0, v[168:171] offset:8192
		ds_write_b128 v0, v[108:111] offset:16384
		ds_write_b128 v0, v[112:115] offset:24576
		v_lshlrev_b32_e32 v3, 9, v32
		v_lshl_add_u32 v3, v9, 4, v3
		v_and_b32_e32 v4, 1, v8
		v_lshl_add_u32 v3, v4, 14, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 1, v1
		v_lshl_add_u32 v1, v1, 13, v3
		v_lshl_add_u32 v1, v31, 11, v1
		v_lshl_add_u32 v1, v30, 10, v1
		ds_read_b128 v[4:7], v1
		ds_read_b128 v[40:43], v1 offset:256
		ds_read_b128 v[44:47], v1 offset:4096
		ds_read_b128 v[104:107], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[48:51]
		ds_write_b128 v0, v[116:119] offset:8192
		ds_write_b128 v0, v[120:123] offset:16384
		ds_write_b128 v0, v[124:127] offset:24576
		v_mov_b64_e32 v[8:9], v[4:5]
		v_pk_fma_f32 v[112:113], v[8:9], v[10:11], v[8:9]
		v_mov_b64_e32 v[4:5], v[6:7]
		v_pk_fma_f32 v[114:115], v[4:5], v[12:13], v[4:5]
		v_mov_b64_e32 v[4:5], v[40:41]
		v_pk_fma_f32 v[116:117], v[4:5], v[18:19], v[4:5]
		v_mov_b64_e32 v[4:5], v[42:43]
		v_pk_fma_f32 v[118:119], v[4:5], v[20:21], v[4:5]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v1
		ds_read_b128 v[8:11], v1 offset:256
		ds_read_b128 v[40:43], v1 offset:4096
		ds_read_b128 v[48:51], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[128:131]
		ds_write_b128 v0, v[132:135] offset:8192
		ds_write_b128 v0, v[136:139] offset:16384
		ds_write_b128 v0, v[140:143] offset:24576
		v_mov_b64_e32 v[12:13], v[44:45]
		v_pk_fma_f32 v[120:121], v[12:13], v[26:27], v[12:13]
		v_mov_b64_e32 v[12:13], v[46:47]
		v_pk_fma_f32 v[122:123], v[12:13], v[28:29], v[12:13]
		v_mov_b64_e32 v[12:13], v[104:105]
		v_pk_fma_f32 v[124:125], v[12:13], v[34:35], v[12:13]
		v_mov_b64_e32 v[12:13], v[106:107]
		v_pk_fma_f32 v[126:127], v[12:13], v[52:53], v[12:13]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[32:35], v1 offset:256
		ds_read_b128 v[44:47], v1 offset:4096
		ds_read_b128 v[104:107], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[144:147]
		ds_write_b128 v0, v[148:151] offset:8192
		ds_write_b128 v0, v[152:155] offset:16384
		ds_write_b128 v0, v[36:39] offset:24576
		v_mov_b64_e32 v[12:13], v[4:5]
		v_pk_fma_f32 v[128:129], v[12:13], v[54:55], v[12:13]
		v_mov_b64_e32 v[4:5], v[6:7]
		v_pk_fma_f32 v[130:131], v[4:5], v[56:57], v[4:5]
		v_mov_b64_e32 v[4:5], v[8:9]
		v_pk_fma_f32 v[132:133], v[4:5], v[58:59], v[4:5]
		v_mov_b64_e32 v[4:5], v[10:11]
		v_pk_fma_f32 v[134:135], v[4:5], v[60:61], v[4:5]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v1
		ds_read_b128 v[8:11], v1 offset:256
		ds_read_b128 v[36:39], v1 offset:4096
		ds_read_b128 v[52:55], v1 offset:4352
		v_mov_b64_e32 v[0:1], v[40:41]
		v_pk_fma_f32 v[136:137], v[0:1], v[62:63], v[0:1]
		v_mov_b64_e32 v[0:1], v[42:43]
		v_pk_fma_f32 v[138:139], v[0:1], v[84:85], v[0:1]
		v_mov_b64_e32 v[0:1], v[48:49]
		v_pk_fma_f32 v[140:141], v[0:1], v[64:65], v[0:1]
		v_mov_b64_e32 v[0:1], v[50:51]
		v_pk_fma_f32 v[142:143], v[0:1], v[86:87], v[0:1]
		v_mov_b64_e32 v[0:1], v[28:29]
		v_pk_fma_f32 v[56:57], v[0:1], v[66:67], v[0:1]
		v_mov_b64_e32 v[0:1], v[30:31]
		v_pk_fma_f32 v[58:59], v[0:1], v[88:89], v[0:1]
		v_mov_b64_e32 v[0:1], v[32:33]
		v_pk_fma_f32 v[60:61], v[0:1], v[68:69], v[0:1]
		v_mov_b64_e32 v[0:1], v[34:35]
		v_pk_fma_f32 v[62:63], v[0:1], v[90:91], v[0:1]
		v_mov_b64_e32 v[0:1], v[44:45]
		v_pk_fma_f32 v[144:145], v[0:1], v[70:71], v[0:1]
		v_mov_b64_e32 v[0:1], v[46:47]
		v_pk_fma_f32 v[146:147], v[0:1], v[92:93], v[0:1]
		v_mov_b64_e32 v[0:1], v[104:105]
		v_pk_fma_f32 v[148:149], v[0:1], v[72:73], v[0:1]
		v_mov_b64_e32 v[0:1], v[106:107]
		v_pk_fma_f32 v[150:151], v[0:1], v[94:95], v[0:1]
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[0:1], v[4:5]
		v_pk_fma_f32 v[40:41], v[0:1], v[74:75], v[0:1]
		v_mov_b64_e32 v[0:1], v[6:7]
		v_pk_fma_f32 v[42:43], v[0:1], v[96:97], v[0:1]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[0:1], v[8:9]
		v_pk_fma_f32 v[44:45], v[0:1], v[76:77], v[0:1]
		v_mov_b64_e32 v[0:1], v[10:11]
		v_pk_fma_f32 v[46:47], v[0:1], v[98:99], v[0:1]
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[0:1], v[36:37]
		v_pk_fma_f32 v[64:65], v[0:1], v[78:79], v[0:1]
		v_mov_b64_e32 v[0:1], v[38:39]
		v_pk_fma_f32 v[66:67], v[0:1], v[100:101], v[0:1]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[0:1], v[52:53]
		v_pk_fma_f32 v[68:69], v[0:1], v[80:81], v[0:1]
		v_mov_b64_e32 v[0:1], v[54:55]
		v_pk_fma_f32 v[70:71], v[0:1], v[102:103], v[0:1]
		v_cvt_pk_f16_f32 v4, v112, v113
		v_cvt_pk_f16_f32 v5, v114, v115
		v_cvt_pk_f16_f32 v6, v116, v117
		v_cvt_pk_f16_f32 v7, v118, v119
		v_mul_lo_u32 v0, s19, v23
		v_lshl_add_u32 v0, v0, 1, v2
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, s22
		s_mov_b32 s3, s23
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v22
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		v_cvt_pk_f16_f32 v6, v124, v125
		v_cvt_pk_f16_f32 v7, v126, v127
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v24
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v128, v129
		v_cvt_pk_f16_f32 v5, v130, v131
		v_cvt_pk_f16_f32 v6, v132, v133
		v_cvt_pk_f16_f32 v7, v134, v135
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v25
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v136, v137
		v_cvt_pk_f16_f32 v5, v138, v139
		v_cvt_pk_f16_f32 v6, v140, v141
		v_cvt_pk_f16_f32 v7, v142, v143
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v14
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v56, v57
		v_cvt_pk_f16_f32 v5, v58, v59
		v_cvt_pk_f16_f32 v6, v60, v61
		v_cvt_pk_f16_f32 v7, v62, v63
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v15
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v144, v145
		v_cvt_pk_f16_f32 v5, v146, v147
		v_cvt_pk_f16_f32 v6, v148, v149
		v_cvt_pk_f16_f32 v7, v150, v151
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v16
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v40, v41
		v_cvt_pk_f16_f32 v5, v42, v43
		v_cvt_pk_f16_f32 v6, v44, v45
		v_cvt_pk_f16_f32 v7, v46, v47
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
		v_mul_lo_u32 v0, s19, v17
		v_lshl_add_u32 v0, v0, 1, v2
		v_cvt_pk_f16_f32 v4, v64, v65
		v_cvt_pk_f16_f32 v5, v66, v67
		v_cvt_pk_f16_f32 v6, v68, v69
		v_cvt_pk_f16_f32 v7, v70, v71
		buffer_store_dwordx4 v[4:7], v0, s[0:3], 0 offen
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
		.amdhsa_next_free_vgpr 172
		.amdhsa_next_free_sgpr 34
		.amdhsa_accum_offset 172
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
	.set .Ltlx_addmm_glu_kernel_optimized.num_vgpr, 172
	.set .Ltlx_addmm_glu_kernel_optimized.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 34
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
    .sgpr_count:     34
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized.kd
    .uses_dynamic_stack: false
    .vgpr_count:     172
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
