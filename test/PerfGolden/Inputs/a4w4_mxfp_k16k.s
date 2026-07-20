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
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s21, s21, s15
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v19, v2, v4, v7
		v_add3_u32 v19, v19, v9, v11
		v_add3_u32 v19, v19, v13, v15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v20, v17, v19, s28
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v21, v17, v19, s29
		s_lshl_b32 s30, s14, 7
		v_add3_u32 v19, v17, v19, s30
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v22, v2, v4, v7
		v_add3_u32 v22, v22, v9, v11
		v_add3_u32 v22, v22, v13, v15
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_add3_u32 v23, v17, v22, s31
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s32, 0x88, s14
		v_add3_u32 v24, v17, v22, s32
		s_mul_i32 s14, 0x8c, s14
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		v_add3_u32 v22, v17, v22, s14
		s_add_i32 m0, m0, 0x1080
		v_mul_lo_u32 v25, s15, v1
		v_lshlrev_b32_e32 v25, 1, v25
		v_mul_lo_u32 v26, s15, v3
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add_u32_e32 v27, v25, v26
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s36, s4, s21
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v28, s15, v6
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v28, 6, v28
		v_mul_lo_u32 v29, s15, v8
		v_lshlrev_b32_e32 v29, 5, v29
		v_add3_u32 v27, v27, v28, v29
		v_mul_lo_u32 v30, s15, v10
		v_lshlrev_b32_e32 v30, 4, v30
		v_add3_u32 v27, v27, v30, v13
		s_add_i32 m0, m0, 0x9460
		v_add3_u32 v27, v27, v15, v17
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v31, v25, v26, v28
		v_add3_u32 v31, v31, v29, v30
		v_add3_u32 v31, v31, v13, v15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v32, v17, v31, s33
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v33, v17, v31, s34
		s_mul_i32 s35, 12, s15
		v_add3_u32 v31, v17, v31, s35
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v34, s18, v1
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
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
		s_add_i32 m0, m0, 0x5260
		v_add3_u32 v53, v53, v15, v17
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v54, v25, v26, v28
		v_add3_u32 v54, v54, v29, v30
		v_add3_u32 v54, v54, v13, v15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v55, v17, v54, s49
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v56, v17, v54, s50
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v54, v17, v54, s15
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		v_add_u32_e32 v57, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s51, s20, 0x80
		v_add3_u32 v58, s51, v43, v46
		v_add3_u32 v58, v58, v48, v12
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		v_add3_u32 v58, v58, v49, v50
		v_add3_u32 v58, v58, v14, v51
		buffer_load_dword v59, v58, s[44:47], 0 offen
		v_add_u32_e32 v57, v57, v4
		v_add3_u32 v57, v57, v7, v9
		v_add3_u32 v57, v57, v11, v13
		s_add_i32 m0, m0, 0xfffec6c0
		v_add3_u32 v57, v57, v15, v17
		buffer_load_dwordx4 v57, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v60, s22, v2, v4
		v_add3_u32 v60, v60, v7, v9
		v_add3_u32 v60, v60, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v60, v60, v15, v17
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v61, s22, v2, v4
		v_add3_u32 v61, v61, v7, v9
		v_add3_u32 v61, v61, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v61, v61, v15, v17
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v62, s22, v2, v4
		v_add3_u32 v62, v62, v7, v9
		v_add3_u32 v62, v62, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v62, v62, v15, v17
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v63, s22, v2, v4
		v_add3_u32 v63, v63, v7, v9
		v_add3_u32 v63, v63, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v63, v63, v15, v17
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v64, s22, v2, v4
		v_add3_u32 v64, v64, v7, v9
		v_add3_u32 v64, v64, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v64, v64, v15, v17
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v65, s22, v2, v4
		v_add3_u32 v65, v65, v7, v9
		v_add3_u32 v65, v65, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v65, v65, v15, v17
		buffer_load_dwordx4 v65, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v4
		v_add3_u32 v2, v2, v7, v9
		v_add3_u32 v2, v2, v11, v13
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v2, v2, v15, v17
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v25
		v_add_u32_e32 v4, v4, v26
		v_add3_u32 v4, v4, v28, v29
		v_add3_u32 v4, v4, v30, v13
		s_add_i32 m0, m0, 0x5260
		v_add3_u32 v4, v4, v15, v17
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v7, v25, v26, v28
		v_add3_u32 v7, v7, v29, v30
		v_add3_u32 v7, v7, v13, v15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v9, v17, v7, s14
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v11, v17, v7, s14
		s_add_i32 s14, s35, 0x80
		v_add3_u32 v7, v17, v7, s14
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_add3_u32 v66, v25, v26, v28
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		v_add3_u32 v34, s1, v34, v35
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_add3_u32 v34, v34, v37, v38
		v_add3_u32 v34, v34, v39, v40
		v_add3_u32 v34, v34, v41, v42
		buffer_load_dwordx2 v[68:69], v34, s[40:43], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s20, s1
		v_add3_u32 v35, s14, v43, v46
		v_add3_u32 v35, v35, v48, v12
		v_add3_u32 v35, v35, v49, v50
		v_add3_u32 v35, v35, v14, v51
		buffer_load_dword v37, v35, s[44:47], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v25, s14, v25, v26
		v_add3_u32 v25, v25, v28, v29
		v_add3_u32 v25, v25, v30, v13
		s_add_i32 m0, m0, 0x5260
		v_add3_u32 v25, v25, v15, v17
		buffer_load_dwordx4 v25, s[36:39], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v26, v66, v29, v30
		v_add3_u32 v26, v26, v13, v15
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v28, v17, v26, s14
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v29, v17, v26, s14
		s_add_i32 s14, s15, 0x80
		v_add3_u32 v26, v17, v26, s14
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_mul_i32 s14, s18, 16
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s51, s1
		v_add3_u32 v30, s1, v43, v46
		v_add3_u32 v12, v30, v48, v12
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		v_add3_u32 v12, v12, v49, v50
		v_add3_u32 v12, v12, v14, v51
		buffer_load_dword v14, v12, s[44:47], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s21, 0x100
		s_mul_i32 s15, s19, 16
		v_lshlrev_b32_e32 v30, 7, v1
		v_and_b32_e32 v42, 63, v0
		v_lshrrev_b32_e32 v43, 4, v42
		v_accvgpr_write_b32 a0, v43
		v_accvgpr_read_b32 v43, a0
		v_lshlrev_b32_e32 v43, 4, v43
		v_and_b32_e32 v46, 15, v42
		v_mov_b32_e32 v48, 0x420
		v_mul_lo_u32 v48, v48, v46
		v_add3_u32 v30, v30, v43, v48
		ds_read_b128 a[4:7], v30
		ds_read_b128 a[8:11], v30 offset:64
		ds_read_b128 a[12:15], v30 offset:256
		ds_read_b128 a[16:19], v30 offset:320
		ds_read_b128 a[20:23], v30 offset:512
		ds_read_b128 a[24:27], v30 offset:576
		ds_read_b128 a[28:31], v30 offset:768
		ds_read_b128 a[32:35], v30 offset:832
		ds_read_b128 a[36:39], v30 offset:16896
		ds_read_b128 a[40:43], v30 offset:16960
		ds_read_b128 a[44:47], v30 offset:17152
		ds_read_b128 a[48:51], v30 offset:17216
		ds_read_b128 a[52:55], v30 offset:17408
		ds_read_b128 a[56:59], v30 offset:17472
		ds_read_b128 a[60:63], v30 offset:17664
		ds_read_b128 a[64:67], v30 offset:17728
		v_add_u32_e32 v43, 0x10000, v43
		v_lshlrev_b32_e32 v46, 7, v3
		v_add3_u32 v43, v43, v46, v48
		ds_read_b128 a[68:71], v43 offset:2016
		ds_read_b128 a[72:75], v43 offset:2080
		ds_read_b128 a[76:79], v43 offset:2272
		ds_read_b128 a[80:83], v43 offset:2336
		ds_read_b128 a[84:87], v43 offset:2528
		ds_read_b128 a[88:91], v43 offset:2592
		ds_read_b128 a[92:95], v43 offset:2784
		ds_read_b128 a[96:99], v43 offset:2848
		v_lshlrev_b32_e32 v46, 3, v0
		v_add_u32_e32 v46, 0x20000, v46
		s_waitcnt vmcnt(25)
		ds_write_b64 v46, v[44:45] offset:4000
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
		ds_read_b64_tr_b8 v[48:49], v45 offset:4000
		ds_read_b64_tr_b8 v[50:51], v45 offset:4128
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
		v_accvgpr_write_b32 a100, v40
		v_accvgpr_write_b32 a101, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a102, v40
		v_accvgpr_write_b32 a103, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a104, v40
		v_accvgpr_write_b32 a105, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a106, v40
		v_accvgpr_write_b32 a107, v41
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
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
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a172, v40
		v_accvgpr_write_b32 a173, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a174, v40
		v_accvgpr_write_b32 a175, v41
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v38, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v38, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_u32 s40, s10, s19
		s_addc_u32 s41, s11, 0
		s_add_u32 s36, s8, s18
		s_addc_u32 s37, s9, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v38, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s1, s1, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s18, s18, s14
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v38, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s19, s19, s15
		s_add_i32 s23, s23, 2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v38, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v38, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v38, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v38, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v39, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v39, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v39, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v39, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[8:11], v[80:83], v39, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], a[8:11], v[84:87], v39, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], a[16:19], v[100:103], v39, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[16:19], v[96:99], v39, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v39, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v39, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v39, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v39, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[24:27], v[112:115], v39, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], a[24:27], v[116:119], v39, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[32:35], v[132:135], v39, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[32:35], v[128:131], v39, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v38, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v38, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v38, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v38, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v38, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v38, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v38, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v38, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v38, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v38, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v38, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v38, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v39, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v39, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v39, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v39, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[40:43], v[144:147], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[40:43], v[148:151], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[48:51], v[164:167], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[48:51], v[160:163], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v39, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v39, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v39, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v39, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[56:59], v[176:179], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[56:59], v[180:183], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[64:67], v[196:199], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[64:67], v[192:195], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v38, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v38, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v38, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v38, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[68:71], v43 offset:35776
		ds_read_b128 a[72:75], v43 offset:35840
		ds_read_b128 a[76:79], v43 offset:36032
		ds_read_b128 a[80:83], v43 offset:36096
		ds_read_b128 a[84:87], v43 offset:36288
		ds_read_b128 a[88:91], v43 offset:36352
		ds_read_b128 a[92:95], v43 offset:36544
		ds_read_b128 v[252:255], v43 offset:36608
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v59 offset:6048
		s_mov_b32 m0, s16
		buffer_load_dwordx2 v[38:39], v36, s[36:39], 0 offen
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		buffer_load_dword v40, v47, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v16 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_waitcnt vmcnt(10)
		ds_write_b64 v46, v[68:69] offset:4000
		s_add_i32 m0, m0, 0x1080
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v66, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v66, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v66, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v66, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[8:11], v[200:203], v66, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[8:11], v[204:207], v66, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[16:19], v[220:223], v66, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[16:19], v[216:219], v66, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v67, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v67, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v67, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v67, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[8:11], v[208:211], v67, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[8:11], v[212:215], v67, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[16:19], v[228:231], v67, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[16:19], v[224:227], v67, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v67, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[20:23], v[244:247], v67, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v67, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v67, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v67, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[24:27], v[244:247], v67, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v67, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[32:35], v[248:251], v67, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v66, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v66, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v66, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x9460
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v66, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[24:27], v[232:235], v66, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[24:27], v[236:239], v66, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v66, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v66, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v66, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v66, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v66, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v66, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v66, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v66, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v66, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v66, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v67, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v67, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v67, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v67, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v67, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v67, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v67, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v67, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v67, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v67, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v67, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v67, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v67, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v67, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v67, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v67, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v66, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v66, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v66, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v66, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v66, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v66, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v66, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v66, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 a[4:7], v30 offset:33792
		ds_read_b128 a[8:11], v30 offset:33856
		ds_read_b128 a[12:15], v30 offset:34048
		ds_read_b128 a[16:19], v30 offset:34112
		ds_read_b128 a[20:23], v30 offset:34304
		ds_read_b128 a[24:27], v30 offset:34368
		ds_read_b128 a[28:31], v30 offset:34560
		ds_read_b128 a[32:35], v30 offset:34624
		ds_read_b128 a[36:39], v30 offset:50688
		ds_read_b128 a[40:43], v30 offset:50752
		ds_read_b128 a[44:47], v30 offset:50944
		ds_read_b128 a[48:51], v30 offset:51008
		ds_read_b128 a[52:55], v30 offset:51200
		ds_read_b128 a[56:59], v30 offset:51264
		ds_read_b128 a[60:63], v30 offset:51456
		ds_read_b128 a[64:67], v30 offset:51520
		ds_read_b128 a[68:71], v43 offset:18912
		ds_read_b128 a[72:75], v43 offset:18976
		ds_read_b128 a[76:79], v43 offset:19168
		ds_read_b128 a[80:83], v43 offset:19232
		ds_read_b128 v[48:51], v43 offset:19424
		ds_read_b128 a[84:87], v43 offset:19488
		ds_read_b128 v[68:71], v43 offset:19680
		ds_read_b128 a[88:91], v43 offset:19744
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v37 offset:6048
		s_waitcnt lgkmcnt(14)
		s_barrier
		ds_read_b64_tr_b8 v[66:67], v45 offset:4000
		ds_read_b64_tr_b8 v[252:253], v45 offset:4128
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[254:255], v16 offset:6048
		buffer_load_dwordx4 v53, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v55, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v254, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v254, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v254, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v254, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v254, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v254, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v254, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v254, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v54, s[32:35], 0 offen lds
		buffer_load_dword v59, v58, s[40:43], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[48:51], a[4:7], v[80:83], v255, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], a[4:7], v[84:87], v255, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], a[12:15], v[100:103], v255, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[48:51], a[12:15], v[96:99], v255, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[8:11], v[80:83], v255, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[8:11], v[84:87], v255, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[16:19], v[100:103], v255, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[16:19], v[96:99], v255, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[48:51], a[20:23], v[112:115], v255, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], a[20:23], v[116:119], v255, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], a[28:31], v[132:135], v255, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[48:51], a[28:31], v[128:131], v255, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[24:27], v[112:115], v255, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[24:27], v[116:119], v255, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[32:35], v[132:135], v255, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[32:35], v[128:131], v255, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v254, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v254, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v254, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v254, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v254, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v254, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v254, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v254, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v254, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v254, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v254, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v254, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[48:51], a[36:39], v[144:147], v255, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], a[36:39], v[148:151], v255, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[68:71], a[44:47], v[164:167], v255, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[48:51], a[44:47], v[160:163], v255, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[40:43], v[144:147], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[40:43], v[148:151], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[48:51], v[164:167], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[48:51], v[160:163], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], a[52:55], v[176:179], v255, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[68:71], a[52:55], v[180:183], v255, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], a[60:63], v[196:199], v255, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[48:51], a[60:63], v[192:195], v255, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[56:59], v[176:179], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[56:59], v[180:183], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[64:67], v[196:199], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[64:67], v[192:195], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v254, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v254, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v254, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v254, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[68:71], v43 offset:52672
		ds_read_b128 a[72:75], v43 offset:52736
		ds_read_b128 a[76:79], v43 offset:52928
		ds_read_b128 a[80:83], v43 offset:52992
		ds_read_b128 a[84:87], v43 offset:53184
		ds_read_b128 a[88:91], v43 offset:53248
		ds_read_b128 a[92:95], v43 offset:53440
		ds_read_b128 v[48:51], v43 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v14 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt vmcnt(18)
		ds_write_b64 v46, v[38:39] offset:4000
		buffer_load_dwordx4 v57, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v38, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v38, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v38, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v61, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v38, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[8:11], v[200:203], v38, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[8:11], v[204:207], v38, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[16:19], v[220:223], v38, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v62, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[16:19], v[216:219], v38, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v39, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v39, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v39, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v39, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[8:11], v[208:211], v39, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], a[8:11], v[212:215], v39, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], a[16:19], v[228:231], v39, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[16:19], v[224:227], v39, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v39, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[20:23], v[244:247], v39, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v39, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v39, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v39, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[24:27], v[244:247], v39, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[48:51], a[32:35], a[108:111], v39, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[32:35], v[248:251], v39, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v38, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v38, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v38, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x5260
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v38, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[24:27], v[232:235], v38, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[24:27], v[236:239], v38, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v38, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v38, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v38, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v38, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v38, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v38, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v38, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v38, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v38, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v38, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v39, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v39, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[68:69], v34, s[36:39], 0 offen
		buffer_load_dword v37, v35, s[40:43], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v39, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v39, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v39, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], a[40:43], a[124:127], v39, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], a[48:51], a[140:143], v39, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v39, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v39, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v39, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v39, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v39, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v39, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], a[56:59], a[156:159], v39, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], a[64:67], a[172:175], v39, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v39, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v38, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v38, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v38, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v38, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v38, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v38, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v38, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v38, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[4:7], v30
		ds_read_b128 a[8:11], v30 offset:64
		ds_read_b128 a[12:15], v30 offset:256
		ds_read_b128 a[16:19], v30 offset:320
		ds_read_b128 a[20:23], v30 offset:512
		ds_read_b128 a[24:27], v30 offset:576
		ds_read_b128 a[28:31], v30 offset:768
		ds_read_b128 a[32:35], v30 offset:832
		ds_read_b128 a[36:39], v30 offset:16896
		ds_read_b128 a[40:43], v30 offset:16960
		ds_read_b128 a[44:47], v30 offset:17152
		ds_read_b128 a[48:51], v30 offset:17216
		ds_read_b128 a[52:55], v30 offset:17408
		ds_read_b128 a[56:59], v30 offset:17472
		ds_read_b128 a[60:63], v30 offset:17664
		ds_read_b128 a[64:67], v30 offset:17728
		ds_read_b128 a[68:71], v43 offset:2016
		ds_read_b128 a[72:75], v43 offset:2080
		ds_read_b128 a[76:79], v43 offset:2272
		ds_read_b128 a[80:83], v43 offset:2336
		ds_read_b128 a[84:87], v43 offset:2528
		ds_read_b128 a[88:91], v43 offset:2592
		ds_read_b128 a[92:95], v43 offset:2784
		ds_read_b128 a[96:99], v43 offset:2848
		ds_write_b32 v44, v40 offset:6048
		s_barrier
		ds_read_b64_tr_b8 v[48:49], v45 offset:4000
		ds_read_b64_tr_b8 v[50:51], v45 offset:4128
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		buffer_load_dwordx4 v25, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_cmp_lt_i32 s23, 62
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		buffer_load_dword v14, v12, s[40:43], 0 offen
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v38, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v38, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v38, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v38, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v38, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v38, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v38, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v38, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v39, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v39, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v39, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v39, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[8:11], v[80:83], v39, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], a[8:11], v[84:87], v39, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], a[16:19], v[100:103], v39, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[16:19], v[96:99], v39, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v39, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v39, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v39, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v39, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[24:27], v[112:115], v39, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], a[24:27], v[116:119], v39, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[32:35], v[132:135], v39, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[32:35], v[128:131], v39, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v38, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v38, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v38, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v38, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v38, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v38, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v38, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v38, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v38, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v38, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v38, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v38, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v38, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v38, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v39, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v39, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v39, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v39, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[40:43], v[144:147], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[40:43], v[148:151], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[48:51], v[164:167], v39, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[48:51], v[160:163], v39, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v39, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v39, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v39, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v39, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[56:59], v[176:179], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[56:59], v[180:183], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[64:67], v[196:199], v39, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[64:67], v[192:195], v39, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v38, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v38, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v38, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v38, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v38, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v38, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[20:23], v43 offset:35776
		ds_read_b128 a[68:71], v43 offset:35840
		ds_read_b128 v[24:27], v43 offset:36032
		ds_read_b128 v[32:35], v43 offset:36096
		ds_read_b128 v[52:55], v43 offset:36288
		ds_read_b128 v[60:63], v43 offset:36352
		ds_read_b128 v[64:67], v43 offset:36544
		ds_read_b128 v[252:255], v43 offset:36608
		ds_write_b32 v44, v59 offset:6048
		v_lshlrev_b32_e32 v2, 3, v3
		v_lshlrev_b32_e32 v4, 2, v6
		v_bitop3_b32 v0, v2, v0, v4 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v16 offset:6048
		ds_read_b128 a[72:75], v30 offset:33792
		ds_read_b128 a[76:79], v30 offset:33856
		ds_read_b128 a[80:83], v30 offset:34048
		ds_read_b128 v[56:59], v30 offset:34112
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], a[4:7], v[200:203], v4, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], a[4:7], v[204:207], v4, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], a[12:15], v[220:223], v4, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[20:23], a[12:15], v[216:219], v4, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[8:11], v[200:203], v4, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], a[8:11], v[204:207], v4, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], a[16:19], v[220:223], v4, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[16:19], v[216:219], v4, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[52:55], a[4:7], v[208:211], v5, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], a[4:7], v[212:215], v5, v48 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[64:67], a[12:15], v[228:231], v5, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], a[12:15], v[224:227], v5, v48 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], a[8:11], v[208:211], v5, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[8:11], v[212:215], v5, v48 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[16:19], v[228:231], v5, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], a[16:19], v[224:227], v5, v48 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[52:55], a[20:23], v[240:243], v5, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[64:67], a[20:23], v[244:247], v5, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], a[28:31], a[108:111], v5, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[28:31], v[248:251], v5, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[60:63], a[24:27], v[240:243], v5, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[24:27], v[244:247], v5, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v5, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[60:63], a[32:35], v[248:251], v5, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[20:23], a[20:23], v[232:235], v4, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[24:27], a[20:23], v[236:239], v4, v49 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], a[28:31], a[104:107], v4, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], a[28:31], a[100:103], v4, v49 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[24:27], v[232:235], v4, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], a[24:27], v[236:239], v4, v49 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[32:35], a[32:35], a[104:107], v4, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[32:35], a[100:103], v4, v49 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], a[36:39], a[112:115], v4, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], a[36:39], a[116:119], v4, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], a[44:47], a[132:135], v4, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[20:23], a[44:47], a[128:131], v4, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[40:43], a[112:115], v4, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], a[40:43], a[116:119], v4, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], a[48:51], a[132:135], v4, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[48:51], a[128:131], v4, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[36:39], a[120:123], v5, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[64:67], a[36:39], a[124:127], v5, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[64:67], a[44:47], a[140:143], v5, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[44:47], a[136:139], v5, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], a[40:43], a[120:123], v5, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v5, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v5, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], a[48:51], a[136:139], v5, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[52:55], a[152:155], v5, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[64:67], a[52:55], a[156:159], v5, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[64:67], a[60:63], a[172:175], v5, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[60:63], a[168:171], v5, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], a[56:59], a[152:155], v5, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v5, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v5, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], a[64:67], a[168:171], v5, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[20:23], a[52:55], a[144:147], v4, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], a[52:55], a[148:151], v4, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], a[60:63], a[164:167], v4, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[20:23], a[60:63], a[160:163], v4, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[56:59], a[144:147], v4, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], a[56:59], a[148:151], v4, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], a[64:67], a[164:167], v4, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[64:67], a[160:163], v4, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v30 offset:34304
		ds_read_b128 a[4:7], v30 offset:34368
		ds_read_b128 a[8:11], v30 offset:34560
		ds_read_b128 a[12:15], v30 offset:34624
		ds_read_b128 a[16:19], v30 offset:50688
		ds_read_b128 a[20:23], v30 offset:50752
		ds_read_b128 a[24:27], v30 offset:50944
		ds_read_b128 a[28:31], v30 offset:51008
		ds_read_b128 a[32:35], v30 offset:51200
		ds_read_b128 a[36:39], v30 offset:51264
		ds_read_b128 a[40:43], v30 offset:51456
		ds_read_b128 a[44:47], v30 offset:51520
		ds_read_b128 v[24:27], v43 offset:18912
		ds_read_b128 v[28:31], v43 offset:18976
		ds_read_b128 v[32:35], v43 offset:19168
		ds_read_b128 v[48:51], v43 offset:19232
		ds_read_b128 v[52:55], v43 offset:19424
		ds_read_b128 v[60:63], v43 offset:19488
		ds_read_b128 v[64:67], v43 offset:19680
		ds_read_b128 v[252:255], v43 offset:19744
		ds_write_b64 v46, v[68:69] offset:4000
		s_barrier
		ds_write_b32 v44, v37 offset:6048
		v_xor_b32_e32 v4, 1, v0
		v_lshlrev_b32_e32 v4, 4, v4
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[18:19], v45 offset:4000
		ds_read_b64_tr_b8 v[36:37], v45 offset:4128
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		ds_read_b128 a[48:51], v43 offset:52672
		ds_read_b128 a[52:55], v43 offset:52736
		ds_read_b128 a[56:59], v43 offset:52928
		ds_read_b128 v[68:71], v43 offset:52992
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[24:27], a[72:75], v[72:75], v38, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], a[72:75], v[76:79], v38, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], a[80:83], v[92:95], v38, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], a[80:83], v[88:91], v38, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[28:31], a[76:79], v[72:75], v38, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[48:51], a[76:79], v[76:79], v38, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[48:51], v[56:59], v[92:95], v38, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[28:31], v[56:59], v[88:91], v38, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[52:55], a[72:75], v[80:83], v39, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], a[72:75], v[84:87], v39, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], a[80:83], v[100:103], v39, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[52:55], a[80:83], v[96:99], v39, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[60:63], a[76:79], v[80:83], v39, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], a[76:79], v[84:87], v39, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], v[56:59], v[100:103], v39, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[60:63], v[56:59], v[96:99], v39, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[52:55], v[20:23], v[112:115], v39, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[20:23], v[116:119], v39, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], a[8:11], v[132:135], v39, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[52:55], a[8:11], v[128:131], v39, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[60:63], a[4:7], v[112:115], v39, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], a[4:7], v[116:119], v39, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[12:15], v[132:135], v39, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[60:63], a[12:15], v[128:131], v39, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[20:23], v[104:107], v38, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], v[20:23], v[108:111], v38, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], a[8:11], v[124:127], v38, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], a[8:11], v[120:123], v38, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[28:31], a[4:7], v[104:107], v38, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[48:51], a[4:7], v[108:111], v38, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[48:51], a[12:15], v[124:127], v38, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[28:31], a[12:15], v[120:123], v38, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], a[16:19], v[136:139], v38, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], a[16:19], v[140:143], v38, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], a[24:27], v[156:159], v38, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], a[24:27], v[152:155], v38, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], a[20:23], v[136:139], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], a[20:23], v[140:143], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], a[28:31], v[156:159], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], a[28:31], v[152:155], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[52:55], a[16:19], v[144:147], v39, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[64:67], a[16:19], v[148:151], v39, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[64:67], a[24:27], v[164:167], v39, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], a[24:27], v[160:163], v39, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[60:63], a[20:23], v[144:147], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[20:23], v[148:151], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[28:31], v[164:167], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[60:63], a[28:31], v[160:163], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[52:55], a[32:35], v[176:179], v39, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], a[32:35], v[180:183], v39, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], a[40:43], v[196:199], v39, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], a[40:43], v[192:195], v39, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], a[36:39], v[176:179], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[36:39], v[180:183], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[44:47], v[196:199], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], a[44:47], v[192:195], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[32:35], v[168:171], v38, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], a[32:35], v[172:175], v38, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], a[40:43], v[188:191], v38, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[40:43], v[184:187], v38, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], a[36:39], v[168:171], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], a[36:39], v[172:175], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], a[44:47], v[188:191], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], a[44:47], v[184:187], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v43 offset:53184
		ds_read_b128 v[28:31], v43 offset:53248
		ds_read_b128 v[32:35], v43 offset:53440
		ds_read_b128 v[48:51], v43 offset:53504
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v44, v14 offset:6048
		v_cvt_pk_bf16_f32 v44, v72, v73
		v_cvt_pk_bf16_f32 v45, v74, v75
		v_cvt_pk_bf16_f32 v52, v76, v77
		v_cvt_pk_bf16_f32 v53, v78, v79
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v16 offset:6048
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v60, v80, v81
		v_cvt_pk_bf16_f32 v61, v82, v83
		v_cvt_pk_bf16_f32 v64, v84, v85
		v_cvt_pk_bf16_f32 v65, v86, v87
		v_cvt_pk_bf16_f32 v46, v88, v89
		v_cvt_pk_bf16_f32 v47, v90, v91
		v_cvt_pk_bf16_f32 v54, v92, v93
		v_cvt_pk_bf16_f32 v55, v94, v95
		v_cvt_pk_bf16_f32 v62, v96, v97
		v_cvt_pk_bf16_f32 v63, v98, v99
		v_cvt_pk_bf16_f32 v66, v100, v101
		v_cvt_pk_bf16_f32 v67, v102, v103
		v_cvt_pk_bf16_f32 v72, v104, v105
		v_cvt_pk_bf16_f32 v73, v106, v107
		v_cvt_pk_bf16_f32 v76, v108, v109
		v_cvt_pk_bf16_f32 v77, v110, v111
		v_cvt_pk_bf16_f32 v80, v112, v113
		v_cvt_pk_bf16_f32 v81, v114, v115
		v_cvt_pk_bf16_f32 v84, v116, v117
		v_cvt_pk_bf16_f32 v85, v118, v119
		v_cvt_pk_bf16_f32 v74, v120, v121
		v_cvt_pk_bf16_f32 v75, v122, v123
		v_cvt_pk_bf16_f32 v78, v124, v125
		v_cvt_pk_bf16_f32 v79, v126, v127
		v_cvt_pk_bf16_f32 v82, v128, v129
		v_cvt_pk_bf16_f32 v83, v130, v131
		v_cvt_pk_bf16_f32 v86, v132, v133
		v_cvt_pk_bf16_f32 v87, v134, v135
		v_cvt_pk_bf16_f32 v88, v136, v137
		v_cvt_pk_bf16_f32 v89, v138, v139
		v_cvt_pk_bf16_f32 v92, v140, v141
		v_cvt_pk_bf16_f32 v93, v142, v143
		v_cvt_pk_bf16_f32 v96, v144, v145
		v_cvt_pk_bf16_f32 v97, v146, v147
		v_cvt_pk_bf16_f32 v100, v148, v149
		v_cvt_pk_bf16_f32 v101, v150, v151
		v_cvt_pk_bf16_f32 v90, v152, v153
		v_cvt_pk_bf16_f32 v91, v154, v155
		v_cvt_pk_bf16_f32 v94, v156, v157
		v_cvt_pk_bf16_f32 v95, v158, v159
		v_cvt_pk_bf16_f32 v98, v160, v161
		v_cvt_pk_bf16_f32 v99, v162, v163
		v_cvt_pk_bf16_f32 v102, v164, v165
		v_cvt_pk_bf16_f32 v103, v166, v167
		v_cvt_pk_bf16_f32 v104, v168, v169
		v_cvt_pk_bf16_f32 v105, v170, v171
		v_cvt_pk_bf16_f32 v108, v172, v173
		v_cvt_pk_bf16_f32 v109, v174, v175
		v_cvt_pk_bf16_f32 v112, v176, v177
		v_cvt_pk_bf16_f32 v113, v178, v179
		v_cvt_pk_bf16_f32 v116, v180, v181
		v_cvt_pk_bf16_f32 v117, v182, v183
		v_cvt_pk_bf16_f32 v106, v184, v185
		v_cvt_pk_bf16_f32 v107, v186, v187
		v_cvt_pk_bf16_f32 v110, v188, v189
		v_cvt_pk_bf16_f32 v111, v190, v191
		v_cvt_pk_bf16_f32 v114, v192, v193
		v_cvt_pk_bf16_f32 v115, v194, v195
		v_cvt_pk_bf16_f32 v118, v196, v197
		v_cvt_pk_bf16_f32 v119, v198, v199
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[44:47]
		ds_write_b128 v4, v[52:55] offset:4096
		v_xor_b32_e32 v5, 2, v0
		v_lshlrev_b32_e32 v5, 4, v5
		ds_write_b128 v5, v[60:63] offset:8192
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[64:67] offset:12288
		v_lshrrev_b32_e32 v7, 3, v42
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v9, 2, v42
		v_and_b32_e32 v9, 1, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v11, 12, v9
		v_lshl_add_u32 v11, v7, 13, v11
		v_lshl_add_u32 v12, v7, 1, v9
		v_lshlrev_b32_e32 v14, 3, v1
		v_lshlrev_b32_e32 v16, 2, v3
		v_accvgpr_read_b32 v40, a0
		v_and_b32_e32 v40, 1, v40
		v_and_b32_e32 v41, 1, v42
		v_lshl_add_u32 v40, v41, 5, v40
		v_lshrrev_b32_e32 v41, 5, v42
		v_lshlrev_b32_e32 v41, 1, v41
		v_xor_b32_e32 v40, v40, v41
		v_bitop3_b32 v40, v14, v16, v40 bitop3:0x96
		v_lshrrev_b32_e32 v41, 6, v40
		v_lshrrev_b32_e32 v42, 1, v42
		v_and_b32_e32 v42, 1, v42
		v_add_u32_e32 v41, v41, v42
		v_and_b32_e32 v41, 1, v41
		v_lshlrev_b32_e32 v41, 3, v41
		v_lshl_add_u32 v42, v42, 6, v40
		v_lshrrev_b32_e32 v40, 5, v40
		v_and_b32_e32 v40, 1, v40
		v_lshlrev_b32_e32 v40, 2, v40
		v_bitop3_b32 v40, v41, v42, v40 bitop3:0x96
		v_xor_b32_e32 v12, v12, v40
		v_lshl_add_u32 v11, v12, 4, v11
		ds_read_b128 v[44:47], v11
		ds_read_b128 v[52:55], v11 offset:256
		ds_read_b128 v[60:63], v11 offset:2048
		ds_read_b128 v[64:67], v11 offset:2304
		v_lshlrev_b32_e32 v9, 2, v9
		v_add_u32_e32 v12, 32, v9
		v_lshlrev_b32_e32 v7, 3, v7
		v_xor_b32_e32 v12, v12, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[72:75]
		ds_write_b128 v4, v[76:79] offset:4096
		ds_write_b128 v5, v[80:83] offset:8192
		ds_write_b128 v0, v[84:87] offset:12288
		v_lshrrev_b32_e32 v41, 6, v12
		v_and_b32_e32 v41, 1, v41
		v_lshrrev_b32_e32 v42, 5, v12
		v_and_b32_e32 v42, 1, v42
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v42, 14, v42
		v_lshl_add_u32 v41, v41, 15, v42
		v_lshrrev_b32_e32 v42, 3, v12
		v_and_b32_e32 v42, 1, v42
		v_lshl_add_u32 v41, v42, 13, v41
		v_lshrrev_b32_e32 v12, 2, v12
		v_and_b32_e32 v12, 1, v12
		v_lshl_add_u32 v41, v12, 12, v41
		v_lshl_add_u32 v12, v42, 1, v12
		v_xor_b32_e32 v12, v12, v40
		v_lshl_add_u32 v12, v12, 4, v41
		v_add_u32_e32 v41, 0xffffc000, v12
		ds_read_b128 v[72:75], v41
		v_add_u32_e32 v41, 0xffffc100, v12
		ds_read_b128 v[76:79], v41
		v_add_u32_e32 v41, 0xffffc800, v12
		ds_read_b128 v[80:83], v41
		v_add_u32_e32 v41, 0xffffc900, v12
		ds_read_b128 v[84:87], v41
		v_add_u32_e32 v41, 64, v9
		v_xor_b32_e32 v41, v41, v7
		v_lshrrev_b32_e32 v42, 6, v41
		v_and_b32_e32 v42, 1, v42
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[88:91]
		ds_write_b128 v4, v[92:95] offset:4096
		ds_write_b128 v5, v[96:99] offset:8192
		ds_write_b128 v0, v[100:103] offset:12288
		v_lshrrev_b32_e32 v43, 5, v41
		v_and_b32_e32 v43, 1, v43
		v_lshlrev_b32_e32 v43, 14, v43
		v_lshl_add_u32 v42, v42, 15, v43
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v43, 3, v41
		v_and_b32_e32 v43, 1, v43
		v_lshl_add_u32 v42, v43, 13, v42
		v_lshrrev_b32_e32 v41, 2, v41
		v_and_b32_e32 v41, 1, v41
		v_lshl_add_u32 v42, v41, 12, v42
		v_lshl_add_u32 v41, v43, 1, v41
		v_xor_b32_e32 v41, v41, v40
		v_lshl_add_u32 v41, v41, 4, v42
		v_add_u32_e32 v42, 0xffff8000, v41
		ds_read_b128 v[88:91], v42
		v_add_u32_e32 v42, 0xffff8100, v41
		ds_read_b128 v[92:95], v42
		v_add_u32_e32 v42, 0xffff8800, v41
		ds_read_b128 v[96:99], v42
		v_add_u32_e32 v42, 0xffff8900, v41
		ds_read_b128 v[100:103], v42
		v_add_u32_e32 v9, 0x60, v9
		v_xor_b32_e32 v7, v9, v7
		v_lshrrev_b32_e32 v9, 6, v7
		v_and_b32_e32 v9, 1, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[104:107]
		ds_write_b128 v4, v[108:111] offset:4096
		ds_write_b128 v5, v[112:115] offset:8192
		ds_write_b128 v0, v[116:119] offset:12288
		v_lshrrev_b32_e32 v42, 5, v7
		v_and_b32_e32 v42, 1, v42
		v_lshlrev_b32_e32 v42, 14, v42
		v_lshl_add_u32 v9, v9, 15, v42
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v42, 3, v7
		v_and_b32_e32 v42, 1, v42
		v_lshl_add_u32 v9, v42, 13, v9
		v_lshrrev_b32_e32 v7, 2, v7
		v_and_b32_e32 v7, 1, v7
		v_lshl_add_u32 v9, v7, 12, v9
		v_lshl_add_u32 v7, v42, 1, v7
		v_xor_b32_e32 v7, v7, v40
		v_lshl_add_u32 v7, v7, 4, v9
		v_add_u32_e32 v9, 0xffff4000, v7
		ds_read_b128 v[104:107], v9
		v_add_u32_e32 v9, 0xffff4100, v7
		ds_read_b128 v[108:111], v9
		v_add_u32_e32 v9, 0xffff4800, v7
		ds_read_b128 v[112:115], v9
		v_add_u32_e32 v9, 0xffff4900, v7
		ds_read_b128 v[116:119], v9
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v9, s0, v1, v3
		v_mul_lo_u32 v40, s17, v6
		v_lshlrev_b32_e32 v40, 2, v40
		v_mul_lo_u32 v42, s17, v8
		v_lshlrev_b32_e32 v42, 1, v42
		v_add3_u32 v9, v9, v40, v42
		v_lshlrev_b32_e32 v10, 7, v10
		v_add3_u32 v9, v9, v13, v10
		v_add3_u32 v9, v9, v15, v17
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		v_mov_b64_e32 v[120:121], v[44:45]
		v_mov_b64_e32 v[122:123], v[52:53]
		buffer_store_dwordx4 v[120:123], v9, s[8:11], 0 offen
		v_add_u32_e32 v9, 16, v8
		v_lshlrev_b32_e32 v6, 1, v6
		v_xor_b32_e32 v9, v9, v6
		v_bitop3_b32 v9, v14, v16, v9 bitop3:0x96
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v43, s0, v9
		v_add3_u32 v43, v43, v13, v10
		v_add3_u32 v43, v43, v15, v17
		v_mov_b64_e32 v[120:121], v[60:61]
		v_mov_b64_e32 v[122:123], v[64:65]
		buffer_store_dwordx4 v[120:123], v43, s[8:11], 0 offen
		v_add_u32_e32 v43, 32, v8
		v_xor_b32_e32 v43, v43, v6
		v_bitop3_b32 v43, v14, v16, v43 bitop3:0x96
		v_mul_lo_u32 v43, s17, v43
		v_lshlrev_b32_e32 v43, 1, v43
		v_add_u32_e32 v44, s0, v43
		v_add3_u32 v44, v44, v13, v10
		v_add3_u32 v44, v44, v15, v17
		v_mov_b64_e32 v[120:121], v[46:47]
		v_mov_b64_e32 v[122:123], v[54:55]
		buffer_store_dwordx4 v[120:123], v44, s[8:11], 0 offen
		v_add_u32_e32 v44, 48, v8
		v_xor_b32_e32 v44, v44, v6
		v_bitop3_b32 v44, v14, v16, v44 bitop3:0x96
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v13, v10
		v_add3_u32 v45, v45, v15, v17
		v_mov_b64_e32 v[52:53], v[62:63]
		v_mov_b64_e32 v[54:55], v[66:67]
		buffer_store_dwordx4 v[52:55], v45, s[8:11], 0 offen
		v_add_u32_e32 v45, 64, v8
		v_xor_b32_e32 v45, v45, v6
		v_bitop3_b32 v45, v14, v16, v45 bitop3:0x96
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v46, s0, v45
		v_add3_u32 v46, v46, v13, v10
		v_add3_u32 v46, v46, v15, v17
		v_mov_b64_e32 v[52:53], v[72:73]
		v_mov_b64_e32 v[54:55], v[76:77]
		buffer_store_dwordx4 v[52:55], v46, s[8:11], 0 offen
		v_add_u32_e32 v46, 0x50, v8
		v_xor_b32_e32 v46, v46, v6
		v_bitop3_b32 v46, v14, v16, v46 bitop3:0x96
		v_mul_lo_u32 v46, s17, v46
		v_lshlrev_b32_e32 v46, 1, v46
		v_add_u32_e32 v47, s0, v46
		v_add3_u32 v47, v47, v13, v10
		v_add3_u32 v47, v47, v15, v17
		v_mov_b64_e32 v[52:53], v[80:81]
		v_mov_b64_e32 v[54:55], v[84:85]
		buffer_store_dwordx4 v[52:55], v47, s[8:11], 0 offen
		v_add_u32_e32 v47, 0x60, v8
		v_xor_b32_e32 v47, v47, v6
		v_bitop3_b32 v47, v14, v16, v47 bitop3:0x96
		v_mul_lo_u32 v47, s17, v47
		v_lshlrev_b32_e32 v47, 1, v47
		v_add_u32_e32 v52, s0, v47
		v_add3_u32 v52, v52, v13, v10
		v_add3_u32 v52, v52, v15, v17
		v_mov_b64_e32 v[60:61], v[74:75]
		v_mov_b64_e32 v[62:63], v[78:79]
		buffer_store_dwordx4 v[60:63], v52, s[8:11], 0 offen
		v_add_u32_e32 v52, 0x70, v8
		v_xor_b32_e32 v52, v52, v6
		v_bitop3_b32 v52, v14, v16, v52 bitop3:0x96
		v_mul_lo_u32 v52, s17, v52
		v_lshlrev_b32_e32 v52, 1, v52
		v_add_u32_e32 v53, s0, v52
		v_add3_u32 v53, v53, v13, v10
		v_add3_u32 v53, v53, v15, v17
		v_mov_b64_e32 v[60:61], v[82:83]
		v_mov_b64_e32 v[62:63], v[86:87]
		buffer_store_dwordx4 v[60:63], v53, s[8:11], 0 offen
		v_add_u32_e32 v53, 0x80, v8
		v_xor_b32_e32 v53, v53, v6
		v_bitop3_b32 v53, v14, v16, v53 bitop3:0x96
		v_mul_lo_u32 v53, s17, v53
		v_lshlrev_b32_e32 v53, 1, v53
		v_add_u32_e32 v54, s0, v53
		v_add3_u32 v54, v54, v13, v10
		v_add3_u32 v54, v54, v15, v17
		v_mov_b64_e32 v[60:61], v[88:89]
		v_mov_b64_e32 v[62:63], v[92:93]
		buffer_store_dwordx4 v[60:63], v54, s[8:11], 0 offen
		v_add_u32_e32 v54, 0x90, v8
		v_xor_b32_e32 v54, v54, v6
		v_bitop3_b32 v54, v14, v16, v54 bitop3:0x96
		v_mul_lo_u32 v54, s17, v54
		v_lshlrev_b32_e32 v54, 1, v54
		v_add_u32_e32 v55, s0, v54
		v_add3_u32 v55, v55, v13, v10
		v_add3_u32 v55, v55, v15, v17
		v_mov_b64_e32 v[60:61], v[96:97]
		v_mov_b64_e32 v[62:63], v[100:101]
		buffer_store_dwordx4 v[60:63], v55, s[8:11], 0 offen
		v_add_u32_e32 v55, 0xa0, v8
		v_xor_b32_e32 v55, v55, v6
		v_bitop3_b32 v55, v14, v16, v55 bitop3:0x96
		v_mul_lo_u32 v55, s17, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v60, s0, v55
		v_add3_u32 v60, v60, v13, v10
		v_add3_u32 v60, v60, v15, v17
		v_mov_b64_e32 v[64:65], v[90:91]
		v_mov_b64_e32 v[66:67], v[94:95]
		buffer_store_dwordx4 v[64:67], v60, s[8:11], 0 offen
		v_add_u32_e32 v60, 0xb0, v8
		v_xor_b32_e32 v60, v60, v6
		v_bitop3_b32 v60, v14, v16, v60 bitop3:0x96
		v_mul_lo_u32 v60, s17, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_add_u32_e32 v61, s0, v60
		v_add3_u32 v61, v61, v13, v10
		v_add3_u32 v61, v61, v15, v17
		v_mov_b64_e32 v[64:65], v[98:99]
		v_mov_b64_e32 v[66:67], v[102:103]
		buffer_store_dwordx4 v[64:67], v61, s[8:11], 0 offen
		v_add_u32_e32 v61, 0xc0, v8
		v_xor_b32_e32 v61, v61, v6
		v_bitop3_b32 v61, v14, v16, v61 bitop3:0x96
		v_mul_lo_u32 v61, s17, v61
		v_lshlrev_b32_e32 v61, 1, v61
		v_add_u32_e32 v62, s0, v61
		v_add3_u32 v62, v62, v13, v10
		v_add3_u32 v62, v62, v15, v17
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[64:65], v[104:105]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[66:67], v[108:109]
		buffer_store_dwordx4 v[64:67], v62, s[8:11], 0 offen
		v_add_u32_e32 v62, 0xd0, v8
		v_xor_b32_e32 v62, v62, v6
		v_bitop3_b32 v62, v14, v16, v62 bitop3:0x96
		v_mul_lo_u32 v62, s17, v62
		v_lshlrev_b32_e32 v62, 1, v62
		v_add_u32_e32 v63, s0, v62
		v_add3_u32 v63, v63, v13, v10
		v_add3_u32 v63, v63, v15, v17
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[64:65], v[112:113]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[66:67], v[116:117]
		buffer_store_dwordx4 v[64:67], v63, s[8:11], 0 offen
		v_add_u32_e32 v63, 0xe0, v8
		v_xor_b32_e32 v63, v63, v6
		v_bitop3_b32 v63, v14, v16, v63 bitop3:0x96
		v_mul_lo_u32 v63, s17, v63
		v_lshlrev_b32_e32 v63, 1, v63
		v_add_u32_e32 v64, s0, v63
		v_add3_u32 v64, v64, v13, v10
		v_add3_u32 v64, v64, v15, v17
		v_mov_b64_e32 v[72:73], v[106:107]
		v_mov_b64_e32 v[74:75], v[110:111]
		buffer_store_dwordx4 v[72:75], v64, s[8:11], 0 offen
		v_add_u32_e32 v8, 0xf0, v8
		v_xor_b32_e32 v6, v8, v6
		v_bitop3_b32 v6, v14, v16, v6 bitop3:0x96
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v8, s0, v6
		v_add3_u32 v8, v8, v13, v10
		v_add3_u32 v8, v8, v15, v17
		v_mov_b64_e32 v[64:65], v[114:115]
		v_mov_b64_e32 v[66:67], v[118:119]
		buffer_store_dwordx4 v[64:67], v8, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[48:51], a[72:75], v[200:203], v38, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[56:59], a[72:75], v[204:207], v38, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[56:59], a[80:83], v[220:223], v38, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[48:51], a[80:83], v[216:219], v38, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[52:55], a[76:79], v[200:203], v38, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], a[76:79], v[204:207], v38, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], v[56:59], v[220:223], v38, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[52:55], v[56:59], v[216:219], v38, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[72:75], v[208:211], v39, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[72:75], v[212:215], v39, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[80:83], v[228:231], v39, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], a[80:83], v[224:227], v39, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], a[76:79], v[208:211], v39, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v200, v201
		v_cvt_pk_bf16_f32 v65, v202, v203
		v_cvt_pk_bf16_f32 v72, v204, v205
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], a[76:79], v[212:215], v39, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v73, v206, v207
		v_cvt_pk_bf16_f32 v66, v216, v217
		v_cvt_pk_bf16_f32 v67, v218, v219
		ds_write_b128 v2, v[64:67] offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[56:59], v[228:231], v39, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v208, v209
		v_cvt_pk_bf16_f32 v65, v210, v211
		v_cvt_pk_bf16_f32 v74, v220, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[56:59], v[224:227], v39, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v56, v212, v213
		v_cvt_pk_bf16_f32 v57, v214, v215
		v_cvt_pk_bf16_f32 v75, v222, v223
		ds_write_b128 v4, v[72:75] offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], v[20:23], v[240:243], v39, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v58, v228, v229
		v_cvt_pk_bf16_f32 v59, v230, v231
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], v[20:23], v[244:247], v39, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v66, v224, v225
		v_cvt_pk_bf16_f32 v67, v226, v227
		ds_write_b128 v5, v[64:67] offset:24576
		ds_write_b128 v0, v[56:59] offset:28672
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], a[8:11], a[108:111], v39, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[24:27], a[8:11], v[248:251], v39, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], a[4:7], v[240:243], v39, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[4:7], v[244:247], v39, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[48:51], a[12:15], a[108:111], v39, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[28:31], a[12:15], v[248:251], v39, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[48:51], v[20:23], v[232:235], v38, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[56:59], v[20:23], v[236:239], v38, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[56:59], a[8:11], a[104:107], v38, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[48:51], a[8:11], a[100:103], v38, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[52:55], a[4:7], v[232:235], v38, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v20, v240, v241
		v_cvt_pk_bf16_f32 v21, v242, v243
		v_cvt_pk_bf16_f32 v56, v244, v245
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], a[4:7], v[236:239], v38, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v57, v246, v247
		v_cvt_pk_bf16_f32 v22, v248, v249
		v_cvt_pk_bf16_f32 v23, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[12:15], a[104:107], v38, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v232, v233
		v_cvt_pk_bf16_f32 v65, v234, v235
		v_accvgpr_read_b32 v8, a108
		v_accvgpr_read_b32 v14, a109
		v_cvt_pk_bf16_f32 v58, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[52:55], a[12:15], a[100:103], v38, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v72, v236, v237
		v_cvt_pk_bf16_f32 v73, v238, v239
		v_accvgpr_read_b32 v8, a110
		v_accvgpr_read_b32 v14, a111
		v_cvt_pk_bf16_f32 v59, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[48:51], a[16:19], a[112:115], v38, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a104
		v_accvgpr_read_b32 v14, a105
		v_cvt_pk_bf16_f32 v74, v8, v14
		v_accvgpr_read_b32 v8, a106
		v_accvgpr_read_b32 v14, a107
		v_cvt_pk_bf16_f32 v75, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[56:59], a[16:19], a[116:119], v38, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[56:59], a[24:27], a[132:135], v38, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a100
		v_accvgpr_read_b32 v14, a101
		v_cvt_pk_bf16_f32 v66, v8, v14
		v_accvgpr_read_b32 v8, a102
		v_accvgpr_read_b32 v14, a103
		v_cvt_pk_bf16_f32 v67, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[48:51], a[24:27], a[128:131], v38, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[52:55], a[20:23], a[112:115], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[68:71], a[20:23], a[116:119], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[68:71], a[28:31], a[132:135], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[52:55], a[28:31], a[128:131], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], a[16:19], a[120:123], v39, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], a[16:19], a[124:127], v39, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], a[24:27], a[140:143], v39, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], a[24:27], a[136:139], v39, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], a[20:23], a[120:123], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a112
		v_accvgpr_read_b32 v14, a113
		v_cvt_pk_bf16_f32 v76, v8, v14
		v_accvgpr_read_b32 v8, a114
		v_accvgpr_read_b32 v14, a115
		v_cvt_pk_bf16_f32 v77, v8, v14
		v_accvgpr_read_b32 v8, a116
		v_accvgpr_read_b32 v14, a117
		v_cvt_pk_bf16_f32 v80, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], a[20:23], a[124:127], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a118
		v_accvgpr_read_b32 v14, a119
		v_cvt_pk_bf16_f32 v81, v8, v14
		v_accvgpr_read_b32 v8, a128
		v_accvgpr_read_b32 v14, a129
		v_cvt_pk_bf16_f32 v78, v8, v14
		v_accvgpr_read_b32 v8, a130
		v_accvgpr_read_b32 v14, a131
		v_cvt_pk_bf16_f32 v79, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], a[28:31], a[140:143], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a120
		v_accvgpr_read_b32 v14, a121
		v_cvt_pk_bf16_f32 v84, v8, v14
		v_accvgpr_read_b32 v8, a122
		v_accvgpr_read_b32 v14, a123
		v_cvt_pk_bf16_f32 v85, v8, v14
		v_accvgpr_read_b32 v8, a132
		v_accvgpr_read_b32 v14, a133
		v_cvt_pk_bf16_f32 v82, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], a[28:31], a[136:139], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a124
		v_accvgpr_read_b32 v14, a125
		v_cvt_pk_bf16_f32 v88, v8, v14
		v_accvgpr_read_b32 v8, a126
		v_accvgpr_read_b32 v14, a127
		v_cvt_pk_bf16_f32 v89, v8, v14
		v_accvgpr_read_b32 v8, a134
		v_accvgpr_read_b32 v14, a135
		v_cvt_pk_bf16_f32 v83, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], a[32:35], a[152:155], v39, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a140
		v_accvgpr_read_b32 v14, a141
		v_cvt_pk_bf16_f32 v90, v8, v14
		v_accvgpr_read_b32 v8, a142
		v_accvgpr_read_b32 v14, a143
		v_cvt_pk_bf16_f32 v91, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], a[32:35], a[156:159], v39, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], a[40:43], a[172:175], v39, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a136
		v_accvgpr_read_b32 v14, a137
		v_cvt_pk_bf16_f32 v86, v8, v14
		v_accvgpr_read_b32 v8, a138
		v_accvgpr_read_b32 v14, a139
		v_cvt_pk_bf16_f32 v87, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[24:27], a[40:43], a[168:171], v39, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], a[36:39], a[152:155], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], a[36:39], a[156:159], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], a[44:47], a[172:175], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], a[44:47], a[168:171], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], a[32:35], a[144:147], v38, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[32:35], a[148:151], v38, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[56:59], a[40:43], a[164:167], v38, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[48:51], a[40:43], a[160:163], v38, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[52:55], a[36:39], a[144:147], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a152
		v_accvgpr_read_b32 v14, a153
		v_cvt_pk_bf16_f32 v24, v8, v14
		v_accvgpr_read_b32 v8, a154
		v_accvgpr_read_b32 v14, a155
		v_cvt_pk_bf16_f32 v25, v8, v14
		v_accvgpr_read_b32 v8, a156
		v_accvgpr_read_b32 v14, a157
		v_cvt_pk_bf16_f32 v28, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[68:71], a[36:39], a[148:151], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a158
		v_accvgpr_read_b32 v14, a159
		v_cvt_pk_bf16_f32 v29, v8, v14
		v_accvgpr_read_b32 v8, a168
		v_accvgpr_read_b32 v14, a169
		v_cvt_pk_bf16_f32 v26, v8, v14
		v_accvgpr_read_b32 v8, a170
		v_accvgpr_read_b32 v14, a171
		v_cvt_pk_bf16_f32 v27, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[68:71], a[44:47], a[164:167], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a144
		v_accvgpr_read_b32 v14, a145
		v_cvt_pk_bf16_f32 v32, v8, v14
		v_accvgpr_read_b32 v8, a146
		v_accvgpr_read_b32 v14, a147
		v_cvt_pk_bf16_f32 v33, v8, v14
		v_accvgpr_read_b32 v8, a172
		v_accvgpr_read_b32 v14, a173
		v_cvt_pk_bf16_f32 v30, v8, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], a[44:47], a[160:163], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a148
		v_accvgpr_read_b32 v14, a149
		v_cvt_pk_bf16_f32 v36, v8, v14
		v_accvgpr_read_b32 v8, a150
		v_accvgpr_read_b32 v14, a151
		v_cvt_pk_bf16_f32 v37, v8, v14
		v_accvgpr_read_b32 v8, a174
		v_accvgpr_read_b32 v14, a175
		v_cvt_pk_bf16_f32 v31, v8, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v8, a164
		v_accvgpr_read_b32 v14, a165
		v_cvt_pk_bf16_f32 v38, v8, v14
		v_accvgpr_read_b32 v8, a166
		v_accvgpr_read_b32 v14, a167
		v_cvt_pk_bf16_f32 v39, v8, v14
		ds_read_b128 v[48:51], v11 offset:16384
		ds_read_b128 v[68:71], v11 offset:16640
		v_accvgpr_read_b32 v8, a160
		v_accvgpr_read_b32 v14, a161
		v_cvt_pk_bf16_f32 v34, v8, v14
		v_accvgpr_read_b32 v8, a162
		v_accvgpr_read_b32 v14, a163
		v_cvt_pk_bf16_f32 v35, v8, v14
		ds_read_b128 v[92:95], v11 offset:18432
		ds_read_b128 v[96:99], v11 offset:18688
		v_add_u32_e32 v8, 0xffffc000, v41
		v_add_u32_e32 v11, 0xffffc100, v41
		v_add_u32_e32 v14, 0xffffc800, v41
		v_add_u32_e32 v16, 0xffffc900, v41
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[64:67] offset:16384
		ds_write_b128 v4, v[72:75] offset:20480
		ds_write_b128 v5, v[20:23] offset:24576
		ds_write_b128 v0, v[56:59] offset:28672
		v_add_u32_e32 v18, 0xffff8000, v7
		v_add_u32_e32 v19, 0xffff8100, v7
		v_add_u32_e32 v20, 0xffff8800, v7
		v_add_u32_e32 v7, 0xffff8900, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v12
		ds_read_b128 v[64:67], v12 offset:256
		ds_read_b128 v[72:75], v12 offset:2048
		ds_read_b128 v[100:103], v12 offset:2304
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v40, v42
		v_add3_u32 v1, v1, v13, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[76:79] offset:16384
		ds_write_b128 v4, v[80:83] offset:20480
		ds_write_b128 v5, v[84:87] offset:24576
		ds_write_b128 v0, v[88:91] offset:28672
		v_add3_u32 v1, v1, v15, v17
		v_mov_b64_e32 v[76:77], v[48:49]
		v_mov_b64_e32 v[78:79], v[68:69]
		buffer_store_dwordx4 v[76:79], v1, s[8:11], 0 offen
		v_add3_u32 v1, v13, v10, v15
		v_add_u32_e32 v1, v1, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v8
		ds_read_b128 v[80:83], v11
		ds_read_b128 v[84:87], v14
		ds_read_b128 v[88:91], v16
		v_add3_u32 v3, v9, v1, s0
		v_mov_b64_e32 v[104:105], v[92:93]
		v_mov_b64_e32 v[106:107], v[96:97]
		buffer_store_dwordx4 v[104:107], v3, s[8:11], 0 offen
		v_add3_u32 v3, v43, v1, s0
		v_mov_b64_e32 v[40:41], v[50:51]
		v_mov_b64_e32 v[42:43], v[70:71]
		buffer_store_dwordx4 v[40:43], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[32:35] offset:16384
		ds_write_b128 v4, v[36:39] offset:20480
		ds_write_b128 v5, v[24:27] offset:24576
		ds_write_b128 v0, v[28:31] offset:28672
		v_add3_u32 v0, v44, v1, s0
		v_mov_b64_e32 v[24:25], v[94:95]
		v_mov_b64_e32 v[26:27], v[98:99]
		buffer_store_dwordx4 v[24:27], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v18
		ds_read_b128 v[28:31], v19
		ds_read_b128 v[32:35], v20
		ds_read_b128 v[20:23], v7
		v_add3_u32 v1, v45, v0, s0
		v_mov_b64_e32 v[36:37], v[56:57]
		v_mov_b64_e32 v[38:39], v[64:65]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v46, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[72:73]
		v_mov_b64_e32 v[38:39], v[100:101]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v0, v47, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[58:59]
		v_mov_b64_e32 v[38:39], v[66:67]
		buffer_store_dwordx4 v[36:39], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v52, v0, s0
		v_mov_b64_e32 v[36:37], v[74:75]
		v_mov_b64_e32 v[38:39], v[102:103]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v53, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[76:77]
		v_mov_b64_e32 v[38:39], v[80:81]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v0, v54, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[84:85]
		v_mov_b64_e32 v[38:39], v[88:89]
		buffer_store_dwordx4 v[36:39], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v55, v0, s0
		v_mov_b64_e32 v[36:37], v[78:79]
		v_mov_b64_e32 v[38:39], v[82:83]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v60, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[86:87]
		v_mov_b64_e32 v[38:39], v[90:91]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v0, v61, v0, s0
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mov_b64_e32 v[36:37], v[24:25]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[38:39], v[28:29]
		buffer_store_dwordx4 v[36:39], v0, s[8:11], 0 offen
		v_add3_u32 v0, v13, v10, v15
		v_add_u32_e32 v0, v0, v17
		v_add3_u32 v1, v62, v0, s0
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[8:9], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[10:11], v[20:21]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v63, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[26:27]
		v_mov_b64_e32 v[10:11], v[30:31]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v6, v0, s0
		v_mov_b64_e32 v[4:5], v[34:35]
		v_mov_b64_e32 v[6:7], v[22:23]
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
		.amdhsa_next_free_vgpr 432
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
	.set .L_a4w4_kernel.num_agpr, 176
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
    .vgpr_count:     432
    .agpr_count:     176
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 99
    wave.regalloc.agpr.dwords: 389
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
