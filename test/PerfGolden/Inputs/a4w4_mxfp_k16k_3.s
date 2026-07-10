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
		v_mul_lo_u32 v7, s14, v8
		v_lshlrev_b32_e32 v7, 6, v7
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v10, 1, v9
		v_mul_lo_u32 v11, s14, v10
		v_lshlrev_b32_e32 v11, 5, v11
		v_add3_u32 v6, v6, v7, v11
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v13, s14, v12
		v_lshlrev_b32_e32 v13, 4, v13
		v_and_b32_e32 v14, 1, v0
		v_lshlrev_b32_e32 v15, 4, v14
		v_add3_u32 v6, v6, v13, v15
		v_lshrrev_b32_e32 v16, 2, v0
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 1, v0
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 5, v18
		v_add3_u32 v20, v6, v17, v19
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		s_mul_i32 s20, s20, s15
		s_lshl_b32 s22, s14, 2
		v_add3_u32 v6, s22, v2, v5
		v_add3_u32 v6, v6, v7, v11
		v_add3_u32 v6, v6, v13, v15
		s_add_i32 m0, s21, 0x1080
		v_add3_u32 v21, v6, v17, v19
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		s_mov_b32 s23, 0
		s_lshl_b32 s28, s14, 3
		v_add3_u32 v6, v2, v5, v7
		v_add3_u32 v6, v6, v11, v13
		v_add3_u32 v6, v6, v15, v17
		s_add_i32 m0, s21, 0x2100
		v_add3_u32 v22, v19, v6, s28
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_mul_i32 s29, 12, s14
		s_add_i32 m0, s21, 0x3180
		v_add3_u32 v23, v19, v6, s29
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		s_lshl_b32 s30, s14, 7
		s_add_i32 m0, s21, 0x4200
		v_add3_u32 v24, v19, v6, s30
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s14
		v_add3_u32 v6, v2, v5, v7
		v_add3_u32 v6, v6, v11, v13
		v_add3_u32 v6, v6, v15, v17
		s_add_i32 m0, s21, 0x5280
		v_add3_u32 v25, v19, v6, s31
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_mul_i32 s32, 0x88, s14
		s_add_i32 m0, s21, 0x6300
		v_add3_u32 v26, v19, v6, s32
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s21, 0x7380
		v_add3_u32 v27, v19, v6, s14
		s_add_u32 s36, s4, s20
		s_addc_u32 s37, s5, 0
		v_mul_lo_u32 v6, s15, v1
		v_lshlrev_b32_e32 v6, 1, v6
		v_mul_lo_u32 v28, s15, v3
		v_add_u32_e32 v29, v6, v28
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		v_mul_lo_u32 v30, s15, v8
		v_lshlrev_b32_e32 v30, 6, v30
		v_mul_lo_u32 v31, s15, v10
		v_lshlrev_b32_e32 v31, 5, v31
		v_add3_u32 v29, v29, v30, v31
		v_mul_lo_u32 v32, s15, v12
		v_lshlrev_b32_e32 v32, 4, v32
		v_add3_u32 v29, v29, v32, v15
		s_add_i32 m0, s21, 0x107c0
		v_add3_u32 v29, v29, v17, v19
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dwordx4 v29, s[36:39], 0 offen lds
		s_lshl_b32 s33, s15, 2
		v_add3_u32 v33, v6, v28, v30
		v_add3_u32 v33, v33, v31, v32
		v_add3_u32 v33, v33, v15, v17
		s_add_i32 m0, s21, 0x11840
		v_add3_u32 v34, v19, v33, s33
		buffer_load_dwordx4 v34, s[36:39], 0 offen lds
		s_lshl_b32 s34, s15, 3
		s_add_i32 m0, s21, 0x128c0
		v_add3_u32 v35, v19, v33, s34
		buffer_load_dwordx4 v35, s[36:39], 0 offen lds
		s_mul_i32 s35, 12, s15
		s_add_i32 m0, s21, 0x13940
		v_add3_u32 v33, v19, v33, s35
		buffer_load_dwordx4 v33, s[36:39], 0 offen lds
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s16, s16, 8
		s_add_i32 s1, s1, s16
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v36, s18, v1
		v_lshlrev_b32_e32 v36, 2, v36
		v_mul_lo_u32 v37, s18, v3
		v_lshlrev_b32_e32 v37, 1, v37
		v_add3_u32 v38, s1, v36, v37
		v_mul_lo_u32 v39, s18, v8
		v_lshlrev_b32_e32 v40, 3, v14
		v_add3_u32 v38, v38, v39, v40
		v_lshlrev_b32_e32 v41, 7, v10
		v_lshlrev_b32_e32 v42, 6, v12
		v_add3_u32 v38, v38, v41, v42
		v_lshlrev_b32_e32 v43, 5, v16
		v_lshlrev_b32_e32 v44, 4, v18
		v_add3_u32 v38, v38, v43, v44
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx2 v[46:47], v38, s[40:43], 0 offen
		s_lshl_b32 s16, s0, 8
		v_mul_lo_u32 v45, s19, v1
		v_lshlrev_b32_e32 v45, 2, v45
		v_mul_lo_u32 v48, s19, v3
		v_lshlrev_b32_e32 v48, 1, v48
		v_add3_u32 v49, s16, v45, v48
		v_mul_lo_u32 v50, s19, v8
		v_lshlrev_b32_e32 v51, 2, v14
		v_add3_u32 v49, v49, v50, v51
		v_lshlrev_b32_e32 v52, 6, v10
		v_lshlrev_b32_e32 v53, 5, v12
		v_add3_u32 v49, v49, v52, v53
		v_lshlrev_b32_e32 v54, 4, v16
		v_lshlrev_b32_e32 v55, 3, v18
		v_add3_u32 v49, v49, v54, v55
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dword v56, v49, s[44:47], 0 offen
		s_lshl_b32 s48, s15, 7
		v_add3_u32 v57, s48, v6, v28
		v_add3_u32 v57, v57, v30, v31
		v_add3_u32 v57, v57, v32, v15
		s_add_i32 m0, s21, 0x18b80
		v_add3_u32 v57, v57, v17, v19
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_mul_i32 s49, 0x84, s15
		v_add3_u32 v58, v6, v28, v30
		v_add3_u32 v58, v58, v31, v32
		v_add3_u32 v58, v58, v15, v17
		s_add_i32 m0, s21, 0x19c00
		v_add3_u32 v59, v19, v58, s49
		buffer_load_dwordx4 v59, s[36:39], 0 offen lds
		s_mul_i32 s50, 0x88, s15
		s_add_i32 m0, s21, 0x1ac80
		v_add3_u32 v60, v19, v58, s50
		buffer_load_dwordx4 v60, s[36:39], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s21, 0x1bd00
		v_add3_u32 v58, v19, v58, s15
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
		s_add_i32 s51, s16, 0x80
		v_add3_u32 v61, s51, v45, v48
		v_add3_u32 v61, v61, v50, v51
		v_add3_u32 v61, v61, v52, v53
		v_add3_u32 v61, v61, v54, v55
		buffer_load_dword v62, v61, s[44:47], 0 offen
		v_add_u32_e32 v63, 0x80, v2
		v_add_u32_e32 v63, v63, v5
		v_add3_u32 v63, v63, v7, v11
		v_add3_u32 v63, v63, v13, v15
		s_add_i32 m0, s21, 0x83e0
		v_add3_u32 v63, v63, v17, v19
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_add_i32 s22, s22, 0x80
		v_add3_u32 v64, s22, v2, v5
		v_add3_u32 v64, v64, v7, v11
		v_add3_u32 v64, v64, v13, v15
		s_add_i32 m0, s21, 0x9460
		v_add3_u32 v64, v64, v17, v19
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		s_add_i32 s22, s28, 0x80
		v_add3_u32 v65, s22, v2, v5
		v_add3_u32 v65, v65, v7, v11
		v_add3_u32 v65, v65, v13, v15
		s_add_i32 m0, s21, 0xa4e0
		v_add3_u32 v65, v65, v17, v19
		buffer_load_dwordx4 v65, s[24:27], 0 offen lds
		s_add_i32 s22, s29, 0x80
		v_add3_u32 v66, s22, v2, v5
		v_add3_u32 v66, v66, v7, v11
		v_add3_u32 v66, v66, v13, v15
		s_add_i32 m0, s21, 0xb560
		v_add3_u32 v66, v66, v17, v19
		buffer_load_dwordx4 v66, s[24:27], 0 offen lds
		s_add_i32 s22, s30, 0x80
		v_add3_u32 v67, s22, v2, v5
		v_add3_u32 v67, v67, v7, v11
		v_add3_u32 v67, v67, v13, v15
		s_add_i32 m0, s21, 0xc5e0
		v_add3_u32 v67, v67, v17, v19
		buffer_load_dwordx4 v67, s[24:27], 0 offen lds
		s_add_i32 s22, s31, 0x80
		v_add3_u32 v68, s22, v2, v5
		v_add3_u32 v68, v68, v7, v11
		v_add3_u32 v68, v68, v13, v15
		s_add_i32 m0, s21, 0xd660
		v_add3_u32 v68, v68, v17, v19
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		s_add_i32 s22, s32, 0x80
		v_add3_u32 v69, s22, v2, v5
		v_add3_u32 v69, v69, v7, v11
		v_add3_u32 v69, v69, v13, v15
		s_add_i32 m0, s21, 0xe6e0
		v_add3_u32 v69, v69, v17, v19
		buffer_load_dwordx4 v69, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v2, s14, v2, v5
		v_add3_u32 v2, v2, v7, v11
		v_add3_u32 v2, v2, v13, v15
		s_add_i32 m0, s21, 0xf760
		v_add3_u32 v2, v2, v17, v19
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v5, 0x80, v6
		v_add_u32_e32 v5, v5, v28
		v_add3_u32 v5, v5, v30, v31
		v_add3_u32 v5, v5, v32, v15
		s_add_i32 m0, s21, 0x149a0
		v_add3_u32 v11, v5, v17, v19
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		s_add_i32 s14, s33, 0x80
		v_add3_u32 v5, v6, v28, v30
		v_add3_u32 v5, v5, v31, v32
		v_add3_u32 v5, v5, v15, v17
		s_add_i32 m0, s21, 0x15a20
		v_add3_u32 v13, v19, v5, s14
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 s14, s34, 0x80
		s_add_i32 m0, s21, 0x16aa0
		v_add3_u32 v70, v19, v5, s14
		buffer_load_dwordx4 v70, s[36:39], 0 offen lds
		s_add_i32 s14, s35, 0x80
		s_add_i32 m0, s21, 0x17b20
		v_add3_u32 v71, v19, v5, s14
		s_lshl_b32 s14, s18, 3
		s_add_i32 s1, s1, s14
		buffer_load_dwordx4 v71, s[36:39], 0 offen lds
		v_add3_u32 v5, s1, v36, v37
		v_add3_u32 v5, v5, v39, v40
		v_add3_u32 v5, v5, v41, v42
		v_add3_u32 v36, v5, v43, v44
		buffer_load_dwordx2 v[72:73], v36, s[40:43], 0 offen
		s_lshl_b32 s1, s19, 3
		s_add_i32 s14, s16, s1
		v_add3_u32 v5, s14, v45, v48
		v_add3_u32 v5, v5, v50, v51
		v_add3_u32 v5, v5, v52, v53
		v_add3_u32 v37, v5, v54, v55
		buffer_load_dword v39, v37, s[44:47], 0 offen
		s_add_i32 s14, s48, 0x80
		v_add3_u32 v5, s14, v6, v28
		v_add3_u32 v5, v5, v30, v31
		v_add3_u32 v5, v5, v32, v15
		s_add_i32 m0, s21, 0x1cd60
		v_add3_u32 v44, v5, v17, v19
		s_waitcnt vmcnt(15)
		buffer_load_dwordx4 v44, s[36:39], 0 offen lds
		s_add_i32 s14, s49, 0x80
		v_add3_u32 v5, v6, v28, v30
		v_add3_u32 v5, v5, v31, v32
		v_add3_u32 v5, v5, v15, v17
		s_add_i32 m0, s21, 0x1dde0
		v_add3_u32 v28, v19, v5, s14
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		s_add_i32 s14, s50, 0x80
		s_add_i32 m0, s21, 0x1ee60
		v_add3_u32 v30, v19, v5, s14
		buffer_load_dwordx4 v30, s[36:39], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s21, 0x1fee0
		v_add3_u32 v31, v19, v5, s14
		buffer_load_dwordx4 v31, s[36:39], 0 offen lds
		s_add_i32 s1, s51, s1
		v_add3_u32 v5, s1, v45, v48
		v_add3_u32 v5, v5, v50, v51
		v_add3_u32 v5, v5, v52, v53
		v_add3_u32 v32, v5, v54, v55
		buffer_load_dword v45, v32, s[44:47], 0 offen
		s_barrier
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s20, 0x100
		s_mul_i32 s14, s18, 16
		s_mul_i32 s15, s19, 16
		v_lshlrev_b32_e32 v5, 7, v1
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v7, 4, v6
		v_lshlrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v6, 15, v6
		v_mov_b32_e32 v48, 0x420
		v_mul_lo_u32 v48, v48, v6
		v_add3_u32 v50, v5, v7, v48
		ds_read_b128 a[0:3], v50
		ds_read_b128 a[4:7], v50 offset:64
		ds_read_b128 a[8:11], v50 offset:256
		ds_read_b128 a[12:15], v50 offset:320
		ds_read_b128 a[16:19], v50 offset:512
		ds_read_b128 a[20:23], v50 offset:576
		ds_read_b128 a[24:27], v50 offset:768
		ds_read_b128 a[28:31], v50 offset:832
		ds_read_b128 a[32:35], v50 offset:16896
		ds_read_b128 a[36:39], v50 offset:16960
		ds_read_b128 a[40:43], v50 offset:17152
		ds_read_b128 a[44:47], v50 offset:17216
		ds_read_b128 a[48:51], v50 offset:17408
		ds_read_b128 a[52:55], v50 offset:17472
		ds_read_b128 a[56:59], v50 offset:17664
		ds_read_b128 a[60:63], v50 offset:17728
		v_add_u32_e32 v5, 0x10000, v7
		v_lshlrev_b32_e32 v6, 7, v3
		v_add3_u32 v48, v5, v6, v48
		ds_read_b128 a[64:67], v48 offset:1984
		ds_read_b128 a[68:71], v48 offset:2048
		ds_read_b128 a[72:75], v48 offset:2240
		ds_read_b128 a[76:79], v48 offset:2304
		ds_read_b128 a[80:83], v48 offset:2496
		ds_read_b128 a[84:87], v48 offset:2560
		ds_read_b128 a[88:91], v48 offset:2752
		ds_read_b128 a[92:95], v48 offset:2816
		v_lshlrev_b32_e32 v5, 3, v0
		v_add_u32_e32 v51, 0x20000, v5
		ds_write_b64 v51, v[46:47] offset:3904
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v46, 0x20000, v5
		ds_write_b32 v46, v56 offset:5952
		v_lshlrev_b32_e32 v5, 4, v1
		s_waitcnt lgkmcnt(1)
		s_barrier
		v_add_u32_e32 v5, 0x20000, v5
		v_add_u32_e32 v5, v5, v40
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v5, v8, 9, v5
		v_lshlrev_b32_e32 v6, 8, v10
		v_add3_u32 v5, v5, v6, v42
		v_lshlrev_b32_e32 v47, 10, v18
		v_add3_u32 v52, v5, v43, v47
		ds_read_b64_tr_b8 v[54:55], v52 offset:3904
		ds_read_b64_tr_b8 v[74:75], v52 offset:4032
		v_add_u32_e32 v5, 0x20000, v40
		v_lshl_add_u32 v5, v3, 4, v5
		v_lshlrev_b32_e32 v6, 8, v8
		v_add3_u32 v5, v5, v6, v41
		v_add3_u32 v5, v5, v42, v43
		v_lshl_add_u32 v18, v18, 9, v5
		ds_read_b64_tr_b8 v[40:41], v18 offset:5952
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
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
.L_a4w4_kernel.loop_head_0:
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[92:95], a[4:7], v[76:79], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], a[12:15], v[92:95], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[92:95], a[20:23], v[108:111], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], a[28:31], v[124:127], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v40, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v40, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v40, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v40, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v41, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v41, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v41, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v41, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], a[36:39], v[140:143], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], a[44:47], v[156:159], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v41, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v41, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v41, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v41, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], a[52:55], v[172:175], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], a[60:63], v[188:191], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v40, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v40, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v40, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v40, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v48 offset:35712
		ds_read_b128 a[68:71], v48 offset:35776
		ds_read_b128 a[72:75], v48 offset:35968
		ds_read_b128 a[76:79], v48 offset:36032
		ds_read_b128 a[80:83], v48 offset:36224
		ds_read_b128 a[84:87], v48 offset:36288
		ds_read_b128 a[88:91], v48 offset:36480
		ds_read_b128 a[92:95], v48 offset:36544
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v62 offset:5952
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v18 offset:5952
		s_waitcnt vmcnt(7)
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], a[0:3], v[192:195], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[0:3], v[196:199], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[8:11], v[212:215], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[64:67], a[8:11], v[208:211], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[68:71], a[4:7], v[192:195], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[76:79], a[4:7], v[196:199], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x7380
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[76:79], a[12:15], v[212:215], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[68:71], a[12:15], v[208:211], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[0:3], v[200:203], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[0:3], v[204:207], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[8:11], v[220:223], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[8:11], v[216:219], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[84:87], a[4:7], v[200:203], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], a[4:7], v[204:207], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[92:95], a[12:15], v[220:223], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[84:87], a[12:15], v[216:219], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[16:19], v[232:235], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[16:19], v[236:239], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[84:87], a[20:23], v[232:235], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[92:95], a[20:23], v[236:239], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[28:31], a[104:107], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[16:19], v[224:227], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[16:19], v[228:231], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[24:27], v[244:247], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[24:27], v[240:243], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[68:71], a[20:23], v[224:227], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[76:79], a[20:23], v[228:231], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x107c0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x11840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x128c0
		s_add_u32 s40, s10, s18
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v35, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x13940
		s_add_u32 s36, s8, s16
		s_addc_u32 s37, s9, 0
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[42:43], v38, s[36:39], 0 offen
		buffer_load_dword v53, v49, s[40:43], 0 offen
		s_barrier
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
		ds_read_b128 a[0:3], v50 offset:33760
		ds_read_b128 a[4:7], v50 offset:33824
		ds_read_b128 a[8:11], v50 offset:34016
		ds_read_b128 a[12:15], v50 offset:34080
		ds_read_b128 a[16:19], v50 offset:34272
		ds_read_b128 a[20:23], v50 offset:34336
		ds_read_b128 a[24:27], v50 offset:34528
		ds_read_b128 a[28:31], v50 offset:34592
		ds_read_b128 a[32:35], v50 offset:50656
		ds_read_b128 a[36:39], v50 offset:50720
		ds_read_b128 a[40:43], v50 offset:50912
		ds_read_b128 a[44:47], v50 offset:50976
		ds_read_b128 a[48:51], v50 offset:51168
		ds_read_b128 a[52:55], v50 offset:51232
		ds_read_b128 a[56:59], v50 offset:51424
		ds_read_b128 a[60:63], v50 offset:51488
		ds_read_b128 a[64:67], v48 offset:18848
		ds_read_b128 a[68:71], v48 offset:18912
		ds_read_b128 a[72:75], v48 offset:19104
		ds_read_b128 a[76:79], v48 offset:19168
		ds_read_b128 a[80:83], v48 offset:19360
		ds_read_b128 a[84:87], v48 offset:19424
		ds_read_b128 a[88:91], v48 offset:19616
		ds_read_b128 v[252:255], v48 offset:19680
		s_waitcnt vmcnt(20)
		ds_write_b64 v51, v[72:73] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v39 offset:5952
		s_add_i32 m0, s21, 0x18b80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[40:41], v52 offset:3904
		ds_read_b64_tr_b8 v[54:55], v52 offset:4032
		ds_read_b64_tr_b8 v[72:73], v18 offset:5952
		buffer_load_dwordx4 v57, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x19c00
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v72, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v59, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ac80
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v72, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v60, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1bd00
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v72, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v58, s[32:35], 0 offen lds
		buffer_load_dword v62, v61, s[40:43], 0 offen
		s_waitcnt vmcnt(20)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v72, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v72, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v72, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v72, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v72, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v73, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v73, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v73, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v73, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v73, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[252:255], a[4:7], v[76:79], v73, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[252:255], a[12:15], v[92:95], v73, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v73, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v73, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v73, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v73, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v73, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v73, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[252:255], a[20:23], v[108:111], v73, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], a[28:31], v[124:127], v73, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v73, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v72, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v72, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v72, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v72, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v72, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v72, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v72, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v72, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v72, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v72, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v72, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v72, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v72, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v72, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v72, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v72, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v73, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v73, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v73, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v73, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v73, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], a[36:39], v[140:143], v73, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], a[44:47], v[156:159], v73, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v73, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v73, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v73, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v73, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v73, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v73, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[252:255], a[52:55], v[172:175], v73, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[252:255], a[60:63], v[188:191], v73, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v73, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v72, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v72, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v72, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v72, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v72, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v72, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v72, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v72, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[64:67], v48 offset:52576
		ds_read_b128 a[68:71], v48 offset:52640
		ds_read_b128 a[72:75], v48 offset:52832
		ds_read_b128 a[76:79], v48 offset:52896
		ds_read_b128 a[80:83], v48 offset:53088
		ds_read_b128 a[84:87], v48 offset:53152
		ds_read_b128 a[88:91], v48 offset:53344
		ds_read_b128 v[252:255], v48 offset:53408
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v45 offset:5952
		s_add_i32 m0, s21, 0x83e0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[74:75], v18 offset:5952
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x9460
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], a[0:3], v[192:195], v74, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xa4e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[0:3], v[196:199], v74, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[8:11], v[212:215], v74, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v66, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[64:67], a[8:11], v[208:211], v74, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v67, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[68:71], a[4:7], v[192:195], v74, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[76:79], a[4:7], v[196:199], v74, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v69, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[76:79], a[12:15], v[212:215], v74, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[68:71], a[12:15], v[208:211], v74, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[0:3], v[200:203], v75, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[0:3], v[204:207], v75, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[8:11], v[220:223], v75, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[8:11], v[216:219], v75, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[84:87], a[4:7], v[200:203], v75, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[252:255], a[4:7], v[204:207], v75, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[252:255], a[12:15], v[220:223], v75, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[84:87], a[12:15], v[216:219], v75, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[16:19], v[232:235], v75, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[16:19], v[236:239], v75, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[24:27], a[104:107], v75, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v75, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[84:87], a[20:23], v[232:235], v75, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[252:255], a[20:23], v[236:239], v75, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[28:31], a[104:107], v75, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[28:31], a[100:103], v75, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[16:19], v[224:227], v74, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[16:19], v[228:231], v74, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[24:27], v[244:247], v74, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[24:27], v[240:243], v74, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[68:71], a[20:23], v[224:227], v74, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[76:79], a[20:23], v[228:231], v74, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v74, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x149a0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v74, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[32:35], a[108:111], v74, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[32:35], a[112:115], v74, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v70, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x17b20
		s_add_i32 s23, s23, 2
		buffer_load_dwordx4 v71, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[72:73], v36, s[36:39], 0 offen
		buffer_load_dword v39, v37, s[40:43], 0 offen
		s_waitcnt vmcnt(21)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[40:43], a[128:131], v74, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[40:43], a[124:127], v74, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v74, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v74, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v74, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v74, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[32:35], a[116:119], v75, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[32:35], a[120:123], v75, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[40:43], a[136:139], v75, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[40:43], a[132:135], v75, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v75, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[36:39], a[120:123], v75, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[44:47], a[136:139], v75, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v75, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[48:51], a[148:151], v75, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[48:51], a[152:155], v75, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[56:59], a[168:171], v75, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[56:59], a[164:167], v75, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v75, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[52:55], a[152:155], v75, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[60:63], a[168:171], v75, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v75, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[48:51], a[140:143], v74, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[48:51], a[144:147], v74, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[56:59], a[160:163], v74, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[56:59], a[156:159], v74, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v74, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v74, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v74, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v74, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 a[0:3], v50
		ds_read_b128 a[4:7], v50 offset:64
		ds_read_b128 a[8:11], v50 offset:256
		ds_read_b128 a[12:15], v50 offset:320
		ds_read_b128 a[16:19], v50 offset:512
		ds_read_b128 a[20:23], v50 offset:576
		ds_read_b128 a[24:27], v50 offset:768
		ds_read_b128 a[28:31], v50 offset:832
		ds_read_b128 a[32:35], v50 offset:16896
		ds_read_b128 a[36:39], v50 offset:16960
		ds_read_b128 a[40:43], v50 offset:17152
		ds_read_b128 a[44:47], v50 offset:17216
		ds_read_b128 a[48:51], v50 offset:17408
		ds_read_b128 a[52:55], v50 offset:17472
		ds_read_b128 a[56:59], v50 offset:17664
		ds_read_b128 a[60:63], v50 offset:17728
		ds_read_b128 a[64:67], v48 offset:1984
		ds_read_b128 a[68:71], v48 offset:2048
		ds_read_b128 a[72:75], v48 offset:2240
		ds_read_b128 a[76:79], v48 offset:2304
		ds_read_b128 a[80:83], v48 offset:2496
		ds_read_b128 a[84:87], v48 offset:2560
		ds_read_b128 a[88:91], v48 offset:2752
		ds_read_b128 a[92:95], v48 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v51, v[42:43] offset:3904
		s_waitcnt vmcnt(19)
		ds_write_b32 v46, v53 offset:5952
		s_add_i32 m0, s21, 0x1cd60
		s_add_i32 s18, s18, s15
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[54:55], v52 offset:3904
		ds_read_b64_tr_b8 v[74:75], v52 offset:4032
		ds_read_b64_tr_b8 v[40:41], v18 offset:5952
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1dde0
		s_nop 0
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1ee60
		s_add_i32 s16, s16, s14
		buffer_load_dwordx4 v30, s[32:35], 0 offen lds
		s_add_i32 m0, s21, 0x1fee0
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 s1, s1, 0x100
		buffer_load_dword v45, v32, s[40:43], 0 offen
		s_cmp_lt_i32 s23, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt vmcnt(1)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v40, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v40, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[8:11], v[84:87], v40, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[64:67], a[8:11], v[80:83], v40, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[76:79], a[12:15], v[84:87], v40, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], a[12:15], v[80:83], v40, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v41, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[0:3], v[76:79], v41, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[8:11], v[92:95], v41, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[8:11], v[88:91], v41, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[92:95], a[4:7], v[76:79], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], a[12:15], v[92:95], v41, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[84:87], a[12:15], v[88:91], v41, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[16:19], v[104:107], v41, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[16:19], v[108:111], v41, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[24:27], v[124:127], v41, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[24:27], v[120:123], v41, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[84:87], a[20:23], v[104:107], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[92:95], a[20:23], v[108:111], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], a[28:31], v[124:127], v41, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], a[28:31], v[120:123], v41, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[64:67], a[16:19], v[96:99], v40, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[16:19], v[100:103], v40, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[24:27], v[116:119], v40, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[64:67], a[24:27], v[112:115], v40, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[68:71], a[20:23], v[96:99], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], a[20:23], v[100:103], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], a[28:31], v[116:119], v40, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[68:71], a[28:31], v[112:115], v40, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[64:67], a[32:35], v[128:131], v40, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[32:35], v[132:135], v40, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[40:43], v[148:151], v40, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[64:67], a[40:43], v[144:147], v40, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[68:71], a[36:39], v[128:131], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[76:79], a[36:39], v[132:135], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[76:79], a[44:47], v[148:151], v40, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[68:71], a[44:47], v[144:147], v40, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[32:35], v[136:139], v41, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[32:35], v[140:143], v41, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[40:43], v[156:159], v41, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[40:43], v[152:155], v41, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[84:87], a[36:39], v[136:139], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], a[36:39], v[140:143], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], a[44:47], v[156:159], v41, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], a[44:47], v[152:155], v41, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[48:51], v[168:171], v41, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[48:51], v[172:175], v41, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[56:59], v[188:191], v41, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[56:59], v[184:187], v41, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[84:87], a[52:55], v[168:171], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], a[52:55], v[172:175], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], a[60:63], v[188:191], v41, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[84:87], a[60:63], v[184:187], v41, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[64:67], a[48:51], v[160:163], v40, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[48:51], v[164:167], v40, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[56:59], v[180:183], v40, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[56:59], v[176:179], v40, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[68:71], a[52:55], v[160:163], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[76:79], a[52:55], v[164:167], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[76:79], a[60:63], v[180:183], v40, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[68:71], a[60:63], v[176:179], v40, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v48 offset:35712
		ds_read_b128 v[24:27], v48 offset:35776
		ds_read_b128 v[28:31], v48 offset:35968
		ds_read_b128 v[32:35], v48 offset:36032
		ds_read_b128 v[40:43], v48 offset:36224
		ds_read_b128 v[56:59], v48 offset:36288
		ds_read_b128 v[64:67], v48 offset:36480
		ds_read_b128 v[68:71], v48 offset:36544
		ds_write_b32 v46, v62 offset:5952
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v2, 9, v14
		v_lshl_add_u32 v2, v9, 4, v2
		v_lshl_add_u32 v2, v12, 13, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[36:37], v18 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], a[0:3], v[192:195], v36, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], a[0:3], v[196:199], v36, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], a[8:11], v[212:215], v36, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], a[8:11], v[208:211], v36, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], a[4:7], v[192:195], v36, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], a[4:7], v[196:199], v36, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[12:15], v[212:215], v36, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], a[12:15], v[208:211], v36, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[0:3], v[200:203], v37, v54 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], a[0:3], v[204:207], v37, v54 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], a[8:11], v[220:223], v37, v54 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[8:11], v[216:219], v37, v54 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], a[4:7], v[200:203], v37, v54 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], a[4:7], v[204:207], v37, v54 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], a[12:15], v[220:223], v37, v54 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], a[12:15], v[216:219], v37, v54 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[16:19], v[232:235], v37, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], a[16:19], v[236:239], v37, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[64:67], a[24:27], a[104:107], v37, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], a[24:27], a[100:103], v37, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[20:23], v[232:235], v37, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], a[20:23], v[236:239], v37, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[28:31], a[104:107], v37, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[56:59], a[28:31], a[100:103], v37, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[20:23], a[16:19], v[224:227], v36, v55 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[16:19], v[228:231], v36, v55 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], a[24:27], v[244:247], v36, v55 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[20:23], a[24:27], v[240:243], v36, v55 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], a[20:23], v[224:227], v36, v55 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[20:23], v[228:231], v36, v55 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], a[28:31], v[244:247], v36, v55 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], a[28:31], v[240:243], v36, v55 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[32:35], a[108:111], v36, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], a[32:35], a[112:115], v36, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], a[40:43], a[128:131], v36, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[40:43], a[124:127], v36, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], a[36:39], a[108:111], v36, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[36:39], a[112:115], v36, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[44:47], a[128:131], v36, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], a[44:47], a[124:127], v36, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[32:35], a[116:119], v37, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[32:35], a[120:123], v37, v74 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[40:43], a[136:139], v37, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[40:43], a[132:135], v37, v74 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[36:39], a[116:119], v37, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], a[36:39], a[120:123], v37, v74 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[44:47], a[136:139], v37, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[44:47], a[132:135], v37, v74 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[48:51], a[148:151], v37, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[48:51], a[152:155], v37, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[56:59], a[168:171], v37, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[56:59], a[164:167], v37, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[52:55], a[148:151], v37, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[52:55], a[152:155], v37, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[60:63], a[168:171], v37, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[60:63], a[164:167], v37, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[48:51], a[140:143], v36, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], a[48:51], a[144:147], v36, v75 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], a[56:59], a[160:163], v36, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[56:59], a[156:159], v36, v75 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], a[52:55], a[140:143], v36, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[52:55], a[144:147], v36, v75 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[60:63], a[160:163], v36, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], a[60:63], a[156:159], v36, v75 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v50 offset:33760
		ds_read_b128 a[0:3], v50 offset:33824
		ds_read_b128 v[24:27], v50 offset:34016
		ds_read_b128 a[4:7], v50 offset:34080
		ds_read_b128 a[8:11], v50 offset:34272
		ds_read_b128 a[12:15], v50 offset:34336
		ds_read_b128 a[16:19], v50 offset:34528
		ds_read_b128 a[20:23], v50 offset:34592
		ds_read_b128 a[24:27], v50 offset:50656
		ds_read_b128 a[28:31], v50 offset:50720
		ds_read_b128 a[32:35], v50 offset:50912
		ds_read_b128 a[36:39], v50 offset:50976
		ds_read_b128 a[40:43], v50 offset:51168
		ds_read_b128 a[44:47], v50 offset:51232
		ds_read_b128 a[48:51], v50 offset:51424
		ds_read_b128 a[52:55], v50 offset:51488
		ds_read_b128 v[28:31], v48 offset:18848
		ds_read_b128 v[32:35], v48 offset:18912
		ds_read_b128 v[40:43], v48 offset:19104
		ds_read_b128 v[56:59], v48 offset:19168
		ds_read_b128 v[60:63], v48 offset:19360
		ds_read_b128 v[64:67], v48 offset:19424
		ds_read_b128 v[68:71], v48 offset:19616
		ds_read_b128 v[252:255], v48 offset:19680
		ds_write_b64 v51, v[72:73] offset:3904
		ds_write_b32 v46, v39 offset:5952
		v_lshlrev_b32_e32 v9, 12, v16
		v_add3_u32 v2, v2, v9, v47
		v_lshlrev_b32_e32 v9, 7, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[12:13], v52 offset:3904
		ds_read_b64_tr_b8 v[36:37], v52 offset:4032
		ds_read_b64_tr_b8 v[38:39], v18 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[28:31], v[20:23], v[248:251], v38, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], v[20:23], a[96:99], v38, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[40:43], v[24:27], v[84:87], v38, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], v[24:27], v[80:83], v38, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[0:3], v[248:251], v38, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[56:59], a[0:3], a[96:99], v38, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[56:59], a[4:7], v[84:87], v38, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], a[4:7], v[80:83], v38, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[60:63], v[20:23], v[4:7], v39, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[68:71], v[20:23], v[76:79], v39, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[68:71], v[24:27], v[92:95], v39, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[60:63], v[24:27], v[88:91], v39, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], a[0:3], v[4:7], v39, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[252:255], a[0:3], v[76:79], v39, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[252:255], a[4:7], v[92:95], v39, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], a[4:7], v[88:91], v39, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[60:63], a[8:11], v[104:107], v39, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], a[8:11], v[108:111], v39, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], a[16:19], v[124:127], v39, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[60:63], a[16:19], v[120:123], v39, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], a[12:15], v[104:107], v39, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[252:255], a[12:15], v[108:111], v39, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], a[20:23], v[124:127], v39, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], a[20:23], v[120:123], v39, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[28:31], a[8:11], v[96:99], v38, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[40:43], a[8:11], v[100:103], v38, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], a[16:19], v[116:119], v38, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[28:31], a[16:19], v[112:115], v38, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[32:35], a[12:15], v[96:99], v38, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[56:59], a[12:15], v[100:103], v38, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[56:59], a[20:23], v[116:119], v38, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], a[20:23], v[112:115], v38, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], a[24:27], v[128:131], v38, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], a[24:27], v[132:135], v38, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], a[32:35], v[148:151], v38, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], a[32:35], v[144:147], v38, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], a[28:31], v[128:131], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[56:59], a[28:31], v[132:135], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[56:59], a[36:39], v[148:151], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], a[36:39], v[144:147], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[60:63], a[24:27], v[136:139], v39, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], a[24:27], v[140:143], v39, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[68:71], a[32:35], v[156:159], v39, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[60:63], a[32:35], v[152:155], v39, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[64:67], a[28:31], v[136:139], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], a[28:31], v[140:143], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], a[36:39], v[156:159], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[64:67], a[36:39], v[152:155], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[60:63], a[40:43], v[168:171], v39, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[68:71], a[40:43], v[172:175], v39, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[68:71], a[48:51], v[188:191], v39, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], a[48:51], v[184:187], v39, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[64:67], a[44:47], v[168:171], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[252:255], a[44:47], v[172:175], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[252:255], a[52:55], v[188:191], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[64:67], a[52:55], v[184:187], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], a[40:43], v[160:163], v38, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], a[40:43], v[164:167], v38, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], a[48:51], v[180:183], v38, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], a[48:51], v[176:179], v38, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[32:35], a[44:47], v[160:163], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[56:59], a[44:47], v[164:167], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], a[52:55], v[180:183], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], a[52:55], v[176:179], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v48 offset:52576
		ds_read_b128 v[32:35], v48 offset:52640
		ds_read_b128 v[40:43], v48 offset:52832
		ds_read_b128 v[52:55], v48 offset:52896
		ds_read_b128 v[56:59], v48 offset:53088
		ds_read_b128 v[60:63], v48 offset:53152
		ds_read_b128 v[64:67], v48 offset:53344
		ds_read_b128 v[68:71], v48 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v46, v45 offset:5952
		v_cvt_pk_bf16_f32 v44, v248, v249
		v_cvt_pk_bf16_f32 v45, v250, v251
		v_accvgpr_read_b32 v11, a96
		v_accvgpr_read_b32 v14, a97
		v_cvt_pk_bf16_f32 v48, v11, v14
		v_accvgpr_read_b32 v11, a98
		v_accvgpr_read_b32 v14, a99
		v_cvt_pk_bf16_f32 v49, v11, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[38:39], v18 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v72, v4, v5
		v_cvt_pk_bf16_f32 v73, v6, v7
		v_cvt_pk_bf16_f32 v4, v76, v77
		v_cvt_pk_bf16_f32 v5, v78, v79
		v_cvt_pk_bf16_f32 v46, v80, v81
		v_cvt_pk_bf16_f32 v47, v82, v83
		v_cvt_pk_bf16_f32 v50, v84, v85
		v_cvt_pk_bf16_f32 v51, v86, v87
		v_cvt_pk_bf16_f32 v74, v88, v89
		v_cvt_pk_bf16_f32 v75, v90, v91
		v_cvt_pk_bf16_f32 v6, v92, v93
		v_cvt_pk_bf16_f32 v7, v94, v95
		v_cvt_pk_bf16_f32 v76, v96, v97
		v_cvt_pk_bf16_f32 v77, v98, v99
		v_cvt_pk_bf16_f32 v80, v100, v101
		v_cvt_pk_bf16_f32 v81, v102, v103
		v_cvt_pk_bf16_f32 v84, v104, v105
		v_cvt_pk_bf16_f32 v85, v106, v107
		v_cvt_pk_bf16_f32 v88, v108, v109
		v_cvt_pk_bf16_f32 v89, v110, v111
		v_cvt_pk_bf16_f32 v78, v112, v113
		v_cvt_pk_bf16_f32 v79, v114, v115
		v_cvt_pk_bf16_f32 v82, v116, v117
		v_cvt_pk_bf16_f32 v83, v118, v119
		v_cvt_pk_bf16_f32 v86, v120, v121
		v_cvt_pk_bf16_f32 v87, v122, v123
		v_cvt_pk_bf16_f32 v90, v124, v125
		v_cvt_pk_bf16_f32 v91, v126, v127
		v_cvt_pk_bf16_f32 v92, v128, v129
		v_cvt_pk_bf16_f32 v93, v130, v131
		v_cvt_pk_bf16_f32 v96, v132, v133
		v_cvt_pk_bf16_f32 v97, v134, v135
		v_cvt_pk_bf16_f32 v100, v136, v137
		v_cvt_pk_bf16_f32 v101, v138, v139
		v_cvt_pk_bf16_f32 v104, v140, v141
		v_cvt_pk_bf16_f32 v105, v142, v143
		v_cvt_pk_bf16_f32 v94, v144, v145
		v_cvt_pk_bf16_f32 v95, v146, v147
		v_cvt_pk_bf16_f32 v98, v148, v149
		v_cvt_pk_bf16_f32 v99, v150, v151
		v_cvt_pk_bf16_f32 v102, v152, v153
		v_cvt_pk_bf16_f32 v103, v154, v155
		v_cvt_pk_bf16_f32 v106, v156, v157
		v_cvt_pk_bf16_f32 v107, v158, v159
		v_cvt_pk_bf16_f32 v108, v160, v161
		v_cvt_pk_bf16_f32 v109, v162, v163
		v_cvt_pk_bf16_f32 v112, v164, v165
		v_cvt_pk_bf16_f32 v113, v166, v167
		v_cvt_pk_bf16_f32 v116, v168, v169
		v_cvt_pk_bf16_f32 v117, v170, v171
		v_cvt_pk_bf16_f32 v120, v172, v173
		v_cvt_pk_bf16_f32 v121, v174, v175
		v_cvt_pk_bf16_f32 v110, v176, v177
		v_cvt_pk_bf16_f32 v111, v178, v179
		v_cvt_pk_bf16_f32 v114, v180, v181
		v_cvt_pk_bf16_f32 v115, v182, v183
		v_cvt_pk_bf16_f32 v118, v184, v185
		v_cvt_pk_bf16_f32 v119, v186, v187
		v_cvt_pk_bf16_f32 v122, v188, v189
		v_cvt_pk_bf16_f32 v123, v190, v191
		ds_write_b128 v0, v[44:47]
		ds_write_b128 v0, v[48:51] offset:4096
		ds_write_b128 v0, v[72:75] offset:8192
		ds_write_b128 v0, v[4:7] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v4, 3, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[44:47], v2
		ds_read_b128 v[48:51], v2 offset:256
		ds_read_b128 v[72:75], v2 offset:2048
		ds_read_b128 v[124:127], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[76:79]
		ds_write_b128 v0, v[80:83] offset:4096
		ds_write_b128 v0, v[84:87] offset:8192
		ds_write_b128 v0, v[88:91] offset:12288
		v_lshlrev_b32_e32 v5, 2, v3
		v_add_u32_e32 v6, 16, v10
		v_lshlrev_b32_e32 v7, 1, v8
		v_xor_b32_e32 v6, v6, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v2
		ds_read_b128 v[80:83], v2 offset:256
		ds_read_b128 v[84:87], v2 offset:2048
		ds_read_b128 v[88:91], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[92:95]
		ds_write_b128 v0, v[96:99] offset:4096
		ds_write_b128 v0, v[100:103] offset:8192
		ds_write_b128 v0, v[104:107] offset:12288
		v_bitop3_b32 v6, v4, v5, v6 bitop3:0x96
		v_add_u32_e32 v11, 32, v10
		v_xor_b32_e32 v11, v11, v7
		v_bitop3_b32 v11, v4, v5, v11 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v2
		ds_read_b128 v[96:99], v2 offset:256
		ds_read_b128 v[100:103], v2 offset:2048
		ds_read_b128 v[104:107], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[108:111]
		ds_write_b128 v0, v[112:115] offset:4096
		ds_write_b128 v0, v[116:119] offset:8192
		ds_write_b128 v0, v[120:123] offset:12288
		v_add_u32_e32 v14, 48, v10
		v_xor_b32_e32 v14, v14, v7
		v_bitop3_b32 v14, v4, v5, v14 bitop3:0x96
		v_add_u32_e32 v16, 64, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v2
		ds_read_b128 v[112:115], v2 offset:256
		ds_read_b128 v[116:119], v2 offset:2048
		ds_read_b128 v[120:123], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v18, s0, v1, v3
		v_mul_lo_u32 v8, s17, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_mul_lo_u32 v128, s17, v10
		v_lshlrev_b32_e32 v128, 1, v128
		v_add3_u32 v18, v18, v8, v128
		v_add3_u32 v18, v18, v15, v9
		v_add3_u32 v18, v18, v17, v19
		v_mov_b64_e32 v[132:133], v[44:45]
		v_mov_b64_e32 v[134:135], v[48:49]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[132:135], v18, s[8:11], 0 offen
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v18, s0, v6
		v_add3_u32 v18, v18, v15, v9
		v_add3_u32 v18, v18, v17, v19
		v_mov_b64_e32 v[132:133], v[72:73]
		v_mov_b64_e32 v[134:135], v[124:125]
		buffer_store_dwordx4 v[132:135], v18, s[8:11], 0 offen
		v_mul_lo_u32 v11, s17, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v18, s0, v11
		v_add3_u32 v18, v18, v15, v9
		v_add3_u32 v18, v18, v17, v19
		v_mov_b64_e32 v[132:133], v[46:47]
		v_mov_b64_e32 v[134:135], v[50:51]
		buffer_store_dwordx4 v[132:135], v18, s[8:11], 0 offen
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v18, s0, v14
		v_add3_u32 v18, v18, v15, v9
		v_add3_u32 v18, v18, v17, v19
		v_mov_b64_e32 v[44:45], v[74:75]
		v_mov_b64_e32 v[46:47], v[126:127]
		buffer_store_dwordx4 v[44:47], v18, s[8:11], 0 offen
		v_xor_b32_e32 v16, v16, v7
		v_bitop3_b32 v16, v4, v5, v16 bitop3:0x96
		v_mul_lo_u32 v16, s17, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v18, s0, v16
		v_add3_u32 v18, v18, v15, v9
		v_add3_u32 v18, v18, v17, v19
		v_mov_b64_e32 v[44:45], v[76:77]
		v_mov_b64_e32 v[46:47], v[80:81]
		buffer_store_dwordx4 v[44:47], v18, s[8:11], 0 offen
		v_add_u32_e32 v18, 0x50, v10
		v_xor_b32_e32 v18, v18, v7
		v_bitop3_b32 v18, v4, v5, v18 bitop3:0x96
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v44, s0, v18
		v_add3_u32 v44, v44, v15, v9
		v_add3_u32 v44, v44, v17, v19
		v_mov_b64_e32 v[48:49], v[84:85]
		v_mov_b64_e32 v[50:51], v[88:89]
		buffer_store_dwordx4 v[48:51], v44, s[8:11], 0 offen
		v_add_u32_e32 v44, 0x60, v10
		v_xor_b32_e32 v44, v44, v7
		v_bitop3_b32 v44, v4, v5, v44 bitop3:0x96
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v15, v9
		v_add3_u32 v45, v45, v17, v19
		v_mov_b64_e32 v[48:49], v[78:79]
		v_mov_b64_e32 v[50:51], v[82:83]
		buffer_store_dwordx4 v[48:51], v45, s[8:11], 0 offen
		v_add_u32_e32 v45, 0x70, v10
		v_xor_b32_e32 v45, v45, v7
		v_bitop3_b32 v45, v4, v5, v45 bitop3:0x96
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v46, s0, v45
		v_add3_u32 v46, v46, v15, v9
		v_add3_u32 v46, v46, v17, v19
		v_mov_b64_e32 v[48:49], v[86:87]
		v_mov_b64_e32 v[50:51], v[90:91]
		buffer_store_dwordx4 v[48:51], v46, s[8:11], 0 offen
		v_add_u32_e32 v46, 0x80, v10
		v_xor_b32_e32 v46, v46, v7
		v_bitop3_b32 v46, v4, v5, v46 bitop3:0x96
		v_mul_lo_u32 v46, s17, v46
		v_lshlrev_b32_e32 v46, 1, v46
		v_add_u32_e32 v47, s0, v46
		v_add3_u32 v47, v47, v15, v9
		v_add3_u32 v47, v47, v17, v19
		v_mov_b64_e32 v[48:49], v[92:93]
		v_mov_b64_e32 v[50:51], v[96:97]
		buffer_store_dwordx4 v[48:51], v47, s[8:11], 0 offen
		v_add_u32_e32 v47, 0x90, v10
		v_xor_b32_e32 v47, v47, v7
		v_bitop3_b32 v47, v4, v5, v47 bitop3:0x96
		v_mul_lo_u32 v47, s17, v47
		v_lshlrev_b32_e32 v47, 1, v47
		v_add_u32_e32 v48, s0, v47
		v_add3_u32 v48, v48, v15, v9
		v_add3_u32 v48, v48, v17, v19
		v_mov_b64_e32 v[72:73], v[100:101]
		v_mov_b64_e32 v[74:75], v[104:105]
		buffer_store_dwordx4 v[72:75], v48, s[8:11], 0 offen
		v_add_u32_e32 v48, 0xa0, v10
		v_xor_b32_e32 v48, v48, v7
		v_bitop3_b32 v48, v4, v5, v48 bitop3:0x96
		v_mul_lo_u32 v48, s17, v48
		v_lshlrev_b32_e32 v48, 1, v48
		v_add_u32_e32 v49, s0, v48
		v_add3_u32 v49, v49, v15, v9
		v_add3_u32 v49, v49, v17, v19
		v_mov_b64_e32 v[72:73], v[94:95]
		v_mov_b64_e32 v[74:75], v[98:99]
		buffer_store_dwordx4 v[72:75], v49, s[8:11], 0 offen
		v_add_u32_e32 v49, 0xb0, v10
		v_xor_b32_e32 v49, v49, v7
		v_bitop3_b32 v49, v4, v5, v49 bitop3:0x96
		v_mul_lo_u32 v49, s17, v49
		v_lshlrev_b32_e32 v49, 1, v49
		v_add_u32_e32 v50, s0, v49
		v_add3_u32 v50, v50, v15, v9
		v_add3_u32 v50, v50, v17, v19
		v_mov_b64_e32 v[72:73], v[102:103]
		v_mov_b64_e32 v[74:75], v[106:107]
		buffer_store_dwordx4 v[72:75], v50, s[8:11], 0 offen
		v_add_u32_e32 v50, 0xc0, v10
		v_xor_b32_e32 v50, v50, v7
		v_bitop3_b32 v50, v4, v5, v50 bitop3:0x96
		v_mul_lo_u32 v50, s17, v50
		v_lshlrev_b32_e32 v50, 1, v50
		v_add_u32_e32 v51, s0, v50
		v_add3_u32 v51, v51, v15, v9
		v_add3_u32 v51, v51, v17, v19
		v_mov_b64_e32 v[72:73], v[108:109]
		v_mov_b64_e32 v[74:75], v[112:113]
		buffer_store_dwordx4 v[72:75], v51, s[8:11], 0 offen
		v_add_u32_e32 v51, 0xd0, v10
		v_xor_b32_e32 v51, v51, v7
		v_bitop3_b32 v51, v4, v5, v51 bitop3:0x96
		v_mul_lo_u32 v51, s17, v51
		v_lshlrev_b32_e32 v51, 1, v51
		v_add_u32_e32 v72, s0, v51
		v_add3_u32 v72, v72, v15, v9
		v_add3_u32 v72, v72, v17, v19
		v_mov_b64_e32 v[76:77], v[116:117]
		v_mov_b64_e32 v[78:79], v[120:121]
		buffer_store_dwordx4 v[76:79], v72, s[8:11], 0 offen
		v_add_u32_e32 v72, 0xe0, v10
		v_xor_b32_e32 v72, v72, v7
		v_bitop3_b32 v72, v4, v5, v72 bitop3:0x96
		v_mul_lo_u32 v72, s17, v72
		v_lshlrev_b32_e32 v72, 1, v72
		v_add_u32_e32 v73, s0, v72
		v_add3_u32 v73, v73, v15, v9
		v_add3_u32 v73, v73, v17, v19
		v_mov_b64_e32 v[76:77], v[110:111]
		v_mov_b64_e32 v[78:79], v[114:115]
		buffer_store_dwordx4 v[76:79], v73, s[8:11], 0 offen
		v_add_u32_e32 v10, 0xf0, v10
		v_xor_b32_e32 v7, v10, v7
		v_bitop3_b32 v4, v4, v5, v7 bitop3:0x96
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v5, s0, v4
		v_add3_u32 v5, v5, v15, v9
		v_add3_u32 v5, v5, v17, v19
		v_mov_b64_e32 v[76:77], v[118:119]
		v_mov_b64_e32 v[78:79], v[122:123]
		buffer_store_dwordx4 v[76:79], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[20:23], v[192:195], v38, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[20:23], v[196:199], v38, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], v[24:27], v[212:215], v38, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[24:27], v[208:211], v38, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], a[0:3], v[192:195], v38, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[52:55], a[0:3], v[196:199], v38, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[52:55], a[4:7], v[212:215], v38, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], a[4:7], v[208:211], v38, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], v[20:23], v[200:203], v39, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], v[20:23], v[204:207], v39, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[24:27], v[220:223], v39, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], v[24:27], v[216:219], v39, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], a[0:3], v[200:203], v39, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], a[0:3], v[204:207], v39, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], a[4:7], v[220:223], v39, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[60:63], a[4:7], v[216:219], v39, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], a[8:11], v[232:235], v39, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], a[8:11], v[236:239], v39, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[64:67], a[16:19], a[104:107], v39, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[56:59], a[16:19], a[100:103], v39, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[60:63], a[12:15], v[232:235], v39, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], a[12:15], v[236:239], v39, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], a[20:23], a[104:107], v39, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[60:63], a[20:23], a[100:103], v39, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], a[8:11], v[224:227], v38, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], a[8:11], v[228:231], v38, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[16:19], v[244:247], v38, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], a[16:19], v[240:243], v38, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], a[12:15], v[224:227], v38, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[52:55], a[12:15], v[228:231], v38, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[52:55], a[20:23], v[244:247], v38, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[20:23], v[240:243], v38, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], a[24:27], a[108:111], v38, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[24:27], a[112:115], v38, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[32:35], a[128:131], v38, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[32:35], a[124:127], v38, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], a[28:31], a[108:111], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[52:55], a[28:31], a[112:115], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[36:39], a[128:131], v38, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], a[36:39], a[124:127], v38, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[56:59], a[24:27], a[116:119], v39, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[64:67], a[24:27], a[120:123], v39, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[64:67], a[32:35], a[136:139], v39, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[56:59], a[32:35], a[132:135], v39, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[60:63], a[28:31], a[116:119], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], a[28:31], a[120:123], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], a[36:39], a[136:139], v39, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[36:39], a[132:135], v39, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[56:59], a[40:43], a[148:151], v39, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[64:67], a[40:43], a[152:155], v39, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[64:67], a[48:51], a[168:171], v39, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[56:59], a[48:51], a[164:167], v39, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[44:47], a[148:151], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[68:71], a[44:47], a[152:155], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[68:71], a[52:55], a[168:171], v39, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[52:55], a[164:167], v39, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[40:43], a[140:143], v38, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[40:43], a[144:147], v38, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[48:51], a[160:163], v38, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[48:51], a[156:159], v38, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], a[44:47], a[140:143], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[44:47], a[144:147], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[52:55], a[160:163], v38, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], a[52:55], a[156:159], v38, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v20, v192, v193
		v_cvt_pk_bf16_f32 v21, v194, v195
		v_cvt_pk_bf16_f32 v24, v196, v197
		v_cvt_pk_bf16_f32 v25, v198, v199
		v_cvt_pk_bf16_f32 v28, v200, v201
		v_cvt_pk_bf16_f32 v29, v202, v203
		v_cvt_pk_bf16_f32 v32, v204, v205
		v_cvt_pk_bf16_f32 v33, v206, v207
		v_cvt_pk_bf16_f32 v22, v208, v209
		v_cvt_pk_bf16_f32 v23, v210, v211
		ds_write_b128 v0, v[20:23]
		v_cvt_pk_bf16_f32 v26, v212, v213
		v_cvt_pk_bf16_f32 v27, v214, v215
		ds_write_b128 v0, v[24:27] offset:4096
		v_cvt_pk_bf16_f32 v30, v216, v217
		v_cvt_pk_bf16_f32 v31, v218, v219
		ds_write_b128 v0, v[28:31] offset:8192
		v_cvt_pk_bf16_f32 v34, v220, v221
		v_cvt_pk_bf16_f32 v35, v222, v223
		ds_write_b128 v0, v[32:35] offset:12288
		v_cvt_pk_bf16_f32 v20, v224, v225
		v_cvt_pk_bf16_f32 v21, v226, v227
		v_cvt_pk_bf16_f32 v24, v228, v229
		v_cvt_pk_bf16_f32 v25, v230, v231
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_cvt_pk_bf16_f32 v28, v232, v233
		v_cvt_pk_bf16_f32 v29, v234, v235
		v_cvt_pk_bf16_f32 v32, v236, v237
		v_cvt_pk_bf16_f32 v33, v238, v239
		v_cvt_pk_bf16_f32 v22, v240, v241
		v_cvt_pk_bf16_f32 v23, v242, v243
		v_cvt_pk_bf16_f32 v26, v244, v245
		v_cvt_pk_bf16_f32 v27, v246, v247
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v7, a101
		v_cvt_pk_bf16_f32 v30, v5, v7
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v7, a103
		v_cvt_pk_bf16_f32 v31, v5, v7
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v7, a105
		v_cvt_pk_bf16_f32 v34, v5, v7
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v7, a107
		v_cvt_pk_bf16_f32 v35, v5, v7
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v7, a109
		v_cvt_pk_bf16_f32 v36, v5, v7
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v7, a111
		v_cvt_pk_bf16_f32 v37, v5, v7
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v7, a113
		v_cvt_pk_bf16_f32 v40, v5, v7
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v7, a115
		v_cvt_pk_bf16_f32 v41, v5, v7
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v7, a117
		v_cvt_pk_bf16_f32 v52, v5, v7
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v7, a119
		v_cvt_pk_bf16_f32 v53, v5, v7
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v7, a121
		v_cvt_pk_bf16_f32 v56, v5, v7
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v7, a123
		v_cvt_pk_bf16_f32 v57, v5, v7
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v7, a125
		v_cvt_pk_bf16_f32 v38, v5, v7
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v7, a127
		v_cvt_pk_bf16_f32 v39, v5, v7
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v7, a129
		v_cvt_pk_bf16_f32 v42, v5, v7
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v7, a131
		v_cvt_pk_bf16_f32 v43, v5, v7
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v7, a133
		v_cvt_pk_bf16_f32 v54, v5, v7
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v7, a135
		v_cvt_pk_bf16_f32 v55, v5, v7
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v7, a137
		v_cvt_pk_bf16_f32 v58, v5, v7
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v7, a139
		v_cvt_pk_bf16_f32 v59, v5, v7
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v7, a141
		v_cvt_pk_bf16_f32 v60, v5, v7
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v7, a143
		v_cvt_pk_bf16_f32 v61, v5, v7
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v7, a145
		v_cvt_pk_bf16_f32 v64, v5, v7
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v7, a147
		v_cvt_pk_bf16_f32 v65, v5, v7
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v7, a149
		v_cvt_pk_bf16_f32 v68, v5, v7
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v7, a151
		v_cvt_pk_bf16_f32 v69, v5, v7
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v7, a153
		v_cvt_pk_bf16_f32 v76, v5, v7
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v7, a155
		v_cvt_pk_bf16_f32 v77, v5, v7
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v7, a157
		v_cvt_pk_bf16_f32 v62, v5, v7
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v7, a159
		v_cvt_pk_bf16_f32 v63, v5, v7
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v7, a161
		v_cvt_pk_bf16_f32 v66, v5, v7
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v7, a163
		v_cvt_pk_bf16_f32 v67, v5, v7
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v7, a165
		v_cvt_pk_bf16_f32 v70, v5, v7
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v7, a167
		v_cvt_pk_bf16_f32 v71, v5, v7
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v7, a169
		v_cvt_pk_bf16_f32 v78, v5, v7
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v7, a171
		v_cvt_pk_bf16_f32 v79, v5, v7
		ds_read_b128 v[80:83], v2
		ds_read_b128 v[84:87], v2 offset:256
		ds_read_b128 v[88:91], v2 offset:2048
		ds_read_b128 v[92:95], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[20:23]
		ds_write_b128 v0, v[24:27] offset:4096
		ds_write_b128 v0, v[28:31] offset:8192
		ds_write_b128 v0, v[32:35] offset:12288
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v3
		v_add3_u32 v1, v1, v8, v128
		v_add3_u32 v1, v1, v15, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[24:27], v2 offset:256
		ds_read_b128 v[28:31], v2 offset:2048
		ds_read_b128 v[32:35], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[36:39]
		ds_write_b128 v0, v[40:43] offset:4096
		ds_write_b128 v0, v[52:55] offset:8192
		ds_write_b128 v0, v[56:59] offset:12288
		v_add3_u32 v1, v1, v17, v19
		v_mov_b64_e32 v[36:37], v[80:81]
		v_mov_b64_e32 v[38:39], v[84:85]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v1, v15, v9, v17
		v_add_u32_e32 v1, v1, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v2
		ds_read_b128 v[40:43], v2 offset:256
		ds_read_b128 v[52:55], v2 offset:2048
		ds_read_b128 v[56:59], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v0, v[60:63]
		ds_write_b128 v0, v[64:67] offset:4096
		ds_write_b128 v0, v[68:71] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		v_add3_u32 v0, v6, v1, s0
		v_mov_b64_e32 v[60:61], v[88:89]
		v_mov_b64_e32 v[62:63], v[92:93]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, v11, v1, s0
		s_nop 0
		v_mov_b64_e32 v[60:61], v[82:83]
		v_mov_b64_e32 v[62:63], v[86:87]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v2
		ds_read_b128 v[64:67], v2 offset:256
		ds_read_b128 v[68:71], v2 offset:2048
		ds_read_b128 v[76:79], v2 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v0, v14, v1, s0
		v_mov_b64_e32 v[80:81], v[90:91]
		v_mov_b64_e32 v[82:83], v[94:95]
		buffer_store_dwordx4 v[80:83], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v9, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v16, v0, s0
		v_mov_b64_e32 v[80:81], v[20:21]
		v_mov_b64_e32 v[82:83], v[24:25]
		buffer_store_dwordx4 v[80:83], v1, s[8:11], 0 offen
		v_add3_u32 v1, v18, v0, s0
		s_nop 0
		v_mov_b64_e32 v[80:81], v[28:29]
		v_mov_b64_e32 v[82:83], v[32:33]
		buffer_store_dwordx4 v[80:83], v1, s[8:11], 0 offen
		v_add3_u32 v0, v44, v0, s0
		s_nop 0
		v_mov_b64_e32 v[80:81], v[22:23]
		v_mov_b64_e32 v[82:83], v[26:27]
		buffer_store_dwordx4 v[80:83], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v9, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v45, v0, s0
		v_mov_b64_e32 v[20:21], v[30:31]
		v_mov_b64_e32 v[22:23], v[34:35]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, v46, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[36:37]
		v_mov_b64_e32 v[22:23], v[40:41]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v0, v47, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[52:53]
		v_mov_b64_e32 v[22:23], v[56:57]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v9, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v48, v0, s0
		v_mov_b64_e32 v[20:21], v[38:39]
		v_mov_b64_e32 v[22:23], v[42:43]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v1, v49, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[54:55]
		v_mov_b64_e32 v[22:23], v[58:59]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v0, v50, v0, s0
		s_nop 0
		v_mov_b64_e32 v[20:21], v[60:61]
		v_mov_b64_e32 v[22:23], v[64:65]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v15, v9, v17
		v_add_u32_e32 v0, v0, v19
		v_add3_u32 v1, v51, v0, s0
		v_mov_b64_e32 v[8:9], v[68:69]
		v_mov_b64_e32 v[10:11], v[76:77]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v72, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[62:63]
		v_mov_b64_e32 v[10:11], v[66:67]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v4, v0, s0
		v_mov_b64_e32 v[4:5], v[70:71]
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
    wave.regalloc.iterations: 96
    wave.regalloc.agpr.dwords: 380
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
