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
		s_mul_hi_u32 s22, s13, s22
		s_mul_i32 s23, s22, s20
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s13, s13, s23
		s_cmp_ge_u32 s13, s20
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s13, s21
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s13, s24, s13
		s_cmp_ge_u32 s13, s20
		s_cselect_b32 s20, 1, 0
		s_add_i32 s23, s22, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s23, s22
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s1, s12, s1
		s_xor_b32 s12, s20, -1
		s_add_i32 s12, s12, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s12, s20
		s_mul_i32 s12, s1, 4
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s20, s13, s21
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s13, s20, s13
		s_xor_b32 s20, s13, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s20, s13
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s16, s0, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s16, s16, 1
		v_readfirstlane_b32 s20, v1
		s_mul_i32 s21, s16, s20
		s_mul_hi_u32 s21, s20, s21
		s_add_i32 s20, s20, s21
		s_mul_hi_u32 s20, s13, s20
		s_mul_i32 s20, s20, s0
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s20, s13, s20
		s_add_i32 s21, s20, s16
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s20, s21, s20
		s_add_i32 s21, s20, s16
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s20, s21, s20
		s_add_i32 s12, s12, s20
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s22, s16, s21
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
		s_add_i32 s16, s13, s16
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s13, s16, s13
		s_add_i32 s16, s21, 1
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s0, s16, s21
		s_mul_i32 s12, s12, 0x100
		s_mul_i32 s13, s12, s14
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s16, v0
		v_lshrrev_b32_e32 v1, 7, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v4, s14, v3
		v_add_u32_e32 v5, v2, v4
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v7, s14, v6
		v_lshlrev_b32_e32 v7, 6, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v9, s14, v8
		v_lshlrev_b32_e32 v9, 5, v9
		v_add3_u32 v5, v5, v7, v9
		v_lshrrev_b32_e32 v10, 3, v0
		v_and_b32_e32 v10, 1, v10
		v_mul_lo_u32 v11, s14, v10
		v_lshlrev_b32_e32 v11, 4, v11
		v_and_b32_e32 v12, 1, v0
		v_lshlrev_b32_e32 v13, 4, v12
		v_add3_u32 v5, v5, v11, v13
		v_lshrrev_b32_e32 v14, 2, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v15, 6, v14
		v_lshrrev_b32_e32 v16, 1, v0
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v17, 5, v16
		v_add3_u32 v5, v5, v15, v17
		s_lshr_b32 s16, s16, 6
		s_mul_i32 s16, 0x420, s16
		s_mov_b32 m0, s16
		s_mul_i32 s21, s0, 0x100
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v18, s22, v2, v4
		v_add3_u32 v18, v18, v7, v9
		v_add3_u32 v18, v18, v11, v13
		v_add3_u32 v18, v18, v15, v17
		s_add_i32 m0, s16, 0x1080
		s_mul_i32 s21, s21, s15
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v19, v2, v4, v7
		v_add3_u32 v19, v19, v9, v11
		v_add3_u32 v19, v19, v13, v15
		s_add_i32 m0, s16, 0x2100
		v_add3_u32 v20, v17, v19, s28
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s16, 0x3180
		v_add3_u32 v21, v17, v19, s29
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s16, 0x4200
		v_add3_u32 v19, v17, v19, s30
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v22, v2, v4, v7
		v_add3_u32 v22, v22, v9, v11
		v_add3_u32 v22, v22, v13, v15
		s_add_i32 m0, s16, 0x5280
		v_add3_u32 v23, v17, v22, s31
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s16, 0x6300
		v_add3_u32 v24, v17, v22, s32
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s16, 0x7380
		v_add3_u32 v22, v17, v22, s14
		s_add_u32 s36, s4, s21
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v25, s15, v1
		v_lshlrev_b32_e32 v25, 1, v25
		v_mul_lo_u32 v26, s15, v3
		v_add_u32_e32 v27, v25, v26
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		v_mul_lo_u32 v28, s15, v6
		v_lshlrev_b32_e32 v28, 6, v28
		v_mul_lo_u32 v29, s15, v8
		v_lshlrev_b32_e32 v29, 5, v29
		v_add3_u32 v27, v27, v28, v29
		v_mul_lo_u32 v30, s15, v10
		v_lshlrev_b32_e32 v30, 4, v30
		v_add3_u32 v27, v27, v30, v13
		s_add_i32 m0, s16, 0x107e0
		v_add3_u32 v27, v27, v15, v17
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v31, v25, v26, v28
		v_add3_u32 v31, v31, v29, v30
		v_add3_u32 v31, v31, v13, v15
		s_add_i32 m0, s16, 0x11860
		v_add3_u32 v32, v17, v31, s33
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s16, 0x128e0
		v_add3_u32 v33, v17, v31, s34
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s16, 0x13960
		v_add3_u32 v31, v17, v31, s35
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v34, s18, v1
		v_lshlrev_b32_e32 v34, 2, v34
		v_mul_lo_u32 v35, s18, v3
		v_lshlrev_b32_e32 v35, 1, v35
		v_add3_u32 v36, s1, v34, v35
		v_mul_lo_u32 v37, s18, v6
		v_lshlrev_b32_e32 v38, 3, v12
		v_add3_u32 v36, v36, v37, v38
		v_lshlrev_b32_e32 v39, 7, v8
		v_lshlrev_b32_e32 v40, 6, v10
		v_add3_u32 v36, v36, v39, v40
		v_lshlrev_b32_e32 v41, 5, v14
		v_lshlrev_b32_e32 v42, 4, v16
		v_add3_u32 v36, v36, v41, v42
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx2 v[44:45], v36, s[40:43], 0 offen
		s_lshl_b32 s20, s0, 8
		v_mul_lo_u32 v43, s19, v1
		v_lshlrev_b32_e32 v43, 2, v43
		v_mul_lo_u32 v46, s19, v3
		v_lshlrev_b32_e32 v46, 1, v46
		v_add3_u32 v47, s20, v43, v46
		v_mul_lo_u32 v48, s19, v6
		v_lshlrev_b32_e32 v12, 2, v12
		v_add3_u32 v47, v47, v48, v12
		v_lshlrev_b32_e32 v49, 6, v8
		v_lshlrev_b32_e32 v50, 5, v10
		v_add3_u32 v47, v47, v49, v50
		v_lshlrev_b32_e32 v14, 4, v14
		v_lshlrev_b32_e32 v51, 3, v16
		v_add3_u32 v47, v47, v14, v51
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dword v52, v47, s[44:47], 0 offen
		s_lshl_b32 s48, s15, 7
		v_add3_u32 v53, s48, v25, v26
		v_add3_u32 v53, v53, v28, v29
		v_add3_u32 v53, v53, v30, v13
		s_add_i32 m0, s16, 0x18bc0
		v_add3_u32 v53, v53, v15, v17
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v54, v25, v26, v28
		v_add3_u32 v54, v54, v29, v30
		v_add3_u32 v54, v54, v13, v15
		s_add_i32 m0, s16, 0x19c40
		v_add3_u32 v55, v17, v54, s49
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, s16, 0x1acc0
		v_add3_u32 v56, v17, v54, s50
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s16, 0x1bd40
		v_add3_u32 v54, v17, v54, s15
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		s_add_i32 s51, s20, 0x80
		v_add3_u32 v57, s51, v43, v46
		v_add3_u32 v57, v57, v48, v12
		v_add3_u32 v57, v57, v49, v50
		v_add3_u32 v57, v57, v14, v51
		buffer_load_dword v58, v57, s[44:47], 0 offen
		v_add_u32_e32 v59, 0x80, v2
		v_add_u32_e32 v59, v59, v4
		v_add3_u32 v59, v59, v7, v9
		v_add3_u32 v59, v59, v11, v13
		s_add_i32 m0, s16, 0x8400
		v_add3_u32 v59, v59, v15, v17
		buffer_load_dwordx4 v59, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v60, s22, v2, v4
		v_add3_u32 v60, v60, v7, v9
		v_add3_u32 v60, v60, v11, v13
		s_add_i32 m0, s16, 0x9480
		v_add3_u32 v60, v60, v15, v17
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v61, s22, v2, v4
		v_add3_u32 v61, v61, v7, v9
		v_add3_u32 v61, v61, v11, v13
		s_add_i32 m0, s16, 0xa500
		v_add3_u32 v61, v61, v15, v17
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v62, s22, v2, v4
		v_add3_u32 v62, v62, v7, v9
		v_add3_u32 v62, v62, v11, v13
		s_add_i32 m0, s16, 0xb580
		v_add3_u32 v62, v62, v15, v17
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v63, s22, v2, v4
		v_add3_u32 v63, v63, v7, v9
		v_add3_u32 v63, v63, v11, v13
		s_add_i32 m0, s16, 0xc600
		v_add3_u32 v63, v63, v15, v17
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v64, s22, v2, v4
		v_add3_u32 v64, v64, v7, v9
		v_add3_u32 v64, v64, v11, v13
		s_add_i32 m0, s16, 0xd680
		v_add3_u32 v64, v64, v15, v17
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v65, s22, v2, v4
		v_add3_u32 v65, v65, v7, v9
		v_add3_u32 v65, v65, v11, v13
		s_add_i32 m0, s16, 0xe700
		v_add3_u32 v65, v65, v15, v17
		buffer_load_dwordx4 v65, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v4
		v_add3_u32 v2, v2, v7, v9
		v_add3_u32 v2, v2, v11, v13
		s_add_i32 m0, s16, 0xf780
		v_add3_u32 v2, v2, v15, v17
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v25
		v_add_u32_e32 v4, v4, v26
		v_add3_u32 v4, v4, v28, v29
		v_add3_u32 v4, v4, v30, v13
		s_add_i32 m0, s16, 0x149e0
		v_add3_u32 v4, v4, v15, v17
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v7, v25, v26, v28
		v_add3_u32 v7, v7, v29, v30
		v_add3_u32 v7, v7, v13, v15
		s_add_i32 m0, s16, 0x15a60
		v_add3_u32 v9, v17, v7, s14
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s16, 0x16ae0
		v_add3_u32 v11, v17, v7, s14
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s16, 0x17b60
		v_add3_u32 v7, v17, v7, s14
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_add3_u32 v34, s1, v34, v35
		v_add3_u32 v34, v34, v37, v38
		v_add3_u32 v34, v34, v39, v40
		v_add3_u32 v34, v34, v41, v42
		buffer_load_dwordx2 v[66:67], v34, s[40:43], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s20, s1
		v_add3_u32 v35, s14, v43, v46
		v_add3_u32 v35, v35, v48, v12
		v_add3_u32 v35, v35, v49, v50
		v_add3_u32 v35, v35, v14, v51
		buffer_load_dword v37, v35, s[44:47], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v42, s14, v25, v26
		v_add3_u32 v42, v42, v28, v29
		v_add3_u32 v42, v42, v30, v13
		s_add_i32 m0, s16, 0x1cdc0
		v_add3_u32 v42, v42, v15, v17
		buffer_load_dwordx4 v42, s[36:39], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v25, v25, v26, v28
		v_add3_u32 v25, v25, v29, v30
		v_add3_u32 v25, v25, v13, v15
		s_add_i32 m0, s16, 0x1de40
		v_add3_u32 v26, v17, v25, s14
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, s16, 0x1eec0
		v_add3_u32 v28, v17, v25, s14
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s16, 0x1ff40
		v_add3_u32 v25, v17, v25, s14
		buffer_load_dwordx4 v25, s[36:39], 0 offen lds
		s_add_i32 s1, s51, s1
		v_add3_u32 v29, s1, v43, v46
		v_add3_u32 v12, v29, v48, v12
		v_add3_u32 v12, v12, v49, v50
		v_add3_u32 v12, v12, v14, v51
		buffer_load_dword v14, v12, s[44:47], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s21, 0x100
		s_mul_i32 s14, s18, 16
		s_mul_i32 s15, s19, 16
		v_lshlrev_b32_e32 v29, 7, v1
		v_and_b32_e32 v30, 63, v0
		v_lshrrev_b32_e32 v43, 4, v30
		v_lshlrev_b32_e32 v46, 4, v43
		v_and_b32_e32 v48, 15, v30
		v_mov_b32_e32 v49, 0x420
		v_mul_lo_u32 v49, v49, v48
		v_add3_u32 v29, v29, v46, v49
		ds_read_b128 a[0:3], v29
		ds_read_b128 a[4:7], v29 offset:64
		ds_read_b128 a[8:11], v29 offset:256
		ds_read_b128 a[12:15], v29 offset:320
		ds_read_b128 a[16:19], v29 offset:512
		ds_read_b128 a[20:23], v29 offset:576
		ds_read_b128 a[24:27], v29 offset:768
		ds_read_b128 a[28:31], v29 offset:832
		ds_read_b128 a[32:35], v29 offset:16896
		ds_read_b128 a[36:39], v29 offset:16960
		ds_read_b128 a[40:43], v29 offset:17152
		ds_read_b128 a[44:47], v29 offset:17216
		ds_read_b128 a[48:51], v29 offset:17408
		ds_read_b128 a[52:55], v29 offset:17472
		ds_read_b128 a[56:59], v29 offset:17664
		ds_read_b128 a[60:63], v29 offset:17728
		v_add_u32_e32 v46, 0x10000, v46
		v_lshlrev_b32_e32 v48, 7, v3
		v_add3_u32 v46, v46, v48, v49
		ds_read_b128 a[64:67], v46 offset:2016
		ds_read_b128 a[68:71], v46 offset:2080
		ds_read_b128 a[72:75], v46 offset:2272
		ds_read_b128 a[76:79], v46 offset:2336
		ds_read_b128 a[80:83], v46 offset:2528
		ds_read_b128 a[84:87], v46 offset:2592
		ds_read_b128 a[88:91], v46 offset:2784
		ds_read_b128 a[92:95], v46 offset:2848
		v_lshlrev_b32_e32 v48, 3, v0
		v_add_u32_e32 v49, 0x20000, v48
		s_waitcnt vmcnt(25)
		ds_write_b64 v49, v[44:45] offset:4000
		v_lshlrev_b32_e32 v44, 2, v0
		v_add_u32_e32 v44, 0x20000, v44
		s_waitcnt vmcnt(24)
		ds_write_b32 v44, v52 offset:6048
		v_lshlrev_b32_e32 v45, 4, v1
		s_waitcnt lgkmcnt(1)
		s_barrier
		v_add_u32_e32 v45, 0x20000, v45
		v_add_u32_e32 v45, v45, v38
		v_lshl_add_u32 v45, v6, 9, v45
		v_lshl_add_u32 v45, v8, 8, v45
		v_add3_u32 v45, v45, v40, v41
		v_lshl_add_u32 v45, v16, 10, v45
		ds_read_b64_tr_b8 v[50:51], v45 offset:4000
		ds_read_b64_tr_b8 v[68:69], v45 offset:4128
		s_waitcnt lgkmcnt(2)
		s_barrier
		v_add_u32_e32 v38, 0x20000, v38
		v_lshl_add_u32 v38, v3, 4, v38
		v_lshlrev_b32_e32 v52, 8, v6
		v_add3_u32 v38, v38, v52, v39
		v_add3_u32 v38, v38, v40, v41
		v_lshl_add_u32 v16, v16, 9, v38
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		s_mov_b32 s18, s14
		s_mov_b32 s19, s15
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_add_u32 s36, s8, s18
		s_addc_u32 s37, s9, 0
		s_add_u32 s40, s10, s19
		s_addc_u32 s41, s11, 0
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
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
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a96, v40
		v_accvgpr_write_b32 a97, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a98, v40
		v_accvgpr_write_b32 a99, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a100, v40
		v_accvgpr_write_b32 a101, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a102, v40
		v_accvgpr_write_b32 a103, v41
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a104, v40
		v_accvgpr_write_b32 a105, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a106, v40
		v_accvgpr_write_b32 a107, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a108, v40
		v_accvgpr_write_b32 a109, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a110, v40
		v_accvgpr_write_b32 a111, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a112, v40
		v_accvgpr_write_b32 a113, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a114, v40
		v_accvgpr_write_b32 a115, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a116, v40
		v_accvgpr_write_b32 a117, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a118, v40
		v_accvgpr_write_b32 a119, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a120, v40
		v_accvgpr_write_b32 a121, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a122, v40
		v_accvgpr_write_b32 a123, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a124, v40
		v_accvgpr_write_b32 a125, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a126, v40
		v_accvgpr_write_b32 a127, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a128, v40
		v_accvgpr_write_b32 a129, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a130, v40
		v_accvgpr_write_b32 a131, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a132, v40
		v_accvgpr_write_b32 a133, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a134, v40
		v_accvgpr_write_b32 a135, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a136, v40
		v_accvgpr_write_b32 a137, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a138, v40
		v_accvgpr_write_b32 a139, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a140, v40
		v_accvgpr_write_b32 a141, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a142, v40
		v_accvgpr_write_b32 a143, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a144, v40
		v_accvgpr_write_b32 a145, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a146, v40
		v_accvgpr_write_b32 a147, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a148, v40
		v_accvgpr_write_b32 a149, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a150, v40
		v_accvgpr_write_b32 a151, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a152, v40
		v_accvgpr_write_b32 a153, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a154, v40
		v_accvgpr_write_b32 a155, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a156, v40
		v_accvgpr_write_b32 a157, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a158, v40
		v_accvgpr_write_b32 a159, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a160, v40
		v_accvgpr_write_b32 a161, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a162, v40
		v_accvgpr_write_b32 a163, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a164, v40
		v_accvgpr_write_b32 a165, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a166, v40
		v_accvgpr_write_b32 a167, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a168, v40
		v_accvgpr_write_b32 a169, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a170, v40
		v_accvgpr_write_b32 a171, v41
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(20) lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v38, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v38, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v38, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v38, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v39, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[0:3], v[84:87], v39, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[8:11], v[100:103], v39, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v39, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v39, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[16:19], v[116:119], v39, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[24:27], v[132:135], v39, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v39, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v38, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v38, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v38, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v38, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v38, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v38, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v38, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v38, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v39, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[32:35], v[148:151], v39, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[40:43], v[164:167], v39, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v39, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v39, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[48:51], v[180:183], v39, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[56:59], v[196:199], v39, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v39, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v38, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v38, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v38, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v38, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v46 offset:35776
		ds_read_b128 a[68:71], v46 offset:35840
		ds_read_b128 a[72:75], v46 offset:36032
		ds_read_b128 a[76:79], v46 offset:36096
		ds_read_b128 a[80:83], v46 offset:36288
		ds_read_b128 a[84:87], v46 offset:36352
		ds_read_b128 a[88:91], v46 offset:36544
		ds_read_b128 v[252:255], v46 offset:36608
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v58 offset:6048
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s16
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x1080
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x2100
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[0:3], v[200:203], v38, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[0:3], v[204:207], v38, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[8:11], v[220:223], v38, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[8:11], v[216:219], v38, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x7380
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[0:3], v[208:211], v39, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[0:3], v[212:215], v39, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[8:11], v[228:231], v39, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[8:11], v[224:227], v39, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[4:7], v[212:215], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[12:15], v[228:231], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[16:19], v[240:243], v39, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[16:19], v[244:247], v39, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v39, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[80:83], a[24:27], v[248:251], v39, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[20:23], v[244:247], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[16:19], v[232:235], v38, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[16:19], v[236:239], v38, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[24:27], a[100:103], v38, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[64:67], a[24:27], a[96:99], v38, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x107e0
		s_nop 0
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x11860
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x128e0
		s_add_u32 s40, s10, s19
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x13960
		s_add_u32 s36, s8, s18
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[40:41], v36, s[36:39], 0 offen
		buffer_load_dword v50, v47, s[40:43], 0 offen
		s_waitcnt vmcnt(21)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[28:31], a[100:103], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[68:71], a[28:31], a[96:99], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v38, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v38, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v38, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v38, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v39, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v39, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v39, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v39, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v39, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v39, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v39, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v39, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v38, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v38, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v38, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v38, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v29 offset:33792
		ds_read_b128 a[4:7], v29 offset:33856
		ds_read_b128 a[8:11], v29 offset:34048
		ds_read_b128 a[12:15], v29 offset:34112
		ds_read_b128 a[16:19], v29 offset:34304
		ds_read_b128 a[20:23], v29 offset:34368
		ds_read_b128 a[24:27], v29 offset:34560
		ds_read_b128 a[28:31], v29 offset:34624
		ds_read_b128 a[32:35], v29 offset:50688
		ds_read_b128 a[36:39], v29 offset:50752
		ds_read_b128 a[40:43], v29 offset:50944
		ds_read_b128 a[44:47], v29 offset:51008
		ds_read_b128 a[48:51], v29 offset:51200
		ds_read_b128 a[52:55], v29 offset:51264
		ds_read_b128 a[56:59], v29 offset:51456
		ds_read_b128 a[60:63], v29 offset:51520
		ds_read_b128 a[64:67], v46 offset:18912
		ds_read_b128 a[68:71], v46 offset:18976
		ds_read_b128 a[72:75], v46 offset:19168
		ds_read_b128 a[76:79], v46 offset:19232
		ds_read_b128 a[80:83], v46 offset:19424
		ds_read_b128 a[84:87], v46 offset:19488
		ds_read_b128 v[68:71], v46 offset:19680
		ds_read_b128 a[88:91], v46 offset:19744
		s_waitcnt vmcnt(20)
		ds_write_b64 v49, v[66:67] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v37 offset:6048
		s_add_i32 m0, s16, 0x18bc0
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v45 offset:4000
		ds_read_b64_tr_b8 v[252:253], v45 offset:4128
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v16 offset:6048
		buffer_load_dwordx4 v53, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x19c40
		s_nop 0
		buffer_load_dwordx4 v55, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1acc0
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v66, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1bd40
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v66, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v54, s[32:35], 0 offen lds
		buffer_load_dword v58, v57, s[40:43], 0 offen
		s_waitcnt vmcnt(20)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v66, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v66, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v66, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v66, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v66, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v66, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v67, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], a[0:3], v[84:87], v67, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], a[8:11], v[100:103], v67, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v67, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v67, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[4:7], v[84:87], v67, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[12:15], v[100:103], v67, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v67, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v67, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], a[16:19], v[116:119], v67, v39 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], a[24:27], v[132:135], v67, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v67, v39 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v67, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[20:23], v[116:119], v67, v39 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[28:31], v[132:135], v67, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v67, v39 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v66, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v66, v39 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v66, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v66, v39 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v66, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v66, v39 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v66, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v66, v39 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v66, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v66, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v66, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v66, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v66, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v66, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v66, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v66, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v67, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], a[32:35], v[148:151], v67, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[68:71], a[40:43], v[164:167], v67, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v67, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v67, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[36:39], v[148:151], v67, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[44:47], v[164:167], v67, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v67, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v67, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[68:71], a[48:51], v[180:183], v67, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], a[56:59], v[196:199], v67, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v67, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v67, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[52:55], v[180:183], v67, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[60:63], v[196:199], v67, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v67, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v66, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v66, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v66, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v66, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v66, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v66, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v66, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v66, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v46 offset:52672
		ds_read_b128 a[68:71], v46 offset:52736
		ds_read_b128 a[72:75], v46 offset:52928
		ds_read_b128 a[76:79], v46 offset:52992
		ds_read_b128 a[80:83], v46 offset:53184
		ds_read_b128 a[84:87], v46 offset:53248
		ds_read_b128 a[88:91], v46 offset:53440
		ds_read_b128 v[68:71], v46 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v14 offset:6048
		s_add_i32 m0, s16, 0x8400
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[254:255], v16 offset:6048
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x9480
		s_nop 0
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xa500
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[0:3], v[200:203], v254, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v61, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xb580
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[0:3], v[204:207], v254, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v62, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xc600
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[8:11], v[220:223], v254, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xd680
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[8:11], v[216:219], v254, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xe700
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v254, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xf780
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v254, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v254, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v254, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[0:3], v[208:211], v255, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[0:3], v[212:215], v255, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[8:11], v[228:231], v255, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[8:11], v[224:227], v255, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v255, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], a[4:7], v[212:215], v255, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[68:71], a[12:15], v[228:231], v255, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v255, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[16:19], v[240:243], v255, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[16:19], v[244:247], v255, v39 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v255, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[80:83], a[24:27], v[248:251], v255, v39 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v255, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[68:71], a[20:23], v[244:247], v255, v39 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[28:31], a[104:107], v255, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v255, v39 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[16:19], v[232:235], v254, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[16:19], v[236:239], v254, v39 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[24:27], a[100:103], v254, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[64:67], a[24:27], a[96:99], v254, v39 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v254, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v254, v39 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x149e0
		s_add_i32 s19, s19, s15
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x15a60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[28:31], a[100:103], v254, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x16ae0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[68:71], a[28:31], a[96:99], v254, v39 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x17b60
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[66:67], v34, s[36:39], 0 offen
		buffer_load_dword v37, v35, s[40:43], 0 offen
		s_waitcnt vmcnt(21)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v254, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v254, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v254, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v254, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v255, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v255, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v255, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v255, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], a[36:39], a[120:123], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[44:47], a[136:139], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v255, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v255, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v255, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v255, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[52:55], a[152:155], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[60:63], a[168:171], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v254, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v254, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v254, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v254, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v29
		ds_read_b128 a[4:7], v29 offset:64
		ds_read_b128 a[8:11], v29 offset:256
		ds_read_b128 a[12:15], v29 offset:320
		ds_read_b128 a[16:19], v29 offset:512
		ds_read_b128 a[20:23], v29 offset:576
		ds_read_b128 a[24:27], v29 offset:768
		ds_read_b128 a[28:31], v29 offset:832
		ds_read_b128 a[32:35], v29 offset:16896
		ds_read_b128 a[36:39], v29 offset:16960
		ds_read_b128 a[40:43], v29 offset:17152
		ds_read_b128 a[44:47], v29 offset:17216
		ds_read_b128 a[48:51], v29 offset:17408
		ds_read_b128 a[52:55], v29 offset:17472
		ds_read_b128 a[56:59], v29 offset:17664
		ds_read_b128 a[60:63], v29 offset:17728
		ds_read_b128 a[64:67], v46 offset:2016
		ds_read_b128 a[68:71], v46 offset:2080
		ds_read_b128 a[72:75], v46 offset:2272
		ds_read_b128 a[76:79], v46 offset:2336
		ds_read_b128 a[80:83], v46 offset:2528
		ds_read_b128 a[84:87], v46 offset:2592
		ds_read_b128 a[88:91], v46 offset:2784
		ds_read_b128 a[92:95], v46 offset:2848
		s_waitcnt vmcnt(20)
		ds_write_b64 v49, v[40:41] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v50 offset:6048
		s_add_i32 m0, s16, 0x1cdc0
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[50:51], v45 offset:4000
		ds_read_b64_tr_b8 v[68:69], v45 offset:4128
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1de40
		s_add_i32 s18, s18, s14
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1eec0
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1ff40
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v25, s[32:35], 0 offen lds
		buffer_load_dword v14, v12, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(1) lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v38, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v38, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v38, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v38, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v39, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[0:3], v[84:87], v39, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[8:11], v[100:103], v39, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v39, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v39, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[16:19], v[116:119], v39, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[24:27], v[132:135], v39, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v39, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v38, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v38, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v38, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v38, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v38, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v38, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v38, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v38, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v38, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v38, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v39, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[32:35], v[148:151], v39, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[40:43], v[164:167], v39, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v39, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v39, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v39, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v39, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[48:51], v[180:183], v39, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[56:59], v[196:199], v39, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v39, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v39, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v39, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v38, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v38, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v38, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v38, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v38, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v38, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v46 offset:35776
		ds_read_b128 a[64:67], v46 offset:35840
		ds_read_b128 v[24:27], v46 offset:36032
		ds_read_b128 a[68:71], v46 offset:36096
		ds_read_b128 v[32:35], v46 offset:36288
		ds_read_b128 v[52:55], v46 offset:36352
		ds_read_b128 v[60:63], v46 offset:36544
		ds_read_b128 v[252:255], v46 offset:36608
		ds_write_b32 v44, v58 offset:6048
		v_xor_b32_e32 v2, 2, v0
		v_lshlrev_b32_e32 v2, 3, v2
		v_xor_b32_e32 v4, 4, v0
		v_lshlrev_b32_e32 v4, 3, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[18:19], v16 offset:6048
		ds_read_b128 a[72:75], v29 offset:33792
		ds_read_b128 a[76:79], v29 offset:33856
		ds_read_b128 a[80:83], v29 offset:34048
		ds_read_b128 a[84:87], v29 offset:34112
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], a[0:3], v[200:203], v18, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], a[0:3], v[204:207], v18, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], a[8:11], v[220:223], v18, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[20:23], a[8:11], v[216:219], v18, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[4:7], v[200:203], v18, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[4:7], v[204:207], v18, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[12:15], v[220:223], v18, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[12:15], v[216:219], v18, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], a[0:3], v[208:211], v19, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[60:63], a[0:3], v[212:215], v19, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[60:63], a[8:11], v[228:231], v19, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], a[8:11], v[224:227], v19, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[52:55], a[4:7], v[208:211], v19, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[4:7], v[212:215], v19, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[12:15], v[228:231], v19, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], a[12:15], v[224:227], v19, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[16:19], v[240:243], v19, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[60:63], a[16:19], v[244:247], v19, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[60:63], a[24:27], a[104:107], v19, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[24:27], v[248:251], v19, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[52:55], a[20:23], v[240:243], v19, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[20:23], v[244:247], v19, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v19, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[28:31], v[248:251], v19, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[20:23], a[16:19], v[232:235], v18, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[24:27], a[16:19], v[236:239], v18, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], a[24:27], a[100:103], v18, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], a[24:27], a[96:99], v18, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[20:23], v[232:235], v18, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[20:23], v[236:239], v18, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v18, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[64:67], a[28:31], a[96:99], v18, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[32:35], a[108:111], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], a[32:35], a[112:115], v18, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], a[40:43], a[128:131], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[40:43], a[124:127], v18, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[36:39], a[108:111], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[44:47], a[124:127], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], a[32:35], a[116:119], v19, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], a[32:35], a[120:123], v19, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], a[40:43], a[136:139], v19, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], a[40:43], a[132:135], v19, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[36:39], a[116:119], v19, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v19, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v19, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[44:47], a[132:135], v19, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], a[48:51], a[148:151], v19, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], a[48:51], a[152:155], v19, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], a[56:59], a[168:171], v19, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], a[56:59], a[164:167], v19, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[52:55], a[148:151], v19, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v19, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v19, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[60:63], a[164:167], v19, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[48:51], a[140:143], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], a[48:51], a[144:147], v18, v69 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], a[56:59], a[160:163], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[56:59], a[156:159], v18, v69 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[52:55], a[140:143], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[60:63], a[156:159], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v29 offset:34304
		ds_read_b128 a[4:7], v29 offset:34368
		ds_read_b128 a[8:11], v29 offset:34560
		ds_read_b128 a[12:15], v29 offset:34624
		ds_read_b128 a[16:19], v29 offset:50688
		ds_read_b128 a[20:23], v29 offset:50752
		ds_read_b128 a[24:27], v29 offset:50944
		ds_read_b128 a[28:31], v29 offset:51008
		ds_read_b128 a[32:35], v29 offset:51200
		ds_read_b128 a[36:39], v29 offset:51264
		ds_read_b128 a[40:43], v29 offset:51456
		ds_read_b128 a[44:47], v29 offset:51520
		ds_read_b128 v[20:23], v46 offset:18912
		ds_read_b128 v[24:27], v46 offset:18976
		ds_read_b128 v[32:35], v46 offset:19168
		ds_read_b128 v[52:55], v46 offset:19232
		ds_read_b128 v[56:59], v46 offset:19424
		ds_read_b128 v[60:63], v46 offset:19488
		ds_read_b128 v[68:71], v46 offset:19680
		ds_read_b128 v[252:255], v46 offset:19744
		ds_write_b64 v49, v[66:67] offset:4000
		s_barrier
		ds_write_b32 v44, v37 offset:6048
		v_xor_b32_e32 v0, 6, v0
		v_lshlrev_b32_e32 v0, 3, v0
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[18:19], v45 offset:4000
		ds_read_b64_tr_b8 v[28:29], v45 offset:4128
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[36:37], v16 offset:6048
		ds_read_b128 a[48:51], v46 offset:52672
		ds_read_b128 a[52:55], v46 offset:52736
		ds_read_b128 a[56:59], v46 offset:52928
		ds_read_b128 v[64:67], v46 offset:52992
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], a[72:75], v[72:75], v36, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], a[72:75], v[76:79], v36, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], a[80:83], v[92:95], v36, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], a[80:83], v[88:91], v36, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[24:27], a[76:79], v[72:75], v36, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[52:55], a[76:79], v[76:79], v36, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[52:55], a[84:87], v[92:95], v36, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], a[84:87], v[88:91], v36, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[56:59], a[72:75], v[80:83], v37, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], a[72:75], v[84:87], v37, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], a[80:83], v[100:103], v37, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[56:59], a[80:83], v[96:99], v37, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[60:63], a[76:79], v[80:83], v37, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], a[76:79], v[84:87], v37, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], a[84:87], v[100:103], v37, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[60:63], a[84:87], v[96:99], v37, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[56:59], a[0:3], v[112:115], v37, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], a[0:3], v[116:119], v37, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], a[8:11], v[132:135], v37, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[56:59], a[8:11], v[128:131], v37, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[60:63], a[4:7], v[112:115], v37, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], a[4:7], v[116:119], v37, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[12:15], v[132:135], v37, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[60:63], a[12:15], v[128:131], v37, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], a[0:3], v[104:107], v36, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], a[0:3], v[108:111], v36, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], a[8:11], v[124:127], v36, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], a[8:11], v[120:123], v36, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], a[4:7], v[104:107], v36, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[52:55], a[4:7], v[108:111], v36, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[52:55], a[12:15], v[124:127], v36, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], a[12:15], v[120:123], v36, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], a[16:19], v[136:139], v36, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], a[16:19], v[140:143], v36, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], a[24:27], v[156:159], v36, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], a[24:27], v[152:155], v36, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], a[20:23], v[136:139], v36, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[52:55], a[20:23], v[140:143], v36, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], a[28:31], v[156:159], v36, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], a[28:31], v[152:155], v36, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[56:59], a[16:19], v[144:147], v37, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], a[16:19], v[148:151], v37, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[68:71], a[24:27], v[164:167], v37, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], a[24:27], v[160:163], v37, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[60:63], a[20:23], v[144:147], v37, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[20:23], v[148:151], v37, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[28:31], v[164:167], v37, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[60:63], a[28:31], v[160:163], v37, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], a[32:35], v[176:179], v37, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[68:71], a[32:35], v[180:183], v37, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], a[40:43], v[196:199], v37, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], a[40:43], v[192:195], v37, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], a[36:39], v[176:179], v37, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[36:39], v[180:183], v37, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[44:47], v[196:199], v37, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], a[44:47], v[192:195], v37, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], a[32:35], v[168:171], v36, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], a[32:35], v[172:175], v36, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], a[40:43], v[188:191], v36, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], a[40:43], v[184:187], v36, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[36:39], v[168:171], v36, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], a[36:39], v[172:175], v36, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], a[44:47], v[188:191], v36, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[44:47], v[184:187], v36, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v46 offset:53184
		ds_read_b128 v[24:27], v46 offset:53248
		ds_read_b128 v[32:35], v46 offset:53440
		ds_read_b128 v[36:39], v46 offset:53504
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v44, v14 offset:6048
		v_cvt_pk_bf16_f32 v40, v72, v73
		v_cvt_pk_bf16_f32 v41, v74, v75
		v_cvt_pk_bf16_f32 v44, v76, v77
		v_cvt_pk_bf16_f32 v45, v78, v79
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[46:47], v16 offset:6048
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v50, v80, v81
		v_cvt_pk_bf16_f32 v51, v82, v83
		v_cvt_pk_bf16_f32 v52, v84, v85
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_cvt_pk_bf16_f32 v53, v86, v87
		v_cvt_pk_bf16_f32 v54, v88, v89
		v_cvt_pk_bf16_f32 v55, v90, v91
		ds_write2st64_b64 v48, v[40:41], v[54:55] offset1:16
		v_cvt_pk_bf16_f32 v40, v92, v93
		v_cvt_pk_bf16_f32 v41, v94, v95
		ds_write2st64_b64 v2, v[44:45], v[40:41] offset0:4 offset1:20
		v_cvt_pk_bf16_f32 v40, v96, v97
		v_cvt_pk_bf16_f32 v41, v98, v99
		ds_write2st64_b64 v4, v[50:51], v[40:41] offset0:8 offset1:24
		v_cvt_pk_bf16_f32 v40, v100, v101
		v_cvt_pk_bf16_f32 v41, v102, v103
		ds_write2st64_b64 v0, v[52:53], v[40:41] offset0:12 offset1:28
		v_cvt_pk_bf16_f32 v40, v104, v105
		v_cvt_pk_bf16_f32 v41, v106, v107
		v_cvt_pk_bf16_f32 v44, v108, v109
		v_cvt_pk_bf16_f32 v45, v110, v111
		v_cvt_pk_bf16_f32 v50, v112, v113
		v_cvt_pk_bf16_f32 v51, v114, v115
		v_cvt_pk_bf16_f32 v52, v116, v117
		v_cvt_pk_bf16_f32 v53, v118, v119
		v_cvt_pk_bf16_f32 v54, v120, v121
		v_cvt_pk_bf16_f32 v55, v122, v123
		ds_write2st64_b64 v48, v[40:41], v[54:55] offset0:32 offset1:48
		v_cvt_pk_bf16_f32 v40, v124, v125
		v_cvt_pk_bf16_f32 v41, v126, v127
		ds_write2st64_b64 v2, v[44:45], v[40:41] offset0:36 offset1:52
		v_cvt_pk_bf16_f32 v40, v128, v129
		v_cvt_pk_bf16_f32 v41, v130, v131
		ds_write2st64_b64 v4, v[50:51], v[40:41] offset0:40 offset1:56
		v_cvt_pk_bf16_f32 v40, v132, v133
		v_cvt_pk_bf16_f32 v41, v134, v135
		ds_write2st64_b64 v0, v[52:53], v[40:41] offset0:44 offset1:60
		v_cvt_pk_bf16_f32 v40, v136, v137
		v_cvt_pk_bf16_f32 v41, v138, v139
		v_cvt_pk_bf16_f32 v44, v140, v141
		v_cvt_pk_bf16_f32 v45, v142, v143
		v_cvt_pk_bf16_f32 v50, v144, v145
		v_cvt_pk_bf16_f32 v51, v146, v147
		v_cvt_pk_bf16_f32 v52, v148, v149
		v_cvt_pk_bf16_f32 v53, v150, v151
		v_cvt_pk_bf16_f32 v54, v152, v153
		v_cvt_pk_bf16_f32 v55, v154, v155
		ds_write2st64_b64 v48, v[40:41], v[54:55] offset0:64 offset1:80
		v_cvt_pk_bf16_f32 v40, v156, v157
		v_cvt_pk_bf16_f32 v41, v158, v159
		ds_write2st64_b64 v2, v[44:45], v[40:41] offset0:68 offset1:84
		v_cvt_pk_bf16_f32 v40, v160, v161
		v_cvt_pk_bf16_f32 v41, v162, v163
		ds_write2st64_b64 v4, v[50:51], v[40:41] offset0:72 offset1:88
		v_cvt_pk_bf16_f32 v40, v164, v165
		v_cvt_pk_bf16_f32 v41, v166, v167
		ds_write2st64_b64 v0, v[52:53], v[40:41] offset0:76 offset1:92
		v_cvt_pk_bf16_f32 v40, v168, v169
		v_cvt_pk_bf16_f32 v41, v170, v171
		v_cvt_pk_bf16_f32 v44, v172, v173
		v_cvt_pk_bf16_f32 v45, v174, v175
		v_cvt_pk_bf16_f32 v50, v176, v177
		v_cvt_pk_bf16_f32 v51, v178, v179
		v_cvt_pk_bf16_f32 v52, v180, v181
		v_cvt_pk_bf16_f32 v53, v182, v183
		v_cvt_pk_bf16_f32 v54, v184, v185
		v_cvt_pk_bf16_f32 v55, v186, v187
		ds_write2st64_b64 v48, v[40:41], v[54:55] offset0:96 offset1:112
		v_cvt_pk_bf16_f32 v40, v188, v189
		v_cvt_pk_bf16_f32 v41, v190, v191
		ds_write2st64_b64 v2, v[44:45], v[40:41] offset0:100 offset1:116
		v_cvt_pk_bf16_f32 v40, v192, v193
		v_cvt_pk_bf16_f32 v41, v194, v195
		ds_write2st64_b64 v4, v[50:51], v[40:41] offset0:104 offset1:120
		v_cvt_pk_bf16_f32 v40, v196, v197
		v_cvt_pk_bf16_f32 v41, v198, v199
		ds_write2st64_b64 v0, v[52:53], v[40:41] offset0:108 offset1:124
		v_lshrrev_b32_e32 v5, 3, v30
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v7, 12, v5
		v_lshrrev_b32_e32 v9, 2, v30
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v9, 1, v9
		v_lshl_add_u32 v11, v9, 11, v7
		v_lshlrev_b32_e32 v12, 1, v9
		v_lshl_add_u32 v12, v5, 2, v12
		v_lshrrev_b32_e32 v14, 1, v30
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 6, v14
		v_lshlrev_b32_e32 v16, 3, v1
		v_lshlrev_b32_e32 v31, 2, v3
		v_and_b32_e32 v40, 1, v43
		v_and_b32_e32 v41, 1, v30
		v_lshl_add_u32 v42, v41, 5, v40
		v_lshrrev_b32_e32 v30, 5, v30
		v_lshlrev_b32_e32 v30, 1, v30
		v_xor_b32_e32 v42, v42, v30
		v_bitop3_b32 v42, v16, v31, v42 bitop3:0x96
		v_add_u32_e32 v43, v14, v42
		v_xor_b32_e32 v44, v12, v43
		v_lshl_add_u32 v45, v44, 3, v11
		ds_read_b64 v[52:53], v45
		v_lshl_add_u32 v41, v41, 5, 16
		v_bitop3_b32 v30, v30, v41, v40 bitop3:0x96
		v_bitop3_b32 v30, v16, v31, v30 bitop3:0x96
		v_add_u32_e32 v40, v14, v30
		v_xor_b32_e32 v41, v12, v40
		v_lshl_add_u32 v45, v41, 3, v11
		ds_read_b64 v[54:55], v45
		v_add_u32_e32 v14, 0x80, v14
		v_add_u32_e32 v42, v14, v42
		v_xor_b32_e32 v45, v12, v42
		v_lshl_add_u32 v49, v45, 3, v11
		ds_read_b64 v[56:57], v49
		v_add_u32_e32 v14, v14, v30
		v_xor_b32_e32 v12, v12, v14
		v_lshl_add_u32 v11, v12, 3, v11
		ds_read_b64 v[58:59], v11
		v_lshlrev_b32_e32 v11, 2, v9
		v_add_u32_e32 v30, 16, v11
		v_lshlrev_b32_e32 v5, 3, v5
		v_xor_b32_e32 v30, v30, v5
		v_lshrrev_b32_e32 v30, 2, v30
		v_and_b32_e32 v49, 3, v30
		v_lshlrev_b32_e32 v49, 1, v49
		v_xor_b32_e32 v50, v43, v49
		v_lshlrev_b32_e32 v30, 11, v30
		v_lshl_add_u32 v51, v50, 3, v30
		ds_read_b64 v[60:61], v51
		v_xor_b32_e32 v51, v40, v49
		v_lshl_add_u32 v68, v51, 3, v30
		ds_read_b64 v[62:63], v68
		v_xor_b32_e32 v68, v42, v49
		v_lshl_add_u32 v69, v68, 3, v30
		ds_read_b64 v[72:73], v69
		v_xor_b32_e32 v49, v14, v49
		v_lshl_add_u32 v69, v49, 3, v30
		ds_read_b64 v[74:75], v69
		v_add_u32_e32 v69, 32, v11
		v_xor_b32_e32 v69, v69, v5
		v_lshrrev_b32_e32 v69, 2, v69
		v_and_b32_e32 v70, 3, v69
		v_lshlrev_b32_e32 v70, 1, v70
		v_xor_b32_e32 v71, v43, v70
		v_lshlrev_b32_e32 v69, 11, v69
		v_lshl_add_u32 v76, v71, 3, v69
		ds_read_b64 v[80:81], v76
		v_xor_b32_e32 v76, v40, v70
		v_lshl_add_u32 v77, v76, 3, v69
		ds_read_b64 v[82:83], v77
		v_xor_b32_e32 v77, v42, v70
		v_lshl_add_u32 v78, v77, 3, v69
		ds_read_b64 v[84:85], v78
		v_xor_b32_e32 v70, v14, v70
		v_lshl_add_u32 v78, v70, 3, v69
		ds_read_b64 v[86:87], v78
		v_add_u32_e32 v78, 48, v11
		v_xor_b32_e32 v78, v78, v5
		v_lshrrev_b32_e32 v78, 2, v78
		v_and_b32_e32 v79, 3, v78
		v_lshlrev_b32_e32 v79, 1, v79
		v_xor_b32_e32 v88, v43, v79
		v_lshlrev_b32_e32 v78, 11, v78
		v_lshl_add_u32 v89, v88, 3, v78
		ds_read_b64 v[92:93], v89
		v_xor_b32_e32 v89, v40, v79
		v_lshl_add_u32 v90, v89, 3, v78
		ds_read_b64 v[94:95], v90
		v_xor_b32_e32 v90, v42, v79
		v_lshl_add_u32 v91, v90, 3, v78
		ds_read_b64 v[96:97], v91
		v_xor_b32_e32 v79, v14, v79
		v_lshl_add_u32 v91, v79, 3, v78
		ds_read_b64 v[98:99], v91
		v_add_u32_e32 v91, 64, v11
		v_xor_b32_e32 v91, v91, v5
		v_lshrrev_b32_e32 v91, 2, v91
		v_and_b32_e32 v100, 3, v91
		v_lshlrev_b32_e32 v100, 1, v100
		v_xor_b32_e32 v101, v43, v100
		v_lshlrev_b32_e32 v91, 11, v91
		v_lshl_add_u32 v102, v101, 3, v91
		ds_read_b64 v[104:105], v102
		v_xor_b32_e32 v102, v40, v100
		v_lshl_add_u32 v103, v102, 3, v91
		ds_read_b64 v[106:107], v103
		v_xor_b32_e32 v103, v42, v100
		v_lshl_add_u32 v108, v103, 3, v91
		ds_read_b64 v[112:113], v108
		v_xor_b32_e32 v100, v14, v100
		v_lshl_add_u32 v108, v100, 3, v91
		ds_read_b64 v[114:115], v108
		v_add_u32_e32 v108, 0x50, v11
		v_xor_b32_e32 v108, v108, v5
		v_lshrrev_b32_e32 v108, 2, v108
		v_and_b32_e32 v109, 3, v108
		v_lshlrev_b32_e32 v109, 1, v109
		v_xor_b32_e32 v110, v43, v109
		v_lshlrev_b32_e32 v108, 11, v108
		v_lshl_add_u32 v111, v110, 3, v108
		ds_read_b64 v[116:117], v111
		v_xor_b32_e32 v111, v40, v109
		v_lshl_add_u32 v120, v111, 3, v108
		ds_read_b64 v[118:119], v120
		v_xor_b32_e32 v120, v42, v109
		v_lshl_add_u32 v121, v120, 3, v108
		ds_read_b64 v[124:125], v121
		v_xor_b32_e32 v109, v14, v109
		v_lshl_add_u32 v121, v109, 3, v108
		ds_read_b64 v[126:127], v121
		v_add_u32_e32 v121, 0x60, v11
		v_xor_b32_e32 v121, v121, v5
		v_lshrrev_b32_e32 v121, 2, v121
		v_and_b32_e32 v122, 3, v121
		v_lshlrev_b32_e32 v122, 1, v122
		v_xor_b32_e32 v123, v43, v122
		v_lshlrev_b32_e32 v121, 11, v121
		v_lshl_add_u32 v128, v123, 3, v121
		ds_read_b64 v[132:133], v128
		v_xor_b32_e32 v128, v40, v122
		v_lshl_add_u32 v129, v128, 3, v121
		ds_read_b64 v[134:135], v129
		v_xor_b32_e32 v129, v42, v122
		v_lshl_add_u32 v130, v129, 3, v121
		ds_read_b64 v[136:137], v130
		v_xor_b32_e32 v122, v14, v122
		v_lshl_add_u32 v130, v122, 3, v121
		ds_read_b64 v[138:139], v130
		v_add_u32_e32 v11, 0x70, v11
		v_xor_b32_e32 v5, v11, v5
		v_lshrrev_b32_e32 v5, 2, v5
		v_and_b32_e32 v11, 3, v5
		v_lshlrev_b32_e32 v11, 1, v11
		v_xor_b32_e32 v43, v43, v11
		v_lshlrev_b32_e32 v5, 11, v5
		v_lshl_add_u32 v130, v43, 3, v5
		ds_read_b64 v[140:141], v130
		v_xor_b32_e32 v40, v40, v11
		v_lshl_add_u32 v130, v40, 3, v5
		ds_read_b64 v[142:143], v130
		v_xor_b32_e32 v42, v42, v11
		v_lshl_add_u32 v130, v42, 3, v5
		ds_read_b64 v[144:145], v130
		v_xor_b32_e32 v11, v14, v11
		v_lshl_add_u32 v14, v11, 3, v5
		ds_read_b64 v[146:147], v14
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v14, s0, v1, v3
		v_mul_lo_u32 v130, s17, v6
		v_lshlrev_b32_e32 v130, 2, v130
		v_mul_lo_u32 v131, s17, v8
		v_lshlrev_b32_e32 v131, 1, v131
		v_add3_u32 v14, v14, v130, v131
		v_lshlrev_b32_e32 v10, 7, v10
		v_add3_u32 v14, v14, v13, v10
		v_add3_u32 v14, v14, v15, v17
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[52:55], v14, s[8:11], 0 offen
		v_add_u32_e32 v14, 16, v8
		v_lshlrev_b32_e32 v6, 1, v6
		v_xor_b32_e32 v14, v14, v6
		v_bitop3_b32 v14, v16, v31, v14 bitop3:0x96
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v52, s0, v14
		v_add3_u32 v52, v52, v13, v10
		v_add3_u32 v52, v52, v15, v17
		buffer_store_dwordx4 v[56:59], v52, s[8:11], 0 offen
		v_add_u32_e32 v52, 32, v8
		v_xor_b32_e32 v52, v52, v6
		v_bitop3_b32 v52, v16, v31, v52 bitop3:0x96
		v_mul_lo_u32 v52, s17, v52
		v_lshlrev_b32_e32 v52, 1, v52
		v_add_u32_e32 v53, s0, v52
		v_add3_u32 v53, v53, v13, v10
		v_add3_u32 v53, v53, v15, v17
		buffer_store_dwordx4 v[60:63], v53, s[8:11], 0 offen
		v_add_u32_e32 v53, 48, v8
		v_xor_b32_e32 v53, v53, v6
		v_bitop3_b32 v53, v16, v31, v53 bitop3:0x96
		v_mul_lo_u32 v53, s17, v53
		v_lshlrev_b32_e32 v53, 1, v53
		v_add_u32_e32 v54, s0, v53
		v_add3_u32 v54, v54, v13, v10
		v_add3_u32 v54, v54, v15, v17
		buffer_store_dwordx4 v[72:75], v54, s[8:11], 0 offen
		v_add_u32_e32 v54, 64, v8
		v_xor_b32_e32 v54, v54, v6
		v_bitop3_b32 v54, v16, v31, v54 bitop3:0x96
		v_mul_lo_u32 v54, s17, v54
		v_lshlrev_b32_e32 v54, 1, v54
		v_add_u32_e32 v55, s0, v54
		v_add3_u32 v55, v55, v13, v10
		v_add3_u32 v55, v55, v15, v17
		buffer_store_dwordx4 v[80:83], v55, s[8:11], 0 offen
		v_add_u32_e32 v55, 0x50, v8
		v_xor_b32_e32 v55, v55, v6
		v_bitop3_b32 v55, v16, v31, v55 bitop3:0x96
		v_mul_lo_u32 v55, s17, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v56, s0, v55
		v_add3_u32 v56, v56, v13, v10
		v_add3_u32 v56, v56, v15, v17
		buffer_store_dwordx4 v[84:87], v56, s[8:11], 0 offen
		v_add_u32_e32 v56, 0x60, v8
		v_xor_b32_e32 v56, v56, v6
		v_bitop3_b32 v56, v16, v31, v56 bitop3:0x96
		v_mul_lo_u32 v56, s17, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s0, v56
		v_add3_u32 v57, v57, v13, v10
		v_add3_u32 v57, v57, v15, v17
		buffer_store_dwordx4 v[92:95], v57, s[8:11], 0 offen
		v_add_u32_e32 v57, 0x70, v8
		v_xor_b32_e32 v57, v57, v6
		v_bitop3_b32 v57, v16, v31, v57 bitop3:0x96
		v_mul_lo_u32 v57, s17, v57
		v_lshlrev_b32_e32 v57, 1, v57
		v_add_u32_e32 v58, s0, v57
		v_add3_u32 v58, v58, v13, v10
		v_add3_u32 v58, v58, v15, v17
		buffer_store_dwordx4 v[96:99], v58, s[8:11], 0 offen
		v_add_u32_e32 v58, 0x80, v8
		v_xor_b32_e32 v58, v58, v6
		v_bitop3_b32 v58, v16, v31, v58 bitop3:0x96
		v_mul_lo_u32 v58, s17, v58
		v_lshlrev_b32_e32 v58, 1, v58
		v_add_u32_e32 v59, s0, v58
		v_add3_u32 v59, v59, v13, v10
		v_add3_u32 v59, v59, v15, v17
		buffer_store_dwordx4 v[104:107], v59, s[8:11], 0 offen
		v_add_u32_e32 v59, 0x90, v8
		v_xor_b32_e32 v59, v59, v6
		v_bitop3_b32 v59, v16, v31, v59 bitop3:0x96
		v_mul_lo_u32 v59, s17, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add_u32_e32 v60, s0, v59
		v_add3_u32 v60, v60, v13, v10
		v_add3_u32 v60, v60, v15, v17
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[112:115], v60, s[8:11], 0 offen
		v_add_u32_e32 v60, 0xa0, v8
		v_xor_b32_e32 v60, v60, v6
		v_bitop3_b32 v60, v16, v31, v60 bitop3:0x96
		v_mul_lo_u32 v60, s17, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_add_u32_e32 v61, s0, v60
		v_add3_u32 v61, v61, v13, v10
		v_add3_u32 v61, v61, v15, v17
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[116:119], v61, s[8:11], 0 offen
		v_add_u32_e32 v61, 0xb0, v8
		v_xor_b32_e32 v61, v61, v6
		v_bitop3_b32 v61, v16, v31, v61 bitop3:0x96
		v_mul_lo_u32 v61, s17, v61
		v_lshlrev_b32_e32 v61, 1, v61
		v_add_u32_e32 v62, s0, v61
		v_add3_u32 v62, v62, v13, v10
		v_add3_u32 v62, v62, v15, v17
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[124:127], v62, s[8:11], 0 offen
		v_add_u32_e32 v62, 0xc0, v8
		v_xor_b32_e32 v62, v62, v6
		v_bitop3_b32 v62, v16, v31, v62 bitop3:0x96
		v_mul_lo_u32 v62, s17, v62
		v_lshlrev_b32_e32 v62, 1, v62
		v_add_u32_e32 v63, s0, v62
		v_add3_u32 v63, v63, v13, v10
		v_add3_u32 v63, v63, v15, v17
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[132:135], v63, s[8:11], 0 offen
		v_add_u32_e32 v63, 0xd0, v8
		v_xor_b32_e32 v63, v63, v6
		v_bitop3_b32 v63, v16, v31, v63 bitop3:0x96
		v_mul_lo_u32 v63, s17, v63
		v_lshlrev_b32_e32 v63, 1, v63
		v_add_u32_e32 v72, s0, v63
		v_add3_u32 v72, v72, v13, v10
		v_add3_u32 v72, v72, v15, v17
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[136:139], v72, s[8:11], 0 offen
		v_add_u32_e32 v72, 0xe0, v8
		v_xor_b32_e32 v72, v72, v6
		v_bitop3_b32 v72, v16, v31, v72 bitop3:0x96
		v_mul_lo_u32 v72, s17, v72
		v_lshlrev_b32_e32 v72, 1, v72
		v_add_u32_e32 v73, s0, v72
		v_add3_u32 v73, v73, v13, v10
		v_add3_u32 v73, v73, v15, v17
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[140:143], v73, s[8:11], 0 offen
		v_add_u32_e32 v8, 0xf0, v8
		v_xor_b32_e32 v6, v8, v6
		v_bitop3_b32 v6, v16, v31, v6 bitop3:0x96
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v8, s0, v6
		v_add3_u32 v8, v8, v13, v10
		v_add3_u32 v8, v8, v15, v17
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[144:147], v8, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[48:51], a[72:75], v[200:203], v46, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x10000, v48
		v_add_u32_e32 v2, 0x10000, v2
		v_add_u32_e32 v4, 0x10000, v4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[56:59], a[72:75], v[204:207], v46, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x10000, v0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[56:59], a[80:83], v[220:223], v46, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[48:51], a[80:83], v[216:219], v46, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[52:55], a[76:79], v[200:203], v46, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], a[76:79], v[204:207], v46, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], a[84:87], v[220:223], v46, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[52:55], a[84:87], v[216:219], v46, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], a[72:75], v[208:211], v47, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[72:75], v[212:215], v47, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[80:83], v[228:231], v47, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[20:23], a[80:83], v[224:227], v47, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[76:79], v[208:211], v47, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v74, v200, v201
		v_cvt_pk_bf16_f32 v75, v202, v203
		v_cvt_pk_bf16_f32 v80, v204, v205
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], a[76:79], v[212:215], v47, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v81, v206, v207
		v_cvt_pk_bf16_f32 v82, v216, v217
		v_cvt_pk_bf16_f32 v83, v218, v219
		ds_write2st64_b64 v8, v[74:75], v[82:83] offset1:16
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], a[84:87], v[228:231], v47, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v74, v208, v209
		v_cvt_pk_bf16_f32 v75, v210, v211
		v_cvt_pk_bf16_f32 v82, v220, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], a[84:87], v[224:227], v47, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v84, v212, v213
		v_cvt_pk_bf16_f32 v85, v214, v215
		v_cvt_pk_bf16_f32 v83, v222, v223
		ds_write2st64_b64 v2, v[80:81], v[82:83] offset0:4 offset1:20
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[20:23], a[0:3], v[240:243], v47, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v80, v228, v229
		v_cvt_pk_bf16_f32 v81, v230, v231
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], a[0:3], v[244:247], v47, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v82, v224, v225
		v_cvt_pk_bf16_f32 v83, v226, v227
		ds_write2st64_b64 v4, v[74:75], v[82:83] offset0:8 offset1:24
		ds_write2st64_b64 v0, v[84:85], v[80:81] offset0:12 offset1:28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[32:35], a[8:11], a[104:107], v47, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[20:23], a[8:11], v[248:251], v47, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], a[4:7], v[240:243], v47, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[36:39], a[4:7], v[244:247], v47, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[12:15], a[104:107], v47, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[24:27], a[12:15], v[248:251], v47, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[48:51], a[0:3], v[232:235], v46, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[56:59], a[0:3], v[236:239], v46, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[56:59], a[8:11], a[100:103], v46, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[48:51], a[8:11], a[96:99], v46, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[52:55], a[4:7], v[232:235], v46, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v74, v240, v241
		v_cvt_pk_bf16_f32 v75, v242, v243
		v_cvt_pk_bf16_f32 v80, v244, v245
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], a[4:7], v[236:239], v46, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v81, v246, v247
		v_cvt_pk_bf16_f32 v82, v248, v249
		v_cvt_pk_bf16_f32 v83, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[64:67], a[12:15], a[100:103], v46, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v84, v232, v233
		v_cvt_pk_bf16_f32 v85, v234, v235
		v_accvgpr_read_b32 v16, a104
		v_accvgpr_read_b32 v18, a105
		v_cvt_pk_bf16_f32 v86, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[52:55], a[12:15], a[96:99], v46, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v18, v236, v237
		v_cvt_pk_bf16_f32 v19, v238, v239
		v_accvgpr_read_b32 v16, a106
		v_accvgpr_read_b32 v31, a107
		v_cvt_pk_bf16_f32 v87, v16, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[48:51], a[16:19], a[108:111], v46, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a100
		v_accvgpr_read_b32 v31, a101
		v_cvt_pk_bf16_f32 v92, v16, v31
		v_accvgpr_read_b32 v16, a102
		v_accvgpr_read_b32 v31, a103
		v_cvt_pk_bf16_f32 v93, v16, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[56:59], a[16:19], a[112:115], v46, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[56:59], a[24:27], a[128:131], v46, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a96
		v_accvgpr_read_b32 v31, a97
		v_cvt_pk_bf16_f32 v94, v16, v31
		v_accvgpr_read_b32 v16, a98
		v_accvgpr_read_b32 v31, a99
		v_cvt_pk_bf16_f32 v95, v16, v31
		ds_write2st64_b64 v8, v[84:85], v[94:95] offset0:32 offset1:48
		ds_write2st64_b64 v2, v[18:19], v[92:93] offset0:36 offset1:52
		ds_write2st64_b64 v4, v[74:75], v[82:83] offset0:40 offset1:56
		ds_write2st64_b64 v0, v[80:81], v[86:87] offset0:44 offset1:60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[48:51], a[24:27], a[124:127], v46, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[52:55], a[20:23], a[108:111], v46, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[64:67], a[20:23], a[112:115], v46, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[64:67], a[28:31], a[128:131], v46, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[52:55], a[28:31], a[124:127], v46, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[16:19], a[116:119], v47, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], a[16:19], a[120:123], v47, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], a[24:27], a[136:139], v47, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[24:27], a[132:135], v47, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], a[20:23], a[116:119], v47, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a108
		v_accvgpr_read_b32 v18, a109
		v_cvt_pk_bf16_f32 v74, v16, v18
		v_accvgpr_read_b32 v16, a110
		v_accvgpr_read_b32 v18, a111
		v_cvt_pk_bf16_f32 v75, v16, v18
		v_accvgpr_read_b32 v16, a112
		v_accvgpr_read_b32 v18, a113
		v_cvt_pk_bf16_f32 v80, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], a[20:23], a[120:123], v47, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a114
		v_accvgpr_read_b32 v18, a115
		v_cvt_pk_bf16_f32 v81, v16, v18
		v_accvgpr_read_b32 v16, a124
		v_accvgpr_read_b32 v18, a125
		v_cvt_pk_bf16_f32 v82, v16, v18
		v_accvgpr_read_b32 v16, a126
		v_accvgpr_read_b32 v18, a127
		v_cvt_pk_bf16_f32 v83, v16, v18
		ds_write2st64_b64 v8, v[74:75], v[82:83] offset0:64 offset1:80
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[36:39], a[28:31], a[136:139], v47, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a116
		v_accvgpr_read_b32 v18, a117
		v_cvt_pk_bf16_f32 v74, v16, v18
		v_accvgpr_read_b32 v16, a118
		v_accvgpr_read_b32 v18, a119
		v_cvt_pk_bf16_f32 v75, v16, v18
		v_accvgpr_read_b32 v16, a128
		v_accvgpr_read_b32 v18, a129
		v_cvt_pk_bf16_f32 v82, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], a[28:31], a[132:135], v47, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a120
		v_accvgpr_read_b32 v18, a121
		v_cvt_pk_bf16_f32 v84, v16, v18
		v_accvgpr_read_b32 v16, a122
		v_accvgpr_read_b32 v18, a123
		v_cvt_pk_bf16_f32 v85, v16, v18
		v_accvgpr_read_b32 v16, a130
		v_accvgpr_read_b32 v18, a131
		v_cvt_pk_bf16_f32 v83, v16, v18
		ds_write2st64_b64 v2, v[80:81], v[82:83] offset0:68 offset1:84
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[32:35], a[148:151], v47, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a136
		v_accvgpr_read_b32 v18, a137
		v_cvt_pk_bf16_f32 v80, v16, v18
		v_accvgpr_read_b32 v16, a138
		v_accvgpr_read_b32 v18, a139
		v_cvt_pk_bf16_f32 v81, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], a[32:35], a[152:155], v47, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a132
		v_accvgpr_read_b32 v18, a133
		v_cvt_pk_bf16_f32 v82, v16, v18
		v_accvgpr_read_b32 v16, a134
		v_accvgpr_read_b32 v18, a135
		v_cvt_pk_bf16_f32 v83, v16, v18
		ds_write2st64_b64 v4, v[74:75], v[82:83] offset0:72 offset1:88
		ds_write2st64_b64 v0, v[84:85], v[80:81] offset0:76 offset1:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], a[40:43], a[168:171], v47, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[20:23], a[40:43], a[164:167], v47, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], a[36:39], a[148:151], v47, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], a[36:39], a[152:155], v47, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], a[44:47], a[168:171], v47, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], a[44:47], a[164:167], v47, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[48:51], a[32:35], a[140:143], v46, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[32:35], a[144:147], v46, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[56:59], a[40:43], a[160:163], v46, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[40:43], a[156:159], v46, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[36:39], a[140:143], v46, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a148
		v_accvgpr_read_b32 v18, a149
		v_cvt_pk_bf16_f32 v20, v16, v18
		v_accvgpr_read_b32 v16, a150
		v_accvgpr_read_b32 v18, a151
		v_cvt_pk_bf16_f32 v21, v16, v18
		v_accvgpr_read_b32 v16, a152
		v_accvgpr_read_b32 v18, a153
		v_cvt_pk_bf16_f32 v22, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[64:67], a[36:39], a[144:147], v46, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a154
		v_accvgpr_read_b32 v18, a155
		v_cvt_pk_bf16_f32 v23, v16, v18
		v_accvgpr_read_b32 v16, a164
		v_accvgpr_read_b32 v18, a165
		v_cvt_pk_bf16_f32 v24, v16, v18
		v_accvgpr_read_b32 v16, a166
		v_accvgpr_read_b32 v18, a167
		v_cvt_pk_bf16_f32 v25, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[64:67], a[44:47], a[160:163], v46, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a140
		v_accvgpr_read_b32 v18, a141
		v_cvt_pk_bf16_f32 v26, v16, v18
		v_accvgpr_read_b32 v16, a142
		v_accvgpr_read_b32 v18, a143
		v_cvt_pk_bf16_f32 v27, v16, v18
		v_accvgpr_read_b32 v16, a168
		v_accvgpr_read_b32 v18, a169
		v_cvt_pk_bf16_f32 v32, v16, v18
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[52:55], a[44:47], a[156:159], v46, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v16, a144
		v_accvgpr_read_b32 v18, a145
		v_cvt_pk_bf16_f32 v28, v16, v18
		v_accvgpr_read_b32 v16, a146
		v_accvgpr_read_b32 v18, a147
		v_cvt_pk_bf16_f32 v29, v16, v18
		v_accvgpr_read_b32 v16, a170
		v_accvgpr_read_b32 v18, a171
		v_cvt_pk_bf16_f32 v33, v16, v18
		v_add_u32_e32 v7, 0x10000, v7
		v_accvgpr_read_b32 v16, a160
		v_accvgpr_read_b32 v18, a161
		v_cvt_pk_bf16_f32 v34, v16, v18
		v_accvgpr_read_b32 v16, a162
		v_accvgpr_read_b32 v18, a163
		v_cvt_pk_bf16_f32 v35, v16, v18
		v_lshl_add_u32 v7, v9, 11, v7
		v_lshl_add_u32 v9, v44, 3, v7
		v_accvgpr_read_b32 v16, a156
		v_accvgpr_read_b32 v18, a157
		v_cvt_pk_bf16_f32 v36, v16, v18
		v_accvgpr_read_b32 v16, a158
		v_accvgpr_read_b32 v18, a159
		v_cvt_pk_bf16_f32 v37, v16, v18
		ds_write2st64_b64 v8, v[26:27], v[36:37] offset0:96 offset1:112
		ds_write2st64_b64 v2, v[28:29], v[34:35] offset0:100 offset1:116
		ds_write2st64_b64 v4, v[20:21], v[24:25] offset0:104 offset1:120
		ds_write2st64_b64 v0, v[22:23], v[32:33] offset0:108 offset1:124
		v_lshl_add_u32 v0, v41, 3, v7
		v_lshl_add_u32 v2, v45, 3, v7
		v_lshl_add_u32 v4, v12, 3, v7
		v_add_u32_e32 v7, 0x10000, v30
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64 v[20:21], v9
		ds_read_b64 v[22:23], v0
		ds_read_b64 v[24:25], v2
		ds_read_b64 v[26:27], v4
		v_lshl_add_u32 v0, v50, 3, v7
		ds_read_b64 v[28:29], v0
		v_lshl_add_u32 v0, v51, 3, v7
		ds_read_b64 v[30:31], v0
		v_lshl_add_u32 v0, v68, 3, v7
		ds_read_b64 v[32:33], v0
		v_lshl_add_u32 v0, v49, 3, v7
		ds_read_b64 v[34:35], v0
		v_add_u32_e32 v0, 0x10000, v69
		v_lshl_add_u32 v2, v71, 3, v0
		ds_read_b64 v[36:37], v2
		v_lshl_add_u32 v2, v76, 3, v0
		ds_read_b64 v[38:39], v2
		v_lshl_add_u32 v2, v77, 3, v0
		ds_read_b64 v[44:45], v2
		v_lshl_add_u32 v0, v70, 3, v0
		ds_read_b64 v[46:47], v0
		v_add_u32_e32 v0, 0x10000, v78
		v_lshl_add_u32 v2, v88, 3, v0
		ds_read_b64 v[48:49], v2
		v_lshl_add_u32 v2, v89, 3, v0
		ds_read_b64 v[50:51], v2
		v_lshl_add_u32 v2, v90, 3, v0
		ds_read_b64 v[64:65], v2
		v_lshl_add_u32 v0, v79, 3, v0
		ds_read_b64 v[66:67], v0
		v_add_u32_e32 v0, 0x10000, v91
		v_lshl_add_u32 v2, v101, 3, v0
		ds_read_b64 v[68:69], v2
		v_lshl_add_u32 v2, v102, 3, v0
		ds_read_b64 v[70:71], v2
		v_lshl_add_u32 v2, v103, 3, v0
		ds_read_b64 v[76:77], v2
		v_lshl_add_u32 v0, v100, 3, v0
		ds_read_b64 v[78:79], v0
		v_add_u32_e32 v0, 0x10000, v108
		v_lshl_add_u32 v2, v110, 3, v0
		ds_read_b64 v[80:81], v2
		v_lshl_add_u32 v2, v111, 3, v0
		ds_read_b64 v[82:83], v2
		v_lshl_add_u32 v2, v120, 3, v0
		ds_read_b64 v[84:85], v2
		v_lshl_add_u32 v0, v109, 3, v0
		ds_read_b64 v[86:87], v0
		v_add_u32_e32 v0, 0x10000, v121
		v_lshl_add_u32 v2, v123, 3, v0
		ds_read_b64 v[88:89], v2
		v_lshl_add_u32 v2, v128, 3, v0
		ds_read_b64 v[90:91], v2
		v_lshl_add_u32 v2, v129, 3, v0
		ds_read_b64 v[92:93], v2
		v_lshl_add_u32 v0, v122, 3, v0
		ds_read_b64 v[94:95], v0
		v_add_u32_e32 v0, 0x10000, v5
		v_lshl_add_u32 v2, v43, 3, v0
		ds_read_b64 v[96:97], v2
		v_lshl_add_u32 v2, v40, 3, v0
		ds_read_b64 v[98:99], v2
		v_lshl_add_u32 v2, v42, 3, v0
		ds_read_b64 v[40:41], v2
		v_lshl_add_u32 v0, v11, 3, v0
		ds_read_b64 v[42:43], v0
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v1, v3
		v_add3_u32 v0, v0, v130, v131
		v_add3_u32 v0, v0, v13, v10
		v_add3_u32 v0, v0, v15, v17
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v14, v0, s0
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v1, v52, v0, s0
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		v_add3_u32 v0, v53, v0, s0
		buffer_store_dwordx4 v[32:35], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v54, v0, s0
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v55, v0, s0
		buffer_store_dwordx4 v[44:47], v1, s[8:11], 0 offen
		v_add3_u32 v0, v56, v0, s0
		buffer_store_dwordx4 v[48:51], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v57, v0, s0
		buffer_store_dwordx4 v[64:67], v1, s[8:11], 0 offen
		v_add3_u32 v1, v58, v0, s0
		buffer_store_dwordx4 v[68:71], v1, s[8:11], 0 offen
		v_add3_u32 v0, v59, v0, s0
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[76:79], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v60, v0, s0
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[80:83], v1, s[8:11], 0 offen
		v_add3_u32 v1, v61, v0, s0
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[84:87], v1, s[8:11], 0 offen
		v_add3_u32 v0, v62, v0, s0
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[88:91], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v63, v0, s0
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[92:95], v1, s[8:11], 0 offen
		v_add3_u32 v1, v72, v0, s0
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[96:99], v1, s[8:11], 0 offen
		v_add3_u32 v0, v6, v0, s0
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[8:11], 0 offen
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
		.amdhsa_next_free_sgpr 52
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
	.set .L_a4w4_kernel.numbered_sgpr, 52
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
    .sgpr_count:     52
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     428
    .agpr_count:     172
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 102
    wave.regalloc.agpr.dwords: 404
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
