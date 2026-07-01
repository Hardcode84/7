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
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 s0, s12, 0xff
		s_cmp_lt_i32 s0, 0
		s_mov_b32 s1, 0xff
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
		s_mul_i32 s12, s12, 32
		s_add_i32 s12, s12, s13
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s16, s12, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s16, s12
		s_cselect_b32 s16, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, 1, 0
		s_xor_b32 s21, s1, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s21, s1
		v_mov_b32_e32 v1, s20
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_xor_b32 s22, s20, -1
		s_add_i32 s22, s22, 1
		s_mul_i32 s23, s22, s21
		s_mul_hi_u32 s23, s21, s23
		s_add_i32 s21, s21, s23
		s_mul_hi_u32 s21, s13, s21
		s_mul_i32 s23, s21, s20
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s13, s13, s23
		s_cmp_ge_u32 s13, s20
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s21, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s24, s21
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s13, s22
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s13, s24, s13
		s_cmp_ge_u32 s13, s20
		s_cselect_b32 s20, 1, 0
		s_add_i32 s23, s21, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s23, s21
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s1, s12, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s12, s20, -1
		s_add_i32 s12, s12, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s12, s20
		s_mul_i32 s12, s1, 4
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s20, s13, s22
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s13, s20, s13
		s_xor_b32 s20, s13, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s20, s13
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s16, v1
		s_xor_b32 s20, s0, -1
		s_add_i32 s20, s20, 1
		s_mul_i32 s21, s20, s16
		s_mul_hi_u32 s21, s16, s21
		s_add_i32 s16, s16, s21
		s_mul_hi_u32 s16, s13, s16
		s_mul_i32 s16, s16, s0
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s16, s13, s16
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s16, s20
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s16, s20
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_add_i32 s12, s12, s16
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s22, s20, s21
		s_mul_hi_u32 s22, s21, s22
		s_add_i32 s21, s21, s22
		s_mul_hi_u32 s21, s13, s21
		s_mul_i32 s22, s21, s0
		s_xor_b32 s22, s22, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s13, s13, s22
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s21, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s21, s23, s21
		s_cselect_b32 s22, 1, 0
		s_add_i32 s20, s13, s20
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s13, s20, s13
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s13, s21, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s13, s21
		s_mul_i32 s12, s12, 0x100
		s_mul_i32 s13, s12, s14
		s_mul_i32 s20, s0, 0x100
		s_mul_i32 s20, s20, s15
		s_mov_b32 s21, 0
		s_add_u32 s22, s2, s13
		s_addc_u32 s23, s3, 0
		s_mov_b32 s24, s22
		s_mov_b32 s25, s23
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s22, v0
		v_lshrrev_b32_e32 v1, 7, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v8, s14, v3
		v_add_u32_e32 v9, v2, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v11, 1, v10
		v_mul_lo_u32 v12, s14, v11
		v_lshlrev_b32_e32 v12, 6, v12
		v_lshrrev_b32_e32 v13, 4, v0
		v_accvgpr_write_b32 a0, v13
		v_accvgpr_read_b32 v13, a0
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v14, s14, v13
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v9, v9, v12, v14
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v16, 1, v15
		v_mul_lo_u32 v17, s14, v16
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v0
		v_lshlrev_b32_e32 v19, 4, v18
		v_add3_u32 v9, v9, v17, v19
		v_lshrrev_b32_e32 v20, 2, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v21, 6, v20
		v_lshrrev_b32_e32 v22, 1, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v23, 5, v22
		v_add3_u32 v9, v9, v21, v23
		s_lshr_b32 s22, s22, 6
		s_mul_i32 s22, 0x420, s22
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_lshl_b32 s23, s14, 2
		v_add3_u32 v24, s23, v2, v8
		v_add3_u32 v24, v24, v12, v14
		v_add3_u32 v24, v24, v17, v19
		v_add3_u32 v24, v24, v21, v23
		s_add_i32 s28, s22, 0x1080
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_lshl_b32 s29, s14, 3
		v_add3_u32 v25, s29, v2, v8
		v_add3_u32 v25, v25, v12, v14
		v_add3_u32 v25, v25, v17, v19
		v_add3_u32 v25, v25, v21, v23
		s_add_i32 s30, s22, 0x2100
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s31, 12, s14
		v_add3_u32 v26, s31, v2, v8
		v_add3_u32 v26, v26, v12, v14
		v_add3_u32 v26, v26, v17, v19
		v_add3_u32 v26, v26, v21, v23
		s_add_i32 s32, s22, 0x3180
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_lshl_b32 s33, s14, 7
		v_add3_u32 v27, s33, v2, v8
		v_add3_u32 v27, v27, v12, v14
		v_add3_u32 v27, v27, v17, v19
		v_add3_u32 v27, v27, v21, v23
		s_add_i32 s34, s22, 0x4200
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mul_i32 s35, 0x84, s14
		v_add3_u32 v28, s35, v2, v8
		v_add3_u32 v28, v28, v12, v14
		v_add3_u32 v28, v28, v17, v19
		v_add3_u32 v28, v28, v21, v23
		s_add_i32 s36, s22, 0x5280
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s37, 0x88, s14
		v_add3_u32 v29, s37, v2, v8
		v_add3_u32 v29, v29, v12, v14
		v_add3_u32 v29, v29, v17, v19
		v_add3_u32 v29, v29, v21, v23
		s_add_i32 s38, s22, 0x6300
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		v_add3_u32 v30, s14, v2, v8
		v_add3_u32 v30, v30, v12, v14
		v_add3_u32 v30, v30, v17, v19
		v_add3_u32 v30, v30, v21, v23
		s_add_i32 s39, s22, 0x7380
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		s_add_u32 s40, s4, s20
		s_addc_u32 s41, s5, 0
		s_mov_b32 s44, s40
		s_mov_b32 s45, s41
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		v_mul_lo_u32 v31, s15, v1
		v_lshlrev_b32_e32 v31, 1, v31
		v_mul_lo_u32 v32, s15, v3
		v_add_u32_e32 v33, v31, v32
		v_mul_lo_u32 v34, s15, v11
		v_lshlrev_b32_e32 v34, 6, v34
		v_mul_lo_u32 v35, s15, v13
		v_lshlrev_b32_e32 v35, 5, v35
		v_add3_u32 v33, v33, v34, v35
		v_mul_lo_u32 v36, s15, v16
		v_lshlrev_b32_e32 v36, 4, v36
		v_add3_u32 v33, v33, v36, v19
		v_add3_u32 v33, v33, v21, v23
		s_add_i32 s40, s22, 0x107c0
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v33, s[44:47], 0 offen lds
		s_lshl_b32 s41, s15, 2
		v_add3_u32 v37, s41, v31, v32
		v_add3_u32 v37, v37, v34, v35
		v_add3_u32 v37, v37, v36, v19
		v_add3_u32 v37, v37, v21, v23
		s_add_i32 s42, s22, 0x11840
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v37, s[44:47], 0 offen lds
		s_lshl_b32 s43, s15, 3
		v_add3_u32 v38, s43, v31, v32
		v_add3_u32 v38, v38, v34, v35
		v_add3_u32 v38, v38, v36, v19
		v_add3_u32 v38, v38, v21, v23
		s_add_i32 s48, s22, 0x128c0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		s_mul_i32 s49, 12, s15
		v_add3_u32 v39, s49, v31, v32
		v_add3_u32 v39, v39, v34, v35
		v_add3_u32 v39, v39, v36, v19
		v_add3_u32 v39, v39, v21, v23
		s_add_i32 s50, s22, 0x13940
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		s_mov_b32 s52, s8
		s_mov_b32 s53, s9
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 10
		s_mul_i32 s16, s16, s18
		s_lshl_b32 s16, s16, 8
		s_add_i32 s51, s1, s16
		v_mul_lo_u32 v40, s18, v1
		v_lshl_add_u32 v40, v40, 4, s51
		v_mul_lo_u32 v41, s18, v3
		v_lshl_add_u32 v40, v41, 3, v40
		v_mul_lo_u32 v41, s18, v11
		v_lshl_add_u32 v40, v41, 2, v40
		v_mul_lo_u32 v41, s18, v13
		v_lshl_add_u32 v40, v41, 1, v40
		v_mul_lo_u32 v42, s18, v16
		v_add3_u32 v40, v40, v42, v18
		v_lshlrev_b32_e32 v43, 2, v20
		v_lshlrev_b32_e32 v44, 1, v22
		v_add3_u32 v40, v40, v43, v44
		v_lshlrev_b32_e32 v45, 4, v1
		v_lshlrev_b32_e32 v46, 3, v3
		v_lshlrev_b32_e32 v47, 2, v11
		v_add_u32_e32 v48, 32, v16
		v_lshlrev_b32_e32 v49, 1, v13
		v_xor_b32_e32 v48, v48, v49
		v_xor_b32_e32 v48, v47, v48
		v_xor_b32_e32 v48, v46, v48
		v_xor_b32_e32 v48, v45, v48
		v_mul_lo_u32 v50, s18, v48
		v_add3_u32 v50, s51, v50, v18
		v_add3_u32 v50, v50, v43, v44
		v_add_u32_e32 v51, 64, v16
		v_xor_b32_e32 v51, v51, v49
		v_xor_b32_e32 v51, v47, v51
		v_xor_b32_e32 v51, v46, v51
		v_xor_b32_e32 v51, v45, v51
		v_mul_lo_u32 v52, s18, v51
		v_add3_u32 v52, s51, v52, v18
		v_add3_u32 v52, v52, v43, v44
		v_add_u32_e32 v53, 0x60, v16
		v_xor_b32_e32 v53, v53, v49
		v_xor_b32_e32 v53, v47, v53
		v_xor_b32_e32 v53, v46, v53
		v_xor_b32_e32 v53, v45, v53
		v_mul_lo_u32 v54, s18, v53
		v_add3_u32 v54, s51, v54, v18
		v_add3_u32 v54, v54, v43, v44
		v_add_u32_e32 v55, 0x80, v16
		v_xor_b32_e32 v55, v55, v49
		v_xor_b32_e32 v55, v47, v55
		v_xor_b32_e32 v55, v46, v55
		v_xor_b32_e32 v55, v45, v55
		v_mul_lo_u32 v56, s18, v55
		v_add3_u32 v56, s51, v56, v18
		v_add3_u32 v56, v56, v43, v44
		v_add_u32_e32 v57, 0xa0, v16
		v_xor_b32_e32 v57, v57, v49
		v_xor_b32_e32 v57, v47, v57
		v_xor_b32_e32 v57, v46, v57
		v_xor_b32_e32 v57, v45, v57
		v_mul_lo_u32 v58, s18, v57
		v_add3_u32 v58, s51, v58, v18
		v_add3_u32 v58, v58, v43, v44
		v_add_u32_e32 v59, 0xc0, v16
		v_xor_b32_e32 v59, v59, v49
		v_xor_b32_e32 v59, v47, v59
		v_xor_b32_e32 v59, v46, v59
		v_xor_b32_e32 v59, v45, v59
		v_mul_lo_u32 v60, s18, v59
		v_add3_u32 v60, s51, v60, v18
		v_add3_u32 v60, v60, v43, v44
		v_add_u32_e32 v61, 0xe0, v16
		v_xor_b32_e32 v49, v61, v49
		v_xor_b32_e32 v47, v47, v49
		v_xor_b32_e32 v46, v46, v47
		v_xor_b32_e32 v46, v45, v46
		v_mul_lo_u32 v47, s18, v46
		v_add3_u32 v47, s51, v47, v18
		v_add3_u32 v47, v47, v43, v44
		buffer_load_ubyte v49, v40, s[52:55], 0 offen
		buffer_load_ubyte v61, v50, s[52:55], 0 offen
		buffer_load_ubyte v62, v52, s[52:55], 0 offen
		buffer_load_ubyte v63, v54, s[52:55], 0 offen
		buffer_load_ubyte v64, v56, s[52:55], 0 offen
		buffer_load_ubyte v65, v58, s[52:55], 0 offen
		buffer_load_ubyte v66, v60, s[52:55], 0 offen
		buffer_load_ubyte v67, v47, s[52:55], 0 offen
		s_mov_b32 s56, s10
		s_mov_b32 s57, s11
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_mul_i32 s51, s0, s19
		s_lshl_b32 s51, s51, 8
		v_mul_lo_u32 v68, s19, v1
		v_lshl_add_u32 v68, v68, 4, s51
		v_mul_lo_u32 v69, s19, v3
		v_lshl_add_u32 v68, v69, 3, v68
		v_mul_lo_u32 v69, s19, v11
		v_lshl_add_u32 v68, v69, 2, v68
		v_mul_lo_u32 v69, s19, v13
		v_lshl_add_u32 v68, v69, 1, v68
		v_mul_lo_u32 v70, s19, v16
		v_add3_u32 v68, v68, v70, v18
		v_add3_u32 v68, v68, v43, v44
		v_mul_lo_u32 v71, s19, v48
		v_add3_u32 v71, s51, v71, v18
		v_add3_u32 v71, v71, v43, v44
		v_mul_lo_u32 v72, s19, v51
		v_add3_u32 v72, s51, v72, v18
		v_add3_u32 v72, v72, v43, v44
		v_mul_lo_u32 v73, s19, v53
		v_add3_u32 v73, s51, v73, v18
		v_add3_u32 v43, v73, v43, v44
		buffer_load_ubyte v44, v68, s[56:59], 0 offen
		buffer_load_ubyte v73, v71, s[56:59], 0 offen
		buffer_load_ubyte v74, v72, s[56:59], 0 offen
		buffer_load_ubyte v75, v43, s[56:59], 0 offen
		s_lshl_b32 s60, s15, 7
		v_add3_u32 v76, s60, v31, v32
		v_add3_u32 v76, v76, v34, v35
		v_add3_u32 v76, v76, v36, v19
		v_add3_u32 v76, v76, v21, v23
		s_add_i32 s61, s22, 0x18b80
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v76, s[44:47], 0 offen lds
		s_mul_i32 s62, 0x84, s15
		v_add3_u32 v77, s62, v31, v32
		v_add3_u32 v77, v77, v34, v35
		v_add3_u32 v77, v77, v36, v19
		v_add3_u32 v77, v77, v21, v23
		s_add_i32 s63, s22, 0x19c00
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v77, s[44:47], 0 offen lds
		s_mul_i32 s64, 0x88, s15
		v_add3_u32 v78, s64, v31, v32
		v_add3_u32 v78, v78, v34, v35
		v_add3_u32 v78, v78, v36, v19
		v_add3_u32 v78, v78, v21, v23
		s_add_i32 s65, s22, 0x1ac80
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v78, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v79, s15, v31, v32
		v_add3_u32 v79, v79, v34, v35
		v_add3_u32 v79, v79, v36, v19
		v_add3_u32 v79, v79, v21, v23
		s_add_i32 s66, s22, 0x1bd00
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v79, s[44:47], 0 offen lds
		s_lshl_b32 s67, s19, 7
		s_add_i32 s68, s67, s51
		v_mul_lo_u32 v80, s19, v18
		v_lshlrev_b32_e32 v80, 2, v80
		v_lshlrev_b32_e32 v69, 6, v69
		v_add3_u32 v81, s68, v80, v69
		v_lshlrev_b32_e32 v70, 5, v70
		v_mul_lo_u32 v82, s19, v20
		v_lshlrev_b32_e32 v82, 4, v82
		v_add3_u32 v81, v81, v70, v82
		v_mul_lo_u32 v83, s19, v22
		v_lshlrev_b32_e32 v83, 3, v83
		v_add3_u32 v81, v81, v83, v10
		s_mul_i32 s68, 0x81, s19
		s_add_i32 s69, s68, s51
		v_add3_u32 v84, s69, v80, v69
		v_add3_u32 v84, v84, v70, v82
		v_add3_u32 v84, v84, v83, v10
		s_mul_i32 s69, 0x82, s19
		s_add_i32 s70, s69, s51
		v_add3_u32 v85, s70, v80, v69
		v_add3_u32 v85, v85, v70, v82
		v_add3_u32 v85, v85, v83, v10
		s_mul_i32 s70, 0x83, s19
		s_add_i32 s71, s70, s51
		v_add3_u32 v86, s71, v80, v69
		v_add3_u32 v86, v86, v70, v82
		v_add3_u32 v86, v86, v83, v10
		buffer_load_ubyte v87, v81, s[56:59], 0 offen
		buffer_load_ubyte v88, v84, s[56:59], 0 offen
		buffer_load_ubyte v89, v85, s[56:59], 0 offen
		buffer_load_ubyte v90, v86, s[56:59], 0 offen
		v_add_u32_e32 v91, 0x80, v2
		v_add_u32_e32 v91, v91, v8
		v_add3_u32 v91, v91, v12, v14
		v_add3_u32 v91, v91, v17, v19
		v_add3_u32 v91, v91, v21, v23
		s_add_i32 s71, s22, 0x83e0
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v91, s[24:27], 0 offen lds
		s_add_i32 s23, s23, 0x80
		v_add3_u32 v92, s23, v2, v8
		v_add3_u32 v92, v92, v12, v14
		v_add3_u32 v92, v92, v17, v19
		v_add3_u32 v92, v92, v21, v23
		s_add_i32 s23, s22, 0x9460
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v92, s[24:27], 0 offen lds
		s_add_i32 s29, s29, 0x80
		v_add3_u32 v93, s29, v2, v8
		v_add3_u32 v93, v93, v12, v14
		v_add3_u32 v93, v93, v17, v19
		v_add3_u32 v93, v93, v21, v23
		s_add_i32 s29, s22, 0xa4e0
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_add_i32 s31, s31, 0x80
		v_add3_u32 v94, s31, v2, v8
		v_add3_u32 v94, v94, v12, v14
		v_add3_u32 v94, v94, v17, v19
		v_add3_u32 v94, v94, v21, v23
		s_add_i32 s31, s22, 0xb560
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 0x80
		v_add3_u32 v95, s33, v2, v8
		v_add3_u32 v95, v95, v12, v14
		v_add3_u32 v95, v95, v17, v19
		v_add3_u32 v95, v95, v21, v23
		s_add_i32 s33, s22, 0xc5e0
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s35, s35, 0x80
		v_add3_u32 v96, s35, v2, v8
		v_add3_u32 v96, v96, v12, v14
		v_add3_u32 v96, v96, v17, v19
		v_add3_u32 v96, v96, v21, v23
		s_add_i32 s35, s22, 0xd660
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s37, s37, 0x80
		v_add3_u32 v97, s37, v2, v8
		v_add3_u32 v97, v97, v12, v14
		v_add3_u32 v97, v97, v17, v19
		v_add3_u32 v97, v97, v21, v23
		s_add_i32 s37, s22, 0xe6e0
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v97, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v8
		v_add3_u32 v2, v2, v12, v14
		v_add3_u32 v2, v2, v17, v19
		v_add3_u32 v2, v2, v21, v23
		s_add_i32 s14, s22, 0xf760
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v8, 0x80, v31
		v_add_u32_e32 v8, v8, v32
		v_add3_u32 v8, v8, v34, v35
		v_add3_u32 v8, v8, v36, v19
		v_add3_u32 v8, v8, v21, v23
		s_add_i32 s24, s22, 0x149a0
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
		s_add_i32 s25, s41, 0x80
		v_add3_u32 v12, s25, v31, v32
		v_add3_u32 v12, v12, v34, v35
		v_add3_u32 v12, v12, v36, v19
		v_add3_u32 v12, v12, v21, v23
		s_add_i32 s25, s22, 0x15a20
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 s26, s43, 0x80
		v_add3_u32 v14, s26, v31, v32
		v_add3_u32 v14, v14, v34, v35
		v_add3_u32 v14, v14, v36, v19
		v_add3_u32 v14, v14, v21, v23
		s_add_i32 s26, s22, 0x16aa0
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 s27, s49, 0x80
		v_add3_u32 v17, s27, v31, v32
		v_add3_u32 v17, v17, v34, v35
		v_add3_u32 v17, v17, v36, v19
		v_add3_u32 v17, v17, v21, v23
		s_add_i32 s27, s22, 0x17b20
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v17, s[44:47], 0 offen lds
		s_add_i32 s41, s1, 8
		s_add_i32 s41, s41, s16
		v_mul_lo_u32 v98, s18, v18
		v_lshlrev_b32_e32 v98, 3, v98
		v_lshlrev_b32_e32 v41, 7, v41
		v_add3_u32 v99, s41, v98, v41
		v_lshlrev_b32_e32 v42, 6, v42
		v_mul_lo_u32 v100, s18, v20
		v_lshlrev_b32_e32 v100, 5, v100
		v_add3_u32 v99, v99, v42, v100
		v_mul_lo_u32 v101, s18, v22
		v_lshlrev_b32_e32 v101, 4, v101
		v_add3_u32 v99, v99, v101, v10
		s_add_i32 s41, s18, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v102, s41, v98, v41
		v_add3_u32 v102, v102, v42, v100
		v_add3_u32 v102, v102, v101, v10
		s_lshl_b32 s41, s18, 1
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v103, s41, v98, v41
		v_add3_u32 v103, v103, v42, v100
		v_add3_u32 v103, v103, v101, v10
		s_mul_i32 s41, 3, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v104, s41, v98, v41
		v_add3_u32 v104, v104, v42, v100
		v_add3_u32 v104, v104, v101, v10
		s_lshl_b32 s41, s18, 2
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v105, s41, v98, v41
		v_add3_u32 v105, v105, v42, v100
		v_add3_u32 v105, v105, v101, v10
		s_mul_i32 s41, 5, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v106, s41, v98, v41
		v_add3_u32 v106, v106, v42, v100
		v_add3_u32 v106, v106, v101, v10
		s_mul_i32 s41, 6, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v107, s41, v98, v41
		v_add3_u32 v107, v107, v42, v100
		v_add3_u32 v107, v107, v101, v10
		s_mul_i32 s18, 7, s18
		s_add_i32 s18, s18, 8
		s_add_i32 s1, s18, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v41, s1, v98, v41
		v_add3_u32 v41, v41, v42, v100
		v_add3_u32 v41, v41, v101, v10
		buffer_load_ubyte v42, v99, s[52:55], 0 offen
		buffer_load_ubyte v98, v102, s[52:55], 0 offen
		buffer_load_ubyte v100, v103, s[52:55], 0 offen
		buffer_load_ubyte v101, v104, s[52:55], 0 offen
		buffer_load_ubyte v108, v105, s[52:55], 0 offen
		buffer_load_ubyte v109, v106, s[52:55], 0 offen
		buffer_load_ubyte v110, v107, s[52:55], 0 offen
		buffer_load_ubyte v111, v41, s[52:55], 0 offen
		s_add_i32 s1, s51, 8
		v_add3_u32 v112, s1, v80, v69
		v_add3_u32 v112, v112, v70, v82
		v_add3_u32 v112, v112, v83, v10
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v113, s1, v80, v69
		v_add3_u32 v113, v113, v70, v82
		v_add3_u32 v113, v113, v83, v10
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v114, s1, v80, v69
		v_add3_u32 v114, v114, v70, v82
		v_add3_u32 v114, v114, v83, v10
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v115, s1, v80, v69
		v_add3_u32 v115, v115, v70, v82
		v_add3_u32 v115, v115, v83, v10
		buffer_load_ubyte v116, v112, s[56:59], 0 offen
		buffer_load_ubyte v117, v113, s[56:59], 0 offen
		buffer_load_ubyte v118, v114, s[56:59], 0 offen
		buffer_load_ubyte v119, v115, s[56:59], 0 offen
		s_add_i32 s1, s60, 0x80
		v_add3_u32 v120, s1, v31, v32
		v_add3_u32 v120, v120, v34, v35
		v_add3_u32 v120, v120, v36, v19
		v_add3_u32 v120, v120, v21, v23
		s_add_i32 s1, s22, 0x1cd60
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v120, s[44:47], 0 offen lds
		s_add_i32 s16, s62, 0x80
		v_add3_u32 v121, s16, v31, v32
		v_add3_u32 v121, v121, v34, v35
		v_add3_u32 v121, v121, v36, v19
		v_add3_u32 v121, v121, v21, v23
		s_add_i32 s16, s22, 0x1dde0
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v121, s[44:47], 0 offen lds
		s_add_i32 s18, s64, 0x80
		v_add3_u32 v122, s18, v31, v32
		v_add3_u32 v122, v122, v34, v35
		v_add3_u32 v122, v122, v36, v19
		v_add3_u32 v122, v122, v21, v23
		s_add_i32 s18, s22, 0x1ee60
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v122, s[44:47], 0 offen lds
		s_add_i32 s15, s15, 0x80
		v_add3_u32 v31, s15, v31, v32
		v_add3_u32 v31, v31, v34, v35
		v_add3_u32 v31, v31, v36, v19
		v_add3_u32 v31, v31, v21, v23
		s_add_i32 s15, s22, 0x1fee0
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_add_i32 s19, s67, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v32, s19, v80, v69
		v_add3_u32 v32, v32, v70, v82
		v_add3_u32 v32, v32, v83, v10
		s_add_i32 s19, s68, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v34, s19, v80, v69
		v_add3_u32 v34, v34, v70, v82
		v_add3_u32 v34, v34, v83, v10
		s_add_i32 s19, s69, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v35, s19, v80, v69
		v_add3_u32 v35, v35, v70, v82
		v_add3_u32 v35, v35, v83, v10
		s_add_i32 s19, s70, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v36, s19, v80, v69
		v_add3_u32 v36, v36, v70, v82
		v_add3_u32 v10, v36, v83, v10
		buffer_load_ubyte v36, v32, s[56:59], 0 offen
		buffer_load_ubyte v69, v34, s[56:59], 0 offen
		buffer_load_ubyte v70, v35, s[56:59], 0 offen
		buffer_load_ubyte v80, v10, s[56:59], 0 offen
		s_add_i32 s19, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v82, 7, v1
		v_and_b32_e32 v83, 63, v0
		v_lshrrev_b32_e32 v123, 4, v83
		v_lshlrev_b32_e32 v123, 4, v123
		v_and_b32_e32 v83, 15, v83
		v_mov_b32_e32 v124, 0x420
		v_mul_lo_u32 v124, v124, v83
		v_add3_u32 v82, v82, v123, v124
		ds_read_b128 v[128:131], v82
		ds_read_b128 v[132:135], v82 offset:64
		ds_read_b128 v[136:139], v82 offset:256
		ds_read_b128 v[140:143], v82 offset:320
		ds_read_b128 v[144:147], v82 offset:512
		ds_read_b128 v[148:151], v82 offset:576
		ds_read_b128 v[152:155], v82 offset:768
		ds_read_b128 v[156:159], v82 offset:832
		ds_read_b128 v[160:163], v82 offset:16896
		ds_read_b128 v[164:167], v82 offset:16960
		ds_read_b128 v[168:171], v82 offset:17152
		ds_read_b128 v[172:175], v82 offset:17216
		ds_read_b128 v[176:179], v82 offset:17408
		ds_read_b128 v[180:183], v82 offset:17472
		ds_read_b128 v[184:187], v82 offset:17664
		ds_read_b128 v[188:191], v82 offset:17728
		v_add_u32_e32 v83, 0x10000, v123
		v_lshlrev_b32_e32 v123, 7, v3
		v_add3_u32 v83, v83, v123, v124
		ds_read_b128 v[124:127], v83 offset:1984
		ds_read_b128 v[192:195], v83 offset:2048
		ds_read_b128 v[196:199], v83 offset:2240
		ds_read_b128 v[200:203], v83 offset:2304
		ds_read_b128 v[204:207], v83 offset:2496
		ds_read_b128 v[208:211], v83 offset:2560
		ds_read_b128 v[212:215], v83 offset:2752
		ds_read_b128 v[216:219], v83 offset:2816
		v_add_u32_e32 v15, 0x20000, v15
		v_lshlrev_b32_e32 v123, 8, v18
		v_add_u32_e32 v220, v15, v123
		v_lshlrev_b32_e32 v221, 10, v20
		v_lshlrev_b32_e32 v222, 9, v22
		v_add3_u32 v220, v220, v221, v222
		s_waitcnt vmcnt(51)
		ds_write_b8 v220, v49 offset:3904
		v_add_u32_e32 v49, 0x20000, v123
		v_add3_u32 v49, v49, v221, v222
		v_add_u32_e32 v123, v49, v48
		s_waitcnt vmcnt(50)
		ds_write_b8 v123, v61 offset:3904
		v_add_u32_e32 v61, v49, v51
		s_waitcnt vmcnt(49)
		ds_write_b8 v61, v62 offset:3904
		v_add_u32_e32 v62, v49, v53
		s_waitcnt vmcnt(48)
		ds_write_b8 v62, v63 offset:3904
		v_add_u32_e32 v55, v49, v55
		s_waitcnt vmcnt(47)
		ds_write_b8 v55, v64 offset:3904
		v_add_u32_e32 v57, v49, v57
		s_waitcnt vmcnt(46)
		ds_write_b8 v57, v65 offset:3904
		v_add_u32_e32 v59, v49, v59
		s_waitcnt vmcnt(45)
		ds_write_b8 v59, v66 offset:3904
		v_add_u32_e32 v46, v49, v46
		s_waitcnt vmcnt(44)
		ds_write_b8 v46, v67 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v49, 7, v18
		v_add_u32_e32 v15, v15, v49
		v_lshlrev_b32_e32 v63, 9, v20
		v_lshlrev_b32_e32 v64, 8, v22
		v_add3_u32 v15, v15, v63, v64
		s_waitcnt vmcnt(43)
		ds_write_b8 v15, v44 offset:5952
		v_add_u32_e32 v44, 0x20000, v49
		v_add3_u32 v44, v44, v63, v64
		v_add_u32_e32 v48, v44, v48
		s_waitcnt vmcnt(42)
		ds_write_b8 v48, v73 offset:5952
		v_add_u32_e32 v49, v44, v51
		s_waitcnt vmcnt(41)
		ds_write_b8 v49, v74 offset:5952
		v_add_u32_e32 v44, v44, v53
		s_waitcnt vmcnt(40)
		ds_write_b8 v44, v75 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v45, 0x20000, v45
		v_lshlrev_b32_e32 v51, 3, v18
		v_add_u32_e32 v45, v45, v51
		v_lshl_add_u32 v45, v11, 9, v45
		v_lshlrev_b32_e32 v53, 8, v13
		v_lshlrev_b32_e32 v63, 6, v16
		v_add3_u32 v45, v45, v53, v63
		v_lshlrev_b32_e32 v53, 5, v20
		v_lshlrev_b32_e32 v22, 10, v22
		v_accvgpr_write_b32 a1, v22
		v_accvgpr_read_b32 v22, a1
		v_add3_u32 v22, v45, v53, v22
		ds_read_b64_tr_b8 v[64:65], v22 offset:3904
		ds_read_b64_tr_b8 v[66:67], v22 offset:4032
		v_add_u32_e32 v45, 0x20000, v51
		v_lshl_add_u32 v45, v3, 4, v45
		v_lshl_add_u32 v45, v11, 8, v45
		v_lshlrev_b32_e32 v51, 7, v13
		v_add3_u32 v45, v45, v51, v63
		v_add3_u32 v45, v45, v53, v222
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[74:75], v45 offset:5952
		s_mov_b32 s20, 16
		v_lshlrev_b32_e32 v51, 2, v0
		v_add_u32_e32 v51, 0x20000, v51
		v_lshlrev_b32_e32 v53, 3, v0
		v_add_u32_e32 v53, 0x20000, v53
		s_mov_b32 s41, s20
		v_mov_b32_e32 v4, v4
		v_mov_b32_e32 v5, v5
		v_mov_b32_e32 v6, v6
		v_mov_b32_e32 v7, v7
		v_accvgpr_write_b32 a4, v4
		v_accvgpr_write_b32 a5, v5
		v_accvgpr_write_b32 a6, v6
		v_accvgpr_write_b32 a7, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a8, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a9, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a10, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a11, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a12, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a13, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a14, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a15, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a16, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a17, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a18, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a19, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a20, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a21, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a22, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a23, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a24, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a25, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a26, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a27, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a28, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a29, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a30, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a31, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a32, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a33, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a34, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a35, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a36, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a37, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a38, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a39, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a40, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a41, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a42, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a43, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a44, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a45, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a46, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a47, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a48, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a49, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a50, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a51, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a52, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a53, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a54, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a55, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a56, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a57, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a58, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a59, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a60, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a61, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a62, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a63, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a64, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a65, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a66, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a67, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a68, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a69, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a70, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a71, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a72, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a73, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a74, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a75, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a76, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a77, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a78, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a79, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a80, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a81, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a82, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a83, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a84, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a85, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a86, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a87, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a88, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a89, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a90, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a91, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a92, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a93, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a94, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a95, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a96, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a97, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a98, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a99, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a100, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a101, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a102, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a103, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a104, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a105, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a106, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a107, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a108, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a109, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a110, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a111, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a112, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a113, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a114, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a115, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a116, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a117, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a118, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a119, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a120, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a121, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a122, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a123, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a124, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a125, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a126, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a127, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a128, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a129, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a130, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a131, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a132, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a133, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a134, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a135, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a136, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a137, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a138, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a139, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a140, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a141, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a142, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a143, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a144, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a145, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a146, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a147, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a148, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a149, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a150, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a151, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a152, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a153, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a154, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a155, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a156, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a157, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a158, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a159, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a160, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a161, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a162, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a163, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a164, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a165, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a166, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a167, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a168, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a169, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a170, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a171, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a172, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a173, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a174, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a175, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a176, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a177, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a178, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a179, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a180, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a181, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a182, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a183, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a184, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a185, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a186, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a187, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a188, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a189, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a190, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a191, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a192, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a193, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a194, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a195, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a196, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a197, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a198, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a199, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a200, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a201, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a202, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a203, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a204, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a205, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a206, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a207, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a208, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a209, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a210, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a211, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a212, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a213, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a214, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a215, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a216, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a217, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a218, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a219, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a220, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a221, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a222, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a223, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a224, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a225, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a226, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a227, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a228, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a229, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a230, v63
		v_mov_b32_e32 v63, 0
		v_accvgpr_write_b32 a231, v63
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[124:127], v[128:131], v[4:7], v74, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[132:135], v[4:7], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[128:131], a[4:7], v74, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[132:135], a[4:7], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[204:207], v[128:131], v[224:227], v75, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[208:211], v[132:135], v[224:227], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[212:215], v[128:131], v[228:231], v75, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[216:219], v[132:135], v[228:231], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[124:127], v[136:139], v[232:235], v74, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[192:195], v[140:143], v[232:235], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[196:199], v[136:139], v[236:239], v74, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[200:203], v[140:143], v[236:239], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[136:139], v[240:243], v75, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[140:143], v[240:243], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[136:139], v[244:247], v75, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[140:143], v[244:247], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[124:127], v[144:147], a[8:11], v74, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[192:195], v[148:151], a[8:11], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[196:199], v[144:147], a[12:15], v74, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[148:151], a[12:15], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[204:207], v[144:147], a[16:19], v75, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[208:211], v[148:151], a[16:19], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[212:215], v[144:147], a[20:23], v75, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[216:219], v[148:151], a[20:23], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[124:127], v[152:155], a[24:27], v74, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[192:195], v[156:159], a[24:27], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[196:199], v[152:155], a[28:31], v74, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[156:159], a[28:31], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[152:155], a[32:35], v75, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[156:159], a[32:35], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[212:215], v[152:155], a[36:39], v75, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[216:219], v[156:159], a[36:39], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[124:127], v[160:163], a[40:43], v74, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[192:195], v[164:167], a[40:43], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[196:199], v[160:163], a[44:47], v74, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[200:203], v[164:167], a[44:47], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[160:163], a[48:51], v75, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[164:167], a[48:51], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[160:163], a[52:55], v75, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[216:219], v[164:167], a[52:55], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[124:127], v[168:171], a[56:59], v74, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[192:195], v[172:175], a[56:59], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[196:199], v[168:171], a[60:63], v74, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[200:203], v[172:175], a[60:63], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[204:207], v[168:171], a[64:67], v75, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[208:211], v[172:175], a[64:67], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[168:171], a[68:71], v75, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[216:219], v[172:175], a[68:71], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[124:127], v[176:179], a[72:75], v74, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[192:195], v[180:183], a[72:75], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[196:199], v[176:179], a[76:79], v74, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[200:203], v[180:183], a[76:79], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[204:207], v[176:179], a[80:83], v75, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[208:211], v[180:183], a[80:83], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[212:215], v[176:179], a[84:87], v75, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[180:183], a[84:87], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[124:127], v[184:187], a[88:91], v74, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[192:195], v[188:191], a[88:91], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[196:199], v[184:187], a[92:95], v74, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[200:203], v[188:191], a[92:95], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[204:207], v[184:187], a[96:99], v75, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[208:211], v[188:191], a[96:99], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[184:187], a[100:103], v75, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[188:191], a[100:103], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[124:127], v83 offset:35712
		ds_read_b128 v[192:195], v83 offset:35776
		ds_read_b128 v[196:199], v83 offset:35968
		ds_read_b128 v[200:203], v83 offset:36032
		ds_read_b128 v[204:207], v83 offset:36224
		ds_read_b128 v[208:211], v83 offset:36288
		ds_read_b128 v[212:215], v83 offset:36480
		ds_read_b128 v[216:219], v83 offset:36544
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v63, 0xff, v87
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v73, 0xff, v88
		v_lshlrev_b32_e32 v73, 8, v73
		v_or_b32_e32 v63, v63, v73
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v73, 0xff, v89
		v_lshlrev_b32_e32 v73, 16, v73
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v74, 0xff, v90
		v_lshlrev_b32_e32 v74, 24, v74
		v_or3_b32 v63, v63, v73, v74
		ds_write_b32 v51, v63 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v45 offset:5952
		s_add_u32 s44, s2, s19
		s_addc_u32 s45, s3, 0
		s_mov_b32 m0, s22
		s_mov_b32 s52, s44
		s_mov_b32 s53, s45
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		buffer_load_dwordx4 v9, s[52:55], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v24, s[52:55], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v25, s[52:55], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v26, s[52:55], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v27, s[52:55], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v28, s[52:55], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v29, s[52:55], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v30, s[52:55], 0 offen lds
		s_add_u32 s44, s4, s13
		s_addc_u32 s45, s5, 0
		s_mov_b32 m0, s40
		s_mov_b32 s56, s44
		s_mov_b32 s57, s45
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		buffer_load_dwordx4 v33, s[56:59], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v37, s[56:59], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v38, s[56:59], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v39, s[56:59], 0 offen lds
		s_add_u32 s44, s8, s20
		s_addc_u32 s45, s9, 0
		s_mov_b32 s72, s44
		s_mov_b32 s73, s45
		s_mov_b32 s74, 0x7fffffff
		s_mov_b32 s75, 0x31016000
		buffer_load_ubyte v63, v40, s[72:75], 0 offen
		buffer_load_ubyte v73, v50, s[72:75], 0 offen
		buffer_load_ubyte v221, v52, s[72:75], 0 offen
		buffer_load_ubyte v222, v54, s[72:75], 0 offen
		buffer_load_ubyte v223, v56, s[72:75], 0 offen
		buffer_load_ubyte v248, v58, s[72:75], 0 offen
		buffer_load_ubyte v249, v60, s[72:75], 0 offen
		buffer_load_ubyte v250, v47, s[72:75], 0 offen
		s_add_u32 s44, s10, s41
		s_addc_u32 s45, s11, 0
		s_mov_b32 s76, s44
		s_mov_b32 s77, s45
		s_mov_b32 s78, 0x7fffffff
		s_mov_b32 s79, 0x31016000
		buffer_load_ubyte v251, v68, s[76:79], 0 offen
		buffer_load_ubyte v252, v71, s[76:79], 0 offen
		buffer_load_ubyte v253, v72, s[76:79], 0 offen
		buffer_load_ubyte v254, v43, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[124:127], v[128:131], a[104:107], v74, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[192:195], v[132:135], a[104:107], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[196:199], v[128:131], a[108:111], v74, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[200:203], v[132:135], a[108:111], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[204:207], v[128:131], a[112:115], v75, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[208:211], v[132:135], a[112:115], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[128:131], a[116:119], v75, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[216:219], v[132:135], a[116:119], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[124:127], v[136:139], a[120:123], v74, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[192:195], v[140:143], a[120:123], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[196:199], v[136:139], a[124:127], v74, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[200:203], v[140:143], a[124:127], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[204:207], v[136:139], a[128:131], v75, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[208:211], v[140:143], a[128:131], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[212:215], v[136:139], a[132:135], v75, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[216:219], v[140:143], a[132:135], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[124:127], v[144:147], a[136:139], v74, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[192:195], v[148:151], a[136:139], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[196:199], v[144:147], a[140:143], v74, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[200:203], v[148:151], a[140:143], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[204:207], v[144:147], a[144:147], v75, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[208:211], v[148:151], a[144:147], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[212:215], v[144:147], a[148:151], v75, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[216:219], v[148:151], a[148:151], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[124:127], v[152:155], a[152:155], v74, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[192:195], v[156:159], a[152:155], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[196:199], v[152:155], a[156:159], v74, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[200:203], v[156:159], a[156:159], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[204:207], v[152:155], a[160:163], v75, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[208:211], v[156:159], a[160:163], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[212:215], v[152:155], a[164:167], v75, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[216:219], v[156:159], a[164:167], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[124:127], v[160:163], a[168:171], v74, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[192:195], v[164:167], a[168:171], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[196:199], v[160:163], a[172:175], v74, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[200:203], v[164:167], a[172:175], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[204:207], v[160:163], a[176:179], v75, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[208:211], v[164:167], a[176:179], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[212:215], v[160:163], a[180:183], v75, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[216:219], v[164:167], a[180:183], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[124:127], v[168:171], a[184:187], v74, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[192:195], v[172:175], a[184:187], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[196:199], v[168:171], a[188:191], v74, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[200:203], v[172:175], a[188:191], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[204:207], v[168:171], a[192:195], v75, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[208:211], v[172:175], a[192:195], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[212:215], v[168:171], a[196:199], v75, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[216:219], v[172:175], a[196:199], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[176:179], a[200:203], v74, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[192:195], v[180:183], a[200:203], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[196:199], v[176:179], a[204:207], v74, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[200:203], v[180:183], a[204:207], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[204:207], v[176:179], a[208:211], v75, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[208:211], v[180:183], a[208:211], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[212:215], v[176:179], a[212:215], v75, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[216:219], v[180:183], a[212:215], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[184:187], a[216:219], v74, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[192:195], v[188:191], a[216:219], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[196:199], v[184:187], a[220:223], v74, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[200:203], v[188:191], a[220:223], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[204:207], v[184:187], a[224:227], v75, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[208:211], v[188:191], a[224:227], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[212:215], v[184:187], a[228:231], v75, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[216:219], v[188:191], a[228:231], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[64:67], v82 offset:33760
		ds_read_b128 v[124:127], v82 offset:33824
		ds_read_b128 v[128:131], v82 offset:34016
		ds_read_b128 v[132:135], v82 offset:34080
		ds_read_b128 v[136:139], v82 offset:34272
		ds_read_b128 v[140:143], v82 offset:34336
		ds_read_b128 v[144:147], v82 offset:34528
		ds_read_b128 v[148:151], v82 offset:34592
		ds_read_b128 v[152:155], v82 offset:50656
		ds_read_b128 v[156:159], v82 offset:50720
		ds_read_b128 v[160:163], v82 offset:50912
		ds_read_b128 v[164:167], v82 offset:50976
		ds_read_b128 v[168:171], v82 offset:51168
		ds_read_b128 v[172:175], v82 offset:51232
		ds_read_b128 v[176:179], v82 offset:51424
		ds_read_b128 v[180:183], v82 offset:51488
		ds_read_b128 v[184:187], v83 offset:18848
		ds_read_b128 v[188:191], v83 offset:18912
		ds_read_b128 v[192:195], v83 offset:19104
		ds_read_b128 v[196:199], v83 offset:19168
		ds_read_b128 v[200:203], v83 offset:19360
		ds_read_b128 v[204:207], v83 offset:19424
		ds_read_b128 v[208:211], v83 offset:19616
		ds_read_b128 v[212:215], v83 offset:19680
		s_waitcnt vmcnt(43)
		v_and_b32_e32 v42, 0xff, v42
		s_waitcnt vmcnt(42)
		v_and_b32_e32 v74, 0xff, v98
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v42, v42, v74
		s_waitcnt vmcnt(41)
		v_and_b32_e32 v74, 0xff, v100
		v_lshlrev_b32_e32 v74, 16, v74
		s_waitcnt vmcnt(40)
		v_and_b32_e32 v75, 0xff, v101
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v88, v42, v74, v75
		s_waitcnt vmcnt(39)
		v_and_b32_e32 v42, 0xff, v108
		s_waitcnt vmcnt(38)
		v_and_b32_e32 v74, 0xff, v109
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v42, v42, v74
		s_waitcnt vmcnt(37)
		v_and_b32_e32 v74, 0xff, v110
		v_lshlrev_b32_e32 v74, 16, v74
		s_waitcnt vmcnt(36)
		v_and_b32_e32 v75, 0xff, v111
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v89, v42, v74, v75
		ds_write_b64 v53, v[88:89] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v42, 0xff, v116
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v74, 0xff, v117
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v42, v42, v74
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v74, 0xff, v118
		v_lshlrev_b32_e32 v74, 16, v74
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v75, 0xff, v119
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v42, v42, v74, v75
		ds_write_b32 v51, v42 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v22 offset:3904
		ds_read_b64_tr_b8 v[216:217], v22 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[100:101], v45 offset:5952
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v76, s[56:59], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v77, s[56:59], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v78, s[56:59], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v79, s[56:59], 0 offen lds
		buffer_load_ubyte v87, v81, s[76:79], 0 offen
		buffer_load_ubyte v88, v84, s[76:79], 0 offen
		buffer_load_ubyte v89, v85, s[76:79], 0 offen
		buffer_load_ubyte v90, v86, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[184:187], v[64:67], v[4:7], v100, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[188:191], v[124:127], v[4:7], v100, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[64:67], a[4:7], v100, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[124:127], a[4:7], v100, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[200:203], v[64:67], v[224:227], v101, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[204:207], v[124:127], v[224:227], v101, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[208:211], v[64:67], v[228:231], v101, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[212:215], v[124:127], v[228:231], v101, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[184:187], v[128:131], v[232:235], v100, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[188:191], v[132:135], v[232:235], v100, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[192:195], v[128:131], v[236:239], v100, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[196:199], v[132:135], v[236:239], v100, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[200:203], v[128:131], v[240:243], v101, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[132:135], v[240:243], v101, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[208:211], v[128:131], v[244:247], v101, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[132:135], v[244:247], v101, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[184:187], v[136:139], a[8:11], v100, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[188:191], v[140:143], a[8:11], v100, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[192:195], v[136:139], a[12:15], v100, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[196:199], v[140:143], a[12:15], v100, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[200:203], v[136:139], a[16:19], v101, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[204:207], v[140:143], a[16:19], v101, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[136:139], a[20:23], v101, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[212:215], v[140:143], a[20:23], v101, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[184:187], v[144:147], a[24:27], v100, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[188:191], v[148:151], a[24:27], v100, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[192:195], v[144:147], a[28:31], v100, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[196:199], v[148:151], a[28:31], v100, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[200:203], v[144:147], a[32:35], v101, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[148:151], a[32:35], v101, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[144:147], a[36:39], v101, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[212:215], v[148:151], a[36:39], v101, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[184:187], v[152:155], a[40:43], v100, v216 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[188:191], v[156:159], a[40:43], v100, v216 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[192:195], v[152:155], a[44:47], v100, v216 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[196:199], v[156:159], a[44:47], v100, v216 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[200:203], v[152:155], a[48:51], v101, v216 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[156:159], a[48:51], v101, v216 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[208:211], v[152:155], a[52:55], v101, v216 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[156:159], a[52:55], v101, v216 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[184:187], v[160:163], a[56:59], v100, v216 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[188:191], v[164:167], a[56:59], v100, v216 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[192:195], v[160:163], a[60:63], v100, v216 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[196:199], v[164:167], a[60:63], v100, v216 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[200:203], v[160:163], a[64:67], v101, v216 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[204:207], v[164:167], a[64:67], v101, v216 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[208:211], v[160:163], a[68:71], v101, v216 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[164:167], a[68:71], v101, v216 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[184:187], v[168:171], a[72:75], v100, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[188:191], v[172:175], a[72:75], v100, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[192:195], v[168:171], a[76:79], v100, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[196:199], v[172:175], a[76:79], v100, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[200:203], v[168:171], a[80:83], v101, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[204:207], v[172:175], a[80:83], v101, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[208:211], v[168:171], a[84:87], v101, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[212:215], v[172:175], a[84:87], v101, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[184:187], v[176:179], a[88:91], v100, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[188:191], v[180:183], a[88:91], v100, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[192:195], v[176:179], a[92:95], v100, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[196:199], v[180:183], a[92:95], v100, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[200:203], v[176:179], a[96:99], v101, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[204:207], v[180:183], a[96:99], v101, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[208:211], v[176:179], a[100:103], v101, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[180:183], a[100:103], v101, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[184:187], v83 offset:52576
		ds_read_b128 v[188:191], v83 offset:52640
		ds_read_b128 v[192:195], v83 offset:52832
		ds_read_b128 v[196:199], v83 offset:52896
		ds_read_b128 v[200:203], v83 offset:53088
		ds_read_b128 v[204:207], v83 offset:53152
		ds_read_b128 v[208:211], v83 offset:53344
		ds_read_b128 v[212:215], v83 offset:53408
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v36, 0xff, v36
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v42, 0xff, v69
		v_lshlrev_b32_e32 v42, 8, v42
		v_or_b32_e32 v36, v36, v42
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v42, 0xff, v70
		v_lshlrev_b32_e32 v42, 16, v42
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v69, 0xff, v80
		v_lshlrev_b32_e32 v69, 24, v69
		v_or3_b32 v36, v36, v42, v69
		ds_write_b32 v51, v36 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[218:219], v45 offset:5952
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v91, s[52:55], 0 offen lds
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v92, s[52:55], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v93, s[52:55], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v94, s[52:55], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v95, s[52:55], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v96, s[52:55], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v97, s[52:55], 0 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v2, s[52:55], 0 offen lds
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v8, s[56:59], 0 offen lds
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v12, s[56:59], 0 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v14, s[56:59], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v17, s[56:59], 0 offen lds
		buffer_load_ubyte v42, v99, s[72:75], 0 offen
		buffer_load_ubyte v98, v102, s[72:75], 0 offen
		buffer_load_ubyte v100, v103, s[72:75], 0 offen
		buffer_load_ubyte v101, v104, s[72:75], 0 offen
		buffer_load_ubyte v108, v105, s[72:75], 0 offen
		buffer_load_ubyte v109, v106, s[72:75], 0 offen
		buffer_load_ubyte v110, v107, s[72:75], 0 offen
		buffer_load_ubyte v111, v41, s[72:75], 0 offen
		buffer_load_ubyte v116, v112, s[76:79], 0 offen
		buffer_load_ubyte v117, v113, s[76:79], 0 offen
		buffer_load_ubyte v118, v114, s[76:79], 0 offen
		buffer_load_ubyte v119, v115, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[184:187], v[64:67], a[104:107], v218, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[188:191], v[124:127], a[104:107], v218, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[192:195], v[64:67], a[108:111], v218, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[196:199], v[124:127], a[108:111], v218, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[200:203], v[64:67], a[112:115], v219, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[204:207], v[124:127], a[112:115], v219, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[208:211], v[64:67], a[116:119], v219, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[124:127], a[116:119], v219, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[184:187], v[128:131], a[120:123], v218, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[188:191], v[132:135], a[120:123], v218, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[192:195], v[128:131], a[124:127], v218, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[196:199], v[132:135], a[124:127], v218, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[200:203], v[128:131], a[128:131], v219, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[204:207], v[132:135], a[128:131], v219, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[208:211], v[128:131], a[132:135], v219, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[212:215], v[132:135], a[132:135], v219, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[184:187], v[136:139], a[136:139], v218, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[188:191], v[140:143], a[136:139], v218, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[192:195], v[136:139], a[140:143], v218, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[196:199], v[140:143], a[140:143], v218, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[200:203], v[136:139], a[144:147], v219, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[204:207], v[140:143], a[144:147], v219, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[208:211], v[136:139], a[148:151], v219, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[212:215], v[140:143], a[148:151], v219, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[184:187], v[144:147], a[152:155], v218, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[188:191], v[148:151], a[152:155], v218, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[192:195], v[144:147], a[156:159], v218, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[196:199], v[148:151], a[156:159], v218, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[200:203], v[144:147], a[160:163], v219, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[204:207], v[148:151], a[160:163], v219, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[208:211], v[144:147], a[164:167], v219, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[212:215], v[148:151], a[164:167], v219, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[184:187], v[152:155], a[168:171], v218, v216 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[188:191], v[156:159], a[168:171], v218, v216 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[192:195], v[152:155], a[172:175], v218, v216 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[196:199], v[156:159], a[172:175], v218, v216 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[200:203], v[152:155], a[176:179], v219, v216 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[204:207], v[156:159], a[176:179], v219, v216 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[208:211], v[152:155], a[180:183], v219, v216 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[212:215], v[156:159], a[180:183], v219, v216 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[184:187], v[160:163], a[184:187], v218, v216 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[188:191], v[164:167], a[184:187], v218, v216 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[192:195], v[160:163], a[188:191], v218, v216 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[196:199], v[164:167], a[188:191], v218, v216 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[200:203], v[160:163], a[192:195], v219, v216 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[204:207], v[164:167], a[192:195], v219, v216 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[208:211], v[160:163], a[196:199], v219, v216 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[212:215], v[164:167], a[196:199], v219, v216 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[184:187], v[168:171], a[200:203], v218, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[188:191], v[172:175], a[200:203], v218, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[192:195], v[168:171], a[204:207], v218, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[196:199], v[172:175], a[204:207], v218, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[200:203], v[168:171], a[208:211], v219, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[204:207], v[172:175], a[208:211], v219, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[208:211], v[168:171], a[212:215], v219, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[212:215], v[172:175], a[212:215], v219, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[184:187], v[176:179], a[216:219], v218, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[188:191], v[180:183], a[216:219], v218, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[192:195], v[176:179], a[220:223], v218, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[196:199], v[180:183], a[220:223], v218, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[200:203], v[176:179], a[224:227], v219, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[204:207], v[180:183], a[224:227], v219, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[208:211], v[176:179], a[228:231], v219, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[212:215], v[180:183], a[228:231], v219, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[128:131], v82
		ds_read_b128 v[132:135], v82 offset:64
		ds_read_b128 v[136:139], v82 offset:256
		ds_read_b128 v[140:143], v82 offset:320
		ds_read_b128 v[144:147], v82 offset:512
		ds_read_b128 v[148:151], v82 offset:576
		ds_read_b128 v[152:155], v82 offset:768
		ds_read_b128 v[156:159], v82 offset:832
		ds_read_b128 v[160:163], v82 offset:16896
		ds_read_b128 v[164:167], v82 offset:16960
		ds_read_b128 v[168:171], v82 offset:17152
		ds_read_b128 v[172:175], v82 offset:17216
		ds_read_b128 v[176:179], v82 offset:17408
		ds_read_b128 v[180:183], v82 offset:17472
		ds_read_b128 v[184:187], v82 offset:17664
		ds_read_b128 v[188:191], v82 offset:17728
		ds_read_b128 v[124:127], v83 offset:1984
		ds_read_b128 v[192:195], v83 offset:2048
		ds_read_b128 v[196:199], v83 offset:2240
		ds_read_b128 v[200:203], v83 offset:2304
		ds_read_b128 v[204:207], v83 offset:2496
		ds_read_b128 v[208:211], v83 offset:2560
		ds_read_b128 v[212:215], v83 offset:2752
		ds_read_b128 v[216:219], v83 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v220, v63 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v123, v73 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v61, v221 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v62, v222 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v55, v223 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v57, v248 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v59, v249 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v46, v250 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v15, v251 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v48, v252 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v49, v253 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v44, v254 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[64:65], v22 offset:3904
		ds_read_b64_tr_b8 v[66:67], v22 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[74:75], v45 offset:5952
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v120, s[56:59], 0 offen lds
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v121, s[56:59], 0 offen lds
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v122, s[56:59], 0 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v31, s[56:59], 0 offen lds
		buffer_load_ubyte v36, v32, s[76:79], 0 offen
		buffer_load_ubyte v69, v34, s[76:79], 0 offen
		buffer_load_ubyte v70, v35, s[76:79], 0 offen
		buffer_load_ubyte v80, v10, s[76:79], 0 offen
		s_add_i32 s19, s19, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s20, s20, 16
		s_add_i32 s41, s41, 16
		s_add_i32 s21, s21, 2
		s_cmp_lt_i32 s21, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[124:127], v[128:131], v[4:7], v74, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[132:135], v[4:7], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[128:131], a[4:7], v74, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[132:135], a[4:7], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[204:207], v[128:131], v[224:227], v75, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[208:211], v[132:135], v[224:227], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[212:215], v[128:131], v[228:231], v75, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[216:219], v[132:135], v[228:231], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[124:127], v[136:139], v[232:235], v74, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[192:195], v[140:143], v[232:235], v74, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[196:199], v[136:139], v[236:239], v74, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[200:203], v[140:143], v[236:239], v74, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[136:139], v[240:243], v75, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[140:143], v[240:243], v75, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[136:139], v[244:247], v75, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[140:143], v[244:247], v75, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[124:127], v[144:147], a[8:11], v74, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[192:195], v[148:151], a[8:11], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[196:199], v[144:147], a[12:15], v74, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[148:151], a[12:15], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[204:207], v[144:147], a[16:19], v75, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[208:211], v[148:151], a[16:19], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[212:215], v[144:147], a[20:23], v75, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[216:219], v[148:151], a[20:23], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[124:127], v[152:155], a[24:27], v74, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[192:195], v[156:159], a[24:27], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[196:199], v[152:155], a[28:31], v74, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[156:159], a[28:31], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[152:155], a[32:35], v75, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[156:159], a[32:35], v75, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[212:215], v[152:155], a[36:39], v75, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[216:219], v[156:159], a[36:39], v75, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[124:127], v[160:163], a[40:43], v74, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[192:195], v[164:167], a[40:43], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[196:199], v[160:163], a[44:47], v74, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[200:203], v[164:167], a[44:47], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[160:163], a[48:51], v75, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[164:167], a[48:51], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[160:163], a[52:55], v75, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[216:219], v[164:167], a[52:55], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[124:127], v[168:171], a[56:59], v74, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[192:195], v[172:175], a[56:59], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[196:199], v[168:171], a[60:63], v74, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[200:203], v[172:175], a[60:63], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[204:207], v[168:171], a[64:67], v75, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[208:211], v[172:175], a[64:67], v75, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[168:171], a[68:71], v75, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[216:219], v[172:175], a[68:71], v75, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[124:127], v[176:179], a[72:75], v74, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[192:195], v[180:183], a[72:75], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[196:199], v[176:179], a[76:79], v74, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[200:203], v[180:183], a[76:79], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[204:207], v[176:179], a[80:83], v75, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[208:211], v[180:183], a[80:83], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[212:215], v[176:179], a[84:87], v75, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[180:183], a[84:87], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[124:127], v[184:187], a[88:91], v74, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[192:195], v[188:191], a[88:91], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[196:199], v[184:187], a[92:95], v74, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[200:203], v[188:191], a[92:95], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[204:207], v[184:187], a[96:99], v75, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[208:211], v[188:191], a[96:99], v75, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[184:187], a[100:103], v75, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[188:191], a[100:103], v75, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[24:27], v83 offset:35712
		ds_read_b128 v[28:31], v83 offset:35776
		ds_read_b128 v[32:35], v83 offset:35968
		ds_read_b128 v[56:59], v83 offset:36032
		ds_read_b128 v[60:63], v83 offset:36224
		ds_read_b128 v[72:75], v83 offset:36288
		ds_read_b128 v[76:79], v83 offset:36480
		ds_read_b128 v[92:95], v83 offset:36544
		v_and_b32_e32 v2, 0xff, v87
		v_and_b32_e32 v8, 0xff, v88
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v89
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v90
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v2, v2, v8, v9
		ds_write_b32 v51, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v45 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[128:131], a[104:107], v8, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[132:135], a[104:107], v8, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], v[128:131], a[108:111], v8, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[56:59], v[132:135], a[108:111], v8, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[60:63], v[128:131], a[112:115], v9, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[72:75], v[132:135], a[112:115], v9, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[128:131], a[116:119], v9, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[132:135], a[116:119], v9, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[136:139], a[120:123], v8, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[140:143], a[120:123], v8, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[136:139], a[124:127], v8, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[56:59], v[140:143], a[124:127], v8, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[60:63], v[136:139], a[128:131], v9, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[72:75], v[140:143], a[128:131], v9, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[136:139], a[132:135], v9, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[140:143], a[132:135], v9, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[144:147], a[136:139], v8, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[148:151], a[136:139], v8, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[144:147], a[140:143], v8, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[56:59], v[148:151], a[140:143], v8, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[60:63], v[144:147], a[144:147], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[72:75], v[148:151], a[144:147], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[76:79], v[144:147], a[148:151], v9, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[148:151], a[148:151], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[152:155], a[152:155], v8, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[156:159], a[152:155], v8, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[152:155], a[156:159], v8, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[56:59], v[156:159], a[156:159], v8, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[60:63], v[152:155], a[160:163], v9, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[72:75], v[156:159], a[160:163], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[76:79], v[152:155], a[164:167], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[92:95], v[156:159], a[164:167], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[24:27], v[160:163], a[168:171], v8, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[164:167], a[168:171], v8, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[160:163], a[172:175], v8, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[56:59], v[164:167], a[172:175], v8, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[60:63], v[160:163], a[176:179], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[72:75], v[164:167], a[176:179], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[76:79], v[160:163], a[180:183], v9, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[92:95], v[164:167], a[180:183], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[24:27], v[168:171], a[184:187], v8, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[172:175], a[184:187], v8, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[168:171], a[188:191], v8, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[56:59], v[172:175], a[188:191], v8, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[60:63], v[168:171], a[192:195], v9, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[72:75], v[172:175], a[192:195], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[76:79], v[168:171], a[196:199], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[92:95], v[172:175], a[196:199], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[24:27], v[176:179], a[200:203], v8, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[28:31], v[180:183], a[200:203], v8, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[176:179], a[204:207], v8, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[56:59], v[180:183], a[204:207], v8, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[60:63], v[176:179], a[208:211], v9, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[72:75], v[180:183], a[208:211], v9, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[76:79], v[176:179], a[212:215], v9, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[92:95], v[180:183], a[212:215], v9, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[24:27], v[184:187], a[216:219], v8, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[28:31], v[188:191], a[216:219], v8, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[184:187], a[220:223], v8, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[56:59], v[188:191], a[220:223], v8, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[60:63], v[184:187], a[224:227], v9, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[72:75], v[188:191], a[224:227], v9, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[76:79], v[184:187], a[228:231], v9, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[92:95], v[188:191], a[228:231], v9, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v82 offset:33760
		ds_read_b128 v[28:31], v82 offset:33824
		ds_read_b128 v[32:35], v82 offset:34016
		ds_read_b128 v[56:59], v82 offset:34080
		ds_read_b128 v[60:63], v82 offset:34272
		ds_read_b128 v[64:67], v82 offset:34336
		ds_read_b128 v[72:75], v82 offset:34528
		ds_read_b128 v[76:79], v82 offset:34592
		ds_read_b128 v[84:87], v82 offset:50656
		ds_read_b128 v[88:91], v82 offset:50720
		ds_read_b128 v[92:95], v82 offset:50912
		ds_read_b128 v[104:107], v82 offset:50976
		ds_read_b128 v[112:115], v82 offset:51168
		ds_read_b128 v[120:123], v82 offset:51232
		ds_read_b128 v[124:127], v82 offset:51424
		ds_read_b128 v[128:131], v82 offset:51488
		ds_read_b128 v[132:135], v83 offset:18848
		ds_read_b128 v[136:139], v83 offset:18912
		ds_read_b128 v[140:143], v83 offset:19104
		ds_read_b128 v[144:147], v83 offset:19168
		ds_read_b128 v[148:151], v83 offset:19360
		ds_read_b128 v[152:155], v83 offset:19424
		ds_read_b128 v[156:159], v83 offset:19616
		ds_read_b128 v[160:163], v83 offset:19680
		v_and_b32_e32 v2, 0xff, v42
		v_and_b32_e32 v8, 0xff, v98
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v100
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v101
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v14, v2, v8, v9
		v_and_b32_e32 v2, 0xff, v108
		v_and_b32_e32 v8, 0xff, v109
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v110
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v111
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v15, v2, v8, v9
		ds_write_b64 v53, v[14:15] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v2, 0xff, v116
		v_and_b32_e32 v8, 0xff, v117
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v118
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v119
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v2, v2, v8, v9
		ds_write_b32 v51, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v22 offset:3904
		ds_read_b64_tr_b8 v[14:15], v22 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[38:39], v45 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[132:135], v[24:27], v[4:7], v38, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[136:139], v[28:31], v[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[140:143], v[24:27], a[4:7], v38, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[144:147], v[28:31], a[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[148:151], v[24:27], v[224:227], v39, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[152:155], v[28:31], v[224:227], v39, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[156:159], v[24:27], v[228:231], v39, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[160:163], v[28:31], v[228:231], v39, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[132:135], v[32:35], v[232:235], v38, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[136:139], v[56:59], v[232:235], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[140:143], v[32:35], v[236:239], v38, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[144:147], v[56:59], v[236:239], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[148:151], v[32:35], v[240:243], v39, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[152:155], v[56:59], v[240:243], v39, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[156:159], v[32:35], v[244:247], v39, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[160:163], v[56:59], v[244:247], v39, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[132:135], v[60:63], a[8:11], v38, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[136:139], v[64:67], a[8:11], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[140:143], v[60:63], a[12:15], v38, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[144:147], v[64:67], a[12:15], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[148:151], v[60:63], a[16:19], v39, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[152:155], v[64:67], a[16:19], v39, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[156:159], v[60:63], a[20:23], v39, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[160:163], v[64:67], a[20:23], v39, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[132:135], v[72:75], a[24:27], v38, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[136:139], v[76:79], a[24:27], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[140:143], v[72:75], a[28:31], v38, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[144:147], v[76:79], a[28:31], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[148:151], v[72:75], a[32:35], v39, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[152:155], v[76:79], a[32:35], v39, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[156:159], v[72:75], a[36:39], v39, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[160:163], v[76:79], a[36:39], v39, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[132:135], v[84:87], a[40:43], v38, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[136:139], v[88:91], a[40:43], v38, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[140:143], v[84:87], a[44:47], v38, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[144:147], v[88:91], a[44:47], v38, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[148:151], v[84:87], a[48:51], v39, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[152:155], v[88:91], a[48:51], v39, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[156:159], v[84:87], a[52:55], v39, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[160:163], v[88:91], a[52:55], v39, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[132:135], v[92:95], a[56:59], v38, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[136:139], v[104:107], a[56:59], v38, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[140:143], v[92:95], a[60:63], v38, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[144:147], v[104:107], a[60:63], v38, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[148:151], v[92:95], a[64:67], v39, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[152:155], v[104:107], a[64:67], v39, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[156:159], v[92:95], a[68:71], v39, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[160:163], v[104:107], a[68:71], v39, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[132:135], v[112:115], a[72:75], v38, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[136:139], v[120:123], a[72:75], v38, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[140:143], v[112:115], a[76:79], v38, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[144:147], v[120:123], a[76:79], v38, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[148:151], v[112:115], a[80:83], v39, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[152:155], v[120:123], a[80:83], v39, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[156:159], v[112:115], a[84:87], v39, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[160:163], v[120:123], a[84:87], v39, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[132:135], v[124:127], a[88:91], v38, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[136:139], v[128:131], a[88:91], v38, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[140:143], v[124:127], a[92:95], v38, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[144:147], v[128:131], a[92:95], v38, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[148:151], v[124:127], a[96:99], v39, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[152:155], v[128:131], a[96:99], v39, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[156:159], v[124:127], a[100:103], v39, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[160:163], v[128:131], a[100:103], v39, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v83 offset:52576
		ds_read_b128 v[52:55], v83 offset:52640
		ds_read_b128 v[96:99], v83 offset:52832
		ds_read_b128 v[100:103], v83 offset:52896
		ds_read_b128 v[108:111], v83 offset:53088
		ds_read_b128 v[116:119], v83 offset:53152
		ds_read_b128 v[132:135], v83 offset:53344
		ds_read_b128 v[136:139], v83 offset:53408
		s_waitcnt vmcnt(3)
		v_and_b32_e32 v2, 0xff, v36
		s_waitcnt vmcnt(2)
		v_and_b32_e32 v10, 0xff, v69
		v_lshlrev_b32_e32 v10, 8, v10
		v_or_b32_e32 v2, v2, v10
		s_waitcnt vmcnt(1)
		v_and_b32_e32 v10, 0xff, v70
		v_lshlrev_b32_e32 v10, 16, v10
		s_waitcnt vmcnt(0)
		v_and_b32_e32 v12, 0xff, v80
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v2, v2, v10, v12
		ds_write_b32 v51, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[36:37], v45 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v44, v4, v5
		v_cvt_pk_bf16_f32 v45, v6, v7
		v_accvgpr_read_b32 v2, a4
		v_accvgpr_read_b32 v4, a5
		v_cvt_pk_bf16_f32 v48, v2, v4
		v_accvgpr_read_b32 v2, a6
		v_accvgpr_read_b32 v4, a7
		v_cvt_pk_bf16_f32 v49, v2, v4
		v_cvt_pk_bf16_f32 v4, v224, v225
		v_cvt_pk_bf16_f32 v5, v226, v227
		v_cvt_pk_bf16_f32 v68, v228, v229
		v_cvt_pk_bf16_f32 v69, v230, v231
		v_cvt_pk_bf16_f32 v46, v232, v233
		v_cvt_pk_bf16_f32 v47, v234, v235
		v_cvt_pk_bf16_f32 v50, v236, v237
		v_cvt_pk_bf16_f32 v51, v238, v239
		v_cvt_pk_bf16_f32 v6, v240, v241
		v_cvt_pk_bf16_f32 v7, v242, v243
		v_cvt_pk_bf16_f32 v70, v244, v245
		v_cvt_pk_bf16_f32 v71, v246, v247
		v_accvgpr_read_b32 v2, a8
		v_accvgpr_read_b32 v10, a9
		v_cvt_pk_bf16_f32 v80, v2, v10
		v_accvgpr_read_b32 v2, a10
		v_accvgpr_read_b32 v10, a11
		v_cvt_pk_bf16_f32 v81, v2, v10
		v_accvgpr_read_b32 v2, a12
		v_accvgpr_read_b32 v10, a13
		v_cvt_pk_bf16_f32 v140, v2, v10
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v10, a15
		v_cvt_pk_bf16_f32 v141, v2, v10
		v_accvgpr_read_b32 v2, a16
		v_accvgpr_read_b32 v10, a17
		v_cvt_pk_bf16_f32 v144, v2, v10
		v_accvgpr_read_b32 v2, a18
		v_accvgpr_read_b32 v10, a19
		v_cvt_pk_bf16_f32 v145, v2, v10
		v_accvgpr_read_b32 v2, a20
		v_accvgpr_read_b32 v10, a21
		v_cvt_pk_bf16_f32 v148, v2, v10
		v_accvgpr_read_b32 v2, a22
		v_accvgpr_read_b32 v10, a23
		v_cvt_pk_bf16_f32 v149, v2, v10
		v_accvgpr_read_b32 v2, a24
		v_accvgpr_read_b32 v10, a25
		v_cvt_pk_bf16_f32 v82, v2, v10
		v_accvgpr_read_b32 v2, a26
		v_accvgpr_read_b32 v10, a27
		v_cvt_pk_bf16_f32 v83, v2, v10
		v_accvgpr_read_b32 v2, a28
		v_accvgpr_read_b32 v10, a29
		v_cvt_pk_bf16_f32 v142, v2, v10
		v_accvgpr_read_b32 v2, a30
		v_accvgpr_read_b32 v10, a31
		v_cvt_pk_bf16_f32 v143, v2, v10
		v_accvgpr_read_b32 v2, a32
		v_accvgpr_read_b32 v10, a33
		v_cvt_pk_bf16_f32 v146, v2, v10
		v_accvgpr_read_b32 v2, a34
		v_accvgpr_read_b32 v10, a35
		v_cvt_pk_bf16_f32 v147, v2, v10
		v_accvgpr_read_b32 v2, a36
		v_accvgpr_read_b32 v10, a37
		v_cvt_pk_bf16_f32 v150, v2, v10
		v_accvgpr_read_b32 v2, a38
		v_accvgpr_read_b32 v10, a39
		v_cvt_pk_bf16_f32 v151, v2, v10
		v_accvgpr_read_b32 v2, a40
		v_accvgpr_read_b32 v10, a41
		v_cvt_pk_bf16_f32 v152, v2, v10
		v_accvgpr_read_b32 v2, a42
		v_accvgpr_read_b32 v10, a43
		v_cvt_pk_bf16_f32 v153, v2, v10
		v_accvgpr_read_b32 v2, a44
		v_accvgpr_read_b32 v10, a45
		v_cvt_pk_bf16_f32 v156, v2, v10
		v_accvgpr_read_b32 v2, a46
		v_accvgpr_read_b32 v10, a47
		v_cvt_pk_bf16_f32 v157, v2, v10
		v_accvgpr_read_b32 v2, a48
		v_accvgpr_read_b32 v10, a49
		v_cvt_pk_bf16_f32 v160, v2, v10
		v_accvgpr_read_b32 v2, a50
		v_accvgpr_read_b32 v10, a51
		v_cvt_pk_bf16_f32 v161, v2, v10
		v_accvgpr_read_b32 v2, a52
		v_accvgpr_read_b32 v10, a53
		v_cvt_pk_bf16_f32 v164, v2, v10
		v_accvgpr_read_b32 v2, a54
		v_accvgpr_read_b32 v10, a55
		v_cvt_pk_bf16_f32 v165, v2, v10
		v_accvgpr_read_b32 v2, a56
		v_accvgpr_read_b32 v10, a57
		v_cvt_pk_bf16_f32 v154, v2, v10
		v_accvgpr_read_b32 v2, a58
		v_accvgpr_read_b32 v10, a59
		v_cvt_pk_bf16_f32 v155, v2, v10
		v_accvgpr_read_b32 v2, a60
		v_accvgpr_read_b32 v10, a61
		v_cvt_pk_bf16_f32 v158, v2, v10
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v10, a63
		v_cvt_pk_bf16_f32 v159, v2, v10
		v_accvgpr_read_b32 v2, a64
		v_accvgpr_read_b32 v10, a65
		v_cvt_pk_bf16_f32 v162, v2, v10
		v_accvgpr_read_b32 v2, a66
		v_accvgpr_read_b32 v10, a67
		v_cvt_pk_bf16_f32 v163, v2, v10
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v10, a69
		v_cvt_pk_bf16_f32 v166, v2, v10
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v10, a71
		v_cvt_pk_bf16_f32 v167, v2, v10
		v_accvgpr_read_b32 v2, a72
		v_accvgpr_read_b32 v10, a73
		v_cvt_pk_bf16_f32 v168, v2, v10
		v_accvgpr_read_b32 v2, a74
		v_accvgpr_read_b32 v10, a75
		v_cvt_pk_bf16_f32 v169, v2, v10
		v_accvgpr_read_b32 v2, a76
		v_accvgpr_read_b32 v10, a77
		v_cvt_pk_bf16_f32 v172, v2, v10
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v10, a79
		v_cvt_pk_bf16_f32 v173, v2, v10
		v_accvgpr_read_b32 v2, a80
		v_accvgpr_read_b32 v10, a81
		v_cvt_pk_bf16_f32 v176, v2, v10
		v_accvgpr_read_b32 v2, a82
		v_accvgpr_read_b32 v10, a83
		v_cvt_pk_bf16_f32 v177, v2, v10
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v10, a85
		v_cvt_pk_bf16_f32 v180, v2, v10
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v10, a87
		v_cvt_pk_bf16_f32 v181, v2, v10
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v10, a89
		v_cvt_pk_bf16_f32 v170, v2, v10
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v10, a91
		v_cvt_pk_bf16_f32 v171, v2, v10
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v10, a93
		v_cvt_pk_bf16_f32 v174, v2, v10
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v10, a95
		v_cvt_pk_bf16_f32 v175, v2, v10
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v10, a97
		v_cvt_pk_bf16_f32 v178, v2, v10
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v10, a99
		v_cvt_pk_bf16_f32 v179, v2, v10
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v10, a101
		v_cvt_pk_bf16_f32 v182, v2, v10
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v10, a103
		v_cvt_pk_bf16_f32 v183, v2, v10
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v0, 0x20000, v0
		ds_write_b128 v0, v[44:47] offset:6976
		ds_write_b128 v0, v[48:51] offset:11072
		ds_write_b128 v0, v[4:7] offset:15168
		ds_write_b128 v0, v[68:71] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v2, a0
		v_lshlrev_b32_e32 v2, 4, v2
		v_add_u32_e32 v2, 0x20000, v2
		v_lshl_add_u32 v2, v18, 9, v2
		v_lshl_add_u32 v2, v16, 13, v2
		v_lshlrev_b32_e32 v4, 12, v20
		v_accvgpr_read_b32 v5, a1
		v_add3_u32 v2, v2, v4, v5
		ds_read_b128 v[4:7], v2 offset:6976
		ds_read_b128 v[44:47], v2 offset:7232
		ds_read_b128 v[48:51], v2 offset:9024
		ds_read_b128 v[68:71], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[80:83] offset:6976
		ds_write_b128 v0, v[140:143] offset:11072
		ds_write_b128 v0, v[144:147] offset:15168
		ds_write_b128 v0, v[148:151] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v2 offset:6976
		ds_read_b128 v[140:143], v2 offset:7232
		ds_read_b128 v[144:147], v2 offset:9024
		ds_read_b128 v[148:151], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[152:155] offset:6976
		ds_write_b128 v0, v[156:159] offset:11072
		ds_write_b128 v0, v[160:163] offset:15168
		ds_write_b128 v0, v[164:167] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[152:155], v2 offset:6976
		ds_read_b128 v[156:159], v2 offset:7232
		ds_read_b128 v[160:163], v2 offset:9024
		ds_read_b128 v[164:167], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[168:171] offset:6976
		ds_write_b128 v0, v[172:175] offset:11072
		ds_write_b128 v0, v[176:179] offset:15168
		ds_write_b128 v0, v[180:183] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[168:171], v2 offset:6976
		ds_read_b128 v[172:175], v2 offset:7232
		ds_read_b128 v[176:179], v2 offset:9024
		ds_read_b128 v[180:183], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s1, s1, 1
		s_add_u32 s2, s6, s1
		s_addc_u32 s3, s7, 0
		s_mov_b32 s4, s2
		s_mov_b32 s5, s3
		s_mov_b32 s6, 0x7fffffff
		s_mov_b32 s7, 0x31016000
		v_mov_b64_e32 v[184:185], v[4:5]
		v_mov_b64_e32 v[186:187], v[44:45]
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v4, s17, v1
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v5, s17, v3
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v10, s0, v4, v5
		v_mul_lo_u32 v12, s17, v11
		v_lshlrev_b32_e32 v12, 2, v12
		v_mul_lo_u32 v17, s17, v13
		v_lshlrev_b32_e32 v17, 1, v17
		v_add3_u32 v10, v10, v12, v17
		v_lshlrev_b32_e32 v16, 7, v16
		v_add3_u32 v10, v10, v19, v16
		v_add3_u32 v10, v10, v21, v23
		buffer_store_dwordx4 v[184:187], v10, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[184:185], v[48:49]
		v_mov_b64_e32 v[186:187], v[68:69]
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v10, 16, v13
		v_lshlrev_b32_e32 v11, 1, v11
		v_xor_b32_e32 v10, v10, v11
		v_xor_b32_e32 v10, v3, v10
		v_xor_b32_e32 v10, v1, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v18, v10, 1, s0
		v_add3_u32 v18, v18, v19, v16
		v_add3_u32 v18, v18, v21, v23
		buffer_store_dwordx4 v[184:187], v18, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[184:185], v[6:7]
		v_mov_b64_e32 v[186:187], v[46:47]
		v_add_u32_e32 v6, 32, v13
		v_xor_b32_e32 v6, v6, v11
		v_xor_b32_e32 v6, v3, v6
		v_xor_b32_e32 v6, v1, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshl_add_u32 v7, v6, 1, s0
		v_add3_u32 v7, v7, v19, v16
		v_add3_u32 v7, v7, v21, v23
		buffer_store_dwordx4 v[184:187], v7, s[4:7], 0 offen
		v_mov_b64_e32 v[44:45], v[50:51]
		v_mov_b64_e32 v[46:47], v[70:71]
		v_add_u32_e32 v7, 48, v13
		v_xor_b32_e32 v7, v7, v11
		v_xor_b32_e32 v7, v3, v7
		v_xor_b32_e32 v7, v1, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshl_add_u32 v18, v7, 1, s0
		v_add3_u32 v18, v18, v19, v16
		v_add3_u32 v18, v18, v21, v23
		buffer_store_dwordx4 v[44:47], v18, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[80:81]
		v_mov_b64_e32 v[46:47], v[140:141]
		v_add_u32_e32 v18, 64, v13
		v_xor_b32_e32 v18, v18, v11
		v_xor_b32_e32 v18, v3, v18
		v_xor_b32_e32 v18, v1, v18
		v_mul_lo_u32 v18, s17, v18
		v_lshl_add_u32 v20, v18, 1, s0
		v_add3_u32 v20, v20, v19, v16
		v_add3_u32 v20, v20, v21, v23
		buffer_store_dwordx4 v[44:47], v20, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[144:145]
		v_mov_b64_e32 v[46:47], v[148:149]
		v_add_u32_e32 v20, 0x50, v13
		v_xor_b32_e32 v20, v20, v11
		v_xor_b32_e32 v20, v3, v20
		v_xor_b32_e32 v20, v1, v20
		v_mul_lo_u32 v20, s17, v20
		v_lshl_add_u32 v22, v20, 1, s0
		v_add3_u32 v22, v22, v19, v16
		v_add3_u32 v22, v22, v21, v23
		buffer_store_dwordx4 v[44:47], v22, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[82:83]
		v_mov_b64_e32 v[46:47], v[142:143]
		v_add_u32_e32 v22, 0x60, v13
		v_xor_b32_e32 v22, v22, v11
		v_xor_b32_e32 v22, v3, v22
		v_xor_b32_e32 v22, v1, v22
		v_mul_lo_u32 v22, s17, v22
		v_lshl_add_u32 v38, v22, 1, s0
		v_add3_u32 v38, v38, v19, v16
		v_add3_u32 v38, v38, v21, v23
		buffer_store_dwordx4 v[44:47], v38, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[146:147]
		v_mov_b64_e32 v[46:47], v[150:151]
		v_add_u32_e32 v38, 0x70, v13
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v3, v38
		v_xor_b32_e32 v38, v1, v38
		v_mul_lo_u32 v38, s17, v38
		v_lshl_add_u32 v39, v38, 1, s0
		v_add3_u32 v39, v39, v19, v16
		v_add3_u32 v39, v39, v21, v23
		buffer_store_dwordx4 v[44:47], v39, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[152:153]
		v_mov_b64_e32 v[46:47], v[156:157]
		v_add_u32_e32 v39, 0x80, v13
		v_xor_b32_e32 v39, v39, v11
		v_xor_b32_e32 v39, v3, v39
		v_xor_b32_e32 v39, v1, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshl_add_u32 v48, v39, 1, s0
		v_add3_u32 v48, v48, v19, v16
		v_add3_u32 v48, v48, v21, v23
		buffer_store_dwordx4 v[44:47], v48, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[160:161]
		v_mov_b64_e32 v[46:47], v[164:165]
		v_add_u32_e32 v48, 0x90, v13
		v_xor_b32_e32 v48, v48, v11
		v_xor_b32_e32 v48, v3, v48
		v_xor_b32_e32 v48, v1, v48
		v_mul_lo_u32 v48, s17, v48
		v_lshl_add_u32 v49, v48, 1, s0
		v_add3_u32 v49, v49, v19, v16
		v_add3_u32 v49, v49, v21, v23
		buffer_store_dwordx4 v[44:47], v49, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[154:155]
		v_mov_b64_e32 v[46:47], v[158:159]
		v_add_u32_e32 v49, 0xa0, v13
		v_xor_b32_e32 v49, v49, v11
		v_xor_b32_e32 v49, v3, v49
		v_xor_b32_e32 v49, v1, v49
		v_mul_lo_u32 v49, s17, v49
		v_lshl_add_u32 v50, v49, 1, s0
		v_add3_u32 v50, v50, v19, v16
		v_add3_u32 v50, v50, v21, v23
		buffer_store_dwordx4 v[44:47], v50, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[162:163]
		v_mov_b64_e32 v[46:47], v[166:167]
		v_add_u32_e32 v50, 0xb0, v13
		v_xor_b32_e32 v50, v50, v11
		v_xor_b32_e32 v50, v3, v50
		v_xor_b32_e32 v50, v1, v50
		v_mul_lo_u32 v50, s17, v50
		v_lshl_add_u32 v51, v50, 1, s0
		v_add3_u32 v51, v51, v19, v16
		v_add3_u32 v51, v51, v21, v23
		buffer_store_dwordx4 v[44:47], v51, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[168:169]
		v_mov_b64_e32 v[46:47], v[172:173]
		v_add_u32_e32 v51, 0xc0, v13
		v_xor_b32_e32 v51, v51, v11
		v_xor_b32_e32 v51, v3, v51
		v_xor_b32_e32 v51, v1, v51
		v_mul_lo_u32 v51, s17, v51
		v_lshl_add_u32 v68, v51, 1, s0
		v_add3_u32 v68, v68, v19, v16
		v_add3_u32 v68, v68, v21, v23
		buffer_store_dwordx4 v[44:47], v68, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[176:177]
		v_mov_b64_e32 v[46:47], v[180:181]
		v_add_u32_e32 v68, 0xd0, v13
		v_xor_b32_e32 v68, v68, v11
		v_xor_b32_e32 v68, v3, v68
		v_xor_b32_e32 v68, v1, v68
		v_mul_lo_u32 v68, s17, v68
		v_lshl_add_u32 v69, v68, 1, s0
		v_add3_u32 v69, v69, v19, v16
		v_add3_u32 v69, v69, v21, v23
		buffer_store_dwordx4 v[44:47], v69, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[170:171]
		v_mov_b64_e32 v[46:47], v[174:175]
		v_add_u32_e32 v69, 0xe0, v13
		v_xor_b32_e32 v69, v69, v11
		v_xor_b32_e32 v69, v3, v69
		v_xor_b32_e32 v69, v1, v69
		v_mul_lo_u32 v69, s17, v69
		v_lshl_add_u32 v70, v69, 1, s0
		v_add3_u32 v70, v70, v19, v16
		v_add3_u32 v70, v70, v21, v23
		buffer_store_dwordx4 v[44:47], v70, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[44:45], v[178:179]
		v_mov_b64_e32 v[46:47], v[182:183]
		v_add_u32_e32 v13, 0xf0, v13
		v_xor_b32_e32 v11, v13, v11
		v_xor_b32_e32 v3, v3, v11
		v_xor_b32_e32 v1, v1, v3
		v_mul_lo_u32 v1, s17, v1
		v_lshl_add_u32 v3, v1, 1, s0
		v_add3_u32 v3, v3, v19, v16
		v_add3_u32 v3, v3, v21, v23
		buffer_store_dwordx4 v[44:47], v3, s[4:7], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[24:27], a[104:107], v36, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], v[28:31], a[104:107], v36, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[24:27], a[108:111], v36, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[28:31], a[108:111], v36, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[24:27], a[112:115], v37, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[116:119], v[28:31], a[112:115], v37, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[132:135], v[24:27], a[116:119], v37, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[136:139], v[28:31], a[116:119], v37, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], v[32:35], a[120:123], v36, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], v[56:59], a[120:123], v36, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[32:35], a[124:127], v36, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[56:59], a[124:127], v36, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[32:35], a[128:131], v37, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[116:119], v[56:59], a[128:131], v37, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[132:135], v[32:35], a[132:135], v37, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[136:139], v[56:59], a[132:135], v37, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], v[60:63], a[136:139], v36, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], v[64:67], a[136:139], v36, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[60:63], a[140:143], v36, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[64:67], a[140:143], v36, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[60:63], a[144:147], v37, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[116:119], v[64:67], a[144:147], v37, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[132:135], v[60:63], a[148:151], v37, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[136:139], v[64:67], a[148:151], v37, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], v[72:75], a[152:155], v36, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], v[76:79], a[152:155], v36, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[72:75], a[156:159], v36, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[76:79], a[156:159], v36, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[72:75], a[160:163], v37, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[116:119], v[76:79], a[160:163], v37, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[132:135], v[72:75], a[164:167], v37, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[136:139], v[76:79], a[164:167], v37, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], v[84:87], a[168:171], v36, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[88:91], a[168:171], v36, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[84:87], a[172:175], v36, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[88:91], a[172:175], v36, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[84:87], a[176:179], v37, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[116:119], v[88:91], a[176:179], v37, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[132:135], v[84:87], a[180:183], v37, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[136:139], v[88:91], a[180:183], v37, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[92:95], a[184:187], v36, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], v[104:107], a[184:187], v36, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[92:95], a[188:191], v36, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[104:107], a[188:191], v36, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[92:95], a[192:195], v37, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[116:119], v[104:107], a[192:195], v37, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[132:135], v[92:95], a[196:199], v37, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[136:139], v[104:107], a[196:199], v37, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[112:115], a[200:203], v36, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[52:55], v[120:123], a[200:203], v36, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[112:115], a[204:207], v36, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[120:123], a[204:207], v36, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[112:115], a[208:211], v37, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[116:119], v[120:123], a[208:211], v37, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[132:135], v[112:115], a[212:215], v37, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[136:139], v[120:123], a[212:215], v37, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[124:127], a[216:219], v36, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[52:55], v[128:131], a[216:219], v36, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[96:99], v[124:127], a[220:223], v36, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[128:131], a[220:223], v36, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[108:111], v[124:127], a[224:227], v37, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[116:119], v[128:131], a[224:227], v37, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[132:135], v[124:127], a[228:231], v37, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[136:139], v[128:131], a[228:231], v37, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v3, a104
		v_accvgpr_read_b32 v8, a105
		v_cvt_pk_bf16_f32 v24, v3, v8
		v_accvgpr_read_b32 v3, a106
		v_accvgpr_read_b32 v8, a107
		v_cvt_pk_bf16_f32 v25, v3, v8
		v_accvgpr_read_b32 v3, a108
		v_accvgpr_read_b32 v8, a109
		v_cvt_pk_bf16_f32 v28, v3, v8
		v_accvgpr_read_b32 v3, a110
		v_accvgpr_read_b32 v8, a111
		v_cvt_pk_bf16_f32 v29, v3, v8
		v_accvgpr_read_b32 v3, a112
		v_accvgpr_read_b32 v8, a113
		v_cvt_pk_bf16_f32 v32, v3, v8
		v_accvgpr_read_b32 v3, a114
		v_accvgpr_read_b32 v8, a115
		v_cvt_pk_bf16_f32 v33, v3, v8
		v_accvgpr_read_b32 v3, a116
		v_accvgpr_read_b32 v8, a117
		v_cvt_pk_bf16_f32 v40, v3, v8
		v_accvgpr_read_b32 v3, a118
		v_accvgpr_read_b32 v8, a119
		v_cvt_pk_bf16_f32 v41, v3, v8
		v_accvgpr_read_b32 v3, a120
		v_accvgpr_read_b32 v8, a121
		v_cvt_pk_bf16_f32 v26, v3, v8
		v_accvgpr_read_b32 v3, a122
		v_accvgpr_read_b32 v8, a123
		v_cvt_pk_bf16_f32 v27, v3, v8
		v_accvgpr_read_b32 v3, a124
		v_accvgpr_read_b32 v8, a125
		v_cvt_pk_bf16_f32 v30, v3, v8
		v_accvgpr_read_b32 v3, a126
		v_accvgpr_read_b32 v8, a127
		v_cvt_pk_bf16_f32 v31, v3, v8
		v_accvgpr_read_b32 v3, a128
		v_accvgpr_read_b32 v8, a129
		v_cvt_pk_bf16_f32 v34, v3, v8
		v_accvgpr_read_b32 v3, a130
		v_accvgpr_read_b32 v8, a131
		v_cvt_pk_bf16_f32 v35, v3, v8
		v_accvgpr_read_b32 v3, a132
		v_accvgpr_read_b32 v8, a133
		v_cvt_pk_bf16_f32 v42, v3, v8
		v_accvgpr_read_b32 v3, a134
		v_accvgpr_read_b32 v8, a135
		v_cvt_pk_bf16_f32 v43, v3, v8
		v_accvgpr_read_b32 v3, a136
		v_accvgpr_read_b32 v8, a137
		v_cvt_pk_bf16_f32 v44, v3, v8
		v_accvgpr_read_b32 v3, a138
		v_accvgpr_read_b32 v8, a139
		v_cvt_pk_bf16_f32 v45, v3, v8
		v_accvgpr_read_b32 v3, a140
		v_accvgpr_read_b32 v8, a141
		v_cvt_pk_bf16_f32 v52, v3, v8
		v_accvgpr_read_b32 v3, a142
		v_accvgpr_read_b32 v8, a143
		v_cvt_pk_bf16_f32 v53, v3, v8
		v_accvgpr_read_b32 v3, a144
		v_accvgpr_read_b32 v8, a145
		v_cvt_pk_bf16_f32 v56, v3, v8
		v_accvgpr_read_b32 v3, a146
		v_accvgpr_read_b32 v8, a147
		v_cvt_pk_bf16_f32 v57, v3, v8
		v_accvgpr_read_b32 v3, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v60, v3, v8
		v_accvgpr_read_b32 v3, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v61, v3, v8
		v_accvgpr_read_b32 v3, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v46, v3, v8
		v_accvgpr_read_b32 v3, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v47, v3, v8
		v_accvgpr_read_b32 v3, a156
		v_accvgpr_read_b32 v8, a157
		v_cvt_pk_bf16_f32 v54, v3, v8
		v_accvgpr_read_b32 v3, a158
		v_accvgpr_read_b32 v8, a159
		v_cvt_pk_bf16_f32 v55, v3, v8
		v_accvgpr_read_b32 v3, a160
		v_accvgpr_read_b32 v8, a161
		v_cvt_pk_bf16_f32 v58, v3, v8
		v_accvgpr_read_b32 v3, a162
		v_accvgpr_read_b32 v8, a163
		v_cvt_pk_bf16_f32 v59, v3, v8
		v_accvgpr_read_b32 v3, a164
		v_accvgpr_read_b32 v8, a165
		v_cvt_pk_bf16_f32 v62, v3, v8
		v_accvgpr_read_b32 v3, a166
		v_accvgpr_read_b32 v8, a167
		v_cvt_pk_bf16_f32 v63, v3, v8
		v_accvgpr_read_b32 v3, a168
		v_accvgpr_read_b32 v8, a169
		v_cvt_pk_bf16_f32 v64, v3, v8
		v_accvgpr_read_b32 v3, a170
		v_accvgpr_read_b32 v8, a171
		v_cvt_pk_bf16_f32 v65, v3, v8
		v_accvgpr_read_b32 v3, a172
		v_accvgpr_read_b32 v8, a173
		v_cvt_pk_bf16_f32 v72, v3, v8
		v_accvgpr_read_b32 v3, a174
		v_accvgpr_read_b32 v8, a175
		v_cvt_pk_bf16_f32 v73, v3, v8
		v_accvgpr_read_b32 v3, a176
		v_accvgpr_read_b32 v8, a177
		v_cvt_pk_bf16_f32 v76, v3, v8
		v_accvgpr_read_b32 v3, a178
		v_accvgpr_read_b32 v8, a179
		v_cvt_pk_bf16_f32 v77, v3, v8
		v_accvgpr_read_b32 v3, a180
		v_accvgpr_read_b32 v8, a181
		v_cvt_pk_bf16_f32 v80, v3, v8
		v_accvgpr_read_b32 v3, a182
		v_accvgpr_read_b32 v8, a183
		v_cvt_pk_bf16_f32 v81, v3, v8
		v_accvgpr_read_b32 v3, a184
		v_accvgpr_read_b32 v8, a185
		v_cvt_pk_bf16_f32 v66, v3, v8
		v_accvgpr_read_b32 v3, a186
		v_accvgpr_read_b32 v8, a187
		v_cvt_pk_bf16_f32 v67, v3, v8
		v_accvgpr_read_b32 v3, a188
		v_accvgpr_read_b32 v8, a189
		v_cvt_pk_bf16_f32 v74, v3, v8
		v_accvgpr_read_b32 v3, a190
		v_accvgpr_read_b32 v8, a191
		v_cvt_pk_bf16_f32 v75, v3, v8
		v_accvgpr_read_b32 v3, a192
		v_accvgpr_read_b32 v8, a193
		v_cvt_pk_bf16_f32 v78, v3, v8
		v_accvgpr_read_b32 v3, a194
		v_accvgpr_read_b32 v8, a195
		v_cvt_pk_bf16_f32 v79, v3, v8
		v_accvgpr_read_b32 v3, a196
		v_accvgpr_read_b32 v8, a197
		v_cvt_pk_bf16_f32 v82, v3, v8
		v_accvgpr_read_b32 v3, a198
		v_accvgpr_read_b32 v8, a199
		v_cvt_pk_bf16_f32 v83, v3, v8
		v_accvgpr_read_b32 v3, a200
		v_accvgpr_read_b32 v8, a201
		v_cvt_pk_bf16_f32 v84, v3, v8
		v_accvgpr_read_b32 v3, a202
		v_accvgpr_read_b32 v8, a203
		v_cvt_pk_bf16_f32 v85, v3, v8
		v_accvgpr_read_b32 v3, a204
		v_accvgpr_read_b32 v8, a205
		v_cvt_pk_bf16_f32 v88, v3, v8
		v_accvgpr_read_b32 v3, a206
		v_accvgpr_read_b32 v8, a207
		v_cvt_pk_bf16_f32 v89, v3, v8
		v_accvgpr_read_b32 v3, a208
		v_accvgpr_read_b32 v8, a209
		v_cvt_pk_bf16_f32 v92, v3, v8
		v_accvgpr_read_b32 v3, a210
		v_accvgpr_read_b32 v8, a211
		v_cvt_pk_bf16_f32 v93, v3, v8
		v_accvgpr_read_b32 v3, a212
		v_accvgpr_read_b32 v8, a213
		v_cvt_pk_bf16_f32 v96, v3, v8
		v_accvgpr_read_b32 v3, a214
		v_accvgpr_read_b32 v8, a215
		v_cvt_pk_bf16_f32 v97, v3, v8
		v_accvgpr_read_b32 v3, a216
		v_accvgpr_read_b32 v8, a217
		v_cvt_pk_bf16_f32 v86, v3, v8
		v_accvgpr_read_b32 v3, a218
		v_accvgpr_read_b32 v8, a219
		v_cvt_pk_bf16_f32 v87, v3, v8
		v_accvgpr_read_b32 v3, a220
		v_accvgpr_read_b32 v8, a221
		v_cvt_pk_bf16_f32 v90, v3, v8
		v_accvgpr_read_b32 v3, a222
		v_accvgpr_read_b32 v8, a223
		v_cvt_pk_bf16_f32 v91, v3, v8
		v_accvgpr_read_b32 v3, a224
		v_accvgpr_read_b32 v8, a225
		v_cvt_pk_bf16_f32 v94, v3, v8
		v_accvgpr_read_b32 v3, a226
		v_accvgpr_read_b32 v8, a227
		v_cvt_pk_bf16_f32 v95, v3, v8
		v_accvgpr_read_b32 v3, a228
		v_accvgpr_read_b32 v8, a229
		v_cvt_pk_bf16_f32 v98, v3, v8
		v_accvgpr_read_b32 v3, a230
		v_accvgpr_read_b32 v8, a231
		v_cvt_pk_bf16_f32 v99, v3, v8
		ds_write_b128 v0, v[24:27] offset:6976
		ds_write_b128 v0, v[28:31] offset:11072
		ds_write_b128 v0, v[32:35] offset:15168
		ds_write_b128 v0, v[40:43] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2 offset:6976
		ds_read_b128 v[28:31], v2 offset:7232
		ds_read_b128 v[32:35], v2 offset:9024
		ds_read_b128 v[40:43], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[44:47] offset:6976
		ds_write_b128 v0, v[52:55] offset:11072
		ds_write_b128 v0, v[56:59] offset:15168
		ds_write_b128 v0, v[60:63] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v2 offset:6976
		ds_read_b128 v[52:55], v2 offset:7232
		ds_read_b128 v[56:59], v2 offset:9024
		ds_read_b128 v[60:63], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[64:67] offset:6976
		ds_write_b128 v0, v[72:75] offset:11072
		ds_write_b128 v0, v[76:79] offset:15168
		ds_write_b128 v0, v[80:83] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v2 offset:6976
		ds_read_b128 v[72:75], v2 offset:7232
		ds_read_b128 v[76:79], v2 offset:9024
		ds_read_b128 v[80:83], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[84:87] offset:6976
		ds_write_b128 v0, v[88:91] offset:11072
		ds_write_b128 v0, v[92:95] offset:15168
		ds_write_b128 v0, v[96:99] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v2 offset:6976
		ds_read_b128 v[88:91], v2 offset:7232
		ds_read_b128 v[92:95], v2 offset:9024
		ds_read_b128 v[96:99], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[100:101], v[24:25]
		v_mov_b64_e32 v[102:103], v[28:29]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v4, v5
		v_add3_u32 v0, v0, v12, v17
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[100:103], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[12:13], v[32:33]
		v_mov_b64_e32 v[14:15], v[40:41]
		v_lshl_add_u32 v0, v10, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[12:15], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[8:9], v[26:27]
		v_mov_b64_e32 v[10:11], v[30:31]
		v_lshl_add_u32 v0, v6, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[8:11], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[34:35]
		v_mov_b64_e32 v[10:11], v[42:43]
		v_lshl_add_u32 v0, v7, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[8:11], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[4:5], v[44:45]
		v_mov_b64_e32 v[6:7], v[52:53]
		v_lshl_add_u32 v0, v18, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[56:57]
		v_mov_b64_e32 v[6:7], v[60:61]
		v_lshl_add_u32 v0, v20, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[46:47]
		v_mov_b64_e32 v[6:7], v[54:55]
		v_lshl_add_u32 v0, v22, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[58:59]
		v_mov_b64_e32 v[6:7], v[62:63]
		v_lshl_add_u32 v0, v38, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[64:65]
		v_mov_b64_e32 v[6:7], v[72:73]
		v_lshl_add_u32 v0, v39, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[76:77]
		v_mov_b64_e32 v[6:7], v[80:81]
		v_lshl_add_u32 v0, v48, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[66:67]
		v_mov_b64_e32 v[6:7], v[74:75]
		v_lshl_add_u32 v0, v49, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[78:79]
		v_mov_b64_e32 v[6:7], v[82:83]
		v_lshl_add_u32 v0, v50, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[84:85]
		v_mov_b64_e32 v[6:7], v[88:89]
		v_lshl_add_u32 v0, v51, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[92:93]
		v_mov_b64_e32 v[6:7], v[96:97]
		v_lshl_add_u32 v0, v68, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[86:87]
		v_mov_b64_e32 v[6:7], v[90:91]
		v_lshl_add_u32 v0, v69, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[94:95]
		v_mov_b64_e32 v[6:7], v[98:99]
		v_lshl_add_u32 v0, v1, 1, s0
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 154432
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
		.amdhsa_next_free_vgpr 488
		.amdhsa_next_free_sgpr 80
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
	.set .L_a4w4_kernel.num_vgpr, 255
	.set .L_a4w4_kernel.num_agpr, 232
	.set .L_a4w4_kernel.numbered_sgpr, 80
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
    .group_segment_fixed_size: 154432
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     80
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     488
    .agpr_count:     232
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 60
    wave.regalloc.agpr.dwords: 230
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
