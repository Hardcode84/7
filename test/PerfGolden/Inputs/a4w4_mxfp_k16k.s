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
		s_cmp_lt_i32 s12, 8
		s_cbranch_scc0 .L_a4w4_kernel.if_else_0
		s_mul_i32 s12, s12, 32
		s_add_i32 s16, s12, s13
		s_branch .L_a4w4_kernel.if_end_0
.L_a4w4_kernel.if_else_0:
		s_add_i32 s12, s12, -8
		s_mul_i32 s12, s12, 31
		s_add_i32 s12, s12, 0x100
		s_add_i32 s16, s12, s13
.L_a4w4_kernel.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s12, 1, 0
		s_xor_b32 s13, s16, -1
		s_add_i32 s13, s13, 1
		s_cmp_lg_u32 s12, 0
		s_cselect_b32 s12, s13, s16
		s_cselect_b32 s13, 1, 0
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
		s_mul_hi_u32 s22, s12, s22
		s_mul_i32 s23, s22, s20
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s12, s12, s23
		s_cmp_ge_u32 s12, s20
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s12, s21
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s12, s24, s12
		s_cmp_ge_u32 s12, s20
		s_cselect_b32 s20, 1, 0
		s_add_i32 s23, s22, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s23, s22
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s1, s16, s1
		s_xor_b32 s16, s20, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s16, s20
		s_mul_i32 s16, s1, 4
		s_xor_b32 s20, s16, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s0, s0, s20
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s20, s12, s21
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s12, s20, s12
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s12, s20, s12
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s20, s12, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s20, s12
		s_cselect_b32 s20, 1, 0
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s0
		v_mov_b32_e32 v1, s21
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s22, s21, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s22, s22, 1
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s23, s23, s21
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s13, s23
		s_add_i32 s24, s23, s22
		s_cmp_ge_u32 s23, s21
		s_cselect_b32 s23, s24, s23
		s_add_i32 s24, s23, s22
		s_cmp_ge_u32 s23, s21
		s_cselect_b32 s23, s24, s23
		s_xor_b32 s24, s23, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s24, s23
		s_add_i32 s16, s16, s20
		s_mul_i32 s16, s16, 0x100
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s24, s23, s21
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s13, s13, s24
		s_cmp_ge_u32 s13, s21
		s_cselect_b32 s24, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s24, 1, 0
		s_add_i32 s22, s13, s22
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s13, s22, s13
		s_add_i32 s22, s23, 1
		s_cmp_ge_u32 s13, s21
		s_cselect_b32 s13, s22, s23
		s_xor_b32 s0, s12, s0
		s_xor_b32 s12, s13, -1
		s_add_i32 s12, s12, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s12, s13
		s_mul_i32 s12, s16, s14
		s_mul_i32 s13, s0, 0x100
		s_add_u32 s24, s2, s12
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s21, v0
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_mul_lo_u32 v1, s14, v1
		v_lshrrev_b32_e32 v2, 5, v0
		v_and_b32_e32 v3, 1, v2
		v_accvgpr_write_b32 a1, v3
		v_accvgpr_read_b32 v3, a1
		v_mul_lo_u32 v3, s14, v3
		v_lshl_add_u32 v1, v3, 6, v1
		v_lshrrev_b32_e32 v3, 4, v0
		v_accvgpr_write_b32 a2, v3
		v_accvgpr_read_b32 v3, a2
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v4, s14, v3
		v_lshl_add_u32 v1, v4, 5, v1
		v_lshrrev_b32_e32 v4, 3, v0
		v_and_b32_e32 v4, 1, v4
		v_mul_lo_u32 v5, s14, v4
		v_lshlrev_b32_e32 v5, 4, v5
		v_and_b32_e32 v6, 7, v0
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v1, v1, v5, v6
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s22, 0
		s_mov_b32 s23, 0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s28, s14, 2
		v_add_u32_e32 v5, s28, v1
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mov_b32 s30, -1
		s_mov_b32 s31, -1
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s29, s14, 3
		v_add_u32_e32 v7, s29, v1
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_mul_i32 s13, s13, s15
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s32, 12, s14
		v_add_u32_e32 v8, s32, v1
		v_mul_lo_u32 v3, s15, v3
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s34, s14, 7
		v_add_u32_e32 v9, s34, v1
		v_mul_lo_u32 v4, s15, v4
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v4, 4, v4
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s35, 0x84, s14
		v_add_u32_e32 v10, s35, v1
		s_mul_i32 s36, 0x88, s14
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v11, a1
		v_mul_lo_u32 v11, s15, v11
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v12, s36, v1
		s_mul_i32 s14, 0x8c, s14
		s_mul_i32 s37, 12, s15
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v13, a0
		v_mul_lo_u32 v13, s15, v13
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v14, s14, v1
		v_lshl_add_u32 v11, v11, 6, v13
		v_lshl_add_u32 v3, v3, 5, v11
		v_add3_u32 v3, v3, v4, v6
		s_mul_i32 s38, 0x84, s15
		s_mul_i32 s39, 0x88, s15
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_u32 s40, s4, s13
		s_addc_u32 s41, s5, 0
		s_add_i32 m0, m0, 0x9460
		s_lshl_b32 s44, s15, 2
		s_mul_i32 s45, 0x8c, s15
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s46, s19, 16
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v4, s44, v3
		s_lshl_b32 s47, s15, 3
		s_mul_i32 s48, s18, 16
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		s_mov_b32 s49, 0xc0c0c01
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v6, s47, v3
		s_mov_b32 s50, 0xc0c0c02
		s_mov_b32 s51, 0xc0c0c03
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		v_add_u32_e32 v11, s37, v3
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s52, s1, s20
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		v_mul_lo_u32 v13, s18, v2
		v_and_b32_e32 v15, 31, v0
		v_lshlrev_b32_e32 v16, 3, v15
		v_add3_u32 v17, s52, v13, v16
		s_mov_b32 s56, s8
		s_mov_b32 s57, s9
		s_mov_b32 s58, s26
		s_mov_b32 s59, s27
		buffer_load_ubyte v18, v17, s[56:59], 0 offen
		s_add_i32 s53, s1, 1
		s_add_i32 s53, s53, s20
		v_add3_u32 v19, s53, v13, v16
		buffer_load_ubyte v20, v19, s[56:59], 0 offen
		s_add_i32 s54, s1, 2
		s_add_i32 s54, s54, s20
		v_add3_u32 v21, s54, v13, v16
		buffer_load_ubyte v22, v21, s[56:59], 0 offen
		s_add_i32 s55, s1, 3
		s_add_i32 s55, s55, s20
		v_add3_u32 v23, s55, v13, v16
		buffer_load_ubyte v24, v23, s[56:59], 0 offen
		s_add_i32 s60, s1, 4
		s_add_i32 s60, s60, s20
		v_add3_u32 v25, s60, v13, v16
		buffer_load_ubyte v26, v25, s[56:59], 0 offen
		s_add_i32 s61, s1, 5
		s_add_i32 s61, s61, s20
		v_add3_u32 v27, s61, v13, v16
		buffer_load_ubyte v28, v27, s[56:59], 0 offen
		s_add_i32 s62, s1, 6
		s_add_i32 s62, s62, s20
		v_add3_u32 v29, s62, v13, v16
		buffer_load_ubyte v30, v29, s[56:59], 0 offen
		s_add_i32 s1, s1, 7
		s_add_i32 s1, s1, s20
		v_add3_u32 v31, s1, v13, v16
		buffer_load_ubyte v32, v31, s[56:59], 0 offen
		s_lshl_b32 s20, s0, 8
		v_mul_lo_u32 v2, s19, v2
		v_lshlrev_b32_e32 v15, 2, v15
		v_add3_u32 v33, s20, v2, v15
		s_mov_b32 s64, s10
		s_mov_b32 s65, s11
		s_mov_b32 s66, s26
		s_mov_b32 s67, s27
		buffer_load_ubyte v34, v33, s[64:67], 0 offen
		s_add_i32 s63, s20, 1
		v_add3_u32 v35, s63, v2, v15
		buffer_load_ubyte v36, v35, s[64:67], 0 offen
		s_add_i32 s68, s20, 2
		v_add3_u32 v37, s68, v2, v15
		buffer_load_ubyte v38, v37, s[64:67], 0 offen
		s_add_i32 s69, s20, 3
		v_add3_u32 v39, s69, v2, v15
		buffer_load_ubyte v40, v39, s[64:67], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_lshl_b32 s15, s15, 7
		v_add_u32_e32 v41, s15, v3
		buffer_load_dwordx4 v41, s[40:43], 0 offen lds
		v_add_u32_e32 v42, s38, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v43, s39, v3
		v_add_u32_e32 v44, s45, v3
		v_add_u32_e32 v45, 0x80, v1
		buffer_load_dwordx4 v42, s[40:43], 0 offen lds
		v_add_u32_e32 v46, 0x80, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v47, s29, v46
		v_add_u32_e32 v48, s32, v46
		v_add_u32_e32 v46, s34, v46
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		v_add_u32_e32 v49, 0x80, v1
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s29, s20, 0x80
		s_add_i32 s32, s20, 0x81
		s_add_i32 s34, s20, 0x82
		buffer_load_dwordx4 v44, s[40:43], 0 offen lds
		v_add3_u32 v50, s29, v2, v15
		buffer_load_ubyte_d16 v51, v50, s[64:67], 0 offen
		v_add3_u32 v52, s32, v2, v15
		buffer_load_ubyte_d16 v53, v52, s[64:67], 0 offen
		v_add3_u32 v54, s34, v2, v15
		v_mov_b32_e32 v55, 0
		buffer_load_ubyte_d16_hi v55, v54, s[64:67], 0 offen
		s_add_i32 s70, s20, 0x83
		v_add3_u32 v56, s70, v2, v15
		v_mov_b32_e32 v57, 0
		buffer_load_ubyte_d16_hi v57, v56, s[64:67], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s28, s28, 0x80
		buffer_load_dwordx4 v45, s[24:27], 0 offen lds
		v_add_u32_e32 v58, s28, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v59, s35, v49
		v_add_u32_e32 v60, s36, v49
		v_add_u32_e32 v49, s14, v49
		buffer_load_dwordx4 v58, s[24:27], 0 offen lds
		v_add_u32_e32 v61, 0x80, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v62, 0x80, v3
		v_add_u32_e32 v63, s44, v62
		v_add_u32_e32 v64, s47, v62
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		v_add_u32_e32 v62, s37, v62
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v65, 0x80, v3
		v_add_u32_e32 v66, s38, v65
		v_add_u32_e32 v67, s39, v65
		buffer_load_dwordx4 v48, s[24:27], 0 offen lds
		v_add_u32_e32 v65, s45, v65
		s_add_i32 m0, m0, 0x1080
		v_lshrrev_b32_e32 v68, 7, v0
		v_lshlrev_b32_e32 v68, 7, v68
		v_and_b32_e32 v69, 63, v0
		buffer_load_dwordx4 v46, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v70, 4, v69
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s13, 0x100
		v_lshlrev_b32_e32 v71, 4, v70
		v_and_b32_e32 v72, 15, v69
		buffer_load_dwordx4 v59, s[24:27], 0 offen lds
		v_mov_b32_e32 v73, 0x420
		v_mul_lo_u32 v73, v73, v72
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s12, 0x100
		v_add3_u32 v68, v68, v71, v73
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		v_add_u32_e32 v71, 0x10000, v71
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s12, s15, 0x80
		v_add_u32_e32 v74, s12, v3
		v_accvgpr_read_b32 v75, a0
		v_and_b32_e32 v75, 1, v75
		v_accvgpr_write_b32 a3, v75
		v_accvgpr_read_b32 v75, a3
		v_lshlrev_b32_e32 v75, 7, v75
		v_add3_u32 v71, v71, v75, v73
		v_lshlrev_b32_e32 v73, 3, v0
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		v_add_u32_e32 v73, 0x20000, v73
		s_add_i32 m0, m0, 0x5260
		v_lshlrev_b32_e32 v75, 2, v0
		v_add_u32_e32 v75, 0x20000, v75
		v_lshrrev_b32_e32 v76, 1, v72
		buffer_load_dwordx4 v61, s[40:43], 0 offen lds
		v_add_u32_e32 v77, v0, v76
		s_add_i32 m0, m0, 0x1080
		v_mad_i32_i24 v72, -1, v72, v77
		s_lshl_b32 s12, s19, 3
		v_and_b32_e32 v76, 1, v76
		buffer_load_dwordx4 v63, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v76, 3, v76
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s15, s18, 3
		v_ashrrev_i32_e32 v77, 7, v72
		v_and_b32_e32 v77, 1, v77
		buffer_load_dwordx4 v64, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v77, 4, v77
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s18, s52, s15
		s_add_i32 s19, s53, s15
		s_add_i32 s24, s54, s15
		buffer_load_dwordx4 v62, s[40:43], 0 offen lds
		v_add3_u32 v78, s18, v13, v16
		buffer_load_ubyte_d16 v79, v78, s[56:59], 0 offen
		v_add3_u32 v80, s19, v13, v16
		buffer_load_ubyte_d16 v81, v80, s[56:59], 0 offen
		v_add3_u32 v82, s24, v13, v16
		v_mov_b32_e32 v83, 0
		buffer_load_ubyte_d16_hi v83, v82, s[56:59], 0 offen
		s_add_i32 s18, s55, s15
		v_add3_u32 v84, s18, v13, v16
		v_mov_b32_e32 v85, 0
		buffer_load_ubyte_d16_hi v85, v84, s[56:59], 0 offen
		s_add_i32 s18, s60, s15
		v_add3_u32 v86, s18, v13, v16
		buffer_load_ubyte_d16 v87, v86, s[56:59], 0 offen
		s_add_i32 s18, s61, s15
		v_add3_u32 v88, s18, v13, v16
		buffer_load_ubyte_d16 v89, v88, s[56:59], 0 offen
		s_add_i32 s18, s62, s15
		v_add3_u32 v90, s18, v13, v16
		v_mov_b32_e32 v91, 0
		buffer_load_ubyte_d16_hi v91, v90, s[56:59], 0 offen
		s_add_i32 s1, s1, s15
		v_add3_u32 v13, s1, v13, v16
		v_mov_b32_e32 v16, 0
		buffer_load_ubyte_d16_hi v16, v13, s[56:59], 0 offen
		s_add_i32 s1, s20, s12
		v_add3_u32 v92, s1, v2, v15
		buffer_load_ubyte_d16 v93, v92, s[64:67], 0 offen
		s_add_i32 s1, s63, s12
		v_add3_u32 v94, s1, v2, v15
		buffer_load_ubyte_d16 v95, v94, s[64:67], 0 offen
		s_add_i32 s1, s68, s12
		v_add3_u32 v96, s1, v2, v15
		v_mov_b32_e32 v97, 0
		buffer_load_ubyte_d16_hi v97, v96, s[64:67], 0 offen
		s_add_i32 s1, s69, s12
		v_add3_u32 v98, s1, v2, v15
		v_mov_b32_e32 v99, 0
		buffer_load_ubyte_d16_hi v99, v98, s[64:67], 0 offen
		s_add_i32 m0, m0, 0x5260
		v_add_u32_e32 v77, 0x20000, v77
		buffer_load_dwordx4 v74, s[40:43], 0 offen lds
		v_ashrrev_i32_e32 v100, 5, v72
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s32, s12
		v_and_b32_e32 v100, 1, v100
		v_lshl_add_u32 v77, v100, 9, v77
		buffer_load_dwordx4 v66, s[40:43], 0 offen lds
		v_add3_u32 v101, s1, v2, v15
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s29, s12
		v_add3_u32 v102, s1, v2, v15
		v_ashrrev_i32_e32 v103, 4, v72
		buffer_load_dwordx4 v67, s[40:43], 0 offen lds
		v_and_b32_e32 v103, 1, v103
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s34, s12
		s_add_i32 s12, s70, s12
		v_lshl_add_u32 v77, v103, 8, v77
		buffer_load_dwordx4 v65, s[40:43], 0 offen lds
		buffer_load_ubyte_d16 v104, v102, s[64:67], 0 offen
		buffer_load_ubyte_d16 v105, v101, s[64:67], 0 offen
		v_add3_u32 v106, s1, v2, v15
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v106, s[64:67], 0 offen
		v_add3_u32 v2, s12, v2, v15
		v_mov_b32_e32 v15, 0
		buffer_load_ubyte_d16_hi v15, v2, s[64:67], 0 offen
		s_waitcnt vmcnt(52)
		s_barrier
		ds_read_b128 a[4:7], v68
		ds_read_b128 a[8:11], v68 offset:64
		ds_read_b128 a[12:15], v68 offset:256
		ds_read_b128 a[16:19], v68 offset:320
		ds_read_b128 a[20:23], v68 offset:512
		ds_read_b128 a[24:27], v68 offset:576
		ds_read_b128 a[28:31], v68 offset:768
		ds_read_b128 a[32:35], v68 offset:832
		ds_read_b128 a[36:39], v68 offset:16896
		ds_read_b128 a[40:43], v68 offset:16960
		ds_read_b128 a[44:47], v68 offset:17152
		ds_read_b128 a[48:51], v68 offset:17216
		ds_read_b128 a[52:55], v68 offset:17408
		ds_read_b128 a[56:59], v68 offset:17472
		ds_read_b128 a[60:63], v68 offset:17664
		ds_read_b128 a[64:67], v68 offset:17728
		ds_read_b128 a[68:71], v71 offset:2016
		ds_read_b128 a[72:75], v71 offset:2080
		ds_read_b128 a[76:79], v71 offset:2272
		ds_read_b128 a[80:83], v71 offset:2336
		ds_read_b128 a[84:87], v71 offset:2528
		ds_read_b128 a[88:91], v71 offset:2592
		ds_read_b128 a[92:95], v71 offset:2784
		ds_read_b128 a[96:99], v71 offset:2848
		s_waitcnt vmcnt(51)
		ds_write_b8 v73, v18 offset:4000
		s_waitcnt vmcnt(50)
		ds_write_b8 v73, v20 offset:4001
		s_waitcnt vmcnt(49)
		ds_write_b8 v73, v22 offset:4002
		s_waitcnt vmcnt(48)
		ds_write_b8 v73, v24 offset:4003
		s_waitcnt vmcnt(47)
		ds_write_b8 v73, v26 offset:4004
		s_waitcnt vmcnt(46)
		ds_write_b8 v73, v28 offset:4005
		s_waitcnt vmcnt(45)
		ds_write_b8 v73, v30 offset:4006
		s_waitcnt vmcnt(44)
		ds_write_b8 v73, v32 offset:4007
		s_waitcnt vmcnt(43)
		ds_write_b8 v75, v34 offset:6048
		s_waitcnt vmcnt(42)
		ds_write_b8 v75, v36 offset:6049
		s_waitcnt vmcnt(41)
		ds_write_b8 v75, v38 offset:6050
		s_waitcnt vmcnt(40)
		ds_write_b8 v75, v40 offset:6051
		v_ashrrev_i32_e32 v18, 3, v72
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_ashrrev_i32_e32 v20, 2, v72
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v22, v77, v18, v20
		v_ashrrev_i32_e32 v24, 1, v72
		v_and_b32_e32 v24, 1, v24
		v_lshl_add_u32 v22, v24, 10, v22
		v_and_b32_e32 v26, 1, v69
		v_lshlrev_b32_e32 v26, 2, v26
		v_add3_u32 v22, v22, v76, v26
		ds_read_b32 v28, v22 offset:4000
		v_ashrrev_i32_e32 v30, 6, v72
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 4, v30
		v_add_u32_e32 v30, 0x20000, v30
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v32, 0xff, v28
		v_and_b32_e32 v32, 0xff, v32
		v_lshlrev_b32_e32 v34, 8, v32
		v_or_b32_e32 v32, v32, v34
		v_perm_b32 v34, v28, v28, s49
		v_lshlrev_b32_e32 v36, 16, v34
		v_lshlrev_b32_e32 v34, 24, v34
		v_or3_b32 v38, v32, v36, v34
		v_perm_b32 v32, v28, v28, s50
		v_lshlrev_b32_e32 v34, 8, v32
		v_or_b32_e32 v32, v32, v34
		v_perm_b32 v28, v28, v28, s51
		v_lshlrev_b32_e32 v34, 16, v28
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v36, v32, v34, v28
		ds_read_b32 v28, v22 offset:4128
		v_lshl_add_u32 v30, v100, 8, v30
		v_lshl_add_u32 v30, v103, 7, v30
		v_add3_u32 v18, v30, v18, v20
		v_lshl_add_u32 v18, v24, 9, v18
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v20, 0xff, v28
		v_and_b32_e32 v20, 0xff, v20
		v_lshlrev_b32_e32 v24, 8, v20
		v_or_b32_e32 v20, v20, v24
		v_perm_b32 v24, v28, v28, s49
		v_lshlrev_b32_e32 v30, 16, v24
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v32, v20, v30, v24
		v_perm_b32 v20, v28, v28, s50
		v_lshlrev_b32_e32 v24, 8, v20
		v_or_b32_e32 v20, v20, v24
		v_perm_b32 v24, v28, v28, s51
		v_lshlrev_b32_e32 v28, 16, v24
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v30, v20, v28, v24
		v_add3_u32 v18, v18, v76, v26
		ds_read_b32 v20, v18 offset:6048
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v24, 0xff, v20
		v_and_b32_e32 v24, 0xff, v24
		v_lshlrev_b32_e32 v26, 8, v24
		v_or_b32_e32 v24, v24, v26
		v_perm_b32 v26, v20, v20, s49
		v_lshlrev_b32_e32 v28, 16, v26
		v_lshlrev_b32_e32 v26, 24, v26
		v_or3_b32 v34, v24, v28, v26
		v_perm_b32 v24, v20, v20, s50
		v_lshlrev_b32_e32 v26, 8, v24
		v_or_b32_e32 v24, v24, v26
		v_perm_b32 v20, v20, v20, s51
		v_lshlrev_b32_e32 v26, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v28, v24, v26, v20
		s_barrier
		s_and_saveexec_b64 s[80:81], s[22:23]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_0
		s_barrier
