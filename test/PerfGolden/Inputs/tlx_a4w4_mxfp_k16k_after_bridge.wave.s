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
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
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
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
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
		s_mov_b32 s62, 0x7fffffff
		s_mov_b32 s63, 0x31016000
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
		s_mov_b32 s70, 0x7fffffff
		s_mov_b32 s71, 0x31016000
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
		v_add3_u32 v83, s8, v82, v32
		v_add3_u32 v83, v83, v66, v67
		v_mul_lo_u32 v84, s18, v75
		v_add3_u32 v85, s8, v84, v32
		v_add3_u32 v85, v85, v66, v67
		v_mul_lo_u32 v86, s18, v78
		v_add3_u32 v87, s8, v86, v32
		v_add3_u32 v87, v87, v66, v67
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
		buffer_load_ubyte v80, v83, s[60:63], 0 offen
		buffer_load_ubyte v83, v85, s[60:63], 0 offen
		buffer_load_ubyte v85, v87, s[60:63], 0 offen
		buffer_load_ubyte v87, v90, s[60:63], 0 offen
		buffer_load_ubyte v90, v93, s[60:63], 0 offen
		buffer_load_ubyte v93, v96, s[60:63], 0 offen
		buffer_load_ubyte v96, v72, s[60:63], 0 offen
		s_add_i32 s9, s10, 8
		v_add3_u32 v72, s9, v34, v53
		v_add3_u32 v72, v72, v56, v58
		v_add3_u32 v72, v72, v60, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v98, s9, v73, v32
		v_add3_u32 v98, v98, v66, v67
		v_add3_u32 v99, s9, v76, v32
		v_add3_u32 v99, v99, v66, v67
		v_add3_u32 v100, s9, v79, v32
		v_add3_u32 v100, v100, v66, v67
		buffer_load_ubyte v101, v72, s[68:71], 0 offen
		buffer_load_ubyte v72, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v100, s[68:71], 0 offen
		s_add_i32 s11, s11, 0x80
		s_add_i32 s11, s11, s4
		v_add3_u32 v100, s11, v28, v27
		s_add_i32 s18, s2, 0x1c000
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s67, s67, 0x80
		s_add_i32 s67, s67, s4
		v_add3_u32 v100, s67, v28, v27
		s_add_i32 s92, s2, 0x1d000
		s_mov_b32 m0, s92
		s_nop 0
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s74, s74, 0x80
		s_add_i32 s74, s74, s4
		v_add3_u32 v100, s74, v28, v27
		s_add_i32 s93, s2, 0x1e000
		s_mov_b32 m0, s93
		s_nop 0
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s4
		v_add3_u32 v100, s15, v28, v27
		s_add_i32 s94, s2, 0x1f000
		s_mov_b32 m0, s94
		s_nop 0
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s79, s79, 8
		s_add_i32 s79, s79, s10
		v_add3_u32 v100, s79, v34, v53
		v_add3_u32 v100, v100, v56, v58
		v_add3_u32 v100, v100, v60, v32
		v_add3_u32 v100, v100, v66, v67
		v_add3_u32 v102, s79, v73, v32
		v_add3_u32 v102, v102, v66, v67
		v_add3_u32 v103, s79, v76, v32
		v_add3_u32 v103, v103, v66, v67
		v_add3_u32 v104, s79, v79, v32
		v_add3_u32 v104, v104, v66, v67
		buffer_load_ubyte v105, v100, s[68:71], 0 offen
		buffer_load_ubyte v100, v102, s[68:71], 0 offen
		buffer_load_ubyte v102, v103, s[68:71], 0 offen
		buffer_load_ubyte v103, v104, s[68:71], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v104, 11, v29
		v_and_b32_e32 v106, 63, v0
		v_lshrrev_b32_e32 v107, 4, v106
		v_lshlrev_b32_e32 v107, 4, v107
		v_and_b32_e32 v106, 15, v106
		v_lshlrev_b32_e32 v106, 7, v106
		v_add3_u32 v104, v104, v107, v106
		ds_read_b128 v[108:111], v104
		ds_read_b128 v[112:115], v104 offset:64
		ds_read_b128 v[116:119], v104 offset:4096
		ds_read_b128 v[120:123], v104 offset:4160
		ds_read_b128 v[124:127], v104 offset:8192
		ds_read_b128 v[128:131], v104 offset:8256
		ds_read_b128 v[132:135], v104 offset:12288
		ds_read_b128 v[136:139], v104 offset:12352
		ds_read_b128 v[140:143], v104 offset:16384
		ds_read_b128 v[144:147], v104 offset:16448
		ds_read_b128 v[148:151], v104 offset:20480
		ds_read_b128 v[152:155], v104 offset:20544
		ds_read_b128 v[156:159], v104 offset:24576
		ds_read_b128 v[160:163], v104 offset:24640
		ds_read_b128 v[164:167], v104 offset:28672
		ds_read_b128 v[168:171], v104 offset:28736
		v_add_u32_e32 v107, 0x10000, v107
		v_lshlrev_b32_e32 v172, 11, v35
		v_add3_u32 v106, v107, v172, v106
		ds_read_b128 v[172:175], v106
		ds_read_b128 v[176:179], v106 offset:64
		ds_read_b128 v[180:183], v106 offset:4096
		ds_read_b128 v[184:187], v106 offset:4160
		ds_read_b128 v[188:191], v106 offset:8192
		ds_read_b128 v[192:195], v106 offset:8256
		ds_read_b128 v[196:199], v106 offset:12288
		ds_read_b128 v[200:203], v106 offset:12352
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
		v_lshlrev_b32_e32 v204, 1, v38
		v_add_u32_e32 v205, v51, v204
		v_lshlrev_b32_e32 v206, 6, v24
		v_add3_u32 v205, v205, v41, v206
		v_lshlrev_b32_e32 v207, 5, v46
		v_lshlrev_b32_e32 v208, 4, v48
		v_add3_u32 v205, v205, v207, v208
		ds_read_u8 v209, v205
		v_add3_u32 v51, v51, v206, v207
		v_add_u32_e32 v210, 4, v41
		v_xor_b32_e32 v210, v210, v204
		v_add3_u32 v51, v51, v208, v210
		ds_read_u8 v211, v51
		v_add_u32_e32 v212, 0x20000, v204
		v_add_u32_e32 v212, v212, v41
		v_lshlrev_b32_e32 v213, 3, v24
		v_add_u32_e32 v214, 32, v32
		v_xor_b32_e32 v214, v214, v67
		v_xor_b32_e32 v214, v66, v214
		v_xor_b32_e32 v214, v213, v214
		v_xor_b32_e32 v215, v68, v214
		v_lshl_add_u32 v216, v215, 3, v212
		ds_read_u8 v217, v216
		v_add_u32_e32 v218, 0x20000, v210
		v_lshl_add_u32 v215, v215, 3, v218
		ds_read_u8 v219, v215
		v_add_u32_e32 v220, 64, v32
		v_xor_b32_e32 v220, v220, v67
		v_xor_b32_e32 v220, v66, v220
		v_xor_b32_e32 v220, v213, v220
		v_xor_b32_e32 v221, v68, v220
		v_lshl_add_u32 v222, v221, 3, v212
		ds_read_u8 v223, v222
		v_lshl_add_u32 v221, v221, 3, v218
		ds_read_u8 v224, v221
		v_add_u32_e32 v225, 0x60, v32
		v_xor_b32_e32 v225, v225, v67
		v_xor_b32_e32 v225, v66, v225
		v_xor_b32_e32 v225, v213, v225
		v_xor_b32_e32 v226, v68, v225
		v_lshl_add_u32 v227, v226, 3, v212
		ds_read_u8 v228, v227
		v_lshl_add_u32 v226, v226, 3, v218
		ds_read_u8 v229, v226
		v_add_u32_e32 v230, 0x80, v32
		v_xor_b32_e32 v230, v230, v67
		v_xor_b32_e32 v230, v66, v230
		v_xor_b32_e32 v230, v213, v230
		v_xor_b32_e32 v230, v68, v230
		v_lshl_add_u32 v231, v230, 3, v212
		ds_read_u8 v232, v231
		v_lshl_add_u32 v230, v230, 3, v218
		ds_read_u8 v233, v230
		v_add_u32_e32 v234, 0xa0, v32
		v_xor_b32_e32 v234, v234, v67
		v_xor_b32_e32 v234, v66, v234
		v_xor_b32_e32 v234, v213, v234
		v_xor_b32_e32 v234, v68, v234
		v_lshl_add_u32 v235, v234, 3, v212
		ds_read_u8 v236, v235
		v_lshl_add_u32 v234, v234, 3, v218
		ds_read_u8 v237, v234
		v_add_u32_e32 v238, 0xc0, v32
		v_xor_b32_e32 v238, v238, v67
		v_xor_b32_e32 v238, v66, v238
		v_xor_b32_e32 v238, v213, v238
		v_xor_b32_e32 v238, v68, v238
		v_lshl_add_u32 v239, v238, 3, v212
		ds_read_u8 v240, v239
		v_lshl_add_u32 v238, v238, 3, v218
		ds_read_u8 v241, v238
		v_add_u32_e32 v242, 0xe0, v32
		v_xor_b32_e32 v242, v242, v67
		v_xor_b32_e32 v242, v66, v242
		v_xor_b32_e32 v213, v213, v242
		v_xor_b32_e32 v68, v68, v213
		v_lshl_add_u32 v213, v68, 3, v212
		ds_read_u8 v242, v213
		v_lshl_add_u32 v68, v68, 3, v218
		ds_read_u8 v243, v68
		v_add_u32_e32 v65, 0x20000, v65
		v_lshl_add_u32 v65, v35, 7, v65
		v_add_u32_e32 v244, v65, v204
		v_add3_u32 v244, v244, v41, v206
		v_add3_u32 v244, v244, v207, v208
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v245, v244 offset:2048
		v_add3_u32 v65, v65, v206, v207
		v_add3_u32 v65, v65, v208, v210
		ds_read_u8 v206, v65 offset:2048
		v_lshlrev_b32_e32 v207, 4, v35
		v_xor_b32_e32 v208, v207, v214
		v_lshl_add_u32 v210, v208, 3, v212
		ds_read_u8 v214, v210 offset:2048
		v_lshl_add_u32 v208, v208, 3, v218
		ds_read_u8 v246, v208 offset:2048
		v_xor_b32_e32 v220, v207, v220
		v_lshl_add_u32 v247, v220, 3, v212
		ds_read_u8 v248, v247 offset:2048
		v_lshl_add_u32 v220, v220, 3, v218
		ds_read_u8 v249, v220 offset:2048
		v_xor_b32_e32 v207, v207, v225
		v_lshl_add_u32 v212, v207, 3, v212
		ds_read_u8 v225, v212 offset:2048
		v_lshl_add_u32 v207, v207, 3, v218
		ds_read_u8 v218, v207 offset:2048
		s_mov_b32 s95, 0x100
		s_mov_b32 s96, 16
		s_mov_b32 s97, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v250, 0x20000, v32
		v_add3_u32 v250, v250, v66, v67
		v_lshl_add_u32 v71, v71, 3, v250
		v_lshl_add_u32 v75, v75, 3, v250
		v_lshl_add_u32 v78, v78, 3, v250
		v_lshl_add_u32 v88, v88, 3, v250
		v_lshl_add_u32 v91, v91, 3, v250
		v_lshl_add_u32 v94, v94, 3, v250
		v_lshl_add_u32 v69, v69, 3, v250
		s_mov_b32 s98, s95
		s_mov_b32 s99, s96
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
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a4, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a5, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a6, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a7, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a8, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a9, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a10, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a11, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a12, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a13, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a14, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a15, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a16, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a17, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a18, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a19, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a20, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a21, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a22, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a23, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a24, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a25, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a26, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a27, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a28, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a29, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a30, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a31, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a32, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a33, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a34, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a35, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a36, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a37, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a38, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a39, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a40, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a41, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a42, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a43, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a44, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a45, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a46, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a47, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a48, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a49, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a50, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a51, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a52, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a53, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a54, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a55, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a56, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a57, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a58, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a59, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a60, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a61, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a62, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a63, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a64, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a65, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a66, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a67, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a68, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a69, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a70, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a71, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a72, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a73, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a74, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a75, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a76, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a77, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a78, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a79, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a80, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a81, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a82, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a83, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a84, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a85, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a86, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a87, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a88, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a89, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a90, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a91, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a92, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a93, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a94, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a95, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a96, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a97, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a98, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a99, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a100, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a101, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a102, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a103, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a104, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a105, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a106, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a107, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a108, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a109, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a110, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a111, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a112, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a113, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a114, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a115, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a116, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a117, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a118, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a119, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a120, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a121, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a122, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a123, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a124, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a125, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a126, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a127, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a128, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a129, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a130, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a131, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a132, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a133, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a134, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a135, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a136, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a137, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a138, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a139, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a140, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a141, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a142, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a143, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a144, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a145, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a146, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a147, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a148, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a149, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a150, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a151, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a152, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a153, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a154, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a155, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a156, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a157, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a158, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a159, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a160, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a161, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a162, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a163, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a164, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a165, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a166, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a167, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a168, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a169, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a170, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a171, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a172, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a173, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a174, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a175, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a176, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a177, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a178, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a179, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a180, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a181, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a182, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a183, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a184, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a185, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a186, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a187, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a188, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a189, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a190, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a191, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a192, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a193, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a194, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a195, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a196, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a197, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a198, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a199, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a200, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a201, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a202, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a203, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a204, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a205, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a206, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a207, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a208, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a209, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a210, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a211, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a212, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a213, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a214, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a215, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a216, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a217, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a218, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a219, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a220, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a221, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a222, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a223, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a224, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a225, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a226, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a227, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a228, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a229, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a230, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a231, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a232, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a233, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a234, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a235, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a236, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a237, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a238, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a239, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a240, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a241, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a242, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a243, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a244, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a245, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a246, v250
		v_mov_b32_e32 v250, 0
		v_accvgpr_write_b32 a247, v250
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
.L_a4w4_kernel.loop_head_0:
		v_and_b32_e32 v209, 0xff, v209
		v_and_b32_e32 v211, 0xff, v211
		v_lshlrev_b32_e32 v211, 8, v211
		v_or_b32_e32 v209, v209, v211
		v_and_b32_e32 v211, 0xff, v217
		v_lshlrev_b32_e32 v211, 16, v211
		v_and_b32_e32 v217, 0xff, v219
		v_lshlrev_b32_e32 v217, 24, v217
		v_or3_b32 v209, v209, v211, v217
		v_and_b32_e32 v211, 0xff, v223
		v_and_b32_e32 v217, 0xff, v224
		v_lshlrev_b32_e32 v217, 8, v217
		v_or_b32_e32 v211, v211, v217
		v_and_b32_e32 v217, 0xff, v228
		v_lshlrev_b32_e32 v217, 16, v217
		v_and_b32_e32 v219, 0xff, v229
		v_lshlrev_b32_e32 v219, 24, v219
		v_or3_b32 v211, v211, v217, v219
		v_and_b32_e32 v217, 0xff, v232
		v_and_b32_e32 v219, 0xff, v233
		v_lshlrev_b32_e32 v219, 8, v219
		v_or_b32_e32 v217, v217, v219
		v_and_b32_e32 v219, 0xff, v236
		v_lshlrev_b32_e32 v219, 16, v219
		v_and_b32_e32 v223, 0xff, v237
		v_lshlrev_b32_e32 v223, 24, v223
		v_or3_b32 v217, v217, v219, v223
		v_and_b32_e32 v219, 0xff, v240
		v_and_b32_e32 v223, 0xff, v241
		v_lshlrev_b32_e32 v223, 8, v223
		v_or_b32_e32 v219, v219, v223
		v_and_b32_e32 v223, 0xff, v242
		v_lshlrev_b32_e32 v223, 16, v223
		v_and_b32_e32 v224, 0xff, v243
		v_lshlrev_b32_e32 v224, 24, v224
		v_or3_b32 v219, v219, v223, v224
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v223, 0xff, v245
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v206, 0xff, v206
		v_lshlrev_b32_e32 v206, 8, v206
		v_or_b32_e32 v206, v223, v206
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v214, 0xff, v214
		v_lshlrev_b32_e32 v214, 16, v214
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v223, 0xff, v246
		v_lshlrev_b32_e32 v223, 24, v223
		v_or3_b32 v206, v206, v214, v223
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v214, 0xff, v248
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v223, 0xff, v249
		v_lshlrev_b32_e32 v223, 8, v223
		v_or_b32_e32 v214, v214, v223
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v223, 0xff, v225
		v_lshlrev_b32_e32 v223, 16, v223
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v218, 0xff, v218
		v_lshlrev_b32_e32 v218, 24, v218
		v_or3_b32 v214, v214, v223, v218
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[172:175], v[108:111], v[4:7], v206, v209 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[176:179], v[112:115], v[4:7], v206, v209 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[180:183], v[108:111], a[0:3], v206, v209 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[184:187], v[112:115], a[0:3], v206, v209 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[108:111], a[4:7], v214, v209 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[112:115], a[4:7], v214, v209 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[108:111], a[8:11], v214, v209 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[112:115], a[8:11], v214, v209 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[172:175], v[116:119], a[12:15], v206, v209 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[176:179], v[120:123], a[12:15], v206, v209 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[116:119], a[16:19], v206, v209 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[184:187], v[120:123], a[16:19], v206, v209 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[116:119], a[20:23], v214, v209 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[192:195], v[120:123], a[20:23], v214, v209 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[116:119], a[24:27], v214, v209 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[120:123], a[24:27], v214, v209 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[172:175], v[124:127], a[28:31], v206, v211 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[176:179], v[128:131], a[28:31], v206, v211 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[124:127], a[32:35], v206, v211 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[184:187], v[128:131], a[32:35], v206, v211 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[124:127], a[36:39], v214, v211 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[192:195], v[128:131], a[36:39], v214, v211 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[124:127], a[40:43], v214, v211 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[128:131], a[40:43], v214, v211 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[172:175], v[132:135], a[44:47], v206, v211 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[176:179], v[136:139], a[44:47], v206, v211 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[132:135], a[48:51], v206, v211 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[184:187], v[136:139], a[48:51], v206, v211 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[132:135], a[52:55], v214, v211 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[192:195], v[136:139], a[52:55], v214, v211 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[132:135], a[56:59], v214, v211 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[200:203], v[136:139], a[56:59], v214, v211 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[172:175], v[140:143], a[60:63], v206, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[176:179], v[144:147], a[60:63], v206, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[140:143], a[64:67], v206, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[184:187], v[144:147], a[64:67], v206, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[140:143], a[68:71], v214, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[192:195], v[144:147], a[68:71], v214, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[140:143], a[72:75], v214, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[200:203], v[144:147], a[72:75], v214, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[172:175], v[148:151], a[76:79], v206, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[176:179], v[152:155], a[76:79], v206, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[148:151], a[80:83], v206, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[184:187], v[152:155], a[80:83], v206, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[148:151], a[84:87], v214, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[192:195], v[152:155], a[84:87], v214, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[148:151], a[88:91], v214, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[200:203], v[152:155], a[88:91], v214, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[172:175], v[156:159], a[92:95], v206, v219 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[176:179], v[160:163], a[92:95], v206, v219 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[180:183], v[156:159], a[96:99], v206, v219 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[184:187], v[160:163], a[96:99], v206, v219 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], v[156:159], a[100:103], v214, v219 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[192:195], v[160:163], a[100:103], v214, v219 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[196:199], v[156:159], a[104:107], v214, v219 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[200:203], v[160:163], a[104:107], v214, v219 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[172:175], v[164:167], a[108:111], v206, v219 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[176:179], v[168:171], a[108:111], v206, v219 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[180:183], v[164:167], a[112:115], v206, v219 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[184:187], v[168:171], a[112:115], v206, v219 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[188:191], v[164:167], a[116:119], v214, v219 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[192:195], v[168:171], a[116:119], v214, v219 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[196:199], v[164:167], a[120:123], v214, v219 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[200:203], v[168:171], a[120:123], v214, v219 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[172:175], v106 offset:32768
		ds_read_b128 v[176:179], v106 offset:32832
		ds_read_b128 v[180:183], v106 offset:36864
		ds_read_b128 v[184:187], v106 offset:36928
		ds_read_b128 v[188:191], v106 offset:40960
		ds_read_b128 v[192:195], v106 offset:41024
		ds_read_b128 v[196:199], v106 offset:45056
		ds_read_b128 v[200:203], v106 offset:45120
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
		ds_read_u8 v55, v244 offset:2048
		ds_read_u8 v74, v65 offset:2048
		ds_read_u8 v77, v210 offset:2048
		ds_read_u8 v81, v208 offset:2048
		ds_read_u8 v206, v247 offset:2048
		ds_read_u8 v214, v220 offset:2048
		ds_read_u8 v218, v212 offset:2048
		ds_read_u8 v223, v207 offset:2048
		s_add_i32 s100, s22, s95
		s_mov_b32 m0, s2
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s28, s95
		s_mov_b32 m0, s29
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s31, s95
		s_mov_b32 m0, s32
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s34, s95
		s_mov_b32 m0, s35
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s37, s95
		s_mov_b32 m0, s38
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s40, s95
		s_mov_b32 m0, s41
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s43, s95
		s_mov_b32 m0, s44
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s45, s95
		s_mov_b32 m0, s46
		v_add3_u32 v224, s100, v25, v27
		buffer_load_dwordx4 v224, s[24:27], 0 offen lds
		s_add_i32 s100, s4, s98
		s_mov_b32 m0, s5
		v_add3_u32 v224, s100, v28, v27
		buffer_load_dwordx4 v224, s[48:51], 0 offen lds
		s_add_i32 s100, s52, s98
		s_mov_b32 m0, s53
		v_add3_u32 v224, s100, v28, v27
		buffer_load_dwordx4 v224, s[48:51], 0 offen lds
		s_add_i32 s100, s55, s98
		s_mov_b32 m0, s56
		v_add3_u32 v224, s100, v28, v27
		buffer_load_dwordx4 v224, s[48:51], 0 offen lds
		s_add_i32 s100, s58, s98
		s_mov_b32 m0, s59
		v_add3_u32 v224, s100, v28, v27
		buffer_load_dwordx4 v224, s[48:51], 0 offen lds
		s_add_i32 s100, s64, s96
		v_add3_u32 v224, s100, v31, v33
		v_add3_u32 v224, v224, v37, v40
		v_add3_u32 v224, v224, v43, v45
		v_add3_u32 v224, v224, v47, v49
		buffer_load_dwordx2 v[228:229], v224, s[60:63], 0 offen
		s_add_i32 s100, s10, s99
		v_add3_u32 v224, s100, v52, v54
		v_add3_u32 v224, v224, v57, v59
		v_add3_u32 v224, v224, v61, v62
		v_add3_u32 v224, v224, v63, v64
		buffer_load_dword v225, v224, s[68:71], 0 offen
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
		v_and_b32_e32 v74, 0xff, v206
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v77, 0xff, v214
		v_lshlrev_b32_e32 v77, 8, v77
		v_or_b32_e32 v74, v74, v77
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v77, 0xff, v218
		v_lshlrev_b32_e32 v77, 16, v77
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v81, 0xff, v223
		v_lshlrev_b32_e32 v81, 24, v81
		v_or3_b32 v74, v74, v77, v81
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[172:175], v[108:111], a[124:127], v55, v209 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[176:179], v[112:115], a[124:127], v55, v209 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[180:183], v[108:111], a[128:131], v55, v209 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[184:187], v[112:115], a[128:131], v55, v209 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[188:191], v[108:111], a[132:135], v74, v209 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[192:195], v[112:115], a[132:135], v74, v209 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[196:199], v[108:111], a[136:139], v74, v209 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[200:203], v[112:115], a[136:139], v74, v209 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[172:175], v[116:119], a[140:143], v55, v209 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[176:179], v[120:123], a[140:143], v55, v209 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[180:183], v[116:119], a[144:147], v55, v209 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[184:187], v[120:123], a[144:147], v55, v209 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[188:191], v[116:119], a[148:151], v74, v209 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[192:195], v[120:123], a[148:151], v74, v209 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[196:199], v[116:119], a[152:155], v74, v209 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[200:203], v[120:123], a[152:155], v74, v209 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[172:175], v[124:127], a[156:159], v55, v211 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[176:179], v[128:131], a[156:159], v55, v211 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[180:183], v[124:127], a[160:163], v55, v211 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[184:187], v[128:131], a[160:163], v55, v211 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[188:191], v[124:127], a[164:167], v74, v211 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[192:195], v[128:131], a[164:167], v74, v211 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[196:199], v[124:127], a[168:171], v74, v211 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[200:203], v[128:131], a[168:171], v74, v211 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[172:175], v[132:135], a[172:175], v55, v211 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[176:179], v[136:139], a[172:175], v55, v211 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[180:183], v[132:135], a[176:179], v55, v211 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[184:187], v[136:139], a[176:179], v55, v211 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[188:191], v[132:135], a[180:183], v74, v211 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[192:195], v[136:139], a[180:183], v74, v211 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[196:199], v[132:135], a[184:187], v74, v211 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[200:203], v[136:139], a[184:187], v74, v211 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[172:175], v[140:143], a[188:191], v55, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[176:179], v[144:147], a[188:191], v55, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[140:143], a[192:195], v55, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[184:187], v[144:147], a[192:195], v55, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[188:191], v[140:143], a[196:199], v74, v217 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[192:195], v[144:147], a[196:199], v74, v217 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[196:199], v[140:143], a[200:203], v74, v217 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[200:203], v[144:147], a[200:203], v74, v217 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[172:175], v[148:151], a[204:207], v55, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[176:179], v[152:155], a[204:207], v55, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[148:151], a[208:211], v55, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[184:187], v[152:155], a[208:211], v55, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[188:191], v[148:151], a[212:215], v74, v217 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[192:195], v[152:155], a[212:215], v74, v217 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[196:199], v[148:151], a[216:219], v74, v217 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[200:203], v[152:155], a[216:219], v74, v217 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[172:175], v[156:159], a[220:223], v55, v219 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[176:179], v[160:163], a[220:223], v55, v219 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[180:183], v[156:159], a[224:227], v55, v219 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[184:187], v[160:163], a[224:227], v55, v219 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[188:191], v[156:159], a[228:231], v74, v219 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[192:195], v[160:163], a[228:231], v74, v219 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[196:199], v[156:159], a[232:235], v74, v219 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[200:203], v[160:163], a[232:235], v74, v219 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[172:175], v[164:167], a[236:239], v55, v219 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[176:179], v[168:171], a[236:239], v55, v219 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[180:183], v[164:167], a[240:243], v55, v219 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[184:187], v[168:171], a[240:243], v55, v219 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[188:191], v[164:167], a[244:247], v74, v219 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[192:195], v[168:171], a[244:247], v74, v219 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[196:199], v[164:167], v[252:255], v74, v219 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[200:203], v[168:171], v[252:255], v74, v219 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
		ds_read_b128 v[108:111], v104 offset:32768
		ds_read_b128 v[112:115], v104 offset:32832
		ds_read_b128 v[116:119], v104 offset:36864
		ds_read_b128 v[120:123], v104 offset:36928
		ds_read_b128 v[124:127], v104 offset:40960
		ds_read_b128 v[128:131], v104 offset:41024
		ds_read_b128 v[132:135], v104 offset:45056
		ds_read_b128 v[136:139], v104 offset:45120
		ds_read_b128 v[140:143], v104 offset:49152
		ds_read_b128 v[144:147], v104 offset:49216
		ds_read_b128 v[148:151], v104 offset:53248
		ds_read_b128 v[152:155], v104 offset:53312
		ds_read_b128 v[156:159], v104 offset:57344
		ds_read_b128 v[160:163], v104 offset:57408
		ds_read_b128 v[164:167], v104 offset:61440
		ds_read_b128 v[168:171], v104 offset:61504
		ds_read_b128 v[172:175], v106 offset:16384
		ds_read_b128 v[176:179], v106 offset:16448
		ds_read_b128 v[180:183], v106 offset:20480
		ds_read_b128 v[184:187], v106 offset:20544
		ds_read_b128 v[188:191], v106 offset:24576
		ds_read_b128 v[192:195], v106 offset:24640
		ds_read_b128 v[196:199], v106 offset:28672
		ds_read_b128 v[200:203], v106 offset:28736
		s_waitcnt vmcnt(33)
		ds_write_b8 v0, v97
		s_waitcnt vmcnt(32)
		ds_write_b8 v71, v80
		s_waitcnt vmcnt(31)
		ds_write_b8 v75, v83
		s_waitcnt vmcnt(30)
		ds_write_b8 v78, v85
		s_waitcnt vmcnt(29)
		ds_write_b8 v88, v87
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
		ds_write_b8 v75, v98 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v78, v99 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v72, v205
		ds_read_u8 v80, v51
		ds_read_u8 v83, v216
		ds_read_u8 v85, v215
		ds_read_u8 v87, v222
		ds_read_u8 v90, v221
		ds_read_u8 v93, v227
		ds_read_u8 v96, v226
		ds_read_u8 v97, v231
		ds_read_u8 v98, v230
		ds_read_u8 v99, v235
		ds_read_u8 v101, v234
		ds_read_u8 v206, v239
		ds_read_u8 v209, v238
		ds_read_u8 v211, v213
		ds_read_u8 v214, v68
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v217, v244 offset:2048
		ds_read_u8 v218, v65 offset:2048
		ds_read_u8 v219, v210 offset:2048
		ds_read_u8 v223, v208 offset:2048
		ds_read_u8 v224, v247 offset:2048
		ds_read_u8 v232, v220 offset:2048
		ds_read_u8 v233, v212 offset:2048
		ds_read_u8 v236, v207 offset:2048
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
		v_add3_u32 v74, s100, v73, v32
		v_add3_u32 v74, v74, v66, v67
		v_add3_u32 v77, s100, v76, v32
		v_add3_u32 v77, v77, v66, v67
		v_add3_u32 v81, s100, v79, v32
		v_add3_u32 v237, v81, v66, v67
		buffer_load_ubyte v81, v55, s[68:71], 0 offen
		buffer_load_ubyte v55, v74, s[68:71], 0 offen
		buffer_load_ubyte v74, v77, s[68:71], 0 offen
		buffer_load_ubyte v77, v237, s[68:71], 0 offen
		v_and_b32_e32 v72, 0xff, v72
		v_and_b32_e32 v80, 0xff, v80
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v83
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v85
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v237, v72, v80, v83
		v_and_b32_e32 v72, 0xff, v87
		v_and_b32_e32 v80, 0xff, v90
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v93
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v96
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v240, v72, v80, v83
		v_and_b32_e32 v72, 0xff, v97
		v_and_b32_e32 v80, 0xff, v98
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v99
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v101
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v241, v72, v80, v83
		v_and_b32_e32 v72, 0xff, v206
		v_and_b32_e32 v80, 0xff, v209
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		v_and_b32_e32 v80, 0xff, v211
		v_lshlrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v83, 0xff, v214
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v206, v72, v80, v83
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v72, 0xff, v217
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v80, 0xff, v218
		v_lshlrev_b32_e32 v80, 8, v80
		v_or_b32_e32 v72, v72, v80
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v80, 0xff, v219
		v_lshlrev_b32_e32 v80, 16, v80
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v83, 0xff, v223
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v72, v72, v80, v83
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v80, 0xff, v224
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v83, 0xff, v232
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v80, v80, v83
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v83, 0xff, v233
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v85, 0xff, v236
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v80, v80, v83, v85
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[172:175], v[108:111], v[4:7], v72, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[176:179], v[112:115], v[4:7], v72, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[180:183], v[108:111], a[0:3], v72, v237 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[184:187], v[112:115], a[0:3], v72, v237 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[108:111], a[4:7], v80, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[112:115], a[4:7], v80, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[108:111], a[8:11], v80, v237 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[112:115], a[8:11], v80, v237 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[172:175], v[116:119], a[12:15], v72, v237 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[176:179], v[120:123], a[12:15], v72, v237 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[116:119], a[16:19], v72, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[184:187], v[120:123], a[16:19], v72, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[116:119], a[20:23], v80, v237 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[192:195], v[120:123], a[20:23], v80, v237 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[116:119], a[24:27], v80, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[120:123], a[24:27], v80, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[172:175], v[124:127], a[28:31], v72, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[176:179], v[128:131], a[28:31], v72, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[124:127], a[32:35], v72, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[184:187], v[128:131], a[32:35], v72, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[124:127], a[36:39], v80, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[192:195], v[128:131], a[36:39], v80, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[124:127], a[40:43], v80, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[128:131], a[40:43], v80, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[172:175], v[132:135], a[44:47], v72, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[176:179], v[136:139], a[44:47], v72, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[132:135], a[48:51], v72, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[184:187], v[136:139], a[48:51], v72, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[132:135], a[52:55], v80, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[192:195], v[136:139], a[52:55], v80, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[132:135], a[56:59], v80, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[200:203], v[136:139], a[56:59], v80, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[172:175], v[140:143], a[60:63], v72, v241 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[176:179], v[144:147], a[60:63], v72, v241 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[140:143], a[64:67], v72, v241 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[184:187], v[144:147], a[64:67], v72, v241 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[140:143], a[68:71], v80, v241 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[192:195], v[144:147], a[68:71], v80, v241 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[140:143], a[72:75], v80, v241 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[200:203], v[144:147], a[72:75], v80, v241 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[172:175], v[148:151], a[76:79], v72, v241 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[176:179], v[152:155], a[76:79], v72, v241 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[148:151], a[80:83], v72, v241 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[184:187], v[152:155], a[80:83], v72, v241 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[148:151], a[84:87], v80, v241 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[192:195], v[152:155], a[84:87], v80, v241 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[148:151], a[88:91], v80, v241 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[200:203], v[152:155], a[88:91], v80, v241 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[172:175], v[156:159], a[92:95], v72, v206 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[176:179], v[160:163], a[92:95], v72, v206 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[180:183], v[156:159], a[96:99], v72, v206 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[184:187], v[160:163], a[96:99], v72, v206 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], v[156:159], a[100:103], v80, v206 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[192:195], v[160:163], a[100:103], v80, v206 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[196:199], v[156:159], a[104:107], v80, v206 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[200:203], v[160:163], a[104:107], v80, v206 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[172:175], v[164:167], a[108:111], v72, v206 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[176:179], v[168:171], a[108:111], v72, v206 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[180:183], v[164:167], a[112:115], v72, v206 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[184:187], v[168:171], a[112:115], v72, v206 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[188:191], v[164:167], a[116:119], v80, v206 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[192:195], v[168:171], a[116:119], v80, v206 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[196:199], v[164:167], a[120:123], v80, v206 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[200:203], v[168:171], a[120:123], v80, v206 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 v[172:175], v106 offset:49152
		ds_read_b128 v[176:179], v106 offset:49216
		ds_read_b128 v[180:183], v106 offset:53248
		ds_read_b128 v[184:187], v106 offset:53312
		ds_read_b128 v[188:191], v106 offset:57344
		ds_read_b128 v[192:195], v106 offset:57408
		ds_read_b128 v[196:199], v106 offset:61440
		ds_read_b128 v[200:203], v106 offset:61504
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v105 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v71, v100 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v75, v102 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v78, v103 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v100, v244 offset:2048
		ds_read_u8 v102, v65 offset:2048
		ds_read_u8 v103, v210 offset:2048
		ds_read_u8 v105, v208 offset:2048
		ds_read_u8 v209, v247 offset:2048
		ds_read_u8 v211, v220 offset:2048
		ds_read_u8 v214, v212 offset:2048
		ds_read_u8 v217, v207 offset:2048
		s_add_i32 s100, s19, s95
		s_mov_b32 m0, s81
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s23, s95
		s_mov_b32 m0, s82
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s30, s95
		s_mov_b32 m0, s83
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s33, s95
		s_mov_b32 m0, s84
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s36, s95
		s_mov_b32 m0, s85
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s39, s95
		s_mov_b32 m0, s86
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s42, s95
		s_mov_b32 m0, s87
		v_add3_u32 v72, s100, v25, v27
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s100, s3, s95
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
		s_add_i32 s100, s8, s96
		v_add3_u32 v72, s100, v30, v36
		v_add3_u32 v72, v72, v39, v42
		v_add3_u32 v72, v72, v44, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v80, s100, v82, v32
		v_add3_u32 v83, v80, v66, v67
		v_add3_u32 v80, s100, v84, v32
		v_add3_u32 v85, v80, v66, v67
		v_add3_u32 v80, s100, v86, v32
		v_add3_u32 v87, v80, v66, v67
		v_add3_u32 v80, s100, v89, v32
		v_add3_u32 v90, v80, v66, v67
		v_add3_u32 v80, s100, v92, v32
		v_add3_u32 v93, v80, v66, v67
		v_add3_u32 v80, s100, v95, v32
		v_add3_u32 v96, v80, v66, v67
		v_add3_u32 v80, s100, v70, v32
		v_add3_u32 v98, v80, v66, v67
		buffer_load_ubyte v97, v72, s[60:63], 0 offen
		buffer_load_ubyte v80, v83, s[60:63], 0 offen
		buffer_load_ubyte v83, v85, s[60:63], 0 offen
		buffer_load_ubyte v85, v87, s[60:63], 0 offen
		buffer_load_ubyte v87, v90, s[60:63], 0 offen
		buffer_load_ubyte v90, v93, s[60:63], 0 offen
		buffer_load_ubyte v93, v96, s[60:63], 0 offen
		buffer_load_ubyte v96, v98, s[60:63], 0 offen
		s_add_i32 s100, s9, s99
		v_add3_u32 v72, s100, v34, v53
		v_add3_u32 v72, v72, v56, v58
		v_add3_u32 v72, v72, v60, v32
		v_add3_u32 v72, v72, v66, v67
		v_add3_u32 v98, s100, v73, v32
		v_add3_u32 v98, v98, v66, v67
		v_add3_u32 v99, s100, v76, v32
		v_add3_u32 v99, v99, v66, v67
		v_add3_u32 v101, s100, v79, v32
		v_add3_u32 v218, v101, v66, v67
		buffer_load_ubyte v101, v72, s[68:71], 0 offen
		buffer_load_ubyte v72, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v218, s[68:71], 0 offen
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v100, 0xff, v100
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v102, 0xff, v102
		v_lshlrev_b32_e32 v102, 8, v102
		v_or_b32_e32 v100, v100, v102
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v102, 0xff, v103
		v_lshlrev_b32_e32 v102, 16, v102
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v103, 0xff, v105
		v_lshlrev_b32_e32 v103, 24, v103
		v_or3_b32 v100, v100, v102, v103
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v102, 0xff, v209
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v103, 0xff, v211
		v_lshlrev_b32_e32 v103, 8, v103
		v_or_b32_e32 v102, v102, v103
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v103, 0xff, v214
		v_lshlrev_b32_e32 v103, 16, v103
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v105, 0xff, v217
		v_lshlrev_b32_e32 v105, 24, v105
		v_or3_b32 v102, v102, v103, v105
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[172:175], v[108:111], a[124:127], v100, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[176:179], v[112:115], a[124:127], v100, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[180:183], v[108:111], a[128:131], v100, v237 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[184:187], v[112:115], a[128:131], v100, v237 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[188:191], v[108:111], a[132:135], v102, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[192:195], v[112:115], a[132:135], v102, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[196:199], v[108:111], a[136:139], v102, v237 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[200:203], v[112:115], a[136:139], v102, v237 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[172:175], v[116:119], a[140:143], v100, v237 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[176:179], v[120:123], a[140:143], v100, v237 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[180:183], v[116:119], a[144:147], v100, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[184:187], v[120:123], a[144:147], v100, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[188:191], v[116:119], a[148:151], v102, v237 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[192:195], v[120:123], a[148:151], v102, v237 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[196:199], v[116:119], a[152:155], v102, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[200:203], v[120:123], a[152:155], v102, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[172:175], v[124:127], a[156:159], v100, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[176:179], v[128:131], a[156:159], v100, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[180:183], v[124:127], a[160:163], v100, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[184:187], v[128:131], a[160:163], v100, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[188:191], v[124:127], a[164:167], v102, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[192:195], v[128:131], a[164:167], v102, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[196:199], v[124:127], a[168:171], v102, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[200:203], v[128:131], a[168:171], v102, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[172:175], v[132:135], a[172:175], v100, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[176:179], v[136:139], a[172:175], v100, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[180:183], v[132:135], a[176:179], v100, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[184:187], v[136:139], a[176:179], v100, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[188:191], v[132:135], a[180:183], v102, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[192:195], v[136:139], a[180:183], v102, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[196:199], v[132:135], a[184:187], v102, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[200:203], v[136:139], a[184:187], v102, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[172:175], v[140:143], a[188:191], v100, v241 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[176:179], v[144:147], a[188:191], v100, v241 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[140:143], a[192:195], v100, v241 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[184:187], v[144:147], a[192:195], v100, v241 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[188:191], v[140:143], a[196:199], v102, v241 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[192:195], v[144:147], a[196:199], v102, v241 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[196:199], v[140:143], a[200:203], v102, v241 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[200:203], v[144:147], a[200:203], v102, v241 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[172:175], v[148:151], a[204:207], v100, v241 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[176:179], v[152:155], a[204:207], v100, v241 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[148:151], a[208:211], v100, v241 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[184:187], v[152:155], a[208:211], v100, v241 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[188:191], v[148:151], a[212:215], v102, v241 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[192:195], v[152:155], a[212:215], v102, v241 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[196:199], v[148:151], a[216:219], v102, v241 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[200:203], v[152:155], a[216:219], v102, v241 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[172:175], v[156:159], a[220:223], v100, v206 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[176:179], v[160:163], a[220:223], v100, v206 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[180:183], v[156:159], a[224:227], v100, v206 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[184:187], v[160:163], a[224:227], v100, v206 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[188:191], v[156:159], a[228:231], v102, v206 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[192:195], v[160:163], a[228:231], v102, v206 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[196:199], v[156:159], a[232:235], v102, v206 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[200:203], v[160:163], a[232:235], v102, v206 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[172:175], v[164:167], a[236:239], v100, v206 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[176:179], v[168:171], a[236:239], v100, v206 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[180:183], v[164:167], a[240:243], v100, v206 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[184:187], v[168:171], a[240:243], v100, v206 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[188:191], v[164:167], a[244:247], v102, v206 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[192:195], v[168:171], a[244:247], v102, v206 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[196:199], v[164:167], v[252:255], v102, v206 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[200:203], v[168:171], v[252:255], v102, v206 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
		ds_read_b128 v[108:111], v104
		ds_read_b128 v[112:115], v104 offset:64
		ds_read_b128 v[116:119], v104 offset:4096
		ds_read_b128 v[120:123], v104 offset:4160
		ds_read_b128 v[124:127], v104 offset:8192
		ds_read_b128 v[128:131], v104 offset:8256
		ds_read_b128 v[132:135], v104 offset:12288
		ds_read_b128 v[136:139], v104 offset:12352
		ds_read_b128 v[140:143], v104 offset:16384
		ds_read_b128 v[144:147], v104 offset:16448
		ds_read_b128 v[148:151], v104 offset:20480
		ds_read_b128 v[152:155], v104 offset:20544
		ds_read_b128 v[156:159], v104 offset:24576
		ds_read_b128 v[160:163], v104 offset:24640
		ds_read_b128 v[164:167], v104 offset:28672
		ds_read_b128 v[168:171], v104 offset:28736
		ds_read_b128 v[172:175], v106
		ds_read_b128 v[176:179], v106 offset:64
		ds_read_b128 v[180:183], v106 offset:4096
		ds_read_b128 v[184:187], v106 offset:4160
		ds_read_b128 v[188:191], v106 offset:8192
		ds_read_b128 v[192:195], v106 offset:8256
		ds_read_b128 v[196:199], v106 offset:12288
		ds_read_b128 v[200:203], v106 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v107, v[228:229]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(32)
		ds_write_b32 v50, v225 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v209, v205
		ds_read_u8 v211, v51
		ds_read_u8 v217, v216
		ds_read_u8 v219, v215
		ds_read_u8 v223, v222
		ds_read_u8 v224, v221
		ds_read_u8 v228, v227
		ds_read_u8 v229, v226
		ds_read_u8 v232, v231
		ds_read_u8 v233, v230
		ds_read_u8 v236, v235
		ds_read_u8 v237, v234
		ds_read_u8 v240, v239
		ds_read_u8 v241, v238
		ds_read_u8 v242, v213
		ds_read_u8 v243, v68
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v245, v244 offset:2048
		ds_read_u8 v206, v65 offset:2048
		ds_read_u8 v214, v210 offset:2048
		ds_read_u8 v246, v208 offset:2048
		ds_read_u8 v248, v247 offset:2048
		ds_read_u8 v249, v220 offset:2048
		ds_read_u8 v225, v212 offset:2048
		ds_read_u8 v218, v207 offset:2048
		s_add_i32 s100, s11, s98
		s_mov_b32 m0, s18
		v_add3_u32 v100, s100, v28, v27
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s100, s67, s98
		s_mov_b32 m0, s92
		v_add3_u32 v100, s100, v28, v27
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s100, s74, s98
		s_mov_b32 m0, s93
		v_add3_u32 v100, s100, v28, v27
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s100, s15, s98
		s_mov_b32 m0, s94
		v_add3_u32 v100, s100, v28, v27
		buffer_load_dwordx4 v100, s[48:51], 0 offen lds
		s_add_i32 s100, s79, s99
		v_add3_u32 v100, s100, v34, v53
		v_add3_u32 v100, v100, v56, v58
		v_add3_u32 v100, v100, v60, v32
		v_add3_u32 v100, v100, v66, v67
		v_add3_u32 v102, s100, v73, v32
		v_add3_u32 v102, v102, v66, v67
		v_add3_u32 v103, s100, v76, v32
		v_add3_u32 v103, v103, v66, v67
		v_add3_u32 v105, s100, v79, v32
		v_add3_u32 v250, v105, v66, v67
		buffer_load_ubyte v105, v100, s[68:71], 0 offen
		buffer_load_ubyte v100, v102, s[68:71], 0 offen
		buffer_load_ubyte v102, v103, s[68:71], 0 offen
		buffer_load_ubyte v103, v250, s[68:71], 0 offen
		s_add_i32 s95, s95, 0x100
		s_add_i32 s98, s98, 0x100
		s_add_i32 s96, s96, 16
		s_add_i32 s99, s99, 16
		s_add_i32 s97, s97, 2
		s_cmp_lt_i32 s97, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		v_and_b32_e32 v25, 0xff, v209
		v_and_b32_e32 v27, 0xff, v211
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v25, v25, v27
		v_and_b32_e32 v27, 0xff, v217
		v_lshlrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v28, 0xff, v219
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v25, v25, v27, v28
		v_and_b32_e32 v27, 0xff, v223
		v_and_b32_e32 v28, 0xff, v224
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		v_and_b32_e32 v28, 0xff, v228
		v_lshlrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v30, 0xff, v229
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		v_and_b32_e32 v28, 0xff, v232
		v_and_b32_e32 v30, 0xff, v233
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		v_and_b32_e32 v30, 0xff, v236
		v_lshlrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v31, 0xff, v237
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v28, v28, v30, v31
		v_and_b32_e32 v30, 0xff, v240
		v_and_b32_e32 v31, 0xff, v241
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v30, v30, v31
		v_and_b32_e32 v31, 0xff, v242
		v_lshlrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v33, 0xff, v243
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v30, v30, v31, v33
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v245
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v206
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v214
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v34, 0xff, v246
		v_lshlrev_b32_e32 v34, 24, v34
		v_or3_b32 v31, v31, v33, v34
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v248
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v34, 0xff, v249
		v_lshlrev_b32_e32 v34, 8, v34
		v_or_b32_e32 v33, v33, v34
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v34, 0xff, v225
		v_lshlrev_b32_e32 v34, 16, v34
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v218
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v34, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[172:175], v[108:111], v[4:7], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[176:179], v[112:115], v[4:7], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[180:183], v[108:111], a[0:3], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[184:187], v[112:115], a[0:3], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[108:111], a[4:7], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[112:115], a[4:7], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[108:111], a[8:11], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[112:115], a[8:11], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[172:175], v[116:119], a[12:15], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[176:179], v[120:123], a[12:15], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[116:119], a[16:19], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[184:187], v[120:123], a[16:19], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[116:119], a[20:23], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[192:195], v[120:123], a[20:23], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[116:119], a[24:27], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[120:123], a[24:27], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[172:175], v[124:127], a[28:31], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[176:179], v[128:131], a[28:31], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[124:127], a[32:35], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[184:187], v[128:131], a[32:35], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[124:127], a[36:39], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[192:195], v[128:131], a[36:39], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[124:127], a[40:43], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[128:131], a[40:43], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[172:175], v[132:135], a[44:47], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[176:179], v[136:139], a[44:47], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[132:135], a[48:51], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[184:187], v[136:139], a[48:51], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[132:135], a[52:55], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[192:195], v[136:139], a[52:55], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[132:135], a[56:59], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[200:203], v[136:139], a[56:59], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[172:175], v[140:143], a[60:63], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[176:179], v[144:147], a[60:63], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[140:143], a[64:67], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[184:187], v[144:147], a[64:67], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[140:143], a[68:71], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[192:195], v[144:147], a[68:71], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[140:143], a[72:75], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[200:203], v[144:147], a[72:75], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[172:175], v[148:151], a[76:79], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[176:179], v[152:155], a[76:79], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[148:151], a[80:83], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[184:187], v[152:155], a[80:83], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[148:151], a[84:87], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[192:195], v[152:155], a[84:87], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[148:151], a[88:91], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[200:203], v[152:155], a[88:91], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[172:175], v[156:159], a[92:95], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[176:179], v[160:163], a[92:95], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[180:183], v[156:159], a[96:99], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[184:187], v[160:163], a[96:99], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], v[156:159], a[100:103], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[192:195], v[160:163], a[100:103], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[196:199], v[156:159], a[104:107], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[200:203], v[160:163], a[104:107], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[172:175], v[164:167], a[108:111], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[176:179], v[168:171], a[108:111], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[180:183], v[164:167], a[112:115], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[184:187], v[168:171], a[112:115], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[188:191], v[164:167], a[116:119], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[192:195], v[168:171], a[116:119], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[196:199], v[164:167], a[120:123], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[200:203], v[168:171], a[120:123], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[56:59], v106 offset:32768
		ds_read_b128 v[60:63], v106 offset:32832
		ds_read_b128 v[172:175], v106 offset:36864
		ds_read_b128 v[176:179], v106 offset:36928
		ds_read_b128 v[180:183], v106 offset:40960
		ds_read_b128 v[184:187], v106 offset:41024
		ds_read_b128 v[188:191], v106 offset:45056
		ds_read_b128 v[192:195], v106 offset:45120
		ds_write_b8 v0, v81 offset:2048
		ds_write_b8 v71, v55 offset:2048
		ds_write_b8 v75, v74 offset:2048
		ds_write_b8 v78, v77 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v31, v244 offset:2048
		ds_read_u8 v33, v65 offset:2048
		ds_read_u8 v34, v210 offset:2048
		ds_read_u8 v36, v208 offset:2048
		ds_read_u8 v37, v247 offset:2048
		ds_read_u8 v39, v220 offset:2048
		ds_read_u8 v40, v212 offset:2048
		ds_read_u8 v42, v207 offset:2048
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[56:59], v[108:111], a[124:127], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], v[112:115], a[124:127], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[172:175], v[108:111], a[128:131], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[176:179], v[112:115], a[128:131], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[180:183], v[108:111], a[132:135], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[184:187], v[112:115], a[132:135], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[188:191], v[108:111], a[136:139], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[192:195], v[112:115], a[136:139], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[56:59], v[116:119], a[140:143], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], v[120:123], a[140:143], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[172:175], v[116:119], a[144:147], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[176:179], v[120:123], a[144:147], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[180:183], v[116:119], a[148:151], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[184:187], v[120:123], a[148:151], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[188:191], v[116:119], a[152:155], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[192:195], v[120:123], a[152:155], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[56:59], v[124:127], a[156:159], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], v[128:131], a[156:159], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[172:175], v[124:127], a[160:163], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[176:179], v[128:131], a[160:163], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[180:183], v[124:127], a[164:167], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[184:187], v[128:131], a[164:167], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[188:191], v[124:127], a[168:171], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[192:195], v[128:131], a[168:171], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[56:59], v[132:135], a[172:175], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], v[136:139], a[172:175], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[172:175], v[132:135], a[176:179], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[176:179], v[136:139], a[176:179], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[180:183], v[132:135], a[180:183], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[184:187], v[136:139], a[180:183], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[188:191], v[132:135], a[184:187], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[192:195], v[136:139], a[184:187], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[56:59], v[140:143], a[188:191], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[60:63], v[144:147], a[188:191], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[172:175], v[140:143], a[192:195], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[176:179], v[144:147], a[192:195], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[180:183], v[140:143], a[196:199], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[184:187], v[144:147], a[196:199], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[188:191], v[140:143], a[200:203], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[192:195], v[144:147], a[200:203], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[56:59], v[148:151], a[204:207], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], v[152:155], a[204:207], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[172:175], v[148:151], a[208:211], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[176:179], v[152:155], a[208:211], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[180:183], v[148:151], a[212:215], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[184:187], v[152:155], a[212:215], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[188:191], v[148:151], a[216:219], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[192:195], v[152:155], a[216:219], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[56:59], v[156:159], a[220:223], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[60:63], v[160:163], a[220:223], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[172:175], v[156:159], a[224:227], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[176:179], v[160:163], a[224:227], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[180:183], v[156:159], a[228:231], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[184:187], v[160:163], a[228:231], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[188:191], v[156:159], a[232:235], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[192:195], v[160:163], a[232:235], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[56:59], v[164:167], a[236:239], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[60:63], v[168:171], a[236:239], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[172:175], v[164:167], a[240:243], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[176:179], v[168:171], a[240:243], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[180:183], v[164:167], a[244:247], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[184:187], v[168:171], a[244:247], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[188:191], v[164:167], v[252:255], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[192:195], v[168:171], v[252:255], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v104 offset:32768
		ds_read_b128 v[56:59], v104 offset:32832
		ds_read_b128 v[60:63], v104 offset:36864
		ds_read_b128 v[108:111], v104 offset:36928
		ds_read_b128 v[112:115], v104 offset:40960
		ds_read_b128 v[116:119], v104 offset:41024
		ds_read_b128 v[120:123], v104 offset:45056
		ds_read_b128 v[124:127], v104 offset:45120
		ds_read_b128 v[128:131], v104 offset:49152
		ds_read_b128 v[132:135], v104 offset:49216
		ds_read_b128 v[136:139], v104 offset:53248
		ds_read_b128 v[140:143], v104 offset:53312
		ds_read_b128 v[144:147], v104 offset:57344
		ds_read_b128 v[148:151], v104 offset:57408
		ds_read_b128 v[152:155], v104 offset:61440
		ds_read_b128 v[156:159], v104 offset:61504
		ds_read_b128 v[160:163], v106 offset:16384
		ds_read_b128 v[164:167], v106 offset:16448
		ds_read_b128 v[168:171], v106 offset:20480
		ds_read_b128 v[172:175], v106 offset:20544
		ds_read_b128 v[176:179], v106 offset:24576
		ds_read_b128 v[180:183], v106 offset:24640
		ds_read_b128 v[184:187], v106 offset:28672
		ds_read_b128 v[188:191], v106 offset:28736
		ds_write_b8 v0, v97
		ds_write_b8 v71, v80
		ds_write_b8 v75, v83
		ds_write_b8 v78, v85
		ds_write_b8 v88, v87
		ds_write_b8 v91, v90
		ds_write_b8 v94, v93
		ds_write_b8 v69, v96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v101 offset:2048
		ds_write_b8 v71, v72 offset:2048
		ds_write_b8 v75, v98 offset:2048
		ds_write_b8 v78, v99 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v25, v205
		ds_read_u8 v27, v51
		ds_read_u8 v28, v216
		ds_read_u8 v30, v215
		ds_read_u8 v31, v222
		ds_read_u8 v33, v221
		ds_read_u8 v34, v227
		ds_read_u8 v36, v226
		ds_read_u8 v37, v231
		ds_read_u8 v39, v230
		ds_read_u8 v40, v235
		ds_read_u8 v42, v234
		ds_read_u8 v43, v239
		ds_read_u8 v44, v238
		ds_read_u8 v45, v213
		ds_read_u8 v47, v68
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v49, v244 offset:2048
		ds_read_u8 v50, v65 offset:2048
		ds_read_u8 v51, v210 offset:2048
		ds_read_u8 v64, v208 offset:2048
		ds_read_u8 v66, v247 offset:2048
		ds_read_u8 v67, v220 offset:2048
		ds_read_u8 v68, v212 offset:2048
		ds_read_u8 v69, v207 offset:2048
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
		v_and_b32_e32 v30, 0xff, v40
		v_lshlrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v31, 0xff, v42
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v28, v28, v30, v31
		v_and_b32_e32 v30, 0xff, v43
		v_and_b32_e32 v31, 0xff, v44
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v30, v30, v31
		v_and_b32_e32 v31, 0xff, v45
		v_lshlrev_b32_e32 v31, 16, v31
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[160:163], v[52:55], v[4:7], v31, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[164:167], v[56:59], v[4:7], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[168:171], v[52:55], a[0:3], v31, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[172:175], v[56:59], a[0:3], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[176:179], v[52:55], a[4:7], v33, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[180:183], v[56:59], a[4:7], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[184:187], v[52:55], a[8:11], v33, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[188:191], v[56:59], a[8:11], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[160:163], v[60:63], a[12:15], v31, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[164:167], v[108:111], a[12:15], v31, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[168:171], v[60:63], a[16:19], v31, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[172:175], v[108:111], a[16:19], v31, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[176:179], v[60:63], a[20:23], v33, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[180:183], v[108:111], a[20:23], v33, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[184:187], v[60:63], a[24:27], v33, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[188:191], v[108:111], a[24:27], v33, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[160:163], v[112:115], a[28:31], v31, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[164:167], v[116:119], a[28:31], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[168:171], v[112:115], a[32:35], v31, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[172:175], v[116:119], a[32:35], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[176:179], v[112:115], a[36:39], v33, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[180:183], v[116:119], a[36:39], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[184:187], v[112:115], a[40:43], v33, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[188:191], v[116:119], a[40:43], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[160:163], v[120:123], a[44:47], v31, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[164:167], v[124:127], a[44:47], v31, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[168:171], v[120:123], a[48:51], v31, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[172:175], v[124:127], a[48:51], v31, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[176:179], v[120:123], a[52:55], v33, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[180:183], v[124:127], a[52:55], v33, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[184:187], v[120:123], a[56:59], v33, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[188:191], v[124:127], a[56:59], v33, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[160:163], v[128:131], a[60:63], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[164:167], v[132:135], a[60:63], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[168:171], v[128:131], a[64:67], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[172:175], v[132:135], a[64:67], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[176:179], v[128:131], a[68:71], v33, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[180:183], v[132:135], a[68:71], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[184:187], v[128:131], a[72:75], v33, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[188:191], v[132:135], a[72:75], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[160:163], v[136:139], a[76:79], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[164:167], v[140:143], a[76:79], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[168:171], v[136:139], a[80:83], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[172:175], v[140:143], a[80:83], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[176:179], v[136:139], a[84:87], v33, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[180:183], v[140:143], a[84:87], v33, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[184:187], v[136:139], a[88:91], v33, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[188:191], v[140:143], a[88:91], v33, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[160:163], v[144:147], a[92:95], v31, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[164:167], v[148:151], a[92:95], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[144:147], a[96:99], v31, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[172:175], v[148:151], a[96:99], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[176:179], v[144:147], a[100:103], v33, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[180:183], v[148:151], a[100:103], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[184:187], v[144:147], a[104:107], v33, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[188:191], v[148:151], a[104:107], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[160:163], v[152:155], a[108:111], v31, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[164:167], v[156:159], a[108:111], v31, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], v[152:155], a[112:115], v31, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[172:175], v[156:159], a[112:115], v31, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[176:179], v[152:155], a[116:119], v33, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[180:183], v[156:159], a[116:119], v33, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[184:187], v[152:155], a[120:123], v33, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[188:191], v[156:159], a[120:123], v33, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v106 offset:49152
		ds_read_b128 v[84:87], v106 offset:49216
		ds_read_b128 v[88:91], v106 offset:53248
		ds_read_b128 v[92:95], v106 offset:53312
		ds_read_b128 v[96:99], v106 offset:57344
		ds_read_b128 v[160:163], v106 offset:57408
		ds_read_b128 v[164:167], v106 offset:61440
		ds_read_b128 v[168:171], v106 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v105 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v71, v100 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v75, v102 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v78, v103 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v244 offset:2048
		ds_read_u8 v31, v65 offset:2048
		ds_read_u8 v33, v210 offset:2048
		ds_read_u8 v34, v208 offset:2048
		ds_read_u8 v36, v247 offset:2048
		ds_read_u8 v37, v220 offset:2048
		ds_read_u8 v39, v212 offset:2048
		ds_read_u8 v40, v207 offset:2048
		v_cmp_lt_i32_e64 vcc, v18, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v19, s12
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v20, s12
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v21, s12
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[28:29], vcc
		v_cmp_lt_i32_e64 vcc, v12, s12
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v13, s12
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[34:35], vcc
		v_cmp_lt_i32_e64 vcc, v15, s12
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v16, s12
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v22, s13
		s_mov_b64 s[42:43], vcc
		v_cvt_pk_bf16_f32 v8, v4, v5
		v_cvt_pk_bf16_f32 v9, v6, v7
		v_accvgpr_read_b32 v2, a0
		v_accvgpr_read_b32 v3, a1
		v_cvt_pk_bf16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a2
		v_accvgpr_read_b32 v3, a3
		v_cvt_pk_bf16_f32 v5, v2, v3
		v_accvgpr_read_b32 v2, a4
		v_accvgpr_read_b32 v3, a5
		v_cvt_pk_bf16_f32 v12, v2, v3
		v_accvgpr_read_b32 v2, a6
		v_accvgpr_read_b32 v3, a7
		v_cvt_pk_bf16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a8
		v_accvgpr_read_b32 v3, a9
		v_cvt_pk_bf16_f32 v16, v2, v3
		v_accvgpr_read_b32 v2, a10
		v_accvgpr_read_b32 v3, a11
		v_cvt_pk_bf16_f32 v17, v2, v3
		v_accvgpr_read_b32 v2, a12
		v_accvgpr_read_b32 v3, a13
		v_cvt_pk_bf16_f32 v10, v2, v3
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v3, a15
		v_cvt_pk_bf16_f32 v11, v2, v3
		v_accvgpr_read_b32 v2, a16
		v_accvgpr_read_b32 v3, a17
		v_cvt_pk_bf16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a18
		v_accvgpr_read_b32 v3, a19
		v_cvt_pk_bf16_f32 v7, v2, v3
		v_accvgpr_read_b32 v2, a20
		v_accvgpr_read_b32 v3, a21
		v_cvt_pk_bf16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a22
		v_accvgpr_read_b32 v3, a23
		v_cvt_pk_bf16_f32 v15, v2, v3
		v_accvgpr_read_b32 v2, a24
		v_accvgpr_read_b32 v3, a25
		v_cvt_pk_bf16_f32 v18, v2, v3
		v_accvgpr_read_b32 v2, a26
		v_accvgpr_read_b32 v3, a27
		v_cvt_pk_bf16_f32 v19, v2, v3
		v_accvgpr_read_b32 v2, a28
		v_accvgpr_read_b32 v3, a29
		v_cvt_pk_bf16_f32 v64, v2, v3
		v_accvgpr_read_b32 v2, a30
		v_accvgpr_read_b32 v3, a31
		v_cvt_pk_bf16_f32 v65, v2, v3
		v_accvgpr_read_b32 v2, a32
		v_accvgpr_read_b32 v3, a33
		v_cvt_pk_bf16_f32 v68, v2, v3
		v_accvgpr_read_b32 v2, a34
		v_accvgpr_read_b32 v3, a35
		v_cvt_pk_bf16_f32 v69, v2, v3
		v_accvgpr_read_b32 v2, a36
		v_accvgpr_read_b32 v3, a37
		v_cvt_pk_bf16_f32 v72, v2, v3
		v_accvgpr_read_b32 v2, a38
		v_accvgpr_read_b32 v3, a39
		v_cvt_pk_bf16_f32 v73, v2, v3
		v_accvgpr_read_b32 v2, a40
		v_accvgpr_read_b32 v3, a41
		v_cvt_pk_bf16_f32 v76, v2, v3
		v_accvgpr_read_b32 v2, a42
		v_accvgpr_read_b32 v3, a43
		v_cvt_pk_bf16_f32 v77, v2, v3
		v_accvgpr_read_b32 v2, a44
		v_accvgpr_read_b32 v3, a45
		v_cvt_pk_bf16_f32 v66, v2, v3
		v_accvgpr_read_b32 v2, a46
		v_accvgpr_read_b32 v3, a47
		v_cvt_pk_bf16_f32 v67, v2, v3
		v_accvgpr_read_b32 v2, a48
		v_accvgpr_read_b32 v3, a49
		v_cvt_pk_bf16_f32 v70, v2, v3
		v_accvgpr_read_b32 v2, a50
		v_accvgpr_read_b32 v3, a51
		v_cvt_pk_bf16_f32 v71, v2, v3
		v_accvgpr_read_b32 v2, a52
		v_accvgpr_read_b32 v3, a53
		v_cvt_pk_bf16_f32 v74, v2, v3
		v_accvgpr_read_b32 v2, a54
		v_accvgpr_read_b32 v3, a55
		v_cvt_pk_bf16_f32 v75, v2, v3
		v_accvgpr_read_b32 v2, a56
		v_accvgpr_read_b32 v3, a57
		v_cvt_pk_bf16_f32 v78, v2, v3
		v_accvgpr_read_b32 v2, a58
		v_accvgpr_read_b32 v3, a59
		v_cvt_pk_bf16_f32 v79, v2, v3
		v_accvgpr_read_b32 v2, a60
		v_accvgpr_read_b32 v3, a61
		v_cvt_pk_bf16_f32 v100, v2, v3
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v3, a63
		v_cvt_pk_bf16_f32 v101, v2, v3
		v_accvgpr_read_b32 v2, a64
		v_accvgpr_read_b32 v3, a65
		v_cvt_pk_bf16_f32 v104, v2, v3
		v_accvgpr_read_b32 v2, a66
		v_accvgpr_read_b32 v3, a67
		v_cvt_pk_bf16_f32 v105, v2, v3
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v3, a69
		v_cvt_pk_bf16_f32 v172, v2, v3
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v3, a71
		v_cvt_pk_bf16_f32 v173, v2, v3
		v_accvgpr_read_b32 v2, a72
		v_accvgpr_read_b32 v3, a73
		v_cvt_pk_bf16_f32 v176, v2, v3
		v_accvgpr_read_b32 v2, a74
		v_accvgpr_read_b32 v3, a75
		v_cvt_pk_bf16_f32 v177, v2, v3
		v_accvgpr_read_b32 v2, a76
		v_accvgpr_read_b32 v3, a77
		v_cvt_pk_bf16_f32 v102, v2, v3
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v3, a79
		v_cvt_pk_bf16_f32 v103, v2, v3
		v_accvgpr_read_b32 v2, a80
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_bf16_f32 v106, v2, v3
		v_accvgpr_read_b32 v2, a82
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_bf16_f32 v107, v2, v3
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v3, a85
		v_cvt_pk_bf16_f32 v174, v2, v3
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v3, a87
		v_cvt_pk_bf16_f32 v175, v2, v3
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_bf16_f32 v178, v2, v3
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_bf16_f32 v179, v2, v3
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_bf16_f32 v180, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_bf16_f32 v181, v2, v3
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_bf16_f32 v184, v2, v3
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_bf16_f32 v185, v2, v3
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v3, a101
		v_cvt_pk_bf16_f32 v188, v2, v3
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v3, a103
		v_cvt_pk_bf16_f32 v189, v2, v3
		v_accvgpr_read_b32 v2, a104
		v_accvgpr_read_b32 v3, a105
		v_cvt_pk_bf16_f32 v192, v2, v3
		v_accvgpr_read_b32 v2, a106
		v_accvgpr_read_b32 v3, a107
		v_cvt_pk_bf16_f32 v193, v2, v3
		v_accvgpr_read_b32 v2, a108
		v_accvgpr_read_b32 v3, a109
		v_cvt_pk_bf16_f32 v182, v2, v3
		v_accvgpr_read_b32 v2, a110
		v_accvgpr_read_b32 v3, a111
		v_cvt_pk_bf16_f32 v183, v2, v3
		v_accvgpr_read_b32 v2, a112
		v_accvgpr_read_b32 v3, a113
		v_cvt_pk_bf16_f32 v186, v2, v3
		v_accvgpr_read_b32 v2, a114
		v_accvgpr_read_b32 v3, a115
		v_cvt_pk_bf16_f32 v187, v2, v3
		v_accvgpr_read_b32 v2, a116
		v_accvgpr_read_b32 v3, a117
		v_cvt_pk_bf16_f32 v190, v2, v3
		v_accvgpr_read_b32 v2, a118
		v_accvgpr_read_b32 v3, a119
		v_cvt_pk_bf16_f32 v191, v2, v3
		v_accvgpr_read_b32 v2, a120
		v_accvgpr_read_b32 v3, a121
		v_cvt_pk_bf16_f32 v194, v2, v3
		v_accvgpr_read_b32 v2, a122
		v_accvgpr_read_b32 v3, a123
		v_cvt_pk_bf16_f32 v195, v2, v3
		v_add_u32_e32 v2, 0x20000, v26
		ds_write_b128 v2, v[8:11] offset:3072
		ds_write_b128 v2, v[4:7] offset:7168
		ds_write_b128 v2, v[12:15] offset:11264
		ds_write_b128 v2, v[16:19] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v32, 9, v1
		v_lshl_add_u32 v1, v24, 13, v1
		v_lshl_add_u32 v1, v46, 12, v1
		v_lshl_add_u32 v1, v48, 10, v1
		ds_read_b128 v[4:7], v1 offset:3072
		ds_read_b128 v[8:11], v1 offset:3328
		ds_read_b128 v[12:15], v1 offset:5120
		ds_read_b128 v[16:19], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[64:67] offset:3072
		ds_write_b128 v2, v[68:71] offset:7168
		ds_write_b128 v2, v[72:75] offset:11264
		ds_write_b128 v2, v[76:79] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v1 offset:3072
		ds_read_b128 v[68:71], v1 offset:3328
		ds_read_b128 v[72:75], v1 offset:5120
		ds_read_b128 v[76:79], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[100:103] offset:3072
		ds_write_b128 v2, v[104:107] offset:7168
		ds_write_b128 v2, v[172:175] offset:11264
		ds_write_b128 v2, v[176:179] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[100:103], v1 offset:3072
		ds_read_b128 v[104:107], v1 offset:3328
		ds_read_b128 v[172:175], v1 offset:5120
		ds_read_b128 v[176:179], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[180:183] offset:3072
		ds_write_b128 v2, v[184:187] offset:7168
		ds_write_b128 v2, v[188:191] offset:11264
		ds_write_b128 v2, v[192:195] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[180:183], v1 offset:3072
		ds_read_b128 v[184:187], v1 offset:3328
		ds_read_b128 v[188:191], v1 offset:5120
		ds_read_b128 v[192:195], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s44, s6
		s_mov_b32 s45, s7
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_and_b32 s6, s2, s42
		s_and_b32 s7, s3, s43
		v_mov_b32_e32 v196, v4
		v_mov_b32_e32 v197, v5
		v_mov_b32_e32 v198, v8
		v_mov_b32_e32 v199, v9
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s12, s0, s1
		s_mul_i32 s20, s21, s17
		s_lshl_b32 s20, s20, 9
		s_add_i32 s12, s12, s20
		v_mul_lo_u32 v3, s17, v29
		v_lshlrev_b32_e32 v3, 4, v3
		v_mul_lo_u32 v4, s17, v35
		v_lshlrev_b32_e32 v4, 3, v4
		v_add3_u32 v5, s12, v3, v4
		v_mul_lo_u32 v8, s17, v38
		v_lshlrev_b32_e32 v8, 2, v8
		v_mul_lo_u32 v9, s17, v41
		v_lshlrev_b32_e32 v9, 1, v9
		v_add3_u32 v5, v5, v8, v9
		v_lshlrev_b32_e32 v20, 4, v32
		v_lshlrev_b32_e32 v21, 7, v24
		v_add3_u32 v5, v5, v20, v21
		v_lshlrev_b32_e32 v22, 6, v46
		v_lshlrev_b32_e32 v24, 5, v48
		v_add3_u32 v5, v5, v22, v24
		v_mov_b32_e32 v26, 0x80000000
		v_cndmask_b32_e64 v5, v26, v5, s[6:7]
		buffer_store_dwordx4 v[196:199], v5, s[44:47], 0 offen
		s_and_b32 s6, s4, s42
		s_and_b32 s7, s5, s43
		v_mov_b32_e32 v44, v12
		v_mov_b32_e32 v45, v13
		v_mov_b32_e32 v46, v16
		v_mov_b32_e32 v47, v17
		v_lshlrev_b32_e32 v5, 3, v29
		v_lshlrev_b32_e32 v12, 2, v35
		v_add_u32_e32 v13, 16, v41
		v_xor_b32_e32 v13, v13, v204
		v_xor_b32_e32 v13, v12, v13
		v_xor_b32_e32 v13, v5, v13
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v16, v13, 1, s12
		v_add3_u32 v16, v16, v20, v21
		v_add3_u32 v16, v16, v22, v24
		v_cndmask_b32_e64 v16, v26, v16, s[6:7]
		buffer_store_dwordx4 v[44:47], v16, s[44:47], 0 offen
		s_and_b32 s6, s8, s42
		s_and_b32 s7, s9, s43
		v_mov_b32_e32 v44, v6
		v_mov_b32_e32 v45, v7
		v_mov_b32_e32 v46, v10
		v_mov_b32_e32 v47, v11
		v_add_u32_e32 v6, 32, v41
		v_xor_b32_e32 v6, v6, v204
		v_xor_b32_e32 v6, v12, v6
		v_xor_b32_e32 v6, v5, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshl_add_u32 v7, v6, 1, s12
		v_add3_u32 v7, v7, v20, v21
		v_add3_u32 v7, v7, v22, v24
		v_cndmask_b32_e64 v7, v26, v7, s[6:7]
		buffer_store_dwordx4 v[44:47], v7, s[44:47], 0 offen
		s_and_b32 s6, s10, s42
		s_and_b32 s7, s11, s43
		v_mov_b32_e32 v44, v14
		v_mov_b32_e32 v45, v15
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
		v_add_u32_e32 v7, 48, v41
		v_xor_b32_e32 v7, v7, v204
		v_xor_b32_e32 v7, v12, v7
		v_xor_b32_e32 v7, v5, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshl_add_u32 v10, v7, 1, s12
		v_add3_u32 v10, v10, v20, v21
		v_add3_u32 v10, v10, v22, v24
		v_cndmask_b32_e64 v10, v26, v10, s[6:7]
		buffer_store_dwordx4 v[44:47], v10, s[44:47], 0 offen
		s_and_b32 s6, s14, s42
		s_and_b32 s7, s15, s43
		v_mov_b32_e32 v16, v64
		v_mov_b32_e32 v17, v65
		v_mov_b32_e32 v18, v68
		v_mov_b32_e32 v19, v69
		v_add_u32_e32 v10, 64, v41
		v_xor_b32_e32 v10, v10, v204
		v_xor_b32_e32 v10, v12, v10
		v_xor_b32_e32 v10, v5, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v11, v10, 1, s12
		v_add3_u32 v11, v11, v20, v21
		v_add3_u32 v11, v11, v22, v24
		v_cndmask_b32_e64 v11, v26, v11, s[6:7]
		buffer_store_dwordx4 v[16:19], v11, s[44:47], 0 offen
		s_and_b32 s6, s18, s42
		s_and_b32 s7, s19, s43
		v_mov_b32_e32 v16, v72
		v_mov_b32_e32 v17, v73
		v_mov_b32_e32 v18, v76
		v_mov_b32_e32 v19, v77
		v_add_u32_e32 v11, 0x50, v41
		v_xor_b32_e32 v11, v11, v204
		v_xor_b32_e32 v11, v12, v11
		v_xor_b32_e32 v11, v5, v11
		v_mul_lo_u32 v11, s17, v11
		v_lshl_add_u32 v14, v11, 1, s12
		v_add3_u32 v14, v14, v20, v21
		v_add3_u32 v14, v14, v22, v24
		v_cndmask_b32_e64 v14, v26, v14, s[6:7]
		buffer_store_dwordx4 v[16:19], v14, s[44:47], 0 offen
		s_and_b32 s6, s22, s42
		s_and_b32 s7, s23, s43
		v_mov_b32_e32 v16, v66
		v_mov_b32_e32 v17, v67
		v_mov_b32_e32 v18, v70
		v_mov_b32_e32 v19, v71
		v_add_u32_e32 v14, 0x60, v41
		v_xor_b32_e32 v14, v14, v204
		v_xor_b32_e32 v14, v12, v14
		v_xor_b32_e32 v14, v5, v14
		v_mul_lo_u32 v14, s17, v14
		v_lshl_add_u32 v15, v14, 1, s12
		v_add3_u32 v15, v15, v20, v21
		v_add3_u32 v15, v15, v22, v24
		v_cndmask_b32_e64 v15, v26, v15, s[6:7]
		buffer_store_dwordx4 v[16:19], v15, s[44:47], 0 offen
		s_and_b32 s6, s24, s42
		s_and_b32 s7, s25, s43
		v_mov_b32_e32 v16, v74
		v_mov_b32_e32 v17, v75
		v_mov_b32_e32 v18, v78
		v_mov_b32_e32 v19, v79
		v_add_u32_e32 v15, 0x70, v41
		v_xor_b32_e32 v15, v15, v204
		v_xor_b32_e32 v15, v12, v15
		v_xor_b32_e32 v15, v5, v15
		v_mul_lo_u32 v15, s17, v15
		v_lshl_add_u32 v29, v15, 1, s12
		v_add3_u32 v29, v29, v20, v21
		v_add3_u32 v29, v29, v22, v24
		v_cndmask_b32_e64 v29, v26, v29, s[6:7]
		buffer_store_dwordx4 v[16:19], v29, s[44:47], 0 offen
		s_and_b32 s6, s26, s42
		s_and_b32 s7, s27, s43
		v_mov_b32_e32 v16, v100
		v_mov_b32_e32 v17, v101
		v_mov_b32_e32 v18, v104
		v_mov_b32_e32 v19, v105
		v_add_u32_e32 v29, 0x80, v41
		v_xor_b32_e32 v29, v29, v204
		v_xor_b32_e32 v29, v12, v29
		v_xor_b32_e32 v29, v5, v29
		v_mul_lo_u32 v29, s17, v29
		v_lshl_add_u32 v32, v29, 1, s12
		v_add3_u32 v32, v32, v20, v21
		v_add3_u32 v32, v32, v22, v24
		v_cndmask_b32_e64 v32, v26, v32, s[6:7]
		buffer_store_dwordx4 v[16:19], v32, s[44:47], 0 offen
		s_and_b32 s6, s28, s42
		s_and_b32 s7, s29, s43
		v_mov_b32_e32 v16, v172
		v_mov_b32_e32 v17, v173
		v_mov_b32_e32 v18, v176
		v_mov_b32_e32 v19, v177
		v_add_u32_e32 v32, 0x90, v41
		v_xor_b32_e32 v32, v32, v204
		v_xor_b32_e32 v32, v12, v32
		v_xor_b32_e32 v32, v5, v32
		v_mul_lo_u32 v32, s17, v32
		v_lshl_add_u32 v35, v32, 1, s12
		v_add3_u32 v35, v35, v20, v21
		v_add3_u32 v35, v35, v22, v24
		v_cndmask_b32_e64 v35, v26, v35, s[6:7]
		buffer_store_dwordx4 v[16:19], v35, s[44:47], 0 offen
		s_and_b32 s6, s30, s42
		s_and_b32 s7, s31, s43
		v_mov_b32_e32 v16, v102
		v_mov_b32_e32 v17, v103
		v_mov_b32_e32 v18, v106
		v_mov_b32_e32 v19, v107
		v_add_u32_e32 v35, 0xa0, v41
		v_xor_b32_e32 v35, v35, v204
		v_xor_b32_e32 v35, v12, v35
		v_xor_b32_e32 v35, v5, v35
		v_mul_lo_u32 v35, s17, v35
		v_lshl_add_u32 v38, v35, 1, s12
		v_add3_u32 v38, v38, v20, v21
		v_add3_u32 v38, v38, v22, v24
		v_cndmask_b32_e64 v38, v26, v38, s[6:7]
		buffer_store_dwordx4 v[16:19], v38, s[44:47], 0 offen
		s_and_b32 s6, s32, s42
		s_and_b32 s7, s33, s43
		v_mov_b32_e32 v16, v174
		v_mov_b32_e32 v17, v175
		v_mov_b32_e32 v18, v178
		v_mov_b32_e32 v19, v179
		v_add_u32_e32 v38, 0xb0, v41
		v_xor_b32_e32 v38, v38, v204
		v_xor_b32_e32 v38, v12, v38
		v_xor_b32_e32 v38, v5, v38
		v_mul_lo_u32 v38, s17, v38
		v_lshl_add_u32 v42, v38, 1, s12
		v_add3_u32 v42, v42, v20, v21
		v_add3_u32 v42, v42, v22, v24
		v_cndmask_b32_e64 v42, v26, v42, s[6:7]
		buffer_store_dwordx4 v[16:19], v42, s[44:47], 0 offen
		s_and_b32 s6, s34, s42
		s_and_b32 s7, s35, s43
		v_mov_b32_e32 v16, v180
		v_mov_b32_e32 v17, v181
		v_mov_b32_e32 v18, v184
		v_mov_b32_e32 v19, v185
		v_add_u32_e32 v42, 0xc0, v41
		v_xor_b32_e32 v42, v42, v204
		v_xor_b32_e32 v42, v12, v42
		v_xor_b32_e32 v42, v5, v42
		v_mul_lo_u32 v42, s17, v42
		v_lshl_add_u32 v43, v42, 1, s12
		v_add3_u32 v43, v43, v20, v21
		v_add3_u32 v43, v43, v22, v24
		v_cndmask_b32_e64 v43, v26, v43, s[6:7]
		buffer_store_dwordx4 v[16:19], v43, s[44:47], 0 offen
		s_and_b32 s6, s36, s42
		s_and_b32 s7, s37, s43
		v_mov_b32_e32 v16, v188
		v_mov_b32_e32 v17, v189
		v_mov_b32_e32 v18, v192
		v_mov_b32_e32 v19, v193
		v_add_u32_e32 v43, 0xd0, v41
		v_xor_b32_e32 v43, v43, v204
		v_xor_b32_e32 v43, v12, v43
		v_xor_b32_e32 v43, v5, v43
		v_mul_lo_u32 v43, s17, v43
		v_lshl_add_u32 v44, v43, 1, s12
		v_add3_u32 v44, v44, v20, v21
		v_add3_u32 v44, v44, v22, v24
		v_cndmask_b32_e64 v44, v26, v44, s[6:7]
		buffer_store_dwordx4 v[16:19], v44, s[44:47], 0 offen
		s_and_b32 s6, s38, s42
		s_and_b32 s7, s39, s43
		v_mov_b32_e32 v16, v182
		v_mov_b32_e32 v17, v183
		v_mov_b32_e32 v18, v186
		v_mov_b32_e32 v19, v187
		v_add_u32_e32 v44, 0xe0, v41
		v_xor_b32_e32 v44, v44, v204
		v_xor_b32_e32 v44, v12, v44
		v_xor_b32_e32 v44, v5, v44
		v_mul_lo_u32 v44, s17, v44
		v_lshl_add_u32 v45, v44, 1, s12
		v_add3_u32 v45, v45, v20, v21
		v_add3_u32 v45, v45, v22, v24
		v_cndmask_b32_e64 v45, v26, v45, s[6:7]
		buffer_store_dwordx4 v[16:19], v45, s[44:47], 0 offen
		s_and_b32 s6, s40, s42
		s_and_b32 s7, s41, s43
		v_mov_b32_e32 v16, v190
		v_mov_b32_e32 v17, v191
		v_mov_b32_e32 v18, v194
		v_mov_b32_e32 v19, v195
		v_add_u32_e32 v41, 0xf0, v41
		v_xor_b32_e32 v41, v41, v204
		v_xor_b32_e32 v12, v12, v41
		v_xor_b32_e32 v5, v5, v12
		v_mul_lo_u32 v5, s17, v5
		v_lshl_add_u32 v12, v5, 1, s12
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v24
		v_cndmask_b32_e64 v12, v26, v12, s[6:7]
		buffer_store_dwordx4 v[16:19], v12, s[44:47], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v12, 0xff, v31
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v0, v0, v12
		v_and_b32_e32 v12, 0xff, v33
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v16, 0xff, v34
		v_lshlrev_b32_e32 v16, 24, v16
		v_or3_b32 v0, v0, v12, v16
		v_and_b32_e32 v12, 0xff, v36
		v_and_b32_e32 v16, 0xff, v37
		v_lshlrev_b32_e32 v16, 8, v16
		v_or_b32_e32 v12, v12, v16
		v_and_b32_e32 v16, 0xff, v39
		v_lshlrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v17, 0xff, v40
		v_lshlrev_b32_e32 v17, 24, v17
		v_or3_b32 v12, v12, v16, v17
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[52:55], a[124:127], v0, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[84:87], v[56:59], a[124:127], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[88:91], v[52:55], a[128:131], v0, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[56:59], a[128:131], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[52:55], a[132:135], v12, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[160:163], v[56:59], a[132:135], v12, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[164:167], v[52:55], a[136:139], v12, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[168:171], v[56:59], a[136:139], v12, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[60:63], a[140:143], v0, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[84:87], v[108:111], a[140:143], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[88:91], v[60:63], a[144:147], v0, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[108:111], a[144:147], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[60:63], a[148:151], v12, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[160:163], v[108:111], a[148:151], v12, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[164:167], v[60:63], a[152:155], v12, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[168:171], v[108:111], a[152:155], v12, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], v[112:115], a[156:159], v0, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[116:119], a[156:159], v0, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[88:91], v[112:115], a[160:163], v0, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[116:119], a[160:163], v0, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[112:115], a[164:167], v12, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[160:163], v[116:119], a[164:167], v12, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[164:167], v[112:115], a[168:171], v12, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[168:171], v[116:119], a[168:171], v12, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[120:123], a[172:175], v0, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[124:127], a[172:175], v0, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[88:91], v[120:123], a[176:179], v0, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[92:95], v[124:127], a[176:179], v0, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[120:123], a[180:183], v12, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[160:163], v[124:127], a[180:183], v12, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[164:167], v[120:123], a[184:187], v12, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[168:171], v[124:127], a[184:187], v12, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[80:83], v[128:131], a[188:191], v0, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[84:87], v[132:135], a[188:191], v0, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[88:91], v[128:131], a[192:195], v0, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[92:95], v[132:135], a[192:195], v0, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[96:99], v[128:131], a[196:199], v12, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[160:163], v[132:135], a[196:199], v12, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[164:167], v[128:131], a[200:203], v12, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[168:171], v[132:135], a[200:203], v12, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[80:83], v[136:139], a[204:207], v0, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[84:87], v[140:143], a[204:207], v0, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[88:91], v[136:139], a[208:211], v0, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[92:95], v[140:143], a[208:211], v0, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[96:99], v[136:139], a[212:215], v12, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[160:163], v[140:143], a[212:215], v12, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[164:167], v[136:139], a[216:219], v12, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[168:171], v[140:143], a[216:219], v12, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[80:83], v[144:147], a[220:223], v0, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[84:87], v[148:151], a[220:223], v0, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[88:91], v[144:147], a[224:227], v0, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[92:95], v[148:151], a[224:227], v0, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[96:99], v[144:147], a[228:231], v12, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[160:163], v[148:151], a[228:231], v12, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[164:167], v[144:147], a[232:235], v12, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[168:171], v[148:151], a[232:235], v12, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[80:83], v[152:155], a[236:239], v0, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[84:87], v[156:159], a[236:239], v0, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[88:91], v[152:155], a[240:243], v0, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[92:95], v[156:159], a[240:243], v0, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[96:99], v[152:155], a[244:247], v12, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[160:163], v[156:159], a[244:247], v12, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[164:167], v[152:155], v[252:255], v12, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[252:255], v[168:171], v[156:159], v[252:255], v12, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s6, s16, 0x80
		v_add_u32_e32 v0, s6, v23
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[6:7], vcc
		v_accvgpr_read_b32 v0, a124
		v_accvgpr_read_b32 v12, a125
		v_cvt_pk_bf16_f32 v16, v0, v12
		v_accvgpr_read_b32 v0, a126
		v_accvgpr_read_b32 v12, a127
		v_cvt_pk_bf16_f32 v17, v0, v12
		v_accvgpr_read_b32 v0, a128
		v_accvgpr_read_b32 v12, a129
		v_cvt_pk_bf16_f32 v48, v0, v12
		v_accvgpr_read_b32 v0, a130
		v_accvgpr_read_b32 v12, a131
		v_cvt_pk_bf16_f32 v49, v0, v12
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v12, a133
		v_cvt_pk_bf16_f32 v52, v0, v12
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v12, a135
		v_cvt_pk_bf16_f32 v53, v0, v12
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v12, a137
		v_cvt_pk_bf16_f32 v56, v0, v12
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v12, a139
		v_cvt_pk_bf16_f32 v57, v0, v12
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v12, a141
		v_cvt_pk_bf16_f32 v18, v0, v12
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v12, a143
		v_cvt_pk_bf16_f32 v19, v0, v12
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v12, a145
		v_cvt_pk_bf16_f32 v50, v0, v12
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v12, a147
		v_cvt_pk_bf16_f32 v51, v0, v12
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v12, a149
		v_cvt_pk_bf16_f32 v54, v0, v12
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v12, a151
		v_cvt_pk_bf16_f32 v55, v0, v12
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v12, a153
		v_cvt_pk_bf16_f32 v58, v0, v12
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v12, a155
		v_cvt_pk_bf16_f32 v59, v0, v12
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v12, a157
		v_cvt_pk_bf16_f32 v60, v0, v12
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v12, a159
		v_cvt_pk_bf16_f32 v61, v0, v12
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v12, a161
		v_cvt_pk_bf16_f32 v64, v0, v12
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v12, a163
		v_cvt_pk_bf16_f32 v65, v0, v12
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v12, a165
		v_cvt_pk_bf16_f32 v68, v0, v12
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v12, a167
		v_cvt_pk_bf16_f32 v69, v0, v12
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v12, a169
		v_cvt_pk_bf16_f32 v72, v0, v12
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v12, a171
		v_cvt_pk_bf16_f32 v73, v0, v12
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v12, a173
		v_cvt_pk_bf16_f32 v62, v0, v12
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v12, a175
		v_cvt_pk_bf16_f32 v63, v0, v12
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v12, a177
		v_cvt_pk_bf16_f32 v66, v0, v12
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v12, a179
		v_cvt_pk_bf16_f32 v67, v0, v12
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v12, a181
		v_cvt_pk_bf16_f32 v70, v0, v12
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v12, a183
		v_cvt_pk_bf16_f32 v71, v0, v12
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v12, a185
		v_cvt_pk_bf16_f32 v74, v0, v12
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v12, a187
		v_cvt_pk_bf16_f32 v75, v0, v12
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v12, a189
		v_cvt_pk_bf16_f32 v76, v0, v12
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v12, a191
		v_cvt_pk_bf16_f32 v77, v0, v12
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v12, a193
		v_cvt_pk_bf16_f32 v80, v0, v12
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v12, a195
		v_cvt_pk_bf16_f32 v81, v0, v12
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v12, a197
		v_cvt_pk_bf16_f32 v84, v0, v12
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v12, a199
		v_cvt_pk_bf16_f32 v85, v0, v12
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v12, a201
		v_cvt_pk_bf16_f32 v88, v0, v12
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v12, a203
		v_cvt_pk_bf16_f32 v89, v0, v12
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v12, a205
		v_cvt_pk_bf16_f32 v78, v0, v12
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v12, a207
		v_cvt_pk_bf16_f32 v79, v0, v12
		v_accvgpr_read_b32 v0, a208
		v_accvgpr_read_b32 v12, a209
		v_cvt_pk_bf16_f32 v82, v0, v12
		v_accvgpr_read_b32 v0, a210
		v_accvgpr_read_b32 v12, a211
		v_cvt_pk_bf16_f32 v83, v0, v12
		v_accvgpr_read_b32 v0, a212
		v_accvgpr_read_b32 v12, a213
		v_cvt_pk_bf16_f32 v86, v0, v12
		v_accvgpr_read_b32 v0, a214
		v_accvgpr_read_b32 v12, a215
		v_cvt_pk_bf16_f32 v87, v0, v12
		v_accvgpr_read_b32 v0, a216
		v_accvgpr_read_b32 v12, a217
		v_cvt_pk_bf16_f32 v90, v0, v12
		v_accvgpr_read_b32 v0, a218
		v_accvgpr_read_b32 v12, a219
		v_cvt_pk_bf16_f32 v91, v0, v12
		v_accvgpr_read_b32 v0, a220
		v_accvgpr_read_b32 v12, a221
		v_cvt_pk_bf16_f32 v92, v0, v12
		v_accvgpr_read_b32 v0, a222
		v_accvgpr_read_b32 v12, a223
		v_cvt_pk_bf16_f32 v93, v0, v12
		v_accvgpr_read_b32 v0, a224
		v_accvgpr_read_b32 v12, a225
		v_cvt_pk_bf16_f32 v96, v0, v12
		v_accvgpr_read_b32 v0, a226
		v_accvgpr_read_b32 v12, a227
		v_cvt_pk_bf16_f32 v97, v0, v12
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v12, a229
		v_cvt_pk_bf16_f32 v100, v0, v12
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v12, a231
		v_cvt_pk_bf16_f32 v101, v0, v12
		v_accvgpr_read_b32 v0, a232
		v_accvgpr_read_b32 v12, a233
		v_cvt_pk_bf16_f32 v104, v0, v12
		v_accvgpr_read_b32 v0, a234
		v_accvgpr_read_b32 v12, a235
		v_cvt_pk_bf16_f32 v105, v0, v12
		v_accvgpr_read_b32 v0, a236
		v_accvgpr_read_b32 v12, a237
		v_cvt_pk_bf16_f32 v94, v0, v12
		v_accvgpr_read_b32 v0, a238
		v_accvgpr_read_b32 v12, a239
		v_cvt_pk_bf16_f32 v95, v0, v12
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v12, a241
		v_cvt_pk_bf16_f32 v98, v0, v12
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v12, a243
		v_cvt_pk_bf16_f32 v99, v0, v12
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v12, a245
		v_cvt_pk_bf16_f32 v102, v0, v12
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v12, a247
		v_cvt_pk_bf16_f32 v103, v0, v12
		v_cvt_pk_bf16_f32 v106, v252, v253
		v_cvt_pk_bf16_f32 v107, v254, v255
		ds_write_b128 v2, v[16:19] offset:3072
		ds_write_b128 v2, v[48:51] offset:7168
		ds_write_b128 v2, v[52:55] offset:11264
		ds_write_b128 v2, v[56:59] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:3072
		ds_read_b128 v[48:51], v1 offset:3328
		ds_read_b128 v[52:55], v1 offset:5120
		ds_read_b128 v[56:59], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[60:63] offset:3072
		ds_write_b128 v2, v[64:67] offset:7168
		ds_write_b128 v2, v[68:71] offset:11264
		ds_write_b128 v2, v[72:75] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v1 offset:3072
		ds_read_b128 v[64:67], v1 offset:3328
		ds_read_b128 v[68:71], v1 offset:5120
		ds_read_b128 v[72:75], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[76:79] offset:3072
		ds_write_b128 v2, v[80:83] offset:7168
		ds_write_b128 v2, v[84:87] offset:11264
		ds_write_b128 v2, v[88:91] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v1 offset:3072
		ds_read_b128 v[80:83], v1 offset:3328
		ds_read_b128 v[84:87], v1 offset:5120
		ds_read_b128 v[88:91], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[92:95] offset:3072
		ds_write_b128 v2, v[96:99] offset:7168
		ds_write_b128 v2, v[100:103] offset:11264
		ds_write_b128 v2, v[104:107] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1 offset:3072
		ds_read_b128 v[96:99], v1 offset:3328
		ds_read_b128 v[100:103], v1 offset:5120
		ds_read_b128 v[104:107], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s12, s2, s6
		s_and_b32 s13, s3, s7
		v_mov_b32_e32 v108, v16
		v_mov_b32_e32 v109, v17
		v_mov_b32_e32 v110, v48
		v_mov_b32_e32 v111, v49
		s_add_i32 s0, s0, 0x100
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v0, s0, v3, v4
		v_add3_u32 v0, v0, v8, v9
		v_add3_u32 v0, v0, v20, v21
		v_add3_u32 v0, v0, v22, v24
		v_cndmask_b32_e64 v0, v26, v0, s[12:13]
		buffer_store_dwordx4 v[108:111], v0, s[44:47], 0 offen
		s_and_b32 s2, s4, s6
		s_and_b32 s3, s5, s7
		v_mov_b32_e32 v0, v52
		v_mov_b32_e32 v1, v53
		v_mov_b32_e32 v2, v56
		v_mov_b32_e32 v3, v57
		v_lshl_add_u32 v4, v13, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s8, s6
		s_and_b32 s3, s9, s7
		v_mov_b32_e32 v0, v18
		v_mov_b32_e32 v1, v19
		v_mov_b32_e32 v2, v50
		v_mov_b32_e32 v3, v51
		v_lshl_add_u32 v4, v6, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s10, s6
		s_and_b32 s3, s11, s7
		v_mov_b32_e32 v0, v54
		v_mov_b32_e32 v1, v55
		v_mov_b32_e32 v2, v58
		v_mov_b32_e32 v3, v59
		v_lshl_add_u32 v4, v7, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s14, s6
		s_and_b32 s3, s15, s7
		v_mov_b32_e32 v0, v60
		v_mov_b32_e32 v1, v61
		v_mov_b32_e32 v2, v64
		v_mov_b32_e32 v3, v65
		v_lshl_add_u32 v4, v10, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s18, s6
		s_and_b32 s3, s19, s7
		v_mov_b32_e32 v0, v68
		v_mov_b32_e32 v1, v69
		v_mov_b32_e32 v2, v72
		v_mov_b32_e32 v3, v73
		v_lshl_add_u32 v4, v11, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s22, s6
		s_and_b32 s3, s23, s7
		v_mov_b32_e32 v0, v62
		v_mov_b32_e32 v1, v63
		v_mov_b32_e32 v2, v66
		v_mov_b32_e32 v3, v67
		v_lshl_add_u32 v4, v14, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s24, s6
		s_and_b32 s3, s25, s7
		v_mov_b32_e32 v0, v70
		v_mov_b32_e32 v1, v71
		v_mov_b32_e32 v2, v74
		v_mov_b32_e32 v3, v75
		v_lshl_add_u32 v4, v15, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s26, s6
		s_and_b32 s3, s27, s7
		v_mov_b32_e32 v0, v76
		v_mov_b32_e32 v1, v77
		v_mov_b32_e32 v2, v80
		v_mov_b32_e32 v3, v81
		v_lshl_add_u32 v4, v29, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s28, s6
		s_and_b32 s3, s29, s7
		v_mov_b32_e32 v0, v84
		v_mov_b32_e32 v1, v85
		v_mov_b32_e32 v2, v88
		v_mov_b32_e32 v3, v89
		v_lshl_add_u32 v4, v32, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s30, s6
		s_and_b32 s3, s31, s7
		v_mov_b32_e32 v0, v78
		v_mov_b32_e32 v1, v79
		v_mov_b32_e32 v2, v82
		v_mov_b32_e32 v3, v83
		v_lshl_add_u32 v4, v35, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s32, s6
		s_and_b32 s3, s33, s7
		v_mov_b32_e32 v0, v86
		v_mov_b32_e32 v1, v87
		v_mov_b32_e32 v2, v90
		v_mov_b32_e32 v3, v91
		v_lshl_add_u32 v4, v38, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s34, s6
		s_and_b32 s3, s35, s7
		v_mov_b32_e32 v0, v92
		v_mov_b32_e32 v1, v93
		v_mov_b32_e32 v2, v96
		v_mov_b32_e32 v3, v97
		v_lshl_add_u32 v4, v42, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s36, s6
		s_and_b32 s3, s37, s7
		v_mov_b32_e32 v0, v100
		v_mov_b32_e32 v1, v101
		v_mov_b32_e32 v2, v104
		v_mov_b32_e32 v3, v105
		v_lshl_add_u32 v4, v43, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s38, s6
		s_and_b32 s3, s39, s7
		v_mov_b32_e32 v0, v94
		v_mov_b32_e32 v1, v95
		v_mov_b32_e32 v2, v98
		v_mov_b32_e32 v3, v99
		v_lshl_add_u32 v4, v44, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s40, s6
		s_and_b32 s3, s41, s7
		v_mov_b32_e32 v0, v102
		v_mov_b32_e32 v1, v103
		v_mov_b32_e32 v2, v106
		v_mov_b32_e32 v3, v107
		v_lshl_add_u32 v4, v5, 1, s0
		v_add3_u32 v4, v4, v20, v21
		v_add3_u32 v4, v4, v22, v24
		v_cndmask_b32_e64 v4, v26, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
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
		.amdhsa_next_free_vgpr 504
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
	.set .L_a4w4_kernel.num_agpr, 248
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
    .vgpr_count:     504
    .agpr_count:     248
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
