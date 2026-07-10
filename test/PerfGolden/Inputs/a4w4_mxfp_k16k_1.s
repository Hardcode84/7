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
		v_mov_b32_e32 v4, 0
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
		v_add_u32_e32 v5, 0x60, v2
		v_add_u32_e32 v6, 0x70, v2
		v_add_u32_e32 v7, 0x80, v2
		v_add_u32_e32 v8, 0x90, v2
		v_add_u32_e32 v9, 0xa0, v2
		v_add_u32_e32 v10, 0xb0, v2
		v_add_u32_e32 v11, 0xc0, v2
		v_add_u32_e32 v12, 0xd0, v2
		v_add_u32_e32 v13, 0xe0, v2
		v_add_u32_e32 v14, 0xf0, v2
		v_and_b32_e32 v15, 15, v0
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v15
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
		v_lshrrev_b32_e32 v15, 3, v0
		v_mul_lo_u32 v17, s14, v15
		v_lshlrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v19, 0x7f, v18
		v_add3_u32 v20, s5, v17, v19
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		v_add_u32_e32 v20, s16, v2
		s_lshl_b32 s8, s14, 5
		s_add_i32 s9, s8, s3
		s_add_i32 s9, s9, s4
		s_add_i32 m0, s2, 0x1000
		v_add3_u32 v21, s9, v17, v19
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		v_add3_u32 v21, 16, v2, s16
		s_lshl_b32 s10, s14, 6
		s_add_i32 s11, s10, s3
		s_add_i32 s11, s11, s4
		s_add_i32 m0, s2, 0x2000
		v_add3_u32 v22, s11, v17, v19
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		v_add3_u32 v22, 32, v2, s16
		s_mul_i32 s22, 0x60, s14
		s_add_i32 s23, s22, s3
		s_add_i32 s23, s23, s4
		s_add_i32 m0, s2, 0x3000
		v_add3_u32 v23, s23, v17, v19
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		v_add3_u32 v23, 48, v2, s16
		s_lshl_b32 s40, s14, 7
		s_add_i32 s41, s40, s3
		s_add_i32 s41, s41, s4
		s_add_i32 m0, s2, 0x4000
		v_add3_u32 v24, s41, v17, v19
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add3_u32 v2, 64, v2, s16
		s_mul_i32 s42, 0xa0, s14
		s_add_i32 s43, s42, s3
		s_add_i32 s43, s43, s4
		s_add_i32 m0, s2, 0x5000
		v_add3_u32 v24, s43, v17, v19
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s16, v3
		s_mul_i32 s44, 0xc0, s14
		s_add_i32 s45, s44, s3
		s_add_i32 s45, s45, s4
		s_add_i32 m0, s2, 0x6000
		v_add3_u32 v24, s45, v17, v19
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add_u32_e32 v24, s16, v5
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s46, s14, s3
		s_add_i32 s46, s46, s4
		s_add_i32 m0, s2, 0x7000
		v_add3_u32 v5, s46, v17, v19
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add_u32_e32 v25, s16, v6
		s_mul_i32 s47, s0, s15
		s_lshl_b32 s47, s47, 8
		v_mul_lo_u32 v26, s15, v15
		s_add_i32 m0, s2, 0x10000
		v_add3_u32 v5, s47, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_add_u32_e32 v27, s16, v7
		s_lshl_b32 s48, s15, 5
		s_add_i32 s49, s48, s47
		s_add_i32 m0, s2, 0x11000
		v_add3_u32 v5, s49, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_add_u32_e32 v8, s16, v8
		s_lshl_b32 s50, s15, 6
		s_add_i32 s51, s50, s47
		s_add_i32 m0, s2, 0x12000
		v_add3_u32 v5, s51, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_add_u32_e32 v9, s16, v9
		s_mul_i32 s52, 0x60, s15
		s_add_i32 s53, s52, s47
		s_add_i32 m0, s2, 0x13000
		v_add3_u32 v5, s53, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_add_u32_e32 v10, s16, v10
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s54, s1, s18
		s_lshl_b32 s54, s54, 10
		s_mul_i32 s55, s21, s18
		s_lshl_b32 s55, s55, 8
		s_add_i32 s56, s54, s55
		v_lshrrev_b32_e32 v28, 7, v0
		v_mul_lo_u32 v5, s18, v28
		v_lshlrev_b32_e32 v29, 7, v5
		v_and_b32_e32 v30, 1, v0
		v_mul_lo_u32 v31, s18, v30
		v_add3_u32 v6, s56, v29, v31
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v32, 1, v7
		v_mul_lo_u32 v7, s18, v32
		v_lshlrev_b32_e32 v33, 6, v7
		v_lshrrev_b32_e32 v34, 5, v0
		v_and_b32_e32 v34, 1, v34
		v_mul_lo_u32 v35, s18, v34
		v_lshlrev_b32_e32 v36, 5, v35
		v_add3_u32 v6, v6, v33, v36
		v_and_b32_e32 v37, 1, v1
		v_mul_lo_u32 v38, s18, v37
		v_lshlrev_b32_e32 v39, 4, v38
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v40, s18, v15
		v_lshlrev_b32_e32 v41, 3, v40
		v_add3_u32 v6, v6, v39, v41
		v_lshrrev_b32_e32 v42, 2, v0
		v_and_b32_e32 v42, 1, v42
		v_mul_lo_u32 v43, s18, v42
		v_lshlrev_b32_e32 v43, 2, v43
		v_lshrrev_b32_e32 v44, 1, v0
		v_and_b32_e32 v44, 1, v44
		v_mul_lo_u32 v45, s18, v44
		v_lshlrev_b32_e32 v45, 1, v45
		v_add3_u32 v6, v6, v43, v45
		buffer_load_dwordx2 v[46:47], v6, s[32:35], 0 offen
		s_mul_i32 s57, s0, s19
		s_lshl_b32 s57, s57, 8
		v_mul_lo_u32 v6, s19, v28
		v_lshlrev_b32_e32 v48, 6, v6
		v_mul_lo_u32 v49, s19, v32
		v_lshlrev_b32_e32 v50, 5, v49
		v_add3_u32 v51, s57, v48, v50
		v_mul_lo_u32 v52, s19, v34
		v_lshlrev_b32_e32 v53, 4, v52
		v_mul_lo_u32 v54, s19, v37
		v_lshlrev_b32_e32 v55, 3, v54
		v_add3_u32 v51, v51, v53, v55
		v_mul_lo_u32 v56, s19, v15
		v_lshlrev_b32_e32 v57, 2, v56
		v_mul_lo_u32 v58, s19, v42
		v_lshlrev_b32_e32 v58, 1, v58
		v_add3_u32 v51, v51, v57, v58
		v_mul_lo_u32 v59, s19, v44
		v_lshlrev_b32_e32 v60, 2, v30
		v_add3_u32 v51, v51, v59, v60
		buffer_load_dword v61, v51, s[36:39], 0 offen
		s_lshl_b32 s58, s15, 7
		s_add_i32 s59, s58, s47
		s_add_i32 m0, s2, 0x18000
		v_add3_u32 v51, s59, v26, v19
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		v_add_u32_e32 v11, s16, v11
		s_mul_i32 s60, 0xa0, s15
		s_add_i32 s61, s60, s47
		s_add_i32 m0, s2, 0x19000
		v_add3_u32 v51, s61, v26, v19
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		v_add_u32_e32 v12, s16, v12
		s_mul_i32 s62, 0xc0, s15
		s_add_i32 s63, s62, s47
		s_add_i32 m0, s2, 0x1a000
		v_add3_u32 v51, s63, v26, v19
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		v_add_u32_e32 v13, s16, v13
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s64, s15, s47
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v51, s64, v26, v19
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		v_add_u32_e32 v14, s16, v14
		s_lshl_b32 s16, s19, 7
		s_add_i32 s65, s16, s57
		v_lshlrev_b32_e32 v51, 4, v6
		v_lshlrev_b32_e32 v49, 3, v49
		v_add3_u32 v6, s65, v51, v49
		v_lshlrev_b32_e32 v52, 2, v52
		v_lshlrev_b32_e32 v54, 1, v54
		v_add3_u32 v6, v6, v52, v54
		v_add3_u32 v6, v6, v56, v30
		v_lshlrev_b32_e32 v62, 2, v42
		v_lshlrev_b32_e32 v63, 1, v44
		v_add3_u32 v6, v6, v62, v63
		v_lshlrev_b32_e32 v64, 4, v28
		v_lshlrev_b32_e32 v65, 3, v32
		v_lshlrev_b32_e32 v66, 2, v34
		v_add_u32_e32 v67, 32, v15
		v_lshlrev_b32_e32 v68, 1, v37
		v_bitop3_b32 v67, v66, v67, v68 bitop3:0x96
		v_bitop3_b32 v67, v64, v65, v67 bitop3:0x96
		v_mul_lo_u32 v69, s19, v67
		v_add3_u32 v70, v30, v62, v63
		v_add3_u32 v71, v69, v70, s65
		v_add_u32_e32 v72, 64, v15
		v_bitop3_b32 v72, v66, v72, v68 bitop3:0x96
		v_bitop3_b32 v72, v64, v65, v72 bitop3:0x96
		v_mul_lo_u32 v73, s19, v72
		v_add3_u32 v74, v73, v70, s65
		v_add_u32_e32 v75, 0x60, v15
		v_bitop3_b32 v75, v66, v75, v68 bitop3:0x96
		v_bitop3_b32 v75, v64, v65, v75 bitop3:0x96
		v_mul_lo_u32 v76, s19, v75
		v_add3_u32 v70, v76, v70, s65
		buffer_load_ubyte v77, v6, s[36:39], 0 offen
		buffer_load_ubyte v78, v71, s[36:39], 0 offen
		buffer_load_ubyte v71, v74, s[36:39], 0 offen
		buffer_load_ubyte v74, v70, s[36:39], 0 offen
		s_add_i32 s19, s3, 0x80
		s_add_i32 s19, s19, s4
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v6, s19, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_add_u32_e32 v70, s20, v16
		s_add_i32 s8, s8, 0x80
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v6, s8, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s4
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v6, s10, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		s_add_i32 s22, s22, s3
		s_add_i32 s22, s22, s4
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v6, s22, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s40, s40, 0x80
		s_add_i32 s40, s40, s3
		s_add_i32 s40, s40, s4
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v6, s40, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s42, s42, 0x80
		s_add_i32 s42, s42, s3
		s_add_i32 s42, s42, s4
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v6, s42, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s44, s44, 0x80
		s_add_i32 s44, s44, s3
		s_add_i32 s44, s44, s4
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v6, s44, v17, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s4
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v6, s3, v17, v19
		s_add_i32 s4, s47, 0x80
		v_add3_u32 v79, s4, v26, v19
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s14, s48, 0x80
		s_add_i32 s14, s14, s47
		v_add3_u32 v6, s14, v26, v19
		v_lshlrev_b32_e32 v80, 4, v5
		v_lshlrev_b32_e32 v81, 3, v7
		buffer_load_dwordx4 v79, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s48, s50, 0x80
		s_add_i32 s48, s48, s47
		v_add3_u32 v5, s48, v26, v19
		v_lshlrev_b32_e32 v35, 2, v35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s50, s52, 0x80
		s_add_i32 s50, s50, s47
		v_add3_u32 v6, s50, v26, v19
		v_lshlrev_b32_e32 v38, 1, v38
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s52, s54, 8
		s_add_i32 s52, s52, s55
		v_add3_u32 v5, s52, v80, v81
		v_add3_u32 v5, v5, v35, v38
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v5, v5, v40, v30
		v_add3_u32 v5, v5, v62, v63
		v_mul_lo_u32 v79, s18, v67
		v_add3_u32 v6, s52, v79, v30
		v_add3_u32 v6, v6, v62, v63
		v_mul_lo_u32 v82, s18, v72
		v_add3_u32 v7, v30, v62, v63
		v_add3_u32 v83, v82, v7, s52
		v_mul_lo_u32 v84, s18, v75
		v_add3_u32 v85, v84, v7, s52
		v_add_u32_e32 v86, 0x80, v15
		v_bitop3_b32 v86, v66, v86, v68 bitop3:0x96
		v_bitop3_b32 v86, v64, v65, v86 bitop3:0x96
		v_mul_lo_u32 v87, s18, v86
		v_add3_u32 v7, v87, v7, s52
		v_add_u32_e32 v88, 0xa0, v15
		v_bitop3_b32 v88, v66, v88, v68 bitop3:0x96
		v_bitop3_b32 v88, v64, v65, v88 bitop3:0x96
		v_mul_lo_u32 v89, s18, v88
		v_add3_u32 v90, v30, v62, v63
		v_add3_u32 v91, v89, v90, s52
		v_add_u32_e32 v92, 0xc0, v15
		v_bitop3_b32 v92, v66, v92, v68 bitop3:0x96
		v_bitop3_b32 v92, v64, v65, v92 bitop3:0x96
		v_mul_lo_u32 v93, s18, v92
		v_add3_u32 v94, v93, v90, s52
		v_add_u32_e32 v95, 0xe0, v15
		v_bitop3_b32 v66, v66, v95, v68 bitop3:0x96
		v_bitop3_b32 v65, v64, v65, v66 bitop3:0x96
		v_mul_lo_u32 v66, s18, v65
		v_add3_u32 v68, v66, v90, s52
		buffer_load_ubyte v90, v5, s[32:35], 0 offen
		buffer_load_ubyte v95, v6, s[32:35], 0 offen
		buffer_load_ubyte v96, v83, s[32:35], 0 offen
		buffer_load_ubyte v83, v85, s[32:35], 0 offen
		buffer_load_ubyte v85, v7, s[32:35], 0 offen
		buffer_load_ubyte v97, v91, s[32:35], 0 offen
		buffer_load_ubyte v91, v94, s[32:35], 0 offen
		buffer_load_ubyte v94, v68, s[32:35], 0 offen
		s_add_i32 s18, s57, 8
		v_add3_u32 v5, s18, v51, v49
		v_add3_u32 v5, v5, v52, v54
		v_add3_u32 v5, v5, v56, v30
		v_add3_u32 v5, v5, v62, v63
		v_add3_u32 v6, v30, v62, v63
		v_add3_u32 v7, v69, v6, s18
		v_add3_u32 v68, v73, v6, s18
		v_add3_u32 v6, v76, v6, s18
		buffer_load_ubyte v98, v5, s[36:39], 0 offen
		buffer_load_ubyte v99, v7, s[36:39], 0 offen
		buffer_load_ubyte v100, v68, s[36:39], 0 offen
		buffer_load_ubyte v68, v6, s[36:39], 0 offen
		s_add_i32 s54, s58, 0x80
		s_add_i32 s54, s54, s47
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v5, s54, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s55, s60, 0x80
		s_add_i32 s55, s55, s47
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v5, s55, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s58, s62, 0x80
		s_add_i32 s58, s58, s47
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v5, s58, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s47
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v5, s15, v26, v19
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s16, s16, 8
		s_add_i32 s16, s16, s57
		v_add3_u32 v5, s16, v51, v49
		v_add3_u32 v5, v5, v52, v54
		v_add3_u32 v5, v5, v56, v30
		v_add3_u32 v5, v5, v62, v63
		v_add3_u32 v6, v30, v62, v63
		v_add3_u32 v7, v69, v6, s16
		v_add3_u32 v101, v73, v6, s16
		v_add3_u32 v6, v76, v6, s16
		buffer_load_ubyte v102, v5, s[36:39], 0 offen
		buffer_load_ubyte v103, v7, s[36:39], 0 offen
		buffer_load_ubyte v104, v101, s[36:39], 0 offen
		buffer_load_ubyte v101, v6, s[36:39], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v5, 11, v28
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v7, 4, v6
		v_lshlrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v6, 15, v6
		v_lshlrev_b32_e32 v6, 7, v6
		v_add3_u32 v105, v5, v7, v6
		ds_read_b128 a[0:3], v105
		ds_read_b128 a[4:7], v105 offset:64
		ds_read_b128 a[8:11], v105 offset:4096
		ds_read_b128 a[12:15], v105 offset:4160
		ds_read_b128 a[16:19], v105 offset:8192
		ds_read_b128 a[20:23], v105 offset:8256
		ds_read_b128 a[24:27], v105 offset:12288
		ds_read_b128 a[28:31], v105 offset:12352
		ds_read_b128 a[32:35], v105 offset:16384
		ds_read_b128 a[36:39], v105 offset:16448
		ds_read_b128 a[40:43], v105 offset:20480
		ds_read_b128 a[44:47], v105 offset:20544
		ds_read_b128 a[48:51], v105 offset:24576
		ds_read_b128 a[52:55], v105 offset:24640
		ds_read_b128 a[56:59], v105 offset:28672
		ds_read_b128 a[60:63], v105 offset:28736
		v_add_u32_e32 v5, 0x10000, v7
		v_lshlrev_b32_e32 v7, 11, v32
		v_add3_u32 v106, v5, v7, v6
		ds_read_b128 a[64:67], v106
		ds_read_b128 a[68:71], v106 offset:64
		ds_read_b128 a[72:75], v106 offset:4096
		ds_read_b128 a[76:79], v106 offset:4160
		ds_read_b128 a[80:83], v106 offset:8192
		ds_read_b128 a[84:87], v106 offset:8256
		ds_read_b128 a[88:91], v106 offset:12288
		ds_read_b128 a[92:95], v106 offset:12352
		v_lshlrev_b32_e32 v5, 3, v0
		v_add_u32_e32 v107, 0x20000, v5
		s_waitcnt vmcnt(41)
		ds_write_b64 v107, v[46:47]
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v46, 0x20000, v5
		v_lshlrev_b32_e32 v5, 7, v28
		v_add_u32_e32 v5, 0x20000, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(40)
		ds_write_b32 v46, v61 offset:2048
		v_lshlrev_b32_e32 v6, 3, v30
		v_add_u32_e32 v5, v5, v6
		v_lshlrev_b32_e32 v47, 1, v34
		v_add_u32_e32 v7, v5, v47
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v61, 6, v15
		v_add3_u32 v7, v7, v37, v61
		v_lshlrev_b32_e32 v108, 5, v42
		v_lshlrev_b32_e32 v109, 4, v44
		v_add3_u32 v110, v7, v108, v109
		ds_read_u8 v111, v110
		v_add3_u32 v5, v5, v61, v108
		v_add_u32_e32 v7, 4, v37
		v_xor_b32_e32 v7, v7, v47
		v_add3_u32 v112, v5, v109, v7
		ds_read_u8 v113, v112
		v_add_u32_e32 v5, 0x20000, v47
		v_add_u32_e32 v5, v5, v37
		v_lshlrev_b32_e32 v114, 3, v15
		v_add_u32_e32 v115, 32, v30
		v_xor_b32_e32 v115, v115, v63
		v_bitop3_b32 v115, v114, v62, v115 bitop3:0x96
		v_xor_b32_e32 v116, v64, v115
		v_lshl_add_u32 v117, v116, 3, v5
		ds_read_u8 v118, v117
		v_add_u32_e32 v119, 0x20000, v7
		v_lshl_add_u32 v116, v116, 3, v119
		ds_read_u8 v120, v116
		v_add_u32_e32 v121, 64, v30
		v_xor_b32_e32 v121, v121, v63
		v_bitop3_b32 v121, v114, v62, v121 bitop3:0x96
		v_xor_b32_e32 v122, v64, v121
		v_lshl_add_u32 v123, v122, 3, v5
		ds_read_u8 v124, v123
		v_lshl_add_u32 v122, v122, 3, v119
		ds_read_u8 v125, v122
		v_add_u32_e32 v126, 0x60, v30
		v_xor_b32_e32 v126, v126, v63
		v_bitop3_b32 v126, v114, v62, v126 bitop3:0x96
		v_xor_b32_e32 v127, v64, v126
		v_lshl_add_u32 v128, v127, 3, v5
		ds_read_u8 v129, v128
		v_lshl_add_u32 v127, v127, 3, v119
		ds_read_u8 v130, v127
		v_add_u32_e32 v131, 0x80, v30
		v_bitop3_b32 v131, v62, v131, v63 bitop3:0x96
		v_bitop3_b32 v131, v64, v114, v131 bitop3:0x96
		v_lshl_add_u32 v132, v131, 3, v5
		ds_read_u8 v133, v132
		v_lshl_add_u32 v131, v131, 3, v119
		ds_read_u8 v134, v131
		v_add_u32_e32 v135, 0xa0, v30
		v_bitop3_b32 v135, v62, v135, v63 bitop3:0x96
		v_bitop3_b32 v135, v64, v114, v135 bitop3:0x96
		v_lshl_add_u32 v136, v135, 3, v5
		ds_read_u8 v137, v136
		v_lshl_add_u32 v135, v135, 3, v119
		ds_read_u8 v138, v135
		v_add_u32_e32 v139, 0xc0, v30
		v_bitop3_b32 v139, v62, v139, v63 bitop3:0x96
		v_bitop3_b32 v139, v64, v114, v139 bitop3:0x96
		v_lshl_add_u32 v140, v139, 3, v5
		ds_read_u8 v141, v140
		v_lshl_add_u32 v139, v139, 3, v119
		ds_read_u8 v142, v139
		v_add_u32_e32 v143, 0xe0, v30
		v_bitop3_b32 v143, v62, v143, v63 bitop3:0x96
		v_bitop3_b32 v64, v64, v114, v143 bitop3:0x96
		v_lshl_add_u32 v114, v64, 3, v5
		ds_read_u8 v143, v114
		v_lshl_add_u32 v64, v64, 3, v119
		ds_read_u8 v144, v64
		v_add_u32_e32 v6, 0x20000, v6
		v_lshl_add_u32 v6, v32, 7, v6
		v_add_u32_e32 v145, v6, v47
		v_add3_u32 v145, v145, v37, v61
		v_add3_u32 v145, v145, v108, v109
		ds_read_u8 v146, v145 offset:2048
		v_add3_u32 v6, v6, v61, v108
		v_add3_u32 v61, v6, v109, v7
		ds_read_u8 v108, v61 offset:2048
		v_lshlrev_b32_e32 v6, 4, v32
		v_xor_b32_e32 v7, v6, v115
		v_lshl_add_u32 v109, v7, 3, v5
		ds_read_u8 v115, v109 offset:2048
		v_lshl_add_u32 v147, v7, 3, v119
		ds_read_u8 v148, v147 offset:2048
		v_xor_b32_e32 v7, v6, v121
		v_lshl_add_u32 v121, v7, 3, v5
		ds_read_u8 v149, v121 offset:2048
		v_lshl_add_u32 v150, v7, 3, v119
		ds_read_u8 v151, v150 offset:2048
		v_xor_b32_e32 v6, v6, v126
		v_lshl_add_u32 v126, v6, 3, v5
		ds_read_u8 v152, v126 offset:2048
		v_lshl_add_u32 v119, v6, 3, v119
		ds_read_u8 v153, v119 offset:2048
		s_mov_b32 s60, 0x100
		s_mov_b32 s62, s60
		s_mov_b32 s60, 16
		s_mov_b32 s66, s60
		s_mov_b32 s60, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v5, 0x20000, v30
		v_add3_u32 v5, v5, v62, v63
		v_lshl_add_u32 v67, v67, 3, v5
		v_lshl_add_u32 v72, v72, 3, v5
		v_lshl_add_u32 v75, v75, 3, v5
		v_lshl_add_u32 v86, v86, 3, v5
		v_lshl_add_u32 v88, v88, 3, v5
		v_lshl_add_u32 v92, v92, 3, v5
		v_lshl_add_u32 v65, v65, 3, v5
		v_add3_u32 v154, v30, v62, v63
		v_add3_u32 v155, v30, v62, v63
		v_add3_u32 v156, v30, v62, v63
		v_add3_u32 v157, v30, v62, v63
		v_add3_u32 v158, v30, v62, v63
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
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
		v_accvgpr_write_b32 a252, 0
		v_accvgpr_write_b32 a253, 0
		v_accvgpr_write_b32 a254, 0
		v_accvgpr_write_b32 a255, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v111, 0xff, v111
		v_and_b32_e32 v113, 0xff, v113
		v_lshlrev_b32_e32 v113, 8, v113
		v_or_b32_e32 v111, v111, v113
		v_and_b32_e32 v113, 0xff, v118
		v_lshlrev_b32_e32 v113, 16, v113
		v_and_b32_e32 v118, 0xff, v120
		v_lshlrev_b32_e32 v118, 24, v118
		v_or3_b32 v111, v111, v113, v118
		v_and_b32_e32 v113, 0xff, v124
		v_and_b32_e32 v118, 0xff, v125
		v_lshlrev_b32_e32 v118, 8, v118
		v_or_b32_e32 v113, v113, v118
		v_and_b32_e32 v118, 0xff, v129
		v_lshlrev_b32_e32 v118, 16, v118
		v_and_b32_e32 v120, 0xff, v130
		v_lshlrev_b32_e32 v120, 24, v120
		v_or3_b32 v113, v113, v118, v120
		v_and_b32_e32 v118, 0xff, v133
		v_and_b32_e32 v120, 0xff, v134
		v_lshlrev_b32_e32 v120, 8, v120
		v_or_b32_e32 v118, v118, v120
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v120, 0xff, v137
		v_lshlrev_b32_e32 v120, 16, v120
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v124, 0xff, v138
		v_lshlrev_b32_e32 v124, 24, v124
		v_or3_b32 v118, v118, v120, v124
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v120, 0xff, v141
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v124, 0xff, v142
		v_lshlrev_b32_e32 v124, 8, v124
		v_or_b32_e32 v120, v120, v124
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v124, 0xff, v143
		v_lshlrev_b32_e32 v124, 16, v124
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v125, 0xff, v144
		v_lshlrev_b32_e32 v125, 24, v125
		v_or3_b32 v120, v120, v124, v125
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v124, 0xff, v146
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v108, 0xff, v108
		v_lshlrev_b32_e32 v108, 8, v108
		v_or_b32_e32 v108, v124, v108
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v115, 0xff, v115
		v_lshlrev_b32_e32 v115, 16, v115
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v124, 0xff, v148
		v_lshlrev_b32_e32 v124, 24, v124
		v_or3_b32 v108, v108, v115, v124
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v115, 0xff, v149
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v124, 0xff, v151
		v_lshlrev_b32_e32 v124, 8, v124
		v_or_b32_e32 v115, v115, v124
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v124, 0xff, v152
		v_lshlrev_b32_e32 v124, 16, v124
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v125, 0xff, v153
		v_lshlrev_b32_e32 v125, 24, v125
		v_or3_b32 v115, v115, v124, v125
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v108, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v108, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v108, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v108, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v108, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v108, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v108, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v108, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v115, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v115, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v115, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v115, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v115, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v115, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v115, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v115, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v115, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v115, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v115, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v115, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v115, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v115, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v115, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v115, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v108, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v108, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v108, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v108, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v108, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v108, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v108, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v108, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v108, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v108, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v108, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v108, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v115, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v115, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v115, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v115, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v115, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[36:39], v[224:227], v115, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[44:47], v[240:243], v115, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v115, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v115, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v115, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v115, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v115, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v115, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v115, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v115, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v115, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v108, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v108, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v108, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v108, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v108, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v108, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v108, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v108, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v106 offset:32768
		ds_read_b128 a[68:71], v106 offset:32832
		ds_read_b128 a[72:75], v106 offset:36864
		ds_read_b128 a[76:79], v106 offset:36928
		ds_read_b128 a[80:83], v106 offset:40960
		ds_read_b128 a[84:87], v106 offset:41024
		ds_read_b128 a[88:91], v106 offset:45056
		ds_read_b128 v[252:255], v106 offset:45120
		s_waitcnt vmcnt(35)
		ds_write_b8 v0, v77 offset:2048
		s_waitcnt vmcnt(34)
		ds_write_b8 v67, v78 offset:2048
		s_waitcnt vmcnt(33)
		ds_write_b8 v72, v71 offset:2048
		s_waitcnt vmcnt(32)
		ds_write_b8 v75, v74 offset:2048
		s_add_i32 s69, s5, s62
		s_mov_b32 m0, s2
		v_add3_u32 v71, s69, v17, v19
		buffer_load_dwordx4 v71, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v71, v145 offset:2048
		ds_read_u8 v74, v61 offset:2048
		ds_read_u8 v77, v109 offset:2048
		ds_read_u8 v78, v147 offset:2048
		ds_read_u8 v108, v121 offset:2048
		ds_read_u8 v115, v150 offset:2048
		ds_read_u8 v124, v126 offset:2048
		ds_read_u8 v125, v119 offset:2048
		s_add_i32 s69, s9, s62
		s_add_i32 m0, s2, 0x1000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s11, s62
		s_add_i32 m0, s2, 0x2000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s23, s62
		s_add_i32 m0, s2, 0x3000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s41, s62
		s_add_i32 m0, s2, 0x4000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s43, s62
		s_add_i32 m0, s2, 0x5000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s45, s62
		s_add_i32 m0, s2, 0x6000
		v_add3_u32 v129, s69, v17, v19
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s46, s62
		s_add_i32 m0, s2, 0x7000
		v_add3_u32 v129, s69, v17, v19
		s_add_i32 s69, s47, s67
		v_add3_u32 v130, s69, v26, v19
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v71, 0xff, v71
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v74, 0xff, v74
		v_lshlrev_b32_e32 v74, 8, v74
		v_or_b32_e32 v71, v71, v74
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v74, 0xff, v77
		v_lshlrev_b32_e32 v74, 16, v74
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x10000
		s_add_i32 s69, s49, s67
		v_add3_u32 v77, s69, v26, v19
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v78, 0xff, v78
		v_lshlrev_b32_e32 v78, 24, v78
		v_or3_b32 v71, v71, v74, v78
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v74, 0xff, v108
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v78, 0xff, v115
		v_lshlrev_b32_e32 v78, 8, v78
		v_or_b32_e32 v74, v74, v78
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v78, 0xff, v124
		v_lshlrev_b32_e32 v78, 16, v78
		buffer_load_dwordx4 v130, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x11000
		s_add_i32 s69, s51, s67
		v_add3_u32 v108, s69, v26, v19
		buffer_load_dwordx4 v77, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x12000
		s_add_i32 s69, s53, s67
		v_add3_u32 v77, s69, v26, v19
		buffer_load_dwordx4 v108, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x13000
		s_add_i32 s69, s56, s66
		v_add3_u32 v108, s69, v29, v31
		buffer_load_dwordx4 v77, s[28:31], 0 offen lds
		v_add3_u32 v77, v108, v33, v36
		v_add3_u32 v77, v77, v39, v41
		v_add3_u32 v77, v77, v43, v45
		buffer_load_dwordx2 v[142:143], v77, s[32:35], 0 offen
		s_add_i32 s69, s57, s68
		v_add3_u32 v77, s69, v48, v50
		v_add3_u32 v77, v77, v53, v55
		v_add3_u32 v77, v77, v57, v58
		v_add3_u32 v77, v77, v59, v60
		buffer_load_dword v108, v77, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v77, 0xff, v125
		v_lshlrev_b32_e32 v77, 24, v77
		v_or3_b32 v74, v74, v78, v77
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v71, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v71, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v71, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v71, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v71, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v71, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v71, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v71, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v74, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v74, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v74, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v74, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v74, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v74, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v74, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v74, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v74, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v74, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v74, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v74, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v74, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[20:23], a[172:175], v74, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[28:31], a[188:191], v74, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v74, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v71, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v71, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v71, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v71, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v71, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v71, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v71, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v71, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v71, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v71, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v71, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v71, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v71, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v71, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v71, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v71, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v74, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v74, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v74, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v74, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v74, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[36:39], a[204:207], v74, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[44:47], a[220:223], v74, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v74, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v74, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v74, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[88:91], a[56:59], a[252:255], v74, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v74, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v74, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[52:55], a[236:239], v74, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[60:63], a[252:255], v74, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v74, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v71, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v71, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v71, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v71, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v71, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v71, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v71, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v71, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v105 offset:32768
		ds_read_b128 a[4:7], v105 offset:32832
		ds_read_b128 a[8:11], v105 offset:36864
		ds_read_b128 a[12:15], v105 offset:36928
		ds_read_b128 a[16:19], v105 offset:40960
		ds_read_b128 a[20:23], v105 offset:41024
		ds_read_b128 a[24:27], v105 offset:45056
		ds_read_b128 a[28:31], v105 offset:45120
		ds_read_b128 a[32:35], v105 offset:49152
		ds_read_b128 a[36:39], v105 offset:49216
		ds_read_b128 a[40:43], v105 offset:53248
		ds_read_b128 a[44:47], v105 offset:53312
		ds_read_b128 a[48:51], v105 offset:57344
		ds_read_b128 a[52:55], v105 offset:57408
		ds_read_b128 a[56:59], v105 offset:61440
		ds_read_b128 a[60:63], v105 offset:61504
		ds_read_b128 a[64:67], v106 offset:16384
		ds_read_b128 a[68:71], v106 offset:16448
		ds_read_b128 a[72:75], v106 offset:20480
		ds_read_b128 a[76:79], v106 offset:20544
		ds_read_b128 a[80:83], v106 offset:24576
		ds_read_b128 a[84:87], v106 offset:24640
		ds_read_b128 a[88:91], v106 offset:28672
		ds_read_b128 v[252:255], v106 offset:28736
		s_waitcnt vmcnt(33)
		ds_write_b8 v0, v90
		s_waitcnt vmcnt(32)
		ds_write_b8 v67, v95
		s_waitcnt vmcnt(31)
		ds_write_b8 v72, v96
		s_waitcnt vmcnt(30)
		ds_write_b8 v75, v83
		s_waitcnt vmcnt(29)
		ds_write_b8 v86, v85
		s_waitcnt vmcnt(28)
		ds_write_b8 v88, v97
		s_waitcnt vmcnt(27)
		ds_write_b8 v92, v91
		s_waitcnt vmcnt(26)
		ds_write_b8 v65, v94
		s_add_i32 s69, s59, s67
		s_add_i32 m0, s2, 0x18000
		v_add3_u32 v71, s69, v26, v19
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(26)
		ds_write_b8 v0, v98 offset:2048
		s_waitcnt vmcnt(25)
		ds_write_b8 v67, v99 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v72, v100 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v75, v68 offset:2048
		s_add_i32 s69, s61, s67
		s_add_i32 m0, s2, 0x19000
		v_add3_u32 v68, s69, v26, v19
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v68, v110
		ds_read_u8 v83, v112
		ds_read_u8 v85, v117
		ds_read_u8 v90, v116
		ds_read_u8 v91, v123
		ds_read_u8 v94, v122
		ds_read_u8 v95, v128
		ds_read_u8 v96, v127
		ds_read_u8 v97, v132
		ds_read_u8 v98, v131
		ds_read_u8 v99, v136
		ds_read_u8 v100, v135
		ds_read_u8 v111, v140
		ds_read_u8 v113, v139
		ds_read_u8 v115, v114
		ds_read_u8 v118, v64
		ds_read_u8 v120, v145 offset:2048
		ds_read_u8 v124, v61 offset:2048
		ds_read_u8 v125, v109 offset:2048
		ds_read_u8 v129, v147 offset:2048
		ds_read_u8 v130, v121 offset:2048
		ds_read_u8 v133, v150 offset:2048
		ds_read_u8 v134, v126 offset:2048
		ds_read_u8 v137, v119 offset:2048
		s_add_i32 s69, s63, s67
		s_add_i32 m0, s2, 0x1a000
		v_add3_u32 v71, s69, v26, v19
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 s69, s64, s67
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v71, s69, v26, v19
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 s69, s65, s68
		v_add3_u32 v71, s69, v51, v49
		v_add3_u32 v71, v71, v52, v54
		v_add3_u32 v71, v71, v56, v30
		v_add3_u32 v71, v71, v62, v63
		v_add3_u32 v74, v69, v154, s69
		v_add3_u32 v138, v73, v154, s69
		v_add3_u32 v141, v76, v154, s69
		buffer_load_ubyte v77, v71, s[36:39], 0 offen
		buffer_load_ubyte v78, v74, s[36:39], 0 offen
		buffer_load_ubyte v71, v138, s[36:39], 0 offen
		buffer_load_ubyte v74, v141, s[36:39], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v68, 0xff, v68
		v_and_b32_e32 v83, 0xff, v83
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		v_and_b32_e32 v83, 0xff, v85
		v_lshlrev_b32_e32 v83, 16, v83
		v_and_b32_e32 v85, 0xff, v90
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v138, v68, v83, v85
		v_and_b32_e32 v68, 0xff, v91
		v_and_b32_e32 v83, 0xff, v94
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		v_and_b32_e32 v83, 0xff, v95
		v_lshlrev_b32_e32 v83, 16, v83
		v_and_b32_e32 v85, 0xff, v96
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v141, v68, v83, v85
		v_and_b32_e32 v68, 0xff, v97
		v_and_b32_e32 v83, 0xff, v98
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v83, 0xff, v99
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v85, 0xff, v100
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v144, v68, v83, v85
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v68, 0xff, v111
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v83, 0xff, v113
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v83, 0xff, v115
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v85, 0xff, v118
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v111, v68, v83, v85
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v68, 0xff, v120
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v83, 0xff, v124
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v83, 0xff, v125
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v85, 0xff, v129
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v68, v68, v83, v85
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v83, 0xff, v130
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v85, 0xff, v133
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v83, v83, v85
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v85, 0xff, v134
		v_lshlrev_b32_e32 v85, 16, v85
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v90, 0xff, v137
		v_lshlrev_b32_e32 v90, 24, v90
		v_or3_b32 v83, v83, v85, v90
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v68, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v68, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v68, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v68, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v68, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v68, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v68, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v68, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v83, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v83, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v83, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v83, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v83, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[4:7], v[160:163], v83, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[12:15], v[176:179], v83, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v83, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v83, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v83, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v83, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v83, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v83, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[20:23], v[192:195], v83, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[28:31], v[208:211], v83, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v83, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v68, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v68, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v68, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v68, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v68, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v68, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v68, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v68, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v68, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v68, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v68, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v68, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v68, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v68, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v68, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v68, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v83, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v83, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v83, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v83, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v83, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[36:39], v[224:227], v83, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[44:47], v[240:243], v83, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v83, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v83, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v83, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v83, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v83, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v83, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[52:55], a[108:111], v83, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[60:63], a[124:127], v83, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v83, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v68, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v68, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v68, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v68, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v68, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v68, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v68, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v68, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v106 offset:49152
		ds_read_b128 a[68:71], v106 offset:49216
		ds_read_b128 a[72:75], v106 offset:53248
		ds_read_b128 a[76:79], v106 offset:53312
		ds_read_b128 a[80:83], v106 offset:57344
		ds_read_b128 a[84:87], v106 offset:57408
		ds_read_b128 a[88:91], v106 offset:61440
		ds_read_b128 v[252:255], v106 offset:61504
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v102 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v67, v103 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v72, v104 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v75, v101 offset:2048
		s_add_i32 s69, s19, s62
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v68, s69, v17, v19
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v68, v145 offset:2048
		ds_read_u8 v83, v61 offset:2048
		ds_read_u8 v85, v109 offset:2048
		ds_read_u8 v90, v147 offset:2048
		ds_read_u8 v91, v121 offset:2048
		ds_read_u8 v94, v150 offset:2048
		ds_read_u8 v95, v126 offset:2048
		ds_read_u8 v101, v119 offset:2048
		s_add_i32 s69, s8, s62
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s10, s62
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s22, s62
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s40, s62
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s42, s62
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s44, s62
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v96, s69, v17, v19
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 s69, s3, s62
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v96, s69, v17, v19
		s_add_i32 s69, s4, s67
		v_add3_u32 v97, s69, v26, v19
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v68, 0xff, v68
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v83, 0xff, v83
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v68, v68, v83
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v83, 0xff, v85
		v_lshlrev_b32_e32 v83, 16, v83
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s69, s14, s67
		v_add3_u32 v85, s69, v26, v19
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v90, 0xff, v90
		v_lshlrev_b32_e32 v90, 24, v90
		v_or3_b32 v102, v68, v83, v90
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v68, 0xff, v91
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v83, 0xff, v94
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v103, v68, v83
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v68, 0xff, v95
		v_lshlrev_b32_e32 v104, 16, v68
		buffer_load_dwordx4 v97, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s69, s48, s67
		v_add3_u32 v68, s69, v26, v19
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s69, s50, s67
		v_add3_u32 v83, s69, v26, v19
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s69, s52, s66
		v_add3_u32 v68, s69, v80, v81
		buffer_load_dwordx4 v83, s[28:31], 0 offen lds
		v_add3_u32 v68, v68, v35, v38
		v_add3_u32 v68, v68, v40, v30
		v_add3_u32 v68, v68, v62, v63
		v_add3_u32 v83, s69, v79, v30
		v_add3_u32 v83, v83, v62, v63
		v_add3_u32 v85, v82, v155, s69
		v_add3_u32 v91, v84, v155, s69
		v_add3_u32 v94, v87, v155, s69
		v_add3_u32 v98, v89, v156, s69
		v_add3_u32 v99, v93, v156, s69
		v_add3_u32 v100, v66, v156, s69
		buffer_load_ubyte v90, v68, s[32:35], 0 offen
		buffer_load_ubyte v95, v83, s[32:35], 0 offen
		buffer_load_ubyte v96, v85, s[32:35], 0 offen
		buffer_load_ubyte v83, v91, s[32:35], 0 offen
		buffer_load_ubyte v85, v94, s[32:35], 0 offen
		buffer_load_ubyte v97, v98, s[32:35], 0 offen
		buffer_load_ubyte v91, v99, s[32:35], 0 offen
		buffer_load_ubyte v94, v100, s[32:35], 0 offen
		s_add_i32 s69, s18, s68
		v_add3_u32 v68, s69, v51, v49
		v_add3_u32 v68, v68, v52, v54
		v_add3_u32 v68, v68, v56, v30
		v_add3_u32 v68, v68, v62, v63
		v_add3_u32 v100, v69, v157, s69
		v_add3_u32 v113, v73, v157, s69
		v_add3_u32 v115, v76, v157, s69
		buffer_load_ubyte v98, v68, s[36:39], 0 offen
		buffer_load_ubyte v99, v100, s[36:39], 0 offen
		buffer_load_ubyte v100, v113, s[36:39], 0 offen
		buffer_load_ubyte v68, v115, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v101, 0xff, v101
		v_lshlrev_b32_e32 v101, 24, v101
		v_or3_b32 v101, v103, v104, v101
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v102, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v102, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v102, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v102, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v102, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v102, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v102, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v102, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v101, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v101, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v101, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v101, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v101, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v101, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v101, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v101, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v101, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v101, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v101, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v101, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v101, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[20:23], a[172:175], v101, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[28:31], a[188:191], v101, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v101, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v102, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v102, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v102, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v102, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v102, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v102, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v102, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v102, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v102, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v102, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v102, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v102, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v102, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v102, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v102, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v102, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v101, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v101, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v101, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v101, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v101, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[36:39], a[204:207], v101, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[44:47], a[220:223], v101, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v101, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v101, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v101, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[88:91], a[56:59], a[252:255], v101, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v101, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v101, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[52:55], a[236:239], v101, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[60:63], a[252:255], v101, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v101, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v102, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v102, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v102, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v102, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v102, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v102, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v102, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v102, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v105
		ds_read_b128 a[4:7], v105 offset:64
		ds_read_b128 a[8:11], v105 offset:4096
		ds_read_b128 a[12:15], v105 offset:4160
		ds_read_b128 a[16:19], v105 offset:8192
		ds_read_b128 a[20:23], v105 offset:8256
		ds_read_b128 a[24:27], v105 offset:12288
		ds_read_b128 a[28:31], v105 offset:12352
		ds_read_b128 a[32:35], v105 offset:16384
		ds_read_b128 a[36:39], v105 offset:16448
		ds_read_b128 a[40:43], v105 offset:20480
		ds_read_b128 a[44:47], v105 offset:20544
		ds_read_b128 a[48:51], v105 offset:24576
		ds_read_b128 a[52:55], v105 offset:24640
		ds_read_b128 a[56:59], v105 offset:28672
		ds_read_b128 a[60:63], v105 offset:28736
		ds_read_b128 a[64:67], v106
		ds_read_b128 a[68:71], v106 offset:64
		ds_read_b128 a[72:75], v106 offset:4096
		ds_read_b128 a[76:79], v106 offset:4160
		ds_read_b128 a[80:83], v106 offset:8192
		ds_read_b128 a[84:87], v106 offset:8256
		ds_read_b128 a[88:91], v106 offset:12288
		ds_read_b128 a[92:95], v106 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v107, v[142:143]
		s_add_i32 s69, s54, s67
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v101, s69, v26, v19
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(33)
		ds_write_b32 v46, v108 offset:2048
		s_add_i32 s69, s55, s67
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v101, s69, v26, v19
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v111, v110
		ds_read_u8 v113, v112
		ds_read_u8 v118, v117
		ds_read_u8 v120, v116
		ds_read_u8 v124, v123
		ds_read_u8 v125, v122
		ds_read_u8 v129, v128
		ds_read_u8 v130, v127
		ds_read_u8 v133, v132
		ds_read_u8 v134, v131
		ds_read_u8 v137, v136
		ds_read_u8 v138, v135
		ds_read_u8 v141, v140
		ds_read_u8 v142, v139
		ds_read_u8 v143, v114
		ds_read_u8 v144, v64
		ds_read_u8 v146, v145 offset:2048
		ds_read_u8 v108, v61 offset:2048
		ds_read_u8 v115, v109 offset:2048
		ds_read_u8 v148, v147 offset:2048
		ds_read_u8 v149, v121 offset:2048
		ds_read_u8 v151, v150 offset:2048
		ds_read_u8 v152, v126 offset:2048
		ds_read_u8 v153, v119 offset:2048
		s_add_i32 s69, s58, s67
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v101, s69, v26, v19
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s69, s15, s67
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v101, s69, v26, v19
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s69, s16, s68
		v_add3_u32 v101, s69, v51, v49
		v_add3_u32 v101, v101, v52, v54
		v_add3_u32 v101, v101, v56, v30
		v_add3_u32 v101, v101, v62, v63
		v_add3_u32 v104, v69, v158, s69
		v_add3_u32 v159, v73, v158, s69
		v_add3_u32 v252, v76, v158, s69
		buffer_load_ubyte v102, v101, s[36:39], 0 offen
		buffer_load_ubyte v103, v104, s[36:39], 0 offen
		buffer_load_ubyte v104, v159, s[36:39], 0 offen
		buffer_load_ubyte v101, v252, s[36:39], 0 offen
		s_add_i32 s62, s62, 0x100
		s_add_i32 s67, s67, 0x100
		s_add_i32 s66, s66, 16
		s_add_i32 s68, s68, 16
		s_add_i32 s60, s60, 2
		s_cmp_lt_i32 s60, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(4)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v17, 0xff, v111
		v_and_b32_e32 v19, 0xff, v113
		v_lshlrev_b32_e32 v19, 8, v19
		v_or_b32_e32 v17, v17, v19
		v_and_b32_e32 v19, 0xff, v118
		v_lshlrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v26, 0xff, v120
		v_lshlrev_b32_e32 v26, 24, v26
		v_or3_b32 v17, v17, v19, v26
		v_and_b32_e32 v19, 0xff, v124
		v_and_b32_e32 v26, 0xff, v125
		v_lshlrev_b32_e32 v26, 8, v26
		v_or_b32_e32 v19, v19, v26
		v_and_b32_e32 v26, 0xff, v129
		v_lshlrev_b32_e32 v26, 16, v26
		v_and_b32_e32 v29, 0xff, v130
		v_lshlrev_b32_e32 v29, 24, v29
		v_or3_b32 v19, v19, v26, v29
		v_and_b32_e32 v26, 0xff, v133
		v_and_b32_e32 v29, 0xff, v134
		v_lshlrev_b32_e32 v29, 8, v29
		v_or_b32_e32 v26, v26, v29
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v29, 0xff, v137
		v_lshlrev_b32_e32 v29, 16, v29
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v31, 0xff, v138
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v26, v26, v29, v31
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v29, 0xff, v141
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v31, 0xff, v142
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v29, v29, v31
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v31, 0xff, v143
		v_lshlrev_b32_e32 v31, 16, v31
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v33, 0xff, v144
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v29, v29, v31, v33
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v146
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v108
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v115
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v35, 0xff, v148
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v31, v31, v33, v35
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v149
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v35, 0xff, v151
		v_lshlrev_b32_e32 v35, 8, v35
		v_or_b32_e32 v33, v33, v35
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v35, 0xff, v152
		v_lshlrev_b32_e32 v35, 16, v35
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v153
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v35, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v31, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v31, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v31, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v31, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v33, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v33, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v33, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v33, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v33, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v33, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v33, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v33, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v33, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v33, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v33, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v33, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v31, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v31, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v31, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v31, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v31, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v31, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[40:43], v[232:235], v31, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[40:43], v[228:231], v31, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[44:47], v[232:235], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[44:47], v[228:231], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[32:35], v[220:223], v33, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[32:35], v[224:227], v33, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[40:43], v[240:243], v33, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[40:43], v[236:239], v33, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[36:39], v[220:223], v33, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[36:39], v[224:227], v33, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[44:47], v[240:243], v33, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[44:47], v[236:239], v33, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v33, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v33, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v33, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v33, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v33, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v33, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v33, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v33, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[48:51], v[244:247], v31, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v31, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v31, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v31, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[52:55], v[244:247], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v106 offset:32768
		ds_read_b128 a[64:67], v106 offset:32832
		ds_read_b128 v[52:55], v106 offset:36864
		ds_read_b128 a[68:71], v106 offset:36928
		ds_read_b128 v[56:59], v106 offset:40960
		ds_read_b128 v[152:155], v106 offset:41024
		ds_read_b128 v[156:159], v106 offset:45056
		ds_read_b128 v[252:255], v106 offset:45120
		ds_write_b8 v0, v77 offset:2048
		ds_write_b8 v67, v78 offset:2048
		ds_write_b8 v72, v71 offset:2048
		ds_write_b8 v75, v74 offset:2048
		v_add_u32_e32 v18, 0x20000, v18
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v30, 9, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v31, v145 offset:2048
		ds_read_u8 v33, v61 offset:2048
		ds_read_u8 v35, v109 offset:2048
		ds_read_u8 v36, v147 offset:2048
		ds_read_u8 v38, v121 offset:2048
		ds_read_u8 v39, v150 offset:2048
		ds_read_u8 v40, v126 offset:2048
		ds_read_u8 v41, v119 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v31, 0xff, v31
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v33, 0xff, v33
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v33, 0xff, v35
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v35, 0xff, v36
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v31, v31, v33, v35
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v33, 0xff, v38
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v35, 0xff, v39
		v_lshlrev_b32_e32 v35, 8, v35
		v_or_b32_e32 v33, v33, v35
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v35, 0xff, v40
		v_lshlrev_b32_e32 v35, 16, v35
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xff, v41
		v_lshlrev_b32_e32 v36, 24, v36
		v_or3_b32 v33, v33, v35, v36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], a[0:3], a[128:131], v31, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[0:3], a[132:135], v31, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[8:11], a[148:151], v31, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], a[8:11], a[144:147], v31, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[4:7], a[128:131], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[4:7], a[132:135], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[12:15], a[148:151], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[12:15], a[144:147], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[0:3], a[136:139], v33, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[156:159], a[0:3], a[140:143], v33, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[156:159], a[8:11], a[156:159], v33, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[8:11], a[152:155], v33, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[152:155], a[4:7], a[136:139], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v33, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[152:155], a[12:15], a[152:155], v33, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[16:19], a[168:171], v33, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[156:159], a[16:19], a[172:175], v33, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[156:159], a[24:27], a[188:191], v33, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[56:59], a[24:27], a[184:187], v33, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[152:155], a[20:23], a[168:171], v33, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[20:23], a[172:175], v33, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[28:31], a[188:191], v33, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[152:155], a[28:31], a[184:187], v33, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], a[16:19], a[160:163], v31, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[16:19], a[164:167], v31, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[52:55], a[24:27], a[180:183], v31, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], a[24:27], a[176:179], v31, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[20:23], a[160:163], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[68:71], a[20:23], a[164:167], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[68:71], a[28:31], a[180:183], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[28:31], a[176:179], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[48:51], a[32:35], a[192:195], v31, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[52:55], a[32:35], a[196:199], v31, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[52:55], a[40:43], a[212:215], v31, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[48:51], a[40:43], a[208:211], v31, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[36:39], a[192:195], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[68:71], a[36:39], a[196:199], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[68:71], a[44:47], a[212:215], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[44:47], a[208:211], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[56:59], a[32:35], a[200:203], v33, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[156:159], a[32:35], a[204:207], v33, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[156:159], a[40:43], a[220:223], v33, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[56:59], a[40:43], a[216:219], v33, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[152:155], a[36:39], a[200:203], v33, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[36:39], a[204:207], v33, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[44:47], a[220:223], v33, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[152:155], a[44:47], a[216:219], v33, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[56:59], a[48:51], a[232:235], v33, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[156:159], a[48:51], a[236:239], v33, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[156:159], a[56:59], a[252:255], v33, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[56:59], a[56:59], a[248:251], v33, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[152:155], a[52:55], a[232:235], v33, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[52:55], a[236:239], v33, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[60:63], a[252:255], v33, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[152:155], a[60:63], a[248:251], v33, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[48:51], a[48:51], a[224:227], v31, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[52:55], a[48:51], a[228:231], v31, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[52:55], a[56:59], a[244:247], v31, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[48:51], a[56:59], a[240:243], v31, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[52:55], a[224:227], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[68:71], a[52:55], a[228:231], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[68:71], a[60:63], a[244:247], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[60:63], a[240:243], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v105 offset:32768
		ds_read_b128 a[4:7], v105 offset:32832
		ds_read_b128 a[8:11], v105 offset:36864
		ds_read_b128 a[12:15], v105 offset:36928
		ds_read_b128 a[16:19], v105 offset:40960
		ds_read_b128 a[20:23], v105 offset:41024
		ds_read_b128 a[24:27], v105 offset:45056
		ds_read_b128 a[28:31], v105 offset:45120
		ds_read_b128 a[32:35], v105 offset:49152
		ds_read_b128 a[36:39], v105 offset:49216
		ds_read_b128 a[40:43], v105 offset:53248
		ds_read_b128 a[44:47], v105 offset:53312
		ds_read_b128 a[48:51], v105 offset:57344
		ds_read_b128 a[52:55], v105 offset:57408
		ds_read_b128 a[56:59], v105 offset:61440
		ds_read_b128 a[60:63], v105 offset:61504
		ds_read_b128 v[48:51], v106 offset:16384
		ds_read_b128 a[64:67], v106 offset:16448
		ds_read_b128 v[52:55], v106 offset:20480
		ds_read_b128 v[56:59], v106 offset:20544
		ds_read_b128 v[76:79], v106 offset:24576
		ds_read_b128 v[152:155], v106 offset:24640
		ds_read_b128 v[156:159], v106 offset:28672
		ds_read_b128 v[252:255], v106 offset:28736
		ds_write_b8 v0, v90
		ds_write_b8 v67, v95
		ds_write_b8 v72, v96
		ds_write_b8 v75, v83
		ds_write_b8 v86, v85
		ds_write_b8 v88, v97
		ds_write_b8 v92, v91
		ds_write_b8 v65, v94
		v_lshl_add_u32 v1, v15, 13, v1
		v_lshl_add_u32 v1, v42, 12, v1
		v_lshl_add_u32 v1, v44, 10, v1
		v_cmp_lt_i32_e64 vcc, v20, s12
		s_mov_b64 s[2:3], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v98 offset:2048
		ds_write_b8 v67, v99 offset:2048
		ds_write_b8 v72, v100 offset:2048
		ds_write_b8 v75, v68 offset:2048
		v_cmp_lt_i32_e64 vcc, v70, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s8, s2, s4
		s_and_b32 s9, s3, s5
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v17, v110
		ds_read_u8 v19, v112
		ds_read_u8 v20, v117
		ds_read_u8 v26, v116
		ds_read_u8 v29, v123
		ds_read_u8 v31, v122
		ds_read_u8 v33, v128
		ds_read_u8 v35, v127
		ds_read_u8 v36, v132
		ds_read_u8 v38, v131
		ds_read_u8 v39, v136
		ds_read_u8 v40, v135
		ds_read_u8 v41, v140
		ds_read_u8 v43, v139
		ds_read_u8 v45, v114
		ds_read_u8 v46, v64
		ds_read_u8 v60, v145 offset:2048
		ds_read_u8 v62, v61 offset:2048
		ds_read_u8 v63, v109 offset:2048
		ds_read_u8 v64, v147 offset:2048
		ds_read_u8 v65, v121 offset:2048
		ds_read_u8 v66, v150 offset:2048
		ds_read_u8 v68, v126 offset:2048
		ds_read_u8 v69, v119 offset:2048
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v17, 0xff, v17
		v_and_b32_e32 v19, 0xff, v19
		v_lshlrev_b32_e32 v19, 8, v19
		v_or_b32_e32 v17, v17, v19
		v_and_b32_e32 v19, 0xff, v20
		v_lshlrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v20, 0xff, v26
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v17, v17, v19, v20
		v_and_b32_e32 v19, 0xff, v29
		v_and_b32_e32 v20, 0xff, v31
		v_lshlrev_b32_e32 v20, 8, v20
		v_or_b32_e32 v19, v19, v20
		v_and_b32_e32 v20, 0xff, v33
		v_lshlrev_b32_e32 v20, 16, v20
		v_and_b32_e32 v26, 0xff, v35
		v_lshlrev_b32_e32 v26, 24, v26
		v_or3_b32 v19, v19, v20, v26
		v_and_b32_e32 v20, 0xff, v36
		v_and_b32_e32 v26, 0xff, v38
		v_lshlrev_b32_e32 v26, 8, v26
		v_or_b32_e32 v20, v20, v26
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v26, 0xff, v39
		v_lshlrev_b32_e32 v26, 16, v26
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v29, 0xff, v40
		v_lshlrev_b32_e32 v29, 24, v29
		v_or3_b32 v20, v20, v26, v29
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v26, 0xff, v41
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v29, 0xff, v43
		v_lshlrev_b32_e32 v29, 8, v29
		v_or_b32_e32 v26, v26, v29
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v29, 0xff, v45
		v_lshlrev_b32_e32 v29, 16, v29
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v31, 0xff, v46
		v_lshlrev_b32_e32 v31, 24, v31
		v_or3_b32 v26, v26, v29, v31
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v29, 0xff, v60
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v31, 0xff, v62
		v_lshlrev_b32_e32 v31, 8, v31
		v_or_b32_e32 v29, v29, v31
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v31, 0xff, v63
		v_lshlrev_b32_e32 v31, 16, v31
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v33, 0xff, v64
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v29, v29, v31, v33
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v31, 0xff, v65
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v33, 0xff, v66
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v31, v31, v33
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v33, 0xff, v68
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v35, 0xff, v69
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v31, v31, v33, v35
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[48:51], a[0:3], v[248:251], v29, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[52:55], a[0:3], a[96:99], v29, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], a[8:11], v[168:171], v29, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[48:51], a[8:11], v[164:167], v29, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[4:7], v[248:251], v29, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[56:59], a[4:7], a[96:99], v29, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], a[12:15], v[168:171], v29, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[12:15], v[164:167], v29, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[76:79], a[0:3], v[4:7], v31, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[156:159], a[0:3], v[160:163], v31, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[156:159], a[8:11], v[176:179], v31, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[76:79], a[8:11], v[172:175], v31, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[152:155], a[4:7], v[4:7], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[4:7], v[160:163], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[12:15], v[176:179], v31, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[152:155], a[12:15], v[172:175], v31, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[76:79], a[16:19], v[188:191], v31, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[156:159], a[16:19], v[192:195], v31, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[156:159], a[24:27], v[208:211], v31, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[76:79], a[24:27], v[204:207], v31, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[152:155], a[20:23], v[188:191], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[20:23], v[192:195], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[28:31], v[208:211], v31, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[152:155], a[28:31], v[204:207], v31, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], a[16:19], v[180:183], v29, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], a[16:19], v[184:187], v29, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], a[24:27], v[200:203], v29, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[48:51], a[24:27], v[196:199], v29, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[20:23], v[180:183], v29, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], a[20:23], v[184:187], v29, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], a[28:31], v[200:203], v29, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[28:31], v[196:199], v29, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], a[32:35], v[212:215], v29, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[32:35], v[216:219], v29, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], a[40:43], v[232:235], v29, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], a[40:43], v[228:231], v29, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[36:39], v[212:215], v29, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], a[36:39], v[216:219], v29, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[44:47], v[232:235], v29, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[44:47], v[228:231], v29, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[76:79], a[32:35], v[220:223], v31, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[156:159], a[32:35], v[224:227], v31, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[156:159], a[40:43], v[240:243], v31, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[76:79], a[40:43], v[236:239], v31, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[152:155], a[36:39], v[220:223], v31, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[36:39], v[224:227], v31, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[44:47], v[240:243], v31, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[152:155], a[44:47], v[236:239], v31, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], a[48:51], a[104:107], v31, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[156:159], a[48:51], a[108:111], v31, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[156:159], a[56:59], a[124:127], v31, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], a[56:59], a[120:123], v31, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[152:155], a[52:55], a[104:107], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[52:55], a[108:111], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[60:63], a[124:127], v31, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[152:155], a[60:63], a[120:123], v31, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[48:51], v[244:247], v29, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[52:55], a[48:51], a[100:103], v29, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[56:59], a[116:119], v29, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[48:51], a[56:59], a[112:115], v29, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[52:55], v[244:247], v29, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[56:59], a[52:55], a[100:103], v29, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[60:63], a[116:119], v29, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[60:63], a[112:115], v29, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v106 offset:49152
		ds_read_b128 v[52:55], v106 offset:49216
		ds_read_b128 v[56:59], v106 offset:53248
		ds_read_b128 v[68:71], v106 offset:53312
		ds_read_b128 v[76:79], v106 offset:57344
		ds_read_b128 v[80:83], v106 offset:57408
		ds_read_b128 v[84:87], v106 offset:61440
		ds_read_b128 v[88:91], v106 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v102 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v67, v103 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v72, v104 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v75, v101 offset:2048
		v_cvt_pk_bf16_f32 v64, v248, v249
		v_cvt_pk_bf16_f32 v65, v250, v251
		v_accvgpr_read_b32 v0, a96
		v_accvgpr_read_b32 v29, a97
		v_cvt_pk_bf16_f32 v72, v0, v29
		v_accvgpr_read_b32 v0, a98
		v_accvgpr_read_b32 v29, a99
		v_cvt_pk_bf16_f32 v73, v0, v29
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v145 offset:2048
		ds_read_u8 v29, v61 offset:2048
		ds_read_u8 v31, v109 offset:2048
		ds_read_u8 v33, v147 offset:2048
		ds_read_u8 v35, v121 offset:2048
		ds_read_u8 v36, v150 offset:2048
		ds_read_u8 v38, v126 offset:2048
		ds_read_u8 v39, v119 offset:2048
		v_cvt_pk_bf16_f32 v60, v4, v5
		v_cvt_pk_bf16_f32 v61, v6, v7
		v_cvt_pk_bf16_f32 v4, v160, v161
		v_cvt_pk_bf16_f32 v5, v162, v163
		v_cvt_pk_bf16_f32 v66, v164, v165
		v_cvt_pk_bf16_f32 v67, v166, v167
		v_cvt_pk_bf16_f32 v74, v168, v169
		v_cvt_pk_bf16_f32 v75, v170, v171
		v_cvt_pk_bf16_f32 v62, v172, v173
		v_cvt_pk_bf16_f32 v63, v174, v175
		v_cvt_pk_bf16_f32 v6, v176, v177
		v_cvt_pk_bf16_f32 v7, v178, v179
		v_cvt_pk_bf16_f32 v92, v180, v181
		v_cvt_pk_bf16_f32 v93, v182, v183
		v_cvt_pk_bf16_f32 v96, v184, v185
		v_cvt_pk_bf16_f32 v97, v186, v187
		v_cvt_pk_bf16_f32 v100, v188, v189
		v_cvt_pk_bf16_f32 v101, v190, v191
		v_cvt_pk_bf16_f32 v104, v192, v193
		v_cvt_pk_bf16_f32 v105, v194, v195
		v_cvt_pk_bf16_f32 v94, v196, v197
		v_cvt_pk_bf16_f32 v95, v198, v199
		v_cvt_pk_bf16_f32 v98, v200, v201
		v_cvt_pk_bf16_f32 v99, v202, v203
		v_cvt_pk_bf16_f32 v102, v204, v205
		v_cvt_pk_bf16_f32 v103, v206, v207
		v_cvt_pk_bf16_f32 v106, v208, v209
		v_cvt_pk_bf16_f32 v107, v210, v211
		v_cvt_pk_bf16_f32 v108, v212, v213
		v_cvt_pk_bf16_f32 v109, v214, v215
		v_cvt_pk_bf16_f32 v112, v216, v217
		v_cvt_pk_bf16_f32 v113, v218, v219
		v_cvt_pk_bf16_f32 v116, v220, v221
		v_cvt_pk_bf16_f32 v117, v222, v223
		v_cvt_pk_bf16_f32 v120, v224, v225
		v_cvt_pk_bf16_f32 v121, v226, v227
		v_cvt_pk_bf16_f32 v110, v228, v229
		v_cvt_pk_bf16_f32 v111, v230, v231
		v_cvt_pk_bf16_f32 v114, v232, v233
		v_cvt_pk_bf16_f32 v115, v234, v235
		v_cvt_pk_bf16_f32 v118, v236, v237
		v_cvt_pk_bf16_f32 v119, v238, v239
		v_cvt_pk_bf16_f32 v122, v240, v241
		v_cvt_pk_bf16_f32 v123, v242, v243
		v_cvt_pk_bf16_f32 v124, v244, v245
		v_cvt_pk_bf16_f32 v125, v246, v247
		v_accvgpr_read_b32 v40, a100
		v_accvgpr_read_b32 v41, a101
		v_cvt_pk_bf16_f32 v128, v40, v41
		v_accvgpr_read_b32 v40, a102
		v_accvgpr_read_b32 v41, a103
		v_cvt_pk_bf16_f32 v129, v40, v41
		v_accvgpr_read_b32 v40, a104
		v_accvgpr_read_b32 v41, a105
		v_cvt_pk_bf16_f32 v132, v40, v41
		v_accvgpr_read_b32 v40, a106
		v_accvgpr_read_b32 v41, a107
		v_cvt_pk_bf16_f32 v133, v40, v41
		v_accvgpr_read_b32 v40, a108
		v_accvgpr_read_b32 v41, a109
		v_cvt_pk_bf16_f32 v136, v40, v41
		v_accvgpr_read_b32 v40, a110
		v_accvgpr_read_b32 v41, a111
		v_cvt_pk_bf16_f32 v137, v40, v41
		v_accvgpr_read_b32 v40, a112
		v_accvgpr_read_b32 v41, a113
		v_cvt_pk_bf16_f32 v126, v40, v41
		v_accvgpr_read_b32 v40, a114
		v_accvgpr_read_b32 v41, a115
		v_cvt_pk_bf16_f32 v127, v40, v41
		v_accvgpr_read_b32 v40, a116
		v_accvgpr_read_b32 v41, a117
		v_cvt_pk_bf16_f32 v130, v40, v41
		v_accvgpr_read_b32 v40, a118
		v_accvgpr_read_b32 v41, a119
		v_cvt_pk_bf16_f32 v131, v40, v41
		v_accvgpr_read_b32 v40, a120
		v_accvgpr_read_b32 v41, a121
		v_cvt_pk_bf16_f32 v134, v40, v41
		v_accvgpr_read_b32 v40, a122
		v_accvgpr_read_b32 v41, a123
		v_cvt_pk_bf16_f32 v135, v40, v41
		v_accvgpr_read_b32 v40, a124
		v_accvgpr_read_b32 v41, a125
		v_cvt_pk_bf16_f32 v138, v40, v41
		v_accvgpr_read_b32 v40, a126
		v_accvgpr_read_b32 v41, a127
		v_cvt_pk_bf16_f32 v139, v40, v41
		ds_write_b128 v18, v[64:67] offset:3072
		ds_write_b128 v18, v[72:75] offset:7168
		ds_write_b128 v18, v[60:63] offset:11264
		ds_write_b128 v18, v[4:7] offset:15360
		v_lshlrev_b32_e32 v4, 4, v30
		v_lshlrev_b32_e32 v5, 7, v15
		v_lshlrev_b32_e32 v6, 6, v42
		v_lshlrev_b32_e32 v7, 5, v44
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v1 offset:3072
		ds_read_b128 v[60:63], v1 offset:3328
		ds_read_b128 v[64:67], v1 offset:5120
		ds_read_b128 v[72:75], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[92:95] offset:3072
		ds_write_b128 v18, v[96:99] offset:7168
		ds_write_b128 v18, v[100:103] offset:11264
		ds_write_b128 v18, v[104:107] offset:15360
		v_mov_b32_e32 v15, 0x80000000
		v_cmp_lt_i32_e64 vcc, v21, s12
		s_mov_b64 s[10:11], vcc
		v_lshlrev_b32_e32 v21, 3, v28
		v_lshlrev_b32_e32 v30, 2, v32
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1 offset:3072
		ds_read_b128 v[96:99], v1 offset:3328
		ds_read_b128 v[100:103], v1 offset:5120
		ds_read_b128 v[104:107], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[108:111] offset:3072
		ds_write_b128 v18, v[112:115] offset:7168
		ds_write_b128 v18, v[116:119] offset:11264
		ds_write_b128 v18, v[120:123] offset:15360
		v_add_u32_e32 v44, 16, v37
		v_xor_b32_e32 v44, v44, v47
		v_bitop3_b32 v44, v21, v30, v44 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v22, s12
		s_mov_b64 s[14:15], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v1 offset:3072
		ds_read_b128 v[112:115], v1 offset:3328
		ds_read_b128 v[116:119], v1 offset:5120
		ds_read_b128 v[120:123], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[124:127] offset:3072
		ds_write_b128 v18, v[128:131] offset:7168
		ds_write_b128 v18, v[132:135] offset:11264
		ds_write_b128 v18, v[136:139] offset:15360
		v_add_u32_e32 v22, 32, v37
		v_xor_b32_e32 v22, v22, v47
		v_bitop3_b32 v22, v21, v30, v22 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v23, s12
		s_mov_b64 s[18:19], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[124:127], v1 offset:3072
		ds_read_b128 v[128:131], v1 offset:3328
		ds_read_b128 v[132:135], v1 offset:5120
		ds_read_b128 v[136:139], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s16, s0, s1
		s_mul_i32 s21, s21, s17
		s_lshl_b32 s21, s21, 9
		s_add_i32 s16, s16, s21
		v_mul_lo_u32 v23, s17, v28
		v_lshlrev_b32_e32 v23, 4, v23
		v_mul_lo_u32 v28, s17, v32
		v_lshlrev_b32_e32 v28, 3, v28
		v_add3_u32 v32, s16, v23, v28
		v_mul_lo_u32 v34, s17, v34
		v_lshlrev_b32_e32 v34, 2, v34
		v_mul_lo_u32 v45, s17, v37
		v_lshlrev_b32_e32 v45, 1, v45
		v_add3_u32 v32, v32, v34, v45
		v_add3_u32 v32, v32, v4, v5
		v_add3_u32 v32, v32, v6, v7
		v_cndmask_b32_e64 v32, v15, v32, s[8:9]
		v_mov_b64_e32 v[140:141], v[40:41]
		v_mov_b64_e32 v[142:143], v[60:61]
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		buffer_store_dwordx4 v[140:143], v32, s[28:31], 0 offen
		s_and_b32 s6, s10, s4
		s_and_b32 s7, s11, s5
		v_mul_lo_u32 v32, s17, v44
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v40, s16, v32
		v_add3_u32 v40, v40, v4, v5
		v_add3_u32 v40, v40, v6, v7
		v_cndmask_b32_e64 v40, v15, v40, s[6:7]
		v_mov_b64_e32 v[140:141], v[64:65]
		v_mov_b64_e32 v[142:143], v[72:73]
		buffer_store_dwordx4 v[140:143], v40, s[28:31], 0 offen
		s_and_b32 s6, s14, s4
		s_and_b32 s7, s15, s5
		v_mul_lo_u32 v22, s17, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v40, s16, v22
		v_add3_u32 v40, v40, v4, v5
		v_add3_u32 v40, v40, v6, v7
		v_cndmask_b32_e64 v40, v15, v40, s[6:7]
		v_mov_b64_e32 v[140:141], v[42:43]
		v_mov_b64_e32 v[142:143], v[62:63]
		buffer_store_dwordx4 v[140:143], v40, s[28:31], 0 offen
		s_and_b32 s6, s18, s4
		s_and_b32 s7, s19, s5
		v_add_u32_e32 v40, 48, v37
		v_xor_b32_e32 v40, v40, v47
		v_bitop3_b32 v40, v21, v30, v40 bitop3:0x96
		v_mul_lo_u32 v40, s17, v40
		v_lshlrev_b32_e32 v40, 1, v40
		v_add_u32_e32 v41, s16, v40
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[6:7]
		v_mov_b64_e32 v[60:61], v[66:67]
		v_mov_b64_e32 v[62:63], v[74:75]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[6:7], vcc
		s_and_b32 s8, s6, s4
		s_and_b32 s9, s7, s5
		v_add_u32_e32 v2, 64, v37
		v_xor_b32_e32 v2, v2, v47
		v_bitop3_b32 v2, v21, v30, v2 bitop3:0x96
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v41, s16, v2
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[8:9]
		v_mov_b64_e32 v[60:61], v[92:93]
		v_mov_b64_e32 v[62:63], v[96:97]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[8:9], vcc
		s_and_b32 s22, s8, s4
		s_and_b32 s23, s9, s5
		v_add_u32_e32 v3, 0x50, v37
		v_xor_b32_e32 v3, v3, v47
		v_bitop3_b32 v3, v21, v30, v3 bitop3:0x96
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add_u32_e32 v41, s16, v3
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[22:23]
		v_mov_b64_e32 v[60:61], v[100:101]
		v_mov_b64_e32 v[62:63], v[104:105]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v24, s12
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s22, s4
		s_and_b32 s25, s23, s5
		v_add_u32_e32 v24, 0x60, v37
		v_xor_b32_e32 v24, v24, v47
		v_bitop3_b32 v24, v21, v30, v24 bitop3:0x96
		v_mul_lo_u32 v24, s17, v24
		v_lshlrev_b32_e32 v24, 1, v24
		v_add_u32_e32 v41, s16, v24
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[24:25]
		v_mov_b64_e32 v[60:61], v[94:95]
		v_mov_b64_e32 v[62:63], v[98:99]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v25, s12
		s_mov_b64 s[24:25], vcc
		s_and_b32 s26, s24, s4
		s_and_b32 s27, s25, s5
		v_add_u32_e32 v25, 0x70, v37
		v_xor_b32_e32 v25, v25, v47
		v_bitop3_b32 v25, v21, v30, v25 bitop3:0x96
		v_mul_lo_u32 v25, s17, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add_u32_e32 v41, s16, v25
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[26:27]
		v_mov_b64_e32 v[60:61], v[102:103]
		v_mov_b64_e32 v[62:63], v[106:107]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v27, s12
		s_mov_b64 s[26:27], vcc
		s_and_b32 s32, s26, s4
		s_and_b32 s33, s27, s5
		v_add_u32_e32 v27, 0x80, v37
		v_xor_b32_e32 v27, v27, v47
		v_bitop3_b32 v27, v21, v30, v27 bitop3:0x96
		v_mul_lo_u32 v27, s17, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_add_u32_e32 v41, s16, v27
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[32:33]
		v_mov_b64_e32 v[60:61], v[108:109]
		v_mov_b64_e32 v[62:63], v[112:113]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s32, s4
		s_and_b32 s35, s33, s5
		v_add_u32_e32 v8, 0x90, v37
		v_xor_b32_e32 v8, v8, v47
		v_bitop3_b32 v8, v21, v30, v8 bitop3:0x96
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v41, s16, v8
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[34:35]
		v_mov_b64_e32 v[60:61], v[116:117]
		v_mov_b64_e32 v[62:63], v[120:121]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[34:35], vcc
		s_and_b32 s36, s34, s4
		s_and_b32 s37, s35, s5
		v_add_u32_e32 v9, 0xa0, v37
		v_xor_b32_e32 v9, v9, v47
		v_bitop3_b32 v9, v21, v30, v9 bitop3:0x96
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v41, s16, v9
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[36:37]
		v_mov_b64_e32 v[60:61], v[110:111]
		v_mov_b64_e32 v[62:63], v[114:115]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s36, s4
		s_and_b32 s39, s37, s5
		v_add_u32_e32 v10, 0xb0, v37
		v_xor_b32_e32 v10, v10, v47
		v_bitop3_b32 v10, v21, v30, v10 bitop3:0x96
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v41, s16, v10
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[38:39]
		v_mov_b64_e32 v[60:61], v[118:119]
		v_mov_b64_e32 v[62:63], v[122:123]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[38:39], vcc
		s_and_b32 s40, s38, s4
		s_and_b32 s41, s39, s5
		v_add_u32_e32 v11, 0xc0, v37
		v_xor_b32_e32 v11, v11, v47
		v_bitop3_b32 v11, v21, v30, v11 bitop3:0x96
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v41, s16, v11
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[40:41]
		v_mov_b64_e32 v[60:61], v[124:125]
		v_mov_b64_e32 v[62:63], v[128:129]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v12, s12
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s40, s4
		s_and_b32 s43, s41, s5
		v_add_u32_e32 v12, 0xd0, v37
		v_xor_b32_e32 v12, v12, v47
		v_bitop3_b32 v12, v21, v30, v12 bitop3:0x96
		v_mul_lo_u32 v12, s17, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add_u32_e32 v41, s16, v12
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[42:43]
		v_mov_b64_e32 v[60:61], v[132:133]
		v_mov_b64_e32 v[62:63], v[136:137]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v13, s12
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s42, s4
		s_and_b32 s45, s43, s5
		v_add_u32_e32 v13, 0xe0, v37
		v_xor_b32_e32 v13, v13, v47
		v_bitop3_b32 v13, v21, v30, v13 bitop3:0x96
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add_u32_e32 v41, s16, v13
		v_add3_u32 v41, v41, v4, v5
		v_add3_u32 v41, v41, v6, v7
		v_cndmask_b32_e64 v41, v15, v41, s[44:45]
		v_mov_b64_e32 v[60:61], v[126:127]
		v_mov_b64_e32 v[62:63], v[130:131]
		buffer_store_dwordx4 v[60:63], v41, s[28:31], 0 offen
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s44, s4
		s_and_b32 s47, s45, s5
		v_add_u32_e32 v14, 0xf0, v37
		v_xor_b32_e32 v14, v14, v47
		v_bitop3_b32 v14, v21, v30, v14 bitop3:0x96
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v21, s16, v14
		v_add3_u32 v21, v21, v4, v5
		v_add3_u32 v21, v21, v6, v7
		v_cndmask_b32_e64 v21, v15, v21, s[46:47]
		v_mov_b64_e32 v[60:61], v[134:135]
		v_mov_b64_e32 v[62:63], v[138:139]
		buffer_store_dwordx4 v[60:63], v21, s[28:31], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v21, 0xff, v29
		v_lshlrev_b32_e32 v21, 8, v21
		v_or_b32_e32 v0, v0, v21
		v_and_b32_e32 v21, 0xff, v31
		v_lshlrev_b32_e32 v21, 16, v21
		v_and_b32_e32 v29, 0xff, v33
		v_lshlrev_b32_e32 v29, 24, v29
		v_or3_b32 v0, v0, v21, v29
		v_and_b32_e32 v21, 0xff, v35
		v_and_b32_e32 v29, 0xff, v36
		v_lshlrev_b32_e32 v29, 8, v29
		v_or_b32_e32 v21, v21, v29
		v_and_b32_e32 v29, 0xff, v38
		v_lshlrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v30, 0xff, v39
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v21, v21, v29, v30
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], a[0:3], a[128:131], v0, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[0:3], a[132:135], v0, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[8:11], a[148:151], v0, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], a[8:11], a[144:147], v0, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[4:7], a[128:131], v0, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[68:71], a[4:7], a[132:135], v0, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[68:71], a[12:15], a[148:151], v0, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[12:15], a[144:147], v0, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], a[0:3], a[136:139], v21, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[84:87], a[0:3], a[140:143], v21, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], a[8:11], a[156:159], v21, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], a[8:11], a[152:155], v21, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], a[4:7], a[136:139], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], a[4:7], a[140:143], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[88:91], a[12:15], a[156:159], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], a[12:15], a[152:155], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[76:79], a[16:19], a[168:171], v21, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], a[16:19], a[172:175], v21, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[84:87], a[24:27], a[188:191], v21, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[76:79], a[24:27], a[184:187], v21, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], a[20:23], a[168:171], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[88:91], a[20:23], a[172:175], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[88:91], a[28:31], a[188:191], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[80:83], a[28:31], a[184:187], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], a[16:19], a[160:163], v0, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[16:19], a[164:167], v0, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[56:59], a[24:27], a[180:183], v0, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], a[24:27], a[176:179], v0, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[20:23], a[160:163], v0, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[68:71], a[20:23], a[164:167], v0, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[68:71], a[28:31], a[180:183], v0, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], a[28:31], a[176:179], v0, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[48:51], a[32:35], a[192:195], v0, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], a[32:35], a[196:199], v0, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], a[40:43], a[212:215], v0, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[48:51], a[40:43], a[208:211], v0, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[52:55], a[36:39], a[192:195], v0, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[68:71], a[36:39], a[196:199], v0, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[68:71], a[44:47], a[212:215], v0, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[52:55], a[44:47], a[208:211], v0, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[76:79], a[32:35], a[200:203], v21, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[84:87], a[32:35], a[204:207], v21, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[84:87], a[40:43], a[220:223], v21, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[76:79], a[40:43], a[216:219], v21, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[80:83], a[36:39], a[200:203], v21, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[88:91], a[36:39], a[204:207], v21, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[88:91], a[44:47], a[220:223], v21, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[80:83], a[44:47], a[216:219], v21, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[76:79], a[48:51], a[232:235], v21, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[84:87], a[48:51], a[236:239], v21, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[84:87], a[56:59], a[252:255], v21, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[76:79], a[56:59], a[248:251], v21, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[80:83], a[52:55], a[232:235], v21, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[88:91], a[52:55], a[236:239], v21, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[88:91], a[60:63], a[252:255], v21, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[80:83], a[60:63], a[248:251], v21, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[48:51], a[48:51], a[224:227], v0, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[56:59], a[48:51], a[228:231], v0, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[56:59], a[56:59], a[244:247], v0, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[48:51], a[56:59], a[240:243], v0, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[52:55], a[52:55], a[224:227], v0, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[68:71], a[52:55], a[228:231], v0, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[68:71], a[60:63], a[244:247], v0, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[52:55], a[60:63], a[240:243], v0, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s4, s20, 0x80
		v_add_u32_e32 v0, s4, v16
		v_accvgpr_read_b32 v16, a128
		v_accvgpr_read_b32 v17, a129
		v_cvt_pk_bf16_f32 v36, v16, v17
		v_accvgpr_read_b32 v16, a130
		v_accvgpr_read_b32 v17, a131
		v_cvt_pk_bf16_f32 v37, v16, v17
		v_accvgpr_read_b32 v16, a132
		v_accvgpr_read_b32 v17, a133
		v_cvt_pk_bf16_f32 v48, v16, v17
		v_accvgpr_read_b32 v16, a134
		v_accvgpr_read_b32 v17, a135
		v_cvt_pk_bf16_f32 v49, v16, v17
		v_accvgpr_read_b32 v16, a136
		v_accvgpr_read_b32 v17, a137
		v_cvt_pk_bf16_f32 v52, v16, v17
		v_accvgpr_read_b32 v16, a138
		v_accvgpr_read_b32 v17, a139
		v_cvt_pk_bf16_f32 v53, v16, v17
		v_accvgpr_read_b32 v16, a140
		v_accvgpr_read_b32 v17, a141
		v_cvt_pk_bf16_f32 v56, v16, v17
		v_accvgpr_read_b32 v16, a142
		v_accvgpr_read_b32 v17, a143
		v_cvt_pk_bf16_f32 v57, v16, v17
		v_accvgpr_read_b32 v16, a144
		v_accvgpr_read_b32 v17, a145
		v_cvt_pk_bf16_f32 v38, v16, v17
		v_accvgpr_read_b32 v16, a146
		v_accvgpr_read_b32 v17, a147
		v_cvt_pk_bf16_f32 v39, v16, v17
		ds_write_b128 v18, v[36:39] offset:3072
		v_accvgpr_read_b32 v16, a148
		v_accvgpr_read_b32 v17, a149
		v_cvt_pk_bf16_f32 v50, v16, v17
		v_accvgpr_read_b32 v16, a150
		v_accvgpr_read_b32 v17, a151
		v_cvt_pk_bf16_f32 v51, v16, v17
		ds_write_b128 v18, v[48:51] offset:7168
		v_accvgpr_read_b32 v16, a152
		v_accvgpr_read_b32 v17, a153
		v_cvt_pk_bf16_f32 v54, v16, v17
		v_accvgpr_read_b32 v16, a154
		v_accvgpr_read_b32 v17, a155
		v_cvt_pk_bf16_f32 v55, v16, v17
		ds_write_b128 v18, v[52:55] offset:11264
		v_accvgpr_read_b32 v16, a156
		v_accvgpr_read_b32 v17, a157
		v_cvt_pk_bf16_f32 v58, v16, v17
		v_accvgpr_read_b32 v16, a158
		v_accvgpr_read_b32 v17, a159
		v_cvt_pk_bf16_f32 v59, v16, v17
		ds_write_b128 v18, v[56:59] offset:15360
		v_accvgpr_read_b32 v16, a160
		v_accvgpr_read_b32 v17, a161
		v_cvt_pk_bf16_f32 v36, v16, v17
		v_accvgpr_read_b32 v16, a162
		v_accvgpr_read_b32 v17, a163
		v_cvt_pk_bf16_f32 v37, v16, v17
		v_accvgpr_read_b32 v16, a164
		v_accvgpr_read_b32 v17, a165
		v_cvt_pk_bf16_f32 v48, v16, v17
		v_accvgpr_read_b32 v16, a166
		v_accvgpr_read_b32 v17, a167
		v_cvt_pk_bf16_f32 v49, v16, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v16, a168
		v_accvgpr_read_b32 v17, a169
		v_cvt_pk_bf16_f32 v52, v16, v17
		v_accvgpr_read_b32 v16, a170
		v_accvgpr_read_b32 v17, a171
		v_cvt_pk_bf16_f32 v53, v16, v17
		v_accvgpr_read_b32 v16, a172
		v_accvgpr_read_b32 v17, a173
		v_cvt_pk_bf16_f32 v56, v16, v17
		v_accvgpr_read_b32 v16, a174
		v_accvgpr_read_b32 v17, a175
		v_cvt_pk_bf16_f32 v57, v16, v17
		v_accvgpr_read_b32 v16, a176
		v_accvgpr_read_b32 v17, a177
		v_cvt_pk_bf16_f32 v38, v16, v17
		v_accvgpr_read_b32 v16, a178
		v_accvgpr_read_b32 v17, a179
		v_cvt_pk_bf16_f32 v39, v16, v17
		v_accvgpr_read_b32 v16, a180
		v_accvgpr_read_b32 v17, a181
		v_cvt_pk_bf16_f32 v50, v16, v17
		v_accvgpr_read_b32 v16, a182
		v_accvgpr_read_b32 v17, a183
		v_cvt_pk_bf16_f32 v51, v16, v17
		v_accvgpr_read_b32 v16, a184
		v_accvgpr_read_b32 v17, a185
		v_cvt_pk_bf16_f32 v54, v16, v17
		v_accvgpr_read_b32 v16, a186
		v_accvgpr_read_b32 v17, a187
		v_cvt_pk_bf16_f32 v55, v16, v17
		v_accvgpr_read_b32 v16, a188
		v_accvgpr_read_b32 v17, a189
		v_cvt_pk_bf16_f32 v58, v16, v17
		v_accvgpr_read_b32 v16, a190
		v_accvgpr_read_b32 v17, a191
		v_cvt_pk_bf16_f32 v59, v16, v17
		v_accvgpr_read_b32 v16, a192
		v_accvgpr_read_b32 v17, a193
		v_cvt_pk_bf16_f32 v60, v16, v17
		v_accvgpr_read_b32 v16, a194
		v_accvgpr_read_b32 v17, a195
		v_cvt_pk_bf16_f32 v61, v16, v17
		v_accvgpr_read_b32 v16, a196
		v_accvgpr_read_b32 v17, a197
		v_cvt_pk_bf16_f32 v64, v16, v17
		v_accvgpr_read_b32 v16, a198
		v_accvgpr_read_b32 v17, a199
		v_cvt_pk_bf16_f32 v65, v16, v17
		v_accvgpr_read_b32 v16, a200
		v_accvgpr_read_b32 v17, a201
		v_cvt_pk_bf16_f32 v68, v16, v17
		v_accvgpr_read_b32 v16, a202
		v_accvgpr_read_b32 v17, a203
		v_cvt_pk_bf16_f32 v69, v16, v17
		v_accvgpr_read_b32 v16, a204
		v_accvgpr_read_b32 v17, a205
		v_cvt_pk_bf16_f32 v72, v16, v17
		v_accvgpr_read_b32 v16, a206
		v_accvgpr_read_b32 v17, a207
		v_cvt_pk_bf16_f32 v73, v16, v17
		v_accvgpr_read_b32 v16, a208
		v_accvgpr_read_b32 v17, a209
		v_cvt_pk_bf16_f32 v62, v16, v17
		v_accvgpr_read_b32 v16, a210
		v_accvgpr_read_b32 v17, a211
		v_cvt_pk_bf16_f32 v63, v16, v17
		v_accvgpr_read_b32 v16, a212
		v_accvgpr_read_b32 v17, a213
		v_cvt_pk_bf16_f32 v66, v16, v17
		v_accvgpr_read_b32 v16, a214
		v_accvgpr_read_b32 v17, a215
		v_cvt_pk_bf16_f32 v67, v16, v17
		v_accvgpr_read_b32 v16, a216
		v_accvgpr_read_b32 v17, a217
		v_cvt_pk_bf16_f32 v70, v16, v17
		v_accvgpr_read_b32 v16, a218
		v_accvgpr_read_b32 v17, a219
		v_cvt_pk_bf16_f32 v71, v16, v17
		v_accvgpr_read_b32 v16, a220
		v_accvgpr_read_b32 v17, a221
		v_cvt_pk_bf16_f32 v74, v16, v17
		v_accvgpr_read_b32 v16, a222
		v_accvgpr_read_b32 v17, a223
		v_cvt_pk_bf16_f32 v75, v16, v17
		v_accvgpr_read_b32 v16, a224
		v_accvgpr_read_b32 v17, a225
		v_cvt_pk_bf16_f32 v76, v16, v17
		v_accvgpr_read_b32 v16, a226
		v_accvgpr_read_b32 v17, a227
		v_cvt_pk_bf16_f32 v77, v16, v17
		v_accvgpr_read_b32 v16, a228
		v_accvgpr_read_b32 v17, a229
		v_cvt_pk_bf16_f32 v80, v16, v17
		v_accvgpr_read_b32 v16, a230
		v_accvgpr_read_b32 v17, a231
		v_cvt_pk_bf16_f32 v81, v16, v17
		v_accvgpr_read_b32 v16, a232
		v_accvgpr_read_b32 v17, a233
		v_cvt_pk_bf16_f32 v84, v16, v17
		v_accvgpr_read_b32 v16, a234
		v_accvgpr_read_b32 v17, a235
		v_cvt_pk_bf16_f32 v85, v16, v17
		v_accvgpr_read_b32 v16, a236
		v_accvgpr_read_b32 v17, a237
		v_cvt_pk_bf16_f32 v88, v16, v17
		v_accvgpr_read_b32 v16, a238
		v_accvgpr_read_b32 v17, a239
		v_cvt_pk_bf16_f32 v89, v16, v17
		v_accvgpr_read_b32 v16, a240
		v_accvgpr_read_b32 v17, a241
		v_cvt_pk_bf16_f32 v78, v16, v17
		v_accvgpr_read_b32 v16, a242
		v_accvgpr_read_b32 v17, a243
		v_cvt_pk_bf16_f32 v79, v16, v17
		v_accvgpr_read_b32 v16, a244
		v_accvgpr_read_b32 v17, a245
		v_cvt_pk_bf16_f32 v82, v16, v17
		v_accvgpr_read_b32 v16, a246
		v_accvgpr_read_b32 v17, a247
		v_cvt_pk_bf16_f32 v83, v16, v17
		v_accvgpr_read_b32 v16, a248
		v_accvgpr_read_b32 v17, a249
		v_cvt_pk_bf16_f32 v86, v16, v17
		v_accvgpr_read_b32 v16, a250
		v_accvgpr_read_b32 v17, a251
		v_cvt_pk_bf16_f32 v87, v16, v17
		v_accvgpr_read_b32 v16, a252
		v_accvgpr_read_b32 v17, a253
		v_cvt_pk_bf16_f32 v90, v16, v17
		v_accvgpr_read_b32 v16, a254
		v_accvgpr_read_b32 v17, a255
		v_cvt_pk_bf16_f32 v91, v16, v17
		ds_read_b128 v[92:95], v1 offset:3072
		ds_read_b128 v[96:99], v1 offset:3328
		ds_read_b128 v[100:103], v1 offset:5120
		ds_read_b128 v[104:107], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[36:39] offset:3072
		ds_write_b128 v18, v[48:51] offset:7168
		ds_write_b128 v18, v[52:55] offset:11264
		ds_write_b128 v18, v[56:59] offset:15360
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s12, s2, s4
		s_and_b32 s13, s3, s5
		s_add_i32 s0, s0, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v1 offset:3072
		ds_read_b128 v[48:51], v1 offset:3328
		ds_read_b128 v[52:55], v1 offset:5120
		ds_read_b128 v[56:59], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[60:63] offset:3072
		ds_write_b128 v18, v[64:67] offset:7168
		ds_write_b128 v18, v[68:71] offset:11264
		ds_write_b128 v18, v[72:75] offset:15360
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s21
		v_add3_u32 v0, s0, v23, v28
		v_add3_u32 v0, v0, v34, v45
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[28:31], v1 offset:3072
		ds_read_b128 v[44:47], v1 offset:3328
		ds_read_b128 v[60:63], v1 offset:5120
		ds_read_b128 v[64:67], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v18, v[76:79] offset:3072
		ds_write_b128 v18, v[80:83] offset:7168
		ds_write_b128 v18, v[84:87] offset:11264
		ds_write_b128 v18, v[88:91] offset:15360
		v_add3_u32 v0, v0, v4, v5
		v_add3_u32 v0, v0, v6, v7
		v_cndmask_b32_e64 v0, v15, v0, s[12:13]
		v_mov_b64_e32 v[16:17], v[92:93]
		v_mov_b64_e32 v[18:19], v[96:97]
		buffer_store_dwordx4 v[16:19], v0, s[28:31], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:3072
		ds_read_b128 v[68:71], v1 offset:3328
		ds_read_b128 v[72:75], v1 offset:5120
		ds_read_b128 v[76:79], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s2, s10, s4
		s_and_b32 s3, s11, s5
		v_add3_u32 v0, v4, v5, v6
		v_add_u32_e32 v0, v0, v7
		v_add3_u32 v1, v32, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[32:33], v[100:101]
		v_mov_b64_e32 v[34:35], v[104:105]
		buffer_store_dwordx4 v[32:35], v1, s[28:31], 0 offen
		s_and_b32 s2, s14, s4
		s_and_b32 s3, s15, s5
		v_add3_u32 v1, v22, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[94:95]
		v_mov_b64_e32 v[22:23], v[98:99]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s18, s4
		s_and_b32 s3, s19, s5
		v_add3_u32 v0, v40, v0, s0
		v_cndmask_b32_e64 v0, v15, v0, s[2:3]
		v_mov_b64_e32 v[20:21], v[102:103]
		v_mov_b64_e32 v[22:23], v[106:107]
		buffer_store_dwordx4 v[20:23], v0, s[28:31], 0 offen
		s_and_b32 s2, s6, s4
		s_and_b32 s3, s7, s5
		v_add3_u32 v0, v4, v5, v6
		v_add_u32_e32 v0, v0, v7
		v_add3_u32 v1, v2, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[36:37]
		v_mov_b64_e32 v[22:23], v[48:49]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s8, s4
		s_and_b32 s3, s9, s5
		v_add3_u32 v1, v3, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[52:53]
		v_mov_b64_e32 v[22:23], v[56:57]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s22, s4
		s_and_b32 s3, s23, s5
		v_add3_u32 v0, v24, v0, s0
		v_cndmask_b32_e64 v0, v15, v0, s[2:3]
		v_mov_b64_e32 v[20:21], v[38:39]
		v_mov_b64_e32 v[22:23], v[50:51]
		buffer_store_dwordx4 v[20:23], v0, s[28:31], 0 offen
		s_and_b32 s2, s24, s4
		s_and_b32 s3, s25, s5
		v_add3_u32 v0, v4, v5, v6
		v_add_u32_e32 v0, v0, v7
		v_add3_u32 v1, v25, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[54:55]
		v_mov_b64_e32 v[22:23], v[58:59]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s26, s4
		s_and_b32 s3, s27, s5
		v_add3_u32 v1, v27, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[28:29]
		v_mov_b64_e32 v[22:23], v[44:45]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s32, s4
		s_and_b32 s3, s33, s5
		v_add3_u32 v0, v8, v0, s0
		v_cndmask_b32_e64 v0, v15, v0, s[2:3]
		v_mov_b64_e32 v[20:21], v[60:61]
		v_mov_b64_e32 v[22:23], v[64:65]
		buffer_store_dwordx4 v[20:23], v0, s[28:31], 0 offen
		s_and_b32 s2, s34, s4
		s_and_b32 s3, s35, s5
		v_add3_u32 v0, v4, v5, v6
		v_add_u32_e32 v0, v0, v7
		v_add3_u32 v1, v9, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[30:31]
		v_mov_b64_e32 v[22:23], v[46:47]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s36, s4
		s_and_b32 s3, s37, s5
		v_add3_u32 v1, v10, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[20:21], v[62:63]
		v_mov_b64_e32 v[22:23], v[66:67]
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen
		s_and_b32 s2, s38, s4
		s_and_b32 s3, s39, s5
		v_add3_u32 v0, v11, v0, s0
		v_cndmask_b32_e64 v0, v15, v0, s[2:3]
		v_mov_b64_e32 v[8:9], v[16:17]
		v_mov_b64_e32 v[10:11], v[68:69]
		buffer_store_dwordx4 v[8:11], v0, s[28:31], 0 offen
		s_and_b32 s2, s40, s4
		s_and_b32 s3, s41, s5
		v_add3_u32 v0, v4, v5, v6
		v_add_u32_e32 v0, v0, v7
		v_add3_u32 v1, v12, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[4:5], v[72:73]
		v_mov_b64_e32 v[6:7], v[76:77]
		buffer_store_dwordx4 v[4:7], v1, s[28:31], 0 offen
		s_and_b32 s2, s42, s4
		s_and_b32 s3, s43, s5
		v_add3_u32 v1, v13, v0, s0
		v_cndmask_b32_e64 v1, v15, v1, s[2:3]
		v_mov_b64_e32 v[4:5], v[18:19]
		v_mov_b64_e32 v[6:7], v[70:71]
		buffer_store_dwordx4 v[4:7], v1, s[28:31], 0 offen
		s_and_b32 s2, s44, s4
		s_and_b32 s3, s45, s5
		v_add3_u32 v0, v14, v0, s0
		v_cndmask_b32_e64 v0, v15, v0, s[2:3]
		v_mov_b64_e32 v[4:5], v[74:75]
		v_mov_b64_e32 v[6:7], v[78:79]
		buffer_store_dwordx4 v[4:7], v0, s[28:31], 0 offen
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
		.amdhsa_next_free_vgpr 512
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
	.set .L_a4w4_kernel.num_agpr, 256
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
    .vgpr_count:     512
    .agpr_count:     256
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
