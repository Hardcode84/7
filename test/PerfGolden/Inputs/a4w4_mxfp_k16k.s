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
		v_and_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v2, v2, v7, v8
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s23, s14, 2
		v_add_u32_e32 v7, s23, v2
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_mov_b32 s30, -1
		s_mov_b32 s31, -1
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s32, s14, 3
		v_add_u32_e32 v9, s32, v2
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_mul_i32 s13, s13, s15
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s33, 12, s14
		v_add_u32_e32 v10, s33, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_mul_i32 s34, 0x84, s14
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s35, s14, 7
		v_add_u32_e32 v11, s35, v2
		s_mul_i32 s36, 0x88, s14
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		v_mul_lo_u32 v12, s15, v5
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v13, s34, v2
		s_mul_i32 s14, 0x8c, s14
		s_mul_i32 s37, 12, s15
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_mul_lo_u32 v14, s15, v4
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v15, s36, v2
		s_mul_i32 s38, 0x84, s15
		s_mul_i32 s39, 0x88, s15
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		v_mul_lo_u32 v16, s15, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v17, s14, v2
		v_lshl_add_u32 v14, v14, 6, v16
		v_lshl_add_u32 v12, v12, 5, v14
		v_and_b32_e32 v1, 1, v1
		v_accvgpr_write_b32 a1, v1
		s_mul_i32 s40, 0x8c, s15
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		s_add_u32 s44, s4, s13
		s_addc_u32 s45, s5, 0
		s_add_i32 m0, m0, 0x9460
		v_mul_lo_u32 v1, s15, v6
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, v12, v1, v8
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dwordx4 v1, s[44:47], 0 offen lds
		s_lshl_b32 s41, s15, 2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v8, s41, v1
		v_lshlrev_b32_e32 v6, 6, v6
		s_lshl_b32 s42, s15, 3
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s43, s18, 16
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v12, s42, v1
		v_add_u32_e32 v14, s37, v1
		v_mul_lo_u32 v16, s18, v3
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		v_mul_lo_u32 v3, s19, v3
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		v_and_b32_e32 v18, 31, v0
		v_lshlrev_b32_e32 v19, 3, v18
		v_add3_u32 v20, s1, v16, v19
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		buffer_load_dwordx2 v[22:23], v20, s[48:51], 0 offen
		s_lshl_b32 s20, s0, 8
		v_lshlrev_b32_e32 v18, 2, v18
		v_add3_u32 v21, s20, v3, v18
		s_mov_b32 s52, s10
		s_mov_b32 s53, s11
		s_mov_b32 s54, s26
		s_mov_b32 s55, s27
		buffer_load_dword v24, v21, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_lshl_b32 s15, s15, 7
		v_add_u32_e32 v25, s15, v1
		buffer_load_dwordx4 v25, s[44:47], 0 offen lds
		v_add_u32_e32 v26, s38, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v27, s39, v1
		v_add_u32_e32 v28, s40, v1
		v_add_u32_e32 v29, 0x80, v2
		buffer_load_dwordx4 v26, s[44:47], 0 offen lds
		v_add_u32_e32 v30, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v31, s32, v30
		v_add_u32_e32 v32, s33, v30
		v_add_u32_e32 v30, s35, v30
		buffer_load_dwordx4 v27, s[44:47], 0 offen lds
		v_lshrrev_b32_e32 v33, 7, v0
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s32, s20, 0x80
		v_add3_u32 v34, s32, v3, v18
		v_add_u32_e32 v35, 0x80, v2
		buffer_load_dwordx4 v28, s[44:47], 0 offen lds
		buffer_load_dword v36, v34, s[52:55], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s23, s23, 0x80
		v_add_u32_e32 v37, s23, v2
		v_add_u32_e32 v38, s34, v35
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_add_u32_e32 v39, s36, v35
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v35, s14, v35
		v_add_u32_e32 v40, 0x80, v1
		v_add_u32_e32 v41, 0x80, v1
		buffer_load_dwordx4 v37, s[24:27], 0 offen lds
		v_add_u32_e32 v42, s41, v41
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v43, s42, v41
		v_add_u32_e32 v41, s37, v41
		v_add_u32_e32 v44, 0x80, v1
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_add_u32_e32 v45, s38, v44
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v46, s39, v44
		v_lshlrev_b32_e32 v47, 7, v33
		v_lshlrev_b32_e32 v33, 4, v33
		v_add_u32_e32 v33, 0x20000, v33
		v_and_b32_e32 v48, 63, v0
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v49, 4, v48
		v_accvgpr_write_b32 a2, v49
		s_add_i32 m0, m0, 0x1080
		v_accvgpr_read_b32 v49, a2
		v_lshlrev_b32_e32 v49, 4, v49
		v_and_b32_e32 v50, 15, v48
		v_add_u32_e32 v51, 0x10000, v49
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		v_mov_b32_e32 v52, 0x420
		v_mul_lo_u32 v52, v52, v50
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v47, v47, v49, v52
		v_accvgpr_read_b32 v49, a1
		v_lshlrev_b32_e32 v49, 7, v49
		buffer_load_dwordx4 v38, s[24:27], 0 offen lds
		v_add3_u32 v49, v51, v49, v52
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s13, 0x100
		v_lshlrev_b32_e32 v50, 3, v0
		v_add_u32_e32 v50, 0x20000, v50
		buffer_load_dwordx4 v39, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v51, 2, v0
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s15, 0x80
		v_add_u32_e32 v51, 0x20000, v51
		v_add_u32_e32 v52, s13, v1
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		v_and_b32_e32 v53, 1, v0
		v_accvgpr_write_b32 a3, v53
		s_add_i32 m0, m0, 0x5260
		v_accvgpr_read_b32 v53, a3
		v_lshlrev_b32_e32 v53, 3, v53
		v_add_u32_e32 v33, v33, v53
		v_lshl_add_u32 v33, v4, 9, v33
		buffer_load_dwordx4 v40, s[44:47], 0 offen lds
		v_lshl_add_u32 v33, v5, 8, v33
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s13, s19, 3
		v_add_u32_e32 v53, 0x20000, v53
		v_accvgpr_read_b32 v54, a1
		v_lshl_add_u32 v53, v54, 4, v53
		buffer_load_dwordx4 v42, s[44:47], 0 offen lds
		v_lshl_add_u32 v53, v4, 8, v53
		s_add_i32 m0, m0, 0x1080
		v_lshl_add_u32 v5, v5, 7, v53
		s_lshl_b32 s15, s18, 3
		v_lshrrev_b32_e32 v53, 2, v0
		v_and_b32_e32 v53, 1, v53
		v_lshlrev_b32_e32 v53, 5, v53
		v_add3_u32 v33, v33, v6, v53
		buffer_load_dwordx4 v43, s[44:47], 0 offen lds
		v_add3_u32 v5, v5, v6, v53
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s1, s15
		v_add3_u32 v6, s1, v16, v19
		s_add_i32 s1, s20, s13
		buffer_load_dwordx4 v41, s[44:47], 0 offen lds
		buffer_load_dwordx2 v[54:55], v6, s[48:51], 0 offen
		v_add3_u32 v16, s1, v3, v18
		buffer_load_dword v19, v16, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		v_lshrrev_b32_e32 v53, 1, v0
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		v_and_b32_e32 v53, 1, v53
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s12, 0x100
		v_lshl_add_u32 v33, v53, 10, v33
		v_lshl_add_u32 v5, v53, 9, v5
		buffer_load_dwordx4 v45, s[44:47], 0 offen lds
		s_mov_b32 s12, 0
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s32, s13
		v_add3_u32 v3, s13, v3, v18
		buffer_load_dwordx4 v46, s[44:47], 0 offen lds
		s_mul_i32 s13, s19, 16
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v18, s40, v44
		buffer_load_dwordx4 v18, s[44:47], 0 offen lds
		buffer_load_dword v44, v3, s[52:55], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 a[4:7], v47
		ds_read_b128 a[8:11], v47 offset:64
		ds_read_b128 a[12:15], v47 offset:256
		ds_read_b128 a[16:19], v47 offset:320
		ds_read_b128 a[20:23], v47 offset:512
		ds_read_b128 a[24:27], v47 offset:576
		ds_read_b128 a[28:31], v47 offset:768
		ds_read_b128 a[32:35], v47 offset:832
		ds_read_b128 a[36:39], v47 offset:16896
		ds_read_b128 a[40:43], v47 offset:16960
		ds_read_b128 a[44:47], v47 offset:17152
		ds_read_b128 a[48:51], v47 offset:17216
		ds_read_b128 a[52:55], v47 offset:17408
		ds_read_b128 a[56:59], v47 offset:17472
		ds_read_b128 a[60:63], v47 offset:17664
		ds_read_b128 a[64:67], v47 offset:17728
		ds_read_b128 a[68:71], v49 offset:2016
		ds_read_b128 a[72:75], v49 offset:2080
		ds_read_b128 a[76:79], v49 offset:2272
		ds_read_b128 a[80:83], v49 offset:2336
		ds_read_b128 a[84:87], v49 offset:2528
		ds_read_b128 a[88:91], v49 offset:2592
		ds_read_b128 a[92:95], v49 offset:2784
		ds_read_b128 a[96:99], v49 offset:2848
		s_waitcnt vmcnt(25)
		ds_write_b64 v50, v[22:23] offset:4000
		s_waitcnt vmcnt(24)
		ds_write_b32 v51, v24 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[22:23], v33 offset:4000
		ds_read_b64_tr_b8 v[56:57], v33 offset:4128
		ds_read_b64_tr_b8 v[58:59], v5 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[56:57], s[28:29]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_0
		s_barrier