.L_a4w4_kernel.exec_endif_0:
		s_mov_b64 exec, s[80:81]
		s_setprio 0
		s_mov_b32 s1, s48
		s_mov_b32 s12, s46
		s_add_u32 s36, s2, s13
		s_addc_u32 s37, s3, 0
		s_add_u32 s40, s4, s14
		s_addc_u32 s41, s5, 0
		s_add_u32 s52, s8, s1
		s_addc_u32 s53, s9, 0
		s_add_u32 s56, s10, s12
		s_addc_u32 s57, s11, 0
		s_mov_b32 s58, s26
		s_mov_b32 s59, s27
		s_mov_b32 s54, s26
		s_mov_b32 s55, s27
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
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
.L_a4w4_kernel.loop_head_0:
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[4:7], v[108:111], v34, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[4:7], v[112:115], v34, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[12:15], v[128:131], v34, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[12:15], v[124:127], v34, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[8:11], v[108:111], v34, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[8:11], v[112:115], v34, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[16:19], v[128:131], v34, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[16:19], v[124:127], v34, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[4:7], v[116:119], v28, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[4:7], v[120:123], v28, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[12:15], v[136:139], v28, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[12:15], v[132:135], v28, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[8:11], v[116:119], v28, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[8:11], v[120:123], v28, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[16:19], v[136:139], v28, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[16:19], v[132:135], v28, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[20:23], v[148:151], v28, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[20:23], v[152:155], v28, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[28:31], v[168:171], v28, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[28:31], v[164:167], v28, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[24:27], v[148:151], v28, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[24:27], v[152:155], v28, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[32:35], v[168:171], v28, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[32:35], v[164:167], v28, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[20:23], v[140:143], v34, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[20:23], v[144:147], v34, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[28:31], v[160:163], v34, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[28:31], v[156:159], v34, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[24:27], v[140:143], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[24:27], v[144:147], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[32:35], v[160:163], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[32:35], v[156:159], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[36:39], v[172:175], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[36:39], v[176:179], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[44:47], v[192:195], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[44:47], v[188:191], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[40:43], v[172:175], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[40:43], v[176:179], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[48:51], v[192:195], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[48:51], v[188:191], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[36:39], v[180:183], v28, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[36:39], v[184:187], v28, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[44:47], v[200:203], v28, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[44:47], v[196:199], v28, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[40:43], v[180:183], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[40:43], v[184:187], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[48:51], v[200:203], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[48:51], v[196:199], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[52:55], v[212:215], v28, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[52:55], v[216:219], v28, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[60:63], v[232:235], v28, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[60:63], v[228:231], v28, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[56:59], v[212:215], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], a[56:59], v[216:219], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[96:99], a[64:67], v[232:235], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[64:67], v[228:231], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[52:55], v[204:207], v34, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[52:55], v[208:211], v34, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[60:63], v[224:227], v34, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[60:63], v[220:223], v34, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[56:59], v[204:207], v34, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[56:59], v[208:211], v34, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[64:67], v[224:227], v34, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[64:67], v[220:223], v34, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(36)
		s_barrier
		s_waitcnt vmcnt(4)
		ds_read_b128 a[68:71], v71 offset:35776
		ds_read_b128 a[72:75], v71 offset:35840
		ds_read_b128 a[76:79], v71 offset:36032
		ds_read_b128 a[80:83], v71 offset:36096
		ds_read_b128 a[84:87], v71 offset:36288
		ds_read_b128 a[88:91], v71 offset:36352
		ds_read_b128 a[92:95], v71 offset:36544
		ds_read_b128 a[96:99], v71 offset:36608
		s_barrier
		v_or_b32_e32 v20, v53, v57
		v_lshlrev_b32_e32 v20, 8, v20
		v_or3_b32 v20, v51, v55, v20
		v_and_b32_e32 v24, 0xff, v20
		ds_write_b8 v75, v24 offset:6048
		v_lshrrev_b32_e32 v24, 8, v20
		v_and_b32_e32 v24, 0xff, v24
		ds_write_b8 v75, v24 offset:6049
		v_lshrrev_b32_e32 v24, 16, v20
		v_and_b32_e32 v24, 0xff, v24
		ds_write_b8 v75, v24 offset:6050
		v_lshrrev_b32_e32 v20, 24, v20
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v75, v20 offset:6051
		s_add_u32 s36, s2, s13
		s_addc_u32 s37, s3, 0
		s_mov_b32 m0, s21
		s_add_u32 s40, s4, s14
		s_addc_u32 s41, s5, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v1, s[36:39], 0 offen lds
		ds_read_b32 v20, v18 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s56, s10, s12
		s_addc_u32 s57, s11, 0
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v24, 0xff, v20
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		v_and_b32_e32 v24, 0xff, v24
		v_lshlrev_b32_e32 v26, 8, v24
		v_or_b32_e32 v24, v24, v26
		v_perm_b32 v26, v20, v20, s49
		v_lshlrev_b32_e32 v28, 16, v26
		v_lshlrev_b32_e32 v26, 24, v26
		v_perm_b32 v34, v20, v20, s50
		v_lshlrev_b32_e32 v40, 8, v34
		v_or_b32_e32 v34, v34, v40
		v_perm_b32 v20, v20, v20, s51
		v_lshlrev_b32_e32 v40, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s52, s8, s1
		s_addc_u32 s53, s9, 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_or3_b32 v24, v24, v28, v26
		s_add_i32 m0, m0, 0x1080
		v_or3_b32 v20, v34, v40, v20
		buffer_load_dwordx4 v8, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_mov_b32_e32 v57, 0
		s_add_i32 m0, m0, 0x9460
		v_mov_b32_e32 v55, 0
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		v_or_b32_e32 v26, v95, v99
		s_add_i32 m0, m0, 0x1080
		v_or_b32_e32 v16, v89, v16
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		v_or_b32_e32 v28, v81, v85
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v26, 8, v26
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v16, 8, v16
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v28, 8, v28
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		buffer_load_ubyte v34, v17, s[52:55], 0 offen
		buffer_load_ubyte v40, v19, s[52:55], 0 offen
		buffer_load_ubyte v72, v21, s[52:55], 0 offen
		buffer_load_ubyte v76, v23, s[52:55], 0 offen
		buffer_load_ubyte v77, v25, s[52:55], 0 offen
		buffer_load_ubyte v100, v27, s[52:55], 0 offen
		buffer_load_ubyte v103, v29, s[52:55], 0 offen
		buffer_load_ubyte v244, v31, s[52:55], 0 offen
		buffer_load_ubyte v245, v33, s[56:59], 0 offen
		buffer_load_ubyte v246, v35, s[56:59], 0 offen
		buffer_load_ubyte v247, v37, s[56:59], 0 offen
		buffer_load_ubyte v248, v39, s[56:59], 0 offen
		s_setprio 0
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[4:7], v[236:239], v24, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[76:79], a[4:7], v[240:243], v24, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[12:15], a[112:115], v24, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[12:15], a[108:111], v24, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[8:11], v[236:239], v24, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[8:11], v[240:243], v24, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[16:19], a[112:115], v24, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[16:19], a[108:111], v24, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[4:7], a[100:103], v20, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[4:7], a[104:107], v20, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[12:15], a[120:123], v20, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[12:15], a[116:119], v20, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[88:91], a[8:11], a[100:103], v20, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[8:11], a[104:107], v20, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[16:19], a[120:123], v20, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[16:19], a[116:119], v20, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[20:23], a[132:135], v20, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[20:23], a[136:139], v20, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[28:31], a[152:155], v20, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[28:31], a[148:151], v20, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[24:27], a[132:135], v20, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[24:27], a[136:139], v20, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[32:35], a[152:155], v20, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[32:35], a[148:151], v20, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[20:23], a[124:127], v24, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[20:23], a[128:131], v24, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[28:31], a[144:147], v24, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[28:31], a[140:143], v24, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[24:27], a[124:127], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[24:27], a[128:131], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[32:35], a[144:147], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[32:35], a[140:143], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[36:39], a[156:159], v24, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[36:39], a[160:163], v24, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[44:47], a[176:179], v24, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[44:47], a[172:175], v24, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[40:43], a[156:159], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[40:43], a[160:163], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[48:51], a[176:179], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[48:51], a[172:175], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[36:39], a[164:167], v20, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[36:39], a[168:171], v20, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[44:47], a[184:187], v20, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[44:47], a[180:183], v20, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[40:43], a[164:167], v20, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[40:43], a[168:171], v20, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[96:99], a[48:51], a[184:187], v20, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[48:51], a[180:183], v20, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[52:55], a[196:199], v20, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[52:55], a[200:203], v20, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[60:63], a[216:219], v20, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[60:63], a[212:215], v20, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[56:59], a[196:199], v20, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[96:99], a[56:59], a[200:203], v20, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[96:99], a[64:67], a[216:219], v20, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[64:67], a[212:215], v20, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[52:55], a[188:191], v24, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[52:55], a[192:195], v24, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[60:63], a[208:211], v24, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[60:63], a[204:207], v24, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[56:59], a[188:191], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[56:59], a[192:195], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[64:67], a[208:211], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[64:67], a[204:207], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[4:7], v68 offset:33792
		ds_read_b128 a[8:11], v68 offset:33856
		ds_read_b128 a[12:15], v68 offset:34048
		ds_read_b128 a[16:19], v68 offset:34112
		ds_read_b128 a[20:23], v68 offset:34304
		ds_read_b128 a[24:27], v68 offset:34368
		ds_read_b128 a[28:31], v68 offset:34560
		ds_read_b128 a[32:35], v68 offset:34624
		ds_read_b128 a[36:39], v68 offset:50688
		ds_read_b128 a[40:43], v68 offset:50752
		ds_read_b128 a[44:47], v68 offset:50944
		ds_read_b128 a[48:51], v68 offset:51008
		ds_read_b128 a[52:55], v68 offset:51200
		ds_read_b128 a[56:59], v68 offset:51264
		ds_read_b128 a[60:63], v68 offset:51456
		ds_read_b128 a[64:67], v68 offset:51520
		ds_read_b128 a[68:71], v71 offset:18912
		ds_read_b128 a[72:75], v71 offset:18976
		ds_read_b128 a[76:79], v71 offset:19168
		ds_read_b128 a[80:83], v71 offset:19232
		ds_read_b128 a[84:87], v71 offset:19424
		ds_read_b128 a[88:91], v71 offset:19488
		ds_read_b128 a[92:95], v71 offset:19680
		ds_read_b128 v[252:255], v71 offset:19744
		v_or3_b32 v20, v79, v83, v28
		v_or3_b32 v16, v87, v91, v16
		v_and_b32_e32 v24, 0xff, v20
		ds_write_b8 v73, v24 offset:4000
		v_lshrrev_b32_e32 v24, 8, v20
		v_and_b32_e32 v24, 0xff, v24
		ds_write_b8 v73, v24 offset:4001
		v_lshrrev_b32_e32 v24, 16, v20
		v_and_b32_e32 v24, 0xff, v24
		ds_write_b8 v73, v24 offset:4002
		v_lshrrev_b32_e32 v20, 24, v20
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v73, v20 offset:4003
		v_and_b32_e32 v20, 0xff, v16
		ds_write_b8 v73, v20 offset:4004
		v_lshrrev_b32_e32 v20, 8, v16
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v73, v20 offset:4005
		v_lshrrev_b32_e32 v20, 16, v16
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v73, v20 offset:4006
		v_lshrrev_b32_e32 v16, 24, v16
		v_and_b32_e32 v16, 0xff, v16
		ds_write_b8 v73, v16 offset:4007
		v_or3_b32 v16, v93, v97, v26
		v_and_b32_e32 v20, 0xff, v16
		ds_write_b8 v75, v20 offset:6048
		v_lshrrev_b32_e32 v20, 8, v16
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v75, v20 offset:6049
		v_lshrrev_b32_e32 v20, 16, v16
		v_and_b32_e32 v20, 0xff, v20
		ds_write_b8 v75, v20 offset:6050
		v_lshrrev_b32_e32 v16, 24, v16
		v_and_b32_e32 v16, 0xff, v16
		ds_write_b8 v75, v16 offset:6051
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v41, s[40:43], 0 offen lds
		ds_read_b32 v16, v22 offset:4000
		s_add_i32 m0, m0, 0x1080
		ds_read_b32 v20, v22 offset:4128
		ds_read_b32 v24, v18 offset:6048
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v26, 0xff, v16
		buffer_load_dwordx4 v42, s[40:43], 0 offen lds
		v_and_b32_e32 v26, 0xff, v26
		v_lshlrev_b32_e32 v28, 8, v26
		v_or_b32_e32 v26, v26, v28
		v_perm_b32 v28, v16, v16, s49
		v_lshlrev_b32_e32 v30, 16, v28
		v_lshlrev_b32_e32 v28, 24, v28
		v_perm_b32 v32, v16, v16, s50
		v_lshlrev_b32_e32 v36, 8, v32
		v_or_b32_e32 v32, v32, v36
		v_perm_b32 v16, v16, v16, s51
		v_lshlrev_b32_e32 v36, 16, v16
		v_lshlrev_b32_e32 v16, 24, v16
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v38, 0xff, v20
		v_and_b32_e32 v38, 0xff, v38
		v_lshlrev_b32_e32 v51, 8, v38
		v_or_b32_e32 v38, v38, v51
		v_perm_b32 v51, v20, v20, s49
		v_lshlrev_b32_e32 v53, 16, v51
		v_lshlrev_b32_e32 v51, 24, v51
		v_perm_b32 v79, v20, v20, s50
		v_lshlrev_b32_e32 v81, 8, v79
		v_or_b32_e32 v79, v79, v81
		v_perm_b32 v20, v20, v20, s51
		v_lshlrev_b32_e32 v81, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v83, 0xff, v24
		v_and_b32_e32 v83, 0xff, v83
		v_lshlrev_b32_e32 v85, 8, v83
		v_or_b32_e32 v83, v83, v85
		v_perm_b32 v85, v24, v24, s49
		v_lshlrev_b32_e32 v87, 16, v85
		v_lshlrev_b32_e32 v85, 24, v85
		v_perm_b32 v89, v24, v24, s50
		v_lshlrev_b32_e32 v91, 8, v89
		v_or_b32_e32 v89, v89, v91
		v_perm_b32 v24, v24, v24, s51
		v_lshlrev_b32_e32 v91, 16, v24
		v_lshlrev_b32_e32 v24, 24, v24
		v_or3_b32 v32, v32, v36, v16
		v_or3_b32 v36, v38, v53, v51
		v_or3_b32 v20, v79, v81, v20
		v_or3_b32 v16, v83, v87, v85
		s_add_i32 m0, m0, 0x1080
		v_or3_b32 v24, v89, v91, v24
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		s_waitcnt vmcnt(27)
		v_or_b32_e32 v15, v105, v15
		s_add_i32 m0, m0, 0x1080
		v_or3_b32 v26, v26, v30, v28
		buffer_load_dwordx4 v44, s[40:43], 0 offen lds
		buffer_load_ubyte_d16 v51, v50, s[56:59], 0 offen
		buffer_load_ubyte_d16 v53, v52, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v55, v54, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v57, v56, s[56:59], 0 offen
		s_setprio 0
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[4:7], v[108:111], v16, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[4:7], v[112:115], v16, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[12:15], v[128:131], v16, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[12:15], v[124:127], v16, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[8:11], v[108:111], v16, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[8:11], v[112:115], v16, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[16:19], v[128:131], v16, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[16:19], v[124:127], v16, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[4:7], v[116:119], v24, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[4:7], v[120:123], v24, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[12:15], v[136:139], v24, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[12:15], v[132:135], v24, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[8:11], v[116:119], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[252:255], a[8:11], v[120:123], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], a[16:19], v[136:139], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[16:19], v[132:135], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[20:23], v[148:151], v24, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[20:23], v[152:155], v24, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[28:31], v[168:171], v24, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[28:31], v[164:167], v24, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[24:27], v[148:151], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], a[24:27], v[152:155], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], a[32:35], v[168:171], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[32:35], v[164:167], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[20:23], v[140:143], v16, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[20:23], v[144:147], v16, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[28:31], v[160:163], v16, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[28:31], v[156:159], v16, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[24:27], v[140:143], v16, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[24:27], v[144:147], v16, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[32:35], v[160:163], v16, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[32:35], v[156:159], v16, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[36:39], v[172:175], v16, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[36:39], v[176:179], v16, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[44:47], v[192:195], v16, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[44:47], v[188:191], v16, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[40:43], v[172:175], v16, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[40:43], v[176:179], v16, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[48:51], v[192:195], v16, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[48:51], v[188:191], v16, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[36:39], v[180:183], v24, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[36:39], v[184:187], v24, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[44:47], v[200:203], v24, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[44:47], v[196:199], v24, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[40:43], v[180:183], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], a[40:43], v[184:187], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], a[48:51], v[200:203], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[48:51], v[196:199], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[52:55], v[212:215], v24, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[52:55], v[216:219], v24, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[60:63], v[232:235], v24, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[60:63], v[228:231], v24, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[56:59], v[212:215], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], a[56:59], v[216:219], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[64:67], v[232:235], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[64:67], v[228:231], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[52:55], v[204:207], v16, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[52:55], v[208:211], v16, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[60:63], v[224:227], v16, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[60:63], v[220:223], v16, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[56:59], v[204:207], v16, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[56:59], v[208:211], v16, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[64:67], v[224:227], v16, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[64:67], v[220:223], v16, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[68:71], v71 offset:52672
		ds_read_b128 a[72:75], v71 offset:52736
		ds_read_b128 a[76:79], v71 offset:52928
		ds_read_b128 a[80:83], v71 offset:52992
		ds_read_b128 a[84:87], v71 offset:53184
		ds_read_b128 a[88:91], v71 offset:53248
		ds_read_b128 a[92:95], v71 offset:53440
		ds_read_b128 v[252:255], v71 offset:53504
		v_lshlrev_b32_e32 v15, 8, v15
		v_or3_b32 v15, v104, v107, v15
		v_and_b32_e32 v16, 0xff, v15
		ds_write_b8 v75, v16 offset:6048
		v_lshrrev_b32_e32 v16, 8, v15
		v_and_b32_e32 v16, 0xff, v16
		ds_write_b8 v75, v16 offset:6049
		v_lshrrev_b32_e32 v16, 16, v15
		v_and_b32_e32 v16, 0xff, v16
		ds_write_b8 v75, v16 offset:6050
		v_lshrrev_b32_e32 v15, 24, v15
		v_and_b32_e32 v15, 0xff, v15
		ds_write_b8 v75, v15 offset:6051
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v45, s[36:39], 0 offen lds
		ds_read_b32 v15, v18 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v16, 0xff, v15
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
		v_and_b32_e32 v16, 0xff, v16
		v_lshlrev_b32_e32 v24, 8, v16
		v_or_b32_e32 v16, v16, v24
		v_perm_b32 v24, v15, v15, s49
		v_lshlrev_b32_e32 v28, 16, v24
		v_lshlrev_b32_e32 v24, 24, v24
		v_perm_b32 v30, v15, v15, s50
		v_lshlrev_b32_e32 v38, 8, v30
		v_or_b32_e32 v30, v30, v38
		v_perm_b32 v15, v15, v15, s51
		v_lshlrev_b32_e32 v38, 16, v15
		v_lshlrev_b32_e32 v15, 24, v15
		s_add_i32 m0, m0, 0x1080
		v_or3_b32 v24, v16, v28, v24
		buffer_load_dwordx4 v47, s[36:39], 0 offen lds
		v_or3_b32 v15, v30, v38, v15
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v48, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v46, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v59, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v60, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v49, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x5260
		s_nop 0
		buffer_load_dwordx4 v61, s[40:43], 0 offen lds
		v_mov_b32_e32 v99, 0
		s_add_i32 m0, m0, 0x1080
		v_mov_b32_e32 v97, 0
		buffer_load_dwordx4 v63, s[40:43], 0 offen lds
		v_mov_b32_e32 v16, 0
		s_add_i32 m0, m0, 0x1080
		v_mov_b32_e32 v91, 0
		buffer_load_dwordx4 v64, s[40:43], 0 offen lds
		v_mov_b32_e32 v85, 0
		s_add_i32 m0, m0, 0x1080
		v_mov_b32_e32 v83, 0
		buffer_load_dwordx4 v62, s[40:43], 0 offen lds
		buffer_load_ubyte_d16 v79, v78, s[52:55], 0 offen
		buffer_load_ubyte_d16 v81, v80, s[52:55], 0 offen
		buffer_load_ubyte_d16_hi v83, v82, s[52:55], 0 offen
		buffer_load_ubyte_d16_hi v85, v84, s[52:55], 0 offen
		buffer_load_ubyte_d16 v87, v86, s[52:55], 0 offen
		buffer_load_ubyte_d16 v89, v88, s[52:55], 0 offen
		buffer_load_ubyte_d16_hi v91, v90, s[52:55], 0 offen
		buffer_load_ubyte_d16_hi v16, v13, s[52:55], 0 offen
		buffer_load_ubyte_d16 v93, v92, s[56:59], 0 offen
		buffer_load_ubyte_d16 v95, v94, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v97, v96, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v99, v98, s[56:59], 0 offen
		s_setprio 0
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[4:7], v[236:239], v24, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[76:79], a[4:7], v[240:243], v24, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[12:15], a[112:115], v24, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[12:15], a[108:111], v24, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[8:11], v[236:239], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[8:11], v[240:243], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[16:19], a[112:115], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[16:19], a[108:111], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[4:7], a[100:103], v15, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[4:7], a[104:107], v15, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[12:15], a[120:123], v15, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[12:15], a[116:119], v15, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[88:91], a[8:11], a[100:103], v15, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[8:11], a[104:107], v15, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[16:19], a[120:123], v15, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[16:19], a[116:119], v15, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[20:23], a[132:135], v15, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[20:23], a[136:139], v15, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[28:31], a[152:155], v15, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[28:31], a[148:151], v15, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[24:27], a[132:135], v15, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[24:27], a[136:139], v15, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[32:35], a[152:155], v15, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[32:35], a[148:151], v15, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[20:23], a[124:127], v24, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[20:23], a[128:131], v24, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[28:31], a[144:147], v24, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[28:31], a[140:143], v24, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[24:27], a[124:127], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[24:27], a[128:131], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[32:35], a[144:147], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[32:35], a[140:143], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[36:39], a[156:159], v24, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[36:39], a[160:163], v24, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[44:47], a[176:179], v24, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[44:47], a[172:175], v24, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[40:43], a[156:159], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[40:43], a[160:163], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[48:51], a[176:179], v24, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[48:51], a[172:175], v24, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[36:39], a[164:167], v15, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[36:39], a[168:171], v15, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[44:47], a[184:187], v15, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[44:47], a[180:183], v15, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[40:43], a[164:167], v15, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[40:43], a[168:171], v15, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[252:255], a[48:51], a[184:187], v15, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[48:51], a[180:183], v15, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[52:55], a[196:199], v15, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[52:55], a[200:203], v15, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[60:63], a[216:219], v15, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[60:63], a[212:215], v15, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[56:59], a[196:199], v15, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], a[56:59], a[200:203], v15, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], a[64:67], a[216:219], v15, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[64:67], a[212:215], v15, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[52:55], a[188:191], v24, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[52:55], a[192:195], v24, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[60:63], a[208:211], v24, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[60:63], a[204:207], v24, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[56:59], a[188:191], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[56:59], a[192:195], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[64:67], a[208:211], v24, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[64:67], a[204:207], v24, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 a[4:7], v68
		ds_read_b128 a[8:11], v68 offset:64
		ds_read_b128 a[12:15], v68 offset:256
		ds_read_b128 a[16:19], v68 offset:320
		ds_read_b128 a[20:23], v68 offset:512
		ds_read_b128 a[24:27], v68 offset:576
		ds_read_b128 a[28:31], v68 offset:768
		ds_read_b128 a[32:35], v68 offset:832
		ds_read_b128 a[36:39], v68 offset:16896
		ds_read_b128 a[40:43], v68 offset:16960
		ds_read_b128 a[44:47], v68 offset:17152
		ds_read_b128 a[48:51], v68 offset:17216
		ds_read_b128 a[52:55], v68 offset:17408
		ds_read_b128 a[56:59], v68 offset:17472
		ds_read_b128 a[60:63], v68 offset:17664
		ds_read_b128 a[64:67], v68 offset:17728
		ds_read_b128 a[68:71], v71 offset:2016
		ds_read_b128 a[72:75], v71 offset:2080
		ds_read_b128 a[76:79], v71 offset:2272
		ds_read_b128 a[80:83], v71 offset:2336
		ds_read_b128 a[84:87], v71 offset:2528
		ds_read_b128 a[88:91], v71 offset:2592
		ds_read_b128 a[92:95], v71 offset:2784
		ds_read_b128 a[96:99], v71 offset:2848
		s_waitcnt vmcnt(43)
		ds_write_b8 v73, v34 offset:4000
		s_waitcnt vmcnt(42)
		ds_write_b8 v73, v40 offset:4001
		s_waitcnt vmcnt(41)
		ds_write_b8 v73, v72 offset:4002
		s_waitcnt vmcnt(40)
		ds_write_b8 v73, v76 offset:4003
		s_waitcnt vmcnt(39)
		ds_write_b8 v73, v77 offset:4004
		s_waitcnt vmcnt(38)
		ds_write_b8 v73, v100 offset:4005
		s_waitcnt vmcnt(37)
		ds_write_b8 v73, v103 offset:4006
		s_waitcnt vmcnt(36)
		ds_write_b8 v73, v244 offset:4007
		s_waitcnt vmcnt(35)
		ds_write_b8 v75, v245 offset:6048
		s_waitcnt vmcnt(34)
		ds_write_b8 v75, v246 offset:6049
		s_waitcnt vmcnt(33)
		ds_write_b8 v75, v247 offset:6050
		s_waitcnt vmcnt(32)
		ds_write_b8 v75, v248 offset:6051
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v74, s[40:43], 0 offen lds
		ds_read_b32 v15, v22 offset:4000
		s_add_i32 m0, m0, 0x1080
		ds_read_b32 v20, v22 offset:4128
		ds_read_b32 v24, v18 offset:6048
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v26, 0xff, v15
		buffer_load_dwordx4 v66, s[40:43], 0 offen lds
		v_and_b32_e32 v26, 0xff, v26
		v_lshlrev_b32_e32 v28, 8, v26
		v_or_b32_e32 v26, v26, v28
		v_perm_b32 v28, v15, v15, s49
		v_lshlrev_b32_e32 v30, 16, v28
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v38, v26, v30, v28
		v_perm_b32 v26, v15, v15, s50
		v_lshlrev_b32_e32 v28, 8, v26
		v_or_b32_e32 v26, v26, v28
		v_perm_b32 v15, v15, v15, s51
		v_lshlrev_b32_e32 v28, 16, v15
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v36, v26, v28, v15
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v15, 0xff, v20
		v_and_b32_e32 v15, 0xff, v15
		v_lshlrev_b32_e32 v26, 8, v15
		v_or_b32_e32 v15, v15, v26
		v_perm_b32 v26, v20, v20, s49
		v_lshlrev_b32_e32 v28, 16, v26
		v_lshlrev_b32_e32 v26, 24, v26
		v_or3_b32 v32, v15, v28, v26
		v_perm_b32 v15, v20, v20, s50
		v_lshlrev_b32_e32 v26, 8, v15
		v_or_b32_e32 v15, v15, v26
		v_perm_b32 v20, v20, v20, s51
		v_lshlrev_b32_e32 v26, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v30, v15, v26, v20
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v15, 0xff, v24
		v_and_b32_e32 v15, 0xff, v15
		v_lshlrev_b32_e32 v20, 8, v15
		v_or_b32_e32 v15, v15, v20
		v_perm_b32 v20, v24, v24, s49
		v_lshlrev_b32_e32 v26, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v34, v15, v26, v20
		v_perm_b32 v15, v24, v24, s50
		v_lshlrev_b32_e32 v20, 8, v15
		v_or_b32_e32 v15, v15, v20
		v_perm_b32 v20, v24, v24, s51
		v_lshlrev_b32_e32 v24, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v28, v15, v24, v20
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v67, s[40:43], 0 offen lds
		v_mov_b32_e32 v15, 0
		s_add_i32 m0, m0, 0x1080
		v_mov_b32_e32 v107, 0
		buffer_load_dwordx4 v65, s[40:43], 0 offen lds
		buffer_load_ubyte_d16 v104, v102, s[56:59], 0 offen
		buffer_load_ubyte_d16 v105, v101, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v107, v106, s[56:59], 0 offen
		buffer_load_ubyte_d16_hi v15, v2, s[56:59], 0 offen
		s_setprio 0
		s_barrier
		s_add_i32 s13, s13, 0x100
		s_add_i32 s14, s14, 0x100
		s_add_i32 s1, s1, s48
		s_add_i32 s12, s12, s46
		s_setprio 0
		s_barrier
		s_add_i32 s33, s33, 2
		s_cmp_lt_i32 s33, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v1, v53, v57
		v_lshlrev_b32_e32 v1, 8, v1
		v_or3_b32 v1, v51, v55, v1
		s_waitcnt vmcnt(16)
		v_or_b32_e32 v2, v81, v85
		v_lshlrev_b32_e32 v2, 8, v2
		v_or3_b32 v2, v79, v83, v2
		s_waitcnt vmcnt(12)
		v_or_b32_e32 v3, v89, v16
		v_lshlrev_b32_e32 v3, 8, v3
		v_or3_b32 v3, v87, v91, v3
		s_waitcnt vmcnt(8)
		v_or_b32_e32 v4, v95, v99
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v4, v93, v97, v4
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v5, v105, v15
		v_lshlrev_b32_e32 v5, 8, v5
		v_or3_b32 v5, v104, v107, v5
		s_setprio 0
		s_and_saveexec_b64 s[80:81], s[30:31]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_1
		s_barrier
