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
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_load_dword s17, s[0:1], 0x3c
		s_load_dword s18, s[0:1], 0x40
		v_mov_b32_e32 v1, 0x4f7ffffe
		s_add_i32 s12, s12, 0xff
		v_readfirstlane_b32 s19, v0
		s_cmp_lt_i32 s12, 0
		v_lshrrev_b32_e32 v2, 7, v0
		s_mov_b32 s28, 0xff
		v_mul_lo_u32 v3, s14, v2
		s_cselect_b32 s29, s28, 0
		v_lshlrev_b32_e32 v3, 1, v3
		s_add_i32 s12, s12, s29
		v_lshrrev_b32_e32 v4, 6, v0
		s_ashr_i32 s12, s12, 8
		v_and_b32_e32 v4, 1, v4
		s_add_i32 s13, s13, 0xff
		v_mul_lo_u32 v5, s14, v4
		s_cmp_lt_i32 s13, 0
		v_add_u32_e32 v6, v3, v5
		s_cselect_b32 s28, s28, 0
		v_lshrrev_b32_e32 v7, 5, v0
		s_add_i32 s13, s13, s28
		v_and_b32_e32 v8, 1, v7
		s_ashr_i32 s13, s13, 8
		v_mul_lo_u32 v9, s14, v8
		s_and_b32 s28, s16, 7
		v_lshlrev_b32_e32 v9, 6, v9
		s_lshr_b32 s16, s16, 3
		v_lshrrev_b32_e32 v10, 4, v0
		v_accvgpr_write_b32 a0, v10
		s_mul_i32 s28, s28, 32
		v_accvgpr_read_b32 v10, a0
		v_and_b32_e32 v10, 1, v10
		s_add_i32 s16, s28, s16
		v_mul_lo_u32 v11, s14, v10
		s_mul_i32 s13, s13, 4
		v_lshlrev_b32_e32 v11, 5, v11
		s_cmp_lt_i32 s16, 0
		v_add3_u32 v6, v6, v9, v11
		s_cselect_b32 s28, 1, 0
		s_xor_b32 s29, s16, -1
		v_lshrrev_b32_e32 v12, 3, v0
		s_add_i32 s29, s29, 1
		v_and_b32_e32 v13, 1, v12
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s28, s29, s16
		v_mul_lo_u32 v14, s14, v13
		s_cselect_b32 s29, 1, 0
		s_cmp_lt_i32 s13, 0
		v_lshlrev_b32_e32 v14, 4, v14
		s_cselect_b32 s30, 1, 0
		s_xor_b32 s31, s13, -1
		v_and_b32_e32 v15, 1, v0
		s_add_i32 s31, s31, 1
		v_lshlrev_b32_e32 v16, 4, v15
		s_cmp_lg_u32 s30, 0
		s_cselect_b32 s30, s31, s13
		v_mov_b32_e32 v17, s30
		s_xor_b32 s31, s30, -1
		v_cvt_f32_u32_e32 v17, v17
		s_add_i32 s31, s31, 1
		v_rcp_iflag_f32_e32 v17, v17
		s_mul_i32 s32, 12, s14
		v_mul_f32_e32 v17, v1, v17
		s_mul_i32 s33, 0x84, s14
		v_cvt_u32_f32_e32 v17, v17
		s_mul_i32 s34, 0x88, s14
		v_readfirstlane_b32 s35, v17
		s_mul_i32 s36, s31, s35
		v_add3_u32 v6, v6, v14, v16
		s_mul_hi_u32 s36, s35, s36
		v_lshrrev_b32_e32 v17, 2, v0
		s_add_i32 s35, s35, s36
		v_and_b32_e32 v17, 1, v17
		s_mul_hi_u32 s35, s28, s35
		v_lshlrev_b32_e32 v18, 6, v17
		s_mul_i32 s36, s35, s30
		v_lshrrev_b32_e32 v19, 1, v0
		s_xor_b32 s36, s36, -1
		v_and_b32_e32 v19, 1, v19
		s_add_i32 s36, s36, 1
		v_lshlrev_b32_e32 v20, 5, v19
		s_add_i32 s28, s28, s36
		v_add3_u32 v6, v6, v18, v20
		s_cmp_ge_u32 s28, s30
		v_add3_u32 v21, s32, v3, v5
		s_cselect_b32 s36, 1, 0
		s_add_i32 s37, s35, 1
		v_add3_u32 v21, v21, v9, v11
		s_cmp_lg_u32 s36, 0
		s_cselect_b32 s35, s37, s35
		v_add3_u32 v21, v21, v14, v16
		s_cselect_b32 s36, 1, 0
		s_add_i32 s37, s28, s31
		v_add3_u32 v21, v21, v18, v20
		s_cmp_lg_u32 s36, 0
		s_cselect_b32 s28, s37, s28
		v_add3_u32 v22, s33, v3, v5
		s_cmp_ge_u32 s28, s30
		v_add3_u32 v22, v22, v9, v11
		s_cselect_b32 s30, 1, 0
		s_add_i32 s36, s35, 1
		v_add3_u32 v22, v22, v14, v16
		s_cmp_lg_u32 s30, 0
		s_cselect_b32 s30, s36, s35
		v_add3_u32 v22, v22, v18, v20
		s_cselect_b32 s35, 1, 0
		s_xor_b32 s13, s16, s13
		v_add3_u32 v23, s34, v3, v5
		s_cmp_lt_i32 s13, 0
		v_add3_u32 v23, v23, v9, v11
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s16, s30, -1
		v_add3_u32 v23, v23, v14, v16
		s_add_i32 s16, s16, 1
		v_add3_u32 v23, v23, v18, v20
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s16, s30
		v_mul_lo_u32 v24, s15, v2
		s_mul_i32 s16, s13, 4
		v_lshlrev_b32_e32 v24, 1, v24
		s_xor_b32 s30, s16, -1
		v_mul_lo_u32 v25, s15, v4
		s_add_i32 s30, s30, 1
		v_add_u32_e32 v26, v24, v25
		s_add_i32 s12, s12, s30
		v_mul_lo_u32 v27, s15, v8
		s_cmp_lt_i32 s12, 4
		v_lshlrev_b32_e32 v27, 6, v27
		s_cselect_b32 s12, s12, 4
		v_mov_b32_e32 v28, s12
		s_add_i32 s30, s28, s31
		v_cvt_f32_u32_e32 v28, v28
		s_cmp_lg_u32 s35, 0
		s_cselect_b32 s28, s30, s28
		v_rcp_iflag_f32_e32 v28, v28
		s_xor_b32 s30, s28, -1
		v_mul_f32_e32 v1, v1, v28
		s_add_i32 s30, s30, 1
		v_cvt_u32_f32_e32 v1, v1
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s28, s30, s28
		v_readfirstlane_b32 s29, v1
		s_xor_b32 s30, s12, -1
		v_readfirstlane_b32 s31, v1
		s_add_i32 s30, s30, 1
		v_mul_lo_u32 v1, s15, v10
		s_mul_i32 s35, s30, s29
		v_lshlrev_b32_e32 v1, 5, v1
		s_mul_hi_u32 s35, s29, s35
		v_add3_u32 v26, v26, v27, v1
		s_add_i32 s29, s29, s35
		v_mul_lo_u32 v28, s15, v13
		s_mul_hi_u32 s29, s28, s29
		v_lshlrev_b32_e32 v28, 4, v28
		s_mul_i32 s29, s29, s12
		v_add3_u32 v26, v26, v28, v16
		s_xor_b32 s29, s29, -1
		v_add3_u32 v26, v26, v18, v20
		s_add_i32 s29, s29, 1
		v_add_u32_e32 v29, 0x80, v3
		s_add_i32 s29, s28, s29
		v_add_u32_e32 v29, v29, v5
		s_cmp_ge_u32 s29, s12
		v_add3_u32 v29, v29, v9, v11
		s_cselect_b32 s35, 1, 0
		s_add_i32 s36, s29, s30
		v_add3_u32 v29, v29, v14, v16
		s_cmp_lg_u32 s35, 0
		s_cselect_b32 s29, s36, s29
		v_add3_u32 v29, v29, v18, v20
		s_cmp_ge_u32 s29, s12
		v_add_u32_e32 v30, 0x80, v24
		s_cselect_b32 s35, 1, 0
		s_add_i32 s36, s29, s30
		v_add_u32_e32 v30, v30, v25
		s_cmp_lg_u32 s35, 0
		s_cselect_b32 s29, s36, s29
		v_add3_u32 v30, v30, v27, v1
		s_add_i32 s16, s16, s29
		v_add3_u32 v30, v30, v28, v16
		s_mul_i32 s35, s30, s31
		v_add3_u32 v30, v30, v18, v20
		s_mul_hi_u32 s35, s31, s35
		s_add_i32 s31, s31, s35
		s_mul_hi_u32 s31, s28, s31
		s_mul_i32 s35, s31, s12
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s28, s28, s35
		s_cmp_ge_u32 s28, s12
		s_cselect_b32 s35, 1, 0
		s_add_i32 s36, s31, 1
		s_cmp_lg_u32 s35, 0
		s_cselect_b32 s31, s36, s31
		s_cselect_b32 s35, 1, 0
		s_add_i32 s30, s28, s30
		s_cmp_lg_u32 s35, 0
		s_cselect_b32 s28, s30, s28
		s_cmp_ge_u32 s28, s12
		s_cselect_b32 s12, 1, 0
		s_add_i32 s28, s31, 1
		s_cmp_lg_u32 s12, 0
		s_cselect_b32 s12, s28, s31
		s_mul_i32 s16, s16, 0x100
		s_mul_i32 s28, s16, s14
		s_mul_i32 s30, s12, 0x100
		s_mul_i32 s30, s30, s15
		s_add_u32 s36, s2, s28
		s_addc_u32 s37, s3, 0
		s_mov_b32 s40, s36
		s_mov_b32 s41, s37
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_lshr_b32 s19, s19, 6
		s_mul_i32 s19, 0x420, s19
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_lshl_b32 s31, s14, 2
		v_add3_u32 v31, s31, v3, v5
		s_add_i32 s35, s19, 0x1080
		v_add3_u32 v31, v31, v9, v11
		s_mov_b32 m0, s35
		v_add3_u32 v31, v31, v14, v16
		s_lshl_b32 s36, s14, 3
		v_add3_u32 v31, v31, v18, v20
		buffer_load_dwordx4 v31, s[40:43], 0 offen lds
		v_add3_u32 v32, s36, v3, v5
		s_add_i32 s37, s19, 0x2100
		v_add3_u32 v32, v32, v9, v11
		s_mov_b32 m0, s37
		v_add3_u32 v32, v32, v14, v16
		s_add_i32 s38, s19, 0x3180
		v_add3_u32 v32, v32, v18, v20
		buffer_load_dwordx4 v32, s[40:43], 0 offen lds
		s_mov_b32 m0, s38
		s_lshl_b32 s39, s14, 7
		buffer_load_dwordx4 v21, s[40:43], 0 offen lds
		v_add3_u32 v33, s39, v3, v5
		s_add_i32 s44, s19, 0x4200
		v_add3_u32 v33, v33, v9, v11
		s_mov_b32 m0, s44
		v_add3_u32 v33, v33, v14, v16
		s_add_i32 s45, s19, 0x5280
		v_add3_u32 v33, v33, v18, v20
		buffer_load_dwordx4 v33, s[40:43], 0 offen lds
		s_mov_b32 m0, s45
		s_add_i32 s46, s19, 0x6300
		buffer_load_dwordx4 v22, s[40:43], 0 offen lds
		s_mov_b32 m0, s46
		s_mul_i32 s14, 0x8c, s14
		buffer_load_dwordx4 v23, s[40:43], 0 offen lds
		v_add3_u32 v34, s14, v3, v5
		s_add_i32 s47, s19, 0x7380
		v_add3_u32 v34, v34, v9, v11
		s_mov_b32 m0, s47
		v_add3_u32 v34, v34, v14, v16
		s_add_u32 s48, s4, s30
		s_addc_u32 s49, s5, 0
		s_mov_b32 s52, s48
		s_mov_b32 s53, s49
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		v_add3_u32 v34, v34, v18, v20
		buffer_load_dwordx4 v34, s[40:43], 0 offen lds
		s_add_i32 s48, s19, 0x107c0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v26, s[52:55], 0 offen lds
		s_lshl_b32 s49, s15, 2
		v_add3_u32 v35, s49, v24, v25
		s_add_i32 s50, s19, 0x11840
		v_add3_u32 v35, v35, v27, v1
		s_mov_b32 m0, s50
		v_add3_u32 v35, v35, v28, v16
		s_lshl_b32 s51, s15, 3
		v_add3_u32 v35, v35, v18, v20
		buffer_load_dwordx4 v35, s[52:55], 0 offen lds
		v_add3_u32 v36, s51, v24, v25
		s_add_i32 s56, s19, 0x128c0
		v_add3_u32 v36, v36, v27, v1
		s_mov_b32 m0, s56
		v_add3_u32 v36, v36, v28, v16
		s_mul_i32 s57, 12, s15
		v_add3_u32 v36, v36, v18, v20
		buffer_load_dwordx4 v36, s[52:55], 0 offen lds
		v_add3_u32 v37, s57, v24, v25
		s_add_i32 s58, s19, 0x13940
		v_add3_u32 v37, v37, v27, v1
		s_mov_b32 m0, s58
		v_add3_u32 v37, v37, v28, v16
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s13, s13, s17
		v_add3_u32 v37, v37, v18, v20
		buffer_load_dwordx4 v37, s[52:55], 0 offen lds
		s_lshl_b32 s13, s13, 10
		s_mul_i32 s29, s29, s17
		s_lshl_b32 s29, s29, 8
		s_add_i32 s59, s13, s29
		s_mul_i32 s60, s12, s18
		s_lshl_b32 s60, s60, 8
		s_lshl_b32 s61, s15, 7
		v_add3_u32 v38, s61, v24, v25
		s_add_i32 s62, s19, 0x18b80
		v_add3_u32 v38, v38, v27, v1
		s_mov_b32 m0, s62
		v_add3_u32 v38, v38, v28, v16
		s_mul_i32 s63, 0x84, s15
		v_add3_u32 v38, v38, v18, v20
		buffer_load_dwordx4 v38, s[52:55], 0 offen lds
		v_add3_u32 v39, s63, v24, v25
		s_add_i32 s64, s19, 0x19c00
		v_add3_u32 v39, v39, v27, v1
		s_mov_b32 m0, s64
		v_add3_u32 v39, v39, v28, v16
		s_mul_i32 s65, 0x88, s15
		v_add3_u32 v39, v39, v18, v20
		buffer_load_dwordx4 v39, s[52:55], 0 offen lds
		v_add3_u32 v40, s65, v24, v25
		s_add_i32 s66, s19, 0x1ac80
		v_add3_u32 v40, v40, v27, v1
		s_mov_b32 m0, s66
		v_add3_u32 v40, v40, v28, v16
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v40, v40, v18, v20
		buffer_load_dwordx4 v40, s[52:55], 0 offen lds
		v_add3_u32 v41, s15, v24, v25
		s_add_i32 s67, s19, 0x1bd00
		v_add3_u32 v41, v41, v27, v1
		s_mov_b32 m0, s67
		v_add3_u32 v41, v41, v28, v16
		s_lshl_b32 s68, s18, 7
		v_add3_u32 v41, v41, v18, v20
		buffer_load_dwordx4 v41, s[52:55], 0 offen lds
		s_add_i32 s69, s68, s60
		s_mul_i32 s70, 0x81, s18
		s_add_i32 s71, s70, s60
		s_mul_i32 s72, 0x82, s18
		s_add_i32 s73, s72, s60
		s_mul_i32 s74, 0x83, s18
		s_add_i32 s75, s74, s60
		s_add_i32 s76, s19, 0x83e0
		s_mov_b32 m0, s76
		s_nop 0
		buffer_load_dwordx4 v29, s[40:43], 0 offen lds
		s_add_i32 s31, s31, 0x80
		v_add3_u32 v42, s31, v3, v5
		s_add_i32 s31, s19, 0x9460
		v_add3_u32 v42, v42, v9, v11
		s_mov_b32 m0, s31
		v_add3_u32 v42, v42, v14, v16
		s_add_i32 s36, s36, 0x80
		v_add3_u32 v42, v42, v18, v20
		buffer_load_dwordx4 v42, s[40:43], 0 offen lds
		v_add3_u32 v43, s36, v3, v5
		s_add_i32 s36, s19, 0xa4e0
		v_add3_u32 v43, v43, v9, v11
		s_mov_b32 m0, s36
		v_add3_u32 v43, v43, v14, v16
		s_add_i32 s32, s32, 0x80
		v_add3_u32 v43, v43, v18, v20
		buffer_load_dwordx4 v43, s[40:43], 0 offen lds
		v_add3_u32 v44, s32, v3, v5
		s_add_i32 s32, s19, 0xb560
		v_add3_u32 v44, v44, v9, v11
		s_mov_b32 m0, s32
		v_add3_u32 v44, v44, v14, v16
		s_add_i32 s39, s39, 0x80
		v_add3_u32 v44, v44, v18, v20
		buffer_load_dwordx4 v44, s[40:43], 0 offen lds
		v_add3_u32 v45, s39, v3, v5
		s_add_i32 s39, s19, 0xc5e0
		v_add3_u32 v45, v45, v9, v11
		s_mov_b32 m0, s39
		v_add3_u32 v45, v45, v14, v16
		s_add_i32 s33, s33, 0x80
		v_add3_u32 v45, v45, v18, v20
		buffer_load_dwordx4 v45, s[40:43], 0 offen lds
		v_add3_u32 v46, s33, v3, v5
		s_add_i32 s33, s19, 0xd660
		v_add3_u32 v46, v46, v9, v11
		s_mov_b32 m0, s33
		v_add3_u32 v46, v46, v14, v16
		s_add_i32 s34, s34, 0x80
		v_add3_u32 v46, v46, v18, v20
		buffer_load_dwordx4 v46, s[40:43], 0 offen lds
		v_add3_u32 v47, s34, v3, v5
		s_add_i32 s34, s19, 0xe6e0
		v_add3_u32 v47, v47, v9, v11
		s_mov_b32 m0, s34
		v_add3_u32 v47, v47, v14, v16
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v47, v47, v18, v20
		buffer_load_dwordx4 v47, s[40:43], 0 offen lds
		v_add3_u32 v3, s14, v3, v5
		s_add_i32 s14, s19, 0xf760
		v_add3_u32 v3, v3, v9, v11
		s_mov_b32 m0, s14
		v_add3_u32 v3, v3, v14, v16
		s_add_i32 s77, s19, 0x149a0
		v_add3_u32 v3, v3, v18, v20
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_mov_b32 m0, s77
		s_add_i32 s40, s49, 0x80
		buffer_load_dwordx4 v30, s[52:55], 0 offen lds
		v_add3_u32 v5, s40, v24, v25
		s_add_i32 s40, s19, 0x15a20
		v_add3_u32 v5, v5, v27, v1
		s_mov_b32 m0, s40
		v_add3_u32 v5, v5, v28, v16
		s_add_i32 s41, s51, 0x80
		v_add3_u32 v5, v5, v18, v20
		buffer_load_dwordx4 v5, s[52:55], 0 offen lds
		v_add3_u32 v9, s41, v24, v25
		s_add_i32 s41, s19, 0x16aa0
		v_add3_u32 v9, v9, v27, v1
		s_mov_b32 m0, s41
		v_add3_u32 v9, v9, v28, v16
		s_add_i32 s42, s57, 0x80
		v_add3_u32 v9, v9, v18, v20
		buffer_load_dwordx4 v9, s[52:55], 0 offen lds
		v_add3_u32 v11, s42, v24, v25
		s_add_i32 s42, s19, 0x17b20
		v_add3_u32 v11, v11, v27, v1
		s_mov_b32 m0, s42
		v_add3_u32 v11, v11, v28, v16
		s_add_i32 s43, s13, 8
		v_add3_u32 v11, v11, v18, v20
		buffer_load_dwordx4 v11, s[52:55], 0 offen lds
		s_add_i32 s43, s43, s29
		s_add_i32 s49, s17, 8
		s_add_i32 s49, s49, s13
		s_add_i32 s49, s49, s29
		s_lshl_b32 s51, s17, 1
		s_add_i32 s51, s51, 8
		s_add_i32 s51, s51, s13
		s_add_i32 s51, s51, s29
		s_mul_i32 s57, 3, s17
		s_add_i32 s57, s57, 8
		s_add_i32 s57, s57, s13
		s_add_i32 s57, s57, s29
		s_lshl_b32 s78, s17, 2
		s_add_i32 s78, s78, 8
		s_add_i32 s78, s78, s13
		s_add_i32 s78, s78, s29
		s_mul_i32 s79, 5, s17
		s_add_i32 s79, s79, 8
		s_add_i32 s79, s79, s13
		s_add_i32 s79, s79, s29
		s_mul_i32 s80, 6, s17
		s_add_i32 s80, s80, 8
		s_add_i32 s80, s80, s13
		s_add_i32 s80, s80, s29
		s_mul_i32 s81, 7, s17
		s_add_i32 s81, s81, 8
		s_add_i32 s13, s81, s13
		s_add_i32 s13, s13, s29
		s_add_i32 s29, s60, 8
		s_add_i32 s81, s18, 8
		s_add_i32 s81, s81, s60
		s_lshl_b32 s82, s18, 1
		s_add_i32 s82, s82, 8
		s_add_i32 s82, s82, s60
		s_mul_i32 s83, 3, s18
		s_add_i32 s83, s83, 8
		s_add_i32 s83, s83, s60
		s_add_i32 s61, s61, 0x80
		v_add3_u32 v14, s61, v24, v25
		s_add_i32 s61, s19, 0x1cd60
		v_add3_u32 v14, v14, v27, v1
		s_mov_b32 m0, s61
		v_add3_u32 v14, v14, v28, v16
		s_add_i32 s63, s63, 0x80
		v_add3_u32 v14, v14, v18, v20
		buffer_load_dwordx4 v14, s[52:55], 0 offen lds
		v_add3_u32 v48, s63, v24, v25
		s_add_i32 s63, s19, 0x1dde0
		v_add3_u32 v48, v48, v27, v1
		s_mov_b32 m0, s63
		v_add3_u32 v48, v48, v28, v16
		v_add3_u32 v48, v48, v18, v20
		buffer_load_dwordx4 v48, s[52:55], 0 offen lds
		s_add_i32 s65, s65, 0x80
		v_add3_u32 v49, s65, v24, v25
		s_add_i32 s65, s19, 0x1ee60
		v_add3_u32 v49, v49, v27, v1
		s_add_i32 s15, s15, 0x80
		v_add3_u32 v49, v49, v28, v16
		s_add_i32 s84, s19, 0x1fee0
		s_mov_b32 m0, s65
		v_add3_u32 v49, v49, v18, v20
		buffer_load_dwordx4 v49, s[52:55], 0 offen lds
		v_add3_u32 v24, s15, v24, v25
		s_mov_b32 m0, s84
		v_add3_u32 v1, v24, v27, v1
		v_add3_u32 v1, v1, v28, v16
		v_add3_u32 v1, v1, v18, v20
		buffer_load_dwordx4 v1, s[52:55], 0 offen lds
		v_mul_lo_u32 v24, s17, v10
		s_add_i32 s15, s68, 8
		v_mul_lo_u32 v25, s18, v10
		s_add_i32 s15, s15, s60
		v_mul_lo_u32 v27, s18, v15
		s_add_i32 s52, s70, 8
		v_mul_lo_u32 v28, s17, v15
		s_add_i32 s52, s52, s60
		v_mul_lo_u32 v50, s17, v13
		v_mul_lo_u32 v51, s18, v13
		v_lshlrev_b32_e32 v27, 2, v27
		v_lshlrev_b32_e32 v52, 6, v25
		v_mul_lo_u32 v53, s18, v17
		v_lshlrev_b32_e32 v28, 3, v28
		v_lshlrev_b32_e32 v54, 7, v24
		v_mul_lo_u32 v55, s17, v17
		v_add3_u32 v56, s69, v27, v52
		v_lshlrev_b32_e32 v57, 5, v51
		v_lshlrev_b32_e32 v53, 4, v53
		v_mul_lo_u32 v58, s18, v19
		v_add3_u32 v59, s71, v27, v52
		v_add3_u32 v60, s43, v28, v54
		v_lshlrev_b32_e32 v61, 6, v50
		v_lshlrev_b32_e32 v55, 5, v55
		v_mul_lo_u32 v62, s17, v19
		v_add3_u32 v63, s49, v28, v54
		v_add3_u32 v64, s78, v28, v54
		v_add3_u32 v65, s79, v28, v54
		v_add3_u32 v66, s29, v27, v52
		v_add3_u32 v67, s81, v27, v52
		v_add3_u32 v68, s15, v27, v52
		v_add3_u32 v69, s52, v27, v52
		v_add3_u32 v56, v56, v57, v53
		v_lshlrev_b32_e32 v58, 3, v58
		v_add3_u32 v59, v59, v57, v53
		v_add3_u32 v60, v60, v61, v55
		v_lshlrev_b32_e32 v62, 4, v62
		v_add3_u32 v63, v63, v61, v55
		v_add3_u32 v64, v64, v61, v55
		v_add3_u32 v65, v65, v61, v55
		v_add3_u32 v66, v66, v57, v53
		v_add3_u32 v67, v67, v57, v53
		v_add3_u32 v68, v68, v57, v53
		v_add3_u32 v69, v69, v57, v53
		v_add3_u32 v56, v56, v58, v7
		buffer_load_ubyte_d16 v70, v56, s[24:27], 0 offen
		v_add3_u32 v59, v59, v58, v7
		buffer_load_ubyte_d16 v71, v59, s[24:27], 0 offen
		v_add3_u32 v60, v60, v62, v7
		buffer_load_ubyte_d16 v72, v60, s[20:23], 0 offen
		v_add3_u32 v63, v63, v62, v7
		buffer_load_ubyte_d16 v73, v63, s[20:23], 0 offen
		v_add3_u32 v64, v64, v62, v7
		buffer_load_ubyte_d16 v74, v64, s[20:23], 0 offen
		v_add3_u32 v65, v65, v62, v7
		buffer_load_ubyte_d16 v75, v65, s[20:23], 0 offen
		v_add3_u32 v66, v66, v58, v7
		buffer_load_ubyte_d16 v76, v66, s[24:27], 0 offen
		v_add3_u32 v67, v67, v58, v7
		buffer_load_ubyte_d16 v77, v67, s[24:27], 0 offen
		v_add3_u32 v68, v68, v58, v7
		buffer_load_ubyte_d16 v78, v68, s[24:27], 0 offen
		v_add3_u32 v69, v69, v58, v7
		buffer_load_ubyte_d16 v79, v69, s[24:27], 0 offen
		v_add_u32_e32 v80, 32, v13
		s_add_i32 s15, s72, 8
		v_lshlrev_b32_e32 v81, 1, v10
		s_load_dword s29, s[0:1], 0x38
		v_add_u32_e32 v82, 64, v13
		s_add_i32 s0, s15, s60
		v_add_u32_e32 v83, 0x60, v13
		s_add_i32 s1, s74, 8
		v_add_u32_e32 v84, 0x80, v13
		s_add_i32 s1, s1, s60
		v_add_u32_e32 v85, 0xa0, v13
		v_add_u32_e32 v86, 0xc0, v13
		v_add_u32_e32 v87, 0xe0, v13
		v_mul_lo_u32 v88, s17, v2
		v_lshlrev_b32_e32 v89, 2, v8
		v_xor_b32_e32 v80, v80, v81
		v_xor_b32_e32 v82, v82, v81
		v_xor_b32_e32 v83, v83, v81
		v_xor_b32_e32 v84, v84, v81
		v_xor_b32_e32 v85, v85, v81
		v_xor_b32_e32 v86, v86, v81
		v_xor_b32_e32 v81, v87, v81
		v_mul_lo_u32 v87, s18, v2
		v_lshl_add_u32 v88, v88, 4, s59
		v_mul_lo_u32 v90, s17, v4
		v_lshlrev_b32_e32 v91, 3, v4
		v_xor_b32_e32 v80, v89, v80
		v_xor_b32_e32 v82, v89, v82
		v_xor_b32_e32 v83, v89, v83
		v_xor_b32_e32 v84, v89, v84
		v_xor_b32_e32 v85, v89, v85
		v_xor_b32_e32 v86, v89, v86
		v_xor_b32_e32 v81, v89, v81
		v_lshl_add_u32 v87, v87, 4, s60
		v_mul_lo_u32 v89, s18, v4
		v_lshl_add_u32 v88, v90, 3, v88
		v_mul_lo_u32 v90, s17, v8
		v_lshlrev_b32_e32 v92, 4, v2
		v_xor_b32_e32 v80, v91, v80
		v_xor_b32_e32 v82, v91, v82
		v_xor_b32_e32 v83, v91, v83
		v_xor_b32_e32 v84, v91, v84
		v_xor_b32_e32 v85, v91, v85
		v_xor_b32_e32 v86, v91, v86
		v_xor_b32_e32 v81, v91, v81
		v_lshl_add_u32 v87, v89, 3, v87
		v_mul_lo_u32 v89, s18, v8
		v_lshl_add_u32 v88, v90, 2, v88
		v_xor_b32_e32 v80, v92, v80
		v_xor_b32_e32 v82, v92, v82
		v_xor_b32_e32 v83, v92, v83
		v_xor_b32_e32 v84, v92, v84
		v_xor_b32_e32 v85, v92, v85
		v_xor_b32_e32 v86, v92, v86
		v_xor_b32_e32 v81, v92, v81
		v_lshl_add_u32 v87, v89, 2, v87
		v_lshl_add_u32 v24, v24, 1, v88
		v_mul_lo_u32 v88, s17, v80
		v_mul_lo_u32 v89, s17, v82
		v_mul_lo_u32 v90, s17, v83
		v_mul_lo_u32 v91, s17, v84
		v_mul_lo_u32 v93, s17, v85
		v_mul_lo_u32 v94, s17, v86
		v_mul_lo_u32 v95, s17, v81
		v_lshl_add_u32 v25, v25, 1, v87
		v_mul_lo_u32 v87, s18, v80
		v_mul_lo_u32 v96, s18, v82
		v_mul_lo_u32 v97, s18, v83
		v_add3_u32 v98, s73, v27, v52
		v_add3_u32 v99, s75, v27, v52
		v_add3_u32 v100, s51, v28, v54
		v_add3_u32 v101, s57, v28, v54
		v_add3_u32 v102, s80, v28, v54
		v_add3_u32 v28, s13, v28, v54
		v_add3_u32 v54, s82, v27, v52
		v_add3_u32 v103, s83, v27, v52
		v_add3_u32 v104, s0, v27, v52
		v_add3_u32 v27, s1, v27, v52
		v_add3_u32 v24, v24, v50, v15
		v_lshlrev_b32_e32 v50, 2, v17
		v_lshlrev_b32_e32 v52, 1, v19
		v_add3_u32 v88, s59, v88, v15
		v_add3_u32 v89, s59, v89, v15
		v_add3_u32 v90, s59, v90, v15
		v_add3_u32 v91, s59, v91, v15
		v_add3_u32 v93, s59, v93, v15
		v_add3_u32 v94, s59, v94, v15
		v_add3_u32 v95, s59, v95, v15
		v_add3_u32 v25, v25, v51, v15
		v_add3_u32 v51, s60, v87, v15
		v_add3_u32 v87, s60, v96, v15
		v_add3_u32 v96, s60, v97, v15
		v_add3_u32 v97, v98, v57, v53
		v_add3_u32 v98, v99, v57, v53
		v_add3_u32 v99, v100, v61, v55
		v_add3_u32 v100, v101, v61, v55
		v_add3_u32 v101, v102, v61, v55
		v_add3_u32 v28, v28, v61, v55
		v_add3_u32 v54, v54, v57, v53
		v_add3_u32 v55, v103, v57, v53
		v_add3_u32 v61, v104, v57, v53
		v_add3_u32 v27, v27, v57, v53
		v_add3_u32 v24, v24, v50, v52
		buffer_load_ubyte v53, v24, s[20:23], 0 offen
		v_add3_u32 v57, v88, v50, v52
		buffer_load_ubyte v88, v57, s[20:23], 0 offen
		v_add3_u32 v89, v89, v50, v52
		buffer_load_ubyte v102, v89, s[20:23], 0 offen
		v_add3_u32 v90, v90, v50, v52
		buffer_load_ubyte v103, v90, s[20:23], 0 offen
		v_add3_u32 v91, v91, v50, v52
		buffer_load_ubyte v104, v91, s[20:23], 0 offen
		v_add3_u32 v93, v93, v50, v52
		buffer_load_ubyte v105, v93, s[20:23], 0 offen
		v_add3_u32 v94, v94, v50, v52
		buffer_load_ubyte v106, v94, s[20:23], 0 offen
		v_add3_u32 v95, v95, v50, v52
		buffer_load_ubyte v107, v95, s[20:23], 0 offen
		v_add3_u32 v25, v25, v50, v52
		buffer_load_ubyte v108, v25, s[24:27], 0 offen
		v_add3_u32 v51, v51, v50, v52
		buffer_load_ubyte v109, v51, s[24:27], 0 offen
		v_add3_u32 v87, v87, v50, v52
		buffer_load_ubyte v110, v87, s[24:27], 0 offen
		v_add3_u32 v50, v96, v50, v52
		buffer_load_ubyte v52, v50, s[24:27], 0 offen
		v_add3_u32 v96, v97, v58, v7
		buffer_load_ubyte_d16_hi v70, v96, s[24:27], 0 offen
		v_add3_u32 v97, v98, v58, v7
		buffer_load_ubyte_d16_hi v71, v97, s[24:27], 0 offen
		v_add3_u32 v98, v99, v62, v7
		buffer_load_ubyte_d16_hi v72, v98, s[20:23], 0 offen
		v_add3_u32 v99, v100, v62, v7
		buffer_load_ubyte_d16_hi v73, v99, s[20:23], 0 offen
		v_add3_u32 v100, v101, v62, v7
		buffer_load_ubyte_d16_hi v74, v100, s[20:23], 0 offen
		v_add3_u32 v28, v28, v62, v7
		buffer_load_ubyte_d16_hi v75, v28, s[20:23], 0 offen
		v_add3_u32 v54, v54, v58, v7
		buffer_load_ubyte_d16_hi v76, v54, s[24:27], 0 offen
		v_add3_u32 v55, v55, v58, v7
		buffer_load_ubyte_d16_hi v77, v55, s[24:27], 0 offen
		v_add3_u32 v61, v61, v58, v7
		buffer_load_ubyte_d16_hi v78, v61, s[24:27], 0 offen
		v_add3_u32 v7, v27, v58, v7
		buffer_load_ubyte_d16_hi v79, v7, s[24:27], 0 offen
		v_mov_b32_e32 v112, 0
		s_add_i32 s0, s28, 0x100
		s_mov_b32 s1, 0
		s_add_i32 s13, s30, 0x100
		v_mov_b32_e32 v113, 0
		v_mov_b64_e32 v[114:115], 0
		s_waitcnt vmcnt(52)
		s_barrier
		v_lshlrev_b32_e32 v27, 7, v2
		v_and_b32_e32 v58, 63, v0
		v_lshrrev_b32_e32 v62, 4, v58
		v_lshlrev_b32_e32 v62, 4, v62
		v_and_b32_e32 v58, 15, v58
		v_mov_b32_e32 v101, 0x420
		v_mul_lo_u32 v101, v101, v58
		v_add3_u32 v27, v27, v62, v101
		ds_read_b128 v[116:119], v27
		ds_read_b128 v[120:123], v27 offset:64
		ds_read_b128 v[124:127], v27 offset:256
		ds_read_b128 v[128:131], v27 offset:320
		ds_read_b128 v[132:135], v27 offset:512
		ds_read_b128 v[136:139], v27 offset:576
		ds_read_b128 v[140:143], v27 offset:768
		ds_read_b128 v[144:147], v27 offset:832
		ds_read_b128 v[148:151], v27 offset:16896
		ds_read_b128 v[152:155], v27 offset:16960
		ds_read_b128 v[156:159], v27 offset:17152
		ds_read_b128 v[160:163], v27 offset:17216
		ds_read_b128 v[164:167], v27 offset:17408
		ds_read_b128 v[168:171], v27 offset:17472
		ds_read_b128 v[172:175], v27 offset:17664
		ds_read_b128 v[176:179], v27 offset:17728
		v_add_u32_e32 v58, 0x10000, v62
		v_lshlrev_b32_e32 v62, 7, v4
		v_add3_u32 v58, v58, v62, v101
		ds_read_b128 v[180:183], v58 offset:1984
		ds_read_b128 v[184:187], v58 offset:2048
		ds_read_b128 v[188:191], v58 offset:2240
		ds_read_b128 v[192:195], v58 offset:2304
		ds_read_b128 v[196:199], v58 offset:2496
		ds_read_b128 v[200:203], v58 offset:2560
		ds_read_b128 v[204:207], v58 offset:2752
		ds_read_b128 v[208:211], v58 offset:2816
		v_add_u32_e32 v12, 0x20000, v12
		v_lshlrev_b32_e32 v62, 8, v15
		v_add_u32_e32 v101, v12, v62
		v_lshlrev_b32_e32 v111, 10, v17
		v_lshlrev_b32_e32 v212, 9, v19
		v_add3_u32 v101, v101, v111, v212
		s_waitcnt vmcnt(21)
		ds_write_b8 v101, v53 offset:3904
		v_add_u32_e32 v53, 0x20000, v62
		v_add3_u32 v53, v53, v111, v212
		v_add_u32_e32 v62, v53, v80
		s_waitcnt vmcnt(20)
		ds_write_b8 v62, v88 offset:3904
		v_add_u32_e32 v88, v53, v82
		s_waitcnt vmcnt(19)
		ds_write_b8 v88, v102 offset:3904
		v_add_u32_e32 v102, v53, v83
		s_waitcnt vmcnt(18)
		ds_write_b8 v102, v103 offset:3904
		v_add_u32_e32 v84, v53, v84
		s_waitcnt vmcnt(17)
		ds_write_b8 v84, v104 offset:3904
		v_add_u32_e32 v85, v53, v85
		s_waitcnt vmcnt(16)
		ds_write_b8 v85, v105 offset:3904
		v_add_u32_e32 v86, v53, v86
		s_waitcnt vmcnt(15)
		ds_write_b8 v86, v106 offset:3904
		v_add_u32_e32 v53, v53, v81
		s_waitcnt vmcnt(14)
		ds_write_b8 v53, v107 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v81, 7, v15
		v_add_u32_e32 v12, v12, v81
		v_lshlrev_b32_e32 v103, 9, v17
		v_lshlrev_b32_e32 v104, 8, v19
		v_add3_u32 v12, v12, v103, v104
		s_waitcnt vmcnt(13)
		ds_write_b8 v12, v108 offset:5952
		v_add_u32_e32 v81, 0x20000, v81
		v_add3_u32 v81, v81, v103, v104
		v_add_u32_e32 v80, v81, v80
		s_waitcnt vmcnt(12)
		ds_write_b8 v80, v109 offset:5952
		v_add_u32_e32 v82, v81, v82
		s_waitcnt vmcnt(11)
		ds_write_b8 v82, v110 offset:5952
		v_add_u32_e32 v81, v81, v83
		s_waitcnt vmcnt(10)
		ds_write_b8 v81, v52 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v52, 0x20000, v92
		v_lshlrev_b32_e32 v83, 3, v15
		v_add_u32_e32 v52, v52, v83
		v_lshl_add_u32 v52, v8, 9, v52
		v_lshlrev_b32_e32 v92, 8, v10
		v_lshlrev_b32_e32 v103, 6, v13
		v_add3_u32 v52, v52, v92, v103
		v_lshlrev_b32_e32 v92, 5, v17
		v_lshlrev_b32_e32 v19, 10, v19
		v_accvgpr_write_b32 a1, v19
		v_accvgpr_read_b32 v19, a1
		v_add3_u32 v19, v52, v92, v19
		ds_read_b64_tr_b8 v[104:105], v19 offset:3904
		ds_read_b64_tr_b8 v[106:107], v19 offset:4032
		v_add_u32_e32 v52, 0x20000, v83
		v_lshl_add_u32 v52, v4, 4, v52
		v_lshl_add_u32 v52, v8, 8, v52
		v_lshlrev_b32_e32 v83, 7, v10
		v_add3_u32 v52, v52, v83, v103
		v_add3_u32 v52, v52, v92, v212
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[108:109], v52 offset:5952
		s_waitcnt vmcnt(8)
		v_lshlrev_b32_e32 v71, 8, v71
		v_or_b32_e32 v83, v70, v71
		s_waitcnt vmcnt(6)
		v_lshlrev_b32_e32 v70, 8, v73
		v_or_b32_e32 v110, v72, v70
		s_waitcnt vmcnt(4)
		v_lshlrev_b32_e32 v70, 8, v75
		v_or_b32_e32 v111, v74, v70
		s_waitcnt vmcnt(2)
		v_lshlrev_b32_e32 v70, 8, v77
		v_or_b32_e32 v71, v76, v70
		s_waitcnt vmcnt(0)
		v_lshlrev_b32_e32 v70, 8, v79
		v_or_b32_e32 v72, v78, v70
		s_mov_b32 s15, 16
		v_lshlrev_b32_e32 v70, 2, v0
		v_add_u32_e32 v70, 0x20000, v70
		v_lshlrev_b32_e32 v73, 3, v0
		v_add_u32_e32 v73, 0x20000, v73
		s_mov_b32 s17, s15
		v_mov_b32_e32 v76, v112
		v_mov_b32_e32 v77, v113
		v_mov_b32_e32 v78, v114
		v_mov_b32_e32 v79, v115
		v_accvgpr_write_b32 a4, v76
		v_accvgpr_write_b32 a5, v77
		v_accvgpr_write_b32 a6, v78
		v_accvgpr_write_b32 a7, v79
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
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
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a8, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a9, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a10, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a11, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a12, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a13, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a14, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a15, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a16, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a17, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a18, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a19, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a20, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a21, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a22, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a23, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a24, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a25, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a26, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a27, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a28, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a29, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a30, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a31, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a32, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a33, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a34, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a35, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a36, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a37, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a38, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a39, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a40, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a41, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a42, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a43, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a44, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a45, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a46, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a47, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a48, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a49, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a50, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a51, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a52, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a53, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a54, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a55, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a56, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a57, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a58, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a59, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a60, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a61, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a62, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a63, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a64, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a65, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a66, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a67, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a68, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a69, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a70, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a71, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a72, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a73, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a74, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a75, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a76, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a77, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a78, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a79, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a80, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a81, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a82, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a83, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a84, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a85, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a86, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a87, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a88, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a89, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a90, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a91, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a92, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a93, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a94, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a95, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a96, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a97, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a98, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a99, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a100, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a101, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a102, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a103, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a104, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a105, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a106, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a107, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a108, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a109, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a110, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a111, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a112, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a113, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a114, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a115, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a116, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a117, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a118, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a119, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a120, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a121, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a122, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a123, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a124, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a125, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a126, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a127, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a128, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a129, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a130, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a131, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a132, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a133, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a134, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a135, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a136, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a137, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a138, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a139, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a140, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a141, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a142, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a143, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a144, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a145, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a146, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a147, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a148, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a149, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a150, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a151, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a152, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a153, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a154, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a155, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a156, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a157, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a158, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a159, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a160, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a161, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a162, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a163, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a164, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a165, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a166, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a167, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a168, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a169, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a170, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a171, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a172, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a173, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a174, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a175, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a176, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a177, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a178, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a179, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a180, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a181, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a182, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a183, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a184, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a185, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a186, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a187, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a188, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a189, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a190, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a191, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a192, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a193, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a194, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a195, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a196, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a197, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a198, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a199, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a200, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a201, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a202, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a203, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a204, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a205, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a206, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a207, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a208, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a209, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a210, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a211, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a212, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a213, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a214, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a215, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a216, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a217, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a218, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a219, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a220, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a221, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a222, v74
		v_mov_b32_e32 v74, 0
		v_accvgpr_write_b32 a223, v74
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[180:183], v[116:119], v[76:79], v108, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[184:187], v[120:123], v[76:79], v108, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[116:119], a[4:7], v108, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[120:123], a[4:7], v108, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[116:119], v[112:115], v109, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[120:123], v[112:115], v109, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[204:207], v[116:119], v[212:215], v109, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[208:211], v[120:123], v[212:215], v109, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[180:183], v[124:127], v[216:219], v108, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[184:187], v[128:131], v[216:219], v108, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[188:191], v[124:127], v[220:223], v108, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[192:195], v[128:131], v[220:223], v108, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[196:199], v[124:127], v[224:227], v109, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[200:203], v[128:131], v[224:227], v109, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[204:207], v[124:127], v[228:231], v109, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[208:211], v[128:131], v[228:231], v109, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[180:183], v[132:135], v[232:235], v108, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[184:187], v[136:139], v[232:235], v108, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[188:191], v[132:135], v[236:239], v108, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[192:195], v[136:139], v[236:239], v108, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[132:135], a[8:11], v109, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[136:139], a[8:11], v109, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[204:207], v[132:135], a[12:15], v109, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[208:211], v[136:139], a[12:15], v109, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[140:143], a[16:19], v108, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[184:187], v[144:147], a[16:19], v108, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[140:143], a[20:23], v108, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[192:195], v[144:147], a[20:23], v108, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[140:143], a[24:27], v109, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[144:147], a[24:27], v109, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[204:207], v[140:143], a[28:31], v109, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[144:147], a[28:31], v109, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[148:151], a[32:35], v108, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[184:187], v[152:155], a[32:35], v108, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[148:151], a[36:39], v108, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[192:195], v[152:155], a[36:39], v108, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[148:151], a[40:43], v109, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[152:155], a[40:43], v109, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[148:151], a[44:47], v109, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[152:155], a[44:47], v109, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[156:159], a[48:51], v108, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[184:187], v[160:163], a[48:51], v108, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[156:159], a[52:55], v108, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[192:195], v[160:163], a[52:55], v108, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[156:159], a[56:59], v109, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[200:203], v[160:163], a[56:59], v109, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[156:159], a[60:63], v109, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[208:211], v[160:163], a[60:63], v109, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[164:167], a[64:67], v108, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[184:187], v[168:171], a[64:67], v108, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[164:167], a[68:71], v108, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[192:195], v[168:171], a[68:71], v108, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[164:167], a[72:75], v109, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[200:203], v[168:171], a[72:75], v109, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[204:207], v[164:167], a[76:79], v109, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[208:211], v[168:171], a[76:79], v109, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[172:175], a[80:83], v108, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[184:187], v[176:179], a[80:83], v108, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[172:175], a[84:87], v108, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[192:195], v[176:179], a[84:87], v108, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[172:175], a[88:91], v109, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[200:203], v[176:179], a[88:91], v109, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[204:207], v[172:175], a[92:95], v109, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[176:179], a[92:95], v109, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[180:183], v58 offset:35712
		ds_read_b128 v[184:187], v58 offset:35776
		ds_read_b128 v[188:191], v58 offset:35968
		ds_read_b128 v[192:195], v58 offset:36032
		ds_read_b128 v[196:199], v58 offset:36224
		ds_read_b128 v[200:203], v58 offset:36288
		ds_read_b128 v[204:207], v58 offset:36480
		ds_read_b128 v[208:211], v58 offset:36544
		ds_write_b32 v70, v83 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v52 offset:5952
		s_add_u32 s20, s2, s0
		s_addc_u32 s21, s3, 0
		s_mov_b32 m0, s19
		s_mov_b32 s24, s20
		s_mov_b32 s25, s21
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_add_u32 s20, s4, s13
		s_addc_u32 s21, s5, 0
		s_mov_b32 m0, s48
		s_mov_b32 s52, s20
		s_mov_b32 s53, s21
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		buffer_load_dwordx4 v26, s[52:55], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v35, s[52:55], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v36, s[52:55], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v37, s[52:55], 0 offen lds
		s_add_u32 s20, s8, s15
		s_addc_u32 s21, s9, 0
		s_mov_b32 s68, s20
		s_mov_b32 s69, s21
		s_mov_b32 s70, 0x7fffffff
		s_mov_b32 s71, 0x31016000
		buffer_load_ubyte v83, v24, s[68:71], 0 offen
		buffer_load_ubyte v92, v57, s[68:71], 0 offen
		buffer_load_ubyte v103, v89, s[68:71], 0 offen
		buffer_load_ubyte v108, v90, s[68:71], 0 offen
		buffer_load_ubyte v109, v91, s[68:71], 0 offen
		buffer_load_ubyte v240, v93, s[68:71], 0 offen
		buffer_load_ubyte v241, v94, s[68:71], 0 offen
		buffer_load_ubyte v242, v95, s[68:71], 0 offen
		s_add_u32 s20, s10, s17
		s_addc_u32 s21, s11, 0
		s_mov_b32 s72, s20
		s_mov_b32 s73, s21
		s_mov_b32 s74, 0x7fffffff
		s_mov_b32 s75, 0x31016000
		buffer_load_ubyte v243, v25, s[72:75], 0 offen
		buffer_load_ubyte v244, v51, s[72:75], 0 offen
		buffer_load_ubyte v245, v87, s[72:75], 0 offen
		buffer_load_ubyte v246, v50, s[72:75], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[180:183], v[116:119], a[96:99], v74, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[184:187], v[120:123], a[96:99], v74, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], v[116:119], a[100:103], v74, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[192:195], v[120:123], a[100:103], v74, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[196:199], v[116:119], a[104:107], v75, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[200:203], v[120:123], a[104:107], v75, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[204:207], v[116:119], a[108:111], v75, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[208:211], v[120:123], a[108:111], v75, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[180:183], v[124:127], a[112:115], v74, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[184:187], v[128:131], a[112:115], v74, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[188:191], v[124:127], a[116:119], v74, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[192:195], v[128:131], a[116:119], v74, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[196:199], v[124:127], a[120:123], v75, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[200:203], v[128:131], a[120:123], v75, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[204:207], v[124:127], a[124:127], v75, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[208:211], v[128:131], a[124:127], v75, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[180:183], v[132:135], a[128:131], v74, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[184:187], v[136:139], a[128:131], v74, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[188:191], v[132:135], a[132:135], v74, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[192:195], v[136:139], a[132:135], v74, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[196:199], v[132:135], a[136:139], v75, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[200:203], v[136:139], a[136:139], v75, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[204:207], v[132:135], a[140:143], v75, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[208:211], v[136:139], a[140:143], v75, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[180:183], v[140:143], a[144:147], v74, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[184:187], v[144:147], a[144:147], v74, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[188:191], v[140:143], a[148:151], v74, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[192:195], v[144:147], a[148:151], v74, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[196:199], v[140:143], a[152:155], v75, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[200:203], v[144:147], a[152:155], v75, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[204:207], v[140:143], a[156:159], v75, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[208:211], v[144:147], a[156:159], v75, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[180:183], v[148:151], a[160:163], v74, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[184:187], v[152:155], a[160:163], v74, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[188:191], v[148:151], a[164:167], v74, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[192:195], v[152:155], a[164:167], v74, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[196:199], v[148:151], a[168:171], v75, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[200:203], v[152:155], a[168:171], v75, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[204:207], v[148:151], a[172:175], v75, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[208:211], v[152:155], a[172:175], v75, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[180:183], v[156:159], a[176:179], v74, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[184:187], v[160:163], a[176:179], v74, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[188:191], v[156:159], a[180:183], v74, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[192:195], v[160:163], a[180:183], v74, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[196:199], v[156:159], a[184:187], v75, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[200:203], v[160:163], a[184:187], v75, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[204:207], v[156:159], a[188:191], v75, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[208:211], v[160:163], a[188:191], v75, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[164:167], a[192:195], v74, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[184:187], v[168:171], a[192:195], v74, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[188:191], v[164:167], a[196:199], v74, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[192:195], v[168:171], a[196:199], v74, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[196:199], v[164:167], a[200:203], v75, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[200:203], v[168:171], a[200:203], v75, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[204:207], v[164:167], a[204:207], v75, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[208:211], v[168:171], a[204:207], v75, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[172:175], a[208:211], v74, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[184:187], v[176:179], a[208:211], v74, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[188:191], v[172:175], a[212:215], v74, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[192:195], v[176:179], a[212:215], v74, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[196:199], v[172:175], a[216:219], v75, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[200:203], v[176:179], a[216:219], v75, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[204:207], v[172:175], a[220:223], v75, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[208:211], v[176:179], a[220:223], v75, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[104:107], v27 offset:33760
		ds_read_b128 v[116:119], v27 offset:33824
		ds_read_b128 v[120:123], v27 offset:34016
		ds_read_b128 v[124:127], v27 offset:34080
		ds_read_b128 v[128:131], v27 offset:34272
		ds_read_b128 v[132:135], v27 offset:34336
		ds_read_b128 v[136:139], v27 offset:34528
		ds_read_b128 v[140:143], v27 offset:34592
		ds_read_b128 v[144:147], v27 offset:50656
		ds_read_b128 v[148:151], v27 offset:50720
		ds_read_b128 v[152:155], v27 offset:50912
		ds_read_b128 v[156:159], v27 offset:50976
		ds_read_b128 v[160:163], v27 offset:51168
		ds_read_b128 v[164:167], v27 offset:51232
		ds_read_b128 v[168:171], v27 offset:51424
		ds_read_b128 v[172:175], v27 offset:51488
		ds_read_b128 v[176:179], v58 offset:18848
		ds_read_b128 v[180:183], v58 offset:18912
		ds_read_b128 v[184:187], v58 offset:19104
		ds_read_b128 v[188:191], v58 offset:19168
		ds_read_b128 v[192:195], v58 offset:19360
		ds_read_b128 v[196:199], v58 offset:19424
		ds_read_b128 v[200:203], v58 offset:19616
		ds_read_b128 v[204:207], v58 offset:19680
		ds_write_b64 v73, v[110:111] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v70, v71 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v19 offset:3904
		ds_read_b64_tr_b8 v[110:111], v19 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[208:209], v52 offset:5952
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v38, s[52:55], 0 offen lds
		s_mov_b32 m0, s64
		s_nop 0
		buffer_load_dwordx4 v39, s[52:55], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v40, s[52:55], 0 offen lds
		s_mov_b32 m0, s67
		s_nop 0
		buffer_load_dwordx4 v41, s[52:55], 0 offen lds
		buffer_load_ubyte_d16 v71, v56, s[72:75], 0 offen
		buffer_load_ubyte_d16 v247, v59, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v71, v96, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v247, v97, s[72:75], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[176:179], v[104:107], v[76:79], v208, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[180:183], v[116:119], v[76:79], v208, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[184:187], v[104:107], a[4:7], v208, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[116:119], a[4:7], v208, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[192:195], v[104:107], v[112:115], v209, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[116:119], v[112:115], v209, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[200:203], v[104:107], v[212:215], v209, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[204:207], v[116:119], v[212:215], v209, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[176:179], v[120:123], v[216:219], v208, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[180:183], v[124:127], v[216:219], v208, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[184:187], v[120:123], v[220:223], v208, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[188:191], v[124:127], v[220:223], v208, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[192:195], v[120:123], v[224:227], v209, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[196:199], v[124:127], v[224:227], v209, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[200:203], v[120:123], v[228:231], v209, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[204:207], v[124:127], v[228:231], v209, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[176:179], v[128:131], v[232:235], v208, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[180:183], v[132:135], v[232:235], v208, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[184:187], v[128:131], v[236:239], v208, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[188:191], v[132:135], v[236:239], v208, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[192:195], v[128:131], a[8:11], v209, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[132:135], a[8:11], v209, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[128:131], a[12:15], v209, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[204:207], v[132:135], a[12:15], v209, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[176:179], v[136:139], a[16:19], v208, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[140:143], a[16:19], v208, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[184:187], v[136:139], a[20:23], v208, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[140:143], a[20:23], v208, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[192:195], v[136:139], a[24:27], v209, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[140:143], a[24:27], v209, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[136:139], a[28:31], v209, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[204:207], v[140:143], a[28:31], v209, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[176:179], v[144:147], a[32:35], v208, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[148:151], a[32:35], v208, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[184:187], v[144:147], a[36:39], v208, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[148:151], a[36:39], v208, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[192:195], v[144:147], a[40:43], v209, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[148:151], a[40:43], v209, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[200:203], v[144:147], a[44:47], v209, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[148:151], a[44:47], v209, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[176:179], v[152:155], a[48:51], v208, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[156:159], a[48:51], v208, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[184:187], v[152:155], a[52:55], v208, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[156:159], a[52:55], v208, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[192:195], v[152:155], a[56:59], v209, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[156:159], a[56:59], v209, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[200:203], v[152:155], a[60:63], v209, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[156:159], a[60:63], v209, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[176:179], v[160:163], a[64:67], v208, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[164:167], a[64:67], v208, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[184:187], v[160:163], a[68:71], v208, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[164:167], a[68:71], v208, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[192:195], v[160:163], a[72:75], v209, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[164:167], a[72:75], v209, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[200:203], v[160:163], a[76:79], v209, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[204:207], v[164:167], a[76:79], v209, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[176:179], v[168:171], a[80:83], v208, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[172:175], a[80:83], v208, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[184:187], v[168:171], a[84:87], v208, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[172:175], a[84:87], v208, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[192:195], v[168:171], a[88:91], v209, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[172:175], a[88:91], v209, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[200:203], v[168:171], a[92:95], v209, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[204:207], v[172:175], a[92:95], v209, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[176:179], v58 offset:52576
		ds_read_b128 v[180:183], v58 offset:52640
		ds_read_b128 v[184:187], v58 offset:52832
		ds_read_b128 v[188:191], v58 offset:52896
		ds_read_b128 v[192:195], v58 offset:53088
		ds_read_b128 v[196:199], v58 offset:53152
		ds_read_b128 v[200:203], v58 offset:53344
		ds_read_b128 v[204:207], v58 offset:53408
		ds_write_b32 v70, v72 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[208:209], v52 offset:5952
		s_mov_b32 m0, s76
		s_nop 0
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v42, s[24:27], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v43, s[24:27], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v44, s[24:27], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v45, s[24:27], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v46, s[24:27], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_mov_b32 m0, s77
		s_nop 0
		buffer_load_dwordx4 v30, s[52:55], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v5, s[52:55], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v9, s[52:55], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v11, s[52:55], 0 offen lds
		buffer_load_ubyte_d16 v72, v60, s[68:71], 0 offen
		buffer_load_ubyte_d16 v248, v63, s[68:71], 0 offen
		buffer_load_ubyte_d16_hi v72, v98, s[68:71], 0 offen
		buffer_load_ubyte_d16_hi v248, v99, s[68:71], 0 offen
		buffer_load_ubyte_d16 v249, v64, s[68:71], 0 offen
		buffer_load_ubyte_d16 v250, v65, s[68:71], 0 offen
		buffer_load_ubyte_d16_hi v249, v100, s[68:71], 0 offen
		buffer_load_ubyte_d16_hi v250, v28, s[68:71], 0 offen
		buffer_load_ubyte_d16 v251, v66, s[72:75], 0 offen
		buffer_load_ubyte_d16 v252, v67, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v251, v54, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v252, v55, s[72:75], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[176:179], v[104:107], a[96:99], v208, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[180:183], v[116:119], a[96:99], v208, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[184:187], v[104:107], a[100:103], v208, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], v[116:119], a[100:103], v208, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[192:195], v[104:107], a[104:107], v209, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[196:199], v[116:119], a[104:107], v209, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[200:203], v[104:107], a[108:111], v209, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[204:207], v[116:119], a[108:111], v209, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[176:179], v[120:123], a[112:115], v208, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[180:183], v[124:127], a[112:115], v208, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[184:187], v[120:123], a[116:119], v208, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[188:191], v[124:127], a[116:119], v208, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[192:195], v[120:123], a[120:123], v209, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[196:199], v[124:127], a[120:123], v209, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[200:203], v[120:123], a[124:127], v209, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[204:207], v[124:127], a[124:127], v209, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[176:179], v[128:131], a[128:131], v208, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[180:183], v[132:135], a[128:131], v208, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[184:187], v[128:131], a[132:135], v208, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[188:191], v[132:135], a[132:135], v208, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[192:195], v[128:131], a[136:139], v209, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[196:199], v[132:135], a[136:139], v209, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[200:203], v[128:131], a[140:143], v209, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[204:207], v[132:135], a[140:143], v209, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[176:179], v[136:139], a[144:147], v208, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[180:183], v[140:143], a[144:147], v208, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[184:187], v[136:139], a[148:151], v208, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[188:191], v[140:143], a[148:151], v208, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[192:195], v[136:139], a[152:155], v209, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[196:199], v[140:143], a[152:155], v209, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[200:203], v[136:139], a[156:159], v209, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[204:207], v[140:143], a[156:159], v209, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[176:179], v[144:147], a[160:163], v208, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[180:183], v[148:151], a[160:163], v208, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[184:187], v[144:147], a[164:167], v208, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[188:191], v[148:151], a[164:167], v208, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[192:195], v[144:147], a[168:171], v209, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[196:199], v[148:151], a[168:171], v209, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[200:203], v[144:147], a[172:175], v209, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[204:207], v[148:151], a[172:175], v209, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[176:179], v[152:155], a[176:179], v208, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[180:183], v[156:159], a[176:179], v208, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[184:187], v[152:155], a[180:183], v208, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[188:191], v[156:159], a[180:183], v208, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[192:195], v[152:155], a[184:187], v209, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[196:199], v[156:159], a[184:187], v209, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[200:203], v[152:155], a[188:191], v209, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[204:207], v[156:159], a[188:191], v209, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[176:179], v[160:163], a[192:195], v208, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[164:167], a[192:195], v208, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[184:187], v[160:163], a[196:199], v208, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[188:191], v[164:167], a[196:199], v208, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[192:195], v[160:163], a[200:203], v209, v111 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[196:199], v[164:167], a[200:203], v209, v111 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[200:203], v[160:163], a[204:207], v209, v111 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[204:207], v[164:167], a[204:207], v209, v111 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[176:179], v[168:171], a[208:211], v208, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[172:175], a[208:211], v208, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[184:187], v[168:171], a[212:215], v208, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[188:191], v[172:175], a[212:215], v208, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[192:195], v[168:171], a[216:219], v209, v111 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[196:199], v[172:175], a[216:219], v209, v111 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[200:203], v[168:171], a[220:223], v209, v111 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[204:207], v[172:175], a[220:223], v209, v111 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		s_barrier
		ds_read_b128 v[116:119], v27
		ds_read_b128 v[120:123], v27 offset:64
		ds_read_b128 v[124:127], v27 offset:256
		ds_read_b128 v[128:131], v27 offset:320
		ds_read_b128 v[132:135], v27 offset:512
		ds_read_b128 v[136:139], v27 offset:576
		ds_read_b128 v[140:143], v27 offset:768
		ds_read_b128 v[144:147], v27 offset:832
		ds_read_b128 v[148:151], v27 offset:16896
		ds_read_b128 v[152:155], v27 offset:16960
		ds_read_b128 v[156:159], v27 offset:17152
		ds_read_b128 v[160:163], v27 offset:17216
		ds_read_b128 v[164:167], v27 offset:17408
		ds_read_b128 v[168:171], v27 offset:17472
		ds_read_b128 v[172:175], v27 offset:17664
		ds_read_b128 v[176:179], v27 offset:17728
		ds_read_b128 v[180:183], v58 offset:1984
		ds_read_b128 v[184:187], v58 offset:2048
		ds_read_b128 v[188:191], v58 offset:2240
		ds_read_b128 v[192:195], v58 offset:2304
		ds_read_b128 v[196:199], v58 offset:2496
		ds_read_b128 v[200:203], v58 offset:2560
		ds_read_b128 v[204:207], v58 offset:2752
		ds_read_b128 v[208:211], v58 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v101, v83 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v62, v92 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v88, v103 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v102, v108 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v84, v109 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v85, v240 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v86, v241 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v53, v242 offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(35)
		ds_write_b8 v12, v243 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v80, v244 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v82, v245 offset:5952
		s_waitcnt vmcnt(32)
		ds_write_b8 v81, v246 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[104:105], v19 offset:3904
		ds_read_b64_tr_b8 v[106:107], v19 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[108:109], v52 offset:5952
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v14, s[52:55], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v48, s[52:55], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v49, s[52:55], 0 offen lds
		s_mov_b32 m0, s84
		s_nop 0
		buffer_load_dwordx4 v1, s[52:55], 0 offen lds
		buffer_load_ubyte_d16 v74, v68, s[72:75], 0 offen
		buffer_load_ubyte_d16 v75, v69, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v74, v61, s[72:75], 0 offen
		buffer_load_ubyte_d16_hi v75, v7, s[72:75], 0 offen
		s_add_i32 s0, s0, 0x100
		s_add_i32 s13, s13, 0x100
		s_add_i32 s15, s15, 16
		s_add_i32 s17, s17, 16
		s_waitcnt vmcnt(32)
		v_lshlrev_b32_e32 v83, 8, v247
		v_or_b32_e32 v83, v71, v83
		s_waitcnt vmcnt(16)
		v_lshlrev_b32_e32 v71, 8, v248
		v_or_b32_e32 v110, v72, v71
		s_waitcnt vmcnt(12)
		v_lshlrev_b32_e32 v71, 8, v250
		v_or_b32_e32 v111, v249, v71
		s_waitcnt vmcnt(8)
		v_lshlrev_b32_e32 v71, 8, v252
		v_or_b32_e32 v71, v251, v71
		s_waitcnt vmcnt(0)
		v_lshlrev_b32_e32 v72, 8, v75
		v_or_b32_e32 v72, v74, v72
		s_add_i32 s1, s1, 2
		s_cmp_lt_i32 s1, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[180:183], v[116:119], v[76:79], v108, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[184:187], v[120:123], v[76:79], v108, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[188:191], v[116:119], a[4:7], v108, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[192:195], v[120:123], a[4:7], v108, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[116:119], v[112:115], v109, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[120:123], v[112:115], v109, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[204:207], v[116:119], v[212:215], v109, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[208:211], v[120:123], v[212:215], v109, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[180:183], v[124:127], v[216:219], v108, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[184:187], v[128:131], v[216:219], v108, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[188:191], v[124:127], v[220:223], v108, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[192:195], v[128:131], v[220:223], v108, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[196:199], v[124:127], v[224:227], v109, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[200:203], v[128:131], v[224:227], v109, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[204:207], v[124:127], v[228:231], v109, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[208:211], v[128:131], v[228:231], v109, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[180:183], v[132:135], v[232:235], v108, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[184:187], v[136:139], v[232:235], v108, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[188:191], v[132:135], v[236:239], v108, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[192:195], v[136:139], v[236:239], v108, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[196:199], v[132:135], a[8:11], v109, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[136:139], a[8:11], v109, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[204:207], v[132:135], a[12:15], v109, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[208:211], v[136:139], a[12:15], v109, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[180:183], v[140:143], a[16:19], v108, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[184:187], v[144:147], a[16:19], v108, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[188:191], v[140:143], a[20:23], v108, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[192:195], v[144:147], a[20:23], v108, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[196:199], v[140:143], a[24:27], v109, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[144:147], a[24:27], v109, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[204:207], v[140:143], a[28:31], v109, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[144:147], a[28:31], v109, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[180:183], v[148:151], a[32:35], v108, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[184:187], v[152:155], a[32:35], v108, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[188:191], v[148:151], a[36:39], v108, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[192:195], v[152:155], a[36:39], v108, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[196:199], v[148:151], a[40:43], v109, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[152:155], a[40:43], v109, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[148:151], a[44:47], v109, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[152:155], a[44:47], v109, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[180:183], v[156:159], a[48:51], v108, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[184:187], v[160:163], a[48:51], v108, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[188:191], v[156:159], a[52:55], v108, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[192:195], v[160:163], a[52:55], v108, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[196:199], v[156:159], a[56:59], v109, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[200:203], v[160:163], a[56:59], v109, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[156:159], a[60:63], v109, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[208:211], v[160:163], a[60:63], v109, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[180:183], v[164:167], a[64:67], v108, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[184:187], v[168:171], a[64:67], v108, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[188:191], v[164:167], a[68:71], v108, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[192:195], v[168:171], a[68:71], v108, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[196:199], v[164:167], a[72:75], v109, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[200:203], v[168:171], a[72:75], v109, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[204:207], v[164:167], a[76:79], v109, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[208:211], v[168:171], a[76:79], v109, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[180:183], v[172:175], a[80:83], v108, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[184:187], v[176:179], a[80:83], v108, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], v[172:175], a[84:87], v108, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[192:195], v[176:179], a[84:87], v108, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[196:199], v[172:175], a[88:91], v109, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[200:203], v[176:179], a[88:91], v109, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[204:207], v[172:175], a[92:95], v109, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[176:179], a[92:95], v109, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[28:31], v58 offset:35712
		ds_read_b128 v[32:35], v58 offset:35776
		ds_read_b128 v[36:39], v58 offset:35968
		ds_read_b128 v[40:43], v58 offset:36032
		ds_read_b128 v[44:47], v58 offset:36224
		ds_read_b128 v[48:51], v58 offset:36288
		ds_read_b128 v[60:63], v58 offset:36480
		ds_read_b128 v[64:67], v58 offset:36544
		ds_write_b32 v70, v83 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[116:119], a[96:99], v6, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[32:35], v[120:123], a[96:99], v6, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], v[116:119], a[100:103], v6, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[120:123], a[100:103], v6, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[116:119], a[104:107], v7, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[48:51], v[120:123], a[104:107], v7, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[60:63], v[116:119], a[108:111], v7, v104 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], v[120:123], a[108:111], v7, v104 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[124:127], a[112:115], v6, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], v[128:131], a[112:115], v6, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], v[124:127], a[116:119], v6, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], v[128:131], a[116:119], v6, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], v[124:127], a[120:123], v7, v104 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], v[128:131], a[120:123], v7, v104 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], v[124:127], a[124:127], v7, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[64:67], v[128:131], a[124:127], v7, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[132:135], a[128:131], v6, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[136:139], a[128:131], v6, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[36:39], v[132:135], a[132:135], v6, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], v[136:139], a[132:135], v6, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[132:135], a[136:139], v7, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[136:139], a[136:139], v7, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], v[132:135], a[140:143], v7, v105 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[64:67], v[136:139], a[140:143], v7, v105 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[140:143], a[144:147], v6, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[144:147], a[144:147], v6, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[140:143], a[148:151], v6, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], v[144:147], a[148:151], v6, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], v[140:143], a[152:155], v7, v105 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], v[144:147], a[152:155], v7, v105 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], v[140:143], a[156:159], v7, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[64:67], v[144:147], a[156:159], v7, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[148:151], a[160:163], v6, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[152:155], a[160:163], v6, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[148:151], a[164:167], v6, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], v[152:155], a[164:167], v6, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[44:47], v[148:151], a[168:171], v7, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[152:155], a[168:171], v7, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], v[148:151], a[172:175], v7, v106 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[64:67], v[152:155], a[172:175], v7, v106 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[156:159], a[176:179], v6, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[160:163], a[176:179], v6, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[156:159], a[180:183], v6, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[160:163], a[180:183], v6, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[44:47], v[156:159], a[184:187], v7, v106 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[48:51], v[160:163], a[184:187], v7, v106 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[60:63], v[156:159], a[188:191], v7, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[64:67], v[160:163], a[188:191], v7, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], v[164:167], a[192:195], v6, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[168:171], a[192:195], v6, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[164:167], a[196:199], v6, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[168:171], a[196:199], v6, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[44:47], v[164:167], a[200:203], v7, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[48:51], v[168:171], a[200:203], v7, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], v[164:167], a[204:207], v7, v107 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[64:67], v[168:171], a[204:207], v7, v107 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], v[172:175], a[208:211], v6, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[176:179], a[208:211], v6, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[172:175], a[212:215], v6, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[176:179], a[212:215], v6, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[44:47], v[172:175], a[216:219], v7, v107 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[48:51], v[176:179], a[216:219], v7, v107 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[60:63], v[172:175], a[220:223], v7, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[64:67], v[176:179], a[220:223], v7, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v27 offset:33760
		ds_read_b128 v[32:35], v27 offset:33824
		ds_read_b128 v[36:39], v27 offset:34016
		ds_read_b128 v[40:43], v27 offset:34080
		ds_read_b128 v[44:47], v27 offset:34272
		ds_read_b128 v[48:51], v27 offset:34336
		ds_read_b128 v[60:63], v27 offset:34528
		ds_read_b128 v[64:67], v27 offset:34592
		ds_read_b128 v[80:83], v27 offset:50656
		ds_read_b128 v[84:87], v27 offset:50720
		ds_read_b128 v[88:91], v27 offset:50912
		ds_read_b128 v[92:95], v27 offset:50976
		ds_read_b128 v[96:99], v27 offset:51168
		ds_read_b128 v[100:103], v27 offset:51232
		ds_read_b128 v[104:107], v27 offset:51424
		ds_read_b128 v[116:119], v27 offset:51488
		ds_read_b128 v[24:27], v58 offset:18848
		ds_read_b128 v[120:123], v58 offset:18912
		ds_read_b128 v[124:127], v58 offset:19104
		ds_read_b128 v[128:131], v58 offset:19168
		ds_read_b128 v[132:135], v58 offset:19360
		ds_read_b128 v[136:139], v58 offset:19424
		ds_read_b128 v[140:143], v58 offset:19616
		ds_read_b128 v[144:147], v58 offset:19680
		ds_write_b64 v73, v[110:111] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v70, v71 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v19 offset:3904
		ds_read_b64_tr_b8 v[22:23], v19 offset:4032
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b8 v[54:55], v52 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[24:27], v[28:31], v[76:79], v54, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[120:123], v[32:35], v[76:79], v54, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[124:127], v[28:31], a[4:7], v54, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[128:131], v[32:35], a[4:7], v54, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[132:135], v[28:31], v[112:115], v55, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[136:139], v[32:35], v[112:115], v55, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[140:143], v[28:31], v[212:215], v55, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[144:147], v[32:35], v[212:215], v55, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[36:39], v[216:219], v54, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[120:123], v[40:43], v[216:219], v54, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[124:127], v[36:39], v[220:223], v54, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[128:131], v[40:43], v[220:223], v54, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[132:135], v[36:39], v[224:227], v55, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[136:139], v[40:43], v[224:227], v55, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[140:143], v[36:39], v[228:231], v55, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[144:147], v[40:43], v[228:231], v55, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[24:27], v[44:47], v[232:235], v54, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[120:123], v[48:51], v[232:235], v54, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[124:127], v[44:47], v[236:239], v54, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[128:131], v[48:51], v[236:239], v54, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[132:135], v[44:47], a[8:11], v55, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[136:139], v[48:51], a[8:11], v55, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[140:143], v[44:47], a[12:15], v55, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[144:147], v[48:51], a[12:15], v55, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[24:27], v[60:63], a[16:19], v54, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[120:123], v[64:67], a[16:19], v54, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[124:127], v[60:63], a[20:23], v54, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[128:131], v[64:67], a[20:23], v54, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[132:135], v[60:63], a[24:27], v55, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[136:139], v[64:67], a[24:27], v55, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[140:143], v[60:63], a[28:31], v55, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[144:147], v[64:67], a[28:31], v55, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[80:83], a[32:35], v54, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[120:123], v[84:87], a[32:35], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[124:127], v[80:83], a[36:39], v54, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[128:131], v[84:87], a[36:39], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[132:135], v[80:83], a[40:43], v55, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[136:139], v[84:87], a[40:43], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[140:143], v[80:83], a[44:47], v55, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[144:147], v[84:87], a[44:47], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[88:91], a[48:51], v54, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[120:123], v[92:95], a[48:51], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[124:127], v[88:91], a[52:55], v54, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[128:131], v[92:95], a[52:55], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[132:135], v[88:91], a[56:59], v55, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[136:139], v[92:95], a[56:59], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[140:143], v[88:91], a[60:63], v55, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[144:147], v[92:95], a[60:63], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[96:99], a[64:67], v54, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[120:123], v[100:103], a[64:67], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[124:127], v[96:99], a[68:71], v54, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[128:131], v[100:103], a[68:71], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[132:135], v[96:99], a[72:75], v55, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[136:139], v[100:103], a[72:75], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[140:143], v[96:99], a[76:79], v55, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[144:147], v[100:103], a[76:79], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[104:107], a[80:83], v54, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[120:123], v[116:119], a[80:83], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[124:127], v[104:107], a[84:87], v54, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[128:131], v[116:119], a[84:87], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[132:135], v[104:107], a[88:91], v55, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[136:139], v[116:119], a[88:91], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[140:143], v[104:107], a[92:95], v55, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[144:147], v[116:119], a[92:95], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v58 offset:52576
		ds_read_b128 v[108:111], v58 offset:52640
		ds_read_b128 v[120:123], v58 offset:52832
		ds_read_b128 v[124:127], v58 offset:52896
		ds_read_b128 v[128:131], v58 offset:53088
		ds_read_b128 v[132:135], v58 offset:53152
		ds_read_b128 v[136:139], v58 offset:53344
		ds_read_b128 v[140:143], v58 offset:53408
		ds_write_b32 v70, v72 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[54:55], v52 offset:5952
		s_mul_i32 s0, s16, s29
		v_cvt_pk_bf16_f32 v56, v76, v77
		v_cvt_pk_bf16_f32 v57, v78, v79
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v3, a5
		v_cvt_pk_bf16_f32 v68, v1, v3
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v3, a7
		v_cvt_pk_bf16_f32 v69, v1, v3
		v_cvt_pk_bf16_f32 v72, v112, v113
		v_cvt_pk_bf16_f32 v73, v114, v115
		v_cvt_pk_bf16_f32 v76, v212, v213
		v_cvt_pk_bf16_f32 v77, v214, v215
		v_cvt_pk_bf16_f32 v58, v216, v217
		v_cvt_pk_bf16_f32 v59, v218, v219
		v_cvt_pk_bf16_f32 v70, v220, v221
		v_cvt_pk_bf16_f32 v71, v222, v223
		v_cvt_pk_bf16_f32 v74, v224, v225
		v_cvt_pk_bf16_f32 v75, v226, v227
		v_cvt_pk_bf16_f32 v78, v228, v229
		v_cvt_pk_bf16_f32 v79, v230, v231
		v_cvt_pk_bf16_f32 v112, v232, v233
		v_cvt_pk_bf16_f32 v113, v234, v235
		v_cvt_pk_bf16_f32 v144, v236, v237
		v_cvt_pk_bf16_f32 v145, v238, v239
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v3, a9
		v_cvt_pk_bf16_f32 v148, v1, v3
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v3, a11
		v_cvt_pk_bf16_f32 v149, v1, v3
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v3, a13
		v_cvt_pk_bf16_f32 v152, v1, v3
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v3, a15
		v_cvt_pk_bf16_f32 v153, v1, v3
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v3, a17
		v_cvt_pk_bf16_f32 v114, v1, v3
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v3, a19
		v_cvt_pk_bf16_f32 v115, v1, v3
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v3, a21
		v_cvt_pk_bf16_f32 v146, v1, v3
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v3, a23
		v_cvt_pk_bf16_f32 v147, v1, v3
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v3, a25
		v_cvt_pk_bf16_f32 v150, v1, v3
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v3, a27
		v_cvt_pk_bf16_f32 v151, v1, v3
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v3, a29
		v_cvt_pk_bf16_f32 v154, v1, v3
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v3, a31
		v_cvt_pk_bf16_f32 v155, v1, v3
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v3, a33
		v_cvt_pk_bf16_f32 v156, v1, v3
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v3, a35
		v_cvt_pk_bf16_f32 v157, v1, v3
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v3, a37
		v_cvt_pk_bf16_f32 v160, v1, v3
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v3, a39
		v_cvt_pk_bf16_f32 v161, v1, v3
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v3, a41
		v_cvt_pk_bf16_f32 v164, v1, v3
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v3, a43
		v_cvt_pk_bf16_f32 v165, v1, v3
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v3, a45
		v_cvt_pk_bf16_f32 v168, v1, v3
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v3, a47
		v_cvt_pk_bf16_f32 v169, v1, v3
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v3, a49
		v_cvt_pk_bf16_f32 v158, v1, v3
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v3, a51
		v_cvt_pk_bf16_f32 v159, v1, v3
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v3, a53
		v_cvt_pk_bf16_f32 v162, v1, v3
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v3, a55
		v_cvt_pk_bf16_f32 v163, v1, v3
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v3, a57
		v_cvt_pk_bf16_f32 v166, v1, v3
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v3, a59
		v_cvt_pk_bf16_f32 v167, v1, v3
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v3, a61
		v_cvt_pk_bf16_f32 v170, v1, v3
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v3, a63
		v_cvt_pk_bf16_f32 v171, v1, v3
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v3, a65
		v_cvt_pk_bf16_f32 v172, v1, v3
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v3, a67
		v_cvt_pk_bf16_f32 v173, v1, v3
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v3, a69
		v_cvt_pk_bf16_f32 v176, v1, v3
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v3, a71
		v_cvt_pk_bf16_f32 v177, v1, v3
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v3, a73
		v_cvt_pk_bf16_f32 v180, v1, v3
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v3, a75
		v_cvt_pk_bf16_f32 v181, v1, v3
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v3, a77
		v_cvt_pk_bf16_f32 v184, v1, v3
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v3, a79
		v_cvt_pk_bf16_f32 v185, v1, v3
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_bf16_f32 v174, v1, v3
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_bf16_f32 v175, v1, v3
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v3, a85
		v_cvt_pk_bf16_f32 v178, v1, v3
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v3, a87
		v_cvt_pk_bf16_f32 v179, v1, v3
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_bf16_f32 v182, v1, v3
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_bf16_f32 v183, v1, v3
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_bf16_f32 v186, v1, v3
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_bf16_f32 v187, v1, v3
		v_lshlrev_b32_e32 v0, 4, v0
		v_add_u32_e32 v0, 0x20000, v0
		ds_write_b128 v0, v[56:59] offset:6976
		ds_write_b128 v0, v[68:71] offset:11072
		ds_write_b128 v0, v[72:75] offset:15168
		ds_write_b128 v0, v[76:79] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v15, 9, v1
		v_lshl_add_u32 v1, v13, 13, v1
		v_lshlrev_b32_e32 v3, 12, v17
		v_accvgpr_read_b32 v5, a1
		v_add3_u32 v1, v1, v3, v5
		ds_read_b128 v[56:59], v1 offset:6976
		ds_read_b128 v[68:71], v1 offset:7232
		ds_read_b128 v[72:75], v1 offset:9024
		ds_read_b128 v[76:79], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[112:115] offset:6976
		ds_write_b128 v0, v[144:147] offset:11072
		ds_write_b128 v0, v[148:151] offset:15168
		ds_write_b128 v0, v[152:155] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v1 offset:6976
		ds_read_b128 v[144:147], v1 offset:7232
		ds_read_b128 v[148:151], v1 offset:9024
		ds_read_b128 v[152:155], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[156:159] offset:6976
		ds_write_b128 v0, v[160:163] offset:11072
		ds_write_b128 v0, v[164:167] offset:15168
		ds_write_b128 v0, v[168:171] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[156:159], v1 offset:6976
		ds_read_b128 v[160:163], v1 offset:7232
		ds_read_b128 v[164:167], v1 offset:9024
		ds_read_b128 v[168:171], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[172:175] offset:6976
		ds_write_b128 v0, v[176:179] offset:11072
		ds_write_b128 v0, v[180:183] offset:15168
		ds_write_b128 v0, v[184:187] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[172:175], v1 offset:6976
		ds_read_b128 v[176:179], v1 offset:7232
		ds_read_b128 v[180:183], v1 offset:9024
		ds_read_b128 v[184:187], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s0, s0, 1
		s_add_u32 s2, s6, s0
		s_addc_u32 s3, s7, 0
		s_mov_b32 s4, s2
		s_mov_b32 s5, s3
		s_mov_b32 s6, 0x7fffffff
		s_mov_b32 s7, 0x31016000
		v_mov_b64_e32 v[188:189], v[56:57]
		v_mov_b64_e32 v[190:191], v[68:69]
		s_lshl_b32 s0, s12, 9
		v_mul_lo_u32 v3, s29, v2
		v_lshlrev_b32_e32 v3, 4, v3
		v_mul_lo_u32 v5, s29, v4
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v9, s0, v3, v5
		v_mul_lo_u32 v11, s29, v8
		v_lshlrev_b32_e32 v11, 2, v11
		v_mul_lo_u32 v12, s29, v10
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v9, v9, v11, v12
		v_lshlrev_b32_e32 v13, 7, v13
		v_add3_u32 v9, v9, v16, v13
		v_add3_u32 v9, v9, v18, v20
		buffer_store_dwordx4 v[188:191], v9, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[188:189], v[72:73]
		v_mov_b64_e32 v[190:191], v[76:77]
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v9, 16, v10
		v_lshlrev_b32_e32 v8, 1, v8
		v_xor_b32_e32 v9, v9, v8
		v_xor_b32_e32 v9, v4, v9
		v_xor_b32_e32 v9, v2, v9
		v_mul_lo_u32 v9, s29, v9
		v_lshl_add_u32 v14, v9, 1, s0
		v_add3_u32 v14, v14, v16, v13
		v_add3_u32 v14, v14, v18, v20
		buffer_store_dwordx4 v[188:191], v14, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[188:189], v[58:59]
		v_mov_b64_e32 v[190:191], v[70:71]
		v_add_u32_e32 v14, 32, v10
		v_xor_b32_e32 v14, v14, v8
		v_xor_b32_e32 v14, v4, v14
		v_xor_b32_e32 v14, v2, v14
		v_mul_lo_u32 v14, s29, v14
		v_lshl_add_u32 v15, v14, 1, s0
		v_add3_u32 v15, v15, v16, v13
		v_add3_u32 v15, v15, v18, v20
		buffer_store_dwordx4 v[188:191], v15, s[4:7], 0 offen
		v_mov_b64_e32 v[56:57], v[74:75]
		v_mov_b64_e32 v[58:59], v[78:79]
		v_add_u32_e32 v15, 48, v10
		v_xor_b32_e32 v15, v15, v8
		v_xor_b32_e32 v15, v4, v15
		v_xor_b32_e32 v15, v2, v15
		v_mul_lo_u32 v15, s29, v15
		v_lshl_add_u32 v17, v15, 1, s0
		v_add3_u32 v17, v17, v16, v13
		v_add3_u32 v17, v17, v18, v20
		buffer_store_dwordx4 v[56:59], v17, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[112:113]
		v_mov_b64_e32 v[58:59], v[144:145]
		v_add_u32_e32 v17, 64, v10
		v_xor_b32_e32 v17, v17, v8
		v_xor_b32_e32 v17, v4, v17
		v_xor_b32_e32 v17, v2, v17
		v_mul_lo_u32 v17, s29, v17
		v_lshl_add_u32 v19, v17, 1, s0
		v_add3_u32 v19, v19, v16, v13
		v_add3_u32 v19, v19, v18, v20
		buffer_store_dwordx4 v[56:59], v19, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[148:149]
		v_mov_b64_e32 v[58:59], v[152:153]
		v_add_u32_e32 v19, 0x50, v10
		v_xor_b32_e32 v19, v19, v8
		v_xor_b32_e32 v19, v4, v19
		v_xor_b32_e32 v19, v2, v19
		v_mul_lo_u32 v19, s29, v19
		v_lshl_add_u32 v21, v19, 1, s0
		v_add3_u32 v21, v21, v16, v13
		v_add3_u32 v21, v21, v18, v20
		buffer_store_dwordx4 v[56:59], v21, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[114:115]
		v_mov_b64_e32 v[58:59], v[146:147]
		v_add_u32_e32 v21, 0x60, v10
		v_xor_b32_e32 v21, v21, v8
		v_xor_b32_e32 v21, v4, v21
		v_xor_b32_e32 v21, v2, v21
		v_mul_lo_u32 v21, s29, v21
		v_lshl_add_u32 v52, v21, 1, s0
		v_add3_u32 v52, v52, v16, v13
		v_add3_u32 v52, v52, v18, v20
		buffer_store_dwordx4 v[56:59], v52, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[150:151]
		v_mov_b64_e32 v[58:59], v[154:155]
		v_add_u32_e32 v52, 0x70, v10
		v_xor_b32_e32 v52, v52, v8
		v_xor_b32_e32 v52, v4, v52
		v_xor_b32_e32 v52, v2, v52
		v_mul_lo_u32 v52, s29, v52
		v_lshl_add_u32 v53, v52, 1, s0
		v_add3_u32 v53, v53, v16, v13
		v_add3_u32 v53, v53, v18, v20
		buffer_store_dwordx4 v[56:59], v53, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[156:157]
		v_mov_b64_e32 v[58:59], v[160:161]
		v_add_u32_e32 v53, 0x80, v10
		v_xor_b32_e32 v53, v53, v8
		v_xor_b32_e32 v53, v4, v53
		v_xor_b32_e32 v53, v2, v53
		v_mul_lo_u32 v53, s29, v53
		v_lshl_add_u32 v68, v53, 1, s0
		v_add3_u32 v68, v68, v16, v13
		v_add3_u32 v68, v68, v18, v20
		buffer_store_dwordx4 v[56:59], v68, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[164:165]
		v_mov_b64_e32 v[58:59], v[168:169]
		v_add_u32_e32 v68, 0x90, v10
		v_xor_b32_e32 v68, v68, v8
		v_xor_b32_e32 v68, v4, v68
		v_xor_b32_e32 v68, v2, v68
		v_mul_lo_u32 v68, s29, v68
		v_lshl_add_u32 v69, v68, 1, s0
		v_add3_u32 v69, v69, v16, v13
		v_add3_u32 v69, v69, v18, v20
		buffer_store_dwordx4 v[56:59], v69, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[158:159]
		v_mov_b64_e32 v[58:59], v[162:163]
		v_add_u32_e32 v69, 0xa0, v10
		v_xor_b32_e32 v69, v69, v8
		v_xor_b32_e32 v69, v4, v69
		v_xor_b32_e32 v69, v2, v69
		v_mul_lo_u32 v69, s29, v69
		v_lshl_add_u32 v70, v69, 1, s0
		v_add3_u32 v70, v70, v16, v13
		v_add3_u32 v70, v70, v18, v20
		buffer_store_dwordx4 v[56:59], v70, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[166:167]
		v_mov_b64_e32 v[58:59], v[170:171]
		v_add_u32_e32 v70, 0xb0, v10
		v_xor_b32_e32 v70, v70, v8
		v_xor_b32_e32 v70, v4, v70
		v_xor_b32_e32 v70, v2, v70
		v_mul_lo_u32 v70, s29, v70
		v_lshl_add_u32 v71, v70, 1, s0
		v_add3_u32 v71, v71, v16, v13
		v_add3_u32 v71, v71, v18, v20
		buffer_store_dwordx4 v[56:59], v71, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[172:173]
		v_mov_b64_e32 v[58:59], v[176:177]
		v_add_u32_e32 v71, 0xc0, v10
		v_xor_b32_e32 v71, v71, v8
		v_xor_b32_e32 v71, v4, v71
		v_xor_b32_e32 v71, v2, v71
		v_mul_lo_u32 v71, s29, v71
		v_lshl_add_u32 v72, v71, 1, s0
		v_add3_u32 v72, v72, v16, v13
		v_add3_u32 v72, v72, v18, v20
		buffer_store_dwordx4 v[56:59], v72, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[180:181]
		v_mov_b64_e32 v[58:59], v[184:185]
		v_add_u32_e32 v72, 0xd0, v10
		v_xor_b32_e32 v72, v72, v8
		v_xor_b32_e32 v72, v4, v72
		v_xor_b32_e32 v72, v2, v72
		v_mul_lo_u32 v72, s29, v72
		v_lshl_add_u32 v73, v72, 1, s0
		v_add3_u32 v73, v73, v16, v13
		v_add3_u32 v73, v73, v18, v20
		buffer_store_dwordx4 v[56:59], v73, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[174:175]
		v_mov_b64_e32 v[58:59], v[178:179]
		v_add_u32_e32 v73, 0xe0, v10
		v_xor_b32_e32 v73, v73, v8
		v_xor_b32_e32 v73, v4, v73
		v_xor_b32_e32 v73, v2, v73
		v_mul_lo_u32 v73, s29, v73
		v_lshl_add_u32 v74, v73, 1, s0
		v_add3_u32 v74, v74, v16, v13
		v_add3_u32 v74, v74, v18, v20
		buffer_store_dwordx4 v[56:59], v74, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[56:57], v[182:183]
		v_mov_b64_e32 v[58:59], v[186:187]
		v_add_u32_e32 v10, 0xf0, v10
		v_xor_b32_e32 v8, v10, v8
		v_xor_b32_e32 v4, v4, v8
		v_xor_b32_e32 v2, v2, v4
		v_mul_lo_u32 v2, s29, v2
		v_lshl_add_u32 v4, v2, 1, s0
		v_add3_u32 v4, v4, v16, v13
		v_add3_u32 v4, v4, v18, v20
		buffer_store_dwordx4 v[56:59], v4, s[4:7], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[28:31], a[96:99], v54, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[108:111], v[32:35], a[96:99], v54, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[120:123], v[28:31], a[100:103], v54, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[124:127], v[32:35], a[100:103], v54, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[128:131], v[28:31], a[104:107], v55, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[132:135], v[32:35], a[104:107], v55, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[136:139], v[28:31], a[108:111], v55, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[140:143], v[32:35], a[108:111], v55, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[36:39], a[112:115], v54, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[40:43], a[112:115], v54, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[120:123], v[36:39], a[116:119], v54, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[124:127], v[40:43], a[116:119], v54, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[128:131], v[36:39], a[120:123], v55, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[132:135], v[40:43], a[120:123], v55, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[136:139], v[36:39], a[124:127], v55, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[140:143], v[40:43], a[124:127], v55, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[44:47], a[128:131], v54, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[48:51], a[128:131], v54, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[120:123], v[44:47], a[132:135], v54, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[124:127], v[48:51], a[132:135], v54, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[128:131], v[44:47], a[136:139], v55, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[132:135], v[48:51], a[136:139], v55, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[136:139], v[44:47], a[140:143], v55, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[140:143], v[48:51], a[140:143], v55, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[60:63], a[144:147], v54, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[64:67], a[144:147], v54, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[120:123], v[60:63], a[148:151], v54, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[124:127], v[64:67], a[148:151], v54, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[128:131], v[60:63], a[152:155], v55, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[132:135], v[64:67], a[152:155], v55, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[136:139], v[60:63], a[156:159], v55, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[140:143], v[64:67], a[156:159], v55, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], v[80:83], a[160:163], v54, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[84:87], a[160:163], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[120:123], v[80:83], a[164:167], v54, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[124:127], v[84:87], a[164:167], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[128:131], v[80:83], a[168:171], v55, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[132:135], v[84:87], a[168:171], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[136:139], v[80:83], a[172:175], v55, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[140:143], v[84:87], a[172:175], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[24:27], v[88:91], a[176:179], v54, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[92:95], a[176:179], v54, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[120:123], v[88:91], a[180:183], v54, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[124:127], v[92:95], a[180:183], v54, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[128:131], v[88:91], a[184:187], v55, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[132:135], v[92:95], a[184:187], v55, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[136:139], v[88:91], a[188:191], v55, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[140:143], v[92:95], a[188:191], v55, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[24:27], v[96:99], a[192:195], v54, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[100:103], a[192:195], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[120:123], v[96:99], a[196:199], v54, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[124:127], v[100:103], a[196:199], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[128:131], v[96:99], a[200:203], v55, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[132:135], v[100:103], a[200:203], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[136:139], v[96:99], a[204:207], v55, v23 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[140:143], v[100:103], a[204:207], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[24:27], v[104:107], a[208:211], v54, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[116:119], a[208:211], v54, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[120:123], v[104:107], a[212:215], v54, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[124:127], v[116:119], a[212:215], v54, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[128:131], v[104:107], a[216:219], v55, v23 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[132:135], v[116:119], a[216:219], v55, v23 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[136:139], v[104:107], a[220:223], v55, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[140:143], v[116:119], a[220:223], v55, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a96
		v_accvgpr_read_b32 v6, a97
		v_cvt_pk_bf16_f32 v24, v4, v6
		v_accvgpr_read_b32 v4, a98
		v_accvgpr_read_b32 v6, a99
		v_cvt_pk_bf16_f32 v25, v4, v6
		v_accvgpr_read_b32 v4, a100
		v_accvgpr_read_b32 v6, a101
		v_cvt_pk_bf16_f32 v28, v4, v6
		v_accvgpr_read_b32 v4, a102
		v_accvgpr_read_b32 v6, a103
		v_cvt_pk_bf16_f32 v29, v4, v6
		v_accvgpr_read_b32 v4, a104
		v_accvgpr_read_b32 v6, a105
		v_cvt_pk_bf16_f32 v32, v4, v6
		v_accvgpr_read_b32 v4, a106
		v_accvgpr_read_b32 v6, a107
		v_cvt_pk_bf16_f32 v33, v4, v6
		v_accvgpr_read_b32 v4, a108
		v_accvgpr_read_b32 v6, a109
		v_cvt_pk_bf16_f32 v36, v4, v6
		v_accvgpr_read_b32 v4, a110
		v_accvgpr_read_b32 v6, a111
		v_cvt_pk_bf16_f32 v37, v4, v6
		v_accvgpr_read_b32 v4, a112
		v_accvgpr_read_b32 v6, a113
		v_cvt_pk_bf16_f32 v26, v4, v6
		v_accvgpr_read_b32 v4, a114
		v_accvgpr_read_b32 v6, a115
		v_cvt_pk_bf16_f32 v27, v4, v6
		v_accvgpr_read_b32 v4, a116
		v_accvgpr_read_b32 v6, a117
		v_cvt_pk_bf16_f32 v30, v4, v6
		v_accvgpr_read_b32 v4, a118
		v_accvgpr_read_b32 v6, a119
		v_cvt_pk_bf16_f32 v31, v4, v6
		v_accvgpr_read_b32 v4, a120
		v_accvgpr_read_b32 v6, a121
		v_cvt_pk_bf16_f32 v34, v4, v6
		v_accvgpr_read_b32 v4, a122
		v_accvgpr_read_b32 v6, a123
		v_cvt_pk_bf16_f32 v35, v4, v6
		v_accvgpr_read_b32 v4, a124
		v_accvgpr_read_b32 v6, a125
		v_cvt_pk_bf16_f32 v38, v4, v6
		v_accvgpr_read_b32 v4, a126
		v_accvgpr_read_b32 v6, a127
		v_cvt_pk_bf16_f32 v39, v4, v6
		v_accvgpr_read_b32 v4, a128
		v_accvgpr_read_b32 v6, a129
		v_cvt_pk_bf16_f32 v40, v4, v6
		v_accvgpr_read_b32 v4, a130
		v_accvgpr_read_b32 v6, a131
		v_cvt_pk_bf16_f32 v41, v4, v6
		v_accvgpr_read_b32 v4, a132
		v_accvgpr_read_b32 v6, a133
		v_cvt_pk_bf16_f32 v44, v4, v6
		v_accvgpr_read_b32 v4, a134
		v_accvgpr_read_b32 v6, a135
		v_cvt_pk_bf16_f32 v45, v4, v6
		v_accvgpr_read_b32 v4, a136
		v_accvgpr_read_b32 v6, a137
		v_cvt_pk_bf16_f32 v48, v4, v6
		v_accvgpr_read_b32 v4, a138
		v_accvgpr_read_b32 v6, a139
		v_cvt_pk_bf16_f32 v49, v4, v6
		v_accvgpr_read_b32 v4, a140
		v_accvgpr_read_b32 v6, a141
		v_cvt_pk_bf16_f32 v56, v4, v6
		v_accvgpr_read_b32 v4, a142
		v_accvgpr_read_b32 v6, a143
		v_cvt_pk_bf16_f32 v57, v4, v6
		v_accvgpr_read_b32 v4, a144
		v_accvgpr_read_b32 v6, a145
		v_cvt_pk_bf16_f32 v42, v4, v6
		v_accvgpr_read_b32 v4, a146
		v_accvgpr_read_b32 v6, a147
		v_cvt_pk_bf16_f32 v43, v4, v6
		v_accvgpr_read_b32 v4, a148
		v_accvgpr_read_b32 v6, a149
		v_cvt_pk_bf16_f32 v46, v4, v6
		v_accvgpr_read_b32 v4, a150
		v_accvgpr_read_b32 v6, a151
		v_cvt_pk_bf16_f32 v47, v4, v6
		v_accvgpr_read_b32 v4, a152
		v_accvgpr_read_b32 v6, a153
		v_cvt_pk_bf16_f32 v50, v4, v6
		v_accvgpr_read_b32 v4, a154
		v_accvgpr_read_b32 v6, a155
		v_cvt_pk_bf16_f32 v51, v4, v6
		v_accvgpr_read_b32 v4, a156
		v_accvgpr_read_b32 v6, a157
		v_cvt_pk_bf16_f32 v58, v4, v6
		v_accvgpr_read_b32 v4, a158
		v_accvgpr_read_b32 v6, a159
		v_cvt_pk_bf16_f32 v59, v4, v6
		v_accvgpr_read_b32 v4, a160
		v_accvgpr_read_b32 v6, a161
		v_cvt_pk_bf16_f32 v60, v4, v6
		v_accvgpr_read_b32 v4, a162
		v_accvgpr_read_b32 v6, a163
		v_cvt_pk_bf16_f32 v61, v4, v6
		v_accvgpr_read_b32 v4, a164
		v_accvgpr_read_b32 v6, a165
		v_cvt_pk_bf16_f32 v64, v4, v6
		v_accvgpr_read_b32 v4, a166
		v_accvgpr_read_b32 v6, a167
		v_cvt_pk_bf16_f32 v65, v4, v6
		v_accvgpr_read_b32 v4, a168
		v_accvgpr_read_b32 v6, a169
		v_cvt_pk_bf16_f32 v76, v4, v6
		v_accvgpr_read_b32 v4, a170
		v_accvgpr_read_b32 v6, a171
		v_cvt_pk_bf16_f32 v77, v4, v6
		v_accvgpr_read_b32 v4, a172
		v_accvgpr_read_b32 v6, a173
		v_cvt_pk_bf16_f32 v80, v4, v6
		v_accvgpr_read_b32 v4, a174
		v_accvgpr_read_b32 v6, a175
		v_cvt_pk_bf16_f32 v81, v4, v6
		v_accvgpr_read_b32 v4, a176
		v_accvgpr_read_b32 v6, a177
		v_cvt_pk_bf16_f32 v62, v4, v6
		v_accvgpr_read_b32 v4, a178
		v_accvgpr_read_b32 v6, a179
		v_cvt_pk_bf16_f32 v63, v4, v6
		v_accvgpr_read_b32 v4, a180
		v_accvgpr_read_b32 v6, a181
		v_cvt_pk_bf16_f32 v66, v4, v6
		v_accvgpr_read_b32 v4, a182
		v_accvgpr_read_b32 v6, a183
		v_cvt_pk_bf16_f32 v67, v4, v6
		v_accvgpr_read_b32 v4, a184
		v_accvgpr_read_b32 v6, a185
		v_cvt_pk_bf16_f32 v78, v4, v6
		v_accvgpr_read_b32 v4, a186
		v_accvgpr_read_b32 v6, a187
		v_cvt_pk_bf16_f32 v79, v4, v6
		v_accvgpr_read_b32 v4, a188
		v_accvgpr_read_b32 v6, a189
		v_cvt_pk_bf16_f32 v82, v4, v6
		v_accvgpr_read_b32 v4, a190
		v_accvgpr_read_b32 v6, a191
		v_cvt_pk_bf16_f32 v83, v4, v6
		v_accvgpr_read_b32 v4, a192
		v_accvgpr_read_b32 v6, a193
		v_cvt_pk_bf16_f32 v84, v4, v6
		v_accvgpr_read_b32 v4, a194
		v_accvgpr_read_b32 v6, a195
		v_cvt_pk_bf16_f32 v85, v4, v6
		v_accvgpr_read_b32 v4, a196
		v_accvgpr_read_b32 v6, a197
		v_cvt_pk_bf16_f32 v88, v4, v6
		v_accvgpr_read_b32 v4, a198
		v_accvgpr_read_b32 v6, a199
		v_cvt_pk_bf16_f32 v89, v4, v6
		v_accvgpr_read_b32 v4, a200
		v_accvgpr_read_b32 v6, a201
		v_cvt_pk_bf16_f32 v92, v4, v6
		v_accvgpr_read_b32 v4, a202
		v_accvgpr_read_b32 v6, a203
		v_cvt_pk_bf16_f32 v93, v4, v6
		v_accvgpr_read_b32 v4, a204
		v_accvgpr_read_b32 v6, a205
		v_cvt_pk_bf16_f32 v96, v4, v6
		v_accvgpr_read_b32 v4, a206
		v_accvgpr_read_b32 v6, a207
		v_cvt_pk_bf16_f32 v97, v4, v6
		v_accvgpr_read_b32 v4, a208
		v_accvgpr_read_b32 v6, a209
		v_cvt_pk_bf16_f32 v86, v4, v6
		v_accvgpr_read_b32 v4, a210
		v_accvgpr_read_b32 v6, a211
		v_cvt_pk_bf16_f32 v87, v4, v6
		v_accvgpr_read_b32 v4, a212
		v_accvgpr_read_b32 v6, a213
		v_cvt_pk_bf16_f32 v90, v4, v6
		v_accvgpr_read_b32 v4, a214
		v_accvgpr_read_b32 v6, a215
		v_cvt_pk_bf16_f32 v91, v4, v6
		v_accvgpr_read_b32 v4, a216
		v_accvgpr_read_b32 v6, a217
		v_cvt_pk_bf16_f32 v94, v4, v6
		v_accvgpr_read_b32 v4, a218
		v_accvgpr_read_b32 v6, a219
		v_cvt_pk_bf16_f32 v95, v4, v6
		v_accvgpr_read_b32 v4, a220
		v_accvgpr_read_b32 v6, a221
		v_cvt_pk_bf16_f32 v98, v4, v6
		v_accvgpr_read_b32 v4, a222
		v_accvgpr_read_b32 v6, a223
		v_cvt_pk_bf16_f32 v99, v4, v6
		ds_write_b128 v0, v[24:27] offset:6976
		ds_write_b128 v0, v[28:31] offset:11072
		ds_write_b128 v0, v[32:35] offset:15168
		ds_write_b128 v0, v[36:39] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v1 offset:6976
		ds_read_b128 v[28:31], v1 offset:7232
		ds_read_b128 v[32:35], v1 offset:9024
		ds_read_b128 v[36:39], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[40:43] offset:6976
		ds_write_b128 v0, v[44:47] offset:11072
		ds_write_b128 v0, v[48:51] offset:15168
		ds_write_b128 v0, v[56:59] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v1 offset:6976
		ds_read_b128 v[44:47], v1 offset:7232
		ds_read_b128 v[48:51], v1 offset:9024
		ds_read_b128 v[56:59], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[60:63] offset:6976
		ds_write_b128 v0, v[64:67] offset:11072
		ds_write_b128 v0, v[76:79] offset:15168
		ds_write_b128 v0, v[80:83] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v1 offset:6976
		ds_read_b128 v[64:67], v1 offset:7232
		ds_read_b128 v[76:79], v1 offset:9024
		ds_read_b128 v[80:83], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[84:87] offset:6976
		ds_write_b128 v0, v[88:91] offset:11072
		ds_write_b128 v0, v[92:95] offset:15168
		ds_write_b128 v0, v[96:99] offset:19264
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v1 offset:6976
		ds_read_b128 v[88:91], v1 offset:7232
		ds_read_b128 v[92:95], v1 offset:9024
		ds_read_b128 v[96:99], v1 offset:9280
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[100:101], v[24:25]
		v_mov_b64_e32 v[102:103], v[28:29]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v3, v5
		v_add3_u32 v0, v0, v11, v12
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[100:103], v0, s[4:7], 0 offen
		v_mov_b64_e32 v[4:5], v[32:33]
		v_mov_b64_e32 v[6:7], v[36:37]
		v_lshl_add_u32 v0, v9, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[26:27]
		v_mov_b64_e32 v[6:7], v[30:31]
		v_lshl_add_u32 v0, v14, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[34:35]
		v_mov_b64_e32 v[6:7], v[38:39]
		v_lshl_add_u32 v0, v15, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[40:41]
		v_mov_b64_e32 v[6:7], v[44:45]
		v_lshl_add_u32 v0, v17, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[48:49]
		v_mov_b64_e32 v[6:7], v[56:57]
		v_lshl_add_u32 v0, v19, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[42:43]
		v_mov_b64_e32 v[6:7], v[46:47]
		v_lshl_add_u32 v0, v21, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[50:51]
		v_mov_b64_e32 v[6:7], v[58:59]
		v_lshl_add_u32 v0, v52, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[60:61]
		v_mov_b64_e32 v[6:7], v[64:65]
		v_lshl_add_u32 v0, v53, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[76:77]
		v_mov_b64_e32 v[6:7], v[80:81]
		v_lshl_add_u32 v0, v68, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[62:63]
		v_mov_b64_e32 v[6:7], v[66:67]
		v_lshl_add_u32 v0, v69, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[78:79]
		v_mov_b64_e32 v[6:7], v[82:83]
		v_lshl_add_u32 v0, v70, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[84:85]
		v_mov_b64_e32 v[6:7], v[88:89]
		v_lshl_add_u32 v0, v71, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[92:93]
		v_mov_b64_e32 v[6:7], v[96:97]
		v_lshl_add_u32 v0, v72, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[86:87]
		v_mov_b64_e32 v[6:7], v[90:91]
		v_lshl_add_u32 v0, v73, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[94:95]
		v_mov_b64_e32 v[6:7], v[98:99]
		v_lshl_add_u32 v0, v2, 1, s0
		v_add3_u32 v0, v0, v16, v13
		v_add3_u32 v0, v0, v18, v20
		buffer_store_dwordx4 v[4:7], v0, s[4:7], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 154432
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
		.amdhsa_next_free_vgpr 480
		.amdhsa_next_free_sgpr 85
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
	.set .L_a4w4_kernel.num_vgpr, 253
	.set .L_a4w4_kernel.num_agpr, 224
	.set .L_a4w4_kernel.numbered_sgpr, 85
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
    .group_segment_fixed_size: 154432
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     85
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     480
    .agpr_count:     224
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 58
    wave.regalloc.agpr.dwords: 222
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
