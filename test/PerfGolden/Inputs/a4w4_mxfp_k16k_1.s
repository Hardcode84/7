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
		s_xor_b32 s23, s22, -1
		v_readfirstlane_b32 s24, v1
		s_add_i32 s23, s23, 1
		s_mul_i32 s25, s23, s24
		s_mul_hi_u32 s25, s24, s25
		s_add_i32 s24, s24, s25
		s_mul_hi_u32 s24, s20, s24
		s_mul_i32 s25, s24, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s20, s20, s25
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s24, s26, s24
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s20, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s20, s26, s20
		s_cmp_ge_u32 s20, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s24, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s24
		s_cselect_b32 s24, 1, 0
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
		s_add_i32 s22, s20, s23
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s20, s22, s20
		s_xor_b32 s22, s20, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s22, s20
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s21, s0, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s21, s21, 1
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s23, s21, s22
		s_mul_hi_u32 s23, s22, s23
		s_add_i32 s22, s22, s23
		s_mul_hi_u32 s22, s20, s22
		s_mul_i32 s22, s22, s0
		s_xor_b32 s22, s22, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s20, s22
		s_add_i32 s23, s22, s21
		s_cmp_ge_u32 s22, s0
		s_cselect_b32 s22, s23, s22
		s_add_i32 s23, s22, s21
		s_cmp_ge_u32 s22, s0
		s_cselect_b32 s22, s23, s22
		s_add_i32 s16, s16, s22
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s21, s23
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
		s_add_i32 s21, s20, s21
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s20, s21, s20
		s_add_i32 s21, s23, 1
		s_cmp_ge_u32 s20, s0
		s_cselect_b32 s0, s21, s23
		s_mul_i32 s16, s16, 0x100
		v_lshrrev_b32_e32 v1, 4, v0
		v_and_b32_e32 v2, 15, v1
		v_and_b32_e32 v3, 15, v0
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
		s_mul_i32 s4, s22, s14
		s_lshl_b32 s4, s4, 8
		s_add_i32 s5, s3, s4
		v_lshrrev_b32_e32 v4, 3, v0
		v_mul_lo_u32 v5, s14, v4
		v_lshlrev_b32_e32 v6, 4, v0
		v_and_b32_e32 v7, 0x7f, v6
		v_add3_u32 v8, s5, v5, v7
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		v_mov_b32_e32 v12, 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_lshl_b32 s8, s14, 5
		s_add_i32 s9, s8, s3
		s_add_i32 s9, s9, s4
		v_add3_u32 v8, s9, v5, v7
		s_add_i32 m0, s2, 0x1000
		v_add_u32_e32 v9, 0x50, v2
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_lshl_b32 s10, s14, 6
		s_add_i32 s11, s10, s3
		s_add_i32 s11, s11, s4
		v_add3_u32 v8, s11, v5, v7
		s_add_i32 m0, s2, 0x2000
		v_add_u32_e32 v10, 0x60, v2
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mul_i32 s20, 0x60, s14
		s_add_i32 s21, s20, s3
		s_add_i32 s21, s21, s4
		v_add3_u32 v8, s21, v5, v7
		s_add_i32 m0, s2, 0x3000
		v_add_u32_e32 v11, 0x70, v2
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_add3_u32 v8, 48, v2, s16
		s_lshl_b32 s23, s14, 7
		s_add_i32 s40, s23, s3
		s_add_i32 s40, s40, s4
		v_add3_u32 v13, s40, v5, v7
		s_add_i32 m0, s2, 0x4000
		v_add_u32_e32 v14, 0x80, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add3_u32 v16, 64, v2, s16
		s_mul_i32 s41, 0xa0, s14
		s_add_i32 s42, s41, s3
		s_add_i32 s42, s42, s4
		v_add3_u32 v13, s42, v5, v7
		s_add_i32 m0, s2, 0x5000
		v_add_u32_e32 v15, 0x90, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v9, s16, v9
		s_mul_i32 s43, 0xc0, s14
		s_add_i32 s44, s43, s3
		s_add_i32 s44, s44, s4
		v_add3_u32 v13, s44, v5, v7
		s_add_i32 m0, s2, 0x6000
		v_add_u32_e32 v17, 0xa0, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v10, s16, v10
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s45, s14, s3
		s_add_i32 s45, s45, s4
		v_add3_u32 v13, s45, v5, v7
		s_add_i32 m0, s2, 0x7000
		v_add_u32_e32 v18, 0xb0, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v11, s16, v11
		s_mul_i32 s46, s0, s15
		s_lshl_b32 s46, s46, 8
		v_mul_lo_u32 v19, s15, v4
		v_add3_u32 v13, s46, v19, v7
		s_add_i32 m0, s2, 0x10000
		v_add_u32_e32 v20, 0xc0, v2
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_add_u32_e32 v21, s16, v14
		s_lshl_b32 s47, s15, 5
		s_add_i32 s48, s47, s46
		v_add3_u32 v13, s48, v19, v7
		s_add_i32 m0, s2, 0x11000
		v_add_u32_e32 v14, 0xd0, v2
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_add_u32_e32 v22, s16, v15
		s_lshl_b32 s49, s15, 6
		s_add_i32 s50, s49, s46
		v_add3_u32 v13, s50, v19, v7
		s_add_i32 m0, s2, 0x12000
		v_add_u32_e32 v15, 0xe0, v2
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_add_u32_e32 v17, s16, v17
		s_mul_i32 s51, 0x60, s15
		s_add_i32 s52, s51, s46
		v_add3_u32 v13, s52, v19, v7
		s_add_i32 m0, s2, 0x13000
		v_add_u32_e32 v23, 0xf0, v2
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s53, s1, s18
		s_lshl_b32 s53, s53, 10
		s_mul_i32 s54, s22, s18
		s_lshl_b32 s54, s54, 8
		s_add_i32 s55, s53, s54
		v_lshrrev_b32_e32 v24, 7, v0
		v_mul_lo_u32 v13, s18, v24
		v_lshlrev_b32_e32 v25, 7, v13
		v_and_b32_e32 v26, 1, v0
		v_mul_lo_u32 v27, s18, v26
		v_add3_u32 v28, s55, v25, v27
		v_lshrrev_b32_e32 v29, 6, v0
		v_and_b32_e32 v29, 1, v29
		v_mul_lo_u32 v30, s18, v29
		v_lshlrev_b32_e32 v31, 6, v30
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mul_lo_u32 v33, s18, v32
		v_lshlrev_b32_e32 v34, 5, v33
		v_add3_u32 v28, v28, v31, v34
		v_and_b32_e32 v35, 1, v1
		v_mul_lo_u32 v36, s18, v35
		v_lshlrev_b32_e32 v37, 4, v36
		v_and_b32_e32 v4, 1, v4
		v_mul_lo_u32 v38, s18, v4
		v_lshlrev_b32_e32 v39, 3, v38
		v_add3_u32 v28, v28, v37, v39
		v_lshrrev_b32_e32 v40, 2, v0
		v_and_b32_e32 v40, 1, v40
		v_mul_lo_u32 v41, s18, v40
		v_lshlrev_b32_e32 v41, 2, v41
		v_lshrrev_b32_e32 v42, 1, v0
		v_and_b32_e32 v42, 1, v42
		v_mul_lo_u32 v43, s18, v42
		v_lshlrev_b32_e32 v43, 1, v43
		v_add3_u32 v28, v28, v41, v43
		buffer_load_dwordx2 v[44:45], v28, s[32:35], 0 offen
		s_mul_i32 s56, s0, s19
		s_lshl_b32 s56, s56, 8
		v_mul_lo_u32 v28, s19, v24
		v_lshlrev_b32_e32 v46, 6, v28
		v_mul_lo_u32 v47, s19, v29
		v_lshlrev_b32_e32 v48, 5, v47
		v_add3_u32 v49, s56, v46, v48
		v_mul_lo_u32 v50, s19, v32
		v_lshlrev_b32_e32 v51, 4, v50
		v_mul_lo_u32 v52, s19, v35
		v_lshlrev_b32_e32 v53, 3, v52
		v_add3_u32 v49, v49, v51, v53
		v_mul_lo_u32 v54, s19, v4
		v_lshlrev_b32_e32 v55, 2, v54
		v_mul_lo_u32 v56, s19, v40
		v_lshlrev_b32_e32 v56, 1, v56
		v_add3_u32 v49, v49, v55, v56
		v_mul_lo_u32 v57, s19, v42
		v_lshlrev_b32_e32 v58, 2, v26
		v_add3_u32 v49, v49, v57, v58
		buffer_load_dword v59, v49, s[36:39], 0 offen
		v_add_u32_e32 v18, s16, v18
		s_lshl_b32 s57, s15, 7
		s_add_i32 s58, s57, s46
		v_add3_u32 v49, s58, v19, v7
		s_add_i32 m0, s2, 0x18000
		v_mov_b32_e32 v60, 8
		v_mul_lo_u32 v60, v60, v3
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s16, v20
		s_mul_i32 s59, 0xa0, s15
		s_add_i32 s60, s59, s46
		v_add3_u32 v20, s60, v19, v7
		s_add_i32 m0, s2, 0x19000
		s_mul_i32 s61, s0, 0x100
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_add_u32_e32 v20, s16, v14
		s_mul_i32 s62, 0xc0, s15
		s_add_i32 s63, s62, s46
		v_add3_u32 v14, s63, v19, v7
		s_add_i32 m0, s2, 0x1a000
		v_add_u32_e32 v49, s16, v2
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_add_u32_e32 v61, s16, v15
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s64, s15, s46
		v_add3_u32 v14, s64, v19, v7
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v62, 16, v2, s16
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_add_u32_e32 v23, s16, v23
		s_lshl_b32 s65, s19, 7
		s_add_i32 s66, s65, s56
		v_lshlrev_b32_e32 v28, 4, v28
		v_lshlrev_b32_e32 v47, 3, v47
		v_add3_u32 v14, s66, v28, v47
		v_lshlrev_b32_e32 v50, 2, v50
		v_lshlrev_b32_e32 v52, 1, v52
		v_add3_u32 v14, v14, v50, v52
		v_add3_u32 v14, v14, v54, v26
		v_lshlrev_b32_e32 v63, 2, v40
		v_lshlrev_b32_e32 v64, 1, v42
		v_add3_u32 v14, v14, v63, v64
		v_lshlrev_b32_e32 v15, 4, v24
		v_lshlrev_b32_e32 v65, 3, v29
		v_lshlrev_b32_e32 v66, 2, v32
		v_add_u32_e32 v67, 32, v4
		v_lshlrev_b32_e32 v68, 1, v35
		v_bitop3_b32 v67, v66, v67, v68 bitop3:0x96
		v_bitop3_b32 v67, v15, v65, v67 bitop3:0x96
		v_mul_lo_u32 v69, s19, v67
		v_add3_u32 v70, v26, v63, v64
		v_add3_u32 v71, v69, v70, s66
		v_add_u32_e32 v72, 64, v4
		v_bitop3_b32 v72, v66, v72, v68 bitop3:0x96
		v_bitop3_b32 v72, v15, v65, v72 bitop3:0x96
		v_mul_lo_u32 v73, s19, v72
		v_add3_u32 v74, v73, v70, s66
		v_add_u32_e32 v75, 0x60, v4
		v_bitop3_b32 v75, v66, v75, v68 bitop3:0x96
		v_bitop3_b32 v75, v15, v65, v75 bitop3:0x96
		v_mul_lo_u32 v76, s19, v75
		v_add3_u32 v70, v76, v70, s66
		buffer_load_ubyte v77, v14, s[36:39], 0 offen
		buffer_load_ubyte v78, v71, s[36:39], 0 offen
		buffer_load_ubyte v71, v74, s[36:39], 0 offen
		buffer_load_ubyte v74, v70, s[36:39], 0 offen
		s_add_i32 s19, s3, 0x80
		s_add_i32 s19, s19, s4
		v_add3_u32 v14, s19, v5, v7
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v2, 32, v2, s16
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		v_add_u32_e32 v70, s61, v60
		s_add_i32 s8, s8, 0x80
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v14, s8, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s4
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v14, s10, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s16, s20, 0x80
		s_add_i32 s16, s16, s3
		s_add_i32 s16, s16, s4
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v14, s16, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s20, s23, 0x80
		s_add_i32 s20, s20, s3
		s_add_i32 s20, s20, s4
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v14, s20, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s23, s41, 0x80
		s_add_i32 s23, s23, s3
		s_add_i32 s23, s23, s4
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v14, s23, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s41, s43, 0x80
		s_add_i32 s41, s41, s3
		s_add_i32 s41, s41, s4
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v14, s41, v5, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s4
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v14, s3, v5, v7
		s_add_i32 s4, s46, 0x80
		v_add3_u32 v79, s4, v19, v7
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s14, s47, 0x80
		s_add_i32 s14, s14, s46
		v_add3_u32 v14, s14, v19, v7
		v_lshlrev_b32_e32 v80, 4, v13
		v_lshlrev_b32_e32 v30, 3, v30
		buffer_load_dwordx4 v79, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s43, s49, 0x80
		s_add_i32 s43, s43, s46
		v_add3_u32 v13, s43, v19, v7
		v_lshlrev_b32_e32 v33, 2, v33
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s47, s51, 0x80
		s_add_i32 s47, s47, s46
		v_add3_u32 v14, s47, v19, v7
		v_lshlrev_b32_e32 v36, 1, v36
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s49, s53, 8
		s_add_i32 s49, s49, s54
		v_add3_u32 v13, s49, v80, v30
		v_add3_u32 v13, v13, v33, v36
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_add3_u32 v13, v13, v38, v26
		v_add3_u32 v13, v13, v63, v64
		v_mul_lo_u32 v79, s18, v67
		v_add3_u32 v14, s49, v79, v26
		v_add3_u32 v14, v14, v63, v64
		v_mul_lo_u32 v81, s18, v72
		v_add3_u32 v82, v26, v63, v64
		v_add3_u32 v83, v81, v82, s49
		v_mul_lo_u32 v84, s18, v75
		v_add3_u32 v85, v84, v82, s49
		v_add_u32_e32 v86, 0x80, v4
		v_bitop3_b32 v86, v66, v86, v68 bitop3:0x96
		v_bitop3_b32 v86, v15, v65, v86 bitop3:0x96
		v_mul_lo_u32 v87, s18, v86
		v_add3_u32 v82, v87, v82, s49
		v_add_u32_e32 v88, 0xa0, v4
		v_bitop3_b32 v88, v66, v88, v68 bitop3:0x96
		v_bitop3_b32 v88, v15, v65, v88 bitop3:0x96
		v_mul_lo_u32 v89, s18, v88
		v_add3_u32 v90, v26, v63, v64
		v_add3_u32 v91, v89, v90, s49
		v_add_u32_e32 v92, 0xc0, v4
		v_bitop3_b32 v92, v66, v92, v68 bitop3:0x96
		v_bitop3_b32 v92, v15, v65, v92 bitop3:0x96
		v_mul_lo_u32 v93, s18, v92
		v_add3_u32 v94, v93, v90, s49
		v_add_u32_e32 v95, 0xe0, v4
		v_bitop3_b32 v66, v66, v95, v68 bitop3:0x96
		v_bitop3_b32 v65, v15, v65, v66 bitop3:0x96
		v_mul_lo_u32 v66, s18, v65
		v_add3_u32 v68, v66, v90, s49
		buffer_load_ubyte v90, v13, s[32:35], 0 offen
		buffer_load_ubyte v95, v14, s[32:35], 0 offen
		buffer_load_ubyte v96, v83, s[32:35], 0 offen
		buffer_load_ubyte v83, v85, s[32:35], 0 offen
		buffer_load_ubyte v85, v82, s[32:35], 0 offen
		buffer_load_ubyte v82, v91, s[32:35], 0 offen
		buffer_load_ubyte v91, v94, s[32:35], 0 offen
		buffer_load_ubyte v94, v68, s[32:35], 0 offen
		s_add_i32 s18, s56, 8
		v_add3_u32 v13, s18, v28, v47
		v_add3_u32 v13, v13, v50, v52
		v_add3_u32 v13, v13, v54, v26
		v_add3_u32 v13, v13, v63, v64
		v_add3_u32 v14, v26, v63, v64
		v_add3_u32 v68, v69, v14, s18
		v_add3_u32 v97, v73, v14, s18
		v_add3_u32 v14, v76, v14, s18
		buffer_load_ubyte v98, v13, s[36:39], 0 offen
		buffer_load_ubyte v99, v68, s[36:39], 0 offen
		buffer_load_ubyte v68, v97, s[36:39], 0 offen
		buffer_load_ubyte v97, v14, s[36:39], 0 offen
		s_add_i32 s51, s57, 0x80
		s_add_i32 s51, s51, s46
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v13, s51, v19, v7
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s53, s59, 0x80
		s_add_i32 s53, s53, s46
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v13, s53, v19, v7
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s54, s62, 0x80
		s_add_i32 s54, s54, s46
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v13, s54, v19, v7
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s46
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v13, s15, v19, v7
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_add_i32 s57, s65, 8
		s_add_i32 s57, s57, s56
		v_add3_u32 v13, s57, v28, v47
		v_add3_u32 v13, v13, v50, v52
		v_add3_u32 v13, v13, v54, v26
		v_add3_u32 v13, v13, v63, v64
		v_add3_u32 v14, v26, v63, v64
		v_add3_u32 v100, v69, v14, s57
		v_add3_u32 v101, v73, v14, s57
		v_add3_u32 v14, v76, v14, s57
		buffer_load_ubyte v102, v13, s[36:39], 0 offen
		buffer_load_ubyte v103, v100, s[36:39], 0 offen
		buffer_load_ubyte v100, v101, s[36:39], 0 offen
		buffer_load_ubyte v101, v14, s[36:39], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v13, 11, v24
		v_and_b32_e32 v14, 63, v0
		v_lshrrev_b32_e32 v104, 4, v14
		v_lshlrev_b32_e32 v104, 4, v104
		v_and_b32_e32 v14, 15, v14
		v_lshlrev_b32_e32 v14, 7, v14
		v_add3_u32 v105, v13, v104, v14
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
		v_add_u32_e32 v13, 0x10000, v104
		v_lshlrev_b32_e32 v104, 11, v29
		v_add3_u32 v104, v13, v104, v14
		ds_read_b128 a[64:67], v104
		ds_read_b128 a[68:71], v104 offset:64
		ds_read_b128 a[72:75], v104 offset:4096
		ds_read_b128 a[76:79], v104 offset:4160
		ds_read_b128 a[80:83], v104 offset:8192
		ds_read_b128 a[84:87], v104 offset:8256
		ds_read_b128 a[88:91], v104 offset:12288
		ds_read_b128 a[92:95], v104 offset:12352
		v_lshlrev_b32_e32 v13, 3, v0
		v_add_u32_e32 v106, 0x20000, v13
		s_waitcnt vmcnt(41)
		ds_write_b64 v106, v[44:45]
		v_lshlrev_b32_e32 v13, 2, v0
		v_add_u32_e32 v44, 0x20000, v13
		v_lshlrev_b32_e32 v13, 7, v24
		v_add_u32_e32 v13, 0x20000, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(40)
		ds_write_b32 v44, v59 offset:2048
		v_lshlrev_b32_e32 v14, 3, v26
		v_add_u32_e32 v13, v13, v14
		v_lshlrev_b32_e32 v45, 1, v32
		v_add_u32_e32 v59, v13, v45
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v107, 6, v4
		v_add3_u32 v59, v59, v35, v107
		v_lshlrev_b32_e32 v108, 5, v40
		v_lshlrev_b32_e32 v109, 4, v42
		v_add3_u32 v59, v59, v108, v109
		ds_read_u8 v110, v59
		v_add3_u32 v13, v13, v107, v108
		v_add_u32_e32 v111, 4, v35
		v_xor_b32_e32 v111, v111, v45
		v_add3_u32 v112, v13, v109, v111
		ds_read_u8 v113, v112
		v_add_u32_e32 v13, 0x20000, v45
		v_add_u32_e32 v13, v13, v35
		v_lshlrev_b32_e32 v114, 3, v4
		v_add_u32_e32 v115, 32, v26
		v_xor_b32_e32 v115, v115, v64
		v_bitop3_b32 v115, v114, v63, v115 bitop3:0x96
		v_xor_b32_e32 v116, v15, v115
		v_lshl_add_u32 v117, v116, 3, v13
		ds_read_u8 v118, v117
		v_add_u32_e32 v119, 0x20000, v111
		v_lshl_add_u32 v116, v116, 3, v119
		ds_read_u8 v120, v116
		v_add_u32_e32 v121, 64, v26
		v_xor_b32_e32 v121, v121, v64
		v_bitop3_b32 v121, v114, v63, v121 bitop3:0x96
		v_xor_b32_e32 v122, v15, v121
		v_lshl_add_u32 v123, v122, 3, v13
		ds_read_u8 v124, v123
		v_lshl_add_u32 v122, v122, 3, v119
		ds_read_u8 v125, v122
		v_add_u32_e32 v126, 0x60, v26
		v_xor_b32_e32 v126, v126, v64
		v_bitop3_b32 v126, v114, v63, v126 bitop3:0x96
		v_xor_b32_e32 v127, v15, v126
		v_lshl_add_u32 v128, v127, 3, v13
		ds_read_u8 v129, v128
		v_lshl_add_u32 v127, v127, 3, v119
		ds_read_u8 v130, v127
		v_add_u32_e32 v131, 0x80, v26
		v_bitop3_b32 v131, v63, v131, v64 bitop3:0x96
		v_bitop3_b32 v131, v15, v114, v131 bitop3:0x96
		v_lshl_add_u32 v132, v131, 3, v13
		ds_read_u8 v133, v132
		v_lshl_add_u32 v131, v131, 3, v119
		ds_read_u8 v134, v131
		v_add_u32_e32 v135, 0xa0, v26
		v_bitop3_b32 v135, v63, v135, v64 bitop3:0x96
		v_bitop3_b32 v135, v15, v114, v135 bitop3:0x96
		v_lshl_add_u32 v136, v135, 3, v13
		ds_read_u8 v137, v136
		v_lshl_add_u32 v135, v135, 3, v119
		ds_read_u8 v138, v135
		v_add_u32_e32 v139, 0xc0, v26
		v_bitop3_b32 v139, v63, v139, v64 bitop3:0x96
		v_bitop3_b32 v139, v15, v114, v139 bitop3:0x96
		v_lshl_add_u32 v140, v139, 3, v13
		ds_read_u8 v141, v140
		v_lshl_add_u32 v139, v139, 3, v119
		ds_read_u8 v142, v139
		v_add_u32_e32 v143, 0xe0, v26
		v_bitop3_b32 v143, v63, v143, v64 bitop3:0x96
		v_bitop3_b32 v15, v15, v114, v143 bitop3:0x96
		v_lshl_add_u32 v114, v15, 3, v13
		ds_read_u8 v143, v114
		v_lshl_add_u32 v144, v15, 3, v119
		ds_read_u8 v145, v144
		v_add_u32_e32 v14, 0x20000, v14
		v_lshl_add_u32 v14, v29, 7, v14
		v_add_u32_e32 v15, v14, v45
		v_add3_u32 v15, v15, v35, v107
		v_add3_u32 v146, v15, v108, v109
		ds_read_u8 v147, v146 offset:2048
		v_add3_u32 v14, v14, v107, v108
		v_add3_u32 v107, v14, v109, v111
		ds_read_u8 v108, v107 offset:2048
		v_lshlrev_b32_e32 v14, 4, v29
		v_xor_b32_e32 v15, v14, v115
		v_lshl_add_u32 v109, v15, 3, v13
		ds_read_u8 v111, v109 offset:2048
		v_lshl_add_u32 v115, v15, 3, v119
		ds_read_u8 v148, v115 offset:2048
		v_xor_b32_e32 v15, v14, v121
		v_lshl_add_u32 v121, v15, 3, v13
		ds_read_u8 v149, v121 offset:2048
		v_lshl_add_u32 v150, v15, 3, v119
		ds_read_u8 v151, v150 offset:2048
		v_xor_b32_e32 v14, v14, v126
		v_lshl_add_u32 v126, v14, 3, v13
		ds_read_u8 v152, v126 offset:2048
		v_lshl_add_u32 v119, v14, 3, v119
		ds_read_u8 v153, v119 offset:2048
		s_mov_b32 s59, 0x100
		s_mov_b32 s62, s59
		s_mov_b32 s59, 16
		s_mov_b32 s65, s59
		s_mov_b32 s59, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v13, 0x20000, v26
		v_add3_u32 v13, v13, v63, v64
		v_lshl_add_u32 v67, v67, 3, v13
		v_lshl_add_u32 v72, v72, 3, v13
		v_lshl_add_u32 v75, v75, 3, v13
		v_lshl_add_u32 v86, v86, 3, v13
		v_lshl_add_u32 v88, v88, 3, v13
		v_lshl_add_u32 v92, v92, 3, v13
		v_lshl_add_u32 v65, v65, 3, v13
		v_add3_u32 v154, v26, v63, v64
		v_add3_u32 v155, v26, v63, v64
		v_add3_u32 v156, v26, v63, v64
		v_add3_u32 v157, v26, v63, v64
		v_add3_u32 v158, v26, v63, v64
		v_mov_b32_e32 v13, 0
		v_mov_b64_e32 v[14:15], 0
		s_mov_b32 s67, s62
		s_mov_b32 s68, s65
		v_mov_b32_e32 v160, v12
		v_mov_b32_e32 v161, v13
		v_mov_b32_e32 v162, v14
		v_mov_b32_e32 v163, v15
		v_accvgpr_write_b32 a96, v160
		v_accvgpr_write_b32 a97, v161
		v_accvgpr_write_b32 a98, v162
		v_accvgpr_write_b32 a99, v163
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
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a100, v252
		v_accvgpr_write_b32 a101, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a102, v252
		v_accvgpr_write_b32 a103, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a104, v252
		v_accvgpr_write_b32 a105, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a106, v252
		v_accvgpr_write_b32 a107, v253
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
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a182, v252
		v_accvgpr_write_b32 a183, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a184, v252
		v_accvgpr_write_b32 a185, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a186, v252
		v_accvgpr_write_b32 a187, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a188, v252
		v_accvgpr_write_b32 a189, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a190, v252
		v_accvgpr_write_b32 a191, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a192, v252
		v_accvgpr_write_b32 a193, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a194, v252
		v_accvgpr_write_b32 a195, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a196, v252
		v_accvgpr_write_b32 a197, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a198, v252
		v_accvgpr_write_b32 a199, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a200, v252
		v_accvgpr_write_b32 a201, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a202, v252
		v_accvgpr_write_b32 a203, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a204, v252
		v_accvgpr_write_b32 a205, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a206, v252
		v_accvgpr_write_b32 a207, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a208, v252
		v_accvgpr_write_b32 a209, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a210, v252
		v_accvgpr_write_b32 a211, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a212, v252
		v_accvgpr_write_b32 a213, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a214, v252
		v_accvgpr_write_b32 a215, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a216, v252
		v_accvgpr_write_b32 a217, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a218, v252
		v_accvgpr_write_b32 a219, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a220, v252
		v_accvgpr_write_b32 a221, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a222, v252
		v_accvgpr_write_b32 a223, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a224, v252
		v_accvgpr_write_b32 a225, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a226, v252
		v_accvgpr_write_b32 a227, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a228, v252
		v_accvgpr_write_b32 a229, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a230, v252
		v_accvgpr_write_b32 a231, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a232, v252
		v_accvgpr_write_b32 a233, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a234, v252
		v_accvgpr_write_b32 a235, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a236, v252
		v_accvgpr_write_b32 a237, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a238, v252
		v_accvgpr_write_b32 a239, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a240, v252
		v_accvgpr_write_b32 a241, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a242, v252
		v_accvgpr_write_b32 a243, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a244, v252
		v_accvgpr_write_b32 a245, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a246, v252
		v_accvgpr_write_b32 a247, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a248, v252
		v_accvgpr_write_b32 a249, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a250, v252
		v_accvgpr_write_b32 a251, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a252, v252
		v_accvgpr_write_b32 a253, v253
		v_mov_b64_e32 v[252:253], 0
		v_accvgpr_write_b32 a254, v252
		v_accvgpr_write_b32 a255, v253
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v110, 0xff, v110
		v_and_b32_e32 v113, 0xff, v113
		v_lshlrev_b32_e32 v113, 8, v113
		v_or_b32_e32 v110, v110, v113
		v_and_b32_e32 v113, 0xff, v118
		v_lshlrev_b32_e32 v113, 16, v113
		v_and_b32_e32 v118, 0xff, v120
		v_lshlrev_b32_e32 v118, 24, v118
		v_or3_b32 v110, v110, v113, v118
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
		v_and_b32_e32 v125, 0xff, v145
		v_lshlrev_b32_e32 v125, 24, v125
		v_or3_b32 v120, v120, v124, v125
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v124, 0xff, v147
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v108, 0xff, v108
		v_lshlrev_b32_e32 v108, 8, v108
		v_or_b32_e32 v108, v124, v108
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v111, 0xff, v111
		v_lshlrev_b32_e32 v111, 16, v111
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v124, 0xff, v148
		v_lshlrev_b32_e32 v124, 24, v124
		v_or3_b32 v108, v108, v111, v124
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v111, 0xff, v149
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v124, 0xff, v151
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[64:67], a[0:3], v[12:15], v108, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v124, 8, v124
		v_or_b32_e32 v111, v111, v124
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v124, 0xff, v152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v108, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v124, 16, v124
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v125, 0xff, v153
		v_lshlrev_b32_e32 v125, 24, v125
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v108, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v111, v111, v124, v125
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v108, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[68:71], a[4:7], v[12:15], v108, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v108, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v108, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v108, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v111, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v111, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v111, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v111, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v111, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[4:7], v[164:167], v111, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[12:15], v[180:183], v111, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v111, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v111, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v111, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v111, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v111, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v111, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[20:23], v[196:199], v111, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[28:31], v[212:215], v111, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v111, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v108, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v108, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v108, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v108, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v108, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v108, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v108, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v108, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v108, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v108, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v108, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v108, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v111, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v111, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v111, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v111, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v111, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[36:39], v[228:231], v111, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[44:47], v[244:247], v111, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v111, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v111, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v111, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v111, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v111, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v111, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v111, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v111, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v111, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v108, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v108, v120 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v108, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v108, v120 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v108, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v108, v120 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v108, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v108, v120 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v104 offset:32768
		ds_read_b128 a[68:71], v104 offset:32832
		ds_read_b128 a[72:75], v104 offset:36864
		ds_read_b128 a[76:79], v104 offset:36928
		ds_read_b128 a[80:83], v104 offset:40960
		ds_read_b128 a[84:87], v104 offset:41024
		ds_read_b128 a[88:91], v104 offset:45056
		ds_read_b128 v[252:255], v104 offset:45120
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
		v_add3_u32 v71, s69, v5, v7
		buffer_load_dwordx4 v71, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v71, v146 offset:2048
		ds_read_u8 v74, v107 offset:2048
		ds_read_u8 v77, v109 offset:2048
		ds_read_u8 v78, v115 offset:2048
		ds_read_u8 v108, v121 offset:2048
		ds_read_u8 v111, v150 offset:2048
		ds_read_u8 v124, v126 offset:2048
		ds_read_u8 v125, v119 offset:2048
		s_add_i32 s69, s9, s62
		s_add_i32 m0, s2, 0x1000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s11, s62
		s_add_i32 m0, s2, 0x2000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s21, s62
		s_add_i32 m0, s2, 0x3000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s40, s62
		s_add_i32 m0, s2, 0x4000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s42, s62
		s_add_i32 m0, s2, 0x5000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s44, s62
		s_add_i32 m0, s2, 0x6000
		v_add3_u32 v129, s69, v5, v7
		buffer_load_dwordx4 v129, s[24:27], 0 offen lds
		s_add_i32 s69, s45, s62
		s_add_i32 m0, s2, 0x7000
		v_add3_u32 v129, s69, v5, v7
		s_add_i32 s69, s46, s67
		v_add3_u32 v130, s69, v19, v7
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
		s_add_i32 s69, s48, s67
		v_add3_u32 v77, s69, v19, v7
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v78, 0xff, v78
		v_lshlrev_b32_e32 v78, 24, v78
		v_or3_b32 v71, v71, v74, v78
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v74, 0xff, v108
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v78, 0xff, v111
		v_lshlrev_b32_e32 v78, 8, v78
		v_or_b32_e32 v74, v74, v78
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v78, 0xff, v124
		v_lshlrev_b32_e32 v78, 16, v78
		buffer_load_dwordx4 v130, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x11000
		s_add_i32 s69, s50, s67
		v_add3_u32 v108, s69, v19, v7
		buffer_load_dwordx4 v77, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x12000
		s_add_i32 s69, s52, s67
		v_add3_u32 v77, s69, v19, v7
		buffer_load_dwordx4 v108, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x13000
		s_add_i32 s69, s55, s65
		v_add3_u32 v108, s69, v25, v27
		buffer_load_dwordx4 v77, s[28:31], 0 offen lds
		v_add3_u32 v77, v108, v31, v34
		v_add3_u32 v77, v77, v37, v39
		v_add3_u32 v77, v77, v41, v43
		buffer_load_dwordx2 v[142:143], v77, s[32:35], 0 offen
		s_add_i32 s69, s56, s68
		v_add3_u32 v77, s69, v46, v48
		v_add3_u32 v77, v77, v51, v53
		v_add3_u32 v77, v77, v55, v56
		v_add3_u32 v77, v77, v57, v58
		buffer_load_dword v108, v77, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v71, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v77, 0xff, v125
		v_lshlrev_b32_e32 v77, 24, v77
		v_or3_b32 v74, v74, v78, v77
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v71, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v71, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v71, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v71, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v71, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v71, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v71, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v74, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v74, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v74, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v74, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v74, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v74, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v74, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v74, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
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
		ds_read_b128 a[64:67], v104 offset:16384
		ds_read_b128 a[68:71], v104 offset:16448
		ds_read_b128 a[72:75], v104 offset:20480
		ds_read_b128 a[76:79], v104 offset:20544
		ds_read_b128 a[80:83], v104 offset:24576
		ds_read_b128 a[84:87], v104 offset:24640
		ds_read_b128 a[88:91], v104 offset:28672
		ds_read_b128 v[252:255], v104 offset:28736
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
		ds_write_b8 v88, v82
		s_waitcnt vmcnt(27)
		ds_write_b8 v92, v91
		s_waitcnt vmcnt(26)
		ds_write_b8 v65, v94
		s_add_i32 s69, s58, s67
		s_add_i32 m0, s2, 0x18000
		v_add3_u32 v71, s69, v19, v7
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(26)
		ds_write_b8 v0, v98 offset:2048
		s_waitcnt vmcnt(25)
		ds_write_b8 v67, v99 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v72, v68 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v75, v97 offset:2048
		s_add_i32 s69, s60, s67
		s_add_i32 m0, s2, 0x19000
		v_add3_u32 v68, s69, v19, v7
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v68, v59
		ds_read_u8 v82, v112
		ds_read_u8 v83, v117
		ds_read_u8 v85, v116
		ds_read_u8 v90, v123
		ds_read_u8 v91, v122
		ds_read_u8 v94, v128
		ds_read_u8 v95, v127
		ds_read_u8 v96, v132
		ds_read_u8 v97, v131
		ds_read_u8 v98, v136
		ds_read_u8 v99, v135
		ds_read_u8 v110, v140
		ds_read_u8 v111, v139
		ds_read_u8 v113, v114
		ds_read_u8 v118, v144
		ds_read_u8 v120, v146 offset:2048
		ds_read_u8 v124, v107 offset:2048
		ds_read_u8 v125, v109 offset:2048
		ds_read_u8 v129, v115 offset:2048
		ds_read_u8 v130, v121 offset:2048
		ds_read_u8 v133, v150 offset:2048
		ds_read_u8 v134, v126 offset:2048
		ds_read_u8 v137, v119 offset:2048
		s_add_i32 s69, s63, s67
		s_add_i32 m0, s2, 0x1a000
		v_add3_u32 v71, s69, v19, v7
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 s69, s64, s67
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v71, s69, v19, v7
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		s_add_i32 s69, s66, s68
		v_add3_u32 v71, s69, v28, v47
		v_add3_u32 v71, v71, v50, v52
		v_add3_u32 v71, v71, v54, v26
		v_add3_u32 v71, v71, v63, v64
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
		v_and_b32_e32 v82, 0xff, v82
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		v_and_b32_e32 v82, 0xff, v83
		v_lshlrev_b32_e32 v82, 16, v82
		v_and_b32_e32 v83, 0xff, v85
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v138, v68, v82, v83
		v_and_b32_e32 v68, 0xff, v90
		v_and_b32_e32 v82, 0xff, v91
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		v_and_b32_e32 v82, 0xff, v94
		v_lshlrev_b32_e32 v82, 16, v82
		v_and_b32_e32 v83, 0xff, v95
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v141, v68, v82, v83
		v_and_b32_e32 v68, 0xff, v96
		v_and_b32_e32 v82, 0xff, v97
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v82, 0xff, v98
		v_lshlrev_b32_e32 v82, 16, v82
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v83, 0xff, v99
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v145, v68, v82, v83
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v68, 0xff, v110
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v82, 0xff, v111
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v82, 0xff, v113
		v_lshlrev_b32_e32 v82, 16, v82
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v83, 0xff, v118
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v110, v68, v82, v83
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v68, 0xff, v120
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v82, 0xff, v124
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v82, 0xff, v125
		v_lshlrev_b32_e32 v82, 16, v82
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v83, 0xff, v129
		v_lshlrev_b32_e32 v83, 24, v83
		v_or3_b32 v68, v68, v82, v83
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v82, 0xff, v130
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v83, 0xff, v133
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[64:67], a[0:3], v[12:15], v68, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v83, 8, v83
		v_or_b32_e32 v82, v82, v83
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v83, 0xff, v134
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v68, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v83, 16, v83
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v85, 0xff, v137
		v_lshlrev_b32_e32 v85, 24, v85
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v68, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v82, v82, v83, v85
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v68, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[68:71], a[4:7], v[12:15], v68, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v68, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v68, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v68, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v82, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v82, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v82, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v82, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v82, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[4:7], v[164:167], v82, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[12:15], v[180:183], v82, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v82, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v82, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v82, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v82, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v82, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v82, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[20:23], v[196:199], v82, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[28:31], v[212:215], v82, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v82, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v68, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v68, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v68, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v68, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v68, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v68, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v68, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v68, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v68, v145 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v68, v145 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v68, v145 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v68, v145 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v68, v145 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v68, v145 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v68, v145 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v68, v145 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v82, v145 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v82, v145 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v82, v145 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v82, v145 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v82, v145 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[36:39], v[228:231], v82, v145 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[44:47], v[244:247], v82, v145 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v82, v145 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v82, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v82, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v82, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v82, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v82, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[52:55], a[108:111], v82, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[60:63], a[124:127], v82, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v82, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v68, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v68, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v68, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v68, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v68, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v68, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v68, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v68, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v104 offset:49152
		ds_read_b128 a[68:71], v104 offset:49216
		ds_read_b128 a[72:75], v104 offset:53248
		ds_read_b128 a[76:79], v104 offset:53312
		ds_read_b128 a[80:83], v104 offset:57344
		ds_read_b128 a[84:87], v104 offset:57408
		ds_read_b128 a[88:91], v104 offset:61440
		ds_read_b128 v[252:255], v104 offset:61504
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v102 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v67, v103 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v72, v100 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v75, v101 offset:2048
		s_add_i32 s69, s19, s62
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v68, s69, v5, v7
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v68, v146 offset:2048
		ds_read_u8 v82, v107 offset:2048
		ds_read_u8 v83, v109 offset:2048
		ds_read_u8 v85, v115 offset:2048
		ds_read_u8 v90, v121 offset:2048
		ds_read_u8 v91, v150 offset:2048
		ds_read_u8 v94, v126 offset:2048
		ds_read_u8 v100, v119 offset:2048
		s_add_i32 s69, s8, s62
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s10, s62
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s16, s62
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s20, s62
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s23, s62
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s41, s62
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v95, s69, v5, v7
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 s69, s3, s62
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v95, s69, v5, v7
		s_add_i32 s69, s4, s67
		v_add3_u32 v96, s69, v19, v7
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v68, 0xff, v68
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v82, 0xff, v82
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v68, v68, v82
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v82, 0xff, v83
		v_lshlrev_b32_e32 v82, 16, v82
		buffer_load_dwordx4 v95, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s69, s14, s67
		v_add3_u32 v83, s69, v19, v7
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v85, 0xff, v85
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v101, v68, v82, v85
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v68, 0xff, v90
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v82, 0xff, v91
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v102, v68, v82
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v68, 0xff, v94
		v_lshlrev_b32_e32 v103, 16, v68
		buffer_load_dwordx4 v96, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s69, s43, s67
		v_add3_u32 v68, s69, v19, v7
		buffer_load_dwordx4 v83, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s69, s47, s67
		v_add3_u32 v82, s69, v19, v7
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s69, s49, s65
		v_add3_u32 v68, s69, v80, v30
		buffer_load_dwordx4 v82, s[28:31], 0 offen lds
		v_add3_u32 v68, v68, v33, v36
		v_add3_u32 v68, v68, v38, v26
		v_add3_u32 v68, v68, v63, v64
		v_add3_u32 v82, s69, v79, v26
		v_add3_u32 v82, v82, v63, v64
		v_add3_u32 v83, v81, v155, s69
		v_add3_u32 v85, v84, v155, s69
		v_add3_u32 v91, v87, v155, s69
		v_add3_u32 v94, v89, v156, s69
		v_add3_u32 v97, v93, v156, s69
		v_add3_u32 v98, v66, v156, s69
		buffer_load_ubyte v90, v68, s[32:35], 0 offen
		buffer_load_ubyte v95, v82, s[32:35], 0 offen
		buffer_load_ubyte v96, v83, s[32:35], 0 offen
		buffer_load_ubyte v83, v85, s[32:35], 0 offen
		buffer_load_ubyte v85, v91, s[32:35], 0 offen
		buffer_load_ubyte v82, v94, s[32:35], 0 offen
		buffer_load_ubyte v91, v97, s[32:35], 0 offen
		buffer_load_ubyte v94, v98, s[32:35], 0 offen
		s_add_i32 s69, s18, s68
		v_add3_u32 v68, s69, v28, v47
		v_add3_u32 v68, v68, v50, v52
		v_add3_u32 v68, v68, v54, v26
		v_add3_u32 v68, v68, v63, v64
		v_add3_u32 v97, v69, v157, s69
		v_add3_u32 v111, v73, v157, s69
		v_add3_u32 v113, v76, v157, s69
		buffer_load_ubyte v98, v68, s[36:39], 0 offen
		buffer_load_ubyte v99, v97, s[36:39], 0 offen
		buffer_load_ubyte v68, v111, s[36:39], 0 offen
		buffer_load_ubyte v97, v113, s[36:39], 0 offen
		s_waitcnt vmcnt(34)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v101, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v100, 0xff, v100
		v_lshlrev_b32_e32 v100, 24, v100
		v_or3_b32 v100, v102, v103, v100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v101, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v101, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v101, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v101, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v101, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v101, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v101, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v100, v138 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v100, v138 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v100, v138 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v100, v138 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v100, v138 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v100, v138 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v100, v138 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v100, v138 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v100, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v100, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v100, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v100, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v100, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[20:23], a[172:175], v100, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[28:31], a[188:191], v100, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v100, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v101, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v101, v141 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v101, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v101, v141 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v101, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v101, v141 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v101, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v101, v141 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v101, v145 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v101, v145 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v101, v145 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v101, v145 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v101, v145 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v101, v145 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v101, v145 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v101, v145 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v100, v145 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v100, v145 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v100, v145 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v100, v145 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v100, v145 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[36:39], a[204:207], v100, v145 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[44:47], a[220:223], v100, v145 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v100, v145 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v100, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v100, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[88:91], a[56:59], a[252:255], v100, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v100, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v100, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[52:55], a[236:239], v100, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[60:63], a[252:255], v100, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v100, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v101, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v101, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v101, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v101, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v101, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v101, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v101, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v101, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
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
		ds_read_b128 a[64:67], v104
		ds_read_b128 a[68:71], v104 offset:64
		ds_read_b128 a[72:75], v104 offset:4096
		ds_read_b128 a[76:79], v104 offset:4160
		ds_read_b128 a[80:83], v104 offset:8192
		ds_read_b128 a[84:87], v104 offset:8256
		ds_read_b128 a[88:91], v104 offset:12288
		ds_read_b128 a[92:95], v104 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v106, v[142:143]
		s_add_i32 s69, s51, s67
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v100, s69, v19, v7
		buffer_load_dwordx4 v100, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(33)
		ds_write_b32 v44, v108 offset:2048
		s_add_i32 s69, s53, s67
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v100, s69, v19, v7
		buffer_load_dwordx4 v100, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v110, v59
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
		ds_read_u8 v145, v144
		ds_read_u8 v147, v146 offset:2048
		ds_read_u8 v108, v107 offset:2048
		ds_read_u8 v111, v109 offset:2048
		ds_read_u8 v148, v115 offset:2048
		ds_read_u8 v149, v121 offset:2048
		ds_read_u8 v151, v150 offset:2048
		ds_read_u8 v152, v126 offset:2048
		ds_read_u8 v153, v119 offset:2048
		s_add_i32 s69, s54, s67
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v100, s69, v19, v7
		buffer_load_dwordx4 v100, s[28:31], 0 offen lds
		s_add_i32 s69, s15, s67
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v100, s69, v19, v7
		buffer_load_dwordx4 v100, s[28:31], 0 offen lds
		s_add_i32 s69, s57, s68
		v_add3_u32 v100, s69, v28, v47
		v_add3_u32 v100, v100, v50, v52
		v_add3_u32 v100, v100, v54, v26
		v_add3_u32 v100, v100, v63, v64
		v_add3_u32 v101, v69, v158, s69
		v_add3_u32 v159, v73, v158, s69
		v_add3_u32 v252, v76, v158, s69
		buffer_load_ubyte v102, v100, s[36:39], 0 offen
		buffer_load_ubyte v103, v101, s[36:39], 0 offen
		buffer_load_ubyte v100, v159, s[36:39], 0 offen
		buffer_load_ubyte v101, v252, s[36:39], 0 offen
		s_add_i32 s62, s62, 0x100
		s_add_i32 s67, s67, 0x100
		s_add_i32 s65, s65, 16
		s_add_i32 s68, s68, 16
		s_add_i32 s59, s59, 2
		s_cmp_lt_i32 s59, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(4)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v5, 0xff, v110
		v_and_b32_e32 v7, 0xff, v113
		v_lshlrev_b32_e32 v7, 8, v7
		v_or_b32_e32 v5, v5, v7
		v_and_b32_e32 v7, 0xff, v118
		v_lshlrev_b32_e32 v7, 16, v7
		v_and_b32_e32 v19, 0xff, v120
		v_lshlrev_b32_e32 v19, 24, v19
		v_or3_b32 v5, v5, v7, v19
		v_and_b32_e32 v7, 0xff, v124
		v_and_b32_e32 v19, 0xff, v125
		v_lshlrev_b32_e32 v19, 8, v19
		v_or_b32_e32 v7, v7, v19
		v_and_b32_e32 v19, 0xff, v129
		v_lshlrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v25, 0xff, v130
		v_lshlrev_b32_e32 v25, 24, v25
		v_or3_b32 v7, v7, v19, v25
		v_and_b32_e32 v19, 0xff, v133
		v_and_b32_e32 v25, 0xff, v134
		v_lshlrev_b32_e32 v25, 8, v25
		v_or_b32_e32 v19, v19, v25
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v25, 0xff, v137
		v_lshlrev_b32_e32 v25, 16, v25
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v27, 0xff, v138
		v_lshlrev_b32_e32 v27, 24, v27
		v_or3_b32 v19, v19, v25, v27
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v25, 0xff, v141
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v27, 0xff, v142
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v25, v25, v27
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v27, 0xff, v143
		v_lshlrev_b32_e32 v27, 16, v27
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v28, 0xff, v145
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v25, v25, v27, v28
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v27, 0xff, v147
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v28, 0xff, v108
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v28, 0xff, v111
		v_lshlrev_b32_e32 v28, 16, v28
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v30, 0xff, v148
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v28, 0xff, v149
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v30, 0xff, v151
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[64:67], a[0:3], v[12:15], v27, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v30, 0xff, v152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v27, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v31, 0xff, v153
		v_lshlrev_b32_e32 v31, 24, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[8:11], v[172:175], v27, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v28, v28, v30, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[8:11], v[168:171], v27, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[68:71], a[4:7], v[12:15], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[12:15], v[172:175], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[12:15], v[168:171], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[0:3], v[160:163], v28, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[0:3], v[164:167], v28, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[8:11], v[180:183], v28, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[8:11], v[176:179], v28, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[4:7], v[160:163], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[4:7], v[164:167], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[12:15], v[180:183], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[12:15], v[176:179], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[16:19], v[192:195], v28, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[16:19], v[196:199], v28, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[24:27], v[212:215], v28, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[24:27], v[208:211], v28, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[20:23], v[192:195], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[20:23], v[196:199], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[28:31], v[212:215], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[28:31], v[208:211], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[16:19], v[184:187], v27, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[16:19], v[188:191], v27, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[24:27], v[204:207], v27, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[24:27], v[200:203], v27, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[20:23], v[184:187], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[20:23], v[188:191], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[28:31], v[204:207], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[28:31], v[200:203], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[32:35], v[216:219], v27, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[32:35], v[220:223], v27, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[40:43], v[236:239], v27, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[40:43], v[232:235], v27, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[36:39], v[216:219], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[36:39], v[220:223], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[44:47], v[236:239], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[44:47], v[232:235], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[32:35], v[224:227], v28, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[32:35], v[228:231], v28, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[40:43], v[244:247], v28, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[40:43], v[240:243], v28, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[36:39], v[224:227], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[36:39], v[228:231], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[44:47], v[244:247], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[44:47], v[240:243], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v28, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v28, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v28, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v28, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[48:51], v[248:251], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[52:55], v[248:251], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v104 offset:32768
		ds_read_b128 a[68:71], v104 offset:32832
		ds_read_b128 v[36:39], v104 offset:36864
		ds_read_b128 a[72:75], v104 offset:36928
		ds_read_b128 v[52:55], v104 offset:40960
		ds_read_b128 v[152:155], v104 offset:41024
		ds_read_b128 v[156:159], v104 offset:45056
		ds_read_b128 v[252:255], v104 offset:45120
		ds_write_b8 v0, v77 offset:2048
		ds_write_b8 v67, v78 offset:2048
		ds_write_b8 v72, v71 offset:2048
		ds_write_b8 v75, v74 offset:2048
		v_add_u32_e32 v6, 0x20000, v6
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v26, 9, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v27, v146 offset:2048
		ds_read_u8 v28, v107 offset:2048
		ds_read_u8 v30, v109 offset:2048
		ds_read_u8 v31, v115 offset:2048
		ds_read_u8 v33, v121 offset:2048
		ds_read_u8 v34, v150 offset:2048
		ds_read_u8 v41, v126 offset:2048
		ds_read_u8 v43, v119 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v27, 0xff, v27
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v28, 0xff, v28
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v28, 0xff, v30
		v_lshlrev_b32_e32 v28, 16, v28
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v30, 0xff, v31
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v28, 0xff, v33
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v30, 0xff, v34
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v27, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v30, 0xff, v41
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[36:39], a[0:3], a[132:135], v27, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v31, 0xff, v43
		v_lshlrev_b32_e32 v31, 24, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], a[8:11], a[148:151], v27, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v28, v28, v30, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v27, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[4:7], a[132:135], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[12:15], a[148:151], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[0:3], a[136:139], v28, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[156:159], a[0:3], a[140:143], v28, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[156:159], a[8:11], a[156:159], v28, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[8:11], a[152:155], v28, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[152:155], a[4:7], a[136:139], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[4:7], a[140:143], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[12:15], a[156:159], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[152:155], a[12:15], a[152:155], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[16:19], a[168:171], v28, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[156:159], a[16:19], a[172:175], v28, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[156:159], a[24:27], a[188:191], v28, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], a[24:27], a[184:187], v28, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[152:155], a[20:23], a[168:171], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[20:23], a[172:175], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[28:31], a[188:191], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[152:155], a[28:31], a[184:187], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v27, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], a[16:19], a[164:167], v27, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], a[24:27], a[180:183], v27, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v27, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[20:23], a[164:167], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[28:31], a[180:183], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v27, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], a[32:35], a[196:199], v27, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], a[40:43], a[212:215], v27, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v27, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[36:39], a[196:199], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[44:47], a[212:215], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[52:55], a[32:35], a[200:203], v28, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[156:159], a[32:35], a[204:207], v28, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[156:159], a[40:43], a[220:223], v28, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[52:55], a[40:43], a[216:219], v28, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[152:155], a[36:39], a[200:203], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[36:39], a[204:207], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[44:47], a[220:223], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[152:155], a[44:47], a[216:219], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[52:55], a[48:51], a[232:235], v28, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[156:159], a[48:51], a[236:239], v28, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[156:159], a[56:59], a[252:255], v28, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[52:55], a[56:59], a[248:251], v28, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[152:155], a[52:55], a[232:235], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[52:55], a[236:239], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[60:63], a[252:255], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[152:155], a[60:63], a[248:251], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], a[48:51], a[228:231], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], a[56:59], a[244:247], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[52:55], a[228:231], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[60:63], a[244:247], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
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
		ds_read_b128 v[36:39], v104 offset:16384
		ds_read_b128 a[64:67], v104 offset:16448
		ds_read_b128 v[52:55], v104 offset:20480
		ds_read_b128 a[68:71], v104 offset:20544
		ds_read_b128 v[76:79], v104 offset:24576
		ds_read_b128 v[152:155], v104 offset:24640
		ds_read_b128 v[156:159], v104 offset:28672
		ds_read_b128 v[252:255], v104 offset:28736
		ds_write_b8 v0, v90
		ds_write_b8 v67, v95
		ds_write_b8 v72, v96
		ds_write_b8 v75, v83
		ds_write_b8 v86, v85
		ds_write_b8 v88, v82
		ds_write_b8 v92, v91
		ds_write_b8 v65, v94
		v_lshl_add_u32 v1, v4, 13, v1
		v_lshl_add_u32 v1, v40, 12, v1
		v_lshl_add_u32 v1, v42, 10, v1
		v_cmp_lt_i32_e64 vcc, v49, s12
		s_mov_b64 s[2:3], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v98 offset:2048
		ds_write_b8 v67, v99 offset:2048
		ds_write_b8 v72, v68 offset:2048
		ds_write_b8 v75, v97 offset:2048
		v_cmp_lt_i32_e64 vcc, v70, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s8, s2, s4
		s_and_b32 s9, s3, s5
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v5, v59
		ds_read_u8 v7, v112
		ds_read_u8 v19, v117
		ds_read_u8 v25, v116
		ds_read_u8 v27, v123
		ds_read_u8 v28, v122
		ds_read_u8 v30, v128
		ds_read_u8 v31, v127
		ds_read_u8 v33, v132
		ds_read_u8 v34, v131
		ds_read_u8 v41, v136
		ds_read_u8 v43, v135
		ds_read_u8 v44, v140
		ds_read_u8 v46, v139
		ds_read_u8 v47, v114
		ds_read_u8 v48, v144
		ds_read_u8 v49, v146 offset:2048
		ds_read_u8 v50, v107 offset:2048
		ds_read_u8 v51, v109 offset:2048
		ds_read_u8 v56, v115 offset:2048
		ds_read_u8 v57, v121 offset:2048
		ds_read_u8 v58, v150 offset:2048
		ds_read_u8 v59, v126 offset:2048
		ds_read_u8 v63, v119 offset:2048
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v5, 0xff, v5
		v_and_b32_e32 v7, 0xff, v7
		v_lshlrev_b32_e32 v7, 8, v7
		v_or_b32_e32 v5, v5, v7
		v_and_b32_e32 v7, 0xff, v19
		v_lshlrev_b32_e32 v7, 16, v7
		v_and_b32_e32 v19, 0xff, v25
		v_lshlrev_b32_e32 v19, 24, v19
		v_or3_b32 v5, v5, v7, v19
		v_and_b32_e32 v7, 0xff, v27
		v_and_b32_e32 v19, 0xff, v28
		v_lshlrev_b32_e32 v19, 8, v19
		v_or_b32_e32 v7, v7, v19
		v_and_b32_e32 v19, 0xff, v30
		v_lshlrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v25, 0xff, v31
		v_lshlrev_b32_e32 v25, 24, v25
		v_or3_b32 v7, v7, v19, v25
		v_and_b32_e32 v19, 0xff, v33
		v_and_b32_e32 v25, 0xff, v34
		v_lshlrev_b32_e32 v25, 8, v25
		v_or_b32_e32 v19, v19, v25
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v25, 0xff, v41
		v_lshlrev_b32_e32 v25, 16, v25
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v27, 0xff, v43
		v_lshlrev_b32_e32 v27, 24, v27
		v_or3_b32 v19, v19, v25, v27
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v25, 0xff, v44
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v27, 0xff, v46
		v_lshlrev_b32_e32 v27, 8, v27
		v_or_b32_e32 v25, v25, v27
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v27, 0xff, v47
		v_lshlrev_b32_e32 v27, 16, v27
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v28, 0xff, v48
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v25, v25, v27, v28
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v27, 0xff, v49
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v28, 0xff, v50
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v27, v27, v28
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v28, 0xff, v51
		v_lshlrev_b32_e32 v28, 16, v28
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v30, 0xff, v56
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v27, v27, v28, v30
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v28, 0xff, v57
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v30, 0xff, v58
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], a[0:3], v[12:15], v27, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 8, v30
		v_or_b32_e32 v28, v28, v30
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v30, 0xff, v59
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[52:55], a[0:3], a[96:99], v27, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v30, 16, v30
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v31, 0xff, v63
		v_lshlrev_b32_e32 v31, 24, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], a[8:11], v[172:175], v27, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v28, v28, v30, v31
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[8:11], v[168:171], v27, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[64:67], a[4:7], v[12:15], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[68:71], a[4:7], a[96:99], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[12:15], v[172:175], v27, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], a[12:15], v[168:171], v27, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[76:79], a[0:3], v[160:163], v28, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[156:159], a[0:3], v[164:167], v28, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[156:159], a[8:11], v[180:183], v28, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[76:79], a[8:11], v[176:179], v28, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[152:155], a[4:7], v[160:163], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[4:7], v[164:167], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[12:15], v[180:183], v28, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[152:155], a[12:15], v[176:179], v28, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[76:79], a[16:19], v[192:195], v28, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[156:159], a[16:19], v[196:199], v28, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[156:159], a[24:27], v[212:215], v28, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[76:79], a[24:27], v[208:211], v28, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[152:155], a[20:23], v[192:195], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[20:23], v[196:199], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[28:31], v[212:215], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[152:155], a[28:31], v[208:211], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[16:19], v[184:187], v27, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], a[16:19], v[188:191], v27, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], a[24:27], v[204:207], v27, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], a[24:27], v[200:203], v27, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[64:67], a[20:23], v[184:187], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[20:23], v[188:191], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[28:31], v[204:207], v27, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[28:31], v[200:203], v27, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[32:35], v[216:219], v27, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], a[32:35], v[220:223], v27, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[40:43], v[236:239], v27, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[40:43], v[232:235], v27, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[36:39], v[216:219], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[36:39], v[220:223], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[44:47], v[236:239], v27, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[44:47], v[232:235], v27, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[76:79], a[32:35], v[224:227], v28, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[156:159], a[32:35], v[228:231], v28, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[156:159], a[40:43], v[244:247], v28, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[76:79], a[40:43], v[240:243], v28, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[152:155], a[36:39], v[224:227], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[36:39], v[228:231], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[44:47], v[244:247], v28, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[152:155], a[44:47], v[240:243], v28, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], a[48:51], a[104:107], v28, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[156:159], a[48:51], a[108:111], v28, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[156:159], a[56:59], a[124:127], v28, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], a[56:59], a[120:123], v28, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[152:155], a[52:55], a[104:107], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[52:55], a[108:111], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[60:63], a[124:127], v28, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[152:155], a[60:63], a[120:123], v28, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[48:51], v[248:251], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[52:55], a[48:51], a[100:103], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[56:59], a[116:119], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[56:59], a[112:115], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[52:55], v[248:251], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[52:55], a[100:103], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[60:63], a[116:119], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[60:63], a[112:115], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v104 offset:49152
		ds_read_b128 v[48:51], v104 offset:49216
		ds_read_b128 v[52:55], v104 offset:53248
		ds_read_b128 v[56:59], v104 offset:53312
		ds_read_b128 v[68:71], v104 offset:57344
		ds_read_b128 v[76:79], v104 offset:57408
		ds_read_b128 v[80:83], v104 offset:61440
		ds_read_b128 v[84:87], v104 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v102 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v67, v103 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v72, v100 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v75, v101 offset:2048
		v_cvt_pk_bf16_f32 v64, v12, v13
		v_cvt_pk_bf16_f32 v65, v14, v15
		v_accvgpr_read_b32 v0, a96
		v_accvgpr_read_b32 v12, a97
		v_cvt_pk_bf16_f32 v72, v0, v12
		v_accvgpr_read_b32 v0, a98
		v_accvgpr_read_b32 v12, a99
		v_cvt_pk_bf16_f32 v73, v0, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v146 offset:2048
		ds_read_u8 v12, v107 offset:2048
		ds_read_u8 v13, v109 offset:2048
		ds_read_u8 v14, v115 offset:2048
		ds_read_u8 v15, v121 offset:2048
		ds_read_u8 v27, v150 offset:2048
		ds_read_u8 v28, v126 offset:2048
		ds_read_u8 v30, v119 offset:2048
		v_cvt_pk_bf16_f32 v88, v160, v161
		v_cvt_pk_bf16_f32 v89, v162, v163
		v_cvt_pk_bf16_f32 v92, v164, v165
		v_cvt_pk_bf16_f32 v93, v166, v167
		v_cvt_pk_bf16_f32 v66, v168, v169
		v_cvt_pk_bf16_f32 v67, v170, v171
		v_cvt_pk_bf16_f32 v74, v172, v173
		v_cvt_pk_bf16_f32 v75, v174, v175
		v_cvt_pk_bf16_f32 v90, v176, v177
		v_cvt_pk_bf16_f32 v91, v178, v179
		v_cvt_pk_bf16_f32 v94, v180, v181
		v_cvt_pk_bf16_f32 v95, v182, v183
		v_cvt_pk_bf16_f32 v96, v184, v185
		v_cvt_pk_bf16_f32 v97, v186, v187
		v_cvt_pk_bf16_f32 v100, v188, v189
		v_cvt_pk_bf16_f32 v101, v190, v191
		v_cvt_pk_bf16_f32 v104, v192, v193
		v_cvt_pk_bf16_f32 v105, v194, v195
		v_cvt_pk_bf16_f32 v108, v196, v197
		v_cvt_pk_bf16_f32 v109, v198, v199
		v_cvt_pk_bf16_f32 v98, v200, v201
		v_cvt_pk_bf16_f32 v99, v202, v203
		v_cvt_pk_bf16_f32 v102, v204, v205
		v_cvt_pk_bf16_f32 v103, v206, v207
		v_cvt_pk_bf16_f32 v106, v208, v209
		v_cvt_pk_bf16_f32 v107, v210, v211
		v_cvt_pk_bf16_f32 v110, v212, v213
		v_cvt_pk_bf16_f32 v111, v214, v215
		v_cvt_pk_bf16_f32 v112, v216, v217
		v_cvt_pk_bf16_f32 v113, v218, v219
		v_cvt_pk_bf16_f32 v116, v220, v221
		v_cvt_pk_bf16_f32 v117, v222, v223
		v_cvt_pk_bf16_f32 v120, v224, v225
		v_cvt_pk_bf16_f32 v121, v226, v227
		v_cvt_pk_bf16_f32 v124, v228, v229
		v_cvt_pk_bf16_f32 v125, v230, v231
		v_cvt_pk_bf16_f32 v114, v232, v233
		v_cvt_pk_bf16_f32 v115, v234, v235
		v_cvt_pk_bf16_f32 v118, v236, v237
		v_cvt_pk_bf16_f32 v119, v238, v239
		v_cvt_pk_bf16_f32 v122, v240, v241
		v_cvt_pk_bf16_f32 v123, v242, v243
		v_cvt_pk_bf16_f32 v126, v244, v245
		v_cvt_pk_bf16_f32 v127, v246, v247
		v_cvt_pk_bf16_f32 v128, v248, v249
		v_cvt_pk_bf16_f32 v129, v250, v251
		v_accvgpr_read_b32 v31, a100
		v_accvgpr_read_b32 v33, a101
		v_cvt_pk_bf16_f32 v132, v31, v33
		v_accvgpr_read_b32 v31, a102
		v_accvgpr_read_b32 v33, a103
		v_cvt_pk_bf16_f32 v133, v31, v33
		v_accvgpr_read_b32 v31, a104
		v_accvgpr_read_b32 v33, a105
		v_cvt_pk_bf16_f32 v136, v31, v33
		v_accvgpr_read_b32 v31, a106
		v_accvgpr_read_b32 v33, a107
		v_cvt_pk_bf16_f32 v137, v31, v33
		v_accvgpr_read_b32 v31, a108
		v_accvgpr_read_b32 v33, a109
		v_cvt_pk_bf16_f32 v140, v31, v33
		v_accvgpr_read_b32 v31, a110
		v_accvgpr_read_b32 v33, a111
		v_cvt_pk_bf16_f32 v141, v31, v33
		v_accvgpr_read_b32 v31, a112
		v_accvgpr_read_b32 v33, a113
		v_cvt_pk_bf16_f32 v130, v31, v33
		v_accvgpr_read_b32 v31, a114
		v_accvgpr_read_b32 v33, a115
		v_cvt_pk_bf16_f32 v131, v31, v33
		v_accvgpr_read_b32 v31, a116
		v_accvgpr_read_b32 v33, a117
		v_cvt_pk_bf16_f32 v134, v31, v33
		v_accvgpr_read_b32 v31, a118
		v_accvgpr_read_b32 v33, a119
		v_cvt_pk_bf16_f32 v135, v31, v33
		v_accvgpr_read_b32 v31, a120
		v_accvgpr_read_b32 v33, a121
		v_cvt_pk_bf16_f32 v138, v31, v33
		v_accvgpr_read_b32 v31, a122
		v_accvgpr_read_b32 v33, a123
		v_cvt_pk_bf16_f32 v139, v31, v33
		v_accvgpr_read_b32 v31, a124
		v_accvgpr_read_b32 v33, a125
		v_cvt_pk_bf16_f32 v142, v31, v33
		v_accvgpr_read_b32 v31, a126
		v_accvgpr_read_b32 v33, a127
		v_cvt_pk_bf16_f32 v143, v31, v33
		ds_write_b128 v6, v[64:67] offset:3072
		ds_write_b128 v6, v[72:75] offset:7168
		ds_write_b128 v6, v[88:91] offset:11264
		ds_write_b128 v6, v[92:95] offset:15360
		v_lshlrev_b32_e32 v26, 4, v26
		v_lshlrev_b32_e32 v4, 7, v4
		v_lshlrev_b32_e32 v31, 6, v40
		v_lshlrev_b32_e32 v33, 5, v42
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v1 offset:3072
		ds_read_b128 v[64:67], v1 offset:3328
		ds_read_b128 v[72:75], v1 offset:5120
		ds_read_b128 v[88:91], v1 offset:5376
		v_mov_b32_e32 v34, 0x80000000
		v_cmp_lt_i32_e64 vcc, v62, s12
		s_mov_b64 s[10:11], vcc
		v_lshlrev_b32_e32 v44, 3, v24
		v_lshlrev_b32_e32 v46, 2, v29
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[96:99] offset:3072
		ds_write_b128 v6, v[100:103] offset:7168
		ds_write_b128 v6, v[104:107] offset:11264
		ds_write_b128 v6, v[108:111] offset:15360
		v_add_u32_e32 v47, 16, v35
		v_xor_b32_e32 v47, v47, v45
		v_bitop3_b32 v47, v44, v46, v47 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[14:15], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1 offset:3072
		ds_read_b128 v[96:99], v1 offset:3328
		ds_read_b128 v[100:103], v1 offset:5120
		ds_read_b128 v[104:107], v1 offset:5376
		v_add_u32_e32 v2, 32, v35
		v_xor_b32_e32 v2, v2, v45
		v_bitop3_b32 v2, v44, v46, v2 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[18:19], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[112:115] offset:3072
		ds_write_b128 v6, v[116:119] offset:7168
		ds_write_b128 v6, v[120:123] offset:11264
		ds_write_b128 v6, v[124:127] offset:15360
		v_add_u32_e32 v8, 48, v35
		v_xor_b32_e32 v8, v8, v45
		v_bitop3_b32 v8, v44, v46, v8 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s12
		s_mov_b64 s[20:21], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v1 offset:3072
		ds_read_b128 v[112:115], v1 offset:3328
		ds_read_b128 v[116:119], v1 offset:5120
		ds_read_b128 v[120:123], v1 offset:5376
		v_add_u32_e32 v16, 64, v35
		v_xor_b32_e32 v16, v16, v45
		v_bitop3_b32 v16, v44, v46, v16 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[24:25], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[128:131] offset:3072
		ds_write_b128 v6, v[132:135] offset:7168
		ds_write_b128 v6, v[136:139] offset:11264
		ds_write_b128 v6, v[140:143] offset:15360
		v_add_u32_e32 v9, 0x50, v35
		v_xor_b32_e32 v9, v9, v45
		v_bitop3_b32 v9, v44, v46, v9 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[28:29], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[124:127], v1 offset:3072
		ds_read_b128 v[128:131], v1 offset:3328
		ds_read_b128 v[132:135], v1 offset:5120
		ds_read_b128 v[136:139], v1 offset:5376
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s16, s0, s1
		s_mul_i32 s22, s22, s17
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s22, s22, 9
		s_add_i32 s16, s16, s22
		v_mul_lo_u32 v10, s17, v24
		v_lshlrev_b32_e32 v10, 4, v10
		v_mul_lo_u32 v24, s17, v29
		v_lshlrev_b32_e32 v24, 3, v24
		v_add3_u32 v29, s16, v10, v24
		v_mul_lo_u32 v32, s17, v32
		v_lshlrev_b32_e32 v32, 2, v32
		v_mul_lo_u32 v62, s17, v35
		v_lshlrev_b32_e32 v62, 1, v62
		v_add3_u32 v29, v29, v32, v62
		v_add3_u32 v29, v29, v26, v4
		v_add3_u32 v29, v29, v31, v33
		v_cndmask_b32_e64 v29, v34, v29, s[8:9]
		v_mov_b64_e32 v[140:141], v[40:41]
		v_mov_b64_e32 v[142:143], v[64:65]
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		buffer_store_dwordx4 v[140:143], v29, s[32:35], 0 offen
		s_and_b32 s6, s10, s4
		s_and_b32 s7, s11, s5
		v_mul_lo_u32 v29, s17, v47
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v40, s16, v29
		v_add3_u32 v40, v40, v26, v4
		v_add3_u32 v40, v40, v31, v33
		v_cndmask_b32_e64 v40, v34, v40, s[6:7]
		v_mov_b64_e32 v[140:141], v[72:73]
		v_mov_b64_e32 v[142:143], v[88:89]
		buffer_store_dwordx4 v[140:143], v40, s[32:35], 0 offen
		s_and_b32 s6, s14, s4
		s_and_b32 s7, s15, s5
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v40, s16, v2
		v_add3_u32 v40, v40, v26, v4
		v_add3_u32 v40, v40, v31, v33
		v_cndmask_b32_e64 v40, v34, v40, s[6:7]
		v_mov_b64_e32 v[140:141], v[42:43]
		v_mov_b64_e32 v[142:143], v[66:67]
		buffer_store_dwordx4 v[140:143], v40, s[32:35], 0 offen
		s_and_b32 s6, s18, s4
		s_and_b32 s7, s19, s5
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v40, s16, v8
		v_add3_u32 v40, v40, v26, v4
		v_add3_u32 v40, v40, v31, v33
		v_cndmask_b32_e64 v40, v34, v40, s[6:7]
		v_mov_b64_e32 v[64:65], v[74:75]
		v_mov_b64_e32 v[66:67], v[90:91]
		buffer_store_dwordx4 v[64:67], v40, s[32:35], 0 offen
		s_and_b32 s6, s20, s4
		s_and_b32 s7, s21, s5
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v40, s16, v16
		v_add3_u32 v40, v40, v26, v4
		v_add3_u32 v40, v40, v31, v33
		v_cndmask_b32_e64 v40, v34, v40, s[6:7]
		v_mov_b64_e32 v[64:65], v[92:93]
		v_mov_b64_e32 v[66:67], v[96:97]
		buffer_store_dwordx4 v[64:67], v40, s[32:35], 0 offen
		s_and_b32 s6, s24, s4
		s_and_b32 s7, s25, s5
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v40, s16, v9
		v_add3_u32 v40, v40, v26, v4
		v_add3_u32 v40, v40, v31, v33
		v_cndmask_b32_e64 v40, v34, v40, s[6:7]
		v_mov_b64_e32 v[64:65], v[100:101]
		v_mov_b64_e32 v[66:67], v[104:105]
		buffer_store_dwordx4 v[64:67], v40, s[32:35], 0 offen
		s_and_b32 s6, s28, s4
		s_and_b32 s7, s29, s5
		v_add_u32_e32 v40, 0x60, v35
		v_xor_b32_e32 v40, v40, v45
		v_bitop3_b32 v40, v44, v46, v40 bitop3:0x96
		v_mul_lo_u32 v40, s17, v40
		v_lshlrev_b32_e32 v40, 1, v40
		v_add_u32_e32 v41, s16, v40
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[6:7]
		v_mov_b64_e32 v[64:65], v[94:95]
		v_mov_b64_e32 v[66:67], v[98:99]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[6:7], vcc
		s_and_b32 s8, s6, s4
		s_and_b32 s9, s7, s5
		v_add_u32_e32 v11, 0x70, v35
		v_xor_b32_e32 v11, v11, v45
		v_bitop3_b32 v11, v44, v46, v11 bitop3:0x96
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v41, s16, v11
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[8:9]
		v_mov_b64_e32 v[64:65], v[102:103]
		v_mov_b64_e32 v[66:67], v[106:107]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v21, s12
		s_mov_b64 s[8:9], vcc
		s_and_b32 s26, s8, s4
		s_and_b32 s27, s9, s5
		v_add_u32_e32 v21, 0x80, v35
		v_xor_b32_e32 v21, v21, v45
		v_bitop3_b32 v21, v44, v46, v21 bitop3:0x96
		v_mul_lo_u32 v21, s17, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v41, s16, v21
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[26:27]
		v_mov_b64_e32 v[64:65], v[108:109]
		v_mov_b64_e32 v[66:67], v[112:113]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v22, s12
		s_mov_b64 s[26:27], vcc
		s_and_b32 s30, s26, s4
		s_and_b32 s31, s27, s5
		v_add_u32_e32 v22, 0x90, v35
		v_xor_b32_e32 v22, v22, v45
		v_bitop3_b32 v22, v44, v46, v22 bitop3:0x96
		v_mul_lo_u32 v22, s17, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v41, s16, v22
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[30:31]
		v_mov_b64_e32 v[64:65], v[116:117]
		v_mov_b64_e32 v[66:67], v[120:121]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[30:31], vcc
		s_and_b32 s36, s30, s4
		s_and_b32 s37, s31, s5
		v_add_u32_e32 v17, 0xa0, v35
		v_xor_b32_e32 v17, v17, v45
		v_bitop3_b32 v17, v44, v46, v17 bitop3:0x96
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v41, s16, v17
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[36:37]
		v_mov_b64_e32 v[64:65], v[110:111]
		v_mov_b64_e32 v[66:67], v[114:115]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v18, s12
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s36, s4
		s_and_b32 s39, s37, s5
		v_add_u32_e32 v18, 0xb0, v35
		v_xor_b32_e32 v18, v18, v45
		v_bitop3_b32 v18, v44, v46, v18 bitop3:0x96
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v41, s16, v18
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[38:39]
		v_mov_b64_e32 v[64:65], v[118:119]
		v_mov_b64_e32 v[66:67], v[122:123]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[38:39], vcc
		s_and_b32 s40, s38, s4
		s_and_b32 s41, s39, s5
		v_add_u32_e32 v3, 0xc0, v35
		v_xor_b32_e32 v3, v3, v45
		v_bitop3_b32 v3, v44, v46, v3 bitop3:0x96
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add_u32_e32 v41, s16, v3
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[40:41]
		v_mov_b64_e32 v[64:65], v[124:125]
		v_mov_b64_e32 v[66:67], v[128:129]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v20, s12
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s40, s4
		s_and_b32 s43, s41, s5
		v_add_u32_e32 v20, 0xd0, v35
		v_xor_b32_e32 v20, v20, v45
		v_bitop3_b32 v20, v44, v46, v20 bitop3:0x96
		v_mul_lo_u32 v20, s17, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v41, s16, v20
		v_add3_u32 v41, v41, v26, v4
		v_add3_u32 v41, v41, v31, v33
		v_cndmask_b32_e64 v41, v34, v41, s[42:43]
		v_mov_b64_e32 v[64:65], v[132:133]
		v_mov_b64_e32 v[66:67], v[136:137]
		buffer_store_dwordx4 v[64:67], v41, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v61, s12
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s42, s4
		s_and_b32 s45, s43, s5
		v_add_u32_e32 v41, 0xe0, v35
		v_xor_b32_e32 v41, v41, v45
		v_bitop3_b32 v41, v44, v46, v41 bitop3:0x96
		v_mul_lo_u32 v41, s17, v41
		v_lshlrev_b32_e32 v41, 1, v41
		v_add_u32_e32 v42, s16, v41
		v_add3_u32 v42, v42, v26, v4
		v_add3_u32 v42, v42, v31, v33
		v_cndmask_b32_e64 v42, v34, v42, s[44:45]
		v_mov_b64_e32 v[64:65], v[126:127]
		v_mov_b64_e32 v[66:67], v[130:131]
		buffer_store_dwordx4 v[64:67], v42, s[32:35], 0 offen
		v_cmp_lt_i32_e64 vcc, v23, s12
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s44, s4
		s_and_b32 s47, s45, s5
		v_add_u32_e32 v23, 0xf0, v35
		v_xor_b32_e32 v23, v23, v45
		v_bitop3_b32 v23, v44, v46, v23 bitop3:0x96
		v_mul_lo_u32 v23, s17, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_add_u32_e32 v35, s16, v23
		v_add3_u32 v35, v35, v26, v4
		v_add3_u32 v35, v35, v31, v33
		v_cndmask_b32_e64 v35, v34, v35, s[46:47]
		v_mov_b64_e32 v[44:45], v[134:135]
		v_mov_b64_e32 v[46:47], v[138:139]
		buffer_store_dwordx4 v[44:47], v35, s[32:35], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v12, 0xff, v12
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v0, v0, v12
		v_and_b32_e32 v12, 0xff, v13
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v13, 0xff, v14
		v_lshlrev_b32_e32 v13, 24, v13
		v_or3_b32 v0, v0, v12, v13
		v_and_b32_e32 v12, 0xff, v15
		v_and_b32_e32 v13, 0xff, v27
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[0:3], a[128:131], v0, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v13, 8, v13
		v_or_b32_e32 v12, v12, v13
		v_and_b32_e32 v13, 0xff, v28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[0:3], a[132:135], v0, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v14, 0xff, v30
		v_lshlrev_b32_e32 v14, 24, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[8:11], a[148:151], v0, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_or3_b32 v12, v12, v13, v14
		s_add_i32 s4, s61, 0x80
		v_add_u32_e32 v13, s4, v60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[8:11], a[144:147], v0, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], a[4:7], a[128:131], v0, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[4:7], a[132:135], v0, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[12:15], a[148:151], v0, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], a[12:15], a[144:147], v0, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[0:3], a[136:139], v12, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], a[0:3], a[140:143], v12, v5 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], a[8:11], a[156:159], v12, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[8:11], a[152:155], v12, v5 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], a[4:7], a[136:139], v12, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v14, a128
		v_accvgpr_read_b32 v15, a129
		v_cvt_pk_bf16_f32 v44, v14, v15
		v_accvgpr_read_b32 v14, a130
		v_accvgpr_read_b32 v15, a131
		v_cvt_pk_bf16_f32 v45, v14, v15
		v_accvgpr_read_b32 v14, a132
		v_accvgpr_read_b32 v15, a133
		v_cvt_pk_bf16_f32 v64, v14, v15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[84:87], a[4:7], a[140:143], v12, v5 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v14, a134
		v_accvgpr_read_b32 v15, a135
		v_cvt_pk_bf16_f32 v65, v14, v15
		v_accvgpr_read_b32 v14, a144
		v_accvgpr_read_b32 v15, a145
		v_cvt_pk_bf16_f32 v46, v14, v15
		v_accvgpr_read_b32 v14, a146
		v_accvgpr_read_b32 v15, a147
		v_cvt_pk_bf16_f32 v47, v14, v15
		ds_write_b128 v6, v[44:47] offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], a[12:15], a[156:159], v12, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v14, a136
		v_accvgpr_read_b32 v15, a137
		v_cvt_pk_bf16_f32 v44, v14, v15
		v_accvgpr_read_b32 v14, a138
		v_accvgpr_read_b32 v15, a139
		v_cvt_pk_bf16_f32 v45, v14, v15
		v_accvgpr_read_b32 v14, a148
		v_accvgpr_read_b32 v15, a149
		v_cvt_pk_bf16_f32 v66, v14, v15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], a[12:15], a[152:155], v12, v5 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v14, a141
		v_cvt_pk_bf16_f32 v72, v5, v14
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v14, a143
		v_cvt_pk_bf16_f32 v73, v5, v14
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v14, a151
		v_cvt_pk_bf16_f32 v67, v5, v14
		ds_write_b128 v6, v[64:67] offset:7168
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[16:19], a[168:171], v12, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v14, a157
		v_cvt_pk_bf16_f32 v74, v5, v14
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v14, a159
		v_cvt_pk_bf16_f32 v75, v5, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], a[16:19], a[172:175], v12, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v14, a153
		v_cvt_pk_bf16_f32 v46, v5, v14
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v14, a155
		v_cvt_pk_bf16_f32 v47, v5, v14
		ds_write_b128 v6, v[44:47] offset:11264
		ds_write_b128 v6, v[72:75] offset:15360
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[80:83], a[24:27], a[188:191], v12, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[68:71], a[24:27], a[184:187], v12, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[76:79], a[20:23], a[168:171], v12, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], a[20:23], a[172:175], v12, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[84:87], a[28:31], a[188:191], v12, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[76:79], a[28:31], a[184:187], v12, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[16:19], a[160:163], v0, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[16:19], a[164:167], v0, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[52:55], a[24:27], a[180:183], v0, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], a[24:27], a[176:179], v0, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v14, a169
		v_cvt_pk_bf16_f32 v44, v5, v14
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v14, a171
		v_cvt_pk_bf16_f32 v45, v5, v14
		v_accvgpr_read_b32 v5, a172
		v_accvgpr_read_b32 v14, a173
		v_cvt_pk_bf16_f32 v64, v5, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], a[20:23], a[160:163], v0, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a174
		v_accvgpr_read_b32 v14, a175
		v_cvt_pk_bf16_f32 v65, v5, v14
		v_accvgpr_read_b32 v5, a184
		v_accvgpr_read_b32 v14, a185
		v_cvt_pk_bf16_f32 v46, v5, v14
		v_accvgpr_read_b32 v5, a186
		v_accvgpr_read_b32 v14, a187
		v_cvt_pk_bf16_f32 v47, v5, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[20:23], a[164:167], v0, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a188
		v_accvgpr_read_b32 v14, a189
		v_cvt_pk_bf16_f32 v66, v5, v14
		v_accvgpr_read_b32 v5, a190
		v_accvgpr_read_b32 v14, a191
		v_cvt_pk_bf16_f32 v67, v5, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[56:59], a[28:31], a[180:183], v0, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], a[28:31], a[176:179], v0, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v7, a161
		v_cvt_pk_bf16_f32 v72, v5, v7
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v7, a163
		v_cvt_pk_bf16_f32 v73, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], a[32:35], a[192:195], v0, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[52:55], a[32:35], a[196:199], v0, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v7, a165
		v_cvt_pk_bf16_f32 v88, v5, v7
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v7, a167
		v_cvt_pk_bf16_f32 v89, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[52:55], a[40:43], a[212:215], v0, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a180
		v_accvgpr_read_b32 v7, a181
		v_cvt_pk_bf16_f32 v90, v5, v7
		v_accvgpr_read_b32 v5, a176
		v_accvgpr_read_b32 v7, a177
		v_cvt_pk_bf16_f32 v74, v5, v7
		v_accvgpr_read_b32 v5, a178
		v_accvgpr_read_b32 v7, a179
		v_cvt_pk_bf16_f32 v75, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], a[40:43], a[208:211], v0, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a182
		v_accvgpr_read_b32 v7, a183
		v_cvt_pk_bf16_f32 v91, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[48:51], a[36:39], a[192:195], v0, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], a[36:39], a[196:199], v0, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], a[44:47], a[212:215], v0, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[48:51], a[44:47], a[208:211], v0, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[68:71], a[32:35], a[200:203], v12, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[80:83], a[32:35], a[204:207], v12, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[80:83], a[40:43], a[220:223], v12, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[68:71], a[40:43], a[216:219], v12, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[76:79], a[36:39], a[200:203], v12, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a192
		v_accvgpr_read_b32 v7, a193
		v_cvt_pk_bf16_f32 v92, v5, v7
		v_accvgpr_read_b32 v5, a194
		v_accvgpr_read_b32 v7, a195
		v_cvt_pk_bf16_f32 v93, v5, v7
		v_accvgpr_read_b32 v5, a196
		v_accvgpr_read_b32 v7, a197
		v_cvt_pk_bf16_f32 v96, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[84:87], a[36:39], a[204:207], v12, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a198
		v_accvgpr_read_b32 v7, a199
		v_cvt_pk_bf16_f32 v97, v5, v7
		v_accvgpr_read_b32 v5, a208
		v_accvgpr_read_b32 v7, a209
		v_cvt_pk_bf16_f32 v94, v5, v7
		v_accvgpr_read_b32 v5, a210
		v_accvgpr_read_b32 v7, a211
		v_cvt_pk_bf16_f32 v95, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[84:87], a[44:47], a[220:223], v12, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a200
		v_accvgpr_read_b32 v7, a201
		v_cvt_pk_bf16_f32 v100, v5, v7
		v_accvgpr_read_b32 v5, a202
		v_accvgpr_read_b32 v7, a203
		v_cvt_pk_bf16_f32 v101, v5, v7
		v_accvgpr_read_b32 v5, a212
		v_accvgpr_read_b32 v7, a213
		v_cvt_pk_bf16_f32 v98, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[76:79], a[44:47], a[216:219], v12, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a204
		v_accvgpr_read_b32 v7, a205
		v_cvt_pk_bf16_f32 v104, v5, v7
		v_accvgpr_read_b32 v5, a206
		v_accvgpr_read_b32 v7, a207
		v_cvt_pk_bf16_f32 v105, v5, v7
		v_accvgpr_read_b32 v5, a214
		v_accvgpr_read_b32 v7, a215
		v_cvt_pk_bf16_f32 v99, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[68:71], a[48:51], a[232:235], v12, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a220
		v_accvgpr_read_b32 v7, a221
		v_cvt_pk_bf16_f32 v106, v5, v7
		v_accvgpr_read_b32 v5, a222
		v_accvgpr_read_b32 v7, a223
		v_cvt_pk_bf16_f32 v107, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[80:83], a[48:51], a[236:239], v12, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[80:83], a[56:59], a[252:255], v12, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a216
		v_accvgpr_read_b32 v7, a217
		v_cvt_pk_bf16_f32 v102, v5, v7
		v_accvgpr_read_b32 v5, a218
		v_accvgpr_read_b32 v7, a219
		v_cvt_pk_bf16_f32 v103, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[68:71], a[56:59], a[248:251], v12, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[76:79], a[52:55], a[232:235], v12, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[84:87], a[52:55], a[236:239], v12, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[84:87], a[60:63], a[252:255], v12, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[76:79], a[60:63], a[248:251], v12, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], a[48:51], a[224:227], v0, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[52:55], a[48:51], a[228:231], v0, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[52:55], a[56:59], a[244:247], v0, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], a[56:59], a[240:243], v0, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[48:51], a[52:55], a[224:227], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a232
		v_accvgpr_read_b32 v7, a233
		v_cvt_pk_bf16_f32 v36, v5, v7
		v_accvgpr_read_b32 v5, a234
		v_accvgpr_read_b32 v7, a235
		v_cvt_pk_bf16_f32 v37, v5, v7
		v_accvgpr_read_b32 v5, a236
		v_accvgpr_read_b32 v7, a237
		v_cvt_pk_bf16_f32 v52, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[56:59], a[52:55], a[228:231], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a238
		v_accvgpr_read_b32 v7, a239
		v_cvt_pk_bf16_f32 v53, v5, v7
		v_accvgpr_read_b32 v5, a248
		v_accvgpr_read_b32 v7, a249
		v_cvt_pk_bf16_f32 v38, v5, v7
		v_accvgpr_read_b32 v5, a250
		v_accvgpr_read_b32 v7, a251
		v_cvt_pk_bf16_f32 v39, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[56:59], a[60:63], a[244:247], v0, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v5, a224
		v_accvgpr_read_b32 v7, a225
		v_cvt_pk_bf16_f32 v56, v5, v7
		v_accvgpr_read_b32 v5, a226
		v_accvgpr_read_b32 v7, a227
		v_cvt_pk_bf16_f32 v57, v5, v7
		v_accvgpr_read_b32 v5, a252
		v_accvgpr_read_b32 v7, a253
		v_cvt_pk_bf16_f32 v54, v5, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[48:51], a[60:63], a[240:243], v0, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v5, a229
		v_cvt_pk_bf16_f32 v48, v0, v5
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v5, a231
		v_cvt_pk_bf16_f32 v49, v0, v5
		v_accvgpr_read_b32 v0, a254
		v_accvgpr_read_b32 v5, a255
		v_cvt_pk_bf16_f32 v55, v0, v5
		ds_read_b128 v[68:71], v1 offset:3072
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v5, a245
		v_cvt_pk_bf16_f32 v50, v0, v5
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v5, a247
		v_cvt_pk_bf16_f32 v51, v0, v5
		ds_read_b128 v[76:79], v1 offset:3328
		ds_read_b128 v[80:83], v1 offset:5120
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v5, a241
		v_cvt_pk_bf16_f32 v58, v0, v5
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v5, a243
		v_cvt_pk_bf16_f32 v59, v0, v5
		ds_read_b128 v[84:87], v1 offset:5376
		v_cmp_lt_i32_e64 vcc, v13, s13
		s_mov_b64 s[4:5], vcc
		s_and_b32 s12, s2, s4
		s_and_b32 s13, s3, s5
		s_add_i32 s0, s0, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[72:75] offset:3072
		ds_write_b128 v6, v[88:91] offset:7168
		ds_write_b128 v6, v[44:47] offset:11264
		ds_write_b128 v6, v[64:67] offset:15360
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s22
		v_add3_u32 v0, s0, v10, v24
		v_add3_u32 v0, v0, v32, v62
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v1 offset:3072
		ds_read_b128 v[44:47], v1 offset:3328
		ds_read_b128 v[60:63], v1 offset:5120
		ds_read_b128 v[64:67], v1 offset:5376
		v_add3_u32 v0, v0, v26, v4
		v_add3_u32 v0, v0, v31, v33
		v_cndmask_b32_e64 v0, v34, v0, s[12:13]
		v_mov_b64_e32 v[72:73], v[68:69]
		v_mov_b64_e32 v[74:75], v[76:77]
		buffer_store_dwordx4 v[72:75], v0, s[32:35], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[92:95] offset:3072
		ds_write_b128 v6, v[96:99] offset:7168
		ds_write_b128 v6, v[100:103] offset:11264
		ds_write_b128 v6, v[104:107] offset:15360
		s_and_b32 s2, s10, s4
		s_and_b32 s3, s11, s5
		v_add3_u32 v0, v26, v4, v31
		v_add_u32_e32 v0, v0, v33
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v1 offset:3072
		ds_read_b128 v[88:91], v1 offset:3328
		ds_read_b128 v[92:95], v1 offset:5120
		ds_read_b128 v[96:99], v1 offset:5376
		v_add3_u32 v5, v29, v0, s0
		v_cndmask_b32_e64 v5, v34, v5, s[2:3]
		v_mov_b64_e32 v[100:101], v[80:81]
		v_mov_b64_e32 v[102:103], v[84:85]
		buffer_store_dwordx4 v[100:103], v5, s[32:35], 0 offen
		s_and_b32 s2, s14, s4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[56:59] offset:3072
		ds_write_b128 v6, v[48:51] offset:7168
		ds_write_b128 v6, v[36:39] offset:11264
		ds_write_b128 v6, v[52:55] offset:15360
		s_and_b32 s3, s15, s5
		v_add3_u32 v2, v2, v0, s0
		v_cndmask_b32_e64 v2, v34, v2, s[2:3]
		v_mov_b64_e32 v[36:37], v[70:71]
		v_mov_b64_e32 v[38:39], v[78:79]
		buffer_store_dwordx4 v[36:39], v2, s[32:35], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v1 offset:3072
		ds_read_b128 v[48:51], v1 offset:3328
		ds_read_b128 v[52:55], v1 offset:5120
		ds_read_b128 v[56:59], v1 offset:5376
		s_and_b32 s2, s18, s4
		s_and_b32 s3, s19, s5
		v_add3_u32 v0, v8, v0, s0
		v_cndmask_b32_e64 v0, v34, v0, s[2:3]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[68:69], v[82:83]
		v_mov_b64_e32 v[70:71], v[86:87]
		buffer_store_dwordx4 v[68:71], v0, s[32:35], 0 offen
		s_and_b32 s2, s20, s4
		s_and_b32 s3, s21, s5
		v_add3_u32 v0, v26, v4, v31
		v_add_u32_e32 v0, v0, v33
		v_add3_u32 v1, v16, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[68:69], v[12:13]
		v_mov_b64_e32 v[70:71], v[44:45]
		buffer_store_dwordx4 v[68:71], v1, s[32:35], 0 offen
		s_and_b32 s2, s24, s4
		s_and_b32 s3, s25, s5
		v_add3_u32 v1, v9, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[68:69], v[60:61]
		v_mov_b64_e32 v[70:71], v[64:65]
		buffer_store_dwordx4 v[68:71], v1, s[32:35], 0 offen
		s_and_b32 s2, s28, s4
		s_and_b32 s3, s29, s5
		v_add3_u32 v0, v40, v0, s0
		v_cndmask_b32_e64 v0, v34, v0, s[2:3]
		v_mov_b64_e32 v[68:69], v[14:15]
		v_mov_b64_e32 v[70:71], v[46:47]
		buffer_store_dwordx4 v[68:71], v0, s[32:35], 0 offen
		s_and_b32 s2, s6, s4
		s_and_b32 s3, s7, s5
		v_add3_u32 v0, v26, v4, v31
		v_add_u32_e32 v0, v0, v33
		v_add3_u32 v1, v11, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[8:9], v[62:63]
		v_mov_b64_e32 v[10:11], v[66:67]
		buffer_store_dwordx4 v[8:11], v1, s[32:35], 0 offen
		s_and_b32 s2, s8, s4
		s_and_b32 s3, s9, s5
		v_add3_u32 v1, v21, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[8:9], v[72:73]
		v_mov_b64_e32 v[10:11], v[88:89]
		buffer_store_dwordx4 v[8:11], v1, s[32:35], 0 offen
		s_and_b32 s2, s26, s4
		s_and_b32 s3, s27, s5
		v_add3_u32 v0, v22, v0, s0
		v_cndmask_b32_e64 v0, v34, v0, s[2:3]
		v_mov_b64_e32 v[8:9], v[92:93]
		v_mov_b64_e32 v[10:11], v[96:97]
		buffer_store_dwordx4 v[8:11], v0, s[32:35], 0 offen
		s_and_b32 s2, s30, s4
		s_and_b32 s3, s31, s5
		v_add3_u32 v0, v26, v4, v31
		v_add_u32_e32 v0, v0, v33
		v_add3_u32 v1, v17, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[8:9], v[74:75]
		v_mov_b64_e32 v[10:11], v[90:91]
		buffer_store_dwordx4 v[8:11], v1, s[32:35], 0 offen
		s_and_b32 s2, s36, s4
		s_and_b32 s3, s37, s5
		v_add3_u32 v1, v18, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[8:9], v[94:95]
		v_mov_b64_e32 v[10:11], v[98:99]
		buffer_store_dwordx4 v[8:11], v1, s[32:35], 0 offen
		s_and_b32 s2, s38, s4
		s_and_b32 s3, s39, s5
		v_add3_u32 v0, v3, v0, s0
		v_cndmask_b32_e64 v0, v34, v0, s[2:3]
		v_mov_b64_e32 v[8:9], v[36:37]
		v_mov_b64_e32 v[10:11], v[48:49]
		buffer_store_dwordx4 v[8:11], v0, s[32:35], 0 offen
		s_and_b32 s2, s40, s4
		s_and_b32 s3, s41, s5
		v_add3_u32 v0, v26, v4, v31
		v_add_u32_e32 v0, v0, v33
		v_add3_u32 v1, v20, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[4:5], v[52:53]
		v_mov_b64_e32 v[6:7], v[56:57]
		buffer_store_dwordx4 v[4:7], v1, s[32:35], 0 offen
		s_and_b32 s2, s42, s4
		s_and_b32 s3, s43, s5
		v_add3_u32 v1, v41, v0, s0
		v_cndmask_b32_e64 v1, v34, v1, s[2:3]
		v_mov_b64_e32 v[4:5], v[38:39]
		v_mov_b64_e32 v[6:7], v[50:51]
		buffer_store_dwordx4 v[4:7], v1, s[32:35], 0 offen
		s_and_b32 s2, s44, s4
		s_and_b32 s3, s45, s5
		v_add3_u32 v0, v23, v0, s0
		v_cndmask_b32_e64 v0, v34, v0, s[2:3]
		v_mov_b64_e32 v[4:5], v[54:55]
		v_mov_b64_e32 v[6:7], v[58:59]
		buffer_store_dwordx4 v[4:7], v0, s[32:35], 0 offen
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
    wave.regalloc.iterations: 123
    wave.regalloc.agpr.dwords: 488
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
