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
		s_mul_i32 s16, s12, 32
		s_add_i32 s20, s16, s13
		s_branch .L_a4w4_kernel.if_end_0
.L_a4w4_kernel.if_else_0:
		s_add_i32 s12, s12, -8
		s_mul_i32 s12, s12, 31
		s_add_i32 s12, s12, 0x100
		s_add_i32 s20, s12, s13
.L_a4w4_kernel.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s12, 1, 0
		s_xor_b32 s13, s20, -1
		s_add_i32 s13, s13, 1
		s_cmp_lg_u32 s12, 0
		s_cselect_b32 s12, s13, s20
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s16, s1, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s16, s16, s1
		v_mov_b32_e32 v1, s16
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s21, s16, -1
		v_readfirstlane_b32 s22, v1
		s_add_i32 s21, s21, 1
		s_mul_i32 s23, s21, s22
		s_mul_hi_u32 s23, s22, s23
		s_add_i32 s22, s22, s23
		s_mul_hi_u32 s22, s12, s22
		s_mul_i32 s23, s22, s16
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s12, s12, s23
		s_cmp_ge_u32 s12, s16
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s12, s21
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s12, s24, s12
		s_cmp_ge_u32 s12, s16
		s_cselect_b32 s16, 1, 0
		s_add_i32 s23, s22, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s23, s22
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s1, s20, s1
		s_xor_b32 s20, s16, -1
		s_add_i32 s20, s20, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s20, s16
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
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s24, s21, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s24, s24, 1
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s26, s24, s25
		s_mul_hi_u32 s26, s25, s26
		s_add_i32 s25, s25, s26
		s_mul_hi_u32 s25, s13, s25
		s_mul_i32 s25, s25, s21
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s25, s13, s25
		s_add_i32 s26, s25, s24
		s_cmp_ge_u32 s25, s21
		s_cselect_b32 s25, s26, s25
		s_add_i32 s24, s25, s24
		s_cmp_ge_u32 s25, s21
		s_cselect_b32 s21, s24, s25
		s_xor_b32 s24, s21, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s20, s24, s21
		s_add_i32 s16, s16, s20
		s_cmp_lg_u32 s23, 0
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
		s_mul_i32 s12, s16, 0x100
		s_mul_i32 s13, s12, s14
		s_mul_i32 s16, s0, 0x100
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s21, v0
		s_lshr_b32 s21, s21, 6
		s_mul_i32 s21, 0x420, s21
		s_mov_b32 m0, s21
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v3, 1, v3
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v5, 5, v4
		v_lshl_add_u32 v5, v3, 6, v5
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a0, v6
		v_accvgpr_read_b32 v6, a0
		v_lshl_add_u32 v5, v6, 4, v5
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_bitop3_b32 v2, v2, v5, v6 bitop3:0x96
		v_mul_lo_u32 v5, s14, v2
		v_and_b32_e32 v7, 1, v0
		v_lshlrev_b32_e32 v8, 4, v7
		v_add_u32_e32 v5, v5, v8
		v_lshrrev_b32_e32 v9, 2, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v10, 6, v9
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v12, 5, v11
		v_add3_u32 v5, v5, v10, v12
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s16, s16, s15
		s_add_i32 m0, m0, 0x1080
		v_xor_b32_e32 v13, 4, v2
		v_mul_lo_u32 v14, s14, v13
		v_add_u32_e32 v14, v14, v8
		v_add3_u32 v14, v14, v10, v12
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_mov_b32 s22, 0
		s_add_i32 m0, m0, 0x1080
		v_xor_b32_e32 v15, 8, v2
		v_mul_lo_u32 v16, s14, v15
		v_add_u32_e32 v16, v16, v8
		v_add3_u32 v16, v16, v10, v12
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		v_xor_b32_e32 v17, 8, v13
		s_add_i32 m0, m0, 0x1080
		v_mul_lo_u32 v18, s14, v17
		v_add_u32_e32 v18, v18, v8
		v_add3_u32 v18, v18, v10, v12
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_lshl_b32 s14, s14, 7
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v19, s14, v5
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v20, s18, v1
		v_add_u32_e32 v21, s14, v14
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_add_u32_e32 v22, s14, v16
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s20, s20, 8
		v_mul_lo_u32 v2, s15, v2
		v_add_u32_e32 v23, s14, v18
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		v_add_u32_e32 v2, v2, v8
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v2, v2, v10, v12
		v_mul_lo_u32 v13, s15, v13
		v_add_u32_e32 v13, v13, v8
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		v_add3_u32 v13, v13, v10, v12
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s28, s4, s16
		s_addc_u32 s29, s5, 0
		v_mul_lo_u32 v15, s15, v15
		v_add_u32_e32 v15, v15, v8
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		v_add3_u32 v15, v15, v10, v12
		s_add_i32 m0, m0, 0x9460
		v_mul_lo_u32 v17, s15, v17
		v_add_u32_e32 v17, v17, v8
		v_add3_u32 v17, v17, v10, v12
		v_lshlrev_b32_e32 v20, 2, v20
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mul_lo_u32 v24, s18, v6
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v24, 1, v24
		v_mul_lo_u32 v25, s18, v3
		v_lshlrev_b32_e32 v26, 3, v7
		v_lshlrev_b32_e32 v27, 7, v4
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v28, a0
		v_lshlrev_b32_e32 v28, 6, v28
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v29, 5, v9
		v_lshlrev_b32_e32 v30, 4, v11
		v_mul_lo_u32 v31, s19, v1
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v31, 2, v31
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_add_i32 s1, s1, s20
		v_add3_u32 v32, s1, v20, v24
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		v_add3_u32 v32, v32, v25, v26
		v_add3_u32 v32, v32, v27, v28
		v_add3_u32 v32, v32, v29, v30
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		buffer_load_dwordx2 v[34:35], v32, s[32:35], 0 offen
		s_lshl_b32 s20, s0, 8
		v_mul_lo_u32 v33, s19, v6
		v_lshlrev_b32_e32 v33, 1, v33
		v_add3_u32 v36, s20, v31, v33
		v_mul_lo_u32 v37, s19, v3
		v_lshlrev_b32_e32 v7, 2, v7
		v_add3_u32 v36, v36, v37, v7
		v_lshlrev_b32_e32 v38, 6, v4
		v_accvgpr_read_b32 v39, a0
		v_lshlrev_b32_e32 v39, 5, v39
		v_add3_u32 v36, v36, v38, v39
		v_lshlrev_b32_e32 v9, 4, v9
		v_lshlrev_b32_e32 v40, 3, v11
		v_add3_u32 v36, v36, v9, v40
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		buffer_load_dword v41, v36, s[36:39], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_lshl_b32 s15, s15, 7
		v_add_u32_e32 v42, s15, v2
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		s_mul_i32 s12, s12, s17
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v43, s15, v13
		v_lshrrev_b32_e32 v44, 8, v0
		v_accvgpr_write_b32 a1, v44
		v_add_u32_e32 v44, s15, v15
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v45, 8, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v46, s15, v17
		v_add_u32_e32 v47, 0x80, v5
		v_lshlrev_b32_e32 v48, 4, v1
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		v_add_u32_e32 v49, 0x80, v14
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s23, s20, 0x80
		v_add3_u32 v50, s23, v31, v33
		v_add3_u32 v50, v50, v37, v7
		buffer_load_dwordx4 v46, s[28:31], 0 offen lds
		v_add3_u32 v50, v50, v38, v39
		v_add3_u32 v50, v50, v9, v40
		buffer_load_dword v51, v50, s[36:39], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		v_lshlrev_b32_e32 v52, 2, v0
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		v_add_u32_e32 v53, 0x80, v16
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v54, 3, v0
		v_add_u32_e32 v55, 0x80, v18
		v_lshlrev_b32_e32 v56, 7, v6
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v57, 7, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v58, 0x80, v2
		buffer_load_dwordx4 v53, s[24:27], 0 offen lds
		v_add_u32_e32 v59, 0x80, v13
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s14, 0x80
		v_add_u32_e32 v60, s14, v5
		v_add_u32_e32 v61, s14, v14
		v_add_u32_e32 v62, s14, v16
		v_add_u32_e32 v63, s14, v18
		v_add_u32_e32 v64, 0x80, v15
		buffer_load_dwordx4 v55, s[24:27], 0 offen lds
		v_add_u32_e32 v65, 0x80, v17
		s_add_i32 m0, m0, 0x1080
		v_and_b32_e32 v66, 63, v0
		v_lshrrev_b32_e32 v67, 4, v66
		v_accvgpr_write_b32 a2, v67
		v_accvgpr_read_b32 v67, a2
		v_lshlrev_b32_e32 v67, 4, v67
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		v_and_b32_e32 v68, 15, v66
		s_add_i32 m0, m0, 0x1080
		v_mov_b32_e32 v69, 0x420
		v_mul_lo_u32 v69, v69, v68
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		v_add_u32_e32 v68, 0x10000, v67
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v56, v68, v56, v69
		v_add_u32_e32 v54, 0x20000, v54
		v_add_u32_e32 v52, 0x20000, v52
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		v_add_u32_e32 v48, 0x20000, v48
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v48, v48, v26
		v_lshl_add_u32 v48, v3, 9, v48
		v_lshl_add_u32 v48, v4, 8, v48
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		v_add3_u32 v48, v48, v28, v29
		s_add_i32 m0, m0, 0x5260
		s_add_i32 s14, s15, 0x80
		v_add_u32_e32 v68, s14, v2
		v_add_u32_e32 v70, s14, v13
		buffer_load_dwordx4 v58, s[28:31], 0 offen lds
		v_add_u32_e32 v71, s14, v15
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s15, s19, 3
		v_add_u32_e32 v72, s14, v17
		v_lshl_add_u32 v48, v11, 10, v48
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		v_add_u32_e32 v73, 0x20000, v26
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s14, s18, 3
		v_lshl_add_u32 v73, v6, 4, v73
		v_add3_u32 v45, v73, v45, v27
		v_add3_u32 v45, v45, v28, v29
		v_lshl_add_u32 v11, v11, 9, v45
		v_accvgpr_read_b32 v45, a1
		v_cmp_ne_u32_e64 vcc, v45, s22
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		s_mul_i32 s19, s19, 16
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s1, s14
		v_add3_u32 v20, s1, v20, v24
		v_add3_u32 v20, v20, v25, v26
		buffer_load_dwordx4 v65, s[28:31], 0 offen lds
		v_add3_u32 v20, v20, v27, v28
		v_add3_u32 v20, v20, v29, v30
		buffer_load_dwordx2 v[24:25], v20, s[32:35], 0 offen
		s_add_i32 s1, s20, s15
		v_add3_u32 v26, s1, v31, v33
		v_add3_u32 v26, v26, v37, v7
		v_add3_u32 v26, v26, v38, v39
		v_add3_u32 v26, v26, v9, v40
		buffer_load_dword v27, v26, s[36:39], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_add_i32 s1, s16, 0x100
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_mul_i32 s14, s18, 16
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s16, s13, 0x100
		buffer_load_dwordx4 v70, s[28:31], 0 offen lds
		v_add3_u32 v28, v57, v67, v69
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s23, s15
		v_add3_u32 v29, s13, v31, v33
		v_add3_u32 v7, v29, v37, v7
		buffer_load_dwordx4 v71, s[28:31], 0 offen lds
		v_add3_u32 v7, v7, v38, v39
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v7, v7, v9, v40
		buffer_load_dwordx4 v72, s[28:31], 0 offen lds
		buffer_load_dword v9, v7, s[36:39], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 a[4:7], v28
		ds_read_b128 a[8:11], v28 offset:64
		ds_read_b128 a[12:15], v28 offset:256
		ds_read_b128 a[16:19], v28 offset:320
		ds_read_b128 a[20:23], v28 offset:512
		ds_read_b128 a[24:27], v28 offset:576
		ds_read_b128 a[28:31], v28 offset:768
		ds_read_b128 a[32:35], v28 offset:832
		ds_read_b128 a[36:39], v28 offset:16896
		ds_read_b128 a[40:43], v28 offset:16960
		ds_read_b128 a[44:47], v28 offset:17152
		ds_read_b128 a[48:51], v28 offset:17216
		ds_read_b128 a[52:55], v28 offset:17408
		ds_read_b128 a[56:59], v28 offset:17472
		ds_read_b128 a[60:63], v28 offset:17664
		ds_read_b128 a[64:67], v28 offset:17728
		ds_read_b128 a[68:71], v56 offset:2016
		ds_read_b128 a[72:75], v56 offset:2080
		ds_read_b128 a[76:79], v56 offset:2272
		ds_read_b128 a[80:83], v56 offset:2336
		ds_read_b128 a[84:87], v56 offset:2528
		ds_read_b128 a[88:91], v56 offset:2592
		ds_read_b128 a[92:95], v56 offset:2784
		ds_read_b128 a[96:99], v56 offset:2848
		s_waitcnt vmcnt(25)
		ds_write_b64 v54, v[34:35] offset:4000
		s_waitcnt vmcnt(24)
		ds_write_b32 v52, v41 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[30:31], v48 offset:4000
		ds_read_b64_tr_b8 v[34:35], v48 offset:4128
		ds_read_b64_tr_b8 v[38:39], v11 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[44:45], vcc
		s_cbranch_execz .L_a4w4_kernel.exec_endif_0
		s_barrier
