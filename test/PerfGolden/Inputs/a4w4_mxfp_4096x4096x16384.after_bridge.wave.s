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
		v_and_b32_e32 v14, 1, v13
		v_mul_lo_u32 v15, s14, v14
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v9, v9, v12, v15
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v17, 1, v16
		v_mul_lo_u32 v18, s14, v17
		v_lshlrev_b32_e32 v18, 4, v18
		v_and_b32_e32 v19, 1, v0
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v9, v9, v18, v20
		v_lshrrev_b32_e32 v21, 2, v0
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v22, 6, v21
		v_lshrrev_b32_e32 v23, 1, v0
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v24, 5, v23
		v_add3_u32 v9, v9, v22, v24
		s_lshr_b32 s22, s22, 6
		s_mul_i32 s22, 0x420, s22
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_lshl_b32 s23, s14, 2
		v_add3_u32 v25, s23, v2, v8
		v_add3_u32 v25, v25, v12, v15
		v_add3_u32 v25, v25, v18, v20
		v_add3_u32 v25, v25, v22, v24
		s_add_i32 s28, s22, 0x1080
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_lshl_b32 s29, s14, 3
		v_add3_u32 v26, s29, v2, v8
		v_add3_u32 v26, v26, v12, v15
		v_add3_u32 v26, v26, v18, v20
		v_add3_u32 v26, v26, v22, v24
		s_add_i32 s30, s22, 0x2100
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mul_i32 s31, 12, s14
		v_add3_u32 v27, s31, v2, v8
		v_add3_u32 v27, v27, v12, v15
		v_add3_u32 v27, v27, v18, v20
		v_add3_u32 v27, v27, v22, v24
		s_add_i32 s32, s22, 0x3180
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_lshl_b32 s33, s14, 7
		v_add3_u32 v28, s33, v2, v8
		v_add3_u32 v28, v28, v12, v15
		v_add3_u32 v28, v28, v18, v20
		v_add3_u32 v28, v28, v22, v24
		s_add_i32 s34, s22, 0x4200
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s35, 0x84, s14
		v_add3_u32 v29, s35, v2, v8
		v_add3_u32 v29, v29, v12, v15
		v_add3_u32 v29, v29, v18, v20
		v_add3_u32 v29, v29, v22, v24
		s_add_i32 s36, s22, 0x5280
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s37, 0x88, s14
		v_add3_u32 v30, s37, v2, v8
		v_add3_u32 v30, v30, v12, v15
		v_add3_u32 v30, v30, v18, v20
		v_add3_u32 v30, v30, v22, v24
		s_add_i32 s38, s22, 0x6300
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		v_add3_u32 v31, s14, v2, v8
		v_add3_u32 v31, v31, v12, v15
		v_add3_u32 v31, v31, v18, v20
		v_add3_u32 v31, v31, v22, v24
		s_add_i32 s39, s22, 0x7380
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_add_u32 s40, s4, s20
		s_addc_u32 s41, s5, 0
		s_mov_b32 s44, s40
		s_mov_b32 s45, s41
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		v_mul_lo_u32 v32, s15, v1
		v_lshlrev_b32_e32 v32, 1, v32
		v_mul_lo_u32 v33, s15, v3
		v_add_u32_e32 v34, v32, v33
		v_mul_lo_u32 v35, s15, v11
		v_lshlrev_b32_e32 v35, 6, v35
		v_mul_lo_u32 v36, s15, v14
		v_lshlrev_b32_e32 v36, 5, v36
		v_add3_u32 v34, v34, v35, v36
		v_mul_lo_u32 v37, s15, v17
		v_lshlrev_b32_e32 v37, 4, v37
		v_add3_u32 v34, v34, v37, v20
		v_add3_u32 v34, v34, v22, v24
		s_add_i32 s40, s22, 0x107c0
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v34, s[44:47], 0 offen lds
		s_lshl_b32 s41, s15, 2
		v_add3_u32 v38, s41, v32, v33
		v_add3_u32 v38, v38, v35, v36
		v_add3_u32 v38, v38, v37, v20
		v_add3_u32 v38, v38, v22, v24
		s_add_i32 s42, s22, 0x11840
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		s_lshl_b32 s43, s15, 3
		v_add3_u32 v39, s43, v32, v33
		v_add3_u32 v39, v39, v35, v36
		v_add3_u32 v39, v39, v37, v20
		v_add3_u32 v39, v39, v22, v24
		s_add_i32 s48, s22, 0x128c0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		s_mul_i32 s49, 12, s15
		v_add3_u32 v40, s49, v32, v33
		v_add3_u32 v40, v40, v35, v36
		v_add3_u32 v40, v40, v37, v20
		v_add3_u32 v40, v40, v22, v24
		s_add_i32 s50, s22, 0x13940
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v40, s[44:47], 0 offen lds
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
		v_mul_lo_u32 v41, s18, v1
		v_lshl_add_u32 v41, v41, 4, s51
		v_mul_lo_u32 v42, s18, v3
		v_lshl_add_u32 v41, v42, 3, v41
		v_mul_lo_u32 v42, s18, v11
		v_lshl_add_u32 v41, v42, 2, v41
		v_mul_lo_u32 v42, s18, v14
		v_lshl_add_u32 v41, v42, 1, v41
		v_mul_lo_u32 v43, s18, v17
		v_add3_u32 v41, v41, v43, v19
		v_lshlrev_b32_e32 v44, 2, v21
		v_lshlrev_b32_e32 v45, 1, v23
		v_add3_u32 v41, v41, v44, v45
		v_lshlrev_b32_e32 v46, 4, v1
		v_lshlrev_b32_e32 v47, 3, v3
		v_lshlrev_b32_e32 v48, 2, v11
		v_add_u32_e32 v49, 32, v17
		v_lshlrev_b32_e32 v50, 1, v14
		v_xor_b32_e32 v49, v49, v50
		v_xor_b32_e32 v49, v48, v49
		v_xor_b32_e32 v49, v47, v49
		v_xor_b32_e32 v49, v46, v49
		v_mul_lo_u32 v51, s18, v49
		v_add3_u32 v51, s51, v51, v19
		v_add3_u32 v51, v51, v44, v45
		v_add_u32_e32 v52, 64, v17
		v_xor_b32_e32 v52, v52, v50
		v_xor_b32_e32 v52, v48, v52
		v_xor_b32_e32 v52, v47, v52
		v_xor_b32_e32 v52, v46, v52
		v_mul_lo_u32 v53, s18, v52
		v_add3_u32 v53, s51, v53, v19
		v_add3_u32 v53, v53, v44, v45
		v_add_u32_e32 v54, 0x60, v17
		v_xor_b32_e32 v54, v54, v50
		v_xor_b32_e32 v54, v48, v54
		v_xor_b32_e32 v54, v47, v54
		v_xor_b32_e32 v54, v46, v54
		v_mul_lo_u32 v55, s18, v54
		v_add3_u32 v55, s51, v55, v19
		v_add3_u32 v55, v55, v44, v45
		v_add_u32_e32 v56, 0x80, v17
		v_xor_b32_e32 v56, v56, v50
		v_xor_b32_e32 v56, v48, v56
		v_xor_b32_e32 v56, v47, v56
		v_xor_b32_e32 v56, v46, v56
		v_mul_lo_u32 v57, s18, v56
		v_add3_u32 v57, s51, v57, v19
		v_add3_u32 v57, v57, v44, v45
		v_add_u32_e32 v58, 0xa0, v17
		v_xor_b32_e32 v58, v58, v50
		v_xor_b32_e32 v58, v48, v58
		v_xor_b32_e32 v58, v47, v58
		v_xor_b32_e32 v58, v46, v58
		v_mul_lo_u32 v59, s18, v58
		v_add3_u32 v59, s51, v59, v19
		v_add3_u32 v59, v59, v44, v45
		v_add_u32_e32 v60, 0xc0, v17
		v_xor_b32_e32 v60, v60, v50
		v_xor_b32_e32 v60, v48, v60
		v_xor_b32_e32 v60, v47, v60
		v_xor_b32_e32 v60, v46, v60
		v_mul_lo_u32 v61, s18, v60
		v_add3_u32 v61, s51, v61, v19
		v_add3_u32 v61, v61, v44, v45
		v_add_u32_e32 v62, 0xe0, v17
		v_xor_b32_e32 v50, v62, v50
		v_xor_b32_e32 v48, v48, v50
		v_xor_b32_e32 v47, v47, v48
		v_xor_b32_e32 v47, v46, v47
		v_mul_lo_u32 v48, s18, v47
		v_add3_u32 v48, s51, v48, v19
		v_add3_u32 v48, v48, v44, v45
		buffer_load_ubyte v50, v41, s[52:55], 0 offen
		buffer_load_ubyte v62, v51, s[52:55], 0 offen
		buffer_load_ubyte v63, v53, s[52:55], 0 offen
		buffer_load_ubyte v64, v55, s[52:55], 0 offen
		buffer_load_ubyte v65, v57, s[52:55], 0 offen
		buffer_load_ubyte v66, v59, s[52:55], 0 offen
		buffer_load_ubyte v67, v61, s[52:55], 0 offen
		buffer_load_ubyte v68, v48, s[52:55], 0 offen
		s_mov_b32 s56, s10
		s_mov_b32 s57, s11
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_mul_i32 s51, s0, s19
		s_lshl_b32 s51, s51, 8
		v_mul_lo_u32 v69, s19, v1
		v_lshl_add_u32 v69, v69, 4, s51
		v_mul_lo_u32 v70, s19, v3
		v_lshl_add_u32 v69, v70, 3, v69
		v_mul_lo_u32 v70, s19, v11
		v_lshl_add_u32 v69, v70, 2, v69
		v_mul_lo_u32 v70, s19, v14
		v_lshl_add_u32 v69, v70, 1, v69
		v_mul_lo_u32 v71, s19, v17
		v_add3_u32 v69, v69, v71, v19
		v_add3_u32 v69, v69, v44, v45
		v_mul_lo_u32 v72, s19, v49
		v_add3_u32 v72, s51, v72, v19
		v_add3_u32 v72, v72, v44, v45
		v_mul_lo_u32 v73, s19, v52
		v_add3_u32 v73, s51, v73, v19
		v_add3_u32 v73, v73, v44, v45
		v_mul_lo_u32 v74, s19, v54
		v_add3_u32 v74, s51, v74, v19
		v_add3_u32 v44, v74, v44, v45
		buffer_load_ubyte v45, v69, s[56:59], 0 offen
		buffer_load_ubyte v74, v72, s[56:59], 0 offen
		buffer_load_ubyte v75, v73, s[56:59], 0 offen
		buffer_load_ubyte v76, v44, s[56:59], 0 offen
		s_lshl_b32 s60, s15, 7
		v_add3_u32 v77, s60, v32, v33
		v_add3_u32 v77, v77, v35, v36
		v_add3_u32 v77, v77, v37, v20
		v_add3_u32 v77, v77, v22, v24
		s_add_i32 s61, s22, 0x18b80
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v77, s[44:47], 0 offen lds
		s_mul_i32 s62, 0x84, s15
		v_add3_u32 v78, s62, v32, v33
		v_add3_u32 v78, v78, v35, v36
		v_add3_u32 v78, v78, v37, v20
		v_add3_u32 v78, v78, v22, v24
		s_add_i32 s63, s22, 0x19c00
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v78, s[44:47], 0 offen lds
		s_mul_i32 s64, 0x88, s15
		v_add3_u32 v79, s64, v32, v33
		v_add3_u32 v79, v79, v35, v36
		v_add3_u32 v79, v79, v37, v20
		v_add3_u32 v79, v79, v22, v24
		s_add_i32 s65, s22, 0x1ac80
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v79, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v80, s15, v32, v33
		v_add3_u32 v80, v80, v35, v36
		v_add3_u32 v80, v80, v37, v20
		v_add3_u32 v80, v80, v22, v24
		s_add_i32 s66, s22, 0x1bd00
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v80, s[44:47], 0 offen lds
		s_lshl_b32 s67, s19, 7
		s_add_i32 s68, s67, s51
		v_mul_lo_u32 v81, s19, v19
		v_lshlrev_b32_e32 v81, 2, v81
		v_lshlrev_b32_e32 v70, 6, v70
		v_add3_u32 v82, s68, v81, v70
		v_lshlrev_b32_e32 v71, 5, v71
		v_mul_lo_u32 v83, s19, v21
		v_lshlrev_b32_e32 v83, 4, v83
		v_add3_u32 v82, v82, v71, v83
		v_mul_lo_u32 v84, s19, v23
		v_lshlrev_b32_e32 v84, 3, v84
		v_add3_u32 v82, v82, v84, v10
		s_mul_i32 s68, 0x81, s19
		s_add_i32 s69, s68, s51
		v_add3_u32 v85, s69, v81, v70
		v_add3_u32 v85, v85, v71, v83
		v_add3_u32 v85, v85, v84, v10
		s_mul_i32 s69, 0x82, s19
		s_add_i32 s70, s69, s51
		v_add3_u32 v86, s70, v81, v70
		v_add3_u32 v86, v86, v71, v83
		v_add3_u32 v86, v86, v84, v10
		s_mul_i32 s70, 0x83, s19
		s_add_i32 s71, s70, s51
		v_add3_u32 v87, s71, v81, v70
		v_add3_u32 v87, v87, v71, v83
		v_add3_u32 v87, v87, v84, v10
		buffer_load_ubyte v88, v82, s[56:59], 0 offen
		buffer_load_ubyte v89, v85, s[56:59], 0 offen
		buffer_load_ubyte v90, v86, s[56:59], 0 offen
		buffer_load_ubyte v91, v87, s[56:59], 0 offen
		v_add_u32_e32 v92, 0x80, v2
		v_add_u32_e32 v92, v92, v8
		v_add3_u32 v92, v92, v12, v15
		v_add3_u32 v92, v92, v18, v20
		v_add3_u32 v92, v92, v22, v24
		s_add_i32 s71, s22, 0x83e0
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v92, s[24:27], 0 offen lds
		s_add_i32 s23, s23, 0x80
		v_add3_u32 v93, s23, v2, v8
		v_add3_u32 v93, v93, v12, v15
		v_add3_u32 v93, v93, v18, v20
		v_add3_u32 v93, v93, v22, v24
		s_add_i32 s23, s22, 0x9460
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_add_i32 s29, s29, 0x80
		v_add3_u32 v94, s29, v2, v8
		v_add3_u32 v94, v94, v12, v15
		v_add3_u32 v94, v94, v18, v20
		v_add3_u32 v94, v94, v22, v24
		s_add_i32 s29, s22, 0xa4e0
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_add_i32 s31, s31, 0x80
		v_add3_u32 v95, s31, v2, v8
		v_add3_u32 v95, v95, v12, v15
		v_add3_u32 v95, v95, v18, v20
		v_add3_u32 v95, v95, v22, v24
		s_add_i32 s31, s22, 0xb560
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 0x80
		v_add3_u32 v96, s33, v2, v8
		v_add3_u32 v96, v96, v12, v15
		v_add3_u32 v96, v96, v18, v20
		v_add3_u32 v96, v96, v22, v24
		s_add_i32 s33, s22, 0xc5e0
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s35, s35, 0x80
		v_add3_u32 v97, s35, v2, v8
		v_add3_u32 v97, v97, v12, v15
		v_add3_u32 v97, v97, v18, v20
		v_add3_u32 v97, v97, v22, v24
		s_add_i32 s35, s22, 0xd660
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v97, s[24:27], 0 offen lds
		s_add_i32 s37, s37, 0x80
		v_add3_u32 v98, s37, v2, v8
		v_add3_u32 v98, v98, v12, v15
		v_add3_u32 v98, v98, v18, v20
		v_add3_u32 v98, v98, v22, v24
		s_add_i32 s37, s22, 0xe6e0
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v98, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v8
		v_add3_u32 v2, v2, v12, v15
		v_add3_u32 v2, v2, v18, v20
		v_add3_u32 v2, v2, v22, v24
		s_add_i32 s14, s22, 0xf760
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v8, 0x80, v32
		v_add_u32_e32 v8, v8, v33
		v_add3_u32 v8, v8, v35, v36
		v_add3_u32 v8, v8, v37, v20
		v_add3_u32 v8, v8, v22, v24
		s_add_i32 s24, s22, 0x149a0
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
		s_add_i32 s25, s41, 0x80
		v_add3_u32 v12, s25, v32, v33
		v_add3_u32 v12, v12, v35, v36
		v_add3_u32 v12, v12, v37, v20
		v_add3_u32 v12, v12, v22, v24
		s_add_i32 s25, s22, 0x15a20
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 s26, s43, 0x80
		v_add3_u32 v15, s26, v32, v33
		v_add3_u32 v15, v15, v35, v36
		v_add3_u32 v15, v15, v37, v20
		v_add3_u32 v15, v15, v22, v24
		s_add_i32 s26, s22, 0x16aa0
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 s27, s49, 0x80
		v_add3_u32 v18, s27, v32, v33
		v_add3_u32 v18, v18, v35, v36
		v_add3_u32 v18, v18, v37, v20
		v_add3_u32 v18, v18, v22, v24
		s_add_i32 s27, s22, 0x17b20
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[44:47], 0 offen lds
		s_add_i32 s41, s1, 8
		s_add_i32 s41, s41, s16
		v_mul_lo_u32 v99, s18, v19
		v_lshlrev_b32_e32 v99, 3, v99
		v_lshlrev_b32_e32 v42, 7, v42
		v_add3_u32 v100, s41, v99, v42
		v_lshlrev_b32_e32 v43, 6, v43
		v_mul_lo_u32 v101, s18, v21
		v_lshlrev_b32_e32 v101, 5, v101
		v_add3_u32 v100, v100, v43, v101
		v_mul_lo_u32 v102, s18, v23
		v_lshlrev_b32_e32 v102, 4, v102
		v_add3_u32 v100, v100, v102, v10
		s_add_i32 s41, s18, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v103, s41, v99, v42
		v_add3_u32 v103, v103, v43, v101
		v_add3_u32 v103, v103, v102, v10
		s_lshl_b32 s41, s18, 1
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v104, s41, v99, v42
		v_add3_u32 v104, v104, v43, v101
		v_add3_u32 v104, v104, v102, v10
		s_mul_i32 s41, 3, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v105, s41, v99, v42
		v_add3_u32 v105, v105, v43, v101
		v_add3_u32 v105, v105, v102, v10
		s_lshl_b32 s41, s18, 2
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v106, s41, v99, v42
		v_add3_u32 v106, v106, v43, v101
		v_add3_u32 v106, v106, v102, v10
		s_mul_i32 s41, 5, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v107, s41, v99, v42
		v_add3_u32 v107, v107, v43, v101
		v_add3_u32 v107, v107, v102, v10
		s_mul_i32 s41, 6, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v108, s41, v99, v42
		v_add3_u32 v108, v108, v43, v101
		v_add3_u32 v108, v108, v102, v10
		s_mul_i32 s18, 7, s18
		s_add_i32 s18, s18, 8
		s_add_i32 s1, s18, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v42, s1, v99, v42
		v_add3_u32 v42, v42, v43, v101
		v_add3_u32 v42, v42, v102, v10
		buffer_load_ubyte v43, v100, s[52:55], 0 offen
		buffer_load_ubyte v99, v103, s[52:55], 0 offen
		buffer_load_ubyte v101, v104, s[52:55], 0 offen
		buffer_load_ubyte v102, v105, s[52:55], 0 offen
		buffer_load_ubyte v109, v106, s[52:55], 0 offen
		buffer_load_ubyte v110, v107, s[52:55], 0 offen
		buffer_load_ubyte v111, v108, s[52:55], 0 offen
		buffer_load_ubyte v112, v42, s[52:55], 0 offen
		s_add_i32 s1, s51, 8
		v_add3_u32 v113, s1, v81, v70
		v_add3_u32 v113, v113, v71, v83
		v_add3_u32 v113, v113, v84, v10
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v114, s1, v81, v70
		v_add3_u32 v114, v114, v71, v83
		v_add3_u32 v114, v114, v84, v10
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v115, s1, v81, v70
		v_add3_u32 v115, v115, v71, v83
		v_add3_u32 v115, v115, v84, v10
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v116, s1, v81, v70
		v_add3_u32 v116, v116, v71, v83
		v_add3_u32 v116, v116, v84, v10
		buffer_load_ubyte v117, v113, s[56:59], 0 offen
		buffer_load_ubyte v118, v114, s[56:59], 0 offen
		buffer_load_ubyte v119, v115, s[56:59], 0 offen
		buffer_load_ubyte v120, v116, s[56:59], 0 offen
		s_add_i32 s1, s60, 0x80
		v_add3_u32 v121, s1, v32, v33
		v_add3_u32 v121, v121, v35, v36
		v_add3_u32 v121, v121, v37, v20
		v_add3_u32 v121, v121, v22, v24
		s_add_i32 s1, s22, 0x1cd60
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v121, s[44:47], 0 offen lds
		s_add_i32 s16, s62, 0x80
		v_add3_u32 v122, s16, v32, v33
		v_add3_u32 v122, v122, v35, v36
		v_add3_u32 v122, v122, v37, v20
		v_add3_u32 v122, v122, v22, v24
		s_add_i32 s16, s22, 0x1dde0
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v122, s[44:47], 0 offen lds
		s_add_i32 s18, s64, 0x80
		v_add3_u32 v123, s18, v32, v33
		v_add3_u32 v123, v123, v35, v36
		v_add3_u32 v123, v123, v37, v20
		v_add3_u32 v123, v123, v22, v24
		s_add_i32 s18, s22, 0x1ee60
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v123, s[44:47], 0 offen lds
		s_add_i32 s15, s15, 0x80
		v_add3_u32 v32, s15, v32, v33
		v_add3_u32 v32, v32, v35, v36
		v_add3_u32 v32, v32, v37, v20
		v_add3_u32 v32, v32, v22, v24
		s_add_i32 s15, s22, 0x1fee0
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v32, s[44:47], 0 offen lds
		s_add_i32 s19, s67, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v33, s19, v81, v70
		v_add3_u32 v33, v33, v71, v83
		v_add3_u32 v33, v33, v84, v10
		s_add_i32 s19, s68, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v35, s19, v81, v70
		v_add3_u32 v35, v35, v71, v83
		v_add3_u32 v35, v35, v84, v10
		s_add_i32 s19, s69, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v36, s19, v81, v70
		v_add3_u32 v36, v36, v71, v83
		v_add3_u32 v36, v36, v84, v10
		s_add_i32 s19, s70, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v37, s19, v81, v70
		v_add3_u32 v37, v37, v71, v83
		v_add3_u32 v10, v37, v84, v10
		buffer_load_ubyte v37, v33, s[56:59], 0 offen
		buffer_load_ubyte v70, v35, s[56:59], 0 offen
		buffer_load_ubyte v71, v36, s[56:59], 0 offen
		buffer_load_ubyte v81, v10, s[56:59], 0 offen
		s_add_i32 s19, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v83, 7, v1
		v_and_b32_e32 v84, 63, v0
		v_lshrrev_b32_e32 v124, 4, v84
		v_lshlrev_b32_e32 v124, 4, v124
		v_and_b32_e32 v84, 15, v84
		v_mov_b32_e32 v125, 0x420
		v_mul_lo_u32 v125, v125, v84
		v_add3_u32 v83, v83, v124, v125
		ds_read_b128 v[128:131], v83
		ds_read_b128 v[132:135], v83 offset:64
		ds_read_b128 v[136:139], v83 offset:256
		ds_read_b128 v[140:143], v83 offset:320
		ds_read_b128 v[144:147], v83 offset:512
		ds_read_b128 v[148:151], v83 offset:576
		ds_read_b128 v[152:155], v83 offset:768
		ds_read_b128 v[156:159], v83 offset:832
		ds_read_b128 v[160:163], v83 offset:16896
		ds_read_b128 v[164:167], v83 offset:16960
		ds_read_b128 v[168:171], v83 offset:17152
		ds_read_b128 v[172:175], v83 offset:17216
		ds_read_b128 v[176:179], v83 offset:17408
		ds_read_b128 v[180:183], v83 offset:17472
		ds_read_b128 v[184:187], v83 offset:17664
		ds_read_b128 v[188:191], v83 offset:17728
		v_add_u32_e32 v84, 0x10000, v124
		v_lshlrev_b32_e32 v124, 7, v3
		v_add3_u32 v84, v84, v124, v125
		ds_read_b128 v[124:127], v84 offset:1984
		ds_read_b128 v[192:195], v84 offset:2048
		ds_read_b128 v[196:199], v84 offset:2240
		ds_read_b128 v[200:203], v84 offset:2304
		ds_read_b128 v[204:207], v84 offset:2496
		ds_read_b128 v[208:211], v84 offset:2560
		ds_read_b128 v[212:215], v84 offset:2752
		ds_read_b128 v[216:219], v84 offset:2816
		v_add_u32_e32 v16, 0x20000, v16
		v_lshlrev_b32_e32 v220, 8, v19
		v_add_u32_e32 v221, v16, v220
		v_lshlrev_b32_e32 v222, 10, v21
		v_lshlrev_b32_e32 v223, 9, v23
		v_add3_u32 v221, v221, v222, v223
		s_waitcnt vmcnt(51)
		ds_write_b8 v221, v50 offset:3904
		v_add_u32_e32 v50, 0x20000, v220
		v_add3_u32 v50, v50, v222, v223
		v_add_u32_e32 v220, v50, v49
		s_waitcnt vmcnt(50)
		ds_write_b8 v220, v62 offset:3904
		v_add_u32_e32 v62, v50, v52
		s_waitcnt vmcnt(49)
		ds_write_b8 v62, v63 offset:3904
		v_add_u32_e32 v63, v50, v54
		s_waitcnt vmcnt(48)
		ds_write_b8 v63, v64 offset:3904
		v_add_u32_e32 v56, v50, v56
		s_waitcnt vmcnt(47)
		ds_write_b8 v56, v65 offset:3904
		v_add_u32_e32 v58, v50, v58
		s_waitcnt vmcnt(46)
		ds_write_b8 v58, v66 offset:3904
		v_add_u32_e32 v60, v50, v60
		s_waitcnt vmcnt(45)
		ds_write_b8 v60, v67 offset:3904
		v_add_u32_e32 v47, v50, v47
		s_waitcnt vmcnt(44)
		ds_write_b8 v47, v68 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v50, 7, v19
		v_add_u32_e32 v16, v16, v50
		v_lshlrev_b32_e32 v64, 9, v21
		v_lshlrev_b32_e32 v65, 8, v23
		v_add3_u32 v16, v16, v64, v65
		s_waitcnt vmcnt(43)
		ds_write_b8 v16, v45 offset:5952
		v_add_u32_e32 v45, 0x20000, v50
		v_add3_u32 v45, v45, v64, v65
		v_add_u32_e32 v49, v45, v49
		s_waitcnt vmcnt(42)
		ds_write_b8 v49, v74 offset:5952
		v_add_u32_e32 v50, v45, v52
		s_waitcnt vmcnt(41)
		ds_write_b8 v50, v75 offset:5952
		v_add_u32_e32 v45, v45, v54
		s_waitcnt vmcnt(40)
		ds_write_b8 v45, v76 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v46, 0x20000, v46
		v_lshlrev_b32_e32 v52, 3, v19
		v_add_u32_e32 v46, v46, v52
		v_lshl_add_u32 v46, v11, 9, v46
		v_lshlrev_b32_e32 v54, 8, v14
		v_lshlrev_b32_e32 v64, 6, v17
		v_add3_u32 v46, v46, v54, v64
		v_lshlrev_b32_e32 v54, 5, v21
		v_lshlrev_b32_e32 v23, 10, v23
		v_add3_u32 v46, v46, v54, v23
		ds_read_b64_tr_b8 v[66:67], v46 offset:3904
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v65, 0xff, v66
		v_lshrrev_b32_e32 v68, 8, v66
		v_and_b32_e32 v74, 0xff, v68
		v_lshrrev_b32_e32 v68, 16, v66
		v_and_b32_e32 v75, 0xff, v68
		v_lshrrev_b32_e32 v66, 24, v66
		v_and_b32_e32 v68, 0xff, v66
		v_and_b32_e32 v66, 0xff, v67
		v_lshrrev_b32_e32 v76, 8, v67
		v_and_b32_e32 v222, 0xff, v76
		v_lshrrev_b32_e32 v76, 16, v67
		v_and_b32_e32 v224, 0xff, v76
		v_lshrrev_b32_e32 v67, 24, v67
		v_and_b32_e32 v76, 0xff, v67
		ds_read_b64_tr_b8 v[226:227], v46 offset:4032
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v67, 0xff, v226
		v_lshrrev_b32_e32 v225, 8, v226
		v_and_b32_e32 v228, 0xff, v225
		v_lshrrev_b32_e32 v225, 16, v226
		v_and_b32_e32 v229, 0xff, v225
		v_lshrrev_b32_e32 v225, 24, v226
		v_and_b32_e32 v226, 0xff, v225
		v_and_b32_e32 v225, 0xff, v227
		v_lshrrev_b32_e32 v230, 8, v227
		v_and_b32_e32 v231, 0xff, v230
		v_lshrrev_b32_e32 v230, 16, v227
		v_and_b32_e32 v232, 0xff, v230
		v_lshrrev_b32_e32 v227, 24, v227
		v_and_b32_e32 v230, 0xff, v227
		v_add_u32_e32 v52, 0x20000, v52
		v_lshl_add_u32 v52, v3, 4, v52
		v_lshl_add_u32 v52, v11, 8, v52
		v_lshlrev_b32_e32 v227, 7, v14
		v_add3_u32 v52, v52, v227, v64
		v_add3_u32 v52, v52, v54, v223
		ds_read_b64_tr_b8 v[234:235], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v54, 0xff, v234
		v_lshrrev_b32_e32 v64, 8, v234
		v_and_b32_e32 v223, 0xff, v64
		v_lshrrev_b32_e32 v64, 16, v234
		v_and_b32_e32 v227, 0xff, v64
		v_lshrrev_b32_e32 v64, 24, v234
		v_and_b32_e32 v233, 0xff, v64
		v_and_b32_e32 v64, 0xff, v235
		v_lshrrev_b32_e32 v234, 8, v235
		v_and_b32_e32 v236, 0xff, v234
		v_lshrrev_b32_e32 v234, 16, v235
		v_and_b32_e32 v237, 0xff, v234
		v_lshrrev_b32_e32 v234, 24, v235
		v_and_b32_e32 v235, 0xff, v234
		s_mov_b32 s20, 16
		v_lshlrev_b32_e32 v234, 2, v0
		v_add_u32_e32 v234, 0x20000, v234
		v_lshlrev_b32_e32 v238, 3, v0
		v_add_u32_e32 v238, 0x20000, v238
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
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a4, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a5, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a6, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a7, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a8, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a9, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a10, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a11, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a12, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a13, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a14, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a15, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a16, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a17, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a18, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a19, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a20, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a21, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a22, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a23, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a24, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a25, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a26, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a27, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a28, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a29, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a30, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a31, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a32, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a33, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a34, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a35, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a36, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a37, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a38, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a39, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a40, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a41, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a42, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a43, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a44, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a45, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a46, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a47, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a48, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a49, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a50, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a51, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a52, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a53, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a54, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a55, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a56, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a57, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a58, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a59, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a60, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a61, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a62, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a63, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a64, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a65, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a66, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a67, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a68, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a69, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a70, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a71, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a72, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a73, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a74, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a75, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a76, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a77, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a78, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a79, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a80, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a81, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a82, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a83, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a84, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a85, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a86, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a87, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a88, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a89, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a90, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a91, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a92, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a93, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a94, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a95, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a96, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a97, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a98, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a99, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a100, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a101, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a102, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a103, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a104, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a105, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a106, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a107, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a108, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a109, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a110, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a111, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a112, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a113, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a114, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a115, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a116, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a117, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a118, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a119, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a120, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a121, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a122, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a123, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a124, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a125, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a126, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a127, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a128, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a129, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a130, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a131, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a132, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a133, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a134, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a135, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a136, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a137, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a138, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a139, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a140, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a141, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a142, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a143, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a144, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a145, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a146, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a147, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a148, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a149, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a150, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a151, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a152, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a153, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a154, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a155, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a156, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a157, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a158, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a159, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a160, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a161, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a162, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a163, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a164, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a165, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a166, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a167, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a168, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a169, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a170, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a171, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a172, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a173, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a174, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a175, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a176, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a177, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a178, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a179, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a180, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a181, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a182, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a183, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a184, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a185, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a186, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a187, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a188, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a189, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a190, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a191, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a192, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a193, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a194, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a195, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a196, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a197, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a198, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a199, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a200, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a201, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a202, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a203, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a204, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a205, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a206, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a207, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a208, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a209, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a210, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a211, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a212, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a213, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a214, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a215, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a216, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a217, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a218, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a219, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a220, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a221, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a222, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a223, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a224, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a225, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a226, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a227, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a228, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a229, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a230, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a231, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a232, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a233, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a234, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a235, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a236, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a237, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a238, v239
		v_mov_b32_e32 v239, 0
		v_accvgpr_write_b32 a239, v239
