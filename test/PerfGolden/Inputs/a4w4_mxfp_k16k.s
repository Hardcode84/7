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
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v7, s14, v6
		v_lshlrev_b32_e32 v7, 6, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v9, 1, v8
		v_mul_lo_u32 v10, s14, v9
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v5, v5, v7, v10
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v11, 1, v11
		v_mul_lo_u32 v12, s14, v11
		v_lshlrev_b32_e32 v12, 4, v12
		v_and_b32_e32 v13, 1, v0
		v_lshlrev_b32_e32 v14, 4, v13
		v_add3_u32 v5, v5, v12, v14
		v_lshrrev_b32_e32 v15, 2, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v16, 6, v15
		v_lshrrev_b32_e32 v17, 1, v0
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_add3_u32 v5, v5, v16, v18
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		v_mov_b32_e32 v20, 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v19, s22, v2, v4
		v_add3_u32 v19, v19, v7, v10
		v_add3_u32 v19, v19, v12, v14
		v_add3_u32 v19, v19, v16, v18
		s_add_i32 m0, s21, 0x1080
		s_mul_i32 s16, s16, s15
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v21, v2, v4, v7
		v_add3_u32 v21, v21, v10, v12
		v_add3_u32 v21, v21, v14, v16
		s_add_i32 m0, s21, 0x2100
		v_add3_u32 v24, v18, v21, s28
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s21, 0x3180
		v_add3_u32 v25, v18, v21, s29
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s21, 0x4200
		v_add3_u32 v26, v18, v21, s30
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v21, v2, v4, v7
		v_add3_u32 v21, v21, v10, v12
		v_add3_u32 v21, v21, v14, v16
		s_add_i32 m0, s21, 0x5280
		v_add3_u32 v27, v18, v21, s31
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s21, 0x6300
		v_add3_u32 v28, v18, v21, s32
		buffer_load_dwordx4 v28, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s21, 0x7380
		v_add3_u32 v29, v18, v21, s14
		s_add_u32 s36, s4, s16
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v21, s15, v1
		v_lshlrev_b32_e32 v21, 1, v21
		v_mul_lo_u32 v22, s15, v3
		v_add_u32_e32 v23, v21, v22
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_mul_lo_u32 v30, s15, v6
		v_lshlrev_b32_e32 v30, 6, v30
		v_mul_lo_u32 v31, s15, v9
		v_lshlrev_b32_e32 v31, 5, v31
		v_add3_u32 v23, v23, v30, v31
		v_mul_lo_u32 v32, s15, v11
		v_lshlrev_b32_e32 v32, 4, v32
		v_add3_u32 v23, v23, v32, v14
		s_add_i32 m0, s21, 0x107c0
		v_add3_u32 v33, v23, v16, v18
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v23, v21, v22, v30
		v_add3_u32 v23, v23, v31, v32
		v_add3_u32 v23, v23, v14, v16
		s_add_i32 m0, s21, 0x11840
		v_add3_u32 v34, v18, v23, s33
		buffer_load_dwordx4 v34, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s21, 0x128c0
		v_add3_u32 v35, v18, v23, s34
		buffer_load_dwordx4 v35, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s21, 0x13940
		v_add3_u32 v36, v18, v23, s35
		buffer_load_dwordx4 v36, s[36:39], 0 offen lds
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v23, s18, v1
		v_lshlrev_b32_e32 v23, 2, v23
		v_mul_lo_u32 v37, s18, v3
		v_lshlrev_b32_e32 v37, 1, v37
		v_add3_u32 v38, s1, v23, v37
		v_mul_lo_u32 v39, s18, v6
		v_lshlrev_b32_e32 v40, 3, v13
		v_add3_u32 v38, v38, v39, v40
		v_lshlrev_b32_e32 v41, 7, v9
		v_lshlrev_b32_e32 v42, 6, v11
		v_add3_u32 v38, v38, v41, v42
		v_lshlrev_b32_e32 v43, 5, v15
		v_lshlrev_b32_e32 v44, 4, v17
		v_add3_u32 v38, v38, v43, v44
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx2 v[46:47], v38, s[40:43], 0 offen
		s_lshl_b32 s20, s0, 8
		v_mul_lo_u32 v45, s19, v1
		v_lshlrev_b32_e32 v45, 2, v45
		v_mul_lo_u32 v48, s19, v3
		v_lshlrev_b32_e32 v48, 1, v48
		v_add3_u32 v49, s20, v45, v48
		v_mul_lo_u32 v50, s19, v6
		v_lshlrev_b32_e32 v51, 2, v13
		v_add3_u32 v49, v49, v50, v51
		v_lshlrev_b32_e32 v52, 6, v9
		v_lshlrev_b32_e32 v53, 5, v11
		v_add3_u32 v49, v49, v52, v53
		v_lshlrev_b32_e32 v54, 4, v15
		v_lshlrev_b32_e32 v55, 3, v17
		v_add3_u32 v49, v49, v54, v55
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dword v56, v49, s[44:47], 0 offen
		s_lshl_b32 s48, s15, 7
		v_add3_u32 v57, s48, v21, v22
		v_add3_u32 v57, v57, v30, v31
		v_add3_u32 v57, v57, v32, v14
		s_add_i32 m0, s21, 0x18b80
		v_add3_u32 v57, v57, v16, v18
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v58, v21, v22, v30
		v_add3_u32 v58, v58, v31, v32
		v_add3_u32 v58, v58, v14, v16
		s_add_i32 m0, s21, 0x19c00
		v_add3_u32 v59, v18, v58, s49
		buffer_load_dwordx4 v59, s[36:39], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, s21, 0x1ac80
		v_add3_u32 v60, v18, v58, s50
		buffer_load_dwordx4 v60, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s21, 0x1bd00
		v_add3_u32 v58, v18, v58, s15
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
		s_add_i32 s51, s20, 0x80
		v_add3_u32 v61, s51, v45, v48
		v_add3_u32 v61, v61, v50, v51
		v_add3_u32 v61, v61, v52, v53
		v_add3_u32 v61, v61, v54, v55
		buffer_load_dword v62, v61, s[44:47], 0 offen
		v_add_u32_e32 v63, 0x80, v2
		v_add_u32_e32 v63, v63, v4
		v_add3_u32 v63, v63, v7, v10
		v_add3_u32 v63, v63, v12, v14
		s_add_i32 m0, s21, 0x83e0
		v_add3_u32 v63, v63, v16, v18
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v64, s22, v2, v4
		v_add3_u32 v64, v64, v7, v10
		v_add3_u32 v64, v64, v12, v14
		s_add_i32 m0, s21, 0x9460
		v_add3_u32 v64, v64, v16, v18
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v65, s22, v2, v4
		v_add3_u32 v65, v65, v7, v10
		v_add3_u32 v65, v65, v12, v14
		s_add_i32 m0, s21, 0xa4e0
		v_add3_u32 v65, v65, v16, v18
		buffer_load_dwordx4 v65, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v66, s22, v2, v4
		v_add3_u32 v66, v66, v7, v10
		v_add3_u32 v66, v66, v12, v14
		s_add_i32 m0, s21, 0xb560
		v_add3_u32 v66, v66, v16, v18
		buffer_load_dwordx4 v66, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v67, s22, v2, v4
		v_add3_u32 v67, v67, v7, v10
		v_add3_u32 v67, v67, v12, v14
		s_add_i32 m0, s21, 0xc5e0
		v_add3_u32 v67, v67, v16, v18
		buffer_load_dwordx4 v67, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v68, s22, v2, v4
		v_add3_u32 v68, v68, v7, v10
		v_add3_u32 v68, v68, v12, v14
		s_add_i32 m0, s21, 0xd660
		v_add3_u32 v68, v68, v16, v18
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v69, s22, v2, v4
		v_add3_u32 v69, v69, v7, v10
		v_add3_u32 v69, v69, v12, v14
		s_add_i32 m0, s21, 0xe6e0
		v_add3_u32 v69, v69, v16, v18
		buffer_load_dwordx4 v69, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v4
		v_add3_u32 v2, v2, v7, v10
		v_add3_u32 v2, v2, v12, v14
		s_add_i32 m0, s21, 0xf760
		v_add3_u32 v2, v2, v16, v18
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v21
		v_add_u32_e32 v4, v4, v22
		v_add3_u32 v4, v4, v30, v31
		v_add3_u32 v4, v4, v32, v14
		s_add_i32 m0, s21, 0x149a0
		v_add3_u32 v4, v4, v16, v18
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v7, v21, v22, v30
		v_add3_u32 v7, v7, v31, v32
		v_add3_u32 v7, v7, v14, v16
		s_add_i32 m0, s21, 0x15a20
		v_add3_u32 v10, v18, v7, s14
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s21, 0x16aa0
		v_add3_u32 v12, v18, v7, s14
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s21, 0x17b20
		v_add3_u32 v7, v18, v7, s14
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_add3_u32 v23, s1, v23, v37
		v_add3_u32 v23, v23, v39, v40
		v_add3_u32 v23, v23, v41, v42
		v_add3_u32 v37, v23, v43, v44
		buffer_load_dwordx2 v[70:71], v37, s[40:43], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s20, s1
		v_add3_u32 v23, s14, v45, v48
		v_add3_u32 v23, v23, v50, v51
		v_add3_u32 v23, v23, v52, v53
		v_add3_u32 v39, v23, v54, v55
		buffer_load_dword v44, v39, s[44:47], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v23, s14, v21, v22
		v_add3_u32 v23, v23, v30, v31
		v_add3_u32 v23, v23, v32, v14
		s_add_i32 m0, s21, 0x1cd60
		v_add3_u32 v72, v23, v16, v18
		s_waitcnt vmcnt(15)
		buffer_load_dwordx4 v72, s[36:39], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v21, v21, v22, v30
		v_add3_u32 v21, v21, v31, v32
		v_add3_u32 v21, v21, v14, v16
		s_add_i32 m0, s21, 0x1dde0
		v_add3_u32 v30, v18, v21, s14
		buffer_load_dwordx4 v30, s[36:39], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, s21, 0x1ee60
		v_add3_u32 v31, v18, v21, s14
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s21, 0x1fee0
		v_add3_u32 v32, v18, v21, s14
		buffer_load_dwordx4 v32, s[36:39], 0 offen lds
		s_add_i32 s1, s51, s1
		v_add3_u32 v21, s1, v45, v48
		v_add3_u32 v21, v21, v50, v51
		v_add3_u32 v21, v21, v52, v53
		v_add3_u32 v45, v21, v54, v55
		buffer_load_dword v48, v45, s[44:47], 0 offen
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s16, 0x100
		s_mul_i32 s14, s18, 16
		s_mul_i32 s15, s19, 16
		v_lshlrev_b32_e32 v21, 7, v1
		v_and_b32_e32 v22, 63, v0
		v_lshrrev_b32_e32 v23, 4, v22
		v_lshlrev_b32_e32 v23, 4, v23
		v_and_b32_e32 v22, 15, v22
		v_mov_b32_e32 v50, 0x420
		v_mul_lo_u32 v50, v50, v22
		v_add3_u32 v51, v21, v23, v50
		ds_read_b128 a[0:3], v51
		ds_read_b128 a[4:7], v51 offset:64
		ds_read_b128 a[8:11], v51 offset:256
		ds_read_b128 a[12:15], v51 offset:320
		ds_read_b128 a[16:19], v51 offset:512
		ds_read_b128 a[20:23], v51 offset:576
		ds_read_b128 a[24:27], v51 offset:768
		ds_read_b128 a[28:31], v51 offset:832
		ds_read_b128 a[32:35], v51 offset:16896
		ds_read_b128 a[36:39], v51 offset:16960
		ds_read_b128 a[40:43], v51 offset:17152
		ds_read_b128 a[44:47], v51 offset:17216
		ds_read_b128 a[48:51], v51 offset:17408
		ds_read_b128 a[52:55], v51 offset:17472
		ds_read_b128 a[56:59], v51 offset:17664
		ds_read_b128 a[60:63], v51 offset:17728
		v_add_u32_e32 v21, 0x10000, v23
		v_lshlrev_b32_e32 v22, 7, v3
		v_add3_u32 v50, v21, v22, v50
		ds_read_b128 a[64:67], v50 offset:1984
		ds_read_b128 a[68:71], v50 offset:2048
		ds_read_b128 a[72:75], v50 offset:2240
		ds_read_b128 a[76:79], v50 offset:2304
		ds_read_b128 a[80:83], v50 offset:2496
		ds_read_b128 a[84:87], v50 offset:2560
		ds_read_b128 a[88:91], v50 offset:2752
		ds_read_b128 a[92:95], v50 offset:2816
		v_lshlrev_b32_e32 v21, 3, v0
		v_add_u32_e32 v52, 0x20000, v21
		ds_write_b64 v52, v[46:47] offset:3904
		v_lshlrev_b32_e32 v21, 2, v0
		v_add_u32_e32 v46, 0x20000, v21
		ds_write_b32 v46, v56 offset:5952
		v_lshlrev_b32_e32 v21, 4, v1
		s_waitcnt lgkmcnt(1)
		s_barrier
		v_add_u32_e32 v21, 0x20000, v21
		v_add_u32_e32 v21, v21, v40
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v21, v6, 9, v21
		v_lshlrev_b32_e32 v22, 8, v9
		v_add3_u32 v21, v21, v22, v42
		v_lshlrev_b32_e32 v47, 10, v17
		v_add3_u32 v53, v21, v43, v47
		ds_read_b64_tr_b8 v[54:55], v53 offset:3904
		ds_read_b64_tr_b8 v[74:75], v53 offset:4032
		v_add_u32_e32 v21, 0x20000, v40
		v_lshl_add_u32 v21, v3, 4, v21
		v_lshlrev_b32_e32 v22, 8, v6
		v_add3_u32 v21, v21, v22, v41
		v_add3_u32 v21, v21, v42, v43
		v_lshl_add_u32 v17, v17, 9, v21
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
		s_mov_b32 s16, s14
		s_mov_b32 s18, s15
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_add_u32 s36, s8, s16
		s_addc_u32 s37, s9, 0
		s_add_u32 s40, s10, s18
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
		v_mov_b32_e32 v76, v20
		v_mov_b32_e32 v77, v21
		v_mov_b32_e32 v78, v22
		v_mov_b32_e32 v79, v23
		v_accvgpr_write_b32 a96, v76
		v_accvgpr_write_b32 a97, v77
		v_accvgpr_write_b32 a98, v78
		v_accvgpr_write_b32 a99, v79
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
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a100, v42
		v_accvgpr_write_b32 a101, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a102, v42
		v_accvgpr_write_b32 a103, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a104, v42
		v_accvgpr_write_b32 a105, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a106, v42
		v_accvgpr_write_b32 a107, v43
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a108, v42
		v_accvgpr_write_b32 a109, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a110, v42
		v_accvgpr_write_b32 a111, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a112, v42
		v_accvgpr_write_b32 a113, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a114, v42
		v_accvgpr_write_b32 a115, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a116, v42
		v_accvgpr_write_b32 a117, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a118, v42
		v_accvgpr_write_b32 a119, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a120, v42
		v_accvgpr_write_b32 a121, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a122, v42
		v_accvgpr_write_b32 a123, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a124, v42
		v_accvgpr_write_b32 a125, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a126, v42
		v_accvgpr_write_b32 a127, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a128, v42
		v_accvgpr_write_b32 a129, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a130, v42
		v_accvgpr_write_b32 a131, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a132, v42
		v_accvgpr_write_b32 a133, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a134, v42
		v_accvgpr_write_b32 a135, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a136, v42
		v_accvgpr_write_b32 a137, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a138, v42
		v_accvgpr_write_b32 a139, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a140, v42
		v_accvgpr_write_b32 a141, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a142, v42
		v_accvgpr_write_b32 a143, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a144, v42
		v_accvgpr_write_b32 a145, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a146, v42
		v_accvgpr_write_b32 a147, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a148, v42
		v_accvgpr_write_b32 a149, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a150, v42
		v_accvgpr_write_b32 a151, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a152, v42
		v_accvgpr_write_b32 a153, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a154, v42
		v_accvgpr_write_b32 a155, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a156, v42
		v_accvgpr_write_b32 a157, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a158, v42
		v_accvgpr_write_b32 a159, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a160, v42
		v_accvgpr_write_b32 a161, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a162, v42
		v_accvgpr_write_b32 a163, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a164, v42
		v_accvgpr_write_b32 a165, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a166, v42
		v_accvgpr_write_b32 a167, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a168, v42
		v_accvgpr_write_b32 a169, v43
		v_mov_b64_e32 v[42:43], 0
		v_accvgpr_write_b32 a170, v42
		v_accvgpr_write_b32 a171, v43
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[64:67], a[0:3], v[20:23], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v40, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v40, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v40, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v40, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v41, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v41, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v41, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v41, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v41, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v41, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v41, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v41, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v40, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v40, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v40, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v40, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v50 offset:35712
		ds_read_b128 a[68:71], v50 offset:35776
		ds_read_b128 a[72:75], v50 offset:35968
		ds_read_b128 a[76:79], v50 offset:36032
		ds_read_b128 a[80:83], v50 offset:36224
		ds_read_b128 a[84:87], v50 offset:36288
		ds_read_b128 a[88:91], v50 offset:36480
		ds_read_b128 a[92:95], v50 offset:36544
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v62 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x1080
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x2100
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[0:3], v[196:199], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[0:3], v[200:203], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[8:11], v[216:219], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[8:11], v[212:215], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x7380
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[0:3], v[204:207], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[0:3], v[208:211], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[8:11], v[224:227], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[8:11], v[220:223], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[24:27], v[248:251], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[24:27], v[244:247], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[16:19], v[228:231], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[16:19], v[232:235], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[24:27], a[104:107], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[64:67], a[24:27], a[100:103], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x107c0
		s_nop 0
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x11840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x128c0
		s_add_u32 s40, s10, s18
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x13940
		s_add_u32 s36, s8, s16
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[42:43], v38, s[36:39], 0 offen
		buffer_load_dword v54, v49, s[40:43], 0 offen
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v40, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v40, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v40, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v40, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v41, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v41, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v41, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v41, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v41, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v41, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v41, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v41, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v40, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v40, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v40, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v40, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v51 offset:33760
		ds_read_b128 a[4:7], v51 offset:33824
		ds_read_b128 a[8:11], v51 offset:34016
		ds_read_b128 a[12:15], v51 offset:34080
		ds_read_b128 a[16:19], v51 offset:34272
		ds_read_b128 a[20:23], v51 offset:34336
		ds_read_b128 a[24:27], v51 offset:34528
		ds_read_b128 a[28:31], v51 offset:34592
		ds_read_b128 a[32:35], v51 offset:50656
		ds_read_b128 a[36:39], v51 offset:50720
		ds_read_b128 a[40:43], v51 offset:50912
		ds_read_b128 a[44:47], v51 offset:50976
		ds_read_b128 a[48:51], v51 offset:51168
		ds_read_b128 a[52:55], v51 offset:51232
		ds_read_b128 a[56:59], v51 offset:51424
		ds_read_b128 a[60:63], v51 offset:51488
		ds_read_b128 a[64:67], v50 offset:18848
		ds_read_b128 a[68:71], v50 offset:18912
		ds_read_b128 a[72:75], v50 offset:19104
		ds_read_b128 a[76:79], v50 offset:19168
		ds_read_b128 a[80:83], v50 offset:19360
		ds_read_b128 a[84:87], v50 offset:19424
		ds_read_b128 a[88:91], v50 offset:19616
		ds_read_b128 v[252:255], v50 offset:19680
		s_waitcnt vmcnt(20)
		ds_write_b64 v52, v[70:71] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v44 offset:5952
		s_add_i32 m0, s21, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v53 offset:3904
		ds_read_b64_tr_b8 v[74:75], v53 offset:4032
		ds_read_b64_tr_b8 v[70:71], v17 offset:5952
		buffer_load_dwordx4 v57, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x19c00
		s_nop 0
		buffer_load_dwordx4 v59, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ac80
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[64:67], a[0:3], v[20:23], v70, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v60, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1bd00
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v70, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v58, s[32:35], 0 offen lds
		buffer_load_dword v62, v61, s[40:43], 0 offen
		s_waitcnt vmcnt(20)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v70, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v70, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v70, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v70, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v70, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v70, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v71, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v71, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v71, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v71, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v71, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[4:7], v[80:83], v71, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[12:15], v[96:99], v71, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v71, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v71, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v71, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v71, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v71, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v71, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[20:23], v[112:115], v71, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[28:31], v[128:131], v71, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v71, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v70, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v70, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v70, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v70, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v70, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v70, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v70, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v70, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v70, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v70, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v71, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v71, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[36:39], v[144:147], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[44:47], v[160:163], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v71, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v71, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v71, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v71, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v71, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[52:55], v[176:179], v71, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[60:63], v[192:195], v71, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v71, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v70, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v70, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v70, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v70, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v70, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v70, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v70, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v70, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v50 offset:52576
		ds_read_b128 a[68:71], v50 offset:52640
		ds_read_b128 a[72:75], v50 offset:52832
		ds_read_b128 a[76:79], v50 offset:52896
		ds_read_b128 a[80:83], v50 offset:53088
		ds_read_b128 a[84:87], v50 offset:53152
		ds_read_b128 a[88:91], v50 offset:53344
		ds_read_b128 a[92:95], v50 offset:53408
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v48 offset:5952
		s_add_i32 m0, s21, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[252:253], v17 offset:5952
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x9460
		s_nop 0
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xa4e0
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[0:3], v[196:199], v252, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[0:3], v[200:203], v252, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v66, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[8:11], v[216:219], v252, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v67, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[8:11], v[212:215], v252, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v252, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v69, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v252, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v252, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v252, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[0:3], v[204:207], v253, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[0:3], v[208:211], v253, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[8:11], v[224:227], v253, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[8:11], v[220:223], v253, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v253, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v253, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v253, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v253, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[16:19], v[236:239], v253, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[16:19], v[240:243], v253, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[24:27], v[248:251], v253, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[24:27], v[244:247], v253, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v253, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v253, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v253, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v253, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[16:19], v[228:231], v252, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[16:19], v[232:235], v252, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[24:27], a[104:107], v252, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[64:67], a[24:27], a[100:103], v252, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v252, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v252, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x149a0
		s_add_i32 s18, s18, s15
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v252, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v252, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[70:71], v37, s[36:39], 0 offen
		buffer_load_dword v44, v39, s[40:43], 0 offen
		s_waitcnt vmcnt(21)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v252, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v252, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v252, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v252, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v252, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v252, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v252, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v252, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v253, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v253, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v253, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v253, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v253, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v253, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v253, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v253, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v253, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v253, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v253, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v253, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v253, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v253, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v253, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v253, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v252, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v252, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v252, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v252, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v252, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v252, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v252, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v252, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v51
		ds_read_b128 a[4:7], v51 offset:64
		ds_read_b128 a[8:11], v51 offset:256
		ds_read_b128 a[12:15], v51 offset:320
		ds_read_b128 a[16:19], v51 offset:512
		ds_read_b128 a[20:23], v51 offset:576
		ds_read_b128 a[24:27], v51 offset:768
		ds_read_b128 a[28:31], v51 offset:832
		ds_read_b128 a[32:35], v51 offset:16896
		ds_read_b128 a[36:39], v51 offset:16960
		ds_read_b128 a[40:43], v51 offset:17152
		ds_read_b128 a[44:47], v51 offset:17216
		ds_read_b128 a[48:51], v51 offset:17408
		ds_read_b128 a[52:55], v51 offset:17472
		ds_read_b128 a[56:59], v51 offset:17664
		ds_read_b128 a[60:63], v51 offset:17728
		ds_read_b128 a[64:67], v50 offset:1984
		ds_read_b128 a[68:71], v50 offset:2048
		ds_read_b128 a[72:75], v50 offset:2240
		ds_read_b128 a[76:79], v50 offset:2304
		ds_read_b128 a[80:83], v50 offset:2496
		ds_read_b128 a[84:87], v50 offset:2560
		ds_read_b128 a[88:91], v50 offset:2752
		ds_read_b128 a[92:95], v50 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v52, v[42:43] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v54 offset:5952
		s_add_i32 m0, s21, 0x1cd60
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[54:55], v53 offset:3904
		ds_read_b64_tr_b8 v[74:75], v53 offset:4032
		ds_read_b64_tr_b8 v[40:41], v17 offset:5952
		buffer_load_dwordx4 v72, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1dde0
		s_add_i32 s16, s16, s14
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1fee0
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		buffer_load_dword v48, v45, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(1)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[64:67], a[0:3], v[20:23], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[8:11], v[88:91], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[64:67], a[8:11], v[84:87], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], a[68:71], a[4:7], v[20:23], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[0:3], v[76:79], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[0:3], v[80:83], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[8:11], v[96:99], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[8:11], v[92:95], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[16:19], v[108:111], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[16:19], v[112:115], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[24:27], v[128:131], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[24:27], v[124:127], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[64:67], a[16:19], v[100:103], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[16:19], v[104:107], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[24:27], v[120:123], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[24:27], v[116:119], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[32:35], v[132:135], v40, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[32:35], v[136:139], v40, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[40:43], v[152:155], v40, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[40:43], v[148:151], v40, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[32:35], v[140:143], v41, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[32:35], v[144:147], v41, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[40:43], v[160:163], v41, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[40:43], v[156:159], v41, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[48:51], v[172:175], v41, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[48:51], v[176:179], v41, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[56:59], v[192:195], v41, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[56:59], v[188:191], v41, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[48:51], v[164:167], v40, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[48:51], v[168:171], v40, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[56:59], v[184:187], v40, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[56:59], v[180:183], v40, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v50 offset:35712
		ds_read_b128 v[28:31], v50 offset:35776
		ds_read_b128 v[32:35], v50 offset:35968
		ds_read_b128 v[36:39], v50 offset:36032
		ds_read_b128 v[40:43], v50 offset:36224
		ds_read_b128 v[56:59], v50 offset:36288
		ds_read_b128 v[64:67], v50 offset:36480
		ds_read_b128 v[252:255], v50 offset:36544
		ds_write_b32 v46, v62 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v13
		v_lshl_add_u32 v2, v8, 4, v2
		v_lshl_add_u32 v2, v11, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v17 offset:5952
		ds_read_b128 a[64:67], v51 offset:33760
		ds_read_b128 a[68:71], v51 offset:33824
		ds_read_b128 a[72:75], v51 offset:34016
		ds_read_b128 v[60:63], v51 offset:34080
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], a[0:3], v[196:199], v4, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], a[0:3], v[200:203], v4, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], a[8:11], v[216:219], v4, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], a[8:11], v[212:215], v4, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], a[4:7], v[196:199], v4, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], a[4:7], v[200:203], v4, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[12:15], v[216:219], v4, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], a[12:15], v[212:215], v4, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], a[0:3], v[204:207], v5, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], a[0:3], v[208:211], v5, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], a[8:11], v[224:227], v5, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], a[8:11], v[220:223], v5, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], a[4:7], v[204:207], v5, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[4:7], v[208:211], v5, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[12:15], v[224:227], v5, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], a[12:15], v[220:223], v5, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], a[16:19], v[236:239], v5, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[64:67], a[16:19], v[240:243], v5, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[64:67], a[24:27], v[248:251], v5, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[24:27], v[244:247], v5, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], a[20:23], v[236:239], v5, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[20:23], v[240:243], v5, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[28:31], v[248:251], v5, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[56:59], a[28:31], v[244:247], v5, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], a[16:19], v[228:231], v4, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], a[16:19], v[232:235], v4, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[32:35], a[24:27], a[104:107], v4, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], a[24:27], a[100:103], v4, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[20:23], v[228:231], v4, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[20:23], v[232:235], v4, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[28:31], a[104:107], v4, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], a[28:31], a[100:103], v4, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[32:35], a[108:111], v4, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[32:35], a[112:115], v4, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[40:43], a[128:131], v4, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[40:43], a[124:127], v4, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[36:39], a[108:111], v4, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[36:39], a[112:115], v4, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[44:47], a[128:131], v4, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[44:47], a[124:127], v4, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[32:35], a[116:119], v5, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[32:35], a[120:123], v5, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[40:43], a[136:139], v5, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[40:43], a[132:135], v5, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[36:39], a[116:119], v5, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v5, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v5, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[44:47], a[132:135], v5, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[48:51], a[148:151], v5, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[48:51], a[152:155], v5, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[56:59], a[168:171], v5, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[56:59], a[164:167], v5, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[52:55], a[148:151], v5, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v5, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v5, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[60:63], a[164:167], v5, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[48:51], a[140:143], v4, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[48:51], a[144:147], v4, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[56:59], a[160:163], v4, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[56:59], a[156:159], v4, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[52:55], a[140:143], v4, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[52:55], a[144:147], v4, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[60:63], a[160:163], v4, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[60:63], a[156:159], v4, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v51 offset:34272
		ds_read_b128 a[0:3], v51 offset:34336
		ds_read_b128 a[4:7], v51 offset:34528
		ds_read_b128 a[8:11], v51 offset:34592
		ds_read_b128 a[12:15], v51 offset:50656
		ds_read_b128 a[16:19], v51 offset:50720
		ds_read_b128 a[20:23], v51 offset:50912
		ds_read_b128 a[24:27], v51 offset:50976
		ds_read_b128 a[28:31], v51 offset:51168
		ds_read_b128 a[32:35], v51 offset:51232
		ds_read_b128 a[36:39], v51 offset:51424
		ds_read_b128 a[40:43], v51 offset:51488
		ds_read_b128 v[28:31], v50 offset:18848
		ds_read_b128 v[32:35], v50 offset:18912
		ds_read_b128 v[36:39], v50 offset:19104
		ds_read_b128 v[40:43], v50 offset:19168
		ds_read_b128 v[56:59], v50 offset:19360
		ds_read_b128 v[64:67], v50 offset:19424
		ds_read_b128 v[72:75], v50 offset:19616
		ds_read_b128 v[252:255], v50 offset:19680
		ds_write_b64 v52, v[70:71] offset:3904
		ds_write_b32 v46, v44 offset:5952
		v_lshlrev_b32_e32 v4, 12, v15
		v_add3_u32 v2, v2, v4, v47
		v_lshlrev_b32_e32 v4, 7, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v53 offset:3904
		ds_read_b64_tr_b8 v[12:13], v53 offset:4032
		ds_read_b64_tr_b8 v[44:45], v17 offset:5952
		ds_read_b128 a[44:47], v50 offset:52576
		ds_read_b128 a[48:51], v50 offset:52640
		ds_read_b128 v[52:55], v50 offset:52832
		ds_read_b128 v[68:71], v50 offset:52896
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[28:31], a[64:67], v[20:23], v44, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], a[64:67], a[96:99], v44, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[36:39], a[72:75], v[88:91], v44, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[28:31], a[72:75], v[84:87], v44, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[20:23], v[32:35], a[68:71], v[20:23], v44, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], a[68:71], a[96:99], v44, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[40:43], v[60:63], v[88:91], v44, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[60:63], v[84:87], v44, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[56:59], a[64:67], v[76:79], v45, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[72:75], a[64:67], v[80:83], v45, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[72:75], a[72:75], v[96:99], v45, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[56:59], a[72:75], v[92:95], v45, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], a[68:71], v[76:79], v45, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[68:71], v[80:83], v45, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], v[60:63], v[96:99], v45, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[60:63], v[92:95], v45, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[56:59], v[24:27], v[108:111], v45, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[72:75], v[24:27], v[112:115], v45, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], a[4:7], v[128:131], v45, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[56:59], a[4:7], v[124:127], v45, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], a[0:3], v[108:111], v45, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[0:3], v[112:115], v45, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[8:11], v[128:131], v45, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], a[8:11], v[124:127], v45, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[28:31], v[24:27], v[100:103], v44, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[36:39], v[24:27], v[104:107], v44, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], a[4:7], v[120:123], v44, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[28:31], a[4:7], v[116:119], v44, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[0:3], v[100:103], v44, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[40:43], a[0:3], v[104:107], v44, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], a[8:11], v[120:123], v44, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], a[8:11], v[116:119], v44, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], a[12:15], v[132:135], v44, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], a[12:15], v[136:139], v44, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], a[20:23], v[152:155], v44, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], a[20:23], v[148:151], v44, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], a[16:19], v[132:135], v44, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], a[16:19], v[136:139], v44, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], a[24:27], v[152:155], v44, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], a[24:27], v[148:151], v44, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[56:59], a[12:15], v[140:143], v45, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], a[12:15], v[144:147], v45, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], a[20:23], v[160:163], v45, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], a[20:23], v[156:159], v45, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[64:67], a[16:19], v[140:143], v45, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[16:19], v[144:147], v45, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[24:27], v[160:163], v45, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[64:67], a[24:27], v[156:159], v45, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], a[28:31], v[172:175], v45, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], a[28:31], v[176:179], v45, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[72:75], a[36:39], v[192:195], v45, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], a[36:39], v[188:191], v45, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[64:67], a[32:35], v[172:175], v45, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[32:35], v[176:179], v45, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[40:43], v[192:195], v45, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[64:67], a[40:43], v[188:191], v45, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], a[28:31], v[164:167], v44, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[28:31], v[168:171], v44, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[36:39], v[184:187], v44, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], a[36:39], v[180:183], v44, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], a[32:35], v[164:167], v44, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], a[32:35], v[168:171], v44, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], a[40:43], v[184:187], v44, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], a[40:43], v[180:183], v44, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v50 offset:53088
		ds_read_b128 v[32:35], v50 offset:53152
		ds_read_b128 v[36:39], v50 offset:53344
		ds_read_b128 v[40:43], v50 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v46, v48 offset:5952
		v_cvt_pk_bf16_f32 v44, v20, v21
		v_cvt_pk_bf16_f32 v45, v22, v23
		v_accvgpr_read_b32 v5, a96
		v_accvgpr_read_b32 v7, a97
		v_cvt_pk_bf16_f32 v20, v5, v7
		v_accvgpr_read_b32 v5, a98
		v_accvgpr_read_b32 v7, a99
		v_cvt_pk_bf16_f32 v21, v5, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[48:49], v17 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v56, v76, v77
		v_cvt_pk_bf16_f32 v57, v78, v79
		v_cvt_pk_bf16_f32 v64, v80, v81
		v_cvt_pk_bf16_f32 v65, v82, v83
		v_cvt_pk_bf16_f32 v46, v84, v85
		v_cvt_pk_bf16_f32 v47, v86, v87
		v_cvt_pk_bf16_f32 v22, v88, v89
		v_cvt_pk_bf16_f32 v23, v90, v91
		v_cvt_pk_bf16_f32 v58, v92, v93
		v_cvt_pk_bf16_f32 v59, v94, v95
		v_cvt_pk_bf16_f32 v66, v96, v97
		v_cvt_pk_bf16_f32 v67, v98, v99
		v_cvt_pk_bf16_f32 v72, v100, v101
		v_cvt_pk_bf16_f32 v73, v102, v103
		v_cvt_pk_bf16_f32 v76, v104, v105
		v_cvt_pk_bf16_f32 v77, v106, v107
		v_cvt_pk_bf16_f32 v80, v108, v109
		v_cvt_pk_bf16_f32 v81, v110, v111
		v_cvt_pk_bf16_f32 v84, v112, v113
		v_cvt_pk_bf16_f32 v85, v114, v115
		v_cvt_pk_bf16_f32 v74, v116, v117
		v_cvt_pk_bf16_f32 v75, v118, v119
		v_cvt_pk_bf16_f32 v78, v120, v121
		v_cvt_pk_bf16_f32 v79, v122, v123
		v_cvt_pk_bf16_f32 v82, v124, v125
		v_cvt_pk_bf16_f32 v83, v126, v127
		v_cvt_pk_bf16_f32 v86, v128, v129
		v_cvt_pk_bf16_f32 v87, v130, v131
		v_cvt_pk_bf16_f32 v88, v132, v133
		v_cvt_pk_bf16_f32 v89, v134, v135
		v_cvt_pk_bf16_f32 v92, v136, v137
		v_cvt_pk_bf16_f32 v93, v138, v139
		v_cvt_pk_bf16_f32 v96, v140, v141
		v_cvt_pk_bf16_f32 v97, v142, v143
		v_cvt_pk_bf16_f32 v100, v144, v145
		v_cvt_pk_bf16_f32 v101, v146, v147
		v_cvt_pk_bf16_f32 v90, v148, v149
		v_cvt_pk_bf16_f32 v91, v150, v151
		v_cvt_pk_bf16_f32 v94, v152, v153
		v_cvt_pk_bf16_f32 v95, v154, v155
		v_cvt_pk_bf16_f32 v98, v156, v157
		v_cvt_pk_bf16_f32 v99, v158, v159
		v_cvt_pk_bf16_f32 v102, v160, v161
		v_cvt_pk_bf16_f32 v103, v162, v163
		v_cvt_pk_bf16_f32 v104, v164, v165
		v_cvt_pk_bf16_f32 v105, v166, v167
		v_cvt_pk_bf16_f32 v108, v168, v169
		v_cvt_pk_bf16_f32 v109, v170, v171
		v_cvt_pk_bf16_f32 v112, v172, v173
		v_cvt_pk_bf16_f32 v113, v174, v175
		v_cvt_pk_bf16_f32 v116, v176, v177
		v_cvt_pk_bf16_f32 v117, v178, v179
		v_cvt_pk_bf16_f32 v106, v180, v181
		v_cvt_pk_bf16_f32 v107, v182, v183
		v_cvt_pk_bf16_f32 v110, v184, v185
		v_cvt_pk_bf16_f32 v111, v186, v187
		v_cvt_pk_bf16_f32 v114, v188, v189
		v_cvt_pk_bf16_f32 v115, v190, v191
		v_cvt_pk_bf16_f32 v118, v192, v193
		v_cvt_pk_bf16_f32 v119, v194, v195
		ds_write_b128 v0, v[44:47]
		ds_write_b128 v0, v[20:23] offset:4096
		ds_write_b128 v0, v[56:59] offset:8192
		ds_write_b128 v0, v[64:67] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v5, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[44:47], v2 offset:256
		ds_read_b128 v[56:59], v2 offset:2048
		ds_read_b128 v[64:67], v2 offset:2304
		v_lshlrev_b32_e32 v7, 2, v3
		v_add_u32_e32 v8, 16, v9
		v_lshlrev_b32_e32 v15, 1, v6
		v_xor_b32_e32 v8, v8, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[72:75]
		ds_write_b128 v0, v[76:79] offset:4096
		ds_write_b128 v0, v[80:83] offset:8192
		ds_write_b128 v0, v[84:87] offset:12288
		v_bitop3_b32 v8, v5, v7, v8 bitop3:0x96
		v_add_u32_e32 v17, 32, v9
		v_xor_b32_e32 v17, v17, v15
		v_bitop3_b32 v17, v5, v7, v17 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v2
		ds_read_b128 v[76:79], v2 offset:256
		ds_read_b128 v[80:83], v2 offset:2048
		ds_read_b128 v[84:87], v2 offset:2304
		v_add_u32_e32 v19, 48, v9
		v_xor_b32_e32 v19, v19, v15
		v_bitop3_b32 v19, v5, v7, v19 bitop3:0x96
		v_add_u32_e32 v50, 64, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[88:91]
		ds_write_b128 v0, v[92:95] offset:4096
		ds_write_b128 v0, v[96:99] offset:8192
		ds_write_b128 v0, v[100:103] offset:12288
		v_xor_b32_e32 v50, v50, v15
		v_bitop3_b32 v50, v5, v7, v50 bitop3:0x96
		v_add_u32_e32 v51, 0x50, v9
		v_xor_b32_e32 v51, v51, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[88:91], v2
		ds_read_b128 v[92:95], v2 offset:256
		ds_read_b128 v[96:99], v2 offset:2048
		ds_read_b128 v[100:103], v2 offset:2304
		v_bitop3_b32 v51, v5, v7, v51 bitop3:0x96
		v_add_u32_e32 v120, 0x60, v9
		v_xor_b32_e32 v120, v120, v15
		v_bitop3_b32 v120, v5, v7, v120 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[104:107]
		ds_write_b128 v0, v[108:111] offset:4096
		ds_write_b128 v0, v[112:115] offset:8192
		ds_write_b128 v0, v[116:119] offset:12288
		v_add_u32_e32 v104, 0x70, v9
		v_xor_b32_e32 v104, v104, v15
		v_bitop3_b32 v104, v5, v7, v104 bitop3:0x96
		v_add_u32_e32 v105, 0x80, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v2
		ds_read_b128 v[112:115], v2 offset:256
		ds_read_b128 v[116:119], v2 offset:2048
		ds_read_b128 v[124:127], v2 offset:2304
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v106, s0, v1, v3
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 2, v6
		v_mul_lo_u32 v107, s17, v9
		v_lshlrev_b32_e32 v107, 1, v107
		v_add3_u32 v106, v106, v6, v107
		v_add3_u32 v106, v106, v14, v4
		v_add3_u32 v106, v106, v16, v18
		v_mov_b64_e32 v[128:129], v[20:21]
		v_mov_b64_e32 v[130:131], v[44:45]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[128:131], v106, s[8:11], 0 offen
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v20, s0, v8
		v_add3_u32 v20, v20, v14, v4
		v_add3_u32 v20, v20, v16, v18
		v_mov_b64_e32 v[128:129], v[56:57]
		v_mov_b64_e32 v[130:131], v[64:65]
		buffer_store_dwordx4 v[128:131], v20, s[8:11], 0 offen
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v20, s0, v17
		v_add3_u32 v20, v20, v14, v4
		v_add3_u32 v20, v20, v16, v18
		v_mov_b64_e32 v[128:129], v[22:23]
		v_mov_b64_e32 v[130:131], v[46:47]
		buffer_store_dwordx4 v[128:131], v20, s[8:11], 0 offen
		v_mul_lo_u32 v19, s17, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_add_u32_e32 v20, s0, v19
		v_add3_u32 v20, v20, v14, v4
		v_add3_u32 v20, v20, v16, v18
		v_mov_b64_e32 v[44:45], v[58:59]
		v_mov_b64_e32 v[46:47], v[66:67]
		buffer_store_dwordx4 v[44:47], v20, s[8:11], 0 offen
		v_mul_lo_u32 v20, s17, v50
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v21, s0, v20
		v_add3_u32 v21, v21, v14, v4
		v_add3_u32 v21, v21, v16, v18
		v_mov_b64_e32 v[44:45], v[72:73]
		v_mov_b64_e32 v[46:47], v[76:77]
		buffer_store_dwordx4 v[44:47], v21, s[8:11], 0 offen
		v_mul_lo_u32 v21, s17, v51
		v_lshlrev_b32_e32 v21, 1, v21
		v_add_u32_e32 v22, s0, v21
		v_add3_u32 v22, v22, v14, v4
		v_add3_u32 v22, v22, v16, v18
		v_mov_b64_e32 v[44:45], v[80:81]
		v_mov_b64_e32 v[46:47], v[84:85]
		buffer_store_dwordx4 v[44:47], v22, s[8:11], 0 offen
		v_mul_lo_u32 v22, s17, v120
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v23, s0, v22
		v_add3_u32 v23, v23, v14, v4
		v_add3_u32 v23, v23, v16, v18
		v_mov_b64_e32 v[44:45], v[74:75]
		v_mov_b64_e32 v[46:47], v[78:79]
		buffer_store_dwordx4 v[44:47], v23, s[8:11], 0 offen
		v_mul_lo_u32 v23, s17, v104
		v_lshlrev_b32_e32 v23, 1, v23
		v_add_u32_e32 v44, s0, v23
		v_add3_u32 v44, v44, v14, v4
		v_add3_u32 v44, v44, v16, v18
		v_mov_b64_e32 v[56:57], v[82:83]
		v_mov_b64_e32 v[58:59], v[86:87]
		buffer_store_dwordx4 v[56:59], v44, s[8:11], 0 offen
		v_xor_b32_e32 v44, v105, v15
		v_bitop3_b32 v44, v5, v7, v44 bitop3:0x96
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v14, v4
		v_add3_u32 v45, v45, v16, v18
		v_mov_b64_e32 v[56:57], v[88:89]
		v_mov_b64_e32 v[58:59], v[92:93]
		buffer_store_dwordx4 v[56:59], v45, s[8:11], 0 offen
		v_add_u32_e32 v45, 0x90, v9
		v_xor_b32_e32 v45, v45, v15
		v_bitop3_b32 v45, v5, v7, v45 bitop3:0x96
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v46, s0, v45
		v_add3_u32 v46, v46, v14, v4
		v_add3_u32 v46, v46, v16, v18
		v_mov_b64_e32 v[56:57], v[96:97]
		v_mov_b64_e32 v[58:59], v[100:101]
		buffer_store_dwordx4 v[56:59], v46, s[8:11], 0 offen
		v_add_u32_e32 v46, 0xa0, v9
		v_xor_b32_e32 v46, v46, v15
		v_bitop3_b32 v46, v5, v7, v46 bitop3:0x96
		v_mul_lo_u32 v46, s17, v46
		v_lshlrev_b32_e32 v46, 1, v46
		v_add_u32_e32 v47, s0, v46
		v_add3_u32 v47, v47, v14, v4
		v_add3_u32 v47, v47, v16, v18
		v_mov_b64_e32 v[56:57], v[90:91]
		v_mov_b64_e32 v[58:59], v[94:95]
		buffer_store_dwordx4 v[56:59], v47, s[8:11], 0 offen
		v_add_u32_e32 v47, 0xb0, v9
		v_xor_b32_e32 v47, v47, v15
		v_bitop3_b32 v47, v5, v7, v47 bitop3:0x96
		v_mul_lo_u32 v47, s17, v47
		v_lshlrev_b32_e32 v47, 1, v47
		v_add_u32_e32 v50, s0, v47
		v_add3_u32 v50, v50, v14, v4
		v_add3_u32 v50, v50, v16, v18
		v_mov_b64_e32 v[56:57], v[98:99]
		v_mov_b64_e32 v[58:59], v[102:103]
		buffer_store_dwordx4 v[56:59], v50, s[8:11], 0 offen
		v_add_u32_e32 v50, 0xc0, v9
		v_xor_b32_e32 v50, v50, v15
		v_bitop3_b32 v50, v5, v7, v50 bitop3:0x96
		v_mul_lo_u32 v50, s17, v50
		v_lshlrev_b32_e32 v50, 1, v50
		v_add_u32_e32 v51, s0, v50
		v_add3_u32 v51, v51, v14, v4
		v_add3_u32 v51, v51, v16, v18
		v_mov_b64_e32 v[56:57], v[108:109]
		v_mov_b64_e32 v[58:59], v[112:113]
		buffer_store_dwordx4 v[56:59], v51, s[8:11], 0 offen
		v_add_u32_e32 v51, 0xd0, v9
		v_xor_b32_e32 v51, v51, v15
		v_bitop3_b32 v51, v5, v7, v51 bitop3:0x96
		v_mul_lo_u32 v51, s17, v51
		v_lshlrev_b32_e32 v51, 1, v51
		v_add_u32_e32 v56, s0, v51
		v_add3_u32 v56, v56, v14, v4
		v_add3_u32 v56, v56, v16, v18
		v_mov_b64_e32 v[64:65], v[116:117]
		v_mov_b64_e32 v[66:67], v[124:125]
		buffer_store_dwordx4 v[64:67], v56, s[8:11], 0 offen
		v_add_u32_e32 v56, 0xe0, v9
		v_xor_b32_e32 v56, v56, v15
		v_bitop3_b32 v56, v5, v7, v56 bitop3:0x96
		v_mul_lo_u32 v56, s17, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s0, v56
		v_add3_u32 v57, v57, v14, v4
		v_add3_u32 v57, v57, v16, v18
		v_mov_b64_e32 v[64:65], v[110:111]
		v_mov_b64_e32 v[66:67], v[114:115]
		buffer_store_dwordx4 v[64:67], v57, s[8:11], 0 offen
		v_add_u32_e32 v9, 0xf0, v9
		v_xor_b32_e32 v9, v9, v15
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_mul_lo_u32 v5, s17, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_add_u32_e32 v7, s0, v5
		v_add3_u32 v7, v7, v14, v4
		v_add3_u32 v7, v7, v16, v18
		v_mov_b64_e32 v[64:65], v[118:119]
		v_mov_b64_e32 v[66:67], v[126:127]
		buffer_store_dwordx4 v[64:67], v7, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[44:47], a[64:67], v[196:199], v48, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], a[64:67], v[200:203], v48, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], a[72:75], v[216:219], v48, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[44:47], a[72:75], v[212:215], v48, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[48:51], a[68:71], v[196:199], v48, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[68:71], a[68:71], v[200:203], v48, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], v[60:63], v[216:219], v48, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[48:51], v[60:63], v[212:215], v48, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], a[64:67], v[204:207], v49, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], a[64:67], v[208:211], v49, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], a[72:75], v[224:227], v49, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], a[72:75], v[220:223], v49, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], a[68:71], v[204:207], v49, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v196, v197
		v_cvt_pk_bf16_f32 v65, v198, v199
		v_cvt_pk_bf16_f32 v72, v200, v201
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], a[68:71], v[208:211], v49, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v73, v202, v203
		v_cvt_pk_bf16_f32 v66, v212, v213
		v_cvt_pk_bf16_f32 v67, v214, v215
		ds_write_b128 v0, v[64:67]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[60:63], v[224:227], v49, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v204, v205
		v_cvt_pk_bf16_f32 v65, v206, v207
		v_cvt_pk_bf16_f32 v74, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v49, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v208, v209
		v_cvt_pk_bf16_f32 v61, v210, v211
		v_cvt_pk_bf16_f32 v75, v218, v219
		ds_write_b128 v0, v[72:75] offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[24:27], v[236:239], v49, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v62, v224, v225
		v_cvt_pk_bf16_f32 v63, v226, v227
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[36:39], v[24:27], v[240:243], v49, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v66, v220, v221
		v_cvt_pk_bf16_f32 v67, v222, v223
		ds_write_b128 v0, v[64:67] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[4:7], v[248:251], v49, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], a[4:7], v[244:247], v49, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], a[0:3], v[236:239], v49, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], a[0:3], v[240:243], v49, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[40:43], a[8:11], v[248:251], v49, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], a[8:11], v[244:247], v49, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[44:47], v[24:27], v[228:231], v48, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], v[24:27], v[232:235], v48, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], a[4:7], a[104:107], v48, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[44:47], a[4:7], a[100:103], v48, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v24, v236, v237
		v_cvt_pk_bf16_f32 v25, v238, v239
		v_cvt_pk_bf16_f32 v60, v240, v241
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[48:51], a[0:3], v[228:231], v48, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v61, v242, v243
		v_cvt_pk_bf16_f32 v26, v244, v245
		v_cvt_pk_bf16_f32 v27, v246, v247
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[68:71], a[0:3], v[232:235], v48, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v62, v248, v249
		v_cvt_pk_bf16_f32 v63, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[8:11], a[104:107], v48, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[48:51], a[8:11], a[100:103], v48, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v228, v229
		v_cvt_pk_bf16_f32 v65, v230, v231
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[44:47], a[12:15], a[108:111], v48, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[52:55], a[12:15], a[112:115], v48, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v72, v232, v233
		v_cvt_pk_bf16_f32 v73, v234, v235
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[20:23], a[128:131], v48, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a104
		v_accvgpr_read_b32 v9, a105
		v_cvt_pk_bf16_f32 v74, v7, v9
		v_accvgpr_read_b32 v7, a100
		v_accvgpr_read_b32 v9, a101
		v_cvt_pk_bf16_f32 v66, v7, v9
		v_accvgpr_read_b32 v7, a102
		v_accvgpr_read_b32 v9, a103
		v_cvt_pk_bf16_f32 v67, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[44:47], a[20:23], a[124:127], v48, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a106
		v_accvgpr_read_b32 v9, a107
		v_cvt_pk_bf16_f32 v75, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[48:51], a[16:19], a[108:111], v48, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], a[16:19], a[112:115], v48, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], a[24:27], a[128:131], v48, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[48:51], a[24:27], a[124:127], v48, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], a[12:15], a[116:119], v49, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], a[12:15], a[120:123], v49, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[36:39], a[20:23], a[136:139], v49, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], a[20:23], a[132:135], v49, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], a[16:19], a[116:119], v49, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a108
		v_accvgpr_read_b32 v9, a109
		v_cvt_pk_bf16_f32 v76, v7, v9
		v_accvgpr_read_b32 v7, a110
		v_accvgpr_read_b32 v9, a111
		v_cvt_pk_bf16_f32 v77, v7, v9
		v_accvgpr_read_b32 v7, a112
		v_accvgpr_read_b32 v9, a113
		v_cvt_pk_bf16_f32 v80, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[16:19], a[120:123], v49, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a114
		v_accvgpr_read_b32 v9, a115
		v_cvt_pk_bf16_f32 v81, v7, v9
		v_accvgpr_read_b32 v7, a124
		v_accvgpr_read_b32 v9, a125
		v_cvt_pk_bf16_f32 v78, v7, v9
		v_accvgpr_read_b32 v7, a126
		v_accvgpr_read_b32 v9, a127
		v_cvt_pk_bf16_f32 v79, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[24:27], a[136:139], v49, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a116
		v_accvgpr_read_b32 v9, a117
		v_cvt_pk_bf16_f32 v84, v7, v9
		v_accvgpr_read_b32 v7, a118
		v_accvgpr_read_b32 v9, a119
		v_cvt_pk_bf16_f32 v85, v7, v9
		v_accvgpr_read_b32 v7, a128
		v_accvgpr_read_b32 v9, a129
		v_cvt_pk_bf16_f32 v82, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], a[24:27], a[132:135], v49, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a120
		v_accvgpr_read_b32 v9, a121
		v_cvt_pk_bf16_f32 v88, v7, v9
		v_accvgpr_read_b32 v7, a122
		v_accvgpr_read_b32 v9, a123
		v_cvt_pk_bf16_f32 v89, v7, v9
		v_accvgpr_read_b32 v7, a130
		v_accvgpr_read_b32 v9, a131
		v_cvt_pk_bf16_f32 v83, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], a[28:31], a[148:151], v49, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a136
		v_accvgpr_read_b32 v9, a137
		v_cvt_pk_bf16_f32 v90, v7, v9
		v_accvgpr_read_b32 v7, a138
		v_accvgpr_read_b32 v9, a139
		v_cvt_pk_bf16_f32 v91, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], a[28:31], a[152:155], v49, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], a[36:39], a[168:171], v49, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a132
		v_accvgpr_read_b32 v9, a133
		v_cvt_pk_bf16_f32 v86, v7, v9
		v_accvgpr_read_b32 v7, a134
		v_accvgpr_read_b32 v9, a135
		v_cvt_pk_bf16_f32 v87, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], a[36:39], a[164:167], v49, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], a[32:35], a[148:151], v49, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], a[32:35], a[152:155], v49, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], a[40:43], a[168:171], v49, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], a[40:43], a[164:167], v49, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], a[28:31], a[140:143], v48, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[28:31], a[144:147], v48, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[36:39], a[160:163], v48, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[44:47], a[36:39], a[156:159], v48, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[48:51], a[32:35], a[140:143], v48, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a148
		v_accvgpr_read_b32 v9, a149
		v_cvt_pk_bf16_f32 v28, v7, v9
		v_accvgpr_read_b32 v7, a150
		v_accvgpr_read_b32 v9, a151
		v_cvt_pk_bf16_f32 v29, v7, v9
		v_accvgpr_read_b32 v7, a152
		v_accvgpr_read_b32 v9, a153
		v_cvt_pk_bf16_f32 v32, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[68:71], a[32:35], a[144:147], v48, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a154
		v_accvgpr_read_b32 v9, a155
		v_cvt_pk_bf16_f32 v33, v7, v9
		v_accvgpr_read_b32 v7, a164
		v_accvgpr_read_b32 v9, a165
		v_cvt_pk_bf16_f32 v30, v7, v9
		v_accvgpr_read_b32 v7, a166
		v_accvgpr_read_b32 v9, a167
		v_cvt_pk_bf16_f32 v31, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[68:71], a[40:43], a[160:163], v48, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a140
		v_accvgpr_read_b32 v9, a141
		v_cvt_pk_bf16_f32 v36, v7, v9
		v_accvgpr_read_b32 v7, a142
		v_accvgpr_read_b32 v9, a143
		v_cvt_pk_bf16_f32 v37, v7, v9
		v_accvgpr_read_b32 v7, a168
		v_accvgpr_read_b32 v9, a169
		v_cvt_pk_bf16_f32 v34, v7, v9
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[40:43], a[156:159], v48, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a144
		v_accvgpr_read_b32 v9, a145
		v_cvt_pk_bf16_f32 v40, v7, v9
		v_accvgpr_read_b32 v7, a146
		v_accvgpr_read_b32 v9, a147
		v_cvt_pk_bf16_f32 v41, v7, v9
		v_accvgpr_read_b32 v7, a170
		v_accvgpr_read_b32 v9, a171
		v_cvt_pk_bf16_f32 v35, v7, v9
		ds_read_b128 v[52:55], v2
		v_accvgpr_read_b32 v7, a160
		v_accvgpr_read_b32 v9, a161
		v_cvt_pk_bf16_f32 v42, v7, v9
		v_accvgpr_read_b32 v7, a162
		v_accvgpr_read_b32 v9, a163
		v_cvt_pk_bf16_f32 v43, v7, v9
		ds_read_b128 v[68:71], v2 offset:256
		ds_read_b128 v[92:95], v2 offset:2048
		v_accvgpr_read_b32 v7, a156
		v_accvgpr_read_b32 v9, a157
		v_cvt_pk_bf16_f32 v38, v7, v9
		v_accvgpr_read_b32 v7, a158
		v_accvgpr_read_b32 v9, a159
		v_cvt_pk_bf16_f32 v39, v7, v9
		ds_read_b128 v[96:99], v2 offset:2304
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v6, v107
		v_add3_u32 v1, v1, v14, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[64:67]
		ds_write_b128 v0, v[72:75] offset:4096
		ds_write_b128 v0, v[24:27] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_add3_u32 v1, v1, v16, v18
		v_mov_b64_e32 v[24:25], v[52:53]
		v_mov_b64_e32 v[26:27], v[68:69]
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v1, v14, v4, v16
		v_add_u32_e32 v1, v1, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[60:63], v2 offset:256
		ds_read_b128 v[64:67], v2 offset:2048
		ds_read_b128 v[72:75], v2 offset:2304
		v_add3_u32 v3, v8, v1, s0
		v_mov_b64_e32 v[8:9], v[92:93]
		v_mov_b64_e32 v[10:11], v[96:97]
		buffer_store_dwordx4 v[8:11], v3, s[8:11], 0 offen
		v_add3_u32 v3, v17, v1, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[54:55]
		v_mov_b64_e32 v[10:11], v[70:71]
		buffer_store_dwordx4 v[8:11], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[76:79]
		ds_write_b128 v0, v[80:83] offset:4096
		ds_write_b128 v0, v[84:87] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		v_add3_u32 v1, v19, v1, s0
		v_mov_b64_e32 v[8:9], v[94:95]
		v_mov_b64_e32 v[10:11], v[98:99]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v14, v4, v16
		v_add_u32_e32 v1, v1, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[52:55], v2 offset:256
		ds_read_b128 v[68:71], v2 offset:2048
		ds_read_b128 v[76:79], v2 offset:2304
		v_add3_u32 v3, v20, v1, s0
		v_mov_b64_e32 v[80:81], v[24:25]
		v_mov_b64_e32 v[82:83], v[60:61]
		buffer_store_dwordx4 v[80:83], v3, s[8:11], 0 offen
		v_add3_u32 v3, v21, v1, s0
		s_nop 0
		v_mov_b64_e32 v[80:81], v[64:65]
		v_mov_b64_e32 v[82:83], v[72:73]
		buffer_store_dwordx4 v[80:83], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[36:39]
		ds_write_b128 v0, v[40:43] offset:4096
		ds_write_b128 v0, v[28:31] offset:8192
		ds_write_b128 v0, v[32:35] offset:12288
		v_add3_u32 v0, v22, v1, s0
		v_mov_b64_e32 v[28:29], v[26:27]
		v_mov_b64_e32 v[30:31], v[62:63]
		buffer_store_dwordx4 v[28:31], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:2304
		v_add3_u32 v1, v23, v0, s0
		v_mov_b64_e32 v[20:21], v[66:67]
		v_mov_b64_e32 v[22:23], v[74:75]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, v44, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[8:9]
		v_mov_b64_e32 v[22:23], v[52:53]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v0, v45, v0, s0
		v_mov_b64_e32 v[20:21], v[68:69]
		v_mov_b64_e32 v[22:23], v[76:77]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v46, v0, s0
		v_mov_b64_e32 v[20:21], v[10:11]
		v_mov_b64_e32 v[22:23], v[54:55]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, v47, v0, s0
		v_mov_b64_e32 v[8:9], v[70:71]
		v_mov_b64_e32 v[10:11], v[78:79]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v50, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[24:25]
		v_mov_b64_e32 v[10:11], v[28:29]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		v_add3_u32 v0, v14, v4, v16
		v_add_u32_e32 v0, v0, v18
		v_add3_u32 v1, v51, v0, s0
		v_mov_b64_e32 v[8:9], v[32:33]
		v_mov_b64_e32 v[10:11], v[36:37]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v56, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[26:27]
		v_mov_b64_e32 v[10:11], v[30:31]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v5, v0, s0
		v_mov_b64_e32 v[4:5], v[34:35]
		v_mov_b64_e32 v[6:7], v[38:39]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
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
		.amdhsa_next_free_sgpr 52
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
	.set .L_a4w4_kernel.numbered_sgpr, 52
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
    .sgpr_count:     52
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     428
    .agpr_count:     172
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 99
    wave.regalloc.agpr.dwords: 392
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