.L_a4w4_kernel.exec_endif_0:
		s_mov_b64 exec, s[44:45]
		s_setprio 0
		s_mov_b32 s13, s14
		s_mov_b32 s15, s19
		s_add_u32 s28, s2, s16
		s_addc_u32 s29, s3, 0
		s_add_u32 s32, s4, s1
		s_addc_u32 s33, s5, 0
		s_add_u32 s36, s8, s13
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
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		s_mov_b32 s18, s22
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
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a100, v40
		v_accvgpr_write_b32 a101, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a102, v40
		v_accvgpr_write_b32 a103, v41
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a104, v40
		v_accvgpr_write_b32 a105, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a106, v40
		v_accvgpr_write_b32 a107, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a108, v40
		v_accvgpr_write_b32 a109, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a110, v40
		v_accvgpr_write_b32 a111, v41
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a112, v40
		v_accvgpr_write_b32 a113, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a114, v40
		v_accvgpr_write_b32 a115, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a116, v40
		v_accvgpr_write_b32 a117, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a118, v40
		v_accvgpr_write_b32 a119, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a120, v40
		v_accvgpr_write_b32 a121, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a122, v40
		v_accvgpr_write_b32 a123, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a124, v40
		v_accvgpr_write_b32 a125, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a126, v40
		v_accvgpr_write_b32 a127, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a128, v40
		v_accvgpr_write_b32 a129, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a130, v40
		v_accvgpr_write_b32 a131, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a132, v40
		v_accvgpr_write_b32 a133, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a134, v40
		v_accvgpr_write_b32 a135, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a136, v40
		v_accvgpr_write_b32 a137, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a138, v40
		v_accvgpr_write_b32 a139, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a140, v40
		v_accvgpr_write_b32 a141, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a142, v40
		v_accvgpr_write_b32 a143, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a144, v40
		v_accvgpr_write_b32 a145, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a146, v40
		v_accvgpr_write_b32 a147, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a148, v40
		v_accvgpr_write_b32 a149, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a150, v40
		v_accvgpr_write_b32 a151, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a152, v40
		v_accvgpr_write_b32 a153, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a154, v40
		v_accvgpr_write_b32 a155, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a156, v40
		v_accvgpr_write_b32 a157, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a158, v40
		v_accvgpr_write_b32 a159, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a160, v40
		v_accvgpr_write_b32 a161, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a162, v40
		v_accvgpr_write_b32 a163, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a164, v40
		v_accvgpr_write_b32 a165, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a166, v40
		v_accvgpr_write_b32 a167, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a168, v40
		v_accvgpr_write_b32 a169, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a170, v40
		v_accvgpr_write_b32 a171, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a172, v40
		v_accvgpr_write_b32 a173, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a174, v40
		v_accvgpr_write_b32 a175, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a176, v40
		v_accvgpr_write_b32 a177, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a178, v40
		v_accvgpr_write_b32 a179, v41