.L_a4w4_kernel.loop_head_0:
		v_and_b32_e32 v65, 0xff, v65
		v_and_b32_e32 v74, 0xff, v74
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v65, v65, v74
		v_and_b32_e32 v74, 0xff, v75
		v_lshlrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v68, 0xff, v68
		v_lshlrev_b32_e32 v68, 24, v68
		v_or3_b32 v65, v65, v74, v68
		v_and_b32_e32 v66, 0xff, v66
		v_and_b32_e32 v68, 0xff, v222
		v_lshlrev_b32_e32 v68, 8, v68
		v_or_b32_e32 v66, v66, v68
		v_and_b32_e32 v68, 0xff, v224
		v_lshlrev_b32_e32 v68, 16, v68
		v_and_b32_e32 v74, 0xff, v76
		v_lshlrev_b32_e32 v74, 24, v74
		v_or3_b32 v66, v66, v68, v74
		v_and_b32_e32 v67, 0xff, v67
		v_and_b32_e32 v68, 0xff, v228
		v_lshlrev_b32_e32 v68, 8, v68
		v_or_b32_e32 v67, v67, v68
		v_and_b32_e32 v68, 0xff, v229
		v_lshlrev_b32_e32 v68, 16, v68
		v_and_b32_e32 v74, 0xff, v226
		v_lshlrev_b32_e32 v74, 24, v74
		v_or3_b32 v67, v67, v68, v74
		v_and_b32_e32 v68, 0xff, v225
		v_and_b32_e32 v74, 0xff, v231
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v68, v68, v74
		v_and_b32_e32 v74, 0xff, v232
		v_lshlrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v75, 0xff, v230
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v68, v68, v74, v75
		v_and_b32_e32 v54, 0xff, v54
		v_and_b32_e32 v74, 0xff, v223
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v54, v54, v74
		v_and_b32_e32 v74, 0xff, v227
		v_lshlrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v75, 0xff, v233
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v54, v54, v74, v75
		v_and_b32_e32 v64, 0xff, v64
		v_and_b32_e32 v74, 0xff, v236
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v64, v64, v74
		v_and_b32_e32 v74, 0xff, v237
		v_lshlrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v75, 0xff, v235
		v_lshlrev_b32_e32 v75, 24, v75
		v_or3_b32 v64, v64, v74, v75
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[124:127], v[128:131], v[4:7], v54, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[132:135], v[4:7], v54, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[196:199], v[128:131], a[0:3], v54, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[132:135], a[0:3], v54, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[128:131], v[240:243], v64, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[132:135], v[240:243], v64, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[128:131], v[244:247], v64, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[132:135], v[244:247], v64, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[124:127], v[136:139], v[248:251], v54, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[140:143], v[248:251], v54, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[136:139], a[4:7], v54, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[140:143], a[4:7], v54, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[204:207], v[136:139], a[8:11], v64, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[140:143], a[8:11], v64, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[212:215], v[136:139], a[12:15], v64, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[140:143], a[12:15], v64, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[124:127], v[144:147], a[16:19], v54, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[148:151], a[16:19], v54, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[196:199], v[144:147], a[20:23], v54, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[148:151], a[20:23], v54, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[204:207], v[144:147], a[24:27], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[148:151], a[24:27], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[212:215], v[144:147], a[28:31], v64, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[148:151], a[28:31], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[124:127], v[152:155], a[32:35], v54, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[156:159], a[32:35], v54, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[196:199], v[152:155], a[36:39], v54, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[156:159], a[36:39], v54, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[152:155], a[40:43], v64, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[156:159], a[40:43], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[212:215], v[152:155], a[44:47], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[156:159], a[44:47], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[124:127], v[160:163], a[48:51], v54, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[164:167], a[48:51], v54, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[196:199], v[160:163], a[52:55], v54, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[164:167], a[52:55], v54, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[160:163], a[56:59], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[164:167], a[56:59], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[160:163], a[60:63], v64, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[164:167], a[60:63], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[124:127], v[168:171], a[64:67], v54, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[172:175], a[64:67], v54, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[196:199], v[168:171], a[68:71], v54, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[172:175], a[68:71], v54, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[204:207], v[168:171], a[72:75], v64, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[172:175], a[72:75], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[168:171], a[76:79], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[172:175], a[76:79], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[124:127], v[176:179], a[80:83], v54, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[180:183], a[80:83], v54, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[196:199], v[176:179], a[84:87], v54, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[180:183], a[84:87], v54, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[204:207], v[176:179], a[88:91], v64, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[180:183], a[88:91], v64, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[212:215], v[176:179], a[92:95], v64, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[180:183], a[92:95], v64, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[124:127], v[184:187], a[96:99], v54, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[188:191], a[96:99], v54, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[196:199], v[184:187], a[100:103], v54, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[188:191], a[100:103], v54, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[204:207], v[184:187], a[104:107], v64, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[188:191], a[104:107], v64, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[184:187], a[108:111], v64, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[188:191], a[108:111], v64, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[124:127], v84 offset:35712
		ds_read_b128 v[192:195], v84 offset:35776
		ds_read_b128 v[196:199], v84 offset:35968
		ds_read_b128 v[200:203], v84 offset:36032
		ds_read_b128 v[204:207], v84 offset:36224
		ds_read_b128 v[208:211], v84 offset:36288
		ds_read_b128 v[212:215], v84 offset:36480
		ds_read_b128 v[216:219], v84 offset:36544
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v54, 0xff, v88
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v64, 0xff, v89
		v_lshlrev_b32_e32 v64, 8, v64
		v_or_b32_e32 v54, v54, v64
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v64, 0xff, v90
		v_lshlrev_b32_e32 v64, 16, v64
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v74, 0xff, v91
		v_lshlrev_b32_e32 v74, 24, v74
		v_or3_b32 v54, v54, v64, v74
		ds_write_b32 v234, v54 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v52 offset:5952
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
		buffer_load_dwordx4 v25, s[52:55], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v26, s[52:55], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v27, s[52:55], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v28, s[52:55], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v29, s[52:55], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v30, s[52:55], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v31, s[52:55], 0 offen lds
		s_add_u32 s44, s4, s13
		s_addc_u32 s45, s5, 0
		s_mov_b32 m0, s40
		s_mov_b32 s56, s44
		s_mov_b32 s57, s45
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		buffer_load_dwordx4 v34, s[56:59], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v38, s[56:59], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v39, s[56:59], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v40, s[56:59], 0 offen lds
		s_add_u32 s44, s8, s20
		s_addc_u32 s45, s9, 0
		s_mov_b32 s72, s44
		s_mov_b32 s73, s45
		s_mov_b32 s74, 0x7fffffff
		s_mov_b32 s75, 0x31016000
		buffer_load_ubyte v54, v41, s[72:75], 0 offen
		buffer_load_ubyte v64, v51, s[72:75], 0 offen
		buffer_load_ubyte v76, v53, s[72:75], 0 offen
		buffer_load_ubyte v222, v55, s[72:75], 0 offen
		buffer_load_ubyte v223, v57, s[72:75], 0 offen
		buffer_load_ubyte v224, v59, s[72:75], 0 offen
		buffer_load_ubyte v225, v61, s[72:75], 0 offen
		buffer_load_ubyte v226, v48, s[72:75], 0 offen
		s_add_u32 s44, s10, s41
		s_addc_u32 s45, s11, 0
		s_mov_b32 s76, s44
		s_mov_b32 s77, s45
		s_mov_b32 s78, 0x7fffffff
		s_mov_b32 s79, 0x31016000
		buffer_load_ubyte v227, v69, s[76:79], 0 offen
		buffer_load_ubyte v228, v72, s[76:79], 0 offen
		buffer_load_ubyte v229, v73, s[76:79], 0 offen
		buffer_load_ubyte v230, v44, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[124:127], v[128:131], a[112:115], v74, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[192:195], v[132:135], a[112:115], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[196:199], v[128:131], a[116:119], v74, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[200:203], v[132:135], a[116:119], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v88, v75
		v_mov_b32_e32 v89, v74
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[204:207], v[128:131], a[120:123], v88, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[208:211], v[132:135], a[120:123], v88, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[128:131], a[124:127], v88, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[132:135], a[124:127], v88, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[124:127], v[136:139], a[128:131], v74, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[192:195], v[140:143], a[128:131], v74, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[196:199], v[136:139], a[132:135], v74, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[200:203], v[140:143], a[132:135], v74, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[204:207], v[136:139], a[136:139], v88, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[208:211], v[140:143], a[136:139], v88, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[212:215], v[136:139], a[140:143], v88, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[140:143], a[140:143], v88, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[124:127], v[144:147], a[144:147], v74, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[192:195], v[148:151], a[144:147], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[196:199], v[144:147], a[148:151], v74, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[200:203], v[148:151], a[148:151], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[204:207], v[144:147], a[152:155], v88, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[208:211], v[148:151], a[152:155], v88, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[212:215], v[144:147], a[156:159], v88, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[148:151], a[156:159], v88, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[124:127], v[152:155], a[160:163], v74, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[192:195], v[156:159], a[160:163], v74, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[196:199], v[152:155], a[164:167], v74, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[200:203], v[156:159], a[164:167], v74, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[204:207], v[152:155], a[168:171], v88, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[208:211], v[156:159], a[168:171], v88, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[212:215], v[152:155], a[172:175], v88, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[216:219], v[156:159], a[172:175], v88, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[124:127], v[160:163], a[176:179], v74, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[192:195], v[164:167], a[176:179], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[196:199], v[160:163], a[180:183], v74, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[200:203], v[164:167], a[180:183], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[204:207], v[160:163], a[184:187], v88, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[208:211], v[164:167], a[184:187], v88, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[212:215], v[160:163], a[188:191], v88, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[216:219], v[164:167], a[188:191], v88, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[124:127], v[168:171], a[192:195], v74, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[192:195], v[172:175], a[192:195], v74, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[196:199], v[168:171], a[196:199], v74, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[200:203], v[172:175], a[196:199], v74, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[204:207], v[168:171], a[200:203], v88, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[208:211], v[172:175], a[200:203], v88, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[212:215], v[168:171], a[204:207], v88, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[216:219], v[172:175], a[204:207], v88, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[124:127], v[176:179], a[208:211], v74, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[192:195], v[180:183], a[208:211], v74, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[196:199], v[176:179], a[212:215], v74, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[200:203], v[180:183], a[212:215], v74, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[204:207], v[176:179], a[216:219], v88, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[208:211], v[180:183], a[216:219], v88, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[212:215], v[176:179], a[220:223], v88, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[216:219], v[180:183], a[220:223], v88, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[124:127], v[184:187], a[224:227], v74, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[192:195], v[188:191], a[224:227], v74, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[196:199], v[184:187], a[228:231], v74, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[200:203], v[188:191], a[228:231], v74, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[204:207], v[184:187], a[232:235], v88, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[208:211], v[188:191], a[232:235], v88, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[212:215], v[184:187], a[236:239], v88, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[216:219], v[188:191], a[236:239], v88, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[124:127], v83 offset:33760
		ds_read_b128 v[128:131], v83 offset:33824
		ds_read_b128 v[132:135], v83 offset:34016
		ds_read_b128 v[136:139], v83 offset:34080
		ds_read_b128 v[140:143], v83 offset:34272
		ds_read_b128 v[144:147], v83 offset:34336
		ds_read_b128 v[148:151], v83 offset:34528
		ds_read_b128 v[152:155], v83 offset:34592
		ds_read_b128 v[156:159], v83 offset:50656
		ds_read_b128 v[160:163], v83 offset:50720
		ds_read_b128 v[164:167], v83 offset:50912
		ds_read_b128 v[168:171], v83 offset:50976
		ds_read_b128 v[172:175], v83 offset:51168
		ds_read_b128 v[176:179], v83 offset:51232
		ds_read_b128 v[180:183], v83 offset:51424
		ds_read_b128 v[184:187], v83 offset:51488
		ds_read_b128 v[188:191], v84 offset:18848
		ds_read_b128 v[192:195], v84 offset:18912
		ds_read_b128 v[196:199], v84 offset:19104
		ds_read_b128 v[200:203], v84 offset:19168
		ds_read_b128 v[204:207], v84 offset:19360
		ds_read_b128 v[208:211], v84 offset:19424
		ds_read_b128 v[212:215], v84 offset:19616
		ds_read_b128 v[216:219], v84 offset:19680
		s_waitcnt vmcnt(43)
		v_and_b32_e32 v43, 0xff, v43
		s_waitcnt vmcnt(42)
		v_and_b32_e32 v65, 0xff, v99
		v_lshlrev_b32_e32 v65, 8, v65
		v_or_b32_e32 v43, v43, v65
		s_waitcnt vmcnt(41)
		v_and_b32_e32 v65, 0xff, v101
		v_lshlrev_b32_e32 v65, 16, v65
		s_waitcnt vmcnt(40)
		v_and_b32_e32 v66, 0xff, v102
		v_lshlrev_b32_e32 v66, 24, v66
		v_or3_b32 v74, v43, v65, v66
		s_waitcnt vmcnt(39)
		v_and_b32_e32 v43, 0xff, v109
		s_waitcnt vmcnt(38)
		v_and_b32_e32 v65, 0xff, v110
		v_lshlrev_b32_e32 v65, 8, v65
		v_or_b32_e32 v43, v43, v65
		s_waitcnt vmcnt(37)
		v_and_b32_e32 v65, 0xff, v111
		v_lshlrev_b32_e32 v65, 16, v65
		s_waitcnt vmcnt(36)
		v_and_b32_e32 v66, 0xff, v112
		v_lshlrev_b32_e32 v66, 24, v66
		v_or3_b32 v75, v43, v65, v66
		ds_write_b64 v238, v[74:75] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v43, 0xff, v117
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v65, 0xff, v118
		v_lshlrev_b32_e32 v65, 8, v65
		v_or_b32_e32 v43, v43, v65
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v65, 0xff, v119
		v_lshlrev_b32_e32 v65, 16, v65
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v66, 0xff, v120
		v_lshlrev_b32_e32 v66, 24, v66
		v_or3_b32 v43, v43, v65, v66
		ds_write_b32 v234, v43 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v46 offset:3904
		ds_read_b64_tr_b8 v[74:75], v46 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[110:111], v52 offset:5952
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v77, s[56:59], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v78, s[56:59], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v79, s[56:59], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v80, s[56:59], 0 offen lds
		buffer_load_ubyte v88, v82, s[76:79], 0 offen
		buffer_load_ubyte v89, v85, s[76:79], 0 offen
		buffer_load_ubyte v90, v86, s[76:79], 0 offen
		buffer_load_ubyte v91, v87, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[188:191], v[124:127], v[4:7], v110, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[128:131], v[4:7], v110, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[196:199], v[124:127], a[0:3], v110, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[128:131], a[0:3], v110, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v118, v111
		v_mov_b32_e32 v119, v110
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[124:127], v[240:243], v118, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[128:131], v[240:243], v118, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[124:127], v[244:247], v118, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[128:131], v[244:247], v118, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[188:191], v[132:135], v[248:251], v110, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[136:139], v[248:251], v110, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[132:135], a[4:7], v110, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[136:139], a[4:7], v110, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[204:207], v[132:135], a[8:11], v118, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[136:139], a[8:11], v118, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[212:215], v[132:135], a[12:15], v118, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[136:139], a[12:15], v118, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v232, v67
		v_mov_b32_e32 v233, v66
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[188:191], v[140:143], a[16:19], v110, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[144:147], a[16:19], v110, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[196:199], v[140:143], a[20:23], v110, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[144:147], a[20:23], v110, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[204:207], v[140:143], a[24:27], v118, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[144:147], a[24:27], v118, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[212:215], v[140:143], a[28:31], v118, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[144:147], a[28:31], v118, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[188:191], v[148:151], a[32:35], v110, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[152:155], a[32:35], v110, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[196:199], v[148:151], a[36:39], v110, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[152:155], a[36:39], v110, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[148:151], a[40:43], v118, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[152:155], a[40:43], v118, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[212:215], v[148:151], a[44:47], v118, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[152:155], a[44:47], v118, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[188:191], v[156:159], a[48:51], v110, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[160:163], a[48:51], v110, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[196:199], v[156:159], a[52:55], v110, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[160:163], a[52:55], v110, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[156:159], a[56:59], v118, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[160:163], a[56:59], v118, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[156:159], a[60:63], v118, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[160:163], a[60:63], v118, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[188:191], v[164:167], a[64:67], v110, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[168:171], a[64:67], v110, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[196:199], v[164:167], a[68:71], v110, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[168:171], a[68:71], v110, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[204:207], v[164:167], a[72:75], v118, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[168:171], a[72:75], v118, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[164:167], a[76:79], v118, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[168:171], a[76:79], v118, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v236, v75
		v_mov_b32_e32 v237, v74
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[188:191], v[172:175], a[80:83], v110, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[176:179], a[80:83], v110, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[196:199], v[172:175], a[84:87], v110, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[176:179], a[84:87], v110, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[204:207], v[172:175], a[88:91], v118, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[176:179], a[88:91], v118, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[212:215], v[172:175], a[92:95], v118, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[176:179], a[92:95], v118, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[188:191], v[180:183], a[96:99], v110, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[184:187], a[96:99], v110, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[196:199], v[180:183], a[100:103], v110, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[184:187], a[100:103], v110, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[204:207], v[180:183], a[104:107], v118, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[184:187], a[104:107], v118, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[180:183], a[108:111], v118, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[184:187], a[108:111], v118, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[188:191], v84 offset:52576
		ds_read_b128 v[192:195], v84 offset:52640
		ds_read_b128 v[196:199], v84 offset:52832
		ds_read_b128 v[200:203], v84 offset:52896
		ds_read_b128 v[204:207], v84 offset:53088
		ds_read_b128 v[208:211], v84 offset:53152
		ds_read_b128 v[212:215], v84 offset:53344
		ds_read_b128 v[216:219], v84 offset:53408
		s_waitcnt vmcnt(35)
		v_and_b32_e32 v37, 0xff, v37
		s_waitcnt vmcnt(34)
		v_and_b32_e32 v43, 0xff, v70
		v_lshlrev_b32_e32 v43, 8, v43
		v_or_b32_e32 v37, v37, v43
		s_waitcnt vmcnt(33)
		v_and_b32_e32 v43, 0xff, v71
		v_lshlrev_b32_e32 v43, 16, v43
		s_waitcnt vmcnt(32)
		v_and_b32_e32 v65, 0xff, v81
		v_lshlrev_b32_e32 v65, 24, v65
		v_or3_b32 v37, v37, v43, v65
		ds_write_b32 v234, v37 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[70:71], v52 offset:5952
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v92, s[52:55], 0 offen lds
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v93, s[52:55], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v94, s[52:55], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v95, s[52:55], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v96, s[52:55], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v97, s[52:55], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v98, s[52:55], 0 offen lds
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
		buffer_load_dwordx4 v15, s[56:59], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[56:59], 0 offen lds
		buffer_load_ubyte v43, v100, s[72:75], 0 offen
		buffer_load_ubyte v99, v103, s[72:75], 0 offen
		buffer_load_ubyte v101, v104, s[72:75], 0 offen
		buffer_load_ubyte v102, v105, s[72:75], 0 offen
		buffer_load_ubyte v109, v106, s[72:75], 0 offen
		buffer_load_ubyte v110, v107, s[72:75], 0 offen
		buffer_load_ubyte v111, v108, s[72:75], 0 offen
		buffer_load_ubyte v112, v42, s[72:75], 0 offen
		buffer_load_ubyte v117, v113, s[76:79], 0 offen
		buffer_load_ubyte v118, v114, s[76:79], 0 offen
		buffer_load_ubyte v119, v115, s[76:79], 0 offen
		buffer_load_ubyte v120, v116, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[188:191], v[124:127], a[112:115], v70, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[192:195], v[128:131], a[112:115], v70, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[196:199], v[124:127], a[116:119], v70, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[200:203], v[128:131], a[116:119], v70, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v252, v71
		v_mov_b32_e32 v253, v70
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[204:207], v[124:127], a[120:123], v252, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[208:211], v[128:131], a[120:123], v252, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[124:127], a[124:127], v252, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[128:131], a[124:127], v252, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[188:191], v[132:135], a[128:131], v70, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[192:195], v[136:139], a[128:131], v70, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[196:199], v[132:135], a[132:135], v70, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[200:203], v[136:139], a[132:135], v70, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[204:207], v[132:135], a[136:139], v252, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[208:211], v[136:139], a[136:139], v252, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[212:215], v[132:135], a[140:143], v252, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[136:139], a[140:143], v252, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[188:191], v[140:143], a[144:147], v70, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[192:195], v[144:147], a[144:147], v70, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[196:199], v[140:143], a[148:151], v70, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[200:203], v[144:147], a[148:151], v70, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[204:207], v[140:143], a[152:155], v252, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[208:211], v[144:147], a[152:155], v252, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[212:215], v[140:143], a[156:159], v252, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[144:147], a[156:159], v252, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[188:191], v[148:151], a[160:163], v70, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[192:195], v[152:155], a[160:163], v70, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[196:199], v[148:151], a[164:167], v70, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[200:203], v[152:155], a[164:167], v70, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[204:207], v[148:151], a[168:171], v252, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[208:211], v[152:155], a[168:171], v252, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[212:215], v[148:151], a[172:175], v252, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[216:219], v[152:155], a[172:175], v252, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[188:191], v[156:159], a[176:179], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[192:195], v[160:163], a[176:179], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[196:199], v[156:159], a[180:183], v70, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[200:203], v[160:163], a[180:183], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[204:207], v[156:159], a[184:187], v252, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[208:211], v[160:163], a[184:187], v252, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[212:215], v[156:159], a[188:191], v252, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[216:219], v[160:163], a[188:191], v252, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[188:191], v[164:167], a[192:195], v70, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[192:195], v[168:171], a[192:195], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[196:199], v[164:167], a[196:199], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[200:203], v[168:171], a[196:199], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[204:207], v[164:167], a[200:203], v252, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[208:211], v[168:171], a[200:203], v252, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[212:215], v[164:167], a[204:207], v252, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[216:219], v[168:171], a[204:207], v252, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[188:191], v[172:175], a[208:211], v70, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[192:195], v[176:179], a[208:211], v70, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[196:199], v[172:175], a[212:215], v70, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[200:203], v[176:179], a[212:215], v70, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[204:207], v[172:175], a[216:219], v252, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[208:211], v[176:179], a[216:219], v252, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[212:215], v[172:175], a[220:223], v252, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[216:219], v[176:179], a[220:223], v252, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[188:191], v[180:183], a[224:227], v70, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[192:195], v[184:187], a[224:227], v70, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[196:199], v[180:183], a[228:231], v70, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[200:203], v[184:187], a[228:231], v70, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[204:207], v[180:183], a[232:235], v252, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[208:211], v[184:187], a[232:235], v252, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[212:215], v[180:183], a[236:239], v252, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[216:219], v[184:187], a[236:239], v252, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[128:131], v83
		ds_read_b128 v[132:135], v83 offset:64
		ds_read_b128 v[136:139], v83 offset:256
		ds_read_b128 v[140:143], v83 offset:320
		ds_read_b128 v[144:147], v83 offset:512
		ds_read_b128 v[148:151], v83 offset:576
		ds_read_b128 v[152:155], v83 offset:768
		ds_read_b128 v[156:159], v83 offset:832
		ds_read_b128 v[160:163], v83 offset:16896
		ds_read_b128 v[164:167], v83 offset:16960
		ds_read_b128 v[168:171], v83 offset:17152
		ds_read_b128 v[172:175], v83 offset:17216
		ds_read_b128 v[176:179], v83 offset:17408
		ds_read_b128 v[180:183], v83 offset:17472
		ds_read_b128 v[184:187], v83 offset:17664
		ds_read_b128 v[188:191], v83 offset:17728
		ds_read_b128 v[124:127], v84 offset:1984
		ds_read_b128 v[192:195], v84 offset:2048
		ds_read_b128 v[196:199], v84 offset:2240
		ds_read_b128 v[200:203], v84 offset:2304
		ds_read_b128 v[204:207], v84 offset:2496
		ds_read_b128 v[208:211], v84 offset:2560
		ds_read_b128 v[212:215], v84 offset:2752
		ds_read_b128 v[216:219], v84 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v221, v54 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v220, v64 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v62, v76 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v63, v222 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v56, v223 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v58, v224 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v60, v225 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v47, v226 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v16, v227 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v49, v228 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v50, v229 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v45, v230 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[70:71], v46 offset:3904
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v65, 0xff, v70
		v_lshrrev_b32_e32 v37, 8, v70
		v_and_b32_e32 v74, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v70
		v_and_b32_e32 v75, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v70
		v_and_b32_e32 v68, 0xff, v37
		v_and_b32_e32 v66, 0xff, v71
		v_lshrrev_b32_e32 v37, 8, v71
		v_and_b32_e32 v222, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v71
		v_and_b32_e32 v224, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v71
		v_and_b32_e32 v76, 0xff, v37
		ds_read_b64_tr_b8 v[70:71], v46 offset:4032
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v67, 0xff, v70
		v_lshrrev_b32_e32 v37, 8, v70
		v_and_b32_e32 v228, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v70
		v_and_b32_e32 v229, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v70
		v_and_b32_e32 v226, 0xff, v37
		v_and_b32_e32 v225, 0xff, v71
		v_lshrrev_b32_e32 v37, 8, v71
		v_and_b32_e32 v231, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v71
		v_and_b32_e32 v232, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v71
		v_and_b32_e32 v230, 0xff, v37
		ds_read_b64_tr_b8 v[70:71], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v54, 0xff, v70
		v_lshrrev_b32_e32 v37, 8, v70
		v_and_b32_e32 v223, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v70
		v_and_b32_e32 v227, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v70
		v_and_b32_e32 v233, 0xff, v37
		v_and_b32_e32 v64, 0xff, v71
		v_lshrrev_b32_e32 v37, 8, v71
		v_and_b32_e32 v236, 0xff, v37
		v_lshrrev_b32_e32 v37, 16, v71
		v_and_b32_e32 v237, 0xff, v37
		v_lshrrev_b32_e32 v37, 24, v71
		s_mov_b32 m0, s1
		v_and_b32_e32 v235, 0xff, v37
		buffer_load_dwordx4 v121, s[56:59], 0 offen lds
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v122, s[56:59], 0 offen lds
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v123, s[56:59], 0 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v32, s[56:59], 0 offen lds
		buffer_load_ubyte v37, v33, s[76:79], 0 offen
		buffer_load_ubyte v70, v35, s[76:79], 0 offen
		buffer_load_ubyte v71, v36, s[76:79], 0 offen
		buffer_load_ubyte v81, v10, s[76:79], 0 offen
		s_add_i32 s19, s19, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s20, s20, 16
		s_add_i32 s41, s41, 16
		s_add_i32 s21, s21, 2
		s_cmp_lt_i32 s21, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		v_and_b32_e32 v2, 0xff, v65
		v_and_b32_e32 v8, 0xff, v74
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v75
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v68
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v2, v2, v8, v9
		v_and_b32_e32 v8, 0xff, v66
		v_and_b32_e32 v9, 0xff, v222
		v_lshlrev_b32_e32 v9, 8, v9
		v_or_b32_e32 v8, v8, v9
		v_and_b32_e32 v9, 0xff, v224
		v_lshlrev_b32_e32 v9, 16, v9
		v_and_b32_e32 v10, 0xff, v76
		v_lshlrev_b32_e32 v10, 24, v10
		v_or3_b32 v8, v8, v9, v10
		v_and_b32_e32 v9, 0xff, v67
		v_and_b32_e32 v10, 0xff, v228
		v_lshlrev_b32_e32 v10, 8, v10
		v_or_b32_e32 v9, v9, v10
		v_and_b32_e32 v10, 0xff, v229
		v_lshlrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v12, 0xff, v226
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v9, v9, v10, v12
		v_and_b32_e32 v10, 0xff, v225
		v_and_b32_e32 v12, 0xff, v231
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v10, v10, v12
		v_and_b32_e32 v12, 0xff, v232
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v15, 0xff, v230
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v10, v10, v12, v15
		v_and_b32_e32 v12, 0xff, v54
		v_and_b32_e32 v15, 0xff, v223
		v_lshlrev_b32_e32 v15, 8, v15
		v_or_b32_e32 v12, v12, v15
		v_and_b32_e32 v15, 0xff, v227
		v_lshlrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v16, 0xff, v233
		v_lshlrev_b32_e32 v16, 24, v16
		v_or3_b32 v12, v12, v15, v16
		v_and_b32_e32 v15, 0xff, v64
		v_and_b32_e32 v16, 0xff, v236
		v_lshlrev_b32_e32 v16, 8, v16
		v_or_b32_e32 v15, v15, v16
		v_and_b32_e32 v16, 0xff, v237
		v_lshlrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v18, 0xff, v235
		v_lshlrev_b32_e32 v18, 24, v18
		v_or3_b32 v15, v15, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[124:127], v[128:131], v[4:7], v12, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[132:135], v[4:7], v12, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[196:199], v[128:131], a[0:3], v12, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[200:203], v[132:135], a[0:3], v12, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[204:207], v[128:131], v[240:243], v15, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[208:211], v[132:135], v[240:243], v15, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[212:215], v[128:131], v[244:247], v15, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[216:219], v[132:135], v[244:247], v15, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[124:127], v[136:139], v[248:251], v12, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[192:195], v[140:143], v[248:251], v12, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[196:199], v[136:139], a[4:7], v12, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[140:143], a[4:7], v12, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[204:207], v[136:139], a[8:11], v15, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[208:211], v[140:143], a[8:11], v15, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[212:215], v[136:139], a[12:15], v15, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[216:219], v[140:143], a[12:15], v15, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[124:127], v[144:147], a[16:19], v12, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[192:195], v[148:151], a[16:19], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[196:199], v[144:147], a[20:23], v12, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[148:151], a[20:23], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[204:207], v[144:147], a[24:27], v15, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[148:151], a[24:27], v15, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[212:215], v[144:147], a[28:31], v15, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[216:219], v[148:151], a[28:31], v15, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[124:127], v[152:155], a[32:35], v12, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[192:195], v[156:159], a[32:35], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[196:199], v[152:155], a[36:39], v12, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[156:159], a[36:39], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[152:155], a[40:43], v15, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[156:159], a[40:43], v15, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[212:215], v[152:155], a[44:47], v15, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[216:219], v[156:159], a[44:47], v15, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[124:127], v[160:163], a[48:51], v12, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[192:195], v[164:167], a[48:51], v12, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[196:199], v[160:163], a[52:55], v12, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[200:203], v[164:167], a[52:55], v12, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[160:163], a[56:59], v15, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[164:167], a[56:59], v15, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[160:163], a[60:63], v15, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[216:219], v[164:167], a[60:63], v15, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[124:127], v[168:171], a[64:67], v12, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[192:195], v[172:175], a[64:67], v12, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[196:199], v[168:171], a[68:71], v12, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[200:203], v[172:175], a[68:71], v12, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[204:207], v[168:171], a[72:75], v15, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[172:175], a[72:75], v15, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[168:171], a[76:79], v15, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[172:175], a[76:79], v15, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[124:127], v[176:179], a[80:83], v12, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[192:195], v[180:183], a[80:83], v12, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[196:199], v[176:179], a[84:87], v12, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[200:203], v[180:183], a[84:87], v12, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[204:207], v[176:179], a[88:91], v15, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[180:183], a[88:91], v15, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[212:215], v[176:179], a[92:95], v15, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[180:183], a[92:95], v15, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[124:127], v[184:187], a[96:99], v12, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[192:195], v[188:191], a[96:99], v12, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[196:199], v[184:187], a[100:103], v12, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[200:203], v[188:191], a[100:103], v12, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[204:207], v[184:187], a[104:107], v15, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[188:191], a[104:107], v15, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[184:187], a[108:111], v15, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[188:191], a[108:111], v15, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[28:31], v84 offset:35712
		ds_read_b128 v[32:35], v84 offset:35776
		ds_read_b128 v[48:51], v84 offset:35968
		ds_read_b128 v[56:59], v84 offset:36032
		ds_read_b128 v[60:63], v84 offset:36224
		ds_read_b128 v[64:67], v84 offset:36288
		ds_read_b128 v[72:75], v84 offset:36480
		ds_read_b128 v[76:79], v84 offset:36544
		v_and_b32_e32 v12, 0xff, v88
		v_and_b32_e32 v15, 0xff, v89
		v_lshlrev_b32_e32 v15, 8, v15
		v_or_b32_e32 v12, v12, v15
		v_and_b32_e32 v15, 0xff, v90
		v_lshlrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v16, 0xff, v91
		v_lshlrev_b32_e32 v16, 24, v16
		v_or3_b32 v12, v12, v15, v16
		ds_write_b32 v234, v12 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[128:131], a[112:115], v26, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], v[132:135], a[112:115], v26, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], v[128:131], a[116:119], v26, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], v[132:135], a[116:119], v26, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v38, v27
		v_mov_b32_e32 v39, v26
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], v[128:131], a[120:123], v38, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], v[132:135], a[120:123], v38, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[72:75], v[128:131], a[124:127], v38, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[76:79], v[132:135], a[124:127], v38, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[136:139], a[128:131], v26, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[140:143], a[128:131], v26, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[136:139], a[132:135], v26, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], v[140:143], a[132:135], v26, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], v[136:139], a[136:139], v38, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], v[140:143], a[136:139], v38, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[72:75], v[136:139], a[140:143], v38, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[140:143], a[140:143], v38, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[144:147], a[144:147], v26, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[148:151], a[144:147], v26, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[144:147], a[148:151], v26, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], v[148:151], a[148:151], v26, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], v[144:147], a[152:155], v38, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], v[148:151], a[152:155], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[72:75], v[144:147], a[156:159], v38, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[76:79], v[148:151], a[156:159], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[152:155], a[160:163], v26, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[156:159], a[160:163], v26, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[152:155], a[164:167], v26, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], v[156:159], a[164:167], v26, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], v[152:155], a[168:171], v38, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], v[156:159], a[168:171], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[72:75], v[152:155], a[172:175], v38, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[76:79], v[156:159], a[172:175], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[160:163], a[176:179], v26, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[164:167], a[176:179], v26, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], v[160:163], a[180:183], v26, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[56:59], v[164:167], a[180:183], v26, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[60:63], v[160:163], a[184:187], v38, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[64:67], v[164:167], a[184:187], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[72:75], v[160:163], a[188:191], v38, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[76:79], v[164:167], a[188:191], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], v[168:171], a[192:195], v26, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[172:175], a[192:195], v26, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[48:51], v[168:171], a[196:199], v26, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], v[172:175], a[196:199], v26, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[60:63], v[168:171], a[200:203], v38, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[64:67], v[172:175], a[200:203], v38, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[72:75], v[168:171], a[204:207], v38, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[76:79], v[172:175], a[204:207], v38, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], v[176:179], a[208:211], v26, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[180:183], a[208:211], v26, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[48:51], v[176:179], a[212:215], v26, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], v[180:183], a[212:215], v26, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[60:63], v[176:179], a[216:219], v38, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[64:67], v[180:183], a[216:219], v38, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[72:75], v[176:179], a[220:223], v38, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[76:79], v[180:183], a[220:223], v38, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[28:31], v[184:187], a[224:227], v26, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], v[188:191], a[224:227], v26, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[48:51], v[184:187], a[228:231], v26, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[56:59], v[188:191], a[228:231], v26, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[60:63], v[184:187], a[232:235], v38, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[64:67], v[188:191], a[232:235], v38, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[72:75], v[184:187], a[236:239], v38, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[76:79], v[188:191], a[236:239], v38, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v83 offset:33760
		ds_read_b128 v[32:35], v83 offset:33824
		ds_read_b128 v[48:51], v83 offset:34016
		ds_read_b128 v[56:59], v83 offset:34080
		ds_read_b128 v[60:63], v83 offset:34272
		ds_read_b128 v[64:67], v83 offset:34336
		ds_read_b128 v[72:75], v83 offset:34528
		ds_read_b128 v[76:79], v83 offset:34592
		ds_read_b128 v[88:91], v83 offset:50656
		ds_read_b128 v[92:95], v83 offset:50720
		ds_read_b128 v[104:107], v83 offset:50912
		ds_read_b128 v[124:127], v83 offset:50976
		ds_read_b128 v[128:131], v83 offset:51168
		ds_read_b128 v[132:135], v83 offset:51232
		ds_read_b128 v[136:139], v83 offset:51424
		ds_read_b128 v[140:143], v83 offset:51488
		ds_read_b128 v[144:147], v84 offset:18848
		ds_read_b128 v[148:151], v84 offset:18912
		ds_read_b128 v[152:155], v84 offset:19104
		ds_read_b128 v[156:159], v84 offset:19168
		ds_read_b128 v[160:163], v84 offset:19360
		ds_read_b128 v[164:167], v84 offset:19424
		ds_read_b128 v[168:171], v84 offset:19616
		ds_read_b128 v[172:175], v84 offset:19680
		v_and_b32_e32 v2, 0xff, v43
		v_and_b32_e32 v8, 0xff, v99
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v101
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v102
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v26, v2, v8, v9
		v_and_b32_e32 v2, 0xff, v109
		v_and_b32_e32 v8, 0xff, v110
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v111
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v112
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v27, v2, v8, v9
		ds_write_b64 v238, v[26:27] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v2, 0xff, v117
		v_and_b32_e32 v8, 0xff, v118
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v2, v2, v8
		v_and_b32_e32 v8, 0xff, v119
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v120
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v2, v2, v8, v9
		ds_write_b32 v234, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v46 offset:3904
		ds_read_b64_tr_b8 v[26:27], v46 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[38:39], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[144:147], v[28:31], v[4:7], v38, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[148:151], v[32:35], v[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[152:155], v[28:31], a[0:3], v38, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[156:159], v[32:35], a[0:3], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v40, v39
		v_mov_b32_e32 v41, v38
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[160:163], v[28:31], v[240:243], v40, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[164:167], v[32:35], v[240:243], v40, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[168:171], v[28:31], v[244:247], v40, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[172:175], v[32:35], v[244:247], v40, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[144:147], v[48:51], v[248:251], v38, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[148:151], v[56:59], v[248:251], v38, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[152:155], v[48:51], a[4:7], v38, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[156:159], v[56:59], a[4:7], v38, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[160:163], v[48:51], a[8:11], v40, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[164:167], v[56:59], a[8:11], v40, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[168:171], v[48:51], a[12:15], v40, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[172:175], v[56:59], a[12:15], v40, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v42, v9
		v_mov_b32_e32 v43, v8
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[144:147], v[60:63], a[16:19], v38, v42 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[148:151], v[64:67], a[16:19], v38, v42 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[152:155], v[60:63], a[20:23], v38, v42 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[156:159], v[64:67], a[20:23], v38, v42 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[160:163], v[60:63], a[24:27], v40, v42 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[164:167], v[64:67], a[24:27], v40, v42 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[168:171], v[60:63], a[28:31], v40, v42 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[172:175], v[64:67], a[28:31], v40, v42 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[144:147], v[72:75], a[32:35], v38, v42 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[148:151], v[76:79], a[32:35], v38, v42 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[152:155], v[72:75], a[36:39], v38, v42 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[156:159], v[76:79], a[36:39], v38, v42 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[160:163], v[72:75], a[40:43], v40, v42 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[164:167], v[76:79], a[40:43], v40, v42 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[168:171], v[72:75], a[44:47], v40, v42 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[172:175], v[76:79], a[44:47], v40, v42 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[144:147], v[88:91], a[48:51], v38, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[148:151], v[92:95], a[48:51], v38, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[152:155], v[88:91], a[52:55], v38, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[156:159], v[92:95], a[52:55], v38, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[160:163], v[88:91], a[56:59], v40, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[164:167], v[92:95], a[56:59], v40, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[168:171], v[88:91], a[60:63], v40, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[172:175], v[92:95], a[60:63], v40, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[144:147], v[104:107], a[64:67], v38, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[148:151], v[124:127], a[64:67], v38, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[152:155], v[104:107], a[68:71], v38, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[156:159], v[124:127], a[68:71], v38, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[160:163], v[104:107], a[72:75], v40, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[164:167], v[124:127], a[72:75], v40, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[168:171], v[104:107], a[76:79], v40, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[172:175], v[124:127], a[76:79], v40, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v44, v27
		v_mov_b32_e32 v45, v26
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[144:147], v[128:131], a[80:83], v38, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[148:151], v[132:135], a[80:83], v38, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[152:155], v[128:131], a[84:87], v38, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[156:159], v[132:135], a[84:87], v38, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[160:163], v[128:131], a[88:91], v40, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[164:167], v[132:135], a[88:91], v40, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[168:171], v[128:131], a[92:95], v40, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[172:175], v[132:135], a[92:95], v40, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[144:147], v[136:139], a[96:99], v38, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[148:151], v[140:143], a[96:99], v38, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[152:155], v[136:139], a[100:103], v38, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[156:159], v[140:143], a[100:103], v38, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[160:163], v[136:139], a[104:107], v40, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[164:167], v[140:143], a[104:107], v40, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[168:171], v[136:139], a[108:111], v40, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[172:175], v[140:143], a[108:111], v40, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v84 offset:52576
		ds_read_b128 v[100:103], v84 offset:52640
		ds_read_b128 v[108:111], v84 offset:52832
		ds_read_b128 v[112:115], v84 offset:52896
		ds_read_b128 v[116:119], v84 offset:53088
		ds_read_b128 v[120:123], v84 offset:53152
		ds_read_b128 v[144:147], v84 offset:53344
		ds_read_b128 v[148:151], v84 offset:53408
		s_waitcnt vmcnt(3)
		v_and_b32_e32 v2, 0xff, v37
		s_waitcnt vmcnt(2)
		v_and_b32_e32 v9, 0xff, v70
		v_lshlrev_b32_e32 v9, 8, v9
		v_or_b32_e32 v2, v2, v9
		s_waitcnt vmcnt(1)
		v_and_b32_e32 v9, 0xff, v71
		v_lshlrev_b32_e32 v9, 16, v9
		s_waitcnt vmcnt(0)
		v_and_b32_e32 v10, 0xff, v81
		v_lshlrev_b32_e32 v10, 24, v10
		v_or3_b32 v2, v2, v9, v10
		ds_write_b32 v234, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[36:37], v52 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v52, v4, v5
		v_cvt_pk_bf16_f32 v53, v6, v7
		v_accvgpr_read_b32 v2, a0
		v_accvgpr_read_b32 v4, a1
		v_cvt_pk_bf16_f32 v68, v2, v4
		v_accvgpr_read_b32 v2, a2
		v_accvgpr_read_b32 v4, a3
		v_cvt_pk_bf16_f32 v69, v2, v4
		v_cvt_pk_bf16_f32 v4, v240, v241
		v_cvt_pk_bf16_f32 v5, v242, v243
		v_cvt_pk_bf16_f32 v80, v244, v245
		v_cvt_pk_bf16_f32 v81, v246, v247
		v_cvt_pk_bf16_f32 v54, v248, v249
		v_cvt_pk_bf16_f32 v55, v250, v251
		v_accvgpr_read_b32 v2, a4
		v_accvgpr_read_b32 v6, a5
		v_cvt_pk_bf16_f32 v70, v2, v6
		v_accvgpr_read_b32 v2, a6
		v_accvgpr_read_b32 v6, a7
		v_cvt_pk_bf16_f32 v71, v2, v6
		v_accvgpr_read_b32 v2, a8
		v_accvgpr_read_b32 v6, a9
		v_cvt_pk_bf16_f32 v6, v2, v6
		v_accvgpr_read_b32 v2, a10
		v_accvgpr_read_b32 v7, a11
		v_cvt_pk_bf16_f32 v7, v2, v7
		v_accvgpr_read_b32 v2, a12
		v_accvgpr_read_b32 v9, a13
		v_cvt_pk_bf16_f32 v82, v2, v9
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v9, a15
		v_cvt_pk_bf16_f32 v83, v2, v9
		v_accvgpr_read_b32 v2, a16
		v_accvgpr_read_b32 v9, a17
		v_cvt_pk_bf16_f32 v84, v2, v9
		v_accvgpr_read_b32 v2, a18
		v_accvgpr_read_b32 v9, a19
		v_cvt_pk_bf16_f32 v85, v2, v9
		v_accvgpr_read_b32 v2, a20
		v_accvgpr_read_b32 v9, a21
		v_cvt_pk_bf16_f32 v152, v2, v9
		v_accvgpr_read_b32 v2, a22
		v_accvgpr_read_b32 v9, a23
		v_cvt_pk_bf16_f32 v153, v2, v9
		v_accvgpr_read_b32 v2, a24
		v_accvgpr_read_b32 v9, a25
		v_cvt_pk_bf16_f32 v156, v2, v9
		v_accvgpr_read_b32 v2, a26
		v_accvgpr_read_b32 v9, a27
		v_cvt_pk_bf16_f32 v157, v2, v9
		v_accvgpr_read_b32 v2, a28
		v_accvgpr_read_b32 v9, a29
		v_cvt_pk_bf16_f32 v160, v2, v9
		v_accvgpr_read_b32 v2, a30
		v_accvgpr_read_b32 v9, a31
		v_cvt_pk_bf16_f32 v161, v2, v9
		v_accvgpr_read_b32 v2, a32
		v_accvgpr_read_b32 v9, a33
		v_cvt_pk_bf16_f32 v86, v2, v9
		v_accvgpr_read_b32 v2, a34
		v_accvgpr_read_b32 v9, a35
		v_cvt_pk_bf16_f32 v87, v2, v9
		v_accvgpr_read_b32 v2, a36
		v_accvgpr_read_b32 v9, a37
		v_cvt_pk_bf16_f32 v154, v2, v9
		v_accvgpr_read_b32 v2, a38
		v_accvgpr_read_b32 v9, a39
		v_cvt_pk_bf16_f32 v155, v2, v9
		v_accvgpr_read_b32 v2, a40
		v_accvgpr_read_b32 v9, a41
		v_cvt_pk_bf16_f32 v158, v2, v9
		v_accvgpr_read_b32 v2, a42
		v_accvgpr_read_b32 v9, a43
		v_cvt_pk_bf16_f32 v159, v2, v9
		v_accvgpr_read_b32 v2, a44
		v_accvgpr_read_b32 v9, a45
		v_cvt_pk_bf16_f32 v162, v2, v9
		v_accvgpr_read_b32 v2, a46
		v_accvgpr_read_b32 v9, a47
		v_cvt_pk_bf16_f32 v163, v2, v9
		v_accvgpr_read_b32 v2, a48
		v_accvgpr_read_b32 v9, a49
		v_cvt_pk_bf16_f32 v164, v2, v9
		v_accvgpr_read_b32 v2, a50
		v_accvgpr_read_b32 v9, a51
		v_cvt_pk_bf16_f32 v165, v2, v9
		v_accvgpr_read_b32 v2, a52
		v_accvgpr_read_b32 v9, a53
		v_cvt_pk_bf16_f32 v168, v2, v9
		v_accvgpr_read_b32 v2, a54
		v_accvgpr_read_b32 v9, a55
		v_cvt_pk_bf16_f32 v169, v2, v9
		v_accvgpr_read_b32 v2, a56
		v_accvgpr_read_b32 v9, a57
		v_cvt_pk_bf16_f32 v172, v2, v9
		v_accvgpr_read_b32 v2, a58
		v_accvgpr_read_b32 v9, a59
		v_cvt_pk_bf16_f32 v173, v2, v9
		v_accvgpr_read_b32 v2, a60
		v_accvgpr_read_b32 v9, a61
		v_cvt_pk_bf16_f32 v176, v2, v9
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v9, a63
		v_cvt_pk_bf16_f32 v177, v2, v9
		v_accvgpr_read_b32 v2, a64
		v_accvgpr_read_b32 v9, a65
		v_cvt_pk_bf16_f32 v166, v2, v9
		v_accvgpr_read_b32 v2, a66
		v_accvgpr_read_b32 v9, a67
		v_cvt_pk_bf16_f32 v167, v2, v9
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v9, a69
		v_cvt_pk_bf16_f32 v170, v2, v9
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v9, a71
		v_cvt_pk_bf16_f32 v171, v2, v9
		v_accvgpr_read_b32 v2, a72
		v_accvgpr_read_b32 v9, a73
		v_cvt_pk_bf16_f32 v174, v2, v9
		v_accvgpr_read_b32 v2, a74
		v_accvgpr_read_b32 v9, a75
		v_cvt_pk_bf16_f32 v175, v2, v9
		v_accvgpr_read_b32 v2, a76
		v_accvgpr_read_b32 v9, a77
		v_cvt_pk_bf16_f32 v178, v2, v9
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v9, a79
		v_cvt_pk_bf16_f32 v179, v2, v9
		v_accvgpr_read_b32 v2, a80
		v_accvgpr_read_b32 v9, a81
		v_cvt_pk_bf16_f32 v180, v2, v9
		v_accvgpr_read_b32 v2, a82
		v_accvgpr_read_b32 v9, a83
		v_cvt_pk_bf16_f32 v181, v2, v9
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v9, a85
		v_cvt_pk_bf16_f32 v184, v2, v9
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v9, a87
		v_cvt_pk_bf16_f32 v185, v2, v9
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v9, a89
		v_cvt_pk_bf16_f32 v188, v2, v9
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v9, a91
		v_cvt_pk_bf16_f32 v189, v2, v9
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v9, a93
		v_cvt_pk_bf16_f32 v192, v2, v9
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v9, a95
		v_cvt_pk_bf16_f32 v193, v2, v9
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v9, a97
		v_cvt_pk_bf16_f32 v182, v2, v9
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v9, a99
		v_cvt_pk_bf16_f32 v183, v2, v9
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v9, a101
		v_cvt_pk_bf16_f32 v186, v2, v9
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v9, a103
		v_cvt_pk_bf16_f32 v187, v2, v9
		v_accvgpr_read_b32 v2, a104
		v_accvgpr_read_b32 v9, a105
		v_cvt_pk_bf16_f32 v190, v2, v9
		v_accvgpr_read_b32 v2, a106
		v_accvgpr_read_b32 v9, a107
		v_cvt_pk_bf16_f32 v191, v2, v9
		v_accvgpr_read_b32 v2, a108
		v_accvgpr_read_b32 v9, a109
		v_cvt_pk_bf16_f32 v194, v2, v9
		v_accvgpr_read_b32 v2, a110
		v_accvgpr_read_b32 v9, a111
		v_cvt_pk_bf16_f32 v195, v2, v9
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v0, 0x20000, v0
		ds_write_b128 v0, v[52:55] offset:6976
		ds_write_b128 v0, v[68:71] offset:11072
		ds_write_b128 v0, v[4:7] offset:15168
		ds_write_b128 v0, v[80:83] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v2, 4, v13
		v_add_u32_e32 v2, 0x20000, v2
		v_lshl_add_u32 v2, v19, 9, v2
		v_lshl_add_u32 v2, v17, 13, v2
		v_lshlrev_b32_e32 v4, 12, v21
		v_add3_u32 v2, v2, v4, v23
		ds_read_b128 v[4:7], v2 offset:6976
		ds_read_b128 v[52:55], v2 offset:7232
		ds_read_b128 v[68:71], v2 offset:9024
		ds_read_b128 v[80:83], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[84:87] offset:6976
		ds_write_b128 v0, v[152:155] offset:11072
		ds_write_b128 v0, v[156:159] offset:15168
		ds_write_b128 v0, v[160:163] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v2 offset:6976
		ds_read_b128 v[152:155], v2 offset:7232
		ds_read_b128 v[156:159], v2 offset:9024
		ds_read_b128 v[160:163], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[164:167] offset:6976
		ds_write_b128 v0, v[168:171] offset:11072
		ds_write_b128 v0, v[172:175] offset:15168
		ds_write_b128 v0, v[176:179] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[164:167], v2 offset:6976
		ds_read_b128 v[168:171], v2 offset:7232
		ds_read_b128 v[172:175], v2 offset:9024
		ds_read_b128 v[176:179], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[180:183] offset:6976
		ds_write_b128 v0, v[184:187] offset:11072
		ds_write_b128 v0, v[188:191] offset:15168
		ds_write_b128 v0, v[192:195] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[180:183], v2 offset:6976
		ds_read_b128 v[184:187], v2 offset:7232
		ds_read_b128 v[188:191], v2 offset:9024
		ds_read_b128 v[192:195], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s1, s1, 1
		s_add_u32 s2, s6, s1
		s_addc_u32 s3, s7, 0
		s_mov_b32 s4, s2
		s_mov_b32 s5, s3
		s_mov_b32 s6, 0x7fffffff
		s_mov_b32 s7, 0x31016000
		v_mov_b64_e32 v[196:197], v[4:5]
		v_mov_b64_e32 v[198:199], v[52:53]
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v4, s17, v1
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v5, s17, v3
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v9, s0, v4, v5
		v_mul_lo_u32 v10, s17, v11
		v_lshlrev_b32_e32 v10, 2, v10
		v_mul_lo_u32 v12, s17, v14
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v9, v9, v10, v12
		v_lshlrev_b32_e32 v13, 7, v17
		v_add3_u32 v9, v9, v20, v13
		v_add3_u32 v9, v9, v22, v24
		buffer_store_dwordx4 v[196:199], v9, s[4:7], 0 offen
		v_mov_b64_e32 v[16:17], v[68:69]
		v_mov_b64_e32 v[18:19], v[80:81]
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v9, 16, v14
		v_lshlrev_b32_e32 v11, 1, v11
		v_xor_b32_e32 v9, v9, v11
		v_xor_b32_e32 v9, v3, v9
		v_xor_b32_e32 v9, v1, v9
		v_mul_lo_u32 v9, s17, v9
		v_lshl_add_u32 v15, v9, 1, s0
		v_add3_u32 v15, v15, v20, v13
		v_add3_u32 v15, v15, v22, v24
		buffer_store_dwordx4 v[16:19], v15, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[6:7]
		v_mov_b64_e32 v[18:19], v[54:55]
		v_add_u32_e32 v6, 32, v14
		v_xor_b32_e32 v6, v6, v11
		v_xor_b32_e32 v6, v3, v6
		v_xor_b32_e32 v6, v1, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshl_add_u32 v7, v6, 1, s0
		v_add3_u32 v7, v7, v20, v13
		v_add3_u32 v7, v7, v22, v24
		buffer_store_dwordx4 v[16:19], v7, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[70:71]
		v_mov_b64_e32 v[18:19], v[82:83]
		v_add_u32_e32 v7, 48, v14
		v_xor_b32_e32 v7, v7, v11
		v_xor_b32_e32 v7, v3, v7
		v_xor_b32_e32 v7, v1, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshl_add_u32 v15, v7, 1, s0
		v_add3_u32 v15, v15, v20, v13
		v_add3_u32 v15, v15, v22, v24
		buffer_store_dwordx4 v[16:19], v15, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[84:85]
		v_mov_b64_e32 v[18:19], v[152:153]
		v_add_u32_e32 v15, 64, v14
		v_xor_b32_e32 v15, v15, v11
		v_xor_b32_e32 v15, v3, v15
		v_xor_b32_e32 v15, v1, v15
		v_mul_lo_u32 v15, s17, v15
		v_lshl_add_u32 v21, v15, 1, s0
		v_add3_u32 v21, v21, v20, v13
		v_add3_u32 v21, v21, v22, v24
		buffer_store_dwordx4 v[16:19], v21, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[156:157]
		v_mov_b64_e32 v[18:19], v[160:161]
		v_add_u32_e32 v21, 0x50, v14
		v_xor_b32_e32 v21, v21, v11
		v_xor_b32_e32 v21, v3, v21
		v_xor_b32_e32 v21, v1, v21
		v_mul_lo_u32 v21, s17, v21
		v_lshl_add_u32 v23, v21, 1, s0
		v_add3_u32 v23, v23, v20, v13
		v_add3_u32 v23, v23, v22, v24
		buffer_store_dwordx4 v[16:19], v23, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[86:87]
		v_mov_b64_e32 v[18:19], v[154:155]
		v_add_u32_e32 v23, 0x60, v14
		v_xor_b32_e32 v23, v23, v11
		v_xor_b32_e32 v23, v3, v23
		v_xor_b32_e32 v23, v1, v23
		v_mul_lo_u32 v23, s17, v23
		v_lshl_add_u32 v25, v23, 1, s0
		v_add3_u32 v25, v25, v20, v13
		v_add3_u32 v25, v25, v22, v24
		buffer_store_dwordx4 v[16:19], v25, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[158:159]
		v_mov_b64_e32 v[18:19], v[162:163]
		v_add_u32_e32 v25, 0x70, v14
		v_xor_b32_e32 v25, v25, v11
		v_xor_b32_e32 v25, v3, v25
		v_xor_b32_e32 v25, v1, v25
		v_mul_lo_u32 v25, s17, v25
		v_lshl_add_u32 v27, v25, 1, s0
		v_add3_u32 v27, v27, v20, v13
		v_add3_u32 v27, v27, v22, v24
		buffer_store_dwordx4 v[16:19], v27, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[164:165]
		v_mov_b64_e32 v[18:19], v[168:169]
		v_add_u32_e32 v27, 0x80, v14
		v_xor_b32_e32 v27, v27, v11
		v_xor_b32_e32 v27, v3, v27
		v_xor_b32_e32 v27, v1, v27
		v_mul_lo_u32 v27, s17, v27
		v_lshl_add_u32 v38, v27, 1, s0
		v_add3_u32 v38, v38, v20, v13
		v_add3_u32 v38, v38, v22, v24
		buffer_store_dwordx4 v[16:19], v38, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[172:173]
		v_mov_b64_e32 v[18:19], v[176:177]
		v_add_u32_e32 v38, 0x90, v14
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v3, v38
		v_xor_b32_e32 v38, v1, v38
		v_mul_lo_u32 v38, s17, v38
		v_lshl_add_u32 v39, v38, 1, s0
		v_add3_u32 v39, v39, v20, v13
		v_add3_u32 v39, v39, v22, v24
		buffer_store_dwordx4 v[16:19], v39, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[166:167]
		v_mov_b64_e32 v[18:19], v[170:171]
		v_add_u32_e32 v39, 0xa0, v14
		v_xor_b32_e32 v39, v39, v11
		v_xor_b32_e32 v39, v3, v39
		v_xor_b32_e32 v39, v1, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshl_add_u32 v40, v39, 1, s0
		v_add3_u32 v40, v40, v20, v13
		v_add3_u32 v40, v40, v22, v24
		buffer_store_dwordx4 v[16:19], v40, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[174:175]
		v_mov_b64_e32 v[18:19], v[178:179]
		v_add_u32_e32 v40, 0xb0, v14
		v_xor_b32_e32 v40, v40, v11
		v_xor_b32_e32 v40, v3, v40
		v_xor_b32_e32 v40, v1, v40
		v_mul_lo_u32 v40, s17, v40
		v_lshl_add_u32 v41, v40, 1, s0
		v_add3_u32 v41, v41, v20, v13
		v_add3_u32 v41, v41, v22, v24
		buffer_store_dwordx4 v[16:19], v41, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[180:181]
		v_mov_b64_e32 v[18:19], v[184:185]
		v_add_u32_e32 v41, 0xc0, v14
		v_xor_b32_e32 v41, v41, v11
		v_xor_b32_e32 v41, v3, v41
		v_xor_b32_e32 v41, v1, v41
		v_mul_lo_u32 v41, s17, v41
		v_lshl_add_u32 v43, v41, 1, s0
		v_add3_u32 v43, v43, v20, v13
		v_add3_u32 v43, v43, v22, v24
		buffer_store_dwordx4 v[16:19], v43, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[188:189]
		v_mov_b64_e32 v[18:19], v[192:193]
		v_add_u32_e32 v43, 0xd0, v14
		v_xor_b32_e32 v43, v43, v11
		v_xor_b32_e32 v43, v3, v43
		v_xor_b32_e32 v43, v1, v43
		v_mul_lo_u32 v43, s17, v43
		v_lshl_add_u32 v45, v43, 1, s0
		v_add3_u32 v45, v45, v20, v13
		v_add3_u32 v45, v45, v22, v24
		buffer_store_dwordx4 v[16:19], v45, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[182:183]
		v_mov_b64_e32 v[18:19], v[186:187]
		v_add_u32_e32 v45, 0xe0, v14
		v_xor_b32_e32 v45, v45, v11
		v_xor_b32_e32 v45, v3, v45
		v_xor_b32_e32 v45, v1, v45
		v_mul_lo_u32 v45, s17, v45
		v_lshl_add_u32 v46, v45, 1, s0
		v_add3_u32 v46, v46, v20, v13
		v_add3_u32 v46, v46, v22, v24
		buffer_store_dwordx4 v[16:19], v46, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[16:17], v[190:191]
		v_mov_b64_e32 v[18:19], v[194:195]
		v_add_u32_e32 v14, 0xf0, v14
		v_xor_b32_e32 v11, v14, v11
		v_xor_b32_e32 v3, v3, v11
		v_xor_b32_e32 v1, v1, v3
		v_mul_lo_u32 v1, s17, v1
		v_lshl_add_u32 v3, v1, 1, s0
		v_add3_u32 v3, v3, v20, v13
		v_add3_u32 v3, v3, v22, v24
		buffer_store_dwordx4 v[16:19], v3, s[4:7], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[28:31], a[112:115], v36, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[32:35], a[112:115], v36, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[108:111], v[28:31], a[116:119], v36, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[32:35], a[116:119], v36, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mov_b32_e32 v16, v37
		v_mov_b32_e32 v17, v36
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[116:119], v[28:31], a[120:123], v16, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[120:123], v[32:35], a[120:123], v16, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[144:147], v[28:31], a[124:127], v16, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[148:151], v[32:35], a[124:127], v16, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[48:51], a[128:131], v36, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[56:59], a[128:131], v36, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[108:111], v[48:51], a[132:135], v36, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[56:59], a[132:135], v36, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[116:119], v[48:51], a[136:139], v16, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[120:123], v[56:59], a[136:139], v16, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], v[48:51], a[140:143], v16, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[148:151], v[56:59], a[140:143], v16, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[60:63], a[144:147], v36, v42 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[64:67], a[144:147], v36, v42 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[60:63], a[148:151], v36, v42 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[64:67], a[148:151], v36, v42 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[116:119], v[60:63], a[152:155], v16, v42 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[120:123], v[64:67], a[152:155], v16, v42 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[144:147], v[60:63], a[156:159], v16, v42 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[148:151], v[64:67], a[156:159], v16, v42 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[72:75], a[160:163], v36, v42 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[76:79], a[160:163], v36, v42 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[72:75], a[164:167], v36, v42 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[76:79], a[164:167], v36, v42 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[116:119], v[72:75], a[168:171], v16, v42 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[120:123], v[76:79], a[168:171], v16, v42 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], v[72:75], a[172:175], v16, v42 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[148:151], v[76:79], a[172:175], v16, v42 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[88:91], a[176:179], v36, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[92:95], a[176:179], v36, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[88:91], a[180:183], v36, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[92:95], a[180:183], v36, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[116:119], v[88:91], a[184:187], v16, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[120:123], v[92:95], a[184:187], v16, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], v[88:91], a[188:191], v16, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[148:151], v[92:95], a[188:191], v16, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[104:107], a[192:195], v36, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[124:127], a[192:195], v36, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[108:111], v[104:107], a[196:199], v36, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[124:127], a[196:199], v36, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[116:119], v[104:107], a[200:203], v16, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[120:123], v[124:127], a[200:203], v16, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[144:147], v[104:107], a[204:207], v16, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[148:151], v[124:127], a[204:207], v16, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[96:99], v[128:131], a[208:211], v36, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[132:135], a[208:211], v36, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[108:111], v[128:131], a[212:215], v36, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[132:135], a[212:215], v36, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[116:119], v[128:131], a[216:219], v16, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[120:123], v[132:135], a[216:219], v16, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[144:147], v[128:131], a[220:223], v16, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[148:151], v[132:135], a[220:223], v16, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[96:99], v[136:139], a[224:227], v36, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[100:103], v[140:143], a[224:227], v36, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[108:111], v[136:139], a[228:231], v36, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[140:143], a[228:231], v36, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[116:119], v[136:139], a[232:235], v16, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[120:123], v[140:143], a[232:235], v16, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[144:147], v[136:139], a[236:239], v16, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[148:151], v[140:143], a[236:239], v16, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v3, a112
		v_accvgpr_read_b32 v8, a113
		v_cvt_pk_bf16_f32 v16, v3, v8
		v_accvgpr_read_b32 v3, a114
		v_accvgpr_read_b32 v8, a115
		v_cvt_pk_bf16_f32 v17, v3, v8
		v_accvgpr_read_b32 v3, a116
		v_accvgpr_read_b32 v8, a117
		v_cvt_pk_bf16_f32 v28, v3, v8
		v_accvgpr_read_b32 v3, a118
		v_accvgpr_read_b32 v8, a119
		v_cvt_pk_bf16_f32 v29, v3, v8
		v_accvgpr_read_b32 v3, a120
		v_accvgpr_read_b32 v8, a121
		v_cvt_pk_bf16_f32 v32, v3, v8
		v_accvgpr_read_b32 v3, a122
		v_accvgpr_read_b32 v8, a123
		v_cvt_pk_bf16_f32 v33, v3, v8
		v_accvgpr_read_b32 v3, a124
		v_accvgpr_read_b32 v8, a125
		v_cvt_pk_bf16_f32 v48, v3, v8
		v_accvgpr_read_b32 v3, a126
		v_accvgpr_read_b32 v8, a127
		v_cvt_pk_bf16_f32 v49, v3, v8
		v_accvgpr_read_b32 v3, a128
		v_accvgpr_read_b32 v8, a129
		v_cvt_pk_bf16_f32 v18, v3, v8
		v_accvgpr_read_b32 v3, a130
		v_accvgpr_read_b32 v8, a131
		v_cvt_pk_bf16_f32 v19, v3, v8
		v_accvgpr_read_b32 v3, a132
		v_accvgpr_read_b32 v8, a133
		v_cvt_pk_bf16_f32 v30, v3, v8
		v_accvgpr_read_b32 v3, a134
		v_accvgpr_read_b32 v8, a135
		v_cvt_pk_bf16_f32 v31, v3, v8
		v_accvgpr_read_b32 v3, a136
		v_accvgpr_read_b32 v8, a137
		v_cvt_pk_bf16_f32 v34, v3, v8
		v_accvgpr_read_b32 v3, a138
		v_accvgpr_read_b32 v8, a139
		v_cvt_pk_bf16_f32 v35, v3, v8
		v_accvgpr_read_b32 v3, a140
		v_accvgpr_read_b32 v8, a141
		v_cvt_pk_bf16_f32 v50, v3, v8
		v_accvgpr_read_b32 v3, a142
		v_accvgpr_read_b32 v8, a143
		v_cvt_pk_bf16_f32 v51, v3, v8
		v_accvgpr_read_b32 v3, a144
		v_accvgpr_read_b32 v8, a145
		v_cvt_pk_bf16_f32 v52, v3, v8
		v_accvgpr_read_b32 v3, a146
		v_accvgpr_read_b32 v8, a147
		v_cvt_pk_bf16_f32 v53, v3, v8
		v_accvgpr_read_b32 v3, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v56, v3, v8
		v_accvgpr_read_b32 v3, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v57, v3, v8
		v_accvgpr_read_b32 v3, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v60, v3, v8
		v_accvgpr_read_b32 v3, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v61, v3, v8
		v_accvgpr_read_b32 v3, a156
		v_accvgpr_read_b32 v8, a157
		v_cvt_pk_bf16_f32 v64, v3, v8
		v_accvgpr_read_b32 v3, a158
		v_accvgpr_read_b32 v8, a159
		v_cvt_pk_bf16_f32 v65, v3, v8
		v_accvgpr_read_b32 v3, a160
		v_accvgpr_read_b32 v8, a161
		v_cvt_pk_bf16_f32 v54, v3, v8
		v_accvgpr_read_b32 v3, a162
		v_accvgpr_read_b32 v8, a163
		v_cvt_pk_bf16_f32 v55, v3, v8
		v_accvgpr_read_b32 v3, a164
		v_accvgpr_read_b32 v8, a165
		v_cvt_pk_bf16_f32 v58, v3, v8
		v_accvgpr_read_b32 v3, a166
		v_accvgpr_read_b32 v8, a167
		v_cvt_pk_bf16_f32 v59, v3, v8
		v_accvgpr_read_b32 v3, a168
		v_accvgpr_read_b32 v8, a169
		v_cvt_pk_bf16_f32 v62, v3, v8
		v_accvgpr_read_b32 v3, a170
		v_accvgpr_read_b32 v8, a171
		v_cvt_pk_bf16_f32 v63, v3, v8
		v_accvgpr_read_b32 v3, a172
		v_accvgpr_read_b32 v8, a173
		v_cvt_pk_bf16_f32 v66, v3, v8
		v_accvgpr_read_b32 v3, a174
		v_accvgpr_read_b32 v8, a175
		v_cvt_pk_bf16_f32 v67, v3, v8
		v_accvgpr_read_b32 v3, a176
		v_accvgpr_read_b32 v8, a177
		v_cvt_pk_bf16_f32 v68, v3, v8
		v_accvgpr_read_b32 v3, a178
		v_accvgpr_read_b32 v8, a179
		v_cvt_pk_bf16_f32 v69, v3, v8
		v_accvgpr_read_b32 v3, a180
		v_accvgpr_read_b32 v8, a181
		v_cvt_pk_bf16_f32 v72, v3, v8
		v_accvgpr_read_b32 v3, a182
		v_accvgpr_read_b32 v8, a183
		v_cvt_pk_bf16_f32 v73, v3, v8
		v_accvgpr_read_b32 v3, a184
		v_accvgpr_read_b32 v8, a185
		v_cvt_pk_bf16_f32 v76, v3, v8
		v_accvgpr_read_b32 v3, a186
		v_accvgpr_read_b32 v8, a187
		v_cvt_pk_bf16_f32 v77, v3, v8
		v_accvgpr_read_b32 v3, a188
		v_accvgpr_read_b32 v8, a189
		v_cvt_pk_bf16_f32 v80, v3, v8
		v_accvgpr_read_b32 v3, a190
		v_accvgpr_read_b32 v8, a191
		v_cvt_pk_bf16_f32 v81, v3, v8
		v_accvgpr_read_b32 v3, a192
		v_accvgpr_read_b32 v8, a193
		v_cvt_pk_bf16_f32 v70, v3, v8
		v_accvgpr_read_b32 v3, a194
		v_accvgpr_read_b32 v8, a195
		v_cvt_pk_bf16_f32 v71, v3, v8
		v_accvgpr_read_b32 v3, a196
		v_accvgpr_read_b32 v8, a197
		v_cvt_pk_bf16_f32 v74, v3, v8
		v_accvgpr_read_b32 v3, a198
		v_accvgpr_read_b32 v8, a199
		v_cvt_pk_bf16_f32 v75, v3, v8
		v_accvgpr_read_b32 v3, a200
		v_accvgpr_read_b32 v8, a201
		v_cvt_pk_bf16_f32 v78, v3, v8
		v_accvgpr_read_b32 v3, a202
		v_accvgpr_read_b32 v8, a203
		v_cvt_pk_bf16_f32 v79, v3, v8
		v_accvgpr_read_b32 v3, a204
		v_accvgpr_read_b32 v8, a205
		v_cvt_pk_bf16_f32 v82, v3, v8
		v_accvgpr_read_b32 v3, a206
		v_accvgpr_read_b32 v8, a207
		v_cvt_pk_bf16_f32 v83, v3, v8
		v_accvgpr_read_b32 v3, a208
		v_accvgpr_read_b32 v8, a209
		v_cvt_pk_bf16_f32 v84, v3, v8
		v_accvgpr_read_b32 v3, a210
		v_accvgpr_read_b32 v8, a211
		v_cvt_pk_bf16_f32 v85, v3, v8
		v_accvgpr_read_b32 v3, a212
		v_accvgpr_read_b32 v8, a213
		v_cvt_pk_bf16_f32 v88, v3, v8
		v_accvgpr_read_b32 v3, a214
		v_accvgpr_read_b32 v8, a215
		v_cvt_pk_bf16_f32 v89, v3, v8
		v_accvgpr_read_b32 v3, a216
		v_accvgpr_read_b32 v8, a217
		v_cvt_pk_bf16_f32 v92, v3, v8
		v_accvgpr_read_b32 v3, a218
		v_accvgpr_read_b32 v8, a219
		v_cvt_pk_bf16_f32 v93, v3, v8
		v_accvgpr_read_b32 v3, a220
		v_accvgpr_read_b32 v8, a221
		v_cvt_pk_bf16_f32 v96, v3, v8
		v_accvgpr_read_b32 v3, a222
		v_accvgpr_read_b32 v8, a223
		v_cvt_pk_bf16_f32 v97, v3, v8
		v_accvgpr_read_b32 v3, a224
		v_accvgpr_read_b32 v8, a225
		v_cvt_pk_bf16_f32 v86, v3, v8
		v_accvgpr_read_b32 v3, a226
		v_accvgpr_read_b32 v8, a227
		v_cvt_pk_bf16_f32 v87, v3, v8
		v_accvgpr_read_b32 v3, a228
		v_accvgpr_read_b32 v8, a229
		v_cvt_pk_bf16_f32 v90, v3, v8
		v_accvgpr_read_b32 v3, a230
		v_accvgpr_read_b32 v8, a231
		v_cvt_pk_bf16_f32 v91, v3, v8
		v_accvgpr_read_b32 v3, a232
		v_accvgpr_read_b32 v8, a233
		v_cvt_pk_bf16_f32 v94, v3, v8
		v_accvgpr_read_b32 v3, a234
		v_accvgpr_read_b32 v8, a235
		v_cvt_pk_bf16_f32 v95, v3, v8
		v_accvgpr_read_b32 v3, a236
		v_accvgpr_read_b32 v8, a237
		v_cvt_pk_bf16_f32 v98, v3, v8
		v_accvgpr_read_b32 v3, a238
		v_accvgpr_read_b32 v8, a239
		v_cvt_pk_bf16_f32 v99, v3, v8
		ds_write_b128 v0, v[16:19] offset:6976
		ds_write_b128 v0, v[28:31] offset:11072
		ds_write_b128 v0, v[32:35] offset:15168
		ds_write_b128 v0, v[48:51] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v2 offset:6976
		ds_read_b128 v[28:31], v2 offset:7232
		ds_read_b128 v[32:35], v2 offset:9024
		ds_read_b128 v[48:51], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[52:55] offset:6976
		ds_write_b128 v0, v[56:59] offset:11072
		ds_write_b128 v0, v[60:63] offset:15168
		ds_write_b128 v0, v[64:67] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[52:55], v2 offset:6976
		ds_read_b128 v[56:59], v2 offset:7232
		ds_read_b128 v[60:63], v2 offset:9024
		ds_read_b128 v[64:67], v2 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[68:71] offset:6976
		ds_write_b128 v0, v[72:75] offset:11072
		ds_write_b128 v0, v[76:79] offset:15168
		ds_write_b128 v0, v[80:83] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v2 offset:6976
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
		v_mov_b64_e32 v[100:101], v[16:17]
		v_mov_b64_e32 v[102:103], v[28:29]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v4, v5
		v_add3_u32 v0, v0, v10, v12
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[100:103], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[100:101], v[32:33]
		v_mov_b64_e32 v[102:103], v[48:49]
		v_lshl_add_u32 v0, v9, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[100:103], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[8:9], v[18:19]
		v_mov_b64_e32 v[10:11], v[30:31]
		v_lshl_add_u32 v0, v6, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[8:11], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[34:35]
		v_mov_b64_e32 v[10:11], v[50:51]
		v_lshl_add_u32 v0, v7, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[8:11], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[4:5], v[52:53]
		v_mov_b64_e32 v[6:7], v[56:57]
		v_lshl_add_u32 v0, v15, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[60:61]
		v_mov_b64_e32 v[6:7], v[64:65]
		v_lshl_add_u32 v0, v21, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[54:55]
		v_mov_b64_e32 v[6:7], v[58:59]
		v_lshl_add_u32 v0, v23, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[62:63]
		v_mov_b64_e32 v[6:7], v[66:67]
		v_lshl_add_u32 v0, v25, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[68:69]
		v_mov_b64_e32 v[6:7], v[72:73]
		v_lshl_add_u32 v0, v27, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[76:77]
		v_mov_b64_e32 v[6:7], v[80:81]
		v_lshl_add_u32 v0, v38, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[70:71]
		v_mov_b64_e32 v[6:7], v[74:75]
		v_lshl_add_u32 v0, v39, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[78:79]
		v_mov_b64_e32 v[6:7], v[82:83]
		v_lshl_add_u32 v0, v40, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[84:85]
		v_mov_b64_e32 v[6:7], v[88:89]
		v_lshl_add_u32 v0, v41, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[92:93]
		v_mov_b64_e32 v[6:7], v[96:97]
		v_lshl_add_u32 v0, v43, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[86:87]
		v_mov_b64_e32 v[6:7], v[90:91]
		v_lshl_add_u32 v0, v45, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[94:95]
		v_mov_b64_e32 v[6:7], v[98:99]
		v_lshl_add_u32 v0, v1, 1, s0
		v_add3_u32 v0, v0, v20, v13
		v_add3_u32 v0, v0, v22, v24
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
		.amdhsa_next_free_vgpr 496
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
	.set .L_a4w4_kernel.num_vgpr, 254
	.set .L_a4w4_kernel.num_agpr, 240
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
    .vgpr_count:     496
    .agpr_count:     240
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 61
    wave.regalloc.agpr.dwords: 240
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
