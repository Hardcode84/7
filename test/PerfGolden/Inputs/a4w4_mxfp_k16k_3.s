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
		s_xor_b32 s19, s19, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s19, s17, s19
		s_add_i32 s20, s19, s18
		v_readfirstlane_b32 s21, v1
		v_mul_lo_u32 v1, s14, v2
		v_and_b32_e32 v3, 1, v3
		v_and_b32_e32 v4, 1, v4
		v_and_b32_e32 v6, 1, v5
		v_lshrrev_b32_e32 v7, 3, v0
		s_cmp_ge_u32 s19, s12
		s_cselect_b32 s19, s20, s19
		s_add_i32 s20, s19, s18
		v_lshlrev_b32_e32 v1, 1, v1
		v_mul_lo_u32 v8, s14, v3
		v_mul_lo_u32 v9, s14, v4
		v_mul_lo_u32 v10, s14, v6
		v_and_b32_e32 v7, 1, v7
		s_cmp_ge_u32 s19, s12
		s_cselect_b32 s19, s20, s19
		s_mul_i32 s20, s18, s21
		s_add_i32 s16, s16, s19
		s_mul_hi_u32 s20, s21, s20
		s_add_i32 s20, s21, s20
		s_mul_hi_u32 s20, s17, s20
		v_add_u32_e32 v11, v1, v8
		v_lshlrev_b32_e32 v9, 6, v9
		v_lshlrev_b32_e32 v10, 5, v10
		v_mul_lo_u32 v12, s14, v7
		v_and_b32_e32 v13, 1, v0
		v_lshrrev_b32_e32 v14, 2, v0
		v_lshrrev_b32_e32 v15, 1, v0
		s_mul_i32 s21, s20, s12
		s_xor_b32 s21, s21, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s17, s17, s21
		v_add3_u32 v11, v11, v9, v10
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshlrev_b32_e32 v16, 4, v13
		v_and_b32_e32 v14, 1, v14
		v_and_b32_e32 v15, 1, v15
		s_cmp_ge_u32 s17, s12
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s20, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s20, s22, s20
		s_cselect_b32 s21, 1, 0
		s_add_i32 s18, s17, s18
		v_add3_u32 v11, v11, v12, v16
		v_lshlrev_b32_e32 v17, 6, v14
		v_lshlrev_b32_e32 v18, 5, v15
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s17, s18, s17
		v_readfirstlane_b32 s18, v0
		s_add_i32 s21, s20, 1
		s_mul_i32 s16, s16, 0x100
		s_cmp_ge_u32 s17, s12
		s_cselect_b32 s12, s21, s20
		s_mul_i32 s17, s16, s14
		v_add3_u32 v11, v11, v17, v18
		s_add_u32 s20, s2, s17
		s_addc_u32 s21, s3, 0
		s_lshr_b32 s18, s18, 6
		s_mul_i32 s18, 0x420, s18
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 m0, s18
		s_mov_b32 s23, 0x31016000
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_lshl_b32 s24, s14, 2
		v_add3_u32 v19, s24, v1, v8
		v_add3_u32 v19, v19, v9, v10
		v_add3_u32 v19, v19, v12, v16
		v_add3_u32 v19, v19, v17, v18
		s_add_i32 m0, s18, 0x1080
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_add3_u32 v20, v1, v8, v9
		v_add3_u32 v20, v20, v10, v12
		v_add3_u32 v20, v20, v16, v17
		s_lshl_b32 s25, s14, 3
		v_add3_u32 v21, v18, v20, s25
		s_add_i32 m0, s18, 0x2100
		s_nop 0
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		s_mul_i32 s26, 12, s14
		v_add3_u32 v22, v18, v20, s26
		s_add_i32 m0, s18, 0x3180
		s_nop 0
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		s_lshl_b32 s27, s14, 7
		v_add3_u32 v20, v18, v20, s27
		s_add_i32 m0, s18, 0x4200
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_add3_u32 v23, v1, v8, v9
		v_add3_u32 v23, v23, v10, v12
		v_add3_u32 v23, v23, v16, v17
		s_mul_i32 s28, 0x84, s14
		v_add3_u32 v24, v18, v23, s28
		s_add_i32 m0, s18, 0x5280
		s_nop 0
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		s_mul_i32 s29, 0x88, s14
		v_add3_u32 v25, v18, v23, s29
		s_add_i32 m0, s18, 0x6300
		s_nop 0
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		v_add3_u32 v23, v18, v23, s14
		s_add_i32 m0, s18, 0x7380
		s_nop 0
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		v_mul_lo_u32 v26, s15, v2
		v_lshlrev_b32_e32 v26, 1, v26
		v_mul_lo_u32 v27, s15, v3
		v_mul_lo_u32 v28, s15, v4
		v_mul_lo_u32 v29, s15, v6
		v_add_u32_e32 v30, v26, v27
		v_lshlrev_b32_e32 v28, 6, v28
		v_lshlrev_b32_e32 v29, 5, v29
		v_mul_lo_u32 v31, s15, v7
		v_add3_u32 v30, v30, v28, v29
		v_lshlrev_b32_e32 v31, 4, v31
		v_add3_u32 v30, v30, v31, v16
		v_add3_u32 v30, v30, v17, v18
		s_mul_i32 s30, s12, 0x100
		s_mul_i32 s30, s30, s15
		s_add_u32 s32, s4, s30
		s_addc_u32 s33, s5, 0
		s_mov_b32 s34, s22
		s_mov_b32 s35, s23
		s_add_i32 m0, s18, 0x107c0
		s_nop 0
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		v_add3_u32 v32, v26, v27, v28
		v_add3_u32 v32, v32, v29, v31
		v_add3_u32 v32, v32, v16, v17
		s_lshl_b32 s31, s15, 2
		v_add3_u32 v33, v18, v32, s31
		s_add_i32 m0, s18, 0x11840
		s_nop 0
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_lshl_b32 s36, s15, 3
		v_add3_u32 v34, v18, v32, s36
		s_add_i32 m0, s18, 0x128c0
		s_nop 0
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		s_mul_i32 s37, 12, s15
		v_add3_u32 v32, v18, v32, s37
		s_add_i32 m0, s18, 0x13940
		s_nop 0
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_lshl_b32 s13, s13, 10
		s_lshl_b32 s19, s19, 8
		s_add_i32 s13, s13, s19
		s_lshl_b32 s19, s12, 8
		s_lshl_b32 s38, s15, 7
		v_add3_u32 v35, s38, v26, v27
		v_add3_u32 v35, v35, v28, v29
		v_add3_u32 v35, v35, v31, v16
		v_add3_u32 v35, v35, v17, v18
		s_add_i32 m0, s18, 0x18b80
		s_nop 0
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		v_add3_u32 v36, v26, v27, v28
		v_add3_u32 v36, v36, v29, v31
		v_add3_u32 v36, v36, v16, v17
		s_mul_i32 s39, 0x84, s15
		v_add3_u32 v37, v18, v36, s39
		s_add_i32 m0, s18, 0x19c00
		s_nop 0
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		s_mul_i32 s40, 0x88, s15
		v_add3_u32 v38, v18, v36, s40
		s_add_i32 m0, s18, 0x1ac80
		s_nop 0
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		v_add3_u32 v36, v18, v36, s15
		s_add_i32 m0, s18, 0x1bd00
		s_nop 0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		v_add_u32_e32 v39, 0x80, v1
		v_add_u32_e32 v39, v39, v8
		v_add3_u32 v39, v39, v9, v10
		v_add3_u32 v39, v39, v12, v16
		v_add3_u32 v39, v39, v17, v18
		s_add_i32 s41, s19, 0x80
		s_add_i32 m0, s18, 0x83e0
		s_waitcnt vmcnt(4)
		s_nop 0
		buffer_load_dwordx4 v39, s[20:23], 0 offen lds
		s_add_i32 s24, s24, 0x80
		v_add3_u32 v40, s24, v1, v8
		v_add3_u32 v40, v40, v9, v10
		v_add3_u32 v40, v40, v12, v16
		v_add3_u32 v40, v40, v17, v18
		s_add_i32 m0, s18, 0x9460
		s_nop 0
		buffer_load_dwordx4 v40, s[20:23], 0 offen lds
		s_add_i32 s24, s25, 0x80
		v_add3_u32 v41, s24, v1, v8
		v_add3_u32 v41, v41, v9, v10
		v_add3_u32 v41, v41, v12, v16
		v_add3_u32 v41, v41, v17, v18
		s_add_i32 m0, s18, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v41, s[20:23], 0 offen lds
		s_add_i32 s24, s26, 0x80
		v_add3_u32 v42, s24, v1, v8
		v_add3_u32 v42, v42, v9, v10
		v_add3_u32 v42, v42, v12, v16
		v_add3_u32 v42, v42, v17, v18
		s_add_i32 m0, s18, 0xb560
		s_nop 0
		buffer_load_dwordx4 v42, s[20:23], 0 offen lds
		s_add_i32 s24, s27, 0x80
		v_add3_u32 v43, s24, v1, v8
		v_add3_u32 v43, v43, v9, v10
		v_add3_u32 v43, v43, v12, v16
		v_add3_u32 v43, v43, v17, v18
		s_add_i32 m0, s18, 0xc5e0
		s_nop 0
		buffer_load_dwordx4 v43, s[20:23], 0 offen lds
		s_add_i32 s24, s28, 0x80
		v_add3_u32 v44, s24, v1, v8
		v_add3_u32 v44, v44, v9, v10
		v_add3_u32 v44, v44, v12, v16
		v_add3_u32 v44, v44, v17, v18
		s_add_i32 m0, s18, 0xd660
		s_nop 0
		buffer_load_dwordx4 v44, s[20:23], 0 offen lds
		s_add_i32 s24, s29, 0x80
		v_add3_u32 v45, s24, v1, v8
		v_add3_u32 v45, v45, v9, v10
		v_add3_u32 v45, v45, v12, v16
		v_add3_u32 v45, v45, v17, v18
		s_add_i32 m0, s18, 0xe6e0
		s_nop 0
		buffer_load_dwordx4 v45, s[20:23], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v1, s14, v1, v8
		v_add3_u32 v1, v1, v9, v10
		v_add3_u32 v1, v1, v12, v16
		v_add3_u32 v1, v1, v17, v18
		s_add_i32 m0, s18, 0xf760
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add_u32_e32 v8, 0x80, v26
		v_add_u32_e32 v8, v8, v27
		v_add3_u32 v8, v8, v28, v29
		v_add3_u32 v8, v8, v31, v16
		v_add3_u32 v8, v8, v17, v18
		s_add_i32 m0, s18, 0x149a0
		s_nop 0
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_add3_u32 v9, v26, v27, v28
		v_add3_u32 v9, v9, v29, v31
		v_add3_u32 v9, v9, v16, v17
		s_add_i32 s14, s31, 0x80
		v_add3_u32 v10, v18, v9, s14
		s_add_i32 m0, s18, 0x15a20
		s_nop 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 s14, s36, 0x80
		v_add3_u32 v12, v18, v9, s14
		s_add_i32 m0, s18, 0x16aa0
		s_nop 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_add_i32 s14, s37, 0x80
		v_add3_u32 v9, v18, v9, s14
		s_add_i32 m0, s18, 0x17b20
		s_nop 0
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_load_dword s14, s[0:1], 0x3c
		s_load_dword s20, s[0:1], 0x40
		s_waitcnt lgkmcnt(0)
		s_lshl_b32 s21, s14, 3
		s_add_i32 s21, s13, s21
		s_lshl_b32 s22, s20, 3
		s_add_i32 s23, s19, s22
		s_add_i32 s24, s38, 0x80
		v_add3_u32 v46, s24, v26, v27
		v_add3_u32 v46, v46, v28, v29
		v_add3_u32 v46, v46, v31, v16
		v_add3_u32 v46, v46, v17, v18
		s_add_i32 m0, s18, 0x1cd60
		s_waitcnt vmcnt(12)
		s_nop 0
		buffer_load_dwordx4 v46, s[32:35], 0 offen lds
		v_add3_u32 v26, v26, v27, v28
		v_add3_u32 v26, v26, v29, v31
		v_add3_u32 v26, v26, v16, v17
		s_add_i32 s24, s39, 0x80
		v_add3_u32 v27, v18, v26, s24
		s_add_i32 m0, s18, 0x1dde0
		s_nop 0
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		s_add_i32 s24, s40, 0x80
		v_add3_u32 v28, v18, v26, s24
		s_add_i32 m0, s18, 0x1ee60
		s_nop 0
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_mul_lo_u32 v29, s14, v2
		v_mul_lo_u32 v31, s14, v3
		v_mul_lo_u32 v47, s20, v2
		v_mul_lo_u32 v48, s20, v3
		v_lshlrev_b32_e32 v29, 2, v29
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v47, 2, v47
		v_lshlrev_b32_e32 v48, 1, v48
		s_add_i32 s15, s15, 0x80
		s_add_i32 m0, s18, 0x1fee0
		s_add_i32 s22, s41, s22
		v_add3_u32 v49, s13, v29, v31
		v_mul_lo_u32 v50, s14, v4
		v_lshlrev_b32_e32 v51, 3, v13
		v_add3_u32 v52, s19, v47, v48
		v_mul_lo_u32 v53, s20, v4
		v_lshlrev_b32_e32 v54, 2, v13
		v_add3_u32 v55, s41, v47, v48
		v_add3_u32 v29, s21, v29, v31
		v_add3_u32 v31, s23, v47, v48
		v_add3_u32 v47, s22, v47, v48
		v_add3_u32 v48, v49, v50, v51
		v_lshlrev_b32_e32 v49, 7, v6
		v_lshlrev_b32_e32 v56, 6, v7
		v_add3_u32 v52, v52, v53, v54
		v_lshlrev_b32_e32 v57, 6, v6
		v_lshlrev_b32_e32 v58, 5, v7
		v_add3_u32 v55, v55, v53, v54
		v_add3_u32 v29, v29, v50, v51
		v_add3_u32 v31, v31, v53, v54
		v_add3_u32 v47, v47, v53, v54
		v_add3_u32 v48, v48, v49, v56
		v_lshlrev_b32_e32 v50, 5, v14
		v_lshlrev_b32_e32 v53, 4, v15
		v_add3_u32 v52, v52, v57, v58
		v_lshlrev_b32_e32 v54, 4, v14
		v_lshlrev_b32_e32 v59, 3, v15
		v_add3_u32 v55, v55, v57, v58
		v_add3_u32 v29, v29, v49, v56
		v_add3_u32 v31, v31, v57, v58
		v_add3_u32 v47, v47, v57, v58
		v_add3_u32 v48, v48, v50, v53
		v_add3_u32 v52, v52, v54, v59
		v_add3_u32 v55, v55, v54, v59
		v_add3_u32 v29, v29, v50, v53
		v_add3_u32 v31, v31, v54, v59
		v_add3_u32 v26, v18, v26, s15
		v_add3_u32 v47, v47, v54, v59
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s34
		s_mov_b32 s27, s35
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		buffer_load_dwordx2 v[58:59], v48, s[24:27], 0 offen
		buffer_load_dword v53, v52, s[36:39], 0 offen
		buffer_load_dword v54, v55, s[36:39], 0 offen
		buffer_load_dwordx2 v[60:61], v29, s[24:27], 0 offen
		buffer_load_dword v57, v31, s[36:39], 0 offen
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		buffer_load_dword v62, v47, s[36:39], 0 offen
		s_load_dword s13, s[0:1], 0x38
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		s_add_i32 s0, s17, 0x100
		s_mov_b32 s1, 0
		s_add_i32 s15, s30, 0x100
		s_mul_i32 s14, s14, 16
		s_mul_i32 s17, s20, 16
		s_barrier
		v_lshlrev_b32_e32 v63, 7, v2
		v_and_b32_e32 v68, 63, v0
		v_lshrrev_b32_e32 v69, 4, v68
		v_lshlrev_b32_e32 v69, 4, v69
		v_and_b32_e32 v68, 15, v68
		v_mov_b32_e32 v70, 0x420
		v_mul_lo_u32 v70, v70, v68
		v_add3_u32 v63, v63, v69, v70
		ds_read_b128 a[0:3], v63
		ds_read_b128 a[4:7], v63 offset:64
		ds_read_b128 a[8:11], v63 offset:256
		ds_read_b128 a[12:15], v63 offset:320
		ds_read_b128 a[16:19], v63 offset:512
		ds_read_b128 a[20:23], v63 offset:576
		ds_read_b128 a[24:27], v63 offset:768
		ds_read_b128 a[28:31], v63 offset:832
		ds_read_b128 a[32:35], v63 offset:16896
		ds_read_b128 a[36:39], v63 offset:16960
		ds_read_b128 a[40:43], v63 offset:17152
		ds_read_b128 a[44:47], v63 offset:17216
		ds_read_b128 a[48:51], v63 offset:17408
		ds_read_b128 a[52:55], v63 offset:17472
		ds_read_b128 a[56:59], v63 offset:17664
		ds_read_b128 a[60:63], v63 offset:17728
		v_add_u32_e32 v68, 0x10000, v69
		v_lshlrev_b32_e32 v69, 7, v3
		v_add3_u32 v68, v68, v69, v70
		ds_read_b128 a[64:67], v68 offset:1984
		ds_read_b128 a[68:71], v68 offset:2048
		ds_read_b128 a[72:75], v68 offset:2240
		ds_read_b128 a[76:79], v68 offset:2304
		ds_read_b128 a[80:83], v68 offset:2496
		ds_read_b128 a[84:87], v68 offset:2560
		ds_read_b128 a[88:91], v68 offset:2752
		ds_read_b128 a[92:95], v68 offset:2816
		v_lshlrev_b32_e32 v69, 3, v0
		v_add_u32_e32 v69, 0x20000, v69
		s_waitcnt vmcnt(6)
		ds_write_b64 v69, v[58:59] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v58, 2, v0
		v_add_u32_e32 v58, 0x20000, v58
		s_waitcnt vmcnt(5)
		ds_write_b32 v58, v53 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v53, 4, v2
		v_add_u32_e32 v53, 0x20000, v53
		v_add_u32_e32 v53, v53, v51
		v_lshl_add_u32 v53, v4, 9, v53
		v_lshlrev_b32_e32 v59, 8, v6
		v_add3_u32 v53, v53, v59, v56
		v_lshlrev_b32_e32 v59, 10, v15
		v_add3_u32 v53, v53, v50, v59
		ds_read_b64_tr_b8 v[70:71], v53 offset:3904
		ds_read_b64_tr_b8 v[72:73], v53 offset:4032
		v_add_u32_e32 v51, 0x20000, v51
		v_lshl_add_u32 v51, v3, 4, v51
		v_lshlrev_b32_e32 v74, 8, v4
		v_add3_u32 v49, v51, v74, v49
		v_add3_u32 v49, v49, v56, v50
		v_lshl_add_u32 v15, v15, 9, v49
		ds_read_b64_tr_b8 v[50:51], v15 offset:5952
		s_mov_b32 s19, s14
		s_mov_b32 s20, s17
		s_add_u32 s24, s2, s0
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, s34
		s_mov_b32 s27, s35
		s_add_u32 s28, s4, s15
		s_addc_u32 s29, s5, 0
		s_mov_b32 s30, s34
		s_mov_b32 s31, s35
		s_add_u32 s36, s8, s19
		s_addc_u32 s37, s9, 0
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		s_add_u32 s40, s10, s20
		s_addc_u32 s41, s11, 0
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		v_accvgpr_write_b32 a96, v64
		v_accvgpr_write_b32 a97, v65
		v_accvgpr_write_b32 a98, v66
		v_accvgpr_write_b32 a99, v67
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
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
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[64:67], a[0:3], v[64:67], v50, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v50, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v50, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v50, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[68:71], a[4:7], v[64:67], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v51, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v51, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v51, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v51, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v51, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v51, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v51, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v51, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v50, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v50, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v50, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v50, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v50, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v50, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v50, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v50, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v51, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v51, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v51, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v51, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v51, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v51, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v51, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v51, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v50, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v50, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v50, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v50, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[64:67], v68 offset:35712
		ds_read_b128 a[68:71], v68 offset:35776
		ds_read_b128 a[72:75], v68 offset:35968
		ds_read_b128 a[76:79], v68 offset:36032
		ds_read_b128 a[80:83], v68 offset:36224
		ds_read_b128 a[84:87], v68 offset:36288
		ds_read_b128 a[88:91], v68 offset:36480
		ds_read_b128 v[252:255], v68 offset:36544
		s_waitcnt vmcnt(4)
		ds_write_b32 v58, v54 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[50:51], v15 offset:5952
		s_mov_b32 m0, s18
		s_add_u32 s24, s2, s0
		s_addc_u32 s25, s3, 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x1080
		s_nop 0
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x2100
		s_nop 0
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x3180
		s_nop 0
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x4200
		s_nop 0
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x5280
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x6300
		s_nop 0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x7380
		s_nop 0
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_add_u32 s28, s4, s15
		s_addc_u32 s29, s5, 0
		s_add_i32 m0, s18, 0x107c0
		s_nop 0
		buffer_load_dwordx4 v30, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x11840
		s_nop 0
		buffer_load_dwordx4 v33, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x128c0
		s_nop 0
		buffer_load_dwordx4 v34, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x13940
		s_nop 0
		buffer_load_dwordx4 v32, s[28:31], 0 offen lds
		s_add_u32 s36, s8, s19
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx2 v[74:75], v48, s[36:39], 0 offen
		s_add_u32 s40, s10, s20
		s_addc_u32 s41, s11, 0
		buffer_load_dword v49, v52, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[0:3], v[196:199], v50, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[0:3], v[200:203], v50, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[8:11], v[216:219], v50, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[8:11], v[212:215], v50, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[0:3], v[204:207], v51, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[0:3], v[208:211], v51, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[8:11], v[224:227], v51, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[8:11], v[220:223], v51, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[4:7], v[208:211], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[12:15], v[224:227], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v51, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v51, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v51, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v51, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[20:23], v[240:243], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[16:19], v[228:231], v50, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[16:19], v[232:235], v50, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[72:75], a[24:27], v[248:251], v50, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[24:27], v[244:247], v50, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[28:31], v[248:251], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[28:31], v[244:247], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v50, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v50, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v50, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v50, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v51, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v51, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v51, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v51, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v51, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v51, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v51, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v51, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v50, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v50, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v50, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v50, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 a[0:3], v63 offset:33760
		ds_read_b128 a[4:7], v63 offset:33824
		ds_read_b128 a[8:11], v63 offset:34016
		ds_read_b128 a[12:15], v63 offset:34080
		ds_read_b128 a[16:19], v63 offset:34272
		ds_read_b128 a[20:23], v63 offset:34336
		ds_read_b128 a[24:27], v63 offset:34528
		ds_read_b128 a[28:31], v63 offset:34592
		ds_read_b128 a[32:35], v63 offset:50656
		ds_read_b128 a[36:39], v63 offset:50720
		ds_read_b128 a[40:43], v63 offset:50912
		ds_read_b128 a[44:47], v63 offset:50976
		ds_read_b128 a[48:51], v63 offset:51168
		ds_read_b128 a[52:55], v63 offset:51232
		ds_read_b128 a[56:59], v63 offset:51424
		ds_read_b128 a[60:63], v63 offset:51488
		ds_read_b128 a[64:67], v68 offset:18848
		ds_read_b128 a[68:71], v68 offset:18912
		ds_read_b128 a[72:75], v68 offset:19104
		ds_read_b128 a[76:79], v68 offset:19168
		ds_read_b128 a[80:83], v68 offset:19360
		ds_read_b128 a[84:87], v68 offset:19424
		ds_read_b128 a[88:91], v68 offset:19616
		ds_read_b128 v[252:255], v68 offset:19680
		s_waitcnt vmcnt(17)
		ds_write_b64 v69, v[60:61] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(16)
		ds_write_b32 v58, v57 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[50:51], v53 offset:3904
		ds_read_b64_tr_b8 v[70:71], v53 offset:4032
		ds_read_b64_tr_b8 v[56:57], v15 offset:5952
		s_add_i32 m0, s18, 0x18b80
		s_nop 0
		buffer_load_dwordx4 v35, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x19c00
		s_nop 0
		buffer_load_dwordx4 v37, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1ac80
		s_nop 0
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1bd00
		s_nop 0
		buffer_load_dwordx4 v36, s[28:31], 0 offen lds
		buffer_load_dword v54, v55, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[64:67], a[0:3], v[64:67], v56, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v56, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v56, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v56, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[68:71], a[4:7], v[64:67], v56, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v56, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v56, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v56, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v57, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v57, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v57, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v57, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v57, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[4:7], v[80:83], v57, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[12:15], v[96:99], v57, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v57, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v57, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v57, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v57, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v57, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v57, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[20:23], v[112:115], v57, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[28:31], v[128:131], v57, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v57, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v56, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v56, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v56, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v56, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v56, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v56, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v56, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v56, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v56, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v56, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v56, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v56, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v56, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v56, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v56, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v56, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v57, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v57, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v57, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v57, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v57, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[36:39], v[144:147], v57, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[44:47], v[160:163], v57, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v57, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v57, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v57, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v57, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v57, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v57, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[52:55], v[176:179], v57, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[60:63], v[192:195], v57, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v57, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v56, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v56, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v56, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v56, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v56, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v56, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v56, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v56, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[64:67], v68 offset:52576
		ds_read_b128 a[68:71], v68 offset:52640
		ds_read_b128 a[72:75], v68 offset:52832
		ds_read_b128 a[76:79], v68 offset:52896
		ds_read_b128 a[80:83], v68 offset:53088
		ds_read_b128 a[84:87], v68 offset:53152
		ds_read_b128 a[88:91], v68 offset:53344
		ds_read_b128 v[252:255], v68 offset:53408
		s_waitcnt vmcnt(19)
		ds_write_b32 v58, v62 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[72:73], v15 offset:5952
		s_add_i32 m0, s18, 0x83e0
		s_nop 0
		buffer_load_dwordx4 v39, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x9460
		s_nop 0
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v41, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xb560
		s_nop 0
		buffer_load_dwordx4 v42, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xc5e0
		s_nop 0
		buffer_load_dwordx4 v43, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xd660
		s_nop 0
		buffer_load_dwordx4 v44, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xe6e0
		s_nop 0
		buffer_load_dwordx4 v45, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0xf760
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 m0, s18, 0x149a0
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x15a20
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x16aa0
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x17b20
		s_nop 0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		buffer_load_dwordx2 v[60:61], v29, s[36:39], 0 offen
		buffer_load_dword v57, v31, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[0:3], v[196:199], v72, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[0:3], v[200:203], v72, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[8:11], v[216:219], v72, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[8:11], v[212:215], v72, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v72, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v72, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v72, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v72, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[0:3], v[204:207], v73, v50 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[0:3], v[208:211], v73, v50 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[8:11], v[224:227], v73, v50 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[8:11], v[220:223], v73, v50 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v73, v50 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[4:7], v[208:211], v73, v50 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[12:15], v[224:227], v73, v50 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v73, v50 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v73, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v73, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v73, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v73, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v73, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[20:23], v[240:243], v73, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v73, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v73, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[16:19], v[228:231], v72, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[16:19], v[232:235], v72, v51 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[72:75], a[24:27], v[248:251], v72, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[24:27], v[244:247], v72, v51 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v72, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v72, v51 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[28:31], v[248:251], v72, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[28:31], v[244:247], v72, v51 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v72, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v72, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v72, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v72, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v72, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v72, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v72, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v72, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v73, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v73, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v73, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v73, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v73, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v73, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v73, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v73, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v73, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v73, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v73, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v73, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v73, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v73, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v73, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v73, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v72, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v72, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v72, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v72, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v72, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v72, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v72, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v72, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[0:3], v63
		ds_read_b128 a[4:7], v63 offset:64
		ds_read_b128 a[8:11], v63 offset:256
		ds_read_b128 a[12:15], v63 offset:320
		ds_read_b128 a[16:19], v63 offset:512
		ds_read_b128 a[20:23], v63 offset:576
		ds_read_b128 a[24:27], v63 offset:768
		ds_read_b128 a[28:31], v63 offset:832
		ds_read_b128 a[32:35], v63 offset:16896
		ds_read_b128 a[36:39], v63 offset:16960
		ds_read_b128 a[40:43], v63 offset:17152
		ds_read_b128 a[44:47], v63 offset:17216
		ds_read_b128 a[48:51], v63 offset:17408
		ds_read_b128 a[52:55], v63 offset:17472
		ds_read_b128 a[56:59], v63 offset:17664
		ds_read_b128 a[60:63], v63 offset:17728
		ds_read_b128 a[64:67], v68 offset:1984
		ds_read_b128 a[68:71], v68 offset:2048
		ds_read_b128 a[72:75], v68 offset:2240
		ds_read_b128 a[76:79], v68 offset:2304
		ds_read_b128 a[80:83], v68 offset:2496
		ds_read_b128 a[84:87], v68 offset:2560
		ds_read_b128 a[88:91], v68 offset:2752
		ds_read_b128 a[92:95], v68 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v69, v[74:75] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(19)
		ds_write_b32 v58, v49 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[70:71], v53 offset:3904
		ds_read_b64_tr_b8 v[72:73], v53 offset:4032
		ds_read_b64_tr_b8 v[50:51], v15 offset:5952
		s_add_i32 m0, s18, 0x1cd60
		s_nop 0
		buffer_load_dwordx4 v46, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1dde0
		s_nop 0
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1ee60
		s_nop 0
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1fee0
		s_nop 0
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		buffer_load_dword v62, v47, s[40:43], 0 offen
		s_add_i32 s0, s0, 0x100
		s_add_i32 s15, s15, 0x100
		s_add_i32 s19, s19, s14
		s_add_i32 s20, s20, s17
		s_add_i32 s1, s1, 2
		s_cmp_lt_i32 s1, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[64:67], a[0:3], v[64:67], v50, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v50, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v50, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v50, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[68:71], a[4:7], v[64:67], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v50, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v50, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v51, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v51, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v51, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v51, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v51, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v51, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v51, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v51, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v51, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v51, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v51, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v51, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v50, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v50, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v50, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v50, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v50, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v50, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v50, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v50, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v50, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v50, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v50, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v50, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v51, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v51, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v51, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v51, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v51, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v51, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v51, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v51, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v51, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v51, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v51, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v51, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v50, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v50, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v50, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v50, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v50, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v50, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[8:11], v68 offset:35712
		ds_read_b128 v[20:23], v68 offset:35776
		ds_read_b128 v[24:27], v68 offset:35968
		ds_read_b128 v[28:31], v68 offset:36032
		ds_read_b128 v[32:35], v68 offset:36224
		ds_read_b128 v[36:39], v68 offset:36288
		ds_read_b128 v[40:43], v68 offset:36480
		ds_read_b128 v[44:47], v68 offset:36544
		ds_write_b32 v58, v54 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[48:49], v15 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[8:11], a[0:3], v[196:199], v48, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], a[0:3], v[200:203], v48, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], a[8:11], v[216:219], v48, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[8:11], a[8:11], v[212:215], v48, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], a[4:7], v[196:199], v48, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], a[4:7], v[200:203], v48, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], a[12:15], v[216:219], v48, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[20:23], a[12:15], v[212:215], v48, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], a[0:3], v[204:207], v49, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], a[0:3], v[208:211], v49, v70 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], a[8:11], v[224:227], v49, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], a[8:11], v[220:223], v49, v70 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], a[4:7], v[204:207], v49, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], a[4:7], v[208:211], v49, v70 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], a[12:15], v[224:227], v49, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], a[12:15], v[220:223], v49, v70 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], a[16:19], v[236:239], v49, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], a[16:19], v[240:243], v49, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[24:27], a[104:107], v49, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[32:35], a[24:27], a[100:103], v49, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[36:39], a[20:23], v[236:239], v49, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], a[20:23], v[240:243], v49, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], a[28:31], a[104:107], v49, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], a[28:31], a[100:103], v49, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[8:11], a[16:19], v[228:231], v48, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[24:27], a[16:19], v[232:235], v48, v71 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[24:27], a[24:27], v[248:251], v48, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[8:11], a[24:27], v[244:247], v48, v71 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[20:23], a[20:23], v[228:231], v48, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], a[20:23], v[232:235], v48, v71 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[28:31], a[28:31], v[248:251], v48, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[20:23], a[28:31], v[244:247], v48, v71 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[8:11], a[32:35], a[108:111], v48, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], a[32:35], a[112:115], v48, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], a[40:43], a[128:131], v48, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[8:11], a[40:43], a[124:127], v48, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[36:39], a[108:111], v48, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], a[36:39], a[112:115], v48, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], a[44:47], a[128:131], v48, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[44:47], a[124:127], v48, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], a[32:35], a[116:119], v49, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[32:35], a[120:123], v49, v72 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[40:43], a[136:139], v49, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], a[40:43], a[132:135], v49, v72 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], a[36:39], a[116:119], v49, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], a[36:39], a[120:123], v49, v72 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], a[44:47], a[136:139], v49, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[36:39], a[44:47], a[132:135], v49, v72 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], a[48:51], a[148:151], v49, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], a[48:51], a[152:155], v49, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], a[56:59], a[168:171], v49, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], a[56:59], a[164:167], v49, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], a[52:55], a[148:151], v49, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], a[52:55], a[152:155], v49, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[44:47], a[60:63], a[168:171], v49, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], a[60:63], a[164:167], v49, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[8:11], a[48:51], a[140:143], v48, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], a[48:51], a[144:147], v48, v73 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], a[56:59], a[160:163], v48, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[8:11], a[56:59], a[156:159], v48, v73 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[52:55], a[140:143], v48, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], a[52:55], a[144:147], v48, v73 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], a[60:63], a[160:163], v48, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[60:63], a[156:159], v48, v73 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v63 offset:33760
		ds_read_b128 v[20:23], v63 offset:33824
		ds_read_b128 v[24:27], v63 offset:34016
		ds_read_b128 a[0:3], v63 offset:34080
		ds_read_b128 a[4:7], v63 offset:34272
		ds_read_b128 a[8:11], v63 offset:34336
		ds_read_b128 a[12:15], v63 offset:34528
		ds_read_b128 a[16:19], v63 offset:34592
		ds_read_b128 a[20:23], v63 offset:50656
		ds_read_b128 a[24:27], v63 offset:50720
		ds_read_b128 a[28:31], v63 offset:50912
		ds_read_b128 a[32:35], v63 offset:50976
		ds_read_b128 a[36:39], v63 offset:51168
		ds_read_b128 a[40:43], v63 offset:51232
		ds_read_b128 a[44:47], v63 offset:51424
		ds_read_b128 a[48:51], v63 offset:51488
		ds_read_b128 v[28:31], v68 offset:18848
		ds_read_b128 v[32:35], v68 offset:18912
		ds_read_b128 v[36:39], v68 offset:19104
		ds_read_b128 v[40:43], v68 offset:19168
		ds_read_b128 v[44:47], v68 offset:19360
		ds_read_b128 v[48:51], v68 offset:19424
		ds_read_b128 v[72:75], v68 offset:19616
		ds_read_b128 v[252:255], v68 offset:19680
		ds_write_b64 v69, v[60:61] offset:3904
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v58, v57 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[54:55], v53 offset:3904
		ds_read_b64_tr_b8 v[56:57], v53 offset:4032
		ds_read_b64_tr_b8 v[52:53], v15 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[28:31], v[8:11], v[64:67], v52, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], v[8:11], a[96:99], v52, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[36:39], v[24:27], v[88:91], v52, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[28:31], v[24:27], v[84:87], v52, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[32:35], v[20:23], v[64:67], v52, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], v[20:23], a[96:99], v52, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[40:43], a[0:3], v[88:91], v52, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], a[0:3], v[84:87], v52, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[44:47], v[8:11], v[76:79], v53, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[72:75], v[8:11], v[80:83], v53, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[72:75], v[24:27], v[96:99], v53, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[44:47], v[24:27], v[92:95], v53, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[48:51], v[20:23], v[76:79], v53, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], v[20:23], v[80:83], v53, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[0:3], v[96:99], v53, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[48:51], a[0:3], v[92:95], v53, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[44:47], a[4:7], v[108:111], v53, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[72:75], a[4:7], v[112:115], v53, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], a[12:15], v[128:131], v53, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[44:47], a[12:15], v[124:127], v53, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[48:51], a[8:11], v[108:111], v53, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[8:11], v[112:115], v53, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[16:19], v[128:131], v53, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[48:51], a[16:19], v[124:127], v53, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[28:31], a[4:7], v[100:103], v52, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[36:39], a[4:7], v[104:107], v52, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], a[12:15], v[120:123], v52, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[28:31], a[12:15], v[116:119], v52, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[8:11], v[100:103], v52, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[40:43], a[8:11], v[104:107], v52, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], a[16:19], v[120:123], v52, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], a[16:19], v[116:119], v52, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], a[20:23], v[132:135], v52, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], a[20:23], v[136:139], v52, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], a[28:31], v[152:155], v52, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], a[28:31], v[148:151], v52, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], a[24:27], v[132:135], v52, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], a[24:27], v[136:139], v52, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], a[32:35], v[152:155], v52, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], a[32:35], v[148:151], v52, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[44:47], a[20:23], v[140:143], v53, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], a[20:23], v[144:147], v53, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], a[28:31], v[160:163], v53, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[44:47], a[28:31], v[156:159], v53, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], a[24:27], v[140:143], v53, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[24:27], v[144:147], v53, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[32:35], v[160:163], v53, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], a[32:35], v[156:159], v53, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], a[36:39], v[172:175], v53, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], a[36:39], v[176:179], v53, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[72:75], a[44:47], v[192:195], v53, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], a[44:47], v[188:191], v53, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], a[40:43], v[172:175], v53, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[40:43], v[176:179], v53, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[48:51], v[192:195], v53, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], a[48:51], v[188:191], v53, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], a[36:39], v[164:167], v52, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[36:39], v[168:171], v52, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[44:47], v[184:187], v52, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], a[44:47], v[180:183], v52, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], a[40:43], v[164:167], v52, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], a[40:43], v[168:171], v52, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], a[48:51], v[184:187], v52, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], a[48:51], v[180:183], v52, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v68 offset:52576
		ds_read_b128 v[32:35], v68 offset:52640
		ds_read_b128 v[36:39], v68 offset:52832
		ds_read_b128 v[40:43], v68 offset:52896
		ds_read_b128 v[44:47], v68 offset:53088
		ds_read_b128 v[48:51], v68 offset:53152
		ds_read_b128 v[72:75], v68 offset:53344
		ds_read_b128 v[252:255], v68 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v58, v62 offset:5952
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[52:53], v15 offset:5952
		s_mul_i32 s0, s16, s13
		v_cvt_pk_bf16_f32 v60, v64, v65
		v_cvt_pk_bf16_f32 v61, v66, v67
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v12, a97
		v_cvt_pk_bf16_f32 v64, v1, v12
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v12, a99
		v_cvt_pk_bf16_f32 v65, v1, v12
		v_cvt_pk_bf16_f32 v68, v76, v77
		v_cvt_pk_bf16_f32 v69, v78, v79
		v_cvt_pk_bf16_f32 v76, v80, v81
		v_cvt_pk_bf16_f32 v77, v82, v83
		v_cvt_pk_bf16_f32 v62, v84, v85
		v_cvt_pk_bf16_f32 v63, v86, v87
		v_cvt_pk_bf16_f32 v66, v88, v89
		v_cvt_pk_bf16_f32 v67, v90, v91
		v_cvt_pk_bf16_f32 v70, v92, v93
		v_cvt_pk_bf16_f32 v71, v94, v95
		v_cvt_pk_bf16_f32 v78, v96, v97
		v_cvt_pk_bf16_f32 v79, v98, v99
		v_cvt_pk_bf16_f32 v80, v100, v101
		v_cvt_pk_bf16_f32 v81, v102, v103
		v_cvt_pk_bf16_f32 v84, v104, v105
		v_cvt_pk_bf16_f32 v85, v106, v107
		v_cvt_pk_bf16_f32 v88, v108, v109
		v_cvt_pk_bf16_f32 v89, v110, v111
		v_cvt_pk_bf16_f32 v92, v112, v113
		v_cvt_pk_bf16_f32 v93, v114, v115
		v_cvt_pk_bf16_f32 v82, v116, v117
		v_cvt_pk_bf16_f32 v83, v118, v119
		v_cvt_pk_bf16_f32 v86, v120, v121
		v_cvt_pk_bf16_f32 v87, v122, v123
		v_cvt_pk_bf16_f32 v90, v124, v125
		v_cvt_pk_bf16_f32 v91, v126, v127
		v_cvt_pk_bf16_f32 v94, v128, v129
		v_cvt_pk_bf16_f32 v95, v130, v131
		v_cvt_pk_bf16_f32 v96, v132, v133
		v_cvt_pk_bf16_f32 v97, v134, v135
		v_cvt_pk_bf16_f32 v100, v136, v137
		v_cvt_pk_bf16_f32 v101, v138, v139
		v_cvt_pk_bf16_f32 v104, v140, v141
		v_cvt_pk_bf16_f32 v105, v142, v143
		v_cvt_pk_bf16_f32 v108, v144, v145
		v_cvt_pk_bf16_f32 v109, v146, v147
		v_cvt_pk_bf16_f32 v98, v148, v149
		v_cvt_pk_bf16_f32 v99, v150, v151
		v_cvt_pk_bf16_f32 v102, v152, v153
		v_cvt_pk_bf16_f32 v103, v154, v155
		v_cvt_pk_bf16_f32 v106, v156, v157
		v_cvt_pk_bf16_f32 v107, v158, v159
		v_cvt_pk_bf16_f32 v110, v160, v161
		v_cvt_pk_bf16_f32 v111, v162, v163
		v_cvt_pk_bf16_f32 v112, v164, v165
		v_cvt_pk_bf16_f32 v113, v166, v167
		v_cvt_pk_bf16_f32 v116, v168, v169
		v_cvt_pk_bf16_f32 v117, v170, v171
		v_cvt_pk_bf16_f32 v120, v172, v173
		v_cvt_pk_bf16_f32 v121, v174, v175
		v_cvt_pk_bf16_f32 v124, v176, v177
		v_cvt_pk_bf16_f32 v125, v178, v179
		v_cvt_pk_bf16_f32 v114, v180, v181
		v_cvt_pk_bf16_f32 v115, v182, v183
		v_cvt_pk_bf16_f32 v118, v184, v185
		v_cvt_pk_bf16_f32 v119, v186, v187
		v_cvt_pk_bf16_f32 v122, v188, v189
		v_cvt_pk_bf16_f32 v123, v190, v191
		v_cvt_pk_bf16_f32 v126, v192, v193
		v_cvt_pk_bf16_f32 v127, v194, v195
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[60:63]
		ds_write_b128 v0, v[64:67] offset:4096
		ds_write_b128 v0, v[68:71] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v1, 9, v13
		v_lshl_add_u32 v1, v5, 4, v1
		v_lshl_add_u32 v1, v7, 13, v1
		v_lshlrev_b32_e32 v5, 12, v14
		v_add3_u32 v1, v1, v5, v59
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[60:63], v1 offset:256
		ds_read_b128 v[64:67], v1 offset:2048
		ds_read_b128 v[68:71], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v1
		ds_read_b128 v[80:83], v1 offset:256
		ds_read_b128 v[84:87], v1 offset:2048
		ds_read_b128 v[88:91], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[96:99]
		ds_write_b128 v0, v[100:103] offset:4096
		ds_write_b128 v0, v[104:107] offset:8192
		ds_write_b128 v0, v[108:111] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1
		ds_read_b128 v[96:99], v1 offset:256
		ds_read_b128 v[100:103], v1 offset:2048
		ds_read_b128 v[104:107], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[112:115]
		ds_write_b128 v0, v[116:119] offset:4096
		ds_write_b128 v0, v[120:123] offset:8192
		ds_write_b128 v0, v[124:127] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v1
		ds_read_b128 v[112:115], v1 offset:256
		ds_read_b128 v[116:119], v1 offset:2048
		ds_read_b128 v[120:123], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s0, s0, 1
		s_add_u32 s8, s6, s0
		s_addc_u32 s9, s7, 0
		s_mov_b32 s10, s34
		s_mov_b32 s11, s35
		v_mov_b64_e32 v[124:125], v[12:13]
		v_mov_b64_e32 v[126:127], v[60:61]
		s_lshl_b32 s0, s12, 9
		v_mul_lo_u32 v5, s13, v2
		v_lshlrev_b32_e32 v5, 4, v5
		v_mul_lo_u32 v12, s13, v3
		v_lshlrev_b32_e32 v12, 3, v12
		v_add3_u32 v13, s0, v5, v12
		v_mul_lo_u32 v19, s13, v4
		v_lshlrev_b32_e32 v19, 2, v19
		v_mul_lo_u32 v58, s13, v6
		v_lshlrev_b32_e32 v58, 1, v58
		v_add3_u32 v13, v13, v19, v58
		v_lshlrev_b32_e32 v7, 7, v7
		v_add3_u32 v13, v13, v16, v7
		v_add3_u32 v13, v13, v17, v18
		buffer_store_dwordx4 v[124:127], v13, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[124:125], v[64:65]
		v_mov_b64_e32 v[126:127], v[68:69]
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v13, 16, v6
		v_lshlrev_b32_e32 v4, 1, v4
		v_xor_b32_e32 v13, v13, v4
		v_xor_b32_e32 v13, v3, v13
		v_xor_b32_e32 v13, v2, v13
		v_mul_lo_u32 v13, s13, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add_u32_e32 v59, s0, v13
		v_add3_u32 v59, v59, v16, v7
		v_add3_u32 v59, v59, v17, v18
		buffer_store_dwordx4 v[124:127], v59, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[124:125], v[14:15]
		v_mov_b64_e32 v[126:127], v[62:63]
		v_add_u32_e32 v14, 32, v6
		v_xor_b32_e32 v14, v14, v4
		v_xor_b32_e32 v14, v3, v14
		v_xor_b32_e32 v14, v2, v14
		v_mul_lo_u32 v14, s13, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v15, s0, v14
		v_add3_u32 v15, v15, v16, v7
		v_add3_u32 v15, v15, v17, v18
		buffer_store_dwordx4 v[124:127], v15, s[8:11], 0 offen
		v_mov_b64_e32 v[60:61], v[66:67]
		v_mov_b64_e32 v[62:63], v[70:71]
		v_add_u32_e32 v15, 48, v6
		v_xor_b32_e32 v15, v15, v4
		v_xor_b32_e32 v15, v3, v15
		v_xor_b32_e32 v15, v2, v15
		v_mul_lo_u32 v15, s13, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add_u32_e32 v59, s0, v15
		v_add3_u32 v59, v59, v16, v7
		v_add3_u32 v59, v59, v17, v18
		buffer_store_dwordx4 v[60:63], v59, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[76:77]
		v_mov_b64_e32 v[62:63], v[80:81]
		v_add_u32_e32 v59, 64, v6
		v_xor_b32_e32 v59, v59, v4
		v_xor_b32_e32 v59, v3, v59
		v_xor_b32_e32 v59, v2, v59
		v_mul_lo_u32 v59, s13, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add_u32_e32 v64, s0, v59
		v_add3_u32 v64, v64, v16, v7
		v_add3_u32 v64, v64, v17, v18
		buffer_store_dwordx4 v[60:63], v64, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[84:85]
		v_mov_b64_e32 v[62:63], v[88:89]
		v_add_u32_e32 v64, 0x50, v6
		v_xor_b32_e32 v64, v64, v4
		v_xor_b32_e32 v64, v3, v64
		v_xor_b32_e32 v64, v2, v64
		v_mul_lo_u32 v64, s13, v64
		v_lshlrev_b32_e32 v64, 1, v64
		v_add_u32_e32 v65, s0, v64
		v_add3_u32 v65, v65, v16, v7
		v_add3_u32 v65, v65, v17, v18
		buffer_store_dwordx4 v[60:63], v65, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[78:79]
		v_mov_b64_e32 v[62:63], v[82:83]
		v_add_u32_e32 v65, 0x60, v6
		v_xor_b32_e32 v65, v65, v4
		v_xor_b32_e32 v65, v3, v65
		v_xor_b32_e32 v65, v2, v65
		v_mul_lo_u32 v65, s13, v65
		v_lshlrev_b32_e32 v65, 1, v65
		v_add_u32_e32 v66, s0, v65
		v_add3_u32 v66, v66, v16, v7
		v_add3_u32 v66, v66, v17, v18
		buffer_store_dwordx4 v[60:63], v66, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[86:87]
		v_mov_b64_e32 v[62:63], v[90:91]
		v_add_u32_e32 v66, 0x70, v6
		v_xor_b32_e32 v66, v66, v4
		v_xor_b32_e32 v66, v3, v66
		v_xor_b32_e32 v66, v2, v66
		v_mul_lo_u32 v66, s13, v66
		v_lshlrev_b32_e32 v66, 1, v66
		v_add_u32_e32 v67, s0, v66
		v_add3_u32 v67, v67, v16, v7
		v_add3_u32 v67, v67, v17, v18
		buffer_store_dwordx4 v[60:63], v67, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[92:93]
		v_mov_b64_e32 v[62:63], v[96:97]
		v_add_u32_e32 v67, 0x80, v6
		v_xor_b32_e32 v67, v67, v4
		v_xor_b32_e32 v67, v3, v67
		v_xor_b32_e32 v67, v2, v67
		v_mul_lo_u32 v67, s13, v67
		v_lshlrev_b32_e32 v67, 1, v67
		v_add_u32_e32 v68, s0, v67
		v_add3_u32 v68, v68, v16, v7
		v_add3_u32 v68, v68, v17, v18
		buffer_store_dwordx4 v[60:63], v68, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[100:101]
		v_mov_b64_e32 v[62:63], v[104:105]
		v_add_u32_e32 v68, 0x90, v6
		v_xor_b32_e32 v68, v68, v4
		v_xor_b32_e32 v68, v3, v68
		v_xor_b32_e32 v68, v2, v68
		v_mul_lo_u32 v68, s13, v68
		v_lshlrev_b32_e32 v68, 1, v68
		v_add_u32_e32 v69, s0, v68
		v_add3_u32 v69, v69, v16, v7
		v_add3_u32 v69, v69, v17, v18
		buffer_store_dwordx4 v[60:63], v69, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[94:95]
		v_mov_b64_e32 v[62:63], v[98:99]
		v_add_u32_e32 v69, 0xa0, v6
		v_xor_b32_e32 v69, v69, v4
		v_xor_b32_e32 v69, v3, v69
		v_xor_b32_e32 v69, v2, v69
		v_mul_lo_u32 v69, s13, v69
		v_lshlrev_b32_e32 v69, 1, v69
		v_add_u32_e32 v70, s0, v69
		v_add3_u32 v70, v70, v16, v7
		v_add3_u32 v70, v70, v17, v18
		buffer_store_dwordx4 v[60:63], v70, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[102:103]
		v_mov_b64_e32 v[62:63], v[106:107]
		v_add_u32_e32 v70, 0xb0, v6
		v_xor_b32_e32 v70, v70, v4
		v_xor_b32_e32 v70, v3, v70
		v_xor_b32_e32 v70, v2, v70
		v_mul_lo_u32 v70, s13, v70
		v_lshlrev_b32_e32 v70, 1, v70
		v_add_u32_e32 v71, s0, v70
		v_add3_u32 v71, v71, v16, v7
		v_add3_u32 v71, v71, v17, v18
		buffer_store_dwordx4 v[60:63], v71, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[108:109]
		v_mov_b64_e32 v[62:63], v[112:113]
		v_add_u32_e32 v71, 0xc0, v6
		v_xor_b32_e32 v71, v71, v4
		v_xor_b32_e32 v71, v3, v71
		v_xor_b32_e32 v71, v2, v71
		v_mul_lo_u32 v71, s13, v71
		v_lshlrev_b32_e32 v71, 1, v71
		v_add_u32_e32 v76, s0, v71
		v_add3_u32 v76, v76, v16, v7
		v_add3_u32 v76, v76, v17, v18
		buffer_store_dwordx4 v[60:63], v76, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[116:117]
		v_mov_b64_e32 v[62:63], v[120:121]
		v_add_u32_e32 v76, 0xd0, v6
		v_xor_b32_e32 v76, v76, v4
		v_xor_b32_e32 v76, v3, v76
		v_xor_b32_e32 v76, v2, v76
		v_mul_lo_u32 v76, s13, v76
		v_lshlrev_b32_e32 v76, 1, v76
		v_add_u32_e32 v77, s0, v76
		v_add3_u32 v77, v77, v16, v7
		v_add3_u32 v77, v77, v17, v18
		buffer_store_dwordx4 v[60:63], v77, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[110:111]
		v_mov_b64_e32 v[62:63], v[114:115]
		v_add_u32_e32 v77, 0xe0, v6
		v_xor_b32_e32 v77, v77, v4
		v_xor_b32_e32 v77, v3, v77
		v_xor_b32_e32 v77, v2, v77
		v_mul_lo_u32 v77, s13, v77
		v_lshlrev_b32_e32 v77, 1, v77
		v_add_u32_e32 v78, s0, v77
		v_add3_u32 v78, v78, v16, v7
		v_add3_u32 v78, v78, v17, v18
		buffer_store_dwordx4 v[60:63], v78, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[60:61], v[118:119]
		v_mov_b64_e32 v[62:63], v[122:123]
		v_add_u32_e32 v6, 0xf0, v6
		v_xor_b32_e32 v4, v6, v4
		v_xor_b32_e32 v3, v3, v4
		v_xor_b32_e32 v2, v2, v3
		v_mul_lo_u32 v2, s13, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v3, s0, v2
		v_add3_u32 v3, v3, v16, v7
		v_add3_u32 v3, v3, v17, v18
		buffer_store_dwordx4 v[60:63], v3, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[8:11], v[196:199], v52, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[8:11], v[200:203], v52, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[24:27], v[216:219], v52, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[24:27], v[212:215], v52, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[20:23], v[196:199], v52, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[20:23], v[200:203], v52, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[0:3], v[216:219], v52, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[0:3], v[212:215], v52, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[8:11], v[204:207], v53, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[72:75], v[8:11], v[208:211], v53, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[72:75], v[24:27], v[224:227], v53, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[24:27], v[220:223], v53, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[20:23], v[204:207], v53, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], v[20:23], v[208:211], v53, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[0:3], v[224:227], v53, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], a[0:3], v[220:223], v53, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], a[4:7], v[236:239], v53, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[72:75], a[4:7], v[240:243], v53, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], a[12:15], a[104:107], v53, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], a[12:15], a[100:103], v53, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[8:11], v[236:239], v53, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[8:11], v[240:243], v53, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[16:19], a[104:107], v53, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[48:51], a[16:19], a[100:103], v53, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[4:7], v[228:231], v52, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[4:7], v[232:235], v52, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[12:15], v[248:251], v52, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], a[12:15], v[244:247], v52, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[8:11], v[228:231], v52, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[8:11], v[232:235], v52, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[40:43], a[16:19], v[248:251], v52, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], a[16:19], v[244:247], v52, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[20:23], a[108:111], v52, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[20:23], a[112:115], v52, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[28:31], a[128:131], v52, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[28:31], a[124:127], v52, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], a[24:27], a[108:111], v52, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[24:27], a[112:115], v52, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[32:35], a[128:131], v52, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], a[32:35], a[124:127], v52, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[20:23], a[116:119], v53, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[72:75], a[20:23], a[120:123], v53, v56 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[72:75], a[28:31], a[136:139], v53, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[28:31], a[132:135], v53, v56 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[24:27], a[116:119], v53, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[24:27], a[120:123], v53, v56 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[32:35], a[136:139], v53, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[32:35], a[132:135], v53, v56 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[36:39], a[148:151], v53, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[72:75], a[36:39], a[152:155], v53, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[72:75], a[44:47], a[168:171], v53, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[44:47], a[164:167], v53, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[40:43], a[148:151], v53, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[40:43], a[152:155], v53, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[48:51], a[168:171], v53, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[48:51], a[164:167], v53, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[36:39], a[140:143], v52, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[36:39], a[144:147], v52, v57 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[44:47], a[160:163], v52, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[44:47], a[156:159], v52, v57 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], a[40:43], a[140:143], v52, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[40:43], a[144:147], v52, v57 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[48:51], a[160:163], v52, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], a[48:51], a[156:159], v52, v57 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v8, v196, v197
		v_cvt_pk_bf16_f32 v9, v198, v199
		v_cvt_pk_bf16_f32 v20, v200, v201
		v_cvt_pk_bf16_f32 v21, v202, v203
		v_cvt_pk_bf16_f32 v24, v204, v205
		v_cvt_pk_bf16_f32 v25, v206, v207
		v_cvt_pk_bf16_f32 v28, v208, v209
		v_cvt_pk_bf16_f32 v29, v210, v211
		v_cvt_pk_bf16_f32 v10, v212, v213
		v_cvt_pk_bf16_f32 v11, v214, v215
		v_cvt_pk_bf16_f32 v22, v216, v217
		v_cvt_pk_bf16_f32 v23, v218, v219
		v_cvt_pk_bf16_f32 v26, v220, v221
		v_cvt_pk_bf16_f32 v27, v222, v223
		v_cvt_pk_bf16_f32 v30, v224, v225
		v_cvt_pk_bf16_f32 v31, v226, v227
		v_cvt_pk_bf16_f32 v32, v228, v229
		v_cvt_pk_bf16_f32 v33, v230, v231
		v_cvt_pk_bf16_f32 v36, v232, v233
		v_cvt_pk_bf16_f32 v37, v234, v235
		v_cvt_pk_bf16_f32 v40, v236, v237
		v_cvt_pk_bf16_f32 v41, v238, v239
		v_cvt_pk_bf16_f32 v44, v240, v241
		v_cvt_pk_bf16_f32 v45, v242, v243
		v_cvt_pk_bf16_f32 v34, v244, v245
		v_cvt_pk_bf16_f32 v35, v246, v247
		v_cvt_pk_bf16_f32 v38, v248, v249
		v_cvt_pk_bf16_f32 v39, v250, v251
		v_accvgpr_read_b32 v3, a100
		v_accvgpr_read_b32 v4, a101
		v_cvt_pk_bf16_f32 v42, v3, v4
		v_accvgpr_read_b32 v3, a102
		v_accvgpr_read_b32 v4, a103
		v_cvt_pk_bf16_f32 v43, v3, v4
		v_accvgpr_read_b32 v3, a104
		v_accvgpr_read_b32 v4, a105
		v_cvt_pk_bf16_f32 v46, v3, v4
		v_accvgpr_read_b32 v3, a106
		v_accvgpr_read_b32 v4, a107
		v_cvt_pk_bf16_f32 v47, v3, v4
		v_accvgpr_read_b32 v3, a108
		v_accvgpr_read_b32 v4, a109
		v_cvt_pk_bf16_f32 v48, v3, v4
		v_accvgpr_read_b32 v3, a110
		v_accvgpr_read_b32 v4, a111
		v_cvt_pk_bf16_f32 v49, v3, v4
		v_accvgpr_read_b32 v3, a112
		v_accvgpr_read_b32 v4, a113
		v_cvt_pk_bf16_f32 v52, v3, v4
		v_accvgpr_read_b32 v3, a114
		v_accvgpr_read_b32 v4, a115
		v_cvt_pk_bf16_f32 v53, v3, v4
		v_accvgpr_read_b32 v3, a116
		v_accvgpr_read_b32 v4, a117
		v_cvt_pk_bf16_f32 v60, v3, v4
		v_accvgpr_read_b32 v3, a118
		v_accvgpr_read_b32 v4, a119
		v_cvt_pk_bf16_f32 v61, v3, v4
		v_accvgpr_read_b32 v3, a120
		v_accvgpr_read_b32 v4, a121
		v_cvt_pk_bf16_f32 v72, v3, v4
		v_accvgpr_read_b32 v3, a122
		v_accvgpr_read_b32 v4, a123
		v_cvt_pk_bf16_f32 v73, v3, v4
		v_accvgpr_read_b32 v3, a124
		v_accvgpr_read_b32 v4, a125
		v_cvt_pk_bf16_f32 v50, v3, v4
		v_accvgpr_read_b32 v3, a126
		v_accvgpr_read_b32 v4, a127
		v_cvt_pk_bf16_f32 v51, v3, v4
		v_accvgpr_read_b32 v3, a128
		v_accvgpr_read_b32 v4, a129
		v_cvt_pk_bf16_f32 v54, v3, v4
		v_accvgpr_read_b32 v3, a130
		v_accvgpr_read_b32 v4, a131
		v_cvt_pk_bf16_f32 v55, v3, v4
		v_accvgpr_read_b32 v3, a132
		v_accvgpr_read_b32 v4, a133
		v_cvt_pk_bf16_f32 v62, v3, v4
		v_accvgpr_read_b32 v3, a134
		v_accvgpr_read_b32 v4, a135
		v_cvt_pk_bf16_f32 v63, v3, v4
		v_accvgpr_read_b32 v3, a136
		v_accvgpr_read_b32 v4, a137
		v_cvt_pk_bf16_f32 v74, v3, v4
		v_accvgpr_read_b32 v3, a138
		v_accvgpr_read_b32 v4, a139
		v_cvt_pk_bf16_f32 v75, v3, v4
		v_accvgpr_read_b32 v3, a140
		v_accvgpr_read_b32 v4, a141
		v_cvt_pk_bf16_f32 v80, v3, v4
		v_accvgpr_read_b32 v3, a142
		v_accvgpr_read_b32 v4, a143
		v_cvt_pk_bf16_f32 v81, v3, v4
		v_accvgpr_read_b32 v3, a144
		v_accvgpr_read_b32 v4, a145
		v_cvt_pk_bf16_f32 v84, v3, v4
		v_accvgpr_read_b32 v3, a146
		v_accvgpr_read_b32 v4, a147
		v_cvt_pk_bf16_f32 v85, v3, v4
		v_accvgpr_read_b32 v3, a148
		v_accvgpr_read_b32 v4, a149
		v_cvt_pk_bf16_f32 v88, v3, v4
		v_accvgpr_read_b32 v3, a150
		v_accvgpr_read_b32 v4, a151
		v_cvt_pk_bf16_f32 v89, v3, v4
		v_accvgpr_read_b32 v3, a152
		v_accvgpr_read_b32 v4, a153
		v_cvt_pk_bf16_f32 v92, v3, v4
		v_accvgpr_read_b32 v3, a154
		v_accvgpr_read_b32 v4, a155
		v_cvt_pk_bf16_f32 v93, v3, v4
		v_accvgpr_read_b32 v3, a156
		v_accvgpr_read_b32 v4, a157
		v_cvt_pk_bf16_f32 v82, v3, v4
		v_accvgpr_read_b32 v3, a158
		v_accvgpr_read_b32 v4, a159
		v_cvt_pk_bf16_f32 v83, v3, v4
		v_accvgpr_read_b32 v3, a160
		v_accvgpr_read_b32 v4, a161
		v_cvt_pk_bf16_f32 v86, v3, v4
		v_accvgpr_read_b32 v3, a162
		v_accvgpr_read_b32 v4, a163
		v_cvt_pk_bf16_f32 v87, v3, v4
		v_accvgpr_read_b32 v3, a164
		v_accvgpr_read_b32 v4, a165
		v_cvt_pk_bf16_f32 v90, v3, v4
		v_accvgpr_read_b32 v3, a166
		v_accvgpr_read_b32 v4, a167
		v_cvt_pk_bf16_f32 v91, v3, v4
		v_accvgpr_read_b32 v3, a168
		v_accvgpr_read_b32 v4, a169
		v_cvt_pk_bf16_f32 v94, v3, v4
		v_accvgpr_read_b32 v3, a170
		v_accvgpr_read_b32 v4, a171
		v_cvt_pk_bf16_f32 v95, v3, v4
		ds_write_b128 v0, v[8:11]
		ds_write_b128 v0, v[20:23] offset:4096
		ds_write_b128 v0, v[24:27] offset:8192
		ds_write_b128 v0, v[28:31] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v1
		ds_read_b128 v[20:23], v1 offset:256
		ds_read_b128 v[24:27], v1 offset:2048
		ds_read_b128 v[28:31], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[32:35]
		ds_write_b128 v0, v[36:39] offset:4096
		ds_write_b128 v0, v[40:43] offset:8192
		ds_write_b128 v0, v[44:47] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[32:35], v1
		ds_read_b128 v[36:39], v1 offset:256
		ds_read_b128 v[40:43], v1 offset:2048
		ds_read_b128 v[44:47], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[48:51]
		ds_write_b128 v0, v[52:55] offset:4096
		ds_write_b128 v0, v[60:63] offset:8192
		ds_write_b128 v0, v[72:75] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[48:51], v1
		ds_read_b128 v[52:55], v1 offset:256
		ds_read_b128 v[60:63], v1 offset:2048
		ds_read_b128 v[72:75], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v1
		ds_read_b128 v[84:87], v1 offset:256
		ds_read_b128 v[88:91], v1 offset:2048
		ds_read_b128 v[92:95], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[96:97], v[8:9]
		v_mov_b64_e32 v[98:99], v[20:21]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v0, s0, v5, v12
		v_add3_u32 v0, v0, v19, v58
		v_add3_u32 v0, v0, v16, v7
		v_add3_u32 v0, v0, v17, v18
		buffer_store_dwordx4 v[96:99], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[96:97], v[24:25]
		v_mov_b64_e32 v[98:99], v[28:29]
		v_add3_u32 v0, v16, v7, v17
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v13, v0, s0
		buffer_store_dwordx4 v[96:99], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[96:97], v[10:11]
		v_mov_b64_e32 v[98:99], v[22:23]
		v_add3_u32 v1, v14, v0, s0
		buffer_store_dwordx4 v[96:99], v1, s[8:11], 0 offen
		v_mov_b64_e32 v[8:9], v[26:27]
		v_mov_b64_e32 v[10:11], v[30:31]
		v_add3_u32 v0, v15, v0, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[32:33]
		v_mov_b64_e32 v[10:11], v[36:37]
		v_add3_u32 v0, v16, v7, v17
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v59, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[40:41]
		v_mov_b64_e32 v[10:11], v[44:45]
		v_add3_u32 v1, v64, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[34:35]
		v_mov_b64_e32 v[10:11], v[38:39]
		v_add3_u32 v0, v65, v0, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[42:43]
		v_mov_b64_e32 v[10:11], v[46:47]
		v_add3_u32 v0, v16, v7, v17
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v66, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[48:49]
		v_mov_b64_e32 v[10:11], v[52:53]
		v_add3_u32 v1, v67, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[60:61]
		v_mov_b64_e32 v[10:11], v[72:73]
		v_add3_u32 v0, v68, v0, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[50:51]
		v_mov_b64_e32 v[10:11], v[54:55]
		v_add3_u32 v0, v16, v7, v17
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v69, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[62:63]
		v_mov_b64_e32 v[10:11], v[74:75]
		v_add3_u32 v1, v70, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[80:81]
		v_mov_b64_e32 v[10:11], v[84:85]
		v_add3_u32 v0, v71, v0, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[8:9], v[88:89]
		v_mov_b64_e32 v[10:11], v[92:93]
		v_add3_u32 v0, v16, v7, v17
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v76, v0, s0
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_mov_b64_e32 v[4:5], v[82:83]
		v_mov_b64_e32 v[6:7], v[86:87]
		v_add3_u32 v1, v77, v0, s0
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_nop 1
		v_mov_b64_e32 v[4:5], v[90:91]
		v_mov_b64_e32 v[6:7], v[94:95]
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
		.amdhsa_next_free_vgpr 428
		.amdhsa_next_free_sgpr 44
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
	.set .L_a4w4_kernel.num_agpr, 172
	.set .L_a4w4_kernel.numbered_sgpr, 44
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
    .sgpr_count:     44
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     428
    .agpr_count:     172
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 94
    wave.regalloc.agpr.dwords: 372
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
