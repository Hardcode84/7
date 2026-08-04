	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	_a4w4_kernel
	.p2align	8
	.type	_a4w4_kernel,@function
_a4w4_kernel:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .L_a4w4_kernel.kernarg_preload_entry
	.p2align	8
.L_a4w4_kernel.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s18, s[0:1], 0x3c
		s_load_dword s19, s[0:1], 0x40
		s_add_i32 s0, s12, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s12, s1, 0
		s_add_i32 s0, s0, s12
		s_ashr_i32 s0, s0, 8
		s_add_i32 s12, s13, 0xff
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s12, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s12, s16, 7
		s_lshr_b32 s13, s16, 3
		s_cmp_lt_i32 s12, 8
		s_cbranch_scc0 .L_a4w4_kernel.if_else_0
		s_mul_i32 s12, s12, 32
		s_add_i32 s16, s12, s13
		s_branch .L_a4w4_kernel.if_end_0
.L_a4w4_kernel.if_else_0:
		s_add_i32 s12, s12, -8
		s_mul_i32 s12, s12, 31
		s_add_i32 s12, s12, 0x100
		s_add_i32 s16, s12, s13
.L_a4w4_kernel.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s12, 1, 0
		s_xor_b32 s13, s16, -1
		s_add_i32 s13, s13, 1
		s_cmp_lg_u32 s12, 0
		s_cselect_b32 s12, s13, s16
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s20, s1, -1
		s_add_i32 s20, s20, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, s20, s1
		v_mov_b32_e32 v1, s20
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s21, s20, -1
		v_readfirstlane_b32 s22, v1
		s_add_i32 s21, s21, 1
		s_mul_i32 s23, s21, s22
		s_mul_hi_u32 s23, s22, s23
		s_add_i32 s22, s22, s23
		s_mul_hi_u32 s22, s12, s22
		s_mul_i32 s23, s22, s20
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s12, s12, s23
		s_cmp_ge_u32 s12, s20
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s12, s21
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s12, s24, s12
		s_cmp_ge_u32 s12, s20
		s_cselect_b32 s20, 1, 0
		s_add_i32 s23, s22, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s23, s22
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s1, s16, s1
		s_xor_b32 s16, s20, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s16, s20
		s_mul_i32 s16, s1, 4
		s_xor_b32 s20, s16, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s20, s12, s21
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s12, s20, s12
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s12, s20, s12
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s20, s12
		s_cselect_b32 s20, 1, 0
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s0
		v_mov_b32_e32 v1, s21
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s22, s21, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s22, s22, 1
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s23, s23, s21
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s13, s23
		s_add_i32 s24, s23, s22
		s_cmp_ge_u32 s23, s21
		s_cselect_b32 s23, s24, s23
		s_add_i32 s24, s23, s22
		s_cmp_ge_u32 s23, s21
		s_cselect_b32 s23, s24, s23
		s_xor_b32 s24, s23, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s24, s23
		s_add_i32 s16, s16, s20
		s_mul_i32 s16, s16, 0x100
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s24, s23, s21
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s13, s13, s24
		s_cmp_ge_u32 s13, s21
		s_cselect_b32 s24, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s24, 1, 0
		s_add_i32 s22, s13, s22
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s13, s22, s13
		s_add_i32 s22, s23, 1
		s_cmp_ge_u32 s13, s21
		s_cselect_b32 s13, s22, s23
		s_xor_b32 s0, s12, s0
		s_xor_b32 s12, s13, -1
		s_add_i32 s12, s12, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s12, s13
		s_mul_i32 s12, s16, s14
		s_mul_i32 s13, s0, 0x100
		s_add_u32 s24, s2, s12
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s21, v0
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s22, 0x420, s21
		s_mov_b32 m0, s22
		v_lshrrev_b32_e32 v1, 6, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v4, 1, v3
		v_mul_lo_u32 v5, s14, v4
		v_lshl_add_u32 v2, v5, 6, v2
		v_lshrrev_b32_e32 v5, 4, v0
		v_accvgpr_write_b32 a0, v5
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v5, 1, v5
		v_mul_lo_u32 v6, s14, v5
		v_lshl_add_u32 v2, v6, 5, v2
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v7, s14, v6
		v_lshlrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v8, 1, v0
		v_lshlrev_b32_e32 v9, 4, v8
		v_add3_u32 v2, v2, v7, v9
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v10, 6, v7
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v12, 5, v11
		v_add3_u32 v2, v2, v10, v12
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s23, s14, 2
		v_add_u32_e32 v13, s23, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_mov_b32 s30, -1
		s_mov_b32 s31, -1
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s32, s14, 3
		v_add_u32_e32 v14, s32, v2
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_mul_i32 s13, s13, s15
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s33, 12, s14
		v_add_u32_e32 v15, s33, v2
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_mul_i32 s34, 0x84, s14
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s35, s14, 7
		v_add_u32_e32 v16, s35, v2
		s_mul_i32 s36, 0x88, s14
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		v_mul_lo_u32 v17, s15, v5
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v18, s34, v2
		s_mul_i32 s14, 0x8c, s14
		s_mul_i32 s37, 12, s15
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_mul_lo_u32 v19, s15, v4
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v20, s36, v2
		s_mul_i32 s38, 0x84, s15
		s_mul_i32 s39, 0x88, s15
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		v_mul_lo_u32 v21, s15, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v22, s14, v2
		v_lshl_add_u32 v19, v19, 6, v21
		v_lshl_add_u32 v17, v17, 5, v19
		v_and_b32_e32 v1, 1, v1
		v_accvgpr_write_b32 a1, v1
		s_mul_i32 s40, 0x8c, s15
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_add_u32 s44, s4, s13
		s_addc_u32 s45, s5, 0
		s_add_i32 m0, m0, 0x9460
		v_mul_lo_u32 v1, s15, v6
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, v17, v1, v9
		v_add3_u32 v1, v1, v10, v12
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dwordx4 v1, s[44:47], 0 offen lds
		s_lshl_b32 s41, s15, 2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v17, s41, v1
		s_lshl_b32 s42, s15, 3
		buffer_load_dwordx4 v17, s[44:47], 0 offen lds
		v_add_u32_e32 v19, s42, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v21, s37, v1
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v23, s18, v3
		v_mul_lo_u32 v3, s19, v3
		buffer_load_dwordx4 v19, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v24, 3, v8
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		buffer_load_dwordx4 v21, s[44:47], 0 offen lds
		v_add3_u32 v25, s1, v23, v24
		v_lshlrev_b32_e32 v26, 7, v5
		v_lshlrev_b32_e32 v27, 6, v6
		v_add3_u32 v25, v25, v26, v27
		v_lshlrev_b32_e32 v28, 5, v7
		v_lshlrev_b32_e32 v29, 4, v11
		v_add3_u32 v25, v25, v28, v29
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		buffer_load_dwordx2 v[30:31], v25, s[48:51], 0 offen
		s_lshl_b32 s20, s0, 8
		v_lshlrev_b32_e32 v8, 2, v8
		v_add3_u32 v32, s20, v3, v8
		v_lshlrev_b32_e32 v33, 6, v5
		v_lshlrev_b32_e32 v34, 5, v6
		v_add3_u32 v32, v32, v33, v34
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshlrev_b32_e32 v35, 3, v11
		v_add3_u32 v32, v32, v7, v35
		s_mov_b32 s52, s10
		s_mov_b32 s53, s11
		s_mov_b32 s54, s26
		s_mov_b32 s55, s27
		buffer_load_dword v36, v32, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_lshl_b32 s15, s15, 7
		v_add_u32_e32 v37, s15, v1
		buffer_load_dwordx4 v37, s[44:47], 0 offen lds
		v_add_u32_e32 v38, s38, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v39, s39, v1
		v_add_u32_e32 v40, s40, v1
		v_add_u32_e32 v41, 0x80, v2
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		v_add_u32_e32 v42, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v43, s32, v42
		v_add_u32_e32 v44, s33, v42
		v_add_u32_e32 v42, s35, v42
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		v_lshrrev_b32_e32 v45, 7, v0
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s32, s20, 0x80
		v_add3_u32 v46, s32, v3, v8
		v_add3_u32 v46, v46, v33, v34
		buffer_load_dwordx4 v40, s[44:47], 0 offen lds
		v_add3_u32 v46, v46, v7, v35
		buffer_load_dword v47, v46, s[52:55], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s23, s23, 0x80
		v_add_u32_e32 v48, s23, v2
		buffer_load_dwordx4 v41, s[24:27], 0 offen lds
		v_add_u32_e32 v49, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v50, s34, v49
		v_add_u32_e32 v51, s36, v49
		v_add_u32_e32 v49, s14, v49
		buffer_load_dwordx4 v48, s[24:27], 0 offen lds
		v_add_u32_e32 v52, 0x80, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v53, 0x80, v1
		v_add_u32_e32 v54, s41, v53
		v_add_u32_e32 v55, s42, v53
		buffer_load_dwordx4 v43, s[24:27], 0 offen lds
		v_add_u32_e32 v53, s37, v53
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v56, 0x80, v1
		v_add_u32_e32 v57, s38, v56
		v_lshlrev_b32_e32 v58, 7, v45
		v_lshlrev_b32_e32 v45, 4, v45
		buffer_load_dwordx4 v44, s[24:27], 0 offen lds
		v_add_u32_e32 v45, 0x20000, v45
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v45, v45, v24
		v_lshl_add_u32 v45, v4, 9, v45
		v_lshl_add_u32 v5, v5, 8, v45
		buffer_load_dwordx4 v42, s[24:27], 0 offen lds
		v_add3_u32 v5, v5, v27, v28
		s_add_i32 m0, m0, 0x1080
		v_lshl_add_u32 v5, v11, 10, v5
		v_and_b32_e32 v45, 63, v0
		v_lshrrev_b32_e32 v59, 4, v45
		v_accvgpr_write_b32 a2, v59
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v59, a2
		v_lshlrev_b32_e32 v59, 4, v59
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s13, 0x100
		v_and_b32_e32 v60, 15, v45
		v_add_u32_e32 v61, 0x10000, v59
		buffer_load_dwordx4 v51, s[24:27], 0 offen lds
		v_mov_b32_e32 v62, 0x420
		v_mul_lo_u32 v62, v62, v60
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v58, v58, v59, v62
		s_add_i32 s13, s15, 0x80
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		v_add_u32_e32 v59, s13, v1
		s_add_i32 m0, m0, 0x5260
		v_accvgpr_read_b32 v60, a1
		v_lshlrev_b32_e32 v60, 7, v60
		v_add3_u32 v60, v61, v60, v62
		v_lshlrev_b32_e32 v61, 3, v0
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		v_add_u32_e32 v61, 0x20000, v61
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s13, s19, 3
		v_lshlrev_b32_e32 v62, 2, v0
		v_add_u32_e32 v62, 0x20000, v62
		buffer_load_dwordx4 v54, s[44:47], 0 offen lds
		v_add_u32_e32 v63, 0x20000, v24
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s15, s18, 3
		v_accvgpr_read_b32 v64, a1
		v_lshl_add_u32 v63, v64, 4, v63
		v_lshlrev_b32_e32 v64, 8, v4
		v_add3_u32 v63, v63, v64, v26
		v_add3_u32 v63, v63, v27, v28
		v_lshl_add_u32 v11, v11, 9, v63
		buffer_load_dwordx4 v55, s[44:47], 0 offen lds
		s_mov_b32 s23, 0
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s1, s15
		v_add3_u32 v23, s1, v23, v24
		v_add3_u32 v23, v23, v26, v27
		buffer_load_dwordx4 v53, s[44:47], 0 offen lds
		v_add3_u32 v23, v23, v28, v29
		buffer_load_dwordx2 v[26:27], v23, s[48:51], 0 offen
		s_add_i32 s1, s20, s13
		v_add3_u32 v24, s1, v3, v8
		v_add3_u32 v24, v24, v33, v34
		v_add3_u32 v24, v24, v7, v35
		buffer_load_dword v28, v24, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_mul_i32 s1, s19, 16
		buffer_load_dwordx4 v59, s[44:47], 0 offen lds
		s_mul_i32 s15, s18, 16
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s18, s12, 0x100
		buffer_load_dwordx4 v57, s[44:47], 0 offen lds
		v_add_u32_e32 v29, s39, v56
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s12, s32, s13
		v_add3_u32 v3, s12, v3, v8
		v_add3_u32 v3, v3, v33, v34
		buffer_load_dwordx4 v29, s[44:47], 0 offen lds
		v_add3_u32 v3, v3, v7, v35
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v7, s40, v56
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		buffer_load_dword v8, v3, s[52:55], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 a[4:7], v58
		ds_read_b128 a[8:11], v58 offset:64
		ds_read_b128 a[12:15], v58 offset:256
		ds_read_b128 a[16:19], v58 offset:320
		ds_read_b128 a[20:23], v58 offset:512
		ds_read_b128 a[24:27], v58 offset:576
		ds_read_b128 a[28:31], v58 offset:768
		ds_read_b128 a[32:35], v58 offset:832
		ds_read_b128 a[36:39], v58 offset:16896
		ds_read_b128 a[40:43], v58 offset:16960
		ds_read_b128 a[44:47], v58 offset:17152
		ds_read_b128 a[48:51], v58 offset:17216
		ds_read_b128 a[52:55], v58 offset:17408
		ds_read_b128 a[56:59], v58 offset:17472
		ds_read_b128 a[60:63], v58 offset:17664
		ds_read_b128 a[64:67], v58 offset:17728
		ds_read_b128 a[68:71], v60 offset:2016
		ds_read_b128 a[72:75], v60 offset:2080
		ds_read_b128 a[76:79], v60 offset:2272
		ds_read_b128 a[80:83], v60 offset:2336
		ds_read_b128 a[84:87], v60 offset:2528
		ds_read_b128 a[88:91], v60 offset:2592
		ds_read_b128 a[92:95], v60 offset:2784
		ds_read_b128 a[96:99], v60 offset:2848
		s_waitcnt vmcnt(25)
		ds_write_b64 v61, v[30:31] offset:4000
		s_waitcnt vmcnt(24)
		ds_write_b32 v62, v36 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[30:31], v5 offset:4000
		ds_read_b64_tr_b8 v[34:35], v5 offset:4128
		ds_read_b64_tr_b8 v[64:65], v11 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[56:57], s[28:29]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_0
		s_barrier
