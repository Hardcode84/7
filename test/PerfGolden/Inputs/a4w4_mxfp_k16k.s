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
		v_and_b32_e32 v9, 1, v8
		v_mul_lo_u32 v10, s14, v9
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v5, v5, v7, v10
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v11, 1, v11
		v_mul_lo_u32 v12, s14, v11
		v_lshlrev_b32_e32 v12, 4, v12
		v_and_b32_e32 v13, 1, v0
		v_lshlrev_b32_e32 v14, 4, v13
		v_add3_u32 v5, v5, v12, v14
		v_lshrrev_b32_e32 v15, 2, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v16, 6, v15
		v_lshrrev_b32_e32 v17, 1, v0
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_add3_u32 v5, v5, v16, v18
		s_lshr_b32 s16, s16, 6
		s_mul_i32 s16, 0x420, s16
		s_mov_b32 m0, s16
		s_mul_i32 s21, s0, 0x100
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v19, s22, v2, v4
		v_add3_u32 v19, v19, v7, v10
		v_add3_u32 v19, v19, v12, v14
		v_add3_u32 v19, v19, v16, v18
		s_add_i32 m0, s16, 0x1080
		s_mul_i32 s21, s21, s15
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v20, v2, v4, v7
		v_add3_u32 v20, v20, v10, v12
		v_add3_u32 v20, v20, v14, v16
		s_add_i32 m0, s16, 0x2100
		v_add3_u32 v21, v18, v20, s28
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s16, 0x3180
		v_add3_u32 v22, v18, v20, s29
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s16, 0x4200
		v_add3_u32 v20, v18, v20, s30
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v23, v2, v4, v7
		v_add3_u32 v23, v23, v10, v12
		v_add3_u32 v23, v23, v14, v16
		s_add_i32 m0, s16, 0x5280
		v_add3_u32 v24, v18, v23, s31
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s16, 0x6300
		v_add3_u32 v25, v18, v23, s32
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s16, 0x7380
		v_add3_u32 v23, v18, v23, s14
		s_add_u32 s36, s4, s21
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v26, s15, v1
		v_lshlrev_b32_e32 v26, 1, v26
		v_mul_lo_u32 v27, s15, v3
		v_add_u32_e32 v28, v26, v27
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		v_mul_lo_u32 v29, s15, v6
		v_lshlrev_b32_e32 v29, 6, v29
		v_mul_lo_u32 v30, s15, v9
		v_lshlrev_b32_e32 v30, 5, v30
		v_add3_u32 v28, v28, v29, v30
		v_mul_lo_u32 v31, s15, v11
		v_lshlrev_b32_e32 v31, 4, v31
		v_add3_u32 v28, v28, v31, v14
		s_add_i32 m0, s16, 0x107c0
		v_add3_u32 v28, v28, v16, v18
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v32, v26, v27, v29
		v_add3_u32 v32, v32, v30, v31
		v_add3_u32 v32, v32, v14, v16
		s_add_i32 m0, s16, 0x11840
		v_add3_u32 v33, v18, v32, s33
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s16, 0x128c0
		v_add3_u32 v34, v18, v32, s34
		buffer_load_dwordx4 v34, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s16, 0x13940
		v_add3_u32 v32, v18, v32, s35
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v35, s18, v1
		v_lshlrev_b32_e32 v35, 2, v35
		v_mul_lo_u32 v36, s18, v3
		v_lshlrev_b32_e32 v36, 1, v36
		v_add3_u32 v37, s1, v35, v36
		v_mul_lo_u32 v38, s18, v6
		v_lshlrev_b32_e32 v39, 3, v13
		v_add3_u32 v37, v37, v38, v39
		v_lshlrev_b32_e32 v40, 7, v9
		v_lshlrev_b32_e32 v41, 6, v11
		v_add3_u32 v37, v37, v40, v41
		v_lshlrev_b32_e32 v42, 5, v15
		v_lshlrev_b32_e32 v43, 4, v17
		v_add3_u32 v37, v37, v42, v43
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx2 v[44:45], v37, s[40:43], 0 offen
		s_lshl_b32 s20, s0, 8
		v_mul_lo_u32 v46, s19, v1
		v_lshlrev_b32_e32 v46, 2, v46
		v_mul_lo_u32 v47, s19, v3
		v_lshlrev_b32_e32 v47, 1, v47
		v_add3_u32 v48, s20, v46, v47
		v_mul_lo_u32 v49, s19, v6
		v_lshlrev_b32_e32 v50, 2, v13
		v_add3_u32 v48, v48, v49, v50
		v_lshlrev_b32_e32 v51, 6, v9
		v_lshlrev_b32_e32 v52, 5, v11
		v_add3_u32 v48, v48, v51, v52
		v_lshlrev_b32_e32 v53, 4, v15
		v_lshlrev_b32_e32 v54, 3, v17
		v_add3_u32 v48, v48, v53, v54
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dword v55, v48, s[44:47], 0 offen
		s_lshl_b32 s48, s15, 7
		v_add3_u32 v56, s48, v26, v27
		v_add3_u32 v56, v56, v29, v30
		v_add3_u32 v56, v56, v31, v14
		s_add_i32 m0, s16, 0x18b80
		v_add3_u32 v56, v56, v16, v18
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v57, v26, v27, v29
		v_add3_u32 v57, v57, v30, v31
		v_add3_u32 v57, v57, v14, v16
		s_add_i32 m0, s16, 0x19c00
		v_add3_u32 v58, v18, v57, s49
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, s16, 0x1ac80
		v_add3_u32 v59, v18, v57, s50
		buffer_load_dwordx4 v59, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s16, 0x1bd00
		v_add3_u32 v57, v18, v57, s15
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_add_i32 s51, s20, 0x80
		v_add3_u32 v60, s51, v46, v47
		v_add3_u32 v60, v60, v49, v50
		v_add3_u32 v60, v60, v51, v52
		v_add3_u32 v60, v60, v53, v54
		buffer_load_dword v61, v60, s[44:47], 0 offen
		v_add_u32_e32 v62, 0x80, v2
		v_add_u32_e32 v62, v62, v4
		v_add3_u32 v62, v62, v7, v10
		v_add3_u32 v62, v62, v12, v14
		s_add_i32 m0, s16, 0x83e0
		v_add3_u32 v62, v62, v16, v18
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v63, s22, v2, v4
		v_add3_u32 v63, v63, v7, v10
		v_add3_u32 v63, v63, v12, v14
		s_add_i32 m0, s16, 0x9460
		v_add3_u32 v63, v63, v16, v18
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v64, s22, v2, v4
		v_add3_u32 v64, v64, v7, v10
		v_add3_u32 v64, v64, v12, v14
		s_add_i32 m0, s16, 0xa4e0
		v_add3_u32 v64, v64, v16, v18
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v65, s22, v2, v4
		v_add3_u32 v65, v65, v7, v10
		v_add3_u32 v65, v65, v12, v14
		s_add_i32 m0, s16, 0xb560
		v_add3_u32 v65, v65, v16, v18
		buffer_load_dwordx4 v65, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v66, s22, v2, v4
		v_add3_u32 v66, v66, v7, v10
		v_add3_u32 v66, v66, v12, v14
		s_add_i32 m0, s16, 0xc5e0
		v_add3_u32 v66, v66, v16, v18
		buffer_load_dwordx4 v66, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v67, s22, v2, v4
		v_add3_u32 v67, v67, v7, v10
		v_add3_u32 v67, v67, v12, v14
		s_add_i32 m0, s16, 0xd660
		v_add3_u32 v67, v67, v16, v18
		buffer_load_dwordx4 v67, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v68, s22, v2, v4
		v_add3_u32 v68, v68, v7, v10
		v_add3_u32 v68, v68, v12, v14
		s_add_i32 m0, s16, 0xe6e0
		v_add3_u32 v68, v68, v16, v18
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v4
		v_add3_u32 v2, v2, v7, v10
		v_add3_u32 v2, v2, v12, v14
		s_add_i32 m0, s16, 0xf760
		v_add3_u32 v2, v2, v16, v18
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v26
		v_add_u32_e32 v4, v4, v27
		v_add3_u32 v4, v4, v29, v30
		v_add3_u32 v4, v4, v31, v14
		s_add_i32 m0, s16, 0x149a0
		v_add3_u32 v4, v4, v16, v18
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v7, v26, v27, v29
		v_add3_u32 v7, v7, v30, v31
		v_add3_u32 v7, v7, v14, v16
		s_add_i32 m0, s16, 0x15a20
		v_add3_u32 v10, v18, v7, s14
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s16, 0x16aa0
		v_add3_u32 v12, v18, v7, s14
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s16, 0x17b20
		v_add3_u32 v7, v18, v7, s14
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_add3_u32 v35, s1, v35, v36
		v_add3_u32 v35, v35, v38, v39
		v_add3_u32 v35, v35, v40, v41
		v_add3_u32 v35, v35, v42, v43
		buffer_load_dwordx2 v[70:71], v35, s[40:43], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s20, s1
		v_add3_u32 v36, s14, v46, v47
		v_add3_u32 v36, v36, v49, v50
		v_add3_u32 v36, v36, v51, v52
		v_add3_u32 v36, v36, v53, v54
		buffer_load_dword v38, v36, s[44:47], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v43, s14, v26, v27
		v_add3_u32 v43, v43, v29, v30
		v_add3_u32 v43, v43, v31, v14
		s_add_i32 m0, s16, 0x1cd60
		v_add3_u32 v43, v43, v16, v18
		s_waitcnt vmcnt(15)
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v26, v26, v27, v29
		v_add3_u32 v26, v26, v30, v31
		v_add3_u32 v26, v26, v14, v16
		s_add_i32 m0, s16, 0x1dde0
		v_add3_u32 v27, v18, v26, s14
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, s16, 0x1ee60
		v_add3_u32 v29, v18, v26, s14
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s16, 0x1fee0
		v_add3_u32 v26, v18, v26, s14
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		s_add_i32 s1, s51, s1
		v_add3_u32 v30, s1, v46, v47
		v_add3_u32 v30, v30, v49, v50
		v_add3_u32 v30, v30, v51, v52
		v_add3_u32 v30, v30, v53, v54
		buffer_load_dword v31, v30, s[44:47], 0 offen
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s21, 0x100
		s_mul_i32 s14, s18, 16
		s_mul_i32 s15, s19, 16
		v_lshlrev_b32_e32 v46, 7, v1
		v_and_b32_e32 v47, 63, v0
		v_lshrrev_b32_e32 v49, 4, v47
		v_lshlrev_b32_e32 v49, 4, v49
		v_and_b32_e32 v47, 15, v47
		v_mov_b32_e32 v50, 0x420
		v_mul_lo_u32 v50, v50, v47
		v_add3_u32 v46, v46, v49, v50
		ds_read_b128 a[0:3], v46
		ds_read_b128 a[4:7], v46 offset:64
		ds_read_b128 a[8:11], v46 offset:256
		ds_read_b128 a[12:15], v46 offset:320
		ds_read_b128 a[16:19], v46 offset:512
		ds_read_b128 a[20:23], v46 offset:576
		ds_read_b128 a[24:27], v46 offset:768
		ds_read_b128 a[28:31], v46 offset:832
		ds_read_b128 a[32:35], v46 offset:16896
		ds_read_b128 a[36:39], v46 offset:16960
		ds_read_b128 a[40:43], v46 offset:17152
		ds_read_b128 a[44:47], v46 offset:17216
		ds_read_b128 a[48:51], v46 offset:17408
		ds_read_b128 a[52:55], v46 offset:17472
		ds_read_b128 a[56:59], v46 offset:17664
		ds_read_b128 a[60:63], v46 offset:17728
		v_add_u32_e32 v47, 0x10000, v49
		v_lshlrev_b32_e32 v49, 7, v3
		v_add3_u32 v47, v47, v49, v50
		ds_read_b128 a[64:67], v47 offset:1984
		ds_read_b128 a[68:71], v47 offset:2048
		ds_read_b128 a[72:75], v47 offset:2240
		ds_read_b128 a[76:79], v47 offset:2304
		ds_read_b128 a[80:83], v47 offset:2496
		ds_read_b128 a[84:87], v47 offset:2560
		ds_read_b128 a[88:91], v47 offset:2752
		ds_read_b128 a[92:95], v47 offset:2816
		v_lshlrev_b32_e32 v49, 3, v0
		v_add_u32_e32 v49, 0x20000, v49
		ds_write_b64 v49, v[44:45] offset:3904
		v_lshlrev_b32_e32 v44, 2, v0
		v_add_u32_e32 v44, 0x20000, v44
		ds_write_b32 v44, v55 offset:5952
		v_lshlrev_b32_e32 v45, 4, v1
		s_waitcnt lgkmcnt(1)
		s_barrier
		v_add_u32_e32 v45, 0x20000, v45
		v_add_u32_e32 v45, v45, v39
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v45, v6, 9, v45
		v_lshlrev_b32_e32 v50, 8, v9
		v_add3_u32 v45, v45, v50, v41
		v_lshlrev_b32_e32 v50, 10, v17
		v_add3_u32 v45, v45, v42, v50
		ds_read_b64_tr_b8 v[52:53], v45 offset:3904
		ds_read_b64_tr_b8 v[54:55], v45 offset:4032
		v_add_u32_e32 v39, 0x20000, v39
		v_lshl_add_u32 v39, v3, 4, v39
		v_lshlrev_b32_e32 v51, 8, v6
		v_add3_u32 v39, v39, v51, v40
		v_add3_u32 v39, v39, v41, v42
		v_lshl_add_u32 v17, v17, 9, v39
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
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
		v_accvgpr_write_b32 a96, v236
		v_accvgpr_write_b32 a97, v237
		v_mov_b64_e32 v[236:237], 0
		v_accvgpr_write_b32 a98, v236
		v_accvgpr_write_b32 a99, v237
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a100, v244
		v_accvgpr_write_b32 a101, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a102, v244
		v_accvgpr_write_b32 a103, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a104, v244
		v_accvgpr_write_b32 a105, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a106, v244
		v_accvgpr_write_b32 a107, v245
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a108, v252
		v_accvgpr_write_b32 a109, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a110, v252
		v_accvgpr_write_b32 a111, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a112, v252
		v_accvgpr_write_b32 a113, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a114, v252
		v_accvgpr_write_b32 a115, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a116, v252
		v_accvgpr_write_b32 a117, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a118, v252
		v_accvgpr_write_b32 a119, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a120, v252
		v_accvgpr_write_b32 a121, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a122, v252
		v_accvgpr_write_b32 a123, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a124, v252
		v_accvgpr_write_b32 a125, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a126, v252
		v_accvgpr_write_b32 a127, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a128, v252
		v_accvgpr_write_b32 a129, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a130, v252
		v_accvgpr_write_b32 a131, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a132, v252
		v_accvgpr_write_b32 a133, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a134, v252
		v_accvgpr_write_b32 a135, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a136, v252
		v_accvgpr_write_b32 a137, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a138, v252
		v_accvgpr_write_b32 a139, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a140, v252
		v_accvgpr_write_b32 a141, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a142, v252
		v_accvgpr_write_b32 a143, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a144, v252
		v_accvgpr_write_b32 a145, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a146, v252
		v_accvgpr_write_b32 a147, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a148, v252
		v_accvgpr_write_b32 a149, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a150, v252
		v_accvgpr_write_b32 a151, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a152, v252
		v_accvgpr_write_b32 a153, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a154, v252
		v_accvgpr_write_b32 a155, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a156, v252
		v_accvgpr_write_b32 a157, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a158, v252
		v_accvgpr_write_b32 a159, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v40, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v40, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v40, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v40, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v41, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[0:3], v[84:87], v41, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[8:11], v[100:103], v41, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v41, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v41, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[16:19], v[116:119], v41, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[24:27], v[132:135], v41, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v41, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v40, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v40, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v40, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v40, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[32:35], v[148:151], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[40:43], v[164:167], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[48:51], v[180:183], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[56:59], v[196:199], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v47 offset:35712
		ds_read_b128 a[68:71], v47 offset:35776
		ds_read_b128 a[72:75], v47 offset:35968
		ds_read_b128 a[76:79], v47 offset:36032
		ds_read_b128 a[80:83], v47 offset:36224
		ds_read_b128 a[84:87], v47 offset:36288
		ds_read_b128 a[88:91], v47 offset:36480
		ds_read_b128 a[92:95], v47 offset:36544
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v61 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s16
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x1080
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x2100
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[0:3], v[200:203], v40, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[0:3], v[204:207], v40, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[8:11], v[220:223], v40, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[8:11], v[216:219], v40, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x7380
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[0:3], v[208:211], v41, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[0:3], v[212:215], v41, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[8:11], v[228:231], v41, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[8:11], v[224:227], v41, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v41, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v41, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[24:27], v[248:251], v41, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[24:27], v[244:247], v41, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[16:19], v[232:235], v40, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[16:19], a[96:99], v40, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[24:27], a[104:107], v40, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[64:67], a[24:27], a[100:103], v40, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x107c0
		s_nop 0
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x11840
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[20:23], a[96:99], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x128c0
		s_add_u32 s40, s10, s19
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x13940
		s_add_u32 s36, s8, s18
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[252:253], v37, s[36:39], 0 offen
		buffer_load_dword v39, v48, s[40:43], 0 offen
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v46 offset:33760
		ds_read_b128 a[4:7], v46 offset:33824
		ds_read_b128 a[8:11], v46 offset:34016
		ds_read_b128 a[12:15], v46 offset:34080
		ds_read_b128 a[16:19], v46 offset:34272
		ds_read_b128 a[20:23], v46 offset:34336
		ds_read_b128 a[24:27], v46 offset:34528
		ds_read_b128 a[28:31], v46 offset:34592
		ds_read_b128 a[32:35], v46 offset:50656
		ds_read_b128 a[36:39], v46 offset:50720
		ds_read_b128 a[40:43], v46 offset:50912
		ds_read_b128 a[44:47], v46 offset:50976
		ds_read_b128 a[48:51], v46 offset:51168
		ds_read_b128 a[52:55], v46 offset:51232
		ds_read_b128 a[56:59], v46 offset:51424
		ds_read_b128 a[60:63], v46 offset:51488
		ds_read_b128 a[64:67], v47 offset:18848
		ds_read_b128 a[68:71], v47 offset:18912
		ds_read_b128 a[72:75], v47 offset:19104
		ds_read_b128 a[76:79], v47 offset:19168
		ds_read_b128 a[80:83], v47 offset:19360
		ds_read_b128 a[84:87], v47 offset:19424
		ds_read_b128 a[88:91], v47 offset:19616
		ds_read_b128 v[52:55], v47 offset:19680
		s_waitcnt vmcnt(20)
		ds_write_b64 v49, v[70:71] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v38 offset:5952
		s_add_i32 m0, s16, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v45 offset:3904
		ds_read_b64_tr_b8 v[254:255], v45 offset:4032
		ds_read_b64_tr_b8 v[70:71], v17 offset:5952
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x19c00
		s_nop 0
		buffer_load_dwordx4 v58, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1ac80
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v70, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v59, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1bd00
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v70, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v57, s[32:35], 0 offen lds
		buffer_load_dword v61, v60, s[40:43], 0 offen
		s_waitcnt vmcnt(20)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v70, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v70, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v70, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v70, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v70, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v70, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v71, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[0:3], v[84:87], v71, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[8:11], v[100:103], v71, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v71, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v71, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[52:55], a[4:7], v[84:87], v71, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[52:55], a[12:15], v[100:103], v71, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v71, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v71, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[16:19], v[116:119], v71, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[24:27], v[132:135], v71, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v71, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v71, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[52:55], a[20:23], v[116:119], v71, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[52:55], a[28:31], v[132:135], v71, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v71, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v70, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v70, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v70, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v70, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v70, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v70, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v70, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v70, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v70, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v70, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v70, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v70, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v70, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v70, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v70, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v70, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v71, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[32:35], v[148:151], v71, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[40:43], v[164:167], v71, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v71, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v71, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[52:55], a[36:39], v[148:151], v71, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], a[44:47], v[164:167], v71, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v71, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v71, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[48:51], v[180:183], v71, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[56:59], v[196:199], v71, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v71, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v71, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[52:55], a[52:55], v[180:183], v71, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[52:55], a[60:63], v[196:199], v71, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v71, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v70, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v70, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v70, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v70, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v70, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v70, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v70, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v70, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v47 offset:52576
		ds_read_b128 a[68:71], v47 offset:52640
		ds_read_b128 a[72:75], v47 offset:52832
		ds_read_b128 a[76:79], v47 offset:52896
		ds_read_b128 a[80:83], v47 offset:53088
		ds_read_b128 a[84:87], v47 offset:53152
		ds_read_b128 a[88:91], v47 offset:53344
		ds_read_b128 a[92:95], v47 offset:53408
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v31 offset:5952
		s_add_i32 m0, s16, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[52:53], v17 offset:5952
		buffer_load_dwordx4 v62, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x9460
		s_nop 0
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xa4e0
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[0:3], v[200:203], v52, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[0:3], v[204:207], v52, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[8:11], v[220:223], v52, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v66, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[8:11], v[216:219], v52, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v67, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v52, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v52, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v52, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v52, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[0:3], v[208:211], v53, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[0:3], v[212:215], v53, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[8:11], v[228:231], v53, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[8:11], v[224:227], v53, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v53, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v53, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v53, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v53, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v53, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v53, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[24:27], v[248:251], v53, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[24:27], v[244:247], v53, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v53, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v53, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v53, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v53, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[16:19], v[232:235], v52, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[16:19], a[96:99], v52, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[24:27], a[104:107], v52, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[64:67], a[24:27], a[100:103], v52, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v52, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[20:23], a[96:99], v52, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s16, 0x149a0
		s_add_i32 s19, s19, s15
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v52, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v52, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[70:71], v35, s[36:39], 0 offen
		buffer_load_dword v38, v36, s[40:43], 0 offen
		s_waitcnt vmcnt(21)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v52, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v52, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v52, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v52, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v52, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v52, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v52, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v52, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v53, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v53, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v53, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v53, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v53, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v53, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v53, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v53, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v53, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v53, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v53, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v53, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v53, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v53, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v53, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v53, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v52, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v52, v255 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v52, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v52, v255 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v52, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v52, v255 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v52, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v52, v255 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v46
		ds_read_b128 a[4:7], v46 offset:64
		ds_read_b128 a[8:11], v46 offset:256
		ds_read_b128 a[12:15], v46 offset:320
		ds_read_b128 a[16:19], v46 offset:512
		ds_read_b128 a[20:23], v46 offset:576
		ds_read_b128 a[24:27], v46 offset:768
		ds_read_b128 a[28:31], v46 offset:832
		ds_read_b128 a[32:35], v46 offset:16896
		ds_read_b128 a[36:39], v46 offset:16960
		ds_read_b128 a[40:43], v46 offset:17152
		ds_read_b128 a[44:47], v46 offset:17216
		ds_read_b128 a[48:51], v46 offset:17408
		ds_read_b128 a[52:55], v46 offset:17472
		ds_read_b128 a[56:59], v46 offset:17664
		ds_read_b128 a[60:63], v46 offset:17728
		ds_read_b128 a[64:67], v47 offset:1984
		ds_read_b128 a[68:71], v47 offset:2048
		ds_read_b128 a[72:75], v47 offset:2240
		ds_read_b128 a[76:79], v47 offset:2304
		ds_read_b128 a[80:83], v47 offset:2496
		ds_read_b128 a[84:87], v47 offset:2560
		ds_read_b128 a[88:91], v47 offset:2752
		ds_read_b128 a[92:95], v47 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v49, v[252:253] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v44, v39 offset:5952
		s_add_i32 m0, s16, 0x1cd60
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[52:53], v45 offset:3904
		ds_read_b64_tr_b8 v[54:55], v45 offset:4032
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
		buffer_load_dwordx4 v43, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1dde0
		s_add_i32 s18, s18, s14
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_add_i32 m0, s16, 0x1fee0
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		buffer_load_dword v31, v30, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(1)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], a[0:3], v[72:75], v40, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[0:3], v[76:79], v40, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[8:11], v[92:95], v40, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[64:67], a[8:11], v[88:91], v40, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v40, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v40, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[0:3], v[80:83], v41, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[0:3], v[84:87], v41, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[8:11], v[100:103], v41, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[8:11], v[96:99], v41, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v41, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v41, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[16:19], v[112:115], v41, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[16:19], v[116:119], v41, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[24:27], v[132:135], v41, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[24:27], v[128:131], v41, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v41, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v41, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[64:67], a[16:19], v[104:107], v40, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[16:19], v[108:111], v40, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[24:27], v[124:127], v40, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[64:67], a[24:27], v[120:123], v40, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v40, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v40, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[64:67], a[32:35], v[136:139], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[32:35], v[140:143], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[40:43], v[156:159], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[64:67], a[40:43], v[152:155], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[32:35], v[144:147], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[32:35], v[148:151], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[40:43], v[164:167], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[40:43], v[160:163], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[48:51], v[176:179], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[48:51], v[180:183], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[56:59], v[196:199], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[56:59], v[192:195], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[48:51], v[168:171], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[48:51], v[172:175], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[56:59], v[188:191], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[56:59], v[184:187], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v47 offset:35712
		ds_read_b128 a[64:67], v47 offset:35776
		ds_read_b128 v[24:27], v47 offset:35968
		ds_read_b128 v[32:35], v47 offset:36032
		ds_read_b128 v[40:43], v47 offset:36224
		ds_read_b128 v[56:59], v47 offset:36288
		ds_read_b128 v[64:67], v47 offset:36480
		ds_read_b128 v[252:255], v47 offset:36544
		ds_write_b32 v44, v61 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v13
		v_lshl_add_u32 v2, v8, 4, v2
		v_lshl_add_u32 v2, v11, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v17 offset:5952
		ds_read_b128 a[68:71], v46 offset:33760
		ds_read_b128 a[72:75], v46 offset:33824
		ds_read_b128 a[76:79], v46 offset:34016
		ds_read_b128 v[60:63], v46 offset:34080
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], a[0:3], v[200:203], v4, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], a[0:3], v[204:207], v4, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], a[8:11], v[220:223], v4, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[20:23], a[8:11], v[216:219], v4, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[4:7], v[200:203], v4, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], a[4:7], v[204:207], v4, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], a[12:15], v[220:223], v4, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[12:15], v[216:219], v4, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], a[0:3], v[208:211], v5, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], a[0:3], v[212:215], v5, v52 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[64:67], a[8:11], v[228:231], v5, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], a[8:11], v[224:227], v5, v52 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], a[4:7], v[208:211], v5, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[4:7], v[212:215], v5, v52 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[12:15], v[228:231], v5, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], a[12:15], v[224:227], v5, v52 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], a[16:19], v[236:239], v5, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[64:67], a[16:19], v[240:243], v5, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[64:67], a[24:27], v[248:251], v5, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[24:27], v[244:247], v5, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], a[20:23], v[236:239], v5, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[20:23], v[240:243], v5, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[28:31], v[248:251], v5, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[56:59], a[28:31], v[244:247], v5, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[20:23], a[16:19], v[232:235], v4, v53 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], a[16:19], a[96:99], v4, v53 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], a[24:27], a[104:107], v4, v53 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], a[24:27], a[100:103], v4, v53 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[20:23], v[232:235], v4, v53 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[32:35], a[20:23], a[96:99], v4, v53 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[32:35], a[28:31], a[104:107], v4, v53 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[64:67], a[28:31], a[100:103], v4, v53 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[32:35], a[108:111], v4, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], a[32:35], a[112:115], v4, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], a[40:43], a[128:131], v4, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[40:43], a[124:127], v4, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[36:39], a[108:111], v4, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[36:39], a[112:115], v4, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[44:47], a[128:131], v4, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[44:47], a[124:127], v4, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[32:35], a[116:119], v5, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[32:35], a[120:123], v5, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[40:43], a[136:139], v5, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[40:43], a[132:135], v5, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[36:39], a[116:119], v5, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v5, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v5, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[44:47], a[132:135], v5, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[48:51], a[148:151], v5, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[48:51], a[152:155], v5, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[56:59], a[168:171], v5, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[56:59], a[164:167], v5, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[52:55], a[148:151], v5, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v5, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v5, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[60:63], a[164:167], v5, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[48:51], a[140:143], v4, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], a[48:51], a[144:147], v4, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], a[56:59], a[160:163], v4, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[56:59], a[156:159], v4, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[52:55], a[140:143], v4, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[52:55], a[144:147], v4, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[60:63], a[160:163], v4, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[60:63], a[156:159], v4, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v46 offset:34272
		ds_read_b128 a[4:7], v46 offset:34336
		ds_read_b128 a[8:11], v46 offset:34528
		ds_read_b128 a[12:15], v46 offset:34592
		ds_read_b128 a[16:19], v46 offset:50656
		ds_read_b128 a[20:23], v46 offset:50720
		ds_read_b128 a[24:27], v46 offset:50912
		ds_read_b128 a[28:31], v46 offset:50976
		ds_read_b128 a[32:35], v46 offset:51168
		ds_read_b128 a[36:39], v46 offset:51232
		ds_read_b128 a[40:43], v46 offset:51424
		ds_read_b128 a[44:47], v46 offset:51488
		ds_read_b128 v[20:23], v47 offset:18848
		ds_read_b128 v[24:27], v47 offset:18912
		ds_read_b128 v[32:35], v47 offset:19104
		ds_read_b128 v[40:43], v47 offset:19168
		ds_read_b128 v[52:55], v47 offset:19360
		ds_read_b128 v[56:59], v47 offset:19424
		ds_read_b128 v[64:67], v47 offset:19616
		ds_read_b128 v[252:255], v47 offset:19680
		ds_write_b64 v49, v[70:71] offset:3904
		ds_write_b32 v44, v38 offset:5952
		v_lshlrev_b32_e32 v4, 12, v15
		v_add3_u32 v2, v2, v4, v50
		v_lshlrev_b32_e32 v4, 7, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v45 offset:3904
		ds_read_b64_tr_b8 v[12:13], v45 offset:4032
		ds_read_b64_tr_b8 v[28:29], v17 offset:5952
		ds_read_b128 v[36:39], v47 offset:52576
		ds_read_b128 a[48:51], v47 offset:52640
		ds_read_b128 v[48:51], v47 offset:52832
		ds_read_b128 v[68:71], v47 offset:52896
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], a[68:71], v[72:75], v28, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], a[68:71], v[76:79], v28, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], a[76:79], v[92:95], v28, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], a[76:79], v[88:91], v28, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[24:27], a[72:75], v[72:75], v28, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[40:43], a[72:75], v[76:79], v28, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[40:43], v[60:63], v[92:95], v28, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], v[60:63], v[88:91], v28, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[52:55], a[68:71], v[80:83], v29, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], a[68:71], v[84:87], v29, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], a[76:79], v[100:103], v29, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[52:55], a[76:79], v[96:99], v29, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[56:59], a[72:75], v[80:83], v29, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], a[72:75], v[84:87], v29, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], v[60:63], v[100:103], v29, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[56:59], v[60:63], v[96:99], v29, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[52:55], a[0:3], v[112:115], v29, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], a[0:3], v[116:119], v29, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], a[8:11], v[132:135], v29, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[52:55], a[8:11], v[128:131], v29, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[56:59], a[4:7], v[112:115], v29, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], a[4:7], v[116:119], v29, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[12:15], v[132:135], v29, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[56:59], a[12:15], v[128:131], v29, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], a[0:3], v[104:107], v28, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], a[0:3], v[108:111], v28, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], a[8:11], v[124:127], v28, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], a[8:11], v[120:123], v28, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], a[4:7], v[104:107], v28, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[40:43], a[4:7], v[108:111], v28, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], a[12:15], v[124:127], v28, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], a[12:15], v[120:123], v28, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], a[16:19], v[136:139], v28, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], a[16:19], v[140:143], v28, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], a[24:27], v[156:159], v28, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], a[24:27], v[152:155], v28, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], a[20:23], v[136:139], v28, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], a[20:23], v[140:143], v28, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], a[28:31], v[156:159], v28, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], a[28:31], v[152:155], v28, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[52:55], a[16:19], v[144:147], v29, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[64:67], a[16:19], v[148:151], v29, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[64:67], a[24:27], v[164:167], v29, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], a[24:27], v[160:163], v29, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[56:59], a[20:23], v[144:147], v29, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[20:23], v[148:151], v29, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[28:31], v[164:167], v29, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], a[28:31], v[160:163], v29, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[52:55], a[32:35], v[176:179], v29, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], a[32:35], v[180:183], v29, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], a[40:43], v[196:199], v29, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], a[40:43], v[192:195], v29, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], a[36:39], v[176:179], v29, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[36:39], v[180:183], v29, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[44:47], v[196:199], v29, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], a[44:47], v[192:195], v29, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], a[32:35], v[168:171], v28, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], a[32:35], v[172:175], v28, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], a[40:43], v[188:191], v28, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], a[40:43], v[184:187], v28, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[36:39], v[168:171], v28, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], a[36:39], v[172:175], v28, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], a[44:47], v[188:191], v28, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[44:47], v[184:187], v28, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v47 offset:53088
		ds_read_b128 v[24:27], v47 offset:53152
		ds_read_b128 v[32:35], v47 offset:53344
		ds_read_b128 v[40:43], v47 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v44, v31 offset:5952
		v_cvt_pk_bf16_f32 v28, v72, v73
		v_cvt_pk_bf16_f32 v29, v74, v75
		v_cvt_pk_bf16_f32 v44, v76, v77
		v_cvt_pk_bf16_f32 v45, v78, v79
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[52:53], v17 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v56, v80, v81
		v_cvt_pk_bf16_f32 v57, v82, v83
		v_cvt_pk_bf16_f32 v64, v84, v85
		v_cvt_pk_bf16_f32 v65, v86, v87
		v_cvt_pk_bf16_f32 v30, v88, v89
		v_cvt_pk_bf16_f32 v31, v90, v91
		v_cvt_pk_bf16_f32 v46, v92, v93
		v_cvt_pk_bf16_f32 v47, v94, v95
		v_cvt_pk_bf16_f32 v58, v96, v97
		v_cvt_pk_bf16_f32 v59, v98, v99
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
		ds_write_b128 v0, v[28:31]
		ds_write_b128 v0, v[44:47] offset:4096
		ds_write_b128 v0, v[56:59] offset:8192
		ds_write_b128 v0, v[64:67] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v5, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v2
		ds_read_b128 v[44:47], v2 offset:256
		ds_read_b128 v[56:59], v2 offset:2048
		ds_read_b128 v[64:67], v2 offset:2304
		v_lshlrev_b32_e32 v7, 2, v3
		v_add_u32_e32 v8, 16, v9
		v_lshlrev_b32_e32 v15, 1, v6
		v_xor_b32_e32 v8, v8, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[72:75]
		ds_write_b128 v0, v[76:79] offset:4096
		ds_write_b128 v0, v[80:83] offset:8192
		ds_write_b128 v0, v[84:87] offset:12288
		v_bitop3_b32 v8, v5, v7, v8 bitop3:0x96
		v_add_u32_e32 v17, 32, v9
		v_xor_b32_e32 v17, v17, v15
		v_bitop3_b32 v17, v5, v7, v17 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v2
		ds_read_b128 v[76:79], v2 offset:256
		ds_read_b128 v[80:83], v2 offset:2048
		ds_read_b128 v[84:87], v2 offset:2304
		v_add_u32_e32 v19, 48, v9
		v_xor_b32_e32 v19, v19, v15
		v_bitop3_b32 v19, v5, v7, v19 bitop3:0x96
		v_add_u32_e32 v54, 64, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[88:91]
		ds_write_b128 v0, v[92:95] offset:4096
		ds_write_b128 v0, v[96:99] offset:8192
		ds_write_b128 v0, v[100:103] offset:12288
		v_xor_b32_e32 v54, v54, v15
		v_bitop3_b32 v54, v5, v7, v54 bitop3:0x96
		v_add_u32_e32 v55, 0x50, v9
		v_xor_b32_e32 v55, v55, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[88:91], v2
		ds_read_b128 v[92:95], v2 offset:256
		ds_read_b128 v[96:99], v2 offset:2048
		ds_read_b128 v[100:103], v2 offset:2304
		v_bitop3_b32 v55, v5, v7, v55 bitop3:0x96
		v_add_u32_e32 v120, 0x60, v9
		v_xor_b32_e32 v120, v120, v15
		v_bitop3_b32 v120, v5, v7, v120 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[104:107]
		ds_write_b128 v0, v[108:111] offset:4096
		ds_write_b128 v0, v[112:115] offset:8192
		ds_write_b128 v0, v[116:119] offset:12288
		v_add_u32_e32 v104, 0x70, v9
		v_xor_b32_e32 v104, v104, v15
		v_bitop3_b32 v104, v5, v7, v104 bitop3:0x96
		v_add_u32_e32 v105, 0x80, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v2
		ds_read_b128 v[112:115], v2 offset:256
		ds_read_b128 v[116:119], v2 offset:2048
		ds_read_b128 v[124:127], v2 offset:2304
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v106, s0, v1, v3
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 2, v6
		v_mul_lo_u32 v107, s17, v9
		v_lshlrev_b32_e32 v107, 1, v107
		v_add3_u32 v106, v106, v6, v107
		v_add3_u32 v106, v106, v14, v4
		v_add3_u32 v106, v106, v16, v18
		v_mov_b64_e32 v[128:129], v[28:29]
		v_mov_b64_e32 v[130:131], v[44:45]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[128:131], v106, s[8:11], 0 offen
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v28, s0, v8
		v_add3_u32 v28, v28, v14, v4
		v_add3_u32 v28, v28, v16, v18
		v_mov_b64_e32 v[128:129], v[56:57]
		v_mov_b64_e32 v[130:131], v[64:65]
		buffer_store_dwordx4 v[128:131], v28, s[8:11], 0 offen
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v28, s0, v17
		v_add3_u32 v28, v28, v14, v4
		v_add3_u32 v28, v28, v16, v18
		v_mov_b64_e32 v[128:129], v[30:31]
		v_mov_b64_e32 v[130:131], v[46:47]
		buffer_store_dwordx4 v[128:131], v28, s[8:11], 0 offen
		v_mul_lo_u32 v19, s17, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_add_u32_e32 v28, s0, v19
		v_add3_u32 v28, v28, v14, v4
		v_add3_u32 v28, v28, v16, v18
		v_mov_b64_e32 v[44:45], v[58:59]
		v_mov_b64_e32 v[46:47], v[66:67]
		buffer_store_dwordx4 v[44:47], v28, s[8:11], 0 offen
		v_mul_lo_u32 v28, s17, v54
		v_lshlrev_b32_e32 v28, 1, v28
		v_add_u32_e32 v29, s0, v28
		v_add3_u32 v29, v29, v14, v4
		v_add3_u32 v29, v29, v16, v18
		v_mov_b64_e32 v[44:45], v[72:73]
		v_mov_b64_e32 v[46:47], v[76:77]
		buffer_store_dwordx4 v[44:47], v29, s[8:11], 0 offen
		v_mul_lo_u32 v29, s17, v55
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v30, s0, v29
		v_add3_u32 v30, v30, v14, v4
		v_add3_u32 v30, v30, v16, v18
		v_mov_b64_e32 v[44:45], v[80:81]
		v_mov_b64_e32 v[46:47], v[84:85]
		buffer_store_dwordx4 v[44:47], v30, s[8:11], 0 offen
		v_mul_lo_u32 v30, s17, v120
		v_lshlrev_b32_e32 v30, 1, v30
		v_add_u32_e32 v31, s0, v30
		v_add3_u32 v31, v31, v14, v4
		v_add3_u32 v31, v31, v16, v18
		v_mov_b64_e32 v[44:45], v[74:75]
		v_mov_b64_e32 v[46:47], v[78:79]
		buffer_store_dwordx4 v[44:47], v31, s[8:11], 0 offen
		v_mul_lo_u32 v31, s17, v104
		v_lshlrev_b32_e32 v31, 1, v31
		v_add_u32_e32 v44, s0, v31
		v_add3_u32 v44, v44, v14, v4
		v_add3_u32 v44, v44, v16, v18
		v_mov_b64_e32 v[56:57], v[82:83]
		v_mov_b64_e32 v[58:59], v[86:87]
		buffer_store_dwordx4 v[56:59], v44, s[8:11], 0 offen
		v_xor_b32_e32 v44, v105, v15
		v_bitop3_b32 v44, v5, v7, v44 bitop3:0x96
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v14, v4
		v_add3_u32 v45, v45, v16, v18
		v_mov_b64_e32 v[56:57], v[88:89]
		v_mov_b64_e32 v[58:59], v[92:93]
		buffer_store_dwordx4 v[56:59], v45, s[8:11], 0 offen
		v_add_u32_e32 v45, 0x90, v9
		v_xor_b32_e32 v45, v45, v15
		v_bitop3_b32 v45, v5, v7, v45 bitop3:0x96
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v46, s0, v45
		v_add3_u32 v46, v46, v14, v4
		v_add3_u32 v46, v46, v16, v18
		v_mov_b64_e32 v[56:57], v[96:97]
		v_mov_b64_e32 v[58:59], v[100:101]
		buffer_store_dwordx4 v[56:59], v46, s[8:11], 0 offen
		v_add_u32_e32 v46, 0xa0, v9
		v_xor_b32_e32 v46, v46, v15
		v_bitop3_b32 v46, v5, v7, v46 bitop3:0x96
		v_mul_lo_u32 v46, s17, v46
		v_lshlrev_b32_e32 v46, 1, v46
		v_add_u32_e32 v47, s0, v46
		v_add3_u32 v47, v47, v14, v4
		v_add3_u32 v47, v47, v16, v18
		v_mov_b64_e32 v[56:57], v[90:91]
		v_mov_b64_e32 v[58:59], v[94:95]
		buffer_store_dwordx4 v[56:59], v47, s[8:11], 0 offen
		v_add_u32_e32 v47, 0xb0, v9
		v_xor_b32_e32 v47, v47, v15
		v_bitop3_b32 v47, v5, v7, v47 bitop3:0x96
		v_mul_lo_u32 v47, s17, v47
		v_lshlrev_b32_e32 v47, 1, v47
		v_add_u32_e32 v54, s0, v47
		v_add3_u32 v54, v54, v14, v4
		v_add3_u32 v54, v54, v16, v18
		v_mov_b64_e32 v[56:57], v[98:99]
		v_mov_b64_e32 v[58:59], v[102:103]
		buffer_store_dwordx4 v[56:59], v54, s[8:11], 0 offen
		v_add_u32_e32 v54, 0xc0, v9
		v_xor_b32_e32 v54, v54, v15
		v_bitop3_b32 v54, v5, v7, v54 bitop3:0x96
		v_mul_lo_u32 v54, s17, v54
		v_lshlrev_b32_e32 v54, 1, v54
		v_add_u32_e32 v55, s0, v54
		v_add3_u32 v55, v55, v14, v4
		v_add3_u32 v55, v55, v16, v18
		v_mov_b64_e32 v[56:57], v[108:109]
		v_mov_b64_e32 v[58:59], v[112:113]
		buffer_store_dwordx4 v[56:59], v55, s[8:11], 0 offen
		v_add_u32_e32 v55, 0xd0, v9
		v_xor_b32_e32 v55, v55, v15
		v_bitop3_b32 v55, v5, v7, v55 bitop3:0x96
		v_mul_lo_u32 v55, s17, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v56, s0, v55
		v_add3_u32 v56, v56, v14, v4
		v_add3_u32 v56, v56, v16, v18
		v_mov_b64_e32 v[64:65], v[116:117]
		v_mov_b64_e32 v[66:67], v[124:125]
		buffer_store_dwordx4 v[64:67], v56, s[8:11], 0 offen
		v_add_u32_e32 v56, 0xe0, v9
		v_xor_b32_e32 v56, v56, v15
		v_bitop3_b32 v56, v5, v7, v56 bitop3:0x96
		v_mul_lo_u32 v56, s17, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s0, v56
		v_add3_u32 v57, v57, v14, v4
		v_add3_u32 v57, v57, v16, v18
		v_mov_b64_e32 v[64:65], v[110:111]
		v_mov_b64_e32 v[66:67], v[114:115]
		buffer_store_dwordx4 v[64:67], v57, s[8:11], 0 offen
		v_add_u32_e32 v9, 0xf0, v9
		v_xor_b32_e32 v9, v9, v15
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_mul_lo_u32 v5, s17, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_add_u32_e32 v7, s0, v5
		v_add3_u32 v7, v7, v14, v4
		v_add3_u32 v7, v7, v16, v18
		v_mov_b64_e32 v[64:65], v[118:119]
		v_mov_b64_e32 v[66:67], v[126:127]
		buffer_store_dwordx4 v[64:67], v7, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], a[68:71], v[200:203], v52, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], a[68:71], v[204:207], v52, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], a[76:79], v[220:223], v52, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[76:79], v[216:219], v52, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[48:51], a[72:75], v[200:203], v52, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], a[72:75], v[204:207], v52, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], v[60:63], v[220:223], v52, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[48:51], v[60:63], v[216:219], v52, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], a[68:71], v[208:211], v53, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[68:71], v[212:215], v53, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[76:79], v[228:231], v53, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[20:23], a[76:79], v[224:227], v53, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[72:75], v[208:211], v53, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v200, v201
		v_cvt_pk_bf16_f32 v65, v202, v203
		v_cvt_pk_bf16_f32 v72, v204, v205
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], a[72:75], v[212:215], v53, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v73, v206, v207
		v_cvt_pk_bf16_f32 v66, v216, v217
		v_cvt_pk_bf16_f32 v67, v218, v219
		ds_write_b128 v0, v[64:67]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[60:63], v[228:231], v53, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v208, v209
		v_cvt_pk_bf16_f32 v65, v210, v211
		v_cvt_pk_bf16_f32 v74, v220, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], v[60:63], v[224:227], v53, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v212, v213
		v_cvt_pk_bf16_f32 v61, v214, v215
		v_cvt_pk_bf16_f32 v75, v222, v223
		ds_write_b128 v0, v[72:75] offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[20:23], a[0:3], v[236:239], v53, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v62, v228, v229
		v_cvt_pk_bf16_f32 v63, v230, v231
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[0:3], v[240:243], v53, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v66, v224, v225
		v_cvt_pk_bf16_f32 v67, v226, v227
		ds_write_b128 v0, v[64:67] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[8:11], v[248:251], v53, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[20:23], a[8:11], v[244:247], v53, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[24:27], a[4:7], v[236:239], v53, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], a[4:7], v[240:243], v53, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[40:43], a[12:15], v[248:251], v53, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[24:27], a[12:15], v[244:247], v53, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[0:3], v[232:235], v52, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[48:51], a[0:3], a[96:99], v52, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[48:51], a[8:11], a[104:107], v52, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], a[8:11], a[100:103], v52, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v236, v237
		v_cvt_pk_bf16_f32 v61, v238, v239
		v_cvt_pk_bf16_f32 v64, v240, v241
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[48:51], a[4:7], v[232:235], v52, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v65, v242, v243
		v_cvt_pk_bf16_f32 v62, v244, v245
		v_cvt_pk_bf16_f32 v63, v246, v247
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[68:71], a[4:7], a[96:99], v52, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v66, v248, v249
		v_cvt_pk_bf16_f32 v67, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[12:15], a[104:107], v52, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[48:51], a[12:15], a[100:103], v52, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v72, v232, v233
		v_cvt_pk_bf16_f32 v73, v234, v235
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[16:19], a[108:111], v52, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[48:51], a[16:19], a[112:115], v52, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a96
		v_accvgpr_read_b32 v9, a97
		v_cvt_pk_bf16_f32 v76, v7, v9
		v_accvgpr_read_b32 v7, a98
		v_accvgpr_read_b32 v9, a99
		v_cvt_pk_bf16_f32 v77, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], a[24:27], a[128:131], v52, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a104
		v_accvgpr_read_b32 v9, a105
		v_cvt_pk_bf16_f32 v78, v7, v9
		v_accvgpr_read_b32 v7, a100
		v_accvgpr_read_b32 v9, a101
		v_cvt_pk_bf16_f32 v74, v7, v9
		v_accvgpr_read_b32 v7, a102
		v_accvgpr_read_b32 v9, a103
		v_cvt_pk_bf16_f32 v75, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], a[24:27], a[124:127], v52, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a106
		v_accvgpr_read_b32 v9, a107
		v_cvt_pk_bf16_f32 v79, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[48:51], a[20:23], a[108:111], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], a[20:23], a[112:115], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], a[28:31], a[128:131], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[48:51], a[28:31], a[124:127], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[16:19], a[116:119], v53, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], a[16:19], a[120:123], v53, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], a[24:27], a[136:139], v53, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[24:27], a[132:135], v53, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], a[20:23], a[116:119], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a108
		v_accvgpr_read_b32 v9, a109
		v_cvt_pk_bf16_f32 v80, v7, v9
		v_accvgpr_read_b32 v7, a110
		v_accvgpr_read_b32 v9, a111
		v_cvt_pk_bf16_f32 v81, v7, v9
		v_accvgpr_read_b32 v7, a112
		v_accvgpr_read_b32 v9, a113
		v_cvt_pk_bf16_f32 v84, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[20:23], a[120:123], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a114
		v_accvgpr_read_b32 v9, a115
		v_cvt_pk_bf16_f32 v85, v7, v9
		v_accvgpr_read_b32 v7, a124
		v_accvgpr_read_b32 v9, a125
		v_cvt_pk_bf16_f32 v82, v7, v9
		v_accvgpr_read_b32 v7, a126
		v_accvgpr_read_b32 v9, a127
		v_cvt_pk_bf16_f32 v83, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[28:31], a[136:139], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a116
		v_accvgpr_read_b32 v9, a117
		v_cvt_pk_bf16_f32 v88, v7, v9
		v_accvgpr_read_b32 v7, a118
		v_accvgpr_read_b32 v9, a119
		v_cvt_pk_bf16_f32 v89, v7, v9
		v_accvgpr_read_b32 v7, a128
		v_accvgpr_read_b32 v9, a129
		v_cvt_pk_bf16_f32 v86, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], a[28:31], a[132:135], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a120
		v_accvgpr_read_b32 v9, a121
		v_cvt_pk_bf16_f32 v92, v7, v9
		v_accvgpr_read_b32 v7, a122
		v_accvgpr_read_b32 v9, a123
		v_cvt_pk_bf16_f32 v93, v7, v9
		v_accvgpr_read_b32 v7, a130
		v_accvgpr_read_b32 v9, a131
		v_cvt_pk_bf16_f32 v87, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[32:35], a[148:151], v53, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a136
		v_accvgpr_read_b32 v9, a137
		v_cvt_pk_bf16_f32 v94, v7, v9
		v_accvgpr_read_b32 v7, a138
		v_accvgpr_read_b32 v9, a139
		v_cvt_pk_bf16_f32 v95, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], a[32:35], a[152:155], v53, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], a[40:43], a[168:171], v53, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a132
		v_accvgpr_read_b32 v9, a133
		v_cvt_pk_bf16_f32 v90, v7, v9
		v_accvgpr_read_b32 v7, a134
		v_accvgpr_read_b32 v9, a135
		v_cvt_pk_bf16_f32 v91, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[20:23], a[40:43], a[164:167], v53, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], a[36:39], a[148:151], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], a[36:39], a[152:155], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], a[44:47], a[168:171], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], a[44:47], a[164:167], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[36:39], a[32:35], a[140:143], v52, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], a[32:35], a[144:147], v52, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], a[40:43], a[160:163], v52, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], a[40:43], a[156:159], v52, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[48:51], a[36:39], a[140:143], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a148
		v_accvgpr_read_b32 v9, a149
		v_cvt_pk_bf16_f32 v20, v7, v9
		v_accvgpr_read_b32 v7, a150
		v_accvgpr_read_b32 v9, a151
		v_cvt_pk_bf16_f32 v21, v7, v9
		v_accvgpr_read_b32 v7, a152
		v_accvgpr_read_b32 v9, a153
		v_cvt_pk_bf16_f32 v24, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[68:71], a[36:39], a[144:147], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a154
		v_accvgpr_read_b32 v9, a155
		v_cvt_pk_bf16_f32 v25, v7, v9
		v_accvgpr_read_b32 v7, a164
		v_accvgpr_read_b32 v9, a165
		v_cvt_pk_bf16_f32 v22, v7, v9
		v_accvgpr_read_b32 v7, a166
		v_accvgpr_read_b32 v9, a167
		v_cvt_pk_bf16_f32 v23, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[68:71], a[44:47], a[160:163], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a140
		v_accvgpr_read_b32 v9, a141
		v_cvt_pk_bf16_f32 v32, v7, v9
		v_accvgpr_read_b32 v7, a142
		v_accvgpr_read_b32 v9, a143
		v_cvt_pk_bf16_f32 v33, v7, v9
		v_accvgpr_read_b32 v7, a168
		v_accvgpr_read_b32 v9, a169
		v_cvt_pk_bf16_f32 v26, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[44:47], a[156:159], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a144
		v_accvgpr_read_b32 v9, a145
		v_cvt_pk_bf16_f32 v36, v7, v9
		v_accvgpr_read_b32 v7, a146
		v_accvgpr_read_b32 v9, a147
		v_cvt_pk_bf16_f32 v37, v7, v9
		v_accvgpr_read_b32 v7, a170
		v_accvgpr_read_b32 v9, a171
		v_cvt_pk_bf16_f32 v27, v7, v9
		ds_read_b128 v[40:43], v2
		v_accvgpr_read_b32 v7, a160
		v_accvgpr_read_b32 v9, a161
		v_cvt_pk_bf16_f32 v38, v7, v9
		v_accvgpr_read_b32 v7, a162
		v_accvgpr_read_b32 v9, a163
		v_cvt_pk_bf16_f32 v39, v7, v9
		ds_read_b128 v[48:51], v2 offset:256
		ds_read_b128 v[68:71], v2 offset:2048
		v_accvgpr_read_b32 v7, a156
		v_accvgpr_read_b32 v9, a157
		v_cvt_pk_bf16_f32 v34, v7, v9
		v_accvgpr_read_b32 v7, a158
		v_accvgpr_read_b32 v9, a159
		v_cvt_pk_bf16_f32 v35, v7, v9
		ds_read_b128 v[96:99], v2 offset:2304
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v6, v107
		v_add3_u32 v1, v1, v14, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[72:75]
		ds_write_b128 v0, v[76:79] offset:4096
		ds_write_b128 v0, v[60:63] offset:8192
		ds_write_b128 v0, v[64:67] offset:12288
		v_add3_u32 v1, v1, v16, v18
		v_mov_b64_e32 v[60:61], v[40:41]
		v_mov_b64_e32 v[62:63], v[48:49]
		buffer_store_dwordx4 v[60:63], v1, s[8:11], 0 offen
		v_add3_u32 v1, v14, v4, v16
		v_add_u32_e32 v1, v1, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v2
		ds_read_b128 v[64:67], v2 offset:256
		ds_read_b128 v[72:75], v2 offset:2048
		ds_read_b128 v[76:79], v2 offset:2304
		v_add3_u32 v3, v8, v1, s0
		v_mov_b64_e32 v[8:9], v[68:69]
		v_mov_b64_e32 v[10:11], v[96:97]
		buffer_store_dwordx4 v[8:11], v3, s[8:11], 0 offen
		v_add3_u32 v3, v17, v1, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[42:43]
		v_mov_b64_e32 v[10:11], v[50:51]
		buffer_store_dwordx4 v[8:11], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		v_add3_u32 v1, v19, v1, s0
		v_mov_b64_e32 v[8:9], v[70:71]
		v_mov_b64_e32 v[10:11], v[98:99]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v14, v4, v16
		v_add_u32_e32 v1, v1, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[40:43], v2 offset:256
		ds_read_b128 v[48:51], v2 offset:2048
		ds_read_b128 v[68:71], v2 offset:2304
		v_add3_u32 v3, v28, v1, s0
		v_mov_b64_e32 v[80:81], v[60:61]
		v_mov_b64_e32 v[82:83], v[64:65]
		buffer_store_dwordx4 v[80:83], v3, s[8:11], 0 offen
		v_add3_u32 v3, v29, v1, s0
		s_nop 0
		v_mov_b64_e32 v[80:81], v[72:73]
		v_mov_b64_e32 v[82:83], v[76:77]
		buffer_store_dwordx4 v[80:83], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[32:35]
		ds_write_b128 v0, v[36:39] offset:4096
		ds_write_b128 v0, v[20:23] offset:8192
		ds_write_b128 v0, v[24:27] offset:12288
		v_add3_u32 v0, v30, v1, s0
		v_mov_b64_e32 v[20:21], v[62:63]
		v_mov_b64_e32 v[22:23], v[66:67]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[24:27], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:2304
		v_add3_u32 v1, v31, v0, s0
		v_mov_b64_e32 v[28:29], v[74:75]
		v_mov_b64_e32 v[30:31], v[78:79]
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		v_add3_u32 v1, v44, v0, s0
		s_nop 0
		v_mov_b64_e32 v[28:29], v[8:9]
		v_mov_b64_e32 v[30:31], v[40:41]
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v0, v45, v0, s0
		v_mov_b64_e32 v[28:29], v[48:49]
		v_mov_b64_e32 v[30:31], v[68:69]
		buffer_store_dwordx4 v[28:31], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v46, v0, s0
		v_mov_b64_e32 v[28:29], v[10:11]
		v_mov_b64_e32 v[30:31], v[42:43]
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		v_add3_u32 v1, v47, v0, s0
		v_mov_b64_e32 v[8:9], v[50:51]
		v_mov_b64_e32 v[10:11], v[70:71]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v54, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[20:21]
		v_mov_b64_e32 v[10:11], v[24:25]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v55, v0, s0
		v_mov_b64_e32 v[8:9], v[32:33]
		v_mov_b64_e32 v[10:11], v[36:37]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v56, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[22:23]
		v_mov_b64_e32 v[10:11], v[26:27]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v5, v0, s0
		v_mov_b64_e32 v[4:5], v[34:35]
		v_mov_b64_e32 v[6:7], v[38:39]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
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
    wave.regalloc.iterations: 100
    wave.regalloc.agpr.dwords: 396
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
