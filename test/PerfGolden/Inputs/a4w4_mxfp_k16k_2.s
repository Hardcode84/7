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
		s_add_i32 s21, s16, s20
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s21, s16
		s_add_i32 s21, s16, s20
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s21, s16
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
		s_add_i32 s20, s21, 1
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s0, s20, s21
		s_mul_i32 s12, s12, 0x100
		s_mul_i32 s13, s12, s14
		s_mul_i32 s20, s0, 0x100
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
		v_mul_lo_u32 v5, s14, v3
		v_add_u32_e32 v6, v2, v5
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v8, 1, v7
		v_mul_lo_u32 v9, s14, v8
		v_lshlrev_b32_e32 v9, 6, v9
		v_lshrrev_b32_e32 v10, 4, v0
		v_accvgpr_write_b32 a0, v10
		v_accvgpr_read_b32 v10, a0
		v_and_b32_e32 v10, 1, v10
		v_mul_lo_u32 v11, s14, v10
		v_lshlrev_b32_e32 v11, 5, v11
		v_add3_u32 v6, v6, v9, v11
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v13, 1, v12
		v_mul_lo_u32 v14, s14, v13
		v_lshlrev_b32_e32 v14, 4, v14
		v_and_b32_e32 v15, 1, v0
		v_lshlrev_b32_e32 v16, 4, v15
		v_add3_u32 v6, v6, v14, v16
		v_lshrrev_b32_e32 v17, 2, v0
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 6, v17
		v_lshrrev_b32_e32 v19, 1, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 5, v19
		v_add3_u32 v21, v6, v18, v20
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_mul_i32 s20, s20, s15
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v6, s22, v2, v5
		v_add3_u32 v6, v6, v9, v11
		v_add3_u32 v6, v6, v14, v16
		s_add_i32 m0, s21, 0x1080
		v_add3_u32 v22, v6, v18, v20
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v6, v2, v5, v9
		v_add3_u32 v6, v6, v11, v14
		v_add3_u32 v6, v6, v16, v18
		s_add_i32 m0, s21, 0x2100
		v_add3_u32 v23, v20, v6, s28
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s21, 0x3180
		v_add3_u32 v24, v20, v6, s29
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s21, 0x4200
		v_add3_u32 v25, v20, v6, s30
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v6, v2, v5, v9
		v_add3_u32 v6, v6, v11, v14
		v_add3_u32 v6, v6, v16, v18
		s_add_i32 m0, s21, 0x5280
		v_add3_u32 v26, v20, v6, s31
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s21, 0x6300
		v_add3_u32 v27, v20, v6, s32
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s21, 0x7380
		v_add3_u32 v28, v20, v6, s14
		s_add_u32 s36, s4, s20
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v6, s15, v1
		v_lshlrev_b32_e32 v6, 1, v6
		v_mul_lo_u32 v29, s15, v3
		v_add_u32_e32 v30, v6, v29
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		v_mul_lo_u32 v31, s15, v8
		v_lshlrev_b32_e32 v31, 6, v31
		v_mul_lo_u32 v32, s15, v10
		v_lshlrev_b32_e32 v32, 5, v32
		v_add3_u32 v30, v30, v31, v32
		v_mul_lo_u32 v33, s15, v13
		v_lshlrev_b32_e32 v33, 4, v33
		v_add3_u32 v30, v30, v33, v16
		s_add_i32 m0, s21, 0x107c0
		v_add3_u32 v30, v30, v18, v20
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v30, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v34, v6, v29, v31
		v_add3_u32 v34, v34, v32, v33
		v_add3_u32 v34, v34, v16, v18
		s_add_i32 m0, s21, 0x11840
		v_add3_u32 v35, v20, v34, s33
		buffer_load_dwordx4 v35, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s21, 0x128c0
		v_add3_u32 v36, v20, v34, s34
		buffer_load_dwordx4 v36, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s21, 0x13940
		v_add3_u32 v34, v20, v34, s35
		buffer_load_dwordx4 v34, s[36:39], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 10
		s_mul_i32 s16, s16, s18
		s_lshl_b32 s16, s16, 8
		s_add_i32 s40, s1, s16
		v_mul_lo_u32 v37, s18, v1
		v_lshl_add_u32 v37, v37, 4, s40
		v_mul_lo_u32 v38, s18, v3
		v_lshl_add_u32 v37, v38, 3, v37
		v_mul_lo_u32 v38, s18, v8
		v_lshl_add_u32 v37, v38, 2, v37
		v_mul_lo_u32 v38, s18, v10
		v_lshl_add_u32 v37, v38, 1, v37
		v_mul_lo_u32 v39, s18, v13
		v_add3_u32 v37, v37, v39, v15
		v_lshlrev_b32_e32 v40, 2, v17
		v_lshlrev_b32_e32 v41, 1, v19
		v_add3_u32 v37, v37, v40, v41
		v_lshlrev_b32_e32 v42, 4, v1
		v_lshlrev_b32_e32 v43, 3, v3
		v_lshlrev_b32_e32 v44, 2, v8
		v_add_u32_e32 v45, 32, v13
		v_lshlrev_b32_e32 v46, 1, v10
		v_bitop3_b32 v45, v44, v45, v46 bitop3:0x96
		v_bitop3_b32 v45, v42, v43, v45 bitop3:0x96
		v_mul_lo_u32 v47, s18, v45
		v_add3_u32 v47, s40, v47, v15
		v_add3_u32 v47, v47, v40, v41
		v_add_u32_e32 v48, 64, v13
		v_bitop3_b32 v48, v44, v48, v46 bitop3:0x96
		v_bitop3_b32 v48, v42, v43, v48 bitop3:0x96
		v_mul_lo_u32 v49, s18, v48
		v_add3_u32 v50, v15, v40, v41
		v_add3_u32 v49, v49, v50, s40
		v_add_u32_e32 v51, 0x60, v13
		v_bitop3_b32 v51, v44, v51, v46 bitop3:0x96
		v_bitop3_b32 v51, v42, v43, v51 bitop3:0x96
		v_mul_lo_u32 v52, s18, v51
		v_add3_u32 v52, v52, v50, s40
		v_add_u32_e32 v53, 0x80, v13
		v_bitop3_b32 v53, v44, v53, v46 bitop3:0x96
		v_bitop3_b32 v53, v42, v43, v53 bitop3:0x96
		v_mul_lo_u32 v54, s18, v53
		v_add3_u32 v50, v54, v50, s40
		v_add_u32_e32 v54, 0xa0, v13
		v_bitop3_b32 v54, v44, v54, v46 bitop3:0x96
		v_bitop3_b32 v54, v42, v43, v54 bitop3:0x96
		v_mul_lo_u32 v55, s18, v54
		v_add3_u32 v56, v15, v40, v41
		v_add3_u32 v55, v55, v56, s40
		v_add_u32_e32 v57, 0xc0, v13
		v_bitop3_b32 v57, v44, v57, v46 bitop3:0x96
		v_bitop3_b32 v57, v42, v43, v57 bitop3:0x96
		v_mul_lo_u32 v58, s18, v57
		v_add3_u32 v58, v58, v56, s40
		v_add_u32_e32 v59, 0xe0, v13
		v_bitop3_b32 v44, v44, v59, v46 bitop3:0x96
		v_bitop3_b32 v43, v42, v43, v44 bitop3:0x96
		v_mul_lo_u32 v44, s18, v43
		v_add3_u32 v44, v44, v56, s40
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_ubyte v46, v37, s[40:43], 0 offen
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
		v_mul_lo_u32 v66, s19, v8
		v_lshl_add_u32 v65, v66, 2, v65
		v_mul_lo_u32 v66, s19, v10
		v_lshl_add_u32 v65, v66, 1, v65
		v_mul_lo_u32 v67, s19, v13
		v_add3_u32 v65, v65, v67, v15
		v_add3_u32 v65, v65, v40, v41
		v_mul_lo_u32 v68, s19, v45
		v_add3_u32 v40, v15, v40, v41
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
		v_add3_u32 v73, s45, v6, v29
		v_add3_u32 v73, v73, v31, v32
		v_add3_u32 v73, v73, v33, v16
		s_add_i32 m0, s21, 0x18b80
		v_add3_u32 v73, v73, v18, v20
		buffer_load_dwordx4 v73, s[36:39], 0 offen lds
		s_mul_i32 s46, 0x84, s15
		v_add3_u32 v74, v6, v29, v31
		v_add3_u32 v74, v74, v32, v33
		v_add3_u32 v74, v74, v16, v18
		s_add_i32 m0, s21, 0x19c00
		v_add3_u32 v75, v20, v74, s46
		buffer_load_dwordx4 v75, s[36:39], 0 offen lds
		s_mul_i32 s47, 0x88, s15
		s_add_i32 m0, s21, 0x1ac80
		v_add3_u32 v76, v20, v74, s47
		buffer_load_dwordx4 v76, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s21, 0x1bd00
		v_add3_u32 v74, v20, v74, s15
		buffer_load_dwordx4 v74, s[36:39], 0 offen lds
		s_lshl_b32 s52, s19, 7
		s_add_i32 s53, s52, s44
		v_mul_lo_u32 v77, s19, v15
		v_lshlrev_b32_e32 v77, 2, v77
		v_lshlrev_b32_e32 v66, 6, v66
		v_add3_u32 v78, s53, v77, v66
		v_lshlrev_b32_e32 v67, 5, v67
		v_mul_lo_u32 v79, s19, v17
		v_lshlrev_b32_e32 v79, 4, v79
		v_add3_u32 v78, v78, v67, v79
		v_mul_lo_u32 v80, s19, v19
		v_lshlrev_b32_e32 v80, 3, v80
		v_add3_u32 v78, v78, v80, v7
		s_mul_i32 s53, 0x81, s19
		s_add_i32 s54, s53, s44
		v_add3_u32 v81, v77, v66, v67
		v_add3_u32 v81, v81, v79, v80
		v_add3_u32 v82, v7, v81, s54
		s_mul_i32 s54, 0x82, s19
		s_add_i32 s55, s54, s44
		v_add3_u32 v83, v7, v81, s55
		s_mul_i32 s55, 0x83, s19
		s_add_i32 s56, s55, s44
		v_add3_u32 v81, v7, v81, s56
		buffer_load_ubyte_d16 v84, v78, s[48:51], 0 offen
		buffer_load_ubyte_d16 v85, v82, s[48:51], 0 offen
		v_mov_b32_e32 v86, 0
		buffer_load_ubyte_d16_hi v86, v83, s[48:51], 0 offen
		v_mov_b32_e32 v87, 0
		buffer_load_ubyte_d16_hi v87, v81, s[48:51], 0 offen
		v_add_u32_e32 v88, 0x80, v2
		v_add_u32_e32 v88, v88, v5
		v_add3_u32 v88, v88, v9, v11
		v_add3_u32 v88, v88, v14, v16
		s_add_i32 m0, s21, 0x83e0
		v_add3_u32 v88, v88, v18, v20
		buffer_load_dwordx4 v88, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v89, s22, v2, v5
		v_add3_u32 v89, v89, v9, v11
		v_add3_u32 v89, v89, v14, v16
		s_add_i32 m0, s21, 0x9460
		v_add3_u32 v89, v89, v18, v20
		buffer_load_dwordx4 v89, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v90, s22, v2, v5
		v_add3_u32 v90, v90, v9, v11
		v_add3_u32 v90, v90, v14, v16
		s_add_i32 m0, s21, 0xa4e0
		v_add3_u32 v90, v90, v18, v20
		buffer_load_dwordx4 v90, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v91, s22, v2, v5
		v_add3_u32 v91, v91, v9, v11
		v_add3_u32 v91, v91, v14, v16
		s_add_i32 m0, s21, 0xb560
		v_add3_u32 v91, v91, v18, v20
		buffer_load_dwordx4 v91, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v92, s22, v2, v5
		v_add3_u32 v92, v92, v9, v11
		v_add3_u32 v92, v92, v14, v16
		s_add_i32 m0, s21, 0xc5e0
		v_add3_u32 v92, v92, v18, v20
		buffer_load_dwordx4 v92, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v93, s22, v2, v5
		v_add3_u32 v93, v93, v9, v11
		v_add3_u32 v93, v93, v14, v16
		s_add_i32 m0, s21, 0xd660
		v_add3_u32 v93, v93, v18, v20
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v94, s22, v2, v5
		v_add3_u32 v94, v94, v9, v11
		v_add3_u32 v94, v94, v14, v16
		s_add_i32 m0, s21, 0xe6e0
		v_add3_u32 v94, v94, v18, v20
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v5
		v_add3_u32 v2, v2, v9, v11
		v_add3_u32 v2, v2, v14, v16
		s_add_i32 m0, s21, 0xf760
		v_add3_u32 v2, v2, v18, v20
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v5, 0x80, v6
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v5, v5, v31, v32
		v_add3_u32 v5, v5, v33, v16
		s_add_i32 m0, s21, 0x149a0
		v_add3_u32 v9, v5, v18, v20
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v5, v6, v29, v31
		v_add3_u32 v5, v5, v32, v33
		v_add3_u32 v5, v5, v16, v18
		s_add_i32 m0, s21, 0x15a20
		v_add3_u32 v11, v20, v5, s14
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s21, 0x16aa0
		v_add3_u32 v14, v20, v5, s14
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s21, 0x17b20
		v_add3_u32 v95, v20, v5, s14
		s_add_i32 s14, s1, 8
		s_add_i32 s14, s14, s16
		buffer_load_dwordx4 v95, s[36:39], 0 offen lds
		v_mul_lo_u32 v5, s18, v15
		v_lshlrev_b32_e32 v5, 3, v5
		v_lshlrev_b32_e32 v38, 7, v38
		v_add3_u32 v96, s14, v5, v38
		v_lshlrev_b32_e32 v39, 6, v39
		v_mul_lo_u32 v97, s18, v17
		v_lshlrev_b32_e32 v97, 5, v97
		v_add3_u32 v96, v96, v39, v97
		v_mul_lo_u32 v98, s18, v19
		v_lshlrev_b32_e32 v98, 4, v98
		v_add3_u32 v96, v96, v98, v7
		s_add_i32 s14, s18, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v99, s14, v5, v38
		v_add3_u32 v99, v99, v39, v97
		v_add3_u32 v99, v99, v98, v7
		s_lshl_b32 s14, s18, 1
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v100, v5, v38, v39
		v_add3_u32 v100, v100, v97, v98
		v_add3_u32 v101, v7, v100, s14
		s_mul_i32 s14, 3, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v102, v7, v100, s14
		s_lshl_b32 s14, s18, 2
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v100, v7, v100, s14
		s_mul_i32 s14, 5, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v5, v5, v38, v39
		v_add3_u32 v5, v5, v97, v98
		v_add3_u32 v38, v7, v5, s14
		s_mul_i32 s14, 6, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v39, v7, v5, s14
		s_mul_i32 s14, 7, s18
		s_add_i32 s14, s14, 8
		s_add_i32 s1, s14, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v97, v7, v5, s1
		buffer_load_ubyte_d16 v98, v96, s[40:43], 0 offen
		buffer_load_ubyte_d16 v103, v99, s[40:43], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v101, s[40:43], 0 offen
		v_mov_b32_e32 v105, 0
		buffer_load_ubyte_d16_hi v105, v102, s[40:43], 0 offen
		buffer_load_ubyte_d16 v106, v100, s[40:43], 0 offen
		buffer_load_ubyte_d16 v107, v38, s[40:43], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v39, s[40:43], 0 offen
		v_mov_b32_e32 v109, 0
		buffer_load_ubyte_d16_hi v109, v97, s[40:43], 0 offen
		s_add_i32 s1, s44, 8
		v_add3_u32 v5, s1, v77, v66
		v_add3_u32 v5, v5, v67, v79
		v_add3_u32 v110, v5, v80, v7
		s_add_i32 s1, s19, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v5, v77, v66, v67
		v_add3_u32 v5, v5, v79, v80
		v_add3_u32 v111, v7, v5, s1
		s_lshl_b32 s1, s19, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v112, v7, v5, s1
		s_mul_i32 s1, 3, s19
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v113, v7, v5, s1
		buffer_load_ubyte_d16 v114, v110, s[48:51], 0 offen
		buffer_load_ubyte_d16 v115, v111, s[48:51], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v112, s[48:51], 0 offen
		v_mov_b32_e32 v117, 0
		buffer_load_ubyte_d16_hi v117, v113, s[48:51], 0 offen
		s_add_i32 s1, s45, 0x80
		v_add3_u32 v5, s1, v6, v29
		v_add3_u32 v5, v5, v31, v32
		v_add3_u32 v5, v5, v33, v16
		s_add_i32 m0, s21, 0x1cd60
		v_add3_u32 v118, v5, v18, v20
		buffer_load_dwordx4 v118, s[36:39], 0 offen lds
		s_add_i32 s1, s46, 0x80
		v_add3_u32 v5, v6, v29, v31
		v_add3_u32 v5, v5, v32, v33
		v_add3_u32 v5, v5, v16, v18
		s_add_i32 m0, s21, 0x1dde0
		v_add3_u32 v29, v20, v5, s1
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_add_i32 s1, s47, 0x80
		s_add_i32 m0, s21, 0x1ee60
		v_add3_u32 v31, v20, v5, s1
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		s_add_i32 s1, s15, 0x80
		s_add_i32 m0, s21, 0x1fee0
		v_add3_u32 v32, v20, v5, s1
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_add_i32 s1, s52, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v5, s1, v77, v66
		v_add3_u32 v5, v5, v67, v79
		v_add3_u32 v33, v5, v80, v7
		s_add_i32 s1, s53, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v5, v77, v66, v67
		v_add3_u32 v5, v5, v79, v80
		v_add3_u32 v66, v7, v5, s1
		s_add_i32 s1, s54, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v67, v7, v5, s1
		s_add_i32 s1, s55, 8
		s_add_i32 s1, s1, s44
		v_add3_u32 v77, v7, v5, s1
		buffer_load_ubyte_d16 v79, v33, s[48:51], 0 offen
		buffer_load_ubyte_d16 v80, v66, s[48:51], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v67, s[48:51], 0 offen
		v_mov_b32_e32 v120, 0
		buffer_load_ubyte_d16_hi v120, v77, s[48:51], 0 offen
		s_waitcnt vmcnt(52)
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s20, 0x100
		v_lshlrev_b32_e32 v5, 7, v1
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v7, 4, v6
		v_lshlrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v6, 15, v6
		v_mov_b32_e32 v121, 0x420
		v_mul_lo_u32 v121, v121, v6
		v_add3_u32 v122, v5, v7, v121
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
		v_add_u32_e32 v5, 0x10000, v7
		v_lshlrev_b32_e32 v6, 7, v3
		v_add3_u32 v121, v5, v6, v121
		ds_read_b128 a[68:71], v121 offset:1984
		ds_read_b128 a[72:75], v121 offset:2048
		ds_read_b128 a[76:79], v121 offset:2240
		ds_read_b128 a[80:83], v121 offset:2304
		ds_read_b128 a[84:87], v121 offset:2496
		ds_read_b128 a[88:91], v121 offset:2560
		ds_read_b128 a[92:95], v121 offset:2752
		ds_read_b128 a[96:99], v121 offset:2816
		v_add_u32_e32 v5, 0x20000, v12
		v_lshlrev_b32_e32 v6, 8, v15
		v_add_u32_e32 v7, v5, v6
		v_lshlrev_b32_e32 v12, 10, v17
		v_lshlrev_b32_e32 v123, 9, v19
		v_add3_u32 v124, v7, v12, v123
		s_waitcnt vmcnt(51)
		ds_write_b8 v124, v46 offset:3904
		v_add_u32_e32 v6, 0x20000, v6
		v_add3_u32 v6, v6, v12, v123
		v_add_u32_e32 v12, v6, v45
		s_waitcnt vmcnt(50)
		ds_write_b8 v12, v56 offset:3904
		v_add_u32_e32 v46, v6, v48
		s_waitcnt vmcnt(49)
		ds_write_b8 v46, v59 offset:3904
		v_add_u32_e32 v56, v6, v51
		s_waitcnt vmcnt(48)
		ds_write_b8 v56, v60 offset:3904
		v_add_u32_e32 v53, v6, v53
		s_waitcnt vmcnt(47)
		ds_write_b8 v53, v61 offset:3904
		v_add_u32_e32 v54, v6, v54
		s_waitcnt vmcnt(46)
		ds_write_b8 v54, v62 offset:3904
		v_add_u32_e32 v57, v6, v57
		s_waitcnt vmcnt(45)
		ds_write_b8 v57, v63 offset:3904
		v_add_u32_e32 v43, v6, v43
		s_waitcnt vmcnt(44)
		ds_write_b8 v43, v64 offset:3904
		v_lshlrev_b32_e32 v6, 7, v15
		v_add_u32_e32 v5, v5, v6
		v_lshlrev_b32_e32 v7, 9, v17
		v_lshlrev_b32_e32 v59, 8, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v60, v5, v7, v59
		s_waitcnt vmcnt(43)
		ds_write_b8 v60, v69 offset:5952
		v_add_u32_e32 v5, 0x20000, v6
		v_add3_u32 v5, v5, v7, v59
		v_add_u32_e32 v45, v5, v45
		s_waitcnt vmcnt(42)
		ds_write_b8 v45, v70 offset:5952
		v_add_u32_e32 v48, v5, v48
		s_waitcnt vmcnt(41)
		ds_write_b8 v48, v71 offset:5952
		v_add_u32_e32 v51, v5, v51
		s_waitcnt vmcnt(40)
		ds_write_b8 v51, v72 offset:5952
		v_add_u32_e32 v5, 0x20000, v42
		v_lshlrev_b32_e32 v6, 3, v15
		v_add_u32_e32 v5, v5, v6
		v_lshl_add_u32 v5, v8, 9, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v7, 8, v10
		v_lshlrev_b32_e32 v42, 6, v13
		v_add3_u32 v5, v5, v7, v42
		v_lshlrev_b32_e32 v7, 5, v17
		v_lshlrev_b32_e32 v19, 10, v19
		v_accvgpr_write_b32 a1, v19
		v_accvgpr_read_b32 v19, a1
		v_add3_u32 v19, v5, v7, v19
		ds_read_b64_tr_b8 v[62:63], v19 offset:3904
		ds_read_b64_tr_b8 v[70:71], v19 offset:4032
		v_add_u32_e32 v5, 0x20000, v6
		v_lshl_add_u32 v5, v3, 4, v5
		v_lshl_add_u32 v5, v8, 8, v5
		v_lshlrev_b32_e32 v6, 7, v10
		v_add3_u32 v5, v5, v6, v42
		v_add3_u32 v42, v5, v7, v123
		ds_read_b64_tr_b8 v[126:127], v42 offset:5952
		s_mov_b32 s14, 16
		s_mov_b32 s15, s14
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v59, 0x20000, v5
		v_lshlrev_b32_e32 v5, 3, v0
		v_add_u32_e32 v61, 0x20000, v5
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
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s14, s15
		v_accvgpr_write_b32 a100, v4
		v_accvgpr_write_b32 a101, v5
		v_accvgpr_write_b32 a102, v6
		v_accvgpr_write_b32 a103, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v126, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v126, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[12:15], v[136:139], v126, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[12:15], v[132:135], v126, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[8:11], v[240:243], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[16:19], v[136:139], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[16:19], v[132:135], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v127, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[4:7], v[128:131], v127, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[12:15], v[144:147], v127, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[12:15], v[140:143], v127, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[88:91], a[8:11], v[4:7], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[8:11], v[128:131], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[16:19], v[144:147], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[16:19], v[140:143], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[20:23], v[156:159], v127, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[20:23], v[160:163], v127, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[28:31], v[176:179], v127, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[28:31], v[172:175], v127, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[24:27], v[156:159], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[24:27], v[160:163], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[32:35], v[176:179], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[32:35], v[172:175], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[20:23], v[148:151], v126, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[20:23], v[152:155], v126, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[28:31], v[168:171], v126, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[28:31], v[164:167], v126, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[24:27], v[148:151], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[24:27], v[152:155], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[32:35], v[168:171], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[32:35], v[164:167], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[36:39], v[180:183], v126, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[36:39], v[184:187], v126, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[44:47], v[200:203], v126, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[44:47], v[196:199], v126, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[40:43], v[180:183], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[40:43], v[184:187], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[48:51], v[200:203], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[48:51], v[196:199], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[36:39], v[188:191], v127, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[36:39], v[192:195], v127, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[44:47], v[208:211], v127, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[44:47], v[204:207], v127, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[40:43], v[188:191], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[40:43], v[192:195], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], a[48:51], v[208:211], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[48:51], v[204:207], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[52:55], v[220:223], v127, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[52:55], v[224:227], v127, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v127, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[60:63], v[236:239], v127, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[56:59], v[220:223], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], a[56:59], v[224:227], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[64:67], v[236:239], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[52:55], v[212:215], v126, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[52:55], v[216:219], v126, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[60:63], v[232:235], v126, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[60:63], v[228:231], v126, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[56:59], v[212:215], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[56:59], v[216:219], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[64:67], v[232:235], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[64:67], v[228:231], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[68:71], v121 offset:35712
		ds_read_b128 a[72:75], v121 offset:35776
		ds_read_b128 a[76:79], v121 offset:35968
		ds_read_b128 a[80:83], v121 offset:36032
		ds_read_b128 a[84:87], v121 offset:36224
		ds_read_b128 a[88:91], v121 offset:36288
		ds_read_b128 a[92:95], v121 offset:36480
		ds_read_b128 a[96:99], v121 offset:36544
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v64, v85, v87
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v64, v84, v86, v64
		ds_write_b32 v59, v64 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[84:85], v42 offset:5952
		s_add_i32 m0, s21, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v84, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v84, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v84, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v84, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v84, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x6300
		s_nop 0
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_waitcnt vmcnt(15)
		v_or_b32_e32 v64, v115, v117
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
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x107c0
		v_or_b32_e32 v62, v107, v109
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v85, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v84, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v84, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v84, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v84, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x11840
		v_or_b32_e32 v69, v103, v105
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x128c0
		s_add_u32 s40, s10, s14
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x13940
		s_add_u32 s36, s8, s15
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		buffer_load_ubyte v72, v37, s[36:39], 0 offen
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
		ds_read_b128 a[68:71], v121 offset:18848
		ds_read_b128 a[72:75], v121 offset:18912
		ds_read_b128 a[76:79], v121 offset:19104
		ds_read_b128 a[80:83], v121 offset:19168
		ds_read_b128 a[84:87], v121 offset:19360
		ds_read_b128 a[88:91], v121 offset:19424
		ds_read_b128 a[92:95], v121 offset:19616
		ds_read_b128 v[252:255], v121 offset:19680
		v_lshlrev_b32_e32 v63, 8, v69
		v_or3_b32 v70, v98, v104, v63
		v_lshlrev_b32_e32 v62, 8, v62
		v_or3_b32 v71, v106, v108, v62
		ds_write_b64 v61, v[70:71] offset:3904
		v_lshlrev_b32_e32 v62, 8, v64
		v_or3_b32 v62, v114, v116, v62
		s_add_i32 m0, s21, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v73, s[32:35], 0 offen lds
		ds_write_b32 v59, v62 offset:5952
		s_add_i32 m0, s21, 0x19c00
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v75, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[62:63], v19 offset:3904
		ds_read_b64_tr_b8 v[70:71], v19 offset:4032
		ds_read_b64_tr_b8 v[104:105], v42 offset:5952
		s_add_i32 m0, s21, 0x1ac80
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v104, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v76, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1bd00
		s_nop 0
		buffer_load_dwordx4 v74, s[32:35], 0 offen lds
		s_waitcnt vmcnt(28)
		v_or_b32_e32 v64, v80, v120
		buffer_load_ubyte_d16 v84, v78, s[40:43], 0 offen
		buffer_load_ubyte_d16 v85, v82, s[40:43], 0 offen
		v_mov_b32_e32 v86, 0
		buffer_load_ubyte_d16_hi v86, v83, s[40:43], 0 offen
		v_mov_b32_e32 v87, 0
		buffer_load_ubyte_d16_hi v87, v81, s[40:43], 0 offen
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v104, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[12:15], v[136:139], v104, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[12:15], v[132:135], v104, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[8:11], v[240:243], v104, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v104, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[16:19], v[136:139], v104, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[16:19], v[132:135], v104, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v105, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[4:7], v[128:131], v105, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[12:15], v[144:147], v105, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[12:15], v[140:143], v105, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[88:91], a[8:11], v[4:7], v105, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[8:11], v[128:131], v105, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[16:19], v[144:147], v105, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[16:19], v[140:143], v105, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[20:23], v[156:159], v105, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[20:23], v[160:163], v105, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[28:31], v[176:179], v105, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[28:31], v[172:175], v105, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[24:27], v[156:159], v105, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[24:27], v[160:163], v105, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[32:35], v[176:179], v105, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[32:35], v[172:175], v105, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[20:23], v[148:151], v104, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[20:23], v[152:155], v104, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[28:31], v[168:171], v104, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[28:31], v[164:167], v104, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[24:27], v[148:151], v104, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[24:27], v[152:155], v104, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[32:35], v[168:171], v104, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[32:35], v[164:167], v104, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[36:39], v[180:183], v104, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[36:39], v[184:187], v104, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[44:47], v[200:203], v104, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[44:47], v[196:199], v104, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[40:43], v[180:183], v104, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[40:43], v[184:187], v104, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[48:51], v[200:203], v104, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[48:51], v[196:199], v104, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[36:39], v[188:191], v105, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[36:39], v[192:195], v105, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[44:47], v[208:211], v105, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[44:47], v[204:207], v105, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[40:43], v[188:191], v105, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[40:43], v[192:195], v105, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[48:51], v[208:211], v105, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[48:51], v[204:207], v105, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[52:55], v[220:223], v105, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[52:55], v[224:227], v105, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v105, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[60:63], v[236:239], v105, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[56:59], v[220:223], v105, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[56:59], v[224:227], v105, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[64:67], a[104:107], v105, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[64:67], v[236:239], v105, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[52:55], v[212:215], v104, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[52:55], v[216:219], v104, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[60:63], v[232:235], v104, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[60:63], v[228:231], v104, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[56:59], v[212:215], v104, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[56:59], v[216:219], v104, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[64:67], v[232:235], v104, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[64:67], v[228:231], v104, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[68:71], v121 offset:52576
		ds_read_b128 a[72:75], v121 offset:52640
		ds_read_b128 a[76:79], v121 offset:52832
		ds_read_b128 a[80:83], v121 offset:52896
		ds_read_b128 a[84:87], v121 offset:53088
		ds_read_b128 a[88:91], v121 offset:53152
		ds_read_b128 a[92:95], v121 offset:53344
		ds_read_b128 a[96:99], v121 offset:53408
		v_lshlrev_b32_e32 v64, 8, v64
		v_or3_b32 v64, v79, v119, v64
		ds_write_b32 v59, v64 offset:5952
		s_add_i32 m0, s21, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v88, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[252:253], v42 offset:5952
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
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v252, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v252, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v95, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v98, v96, s[36:39], 0 offen
		buffer_load_ubyte_d16 v103, v99, s[36:39], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v101, s[36:39], 0 offen
		v_mov_b32_e32 v105, 0
		buffer_load_ubyte_d16_hi v105, v102, s[36:39], 0 offen
		buffer_load_ubyte_d16 v106, v100, s[36:39], 0 offen
		buffer_load_ubyte_d16 v107, v38, s[36:39], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v39, s[36:39], 0 offen
		v_mov_b32_e32 v109, 0
		buffer_load_ubyte_d16_hi v109, v97, s[36:39], 0 offen
		buffer_load_ubyte_d16 v114, v110, s[40:43], 0 offen
		buffer_load_ubyte_d16 v115, v111, s[40:43], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v112, s[40:43], 0 offen
		v_mov_b32_e32 v117, 0
		buffer_load_ubyte_d16_hi v117, v113, s[40:43], 0 offen
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
		ds_read_b128 a[68:71], v121 offset:1984
		ds_read_b128 a[72:75], v121 offset:2048
		ds_read_b128 a[76:79], v121 offset:2240
		ds_read_b128 a[80:83], v121 offset:2304
		ds_read_b128 a[84:87], v121 offset:2496
		ds_read_b128 a[88:91], v121 offset:2560
		ds_read_b128 a[92:95], v121 offset:2752
		ds_read_b128 a[96:99], v121 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v124, v72 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v12, v123 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v46, v125 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v56, v126 offset:3904
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
		buffer_load_dwordx4 v118, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1dde0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_waitcnt vmcnt(37)
		ds_write_b8 v60, v247 offset:5952
		s_waitcnt vmcnt(36)
		ds_write_b8 v45, v248 offset:5952
		s_waitcnt vmcnt(35)
		ds_write_b8 v48, v249 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v51, v250 offset:5952
		s_add_i32 s15, s15, 16
		s_add_i32 m0, s21, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[62:63], v19 offset:3904
		ds_read_b64_tr_b8 v[70:71], v19 offset:4032
		ds_read_b64_tr_b8 v[126:127], v42 offset:5952
		s_add_i32 m0, s21, 0x1fee0
		s_nop 0
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_add_i32 s1, s1, 0x100
		buffer_load_ubyte_d16 v79, v33, s[40:43], 0 offen
		buffer_load_ubyte_d16 v80, v66, s[40:43], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v67, s[40:43], 0 offen
		v_mov_b32_e32 v120, 0
		buffer_load_ubyte_d16_hi v120, v77, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(4)
		s_barrier
		v_or_b32_e32 v2, v85, v87
		v_lshlrev_b32_e32 v2, 8, v2
		v_or3_b32 v2, v84, v86, v2
		v_or_b32_e32 v9, v103, v105
		v_lshlrev_b32_e32 v9, 8, v9
		v_or3_b32 v22, v98, v104, v9
		v_or_b32_e32 v9, v107, v109
		v_lshlrev_b32_e32 v9, 8, v9
		v_or3_b32 v23, v106, v108, v9
		v_or_b32_e32 v9, v115, v117
		v_lshlrev_b32_e32 v9, 8, v9
		v_or3_b32 v9, v114, v116, v9
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v11, v80, v120
		v_lshlrev_b32_e32 v11, 8, v11
		v_or3_b32 v11, v79, v119, v11
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v126, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v126, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[12:15], v[136:139], v126, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[12:15], v[132:135], v126, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[8:11], v[240:243], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[16:19], v[136:139], v126, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[16:19], v[132:135], v126, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v127, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[4:7], v[128:131], v127, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[12:15], v[144:147], v127, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[12:15], v[140:143], v127, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[88:91], a[8:11], v[4:7], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[8:11], v[128:131], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[16:19], v[144:147], v127, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[16:19], v[140:143], v127, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[20:23], v[156:159], v127, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[20:23], v[160:163], v127, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[28:31], v[176:179], v127, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[28:31], v[172:175], v127, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[24:27], v[156:159], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[24:27], v[160:163], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[32:35], v[176:179], v127, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[32:35], v[172:175], v127, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[20:23], v[148:151], v126, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[20:23], v[152:155], v126, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[28:31], v[168:171], v126, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[28:31], v[164:167], v126, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[24:27], v[148:151], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[24:27], v[152:155], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[32:35], v[168:171], v126, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[32:35], v[164:167], v126, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[36:39], v[180:183], v126, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[36:39], v[184:187], v126, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[44:47], v[200:203], v126, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[44:47], v[196:199], v126, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[40:43], v[180:183], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[40:43], v[184:187], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[48:51], v[200:203], v126, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[48:51], v[196:199], v126, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[36:39], v[188:191], v127, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[36:39], v[192:195], v127, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[44:47], v[208:211], v127, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[44:47], v[204:207], v127, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[40:43], v[188:191], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[40:43], v[192:195], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], a[48:51], v[208:211], v127, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[48:51], v[204:207], v127, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[52:55], v[220:223], v127, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[52:55], v[224:227], v127, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v127, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[60:63], v[236:239], v127, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[56:59], v[220:223], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], a[56:59], v[224:227], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v127, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[64:67], v[236:239], v127, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[52:55], v[212:215], v126, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[52:55], v[216:219], v126, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[60:63], v[232:235], v126, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[60:63], v[228:231], v126, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[56:59], v[212:215], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[56:59], v[216:219], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[64:67], v[232:235], v126, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[64:67], v[228:231], v126, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v121 offset:35712
		ds_read_b128 v[28:31], v121 offset:35776
		ds_read_b128 v[32:35], v121 offset:35968
		ds_read_b128 v[36:39], v121 offset:36032
		ds_read_b128 v[44:47], v121 offset:36224
		ds_read_b128 v[48:51], v121 offset:36288
		ds_read_b128 v[52:55], v121 offset:36480
		ds_read_b128 v[64:67], v121 offset:36544
		ds_write_b32 v59, v2 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v15
		v_accvgpr_read_b32 v12, a0
		v_lshl_add_u32 v2, v12, 4, v2
		v_lshl_add_u32 v2, v13, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v42 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[4:7], a[108:111], v14, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[4:7], a[112:115], v14, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[12:15], a[128:131], v14, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[12:15], a[124:127], v14, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[8:11], a[108:111], v14, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[8:11], a[112:115], v14, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[16:19], a[128:131], v14, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[16:19], a[124:127], v14, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[4:7], a[116:119], v15, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[4:7], a[120:123], v15, v62 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[12:15], a[136:139], v15, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[12:15], a[132:135], v15, v62 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[8:11], a[116:119], v15, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[8:11], a[120:123], v15, v62 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[16:19], a[136:139], v15, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[16:19], a[132:135], v15, v62 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[20:23], a[148:151], v15, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[20:23], a[152:155], v15, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[28:31], a[168:171], v15, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[28:31], a[164:167], v15, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[24:27], a[148:151], v15, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[24:27], a[152:155], v15, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[32:35], a[168:171], v15, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[32:35], a[164:167], v15, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[20:23], a[140:143], v14, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[20:23], a[144:147], v14, v63 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[28:31], a[160:163], v14, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[28:31], a[156:159], v14, v63 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[24:27], a[140:143], v14, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[24:27], a[144:147], v14, v63 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[32:35], a[160:163], v14, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[32:35], a[156:159], v14, v63 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], a[36:39], a[172:175], v14, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], a[36:39], a[176:179], v14, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], a[44:47], a[192:195], v14, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], a[44:47], a[188:191], v14, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], a[40:43], a[172:175], v14, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], a[40:43], a[176:179], v14, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], a[48:51], a[192:195], v14, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], a[48:51], a[188:191], v14, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[44:47], a[36:39], a[180:183], v15, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], a[36:39], a[184:187], v15, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[52:55], a[44:47], a[200:203], v15, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[44:47], a[44:47], a[196:199], v15, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], a[40:43], a[180:183], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[64:67], a[40:43], a[184:187], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[64:67], a[48:51], a[200:203], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[48:51], a[48:51], a[196:199], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[44:47], a[52:55], a[212:215], v15, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[52:55], a[52:55], a[216:219], v15, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[52:55], a[60:63], a[232:235], v15, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], a[60:63], a[228:231], v15, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[48:51], a[56:59], a[212:215], v15, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[64:67], a[56:59], a[216:219], v15, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[64:67], a[64:67], a[232:235], v15, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[48:51], a[64:67], a[228:231], v15, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], a[52:55], a[204:207], v14, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], a[52:55], a[208:211], v14, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], a[60:63], a[224:227], v14, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[24:27], a[60:63], a[220:223], v14, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[28:31], a[56:59], a[204:207], v14, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], a[56:59], a[208:211], v14, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], a[64:67], a[224:227], v14, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[28:31], a[64:67], a[220:223], v14, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v122 offset:33760
		ds_read_b128 v[28:31], v122 offset:33824
		ds_read_b128 v[32:35], v122 offset:34016
		ds_read_b128 v[36:39], v122 offset:34080
		ds_read_b128 v[44:47], v122 offset:34272
		ds_read_b128 v[48:51], v122 offset:34336
		ds_read_b128 v[52:55], v122 offset:34528
		ds_read_b128 v[64:67], v122 offset:34592
		ds_read_b128 v[68:71], v122 offset:50656
		ds_read_b128 v[72:75], v122 offset:50720
		ds_read_b128 v[76:79], v122 offset:50912
		ds_read_b128 v[80:83], v122 offset:50976
		ds_read_b128 v[84:87], v122 offset:51168
		ds_read_b128 v[88:91], v122 offset:51232
		ds_read_b128 v[92:95], v122 offset:51424
		ds_read_b128 v[96:99], v122 offset:51488
		ds_read_b128 v[100:103], v121 offset:18848
		ds_read_b128 v[104:107], v121 offset:18912
		ds_read_b128 v[108:111], v121 offset:19104
		ds_read_b128 v[112:115], v121 offset:19168
		ds_read_b128 v[116:119], v121 offset:19360
		ds_read_b128 v[124:127], v121 offset:19424
		ds_read_b128 v[244:247], v121 offset:19616
		ds_read_b128 v[248:251], v121 offset:19680
		ds_write_b64 v61, v[22:23] offset:3904
		v_lshlrev_b32_e32 v12, 12, v17
		v_accvgpr_read_b32 v14, a1
		v_add3_u32 v2, v2, v12, v14
		v_lshlrev_b32_e32 v12, 7, v13
		v_lshlrev_b32_e32 v13, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v59, v9 offset:5952
		v_lshlrev_b32_e32 v9, 2, v3
		v_add_u32_e32 v14, 16, v10
		v_lshlrev_b32_e32 v15, 1, v8
		v_xor_b32_e32 v14, v14, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[22:23], v19 offset:3904
		ds_read_b64_tr_b8 v[40:41], v19 offset:4032
		ds_read_b64_tr_b8 v[56:57], v42 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[100:103], v[24:27], v[240:243], v56, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[24:27], a[100:103], v56, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[108:111], v[32:35], v[136:139], v56, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[100:103], v[32:35], v[132:135], v56, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[104:107], v[28:31], v[240:243], v56, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[112:115], v[28:31], a[100:103], v56, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[112:115], v[36:39], v[136:139], v56, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[104:107], v[36:39], v[132:135], v56, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[116:119], v[24:27], v[4:7], v57, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[244:247], v[24:27], v[128:131], v57, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[244:247], v[32:35], v[144:147], v57, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[116:119], v[32:35], v[140:143], v57, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[124:127], v[28:31], v[4:7], v57, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[248:251], v[28:31], v[128:131], v57, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[248:251], v[36:39], v[144:147], v57, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[124:127], v[36:39], v[140:143], v57, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[116:119], v[44:47], v[156:159], v57, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[244:247], v[44:47], v[160:163], v57, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[244:247], v[52:55], v[176:179], v57, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[116:119], v[52:55], v[172:175], v57, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[124:127], v[48:51], v[156:159], v57, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[248:251], v[48:51], v[160:163], v57, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[248:251], v[64:67], v[176:179], v57, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[124:127], v[64:67], v[172:175], v57, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[100:103], v[44:47], v[148:151], v56, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[108:111], v[44:47], v[152:155], v56, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[108:111], v[52:55], v[168:171], v56, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[100:103], v[52:55], v[164:167], v56, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[104:107], v[48:51], v[148:151], v56, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[112:115], v[48:51], v[152:155], v56, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[112:115], v[64:67], v[168:171], v56, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[104:107], v[64:67], v[164:167], v56, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[100:103], v[68:71], v[180:183], v56, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[108:111], v[68:71], v[184:187], v56, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[108:111], v[76:79], v[200:203], v56, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[100:103], v[76:79], v[196:199], v56, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[104:107], v[72:75], v[180:183], v56, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[112:115], v[72:75], v[184:187], v56, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[112:115], v[80:83], v[200:203], v56, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[104:107], v[80:83], v[196:199], v56, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[116:119], v[68:71], v[188:191], v57, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[244:247], v[68:71], v[192:195], v57, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[76:79], v[208:211], v57, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[116:119], v[76:79], v[204:207], v57, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[124:127], v[72:75], v[188:191], v57, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[248:251], v[72:75], v[192:195], v57, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[248:251], v[80:83], v[208:211], v57, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[124:127], v[80:83], v[204:207], v57, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[116:119], v[84:87], v[220:223], v57, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[244:247], v[84:87], v[224:227], v57, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[244:247], v[92:95], a[104:107], v57, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[116:119], v[92:95], v[236:239], v57, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[124:127], v[88:91], v[220:223], v57, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[248:251], v[88:91], v[224:227], v57, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[248:251], v[96:99], a[104:107], v57, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[124:127], v[96:99], v[236:239], v57, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[100:103], v[84:87], v[212:215], v56, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[108:111], v[84:87], v[216:219], v56, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[108:111], v[92:95], v[232:235], v56, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[100:103], v[92:95], v[228:231], v56, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[104:107], v[88:91], v[212:215], v56, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[112:115], v[88:91], v[216:219], v56, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[112:115], v[96:99], v[232:235], v56, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[104:107], v[96:99], v[228:231], v56, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v121 offset:52576
		ds_read_b128 v[100:103], v121 offset:52640
		ds_read_b128 v[104:107], v121 offset:52832
		ds_read_b128 v[108:111], v121 offset:52896
		ds_read_b128 v[112:115], v121 offset:53088
		ds_read_b128 v[116:119], v121 offset:53152
		ds_read_b128 v[124:127], v121 offset:53344
		ds_read_b128 v[244:247], v121 offset:53408
		ds_write_b32 v59, v11 offset:5952
		v_cvt_pk_bf16_f32 v56, v240, v241
		v_cvt_pk_bf16_f32 v57, v242, v243
		v_accvgpr_read_b32 v11, a100
		v_accvgpr_read_b32 v17, a101
		v_cvt_pk_bf16_f32 v120, v11, v17
		v_accvgpr_read_b32 v11, a102
		v_accvgpr_read_b32 v17, a103
		v_cvt_pk_bf16_f32 v121, v11, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[240:241], v42 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v248, v4, v5
		v_cvt_pk_bf16_f32 v249, v6, v7
		v_cvt_pk_bf16_f32 v4, v128, v129
		v_cvt_pk_bf16_f32 v5, v130, v131
		v_cvt_pk_bf16_f32 v58, v132, v133
		v_cvt_pk_bf16_f32 v59, v134, v135
		v_cvt_pk_bf16_f32 v122, v136, v137
		v_cvt_pk_bf16_f32 v123, v138, v139
		v_cvt_pk_bf16_f32 v250, v140, v141
		v_cvt_pk_bf16_f32 v251, v142, v143
		v_cvt_pk_bf16_f32 v6, v144, v145
		v_cvt_pk_bf16_f32 v7, v146, v147
		v_cvt_pk_bf16_f32 v128, v148, v149
		v_cvt_pk_bf16_f32 v129, v150, v151
		v_cvt_pk_bf16_f32 v132, v152, v153
		v_cvt_pk_bf16_f32 v133, v154, v155
		v_cvt_pk_bf16_f32 v136, v156, v157
		v_cvt_pk_bf16_f32 v137, v158, v159
		v_cvt_pk_bf16_f32 v140, v160, v161
		v_cvt_pk_bf16_f32 v141, v162, v163
		v_cvt_pk_bf16_f32 v130, v164, v165
		v_cvt_pk_bf16_f32 v131, v166, v167
		v_cvt_pk_bf16_f32 v134, v168, v169
		v_cvt_pk_bf16_f32 v135, v170, v171
		v_cvt_pk_bf16_f32 v138, v172, v173
		v_cvt_pk_bf16_f32 v139, v174, v175
		v_cvt_pk_bf16_f32 v142, v176, v177
		v_cvt_pk_bf16_f32 v143, v178, v179
		v_cvt_pk_bf16_f32 v144, v180, v181
		v_cvt_pk_bf16_f32 v145, v182, v183
		v_cvt_pk_bf16_f32 v148, v184, v185
		v_cvt_pk_bf16_f32 v149, v186, v187
		v_cvt_pk_bf16_f32 v152, v188, v189
		v_cvt_pk_bf16_f32 v153, v190, v191
		v_cvt_pk_bf16_f32 v156, v192, v193
		v_cvt_pk_bf16_f32 v157, v194, v195
		v_cvt_pk_bf16_f32 v146, v196, v197
		v_cvt_pk_bf16_f32 v147, v198, v199
		v_cvt_pk_bf16_f32 v150, v200, v201
		v_cvt_pk_bf16_f32 v151, v202, v203
		v_cvt_pk_bf16_f32 v154, v204, v205
		v_cvt_pk_bf16_f32 v155, v206, v207
		v_cvt_pk_bf16_f32 v158, v208, v209
		v_cvt_pk_bf16_f32 v159, v210, v211
		v_cvt_pk_bf16_f32 v160, v212, v213
		v_cvt_pk_bf16_f32 v161, v214, v215
		v_cvt_pk_bf16_f32 v164, v216, v217
		v_cvt_pk_bf16_f32 v165, v218, v219
		v_cvt_pk_bf16_f32 v168, v220, v221
		v_cvt_pk_bf16_f32 v169, v222, v223
		v_cvt_pk_bf16_f32 v172, v224, v225
		v_cvt_pk_bf16_f32 v173, v226, v227
		v_cvt_pk_bf16_f32 v162, v228, v229
		v_cvt_pk_bf16_f32 v163, v230, v231
		v_cvt_pk_bf16_f32 v166, v232, v233
		v_cvt_pk_bf16_f32 v167, v234, v235
		v_cvt_pk_bf16_f32 v170, v236, v237
		v_cvt_pk_bf16_f32 v171, v238, v239
		v_accvgpr_read_b32 v11, a104
		v_accvgpr_read_b32 v17, a105
		v_cvt_pk_bf16_f32 v174, v11, v17
		v_accvgpr_read_b32 v11, a106
		v_accvgpr_read_b32 v17, a107
		v_cvt_pk_bf16_f32 v175, v11, v17
		ds_write_b128 v0, v[56:59]
		ds_write_b128 v0, v[120:123] offset:4096
		ds_write_b128 v0, v[248:251] offset:8192
		ds_write_b128 v0, v[4:7] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_bitop3_b32 v4, v13, v9, v14 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v2
		ds_read_b128 v[120:123], v2 offset:256
		ds_read_b128 v[176:179], v2 offset:2048
		ds_read_b128 v[180:183], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[128:131]
		ds_write_b128 v0, v[132:135] offset:4096
		ds_write_b128 v0, v[136:139] offset:8192
		ds_write_b128 v0, v[140:143] offset:12288
		v_add_u32_e32 v5, 32, v10
		v_xor_b32_e32 v5, v5, v15
		v_bitop3_b32 v5, v13, v9, v5 bitop3:0x96
		v_add_u32_e32 v6, 48, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[128:131], v2
		ds_read_b128 v[132:135], v2 offset:256
		ds_read_b128 v[136:139], v2 offset:2048
		ds_read_b128 v[140:143], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[144:147]
		ds_write_b128 v0, v[148:151] offset:4096
		ds_write_b128 v0, v[152:155] offset:8192
		ds_write_b128 v0, v[156:159] offset:12288
		v_xor_b32_e32 v6, v6, v15
		v_bitop3_b32 v6, v13, v9, v6 bitop3:0x96
		v_add_u32_e32 v7, 64, v10
		v_xor_b32_e32 v7, v7, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[144:147], v2
		ds_read_b128 v[148:151], v2 offset:256
		ds_read_b128 v[152:155], v2 offset:2048
		ds_read_b128 v[156:159], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[160:163]
		ds_write_b128 v0, v[164:167] offset:4096
		ds_write_b128 v0, v[168:171] offset:8192
		ds_write_b128 v0, v[172:175] offset:12288
		v_bitop3_b32 v7, v13, v9, v7 bitop3:0x96
		v_add_u32_e32 v11, 0x50, v10
		v_xor_b32_e32 v11, v11, v15
		v_bitop3_b32 v11, v13, v9, v11 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[160:163], v2
		ds_read_b128 v[164:167], v2 offset:256
		ds_read_b128 v[168:171], v2 offset:2048
		ds_read_b128 v[172:175], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v14, s0, v1, v3
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_mul_lo_u32 v17, s17, v10
		v_lshlrev_b32_e32 v17, 1, v17
		v_add3_u32 v14, v14, v8, v17
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[184:185], v[56:57]
		v_mov_b64_e32 v[186:187], v[120:121]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[184:187], v14, s[8:11], 0 offen
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v14, s0, v4
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[184:185], v[176:177]
		v_mov_b64_e32 v[186:187], v[180:181]
		buffer_store_dwordx4 v[184:187], v14, s[8:11], 0 offen
		v_mul_lo_u32 v5, s17, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_add_u32_e32 v14, s0, v5
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[184:185], v[58:59]
		v_mov_b64_e32 v[186:187], v[122:123]
		buffer_store_dwordx4 v[184:187], v14, s[8:11], 0 offen
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v14, s0, v6
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[56:57], v[178:179]
		v_mov_b64_e32 v[58:59], v[182:183]
		buffer_store_dwordx4 v[56:59], v14, s[8:11], 0 offen
		v_mul_lo_u32 v7, s17, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v14, s0, v7
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[56:57], v[128:129]
		v_mov_b64_e32 v[58:59], v[132:133]
		buffer_store_dwordx4 v[56:59], v14, s[8:11], 0 offen
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v14, s0, v11
		v_add3_u32 v14, v14, v16, v12
		v_add3_u32 v14, v14, v18, v20
		v_mov_b64_e32 v[56:57], v[136:137]
		v_mov_b64_e32 v[58:59], v[140:141]
		buffer_store_dwordx4 v[56:59], v14, s[8:11], 0 offen
		v_add_u32_e32 v14, 0x60, v10
		v_xor_b32_e32 v14, v14, v15
		v_bitop3_b32 v14, v13, v9, v14 bitop3:0x96
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v19, s0, v14
		v_add3_u32 v19, v19, v16, v12
		v_add3_u32 v19, v19, v18, v20
		v_mov_b64_e32 v[56:57], v[130:131]
		v_mov_b64_e32 v[58:59], v[134:135]
		buffer_store_dwordx4 v[56:59], v19, s[8:11], 0 offen
		v_add_u32_e32 v19, 0x70, v10
		v_xor_b32_e32 v19, v19, v15
		v_bitop3_b32 v19, v13, v9, v19 bitop3:0x96
		v_mul_lo_u32 v19, s17, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_add_u32_e32 v21, s0, v19
		v_add3_u32 v21, v21, v16, v12
		v_add3_u32 v21, v21, v18, v20
		v_mov_b64_e32 v[56:57], v[138:139]
		v_mov_b64_e32 v[58:59], v[142:143]
		buffer_store_dwordx4 v[56:59], v21, s[8:11], 0 offen
		v_add_u32_e32 v21, 0x80, v10
		v_xor_b32_e32 v21, v21, v15
		v_bitop3_b32 v21, v13, v9, v21 bitop3:0x96
		v_mul_lo_u32 v21, s17, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v42, s0, v21
		v_add3_u32 v42, v42, v16, v12
		v_add3_u32 v42, v42, v18, v20
		v_mov_b64_e32 v[56:57], v[144:145]
		v_mov_b64_e32 v[58:59], v[148:149]
		buffer_store_dwordx4 v[56:59], v42, s[8:11], 0 offen
		v_add_u32_e32 v42, 0x90, v10
		v_xor_b32_e32 v42, v42, v15
		v_bitop3_b32 v42, v13, v9, v42 bitop3:0x96
		v_mul_lo_u32 v42, s17, v42
		v_lshlrev_b32_e32 v42, 1, v42
		v_add_u32_e32 v43, s0, v42
		v_add3_u32 v43, v43, v16, v12
		v_add3_u32 v43, v43, v18, v20
		v_mov_b64_e32 v[56:57], v[152:153]
		v_mov_b64_e32 v[58:59], v[156:157]
		buffer_store_dwordx4 v[56:59], v43, s[8:11], 0 offen
		v_add_u32_e32 v43, 0xa0, v10
		v_xor_b32_e32 v43, v43, v15
		v_bitop3_b32 v43, v13, v9, v43 bitop3:0x96
		v_mul_lo_u32 v43, s17, v43
		v_lshlrev_b32_e32 v43, 1, v43
		v_add_u32_e32 v56, s0, v43
		v_add3_u32 v56, v56, v16, v12
		v_add3_u32 v56, v56, v18, v20
		v_mov_b64_e32 v[120:121], v[146:147]
		v_mov_b64_e32 v[122:123], v[150:151]
		buffer_store_dwordx4 v[120:123], v56, s[8:11], 0 offen
		v_add_u32_e32 v56, 0xb0, v10
		v_xor_b32_e32 v56, v56, v15
		v_bitop3_b32 v56, v13, v9, v56 bitop3:0x96
		v_mul_lo_u32 v56, s17, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s0, v56
		v_add3_u32 v57, v57, v16, v12
		v_add3_u32 v57, v57, v18, v20
		v_mov_b64_e32 v[120:121], v[154:155]
		v_mov_b64_e32 v[122:123], v[158:159]
		buffer_store_dwordx4 v[120:123], v57, s[8:11], 0 offen
		v_add_u32_e32 v57, 0xc0, v10
		v_xor_b32_e32 v57, v57, v15
		v_bitop3_b32 v57, v13, v9, v57 bitop3:0x96
		v_mul_lo_u32 v57, s17, v57
		v_lshlrev_b32_e32 v57, 1, v57
		v_add_u32_e32 v58, s0, v57
		v_add3_u32 v58, v58, v16, v12
		v_add3_u32 v58, v58, v18, v20
		v_mov_b64_e32 v[120:121], v[160:161]
		v_mov_b64_e32 v[122:123], v[164:165]
		buffer_store_dwordx4 v[120:123], v58, s[8:11], 0 offen
		v_add_u32_e32 v58, 0xd0, v10
		v_xor_b32_e32 v58, v58, v15
		v_bitop3_b32 v58, v13, v9, v58 bitop3:0x96
		v_mul_lo_u32 v58, s17, v58
		v_lshlrev_b32_e32 v58, 1, v58
		v_add_u32_e32 v59, s0, v58
		v_add3_u32 v59, v59, v16, v12
		v_add3_u32 v59, v59, v18, v20
		v_mov_b64_e32 v[120:121], v[168:169]
		v_mov_b64_e32 v[122:123], v[172:173]
		buffer_store_dwordx4 v[120:123], v59, s[8:11], 0 offen
		v_add_u32_e32 v59, 0xe0, v10
		v_xor_b32_e32 v59, v59, v15
		v_bitop3_b32 v59, v13, v9, v59 bitop3:0x96
		v_mul_lo_u32 v59, s17, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add_u32_e32 v120, s0, v59
		v_add3_u32 v120, v120, v16, v12
		v_add3_u32 v120, v120, v18, v20
		v_mov_b64_e32 v[128:129], v[162:163]
		v_mov_b64_e32 v[130:131], v[166:167]
		buffer_store_dwordx4 v[128:131], v120, s[8:11], 0 offen
		v_add_u32_e32 v10, 0xf0, v10
		v_xor_b32_e32 v10, v10, v15
		v_bitop3_b32 v9, v13, v9, v10 bitop3:0x96
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v10, s0, v9
		v_add3_u32 v10, v10, v16, v12
		v_add3_u32 v10, v10, v18, v20
		v_mov_b64_e32 v[120:121], v[170:171]
		v_mov_b64_e32 v[122:123], v[174:175]
		buffer_store_dwordx4 v[120:123], v10, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[60:63], v[24:27], a[108:111], v240, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[104:107], v[24:27], a[112:115], v240, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[32:35], a[128:131], v240, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], v[32:35], a[124:127], v240, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[28:31], a[108:111], v240, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[28:31], a[112:115], v240, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[36:39], a[128:131], v240, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[36:39], a[124:127], v240, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[24:27], a[116:119], v241, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[124:127], v[24:27], a[120:123], v241, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[124:127], v[32:35], a[136:139], v241, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[32:35], a[132:135], v241, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[116:119], v[28:31], a[116:119], v241, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[244:247], v[28:31], a[120:123], v241, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[244:247], v[36:39], a[136:139], v241, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[116:119], v[36:39], a[132:135], v241, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[44:47], a[148:151], v241, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[124:127], v[44:47], a[152:155], v241, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[124:127], v[52:55], a[168:171], v241, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[52:55], a[164:167], v241, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[116:119], v[48:51], a[148:151], v241, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[244:247], v[48:51], a[152:155], v241, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[244:247], v[64:67], a[168:171], v241, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[64:67], a[164:167], v241, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], v[44:47], a[140:143], v240, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[44:47], a[144:147], v240, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[52:55], a[160:163], v240, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], v[52:55], a[156:159], v240, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[48:51], a[140:143], v240, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[48:51], a[144:147], v240, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[64:67], a[160:163], v240, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[64:67], a[156:159], v240, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], v[68:71], a[172:175], v240, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[68:71], a[176:179], v240, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[76:79], a[192:195], v240, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[60:63], v[76:79], a[188:191], v240, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[72:75], a[172:175], v240, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[72:75], a[176:179], v240, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[80:83], a[192:195], v240, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[80:83], a[188:191], v240, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[68:71], a[180:183], v241, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[124:127], v[68:71], a[184:187], v241, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[76:79], a[200:203], v241, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[76:79], a[196:199], v241, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[72:75], a[180:183], v241, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[244:247], v[72:75], a[184:187], v241, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[244:247], v[80:83], a[200:203], v241, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[116:119], v[80:83], a[196:199], v241, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[84:87], a[212:215], v241, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[84:87], a[216:219], v241, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[92:95], a[232:235], v241, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[92:95], a[228:231], v241, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[116:119], v[88:91], a[212:215], v241, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[244:247], v[88:91], a[216:219], v241, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[244:247], v[96:99], a[232:235], v241, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[116:119], v[96:99], a[228:231], v241, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], v[84:87], a[204:207], v240, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[84:87], a[208:211], v240, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[104:107], v[92:95], a[224:227], v240, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[60:63], v[92:95], a[220:223], v240, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[88:91], a[204:207], v240, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[88:91], a[208:211], v240, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[108:111], v[96:99], a[224:227], v240, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[96:99], a[220:223], v240, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v10, a108
		v_accvgpr_read_b32 v13, a109
		v_cvt_pk_bf16_f32 v24, v10, v13
		v_accvgpr_read_b32 v10, a110
		v_accvgpr_read_b32 v13, a111
		v_cvt_pk_bf16_f32 v25, v10, v13
		v_accvgpr_read_b32 v10, a112
		v_accvgpr_read_b32 v13, a113
		v_cvt_pk_bf16_f32 v28, v10, v13
		v_accvgpr_read_b32 v10, a114
		v_accvgpr_read_b32 v13, a115
		v_cvt_pk_bf16_f32 v29, v10, v13
		v_accvgpr_read_b32 v10, a116
		v_accvgpr_read_b32 v13, a117
		v_cvt_pk_bf16_f32 v32, v10, v13
		v_accvgpr_read_b32 v10, a118
		v_accvgpr_read_b32 v13, a119
		v_cvt_pk_bf16_f32 v33, v10, v13
		v_accvgpr_read_b32 v10, a120
		v_accvgpr_read_b32 v13, a121
		v_cvt_pk_bf16_f32 v36, v10, v13
		v_accvgpr_read_b32 v10, a122
		v_accvgpr_read_b32 v13, a123
		v_cvt_pk_bf16_f32 v37, v10, v13
		v_accvgpr_read_b32 v10, a124
		v_accvgpr_read_b32 v13, a125
		v_cvt_pk_bf16_f32 v26, v10, v13
		v_accvgpr_read_b32 v10, a126
		v_accvgpr_read_b32 v13, a127
		v_cvt_pk_bf16_f32 v27, v10, v13
		ds_write_b128 v0, v[24:27]
		v_accvgpr_read_b32 v10, a128
		v_accvgpr_read_b32 v13, a129
		v_cvt_pk_bf16_f32 v30, v10, v13
		v_accvgpr_read_b32 v10, a130
		v_accvgpr_read_b32 v13, a131
		v_cvt_pk_bf16_f32 v31, v10, v13
		ds_write_b128 v0, v[28:31] offset:4096
		v_accvgpr_read_b32 v10, a132
		v_accvgpr_read_b32 v13, a133
		v_cvt_pk_bf16_f32 v34, v10, v13
		v_accvgpr_read_b32 v10, a134
		v_accvgpr_read_b32 v13, a135
		v_cvt_pk_bf16_f32 v35, v10, v13
		ds_write_b128 v0, v[32:35] offset:8192
		v_accvgpr_read_b32 v10, a136
		v_accvgpr_read_b32 v13, a137
		v_cvt_pk_bf16_f32 v38, v10, v13
		v_accvgpr_read_b32 v10, a138
		v_accvgpr_read_b32 v13, a139
		v_cvt_pk_bf16_f32 v39, v10, v13
		ds_write_b128 v0, v[36:39] offset:12288
		v_accvgpr_read_b32 v10, a140
		v_accvgpr_read_b32 v13, a141
		v_cvt_pk_bf16_f32 v24, v10, v13
		v_accvgpr_read_b32 v10, a142
		v_accvgpr_read_b32 v13, a143
		v_cvt_pk_bf16_f32 v25, v10, v13
		v_accvgpr_read_b32 v10, a144
		v_accvgpr_read_b32 v13, a145
		v_cvt_pk_bf16_f32 v28, v10, v13
		v_accvgpr_read_b32 v10, a146
		v_accvgpr_read_b32 v13, a147
		v_cvt_pk_bf16_f32 v29, v10, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a148
		v_accvgpr_read_b32 v13, a149
		v_cvt_pk_bf16_f32 v32, v10, v13
		v_accvgpr_read_b32 v10, a150
		v_accvgpr_read_b32 v13, a151
		v_cvt_pk_bf16_f32 v33, v10, v13
		v_accvgpr_read_b32 v10, a152
		v_accvgpr_read_b32 v13, a153
		v_cvt_pk_bf16_f32 v36, v10, v13
		v_accvgpr_read_b32 v10, a154
		v_accvgpr_read_b32 v13, a155
		v_cvt_pk_bf16_f32 v37, v10, v13
		v_accvgpr_read_b32 v10, a156
		v_accvgpr_read_b32 v13, a157
		v_cvt_pk_bf16_f32 v26, v10, v13
		v_accvgpr_read_b32 v10, a158
		v_accvgpr_read_b32 v13, a159
		v_cvt_pk_bf16_f32 v27, v10, v13
		v_accvgpr_read_b32 v10, a160
		v_accvgpr_read_b32 v13, a161
		v_cvt_pk_bf16_f32 v30, v10, v13
		v_accvgpr_read_b32 v10, a162
		v_accvgpr_read_b32 v13, a163
		v_cvt_pk_bf16_f32 v31, v10, v13
		v_accvgpr_read_b32 v10, a164
		v_accvgpr_read_b32 v13, a165
		v_cvt_pk_bf16_f32 v34, v10, v13
		v_accvgpr_read_b32 v10, a166
		v_accvgpr_read_b32 v13, a167
		v_cvt_pk_bf16_f32 v35, v10, v13
		v_accvgpr_read_b32 v10, a168
		v_accvgpr_read_b32 v13, a169
		v_cvt_pk_bf16_f32 v38, v10, v13
		v_accvgpr_read_b32 v10, a170
		v_accvgpr_read_b32 v13, a171
		v_cvt_pk_bf16_f32 v39, v10, v13
		v_accvgpr_read_b32 v10, a172
		v_accvgpr_read_b32 v13, a173
		v_cvt_pk_bf16_f32 v44, v10, v13
		v_accvgpr_read_b32 v10, a174
		v_accvgpr_read_b32 v13, a175
		v_cvt_pk_bf16_f32 v45, v10, v13
		v_accvgpr_read_b32 v10, a176
		v_accvgpr_read_b32 v13, a177
		v_cvt_pk_bf16_f32 v48, v10, v13
		v_accvgpr_read_b32 v10, a178
		v_accvgpr_read_b32 v13, a179
		v_cvt_pk_bf16_f32 v49, v10, v13
		v_accvgpr_read_b32 v10, a180
		v_accvgpr_read_b32 v13, a181
		v_cvt_pk_bf16_f32 v52, v10, v13
		v_accvgpr_read_b32 v10, a182
		v_accvgpr_read_b32 v13, a183
		v_cvt_pk_bf16_f32 v53, v10, v13
		v_accvgpr_read_b32 v10, a184
		v_accvgpr_read_b32 v13, a185
		v_cvt_pk_bf16_f32 v60, v10, v13
		v_accvgpr_read_b32 v10, a186
		v_accvgpr_read_b32 v13, a187
		v_cvt_pk_bf16_f32 v61, v10, v13
		v_accvgpr_read_b32 v10, a188
		v_accvgpr_read_b32 v13, a189
		v_cvt_pk_bf16_f32 v46, v10, v13
		v_accvgpr_read_b32 v10, a190
		v_accvgpr_read_b32 v13, a191
		v_cvt_pk_bf16_f32 v47, v10, v13
		v_accvgpr_read_b32 v10, a192
		v_accvgpr_read_b32 v13, a193
		v_cvt_pk_bf16_f32 v50, v10, v13
		v_accvgpr_read_b32 v10, a194
		v_accvgpr_read_b32 v13, a195
		v_cvt_pk_bf16_f32 v51, v10, v13
		v_accvgpr_read_b32 v10, a196
		v_accvgpr_read_b32 v13, a197
		v_cvt_pk_bf16_f32 v54, v10, v13
		v_accvgpr_read_b32 v10, a198
		v_accvgpr_read_b32 v13, a199
		v_cvt_pk_bf16_f32 v55, v10, v13
		v_accvgpr_read_b32 v10, a200
		v_accvgpr_read_b32 v13, a201
		v_cvt_pk_bf16_f32 v62, v10, v13
		v_accvgpr_read_b32 v10, a202
		v_accvgpr_read_b32 v13, a203
		v_cvt_pk_bf16_f32 v63, v10, v13
		v_accvgpr_read_b32 v10, a204
		v_accvgpr_read_b32 v13, a205
		v_cvt_pk_bf16_f32 v64, v10, v13
		v_accvgpr_read_b32 v10, a206
		v_accvgpr_read_b32 v13, a207
		v_cvt_pk_bf16_f32 v65, v10, v13
		v_accvgpr_read_b32 v10, a208
		v_accvgpr_read_b32 v13, a209
		v_cvt_pk_bf16_f32 v68, v10, v13
		v_accvgpr_read_b32 v10, a210
		v_accvgpr_read_b32 v13, a211
		v_cvt_pk_bf16_f32 v69, v10, v13
		v_accvgpr_read_b32 v10, a212
		v_accvgpr_read_b32 v13, a213
		v_cvt_pk_bf16_f32 v72, v10, v13
		v_accvgpr_read_b32 v10, a214
		v_accvgpr_read_b32 v13, a215
		v_cvt_pk_bf16_f32 v73, v10, v13
		v_accvgpr_read_b32 v10, a216
		v_accvgpr_read_b32 v13, a217
		v_cvt_pk_bf16_f32 v76, v10, v13
		v_accvgpr_read_b32 v10, a218
		v_accvgpr_read_b32 v13, a219
		v_cvt_pk_bf16_f32 v77, v10, v13
		v_accvgpr_read_b32 v10, a220
		v_accvgpr_read_b32 v13, a221
		v_cvt_pk_bf16_f32 v66, v10, v13
		v_accvgpr_read_b32 v10, a222
		v_accvgpr_read_b32 v13, a223
		v_cvt_pk_bf16_f32 v67, v10, v13
		v_accvgpr_read_b32 v10, a224
		v_accvgpr_read_b32 v13, a225
		v_cvt_pk_bf16_f32 v70, v10, v13
		v_accvgpr_read_b32 v10, a226
		v_accvgpr_read_b32 v13, a227
		v_cvt_pk_bf16_f32 v71, v10, v13
		v_accvgpr_read_b32 v10, a228
		v_accvgpr_read_b32 v13, a229
		v_cvt_pk_bf16_f32 v74, v10, v13
		v_accvgpr_read_b32 v10, a230
		v_accvgpr_read_b32 v13, a231
		v_cvt_pk_bf16_f32 v75, v10, v13
		v_accvgpr_read_b32 v10, a232
		v_accvgpr_read_b32 v13, a233
		v_cvt_pk_bf16_f32 v78, v10, v13
		v_accvgpr_read_b32 v10, a234
		v_accvgpr_read_b32 v13, a235
		v_cvt_pk_bf16_f32 v79, v10, v13
		ds_read_b128 v[80:83], v2
		ds_read_b128 v[84:87], v2 offset:256
		ds_read_b128 v[88:91], v2 offset:2048
		ds_read_b128 v[92:95], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[24:27]
		ds_write_b128 v0, v[28:31] offset:4096
		ds_write_b128 v0, v[32:35] offset:8192
		ds_write_b128 v0, v[36:39] offset:12288
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v8, v17
		v_add3_u32 v1, v1, v16, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[44:47]
		ds_write_b128 v0, v[48:51] offset:4096
		ds_write_b128 v0, v[52:55] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_add3_u32 v1, v1, v18, v20
		v_mov_b64_e32 v[44:45], v[80:81]
		v_mov_b64_e32 v[46:47], v[84:85]
		buffer_store_dwordx4 v[44:47], v1, s[8:11], 0 offen
		v_add3_u32 v1, v16, v12, v18
		v_add_u32_e32 v1, v1, v20
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v2
		ds_read_b128 v[48:51], v2 offset:256
		ds_read_b128 v[52:55], v2 offset:2048
		ds_read_b128 v[60:63], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[64:67]
		ds_write_b128 v0, v[68:71] offset:4096
		ds_write_b128 v0, v[72:75] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		v_add3_u32 v0, v4, v1, s0
		v_mov_b64_e32 v[64:65], v[88:89]
		v_mov_b64_e32 v[66:67], v[92:93]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		v_add3_u32 v0, v5, v1, s0
		s_nop 0
		v_mov_b64_e32 v[64:65], v[82:83]
		v_mov_b64_e32 v[66:67], v[86:87]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v2
		ds_read_b128 v[68:71], v2 offset:256
		ds_read_b128 v[72:75], v2 offset:2048
		ds_read_b128 v[76:79], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v0, v6, v1, s0
		v_mov_b64_e32 v[80:81], v[90:91]
		v_mov_b64_e32 v[82:83], v[94:95]
		buffer_store_dwordx4 v[80:83], v0, s[8:11], 0 offen
		v_add3_u32 v0, v16, v12, v18
		v_add_u32_e32 v0, v0, v20
		v_add3_u32 v1, v7, v0, s0
		v_mov_b64_e32 v[4:5], v[24:25]
		v_mov_b64_e32 v[6:7], v[28:29]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v11, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[32:33]
		v_mov_b64_e32 v[6:7], v[36:37]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v0, v14, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[26:27]
		v_mov_b64_e32 v[6:7], v[30:31]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		v_add3_u32 v0, v16, v12, v18
		v_add_u32_e32 v0, v0, v20
		v_add3_u32 v1, v19, v0, s0
		v_mov_b64_e32 v[4:5], v[34:35]
		v_mov_b64_e32 v[6:7], v[38:39]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v21, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[44:45]
		v_mov_b64_e32 v[6:7], v[48:49]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v0, v42, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[52:53]
		v_mov_b64_e32 v[6:7], v[60:61]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		v_add3_u32 v0, v16, v12, v18
		v_add_u32_e32 v0, v0, v20
		v_add3_u32 v1, v43, v0, s0
		v_mov_b64_e32 v[4:5], v[46:47]
		v_mov_b64_e32 v[6:7], v[50:51]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v56, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[54:55]
		v_mov_b64_e32 v[6:7], v[62:63]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v0, v57, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[64:65]
		v_mov_b64_e32 v[6:7], v[68:69]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		v_add3_u32 v0, v16, v12, v18
		v_add_u32_e32 v0, v0, v20
		v_add3_u32 v1, v58, v0, s0
		v_mov_b64_e32 v[4:5], v[72:73]
		v_mov_b64_e32 v[6:7], v[76:77]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v59, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[66:67]
		v_mov_b64_e32 v[6:7], v[70:71]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v0, v9, v0, s0
		s_nop 0
		v_mov_b64_e32 v[4:5], v[74:75]
		v_mov_b64_e32 v[6:7], v[78:79]
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