.L_a4w4_kernel.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		s_setprio 0
		s_mov_b32 s15, s43
		s_mov_b32 s18, s13
		s_add_u32 s32, s2, s1
		s_addc_u32 s33, s3, 0
		s_add_u32 s36, s4, s14
		s_addc_u32 s37, s5, 0
		s_add_u32 s44, s8, s15
		s_addc_u32 s45, s9, 0
		s_add_u32 s48, s10, s18
		s_addc_u32 s49, s11, 0
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
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
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
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
.L_a4w4_kernel.loop_head_0:
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[68:71], a[4:7], v[60:63], v58, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[76:79], a[4:7], v[64:67], v58, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[12:15], v[80:83], v58, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[12:15], v[76:79], v58, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[72:75], a[8:11], v[60:63], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[80:83], a[8:11], v[64:67], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[16:19], v[80:83], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[16:19], v[76:79], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[84:87], a[4:7], v[68:71], v59, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[92:95], a[4:7], v[72:75], v59, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[12:15], v[88:91], v59, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[12:15], v[84:87], v59, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[88:91], a[8:11], v[68:71], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], a[8:11], v[72:75], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], a[16:19], v[88:91], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[16:19], v[84:87], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[20:23], v[100:103], v59, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[20:23], v[104:107], v59, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[28:31], v[120:123], v59, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[28:31], v[116:119], v59, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[24:27], v[100:103], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], a[24:27], v[104:107], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[32:35], v[120:123], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[32:35], v[116:119], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[20:23], v[92:95], v58, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[20:23], v[96:99], v58, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[28:31], v[112:115], v58, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[28:31], v[108:111], v58, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[24:27], v[92:95], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[24:27], v[96:99], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[32:35], v[112:115], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[32:35], v[108:111], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[36:39], v[124:127], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[36:39], v[128:131], v58, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[44:47], v[144:147], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[44:47], v[140:143], v58, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[40:43], v[124:127], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[40:43], v[128:131], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[48:51], v[144:147], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[48:51], v[140:143], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[36:39], v[132:135], v59, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[36:39], v[136:139], v59, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[44:47], v[152:155], v59, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[44:47], v[148:151], v59, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[40:43], v[132:135], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[40:43], v[136:139], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[48:51], v[152:155], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[48:51], v[148:151], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[52:55], v[164:167], v59, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[52:55], v[168:171], v59, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[60:63], v[184:187], v59, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[60:63], v[180:183], v59, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[56:59], v[164:167], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[56:59], v[168:171], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[64:67], v[184:187], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[64:67], v[180:183], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[52:55], v[156:159], v58, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[52:55], v[160:163], v58, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[60:63], v[176:179], v58, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[60:63], v[172:175], v58, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[56:59], v[156:159], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[56:59], v[160:163], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[64:67], v[176:179], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[64:67], v[172:175], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt vmcnt(1)
		ds_read_b128 a[68:71], v49 offset:35776
		ds_read_b128 a[72:75], v49 offset:35840
		ds_read_b128 a[76:79], v49 offset:36032
		ds_read_b128 a[80:83], v49 offset:36096
		ds_read_b128 a[84:87], v49 offset:36288
		ds_read_b128 a[88:91], v49 offset:36352
		ds_read_b128 a[92:95], v49 offset:36544
		ds_read_b128 a[96:99], v49 offset:36608
		s_barrier
		ds_write_b32 v51, v36 offset:6048
		s_add_u32 s32, s2, s1
		s_addc_u32 s33, s3, 0
		s_mov_b32 m0, s22
		s_add_u32 s36, s4, s14
		s_addc_u32 s37, s5, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[58:59], v5 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s48, s10, s18
		s_addc_u32 s49, s11, 0
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		s_add_u32 s44, s8, s15
		s_addc_u32 s45, s9, 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9460
		s_nop 0
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v8, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		buffer_load_dwordx2 v[252:253], v20, s[44:47], 0 offen
		buffer_load_dword v24, v21, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[4:7], v[188:191], v58, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[4:7], v[192:195], v58, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[12:15], v[208:211], v58, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[12:15], v[204:207], v58, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[8:11], v[188:191], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[8:11], v[192:195], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[16:19], v[208:211], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[16:19], v[204:207], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[4:7], v[196:199], v59, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[4:7], v[200:203], v59, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[12:15], v[216:219], v59, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[12:15], v[212:215], v59, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[8:11], v[196:199], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[8:11], v[200:203], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], a[16:19], v[216:219], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[16:19], v[212:215], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[20:23], v[228:231], v59, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[20:23], v[232:235], v59, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v59, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v59, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[24:27], v[228:231], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[96:99], a[24:27], v[232:235], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[96:99], a[32:35], v[248:251], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[20:23], v[220:223], v58, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[20:23], v[224:227], v58, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[76:79], a[28:31], v[240:243], v58, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[28:31], v[236:239], v58, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[24:27], v[220:223], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[24:27], v[224:227], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[32:35], v[240:243], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[32:35], v[236:239], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[36:39], a[100:103], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[36:39], a[104:107], v58, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[76:79], a[44:47], a[120:123], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[44:47], a[116:119], v58, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[40:43], a[100:103], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[40:43], a[104:107], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[48:51], a[120:123], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[48:51], a[116:119], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[84:87], a[36:39], a[108:111], v59, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[92:95], a[36:39], a[112:115], v59, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[92:95], a[44:47], a[128:131], v59, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[84:87], a[44:47], a[124:127], v59, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[40:43], a[108:111], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[96:99], a[40:43], a[112:115], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[96:99], a[48:51], a[128:131], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[48:51], a[124:127], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[84:87], a[52:55], a[140:143], v59, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[92:95], a[52:55], a[144:147], v59, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[92:95], a[60:63], a[160:163], v59, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[84:87], a[60:63], a[156:159], v59, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[56:59], a[140:143], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[96:99], a[56:59], a[144:147], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[96:99], a[64:67], a[160:163], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[64:67], a[156:159], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[52:55], a[132:135], v58, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[76:79], a[52:55], a[136:139], v58, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[76:79], a[60:63], a[152:155], v58, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[60:63], a[148:151], v58, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[56:59], a[132:135], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[56:59], a[136:139], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[64:67], a[152:155], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[64:67], a[148:151], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[4:7], v47 offset:33792
		ds_read_b128 a[8:11], v47 offset:33856
		ds_read_b128 a[12:15], v47 offset:34048
		ds_read_b128 a[16:19], v47 offset:34112
		ds_read_b128 a[20:23], v47 offset:34304
		ds_read_b128 a[24:27], v47 offset:34368
		ds_read_b128 a[28:31], v47 offset:34560
		ds_read_b128 a[32:35], v47 offset:34624
		ds_read_b128 a[36:39], v47 offset:50688
		ds_read_b128 a[40:43], v47 offset:50752
		ds_read_b128 a[44:47], v47 offset:50944
		ds_read_b128 a[48:51], v47 offset:51008
		ds_read_b128 a[52:55], v47 offset:51200
		ds_read_b128 a[56:59], v47 offset:51264
		ds_read_b128 a[60:63], v47 offset:51456
		ds_read_b128 a[64:67], v47 offset:51520
		ds_read_b128 a[68:71], v49 offset:18912
		ds_read_b128 a[72:75], v49 offset:18976
		ds_read_b128 a[76:79], v49 offset:19168
		ds_read_b128 a[80:83], v49 offset:19232
		ds_read_b128 a[84:87], v49 offset:19424
		ds_read_b128 a[88:91], v49 offset:19488
		ds_read_b128 a[92:95], v49 offset:19680
		ds_read_b128 v[56:59], v49 offset:19744
		ds_write_b64 v50, v[54:55] offset:4000
		ds_write_b32 v51, v19 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v25, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[22:23], v33 offset:4000
		ds_read_b64_tr_b8 v[254:255], v33 offset:4128
		ds_read_b64_tr_b8 v[54:55], v5 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		buffer_load_dword v36, v34, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[68:71], a[4:7], v[60:63], v54, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[76:79], a[4:7], v[64:67], v54, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[12:15], v[80:83], v54, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[12:15], v[76:79], v54, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[72:75], a[8:11], v[60:63], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[80:83], a[8:11], v[64:67], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[16:19], v[80:83], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[16:19], v[76:79], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[84:87], a[4:7], v[68:71], v55, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[92:95], a[4:7], v[72:75], v55, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[12:15], v[88:91], v55, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[12:15], v[84:87], v55, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[88:91], a[8:11], v[68:71], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[56:59], a[8:11], v[72:75], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[56:59], a[16:19], v[88:91], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[16:19], v[84:87], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[20:23], v[100:103], v55, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[20:23], v[104:107], v55, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[28:31], v[120:123], v55, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[28:31], v[116:119], v55, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[24:27], v[100:103], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[56:59], a[24:27], v[104:107], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[56:59], a[32:35], v[120:123], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[32:35], v[116:119], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[20:23], v[92:95], v54, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[20:23], v[96:99], v54, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[28:31], v[112:115], v54, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[28:31], v[108:111], v54, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[24:27], v[92:95], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[24:27], v[96:99], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[32:35], v[112:115], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[32:35], v[108:111], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[36:39], v[124:127], v54, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[36:39], v[128:131], v54, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[44:47], v[144:147], v54, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[44:47], v[140:143], v54, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[40:43], v[124:127], v54, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[40:43], v[128:131], v54, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[48:51], v[144:147], v54, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[48:51], v[140:143], v54, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[36:39], v[132:135], v55, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[36:39], v[136:139], v55, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[44:47], v[152:155], v55, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[44:47], v[148:151], v55, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[40:43], v[132:135], v55, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[56:59], a[40:43], v[136:139], v55, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[56:59], a[48:51], v[152:155], v55, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[48:51], v[148:151], v55, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[52:55], v[164:167], v55, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[52:55], v[168:171], v55, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[60:63], v[184:187], v55, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[60:63], v[180:183], v55, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[56:59], v[164:167], v55, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], a[56:59], v[168:171], v55, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], a[64:67], v[184:187], v55, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[64:67], v[180:183], v55, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[52:55], v[156:159], v54, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[52:55], v[160:163], v54, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[60:63], v[176:179], v54, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[60:63], v[172:175], v54, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[56:59], v[156:159], v54, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[56:59], v[160:163], v54, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[64:67], v[176:179], v54, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[64:67], v[172:175], v54, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[68:71], v49 offset:52672
		ds_read_b128 a[72:75], v49 offset:52736
		ds_read_b128 a[76:79], v49 offset:52928
		ds_read_b128 a[80:83], v49 offset:52992
		ds_read_b128 a[84:87], v49 offset:53184
		ds_read_b128 a[88:91], v49 offset:53248
		ds_read_b128 a[92:95], v49 offset:53440
		ds_read_b128 a[96:99], v49 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v51, v44 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[56:57], v5 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v39, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x5260
		s_nop 0
		buffer_load_dwordx4 v40, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v42, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v41, s[36:39], 0 offen lds
		buffer_load_dwordx2 v[54:55], v6, s[44:47], 0 offen
		buffer_load_dword v19, v16, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[4:7], v[188:191], v56, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[4:7], v[192:195], v56, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[12:15], v[208:211], v56, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[12:15], v[204:207], v56, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[8:11], v[188:191], v56, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[8:11], v[192:195], v56, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[16:19], v[208:211], v56, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[16:19], v[204:207], v56, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[4:7], v[196:199], v57, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[4:7], v[200:203], v57, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[12:15], v[216:219], v57, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[12:15], v[212:215], v57, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[8:11], v[196:199], v57, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[8:11], v[200:203], v57, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], a[16:19], v[216:219], v57, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[16:19], v[212:215], v57, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[20:23], v[228:231], v57, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[20:23], v[232:235], v57, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v57, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v57, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[24:27], v[228:231], v57, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[96:99], a[24:27], v[232:235], v57, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[96:99], a[32:35], v[248:251], v57, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v57, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[20:23], v[220:223], v56, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[20:23], v[224:227], v56, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[76:79], a[28:31], v[240:243], v56, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[28:31], v[236:239], v56, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[24:27], v[220:223], v56, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[24:27], v[224:227], v56, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[32:35], v[240:243], v56, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[32:35], v[236:239], v56, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[36:39], a[100:103], v56, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[36:39], a[104:107], v56, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[76:79], a[44:47], a[120:123], v56, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[44:47], a[116:119], v56, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[40:43], a[100:103], v56, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[40:43], a[104:107], v56, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[48:51], a[120:123], v56, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[48:51], a[116:119], v56, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[84:87], a[36:39], a[108:111], v57, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[92:95], a[36:39], a[112:115], v57, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[92:95], a[44:47], a[128:131], v57, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[84:87], a[44:47], a[124:127], v57, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[40:43], a[108:111], v57, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[96:99], a[40:43], a[112:115], v57, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[96:99], a[48:51], a[128:131], v57, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[48:51], a[124:127], v57, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[84:87], a[52:55], a[140:143], v57, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[92:95], a[52:55], a[144:147], v57, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[92:95], a[60:63], a[160:163], v57, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[84:87], a[60:63], a[156:159], v57, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[56:59], a[140:143], v57, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[96:99], a[56:59], a[144:147], v57, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[96:99], a[64:67], a[160:163], v57, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[64:67], a[156:159], v57, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[52:55], a[132:135], v56, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[76:79], a[52:55], a[136:139], v56, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[76:79], a[60:63], a[152:155], v56, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[60:63], a[148:151], v56, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[56:59], a[132:135], v56, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[56:59], a[136:139], v56, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[64:67], a[152:155], v56, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[64:67], a[148:151], v56, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[4:7], v47
		ds_read_b128 a[8:11], v47 offset:64
		ds_read_b128 a[12:15], v47 offset:256
		ds_read_b128 a[16:19], v47 offset:320
		ds_read_b128 a[20:23], v47 offset:512
		ds_read_b128 a[24:27], v47 offset:576
		ds_read_b128 a[28:31], v47 offset:768
		ds_read_b128 a[32:35], v47 offset:832
		ds_read_b128 a[36:39], v47 offset:16896
		ds_read_b128 a[40:43], v47 offset:16960
		ds_read_b128 a[44:47], v47 offset:17152
		ds_read_b128 a[48:51], v47 offset:17216
		ds_read_b128 a[52:55], v47 offset:17408
		ds_read_b128 a[56:59], v47 offset:17472
		ds_read_b128 a[60:63], v47 offset:17664
		ds_read_b128 a[64:67], v47 offset:17728
		ds_read_b128 a[68:71], v49 offset:2016
		ds_read_b128 a[72:75], v49 offset:2080
		ds_read_b128 a[76:79], v49 offset:2272
		ds_read_b128 a[80:83], v49 offset:2336
		ds_read_b128 a[84:87], v49 offset:2528
		ds_read_b128 a[88:91], v49 offset:2592
		ds_read_b128 a[92:95], v49 offset:2784
		ds_read_b128 a[96:99], v49 offset:2848
		s_waitcnt vmcnt(20)
		ds_write_b64 v50, v[252:253] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v51, v24 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[22:23], v33 offset:4000
		ds_read_b64_tr_b8 v[56:57], v33 offset:4128
		ds_read_b64_tr_b8 v[58:59], v5 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v45, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v46, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		buffer_load_dword v44, v3, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s1, s1, 0x100
		s_add_i32 s14, s14, 0x100
		s_add_i32 s15, s15, s43
		s_add_i32 s18, s18, s13
		s_setprio 0
		s_barrier
		s_add_i32 s12, s12, 2
		s_cmp_lt_i32 s12, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[56:57], s[30:31]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_1
		s_barrier
