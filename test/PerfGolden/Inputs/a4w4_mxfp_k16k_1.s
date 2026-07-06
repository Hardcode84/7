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
		s_cselect_b32 s20, s1, 0
		s_add_i32 s0, s0, s20
		s_ashr_i32 s0, s0, 8
		s_add_i32 s20, s13, 0xff
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s20, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s20, s16, 7
		s_lshr_b32 s16, s16, 3
		s_mul_i32 s20, s20, 32
		s_add_i32 s16, s20, s16
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s20, 1, 0
		s_xor_b32 s21, s16, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s21, s16
		s_cselect_b32 s21, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s20, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s20, s20, s25
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s23, s26, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s20, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s26, s20
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s23
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s1, s16, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s16, s22, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s16, s22
		s_mul_i32 s16, s1, 4
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s0, s0, s22
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s22, s20, s24
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s20, s22, s20
		s_xor_b32 s22, s20, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s22, s20
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_mul_i32 s23, s22, s21
		s_mul_hi_u32 s23, s21, s23
		s_add_i32 s21, s21, s23
		s_mul_hi_u32 s21, s20, s21
		s_mul_i32 s21, s21, s0
		s_xor_b32 s21, s21, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s21, s20, s21
		s_cmp_ge_u32 s21, s0
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s21, s22
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s24, s21
		s_cmp_ge_u32 s21, s0
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s21, s22
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s24, s21
		s_add_i32 s16, s16, s21
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s20, s23
		s_mul_i32 s24, s23, s0
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s20, s20, s24
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s24, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s24, 1, 0
		s_add_i32 s22, s20, s22
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s20, s22, s20
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s20, s23, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s20, s23
		s_mul_i32 s16, s16, 0x100
		v_lshrrev_b32_e32 v1, 4, v0
		v_and_b32_e32 v2, 15, v1
		v_add_u32_e32 v3, 0x50, v2
		v_add_u32_e32 v8, 0x60, v2
		v_add_u32_e32 v9, 0x70, v2
		v_add_u32_e32 v10, 0x80, v2
		v_add_u32_e32 v11, 0x90, v2
		v_add_u32_e32 v12, 0xa0, v2
		v_add_u32_e32 v13, 0xb0, v2
		v_add_u32_e32 v14, 0xc0, v2
		v_add_u32_e32 v15, 0xd0, v2
		v_add_u32_e32 v16, 0xe0, v2
		v_add_u32_e32 v17, 0xf0, v2
		v_and_b32_e32 v18, 15, v0
		v_mov_b32_e32 v19, 8
		v_mul_lo_u32 v19, v19, v18
		s_mul_i32 s20, s0, 0x100
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		v_readfirstlane_b32 s2, v0
		s_mul_i32 s3, s1, s14
		s_lshl_b32 s3, s3, 10
		s_mul_i32 s4, s21, s14
		s_lshl_b32 s4, s4, 8
		s_add_i32 s5, s3, s4
		v_lshrrev_b32_e32 v18, 3, v0
		v_mul_lo_u32 v20, s14, v18
		v_lshlrev_b32_e32 v21, 4, v0
		v_and_b32_e32 v22, 0x7f, v21
		v_add3_u32 v23, s5, v20, v22
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		v_add_u32_e32 v23, s16, v2
		s_lshl_b32 s8, s14, 5
		s_add_i32 s9, s8, s3
		s_add_i32 s9, s9, s4
		v_add3_u32 v24, s9, v20, v22
		s_add_i32 m0, s2, 0x1000
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add3_u32 v24, 16, v2, s16
		s_lshl_b32 s10, s14, 6
		s_add_i32 s11, s10, s3
		s_add_i32 s11, s11, s4
		v_add3_u32 v25, s11, v20, v22
		s_add_i32 m0, s2, 0x2000
		s_nop 0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		v_add3_u32 v25, 32, v2, s16
		s_mul_i32 s22, 0x60, s14
		s_add_i32 s23, s22, s3
		s_add_i32 s23, s23, s4
		v_add3_u32 v26, s23, v20, v22
		s_add_i32 m0, s2, 0x3000
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		v_add3_u32 v26, 48, v2, s16
		s_lshl_b32 s40, s14, 7
		s_add_i32 s41, s40, s3
		s_add_i32 s41, s41, s4
		v_add3_u32 v27, s41, v20, v22
		s_add_i32 m0, s2, 0x4000
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		v_add3_u32 v2, 64, v2, s16
		s_mul_i32 s42, 0xa0, s14
		s_add_i32 s43, s42, s3
		s_add_i32 s43, s43, s4
		v_add3_u32 v27, s43, v20, v22
		s_add_i32 m0, s2, 0x5000
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s16, v3
		s_mul_i32 s44, 0xc0, s14
		s_add_i32 s45, s44, s3
		s_add_i32 s45, s45, s4
		v_add3_u32 v27, s45, v20, v22
		s_add_i32 m0, s2, 0x6000
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		v_add_u32_e32 v8, s16, v8
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s46, s14, s3
		s_add_i32 s46, s46, s4
		v_add3_u32 v27, s46, v20, v22
		s_add_i32 m0, s2, 0x7000
		s_nop 0
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		v_add_u32_e32 v9, s16, v9
		s_mul_i32 s47, s0, s15
		s_lshl_b32 s47, s47, 8
		v_mul_lo_u32 v27, s15, v18
		v_add3_u32 v28, s47, v27, v22
		s_add_i32 m0, s2, 0x10000
		s_nop 0
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_add_u32_e32 v10, s16, v10
		s_lshl_b32 s48, s15, 5
		s_add_i32 s49, s48, s47
		v_add3_u32 v28, s49, v27, v22
		s_add_i32 m0, s2, 0x11000
		s_nop 0
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_add_u32_e32 v11, s16, v11
		s_lshl_b32 s50, s15, 6
		s_add_i32 s51, s50, s47
		v_add3_u32 v28, s51, v27, v22
		s_add_i32 m0, s2, 0x12000
		s_nop 0
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_add_u32_e32 v12, s16, v12
		s_mul_i32 s52, 0x60, s15
		s_add_i32 s53, s52, s47
		v_add3_u32 v28, s53, v27, v22
		s_add_i32 m0, s2, 0x13000
		s_nop 0
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_add_u32_e32 v13, s16, v13
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s54, s1, s18
		s_lshl_b32 s54, s54, 10
		s_mul_i32 s55, s21, s18
		s_lshl_b32 s55, s55, 8
		s_add_i32 s56, s54, s55
		v_lshrrev_b32_e32 v28, 7, v0
		v_mul_lo_u32 v29, s18, v28
		v_lshlrev_b32_e32 v30, 7, v29
		v_and_b32_e32 v31, 1, v0
		v_mul_lo_u32 v32, s18, v31
		v_add3_u32 v33, s56, v30, v32
		v_lshrrev_b32_e32 v34, 6, v0
		v_and_b32_e32 v34, 1, v34
		v_mul_lo_u32 v35, s18, v34
		v_lshlrev_b32_e32 v36, 6, v35
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mul_lo_u32 v38, s18, v37
		v_lshlrev_b32_e32 v39, 5, v38
		v_add3_u32 v33, v33, v36, v39
		v_and_b32_e32 v40, 1, v1
		v_mul_lo_u32 v41, s18, v40
		v_lshlrev_b32_e32 v42, 4, v41
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v43, s18, v18
		v_lshlrev_b32_e32 v44, 3, v43
		v_add3_u32 v33, v33, v42, v44
		v_lshrrev_b32_e32 v45, 2, v0
		v_and_b32_e32 v45, 1, v45
		v_mul_lo_u32 v46, s18, v45
		v_lshlrev_b32_e32 v46, 2, v46
		v_lshrrev_b32_e32 v47, 1, v0
		v_and_b32_e32 v47, 1, v47
		v_mul_lo_u32 v48, s18, v47
		v_lshlrev_b32_e32 v48, 1, v48
		v_add3_u32 v33, v33, v46, v48
		buffer_load_dwordx2 v[50:51], v33, s[32:35], 0 offen
		s_mul_i32 s57, s0, s19
		s_lshl_b32 s57, s57, 8
		v_mul_lo_u32 v33, s19, v28
		v_lshlrev_b32_e32 v49, 6, v33
		v_mul_lo_u32 v52, s19, v34
		v_lshlrev_b32_e32 v53, 5, v52
		v_add3_u32 v54, s57, v49, v53
		v_mul_lo_u32 v55, s19, v37
		v_lshlrev_b32_e32 v56, 4, v55
		v_mul_lo_u32 v57, s19, v40
		v_lshlrev_b32_e32 v58, 3, v57
		v_add3_u32 v54, v54, v56, v58
		v_mul_lo_u32 v59, s19, v18
		v_lshlrev_b32_e32 v60, 2, v59
		v_mul_lo_u32 v61, s19, v45
		v_lshlrev_b32_e32 v61, 1, v61
		v_add3_u32 v54, v54, v60, v61
		v_mul_lo_u32 v62, s19, v47
		v_lshlrev_b32_e32 v63, 2, v31
		v_add3_u32 v54, v54, v62, v63
		buffer_load_dword v64, v54, s[36:39], 0 offen
		s_lshl_b32 s58, s15, 7
		s_add_i32 s59, s58, s47
		v_add3_u32 v54, s59, v27, v22
		s_add_i32 m0, s2, 0x18000
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		v_add_u32_e32 v14, s16, v14
		s_mul_i32 s60, 0xa0, s15
		s_add_i32 s61, s60, s47
		v_add3_u32 v54, s61, v27, v22
		s_add_i32 m0, s2, 0x19000
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		v_add_u32_e32 v15, s16, v15
		s_mul_i32 s62, 0xc0, s15
		s_add_i32 s63, s62, s47
		v_add3_u32 v54, s63, v27, v22
		s_add_i32 m0, s2, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		v_add_u32_e32 v16, s16, v16
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s64, s15, s47
		v_add3_u32 v54, s64, v27, v22
		s_add_i32 m0, s2, 0x1b000
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		v_add_u32_e32 v17, s16, v17
		s_lshl_b32 s16, s19, 7
		s_add_i32 s65, s16, s57
		v_lshlrev_b32_e32 v33, 4, v33
		v_lshlrev_b32_e32 v52, 3, v52
		v_add3_u32 v54, s65, v33, v52
		v_lshlrev_b32_e32 v55, 2, v55
		v_lshlrev_b32_e32 v57, 1, v57
		v_add3_u32 v54, v54, v55, v57
		v_add3_u32 v54, v54, v59, v31
		v_lshlrev_b32_e32 v65, 2, v45
		v_lshlrev_b32_e32 v66, 1, v47
		v_add3_u32 v54, v54, v65, v66
		v_lshlrev_b32_e32 v67, 4, v28
		v_lshlrev_b32_e32 v68, 3, v34
		v_lshlrev_b32_e32 v69, 2, v37
		v_add_u32_e32 v70, 32, v18
		v_lshlrev_b32_e32 v71, 1, v40
		v_xor_b32_e32 v70, v70, v71
		v_xor_b32_e32 v70, v69, v70
		v_xor_b32_e32 v70, v68, v70
		v_xor_b32_e32 v70, v67, v70
		v_mul_lo_u32 v72, s19, v70
		v_add3_u32 v73, s65, v72, v31
		v_add3_u32 v73, v73, v65, v66
		v_add_u32_e32 v74, 64, v18
		v_xor_b32_e32 v74, v74, v71
		v_xor_b32_e32 v74, v69, v74
		v_xor_b32_e32 v74, v68, v74
		v_xor_b32_e32 v74, v67, v74
		v_mul_lo_u32 v75, s19, v74
		v_add3_u32 v76, s65, v75, v31
		v_add3_u32 v76, v76, v65, v66
		v_add_u32_e32 v77, 0x60, v18
		v_xor_b32_e32 v77, v77, v71
		v_xor_b32_e32 v77, v69, v77
		v_xor_b32_e32 v77, v68, v77
		v_xor_b32_e32 v77, v67, v77
		v_mul_lo_u32 v78, s19, v77
		v_add3_u32 v79, s65, v78, v31
		v_add3_u32 v79, v79, v65, v66
		buffer_load_ubyte v80, v54, s[36:39], 0 offen
		buffer_load_ubyte v54, v73, s[36:39], 0 offen
		buffer_load_ubyte v73, v76, s[36:39], 0 offen
		buffer_load_ubyte v76, v79, s[36:39], 0 offen
		s_add_i32 s19, s3, 0x80
		s_add_i32 s19, s19, s4
		v_add3_u32 v79, s19, v20, v22
		s_add_i32 m0, s2, 0x8000
		s_nop 0
		buffer_load_dwordx4 v79, s[24:27], 0 offen lds
		v_add_u32_e32 v79, s20, v19
		s_add_i32 s8, s8, 0x80
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v81, s8, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s4
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v81, s10, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		s_add_i32 s22, s22, s3
		s_add_i32 s22, s22, s4
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v81, s22, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s40, s40, 0x80
		s_add_i32 s40, s40, s3
		s_add_i32 s40, s40, s4
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v81, s40, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s42, s42, 0x80
		s_add_i32 s42, s42, s3
		s_add_i32 s42, s42, s4
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v81, s42, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s44, s44, 0x80
		s_add_i32 s44, s44, s3
		s_add_i32 s44, s44, s4
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v81, s44, v20, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s4
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v81, s3, v20, v22
		s_add_i32 s4, s47, 0x80
		v_add3_u32 v82, s4, v27, v22
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s14, s48, 0x80
		s_add_i32 s14, s14, s47
		v_add3_u32 v81, s14, v27, v22
		v_lshlrev_b32_e32 v29, 4, v29
		v_lshlrev_b32_e32 v35, 3, v35
		buffer_load_dwordx4 v82, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s48, s50, 0x80
		s_add_i32 s48, s48, s47
		v_add3_u32 v82, s48, v27, v22
		v_lshlrev_b32_e32 v38, 2, v38
		buffer_load_dwordx4 v81, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s50, s52, 0x80
		s_add_i32 s50, s50, s47
		v_add3_u32 v81, s50, v27, v22
		v_lshlrev_b32_e32 v41, 1, v41
		buffer_load_dwordx4 v82, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s52, s54, 8
		s_add_i32 s52, s52, s55
		v_add3_u32 v82, s52, v29, v35
		v_add3_u32 v82, v82, v38, v41
		buffer_load_dwordx4 v81, s[28:31], 0 offen lds
		v_add3_u32 v81, v82, v43, v31
		v_add3_u32 v81, v81, v65, v66
		v_mul_lo_u32 v82, s18, v70
		v_add3_u32 v83, v31, v65, v66
		v_add3_u32 v84, v82, v83, s52
		v_mul_lo_u32 v85, s18, v74
		v_add3_u32 v86, v85, v83, s52
		v_mul_lo_u32 v87, s18, v77
		v_add3_u32 v83, v87, v83, s52
		v_add_u32_e32 v88, 0x80, v18
		v_xor_b32_e32 v88, v88, v71
		v_xor_b32_e32 v88, v69, v88
		v_xor_b32_e32 v88, v68, v88
		v_xor_b32_e32 v88, v67, v88
		v_mul_lo_u32 v89, s18, v88
		v_add3_u32 v90, s52, v89, v31
		v_add3_u32 v90, v90, v65, v66
		v_add_u32_e32 v91, 0xa0, v18
		v_xor_b32_e32 v91, v91, v71
		v_xor_b32_e32 v91, v69, v91
		v_xor_b32_e32 v91, v68, v91
		v_xor_b32_e32 v91, v67, v91
		v_mul_lo_u32 v92, s18, v91
		v_add3_u32 v93, s52, v92, v31
		v_add3_u32 v93, v93, v65, v66
		v_add_u32_e32 v94, 0xc0, v18
		v_xor_b32_e32 v94, v94, v71
		v_xor_b32_e32 v94, v69, v94
		v_xor_b32_e32 v94, v68, v94
		v_xor_b32_e32 v94, v67, v94
		v_mul_lo_u32 v95, s18, v94
		v_add3_u32 v96, s52, v95, v31
		v_add3_u32 v96, v96, v65, v66
		v_add_u32_e32 v97, 0xe0, v18
		v_xor_b32_e32 v71, v97, v71
		v_xor_b32_e32 v69, v69, v71
		v_xor_b32_e32 v68, v68, v69
		v_xor_b32_e32 v68, v67, v68
		v_mul_lo_u32 v69, s18, v68
		v_add3_u32 v71, s52, v69, v31
		v_add3_u32 v71, v71, v65, v66
		buffer_load_ubyte v97, v81, s[32:35], 0 offen
		buffer_load_ubyte v81, v84, s[32:35], 0 offen
		buffer_load_ubyte v84, v86, s[32:35], 0 offen
		buffer_load_ubyte v86, v83, s[32:35], 0 offen
		buffer_load_ubyte v83, v90, s[32:35], 0 offen
		buffer_load_ubyte v90, v93, s[32:35], 0 offen
		buffer_load_ubyte v93, v96, s[32:35], 0 offen
		buffer_load_ubyte v96, v71, s[32:35], 0 offen
		s_add_i32 s18, s57, 8
		v_add3_u32 v71, s18, v33, v52
		v_add3_u32 v71, v71, v55, v57
		v_add3_u32 v71, v71, v59, v31
		v_add3_u32 v71, v71, v65, v66
		v_add3_u32 v98, v31, v65, v66
		v_add3_u32 v99, v72, v98, s18
		v_add3_u32 v100, v75, v98, s18
		v_add3_u32 v98, v78, v98, s18
		buffer_load_ubyte v101, v71, s[36:39], 0 offen
		buffer_load_ubyte v71, v99, s[36:39], 0 offen
		buffer_load_ubyte v99, v100, s[36:39], 0 offen
		buffer_load_ubyte v100, v98, s[36:39], 0 offen
		s_add_i32 s54, s58, 0x80
		s_add_i32 s54, s54, s47
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v98, s54, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s55, s60, 0x80
		s_add_i32 s55, s55, s47
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v98, s55, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s58, s62, 0x80
		s_add_i32 s58, s58, s47
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v98, s58, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s47
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v98, s15, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s16, s16, 8
		s_add_i32 s16, s16, s57
		v_add3_u32 v98, s16, v33, v52
		v_add3_u32 v98, v98, v55, v57
		v_add3_u32 v98, v98, v59, v31
		v_add3_u32 v98, v98, v65, v66
		v_add3_u32 v102, v31, v65, v66
		v_add3_u32 v103, v72, v102, s16
		v_add3_u32 v104, v75, v102, s16
		v_add3_u32 v102, v78, v102, s16
		buffer_load_ubyte v105, v98, s[36:39], 0 offen
		buffer_load_ubyte v98, v103, s[36:39], 0 offen
		buffer_load_ubyte v103, v104, s[36:39], 0 offen
		buffer_load_ubyte v104, v102, s[36:39], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v102, 11, v28
		v_and_b32_e32 v106, 63, v0
		v_lshrrev_b32_e32 v107, 4, v106
		v_lshlrev_b32_e32 v107, 4, v107
		v_and_b32_e32 v106, 15, v106
		v_lshlrev_b32_e32 v106, 7, v106
		v_add3_u32 v102, v102, v107, v106
		ds_read_b128 a[0:3], v102
		ds_read_b128 a[4:7], v102 offset:64
		ds_read_b128 a[8:11], v102 offset:4096
		ds_read_b128 a[12:15], v102 offset:4160
		ds_read_b128 a[16:19], v102 offset:8192
		ds_read_b128 a[20:23], v102 offset:8256
		ds_read_b128 a[24:27], v102 offset:12288
		ds_read_b128 a[28:31], v102 offset:12352
		ds_read_b128 a[32:35], v102 offset:16384
		ds_read_b128 a[36:39], v102 offset:16448
		ds_read_b128 a[40:43], v102 offset:20480
		ds_read_b128 a[44:47], v102 offset:20544
		ds_read_b128 a[48:51], v102 offset:24576
		ds_read_b128 a[52:55], v102 offset:24640
		ds_read_b128 a[56:59], v102 offset:28672
		ds_read_b128 a[60:63], v102 offset:28736
		v_add_u32_e32 v107, 0x10000, v107
		v_lshlrev_b32_e32 v108, 11, v34
		v_add3_u32 v106, v107, v108, v106
		ds_read_b128 a[64:67], v106
		ds_read_b128 a[68:71], v106 offset:64
		ds_read_b128 a[72:75], v106 offset:4096
		ds_read_b128 a[76:79], v106 offset:4160
		ds_read_b128 a[80:83], v106 offset:8192
		ds_read_b128 a[84:87], v106 offset:8256
		ds_read_b128 a[88:91], v106 offset:12288
		ds_read_b128 a[92:95], v106 offset:12352
		v_lshlrev_b32_e32 v107, 3, v0
		v_add_u32_e32 v107, 0x20000, v107
		s_waitcnt vmcnt(41)
		ds_write_b64 v107, v[50:51]
		v_lshlrev_b32_e32 v50, 2, v0
		v_add_u32_e32 v50, 0x20000, v50
		v_lshlrev_b32_e32 v51, 7, v28
		v_add_u32_e32 v51, 0x20000, v51
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(40)
		ds_write_b32 v50, v64 offset:2048
		v_lshlrev_b32_e32 v64, 3, v31
		v_add_u32_e32 v51, v51, v64
		v_lshlrev_b32_e32 v108, 1, v37
		v_add_u32_e32 v109, v51, v108
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v110, 6, v18
		v_add3_u32 v109, v109, v40, v110
		v_lshlrev_b32_e32 v111, 5, v45
		v_lshlrev_b32_e32 v112, 4, v47
		v_add3_u32 v109, v109, v111, v112
		ds_read_u8 v113, v109
		v_add3_u32 v51, v51, v110, v111
		v_add_u32_e32 v114, 4, v40
		v_xor_b32_e32 v114, v114, v108
		v_add3_u32 v51, v51, v112, v114
		ds_read_u8 v115, v51
		v_add_u32_e32 v116, 0x20000, v108
		v_add_u32_e32 v116, v116, v40
		v_lshlrev_b32_e32 v117, 3, v18
		v_add_u32_e32 v118, 32, v31
		v_xor_b32_e32 v118, v118, v66
		v_xor_b32_e32 v118, v65, v118
		v_xor_b32_e32 v118, v117, v118
		v_xor_b32_e32 v119, v67, v118
		v_lshl_add_u32 v120, v119, 3, v116
		ds_read_u8 v121, v120
		v_add_u32_e32 v122, 0x20000, v114
		v_lshl_add_u32 v119, v119, 3, v122
		ds_read_u8 v123, v119
		v_add_u32_e32 v124, 64, v31
		v_xor_b32_e32 v124, v124, v66
		v_xor_b32_e32 v124, v65, v124
		v_xor_b32_e32 v124, v117, v124
		v_xor_b32_e32 v125, v67, v124
		v_lshl_add_u32 v126, v125, 3, v116
		ds_read_u8 v127, v126
		v_lshl_add_u32 v125, v125, 3, v122
		ds_read_u8 v128, v125
		v_add_u32_e32 v129, 0x60, v31
		v_xor_b32_e32 v129, v129, v66
		v_xor_b32_e32 v129, v65, v129
		v_xor_b32_e32 v129, v117, v129
		v_xor_b32_e32 v130, v67, v129
		v_lshl_add_u32 v131, v130, 3, v116
		ds_read_u8 v132, v131
		v_lshl_add_u32 v130, v130, 3, v122
		ds_read_u8 v133, v130
		v_add_u32_e32 v134, 0x80, v31
		v_xor_b32_e32 v134, v134, v66
		v_xor_b32_e32 v134, v65, v134
		v_xor_b32_e32 v134, v117, v134
		v_xor_b32_e32 v134, v67, v134
		v_lshl_add_u32 v135, v134, 3, v116
		ds_read_u8 v136, v135
		v_lshl_add_u32 v134, v134, 3, v122
		ds_read_u8 v137, v134
		v_add_u32_e32 v138, 0xa0, v31
		v_xor_b32_e32 v138, v138, v66
		v_xor_b32_e32 v138, v65, v138
		v_xor_b32_e32 v138, v117, v138
		v_xor_b32_e32 v138, v67, v138
		v_lshl_add_u32 v139, v138, 3, v116
		ds_read_u8 v140, v139
		v_lshl_add_u32 v138, v138, 3, v122
		ds_read_u8 v141, v138
		v_add_u32_e32 v142, 0xc0, v31
		v_xor_b32_e32 v142, v142, v66
		v_xor_b32_e32 v142, v65, v142
		v_xor_b32_e32 v142, v117, v142
		v_xor_b32_e32 v142, v67, v142
		v_lshl_add_u32 v143, v142, 3, v116
		ds_read_u8 v144, v143
		v_lshl_add_u32 v142, v142, 3, v122
		ds_read_u8 v145, v142
		v_add_u32_e32 v146, 0xe0, v31
		v_xor_b32_e32 v146, v146, v66
		v_xor_b32_e32 v146, v65, v146
		v_xor_b32_e32 v117, v117, v146
		v_xor_b32_e32 v67, v67, v117
		v_lshl_add_u32 v117, v67, 3, v116
		ds_read_u8 v146, v117
		v_lshl_add_u32 v67, v67, 3, v122
		ds_read_u8 v147, v67
		v_add_u32_e32 v64, 0x20000, v64
		v_lshl_add_u32 v64, v34, 7, v64
		v_add_u32_e32 v148, v64, v108
		v_add3_u32 v148, v148, v40, v110
		v_add3_u32 v148, v148, v111, v112
		ds_read_u8 v149, v148 offset:2048
		v_add3_u32 v64, v64, v110, v111
		v_add3_u32 v64, v64, v112, v114
		ds_read_u8 v110, v64 offset:2048
		v_lshlrev_b32_e32 v111, 4, v34
		v_xor_b32_e32 v112, v111, v118
		v_lshl_add_u32 v114, v112, 3, v116
		ds_read_u8 v118, v114 offset:2048
		v_lshl_add_u32 v112, v112, 3, v122
		ds_read_u8 v150, v112 offset:2048
		v_xor_b32_e32 v124, v111, v124
		v_lshl_add_u32 v151, v124, 3, v116
		ds_read_u8 v152, v151 offset:2048
		v_lshl_add_u32 v124, v124, 3, v122
		ds_read_u8 v153, v124 offset:2048
		v_xor_b32_e32 v111, v111, v129
		v_lshl_add_u32 v116, v111, 3, v116
		ds_read_u8 v129, v116 offset:2048
		v_lshl_add_u32 v111, v111, 3, v122
		ds_read_u8 v122, v111 offset:2048
		s_mov_b32 s60, 0x100
		s_mov_b32 s62, s60
		s_mov_b32 s60, 16
		s_mov_b32 s66, s60
		s_mov_b32 s60, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v154, 0x20000, v31
		v_add3_u32 v154, v154, v65, v66
		v_lshl_add_u32 v70, v70, 3, v154
		v_lshl_add_u32 v74, v74, 3, v154
		v_lshl_add_u32 v77, v77, 3, v154
		v_lshl_add_u32 v88, v88, 3, v154
		v_lshl_add_u32 v91, v91, 3, v154
		v_lshl_add_u32 v94, v94, 3, v154
		v_lshl_add_u32 v68, v68, 3, v154
		v_add3_u32 v154, v31, v65, v66
		v_add3_u32 v155, v31, v65, v66
		v_add3_u32 v156, v31, v65, v66
		v_add3_u32 v157, v31, v65, v66
		v_add3_u32 v158, v31, v65, v66
		s_mov_b32 s67, s62
		s_mov_b32 s68, s66
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_accvgpr_write_b32 a236, 0
		v_accvgpr_write_b32 a237, 0
		v_accvgpr_write_b32 a238, 0
		v_accvgpr_write_b32 a239, 0
		v_accvgpr_write_b32 a240, 0
		v_accvgpr_write_b32 a241, 0
		v_accvgpr_write_b32 a242, 0
		v_accvgpr_write_b32 a243, 0
		v_accvgpr_write_b32 a244, 0
		v_accvgpr_write_b32 a245, 0
		v_accvgpr_write_b32 a246, 0
		v_accvgpr_write_b32 a247, 0
		v_accvgpr_write_b32 a248, 0
		v_accvgpr_write_b32 a249, 0
		v_accvgpr_write_b32 a250, 0
		v_accvgpr_write_b32 a251, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v113, 0xff, v113
		v_and_b32_e32 v115, 0xff, v115
		v_lshlrev_b32_e32 v115, 8, v115
		v_or_b32_e32 v113, v113, v115
		v_and_b32_e32 v115, 0xff, v121
		v_lshlrev_b32_e32 v115, 16, v115
		v_and_b32_e32 v121, 0xff, v123
		v_lshlrev_b32_e32 v121, 24, v121
		v_or3_b32 v113, v113, v115, v121
		v_and_b32_e32 v115, 0xff, v127
		v_and_b32_e32 v121, 0xff, v128
		v_lshlrev_b32_e32 v121, 8, v121
		v_or_b32_e32 v115, v115, v121
		v_and_b32_e32 v121, 0xff, v132
		v_lshlrev_b32_e32 v121, 16, v121
		v_and_b32_e32 v123, 0xff, v133
		v_lshlrev_b32_e32 v123, 24, v123
		v_or3_b32 v115, v115, v121, v123
		v_and_b32_e32 v121, 0xff, v136
		v_and_b32_e32 v123, 0xff, v137
		v_lshlrev_b32_e32 v123, 8, v123
		v_or_b32_e32 v121, v121, v123
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v123, 0xff, v140
		v_lshlrev_b32_e32 v123, 16, v123
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v127, 0xff, v141
		v_lshlrev_b32_e32 v127, 24, v127
		v_or3_b32 v121, v121, v123, v127
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v123, 0xff, v144
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v127, 0xff, v145
		v_lshlrev_b32_e32 v127, 8, v127
		v_or_b32_e32 v123, v123, v127
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v127, 0xff, v146
		v_lshlrev_b32_e32 v127, 16, v127
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v128, 0xff, v147
		v_lshlrev_b32_e32 v128, 24, v128
		v_or3_b32 v123, v123, v127, v128
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v127, 0xff, v149
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v110, 0xff, v110
		v_lshlrev_b32_e32 v110, 8, v110
		v_or_b32_e32 v110, v127, v110
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v118, 0xff, v118
		v_lshlrev_b32_e32 v118, 16, v118
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v127, 0xff, v150
		v_lshlrev_b32_e32 v127, 24, v127
		v_or3_b32 v110, v110, v118, v127
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v118, 0xff, v152
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v127, 0xff, v153
		v_lshlrev_b32_e32 v127, 8, v127
		v_or_b32_e32 v118, v118, v127
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v127, 0xff, v129
		v_lshlrev_b32_e32 v127, 16, v127
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v122, 0xff, v122
		v_lshlrev_b32_e32 v122, 24, v122
		v_or3_b32 v118, v118, v127, v122
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[64:67], a[0:3], v[252:255], v110, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v110, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v110, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v110, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[68:71], a[4:7], v[252:255], v110, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v110, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v110, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v110, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v118, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v118, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v118, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v118, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v118, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v118, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v118, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v118, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v110, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v110, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v110, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v110, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v110, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v110, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v110, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v110, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v110, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v110, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v110, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v110, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v110, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v110, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v110, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v110, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v118, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v118, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v118, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v118, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[36:39], v[224:227], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[44:47], v[240:243], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[48:51], a[100:103], v118, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[48:51], a[104:107], v118, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[56:59], a[120:123], v118, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[56:59], a[116:119], v118, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[52:55], a[100:103], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[52:55], a[104:107], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[60:63], a[120:123], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[60:63], a[116:119], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v110, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[72:75], a[48:51], v[248:251], v110, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[56:59], a[112:115], v110, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[56:59], a[108:111], v110, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v110, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[52:55], v[248:251], v110, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[60:63], a[112:115], v110, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[60:63], a[108:111], v110, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v106 offset:32768
		ds_read_b128 a[68:71], v106 offset:32832
		ds_read_b128 a[72:75], v106 offset:36864
		ds_read_b128 a[76:79], v106 offset:36928
		ds_read_b128 a[80:83], v106 offset:40960
		ds_read_b128 a[84:87], v106 offset:41024
		ds_read_b128 a[88:91], v106 offset:45056
		ds_read_b128 v[144:147], v106 offset:45120
		s_waitcnt vmcnt(35)
		ds_write_b8 v0, v80 offset:2048
		s_waitcnt vmcnt(34)
		ds_write_b8 v70, v54 offset:2048
		s_waitcnt vmcnt(33)
		ds_write_b8 v74, v73 offset:2048
		s_waitcnt vmcnt(32)
		ds_write_b8 v77, v76 offset:2048
		s_add_i32 s69, s5, s62
		s_mov_b32 m0, s2
		v_add3_u32 v54, s69, v20, v22
		buffer_load_dwordx4 v54, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v54, v148 offset:2048
		ds_read_u8 v73, v64 offset:2048
		ds_read_u8 v76, v114 offset:2048
		ds_read_u8 v80, v112 offset:2048
		ds_read_u8 v110, v151 offset:2048
		ds_read_u8 v118, v124 offset:2048
		ds_read_u8 v122, v116 offset:2048
		ds_read_u8 v127, v111 offset:2048
		s_add_i32 s69, s9, s62
		s_add_i32 m0, s2, 0x1000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s11, s62
		s_add_i32 m0, s2, 0x2000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s23, s62
		s_add_i32 m0, s2, 0x3000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s41, s62
		s_add_i32 m0, s2, 0x4000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s43, s62
		s_add_i32 m0, s2, 0x5000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s45, s62
		s_add_i32 m0, s2, 0x6000
		v_add3_u32 v128, s69, v20, v22
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s69, s46, s62
		s_add_i32 m0, s2, 0x7000
		v_add3_u32 v128, s69, v20, v22
		s_add_i32 s69, s47, s67
		v_add3_u32 v129, s69, v27, v22
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v54, 0xff, v54
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v73, 0xff, v73
		v_lshlrev_b32_e32 v73, 8, v73
		v_or_b32_e32 v54, v54, v73
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v73, 0xff, v76
		v_lshlrev_b32_e32 v73, 16, v73
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x10000
		s_add_i32 s69, s49, s67
		v_add3_u32 v76, s69, v27, v22
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v80, 0xff, v80
		v_lshlrev_b32_e32 v80, 24, v80
		v_or3_b32 v54, v54, v73, v80
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v73, 0xff, v110
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v80, 0xff, v118
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v73, v73, v80
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v80, 0xff, v122
		v_lshlrev_b32_e32 v80, 16, v80
		buffer_load_dwordx4 v129, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x11000
		s_add_i32 s69, s51, s67
		v_add3_u32 v110, s69, v27, v22
		buffer_load_dwordx4 v76, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x12000
		s_add_i32 s69, s53, s67
		v_add3_u32 v76, s69, v27, v22
		buffer_load_dwordx4 v110, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x13000
		s_add_i32 s69, s56, s66
		v_add3_u32 v110, s69, v30, v32
		buffer_load_dwordx4 v76, s[28:31], 0 offen lds
		v_add3_u32 v76, v110, v36, v39
		v_add3_u32 v76, v76, v42, v44
		v_add3_u32 v76, v76, v46, v48
		buffer_load_dwordx2 v[128:129], v76, s[32:35], 0 offen
		s_add_i32 s69, s57, s68
		v_add3_u32 v76, s69, v49, v53
		v_add3_u32 v76, v76, v56, v58
		v_add3_u32 v76, v76, v60, v61
		v_add3_u32 v76, v76, v62, v63
		buffer_load_dword v110, v76, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v76, 0xff, v127
		v_lshlrev_b32_e32 v76, 24, v76
		v_or3_b32 v73, v73, v80, v76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[0:3], a[124:127], v54, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[0:3], a[128:131], v54, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[8:11], a[144:147], v54, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[8:11], a[140:143], v54, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[4:7], a[124:127], v54, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[4:7], a[128:131], v54, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[12:15], a[144:147], v54, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[12:15], a[140:143], v54, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[0:3], a[132:135], v73, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[0:3], a[136:139], v73, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[8:11], a[152:155], v73, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[8:11], a[148:151], v73, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[4:7], a[132:135], v73, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], a[4:7], a[136:139], v73, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], a[12:15], a[152:155], v73, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[12:15], a[148:151], v73, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[16:19], a[164:167], v73, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[16:19], a[168:171], v73, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[88:91], a[24:27], a[184:187], v73, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[80:83], a[24:27], a[180:183], v73, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[20:23], a[164:167], v73, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], a[20:23], a[168:171], v73, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], a[28:31], a[184:187], v73, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[28:31], a[180:183], v73, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[16:19], a[156:159], v54, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[16:19], a[160:163], v54, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[24:27], a[176:179], v54, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[24:27], a[172:175], v54, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[20:23], a[156:159], v54, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[20:23], a[160:163], v54, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[28:31], a[176:179], v54, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[28:31], a[172:175], v54, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[32:35], a[188:191], v54, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[32:35], a[192:195], v54, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[40:43], a[208:211], v54, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[40:43], a[204:207], v54, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[36:39], a[188:191], v54, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[36:39], a[192:195], v54, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[44:47], a[208:211], v54, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[44:47], a[204:207], v54, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[80:83], a[32:35], a[196:199], v73, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[88:91], a[32:35], a[200:203], v73, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[88:91], a[40:43], a[216:219], v73, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[80:83], a[40:43], a[212:215], v73, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[36:39], a[196:199], v73, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], a[36:39], a[200:203], v73, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], a[44:47], a[216:219], v73, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[44:47], a[212:215], v73, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[80:83], a[48:51], a[228:231], v73, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[88:91], a[48:51], a[232:235], v73, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[88:91], a[56:59], a[248:251], v73, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[80:83], a[56:59], a[244:247], v73, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[52:55], a[228:231], v73, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], a[52:55], a[232:235], v73, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], a[60:63], a[248:251], v73, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[84:87], a[60:63], a[244:247], v73, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[48:51], a[220:223], v54, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[48:51], a[224:227], v54, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[56:59], a[240:243], v54, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[56:59], a[236:239], v54, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[52:55], a[220:223], v54, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[52:55], a[224:227], v54, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[76:79], a[60:63], a[240:243], v54, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[68:71], a[60:63], a[236:239], v54, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v102 offset:32768
		ds_read_b128 a[4:7], v102 offset:32832
		ds_read_b128 a[8:11], v102 offset:36864
		ds_read_b128 a[12:15], v102 offset:36928
		ds_read_b128 a[16:19], v102 offset:40960
		ds_read_b128 a[20:23], v102 offset:41024
		ds_read_b128 a[24:27], v102 offset:45056
		ds_read_b128 a[28:31], v102 offset:45120
		ds_read_b128 a[32:35], v102 offset:49152
		ds_read_b128 a[36:39], v102 offset:49216
		ds_read_b128 a[40:43], v102 offset:53248
		ds_read_b128 a[44:47], v102 offset:53312
		ds_read_b128 a[48:51], v102 offset:57344
		ds_read_b128 a[52:55], v102 offset:57408
		ds_read_b128 a[56:59], v102 offset:61440
		ds_read_b128 a[60:63], v102 offset:61504
		ds_read_b128 a[64:67], v106 offset:16384
		ds_read_b128 a[68:71], v106 offset:16448
		ds_read_b128 a[72:75], v106 offset:20480
		ds_read_b128 a[76:79], v106 offset:20544
		ds_read_b128 a[80:83], v106 offset:24576
		ds_read_b128 a[84:87], v106 offset:24640
		ds_read_b128 a[88:91], v106 offset:28672
		ds_read_b128 v[144:147], v106 offset:28736
		s_waitcnt vmcnt(33)
		ds_write_b8 v0, v97
		s_waitcnt vmcnt(32)
		ds_write_b8 v70, v81
		s_waitcnt vmcnt(31)
		ds_write_b8 v74, v84
		s_waitcnt vmcnt(30)
		ds_write_b8 v77, v86
		s_waitcnt vmcnt(29)
		ds_write_b8 v88, v83
		s_waitcnt vmcnt(28)
		ds_write_b8 v91, v90
		s_waitcnt vmcnt(27)
		ds_write_b8 v94, v93
		s_waitcnt vmcnt(26)
		ds_write_b8 v68, v96
		s_add_i32 s69, s59, s67
		s_add_i32 m0, s2, 0x18000
		v_add3_u32 v54, s69, v27, v22
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(26)
		ds_write_b8 v0, v101 offset:2048
		s_waitcnt vmcnt(25)
		ds_write_b8 v70, v71 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v74, v99 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v77, v100 offset:2048
		s_add_i32 s69, s61, s67
		s_add_i32 m0, s2, 0x19000
		v_add3_u32 v54, s69, v27, v22
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v71, v109
		ds_read_u8 v81, v51
		ds_read_u8 v83, v120
		ds_read_u8 v84, v119
		ds_read_u8 v86, v126
		ds_read_u8 v90, v125
		ds_read_u8 v93, v131
		ds_read_u8 v96, v130
		ds_read_u8 v97, v135
		ds_read_u8 v99, v134
		ds_read_u8 v100, v139
		ds_read_u8 v101, v138
		ds_read_u8 v113, v143
		ds_read_u8 v115, v142
		ds_read_u8 v118, v117
		ds_read_u8 v121, v67
		ds_read_u8 v122, v148 offset:2048
		ds_read_u8 v123, v64 offset:2048
		ds_read_u8 v127, v114 offset:2048
		ds_read_u8 v132, v112 offset:2048
		ds_read_u8 v133, v151 offset:2048
		ds_read_u8 v136, v124 offset:2048
		ds_read_u8 v137, v116 offset:2048
		ds_read_u8 v140, v111 offset:2048
		s_add_i32 s69, s63, s67
		s_add_i32 m0, s2, 0x1a000
		v_add3_u32 v54, s69, v27, v22
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_add_i32 s69, s64, s67
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v54, s69, v27, v22
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_add_i32 s69, s65, s68
		v_add3_u32 v54, s69, v33, v52
		v_add3_u32 v54, v54, v55, v57
		v_add3_u32 v54, v54, v59, v31
		v_add3_u32 v54, v54, v65, v66
		v_add3_u32 v73, v72, v154, s69
		v_add3_u32 v76, v75, v154, s69
		v_add3_u32 v141, v78, v154, s69
		buffer_load_ubyte v80, v54, s[36:39], 0 offen
		buffer_load_ubyte v54, v73, s[36:39], 0 offen
		buffer_load_ubyte v73, v76, s[36:39], 0 offen
		buffer_load_ubyte v76, v141, s[36:39], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v71, 0xff, v71
		v_and_b32_e32 v81, 0xff, v81
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		v_and_b32_e32 v81, 0xff, v83
		v_lshlrev_b32_e32 v81, 16, v81
		v_and_b32_e32 v83, 0xff, v84
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v141, v71, v81, v83
		v_and_b32_e32 v71, 0xff, v86
		v_and_b32_e32 v81, 0xff, v90
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		v_and_b32_e32 v81, 0xff, v93
		v_lshlrev_b32_e32 v81, 16, v81
		v_and_b32_e32 v83, 0xff, v96
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v149, v71, v81, v83
		v_and_b32_e32 v71, 0xff, v97
		v_and_b32_e32 v81, 0xff, v99
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v81, 0xff, v100
		v_lshlrev_b32_e32 v81, 16, v81
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v83, 0xff, v101
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v150, v71, v81, v83
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v71, 0xff, v113
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v81, 0xff, v115
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v81, 0xff, v118
		v_lshlrev_b32_e32 v81, 16, v81
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v83, 0xff, v121
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v113, v71, v81, v83
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v71, 0xff, v122
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v81, 0xff, v123
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v81, 0xff, v127
		v_lshlrev_b32_e32 v81, 16, v81
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v83, 0xff, v132
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v71, v71, v81, v83
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v81, 0xff, v133
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v83, 0xff, v136
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v81, v81, v83
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v83, 0xff, v137
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v84, 0xff, v140
		v_lshlrev_b32_e32 v84, 24, v84
		v_or3_b32 v81, v81, v83, v84
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[64:67], a[0:3], v[252:255], v71, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v71, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v71, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v71, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[68:71], a[4:7], v[252:255], v71, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v71, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v71, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v71, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v81, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v81, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v81, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v81, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v81, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[144:147], a[4:7], v[160:163], v81, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[144:147], a[12:15], v[176:179], v81, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v81, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v81, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v81, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v81, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v81, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v81, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[144:147], a[20:23], v[192:195], v81, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[144:147], a[28:31], v[208:211], v81, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v81, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v71, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v71, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v71, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v71, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v71, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v71, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v71, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v71, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v71, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v71, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v71, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v71, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v71, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v71, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v71, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v71, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v81, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v81, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v81, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v81, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v81, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[144:147], a[36:39], v[224:227], v81, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[144:147], a[44:47], v[240:243], v81, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v81, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[48:51], a[100:103], v81, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[48:51], a[104:107], v81, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[56:59], a[120:123], v81, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[56:59], a[116:119], v81, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[52:55], a[100:103], v81, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], a[52:55], a[104:107], v81, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], a[60:63], a[120:123], v81, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[60:63], a[116:119], v81, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v71, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[72:75], a[48:51], v[248:251], v71, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[56:59], a[112:115], v71, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[56:59], a[108:111], v71, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v71, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[52:55], v[248:251], v71, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[60:63], a[112:115], v71, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[60:63], a[108:111], v71, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v106 offset:49152
		ds_read_b128 a[68:71], v106 offset:49216
		ds_read_b128 a[72:75], v106 offset:53248
		ds_read_b128 a[76:79], v106 offset:53312
		ds_read_b128 a[80:83], v106 offset:57344
		ds_read_b128 a[84:87], v106 offset:57408
		ds_read_b128 a[88:91], v106 offset:61440
		ds_read_b128 v[144:147], v106 offset:61504
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v105 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v70, v98 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v74, v103 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v77, v104 offset:2048
		s_add_i32 s69, s19, s62
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v71, s69, v20, v22
		buffer_load_dwordx4 v71, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v71, v148 offset:2048
		ds_read_u8 v81, v64 offset:2048
		ds_read_u8 v83, v114 offset:2048
		ds_read_u8 v84, v112 offset:2048
		ds_read_u8 v86, v151 offset:2048
		ds_read_u8 v90, v124 offset:2048
		ds_read_u8 v93, v116 offset:2048
		ds_read_u8 v98, v111 offset:2048
		s_add_i32 s69, s8, s62
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s10, s62
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s22, s62
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s40, s62
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s42, s62
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s44, s62
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v96, s69, v20, v22
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s3, s62
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v96, s69, v20, v22
		s_add_i32 s69, s4, s67
		v_add3_u32 v97, s69, v27, v22
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v71, 0xff, v71
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v81, 0xff, v81
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v71, v71, v81
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v81, 0xff, v83
		v_lshlrev_b32_e32 v81, 16, v81
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s69, s14, s67
		v_add3_u32 v83, s69, v27, v22
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v84, 0xff, v84
		v_lshlrev_b32_e32 v84, 24, v84
		v_or3_b32 v103, v71, v81, v84
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v71, 0xff, v86
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v81, 0xff, v90
		v_lshlrev_b32_e32 v81, 8, v81
		v_or_b32_e32 v104, v71, v81
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v71, 0xff, v93
		v_lshlrev_b32_e32 v105, 16, v71
		buffer_load_dwordx4 v97, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s69, s48, s67
		v_add3_u32 v71, s69, v27, v22
		buffer_load_dwordx4 v83, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s69, s50, s67
		v_add3_u32 v81, s69, v27, v22
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s69, s52, s66
		v_add3_u32 v71, s69, v29, v35
		buffer_load_dwordx4 v81, s[28:31], 0 offen lds
		v_add3_u32 v71, v71, v38, v41
		v_add3_u32 v71, v71, v43, v31
		v_add3_u32 v71, v71, v65, v66
		v_add3_u32 v81, s69, v82, v31
		v_add3_u32 v83, v81, v65, v66
		v_add3_u32 v86, v85, v155, s69
		v_add3_u32 v90, v87, v155, s69
		v_add3_u32 v93, v89, v155, s69
		v_add3_u32 v96, v92, v156, s69
		v_add3_u32 v99, v95, v156, s69
		v_add3_u32 v100, v69, v156, s69
		buffer_load_ubyte v97, v71, s[32:35], 0 offen
		buffer_load_ubyte v81, v83, s[32:35], 0 offen
		buffer_load_ubyte v84, v86, s[32:35], 0 offen
		buffer_load_ubyte v86, v90, s[32:35], 0 offen
		buffer_load_ubyte v83, v93, s[32:35], 0 offen
		buffer_load_ubyte v90, v96, s[32:35], 0 offen
		buffer_load_ubyte v93, v99, s[32:35], 0 offen
		buffer_load_ubyte v96, v100, s[32:35], 0 offen
		s_add_i32 s69, s18, s68
		v_add3_u32 v71, s69, v33, v52
		v_add3_u32 v71, v71, v55, v57
		v_add3_u32 v71, v71, v59, v31
		v_add3_u32 v71, v71, v65, v66
		v_add3_u32 v99, v72, v157, s69
		v_add3_u32 v100, v75, v157, s69
		v_add3_u32 v115, v78, v157, s69
		buffer_load_ubyte v101, v71, s[36:39], 0 offen
		buffer_load_ubyte v71, v99, s[36:39], 0 offen
		buffer_load_ubyte v99, v100, s[36:39], 0 offen
		buffer_load_ubyte v100, v115, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v98, 0xff, v98
		v_lshlrev_b32_e32 v98, 24, v98
		v_or3_b32 v98, v104, v105, v98
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[0:3], a[124:127], v103, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[0:3], a[128:131], v103, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[8:11], a[144:147], v103, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[8:11], a[140:143], v103, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[4:7], a[124:127], v103, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[4:7], a[128:131], v103, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[12:15], a[144:147], v103, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[12:15], a[140:143], v103, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[0:3], a[132:135], v98, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[0:3], a[136:139], v98, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[8:11], a[152:155], v98, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[8:11], a[148:151], v98, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[4:7], a[132:135], v98, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], a[4:7], a[136:139], v98, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], a[12:15], a[152:155], v98, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[12:15], a[148:151], v98, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[16:19], a[164:167], v98, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[16:19], a[168:171], v98, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[88:91], a[24:27], a[184:187], v98, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[80:83], a[24:27], a[180:183], v98, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[20:23], a[164:167], v98, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], a[20:23], a[168:171], v98, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], a[28:31], a[184:187], v98, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[28:31], a[180:183], v98, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[16:19], a[156:159], v103, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[16:19], a[160:163], v103, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[24:27], a[176:179], v103, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[24:27], a[172:175], v103, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[20:23], a[156:159], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[20:23], a[160:163], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[28:31], a[176:179], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[28:31], a[172:175], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[32:35], a[188:191], v103, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[32:35], a[192:195], v103, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[40:43], a[208:211], v103, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[40:43], a[204:207], v103, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[36:39], a[188:191], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[36:39], a[192:195], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[44:47], a[208:211], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[44:47], a[204:207], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[80:83], a[32:35], a[196:199], v98, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[88:91], a[32:35], a[200:203], v98, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[88:91], a[40:43], a[216:219], v98, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[80:83], a[40:43], a[212:215], v98, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[36:39], a[196:199], v98, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], a[36:39], a[200:203], v98, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], a[44:47], a[216:219], v98, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[44:47], a[212:215], v98, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[80:83], a[48:51], a[228:231], v98, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[88:91], a[48:51], a[232:235], v98, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[88:91], a[56:59], a[248:251], v98, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[80:83], a[56:59], a[244:247], v98, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[52:55], a[228:231], v98, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], a[52:55], a[232:235], v98, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], a[60:63], a[248:251], v98, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[84:87], a[60:63], a[244:247], v98, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[48:51], a[220:223], v103, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[48:51], a[224:227], v103, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[56:59], a[240:243], v103, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[56:59], a[236:239], v103, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[52:55], a[220:223], v103, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[52:55], a[224:227], v103, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[76:79], a[60:63], a[240:243], v103, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[68:71], a[60:63], a[236:239], v103, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v102
		ds_read_b128 a[4:7], v102 offset:64
		ds_read_b128 a[8:11], v102 offset:4096
		ds_read_b128 a[12:15], v102 offset:4160
		ds_read_b128 a[16:19], v102 offset:8192
		ds_read_b128 a[20:23], v102 offset:8256
		ds_read_b128 a[24:27], v102 offset:12288
		ds_read_b128 a[28:31], v102 offset:12352
		ds_read_b128 a[32:35], v102 offset:16384
		ds_read_b128 a[36:39], v102 offset:16448
		ds_read_b128 a[40:43], v102 offset:20480
		ds_read_b128 a[44:47], v102 offset:20544
		ds_read_b128 a[48:51], v102 offset:24576
		ds_read_b128 a[52:55], v102 offset:24640
		ds_read_b128 a[56:59], v102 offset:28672
		ds_read_b128 a[60:63], v102 offset:28736
		ds_read_b128 a[64:67], v106
		ds_read_b128 a[68:71], v106 offset:64
		ds_read_b128 a[72:75], v106 offset:4096
		ds_read_b128 a[76:79], v106 offset:4160
		ds_read_b128 a[80:83], v106 offset:8192
		ds_read_b128 a[84:87], v106 offset:8256
		ds_read_b128 a[88:91], v106 offset:12288
		ds_read_b128 a[92:95], v106 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v107, v[128:129]
		s_add_i32 s69, s54, s67
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v98, s69, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(33)
		ds_write_b32 v50, v110 offset:2048
		s_add_i32 s69, s55, s67
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v98, s69, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v113, v109
		ds_read_u8 v115, v51
		ds_read_u8 v121, v120
		ds_read_u8 v123, v119
		ds_read_u8 v127, v126
		ds_read_u8 v128, v125
		ds_read_u8 v132, v131
		ds_read_u8 v133, v130
		ds_read_u8 v136, v135
		ds_read_u8 v137, v134
		ds_read_u8 v140, v139
		ds_read_u8 v141, v138
		ds_read_u8 v144, v143
		ds_read_u8 v145, v142
		ds_read_u8 v146, v117
		ds_read_u8 v147, v67
		ds_read_u8 v149, v148 offset:2048
		ds_read_u8 v110, v64 offset:2048
		ds_read_u8 v118, v114 offset:2048
		ds_read_u8 v150, v112 offset:2048
		ds_read_u8 v152, v151 offset:2048
		ds_read_u8 v153, v124 offset:2048
		ds_read_u8 v129, v116 offset:2048
		ds_read_u8 v122, v111 offset:2048
		s_add_i32 s69, s58, s67
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v98, s69, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s69, s15, s67
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v98, s69, v27, v22
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		s_add_i32 s69, s16, s68
		v_add3_u32 v98, s69, v33, v52
		v_add3_u32 v98, v98, v55, v57
		v_add3_u32 v98, v98, v59, v31
		v_add3_u32 v98, v98, v65, v66
		v_add3_u32 v103, v72, v158, s69
		v_add3_u32 v104, v75, v158, s69
		v_add3_u32 v159, v78, v158, s69
		buffer_load_ubyte v105, v98, s[36:39], 0 offen
		buffer_load_ubyte v98, v103, s[36:39], 0 offen
		buffer_load_ubyte v103, v104, s[36:39], 0 offen
		buffer_load_ubyte v104, v159, s[36:39], 0 offen
		s_add_i32 s62, s62, 0x100
		s_add_i32 s67, s67, 0x100
		s_add_i32 s66, s66, 16
		s_add_i32 s68, s68, 16
		s_add_i32 s60, s60, 2
		s_cmp_lt_i32 s60, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		s_waitcnt vmcnt(4)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v20, 0xff, v113
		v_and_b32_e32 v22, 0xff, v115
		v_lshlrev_b32_e32 v22, 8, v22
		v_or_b32_e32 v20, v20, v22
		v_and_b32_e32 v22, 0xff, v121
		v_lshlrev_b32_e32 v22, 16, v22
		v_and_b32_e32 v27, 0xff, v123
		v_lshlrev_b32_e32 v27, 24, v27
		v_or3_b32 v20, v20, v22, v27
		v_and_b32_e32 v22, 0xff, v127
		v_and_b32_e32 v27, 0xff, v128
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v22, v22, v27
		v_and_b32_e32 v27, 0xff, v132
		v_lshlrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v29, 0xff, v133
		v_lshlrev_b32_e32 v29, 24, v29
		v_or3_b32 v22, v22, v27, v29
		v_and_b32_e32 v27, 0xff, v136
		v_and_b32_e32 v29, 0xff, v137
		v_lshlrev_b32_e32 v29, 8, v29
		v_or_b32_e32 v27, v27, v29
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v29, 0xff, v140
		v_lshlrev_b32_e32 v29, 16, v29
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v30, 0xff, v141
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v29, v30
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v29, 0xff, v144
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v30, 0xff, v145
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v29, v29, v30
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v30, 0xff, v146
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v32, 0xff, v147
		v_lshlrev_b32_e32 v32, 24, v32
		v_or3_b32 v29, v29, v30, v32
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v30, 0xff, v149
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v32, 0xff, v110
		v_lshlrev_b32_e32 v32, 8, v32
		v_or_b32_e32 v30, v30, v32
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v32, 0xff, v118
		v_lshlrev_b32_e32 v32, 16, v32
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v33, 0xff, v150
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v30, v30, v32, v33
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v32, 0xff, v152
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v33, 0xff, v153
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v32, v32, v33
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v33, 0xff, v129
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v35, 0xff, v122
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v32, v32, v33, v35
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[64:67], a[0:3], v[252:255], v30, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v30, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v30, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v30, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[68:71], a[4:7], v[252:255], v30, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v30, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v30, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v30, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v32, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v32, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v32, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v32, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v32, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v32, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v32, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v32, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v32, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v32, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v32, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v32, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v32, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v32, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v32, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v32, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v30, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v30, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v30, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v30, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v30, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v30, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v30, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v30, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v30, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v30, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v30, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v30, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v30, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v30, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v30, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v30, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v32, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v32, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v32, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v32, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v32, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[36:39], v[224:227], v32, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[44:47], v[240:243], v32, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v32, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[48:51], a[100:103], v32, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[48:51], a[104:107], v32, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[56:59], a[120:123], v32, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[56:59], a[116:119], v32, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[52:55], a[100:103], v32, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[52:55], a[104:107], v32, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[60:63], a[120:123], v32, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[60:63], a[116:119], v32, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v30, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[72:75], a[48:51], v[248:251], v30, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[56:59], a[112:115], v30, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[56:59], a[108:111], v30, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[52:55], v[248:251], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[60:63], a[112:115], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[60:63], a[108:111], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v106 offset:32768
		ds_read_b128 a[68:71], v106 offset:32832
		ds_read_b128 v[56:59], v106 offset:36864
		ds_read_b128 a[72:75], v106 offset:36928
		ds_read_b128 v[60:63], v106 offset:40960
		ds_read_b128 v[144:147], v106 offset:41024
		ds_read_b128 v[152:155], v106 offset:45056
		ds_read_b128 v[156:159], v106 offset:45120
		ds_write_b8 v0, v80 offset:2048
		ds_write_b8 v70, v54 offset:2048
		ds_write_b8 v74, v73 offset:2048
		ds_write_b8 v77, v76 offset:2048
		v_cmp_lt_i32_e64 vcc, v23, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v24, s12
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v25, s12
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v26, s12
		s_mov_b64 s[14:15], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v23, v148 offset:2048
		ds_read_u8 v24, v64 offset:2048
		ds_read_u8 v25, v114 offset:2048
		ds_read_u8 v26, v112 offset:2048
		ds_read_u8 v30, v151 offset:2048
		ds_read_u8 v32, v124 offset:2048
		ds_read_u8 v33, v116 offset:2048
		ds_read_u8 v35, v111 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v23, 0xff, v23
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v24, 0xff, v24
		v_lshlrev_b32_e32 v24, 8, v24
		v_or_b32_e32 v23, v23, v24
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v24, 0xff, v25
		v_lshlrev_b32_e32 v24, 16, v24
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v25, 0xff, v26
		v_lshlrev_b32_e32 v25, 24, v25
		v_or3_b32 v23, v23, v24, v25
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v24, 0xff, v30
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v25, 0xff, v32
		v_lshlrev_b32_e32 v25, 8, v25
		v_or_b32_e32 v24, v24, v25
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v25, 0xff, v33
		v_lshlrev_b32_e32 v25, 16, v25
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v26, 0xff, v35
		v_lshlrev_b32_e32 v26, 24, v26
		v_or3_b32 v24, v24, v25, v26
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[0:3], a[124:127], v23, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], a[0:3], a[128:131], v23, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], a[8:11], a[144:147], v23, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[8:11], a[140:143], v23, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[4:7], a[124:127], v23, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[4:7], a[128:131], v23, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[12:15], a[144:147], v23, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[12:15], a[140:143], v23, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[0:3], a[132:135], v24, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[152:155], a[0:3], a[136:139], v24, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[152:155], a[8:11], a[152:155], v24, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[8:11], a[148:151], v24, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[144:147], a[4:7], a[132:135], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[156:159], a[4:7], a[136:139], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[156:159], a[12:15], a[152:155], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[144:147], a[12:15], a[148:151], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[16:19], a[164:167], v24, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[152:155], a[16:19], a[168:171], v24, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[152:155], a[24:27], a[184:187], v24, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[60:63], a[24:27], a[180:183], v24, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[144:147], a[20:23], a[164:167], v24, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[156:159], a[20:23], a[168:171], v24, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[156:159], a[28:31], a[184:187], v24, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[144:147], a[28:31], a[180:183], v24, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[16:19], a[156:159], v23, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], a[16:19], a[160:163], v23, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[56:59], a[24:27], a[176:179], v23, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[24:27], a[172:175], v23, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[20:23], a[156:159], v23, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[20:23], a[160:163], v23, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[28:31], a[176:179], v23, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[28:31], a[172:175], v23, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[32:35], a[188:191], v23, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], a[32:35], a[192:195], v23, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], a[40:43], a[208:211], v23, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[40:43], a[204:207], v23, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[36:39], a[188:191], v23, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[36:39], a[192:195], v23, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[44:47], a[208:211], v23, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[44:47], a[204:207], v23, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], a[32:35], a[196:199], v24, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[152:155], a[32:35], a[200:203], v24, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[152:155], a[40:43], a[216:219], v24, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[60:63], a[40:43], a[212:215], v24, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[144:147], a[36:39], a[196:199], v24, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[156:159], a[36:39], a[200:203], v24, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[156:159], a[44:47], a[216:219], v24, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[144:147], a[44:47], a[212:215], v24, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[60:63], a[48:51], a[228:231], v24, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[152:155], a[48:51], a[232:235], v24, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[152:155], a[56:59], a[248:251], v24, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[60:63], a[56:59], a[244:247], v24, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[144:147], a[52:55], a[228:231], v24, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[156:159], a[52:55], a[232:235], v24, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[156:159], a[60:63], a[248:251], v24, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[144:147], a[60:63], a[244:247], v24, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[48:51], a[220:223], v23, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[56:59], a[48:51], a[224:227], v23, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[56:59], a[56:59], a[240:243], v23, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[56:59], a[236:239], v23, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[52:55], a[220:223], v23, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[52:55], a[224:227], v23, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[60:63], a[240:243], v23, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[68:71], a[60:63], a[236:239], v23, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v102 offset:32768
		ds_read_b128 a[4:7], v102 offset:32832
		ds_read_b128 a[8:11], v102 offset:36864
		ds_read_b128 a[12:15], v102 offset:36928
		ds_read_b128 a[16:19], v102 offset:40960
		ds_read_b128 a[20:23], v102 offset:41024
		ds_read_b128 a[24:27], v102 offset:45056
		ds_read_b128 a[28:31], v102 offset:45120
		ds_read_b128 a[32:35], v102 offset:49152
		ds_read_b128 a[36:39], v102 offset:49216
		ds_read_b128 a[40:43], v102 offset:53248
		ds_read_b128 a[44:47], v102 offset:53312
		ds_read_b128 a[48:51], v102 offset:57344
		ds_read_b128 a[52:55], v102 offset:57408
		ds_read_b128 a[56:59], v102 offset:61440
		ds_read_b128 a[60:63], v102 offset:61504
		ds_read_b128 v[24:27], v106 offset:16384
		ds_read_b128 a[64:67], v106 offset:16448
		ds_read_b128 v[52:55], v106 offset:20480
		ds_read_b128 v[56:59], v106 offset:20544
		ds_read_b128 v[60:63], v106 offset:24576
		ds_read_b128 v[144:147], v106 offset:24640
		ds_read_b128 v[152:155], v106 offset:28672
		ds_read_b128 v[156:159], v106 offset:28736
		ds_write_b8 v0, v97
		ds_write_b8 v70, v81
		ds_write_b8 v74, v84
		ds_write_b8 v77, v86
		ds_write_b8 v88, v83
		ds_write_b8 v91, v90
		ds_write_b8 v94, v93
		ds_write_b8 v68, v96
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[26:27], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v101 offset:2048
		ds_write_b8 v70, v71 offset:2048
		ds_write_b8 v74, v99 offset:2048
		ds_write_b8 v77, v100 offset:2048
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[28:29], vcc
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v12, s12
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v13, s12
		s_mov_b64 s[34:35], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v2, v109
		ds_read_u8 v3, v51
		ds_read_u8 v8, v120
		ds_read_u8 v9, v119
		ds_read_u8 v10, v126
		ds_read_u8 v11, v125
		ds_read_u8 v12, v131
		ds_read_u8 v13, v130
		ds_read_u8 v20, v135
		ds_read_u8 v22, v134
		ds_read_u8 v23, v139
		ds_read_u8 v29, v138
		ds_read_u8 v30, v143
		ds_read_u8 v32, v142
		ds_read_u8 v33, v117
		ds_read_u8 v35, v67
		ds_read_u8 v36, v148 offset:2048
		ds_read_u8 v38, v64 offset:2048
		ds_read_u8 v39, v114 offset:2048
		ds_read_u8 v41, v112 offset:2048
		ds_read_u8 v42, v151 offset:2048
		ds_read_u8 v43, v124 offset:2048
		ds_read_u8 v44, v116 offset:2048
		ds_read_u8 v46, v111 offset:2048
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v2, 0xff, v2
		v_and_b32_e32 v3, 0xff, v3
		v_lshlrev_b32_e32 v3, 8, v3
		v_or_b32_e32 v2, v2, v3
		v_and_b32_e32 v3, 0xff, v8
		v_lshlrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v8, 0xff, v9
		v_lshlrev_b32_e32 v8, 24, v8
		v_or3_b32 v2, v2, v3, v8
		v_and_b32_e32 v3, 0xff, v10
		v_and_b32_e32 v8, 0xff, v11
		v_lshlrev_b32_e32 v8, 8, v8
		v_or_b32_e32 v3, v3, v8
		v_and_b32_e32 v8, 0xff, v12
		v_lshlrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v9, 0xff, v13
		v_lshlrev_b32_e32 v9, 24, v9
		v_or3_b32 v3, v3, v8, v9
		v_and_b32_e32 v8, 0xff, v20
		v_and_b32_e32 v9, 0xff, v22
		v_lshlrev_b32_e32 v9, 8, v9
		v_or_b32_e32 v8, v8, v9
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v9, 0xff, v23
		v_lshlrev_b32_e32 v9, 16, v9
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v10, 0xff, v29
		v_lshlrev_b32_e32 v10, 24, v10
		v_or3_b32 v8, v8, v9, v10
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v9, 0xff, v30
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v10, 0xff, v32
		v_lshlrev_b32_e32 v10, 8, v10
		v_or_b32_e32 v9, v9, v10
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v10, 0xff, v33
		v_lshlrev_b32_e32 v10, 16, v10
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v11, 0xff, v35
		v_lshlrev_b32_e32 v11, 24, v11
		v_or3_b32 v9, v9, v10, v11
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v10, 0xff, v36
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v11, 0xff, v38
		v_lshlrev_b32_e32 v11, 8, v11
		v_or_b32_e32 v10, v10, v11
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v11, 0xff, v39
		v_lshlrev_b32_e32 v11, 16, v11
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v12, 0xff, v41
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v10, v10, v11, v12
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v11, 0xff, v42
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v12, 0xff, v43
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v11, v11, v12
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v12, 0xff, v44
		v_lshlrev_b32_e32 v12, 16, v12
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v13, 0xff, v46
		v_lshlrev_b32_e32 v13, 24, v13
		v_or3_b32 v11, v11, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[24:27], a[0:3], v[252:255], v10, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[52:55], a[0:3], a[96:99], v10, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], a[8:11], v[168:171], v10, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], a[8:11], v[164:167], v10, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[64:67], a[4:7], v[252:255], v10, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[56:59], a[4:7], a[96:99], v10, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], a[12:15], v[168:171], v10, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[12:15], v[164:167], v10, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[60:63], a[0:3], v[4:7], v11, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[152:155], a[0:3], v[160:163], v11, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[152:155], a[8:11], v[176:179], v11, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[60:63], a[8:11], v[172:175], v11, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[144:147], a[4:7], v[4:7], v11, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[156:159], a[4:7], v[160:163], v11, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[156:159], a[12:15], v[176:179], v11, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[144:147], a[12:15], v[172:175], v11, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[60:63], a[16:19], v[188:191], v11, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[152:155], a[16:19], v[192:195], v11, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[152:155], a[24:27], v[208:211], v11, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], a[24:27], v[204:207], v11, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[144:147], a[20:23], v[188:191], v11, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[156:159], a[20:23], v[192:195], v11, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[156:159], a[28:31], v[208:211], v11, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[144:147], a[28:31], v[204:207], v11, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], a[16:19], v[180:183], v10, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], a[16:19], v[184:187], v10, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], a[24:27], v[200:203], v10, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], a[24:27], v[196:199], v10, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[20:23], v[180:183], v10, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], a[20:23], v[184:187], v10, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], a[28:31], v[200:203], v10, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[28:31], v[196:199], v10, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], a[32:35], v[212:215], v10, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[32:35], v[216:219], v10, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], a[40:43], v[232:235], v10, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], a[40:43], v[228:231], v10, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[36:39], v[212:215], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], a[36:39], v[216:219], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[44:47], v[232:235], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[44:47], v[228:231], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[60:63], a[32:35], v[220:223], v11, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[152:155], a[32:35], v[224:227], v11, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[152:155], a[40:43], v[240:243], v11, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[60:63], a[40:43], v[236:239], v11, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[144:147], a[36:39], v[220:223], v11, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[156:159], a[36:39], v[224:227], v11, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[156:159], a[44:47], v[240:243], v11, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[144:147], a[44:47], v[236:239], v11, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[60:63], a[48:51], a[100:103], v11, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[152:155], a[48:51], a[104:107], v11, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[152:155], a[56:59], a[120:123], v11, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[60:63], a[56:59], a[116:119], v11, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[144:147], a[52:55], a[100:103], v11, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[156:159], a[52:55], a[104:107], v11, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[156:159], a[60:63], a[120:123], v11, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[144:147], a[60:63], a[116:119], v11, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[24:27], a[48:51], v[244:247], v10, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[48:51], v[248:251], v10, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[52:55], a[56:59], a[112:115], v10, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[56:59], a[108:111], v10, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[52:55], v[244:247], v10, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[56:59], a[52:55], v[248:251], v10, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[56:59], a[60:63], a[112:115], v10, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[60:63], a[108:111], v10, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v106 offset:49152
		ds_read_b128 v[48:51], v106 offset:49216
		ds_read_b128 v[52:55], v106 offset:53248
		ds_read_b128 v[56:59], v106 offset:53312
		ds_read_b128 v[60:63], v106 offset:57344
		ds_read_b128 v[80:83], v106 offset:57408
		ds_read_b128 v[84:87], v106 offset:61440
		ds_read_b128 v[88:91], v106 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v105 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v70, v98 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v74, v103 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v77, v104 offset:2048
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v15, s12
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v16, s12
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[42:43], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v148 offset:2048
		ds_read_u8 v10, v64 offset:2048
		ds_read_u8 v11, v114 offset:2048
		ds_read_u8 v12, v112 offset:2048
		ds_read_u8 v13, v151 offset:2048
		ds_read_u8 v14, v124 offset:2048
		ds_read_u8 v15, v116 offset:2048
		ds_read_u8 v16, v111 offset:2048
		v_cmp_lt_i32_e64 vcc, v79, s13
		s_mov_b64 s[44:45], vcc
		v_cvt_pk_bf16_f32 v64, v252, v253
		v_cvt_pk_bf16_f32 v65, v254, v255
		v_accvgpr_read_b32 v17, a96
		v_accvgpr_read_b32 v20, a97
		v_cvt_pk_bf16_f32 v68, v17, v20
		v_accvgpr_read_b32 v17, a98
		v_accvgpr_read_b32 v20, a99
		v_cvt_pk_bf16_f32 v69, v17, v20
		v_cvt_pk_bf16_f32 v72, v4, v5
		v_cvt_pk_bf16_f32 v73, v6, v7
		v_cvt_pk_bf16_f32 v4, v160, v161
		v_cvt_pk_bf16_f32 v5, v162, v163
		v_cvt_pk_bf16_f32 v66, v164, v165
		v_cvt_pk_bf16_f32 v67, v166, v167
		v_cvt_pk_bf16_f32 v70, v168, v169
		v_cvt_pk_bf16_f32 v71, v170, v171
		v_cvt_pk_bf16_f32 v74, v172, v173
		v_cvt_pk_bf16_f32 v75, v174, v175
		v_cvt_pk_bf16_f32 v6, v176, v177
		v_cvt_pk_bf16_f32 v7, v178, v179
		v_cvt_pk_bf16_f32 v76, v180, v181
		v_cvt_pk_bf16_f32 v77, v182, v183
		v_cvt_pk_bf16_f32 v92, v184, v185
		v_cvt_pk_bf16_f32 v93, v186, v187
		v_cvt_pk_bf16_f32 v96, v188, v189
		v_cvt_pk_bf16_f32 v97, v190, v191
		v_cvt_pk_bf16_f32 v100, v192, v193
		v_cvt_pk_bf16_f32 v101, v194, v195
		v_cvt_pk_bf16_f32 v78, v196, v197
		v_cvt_pk_bf16_f32 v79, v198, v199
		v_cvt_pk_bf16_f32 v94, v200, v201
		v_cvt_pk_bf16_f32 v95, v202, v203
		v_cvt_pk_bf16_f32 v98, v204, v205
		v_cvt_pk_bf16_f32 v99, v206, v207
		v_cvt_pk_bf16_f32 v102, v208, v209
		v_cvt_pk_bf16_f32 v103, v210, v211
		v_cvt_pk_bf16_f32 v104, v212, v213
		v_cvt_pk_bf16_f32 v105, v214, v215
		v_cvt_pk_bf16_f32 v112, v216, v217
		v_cvt_pk_bf16_f32 v113, v218, v219
		v_cvt_pk_bf16_f32 v116, v220, v221
		v_cvt_pk_bf16_f32 v117, v222, v223
		v_cvt_pk_bf16_f32 v120, v224, v225
		v_cvt_pk_bf16_f32 v121, v226, v227
		v_cvt_pk_bf16_f32 v106, v228, v229
		v_cvt_pk_bf16_f32 v107, v230, v231
		v_cvt_pk_bf16_f32 v114, v232, v233
		v_cvt_pk_bf16_f32 v115, v234, v235
		v_cvt_pk_bf16_f32 v118, v236, v237
		v_cvt_pk_bf16_f32 v119, v238, v239
		v_cvt_pk_bf16_f32 v122, v240, v241
		v_cvt_pk_bf16_f32 v123, v242, v243
		v_cvt_pk_bf16_f32 v124, v244, v245
		v_cvt_pk_bf16_f32 v125, v246, v247
		v_cvt_pk_bf16_f32 v128, v248, v249
		v_cvt_pk_bf16_f32 v129, v250, v251
		v_accvgpr_read_b32 v17, a100
		v_accvgpr_read_b32 v20, a101
		v_cvt_pk_bf16_f32 v132, v17, v20
		v_accvgpr_read_b32 v17, a102
		v_accvgpr_read_b32 v20, a103
		v_cvt_pk_bf16_f32 v133, v17, v20
		v_accvgpr_read_b32 v17, a104
		v_accvgpr_read_b32 v20, a105
		v_cvt_pk_bf16_f32 v136, v17, v20
		v_accvgpr_read_b32 v17, a106
		v_accvgpr_read_b32 v20, a107
		v_cvt_pk_bf16_f32 v137, v17, v20
		v_accvgpr_read_b32 v17, a108
		v_accvgpr_read_b32 v20, a109
		v_cvt_pk_bf16_f32 v126, v17, v20
		v_accvgpr_read_b32 v17, a110
		v_accvgpr_read_b32 v20, a111
		v_cvt_pk_bf16_f32 v127, v17, v20
		v_accvgpr_read_b32 v17, a112
		v_accvgpr_read_b32 v20, a113
		v_cvt_pk_bf16_f32 v130, v17, v20
		v_accvgpr_read_b32 v17, a114
		v_accvgpr_read_b32 v20, a115
		v_cvt_pk_bf16_f32 v131, v17, v20
		v_accvgpr_read_b32 v17, a116
		v_accvgpr_read_b32 v20, a117
		v_cvt_pk_bf16_f32 v134, v17, v20
		v_accvgpr_read_b32 v17, a118
		v_accvgpr_read_b32 v20, a119
		v_cvt_pk_bf16_f32 v135, v17, v20
		v_accvgpr_read_b32 v17, a120
		v_accvgpr_read_b32 v20, a121
		v_cvt_pk_bf16_f32 v138, v17, v20
		v_accvgpr_read_b32 v17, a122
		v_accvgpr_read_b32 v20, a123
		v_cvt_pk_bf16_f32 v139, v17, v20
		v_add_u32_e32 v17, 0x20000, v21
		ds_write_b128 v17, v[64:67] offset:3072
		ds_write_b128 v17, v[68:71] offset:7168
		ds_write_b128 v17, v[72:75] offset:11264
		ds_write_b128 v17, v[4:7] offset:15360
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v31, 9, v1
		v_lshl_add_u32 v1, v18, 13, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v1, v45, 12, v1
		v_lshl_add_u32 v1, v47, 10, v1
		ds_read_b128 v[4:7], v1 offset:3072
		ds_read_b128 v[20:23], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[64:65], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[66:67], v[20:21]
		v_mov_b64_e32 v[68:69], v[6:7]
		v_mov_b64_e32 v[70:71], v[22:23]
		ds_read_b128 v[4:7], v1 offset:5120
		ds_read_b128 v[20:23], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[72:73], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[74:75], v[20:21]
		v_mov_b64_e32 v[140:141], v[6:7]
		v_mov_b64_e32 v[142:143], v[22:23]
		s_barrier
		ds_write_b128 v17, v[76:79] offset:3072
		ds_write_b128 v17, v[92:95] offset:7168
		ds_write_b128 v17, v[96:99] offset:11264
		ds_write_b128 v17, v[100:103] offset:15360
		s_and_b32 s46, s2, s44
		s_and_b32 s47, s3, s45
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v4, 4, v31
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v1 offset:3072
		ds_read_b128 v[76:79], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[92:93], v[20:21]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[94:95], v[76:77]
		v_mov_b64_e32 v[96:97], v[22:23]
		v_mov_b64_e32 v[98:99], v[78:79]
		ds_read_b128 v[20:23], v1 offset:5120
		ds_read_b128 v[76:79], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[100:101], v[20:21]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[102:103], v[76:77]
		v_mov_b64_e32 v[144:145], v[22:23]
		v_mov_b64_e32 v[146:147], v[78:79]
		s_barrier
		ds_write_b128 v17, v[104:107] offset:3072
		ds_write_b128 v17, v[112:115] offset:7168
		ds_write_b128 v17, v[116:119] offset:11264
		ds_write_b128 v17, v[120:123] offset:15360
		v_lshlrev_b32_e32 v5, 7, v18
		v_lshlrev_b32_e32 v6, 6, v45
		v_lshlrev_b32_e32 v7, 5, v47
		v_mov_b32_e32 v18, 0x80000000
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v1 offset:3072
		ds_read_b128 v[44:47], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[76:77], v[20:21]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[78:79], v[44:45]
		v_mov_b64_e32 v[104:105], v[22:23]
		v_mov_b64_e32 v[106:107], v[46:47]
		ds_read_b128 v[20:23], v1 offset:5120
		ds_read_b128 v[44:47], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[112:113], v[20:21]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[114:115], v[44:45]
		v_mov_b64_e32 v[116:117], v[22:23]
		v_mov_b64_e32 v[118:119], v[46:47]
		s_barrier
		ds_write_b128 v17, v[124:127] offset:3072
		ds_write_b128 v17, v[128:131] offset:7168
		ds_write_b128 v17, v[132:135] offset:11264
		ds_write_b128 v17, v[136:139] offset:15360
		v_lshlrev_b32_e32 v20, 3, v28
		v_lshlrev_b32_e32 v21, 2, v34
		v_add_u32_e32 v22, 16, v40
		v_xor_b32_e32 v22, v22, v108
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v1 offset:3072
		ds_read_b128 v[120:123], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[124:125], v[44:45]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[126:127], v[120:121]
		v_mov_b64_e32 v[128:129], v[46:47]
		v_mov_b64_e32 v[130:131], v[122:123]
		ds_read_b128 v[44:47], v1 offset:5120
		ds_read_b128 v[120:123], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[132:133], v[44:45]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[134:135], v[120:121]
		v_mov_b64_e32 v[136:137], v[46:47]
		v_mov_b64_e32 v[138:139], v[122:123]
		s_barrier
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s12, s0, s1
		s_mul_i32 s16, s21, s17
		s_lshl_b32 s16, s16, 9
		s_add_i32 s12, s12, s16
		v_mul_lo_u32 v23, s17, v28
		v_lshlrev_b32_e32 v23, 4, v23
		v_mul_lo_u32 v28, s17, v34
		v_lshlrev_b32_e32 v28, 3, v28
		v_add3_u32 v29, s12, v23, v28
		v_mul_lo_u32 v30, s17, v37
		v_lshlrev_b32_e32 v30, 2, v30
		v_mul_lo_u32 v31, s17, v40
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v29, v29, v30, v31
		v_add3_u32 v29, v29, v4, v5
		v_add3_u32 v29, v29, v6, v7
		v_cndmask_b32_e64 v29, v18, v29, s[46:47]
		buffer_store_dwordx4 v[64:67], v29, s[8:11], 0 offen
		s_and_b32 s46, s4, s44
		s_and_b32 s47, s5, s45
		v_xor_b32_e32 v22, v21, v22
		v_xor_b32_e32 v22, v20, v22
		v_mul_lo_u32 v22, s17, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v29, s12, v22
		v_add3_u32 v29, v29, v4, v5
		v_add3_u32 v29, v29, v6, v7
		v_cndmask_b32_e64 v29, v18, v29, s[46:47]
		buffer_store_dwordx4 v[72:75], v29, s[8:11], 0 offen
		s_and_b32 s46, s6, s44
		s_and_b32 s47, s7, s45
		v_add_u32_e32 v29, 32, v40
		v_xor_b32_e32 v29, v29, v108
		v_xor_b32_e32 v29, v21, v29
		v_xor_b32_e32 v29, v20, v29
		v_mul_lo_u32 v29, s17, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v32, s12, v29
		v_add3_u32 v32, v32, v4, v5
		v_add3_u32 v32, v32, v6, v7
		v_cndmask_b32_e64 v32, v18, v32, s[46:47]
		buffer_store_dwordx4 v[68:71], v32, s[8:11], 0 offen
		s_and_b32 s46, s14, s44
		s_and_b32 s47, s15, s45
		v_add_u32_e32 v32, 48, v40
		v_xor_b32_e32 v32, v32, v108
		v_xor_b32_e32 v32, v21, v32
		v_xor_b32_e32 v32, v20, v32
		v_mul_lo_u32 v32, s17, v32
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v33, s12, v32
		v_add3_u32 v33, v33, v4, v5
		v_add3_u32 v33, v33, v6, v7
		v_cndmask_b32_e64 v33, v18, v33, s[46:47]
		buffer_store_dwordx4 v[140:143], v33, s[8:11], 0 offen
		s_and_b32 s46, s18, s44
		s_and_b32 s47, s19, s45
		v_add_u32_e32 v33, 64, v40
		v_xor_b32_e32 v33, v33, v108
		v_xor_b32_e32 v33, v21, v33
		v_xor_b32_e32 v33, v20, v33
		v_mul_lo_u32 v33, s17, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v34, s12, v33
		v_add3_u32 v34, v34, v4, v5
		v_add3_u32 v34, v34, v6, v7
		v_cndmask_b32_e64 v34, v18, v34, s[46:47]
		buffer_store_dwordx4 v[92:95], v34, s[8:11], 0 offen
		s_and_b32 s46, s22, s44
		s_and_b32 s47, s23, s45
		v_add_u32_e32 v34, 0x50, v40
		v_xor_b32_e32 v34, v34, v108
		v_xor_b32_e32 v34, v21, v34
		v_xor_b32_e32 v34, v20, v34
		v_mul_lo_u32 v34, s17, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_add_u32_e32 v35, s12, v34
		v_add3_u32 v35, v35, v4, v5
		v_add3_u32 v35, v35, v6, v7
		v_cndmask_b32_e64 v35, v18, v35, s[46:47]
		buffer_store_dwordx4 v[100:103], v35, s[8:11], 0 offen
		s_and_b32 s46, s24, s44
		s_and_b32 s47, s25, s45
		v_add_u32_e32 v35, 0x60, v40
		v_xor_b32_e32 v35, v35, v108
		v_xor_b32_e32 v35, v21, v35
		v_xor_b32_e32 v35, v20, v35
		v_mul_lo_u32 v35, s17, v35
		v_lshlrev_b32_e32 v35, 1, v35
		v_add_u32_e32 v36, s12, v35
		v_add3_u32 v36, v36, v4, v5
		v_add3_u32 v36, v36, v6, v7
		v_cndmask_b32_e64 v36, v18, v36, s[46:47]
		buffer_store_dwordx4 v[96:99], v36, s[8:11], 0 offen
		s_and_b32 s46, s26, s44
		s_and_b32 s47, s27, s45
		v_add_u32_e32 v36, 0x70, v40
		v_xor_b32_e32 v36, v36, v108
		v_xor_b32_e32 v36, v21, v36
		v_xor_b32_e32 v36, v20, v36
		v_mul_lo_u32 v36, s17, v36
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v37, s12, v36
		v_add3_u32 v37, v37, v4, v5
		v_add3_u32 v37, v37, v6, v7
		v_cndmask_b32_e64 v37, v18, v37, s[46:47]
		buffer_store_dwordx4 v[144:147], v37, s[8:11], 0 offen
		s_and_b32 s46, s28, s44
		s_and_b32 s47, s29, s45
		v_add_u32_e32 v37, 0x80, v40
		v_xor_b32_e32 v37, v37, v108
		v_xor_b32_e32 v37, v21, v37
		v_xor_b32_e32 v37, v20, v37
		v_mul_lo_u32 v37, s17, v37
		v_lshlrev_b32_e32 v37, 1, v37
		v_add_u32_e32 v38, s12, v37
		v_add3_u32 v38, v38, v4, v5
		v_add3_u32 v38, v38, v6, v7
		v_cndmask_b32_e64 v38, v18, v38, s[46:47]
		buffer_store_dwordx4 v[76:79], v38, s[8:11], 0 offen
		s_and_b32 s46, s30, s44
		s_and_b32 s47, s31, s45
		v_add_u32_e32 v38, 0x90, v40
		v_xor_b32_e32 v38, v38, v108
		v_xor_b32_e32 v38, v21, v38
		v_xor_b32_e32 v38, v20, v38
		v_mul_lo_u32 v38, s17, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add_u32_e32 v39, s12, v38
		v_add3_u32 v39, v39, v4, v5
		v_add3_u32 v39, v39, v6, v7
		v_cndmask_b32_e64 v39, v18, v39, s[46:47]
		buffer_store_dwordx4 v[112:115], v39, s[8:11], 0 offen
		s_and_b32 s46, s32, s44
		s_and_b32 s47, s33, s45
		v_add_u32_e32 v39, 0xa0, v40
		v_xor_b32_e32 v39, v39, v108
		v_xor_b32_e32 v39, v21, v39
		v_xor_b32_e32 v39, v20, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshlrev_b32_e32 v39, 1, v39
		v_add_u32_e32 v41, s12, v39
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v18, v41, s[46:47]
		buffer_store_dwordx4 v[104:107], v41, s[8:11], 0 offen
		s_and_b32 s46, s34, s44
		s_and_b32 s47, s35, s45
		v_add_u32_e32 v41, 0xb0, v40
		v_xor_b32_e32 v41, v41, v108
		v_xor_b32_e32 v41, v21, v41
		v_xor_b32_e32 v41, v20, v41
		v_mul_lo_u32 v41, s17, v41
		v_lshlrev_b32_e32 v41, 1, v41
		v_add_u32_e32 v42, s12, v41
		v_add3_u32 v42, v42, v4, v5
		v_add3_u32 v42, v42, v6, v7
		v_cndmask_b32_e64 v42, v18, v42, s[46:47]
		buffer_store_dwordx4 v[116:119], v42, s[8:11], 0 offen
		s_and_b32 s46, s36, s44
		s_and_b32 s47, s37, s45
		v_add_u32_e32 v42, 0xc0, v40
		v_xor_b32_e32 v42, v42, v108
		v_xor_b32_e32 v42, v21, v42
		v_xor_b32_e32 v42, v20, v42
		v_mul_lo_u32 v42, s17, v42
		v_lshlrev_b32_e32 v42, 1, v42
		v_add_u32_e32 v43, s12, v42
		v_add3_u32 v43, v43, v4, v5
		v_add3_u32 v43, v43, v6, v7
		v_cndmask_b32_e64 v43, v18, v43, s[46:47]
		buffer_store_dwordx4 v[124:127], v43, s[8:11], 0 offen
		s_and_b32 s46, s38, s44
		s_and_b32 s47, s39, s45
		v_add_u32_e32 v43, 0xd0, v40
		v_xor_b32_e32 v43, v43, v108
		v_xor_b32_e32 v43, v21, v43
		v_xor_b32_e32 v43, v20, v43
		v_mul_lo_u32 v43, s17, v43
		v_lshlrev_b32_e32 v43, 1, v43
		v_add_u32_e32 v44, s12, v43
		v_add3_u32 v44, v44, v4, v5
		v_add3_u32 v44, v44, v6, v7
		v_cndmask_b32_e64 v44, v18, v44, s[46:47]
		buffer_store_dwordx4 v[132:135], v44, s[8:11], 0 offen
		s_and_b32 s46, s40, s44
		s_and_b32 s47, s41, s45
		v_add_u32_e32 v44, 0xe0, v40
		v_xor_b32_e32 v44, v44, v108
		v_xor_b32_e32 v44, v21, v44
		v_xor_b32_e32 v44, v20, v44
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s12, v44
		v_add3_u32 v45, v45, v4, v5
		v_add3_u32 v45, v45, v6, v7
		v_cndmask_b32_e64 v45, v18, v45, s[46:47]
		buffer_store_dwordx4 v[128:131], v45, s[8:11], 0 offen
		s_and_b32 s46, s42, s44
		s_and_b32 s47, s43, s45
		v_add_u32_e32 v40, 0xf0, v40
		v_xor_b32_e32 v40, v40, v108
		v_xor_b32_e32 v21, v21, v40
		v_xor_b32_e32 v20, v20, v21
		v_mul_lo_u32 v20, s17, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v21, s12, v20
		v_add3_u32 v21, v21, v4, v5
		v_add3_u32 v21, v21, v6, v7
		v_cndmask_b32_e64 v21, v18, v21, s[46:47]
		buffer_store_dwordx4 v[136:139], v21, s[8:11], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v10, 0xff, v10
		v_lshlrev_b32_e32 v10, 8, v10
		v_or_b32_e32 v0, v0, v10
		v_and_b32_e32 v10, 0xff, v11
		v_lshlrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v11, 0xff, v12
		v_lshlrev_b32_e32 v11, 24, v11
		v_or3_b32 v0, v0, v10, v11
		v_and_b32_e32 v10, 0xff, v13
		v_and_b32_e32 v11, 0xff, v14
		v_lshlrev_b32_e32 v11, 8, v11
		v_or_b32_e32 v10, v10, v11
		v_and_b32_e32 v11, 0xff, v15
		v_lshlrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v12, 0xff, v16
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v10, v10, v11, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[0:3], a[124:127], v0, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[0:3], a[128:131], v0, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[8:11], a[144:147], v0, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[8:11], a[140:143], v0, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], a[4:7], a[124:127], v0, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], a[4:7], a[128:131], v0, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], a[12:15], a[144:147], v0, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], a[12:15], a[140:143], v0, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[0:3], a[132:135], v10, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[84:87], a[0:3], a[136:139], v10, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], a[8:11], a[152:155], v10, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[8:11], a[148:151], v10, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], a[4:7], a[132:135], v10, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], a[4:7], a[136:139], v10, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[88:91], a[12:15], a[152:155], v10, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], a[12:15], a[148:151], v10, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[16:19], a[164:167], v10, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], a[16:19], a[168:171], v10, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[84:87], a[24:27], a[184:187], v10, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[60:63], a[24:27], a[180:183], v10, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], a[20:23], a[164:167], v10, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[88:91], a[20:23], a[168:171], v10, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[88:91], a[28:31], a[184:187], v10, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[80:83], a[28:31], a[180:183], v10, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[16:19], a[156:159], v0, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[16:19], a[160:163], v0, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], a[24:27], a[176:179], v0, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], a[24:27], a[172:175], v0, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], a[20:23], a[156:159], v0, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], a[20:23], a[160:163], v0, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[56:59], a[28:31], a[176:179], v0, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], a[28:31], a[172:175], v0, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], a[32:35], a[188:191], v0, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[52:55], a[32:35], a[192:195], v0, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[52:55], a[40:43], a[208:211], v0, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], a[40:43], a[204:207], v0, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[48:51], a[36:39], a[188:191], v0, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], a[36:39], a[192:195], v0, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], a[44:47], a[208:211], v0, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[48:51], a[44:47], a[204:207], v0, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], a[32:35], a[196:199], v10, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[84:87], a[32:35], a[200:203], v10, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[84:87], a[40:43], a[216:219], v10, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[60:63], a[40:43], a[212:215], v10, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[80:83], a[36:39], a[196:199], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[88:91], a[36:39], a[200:203], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[88:91], a[44:47], a[216:219], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[80:83], a[44:47], a[212:215], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[60:63], a[48:51], a[228:231], v10, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[84:87], a[48:51], a[232:235], v10, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[84:87], a[56:59], a[248:251], v10, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[60:63], a[56:59], a[244:247], v10, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[80:83], a[52:55], a[228:231], v10, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[88:91], a[52:55], a[232:235], v10, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[88:91], a[60:63], a[248:251], v10, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[80:83], a[60:63], a[244:247], v10, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[24:27], a[48:51], a[220:223], v0, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[52:55], a[48:51], a[224:227], v0, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[52:55], a[56:59], a[240:243], v0, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[24:27], a[56:59], a[236:239], v0, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[48:51], a[52:55], a[220:223], v0, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[56:59], a[52:55], a[224:227], v0, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[56:59], a[60:63], a[240:243], v0, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[48:51], a[60:63], a[236:239], v0, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s12, s20, 0x80
		v_add_u32_e32 v0, s12, v19
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[20:21], vcc
		v_accvgpr_read_b32 v0, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_bf16_f32 v8, v0, v2
		v_accvgpr_read_b32 v0, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_bf16_f32 v9, v0, v2
		v_accvgpr_read_b32 v0, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_bf16_f32 v12, v0, v2
		v_accvgpr_read_b32 v0, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_bf16_f32 v13, v0, v2
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_bf16_f32 v24, v0, v2
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_bf16_f32 v25, v0, v2
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_bf16_f32 v48, v0, v2
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_bf16_f32 v49, v0, v2
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_bf16_f32 v10, v0, v2
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_bf16_f32 v11, v0, v2
		ds_write_b128 v17, v[8:11] offset:3072
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_bf16_f32 v14, v0, v2
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_bf16_f32 v15, v0, v2
		ds_write_b128 v17, v[12:15] offset:7168
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_bf16_f32 v26, v0, v2
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_bf16_f32 v27, v0, v2
		ds_write_b128 v17, v[24:27] offset:11264
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_bf16_f32 v50, v0, v2
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_bf16_f32 v51, v0, v2
		ds_write_b128 v17, v[48:51] offset:15360
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_bf16_f32 v8, v0, v2
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_bf16_f32 v9, v0, v2
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_bf16_f32 v12, v0, v2
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_bf16_f32 v13, v0, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_bf16_f32 v24, v0, v2
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_bf16_f32 v25, v0, v2
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_bf16_f32 v48, v0, v2
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_bf16_f32 v49, v0, v2
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_bf16_f32 v10, v0, v2
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_bf16_f32 v11, v0, v2
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_bf16_f32 v14, v0, v2
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_bf16_f32 v15, v0, v2
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_bf16_f32 v26, v0, v2
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_bf16_f32 v27, v0, v2
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_bf16_f32 v50, v0, v2
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_bf16_f32 v51, v0, v2
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_bf16_f32 v52, v0, v2
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_bf16_f32 v53, v0, v2
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_bf16_f32 v56, v0, v2
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_bf16_f32 v57, v0, v2
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_bf16_f32 v60, v0, v2
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_bf16_f32 v61, v0, v2
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_bf16_f32 v64, v0, v2
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_bf16_f32 v65, v0, v2
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_bf16_f32 v54, v0, v2
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_bf16_f32 v55, v0, v2
		v_accvgpr_read_b32 v0, a208
		v_accvgpr_read_b32 v2, a209
		v_cvt_pk_bf16_f32 v58, v0, v2
		v_accvgpr_read_b32 v0, a210
		v_accvgpr_read_b32 v2, a211
		v_cvt_pk_bf16_f32 v59, v0, v2
		v_accvgpr_read_b32 v0, a212
		v_accvgpr_read_b32 v2, a213
		v_cvt_pk_bf16_f32 v62, v0, v2
		v_accvgpr_read_b32 v0, a214
		v_accvgpr_read_b32 v2, a215
		v_cvt_pk_bf16_f32 v63, v0, v2
		v_accvgpr_read_b32 v0, a216
		v_accvgpr_read_b32 v2, a217
		v_cvt_pk_bf16_f32 v66, v0, v2
		v_accvgpr_read_b32 v0, a218
		v_accvgpr_read_b32 v2, a219
		v_cvt_pk_bf16_f32 v67, v0, v2
		v_accvgpr_read_b32 v0, a220
		v_accvgpr_read_b32 v2, a221
		v_cvt_pk_bf16_f32 v68, v0, v2
		v_accvgpr_read_b32 v0, a222
		v_accvgpr_read_b32 v2, a223
		v_cvt_pk_bf16_f32 v69, v0, v2
		v_accvgpr_read_b32 v0, a224
		v_accvgpr_read_b32 v2, a225
		v_cvt_pk_bf16_f32 v72, v0, v2
		v_accvgpr_read_b32 v0, a226
		v_accvgpr_read_b32 v2, a227
		v_cvt_pk_bf16_f32 v73, v0, v2
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v2, a229
		v_cvt_pk_bf16_f32 v76, v0, v2
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v2, a231
		v_cvt_pk_bf16_f32 v77, v0, v2
		v_accvgpr_read_b32 v0, a232
		v_accvgpr_read_b32 v2, a233
		v_cvt_pk_bf16_f32 v80, v0, v2
		v_accvgpr_read_b32 v0, a234
		v_accvgpr_read_b32 v2, a235
		v_cvt_pk_bf16_f32 v81, v0, v2
		v_accvgpr_read_b32 v0, a236
		v_accvgpr_read_b32 v2, a237
		v_cvt_pk_bf16_f32 v70, v0, v2
		v_accvgpr_read_b32 v0, a238
		v_accvgpr_read_b32 v2, a239
		v_cvt_pk_bf16_f32 v71, v0, v2
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v2, a241
		v_cvt_pk_bf16_f32 v74, v0, v2
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v2, a243
		v_cvt_pk_bf16_f32 v75, v0, v2
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v2, a245
		v_cvt_pk_bf16_f32 v78, v0, v2
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v2, a247
		v_cvt_pk_bf16_f32 v79, v0, v2
		v_accvgpr_read_b32 v0, a248
		v_accvgpr_read_b32 v2, a249
		v_cvt_pk_bf16_f32 v82, v0, v2
		v_accvgpr_read_b32 v0, a250
		v_accvgpr_read_b32 v2, a251
		v_cvt_pk_bf16_f32 v83, v0, v2
		ds_read_b128 v[84:87], v1 offset:3072
		ds_read_b128 v[88:91], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[92:93], v[84:85]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[94:95], v[88:89]
		v_mov_b64_e32 v[96:97], v[86:87]
		v_mov_b64_e32 v[98:99], v[90:91]
		ds_read_b128 v[84:87], v1 offset:5120
		ds_read_b128 v[88:91], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[100:101], v[84:85]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[102:103], v[88:89]
		v_mov_b64_e32 v[104:105], v[86:87]
		v_mov_b64_e32 v[106:107], v[90:91]
		s_barrier
		ds_write_b128 v17, v[8:11] offset:3072
		ds_write_b128 v17, v[12:15] offset:7168
		ds_write_b128 v17, v[24:27] offset:11264
		ds_write_b128 v17, v[48:51] offset:15360
		s_and_b32 s12, s2, s20
		s_and_b32 s13, s3, s21
		s_add_i32 s0, s0, 0x100
		s_add_i32 s0, s0, s1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v1 offset:3072
		ds_read_b128 v[12:15], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[24:25], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[26:27], v[12:13]
		v_mov_b64_e32 v[48:49], v[10:11]
		v_mov_b64_e32 v[50:51], v[14:15]
		ds_read_b128 v[8:11], v1 offset:5120
		ds_read_b128 v[12:15], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[84:85], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[86:87], v[12:13]
		v_mov_b64_e32 v[88:89], v[10:11]
		v_mov_b64_e32 v[90:91], v[14:15]
		s_barrier
		ds_write_b128 v17, v[52:55] offset:3072
		ds_write_b128 v17, v[56:59] offset:7168
		ds_write_b128 v17, v[60:63] offset:11264
		ds_write_b128 v17, v[64:67] offset:15360
		s_add_i32 s0, s0, s16
		v_add3_u32 v0, s0, v23, v28
		v_add3_u32 v0, v0, v30, v31
		v_add3_u32 v0, v0, v4, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v1 offset:3072
		ds_read_b128 v[12:15], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[52:53], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[54:55], v[12:13]
		v_mov_b64_e32 v[56:57], v[10:11]
		v_mov_b64_e32 v[58:59], v[14:15]
		ds_read_b128 v[8:11], v1 offset:5120
		ds_read_b128 v[12:15], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[60:61], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[62:63], v[12:13]
		v_mov_b64_e32 v[64:65], v[10:11]
		v_mov_b64_e32 v[66:67], v[14:15]
		s_barrier
		ds_write_b128 v17, v[68:71] offset:3072
		ds_write_b128 v17, v[72:75] offset:7168
		ds_write_b128 v17, v[76:79] offset:11264
		ds_write_b128 v17, v[80:83] offset:15360
		v_add3_u32 v0, v0, v6, v7
		v_cndmask_b32_e64 v0, v18, v0, s[12:13]
		buffer_store_dwordx4 v[92:95], v0, s[8:11], 0 offen
		s_and_b32 s2, s4, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v1 offset:3072
		ds_read_b128 v[12:15], v1 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[68:69], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[70:71], v[12:13]
		v_mov_b64_e32 v[72:73], v[10:11]
		v_mov_b64_e32 v[74:75], v[14:15]
		ds_read_b128 v[8:11], v1 offset:5120
		ds_read_b128 v[12:15], v1 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[0:1], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[2:3], v[12:13]
		v_mov_b64_e32 v[76:77], v[10:11]
		v_mov_b64_e32 v[78:79], v[14:15]
		s_barrier
		s_and_b32 s3, s5, s21
		v_add3_u32 v8, v4, v5, v6
		v_add_u32_e32 v8, v8, v7
		v_add3_u32 v9, v22, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[100:103], v9, s[8:11], 0 offen
		s_and_b32 s2, s6, s20
		s_and_b32 s3, s7, s21
		v_add3_u32 v9, v29, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[96:99], v9, s[8:11], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_add3_u32 v8, v32, v8, s0
		v_cndmask_b32_e64 v8, v18, v8, s[2:3]
		buffer_store_dwordx4 v[104:107], v8, s[8:11], 0 offen
		s_and_b32 s2, s18, s20
		s_and_b32 s3, s19, s21
		v_add3_u32 v8, v4, v5, v6
		v_add_u32_e32 v8, v8, v7
		v_add3_u32 v9, v33, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[24:27], v9, s[8:11], 0 offen
		s_and_b32 s2, s22, s20
		s_and_b32 s3, s23, s21
		v_add3_u32 v9, v34, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[84:87], v9, s[8:11], 0 offen
		s_and_b32 s2, s24, s20
		s_and_b32 s3, s25, s21
		v_add3_u32 v8, v35, v8, s0
		v_cndmask_b32_e64 v8, v18, v8, s[2:3]
		buffer_store_dwordx4 v[48:51], v8, s[8:11], 0 offen
		s_and_b32 s2, s26, s20
		s_and_b32 s3, s27, s21
		v_add3_u32 v8, v4, v5, v6
		v_add_u32_e32 v8, v8, v7
		v_add3_u32 v9, v36, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[88:91], v9, s[8:11], 0 offen
		s_and_b32 s2, s28, s20
		s_and_b32 s3, s29, s21
		v_add3_u32 v9, v37, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[52:55], v9, s[8:11], 0 offen
		s_and_b32 s2, s30, s20
		s_and_b32 s3, s31, s21
		v_add3_u32 v8, v38, v8, s0
		v_cndmask_b32_e64 v8, v18, v8, s[2:3]
		buffer_store_dwordx4 v[60:63], v8, s[8:11], 0 offen
		s_and_b32 s2, s32, s20
		s_and_b32 s3, s33, s21
		v_add3_u32 v8, v4, v5, v6
		v_add_u32_e32 v8, v8, v7
		v_add3_u32 v9, v39, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[56:59], v9, s[8:11], 0 offen
		s_and_b32 s2, s34, s20
		s_and_b32 s3, s35, s21
		v_add3_u32 v9, v41, v8, s0
		v_cndmask_b32_e64 v9, v18, v9, s[2:3]
		buffer_store_dwordx4 v[64:67], v9, s[8:11], 0 offen
		s_and_b32 s2, s36, s20
		s_and_b32 s3, s37, s21
		v_add3_u32 v8, v42, v8, s0
		v_cndmask_b32_e64 v8, v18, v8, s[2:3]
		buffer_store_dwordx4 v[68:71], v8, s[8:11], 0 offen
		s_and_b32 s2, s38, s20
		s_and_b32 s3, s39, s21
		v_add3_u32 v4, v4, v5, v6
		v_add_u32_e32 v4, v4, v7
		v_add3_u32 v5, v43, v4, s0
		v_cndmask_b32_e64 v5, v18, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s40, s20
		s_and_b32 s3, s41, s21
		v_add3_u32 v0, v44, v4, s0
		v_cndmask_b32_e64 v0, v18, v0, s[2:3]
		buffer_store_dwordx4 v[72:75], v0, s[8:11], 0 offen
		s_and_b32 s2, s42, s20
		s_and_b32 s3, s43, s21
		v_add3_u32 v0, v20, v4, s0
		v_cndmask_b32_e64 v0, v18, v0, s[2:3]
		buffer_store_dwordx4 v[76:79], v0, s[8:11], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 150528
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
		.amdhsa_next_free_vgpr 508
		.amdhsa_next_free_sgpr 70
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 1
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
	.set .L_a4w4_kernel.num_agpr, 252
	.set .L_a4w4_kernel.numbered_sgpr, 70
	.set .L_a4w4_kernel.num_named_barrier, 0
	.set .L_a4w4_kernel.private_seg_size, 0
	.set .L_a4w4_kernel.uses_vcc, 1
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
    .group_segment_fixed_size: 150528
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     70
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     508
    .agpr_count:     252
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 121
    wave.regalloc.agpr.dwords: 480
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
