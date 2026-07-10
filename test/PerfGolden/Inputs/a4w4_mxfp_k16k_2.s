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
		s_mul_i32 s16, s0, 0x100
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s21, v0
		v_lshrrev_b32_e32 v1, 7, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v4, s14, v3
		v_add_u32_e32 v5, v2, v4
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v7, 1, v6
		v_mul_lo_u32 v8, s14, v7
		v_lshlrev_b32_e32 v8, 6, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_accvgpr_write_b32 a0, v9
		v_accvgpr_read_b32 v9, a0
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v10, s14, v9
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v5, v5, v8, v10
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v12, 1, v11
		v_mul_lo_u32 v13, s14, v12
		v_lshlrev_b32_e32 v13, 4, v13
		v_and_b32_e32 v14, 1, v0
		v_lshlrev_b32_e32 v15, 4, v14
		v_add3_u32 v5, v5, v13, v15
		v_lshrrev_b32_e32 v16, 2, v0
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 1, v0
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 5, v18
		v_add3_u32 v5, v5, v17, v19
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		v_mov_b32_e32 v20, 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v21, s22, v2, v4
		v_add3_u32 v21, v21, v8, v10
		v_add3_u32 v21, v21, v13, v15
		v_add3_u32 v24, v21, v17, v19
		s_add_i32 m0, s21, 0x1080
		s_mul_i32 s16, s16, s15
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v21, v2, v4, v8
		v_add3_u32 v21, v21, v10, v13
		v_add3_u32 v21, v21, v15, v17
		s_add_i32 m0, s21, 0x2100
		v_add3_u32 v25, v19, v21, s28
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s21, 0x3180
		v_add3_u32 v26, v19, v21, s29
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s21, 0x4200
		v_add3_u32 v27, v19, v21, s30
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v21, v2, v4, v8
		v_add3_u32 v21, v21, v10, v13
		v_add3_u32 v21, v21, v15, v17
		s_add_i32 m0, s21, 0x5280
		v_add3_u32 v28, v19, v21, s31
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s21, 0x6300
		v_add3_u32 v29, v19, v21, s32
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s21, 0x7380
		v_add3_u32 v30, v19, v21, s14
		s_add_u32 s36, s4, s16
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v21, s15, v1
		v_lshlrev_b32_e32 v21, 1, v21
		v_mul_lo_u32 v22, s15, v3
		v_add_u32_e32 v23, v21, v22
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		v_mul_lo_u32 v31, s15, v7
		v_lshlrev_b32_e32 v31, 6, v31
		v_mul_lo_u32 v32, s15, v9
		v_lshlrev_b32_e32 v32, 5, v32
		v_add3_u32 v23, v23, v31, v32
		v_mul_lo_u32 v33, s15, v12
		v_lshlrev_b32_e32 v33, 4, v33
		v_add3_u32 v23, v23, v33, v15
		s_add_i32 m0, s21, 0x107c0
		v_add3_u32 v34, v23, v17, v19
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v34, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v23, v21, v22, v31
		v_add3_u32 v23, v23, v32, v33
		v_add3_u32 v23, v23, v15, v17
		s_add_i32 m0, s21, 0x11840
		v_add3_u32 v35, v19, v23, s33
		buffer_load_dwordx4 v35, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s21, 0x128c0
		v_add3_u32 v36, v19, v23, s34
		buffer_load_dwordx4 v36, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s21, 0x13940
		v_add3_u32 v37, v19, v23, s35
		buffer_load_dwordx4 v37, s[36:39], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 10
		s_mul_i32 s20, s20, s18
		s_lshl_b32 s20, s20, 8
		s_add_i32 s40, s1, s20
		v_mul_lo_u32 v23, s18, v1
		v_lshl_add_u32 v23, v23, 4, s40
		v_mul_lo_u32 v38, s18, v3
		v_lshl_add_u32 v23, v38, 3, v23
		v_mul_lo_u32 v38, s18, v7
		v_lshl_add_u32 v23, v38, 2, v23
		v_mul_lo_u32 v38, s18, v9
		v_lshl_add_u32 v23, v38, 1, v23
		v_mul_lo_u32 v39, s18, v12
		v_add3_u32 v23, v23, v39, v14
		v_lshlrev_b32_e32 v40, 2, v16
		v_lshlrev_b32_e32 v41, 1, v18
		v_add3_u32 v42, v23, v40, v41
		v_lshlrev_b32_e32 v23, 4, v1
		v_lshlrev_b32_e32 v43, 3, v3
		v_lshlrev_b32_e32 v44, 2, v7
		v_add_u32_e32 v45, 32, v12
		v_lshlrev_b32_e32 v46, 1, v9
		v_bitop3_b32 v45, v44, v45, v46 bitop3:0x96
		v_bitop3_b32 v45, v23, v43, v45 bitop3:0x96
		v_mul_lo_u32 v47, s18, v45
		v_add3_u32 v47, s40, v47, v14
		v_add3_u32 v47, v47, v40, v41
		v_add_u32_e32 v48, 64, v12
		v_bitop3_b32 v48, v44, v48, v46 bitop3:0x96
		v_bitop3_b32 v48, v23, v43, v48 bitop3:0x96
		v_mul_lo_u32 v49, s18, v48
		v_add3_u32 v50, v14, v40, v41
		v_add3_u32 v49, v49, v50, s40
		v_add_u32_e32 v51, 0x60, v12
		v_bitop3_b32 v51, v44, v51, v46 bitop3:0x96
		v_bitop3_b32 v51, v23, v43, v51 bitop3:0x96
		v_mul_lo_u32 v52, s18, v51
		v_add3_u32 v52, v52, v50, s40
		v_add_u32_e32 v53, 0x80, v12
		v_bitop3_b32 v53, v44, v53, v46 bitop3:0x96
		v_bitop3_b32 v53, v23, v43, v53 bitop3:0x96
		v_mul_lo_u32 v54, s18, v53
		v_add3_u32 v50, v54, v50, s40
		v_add_u32_e32 v54, 0xa0, v12
		v_bitop3_b32 v54, v44, v54, v46 bitop3:0x96
		v_bitop3_b32 v54, v23, v43, v54 bitop3:0x96
		v_mul_lo_u32 v55, s18, v54
		v_add3_u32 v56, v14, v40, v41
		v_add3_u32 v55, v55, v56, s40
		v_add_u32_e32 v57, 0xc0, v12
		v_bitop3_b32 v57, v44, v57, v46 bitop3:0x96
		v_bitop3_b32 v57, v23, v43, v57 bitop3:0x96
		v_mul_lo_u32 v58, s18, v57
		v_add3_u32 v58, v58, v56, s40
		v_add_u32_e32 v59, 0xe0, v12
		v_bitop3_b32 v44, v44, v59, v46 bitop3:0x96
		v_bitop3_b32 v43, v23, v43, v44 bitop3:0x96
		v_mul_lo_u32 v44, s18, v43
		v_add3_u32 v44, v44, v56, s40
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_ubyte v46, v42, s[40:43], 0 offen
		buffer_load_ubyte v56, v47, s[40:43], 0 offen
		buffer_load_ubyte v59, v49, s[40:43], 0 offen
		buffer_load_ubyte v60, v52, s[40:43], 0 offen
		buffer_load_ubyte v61, v50, s[40:43], 0 offen
		buffer_load_ubyte v62, v55, s[40:43], 0 offen
		buffer_load_ubyte v63, v58, s[40:43], 0 offen
		buffer_load_ubyte v64, v44, s[40:43], 0 offen
		s_mul_i32 s44, s0, s19
		s_lshl_b32 s44, s44, 8
		v_mul_lo_u32 v65, s19, v1
		v_lshl_add_u32 v65, v65, 4, s44
		v_mul_lo_u32 v66, s19, v3
		v_lshl_add_u32 v65, v66, 3, v65
		v_mul_lo_u32 v66, s19, v7
		v_lshl_add_u32 v65, v66, 2, v65
		v_mul_lo_u32 v66, s19, v9
		v_lshl_add_u32 v65, v66, 1, v65
		v_mul_lo_u32 v67, s19, v12
		v_add3_u32 v65, v65, v67, v14
		v_add3_u32 v65, v65, v40, v41
		v_mul_lo_u32 v68, s19, v45
		v_add3_u32 v40, v14, v40, v41
		v_add3_u32 v41, v68, v40, s44
		v_mul_lo_u32 v68, s19, v48
		v_add3_u32 v68, v68, v40, s44
		v_mul_lo_u32 v69, s19, v51
		v_add3_u32 v40, v69, v40, s44
		s_mov_b32 s48, s10
		s_mov_b32 s49, s11
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		buffer_load_ubyte v69, v65, s[48:51], 0 offen
		buffer_load_ubyte v70, v41, s[48:51], 0 offen
		buffer_load_ubyte v71, v68, s[48:51], 0 offen
		buffer_load_ubyte v72, v40, s[48:51], 0 offen
		s_lshl_b32 s45, s15, 7
		v_add3_u32 v73, s45, v21, v22
		v_add3_u32 v73, v73, v31, v32
		v_add3_u32 v73, v73, v33, v15
		s_add_i32 m0, s21, 0x18b80
		v_add3_u32 v73, v73, v17, v19
		buffer_load_dwordx4 v73, s[36:39], 0 offen lds
		s_mul_i32 s46, 0x84, s15
		v_add3_u32 v74, v21, v22, v31
		v_add3_u32 v74, v74, v32, v33
		v_add3_u32 v74, v74, v15, v17
		s_add_i32 m0, s21, 0x19c00
		v_add3_u32 v75, v19, v74, s46
		buffer_load_dwordx4 v75, s[36:39], 0 offen lds
		s_mul_i32 s47, 0x88, s15
		s_add_i32 m0, s21, 0x1ac80
		v_add3_u32 v76, v19, v74, s47
		buffer_load_dwordx4 v76, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s21, 0x1bd00
		v_add3_u32 v74, v19, v74, s15
		buffer_load_dwordx4 v74, s[36:39], 0 offen lds
		s_lshl_b32 s52, s19, 7
		s_add_i32 s53, s52, s44
		v_mul_lo_u32 v77, s19, v14
		v_lshlrev_b32_e32 v77, 2, v77
		v_lshlrev_b32_e32 v66, 6, v66
		v_add3_u32 v78, s53, v77, v66
		v_lshlrev_b32_e32 v67, 5, v67
		v_mul_lo_u32 v79, s19, v16
		v_lshlrev_b32_e32 v79, 4, v79
		v_add3_u32 v78, v78, v67, v79
		v_mul_lo_u32 v80, s19, v18
		v_lshlrev_b32_e32 v80, 3, v80
		v_add3_u32 v78, v78, v80, v6
		s_mul_i32 s53, 0x81, s19
		s_add_i32 s54, s53, s44
		v_add3_u32 v81, v77, v66, v67
		v_add3_u32 v81, v81, v79, v80
		v_add3_u32 v82, v6, v81, s54
		s_mul_i32 s54, 0x82, s19
		s_add_i32 s55, s54, s44
		v_add3_u32 v83, v6, v81, s55
		s_mul_i32 s55, 0x83, s19
		s_add_i32 s56, s55, s44
		v_add3_u32 v81, v6, v81, s56
		buffer_load_ubyte_d16 v84, v78, s[48:51], 0 offen
		buffer_load_ubyte_d16 v85, v82, s[48:51], 0 offen
		v_mov_b32_e32 v86, 0
		buffer_load_ubyte_d16_hi v86, v83, s[48:51], 0 offen
		v_mov_b32_e32 v87, 0
		buffer_load_ubyte_d16_hi v87, v81, s[48:51], 0 offen
		v_add_u32_e32 v88, 0x80, v2
		v_add_u32_e32 v88, v88, v4
		v_add3_u32 v88, v88, v8, v10
		v_add3_u32 v88, v88, v13, v15
		s_add_i32 m0, s21, 0x83e0
		v_add3_u32 v88, v88, v17, v19
		buffer_load_dwordx4 v88, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v89, s22, v2, v4
		v_add3_u32 v89, v89, v8, v10
		v_add3_u32 v89, v89, v13, v15
		s_add_i32 m0, s21, 0x9460
		v_add3_u32 v89, v89, v17, v19
		buffer_load_dwordx4 v89, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v90, s22, v2, v4
		v_add3_u32 v90, v90, v8, v10
		v_add3_u32 v90, v90, v13, v15
		s_add_i32 m0, s21, 0xa4e0
		v_add3_u32 v90, v90, v17, v19
		buffer_load_dwordx4 v90, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v91, s22, v2, v4
		v_add3_u32 v91, v91, v8, v10
		v_add3_u32 v91, v91, v13, v15
		s_add_i32 m0, s21, 0xb560
		v_add3_u32 v91, v91, v17, v19
		buffer_load_dwordx4 v91, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v92, s22, v2, v4
		v_add3_u32 v92, v92, v8, v10
		v_add3_u32 v92, v92, v13, v15
		s_add_i32 m0, s21, 0xc5e0
		v_add3_u32 v92, v92, v17, v19
		buffer_load_dwordx4 v92, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v93, s22, v2, v4
		v_add3_u32 v93, v93, v8, v10
		v_add3_u32 v93, v93, v13, v15
		s_add_i32 m0, s21, 0xd660
		v_add3_u32 v93, v93, v17, v19
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v94, s22, v2, v4
		v_add3_u32 v94, v94, v8, v10
		v_add3_u32 v94, v94, v13, v15
		s_add_i32 m0, s21, 0xe6e0
		v_add3_u32 v94, v94, v17, v19
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v4
		v_add3_u32 v2, v2, v8, v10
		v_add3_u32 v2, v2, v13, v15
		s_add_i32 m0, s21, 0xf760
		v_add3_u32 v2, v2, v17, v19
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v21
		v_add_u32_e32 v4, v4, v22
		v_add3_u32 v4, v4, v31, v32
		v_add3_u32 v4, v4, v33, v15
		s_add_i32 m0, s21, 0x149a0
		v_add3_u32 v4, v4, v17, v19
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v8, v21, v22, v31
		v_add3_u32 v8, v8, v32, v33
		v_add3_u32 v8, v8, v15, v17
		s_add_i32 m0, s21, 0x15a20
		v_add3_u32 v10, v19, v8, s14
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s21, 0x16aa0
		v_add3_u32 v13, v19, v8, s14
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s21, 0x17b20
		v_add3_u32 v8, v19, v8, s14
		s_add_i32 s14, s1, 8
		s_add_i32 s14, s14, s20
		buffer_load_dwordx4 v8, s[36:39], 0 offen lds
		v_mul_lo_u32 v95, s18, v14
		v_lshlrev_b32_e32 v95, 3, v95
		v_lshlrev_b32_e32 v38, 7, v38
		v_add3_u32 v96, s14, v95, v38
		v_lshlrev_b32_e32 v39, 6, v39
		v_mul_lo_u32 v97, s18, v16
		v_lshlrev_b32_e32 v97, 5, v97
		v_add3_u32 v96, v96, v39, v97
		v_mul_lo_u32 v98, s18, v18
		v_lshlrev_b32_e32 v98, 4, v98
		v_add3_u32 v96, v96, v98, v6
		s_add_i32 s14, s18, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v99, s14, v95, v38
		v_add3_u32 v99, v99, v39, v97
		v_add3_u32 v99, v99, v98, v6
		s_lshl_b32 s14, s18, 1
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v100, v95, v38, v39
		v_add3_u32 v100, v100, v97, v98
		v_add3_u32 v101, v6, v100, s14
		s_mul_i32 s14, 3, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v102, v6, v100, s14
		s_lshl_b32 s14, s18, 2
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v100, v6, v100, s14
		s_mul_i32 s14, 5, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v38, v95, v38, v39
		v_add3_u32 v38, v38, v97, v98
		v_add3_u32 v39, v6, v38, s14
		s_mul_i32 s14, 6, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s20
		v_add3_u32 v95, v6, v38, s14
		s_mul_i32 s14, 7, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s1, s14, s1
		s_add_i32 s1, s1, s20
		v_add3_u32 v38, v6, v38, s1
		buffer_load_ubyte_d16 v97, v96, s[40:43], 0 offen
		buffer_load_ubyte_d16 v98, v99, s[40:43], 0 offen
		v_mov_b32_e32 v103, 0
		buffer_load_ubyte_d16_hi v103, v101, s[40:43], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v102, s[40:43], 0 offen
		buffer_load_ubyte_d16 v105, v100, s[40:43], 0 offen
		buffer_load_ubyte_d16 v106, v39, s[40:43], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v95, s[40:43], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v38, s[40:43], 0 offen
		s_add_i32 s1, s44, 8
		v_add3_u32 v109, s1, v77, v66
		v_add3_u32 v109, v109, v67, v79
		v_add3_u32 v109, v109, v80, v6
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v110, v77, v66, v67
		v_add3_u32 v110, v110, v79, v80
		v_add3_u32 v111, v6, v110, s1
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v112, v6, v110, s1
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v110, v6, v110, s1
		buffer_load_ubyte_d16 v113, v109, s[48:51], 0 offen
		buffer_load_ubyte_d16 v114, v111, s[48:51], 0 offen
		v_mov_b32_e32 v115, 0
		buffer_load_ubyte_d16_hi v115, v112, s[48:51], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v110, s[48:51], 0 offen
		s_add_i32 s1, s45, 0x80
		v_add3_u32 v117, s1, v21, v22
		v_add3_u32 v117, v117, v31, v32
		v_add3_u32 v117, v117, v33, v15
		s_add_i32 m0, s21, 0x1cd60
		v_add3_u32 v117, v117, v17, v19
		buffer_load_dwordx4 v117, s[36:39], 0 offen lds
		s_add_i32 s1, s46, 0x80
		v_add3_u32 v21, v21, v22, v31
		v_add3_u32 v21, v21, v32, v33
		v_add3_u32 v21, v21, v15, v17
		s_add_i32 m0, s21, 0x1dde0
		v_add3_u32 v31, v19, v21, s1
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		s_add_i32 s1, s47, 0x80
		s_add_i32 m0, s21, 0x1ee60
		v_add3_u32 v32, v19, v21, s1
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_add_i32 s1, s15, 0x80
		s_add_i32 m0, s21, 0x1fee0
		v_add3_u32 v33, v19, v21, s1
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_add_i32 s1, s52, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v21, s1, v77, v66
		v_add3_u32 v21, v21, v67, v79
		v_add3_u32 v118, v21, v80, v6
		s_add_i32 s1, s53, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v21, v77, v66, v67
		v_add3_u32 v21, v21, v79, v80
		v_add3_u32 v66, v6, v21, s1
		s_add_i32 s1, s54, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v67, v6, v21, s1
		s_add_i32 s1, s55, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v6, v6, v21, s1
		buffer_load_ubyte_d16 v77, v118, s[48:51], 0 offen
		buffer_load_ubyte_d16 v79, v66, s[48:51], 0 offen
		v_mov_b32_e32 v80, 0
		buffer_load_ubyte_d16_hi v80, v67, s[48:51], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v6, s[48:51], 0 offen
		s_waitcnt vmcnt(52)
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s16, 0x100
		v_lshlrev_b32_e32 v21, 7, v1
		v_and_b32_e32 v22, 63, v0
		v_lshrrev_b32_e32 v120, 4, v22
		v_lshlrev_b32_e32 v120, 4, v120
		v_and_b32_e32 v22, 15, v22
		v_mov_b32_e32 v121, 0x420
		v_mul_lo_u32 v121, v121, v22
		v_add3_u32 v122, v21, v120, v121
		ds_read_b128 a[4:7], v122
		ds_read_b128 a[8:11], v122 offset:64
		ds_read_b128 a[12:15], v122 offset:256
		ds_read_b128 a[16:19], v122 offset:320
		ds_read_b128 a[20:23], v122 offset:512
		ds_read_b128 a[24:27], v122 offset:576
		ds_read_b128 a[28:31], v122 offset:768
		ds_read_b128 a[32:35], v122 offset:832
		ds_read_b128 a[36:39], v122 offset:16896
		ds_read_b128 a[40:43], v122 offset:16960
		ds_read_b128 a[44:47], v122 offset:17152
		ds_read_b128 a[48:51], v122 offset:17216
		ds_read_b128 a[52:55], v122 offset:17408
		ds_read_b128 a[56:59], v122 offset:17472
		ds_read_b128 a[60:63], v122 offset:17664
		ds_read_b128 a[64:67], v122 offset:17728
		v_add_u32_e32 v21, 0x10000, v120
		v_lshlrev_b32_e32 v22, 7, v3
		v_add3_u32 v120, v21, v22, v121
		ds_read_b128 a[68:71], v120 offset:1984
		ds_read_b128 a[72:75], v120 offset:2048
		ds_read_b128 a[76:79], v120 offset:2240
		ds_read_b128 a[80:83], v120 offset:2304
		ds_read_b128 a[84:87], v120 offset:2496
		ds_read_b128 a[88:91], v120 offset:2560
		ds_read_b128 a[92:95], v120 offset:2752
		ds_read_b128 a[96:99], v120 offset:2816
		v_add_u32_e32 v11, 0x20000, v11
		v_lshlrev_b32_e32 v21, 8, v14
		v_add_u32_e32 v22, v11, v21
		v_lshlrev_b32_e32 v121, 10, v16
		v_lshlrev_b32_e32 v123, 9, v18
		v_add3_u32 v124, v22, v121, v123
		s_waitcnt vmcnt(51)
		ds_write_b8 v124, v46 offset:3904
		v_add_u32_e32 v21, 0x20000, v21
		v_add3_u32 v21, v21, v121, v123
		v_add_u32_e32 v46, v21, v45
		s_waitcnt vmcnt(50)
		ds_write_b8 v46, v56 offset:3904
		v_add_u32_e32 v56, v21, v48
		s_waitcnt vmcnt(49)
		ds_write_b8 v56, v59 offset:3904
		v_add_u32_e32 v59, v21, v51
		s_waitcnt vmcnt(48)
		ds_write_b8 v59, v60 offset:3904
		v_add_u32_e32 v53, v21, v53
		s_waitcnt vmcnt(47)
		ds_write_b8 v53, v61 offset:3904
		v_add_u32_e32 v54, v21, v54
		s_waitcnt vmcnt(46)
		ds_write_b8 v54, v62 offset:3904
		v_add_u32_e32 v57, v21, v57
		s_waitcnt vmcnt(45)
		ds_write_b8 v57, v63 offset:3904
		v_add_u32_e32 v43, v21, v43
		s_waitcnt vmcnt(44)
		ds_write_b8 v43, v64 offset:3904
		v_lshlrev_b32_e32 v21, 7, v14
		v_add_u32_e32 v11, v11, v21
		v_lshlrev_b32_e32 v22, 9, v16
		v_lshlrev_b32_e32 v60, 8, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v11, v11, v22, v60
		s_waitcnt vmcnt(43)
		ds_write_b8 v11, v69 offset:5952
		v_add_u32_e32 v21, 0x20000, v21
		v_add3_u32 v21, v21, v22, v60
		v_add_u32_e32 v45, v21, v45
		s_waitcnt vmcnt(42)
		ds_write_b8 v45, v70 offset:5952
		v_add_u32_e32 v48, v21, v48
		s_waitcnt vmcnt(41)
		ds_write_b8 v48, v71 offset:5952
		v_add_u32_e32 v51, v21, v51
		s_waitcnt vmcnt(40)
		ds_write_b8 v51, v72 offset:5952
		v_add_u32_e32 v21, 0x20000, v23
		v_lshlrev_b32_e32 v22, 3, v14
		v_add_u32_e32 v21, v21, v22
		v_lshl_add_u32 v21, v7, 9, v21
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v23, 8, v9
		v_lshlrev_b32_e32 v60, 6, v12
		v_add3_u32 v21, v21, v23, v60
		v_lshlrev_b32_e32 v23, 5, v16
		v_lshlrev_b32_e32 v18, 10, v18
		v_accvgpr_write_b32 a1, v18
		v_accvgpr_read_b32 v18, a1
		v_add3_u32 v18, v21, v23, v18
		ds_read_b64_tr_b8 v[62:63], v18 offset:3904
		ds_read_b64_tr_b8 v[70:71], v18 offset:4032
		v_add_u32_e32 v21, 0x20000, v22
		v_lshl_add_u32 v21, v3, 4, v21
		v_lshl_add_u32 v21, v7, 8, v21
		v_lshlrev_b32_e32 v22, 7, v9
		v_add3_u32 v21, v21, v22, v60
		v_add3_u32 v60, v21, v23, v123
		ds_read_b64_tr_b8 v[126:127], v60 offset:5952
		s_mov_b32 s14, 16
		s_mov_b32 s15, s14
		v_lshlrev_b32_e32 v21, 2, v0
		v_add_u32_e32 v61, 0x20000, v21
		v_lshlrev_b32_e32 v21, 3, v0
		v_add_u32_e32 v64, 0x20000, v21
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_add_u32 s36, s8, s15
		s_addc_u32 s37, s9, 0
		s_add_u32 s40, s10, s15
		s_addc_u32 s41, s11, 0
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_mov_b32_e32 v21, 0
		v_mov_b64_e32 v[22:23], 0
		s_mov_b32 s14, s15
		v_mov_b32_e32 v128, v20
		v_mov_b32_e32 v129, v21
		v_mov_b32_e32 v130, v22
		v_mov_b32_e32 v131, v23
		v_accvgpr_write_b32 a100, v128
		v_accvgpr_write_b32 a101, v129
		v_accvgpr_write_b32 a102, v130
		v_accvgpr_write_b32 a103, v131
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
		v_accvgpr_write_b32 a104, v244
		v_accvgpr_write_b32 a105, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a106, v244
		v_accvgpr_write_b32 a107, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a108, v244
		v_accvgpr_write_b32 a109, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a110, v244
		v_accvgpr_write_b32 a111, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a112, v244
		v_accvgpr_write_b32 a113, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a114, v244
		v_accvgpr_write_b32 a115, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a116, v244
		v_accvgpr_write_b32 a117, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a118, v244
		v_accvgpr_write_b32 a119, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a120, v244
		v_accvgpr_write_b32 a121, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a122, v244
		v_accvgpr_write_b32 a123, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a124, v244
		v_accvgpr_write_b32 a125, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a126, v244
		v_accvgpr_write_b32 a127, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a128, v244
		v_accvgpr_write_b32 a129, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a130, v244
		v_accvgpr_write_b32 a131, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a132, v244
		v_accvgpr_write_b32 a133, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a134, v244
		v_accvgpr_write_b32 a135, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a136, v244
		v_accvgpr_write_b32 a137, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a138, v244
		v_accvgpr_write_b32 a139, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a140, v244
		v_accvgpr_write_b32 a141, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a142, v244
		v_accvgpr_write_b32 a143, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a144, v244
		v_accvgpr_write_b32 a145, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a146, v244
		v_accvgpr_write_b32 a147, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a148, v244
		v_accvgpr_write_b32 a149, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a150, v244
		v_accvgpr_write_b32 a151, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a152, v244
		v_accvgpr_write_b32 a153, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a154, v244
		v_accvgpr_write_b32 a155, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a156, v244
		v_accvgpr_write_b32 a157, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a158, v244
		v_accvgpr_write_b32 a159, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a160, v244
		v_accvgpr_write_b32 a161, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a162, v244
		v_accvgpr_write_b32 a163, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a170, v244
		v_accvgpr_write_b32 a171, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a172, v244
		v_accvgpr_write_b32 a173, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a174, v244
		v_accvgpr_write_b32 a175, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a176, v244
		v_accvgpr_write_b32 a177, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a178, v244
		v_accvgpr_write_b32 a179, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a180, v244
		v_accvgpr_write_b32 a181, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a182, v244
		v_accvgpr_write_b32 a183, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a184, v244
		v_accvgpr_write_b32 a185, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a186, v244
		v_accvgpr_write_b32 a187, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a188, v244
		v_accvgpr_write_b32 a189, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a190, v244
		v_accvgpr_write_b32 a191, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a192, v244
		v_accvgpr_write_b32 a193, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a194, v244
		v_accvgpr_write_b32 a195, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a196, v244
		v_accvgpr_write_b32 a197, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a198, v244
		v_accvgpr_write_b32 a199, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a200, v244
		v_accvgpr_write_b32 a201, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a202, v244
		v_accvgpr_write_b32 a203, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a204, v244
		v_accvgpr_write_b32 a205, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a206, v244
		v_accvgpr_write_b32 a207, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a208, v244
		v_accvgpr_write_b32 a209, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a210, v244
		v_accvgpr_write_b32 a211, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a212, v244
		v_accvgpr_write_b32 a213, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a214, v244
		v_accvgpr_write_b32 a215, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a216, v244
		v_accvgpr_write_b32 a217, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a218, v244
		v_accvgpr_write_b32 a219, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a220, v244
		v_accvgpr_write_b32 a221, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a222, v244
		v_accvgpr_write_b32 a223, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a224, v244
		v_accvgpr_write_b32 a225, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a226, v244
		v_accvgpr_write_b32 a227, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a228, v244
		v_accvgpr_write_b32 a229, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a230, v244
		v_accvgpr_write_b32 a231, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a232, v244
		v_accvgpr_write_b32 a233, v245
		v_mov_b64_e32 v[244:245], 0
		v_accvgpr_write_b32 a234, v244
		v_accvgpr_write_b32 a235, v245
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v126, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v126, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v126, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v126, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[72:75], a[8:11], v[20:23], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v127, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v127, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v127, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v127, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v127, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v127, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v127, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v127, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v126, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v126, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v126, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v126, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v126, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v126, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v126, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v126, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v127, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v127, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v127, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v127, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v127, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v127, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v127, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v127, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v126, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v126, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v126, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v126, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[68:71], v120 offset:35712
		ds_read_b128 a[72:75], v120 offset:35776
		ds_read_b128 a[76:79], v120 offset:35968
		ds_read_b128 a[80:83], v120 offset:36032
		ds_read_b128 a[84:87], v120 offset:36224
		ds_read_b128 a[88:91], v120 offset:36288
		ds_read_b128 a[92:95], v120 offset:36480
		ds_read_b128 a[96:99], v120 offset:36544
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v69, v85, v87
		v_lshlrev_b32_e32 v69, 8, v69
		v_or3_b32 v69, v84, v86, v69
		ds_write_b32 v61, v69 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[84:85], v60 offset:5952
		s_add_i32 m0, s21, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v84, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v84, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v84, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v84, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v84, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x6300
		s_waitcnt vmcnt(14)
		v_or_b32_e32 v69, v114, v116
		buffer_load_dwordx4 v29, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x7380
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v84, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v84, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v84, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v85, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v85, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v85, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v85, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v85, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[8:11], a[120:123], v85, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[16:19], a[136:139], v85, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v85, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v85, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v85, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v85, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v85, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v85, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[24:27], a[152:155], v85, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[32:35], a[168:171], v85, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v30, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x107c0
		v_or_b32_e32 v62, v106, v108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v85, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v84, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v84, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v84, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v84, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x11840
		v_or_b32_e32 v72, v98, v104
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x128c0
		s_add_u32 s40, s10, s14
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x13940
		s_add_u32 s36, s8, s15
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		buffer_load_ubyte v121, v42, s[36:39], 0 offen
		buffer_load_ubyte v123, v47, s[36:39], 0 offen
		buffer_load_ubyte v125, v49, s[36:39], 0 offen
		buffer_load_ubyte v126, v52, s[36:39], 0 offen
		buffer_load_ubyte v127, v50, s[36:39], 0 offen
		buffer_load_ubyte v244, v55, s[36:39], 0 offen
		buffer_load_ubyte v245, v58, s[36:39], 0 offen
		buffer_load_ubyte v246, v44, s[36:39], 0 offen
		buffer_load_ubyte v247, v65, s[40:43], 0 offen
		buffer_load_ubyte v248, v41, s[40:43], 0 offen
		buffer_load_ubyte v249, v68, s[40:43], 0 offen
		buffer_load_ubyte v250, v40, s[40:43], 0 offen
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v84, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v84, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v84, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v84, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v84, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v84, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v84, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v84, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v84, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v84, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v84, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v84, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v85, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v85, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v85, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v85, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v85, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[96:99], a[40:43], a[184:187], v85, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[96:99], a[48:51], a[200:203], v85, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v85, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v85, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v85, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v85, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v85, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v85, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[96:99], a[56:59], a[216:219], v85, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[96:99], a[64:67], a[232:235], v85, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v85, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v84, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v84, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v84, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v84, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v84, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v84, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v84, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v84, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[4:7], v122 offset:33760
		ds_read_b128 a[8:11], v122 offset:33824
		ds_read_b128 a[12:15], v122 offset:34016
		ds_read_b128 a[16:19], v122 offset:34080
		ds_read_b128 a[20:23], v122 offset:34272
		ds_read_b128 a[24:27], v122 offset:34336
		ds_read_b128 a[28:31], v122 offset:34528
		ds_read_b128 a[32:35], v122 offset:34592
		ds_read_b128 a[36:39], v122 offset:50656
		ds_read_b128 a[40:43], v122 offset:50720
		ds_read_b128 a[44:47], v122 offset:50912
		ds_read_b128 a[48:51], v122 offset:50976
		ds_read_b128 a[52:55], v122 offset:51168
		ds_read_b128 a[56:59], v122 offset:51232
		ds_read_b128 a[60:63], v122 offset:51424
		ds_read_b128 a[64:67], v122 offset:51488
		ds_read_b128 a[68:71], v120 offset:18848
		ds_read_b128 a[72:75], v120 offset:18912
		ds_read_b128 a[76:79], v120 offset:19104
		ds_read_b128 a[80:83], v120 offset:19168
		ds_read_b128 a[84:87], v120 offset:19360
		ds_read_b128 a[88:91], v120 offset:19424
		ds_read_b128 a[92:95], v120 offset:19616
		ds_read_b128 v[252:255], v120 offset:19680
		v_lshlrev_b32_e32 v63, 8, v72
		v_or3_b32 v70, v97, v103, v63
		v_lshlrev_b32_e32 v62, 8, v62
		v_or3_b32 v71, v105, v107, v62
		ds_write_b64 v64, v[70:71] offset:3904
		v_lshlrev_b32_e32 v62, 8, v69
		v_or3_b32 v62, v113, v115, v62
		s_add_i32 m0, s21, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v73, s[32:35], 0 offen lds
		ds_write_b32 v61, v62 offset:5952
		s_add_i32 m0, s21, 0x19c00
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v75, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[62:63], v18 offset:3904
		ds_read_b64_tr_b8 v[70:71], v18 offset:4032
		ds_read_b64_tr_b8 v[104:105], v60 offset:5952
		s_add_i32 m0, s21, 0x1ac80
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v104, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v76, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1bd00
		s_waitcnt vmcnt(27)
		v_or_b32_e32 v69, v79, v119
		buffer_load_dwordx4 v74, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v84, v78, s[40:43], 0 offen
		buffer_load_ubyte_d16 v85, v82, s[40:43], 0 offen
		v_mov_b32_e32 v86, 0
		buffer_load_ubyte_d16_hi v86, v83, s[40:43], 0 offen
		v_mov_b32_e32 v87, 0
		buffer_load_ubyte_d16_hi v87, v81, s[40:43], 0 offen
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v104, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v104, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v104, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[72:75], a[8:11], v[20:23], v104, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v104, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v104, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v104, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v105, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v105, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v105, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v105, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v105, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[8:11], v[132:135], v105, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[16:19], v[148:151], v105, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v105, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v105, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v105, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v105, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v105, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v105, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[24:27], v[164:167], v105, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[32:35], v[180:183], v105, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v105, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v104, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v104, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v104, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v104, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v104, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v104, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v104, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v104, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v104, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v104, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v104, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v104, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v104, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v104, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v104, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v104, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v105, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v105, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v105, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v105, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v105, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[40:43], v[196:199], v105, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[48:51], v[212:215], v105, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v105, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v105, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v105, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v105, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v105, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v105, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[56:59], v[228:231], v105, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[64:67], a[104:107], v105, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v105, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v104, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v104, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v104, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v104, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v104, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v104, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v104, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v104, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[68:71], v120 offset:52576
		ds_read_b128 a[72:75], v120 offset:52640
		ds_read_b128 a[76:79], v120 offset:52832
		ds_read_b128 a[80:83], v120 offset:52896
		ds_read_b128 a[84:87], v120 offset:53088
		ds_read_b128 a[88:91], v120 offset:53152
		ds_read_b128 a[92:95], v120 offset:53344
		ds_read_b128 a[96:99], v120 offset:53408
		v_lshlrev_b32_e32 v69, 8, v69
		v_or3_b32 v69, v77, v80, v69
		ds_write_b32 v61, v69 offset:5952
		s_add_i32 m0, s21, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v88, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[252:253], v60 offset:5952
		s_add_i32 m0, s21, 0x9460
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v252, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v89, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xa4e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v252, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v90, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v252, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v91, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v252, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v92, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v252, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v93, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v252, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v94, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v252, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v252, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v253, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v253, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v253, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v253, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v253, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[8:11], a[120:123], v253, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[16:19], a[136:139], v253, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v253, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v253, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v253, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v253, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v253, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v253, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[24:27], a[152:155], v253, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[32:35], a[168:171], v253, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v253, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v252, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v252, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x149a0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v252, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v252, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v252, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v252, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v252, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v252, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v252, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v252, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v97, v96, s[36:39], 0 offen
		buffer_load_ubyte_d16 v98, v99, s[36:39], 0 offen
		v_mov_b32_e32 v103, 0
		buffer_load_ubyte_d16_hi v103, v101, s[36:39], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v102, s[36:39], 0 offen
		buffer_load_ubyte_d16 v105, v100, s[36:39], 0 offen
		buffer_load_ubyte_d16 v106, v39, s[36:39], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v95, s[36:39], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v38, s[36:39], 0 offen
		buffer_load_ubyte_d16 v113, v109, s[40:43], 0 offen
		buffer_load_ubyte_d16 v114, v111, s[40:43], 0 offen
		v_mov_b32_e32 v115, 0
		buffer_load_ubyte_d16_hi v115, v112, s[40:43], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v110, s[40:43], 0 offen
		s_waitcnt vmcnt(44)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v252, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v252, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v252, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v252, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v252, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v252, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v253, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v253, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v253, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v253, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v253, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[96:99], a[40:43], a[184:187], v253, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[96:99], a[48:51], a[200:203], v253, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v253, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v253, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v253, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v253, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v253, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v253, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[96:99], a[56:59], a[216:219], v253, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[96:99], a[64:67], a[232:235], v253, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v253, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v252, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v252, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v252, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v252, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v252, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v252, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v252, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v252, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[4:7], v122
		ds_read_b128 a[8:11], v122 offset:64
		ds_read_b128 a[12:15], v122 offset:256
		ds_read_b128 a[16:19], v122 offset:320
		ds_read_b128 a[20:23], v122 offset:512
		ds_read_b128 a[24:27], v122 offset:576
		ds_read_b128 a[28:31], v122 offset:768
		ds_read_b128 a[32:35], v122 offset:832
		ds_read_b128 a[36:39], v122 offset:16896
		ds_read_b128 a[40:43], v122 offset:16960
		ds_read_b128 a[44:47], v122 offset:17152
		ds_read_b128 a[48:51], v122 offset:17216
		ds_read_b128 a[52:55], v122 offset:17408
		ds_read_b128 a[56:59], v122 offset:17472
		ds_read_b128 a[60:63], v122 offset:17664
		ds_read_b128 a[64:67], v122 offset:17728
		ds_read_b128 a[68:71], v120 offset:1984
		ds_read_b128 a[72:75], v120 offset:2048
		ds_read_b128 a[76:79], v120 offset:2240
		ds_read_b128 a[80:83], v120 offset:2304
		ds_read_b128 a[84:87], v120 offset:2496
		ds_read_b128 a[88:91], v120 offset:2560
		ds_read_b128 a[92:95], v120 offset:2752
		ds_read_b128 a[96:99], v120 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v124, v121 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v46, v123 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v56, v125 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v59, v126 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v53, v127 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v54, v244 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v57, v245 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v43, v246 offset:3904
		s_add_i32 m0, s21, 0x1cd60
		s_add_i32 s14, s14, 16
		buffer_load_dwordx4 v117, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1dde0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_waitcnt vmcnt(37)
		ds_write_b8 v11, v247 offset:5952
		s_waitcnt vmcnt(36)
		ds_write_b8 v45, v248 offset:5952
		s_waitcnt vmcnt(35)
		ds_write_b8 v48, v249 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v51, v250 offset:5952
		s_add_i32 m0, s21, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[62:63], v18 offset:3904
		ds_read_b64_tr_b8 v[70:71], v18 offset:4032
		ds_read_b64_tr_b8 v[126:127], v60 offset:5952
		s_add_i32 m0, s21, 0x1fee0
		s_add_i32 s15, s15, 16
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 s1, s1, 0x100
		buffer_load_ubyte_d16 v77, v118, s[40:43], 0 offen
		buffer_load_ubyte_d16 v79, v66, s[40:43], 0 offen
		v_mov_b32_e32 v80, 0
		buffer_load_ubyte_d16_hi v80, v67, s[40:43], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v6, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(4)
		s_barrier
		v_or_b32_e32 v2, v85, v87
		v_lshlrev_b32_e32 v2, 8, v2
		v_or3_b32 v2, v84, v86, v2
		v_or_b32_e32 v4, v98, v104
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v10, v97, v103, v4
		v_or_b32_e32 v4, v106, v108
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v11, v105, v107, v4
		v_or_b32_e32 v4, v114, v116
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v4, v113, v115, v4
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v5, v79, v119
		v_lshlrev_b32_e32 v5, 8, v5
		v_or3_b32 v5, v77, v80, v5
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v126, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v126, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v126, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v126, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[72:75], a[8:11], v[20:23], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v127, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v127, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v127, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v127, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v127, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v127, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v127, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v127, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v126, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v126, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v126, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v126, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v126, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v126, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v126, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v126, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v127, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v127, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v127, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v127, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v127, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v127, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v127, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v127, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v126, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v126, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v126, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v126, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v120 offset:35712
		ds_read_b128 v[28:31], v120 offset:35776
		ds_read_b128 v[32:35], v120 offset:35968
		ds_read_b128 v[36:39], v120 offset:36032
		ds_read_b128 v[40:43], v120 offset:36224
		ds_read_b128 v[44:47], v120 offset:36288
		ds_read_b128 v[48:51], v120 offset:36480
		ds_read_b128 v[52:55], v120 offset:36544
		ds_write_b32 v61, v2 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v14
		v_accvgpr_read_b32 v6, a0
		v_lshl_add_u32 v2, v6, 4, v2
		v_lshl_add_u32 v2, v12, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[56:57], v60 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[4:7], a[108:111], v56, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[4:7], a[112:115], v56, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[12:15], a[128:131], v56, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[12:15], a[124:127], v56, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[8:11], a[108:111], v56, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[8:11], a[112:115], v56, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[16:19], a[128:131], v56, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[16:19], a[124:127], v56, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[4:7], a[116:119], v57, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], a[4:7], a[120:123], v57, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], a[12:15], a[136:139], v57, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[12:15], a[132:135], v57, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[8:11], a[116:119], v57, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[8:11], a[120:123], v57, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[16:19], a[136:139], v57, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[16:19], a[132:135], v57, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[20:23], a[148:151], v57, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], a[20:23], a[152:155], v57, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], a[28:31], a[168:171], v57, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[28:31], a[164:167], v57, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[24:27], a[148:151], v57, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[24:27], a[152:155], v57, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[32:35], a[168:171], v57, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[32:35], a[164:167], v57, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[20:23], a[140:143], v56, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[20:23], a[144:147], v56, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[28:31], a[160:163], v56, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[28:31], a[156:159], v56, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[24:27], a[140:143], v56, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[24:27], a[144:147], v56, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[32:35], a[160:163], v56, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[32:35], a[156:159], v56, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], a[36:39], a[172:175], v56, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], a[36:39], a[176:179], v56, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], a[44:47], a[192:195], v56, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], a[44:47], a[188:191], v56, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], a[40:43], a[172:175], v56, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], a[40:43], a[176:179], v56, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], a[48:51], a[192:195], v56, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], a[48:51], a[188:191], v56, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], a[36:39], a[180:183], v57, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[48:51], a[36:39], a[184:187], v57, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[48:51], a[44:47], a[200:203], v57, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], a[44:47], a[196:199], v57, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[44:47], a[40:43], a[180:183], v57, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], a[40:43], a[184:187], v57, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[52:55], a[48:51], a[200:203], v57, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[44:47], a[48:51], a[196:199], v57, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], a[52:55], a[212:215], v57, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[48:51], a[52:55], a[216:219], v57, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[48:51], a[60:63], a[232:235], v57, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], a[60:63], a[228:231], v57, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[44:47], a[56:59], a[212:215], v57, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[52:55], a[56:59], a[216:219], v57, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[52:55], a[64:67], a[232:235], v57, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], a[64:67], a[228:231], v57, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], a[52:55], a[204:207], v56, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], a[52:55], a[208:211], v56, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], a[60:63], a[224:227], v56, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[24:27], a[60:63], a[220:223], v56, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[28:31], a[56:59], a[204:207], v56, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], a[56:59], a[208:211], v56, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], a[64:67], a[224:227], v56, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[28:31], a[64:67], a[220:223], v56, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v122 offset:33760
		ds_read_b128 v[28:31], v122 offset:33824
		ds_read_b128 v[32:35], v122 offset:34016
		ds_read_b128 v[36:39], v122 offset:34080
		ds_read_b128 v[40:43], v122 offset:34272
		ds_read_b128 v[44:47], v122 offset:34336
		ds_read_b128 v[48:51], v122 offset:34528
		ds_read_b128 v[52:55], v122 offset:34592
		ds_read_b128 v[56:59], v122 offset:50656
		ds_read_b128 v[68:71], v122 offset:50720
		ds_read_b128 v[72:75], v122 offset:50912
		ds_read_b128 v[76:79], v122 offset:50976
		ds_read_b128 v[80:83], v122 offset:51168
		ds_read_b128 v[84:87], v122 offset:51232
		ds_read_b128 v[88:91], v122 offset:51424
		ds_read_b128 v[92:95], v122 offset:51488
		ds_read_b128 v[96:99], v120 offset:18848
		ds_read_b128 v[100:103], v120 offset:18912
		ds_read_b128 v[104:107], v120 offset:19104
		ds_read_b128 v[108:111], v120 offset:19168
		ds_read_b128 v[112:115], v120 offset:19360
		ds_read_b128 v[116:119], v120 offset:19424
		ds_read_b128 v[124:127], v120 offset:19616
		ds_read_b128 v[244:247], v120 offset:19680
		ds_write_b64 v64, v[10:11] offset:3904
		v_lshlrev_b32_e32 v6, 12, v16
		v_accvgpr_read_b32 v8, a1
		v_add3_u32 v2, v2, v6, v8
		v_lshlrev_b32_e32 v6, 7, v12
		v_lshlrev_b32_e32 v8, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v61, v4 offset:5952
		v_lshlrev_b32_e32 v4, 2, v3
		v_add_u32_e32 v10, 16, v9
		v_lshlrev_b32_e32 v11, 1, v7
		v_xor_b32_e32 v10, v10, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[12:13], v18 offset:3904
		ds_read_b64_tr_b8 v[62:63], v18 offset:4032
		ds_read_b64_tr_b8 v[64:65], v60 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[96:99], v[24:27], v[20:23], v64, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[104:107], v[24:27], a[100:103], v64, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[104:107], v[32:35], v[140:143], v64, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[96:99], v[32:35], v[136:139], v64, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[100:103], v[28:31], v[20:23], v64, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[28:31], a[100:103], v64, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[108:111], v[36:39], v[140:143], v64, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[100:103], v[36:39], v[136:139], v64, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[112:115], v[24:27], v[128:131], v65, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[124:127], v[24:27], v[132:135], v65, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[124:127], v[32:35], v[148:151], v65, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[112:115], v[32:35], v[144:147], v65, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[116:119], v[28:31], v[128:131], v65, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[244:247], v[28:31], v[132:135], v65, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[244:247], v[36:39], v[148:151], v65, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[116:119], v[36:39], v[144:147], v65, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[112:115], v[40:43], v[160:163], v65, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[124:127], v[40:43], v[164:167], v65, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[124:127], v[48:51], v[180:183], v65, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[112:115], v[48:51], v[176:179], v65, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[116:119], v[44:47], v[160:163], v65, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[244:247], v[44:47], v[164:167], v65, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[52:55], v[180:183], v65, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[116:119], v[52:55], v[176:179], v65, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[96:99], v[40:43], v[152:155], v64, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[104:107], v[40:43], v[156:159], v64, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[104:107], v[48:51], v[172:175], v64, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[96:99], v[48:51], v[168:171], v64, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[100:103], v[44:47], v[152:155], v64, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[108:111], v[44:47], v[156:159], v64, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[108:111], v[52:55], v[172:175], v64, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[100:103], v[52:55], v[168:171], v64, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[96:99], v[56:59], v[184:187], v64, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[104:107], v[56:59], v[188:191], v64, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[104:107], v[72:75], v[204:207], v64, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[96:99], v[72:75], v[200:203], v64, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[100:103], v[68:71], v[184:187], v64, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[108:111], v[68:71], v[188:191], v64, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[108:111], v[76:79], v[204:207], v64, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[100:103], v[76:79], v[200:203], v64, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[112:115], v[56:59], v[192:195], v65, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[124:127], v[56:59], v[196:199], v65, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[124:127], v[72:75], v[212:215], v65, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[112:115], v[72:75], v[208:211], v65, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[116:119], v[68:71], v[192:195], v65, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[244:247], v[68:71], v[196:199], v65, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[76:79], v[212:215], v65, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[116:119], v[76:79], v[208:211], v65, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[112:115], v[80:83], v[224:227], v65, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[124:127], v[80:83], v[228:231], v65, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[124:127], v[88:91], a[104:107], v65, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[112:115], v[88:91], v[240:243], v65, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[116:119], v[84:87], v[224:227], v65, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[84:87], v[228:231], v65, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[244:247], v[92:95], a[104:107], v65, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[116:119], v[92:95], v[240:243], v65, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[96:99], v[80:83], v[216:219], v64, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[104:107], v[80:83], v[220:223], v64, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[104:107], v[88:91], v[236:239], v64, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[96:99], v[88:91], v[232:235], v64, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[100:103], v[84:87], v[216:219], v64, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[108:111], v[84:87], v[220:223], v64, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[108:111], v[92:95], v[236:239], v64, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[100:103], v[92:95], v[232:235], v64, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v120 offset:52576
		ds_read_b128 v[96:99], v120 offset:52640
		ds_read_b128 v[100:103], v120 offset:52832
		ds_read_b128 v[104:107], v120 offset:52896
		ds_read_b128 v[108:111], v120 offset:53088
		ds_read_b128 v[112:115], v120 offset:53152
		ds_read_b128 v[116:119], v120 offset:53344
		ds_read_b128 v[124:127], v120 offset:53408
		ds_write_b32 v61, v5 offset:5952
		v_cvt_pk_bf16_f32 v120, v20, v21
		v_cvt_pk_bf16_f32 v121, v22, v23
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v14, a101
		v_cvt_pk_bf16_f32 v20, v5, v14
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v14, a103
		v_cvt_pk_bf16_f32 v21, v5, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[244:245], v60 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v248, v128, v129
		v_cvt_pk_bf16_f32 v249, v130, v131
		v_cvt_pk_bf16_f32 v128, v132, v133
		v_cvt_pk_bf16_f32 v129, v134, v135
		v_cvt_pk_bf16_f32 v122, v136, v137
		v_cvt_pk_bf16_f32 v123, v138, v139
		v_cvt_pk_bf16_f32 v22, v140, v141
		v_cvt_pk_bf16_f32 v23, v142, v143
		v_cvt_pk_bf16_f32 v250, v144, v145
		v_cvt_pk_bf16_f32 v251, v146, v147
		v_cvt_pk_bf16_f32 v130, v148, v149
		v_cvt_pk_bf16_f32 v131, v150, v151
		v_cvt_pk_bf16_f32 v132, v152, v153
		v_cvt_pk_bf16_f32 v133, v154, v155
		v_cvt_pk_bf16_f32 v136, v156, v157
		v_cvt_pk_bf16_f32 v137, v158, v159
		v_cvt_pk_bf16_f32 v140, v160, v161
		v_cvt_pk_bf16_f32 v141, v162, v163
		v_cvt_pk_bf16_f32 v144, v164, v165
		v_cvt_pk_bf16_f32 v145, v166, v167
		v_cvt_pk_bf16_f32 v134, v168, v169
		v_cvt_pk_bf16_f32 v135, v170, v171
		v_cvt_pk_bf16_f32 v138, v172, v173
		v_cvt_pk_bf16_f32 v139, v174, v175
		v_cvt_pk_bf16_f32 v142, v176, v177
		v_cvt_pk_bf16_f32 v143, v178, v179
		v_cvt_pk_bf16_f32 v146, v180, v181
		v_cvt_pk_bf16_f32 v147, v182, v183
		v_cvt_pk_bf16_f32 v148, v184, v185
		v_cvt_pk_bf16_f32 v149, v186, v187
		v_cvt_pk_bf16_f32 v152, v188, v189
		v_cvt_pk_bf16_f32 v153, v190, v191
		v_cvt_pk_bf16_f32 v156, v192, v193
		v_cvt_pk_bf16_f32 v157, v194, v195
		v_cvt_pk_bf16_f32 v160, v196, v197
		v_cvt_pk_bf16_f32 v161, v198, v199
		v_cvt_pk_bf16_f32 v150, v200, v201
		v_cvt_pk_bf16_f32 v151, v202, v203
		v_cvt_pk_bf16_f32 v154, v204, v205
		v_cvt_pk_bf16_f32 v155, v206, v207
		v_cvt_pk_bf16_f32 v158, v208, v209
		v_cvt_pk_bf16_f32 v159, v210, v211
		v_cvt_pk_bf16_f32 v162, v212, v213
		v_cvt_pk_bf16_f32 v163, v214, v215
		v_cvt_pk_bf16_f32 v164, v216, v217
		v_cvt_pk_bf16_f32 v165, v218, v219
		v_cvt_pk_bf16_f32 v168, v220, v221
		v_cvt_pk_bf16_f32 v169, v222, v223
		v_cvt_pk_bf16_f32 v172, v224, v225
		v_cvt_pk_bf16_f32 v173, v226, v227
		v_cvt_pk_bf16_f32 v176, v228, v229
		v_cvt_pk_bf16_f32 v177, v230, v231
		v_cvt_pk_bf16_f32 v166, v232, v233
		v_cvt_pk_bf16_f32 v167, v234, v235
		v_cvt_pk_bf16_f32 v170, v236, v237
		v_cvt_pk_bf16_f32 v171, v238, v239
		v_cvt_pk_bf16_f32 v174, v240, v241
		v_cvt_pk_bf16_f32 v175, v242, v243
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v14, a105
		v_cvt_pk_bf16_f32 v178, v5, v14
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v14, a107
		v_cvt_pk_bf16_f32 v179, v5, v14
		ds_write_b128 v0, v[120:123]
		ds_write_b128 v0, v[20:23] offset:4096
		ds_write_b128 v0, v[248:251] offset:8192
		ds_write_b128 v0, v[128:131] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_bitop3_b32 v5, v8, v4, v10 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[120:123], v2 offset:256
		ds_read_b128 v[128:131], v2 offset:2048
		ds_read_b128 v[180:183], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[132:135]
		ds_write_b128 v0, v[136:139] offset:4096
		ds_write_b128 v0, v[140:143] offset:8192
		ds_write_b128 v0, v[144:147] offset:12288
		v_add_u32_e32 v10, 32, v9
		v_xor_b32_e32 v10, v10, v11
		v_bitop3_b32 v10, v8, v4, v10 bitop3:0x96
		v_add_u32_e32 v14, 48, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[132:135], v2
		ds_read_b128 v[136:139], v2 offset:256
		ds_read_b128 v[140:143], v2 offset:2048
		ds_read_b128 v[144:147], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[148:151]
		ds_write_b128 v0, v[152:155] offset:4096
		ds_write_b128 v0, v[156:159] offset:8192
		ds_write_b128 v0, v[160:163] offset:12288
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v14, v8, v4, v14 bitop3:0x96
		v_add_u32_e32 v16, 64, v9
		v_xor_b32_e32 v16, v16, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[148:151], v2
		ds_read_b128 v[152:155], v2 offset:256
		ds_read_b128 v[156:159], v2 offset:2048
		ds_read_b128 v[160:163], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[164:167]
		ds_write_b128 v0, v[168:171] offset:4096
		ds_write_b128 v0, v[172:175] offset:8192
		ds_write_b128 v0, v[176:179] offset:12288
		v_bitop3_b32 v16, v8, v4, v16 bitop3:0x96
		v_add_u32_e32 v18, 0x50, v9
		v_xor_b32_e32 v18, v18, v11
		v_bitop3_b32 v18, v8, v4, v18 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[164:167], v2
		ds_read_b128 v[168:171], v2 offset:256
		ds_read_b128 v[172:175], v2 offset:2048
		ds_read_b128 v[176:179], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v60, s0, v1, v3
		v_mul_lo_u32 v7, s17, v7
		v_lshlrev_b32_e32 v7, 2, v7
		v_mul_lo_u32 v61, s17, v9
		v_lshlrev_b32_e32 v61, 1, v61
		v_add3_u32 v60, v60, v7, v61
		v_add3_u32 v60, v60, v15, v6
		v_add3_u32 v60, v60, v17, v19
		v_mov_b64_e32 v[184:185], v[20:21]
		v_mov_b64_e32 v[186:187], v[120:121]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[184:187], v60, s[8:11], 0 offen
		v_mul_lo_u32 v5, s17, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_add_u32_e32 v20, s0, v5
		v_add3_u32 v20, v20, v15, v6
		v_add3_u32 v20, v20, v17, v19
		v_mov_b64_e32 v[184:185], v[128:129]
		v_mov_b64_e32 v[186:187], v[180:181]
		buffer_store_dwordx4 v[184:187], v20, s[8:11], 0 offen
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v20, s0, v10
		v_add3_u32 v20, v20, v15, v6
		v_add3_u32 v20, v20, v17, v19
		v_mov_b64_e32 v[184:185], v[22:23]
		v_mov_b64_e32 v[186:187], v[122:123]
		buffer_store_dwordx4 v[184:187], v20, s[8:11], 0 offen
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v20, s0, v14
		v_add3_u32 v20, v20, v15, v6
		v_add3_u32 v20, v20, v17, v19
		v_mov_b64_e32 v[120:121], v[130:131]
		v_mov_b64_e32 v[122:123], v[182:183]
		buffer_store_dwordx4 v[120:123], v20, s[8:11], 0 offen
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v20, s0, v16
		v_add3_u32 v20, v20, v15, v6
		v_add3_u32 v20, v20, v17, v19
		v_mov_b64_e32 v[120:121], v[132:133]
		v_mov_b64_e32 v[122:123], v[136:137]
		buffer_store_dwordx4 v[120:123], v20, s[8:11], 0 offen
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v20, s0, v18
		v_add3_u32 v20, v20, v15, v6
		v_add3_u32 v20, v20, v17, v19
		v_mov_b64_e32 v[120:121], v[140:141]
		v_mov_b64_e32 v[122:123], v[144:145]
		buffer_store_dwordx4 v[120:123], v20, s[8:11], 0 offen
		v_add_u32_e32 v20, 0x60, v9
		v_xor_b32_e32 v20, v20, v11
		v_bitop3_b32 v20, v8, v4, v20 bitop3:0x96
		v_mul_lo_u32 v20, s17, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v21, s0, v20
		v_add3_u32 v21, v21, v15, v6
		v_add3_u32 v21, v21, v17, v19
		v_mov_b64_e32 v[120:121], v[134:135]
		v_mov_b64_e32 v[122:123], v[138:139]
		buffer_store_dwordx4 v[120:123], v21, s[8:11], 0 offen
		v_add_u32_e32 v21, 0x70, v9
		v_xor_b32_e32 v21, v21, v11
		v_bitop3_b32 v21, v8, v4, v21 bitop3:0x96
		v_mul_lo_u32 v21, s17, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v22, s0, v21
		v_add3_u32 v22, v22, v15, v6
		v_add3_u32 v22, v22, v17, v19
		v_mov_b64_e32 v[120:121], v[142:143]
		v_mov_b64_e32 v[122:123], v[146:147]
		buffer_store_dwordx4 v[120:123], v22, s[8:11], 0 offen
		v_add_u32_e32 v22, 0x80, v9
		v_xor_b32_e32 v22, v22, v11
		v_bitop3_b32 v22, v8, v4, v22 bitop3:0x96
		v_mul_lo_u32 v22, s17, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v23, s0, v22
		v_add3_u32 v23, v23, v15, v6
		v_add3_u32 v23, v23, v17, v19
		v_mov_b64_e32 v[120:121], v[148:149]
		v_mov_b64_e32 v[122:123], v[152:153]
		buffer_store_dwordx4 v[120:123], v23, s[8:11], 0 offen
		v_add_u32_e32 v23, 0x90, v9
		v_xor_b32_e32 v23, v23, v11
		v_bitop3_b32 v23, v8, v4, v23 bitop3:0x96
		v_mul_lo_u32 v23, s17, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_add_u32_e32 v60, s0, v23
		v_add3_u32 v60, v60, v15, v6
		v_add3_u32 v60, v60, v17, v19
		v_mov_b64_e32 v[120:121], v[156:157]
		v_mov_b64_e32 v[122:123], v[160:161]
		buffer_store_dwordx4 v[120:123], v60, s[8:11], 0 offen
		v_add_u32_e32 v60, 0xa0, v9
		v_xor_b32_e32 v60, v60, v11
		v_bitop3_b32 v60, v8, v4, v60 bitop3:0x96
		v_mul_lo_u32 v60, s17, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_add_u32_e32 v120, s0, v60
		v_add3_u32 v120, v120, v15, v6
		v_add3_u32 v120, v120, v17, v19
		v_mov_b64_e32 v[128:129], v[150:151]
		v_mov_b64_e32 v[130:131], v[154:155]
		buffer_store_dwordx4 v[128:131], v120, s[8:11], 0 offen
		v_add_u32_e32 v120, 0xb0, v9
		v_xor_b32_e32 v120, v120, v11
		v_bitop3_b32 v120, v8, v4, v120 bitop3:0x96
		v_mul_lo_u32 v120, s17, v120
		v_lshlrev_b32_e32 v120, 1, v120
		v_add_u32_e32 v121, s0, v120
		v_add3_u32 v121, v121, v15, v6
		v_add3_u32 v121, v121, v17, v19
		v_mov_b64_e32 v[128:129], v[158:159]
		v_mov_b64_e32 v[130:131], v[162:163]
		buffer_store_dwordx4 v[128:131], v121, s[8:11], 0 offen
		v_add_u32_e32 v121, 0xc0, v9
		v_xor_b32_e32 v121, v121, v11
		v_bitop3_b32 v121, v8, v4, v121 bitop3:0x96
		v_mul_lo_u32 v121, s17, v121
		v_lshlrev_b32_e32 v121, 1, v121
		v_add_u32_e32 v122, s0, v121
		v_add3_u32 v122, v122, v15, v6
		v_add3_u32 v122, v122, v17, v19
		v_mov_b64_e32 v[128:129], v[164:165]
		v_mov_b64_e32 v[130:131], v[168:169]
		buffer_store_dwordx4 v[128:131], v122, s[8:11], 0 offen
		v_add_u32_e32 v122, 0xd0, v9
		v_xor_b32_e32 v122, v122, v11
		v_bitop3_b32 v122, v8, v4, v122 bitop3:0x96
		v_mul_lo_u32 v122, s17, v122
		v_lshlrev_b32_e32 v122, 1, v122
		v_add_u32_e32 v123, s0, v122
		v_add3_u32 v123, v123, v15, v6
		v_add3_u32 v123, v123, v17, v19
		v_mov_b64_e32 v[128:129], v[172:173]
		v_mov_b64_e32 v[130:131], v[176:177]
		buffer_store_dwordx4 v[128:131], v123, s[8:11], 0 offen
		v_add_u32_e32 v123, 0xe0, v9
		v_xor_b32_e32 v123, v123, v11
		v_bitop3_b32 v123, v8, v4, v123 bitop3:0x96
		v_mul_lo_u32 v123, s17, v123
		v_lshlrev_b32_e32 v123, 1, v123
		v_add_u32_e32 v128, s0, v123
		v_add3_u32 v128, v128, v15, v6
		v_add3_u32 v128, v128, v17, v19
		v_mov_b64_e32 v[132:133], v[166:167]
		v_mov_b64_e32 v[134:135], v[170:171]
		buffer_store_dwordx4 v[132:135], v128, s[8:11], 0 offen
		v_add_u32_e32 v9, 0xf0, v9
		v_xor_b32_e32 v9, v9, v11
		v_bitop3_b32 v4, v8, v4, v9 bitop3:0x96
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v8, s0, v4
		v_add3_u32 v8, v8, v15, v6
		v_add3_u32 v8, v8, v17, v19
		v_mov_b64_e32 v[128:129], v[174:175]
		v_mov_b64_e32 v[130:131], v[178:179]
		buffer_store_dwordx4 v[128:131], v8, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], v[24:27], a[108:111], v244, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[24:27], a[112:115], v244, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[32:35], a[128:131], v244, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[64:67], v[32:35], a[124:127], v244, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[28:31], a[108:111], v244, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[104:107], v[28:31], a[112:115], v244, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[36:39], a[128:131], v244, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[36:39], a[124:127], v244, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[108:111], v[24:27], a[116:119], v245, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[116:119], v[24:27], a[120:123], v245, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[116:119], v[32:35], a[136:139], v245, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[108:111], v[32:35], a[132:135], v245, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[28:31], a[116:119], v245, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[124:127], v[28:31], a[120:123], v245, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[124:127], v[36:39], a[136:139], v245, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[36:39], a[132:135], v245, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[40:43], a[148:151], v245, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[116:119], v[40:43], a[152:155], v245, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[116:119], v[48:51], a[168:171], v245, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[48:51], a[164:167], v245, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[44:47], a[148:151], v245, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[124:127], v[44:47], a[152:155], v245, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[124:127], v[52:55], a[168:171], v245, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[52:55], a[164:167], v245, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[64:67], v[40:43], a[140:143], v244, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[40:43], a[144:147], v244, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[48:51], a[160:163], v244, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[64:67], v[48:51], a[156:159], v244, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[44:47], a[140:143], v244, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[44:47], a[144:147], v244, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[52:55], a[160:163], v244, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[52:55], a[156:159], v244, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[64:67], v[56:59], a[172:175], v244, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[56:59], a[176:179], v244, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[72:75], a[192:195], v244, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[64:67], v[72:75], a[188:191], v244, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[68:71], a[172:175], v244, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[68:71], a[176:179], v244, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[76:79], a[192:195], v244, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[76:79], a[188:191], v244, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[56:59], a[180:183], v245, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[116:119], v[56:59], a[184:187], v245, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[116:119], v[72:75], a[200:203], v245, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[108:111], v[72:75], a[196:199], v245, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[68:71], a[180:183], v245, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[124:127], v[68:71], a[184:187], v245, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[76:79], a[200:203], v245, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[76:79], a[196:199], v245, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[108:111], v[80:83], a[212:215], v245, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[116:119], v[80:83], a[216:219], v245, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[116:119], v[88:91], a[232:235], v245, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[108:111], v[88:91], a[228:231], v245, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[84:87], a[212:215], v245, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[84:87], a[216:219], v245, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[92:95], a[232:235], v245, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[92:95], a[228:231], v245, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[64:67], v[80:83], a[204:207], v244, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[80:83], a[208:211], v244, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[100:103], v[88:91], a[224:227], v244, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[64:67], v[88:91], a[220:223], v244, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[84:87], a[204:207], v244, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[84:87], a[208:211], v244, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[104:107], v[92:95], a[224:227], v244, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[96:99], v[92:95], a[220:223], v244, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v8, a108
		v_accvgpr_read_b32 v9, a109
		v_cvt_pk_bf16_f32 v24, v8, v9
		v_accvgpr_read_b32 v8, a110
		v_accvgpr_read_b32 v9, a111
		v_cvt_pk_bf16_f32 v25, v8, v9
		v_accvgpr_read_b32 v8, a112
		v_accvgpr_read_b32 v9, a113
		v_cvt_pk_bf16_f32 v28, v8, v9
		v_accvgpr_read_b32 v8, a114
		v_accvgpr_read_b32 v9, a115
		v_cvt_pk_bf16_f32 v29, v8, v9
		v_accvgpr_read_b32 v8, a116
		v_accvgpr_read_b32 v9, a117
		v_cvt_pk_bf16_f32 v32, v8, v9
		v_accvgpr_read_b32 v8, a118
		v_accvgpr_read_b32 v9, a119
		v_cvt_pk_bf16_f32 v33, v8, v9
		v_accvgpr_read_b32 v8, a120
		v_accvgpr_read_b32 v9, a121
		v_cvt_pk_bf16_f32 v36, v8, v9
		v_accvgpr_read_b32 v8, a122
		v_accvgpr_read_b32 v9, a123
		v_cvt_pk_bf16_f32 v37, v8, v9
		v_accvgpr_read_b32 v8, a124
		v_accvgpr_read_b32 v9, a125
		v_cvt_pk_bf16_f32 v26, v8, v9
		v_accvgpr_read_b32 v8, a126
		v_accvgpr_read_b32 v9, a127
		v_cvt_pk_bf16_f32 v27, v8, v9
		ds_write_b128 v0, v[24:27]
		v_accvgpr_read_b32 v8, a128
		v_accvgpr_read_b32 v9, a129
		v_cvt_pk_bf16_f32 v30, v8, v9
		v_accvgpr_read_b32 v8, a130
		v_accvgpr_read_b32 v9, a131
		v_cvt_pk_bf16_f32 v31, v8, v9
		ds_write_b128 v0, v[28:31] offset:4096
		v_accvgpr_read_b32 v8, a132
		v_accvgpr_read_b32 v9, a133
		v_cvt_pk_bf16_f32 v34, v8, v9
		v_accvgpr_read_b32 v8, a134
		v_accvgpr_read_b32 v9, a135
		v_cvt_pk_bf16_f32 v35, v8, v9
		ds_write_b128 v0, v[32:35] offset:8192
		v_accvgpr_read_b32 v8, a136
		v_accvgpr_read_b32 v9, a137
		v_cvt_pk_bf16_f32 v38, v8, v9
		v_accvgpr_read_b32 v8, a138
		v_accvgpr_read_b32 v9, a139
		v_cvt_pk_bf16_f32 v39, v8, v9
		ds_write_b128 v0, v[36:39] offset:12288
		v_accvgpr_read_b32 v8, a140
		v_accvgpr_read_b32 v9, a141
		v_cvt_pk_bf16_f32 v24, v8, v9
		v_accvgpr_read_b32 v8, a142
		v_accvgpr_read_b32 v9, a143
		v_cvt_pk_bf16_f32 v25, v8, v9
		v_accvgpr_read_b32 v8, a144
		v_accvgpr_read_b32 v9, a145
		v_cvt_pk_bf16_f32 v28, v8, v9
		v_accvgpr_read_b32 v8, a146
		v_accvgpr_read_b32 v9, a147
		v_cvt_pk_bf16_f32 v29, v8, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v8, a148
		v_accvgpr_read_b32 v9, a149
		v_cvt_pk_bf16_f32 v32, v8, v9
		v_accvgpr_read_b32 v8, a150
		v_accvgpr_read_b32 v9, a151
		v_cvt_pk_bf16_f32 v33, v8, v9
		v_accvgpr_read_b32 v8, a152
		v_accvgpr_read_b32 v9, a153
		v_cvt_pk_bf16_f32 v36, v8, v9
		v_accvgpr_read_b32 v8, a154
		v_accvgpr_read_b32 v9, a155
		v_cvt_pk_bf16_f32 v37, v8, v9
		v_accvgpr_read_b32 v8, a156
		v_accvgpr_read_b32 v9, a157
		v_cvt_pk_bf16_f32 v26, v8, v9
		v_accvgpr_read_b32 v8, a158
		v_accvgpr_read_b32 v9, a159
		v_cvt_pk_bf16_f32 v27, v8, v9
		v_accvgpr_read_b32 v8, a160
		v_accvgpr_read_b32 v9, a161
		v_cvt_pk_bf16_f32 v30, v8, v9
		v_accvgpr_read_b32 v8, a162
		v_accvgpr_read_b32 v9, a163
		v_cvt_pk_bf16_f32 v31, v8, v9
		v_accvgpr_read_b32 v8, a164
		v_accvgpr_read_b32 v9, a165
		v_cvt_pk_bf16_f32 v34, v8, v9
		v_accvgpr_read_b32 v8, a166
		v_accvgpr_read_b32 v9, a167
		v_cvt_pk_bf16_f32 v35, v8, v9
		v_accvgpr_read_b32 v8, a168
		v_accvgpr_read_b32 v9, a169
		v_cvt_pk_bf16_f32 v38, v8, v9
		v_accvgpr_read_b32 v8, a170
		v_accvgpr_read_b32 v9, a171
		v_cvt_pk_bf16_f32 v39, v8, v9
		v_accvgpr_read_b32 v8, a172
		v_accvgpr_read_b32 v9, a173
		v_cvt_pk_bf16_f32 v40, v8, v9
		v_accvgpr_read_b32 v8, a174
		v_accvgpr_read_b32 v9, a175
		v_cvt_pk_bf16_f32 v41, v8, v9
		v_accvgpr_read_b32 v8, a176
		v_accvgpr_read_b32 v9, a177
		v_cvt_pk_bf16_f32 v44, v8, v9
		v_accvgpr_read_b32 v8, a178
		v_accvgpr_read_b32 v9, a179
		v_cvt_pk_bf16_f32 v45, v8, v9
		v_accvgpr_read_b32 v8, a180
		v_accvgpr_read_b32 v9, a181
		v_cvt_pk_bf16_f32 v48, v8, v9
		v_accvgpr_read_b32 v8, a182
		v_accvgpr_read_b32 v9, a183
		v_cvt_pk_bf16_f32 v49, v8, v9
		v_accvgpr_read_b32 v8, a184
		v_accvgpr_read_b32 v9, a185
		v_cvt_pk_bf16_f32 v52, v8, v9
		v_accvgpr_read_b32 v8, a186
		v_accvgpr_read_b32 v9, a187
		v_cvt_pk_bf16_f32 v53, v8, v9
		v_accvgpr_read_b32 v8, a188
		v_accvgpr_read_b32 v9, a189
		v_cvt_pk_bf16_f32 v42, v8, v9
		v_accvgpr_read_b32 v8, a190
		v_accvgpr_read_b32 v9, a191
		v_cvt_pk_bf16_f32 v43, v8, v9
		v_accvgpr_read_b32 v8, a192
		v_accvgpr_read_b32 v9, a193
		v_cvt_pk_bf16_f32 v46, v8, v9
		v_accvgpr_read_b32 v8, a194
		v_accvgpr_read_b32 v9, a195
		v_cvt_pk_bf16_f32 v47, v8, v9
		v_accvgpr_read_b32 v8, a196
		v_accvgpr_read_b32 v9, a197
		v_cvt_pk_bf16_f32 v50, v8, v9
		v_accvgpr_read_b32 v8, a198
		v_accvgpr_read_b32 v9, a199
		v_cvt_pk_bf16_f32 v51, v8, v9
		v_accvgpr_read_b32 v8, a200
		v_accvgpr_read_b32 v9, a201
		v_cvt_pk_bf16_f32 v54, v8, v9
		v_accvgpr_read_b32 v8, a202
		v_accvgpr_read_b32 v9, a203
		v_cvt_pk_bf16_f32 v55, v8, v9
		v_accvgpr_read_b32 v8, a204
		v_accvgpr_read_b32 v9, a205
		v_cvt_pk_bf16_f32 v56, v8, v9
		v_accvgpr_read_b32 v8, a206
		v_accvgpr_read_b32 v9, a207
		v_cvt_pk_bf16_f32 v57, v8, v9
		v_accvgpr_read_b32 v8, a208
		v_accvgpr_read_b32 v9, a209
		v_cvt_pk_bf16_f32 v64, v8, v9
		v_accvgpr_read_b32 v8, a210
		v_accvgpr_read_b32 v9, a211
		v_cvt_pk_bf16_f32 v65, v8, v9
		v_accvgpr_read_b32 v8, a212
		v_accvgpr_read_b32 v9, a213
		v_cvt_pk_bf16_f32 v68, v8, v9
		v_accvgpr_read_b32 v8, a214
		v_accvgpr_read_b32 v9, a215
		v_cvt_pk_bf16_f32 v69, v8, v9
		v_accvgpr_read_b32 v8, a216
		v_accvgpr_read_b32 v9, a217
		v_cvt_pk_bf16_f32 v72, v8, v9
		v_accvgpr_read_b32 v8, a218
		v_accvgpr_read_b32 v9, a219
		v_cvt_pk_bf16_f32 v73, v8, v9
		v_accvgpr_read_b32 v8, a220
		v_accvgpr_read_b32 v9, a221
		v_cvt_pk_bf16_f32 v58, v8, v9
		v_accvgpr_read_b32 v8, a222
		v_accvgpr_read_b32 v9, a223
		v_cvt_pk_bf16_f32 v59, v8, v9
		v_accvgpr_read_b32 v8, a224
		v_accvgpr_read_b32 v9, a225
		v_cvt_pk_bf16_f32 v66, v8, v9
		v_accvgpr_read_b32 v8, a226
		v_accvgpr_read_b32 v9, a227
		v_cvt_pk_bf16_f32 v67, v8, v9
		v_accvgpr_read_b32 v8, a228
		v_accvgpr_read_b32 v9, a229
		v_cvt_pk_bf16_f32 v70, v8, v9
		v_accvgpr_read_b32 v8, a230
		v_accvgpr_read_b32 v9, a231
		v_cvt_pk_bf16_f32 v71, v8, v9
		v_accvgpr_read_b32 v8, a232
		v_accvgpr_read_b32 v9, a233
		v_cvt_pk_bf16_f32 v74, v8, v9
		v_accvgpr_read_b32 v8, a234
		v_accvgpr_read_b32 v9, a235
		v_cvt_pk_bf16_f32 v75, v8, v9
		ds_read_b128 v[76:79], v2
		ds_read_b128 v[80:83], v2 offset:256
		ds_read_b128 v[84:87], v2 offset:2048
		ds_read_b128 v[88:91], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[24:27]
		ds_write_b128 v0, v[28:31] offset:4096
		ds_write_b128 v0, v[32:35] offset:8192
		ds_write_b128 v0, v[36:39] offset:12288
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v7, v61
		v_add3_u32 v1, v1, v15, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[40:43]
		ds_write_b128 v0, v[44:47] offset:4096
		ds_write_b128 v0, v[48:51] offset:8192
		ds_write_b128 v0, v[52:55] offset:12288
		v_add3_u32 v1, v1, v17, v19
		v_mov_b64_e32 v[40:41], v[76:77]
		v_mov_b64_e32 v[42:43], v[80:81]
		buffer_store_dwordx4 v[40:43], v1, s[8:11], 0 offen
		v_add3_u32 v1, v15, v6, v17
		v_add_u32_e32 v1, v1, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v2
		ds_read_b128 v[44:47], v2 offset:256
		ds_read_b128 v[48:51], v2 offset:2048
		ds_read_b128 v[52:55], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[56:59]
		ds_write_b128 v0, v[64:67] offset:4096
		ds_write_b128 v0, v[68:71] offset:8192
		ds_write_b128 v0, v[72:75] offset:12288
		v_add3_u32 v0, v5, v1, s0
		v_mov_b64_e32 v[56:57], v[84:85]
		v_mov_b64_e32 v[58:59], v[88:89]
		buffer_store_dwordx4 v[56:59], v0, s[8:11], 0 offen
		v_add3_u32 v0, v10, v1, s0
		v_mov_b64_e32 v[8:9], v[78:79]
		v_mov_b64_e32 v[10:11], v[82:83]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[56:59], v2 offset:256
		ds_read_b128 v[64:67], v2 offset:2048
		ds_read_b128 v[68:71], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v0, v14, v1, s0
		v_mov_b64_e32 v[72:73], v[86:87]
		v_mov_b64_e32 v[74:75], v[90:91]
		buffer_store_dwordx4 v[72:75], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v6, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v16, v0, s0
		v_mov_b64_e32 v[72:73], v[24:25]
		v_mov_b64_e32 v[74:75], v[28:29]
		buffer_store_dwordx4 v[72:75], v1, s[8:11], 0 offen
		v_add3_u32 v1, v18, v0, s0
		s_nop 0
		v_mov_b64_e32 v[72:73], v[32:33]
		v_mov_b64_e32 v[74:75], v[36:37]
		buffer_store_dwordx4 v[72:75], v1, s[8:11], 0 offen
		v_add3_u32 v0, v20, v0, s0
		s_nop 0
		v_mov_b64_e32 v[72:73], v[26:27]
		v_mov_b64_e32 v[74:75], v[30:31]
		buffer_store_dwordx4 v[72:75], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v6, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v21, v0, s0
		v_mov_b64_e32 v[24:25], v[34:35]
		v_mov_b64_e32 v[26:27], v[38:39]
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v1, v22, v0, s0
		s_nop 0
		v_mov_b64_e32 v[24:25], v[40:41]
		v_mov_b64_e32 v[26:27], v[44:45]
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v0, v23, v0, s0
		v_mov_b64_e32 v[20:21], v[48:49]
		v_mov_b64_e32 v[22:23], v[52:53]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v6, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v60, v0, s0
		v_mov_b64_e32 v[20:21], v[42:43]
		v_mov_b64_e32 v[22:23], v[46:47]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, v120, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[50:51]
		v_mov_b64_e32 v[22:23], v[54:55]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v0, v121, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[8:9]
		v_mov_b64_e32 v[22:23], v[56:57]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v6, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v122, v0, s0
		v_mov_b64_e32 v[12:13], v[64:65]
		v_mov_b64_e32 v[14:15], v[68:69]
		buffer_store_dwordx4 v[12:15], v1, s[8:11], 0 offen
		v_add3_u32 v1, v123, v0, s0
		s_nop 0
		v_mov_b64_e32 v[12:13], v[10:11]
		v_mov_b64_e32 v[14:15], v[58:59]
		buffer_store_dwordx4 v[12:15], v1, s[8:11], 0 offen
		v_add3_u32 v0, v4, v0, s0
		v_mov_b64_e32 v[4:5], v[66:67]
		v_mov_b64_e32 v[6:7], v[70:71]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
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
		.amdhsa_next_free_vgpr 492
		.amdhsa_next_free_sgpr 57
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
	.set .L_a4w4_kernel.num_agpr, 236
	.set .L_a4w4_kernel.numbered_sgpr, 57
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
    .sgpr_count:     57
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     492
    .agpr_count:     236
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 100
    wave.regalloc.agpr.dwords: 390
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