.L_a4w4_kernel.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[68:71], a[4:7], v[60:63], v58, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[76:79], a[4:7], v[64:67], v58, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[12:15], v[80:83], v58, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[12:15], v[76:79], v58, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[72:75], a[8:11], v[60:63], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[80:83], a[8:11], v[64:67], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[16:19], v[80:83], v58, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[16:19], v[76:79], v58, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[84:87], a[4:7], v[68:71], v59, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[92:95], a[4:7], v[72:75], v59, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[12:15], v[88:91], v59, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[12:15], v[84:87], v59, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[88:91], a[8:11], v[68:71], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], a[8:11], v[72:75], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], a[16:19], v[88:91], v59, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[16:19], v[84:87], v59, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[20:23], v[100:103], v59, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[20:23], v[104:107], v59, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[28:31], v[120:123], v59, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[28:31], v[116:119], v59, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[24:27], v[100:103], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], a[24:27], v[104:107], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[32:35], v[120:123], v59, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[32:35], v[116:119], v59, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[20:23], v[92:95], v58, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[20:23], v[96:99], v58, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[28:31], v[112:115], v58, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[28:31], v[108:111], v58, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[24:27], v[92:95], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[24:27], v[96:99], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[32:35], v[112:115], v58, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[32:35], v[108:111], v58, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[36:39], v[124:127], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[36:39], v[128:131], v58, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[44:47], v[144:147], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[44:47], v[140:143], v58, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[40:43], v[124:127], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[40:43], v[128:131], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[48:51], v[144:147], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[48:51], v[140:143], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[36:39], v[132:135], v59, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[36:39], v[136:139], v59, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[44:47], v[152:155], v59, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[44:47], v[148:151], v59, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[40:43], v[132:135], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[40:43], v[136:139], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[48:51], v[152:155], v59, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[48:51], v[148:151], v59, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[52:55], v[164:167], v59, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[52:55], v[168:171], v59, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[60:63], v[184:187], v59, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[60:63], v[180:183], v59, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[56:59], v[164:167], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[56:59], v[168:171], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[64:67], v[184:187], v59, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[64:67], v[180:183], v59, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[52:55], v[156:159], v58, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[52:55], v[160:163], v58, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[60:63], v[176:179], v58, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[60:63], v[172:175], v58, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[56:59], v[156:159], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[56:59], v[160:163], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[64:67], v[176:179], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[64:67], v[172:175], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[8:11], v49 offset:35776
		ds_read_b128 a[68:71], v49 offset:35840
		ds_read_b128 v[12:15], v49 offset:36032
		ds_read_b128 a[72:75], v49 offset:36096
		ds_read_b128 v[24:27], v49 offset:36288
		ds_read_b128 v[28:31], v49 offset:36352
		ds_read_b128 v[40:43], v49 offset:36544
		ds_read_b128 v[252:255], v49 offset:36608
		s_barrier
		ds_write_b32 v51, v36 offset:6048
		v_lshlrev_b32_e32 v1, 2, v4
		v_accvgpr_read_b32 v2, a1
		v_lshlrev_b32_e32 v2, 3, v2
		v_bitop3_b32 v1, v0, v1, v2 bitop3:0x96
		v_accvgpr_read_b32 v2, a2
		v_lshl_add_u32 v2, s21, 2, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v5 offset:6048
		v_accvgpr_read_b32 v3, a3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v4, 4, v1
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[8:11], a[4:7], v[188:191], v6, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[12:15], a[4:7], v[192:195], v6, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[12:15], a[12:15], v[208:211], v6, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[8:11], a[12:15], v[204:207], v6, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[8:11], v[188:191], v6, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[72:75], a[8:11], v[192:195], v6, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[72:75], a[16:19], v[208:211], v6, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[16:19], v[204:207], v6, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], a[4:7], v[196:199], v7, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[4:7], v[200:203], v7, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[12:15], v[216:219], v7, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], a[12:15], v[212:215], v7, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], a[8:11], v[196:199], v7, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], a[8:11], v[200:203], v7, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], a[16:19], v[216:219], v7, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], a[16:19], v[212:215], v7, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], a[20:23], v[228:231], v7, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[20:23], v[232:235], v7, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[40:43], a[28:31], v[248:251], v7, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[24:27], a[28:31], v[244:247], v7, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[24:27], v[228:231], v7, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[24:27], v[232:235], v7, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[32:35], v[248:251], v7, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], a[32:35], v[244:247], v7, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[8:11], a[20:23], v[220:223], v6, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[12:15], a[20:23], v[224:227], v6, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[12:15], a[28:31], v[240:243], v6, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[8:11], a[28:31], v[236:239], v6, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[24:27], v[220:223], v6, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[72:75], a[24:27], v[224:227], v6, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[32:35], v[240:243], v6, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[32:35], v[236:239], v6, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[8:11], a[36:39], a[100:103], v6, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[12:15], a[36:39], a[104:107], v6, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[12:15], a[44:47], a[120:123], v6, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[8:11], a[44:47], a[116:119], v6, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[40:43], a[100:103], v6, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[40:43], a[104:107], v6, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[72:75], a[48:51], a[120:123], v6, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[48:51], a[116:119], v6, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[36:39], a[108:111], v7, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[36:39], a[112:115], v7, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[44:47], a[128:131], v7, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[44:47], a[124:127], v7, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[40:43], a[108:111], v7, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[252:255], a[40:43], a[112:115], v7, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[252:255], a[48:51], a[128:131], v7, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[48:51], a[124:127], v7, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[52:55], a[140:143], v7, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[52:55], a[144:147], v7, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[60:63], a[160:163], v7, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[60:63], a[156:159], v7, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[56:59], a[140:143], v7, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[252:255], a[56:59], a[144:147], v7, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[252:255], a[64:67], a[160:163], v7, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[64:67], a[156:159], v7, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[8:11], a[52:55], a[132:135], v6, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[12:15], a[52:55], a[136:139], v6, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[12:15], a[60:63], a[152:155], v6, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[8:11], a[60:63], a[148:151], v6, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[56:59], a[132:135], v6, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[72:75], a[56:59], a[136:139], v6, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[72:75], a[64:67], a[152:155], v6, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[64:67], a[148:151], v6, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v47 offset:33792
		ds_read_b128 a[4:7], v47 offset:33856
		ds_read_b128 a[8:11], v47 offset:34048
		ds_read_b128 a[12:15], v47 offset:34112
		ds_read_b128 a[16:19], v47 offset:34304
		ds_read_b128 a[20:23], v47 offset:34368
		ds_read_b128 a[24:27], v47 offset:34560
		ds_read_b128 a[28:31], v47 offset:34624
		ds_read_b128 a[32:35], v47 offset:50688
		ds_read_b128 a[36:39], v47 offset:50752
		ds_read_b128 a[40:43], v47 offset:50944
		ds_read_b128 a[44:47], v47 offset:51008
		ds_read_b128 a[48:51], v47 offset:51200
		ds_read_b128 a[52:55], v47 offset:51264
		ds_read_b128 a[56:59], v47 offset:51456
		ds_read_b128 a[60:63], v47 offset:51520
		ds_read_b128 v[12:15], v49 offset:18912
		ds_read_b128 v[20:23], v49 offset:18976
		ds_read_b128 v[24:27], v49 offset:19168
		ds_read_b128 v[28:31], v49 offset:19232
		ds_read_b128 v[36:39], v49 offset:19424
		ds_read_b128 v[40:43], v49 offset:19488
		ds_read_b128 v[56:59], v49 offset:19680
		ds_read_b128 v[252:255], v49 offset:19744
		ds_write_b64 v50, v[54:55] offset:4000
		v_xor_b32_e32 v6, 1, v1
		v_lshlrev_b32_e32 v6, 4, v6
		v_xor_b32_e32 v7, 2, v1
		v_lshlrev_b32_e32 v7, 4, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v51, v19 offset:6048
		ds_read_b64_tr_b8 v[16:17], v33 offset:4000
		ds_read_b64_tr_b8 v[18:19], v33 offset:4128
		v_xor_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_lshrrev_b32_e32 v32, 3, v48
		v_and_b32_e32 v32, 1, v32
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[34:35], v5 offset:6048
		v_lshrrev_b32_e32 v33, 2, v48
		v_and_b32_e32 v45, 1, v33
		v_lshlrev_b32_e32 v45, 12, v45
		v_lshl_add_u32 v32, v32, 13, v45
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[12:15], v[8:11], v[60:63], v34, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[24:27], v[8:11], v[64:67], v34, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[24:27], a[8:11], v[80:83], v34, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], a[8:11], v[76:79], v34, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[20:23], a[4:7], v[60:63], v34, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[28:31], a[4:7], v[64:67], v34, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], a[12:15], v[80:83], v34, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], a[12:15], v[76:79], v34, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[36:39], v[8:11], v[68:71], v35, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[56:59], v[8:11], v[72:75], v35, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[56:59], a[8:11], v[88:91], v35, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[36:39], a[8:11], v[84:87], v35, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[40:43], a[4:7], v[68:71], v35, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[252:255], a[4:7], v[72:75], v35, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[252:255], a[12:15], v[88:91], v35, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[40:43], a[12:15], v[84:87], v35, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[36:39], a[16:19], v[100:103], v35, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[56:59], a[16:19], v[104:107], v35, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[56:59], a[24:27], v[120:123], v35, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], a[24:27], v[116:119], v35, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[40:43], a[20:23], v[100:103], v35, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[252:255], a[20:23], v[104:107], v35, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[252:255], a[28:31], v[120:123], v35, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], a[28:31], v[116:119], v35, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[12:15], a[16:19], v[92:95], v34, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[24:27], a[16:19], v[96:99], v34, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[24:27], a[24:27], v[112:115], v34, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], a[24:27], v[108:111], v34, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], a[20:23], v[92:95], v34, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[28:31], a[20:23], v[96:99], v34, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[28:31], a[28:31], v[112:115], v34, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], a[28:31], v[108:111], v34, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], a[32:35], v[124:127], v34, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], a[32:35], v[128:131], v34, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], a[40:43], v[144:147], v34, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[12:15], a[40:43], v[140:143], v34, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], a[36:39], v[124:127], v34, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], a[36:39], v[128:131], v34, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], a[44:47], v[144:147], v34, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], a[44:47], v[140:143], v34, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], a[32:35], v[132:135], v35, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[56:59], a[32:35], v[136:139], v35, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[56:59], a[40:43], v[152:155], v35, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], a[40:43], v[148:151], v35, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], a[36:39], v[132:135], v35, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], a[36:39], v[136:139], v35, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], a[44:47], v[152:155], v35, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], a[44:47], v[148:151], v35, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], a[48:51], v[164:167], v35, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], a[48:51], v[168:171], v35, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], a[56:59], v[184:187], v35, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], a[56:59], v[180:183], v35, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], a[52:55], v[164:167], v35, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], a[52:55], v[168:171], v35, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], a[60:63], v[184:187], v35, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], a[60:63], v[180:183], v35, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[12:15], a[48:51], v[156:159], v34, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], a[48:51], v[160:163], v34, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], a[56:59], v[176:179], v34, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], a[56:59], v[172:175], v34, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], a[52:55], v[156:159], v34, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], a[52:55], v[160:163], v34, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], a[60:63], v[176:179], v34, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], a[60:63], v[172:175], v34, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v49 offset:52672
		ds_read_b128 v[20:23], v49 offset:52736
		ds_read_b128 v[24:27], v49 offset:52928
		ds_read_b128 v[28:31], v49 offset:52992
		ds_read_b128 v[36:39], v49 offset:53184
		ds_read_b128 v[40:43], v49 offset:53248
		ds_read_b128 v[52:55], v49 offset:53440
		ds_read_b128 v[56:59], v49 offset:53504
		v_cvt_pk_bf16_f32 v252, v60, v61
		v_cvt_pk_bf16_f32 v253, v62, v63
		v_cvt_pk_bf16_f32 v60, v64, v65
		v_cvt_pk_bf16_f32 v61, v66, v67
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v51, v44 offset:6048
		v_cvt_pk_bf16_f32 v44, v68, v69
		v_cvt_pk_bf16_f32 v45, v70, v71
		v_cvt_pk_bf16_f32 v64, v72, v73
		v_cvt_pk_bf16_f32 v65, v74, v75
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[34:35], v5 offset:6048
		s_mul_i32 s1, s16, s17
		v_cvt_pk_bf16_f32 v254, v76, v77
		v_cvt_pk_bf16_f32 v255, v78, v79
		v_cvt_pk_bf16_f32 v62, v80, v81
		v_cvt_pk_bf16_f32 v63, v82, v83
		v_cvt_pk_bf16_f32 v46, v84, v85
		v_cvt_pk_bf16_f32 v47, v86, v87
		v_cvt_pk_bf16_f32 v66, v88, v89
		v_cvt_pk_bf16_f32 v67, v90, v91
		v_cvt_pk_bf16_f32 v68, v92, v93
		v_cvt_pk_bf16_f32 v69, v94, v95
		v_cvt_pk_bf16_f32 v72, v96, v97
		v_cvt_pk_bf16_f32 v73, v98, v99
		v_cvt_pk_bf16_f32 v76, v100, v101
		v_cvt_pk_bf16_f32 v77, v102, v103
		v_cvt_pk_bf16_f32 v80, v104, v105
		v_cvt_pk_bf16_f32 v81, v106, v107
		v_cvt_pk_bf16_f32 v70, v108, v109
		v_cvt_pk_bf16_f32 v71, v110, v111
		v_cvt_pk_bf16_f32 v74, v112, v113
		v_cvt_pk_bf16_f32 v75, v114, v115
		v_cvt_pk_bf16_f32 v78, v116, v117
		v_cvt_pk_bf16_f32 v79, v118, v119
		v_cvt_pk_bf16_f32 v82, v120, v121
		v_cvt_pk_bf16_f32 v83, v122, v123
		v_cvt_pk_bf16_f32 v84, v124, v125
		v_cvt_pk_bf16_f32 v85, v126, v127
		v_cvt_pk_bf16_f32 v88, v128, v129
		v_cvt_pk_bf16_f32 v89, v130, v131
		v_cvt_pk_bf16_f32 v92, v132, v133
		v_cvt_pk_bf16_f32 v93, v134, v135
		v_cvt_pk_bf16_f32 v96, v136, v137
		v_cvt_pk_bf16_f32 v97, v138, v139
		v_cvt_pk_bf16_f32 v86, v140, v141
		v_cvt_pk_bf16_f32 v87, v142, v143
		v_cvt_pk_bf16_f32 v90, v144, v145
		v_cvt_pk_bf16_f32 v91, v146, v147
		v_cvt_pk_bf16_f32 v94, v148, v149
		v_cvt_pk_bf16_f32 v95, v150, v151
		v_cvt_pk_bf16_f32 v98, v152, v153
		v_cvt_pk_bf16_f32 v99, v154, v155
		v_cvt_pk_bf16_f32 v100, v156, v157
		v_cvt_pk_bf16_f32 v101, v158, v159
		v_cvt_pk_bf16_f32 v104, v160, v161
		v_cvt_pk_bf16_f32 v105, v162, v163
		v_cvt_pk_bf16_f32 v108, v164, v165
		v_cvt_pk_bf16_f32 v109, v166, v167
		v_cvt_pk_bf16_f32 v112, v168, v169
		v_cvt_pk_bf16_f32 v113, v170, v171
		v_cvt_pk_bf16_f32 v102, v172, v173
		v_cvt_pk_bf16_f32 v103, v174, v175
		v_cvt_pk_bf16_f32 v106, v176, v177
		v_cvt_pk_bf16_f32 v107, v178, v179
		v_cvt_pk_bf16_f32 v110, v180, v181
		v_cvt_pk_bf16_f32 v111, v182, v183
		v_cvt_pk_bf16_f32 v114, v184, v185
		v_cvt_pk_bf16_f32 v115, v186, v187
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[252:255]
		ds_write_b128 v6, v[60:63] offset:4096
		ds_write_b128 v7, v[44:47] offset:8192
		ds_write_b128 v1, v[64:67] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v5, 3, v48
		v_lshl_add_u32 v2, v5, 5, v2
		v_lshrrev_b32_e32 v5, 1, v48
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 3, v5
		v_bitop3_b32 v5, v5, v33, 3 bitop3:0x78
		v_bitop3_b32 v2, v2, v3, v5 bitop3:0x96
		v_lshl_add_u32 v2, v2, 4, v32
		ds_read_b128 v[44:47], v2
		ds_read_b128 v[48:51], v2 offset:256
		ds_read_b128 v[60:63], v2 offset:2048
		ds_read_b128 v[64:67], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[68:71]
		ds_write_b128 v6, v[72:75] offset:4096
		ds_write_b128 v7, v[76:79] offset:8192
		ds_write_b128 v1, v[80:83] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v2
		ds_read_b128 v[72:75], v2 offset:256
		ds_read_b128 v[76:79], v2 offset:2048
		ds_read_b128 v[80:83], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[84:87]
		ds_write_b128 v6, v[88:91] offset:4096
		ds_write_b128 v7, v[92:95] offset:8192
		ds_write_b128 v1, v[96:99] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v2
		ds_read_b128 v[88:91], v2 offset:256
		ds_read_b128 v[92:95], v2 offset:2048
		ds_read_b128 v[96:99], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[100:103]
		ds_write_b128 v6, v[104:107] offset:4096
		ds_write_b128 v7, v[108:111] offset:8192
		ds_write_b128 v1, v[112:115] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[100:103], v2
		ds_read_b128 v[104:107], v2 offset:256
		ds_read_b128 v[108:111], v2 offset:2048
		ds_read_b128 v[112:115], v2 offset:2304
		v_accvgpr_read_b32 v3, a0
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add3_u32 v5, s0, v3, v0
		v_mov_b64_e32 v[116:117], v[44:45]
		v_mov_b64_e32 v[118:119], v[48:49]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[116:119], v5, s[8:11], 0 offen
		s_lshl_b32 s1, s17, 5
		s_add_i32 s2, s0, s1
		v_add3_u32 v5, s2, v3, v0
		v_mov_b64_e32 v[116:117], v[60:61]
		v_mov_b64_e32 v[118:119], v[64:65]
		buffer_store_dwordx4 v[116:119], v5, s[8:11], 0 offen
		s_lshl_b32 s2, s17, 6
		s_add_i32 s3, s0, s2
		v_add3_u32 v5, s3, v3, v0
		v_mov_b64_e32 v[116:117], v[46:47]
		v_mov_b64_e32 v[118:119], v[50:51]
		buffer_store_dwordx4 v[116:119], v5, s[8:11], 0 offen
		s_mul_i32 s3, 0x60, s17
		s_add_i32 s4, s0, s3
		v_add3_u32 v5, s4, v3, v0
		v_mov_b64_e32 v[44:45], v[62:63]
		v_mov_b64_e32 v[46:47], v[66:67]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_lshl_b32 s4, s17, 7
		s_add_i32 s5, s0, s4
		v_add3_u32 v5, s5, v3, v0
		v_mov_b64_e32 v[44:45], v[68:69]
		v_mov_b64_e32 v[46:47], v[72:73]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s5, 0xa0, s17
		s_add_i32 s6, s0, s5
		v_add3_u32 v5, s6, v3, v0
		v_mov_b64_e32 v[44:45], v[76:77]
		v_mov_b64_e32 v[46:47], v[80:81]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s6, 0xc0, s17
		s_add_i32 s7, s0, s6
		v_add3_u32 v5, s7, v3, v0
		v_mov_b64_e32 v[44:45], v[70:71]
		v_mov_b64_e32 v[46:47], v[74:75]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s7, 0xe0, s17
		s_add_i32 s12, s0, s7
		v_add3_u32 v5, s12, v3, v0
		v_mov_b64_e32 v[44:45], v[78:79]
		v_mov_b64_e32 v[46:47], v[82:83]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_lshl_b32 s12, s17, 8
		s_add_i32 s13, s0, s12
		v_add3_u32 v5, s13, v3, v0
		v_mov_b64_e32 v[44:45], v[84:85]
		v_mov_b64_e32 v[46:47], v[88:89]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s13, 0x120, s17
		s_add_i32 s14, s0, s13
		v_add3_u32 v5, s14, v3, v0
		v_mov_b64_e32 v[44:45], v[92:93]
		v_mov_b64_e32 v[46:47], v[96:97]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s14, 0x140, s17
		s_add_i32 s15, s0, s14
		v_add3_u32 v5, s15, v3, v0
		v_mov_b64_e32 v[44:45], v[86:87]
		v_mov_b64_e32 v[46:47], v[90:91]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s15, 0x160, s17
		s_add_i32 s16, s0, s15
		v_add3_u32 v5, s16, v3, v0
		v_mov_b64_e32 v[44:45], v[94:95]
		v_mov_b64_e32 v[46:47], v[98:99]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s16, 0x180, s17
		s_add_i32 s18, s0, s16
		v_add3_u32 v5, s18, v3, v0
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[44:45], v[100:101]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[46:47], v[104:105]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s18, 0x1a0, s17
		s_add_i32 s19, s0, s18
		v_add3_u32 v5, s19, v3, v0
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[44:45], v[108:109]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[46:47], v[112:113]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s19, 0x1c0, s17
		s_add_i32 s20, s0, s19
		v_add3_u32 v5, s20, v3, v0
		v_mov_b64_e32 v[44:45], v[102:103]
		v_mov_b64_e32 v[46:47], v[106:107]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		s_mul_i32 s17, 0x1e0, s17
		s_add_i32 s20, s0, s17
		v_add3_u32 v5, s20, v3, v0
		v_mov_b64_e32 v[44:45], v[110:111]
		v_mov_b64_e32 v[46:47], v[114:115]
		buffer_store_dwordx4 v[44:47], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[12:15], v[8:11], v[188:191], v34, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[8:11], v[192:195], v34, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[8:11], v[208:211], v34, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[12:15], a[8:11], v[204:207], v34, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], a[4:7], v[188:191], v34, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], a[4:7], v[192:195], v34, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], a[12:15], v[208:211], v34, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], a[12:15], v[204:207], v34, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[8:11], v[196:199], v35, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], v[8:11], v[200:203], v35, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[8:11], v[216:219], v35, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], a[8:11], v[212:215], v35, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], a[4:7], v[196:199], v35, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v8, v188, v189
		v_cvt_pk_bf16_f32 v9, v190, v191
		v_cvt_pk_bf16_f32 v44, v192, v193
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], a[4:7], v[200:203], v35, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v45, v194, v195
		v_cvt_pk_bf16_f32 v10, v204, v205
		v_cvt_pk_bf16_f32 v11, v206, v207
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], a[12:15], v[216:219], v35, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v48, v196, v197
		v_cvt_pk_bf16_f32 v49, v198, v199
		v_cvt_pk_bf16_f32 v46, v208, v209
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], a[12:15], v[212:215], v35, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v200, v201
		v_cvt_pk_bf16_f32 v61, v202, v203
		v_cvt_pk_bf16_f32 v47, v210, v211
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], a[16:19], v[228:231], v35, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v62, v216, v217
		v_cvt_pk_bf16_f32 v63, v218, v219
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], a[16:19], v[232:235], v35, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[24:27], v[248:251], v35, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v50, v212, v213
		v_cvt_pk_bf16_f32 v51, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[36:39], a[24:27], v[244:247], v35, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], a[20:23], v[228:231], v35, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[20:23], v[232:235], v35, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[56:59], a[28:31], v[248:251], v35, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[28:31], v[244:247], v35, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[12:15], a[16:19], v[220:223], v34, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], a[16:19], v[224:227], v34, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], a[24:27], v[240:243], v34, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[12:15], a[24:27], v[236:239], v34, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[20:23], a[20:23], v[220:223], v34, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v228, v229
		v_cvt_pk_bf16_f32 v65, v230, v231
		v_cvt_pk_bf16_f32 v68, v232, v233
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], a[20:23], v[224:227], v34, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v69, v234, v235
		v_cvt_pk_bf16_f32 v66, v244, v245
		v_cvt_pk_bf16_f32 v67, v246, v247
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], a[28:31], v[240:243], v34, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v72, v220, v221
		v_cvt_pk_bf16_f32 v73, v222, v223
		v_cvt_pk_bf16_f32 v70, v248, v249
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[20:23], a[28:31], v[236:239], v34, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v76, v224, v225
		v_cvt_pk_bf16_f32 v77, v226, v227
		v_cvt_pk_bf16_f32 v71, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[12:15], a[32:35], a[100:103], v34, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v78, v240, v241
		v_cvt_pk_bf16_f32 v79, v242, v243
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], a[32:35], a[104:107], v34, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], a[40:43], a[120:123], v34, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v74, v236, v237
		v_cvt_pk_bf16_f32 v75, v238, v239
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[12:15], a[40:43], a[116:119], v34, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], a[36:39], a[100:103], v34, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], a[36:39], a[104:107], v34, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], a[44:47], a[120:123], v34, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[44:47], a[116:119], v34, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[32:35], a[108:111], v35, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[52:55], a[32:35], a[112:115], v35, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[40:43], a[128:131], v35, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], a[40:43], a[124:127], v35, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], a[36:39], a[108:111], v35, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v16, a101
		v_cvt_pk_bf16_f32 v80, v5, v16
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v16, a103
		v_cvt_pk_bf16_f32 v81, v5, v16
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v16, a105
		v_cvt_pk_bf16_f32 v84, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[56:59], a[36:39], a[112:115], v35, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v16, a107
		v_cvt_pk_bf16_f32 v85, v5, v16
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v16, a117
		v_cvt_pk_bf16_f32 v82, v5, v16
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v16, a119
		v_cvt_pk_bf16_f32 v83, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], a[44:47], a[128:131], v35, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v16, a109
		v_cvt_pk_bf16_f32 v88, v5, v16
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v16, a111
		v_cvt_pk_bf16_f32 v89, v5, v16
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v16, a121
		v_cvt_pk_bf16_f32 v86, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], a[44:47], a[124:127], v35, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v16, a113
		v_cvt_pk_bf16_f32 v92, v5, v16
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v16, a115
		v_cvt_pk_bf16_f32 v93, v5, v16
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v16, a123
		v_cvt_pk_bf16_f32 v87, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[36:39], a[48:51], a[140:143], v35, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v16, a129
		v_cvt_pk_bf16_f32 v94, v5, v16
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v16, a131
		v_cvt_pk_bf16_f32 v95, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[48:51], a[144:147], v35, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[56:59], a[160:163], v35, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v16, a125
		v_cvt_pk_bf16_f32 v90, v5, v16
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v16, a127
		v_cvt_pk_bf16_f32 v91, v5, v16
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], a[56:59], a[156:159], v35, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[40:43], a[52:55], a[140:143], v35, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], a[52:55], a[144:147], v35, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], a[60:63], a[160:163], v35, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[40:43], a[60:63], a[156:159], v35, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[12:15], a[48:51], a[132:135], v34, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], a[48:51], a[136:139], v34, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], a[56:59], a[152:155], v34, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[12:15], a[56:59], a[148:151], v34, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[52:55], a[132:135], v34, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v12, a141
		v_cvt_pk_bf16_f32 v24, v5, v12
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v12, a143
		v_cvt_pk_bf16_f32 v25, v5, v12
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v12, a145
		v_cvt_pk_bf16_f32 v36, v5, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], a[52:55], a[136:139], v34, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v12, a147
		v_cvt_pk_bf16_f32 v37, v5, v12
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v12, a157
		v_cvt_pk_bf16_f32 v26, v5, v12
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v12, a159
		v_cvt_pk_bf16_f32 v27, v5, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], a[60:63], a[152:155], v34, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v12, a133
		v_cvt_pk_bf16_f32 v28, v5, v12
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v12, a135
		v_cvt_pk_bf16_f32 v29, v5, v12
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v12, a161
		v_cvt_pk_bf16_f32 v38, v5, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[60:63], a[148:151], v34, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v12, a137
		v_cvt_pk_bf16_f32 v16, v5, v12
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v12, a139
		v_cvt_pk_bf16_f32 v17, v5, v12
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v12, a163
		v_cvt_pk_bf16_f32 v39, v5, v12
		s_barrier
		ds_write_b128 v4, v[8:11] offset:16384
		ds_write_b128 v6, v[44:47] offset:20480
		ds_write_b128 v7, v[48:51] offset:24576
		ds_write_b128 v1, v[60:63] offset:28672
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v30, v5, v8
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v31, v5, v8
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v18, v5, v8
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v19, v5, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v2 offset:16384
		ds_read_b128 v[12:15], v2 offset:16640
		ds_read_b128 v[20:23], v2 offset:18432
		ds_read_b128 v[32:35], v2 offset:18688
		s_add_i32 s0, s0, 0x100
		s_add_i32 s1, s0, s1
		s_add_i32 s2, s0, s2
		s_add_i32 s3, s0, s3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[72:75] offset:16384
		ds_write_b128 v6, v[76:79] offset:20480
		ds_write_b128 v7, v[64:67] offset:24576
		ds_write_b128 v1, v[68:71] offset:28672
		s_add_i32 s4, s0, s4
		s_add_i32 s5, s0, s5
		s_add_i32 s6, s0, s6
		s_add_i32 s7, s0, s7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v2 offset:16384
		ds_read_b128 v[44:47], v2 offset:16640
		ds_read_b128 v[48:51], v2 offset:18432
		ds_read_b128 v[52:55], v2 offset:18688
		s_add_i32 s12, s0, s12
		s_add_i32 s13, s0, s13
		s_add_i32 s14, s0, s14
		s_add_i32 s15, s0, s15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[80:83] offset:16384
		ds_write_b128 v6, v[84:87] offset:20480
		ds_write_b128 v7, v[88:91] offset:24576
		ds_write_b128 v1, v[92:95] offset:28672
		s_add_i32 s16, s0, s16
		s_add_i32 s18, s0, s18
		s_add_i32 s19, s0, s19
		s_add_i32 s17, s0, s17
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v2 offset:16384
		ds_read_b128 v[60:63], v2 offset:16640
		ds_read_b128 v[64:67], v2 offset:18432
		ds_read_b128 v[68:71], v2 offset:18688
		v_add3_u32 v5, s0, v3, v0
		v_mov_b64_e32 v[72:73], v[8:9]
		v_mov_b64_e32 v[74:75], v[12:13]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		v_add3_u32 v5, s1, v3, v0
		s_nop 0
		v_mov_b64_e32 v[72:73], v[20:21]
		v_mov_b64_e32 v[74:75], v[32:33]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[28:31] offset:16384
		ds_write_b128 v6, v[16:19] offset:20480
		ds_write_b128 v7, v[24:27] offset:24576
		ds_write_b128 v1, v[36:39] offset:28672
		v_add3_u32 v1, s2, v3, v0
		v_mov_b64_e32 v[4:5], v[10:11]
		v_mov_b64_e32 v[6:7], v[14:15]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, s3, v3, v0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[22:23]
		v_mov_b64_e32 v[6:7], v[34:35]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v2 offset:16384
		ds_read_b128 v[8:11], v2 offset:16640
		ds_read_b128 v[12:15], v2 offset:18432
		ds_read_b128 v[16:19], v2 offset:18688
		v_add3_u32 v1, s4, v3, v0
		v_mov_b64_e32 v[20:21], v[40:41]
		v_mov_b64_e32 v[22:23], v[44:45]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s5, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[48:49]
		v_mov_b64_e32 v[22:23], v[52:53]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s6, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[42:43]
		v_mov_b64_e32 v[22:23], v[46:47]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s7, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[50:51]
		v_mov_b64_e32 v[22:23], v[54:55]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s12, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[56:57]
		v_mov_b64_e32 v[22:23], v[60:61]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s13, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[64:65]
		v_mov_b64_e32 v[22:23], v[68:69]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s14, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[58:59]
		v_mov_b64_e32 v[22:23], v[62:63]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s15, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[66:67]
		v_mov_b64_e32 v[22:23], v[70:71]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s16, v3, v0
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mov_b64_e32 v[20:21], v[4:5]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[22:23], v[8:9]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s18, v3, v0
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mov_b64_e32 v[20:21], v[12:13]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[22:23], v[16:17]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, s19, v3, v0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[6:7]
		v_mov_b64_e32 v[22:23], v[10:11]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v0, s17, v3, v0
		v_mov_b64_e32 v[4:5], v[14:15]
		v_mov_b64_e32 v[6:7], v[18:19]
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
		.amdhsa_next_free_vgpr 420
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
	.set .L_a4w4_kernel.num_agpr, 164
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
    .vgpr_count:     420
    .agpr_count:     164
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 101
    wave.regalloc.agpr.dwords: 388
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
