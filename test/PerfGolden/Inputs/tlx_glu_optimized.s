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
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v9
		v_mad_u32_u24 v3, v3, 16, v10
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v10, 1, v9
		v_mad_u32_u24 v3, v10, 64, v3
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v12, 1, v11
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v14, 1, v13
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_add3_u32 v3, v3, v12, v15
		v_lshrrev_b32_e32 v14, 8, v0
		v_and_b32_e32 v16, 1, v14
		v_mad_u32_u24 v3, v16, 4, v3
		v_and_b32_e32 v17, 15, v9
		v_add_u32_e32 v18, 0x50, v17
		v_add_u32_e32 v19, 0x60, v17
		v_add_u32_e32 v20, 0x70, v17
		v_add_u32_e32 v21, s1, v3
		s_mov_b32 s16, 0
		v_cmp_lt_i32_e64 vcc, v21, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v22, v21, -1, 1
		v_add3_u32 v3, 8, v3, s1
		v_cndmask_b32_e32 v21, v21, v22, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s22, -1
		s_mov_b32 s23, -1
		s_mov_b32 s24, 0
		s_mov_b32 s25, 0
		s_cselect_b32 s26, s22, s24
		s_cselect_b32 s27, s23, s25
		s_xor_b32 s28, s12, -1
		s_add_i32 s28, s28, 1
		v_mov_b32_e32 v22, s12
		v_mov_b32_e32 v23, s28
		v_cndmask_b32_e64 v22, v22, v23, s[26:27]
		v_cvt_f32_u32_e32 v23, v22
		v_rcp_iflag_f32_e32 v23, v23
		s_nop 0
		v_mul_f32_e32 v23, v2, v23
		v_cvt_u32_f32_e32 v23, v23
		v_xad_u32 v24, v22, -1, 1
		v_mul_lo_u32 v25, v24, v23
		v_mul_hi_u32 v25, v23, v25
		v_add_u32_e32 v23, v23, v25
		v_mul_hi_u32 v25, v21, v23
		v_mul_lo_u32 v25, v25, v22
		v_xor_b32_e32 v25, -1, v25
		v_add3_u32 v21, 1, v25, v21
		v_add_u32_e32 v25, v21, v24
		v_add_u32_e32 v26, s1, v17
		v_cmp_ge_u32_e64 vcc, v21, v22
		s_nop 1
		v_cndmask_b32_e32 v21, v21, v25, vcc
		v_add_u32_e32 v25, v21, v24
		v_add3_u32 v27, 16, v17, s1
		v_cmp_ge_u32_e64 vcc, v21, v22
		s_nop 1
		v_cndmask_b32_e32 v21, v21, v25, vcc
		v_xad_u32 v25, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v3, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v28, v3, -1, 1
		v_add3_u32 v29, 32, v17, s1
		v_cndmask_b32_e32 v3, v3, v28, vcc
		v_mul_hi_u32 v28, v3, v23
		v_mul_lo_u32 v28, v28, v22
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v3, 1, v28, v3
		v_add_u32_e32 v28, v3, v24
		v_add3_u32 v30, 48, v17, s1
		v_cmp_ge_u32_e64 vcc, v3, v22
		s_nop 1
		v_cndmask_b32_e32 v3, v3, v28, vcc
		v_add_u32_e32 v28, v3, v24
		v_add3_u32 v17, 64, v17, s1
		v_cmp_ge_u32_e64 vcc, v3, v22
		s_nop 1
		v_cndmask_b32_e32 v3, v3, v28, vcc
		v_xad_u32 v28, v3, -1, 1
		v_cmp_lt_i32_e64 vcc, v26, s16
		s_mov_b64 s[28:29], vcc
		v_xad_u32 v31, v26, -1, 1
		v_add_u32_e32 v18, s1, v18
		v_cndmask_b32_e32 v26, v26, v31, vcc
		v_mul_hi_u32 v31, v26, v23
		v_mul_lo_u32 v31, v31, v22
		v_xor_b32_e32 v31, -1, v31
		v_add3_u32 v26, 1, v31, v26
		v_add_u32_e32 v31, v26, v24
		v_add_u32_e32 v19, s1, v19
		v_cmp_ge_u32_e64 vcc, v26, v22
		s_nop 1
		v_cndmask_b32_e32 v26, v26, v31, vcc
		v_add_u32_e32 v31, v26, v24
		v_add_u32_e32 v20, s1, v20
		v_cmp_ge_u32_e64 vcc, v26, v22
		s_nop 1
		v_cndmask_b32_e32 v26, v26, v31, vcc
		v_xad_u32 v31, v26, -1, 1
		v_cmp_lt_i32_e64 vcc, v27, s16
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v32, v27, -1, 1
		v_cndmask_b32_e64 v21, v21, v25, s[20:21]
		v_cndmask_b32_e32 v25, v27, v32, vcc
		v_mul_hi_u32 v27, v25, v23
		v_mul_lo_u32 v27, v27, v22
		v_xor_b32_e32 v27, -1, v27
		v_add3_u32 v25, 1, v27, v25
		v_add_u32_e32 v27, v25, v24
		v_cndmask_b32_e64 v3, v3, v28, s[26:27]
		v_cmp_ge_u32_e64 vcc, v25, v22
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_add_u32_e32 v27, v25, v24
		v_cndmask_b32_e64 v26, v26, v31, s[28:29]
		v_cmp_ge_u32_e64 vcc, v25, v22
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v27, vcc
		v_xad_u32 v27, v25, -1, 1
		v_cmp_lt_i32_e64 vcc, v29, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v28, v29, -1, 1
		v_cndmask_b32_e64 v25, v25, v27, s[30:31]
		v_cndmask_b32_e32 v27, v29, v28, vcc
		v_mul_hi_u32 v28, v27, v23
		v_mul_lo_u32 v28, v28, v22
		v_xor_b32_e32 v28, -1, v28
		v_add3_u32 v27, 1, v28, v27
		v_add_u32_e32 v28, v27, v24
		v_and_b32_e32 v29, 1, v11
		v_cmp_ge_u32_e64 vcc, v27, v22
		s_nop 1
		v_cndmask_b32_e32 v27, v27, v28, vcc
		v_add_u32_e32 v28, v27, v24
		v_and_b32_e32 v13, 1, v13
		v_cmp_ge_u32_e64 vcc, v27, v22
		s_nop 1
		v_cndmask_b32_e32 v27, v27, v28, vcc
		v_xad_u32 v28, v27, -1, 1
		v_cmp_lt_i32_e64 vcc, v30, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v31, v30, -1, 1
		v_cndmask_b32_e64 v27, v27, v28, s[20:21]
		v_cndmask_b32_e32 v28, v30, v31, vcc
		v_mul_hi_u32 v30, v28, v23
		v_mul_lo_u32 v30, v30, v22
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v28, 1, v30, v28
		v_add_u32_e32 v30, v28, v24
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v31, s17, v14
		v_cmp_ge_u32_e64 vcc, v28, v22
		s_nop 1
		v_cndmask_b32_e32 v28, v28, v30, vcc
		v_add_u32_e32 v30, v28, v24
		v_mul_lo_u32 v32, s15, v3
		v_cmp_ge_u32_e64 vcc, v28, v22
		s_nop 1
		v_cndmask_b32_e32 v28, v28, v30, vcc
		v_xad_u32 v30, v28, -1, 1
		v_cmp_lt_i32_e64 vcc, v17, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v33, v17, -1, 1
		v_cndmask_b32_e64 v28, v28, v30, s[26:27]
		v_cndmask_b32_e32 v17, v17, v33, vcc
		v_mul_hi_u32 v30, v17, v23
		v_mul_lo_u32 v30, v30, v22
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v17, 1, v30, v17
		v_add_u32_e32 v30, v17, v24
		v_lshrrev_b32_e32 v33, 1, v0
		v_cmp_ge_u32_e64 vcc, v17, v22
		s_nop 1
		v_cndmask_b32_e32 v17, v17, v30, vcc
		v_add_u32_e32 v30, v17, v24
		v_lshrrev_b32_e32 v34, 2, v0
		v_cmp_ge_u32_e64 vcc, v17, v22
		s_nop 1
		v_cndmask_b32_e32 v17, v17, v30, vcc
		v_xad_u32 v30, v17, -1, 1
		v_cmp_lt_i32_e64 vcc, v18, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v35, v18, -1, 1
		v_cndmask_b32_e64 v17, v17, v30, s[20:21]
		v_cndmask_b32_e32 v18, v18, v35, vcc
		v_mul_hi_u32 v30, v18, v23
		v_mul_lo_u32 v30, v30, v22
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v18, 1, v30, v18
		v_add_u32_e32 v30, v18, v24
		v_and_b32_e32 v35, 1, v0
		v_cmp_ge_u32_e64 vcc, v18, v22
		s_nop 1
		v_cndmask_b32_e32 v18, v18, v30, vcc
		v_add_u32_e32 v30, v18, v24
		v_mov_b32_e32 v36, s13
		v_cmp_ge_u32_e64 vcc, v18, v22
		s_nop 1
		v_cndmask_b32_e32 v18, v18, v30, vcc
		v_xad_u32 v30, v18, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v37, v19, -1, 1
		v_cndmask_b32_e64 v18, v18, v30, s[26:27]
		v_cndmask_b32_e32 v19, v19, v37, vcc
		v_mul_hi_u32 v30, v19, v23
		v_mul_lo_u32 v30, v30, v22
		v_xor_b32_e32 v30, -1, v30
		v_add3_u32 v19, 1, v30, v19
		v_add_u32_e32 v30, v19, v24
		s_xor_b32 s1, s13, -1
		v_cmp_ge_u32_e64 vcc, v19, v22
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v30, vcc
		v_add_u32_e32 v30, v19, v24
		v_and_b32_e32 v37, 15, v8
		v_cmp_ge_u32_e64 vcc, v19, v22
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v30, vcc
		v_xad_u32 v30, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s16
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v38, v20, -1, 1
		v_cndmask_b32_e64 v19, v19, v30, s[20:21]
		v_cndmask_b32_e32 v20, v20, v38, vcc
		v_mul_hi_u32 v23, v20, v23
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v23, -1, v23
		v_add3_u32 v20, 1, v23, v20
		v_add_u32_e32 v23, v20, v24
		v_and_b32_e32 v30, 31, v0
		v_cmp_ge_u32_e64 vcc, v20, v22
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v23, vcc
		v_add_u32_e32 v23, v20, v24
		s_mul_i32 s0, s0, 0x100
		v_cmp_ge_u32_e64 vcc, v20, v22
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v23, vcc
		v_xad_u32 v22, v20, -1, 1
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v37
		v_add_u32_e32 v24, 0x80, v23
		v_add_u32_e32 v37, 0xc0, v23
		v_mad_u32_u24 v30, v30, 8, s0
		v_cmp_lt_i32_e64 vcc, v30, s16
		s_mov_b64 s[20:21], vcc
		v_xad_u32 v38, v30, -1, 1
		v_cndmask_b32_e64 v20, v20, v22, s[26:27]
		v_cndmask_b32_e32 v22, v30, v38, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s22, s24
		s_cselect_b32 s13, s23, s25
		s_add_i32 s1, s1, 1
		v_mov_b32_e32 v30, s1
		v_cndmask_b32_e64 v30, v36, v30, s[12:13]
		v_cvt_f32_u32_e32 v36, v30
		v_rcp_iflag_f32_e32 v36, v36
		s_nop 0
		v_mul_f32_e32 v2, v2, v36
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v36, v30, -1, 1
		v_mul_lo_u32 v38, v36, v2
		v_mul_hi_u32 v38, v2, v38
		v_add_u32_e32 v2, v2, v38
		v_mul_hi_u32 v38, v22, v2
		v_mul_lo_u32 v38, v38, v30
		v_xor_b32_e32 v38, -1, v38
		v_add3_u32 v22, 1, v38, v22
		v_add_u32_e32 v38, v22, v36
		v_add_u32_e32 v39, s0, v23
		v_cmp_ge_u32_e64 vcc, v22, v30
		s_nop 1
		v_cndmask_b32_e32 v22, v22, v38, vcc
		v_add_u32_e32 v38, v22, v36
		v_add3_u32 v23, 64, v23, s0
		v_cmp_ge_u32_e64 vcc, v22, v30
		s_nop 1
		v_cndmask_b32_e32 v22, v22, v38, vcc
		v_xad_u32 v38, v22, -1, 1
		v_cmp_lt_i32_e64 vcc, v39, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v40, v39, -1, 1
		v_add_u32_e32 v24, s0, v24
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_mul_hi_u32 v40, v39, v2
		v_mul_lo_u32 v40, v40, v30
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v39, 1, v40, v39
		v_add_u32_e32 v40, v39, v36
		v_add_u32_e32 v37, s0, v37
		v_cmp_ge_u32_e64 vcc, v39, v30
		s_nop 1
		v_cndmask_b32_e32 v39, v39, v40, vcc
		v_add_u32_e32 v40, v39, v36
		v_cndmask_b32_e64 v22, v22, v38, s[20:21]
		v_cmp_ge_u32_e64 vcc, v39, v30
		s_nop 1
		v_cndmask_b32_e32 v38, v39, v40, vcc
		v_xad_u32 v39, v38, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v40, v23, -1, 1
		v_cndmask_b32_e64 v38, v38, v39, s[12:13]
		v_cndmask_b32_e32 v23, v23, v40, vcc
		v_mul_hi_u32 v39, v23, v2
		v_mul_lo_u32 v39, v39, v30
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v23, 1, v39, v23
		v_add_u32_e32 v39, v23, v36
		v_mul_lo_u32 v40, s15, v21
		v_cmp_ge_u32_e64 vcc, v23, v30
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v39, vcc
		v_add_u32_e32 v39, v23, v36
		s_mov_b32 s22, 0x7fffffff
		v_cmp_ge_u32_e64 vcc, v23, v30
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v39, vcc
		v_xad_u32 v39, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s16
		s_mov_b64 s[12:13], vcc
		v_xad_u32 v41, v24, -1, 1
		v_cndmask_b32_e64 v23, v23, v39, s[0:1]
		v_cndmask_b32_e32 v24, v24, v41, vcc
		v_mul_hi_u32 v39, v24, v2
		v_mul_lo_u32 v39, v39, v30
		v_xor_b32_e32 v39, -1, v39
		v_add3_u32 v24, 1, v39, v24
		v_add_u32_e32 v39, v24, v36
		v_mov_b32_e32 v41, 16
		v_mul_lo_u32 v41, v41, v10
		v_cmp_ge_u32_e64 vcc, v24, v30
		s_nop 1
		v_cndmask_b32_e32 v10, v24, v39, vcc
		v_add_u32_e32 v24, v10, v36
		v_and_b32_e32 v39, 7, v0
		v_cmp_ge_u32_e64 vcc, v10, v30
		s_nop 1
		v_cndmask_b32_e32 v10, v10, v24, vcc
		v_xad_u32 v24, v10, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s16
		s_mov_b64 s[0:1], vcc
		v_xad_u32 v42, v37, -1, 1
		v_cndmask_b32_e64 v10, v10, v24, s[12:13]
		v_cndmask_b32_e32 v24, v37, v42, vcc
		v_mul_hi_u32 v2, v24, v2
		v_mul_lo_u32 v2, v2, v30
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v24
		v_add_u32_e32 v24, v2, v36
		s_mov_b32 s12, 63
		v_cmp_ge_u32_e64 vcc, v2, v30
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v24, vcc
		v_add_u32_e32 v24, v2, v36
		s_add_i32 s13, s14, 63
		v_cmp_ge_u32_e64 vcc, v2, v30
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v24, vcc
		v_xad_u32 v24, v2, -1, 1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s12, s12, 0
		s_add_i32 s12, s13, s12
		v_mov_b32_e32 v30, 8
		v_mul_lo_u32 v30, v30, v39
		v_add3_u32 v12, v41, v12, v15
		v_mad_u32_u24 v12, v16, 8, v12
		v_add_u32_e32 v15, 4, v12
		v_add_u32_e32 v16, 32, v12
		v_add_u32_e32 v36, 36, v12
		v_cmp_lt_i32_e64 vcc, v30, s14
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v37, 4, v35
		v_lshl_add_u32 v39, v40, 1, v37
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v40, 6, v34
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v41, 5, v33
		v_add3_u32 v39, v39, v40, v41
		v_mov_b32_e32 v42, 0x80000000
		v_cndmask_b32_e32 v43, v42, v39, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s2, 0x420, s2
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v43, s[20:23], 0 offen lds
		v_cndmask_b32_e64 v2, v2, v24, s[0:1]
		v_lshl_add_u32 v24, v32, 1, v37
		v_add3_u32 v24, v24, v40, v41
		s_add_i32 m0, s2, 0x2100
		v_cndmask_b32_e32 v32, v42, v24, vcc
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		s_ashr_i32 s0, s12, 6
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v31, v31, 4, v22
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v13, v13, 2, v31
		v_mul_lo_u32 v29, s17, v29
		v_lshl_add_u32 v13, v29, 1, v13
		v_and_b32_e32 v29, 1, v9
		v_mul_lo_u32 v29, s17, v29
		v_lshl_add_u32 v13, v29, 5, v13
		s_add_i32 m0, s2, 0xc5e0
		v_cmp_lt_i32_e64 vcc, v12, s14
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v29, v42, v13, s[4:5]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_lshl_b32 s1, s17, 3
		v_add_u32_e32 v29, s1, v13
		s_add_i32 m0, s2, 0xe6e0
		v_cmp_lt_i32_e64 vcc, v15, s14
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v29, v42, v29, s[4:5]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_lshl_b32 s1, s17, 6
		v_add_u32_e32 v29, s1, v13
		s_add_i32 m0, s2, 0x107e0
		v_cmp_lt_i32_e64 vcc, v16, s14
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v29, v42, v29, s[4:5]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s1, 0x48, s17
		v_add_u32_e32 v29, s1, v13
		v_cmp_lt_i32_e64 vcc, v36, s14
		s_add_i32 m0, s2, 0x128e0
		s_nop 0
		v_cndmask_b32_e32 v29, v42, v29, vcc
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_add3_u32 v29, v37, v40, v41
		s_add_i32 s1, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v30, s1
		v_add_u32_e32 v31, 0x80, v39
		s_mul_i32 s3, 0xc0, s17
		s_add_i32 m0, s2, 0x4200
		v_cndmask_b32_e32 v31, v42, v31, vcc
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		v_add_u32_e32 v31, 0x80, v24
		s_add_i32 m0, s2, 0x6300
		v_cndmask_b32_e32 v31, v42, v31, vcc
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_lshl_b32 s4, s17, 7
		v_add_u32_e32 v31, s4, v13
		s_add_i32 m0, s2, 0x149e0
		v_cmp_lt_i32_e64 vcc, v12, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v31, v42, v31, s[4:5]
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_mul_i32 s4, 0x88, s17
		v_add_u32_e32 v31, s4, v13
		s_add_i32 m0, s2, 0x16ae0
		v_cmp_lt_i32_e64 vcc, v15, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v31, v42, v31, s[4:5]
		v_add_u32_e32 v32, s3, v13
		v_cmp_lt_i32_e64 vcc, v16, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v32, v42, v32, s[4:5]
		s_mul_i32 s3, 0xc8, s17
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x18be0
		v_add_u32_e32 v31, s3, v13
		v_cmp_lt_i32_e64 vcc, v36, s1
		s_nop 1
		v_cndmask_b32_e32 v31, v42, v31, vcc
		v_and_b32_e32 v11, 3, v11
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ace0
		s_add_i32 s1, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v30, s1
		v_add_u32_e32 v32, 0x100, v39
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_and_b32_e32 v31, 63, v0
		v_cndmask_b32_e32 v32, v42, v32, vcc
		s_add_i32 m0, s2, 0x8400
		v_add_u32_e32 v24, 0x100, v24
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		v_cndmask_b32_e32 v24, v42, v24, vcc
		s_add_i32 m0, s2, 0xa500
		s_lshl_b32 s3, s17, 8
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_add_u32_e32 v24, s3, v13
		s_add_i32 m0, s2, 0x1cde0
		v_cmp_lt_i32_e64 vcc, v12, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v24, v42, v24, s[4:5]
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s3, 0x108, s17
		v_add_u32_e32 v24, s3, v13
		s_add_i32 m0, s2, 0x1eee0
		v_cmp_lt_i32_e64 vcc, v15, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v24, v42, v24, s[4:5]
		s_mul_i32 s3, 0x140, s17
		v_add_u32_e32 v32, s3, v13
		v_cmp_lt_i32_e64 vcc, v16, s1
		s_mov_b64 s[4:5], vcc
		v_cndmask_b32_e64 v32, v42, v32, s[4:5]
		s_mul_i32 s3, 0x148, s17
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x20fe0
		v_add_u32_e32 v24, s3, v13
		v_cmp_lt_i32_e64 vcc, v36, s1
		s_nop 1
		v_cndmask_b32_e32 v24, v42, v24, vcc
		v_lshlrev_b32_e32 v14, 7, v14
		v_lshrrev_b32_e32 v37, 4, v31
		v_lshlrev_b32_e32 v39, 4, v37
		v_and_b32_e32 v40, 15, v31
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x230e0
		v_mov_b32_e32 v32, 0x420
		v_mul_lo_u32 v32, v32, v40
		v_add3_u32 v41, v14, v39, v32
		v_lshrrev_b32_e32 v31, 5, v31
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[44:47], v41
		ds_read_b128 v[48:51], v41 offset:64
		ds_read_b128 v[52:55], v41 offset:256
		ds_read_b128 v[56:59], v41 offset:320
		ds_read_b128 v[60:63], v41 offset:512
		ds_read_b128 v[64:67], v41 offset:576
		ds_read_b128 v[68:71], v41 offset:768
		ds_read_b128 v[72:75], v41 offset:832
		v_lshlrev_b32_e32 v24, 9, v31
		v_lshrrev_b32_e32 v31, 2, v40
		v_mov_b32_e32 v43, 0x420
		v_mul_lo_u32 v43, v43, v31
		v_lshlrev_b32_e32 v11, 5, v11
		v_add3_u32 v31, v24, v43, v11
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v76, 0x1080
		v_mul_lo_u32 v76, v76, v37
		v_and_b32_e32 v37, 3, v40
		v_lshlrev_b32_e32 v37, 3, v37
		v_add3_u32 v31, v31, v76, v37
		ds_read_b64_tr_b16 v[80:81], v31 offset:50656
		ds_read_b64_tr_b16 v[82:83], v31 offset:59104
		v_add_u32_e32 v40, 0x10000, v24
		v_add3_u32 v40, v40, v43, v11
		v_add3_u32 v40, v40, v76, v37
		ds_read_b64_tr_b16 v[84:85], v40 offset:2016
		ds_read_b64_tr_b16 v[86:87], v40 offset:10464
		ds_read_b64_tr_b16 v[88:89], v31 offset:50784
		ds_read_b64_tr_b16 v[90:91], v31 offset:59232
		ds_read_b64_tr_b16 v[92:93], v40 offset:2144
		ds_read_b64_tr_b16 v[94:95], v40 offset:10592
		ds_read_b64_tr_b16 v[96:97], v31 offset:50912
		ds_read_b64_tr_b16 v[98:99], v31 offset:59360
		ds_read_b64_tr_b16 v[100:101], v40 offset:2272
		ds_read_b64_tr_b16 v[102:103], v40 offset:10720
		ds_read_b64_tr_b16 v[104:105], v31 offset:51040
		ds_read_b64_tr_b16 v[106:107], v31 offset:59488
		ds_read_b64_tr_b16 v[108:109], v40 offset:2400
		ds_read_b64_tr_b16 v[110:111], v40 offset:10848
		s_add_i32 s1, s0, -3
		v_add_u32_e32 v29, 0x180, v29
		s_lshl_b32 s3, s15, 1
		v_mul_lo_u32 v21, s3, v21
		v_add_u32_e32 v40, v29, v21
		v_mul_lo_u32 v3, s3, v3
		v_add_u32_e32 v21, v29, v3
		s_mul_i32 s3, 0x180, s17
		s_mul_i32 s4, 0x188, s17
		s_mul_i32 s5, 0x1c0, s17
		s_mul_i32 s12, 0x1c8, s17
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
		s_cmp_lt_i32 0, s1
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized.loop_head_0:
		s_add_i32 s13, s16, 3
		s_mul_i32 s13, s13, 64
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
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s14, s13
		v_cmp_lt_i32_e64 vcc, v30, s13
		s_lshl_b32 s15, s16, 7
		s_mul_hi_u32 s28, s16, 0xaaaaaaab
		v_cndmask_b32_e32 v3, v42, v40, vcc
		s_lshr_b32 s28, s28, 1
		s_mul_i32 s28, s28, 3
		s_xor_b32 s28, s28, -1
		s_add_i32 s28, s28, 1
		s_add_i32 s28, s16, s28
		s_mul_i32 s29, 0x4200, s28
		s_add_i32 s29, s2, s29
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], s15 offen lds
		s_mul_i32 s28, 0x8400, s28
		s_add_i32 m0, s29, 0x2100
		v_cndmask_b32_e32 v3, v42, v21, vcc
		buffer_load_dwordx4 v3, s[20:23], s15 offen lds
		s_mul_i32 s15, s17, s16
		s_lshl_b32 s15, s15, 7
		s_add_i32 s29, s3, s15
		v_add_u32_e32 v3, s29, v13
		s_add_i32 s28, s2, s28
		s_add_i32 m0, s28, 0xc5e0
		v_cmp_lt_i32_e64 vcc, v12, s13
		s_mov_b64 s[30:31], vcc
		v_cndmask_b32_e64 v3, v42, v3, s[30:31]
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s15, v13
		v_add_u32_e32 v29, s4, v3
		s_add_i32 m0, s28, 0xe6e0
		v_cmp_lt_i32_e64 vcc, v15, s13
		s_mov_b64 s[30:31], vcc
		v_cndmask_b32_e64 v29, v42, v29, s[30:31]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_add_u32_e32 v29, s5, v3
		s_add_i32 m0, s28, 0x107e0
		v_cmp_lt_i32_e64 vcc, v16, s13
		s_mov_b64 s[30:31], vcc
		v_cndmask_b32_e64 v29, v42, v29, s[30:31]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s12, v3
		v_cmp_lt_i32_e64 vcc, v36, s13
		s_add_i32 m0, s28, 0x128e0
		s_nop 0
		v_cndmask_b32_e32 v3, v42, v3, vcc
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_add_i32 s16, s16, 1
		s_mul_hi_u32 s13, s16, 0xaaaaaaab
		s_lshr_b32 s13, s13, 1
		s_mul_i32 s13, s13, 3
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s16, s13
		s_mul_i32 s15, 0x4200, s13
		v_add_u32_e32 v3, s15, v14
		v_add3_u32 v3, v3, v39, v32
		ds_read_b128 v[44:47], v3
		ds_read_b128 v[48:51], v3 offset:64
		ds_read_b128 v[52:55], v3 offset:256
		ds_read_b128 v[56:59], v3 offset:320
		ds_read_b128 v[60:63], v3 offset:512
		ds_read_b128 v[64:67], v3 offset:576
		ds_read_b128 v[68:71], v3 offset:768
		ds_read_b128 v[72:75], v3 offset:832
		s_mul_i32 s13, 0x8400, s13
		v_add_u32_e32 v3, s13, v24
		v_add3_u32 v3, v3, v43, v11
		v_add3_u32 v3, v3, v76, v37
		ds_read_b64_tr_b16 v[80:81], v3 offset:50656
		ds_read_b64_tr_b16 v[82:83], v3 offset:59104
		s_add_i32 s13, s13, 0x10000
		v_add_u32_e32 v29, s13, v24
		v_add3_u32 v29, v29, v43, v11
		v_add3_u32 v29, v29, v76, v37
		ds_read_b64_tr_b16 v[84:85], v29 offset:2016
		ds_read_b64_tr_b16 v[86:87], v29 offset:10464
		ds_read_b64_tr_b16 v[88:89], v3 offset:50784
		ds_read_b64_tr_b16 v[90:91], v3 offset:59232
		ds_read_b64_tr_b16 v[92:93], v29 offset:2144
		ds_read_b64_tr_b16 v[94:95], v29 offset:10592
		ds_read_b64_tr_b16 v[96:97], v3 offset:50912
		ds_read_b64_tr_b16 v[98:99], v3 offset:59360
		ds_read_b64_tr_b16 v[100:101], v29 offset:2272
		ds_read_b64_tr_b16 v[102:103], v29 offset:10720
		ds_read_b64_tr_b16 v[104:105], v3 offset:51040
		ds_read_b64_tr_b16 v[106:107], v3 offset:59488
		ds_read_b64_tr_b16 v[108:109], v29 offset:2400
		ds_read_b64_tr_b16 v[110:111], v29 offset:10848
		s_waitcnt vmcnt(6) lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s16, s1
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized.loop_head_0
.Ltlx_addmm_glu_kernel_optimized.loop_exit_0:
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, s22
		s_mov_b32 s15, s23
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s22
		s_mov_b32 s7, s23
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_waitcnt vmcnt(0) lgkmcnt(14)
		s_barrier
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
		s_lshr_b32 s8, s1, 16
		s_mul_i32 s9, s3, 0xaaab
		s_mul_i32 s3, s3, 0xaaaa
		s_mul_i32 s10, s8, 0xaaab
		s_mul_i32 s8, s8, 0xaaaa
		s_lshr_b32 s9, s9, 16
		s_and_b32 s11, s3, 0xffff
		s_and_b32 s16, s10, 0xffff
		s_add_i32 s9, s9, s11
		s_add_i32 s9, s9, s16
		s_lshr_b32 s3, s3, 16
		s_add_i32 s3, s8, s3
		s_lshr_b32 s8, s10, 16
		s_add_i32 s3, s3, s8
		s_lshr_b32 s8, s9, 16
		s_add_i32 s3, s3, s8
		s_lshr_b32 s3, s3, 1
		s_mul_i32 s3, s3, 3
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s1, s1, s3
		s_xor_b32 s3, s1, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s1, s3, s1
		s_mul_i32 s2, 0x4200, s1
		v_add_u32_e32 v3, s2, v41
		ds_read_b128 v[12:15], v3
		ds_read_b128 v[44:47], v3 offset:64
		ds_read_b128 v[48:51], v3 offset:256
		ds_read_b128 v[52:55], v3 offset:320
		ds_read_b128 v[56:59], v3 offset:512
		ds_read_b128 v[60:63], v3 offset:576
		ds_read_b128 v[64:67], v3 offset:768
		ds_read_b128 v[68:71], v3 offset:832
		s_barrier
		s_mul_i32 s1, 0x8400, s1
		v_add_u32_e32 v3, s1, v31
		ds_read_b64_tr_b16 v[72:73], v3 offset:50656
		ds_read_b64_tr_b16 v[74:75], v3 offset:59104
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v11, s1, v31
		ds_read_b64_tr_b16 v[76:77], v11 offset:2016
		ds_read_b64_tr_b16 v[78:79], v11 offset:10464
		ds_read_b64_tr_b16 v[80:81], v3 offset:50784
		ds_read_b64_tr_b16 v[82:83], v3 offset:59232
		ds_read_b64_tr_b16 v[84:85], v11 offset:2144
		ds_read_b64_tr_b16 v[86:87], v11 offset:10592
		ds_read_b64_tr_b16 v[88:89], v3 offset:50912
		ds_read_b64_tr_b16 v[90:91], v3 offset:59360
		ds_read_b64_tr_b16 v[92:93], v11 offset:2272
		ds_read_b64_tr_b16 v[94:95], v11 offset:10720
		ds_read_b64_tr_b16 v[96:97], v3 offset:51040
		ds_read_b64_tr_b16 v[98:99], v3 offset:59488
		ds_read_b64_tr_b16 v[100:101], v11 offset:2400
		ds_read_b64_tr_b16 v[102:103], v11 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[12:15], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[12:15], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[12:15], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[44:47], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[100:103], v[44:47], v[120:123]
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
		s_mul_i32 s8, s2, 0xaaab
		s_mul_i32 s2, s2, 0xaaaa
		s_mul_i32 s9, s3, 0xaaab
		s_mul_i32 s3, s3, 0xaaaa
		s_lshr_b32 s8, s8, 16
		s_and_b32 s10, s2, 0xffff
		s_and_b32 s11, s9, 0xffff
		s_add_i32 s8, s8, s10
		s_add_i32 s8, s8, s11
		s_lshr_b32 s2, s2, 16
		s_add_i32 s2, s3, s2
		s_lshr_b32 s3, s9, 16
		s_add_i32 s2, s2, s3
		s_lshr_b32 s3, s8, 16
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
		v_add_u32_e32 v3, s1, v41
		ds_read_b128 v[12:15], v3
		ds_read_b128 v[40:43], v3 offset:64
		ds_read_b128 v[44:47], v3 offset:256
		ds_read_b128 v[48:51], v3 offset:320
		ds_read_b128 v[52:55], v3 offset:512
		ds_read_b128 v[56:59], v3 offset:576
		ds_read_b128 v[60:63], v3 offset:768
		ds_read_b128 v[64:67], v3 offset:832
		s_mul_i32 s0, 0x8400, s0
		v_add_u32_e32 v3, s0, v31
		ds_read_b64_tr_b16 v[68:69], v3 offset:50656
		ds_read_b64_tr_b16 v[70:71], v3 offset:59104
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v11, s0, v31
		ds_read_b64_tr_b16 v[72:73], v11 offset:2016
		ds_read_b64_tr_b16 v[74:75], v11 offset:10464
		ds_read_b64_tr_b16 v[76:77], v3 offset:50784
		ds_read_b64_tr_b16 v[78:79], v3 offset:59232
		ds_read_b64_tr_b16 v[80:81], v11 offset:2144
		ds_read_b64_tr_b16 v[82:83], v11 offset:10592
		ds_read_b64_tr_b16 v[84:85], v3 offset:50912
		ds_read_b64_tr_b16 v[86:87], v3 offset:59360
		ds_read_b64_tr_b16 v[88:89], v11 offset:2272
		ds_read_b64_tr_b16 v[90:91], v11 offset:10720
		ds_read_b64_tr_b16 v[92:93], v3 offset:51040
		ds_read_b64_tr_b16 v[94:95], v3 offset:59488
		ds_read_b64_tr_b16 v[96:97], v11 offset:2400
		ds_read_b64_tr_b16 v[98:99], v11 offset:10848
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[12:15], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[12:15], v[112:115]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[12:15], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[60:63], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[60:63], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		s_nop 7
		v_mov_b64_e32 v[12:13], v[4:5]
		v_mov_b64_e32 v[4:5], v[6:7]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[40:43], v[112:115]
		s_nop 7
		v_mov_b64_e32 v[6:7], v[112:113]
		v_mov_b64_e32 v[14:15], v[114:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[40:43], v[116:119]
		s_nop 7
		v_mov_b64_e32 v[30:31], v[116:117]
		v_mov_b64_e32 v[36:37], v[118:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[40:43], v[120:123]
		s_nop 7
		v_mov_b64_e32 v[40:41], v[120:121]
		v_mov_b64_e32 v[42:43], v[122:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		s_nop 7
		v_mov_b64_e32 v[44:45], v[136:137]
		v_mov_b64_e32 v[46:47], v[138:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		s_nop 7
		v_mov_b64_e32 v[52:53], v[124:125]
		v_mov_b64_e32 v[54:55], v[126:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		s_nop 7
		v_mov_b64_e32 v[60:61], v[128:129]
		v_mov_b64_e32 v[62:63], v[130:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		s_nop 7
		v_mov_b64_e32 v[48:49], v[132:133]
		v_mov_b64_e32 v[50:51], v[134:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		s_nop 7
		v_mov_b64_e32 v[68:69], v[148:149]
		v_mov_b64_e32 v[70:71], v[150:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		s_nop 7
		v_mov_b64_e32 v[76:77], v[140:141]
		v_mov_b64_e32 v[78:79], v[142:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		s_nop 7
		v_mov_b64_e32 v[84:85], v[144:145]
		v_mov_b64_e32 v[86:87], v[146:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		s_nop 7
		v_mov_b64_e32 v[56:57], v[152:153]
		v_mov_b64_e32 v[58:59], v[154:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		s_nop 7
		v_mov_b64_e32 v[92:93], v[168:169]
		v_mov_b64_e32 v[94:95], v[170:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		s_nop 7
		v_mov_b64_e32 v[72:73], v[156:157]
		v_mov_b64_e32 v[74:75], v[158:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		s_nop 7
		v_mov_b64_e32 v[80:81], v[160:161]
		v_mov_b64_e32 v[82:83], v[162:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		s_nop 7
		v_mov_b64_e32 v[64:65], v[164:165]
		v_mov_b64_e32 v[66:67], v[166:167]
		v_lshlrev_b32_e32 v3, 1, v38
		buffer_load_dwordx2 v[38:39], v3, s[12:15], 0 offen
		v_lshlrev_b32_e32 v3, 1, v23
		buffer_load_dwordx2 v[88:89], v3, s[12:15], 0 offen
		v_lshlrev_b32_e32 v3, 1, v10
		buffer_load_dwordx2 v[10:11], v3, s[12:15], 0 offen
		v_lshlrev_b32_e32 v2, 1, v2
		buffer_load_dwordx2 v[90:91], v2, s[12:15], 0 offen
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v96, v38
		v_cvt_f32_f16_sdwa v97, v38 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v39
		v_cvt_f32_f16_sdwa v99, v39 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[2:3], v[96:97]
		v_mov_b64_e32 v[38:39], v[98:99]
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v96, v88
		v_cvt_f32_f16_sdwa v97, v88 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v89
		v_cvt_f32_f16_sdwa v99, v89 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[88:89], v[96:97]
		v_mov_b64_e32 v[96:97], v[98:99]
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v100, v10
		v_cvt_f32_f16_sdwa v101, v10 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v11
		v_cvt_f32_f16_sdwa v103, v11 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[10:11], v[100:101]
		v_mov_b64_e32 v[98:99], v[102:103]
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v100, v90
		v_cvt_f32_f16_sdwa v101, v90 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v91
		v_cvt_f32_f16_sdwa v103, v91 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[90:91], v[100:101]
		v_mov_b64_e32 v[100:101], v[102:103]
		v_mul_lo_u32 v16, s18, v26
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[104:107], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v25
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[108:111], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v27
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[112:115], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v28
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[116:119], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v17
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[120:123], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v18
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[124:127], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v19
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[128:131], v16, s[4:7], 0 offen
		v_mul_lo_u32 v16, s18, v20
		v_lshl_add_u32 v16, v16, 1, v22
		buffer_load_dwordx4 v[132:135], v16, s[4:7], 0 offen
		s_barrier
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v102, v104
		v_cvt_f32_f16_sdwa v103, v104 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v136, v105
		v_cvt_f32_f16_sdwa v137, v105 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v106
		v_cvt_f32_f16_sdwa v105, v106 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v138, v107
		v_cvt_f32_f16_sdwa v139, v107 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v106, v108
		v_cvt_f32_f16_sdwa v107, v108 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v140, v109
		v_cvt_f32_f16_sdwa v141, v109 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v108, v110
		v_cvt_f32_f16_sdwa v109, v110 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v142, v111
		v_cvt_f32_f16_sdwa v143, v111 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v110, v112
		v_cvt_f32_f16_sdwa v111, v112 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v144, v113
		v_cvt_f32_f16_sdwa v145, v113 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v112, v114
		v_cvt_f32_f16_sdwa v113, v114 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v146, v115
		v_cvt_f32_f16_sdwa v147, v115 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v114, v116
		v_cvt_f32_f16_sdwa v115, v116 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v148, v117
		v_cvt_f32_f16_sdwa v149, v117 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v116, v118
		v_cvt_f32_f16_sdwa v117, v118 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v150, v119
		v_cvt_f32_f16_sdwa v151, v119 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v118, v120
		v_cvt_f32_f16_sdwa v119, v120 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v152, v121
		v_cvt_f32_f16_sdwa v153, v121 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v120, v122
		v_cvt_f32_f16_sdwa v121, v122 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v154, v123
		v_cvt_f32_f16_sdwa v155, v123 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v122, v124
		v_cvt_f32_f16_sdwa v123, v124 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v156, v125
		v_cvt_f32_f16_sdwa v157, v125 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v124, v126
		v_cvt_f32_f16_sdwa v125, v126 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v158, v127
		v_cvt_f32_f16_sdwa v159, v127 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v126, v128
		v_cvt_f32_f16_sdwa v127, v128 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v160, v129
		v_cvt_f32_f16_sdwa v161, v129 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v128, v130
		v_cvt_f32_f16_sdwa v129, v130 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v162, v131
		v_cvt_f32_f16_sdwa v163, v131 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v130, v132
		v_cvt_f32_f16_sdwa v131, v132 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v164, v133
		v_cvt_f32_f16_sdwa v165, v133 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v132, v134
		v_cvt_f32_f16_sdwa v133, v134 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v166, v135
		v_cvt_f32_f16_sdwa v167, v135 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[168:169], v[12:13], v[2:3]
		v_pk_add_f32 v[170:171], v[4:5], v[38:39]
		v_pk_add_f32 v[172:173], v[6:7], v[88:89]
		v_pk_add_f32 v[174:175], v[14:15], v[96:97]
		v_pk_add_f32 v[4:5], v[30:31], v[10:11]
		v_pk_add_f32 v[6:7], v[36:37], v[98:99]
		v_pk_add_f32 v[12:13], v[40:41], v[90:91]
		v_pk_add_f32 v[14:15], v[42:43], v[100:101]
		v_pk_add_f32 v[40:41], v[52:53], v[2:3]
		v_pk_add_f32 v[42:43], v[54:55], v[38:39]
		v_pk_add_f32 v[52:53], v[60:61], v[88:89]
		v_pk_add_f32 v[54:55], v[62:63], v[96:97]
		v_pk_add_f32 v[60:61], v[48:49], v[10:11]
		v_pk_add_f32 v[62:63], v[50:51], v[98:99]
		v_pk_add_f32 v[48:49], v[44:45], v[90:91]
		v_pk_add_f32 v[50:51], v[46:47], v[100:101]
		v_pk_add_f32 v[44:45], v[76:77], v[2:3]
		v_pk_add_f32 v[46:47], v[78:79], v[38:39]
		v_pk_add_f32 v[76:77], v[84:85], v[88:89]
		v_pk_add_f32 v[78:79], v[86:87], v[96:97]
		v_pk_add_f32 v[84:85], v[68:69], v[10:11]
		v_pk_add_f32 v[86:87], v[70:71], v[98:99]
		v_pk_add_f32 v[68:69], v[56:57], v[90:91]
		v_pk_add_f32 v[70:71], v[58:59], v[100:101]
		v_pk_add_f32 v[56:57], v[72:73], v[2:3]
		v_pk_add_f32 v[58:59], v[74:75], v[38:39]
		v_pk_add_f32 v[36:37], v[80:81], v[88:89]
		v_pk_add_f32 v[38:39], v[82:83], v[96:97]
		v_pk_add_f32 v[72:73], v[64:65], v[10:11]
		v_pk_add_f32 v[74:75], v[66:67], v[98:99]
		v_pk_add_f32 v[64:65], v[92:93], v[90:91]
		v_pk_add_f32 v[66:67], v[94:95], v[100:101]
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[168:171]
		ds_write_b128 v0, v[172:175] offset:8192
		ds_write_b128 v0, v[4:7] offset:16384
		ds_write_b128 v0, v[12:15] offset:24576
		v_lshlrev_b32_e32 v2, 9, v35
		v_lshl_add_u32 v2, v9, 4, v2
		v_and_b32_e32 v3, 1, v8
		v_lshl_add_u32 v2, v3, 14, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 1, v1
		v_lshl_add_u32 v1, v1, 13, v2
		v_lshl_add_u32 v1, v34, 11, v1
		v_lshl_add_u32 v1, v33, 10, v1
		ds_read_b128 v[4:7], v1
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[2:3], v[4:5]
		v_mov_b64_e32 v[4:5], v[6:7]
		ds_read_b128 v[8:11], v1 offset:256
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[8:9]
		v_mov_b64_e32 v[8:9], v[10:11]
		ds_read_b128 v[12:15], v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[10:11], v[12:13]
		v_mov_b64_e32 v[12:13], v[14:15]
		ds_read_b128 v[32:35], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[14:15], v[32:33]
		v_mov_b64_e32 v[30:31], v[34:35]
		s_barrier
		ds_write_b128 v0, v[40:43]
		ds_write_b128 v0, v[52:55] offset:8192
		ds_write_b128 v0, v[60:63] offset:16384
		ds_write_b128 v0, v[48:51] offset:24576
		v_pk_fma_f32 v[48:49], v[2:3], v[102:103], v[2:3]
		v_pk_fma_f32 v[50:51], v[4:5], v[136:137], v[4:5]
		v_pk_fma_f32 v[52:53], v[6:7], v[104:105], v[6:7]
		v_pk_fma_f32 v[54:55], v[8:9], v[138:139], v[8:9]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v1
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[2:3], v[4:5]
		v_mov_b64_e32 v[4:5], v[6:7]
		ds_read_b128 v[32:35], v1 offset:256
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[32:33]
		v_mov_b64_e32 v[8:9], v[34:35]
		ds_read_b128 v[32:35], v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[40:41], v[32:33]
		v_mov_b64_e32 v[32:33], v[34:35]
		ds_read_b128 v[60:63], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[34:35], v[60:61]
		v_mov_b64_e32 v[42:43], v[62:63]
		s_barrier
		ds_write_b128 v0, v[44:47]
		ds_write_b128 v0, v[76:79] offset:8192
		ds_write_b128 v0, v[84:87] offset:16384
		ds_write_b128 v0, v[68:71] offset:24576
		v_pk_fma_f32 v[80:81], v[10:11], v[106:107], v[10:11]
		v_pk_fma_f32 v[82:83], v[12:13], v[140:141], v[12:13]
		v_pk_fma_f32 v[84:85], v[14:15], v[108:109], v[14:15]
		v_pk_fma_f32 v[86:87], v[30:31], v[142:143], v[30:31]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v1
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[10:11], v[12:13]
		v_mov_b64_e32 v[12:13], v[14:15]
		ds_read_b128 v[44:47], v1 offset:256
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[14:15], v[44:45]
		v_mov_b64_e32 v[30:31], v[46:47]
		ds_read_b128 v[44:47], v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[60:61], v[44:45]
		v_mov_b64_e32 v[44:45], v[46:47]
		ds_read_b128 v[68:71], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[46:47], v[68:69]
		v_mov_b64_e32 v[62:63], v[70:71]
		s_barrier
		ds_write_b128 v0, v[56:59]
		ds_write_b128 v0, v[36:39] offset:8192
		ds_write_b128 v0, v[72:75] offset:16384
		ds_write_b128 v0, v[64:67] offset:24576
		v_pk_fma_f32 v[64:65], v[2:3], v[110:111], v[2:3]
		v_pk_fma_f32 v[66:67], v[4:5], v[144:145], v[4:5]
		v_pk_fma_f32 v[68:69], v[6:7], v[112:113], v[6:7]
		v_pk_fma_f32 v[70:71], v[8:9], v[146:147], v[8:9]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v1
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[2:3], v[4:5]
		v_mov_b64_e32 v[4:5], v[6:7]
		ds_read_b128 v[36:39], v1 offset:256
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[36:37]
		v_mov_b64_e32 v[8:9], v[38:39]
		ds_read_b128 v[36:39], v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[56:57], v[36:37]
		v_mov_b64_e32 v[36:37], v[38:39]
		ds_read_b128 v[72:75], v1 offset:4352
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[0:1], v[72:73]
		v_mov_b64_e32 v[38:39], v[74:75]
		v_pk_fma_f32 v[72:73], v[40:41], v[114:115], v[40:41]
		v_pk_fma_f32 v[74:75], v[32:33], v[148:149], v[32:33]
		v_pk_fma_f32 v[76:77], v[34:35], v[116:117], v[34:35]
		v_pk_fma_f32 v[78:79], v[42:43], v[150:151], v[42:43]
		v_pk_fma_f32 v[88:89], v[10:11], v[118:119], v[10:11]
		v_pk_fma_f32 v[90:91], v[12:13], v[152:153], v[12:13]
		v_pk_fma_f32 v[92:93], v[14:15], v[120:121], v[14:15]
		v_pk_fma_f32 v[94:95], v[30:31], v[154:155], v[30:31]
		v_pk_fma_f32 v[96:97], v[60:61], v[122:123], v[60:61]
		v_pk_fma_f32 v[98:99], v[44:45], v[156:157], v[44:45]
		v_pk_fma_f32 v[100:101], v[46:47], v[124:125], v[46:47]
		v_pk_fma_f32 v[102:103], v[62:63], v[158:159], v[62:63]
		v_pk_fma_f32 v[40:41], v[2:3], v[126:127], v[2:3]
		v_pk_fma_f32 v[42:43], v[4:5], v[160:161], v[4:5]
		v_pk_fma_f32 v[44:45], v[6:7], v[128:129], v[6:7]
		v_pk_fma_f32 v[46:47], v[8:9], v[162:163], v[8:9]
		v_pk_fma_f32 v[8:9], v[56:57], v[130:131], v[56:57]
		v_pk_fma_f32 v[10:11], v[36:37], v[164:165], v[36:37]
		v_pk_fma_f32 v[12:13], v[0:1], v[132:133], v[0:1]
		v_pk_fma_f32 v[14:15], v[38:39], v[166:167], v[38:39]
		v_cvt_pk_f16_f32 v0, v48, v49
		v_cvt_pk_f16_f32 v1, v50, v51
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		v_mul_lo_u32 v4, s19, v26
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		v_mul_lo_u32 v4, s19, v25
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v64, v65
		v_cvt_pk_f16_f32 v1, v66, v67
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		v_mul_lo_u32 v4, s19, v27
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		v_mul_lo_u32 v4, s19, v28
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		v_mul_lo_u32 v4, s19, v17
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		v_mul_lo_u32 v4, s19, v18
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v40, v41
		v_cvt_pk_f16_f32 v1, v42, v43
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		v_mul_lo_u32 v4, s19, v19
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
		s_nop 1
		v_cvt_pk_f16_f32 v0, v8, v9
		v_cvt_pk_f16_f32 v1, v10, v11
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_mul_lo_u32 v4, s19, v20
		v_lshl_add_u32 v4, v4, 1, v22
		buffer_store_dwordx4 v[0:3], v4, s[24:27], 0 offen
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
		.amdhsa_next_free_sgpr 32
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
	.set .Ltlx_addmm_glu_kernel_optimized.numbered_sgpr, 32
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
    .sgpr_count:     32
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