.L_a4w4_kernel.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		s_setprio 0
		s_mov_b32 s12, s15
		s_mov_b32 s13, s1
		s_add_u32 s32, s2, s18
		s_addc_u32 s33, s3, 0
		s_add_u32 s36, s4, s14
		s_addc_u32 s37, s5, 0
		s_add_u32 s40, s8, s12
		s_addc_u32 s41, s9, 0
		s_add_u32 s44, s10, s13
		s_addc_u32 s45, s11, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
.L_a4w4_kernel.loop_head_0:
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v64, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v64, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v64, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v64, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v65, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v65, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v65, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v65, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v65, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v65, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v65, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v65, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v64, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v64, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v64, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v64, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v64, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v64, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v64, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v64, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v65, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v65, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v65, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v65, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v65, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v65, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v65, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v65, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v64, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v64, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v64, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v64, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt vmcnt(1)
		ds_read_b128 a[68:71], v60 offset:35776
		ds_read_b128 a[72:75], v60 offset:35840
		ds_read_b128 a[76:79], v60 offset:36032
		ds_read_b128 a[80:83], v60 offset:36096
		ds_read_b128 a[84:87], v60 offset:36288
		ds_read_b128 a[88:91], v60 offset:36352
		ds_read_b128 a[92:95], v60 offset:36544
		ds_read_b128 a[96:99], v60 offset:36608
		s_barrier
		ds_write_b32 v62, v47 offset:6048
		s_add_u32 s32, s2, s18
		s_addc_u32 s33, s3, 0
		s_mov_b32 m0, s22
		s_add_u32 s36, s4, s14
		s_addc_u32 s37, s5, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[64:65], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s44, s10, s13
		s_addc_u32 s45, s11, 0
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_u32 s40, s8, s12
		s_addc_u32 s41, s9, 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v22, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9460
		s_nop 0
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		buffer_load_dwordx2 v[66:67], v25, s[40:43], 0 offen
		buffer_load_dword v33, v32, s[44:47], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v64, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v64, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v64, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v64, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v65, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v65, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v65, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v65, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], a[8:11], v[208:211], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], a[16:19], v[224:227], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v65, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v65, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v65, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v65, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[96:99], a[24:27], v[240:243], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[96:99], a[32:35], v[248:251], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v64, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v64, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v64, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v64, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v64, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v64, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v64, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v64, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[40:43], a[108:111], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[40:43], a[112:115], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[48:51], a[128:131], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[48:51], a[124:127], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v65, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v65, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v65, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v65, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[40:43], a[116:119], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[40:43], a[120:123], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[48:51], a[136:139], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[48:51], a[132:135], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v65, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v65, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v65, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v65, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[56:59], a[148:151], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[56:59], a[152:155], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[64:67], a[168:171], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[64:67], a[164:167], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v64, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v64, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v64, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v64, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[56:59], a[140:143], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[56:59], a[144:147], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[64:67], a[160:163], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[64:67], a[156:159], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[4:7], v58 offset:33792
		ds_read_b128 a[8:11], v58 offset:33856
		ds_read_b128 a[12:15], v58 offset:34048
		ds_read_b128 a[16:19], v58 offset:34112
		ds_read_b128 a[20:23], v58 offset:34304
		ds_read_b128 a[24:27], v58 offset:34368
		ds_read_b128 a[28:31], v58 offset:34560
		ds_read_b128 a[32:35], v58 offset:34624
		ds_read_b128 a[36:39], v58 offset:50688
		ds_read_b128 a[40:43], v58 offset:50752
		ds_read_b128 a[44:47], v58 offset:50944
		ds_read_b128 a[48:51], v58 offset:51008
		ds_read_b128 a[52:55], v58 offset:51200
		ds_read_b128 a[56:59], v58 offset:51264
		ds_read_b128 a[60:63], v58 offset:51456
		ds_read_b128 a[64:67], v58 offset:51520
		ds_read_b128 a[68:71], v60 offset:18912
		ds_read_b128 a[72:75], v60 offset:18976
		ds_read_b128 a[76:79], v60 offset:19168
		ds_read_b128 a[80:83], v60 offset:19232
		ds_read_b128 a[84:87], v60 offset:19424
		ds_read_b128 a[88:91], v60 offset:19488
		ds_read_b128 a[92:95], v60 offset:19680
		ds_read_b128 v[252:255], v60 offset:19744
		ds_write_b64 v61, v[26:27] offset:4000
		ds_write_b32 v62, v28 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[30:31], v5 offset:4000
		ds_read_b64_tr_b8 v[34:35], v5 offset:4128
		ds_read_b64_tr_b8 v[26:27], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v38, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v39, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v40, s[36:39], 0 offen lds
		buffer_load_dword v47, v46, s[44:47], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v26, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v26, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v26, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v26, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v27, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v27, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v27, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v27, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v27, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[8:11], v[80:83], v27, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[16:19], v[96:99], v27, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v27, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v27, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v27, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v27, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v27, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v27, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[24:27], v[112:115], v27, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[32:35], v[128:131], v27, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v27, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v26, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v26, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v26, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v26, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v26, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v26, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v26, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v26, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v26, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v26, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v26, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v26, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v26, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v26, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v26, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v26, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v27, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v27, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v27, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v27, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v27, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[40:43], v[144:147], v27, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[48:51], v[160:163], v27, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v27, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v27, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v27, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v27, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v27, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v27, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[56:59], v[176:179], v27, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[64:67], v[192:195], v27, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v27, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v26, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v26, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v26, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v26, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v26, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v26, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v26, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v26, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[68:71], v60 offset:52672
		ds_read_b128 a[72:75], v60 offset:52736
		ds_read_b128 a[76:79], v60 offset:52928
		ds_read_b128 a[80:83], v60 offset:52992
		ds_read_b128 a[84:87], v60 offset:53184
		ds_read_b128 a[88:91], v60 offset:53248
		ds_read_b128 a[92:95], v60 offset:53440
		ds_read_b128 v[252:255], v60 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v62, v8 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v41, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[64:65], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v48, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v43, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v50, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v51, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x5260
		s_nop 0
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		buffer_load_dwordx2 v[26:27], v23, s[40:43], 0 offen
		buffer_load_dword v28, v24, s[44:47], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v64, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v64, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v64, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v64, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v65, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v65, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v65, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v65, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v65, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v65, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v65, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v65, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[24:27], v[240:243], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[32:35], v[248:251], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v64, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v64, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v64, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v64, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v64, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v64, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v64, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v64, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[40:43], a[108:111], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[40:43], a[112:115], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[48:51], a[128:131], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[48:51], a[124:127], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v65, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v65, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v65, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v65, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[40:43], a[116:119], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[40:43], a[120:123], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[48:51], a[136:139], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[48:51], a[132:135], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v65, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v65, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v65, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v65, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[56:59], a[148:151], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[56:59], a[152:155], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[64:67], a[168:171], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[64:67], a[164:167], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v64, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v64, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v64, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v64, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[56:59], a[140:143], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[56:59], a[144:147], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[64:67], a[160:163], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[64:67], a[156:159], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[4:7], v58
		ds_read_b128 a[8:11], v58 offset:64
		ds_read_b128 a[12:15], v58 offset:256
		ds_read_b128 a[16:19], v58 offset:320
		ds_read_b128 a[20:23], v58 offset:512
		ds_read_b128 a[24:27], v58 offset:576
		ds_read_b128 a[28:31], v58 offset:768
		ds_read_b128 a[32:35], v58 offset:832
		ds_read_b128 a[36:39], v58 offset:16896
		ds_read_b128 a[40:43], v58 offset:16960
		ds_read_b128 a[44:47], v58 offset:17152
		ds_read_b128 a[48:51], v58 offset:17216
		ds_read_b128 a[52:55], v58 offset:17408
		ds_read_b128 a[56:59], v58 offset:17472
		ds_read_b128 a[60:63], v58 offset:17664
		ds_read_b128 a[64:67], v58 offset:17728
		ds_read_b128 a[68:71], v60 offset:2016
		ds_read_b128 a[72:75], v60 offset:2080
		ds_read_b128 a[76:79], v60 offset:2272
		ds_read_b128 a[80:83], v60 offset:2336
		ds_read_b128 a[84:87], v60 offset:2528
		ds_read_b128 a[88:91], v60 offset:2592
		ds_read_b128 a[92:95], v60 offset:2784
		ds_read_b128 a[96:99], v60 offset:2848
		s_waitcnt vmcnt(20)
		ds_write_b64 v61, v[66:67] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v62, v33 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v59, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[30:31], v5 offset:4000
		ds_read_b64_tr_b8 v[34:35], v5 offset:4128
		ds_read_b64_tr_b8 v[64:65], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		buffer_load_dword v8, v3, s[44:47], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s18, s18, 0x100
		s_add_i32 s14, s14, 0x100
		s_add_i32 s12, s12, s15
		s_add_i32 s13, s13, s1
		s_setprio 0
		s_barrier
		s_add_i32 s23, s23, 2
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[56:57], s[30:31]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_1
		s_barrier
