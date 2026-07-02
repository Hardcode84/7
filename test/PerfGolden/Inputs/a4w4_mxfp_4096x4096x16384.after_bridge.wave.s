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
		v_add3_u32 v25, v2, v8, v12
		v_add3_u32 v25, v25, v14, v17
		v_add3_u32 v25, v25, v19, v21
		v_add3_u32 v26, v23, v25, s29
		s_add_i32 s30, s22, 0x2100
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mul_i32 s31, 12, s14
		v_add3_u32 v27, v23, v25, s31
		s_add_i32 s32, s22, 0x3180
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_lshl_b32 s33, s14, 7
		v_add3_u32 v25, v23, v25, s33
		s_add_i32 s34, s22, 0x4200
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s35, 0x84, s14
		v_add3_u32 v28, v2, v8, v12
		v_add3_u32 v28, v28, v14, v17
		v_add3_u32 v28, v28, v19, v21
		v_add3_u32 v29, v23, v28, s35
		s_add_i32 s36, s22, 0x5280
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s37, 0x88, s14
		v_add3_u32 v30, v23, v28, s37
		s_add_i32 s38, s22, 0x6300
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		v_add3_u32 v28, v23, v28, s14
		s_add_i32 s39, s22, 0x7380
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
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
		v_add3_u32 v37, v31, v32, v34
		v_add3_u32 v37, v37, v35, v36
		v_add3_u32 v37, v37, v19, v21
		v_add3_u32 v38, v23, v37, s41
		s_add_i32 s42, s22, 0x11840
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		s_lshl_b32 s43, s15, 3
		v_add3_u32 v39, v23, v37, s43
		s_add_i32 s48, s22, 0x128c0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		s_mul_i32 s49, 12, s15
		v_add3_u32 v37, v23, v37, s49
		s_add_i32 s50, s22, 0x13940
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v37, s[44:47], 0 offen lds
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
		v_add3_u32 v43, v18, v43, v44
		v_add3_u32 v44, v71, v43, s51
		v_mul_lo_u32 v71, s19, v51
		v_add3_u32 v71, v71, v43, s51
		v_mul_lo_u32 v72, s19, v53
		v_add3_u32 v43, v72, v43, s51
		buffer_load_ubyte v72, v68, s[56:59], 0 offen
		buffer_load_ubyte v73, v44, s[56:59], 0 offen
		buffer_load_ubyte v74, v71, s[56:59], 0 offen
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
		v_add3_u32 v77, v31, v32, v34
		v_add3_u32 v77, v77, v35, v36
		v_add3_u32 v77, v77, v19, v21
		v_add3_u32 v78, v23, v77, s62
		s_add_i32 s63, s22, 0x19c00
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v78, s[44:47], 0 offen lds
		s_mul_i32 s64, 0x88, s15
		v_add3_u32 v79, v23, v77, s64
		s_add_i32 s65, s22, 0x1ac80
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v79, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v77, v23, v77, s15
		s_add_i32 s66, s22, 0x1bd00
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v77, s[44:47], 0 offen lds
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
		v_add3_u32 v84, v80, v69, v70
		v_add3_u32 v84, v84, v82, v83
		v_add3_u32 v85, v10, v84, s69
		s_mul_i32 s69, 0x82, s19
		s_add_i32 s70, s69, s51
		v_add3_u32 v86, v10, v84, s70
		s_mul_i32 s70, 0x83, s19
		s_add_i32 s71, s70, s51
		v_add3_u32 v84, v10, v84, s71
		buffer_load_ubyte_d16 v87, v81, s[56:59], 0 offen
		buffer_load_ubyte_d16 v88, v85, s[56:59], 0 offen
		v_mov_b32_e32 v89, 0
		buffer_load_ubyte_d16_hi v89, v86, s[56:59], 0 offen
		v_mov_b32_e32 v90, 0
		buffer_load_ubyte_d16_hi v90, v84, s[56:59], 0 offen
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
		v_add3_u32 v12, v31, v32, v34
		v_add3_u32 v12, v12, v35, v36
		v_add3_u32 v12, v12, v19, v21
		v_add3_u32 v14, v23, v12, s25
		s_add_i32 s25, s22, 0x15a20
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 s26, s43, 0x80
		v_add3_u32 v17, v23, v12, s26
		s_add_i32 s26, s22, 0x16aa0
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v17, s[44:47], 0 offen lds
		s_add_i32 s27, s49, 0x80
		v_add3_u32 v12, v23, v12, s27
		s_add_i32 s27, s22, 0x17b20
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
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
		v_add3_u32 v103, v98, v41, v42
		v_add3_u32 v103, v103, v100, v101
		v_add3_u32 v104, v10, v103, s41
		s_mul_i32 s41, 3, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v105, v10, v103, s41
		s_lshl_b32 s41, s18, 2
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v103, v10, v103, s41
		s_mul_i32 s41, 5, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v41, v98, v41, v42
		v_add3_u32 v41, v41, v100, v101
		v_add3_u32 v42, v10, v41, s41
		s_mul_i32 s41, 6, s18
		s_add_i32 s41, s41, 8
		s_add_i32 s41, s41, s1
		s_add_i32 s41, s41, s16
		v_add3_u32 v98, v10, v41, s41
		s_mul_i32 s18, 7, s18
		s_add_i32 s18, s18, 8
		s_add_i32 s1, s18, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v41, v10, v41, s1
		buffer_load_ubyte_d16 v100, v99, s[52:55], 0 offen
		buffer_load_ubyte_d16 v101, v102, s[52:55], 0 offen
		v_mov_b32_e32 v106, 0
		buffer_load_ubyte_d16_hi v106, v104, s[52:55], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v105, s[52:55], 0 offen
		buffer_load_ubyte_d16 v108, v103, s[52:55], 0 offen
		buffer_load_ubyte_d16 v109, v42, s[52:55], 0 offen
		v_mov_b32_e32 v110, 0
		buffer_load_ubyte_d16_hi v110, v98, s[52:55], 0 offen
		v_mov_b32_e32 v111, 0
		buffer_load_ubyte_d16_hi v111, v41, s[52:55], 0 offen
		s_add_i32 s1, s51, 8
		v_add3_u32 v112, s1, v80, v69
		v_add3_u32 v112, v112, v70, v82
		v_add3_u32 v112, v112, v83, v10
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v113, v80, v69, v70
		v_add3_u32 v113, v113, v82, v83
		v_add3_u32 v114, v10, v113, s1
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v115, v10, v113, s1
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s51
		v_add3_u32 v113, v10, v113, s1
		buffer_load_ubyte_d16 v116, v112, s[56:59], 0 offen
		buffer_load_ubyte_d16 v117, v114, s[56:59], 0 offen
		v_mov_b32_e32 v118, 0
		buffer_load_ubyte_d16_hi v118, v115, s[56:59], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v113, s[56:59], 0 offen
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
		v_add3_u32 v31, v31, v32, v34
		v_add3_u32 v31, v31, v35, v36
		v_add3_u32 v31, v31, v19, v21
		v_add3_u32 v32, v23, v31, s16
		s_add_i32 s16, s22, 0x1dde0
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v32, s[44:47], 0 offen lds
		s_add_i32 s18, s64, 0x80
		v_add3_u32 v34, v23, v31, s18
		s_add_i32 s18, s22, 0x1ee60
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v34, s[44:47], 0 offen lds
		s_add_i32 s15, s15, 0x80
		v_add3_u32 v31, v23, v31, s15
		s_add_i32 s15, s22, 0x1fee0
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_add_i32 s19, s67, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v35, s19, v80, v69
		v_add3_u32 v35, v35, v70, v82
		v_add3_u32 v35, v35, v83, v10
		s_add_i32 s19, s68, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v36, v80, v69, v70
		v_add3_u32 v36, v36, v82, v83
		v_add3_u32 v69, v10, v36, s19
		s_add_i32 s19, s69, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v70, v10, v36, s19
		s_add_i32 s19, s70, 8
		s_add_i32 s19, s19, s51
		v_add3_u32 v10, v10, v36, s19
		buffer_load_ubyte_d16 v36, v35, s[56:59], 0 offen
		buffer_load_ubyte_d16 v80, v69, s[56:59], 0 offen
		v_mov_b32_e32 v82, 0
		buffer_load_ubyte_d16_hi v82, v70, s[56:59], 0 offen
		v_mov_b32_e32 v83, 0
		buffer_load_ubyte_d16_hi v83, v10, s[56:59], 0 offen
		s_add_i32 s19, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v121, 7, v1
		v_and_b32_e32 v122, 63, v0
		v_lshrrev_b32_e32 v123, 4, v122
		v_lshlrev_b32_e32 v123, 4, v123
		v_and_b32_e32 v122, 15, v122
		v_mov_b32_e32 v124, 0x420
		v_mul_lo_u32 v124, v124, v122
		v_add3_u32 v121, v121, v123, v124
		ds_read_b128 a[4:7], v121
		ds_read_b128 a[8:11], v121 offset:64
		ds_read_b128 a[12:15], v121 offset:256
		ds_read_b128 a[16:19], v121 offset:320
		ds_read_b128 a[20:23], v121 offset:512
		ds_read_b128 a[24:27], v121 offset:576
		ds_read_b128 a[28:31], v121 offset:768
		ds_read_b128 a[32:35], v121 offset:832
		ds_read_b128 a[36:39], v121 offset:16896
		ds_read_b128 a[40:43], v121 offset:16960
		ds_read_b128 a[44:47], v121 offset:17152
		ds_read_b128 a[48:51], v121 offset:17216
		ds_read_b128 a[52:55], v121 offset:17408
		ds_read_b128 a[56:59], v121 offset:17472
		ds_read_b128 a[60:63], v121 offset:17664
		ds_read_b128 a[64:67], v121 offset:17728
		v_add_u32_e32 v122, 0x10000, v123
		v_lshlrev_b32_e32 v123, 7, v3
		v_add3_u32 v122, v122, v123, v124
		ds_read_b128 a[68:71], v122 offset:1984
		ds_read_b128 a[72:75], v122 offset:2048
		ds_read_b128 a[76:79], v122 offset:2240
		ds_read_b128 a[80:83], v122 offset:2304
		ds_read_b128 a[84:87], v122 offset:2496
		ds_read_b128 a[88:91], v122 offset:2560
		ds_read_b128 a[92:95], v122 offset:2752
		ds_read_b128 a[96:99], v122 offset:2816
		v_add_u32_e32 v15, 0x20000, v15
		v_lshlrev_b32_e32 v123, 8, v18
		v_add_u32_e32 v124, v15, v123
		v_lshlrev_b32_e32 v125, 10, v20
		v_lshlrev_b32_e32 v126, 9, v22
		v_add3_u32 v124, v124, v125, v126
		s_waitcnt vmcnt(51)
		ds_write_b8 v124, v49 offset:3904
		v_add_u32_e32 v49, 0x20000, v123
		v_add3_u32 v49, v49, v125, v126
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
		ds_write_b8 v15, v72 offset:5952
		v_add_u32_e32 v49, 0x20000, v49
		v_add3_u32 v49, v49, v63, v64
		v_add_u32_e32 v48, v49, v48
		s_waitcnt vmcnt(42)
		ds_write_b8 v48, v73 offset:5952
		v_add_u32_e32 v51, v49, v51
		s_waitcnt vmcnt(41)
		ds_write_b8 v51, v74 offset:5952
		v_add_u32_e32 v49, v49, v53
		s_waitcnt vmcnt(40)
		ds_write_b8 v49, v75 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v45, 0x20000, v45
		v_lshlrev_b32_e32 v53, 3, v18
		v_add_u32_e32 v45, v45, v53
		v_lshl_add_u32 v45, v11, 9, v45
		v_lshlrev_b32_e32 v63, 8, v13
		v_lshlrev_b32_e32 v64, 6, v16
		v_add3_u32 v45, v45, v63, v64
		v_lshlrev_b32_e32 v63, 5, v20
		v_lshlrev_b32_e32 v22, 10, v22
		v_accvgpr_write_b32 a1, v22
		v_accvgpr_read_b32 v22, a1
		v_add3_u32 v22, v45, v63, v22
		ds_read_b64_tr_b8 v[66:67], v22 offset:3904
		ds_read_b64_tr_b8 v[72:73], v22 offset:4032
		v_add_u32_e32 v45, 0x20000, v53
		v_lshl_add_u32 v45, v3, 4, v45
		v_lshl_add_u32 v45, v11, 8, v45
		v_lshlrev_b32_e32 v53, 7, v13
		v_add3_u32 v45, v45, v53, v64
		v_add3_u32 v45, v45, v63, v126
		ds_read_b64_tr_b8 v[64:65], v45 offset:5952
		s_mov_b32 s20, 16
		v_lshlrev_b32_e32 v53, 2, v0
		v_add_u32_e32 v53, 0x20000, v53
		v_lshlrev_b32_e32 v63, 3, v0
		v_add_u32_e32 v63, 0x20000, v63
		s_add_u32 s44, s2, s19
		s_addc_u32 s45, s3, 0
		s_mov_b32 s52, s44
		s_mov_b32 s53, s45
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		s_add_u32 s44, s4, s13
		s_addc_u32 s45, s5, 0
		s_mov_b32 s56, s44
		s_mov_b32 s57, s45
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_add_u32 s44, s8, s20
		s_addc_u32 s45, s9, 0
		s_mov_b32 s72, s44
		s_mov_b32 s73, s45
		s_mov_b32 s74, 0x7fffffff
		s_mov_b32 s75, 0x31016000
		s_add_u32 s44, s10, s20
		s_addc_u32 s45, s11, 0
		s_mov_b32 s76, s44
		s_mov_b32 s77, s45
		s_mov_b32 s78, 0x7fffffff
		s_mov_b32 s79, 0x31016000
		s_mov_b32 s41, s20
		v_accvgpr_write_b32 a100, v4
		v_accvgpr_write_b32 a101, v5
		v_accvgpr_write_b32 a102, v6
		v_accvgpr_write_b32 a103, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
		v_accvgpr_write_b32 a212, 0
		v_accvgpr_write_b32 a213, 0
		v_accvgpr_write_b32 a214, 0
		v_accvgpr_write_b32 a215, 0
		v_accvgpr_write_b32 a216, 0
		v_accvgpr_write_b32 a217, 0
		v_accvgpr_write_b32 a218, 0
		v_accvgpr_write_b32 a219, 0
		v_accvgpr_write_b32 a220, 0
		v_accvgpr_write_b32 a221, 0
		v_accvgpr_write_b32 a222, 0
		v_accvgpr_write_b32 a223, 0
		v_accvgpr_write_b32 a224, 0
		v_accvgpr_write_b32 a225, 0
		v_accvgpr_write_b32 a226, 0
		v_accvgpr_write_b32 a227, 0
		v_accvgpr_write_b32 a228, 0
		v_accvgpr_write_b32 a229, 0
		v_accvgpr_write_b32 a230, 0
		v_accvgpr_write_b32 a231, 0
		v_accvgpr_write_b32 a232, 0
		v_accvgpr_write_b32 a233, 0
		v_accvgpr_write_b32 a234, 0
		v_accvgpr_write_b32 a235, 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[72:75], a[8:11], v[4:7], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v64, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v65, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v65, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v64, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v65, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v65, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v64, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v65, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v65, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v64, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v65, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v65, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v64, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v64, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v65, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v65, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v64, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v64, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v65, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v65, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v64, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v64, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v65, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v65, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v64, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v64, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v65, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v65, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 a[68:71], v122 offset:35712
		ds_read_b128 a[72:75], v122 offset:35776
		ds_read_b128 a[76:79], v122 offset:35968
		ds_read_b128 a[80:83], v122 offset:36032
		ds_read_b128 a[84:87], v122 offset:36224
		ds_read_b128 a[88:91], v122 offset:36288
		ds_read_b128 a[92:95], v122 offset:36480
		ds_read_b128 a[96:99], v122 offset:36544
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v64, v88, v90
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v64, v87, v89, v64
		ds_write_b32 v53, v64 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[64:65], v45 offset:5952
		s_add_u32 s52, s2, s19
		s_addc_u32 s53, s3, 0
		s_mov_b32 m0, s22
		buffer_load_dwordx4 v9, s[52:55], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v24, s[52:55], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v26, s[52:55], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v27, s[52:55], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v25, s[52:55], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v29, s[52:55], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v30, s[52:55], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v28, s[52:55], 0 offen lds
		s_add_u32 s56, s4, s13
		s_addc_u32 s57, s5, 0
		s_mov_b32 m0, s40
		buffer_load_dwordx4 v33, s[56:59], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v38, s[56:59], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v39, s[56:59], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v37, s[56:59], 0 offen lds
		s_add_u32 s72, s8, s20
		s_addc_u32 s73, s9, 0
		buffer_load_ubyte v74, v40, s[72:75], 0 offen
		buffer_load_ubyte v75, v50, s[72:75], 0 offen
		buffer_load_ubyte v125, v52, s[72:75], 0 offen
		buffer_load_ubyte v126, v54, s[72:75], 0 offen
		buffer_load_ubyte v127, v56, s[72:75], 0 offen
		buffer_load_ubyte v244, v58, s[72:75], 0 offen
		buffer_load_ubyte v245, v60, s[72:75], 0 offen
		buffer_load_ubyte v246, v47, s[72:75], 0 offen
		s_add_u32 s76, s10, s41
		s_addc_u32 s77, s11, 0
		buffer_load_ubyte v247, v68, s[76:79], 0 offen
		buffer_load_ubyte v248, v44, s[76:79], 0 offen
		buffer_load_ubyte v249, v71, s[76:79], 0 offen
		buffer_load_ubyte v250, v43, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v64, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v65, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v65, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[8:11], a[120:123], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v64, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v65, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v65, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[16:19], a[136:139], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v64, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v65, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v65, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[24:27], a[152:155], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v64, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v65, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v65, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[32:35], a[168:171], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v64, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v64, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v65, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v65, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[96:99], a[40:43], a[184:187], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v64, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v64, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v65, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v65, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[96:99], a[48:51], a[200:203], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v64, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v64, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v65, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v65, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[96:99], a[56:59], a[216:219], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v64, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v64, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v65, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v65, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[96:99], a[64:67], a[232:235], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 a[4:7], v121 offset:33760
		ds_read_b128 a[8:11], v121 offset:33824
		ds_read_b128 a[12:15], v121 offset:34016
		ds_read_b128 a[16:19], v121 offset:34080
		ds_read_b128 a[20:23], v121 offset:34272
		ds_read_b128 a[24:27], v121 offset:34336
		ds_read_b128 a[28:31], v121 offset:34528
		ds_read_b128 a[32:35], v121 offset:34592
		ds_read_b128 a[36:39], v121 offset:50656
		ds_read_b128 a[40:43], v121 offset:50720
		ds_read_b128 a[44:47], v121 offset:50912
		ds_read_b128 a[48:51], v121 offset:50976
		ds_read_b128 a[52:55], v121 offset:51168
		ds_read_b128 a[56:59], v121 offset:51232
		ds_read_b128 a[60:63], v121 offset:51424
		ds_read_b128 a[64:67], v121 offset:51488
		ds_read_b128 a[68:71], v122 offset:18848
		ds_read_b128 a[72:75], v122 offset:18912
		ds_read_b128 a[76:79], v122 offset:19104
		ds_read_b128 a[80:83], v122 offset:19168
		ds_read_b128 a[84:87], v122 offset:19360
		ds_read_b128 a[88:91], v122 offset:19424
		ds_read_b128 a[92:95], v122 offset:19616
		ds_read_b128 a[96:99], v122 offset:19680
		s_waitcnt vmcnt(40)
		v_or_b32_e32 v64, v101, v107
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v66, v100, v106, v64
		s_waitcnt vmcnt(36)
		v_or_b32_e32 v64, v109, v111
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v67, v108, v110, v64
		ds_write_b64 v63, v[66:67] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v64, v117, v119
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v64, v116, v118, v64
		ds_write_b32 v53, v64 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[64:65], v22 offset:3904
		ds_read_b64_tr_b8 v[66:67], v22 offset:4032
		ds_read_b64_tr_b8 v[72:73], v45 offset:5952
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v76, s[56:59], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v78, s[56:59], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v79, s[56:59], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v77, s[56:59], 0 offen lds
		buffer_load_ubyte_d16 v87, v81, s[76:79], 0 offen
		buffer_load_ubyte_d16 v88, v85, s[76:79], 0 offen
		v_mov_b32_e32 v89, 0
		buffer_load_ubyte_d16_hi v89, v86, s[76:79], 0 offen
		v_mov_b32_e32 v90, 0
		buffer_load_ubyte_d16_hi v90, v84, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v72, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[72:75], a[8:11], v[4:7], v72, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v72, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v72, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v73, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v73, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v73, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v73, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v72, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v72, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v72, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v72, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v73, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v73, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v73, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v73, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v72, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v72, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v72, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v72, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v73, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v73, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v73, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v73, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v72, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v72, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v72, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v72, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v73, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v73, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v73, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v73, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v72, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v72, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v72, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v72, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v73, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v73, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v73, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v73, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v72, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v72, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v72, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v72, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v73, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v73, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v73, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v73, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v72, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v72, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v72, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v72, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v73, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v73, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v73, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v73, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v72, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v72, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v72, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v72, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v73, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v73, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v73, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v73, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 a[68:71], v122 offset:52576
		ds_read_b128 a[72:75], v122 offset:52640
		ds_read_b128 a[76:79], v122 offset:52832
		ds_read_b128 a[80:83], v122 offset:52896
		ds_read_b128 a[84:87], v122 offset:53088
		ds_read_b128 a[88:91], v122 offset:53152
		ds_read_b128 a[92:95], v122 offset:53344
		ds_read_b128 v[252:255], v122 offset:53408
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v72, v80, v83
		v_lshlrev_b32_e32 v72, 8, v72
		v_or3_b32 v36, v36, v82, v72
		ds_write_b32 v53, v36 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[72:73], v45 offset:5952
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
		buffer_load_dwordx4 v14, s[56:59], 0 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v17, s[56:59], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v12, s[56:59], 0 offen lds
		buffer_load_ubyte_d16 v100, v99, s[72:75], 0 offen
		buffer_load_ubyte_d16 v101, v102, s[72:75], 0 offen
		v_mov_b32_e32 v106, 0
		buffer_load_ubyte_d16_hi v106, v104, s[72:75], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v105, s[72:75], 0 offen
		buffer_load_ubyte_d16 v108, v103, s[72:75], 0 offen
		buffer_load_ubyte_d16 v109, v42, s[72:75], 0 offen
		v_mov_b32_e32 v110, 0
		buffer_load_ubyte_d16_hi v110, v98, s[72:75], 0 offen
		v_mov_b32_e32 v111, 0
		buffer_load_ubyte_d16_hi v111, v41, s[72:75], 0 offen
		buffer_load_ubyte_d16 v116, v112, s[76:79], 0 offen
		buffer_load_ubyte_d16 v117, v114, s[76:79], 0 offen
		v_mov_b32_e32 v118, 0
		buffer_load_ubyte_d16_hi v118, v115, s[76:79], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v113, s[76:79], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v72, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v72, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v72, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v72, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v73, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v73, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v73, v64 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[8:11], a[120:123], v73, v64 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v72, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v72, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v72, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v72, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v73, v64 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v73, v64 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v73, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[16:19], a[136:139], v73, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v72, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v72, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v72, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v72, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v73, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v73, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v73, v65 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[24:27], a[152:155], v73, v65 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v72, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v72, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v72, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v72, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v73, v65 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v73, v65 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v73, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[32:35], a[168:171], v73, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v72, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v72, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v72, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v72, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v73, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v73, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v73, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[252:255], a[40:43], a[184:187], v73, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v72, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v72, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v72, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v72, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v73, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v73, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v73, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], a[48:51], a[200:203], v73, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v72, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v72, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v72, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v72, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v73, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v73, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v73, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], a[56:59], a[216:219], v73, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v72, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v72, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v72, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v72, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v73, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v73, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v73, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[252:255], a[64:67], a[232:235], v73, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 a[4:7], v121
		ds_read_b128 a[8:11], v121 offset:64
		ds_read_b128 a[12:15], v121 offset:256
		ds_read_b128 a[16:19], v121 offset:320
		ds_read_b128 a[20:23], v121 offset:512
		ds_read_b128 a[24:27], v121 offset:576
		ds_read_b128 a[28:31], v121 offset:768
		ds_read_b128 a[32:35], v121 offset:832
		ds_read_b128 a[36:39], v121 offset:16896
		ds_read_b128 a[40:43], v121 offset:16960
		ds_read_b128 a[44:47], v121 offset:17152
		ds_read_b128 a[48:51], v121 offset:17216
		ds_read_b128 a[52:55], v121 offset:17408
		ds_read_b128 a[56:59], v121 offset:17472
		ds_read_b128 a[60:63], v121 offset:17664
		ds_read_b128 a[64:67], v121 offset:17728
		ds_read_b128 a[68:71], v122 offset:1984
		ds_read_b128 a[72:75], v122 offset:2048
		ds_read_b128 a[76:79], v122 offset:2240
		ds_read_b128 a[80:83], v122 offset:2304
		ds_read_b128 a[84:87], v122 offset:2496
		ds_read_b128 a[88:91], v122 offset:2560
		ds_read_b128 a[92:95], v122 offset:2752
		ds_read_b128 a[96:99], v122 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v124, v74 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v123, v75 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v61, v125 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v62, v126 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v55, v127 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v57, v244 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v59, v245 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v46, v246 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v15, v247 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v48, v248 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v51, v249 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v49, v250 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v22 offset:3904
		ds_read_b64_tr_b8 v[72:73], v22 offset:4032
		ds_read_b64_tr_b8 v[64:65], v45 offset:5952
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v120, s[56:59], 0 offen lds
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v32, s[56:59], 0 offen lds
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v34, s[56:59], 0 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v31, s[56:59], 0 offen lds
		buffer_load_ubyte_d16 v36, v35, s[76:79], 0 offen
		buffer_load_ubyte_d16 v80, v69, s[76:79], 0 offen
		v_mov_b32_e32 v82, 0
		buffer_load_ubyte_d16_hi v82, v70, s[76:79], 0 offen
		v_mov_b32_e32 v83, 0
		buffer_load_ubyte_d16_hi v83, v10, s[76:79], 0 offen
		s_add_i32 s19, s19, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s20, s20, 16
		s_add_i32 s41, s41, 16
		s_add_i32 s21, s21, 2
		s_cmp_lt_i32 s21, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v2, v88, v90
		v_lshlrev_b32_e32 v2, 8, v2
		v_or3_b32 v2, v87, v89, v2
		s_waitcnt vmcnt(16)
		v_or_b32_e32 v8, v101, v107
		v_lshlrev_b32_e32 v8, 8, v8
		v_or3_b32 v14, v100, v106, v8
		s_waitcnt vmcnt(12)
		v_or_b32_e32 v8, v109, v111
		v_lshlrev_b32_e32 v8, 8, v8
		v_or3_b32 v15, v108, v110, v8
		s_waitcnt vmcnt(8)
		v_or_b32_e32 v8, v117, v119
		v_lshlrev_b32_e32 v8, 8, v8
		v_or3_b32 v8, v116, v118, v8
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v9, v80, v83
		v_lshlrev_b32_e32 v9, 8, v9
		v_or3_b32 v9, v36, v82, v9
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[72:75], a[8:11], v[4:7], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v64, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v65, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v65, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v64, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v65, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v65, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v65, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v65, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v64, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v65, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v65, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v64, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v65, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v65, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v65, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v65, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v64, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v64, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v65, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v65, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v64, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v64, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v64, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v64, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v65, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v65, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v65, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v65, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v64, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v64, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v65, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v65, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v64, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v64, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v64, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v64, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v65, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v65, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v65, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v65, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[24:27], v122 offset:35712
		ds_read_b128 v[28:31], v122 offset:35776
		ds_read_b128 v[32:35], v122 offset:35968
		ds_read_b128 v[36:39], v122 offset:36032
		ds_read_b128 v[40:43], v122 offset:36224
		ds_read_b128 v[48:51], v122 offset:36288
		ds_read_b128 v[56:59], v122 offset:36480
		ds_read_b128 v[68:71], v122 offset:36544
		ds_write_b32 v53, v2 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[46:47], v45 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[4:7], a[108:111], v46, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[8:11], a[108:111], v46, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[4:7], a[112:115], v46, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[8:11], a[112:115], v46, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[4:7], a[116:119], v47, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[8:11], a[116:119], v47, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[4:7], a[120:123], v47, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], a[8:11], a[120:123], v47, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[12:15], a[124:127], v46, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[16:19], a[124:127], v46, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[12:15], a[128:131], v46, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[16:19], a[128:131], v46, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[12:15], a[132:135], v47, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[16:19], a[132:135], v47, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[12:15], a[136:139], v47, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[16:19], a[136:139], v47, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[20:23], a[140:143], v46, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[24:27], a[140:143], v46, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[20:23], a[144:147], v46, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[24:27], a[144:147], v46, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[20:23], a[148:151], v47, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[24:27], a[148:151], v47, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[20:23], a[152:155], v47, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[24:27], a[152:155], v47, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[28:31], a[156:159], v46, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[32:35], a[156:159], v46, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[28:31], a[160:163], v46, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[32:35], a[160:163], v46, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[28:31], a[164:167], v47, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[32:35], a[164:167], v47, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[28:31], a[168:171], v47, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[32:35], a[168:171], v47, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], a[36:39], a[172:175], v46, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], a[40:43], a[172:175], v46, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], a[36:39], a[176:179], v46, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], a[40:43], a[176:179], v46, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], a[36:39], a[180:183], v47, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], a[40:43], a[180:183], v47, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[56:59], a[36:39], a[184:187], v47, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[68:71], a[40:43], a[184:187], v47, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], a[44:47], a[188:191], v46, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], a[48:51], a[188:191], v46, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], a[44:47], a[192:195], v46, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], a[48:51], a[192:195], v46, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], a[44:47], a[196:199], v47, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[48:51], a[48:51], a[196:199], v47, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[56:59], a[44:47], a[200:203], v47, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[68:71], a[48:51], a[200:203], v47, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], a[52:55], a[204:207], v46, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[28:31], a[56:59], a[204:207], v46, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], a[52:55], a[208:211], v46, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], a[56:59], a[208:211], v46, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], a[52:55], a[212:215], v47, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[48:51], a[56:59], a[212:215], v47, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[56:59], a[52:55], a[216:219], v47, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[68:71], a[56:59], a[216:219], v47, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[24:27], a[60:63], a[220:223], v46, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[28:31], a[64:67], a[220:223], v46, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], a[60:63], a[224:227], v46, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], a[64:67], a[224:227], v46, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], a[60:63], a[228:231], v47, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[48:51], a[64:67], a[228:231], v47, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[56:59], a[60:63], a[232:235], v47, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[68:71], a[64:67], a[232:235], v47, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v121 offset:33760
		ds_read_b128 v[28:31], v121 offset:33824
		ds_read_b128 v[32:35], v121 offset:34016
		ds_read_b128 v[36:39], v121 offset:34080
		ds_read_b128 v[40:43], v121 offset:34272
		ds_read_b128 v[48:51], v121 offset:34336
		ds_read_b128 v[56:59], v121 offset:34528
		ds_read_b128 v[64:67], v121 offset:34592
		ds_read_b128 v[68:71], v121 offset:50656
		ds_read_b128 v[72:75], v121 offset:50720
		ds_read_b128 v[76:79], v121 offset:50912
		ds_read_b128 v[80:83], v121 offset:50976
		ds_read_b128 v[84:87], v121 offset:51168
		ds_read_b128 v[88:91], v121 offset:51232
		ds_read_b128 v[92:95], v121 offset:51424
		ds_read_b128 v[96:99], v121 offset:51488
		ds_read_b128 v[100:103], v122 offset:18848
		ds_read_b128 v[104:107], v122 offset:18912
		ds_read_b128 v[108:111], v122 offset:19104
		ds_read_b128 v[112:115], v122 offset:19168
		ds_read_b128 v[116:119], v122 offset:19360
		ds_read_b128 v[124:127], v122 offset:19424
		ds_read_b128 v[244:247], v122 offset:19616
		ds_read_b128 v[248:251], v122 offset:19680
		ds_write_b64 v63, v[14:15] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v53, v8 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v22 offset:3904
		ds_read_b64_tr_b8 v[46:47], v22 offset:4032
		ds_read_b64_tr_b8 v[54:55], v45 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[100:103], v[24:27], v[4:7], v54, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[104:107], v[28:31], v[4:7], v54, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[24:27], a[100:103], v54, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[112:115], v[28:31], a[100:103], v54, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[116:119], v[24:27], v[128:131], v55, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[124:127], v[28:31], v[128:131], v55, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[244:247], v[24:27], v[132:135], v55, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[248:251], v[28:31], v[132:135], v55, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[100:103], v[32:35], v[136:139], v54, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[104:107], v[36:39], v[136:139], v54, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[108:111], v[32:35], v[140:143], v54, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[112:115], v[36:39], v[140:143], v54, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[116:119], v[32:35], v[144:147], v55, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[124:127], v[36:39], v[144:147], v55, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[244:247], v[32:35], v[148:151], v55, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[248:251], v[36:39], v[148:151], v55, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[100:103], v[40:43], v[152:155], v54, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[104:107], v[48:51], v[152:155], v54, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[108:111], v[40:43], v[156:159], v54, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[112:115], v[48:51], v[156:159], v54, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[116:119], v[40:43], v[160:163], v55, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[124:127], v[48:51], v[160:163], v55, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[244:247], v[40:43], v[164:167], v55, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[248:251], v[48:51], v[164:167], v55, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[100:103], v[56:59], v[168:171], v54, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[104:107], v[64:67], v[168:171], v54, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[108:111], v[56:59], v[172:175], v54, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[112:115], v[64:67], v[172:175], v54, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[116:119], v[56:59], v[176:179], v55, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[124:127], v[64:67], v[176:179], v55, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[56:59], v[180:183], v55, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[248:251], v[64:67], v[180:183], v55, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[100:103], v[68:71], v[184:187], v54, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[104:107], v[72:75], v[184:187], v54, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[108:111], v[68:71], v[188:191], v54, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[112:115], v[72:75], v[188:191], v54, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[116:119], v[68:71], v[192:195], v55, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[124:127], v[72:75], v[192:195], v55, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[244:247], v[68:71], v[196:199], v55, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[248:251], v[72:75], v[196:199], v55, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[100:103], v[76:79], v[200:203], v54, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[104:107], v[80:83], v[200:203], v54, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[108:111], v[76:79], v[204:207], v54, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[112:115], v[80:83], v[204:207], v54, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[116:119], v[76:79], v[208:211], v55, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[124:127], v[80:83], v[208:211], v55, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[76:79], v[212:215], v55, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[248:251], v[80:83], v[212:215], v55, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[100:103], v[84:87], v[216:219], v54, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[104:107], v[88:91], v[216:219], v54, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[108:111], v[84:87], v[220:223], v54, v47 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[112:115], v[88:91], v[220:223], v54, v47 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[116:119], v[84:87], v[224:227], v55, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[124:127], v[88:91], v[224:227], v55, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[84:87], v[228:231], v55, v47 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[248:251], v[88:91], v[228:231], v55, v47 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[100:103], v[92:95], v[232:235], v54, v47 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[104:107], v[96:99], v[232:235], v54, v47 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[108:111], v[92:95], v[236:239], v54, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[112:115], v[96:99], v[236:239], v54, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[116:119], v[92:95], v[240:243], v55, v47 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[124:127], v[96:99], v[240:243], v55, v47 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[244:247], v[92:95], a[104:107], v55, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[248:251], v[96:99], a[104:107], v55, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v122 offset:52576
		ds_read_b128 v[100:103], v122 offset:52640
		ds_read_b128 v[104:107], v122 offset:52832
		ds_read_b128 v[108:111], v122 offset:52896
		ds_read_b128 v[112:115], v122 offset:53088
		ds_read_b128 v[116:119], v122 offset:53152
		ds_read_b128 v[124:127], v122 offset:53344
		ds_read_b128 v[244:247], v122 offset:53408
		ds_write_b32 v53, v9 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v45 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v52, v4, v5
		v_cvt_pk_bf16_f32 v53, v6, v7
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v4, a101
		v_cvt_pk_bf16_f32 v120, v2, v4
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v4, a103
		v_cvt_pk_bf16_f32 v121, v2, v4
		v_cvt_pk_bf16_f32 v4, v128, v129
		v_cvt_pk_bf16_f32 v5, v130, v131
		v_cvt_pk_bf16_f32 v128, v132, v133
		v_cvt_pk_bf16_f32 v129, v134, v135
		v_cvt_pk_bf16_f32 v54, v136, v137
		v_cvt_pk_bf16_f32 v55, v138, v139
		v_cvt_pk_bf16_f32 v122, v140, v141
		v_cvt_pk_bf16_f32 v123, v142, v143
		v_cvt_pk_bf16_f32 v6, v144, v145
		v_cvt_pk_bf16_f32 v7, v146, v147
		v_cvt_pk_bf16_f32 v130, v148, v149
		v_cvt_pk_bf16_f32 v131, v150, v151
		v_cvt_pk_bf16_f32 v132, v152, v153
		v_cvt_pk_bf16_f32 v133, v154, v155
		v_cvt_pk_bf16_f32 v136, v156, v157
		v_cvt_pk_bf16_f32 v137, v158, v159
		v_cvt_pk_bf16_f32 v140, v160, v161
		v_cvt_pk_bf16_f32 v141, v162, v163
		v_cvt_pk_bf16_f32 v144, v164, v165
		v_cvt_pk_bf16_f32 v145, v166, v167
		v_cvt_pk_bf16_f32 v134, v168, v169
		v_cvt_pk_bf16_f32 v135, v170, v171
		v_cvt_pk_bf16_f32 v138, v172, v173
		v_cvt_pk_bf16_f32 v139, v174, v175
		v_cvt_pk_bf16_f32 v142, v176, v177
		v_cvt_pk_bf16_f32 v143, v178, v179
		v_cvt_pk_bf16_f32 v146, v180, v181
		v_cvt_pk_bf16_f32 v147, v182, v183
		v_cvt_pk_bf16_f32 v148, v184, v185
		v_cvt_pk_bf16_f32 v149, v186, v187
		v_cvt_pk_bf16_f32 v152, v188, v189
		v_cvt_pk_bf16_f32 v153, v190, v191
		v_cvt_pk_bf16_f32 v156, v192, v193
		v_cvt_pk_bf16_f32 v157, v194, v195
		v_cvt_pk_bf16_f32 v160, v196, v197
		v_cvt_pk_bf16_f32 v161, v198, v199
		v_cvt_pk_bf16_f32 v150, v200, v201
		v_cvt_pk_bf16_f32 v151, v202, v203
		v_cvt_pk_bf16_f32 v154, v204, v205
		v_cvt_pk_bf16_f32 v155, v206, v207
		v_cvt_pk_bf16_f32 v158, v208, v209
		v_cvt_pk_bf16_f32 v159, v210, v211
		v_cvt_pk_bf16_f32 v162, v212, v213
		v_cvt_pk_bf16_f32 v163, v214, v215
		v_cvt_pk_bf16_f32 v164, v216, v217
		v_cvt_pk_bf16_f32 v165, v218, v219
		v_cvt_pk_bf16_f32 v168, v220, v221
		v_cvt_pk_bf16_f32 v169, v222, v223
		v_cvt_pk_bf16_f32 v172, v224, v225
		v_cvt_pk_bf16_f32 v173, v226, v227
		v_cvt_pk_bf16_f32 v176, v228, v229
		v_cvt_pk_bf16_f32 v177, v230, v231
		v_cvt_pk_bf16_f32 v166, v232, v233
		v_cvt_pk_bf16_f32 v167, v234, v235
		v_cvt_pk_bf16_f32 v170, v236, v237
		v_cvt_pk_bf16_f32 v171, v238, v239
		v_cvt_pk_bf16_f32 v174, v240, v241
		v_cvt_pk_bf16_f32 v175, v242, v243
		v_accvgpr_read_b32 v2, a104
		v_accvgpr_read_b32 v10, a105
		v_cvt_pk_bf16_f32 v178, v2, v10
		v_accvgpr_read_b32 v2, a106
		v_accvgpr_read_b32 v10, a107
		v_cvt_pk_bf16_f32 v179, v2, v10
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[52:55]
		ds_write_b128 v0, v[120:123] offset:4096
		ds_write_b128 v0, v[4:7] offset:8192
		ds_write_b128 v0, v[128:131] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v2, 9, v18
		v_accvgpr_read_b32 v4, a0
		v_lshl_add_u32 v2, v4, 4, v2
		v_lshl_add_u32 v2, v16, 13, v2
		v_lshlrev_b32_e32 v4, 12, v20
		v_accvgpr_read_b32 v5, a1
		v_add3_u32 v2, v2, v4, v5
		ds_read_b128 v[4:7], v2
		ds_read_b128 v[52:55], v2 offset:256
		ds_read_b128 v[120:123], v2 offset:2048
		ds_read_b128 v[128:131], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[132:135]
		ds_write_b128 v0, v[136:139] offset:4096
		ds_write_b128 v0, v[140:143] offset:8192
		ds_write_b128 v0, v[144:147] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[132:135], v2
		ds_read_b128 v[136:139], v2 offset:256
		ds_read_b128 v[140:143], v2 offset:2048
		ds_read_b128 v[144:147], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[148:151]
		ds_write_b128 v0, v[152:155] offset:4096
		ds_write_b128 v0, v[156:159] offset:8192
		ds_write_b128 v0, v[160:163] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[148:151], v2
		ds_read_b128 v[152:155], v2 offset:256
		ds_read_b128 v[156:159], v2 offset:2048
		ds_read_b128 v[160:163], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[164:167]
		ds_write_b128 v0, v[168:171] offset:4096
		ds_write_b128 v0, v[172:175] offset:8192
		ds_write_b128 v0, v[176:179] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[164:167], v2
		ds_read_b128 v[168:171], v2 offset:256
		ds_read_b128 v[172:175], v2 offset:2048
		ds_read_b128 v[176:179], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s1, s1, 1
		s_add_u32 s2, s6, s1
		s_addc_u32 s3, s7, 0
		s_mov_b32 s4, s2
		s_mov_b32 s5, s3
		s_mov_b32 s6, 0x7fffffff
		s_mov_b32 s7, 0x31016000
		v_mov_b64_e32 v[180:181], v[4:5]
		v_mov_b64_e32 v[182:183], v[52:53]
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
		buffer_store_dwordx4 v[180:183], v10, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[180:181], v[120:121]
		v_mov_b64_e32 v[182:183], v[128:129]
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v10, 16, v13
		v_lshlrev_b32_e32 v11, 1, v11
		v_xor_b32_e32 v10, v10, v11
		v_xor_b32_e32 v10, v3, v10
		v_xor_b32_e32 v10, v1, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v18, s0, v10
		v_add3_u32 v18, v18, v19, v16
		v_add3_u32 v18, v18, v21, v23
		buffer_store_dwordx4 v[180:183], v18, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[180:181], v[6:7]
		v_mov_b64_e32 v[182:183], v[54:55]
		v_add_u32_e32 v6, 32, v13
		v_xor_b32_e32 v6, v6, v11
		v_xor_b32_e32 v6, v3, v6
		v_xor_b32_e32 v6, v1, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v7, s0, v6
		v_add3_u32 v7, v7, v19, v16
		v_add3_u32 v7, v7, v21, v23
		buffer_store_dwordx4 v[180:183], v7, s[4:7], 0 offen
		v_mov_b64_e32 v[52:53], v[122:123]
		v_mov_b64_e32 v[54:55], v[130:131]
		v_add_u32_e32 v7, 48, v13
		v_xor_b32_e32 v7, v7, v11
		v_xor_b32_e32 v7, v3, v7
		v_xor_b32_e32 v7, v1, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v18, s0, v7
		v_add3_u32 v18, v18, v19, v16
		v_add3_u32 v18, v18, v21, v23
		buffer_store_dwordx4 v[52:55], v18, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[132:133]
		v_mov_b64_e32 v[54:55], v[136:137]
		v_add_u32_e32 v18, 64, v13
		v_xor_b32_e32 v18, v18, v11
		v_xor_b32_e32 v18, v3, v18
		v_xor_b32_e32 v18, v1, v18
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v20, s0, v18
		v_add3_u32 v20, v20, v19, v16
		v_add3_u32 v20, v20, v21, v23
		buffer_store_dwordx4 v[52:55], v20, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[140:141]
		v_mov_b64_e32 v[54:55], v[144:145]
		v_add_u32_e32 v20, 0x50, v13
		v_xor_b32_e32 v20, v20, v11
		v_xor_b32_e32 v20, v3, v20
		v_xor_b32_e32 v20, v1, v20
		v_mul_lo_u32 v20, s17, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v22, s0, v20
		v_add3_u32 v22, v22, v19, v16
		v_add3_u32 v22, v22, v21, v23
		buffer_store_dwordx4 v[52:55], v22, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[134:135]
		v_mov_b64_e32 v[54:55], v[138:139]
		v_add_u32_e32 v22, 0x60, v13
		v_xor_b32_e32 v22, v22, v11
		v_xor_b32_e32 v22, v3, v22
		v_xor_b32_e32 v22, v1, v22
		v_mul_lo_u32 v22, s17, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v44, s0, v22
		v_add3_u32 v44, v44, v19, v16
		v_add3_u32 v44, v44, v21, v23
		buffer_store_dwordx4 v[52:55], v44, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[142:143]
		v_mov_b64_e32 v[54:55], v[146:147]
		v_add_u32_e32 v44, 0x70, v13
		v_xor_b32_e32 v44, v44, v11
		v_xor_b32_e32 v44, v3, v44
		v_xor_b32_e32 v44, v1, v44
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v19, v16
		v_add3_u32 v45, v45, v21, v23
		buffer_store_dwordx4 v[52:55], v45, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[148:149]
		v_mov_b64_e32 v[54:55], v[152:153]
		v_add_u32_e32 v45, 0x80, v13
		v_xor_b32_e32 v45, v45, v11
		v_xor_b32_e32 v45, v3, v45
		v_xor_b32_e32 v45, v1, v45
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v120, s0, v45
		v_add3_u32 v120, v120, v19, v16
		v_add3_u32 v120, v120, v21, v23
		buffer_store_dwordx4 v[52:55], v120, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[156:157]
		v_mov_b64_e32 v[54:55], v[160:161]
		v_add_u32_e32 v120, 0x90, v13
		v_xor_b32_e32 v120, v120, v11
		v_xor_b32_e32 v120, v3, v120
		v_xor_b32_e32 v120, v1, v120
		v_mul_lo_u32 v120, s17, v120
		v_lshlrev_b32_e32 v120, 1, v120
		v_add_u32_e32 v121, s0, v120
		v_add3_u32 v121, v121, v19, v16
		v_add3_u32 v121, v121, v21, v23
		buffer_store_dwordx4 v[52:55], v121, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[150:151]
		v_mov_b64_e32 v[54:55], v[154:155]
		v_add_u32_e32 v121, 0xa0, v13
		v_xor_b32_e32 v121, v121, v11
		v_xor_b32_e32 v121, v3, v121
		v_xor_b32_e32 v121, v1, v121
		v_mul_lo_u32 v121, s17, v121
		v_lshlrev_b32_e32 v121, 1, v121
		v_add_u32_e32 v122, s0, v121
		v_add3_u32 v122, v122, v19, v16
		v_add3_u32 v122, v122, v21, v23
		buffer_store_dwordx4 v[52:55], v122, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[158:159]
		v_mov_b64_e32 v[54:55], v[162:163]
		v_add_u32_e32 v122, 0xb0, v13
		v_xor_b32_e32 v122, v122, v11
		v_xor_b32_e32 v122, v3, v122
		v_xor_b32_e32 v122, v1, v122
		v_mul_lo_u32 v122, s17, v122
		v_lshlrev_b32_e32 v122, 1, v122
		v_add_u32_e32 v123, s0, v122
		v_add3_u32 v123, v123, v19, v16
		v_add3_u32 v123, v123, v21, v23
		buffer_store_dwordx4 v[52:55], v123, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[164:165]
		v_mov_b64_e32 v[54:55], v[168:169]
		v_add_u32_e32 v123, 0xc0, v13
		v_xor_b32_e32 v123, v123, v11
		v_xor_b32_e32 v123, v3, v123
		v_xor_b32_e32 v123, v1, v123
		v_mul_lo_u32 v123, s17, v123
		v_lshlrev_b32_e32 v123, 1, v123
		v_add_u32_e32 v128, s0, v123
		v_add3_u32 v128, v128, v19, v16
		v_add3_u32 v128, v128, v21, v23
		buffer_store_dwordx4 v[52:55], v128, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[172:173]
		v_mov_b64_e32 v[54:55], v[176:177]
		v_add_u32_e32 v128, 0xd0, v13
		v_xor_b32_e32 v128, v128, v11
		v_xor_b32_e32 v128, v3, v128
		v_xor_b32_e32 v128, v1, v128
		v_mul_lo_u32 v128, s17, v128
		v_lshlrev_b32_e32 v128, 1, v128
		v_add_u32_e32 v129, s0, v128
		v_add3_u32 v129, v129, v19, v16
		v_add3_u32 v129, v129, v21, v23
		buffer_store_dwordx4 v[52:55], v129, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[166:167]
		v_mov_b64_e32 v[54:55], v[170:171]
		v_add_u32_e32 v129, 0xe0, v13
		v_xor_b32_e32 v129, v129, v11
		v_xor_b32_e32 v129, v3, v129
		v_xor_b32_e32 v129, v1, v129
		v_mul_lo_u32 v129, s17, v129
		v_lshlrev_b32_e32 v129, 1, v129
		v_add_u32_e32 v130, s0, v129
		v_add3_u32 v130, v130, v19, v16
		v_add3_u32 v130, v130, v21, v23
		buffer_store_dwordx4 v[52:55], v130, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[52:53], v[174:175]
		v_mov_b64_e32 v[54:55], v[178:179]
		v_add_u32_e32 v13, 0xf0, v13
		v_xor_b32_e32 v11, v13, v11
		v_xor_b32_e32 v3, v3, v11
		v_xor_b32_e32 v1, v1, v3
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add_u32_e32 v3, s0, v1
		v_add3_u32 v3, v3, v19, v16
		v_add3_u32 v3, v3, v21, v23
		buffer_store_dwordx4 v[52:55], v3, s[4:7], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[60:63], v[24:27], a[108:111], v8, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[28:31], a[108:111], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[104:107], v[24:27], a[112:115], v8, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[28:31], a[112:115], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[24:27], a[116:119], v9, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[116:119], v[28:31], a[116:119], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[124:127], v[24:27], a[120:123], v9, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[244:247], v[28:31], a[120:123], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], v[32:35], a[124:127], v8, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[36:39], a[124:127], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[32:35], a[128:131], v8, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[36:39], a[128:131], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[32:35], a[132:135], v9, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[116:119], v[36:39], a[132:135], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[124:127], v[32:35], a[136:139], v9, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[244:247], v[36:39], a[136:139], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], v[40:43], a[140:143], v8, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[48:51], a[140:143], v8, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[40:43], a[144:147], v8, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[48:51], a[144:147], v8, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[40:43], a[148:151], v9, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[116:119], v[48:51], a[148:151], v9, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[124:127], v[40:43], a[152:155], v9, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[244:247], v[48:51], a[152:155], v9, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], v[56:59], a[156:159], v8, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[64:67], a[156:159], v8, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[56:59], a[160:163], v8, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[64:67], a[160:163], v8, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[56:59], a[164:167], v9, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[64:67], a[164:167], v9, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[124:127], v[56:59], a[168:171], v9, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[244:247], v[64:67], a[168:171], v9, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], v[68:71], a[172:175], v8, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[72:75], a[172:175], v8, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[68:71], a[176:179], v8, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[72:75], a[176:179], v8, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[68:71], a[180:183], v9, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[72:75], a[180:183], v9, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[124:127], v[68:71], a[184:187], v9, v46 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[244:247], v[72:75], a[184:187], v9, v46 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[60:63], v[76:79], a[188:191], v8, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[80:83], a[188:191], v8, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[76:79], a[192:195], v8, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[80:83], a[192:195], v8, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[76:79], a[196:199], v9, v46 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[116:119], v[80:83], a[196:199], v9, v46 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[76:79], a[200:203], v9, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[244:247], v[80:83], a[200:203], v9, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], v[84:87], a[204:207], v8, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[88:91], a[204:207], v8, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[84:87], a[208:211], v8, v47 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[88:91], a[208:211], v8, v47 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[84:87], a[212:215], v9, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[116:119], v[88:91], a[212:215], v9, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[84:87], a[216:219], v9, v47 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[244:247], v[88:91], a[216:219], v9, v47 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[60:63], v[92:95], a[220:223], v8, v47 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[96:99], a[220:223], v8, v47 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[104:107], v[92:95], a[224:227], v8, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[108:111], v[96:99], a[224:227], v8, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[92:95], a[228:231], v9, v47 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[116:119], v[96:99], a[228:231], v9, v47 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[92:95], a[232:235], v9, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[244:247], v[96:99], a[232:235], v9, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v3, a108
		v_accvgpr_read_b32 v8, a109
		v_cvt_pk_bf16_f32 v24, v3, v8
		v_accvgpr_read_b32 v3, a110
		v_accvgpr_read_b32 v8, a111
		v_cvt_pk_bf16_f32 v25, v3, v8
		v_accvgpr_read_b32 v3, a112
		v_accvgpr_read_b32 v8, a113
		v_cvt_pk_bf16_f32 v28, v3, v8
		v_accvgpr_read_b32 v3, a114
		v_accvgpr_read_b32 v8, a115
		v_cvt_pk_bf16_f32 v29, v3, v8
		v_accvgpr_read_b32 v3, a116
		v_accvgpr_read_b32 v8, a117
		v_cvt_pk_bf16_f32 v32, v3, v8
		v_accvgpr_read_b32 v3, a118
		v_accvgpr_read_b32 v8, a119
		v_cvt_pk_bf16_f32 v33, v3, v8
		v_accvgpr_read_b32 v3, a120
		v_accvgpr_read_b32 v8, a121
		v_cvt_pk_bf16_f32 v36, v3, v8
		v_accvgpr_read_b32 v3, a122
		v_accvgpr_read_b32 v8, a123
		v_cvt_pk_bf16_f32 v37, v3, v8
		v_accvgpr_read_b32 v3, a124
		v_accvgpr_read_b32 v8, a125
		v_cvt_pk_bf16_f32 v26, v3, v8
		v_accvgpr_read_b32 v3, a126
		v_accvgpr_read_b32 v8, a127
		v_cvt_pk_bf16_f32 v27, v3, v8
		v_accvgpr_read_b32 v3, a128
		v_accvgpr_read_b32 v8, a129
		v_cvt_pk_bf16_f32 v30, v3, v8
		v_accvgpr_read_b32 v3, a130
		v_accvgpr_read_b32 v8, a131
		v_cvt_pk_bf16_f32 v31, v3, v8
		v_accvgpr_read_b32 v3, a132
		v_accvgpr_read_b32 v8, a133
		v_cvt_pk_bf16_f32 v34, v3, v8
		v_accvgpr_read_b32 v3, a134
		v_accvgpr_read_b32 v8, a135
		v_cvt_pk_bf16_f32 v35, v3, v8
		v_accvgpr_read_b32 v3, a136
		v_accvgpr_read_b32 v8, a137
		v_cvt_pk_bf16_f32 v38, v3, v8
		v_accvgpr_read_b32 v3, a138
		v_accvgpr_read_b32 v8, a139
		v_cvt_pk_bf16_f32 v39, v3, v8
		v_accvgpr_read_b32 v3, a140
		v_accvgpr_read_b32 v8, a141
		v_cvt_pk_bf16_f32 v40, v3, v8
		v_accvgpr_read_b32 v3, a142
		v_accvgpr_read_b32 v8, a143
		v_cvt_pk_bf16_f32 v41, v3, v8
		v_accvgpr_read_b32 v3, a144
		v_accvgpr_read_b32 v8, a145
		v_cvt_pk_bf16_f32 v48, v3, v8
		v_accvgpr_read_b32 v3, a146
		v_accvgpr_read_b32 v8, a147
		v_cvt_pk_bf16_f32 v49, v3, v8
		v_accvgpr_read_b32 v3, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v52, v3, v8
		v_accvgpr_read_b32 v3, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v53, v3, v8
		v_accvgpr_read_b32 v3, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v56, v3, v8
		v_accvgpr_read_b32 v3, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v57, v3, v8
		v_accvgpr_read_b32 v3, a156
		v_accvgpr_read_b32 v8, a157
		v_cvt_pk_bf16_f32 v42, v3, v8
		v_accvgpr_read_b32 v3, a158
		v_accvgpr_read_b32 v8, a159
		v_cvt_pk_bf16_f32 v43, v3, v8
		v_accvgpr_read_b32 v3, a160
		v_accvgpr_read_b32 v8, a161
		v_cvt_pk_bf16_f32 v50, v3, v8
		v_accvgpr_read_b32 v3, a162
		v_accvgpr_read_b32 v8, a163
		v_cvt_pk_bf16_f32 v51, v3, v8
		v_accvgpr_read_b32 v3, a164
		v_accvgpr_read_b32 v8, a165
		v_cvt_pk_bf16_f32 v54, v3, v8
		v_accvgpr_read_b32 v3, a166
		v_accvgpr_read_b32 v8, a167
		v_cvt_pk_bf16_f32 v55, v3, v8
		v_accvgpr_read_b32 v3, a168
		v_accvgpr_read_b32 v8, a169
		v_cvt_pk_bf16_f32 v58, v3, v8
		v_accvgpr_read_b32 v3, a170
		v_accvgpr_read_b32 v8, a171
		v_cvt_pk_bf16_f32 v59, v3, v8
		v_accvgpr_read_b32 v3, a172
		v_accvgpr_read_b32 v8, a173
		v_cvt_pk_bf16_f32 v60, v3, v8
		v_accvgpr_read_b32 v3, a174
		v_accvgpr_read_b32 v8, a175
		v_cvt_pk_bf16_f32 v61, v3, v8
		v_accvgpr_read_b32 v3, a176
		v_accvgpr_read_b32 v8, a177
		v_cvt_pk_bf16_f32 v64, v3, v8
		v_accvgpr_read_b32 v3, a178
		v_accvgpr_read_b32 v8, a179
		v_cvt_pk_bf16_f32 v65, v3, v8
		v_accvgpr_read_b32 v3, a180
		v_accvgpr_read_b32 v8, a181
		v_cvt_pk_bf16_f32 v68, v3, v8
		v_accvgpr_read_b32 v3, a182
		v_accvgpr_read_b32 v8, a183
		v_cvt_pk_bf16_f32 v69, v3, v8
		v_accvgpr_read_b32 v3, a184
		v_accvgpr_read_b32 v8, a185
		v_cvt_pk_bf16_f32 v72, v3, v8
		v_accvgpr_read_b32 v3, a186
		v_accvgpr_read_b32 v8, a187
		v_cvt_pk_bf16_f32 v73, v3, v8
		v_accvgpr_read_b32 v3, a188
		v_accvgpr_read_b32 v8, a189
		v_cvt_pk_bf16_f32 v62, v3, v8
		v_accvgpr_read_b32 v3, a190
		v_accvgpr_read_b32 v8, a191
		v_cvt_pk_bf16_f32 v63, v3, v8
		v_accvgpr_read_b32 v3, a192
		v_accvgpr_read_b32 v8, a193
		v_cvt_pk_bf16_f32 v66, v3, v8
		v_accvgpr_read_b32 v3, a194
		v_accvgpr_read_b32 v8, a195
		v_cvt_pk_bf16_f32 v67, v3, v8
		v_accvgpr_read_b32 v3, a196
		v_accvgpr_read_b32 v8, a197
		v_cvt_pk_bf16_f32 v70, v3, v8
		v_accvgpr_read_b32 v3, a198
		v_accvgpr_read_b32 v8, a199
		v_cvt_pk_bf16_f32 v71, v3, v8
		v_accvgpr_read_b32 v3, a200
		v_accvgpr_read_b32 v8, a201
		v_cvt_pk_bf16_f32 v74, v3, v8
		v_accvgpr_read_b32 v3, a202
		v_accvgpr_read_b32 v8, a203
		v_cvt_pk_bf16_f32 v75, v3, v8
		v_accvgpr_read_b32 v3, a204
		v_accvgpr_read_b32 v8, a205
		v_cvt_pk_bf16_f32 v76, v3, v8
		v_accvgpr_read_b32 v3, a206
		v_accvgpr_read_b32 v8, a207
		v_cvt_pk_bf16_f32 v77, v3, v8
		v_accvgpr_read_b32 v3, a208
		v_accvgpr_read_b32 v8, a209
		v_cvt_pk_bf16_f32 v80, v3, v8
		v_accvgpr_read_b32 v3, a210
		v_accvgpr_read_b32 v8, a211
		v_cvt_pk_bf16_f32 v81, v3, v8
		v_accvgpr_read_b32 v3, a212
		v_accvgpr_read_b32 v8, a213
		v_cvt_pk_bf16_f32 v84, v3, v8
		v_accvgpr_read_b32 v3, a214
		v_accvgpr_read_b32 v8, a215
		v_cvt_pk_bf16_f32 v85, v3, v8
		v_accvgpr_read_b32 v3, a216
		v_accvgpr_read_b32 v8, a217
		v_cvt_pk_bf16_f32 v88, v3, v8
		v_accvgpr_read_b32 v3, a218
		v_accvgpr_read_b32 v8, a219
		v_cvt_pk_bf16_f32 v89, v3, v8
		v_accvgpr_read_b32 v3, a220
		v_accvgpr_read_b32 v8, a221
		v_cvt_pk_bf16_f32 v78, v3, v8
		v_accvgpr_read_b32 v3, a222
		v_accvgpr_read_b32 v8, a223
		v_cvt_pk_bf16_f32 v79, v3, v8
		v_accvgpr_read_b32 v3, a224
		v_accvgpr_read_b32 v8, a225
		v_cvt_pk_bf16_f32 v82, v3, v8
		v_accvgpr_read_b32 v3, a226
		v_accvgpr_read_b32 v8, a227
		v_cvt_pk_bf16_f32 v83, v3, v8
		v_accvgpr_read_b32 v3, a228
		v_accvgpr_read_b32 v8, a229
		v_cvt_pk_bf16_f32 v86, v3, v8
		v_accvgpr_read_b32 v3, a230
		v_accvgpr_read_b32 v8, a231
		v_cvt_pk_bf16_f32 v87, v3, v8
		v_accvgpr_read_b32 v3, a232
		v_accvgpr_read_b32 v8, a233
		v_cvt_pk_bf16_f32 v90, v3, v8
		v_accvgpr_read_b32 v3, a234
		v_accvgpr_read_b32 v8, a235
		v_cvt_pk_bf16_f32 v91, v3, v8
		ds_write_b128 v0, v[24:27]
		ds_write_b128 v0, v[28:31] offset:4096
		ds_write_b128 v0, v[32:35] offset:8192
		ds_write_b128 v0, v[36:39] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[40:43]
		ds_write_b128 v0, v[48:51] offset:4096
		ds_write_b128 v0, v[52:55] offset:8192
		ds_write_b128 v0, v[56:59] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v2
		ds_read_b128 v[48:51], v2 offset:256
		ds_read_b128 v[52:55], v2 offset:2048
		ds_read_b128 v[56:59], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[60:63]
		ds_write_b128 v0, v[64:67] offset:4096
		ds_write_b128 v0, v[68:71] offset:8192
		ds_write_b128 v0, v[72:75] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v2
		ds_read_b128 v[64:67], v2 offset:256
		ds_read_b128 v[68:71], v2 offset:2048
		ds_read_b128 v[72:75], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[76:79]
		ds_write_b128 v0, v[80:83] offset:4096
		ds_write_b128 v0, v[84:87] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v2
		ds_read_b128 v[80:83], v2 offset:256
		ds_read_b128 v[84:87], v2 offset:2048
		ds_read_b128 v[88:91], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[92:93], v[24:25]
		v_mov_b64_e32 v[94:95], v[28:29]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v4, v5
		v_add3_u32 v0, v0, v12, v17
		v_add3_u32 v0, v0, v19, v16
		v_add3_u32 v0, v0, v21, v23
		buffer_store_dwordx4 v[92:95], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[12:13], v[32:33]
		v_mov_b64_e32 v[14:15], v[36:37]
		v_add3_u32 v0, v19, v16, v21
		v_add_u32_e32 v0, v0, v23
		v_add3_u32 v2, v10, v0, s0
		buffer_store_dwordx4 v[12:15], v2, s[4:7], 0 offen
		v_mov_b64_e32 v[8:9], v[26:27]
		v_mov_b64_e32 v[10:11], v[30:31]
		v_add3_u32 v2, v6, v0, s0
		buffer_store_dwordx4 v[8:11], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[34:35]
		v_mov_b64_e32 v[10:11], v[38:39]
		v_add3_u32 v0, v7, v0, s0
		buffer_store_dwordx4 v[8:11], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[4:5], v[40:41]
		v_mov_b64_e32 v[6:7], v[48:49]
		v_add3_u32 v0, v19, v16, v21
		v_add_u32_e32 v0, v0, v23
		v_add3_u32 v2, v18, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[52:53]
		v_mov_b64_e32 v[6:7], v[56:57]
		v_add3_u32 v2, v20, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[42:43]
		v_mov_b64_e32 v[6:7], v[50:51]
		v_add3_u32 v0, v22, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[54:55]
		v_mov_b64_e32 v[6:7], v[58:59]
		v_add3_u32 v0, v19, v16, v21
		v_add_u32_e32 v0, v0, v23
		v_add3_u32 v2, v44, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[60:61]
		v_mov_b64_e32 v[6:7], v[64:65]
		v_add3_u32 v2, v45, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[68:69]
		v_mov_b64_e32 v[6:7], v[72:73]
		v_add3_u32 v0, v120, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[62:63]
		v_mov_b64_e32 v[6:7], v[66:67]
		v_add3_u32 v0, v19, v16, v21
		v_add_u32_e32 v0, v0, v23
		v_add3_u32 v2, v121, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[70:71]
		v_mov_b64_e32 v[6:7], v[74:75]
		v_add3_u32 v2, v122, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[76:77]
		v_mov_b64_e32 v[6:7], v[80:81]
		v_add3_u32 v0, v123, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[84:85]
		v_mov_b64_e32 v[6:7], v[88:89]
		v_add3_u32 v0, v19, v16, v21
		v_add_u32_e32 v0, v0, v23
		v_add3_u32 v2, v128, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[78:79]
		v_mov_b64_e32 v[6:7], v[82:83]
		v_add3_u32 v2, v129, v0, s0
		buffer_store_dwordx4 v[4:7], v2, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[86:87]
		v_mov_b64_e32 v[6:7], v[90:91]
		v_add3_u32 v0, v1, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
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
    wave.regalloc.iterations: 100
    wave.regalloc.agpr.dwords: 390
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