.L_a4w4_kernel.loop_head_0:
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[4:7], v[76:79], v38, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[4:7], v[80:83], v38, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[12:15], v[96:99], v38, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[12:15], v[92:95], v38, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[8:11], v[76:79], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[8:11], v[80:83], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[16:19], v[96:99], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[16:19], v[92:95], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[4:7], v[84:87], v39, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[4:7], v[88:91], v39, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[12:15], v[104:107], v39, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[12:15], v[100:103], v39, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[8:11], v[84:87], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], a[8:11], v[88:91], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], a[16:19], v[104:107], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[16:19], v[100:103], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[20:23], v[116:119], v39, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[20:23], v[120:123], v39, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[28:31], v[136:139], v39, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[28:31], v[132:135], v39, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[24:27], v[116:119], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[24:27], v[120:123], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[32:35], v[136:139], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[32:35], v[132:135], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[20:23], v[108:111], v38, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[20:23], v[112:115], v38, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[28:31], v[128:131], v38, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[28:31], v[124:127], v38, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[24:27], v[108:111], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[24:27], v[112:115], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[32:35], v[128:131], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[32:35], v[124:127], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[36:39], v[140:143], v38, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[36:39], v[144:147], v38, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[44:47], v[160:163], v38, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[44:47], v[156:159], v38, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[40:43], v[140:143], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[40:43], v[144:147], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[48:51], v[160:163], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[48:51], v[156:159], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[36:39], v[148:151], v39, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[36:39], v[152:155], v39, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[44:47], v[168:171], v39, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[44:47], v[164:167], v39, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[40:43], v[148:151], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[40:43], v[152:155], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[48:51], v[168:171], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[48:51], v[164:167], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[52:55], v[180:183], v39, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[52:55], v[184:187], v39, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[60:63], v[200:203], v39, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[60:63], v[196:199], v39, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[56:59], v[180:183], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[56:59], v[184:187], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[64:67], v[200:203], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[64:67], v[196:199], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[52:55], v[172:175], v38, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[52:55], v[176:179], v38, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[60:63], v[192:195], v38, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[60:63], v[188:191], v38, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[56:59], v[172:175], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[56:59], v[176:179], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[64:67], v[192:195], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[64:67], v[188:191], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt vmcnt(1)
		ds_read_b128 a[68:71], v56 offset:35776
		ds_read_b128 a[72:75], v56 offset:35840
		ds_read_b128 a[76:79], v56 offset:36032
		ds_read_b128 a[80:83], v56 offset:36096
		ds_read_b128 a[84:87], v56 offset:36288
		ds_read_b128 a[88:91], v56 offset:36352
		ds_read_b128 a[92:95], v56 offset:36544
		ds_read_b128 v[252:255], v56 offset:36608
		s_barrier
		ds_write_b32 v52, v51 offset:6048
		s_add_u32 s28, s2, s16
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s21
		s_add_u32 s32, s4, s1
		s_addc_u32 s33, s5, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[38:39], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s40, s10, s15
		s_addc_u32 s41, s11, 0
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_add_u32 s36, s8, s13
		s_addc_u32 s37, s9, 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9460
		s_nop 0
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[40:41], v32, s[36:39], 0 offen
		buffer_load_dword v29, v36, s[40:43], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[4:7], v[204:207], v38, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[4:7], v[208:211], v38, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[12:15], v[224:227], v38, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[12:15], v[220:223], v38, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[8:11], v[204:207], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[8:11], v[208:211], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[16:19], v[224:227], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[16:19], v[220:223], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[4:7], v[212:215], v39, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[4:7], v[216:219], v39, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[12:15], v[232:235], v39, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[12:15], v[228:231], v39, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[8:11], v[212:215], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], a[8:11], v[216:219], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[16:19], v[232:235], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[16:19], v[228:231], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v39, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[20:23], v[244:247], v39, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[92:95], a[28:31], a[112:115], v39, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v39, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[24:27], v[244:247], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[252:255], a[32:35], a[112:115], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[32:35], v[248:251], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[20:23], v[236:239], v38, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[20:23], a[100:103], v38, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[76:79], a[28:31], a[108:111], v38, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[68:71], a[28:31], a[104:107], v38, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[24:27], v[236:239], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[80:83], a[32:35], a[108:111], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[32:35], a[104:107], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[36:39], a[116:119], v38, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[76:79], a[36:39], a[120:123], v38, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[76:79], a[44:47], a[136:139], v38, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[44:47], a[132:135], v38, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[40:43], a[116:119], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[40:43], a[120:123], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[48:51], a[136:139], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[48:51], a[132:135], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[84:87], a[36:39], a[124:127], v39, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[92:95], a[36:39], a[128:131], v39, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[92:95], a[44:47], a[144:147], v39, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[84:87], a[44:47], a[140:143], v39, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[40:43], a[124:127], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[252:255], a[40:43], a[128:131], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[252:255], a[48:51], a[144:147], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[48:51], a[140:143], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[84:87], a[52:55], a[156:159], v39, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[92:95], a[52:55], a[160:163], v39, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[92:95], a[60:63], a[176:179], v39, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[84:87], a[60:63], a[172:175], v39, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[56:59], a[156:159], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[252:255], a[56:59], a[160:163], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[252:255], a[64:67], a[176:179], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[64:67], a[172:175], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[52:55], a[148:151], v38, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[76:79], a[52:55], a[152:155], v38, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[76:79], a[60:63], a[168:171], v38, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[68:71], a[60:63], a[164:167], v38, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[56:59], a[148:151], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[56:59], a[152:155], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[64:67], a[168:171], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[64:67], a[164:167], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[4:7], v28 offset:33792
		ds_read_b128 a[8:11], v28 offset:33856
		ds_read_b128 a[12:15], v28 offset:34048
		ds_read_b128 a[16:19], v28 offset:34112
		ds_read_b128 a[20:23], v28 offset:34304
		ds_read_b128 a[24:27], v28 offset:34368
		ds_read_b128 a[28:31], v28 offset:34560
		ds_read_b128 a[32:35], v28 offset:34624
		ds_read_b128 a[36:39], v28 offset:50688
		ds_read_b128 a[40:43], v28 offset:50752
		ds_read_b128 a[44:47], v28 offset:50944
		ds_read_b128 a[48:51], v28 offset:51008
		ds_read_b128 a[52:55], v28 offset:51200
		ds_read_b128 a[56:59], v28 offset:51264
		ds_read_b128 a[60:63], v28 offset:51456
		ds_read_b128 a[64:67], v28 offset:51520
		ds_read_b128 a[68:71], v56 offset:18912
		ds_read_b128 a[72:75], v56 offset:18976
		ds_read_b128 a[76:79], v56 offset:19168
		ds_read_b128 a[80:83], v56 offset:19232
		ds_read_b128 a[84:87], v56 offset:19424
		ds_read_b128 a[88:91], v56 offset:19488
		ds_read_b128 a[92:95], v56 offset:19680
		ds_read_b128 v[252:255], v56 offset:19744
		ds_write_b64 v54, v[24:25] offset:4000
		ds_write_b32 v52, v27 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[30:31], v48 offset:4000
		ds_read_b64_tr_b8 v[34:35], v48 offset:4128
		ds_read_b64_tr_b8 v[24:25], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v43, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v44, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v46, s[32:35], 0 offen lds
		buffer_load_dword v51, v50, s[40:43], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[4:7], v[76:79], v24, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[4:7], v[80:83], v24, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[12:15], v[96:99], v24, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[12:15], v[92:95], v24, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[8:11], v[76:79], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[8:11], v[80:83], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[16:19], v[96:99], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[16:19], v[92:95], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[4:7], v[84:87], v25, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[4:7], v[88:91], v25, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[12:15], v[104:107], v25, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[12:15], v[100:103], v25, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[8:11], v[84:87], v25, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[252:255], a[8:11], v[88:91], v25, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[252:255], a[16:19], v[104:107], v25, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[16:19], v[100:103], v25, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[20:23], v[116:119], v25, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[20:23], v[120:123], v25, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[28:31], v[136:139], v25, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[28:31], v[132:135], v25, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[24:27], v[116:119], v25, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[252:255], a[24:27], v[120:123], v25, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], a[32:35], v[136:139], v25, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[32:35], v[132:135], v25, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[20:23], v[108:111], v24, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[20:23], v[112:115], v24, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[28:31], v[128:131], v24, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[28:31], v[124:127], v24, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[24:27], v[108:111], v24, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[24:27], v[112:115], v24, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[32:35], v[128:131], v24, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[32:35], v[124:127], v24, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[36:39], v[140:143], v24, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[36:39], v[144:147], v24, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[44:47], v[160:163], v24, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[44:47], v[156:159], v24, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[40:43], v[140:143], v24, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[40:43], v[144:147], v24, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[48:51], v[160:163], v24, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[48:51], v[156:159], v24, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[36:39], v[148:151], v25, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[36:39], v[152:155], v25, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[44:47], v[168:171], v25, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[44:47], v[164:167], v25, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[40:43], v[148:151], v25, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], a[40:43], v[152:155], v25, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], a[48:51], v[168:171], v25, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[48:51], v[164:167], v25, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[52:55], v[180:183], v25, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[52:55], v[184:187], v25, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[60:63], v[200:203], v25, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[60:63], v[196:199], v25, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[56:59], v[180:183], v25, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], a[56:59], v[184:187], v25, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], a[64:67], v[200:203], v25, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[64:67], v[196:199], v25, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[52:55], v[172:175], v24, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[52:55], v[176:179], v24, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[60:63], v[192:195], v24, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[60:63], v[188:191], v24, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[56:59], v[172:175], v24, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[56:59], v[176:179], v24, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[64:67], v[192:195], v24, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[64:67], v[188:191], v24, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[68:71], v56 offset:52672
		ds_read_b128 a[72:75], v56 offset:52736
		ds_read_b128 a[76:79], v56 offset:52928
		ds_read_b128 a[80:83], v56 offset:52992
		ds_read_b128 a[84:87], v56 offset:53184
		ds_read_b128 a[88:91], v56 offset:53248
		ds_read_b128 a[92:95], v56 offset:53440
		ds_read_b128 v[252:255], v56 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v52, v9 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[38:39], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v53, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v55, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v61, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v62, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x5260
		s_nop 0
		buffer_load_dwordx4 v58, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v59, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v64, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v65, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[24:25], v20, s[36:39], 0 offen
		buffer_load_dword v27, v26, s[40:43], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[4:7], v[204:207], v38, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[4:7], v[208:211], v38, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[12:15], v[224:227], v38, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[12:15], v[220:223], v38, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[8:11], v[204:207], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[8:11], v[208:211], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[16:19], v[224:227], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[16:19], v[220:223], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[4:7], v[212:215], v39, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[4:7], v[216:219], v39, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[12:15], v[232:235], v39, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[12:15], v[228:231], v39, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[8:11], v[212:215], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], a[8:11], v[216:219], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[16:19], v[232:235], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[16:19], v[228:231], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v39, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[92:95], a[20:23], v[244:247], v39, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[92:95], a[28:31], a[112:115], v39, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[84:87], a[28:31], v[248:251], v39, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[24:27], v[244:247], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[252:255], a[32:35], a[112:115], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[88:91], a[32:35], v[248:251], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[20:23], v[236:239], v38, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[20:23], a[100:103], v38, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[76:79], a[28:31], a[108:111], v38, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[68:71], a[28:31], a[104:107], v38, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[24:27], v[236:239], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[24:27], a[100:103], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[80:83], a[32:35], a[108:111], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[72:75], a[32:35], a[104:107], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[68:71], a[36:39], a[116:119], v38, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[76:79], a[36:39], a[120:123], v38, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[76:79], a[44:47], a[136:139], v38, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[44:47], a[132:135], v38, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[40:43], a[116:119], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[40:43], a[120:123], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[48:51], a[136:139], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[48:51], a[132:135], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[84:87], a[36:39], a[124:127], v39, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[92:95], a[36:39], a[128:131], v39, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[92:95], a[44:47], a[144:147], v39, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[84:87], a[44:47], a[140:143], v39, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[40:43], a[124:127], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[252:255], a[40:43], a[128:131], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[252:255], a[48:51], a[144:147], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[48:51], a[140:143], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[84:87], a[52:55], a[156:159], v39, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[92:95], a[52:55], a[160:163], v39, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[92:95], a[60:63], a[176:179], v39, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[84:87], a[60:63], a[172:175], v39, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[56:59], a[156:159], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[252:255], a[56:59], a[160:163], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[252:255], a[64:67], a[176:179], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[64:67], a[172:175], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[68:71], a[52:55], a[148:151], v38, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[76:79], a[52:55], a[152:155], v38, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[76:79], a[60:63], a[168:171], v38, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[68:71], a[60:63], a[164:167], v38, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[56:59], a[148:151], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[56:59], a[152:155], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[64:67], a[168:171], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[64:67], a[164:167], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[4:7], v28
		ds_read_b128 a[8:11], v28 offset:64
		ds_read_b128 a[12:15], v28 offset:256
		ds_read_b128 a[16:19], v28 offset:320
		ds_read_b128 a[20:23], v28 offset:512
		ds_read_b128 a[24:27], v28 offset:576
		ds_read_b128 a[28:31], v28 offset:768
		ds_read_b128 a[32:35], v28 offset:832
		ds_read_b128 a[36:39], v28 offset:16896
		ds_read_b128 a[40:43], v28 offset:16960
		ds_read_b128 a[44:47], v28 offset:17152
		ds_read_b128 a[48:51], v28 offset:17216
		ds_read_b128 a[52:55], v28 offset:17408
		ds_read_b128 a[56:59], v28 offset:17472
		ds_read_b128 a[60:63], v28 offset:17664
		ds_read_b128 a[64:67], v28 offset:17728
		ds_read_b128 a[68:71], v56 offset:2016
		ds_read_b128 a[72:75], v56 offset:2080
		ds_read_b128 a[76:79], v56 offset:2272
		ds_read_b128 a[80:83], v56 offset:2336
		ds_read_b128 a[84:87], v56 offset:2528
		ds_read_b128 a[88:91], v56 offset:2592
		ds_read_b128 a[92:95], v56 offset:2784
		ds_read_b128 a[96:99], v56 offset:2848
		s_waitcnt vmcnt(20)
		ds_write_b64 v54, v[40:41] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v52, v29 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v68, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[30:31], v48 offset:4000
		ds_read_b64_tr_b8 v[34:35], v48 offset:4128
		ds_read_b64_tr_b8 v[38:39], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v70, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v71, s[32:35], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v72, s[32:35], 0 offen lds
		buffer_load_dword v9, v7, s[40:43], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s16, s16, 0x100
		s_add_i32 s1, s1, 0x100
		s_add_i32 s13, s13, s14
		s_add_i32 s15, s15, s19
		s_setprio 0
		s_barrier
		s_add_i32 s18, s18, 2
		s_cmp_lt_i32 s18, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_setprio 0
		v_accvgpr_read_b32 v2, a1
		v_cmp_eq_u32_e64 vcc, v2, s22
		s_and_saveexec_b64 s[44:45], vcc
		s_cbranch_execz .L_a4w4_kernel.exec_endif_1
		s_barrier
