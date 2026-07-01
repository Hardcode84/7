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
		v_add3_u32 v73, v73, v43, v44
		buffer_load_ubyte v74, v68, s[56:59], 0 offen
		buffer_load_ubyte v75, v71, s[56:59], 0 offen
		buffer_load_ubyte v76, v72, s[56:59], 0 offen
		buffer_load_ubyte v77, v73, s[56:59], 0 offen
		s_lshl_b32 s60, s15, 7
		v_add3_u32 v78, s60, v31, v32
		v_add3_u32 v78, v78, v34, v35
		v_add3_u32 v78, v78, v36, v19
		v_add3_u32 v78, v78, v21, v23
		s_add_i32 s61, s22, 0x18b80
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v78, s[44:47], 0 offen lds
		s_mul_i32 s62, 0x84, s15
		v_add3_u32 v79, s62, v31, v32
		v_add3_u32 v79, v79, v34, v35
		v_add3_u32 v79, v79, v36, v19
		v_add3_u32 v79, v79, v21, v23
		s_add_i32 s63, s22, 0x19c00
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v79, s[44:47], 0 offen lds
		s_mul_i32 s64, 0x88, s15
		v_add3_u32 v80, s64, v31, v32
		v_add3_u32 v80, v80, v34, v35
		v_add3_u32 v80, v80, v36, v19
		v_add3_u32 v80, v80, v21, v23
		s_add_i32 s65, s22, 0x1ac80
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v80, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v81, s15, v31, v32
		v_add3_u32 v81, v81, v34, v35
		v_add3_u32 v81, v81, v36, v19
		v_add3_u32 v81, v81, v21, v23
		s_add_i32 s66, s22, 0x1bd00
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v81, s[44:47], 0 offen lds
		s_lshl_b32 s67, s19, 7
		s_add_i32 s68, s67, s51
		v_mul_lo_u32 v82, s19, v18
		v_lshlrev_b32_e32 v82, 2, v82
		v_lshlrev_b32_e32 v69, 6, v69
		v_add3_u32 v83, s68, v82, v69
		v_lshlrev_b32_e32 v70, 5, v70
		v_mul_lo_u32 v84, s19, v20
		v_lshlrev_b32_e32 v84, 4, v84
		v_add3_u32 v83, v83, v70, v84
		v_mul_lo_u32 v85, s19, v22
		v_lshlrev_b32_e32 v85, 3, v85
		v_add3_u32 v83, v83, v85, v10
		s_mul_i32 s68, 0x81, s19
		s_add_i32 s69, s68, s51
		v_add3_u32 v86, s69, v82, v69
		v_add3_u32 v86, v86, v70, v84
		v_add3_u32 v86, v86, v85, v10
		s_mul_i32 s69, 0x82, s19
		s_add_i32 s70, s69, s51
		v_add3_u32 v87, s70, v82, v69
		v_add3_u32 v87, v87, v70, v84
		v_add3_u32 v87, v87, v85, v10
		s_mul_i32 s70, 0x83, s19
		s_add_i32 s71, s70, s51
		v_add3_u32 v88, s71, v82, v69
		v_add3_u32 v88, v88, v70, v84
		v_add3_u32 v88, v88, v85, v10
		buffer_load_ubyte v89, v83, s[56:59], 0 offen
		buffer_load_ubyte v90, v86, s[56:59], 0 offen
		buffer_load_ubyte v91, v87, s[56:59], 0 offen
		buffer_load_ubyte v92, v88, s[56:59], 0 offen
		v_add_u32_e32 v93, 0x80, v2
		v_add_u32_e32 v93, v93, v8
		v_add3_u32 v93, v93, v12, v14
		v_add3_u32 v93, v93, v17, v19
		v_add3_u32 v93, v93, v21, v23
		s_add_i32 s71, s22, 0x83e0
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_add_i32 s23, s23, 0x80
		v_add3_u32 v94, s23, v2, v8
		v_add3_u32 v94, v94, v12, v14
		v_add3_u32 v94, v94, v17, v19
		v_add3_u32 v94, v94, v21, v23
		s_add_i32 s23, s22, 0x9460
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_add_i32 s29, s29, 0x80
		v_add3_u32 v95, s29, v2, v8
		v_add3_u32 v95, v95, v12, v14
		v_add3_u32 v95, v95, v17, v19
		v_add3_u32 v95, v95, v21, v23
		s_add_i32 s29, s22, 0xa4e0
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s31, s31, 0x80
		v_add3_u32 v96, s31, v2, v8
		v_add3_u32 v96, v96, v12, v14
		v_add3_u32 v96, v96, v17, v19
		v_add3_u32 v96, v96, v21, v23
		s_add_i32 s31, s22, 0xb560
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 0x80
		v_add3_u32 v97, s33, v2, v8
		v_add3_u32 v97, v97, v12, v14
		v_add3_u32 v97, v97, v17, v19
		v_add3_u32 v97, v97, v21, v23
		s_add_i32 s33, s22, 0xc5e0
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v97, s[24:27], 0 offen lds
		s_add_i32 s35, s35, 0x80
		v_add3_u32 v98, s35, v2, v8
		v_add3_u32 v98, v98, v12, v14
		v_add3_u32 v98, v98, v17, v19
		v_add3_u32 v98, v98, v21, v23
		s_add_i32 s35, s22, 0xd660
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v98, s[24:27], 0 offen lds
		s_add_i32 s37, s37, 0x80
		v_add3_u32 v99, s37, v2, v8
		v_add3_u32 v99, v99, v12, v14
		v_add3_u32 v99, v99, v17, v19
		v_add3_u32 v99, v99, v21, v23
		s_add_i32 s37, s22, 0xe6e0
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v99, s[24:27], 0 offen lds
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
		v_mul_lo_u32 v100, s18, v18
		v_lshlrev_b32_e32 v100, 3, v100
		v_lshlrev_b32_e32 v41, 7, v41
		v_add3_u32 v101, s41, v100, v41
		v_lshlrev_b32_e32 v42, 6, v42
		v_mul_lo_u32 v102, s18, v20
		v_lshlrev_b32_e32 v102, 5, v102
		v_add3_u32 v101, v101, v42, v102
		v_mul_lo_u32 v103, s18, v22
		v_lshlrev_b32_e32 v103, 4, v103
		v_add3_u32 v101, v101, v103, v10
		s_add_i32 s41, s18, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v104, s41, v100, v41
		v_add3_u32 v104, v104, v42, v102
		v_add3_u32 v104, v104, v103, v10
		s_lshl_b32 s41, s18, 1
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v105, s41, v100, v41
		v_add3_u32 v105, v105, v42, v102
		v_add3_u32 v105, v105, v103, v10
		s_mul_i32 s41, 3, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v106, s41, v100, v41
		v_add3_u32 v106, v106, v42, v102
		v_add3_u32 v106, v106, v103, v10
		s_lshl_b32 s41, s18, 2
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v107, s41, v100, v41
		v_add3_u32 v107, v107, v42, v102
		v_add3_u32 v107, v107, v103, v10
		s_mul_i32 s41, 5, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v108, s41, v100, v41
		v_add3_u32 v108, v108, v42, v102
		v_add3_u32 v108, v108, v103, v10
		s_mul_i32 s41, 6, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v109, s41, v100, v41
		v_add3_u32 v109, v109, v42, v102
		v_add3_u32 v109, v109, v103, v10
		s_mul_i32 s18, 7, s18
		s_add_i32 s18, s18, 8
		s_add_i32 s1, s18, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v41, s1, v100, v41
		v_add3_u32 v41, v41, v42, v102
		v_add3_u32 v41, v41, v103, v10
		buffer_load_ubyte v42, v101, s[52:55], 0 offen
		buffer_load_ubyte v100, v104, s[52:55], 0 offen
		buffer_load_ubyte v102, v105, s[52:55], 0 offen
		buffer_load_ubyte v103, v106, s[52:55], 0 offen
		buffer_load_ubyte v110, v107, s[52:55], 0 offen
		buffer_load_ubyte v111, v108, s[52:55], 0 offen
		buffer_load_ubyte v112, v109, s[52:55], 0 offen
		buffer_load_ubyte v113, v41, s[52:55], 0 offen
		s_add_i32 s1, s51, 8
		v_add3_u32 v114, s1, v82, v69
		v_add3_u32 v114, v114, v70, v84
		v_add3_u32 v114, v114, v85, v10
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v115, s1, v82, v69
		v_add3_u32 v115, v115, v70, v84
		v_add3_u32 v115, v115, v85, v10
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v116, s1, v82, v69
		v_add3_u32 v116, v116, v70, v84
		v_add3_u32 v116, v116, v85, v10
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v117, s1, v82, v69
		v_add3_u32 v117, v117, v70, v84
		v_add3_u32 v117, v117, v85, v10
		buffer_load_ubyte v118, v114, s[56:59], 0 offen
		buffer_load_ubyte v119, v115, s[56:59], 0 offen
		buffer_load_ubyte v120, v116, s[56:59], 0 offen
		buffer_load_ubyte v121, v117, s[56:59], 0 offen
		s_add_i32 s1, s60, 0x80
		v_add3_u32 v122, s1, v31, v32
		v_add3_u32 v122, v122, v34, v35
		v_add3_u32 v122, v122, v36, v19
		v_add3_u32 v122, v122, v21, v23
		s_add_i32 s1, s22, 0x1cd60
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v122, s[44:47], 0 offen lds
		s_add_i32 s16, s62, 0x80
		v_add3_u32 v123, s16, v31, v32
		v_add3_u32 v123, v123, v34, v35
		v_add3_u32 v123, v123, v36, v19
		v_add3_u32 v123, v123, v21, v23
		s_add_i32 s16, s22, 0x1dde0
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v123, s[44:47], 0 offen lds
		s_add_i32 s18, s64, 0x80
		v_add3_u32 v124, s18, v31, v32
		v_add3_u32 v124, v124, v34, v35
		v_add3_u32 v124, v124, v36, v19
		v_add3_u32 v124, v124, v21, v23
		s_add_i32 s18, s22, 0x1ee60
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v124, s[44:47], 0 offen lds
		s_add_i32 s15, s15, 0x80
		v_add3_u32 v31, s15, v31, v32
		v_add3_u32 v31, v31, v34, v35
		v_add3_u32 v19, v31, v36, v19
		v_add3_u32 v19, v19, v21, v23
		s_add_i32 s15, s22, 0x1fee0
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v19, s[44:47], 0 offen lds
		s_add_i32 s19, s67, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v21, s19, v82, v69
		v_add3_u32 v21, v21, v70, v84
		v_add3_u32 v21, v21, v85, v10
		s_add_i32 s19, s68, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v23, s19, v82, v69
		v_add3_u32 v23, v23, v70, v84
		v_add3_u32 v23, v23, v85, v10
		s_add_i32 s19, s69, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v31, s19, v82, v69
		v_add3_u32 v31, v31, v70, v84
		v_add3_u32 v31, v31, v85, v10
		s_add_i32 s19, s70, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v32, s19, v82, v69
		v_add3_u32 v32, v32, v70, v84
		v_add3_u32 v10, v32, v85, v10
		buffer_load_ubyte v32, v21, s[56:59], 0 offen
		buffer_load_ubyte v34, v23, s[56:59], 0 offen
		buffer_load_ubyte v35, v31, s[56:59], 0 offen
		buffer_load_ubyte v36, v10, s[56:59], 0 offen
		s_add_i32 s19, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v69, 7, v1
		v_and_b32_e32 v70, 63, v0
		v_lshrrev_b32_e32 v82, 4, v70
		v_lshlrev_b32_e32 v82, 4, v82
		v_and_b32_e32 v70, 15, v70
		v_mov_b32_e32 v84, 0x420
		v_mul_lo_u32 v84, v84, v70
		v_add3_u32 v69, v69, v82, v84
		ds_read_b128 v[128:131], v69
		ds_read_b128 v[132:135], v69 offset:64
		ds_read_b128 v[136:139], v69 offset:256
		ds_read_b128 v[140:143], v69 offset:320
		ds_read_b128 v[144:147], v69 offset:512
		ds_read_b128 v[148:151], v69 offset:576
		ds_read_b128 v[152:155], v69 offset:768
		ds_read_b128 v[156:159], v69 offset:832
		ds_read_b128 v[160:163], v69 offset:16896
		ds_read_b128 v[164:167], v69 offset:16960
		ds_read_b128 v[168:171], v69 offset:17152
		ds_read_b128 v[172:175], v69 offset:17216
		ds_read_b128 v[176:179], v69 offset:17408
		ds_read_b128 v[180:183], v69 offset:17472
		ds_read_b128 v[184:187], v69 offset:17664
		ds_read_b128 v[188:191], v69 offset:17728
		v_add_u32_e32 v70, 0x10000, v82
		v_lshlrev_b32_e32 v82, 7, v3
		v_add3_u32 v70, v70, v82, v84
		ds_read_b128 v[192:195], v70 offset:1984
		ds_read_b128 v[196:199], v70 offset:2048
		ds_read_b128 v[200:203], v70 offset:2240
		ds_read_b128 v[204:207], v70 offset:2304
		ds_read_b128 v[208:211], v70 offset:2496
		ds_read_b128 v[212:215], v70 offset:2560
		ds_read_b128 v[216:219], v70 offset:2752
		ds_read_b128 v[220:223], v70 offset:2816
		v_add_u32_e32 v15, 0x20000, v15
		v_lshlrev_b32_e32 v82, 8, v18
		v_add_u32_e32 v84, v15, v82
		v_lshlrev_b32_e32 v85, 10, v20
		v_lshlrev_b32_e32 v125, 9, v22
		v_add3_u32 v84, v84, v85, v125
		s_waitcnt vmcnt(51)
		ds_write_b8 v84, v49 offset:3904
		v_add_u32_e32 v49, 0x20000, v82
		v_add3_u32 v49, v49, v85, v125
		v_add_u32_e32 v82, v49, v48
		s_waitcnt vmcnt(50)
		ds_write_b8 v82, v61 offset:3904
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
		ds_write_b8 v15, v74 offset:5952
		v_add_u32_e32 v49, 0x20000, v49
		v_add3_u32 v49, v49, v63, v64
		v_add_u32_e32 v48, v49, v48
		s_waitcnt vmcnt(42)
		ds_write_b8 v48, v75 offset:5952
		v_add_u32_e32 v51, v49, v51
		s_waitcnt vmcnt(41)
		ds_write_b8 v51, v76 offset:5952
		v_add_u32_e32 v49, v49, v53
		s_waitcnt vmcnt(40)
		ds_write_b8 v49, v77 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v53, 0x20000, v45
		v_lshlrev_b32_e32 v63, 3, v18
		v_add_u32_e32 v53, v53, v63
		v_lshl_add_u32 v53, v11, 9, v53
		v_lshl_add_u32 v53, v13, 8, v53
		v_lshlrev_b32_e32 v64, 6, v16
		v_lshlrev_b32_e32 v65, 5, v20
		v_add3_u32 v53, v53, v64, v65
		v_lshl_add_u32 v53, v22, 10, v53
		ds_read_b64_tr_b8 v[66:67], v53 offset:3904
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v74, 0xff, v66
		v_lshrrev_b32_e32 v75, 8, v66
		v_and_b32_e32 v76, 0xff, v75
		v_lshrrev_b32_e32 v75, 16, v66
		v_and_b32_e32 v77, 0xff, v75
		v_lshrrev_b32_e32 v66, 24, v66
		v_and_b32_e32 v75, 0xff, v66
		v_and_b32_e32 v66, 0xff, v67
		v_lshrrev_b32_e32 v85, 8, v67
		v_and_b32_e32 v126, 0xff, v85
		v_lshrrev_b32_e32 v85, 16, v67
		v_and_b32_e32 v127, 0xff, v85
		v_lshrrev_b32_e32 v67, 24, v67
		v_and_b32_e32 v85, 0xff, v67
		ds_read_b64_tr_b8 v[224:225], v53 offset:4032
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v67, 0xff, v224
		v_lshrrev_b32_e32 v226, 8, v224
		v_and_b32_e32 v227, 0xff, v226
		v_lshrrev_b32_e32 v226, 16, v224
		v_and_b32_e32 v228, 0xff, v226
		v_lshrrev_b32_e32 v224, 24, v224
		v_and_b32_e32 v226, 0xff, v224
		v_and_b32_e32 v224, 0xff, v225
		v_lshrrev_b32_e32 v229, 8, v225
		v_and_b32_e32 v230, 0xff, v229
		v_lshrrev_b32_e32 v229, 16, v225
		v_and_b32_e32 v231, 0xff, v229
		v_lshrrev_b32_e32 v225, 24, v225
		v_and_b32_e32 v229, 0xff, v225
		v_add_u32_e32 v63, 0x20000, v63
		v_lshlrev_b32_e32 v225, 4, v3
		v_add_u32_e32 v63, v63, v225
		v_lshl_add_u32 v63, v11, 8, v63
		v_lshlrev_b32_e32 v232, 7, v13
		v_add3_u32 v63, v63, v232, v64
		v_add3_u32 v63, v63, v65, v125
		ds_read_b64_tr_b8 v[64:65], v63 offset:5952
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v125, 0xff, v64
		v_lshrrev_b32_e32 v232, 8, v64
		v_and_b32_e32 v233, 0xff, v232
		v_lshrrev_b32_e32 v232, 16, v64
		v_and_b32_e32 v234, 0xff, v232
		v_lshrrev_b32_e32 v64, 24, v64
		v_and_b32_e32 v232, 0xff, v64
		v_and_b32_e32 v64, 0xff, v65
		v_lshrrev_b32_e32 v235, 8, v65
		v_and_b32_e32 v236, 0xff, v235
		v_lshrrev_b32_e32 v235, 16, v65
		v_and_b32_e32 v237, 0xff, v235
		v_lshrrev_b32_e32 v65, 24, v65
		v_and_b32_e32 v235, 0xff, v65
		s_mov_b32 s20, 16
		v_lshlrev_b32_e32 v65, 2, v0
		v_add_u32_e32 v65, 0x20000, v65
		v_lshlrev_b32_e32 v0, 3, v0
		v_add_u32_e32 v0, 0x20000, v0
		s_mov_b32 s41, s20
		v_mov_b32_e32 v4, v4
		v_mov_b32_e32 v5, v5
		v_mov_b32_e32 v6, v6
		v_mov_b32_e32 v7, v7
		v_accvgpr_write_b32 a0, v4
		v_accvgpr_write_b32 a1, v5
		v_accvgpr_write_b32 a2, v6
		v_accvgpr_write_b32 a3, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a4, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a5, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a6, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a7, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a8, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a9, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a10, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a11, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a12, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a13, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a14, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a15, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a16, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a17, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a18, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a19, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a20, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a21, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a22, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a23, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a24, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a25, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a26, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a27, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a28, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a29, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a30, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a31, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a32, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a33, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a34, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a35, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a36, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a37, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a38, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a39, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a40, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a41, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a42, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a43, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a44, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a45, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a46, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a47, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a48, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a49, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a50, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a51, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a52, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a53, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a54, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a55, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a56, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a57, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a58, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a59, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a60, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a61, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a62, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a63, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a64, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a65, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a66, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a67, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a68, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a69, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a70, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a71, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a72, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a73, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a74, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a75, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a76, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a77, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a78, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a79, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a80, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a81, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a82, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a83, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a84, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a85, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a86, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a87, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a88, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a89, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a90, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a91, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a92, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a93, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a94, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a95, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a96, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a97, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a98, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a99, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a100, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a101, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a102, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a103, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a104, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a105, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a106, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a107, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a108, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a109, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a110, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a111, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a112, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a113, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a114, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a115, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a116, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a117, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a118, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a119, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a120, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a121, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a122, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a123, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a124, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a125, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a126, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a127, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a128, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a129, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a130, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a131, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a132, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a133, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a134, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a135, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a136, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a137, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a138, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a139, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a140, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a141, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a142, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a143, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a144, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a145, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a146, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a147, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a148, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a149, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a150, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a151, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a152, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a153, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a154, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a155, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a156, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a157, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a158, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a159, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a160, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a161, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a162, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a163, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a164, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a165, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a166, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a167, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a168, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a169, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a170, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a171, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a172, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a173, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a174, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a175, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a176, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a177, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a178, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a179, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a180, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a181, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a182, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a183, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a184, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a185, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a186, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a187, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a188, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a189, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a190, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a191, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a192, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a193, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a194, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a195, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a196, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a197, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a198, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a199, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a200, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a201, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a202, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a203, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a204, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a205, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a206, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a207, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a208, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a209, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a210, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a211, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a212, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a213, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a214, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a215, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a216, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a217, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a218, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a219, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a220, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a221, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a222, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a223, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a224, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a225, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a226, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a227, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a228, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a229, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a230, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a231, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a232, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a233, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a234, v238
		v_mov_b32_e32 v238, 0
		v_accvgpr_write_b32 a235, v238
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
.L_a4w4_kernel.loop_head_0:
		v_and_b32_e32 v74, 0xff, v74
		v_and_b32_e32 v76, 0xff, v76
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v74, v74, v76
		v_and_b32_e32 v76, 0xff, v77
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v75, 0xff, v75
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v74, v74, v76, v75
		v_and_b32_e32 v66, 0xff, v66
		v_and_b32_e32 v75, 0xff, v126
		v_lshlrev_b32_e32 v75, 8, v75
		v_or_b32_e32 v66, v66, v75
		v_and_b32_e32 v75, 0xff, v127
		v_lshlrev_b32_e32 v75, 16, v75
		v_and_b32_e32 v76, 0xff, v85
		v_lshlrev_b32_e32 v76, 24, v76
		v_or3_b32 v66, v66, v75, v76
		v_and_b32_e32 v67, 0xff, v67
		v_and_b32_e32 v75, 0xff, v227
		v_lshlrev_b32_e32 v75, 8, v75
		v_or_b32_e32 v67, v67, v75
		v_and_b32_e32 v75, 0xff, v228
		v_lshlrev_b32_e32 v75, 16, v75
		v_and_b32_e32 v76, 0xff, v226
		v_lshlrev_b32_e32 v76, 24, v76
		v_or3_b32 v67, v67, v75, v76
		v_and_b32_e32 v75, 0xff, v224
		v_and_b32_e32 v76, 0xff, v230
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v75, v75, v76
		v_and_b32_e32 v76, 0xff, v231
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v77, 0xff, v229
		v_lshlrev_b32_e32 v77, 24, v77
		v_or3_b32 v75, v75, v76, v77
		v_and_b32_e32 v76, 0xff, v125
		v_and_b32_e32 v77, 0xff, v233
		v_lshlrev_b32_e32 v77, 8, v77
		v_or_b32_e32 v76, v76, v77
		v_and_b32_e32 v77, 0xff, v234
		v_lshlrev_b32_e32 v77, 16, v77
		v_and_b32_e32 v85, 0xff, v232
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v76, v76, v77, v85
		v_and_b32_e32 v64, 0xff, v64
		v_and_b32_e32 v77, 0xff, v236
		v_lshlrev_b32_e32 v77, 8, v77
		v_or_b32_e32 v64, v64, v77
		v_and_b32_e32 v77, 0xff, v237
		v_lshlrev_b32_e32 v77, 16, v77
		v_and_b32_e32 v85, 0xff, v235
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v64, v64, v77, v85
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[128:131], v[4:7], v76, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[196:199], v[132:135], v[4:7], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[128:131], a[0:3], v76, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[204:207], v[132:135], a[0:3], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[128:131], v[240:243], v64, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[212:215], v[132:135], v[240:243], v64, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[128:131], v[244:247], v64, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[220:223], v[132:135], v[244:247], v64, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[136:139], v[248:251], v76, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[196:199], v[140:143], v[248:251], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[136:139], a[4:7], v76, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[204:207], v[140:143], a[4:7], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[136:139], a[8:11], v64, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[212:215], v[140:143], a[8:11], v64, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[136:139], a[12:15], v64, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[220:223], v[140:143], a[12:15], v64, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[144:147], a[16:19], v76, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[196:199], v[148:151], a[16:19], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[144:147], a[20:23], v76, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[204:207], v[148:151], a[20:23], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[144:147], a[24:27], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[212:215], v[148:151], a[24:27], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[144:147], a[28:31], v64, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[220:223], v[148:151], a[28:31], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[152:155], a[32:35], v76, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[196:199], v[156:159], a[32:35], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[152:155], a[36:39], v76, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[156:159], a[36:39], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[152:155], a[40:43], v64, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[212:215], v[156:159], a[40:43], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[152:155], a[44:47], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[220:223], v[156:159], a[44:47], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[160:163], a[48:51], v76, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[196:199], v[164:167], a[48:51], v76, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[160:163], a[52:55], v76, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[164:167], a[52:55], v76, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[160:163], a[56:59], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[164:167], a[56:59], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[160:163], a[60:63], v64, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[220:223], v[164:167], a[60:63], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[168:171], a[64:67], v76, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[196:199], v[172:175], a[64:67], v76, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[168:171], a[68:71], v76, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[204:207], v[172:175], a[68:71], v76, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[168:171], a[72:75], v64, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[172:175], a[72:75], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[168:171], a[76:79], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[220:223], v[172:175], a[76:79], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[176:179], a[80:83], v76, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[196:199], v[180:183], a[80:83], v76, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[176:179], a[84:87], v76, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[204:207], v[180:183], a[84:87], v76, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[176:179], a[88:91], v64, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[212:215], v[180:183], a[88:91], v64, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[176:179], a[92:95], v64, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[220:223], v[180:183], a[92:95], v64, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[184:187], a[96:99], v76, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[196:199], v[188:191], a[96:99], v76, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[184:187], a[100:103], v76, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[204:207], v[188:191], a[100:103], v76, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[184:187], a[104:107], v64, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[188:191], a[104:107], v64, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[184:187], a[108:111], v64, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[220:223], v[188:191], a[108:111], v64, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[192:195], v70 offset:35712
		ds_read_b128 v[196:199], v70 offset:35776
		ds_read_b128 v[200:203], v70 offset:35968
		ds_read_b128 v[204:207], v70 offset:36032
		ds_read_b128 v[208:211], v70 offset:36224
		ds_read_b128 v[212:215], v70 offset:36288
		ds_read_b128 v[216:219], v70 offset:36480
		ds_read_b128 v[220:223], v70 offset:36544
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v64, 0xff, v89
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v76, 0xff, v90
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v64, v64, v76
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v76, 0xff, v91
		v_lshlrev_b32_e32 v76, 16, v76
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v77, 0xff, v92
		v_lshlrev_b32_e32 v77, 24, v77
		v_or3_b32 v64, v64, v76, v77
		ds_write_b32 v65, v64 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[76:77], v63 offset:5952
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
		buffer_load_ubyte v64, v40, s[72:75], 0 offen
		buffer_load_ubyte v85, v50, s[72:75], 0 offen
		buffer_load_ubyte v125, v52, s[72:75], 0 offen
		buffer_load_ubyte v126, v54, s[72:75], 0 offen
		buffer_load_ubyte v127, v56, s[72:75], 0 offen
		buffer_load_ubyte v224, v58, s[72:75], 0 offen
		buffer_load_ubyte v226, v60, s[72:75], 0 offen
		buffer_load_ubyte v227, v47, s[72:75], 0 offen
		s_add_u32 s44, s10, s41
		s_addc_u32 s45, s11, 0
		s_mov_b32 s76, s44
		s_mov_b32 s77, s45
		s_mov_b32 s78, 0x7fffffff
		s_mov_b32 s79, 0x31016000
		buffer_load_ubyte v228, v68, s[76:79], 0 offen
		buffer_load_ubyte v229, v71, s[76:79], 0 offen
		buffer_load_ubyte v230, v72, s[76:79], 0 offen
		buffer_load_ubyte v231, v73, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[192:195], v[128:131], a[112:115], v76, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[196:199], v[132:135], a[112:115], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[200:203], v[128:131], a[116:119], v76, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[204:207], v[132:135], a[116:119], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v90, v77
		v_mov_b32_e32 v91, v76
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[208:211], v[128:131], a[120:123], v90, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[132:135], a[120:123], v90, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[128:131], a[124:127], v90, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[132:135], a[124:127], v90, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[192:195], v[136:139], a[128:131], v76, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[196:199], v[140:143], a[128:131], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[200:203], v[136:139], a[132:135], v76, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[204:207], v[140:143], a[132:135], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[208:211], v[136:139], a[136:139], v90, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[212:215], v[140:143], a[136:139], v90, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[136:139], a[140:143], v90, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[140:143], a[140:143], v90, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[192:195], v[144:147], a[144:147], v76, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[196:199], v[148:151], a[144:147], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[200:203], v[144:147], a[148:151], v76, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[204:207], v[148:151], a[148:151], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[208:211], v[144:147], a[152:155], v90, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[212:215], v[148:151], a[152:155], v90, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[144:147], a[156:159], v90, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[220:223], v[148:151], a[156:159], v90, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[192:195], v[152:155], a[160:163], v76, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[196:199], v[156:159], a[160:163], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[200:203], v[152:155], a[164:167], v76, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[204:207], v[156:159], a[164:167], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[208:211], v[152:155], a[168:171], v90, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[212:215], v[156:159], a[168:171], v90, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[216:219], v[152:155], a[172:175], v90, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[220:223], v[156:159], a[172:175], v90, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[192:195], v[160:163], a[176:179], v76, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[196:199], v[164:167], a[176:179], v76, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[200:203], v[160:163], a[180:183], v76, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[204:207], v[164:167], a[180:183], v76, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[208:211], v[160:163], a[184:187], v90, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[212:215], v[164:167], a[184:187], v90, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[216:219], v[160:163], a[188:191], v90, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[164:167], a[188:191], v90, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[192:195], v[168:171], a[192:195], v76, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[196:199], v[172:175], a[192:195], v76, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[200:203], v[168:171], a[196:199], v76, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[204:207], v[172:175], a[196:199], v76, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[208:211], v[168:171], a[200:203], v90, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[212:215], v[172:175], a[200:203], v90, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[216:219], v[168:171], a[204:207], v90, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[220:223], v[172:175], a[204:207], v90, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[192:195], v[176:179], a[208:211], v76, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[196:199], v[180:183], a[208:211], v76, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[200:203], v[176:179], a[212:215], v76, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[204:207], v[180:183], a[212:215], v76, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[208:211], v[176:179], a[216:219], v90, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[212:215], v[180:183], a[216:219], v90, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[216:219], v[176:179], a[220:223], v90, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[220:223], v[180:183], a[220:223], v90, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[192:195], v[184:187], a[224:227], v76, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[196:199], v[188:191], a[224:227], v76, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[200:203], v[184:187], a[228:231], v76, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[204:207], v[188:191], a[228:231], v76, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[208:211], v[184:187], a[232:235], v90, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[212:215], v[188:191], a[232:235], v90, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[216:219], v[184:187], v[252:255], v90, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[220:223], v[188:191], v[252:255], v90, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[128:131], v69 offset:33760
		ds_read_b128 v[132:135], v69 offset:33824
		ds_read_b128 v[136:139], v69 offset:34016
		ds_read_b128 v[140:143], v69 offset:34080
		ds_read_b128 v[144:147], v69 offset:34272
		ds_read_b128 v[148:151], v69 offset:34336
		ds_read_b128 v[152:155], v69 offset:34528
		ds_read_b128 v[156:159], v69 offset:34592
		ds_read_b128 v[160:163], v69 offset:50656
		ds_read_b128 v[164:167], v69 offset:50720
		ds_read_b128 v[168:171], v69 offset:50912
		ds_read_b128 v[172:175], v69 offset:50976
		ds_read_b128 v[176:179], v69 offset:51168
		ds_read_b128 v[180:183], v69 offset:51232
		ds_read_b128 v[184:187], v69 offset:51424
		ds_read_b128 v[188:191], v69 offset:51488
		ds_read_b128 v[192:195], v70 offset:18848
		ds_read_b128 v[196:199], v70 offset:18912
		ds_read_b128 v[200:203], v70 offset:19104
		ds_read_b128 v[204:207], v70 offset:19168
		ds_read_b128 v[208:211], v70 offset:19360
		ds_read_b128 v[212:215], v70 offset:19424
		ds_read_b128 v[216:219], v70 offset:19616
		ds_read_b128 v[220:223], v70 offset:19680
		s_waitcnt vmcnt(43)
		v_and_b32_e32 v42, 0xff, v42
		s_waitcnt vmcnt(42)
		v_and_b32_e32 v66, 0xff, v100
		v_lshlrev_b32_e32 v66, 8, v66
		v_or_b32_e32 v42, v42, v66
		s_waitcnt vmcnt(41)
		v_and_b32_e32 v66, 0xff, v102
		v_lshlrev_b32_e32 v66, 16, v66
		s_waitcnt vmcnt(40)
		v_and_b32_e32 v67, 0xff, v103
		v_lshlrev_b32_e32 v67, 24, v67
		v_or3_b32 v74, v42, v66, v67
		s_waitcnt vmcnt(39)
		v_and_b32_e32 v42, 0xff, v110
		s_waitcnt vmcnt(38)
		v_and_b32_e32 v66, 0xff, v111
		v_lshlrev_b32_e32 v66, 8, v66
		v_or_b32_e32 v42, v42, v66
		s_waitcnt vmcnt(37)
		v_and_b32_e32 v66, 0xff, v112
		v_lshlrev_b32_e32 v66, 16, v66
		s_waitcnt vmcnt(36)
		v_and_b32_e32 v67, 0xff, v113
		v_lshlrev_b32_e32 v67, 24, v67
		v_or3_b32 v75, v42, v66, v67
		ds_write_b64 v0, v[74:75] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v42, 0xff, v118
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v66, 0xff, v119
		v_lshlrev_b32_e32 v66, 8, v66
		v_or_b32_e32 v42, v42, v66
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v66, 0xff, v120
		v_lshlrev_b32_e32 v66, 16, v66
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v67, 0xff, v121
		v_lshlrev_b32_e32 v67, 24, v67
		v_or3_b32 v42, v42, v66, v67
		ds_write_b32 v65, v42 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v53 offset:3904
		ds_read_b64_tr_b8 v[74:75], v53 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[76:77], v63 offset:5952
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v78, s[56:59], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v79, s[56:59], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v80, s[56:59], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v81, s[56:59], 0 offen lds
		buffer_load_ubyte v89, v83, s[76:79], 0 offen
		buffer_load_ubyte v90, v86, s[76:79], 0 offen
		buffer_load_ubyte v91, v87, s[76:79], 0 offen
		buffer_load_ubyte v92, v88, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[128:131], v[4:7], v76, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[196:199], v[132:135], v[4:7], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[128:131], a[0:3], v76, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[204:207], v[132:135], a[0:3], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v102, v77
		v_mov_b32_e32 v103, v76
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[128:131], v[240:243], v102, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[212:215], v[132:135], v[240:243], v102, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[128:131], v[244:247], v102, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[220:223], v[132:135], v[244:247], v102, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[136:139], v[248:251], v76, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[196:199], v[140:143], v[248:251], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[136:139], a[4:7], v76, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[204:207], v[140:143], a[4:7], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[136:139], a[8:11], v102, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[212:215], v[140:143], a[8:11], v102, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[136:139], a[12:15], v102, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[220:223], v[140:143], a[12:15], v102, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v232, v67
		v_mov_b32_e32 v233, v66
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[144:147], a[16:19], v76, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[196:199], v[148:151], a[16:19], v76, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[144:147], a[20:23], v76, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[204:207], v[148:151], a[20:23], v76, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[144:147], a[24:27], v102, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[212:215], v[148:151], a[24:27], v102, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[144:147], a[28:31], v102, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[220:223], v[148:151], a[28:31], v102, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[152:155], a[32:35], v76, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[196:199], v[156:159], a[32:35], v76, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[152:155], a[36:39], v76, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[156:159], a[36:39], v76, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[152:155], a[40:43], v102, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[212:215], v[156:159], a[40:43], v102, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[152:155], a[44:47], v102, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[220:223], v[156:159], a[44:47], v102, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[160:163], a[48:51], v76, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[196:199], v[164:167], a[48:51], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[160:163], a[52:55], v76, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[164:167], a[52:55], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[160:163], a[56:59], v102, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[164:167], a[56:59], v102, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[160:163], a[60:63], v102, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[220:223], v[164:167], a[60:63], v102, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[168:171], a[64:67], v76, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[196:199], v[172:175], a[64:67], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[168:171], a[68:71], v76, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[204:207], v[172:175], a[68:71], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[168:171], a[72:75], v102, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[172:175], a[72:75], v102, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[168:171], a[76:79], v102, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[220:223], v[172:175], a[76:79], v102, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v234, v75
		v_mov_b32_e32 v235, v74
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[176:179], a[80:83], v76, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[196:199], v[180:183], a[80:83], v76, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[176:179], a[84:87], v76, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[204:207], v[180:183], a[84:87], v76, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[176:179], a[88:91], v102, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[212:215], v[180:183], a[88:91], v102, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[176:179], a[92:95], v102, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[220:223], v[180:183], a[92:95], v102, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[184:187], a[96:99], v76, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[196:199], v[188:191], a[96:99], v76, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[184:187], a[100:103], v76, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[204:207], v[188:191], a[100:103], v76, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[184:187], a[104:107], v102, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[188:191], a[104:107], v102, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[184:187], a[108:111], v102, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[220:223], v[188:191], a[108:111], v102, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[192:195], v70 offset:52576
		ds_read_b128 v[196:199], v70 offset:52640
		ds_read_b128 v[200:203], v70 offset:52832
		ds_read_b128 v[204:207], v70 offset:52896
		ds_read_b128 v[208:211], v70 offset:53088
		ds_read_b128 v[212:215], v70 offset:53152
		ds_read_b128 v[216:219], v70 offset:53344
		ds_read_b128 v[220:223], v70 offset:53408
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v32, 0xff, v32
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v34, 0xff, v34
		v_lshlrev_b32_e32 v34, 8, v34
		v_or_b32_e32 v32, v32, v34
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v34, 0xff, v35
		v_lshlrev_b32_e32 v34, 16, v34
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v35, 0xff, v36
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v32, v32, v34, v35
		ds_write_b32 v65, v32 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[34:35], v63 offset:5952
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v93, s[52:55], 0 offen lds
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v94, s[52:55], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v95, s[52:55], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v96, s[52:55], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v97, s[52:55], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v98, s[52:55], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v99, s[52:55], 0 offen lds
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
		buffer_load_ubyte v42, v101, s[72:75], 0 offen
		buffer_load_ubyte v100, v104, s[72:75], 0 offen
		buffer_load_ubyte v102, v105, s[72:75], 0 offen
		buffer_load_ubyte v103, v106, s[72:75], 0 offen
		buffer_load_ubyte v110, v107, s[72:75], 0 offen
		buffer_load_ubyte v111, v108, s[72:75], 0 offen
		buffer_load_ubyte v112, v109, s[72:75], 0 offen
		buffer_load_ubyte v113, v41, s[72:75], 0 offen
		buffer_load_ubyte v118, v114, s[76:79], 0 offen
		buffer_load_ubyte v119, v115, s[76:79], 0 offen
		buffer_load_ubyte v120, v116, s[76:79], 0 offen
		buffer_load_ubyte v121, v117, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[192:195], v[128:131], a[112:115], v34, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[196:199], v[132:135], a[112:115], v34, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[200:203], v[128:131], a[116:119], v34, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[204:207], v[132:135], a[116:119], v34, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v76, v35
		v_mov_b32_e32 v77, v34
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[208:211], v[128:131], a[120:123], v76, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[132:135], a[120:123], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[128:131], a[124:127], v76, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[132:135], a[124:127], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[192:195], v[136:139], a[128:131], v34, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[196:199], v[140:143], a[128:131], v34, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[200:203], v[136:139], a[132:135], v34, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[204:207], v[140:143], a[132:135], v34, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[208:211], v[136:139], a[136:139], v76, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[212:215], v[140:143], a[136:139], v76, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[136:139], a[140:143], v76, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[140:143], a[140:143], v76, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[192:195], v[144:147], a[144:147], v34, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[196:199], v[148:151], a[144:147], v34, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[200:203], v[144:147], a[148:151], v34, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[204:207], v[148:151], a[148:151], v34, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[208:211], v[144:147], a[152:155], v76, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[212:215], v[148:151], a[152:155], v76, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[144:147], a[156:159], v76, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[220:223], v[148:151], a[156:159], v76, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[192:195], v[152:155], a[160:163], v34, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[196:199], v[156:159], a[160:163], v34, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[200:203], v[152:155], a[164:167], v34, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[204:207], v[156:159], a[164:167], v34, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[208:211], v[152:155], a[168:171], v76, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[212:215], v[156:159], a[168:171], v76, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[216:219], v[152:155], a[172:175], v76, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[220:223], v[156:159], a[172:175], v76, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[192:195], v[160:163], a[176:179], v34, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[196:199], v[164:167], a[176:179], v34, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[200:203], v[160:163], a[180:183], v34, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[204:207], v[164:167], a[180:183], v34, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[208:211], v[160:163], a[184:187], v76, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[212:215], v[164:167], a[184:187], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[216:219], v[160:163], a[188:191], v76, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[164:167], a[188:191], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[192:195], v[168:171], a[192:195], v34, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[196:199], v[172:175], a[192:195], v34, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[200:203], v[168:171], a[196:199], v34, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[204:207], v[172:175], a[196:199], v34, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[208:211], v[168:171], a[200:203], v76, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[212:215], v[172:175], a[200:203], v76, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[216:219], v[168:171], a[204:207], v76, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[220:223], v[172:175], a[204:207], v76, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[192:195], v[176:179], a[208:211], v34, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[196:199], v[180:183], a[208:211], v34, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[200:203], v[176:179], a[212:215], v34, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[204:207], v[180:183], a[212:215], v34, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[208:211], v[176:179], a[216:219], v76, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[212:215], v[180:183], a[216:219], v76, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[216:219], v[176:179], a[220:223], v76, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[220:223], v[180:183], a[220:223], v76, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[192:195], v[184:187], a[224:227], v34, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[196:199], v[188:191], a[224:227], v34, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[200:203], v[184:187], a[228:231], v34, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[204:207], v[188:191], a[228:231], v34, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[208:211], v[184:187], a[232:235], v76, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[212:215], v[188:191], a[232:235], v76, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[216:219], v[184:187], v[252:255], v76, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[220:223], v[188:191], v[252:255], v76, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[128:131], v69
		ds_read_b128 v[132:135], v69 offset:64
		ds_read_b128 v[136:139], v69 offset:256
		ds_read_b128 v[140:143], v69 offset:320
		ds_read_b128 v[144:147], v69 offset:512
		ds_read_b128 v[148:151], v69 offset:576
		ds_read_b128 v[152:155], v69 offset:768
		ds_read_b128 v[156:159], v69 offset:832
		ds_read_b128 v[160:163], v69 offset:16896
		ds_read_b128 v[164:167], v69 offset:16960
		ds_read_b128 v[168:171], v69 offset:17152
		ds_read_b128 v[172:175], v69 offset:17216
		ds_read_b128 v[176:179], v69 offset:17408
		ds_read_b128 v[180:183], v69 offset:17472
		ds_read_b128 v[184:187], v69 offset:17664
		ds_read_b128 v[188:191], v69 offset:17728
		ds_read_b128 v[192:195], v70 offset:1984
		ds_read_b128 v[196:199], v70 offset:2048
		ds_read_b128 v[200:203], v70 offset:2240
		ds_read_b128 v[204:207], v70 offset:2304
		ds_read_b128 v[208:211], v70 offset:2496
		ds_read_b128 v[212:215], v70 offset:2560
		ds_read_b128 v[216:219], v70 offset:2752
		ds_read_b128 v[220:223], v70 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v84, v64 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v82, v85 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v61, v125 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v62, v126 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v55, v127 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v57, v224 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v59, v226 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v46, v227 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v15, v228 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v48, v229 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v51, v230 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v49, v231 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[34:35], v53 offset:3904
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v74, 0xff, v34
		v_lshrrev_b32_e32 v32, 8, v34
		v_and_b32_e32 v76, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v34
		v_and_b32_e32 v77, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v34
		v_and_b32_e32 v75, 0xff, v32
		v_and_b32_e32 v66, 0xff, v35
		v_lshrrev_b32_e32 v32, 8, v35
		v_and_b32_e32 v126, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v35
		v_and_b32_e32 v127, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v35
		v_and_b32_e32 v85, 0xff, v32
		ds_read_b64_tr_b8 v[34:35], v53 offset:4032
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v67, 0xff, v34
		v_lshrrev_b32_e32 v32, 8, v34
		v_and_b32_e32 v227, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v34
		v_and_b32_e32 v228, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v34
		v_and_b32_e32 v226, 0xff, v32
		v_and_b32_e32 v224, 0xff, v35
		v_lshrrev_b32_e32 v32, 8, v35
		v_and_b32_e32 v230, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v35
		v_and_b32_e32 v231, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v35
		v_and_b32_e32 v229, 0xff, v32
		ds_read_b64_tr_b8 v[34:35], v63 offset:5952
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v125, 0xff, v34
		v_lshrrev_b32_e32 v32, 8, v34
		v_and_b32_e32 v233, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v34
		v_and_b32_e32 v234, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v34
		v_and_b32_e32 v232, 0xff, v32
		v_and_b32_e32 v64, 0xff, v35
		v_lshrrev_b32_e32 v32, 8, v35
		v_and_b32_e32 v236, 0xff, v32
		v_lshrrev_b32_e32 v32, 16, v35
		v_and_b32_e32 v237, 0xff, v32
		v_lshrrev_b32_e32 v32, 24, v35
		s_mov_b32 m0, s1
		v_and_b32_e32 v235, 0xff, v32
		buffer_load_dwordx4 v122, s[56:59], 0 offen lds
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v123, s[56:59], 0 offen lds
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v124, s[56:59], 0 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v19, s[56:59], 0 offen lds
		buffer_load_ubyte v32, v21, s[76:79], 0 offen
		buffer_load_ubyte v34, v23, s[76:79], 0 offen
		buffer_load_ubyte v35, v31, s[76:79], 0 offen
		buffer_load_ubyte v36, v10, s[76:79], 0 offen
		s_add_i32 s19, s19, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s20, s20, 16
		s_add_i32 s41, s41, 16
		s_add_i32 s21, s21, 2
		s_cmp_lt_i32 s21, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		v_and_b32_e32 v2, 0xff, v74
		v_and_b32_e32 v8, 0xff, v76
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v77
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v75
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v2, v2, v8, v9
		v_and_b32_e32 v8, 0xff, v66
		v_and_b32_e32 v9, 0xff, v126
		v_lshlrev_b32_e32 v9, 8, v9
		v_or_b32_e32 v8, v8, v9
		v_and_b32_e32 v9, 0xff, v127
		v_lshlrev_b32_e32 v9, 16, v9
		v_and_b32_e32 v10, 0xff, v85
		v_lshlrev_b32_e32 v10, 24, v10
		v_or3_b32 v8, v8, v9, v10
		v_and_b32_e32 v9, 0xff, v67
		v_and_b32_e32 v10, 0xff, v227
		v_lshlrev_b32_e32 v10, 8, v10
		v_or_b32_e32 v9, v9, v10
		v_and_b32_e32 v10, 0xff, v228
		v_lshlrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v12, 0xff, v226
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v9, v9, v10, v12
		v_and_b32_e32 v10, 0xff, v224
		v_and_b32_e32 v12, 0xff, v230
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v10, v10, v12
		v_and_b32_e32 v12, 0xff, v231
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v14, 0xff, v229
		v_lshlrev_b32_e32 v14, 24, v14
		v_or3_b32 v10, v10, v12, v14
		v_and_b32_e32 v12, 0xff, v125
		v_and_b32_e32 v14, 0xff, v233
		v_lshlrev_b32_e32 v14, 8, v14
		v_or_b32_e32 v12, v12, v14
		v_and_b32_e32 v14, 0xff, v234
		v_lshlrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v15, 0xff, v232
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v12, v12, v14, v15
		v_and_b32_e32 v14, 0xff, v64
		v_and_b32_e32 v15, 0xff, v236
		v_lshlrev_b32_e32 v15, 8, v15
		v_or_b32_e32 v14, v14, v15
		v_and_b32_e32 v15, 0xff, v237
		v_lshlrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v17, 0xff, v235
		v_lshlrev_b32_e32 v17, 24, v17
		v_or3_b32 v14, v14, v15, v17
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[128:131], v[4:7], v12, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[196:199], v[132:135], v[4:7], v12, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[128:131], a[0:3], v12, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[204:207], v[132:135], a[0:3], v12, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[128:131], v[240:243], v14, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[212:215], v[132:135], v[240:243], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[128:131], v[244:247], v14, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[220:223], v[132:135], v[244:247], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[136:139], v[248:251], v12, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[196:199], v[140:143], v[248:251], v12, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[136:139], a[4:7], v12, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[204:207], v[140:143], a[4:7], v12, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[136:139], a[8:11], v14, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[212:215], v[140:143], a[8:11], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[136:139], a[12:15], v14, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[220:223], v[140:143], a[12:15], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[144:147], a[16:19], v12, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[196:199], v[148:151], a[16:19], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[144:147], a[20:23], v12, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[204:207], v[148:151], a[20:23], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[144:147], a[24:27], v14, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[212:215], v[148:151], a[24:27], v14, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[144:147], a[28:31], v14, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[220:223], v[148:151], a[28:31], v14, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[152:155], a[32:35], v12, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[196:199], v[156:159], a[32:35], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[152:155], a[36:39], v12, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[156:159], a[36:39], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[152:155], a[40:43], v14, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[212:215], v[156:159], a[40:43], v14, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[152:155], a[44:47], v14, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[220:223], v[156:159], a[44:47], v14, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[160:163], a[48:51], v12, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[196:199], v[164:167], a[48:51], v12, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[160:163], a[52:55], v12, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[164:167], a[52:55], v12, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[160:163], a[56:59], v14, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[164:167], a[56:59], v14, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[160:163], a[60:63], v14, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[220:223], v[164:167], a[60:63], v14, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[168:171], a[64:67], v12, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[196:199], v[172:175], a[64:67], v12, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[168:171], a[68:71], v12, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[204:207], v[172:175], a[68:71], v12, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[168:171], a[72:75], v14, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[172:175], a[72:75], v14, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[168:171], a[76:79], v14, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[220:223], v[172:175], a[76:79], v14, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[176:179], a[80:83], v12, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[196:199], v[180:183], a[80:83], v12, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[176:179], a[84:87], v12, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[204:207], v[180:183], a[84:87], v12, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[176:179], a[88:91], v14, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[212:215], v[180:183], a[88:91], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[176:179], a[92:95], v14, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[220:223], v[180:183], a[92:95], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[184:187], a[96:99], v12, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[196:199], v[188:191], a[96:99], v12, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[184:187], a[100:103], v12, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[204:207], v[188:191], a[100:103], v12, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[184:187], a[104:107], v14, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[188:191], a[104:107], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[184:187], a[108:111], v14, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[220:223], v[188:191], a[108:111], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[24:27], v70 offset:35712
		ds_read_b128 v[28:31], v70 offset:35776
		ds_read_b128 v[48:51], v70 offset:35968
		ds_read_b128 v[56:59], v70 offset:36032
		ds_read_b128 v[72:75], v70 offset:36224
		ds_read_b128 v[76:79], v70 offset:36288
		ds_read_b128 v[80:83], v70 offset:36480
		ds_read_b128 v[84:87], v70 offset:36544
		v_and_b32_e32 v12, 0xff, v89
		v_and_b32_e32 v14, 0xff, v90
		v_lshlrev_b32_e32 v14, 8, v14
		v_or_b32_e32 v12, v12, v14
		v_and_b32_e32 v14, 0xff, v91
		v_lshlrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v15, 0xff, v92
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v12, v12, v14, v15
		ds_write_b32 v65, v12 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v63 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[128:131], a[112:115], v14, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[132:135], a[112:115], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], v[128:131], a[116:119], v14, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], v[132:135], a[116:119], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v38, v15
		v_mov_b32_e32 v39, v14
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[72:75], v[128:131], a[120:123], v38, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], v[132:135], a[120:123], v38, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[128:131], a[124:127], v38, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[84:87], v[132:135], a[124:127], v38, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[136:139], a[128:131], v14, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[140:143], a[128:131], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[136:139], a[132:135], v14, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], v[140:143], a[132:135], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[72:75], v[136:139], a[136:139], v38, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[140:143], a[136:139], v38, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[136:139], a[140:143], v38, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[84:87], v[140:143], a[140:143], v38, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[144:147], a[144:147], v14, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[148:151], a[144:147], v14, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[144:147], a[148:151], v14, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], v[148:151], a[148:151], v14, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[72:75], v[144:147], a[152:155], v38, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], v[148:151], a[152:155], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], v[144:147], a[156:159], v38, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[148:151], a[156:159], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], v[152:155], a[160:163], v14, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[156:159], a[160:163], v14, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[152:155], a[164:167], v14, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], v[156:159], a[164:167], v14, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[72:75], v[152:155], a[168:171], v38, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[76:79], v[156:159], a[168:171], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[152:155], a[172:175], v38, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[156:159], a[172:175], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[24:27], v[160:163], a[176:179], v14, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[164:167], a[176:179], v14, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], v[160:163], a[180:183], v14, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[56:59], v[164:167], a[180:183], v14, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[72:75], v[160:163], a[184:187], v38, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[76:79], v[164:167], a[184:187], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[80:83], v[160:163], a[188:191], v38, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[84:87], v[164:167], a[188:191], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[24:27], v[168:171], a[192:195], v14, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], v[172:175], a[192:195], v14, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[48:51], v[168:171], a[196:199], v14, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], v[172:175], a[196:199], v14, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[72:75], v[168:171], a[200:203], v38, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[76:79], v[172:175], a[200:203], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[80:83], v[168:171], a[204:207], v38, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[84:87], v[172:175], a[204:207], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[24:27], v[176:179], a[208:211], v14, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], v[180:183], a[208:211], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[48:51], v[176:179], a[212:215], v14, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], v[180:183], a[212:215], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[72:75], v[176:179], a[216:219], v38, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[76:79], v[180:183], a[216:219], v38, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[80:83], v[176:179], a[220:223], v38, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[84:87], v[180:183], a[220:223], v38, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[24:27], v[184:187], a[224:227], v14, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[28:31], v[188:191], a[224:227], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[48:51], v[184:187], a[228:231], v14, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[56:59], v[188:191], a[228:231], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[72:75], v[184:187], a[232:235], v38, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[76:79], v[188:191], a[232:235], v38, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[80:83], v[184:187], v[252:255], v38, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[84:87], v[188:191], v[252:255], v38, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v69 offset:33760
		ds_read_b128 v[28:31], v69 offset:33824
		ds_read_b128 v[48:51], v69 offset:34016
		ds_read_b128 v[56:59], v69 offset:34080
		ds_read_b128 v[72:75], v69 offset:34272
		ds_read_b128 v[76:79], v69 offset:34336
		ds_read_b128 v[80:83], v69 offset:34528
		ds_read_b128 v[84:87], v69 offset:34592
		ds_read_b128 v[88:91], v69 offset:50656
		ds_read_b128 v[92:95], v69 offset:50720
		ds_read_b128 v[96:99], v69 offset:50912
		ds_read_b128 v[104:107], v69 offset:50976
		ds_read_b128 v[124:127], v69 offset:51168
		ds_read_b128 v[128:131], v69 offset:51232
		ds_read_b128 v[132:135], v69 offset:51424
		ds_read_b128 v[136:139], v69 offset:51488
		ds_read_b128 v[140:143], v70 offset:18848
		ds_read_b128 v[144:147], v70 offset:18912
		ds_read_b128 v[148:151], v70 offset:19104
		ds_read_b128 v[152:155], v70 offset:19168
		ds_read_b128 v[156:159], v70 offset:19360
		ds_read_b128 v[160:163], v70 offset:19424
		ds_read_b128 v[164:167], v70 offset:19616
		ds_read_b128 v[168:171], v70 offset:19680
		v_and_b32_e32 v2, 0xff, v42
		v_and_b32_e32 v8, 0xff, v100
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v102
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v103
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v14, v2, v8, v9
		v_and_b32_e32 v2, 0xff, v110
		v_and_b32_e32 v8, 0xff, v111
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v112
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v113
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v15, v2, v8, v9
		ds_write_b64 v0, v[14:15] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v0, 0xff, v118
		v_and_b32_e32 v2, 0xff, v119
		v_lshlrev_b32_e32 v2, 8, v2
		v_or_b32_e32 v0, v0, v2
		v_and_b32_e32 v2, 0xff, v120
		v_lshlrev_b32_e32 v2, 16, v2
		v_and_b32_e32 v8, 0xff, v121
		v_lshlrev_b32_e32 v8, 24, v8
		v_or3_b32 v0, v0, v2, v8
		ds_write_b32 v65, v0 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v53 offset:3904
		ds_read_b64_tr_b8 v[14:15], v53 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[38:39], v63 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[140:143], v[24:27], v[4:7], v38, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[144:147], v[28:31], v[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[148:151], v[24:27], a[0:3], v38, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[152:155], v[28:31], a[0:3], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v40, v39
		v_mov_b32_e32 v41, v38
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[156:159], v[24:27], v[240:243], v40, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[160:163], v[28:31], v[240:243], v40, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[164:167], v[24:27], v[244:247], v40, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[168:171], v[28:31], v[244:247], v40, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[140:143], v[48:51], v[248:251], v38, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[144:147], v[56:59], v[248:251], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[148:151], v[48:51], a[4:7], v38, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[152:155], v[56:59], a[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[156:159], v[48:51], a[8:11], v40, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[160:163], v[56:59], a[8:11], v40, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[164:167], v[48:51], a[12:15], v40, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[168:171], v[56:59], a[12:15], v40, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v46, v9
		v_mov_b32_e32 v47, v8
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[140:143], v[72:75], a[16:19], v38, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[144:147], v[76:79], a[16:19], v38, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[148:151], v[72:75], a[20:23], v38, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[152:155], v[76:79], a[20:23], v38, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[156:159], v[72:75], a[24:27], v40, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[160:163], v[76:79], a[24:27], v40, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[164:167], v[72:75], a[28:31], v40, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[168:171], v[76:79], a[28:31], v40, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[140:143], v[80:83], a[32:35], v38, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[144:147], v[84:87], a[32:35], v38, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[148:151], v[80:83], a[36:39], v38, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[152:155], v[84:87], a[36:39], v38, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[156:159], v[80:83], a[40:43], v40, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[160:163], v[84:87], a[40:43], v40, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[164:167], v[80:83], a[44:47], v40, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[168:171], v[84:87], a[44:47], v40, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[140:143], v[88:91], a[48:51], v38, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[144:147], v[92:95], a[48:51], v38, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[148:151], v[88:91], a[52:55], v38, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[152:155], v[92:95], a[52:55], v38, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[156:159], v[88:91], a[56:59], v40, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[160:163], v[92:95], a[56:59], v40, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[164:167], v[88:91], a[60:63], v40, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[168:171], v[92:95], a[60:63], v40, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[140:143], v[96:99], a[64:67], v38, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[144:147], v[104:107], a[64:67], v38, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[148:151], v[96:99], a[68:71], v38, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[152:155], v[104:107], a[68:71], v38, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[156:159], v[96:99], a[72:75], v40, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[160:163], v[104:107], a[72:75], v40, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[164:167], v[96:99], a[76:79], v40, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[168:171], v[104:107], a[76:79], v40, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v52, v15
		v_mov_b32_e32 v53, v14
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[140:143], v[124:127], a[80:83], v38, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[144:147], v[128:131], a[80:83], v38, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[148:151], v[124:127], a[84:87], v38, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[152:155], v[128:131], a[84:87], v38, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[156:159], v[124:127], a[88:91], v40, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[160:163], v[128:131], a[88:91], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[164:167], v[124:127], a[92:95], v40, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[168:171], v[128:131], a[92:95], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[140:143], v[132:135], a[96:99], v38, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[144:147], v[136:139], a[96:99], v38, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[148:151], v[132:135], a[100:103], v38, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[152:155], v[136:139], a[100:103], v38, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[156:159], v[132:135], a[104:107], v40, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[160:163], v[136:139], a[104:107], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[164:167], v[132:135], a[108:111], v40, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[168:171], v[136:139], a[108:111], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v70 offset:52576
		ds_read_b128 v[108:111], v70 offset:52640
		ds_read_b128 v[112:115], v70 offset:52832
		ds_read_b128 v[116:119], v70 offset:52896
		ds_read_b128 v[120:123], v70 offset:53088
		ds_read_b128 v[140:143], v70 offset:53152
		ds_read_b128 v[144:147], v70 offset:53344
		ds_read_b128 v[148:151], v70 offset:53408
		s_waitcnt vmcnt(3)
		v_and_b32_e32 v0, 0xff, v32
		s_waitcnt vmcnt(2)
		v_and_b32_e32 v2, 0xff, v34
		v_lshlrev_b32_e32 v2, 8, v2
		v_or_b32_e32 v0, v0, v2
		s_waitcnt vmcnt(1)
		v_and_b32_e32 v2, 0xff, v35
		v_lshlrev_b32_e32 v2, 16, v2
		s_waitcnt vmcnt(0)
		v_and_b32_e32 v9, 0xff, v36
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v0, v0, v2, v9
		ds_write_b32 v65, v0 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[32:33], v63 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v34, v4, v5
		v_cvt_pk_bf16_f32 v35, v6, v7
		v_accvgpr_read_b32 v0, a0
		v_accvgpr_read_b32 v2, a1
		v_cvt_pk_bf16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a2
		v_accvgpr_read_b32 v2, a3
		v_cvt_pk_bf16_f32 v5, v0, v2
		v_cvt_pk_bf16_f32 v6, v240, v241
		v_cvt_pk_bf16_f32 v7, v242, v243
		v_cvt_pk_bf16_f32 v36, v244, v245
		v_cvt_pk_bf16_f32 v37, v246, v247
		v_cvt_pk_bf16_f32 v38, v248, v249
		v_cvt_pk_bf16_f32 v39, v250, v251
		v_accvgpr_read_b32 v0, a4
		v_accvgpr_read_b32 v2, a5
		v_cvt_pk_bf16_f32 v40, v0, v2
		v_accvgpr_read_b32 v0, a6
		v_accvgpr_read_b32 v2, a7
		v_cvt_pk_bf16_f32 v41, v0, v2
		v_accvgpr_read_b32 v0, a8
		v_accvgpr_read_b32 v2, a9
		v_cvt_pk_bf16_f32 v54, v0, v2
		v_accvgpr_read_b32 v0, a10
		v_accvgpr_read_b32 v2, a11
		v_cvt_pk_bf16_f32 v55, v0, v2
		v_accvgpr_read_b32 v0, a12
		v_accvgpr_read_b32 v2, a13
		v_cvt_pk_bf16_f32 v60, v0, v2
		v_accvgpr_read_b32 v0, a14
		v_accvgpr_read_b32 v2, a15
		v_cvt_pk_bf16_f32 v61, v0, v2
		v_accvgpr_read_b32 v0, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_bf16_f32 v62, v0, v2
		v_accvgpr_read_b32 v0, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_bf16_f32 v63, v0, v2
		v_accvgpr_read_b32 v0, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_bf16_f32 v64, v0, v2
		v_accvgpr_read_b32 v0, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_bf16_f32 v65, v0, v2
		v_accvgpr_read_b32 v0, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_bf16_f32 v66, v0, v2
		v_accvgpr_read_b32 v0, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_bf16_f32 v67, v0, v2
		v_accvgpr_read_b32 v0, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_bf16_f32 v68, v0, v2
		v_accvgpr_read_b32 v0, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_bf16_f32 v69, v0, v2
		v_accvgpr_read_b32 v0, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_bf16_f32 v70, v0, v2
		v_accvgpr_read_b32 v0, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_bf16_f32 v71, v0, v2
		v_accvgpr_read_b32 v0, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_bf16_f32 v152, v0, v2
		v_accvgpr_read_b32 v0, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_bf16_f32 v153, v0, v2
		v_accvgpr_read_b32 v0, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_bf16_f32 v154, v0, v2
		v_accvgpr_read_b32 v0, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_bf16_f32 v155, v0, v2
		v_accvgpr_read_b32 v0, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_bf16_f32 v156, v0, v2
		v_accvgpr_read_b32 v0, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_bf16_f32 v157, v0, v2
		v_accvgpr_read_b32 v0, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_bf16_f32 v158, v0, v2
		v_accvgpr_read_b32 v0, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_bf16_f32 v159, v0, v2
		v_accvgpr_read_b32 v0, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_bf16_f32 v160, v0, v2
		v_accvgpr_read_b32 v0, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_bf16_f32 v161, v0, v2
		v_accvgpr_read_b32 v0, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_bf16_f32 v162, v0, v2
		v_accvgpr_read_b32 v0, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_bf16_f32 v163, v0, v2
		v_accvgpr_read_b32 v0, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_bf16_f32 v164, v0, v2
		v_accvgpr_read_b32 v0, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_bf16_f32 v165, v0, v2
		v_accvgpr_read_b32 v0, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_bf16_f32 v166, v0, v2
		v_accvgpr_read_b32 v0, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_bf16_f32 v167, v0, v2
		v_accvgpr_read_b32 v0, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_bf16_f32 v168, v0, v2
		v_accvgpr_read_b32 v0, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_bf16_f32 v169, v0, v2
		v_accvgpr_read_b32 v0, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_bf16_f32 v170, v0, v2
		v_accvgpr_read_b32 v0, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_bf16_f32 v171, v0, v2
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_bf16_f32 v172, v0, v2
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_bf16_f32 v173, v0, v2
		v_accvgpr_read_b32 v0, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_bf16_f32 v174, v0, v2
		v_accvgpr_read_b32 v0, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_bf16_f32 v175, v0, v2
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_bf16_f32 v176, v0, v2
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_bf16_f32 v177, v0, v2
		v_accvgpr_read_b32 v0, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_bf16_f32 v178, v0, v2
		v_accvgpr_read_b32 v0, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_bf16_f32 v179, v0, v2
		v_accvgpr_read_b32 v0, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_bf16_f32 v180, v0, v2
		v_accvgpr_read_b32 v0, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_bf16_f32 v181, v0, v2
		v_accvgpr_read_b32 v0, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_bf16_f32 v182, v0, v2
		v_accvgpr_read_b32 v0, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_bf16_f32 v183, v0, v2
		v_accvgpr_read_b32 v0, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_bf16_f32 v184, v0, v2
		v_accvgpr_read_b32 v0, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_bf16_f32 v185, v0, v2
		v_accvgpr_read_b32 v0, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_bf16_f32 v186, v0, v2
		v_accvgpr_read_b32 v0, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_bf16_f32 v187, v0, v2
		v_accvgpr_read_b32 v0, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_bf16_f32 v188, v0, v2
		v_accvgpr_read_b32 v0, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_bf16_f32 v189, v0, v2
		s_lshl_b32 s1, s1, 1
		s_add_u32 s2, s6, s1
		s_addc_u32 s3, s7, 0
		s_mov_b32 s4, s2
		s_mov_b32 s5, s3
		s_mov_b32 s6, 0x7fffffff
		s_mov_b32 s7, 0x31016000
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v0, s17, v1
		v_lshl_add_u32 v1, v0, 5, s0
		v_mul_lo_u32 v2, s17, v18
		v_lshlrev_b32_e32 v2, 1, v2
		v_mul_lo_u32 v9, s17, v16
		v_lshlrev_b32_e32 v9, 4, v9
		v_add3_u32 v1, v1, v2, v9
		v_mul_lo_u32 v10, s17, v20
		v_lshlrev_b32_e32 v10, 3, v10
		v_mul_lo_u32 v12, s17, v22
		v_lshlrev_b32_e32 v12, 2, v12
		v_add3_u32 v1, v1, v10, v12
		v_lshl_add_u32 v15, v3, 5, v1
		v_lshlrev_b32_e32 v17, 4, v11
		v_lshlrev_b32_e32 v19, 3, v13
		v_add3_u32 v15, v15, v17, v19
		buffer_store_dwordx2 v[34:35], v15, s[4:7], 0 offen
		v_lshlrev_b32_e32 v13, 2, v13
		v_add_u32_e32 v15, 32, v13
		v_lshlrev_b32_e32 v11, 3, v11
		v_xor_b32_e32 v15, v15, v11
		v_xor_b32_e32 v15, v225, v15
		v_lshl_add_u32 v20, v15, 1, v1
		buffer_store_dwordx2 v[4:5], v20, s[4:7], 0 offen
		v_add_u32_e32 v4, 64, v13
		v_xor_b32_e32 v4, v4, v11
		v_xor_b32_e32 v4, v225, v4
		v_lshl_add_u32 v5, v4, 1, v1
		buffer_store_dwordx2 v[6:7], v5, s[4:7], 0 offen
		v_add_u32_e32 v5, 0x60, v13
		v_xor_b32_e32 v5, v5, v11
		v_xor_b32_e32 v5, v225, v5
		v_lshl_add_u32 v1, v5, 1, v1
		buffer_store_dwordx2 v[36:37], v1, s[4:7], 0 offen
		v_lshlrev_b32_e32 v1, 3, v16
		v_add_u32_e32 v6, 32, v18
		v_xor_b32_e32 v6, v6, v44
		v_xor_b32_e32 v6, v43, v6
		v_xor_b32_e32 v6, v1, v6
		v_xor_b32_e32 v6, v45, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshl_add_u32 v7, v6, 1, s0
		v_lshl_add_u32 v11, v3, 5, v7
		v_add3_u32 v11, v11, v17, v19
		buffer_store_dwordx2 v[38:39], v11, s[4:7], 0 offen
		v_lshl_add_u32 v11, v15, 1, v7
		buffer_store_dwordx2 v[40:41], v11, s[4:7], 0 offen
		v_lshl_add_u32 v11, v4, 1, v7
		buffer_store_dwordx2 v[54:55], v11, s[4:7], 0 offen
		v_lshl_add_u32 v7, v5, 1, v7
		buffer_store_dwordx2 v[60:61], v7, s[4:7], 0 offen
		v_add_u32_e32 v7, 64, v18
		v_xor_b32_e32 v7, v7, v44
		v_xor_b32_e32 v7, v43, v7
		v_xor_b32_e32 v7, v1, v7
		v_xor_b32_e32 v7, v45, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshl_add_u32 v11, v7, 1, s0
		v_lshl_add_u32 v13, v3, 5, v11
		v_add3_u32 v13, v13, v17, v19
		buffer_store_dwordx2 v[62:63], v13, s[4:7], 0 offen
		v_lshl_add_u32 v13, v15, 1, v11
		buffer_store_dwordx2 v[64:65], v13, s[4:7], 0 offen
		v_lshl_add_u32 v13, v4, 1, v11
		buffer_store_dwordx2 v[66:67], v13, s[4:7], 0 offen
		v_lshl_add_u32 v11, v5, 1, v11
		buffer_store_dwordx2 v[68:69], v11, s[4:7], 0 offen
		v_add_u32_e32 v11, 0x60, v18
		v_xor_b32_e32 v11, v11, v44
		v_xor_b32_e32 v11, v43, v11
		v_xor_b32_e32 v11, v1, v11
		v_xor_b32_e32 v11, v45, v11
		v_mul_lo_u32 v11, s17, v11
		v_lshl_add_u32 v13, v11, 1, s0
		v_lshl_add_u32 v16, v3, 5, v13
		v_add3_u32 v16, v16, v17, v19
		buffer_store_dwordx2 v[70:71], v16, s[4:7], 0 offen
		v_lshl_add_u32 v16, v15, 1, v13
		buffer_store_dwordx2 v[152:153], v16, s[4:7], 0 offen
		v_lshl_add_u32 v16, v4, 1, v13
		buffer_store_dwordx2 v[154:155], v16, s[4:7], 0 offen
		v_lshl_add_u32 v13, v5, 1, v13
		buffer_store_dwordx2 v[156:157], v13, s[4:7], 0 offen
		v_add_u32_e32 v13, 0x80, v18
		v_xor_b32_e32 v13, v13, v44
		v_xor_b32_e32 v13, v43, v13
		v_xor_b32_e32 v13, v1, v13
		v_xor_b32_e32 v13, v45, v13
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v16, v13, 1, s0
		v_lshl_add_u32 v20, v3, 5, v16
		v_add3_u32 v20, v20, v17, v19
		buffer_store_dwordx2 v[158:159], v20, s[4:7], 0 offen
		v_lshl_add_u32 v20, v15, 1, v16
		buffer_store_dwordx2 v[160:161], v20, s[4:7], 0 offen
		v_lshl_add_u32 v20, v4, 1, v16
		buffer_store_dwordx2 v[162:163], v20, s[4:7], 0 offen
		v_lshl_add_u32 v16, v5, 1, v16
		buffer_store_dwordx2 v[164:165], v16, s[4:7], 0 offen
		v_add_u32_e32 v16, 0xa0, v18
		v_xor_b32_e32 v16, v16, v44
		v_xor_b32_e32 v16, v43, v16
		v_xor_b32_e32 v16, v1, v16
		v_xor_b32_e32 v16, v45, v16
		v_mul_lo_u32 v16, s17, v16
		v_lshl_add_u32 v20, v16, 1, s0
		v_lshl_add_u32 v21, v3, 5, v20
		v_add3_u32 v21, v21, v17, v19
		buffer_store_dwordx2 v[166:167], v21, s[4:7], 0 offen
		v_lshl_add_u32 v21, v15, 1, v20
		buffer_store_dwordx2 v[168:169], v21, s[4:7], 0 offen
		v_lshl_add_u32 v21, v4, 1, v20
		buffer_store_dwordx2 v[170:171], v21, s[4:7], 0 offen
		v_lshl_add_u32 v20, v5, 1, v20
		buffer_store_dwordx2 v[172:173], v20, s[4:7], 0 offen
		v_add_u32_e32 v20, 0xc0, v18
		v_xor_b32_e32 v20, v20, v44
		v_xor_b32_e32 v20, v43, v20
		v_xor_b32_e32 v20, v1, v20
		v_xor_b32_e32 v20, v45, v20
		v_mul_lo_u32 v20, s17, v20
		v_lshl_add_u32 v21, v20, 1, s0
		v_lshl_add_u32 v22, v3, 5, v21
		v_add3_u32 v22, v22, v17, v19
		buffer_store_dwordx2 v[174:175], v22, s[4:7], 0 offen
		v_lshl_add_u32 v22, v15, 1, v21
		buffer_store_dwordx2 v[176:177], v22, s[4:7], 0 offen
		v_lshl_add_u32 v22, v4, 1, v21
		buffer_store_dwordx2 v[178:179], v22, s[4:7], 0 offen
		v_lshl_add_u32 v21, v5, 1, v21
		buffer_store_dwordx2 v[180:181], v21, s[4:7], 0 offen
		v_add_u32_e32 v18, 0xe0, v18
		v_xor_b32_e32 v18, v18, v44
		v_xor_b32_e32 v18, v43, v18
		v_xor_b32_e32 v1, v1, v18
		v_xor_b32_e32 v1, v45, v1
		v_mul_lo_u32 v1, s17, v1
		v_lshl_add_u32 v18, v1, 1, s0
		v_lshl_add_u32 v21, v3, 5, v18
		v_add3_u32 v21, v21, v17, v19
		buffer_store_dwordx2 v[182:183], v21, s[4:7], 0 offen
		v_lshl_add_u32 v21, v15, 1, v18
		buffer_store_dwordx2 v[184:185], v21, s[4:7], 0 offen
		v_lshl_add_u32 v21, v4, 1, v18
		buffer_store_dwordx2 v[186:187], v21, s[4:7], 0 offen
		v_lshl_add_u32 v18, v5, 1, v18
		buffer_store_dwordx2 v[188:189], v18, s[4:7], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[24:27], a[112:115], v32, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[28:31], a[112:115], v32, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[24:27], a[116:119], v32, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[116:119], v[28:31], a[116:119], v32, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v22, v33
		v_mov_b32_e32 v23, v32
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[120:123], v[24:27], a[120:123], v22, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[140:143], v[28:31], a[120:123], v22, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[144:147], v[24:27], a[124:127], v22, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[148:151], v[28:31], a[124:127], v22, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[48:51], a[128:131], v32, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[56:59], a[128:131], v32, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[48:51], a[132:135], v32, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[116:119], v[56:59], a[132:135], v32, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[120:123], v[48:51], a[136:139], v22, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[140:143], v[56:59], a[136:139], v22, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], v[48:51], a[140:143], v22, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[148:151], v[56:59], a[140:143], v22, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[72:75], a[144:147], v32, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[76:79], a[144:147], v32, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[72:75], a[148:151], v32, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[116:119], v[76:79], a[148:151], v32, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[120:123], v[72:75], a[152:155], v22, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[140:143], v[76:79], a[152:155], v22, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[144:147], v[72:75], a[156:159], v22, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[148:151], v[76:79], a[156:159], v22, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[80:83], a[160:163], v32, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[84:87], a[160:163], v32, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[80:83], a[164:167], v32, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[84:87], a[164:167], v32, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[120:123], v[80:83], a[168:171], v22, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[140:143], v[84:87], a[168:171], v22, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], v[80:83], a[172:175], v22, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[148:151], v[84:87], a[172:175], v22, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[88:91], a[176:179], v32, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[92:95], a[176:179], v32, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[88:91], a[180:183], v32, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[92:95], a[180:183], v32, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[120:123], v[88:91], a[184:187], v22, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[140:143], v[92:95], a[184:187], v22, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], v[88:91], a[188:191], v22, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[148:151], v[92:95], a[188:191], v22, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[96:99], a[192:195], v32, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[104:107], a[192:195], v32, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[96:99], a[196:199], v32, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[116:119], v[104:107], a[196:199], v32, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[120:123], v[96:99], a[200:203], v22, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[140:143], v[104:107], a[200:203], v22, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[144:147], v[96:99], a[204:207], v22, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[148:151], v[104:107], a[204:207], v22, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[124:127], a[208:211], v32, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[128:131], a[208:211], v32, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[124:127], a[212:215], v32, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[116:119], v[128:131], a[212:215], v32, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[120:123], v[124:127], a[216:219], v22, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[140:143], v[128:131], a[216:219], v22, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[144:147], v[124:127], a[220:223], v22, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[148:151], v[128:131], a[220:223], v22, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[100:103], v[132:135], a[224:227], v32, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[108:111], v[136:139], a[224:227], v32, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[132:135], a[228:231], v32, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[116:119], v[136:139], a[228:231], v32, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[120:123], v[132:135], a[232:235], v22, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[140:143], v[136:139], a[232:235], v22, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[144:147], v[132:135], v[252:255], v22, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[148:151], v[136:139], v[252:255], v22, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a112
		v_accvgpr_read_b32 v14, a113
		v_cvt_pk_bf16_f32 v22, v8, v14
		v_accvgpr_read_b32 v8, a114
		v_accvgpr_read_b32 v14, a115
		v_cvt_pk_bf16_f32 v23, v8, v14
		v_accvgpr_read_b32 v8, a116
		v_accvgpr_read_b32 v14, a117
		v_cvt_pk_bf16_f32 v24, v8, v14
		v_accvgpr_read_b32 v8, a118
		v_accvgpr_read_b32 v14, a119
		v_cvt_pk_bf16_f32 v25, v8, v14
		v_accvgpr_read_b32 v8, a120
		v_accvgpr_read_b32 v14, a121
		v_cvt_pk_bf16_f32 v26, v8, v14
		v_accvgpr_read_b32 v8, a122
		v_accvgpr_read_b32 v14, a123
		v_cvt_pk_bf16_f32 v27, v8, v14
		v_accvgpr_read_b32 v8, a124
		v_accvgpr_read_b32 v14, a125
		v_cvt_pk_bf16_f32 v28, v8, v14
		v_accvgpr_read_b32 v8, a126
		v_accvgpr_read_b32 v14, a127
		v_cvt_pk_bf16_f32 v29, v8, v14
		v_accvgpr_read_b32 v8, a128
		v_accvgpr_read_b32 v14, a129
		v_cvt_pk_bf16_f32 v30, v8, v14
		v_accvgpr_read_b32 v8, a130
		v_accvgpr_read_b32 v14, a131
		v_cvt_pk_bf16_f32 v31, v8, v14
		v_accvgpr_read_b32 v8, a132
		v_accvgpr_read_b32 v14, a133
		v_cvt_pk_bf16_f32 v32, v8, v14
		v_accvgpr_read_b32 v8, a134
		v_accvgpr_read_b32 v14, a135
		v_cvt_pk_bf16_f32 v33, v8, v14
		v_accvgpr_read_b32 v8, a136
		v_accvgpr_read_b32 v14, a137
		v_cvt_pk_bf16_f32 v34, v8, v14
		v_accvgpr_read_b32 v8, a138
		v_accvgpr_read_b32 v14, a139
		v_cvt_pk_bf16_f32 v35, v8, v14
		v_accvgpr_read_b32 v8, a140
		v_accvgpr_read_b32 v14, a141
		v_cvt_pk_bf16_f32 v36, v8, v14
		v_accvgpr_read_b32 v8, a142
		v_accvgpr_read_b32 v14, a143
		v_cvt_pk_bf16_f32 v37, v8, v14
		v_accvgpr_read_b32 v8, a144
		v_accvgpr_read_b32 v14, a145
		v_cvt_pk_bf16_f32 v38, v8, v14
		v_accvgpr_read_b32 v8, a146
		v_accvgpr_read_b32 v14, a147
		v_cvt_pk_bf16_f32 v39, v8, v14
		v_accvgpr_read_b32 v8, a148
		v_accvgpr_read_b32 v14, a149
		v_cvt_pk_bf16_f32 v40, v8, v14
		v_accvgpr_read_b32 v8, a150
		v_accvgpr_read_b32 v14, a151
		v_cvt_pk_bf16_f32 v41, v8, v14
		v_accvgpr_read_b32 v8, a152
		v_accvgpr_read_b32 v14, a153
		v_cvt_pk_bf16_f32 v42, v8, v14
		v_accvgpr_read_b32 v8, a154
		v_accvgpr_read_b32 v14, a155
		v_cvt_pk_bf16_f32 v43, v8, v14
		v_accvgpr_read_b32 v8, a156
		v_accvgpr_read_b32 v14, a157
		v_cvt_pk_bf16_f32 v44, v8, v14
		v_accvgpr_read_b32 v8, a158
		v_accvgpr_read_b32 v14, a159
		v_cvt_pk_bf16_f32 v45, v8, v14
		v_accvgpr_read_b32 v8, a160
		v_accvgpr_read_b32 v14, a161
		v_cvt_pk_bf16_f32 v46, v8, v14
		v_accvgpr_read_b32 v8, a162
		v_accvgpr_read_b32 v14, a163
		v_cvt_pk_bf16_f32 v47, v8, v14
		v_accvgpr_read_b32 v8, a164
		v_accvgpr_read_b32 v14, a165
		v_cvt_pk_bf16_f32 v48, v8, v14
		v_accvgpr_read_b32 v8, a166
		v_accvgpr_read_b32 v14, a167
		v_cvt_pk_bf16_f32 v49, v8, v14
		v_accvgpr_read_b32 v8, a168
		v_accvgpr_read_b32 v14, a169
		v_cvt_pk_bf16_f32 v50, v8, v14
		v_accvgpr_read_b32 v8, a170
		v_accvgpr_read_b32 v14, a171
		v_cvt_pk_bf16_f32 v51, v8, v14
		v_accvgpr_read_b32 v8, a172
		v_accvgpr_read_b32 v14, a173
		v_cvt_pk_bf16_f32 v52, v8, v14
		v_accvgpr_read_b32 v8, a174
		v_accvgpr_read_b32 v14, a175
		v_cvt_pk_bf16_f32 v53, v8, v14
		v_accvgpr_read_b32 v8, a176
		v_accvgpr_read_b32 v14, a177
		v_cvt_pk_bf16_f32 v54, v8, v14
		v_accvgpr_read_b32 v8, a178
		v_accvgpr_read_b32 v14, a179
		v_cvt_pk_bf16_f32 v55, v8, v14
		v_accvgpr_read_b32 v8, a180
		v_accvgpr_read_b32 v14, a181
		v_cvt_pk_bf16_f32 v56, v8, v14
		v_accvgpr_read_b32 v8, a182
		v_accvgpr_read_b32 v14, a183
		v_cvt_pk_bf16_f32 v57, v8, v14
		v_accvgpr_read_b32 v8, a184
		v_accvgpr_read_b32 v14, a185
		v_cvt_pk_bf16_f32 v58, v8, v14
		v_accvgpr_read_b32 v8, a186
		v_accvgpr_read_b32 v14, a187
		v_cvt_pk_bf16_f32 v59, v8, v14
		v_accvgpr_read_b32 v8, a188
		v_accvgpr_read_b32 v14, a189
		v_cvt_pk_bf16_f32 v60, v8, v14
		v_accvgpr_read_b32 v8, a190
		v_accvgpr_read_b32 v14, a191
		v_cvt_pk_bf16_f32 v61, v8, v14
		v_accvgpr_read_b32 v8, a192
		v_accvgpr_read_b32 v14, a193
		v_cvt_pk_bf16_f32 v62, v8, v14
		v_accvgpr_read_b32 v8, a194
		v_accvgpr_read_b32 v14, a195
		v_cvt_pk_bf16_f32 v63, v8, v14
		v_accvgpr_read_b32 v8, a196
		v_accvgpr_read_b32 v14, a197
		v_cvt_pk_bf16_f32 v64, v8, v14
		v_accvgpr_read_b32 v8, a198
		v_accvgpr_read_b32 v14, a199
		v_cvt_pk_bf16_f32 v65, v8, v14
		v_accvgpr_read_b32 v8, a200
		v_accvgpr_read_b32 v14, a201
		v_cvt_pk_bf16_f32 v66, v8, v14
		v_accvgpr_read_b32 v8, a202
		v_accvgpr_read_b32 v14, a203
		v_cvt_pk_bf16_f32 v67, v8, v14
		v_accvgpr_read_b32 v8, a204
		v_accvgpr_read_b32 v14, a205
		v_cvt_pk_bf16_f32 v68, v8, v14
		v_accvgpr_read_b32 v8, a206
		v_accvgpr_read_b32 v14, a207
		v_cvt_pk_bf16_f32 v69, v8, v14
		v_accvgpr_read_b32 v8, a208
		v_accvgpr_read_b32 v14, a209
		v_cvt_pk_bf16_f32 v70, v8, v14
		v_accvgpr_read_b32 v8, a210
		v_accvgpr_read_b32 v14, a211
		v_cvt_pk_bf16_f32 v71, v8, v14
		v_accvgpr_read_b32 v8, a212
		v_accvgpr_read_b32 v14, a213
		v_cvt_pk_bf16_f32 v72, v8, v14
		v_accvgpr_read_b32 v8, a214
		v_accvgpr_read_b32 v14, a215
		v_cvt_pk_bf16_f32 v73, v8, v14
		v_accvgpr_read_b32 v8, a216
		v_accvgpr_read_b32 v14, a217
		v_cvt_pk_bf16_f32 v74, v8, v14
		v_accvgpr_read_b32 v8, a218
		v_accvgpr_read_b32 v14, a219
		v_cvt_pk_bf16_f32 v75, v8, v14
		v_accvgpr_read_b32 v8, a220
		v_accvgpr_read_b32 v14, a221
		v_cvt_pk_bf16_f32 v76, v8, v14
		v_accvgpr_read_b32 v8, a222
		v_accvgpr_read_b32 v14, a223
		v_cvt_pk_bf16_f32 v77, v8, v14
		v_accvgpr_read_b32 v8, a224
		v_accvgpr_read_b32 v14, a225
		v_cvt_pk_bf16_f32 v78, v8, v14
		v_accvgpr_read_b32 v8, a226
		v_accvgpr_read_b32 v14, a227
		v_cvt_pk_bf16_f32 v79, v8, v14
		v_accvgpr_read_b32 v8, a228
		v_accvgpr_read_b32 v14, a229
		v_cvt_pk_bf16_f32 v80, v8, v14
		v_accvgpr_read_b32 v8, a230
		v_accvgpr_read_b32 v14, a231
		v_cvt_pk_bf16_f32 v81, v8, v14
		v_accvgpr_read_b32 v8, a232
		v_accvgpr_read_b32 v14, a233
		v_cvt_pk_bf16_f32 v82, v8, v14
		v_accvgpr_read_b32 v8, a234
		v_accvgpr_read_b32 v14, a235
		v_cvt_pk_bf16_f32 v83, v8, v14
		v_cvt_pk_bf16_f32 v84, v252, v253
		v_cvt_pk_bf16_f32 v85, v254, v255
		s_add_i32 s0, s0, 0x100
		v_lshl_add_u32 v0, v0, 5, s0
		v_add3_u32 v0, v0, v2, v9
		v_add3_u32 v0, v0, v10, v12
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[22:23], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[24:25], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[26:27], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[28:29], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v6, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[30:31], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[32:33], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[34:35], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[36:37], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v7, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[38:39], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[40:41], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[42:43], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[44:45], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v11, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[46:47], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[48:49], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[50:51], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[52:53], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v13, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[54:55], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[56:57], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[58:59], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[60:61], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v16, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[62:63], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[64:65], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[66:67], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[68:69], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v20, 1, s0
		v_lshl_add_u32 v2, v3, 5, v0
		v_add3_u32 v2, v2, v17, v19
		buffer_store_dwordx2 v[70:71], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v15, 1, v0
		buffer_store_dwordx2 v[72:73], v2, s[4:7], 0 offen
		v_lshl_add_u32 v2, v4, 1, v0
		buffer_store_dwordx2 v[74:75], v2, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[76:77], v0, s[4:7], 0 offen
		v_lshl_add_u32 v0, v1, 1, s0
		v_lshl_add_u32 v1, v3, 5, v0
		v_add3_u32 v1, v1, v17, v19
		buffer_store_dwordx2 v[78:79], v1, s[4:7], 0 offen
		v_lshl_add_u32 v1, v15, 1, v0
		buffer_store_dwordx2 v[80:81], v1, s[4:7], 0 offen
		v_lshl_add_u32 v1, v4, 1, v0
		buffer_store_dwordx2 v[82:83], v1, s[4:7], 0 offen
		v_lshl_add_u32 v0, v5, 1, v0
		buffer_store_dwordx2 v[84:85], v0, s[4:7], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 138048
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
		.amdhsa_next_free_vgpr 492
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
	.set .L_a4w4_kernel.num_vgpr, 256
	.set .L_a4w4_kernel.num_agpr, 236
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
    .group_segment_fixed_size: 138048
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     80
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     492
    .agpr_count:     236
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 60
    wave.regalloc.agpr.dwords: 236
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
