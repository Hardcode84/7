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
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_mov_b32 s32, s10
		s_mov_b32 s33, s11
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		v_readfirstlane_b32 s21, v0
		v_lshrrev_b32_e32 v1, 7, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v8, s14, v3
		v_add_u32_e32 v9, v2, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v10, 1, v10
		v_mul_lo_u32 v11, s14, v10
		v_lshlrev_b32_e32 v11, 6, v11
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v13, 1, v12
		v_mul_lo_u32 v14, s14, v13
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v9, v9, v11, v14
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v16, s14, v15
		v_lshlrev_b32_e32 v16, 4, v16
		v_and_b32_e32 v17, 1, v0
		v_lshlrev_b32_e32 v18, 4, v17
		v_add3_u32 v9, v9, v16, v18
		v_lshrrev_b32_e32 v19, 2, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 6, v19
		v_lshrrev_b32_e32 v21, 1, v0
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v22, 5, v21
		v_add3_u32 v9, v9, v20, v22
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		s_mul_i32 s20, s20, s15
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v23, s22, v2, v8
		v_add3_u32 v23, v23, v11, v14
		v_add3_u32 v23, v23, v16, v18
		v_add3_u32 v23, v23, v20, v22
		s_add_i32 m0, s21, 0x1080
		s_mov_b32 s23, 0
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_lshl_b32 s36, s14, 3
		v_add3_u32 v24, v2, v8, v11
		v_add3_u32 v24, v24, v14, v16
		v_add3_u32 v24, v24, v18, v20
		s_add_i32 m0, s21, 0x2100
		v_add3_u32 v25, v22, v24, s36
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s37, 12, s14
		s_add_i32 m0, s21, 0x3180
		v_add3_u32 v26, v22, v24, s37
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_lshl_b32 s38, s14, 7
		s_add_i32 m0, s21, 0x4200
		v_add3_u32 v24, v22, v24, s38
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s39, 0x84, s14
		v_add3_u32 v27, v2, v8, v11
		v_add3_u32 v27, v27, v14, v16
		v_add3_u32 v27, v27, v18, v20
		s_add_i32 m0, s21, 0x5280
		v_add3_u32 v28, v22, v27, s39
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s40, 0x88, s14
		s_add_i32 m0, s21, 0x6300
		v_add3_u32 v29, v22, v27, s40
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s21, 0x7380
		v_add3_u32 v27, v22, v27, s14
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_add_u32 s44, s4, s20
		s_addc_u32 s45, s5, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		v_mul_lo_u32 v30, s15, v1
		v_lshlrev_b32_e32 v30, 1, v30
		v_mul_lo_u32 v31, s15, v3
		v_add_u32_e32 v32, v30, v31
		v_mul_lo_u32 v33, s15, v10
		v_lshlrev_b32_e32 v33, 6, v33
		v_mul_lo_u32 v34, s15, v13
		v_lshlrev_b32_e32 v34, 5, v34
		v_add3_u32 v32, v32, v33, v34
		v_mul_lo_u32 v35, s15, v15
		v_lshlrev_b32_e32 v35, 4, v35
		v_add3_u32 v32, v32, v35, v18
		s_add_i32 m0, s21, 0x107c0
		v_add3_u32 v32, v32, v20, v22
		buffer_load_dwordx4 v32, s[44:47], 0 offen lds
		s_lshl_b32 s41, s15, 2
		v_add3_u32 v36, v30, v31, v33
		v_add3_u32 v36, v36, v34, v35
		v_add3_u32 v36, v36, v18, v20
		s_add_i32 m0, s21, 0x11840
		v_add3_u32 v37, v22, v36, s41
		buffer_load_dwordx4 v37, s[44:47], 0 offen lds
		s_lshl_b32 s42, s15, 3
		s_add_i32 m0, s21, 0x128c0
		v_add3_u32 v38, v22, v36, s42
		buffer_load_dwordx4 v38, s[44:47], 0 offen lds
		s_mul_i32 s43, 12, s15
		s_add_i32 m0, s21, 0x13940
		v_add3_u32 v36, v22, v36, s43
		buffer_load_dwordx4 v36, s[44:47], 0 offen lds
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s16, s16, 8
		s_add_i32 s1, s1, s16
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v39, s18, v1
		v_lshlrev_b32_e32 v39, 2, v39
		v_mul_lo_u32 v40, s18, v3
		v_lshlrev_b32_e32 v40, 1, v40
		v_add3_u32 v41, s1, v39, v40
		v_mul_lo_u32 v42, s18, v10
		v_lshlrev_b32_e32 v43, 3, v17
		v_add3_u32 v41, v41, v42, v43
		v_lshlrev_b32_e32 v44, 7, v13
		v_lshlrev_b32_e32 v45, 6, v15
		v_add3_u32 v41, v41, v44, v45
		v_lshlrev_b32_e32 v46, 5, v19
		v_lshlrev_b32_e32 v47, 4, v21
		v_add3_u32 v41, v41, v46, v47
		buffer_load_dwordx2 v[48:49], v41, s[28:31], 0 offen
		s_lshl_b32 s16, s0, 8
		v_mul_lo_u32 v50, s19, v1
		v_lshlrev_b32_e32 v50, 2, v50
		v_mul_lo_u32 v51, s19, v3
		v_lshlrev_b32_e32 v51, 1, v51
		v_add3_u32 v52, s16, v50, v51
		v_mul_lo_u32 v53, s19, v10
		v_lshlrev_b32_e32 v54, 2, v17
		v_add3_u32 v52, v52, v53, v54
		v_lshlrev_b32_e32 v55, 6, v13
		v_lshlrev_b32_e32 v56, 5, v15
		v_add3_u32 v52, v52, v55, v56
		v_lshlrev_b32_e32 v57, 4, v19
		v_lshlrev_b32_e32 v58, 3, v21
		v_add3_u32 v52, v52, v57, v58
		buffer_load_dword v59, v52, s[32:35], 0 offen
		s_lshl_b32 s48, s15, 7
		v_add3_u32 v60, s48, v30, v31
		v_add3_u32 v60, v60, v33, v34
		v_add3_u32 v60, v60, v35, v18
		s_add_i32 m0, s21, 0x18b80
		v_add3_u32 v60, v60, v20, v22
		buffer_load_dwordx4 v60, s[44:47], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v61, v30, v31, v33
		v_add3_u32 v61, v61, v34, v35
		v_add3_u32 v61, v61, v18, v20
		s_add_i32 m0, s21, 0x19c00
		v_add3_u32 v62, v22, v61, s49
		buffer_load_dwordx4 v62, s[44:47], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, s21, 0x1ac80
		v_add3_u32 v63, v22, v61, s50
		buffer_load_dwordx4 v63, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s21, 0x1bd00
		v_add3_u32 v61, v22, v61, s15
		buffer_load_dwordx4 v61, s[44:47], 0 offen lds
		s_add_i32 s51, s16, 0x80
		v_add3_u32 v64, s51, v50, v51
		v_add3_u32 v64, v64, v53, v54
		v_add3_u32 v64, v64, v55, v56
		v_add3_u32 v64, v64, v57, v58
		buffer_load_dword v65, v64, s[32:35], 0 offen
		v_add_u32_e32 v66, 0x80, v2
		v_add_u32_e32 v66, v66, v8
		v_add3_u32 v66, v66, v11, v14
		v_add3_u32 v66, v66, v16, v18
		s_add_i32 m0, s21, 0x83e0
		v_add3_u32 v66, v66, v20, v22
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v66, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v67, s22, v2, v8
		v_add3_u32 v67, v67, v11, v14
		v_add3_u32 v67, v67, v16, v18
		s_add_i32 m0, s21, 0x9460
		v_add3_u32 v67, v67, v20, v22
		buffer_load_dwordx4 v67, s[24:27], 0 offen lds
		s_add_i32 s22, s36, 0x80
		v_add3_u32 v68, s22, v2, v8
		v_add3_u32 v68, v68, v11, v14
		v_add3_u32 v68, v68, v16, v18
		s_add_i32 m0, s21, 0xa4e0
		v_add3_u32 v68, v68, v20, v22
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s22, s37, 0x80
		v_add3_u32 v69, s22, v2, v8
		v_add3_u32 v69, v69, v11, v14
		v_add3_u32 v69, v69, v16, v18
		s_add_i32 m0, s21, 0xb560
		v_add3_u32 v69, v69, v20, v22
		buffer_load_dwordx4 v69, s[24:27], 0 offen lds
		s_add_i32 s22, s38, 0x80
		v_add3_u32 v70, s22, v2, v8
		v_add3_u32 v70, v70, v11, v14
		v_add3_u32 v70, v70, v16, v18
		s_add_i32 m0, s21, 0xc5e0
		v_add3_u32 v70, v70, v20, v22
		buffer_load_dwordx4 v70, s[24:27], 0 offen lds
		s_add_i32 s22, s39, 0x80
		v_add3_u32 v71, s22, v2, v8
		v_add3_u32 v71, v71, v11, v14
		v_add3_u32 v71, v71, v16, v18
		s_add_i32 m0, s21, 0xd660
		v_add3_u32 v71, v71, v20, v22
		buffer_load_dwordx4 v71, s[24:27], 0 offen lds
		s_add_i32 s22, s40, 0x80
		v_add3_u32 v72, s22, v2, v8
		v_add3_u32 v72, v72, v11, v14
		v_add3_u32 v72, v72, v16, v18
		s_add_i32 m0, s21, 0xe6e0
		v_add3_u32 v72, v72, v20, v22
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v8
		v_add3_u32 v2, v2, v11, v14
		v_add3_u32 v2, v2, v16, v18
		s_add_i32 m0, s21, 0xf760
		v_add3_u32 v2, v2, v20, v22
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v8, 0x80, v30
		v_add_u32_e32 v8, v8, v31
		v_add3_u32 v8, v8, v33, v34
		v_add3_u32 v8, v8, v35, v18
		s_add_i32 m0, s21, 0x149a0
		v_add3_u32 v8, v8, v20, v22
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
		s_add_i32 s14, s41, 0x80
		v_add3_u32 v11, v30, v31, v33
		v_add3_u32 v11, v11, v34, v35
		v_add3_u32 v11, v11, v18, v20
		s_add_i32 m0, s21, 0x15a20
		v_add3_u32 v14, v22, v11, s14
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 s14, s42, 0x80
		s_add_i32 m0, s21, 0x16aa0
		v_add3_u32 v16, v22, v11, s14
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
		s_add_i32 s14, s43, 0x80
		s_add_i32 m0, s21, 0x17b20
		v_add3_u32 v11, v22, v11, s14
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		v_add3_u32 v39, s1, v39, v40
		v_add3_u32 v39, v39, v42, v43
		v_add3_u32 v39, v39, v44, v45
		v_add3_u32 v39, v39, v46, v47
		buffer_load_dwordx2 v[74:75], v39, s[28:31], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s16, s1
		v_add3_u32 v40, s14, v50, v51
		v_add3_u32 v40, v40, v53, v54
		v_add3_u32 v40, v40, v55, v56
		v_add3_u32 v40, v40, v57, v58
		buffer_load_dword v42, v40, s[32:35], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v47, s14, v30, v31
		v_add3_u32 v47, v47, v33, v34
		v_add3_u32 v47, v47, v35, v18
		s_add_i32 m0, s21, 0x1cd60
		v_add3_u32 v47, v47, v20, v22
		s_waitcnt vmcnt(15)
		buffer_load_dwordx4 v47, s[44:47], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v30, v30, v31, v33
		v_add3_u32 v30, v30, v34, v35
		v_add3_u32 v30, v30, v18, v20
		s_add_i32 m0, s21, 0x1dde0
		v_add3_u32 v31, v22, v30, s14
		buffer_load_dwordx4 v31, s[44:47], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, s21, 0x1ee60
		v_add3_u32 v33, v22, v30, s14
		buffer_load_dwordx4 v33, s[44:47], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s21, 0x1fee0
		v_add3_u32 v30, v22, v30, s14
		buffer_load_dwordx4 v30, s[44:47], 0 offen lds
		s_add_i32 s1, s51, s1
		v_add3_u32 v34, s1, v50, v51
		v_add3_u32 v34, v34, v53, v54
		v_add3_u32 v34, v34, v55, v56
		v_add3_u32 v34, v34, v57, v58
		buffer_load_dword v35, v34, s[32:35], 0 offen
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_mul_i32 s14, s18, 16
		s_mul_i32 s15, s19, 16
		s_barrier
		v_lshlrev_b32_e32 v50, 7, v1
		v_and_b32_e32 v51, 63, v0
		v_lshrrev_b32_e32 v53, 4, v51
		v_lshlrev_b32_e32 v53, 4, v53
		v_and_b32_e32 v51, 15, v51
		v_mov_b32_e32 v54, 0x420
		v_mul_lo_u32 v54, v54, v51
		v_add3_u32 v50, v50, v53, v54
		ds_read_b128 a[0:3], v50
		ds_read_b128 a[4:7], v50 offset:64
		ds_read_b128 a[8:11], v50 offset:256
		ds_read_b128 a[12:15], v50 offset:320
		ds_read_b128 a[16:19], v50 offset:512
		ds_read_b128 a[20:23], v50 offset:576
		ds_read_b128 a[24:27], v50 offset:768
		ds_read_b128 a[28:31], v50 offset:832
		ds_read_b128 a[32:35], v50 offset:16896
		ds_read_b128 a[36:39], v50 offset:16960
		ds_read_b128 a[40:43], v50 offset:17152
		ds_read_b128 a[44:47], v50 offset:17216
		ds_read_b128 a[48:51], v50 offset:17408
		ds_read_b128 a[52:55], v50 offset:17472
		ds_read_b128 a[56:59], v50 offset:17664
		ds_read_b128 a[60:63], v50 offset:17728
		v_add_u32_e32 v51, 0x10000, v53
		v_lshlrev_b32_e32 v53, 7, v3
		v_add3_u32 v51, v51, v53, v54
		ds_read_b128 a[64:67], v51 offset:1984
		ds_read_b128 a[68:71], v51 offset:2048
		ds_read_b128 a[72:75], v51 offset:2240
		ds_read_b128 a[76:79], v51 offset:2304
		ds_read_b128 a[80:83], v51 offset:2496
		ds_read_b128 a[84:87], v51 offset:2560
		ds_read_b128 a[88:91], v51 offset:2752
		ds_read_b128 a[92:95], v51 offset:2816
		v_lshlrev_b32_e32 v53, 3, v0
		v_add_u32_e32 v53, 0x20000, v53
		ds_write_b64 v53, v[48:49] offset:3904
		v_lshlrev_b32_e32 v48, 2, v0
		v_add_u32_e32 v48, 0x20000, v48
		ds_write_b32 v48, v59 offset:5952
		v_lshlrev_b32_e32 v49, 4, v1
		s_waitcnt lgkmcnt(1)
		s_barrier
		v_add_u32_e32 v49, 0x20000, v49
		v_add_u32_e32 v49, v49, v43
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v49, v10, 9, v49
		v_lshlrev_b32_e32 v54, 8, v13
		v_add3_u32 v49, v49, v54, v45
		v_lshlrev_b32_e32 v54, 10, v21
		v_add3_u32 v49, v49, v46, v54
		ds_read_b64_tr_b8 v[56:57], v49 offset:3904
		ds_read_b64_tr_b8 v[58:59], v49 offset:4032
		v_add_u32_e32 v43, 0x20000, v43
		v_lshl_add_u32 v43, v3, 4, v43
		v_lshlrev_b32_e32 v55, 8, v10
		v_add3_u32 v43, v43, v55, v44
		v_add3_u32 v43, v43, v45, v46
		v_lshl_add_u32 v21, v21, 9, v43
		ds_read_b64_tr_b8 v[44:45], v21 offset:5952
		s_mov_b32 s16, s14
		s_mov_b32 s18, s15
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_add_u32 s36, s8, s16
		s_addc_u32 s37, s9, 0
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		s_add_u32 s40, s10, s18
		s_addc_u32 s41, s11, 0
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v44, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v44, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v44, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v44, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v45, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v45, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v45, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v45, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[92:95], a[4:7], v[76:79], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], a[12:15], v[92:95], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v45, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v45, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v45, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v45, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[92:95], a[20:23], v[108:111], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], a[28:31], v[124:127], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v44, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v44, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v44, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v44, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v44, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v44, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v44, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v44, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v45, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v45, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v45, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v45, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], a[36:39], v[140:143], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], a[44:47], v[156:159], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v45, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v45, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v45, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v45, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], a[52:55], v[172:175], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], a[60:63], v[188:191], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v44, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v44, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v44, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v44, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[64:67], v51 offset:35712
		ds_read_b128 a[68:71], v51 offset:35776
		ds_read_b128 a[72:75], v51 offset:35968
		ds_read_b128 a[76:79], v51 offset:36032
		ds_read_b128 a[80:83], v51 offset:36224
		ds_read_b128 a[84:87], v51 offset:36288
		ds_read_b128 a[88:91], v51 offset:36480
		ds_read_b128 a[92:95], v51 offset:36544
		s_waitcnt vmcnt(19)
		ds_write_b32 v48, v65 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[44:45], v21 offset:5952
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], a[0:3], v[192:195], v44, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[0:3], v[196:199], v44, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[8:11], v[212:215], v44, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[64:67], a[8:11], v[208:211], v44, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[68:71], a[4:7], v[192:195], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[76:79], a[4:7], v[196:199], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x7380
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x107c0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[76:79], a[12:15], v[212:215], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x11840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[68:71], a[12:15], v[208:211], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x128c0
		s_add_u32 s40, s10, s18
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x13940
		s_add_u32 s36, s8, s16
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[252:253], v41, s[36:39], 0 offen
		buffer_load_dword v43, v52, s[40:43], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[0:3], v[200:203], v45, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[0:3], v[204:207], v45, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[8:11], v[220:223], v45, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[8:11], v[216:219], v45, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[84:87], a[4:7], v[200:203], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], a[4:7], v[204:207], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[92:95], a[12:15], v[220:223], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[84:87], a[12:15], v[216:219], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[16:19], v[232:235], v45, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[16:19], v[236:239], v45, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v45, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v45, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[84:87], a[20:23], v[232:235], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[92:95], a[20:23], v[236:239], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[28:31], a[104:107], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[16:19], v[224:227], v44, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[16:19], v[228:231], v44, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[24:27], v[244:247], v44, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[24:27], v[240:243], v44, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[68:71], a[20:23], v[224:227], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[76:79], a[20:23], v[228:231], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v44, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v44, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v44, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v44, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v45, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v45, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v45, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v45, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v45, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v45, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v45, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v45, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v44, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v44, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v44, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v44, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 a[0:3], v50 offset:33760
		ds_read_b128 a[4:7], v50 offset:33824
		ds_read_b128 a[8:11], v50 offset:34016
		ds_read_b128 a[12:15], v50 offset:34080
		ds_read_b128 a[16:19], v50 offset:34272
		ds_read_b128 a[20:23], v50 offset:34336
		ds_read_b128 a[24:27], v50 offset:34528
		ds_read_b128 a[28:31], v50 offset:34592
		ds_read_b128 a[32:35], v50 offset:50656
		ds_read_b128 a[36:39], v50 offset:50720
		ds_read_b128 a[40:43], v50 offset:50912
		ds_read_b128 a[44:47], v50 offset:50976
		ds_read_b128 a[48:51], v50 offset:51168
		ds_read_b128 a[52:55], v50 offset:51232
		ds_read_b128 a[56:59], v50 offset:51424
		ds_read_b128 a[60:63], v50 offset:51488
		ds_read_b128 a[64:67], v51 offset:18848
		ds_read_b128 a[68:71], v51 offset:18912
		ds_read_b128 a[72:75], v51 offset:19104
		ds_read_b128 a[76:79], v51 offset:19168
		ds_read_b128 a[80:83], v51 offset:19360
		ds_read_b128 a[84:87], v51 offset:19424
		ds_read_b128 a[88:91], v51 offset:19616
		ds_read_b128 v[56:59], v51 offset:19680
		s_waitcnt vmcnt(20)
		ds_write_b64 v53, v[74:75] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v48, v42 offset:5952
		s_add_i32 m0, s21, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[44:45], v49 offset:3904
		ds_read_b64_tr_b8 v[254:255], v49 offset:4032
		ds_read_b64_tr_b8 v[74:75], v21 offset:5952
		buffer_load_dwordx4 v60, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x19c00
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v74, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v62, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ac80
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v74, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v63, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1bd00
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v74, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v61, s[32:35], 0 offen lds
		buffer_load_dword v65, v64, s[40:43], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v74, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v74, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v74, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v74, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v74, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v75, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v75, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v75, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v75, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v75, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[56:59], a[4:7], v[76:79], v75, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[56:59], a[12:15], v[92:95], v75, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v75, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v75, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v75, v45 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v75, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v75, v45 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v75, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[56:59], a[20:23], v[108:111], v75, v45 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[56:59], a[28:31], v[124:127], v75, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v75, v45 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v74, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v74, v45 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v74, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v74, v45 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v74, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v74, v45 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v74, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v74, v45 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v74, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v74, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v74, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v74, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v74, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v74, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v74, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v74, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v75, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v75, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v75, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v75, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v75, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[56:59], a[36:39], v[140:143], v75, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], a[44:47], v[156:159], v75, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v75, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v75, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v75, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v75, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v75, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v75, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], a[52:55], v[172:175], v75, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], a[60:63], v[188:191], v75, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v75, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v74, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v74, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v74, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v74, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v74, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v74, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v74, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v74, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[64:67], v51 offset:52576
		ds_read_b128 a[68:71], v51 offset:52640
		ds_read_b128 a[72:75], v51 offset:52832
		ds_read_b128 a[76:79], v51 offset:52896
		ds_read_b128 a[80:83], v51 offset:53088
		ds_read_b128 a[84:87], v51 offset:53152
		ds_read_b128 a[88:91], v51 offset:53344
		ds_read_b128 a[92:95], v51 offset:53408
		s_waitcnt vmcnt(19)
		ds_write_b32 v48, v35 offset:5952
		s_add_i32 m0, s21, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[56:57], v21 offset:5952
		buffer_load_dwordx4 v66, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x9460
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], a[0:3], v[192:195], v56, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v67, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xa4e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[0:3], v[196:199], v56, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[8:11], v[212:215], v56, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v69, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[64:67], a[8:11], v[208:211], v56, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v70, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[68:71], a[4:7], v[192:195], v56, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[76:79], a[4:7], v[196:199], v56, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v72, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[76:79], a[12:15], v[212:215], v56, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x149a0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[68:71], a[12:15], v[208:211], v56, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[0:3], v[200:203], v57, v44 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[0:3], v[204:207], v57, v44 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[74:75], v39, s[36:39], 0 offen
		buffer_load_dword v42, v40, s[40:43], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[8:11], v[220:223], v57, v44 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[8:11], v[216:219], v57, v44 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[84:87], a[4:7], v[200:203], v57, v44 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], a[4:7], v[204:207], v57, v44 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[92:95], a[12:15], v[220:223], v57, v44 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[84:87], a[12:15], v[216:219], v57, v44 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[16:19], v[232:235], v57, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[16:19], v[236:239], v57, v45 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v57, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v57, v45 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[84:87], a[20:23], v[232:235], v57, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[92:95], a[20:23], v[236:239], v57, v45 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[28:31], a[104:107], v57, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v57, v45 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[16:19], v[224:227], v56, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[16:19], v[228:231], v56, v45 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[24:27], v[244:247], v56, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[24:27], v[240:243], v56, v45 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[68:71], a[20:23], v[224:227], v56, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[76:79], a[20:23], v[228:231], v56, v45 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v56, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v56, v45 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v56, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v56, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v56, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v56, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v56, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v56, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v56, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v56, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v57, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v57, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v57, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v57, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v57, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v57, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v57, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v57, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v57, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v57, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v57, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v57, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v57, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v57, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v57, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v57, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v56, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v56, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v56, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v56, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v56, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v56, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v56, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v56, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[0:3], v50
		ds_read_b128 a[4:7], v50 offset:64
		ds_read_b128 a[8:11], v50 offset:256
		ds_read_b128 a[12:15], v50 offset:320
		ds_read_b128 a[16:19], v50 offset:512
		ds_read_b128 a[20:23], v50 offset:576
		ds_read_b128 a[24:27], v50 offset:768
		ds_read_b128 a[28:31], v50 offset:832
		ds_read_b128 a[32:35], v50 offset:16896
		ds_read_b128 a[36:39], v50 offset:16960
		ds_read_b128 a[40:43], v50 offset:17152
		ds_read_b128 a[44:47], v50 offset:17216
		ds_read_b128 a[48:51], v50 offset:17408
		ds_read_b128 a[52:55], v50 offset:17472
		ds_read_b128 a[56:59], v50 offset:17664
		ds_read_b128 a[60:63], v50 offset:17728
		ds_read_b128 a[64:67], v51 offset:1984
		ds_read_b128 a[68:71], v51 offset:2048
		ds_read_b128 a[72:75], v51 offset:2240
		ds_read_b128 a[76:79], v51 offset:2304
		ds_read_b128 a[80:83], v51 offset:2496
		ds_read_b128 a[84:87], v51 offset:2560
		ds_read_b128 a[88:91], v51 offset:2752
		ds_read_b128 a[92:95], v51 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v53, v[252:253] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v48, v43 offset:5952
		s_add_i32 m0, s21, 0x1cd60
		s_add_i32 s18, s18, s15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[56:57], v49 offset:3904
		ds_read_b64_tr_b8 v[58:59], v49 offset:4032
		ds_read_b64_tr_b8 v[44:45], v21 offset:5952
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1dde0
		s_add_i32 s16, s16, s14
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1fee0
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		buffer_load_dword v35, v34, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v44, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v44, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v44, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v44, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v44, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v44, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v45, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v45, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v45, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v45, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[92:95], a[4:7], v[76:79], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], a[12:15], v[92:95], v45, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v45, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v45, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v45, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v45, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v45, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[92:95], a[20:23], v[108:111], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], a[28:31], v[124:127], v45, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v45, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v44, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v44, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v44, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v44, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v44, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v44, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v44, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v44, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v44, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v44, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v44, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v44, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v45, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v45, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v45, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v45, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], a[36:39], v[140:143], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], a[44:47], v[156:159], v45, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v45, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v45, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v45, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v45, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v45, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], a[52:55], v[172:175], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], a[60:63], v[188:191], v45, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v45, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v44, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v44, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v44, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v44, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v44, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v44, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[24:27], v51 offset:35712
		ds_read_b128 a[64:67], v51 offset:35776
		ds_read_b128 v[28:31], v51 offset:35968
		ds_read_b128 v[36:39], v51 offset:36032
		ds_read_b128 v[44:47], v51 offset:36224
		ds_read_b128 v[60:63], v51 offset:36288
		ds_read_b128 v[68:71], v51 offset:36480
		ds_read_b128 v[252:255], v51 offset:36544
		ds_write_b32 v48, v65 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v17
		v_lshl_add_u32 v2, v12, 4, v2
		v_lshl_add_u32 v2, v15, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v21 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], a[0:3], v[192:195], v8, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], a[0:3], v[196:199], v8, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], a[8:11], v[212:215], v8, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[8:11], v[208:211], v8, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], a[4:7], v[192:195], v8, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], a[4:7], v[196:199], v8, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], a[12:15], v[212:215], v8, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[64:67], a[12:15], v[208:211], v8, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], a[0:3], v[200:203], v9, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], a[0:3], v[204:207], v9, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], a[8:11], v[220:223], v9, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], a[8:11], v[216:219], v9, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], a[4:7], v[200:203], v9, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[252:255], a[4:7], v[204:207], v9, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[252:255], a[12:15], v[220:223], v9, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[60:63], a[12:15], v[216:219], v9, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], a[16:19], v[232:235], v9, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], a[16:19], v[236:239], v9, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[24:27], a[104:107], v9, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], a[24:27], a[100:103], v9, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[60:63], a[20:23], v[232:235], v9, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[252:255], a[20:23], v[236:239], v9, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v9, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[60:63], a[28:31], a[100:103], v9, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], a[16:19], v[224:227], v8, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[16:19], v[228:231], v8, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], a[24:27], v[244:247], v8, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], a[24:27], v[240:243], v8, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[20:23], v[224:227], v8, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], a[20:23], v[228:231], v8, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[36:39], a[28:31], v[244:247], v8, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[28:31], v[240:243], v8, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[32:35], a[108:111], v8, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], a[32:35], a[112:115], v8, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], a[40:43], a[128:131], v8, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[40:43], a[124:127], v8, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[36:39], a[108:111], v8, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[36:39], a[112:115], v8, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[44:47], a[128:131], v8, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[44:47], a[124:127], v8, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[32:35], a[116:119], v9, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], a[32:35], a[120:123], v9, v58 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[40:43], a[136:139], v9, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[40:43], a[132:135], v9, v58 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[60:63], a[36:39], a[116:119], v9, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v9, v58 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v9, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[44:47], a[132:135], v9, v58 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[48:51], a[148:151], v9, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[48:51], a[152:155], v9, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[56:59], a[168:171], v9, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[56:59], a[164:167], v9, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[52:55], a[148:151], v9, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v9, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v9, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[60:63], a[164:167], v9, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[48:51], a[140:143], v8, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], a[48:51], a[144:147], v8, v59 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], a[56:59], a[160:163], v8, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[56:59], a[156:159], v8, v59 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[52:55], a[140:143], v8, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[52:55], a[144:147], v8, v59 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[60:63], a[160:163], v8, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[60:63], a[156:159], v8, v59 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v50 offset:33760
		ds_read_b128 a[0:3], v50 offset:33824
		ds_read_b128 a[4:7], v50 offset:34016
		ds_read_b128 a[8:11], v50 offset:34080
		ds_read_b128 a[12:15], v50 offset:34272
		ds_read_b128 a[16:19], v50 offset:34336
		ds_read_b128 a[20:23], v50 offset:34528
		ds_read_b128 a[24:27], v50 offset:34592
		ds_read_b128 a[28:31], v50 offset:50656
		ds_read_b128 a[32:35], v50 offset:50720
		ds_read_b128 a[36:39], v50 offset:50912
		ds_read_b128 a[40:43], v50 offset:50976
		ds_read_b128 a[44:47], v50 offset:51168
		ds_read_b128 a[48:51], v50 offset:51232
		ds_read_b128 a[52:55], v50 offset:51424
		ds_read_b128 a[56:59], v50 offset:51488
		ds_read_b128 v[28:31], v51 offset:18848
		ds_read_b128 v[36:39], v51 offset:18912
		ds_read_b128 v[44:47], v51 offset:19104
		ds_read_b128 v[56:59], v51 offset:19168
		ds_read_b128 v[60:63], v51 offset:19360
		ds_read_b128 v[64:67], v51 offset:19424
		ds_read_b128 v[68:71], v51 offset:19616
		ds_read_b128 v[252:255], v51 offset:19680
		ds_write_b64 v53, v[74:75] offset:3904
		ds_write_b32 v48, v42 offset:5952
		v_lshlrev_b32_e32 v8, 12, v19
		v_add3_u32 v2, v2, v8, v54
		v_lshlrev_b32_e32 v8, 7, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v49 offset:3904
		ds_read_b64_tr_b8 v[16:17], v49 offset:4032
		ds_read_b64_tr_b8 v[32:33], v21 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[28:31], v[24:27], v[248:251], v32, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[24:27], a[96:99], v32, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[44:47], a[4:7], v[84:87], v32, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], a[4:7], v[80:83], v32, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[0:3], v[248:251], v32, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[56:59], a[0:3], a[96:99], v32, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[56:59], a[8:11], v[84:87], v32, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[36:39], a[8:11], v[80:83], v32, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[60:63], v[24:27], v[4:7], v33, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[68:71], v[24:27], v[76:79], v33, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[68:71], a[4:7], v[92:95], v33, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[60:63], a[4:7], v[88:91], v33, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], a[0:3], v[4:7], v33, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[252:255], a[0:3], v[76:79], v33, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[252:255], a[8:11], v[92:95], v33, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], a[8:11], v[88:91], v33, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[60:63], a[12:15], v[104:107], v33, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], a[12:15], v[108:111], v33, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], a[20:23], v[124:127], v33, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[60:63], a[20:23], v[120:123], v33, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], a[16:19], v[104:107], v33, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[252:255], a[16:19], v[108:111], v33, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], a[24:27], v[124:127], v33, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], a[24:27], v[120:123], v33, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[28:31], a[12:15], v[96:99], v32, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[44:47], a[12:15], v[100:103], v32, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[44:47], a[20:23], v[116:119], v32, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[28:31], a[20:23], v[112:115], v32, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[36:39], a[16:19], v[96:99], v32, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[56:59], a[16:19], v[100:103], v32, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[56:59], a[24:27], v[116:119], v32, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[36:39], a[24:27], v[112:115], v32, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], a[28:31], v[128:131], v32, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], a[28:31], v[132:135], v32, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], a[36:39], v[148:151], v32, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], a[36:39], v[144:147], v32, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], a[32:35], v[128:131], v32, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[56:59], a[32:35], v[132:135], v32, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[56:59], a[40:43], v[148:151], v32, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], a[40:43], v[144:147], v32, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[60:63], a[28:31], v[136:139], v33, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], a[28:31], v[140:143], v33, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[68:71], a[36:39], v[156:159], v33, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[60:63], a[36:39], v[152:155], v33, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[64:67], a[32:35], v[136:139], v33, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], a[32:35], v[140:143], v33, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], a[40:43], v[156:159], v33, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[64:67], a[40:43], v[152:155], v33, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[60:63], a[44:47], v[168:171], v33, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[68:71], a[44:47], v[172:175], v33, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[68:71], a[52:55], v[188:191], v33, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], a[52:55], v[184:187], v33, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[64:67], a[48:51], v[168:171], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[252:255], a[48:51], v[172:175], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[252:255], a[56:59], v[188:191], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[64:67], a[56:59], v[184:187], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], a[44:47], v[160:163], v32, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[44:47], a[44:47], v[164:167], v32, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], a[52:55], v[180:183], v32, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], a[52:55], v[176:179], v32, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], a[48:51], v[160:163], v32, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[56:59], a[48:51], v[164:167], v32, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], a[56:59], v[180:183], v32, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], a[56:59], v[176:179], v32, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v51 offset:52576
		ds_read_b128 v[36:39], v51 offset:52640
		ds_read_b128 v[40:43], v51 offset:52832
		ds_read_b128 v[44:47], v51 offset:52896
		ds_read_b128 v[52:55], v51 offset:53088
		ds_read_b128 v[56:59], v51 offset:53152
		ds_read_b128 v[60:63], v51 offset:53344
		ds_read_b128 v[64:67], v51 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v48, v35 offset:5952
		v_cvt_pk_bf16_f32 v32, v248, v249
		v_cvt_pk_bf16_f32 v33, v250, v251
		v_accvgpr_read_b32 v9, a96
		v_accvgpr_read_b32 v11, a97
		v_cvt_pk_bf16_f32 v48, v9, v11
		v_accvgpr_read_b32 v9, a98
		v_accvgpr_read_b32 v11, a99
		v_cvt_pk_bf16_f32 v49, v9, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[68:69], v21 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v72, v4, v5
		v_cvt_pk_bf16_f32 v73, v6, v7
		v_cvt_pk_bf16_f32 v4, v76, v77
		v_cvt_pk_bf16_f32 v5, v78, v79
		v_cvt_pk_bf16_f32 v34, v80, v81
		v_cvt_pk_bf16_f32 v35, v82, v83
		v_cvt_pk_bf16_f32 v50, v84, v85
		v_cvt_pk_bf16_f32 v51, v86, v87
		v_cvt_pk_bf16_f32 v74, v88, v89
		v_cvt_pk_bf16_f32 v75, v90, v91
		v_cvt_pk_bf16_f32 v6, v92, v93
		v_cvt_pk_bf16_f32 v7, v94, v95
		v_cvt_pk_bf16_f32 v76, v96, v97
		v_cvt_pk_bf16_f32 v77, v98, v99
		v_cvt_pk_bf16_f32 v80, v100, v101
		v_cvt_pk_bf16_f32 v81, v102, v103
		v_cvt_pk_bf16_f32 v84, v104, v105
		v_cvt_pk_bf16_f32 v85, v106, v107
		v_cvt_pk_bf16_f32 v88, v108, v109
		v_cvt_pk_bf16_f32 v89, v110, v111
		v_cvt_pk_bf16_f32 v78, v112, v113
		v_cvt_pk_bf16_f32 v79, v114, v115
		v_cvt_pk_bf16_f32 v82, v116, v117
		v_cvt_pk_bf16_f32 v83, v118, v119
		v_cvt_pk_bf16_f32 v86, v120, v121
		v_cvt_pk_bf16_f32 v87, v122, v123
		v_cvt_pk_bf16_f32 v90, v124, v125
		v_cvt_pk_bf16_f32 v91, v126, v127
		v_cvt_pk_bf16_f32 v92, v128, v129
		v_cvt_pk_bf16_f32 v93, v130, v131
		v_cvt_pk_bf16_f32 v96, v132, v133
		v_cvt_pk_bf16_f32 v97, v134, v135
		v_cvt_pk_bf16_f32 v100, v136, v137
		v_cvt_pk_bf16_f32 v101, v138, v139
		v_cvt_pk_bf16_f32 v104, v140, v141
		v_cvt_pk_bf16_f32 v105, v142, v143
		v_cvt_pk_bf16_f32 v94, v144, v145
		v_cvt_pk_bf16_f32 v95, v146, v147
		v_cvt_pk_bf16_f32 v98, v148, v149
		v_cvt_pk_bf16_f32 v99, v150, v151
		v_cvt_pk_bf16_f32 v102, v152, v153
		v_cvt_pk_bf16_f32 v103, v154, v155
		v_cvt_pk_bf16_f32 v106, v156, v157
		v_cvt_pk_bf16_f32 v107, v158, v159
		v_cvt_pk_bf16_f32 v108, v160, v161
		v_cvt_pk_bf16_f32 v109, v162, v163
		v_cvt_pk_bf16_f32 v112, v164, v165
		v_cvt_pk_bf16_f32 v113, v166, v167
		v_cvt_pk_bf16_f32 v116, v168, v169
		v_cvt_pk_bf16_f32 v117, v170, v171
		v_cvt_pk_bf16_f32 v120, v172, v173
		v_cvt_pk_bf16_f32 v121, v174, v175
		v_cvt_pk_bf16_f32 v110, v176, v177
		v_cvt_pk_bf16_f32 v111, v178, v179
		v_cvt_pk_bf16_f32 v114, v180, v181
		v_cvt_pk_bf16_f32 v115, v182, v183
		v_cvt_pk_bf16_f32 v118, v184, v185
		v_cvt_pk_bf16_f32 v119, v186, v187
		v_cvt_pk_bf16_f32 v122, v188, v189
		v_cvt_pk_bf16_f32 v123, v190, v191
		ds_write_b128 v0, v[32:35]
		ds_write_b128 v0, v[48:51] offset:4096
		ds_write_b128 v0, v[72:75] offset:8192
		ds_write_b128 v0, v[4:7] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v4, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[48:51], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[72:73], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[74:75], v[48:49]
		v_mov_b64_e32 v[124:125], v[34:35]
		v_mov_b64_e32 v[126:127], v[50:51]
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[48:51], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[128:129], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[130:131], v[48:49]
		v_mov_b64_e32 v[132:133], v[34:35]
		v_mov_b64_e32 v[134:135], v[50:51]
		s_barrier
		ds_write_b128 v0, v[76:79]
		ds_write_b128 v0, v[80:83] offset:4096
		ds_write_b128 v0, v[84:87] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		v_lshlrev_b32_e32 v5, 2, v3
		v_add_u32_e32 v6, 16, v13
		v_lshlrev_b32_e32 v7, 1, v10
		v_xor_b32_e32 v6, v6, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[48:51], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[76:77], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[78:79], v[48:49]
		v_mov_b64_e32 v[80:81], v[34:35]
		v_mov_b64_e32 v[82:83], v[50:51]
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[48:51], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[84:85], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[86:87], v[48:49]
		v_mov_b64_e32 v[88:89], v[34:35]
		v_mov_b64_e32 v[90:91], v[50:51]
		s_barrier
		ds_write_b128 v0, v[92:95]
		ds_write_b128 v0, v[96:99] offset:4096
		ds_write_b128 v0, v[100:103] offset:8192
		ds_write_b128 v0, v[104:107] offset:12288
		v_xor_b32_e32 v6, v5, v6
		v_xor_b32_e32 v6, v4, v6
		v_add_u32_e32 v9, 32, v13
		v_xor_b32_e32 v9, v9, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[48:51], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[92:93], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[94:95], v[48:49]
		v_mov_b64_e32 v[96:97], v[34:35]
		v_mov_b64_e32 v[98:99], v[50:51]
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[48:51], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[100:101], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[102:103], v[48:49]
		v_mov_b64_e32 v[104:105], v[34:35]
		v_mov_b64_e32 v[106:107], v[50:51]
		s_barrier
		ds_write_b128 v0, v[108:111]
		ds_write_b128 v0, v[112:115] offset:4096
		ds_write_b128 v0, v[116:119] offset:8192
		ds_write_b128 v0, v[120:123] offset:12288
		v_xor_b32_e32 v9, v5, v9
		v_xor_b32_e32 v9, v4, v9
		v_add_u32_e32 v11, 48, v13
		v_xor_b32_e32 v11, v11, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[48:51], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[108:109], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[110:111], v[48:49]
		v_mov_b64_e32 v[112:113], v[34:35]
		v_mov_b64_e32 v[114:115], v[50:51]
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[48:51], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[116:117], v[32:33]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[118:119], v[48:49]
		v_mov_b64_e32 v[120:121], v[34:35]
		v_mov_b64_e32 v[122:123], v[50:51]
		s_barrier
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v12, s0, v1, v3
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_mul_lo_u32 v19, s17, v13
		v_lshlrev_b32_e32 v19, 1, v19
		v_add3_u32 v12, v12, v10, v19
		v_add3_u32 v12, v12, v18, v8
		v_add3_u32 v12, v12, v20, v22
		buffer_store_dwordx4 v[72:75], v12, s[8:11], 0 offen
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v12, s0, v6
		v_add3_u32 v12, v12, v18, v8
		v_add3_u32 v12, v12, v20, v22
		buffer_store_dwordx4 v[128:131], v12, s[8:11], 0 offen
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v12, s0, v9
		v_add3_u32 v12, v12, v18, v8
		v_add3_u32 v12, v12, v20, v22
		buffer_store_dwordx4 v[124:127], v12, s[8:11], 0 offen
		v_xor_b32_e32 v11, v5, v11
		v_xor_b32_e32 v11, v4, v11
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v12, s0, v11
		v_add3_u32 v12, v12, v18, v8
		v_add3_u32 v12, v12, v20, v22
		buffer_store_dwordx4 v[132:135], v12, s[8:11], 0 offen
		v_add_u32_e32 v12, 64, v13
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v5, v12
		v_xor_b32_e32 v12, v4, v12
		v_mul_lo_u32 v12, s17, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add_u32_e32 v21, s0, v12
		v_add3_u32 v21, v21, v18, v8
		v_add3_u32 v21, v21, v20, v22
		buffer_store_dwordx4 v[76:79], v21, s[8:11], 0 offen
		v_add_u32_e32 v21, 0x50, v13
		v_xor_b32_e32 v21, v21, v7
		v_xor_b32_e32 v21, v5, v21
		v_xor_b32_e32 v21, v4, v21
		v_mul_lo_u32 v21, s17, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v23, s0, v21
		v_add3_u32 v23, v23, v18, v8
		v_add3_u32 v23, v23, v20, v22
		buffer_store_dwordx4 v[84:87], v23, s[8:11], 0 offen
		v_add_u32_e32 v23, 0x60, v13
		v_xor_b32_e32 v23, v23, v7
		v_xor_b32_e32 v23, v5, v23
		v_xor_b32_e32 v23, v4, v23
		v_mul_lo_u32 v23, s17, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_add_u32_e32 v32, s0, v23
		v_add3_u32 v32, v32, v18, v8
		v_add3_u32 v32, v32, v20, v22
		buffer_store_dwordx4 v[80:83], v32, s[8:11], 0 offen
		v_add_u32_e32 v32, 0x70, v13
		v_xor_b32_e32 v32, v32, v7
		v_xor_b32_e32 v32, v5, v32
		v_xor_b32_e32 v32, v4, v32
		v_mul_lo_u32 v32, s17, v32
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v33, s0, v32
		v_add3_u32 v33, v33, v18, v8
		v_add3_u32 v33, v33, v20, v22
		buffer_store_dwordx4 v[88:91], v33, s[8:11], 0 offen
		v_add_u32_e32 v33, 0x80, v13
		v_xor_b32_e32 v33, v33, v7
		v_xor_b32_e32 v33, v5, v33
		v_xor_b32_e32 v33, v4, v33
		v_mul_lo_u32 v33, s17, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v34, s0, v33
		v_add3_u32 v34, v34, v18, v8
		v_add3_u32 v34, v34, v20, v22
		buffer_store_dwordx4 v[92:95], v34, s[8:11], 0 offen
		v_add_u32_e32 v34, 0x90, v13
		v_xor_b32_e32 v34, v34, v7
		v_xor_b32_e32 v34, v5, v34
		v_xor_b32_e32 v34, v4, v34
		v_mul_lo_u32 v34, s17, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_add_u32_e32 v35, s0, v34
		v_add3_u32 v35, v35, v18, v8
		v_add3_u32 v35, v35, v20, v22
		buffer_store_dwordx4 v[100:103], v35, s[8:11], 0 offen
		v_add_u32_e32 v35, 0xa0, v13
		v_xor_b32_e32 v35, v35, v7
		v_xor_b32_e32 v35, v5, v35
		v_xor_b32_e32 v35, v4, v35
		v_mul_lo_u32 v35, s17, v35
		v_lshlrev_b32_e32 v35, 1, v35
		v_add_u32_e32 v48, s0, v35
		v_add3_u32 v48, v48, v18, v8
		v_add3_u32 v48, v48, v20, v22
		buffer_store_dwordx4 v[96:99], v48, s[8:11], 0 offen
		v_add_u32_e32 v48, 0xb0, v13
		v_xor_b32_e32 v48, v48, v7
		v_xor_b32_e32 v48, v5, v48
		v_xor_b32_e32 v48, v4, v48
		v_mul_lo_u32 v48, s17, v48
		v_lshlrev_b32_e32 v48, 1, v48
		v_add_u32_e32 v49, s0, v48
		v_add3_u32 v49, v49, v18, v8
		v_add3_u32 v49, v49, v20, v22
		buffer_store_dwordx4 v[104:107], v49, s[8:11], 0 offen
		v_add_u32_e32 v49, 0xc0, v13
		v_xor_b32_e32 v49, v49, v7
		v_xor_b32_e32 v49, v5, v49
		v_xor_b32_e32 v49, v4, v49
		v_mul_lo_u32 v49, s17, v49
		v_lshlrev_b32_e32 v49, 1, v49
		v_add_u32_e32 v50, s0, v49
		v_add3_u32 v50, v50, v18, v8
		v_add3_u32 v50, v50, v20, v22
		buffer_store_dwordx4 v[108:111], v50, s[8:11], 0 offen
		v_add_u32_e32 v50, 0xd0, v13
		v_xor_b32_e32 v50, v50, v7
		v_xor_b32_e32 v50, v5, v50
		v_xor_b32_e32 v50, v4, v50
		v_mul_lo_u32 v50, s17, v50
		v_lshlrev_b32_e32 v50, 1, v50
		v_add_u32_e32 v51, s0, v50
		v_add3_u32 v51, v51, v18, v8
		v_add3_u32 v51, v51, v20, v22
		buffer_store_dwordx4 v[116:119], v51, s[8:11], 0 offen
		v_add_u32_e32 v51, 0xe0, v13
		v_xor_b32_e32 v51, v51, v7
		v_xor_b32_e32 v51, v5, v51
		v_xor_b32_e32 v51, v4, v51
		v_mul_lo_u32 v51, s17, v51
		v_lshlrev_b32_e32 v51, 1, v51
		v_add_u32_e32 v70, s0, v51
		v_add3_u32 v70, v70, v18, v8
		v_add3_u32 v70, v70, v20, v22
		buffer_store_dwordx4 v[112:115], v70, s[8:11], 0 offen
		v_add_u32_e32 v13, 0xf0, v13
		v_xor_b32_e32 v7, v13, v7
		v_xor_b32_e32 v5, v5, v7
		v_xor_b32_e32 v4, v4, v5
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v5, s0, v4
		v_add3_u32 v5, v5, v18, v8
		v_add3_u32 v5, v5, v20, v22
		buffer_store_dwordx4 v[120:123], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[24:27], v[192:195], v68, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[24:27], v[196:199], v68, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], a[4:7], v[212:215], v68, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], a[4:7], v[208:211], v68, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[36:39], a[0:3], v[192:195], v68, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], a[0:3], v[196:199], v68, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], a[8:11], v[212:215], v68, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], a[8:11], v[208:211], v68, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], v[24:27], v[200:203], v69, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], v[24:27], v[204:207], v69, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[60:63], a[4:7], v[220:223], v69, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[4:7], v[216:219], v69, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], a[0:3], v[200:203], v69, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], a[0:3], v[204:207], v69, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], a[8:11], v[220:223], v69, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], a[8:11], v[216:219], v69, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], a[12:15], v[232:235], v69, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[60:63], a[12:15], v[236:239], v69, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[60:63], a[20:23], a[104:107], v69, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[52:55], a[20:23], a[100:103], v69, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[16:19], v[232:235], v69, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], a[16:19], v[236:239], v69, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[64:67], a[24:27], a[104:107], v69, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[56:59], a[24:27], a[100:103], v69, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], a[12:15], v[224:227], v68, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], a[12:15], v[228:231], v68, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[20:23], v[244:247], v68, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], a[20:23], v[240:243], v68, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], a[16:19], v[224:227], v68, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], a[16:19], v[228:231], v68, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[44:47], a[24:27], v[244:247], v68, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[36:39], a[24:27], v[240:243], v68, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[28:31], a[108:111], v68, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[28:31], a[112:115], v68, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[36:39], a[128:131], v68, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[36:39], a[124:127], v68, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[32:35], a[108:111], v68, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], a[32:35], a[112:115], v68, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], a[40:43], a[128:131], v68, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], a[40:43], a[124:127], v68, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[28:31], a[116:119], v69, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], a[28:31], a[120:123], v69, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], a[36:39], a[136:139], v69, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[36:39], a[132:135], v69, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[32:35], a[116:119], v69, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[32:35], a[120:123], v69, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[40:43], a[136:139], v69, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[40:43], a[132:135], v69, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[44:47], a[148:151], v69, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], a[44:47], a[152:155], v69, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], a[52:55], a[168:171], v69, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[52:55], a[164:167], v69, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[48:51], a[148:151], v69, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[48:51], a[152:155], v69, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[56:59], a[168:171], v69, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[56:59], a[164:167], v69, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[44:47], a[140:143], v68, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[44:47], a[144:147], v68, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[52:55], a[160:163], v68, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[52:55], a[156:159], v68, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[36:39], a[48:51], a[140:143], v68, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], a[48:51], a[144:147], v68, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[44:47], a[56:59], a[160:163], v68, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], a[56:59], a[156:159], v68, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v24, v192, v193
		v_cvt_pk_bf16_f32 v25, v194, v195
		v_cvt_pk_bf16_f32 v28, v196, v197
		v_cvt_pk_bf16_f32 v29, v198, v199
		v_cvt_pk_bf16_f32 v36, v200, v201
		v_cvt_pk_bf16_f32 v37, v202, v203
		v_cvt_pk_bf16_f32 v40, v204, v205
		v_cvt_pk_bf16_f32 v41, v206, v207
		v_cvt_pk_bf16_f32 v26, v208, v209
		v_cvt_pk_bf16_f32 v27, v210, v211
		v_cvt_pk_bf16_f32 v30, v212, v213
		v_cvt_pk_bf16_f32 v31, v214, v215
		v_cvt_pk_bf16_f32 v38, v216, v217
		v_cvt_pk_bf16_f32 v39, v218, v219
		v_cvt_pk_bf16_f32 v42, v220, v221
		v_cvt_pk_bf16_f32 v43, v222, v223
		v_cvt_pk_bf16_f32 v44, v224, v225
		v_cvt_pk_bf16_f32 v45, v226, v227
		v_cvt_pk_bf16_f32 v52, v228, v229
		v_cvt_pk_bf16_f32 v53, v230, v231
		v_cvt_pk_bf16_f32 v56, v232, v233
		v_cvt_pk_bf16_f32 v57, v234, v235
		v_cvt_pk_bf16_f32 v60, v236, v237
		v_cvt_pk_bf16_f32 v61, v238, v239
		v_cvt_pk_bf16_f32 v46, v240, v241
		v_cvt_pk_bf16_f32 v47, v242, v243
		v_cvt_pk_bf16_f32 v54, v244, v245
		v_cvt_pk_bf16_f32 v55, v246, v247
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v7, a101
		v_cvt_pk_bf16_f32 v58, v5, v7
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v7, a103
		v_cvt_pk_bf16_f32 v59, v5, v7
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v7, a105
		v_cvt_pk_bf16_f32 v62, v5, v7
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v7, a107
		v_cvt_pk_bf16_f32 v63, v5, v7
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v7, a109
		v_cvt_pk_bf16_f32 v64, v5, v7
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v7, a111
		v_cvt_pk_bf16_f32 v65, v5, v7
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v7, a113
		v_cvt_pk_bf16_f32 v68, v5, v7
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v7, a115
		v_cvt_pk_bf16_f32 v69, v5, v7
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v7, a117
		v_cvt_pk_bf16_f32 v72, v5, v7
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v7, a119
		v_cvt_pk_bf16_f32 v73, v5, v7
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v7, a121
		v_cvt_pk_bf16_f32 v76, v5, v7
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v7, a123
		v_cvt_pk_bf16_f32 v77, v5, v7
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v7, a125
		v_cvt_pk_bf16_f32 v66, v5, v7
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v7, a127
		v_cvt_pk_bf16_f32 v67, v5, v7
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v7, a129
		v_cvt_pk_bf16_f32 v70, v5, v7
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v7, a131
		v_cvt_pk_bf16_f32 v71, v5, v7
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v7, a133
		v_cvt_pk_bf16_f32 v74, v5, v7
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v7, a135
		v_cvt_pk_bf16_f32 v75, v5, v7
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v7, a137
		v_cvt_pk_bf16_f32 v78, v5, v7
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v7, a139
		v_cvt_pk_bf16_f32 v79, v5, v7
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v7, a141
		v_cvt_pk_bf16_f32 v80, v5, v7
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v7, a143
		v_cvt_pk_bf16_f32 v81, v5, v7
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v7, a145
		v_cvt_pk_bf16_f32 v84, v5, v7
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v7, a147
		v_cvt_pk_bf16_f32 v85, v5, v7
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v7, a149
		v_cvt_pk_bf16_f32 v88, v5, v7
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v7, a151
		v_cvt_pk_bf16_f32 v89, v5, v7
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v7, a153
		v_cvt_pk_bf16_f32 v92, v5, v7
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v7, a155
		v_cvt_pk_bf16_f32 v93, v5, v7
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v7, a157
		v_cvt_pk_bf16_f32 v82, v5, v7
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v7, a159
		v_cvt_pk_bf16_f32 v83, v5, v7
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v7, a161
		v_cvt_pk_bf16_f32 v86, v5, v7
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v7, a163
		v_cvt_pk_bf16_f32 v87, v5, v7
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v7, a165
		v_cvt_pk_bf16_f32 v90, v5, v7
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v7, a167
		v_cvt_pk_bf16_f32 v91, v5, v7
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v7, a169
		v_cvt_pk_bf16_f32 v94, v5, v7
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v7, a171
		v_cvt_pk_bf16_f32 v95, v5, v7
		ds_write_b128 v0, v[24:27]
		ds_write_b128 v0, v[28:31] offset:4096
		ds_write_b128 v0, v[36:39] offset:8192
		ds_write_b128 v0, v[40:43] offset:12288
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v10, v19
		v_add3_u32 v1, v1, v18, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[36:37], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[38:39], v[28:29]
		v_mov_b64_e32 v[40:41], v[26:27]
		v_mov_b64_e32 v[42:43], v[30:31]
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[96:97], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[98:99], v[28:29]
		v_mov_b64_e32 v[100:101], v[26:27]
		v_mov_b64_e32 v[102:103], v[30:31]
		s_barrier
		ds_write_b128 v0, v[44:47]
		ds_write_b128 v0, v[52:55] offset:4096
		ds_write_b128 v0, v[56:59] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_add3_u32 v1, v1, v20, v22
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v18, v8, v20
		v_add_u32_e32 v1, v1, v22
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[36:37], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[38:39], v[28:29]
		v_mov_b64_e32 v[44:45], v[26:27]
		v_mov_b64_e32 v[46:47], v[30:31]
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[52:53], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[54:55], v[28:29]
		v_mov_b64_e32 v[56:57], v[26:27]
		v_mov_b64_e32 v[58:59], v[30:31]
		s_barrier
		ds_write_b128 v0, v[64:67]
		ds_write_b128 v0, v[68:71] offset:4096
		ds_write_b128 v0, v[72:75] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		v_add3_u32 v3, v6, v1, s0
		buffer_store_dwordx4 v[96:99], v3, s[8:11], 0 offen
		v_add3_u32 v3, v9, v1, s0
		buffer_store_dwordx4 v[40:43], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[40:41], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[42:43], v[28:29]
		v_mov_b64_e32 v[60:61], v[26:27]
		v_mov_b64_e32 v[62:63], v[30:31]
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[64:65], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[66:67], v[28:29]
		v_mov_b64_e32 v[68:69], v[26:27]
		v_mov_b64_e32 v[70:71], v[30:31]
		s_barrier
		ds_write_b128 v0, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		v_add3_u32 v0, v11, v1, s0
		buffer_store_dwordx4 v[100:103], v0, s[8:11], 0 offen
		v_add3_u32 v0, v18, v8, v20
		v_add_u32_e32 v0, v0, v22
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[72:73], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[74:75], v[28:29]
		v_mov_b64_e32 v[76:77], v[26:27]
		v_mov_b64_e32 v[78:79], v[30:31]
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[80:81], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[82:83], v[28:29]
		v_mov_b64_e32 v[84:85], v[26:27]
		v_mov_b64_e32 v[86:87], v[30:31]
		s_barrier
		v_add3_u32 v1, v12, v0, s0
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v21, v0, s0
		buffer_store_dwordx4 v[52:55], v1, s[8:11], 0 offen
		v_add3_u32 v0, v23, v0, s0
		buffer_store_dwordx4 v[44:47], v0, s[8:11], 0 offen
		v_add3_u32 v0, v18, v8, v20
		v_add_u32_e32 v0, v0, v22
		v_add3_u32 v1, v32, v0, s0
		buffer_store_dwordx4 v[56:59], v1, s[8:11], 0 offen
		v_add3_u32 v1, v33, v0, s0
		buffer_store_dwordx4 v[40:43], v1, s[8:11], 0 offen
		v_add3_u32 v0, v34, v0, s0
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		v_add3_u32 v0, v18, v8, v20
		v_add_u32_e32 v0, v0, v22
		v_add3_u32 v1, v35, v0, s0
		buffer_store_dwordx4 v[60:63], v1, s[8:11], 0 offen
		v_add3_u32 v1, v48, v0, s0
		buffer_store_dwordx4 v[68:71], v1, s[8:11], 0 offen
		v_add3_u32 v0, v49, v0, s0
		buffer_store_dwordx4 v[72:75], v0, s[8:11], 0 offen
		v_add3_u32 v0, v18, v8, v20
		v_add_u32_e32 v0, v0, v22
		v_add3_u32 v1, v50, v0, s0
		buffer_store_dwordx4 v[80:83], v1, s[8:11], 0 offen
		v_add3_u32 v1, v51, v0, s0
		buffer_store_dwordx4 v[76:79], v1, s[8:11], 0 offen
		v_add3_u32 v0, v4, v0, s0
		buffer_store_dwordx4 v[84:87], v0, s[8:11], 0 offen
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
    .group_segment_fixed_size: 138048
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
    wave.regalloc.iterations: 99
    wave.regalloc.agpr.dwords: 392
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