.L_a4w4_kernel.exec_endif_1:
		s_mov_b64 exec, s[44:45]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], a[4:7], v[76:79], v38, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[76:79], a[4:7], v[80:83], v38, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], a[12:15], v[96:99], v38, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[68:71], a[12:15], v[92:95], v38, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], a[8:11], v[76:79], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[80:83], a[8:11], v[80:83], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[80:83], a[16:19], v[96:99], v38, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], a[16:19], v[92:95], v38, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[84:87], a[4:7], v[84:87], v39, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], a[4:7], v[88:91], v39, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[92:95], a[12:15], v[104:107], v39, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[84:87], a[12:15], v[100:103], v39, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[88:91], a[8:11], v[84:87], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], a[8:11], v[88:91], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], a[16:19], v[104:107], v39, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], a[16:19], v[100:103], v39, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[84:87], a[20:23], v[116:119], v39, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], a[20:23], v[120:123], v39, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], a[28:31], v[136:139], v39, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], a[28:31], v[132:135], v39, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[88:91], a[24:27], v[116:119], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[96:99], a[24:27], v[120:123], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[96:99], a[32:35], v[136:139], v39, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], a[32:35], v[132:135], v39, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[68:71], a[20:23], v[108:111], v38, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], a[20:23], v[112:115], v38, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[76:79], a[28:31], v[128:131], v38, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[68:71], a[28:31], v[124:127], v38, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[72:75], a[24:27], v[108:111], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], a[24:27], v[112:115], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], a[32:35], v[128:131], v38, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[72:75], a[32:35], v[124:127], v38, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[68:71], a[36:39], v[140:143], v38, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[76:79], a[36:39], v[144:147], v38, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[44:47], v[160:163], v38, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[44:47], v[156:159], v38, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[72:75], a[40:43], v[140:143], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[80:83], a[40:43], v[144:147], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[48:51], v[160:163], v38, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[48:51], v[156:159], v38, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], a[36:39], v[148:151], v39, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[36:39], v[152:155], v39, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[44:47], v[168:171], v39, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[44:47], v[164:167], v39, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], a[40:43], v[148:151], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], a[40:43], v[152:155], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], a[48:51], v[168:171], v39, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[48:51], v[164:167], v39, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[52:55], v[180:183], v39, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[52:55], v[184:187], v39, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[60:63], v[200:203], v39, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[60:63], v[196:199], v39, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[56:59], v[180:183], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], a[56:59], v[184:187], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], a[64:67], v[200:203], v39, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[64:67], v[196:199], v39, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[52:55], v[172:175], v38, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[52:55], v[176:179], v38, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[60:63], v[192:195], v38, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[60:63], v[188:191], v38, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[56:59], v[172:175], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[56:59], v[176:179], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[64:67], v[192:195], v38, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[64:67], v[188:191], v38, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[16:19], v56 offset:35776
		ds_read_b128 v[20:23], v56 offset:35840
		ds_read_b128 v[36:39], v56 offset:36032
		ds_read_b128 v[40:43], v56 offset:36096
		ds_read_b128 v[44:47], v56 offset:36288
		ds_read_b128 v[60:63], v56 offset:36352
		ds_read_b128 v[68:71], v56 offset:36544
		ds_read_b128 v[72:75], v56 offset:36608
		s_barrier
		ds_write_b32 v52, v51 offset:6048
		v_lshlrev_b32_e32 v2, 3, v6
		v_lshlrev_b32_e32 v5, 2, v3
		v_bitop3_b32 v0, v2, v0, v5 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v11 offset:6048
		ds_read_b128 a[68:71], v28 offset:33792
		ds_read_b128 a[72:75], v28 offset:33856
		ds_read_b128 a[76:79], v28 offset:34048
		ds_read_b128 v[252:255], v28 offset:34112
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[16:19], a[4:7], v[204:207], v14, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], a[4:7], v[208:211], v14, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], a[12:15], v[224:227], v14, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[16:19], a[12:15], v[220:223], v14, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], a[8:11], v[204:207], v14, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], a[8:11], v[208:211], v14, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], a[16:19], v[224:227], v14, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[20:23], a[16:19], v[220:223], v14, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], a[4:7], v[212:215], v15, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], a[4:7], v[216:219], v15, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[68:71], a[12:15], v[232:235], v15, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], a[12:15], v[228:231], v15, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[60:63], a[8:11], v[212:215], v15, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[72:75], a[8:11], v[216:219], v15, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[72:75], a[16:19], v[232:235], v15, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[60:63], a[16:19], v[228:231], v15, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], a[20:23], v[240:243], v15, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[68:71], a[20:23], v[244:247], v15, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], a[28:31], a[112:115], v15, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[44:47], a[28:31], v[248:251], v15, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[60:63], a[24:27], v[240:243], v15, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[72:75], a[24:27], v[244:247], v15, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[72:75], a[32:35], a[112:115], v15, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[60:63], a[32:35], v[248:251], v15, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[16:19], a[20:23], v[236:239], v14, v31 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], a[20:23], a[100:103], v14, v31 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[28:31], a[108:111], v14, v31 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[16:19], a[28:31], a[104:107], v14, v31 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[20:23], a[24:27], v[236:239], v14, v31 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], a[24:27], a[100:103], v14, v31 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], a[32:35], a[108:111], v14, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], a[32:35], a[104:107], v14, v31 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[16:19], a[36:39], a[116:119], v14, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], a[36:39], a[120:123], v14, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[36:39], a[44:47], a[136:139], v14, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[16:19], a[44:47], a[132:135], v14, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[40:43], a[116:119], v14, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[40:43], a[120:123], v14, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[48:51], a[136:139], v14, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[48:51], a[132:135], v14, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], a[36:39], a[124:127], v15, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], a[36:39], a[128:131], v15, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[68:71], a[44:47], a[144:147], v15, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], a[44:47], a[140:143], v15, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], a[40:43], a[124:127], v15, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[72:75], a[40:43], a[128:131], v15, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[72:75], a[48:51], a[144:147], v15, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], a[48:51], a[140:143], v15, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[44:47], a[52:55], a[156:159], v15, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[68:71], a[52:55], a[160:163], v15, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[68:71], a[60:63], a[176:179], v15, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[44:47], a[60:63], a[172:175], v15, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], a[56:59], a[156:159], v15, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[72:75], a[56:59], a[160:163], v15, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[72:75], a[64:67], a[176:179], v15, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], a[64:67], a[172:175], v15, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[16:19], a[52:55], a[148:151], v14, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], a[52:55], a[152:155], v14, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], a[60:63], a[168:171], v14, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[16:19], a[60:63], a[164:167], v14, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[56:59], a[148:151], v14, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], a[56:59], a[152:155], v14, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], a[64:67], a[168:171], v14, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[20:23], a[64:67], a[164:167], v14, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v28 offset:34304
		ds_read_b128 a[4:7], v28 offset:34368
		ds_read_b128 v[20:23], v28 offset:34560
		ds_read_b128 a[8:11], v28 offset:34624
		ds_read_b128 a[12:15], v28 offset:50688
		ds_read_b128 a[16:19], v28 offset:50752
		ds_read_b128 a[20:23], v28 offset:50944
		ds_read_b128 a[24:27], v28 offset:51008
		ds_read_b128 a[28:31], v28 offset:51200
		ds_read_b128 a[32:35], v28 offset:51264
		ds_read_b128 a[36:39], v28 offset:51456
		ds_read_b128 a[40:43], v28 offset:51520
		ds_read_b128 v[28:31], v56 offset:18912
		ds_read_b128 v[32:35], v56 offset:18976
		ds_read_b128 v[36:39], v56 offset:19168
		ds_read_b128 v[40:43], v56 offset:19232
		ds_read_b128 v[44:47], v56 offset:19424
		ds_read_b128 v[60:63], v56 offset:19488
		ds_read_b128 v[68:71], v56 offset:19680
		ds_read_b128 v[72:75], v56 offset:19744
		ds_write_b64 v54, v[24:25] offset:4000
		v_xor_b32_e32 v5, 1, v0
		v_lshlrev_b32_e32 v5, 4, v5
		v_xor_b32_e32 v7, 2, v0
		v_lshlrev_b32_e32 v7, 4, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v52, v27 offset:6048
		ds_read_b64_tr_b8 v[14:15], v48 offset:4000
		ds_read_b64_tr_b8 v[24:25], v48 offset:4128
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshrrev_b32_e32 v13, 3, v66
		v_and_b32_e32 v13, 1, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v11 offset:6048
		ds_read_b128 a[44:47], v56 offset:52672
		ds_read_b128 a[48:51], v56 offset:52736
		ds_read_b128 a[52:55], v56 offset:52928
		ds_read_b128 v[48:51], v56 offset:52992
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[28:31], a[68:71], v[76:79], v26, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[36:39], a[68:71], v[80:83], v26, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[36:39], a[76:79], v[96:99], v26, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[28:31], a[76:79], v[92:95], v26, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], a[72:75], v[76:79], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[40:43], a[72:75], v[80:83], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[40:43], v[252:255], v[96:99], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], v[252:255], v[92:95], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[44:47], a[68:71], v[84:87], v27, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[68:71], a[68:71], v[88:91], v27, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[68:71], a[76:79], v[104:107], v27, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[44:47], a[76:79], v[100:103], v27, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[60:63], a[72:75], v[84:87], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[72:75], a[72:75], v[88:91], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[72:75], v[252:255], v[104:107], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[60:63], v[252:255], v[100:103], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[44:47], v[16:19], v[116:119], v27, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[16:19], v[120:123], v27, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[20:23], v[136:139], v27, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], v[20:23], v[132:135], v27, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[60:63], a[4:7], v[116:119], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], a[4:7], v[120:123], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], a[8:11], v[136:139], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[60:63], a[8:11], v[132:135], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[28:31], v[16:19], v[108:111], v26, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[36:39], v[16:19], v[112:115], v26, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[20:23], v[128:131], v26, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[28:31], v[20:23], v[124:127], v26, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], a[4:7], v[108:111], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[40:43], a[4:7], v[112:115], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[40:43], a[8:11], v[128:131], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], a[8:11], v[124:127], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], a[12:15], v[140:143], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], a[12:15], v[144:147], v26, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], a[20:23], v[160:163], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], a[20:23], v[156:159], v26, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], a[16:19], v[140:143], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], a[16:19], v[144:147], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], a[24:27], v[160:163], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], a[24:27], v[156:159], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], a[12:15], v[148:151], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], a[12:15], v[152:155], v27, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[68:71], a[20:23], v[168:171], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[44:47], a[20:23], v[164:167], v27, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[60:63], a[16:19], v[148:151], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], a[16:19], v[152:155], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], a[24:27], v[168:171], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[60:63], a[24:27], v[164:167], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], a[28:31], v[180:183], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[68:71], a[28:31], v[184:187], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[68:71], a[36:39], v[200:203], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], a[36:39], v[196:199], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[60:63], a[32:35], v[180:183], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], a[32:35], v[184:187], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[72:75], a[40:43], v[200:203], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[60:63], a[40:43], v[196:199], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], a[28:31], v[172:175], v26, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], a[28:31], v[176:179], v26, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[36:39], a[36:39], v[192:195], v26, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], a[36:39], v[188:191], v26, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], a[32:35], v[172:175], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], a[32:35], v[176:179], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], a[40:43], v[192:195], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], a[40:43], v[188:191], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v56 offset:53184
		ds_read_b128 v[32:35], v56 offset:53248
		ds_read_b128 v[36:39], v56 offset:53440
		ds_read_b128 v[40:43], v56 offset:53504
		v_cvt_pk_bf16_f32 v44, v76, v77
		v_cvt_pk_bf16_f32 v45, v78, v79
		v_cvt_pk_bf16_f32 v56, v80, v81
		v_cvt_pk_bf16_f32 v57, v82, v83
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v52, v9 offset:6048
		v_cvt_pk_bf16_f32 v52, v84, v85
		v_cvt_pk_bf16_f32 v53, v86, v87
		v_cvt_pk_bf16_f32 v60, v88, v89
		v_cvt_pk_bf16_f32 v61, v90, v91
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v11 offset:6048
		v_cvt_pk_bf16_f32 v46, v92, v93
		v_cvt_pk_bf16_f32 v47, v94, v95
		v_cvt_pk_bf16_f32 v58, v96, v97
		v_cvt_pk_bf16_f32 v59, v98, v99
		v_cvt_pk_bf16_f32 v54, v100, v101
		v_cvt_pk_bf16_f32 v55, v102, v103
		v_cvt_pk_bf16_f32 v62, v104, v105
		v_cvt_pk_bf16_f32 v63, v106, v107
		v_cvt_pk_bf16_f32 v68, v108, v109
		v_cvt_pk_bf16_f32 v69, v110, v111
		v_cvt_pk_bf16_f32 v72, v112, v113
		v_cvt_pk_bf16_f32 v73, v114, v115
		v_cvt_pk_bf16_f32 v76, v116, v117
		v_cvt_pk_bf16_f32 v77, v118, v119
		v_cvt_pk_bf16_f32 v80, v120, v121
		v_cvt_pk_bf16_f32 v81, v122, v123
		v_cvt_pk_bf16_f32 v70, v124, v125
		v_cvt_pk_bf16_f32 v71, v126, v127
		v_cvt_pk_bf16_f32 v74, v128, v129
		v_cvt_pk_bf16_f32 v75, v130, v131
		v_cvt_pk_bf16_f32 v78, v132, v133
		v_cvt_pk_bf16_f32 v79, v134, v135
		v_cvt_pk_bf16_f32 v82, v136, v137
		v_cvt_pk_bf16_f32 v83, v138, v139
		v_cvt_pk_bf16_f32 v84, v140, v141
		v_cvt_pk_bf16_f32 v85, v142, v143
		v_cvt_pk_bf16_f32 v88, v144, v145
		v_cvt_pk_bf16_f32 v89, v146, v147
		v_cvt_pk_bf16_f32 v92, v148, v149
		v_cvt_pk_bf16_f32 v93, v150, v151
		v_cvt_pk_bf16_f32 v96, v152, v153
		v_cvt_pk_bf16_f32 v97, v154, v155
		v_cvt_pk_bf16_f32 v86, v156, v157
		v_cvt_pk_bf16_f32 v87, v158, v159
		v_cvt_pk_bf16_f32 v90, v160, v161
		v_cvt_pk_bf16_f32 v91, v162, v163
		v_cvt_pk_bf16_f32 v94, v164, v165
		v_cvt_pk_bf16_f32 v95, v166, v167
		v_cvt_pk_bf16_f32 v98, v168, v169
		v_cvt_pk_bf16_f32 v99, v170, v171
		v_cvt_pk_bf16_f32 v100, v172, v173
		v_cvt_pk_bf16_f32 v101, v174, v175
		v_cvt_pk_bf16_f32 v104, v176, v177
		v_cvt_pk_bf16_f32 v105, v178, v179
		v_cvt_pk_bf16_f32 v108, v180, v181
		v_cvt_pk_bf16_f32 v109, v182, v183
		v_cvt_pk_bf16_f32 v112, v184, v185
		v_cvt_pk_bf16_f32 v113, v186, v187
		v_cvt_pk_bf16_f32 v102, v188, v189
		v_cvt_pk_bf16_f32 v103, v190, v191
		v_cvt_pk_bf16_f32 v106, v192, v193
		v_cvt_pk_bf16_f32 v107, v194, v195
		v_cvt_pk_bf16_f32 v110, v196, v197
		v_cvt_pk_bf16_f32 v111, v198, v199
		v_cvt_pk_bf16_f32 v114, v200, v201
		v_cvt_pk_bf16_f32 v115, v202, v203
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[44:47]
		ds_write_b128 v5, v[56:59] offset:4096
		ds_write_b128 v7, v[52:55] offset:8192
		ds_write_b128 v0, v[60:63] offset:12288
		v_lshrrev_b32_e32 v9, 2, v66
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v11, 12, v9
		v_lshl_add_u32 v11, v13, 13, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v44, v13, 1, v9
		v_lshrrev_b32_e32 v45, 1, v66
		v_and_b32_e32 v45, 1, v45
		v_lshlrev_b32_e32 v46, 3, v45
		v_lshlrev_b32_e32 v47, 3, v1
		v_lshlrev_b32_e32 v52, 2, v6
		v_accvgpr_read_b32 v53, a2
		v_and_b32_e32 v53, 1, v53
		v_and_b32_e32 v54, 1, v66
		v_lshl_add_u32 v53, v54, 5, v53
		v_lshrrev_b32_e32 v54, 5, v66
		v_lshlrev_b32_e32 v54, 1, v54
		v_xor_b32_e32 v53, v53, v54
		v_bitop3_b32 v53, v47, v52, v53 bitop3:0x96
		v_lshl_add_u32 v45, v45, 6, v53
		v_lshrrev_b32_e32 v53, 5, v53
		v_lshlrev_b32_e32 v53, 2, v53
		v_bitop3_b32 v45, v46, v45, v53 bitop3:0x96
		v_xor_b32_e32 v44, v44, v45
		v_lshl_add_u32 v11, v44, 4, v11
		ds_read_b128 v[56:59], v11
		ds_read_b128 v[60:63], v11 offset:256
		ds_read_b128 v[64:67], v11 offset:2048
		ds_read_b128 v[116:119], v11 offset:2304
		v_lshlrev_b32_e32 v9, 2, v9
		v_add_u32_e32 v44, 32, v9
		v_lshlrev_b32_e32 v13, 3, v13
		v_xor_b32_e32 v44, v44, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[68:71]
		ds_write_b128 v5, v[72:75] offset:4096
		ds_write_b128 v7, v[76:79] offset:8192
		ds_write_b128 v0, v[80:83] offset:12288
		v_lshrrev_b32_e32 v46, 5, v44
		v_lshrrev_b32_e32 v53, 3, v44
		v_and_b32_e32 v53, 1, v53
		v_lshlrev_b32_e32 v54, 13, v53
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v46, v46, 14, v54
		v_lshrrev_b32_e32 v44, 2, v44
		v_and_b32_e32 v44, 1, v44
		v_lshl_add_u32 v46, v44, 12, v46
		v_lshl_add_u32 v44, v53, 1, v44
		v_xor_b32_e32 v44, v44, v45
		v_lshl_add_u32 v44, v44, 4, v46
		v_add_u32_e32 v46, 0xffffc000, v44
		ds_read_b128 v[68:71], v46
		v_add_u32_e32 v46, 0xffffc100, v44
		ds_read_b128 v[72:75], v46
		v_add_u32_e32 v46, 0xffffc800, v44
		ds_read_b128 v[76:79], v46
		v_add_u32_e32 v46, 0xffffc900, v44
		ds_read_b128 v[80:83], v46
		v_add_u32_e32 v46, 64, v9
		v_xor_b32_e32 v46, v46, v13
		v_lshrrev_b32_e32 v53, 5, v46
		v_lshrrev_b32_e32 v54, 3, v46
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[84:87]
		ds_write_b128 v5, v[88:91] offset:4096
		ds_write_b128 v7, v[92:95] offset:8192
		ds_write_b128 v0, v[96:99] offset:12288
		v_and_b32_e32 v54, 1, v54
		v_lshlrev_b32_e32 v55, 13, v54
		v_lshl_add_u32 v53, v53, 14, v55
		v_lshrrev_b32_e32 v46, 2, v46
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v46, 1, v46
		v_lshl_add_u32 v53, v46, 12, v53
		v_lshl_add_u32 v46, v54, 1, v46
		v_xor_b32_e32 v46, v46, v45
		v_lshl_add_u32 v46, v46, 4, v53
		v_add_u32_e32 v53, 0xffff8000, v46
		ds_read_b128 v[84:87], v53
		v_add_u32_e32 v53, 0xffff8100, v46
		ds_read_b128 v[88:91], v53
		v_add_u32_e32 v53, 0xffff8800, v46
		ds_read_b128 v[92:95], v53
		v_add_u32_e32 v53, 0xffff8900, v46
		ds_read_b128 v[96:99], v53
		v_add_u32_e32 v9, 0x60, v9
		v_xor_b32_e32 v9, v9, v13
		v_lshrrev_b32_e32 v13, 5, v9
		v_lshrrev_b32_e32 v53, 3, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[100:103]
		ds_write_b128 v5, v[104:107] offset:4096
		ds_write_b128 v7, v[108:111] offset:8192
		ds_write_b128 v0, v[112:115] offset:12288
		v_and_b32_e32 v53, 1, v53
		v_lshlrev_b32_e32 v54, 13, v53
		v_lshl_add_u32 v13, v13, 14, v54
		v_lshrrev_b32_e32 v9, 2, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v9, 1, v9
		v_lshl_add_u32 v13, v9, 12, v13
		v_lshl_add_u32 v9, v53, 1, v9
		v_xor_b32_e32 v9, v9, v45
		v_lshl_add_u32 v9, v9, 4, v13
		v_add_u32_e32 v13, 0xffff4000, v9
		ds_read_b128 v[100:103], v13
		v_add_u32_e32 v13, 0xffff4100, v9
		ds_read_b128 v[104:107], v13
		v_add_u32_e32 v13, 0xffff4800, v9
		ds_read_b128 v[108:111], v13
		v_add_u32_e32 v13, 0xffff4900, v9
		ds_read_b128 v[112:115], v13
		s_lshl_b32 s1, s12, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 3, v6
		v_add3_u32 v13, s0, v1, v6
		v_mul_lo_u32 v45, s17, v3
		v_lshlrev_b32_e32 v45, 2, v45
		v_mul_lo_u32 v53, s17, v4
		v_lshlrev_b32_e32 v53, 1, v53
		v_add3_u32 v13, v13, v45, v53
		v_accvgpr_read_b32 v54, a0
		v_lshlrev_b32_e32 v54, 7, v54
		v_add3_u32 v13, v13, v8, v54
		v_add3_u32 v13, v13, v10, v12
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		v_mov_b64_e32 v[120:121], v[56:57]
		v_mov_b64_e32 v[122:123], v[60:61]
		buffer_store_dwordx4 v[120:123], v13, s[8:11], 0 offen
		v_add_u32_e32 v13, 16, v4
		v_lshlrev_b32_e32 v3, 1, v3
		v_xor_b32_e32 v13, v13, v3
		v_bitop3_b32 v13, v47, v52, v13 bitop3:0x96
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add_u32_e32 v55, s0, v13
		v_add3_u32 v55, v55, v8, v54
		v_add3_u32 v55, v55, v10, v12
		v_mov_b64_e32 v[120:121], v[64:65]
		v_mov_b64_e32 v[122:123], v[116:117]
		buffer_store_dwordx4 v[120:123], v55, s[8:11], 0 offen
		v_add_u32_e32 v55, 32, v4
		v_xor_b32_e32 v55, v55, v3
		v_bitop3_b32 v55, v47, v52, v55 bitop3:0x96
		v_mul_lo_u32 v55, s17, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v56, s0, v55
		v_add3_u32 v56, v56, v8, v54
		v_add3_u32 v56, v56, v10, v12
		v_mov_b64_e32 v[120:121], v[58:59]
		v_mov_b64_e32 v[122:123], v[62:63]
		buffer_store_dwordx4 v[120:123], v56, s[8:11], 0 offen
		v_add_u32_e32 v56, 48, v4
		v_xor_b32_e32 v56, v56, v3
		v_bitop3_b32 v56, v47, v52, v56 bitop3:0x96
		v_mul_lo_u32 v56, s17, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s0, v56
		v_add3_u32 v57, v57, v8, v54
		v_add3_u32 v57, v57, v10, v12
		v_mov_b64_e32 v[60:61], v[66:67]
		v_mov_b64_e32 v[62:63], v[118:119]
		buffer_store_dwordx4 v[60:63], v57, s[8:11], 0 offen
		v_add_u32_e32 v57, 64, v4
		v_xor_b32_e32 v57, v57, v3
		v_bitop3_b32 v57, v47, v52, v57 bitop3:0x96
		v_mul_lo_u32 v57, s17, v57
		v_lshlrev_b32_e32 v57, 1, v57
		v_add_u32_e32 v58, s0, v57
		v_add3_u32 v58, v58, v8, v54
		v_add3_u32 v58, v58, v10, v12
		v_mov_b64_e32 v[60:61], v[68:69]
		v_mov_b64_e32 v[62:63], v[72:73]
		buffer_store_dwordx4 v[60:63], v58, s[8:11], 0 offen
		v_add_u32_e32 v58, 0x50, v4
		v_xor_b32_e32 v58, v58, v3
		v_bitop3_b32 v58, v47, v52, v58 bitop3:0x96
		v_mul_lo_u32 v58, s17, v58
		v_lshlrev_b32_e32 v58, 1, v58
		v_add_u32_e32 v59, s0, v58
		v_add3_u32 v59, v59, v8, v54
		v_add3_u32 v59, v59, v10, v12
		v_mov_b64_e32 v[60:61], v[76:77]
		v_mov_b64_e32 v[62:63], v[80:81]
		buffer_store_dwordx4 v[60:63], v59, s[8:11], 0 offen
		v_add_u32_e32 v59, 0x60, v4
		v_xor_b32_e32 v59, v59, v3
		v_bitop3_b32 v59, v47, v52, v59 bitop3:0x96
		v_mul_lo_u32 v59, s17, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add_u32_e32 v60, s0, v59
		v_add3_u32 v60, v60, v8, v54
		v_add3_u32 v60, v60, v10, v12
		v_mov_b64_e32 v[64:65], v[70:71]
		v_mov_b64_e32 v[66:67], v[74:75]
		buffer_store_dwordx4 v[64:67], v60, s[8:11], 0 offen
		v_add_u32_e32 v60, 0x70, v4
		v_xor_b32_e32 v60, v60, v3
		v_bitop3_b32 v60, v47, v52, v60 bitop3:0x96
		v_mul_lo_u32 v60, s17, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_add_u32_e32 v61, s0, v60
		v_add3_u32 v61, v61, v8, v54
		v_add3_u32 v61, v61, v10, v12
		v_mov_b64_e32 v[64:65], v[78:79]
		v_mov_b64_e32 v[66:67], v[82:83]
		buffer_store_dwordx4 v[64:67], v61, s[8:11], 0 offen
		v_add_u32_e32 v61, 0x80, v4
		v_xor_b32_e32 v61, v61, v3
		v_bitop3_b32 v61, v47, v52, v61 bitop3:0x96
		v_mul_lo_u32 v61, s17, v61
		v_lshlrev_b32_e32 v61, 1, v61
		v_add_u32_e32 v62, s0, v61
		v_add3_u32 v62, v62, v8, v54
		v_add3_u32 v62, v62, v10, v12
		v_mov_b64_e32 v[64:65], v[84:85]
		v_mov_b64_e32 v[66:67], v[88:89]
		buffer_store_dwordx4 v[64:67], v62, s[8:11], 0 offen
		v_add_u32_e32 v62, 0x90, v4
		v_xor_b32_e32 v62, v62, v3
		v_bitop3_b32 v62, v47, v52, v62 bitop3:0x96
		v_mul_lo_u32 v62, s17, v62
		v_lshlrev_b32_e32 v62, 1, v62
		v_add_u32_e32 v63, s0, v62
		v_add3_u32 v63, v63, v8, v54
		v_add3_u32 v63, v63, v10, v12
		v_mov_b64_e32 v[64:65], v[92:93]
		v_mov_b64_e32 v[66:67], v[96:97]
		buffer_store_dwordx4 v[64:67], v63, s[8:11], 0 offen
		v_add_u32_e32 v63, 0xa0, v4
		v_xor_b32_e32 v63, v63, v3
		v_bitop3_b32 v63, v47, v52, v63 bitop3:0x96
		v_mul_lo_u32 v63, s17, v63
		v_lshlrev_b32_e32 v63, 1, v63
		v_add_u32_e32 v64, s0, v63
		v_add3_u32 v64, v64, v8, v54
		v_add3_u32 v64, v64, v10, v12
		v_mov_b64_e32 v[68:69], v[86:87]
		v_mov_b64_e32 v[70:71], v[90:91]
		buffer_store_dwordx4 v[68:71], v64, s[8:11], 0 offen
		v_add_u32_e32 v64, 0xb0, v4
		v_xor_b32_e32 v64, v64, v3
		v_bitop3_b32 v64, v47, v52, v64 bitop3:0x96
		v_mul_lo_u32 v64, s17, v64
		v_lshlrev_b32_e32 v64, 1, v64
		v_add_u32_e32 v65, s0, v64
		v_add3_u32 v65, v65, v8, v54
		v_add3_u32 v65, v65, v10, v12
		v_mov_b64_e32 v[68:69], v[94:95]
		v_mov_b64_e32 v[70:71], v[98:99]
		buffer_store_dwordx4 v[68:71], v65, s[8:11], 0 offen
		v_add_u32_e32 v65, 0xc0, v4
		v_xor_b32_e32 v65, v65, v3
		v_bitop3_b32 v65, v47, v52, v65 bitop3:0x96
		v_mul_lo_u32 v65, s17, v65
		v_lshlrev_b32_e32 v65, 1, v65
		v_add_u32_e32 v66, s0, v65
		v_add3_u32 v66, v66, v8, v54
		v_add3_u32 v66, v66, v10, v12
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[68:69], v[100:101]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[70:71], v[104:105]
		buffer_store_dwordx4 v[68:71], v66, s[8:11], 0 offen
		v_add_u32_e32 v66, 0xd0, v4
		v_xor_b32_e32 v66, v66, v3
		v_bitop3_b32 v66, v47, v52, v66 bitop3:0x96
		v_mul_lo_u32 v66, s17, v66
		v_lshlrev_b32_e32 v66, 1, v66
		v_add_u32_e32 v67, s0, v66
		v_add3_u32 v67, v67, v8, v54
		v_add3_u32 v67, v67, v10, v12
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[68:69], v[108:109]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[70:71], v[112:113]
		buffer_store_dwordx4 v[68:71], v67, s[8:11], 0 offen
		v_add_u32_e32 v67, 0xe0, v4
		v_xor_b32_e32 v67, v67, v3
		v_bitop3_b32 v67, v47, v52, v67 bitop3:0x96
		v_mul_lo_u32 v67, s17, v67
		v_lshlrev_b32_e32 v67, 1, v67
		v_add_u32_e32 v68, s0, v67
		v_add3_u32 v68, v68, v8, v54
		v_add3_u32 v68, v68, v10, v12
		v_mov_b64_e32 v[72:73], v[102:103]
		v_mov_b64_e32 v[74:75], v[106:107]
		buffer_store_dwordx4 v[72:75], v68, s[8:11], 0 offen
		v_add_u32_e32 v4, 0xf0, v4
		v_xor_b32_e32 v3, v4, v3
		v_bitop3_b32 v3, v47, v52, v3 bitop3:0x96
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add_u32_e32 v4, s0, v3
		v_add3_u32 v4, v4, v8, v54
		v_add3_u32 v4, v4, v10, v12
		v_mov_b64_e32 v[68:69], v[110:111]
		v_mov_b64_e32 v[70:71], v[114:115]
		buffer_store_dwordx4 v[68:71], v4, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[44:47], a[68:71], v[204:207], v26, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[52:55], a[68:71], v[208:211], v26, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[52:55], a[76:79], v[224:227], v26, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[44:47], a[76:79], v[220:223], v26, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[48:51], a[72:75], v[204:207], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], a[72:75], v[208:211], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[252:255], v[224:227], v26, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[48:51], v[252:255], v[220:223], v26, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], a[68:71], v[212:215], v27, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[68:71], v[216:219], v27, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[76:79], v[232:235], v27, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], a[76:79], v[228:231], v27, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], a[72:75], v[212:215], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v68, v204, v205
		v_cvt_pk_bf16_f32 v69, v206, v207
		v_cvt_pk_bf16_f32 v72, v208, v209
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[72:75], v[216:219], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v73, v210, v211
		v_cvt_pk_bf16_f32 v70, v220, v221
		v_cvt_pk_bf16_f32 v71, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[252:255], v[232:235], v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v76, v212, v213
		v_cvt_pk_bf16_f32 v77, v214, v215
		v_cvt_pk_bf16_f32 v74, v224, v225
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[252:255], v[228:231], v27, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v80, v216, v217
		v_cvt_pk_bf16_f32 v81, v218, v219
		v_cvt_pk_bf16_f32 v75, v226, v227
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[16:19], v[240:243], v27, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v82, v232, v233
		v_cvt_pk_bf16_f32 v83, v234, v235
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[36:39], v[16:19], v[244:247], v27, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], v[20:23], a[112:115], v27, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v78, v228, v229
		v_cvt_pk_bf16_f32 v79, v230, v231
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[28:31], v[20:23], v[248:251], v27, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[4:7], v[240:243], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[4:7], v[244:247], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[8:11], a[112:115], v27, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[8:11], v[248:251], v27, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[44:47], v[16:19], v[236:239], v26, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[52:55], v[16:19], a[100:103], v26, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[52:55], v[20:23], a[108:111], v26, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[44:47], v[20:23], a[104:107], v26, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[48:51], a[4:7], v[236:239], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v16, v240, v241
		v_cvt_pk_bf16_f32 v17, v242, v243
		v_cvt_pk_bf16_f32 v20, v244, v245
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[48:51], a[4:7], a[100:103], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v21, v246, v247
		v_cvt_pk_bf16_f32 v18, v248, v249
		v_cvt_pk_bf16_f32 v19, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[48:51], a[8:11], a[108:111], v26, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v84, v236, v237
		v_cvt_pk_bf16_f32 v85, v238, v239
		v_accvgpr_read_b32 v4, a112
		v_accvgpr_read_b32 v14, a113
		v_cvt_pk_bf16_f32 v22, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[48:51], a[8:11], a[104:107], v26, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a100
		v_accvgpr_read_b32 v14, a101
		v_cvt_pk_bf16_f32 v88, v4, v14
		v_accvgpr_read_b32 v4, a102
		v_accvgpr_read_b32 v14, a103
		v_cvt_pk_bf16_f32 v89, v4, v14
		v_accvgpr_read_b32 v4, a114
		v_accvgpr_read_b32 v14, a115
		v_cvt_pk_bf16_f32 v23, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[44:47], a[12:15], a[116:119], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a108
		v_accvgpr_read_b32 v14, a109
		v_cvt_pk_bf16_f32 v90, v4, v14
		v_accvgpr_read_b32 v4, a110
		v_accvgpr_read_b32 v14, a111
		v_cvt_pk_bf16_f32 v91, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[52:55], a[12:15], a[120:123], v26, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[20:23], a[136:139], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a104
		v_accvgpr_read_b32 v14, a105
		v_cvt_pk_bf16_f32 v86, v4, v14
		v_accvgpr_read_b32 v4, a106
		v_accvgpr_read_b32 v14, a107
		v_cvt_pk_bf16_f32 v87, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], a[20:23], a[132:135], v26, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[48:51], a[16:19], a[116:119], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], a[16:19], a[120:123], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], a[24:27], a[136:139], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[48:51], a[24:27], a[132:135], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], a[12:15], a[124:127], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[12:15], a[128:131], v27, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[20:23], a[144:147], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], a[20:23], a[140:143], v27, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], a[16:19], a[124:127], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a116
		v_accvgpr_read_b32 v14, a117
		v_cvt_pk_bf16_f32 v92, v4, v14
		v_accvgpr_read_b32 v4, a118
		v_accvgpr_read_b32 v14, a119
		v_cvt_pk_bf16_f32 v93, v4, v14
		v_accvgpr_read_b32 v4, a120
		v_accvgpr_read_b32 v14, a121
		v_cvt_pk_bf16_f32 v96, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[16:19], a[128:131], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a122
		v_accvgpr_read_b32 v14, a123
		v_cvt_pk_bf16_f32 v97, v4, v14
		v_accvgpr_read_b32 v4, a132
		v_accvgpr_read_b32 v14, a133
		v_cvt_pk_bf16_f32 v94, v4, v14
		v_accvgpr_read_b32 v4, a134
		v_accvgpr_read_b32 v14, a135
		v_cvt_pk_bf16_f32 v95, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[24:27], a[144:147], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a124
		v_accvgpr_read_b32 v14, a125
		v_cvt_pk_bf16_f32 v100, v4, v14
		v_accvgpr_read_b32 v4, a126
		v_accvgpr_read_b32 v14, a127
		v_cvt_pk_bf16_f32 v101, v4, v14
		v_accvgpr_read_b32 v4, a136
		v_accvgpr_read_b32 v14, a137
		v_cvt_pk_bf16_f32 v98, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], a[24:27], a[140:143], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a128
		v_accvgpr_read_b32 v14, a129
		v_cvt_pk_bf16_f32 v104, v4, v14
		v_accvgpr_read_b32 v4, a130
		v_accvgpr_read_b32 v14, a131
		v_cvt_pk_bf16_f32 v105, v4, v14
		v_accvgpr_read_b32 v4, a138
		v_accvgpr_read_b32 v14, a139
		v_cvt_pk_bf16_f32 v99, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], a[28:31], a[156:159], v27, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a144
		v_accvgpr_read_b32 v14, a145
		v_cvt_pk_bf16_f32 v106, v4, v14
		v_accvgpr_read_b32 v4, a146
		v_accvgpr_read_b32 v14, a147
		v_cvt_pk_bf16_f32 v107, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[28:31], a[160:163], v27, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], a[36:39], a[176:179], v27, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a140
		v_accvgpr_read_b32 v14, a141
		v_cvt_pk_bf16_f32 v102, v4, v14
		v_accvgpr_read_b32 v4, a142
		v_accvgpr_read_b32 v14, a143
		v_cvt_pk_bf16_f32 v103, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], a[36:39], a[172:175], v27, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], a[32:35], a[156:159], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[32:35], a[160:163], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[40:43], a[40:43], a[176:179], v27, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], a[40:43], a[172:175], v27, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[44:47], a[28:31], a[148:151], v26, v25 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[52:55], a[28:31], a[152:155], v26, v25 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], a[36:39], a[168:171], v26, v25 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[44:47], a[36:39], a[164:167], v26, v25 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], a[32:35], a[148:151], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a156
		v_accvgpr_read_b32 v14, a157
		v_cvt_pk_bf16_f32 v28, v4, v14
		v_accvgpr_read_b32 v4, a158
		v_accvgpr_read_b32 v14, a159
		v_cvt_pk_bf16_f32 v29, v4, v14
		v_accvgpr_read_b32 v4, a160
		v_accvgpr_read_b32 v14, a161
		v_cvt_pk_bf16_f32 v32, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], a[32:35], a[152:155], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a162
		v_accvgpr_read_b32 v14, a163
		v_cvt_pk_bf16_f32 v33, v4, v14
		v_accvgpr_read_b32 v4, a172
		v_accvgpr_read_b32 v14, a173
		v_cvt_pk_bf16_f32 v30, v4, v14
		v_accvgpr_read_b32 v4, a174
		v_accvgpr_read_b32 v14, a175
		v_cvt_pk_bf16_f32 v31, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], a[40:43], a[168:171], v26, v25 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a148
		v_accvgpr_read_b32 v14, a149
		v_cvt_pk_bf16_f32 v36, v4, v14
		v_accvgpr_read_b32 v4, a150
		v_accvgpr_read_b32 v14, a151
		v_cvt_pk_bf16_f32 v37, v4, v14
		v_accvgpr_read_b32 v4, a176
		v_accvgpr_read_b32 v14, a177
		v_cvt_pk_bf16_f32 v34, v4, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[48:51], a[40:43], a[164:167], v26, v25 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v4, a152
		v_accvgpr_read_b32 v14, a153
		v_cvt_pk_bf16_f32 v24, v4, v14
		v_accvgpr_read_b32 v4, a154
		v_accvgpr_read_b32 v14, a155
		v_cvt_pk_bf16_f32 v25, v4, v14
		v_accvgpr_read_b32 v4, a178
		v_accvgpr_read_b32 v14, a179
		v_cvt_pk_bf16_f32 v35, v4, v14
		s_barrier
		v_accvgpr_read_b32 v4, a168
		v_accvgpr_read_b32 v14, a169
		v_cvt_pk_bf16_f32 v26, v4, v14
		v_accvgpr_read_b32 v4, a170
		v_accvgpr_read_b32 v14, a171
		v_cvt_pk_bf16_f32 v27, v4, v14
		ds_write_b128 v2, v[68:71] offset:16384
		ds_write_b128 v5, v[72:75] offset:20480
		v_accvgpr_read_b32 v4, a164
		v_accvgpr_read_b32 v14, a165
		v_cvt_pk_bf16_f32 v38, v4, v14
		ds_write_b128 v7, v[76:79] offset:24576
		ds_write_b128 v0, v[80:83] offset:28672
		v_accvgpr_read_b32 v4, a166
		v_accvgpr_read_b32 v14, a167
		v_cvt_pk_bf16_f32 v39, v4, v14
		v_add_u32_e32 v4, 0xffffc000, v46
		v_add_u32_e32 v14, 0xffffc100, v46
		v_add_u32_e32 v15, 0xffffc800, v46
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[40:43], v11 offset:16384
		ds_read_b128 v[48:51], v11 offset:16640
		ds_read_b128 v[68:71], v11 offset:18432
		ds_read_b128 v[72:75], v11 offset:18688
		v_add_u32_e32 v11, 0xffffc900, v46
		v_add_u32_e32 v46, 0xffff8000, v9
		v_add_u32_e32 v47, 0xffff8100, v9
		v_add_u32_e32 v52, 0xffff8800, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[84:87] offset:16384
		ds_write_b128 v5, v[88:91] offset:20480
		ds_write_b128 v7, v[16:19] offset:24576
		ds_write_b128 v0, v[20:23] offset:28672
		v_add_u32_e32 v9, 0xffff8900, v9
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v1, s0, v1, v6
		v_add3_u32 v1, v1, v45, v53
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v44
		ds_read_b128 v[20:23], v44 offset:256
		ds_read_b128 v[76:79], v44 offset:2048
		ds_read_b128 v[80:83], v44 offset:2304
		v_add3_u32 v1, v1, v8, v54
		v_add3_u32 v1, v1, v10, v12
		v_mov_b64_e32 v[84:85], v[40:41]
		v_mov_b64_e32 v[86:87], v[48:49]
		buffer_store_dwordx4 v[84:87], v1, s[8:11], 0 offen
		v_add3_u32 v1, v8, v54, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[92:95] offset:16384
		ds_write_b128 v5, v[96:99] offset:20480
		ds_write_b128 v7, v[100:103] offset:24576
		ds_write_b128 v0, v[104:107] offset:28672
		v_add_u32_e32 v1, v1, v12
		v_add3_u32 v6, v13, v1, s0
		v_mov_b64_e32 v[84:85], v[68:69]
		v_mov_b64_e32 v[86:87], v[72:73]
		buffer_store_dwordx4 v[84:87], v6, s[8:11], 0 offen
		v_add3_u32 v6, v55, v1, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[84:87], v4
		ds_read_b128 v[88:91], v14
		ds_read_b128 v[92:95], v15
		ds_read_b128 v[96:99], v11
		v_mov_b64_e32 v[100:101], v[42:43]
		v_mov_b64_e32 v[102:103], v[50:51]
		buffer_store_dwordx4 v[100:103], v6, s[8:11], 0 offen
		v_add3_u32 v1, v56, v1, s0
		v_mov_b64_e32 v[40:41], v[70:71]
		v_mov_b64_e32 v[42:43], v[74:75]
		buffer_store_dwordx4 v[40:43], v1, s[8:11], 0 offen
		v_add3_u32 v1, v8, v54, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[36:39] offset:16384
		ds_write_b128 v5, v[24:27] offset:20480
		ds_write_b128 v7, v[28:31] offset:24576
		ds_write_b128 v0, v[32:35] offset:28672
		v_add_u32_e32 v0, v1, v12
		v_add3_u32 v1, v57, v0, s0
		v_mov_b64_e32 v[4:5], v[16:17]
		v_mov_b64_e32 v[6:7], v[20:21]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		v_add3_u32 v1, v58, v0, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[4:7], v46
		ds_read_b128 v[24:27], v47
		ds_read_b128 v[28:31], v52
		ds_read_b128 v[32:35], v9
		v_mov_b64_e32 v[36:37], v[76:77]
		v_mov_b64_e32 v[38:39], v[80:81]
		buffer_store_dwordx4 v[36:39], v1, s[8:11], 0 offen
		v_add3_u32 v0, v59, v0, s0
		s_nop 0
		v_mov_b64_e32 v[36:37], v[18:19]
		v_mov_b64_e32 v[38:39], v[22:23]
		buffer_store_dwordx4 v[36:39], v0, s[8:11], 0 offen
		v_add3_u32 v0, v8, v54, v10
		v_add_u32_e32 v0, v0, v12
		v_add3_u32 v1, v60, v0, s0
		v_mov_b64_e32 v[16:17], v[78:79]
		v_mov_b64_e32 v[18:19], v[82:83]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v1, v61, v0, s0
		s_nop 0
		v_mov_b64_e32 v[16:17], v[84:85]
		v_mov_b64_e32 v[18:19], v[88:89]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v0, v62, v0, s0
		s_nop 0
		v_mov_b64_e32 v[16:17], v[92:93]
		v_mov_b64_e32 v[18:19], v[96:97]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v8, v54, v10
		v_add_u32_e32 v0, v0, v12
		v_add3_u32 v1, v63, v0, s0
		v_mov_b64_e32 v[16:17], v[86:87]
		v_mov_b64_e32 v[18:19], v[90:91]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v1, v64, v0, s0
		s_nop 0
		v_mov_b64_e32 v[16:17], v[94:95]
		v_mov_b64_e32 v[18:19], v[98:99]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		v_add3_u32 v0, v65, v0, s0
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mov_b64_e32 v[16:17], v[4:5]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[18:19], v[24:25]
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v8, v54, v10
		v_add_u32_e32 v0, v0, v12
		v_add3_u32 v1, v66, v0, s0
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[8:9], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[10:11], v[32:33]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v1, v67, v0, s0
		s_nop 0
		v_mov_b64_e32 v[8:9], v[6:7]
		v_mov_b64_e32 v[10:11], v[26:27]
		buffer_store_dwordx4 v[8:11], v1, s[8:11], 0 offen
		v_add3_u32 v0, v3, v0, s0
		v_mov_b64_e32 v[4:5], v[30:31]
		v_mov_b64_e32 v[6:7], v[34:35]
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen
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
		.amdhsa_next_free_vgpr 436
		.amdhsa_next_free_sgpr 46
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
	.set .L_a4w4_kernel.num_agpr, 180
	.set .L_a4w4_kernel.numbered_sgpr, 46
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
    .group_segment_fixed_size: 138144
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     436
    .agpr_count:     180
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 101
    wave.regalloc.agpr.dwords: 391
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