.L_a4w4_kernel.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v64, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v64, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v64, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v64, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v64, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v64, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v65, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v65, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v65, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v65, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v65, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v65, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v65, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v65, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v65, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v65, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v65, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v65, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v64, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v64, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v64, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v64, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v64, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v64, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v64, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v64, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v64, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v64, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v64, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v64, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v65, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v65, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v65, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v65, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v65, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v65, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v65, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v65, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v65, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v65, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v65, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v65, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v64, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v64, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v64, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v64, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v64, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v64, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[16:19], v60 offset:35776
		ds_read_b128 v[20:23], v60 offset:35840
		ds_read_b128 v[36:39], v60 offset:36032
		ds_read_b128 v[40:43], v60 offset:36096
		ds_read_b128 v[48:51], v60 offset:36288
		ds_read_b128 v[52:55], v60 offset:36352
		ds_read_b128 v[64:67], v60 offset:36544
		ds_read_b128 v[252:255], v60 offset:36608
		s_barrier
		ds_write_b32 v62, v47 offset:6048
		v_lshlrev_b32_e32 v1, 2, v4
		v_accvgpr_read_b32 v2, a1
		v_lshlrev_b32_e32 v2, 3, v2
		v_bitop3_b32 v0, v0, v1, v2 bitop3:0x96
		v_accvgpr_read_b32 v1, a2
		v_lshl_add_u32 v1, s21, 2, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[2:3], v11 offset:6048
		v_lshlrev_b32_e32 v4, 7, v6
		v_lshlrev_b32_e32 v6, 4, v0
		v_xor_b32_e32 v7, 1, v0
		v_lshlrev_b32_e32 v7, 4, v7
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[16:19], a[4:7], v[196:199], v2, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], a[4:7], v[200:203], v2, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[12:15], v[216:219], v2, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[16:19], a[12:15], v[212:215], v2, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], a[8:11], v[196:199], v2, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[8:11], v[200:203], v2, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[16:19], v[216:219], v2, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[20:23], a[16:19], v[212:215], v2, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], a[4:7], v[204:207], v3, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], a[4:7], v[208:211], v3, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], a[12:15], v[224:227], v3, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], a[12:15], v[220:223], v3, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], a[8:11], v[204:207], v3, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v3, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v3, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], a[16:19], v[220:223], v3, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[20:23], v[236:239], v3, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[64:67], a[20:23], v[240:243], v3, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[64:67], a[28:31], v[248:251], v3, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[28:31], v[244:247], v3, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[24:27], v[236:239], v3, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[24:27], v[240:243], v3, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[32:35], v[248:251], v3, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[52:55], a[32:35], v[244:247], v3, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[16:19], a[20:23], v[228:231], v2, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[20:23], v[232:235], v2, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[28:31], a[104:107], v2, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[16:19], a[28:31], a[100:103], v2, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[20:23], a[24:27], v[228:231], v2, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[24:27], v[232:235], v2, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[32:35], a[104:107], v2, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], a[32:35], a[100:103], v2, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[16:19], a[36:39], a[108:111], v2, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[36:39], a[112:115], v2, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[44:47], a[128:131], v2, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[16:19], a[44:47], a[124:127], v2, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[40:43], a[108:111], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[40:43], a[112:115], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[48:51], a[128:131], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[48:51], a[124:127], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[36:39], a[116:119], v3, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[36:39], a[120:123], v3, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[44:47], a[136:139], v3, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[44:47], a[132:135], v3, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[40:43], a[116:119], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[40:43], a[120:123], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[48:51], a[136:139], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[48:51], a[132:135], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[52:55], a[148:151], v3, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[52:55], a[152:155], v3, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[60:63], a[168:171], v3, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[60:63], a[164:167], v3, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[56:59], a[148:151], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[56:59], a[152:155], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[64:67], a[168:171], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[64:67], a[164:167], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[16:19], a[52:55], a[140:143], v2, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[52:55], a[144:147], v2, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[60:63], a[160:163], v2, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[16:19], a[60:63], a[156:159], v2, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[56:59], a[140:143], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[56:59], a[144:147], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[64:67], a[160:163], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[64:67], a[156:159], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v58 offset:33792
		ds_read_b128 a[4:7], v58 offset:33856
		ds_read_b128 v[20:23], v58 offset:34048
		ds_read_b128 a[8:11], v58 offset:34112
		ds_read_b128 a[12:15], v58 offset:34304
		ds_read_b128 a[16:19], v58 offset:34368
		ds_read_b128 a[20:23], v58 offset:34560
		ds_read_b128 a[24:27], v58 offset:34624
		ds_read_b128 a[28:31], v58 offset:50688
		ds_read_b128 a[32:35], v58 offset:50752
		ds_read_b128 a[36:39], v58 offset:50944
		ds_read_b128 a[40:43], v58 offset:51008
		ds_read_b128 a[44:47], v58 offset:51200
		ds_read_b128 a[48:51], v58 offset:51264
		ds_read_b128 a[52:55], v58 offset:51456
		ds_read_b128 a[56:59], v58 offset:51520
		ds_read_b128 v[32:35], v60 offset:18912
		ds_read_b128 v[36:39], v60 offset:18976
		ds_read_b128 v[40:43], v60 offset:19168
		ds_read_b128 v[48:51], v60 offset:19232
		ds_read_b128 v[52:55], v60 offset:19424
		ds_read_b128 v[56:59], v60 offset:19488
		ds_read_b128 v[64:67], v60 offset:19680
		ds_read_b128 v[252:255], v60 offset:19744
		ds_write_b64 v61, v[26:27] offset:4000
		v_xor_b32_e32 v2, 2, v0
		v_lshlrev_b32_e32 v2, 4, v2
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v62, v28 offset:6048
		ds_read_b64_tr_b8 v[14:15], v5 offset:4000
		ds_read_b64_tr_b8 v[24:25], v5 offset:4128
		v_lshrrev_b32_e32 v3, 3, v45
		v_and_b32_e32 v3, 1, v3
		v_lshrrev_b32_e32 v5, 2, v45
		v_and_b32_e32 v5, 1, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v11 offset:6048
		v_lshlrev_b32_e32 v13, 12, v5
		v_lshl_add_u32 v13, v3, 13, v13
		v_lshl_add_u32 v3, v3, 1, v5
		v_lshrrev_b32_e32 v5, 1, v45
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[32:35], v[16:19], v[68:71], v26, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[40:43], v[16:19], v[72:75], v26, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[40:43], v[20:23], v[88:91], v26, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[20:23], v[84:87], v26, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[36:39], a[4:7], v[68:71], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[48:51], a[4:7], v[72:75], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[48:51], a[8:11], v[88:91], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[36:39], a[8:11], v[84:87], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[52:55], v[16:19], v[76:79], v27, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[16:19], v[80:83], v27, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[64:67], v[20:23], v[96:99], v27, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[52:55], v[20:23], v[92:95], v27, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[56:59], a[4:7], v[76:79], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[4:7], v[80:83], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[8:11], v[96:99], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[56:59], a[8:11], v[92:95], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[52:55], a[12:15], v[108:111], v27, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], a[12:15], v[112:115], v27, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], a[20:23], v[128:131], v27, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[52:55], a[20:23], v[124:127], v27, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[56:59], a[16:19], v[108:111], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[16:19], v[112:115], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[24:27], v[128:131], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[56:59], a[24:27], v[124:127], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[12:15], v[100:103], v26, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[40:43], a[12:15], v[104:107], v26, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], a[20:23], v[120:123], v26, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], a[20:23], v[116:119], v26, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[36:39], a[16:19], v[100:103], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[48:51], a[16:19], v[104:107], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[48:51], a[24:27], v[120:123], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], a[24:27], v[116:119], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], a[28:31], v[132:135], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], a[28:31], v[136:139], v26, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], a[36:39], v[152:155], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], a[36:39], v[148:151], v26, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], a[32:35], v[132:135], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[48:51], a[32:35], v[136:139], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], a[40:43], v[152:155], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], a[40:43], v[148:151], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[52:55], a[28:31], v[140:143], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[64:67], a[28:31], v[144:147], v27, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[64:67], a[36:39], v[160:163], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], a[36:39], v[156:159], v27, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[56:59], a[32:35], v[140:143], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[32:35], v[144:147], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[40:43], v[160:163], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], a[40:43], v[156:159], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], a[44:47], v[172:175], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[64:67], a[44:47], v[176:179], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[64:67], a[52:55], v[192:195], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], a[52:55], v[188:191], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], a[48:51], v[172:175], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[48:51], v[176:179], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[56:59], v[192:195], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], a[56:59], v[188:191], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], a[44:47], v[164:167], v26, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], a[44:47], v[168:171], v26, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], a[52:55], v[184:187], v26, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], a[52:55], v[180:183], v26, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], a[48:51], v[164:167], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], a[48:51], v[168:171], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[48:51], a[56:59], v[184:187], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], a[56:59], v[180:183], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v60 offset:52672
		ds_read_b128 v[32:35], v60 offset:52736
		ds_read_b128 v[36:39], v60 offset:52928
		ds_read_b128 v[40:43], v60 offset:52992
		ds_read_b128 v[48:51], v60 offset:53184
		ds_read_b128 v[52:55], v60 offset:53248
		ds_read_b128 v[56:59], v60 offset:53440
		ds_read_b128 v[64:67], v60 offset:53504
		v_cvt_pk_bf16_f32 v252, v68, v69
		v_cvt_pk_bf16_f32 v253, v70, v71
		v_cvt_pk_bf16_f32 v68, v72, v73
		v_cvt_pk_bf16_f32 v69, v74, v75
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v62, v8 offset:6048
		v_cvt_pk_bf16_f32 v60, v76, v77
		v_cvt_pk_bf16_f32 v61, v78, v79
		v_cvt_pk_bf16_f32 v72, v80, v81
		v_cvt_pk_bf16_f32 v73, v82, v83
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v11 offset:6048
		s_mul_i32 s1, s16, s17
		v_cvt_pk_bf16_f32 v254, v84, v85
		v_cvt_pk_bf16_f32 v255, v86, v87
		v_cvt_pk_bf16_f32 v70, v88, v89
		v_cvt_pk_bf16_f32 v71, v90, v91
		v_cvt_pk_bf16_f32 v62, v92, v93
		v_cvt_pk_bf16_f32 v63, v94, v95
		v_cvt_pk_bf16_f32 v74, v96, v97
		v_cvt_pk_bf16_f32 v75, v98, v99
		v_cvt_pk_bf16_f32 v76, v100, v101
		v_cvt_pk_bf16_f32 v77, v102, v103
		v_cvt_pk_bf16_f32 v80, v104, v105
		v_cvt_pk_bf16_f32 v81, v106, v107
		v_cvt_pk_bf16_f32 v84, v108, v109
		v_cvt_pk_bf16_f32 v85, v110, v111
		v_cvt_pk_bf16_f32 v88, v112, v113
		v_cvt_pk_bf16_f32 v89, v114, v115
		v_cvt_pk_bf16_f32 v78, v116, v117
		v_cvt_pk_bf16_f32 v79, v118, v119
		v_cvt_pk_bf16_f32 v82, v120, v121
		v_cvt_pk_bf16_f32 v83, v122, v123
		v_cvt_pk_bf16_f32 v86, v124, v125
		v_cvt_pk_bf16_f32 v87, v126, v127
		v_cvt_pk_bf16_f32 v90, v128, v129
		v_cvt_pk_bf16_f32 v91, v130, v131
		v_cvt_pk_bf16_f32 v92, v132, v133
		v_cvt_pk_bf16_f32 v93, v134, v135
		v_cvt_pk_bf16_f32 v96, v136, v137
		v_cvt_pk_bf16_f32 v97, v138, v139
		v_cvt_pk_bf16_f32 v100, v140, v141
		v_cvt_pk_bf16_f32 v101, v142, v143
		v_cvt_pk_bf16_f32 v104, v144, v145
		v_cvt_pk_bf16_f32 v105, v146, v147
		v_cvt_pk_bf16_f32 v94, v148, v149
		v_cvt_pk_bf16_f32 v95, v150, v151
		v_cvt_pk_bf16_f32 v98, v152, v153
		v_cvt_pk_bf16_f32 v99, v154, v155
		v_cvt_pk_bf16_f32 v102, v156, v157
		v_cvt_pk_bf16_f32 v103, v158, v159
		v_cvt_pk_bf16_f32 v106, v160, v161
		v_cvt_pk_bf16_f32 v107, v162, v163
		v_cvt_pk_bf16_f32 v108, v164, v165
		v_cvt_pk_bf16_f32 v109, v166, v167
		v_cvt_pk_bf16_f32 v112, v168, v169
		v_cvt_pk_bf16_f32 v113, v170, v171
		v_cvt_pk_bf16_f32 v116, v172, v173
		v_cvt_pk_bf16_f32 v117, v174, v175
		v_cvt_pk_bf16_f32 v120, v176, v177
		v_cvt_pk_bf16_f32 v121, v178, v179
		v_cvt_pk_bf16_f32 v110, v180, v181
		v_cvt_pk_bf16_f32 v111, v182, v183
		v_cvt_pk_bf16_f32 v114, v184, v185
		v_cvt_pk_bf16_f32 v115, v186, v187
		v_cvt_pk_bf16_f32 v118, v188, v189
		v_cvt_pk_bf16_f32 v119, v190, v191
		v_cvt_pk_bf16_f32 v122, v192, v193
		v_cvt_pk_bf16_f32 v123, v194, v195
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[252:255]
		ds_write_b128 v7, v[68:71] offset:4096
		ds_write_b128 v2, v[60:63] offset:8192
		ds_write_b128 v0, v[72:75] offset:12288
		v_and_b32_e32 v5, 1, v5
		v_lshl_add_u32 v1, v5, 6, v1
		v_and_b32_e32 v8, 1, v45
		v_lshl_add_u32 v1, v8, 5, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v8, 2, v8
		v_lshlrev_b32_e32 v5, 3, v5
		v_xor_b32_e32 v5, v8, v5
		v_bitop3_b32 v1, v3, v1, v5 bitop3:0x96
		v_lshl_add_u32 v1, v1, 4, v13
		ds_read_b128 v[44:47], v1
		ds_read_b128 v[60:63], v1 offset:256
		ds_read_b128 v[68:71], v1 offset:2048
		ds_read_b128 v[72:75], v1 offset:2304
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[76:79]
		ds_write_b128 v7, v[80:83] offset:4096
		ds_write_b128 v2, v[84:87] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v1
		ds_read_b128 v[80:83], v1 offset:256
		ds_read_b128 v[84:87], v1 offset:2048
		ds_read_b128 v[88:91], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[92:95]
		ds_write_b128 v7, v[96:99] offset:4096
		ds_write_b128 v2, v[100:103] offset:8192
		ds_write_b128 v0, v[104:107] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1
		ds_read_b128 v[96:99], v1 offset:256
		ds_read_b128 v[100:103], v1 offset:2048
		ds_read_b128 v[104:107], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[108:111]
		ds_write_b128 v7, v[112:115] offset:4096
		ds_write_b128 v2, v[116:119] offset:8192
		ds_write_b128 v0, v[120:123] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v1
		ds_read_b128 v[112:115], v1 offset:256
		ds_read_b128 v[116:119], v1 offset:2048
		ds_read_b128 v[120:123], v1 offset:2304
		v_accvgpr_read_b32 v3, a0
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add_u32_e32 v5, s0, v3
		v_add3_u32 v5, v5, v9, v4
		v_add3_u32 v5, v5, v10, v12
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		v_mov_b64_e32 v[124:125], v[44:45]
		v_mov_b64_e32 v[126:127], v[60:61]
		buffer_store_dwordx4 v[124:127], v5, s[8:11], 0 offen
		s_lshl_b32 s1, s17, 5
		s_add_i32 s2, s0, s1
		v_add3_u32 v5, v3, v9, v4
		v_add_u32_e32 v5, v5, v10
		v_add3_u32 v8, v12, v5, s2
		v_mov_b64_e32 v[124:125], v[68:69]
		v_mov_b64_e32 v[126:127], v[72:73]
		buffer_store_dwordx4 v[124:127], v8, s[8:11], 0 offen
		s_lshl_b32 s2, s17, 6
		s_add_i32 s3, s0, s2
		v_add3_u32 v8, v12, v5, s3
		v_mov_b64_e32 v[124:125], v[46:47]
		v_mov_b64_e32 v[126:127], v[62:63]
		buffer_store_dwordx4 v[124:127], v8, s[8:11], 0 offen
		s_mul_i32 s3, 0x60, s17
		s_add_i32 s4, s0, s3
		v_add3_u32 v5, v12, v5, s4
		v_mov_b64_e32 v[44:45], v[70:71]
		v_mov_b64_e32 v[46:47], v[74:75]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_lshl_b32 s4, s17, 7
		s_add_i32 s5, s0, s4
		v_add3_u32 v5, v3, v9, v4
		v_add_u32_e32 v5, v5, v10
		v_add3_u32 v8, v12, v5, s5
		v_mov_b64_e32 v[44:45], v[76:77]
		v_mov_b64_e32 v[46:47], v[80:81]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s5, 0xa0, s17
		s_add_i32 s6, s0, s5
		v_add3_u32 v8, v12, v5, s6
		v_mov_b64_e32 v[44:45], v[84:85]
		v_mov_b64_e32 v[46:47], v[88:89]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s6, 0xc0, s17
		s_add_i32 s7, s0, s6
		v_add3_u32 v5, v12, v5, s7
		v_mov_b64_e32 v[44:45], v[78:79]
		v_mov_b64_e32 v[46:47], v[82:83]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s7, 0xe0, s17
		s_add_i32 s12, s0, s7
		v_add3_u32 v5, v3, v9, v4
		v_add_u32_e32 v5, v5, v10
		v_add3_u32 v8, v12, v5, s12
		v_mov_b64_e32 v[44:45], v[86:87]
		v_mov_b64_e32 v[46:47], v[90:91]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_lshl_b32 s12, s17, 8
		s_add_i32 s13, s0, s12
		v_add3_u32 v8, v12, v5, s13
		v_mov_b64_e32 v[44:45], v[92:93]
		v_mov_b64_e32 v[46:47], v[96:97]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s13, 0x120, s17
		s_add_i32 s14, s0, s13
		v_add3_u32 v5, v12, v5, s14
		v_mov_b64_e32 v[44:45], v[100:101]
		v_mov_b64_e32 v[46:47], v[104:105]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s14, 0x140, s17
		s_add_i32 s15, s0, s14
		v_add3_u32 v5, v3, v9, v4
		v_add_u32_e32 v5, v5, v10
		v_add3_u32 v8, v12, v5, s15
		v_mov_b64_e32 v[44:45], v[94:95]
		v_mov_b64_e32 v[46:47], v[98:99]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s15, 0x160, s17
		s_add_i32 s16, s0, s15
		v_add3_u32 v8, v12, v5, s16
		v_mov_b64_e32 v[44:45], v[102:103]
		v_mov_b64_e32 v[46:47], v[106:107]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s16, 0x180, s17
		s_add_i32 s18, s0, s16
		v_add3_u32 v5, v12, v5, s18
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[44:45], v[108:109]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[46:47], v[112:113]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s18, 0x1a0, s17
		s_add_i32 s19, s0, s18
		v_add3_u32 v5, v3, v9, v4
		v_add_u32_e32 v5, v5, v10
		v_add3_u32 v8, v12, v5, s19
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[44:45], v[116:117]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[46:47], v[120:121]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s19, 0x1c0, s17
		s_add_i32 s20, s0, s19
		v_add3_u32 v8, v12, v5, s20
		v_mov_b64_e32 v[44:45], v[110:111]
		v_mov_b64_e32 v[46:47], v[114:115]
		buffer_store_dwordx4 v[44:47], v8, s[8:11], 0 offen
		s_mul_i32 s17, 0x1e0, s17
		s_add_i32 s20, s0, s17
		v_add3_u32 v5, v12, v5, s20
		v_mov_b64_e32 v[44:45], v[118:119]
		v_mov_b64_e32 v[46:47], v[122:123]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[16:19], v[196:199], v26, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[16:19], v[200:203], v26, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[20:23], v[216:219], v26, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[20:23], v[212:215], v26, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], a[4:7], v[196:199], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[4:7], v[200:203], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[8:11], v[216:219], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[8:11], v[212:215], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[16:19], v[204:207], v27, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], v[16:19], v[208:211], v27, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], v[20:23], v[224:227], v27, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[20:23], v[220:223], v27, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], a[4:7], v[204:207], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v16, v196, v197
		v_cvt_pk_bf16_f32 v17, v198, v199
		v_cvt_pk_bf16_f32 v20, v200, v201
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], a[4:7], v[208:211], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v21, v202, v203
		v_cvt_pk_bf16_f32 v18, v212, v213
		v_cvt_pk_bf16_f32 v19, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], a[8:11], v[224:227], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v44, v204, v205
		v_cvt_pk_bf16_f32 v45, v206, v207
		v_cvt_pk_bf16_f32 v22, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], a[8:11], v[220:223], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v208, v209
		v_cvt_pk_bf16_f32 v61, v210, v211
		v_cvt_pk_bf16_f32 v23, v218, v219
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[12:15], v[236:239], v27, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v62, v224, v225
		v_cvt_pk_bf16_f32 v63, v226, v227
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], a[12:15], v[240:243], v27, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[56:59], a[20:23], v[248:251], v27, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v46, v220, v221
		v_cvt_pk_bf16_f32 v47, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[20:23], v[244:247], v27, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[16:19], v[236:239], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[64:67], a[16:19], v[240:243], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[64:67], a[24:27], v[248:251], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[52:55], a[24:27], v[244:247], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[12:15], v[228:231], v26, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[12:15], v[232:235], v26, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[20:23], a[104:107], v26, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], a[20:23], a[100:103], v26, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[16:19], v[228:231], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v68, v236, v237
		v_cvt_pk_bf16_f32 v69, v238, v239
		v_cvt_pk_bf16_f32 v72, v240, v241
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[16:19], v[232:235], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v73, v242, v243
		v_cvt_pk_bf16_f32 v70, v244, v245
		v_cvt_pk_bf16_f32 v71, v246, v247
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[24:27], a[104:107], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v76, v228, v229
		v_cvt_pk_bf16_f32 v77, v230, v231
		v_cvt_pk_bf16_f32 v74, v248, v249
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[32:35], a[24:27], a[100:103], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v80, v232, v233
		v_cvt_pk_bf16_f32 v81, v234, v235
		v_cvt_pk_bf16_f32 v75, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[28:31], a[108:111], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v8, a105
		v_cvt_pk_bf16_f32 v82, v5, v8
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v8, a107
		v_cvt_pk_bf16_f32 v83, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[28:31], a[112:115], v26, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[36:39], a[128:131], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v8, a101
		v_cvt_pk_bf16_f32 v78, v5, v8
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v8, a103
		v_cvt_pk_bf16_f32 v79, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[36:39], a[124:127], v26, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], a[32:35], a[108:111], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[32:35], a[112:115], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[40:43], a[128:131], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], a[40:43], a[124:127], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[28:31], a[116:119], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[28:31], a[120:123], v27, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[36:39], a[136:139], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[36:39], a[132:135], v27, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[32:35], a[116:119], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v8, a109
		v_cvt_pk_bf16_f32 v84, v5, v8
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v8, a111
		v_cvt_pk_bf16_f32 v85, v5, v8
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v8, a113
		v_cvt_pk_bf16_f32 v88, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[32:35], a[120:123], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v8, a115
		v_cvt_pk_bf16_f32 v89, v5, v8
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v8, a125
		v_cvt_pk_bf16_f32 v86, v5, v8
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v8, a127
		v_cvt_pk_bf16_f32 v87, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[40:43], a[136:139], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v8, a117
		v_cvt_pk_bf16_f32 v92, v5, v8
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v8, a119
		v_cvt_pk_bf16_f32 v93, v5, v8
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v8, a129
		v_cvt_pk_bf16_f32 v90, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[40:43], a[132:135], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v8, a121
		v_cvt_pk_bf16_f32 v96, v5, v8
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v8, a123
		v_cvt_pk_bf16_f32 v97, v5, v8
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v8, a131
		v_cvt_pk_bf16_f32 v91, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[44:47], a[148:151], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v8, a137
		v_cvt_pk_bf16_f32 v98, v5, v8
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v8, a139
		v_cvt_pk_bf16_f32 v99, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[44:47], a[152:155], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[52:55], a[168:171], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v8, a133
		v_cvt_pk_bf16_f32 v94, v5, v8
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v8, a135
		v_cvt_pk_bf16_f32 v95, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[52:55], a[164:167], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[48:51], a[148:151], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[48:51], a[152:155], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[56:59], a[168:171], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[56:59], a[164:167], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[44:47], a[140:143], v26, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[44:47], a[144:147], v26, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[52:55], a[160:163], v26, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[52:55], a[156:159], v26, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], a[48:51], a[140:143], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v28, v5, v8
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v29, v5, v8
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v36, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[48:51], a[144:147], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v37, v5, v8
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v8, a165
		v_cvt_pk_bf16_f32 v30, v5, v8
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v8, a167
		v_cvt_pk_bf16_f32 v31, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[56:59], a[160:163], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v8, a141
		v_cvt_pk_bf16_f32 v40, v5, v8
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v8, a143
		v_cvt_pk_bf16_f32 v41, v5, v8
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v8, a169
		v_cvt_pk_bf16_f32 v38, v5, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], a[56:59], a[156:159], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v8, a145
		v_cvt_pk_bf16_f32 v24, v5, v8
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v8, a147
		v_cvt_pk_bf16_f32 v25, v5, v8
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v8, a171
		v_cvt_pk_bf16_f32 v39, v5, v8
		s_barrier
		ds_write_b128 v6, v[16:19] offset:16384
		ds_write_b128 v7, v[20:23] offset:20480
		ds_write_b128 v2, v[44:47] offset:24576
		ds_write_b128 v0, v[60:63] offset:28672
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v8, a157
		v_cvt_pk_bf16_f32 v42, v5, v8
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v8, a159
		v_cvt_pk_bf16_f32 v43, v5, v8
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v8, a161
		v_cvt_pk_bf16_f32 v26, v5, v8
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v8, a163
		v_cvt_pk_bf16_f32 v27, v5, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:16384
		ds_read_b128 v[20:23], v1 offset:16640
		ds_read_b128 v[32:35], v1 offset:18432
		ds_read_b128 v[44:47], v1 offset:18688
		s_add_i32 s0, s0, 0x100
		s_add_i32 s1, s0, s1
		s_add_i32 s2, s0, s2
		s_add_i32 s3, s0, s3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[76:79] offset:16384
		ds_write_b128 v7, v[80:83] offset:20480
		ds_write_b128 v2, v[68:71] offset:24576
		ds_write_b128 v0, v[72:75] offset:28672
		s_add_i32 s4, s0, s4
		s_add_i32 s5, s0, s5
		s_add_i32 s6, s0, s6
		s_add_i32 s7, s0, s7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v1 offset:16384
		ds_read_b128 v[52:55], v1 offset:16640
		ds_read_b128 v[56:59], v1 offset:18432
		ds_read_b128 v[60:63], v1 offset:18688
		s_add_i32 s12, s0, s12
		s_add_i32 s13, s0, s13
		s_add_i32 s14, s0, s14
		s_add_i32 s15, s0, s15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[84:87] offset:16384
		ds_write_b128 v7, v[88:91] offset:20480
		ds_write_b128 v2, v[92:95] offset:24576
		ds_write_b128 v0, v[96:99] offset:28672
		s_add_i32 s16, s0, s16
		s_add_i32 s18, s0, s18
		s_add_i32 s19, s0, s19
		s_add_i32 s17, s0, s17
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v1 offset:16384
		ds_read_b128 v[68:71], v1 offset:16640
		ds_read_b128 v[72:75], v1 offset:18432
		ds_read_b128 v[76:79], v1 offset:18688
		v_add_u32_e32 v5, s0, v3
		v_add3_u32 v5, v5, v9, v4
		v_add3_u32 v5, v5, v10, v12
		v_mov_b64_e32 v[80:81], v[16:17]
		v_mov_b64_e32 v[82:83], v[20:21]
		buffer_store_dwordx4 v[80:83], v5, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[40:43] offset:16384
		ds_write_b128 v7, v[24:27] offset:20480
		ds_write_b128 v2, v[28:31] offset:24576
		ds_write_b128 v0, v[36:39] offset:28672
		v_add3_u32 v0, v3, v9, v4
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v2, v12, v0, s1
		v_mov_b64_e32 v[24:25], v[32:33]
		v_mov_b64_e32 v[26:27], v[44:45]
		buffer_store_dwordx4 v[24:27], v2, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v1 offset:16384
		ds_read_b128 v[28:31], v1 offset:16640
		ds_read_b128 v[36:39], v1 offset:18432
		ds_read_b128 v[40:43], v1 offset:18688
		v_add3_u32 v1, v12, v0, s2
		v_mov_b64_e32 v[80:81], v[18:19]
		v_mov_b64_e32 v[82:83], v[22:23]
		buffer_store_dwordx4 v[80:83], v1, s[8:11], 0 offen
		v_add3_u32 v0, v12, v0, s3
		v_mov_b64_e32 v[16:17], v[34:35]
		v_mov_b64_e32 v[18:19], v[46:47]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v3, v9, v4
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s4
		v_mov_b64_e32 v[16:17], v[48:49]
		v_mov_b64_e32 v[18:19], v[52:53]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v1, v12, v0, s5
		s_nop 0
		v_mov_b64_e32 v[16:17], v[56:57]
		v_mov_b64_e32 v[18:19], v[60:61]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v0, v12, v0, s6
		s_nop 0
		v_mov_b64_e32 v[16:17], v[50:51]
		v_mov_b64_e32 v[18:19], v[54:55]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v3, v9, v4
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s7
		v_mov_b64_e32 v[16:17], v[58:59]
		v_mov_b64_e32 v[18:19], v[62:63]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v1, v12, v0, s12
		s_nop 0
		v_mov_b64_e32 v[16:17], v[64:65]
		v_mov_b64_e32 v[18:19], v[68:69]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v0, v12, v0, s13
		s_nop 0
		v_mov_b64_e32 v[16:17], v[72:73]
		v_mov_b64_e32 v[18:19], v[76:77]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v3, v9, v4
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s14
		v_mov_b64_e32 v[16:17], v[66:67]
		v_mov_b64_e32 v[18:19], v[70:71]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v1, v12, v0, s15
		s_nop 0
		v_mov_b64_e32 v[16:17], v[74:75]
		v_mov_b64_e32 v[18:19], v[78:79]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v0, v12, v0, s16
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mov_b64_e32 v[16:17], v[24:25]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[18:19], v[28:29]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v3, v9, v4
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s18
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[4:5], v[36:37]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[40:41]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v12, v0, s19
		s_nop 0
		v_mov_b64_e32 v[4:5], v[26:27]
		v_mov_b64_e32 v[6:7], v[30:31]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v0, v12, v0, s17
		s_nop 0
		v_mov_b64_e32 v[4:5], v[38:39]
		v_mov_b64_e32 v[6:7], v[42:43]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 138144
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
		.amdhsa_next_free_vgpr 428
		.amdhsa_next_free_sgpr 58
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .L_a4w4_kernel.num_vgpr, 256
	.set .L_a4w4_kernel.num_agpr, 172
	.set .L_a4w4_kernel.numbered_sgpr, 58
	.set .L_a4w4_kernel.num_named_barrier, 0
	.set .L_a4w4_kernel.private_seg_size, 0
	.set .L_a4w4_kernel.uses_vcc, 0
	.set .L_a4w4_kernel.uses_flat_scratch, 0
	.set .L_a4w4_kernel.has_dyn_sized_stack, 0
	.set .L_a4w4_kernel.has_recursion, 0
	.set .L_a4w4_kernel.has_indirect_call, 0
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
    .group_segment_fixed_size: 138144
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     58
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     428
    .agpr_count:     172
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 98
    wave.regalloc.agpr.dwords: 379
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