.L_a4w4_kernel.exec_endif_1:
		s_mov_b64 exec, s[80:81]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[4:7], v[108:111], v34, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[4:7], v[112:115], v34, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[12:15], v[128:131], v34, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[12:15], v[124:127], v34, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[8:11], v[108:111], v34, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[8:11], v[112:115], v34, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[16:19], v[128:131], v34, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[16:19], v[124:127], v34, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[4:7], v[116:119], v28, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[4:7], v[120:123], v28, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[12:15], v[136:139], v28, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[12:15], v[132:135], v28, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[8:11], v[116:119], v28, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[8:11], v[120:123], v28, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[16:19], v[136:139], v28, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[16:19], v[132:135], v28, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[20:23], v[148:151], v28, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[20:23], v[152:155], v28, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[28:31], v[168:171], v28, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[28:31], v[164:167], v28, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[24:27], v[148:151], v28, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[24:27], v[152:155], v28, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[32:35], v[168:171], v28, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[32:35], v[164:167], v28, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[20:23], v[140:143], v34, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[20:23], v[144:147], v34, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[28:31], v[160:163], v34, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[28:31], v[156:159], v34, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[24:27], v[140:143], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[24:27], v[144:147], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[32:35], v[160:163], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[32:35], v[156:159], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[36:39], v[172:175], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[36:39], v[176:179], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[44:47], v[192:195], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[44:47], v[188:191], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[40:43], v[172:175], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[40:43], v[176:179], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[48:51], v[192:195], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[48:51], v[188:191], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[36:39], v[180:183], v28, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[36:39], v[184:187], v28, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[44:47], v[200:203], v28, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[44:47], v[196:199], v28, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[40:43], v[180:183], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[40:43], v[184:187], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[48:51], v[200:203], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[48:51], v[196:199], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[52:55], v[212:215], v28, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[52:55], v[216:219], v28, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[60:63], v[232:235], v28, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[60:63], v[228:231], v28, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[56:59], v[212:215], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], a[56:59], v[216:219], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[96:99], a[64:67], v[232:235], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[64:67], v[228:231], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[52:55], v[204:207], v34, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[52:55], v[208:211], v34, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[60:63], v[224:227], v34, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[60:63], v[220:223], v34, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[56:59], v[204:207], v34, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[56:59], v[208:211], v34, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[64:67], v[224:227], v34, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[64:67], v[220:223], v34, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[8:11], v71 offset:35776
		ds_read_b128 v[12:15], v71 offset:35840
		ds_read_b128 v[24:27], v71 offset:36032
		ds_read_b128 v[40:43], v71 offset:36096
		ds_read_b128 v[44:47], v71 offset:36288
		ds_read_b128 v[48:51], v71 offset:36352
		ds_read_b128 v[52:55], v71 offset:36544
		ds_read_b128 v[56:59], v71 offset:36608
		s_barrier
		v_and_b32_e32 v6, 0xff, v1
		ds_write_b8 v75, v6 offset:6048
		v_lshrrev_b32_e32 v6, 8, v1
		v_and_b32_e32 v6, 0xff, v6
		ds_write_b8 v75, v6 offset:6049
		v_lshrrev_b32_e32 v6, 16, v1
		v_and_b32_e32 v6, 0xff, v6
		ds_write_b8 v75, v6 offset:6050
		v_lshrrev_b32_e32 v1, 24, v1
		v_and_b32_e32 v1, 0xff, v1
		ds_write_b8 v75, v1 offset:6051
		v_accvgpr_read_b32 v1, a1
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_read_b32 v6, a3
		v_lshlrev_b32_e32 v6, 3, v6
		v_bitop3_b32 v1, v0, v1, v6 bitop3:0x96
		v_accvgpr_read_b32 v6, a0
		v_lshlrev_b32_e32 v6, 2, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b32 v7, v18 offset:6048
		v_and_b32_e32 v16, 0xff, v2
		v_lshrrev_b32_e32 v17, 8, v2
		v_and_b32_e32 v17, 0xff, v17
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v19, 0xff, v7
		v_and_b32_e32 v19, 0xff, v19
		v_lshlrev_b32_e32 v20, 8, v19
		v_or_b32_e32 v19, v19, v20
		v_perm_b32 v20, v7, v7, s49
		v_lshlrev_b32_e32 v21, 16, v20
		v_lshlrev_b32_e32 v20, 24, v20
		v_or3_b32 v19, v19, v21, v20
		v_perm_b32 v20, v7, v7, s50
		v_lshlrev_b32_e32 v21, 8, v20
		v_or_b32_e32 v20, v20, v21
		v_perm_b32 v7, v7, v7, s51
		v_lshlrev_b32_e32 v21, 16, v7
		v_lshlrev_b32_e32 v7, 24, v7
		v_or3_b32 v7, v20, v21, v7
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[8:11], a[4:7], v[236:239], v19, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], a[4:7], v[240:243], v19, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], a[12:15], a[112:115], v19, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[8:11], a[12:15], a[108:111], v19, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[12:15], a[8:11], v[236:239], v19, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], a[8:11], v[240:243], v19, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[16:19], a[112:115], v19, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[12:15], a[16:19], a[108:111], v19, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], a[4:7], a[100:103], v7, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], a[4:7], a[104:107], v7, v38 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[12:15], a[120:123], v7, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[12:15], a[116:119], v7, v38 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[48:51], a[8:11], a[100:103], v7, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[56:59], a[8:11], a[104:107], v7, v38 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[16:19], a[120:123], v7, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[16:19], a[116:119], v7, v38 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[20:23], a[132:135], v7, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[20:23], a[136:139], v7, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[28:31], a[152:155], v7, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[28:31], a[148:151], v7, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[24:27], a[132:135], v7, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[24:27], a[136:139], v7, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[32:35], a[152:155], v7, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[32:35], a[148:151], v7, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[8:11], a[20:23], a[124:127], v19, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], a[20:23], a[128:131], v19, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], a[28:31], a[144:147], v19, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[8:11], a[28:31], a[140:143], v19, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[12:15], a[24:27], a[124:127], v19, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[24:27], a[128:131], v19, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[32:35], a[144:147], v19, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[12:15], a[32:35], a[140:143], v19, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[8:11], a[36:39], a[156:159], v19, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], a[36:39], a[160:163], v19, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[24:27], a[44:47], a[176:179], v19, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[8:11], a[44:47], a[172:175], v19, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[12:15], a[40:43], a[156:159], v19, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[40:43], a[160:163], v19, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[40:43], a[48:51], a[176:179], v19, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[12:15], a[48:51], a[172:175], v19, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[36:39], a[164:167], v7, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[36:39], a[168:171], v7, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], a[44:47], a[184:187], v7, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[44:47], a[44:47], a[180:183], v7, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[40:43], a[164:167], v7, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[40:43], a[168:171], v7, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[56:59], a[48:51], a[184:187], v7, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], a[48:51], a[180:183], v7, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[44:47], a[52:55], a[196:199], v7, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[52:55], a[52:55], a[200:203], v7, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[52:55], a[60:63], a[216:219], v7, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[44:47], a[60:63], a[212:215], v7, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[48:51], a[56:59], a[196:199], v7, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[56:59], a[56:59], a[200:203], v7, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[56:59], a[64:67], a[216:219], v7, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[48:51], a[64:67], a[212:215], v7, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[8:11], a[52:55], a[188:191], v19, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[24:27], a[52:55], a[192:195], v19, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[24:27], a[60:63], a[208:211], v19, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[8:11], a[60:63], a[204:207], v19, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[12:15], a[56:59], a[188:191], v19, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], a[56:59], a[192:195], v19, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], a[64:67], a[208:211], v19, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[12:15], a[64:67], a[204:207], v19, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v68 offset:33792
		ds_read_b128 v[12:15], v68 offset:33856
		ds_read_b128 v[24:27], v68 offset:34048
		ds_read_b128 v[28:31], v68 offset:34112
		ds_read_b128 v[32:35], v68 offset:34304
		ds_read_b128 v[36:39], v68 offset:34368
		ds_read_b128 v[40:43], v68 offset:34560
		ds_read_b128 v[44:47], v68 offset:34624
		ds_read_b128 v[48:51], v68 offset:50688
		ds_read_b128 v[52:55], v68 offset:50752
		ds_read_b128 v[56:59], v68 offset:50944
		ds_read_b128 v[60:63], v68 offset:51008
		ds_read_b128 v[64:67], v68 offset:51200
		ds_read_b128 v[76:79], v68 offset:51264
		ds_read_b128 v[80:83], v68 offset:51456
		ds_read_b128 a[4:7], v68 offset:51520
		ds_read_b128 v[84:87], v71 offset:18912
		ds_read_b128 v[88:91], v71 offset:18976
		ds_read_b128 v[92:95], v71 offset:19168
		ds_read_b128 v[96:99], v71 offset:19232
		ds_read_b128 v[100:103], v71 offset:19424
		ds_read_b128 v[104:107], v71 offset:19488
		ds_read_b128 v[244:247], v71 offset:19680
		ds_read_b128 v[248:251], v71 offset:19744
		ds_write_b8 v73, v16 offset:4000
		ds_write_b8 v73, v17 offset:4001
		v_lshrrev_b32_e32 v7, 16, v2
		v_and_b32_e32 v7, 0xff, v7
		ds_write_b8 v73, v7 offset:4002
		v_lshrrev_b32_e32 v2, 24, v2
		v_and_b32_e32 v2, 0xff, v2
		ds_write_b8 v73, v2 offset:4003
		v_and_b32_e32 v2, 0xff, v3
		ds_write_b8 v73, v2 offset:4004
		v_lshrrev_b32_e32 v2, 8, v3
		v_and_b32_e32 v2, 0xff, v2
		ds_write_b8 v73, v2 offset:4005
		v_lshrrev_b32_e32 v2, 16, v3
		v_and_b32_e32 v2, 0xff, v2
		ds_write_b8 v73, v2 offset:4006
		v_lshrrev_b32_e32 v2, 24, v3
		v_and_b32_e32 v2, 0xff, v2
		ds_write_b8 v73, v2 offset:4007
		v_and_b32_e32 v2, 0xff, v4
		v_lshrrev_b32_e32 v3, 8, v4
		v_and_b32_e32 v3, 0xff, v3
		v_lshrrev_b32_e32 v7, 16, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v75, v2 offset:6048
		ds_write_b8 v75, v3 offset:6049
		v_and_b32_e32 v2, 0xff, v7
		ds_write_b8 v75, v2 offset:6050
		v_lshrrev_b32_e32 v2, 24, v4
		v_and_b32_e32 v2, 0xff, v2
		ds_write_b8 v75, v2 offset:6051
		ds_read_b32 v2, v22 offset:4000
		ds_read_b32 v3, v22 offset:4128
		v_and_b32_e32 v4, 0xff, v5
		v_lshrrev_b32_e32 v7, 8, v5
		v_and_b32_e32 v7, 0xff, v7
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v16, 0xff, v2
		v_and_b32_e32 v16, 0xff, v16
		v_lshlrev_b32_e32 v17, 8, v16
		v_or_b32_e32 v16, v16, v17
		v_perm_b32 v17, v2, v2, s49
		v_lshlrev_b32_e32 v19, 16, v17
		v_lshlrev_b32_e32 v17, 24, v17
		v_or3_b32 v16, v16, v19, v17
		v_perm_b32 v17, v2, v2, s50
		v_lshlrev_b32_e32 v19, 8, v17
		v_or_b32_e32 v17, v17, v19
		v_perm_b32 v2, v2, v2, s51
		v_lshlrev_b32_e32 v19, 16, v2
		v_lshlrev_b32_e32 v2, 24, v2
		v_or3_b32 v2, v17, v19, v2
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v17, 0xff, v3
		v_and_b32_e32 v17, 0xff, v17
		v_lshlrev_b32_e32 v19, 8, v17
		v_or_b32_e32 v17, v17, v19
		v_perm_b32 v19, v3, v3, s49
		v_lshlrev_b32_e32 v20, 16, v19
		v_lshlrev_b32_e32 v19, 24, v19
		v_or3_b32 v17, v17, v20, v19
		v_perm_b32 v19, v3, v3, s50
		v_lshlrev_b32_e32 v20, 8, v19
		v_or_b32_e32 v19, v19, v20
		v_perm_b32 v3, v3, v3, s51
		v_lshlrev_b32_e32 v20, 16, v3
		v_lshlrev_b32_e32 v3, 24, v3
		v_or3_b32 v3, v19, v20, v3
		s_barrier
		ds_read_b32 v19, v18 offset:6048
		v_lshrrev_b32_e32 v20, 16, v5
		v_and_b32_e32 v20, 0xff, v20
		v_lshrrev_b32_e32 v5, 24, v5
		v_and_b32_e32 v5, 0xff, v5
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v21, 0xff, v19
		v_and_b32_e32 v21, 0xff, v21
		v_lshlrev_b32_e32 v22, 8, v21
		v_or_b32_e32 v21, v21, v22
		v_perm_b32 v22, v19, v19, s49
		v_lshlrev_b32_e32 v23, 16, v22
		v_lshlrev_b32_e32 v22, 24, v22
		v_or3_b32 v21, v21, v23, v22
		v_perm_b32 v22, v19, v19, s50
		v_lshlrev_b32_e32 v23, 8, v22
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[84:87], v[8:11], v[108:111], v21, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_or_b32_e32 v22, v22, v23
		v_perm_b32 v19, v19, v19, s51
		v_lshlrev_b32_e32 v23, 16, v19
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[92:95], v[8:11], v[112:115], v21, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v19, 24, v19
		v_or3_b32 v19, v22, v23, v19
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[92:95], v[24:27], v[128:131], v21, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[84:87], v[24:27], v[124:127], v21, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[88:91], v[12:15], v[108:111], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[96:99], v[12:15], v[112:115], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[96:99], v[28:31], v[128:131], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[88:91], v[28:31], v[124:127], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[100:103], v[8:11], v[116:119], v19, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[244:247], v[8:11], v[120:123], v19, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[244:247], v[24:27], v[136:139], v19, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[100:103], v[24:27], v[132:135], v19, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[104:107], v[12:15], v[116:119], v19, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[248:251], v[12:15], v[120:123], v19, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[248:251], v[28:31], v[136:139], v19, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[104:107], v[28:31], v[132:135], v19, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[100:103], v[32:35], v[148:151], v19, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[244:247], v[32:35], v[152:155], v19, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[244:247], v[40:43], v[168:171], v19, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[100:103], v[40:43], v[164:167], v19, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[104:107], v[36:39], v[148:151], v19, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[248:251], v[36:39], v[152:155], v19, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[248:251], v[44:47], v[168:171], v19, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[104:107], v[44:47], v[164:167], v19, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[84:87], v[32:35], v[140:143], v21, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[92:95], v[32:35], v[144:147], v21, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[92:95], v[40:43], v[160:163], v21, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[40:43], v[156:159], v21, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[88:91], v[36:39], v[140:143], v21, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[96:99], v[36:39], v[144:147], v21, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[96:99], v[44:47], v[160:163], v21, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[88:91], v[44:47], v[156:159], v21, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[48:51], v[172:175], v21, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[92:95], v[48:51], v[176:179], v21, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], v[56:59], v[192:195], v21, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[84:87], v[56:59], v[188:191], v21, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[88:91], v[52:55], v[172:175], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[96:99], v[52:55], v[176:179], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[96:99], v[60:63], v[192:195], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[88:91], v[60:63], v[188:191], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[100:103], v[48:51], v[180:183], v19, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[244:247], v[48:51], v[184:187], v19, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[56:59], v[200:203], v19, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[100:103], v[56:59], v[196:199], v19, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[104:107], v[52:55], v[180:183], v19, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[248:251], v[52:55], v[184:187], v19, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[248:251], v[60:63], v[200:203], v19, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[104:107], v[60:63], v[196:199], v19, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[100:103], v[64:67], v[212:215], v19, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[64:67], v[216:219], v19, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[244:247], v[80:83], v[232:235], v19, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[100:103], v[80:83], v[228:231], v19, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[104:107], v[76:79], v[212:215], v19, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[248:251], v[76:79], v[216:219], v19, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[248:251], a[4:7], v[232:235], v19, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[104:107], a[4:7], v[228:231], v19, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[84:87], v[64:67], v[204:207], v21, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[64:67], v[208:211], v21, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[92:95], v[80:83], v[224:227], v21, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[84:87], v[80:83], v[220:223], v21, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[88:91], v[76:79], v[204:207], v21, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[96:99], v[76:79], v[208:211], v21, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[96:99], a[4:7], v[224:227], v21, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[88:91], a[4:7], v[220:223], v21, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v71 offset:52672
		ds_read_b128 v[88:91], v71 offset:52736
		ds_read_b128 v[92:95], v71 offset:52928
		ds_read_b128 v[96:99], v71 offset:52992
		ds_read_b128 v[100:103], v71 offset:53184
		ds_read_b128 v[104:107], v71 offset:53248
		ds_read_b128 v[244:247], v71 offset:53440
		ds_read_b128 v[248:251], v71 offset:53504
		v_cvt_pk_bf16_f32 v252, v108, v109
		v_cvt_pk_bf16_f32 v253, v110, v111
		v_cvt_pk_bf16_f32 v108, v112, v113
		v_cvt_pk_bf16_f32 v109, v114, v115
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b8 v75, v4 offset:6048
		ds_write_b8 v75, v7 offset:6049
		ds_write_b8 v75, v20 offset:6050
		ds_write_b8 v75, v5 offset:6051
		v_cvt_pk_bf16_f32 v20, v116, v117
		v_cvt_pk_bf16_f32 v21, v118, v119
		v_cvt_pk_bf16_f32 v72, v120, v121
		v_cvt_pk_bf16_f32 v73, v122, v123
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b32 v4, v18 offset:6048
		v_cvt_pk_bf16_f32 v254, v124, v125
		v_cvt_pk_bf16_f32 v255, v126, v127
		v_cvt_pk_bf16_f32 v110, v128, v129
		v_cvt_pk_bf16_f32 v111, v130, v131
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v5, 0xff, v4
		v_and_b32_e32 v5, 0xff, v5
		v_lshlrev_b32_e32 v7, 8, v5
		v_or_b32_e32 v5, v5, v7
		v_perm_b32 v7, v4, v4, s49
		v_lshlrev_b32_e32 v18, 16, v7
		v_lshlrev_b32_e32 v7, 24, v7
		v_or3_b32 v5, v5, v18, v7
		v_perm_b32 v7, v4, v4, s50
		v_lshlrev_b32_e32 v18, 8, v7
		v_or_b32_e32 v7, v7, v18
		v_perm_b32 v4, v4, v4, s51
		v_lshlrev_b32_e32 v18, 16, v4
		v_lshlrev_b32_e32 v4, 24, v4
		v_or3_b32 v4, v7, v18, v4
		s_mul_i32 s1, s16, s17
		v_cvt_pk_bf16_f32 v22, v132, v133
		v_cvt_pk_bf16_f32 v23, v134, v135
		v_cvt_pk_bf16_f32 v74, v136, v137
		v_cvt_pk_bf16_f32 v75, v138, v139
		v_cvt_pk_bf16_f32 v112, v140, v141
		v_cvt_pk_bf16_f32 v113, v142, v143
		v_cvt_pk_bf16_f32 v116, v144, v145
		v_cvt_pk_bf16_f32 v117, v146, v147
		v_cvt_pk_bf16_f32 v120, v148, v149
		v_cvt_pk_bf16_f32 v121, v150, v151
		v_cvt_pk_bf16_f32 v124, v152, v153
		v_cvt_pk_bf16_f32 v125, v154, v155
		v_cvt_pk_bf16_f32 v114, v156, v157
		v_cvt_pk_bf16_f32 v115, v158, v159
		v_cvt_pk_bf16_f32 v118, v160, v161
		v_cvt_pk_bf16_f32 v119, v162, v163
		v_cvt_pk_bf16_f32 v122, v164, v165
		v_cvt_pk_bf16_f32 v123, v166, v167
		v_cvt_pk_bf16_f32 v126, v168, v169
		v_cvt_pk_bf16_f32 v127, v170, v171
		v_cvt_pk_bf16_f32 v128, v172, v173
		v_cvt_pk_bf16_f32 v129, v174, v175
		v_cvt_pk_bf16_f32 v132, v176, v177
		v_cvt_pk_bf16_f32 v133, v178, v179
		v_cvt_pk_bf16_f32 v136, v180, v181
		v_cvt_pk_bf16_f32 v137, v182, v183
		v_cvt_pk_bf16_f32 v140, v184, v185
		v_cvt_pk_bf16_f32 v141, v186, v187
		v_cvt_pk_bf16_f32 v130, v188, v189
		v_cvt_pk_bf16_f32 v131, v190, v191
		v_cvt_pk_bf16_f32 v134, v192, v193
		v_cvt_pk_bf16_f32 v135, v194, v195
		v_cvt_pk_bf16_f32 v138, v196, v197
		v_cvt_pk_bf16_f32 v139, v198, v199
		v_cvt_pk_bf16_f32 v142, v200, v201
		v_cvt_pk_bf16_f32 v143, v202, v203
		v_cvt_pk_bf16_f32 v144, v204, v205
		v_cvt_pk_bf16_f32 v145, v206, v207
		v_cvt_pk_bf16_f32 v148, v208, v209
		v_cvt_pk_bf16_f32 v149, v210, v211
		v_cvt_pk_bf16_f32 v152, v212, v213
		v_cvt_pk_bf16_f32 v153, v214, v215
		v_cvt_pk_bf16_f32 v156, v216, v217
		v_cvt_pk_bf16_f32 v157, v218, v219
		v_cvt_pk_bf16_f32 v146, v220, v221
		v_cvt_pk_bf16_f32 v147, v222, v223
		v_cvt_pk_bf16_f32 v150, v224, v225
		v_cvt_pk_bf16_f32 v151, v226, v227
		v_cvt_pk_bf16_f32 v154, v228, v229
		v_cvt_pk_bf16_f32 v155, v230, v231
		v_cvt_pk_bf16_f32 v158, v232, v233
		v_cvt_pk_bf16_f32 v159, v234, v235
		s_barrier
		v_lshlrev_b32_e32 v7, 4, v1
		ds_write_b128 v7, v[252:255]
		v_xor_b32_e32 v18, 1, v1
		v_lshlrev_b32_e32 v18, 4, v18
		ds_write_b128 v18, v[108:111] offset:4096
		v_xor_b32_e32 v19, 2, v1
		v_lshlrev_b32_e32 v19, 4, v19
		ds_write_b128 v19, v[20:23] offset:8192
		v_xor_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v1, 4, v1
		ds_write_b128 v1, v[72:75] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v20, 2, v69
		v_and_b32_e32 v20, 3, v20
		v_lshlrev_b32_e32 v21, 12, v20
		v_and_b32_e32 v22, 3, v69
		v_lshlrev_b32_e32 v22, 5, v22
		v_add3_u32 v23, v6, v70, v22
		v_and_b32_e32 v68, 1, v0
		v_lshlrev_b32_e32 v68, 2, v68
		v_lshrrev_b32_e32 v69, 1, v69
		v_and_b32_e32 v69, 1, v69
		v_lshlrev_b32_e32 v69, 3, v69
		v_bitop3_b32 v20, v68, v69, v20 bitop3:0x96
		v_xor_b32_e32 v23, v23, v20
		v_lshl_add_u32 v23, v23, 4, v21
		ds_read_b128 v[72:75], v23
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 4, v0
		s_add_i32 s1, s0, 2
		s_add_i32 s2, s0, 4
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v68, 0xffff, v72
		v_lshrrev_b32_e32 v69, 16, v72
		v_and_b32_e32 v69, 0xffff, v69
		v_and_b32_e32 v71, 0xffff, v73
		v_lshrrev_b32_e32 v72, 16, v73
		v_and_b32_e32 v72, 0xffff, v72
		v_and_b32_e32 v73, 0xffff, v74
		v_lshrrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v74, 0xffff, v74
		v_and_b32_e32 v108, 0xffff, v75
		v_lshrrev_b32_e32 v75, 16, v75
		v_and_b32_e32 v75, 0xffff, v75
		v_add_u32_e32 v109, 16, v6
		v_add3_u32 v109, v109, v70, v22
		v_xor_b32_e32 v109, v109, v20
		v_lshl_add_u32 v109, v109, 4, v21
		ds_read_b128 v[160:163], v109
		s_add_i32 s3, s0, 6
		s_add_i32 s4, s0, 8
		s_add_i32 s5, s0, 10
		s_add_i32 s6, s0, 12
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v110, 0xffff, v160
		v_lshrrev_b32_e32 v111, 16, v160
		v_and_b32_e32 v111, 0xffff, v111
		v_and_b32_e32 v160, 0xffff, v161
		v_lshrrev_b32_e32 v161, 16, v161
		v_and_b32_e32 v161, 0xffff, v161
		v_and_b32_e32 v164, 0xffff, v162
		v_lshrrev_b32_e32 v162, 16, v162
		v_and_b32_e32 v162, 0xffff, v162
		v_and_b32_e32 v165, 0xffff, v163
		v_lshrrev_b32_e32 v163, 16, v163
		v_and_b32_e32 v163, 0xffff, v163
		v_add_u32_e32 v166, 0x80, v6
		v_add3_u32 v166, v166, v70, v22
		v_xor_b32_e32 v166, v166, v20
		v_lshl_add_u32 v166, v166, 4, v21
		ds_read_b128 v[168:171], v166
		v_add_u32_e32 v6, 0x90, v6
		v_add3_u32 v6, v6, v70, v22
		v_xor_b32_e32 v6, v6, v20
		v_lshl_add_u32 v6, v6, 4, v21
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v20, 0xffff, v168
		v_lshrrev_b32_e32 v21, 16, v168
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v22, 0xffff, v169
		v_lshrrev_b32_e32 v70, 16, v169
		v_and_b32_e32 v70, 0xffff, v70
		v_and_b32_e32 v167, 0xffff, v170
		v_lshrrev_b32_e32 v168, 16, v170
		v_and_b32_e32 v168, 0xffff, v168
		v_and_b32_e32 v169, 0xffff, v171
		v_lshrrev_b32_e32 v170, 16, v171
		v_and_b32_e32 v170, 0xffff, v170
		ds_read_b128 v[172:175], v6
		s_add_i32 s7, s0, 14
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v171, 0xffff, v172
		v_lshrrev_b32_e32 v172, 16, v172
		v_and_b32_e32 v172, 0xffff, v172
		v_and_b32_e32 v176, 0xffff, v173
		v_lshrrev_b32_e32 v173, 16, v173
		v_and_b32_e32 v173, 0xffff, v173
		v_and_b32_e32 v177, 0xffff, v174
		v_lshrrev_b32_e32 v174, 16, v174
		v_and_b32_e32 v174, 0xffff, v174
		v_and_b32_e32 v178, 0xffff, v175
		v_lshrrev_b32_e32 v175, 16, v175
		v_and_b32_e32 v175, 0xffff, v175
		s_barrier
		ds_write_b128 v7, v[112:115]
		ds_write_b128 v18, v[116:119] offset:4096
		ds_write_b128 v19, v[120:123] offset:8192
		ds_write_b128 v1, v[124:127] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v23
		ds_read_b128 v[116:119], v109
		ds_read_b128 v[120:123], v166
		ds_read_b128 v[124:127], v6
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v179, 0xffff, v112
		v_lshrrev_b32_e32 v112, 16, v112
		v_and_b32_e32 v112, 0xffff, v112
		v_and_b32_e32 v180, 0xffff, v113
		v_lshrrev_b32_e32 v113, 16, v113
		v_and_b32_e32 v113, 0xffff, v113
		v_and_b32_e32 v181, 0xffff, v114
		v_lshrrev_b32_e32 v114, 16, v114
		v_and_b32_e32 v114, 0xffff, v114
		v_and_b32_e32 v182, 0xffff, v115
		v_lshrrev_b32_e32 v115, 16, v115
		v_and_b32_e32 v115, 0xffff, v115
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v183, 0xffff, v116
		v_lshrrev_b32_e32 v116, 16, v116
		v_and_b32_e32 v116, 0xffff, v116
		v_and_b32_e32 v184, 0xffff, v117
		v_lshrrev_b32_e32 v117, 16, v117
		v_and_b32_e32 v117, 0xffff, v117
		v_and_b32_e32 v185, 0xffff, v118
		v_lshrrev_b32_e32 v118, 16, v118
		v_and_b32_e32 v118, 0xffff, v118
		v_and_b32_e32 v186, 0xffff, v119
		v_lshrrev_b32_e32 v119, 16, v119
		v_and_b32_e32 v119, 0xffff, v119
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v187, 0xffff, v120
		v_lshrrev_b32_e32 v120, 16, v120
		v_and_b32_e32 v120, 0xffff, v120
		v_and_b32_e32 v188, 0xffff, v121
		v_lshrrev_b32_e32 v121, 16, v121
		v_and_b32_e32 v121, 0xffff, v121
		v_and_b32_e32 v189, 0xffff, v122
		v_lshrrev_b32_e32 v122, 16, v122
		v_and_b32_e32 v122, 0xffff, v122
		v_and_b32_e32 v190, 0xffff, v123
		v_lshrrev_b32_e32 v123, 16, v123
		v_and_b32_e32 v123, 0xffff, v123
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v191, 0xffff, v124
		v_lshrrev_b32_e32 v124, 16, v124
		v_and_b32_e32 v124, 0xffff, v124
		v_and_b32_e32 v192, 0xffff, v125
		v_lshrrev_b32_e32 v125, 16, v125
		v_and_b32_e32 v125, 0xffff, v125
		v_and_b32_e32 v193, 0xffff, v126
		v_lshrrev_b32_e32 v126, 16, v126
		v_and_b32_e32 v126, 0xffff, v126
		v_and_b32_e32 v194, 0xffff, v127
		v_lshrrev_b32_e32 v127, 16, v127
		v_and_b32_e32 v127, 0xffff, v127
		s_barrier
		ds_write_b128 v7, v[128:131]
		ds_write_b128 v18, v[132:135] offset:4096
		ds_write_b128 v19, v[136:139] offset:8192
		ds_write_b128 v1, v[140:143] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[128:131], v23
		ds_read_b128 v[132:135], v109
		ds_read_b128 v[136:139], v166
		ds_read_b128 v[140:143], v6
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v195, 0xffff, v128
		v_lshrrev_b32_e32 v128, 16, v128
		v_and_b32_e32 v128, 0xffff, v128
		v_and_b32_e32 v196, 0xffff, v129
		v_lshrrev_b32_e32 v129, 16, v129
		v_and_b32_e32 v129, 0xffff, v129
		v_and_b32_e32 v197, 0xffff, v130
		v_lshrrev_b32_e32 v130, 16, v130
		v_and_b32_e32 v130, 0xffff, v130
		v_and_b32_e32 v198, 0xffff, v131
		v_lshrrev_b32_e32 v131, 16, v131
		v_and_b32_e32 v131, 0xffff, v131
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v199, 0xffff, v132
		v_lshrrev_b32_e32 v132, 16, v132
		v_and_b32_e32 v132, 0xffff, v132
		v_and_b32_e32 v200, 0xffff, v133
		v_lshrrev_b32_e32 v133, 16, v133
		v_and_b32_e32 v133, 0xffff, v133
		v_and_b32_e32 v201, 0xffff, v134
		v_lshrrev_b32_e32 v134, 16, v134
		v_and_b32_e32 v134, 0xffff, v134
		v_and_b32_e32 v202, 0xffff, v135
		v_lshrrev_b32_e32 v135, 16, v135
		v_and_b32_e32 v135, 0xffff, v135
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v203, 0xffff, v136
		v_lshrrev_b32_e32 v136, 16, v136
		v_and_b32_e32 v136, 0xffff, v136
		v_and_b32_e32 v204, 0xffff, v137
		v_lshrrev_b32_e32 v137, 16, v137
		v_and_b32_e32 v137, 0xffff, v137
		v_and_b32_e32 v205, 0xffff, v138
		v_lshrrev_b32_e32 v138, 16, v138
		v_and_b32_e32 v138, 0xffff, v138
		v_and_b32_e32 v206, 0xffff, v139
		v_lshrrev_b32_e32 v139, 16, v139
		v_and_b32_e32 v139, 0xffff, v139
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v207, 0xffff, v140
		v_lshrrev_b32_e32 v140, 16, v140
		v_and_b32_e32 v140, 0xffff, v140
		v_and_b32_e32 v208, 0xffff, v141
		v_lshrrev_b32_e32 v141, 16, v141
		v_and_b32_e32 v141, 0xffff, v141
		v_and_b32_e32 v209, 0xffff, v142
		v_lshrrev_b32_e32 v142, 16, v142
		v_and_b32_e32 v142, 0xffff, v142
		v_and_b32_e32 v210, 0xffff, v143
		v_lshrrev_b32_e32 v143, 16, v143
		v_and_b32_e32 v143, 0xffff, v143
		s_barrier
		ds_write_b128 v7, v[144:147]
		ds_write_b128 v18, v[148:151] offset:4096
		ds_write_b128 v19, v[152:155] offset:8192
		ds_write_b128 v1, v[156:159] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[144:147], v23
		ds_read_b128 v[148:151], v109
		ds_read_b128 v[152:155], v166
		ds_read_b128 v[156:159], v6
		v_accvgpr_read_b32 v211, a2
		v_mul_lo_u32 v211, s17, v211
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v212, 0xffff, v144
		v_lshrrev_b32_e32 v144, 16, v144
		v_and_b32_e32 v144, 0xffff, v144
		v_and_b32_e32 v213, 0xffff, v145
		v_lshrrev_b32_e32 v145, 16, v145
		v_and_b32_e32 v145, 0xffff, v145
		v_and_b32_e32 v214, 0xffff, v146
		v_lshrrev_b32_e32 v146, 16, v146
		v_and_b32_e32 v146, 0xffff, v146
		v_and_b32_e32 v215, 0xffff, v147
		v_lshrrev_b32_e32 v147, 16, v147
		v_and_b32_e32 v147, 0xffff, v147
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v216, 0xffff, v148
		v_lshrrev_b32_e32 v148, 16, v148
		v_and_b32_e32 v148, 0xffff, v148
		v_and_b32_e32 v217, 0xffff, v149
		v_lshrrev_b32_e32 v149, 16, v149
		v_and_b32_e32 v149, 0xffff, v149
		v_and_b32_e32 v218, 0xffff, v150
		v_lshrrev_b32_e32 v150, 16, v150
		v_and_b32_e32 v150, 0xffff, v150
		v_and_b32_e32 v219, 0xffff, v151
		v_lshrrev_b32_e32 v151, 16, v151
		v_and_b32_e32 v151, 0xffff, v151
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v220, 0xffff, v152
		v_lshrrev_b32_e32 v152, 16, v152
		v_and_b32_e32 v152, 0xffff, v152
		v_and_b32_e32 v221, 0xffff, v153
		v_lshrrev_b32_e32 v153, 16, v153
		v_and_b32_e32 v153, 0xffff, v153
		v_and_b32_e32 v222, 0xffff, v154
		v_lshrrev_b32_e32 v154, 16, v154
		v_and_b32_e32 v154, 0xffff, v154
		v_and_b32_e32 v223, 0xffff, v155
		v_lshrrev_b32_e32 v155, 16, v155
		v_and_b32_e32 v155, 0xffff, v155
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v224, 0xffff, v156
		v_lshrrev_b32_e32 v156, 16, v156
		v_and_b32_e32 v156, 0xffff, v156
		v_and_b32_e32 v225, 0xffff, v157
		v_lshrrev_b32_e32 v157, 16, v157
		v_and_b32_e32 v157, 0xffff, v157
		v_and_b32_e32 v226, 0xffff, v158
		v_lshrrev_b32_e32 v158, 16, v158
		v_and_b32_e32 v158, 0xffff, v158
		v_and_b32_e32 v227, 0xffff, v159
		v_lshrrev_b32_e32 v159, 16, v159
		v_and_b32_e32 v159, 0xffff, v159
		v_lshlrev_b32_e32 v211, 1, v211
		v_add3_u32 v228, s0, v211, v0
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_short v68, v228, s[8:11], 0 offen
		v_add3_u32 v68, s1, v211, v0
		buffer_store_short v69, v68, s[8:11], 0 offen
		v_add3_u32 v68, s2, v211, v0
		buffer_store_short v71, v68, s[8:11], 0 offen
		v_add3_u32 v68, s3, v211, v0
		buffer_store_short v72, v68, s[8:11], 0 offen
		v_add3_u32 v68, s4, v211, v0
		buffer_store_short v110, v68, s[8:11], 0 offen
		v_add3_u32 v68, s5, v211, v0
		buffer_store_short v111, v68, s[8:11], 0 offen
		v_add3_u32 v68, s6, v211, v0
		buffer_store_short v160, v68, s[8:11], 0 offen
		v_add3_u32 v68, s7, v211, v0
		buffer_store_short v161, v68, s[8:11], 0 offen
		s_lshl_b32 s12, s17, 5
		s_add_i32 s13, s0, s12
		v_add3_u32 v68, s13, v211, v0
		buffer_store_short v20, v68, s[8:11], 0 offen
		s_add_i32 s13, s1, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v21, v20, s[8:11], 0 offen
		s_add_i32 s13, s2, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v22, v20, s[8:11], 0 offen
		s_add_i32 s13, s3, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v70, v20, s[8:11], 0 offen
		s_add_i32 s13, s4, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v171, v20, s[8:11], 0 offen
		s_add_i32 s13, s5, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v172, v20, s[8:11], 0 offen
		s_add_i32 s13, s6, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v176, v20, s[8:11], 0 offen
		s_add_i32 s13, s7, s12
		v_add3_u32 v20, s13, v211, v0
		buffer_store_short v173, v20, s[8:11], 0 offen
		s_lshl_b32 s13, s17, 6
		s_add_i32 s14, s0, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v73, v20, s[8:11], 0 offen
		s_add_i32 s14, s1, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v74, v20, s[8:11], 0 offen
		s_add_i32 s14, s2, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v108, v20, s[8:11], 0 offen
		s_add_i32 s14, s3, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v75, v20, s[8:11], 0 offen
		s_add_i32 s14, s4, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v164, v20, s[8:11], 0 offen
		s_add_i32 s14, s5, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v162, v20, s[8:11], 0 offen
		s_add_i32 s14, s6, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v165, v20, s[8:11], 0 offen
		s_add_i32 s14, s7, s13
		v_add3_u32 v20, s14, v211, v0
		buffer_store_short v163, v20, s[8:11], 0 offen
		s_mul_i32 s14, 0x60, s17
		s_add_i32 s15, s0, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v167, v20, s[8:11], 0 offen
		s_add_i32 s15, s1, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v168, v20, s[8:11], 0 offen
		s_add_i32 s15, s2, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v169, v20, s[8:11], 0 offen
		s_add_i32 s15, s3, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v170, v20, s[8:11], 0 offen
		s_add_i32 s15, s4, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v177, v20, s[8:11], 0 offen
		s_add_i32 s15, s5, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v174, v20, s[8:11], 0 offen
		s_add_i32 s15, s6, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v178, v20, s[8:11], 0 offen
		s_add_i32 s15, s7, s14
		v_add3_u32 v20, s15, v211, v0
		buffer_store_short v175, v20, s[8:11], 0 offen
		s_lshl_b32 s15, s17, 7
		s_add_i32 s16, s0, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v179, v20, s[8:11], 0 offen
		s_add_i32 s16, s1, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v112, v20, s[8:11], 0 offen
		s_add_i32 s16, s2, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v180, v20, s[8:11], 0 offen
		s_add_i32 s16, s3, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v113, v20, s[8:11], 0 offen
		s_add_i32 s16, s4, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v183, v20, s[8:11], 0 offen
		s_add_i32 s16, s5, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v116, v20, s[8:11], 0 offen
		s_add_i32 s16, s6, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v184, v20, s[8:11], 0 offen
		s_add_i32 s16, s7, s15
		v_add3_u32 v20, s16, v211, v0
		buffer_store_short v117, v20, s[8:11], 0 offen
		s_mul_i32 s16, 0xa0, s17
		s_add_i32 s18, s0, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v187, v20, s[8:11], 0 offen
		s_add_i32 s18, s1, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v120, v20, s[8:11], 0 offen
		s_add_i32 s18, s2, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v188, v20, s[8:11], 0 offen
		s_add_i32 s18, s3, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v121, v20, s[8:11], 0 offen
		s_add_i32 s18, s4, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v191, v20, s[8:11], 0 offen
		s_add_i32 s18, s5, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v124, v20, s[8:11], 0 offen
		s_add_i32 s18, s6, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v192, v20, s[8:11], 0 offen
		s_add_i32 s18, s7, s16
		v_add3_u32 v20, s18, v211, v0
		buffer_store_short v125, v20, s[8:11], 0 offen
		s_mul_i32 s18, 0xc0, s17
		s_add_i32 s19, s0, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v181, v20, s[8:11], 0 offen
		s_add_i32 s19, s1, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v114, v20, s[8:11], 0 offen
		s_add_i32 s19, s2, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v182, v20, s[8:11], 0 offen
		s_add_i32 s19, s3, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v115, v20, s[8:11], 0 offen
		s_add_i32 s19, s4, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v185, v20, s[8:11], 0 offen
		s_add_i32 s19, s5, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v118, v20, s[8:11], 0 offen
		s_add_i32 s19, s6, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v186, v20, s[8:11], 0 offen
		s_add_i32 s19, s7, s18
		v_add3_u32 v20, s19, v211, v0
		buffer_store_short v119, v20, s[8:11], 0 offen
		s_mul_i32 s19, 0xe0, s17
		s_add_i32 s20, s0, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v189, v20, s[8:11], 0 offen
		s_add_i32 s20, s1, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v122, v20, s[8:11], 0 offen
		s_add_i32 s20, s2, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v190, v20, s[8:11], 0 offen
		s_add_i32 s20, s3, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v123, v20, s[8:11], 0 offen
		s_add_i32 s20, s4, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v193, v20, s[8:11], 0 offen
		s_add_i32 s20, s5, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v126, v20, s[8:11], 0 offen
		s_add_i32 s20, s6, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v194, v20, s[8:11], 0 offen
		s_add_i32 s20, s7, s19
		v_add3_u32 v20, s20, v211, v0
		buffer_store_short v127, v20, s[8:11], 0 offen
		s_lshl_b32 s20, s17, 8
		s_add_i32 s21, s0, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v195, v20, s[8:11], 0 offen
		s_add_i32 s21, s1, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v128, v20, s[8:11], 0 offen
		s_add_i32 s21, s2, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v196, v20, s[8:11], 0 offen
		s_add_i32 s21, s3, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v129, v20, s[8:11], 0 offen
		s_add_i32 s21, s4, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v199, v20, s[8:11], 0 offen
		s_add_i32 s21, s5, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v132, v20, s[8:11], 0 offen
		s_add_i32 s21, s6, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v200, v20, s[8:11], 0 offen
		s_add_i32 s21, s7, s20
		v_add3_u32 v20, s21, v211, v0
		buffer_store_short v133, v20, s[8:11], 0 offen
		s_mul_i32 s21, 0x120, s17
		s_add_i32 s22, s0, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v203, v20, s[8:11], 0 offen
		s_add_i32 s22, s1, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v136, v20, s[8:11], 0 offen
		s_add_i32 s22, s2, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v204, v20, s[8:11], 0 offen
		s_add_i32 s22, s3, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v137, v20, s[8:11], 0 offen
		s_add_i32 s22, s4, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v207, v20, s[8:11], 0 offen
		s_add_i32 s22, s5, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v140, v20, s[8:11], 0 offen
		s_add_i32 s22, s6, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v208, v20, s[8:11], 0 offen
		s_add_i32 s22, s7, s21
		v_add3_u32 v20, s22, v211, v0
		buffer_store_short v141, v20, s[8:11], 0 offen
		s_mul_i32 s22, 0x140, s17
		s_add_i32 s23, s0, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v197, v20, s[8:11], 0 offen
		s_add_i32 s23, s1, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v130, v20, s[8:11], 0 offen
		s_add_i32 s23, s2, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v198, v20, s[8:11], 0 offen
		s_add_i32 s23, s3, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v131, v20, s[8:11], 0 offen
		s_add_i32 s23, s4, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v201, v20, s[8:11], 0 offen
		s_add_i32 s23, s5, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v134, v20, s[8:11], 0 offen
		s_add_i32 s23, s6, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v202, v20, s[8:11], 0 offen
		s_add_i32 s23, s7, s22
		v_add3_u32 v20, s23, v211, v0
		buffer_store_short v135, v20, s[8:11], 0 offen
		s_mul_i32 s23, 0x160, s17
		s_add_i32 s24, s0, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v205, v20, s[8:11], 0 offen
		s_add_i32 s24, s1, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v138, v20, s[8:11], 0 offen
		s_add_i32 s24, s2, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v206, v20, s[8:11], 0 offen
		s_add_i32 s24, s3, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v139, v20, s[8:11], 0 offen
		s_add_i32 s24, s4, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v209, v20, s[8:11], 0 offen
		s_add_i32 s24, s5, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v142, v20, s[8:11], 0 offen
		s_add_i32 s24, s6, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v210, v20, s[8:11], 0 offen
		s_add_i32 s24, s7, s23
		v_add3_u32 v20, s24, v211, v0
		buffer_store_short v143, v20, s[8:11], 0 offen
		s_mul_i32 s24, 0x180, s17
		s_add_i32 s25, s0, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v212, v20, s[8:11], 0 offen
		s_add_i32 s25, s1, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v144, v20, s[8:11], 0 offen
		s_add_i32 s25, s2, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v213, v20, s[8:11], 0 offen
		s_add_i32 s25, s3, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v145, v20, s[8:11], 0 offen
		s_add_i32 s25, s4, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v216, v20, s[8:11], 0 offen
		s_add_i32 s25, s5, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v148, v20, s[8:11], 0 offen
		s_add_i32 s25, s6, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v217, v20, s[8:11], 0 offen
		s_add_i32 s25, s7, s24
		v_add3_u32 v20, s25, v211, v0
		buffer_store_short v149, v20, s[8:11], 0 offen
		s_mul_i32 s25, 0x1a0, s17
		s_add_i32 s26, s0, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v220, v20, s[8:11], 0 offen
		s_add_i32 s26, s1, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v152, v20, s[8:11], 0 offen
		s_add_i32 s26, s2, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v221, v20, s[8:11], 0 offen
		s_add_i32 s26, s3, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v153, v20, s[8:11], 0 offen
		s_add_i32 s26, s4, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v224, v20, s[8:11], 0 offen
		s_add_i32 s26, s5, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v156, v20, s[8:11], 0 offen
		s_add_i32 s26, s6, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v225, v20, s[8:11], 0 offen
		s_add_i32 s26, s7, s25
		v_add3_u32 v20, s26, v211, v0
		buffer_store_short v157, v20, s[8:11], 0 offen
		s_mul_i32 s26, 0x1c0, s17
		s_add_i32 s27, s0, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v214, v20, s[8:11], 0 offen
		s_add_i32 s27, s1, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v146, v20, s[8:11], 0 offen
		s_add_i32 s27, s2, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v215, v20, s[8:11], 0 offen
		s_add_i32 s27, s3, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v147, v20, s[8:11], 0 offen
		s_add_i32 s27, s4, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v218, v20, s[8:11], 0 offen
		s_add_i32 s27, s5, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v150, v20, s[8:11], 0 offen
		s_add_i32 s27, s6, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v219, v20, s[8:11], 0 offen
		s_add_i32 s27, s7, s26
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v151, v20, s[8:11], 0 offen
		s_mul_i32 s17, 0x1e0, s17
		s_add_i32 s27, s0, s17
		v_add3_u32 v20, s27, v211, v0
		buffer_store_short v222, v20, s[8:11], 0 offen
		s_add_i32 s1, s1, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v154, v20, s[8:11], 0 offen
		s_add_i32 s1, s2, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v223, v20, s[8:11], 0 offen
		s_add_i32 s1, s3, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v155, v20, s[8:11], 0 offen
		s_add_i32 s1, s4, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v226, v20, s[8:11], 0 offen
		s_add_i32 s1, s5, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v158, v20, s[8:11], 0 offen
		s_add_i32 s1, s6, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v227, v20, s[8:11], 0 offen
		s_add_i32 s1, s7, s17
		v_add3_u32 v20, s1, v211, v0
		buffer_store_short v159, v20, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[84:87], v[8:11], v[236:239], v5, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[92:95], v[8:11], v[240:243], v5, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[24:27], a[112:115], v5, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[84:87], v[24:27], a[108:111], v5, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[88:91], v[12:15], v[236:239], v5, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[96:99], v[12:15], v[240:243], v5, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[28:31], a[112:115], v5, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[28:31], a[108:111], v5, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[8:11], a[100:103], v4, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[244:247], v[8:11], a[104:107], v4, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[244:247], v[24:27], a[120:123], v4, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[24:27], a[116:119], v4, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[104:107], v[12:15], a[100:103], v4, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v8, v236, v237
		v_cvt_pk_bf16_f32 v9, v238, v239
		v_cvt_pk_bf16_f32 v24, v240, v241
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[248:251], v[12:15], a[104:107], v4, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v25, v242, v243
		v_accvgpr_read_b32 v10, a108
		v_accvgpr_read_b32 v11, a109
		v_cvt_pk_bf16_f32 v10, v10, v11
		v_accvgpr_read_b32 v11, a110
		v_accvgpr_read_b32 v12, a111
		v_cvt_pk_bf16_f32 v11, v11, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[248:251], v[28:31], a[120:123], v4, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a100
		v_accvgpr_read_b32 v13, a101
		v_cvt_pk_bf16_f32 v68, v12, v13
		v_accvgpr_read_b32 v12, a102
		v_accvgpr_read_b32 v13, a103
		v_cvt_pk_bf16_f32 v69, v12, v13
		v_accvgpr_read_b32 v12, a112
		v_accvgpr_read_b32 v13, a113
		v_cvt_pk_bf16_f32 v26, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[104:107], v[28:31], a[116:119], v4, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a104
		v_accvgpr_read_b32 v13, a105
		v_cvt_pk_bf16_f32 v28, v12, v13
		v_accvgpr_read_b32 v12, a106
		v_accvgpr_read_b32 v13, a107
		v_cvt_pk_bf16_f32 v29, v12, v13
		v_accvgpr_read_b32 v12, a114
		v_accvgpr_read_b32 v13, a115
		v_cvt_pk_bf16_f32 v27, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[32:35], a[132:135], v4, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a120
		v_accvgpr_read_b32 v13, a121
		v_cvt_pk_bf16_f32 v30, v12, v13
		v_accvgpr_read_b32 v12, a122
		v_accvgpr_read_b32 v13, a123
		v_cvt_pk_bf16_f32 v31, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[244:247], v[32:35], a[136:139], v4, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[244:247], v[40:43], a[152:155], v4, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a116
		v_accvgpr_read_b32 v13, a117
		v_cvt_pk_bf16_f32 v70, v12, v13
		v_accvgpr_read_b32 v12, a118
		v_accvgpr_read_b32 v13, a119
		v_cvt_pk_bf16_f32 v71, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[100:103], v[40:43], a[148:151], v4, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[36:39], a[132:135], v4, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[248:251], v[36:39], a[136:139], v4, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[248:251], v[44:47], a[152:155], v4, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[44:47], a[148:151], v4, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[84:87], v[32:35], a[124:127], v5, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[32:35], a[128:131], v5, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[40:43], a[144:147], v5, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[84:87], v[40:43], a[140:143], v5, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[36:39], a[124:127], v5, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a132
		v_accvgpr_read_b32 v13, a133
		v_cvt_pk_bf16_f32 v32, v12, v13
		v_accvgpr_read_b32 v12, a134
		v_accvgpr_read_b32 v13, a135
		v_cvt_pk_bf16_f32 v33, v12, v13
		v_accvgpr_read_b32 v12, a136
		v_accvgpr_read_b32 v13, a137
		v_cvt_pk_bf16_f32 v40, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[36:39], a[128:131], v5, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a138
		v_accvgpr_read_b32 v13, a139
		v_cvt_pk_bf16_f32 v41, v12, v13
		v_accvgpr_read_b32 v12, a148
		v_accvgpr_read_b32 v13, a149
		v_cvt_pk_bf16_f32 v34, v12, v13
		v_accvgpr_read_b32 v12, a150
		v_accvgpr_read_b32 v13, a151
		v_cvt_pk_bf16_f32 v35, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[44:47], a[144:147], v5, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v12, a124
		v_accvgpr_read_b32 v13, a125
		v_cvt_pk_bf16_f32 v36, v12, v13
		v_accvgpr_read_b32 v12, a126
		v_accvgpr_read_b32 v13, a127
		v_cvt_pk_bf16_f32 v37, v12, v13
		v_accvgpr_read_b32 v12, a152
		v_accvgpr_read_b32 v13, a153
		v_cvt_pk_bf16_f32 v42, v12, v13
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], v[44:47], a[140:143], v5, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a128
		v_accvgpr_read_b32 v12, a129
		v_cvt_pk_bf16_f32 v44, v2, v12
		v_accvgpr_read_b32 v2, a130
		v_accvgpr_read_b32 v12, a131
		v_cvt_pk_bf16_f32 v45, v2, v12
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v12, a155
		v_cvt_pk_bf16_f32 v43, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[48:51], a[156:159], v5, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a144
		v_accvgpr_read_b32 v12, a145
		v_cvt_pk_bf16_f32 v46, v2, v12
		v_accvgpr_read_b32 v2, a146
		v_accvgpr_read_b32 v12, a147
		v_cvt_pk_bf16_f32 v47, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[48:51], a[160:163], v5, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[92:95], v[56:59], a[176:179], v5, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a140
		v_accvgpr_read_b32 v12, a141
		v_cvt_pk_bf16_f32 v38, v2, v12
		v_accvgpr_read_b32 v2, a142
		v_accvgpr_read_b32 v12, a143
		v_cvt_pk_bf16_f32 v39, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[56:59], a[172:175], v5, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[88:91], v[52:55], a[156:159], v5, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[52:55], a[160:163], v5, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[60:63], a[176:179], v5, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[88:91], v[60:63], a[172:175], v5, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[48:51], a[164:167], v4, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[244:247], v[48:51], a[168:171], v4, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[244:247], v[56:59], a[184:187], v4, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[56:59], a[180:183], v4, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[52:55], a[164:167], v4, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v12, a157
		v_cvt_pk_bf16_f32 v48, v2, v12
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v12, a159
		v_cvt_pk_bf16_f32 v49, v2, v12
		v_accvgpr_read_b32 v2, a160
		v_accvgpr_read_b32 v12, a161
		v_cvt_pk_bf16_f32 v56, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[248:251], v[52:55], a[168:171], v4, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a162
		v_accvgpr_read_b32 v12, a163
		v_cvt_pk_bf16_f32 v57, v2, v12
		v_accvgpr_read_b32 v2, a172
		v_accvgpr_read_b32 v12, a173
		v_cvt_pk_bf16_f32 v50, v2, v12
		v_accvgpr_read_b32 v2, a174
		v_accvgpr_read_b32 v12, a175
		v_cvt_pk_bf16_f32 v51, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[248:251], v[60:63], a[184:187], v4, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a164
		v_accvgpr_read_b32 v12, a165
		v_cvt_pk_bf16_f32 v52, v2, v12
		v_accvgpr_read_b32 v2, a166
		v_accvgpr_read_b32 v12, a167
		v_cvt_pk_bf16_f32 v53, v2, v12
		v_accvgpr_read_b32 v2, a176
		v_accvgpr_read_b32 v12, a177
		v_cvt_pk_bf16_f32 v58, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[60:63], a[180:183], v4, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a168
		v_accvgpr_read_b32 v12, a169
		v_cvt_pk_bf16_f32 v60, v2, v12
		v_accvgpr_read_b32 v2, a170
		v_accvgpr_read_b32 v12, a171
		v_cvt_pk_bf16_f32 v61, v2, v12
		v_accvgpr_read_b32 v2, a178
		v_accvgpr_read_b32 v12, a179
		v_cvt_pk_bf16_f32 v59, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[64:67], a[196:199], v4, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a184
		v_accvgpr_read_b32 v12, a185
		v_cvt_pk_bf16_f32 v62, v2, v12
		v_accvgpr_read_b32 v2, a186
		v_accvgpr_read_b32 v12, a187
		v_cvt_pk_bf16_f32 v63, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[244:247], v[64:67], a[200:203], v4, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[244:247], v[80:83], a[216:219], v4, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a180
		v_accvgpr_read_b32 v12, a181
		v_cvt_pk_bf16_f32 v54, v2, v12
		v_accvgpr_read_b32 v2, a182
		v_accvgpr_read_b32 v12, a183
		v_cvt_pk_bf16_f32 v55, v2, v12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[100:103], v[80:83], a[212:215], v4, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[76:79], a[196:199], v4, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[248:251], v[76:79], a[200:203], v4, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[248:251], a[4:7], a[216:219], v4, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], a[4:7], a[212:215], v4, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[84:87], v[64:67], a[188:191], v5, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[92:95], v[64:67], a[192:195], v5, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[92:95], v[80:83], a[208:211], v5, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[84:87], v[80:83], a[204:207], v5, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[88:91], v[76:79], a[188:191], v5, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a196
		v_accvgpr_read_b32 v4, a197
		v_cvt_pk_bf16_f32 v12, v2, v4
		v_accvgpr_read_b32 v2, a198
		v_accvgpr_read_b32 v4, a199
		v_cvt_pk_bf16_f32 v13, v2, v4
		v_accvgpr_read_b32 v2, a200
		v_accvgpr_read_b32 v4, a201
		v_cvt_pk_bf16_f32 v64, v2, v4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[76:79], a[192:195], v5, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a202
		v_accvgpr_read_b32 v4, a203
		v_cvt_pk_bf16_f32 v65, v2, v4
		v_accvgpr_read_b32 v2, a212
		v_accvgpr_read_b32 v4, a213
		v_cvt_pk_bf16_f32 v14, v2, v4
		v_accvgpr_read_b32 v2, a214
		v_accvgpr_read_b32 v4, a215
		v_cvt_pk_bf16_f32 v15, v2, v4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[96:99], a[4:7], a[208:211], v5, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a188
		v_accvgpr_read_b32 v4, a189
		v_cvt_pk_bf16_f32 v72, v2, v4
		v_accvgpr_read_b32 v2, a190
		v_accvgpr_read_b32 v4, a191
		v_cvt_pk_bf16_f32 v73, v2, v4
		v_accvgpr_read_b32 v2, a216
		v_accvgpr_read_b32 v4, a217
		v_cvt_pk_bf16_f32 v66, v2, v4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[88:91], a[4:7], a[204:207], v5, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a192
		v_accvgpr_read_b32 v3, a193
		v_cvt_pk_bf16_f32 v76, v2, v3
		v_accvgpr_read_b32 v2, a194
		v_accvgpr_read_b32 v3, a195
		v_cvt_pk_bf16_f32 v77, v2, v3
		v_accvgpr_read_b32 v2, a218
		v_accvgpr_read_b32 v3, a219
		v_cvt_pk_bf16_f32 v67, v2, v3
		s_barrier
		ds_write_b128 v7, v[8:11]
		ds_write_b128 v18, v[24:27] offset:4096
		ds_write_b128 v19, v[68:71] offset:8192
		ds_write_b128 v1, v[28:31] offset:12288
		v_accvgpr_read_b32 v2, a204
		v_accvgpr_read_b32 v3, a205
		v_cvt_pk_bf16_f32 v74, v2, v3
		v_accvgpr_read_b32 v2, a206
		v_accvgpr_read_b32 v3, a207
		v_cvt_pk_bf16_f32 v75, v2, v3
		v_accvgpr_read_b32 v2, a208
		v_accvgpr_read_b32 v3, a209
		v_cvt_pk_bf16_f32 v78, v2, v3
		v_accvgpr_read_b32 v2, a210
		v_accvgpr_read_b32 v3, a211
		v_cvt_pk_bf16_f32 v79, v2, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v23
		s_add_i32 s1, s0, 0x100
		s_add_i32 s2, s0, 0x102
		s_add_i32 s3, s0, 0x104
		s_add_i32 s4, s0, 0x106
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v2, 0xffff, v8
		v_lshrrev_b32_e32 v3, 16, v8
		v_and_b32_e32 v3, 0xffff, v3
		v_and_b32_e32 v4, 0xffff, v9
		v_lshrrev_b32_e32 v5, 16, v9
		v_and_b32_e32 v5, 0xffff, v5
		v_and_b32_e32 v8, 0xffff, v10
		v_lshrrev_b32_e32 v9, 16, v10
		v_and_b32_e32 v9, 0xffff, v9
		v_and_b32_e32 v10, 0xffff, v11
		v_lshrrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v11, 0xffff, v11
		ds_read_b128 v[24:27], v109
		s_add_i32 s5, s0, 0x108
		s_add_i32 s6, s0, 0x10a
		s_add_i32 s7, s0, 0x10c
		s_add_i32 s0, s0, 0x10e
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v16, 0xffff, v24
		v_lshrrev_b32_e32 v17, 16, v24
		v_and_b32_e32 v17, 0xffff, v17
		v_and_b32_e32 v20, 0xffff, v25
		v_lshrrev_b32_e32 v21, 16, v25
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v22, 0xffff, v26
		v_lshrrev_b32_e32 v24, 16, v26
		v_and_b32_e32 v24, 0xffff, v24
		v_and_b32_e32 v25, 0xffff, v27
		v_lshrrev_b32_e32 v26, 16, v27
		v_and_b32_e32 v26, 0xffff, v26
		ds_read_b128 v[28:31], v166
		s_add_i32 s27, s1, s12
		s_add_i32 s28, s2, s12
		s_add_i32 s29, s3, s12
		s_add_i32 s30, s4, s12
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v27, 0xffff, v28
		v_lshrrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v28, 0xffff, v28
		v_and_b32_e32 v68, 0xffff, v29
		v_lshrrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v29, 0xffff, v29
		v_and_b32_e32 v69, 0xffff, v30
		v_lshrrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v30, 0xffff, v30
		v_and_b32_e32 v70, 0xffff, v31
		v_lshrrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v31, 0xffff, v31
		ds_read_b128 v[80:83], v6
		s_add_i32 s31, s5, s12
		s_add_i32 s32, s6, s12
		s_add_i32 s33, s7, s12
		s_add_i32 s12, s0, s12
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v71, 0xffff, v80
		v_lshrrev_b32_e32 v80, 16, v80
		v_and_b32_e32 v80, 0xffff, v80
		v_and_b32_e32 v84, 0xffff, v81
		v_lshrrev_b32_e32 v81, 16, v81
		v_and_b32_e32 v81, 0xffff, v81
		v_and_b32_e32 v85, 0xffff, v82
		v_lshrrev_b32_e32 v82, 16, v82
		v_and_b32_e32 v82, 0xffff, v82
		v_and_b32_e32 v86, 0xffff, v83
		v_lshrrev_b32_e32 v83, 16, v83
		v_and_b32_e32 v83, 0xffff, v83
		s_barrier
		ds_write_b128 v7, v[36:39]
		ds_write_b128 v18, v[44:47] offset:4096
		ds_write_b128 v19, v[32:35] offset:8192
		ds_write_b128 v1, v[40:43] offset:12288
		s_add_i32 s34, s1, s13
		s_add_i32 s35, s2, s13
		s_add_i32 s36, s3, s13
		s_add_i32 s37, s4, s13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v23
		s_add_i32 s38, s5, s13
		s_add_i32 s39, s6, s13
		s_add_i32 s40, s7, s13
		s_add_i32 s13, s0, s13
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v36, 0xffff, v32
		v_lshrrev_b32_e32 v32, 16, v32
		v_and_b32_e32 v32, 0xffff, v32
		v_and_b32_e32 v37, 0xffff, v33
		v_lshrrev_b32_e32 v33, 16, v33
		v_and_b32_e32 v33, 0xffff, v33
		v_and_b32_e32 v38, 0xffff, v34
		v_lshrrev_b32_e32 v34, 16, v34
		v_and_b32_e32 v34, 0xffff, v34
		v_and_b32_e32 v39, 0xffff, v35
		v_lshrrev_b32_e32 v35, 16, v35
		v_and_b32_e32 v35, 0xffff, v35
		ds_read_b128 v[40:43], v109
		s_add_i32 s41, s1, s14
		s_add_i32 s42, s2, s14
		s_add_i32 s43, s3, s14
		s_add_i32 s44, s4, s14
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v44, 0xffff, v40
		v_lshrrev_b32_e32 v40, 16, v40
		v_and_b32_e32 v40, 0xffff, v40
		v_and_b32_e32 v45, 0xffff, v41
		v_lshrrev_b32_e32 v41, 16, v41
		v_and_b32_e32 v41, 0xffff, v41
		v_and_b32_e32 v46, 0xffff, v42
		v_lshrrev_b32_e32 v42, 16, v42
		v_and_b32_e32 v42, 0xffff, v42
		v_and_b32_e32 v47, 0xffff, v43
		v_lshrrev_b32_e32 v43, 16, v43
		v_and_b32_e32 v43, 0xffff, v43
		ds_read_b128 v[88:91], v166
		s_add_i32 s45, s5, s14
		s_add_i32 s46, s6, s14
		s_add_i32 s47, s7, s14
		s_add_i32 s14, s0, s14
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v87, 0xffff, v88
		v_lshrrev_b32_e32 v88, 16, v88
		v_and_b32_e32 v88, 0xffff, v88
		v_and_b32_e32 v92, 0xffff, v89
		v_lshrrev_b32_e32 v89, 16, v89
		v_and_b32_e32 v89, 0xffff, v89
		v_and_b32_e32 v93, 0xffff, v90
		v_lshrrev_b32_e32 v90, 16, v90
		v_and_b32_e32 v90, 0xffff, v90
		v_and_b32_e32 v94, 0xffff, v91
		v_lshrrev_b32_e32 v91, 16, v91
		v_and_b32_e32 v91, 0xffff, v91
		ds_read_b128 v[96:99], v6
		s_add_i32 s48, s1, s15
		s_add_i32 s49, s2, s15
		s_add_i32 s50, s3, s15
		s_add_i32 s51, s4, s15
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v95, 0xffff, v96
		v_lshrrev_b32_e32 v96, 16, v96
		v_and_b32_e32 v96, 0xffff, v96
		v_and_b32_e32 v100, 0xffff, v97
		v_lshrrev_b32_e32 v97, 16, v97
		v_and_b32_e32 v97, 0xffff, v97
		v_and_b32_e32 v101, 0xffff, v98
		v_lshrrev_b32_e32 v98, 16, v98
		v_and_b32_e32 v98, 0xffff, v98
		v_and_b32_e32 v102, 0xffff, v99
		v_lshrrev_b32_e32 v99, 16, v99
		v_and_b32_e32 v99, 0xffff, v99
		s_barrier
		ds_write_b128 v7, v[48:51]
		ds_write_b128 v18, v[56:59] offset:4096
		ds_write_b128 v19, v[52:55] offset:8192
		ds_write_b128 v1, v[60:63] offset:12288
		s_add_i32 s52, s5, s15
		s_add_i32 s53, s6, s15
		s_add_i32 s54, s7, s15
		s_add_i32 s15, s0, s15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v23
		s_add_i32 s55, s1, s16
		s_add_i32 s56, s2, s16
		s_add_i32 s57, s3, s16
		s_add_i32 s58, s4, s16
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v52, 0xffff, v48
		v_lshrrev_b32_e32 v48, 16, v48
		v_and_b32_e32 v48, 0xffff, v48
		v_and_b32_e32 v53, 0xffff, v49
		v_lshrrev_b32_e32 v49, 16, v49
		v_and_b32_e32 v49, 0xffff, v49
		v_and_b32_e32 v54, 0xffff, v50
		v_lshrrev_b32_e32 v50, 16, v50
		v_and_b32_e32 v50, 0xffff, v50
		v_and_b32_e32 v55, 0xffff, v51
		v_lshrrev_b32_e32 v51, 16, v51
		v_and_b32_e32 v51, 0xffff, v51
		ds_read_b128 v[56:59], v109
		s_add_i32 s59, s5, s16
		s_add_i32 s60, s6, s16
		s_add_i32 s61, s7, s16
		s_add_i32 s16, s0, s16
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v60, 0xffff, v56
		v_lshrrev_b32_e32 v56, 16, v56
		v_and_b32_e32 v56, 0xffff, v56
		v_and_b32_e32 v61, 0xffff, v57
		v_lshrrev_b32_e32 v57, 16, v57
		v_and_b32_e32 v57, 0xffff, v57
		v_and_b32_e32 v62, 0xffff, v58
		v_lshrrev_b32_e32 v58, 16, v58
		v_and_b32_e32 v58, 0xffff, v58
		v_and_b32_e32 v63, 0xffff, v59
		v_lshrrev_b32_e32 v59, 16, v59
		v_and_b32_e32 v59, 0xffff, v59
		ds_read_b128 v[104:107], v166
		s_add_i32 s62, s1, s18
		s_add_i32 s63, s2, s18
		s_add_i32 s64, s3, s18
		s_add_i32 s65, s4, s18
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v103, 0xffff, v104
		v_lshrrev_b32_e32 v104, 16, v104
		v_and_b32_e32 v104, 0xffff, v104
		v_and_b32_e32 v108, 0xffff, v105
		v_lshrrev_b32_e32 v105, 16, v105
		v_and_b32_e32 v105, 0xffff, v105
		v_and_b32_e32 v110, 0xffff, v106
		v_lshrrev_b32_e32 v106, 16, v106
		v_and_b32_e32 v106, 0xffff, v106
		v_and_b32_e32 v111, 0xffff, v107
		v_lshrrev_b32_e32 v107, 16, v107
		v_and_b32_e32 v107, 0xffff, v107
		ds_read_b128 v[112:115], v6
		s_add_i32 s66, s5, s18
		s_add_i32 s67, s6, s18
		s_add_i32 s68, s7, s18
		s_add_i32 s18, s0, s18
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v116, 0xffff, v112
		v_lshrrev_b32_e32 v112, 16, v112
		v_and_b32_e32 v112, 0xffff, v112
		v_and_b32_e32 v117, 0xffff, v113
		v_lshrrev_b32_e32 v113, 16, v113
		v_and_b32_e32 v113, 0xffff, v113
		v_and_b32_e32 v118, 0xffff, v114
		v_lshrrev_b32_e32 v114, 16, v114
		v_and_b32_e32 v114, 0xffff, v114
		v_and_b32_e32 v119, 0xffff, v115
		v_lshrrev_b32_e32 v115, 16, v115
		v_and_b32_e32 v115, 0xffff, v115
		s_barrier
		ds_write_b128 v7, v[72:75]
		ds_write_b128 v18, v[76:79] offset:4096
		ds_write_b128 v19, v[12:15] offset:8192
		ds_write_b128 v1, v[64:67] offset:12288
		s_add_i32 s69, s1, s19
		s_add_i32 s70, s2, s19
		s_add_i32 s71, s3, s19
		s_add_i32 s72, s4, s19
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v23
		s_add_i32 s73, s5, s19
		s_add_i32 s74, s6, s19
		s_add_i32 s75, s7, s19
		s_add_i32 s19, s0, s19
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v1, 0xffff, v12
		v_lshrrev_b32_e32 v7, 16, v12
		v_and_b32_e32 v7, 0xffff, v7
		v_and_b32_e32 v12, 0xffff, v13
		v_lshrrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v13, 0xffff, v13
		v_and_b32_e32 v18, 0xffff, v14
		v_lshrrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v14, 0xffff, v14
		v_and_b32_e32 v19, 0xffff, v15
		v_lshrrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v15, 0xffff, v15
		ds_read_b128 v[64:67], v109
		s_add_i32 s76, s1, s20
		s_add_i32 s77, s2, s20
		s_add_i32 s78, s3, s20
		s_add_i32 s79, s4, s20
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v23, 0xffff, v64
		v_lshrrev_b32_e32 v64, 16, v64
		v_and_b32_e32 v64, 0xffff, v64
		v_and_b32_e32 v72, 0xffff, v65
		v_lshrrev_b32_e32 v65, 16, v65
		v_and_b32_e32 v65, 0xffff, v65
		v_and_b32_e32 v73, 0xffff, v66
		v_lshrrev_b32_e32 v66, 16, v66
		v_and_b32_e32 v66, 0xffff, v66
		v_and_b32_e32 v74, 0xffff, v67
		v_lshrrev_b32_e32 v67, 16, v67
		v_and_b32_e32 v67, 0xffff, v67
		ds_read_b128 v[76:79], v166
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v75, 0xffff, v76
		v_lshrrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v76, 0xffff, v76
		v_and_b32_e32 v109, 0xffff, v77
		v_lshrrev_b32_e32 v77, 16, v77
		v_and_b32_e32 v77, 0xffff, v77
		v_and_b32_e32 v120, 0xffff, v78
		v_lshrrev_b32_e32 v78, 16, v78
		v_and_b32_e32 v78, 0xffff, v78
		v_and_b32_e32 v121, 0xffff, v79
		v_lshrrev_b32_e32 v79, 16, v79
		v_and_b32_e32 v79, 0xffff, v79
		ds_read_b128 v[124:127], v6
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v6, 0xffff, v124
		v_lshrrev_b32_e32 v122, 16, v124
		v_and_b32_e32 v122, 0xffff, v122
		v_and_b32_e32 v123, 0xffff, v125
		v_lshrrev_b32_e32 v124, 16, v125
		v_and_b32_e32 v124, 0xffff, v124
		v_and_b32_e32 v125, 0xffff, v126
		v_lshrrev_b32_e32 v126, 16, v126
		v_and_b32_e32 v126, 0xffff, v126
		v_and_b32_e32 v128, 0xffff, v127
		v_lshrrev_b32_e32 v127, 16, v127
		v_and_b32_e32 v127, 0xffff, v127
		v_add3_u32 v129, s1, v211, v0
		buffer_store_short v2, v129, s[8:11], 0 offen
		v_add3_u32 v2, s2, v211, v0
		buffer_store_short v3, v2, s[8:11], 0 offen
		v_add3_u32 v2, s3, v211, v0
		buffer_store_short v4, v2, s[8:11], 0 offen
		v_add3_u32 v2, s4, v211, v0
		buffer_store_short v5, v2, s[8:11], 0 offen
		v_add3_u32 v2, s5, v211, v0
		buffer_store_short v16, v2, s[8:11], 0 offen
		v_add3_u32 v2, s6, v211, v0
		buffer_store_short v17, v2, s[8:11], 0 offen
		v_add3_u32 v2, s7, v211, v0
		buffer_store_short v20, v2, s[8:11], 0 offen
		v_add3_u32 v2, s0, v211, v0
		buffer_store_short v21, v2, s[8:11], 0 offen
		v_add3_u32 v2, s27, v211, v0
		buffer_store_short v27, v2, s[8:11], 0 offen
		v_add3_u32 v2, s28, v211, v0
		buffer_store_short v28, v2, s[8:11], 0 offen
		v_add3_u32 v2, s29, v211, v0
		buffer_store_short v68, v2, s[8:11], 0 offen
		v_add3_u32 v2, s30, v211, v0
		buffer_store_short v29, v2, s[8:11], 0 offen
		v_add3_u32 v2, s31, v211, v0
		buffer_store_short v71, v2, s[8:11], 0 offen
		v_add3_u32 v2, s32, v211, v0
		buffer_store_short v80, v2, s[8:11], 0 offen
		v_add3_u32 v2, s33, v211, v0
		buffer_store_short v84, v2, s[8:11], 0 offen
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v81, v2, s[8:11], 0 offen
		v_add3_u32 v2, s34, v211, v0
		buffer_store_short v8, v2, s[8:11], 0 offen
		v_add3_u32 v2, s35, v211, v0
		buffer_store_short v9, v2, s[8:11], 0 offen
		v_add3_u32 v2, s36, v211, v0
		buffer_store_short v10, v2, s[8:11], 0 offen
		v_add3_u32 v2, s37, v211, v0
		buffer_store_short v11, v2, s[8:11], 0 offen
		v_add3_u32 v2, s38, v211, v0
		buffer_store_short v22, v2, s[8:11], 0 offen
		v_add3_u32 v2, s39, v211, v0
		buffer_store_short v24, v2, s[8:11], 0 offen
		v_add3_u32 v2, s40, v211, v0
		buffer_store_short v25, v2, s[8:11], 0 offen
		v_add3_u32 v2, s13, v211, v0
		buffer_store_short v26, v2, s[8:11], 0 offen
		v_add3_u32 v2, s41, v211, v0
		buffer_store_short v69, v2, s[8:11], 0 offen
		v_add3_u32 v2, s42, v211, v0
		buffer_store_short v30, v2, s[8:11], 0 offen
		v_add3_u32 v2, s43, v211, v0
		buffer_store_short v70, v2, s[8:11], 0 offen
		v_add3_u32 v2, s44, v211, v0
		buffer_store_short v31, v2, s[8:11], 0 offen
		v_add3_u32 v2, s45, v211, v0
		buffer_store_short v85, v2, s[8:11], 0 offen
		v_add3_u32 v2, s46, v211, v0
		buffer_store_short v82, v2, s[8:11], 0 offen
		v_add3_u32 v2, s47, v211, v0
		buffer_store_short v86, v2, s[8:11], 0 offen
		v_add3_u32 v2, s14, v211, v0
		buffer_store_short v83, v2, s[8:11], 0 offen
		v_add3_u32 v2, s48, v211, v0
		buffer_store_short v36, v2, s[8:11], 0 offen
		v_add3_u32 v2, s49, v211, v0
		buffer_store_short v32, v2, s[8:11], 0 offen
		v_add3_u32 v2, s50, v211, v0
		buffer_store_short v37, v2, s[8:11], 0 offen
		v_add3_u32 v2, s51, v211, v0
		buffer_store_short v33, v2, s[8:11], 0 offen
		v_add3_u32 v2, s52, v211, v0
		buffer_store_short v44, v2, s[8:11], 0 offen
		v_add3_u32 v2, s53, v211, v0
		buffer_store_short v40, v2, s[8:11], 0 offen
		v_add3_u32 v2, s54, v211, v0
		buffer_store_short v45, v2, s[8:11], 0 offen
		v_add3_u32 v2, s15, v211, v0
		buffer_store_short v41, v2, s[8:11], 0 offen
		v_add3_u32 v2, s55, v211, v0
		buffer_store_short v87, v2, s[8:11], 0 offen
		v_add3_u32 v2, s56, v211, v0
		buffer_store_short v88, v2, s[8:11], 0 offen
		v_add3_u32 v2, s57, v211, v0
		buffer_store_short v92, v2, s[8:11], 0 offen
		v_add3_u32 v2, s58, v211, v0
		buffer_store_short v89, v2, s[8:11], 0 offen
		v_add3_u32 v2, s59, v211, v0
		buffer_store_short v95, v2, s[8:11], 0 offen
		v_add3_u32 v2, s60, v211, v0
		buffer_store_short v96, v2, s[8:11], 0 offen
		v_add3_u32 v2, s61, v211, v0
		buffer_store_short v100, v2, s[8:11], 0 offen
		v_add3_u32 v2, s16, v211, v0
		buffer_store_short v97, v2, s[8:11], 0 offen
		v_add3_u32 v2, s62, v211, v0
		buffer_store_short v38, v2, s[8:11], 0 offen
		v_add3_u32 v2, s63, v211, v0
		buffer_store_short v34, v2, s[8:11], 0 offen
		v_add3_u32 v2, s64, v211, v0
		buffer_store_short v39, v2, s[8:11], 0 offen
		v_add3_u32 v2, s65, v211, v0
		buffer_store_short v35, v2, s[8:11], 0 offen
		v_add3_u32 v2, s66, v211, v0
		buffer_store_short v46, v2, s[8:11], 0 offen
		v_add3_u32 v2, s67, v211, v0
		buffer_store_short v42, v2, s[8:11], 0 offen
		v_add3_u32 v2, s68, v211, v0
		buffer_store_short v47, v2, s[8:11], 0 offen
		v_add3_u32 v2, s18, v211, v0
		buffer_store_short v43, v2, s[8:11], 0 offen
		v_add3_u32 v2, s69, v211, v0
		buffer_store_short v93, v2, s[8:11], 0 offen
		v_add3_u32 v2, s70, v211, v0
		buffer_store_short v90, v2, s[8:11], 0 offen
		v_add3_u32 v2, s71, v211, v0
		buffer_store_short v94, v2, s[8:11], 0 offen
		v_add3_u32 v2, s72, v211, v0
		buffer_store_short v91, v2, s[8:11], 0 offen
		v_add3_u32 v2, s73, v211, v0
		buffer_store_short v101, v2, s[8:11], 0 offen
		v_add3_u32 v2, s74, v211, v0
		buffer_store_short v98, v2, s[8:11], 0 offen
		v_add3_u32 v2, s75, v211, v0
		buffer_store_short v102, v2, s[8:11], 0 offen
		v_add3_u32 v2, s19, v211, v0
		buffer_store_short v99, v2, s[8:11], 0 offen
		v_add3_u32 v2, s76, v211, v0
		buffer_store_short v52, v2, s[8:11], 0 offen
		v_add3_u32 v2, s77, v211, v0
		buffer_store_short v48, v2, s[8:11], 0 offen
		v_add3_u32 v2, s78, v211, v0
		buffer_store_short v53, v2, s[8:11], 0 offen
		v_add3_u32 v2, s79, v211, v0
		buffer_store_short v49, v2, s[8:11], 0 offen
		s_add_i32 s12, s5, s20
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v60, v2, s[8:11], 0 offen
		s_add_i32 s12, s6, s20
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v56, v2, s[8:11], 0 offen
		s_add_i32 s12, s7, s20
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v61, v2, s[8:11], 0 offen
		s_add_i32 s12, s0, s20
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v57, v2, s[8:11], 0 offen
		s_add_i32 s12, s1, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v103, v2, s[8:11], 0 offen
		s_add_i32 s12, s2, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v104, v2, s[8:11], 0 offen
		s_add_i32 s12, s3, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v108, v2, s[8:11], 0 offen
		s_add_i32 s12, s4, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v105, v2, s[8:11], 0 offen
		s_add_i32 s12, s5, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v116, v2, s[8:11], 0 offen
		s_add_i32 s12, s6, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v112, v2, s[8:11], 0 offen
		s_add_i32 s12, s7, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v117, v2, s[8:11], 0 offen
		s_add_i32 s12, s0, s21
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v113, v2, s[8:11], 0 offen
		s_add_i32 s12, s1, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v54, v2, s[8:11], 0 offen
		s_add_i32 s12, s2, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v50, v2, s[8:11], 0 offen
		s_add_i32 s12, s3, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v55, v2, s[8:11], 0 offen
		s_add_i32 s12, s4, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v51, v2, s[8:11], 0 offen
		s_add_i32 s12, s5, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v62, v2, s[8:11], 0 offen
		s_add_i32 s12, s6, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v58, v2, s[8:11], 0 offen
		s_add_i32 s12, s7, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v63, v2, s[8:11], 0 offen
		s_add_i32 s12, s0, s22
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v59, v2, s[8:11], 0 offen
		s_add_i32 s12, s1, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v110, v2, s[8:11], 0 offen
		s_add_i32 s12, s2, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v106, v2, s[8:11], 0 offen
		s_add_i32 s12, s3, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v111, v2, s[8:11], 0 offen
		s_add_i32 s12, s4, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v107, v2, s[8:11], 0 offen
		s_add_i32 s12, s5, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v118, v2, s[8:11], 0 offen
		s_add_i32 s12, s6, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v114, v2, s[8:11], 0 offen
		s_add_i32 s12, s7, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v119, v2, s[8:11], 0 offen
		s_add_i32 s12, s0, s23
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v115, v2, s[8:11], 0 offen
		s_add_i32 s12, s1, s24
		v_add3_u32 v2, s12, v211, v0
		buffer_store_short v1, v2, s[8:11], 0 offen
		s_add_i32 s12, s2, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v7, v1, s[8:11], 0 offen
		s_add_i32 s12, s3, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v12, v1, s[8:11], 0 offen
		s_add_i32 s12, s4, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v13, v1, s[8:11], 0 offen
		s_add_i32 s12, s5, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v23, v1, s[8:11], 0 offen
		s_add_i32 s12, s6, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v64, v1, s[8:11], 0 offen
		s_add_i32 s12, s7, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v72, v1, s[8:11], 0 offen
		s_add_i32 s12, s0, s24
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v65, v1, s[8:11], 0 offen
		s_add_i32 s12, s1, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v75, v1, s[8:11], 0 offen
		s_add_i32 s12, s2, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v76, v1, s[8:11], 0 offen
		s_add_i32 s12, s3, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v109, v1, s[8:11], 0 offen
		s_add_i32 s12, s4, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v77, v1, s[8:11], 0 offen
		s_add_i32 s12, s5, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v6, v1, s[8:11], 0 offen
		s_add_i32 s12, s6, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v122, v1, s[8:11], 0 offen
		s_add_i32 s12, s7, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v123, v1, s[8:11], 0 offen
		s_add_i32 s12, s0, s25
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v124, v1, s[8:11], 0 offen
		s_add_i32 s12, s1, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v18, v1, s[8:11], 0 offen
		s_add_i32 s12, s2, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v14, v1, s[8:11], 0 offen
		s_add_i32 s12, s3, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v19, v1, s[8:11], 0 offen
		s_add_i32 s12, s4, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v15, v1, s[8:11], 0 offen
		s_add_i32 s12, s5, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v73, v1, s[8:11], 0 offen
		s_add_i32 s12, s6, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v66, v1, s[8:11], 0 offen
		s_add_i32 s12, s7, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v74, v1, s[8:11], 0 offen
		s_add_i32 s12, s0, s26
		v_add3_u32 v1, s12, v211, v0
		buffer_store_short v67, v1, s[8:11], 0 offen
		s_add_i32 s1, s1, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v120, v1, s[8:11], 0 offen
		s_add_i32 s1, s2, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v78, v1, s[8:11], 0 offen
		s_add_i32 s1, s3, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v121, v1, s[8:11], 0 offen
		s_add_i32 s1, s4, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v79, v1, s[8:11], 0 offen
		s_add_i32 s1, s5, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v125, v1, s[8:11], 0 offen
		s_add_i32 s1, s6, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v126, v1, s[8:11], 0 offen
		s_add_i32 s1, s7, s17
		v_add3_u32 v1, s1, v211, v0
		buffer_store_short v128, v1, s[8:11], 0 offen
		s_add_i32 s0, s0, s17
		v_add3_u32 v0, s0, v211, v0
		buffer_store_short v127, v0, s[8:11], 0 offen
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 138144
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
		.amdhsa_next_free_vgpr 476
		.amdhsa_next_free_sgpr 82
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
	.set .L_a4w4_kernel.num_agpr, 220
	.set .L_a4w4_kernel.numbered_sgpr, 82
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
    .group_segment_fixed_size: 138144
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     82
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     476
    .agpr_count:     220
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 98
    wave.regalloc.agpr.dwords: 376
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
