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
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, s22, s1
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
		s_xor_b32 s16, s22, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
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
		s_add_i32 s23, s21, s22
		s_cmp_ge_u32 s21, s0
		s_cselect_b32 s21, s23, s21
		s_add_i32 s23, s21, s22
		s_cmp_ge_u32 s21, s0
		s_cselect_b32 s21, s23, s21
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
		s_add_i32 s22, s23, 1
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s0, s22, s23
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
		v_add_u32_e32 v18, s16, v2
		v_add3_u32 v19, 16, v2, s16
		v_add3_u32 v20, 32, v2, s16
		v_add3_u32 v21, 48, v2, s16
		v_add3_u32 v2, 64, v2, s16
		v_add_u32_e32 v3, s16, v3
		v_add_u32_e32 v8, s16, v8
		v_add_u32_e32 v9, s16, v9
		v_add_u32_e32 v10, s16, v10
		v_add_u32_e32 v11, s16, v11
		v_add_u32_e32 v12, s16, v12
		v_add_u32_e32 v13, s16, v13
		v_add_u32_e32 v14, s16, v14
		v_add_u32_e32 v15, s16, v15
		v_add_u32_e32 v16, s16, v16
		v_add_u32_e32 v17, s16, v17
		v_and_b32_e32 v22, 15, v0
		v_mov_b32_e32 v23, 8
		v_mul_lo_u32 v23, v23, v22
		s_mul_i32 s16, s0, 0x100
		v_add_u32_e32 v22, s16, v23
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_readfirstlane_b32 s2, v0
		s_mul_i32 s3, s1, s14
		s_lshl_b32 s3, s3, 10
		s_mul_i32 s20, s21, s14
		s_lshl_b32 s20, s20, 8
		s_add_i32 s22, s3, s20
		v_lshrrev_b32_e32 v24, 3, v0
		v_mul_lo_u32 v25, s14, v24
		v_lshlrev_b32_e32 v26, 4, v0
		v_and_b32_e32 v27, 0x7f, v26
		v_add3_u32 v28, s22, v25, v27
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_lshl_b32 s23, s14, 5
		s_add_i32 s28, s23, s3
		s_add_i32 s28, s28, s20
		v_add3_u32 v28, s28, v25, v27
		s_add_i32 s29, s2, 0x1000
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 6
		s_add_i32 s31, s30, s3
		s_add_i32 s31, s31, s20
		v_add3_u32 v28, s31, v25, v27
		s_add_i32 s32, s2, 0x2000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s33, 0x60, s14
		s_add_i32 s34, s33, s3
		s_add_i32 s34, s34, s20
		v_add3_u32 v28, s34, v25, v27
		s_add_i32 s35, s2, 0x3000
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_lshl_b32 s36, s14, 7
		s_add_i32 s37, s36, s3
		s_add_i32 s37, s37, s20
		v_add3_u32 v28, s37, v25, v27
		s_add_i32 s38, s2, 0x4000
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s39, 0xa0, s14
		s_add_i32 s40, s39, s3
		s_add_i32 s40, s40, s20
		v_add3_u32 v28, s40, v25, v27
		s_add_i32 s41, s2, 0x5000
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s42, 0xc0, s14
		s_add_i32 s43, s42, s3
		s_add_i32 s43, s43, s20
		v_add3_u32 v28, s43, v25, v27
		s_add_i32 s44, s2, 0x6000
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s45, s14, s3
		s_add_i32 s45, s45, s20
		v_add3_u32 v28, s45, v25, v27
		s_add_i32 s46, s2, 0x7000
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mov_b32 s48, s4
		s_mov_b32 s49, s5
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		s_mul_i32 s4, s0, s15
		s_lshl_b32 s4, s4, 8
		v_mul_lo_u32 v28, s15, v24
		v_add3_u32 v29, s4, v28, v27
		s_add_i32 s5, s2, 0x10000
		s_mov_b32 m0, s5
		s_nop 0
		buffer_load_dwordx4 v29, s[48:51], 0 offen lds
		s_lshl_b32 s47, s15, 5
		s_add_i32 s52, s47, s4
		v_add3_u32 v29, s52, v28, v27
		s_add_i32 s53, s2, 0x11000
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v29, s[48:51], 0 offen lds
		s_lshl_b32 s54, s15, 6
		s_add_i32 s55, s54, s4
		v_add3_u32 v29, s55, v28, v27
		s_add_i32 s56, s2, 0x12000
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v29, s[48:51], 0 offen lds
		s_mul_i32 s57, 0x60, s15
		s_add_i32 s58, s57, s4
		v_add3_u32 v29, s58, v28, v27
		s_add_i32 s59, s2, 0x13000
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v29, s[48:51], 0 offen lds
		s_mov_b32 s60, s8
		s_mov_b32 s61, s9
		s_mov_b32 s62, s50
		s_mov_b32 s63, s51
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s8, s1, s18
		s_lshl_b32 s8, s8, 10
		s_mul_i32 s9, s21, s18
		s_lshl_b32 s9, s9, 8
		s_add_i32 s64, s8, s9
		v_lshrrev_b32_e32 v29, 7, v0
		v_mul_lo_u32 v30, s18, v29
		v_lshlrev_b32_e32 v31, 7, v30
		v_and_b32_e32 v32, 1, v0
		v_mul_lo_u32 v33, s18, v32
		v_add3_u32 v34, s64, v31, v33
		v_lshrrev_b32_e32 v35, 6, v0
		v_and_b32_e32 v35, 1, v35
		v_mul_lo_u32 v36, s18, v35
		v_lshlrev_b32_e32 v37, 6, v36
		v_lshrrev_b32_e32 v38, 5, v0
		v_and_b32_e32 v38, 1, v38
		v_mul_lo_u32 v39, s18, v38
		v_lshlrev_b32_e32 v40, 5, v39
		v_add3_u32 v34, v34, v37, v40
		v_and_b32_e32 v41, 1, v1
		v_mul_lo_u32 v42, s18, v41
		v_lshlrev_b32_e32 v43, 4, v42
		v_and_b32_e32 v24, 1, v24
		v_mul_lo_u32 v44, s18, v24
		v_lshlrev_b32_e32 v45, 3, v44
		v_add3_u32 v34, v34, v43, v45
		v_lshrrev_b32_e32 v46, 2, v0
		v_and_b32_e32 v46, 1, v46
		v_mul_lo_u32 v47, s18, v46
		v_lshlrev_b32_e32 v47, 2, v47
		v_lshrrev_b32_e32 v48, 1, v0
		v_and_b32_e32 v48, 1, v48
		v_mul_lo_u32 v49, s18, v48
		v_lshlrev_b32_e32 v49, 1, v49
		v_add3_u32 v34, v34, v47, v49
		buffer_load_dwordx2 v[50:51], v34, s[60:63], 0 offen
		s_mov_b32 s68, s10
		s_mov_b32 s69, s11
		s_mov_b32 s70, s50
		s_mov_b32 s71, s51
		s_mul_i32 s10, s0, s19
		s_lshl_b32 s10, s10, 8
		v_mul_lo_u32 v34, s19, v29
		v_lshlrev_b32_e32 v52, 6, v34
		v_mul_lo_u32 v53, s19, v35
		v_lshlrev_b32_e32 v54, 5, v53
		v_add3_u32 v55, s10, v52, v54
		v_mul_lo_u32 v56, s19, v38
		v_lshlrev_b32_e32 v57, 4, v56
		v_mul_lo_u32 v58, s19, v41
		v_lshlrev_b32_e32 v59, 3, v58
		v_add3_u32 v55, v55, v57, v59
		v_mul_lo_u32 v60, s19, v24
		v_lshlrev_b32_e32 v61, 2, v60
		v_mul_lo_u32 v62, s19, v46
		v_lshlrev_b32_e32 v62, 1, v62
		v_add3_u32 v55, v55, v61, v62
		v_mul_lo_u32 v63, s19, v48
		v_lshlrev_b32_e32 v64, 2, v32
		v_add3_u32 v55, v55, v63, v64
		buffer_load_dword v65, v55, s[68:71], 0 offen
		s_lshl_b32 s11, s15, 7
		s_add_i32 s65, s11, s4
		v_add3_u32 v55, s65, v28, v27
		s_add_i32 s66, s2, 0x18000
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_mul_i32 s67, 0xa0, s15
		s_add_i32 s72, s67, s4
		v_add3_u32 v55, s72, v28, v27
		s_add_i32 s73, s2, 0x19000
		s_mov_b32 m0, s73
		s_nop 0
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_mul_i32 s74, 0xc0, s15
		s_add_i32 s75, s74, s4
		v_add3_u32 v55, s75, v28, v27
		s_add_i32 s76, s2, 0x1a000
		s_mov_b32 m0, s76
		s_nop 0
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s77, s15, s4
		v_add3_u32 v55, s77, v28, v27
		s_add_i32 s78, s2, 0x1b000
		s_mov_b32 m0, s78
		s_nop 0
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_lshl_b32 s79, s19, 7
		s_add_i32 s80, s79, s10
		v_lshlrev_b32_e32 v34, 4, v34
		v_lshlrev_b32_e32 v53, 3, v53
		v_add3_u32 v55, s80, v34, v53
		v_lshlrev_b32_e32 v56, 2, v56
		v_lshlrev_b32_e32 v58, 1, v58
		v_add3_u32 v55, v55, v56, v58
		v_add3_u32 v55, v55, v60, v32
		v_lshlrev_b32_e32 v66, 2, v46
		v_lshlrev_b32_e32 v67, 1, v48
		v_add3_u32 v55, v55, v66, v67
		v_lshlrev_b32_e32 v68, 4, v29
		v_lshlrev_b32_e32 v69, 3, v35
		v_lshlrev_b32_e32 v70, 2, v38
		v_add_u32_e32 v71, 32, v24
		v_lshlrev_b32_e32 v72, 1, v41
		v_xor_b32_e32 v71, v71, v72
		v_xor_b32_e32 v71, v70, v71
		v_xor_b32_e32 v71, v69, v71
		v_xor_b32_e32 v71, v68, v71
		v_mul_lo_u32 v73, s19, v71
		v_add3_u32 v74, s80, v73, v32
		v_add3_u32 v74, v74, v66, v67
		v_add_u32_e32 v75, 64, v24
		v_xor_b32_e32 v75, v75, v72
		v_xor_b32_e32 v75, v70, v75
		v_xor_b32_e32 v75, v69, v75
		v_xor_b32_e32 v75, v68, v75
		v_mul_lo_u32 v76, s19, v75
		v_add3_u32 v77, s80, v76, v32
		v_add3_u32 v77, v77, v66, v67
		v_add_u32_e32 v78, 0x60, v24
		v_xor_b32_e32 v78, v78, v72
		v_xor_b32_e32 v78, v70, v78
		v_xor_b32_e32 v78, v69, v78
		v_xor_b32_e32 v78, v68, v78
		v_mul_lo_u32 v79, s19, v78
		v_add3_u32 v80, s80, v79, v32
		v_add3_u32 v80, v80, v66, v67
		buffer_load_ubyte v81, v55, s[68:71], 0 offen
		buffer_load_ubyte v55, v74, s[68:71], 0 offen
		buffer_load_ubyte v74, v77, s[68:71], 0 offen
		buffer_load_ubyte v77, v80, s[68:71], 0 offen
		s_add_i32 s19, s3, 0x80
		s_add_i32 s19, s19, s20
		v_add3_u32 v80, s19, v25, v27
		s_add_i32 s81, s2, 0x8000
		s_mov_b32 m0, s81
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s23, s23, 0x80
		s_add_i32 s23, s23, s3
		s_add_i32 s23, s23, s20
		v_add3_u32 v80, s23, v25, v27
		s_add_i32 s82, s2, 0x9000
		s_mov_b32 m0, s82
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s30, s30, 0x80
		s_add_i32 s30, s30, s3
		s_add_i32 s30, s30, s20
		v_add3_u32 v80, s30, v25, v27
		s_add_i32 s83, s2, 0xa000
		s_mov_b32 m0, s83
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 0x80
		s_add_i32 s33, s33, s3
		s_add_i32 s33, s33, s20
		v_add3_u32 v80, s33, v25, v27
		s_add_i32 s84, s2, 0xb000
		s_mov_b32 m0, s84
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s36, s36, 0x80
		s_add_i32 s36, s36, s3
		s_add_i32 s36, s36, s20
		v_add3_u32 v80, s36, v25, v27
		s_add_i32 s85, s2, 0xc000
		s_mov_b32 m0, s85
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s39, s39, 0x80
		s_add_i32 s39, s39, s3
		s_add_i32 s39, s39, s20
		v_add3_u32 v80, s39, v25, v27
		s_add_i32 s86, s2, 0xd000
		s_mov_b32 m0, s86
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s42, s42, 0x80
		s_add_i32 s42, s42, s3
		s_add_i32 s42, s42, s20
		v_add3_u32 v80, s42, v25, v27
		s_add_i32 s87, s2, 0xe000
		s_mov_b32 m0, s87
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s20
		v_add3_u32 v80, s3, v25, v27
		s_add_i32 s14, s2, 0xf000
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s20, s4, 0x80
		v_add3_u32 v80, s20, v28, v27
		s_add_i32 s88, s2, 0x14000
		s_mov_b32 m0, s88
		s_nop 0
		buffer_load_dwordx4 v80, s[48:51], 0 offen lds
		s_add_i32 s47, s47, 0x80
		s_add_i32 s47, s47, s4
		v_add3_u32 v80, s47, v28, v27
		s_add_i32 s89, s2, 0x15000
		s_mov_b32 m0, s89
		s_nop 0
		buffer_load_dwordx4 v80, s[48:51], 0 offen lds
		s_add_i32 s54, s54, 0x80
		s_add_i32 s54, s54, s4
		v_add3_u32 v80, s54, v28, v27
		s_add_i32 s90, s2, 0x16000
		s_mov_b32 m0, s90
		s_nop 0
		buffer_load_dwordx4 v80, s[48:51], 0 offen lds
		s_add_i32 s57, s57, 0x80
		s_add_i32 s57, s57, s4
		v_add3_u32 v80, s57, v28, v27
		s_add_i32 s91, s2, 0x17000
		s_mov_b32 m0, s91
		s_nop 0
		buffer_load_dwordx4 v80, s[48:51], 0 offen lds
		s_add_i32 s8, s8, 8
		s_add_i32 s8, s8, s9
		v_lshlrev_b32_e32 v30, 4, v30
		v_lshlrev_b32_e32 v36, 3, v36
		v_add3_u32 v80, s8, v30, v36
		v_lshlrev_b32_e32 v39, 2, v39
		v_lshlrev_b32_e32 v42, 1, v42
		v_add3_u32 v80, v80, v39, v42
		v_add3_u32 v80, v80, v44, v32
		v_add3_u32 v80, v80, v66, v67
		v_mul_lo_u32 v82, s18, v71
		v_add3_u32 v83, v32, v66, v67
		v_add3_u32 v84, v82, v83, s8
		v_mul_lo_u32 v85, s18, v75
		v_add3_u32 v86, v85, v83, s8
		v_mul_lo_u32 v87, s18, v78
		v_add3_u32 v83, v87, v83, s8
		v_add_u32_e32 v88, 0x80, v24
		v_xor_b32_e32 v88, v88, v72
		v_xor_b32_e32 v88, v70, v88
		v_xor_b32_e32 v88, v69, v88
		v_xor_b32_e32 v88, v68, v88
		v_mul_lo_u32 v89, s18, v88
		v_add3_u32 v90, s8, v89, v32
		v_add3_u32 v90, v90, v66, v67
		v_add_u32_e32 v91, 0xa0, v24
		v_xor_b32_e32 v91, v91, v72
		v_xor_b32_e32 v91, v70, v91
		v_xor_b32_e32 v91, v69, v91
		v_xor_b32_e32 v91, v68, v91
		v_mul_lo_u32 v92, s18, v91
		v_add3_u32 v93, s8, v92, v32
		v_add3_u32 v93, v93, v66, v67
		v_add_u32_e32 v94, 0xc0, v24
		v_xor_b32_e32 v94, v94, v72
		v_xor_b32_e32 v94, v70, v94
		v_xor_b32_e32 v94, v69, v94
		v_xor_b32_e32 v94, v68, v94
		v_mul_lo_u32 v95, s18, v94
		v_add3_u32 v96, s8, v95, v32
		v_add3_u32 v96, v96, v66, v67
		v_add_u32_e32 v97, 0xe0, v24
		v_xor_b32_e32 v72, v97, v72
		v_xor_b32_e32 v70, v70, v72
		v_xor_b32_e32 v69, v69, v70
		v_xor_b32_e32 v69, v68, v69
		v_mul_lo_u32 v70, s18, v69
		v_add3_u32 v72, s8, v70, v32
		v_add3_u32 v72, v72, v66, v67
		buffer_load_ubyte v97, v80, s[60:63], 0 offen
		buffer_load_ubyte v80, v84, s[60:63], 0 offen
		buffer_load_ubyte v84, v86, s[60:63], 0 offen
		buffer_load_ubyte v86, v83, s[60:63], 0 offen
		buffer_load_ubyte v83, v90, s[60:63], 0 offen
		buffer_load_ubyte v90, v93, s[60:63], 0 offen
		buffer_load_ubyte v93, v96, s[60:63], 0 offen
		buffer_load_ubyte v96, v72, s[60:63], 0 offen
		s_add_i32 s9, s10, 8
		v_add3_u32 v72, s9, v34, v53
		v_add3_u32 v72, v72, v56, v58
		v_add3_u32 v72, v72, v60, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v98, v32, v66, v67
		v_add3_u32 v99, v73, v98, s9
		v_add3_u32 v100, v76, v98, s9
		v_add3_u32 v98, v79, v98, s9
		buffer_load_ubyte v101, v72, s[68:71], 0 offen
		buffer_load_ubyte v72, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v100, s[68:71], 0 offen
		buffer_load_ubyte v100, v98, s[68:71], 0 offen
		s_add_i32 s11, s11, 0x80
		s_add_i32 s11, s11, s4
		v_add3_u32 v98, s11, v28, v27
		s_add_i32 s18, s2, 0x1c000
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s67, s67, 0x80
		s_add_i32 s67, s67, s4
		v_add3_u32 v98, s67, v28, v27
		s_add_i32 s92, s2, 0x1d000
		s_mov_b32 m0, s92
		s_nop 0
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s74, s74, 0x80
		s_add_i32 s74, s74, s4
		v_add3_u32 v98, s74, v28, v27
		s_add_i32 s93, s2, 0x1e000
		s_mov_b32 m0, s93
		s_nop 0
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s4
		v_add3_u32 v98, s15, v28, v27
		s_add_i32 s94, s2, 0x1f000
		s_mov_b32 m0, s94
		s_nop 0
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s79, s79, 8
		s_add_i32 s79, s79, s10
		v_add3_u32 v98, s79, v34, v53
		v_add3_u32 v98, v98, v56, v58
		v_add3_u32 v98, v98, v60, v32
		v_add3_u32 v98, v98, v66, v67
		v_add3_u32 v102, v32, v66, v67
		v_add3_u32 v103, v73, v102, s79
		v_add3_u32 v104, v76, v102, s79
		v_add3_u32 v102, v79, v102, s79
		buffer_load_ubyte v105, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v103, s[68:71], 0 offen
		buffer_load_ubyte v103, v104, s[68:71], 0 offen
		buffer_load_ubyte v104, v102, s[68:71], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v102, 11, v29
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
		v_lshlrev_b32_e32 v108, 11, v35
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
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v50, 2, v0
		v_add_u32_e32 v50, 0x20000, v50
		s_waitcnt vmcnt(40)
		ds_write_b32 v50, v65 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v51, 7, v29
		v_add_u32_e32 v51, 0x20000, v51
		v_lshlrev_b32_e32 v65, 3, v32
		v_add_u32_e32 v51, v51, v65
		v_lshlrev_b32_e32 v108, 1, v38
		v_add_u32_e32 v109, v51, v108
		v_lshlrev_b32_e32 v110, 6, v24
		v_add3_u32 v109, v109, v41, v110
		v_lshlrev_b32_e32 v111, 5, v46
		v_lshlrev_b32_e32 v112, 4, v48
		v_add3_u32 v109, v109, v111, v112
		ds_read_u8 v113, v109
		v_add3_u32 v51, v51, v110, v111
		v_add_u32_e32 v114, 4, v41
		v_xor_b32_e32 v114, v114, v108
		v_add3_u32 v51, v51, v112, v114
		ds_read_u8 v115, v51
		v_add_u32_e32 v116, 0x20000, v108
		v_add_u32_e32 v116, v116, v41
		v_lshlrev_b32_e32 v117, 3, v24
		v_add_u32_e32 v118, 32, v32
		v_xor_b32_e32 v118, v118, v67
		v_xor_b32_e32 v118, v66, v118
		v_xor_b32_e32 v118, v117, v118
		v_xor_b32_e32 v119, v68, v118
		v_lshl_add_u32 v120, v119, 3, v116
		ds_read_u8 v121, v120
		v_add_u32_e32 v122, 0x20000, v114
		v_lshl_add_u32 v119, v119, 3, v122
		ds_read_u8 v123, v119
		v_add_u32_e32 v124, 64, v32
		v_xor_b32_e32 v124, v124, v67
		v_xor_b32_e32 v124, v66, v124
		v_xor_b32_e32 v124, v117, v124
		v_xor_b32_e32 v125, v68, v124
		v_lshl_add_u32 v126, v125, 3, v116
		ds_read_u8 v127, v126
		v_lshl_add_u32 v125, v125, 3, v122
		ds_read_u8 v128, v125
		v_add_u32_e32 v129, 0x60, v32
		v_xor_b32_e32 v129, v129, v67
		v_xor_b32_e32 v129, v66, v129
		v_xor_b32_e32 v129, v117, v129
		v_xor_b32_e32 v130, v68, v129
		v_lshl_add_u32 v131, v130, 3, v116
		ds_read_u8 v132, v131
		v_lshl_add_u32 v130, v130, 3, v122
		ds_read_u8 v133, v130
		v_add_u32_e32 v134, 0x80, v32
		v_xor_b32_e32 v134, v134, v67
		v_xor_b32_e32 v134, v66, v134
		v_xor_b32_e32 v134, v117, v134
		v_xor_b32_e32 v134, v68, v134
		v_lshl_add_u32 v135, v134, 3, v116
		ds_read_u8 v136, v135
		v_lshl_add_u32 v134, v134, 3, v122
		ds_read_u8 v137, v134
		v_add_u32_e32 v138, 0xa0, v32
		v_xor_b32_e32 v138, v138, v67
		v_xor_b32_e32 v138, v66, v138
		v_xor_b32_e32 v138, v117, v138
		v_xor_b32_e32 v138, v68, v138
		v_lshl_add_u32 v139, v138, 3, v116
		ds_read_u8 v140, v139
		v_lshl_add_u32 v138, v138, 3, v122
		ds_read_u8 v141, v138
		v_add_u32_e32 v142, 0xc0, v32
		v_xor_b32_e32 v142, v142, v67
		v_xor_b32_e32 v142, v66, v142
		v_xor_b32_e32 v142, v117, v142
		v_xor_b32_e32 v142, v68, v142
		v_lshl_add_u32 v143, v142, 3, v116
		ds_read_u8 v144, v143
		v_lshl_add_u32 v142, v142, 3, v122
		ds_read_u8 v145, v142
		v_add_u32_e32 v146, 0xe0, v32
		v_xor_b32_e32 v146, v146, v67
		v_xor_b32_e32 v146, v66, v146
		v_xor_b32_e32 v117, v117, v146
		v_xor_b32_e32 v68, v68, v117
		v_lshl_add_u32 v117, v68, 3, v116
		ds_read_u8 v146, v117
		v_lshl_add_u32 v68, v68, 3, v122
		ds_read_u8 v147, v68
		v_add_u32_e32 v65, 0x20000, v65
		v_lshl_add_u32 v65, v35, 7, v65
		v_add_u32_e32 v148, v65, v108
		v_add3_u32 v148, v148, v41, v110
		v_add3_u32 v148, v148, v111, v112
		ds_read_u8 v149, v148 offset:2048
		v_add3_u32 v65, v65, v110, v111
		v_add3_u32 v65, v65, v112, v114
		ds_read_u8 v110, v65 offset:2048
		v_lshlrev_b32_e32 v111, 4, v35
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
		s_mov_b32 s95, 0x100
		s_mov_b32 s96, s95
		s_mov_b32 s95, 16
		s_mov_b32 s97, s95
		s_mov_b32 s95, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v154, 0x20000, v32
		v_add3_u32 v154, v154, v66, v67
		v_lshl_add_u32 v71, v71, 3, v154
		v_lshl_add_u32 v75, v75, 3, v154
		v_lshl_add_u32 v78, v78, 3, v154
		v_lshl_add_u32 v88, v88, 3, v154
		v_lshl_add_u32 v91, v91, 3, v154
		v_lshl_add_u32 v94, v94, 3, v154
		v_lshl_add_u32 v69, v69, 3, v154
		v_add3_u32 v154, v32, v66, v67
		v_add3_u32 v155, v32, v66, v67
		v_add3_u32 v156, v32, v66, v67
		v_add3_u32 v157, v32, v66, v67
		v_add3_u32 v158, v32, v66, v67
		s_mov_b32 s98, s96
		s_mov_b32 s99, s97
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[64:67], a[0:3], v[4:7], v110, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v110, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v110, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v110, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v110, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v110, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v110, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v110, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v118, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v118, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v118, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v118, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[4:7], v[164:167], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[12:15], v[180:183], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v118, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v118, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v118, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v118, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[20:23], v[196:199], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[28:31], v[212:215], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v110, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v110, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v110, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v110, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v110, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v110, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v110, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v110, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v110, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v110, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v110, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v110, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v110, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v110, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v110, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v110, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v118, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v118, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v118, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v118, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[36:39], v[228:231], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[44:47], v[244:247], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v118, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v118, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v118, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v118, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v110, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v110, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v110, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v110, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v110, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v110, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v110, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v110, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 a[64:67], v106 offset:32768
		ds_read_b128 a[68:71], v106 offset:32832
		ds_read_b128 a[72:75], v106 offset:36864
		ds_read_b128 a[76:79], v106 offset:36928
		ds_read_b128 a[80:83], v106 offset:40960
		ds_read_b128 a[84:87], v106 offset:41024
		ds_read_b128 a[88:91], v106 offset:45056
		ds_read_b128 v[144:147], v106 offset:45120
		s_waitcnt vmcnt(35)
		ds_write_b8 v0, v81 offset:2048
		s_waitcnt vmcnt(34)
		ds_write_b8 v71, v55 offset:2048
		s_waitcnt vmcnt(33)
		ds_write_b8 v75, v74 offset:2048
		s_waitcnt vmcnt(32)
		ds_write_b8 v78, v77 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v55, v148 offset:2048
		ds_read_u8 v74, v65 offset:2048
		ds_read_u8 v77, v114 offset:2048
		ds_read_u8 v81, v112 offset:2048
		ds_read_u8 v110, v151 offset:2048
		ds_read_u8 v118, v124 offset:2048
		ds_read_u8 v122, v116 offset:2048
		ds_read_u8 v127, v111 offset:2048
		s_add_i32 s100, s22, s96
		s_mov_b32 m0, s2
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s28, s96
		s_mov_b32 m0, s29
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s31, s96
		s_mov_b32 m0, s32
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s34, s96
		s_mov_b32 m0, s35
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s37, s96
		s_mov_b32 m0, s38
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s40, s96
		s_mov_b32 m0, s41
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s43, s96
		s_mov_b32 m0, s44
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s45, s96
		s_mov_b32 m0, s46
		v_add3_u32 v128, s100, v25, v27
		buffer_load_dwordx4 v128, s[24:27], 0 offen lds
		s_add_i32 s100, s4, s98
		s_mov_b32 m0, s5
		v_add3_u32 v128, s100, v28, v27
		buffer_load_dwordx4 v128, s[48:51], 0 offen lds
		s_add_i32 s100, s52, s98
		s_mov_b32 m0, s53
		v_add3_u32 v128, s100, v28, v27
		buffer_load_dwordx4 v128, s[48:51], 0 offen lds
		s_add_i32 s100, s55, s98
		s_mov_b32 m0, s56
		v_add3_u32 v128, s100, v28, v27
		buffer_load_dwordx4 v128, s[48:51], 0 offen lds
		s_add_i32 s100, s58, s98
		s_mov_b32 m0, s59
		v_add3_u32 v128, s100, v28, v27
		buffer_load_dwordx4 v128, s[48:51], 0 offen lds
		s_add_i32 s100, s64, s97
		v_add3_u32 v128, s100, v31, v33
		v_add3_u32 v128, v128, v37, v40
		v_add3_u32 v128, v128, v43, v45
		v_add3_u32 v128, v128, v47, v49
		buffer_load_dwordx2 v[132:133], v128, s[60:63], 0 offen
		s_add_i32 s100, s10, s99
		v_add3_u32 v128, s100, v52, v54
		v_add3_u32 v128, v128, v57, v59
		v_add3_u32 v128, v128, v61, v62
		v_add3_u32 v128, v128, v63, v64
		buffer_load_dword v129, v128, s[68:71], 0 offen
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v55, 0xff, v55
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v74, 0xff, v74
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v55, v55, v74
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v74, 0xff, v77
		v_lshlrev_b32_e32 v74, 16, v74
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v77, 0xff, v81
		v_lshlrev_b32_e32 v77, 24, v77
		v_or3_b32 v55, v55, v74, v77
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v74, 0xff, v110
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v77, 0xff, v118
		v_lshlrev_b32_e32 v77, 8, v77
		v_or_b32_e32 v74, v74, v77
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v77, 0xff, v122
		v_lshlrev_b32_e32 v77, 16, v77
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v81, 0xff, v127
		v_lshlrev_b32_e32 v81, 24, v81
		v_or3_b32 v74, v74, v77, v81
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v55, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v55, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v55, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v55, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v55, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v55, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v55, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v55, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v74, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v74, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v74, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v74, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v74, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], a[4:7], a[140:143], v74, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[144:147], a[12:15], a[156:159], v74, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v74, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v74, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v74, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v74, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v74, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v74, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], a[20:23], a[172:175], v74, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], a[28:31], a[188:191], v74, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v74, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v55, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v55, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v55, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v55, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v55, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v55, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v55, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v55, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v55, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v55, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v55, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v55, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v55, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v55, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v55, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v55, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v74, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v74, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v74, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v74, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v74, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[144:147], a[36:39], a[204:207], v74, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[144:147], a[44:47], a[220:223], v74, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v74, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v74, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v74, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[88:91], a[56:59], v[252:255], v74, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v74, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v74, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[144:147], a[52:55], a[236:239], v74, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[144:147], a[60:63], v[252:255], v74, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v74, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v55, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v55, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v55, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v55, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v55, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v55, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v55, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v55, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
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
		ds_write_b8 v71, v80
		s_waitcnt vmcnt(31)
		ds_write_b8 v75, v84
		s_waitcnt vmcnt(30)
		ds_write_b8 v78, v86
		s_waitcnt vmcnt(29)
		ds_write_b8 v88, v83
		s_waitcnt vmcnt(28)
		ds_write_b8 v91, v90
		s_waitcnt vmcnt(27)
		ds_write_b8 v94, v93
		s_waitcnt vmcnt(26)
		ds_write_b8 v69, v96
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v101 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v71, v72 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v75, v99 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v78, v100 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v72, v109
		ds_read_u8 v80, v51
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
		ds_read_u8 v110, v143
		ds_read_u8 v113, v142
		ds_read_u8 v115, v117
		ds_read_u8 v118, v68
		ds_read_u8 v121, v148 offset:2048
		ds_read_u8 v122, v65 offset:2048
		ds_read_u8 v123, v114 offset:2048
		ds_read_u8 v127, v112 offset:2048
		ds_read_u8 v128, v151 offset:2048
		ds_read_u8 v136, v124 offset:2048
		ds_read_u8 v137, v116 offset:2048
		ds_read_u8 v140, v111 offset:2048
		s_add_i32 s100, s65, s98
		s_mov_b32 m0, s66
		v_add3_u32 v55, s100, v28, v27
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_add_i32 s100, s72, s98
		s_mov_b32 m0, s73
		v_add3_u32 v55, s100, v28, v27
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_add_i32 s100, s75, s98
		s_mov_b32 m0, s76
		v_add3_u32 v55, s100, v28, v27
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_add_i32 s100, s77, s98
		s_mov_b32 m0, s78
		v_add3_u32 v55, s100, v28, v27
		buffer_load_dwordx4 v55, s[48:51], 0 offen lds
		s_add_i32 s100, s80, s99
		v_add3_u32 v55, s100, v34, v53
		v_add3_u32 v55, v55, v56, v58
		v_add3_u32 v55, v55, v60, v32
		v_add3_u32 v55, v55, v66, v67
		v_add3_u32 v74, v73, v154, s100
		v_add3_u32 v77, v76, v154, s100
		v_add3_u32 v141, v79, v154, s100
		buffer_load_ubyte v81, v55, s[68:71], 0 offen
		buffer_load_ubyte v55, v74, s[68:71], 0 offen
		buffer_load_ubyte v74, v77, s[68:71], 0 offen
		buffer_load_ubyte v77, v141, s[68:71], 0 offen
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v72, 0xff, v72
		v_and_b32_e32 v80, 0xff, v80
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v83
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v84
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v141, v72, v80, v83
		v_and_b32_e32 v72, 0xff, v86
		v_and_b32_e32 v80, 0xff, v90
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v93
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v96
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v149, v72, v80, v83
		v_and_b32_e32 v72, 0xff, v97
		v_and_b32_e32 v80, 0xff, v99
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v80, 0xff, v100
		v_lshlrev_b32_e32 v80, 16, v80
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v83, 0xff, v101
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v150, v72, v80, v83
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v72, 0xff, v110
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v80, 0xff, v113
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v80, 0xff, v115
		v_lshlrev_b32_e32 v80, 16, v80
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v83, 0xff, v118
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v110, v72, v80, v83
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v72, 0xff, v121
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v80, 0xff, v122
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v80, 0xff, v123
		v_lshlrev_b32_e32 v80, 16, v80
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v83, 0xff, v127
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v72, v72, v80, v83
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v80, 0xff, v128
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v83, 0xff, v136
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v80, v80, v83
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v83, 0xff, v137
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v84, 0xff, v140
		v_lshlrev_b32_e32 v84, 24, v84
		v_or3_b32 v80, v80, v83, v84
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[64:67], a[0:3], v[4:7], v72, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v72, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v72, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v72, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v72, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v72, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v72, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v72, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v80, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v80, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v80, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v80, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v80, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[144:147], a[4:7], v[164:167], v80, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[144:147], a[12:15], v[180:183], v80, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v80, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v80, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v80, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v80, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v80, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v80, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[144:147], a[20:23], v[196:199], v80, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[144:147], a[28:31], v[212:215], v80, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v80, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v72, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v72, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v72, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v72, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v72, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v72, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v72, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v72, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v72, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v72, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v72, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v72, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v72, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v72, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v72, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v72, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v80, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v80, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v80, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v80, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v80, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[144:147], a[36:39], v[228:231], v80, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[144:147], a[44:47], v[244:247], v80, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v80, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v80, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v80, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v80, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v80, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v80, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[144:147], a[52:55], a[108:111], v80, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[144:147], a[60:63], a[124:127], v80, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v80, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v72, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v72, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v72, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v72, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v72, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v72, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v72, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v72, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(26)
		s_barrier
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
		ds_write_b8 v71, v98 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v75, v103 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v78, v104 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v98, v148 offset:2048
		ds_read_u8 v103, v65 offset:2048
		ds_read_u8 v104, v114 offset:2048
		ds_read_u8 v105, v112 offset:2048
		ds_read_u8 v113, v151 offset:2048
		ds_read_u8 v115, v124 offset:2048
		ds_read_u8 v118, v116 offset:2048
		ds_read_u8 v121, v111 offset:2048
		s_add_i32 s100, s19, s96
		s_mov_b32 m0, s81
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s23, s96
		s_mov_b32 m0, s82
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s30, s96
		s_mov_b32 m0, s83
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s33, s96
		s_mov_b32 m0, s84
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s36, s96
		s_mov_b32 m0, s85
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s39, s96
		s_mov_b32 m0, s86
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s42, s96
		s_mov_b32 m0, s87
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s3, s96
		s_mov_b32 m0, s14
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s20, s98
		s_mov_b32 m0, s88
		v_add3_u32 v72, s100, v28, v27
		buffer_load_dwordx4 v72, s[48:51], 0 offen lds
		s_add_i32 s100, s47, s98
		s_mov_b32 m0, s89
		v_add3_u32 v72, s100, v28, v27
		buffer_load_dwordx4 v72, s[48:51], 0 offen lds
		s_add_i32 s100, s54, s98
		s_mov_b32 m0, s90
		v_add3_u32 v72, s100, v28, v27
		buffer_load_dwordx4 v72, s[48:51], 0 offen lds
		s_add_i32 s100, s57, s98
		s_mov_b32 m0, s91
		v_add3_u32 v72, s100, v28, v27
		buffer_load_dwordx4 v72, s[48:51], 0 offen lds
		s_add_i32 s100, s8, s97
		v_add3_u32 v72, s100, v30, v36
		v_add3_u32 v72, v72, v39, v42
		v_add3_u32 v72, v72, v44, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v80, s100, v82, v32
		v_add3_u32 v83, v80, v66, v67
		v_add3_u32 v86, v85, v155, s100
		v_add3_u32 v90, v87, v155, s100
		v_add3_u32 v93, v89, v155, s100
		v_add3_u32 v96, v92, v156, s100
		v_add3_u32 v99, v95, v156, s100
		v_add3_u32 v100, v70, v156, s100
		buffer_load_ubyte v97, v72, s[60:63], 0 offen
		buffer_load_ubyte v80, v83, s[60:63], 0 offen
		buffer_load_ubyte v84, v86, s[60:63], 0 offen
		buffer_load_ubyte v86, v90, s[60:63], 0 offen
		buffer_load_ubyte v83, v93, s[60:63], 0 offen
		buffer_load_ubyte v90, v96, s[60:63], 0 offen
		buffer_load_ubyte v93, v99, s[60:63], 0 offen
		buffer_load_ubyte v96, v100, s[60:63], 0 offen
		s_add_i32 s100, s9, s99
		v_add3_u32 v72, s100, v34, v53
		v_add3_u32 v72, v72, v56, v58
		v_add3_u32 v72, v72, v60, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v99, v73, v157, s100
		v_add3_u32 v100, v76, v157, s100
		v_add3_u32 v122, v79, v157, s100
		buffer_load_ubyte v101, v72, s[68:71], 0 offen
		buffer_load_ubyte v72, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v100, s[68:71], 0 offen
		buffer_load_ubyte v100, v122, s[68:71], 0 offen
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v98, 0xff, v98
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v103, 0xff, v103
		v_lshlrev_b32_e32 v103, 8, v103
		v_or_b32_e32 v98, v98, v103
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v103, 0xff, v104
		v_lshlrev_b32_e32 v103, 16, v103
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v104, 0xff, v105
		v_lshlrev_b32_e32 v104, 24, v104
		v_or3_b32 v98, v98, v103, v104
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v103, 0xff, v113
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v104, 0xff, v115
		v_lshlrev_b32_e32 v104, 8, v104
		v_or_b32_e32 v103, v103, v104
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v104, 0xff, v118
		v_lshlrev_b32_e32 v104, 16, v104
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v105, 0xff, v121
		v_lshlrev_b32_e32 v105, 24, v105
		v_or3_b32 v103, v103, v104, v105
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v98, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v98, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v98, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v98, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v98, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v98, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v98, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v98, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v103, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v103, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v103, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v103, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v103, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], a[4:7], a[140:143], v103, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[144:147], a[12:15], a[156:159], v103, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v103, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v103, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v103, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v103, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v103, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], a[20:23], a[172:175], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], a[28:31], a[188:191], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v98, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v98, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v98, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v98, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v98, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v98, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v98, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v98, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v98, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v98, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v98, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v98, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v98, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v98, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v98, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v98, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v103, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v103, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v103, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v103, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[144:147], a[36:39], a[204:207], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[144:147], a[44:47], a[220:223], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v103, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v103, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], a[88:91], a[56:59], v[252:255], v103, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v103, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v103, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[144:147], a[52:55], a[236:239], v103, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[144:147], a[60:63], v[252:255], v103, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v103, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v98, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v98, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v98, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v98, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v98, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v98, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v98, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v98, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
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
		ds_write_b64 v107, v[132:133]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(32)
		ds_write_b32 v50, v129 offset:2048
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
		ds_read_u8 v147, v68
		ds_read_u8 v149, v148 offset:2048
		ds_read_u8 v110, v65 offset:2048
		ds_read_u8 v118, v114 offset:2048
		ds_read_u8 v150, v112 offset:2048
		ds_read_u8 v152, v151 offset:2048
		ds_read_u8 v153, v124 offset:2048
		ds_read_u8 v129, v116 offset:2048
		ds_read_u8 v122, v111 offset:2048
		s_add_i32 s100, s11, s98
		s_mov_b32 m0, s18
		v_add3_u32 v98, s100, v28, v27
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s100, s67, s98
		s_mov_b32 m0, s92
		v_add3_u32 v98, s100, v28, v27
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s100, s74, s98
		s_mov_b32 m0, s93
		v_add3_u32 v98, s100, v28, v27
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s100, s15, s98
		s_mov_b32 m0, s94
		v_add3_u32 v98, s100, v28, v27
		buffer_load_dwordx4 v98, s[48:51], 0 offen lds
		s_add_i32 s100, s79, s99
		v_add3_u32 v98, s100, v34, v53
		v_add3_u32 v98, v98, v56, v58
		v_add3_u32 v98, v98, v60, v32
		v_add3_u32 v98, v98, v66, v67
		v_add3_u32 v103, v73, v158, s100
		v_add3_u32 v104, v76, v158, s100
		v_add3_u32 v159, v79, v158, s100
		buffer_load_ubyte v105, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v103, s[68:71], 0 offen
		buffer_load_ubyte v103, v104, s[68:71], 0 offen
		buffer_load_ubyte v104, v159, s[68:71], 0 offen
		s_add_i32 s96, s96, 0x100
		s_add_i32 s98, s98, 0x100
		s_add_i32 s97, s97, 16
		s_add_i32 s99, s99, 16
		s_add_i32 s95, s95, 2
		s_cmp_lt_i32 s95, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v25, 0xff, v113
		v_and_b32_e32 v27, 0xff, v115
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v25, v25, v27
		v_and_b32_e32 v27, 0xff, v121
		v_lshlrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v28, 0xff, v123
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v25, v25, v27, v28
		v_and_b32_e32 v27, 0xff, v127
		v_and_b32_e32 v28, 0xff, v128
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		v_and_b32_e32 v28, 0xff, v132
		v_lshlrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v30, 0xff, v133
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		v_and_b32_e32 v28, 0xff, v136
		v_and_b32_e32 v30, 0xff, v137
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v30, 0xff, v140
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v31, 0xff, v141
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v28, v28, v30, v31
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v30, 0xff, v144
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v31, 0xff, v145
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v30, v30, v31
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v31, 0xff, v146
		v_lshlrev_b32_e32 v31, 16, v31
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v33, 0xff, v147
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v30, v30, v31, v33
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v149
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v110
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v118
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v34, 0xff, v150
		v_lshlrev_b32_e32 v34, 24, v34
		v_or3_b32 v31, v31, v33, v34
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v152
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v34, 0xff, v153
		v_lshlrev_b32_e32 v34, 8, v34
		v_or_b32_e32 v33, v33, v34
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v34, 0xff, v129
		v_lshlrev_b32_e32 v34, 16, v34
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v122
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v34, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[64:67], a[0:3], v[4:7], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[68:71], a[4:7], v[4:7], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[4:7], v[164:167], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[12:15], v[180:183], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[20:23], v[196:199], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[28:31], v[212:215], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[36:39], v[228:231], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[44:47], v[244:247], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 a[64:67], v106 offset:32768
		ds_read_b128 a[68:71], v106 offset:32832
		ds_read_b128 v[56:59], v106 offset:36864
		ds_read_b128 a[72:75], v106 offset:36928
		ds_read_b128 v[60:63], v106 offset:40960
		ds_read_b128 v[144:147], v106 offset:41024
		ds_read_b128 v[152:155], v106 offset:45056
		ds_read_b128 v[156:159], v106 offset:45120
		ds_write_b8 v0, v81 offset:2048
		ds_write_b8 v71, v55 offset:2048
		ds_write_b8 v75, v74 offset:2048
		ds_write_b8 v78, v77 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v31, v148 offset:2048
		ds_read_u8 v33, v65 offset:2048
		ds_read_u8 v34, v114 offset:2048
		ds_read_u8 v36, v112 offset:2048
		ds_read_u8 v37, v151 offset:2048
		ds_read_u8 v39, v124 offset:2048
		ds_read_u8 v40, v116 offset:2048
		ds_read_u8 v42, v111 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v31
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v33
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v34
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v34, 0xff, v36
		v_lshlrev_b32_e32 v34, 24, v34
		v_or3_b32 v31, v31, v33, v34
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v37
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v34, 0xff, v39
		v_lshlrev_b32_e32 v34, 8, v34
		v_or_b32_e32 v33, v33, v34
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v34, 0xff, v40
		v_lshlrev_b32_e32 v34, 16, v34
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v42
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v34, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[0:3], a[132:135], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[8:11], a[148:151], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[4:7], a[132:135], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[12:15], a[148:151], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], a[0:3], a[136:139], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[152:155], a[0:3], a[140:143], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[152:155], a[8:11], a[156:159], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], a[8:11], a[152:155], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], a[4:7], a[136:139], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[156:159], a[4:7], a[140:143], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[156:159], a[12:15], a[156:159], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], a[12:15], a[152:155], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], a[16:19], a[168:171], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[152:155], a[16:19], a[172:175], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[152:155], a[24:27], a[188:191], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[60:63], a[24:27], a[184:187], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], a[20:23], a[168:171], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[156:159], a[20:23], a[172:175], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[156:159], a[28:31], a[188:191], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], a[28:31], a[184:187], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[16:19], a[164:167], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[56:59], a[24:27], a[180:183], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[20:23], a[164:167], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[28:31], a[180:183], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], a[32:35], a[196:199], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], a[40:43], a[212:215], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[36:39], a[196:199], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[44:47], a[212:215], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[60:63], a[32:35], a[200:203], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[152:155], a[32:35], a[204:207], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[152:155], a[40:43], a[220:223], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[60:63], a[40:43], a[216:219], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], a[36:39], a[200:203], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[156:159], a[36:39], a[204:207], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[156:159], a[44:47], a[220:223], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], a[44:47], a[216:219], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[60:63], a[48:51], a[232:235], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[152:155], a[48:51], a[236:239], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[152:155], a[56:59], v[252:255], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[60:63], a[56:59], a[248:251], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], a[52:55], a[232:235], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[156:159], a[52:55], a[236:239], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[156:159], a[60:63], v[252:255], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], a[60:63], a[248:251], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[56:59], a[48:51], a[228:231], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[56:59], a[56:59], a[244:247], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[52:55], a[228:231], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[60:63], a[244:247], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
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
		ds_read_b128 v[52:55], v106 offset:16384
		ds_read_b128 a[64:67], v106 offset:16448
		ds_read_b128 v[56:59], v106 offset:20480
		ds_read_b128 a[68:71], v106 offset:20544
		ds_read_b128 v[60:63], v106 offset:24576
		ds_read_b128 v[144:147], v106 offset:24640
		ds_read_b128 v[152:155], v106 offset:28672
		ds_read_b128 v[156:159], v106 offset:28736
		ds_write_b8 v0, v97
		ds_write_b8 v71, v80
		ds_write_b8 v75, v84
		ds_write_b8 v78, v86
		ds_write_b8 v88, v83
		ds_write_b8 v91, v90
		ds_write_b8 v94, v93
		ds_write_b8 v69, v96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v101 offset:2048
		ds_write_b8 v71, v72 offset:2048
		ds_write_b8 v75, v99 offset:2048
		ds_write_b8 v78, v100 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v25, v109
		ds_read_u8 v27, v51
		ds_read_u8 v28, v120
		ds_read_u8 v30, v119
		ds_read_u8 v31, v126
		ds_read_u8 v33, v125
		ds_read_u8 v34, v131
		ds_read_u8 v36, v130
		ds_read_u8 v37, v135
		ds_read_u8 v39, v134
		ds_read_u8 v40, v139
		ds_read_u8 v42, v138
		ds_read_u8 v43, v143
		ds_read_u8 v44, v142
		ds_read_u8 v45, v117
		ds_read_u8 v47, v68
		ds_read_u8 v49, v148 offset:2048
		ds_read_u8 v50, v65 offset:2048
		ds_read_u8 v51, v114 offset:2048
		ds_read_u8 v64, v112 offset:2048
		ds_read_u8 v66, v151 offset:2048
		ds_read_u8 v67, v124 offset:2048
		ds_read_u8 v68, v116 offset:2048
		ds_read_u8 v69, v111 offset:2048
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v25, 0xff, v25
		v_and_b32_e32 v27, 0xff, v27
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v25, v25, v27
		v_and_b32_e32 v27, 0xff, v28
		v_lshlrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v28, 0xff, v30
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v25, v25, v27, v28
		v_and_b32_e32 v27, 0xff, v31
		v_and_b32_e32 v28, 0xff, v33
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		v_and_b32_e32 v28, 0xff, v34
		v_lshlrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v30, 0xff, v36
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		v_and_b32_e32 v28, 0xff, v37
		v_and_b32_e32 v30, 0xff, v39
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v30, 0xff, v40
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v31, 0xff, v42
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v28, v28, v30, v31
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v30, 0xff, v43
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v31, 0xff, v44
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v30, v30, v31
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v31, 0xff, v45
		v_lshlrev_b32_e32 v31, 16, v31
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v33, 0xff, v47
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v30, v30, v31, v33
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v49
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v50
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v51
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v34, 0xff, v64
		v_lshlrev_b32_e32 v34, 24, v34
		v_or3_b32 v31, v31, v33, v34
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v66
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v34, 0xff, v67
		v_lshlrev_b32_e32 v34, 8, v34
		v_or_b32_e32 v33, v33, v34
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v34, 0xff, v68
		v_lshlrev_b32_e32 v34, 16, v34
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v69
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v34, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[52:55], a[0:3], v[4:7], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[56:59], a[0:3], a[96:99], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], a[8:11], v[172:175], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], a[8:11], v[168:171], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[64:67], a[4:7], v[4:7], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[68:71], a[4:7], a[96:99], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[12:15], v[172:175], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[12:15], v[168:171], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[60:63], a[0:3], v[160:163], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[152:155], a[0:3], v[164:167], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[152:155], a[8:11], v[180:183], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], a[8:11], v[176:179], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[144:147], a[4:7], v[160:163], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[156:159], a[4:7], v[164:167], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[156:159], a[12:15], v[180:183], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[144:147], a[12:15], v[176:179], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], a[16:19], v[192:195], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[152:155], a[16:19], v[196:199], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[152:155], a[24:27], v[212:215], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], a[24:27], v[208:211], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[144:147], a[20:23], v[192:195], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[156:159], a[20:23], v[196:199], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[156:159], a[28:31], v[212:215], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[144:147], a[28:31], v[208:211], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], a[16:19], v[184:187], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], a[16:19], v[188:191], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], a[24:27], v[204:207], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], a[24:27], v[200:203], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[20:23], v[184:187], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[20:23], v[188:191], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[28:31], v[204:207], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[28:31], v[200:203], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[32:35], v[216:219], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], a[32:35], v[220:223], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], a[40:43], v[236:239], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], a[40:43], v[232:235], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[36:39], v[216:219], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[36:39], v[220:223], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[44:47], v[236:239], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[44:47], v[232:235], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], a[32:35], v[224:227], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[152:155], a[32:35], v[228:231], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[152:155], a[40:43], v[244:247], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[60:63], a[40:43], v[240:243], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[144:147], a[36:39], v[224:227], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[156:159], a[36:39], v[228:231], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[156:159], a[44:47], v[244:247], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[144:147], a[44:47], v[240:243], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[60:63], a[48:51], a[104:107], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[152:155], a[48:51], a[108:111], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[152:155], a[56:59], a[124:127], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], a[56:59], a[120:123], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], a[52:55], a[104:107], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[156:159], a[52:55], a[108:111], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[156:159], a[60:63], a[124:127], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], a[60:63], a[120:123], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[48:51], v[248:251], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[56:59], a[48:51], a[100:103], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[56:59], a[116:119], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[52:55], a[56:59], a[112:115], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[52:55], v[248:251], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[52:55], a[100:103], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[60:63], a[116:119], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[60:63], a[112:115], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v106 offset:49152
		ds_read_b128 v[56:59], v106 offset:49216
		ds_read_b128 v[60:63], v106 offset:53248
		ds_read_b128 v[80:83], v106 offset:53312
		ds_read_b128 v[84:87], v106 offset:57344
		ds_read_b128 v[88:91], v106 offset:57408
		ds_read_b128 v[92:95], v106 offset:61440
		ds_read_b128 v[120:123], v106 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v105 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v71, v98 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v75, v103 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v78, v104 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v148 offset:2048
		ds_read_u8 v31, v65 offset:2048
		ds_read_u8 v33, v114 offset:2048
		ds_read_u8 v34, v112 offset:2048
		ds_read_u8 v36, v151 offset:2048
		ds_read_u8 v37, v124 offset:2048
		ds_read_u8 v39, v116 offset:2048
		ds_read_u8 v40, v111 offset:2048
		v_cvt_pk_bf16_f32 v64, v4, v5
		v_cvt_pk_bf16_f32 v65, v6, v7
		v_accvgpr_read_b32 v4, a96
		v_accvgpr_read_b32 v5, a97
		v_cvt_pk_bf16_f32 v68, v4, v5
		v_accvgpr_read_b32 v4, a98
		v_accvgpr_read_b32 v5, a99
		v_cvt_pk_bf16_f32 v69, v4, v5
		v_cvt_pk_bf16_f32 v4, v160, v161
		v_cvt_pk_bf16_f32 v5, v162, v163
		v_cvt_pk_bf16_f32 v72, v164, v165
		v_cvt_pk_bf16_f32 v73, v166, v167
		v_cvt_pk_bf16_f32 v66, v168, v169
		v_cvt_pk_bf16_f32 v67, v170, v171
		v_cvt_pk_bf16_f32 v70, v172, v173
		v_cvt_pk_bf16_f32 v71, v174, v175
		v_cvt_pk_bf16_f32 v6, v176, v177
		v_cvt_pk_bf16_f32 v7, v178, v179
		v_cvt_pk_bf16_f32 v74, v180, v181
		v_cvt_pk_bf16_f32 v75, v182, v183
		v_cvt_pk_bf16_f32 v76, v184, v185
		v_cvt_pk_bf16_f32 v77, v186, v187
		v_cvt_pk_bf16_f32 v96, v188, v189
		v_cvt_pk_bf16_f32 v97, v190, v191
		v_cvt_pk_bf16_f32 v100, v192, v193
		v_cvt_pk_bf16_f32 v101, v194, v195
		v_cvt_pk_bf16_f32 v104, v196, v197
		v_cvt_pk_bf16_f32 v105, v198, v199
		v_cvt_pk_bf16_f32 v78, v200, v201
		v_cvt_pk_bf16_f32 v79, v202, v203
		v_cvt_pk_bf16_f32 v98, v204, v205
		v_cvt_pk_bf16_f32 v99, v206, v207
		v_cvt_pk_bf16_f32 v102, v208, v209
		v_cvt_pk_bf16_f32 v103, v210, v211
		v_cvt_pk_bf16_f32 v106, v212, v213
		v_cvt_pk_bf16_f32 v107, v214, v215
		v_cvt_pk_bf16_f32 v112, v216, v217
		v_cvt_pk_bf16_f32 v113, v218, v219
		v_cvt_pk_bf16_f32 v116, v220, v221
		v_cvt_pk_bf16_f32 v117, v222, v223
		v_cvt_pk_bf16_f32 v124, v224, v225
		v_cvt_pk_bf16_f32 v125, v226, v227
		v_cvt_pk_bf16_f32 v128, v228, v229
		v_cvt_pk_bf16_f32 v129, v230, v231
		v_cvt_pk_bf16_f32 v114, v232, v233
		v_cvt_pk_bf16_f32 v115, v234, v235
		v_cvt_pk_bf16_f32 v118, v236, v237
		v_cvt_pk_bf16_f32 v119, v238, v239
		v_cvt_pk_bf16_f32 v126, v240, v241
		v_cvt_pk_bf16_f32 v127, v242, v243
		v_cvt_pk_bf16_f32 v130, v244, v245
		v_cvt_pk_bf16_f32 v131, v246, v247
		v_cvt_pk_bf16_f32 v132, v248, v249
		v_cvt_pk_bf16_f32 v133, v250, v251
		v_accvgpr_read_b32 v42, a100
		v_accvgpr_read_b32 v43, a101
		v_cvt_pk_bf16_f32 v136, v42, v43
		v_accvgpr_read_b32 v42, a102
		v_accvgpr_read_b32 v43, a103
		v_cvt_pk_bf16_f32 v137, v42, v43
		v_accvgpr_read_b32 v42, a104
		v_accvgpr_read_b32 v43, a105
		v_cvt_pk_bf16_f32 v140, v42, v43
		v_accvgpr_read_b32 v42, a106
		v_accvgpr_read_b32 v43, a107
		v_cvt_pk_bf16_f32 v141, v42, v43
		v_accvgpr_read_b32 v42, a108
		v_accvgpr_read_b32 v43, a109
		v_cvt_pk_bf16_f32 v144, v42, v43
		v_accvgpr_read_b32 v42, a110
		v_accvgpr_read_b32 v43, a111
		v_cvt_pk_bf16_f32 v145, v42, v43
		v_accvgpr_read_b32 v42, a112
		v_accvgpr_read_b32 v43, a113
		v_cvt_pk_bf16_f32 v134, v42, v43
		v_accvgpr_read_b32 v42, a114
		v_accvgpr_read_b32 v43, a115
		v_cvt_pk_bf16_f32 v135, v42, v43
		v_accvgpr_read_b32 v42, a116
		v_accvgpr_read_b32 v43, a117
		v_cvt_pk_bf16_f32 v138, v42, v43
		v_accvgpr_read_b32 v42, a118
		v_accvgpr_read_b32 v43, a119
		v_cvt_pk_bf16_f32 v139, v42, v43
		v_accvgpr_read_b32 v42, a120
		v_accvgpr_read_b32 v43, a121
		v_cvt_pk_bf16_f32 v142, v42, v43
		v_accvgpr_read_b32 v42, a122
		v_accvgpr_read_b32 v43, a123
		v_cvt_pk_bf16_f32 v143, v42, v43
		v_accvgpr_read_b32 v42, a124
		v_accvgpr_read_b32 v43, a125
		v_cvt_pk_bf16_f32 v146, v42, v43
		v_accvgpr_read_b32 v42, a126
		v_accvgpr_read_b32 v43, a127
		v_cvt_pk_bf16_f32 v147, v42, v43
		v_add_u32_e32 v26, 0x20000, v26
		ds_write_b128 v26, v[64:67] offset:3072
		ds_write_b128 v26, v[68:71] offset:7168
		ds_write_b128 v26, v[4:7] offset:11264
		ds_write_b128 v26, v[72:75] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v32, 9, v1
		v_lshl_add_u32 v1, v24, 13, v1
		v_lshl_add_u32 v1, v46, 12, v1
		v_lshl_add_u32 v1, v48, 10, v1
		ds_read_b128 v[4:7], v1 offset:3072
		ds_read_b128 v[64:67], v1 offset:3328
		ds_read_b128 v[68:71], v1 offset:5120
		ds_read_b128 v[72:75], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[76:79] offset:3072
		ds_write_b128 v26, v[96:99] offset:7168
		ds_write_b128 v26, v[100:103] offset:11264
		ds_write_b128 v26, v[104:107] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v1 offset:3072
		ds_read_b128 v[96:99], v1 offset:3328
		ds_read_b128 v[100:103], v1 offset:5120
		ds_read_b128 v[104:107], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[112:115] offset:3072
		ds_write_b128 v26, v[116:119] offset:7168
		ds_write_b128 v26, v[124:127] offset:11264
		ds_write_b128 v26, v[128:131] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v1 offset:3072
		ds_read_b128 v[116:119], v1 offset:3328
		ds_read_b128 v[124:127], v1 offset:5120
		ds_read_b128 v[128:131], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[132:135] offset:3072
		ds_write_b128 v26, v[136:139] offset:7168
		ds_write_b128 v26, v[140:143] offset:11264
		ds_write_b128 v26, v[144:147] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[132:135], v1 offset:3072
		ds_read_b128 v[136:139], v1 offset:3328
		ds_read_b128 v[140:143], v1 offset:5120
		ds_read_b128 v[144:147], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s50
		s_mov_b32 s11, s51
		v_cmp_lt_i32_e64 vcc, v18, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v22, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_mov_b64_e32 v[148:149], v[4:5]
		v_mov_b64_e32 v[150:151], v[64:65]
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s14, s0, s1
		s_mul_i32 s15, s21, s17
		s_lshl_b32 s15, s15, 9
		s_add_i32 s14, s14, s15
		v_mul_lo_u32 v4, s17, v29
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v5, s17, v35
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v18, s14, v4, v5
		v_mul_lo_u32 v22, s17, v38
		v_lshlrev_b32_e32 v22, 2, v22
		v_mul_lo_u32 v38, s17, v41
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v18, v18, v22, v38
		v_lshlrev_b32_e32 v32, 4, v32
		v_lshlrev_b32_e32 v24, 7, v24
		v_add3_u32 v18, v18, v32, v24
		v_lshlrev_b32_e32 v42, 6, v46
		v_lshlrev_b32_e32 v43, 5, v48
		v_add3_u32 v18, v18, v42, v43
		v_mov_b32_e32 v44, 0x80000000
		v_cndmask_b32_e64 v18, v44, v18, s[6:7]
		buffer_store_dwordx4 v[148:151], v18, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v19, s12
		s_mov_b64 s[6:7], vcc
		s_and_b32 s18, s6, s4
		s_and_b32 s19, s7, s5
		v_mov_b64_e32 v[48:49], v[68:69]
		v_mov_b64_e32 v[50:51], v[72:73]
		v_lshlrev_b32_e32 v18, 3, v29
		v_lshlrev_b32_e32 v19, 2, v35
		v_add_u32_e32 v29, 16, v41
		v_xor_b32_e32 v29, v29, v108
		v_xor_b32_e32 v29, v19, v29
		v_xor_b32_e32 v29, v18, v29
		v_mul_lo_u32 v29, s17, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v35, s14, v29
		v_add3_u32 v35, v35, v32, v24
		v_add3_u32 v35, v35, v42, v43
		v_cndmask_b32_e64 v35, v44, v35, s[18:19]
		buffer_store_dwordx4 v[48:51], v35, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v20, s12
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s18, s4
		s_and_b32 s21, s19, s5
		v_mov_b64_e32 v[48:49], v[6:7]
		v_mov_b64_e32 v[50:51], v[66:67]
		v_add_u32_e32 v6, 32, v41
		v_xor_b32_e32 v6, v6, v108
		v_xor_b32_e32 v6, v19, v6
		v_xor_b32_e32 v6, v18, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v7, s14, v6
		v_add3_u32 v7, v7, v32, v24
		v_add3_u32 v7, v7, v42, v43
		v_cndmask_b32_e64 v7, v44, v7, s[20:21]
		buffer_store_dwordx4 v[48:51], v7, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v21, s12
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s20, s4
		s_and_b32 s23, s21, s5
		v_mov_b64_e32 v[48:49], v[70:71]
		v_mov_b64_e32 v[50:51], v[74:75]
		v_add_u32_e32 v7, 48, v41
		v_xor_b32_e32 v7, v7, v108
		v_xor_b32_e32 v7, v19, v7
		v_xor_b32_e32 v7, v18, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v20, s14, v7
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[22:23]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s22, s4
		s_and_b32 s25, s23, s5
		v_mov_b64_e32 v[48:49], v[76:77]
		v_mov_b64_e32 v[50:51], v[96:97]
		v_add_u32_e32 v2, 64, v41
		v_xor_b32_e32 v2, v2, v108
		v_xor_b32_e32 v2, v19, v2
		v_xor_b32_e32 v2, v18, v2
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v20, s14, v2
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[24:25]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[24:25], vcc
		s_and_b32 s26, s24, s4
		s_and_b32 s27, s25, s5
		v_mov_b64_e32 v[48:49], v[100:101]
		v_mov_b64_e32 v[50:51], v[104:105]
		v_add_u32_e32 v3, 0x50, v41
		v_xor_b32_e32 v3, v3, v108
		v_xor_b32_e32 v3, v19, v3
		v_xor_b32_e32 v3, v18, v3
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add_u32_e32 v20, s14, v3
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[26:27]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[26:27], vcc
		s_and_b32 s28, s26, s4
		s_and_b32 s29, s27, s5
		v_mov_b64_e32 v[48:49], v[78:79]
		v_mov_b64_e32 v[50:51], v[98:99]
		v_add_u32_e32 v8, 0x60, v41
		v_xor_b32_e32 v8, v8, v108
		v_xor_b32_e32 v8, v19, v8
		v_xor_b32_e32 v8, v18, v8
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v20, s14, v8
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[28:29]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s28, s4
		s_and_b32 s31, s29, s5
		v_mov_b64_e32 v[48:49], v[102:103]
		v_mov_b64_e32 v[50:51], v[106:107]
		v_add_u32_e32 v9, 0x70, v41
		v_xor_b32_e32 v9, v9, v108
		v_xor_b32_e32 v9, v19, v9
		v_xor_b32_e32 v9, v18, v9
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v20, s14, v9
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[30:31]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[30:31], vcc
		s_and_b32 s32, s30, s4
		s_and_b32 s33, s31, s5
		v_mov_b64_e32 v[48:49], v[112:113]
		v_mov_b64_e32 v[50:51], v[116:117]
		v_add_u32_e32 v10, 0x80, v41
		v_xor_b32_e32 v10, v10, v108
		v_xor_b32_e32 v10, v19, v10
		v_xor_b32_e32 v10, v18, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v20, s14, v10
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[32:33]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s32, s4
		s_and_b32 s35, s33, s5
		v_mov_b64_e32 v[48:49], v[124:125]
		v_mov_b64_e32 v[50:51], v[128:129]
		v_add_u32_e32 v11, 0x90, v41
		v_xor_b32_e32 v11, v11, v108
		v_xor_b32_e32 v11, v19, v11
		v_xor_b32_e32 v11, v18, v11
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v20, s14, v11
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[34:35]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v12, s12
		s_mov_b64 s[34:35], vcc
		s_and_b32 s36, s34, s4
		s_and_b32 s37, s35, s5
		v_mov_b64_e32 v[48:49], v[114:115]
		v_mov_b64_e32 v[50:51], v[118:119]
		v_add_u32_e32 v12, 0xa0, v41
		v_xor_b32_e32 v12, v12, v108
		v_xor_b32_e32 v12, v19, v12
		v_xor_b32_e32 v12, v18, v12
		v_mul_lo_u32 v12, s17, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add_u32_e32 v20, s14, v12
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[36:37]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v13, s12
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s36, s4
		s_and_b32 s39, s37, s5
		v_mov_b64_e32 v[48:49], v[126:127]
		v_mov_b64_e32 v[50:51], v[130:131]
		v_add_u32_e32 v13, 0xb0, v41
		v_xor_b32_e32 v13, v13, v108
		v_xor_b32_e32 v13, v19, v13
		v_xor_b32_e32 v13, v18, v13
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add_u32_e32 v20, s14, v13
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[38:39]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[38:39], vcc
		s_and_b32 s40, s38, s4
		s_and_b32 s41, s39, s5
		v_mov_b64_e32 v[48:49], v[132:133]
		v_mov_b64_e32 v[50:51], v[136:137]
		v_add_u32_e32 v14, 0xc0, v41
		v_xor_b32_e32 v14, v14, v108
		v_xor_b32_e32 v14, v19, v14
		v_xor_b32_e32 v14, v18, v14
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v20, s14, v14
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[40:41]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v15, s12
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s40, s4
		s_and_b32 s43, s41, s5
		v_mov_b64_e32 v[48:49], v[140:141]
		v_mov_b64_e32 v[50:51], v[144:145]
		v_add_u32_e32 v15, 0xd0, v41
		v_xor_b32_e32 v15, v15, v108
		v_xor_b32_e32 v15, v19, v15
		v_xor_b32_e32 v15, v18, v15
		v_mul_lo_u32 v15, s17, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add_u32_e32 v20, s14, v15
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[42:43]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v16, s12
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s42, s4
		s_and_b32 s45, s43, s5
		v_mov_b64_e32 v[48:49], v[134:135]
		v_mov_b64_e32 v[50:51], v[138:139]
		v_add_u32_e32 v16, 0xe0, v41
		v_xor_b32_e32 v16, v16, v108
		v_xor_b32_e32 v16, v19, v16
		v_xor_b32_e32 v16, v18, v16
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v20, s14, v16
		v_add3_u32 v20, v20, v32, v24
		v_add3_u32 v20, v20, v42, v43
		v_cndmask_b32_e64 v20, v44, v20, s[44:45]
		buffer_store_dwordx4 v[48:51], v20, s[8:11], 0 offen
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s44, s4
		s_and_b32 s47, s45, s5
		v_mov_b64_e32 v[48:49], v[142:143]
		v_mov_b64_e32 v[50:51], v[146:147]
		v_add_u32_e32 v17, 0xf0, v41
		v_xor_b32_e32 v17, v17, v108
		v_xor_b32_e32 v17, v19, v17
		v_xor_b32_e32 v17, v18, v17
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v18, s14, v17
		v_add3_u32 v18, v18, v32, v24
		v_add3_u32 v18, v18, v42, v43
		v_cndmask_b32_e64 v18, v44, v18, s[46:47]
		buffer_store_dwordx4 v[48:51], v18, s[8:11], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v18, 0xff, v31
		v_lshlrev_b32_e32 v18, 8, v18
		v_or_b32_e32 v0, v0, v18
		v_and_b32_e32 v18, 0xff, v33
		v_lshlrev_b32_e32 v18, 16, v18
		v_and_b32_e32 v19, 0xff, v34
		v_lshlrev_b32_e32 v19, 24, v19
		v_or3_b32 v0, v0, v18, v19
		v_and_b32_e32 v18, 0xff, v36
		v_and_b32_e32 v19, 0xff, v37
		v_lshlrev_b32_e32 v19, 8, v19
		v_or_b32_e32 v18, v18, v19
		v_and_b32_e32 v19, 0xff, v39
		v_lshlrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v20, 0xff, v40
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v18, v18, v19, v20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[0:3], a[128:131], v0, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[0:3], a[132:135], v0, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[8:11], a[148:151], v0, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[8:11], a[144:147], v0, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], a[4:7], a[128:131], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], a[4:7], a[132:135], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], a[12:15], a[148:151], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], a[12:15], a[144:147], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[84:87], a[0:3], a[136:139], v18, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], a[0:3], a[140:143], v18, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], a[8:11], a[156:159], v18, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], a[8:11], a[152:155], v18, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], a[4:7], a[136:139], v18, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[120:123], a[4:7], a[140:143], v18, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[120:123], a[12:15], a[156:159], v18, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[88:91], a[12:15], a[152:155], v18, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], a[16:19], a[168:171], v18, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], a[16:19], a[172:175], v18, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[92:95], a[24:27], a[188:191], v18, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[84:87], a[24:27], a[184:187], v18, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[88:91], a[20:23], a[168:171], v18, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[120:123], a[20:23], a[172:175], v18, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[120:123], a[28:31], a[188:191], v18, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[88:91], a[28:31], a[184:187], v18, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[16:19], a[160:163], v0, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[16:19], a[164:167], v0, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[60:63], a[24:27], a[180:183], v0, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], a[24:27], a[176:179], v0, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], a[20:23], a[160:163], v0, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], a[20:23], a[164:167], v0, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[80:83], a[28:31], a[180:183], v0, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[56:59], a[28:31], a[176:179], v0, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[52:55], a[32:35], a[192:195], v0, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], a[32:35], a[196:199], v0, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[60:63], a[40:43], a[212:215], v0, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[52:55], a[40:43], a[208:211], v0, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], a[36:39], a[192:195], v0, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[80:83], a[36:39], a[196:199], v0, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[80:83], a[44:47], a[212:215], v0, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], a[44:47], a[208:211], v0, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[84:87], a[32:35], a[200:203], v18, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[92:95], a[32:35], a[204:207], v18, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[92:95], a[40:43], a[220:223], v18, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[84:87], a[40:43], a[216:219], v18, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[88:91], a[36:39], a[200:203], v18, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[120:123], a[36:39], a[204:207], v18, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[120:123], a[44:47], a[220:223], v18, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[88:91], a[44:47], a[216:219], v18, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[84:87], a[48:51], a[232:235], v18, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[92:95], a[48:51], a[236:239], v18, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[92:95], a[56:59], v[252:255], v18, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[84:87], a[56:59], a[248:251], v18, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[88:91], a[52:55], a[232:235], v18, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[120:123], a[52:55], a[236:239], v18, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[120:123], a[60:63], v[252:255], v18, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[88:91], a[60:63], a[248:251], v18, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[52:55], a[48:51], a[224:227], v0, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[60:63], a[48:51], a[228:231], v0, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[60:63], a[56:59], a[244:247], v0, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[52:55], a[56:59], a[240:243], v0, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[56:59], a[52:55], a[224:227], v0, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[80:83], a[52:55], a[228:231], v0, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[80:83], a[60:63], a[244:247], v0, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[56:59], a[60:63], a[240:243], v0, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s4, s16, 0x80
		v_add_u32_e32 v0, s4, v23
		v_accvgpr_read_b32 v18, a128
		v_accvgpr_read_b32 v19, a129
		v_cvt_pk_bf16_f32 v48, v18, v19
		v_accvgpr_read_b32 v18, a130
		v_accvgpr_read_b32 v19, a131
		v_cvt_pk_bf16_f32 v49, v18, v19
		v_accvgpr_read_b32 v18, a132
		v_accvgpr_read_b32 v19, a133
		v_cvt_pk_bf16_f32 v52, v18, v19
		v_accvgpr_read_b32 v18, a134
		v_accvgpr_read_b32 v19, a135
		v_cvt_pk_bf16_f32 v53, v18, v19
		v_accvgpr_read_b32 v18, a136
		v_accvgpr_read_b32 v19, a137
		v_cvt_pk_bf16_f32 v56, v18, v19
		v_accvgpr_read_b32 v18, a138
		v_accvgpr_read_b32 v19, a139
		v_cvt_pk_bf16_f32 v57, v18, v19
		v_accvgpr_read_b32 v18, a140
		v_accvgpr_read_b32 v19, a141
		v_cvt_pk_bf16_f32 v60, v18, v19
		v_accvgpr_read_b32 v18, a142
		v_accvgpr_read_b32 v19, a143
		v_cvt_pk_bf16_f32 v61, v18, v19
		v_accvgpr_read_b32 v18, a144
		v_accvgpr_read_b32 v19, a145
		v_cvt_pk_bf16_f32 v50, v18, v19
		v_accvgpr_read_b32 v18, a146
		v_accvgpr_read_b32 v19, a147
		v_cvt_pk_bf16_f32 v51, v18, v19
		v_accvgpr_read_b32 v18, a148
		v_accvgpr_read_b32 v19, a149
		v_cvt_pk_bf16_f32 v54, v18, v19
		v_accvgpr_read_b32 v18, a150
		v_accvgpr_read_b32 v19, a151
		v_cvt_pk_bf16_f32 v55, v18, v19
		v_accvgpr_read_b32 v18, a152
		v_accvgpr_read_b32 v19, a153
		v_cvt_pk_bf16_f32 v58, v18, v19
		v_accvgpr_read_b32 v18, a154
		v_accvgpr_read_b32 v19, a155
		v_cvt_pk_bf16_f32 v59, v18, v19
		v_accvgpr_read_b32 v18, a156
		v_accvgpr_read_b32 v19, a157
		v_cvt_pk_bf16_f32 v62, v18, v19
		v_accvgpr_read_b32 v18, a158
		v_accvgpr_read_b32 v19, a159
		v_cvt_pk_bf16_f32 v63, v18, v19
		v_accvgpr_read_b32 v18, a160
		v_accvgpr_read_b32 v19, a161
		v_cvt_pk_bf16_f32 v64, v18, v19
		v_accvgpr_read_b32 v18, a162
		v_accvgpr_read_b32 v19, a163
		v_cvt_pk_bf16_f32 v65, v18, v19
		v_accvgpr_read_b32 v18, a164
		v_accvgpr_read_b32 v19, a165
		v_cvt_pk_bf16_f32 v68, v18, v19
		v_accvgpr_read_b32 v18, a166
		v_accvgpr_read_b32 v19, a167
		v_cvt_pk_bf16_f32 v69, v18, v19
		v_accvgpr_read_b32 v18, a168
		v_accvgpr_read_b32 v19, a169
		v_cvt_pk_bf16_f32 v72, v18, v19
		v_accvgpr_read_b32 v18, a170
		v_accvgpr_read_b32 v19, a171
		v_cvt_pk_bf16_f32 v73, v18, v19
		v_accvgpr_read_b32 v18, a172
		v_accvgpr_read_b32 v19, a173
		v_cvt_pk_bf16_f32 v76, v18, v19
		v_accvgpr_read_b32 v18, a174
		v_accvgpr_read_b32 v19, a175
		v_cvt_pk_bf16_f32 v77, v18, v19
		v_accvgpr_read_b32 v18, a176
		v_accvgpr_read_b32 v19, a177
		v_cvt_pk_bf16_f32 v66, v18, v19
		v_accvgpr_read_b32 v18, a178
		v_accvgpr_read_b32 v19, a179
		v_cvt_pk_bf16_f32 v67, v18, v19
		v_accvgpr_read_b32 v18, a180
		v_accvgpr_read_b32 v19, a181
		v_cvt_pk_bf16_f32 v70, v18, v19
		v_accvgpr_read_b32 v18, a182
		v_accvgpr_read_b32 v19, a183
		v_cvt_pk_bf16_f32 v71, v18, v19
		v_accvgpr_read_b32 v18, a184
		v_accvgpr_read_b32 v19, a185
		v_cvt_pk_bf16_f32 v74, v18, v19
		v_accvgpr_read_b32 v18, a186
		v_accvgpr_read_b32 v19, a187
		v_cvt_pk_bf16_f32 v75, v18, v19
		v_accvgpr_read_b32 v18, a188
		v_accvgpr_read_b32 v19, a189
		v_cvt_pk_bf16_f32 v78, v18, v19
		v_accvgpr_read_b32 v18, a190
		v_accvgpr_read_b32 v19, a191
		v_cvt_pk_bf16_f32 v79, v18, v19
		v_accvgpr_read_b32 v18, a192
		v_accvgpr_read_b32 v19, a193
		v_cvt_pk_bf16_f32 v80, v18, v19
		v_accvgpr_read_b32 v18, a194
		v_accvgpr_read_b32 v19, a195
		v_cvt_pk_bf16_f32 v81, v18, v19
		v_accvgpr_read_b32 v18, a196
		v_accvgpr_read_b32 v19, a197
		v_cvt_pk_bf16_f32 v84, v18, v19
		v_accvgpr_read_b32 v18, a198
		v_accvgpr_read_b32 v19, a199
		v_cvt_pk_bf16_f32 v85, v18, v19
		v_accvgpr_read_b32 v18, a200
		v_accvgpr_read_b32 v19, a201
		v_cvt_pk_bf16_f32 v88, v18, v19
		v_accvgpr_read_b32 v18, a202
		v_accvgpr_read_b32 v19, a203
		v_cvt_pk_bf16_f32 v89, v18, v19
		v_accvgpr_read_b32 v18, a204
		v_accvgpr_read_b32 v19, a205
		v_cvt_pk_bf16_f32 v92, v18, v19
		v_accvgpr_read_b32 v18, a206
		v_accvgpr_read_b32 v19, a207
		v_cvt_pk_bf16_f32 v93, v18, v19
		v_accvgpr_read_b32 v18, a208
		v_accvgpr_read_b32 v19, a209
		v_cvt_pk_bf16_f32 v82, v18, v19
		v_accvgpr_read_b32 v18, a210
		v_accvgpr_read_b32 v19, a211
		v_cvt_pk_bf16_f32 v83, v18, v19
		v_accvgpr_read_b32 v18, a212
		v_accvgpr_read_b32 v19, a213
		v_cvt_pk_bf16_f32 v86, v18, v19
		v_accvgpr_read_b32 v18, a214
		v_accvgpr_read_b32 v19, a215
		v_cvt_pk_bf16_f32 v87, v18, v19
		v_accvgpr_read_b32 v18, a216
		v_accvgpr_read_b32 v19, a217
		v_cvt_pk_bf16_f32 v90, v18, v19
		v_accvgpr_read_b32 v18, a218
		v_accvgpr_read_b32 v19, a219
		v_cvt_pk_bf16_f32 v91, v18, v19
		v_accvgpr_read_b32 v18, a220
		v_accvgpr_read_b32 v19, a221
		v_cvt_pk_bf16_f32 v94, v18, v19
		v_accvgpr_read_b32 v18, a222
		v_accvgpr_read_b32 v19, a223
		v_cvt_pk_bf16_f32 v95, v18, v19
		v_accvgpr_read_b32 v18, a224
		v_accvgpr_read_b32 v19, a225
		v_cvt_pk_bf16_f32 v96, v18, v19
		v_accvgpr_read_b32 v18, a226
		v_accvgpr_read_b32 v19, a227
		v_cvt_pk_bf16_f32 v97, v18, v19
		v_accvgpr_read_b32 v18, a228
		v_accvgpr_read_b32 v19, a229
		v_cvt_pk_bf16_f32 v100, v18, v19
		v_accvgpr_read_b32 v18, a230
		v_accvgpr_read_b32 v19, a231
		v_cvt_pk_bf16_f32 v101, v18, v19
		v_accvgpr_read_b32 v18, a232
		v_accvgpr_read_b32 v19, a233
		v_cvt_pk_bf16_f32 v104, v18, v19
		v_accvgpr_read_b32 v18, a234
		v_accvgpr_read_b32 v19, a235
		v_cvt_pk_bf16_f32 v105, v18, v19
		v_accvgpr_read_b32 v18, a236
		v_accvgpr_read_b32 v19, a237
		v_cvt_pk_bf16_f32 v108, v18, v19
		v_accvgpr_read_b32 v18, a238
		v_accvgpr_read_b32 v19, a239
		v_cvt_pk_bf16_f32 v109, v18, v19
		v_accvgpr_read_b32 v18, a240
		v_accvgpr_read_b32 v19, a241
		v_cvt_pk_bf16_f32 v98, v18, v19
		v_accvgpr_read_b32 v18, a242
		v_accvgpr_read_b32 v19, a243
		v_cvt_pk_bf16_f32 v99, v18, v19
		v_accvgpr_read_b32 v18, a244
		v_accvgpr_read_b32 v19, a245
		v_cvt_pk_bf16_f32 v102, v18, v19
		v_accvgpr_read_b32 v18, a246
		v_accvgpr_read_b32 v19, a247
		v_cvt_pk_bf16_f32 v103, v18, v19
		v_accvgpr_read_b32 v18, a248
		v_accvgpr_read_b32 v19, a249
		v_cvt_pk_bf16_f32 v106, v18, v19
		v_accvgpr_read_b32 v18, a250
		v_accvgpr_read_b32 v19, a251
		v_cvt_pk_bf16_f32 v107, v18, v19
		v_cvt_pk_bf16_f32 v110, v252, v253
		v_cvt_pk_bf16_f32 v111, v254, v255
		ds_write_b128 v26, v[48:51] offset:3072
		ds_write_b128 v26, v[52:55] offset:7168
		ds_write_b128 v26, v[56:59] offset:11264
		ds_write_b128 v26, v[60:63] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v1 offset:3072
		ds_read_b128 v[52:55], v1 offset:3328
		ds_read_b128 v[56:59], v1 offset:5120
		ds_read_b128 v[60:63], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[64:67] offset:3072
		ds_write_b128 v26, v[68:71] offset:7168
		ds_write_b128 v26, v[72:75] offset:11264
		ds_write_b128 v26, v[76:79] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v1 offset:3072
		ds_read_b128 v[68:71], v1 offset:3328
		ds_read_b128 v[72:75], v1 offset:5120
		ds_read_b128 v[76:79], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[80:83] offset:3072
		ds_write_b128 v26, v[84:87] offset:7168
		ds_write_b128 v26, v[88:91] offset:11264
		ds_write_b128 v26, v[92:95] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v1 offset:3072
		ds_read_b128 v[84:87], v1 offset:3328
		ds_read_b128 v[88:91], v1 offset:5120
		ds_read_b128 v[92:95], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v26, v[96:99] offset:3072
		ds_write_b128 v26, v[100:103] offset:7168
		ds_write_b128 v26, v[104:107] offset:11264
		ds_write_b128 v26, v[108:111] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[96:99], v1 offset:3072
		ds_read_b128 v[100:103], v1 offset:3328
		ds_read_b128 v[104:107], v1 offset:5120
		ds_read_b128 v[108:111], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s12, s2, s4
		s_and_b32 s13, s3, s5
		v_mov_b64_e32 v[112:113], v[48:49]
		v_mov_b64_e32 v[114:115], v[52:53]
		s_add_i32 s0, s0, 0x100
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s15
		v_add3_u32 v0, s0, v4, v5
		v_add3_u32 v0, v0, v22, v38
		v_add3_u32 v0, v0, v32, v24
		v_add3_u32 v0, v0, v42, v43
		v_cndmask_b32_e64 v0, v44, v0, s[12:13]
		buffer_store_dwordx4 v[112:115], v0, s[8:11], 0 offen
		s_and_b32 s2, s6, s4
		s_and_b32 s3, s7, s5
		v_mov_b64_e32 v[20:21], v[56:57]
		v_mov_b64_e32 v[22:23], v[60:61]
		v_add3_u32 v0, v32, v24, v42
		v_add_u32_e32 v0, v0, v43
		v_add3_u32 v1, v29, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		s_and_b32 s2, s18, s4
		s_and_b32 s3, s19, s5
		v_mov_b64_e32 v[20:21], v[50:51]
		v_mov_b64_e32 v[22:23], v[54:55]
		v_add3_u32 v1, v6, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		s_and_b32 s2, s20, s4
		s_and_b32 s3, s21, s5
		v_mov_b64_e32 v[20:21], v[58:59]
		v_mov_b64_e32 v[22:23], v[62:63]
		v_add3_u32 v0, v7, v0, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		s_and_b32 s2, s22, s4
		s_and_b32 s3, s23, s5
		v_mov_b64_e32 v[4:5], v[64:65]
		v_mov_b64_e32 v[6:7], v[68:69]
		v_add3_u32 v0, v32, v24, v42
		v_add_u32_e32 v0, v0, v43
		v_add3_u32 v1, v2, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_and_b32 s2, s24, s4
		s_and_b32 s3, s25, s5
		v_mov_b64_e32 v[4:5], v[72:73]
		v_mov_b64_e32 v[6:7], v[76:77]
		v_add3_u32 v1, v3, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_and_b32 s2, s26, s4
		s_and_b32 s3, s27, s5
		v_mov_b64_e32 v[4:5], v[66:67]
		v_mov_b64_e32 v[6:7], v[70:71]
		v_add3_u32 v0, v8, v0, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_and_b32 s2, s28, s4
		s_and_b32 s3, s29, s5
		v_mov_b64_e32 v[0:1], v[74:75]
		v_mov_b64_e32 v[2:3], v[78:79]
		v_add3_u32 v4, v32, v24, v42
		v_add_u32_e32 v4, v4, v43
		v_add3_u32 v5, v9, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s30, s4
		s_and_b32 s3, s31, s5
		v_mov_b64_e32 v[0:1], v[80:81]
		v_mov_b64_e32 v[2:3], v[84:85]
		v_add3_u32 v5, v10, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s32, s4
		s_and_b32 s3, s33, s5
		v_mov_b64_e32 v[0:1], v[88:89]
		v_mov_b64_e32 v[2:3], v[92:93]
		v_add3_u32 v4, v11, v4, s0
		v_cndmask_b32_e64 v4, v44, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[8:11], 0 offen
		s_and_b32 s2, s34, s4
		s_and_b32 s3, s35, s5
		v_mov_b64_e32 v[0:1], v[82:83]
		v_mov_b64_e32 v[2:3], v[86:87]
		v_add3_u32 v4, v32, v24, v42
		v_add_u32_e32 v4, v4, v43
		v_add3_u32 v5, v12, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s36, s4
		s_and_b32 s3, s37, s5
		v_mov_b64_e32 v[0:1], v[90:91]
		v_mov_b64_e32 v[2:3], v[94:95]
		v_add3_u32 v5, v13, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s38, s4
		s_and_b32 s3, s39, s5
		v_mov_b64_e32 v[0:1], v[96:97]
		v_mov_b64_e32 v[2:3], v[100:101]
		v_add3_u32 v4, v14, v4, s0
		v_cndmask_b32_e64 v4, v44, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[8:11], 0 offen
		s_and_b32 s2, s40, s4
		s_and_b32 s3, s41, s5
		v_mov_b64_e32 v[0:1], v[104:105]
		v_mov_b64_e32 v[2:3], v[108:109]
		v_add3_u32 v4, v32, v24, v42
		v_add_u32_e32 v4, v4, v43
		v_add3_u32 v5, v15, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s42, s4
		s_and_b32 s3, s43, s5
		v_mov_b64_e32 v[0:1], v[98:99]
		v_mov_b64_e32 v[2:3], v[102:103]
		v_add3_u32 v5, v16, v4, s0
		v_cndmask_b32_e64 v5, v44, v5, s[2:3]
		buffer_store_dwordx4 v[0:3], v5, s[8:11], 0 offen
		s_and_b32 s2, s44, s4
		s_and_b32 s3, s45, s5
		v_mov_b64_e32 v[0:1], v[106:107]
		v_mov_b64_e32 v[2:3], v[110:111]
		v_add3_u32 v4, v17, v4, s0
		v_cndmask_b32_e64 v4, v44, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[8:11], 0 offen
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
		.amdhsa_next_free_sgpr 101
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
	.set .L_a4w4_kernel.numbered_sgpr, 101
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
    .sgpr_count:     101
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     508
    .agpr_count:     252
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 122
    wave.regalloc.agpr.dwords: 484
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
