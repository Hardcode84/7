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
		s_add_i32 s12, s12, 0xff
		s_mov_b32 s17, 0xff
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s18, s17, 0
		s_add_i32 s12, s12, s18
		s_ashr_i32 s12, s12, 8
		s_add_i32 s13, s13, 0xff
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s17, s17, 0
		s_add_i32 s13, s13, s17
		s_ashr_i32 s13, s13, 8
		s_and_b32 s17, s16, 7
		s_lshr_b32 s16, s16, 3
		s_mul_i32 s17, s17, 32
		s_add_i32 s16, s17, s16
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s17, 1, 0
		s_xor_b32 s18, s16, -1
		s_add_i32 s18, s18, 1
		s_mul_i32 s13, s13, 4
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s17, s18, s16
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s19, s13, -1
		s_add_i32 s19, s19, 1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s19, s19, s13
		v_mov_b32_e32 v1, s19
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s20, v1
		s_xor_b32 s21, s19, -1
		s_add_i32 s21, s21, 1
		s_mul_i32 s22, s21, s20
		s_mul_hi_u32 s22, s20, s22
		s_add_i32 s20, s20, s22
		s_mul_hi_u32 s20, s17, s20
		s_mul_i32 s22, s20, s19
		s_xor_b32 s22, s22, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s17, s17, s22
		s_cmp_ge_u32 s17, s19
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s20, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s20, s23, s20
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s17, s21
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s17, s23, s17
		s_cmp_ge_u32 s17, s19
		s_cselect_b32 s19, 1, 0
		s_add_i32 s22, s20, 1
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s19, s22, s20
		s_cselect_b32 s20, 1, 0
		s_xor_b32 s13, s16, s13
		s_xor_b32 s16, s19, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s13, s16, s19
		s_mul_i32 s16, s13, 4
		s_xor_b32 s19, s16, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s12, s12, s19
		s_cmp_lt_i32 s12, 4
		s_cselect_b32 s12, s12, 4
		v_mov_b32_e32 v1, s12
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s19, s17, s21
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s17, s19, s17
		s_xor_b32 s19, s17, -1
		v_readfirstlane_b32 s20, v1
		s_add_i32 s19, s19, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s17, s19, s17
		s_xor_b32 s18, s12, -1
		s_add_i32 s18, s18, 1
		s_mul_i32 s19, s18, s20
		s_mul_hi_u32 s19, s20, s19
		s_add_i32 s19, s20, s19
		s_mul_hi_u32 s19, s17, s19
		s_mul_i32 s19, s19, s12
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshrrev_b32_e32 v3, 6, v0
		v_lshrrev_b32_e32 v4, 5, v0
		v_lshrrev_b32_e32 v5, 4, v0
		v_accvgpr_write_b32 a0, v5
		s_xor_b32 s19, s19, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s19, s17, s19
		s_add_i32 s20, s19, s18
		v_readfirstlane_b32 s21, v1
		v_mul_lo_u32 v1, s14, v2
		v_and_b32_e32 v3, 1, v3
		v_and_b32_e32 v5, 1, v4
		v_accvgpr_read_b32 v6, a0
		v_and_b32_e32 v6, 1, v6
		v_lshrrev_b32_e32 v7, 3, v0
		s_cmp_ge_u32 s19, s12
		s_cselect_b32 s19, s20, s19
		s_add_i32 s20, s19, s18
		v_lshlrev_b32_e32 v1, 1, v1
		v_mul_lo_u32 v8, s14, v3
		v_mul_lo_u32 v9, s14, v5
		v_mul_lo_u32 v10, s14, v6
		v_and_b32_e32 v11, 1, v7
		s_cmp_ge_u32 s19, s12
		s_cselect_b32 s19, s20, s19
		s_mul_i32 s20, s18, s21
		s_add_i32 s16, s16, s19
		s_mul_hi_u32 s20, s21, s20
		s_add_i32 s20, s21, s20
		s_mul_hi_u32 s20, s17, s20
		v_add_u32_e32 v12, v1, v8
		v_lshlrev_b32_e32 v9, 6, v9
		v_lshlrev_b32_e32 v10, 5, v10
		v_mul_lo_u32 v13, s14, v11
		v_and_b32_e32 v14, 1, v0
		v_lshrrev_b32_e32 v15, 2, v0
		v_lshrrev_b32_e32 v16, 1, v0
		s_mul_i32 s21, s20, s12
		s_xor_b32 s21, s21, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s17, s17, s21
		v_add3_u32 v12, v12, v9, v10
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshlrev_b32_e32 v17, 4, v14
		v_and_b32_e32 v15, 1, v15
		v_and_b32_e32 v16, 1, v16
		s_cmp_ge_u32 s17, s12
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s20, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s22, s20
		s_cselect_b32 s21, 1, 0
		s_add_i32 s18, s17, s18
		v_add3_u32 v12, v12, v13, v17
		v_lshlrev_b32_e32 v18, 6, v15
		v_lshlrev_b32_e32 v19, 5, v16
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s17, s18, s17
		v_readfirstlane_b32 s18, v0
		s_add_i32 s21, s20, 1
		s_mul_i32 s16, s16, 0x100
		s_cmp_ge_u32 s17, s12
		s_cselect_b32 s12, s21, s20
		s_mul_i32 s17, s16, s14
		v_add3_u32 v12, v12, v18, v19
		s_add_u32 s20, s2, s17
		s_addc_u32 s21, s3, 0
		s_lshr_b32 s18, s18, 6
		s_mul_i32 s18, 0x420, s18
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 m0, s18
		s_mov_b32 s23, 0x31016000
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_lshl_b32 s24, s14, 2
		v_add3_u32 v20, s24, v1, v8
		v_add3_u32 v20, v20, v9, v10
		v_add3_u32 v20, v20, v13, v17
		v_add3_u32 v20, v20, v18, v19
		s_add_i32 s25, s18, 0x1080
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_add3_u32 v21, v1, v8, v9
		v_add3_u32 v21, v21, v10, v13
		v_add3_u32 v21, v21, v17, v18
		s_lshl_b32 s26, s14, 3
		v_add3_u32 v22, v19, v21, s26
		s_add_i32 s27, s18, 0x2100
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		s_mul_i32 s28, 12, s14
		v_add3_u32 v23, v19, v21, s28
		s_add_i32 s29, s18, 0x3180
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		s_lshl_b32 s30, s14, 7
		v_add3_u32 v21, v19, v21, s30
		s_add_i32 s31, s18, 0x4200
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		v_add3_u32 v24, v1, v8, v9
		v_add3_u32 v24, v24, v10, v13
		v_add3_u32 v24, v24, v17, v18
		s_mul_i32 s32, 0x84, s14
		v_add3_u32 v25, v19, v24, s32
		s_add_i32 s33, s18, 0x5280
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_mul_i32 s34, 0x88, s14
		v_add3_u32 v26, v19, v24, s34
		s_add_i32 s35, s18, 0x6300
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		v_add3_u32 v24, v19, v24, s14
		s_add_i32 s36, s18, 0x7380
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_mul_lo_u32 v27, s15, v2
		v_lshlrev_b32_e32 v27, 1, v27
		v_mul_lo_u32 v28, s15, v3
		v_mul_lo_u32 v29, s15, v5
		v_mul_lo_u32 v30, s15, v6
		v_add_u32_e32 v31, v27, v28
		v_lshlrev_b32_e32 v29, 6, v29
		v_lshlrev_b32_e32 v30, 5, v30
		v_mul_lo_u32 v32, s15, v11
		v_add3_u32 v31, v31, v29, v30
		v_lshlrev_b32_e32 v32, 4, v32
		v_add3_u32 v31, v31, v32, v17
		s_mul_i32 s37, s12, 0x100
		v_add3_u32 v31, v31, v18, v19
		s_mul_i32 s37, s37, s15
		s_add_u32 s40, s4, s37
		s_addc_u32 s41, s5, 0
		s_add_i32 s38, s18, 0x107c0
		s_mov_b32 s42, s22
		s_mov_b32 m0, s38
		s_mov_b32 s43, s23
		buffer_load_dwordx4 v31, s[40:43], 0 offen lds
		v_add3_u32 v33, v27, v28, v29
		v_add3_u32 v33, v33, v30, v32
		v_add3_u32 v33, v33, v17, v18
		s_lshl_b32 s39, s15, 2
		v_add3_u32 v34, v19, v33, s39
		s_add_i32 s44, s18, 0x11840
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v34, s[40:43], 0 offen lds
		s_lshl_b32 s45, s15, 3
		v_add3_u32 v35, v19, v33, s45
		s_add_i32 s46, s18, 0x128c0
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v35, s[40:43], 0 offen lds
		s_mul_i32 s47, 12, s15
		v_add3_u32 v33, v19, v33, s47
		s_add_i32 s48, s18, 0x13940
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v33, s[40:43], 0 offen lds
		s_load_dword s49, s[0:1], 0x3c
		s_load_dword s50, s[0:1], 0x40
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s13, s13, s49
		s_lshl_b32 s13, s13, 10
		s_mul_i32 s19, s19, s49
		s_lshl_b32 s19, s19, 8
		s_add_i32 s51, s13, s19
		s_mul_i32 s52, s12, s50
		s_lshl_b32 s52, s52, 8
		s_lshl_b32 s53, s15, 7
		v_add3_u32 v36, s53, v27, v28
		v_add3_u32 v36, v36, v29, v30
		v_add3_u32 v36, v36, v32, v17
		v_add3_u32 v36, v36, v18, v19
		s_add_i32 s54, s18, 0x18b80
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v36, s[40:43], 0 offen lds
		v_add3_u32 v37, v27, v28, v29
		v_add3_u32 v37, v37, v30, v32
		v_add3_u32 v37, v37, v17, v18
		s_mul_i32 s55, 0x84, s15
		v_add3_u32 v38, v19, v37, s55
		s_add_i32 s56, s18, 0x19c00
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v38, s[40:43], 0 offen lds
		s_mul_i32 s57, 0x88, s15
		v_add3_u32 v39, v19, v37, s57
		s_add_i32 s58, s18, 0x1ac80
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v39, s[40:43], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v37, v19, v37, s15
		s_add_i32 s59, s18, 0x1bd00
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v37, s[40:43], 0 offen lds
		v_add_u32_e32 v40, 0x80, v1
		v_add_u32_e32 v40, v40, v8
		v_add3_u32 v40, v40, v9, v10
		v_add3_u32 v40, v40, v13, v17
		s_lshl_b32 s60, s50, 7
		s_add_i32 s61, s60, s52
		s_mul_i32 s62, 0x81, s50
		s_add_i32 s63, s62, s52
		s_mul_i32 s64, 0x82, s50
		v_add3_u32 v40, v40, v18, v19
		s_add_i32 s65, s64, s52
		s_mul_i32 s66, 0x83, s50
		s_add_i32 s67, s66, s52
		s_add_i32 s68, s18, 0x83e0
		s_mov_b32 m0, s68
		s_nop 0
		buffer_load_dwordx4 v40, s[20:23], 0 offen lds
		s_add_i32 s24, s24, 0x80
		v_add3_u32 v41, s24, v1, v8
		v_add3_u32 v41, v41, v9, v10
		v_add3_u32 v41, v41, v13, v17
		v_add3_u32 v41, v41, v18, v19
		s_add_i32 s24, s18, 0x9460
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v41, s[20:23], 0 offen lds
		s_add_i32 s26, s26, 0x80
		v_add3_u32 v42, s26, v1, v8
		v_add3_u32 v42, v42, v9, v10
		v_add3_u32 v42, v42, v13, v17
		v_add3_u32 v42, v42, v18, v19
		s_add_i32 s26, s18, 0xa4e0
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v42, s[20:23], 0 offen lds
		s_add_i32 s28, s28, 0x80
		v_add3_u32 v43, s28, v1, v8
		v_add3_u32 v43, v43, v9, v10
		v_add3_u32 v43, v43, v13, v17
		v_add3_u32 v43, v43, v18, v19
		s_add_i32 s28, s18, 0xb560
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v43, s[20:23], 0 offen lds
		s_add_i32 s30, s30, 0x80
		v_add3_u32 v44, s30, v1, v8
		v_add3_u32 v44, v44, v9, v10
		v_add3_u32 v44, v44, v13, v17
		v_add3_u32 v44, v44, v18, v19
		s_add_i32 s30, s18, 0xc5e0
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v44, s[20:23], 0 offen lds
		s_add_i32 s32, s32, 0x80
		v_add3_u32 v45, s32, v1, v8
		v_add3_u32 v45, v45, v9, v10
		v_add3_u32 v45, v45, v13, v17
		v_add3_u32 v45, v45, v18, v19
		s_add_i32 s32, s18, 0xd660
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v45, s[20:23], 0 offen lds
		s_add_i32 s34, s34, 0x80
		v_add3_u32 v46, s34, v1, v8
		v_add3_u32 v46, v46, v9, v10
		v_add3_u32 v46, v46, v13, v17
		v_add3_u32 v46, v46, v18, v19
		s_add_i32 s34, s18, 0xe6e0
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v46, s[20:23], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v1, s14, v1, v8
		v_add3_u32 v1, v1, v9, v10
		v_add3_u32 v1, v1, v13, v17
		v_add3_u32 v1, v1, v18, v19
		s_add_i32 s14, s18, 0xf760
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add_u32_e32 v8, 0x80, v27
		v_add_u32_e32 v8, v8, v28
		v_add3_u32 v8, v8, v29, v30
		v_add3_u32 v8, v8, v32, v17
		v_add3_u32 v8, v8, v18, v19
		s_add_i32 s20, s18, 0x149a0
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		v_add3_u32 v9, v27, v28, v29
		v_add3_u32 v9, v9, v30, v32
		v_add3_u32 v9, v9, v17, v18
		s_add_i32 s21, s39, 0x80
		v_add3_u32 v10, v19, v9, s21
		s_add_i32 s21, s18, 0x15a20
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 s22, s45, 0x80
		v_add3_u32 v13, v19, v9, s22
		s_add_i32 s22, s18, 0x16aa0
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v13, s[40:43], 0 offen lds
		s_add_i32 s23, s47, 0x80
		v_add3_u32 v9, v19, v9, s23
		s_add_i32 s23, s18, 0x17b20
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		s_add_i32 s39, s13, 8
		s_add_i32 s39, s39, s19
		s_add_i32 s45, s49, 8
		s_add_i32 s45, s45, s13
		s_add_i32 s45, s45, s19
		s_lshl_b32 s47, s49, 1
		s_add_i32 s47, s47, 8
		s_add_i32 s47, s47, s13
		s_add_i32 s47, s47, s19
		s_mul_i32 s69, 3, s49
		s_add_i32 s69, s69, 8
		s_add_i32 s69, s69, s13
		s_add_i32 s69, s69, s19
		s_lshl_b32 s70, s49, 2
		s_add_i32 s70, s70, 8
		s_add_i32 s70, s70, s13
		s_add_i32 s70, s70, s19
		s_mul_i32 s71, 5, s49
		s_add_i32 s71, s71, 8
		s_add_i32 s71, s71, s13
		s_add_i32 s71, s71, s19
		s_mul_i32 s72, 6, s49
		s_add_i32 s72, s72, 8
		s_add_i32 s72, s72, s13
		s_add_i32 s72, s72, s19
		s_mul_i32 s73, 7, s49
		s_add_i32 s73, s73, 8
		s_add_i32 s13, s73, s13
		s_add_i32 s13, s13, s19
		s_add_i32 s19, s52, 8
		s_add_i32 s73, s50, 8
		s_add_i32 s73, s73, s52
		s_lshl_b32 s74, s50, 1
		s_add_i32 s74, s74, 8
		s_add_i32 s74, s74, s52
		s_mul_i32 s75, 3, s50
		s_add_i32 s75, s75, 8
		s_add_i32 s75, s75, s52
		s_add_i32 s53, s53, 0x80
		v_add3_u32 v47, s53, v27, v28
		v_add3_u32 v47, v47, v29, v30
		v_add3_u32 v47, v47, v32, v17
		v_add3_u32 v47, v47, v18, v19
		s_add_i32 s53, s18, 0x1cd60
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v47, s[40:43], 0 offen lds
		v_add3_u32 v27, v27, v28, v29
		v_add3_u32 v27, v27, v30, v32
		v_add3_u32 v27, v27, v17, v18
		s_add_i32 s55, s55, 0x80
		v_add3_u32 v28, v19, v27, s55
		s_add_i32 s55, s18, 0x1dde0
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v28, s[40:43], 0 offen lds
		s_add_i32 s57, s57, 0x80
		v_add3_u32 v29, v19, v27, s57
		s_add_i32 s57, s18, 0x1ee60
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v29, s[40:43], 0 offen lds
		v_add_u32_e32 v30, 32, v11
		v_lshlrev_b32_e32 v32, 1, v6
		v_add_u32_e32 v48, 64, v11
		v_add_u32_e32 v49, 0x60, v11
		v_add_u32_e32 v50, 0x80, v11
		v_add_u32_e32 v51, 0xa0, v11
		v_add_u32_e32 v52, 0xc0, v11
		v_add_u32_e32 v53, 0xe0, v11
		v_mul_lo_u32 v54, s49, v2
		v_lshlrev_b32_e32 v55, 2, v5
		v_xor_b32_e32 v30, v30, v32
		v_xor_b32_e32 v48, v48, v32
		v_xor_b32_e32 v49, v49, v32
		v_xor_b32_e32 v50, v50, v32
		v_xor_b32_e32 v51, v51, v32
		v_xor_b32_e32 v52, v52, v32
		v_xor_b32_e32 v32, v53, v32
		v_mul_lo_u32 v53, s50, v2
		v_lshl_add_u32 v54, v54, 4, s51
		v_mul_lo_u32 v56, s49, v3
		v_lshlrev_b32_e32 v57, 3, v3
		v_xor_b32_e32 v30, v55, v30
		v_xor_b32_e32 v48, v55, v48
		v_xor_b32_e32 v49, v55, v49
		v_xor_b32_e32 v50, v55, v50
		v_xor_b32_e32 v51, v55, v51
		v_xor_b32_e32 v52, v55, v52
		v_xor_b32_e32 v32, v55, v32
		v_lshl_add_u32 v53, v53, 4, s52
		v_mul_lo_u32 v55, s50, v3
		v_lshl_add_u32 v54, v56, 3, v54
		v_mul_lo_u32 v56, s49, v5
		v_mul_lo_u32 v58, s49, v6
		v_mul_lo_u32 v59, s49, v11
		v_lshlrev_b32_e32 v60, 4, v2
		v_xor_b32_e32 v30, v57, v30
		v_xor_b32_e32 v48, v57, v48
		v_xor_b32_e32 v49, v57, v49
		v_xor_b32_e32 v50, v57, v50
		v_xor_b32_e32 v51, v57, v51
		v_xor_b32_e32 v52, v57, v52
		v_xor_b32_e32 v32, v57, v32
		v_lshl_add_u32 v53, v55, 3, v53
		v_mul_lo_u32 v55, s50, v5
		v_mul_lo_u32 v57, s50, v6
		v_mul_lo_u32 v61, s50, v11
		v_mul_lo_u32 v62, s50, v14
		v_mul_lo_u32 v63, s49, v14
		v_lshl_add_u32 v54, v56, 2, v54
		v_xor_b32_e32 v30, v60, v30
		v_xor_b32_e32 v48, v60, v48
		v_xor_b32_e32 v49, v60, v49
		v_xor_b32_e32 v50, v60, v50
		v_xor_b32_e32 v51, v60, v51
		v_xor_b32_e32 v52, v60, v52
		v_xor_b32_e32 v32, v60, v32
		v_lshl_add_u32 v53, v55, 2, v53
		v_lshlrev_b32_e32 v55, 2, v62
		v_lshlrev_b32_e32 v56, 6, v57
		v_lshlrev_b32_e32 v62, 5, v61
		v_mul_lo_u32 v64, s50, v15
		v_mul_lo_u32 v65, s50, v16
		v_lshlrev_b32_e32 v63, 3, v63
		v_lshlrev_b32_e32 v66, 7, v58
		v_lshlrev_b32_e32 v67, 6, v59
		v_mul_lo_u32 v68, s49, v15
		v_mul_lo_u32 v69, s49, v16
		s_add_i32 s15, s15, 0x80
		s_add_i32 s76, s18, 0x1fee0
		s_add_i32 s60, s60, 8
		s_add_i32 s60, s60, s52
		v_lshl_add_u32 v54, v58, 1, v54
		v_lshlrev_b32_e32 v58, 2, v15
		v_lshlrev_b32_e32 v70, 1, v16
		v_mul_lo_u32 v71, s49, v30
		v_mul_lo_u32 v72, s49, v48
		v_mul_lo_u32 v73, s49, v49
		v_mul_lo_u32 v74, s49, v50
		v_mul_lo_u32 v75, s49, v51
		v_mul_lo_u32 v76, s49, v52
		v_mul_lo_u32 v77, s49, v32
		v_lshl_add_u32 v53, v57, 1, v53
		v_add3_u32 v57, s61, v55, v56
		v_lshlrev_b32_e32 v64, 4, v64
		v_lshlrev_b32_e32 v65, 3, v65
		v_add3_u32 v78, v55, v56, v62
		v_add3_u32 v79, s39, v63, v66
		v_lshlrev_b32_e32 v68, 5, v68
		v_lshlrev_b32_e32 v69, 4, v69
		v_add3_u32 v80, s45, v63, v66
		v_add3_u32 v81, v63, v66, v67
		v_add3_u32 v63, v63, v66, v67
		v_add3_u32 v66, s19, v55, v56
		v_add3_u32 v82, v55, v56, v62
		v_add3_u32 v83, s60, v55, v56
		v_add3_u32 v55, v55, v56, v62
		s_add_i32 s19, s62, 8
		s_add_i32 s19, s19, s52
		v_add3_u32 v54, v54, v59, v14
		v_add3_u32 v56, s51, v71, v14
		v_add3_u32 v59, s51, v72, v14
		v_add3_u32 v71, s51, v73, v14
		v_add3_u32 v72, s51, v74, v14
		v_add3_u32 v73, s51, v75, v14
		v_add3_u32 v74, s51, v76, v14
		v_add3_u32 v75, s51, v77, v14
		v_add3_u32 v53, v53, v61, v14
		v_mul_lo_u32 v61, s50, v30
		v_add3_u32 v76, v14, v58, v70
		v_mul_lo_u32 v77, s50, v48
		v_mul_lo_u32 v84, s50, v49
		v_add3_u32 v57, v57, v62, v64
		v_add3_u32 v78, v78, v64, v65
		v_add3_u32 v79, v79, v67, v68
		v_add3_u32 v67, v80, v67, v68
		v_add3_u32 v80, v81, v68, v69
		v_add3_u32 v63, v63, v68, v69
		v_add3_u32 v66, v66, v62, v64
		v_add3_u32 v68, v82, v64, v65
		v_add3_u32 v62, v83, v62, v64
		v_add3_u32 v55, v55, v64, v65
		s_add_i32 s39, s64, 8
		s_add_i32 s39, s39, s52
		s_add_i32 s45, s66, 8
		s_add_i32 s45, s45, s52
		v_add3_u32 v54, v54, v58, v70
		v_add3_u32 v56, v56, v58, v70
		v_add3_u32 v59, v59, v58, v70
		v_add3_u32 v64, v71, v58, v70
		v_add3_u32 v71, v72, v58, v70
		v_add3_u32 v72, v73, v58, v70
		v_add3_u32 v73, v74, v58, v70
		v_add3_u32 v74, v75, v58, v70
		v_add3_u32 v53, v53, v58, v70
		v_add3_u32 v58, v61, v76, s52
		v_add3_u32 v61, v77, v76, s52
		v_add3_u32 v70, v84, v76, s52
		v_add3_u32 v57, v57, v65, v4
		v_add3_u32 v75, v4, v78, s63
		v_add3_u32 v76, v4, v78, s65
		v_add3_u32 v77, v4, v78, s67
		v_mov_b32_e32 v84, 0
		v_add3_u32 v78, v79, v69, v4
		v_add3_u32 v67, v67, v69, v4
		v_add3_u32 v69, v4, v80, s47
		v_add3_u32 v79, v4, v80, s69
		v_add3_u32 v80, v4, v80, s70
		v_add3_u32 v81, v4, v63, s71
		v_add3_u32 v82, v4, v63, s72
		v_add3_u32 v63, v4, v63, s13
		v_add3_u32 v66, v66, v65, v4
		v_add3_u32 v83, v4, v68, s73
		v_add3_u32 v88, v4, v68, s74
		v_add3_u32 v68, v4, v68, s75
		v_add3_u32 v27, v19, v27, s15
		v_add3_u32 v62, v62, v65, v4
		v_add3_u32 v65, v4, v55, s19
		v_add3_u32 v89, v4, v55, s39
		v_add3_u32 v4, v4, v55, s45
		s_mov_b32 s60, s8
		s_mov_b32 s61, s9
		s_mov_b32 s62, s42
		s_mov_b32 s63, s43
		s_mov_b32 s64, s10
		s_mov_b32 s65, s11
		s_mov_b32 s66, s42
		s_mov_b32 s67, s43
		s_mov_b32 m0, s76
		buffer_load_ubyte v55, v54, s[60:63], 0 offen
		buffer_load_ubyte v90, v56, s[60:63], 0 offen
		buffer_load_ubyte v91, v59, s[60:63], 0 offen
		buffer_load_ubyte v92, v64, s[60:63], 0 offen
		buffer_load_ubyte v93, v71, s[60:63], 0 offen
		buffer_load_ubyte v94, v72, s[60:63], 0 offen
		buffer_load_ubyte v95, v73, s[60:63], 0 offen
		buffer_load_ubyte v96, v74, s[60:63], 0 offen
		buffer_load_ubyte v97, v53, s[64:67], 0 offen
		buffer_load_ubyte v98, v58, s[64:67], 0 offen
		buffer_load_ubyte v99, v61, s[64:67], 0 offen
		buffer_load_ubyte v100, v70, s[64:67], 0 offen
		buffer_load_ubyte_d16 v101, v57, s[64:67], 0 offen
		buffer_load_ubyte_d16 v102, v75, s[64:67], 0 offen
		v_mov_b32_e32 v103, 0
		buffer_load_ubyte_d16_hi v103, v76, s[64:67], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v77, s[64:67], 0 offen
		buffer_load_ubyte_d16 v105, v78, s[60:63], 0 offen
		buffer_load_ubyte_d16 v106, v67, s[60:63], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v69, s[60:63], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v79, s[60:63], 0 offen
		buffer_load_ubyte_d16 v109, v80, s[60:63], 0 offen
		buffer_load_ubyte_d16 v110, v81, s[60:63], 0 offen
		v_mov_b32_e32 v111, 0
		buffer_load_ubyte_d16_hi v111, v82, s[60:63], 0 offen
		v_mov_b32_e32 v112, 0
		buffer_load_ubyte_d16_hi v112, v63, s[60:63], 0 offen
		buffer_load_ubyte_d16 v113, v66, s[64:67], 0 offen
		buffer_load_ubyte_d16 v114, v83, s[64:67], 0 offen
		v_mov_b32_e32 v115, 0
		buffer_load_ubyte_d16_hi v115, v88, s[64:67], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v68, s[64:67], 0 offen
		buffer_load_dwordx4 v27, s[40:43], 0 offen lds
		buffer_load_ubyte_d16 v117, v62, s[64:67], 0 offen
		buffer_load_ubyte_d16 v118, v65, s[64:67], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v89, s[64:67], 0 offen
		v_mov_b32_e32 v120, 0
		buffer_load_ubyte_d16_hi v120, v4, s[64:67], 0 offen
		s_load_dword s13, s[0:1], 0x38
		v_mov_b32_e32 v85, 0
		v_mov_b64_e32 v[86:87], 0
		s_add_i32 s0, s17, 0x100
		s_mov_b32 s1, 0
		s_add_i32 s15, s37, 0x100
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v121, 7, v2
		v_and_b32_e32 v122, 63, v0
		v_lshrrev_b32_e32 v123, 4, v122
		v_lshlrev_b32_e32 v123, 4, v123
		v_and_b32_e32 v122, 15, v122
		v_mov_b32_e32 v124, 0x420
		v_mul_lo_u32 v124, v124, v122
		v_add3_u32 v121, v121, v123, v124
		ds_read_b128 a[4:7], v121
		ds_read_b128 a[8:11], v121 offset:64
		ds_read_b128 a[12:15], v121 offset:256
		ds_read_b128 a[16:19], v121 offset:320
		ds_read_b128 a[20:23], v121 offset:512
		ds_read_b128 a[24:27], v121 offset:576
		ds_read_b128 a[28:31], v121 offset:768
		ds_read_b128 a[32:35], v121 offset:832
		ds_read_b128 a[36:39], v121 offset:16896
		ds_read_b128 a[40:43], v121 offset:16960
		ds_read_b128 a[44:47], v121 offset:17152
		ds_read_b128 a[48:51], v121 offset:17216
		ds_read_b128 a[52:55], v121 offset:17408
		ds_read_b128 a[56:59], v121 offset:17472
		ds_read_b128 a[60:63], v121 offset:17664
		ds_read_b128 a[64:67], v121 offset:17728
		v_add_u32_e32 v122, 0x10000, v123
		v_lshlrev_b32_e32 v123, 7, v3
		v_add3_u32 v122, v122, v123, v124
		ds_read_b128 a[68:71], v122 offset:1984
		ds_read_b128 a[72:75], v122 offset:2048
		ds_read_b128 a[76:79], v122 offset:2240
		ds_read_b128 a[80:83], v122 offset:2304
		ds_read_b128 a[84:87], v122 offset:2496
		ds_read_b128 a[88:91], v122 offset:2560
		ds_read_b128 a[92:95], v122 offset:2752
		ds_read_b128 a[96:99], v122 offset:2816
		v_add_u32_e32 v7, 0x20000, v7
		v_lshlrev_b32_e32 v123, 8, v14
		v_add_u32_e32 v124, v7, v123
		v_lshlrev_b32_e32 v125, 10, v15
		v_lshlrev_b32_e32 v126, 9, v16
		v_add3_u32 v124, v124, v125, v126
		s_waitcnt vmcnt(32)
		ds_write_b8 v124, v55 offset:3904
		v_add_u32_e32 v55, 0x20000, v123
		v_add3_u32 v55, v55, v125, v126
		v_add_u32_e32 v123, v55, v30
		s_waitcnt vmcnt(31)
		ds_write_b8 v123, v90 offset:3904
		v_add_u32_e32 v90, v55, v48
		s_waitcnt vmcnt(30)
		ds_write_b8 v90, v91 offset:3904
		v_add_u32_e32 v91, v55, v49
		s_waitcnt vmcnt(29)
		ds_write_b8 v91, v92 offset:3904
		v_add_u32_e32 v50, v55, v50
		s_waitcnt vmcnt(28)
		ds_write_b8 v50, v93 offset:3904
		v_add_u32_e32 v51, v55, v51
		s_waitcnt vmcnt(27)
		ds_write_b8 v51, v94 offset:3904
		v_add_u32_e32 v52, v55, v52
		s_waitcnt vmcnt(26)
		ds_write_b8 v52, v95 offset:3904
		v_add_u32_e32 v32, v55, v32
		s_waitcnt vmcnt(25)
		ds_write_b8 v32, v96 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v55, 7, v14
		v_add_u32_e32 v7, v7, v55
		v_lshlrev_b32_e32 v92, 9, v15
		v_lshlrev_b32_e32 v93, 8, v16
		v_add3_u32 v7, v7, v92, v93
		s_waitcnt vmcnt(24)
		ds_write_b8 v7, v97 offset:5952
		v_add_u32_e32 v55, 0x20000, v55
		v_add3_u32 v55, v55, v92, v93
		v_add_u32_e32 v30, v55, v30
		s_waitcnt vmcnt(23)
		ds_write_b8 v30, v98 offset:5952
		v_add_u32_e32 v48, v55, v48
		s_waitcnt vmcnt(22)
		ds_write_b8 v48, v99 offset:5952
		v_add_u32_e32 v49, v55, v49
		s_waitcnt vmcnt(21)
		ds_write_b8 v49, v100 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v55, 0x20000, v60
		v_lshlrev_b32_e32 v60, 3, v14
		v_add_u32_e32 v55, v55, v60
		v_lshl_add_u32 v55, v5, 9, v55
		v_lshlrev_b32_e32 v92, 8, v6
		v_lshlrev_b32_e32 v93, 6, v11
		v_add3_u32 v55, v55, v92, v93
		v_lshlrev_b32_e32 v92, 5, v15
		v_lshlrev_b32_e32 v16, 10, v16
		v_accvgpr_write_b32 a1, v16
		v_accvgpr_read_b32 v16, a1
		v_add3_u32 v16, v55, v92, v16
		ds_read_b64_tr_b8 v[94:95], v16 offset:3904
		ds_read_b64_tr_b8 v[96:97], v16 offset:4032
		v_add_u32_e32 v55, 0x20000, v60
		v_lshl_add_u32 v55, v3, 4, v55
		v_lshl_add_u32 v55, v5, 8, v55
		v_lshlrev_b32_e32 v60, 7, v6
		v_add3_u32 v55, v55, v60, v93
		v_add3_u32 v55, v55, v92, v126
		ds_read_b64_tr_b8 v[92:93], v55 offset:5952
		s_mov_b32 s17, 16
		s_mov_b32 s19, s17
		v_lshlrev_b32_e32 v60, 2, v0
		v_add_u32_e32 v60, 0x20000, v60
		v_lshlrev_b32_e32 v98, 3, v0
		v_add_u32_e32 v98, 0x20000, v98
		s_add_u32 s60, s2, s0
		s_addc_u32 s61, s3, 0
		s_mov_b32 s62, s42
		s_mov_b32 s63, s43
		s_add_u32 s64, s4, s15
		s_addc_u32 s65, s5, 0
		s_mov_b32 s66, s42
		s_mov_b32 s67, s43
		s_add_u32 s72, s8, s19
		s_addc_u32 s73, s9, 0
		s_mov_b32 s74, s42
		s_mov_b32 s75, s43
		s_add_u32 s80, s10, s19
		s_addc_u32 s81, s11, 0
		s_mov_b32 s82, s42
		s_mov_b32 s83, s43
		s_mov_b32 s17, s19
		v_accvgpr_write_b32 a100, v84
		v_accvgpr_write_b32 a101, v85
		v_accvgpr_write_b32 a102, v86
		v_accvgpr_write_b32 a103, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
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
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[4:7], v[84:87], v92, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v92, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v92, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v92, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v93, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v93, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v93, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v93, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v93, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v93, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v93, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v93, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v92, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v92, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v92, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v92, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v92, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v92, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v92, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v92, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v93, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v93, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v93, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v93, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v93, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v93, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v93, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v93, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v92, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v92, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v92, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v92, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 a[68:71], v122 offset:35712
		ds_read_b128 a[72:75], v122 offset:35776
		ds_read_b128 a[76:79], v122 offset:35968
		ds_read_b128 a[80:83], v122 offset:36032
		ds_read_b128 a[84:87], v122 offset:36224
		ds_read_b128 a[88:91], v122 offset:36288
		ds_read_b128 a[92:95], v122 offset:36480
		ds_read_b128 a[96:99], v122 offset:36544
		s_waitcnt vmcnt(17)
		v_or_b32_e32 v92, v102, v104
		v_lshlrev_b32_e32 v92, 8, v92
		v_or3_b32 v92, v101, v103, v92
		ds_write_b32 v60, v92 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[92:93], v55 offset:5952
		s_mov_b32 m0, s18
		s_add_u32 s60, s2, s0
		s_addc_u32 s61, s3, 0
		buffer_load_dwordx4 v12, s[60:63], 0 offen lds
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v20, s[60:63], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v22, s[60:63], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v23, s[60:63], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v21, s[60:63], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v25, s[60:63], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v26, s[60:63], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v24, s[60:63], 0 offen lds
		s_mov_b32 m0, s38
		s_add_u32 s64, s4, s15
		s_addc_u32 s65, s5, 0
		buffer_load_dwordx4 v31, s[64:67], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v34, s[64:67], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v35, s[64:67], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v33, s[64:67], 0 offen lds
		s_add_u32 s72, s8, s19
		s_addc_u32 s73, s9, 0
		buffer_load_ubyte v99, v54, s[72:75], 0 offen
		buffer_load_ubyte v100, v56, s[72:75], 0 offen
		buffer_load_ubyte v125, v59, s[72:75], 0 offen
		buffer_load_ubyte v126, v64, s[72:75], 0 offen
		buffer_load_ubyte v127, v71, s[72:75], 0 offen
		buffer_load_ubyte v244, v72, s[72:75], 0 offen
		buffer_load_ubyte v245, v73, s[72:75], 0 offen
		buffer_load_ubyte v246, v74, s[72:75], 0 offen
		s_add_u32 s80, s10, s17
		s_addc_u32 s81, s11, 0
		buffer_load_ubyte v247, v53, s[80:83], 0 offen
		buffer_load_ubyte v248, v58, s[80:83], 0 offen
		buffer_load_ubyte v249, v61, s[80:83], 0 offen
		buffer_load_ubyte v250, v70, s[80:83], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v92, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v92, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v92, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v92, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v93, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v93, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v93, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v93, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[96:99], a[8:11], a[120:123], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[96:99], a[16:19], a[136:139], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v93, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v93, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v93, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v93, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[96:99], a[24:27], a[152:155], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[96:99], a[32:35], a[168:171], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v92, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v92, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v92, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v92, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v92, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v92, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v92, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v92, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v93, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v93, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v93, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v93, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[96:99], a[40:43], a[184:187], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[96:99], a[48:51], a[200:203], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v93, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v93, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v93, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v93, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[96:99], a[56:59], a[216:219], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[96:99], a[64:67], a[232:235], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v92, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v92, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v92, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v92, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 a[4:7], v121 offset:33760
		ds_read_b128 a[8:11], v121 offset:33824
		ds_read_b128 a[12:15], v121 offset:34016
		ds_read_b128 a[16:19], v121 offset:34080
		ds_read_b128 a[20:23], v121 offset:34272
		ds_read_b128 a[24:27], v121 offset:34336
		ds_read_b128 a[28:31], v121 offset:34528
		ds_read_b128 a[32:35], v121 offset:34592
		ds_read_b128 a[36:39], v121 offset:50656
		ds_read_b128 a[40:43], v121 offset:50720
		ds_read_b128 a[44:47], v121 offset:50912
		ds_read_b128 a[48:51], v121 offset:50976
		ds_read_b128 a[52:55], v121 offset:51168
		ds_read_b128 a[56:59], v121 offset:51232
		ds_read_b128 a[60:63], v121 offset:51424
		ds_read_b128 a[64:67], v121 offset:51488
		ds_read_b128 a[68:71], v122 offset:18848
		ds_read_b128 a[72:75], v122 offset:18912
		ds_read_b128 a[76:79], v122 offset:19104
		ds_read_b128 a[80:83], v122 offset:19168
		ds_read_b128 a[84:87], v122 offset:19360
		ds_read_b128 a[88:91], v122 offset:19424
		ds_read_b128 a[92:95], v122 offset:19616
		ds_read_b128 a[96:99], v122 offset:19680
		s_waitcnt vmcnt(37)
		v_or_b32_e32 v92, v106, v108
		v_lshlrev_b32_e32 v92, 8, v92
		v_or3_b32 v94, v105, v107, v92
		s_waitcnt vmcnt(33)
		v_or_b32_e32 v92, v110, v112
		v_lshlrev_b32_e32 v92, 8, v92
		v_or3_b32 v95, v109, v111, v92
		ds_write_b64 v98, v[94:95] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(29)
		v_or_b32_e32 v92, v114, v116
		v_lshlrev_b32_e32 v92, 8, v92
		v_or3_b32 v92, v113, v115, v92
		ds_write_b32 v60, v92 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[92:93], v16 offset:3904
		ds_read_b64_tr_b8 v[94:95], v16 offset:4032
		ds_read_b64_tr_b8 v[96:97], v55 offset:5952
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v36, s[64:67], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v38, s[64:67], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v39, s[64:67], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v37, s[64:67], 0 offen lds
		buffer_load_ubyte_d16 v101, v57, s[80:83], 0 offen
		buffer_load_ubyte_d16 v102, v75, s[80:83], 0 offen
		v_mov_b32_e32 v103, 0
		buffer_load_ubyte_d16_hi v103, v76, s[80:83], 0 offen
		v_mov_b32_e32 v104, 0
		buffer_load_ubyte_d16_hi v104, v77, s[80:83], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[4:7], v[84:87], v96, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v96, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v96, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v96, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v96, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v96, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v96, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v96, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v97, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v97, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v97, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v97, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v97, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v97, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v97, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v97, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v97, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v97, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v97, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v97, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v97, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v97, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v97, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v97, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v96, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v96, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v96, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v96, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v96, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v96, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v96, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v96, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v96, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v96, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v96, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v96, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v96, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v96, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v96, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v96, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v97, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v97, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v97, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v97, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v97, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v97, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v97, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v97, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v97, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v97, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v97, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v97, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v97, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v97, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v97, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v97, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v96, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v96, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v96, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v96, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v96, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v96, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v96, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v96, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		s_barrier
		ds_read_b128 a[68:71], v122 offset:52576
		ds_read_b128 a[72:75], v122 offset:52640
		ds_read_b128 a[76:79], v122 offset:52832
		ds_read_b128 a[80:83], v122 offset:52896
		ds_read_b128 a[84:87], v122 offset:53088
		ds_read_b128 a[88:91], v122 offset:53152
		ds_read_b128 a[92:95], v122 offset:53344
		ds_read_b128 v[252:255], v122 offset:53408
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v96, v118, v120
		v_lshlrev_b32_e32 v96, 8, v96
		v_or3_b32 v96, v117, v119, v96
		ds_write_b32 v60, v96 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[96:97], v55 offset:5952
		s_mov_b32 m0, s68
		s_nop 0
		buffer_load_dwordx4 v40, s[60:63], 0 offen lds
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v41, s[60:63], 0 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v42, s[60:63], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v43, s[60:63], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v44, s[60:63], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v45, s[60:63], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v46, s[60:63], 0 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v1, s[60:63], 0 offen lds
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v8, s[64:67], 0 offen lds
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v10, s[64:67], 0 offen lds
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v13, s[64:67], 0 offen lds
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v9, s[64:67], 0 offen lds
		buffer_load_ubyte_d16 v105, v78, s[72:75], 0 offen
		buffer_load_ubyte_d16 v106, v67, s[72:75], 0 offen
		v_mov_b32_e32 v107, 0
		buffer_load_ubyte_d16_hi v107, v69, s[72:75], 0 offen
		v_mov_b32_e32 v108, 0
		buffer_load_ubyte_d16_hi v108, v79, s[72:75], 0 offen
		buffer_load_ubyte_d16 v109, v80, s[72:75], 0 offen
		buffer_load_ubyte_d16 v110, v81, s[72:75], 0 offen
		v_mov_b32_e32 v111, 0
		buffer_load_ubyte_d16_hi v111, v82, s[72:75], 0 offen
		v_mov_b32_e32 v112, 0
		buffer_load_ubyte_d16_hi v112, v63, s[72:75], 0 offen
		buffer_load_ubyte_d16 v113, v66, s[80:83], 0 offen
		buffer_load_ubyte_d16 v114, v83, s[80:83], 0 offen
		v_mov_b32_e32 v115, 0
		buffer_load_ubyte_d16_hi v115, v88, s[80:83], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v68, s[80:83], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[4:7], a[108:111], v96, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[4:7], a[112:115], v96, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[12:15], a[128:131], v96, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[12:15], a[124:127], v96, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[8:11], a[108:111], v96, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[8:11], a[112:115], v96, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[16:19], a[128:131], v96, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[16:19], a[124:127], v96, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[4:7], a[116:119], v97, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[4:7], a[120:123], v97, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[12:15], a[136:139], v97, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[12:15], a[132:135], v97, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[8:11], a[116:119], v97, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[8:11], a[120:123], v97, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[16:19], a[136:139], v97, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[16:19], a[132:135], v97, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[20:23], a[148:151], v97, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[20:23], a[152:155], v97, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[28:31], a[168:171], v97, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[28:31], a[164:167], v97, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[24:27], a[148:151], v97, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[24:27], a[152:155], v97, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[32:35], a[168:171], v97, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[32:35], a[164:167], v97, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[20:23], a[140:143], v96, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[20:23], a[144:147], v96, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[28:31], a[160:163], v96, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[28:31], a[156:159], v96, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[24:27], a[140:143], v96, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[24:27], a[144:147], v96, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[32:35], a[160:163], v96, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[32:35], a[156:159], v96, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[36:39], a[172:175], v96, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[36:39], a[176:179], v96, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[44:47], a[192:195], v96, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[44:47], a[188:191], v96, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[72:75], a[40:43], a[172:175], v96, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[80:83], a[40:43], a[176:179], v96, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[80:83], a[48:51], a[192:195], v96, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[72:75], a[48:51], a[188:191], v96, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[36:39], a[180:183], v97, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[36:39], a[184:187], v97, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[92:95], a[44:47], a[200:203], v97, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[44:47], a[196:199], v97, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], a[40:43], a[180:183], v97, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[252:255], a[40:43], a[184:187], v97, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], a[48:51], a[200:203], v97, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[88:91], a[48:51], a[196:199], v97, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[52:55], a[212:215], v97, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[92:95], a[52:55], a[216:219], v97, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[92:95], a[60:63], a[232:235], v97, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[60:63], a[228:231], v97, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[88:91], a[56:59], a[212:215], v97, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], a[56:59], a[216:219], v97, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[252:255], a[64:67], a[232:235], v97, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[88:91], a[64:67], a[228:231], v97, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[52:55], a[204:207], v96, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[52:55], a[208:211], v96, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[60:63], a[224:227], v96, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[60:63], a[220:223], v96, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[72:75], a[56:59], a[204:207], v96, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[80:83], a[56:59], a[208:211], v96, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[80:83], a[64:67], a[224:227], v96, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[72:75], a[64:67], a[220:223], v96, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 a[4:7], v121
		ds_read_b128 a[8:11], v121 offset:64
		ds_read_b128 a[12:15], v121 offset:256
		ds_read_b128 a[16:19], v121 offset:320
		ds_read_b128 a[20:23], v121 offset:512
		ds_read_b128 a[24:27], v121 offset:576
		ds_read_b128 a[28:31], v121 offset:768
		ds_read_b128 a[32:35], v121 offset:832
		ds_read_b128 a[36:39], v121 offset:16896
		ds_read_b128 a[40:43], v121 offset:16960
		ds_read_b128 a[44:47], v121 offset:17152
		ds_read_b128 a[48:51], v121 offset:17216
		ds_read_b128 a[52:55], v121 offset:17408
		ds_read_b128 a[56:59], v121 offset:17472
		ds_read_b128 a[60:63], v121 offset:17664
		ds_read_b128 a[64:67], v121 offset:17728
		ds_read_b128 a[68:71], v122 offset:1984
		ds_read_b128 a[72:75], v122 offset:2048
		ds_read_b128 a[76:79], v122 offset:2240
		ds_read_b128 a[80:83], v122 offset:2304
		ds_read_b128 a[84:87], v122 offset:2496
		ds_read_b128 a[88:91], v122 offset:2560
		ds_read_b128 a[92:95], v122 offset:2752
		ds_read_b128 a[96:99], v122 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v124, v99 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v123, v100 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v90, v125 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v91, v126 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v50, v127 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v51, v244 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v52, v245 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v32, v246 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v7, v247 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v30, v248 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v48, v249 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v49, v250 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[94:95], v16 offset:3904
		ds_read_b64_tr_b8 v[96:97], v16 offset:4032
		ds_read_b64_tr_b8 v[92:93], v55 offset:5952
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v47, s[64:67], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v28, s[64:67], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v29, s[64:67], 0 offen lds
		s_mov_b32 m0, s76
		s_nop 0
		buffer_load_dwordx4 v27, s[64:67], 0 offen lds
		buffer_load_ubyte_d16 v117, v62, s[80:83], 0 offen
		buffer_load_ubyte_d16 v118, v65, s[80:83], 0 offen
		v_mov_b32_e32 v119, 0
		buffer_load_ubyte_d16_hi v119, v89, s[80:83], 0 offen
		v_mov_b32_e32 v120, 0
		buffer_load_ubyte_d16_hi v120, v4, s[80:83], 0 offen
		s_add_i32 s0, s0, 0x100
		s_add_i32 s15, s15, 0x100
		s_add_i32 s19, s19, 16
		s_add_i32 s17, s17, 16
		s_add_i32 s1, s1, 2
		s_cmp_lt_i32 s1, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(32)
		v_or_b32_e32 v1, v102, v104
		v_lshlrev_b32_e32 v1, 8, v1
		v_or3_b32 v1, v101, v103, v1
		s_waitcnt vmcnt(16)
		v_or_b32_e32 v4, v106, v108
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v8, v105, v107, v4
		s_waitcnt vmcnt(12)
		v_or_b32_e32 v4, v110, v112
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v9, v109, v111, v4
		s_waitcnt vmcnt(8)
		v_or_b32_e32 v4, v114, v116
		v_lshlrev_b32_e32 v4, 8, v4
		v_or3_b32 v4, v113, v115, v4
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v7, v118, v120
		v_lshlrev_b32_e32 v7, 8, v7
		v_or3_b32 v7, v117, v119, v7
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[4:7], v[84:87], v92, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[4:7], a[100:103], v92, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[12:15], v[140:143], v92, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[12:15], v[136:139], v92, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[8:11], a[100:103], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v92, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v92, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[4:7], v[128:131], v93, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[4:7], v[132:135], v93, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[12:15], v[148:151], v93, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[12:15], v[144:147], v93, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[8:11], v[132:135], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[16:19], v[148:151], v93, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v93, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[20:23], v[160:163], v93, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[20:23], v[164:167], v93, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[28:31], v[180:183], v93, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[28:31], v[176:179], v93, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[24:27], v[164:167], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[32:35], v[180:183], v93, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v93, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[20:23], v[152:155], v92, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[20:23], v[156:159], v92, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[28:31], v[172:175], v92, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[28:31], v[168:171], v92, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v92, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v92, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[36:39], v[184:187], v92, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[36:39], v[188:191], v92, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[44:47], v[204:207], v92, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[44:47], v[200:203], v92, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v92, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v92, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[36:39], v[192:195], v93, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[36:39], v[196:199], v93, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[44:47], v[212:215], v93, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[44:47], v[208:211], v93, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[40:43], v[196:199], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[48:51], v[212:215], v93, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v93, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v93, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[52:55], v[228:231], v93, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[60:63], a[104:107], v93, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v93, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[56:59], v[228:231], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[96:99], a[64:67], a[104:107], v93, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[64:67], v[240:243], v93, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[52:55], v[216:219], v92, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v92, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v92, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v92, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[64:67], v[236:239], v92, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[64:67], v[232:235], v92, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[20:23], v122 offset:35712
		ds_read_b128 v[24:27], v122 offset:35776
		ds_read_b128 v[28:31], v122 offset:35968
		ds_read_b128 v[32:35], v122 offset:36032
		ds_read_b128 v[36:39], v122 offset:36224
		ds_read_b128 v[40:43], v122 offset:36288
		ds_read_b128 v[44:47], v122 offset:36480
		ds_read_b128 v[48:51], v122 offset:36544
		ds_write_b32 v60, v1 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[12:13], v55 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[4:7], a[108:111], v12, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], a[4:7], a[112:115], v12, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], a[12:15], a[128:131], v12, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[12:15], a[124:127], v12, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[8:11], a[108:111], v12, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[8:11], a[112:115], v12, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[16:19], a[128:131], v12, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[16:19], a[124:127], v12, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], a[4:7], a[116:119], v13, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], a[4:7], a[120:123], v13, v94 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], a[12:15], a[136:139], v13, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[36:39], a[12:15], a[132:135], v13, v94 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[8:11], a[116:119], v13, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], a[8:11], a[120:123], v13, v94 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], a[16:19], a[136:139], v13, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[16:19], a[132:135], v13, v94 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], a[20:23], a[148:151], v13, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], a[20:23], a[152:155], v13, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[44:47], a[28:31], a[168:171], v13, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], a[28:31], a[164:167], v13, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[24:27], a[148:151], v13, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], a[24:27], a[152:155], v13, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], a[32:35], a[168:171], v13, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[32:35], a[164:167], v13, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[20:23], a[140:143], v12, v95 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], a[20:23], a[144:147], v12, v95 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], a[28:31], a[160:163], v12, v95 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[28:31], a[156:159], v12, v95 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[24:27], a[140:143], v12, v95 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[24:27], a[144:147], v12, v95 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[32:35], a[160:163], v12, v95 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[32:35], a[156:159], v12, v95 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[20:23], a[36:39], a[172:175], v12, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], a[36:39], a[176:179], v12, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], a[44:47], a[192:195], v12, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[20:23], a[44:47], a[188:191], v12, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], a[40:43], a[172:175], v12, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], a[40:43], a[176:179], v12, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], a[48:51], a[192:195], v12, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], a[48:51], a[188:191], v12, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], a[36:39], a[180:183], v13, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[44:47], a[36:39], a[184:187], v13, v96 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[44:47], a[44:47], a[200:203], v13, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], a[44:47], a[196:199], v13, v96 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], a[40:43], a[180:183], v13, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[48:51], a[40:43], a[184:187], v13, v96 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[48:51], a[48:51], a[200:203], v13, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], a[48:51], a[196:199], v13, v96 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], a[52:55], a[212:215], v13, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[44:47], a[52:55], a[216:219], v13, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], a[60:63], a[232:235], v13, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], a[60:63], a[228:231], v13, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], a[56:59], a[212:215], v13, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[48:51], a[56:59], a[216:219], v13, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[48:51], a[64:67], a[232:235], v13, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], a[64:67], a[228:231], v13, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[20:23], a[52:55], a[204:207], v12, v97 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], a[52:55], a[208:211], v12, v97 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[28:31], a[60:63], a[224:227], v12, v97 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[20:23], a[60:63], a[220:223], v12, v97 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], a[56:59], a[204:207], v12, v97 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], a[56:59], a[208:211], v12, v97 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], a[64:67], a[224:227], v12, v97 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[24:27], a[64:67], a[220:223], v12, v97 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v121 offset:33760
		ds_read_b128 v[24:27], v121 offset:33824
		ds_read_b128 v[28:31], v121 offset:34016
		ds_read_b128 v[32:35], v121 offset:34080
		ds_read_b128 v[36:39], v121 offset:34272
		ds_read_b128 v[40:43], v121 offset:34336
		ds_read_b128 v[44:47], v121 offset:34528
		ds_read_b128 v[48:51], v121 offset:34592
		ds_read_b128 v[56:59], v121 offset:50656
		ds_read_b128 v[64:67], v121 offset:50720
		ds_read_b128 v[68:71], v121 offset:50912
		ds_read_b128 v[72:75], v121 offset:50976
		ds_read_b128 v[76:79], v121 offset:51168
		ds_read_b128 v[80:83], v121 offset:51232
		ds_read_b128 v[88:91], v121 offset:51424
		ds_read_b128 v[92:95], v121 offset:51488
		ds_read_b128 v[100:103], v122 offset:18848
		ds_read_b128 v[104:107], v122 offset:18912
		ds_read_b128 v[108:111], v122 offset:19104
		ds_read_b128 v[112:115], v122 offset:19168
		ds_read_b128 v[116:119], v122 offset:19360
		ds_read_b128 v[124:127], v122 offset:19424
		ds_read_b128 v[244:247], v122 offset:19616
		ds_read_b128 v[248:251], v122 offset:19680
		ds_write_b64 v98, v[8:9] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v60, v4 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v16 offset:3904
		ds_read_b64_tr_b8 v[12:13], v16 offset:4032
		ds_read_b64_tr_b8 v[52:53], v55 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[100:103], v[20:23], v[84:87], v52, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[20:23], a[100:103], v52, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[108:111], v[28:31], v[140:143], v52, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[100:103], v[28:31], v[136:139], v52, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[104:107], v[24:27], v[84:87], v52, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[112:115], v[24:27], a[100:103], v52, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[112:115], v[32:35], v[140:143], v52, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[104:107], v[32:35], v[136:139], v52, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[116:119], v[20:23], v[128:131], v53, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[244:247], v[20:23], v[132:135], v53, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[244:247], v[28:31], v[148:151], v53, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[116:119], v[28:31], v[144:147], v53, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[124:127], v[24:27], v[128:131], v53, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[248:251], v[24:27], v[132:135], v53, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[248:251], v[32:35], v[148:151], v53, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[124:127], v[32:35], v[144:147], v53, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[116:119], v[36:39], v[160:163], v53, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[244:247], v[36:39], v[164:167], v53, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[44:47], v[180:183], v53, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[116:119], v[44:47], v[176:179], v53, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[124:127], v[40:43], v[160:163], v53, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[248:251], v[40:43], v[164:167], v53, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[248:251], v[48:51], v[180:183], v53, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[124:127], v[48:51], v[176:179], v53, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[100:103], v[36:39], v[152:155], v52, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[108:111], v[36:39], v[156:159], v52, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[108:111], v[44:47], v[172:175], v52, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[100:103], v[44:47], v[168:171], v52, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[104:107], v[40:43], v[152:155], v52, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[112:115], v[40:43], v[156:159], v52, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[112:115], v[48:51], v[172:175], v52, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[104:107], v[48:51], v[168:171], v52, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[100:103], v[56:59], v[184:187], v52, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[108:111], v[56:59], v[188:191], v52, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[108:111], v[68:71], v[204:207], v52, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[100:103], v[68:71], v[200:203], v52, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[104:107], v[64:67], v[184:187], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[112:115], v[64:67], v[188:191], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[112:115], v[72:75], v[204:207], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[104:107], v[72:75], v[200:203], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[116:119], v[56:59], v[192:195], v53, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[244:247], v[56:59], v[196:199], v53, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[68:71], v[212:215], v53, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[116:119], v[68:71], v[208:211], v53, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[124:127], v[64:67], v[192:195], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[248:251], v[64:67], v[196:199], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[248:251], v[72:75], v[212:215], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[124:127], v[72:75], v[208:211], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[116:119], v[76:79], v[224:227], v53, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[76:79], v[228:231], v53, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[244:247], v[88:91], a[104:107], v53, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[116:119], v[88:91], v[240:243], v53, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[124:127], v[80:83], v[224:227], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[248:251], v[80:83], v[228:231], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[248:251], v[92:95], a[104:107], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[124:127], v[92:95], v[240:243], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[100:103], v[76:79], v[216:219], v52, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[108:111], v[76:79], v[220:223], v52, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[108:111], v[88:91], v[236:239], v52, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[100:103], v[88:91], v[232:235], v52, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[104:107], v[80:83], v[216:219], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[112:115], v[80:83], v[220:223], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[112:115], v[92:95], v[236:239], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[104:107], v[92:95], v[232:235], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v122 offset:52576
		ds_read_b128 v[100:103], v122 offset:52640
		ds_read_b128 v[104:107], v122 offset:52832
		ds_read_b128 v[108:111], v122 offset:52896
		ds_read_b128 v[112:115], v122 offset:53088
		ds_read_b128 v[116:119], v122 offset:53152
		ds_read_b128 v[124:127], v122 offset:53344
		ds_read_b128 v[244:247], v122 offset:53408
		ds_write_b32 v60, v7 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[52:53], v55 offset:5952
		s_mul_i32 s0, s16, s13
		v_cvt_pk_bf16_f32 v60, v84, v85
		v_cvt_pk_bf16_f32 v61, v86, v87
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v4, a101
		v_cvt_pk_bf16_f32 v84, v1, v4
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v4, a103
		v_cvt_pk_bf16_f32 v85, v1, v4
		v_cvt_pk_bf16_f32 v120, v128, v129
		v_cvt_pk_bf16_f32 v121, v130, v131
		v_cvt_pk_bf16_f32 v128, v132, v133
		v_cvt_pk_bf16_f32 v129, v134, v135
		v_cvt_pk_bf16_f32 v62, v136, v137
		v_cvt_pk_bf16_f32 v63, v138, v139
		v_cvt_pk_bf16_f32 v86, v140, v141
		v_cvt_pk_bf16_f32 v87, v142, v143
		v_cvt_pk_bf16_f32 v122, v144, v145
		v_cvt_pk_bf16_f32 v123, v146, v147
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
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v4, a105
		v_cvt_pk_bf16_f32 v178, v1, v4
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v4, a107
		v_cvt_pk_bf16_f32 v179, v1, v4
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[60:63]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[120:123] offset:8192
		ds_write_b128 v0, v[128:131] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v1, 9, v14
		v_accvgpr_read_b32 v4, a0
		v_lshl_add_u32 v1, v4, 4, v1
		v_lshl_add_u32 v1, v11, 13, v1
		v_lshlrev_b32_e32 v4, 12, v15
		v_accvgpr_read_b32 v7, a1
		v_add3_u32 v1, v1, v4, v7
		ds_read_b128 v[60:63], v1
		ds_read_b128 v[84:87], v1 offset:256
		ds_read_b128 v[120:123], v1 offset:2048
		ds_read_b128 v[128:131], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[132:135]
		ds_write_b128 v0, v[136:139] offset:4096
		ds_write_b128 v0, v[140:143] offset:8192
		ds_write_b128 v0, v[144:147] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[132:135], v1
		ds_read_b128 v[136:139], v1 offset:256
		ds_read_b128 v[140:143], v1 offset:2048
		ds_read_b128 v[144:147], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[148:151]
		ds_write_b128 v0, v[152:155] offset:4096
		ds_write_b128 v0, v[156:159] offset:8192
		ds_write_b128 v0, v[160:163] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[148:151], v1
		ds_read_b128 v[152:155], v1 offset:256
		ds_read_b128 v[156:159], v1 offset:2048
		ds_read_b128 v[160:163], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[164:167]
		ds_write_b128 v0, v[168:171] offset:4096
		ds_write_b128 v0, v[172:175] offset:8192
		ds_write_b128 v0, v[176:179] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[164:167], v1
		ds_read_b128 v[168:171], v1 offset:256
		ds_read_b128 v[172:175], v1 offset:2048
		ds_read_b128 v[176:179], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s0, s0, 1
		s_add_u32 s8, s6, s0
		s_addc_u32 s9, s7, 0
		s_mov_b32 s10, s42
		s_mov_b32 s11, s43
		v_mov_b64_e32 v[180:181], v[60:61]
		v_mov_b64_e32 v[182:183], v[84:85]
		s_lshl_b32 s0, s12, 9
		v_mul_lo_u32 v4, s13, v2
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v7, s13, v3
		v_lshlrev_b32_e32 v7, 3, v7
		v_add3_u32 v10, s0, v4, v7
		v_mul_lo_u32 v14, s13, v5
		v_lshlrev_b32_e32 v14, 2, v14
		v_mul_lo_u32 v15, s13, v6
		v_lshlrev_b32_e32 v15, 1, v15
		v_add3_u32 v10, v10, v14, v15
		v_lshlrev_b32_e32 v11, 7, v11
		v_add3_u32 v10, v10, v17, v11
		v_add3_u32 v10, v10, v18, v19
		buffer_store_dwordx4 v[180:183], v10, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[180:181], v[120:121]
		v_mov_b64_e32 v[182:183], v[128:129]
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v10, 16, v6
		v_lshlrev_b32_e32 v5, 1, v5
		v_xor_b32_e32 v10, v10, v5
		v_xor_b32_e32 v10, v3, v10
		v_xor_b32_e32 v10, v2, v10
		v_mul_lo_u32 v10, s13, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v16, s0, v10
		v_add3_u32 v16, v16, v17, v11
		v_add3_u32 v16, v16, v18, v19
		buffer_store_dwordx4 v[180:183], v16, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[180:181], v[62:63]
		v_mov_b64_e32 v[182:183], v[86:87]
		v_add_u32_e32 v16, 32, v6
		v_xor_b32_e32 v16, v16, v5
		v_xor_b32_e32 v16, v3, v16
		v_xor_b32_e32 v16, v2, v16
		v_mul_lo_u32 v16, s13, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v54, s0, v16
		v_add3_u32 v54, v54, v17, v11
		v_add3_u32 v54, v54, v18, v19
		buffer_store_dwordx4 v[180:183], v54, s[8:11], 0 offen
		v_mov_b64_e32 v[60:61], v[122:123]
		v_mov_b64_e32 v[62:63], v[130:131]
		v_add_u32_e32 v54, 48, v6
		v_xor_b32_e32 v54, v54, v5
		v_xor_b32_e32 v54, v3, v54
		v_xor_b32_e32 v54, v2, v54
		v_mul_lo_u32 v54, s13, v54
		v_lshlrev_b32_e32 v54, 1, v54
		v_add_u32_e32 v55, s0, v54
		v_add3_u32 v55, v55, v17, v11
		v_add3_u32 v55, v55, v18, v19
		buffer_store_dwordx4 v[60:63], v55, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[132:133]
		v_mov_b64_e32 v[62:63], v[136:137]
		v_add_u32_e32 v55, 64, v6
		v_xor_b32_e32 v55, v55, v5
		v_xor_b32_e32 v55, v3, v55
		v_xor_b32_e32 v55, v2, v55
		v_mul_lo_u32 v55, s13, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v84, s0, v55
		v_add3_u32 v84, v84, v17, v11
		v_add3_u32 v84, v84, v18, v19
		buffer_store_dwordx4 v[60:63], v84, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[140:141]
		v_mov_b64_e32 v[62:63], v[144:145]
		v_add_u32_e32 v84, 0x50, v6
		v_xor_b32_e32 v84, v84, v5
		v_xor_b32_e32 v84, v3, v84
		v_xor_b32_e32 v84, v2, v84
		v_mul_lo_u32 v84, s13, v84
		v_lshlrev_b32_e32 v84, 1, v84
		v_add_u32_e32 v85, s0, v84
		v_add3_u32 v85, v85, v17, v11
		v_add3_u32 v85, v85, v18, v19
		buffer_store_dwordx4 v[60:63], v85, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[134:135]
		v_mov_b64_e32 v[62:63], v[138:139]
		v_add_u32_e32 v85, 0x60, v6
		v_xor_b32_e32 v85, v85, v5
		v_xor_b32_e32 v85, v3, v85
		v_xor_b32_e32 v85, v2, v85
		v_mul_lo_u32 v85, s13, v85
		v_lshlrev_b32_e32 v85, 1, v85
		v_add_u32_e32 v86, s0, v85
		v_add3_u32 v86, v86, v17, v11
		v_add3_u32 v86, v86, v18, v19
		buffer_store_dwordx4 v[60:63], v86, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[142:143]
		v_mov_b64_e32 v[62:63], v[146:147]
		v_add_u32_e32 v86, 0x70, v6
		v_xor_b32_e32 v86, v86, v5
		v_xor_b32_e32 v86, v3, v86
		v_xor_b32_e32 v86, v2, v86
		v_mul_lo_u32 v86, s13, v86
		v_lshlrev_b32_e32 v86, 1, v86
		v_add_u32_e32 v87, s0, v86
		v_add3_u32 v87, v87, v17, v11
		v_add3_u32 v87, v87, v18, v19
		buffer_store_dwordx4 v[60:63], v87, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[148:149]
		v_mov_b64_e32 v[62:63], v[152:153]
		v_add_u32_e32 v87, 0x80, v6
		v_xor_b32_e32 v87, v87, v5
		v_xor_b32_e32 v87, v3, v87
		v_xor_b32_e32 v87, v2, v87
		v_mul_lo_u32 v87, s13, v87
		v_lshlrev_b32_e32 v87, 1, v87
		v_add_u32_e32 v120, s0, v87
		v_add3_u32 v120, v120, v17, v11
		v_add3_u32 v120, v120, v18, v19
		buffer_store_dwordx4 v[60:63], v120, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[156:157]
		v_mov_b64_e32 v[62:63], v[160:161]
		v_add_u32_e32 v120, 0x90, v6
		v_xor_b32_e32 v120, v120, v5
		v_xor_b32_e32 v120, v3, v120
		v_xor_b32_e32 v120, v2, v120
		v_mul_lo_u32 v120, s13, v120
		v_lshlrev_b32_e32 v120, 1, v120
		v_add_u32_e32 v121, s0, v120
		v_add3_u32 v121, v121, v17, v11
		v_add3_u32 v121, v121, v18, v19
		buffer_store_dwordx4 v[60:63], v121, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[150:151]
		v_mov_b64_e32 v[62:63], v[154:155]
		v_add_u32_e32 v121, 0xa0, v6
		v_xor_b32_e32 v121, v121, v5
		v_xor_b32_e32 v121, v3, v121
		v_xor_b32_e32 v121, v2, v121
		v_mul_lo_u32 v121, s13, v121
		v_lshlrev_b32_e32 v121, 1, v121
		v_add_u32_e32 v122, s0, v121
		v_add3_u32 v122, v122, v17, v11
		v_add3_u32 v122, v122, v18, v19
		buffer_store_dwordx4 v[60:63], v122, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[158:159]
		v_mov_b64_e32 v[62:63], v[162:163]
		v_add_u32_e32 v122, 0xb0, v6
		v_xor_b32_e32 v122, v122, v5
		v_xor_b32_e32 v122, v3, v122
		v_xor_b32_e32 v122, v2, v122
		v_mul_lo_u32 v122, s13, v122
		v_lshlrev_b32_e32 v122, 1, v122
		v_add_u32_e32 v123, s0, v122
		v_add3_u32 v123, v123, v17, v11
		v_add3_u32 v123, v123, v18, v19
		buffer_store_dwordx4 v[60:63], v123, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[164:165]
		v_mov_b64_e32 v[62:63], v[168:169]
		v_add_u32_e32 v123, 0xc0, v6
		v_xor_b32_e32 v123, v123, v5
		v_xor_b32_e32 v123, v3, v123
		v_xor_b32_e32 v123, v2, v123
		v_mul_lo_u32 v123, s13, v123
		v_lshlrev_b32_e32 v123, 1, v123
		v_add_u32_e32 v128, s0, v123
		v_add3_u32 v128, v128, v17, v11
		v_add3_u32 v128, v128, v18, v19
		buffer_store_dwordx4 v[60:63], v128, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[172:173]
		v_mov_b64_e32 v[62:63], v[176:177]
		v_add_u32_e32 v128, 0xd0, v6
		v_xor_b32_e32 v128, v128, v5
		v_xor_b32_e32 v128, v3, v128
		v_xor_b32_e32 v128, v2, v128
		v_mul_lo_u32 v128, s13, v128
		v_lshlrev_b32_e32 v128, 1, v128
		v_add_u32_e32 v129, s0, v128
		v_add3_u32 v129, v129, v17, v11
		v_add3_u32 v129, v129, v18, v19
		buffer_store_dwordx4 v[60:63], v129, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[166:167]
		v_mov_b64_e32 v[62:63], v[170:171]
		v_add_u32_e32 v129, 0xe0, v6
		v_xor_b32_e32 v129, v129, v5
		v_xor_b32_e32 v129, v3, v129
		v_xor_b32_e32 v129, v2, v129
		v_mul_lo_u32 v129, s13, v129
		v_lshlrev_b32_e32 v129, 1, v129
		v_add_u32_e32 v130, s0, v129
		v_add3_u32 v130, v130, v17, v11
		v_add3_u32 v130, v130, v18, v19
		buffer_store_dwordx4 v[60:63], v130, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[174:175]
		v_mov_b64_e32 v[62:63], v[178:179]
		v_add_u32_e32 v6, 0xf0, v6
		v_xor_b32_e32 v5, v6, v5
		v_xor_b32_e32 v3, v3, v5
		v_xor_b32_e32 v2, v2, v3
		v_mul_lo_u32 v2, s13, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v3, s0, v2
		v_add3_u32 v3, v3, v17, v11
		v_add3_u32 v3, v3, v18, v19
		buffer_store_dwordx4 v[60:63], v3, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[20:23], a[108:111], v52, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[104:107], v[20:23], a[112:115], v52, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[28:31], a[128:131], v52, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[28:31], a[124:127], v52, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[24:27], a[108:111], v52, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[24:27], a[112:115], v52, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[32:35], a[128:131], v52, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[32:35], a[124:127], v52, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[112:115], v[20:23], a[116:119], v53, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[124:127], v[20:23], a[120:123], v53, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[124:127], v[28:31], a[136:139], v53, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[28:31], a[132:135], v53, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[116:119], v[24:27], a[116:119], v53, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[244:247], v[24:27], a[120:123], v53, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[244:247], v[32:35], a[136:139], v53, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[116:119], v[32:35], a[132:135], v53, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[36:39], a[148:151], v53, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[124:127], v[36:39], a[152:155], v53, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[124:127], v[44:47], a[168:171], v53, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[44:47], a[164:167], v53, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[116:119], v[40:43], a[148:151], v53, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[244:247], v[40:43], a[152:155], v53, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[244:247], v[48:51], a[168:171], v53, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[48:51], a[164:167], v53, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[36:39], a[140:143], v52, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[36:39], a[144:147], v52, v9 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[44:47], a[160:163], v52, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[44:47], a[156:159], v52, v9 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[40:43], a[140:143], v52, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[40:43], a[144:147], v52, v9 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[48:51], a[160:163], v52, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[48:51], a[156:159], v52, v9 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[56:59], a[172:175], v52, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[56:59], a[176:179], v52, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[68:71], a[192:195], v52, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[68:71], a[188:191], v52, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[64:67], a[172:175], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[64:67], a[176:179], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[72:75], a[192:195], v52, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[72:75], a[188:191], v52, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[56:59], a[180:183], v53, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[124:127], v[56:59], a[184:187], v53, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[68:71], a[200:203], v53, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[68:71], a[196:199], v53, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[64:67], a[180:183], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[244:247], v[64:67], a[184:187], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[244:247], v[72:75], a[200:203], v53, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[116:119], v[72:75], a[196:199], v53, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[76:79], a[212:215], v53, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[76:79], a[216:219], v53, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[88:91], a[232:235], v53, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[112:115], v[88:91], a[228:231], v53, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[116:119], v[80:83], a[212:215], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[244:247], v[80:83], a[216:219], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[244:247], v[92:95], a[232:235], v53, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[116:119], v[92:95], a[228:231], v53, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[76:79], a[204:207], v52, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[76:79], a[208:211], v52, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[104:107], v[88:91], a[224:227], v52, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[96:99], v[88:91], a[220:223], v52, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[80:83], a[204:207], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[80:83], a[208:211], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[108:111], v[92:95], a[224:227], v52, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[92:95], a[220:223], v52, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v3, a108
		v_accvgpr_read_b32 v5, a109
		v_cvt_pk_bf16_f32 v20, v3, v5
		v_accvgpr_read_b32 v3, a110
		v_accvgpr_read_b32 v5, a111
		v_cvt_pk_bf16_f32 v21, v3, v5
		v_accvgpr_read_b32 v3, a112
		v_accvgpr_read_b32 v5, a113
		v_cvt_pk_bf16_f32 v24, v3, v5
		v_accvgpr_read_b32 v3, a114
		v_accvgpr_read_b32 v5, a115
		v_cvt_pk_bf16_f32 v25, v3, v5
		v_accvgpr_read_b32 v3, a116
		v_accvgpr_read_b32 v5, a117
		v_cvt_pk_bf16_f32 v28, v3, v5
		v_accvgpr_read_b32 v3, a118
		v_accvgpr_read_b32 v5, a119
		v_cvt_pk_bf16_f32 v29, v3, v5
		v_accvgpr_read_b32 v3, a120
		v_accvgpr_read_b32 v5, a121
		v_cvt_pk_bf16_f32 v32, v3, v5
		v_accvgpr_read_b32 v3, a122
		v_accvgpr_read_b32 v5, a123
		v_cvt_pk_bf16_f32 v33, v3, v5
		v_accvgpr_read_b32 v3, a124
		v_accvgpr_read_b32 v5, a125
		v_cvt_pk_bf16_f32 v22, v3, v5
		v_accvgpr_read_b32 v3, a126
		v_accvgpr_read_b32 v5, a127
		v_cvt_pk_bf16_f32 v23, v3, v5
		v_accvgpr_read_b32 v3, a128
		v_accvgpr_read_b32 v5, a129
		v_cvt_pk_bf16_f32 v26, v3, v5
		v_accvgpr_read_b32 v3, a130
		v_accvgpr_read_b32 v5, a131
		v_cvt_pk_bf16_f32 v27, v3, v5
		v_accvgpr_read_b32 v3, a132
		v_accvgpr_read_b32 v5, a133
		v_cvt_pk_bf16_f32 v30, v3, v5
		v_accvgpr_read_b32 v3, a134
		v_accvgpr_read_b32 v5, a135
		v_cvt_pk_bf16_f32 v31, v3, v5
		v_accvgpr_read_b32 v3, a136
		v_accvgpr_read_b32 v5, a137
		v_cvt_pk_bf16_f32 v34, v3, v5
		v_accvgpr_read_b32 v3, a138
		v_accvgpr_read_b32 v5, a139
		v_cvt_pk_bf16_f32 v35, v3, v5
		v_accvgpr_read_b32 v3, a140
		v_accvgpr_read_b32 v5, a141
		v_cvt_pk_bf16_f32 v36, v3, v5
		v_accvgpr_read_b32 v3, a142
		v_accvgpr_read_b32 v5, a143
		v_cvt_pk_bf16_f32 v37, v3, v5
		v_accvgpr_read_b32 v3, a144
		v_accvgpr_read_b32 v5, a145
		v_cvt_pk_bf16_f32 v40, v3, v5
		v_accvgpr_read_b32 v3, a146
		v_accvgpr_read_b32 v5, a147
		v_cvt_pk_bf16_f32 v41, v3, v5
		v_accvgpr_read_b32 v3, a148
		v_accvgpr_read_b32 v5, a149
		v_cvt_pk_bf16_f32 v44, v3, v5
		v_accvgpr_read_b32 v3, a150
		v_accvgpr_read_b32 v5, a151
		v_cvt_pk_bf16_f32 v45, v3, v5
		v_accvgpr_read_b32 v3, a152
		v_accvgpr_read_b32 v5, a153
		v_cvt_pk_bf16_f32 v48, v3, v5
		v_accvgpr_read_b32 v3, a154
		v_accvgpr_read_b32 v5, a155
		v_cvt_pk_bf16_f32 v49, v3, v5
		v_accvgpr_read_b32 v3, a156
		v_accvgpr_read_b32 v5, a157
		v_cvt_pk_bf16_f32 v38, v3, v5
		v_accvgpr_read_b32 v3, a158
		v_accvgpr_read_b32 v5, a159
		v_cvt_pk_bf16_f32 v39, v3, v5
		v_accvgpr_read_b32 v3, a160
		v_accvgpr_read_b32 v5, a161
		v_cvt_pk_bf16_f32 v42, v3, v5
		v_accvgpr_read_b32 v3, a162
		v_accvgpr_read_b32 v5, a163
		v_cvt_pk_bf16_f32 v43, v3, v5
		v_accvgpr_read_b32 v3, a164
		v_accvgpr_read_b32 v5, a165
		v_cvt_pk_bf16_f32 v46, v3, v5
		v_accvgpr_read_b32 v3, a166
		v_accvgpr_read_b32 v5, a167
		v_cvt_pk_bf16_f32 v47, v3, v5
		v_accvgpr_read_b32 v3, a168
		v_accvgpr_read_b32 v5, a169
		v_cvt_pk_bf16_f32 v50, v3, v5
		v_accvgpr_read_b32 v3, a170
		v_accvgpr_read_b32 v5, a171
		v_cvt_pk_bf16_f32 v51, v3, v5
		v_accvgpr_read_b32 v3, a172
		v_accvgpr_read_b32 v5, a173
		v_cvt_pk_bf16_f32 v56, v3, v5
		v_accvgpr_read_b32 v3, a174
		v_accvgpr_read_b32 v5, a175
		v_cvt_pk_bf16_f32 v57, v3, v5
		v_accvgpr_read_b32 v3, a176
		v_accvgpr_read_b32 v5, a177
		v_cvt_pk_bf16_f32 v60, v3, v5
		v_accvgpr_read_b32 v3, a178
		v_accvgpr_read_b32 v5, a179
		v_cvt_pk_bf16_f32 v61, v3, v5
		v_accvgpr_read_b32 v3, a180
		v_accvgpr_read_b32 v5, a181
		v_cvt_pk_bf16_f32 v64, v3, v5
		v_accvgpr_read_b32 v3, a182
		v_accvgpr_read_b32 v5, a183
		v_cvt_pk_bf16_f32 v65, v3, v5
		v_accvgpr_read_b32 v3, a184
		v_accvgpr_read_b32 v5, a185
		v_cvt_pk_bf16_f32 v68, v3, v5
		v_accvgpr_read_b32 v3, a186
		v_accvgpr_read_b32 v5, a187
		v_cvt_pk_bf16_f32 v69, v3, v5
		v_accvgpr_read_b32 v3, a188
		v_accvgpr_read_b32 v5, a189
		v_cvt_pk_bf16_f32 v58, v3, v5
		v_accvgpr_read_b32 v3, a190
		v_accvgpr_read_b32 v5, a191
		v_cvt_pk_bf16_f32 v59, v3, v5
		v_accvgpr_read_b32 v3, a192
		v_accvgpr_read_b32 v5, a193
		v_cvt_pk_bf16_f32 v62, v3, v5
		v_accvgpr_read_b32 v3, a194
		v_accvgpr_read_b32 v5, a195
		v_cvt_pk_bf16_f32 v63, v3, v5
		v_accvgpr_read_b32 v3, a196
		v_accvgpr_read_b32 v5, a197
		v_cvt_pk_bf16_f32 v66, v3, v5
		v_accvgpr_read_b32 v3, a198
		v_accvgpr_read_b32 v5, a199
		v_cvt_pk_bf16_f32 v67, v3, v5
		v_accvgpr_read_b32 v3, a200
		v_accvgpr_read_b32 v5, a201
		v_cvt_pk_bf16_f32 v70, v3, v5
		v_accvgpr_read_b32 v3, a202
		v_accvgpr_read_b32 v5, a203
		v_cvt_pk_bf16_f32 v71, v3, v5
		v_accvgpr_read_b32 v3, a204
		v_accvgpr_read_b32 v5, a205
		v_cvt_pk_bf16_f32 v72, v3, v5
		v_accvgpr_read_b32 v3, a206
		v_accvgpr_read_b32 v5, a207
		v_cvt_pk_bf16_f32 v73, v3, v5
		v_accvgpr_read_b32 v3, a208
		v_accvgpr_read_b32 v5, a209
		v_cvt_pk_bf16_f32 v76, v3, v5
		v_accvgpr_read_b32 v3, a210
		v_accvgpr_read_b32 v5, a211
		v_cvt_pk_bf16_f32 v77, v3, v5
		v_accvgpr_read_b32 v3, a212
		v_accvgpr_read_b32 v5, a213
		v_cvt_pk_bf16_f32 v80, v3, v5
		v_accvgpr_read_b32 v3, a214
		v_accvgpr_read_b32 v5, a215
		v_cvt_pk_bf16_f32 v81, v3, v5
		v_accvgpr_read_b32 v3, a216
		v_accvgpr_read_b32 v5, a217
		v_cvt_pk_bf16_f32 v88, v3, v5
		v_accvgpr_read_b32 v3, a218
		v_accvgpr_read_b32 v5, a219
		v_cvt_pk_bf16_f32 v89, v3, v5
		v_accvgpr_read_b32 v3, a220
		v_accvgpr_read_b32 v5, a221
		v_cvt_pk_bf16_f32 v74, v3, v5
		v_accvgpr_read_b32 v3, a222
		v_accvgpr_read_b32 v5, a223
		v_cvt_pk_bf16_f32 v75, v3, v5
		v_accvgpr_read_b32 v3, a224
		v_accvgpr_read_b32 v5, a225
		v_cvt_pk_bf16_f32 v78, v3, v5
		v_accvgpr_read_b32 v3, a226
		v_accvgpr_read_b32 v5, a227
		v_cvt_pk_bf16_f32 v79, v3, v5
		v_accvgpr_read_b32 v3, a228
		v_accvgpr_read_b32 v5, a229
		v_cvt_pk_bf16_f32 v82, v3, v5
		v_accvgpr_read_b32 v3, a230
		v_accvgpr_read_b32 v5, a231
		v_cvt_pk_bf16_f32 v83, v3, v5
		v_accvgpr_read_b32 v3, a232
		v_accvgpr_read_b32 v5, a233
		v_cvt_pk_bf16_f32 v90, v3, v5
		v_accvgpr_read_b32 v3, a234
		v_accvgpr_read_b32 v5, a235
		v_cvt_pk_bf16_f32 v91, v3, v5
		ds_write_b128 v0, v[20:23]
		ds_write_b128 v0, v[24:27] offset:4096
		ds_write_b128 v0, v[28:31] offset:8192
		ds_write_b128 v0, v[32:35] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v1
		ds_read_b128 v[24:27], v1 offset:256
		ds_read_b128 v[28:31], v1 offset:2048
		ds_read_b128 v[32:35], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[36:39]
		ds_write_b128 v0, v[40:43] offset:4096
		ds_write_b128 v0, v[44:47] offset:8192
		ds_write_b128 v0, v[48:51] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v1
		ds_read_b128 v[40:43], v1 offset:256
		ds_read_b128 v[44:47], v1 offset:2048
		ds_read_b128 v[48:51], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[56:59]
		ds_write_b128 v0, v[60:63] offset:4096
		ds_write_b128 v0, v[64:67] offset:8192
		ds_write_b128 v0, v[68:71] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[56:59], v1
		ds_read_b128 v[60:63], v1 offset:256
		ds_read_b128 v[64:67], v1 offset:2048
		ds_read_b128 v[68:71], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[72:75]
		ds_write_b128 v0, v[76:79] offset:4096
		ds_write_b128 v0, v[80:83] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v1
		ds_read_b128 v[76:79], v1 offset:256
		ds_read_b128 v[80:83], v1 offset:2048
		ds_read_b128 v[88:91], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[92:93], v[20:21]
		v_mov_b64_e32 v[94:95], v[24:25]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v4, v7
		v_add3_u32 v0, v0, v14, v15
		v_add3_u32 v0, v0, v17, v11
		v_add3_u32 v0, v0, v18, v19
		buffer_store_dwordx4 v[92:95], v0, s[8:11], 0 offen
		v_mov_b64_e32 v[4:5], v[28:29]
		v_mov_b64_e32 v[6:7], v[32:33]
		v_add3_u32 v0, v17, v11, v18
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v10, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[22:23]
		v_mov_b64_e32 v[6:7], v[26:27]
		v_add3_u32 v1, v16, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[30:31]
		v_mov_b64_e32 v[6:7], v[34:35]
		v_add3_u32 v0, v54, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[36:37]
		v_mov_b64_e32 v[6:7], v[40:41]
		v_add3_u32 v0, v17, v11, v18
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v55, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[44:45]
		v_mov_b64_e32 v[6:7], v[48:49]
		v_add3_u32 v1, v84, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[38:39]
		v_mov_b64_e32 v[6:7], v[42:43]
		v_add3_u32 v0, v85, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[46:47]
		v_mov_b64_e32 v[6:7], v[50:51]
		v_add3_u32 v0, v17, v11, v18
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v86, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[56:57]
		v_mov_b64_e32 v[6:7], v[60:61]
		v_add3_u32 v1, v87, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[64:65]
		v_mov_b64_e32 v[6:7], v[68:69]
		v_add3_u32 v0, v120, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[58:59]
		v_mov_b64_e32 v[6:7], v[62:63]
		v_add3_u32 v0, v17, v11, v18
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v121, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[66:67]
		v_mov_b64_e32 v[6:7], v[70:71]
		v_add3_u32 v1, v122, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[72:73]
		v_mov_b64_e32 v[6:7], v[76:77]
		v_add3_u32 v0, v123, v0, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[80:81]
		v_mov_b64_e32 v[6:7], v[88:89]
		v_add3_u32 v0, v17, v11, v18
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v128, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[74:75]
		v_mov_b64_e32 v[6:7], v[78:79]
		v_add3_u32 v1, v129, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[82:83]
		v_mov_b64_e32 v[6:7], v[90:91]
		v_add3_u32 v0, v2, v0, s0
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
		.amdhsa_next_free_sgpr 84
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
	.set .L_a4w4_kernel.numbered_sgpr, 84
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
    .sgpr_count:     84
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
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
