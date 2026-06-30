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
		v_mov_b32_e32 v1, 0
		v_accvgpr_write_b32 a0, v1
		v_mov_b32_e32 v1, 0
		v_accvgpr_write_b32 a1, v1
		v_mov_b32_e32 v1, 0
		v_accvgpr_write_b32 a2, v1
		v_mov_b32_e32 v1, 0
		v_accvgpr_write_b32 a3, v1
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
		v_add_u32_e32 v4, 0x60, v2
		v_add_u32_e32 v5, 0x70, v2
		v_add_u32_e32 v6, 0x80, v2
		v_add_u32_e32 v7, 0x90, v2
		v_add_u32_e32 v8, 0xa0, v2
		v_add_u32_e32 v9, 0xb0, v2
		v_add_u32_e32 v10, 0xc0, v2
		v_add_u32_e32 v11, 0xd0, v2
		v_add_u32_e32 v12, 0xe0, v2
		v_add_u32_e32 v13, 0xf0, v2
		v_add_u32_e32 v14, s16, v2
		v_add3_u32 v15, 16, v2, s16
		v_add3_u32 v16, 32, v2, s16
		v_add3_u32 v17, 48, v2, s16
		v_add3_u32 v2, 64, v2, s16
		v_add_u32_e32 v3, s16, v3
		v_add_u32_e32 v4, s16, v4
		v_add_u32_e32 v5, s16, v5
		v_add_u32_e32 v6, s16, v6
		v_add_u32_e32 v7, s16, v7
		v_add_u32_e32 v8, s16, v8
		v_add_u32_e32 v9, s16, v9
		v_add_u32_e32 v10, s16, v10
		v_add_u32_e32 v11, s16, v11
		v_add_u32_e32 v12, s16, v12
		v_add_u32_e32 v13, s16, v13
		v_and_b32_e32 v18, 15, v0
		v_mov_b32_e32 v19, 8
		v_mul_lo_u32 v19, v19, v18
		s_mul_i32 s16, s0, 0x100
		v_add_u32_e32 v18, s16, v19
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
		v_lshrrev_b32_e32 v20, 3, v0
		v_mul_lo_u32 v21, s14, v20
		v_lshlrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v23, 0x7f, v22
		v_add3_u32 v24, s22, v21, v23
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_lshl_b32 s23, s14, 5
		s_add_i32 s28, s23, s3
		s_add_i32 s28, s28, s20
		v_add3_u32 v24, s28, v21, v23
		s_add_i32 s29, s2, 0x1000
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 6
		s_add_i32 s31, s30, s3
		s_add_i32 s31, s31, s20
		v_add3_u32 v24, s31, v21, v23
		s_add_i32 s32, s2, 0x2000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s33, 0x60, s14
		s_add_i32 s34, s33, s3
		s_add_i32 s34, s34, s20
		v_add3_u32 v24, s34, v21, v23
		s_add_i32 s35, s2, 0x3000
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_lshl_b32 s36, s14, 7
		s_add_i32 s37, s36, s3
		s_add_i32 s37, s37, s20
		v_add3_u32 v24, s37, v21, v23
		s_add_i32 s38, s2, 0x4000
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s39, 0xa0, s14
		s_add_i32 s40, s39, s3
		s_add_i32 s40, s40, s20
		v_add3_u32 v24, s40, v21, v23
		s_add_i32 s41, s2, 0x5000
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s42, 0xc0, s14
		s_add_i32 s43, s42, s3
		s_add_i32 s43, s43, s20
		v_add3_u32 v24, s43, v21, v23
		s_add_i32 s44, s2, 0x6000
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s45, s14, s3
		s_add_i32 s45, s45, s20
		v_add3_u32 v24, s45, v21, v23
		s_add_i32 s46, s2, 0x7000
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mov_b32 s48, s4
		s_mov_b32 s49, s5
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
		s_mul_i32 s4, s0, s15
		s_lshl_b32 s4, s4, 8
		v_mul_lo_u32 v24, s15, v20
		v_add3_u32 v25, s4, v24, v23
		s_add_i32 s5, s2, 0x10000
		s_mov_b32 m0, s5
		s_nop 0
		buffer_load_dwordx4 v25, s[48:51], 0 offen lds
		s_lshl_b32 s47, s15, 5
		s_add_i32 s52, s47, s4
		v_add3_u32 v25, s52, v24, v23
		s_add_i32 s53, s2, 0x11000
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v25, s[48:51], 0 offen lds
		s_lshl_b32 s54, s15, 6
		s_add_i32 s55, s54, s4
		v_add3_u32 v25, s55, v24, v23
		s_add_i32 s56, s2, 0x12000
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v25, s[48:51], 0 offen lds
		s_mul_i32 s57, 0x60, s15
		s_add_i32 s58, s57, s4
		v_add3_u32 v25, s58, v24, v23
		s_add_i32 s59, s2, 0x13000
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v25, s[48:51], 0 offen lds
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
		v_lshrrev_b32_e32 v25, 7, v0
		v_mul_lo_u32 v26, s18, v25
		v_lshlrev_b32_e32 v27, 7, v26
		v_and_b32_e32 v28, 1, v0
		v_mul_lo_u32 v29, s18, v28
		v_add3_u32 v30, s64, v27, v29
		v_lshrrev_b32_e32 v31, 6, v0
		v_and_b32_e32 v31, 1, v31
		v_mul_lo_u32 v32, s18, v31
		v_lshlrev_b32_e32 v33, 6, v32
		v_lshrrev_b32_e32 v34, 5, v0
		v_and_b32_e32 v34, 1, v34
		v_mul_lo_u32 v35, s18, v34
		v_lshlrev_b32_e32 v36, 5, v35
		v_add3_u32 v30, v30, v33, v36
		v_and_b32_e32 v37, 1, v1
		v_mul_lo_u32 v38, s18, v37
		v_lshlrev_b32_e32 v39, 4, v38
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v40, s18, v20
		v_lshlrev_b32_e32 v41, 3, v40
		v_add3_u32 v30, v30, v39, v41
		v_lshrrev_b32_e32 v42, 2, v0
		v_and_b32_e32 v42, 1, v42
		v_mul_lo_u32 v43, s18, v42
		v_lshlrev_b32_e32 v43, 2, v43
		v_lshrrev_b32_e32 v44, 1, v0
		v_and_b32_e32 v44, 1, v44
		v_mul_lo_u32 v45, s18, v44
		v_lshlrev_b32_e32 v45, 1, v45
		v_add3_u32 v30, v30, v43, v45
		buffer_load_dwordx2 v[46:47], v30, s[60:63], 0 offen
		s_mov_b32 s68, s10
		s_mov_b32 s69, s11
		s_mov_b32 s70, 0x7fffffff
		s_mov_b32 s71, 0x31016000
		s_mul_i32 s10, s0, s19
		s_lshl_b32 s10, s10, 8
		v_mul_lo_u32 v30, s19, v25
		v_lshlrev_b32_e32 v48, 6, v30
		v_mul_lo_u32 v49, s19, v31
		v_lshlrev_b32_e32 v50, 5, v49
		v_add3_u32 v51, s10, v48, v50
		v_mul_lo_u32 v52, s19, v34
		v_lshlrev_b32_e32 v53, 4, v52
		v_mul_lo_u32 v54, s19, v37
		v_lshlrev_b32_e32 v55, 3, v54
		v_add3_u32 v51, v51, v53, v55
		v_mul_lo_u32 v56, s19, v20
		v_lshlrev_b32_e32 v57, 2, v56
		v_mul_lo_u32 v58, s19, v42
		v_lshlrev_b32_e32 v58, 1, v58
		v_add3_u32 v51, v51, v57, v58
		v_mul_lo_u32 v59, s19, v44
		v_lshlrev_b32_e32 v60, 2, v28
		v_add3_u32 v51, v51, v59, v60
		buffer_load_dword v61, v51, s[68:71], 0 offen
		s_lshl_b32 s11, s15, 7
		s_add_i32 s65, s11, s4
		v_add3_u32 v51, s65, v24, v23
		s_add_i32 s66, s2, 0x18000
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_mul_i32 s67, 0xa0, s15
		s_add_i32 s72, s67, s4
		v_add3_u32 v51, s72, v24, v23
		s_add_i32 s73, s2, 0x19000
		s_mov_b32 m0, s73
		s_nop 0
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_mul_i32 s74, 0xc0, s15
		s_add_i32 s75, s74, s4
		v_add3_u32 v51, s75, v24, v23
		s_add_i32 s76, s2, 0x1a000
		s_mov_b32 m0, s76
		s_nop 0
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s77, s15, s4
		v_add3_u32 v51, s77, v24, v23
		s_add_i32 s78, s2, 0x1b000
		s_mov_b32 m0, s78
		s_nop 0
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_lshl_b32 s79, s19, 7
		s_add_i32 s80, s79, s10
		v_lshlrev_b32_e32 v30, 4, v30
		v_lshlrev_b32_e32 v49, 3, v49
		v_add3_u32 v51, s80, v30, v49
		v_lshlrev_b32_e32 v52, 2, v52
		v_lshlrev_b32_e32 v54, 1, v54
		v_add3_u32 v51, v51, v52, v54
		v_add3_u32 v51, v51, v56, v28
		v_lshlrev_b32_e32 v62, 2, v42
		v_lshlrev_b32_e32 v63, 1, v44
		v_add3_u32 v51, v51, v62, v63
		v_lshlrev_b32_e32 v64, 4, v25
		v_lshlrev_b32_e32 v65, 3, v31
		v_lshlrev_b32_e32 v66, 2, v34
		v_add_u32_e32 v67, 32, v20
		v_lshlrev_b32_e32 v68, 1, v37
		v_xor_b32_e32 v67, v67, v68
		v_xor_b32_e32 v67, v66, v67
		v_xor_b32_e32 v67, v65, v67
		v_xor_b32_e32 v67, v64, v67
		v_mul_lo_u32 v69, s19, v67
		v_add3_u32 v70, s80, v69, v28
		v_add3_u32 v70, v70, v62, v63
		v_add_u32_e32 v71, 64, v20
		v_xor_b32_e32 v71, v71, v68
		v_xor_b32_e32 v71, v66, v71
		v_xor_b32_e32 v71, v65, v71
		v_xor_b32_e32 v71, v64, v71
		v_mul_lo_u32 v72, s19, v71
		v_add3_u32 v73, s80, v72, v28
		v_add3_u32 v73, v73, v62, v63
		v_add_u32_e32 v74, 0x60, v20
		v_xor_b32_e32 v74, v74, v68
		v_xor_b32_e32 v74, v66, v74
		v_xor_b32_e32 v74, v65, v74
		v_xor_b32_e32 v74, v64, v74
		v_mul_lo_u32 v75, s19, v74
		v_add3_u32 v76, s80, v75, v28
		v_add3_u32 v76, v76, v62, v63
		buffer_load_ubyte v77, v51, s[68:71], 0 offen
		buffer_load_ubyte v51, v70, s[68:71], 0 offen
		buffer_load_ubyte v70, v73, s[68:71], 0 offen
		buffer_load_ubyte v73, v76, s[68:71], 0 offen
		s_add_i32 s19, s3, 0x80
		s_add_i32 s19, s19, s20
		v_add3_u32 v76, s19, v21, v23
		s_add_i32 s81, s2, 0x8000
		s_mov_b32 m0, s81
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s23, s23, 0x80
		s_add_i32 s23, s23, s3
		s_add_i32 s23, s23, s20
		v_add3_u32 v76, s23, v21, v23
		s_add_i32 s82, s2, 0x9000
		s_mov_b32 m0, s82
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s30, s30, 0x80
		s_add_i32 s30, s30, s3
		s_add_i32 s30, s30, s20
		v_add3_u32 v76, s30, v21, v23
		s_add_i32 s83, s2, 0xa000
		s_mov_b32 m0, s83
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 0x80
		s_add_i32 s33, s33, s3
		s_add_i32 s33, s33, s20
		v_add3_u32 v76, s33, v21, v23
		s_add_i32 s84, s2, 0xb000
		s_mov_b32 m0, s84
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s36, s36, 0x80
		s_add_i32 s36, s36, s3
		s_add_i32 s36, s36, s20
		v_add3_u32 v76, s36, v21, v23
		s_add_i32 s85, s2, 0xc000
		s_mov_b32 m0, s85
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s39, s39, 0x80
		s_add_i32 s39, s39, s3
		s_add_i32 s39, s39, s20
		v_add3_u32 v76, s39, v21, v23
		s_add_i32 s86, s2, 0xd000
		s_mov_b32 m0, s86
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s42, s42, 0x80
		s_add_i32 s42, s42, s3
		s_add_i32 s42, s42, s20
		v_add3_u32 v76, s42, v21, v23
		s_add_i32 s87, s2, 0xe000
		s_mov_b32 m0, s87
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s20
		v_add3_u32 v76, s3, v21, v23
		s_add_i32 s14, s2, 0xf000
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s20, s4, 0x80
		v_add3_u32 v76, s20, v24, v23
		s_add_i32 s88, s2, 0x14000
		s_mov_b32 m0, s88
		s_nop 0
		buffer_load_dwordx4 v76, s[48:51], 0 offen lds
		s_add_i32 s47, s47, 0x80
		s_add_i32 s47, s47, s4
		v_add3_u32 v76, s47, v24, v23
		s_add_i32 s89, s2, 0x15000
		s_mov_b32 m0, s89
		s_nop 0
		buffer_load_dwordx4 v76, s[48:51], 0 offen lds
		s_add_i32 s54, s54, 0x80
		s_add_i32 s54, s54, s4
		v_add3_u32 v76, s54, v24, v23
		s_add_i32 s90, s2, 0x16000
		s_mov_b32 m0, s90
		s_nop 0
		buffer_load_dwordx4 v76, s[48:51], 0 offen lds
		s_add_i32 s57, s57, 0x80
		s_add_i32 s57, s57, s4
		v_add3_u32 v76, s57, v24, v23
		s_add_i32 s91, s2, 0x17000
		s_mov_b32 m0, s91
		s_nop 0
		buffer_load_dwordx4 v76, s[48:51], 0 offen lds
		s_add_i32 s8, s8, 8
		s_add_i32 s8, s8, s9
		v_lshlrev_b32_e32 v26, 4, v26
		v_lshlrev_b32_e32 v32, 3, v32
		v_add3_u32 v76, s8, v26, v32
		v_lshlrev_b32_e32 v35, 2, v35
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v76, v76, v35, v38
		v_add3_u32 v76, v76, v40, v28
		v_add3_u32 v76, v76, v62, v63
		v_mul_lo_u32 v78, s18, v67
		v_add3_u32 v79, s8, v78, v28
		v_add3_u32 v79, v79, v62, v63
		v_mul_lo_u32 v80, s18, v71
		v_add3_u32 v81, s8, v80, v28
		v_add3_u32 v81, v81, v62, v63
		v_mul_lo_u32 v82, s18, v74
		v_add3_u32 v83, s8, v82, v28
		v_add3_u32 v83, v83, v62, v63
		v_add_u32_e32 v84, 0x80, v20
		v_xor_b32_e32 v84, v84, v68
		v_xor_b32_e32 v84, v66, v84
		v_xor_b32_e32 v84, v65, v84
		v_xor_b32_e32 v84, v64, v84
		v_mul_lo_u32 v85, s18, v84
		v_add3_u32 v86, s8, v85, v28
		v_add3_u32 v86, v86, v62, v63
		v_add_u32_e32 v87, 0xa0, v20
		v_xor_b32_e32 v87, v87, v68
		v_xor_b32_e32 v87, v66, v87
		v_xor_b32_e32 v87, v65, v87
		v_xor_b32_e32 v87, v64, v87
		v_mul_lo_u32 v88, s18, v87
		v_add3_u32 v89, s8, v88, v28
		v_add3_u32 v89, v89, v62, v63
		v_add_u32_e32 v90, 0xc0, v20
		v_xor_b32_e32 v90, v90, v68
		v_xor_b32_e32 v90, v66, v90
		v_xor_b32_e32 v90, v65, v90
		v_xor_b32_e32 v90, v64, v90
		v_mul_lo_u32 v91, s18, v90
		v_add3_u32 v92, s8, v91, v28
		v_add3_u32 v92, v92, v62, v63
		v_add_u32_e32 v93, 0xe0, v20
		v_xor_b32_e32 v68, v93, v68
		v_xor_b32_e32 v66, v66, v68
		v_xor_b32_e32 v65, v65, v66
		v_xor_b32_e32 v65, v64, v65
		v_mul_lo_u32 v66, s18, v65
		v_add3_u32 v68, s8, v66, v28
		v_add3_u32 v68, v68, v62, v63
		buffer_load_ubyte v93, v76, s[60:63], 0 offen
		buffer_load_ubyte v76, v79, s[60:63], 0 offen
		buffer_load_ubyte v79, v81, s[60:63], 0 offen
		buffer_load_ubyte v81, v83, s[60:63], 0 offen
		buffer_load_ubyte v83, v86, s[60:63], 0 offen
		buffer_load_ubyte v86, v89, s[60:63], 0 offen
		buffer_load_ubyte v89, v92, s[60:63], 0 offen
		buffer_load_ubyte v92, v68, s[60:63], 0 offen
		s_add_i32 s9, s10, 8
		v_add3_u32 v68, s9, v30, v49
		v_add3_u32 v68, v68, v52, v54
		v_add3_u32 v68, v68, v56, v28
		v_add3_u32 v68, v68, v62, v63
		v_add3_u32 v94, s9, v69, v28
		v_add3_u32 v94, v94, v62, v63
		v_add3_u32 v95, s9, v72, v28
		v_add3_u32 v95, v95, v62, v63
		v_add3_u32 v96, s9, v75, v28
		v_add3_u32 v96, v96, v62, v63
		buffer_load_ubyte v97, v68, s[68:71], 0 offen
		buffer_load_ubyte v68, v94, s[68:71], 0 offen
		buffer_load_ubyte v94, v95, s[68:71], 0 offen
		buffer_load_ubyte v95, v96, s[68:71], 0 offen
		s_add_i32 s11, s11, 0x80
		s_add_i32 s11, s11, s4
		v_add3_u32 v96, s11, v24, v23
		s_add_i32 s18, s2, 0x1c000
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s67, s67, 0x80
		s_add_i32 s67, s67, s4
		v_add3_u32 v96, s67, v24, v23
		s_add_i32 s92, s2, 0x1d000
		s_mov_b32 m0, s92
		s_nop 0
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s74, s74, 0x80
		s_add_i32 s74, s74, s4
		v_add3_u32 v96, s74, v24, v23
		s_add_i32 s93, s2, 0x1e000
		s_mov_b32 m0, s93
		s_nop 0
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s4
		v_add3_u32 v96, s15, v24, v23
		s_add_i32 s94, s2, 0x1f000
		s_mov_b32 m0, s94
		s_nop 0
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s79, s79, 8
		s_add_i32 s79, s79, s10
		v_add3_u32 v96, s79, v30, v49
		v_add3_u32 v96, v96, v52, v54
		v_add3_u32 v96, v96, v56, v28
		v_add3_u32 v96, v96, v62, v63
		v_add3_u32 v98, s79, v69, v28
		v_add3_u32 v98, v98, v62, v63
		v_add3_u32 v99, s79, v72, v28
		v_add3_u32 v99, v99, v62, v63
		v_add3_u32 v100, s79, v75, v28
		v_add3_u32 v100, v100, v62, v63
		buffer_load_ubyte v101, v96, s[68:71], 0 offen
		buffer_load_ubyte v96, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v100, s[68:71], 0 offen
		s_waitcnt vmcnt(42)
		s_barrier
		v_lshlrev_b32_e32 v100, 11, v25
		v_and_b32_e32 v102, 63, v0
		v_lshrrev_b32_e32 v103, 4, v102
		v_lshlrev_b32_e32 v103, 4, v103
		v_and_b32_e32 v102, 15, v102
		v_lshlrev_b32_e32 v102, 7, v102
		v_add3_u32 v100, v100, v103, v102
		ds_read_b128 v[104:107], v100
		ds_read_b128 v[108:111], v100 offset:64
		ds_read_b128 v[112:115], v100 offset:4096
		ds_read_b128 v[116:119], v100 offset:4160
		ds_read_b128 v[120:123], v100 offset:8192
		ds_read_b128 v[124:127], v100 offset:8256
		ds_read_b128 v[128:131], v100 offset:12288
		ds_read_b128 v[132:135], v100 offset:12352
		ds_read_b128 v[136:139], v100 offset:16384
		ds_read_b128 v[140:143], v100 offset:16448
		ds_read_b128 v[144:147], v100 offset:20480
		ds_read_b128 v[148:151], v100 offset:20544
		ds_read_b128 v[152:155], v100 offset:24576
		ds_read_b128 v[156:159], v100 offset:24640
		ds_read_b128 v[160:163], v100 offset:28672
		ds_read_b128 v[164:167], v100 offset:28736
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a4, v164
		v_accvgpr_write_b32 a5, v165
		v_accvgpr_write_b32 a6, v166
		v_accvgpr_write_b32 a7, v167
		v_add_u32_e32 v103, 0x10000, v103
		v_lshlrev_b32_e32 v164, 11, v31
		v_add3_u32 v102, v103, v164, v102
		ds_read_b128 v[164:167], v102
		ds_read_b128 v[168:171], v102 offset:64
		ds_read_b128 v[172:175], v102 offset:4096
		ds_read_b128 v[176:179], v102 offset:4160
		ds_read_b128 v[180:183], v102 offset:8192
		ds_read_b128 v[184:187], v102 offset:8256
		ds_read_b128 v[188:191], v102 offset:12288
		ds_read_b128 v[192:195], v102 offset:12352
		v_lshlrev_b32_e32 v103, 3, v0
		v_add_u32_e32 v103, 0x20000, v103
		s_waitcnt vmcnt(41)
		ds_write_b64 v103, v[46:47]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v46, 2, v0
		v_add_u32_e32 v46, 0x20000, v46
		s_waitcnt vmcnt(40)
		ds_write_b32 v46, v61 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v47, 7, v25
		v_add_u32_e32 v47, 0x20000, v47
		v_lshlrev_b32_e32 v61, 3, v28
		v_add_u32_e32 v47, v47, v61
		v_lshlrev_b32_e32 v196, 1, v34
		v_add_u32_e32 v197, v47, v196
		v_lshlrev_b32_e32 v198, 6, v20
		v_add3_u32 v197, v197, v37, v198
		v_lshlrev_b32_e32 v199, 5, v42
		v_lshlrev_b32_e32 v200, 4, v44
		v_add3_u32 v197, v197, v199, v200
		ds_read_u8 v201, v197
		v_add3_u32 v47, v47, v198, v199
		v_add_u32_e32 v202, 4, v37
		v_xor_b32_e32 v202, v202, v196
		v_add3_u32 v47, v47, v200, v202
		ds_read_u8 v203, v47
		v_add_u32_e32 v204, 0x20000, v196
		v_add_u32_e32 v204, v204, v37
		v_lshlrev_b32_e32 v205, 3, v20
		v_add_u32_e32 v206, 32, v28
		v_xor_b32_e32 v206, v206, v63
		v_xor_b32_e32 v206, v62, v206
		v_xor_b32_e32 v206, v205, v206
		v_xor_b32_e32 v207, v64, v206
		v_lshl_add_u32 v208, v207, 3, v204
		ds_read_u8 v209, v208
		v_add_u32_e32 v210, 0x20000, v202
		v_lshl_add_u32 v207, v207, 3, v210
		ds_read_u8 v211, v207
		v_add_u32_e32 v212, 64, v28
		v_xor_b32_e32 v212, v212, v63
		v_xor_b32_e32 v212, v62, v212
		v_xor_b32_e32 v212, v205, v212
		v_xor_b32_e32 v213, v64, v212
		v_lshl_add_u32 v214, v213, 3, v204
		ds_read_u8 v215, v214
		v_lshl_add_u32 v213, v213, 3, v210
		ds_read_u8 v216, v213
		v_add_u32_e32 v217, 0x60, v28
		v_xor_b32_e32 v217, v217, v63
		v_xor_b32_e32 v217, v62, v217
		v_xor_b32_e32 v217, v205, v217
		v_xor_b32_e32 v218, v64, v217
		v_lshl_add_u32 v219, v218, 3, v204
		ds_read_u8 v220, v219
		v_lshl_add_u32 v218, v218, 3, v210
		ds_read_u8 v221, v218
		v_add_u32_e32 v222, 0x80, v28
		v_xor_b32_e32 v222, v222, v63
		v_xor_b32_e32 v222, v62, v222
		v_xor_b32_e32 v222, v205, v222
		v_xor_b32_e32 v222, v64, v222
		v_lshl_add_u32 v223, v222, 3, v204
		ds_read_u8 v224, v223
		v_lshl_add_u32 v222, v222, 3, v210
		ds_read_u8 v225, v222
		v_add_u32_e32 v226, 0xa0, v28
		v_xor_b32_e32 v226, v226, v63
		v_xor_b32_e32 v226, v62, v226
		v_xor_b32_e32 v226, v205, v226
		v_xor_b32_e32 v226, v64, v226
		v_lshl_add_u32 v227, v226, 3, v204
		ds_read_u8 v228, v227
		v_lshl_add_u32 v226, v226, 3, v210
		ds_read_u8 v229, v226
		v_add_u32_e32 v230, 0xc0, v28
		v_xor_b32_e32 v230, v230, v63
		v_xor_b32_e32 v230, v62, v230
		v_xor_b32_e32 v230, v205, v230
		v_xor_b32_e32 v230, v64, v230
		v_lshl_add_u32 v231, v230, 3, v204
		ds_read_u8 v232, v231
		v_lshl_add_u32 v230, v230, 3, v210
		ds_read_u8 v233, v230
		v_add_u32_e32 v234, 0xe0, v28
		v_xor_b32_e32 v234, v234, v63
		v_xor_b32_e32 v234, v62, v234
		v_xor_b32_e32 v205, v205, v234
		v_xor_b32_e32 v64, v64, v205
		v_lshl_add_u32 v205, v64, 3, v204
		ds_read_u8 v234, v205
		v_lshl_add_u32 v64, v64, 3, v210
		ds_read_u8 v235, v64
		v_add_u32_e32 v61, 0x20000, v61
		v_lshl_add_u32 v61, v31, 7, v61
		v_add_u32_e32 v236, v61, v196
		v_add3_u32 v236, v236, v37, v198
		v_add3_u32 v236, v236, v199, v200
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v237, v236 offset:2048
		v_add3_u32 v61, v61, v198, v199
		v_add3_u32 v61, v61, v200, v202
		ds_read_u8 v198, v61 offset:2048
		v_lshlrev_b32_e32 v199, 4, v31
		v_xor_b32_e32 v200, v199, v206
		v_lshl_add_u32 v202, v200, 3, v204
		ds_read_u8 v206, v202 offset:2048
		v_lshl_add_u32 v200, v200, 3, v210
		ds_read_u8 v238, v200 offset:2048
		v_xor_b32_e32 v212, v199, v212
		v_lshl_add_u32 v239, v212, 3, v204
		ds_read_u8 v240, v239 offset:2048
		v_lshl_add_u32 v212, v212, 3, v210
		ds_read_u8 v241, v212 offset:2048
		v_xor_b32_e32 v199, v199, v217
		v_lshl_add_u32 v204, v199, 3, v204
		ds_read_u8 v217, v204 offset:2048
		v_lshl_add_u32 v199, v199, 3, v210
		ds_read_u8 v210, v199 offset:2048
		s_mov_b32 s95, 0x100
		s_mov_b32 s96, 16
		s_mov_b32 s97, 0
		v_accvgpr_read_b32 v242, a0
		v_and_b32_e32 v242, 0xff, v242
		v_lshlrev_b32_e32 v243, 8, v242
		v_or_b32_e32 v243, v242, v243
		v_lshlrev_b32_e32 v244, 16, v242
		v_lshlrev_b32_e32 v242, 24, v242
		v_or3_b32 v247, v243, v244, v242
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v242, 0x20000, v28
		v_add3_u32 v242, v242, v62, v63
		v_lshl_add_u32 v67, v67, 3, v242
		v_lshl_add_u32 v71, v71, 3, v242
		v_lshl_add_u32 v74, v74, 3, v242
		v_lshl_add_u32 v84, v84, 3, v242
		v_lshl_add_u32 v87, v87, 3, v242
		v_lshl_add_u32 v90, v90, 3, v242
		v_lshl_add_u32 v65, v65, 3, v242
		s_mov_b32 s98, s95
		s_mov_b32 s99, s96
		v_accvgpr_read_b32 v248, a0
		v_accvgpr_read_b32 v249, a1
		v_accvgpr_read_b32 v250, a2
		v_accvgpr_read_b32 v251, a3
		v_mov_b32_e32 v248, v248
		v_mov_b32_e32 v249, v249
		v_mov_b32_e32 v250, v250
		v_mov_b32_e32 v251, v251
		v_accvgpr_write_b32 a0, v248
		v_accvgpr_write_b32 a1, v249
		v_accvgpr_write_b32 a2, v250
		v_accvgpr_write_b32 a3, v251
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a8, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a9, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a10, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a11, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a12, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a13, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a14, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a15, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a16, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a17, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a18, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a19, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a20, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a21, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a22, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a23, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a24, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a25, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a26, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a27, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a28, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a29, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a30, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a31, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a32, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a33, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a34, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a35, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a36, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a37, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a38, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a39, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a40, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a41, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a42, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a43, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a44, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a45, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a46, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a47, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a48, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a49, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a50, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a51, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a52, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a53, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a54, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a55, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a56, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a57, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a58, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a59, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a60, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a61, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a62, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a63, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a64, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a65, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a66, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a67, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a68, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a69, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a70, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a71, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a72, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a73, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a74, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a75, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a76, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a77, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a78, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a79, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a80, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a81, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a82, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a83, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a84, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a85, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a86, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a87, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a88, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a89, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a90, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a91, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a92, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a93, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a94, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a95, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a96, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a97, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a98, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a99, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a100, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a101, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a102, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a103, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a104, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a105, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a106, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a107, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a108, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a109, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a110, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a111, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a112, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a113, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a114, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a115, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a116, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a117, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a118, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a119, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a120, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a121, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a122, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a123, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a124, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a125, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a126, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a127, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a128, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a129, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a130, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a131, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a132, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a133, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a134, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a135, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a136, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a137, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a138, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a139, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a140, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a141, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a142, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a143, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a144, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a145, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a146, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a147, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a148, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a149, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a150, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a151, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a152, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a153, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a154, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a155, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a156, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a157, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a158, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a159, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a160, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a161, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a162, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a163, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a164, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a165, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a166, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a167, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a168, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a169, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a170, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a171, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a172, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a173, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a174, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a175, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a176, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a177, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a178, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a179, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a180, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a181, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a182, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a183, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a184, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a185, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a186, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a187, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a188, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a189, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a190, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a191, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a192, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a193, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a194, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a195, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a196, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a197, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a198, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a199, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a200, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a201, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a202, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a203, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a204, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a205, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a206, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a207, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a208, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a209, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a210, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a211, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a212, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a213, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a214, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a215, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a216, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a217, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a218, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a219, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a220, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a221, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a222, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a223, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a224, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a225, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a226, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a227, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a228, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a229, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a230, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a231, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a232, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a233, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a234, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a235, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a236, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a237, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a238, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a239, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a240, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a241, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a242, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a243, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a244, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a245, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a246, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a247, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a248, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a249, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a250, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a251, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a252, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a253, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a254, v242
		v_mov_b32_e32 v242, 0
		v_accvgpr_write_b32 a255, v242
.L_a4w4_kernel.loop_head_0:
		v_and_b32_e32 v201, 0xff, v201
		v_and_b32_e32 v203, 0xff, v203
		v_lshlrev_b32_e32 v203, 8, v203
		v_or_b32_e32 v201, v201, v203
		v_and_b32_e32 v203, 0xff, v209
		v_lshlrev_b32_e32 v203, 16, v203
		v_and_b32_e32 v209, 0xff, v211
		v_lshlrev_b32_e32 v209, 24, v209
		v_or3_b32 v246, v201, v203, v209
		v_and_b32_e32 v201, 0xff, v215
		v_and_b32_e32 v203, 0xff, v216
		v_lshlrev_b32_e32 v203, 8, v203
		v_or_b32_e32 v201, v201, v203
		v_and_b32_e32 v203, 0xff, v220
		v_lshlrev_b32_e32 v203, 16, v203
		v_and_b32_e32 v209, 0xff, v221
		v_lshlrev_b32_e32 v209, 24, v209
		v_or3_b32 v220, v201, v203, v209
		v_mov_b32_e32 v221, v247
		v_and_b32_e32 v201, 0xff, v224
		v_and_b32_e32 v203, 0xff, v225
		v_lshlrev_b32_e32 v203, 8, v203
		v_or_b32_e32 v201, v201, v203
		v_and_b32_e32 v203, 0xff, v228
		v_lshlrev_b32_e32 v203, 16, v203
		v_and_b32_e32 v209, 0xff, v229
		v_lshlrev_b32_e32 v209, 24, v209
		v_or3_b32 v224, v201, v203, v209
		v_mov_b32_e32 v225, v221
		v_and_b32_e32 v201, 0xff, v232
		v_and_b32_e32 v203, 0xff, v233
		v_lshlrev_b32_e32 v203, 8, v203
		v_or_b32_e32 v201, v201, v203
		v_and_b32_e32 v203, 0xff, v234
		v_lshlrev_b32_e32 v203, 16, v203
		v_and_b32_e32 v209, 0xff, v235
		v_lshlrev_b32_e32 v209, 24, v209
		v_or3_b32 v228, v201, v203, v209
		v_mov_b32_e32 v229, v221
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v201, 0xff, v237
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v198, 0xff, v198
		v_lshlrev_b32_e32 v198, 8, v198
		v_or_b32_e32 v198, v201, v198
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v201, 0xff, v206
		v_lshlrev_b32_e32 v201, 16, v201
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v203, 0xff, v238
		v_lshlrev_b32_e32 v203, 24, v203
		v_or3_b32 v232, v198, v201, v203
		v_mov_b32_e32 v233, v221
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v198, 0xff, v240
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v201, 0xff, v241
		v_lshlrev_b32_e32 v201, 8, v201
		v_or_b32_e32 v198, v198, v201
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v201, 0xff, v217
		v_lshlrev_b32_e32 v201, 16, v201
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v203, 0xff, v210
		v_lshlrev_b32_e32 v203, 24, v203
		v_or3_b32 v210, v198, v201, v203
		v_mov_b32_e32 v211, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[164:167], v[104:107], v[248:251], v232, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[168:171], v[108:111], v[248:251], v232, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[172:175], v[104:107], a[0:3], v232, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[176:179], v[108:111], a[0:3], v232, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[180:183], v[104:107], a[8:11], v210, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[184:187], v[108:111], a[8:11], v210, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[188:191], v[104:107], a[12:15], v210, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[192:195], v[108:111], a[12:15], v210, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[164:167], v[112:115], a[16:19], v232, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[168:171], v[116:119], a[16:19], v232, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[172:175], v[112:115], a[20:23], v232, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[176:179], v[116:119], a[20:23], v232, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[180:183], v[112:115], a[24:27], v210, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[184:187], v[116:119], a[24:27], v210, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[188:191], v[112:115], a[28:31], v210, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[192:195], v[116:119], a[28:31], v210, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[164:167], v[120:123], a[32:35], v232, v220 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[168:171], v[124:127], a[32:35], v232, v220 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[172:175], v[120:123], a[36:39], v232, v220 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[176:179], v[124:127], a[36:39], v232, v220 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[180:183], v[120:123], a[40:43], v210, v220 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[184:187], v[124:127], a[40:43], v210, v220 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[188:191], v[120:123], a[44:47], v210, v220 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[192:195], v[124:127], a[44:47], v210, v220 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[164:167], v[128:131], a[48:51], v232, v220 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[168:171], v[132:135], a[48:51], v232, v220 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[172:175], v[128:131], a[52:55], v232, v220 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[176:179], v[132:135], a[52:55], v232, v220 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[180:183], v[128:131], a[56:59], v210, v220 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[184:187], v[132:135], a[56:59], v210, v220 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[188:191], v[128:131], a[60:63], v210, v220 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[192:195], v[132:135], a[60:63], v210, v220 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[164:167], v[136:139], a[64:67], v232, v224 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[168:171], v[140:143], a[64:67], v232, v224 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[172:175], v[136:139], a[68:71], v232, v224 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[176:179], v[140:143], a[68:71], v232, v224 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[180:183], v[136:139], a[72:75], v210, v224 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[184:187], v[140:143], a[72:75], v210, v224 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[188:191], v[136:139], a[76:79], v210, v224 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[192:195], v[140:143], a[76:79], v210, v224 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[164:167], v[144:147], a[80:83], v232, v224 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[168:171], v[148:151], a[80:83], v232, v224 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[172:175], v[144:147], a[84:87], v232, v224 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[176:179], v[148:151], a[84:87], v232, v224 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[180:183], v[144:147], a[88:91], v210, v224 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[184:187], v[148:151], a[88:91], v210, v224 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[188:191], v[144:147], a[92:95], v210, v224 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[192:195], v[148:151], a[92:95], v210, v224 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[164:167], v[152:155], a[96:99], v232, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[156:159], a[96:99], v232, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[172:175], v[152:155], a[100:103], v232, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[176:179], v[156:159], a[100:103], v232, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[180:183], v[152:155], a[104:107], v210, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[184:187], v[156:159], a[104:107], v210, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[188:191], v[152:155], a[108:111], v210, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[192:195], v[156:159], a[108:111], v210, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[164:167], v[160:163], a[112:115], v232, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], a[4:7], a[112:115], v232, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[172:175], v[160:163], a[116:119], v232, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[176:179], a[4:7], a[116:119], v232, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[180:183], v[160:163], a[120:123], v210, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[184:187], a[4:7], a[120:123], v210, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[188:191], v[160:163], a[124:127], v210, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[192:195], a[4:7], a[124:127], v210, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 v[164:167], v102 offset:32768
		ds_read_b128 v[168:171], v102 offset:32832
		ds_read_b128 v[172:175], v102 offset:36864
		ds_read_b128 v[176:179], v102 offset:36928
		ds_read_b128 v[180:183], v102 offset:40960
		ds_read_b128 v[184:187], v102 offset:41024
		ds_read_b128 v[188:191], v102 offset:45056
		ds_read_b128 v[192:195], v102 offset:45120
		s_waitcnt vmcnt(35)
		ds_write_b8 v0, v77 offset:2048
		s_waitcnt vmcnt(34)
		ds_write_b8 v67, v51 offset:2048
		s_waitcnt vmcnt(33)
		ds_write_b8 v71, v70 offset:2048
		s_waitcnt vmcnt(32)
		ds_write_b8 v74, v73 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v51, v236 offset:2048
		ds_read_u8 v70, v61 offset:2048
		ds_read_u8 v73, v202 offset:2048
		ds_read_u8 v77, v200 offset:2048
		ds_read_u8 v198, v239 offset:2048
		ds_read_u8 v201, v212 offset:2048
		ds_read_u8 v203, v204 offset:2048
		ds_read_u8 v206, v199 offset:2048
		s_add_i32 s100, s22, s95
		s_mov_b32 m0, s2
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s28, s95
		s_mov_b32 m0, s29
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s31, s95
		s_mov_b32 m0, s32
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s34, s95
		s_mov_b32 m0, s35
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s37, s95
		s_mov_b32 m0, s38
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s40, s95
		s_mov_b32 m0, s41
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s43, s95
		s_mov_b32 m0, s44
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s45, s95
		s_mov_b32 m0, s46
		v_add3_u32 v209, s100, v21, v23
		buffer_load_dwordx4 v209, s[24:27], 0 offen lds
		s_add_i32 s100, s4, s98
		s_mov_b32 m0, s5
		v_add3_u32 v209, s100, v24, v23
		buffer_load_dwordx4 v209, s[48:51], 0 offen lds
		s_add_i32 s100, s52, s98
		s_mov_b32 m0, s53
		v_add3_u32 v209, s100, v24, v23
		buffer_load_dwordx4 v209, s[48:51], 0 offen lds
		s_add_i32 s100, s55, s98
		s_mov_b32 m0, s56
		v_add3_u32 v209, s100, v24, v23
		buffer_load_dwordx4 v209, s[48:51], 0 offen lds
		s_add_i32 s100, s58, s98
		s_mov_b32 m0, s59
		v_add3_u32 v209, s100, v24, v23
		buffer_load_dwordx4 v209, s[48:51], 0 offen lds
		s_add_i32 s100, s64, s96
		v_add3_u32 v209, s100, v27, v29
		v_add3_u32 v209, v209, v33, v36
		v_add3_u32 v209, v209, v39, v41
		v_add3_u32 v209, v209, v43, v45
		buffer_load_dwordx2 v[210:211], v209, s[60:63], 0 offen
		s_add_i32 s100, s10, s99
		v_add3_u32 v209, s100, v48, v50
		v_add3_u32 v209, v209, v53, v55
		v_add3_u32 v209, v209, v57, v58
		v_add3_u32 v209, v209, v59, v60
		buffer_load_dword v215, v209, s[68:71], 0 offen
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v51, 0xff, v51
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v70, 0xff, v70
		v_lshlrev_b32_e32 v70, 8, v70
		v_or_b32_e32 v51, v51, v70
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v70, 0xff, v73
		v_lshlrev_b32_e32 v70, 16, v70
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v73, 0xff, v77
		v_lshlrev_b32_e32 v73, 24, v73
		v_or3_b32 v216, v51, v70, v73
		v_mov_b32_e32 v217, v221
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v51, 0xff, v198
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v70, 0xff, v201
		v_lshlrev_b32_e32 v70, 8, v70
		v_or_b32_e32 v51, v51, v70
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v70, 0xff, v203
		v_lshlrev_b32_e32 v70, 16, v70
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v73, 0xff, v206
		v_lshlrev_b32_e32 v73, 24, v73
		v_or3_b32 v232, v51, v70, v73
		v_mov_b32_e32 v233, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[164:167], v[104:107], a[128:131], v216, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[168:171], v[108:111], a[128:131], v216, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[172:175], v[104:107], a[132:135], v216, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[176:179], v[108:111], a[132:135], v216, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[180:183], v[104:107], a[136:139], v232, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[184:187], v[108:111], a[136:139], v232, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[188:191], v[104:107], a[140:143], v232, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[192:195], v[108:111], a[140:143], v232, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[164:167], v[112:115], a[144:147], v216, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[168:171], v[116:119], a[144:147], v216, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[172:175], v[112:115], a[148:151], v216, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[176:179], v[116:119], a[148:151], v216, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[180:183], v[112:115], a[152:155], v232, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[184:187], v[116:119], a[152:155], v232, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[188:191], v[112:115], a[156:159], v232, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[192:195], v[116:119], a[156:159], v232, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[164:167], v[120:123], a[160:163], v216, v220 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[168:171], v[124:127], a[160:163], v216, v220 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[172:175], v[120:123], a[164:167], v216, v220 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[176:179], v[124:127], a[164:167], v216, v220 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[180:183], v[120:123], a[168:171], v232, v220 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[184:187], v[124:127], a[168:171], v232, v220 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[188:191], v[120:123], a[172:175], v232, v220 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[192:195], v[124:127], a[172:175], v232, v220 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[164:167], v[128:131], a[176:179], v216, v220 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[168:171], v[132:135], a[176:179], v216, v220 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[172:175], v[128:131], a[180:183], v216, v220 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[176:179], v[132:135], a[180:183], v216, v220 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[180:183], v[128:131], a[184:187], v232, v220 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[184:187], v[132:135], a[184:187], v232, v220 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[188:191], v[128:131], a[188:191], v232, v220 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[192:195], v[132:135], a[188:191], v232, v220 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[164:167], v[136:139], a[192:195], v216, v224 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[168:171], v[140:143], a[192:195], v216, v224 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[172:175], v[136:139], a[196:199], v216, v224 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[176:179], v[140:143], a[196:199], v216, v224 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[180:183], v[136:139], a[200:203], v232, v224 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[184:187], v[140:143], a[200:203], v232, v224 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[188:191], v[136:139], a[204:207], v232, v224 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[192:195], v[140:143], a[204:207], v232, v224 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[164:167], v[144:147], a[208:211], v216, v224 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[168:171], v[148:151], a[208:211], v216, v224 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[172:175], v[144:147], a[212:215], v216, v224 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[176:179], v[148:151], a[212:215], v216, v224 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[180:183], v[144:147], a[216:219], v232, v224 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[184:187], v[148:151], a[216:219], v232, v224 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[188:191], v[144:147], a[220:223], v232, v224 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[192:195], v[148:151], a[220:223], v232, v224 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[164:167], v[152:155], a[224:227], v216, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[168:171], v[156:159], a[224:227], v216, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[172:175], v[152:155], a[228:231], v216, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[176:179], v[156:159], a[228:231], v216, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[180:183], v[152:155], a[232:235], v232, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[184:187], v[156:159], a[232:235], v232, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[188:191], v[152:155], a[236:239], v232, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[192:195], v[156:159], a[236:239], v232, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[164:167], v[160:163], a[240:243], v216, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[168:171], a[4:7], a[240:243], v216, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[172:175], v[160:163], a[244:247], v216, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[176:179], a[4:7], a[244:247], v216, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[180:183], v[160:163], a[248:251], v232, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[184:187], a[4:7], a[248:251], v232, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[188:191], v[160:163], a[252:255], v232, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[192:195], a[4:7], a[252:255], v232, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
		ds_read_b128 v[104:107], v100 offset:32768
		ds_read_b128 v[108:111], v100 offset:32832
		ds_read_b128 v[112:115], v100 offset:36864
		ds_read_b128 v[116:119], v100 offset:36928
		ds_read_b128 v[120:123], v100 offset:40960
		ds_read_b128 v[124:127], v100 offset:41024
		ds_read_b128 v[128:131], v100 offset:45056
		ds_read_b128 v[132:135], v100 offset:45120
		ds_read_b128 v[136:139], v100 offset:49152
		ds_read_b128 v[140:143], v100 offset:49216
		ds_read_b128 v[144:147], v100 offset:53248
		ds_read_b128 v[148:151], v100 offset:53312
		ds_read_b128 v[152:155], v100 offset:57344
		ds_read_b128 v[156:159], v100 offset:57408
		ds_read_b128 v[160:163], v100 offset:61440
		ds_read_b128 v[164:167], v100 offset:61504
		ds_read_b128 v[168:171], v102 offset:16384
		ds_read_b128 v[172:175], v102 offset:16448
		ds_read_b128 v[176:179], v102 offset:20480
		ds_read_b128 v[180:183], v102 offset:20544
		ds_read_b128 v[184:187], v102 offset:24576
		ds_read_b128 v[188:191], v102 offset:24640
		ds_read_b128 v[192:195], v102 offset:28672
		ds_read_b128 v[232:235], v102 offset:28736
		s_waitcnt vmcnt(33)
		ds_write_b8 v0, v93
		s_waitcnt vmcnt(32)
		ds_write_b8 v67, v76
		s_waitcnt vmcnt(31)
		ds_write_b8 v71, v79
		s_waitcnt vmcnt(30)
		ds_write_b8 v74, v81
		s_waitcnt vmcnt(29)
		ds_write_b8 v84, v83
		s_waitcnt vmcnt(28)
		ds_write_b8 v87, v86
		s_waitcnt vmcnt(27)
		ds_write_b8 v90, v89
		s_waitcnt vmcnt(26)
		ds_write_b8 v65, v92
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v97 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v67, v68 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v71, v94 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v74, v95 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v68, v197
		ds_read_u8 v76, v47
		ds_read_u8 v79, v208
		ds_read_u8 v81, v207
		ds_read_u8 v83, v214
		ds_read_u8 v86, v213
		ds_read_u8 v89, v219
		ds_read_u8 v92, v218
		ds_read_u8 v93, v223
		ds_read_u8 v94, v222
		ds_read_u8 v95, v227
		ds_read_u8 v97, v226
		ds_read_u8 v198, v231
		ds_read_u8 v201, v230
		ds_read_u8 v203, v205
		ds_read_u8 v206, v64
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v209, v236 offset:2048
		ds_read_u8 v216, v61 offset:2048
		ds_read_u8 v217, v202 offset:2048
		ds_read_u8 v220, v200 offset:2048
		ds_read_u8 v224, v239 offset:2048
		ds_read_u8 v225, v212 offset:2048
		ds_read_u8 v228, v204 offset:2048
		ds_read_u8 v229, v199 offset:2048
		s_add_i32 s100, s65, s98
		s_mov_b32 m0, s66
		v_add3_u32 v51, s100, v24, v23
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_add_i32 s100, s72, s98
		s_mov_b32 m0, s73
		v_add3_u32 v51, s100, v24, v23
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_add_i32 s100, s75, s98
		s_mov_b32 m0, s76
		v_add3_u32 v51, s100, v24, v23
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_add_i32 s100, s77, s98
		s_mov_b32 m0, s78
		v_add3_u32 v51, s100, v24, v23
		buffer_load_dwordx4 v51, s[48:51], 0 offen lds
		s_add_i32 s100, s80, s99
		v_add3_u32 v51, s100, v30, v49
		v_add3_u32 v51, v51, v52, v54
		v_add3_u32 v51, v51, v56, v28
		v_add3_u32 v51, v51, v62, v63
		v_add3_u32 v70, s100, v69, v28
		v_add3_u32 v70, v70, v62, v63
		v_add3_u32 v73, s100, v72, v28
		v_add3_u32 v73, v73, v62, v63
		v_add3_u32 v77, s100, v75, v28
		v_add3_u32 v237, v77, v62, v63
		buffer_load_ubyte v77, v51, s[68:71], 0 offen
		buffer_load_ubyte v51, v70, s[68:71], 0 offen
		buffer_load_ubyte v70, v73, s[68:71], 0 offen
		buffer_load_ubyte v73, v237, s[68:71], 0 offen
		v_and_b32_e32 v68, 0xff, v68
		v_and_b32_e32 v76, 0xff, v76
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		v_and_b32_e32 v76, 0xff, v79
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v79, 0xff, v81
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v240, v68, v76, v79
		v_mov_b32_e32 v241, v221
		v_and_b32_e32 v68, 0xff, v83
		v_and_b32_e32 v76, 0xff, v86
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		v_and_b32_e32 v76, 0xff, v89
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v79, 0xff, v92
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v242, v68, v76, v79
		v_mov_b32_e32 v243, v221
		v_and_b32_e32 v68, 0xff, v93
		v_and_b32_e32 v76, 0xff, v94
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		v_and_b32_e32 v76, 0xff, v95
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v79, 0xff, v97
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v244, v68, v76, v79
		v_mov_b32_e32 v245, v221
		v_and_b32_e32 v68, 0xff, v198
		v_and_b32_e32 v76, 0xff, v201
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		v_and_b32_e32 v76, 0xff, v203
		v_lshlrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v79, 0xff, v206
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v252, v68, v76, v79
		v_mov_b32_e32 v253, v221
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v68, 0xff, v209
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v76, 0xff, v216
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v76, 0xff, v217
		v_lshlrev_b32_e32 v76, 16, v76
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v79, 0xff, v220
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v92, v68, v76, v79
		v_mov_b32_e32 v93, v221
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v68, 0xff, v224
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v76, 0xff, v225
		v_lshlrev_b32_e32 v76, 8, v76
		v_or_b32_e32 v68, v68, v76
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v76, 0xff, v228
		v_lshlrev_b32_e32 v76, 16, v76
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v79, 0xff, v229
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v94, v68, v76, v79
		v_mov_b32_e32 v95, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[168:171], v[104:107], v[248:251], v92, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[172:175], v[108:111], v[248:251], v92, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[176:179], v[104:107], a[0:3], v92, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[180:183], v[108:111], a[0:3], v92, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[184:187], v[104:107], a[8:11], v94, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[188:191], v[108:111], a[8:11], v94, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[192:195], v[104:107], a[12:15], v94, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[232:235], v[108:111], a[12:15], v94, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[168:171], v[112:115], a[16:19], v92, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[172:175], v[116:119], a[16:19], v92, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[176:179], v[112:115], a[20:23], v92, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[180:183], v[116:119], a[20:23], v92, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[184:187], v[112:115], a[24:27], v94, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[188:191], v[116:119], a[24:27], v94, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[192:195], v[112:115], a[28:31], v94, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[232:235], v[116:119], a[28:31], v94, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[168:171], v[120:123], a[32:35], v92, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[172:175], v[124:127], a[32:35], v92, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[176:179], v[120:123], a[36:39], v92, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[180:183], v[124:127], a[36:39], v92, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[184:187], v[120:123], a[40:43], v94, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[188:191], v[124:127], a[40:43], v94, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[192:195], v[120:123], a[44:47], v94, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[232:235], v[124:127], a[44:47], v94, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[168:171], v[128:131], a[48:51], v92, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[172:175], v[132:135], a[48:51], v92, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[176:179], v[128:131], a[52:55], v92, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[180:183], v[132:135], a[52:55], v92, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[184:187], v[128:131], a[56:59], v94, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[188:191], v[132:135], a[56:59], v94, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[192:195], v[128:131], a[60:63], v94, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[232:235], v[132:135], a[60:63], v94, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[168:171], v[136:139], a[64:67], v92, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[172:175], v[140:143], a[64:67], v92, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[176:179], v[136:139], a[68:71], v92, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[180:183], v[140:143], a[68:71], v92, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[184:187], v[136:139], a[72:75], v94, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[188:191], v[140:143], a[72:75], v94, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[192:195], v[136:139], a[76:79], v94, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[232:235], v[140:143], a[76:79], v94, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[168:171], v[144:147], a[80:83], v92, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[172:175], v[148:151], a[80:83], v92, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[176:179], v[144:147], a[84:87], v92, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[180:183], v[148:151], a[84:87], v92, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[184:187], v[144:147], a[88:91], v94, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[188:191], v[148:151], a[88:91], v94, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[192:195], v[144:147], a[92:95], v94, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[232:235], v[148:151], a[92:95], v94, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[152:155], a[96:99], v92, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[172:175], v[156:159], a[96:99], v92, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[176:179], v[152:155], a[100:103], v92, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[180:183], v[156:159], a[100:103], v92, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[184:187], v[152:155], a[104:107], v94, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[188:191], v[156:159], a[104:107], v94, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[192:195], v[152:155], a[108:111], v94, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[232:235], v[156:159], a[108:111], v94, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], v[160:163], a[112:115], v92, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[172:175], v[164:167], a[112:115], v92, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[176:179], v[160:163], a[116:119], v92, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[180:183], v[164:167], a[116:119], v92, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[184:187], v[160:163], a[120:123], v94, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[188:191], v[164:167], a[120:123], v94, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[192:195], v[160:163], a[124:127], v94, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[232:235], v[164:167], a[124:127], v94, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 v[168:171], v102 offset:49152
		ds_read_b128 v[172:175], v102 offset:49216
		ds_read_b128 v[176:179], v102 offset:53248
		ds_read_b128 v[180:183], v102 offset:53312
		ds_read_b128 v[184:187], v102 offset:57344
		ds_read_b128 v[188:191], v102 offset:57408
		ds_read_b128 v[192:195], v102 offset:61440
		ds_read_b128 v[232:235], v102 offset:61504
		s_waitcnt vmcnt(25)
		ds_write_b8 v0, v101 offset:2048
		s_waitcnt vmcnt(24)
		ds_write_b8 v67, v96 offset:2048
		s_waitcnt vmcnt(23)
		ds_write_b8 v71, v98 offset:2048
		s_waitcnt vmcnt(22)
		ds_write_b8 v74, v99 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v96, v236 offset:2048
		ds_read_u8 v98, v61 offset:2048
		ds_read_u8 v99, v202 offset:2048
		ds_read_u8 v101, v200 offset:2048
		ds_read_u8 v198, v239 offset:2048
		ds_read_u8 v201, v212 offset:2048
		ds_read_u8 v203, v204 offset:2048
		ds_read_u8 v206, v199 offset:2048
		s_add_i32 s100, s19, s95
		s_mov_b32 m0, s81
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s23, s95
		s_mov_b32 m0, s82
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s30, s95
		s_mov_b32 m0, s83
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s33, s95
		s_mov_b32 m0, s84
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s36, s95
		s_mov_b32 m0, s85
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s39, s95
		s_mov_b32 m0, s86
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s42, s95
		s_mov_b32 m0, s87
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s3, s95
		s_mov_b32 m0, s14
		v_add3_u32 v68, s100, v21, v23
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s100, s20, s98
		s_mov_b32 m0, s88
		v_add3_u32 v68, s100, v24, v23
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
		s_add_i32 s100, s47, s98
		s_mov_b32 m0, s89
		v_add3_u32 v68, s100, v24, v23
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
		s_add_i32 s100, s54, s98
		s_mov_b32 m0, s90
		v_add3_u32 v68, s100, v24, v23
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
		s_add_i32 s100, s57, s98
		s_mov_b32 m0, s91
		v_add3_u32 v68, s100, v24, v23
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
		s_add_i32 s100, s8, s96
		v_add3_u32 v68, s100, v26, v32
		v_add3_u32 v68, v68, v35, v38
		v_add3_u32 v68, v68, v40, v28
		v_add3_u32 v68, v68, v62, v63
		v_add3_u32 v76, s100, v78, v28
		v_add3_u32 v79, v76, v62, v63
		v_add3_u32 v76, s100, v80, v28
		v_add3_u32 v81, v76, v62, v63
		v_add3_u32 v76, s100, v82, v28
		v_add3_u32 v83, v76, v62, v63
		v_add3_u32 v76, s100, v85, v28
		v_add3_u32 v86, v76, v62, v63
		v_add3_u32 v76, s100, v88, v28
		v_add3_u32 v89, v76, v62, v63
		v_add3_u32 v76, s100, v91, v28
		v_add3_u32 v92, v76, v62, v63
		v_add3_u32 v76, s100, v66, v28
		v_add3_u32 v94, v76, v62, v63
		buffer_load_ubyte v93, v68, s[60:63], 0 offen
		buffer_load_ubyte v76, v79, s[60:63], 0 offen
		buffer_load_ubyte v79, v81, s[60:63], 0 offen
		buffer_load_ubyte v81, v83, s[60:63], 0 offen
		buffer_load_ubyte v83, v86, s[60:63], 0 offen
		buffer_load_ubyte v86, v89, s[60:63], 0 offen
		buffer_load_ubyte v89, v92, s[60:63], 0 offen
		buffer_load_ubyte v92, v94, s[60:63], 0 offen
		s_add_i32 s100, s9, s99
		v_add3_u32 v68, s100, v30, v49
		v_add3_u32 v68, v68, v52, v54
		v_add3_u32 v68, v68, v56, v28
		v_add3_u32 v68, v68, v62, v63
		v_add3_u32 v94, s100, v69, v28
		v_add3_u32 v94, v94, v62, v63
		v_add3_u32 v95, s100, v72, v28
		v_add3_u32 v95, v95, v62, v63
		v_add3_u32 v97, s100, v75, v28
		v_add3_u32 v209, v97, v62, v63
		buffer_load_ubyte v97, v68, s[68:71], 0 offen
		buffer_load_ubyte v68, v94, s[68:71], 0 offen
		buffer_load_ubyte v94, v95, s[68:71], 0 offen
		buffer_load_ubyte v95, v209, s[68:71], 0 offen
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v96, 0xff, v96
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v98, 0xff, v98
		v_lshlrev_b32_e32 v98, 8, v98
		v_or_b32_e32 v96, v96, v98
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v98, 0xff, v99
		v_lshlrev_b32_e32 v98, 16, v98
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v99, 0xff, v101
		v_lshlrev_b32_e32 v99, 24, v99
		v_or3_b32 v216, v96, v98, v99
		v_mov_b32_e32 v217, v221
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v96, 0xff, v198
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v98, 0xff, v201
		v_lshlrev_b32_e32 v98, 8, v98
		v_or_b32_e32 v96, v96, v98
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v98, 0xff, v203
		v_lshlrev_b32_e32 v98, 16, v98
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v99, 0xff, v206
		v_lshlrev_b32_e32 v99, 24, v99
		v_or3_b32 v224, v96, v98, v99
		v_mov_b32_e32 v225, v221
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[168:171], v[104:107], a[128:131], v216, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[172:175], v[108:111], a[128:131], v216, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[176:179], v[104:107], a[132:135], v216, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[180:183], v[108:111], a[132:135], v216, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[184:187], v[104:107], a[136:139], v224, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[188:191], v[108:111], a[136:139], v224, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[192:195], v[104:107], a[140:143], v224, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[232:235], v[108:111], a[140:143], v224, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[168:171], v[112:115], a[144:147], v216, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[172:175], v[116:119], a[144:147], v216, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[176:179], v[112:115], a[148:151], v216, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[180:183], v[116:119], a[148:151], v216, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[184:187], v[112:115], a[152:155], v224, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[188:191], v[116:119], a[152:155], v224, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[192:195], v[112:115], a[156:159], v224, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[232:235], v[116:119], a[156:159], v224, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[168:171], v[120:123], a[160:163], v216, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[172:175], v[124:127], a[160:163], v216, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[176:179], v[120:123], a[164:167], v216, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[180:183], v[124:127], a[164:167], v216, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[184:187], v[120:123], a[168:171], v224, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[188:191], v[124:127], a[168:171], v224, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[192:195], v[120:123], a[172:175], v224, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[232:235], v[124:127], a[172:175], v224, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[168:171], v[128:131], a[176:179], v216, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[172:175], v[132:135], a[176:179], v216, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[176:179], v[128:131], a[180:183], v216, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[180:183], v[132:135], a[180:183], v216, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[184:187], v[128:131], a[184:187], v224, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[188:191], v[132:135], a[184:187], v224, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[192:195], v[128:131], a[188:191], v224, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[232:235], v[132:135], a[188:191], v224, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[168:171], v[136:139], a[192:195], v216, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[172:175], v[140:143], a[192:195], v216, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[176:179], v[136:139], a[196:199], v216, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[180:183], v[140:143], a[196:199], v216, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[184:187], v[136:139], a[200:203], v224, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[188:191], v[140:143], a[200:203], v224, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[192:195], v[136:139], a[204:207], v224, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[232:235], v[140:143], a[204:207], v224, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[168:171], v[144:147], a[208:211], v216, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[172:175], v[148:151], a[208:211], v216, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[176:179], v[144:147], a[212:215], v216, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[180:183], v[148:151], a[212:215], v216, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[184:187], v[144:147], a[216:219], v224, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[188:191], v[148:151], a[216:219], v224, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[192:195], v[144:147], a[220:223], v224, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[232:235], v[148:151], a[220:223], v224, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[168:171], v[152:155], a[224:227], v216, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[172:175], v[156:159], a[224:227], v216, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[176:179], v[152:155], a[228:231], v216, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[180:183], v[156:159], a[228:231], v216, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[184:187], v[152:155], a[232:235], v224, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[188:191], v[156:159], a[232:235], v224, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[192:195], v[152:155], a[236:239], v224, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[232:235], v[156:159], a[236:239], v224, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[168:171], v[160:163], a[240:243], v216, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[172:175], v[164:167], a[240:243], v216, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[176:179], v[160:163], a[244:247], v216, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[180:183], v[164:167], a[244:247], v216, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[184:187], v[160:163], a[248:251], v224, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[188:191], v[164:167], a[248:251], v224, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[192:195], v[160:163], a[252:255], v224, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[232:235], v[164:167], a[252:255], v224, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(34)
		s_barrier
		ds_read_b128 v[104:107], v100
		ds_read_b128 v[108:111], v100 offset:64
		ds_read_b128 v[112:115], v100 offset:4096
		ds_read_b128 v[116:119], v100 offset:4160
		ds_read_b128 v[120:123], v100 offset:8192
		ds_read_b128 v[124:127], v100 offset:8256
		ds_read_b128 v[128:131], v100 offset:12288
		ds_read_b128 v[132:135], v100 offset:12352
		ds_read_b128 v[136:139], v100 offset:16384
		ds_read_b128 v[140:143], v100 offset:16448
		ds_read_b128 v[144:147], v100 offset:20480
		ds_read_b128 v[148:151], v100 offset:20544
		ds_read_b128 v[152:155], v100 offset:24576
		ds_read_b128 v[156:159], v100 offset:24640
		ds_read_b128 v[160:163], v100 offset:28672
		ds_read_b128 v[164:167], v100 offset:28736
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a4, v164
		v_accvgpr_write_b32 a5, v165
		v_accvgpr_write_b32 a6, v166
		v_accvgpr_write_b32 a7, v167
		ds_read_b128 v[164:167], v102
		ds_read_b128 v[168:171], v102 offset:64
		ds_read_b128 v[172:175], v102 offset:4096
		ds_read_b128 v[176:179], v102 offset:4160
		ds_read_b128 v[180:183], v102 offset:8192
		ds_read_b128 v[184:187], v102 offset:8256
		ds_read_b128 v[188:191], v102 offset:12288
		ds_read_b128 v[192:195], v102 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v103, v[210:211]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(32)
		ds_write_b32 v46, v215 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v201, v197
		ds_read_u8 v203, v47
		ds_read_u8 v209, v208
		ds_read_u8 v211, v207
		ds_read_u8 v215, v214
		ds_read_u8 v216, v213
		ds_read_u8 v220, v219
		ds_read_u8 v221, v218
		ds_read_u8 v224, v223
		ds_read_u8 v225, v222
		ds_read_u8 v228, v227
		ds_read_u8 v229, v226
		ds_read_u8 v232, v231
		ds_read_u8 v233, v230
		ds_read_u8 v234, v205
		ds_read_u8 v235, v64
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v237, v236 offset:2048
		ds_read_u8 v198, v61 offset:2048
		ds_read_u8 v206, v202 offset:2048
		ds_read_u8 v238, v200 offset:2048
		ds_read_u8 v240, v239 offset:2048
		ds_read_u8 v241, v212 offset:2048
		ds_read_u8 v217, v204 offset:2048
		ds_read_u8 v210, v199 offset:2048
		s_add_i32 s100, s11, s98
		s_mov_b32 m0, s18
		v_add3_u32 v96, s100, v24, v23
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s100, s67, s98
		s_mov_b32 m0, s92
		v_add3_u32 v96, s100, v24, v23
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s100, s74, s98
		s_mov_b32 m0, s93
		v_add3_u32 v96, s100, v24, v23
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s100, s15, s98
		s_mov_b32 m0, s94
		v_add3_u32 v96, s100, v24, v23
		buffer_load_dwordx4 v96, s[48:51], 0 offen lds
		s_add_i32 s100, s79, s99
		v_add3_u32 v96, s100, v30, v49
		v_add3_u32 v96, v96, v52, v54
		v_add3_u32 v96, v96, v56, v28
		v_add3_u32 v96, v96, v62, v63
		v_add3_u32 v98, s100, v69, v28
		v_add3_u32 v98, v98, v62, v63
		v_add3_u32 v99, s100, v72, v28
		v_add3_u32 v99, v99, v62, v63
		v_add3_u32 v101, s100, v75, v28
		v_add3_u32 v242, v101, v62, v63
		buffer_load_ubyte v101, v96, s[68:71], 0 offen
		buffer_load_ubyte v96, v98, s[68:71], 0 offen
		buffer_load_ubyte v98, v99, s[68:71], 0 offen
		buffer_load_ubyte v99, v242, s[68:71], 0 offen
		s_add_i32 s95, s95, 0x100
		s_add_i32 s98, s98, 0x100
		s_add_i32 s96, s96, 16
		s_add_i32 s99, s99, 16
		s_add_i32 s97, s97, 2
		s_cmp_lt_i32 s97, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		v_and_b32_e32 v21, 0xff, v201
		v_and_b32_e32 v23, 0xff, v203
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v209
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v211
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v26, v21, v23, v24
		v_mov_b32_e32 v27, v247
		v_and_b32_e32 v21, 0xff, v215
		v_and_b32_e32 v23, 0xff, v216
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v220
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v221
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v32, v21, v23, v24
		v_mov_b32_e32 v33, v27
		v_and_b32_e32 v21, 0xff, v224
		v_and_b32_e32 v23, 0xff, v225
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v228
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v229
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v38, v21, v23, v24
		v_mov_b32_e32 v39, v27
		v_and_b32_e32 v21, 0xff, v232
		v_and_b32_e32 v23, 0xff, v233
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v234
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v235
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v40, v21, v23, v24
		v_mov_b32_e32 v41, v27
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v21, 0xff, v237
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v23, 0xff, v198
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v23, 0xff, v206
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v24, 0xff, v238
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v48, v21, v23, v24
		v_mov_b32_e32 v49, v27
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v21, 0xff, v240
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v23, 0xff, v241
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v23, 0xff, v217
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v24, 0xff, v210
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v52, v21, v23, v24
		v_mov_b32_e32 v53, v27
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[164:167], v[104:107], v[248:251], v48, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[168:171], v[108:111], v[248:251], v48, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[172:175], v[104:107], a[0:3], v48, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[176:179], v[108:111], a[0:3], v48, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[180:183], v[104:107], a[8:11], v52, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[184:187], v[108:111], a[8:11], v52, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[188:191], v[104:107], a[12:15], v52, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[192:195], v[108:111], a[12:15], v52, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[164:167], v[112:115], a[16:19], v48, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[168:171], v[116:119], a[16:19], v48, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[172:175], v[112:115], a[20:23], v48, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[176:179], v[116:119], a[20:23], v48, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[180:183], v[112:115], a[24:27], v52, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[184:187], v[116:119], a[24:27], v52, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[188:191], v[112:115], a[28:31], v52, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[192:195], v[116:119], a[28:31], v52, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[164:167], v[120:123], a[32:35], v48, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[168:171], v[124:127], a[32:35], v48, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[172:175], v[120:123], a[36:39], v48, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[176:179], v[124:127], a[36:39], v48, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[180:183], v[120:123], a[40:43], v52, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[184:187], v[124:127], a[40:43], v52, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[188:191], v[120:123], a[44:47], v52, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[192:195], v[124:127], a[44:47], v52, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[164:167], v[128:131], a[48:51], v48, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[168:171], v[132:135], a[48:51], v48, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[172:175], v[128:131], a[52:55], v48, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[176:179], v[132:135], a[52:55], v48, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[180:183], v[128:131], a[56:59], v52, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[184:187], v[132:135], a[56:59], v52, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[188:191], v[128:131], a[60:63], v52, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[192:195], v[132:135], a[60:63], v52, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[164:167], v[136:139], a[64:67], v48, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[168:171], v[140:143], a[64:67], v48, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[172:175], v[136:139], a[68:71], v48, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[176:179], v[140:143], a[68:71], v48, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[180:183], v[136:139], a[72:75], v52, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[184:187], v[140:143], a[72:75], v52, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[188:191], v[136:139], a[76:79], v52, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[192:195], v[140:143], a[76:79], v52, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[164:167], v[144:147], a[80:83], v48, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[168:171], v[148:151], a[80:83], v48, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[172:175], v[144:147], a[84:87], v48, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[176:179], v[148:151], a[84:87], v48, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[180:183], v[144:147], a[88:91], v52, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[184:187], v[148:151], a[88:91], v52, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[188:191], v[144:147], a[92:95], v52, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[192:195], v[148:151], a[92:95], v52, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[164:167], v[152:155], a[96:99], v48, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[156:159], a[96:99], v48, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[172:175], v[152:155], a[100:103], v48, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[176:179], v[156:159], a[100:103], v48, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[180:183], v[152:155], a[104:107], v52, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[184:187], v[156:159], a[104:107], v52, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[188:191], v[152:155], a[108:111], v52, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[192:195], v[156:159], a[108:111], v52, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[164:167], v[160:163], a[112:115], v48, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], a[4:7], a[112:115], v48, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[172:175], v[160:163], a[116:119], v48, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[176:179], a[4:7], a[116:119], v48, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[180:183], v[160:163], a[120:123], v52, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[184:187], a[4:7], a[120:123], v52, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[188:191], v[160:163], a[124:127], v52, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[192:195], a[4:7], a[124:127], v52, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[52:55], v102 offset:32768
		ds_read_b128 v[56:59], v102 offset:32832
		ds_read_b128 v[164:167], v102 offset:36864
		ds_read_b128 v[168:171], v102 offset:36928
		ds_read_b128 v[172:175], v102 offset:40960
		ds_read_b128 v[176:179], v102 offset:41024
		ds_read_b128 v[180:183], v102 offset:45056
		ds_read_b128 v[184:187], v102 offset:45120
		ds_write_b8 v0, v77 offset:2048
		ds_write_b8 v67, v51 offset:2048
		ds_write_b8 v71, v70 offset:2048
		ds_write_b8 v74, v73 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v21, v236 offset:2048
		ds_read_u8 v23, v61 offset:2048
		ds_read_u8 v24, v202 offset:2048
		ds_read_u8 v29, v200 offset:2048
		ds_read_u8 v30, v239 offset:2048
		ds_read_u8 v33, v212 offset:2048
		ds_read_u8 v35, v204 offset:2048
		ds_read_u8 v36, v199 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v21, 0xff, v21
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v23, 0xff, v23
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v23, 0xff, v24
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v24, 0xff, v29
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v48, v21, v23, v24
		v_mov_b32_e32 v49, v27
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v21, 0xff, v30
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v23, 0xff, v33
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v23, 0xff, v35
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v24, 0xff, v36
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v50, v21, v23, v24
		v_mov_b32_e32 v51, v27
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], v[104:107], a[128:131], v48, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], v[108:111], a[128:131], v48, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[164:167], v[104:107], a[132:135], v48, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[168:171], v[108:111], a[132:135], v48, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[172:175], v[104:107], a[136:139], v50, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[176:179], v[108:111], a[136:139], v50, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[180:183], v[104:107], a[140:143], v50, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[184:187], v[108:111], a[140:143], v50, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], v[112:115], a[144:147], v48, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], v[116:119], a[144:147], v48, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[164:167], v[112:115], a[148:151], v48, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[168:171], v[116:119], a[148:151], v48, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[172:175], v[112:115], a[152:155], v50, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[176:179], v[116:119], a[152:155], v50, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[180:183], v[112:115], a[156:159], v50, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[184:187], v[116:119], a[156:159], v50, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[120:123], a[160:163], v48, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], v[124:127], a[160:163], v48, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[164:167], v[120:123], a[164:167], v48, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[168:171], v[124:127], a[164:167], v48, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[172:175], v[120:123], a[168:171], v50, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[176:179], v[124:127], a[168:171], v50, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[180:183], v[120:123], a[172:175], v50, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[184:187], v[124:127], a[172:175], v50, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[128:131], a[176:179], v48, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[56:59], v[132:135], a[176:179], v48, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[164:167], v[128:131], a[180:183], v48, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[168:171], v[132:135], a[180:183], v48, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[172:175], v[128:131], a[184:187], v50, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[176:179], v[132:135], a[184:187], v50, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[180:183], v[128:131], a[188:191], v50, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[184:187], v[132:135], a[188:191], v50, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[52:55], v[136:139], a[192:195], v48, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], v[140:143], a[192:195], v48, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[164:167], v[136:139], a[196:199], v48, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[168:171], v[140:143], a[196:199], v48, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[172:175], v[136:139], a[200:203], v50, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[176:179], v[140:143], a[200:203], v50, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[180:183], v[136:139], a[204:207], v50, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[184:187], v[140:143], a[204:207], v50, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[52:55], v[144:147], a[208:211], v48, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], v[148:151], a[208:211], v48, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[164:167], v[144:147], a[212:215], v48, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[168:171], v[148:151], a[212:215], v48, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[172:175], v[144:147], a[216:219], v50, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[176:179], v[148:151], a[216:219], v50, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[180:183], v[144:147], a[220:223], v50, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[184:187], v[148:151], a[220:223], v50, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[52:55], v[152:155], a[224:227], v48, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[56:59], v[156:159], a[224:227], v48, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[164:167], v[152:155], a[228:231], v48, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[168:171], v[156:159], a[228:231], v48, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[172:175], v[152:155], a[232:235], v50, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[176:179], v[156:159], a[232:235], v50, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[180:183], v[152:155], a[236:239], v50, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[184:187], v[156:159], a[236:239], v50, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[52:55], v[160:163], a[240:243], v48, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[56:59], a[4:7], a[240:243], v48, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[164:167], v[160:163], a[244:247], v48, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[168:171], a[4:7], a[244:247], v48, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[172:175], v[160:163], a[248:251], v50, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[176:179], a[4:7], a[248:251], v50, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[180:183], v[160:163], a[252:255], v50, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[184:187], a[4:7], a[252:255], v50, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v100 offset:32768
		ds_read_b128 v[52:55], v100 offset:32832
		ds_read_b128 v[56:59], v100 offset:36864
		ds_read_b128 v[104:107], v100 offset:36928
		ds_read_b128 v[108:111], v100 offset:40960
		ds_read_b128 v[112:115], v100 offset:41024
		ds_read_b128 v[116:119], v100 offset:45056
		ds_read_b128 v[120:123], v100 offset:45120
		ds_read_b128 v[124:127], v100 offset:49152
		ds_read_b128 v[128:131], v100 offset:49216
		ds_read_b128 v[132:135], v100 offset:53248
		ds_read_b128 v[136:139], v100 offset:53312
		ds_read_b128 v[140:143], v100 offset:57344
		ds_read_b128 v[144:147], v100 offset:57408
		ds_read_b128 v[148:151], v100 offset:61440
		ds_read_b128 v[152:155], v100 offset:61504
		ds_read_b128 v[156:159], v102 offset:16384
		ds_read_b128 v[160:163], v102 offset:16448
		ds_read_b128 v[164:167], v102 offset:20480
		ds_read_b128 v[168:171], v102 offset:20544
		ds_read_b128 v[172:175], v102 offset:24576
		ds_read_b128 v[176:179], v102 offset:24640
		ds_read_b128 v[180:183], v102 offset:28672
		ds_read_b128 v[184:187], v102 offset:28736
		ds_write_b8 v0, v93
		ds_write_b8 v67, v76
		ds_write_b8 v71, v79
		ds_write_b8 v74, v81
		ds_write_b8 v84, v83
		ds_write_b8 v87, v86
		ds_write_b8 v90, v89
		ds_write_b8 v65, v92
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v0, v97 offset:2048
		ds_write_b8 v67, v68 offset:2048
		ds_write_b8 v71, v94 offset:2048
		ds_write_b8 v74, v95 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v21, v197
		ds_read_u8 v23, v47
		ds_read_u8 v24, v208
		ds_read_u8 v26, v207
		ds_read_u8 v29, v214
		ds_read_u8 v30, v213
		ds_read_u8 v32, v219
		ds_read_u8 v33, v218
		ds_read_u8 v35, v223
		ds_read_u8 v36, v222
		ds_read_u8 v38, v227
		ds_read_u8 v39, v226
		ds_read_u8 v40, v231
		ds_read_u8 v41, v230
		ds_read_u8 v43, v205
		ds_read_u8 v45, v64
		s_waitcnt lgkmcnt(0)
		ds_read_u8 v46, v236 offset:2048
		ds_read_u8 v47, v61 offset:2048
		ds_read_u8 v60, v202 offset:2048
		ds_read_u8 v62, v200 offset:2048
		ds_read_u8 v63, v239 offset:2048
		ds_read_u8 v64, v212 offset:2048
		ds_read_u8 v65, v204 offset:2048
		ds_read_u8 v66, v199 offset:2048
		v_and_b32_e32 v21, 0xff, v21
		v_and_b32_e32 v23, 0xff, v23
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v24
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v26
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v68, v21, v23, v24
		v_mov_b32_e32 v69, v27
		v_and_b32_e32 v21, 0xff, v29
		v_and_b32_e32 v23, 0xff, v30
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v32
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v33
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v32, v21, v23, v24
		v_mov_b32_e32 v33, v27
		v_and_b32_e32 v21, 0xff, v35
		v_and_b32_e32 v23, 0xff, v36
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v38
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v39
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v38, v21, v23, v24
		v_mov_b32_e32 v39, v27
		v_and_b32_e32 v21, 0xff, v40
		v_and_b32_e32 v23, 0xff, v41
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		v_and_b32_e32 v23, 0xff, v43
		v_lshlrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v24, 0xff, v45
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v40, v21, v23, v24
		v_mov_b32_e32 v41, v27
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v21, 0xff, v46
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v23, 0xff, v47
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v23, 0xff, v60
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v24, 0xff, v62
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v46, v21, v23, v24
		v_mov_b32_e32 v47, v27
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v21, 0xff, v63
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v23, 0xff, v64
		v_lshlrev_b32_e32 v23, 8, v23
		v_or_b32_e32 v21, v21, v23
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v23, 0xff, v65
		v_lshlrev_b32_e32 v23, 16, v23
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v24, 0xff, v66
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v62, v21, v23, v24
		v_mov_b32_e32 v63, v27
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[156:159], v[48:51], v[248:251], v46, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[160:163], v[52:55], v[248:251], v46, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[164:167], v[48:51], a[0:3], v46, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[168:171], v[52:55], a[0:3], v46, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[172:175], v[48:51], a[8:11], v62, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[176:179], v[52:55], a[8:11], v62, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[180:183], v[48:51], a[12:15], v62, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[184:187], v[52:55], a[12:15], v62, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[156:159], v[56:59], a[16:19], v46, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[160:163], v[104:107], a[16:19], v46, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[164:167], v[56:59], a[20:23], v46, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[168:171], v[104:107], a[20:23], v46, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[172:175], v[56:59], a[24:27], v62, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[176:179], v[104:107], a[24:27], v62, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[180:183], v[56:59], a[28:31], v62, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[184:187], v[104:107], a[28:31], v62, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[156:159], v[108:111], a[32:35], v46, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[160:163], v[112:115], a[32:35], v46, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[164:167], v[108:111], a[36:39], v46, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[168:171], v[112:115], a[36:39], v46, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[172:175], v[108:111], a[40:43], v62, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[176:179], v[112:115], a[40:43], v62, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[180:183], v[108:111], a[44:47], v62, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[184:187], v[112:115], a[44:47], v62, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[156:159], v[116:119], a[48:51], v46, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[160:163], v[120:123], a[48:51], v46, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[164:167], v[116:119], a[52:55], v46, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[168:171], v[120:123], a[52:55], v46, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[172:175], v[116:119], a[56:59], v62, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[176:179], v[120:123], a[56:59], v62, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[180:183], v[116:119], a[60:63], v62, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[184:187], v[120:123], a[60:63], v62, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[156:159], v[124:127], a[64:67], v46, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[160:163], v[128:131], a[64:67], v46, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[164:167], v[124:127], a[68:71], v46, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[168:171], v[128:131], a[68:71], v46, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[172:175], v[124:127], a[72:75], v62, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[176:179], v[128:131], a[72:75], v62, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[180:183], v[124:127], a[76:79], v62, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[184:187], v[128:131], a[76:79], v62, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[156:159], v[132:135], a[80:83], v46, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[160:163], v[136:139], a[80:83], v46, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[164:167], v[132:135], a[84:87], v46, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[168:171], v[136:139], a[84:87], v46, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[172:175], v[132:135], a[88:91], v62, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[176:179], v[136:139], a[88:91], v62, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[180:183], v[132:135], a[92:95], v62, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[184:187], v[136:139], a[92:95], v62, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[156:159], v[140:143], a[96:99], v46, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[160:163], v[144:147], a[96:99], v46, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[164:167], v[140:143], a[100:103], v46, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[168:171], v[144:147], a[100:103], v46, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[172:175], v[140:143], a[104:107], v62, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[176:179], v[144:147], a[104:107], v62, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[180:183], v[140:143], a[108:111], v62, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[184:187], v[144:147], a[108:111], v62, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[156:159], v[148:151], a[112:115], v46, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[160:163], v[152:155], a[112:115], v46, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[164:167], v[148:151], a[116:119], v46, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[168:171], v[152:155], a[116:119], v46, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[172:175], v[148:151], a[120:123], v62, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[176:179], v[152:155], a[120:123], v62, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[180:183], v[148:151], a[124:127], v62, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[184:187], v[152:155], a[124:127], v62, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v102 offset:49152
		ds_read_b128 v[80:83], v102 offset:49216
		ds_read_b128 v[84:87], v102 offset:53248
		ds_read_b128 v[88:91], v102 offset:53312
		ds_read_b128 v[92:95], v102 offset:57344
		ds_read_b128 v[156:159], v102 offset:57408
		ds_read_b128 v[160:163], v102 offset:61440
		ds_read_b128 v[164:167], v102 offset:61504
		s_waitcnt vmcnt(3)
		ds_write_b8 v0, v101 offset:2048
		s_waitcnt vmcnt(2)
		ds_write_b8 v67, v96 offset:2048
		s_waitcnt vmcnt(1)
		ds_write_b8 v71, v98 offset:2048
		s_waitcnt vmcnt(0)
		ds_write_b8 v74, v99 offset:2048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_u8 v0, v236 offset:2048
		ds_read_u8 v21, v61 offset:2048
		ds_read_u8 v23, v202 offset:2048
		ds_read_u8 v24, v200 offset:2048
		ds_read_u8 v26, v239 offset:2048
		ds_read_u8 v29, v212 offset:2048
		ds_read_u8 v30, v204 offset:2048
		ds_read_u8 v33, v199 offset:2048
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v15, s12
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v16, s12
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v2, s12
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v4, s12
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v5, s12
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v6, s12
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v7, s12
		s_mov_b64 s[28:29], vcc
		v_cmp_lt_i32_e64 vcc, v8, s12
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v9, s12
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v10, s12
		s_mov_b64 s[34:35], vcc
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v12, s12
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v13, s12
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v18, s13
		s_mov_b64 s[42:43], vcc
		v_cvt_pk_bf16_f32 v4, v248, v249
		v_cvt_pk_bf16_f32 v5, v250, v251
		v_accvgpr_read_b32 v2, a0
		v_accvgpr_read_b32 v3, a1
		v_cvt_pk_bf16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a2
		v_accvgpr_read_b32 v3, a3
		v_cvt_pk_bf16_f32 v9, v2, v3
		v_accvgpr_read_b32 v2, a8
		v_accvgpr_read_b32 v3, a9
		v_cvt_pk_bf16_f32 v12, v2, v3
		v_accvgpr_read_b32 v2, a10
		v_accvgpr_read_b32 v3, a11
		v_cvt_pk_bf16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a12
		v_accvgpr_read_b32 v3, a13
		v_cvt_pk_bf16_f32 v60, v2, v3
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v3, a15
		v_cvt_pk_bf16_f32 v61, v2, v3
		v_accvgpr_read_b32 v2, a16
		v_accvgpr_read_b32 v3, a17
		v_cvt_pk_bf16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a18
		v_accvgpr_read_b32 v3, a19
		v_cvt_pk_bf16_f32 v7, v2, v3
		v_accvgpr_read_b32 v2, a20
		v_accvgpr_read_b32 v3, a21
		v_cvt_pk_bf16_f32 v10, v2, v3
		v_accvgpr_read_b32 v2, a22
		v_accvgpr_read_b32 v3, a23
		v_cvt_pk_bf16_f32 v11, v2, v3
		v_accvgpr_read_b32 v2, a24
		v_accvgpr_read_b32 v3, a25
		v_cvt_pk_bf16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a26
		v_accvgpr_read_b32 v3, a27
		v_cvt_pk_bf16_f32 v15, v2, v3
		v_accvgpr_read_b32 v2, a28
		v_accvgpr_read_b32 v3, a29
		v_cvt_pk_bf16_f32 v62, v2, v3
		v_accvgpr_read_b32 v2, a30
		v_accvgpr_read_b32 v3, a31
		v_cvt_pk_bf16_f32 v63, v2, v3
		v_accvgpr_read_b32 v2, a32
		v_accvgpr_read_b32 v3, a33
		v_cvt_pk_bf16_f32 v64, v2, v3
		v_accvgpr_read_b32 v2, a34
		v_accvgpr_read_b32 v3, a35
		v_cvt_pk_bf16_f32 v65, v2, v3
		v_accvgpr_read_b32 v2, a36
		v_accvgpr_read_b32 v3, a37
		v_cvt_pk_bf16_f32 v72, v2, v3
		v_accvgpr_read_b32 v2, a38
		v_accvgpr_read_b32 v3, a39
		v_cvt_pk_bf16_f32 v73, v2, v3
		v_accvgpr_read_b32 v2, a40
		v_accvgpr_read_b32 v3, a41
		v_cvt_pk_bf16_f32 v96, v2, v3
		v_accvgpr_read_b32 v2, a42
		v_accvgpr_read_b32 v3, a43
		v_cvt_pk_bf16_f32 v97, v2, v3
		v_accvgpr_read_b32 v2, a44
		v_accvgpr_read_b32 v3, a45
		v_cvt_pk_bf16_f32 v100, v2, v3
		v_accvgpr_read_b32 v2, a46
		v_accvgpr_read_b32 v3, a47
		v_cvt_pk_bf16_f32 v101, v2, v3
		v_accvgpr_read_b32 v2, a48
		v_accvgpr_read_b32 v3, a49
		v_cvt_pk_bf16_f32 v66, v2, v3
		v_accvgpr_read_b32 v2, a50
		v_accvgpr_read_b32 v3, a51
		v_cvt_pk_bf16_f32 v67, v2, v3
		v_accvgpr_read_b32 v2, a52
		v_accvgpr_read_b32 v3, a53
		v_cvt_pk_bf16_f32 v74, v2, v3
		v_accvgpr_read_b32 v2, a54
		v_accvgpr_read_b32 v3, a55
		v_cvt_pk_bf16_f32 v75, v2, v3
		v_accvgpr_read_b32 v2, a56
		v_accvgpr_read_b32 v3, a57
		v_cvt_pk_bf16_f32 v98, v2, v3
		v_accvgpr_read_b32 v2, a58
		v_accvgpr_read_b32 v3, a59
		v_cvt_pk_bf16_f32 v99, v2, v3
		v_accvgpr_read_b32 v2, a60
		v_accvgpr_read_b32 v3, a61
		v_cvt_pk_bf16_f32 v102, v2, v3
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v3, a63
		v_cvt_pk_bf16_f32 v103, v2, v3
		v_accvgpr_read_b32 v2, a64
		v_accvgpr_read_b32 v3, a65
		v_cvt_pk_bf16_f32 v168, v2, v3
		v_accvgpr_read_b32 v2, a66
		v_accvgpr_read_b32 v3, a67
		v_cvt_pk_bf16_f32 v169, v2, v3
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
		v_cvt_pk_bf16_f32 v180, v2, v3
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v3, a79
		v_cvt_pk_bf16_f32 v181, v2, v3
		v_accvgpr_read_b32 v2, a80
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_bf16_f32 v170, v2, v3
		v_accvgpr_read_b32 v2, a82
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_bf16_f32 v171, v2, v3
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
		v_cvt_pk_bf16_f32 v182, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_bf16_f32 v183, v2, v3
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
		v_cvt_pk_bf16_f32 v200, v2, v3
		v_accvgpr_read_b32 v2, a110
		v_accvgpr_read_b32 v3, a111
		v_cvt_pk_bf16_f32 v201, v2, v3
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
		v_accvgpr_read_b32 v2, a124
		v_accvgpr_read_b32 v3, a125
		v_cvt_pk_bf16_f32 v202, v2, v3
		v_accvgpr_read_b32 v2, a126
		v_accvgpr_read_b32 v3, a127
		v_cvt_pk_bf16_f32 v203, v2, v3
		v_add_u32_e32 v2, 0x20000, v22
		ds_write_b128 v2, v[4:7] offset:3072
		ds_write_b128 v2, v[8:11] offset:7168
		ds_write_b128 v2, v[12:15] offset:11264
		ds_write_b128 v2, v[60:63] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v28, 9, v1
		v_lshl_add_u32 v1, v20, 13, v1
		v_lshl_add_u32 v1, v42, 12, v1
		v_lshl_add_u32 v1, v44, 10, v1
		ds_read_b128 v[4:7], v1 offset:3072
		ds_read_b128 v[8:11], v1 offset:3328
		ds_read_b128 v[12:15], v1 offset:5120
		ds_read_b128 v[60:63], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[64:67] offset:3072
		ds_write_b128 v2, v[72:75] offset:7168
		ds_write_b128 v2, v[96:99] offset:11264
		ds_write_b128 v2, v[100:103] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v1 offset:3072
		ds_read_b128 v[72:75], v1 offset:3328
		ds_read_b128 v[96:99], v1 offset:5120
		ds_read_b128 v[100:103], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[168:171] offset:3072
		ds_write_b128 v2, v[172:175] offset:7168
		ds_write_b128 v2, v[176:179] offset:11264
		ds_write_b128 v2, v[180:183] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[168:171], v1 offset:3072
		ds_read_b128 v[172:175], v1 offset:3328
		ds_read_b128 v[176:179], v1 offset:5120
		ds_read_b128 v[180:183], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[184:187] offset:3072
		ds_write_b128 v2, v[188:191] offset:7168
		ds_write_b128 v2, v[192:195] offset:11264
		ds_write_b128 v2, v[200:203] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[184:187], v1 offset:3072
		ds_read_b128 v[188:191], v1 offset:3328
		ds_read_b128 v[192:195], v1 offset:5120
		ds_read_b128 v[200:203], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s44, s6
		s_mov_b32 s45, s7
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_and_b32 s6, s2, s42
		s_and_b32 s7, s3, s43
		v_mov_b32_e32 v204, v4
		v_mov_b32_e32 v205, v5
		v_mov_b32_e32 v206, v8
		v_mov_b32_e32 v207, v9
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s1, s1, s17
		s_lshl_b32 s1, s1, 11
		s_add_i32 s12, s0, s1
		s_mul_i32 s20, s21, s17
		s_lshl_b32 s20, s20, 9
		s_add_i32 s12, s12, s20
		v_mul_lo_u32 v3, s17, v25
		v_lshlrev_b32_e32 v3, 4, v3
		v_mul_lo_u32 v4, s17, v31
		v_lshlrev_b32_e32 v4, 3, v4
		v_add3_u32 v5, s12, v3, v4
		v_mul_lo_u32 v8, s17, v34
		v_lshlrev_b32_e32 v8, 2, v8
		v_mul_lo_u32 v9, s17, v37
		v_lshlrev_b32_e32 v9, 1, v9
		v_add3_u32 v5, v5, v8, v9
		v_lshlrev_b32_e32 v16, 4, v28
		v_lshlrev_b32_e32 v17, 7, v20
		v_add3_u32 v5, v5, v16, v17
		v_lshlrev_b32_e32 v18, 6, v42
		v_lshlrev_b32_e32 v20, 5, v44
		v_add3_u32 v5, v5, v18, v20
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v5, v22, v5, s[6:7]
		buffer_store_dwordx4 v[204:207], v5, s[44:47], 0 offen
		s_and_b32 s6, s4, s42
		s_and_b32 s7, s5, s43
		v_mov_b32_e32 v44, v12
		v_mov_b32_e32 v45, v13
		v_mov_b32_e32 v46, v60
		v_mov_b32_e32 v47, v61
		v_lshlrev_b32_e32 v5, 3, v25
		v_lshlrev_b32_e32 v12, 2, v31
		v_add_u32_e32 v13, 16, v37
		v_xor_b32_e32 v13, v13, v196
		v_xor_b32_e32 v13, v12, v13
		v_xor_b32_e32 v13, v5, v13
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v25, v13, 1, s12
		v_add3_u32 v25, v25, v16, v17
		v_add3_u32 v25, v25, v18, v20
		v_cndmask_b32_e64 v25, v22, v25, s[6:7]
		buffer_store_dwordx4 v[44:47], v25, s[44:47], 0 offen
		s_and_b32 s6, s8, s42
		s_and_b32 s7, s9, s43
		v_mov_b32_e32 v44, v6
		v_mov_b32_e32 v45, v7
		v_mov_b32_e32 v46, v10
		v_mov_b32_e32 v47, v11
		v_add_u32_e32 v6, 32, v37
		v_xor_b32_e32 v6, v6, v196
		v_xor_b32_e32 v6, v12, v6
		v_xor_b32_e32 v6, v5, v6
		v_mul_lo_u32 v6, s17, v6
		v_lshl_add_u32 v7, v6, 1, s12
		v_add3_u32 v7, v7, v16, v17
		v_add3_u32 v7, v7, v18, v20
		v_cndmask_b32_e64 v7, v22, v7, s[6:7]
		buffer_store_dwordx4 v[44:47], v7, s[44:47], 0 offen
		s_and_b32 s6, s10, s42
		s_and_b32 s7, s11, s43
		v_mov_b32_e32 v44, v14
		v_mov_b32_e32 v45, v15
		v_mov_b32_e32 v46, v62
		v_mov_b32_e32 v47, v63
		v_add_u32_e32 v7, 48, v37
		v_xor_b32_e32 v7, v7, v196
		v_xor_b32_e32 v7, v12, v7
		v_xor_b32_e32 v7, v5, v7
		v_mul_lo_u32 v7, s17, v7
		v_lshl_add_u32 v10, v7, 1, s12
		v_add3_u32 v10, v10, v16, v17
		v_add3_u32 v10, v10, v18, v20
		v_cndmask_b32_e64 v10, v22, v10, s[6:7]
		buffer_store_dwordx4 v[44:47], v10, s[44:47], 0 offen
		s_and_b32 s6, s14, s42
		s_and_b32 s7, s15, s43
		v_mov_b32_e32 v44, v64
		v_mov_b32_e32 v45, v65
		v_mov_b32_e32 v46, v72
		v_mov_b32_e32 v47, v73
		v_add_u32_e32 v10, 64, v37
		v_xor_b32_e32 v10, v10, v196
		v_xor_b32_e32 v10, v12, v10
		v_xor_b32_e32 v10, v5, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v11, v10, 1, s12
		v_add3_u32 v11, v11, v16, v17
		v_add3_u32 v11, v11, v18, v20
		v_cndmask_b32_e64 v11, v22, v11, s[6:7]
		buffer_store_dwordx4 v[44:47], v11, s[44:47], 0 offen
		s_and_b32 s6, s18, s42
		s_and_b32 s7, s19, s43
		v_mov_b32_e32 v44, v96
		v_mov_b32_e32 v45, v97
		v_mov_b32_e32 v46, v100
		v_mov_b32_e32 v47, v101
		v_add_u32_e32 v11, 0x50, v37
		v_xor_b32_e32 v11, v11, v196
		v_xor_b32_e32 v11, v12, v11
		v_xor_b32_e32 v11, v5, v11
		v_mul_lo_u32 v11, s17, v11
		v_lshl_add_u32 v14, v11, 1, s12
		v_add3_u32 v14, v14, v16, v17
		v_add3_u32 v14, v14, v18, v20
		v_cndmask_b32_e64 v14, v22, v14, s[6:7]
		buffer_store_dwordx4 v[44:47], v14, s[44:47], 0 offen
		s_and_b32 s6, s22, s42
		s_and_b32 s7, s23, s43
		v_mov_b32_e32 v44, v66
		v_mov_b32_e32 v45, v67
		v_mov_b32_e32 v46, v74
		v_mov_b32_e32 v47, v75
		v_add_u32_e32 v14, 0x60, v37
		v_xor_b32_e32 v14, v14, v196
		v_xor_b32_e32 v14, v12, v14
		v_xor_b32_e32 v14, v5, v14
		v_mul_lo_u32 v14, s17, v14
		v_lshl_add_u32 v15, v14, 1, s12
		v_add3_u32 v15, v15, v16, v17
		v_add3_u32 v15, v15, v18, v20
		v_cndmask_b32_e64 v15, v22, v15, s[6:7]
		buffer_store_dwordx4 v[44:47], v15, s[44:47], 0 offen
		s_and_b32 s6, s24, s42
		s_and_b32 s7, s25, s43
		v_mov_b32_e32 v44, v98
		v_mov_b32_e32 v45, v99
		v_mov_b32_e32 v46, v102
		v_mov_b32_e32 v47, v103
		v_add_u32_e32 v15, 0x70, v37
		v_xor_b32_e32 v15, v15, v196
		v_xor_b32_e32 v15, v12, v15
		v_xor_b32_e32 v15, v5, v15
		v_mul_lo_u32 v15, s17, v15
		v_lshl_add_u32 v25, v15, 1, s12
		v_add3_u32 v25, v25, v16, v17
		v_add3_u32 v25, v25, v18, v20
		v_cndmask_b32_e64 v25, v22, v25, s[6:7]
		buffer_store_dwordx4 v[44:47], v25, s[44:47], 0 offen
		s_and_b32 s6, s26, s42
		s_and_b32 s7, s27, s43
		v_mov_b32_e32 v44, v168
		v_mov_b32_e32 v45, v169
		v_mov_b32_e32 v46, v172
		v_mov_b32_e32 v47, v173
		v_add_u32_e32 v25, 0x80, v37
		v_xor_b32_e32 v25, v25, v196
		v_xor_b32_e32 v25, v12, v25
		v_xor_b32_e32 v25, v5, v25
		v_mul_lo_u32 v25, s17, v25
		v_lshl_add_u32 v28, v25, 1, s12
		v_add3_u32 v28, v28, v16, v17
		v_add3_u32 v28, v28, v18, v20
		v_cndmask_b32_e64 v28, v22, v28, s[6:7]
		buffer_store_dwordx4 v[44:47], v28, s[44:47], 0 offen
		s_and_b32 s6, s28, s42
		s_and_b32 s7, s29, s43
		v_mov_b32_e32 v44, v176
		v_mov_b32_e32 v45, v177
		v_mov_b32_e32 v46, v180
		v_mov_b32_e32 v47, v181
		v_add_u32_e32 v28, 0x90, v37
		v_xor_b32_e32 v28, v28, v196
		v_xor_b32_e32 v28, v12, v28
		v_xor_b32_e32 v28, v5, v28
		v_mul_lo_u32 v28, s17, v28
		v_lshl_add_u32 v31, v28, 1, s12
		v_add3_u32 v31, v31, v16, v17
		v_add3_u32 v31, v31, v18, v20
		v_cndmask_b32_e64 v31, v22, v31, s[6:7]
		buffer_store_dwordx4 v[44:47], v31, s[44:47], 0 offen
		s_and_b32 s6, s30, s42
		s_and_b32 s7, s31, s43
		v_mov_b32_e32 v44, v170
		v_mov_b32_e32 v45, v171
		v_mov_b32_e32 v46, v174
		v_mov_b32_e32 v47, v175
		v_add_u32_e32 v31, 0xa0, v37
		v_xor_b32_e32 v31, v31, v196
		v_xor_b32_e32 v31, v12, v31
		v_xor_b32_e32 v31, v5, v31
		v_mul_lo_u32 v31, s17, v31
		v_lshl_add_u32 v34, v31, 1, s12
		v_add3_u32 v34, v34, v16, v17
		v_add3_u32 v34, v34, v18, v20
		v_cndmask_b32_e64 v34, v22, v34, s[6:7]
		buffer_store_dwordx4 v[44:47], v34, s[44:47], 0 offen
		s_and_b32 s6, s32, s42
		s_and_b32 s7, s33, s43
		v_mov_b32_e32 v44, v178
		v_mov_b32_e32 v45, v179
		v_mov_b32_e32 v46, v182
		v_mov_b32_e32 v47, v183
		v_add_u32_e32 v34, 0xb0, v37
		v_xor_b32_e32 v34, v34, v196
		v_xor_b32_e32 v34, v12, v34
		v_xor_b32_e32 v34, v5, v34
		v_mul_lo_u32 v34, s17, v34
		v_lshl_add_u32 v35, v34, 1, s12
		v_add3_u32 v35, v35, v16, v17
		v_add3_u32 v35, v35, v18, v20
		v_cndmask_b32_e64 v35, v22, v35, s[6:7]
		buffer_store_dwordx4 v[44:47], v35, s[44:47], 0 offen
		s_and_b32 s6, s34, s42
		s_and_b32 s7, s35, s43
		v_mov_b32_e32 v44, v184
		v_mov_b32_e32 v45, v185
		v_mov_b32_e32 v46, v188
		v_mov_b32_e32 v47, v189
		v_add_u32_e32 v35, 0xc0, v37
		v_xor_b32_e32 v35, v35, v196
		v_xor_b32_e32 v35, v12, v35
		v_xor_b32_e32 v35, v5, v35
		v_mul_lo_u32 v35, s17, v35
		v_lshl_add_u32 v36, v35, 1, s12
		v_add3_u32 v36, v36, v16, v17
		v_add3_u32 v36, v36, v18, v20
		v_cndmask_b32_e64 v36, v22, v36, s[6:7]
		buffer_store_dwordx4 v[44:47], v36, s[44:47], 0 offen
		s_and_b32 s6, s36, s42
		s_and_b32 s7, s37, s43
		v_mov_b32_e32 v44, v192
		v_mov_b32_e32 v45, v193
		v_mov_b32_e32 v46, v200
		v_mov_b32_e32 v47, v201
		v_add_u32_e32 v36, 0xd0, v37
		v_xor_b32_e32 v36, v36, v196
		v_xor_b32_e32 v36, v12, v36
		v_xor_b32_e32 v36, v5, v36
		v_mul_lo_u32 v36, s17, v36
		v_lshl_add_u32 v39, v36, 1, s12
		v_add3_u32 v39, v39, v16, v17
		v_add3_u32 v39, v39, v18, v20
		v_cndmask_b32_e64 v39, v22, v39, s[6:7]
		buffer_store_dwordx4 v[44:47], v39, s[44:47], 0 offen
		s_and_b32 s6, s38, s42
		s_and_b32 s7, s39, s43
		v_mov_b32_e32 v44, v186
		v_mov_b32_e32 v45, v187
		v_mov_b32_e32 v46, v190
		v_mov_b32_e32 v47, v191
		v_add_u32_e32 v39, 0xe0, v37
		v_xor_b32_e32 v39, v39, v196
		v_xor_b32_e32 v39, v12, v39
		v_xor_b32_e32 v39, v5, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshl_add_u32 v41, v39, 1, s12
		v_add3_u32 v41, v41, v16, v17
		v_add3_u32 v41, v41, v18, v20
		v_cndmask_b32_e64 v41, v22, v41, s[6:7]
		buffer_store_dwordx4 v[44:47], v41, s[44:47], 0 offen
		s_and_b32 s6, s40, s42
		s_and_b32 s7, s41, s43
		v_mov_b32_e32 v44, v194
		v_mov_b32_e32 v45, v195
		v_mov_b32_e32 v46, v202
		v_mov_b32_e32 v47, v203
		v_add_u32_e32 v37, 0xf0, v37
		v_xor_b32_e32 v37, v37, v196
		v_xor_b32_e32 v12, v12, v37
		v_xor_b32_e32 v5, v5, v12
		v_mul_lo_u32 v5, s17, v5
		v_lshl_add_u32 v12, v5, 1, s12
		v_add3_u32 v12, v12, v16, v17
		v_add3_u32 v12, v12, v18, v20
		v_cndmask_b32_e64 v12, v22, v12, s[6:7]
		buffer_store_dwordx4 v[44:47], v12, s[44:47], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v12, 0xff, v21
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v0, v0, v12
		v_and_b32_e32 v12, 0xff, v23
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v21, 0xff, v24
		v_lshlrev_b32_e32 v21, 24, v21
		v_or3_b32 v42, v0, v12, v21
		v_mov_b32_e32 v43, v27
		v_and_b32_e32 v0, 0xff, v26
		v_and_b32_e32 v12, 0xff, v29
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v0, v0, v12
		v_and_b32_e32 v12, 0xff, v30
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v21, 0xff, v33
		v_lshlrev_b32_e32 v21, 24, v21
		v_or3_b32 v44, v0, v12, v21
		v_mov_b32_e32 v45, v27
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], v[48:51], a[128:131], v42, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[80:83], v[52:55], a[128:131], v42, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[84:87], v[48:51], a[132:135], v42, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], v[52:55], a[132:135], v42, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], v[48:51], a[136:139], v44, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[156:159], v[52:55], a[136:139], v44, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[160:163], v[48:51], a[140:143], v44, v68 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[164:167], v[52:55], a[140:143], v44, v68 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], v[56:59], a[144:147], v42, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[104:107], a[144:147], v42, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[84:87], v[56:59], a[148:151], v42, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[88:91], v[104:107], a[148:151], v42, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[56:59], a[152:155], v44, v68 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[156:159], v[104:107], a[152:155], v44, v68 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[160:163], v[56:59], a[156:159], v44, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[164:167], v[104:107], a[156:159], v44, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], v[108:111], a[160:163], v42, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[80:83], v[112:115], a[160:163], v42, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[84:87], v[108:111], a[164:167], v42, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[88:91], v[112:115], a[164:167], v42, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], v[108:111], a[168:171], v44, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[156:159], v[112:115], a[168:171], v44, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[160:163], v[108:111], a[172:175], v44, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[164:167], v[112:115], a[172:175], v44, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[76:79], v[116:119], a[176:179], v42, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[80:83], v[120:123], a[176:179], v42, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[84:87], v[116:119], a[180:183], v42, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[88:91], v[120:123], a[180:183], v42, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[92:95], v[116:119], a[184:187], v44, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[156:159], v[120:123], a[184:187], v44, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[160:163], v[116:119], a[188:191], v44, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[164:167], v[120:123], a[188:191], v44, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[76:79], v[124:127], a[192:195], v42, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[80:83], v[128:131], a[192:195], v42, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[84:87], v[124:127], a[196:199], v42, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[88:91], v[128:131], a[196:199], v42, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[92:95], v[124:127], a[200:203], v44, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[156:159], v[128:131], a[200:203], v44, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[160:163], v[124:127], a[204:207], v44, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[164:167], v[128:131], a[204:207], v44, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[76:79], v[132:135], a[208:211], v42, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[80:83], v[136:139], a[208:211], v42, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[84:87], v[132:135], a[212:215], v42, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[88:91], v[136:139], a[212:215], v42, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[92:95], v[132:135], a[216:219], v44, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[156:159], v[136:139], a[216:219], v44, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[160:163], v[132:135], a[220:223], v44, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[164:167], v[136:139], a[220:223], v44, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[76:79], v[140:143], a[224:227], v42, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[80:83], v[144:147], a[224:227], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[84:87], v[140:143], a[228:231], v42, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[88:91], v[144:147], a[228:231], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[92:95], v[140:143], a[232:235], v44, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[156:159], v[144:147], a[232:235], v44, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[160:163], v[140:143], a[236:239], v44, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[164:167], v[144:147], a[236:239], v44, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[76:79], v[148:151], a[240:243], v42, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[80:83], v[152:155], a[240:243], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[84:87], v[148:151], a[244:247], v42, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[88:91], v[152:155], a[244:247], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[92:95], v[148:151], a[248:251], v44, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[156:159], v[152:155], a[248:251], v44, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[160:163], v[148:151], a[252:255], v44, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[164:167], v[152:155], a[252:255], v44, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s6, s16, 0x80
		v_add_u32_e32 v0, s6, v19
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[6:7], vcc
		v_accvgpr_read_b32 v0, a128
		v_accvgpr_read_b32 v12, a129
		v_cvt_pk_bf16_f32 v40, v0, v12
		v_accvgpr_read_b32 v0, a130
		v_accvgpr_read_b32 v12, a131
		v_cvt_pk_bf16_f32 v41, v0, v12
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v12, a133
		v_cvt_pk_bf16_f32 v44, v0, v12
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v12, a135
		v_cvt_pk_bf16_f32 v45, v0, v12
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v12, a137
		v_cvt_pk_bf16_f32 v48, v0, v12
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v12, a139
		v_cvt_pk_bf16_f32 v49, v0, v12
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v12, a141
		v_cvt_pk_bf16_f32 v52, v0, v12
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v12, a143
		v_cvt_pk_bf16_f32 v53, v0, v12
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v12, a145
		v_cvt_pk_bf16_f32 v42, v0, v12
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v12, a147
		v_cvt_pk_bf16_f32 v43, v0, v12
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v12, a149
		v_cvt_pk_bf16_f32 v46, v0, v12
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v12, a151
		v_cvt_pk_bf16_f32 v47, v0, v12
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v12, a153
		v_cvt_pk_bf16_f32 v50, v0, v12
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v12, a155
		v_cvt_pk_bf16_f32 v51, v0, v12
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v12, a157
		v_cvt_pk_bf16_f32 v54, v0, v12
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v12, a159
		v_cvt_pk_bf16_f32 v55, v0, v12
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v12, a161
		v_cvt_pk_bf16_f32 v56, v0, v12
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v12, a163
		v_cvt_pk_bf16_f32 v57, v0, v12
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v12, a165
		v_cvt_pk_bf16_f32 v60, v0, v12
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v12, a167
		v_cvt_pk_bf16_f32 v61, v0, v12
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v12, a169
		v_cvt_pk_bf16_f32 v64, v0, v12
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v12, a171
		v_cvt_pk_bf16_f32 v65, v0, v12
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v12, a173
		v_cvt_pk_bf16_f32 v68, v0, v12
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v12, a175
		v_cvt_pk_bf16_f32 v69, v0, v12
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v12, a177
		v_cvt_pk_bf16_f32 v58, v0, v12
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v12, a179
		v_cvt_pk_bf16_f32 v59, v0, v12
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v12, a181
		v_cvt_pk_bf16_f32 v62, v0, v12
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v12, a183
		v_cvt_pk_bf16_f32 v63, v0, v12
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v12, a185
		v_cvt_pk_bf16_f32 v66, v0, v12
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v12, a187
		v_cvt_pk_bf16_f32 v67, v0, v12
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v12, a189
		v_cvt_pk_bf16_f32 v70, v0, v12
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v12, a191
		v_cvt_pk_bf16_f32 v71, v0, v12
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v12, a193
		v_cvt_pk_bf16_f32 v72, v0, v12
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v12, a195
		v_cvt_pk_bf16_f32 v73, v0, v12
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v12, a197
		v_cvt_pk_bf16_f32 v76, v0, v12
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v12, a199
		v_cvt_pk_bf16_f32 v77, v0, v12
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v12, a201
		v_cvt_pk_bf16_f32 v80, v0, v12
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v12, a203
		v_cvt_pk_bf16_f32 v81, v0, v12
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v12, a205
		v_cvt_pk_bf16_f32 v84, v0, v12
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v12, a207
		v_cvt_pk_bf16_f32 v85, v0, v12
		v_accvgpr_read_b32 v0, a208
		v_accvgpr_read_b32 v12, a209
		v_cvt_pk_bf16_f32 v74, v0, v12
		v_accvgpr_read_b32 v0, a210
		v_accvgpr_read_b32 v12, a211
		v_cvt_pk_bf16_f32 v75, v0, v12
		v_accvgpr_read_b32 v0, a212
		v_accvgpr_read_b32 v12, a213
		v_cvt_pk_bf16_f32 v78, v0, v12
		v_accvgpr_read_b32 v0, a214
		v_accvgpr_read_b32 v12, a215
		v_cvt_pk_bf16_f32 v79, v0, v12
		v_accvgpr_read_b32 v0, a216
		v_accvgpr_read_b32 v12, a217
		v_cvt_pk_bf16_f32 v82, v0, v12
		v_accvgpr_read_b32 v0, a218
		v_accvgpr_read_b32 v12, a219
		v_cvt_pk_bf16_f32 v83, v0, v12
		v_accvgpr_read_b32 v0, a220
		v_accvgpr_read_b32 v12, a221
		v_cvt_pk_bf16_f32 v86, v0, v12
		v_accvgpr_read_b32 v0, a222
		v_accvgpr_read_b32 v12, a223
		v_cvt_pk_bf16_f32 v87, v0, v12
		v_accvgpr_read_b32 v0, a224
		v_accvgpr_read_b32 v12, a225
		v_cvt_pk_bf16_f32 v88, v0, v12
		v_accvgpr_read_b32 v0, a226
		v_accvgpr_read_b32 v12, a227
		v_cvt_pk_bf16_f32 v89, v0, v12
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v12, a229
		v_cvt_pk_bf16_f32 v92, v0, v12
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v12, a231
		v_cvt_pk_bf16_f32 v93, v0, v12
		v_accvgpr_read_b32 v0, a232
		v_accvgpr_read_b32 v12, a233
		v_cvt_pk_bf16_f32 v96, v0, v12
		v_accvgpr_read_b32 v0, a234
		v_accvgpr_read_b32 v12, a235
		v_cvt_pk_bf16_f32 v97, v0, v12
		v_accvgpr_read_b32 v0, a236
		v_accvgpr_read_b32 v12, a237
		v_cvt_pk_bf16_f32 v100, v0, v12
		v_accvgpr_read_b32 v0, a238
		v_accvgpr_read_b32 v12, a239
		v_cvt_pk_bf16_f32 v101, v0, v12
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v12, a241
		v_cvt_pk_bf16_f32 v90, v0, v12
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v12, a243
		v_cvt_pk_bf16_f32 v91, v0, v12
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v12, a245
		v_cvt_pk_bf16_f32 v94, v0, v12
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v12, a247
		v_cvt_pk_bf16_f32 v95, v0, v12
		v_accvgpr_read_b32 v0, a248
		v_accvgpr_read_b32 v12, a249
		v_cvt_pk_bf16_f32 v98, v0, v12
		v_accvgpr_read_b32 v0, a250
		v_accvgpr_read_b32 v12, a251
		v_cvt_pk_bf16_f32 v99, v0, v12
		v_accvgpr_read_b32 v0, a252
		v_accvgpr_read_b32 v12, a253
		v_cvt_pk_bf16_f32 v102, v0, v12
		v_accvgpr_read_b32 v0, a254
		v_accvgpr_read_b32 v12, a255
		v_cvt_pk_bf16_f32 v103, v0, v12
		ds_write_b128 v2, v[40:43] offset:3072
		ds_write_b128 v2, v[44:47] offset:7168
		ds_write_b128 v2, v[48:51] offset:11264
		ds_write_b128 v2, v[52:55] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v1 offset:3072
		ds_read_b128 v[44:47], v1 offset:3328
		ds_read_b128 v[48:51], v1 offset:5120
		ds_read_b128 v[52:55], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[56:59] offset:3072
		ds_write_b128 v2, v[60:63] offset:7168
		ds_write_b128 v2, v[64:67] offset:11264
		ds_write_b128 v2, v[68:71] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v1 offset:3072
		ds_read_b128 v[60:63], v1 offset:3328
		ds_read_b128 v[64:67], v1 offset:5120
		ds_read_b128 v[68:71], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[72:75] offset:3072
		ds_write_b128 v2, v[76:79] offset:7168
		ds_write_b128 v2, v[80:83] offset:11264
		ds_write_b128 v2, v[84:87] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v1 offset:3072
		ds_read_b128 v[76:79], v1 offset:3328
		ds_read_b128 v[80:83], v1 offset:5120
		ds_read_b128 v[84:87], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[88:91] offset:3072
		ds_write_b128 v2, v[92:95] offset:7168
		ds_write_b128 v2, v[96:99] offset:11264
		ds_write_b128 v2, v[100:103] offset:15360
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[88:91], v1 offset:3072
		ds_read_b128 v[92:95], v1 offset:3328
		ds_read_b128 v[96:99], v1 offset:5120
		ds_read_b128 v[100:103], v1 offset:5376
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s12, s2, s6
		s_and_b32 s13, s3, s7
		v_mov_b32_e32 v104, v40
		v_mov_b32_e32 v105, v41
		v_mov_b32_e32 v106, v44
		v_mov_b32_e32 v107, v45
		s_add_i32 s0, s0, 0x100
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s20
		v_add3_u32 v0, s0, v3, v4
		v_add3_u32 v0, v0, v8, v9
		v_add3_u32 v0, v0, v16, v17
		v_add3_u32 v0, v0, v18, v20
		v_cndmask_b32_e64 v0, v22, v0, s[12:13]
		buffer_store_dwordx4 v[104:107], v0, s[44:47], 0 offen
		s_and_b32 s2, s4, s6
		s_and_b32 s3, s5, s7
		v_mov_b32_e32 v0, v48
		v_mov_b32_e32 v1, v49
		v_mov_b32_e32 v2, v52
		v_mov_b32_e32 v3, v53
		v_lshl_add_u32 v4, v13, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s8, s6
		s_and_b32 s3, s9, s7
		v_mov_b32_e32 v0, v42
		v_mov_b32_e32 v1, v43
		v_mov_b32_e32 v2, v46
		v_mov_b32_e32 v3, v47
		v_lshl_add_u32 v4, v6, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s10, s6
		s_and_b32 s3, s11, s7
		v_mov_b32_e32 v0, v50
		v_mov_b32_e32 v1, v51
		v_mov_b32_e32 v2, v54
		v_mov_b32_e32 v3, v55
		v_lshl_add_u32 v4, v7, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s14, s6
		s_and_b32 s3, s15, s7
		v_mov_b32_e32 v0, v56
		v_mov_b32_e32 v1, v57
		v_mov_b32_e32 v2, v60
		v_mov_b32_e32 v3, v61
		v_lshl_add_u32 v4, v10, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s18, s6
		s_and_b32 s3, s19, s7
		v_mov_b32_e32 v0, v64
		v_mov_b32_e32 v1, v65
		v_mov_b32_e32 v2, v68
		v_mov_b32_e32 v3, v69
		v_lshl_add_u32 v4, v11, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s22, s6
		s_and_b32 s3, s23, s7
		v_mov_b32_e32 v0, v58
		v_mov_b32_e32 v1, v59
		v_mov_b32_e32 v2, v62
		v_mov_b32_e32 v3, v63
		v_lshl_add_u32 v4, v14, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s24, s6
		s_and_b32 s3, s25, s7
		v_mov_b32_e32 v0, v66
		v_mov_b32_e32 v1, v67
		v_mov_b32_e32 v2, v70
		v_mov_b32_e32 v3, v71
		v_lshl_add_u32 v4, v15, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s26, s6
		s_and_b32 s3, s27, s7
		v_mov_b32_e32 v0, v72
		v_mov_b32_e32 v1, v73
		v_mov_b32_e32 v2, v76
		v_mov_b32_e32 v3, v77
		v_lshl_add_u32 v4, v25, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s28, s6
		s_and_b32 s3, s29, s7
		v_mov_b32_e32 v0, v80
		v_mov_b32_e32 v1, v81
		v_mov_b32_e32 v2, v84
		v_mov_b32_e32 v3, v85
		v_lshl_add_u32 v4, v28, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s30, s6
		s_and_b32 s3, s31, s7
		v_mov_b32_e32 v0, v74
		v_mov_b32_e32 v1, v75
		v_mov_b32_e32 v2, v78
		v_mov_b32_e32 v3, v79
		v_lshl_add_u32 v4, v31, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s32, s6
		s_and_b32 s3, s33, s7
		v_mov_b32_e32 v0, v82
		v_mov_b32_e32 v1, v83
		v_mov_b32_e32 v2, v86
		v_mov_b32_e32 v3, v87
		v_lshl_add_u32 v4, v34, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s34, s6
		s_and_b32 s3, s35, s7
		v_mov_b32_e32 v0, v88
		v_mov_b32_e32 v1, v89
		v_mov_b32_e32 v2, v92
		v_mov_b32_e32 v3, v93
		v_lshl_add_u32 v4, v35, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s36, s6
		s_and_b32 s3, s37, s7
		v_mov_b32_e32 v0, v96
		v_mov_b32_e32 v1, v97
		v_mov_b32_e32 v2, v100
		v_mov_b32_e32 v3, v101
		v_lshl_add_u32 v4, v36, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s38, s6
		s_and_b32 s3, s39, s7
		v_mov_b32_e32 v0, v90
		v_mov_b32_e32 v1, v91
		v_mov_b32_e32 v2, v94
		v_mov_b32_e32 v3, v95
		v_lshl_add_u32 v4, v39, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
		buffer_store_dwordx4 v[0:3], v4, s[44:47], 0 offen
		s_and_b32 s2, s40, s6
		s_and_b32 s3, s41, s7
		v_mov_b32_e32 v0, v98
		v_mov_b32_e32 v1, v99
		v_mov_b32_e32 v2, v102
		v_mov_b32_e32 v3, v103
		v_lshl_add_u32 v4, v5, 1, s0
		v_add3_u32 v4, v4, v16, v17
		v_add3_u32 v4, v4, v18, v20
		v_cndmask_b32_e64 v4, v22, v4, s[2:3]
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
		.amdhsa_next_free_vgpr 512
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
	.set .L_a4w4_kernel.num_vgpr, 254
	.set .L_a4w4_kernel.num_agpr, 256
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
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
