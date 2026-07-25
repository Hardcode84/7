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
		s_mul_i32 s22, 0x420, s21
		s_mov_b32 m0, s22
		v_lshrrev_b32_e32 v1, 6, v0
		v_mul_lo_u32 v2, s14, v1
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v4, 1, v3
		v_mul_lo_u32 v5, s14, v4
		v_lshl_add_u32 v2, v5, 6, v2
		v_lshrrev_b32_e32 v5, 4, v0
		v_accvgpr_write_b32 a0, v5
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v5, 1, v5
		v_mul_lo_u32 v6, s14, v5
		v_lshl_add_u32 v2, v6, 5, v2
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v7, s14, v6
		v_lshlrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v8, 1, v0
		v_lshlrev_b32_e32 v9, 4, v8
		v_add3_u32 v2, v2, v7, v9
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v10, 6, v7
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v12, 5, v11
		v_add3_u32 v2, v2, v10, v12
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s23, s14, 2
		v_add_u32_e32 v13, s23, v2
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_mov_b32 s30, -1
		s_mov_b32 s31, -1
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s32, s14, 3
		v_add_u32_e32 v14, s32, v2
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_mul_i32 s16, s16, s15
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s33, 12, s14
		v_add_u32_e32 v15, s33, v2
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		v_mul_lo_u32 v16, s15, v5
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s34, s14, 7
		v_add_u32_e32 v17, s34, v2
		s_mul_i32 s35, 0x84, s14
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_add_u32_e32 v18, s35, v2
		s_add_i32 m0, m0, 0x1080
		v_mul_lo_u32 v19, s15, v4
		s_mul_i32 s36, 0x88, s14
		v_add_u32_e32 v20, s36, v2
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_mul_lo_u32 v21, s15, v1
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s14, 0x8c, s14
		v_add_u32_e32 v22, s14, v2
		v_lshl_add_u32 v19, v19, 6, v21
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		v_lshl_add_u32 v16, v16, 5, v19
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s40, s4, s16
		s_addc_u32 s41, s5, 0
		v_mul_lo_u32 v19, s15, v6
		v_lshlrev_b32_e32 v19, 4, v19
		v_add3_u32 v16, v16, v19, v9
		v_add3_u32 v16, v16, v10, v12
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_mul_i32 s37, 12, s15
		s_add_i32 m0, m0, 0x9460
		s_lshl_b32 s38, s15, 2
		v_add_u32_e32 v19, s38, v16
		v_add_u32_e32 v21, s37, v16
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v23, s18, v3
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s39, s15, 3
		v_add_u32_e32 v24, s39, v16
		v_lshlrev_b32_e32 v25, 3, v8
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v26, 7, v5
		s_add_i32 m0, m0, 0x1080
		v_lshlrev_b32_e32 v27, 6, v6
		v_lshlrev_b32_e32 v28, 5, v7
		v_lshlrev_b32_e32 v29, 4, v11
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		v_mul_lo_u32 v3, s19, v3
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s20, s20, 8
		s_add_i32 s1, s1, s20
		buffer_load_dwordx4 v21, s[40:43], 0 offen lds
		v_add3_u32 v30, s1, v23, v25
		v_add3_u32 v30, v30, v26, v27
		v_add3_u32 v30, v30, v28, v29
		s_mov_b32 s44, s8
		s_mov_b32 s45, s9
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dwordx2 v[32:33], v30, s[44:47], 0 offen
		s_lshl_b32 s20, s0, 8
		v_lshlrev_b32_e32 v8, 2, v8
		v_add3_u32 v31, s20, v3, v8
		v_lshlrev_b32_e32 v34, 6, v5
		v_lshlrev_b32_e32 v35, 5, v6
		v_add3_u32 v31, v31, v34, v35
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshlrev_b32_e32 v36, 3, v11
		v_add3_u32 v31, v31, v7, v36
		s_mov_b32 s48, s10
		s_mov_b32 s49, s11
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		buffer_load_dword v37, v31, s[48:51], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_lshl_b32 s52, s15, 7
		v_add_u32_e32 v38, s52, v16
		buffer_load_dwordx4 v38, s[40:43], 0 offen lds
		s_mul_i32 s53, 0x84, s15
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v39, s53, v16
		s_mul_i32 s54, 0x88, s15
		v_add_u32_e32 v40, s54, v16
		buffer_load_dwordx4 v39, s[40:43], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v41, s15, v16
		v_add_u32_e32 v42, 0x80, v2
		v_add_u32_e32 v43, 0x80, v2
		buffer_load_dwordx4 v40, s[40:43], 0 offen lds
		v_add_u32_e32 v44, s32, v43
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s32, s20, 0x80
		v_add3_u32 v45, s32, v3, v8
		v_add3_u32 v45, v45, v34, v35
		buffer_load_dwordx4 v41, s[40:43], 0 offen lds
		v_add3_u32 v45, v45, v7, v36
		buffer_load_dword v46, v45, s[48:51], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s23, s23, 0x80
		v_add_u32_e32 v47, s23, v2
		buffer_load_dwordx4 v42, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v48, 7, v0
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v49, s33, v43
		s_mul_i32 s23, s19, 16
		v_add_u32_e32 v43, s34, v43
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		v_add_u32_e32 v50, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v51, s35, v50
		s_mul_i32 s33, s18, 16
		v_add_u32_e32 v52, s36, v50
		buffer_load_dwordx4 v44, s[24:27], 0 offen lds
		v_add_u32_e32 v50, s14, v50
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v53, 0x80, v16
		v_add_u32_e32 v54, 0x80, v16
		v_add_u32_e32 v55, s38, v54
		v_add_u32_e32 v56, s39, v54
		v_add_u32_e32 v54, s37, v54
		v_add_u32_e32 v57, 0x80, v16
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		v_add_u32_e32 v58, s53, v57
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v59, s54, v57
		v_add_u32_e32 v57, s15, v57
		v_lshlrev_b32_e32 v60, 7, v48
		buffer_load_dwordx4 v43, s[24:27], 0 offen lds
		v_and_b32_e32 v61, 63, v0
		s_add_i32 m0, m0, 0x1080
		v_lshrrev_b32_e32 v62, 4, v61
		v_accvgpr_write_b32 a1, v62
		v_accvgpr_read_b32 v62, a1
		v_lshlrev_b32_e32 v62, 4, v62
		v_and_b32_e32 v63, 15, v61
		buffer_load_dwordx4 v51, s[24:27], 0 offen lds
		v_mov_b32_e32 v64, 0x420
		v_mul_lo_u32 v64, v64, v63
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s16, 0x100
		v_add3_u32 v60, v60, v62, v64
		buffer_load_dwordx4 v52, s[24:27], 0 offen lds
		v_add_u32_e32 v62, 0x10000, v62
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s15, s52, 0x80
		v_add_u32_e32 v63, s15, v16
		v_and_b32_e32 v1, 1, v1
		v_accvgpr_write_b32 a2, v1
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v1, a2
		v_lshlrev_b32_e32 v1, 7, v1
		s_add_i32 m0, m0, 0x5260
		v_add3_u32 v1, v62, v1, v64
		v_lshlrev_b32_e32 v62, 3, v0
		v_add_u32_e32 v62, 0x20000, v62
		buffer_load_dwordx4 v53, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v64, 2, v0
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s15, s19, 3
		v_add_u32_e32 v64, 0x20000, v64
		v_lshlrev_b32_e32 v48, 4, v48
		buffer_load_dwordx4 v55, s[40:43], 0 offen lds
		v_add_u32_e32 v48, 0x20000, v48
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s16, s18, 3
		v_add_u32_e32 v48, v48, v25
		v_lshl_add_u32 v48, v4, 9, v48
		v_lshl_add_u32 v5, v5, 8, v48
		v_add3_u32 v5, v5, v27, v28
		v_lshl_add_u32 v5, v11, 10, v5
		buffer_load_dwordx4 v56, s[40:43], 0 offen lds
		v_add_u32_e32 v48, 0x20000, v25
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s1, s16
		v_add3_u32 v23, s1, v23, v25
		v_add3_u32 v23, v23, v26, v27
		buffer_load_dwordx4 v54, s[40:43], 0 offen lds
		v_add3_u32 v23, v23, v28, v29
		buffer_load_dwordx2 v[66:67], v23, s[44:47], 0 offen
		s_add_i32 s1, s20, s15
		v_add3_u32 v25, s1, v3, v8
		v_add3_u32 v25, v25, v34, v35
		v_add3_u32 v25, v25, v7, v36
		buffer_load_dword v29, v25, s[48:51], 0 offen
		s_add_i32 m0, m0, 0x5260
		v_accvgpr_read_b32 v65, a2
		v_lshl_add_u32 v48, v65, 4, v48
		buffer_load_dwordx4 v63, s[40:43], 0 offen lds
		v_lshlrev_b32_e32 v65, 8, v4
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s1, s13, 0x100
		v_add3_u32 v26, v48, v65, v26
		v_add3_u32 v26, v26, v27, v28
		buffer_load_dwordx4 v58, s[40:43], 0 offen lds
		v_lshl_add_u32 v11, v11, 9, v26
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s32, s15
		v_add3_u32 v3, s13, v3, v8
		v_add3_u32 v3, v3, v34, v35
		buffer_load_dwordx4 v59, s[40:43], 0 offen lds
		v_add3_u32 v3, v3, v7, v36
		s_add_i32 m0, m0, 0x1080
		s_mov_b32 s13, 0
		buffer_load_dwordx4 v57, s[40:43], 0 offen lds
		buffer_load_dword v7, v3, s[48:51], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 a[4:7], v60
		ds_read_b128 a[8:11], v60 offset:64
		ds_read_b128 a[12:15], v60 offset:256
		ds_read_b128 a[16:19], v60 offset:320
		ds_read_b128 a[20:23], v60 offset:512
		ds_read_b128 a[24:27], v60 offset:576
		ds_read_b128 a[28:31], v60 offset:768
		ds_read_b128 a[32:35], v60 offset:832
		ds_read_b128 a[36:39], v60 offset:16896
		ds_read_b128 a[40:43], v60 offset:16960
		ds_read_b128 a[44:47], v60 offset:17152
		ds_read_b128 a[48:51], v60 offset:17216
		ds_read_b128 a[52:55], v60 offset:17408
		ds_read_b128 a[56:59], v60 offset:17472
		ds_read_b128 a[60:63], v60 offset:17664
		ds_read_b128 a[64:67], v60 offset:17728
		ds_read_b128 a[68:71], v1 offset:2016
		ds_read_b128 a[72:75], v1 offset:2080
		ds_read_b128 a[76:79], v1 offset:2272
		ds_read_b128 a[80:83], v1 offset:2336
		ds_read_b128 a[84:87], v1 offset:2528
		ds_read_b128 a[88:91], v1 offset:2592
		ds_read_b128 a[92:95], v1 offset:2784
		ds_read_b128 a[96:99], v1 offset:2848
		s_waitcnt vmcnt(25)
		ds_write_b64 v62, v[32:33] offset:4000
		s_waitcnt vmcnt(24)
		ds_write_b32 v64, v37 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[26:27], v5 offset:4000
		ds_read_b64_tr_b8 v[32:33], v5 offset:4128
		ds_read_b64_tr_b8 v[34:35], v11 offset:6048
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[56:57], s[28:29]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_0
		s_barrier
.L_a4w4_kernel.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		s_setprio 0
		s_mov_b32 s15, s33
		s_mov_b32 s16, s23
		s_add_u32 s36, s2, s1
		s_addc_u32 s37, s3, 0
		s_add_u32 s40, s4, s14
		s_addc_u32 s41, s5, 0
		s_add_u32 s44, s8, s15
		s_addc_u32 s45, s9, 0
		s_add_u32 s48, s10, s16
		s_addc_u32 s49, s11, 0
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
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
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a100, v36
		v_accvgpr_write_b32 a101, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a102, v36
		v_accvgpr_write_b32 a103, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a104, v36
		v_accvgpr_write_b32 a105, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a106, v36
		v_accvgpr_write_b32 a107, v37
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a108, v36
		v_accvgpr_write_b32 a109, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a110, v36
		v_accvgpr_write_b32 a111, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a112, v36
		v_accvgpr_write_b32 a113, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a114, v36
		v_accvgpr_write_b32 a115, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a116, v36
		v_accvgpr_write_b32 a117, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a118, v36
		v_accvgpr_write_b32 a119, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a120, v36
		v_accvgpr_write_b32 a121, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a122, v36
		v_accvgpr_write_b32 a123, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a124, v36
		v_accvgpr_write_b32 a125, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a126, v36
		v_accvgpr_write_b32 a127, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a128, v36
		v_accvgpr_write_b32 a129, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a130, v36
		v_accvgpr_write_b32 a131, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a132, v36
		v_accvgpr_write_b32 a133, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a134, v36
		v_accvgpr_write_b32 a135, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a136, v36
		v_accvgpr_write_b32 a137, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a138, v36
		v_accvgpr_write_b32 a139, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a140, v36
		v_accvgpr_write_b32 a141, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a142, v36
		v_accvgpr_write_b32 a143, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a144, v36
		v_accvgpr_write_b32 a145, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a146, v36
		v_accvgpr_write_b32 a147, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a148, v36
		v_accvgpr_write_b32 a149, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a150, v36
		v_accvgpr_write_b32 a151, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a152, v36
		v_accvgpr_write_b32 a153, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a154, v36
		v_accvgpr_write_b32 a155, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a156, v36
		v_accvgpr_write_b32 a157, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a158, v36
		v_accvgpr_write_b32 a159, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a160, v36
		v_accvgpr_write_b32 a161, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a162, v36
		v_accvgpr_write_b32 a163, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a164, v36
		v_accvgpr_write_b32 a165, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a166, v36
		v_accvgpr_write_b32 a167, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a168, v36
		v_accvgpr_write_b32 a169, v37
		v_mov_b64_e32 v[36:37], 0
		v_accvgpr_write_b32 a170, v36
		v_accvgpr_write_b32 a171, v37
.L_a4w4_kernel.loop_head_0:
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v34, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v34, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v34, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v34, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v35, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v35, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v35, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v35, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v35, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v35, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v35, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v35, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v34, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v34, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v34, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v34, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v35, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v35, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v35, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v35, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v35, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v35, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v35, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v35, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v34, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v34, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v34, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v34, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(20)
		s_barrier
		s_waitcnt vmcnt(1)
		ds_read_b128 a[68:71], v1 offset:35776
		ds_read_b128 a[72:75], v1 offset:35840
		ds_read_b128 a[76:79], v1 offset:36032
		ds_read_b128 a[80:83], v1 offset:36096
		ds_read_b128 a[84:87], v1 offset:36288
		ds_read_b128 a[88:91], v1 offset:36352
		ds_read_b128 a[92:95], v1 offset:36544
		ds_read_b128 v[252:255], v1 offset:36608
		s_barrier
		ds_write_b32 v64, v46 offset:6048
		s_add_u32 s36, s2, s1
		s_addc_u32 s37, s3, 0
		s_mov_b32 m0, s22
		s_add_u32 s40, s4, s14
		s_addc_u32 s41, s5, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v2, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[34:35], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_add_u32 s48, s10, s16
		s_addc_u32 s49, s11, 0
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_u32 s44, s8, s15
		s_addc_u32 s45, s9, 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9460
		s_nop 0
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v24, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v21, s[40:43], 0 offen lds
		buffer_load_dwordx2 v[36:37], v30, s[44:47], 0 offen
		buffer_load_dword v8, v31, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v34, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v34, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v34, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v34, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v35, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v35, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v35, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v35, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v35, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v35, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v35, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v35, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[24:27], v[240:243], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[32:35], v[248:251], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v34, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v34, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v34, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v34, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[40:43], a[108:111], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[40:43], a[112:115], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[48:51], a[128:131], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[48:51], a[124:127], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v35, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v35, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v35, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v35, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[40:43], a[116:119], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[40:43], a[120:123], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[48:51], a[136:139], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[48:51], a[132:135], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v35, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v35, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v35, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v35, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[56:59], a[148:151], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[56:59], a[152:155], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[64:67], a[168:171], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[64:67], a[164:167], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v34, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v34, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v34, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v34, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[56:59], a[140:143], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[56:59], a[144:147], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[64:67], a[160:163], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[64:67], a[156:159], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[4:7], v60 offset:33792
		ds_read_b128 a[8:11], v60 offset:33856
		ds_read_b128 a[12:15], v60 offset:34048
		ds_read_b128 a[16:19], v60 offset:34112
		ds_read_b128 a[20:23], v60 offset:34304
		ds_read_b128 a[24:27], v60 offset:34368
		ds_read_b128 a[28:31], v60 offset:34560
		ds_read_b128 a[32:35], v60 offset:34624
		ds_read_b128 a[36:39], v60 offset:50688
		ds_read_b128 a[40:43], v60 offset:50752
		ds_read_b128 a[44:47], v60 offset:50944
		ds_read_b128 a[48:51], v60 offset:51008
		ds_read_b128 a[52:55], v60 offset:51200
		ds_read_b128 a[56:59], v60 offset:51264
		ds_read_b128 a[60:63], v60 offset:51456
		ds_read_b128 a[64:67], v60 offset:51520
		ds_read_b128 a[68:71], v1 offset:18912
		ds_read_b128 a[72:75], v1 offset:18976
		ds_read_b128 a[76:79], v1 offset:19168
		ds_read_b128 a[80:83], v1 offset:19232
		ds_read_b128 a[84:87], v1 offset:19424
		ds_read_b128 a[88:91], v1 offset:19488
		ds_read_b128 v[32:35], v1 offset:19680
		ds_read_b128 a[92:95], v1 offset:19744
		ds_write_b64 v62, v[66:67] offset:4000
		ds_write_b32 v64, v29 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v38, s[40:43], 0 offen lds
		ds_read_b64_tr_b8 v[26:27], v5 offset:4000
		ds_read_b64_tr_b8 v[252:253], v5 offset:4128
		ds_read_b64_tr_b8 v[28:29], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v39, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v40, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v41, s[40:43], 0 offen lds
		buffer_load_dword v46, v45, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v28, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v28, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v28, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v28, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v28, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v28, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v28, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v28, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v29, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], a[4:7], v[80:83], v29, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[32:35], a[12:15], v[96:99], v29, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v29, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v29, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[8:11], v[80:83], v29, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[16:19], v[96:99], v29, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v29, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v29, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], a[20:23], v[112:115], v29, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], a[28:31], v[128:131], v29, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v29, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v29, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[24:27], v[112:115], v29, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[32:35], v[128:131], v29, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v29, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v28, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v28, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v28, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v28, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v28, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v28, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v28, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v28, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v28, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v28, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v28, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v28, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v28, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v28, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v28, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v28, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v29, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], a[36:39], v[144:147], v29, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[32:35], a[44:47], v[160:163], v29, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v29, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v29, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[40:43], v[144:147], v29, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[48:51], v[160:163], v29, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v29, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v29, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], a[52:55], v[176:179], v29, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], a[60:63], v[192:195], v29, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v29, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v29, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[56:59], v[176:179], v29, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[64:67], v[192:195], v29, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v29, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v28, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v28, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v28, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v28, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v28, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v28, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v28, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v28, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_barrier
		ds_read_b128 a[68:71], v1 offset:52672
		ds_read_b128 a[72:75], v1 offset:52736
		ds_read_b128 a[76:79], v1 offset:52928
		ds_read_b128 a[80:83], v1 offset:52992
		ds_read_b128 a[84:87], v1 offset:53184
		ds_read_b128 a[88:91], v1 offset:53248
		ds_read_b128 a[92:95], v1 offset:53440
		ds_read_b128 v[32:35], v1 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v64, v7 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v42, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[254:255], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v47, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v44, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v49, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v43, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v51, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v50, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x5260
		s_nop 0
		buffer_load_dwordx4 v53, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v55, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v56, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v54, s[40:43], 0 offen lds
		buffer_load_dwordx2 v[66:67], v23, s[44:47], 0 offen
		buffer_load_dword v29, v25, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v254, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v254, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v254, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v254, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v254, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v254, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v254, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v254, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v255, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v255, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v255, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v255, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v255, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], a[8:11], v[208:211], v255, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], a[16:19], v[224:227], v255, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v255, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v255, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[92:95], a[20:23], v[240:243], v255, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[92:95], a[28:31], v[248:251], v255, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[84:87], a[28:31], v[244:247], v255, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v255, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[24:27], v[240:243], v255, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[32:35], v[248:251], v255, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[32:35], v[244:247], v255, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v254, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v254, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[76:79], a[28:31], a[104:107], v254, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[68:71], a[28:31], a[100:103], v254, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v254, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v254, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[32:35], a[104:107], v254, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[32:35], a[100:103], v254, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[36:39], a[108:111], v254, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[36:39], a[112:115], v254, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[44:47], a[128:131], v254, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[44:47], a[124:127], v254, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[72:75], a[40:43], a[108:111], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[80:83], a[40:43], a[112:115], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[80:83], a[48:51], a[128:131], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[72:75], a[48:51], a[124:127], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[36:39], a[116:119], v255, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[36:39], a[120:123], v255, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[44:47], a[136:139], v255, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[44:47], a[132:135], v255, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[88:91], a[40:43], a[116:119], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], a[40:43], a[120:123], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], a[48:51], a[136:139], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[88:91], a[48:51], a[132:135], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[52:55], a[148:151], v255, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[52:55], a[152:155], v255, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[92:95], a[60:63], a[168:171], v255, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[60:63], a[164:167], v255, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[88:91], a[56:59], a[148:151], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], a[56:59], a[152:155], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], a[64:67], a[168:171], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[88:91], a[64:67], a[164:167], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[52:55], a[140:143], v254, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[52:55], a[144:147], v254, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[60:63], a[160:163], v254, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[60:63], a[156:159], v254, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[56:59], a[140:143], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], a[56:59], a[144:147], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[64:67], a[160:163], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[72:75], a[64:67], a[156:159], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_setprio 1
		s_waitcnt vmcnt(21)
		s_barrier
		ds_read_b128 a[4:7], v60
		ds_read_b128 a[8:11], v60 offset:64
		ds_read_b128 a[12:15], v60 offset:256
		ds_read_b128 a[16:19], v60 offset:320
		ds_read_b128 a[20:23], v60 offset:512
		ds_read_b128 a[24:27], v60 offset:576
		ds_read_b128 a[28:31], v60 offset:768
		ds_read_b128 a[32:35], v60 offset:832
		ds_read_b128 a[36:39], v60 offset:16896
		ds_read_b128 a[40:43], v60 offset:16960
		ds_read_b128 a[44:47], v60 offset:17152
		ds_read_b128 a[48:51], v60 offset:17216
		ds_read_b128 a[52:55], v60 offset:17408
		ds_read_b128 a[56:59], v60 offset:17472
		ds_read_b128 a[60:63], v60 offset:17664
		ds_read_b128 a[64:67], v60 offset:17728
		ds_read_b128 a[68:71], v1 offset:2016
		ds_read_b128 a[72:75], v1 offset:2080
		ds_read_b128 a[76:79], v1 offset:2272
		ds_read_b128 a[80:83], v1 offset:2336
		ds_read_b128 a[84:87], v1 offset:2528
		ds_read_b128 a[88:91], v1 offset:2592
		ds_read_b128 a[92:95], v1 offset:2784
		ds_read_b128 a[96:99], v1 offset:2848
		s_waitcnt vmcnt(20)
		ds_write_b64 v62, v[36:37] offset:4000
		s_waitcnt vmcnt(19)
		ds_write_b32 v64, v8 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v63, s[40:43], 0 offen lds
		ds_read_b64_tr_b8 v[26:27], v5 offset:4000
		ds_read_b64_tr_b8 v[32:33], v5 offset:4128
		ds_read_b64_tr_b8 v[34:35], v11 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v58, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v59, s[40:43], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v57, s[40:43], 0 offen lds
		buffer_load_dword v7, v3, s[48:51], 0 offen
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s1, s1, 0x100
		s_add_i32 s14, s14, 0x100
		s_add_i32 s15, s15, s33
		s_add_i32 s16, s16, s23
		s_setprio 0
		s_barrier
		s_add_i32 s13, s13, 2
		s_cmp_lt_i32 s13, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[56:57], s[30:31]
		s_cbranch_execz .L_a4w4_kernel.exec_endif_1
		s_barrier
.L_a4w4_kernel.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v34, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v34, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v34, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v34, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v34, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v34, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v35, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v35, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v35, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v35, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v35, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v35, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v35, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v35, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v35, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v35, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v35, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v35, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v34, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v34, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v34, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v34, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v34, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v34, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v35, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v35, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v35, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v35, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v35, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v35, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v35, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v35, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v34, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v34, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v34, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v34, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:35776
		ds_read_b128 v[20:23], v1 offset:35840
		ds_read_b128 v[36:39], v1 offset:36032
		ds_read_b128 v[40:43], v1 offset:36096
		ds_read_b128 v[48:51], v1 offset:36288
		ds_read_b128 v[52:55], v1 offset:36352
		ds_read_b128 v[56:59], v1 offset:36544
		ds_read_b128 v[252:255], v1 offset:36608
		s_barrier
		ds_write_b32 v64, v46 offset:6048
		v_accvgpr_read_b32 v2, a2
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v3, 2, v4
		v_bitop3_b32 v0, v2, v0, v3 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[14:15], v11 offset:6048
		ds_read_b128 a[68:71], v60 offset:33792
		ds_read_b128 a[72:75], v60 offset:33856
		ds_read_b128 a[76:79], v60 offset:34048
		ds_read_b128 v[44:47], v60 offset:34112
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[16:19], a[4:7], v[196:199], v14, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], a[4:7], v[200:203], v14, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], a[12:15], v[216:219], v14, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[16:19], a[12:15], v[212:215], v14, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], a[8:11], v[196:199], v14, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[8:11], v[200:203], v14, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[16:19], v[216:219], v14, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[20:23], a[16:19], v[212:215], v14, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], a[4:7], v[204:207], v15, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], a[4:7], v[208:211], v15, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], a[12:15], v[224:227], v15, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], a[12:15], v[220:223], v15, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], a[8:11], v[204:207], v15, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v15, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v15, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], a[16:19], v[220:223], v15, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[20:23], v[236:239], v15, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], a[20:23], v[240:243], v15, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[56:59], a[28:31], v[248:251], v15, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[28:31], v[244:247], v15, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[24:27], v[236:239], v15, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[24:27], v[240:243], v15, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[252:255], a[32:35], v[248:251], v15, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[52:55], a[32:35], v[244:247], v15, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[16:19], a[20:23], v[228:231], v14, v27 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[20:23], v[232:235], v14, v27 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[28:31], a[104:107], v14, v27 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[16:19], a[28:31], a[100:103], v14, v27 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[20:23], a[24:27], v[228:231], v14, v27 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[24:27], v[232:235], v14, v27 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[32:35], a[104:107], v14, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], a[32:35], a[100:103], v14, v27 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[16:19], a[36:39], a[108:111], v14, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[36:39], a[112:115], v14, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[44:47], a[128:131], v14, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[16:19], a[44:47], a[124:127], v14, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], a[40:43], a[108:111], v14, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[40:43], a[112:115], v14, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[48:51], a[128:131], v14, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], a[48:51], a[124:127], v14, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[36:39], a[116:119], v15, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[36:39], a[120:123], v15, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[44:47], a[136:139], v15, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[44:47], a[132:135], v15, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[40:43], a[116:119], v15, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[40:43], a[120:123], v15, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[48:51], a[136:139], v15, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[48:51], a[132:135], v15, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[52:55], a[148:151], v15, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[52:55], a[152:155], v15, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[60:63], a[168:171], v15, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[60:63], a[164:167], v15, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[56:59], a[148:151], v15, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[56:59], a[152:155], v15, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[64:67], a[168:171], v15, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[64:67], a[164:167], v15, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[16:19], a[52:55], a[140:143], v14, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[52:55], a[144:147], v14, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[60:63], a[160:163], v14, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[16:19], a[60:63], a[156:159], v14, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], a[56:59], a[140:143], v14, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[56:59], a[144:147], v14, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[64:67], a[160:163], v14, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], a[64:67], a[156:159], v14, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v60 offset:34304
		ds_read_b128 a[4:7], v60 offset:34368
		ds_read_b128 a[8:11], v60 offset:34560
		ds_read_b128 a[12:15], v60 offset:34624
		ds_read_b128 a[16:19], v60 offset:50688
		ds_read_b128 a[20:23], v60 offset:50752
		ds_read_b128 a[24:27], v60 offset:50944
		ds_read_b128 a[28:31], v60 offset:51008
		ds_read_b128 a[32:35], v60 offset:51200
		ds_read_b128 a[36:39], v60 offset:51264
		ds_read_b128 a[40:43], v60 offset:51456
		ds_read_b128 a[44:47], v60 offset:51520
		ds_read_b128 v[20:23], v1 offset:18912
		ds_read_b128 v[24:27], v1 offset:18976
		ds_read_b128 v[32:35], v1 offset:19168
		ds_read_b128 v[36:39], v1 offset:19232
		ds_read_b128 v[40:43], v1 offset:19424
		ds_read_b128 v[48:51], v1 offset:19488
		ds_read_b128 v[52:55], v1 offset:19680
		ds_read_b128 v[56:59], v1 offset:19744
		ds_write_b64 v62, v[66:67] offset:4000
		v_xor_b32_e32 v3, 1, v0
		v_lshlrev_b32_e32 v3, 4, v3
		v_xor_b32_e32 v4, 2, v0
		v_lshlrev_b32_e32 v4, 4, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b32 v64, v29 offset:6048
		ds_read_b64_tr_b8 v[14:15], v5 offset:4000
		ds_read_b64_tr_b8 v[28:29], v5 offset:4128
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshrrev_b32_e32 v5, 3, v61
		v_and_b32_e32 v5, 1, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[30:31], v11 offset:6048
		ds_read_b128 a[48:51], v1 offset:52672
		ds_read_b128 a[52:55], v1 offset:52736
		ds_read_b128 a[56:59], v1 offset:52928
		ds_read_b128 v[252:255], v1 offset:52992
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[20:23], a[68:71], v[68:71], v30, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[32:35], a[68:71], v[72:75], v30, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[32:35], a[76:79], v[88:91], v30, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], a[76:79], v[84:87], v30, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[24:27], a[72:75], v[68:71], v30, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[36:39], a[72:75], v[72:75], v30, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[36:39], v[44:47], v[88:91], v30, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[24:27], v[44:47], v[84:87], v30, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[40:43], a[68:71], v[76:79], v31, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[52:55], a[68:71], v[80:83], v31, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[52:55], a[76:79], v[96:99], v31, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[40:43], a[76:79], v[92:95], v31, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[48:51], a[72:75], v[76:79], v31, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[56:59], a[72:75], v[80:83], v31, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[56:59], v[44:47], v[96:99], v31, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[48:51], v[44:47], v[92:95], v31, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[40:43], v[16:19], v[108:111], v31, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[52:55], v[16:19], v[112:115], v31, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[52:55], a[8:11], v[128:131], v31, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], a[8:11], v[124:127], v31, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[48:51], a[4:7], v[108:111], v31, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[56:59], a[4:7], v[112:115], v31, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[56:59], a[12:15], v[128:131], v31, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[48:51], a[12:15], v[124:127], v31, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[16:19], v[100:103], v30, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[32:35], v[16:19], v[104:107], v30, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], a[8:11], v[120:123], v30, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], a[8:11], v[116:119], v30, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[24:27], a[4:7], v[100:103], v30, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[36:39], a[4:7], v[104:107], v30, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], a[12:15], v[120:123], v30, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], a[12:15], v[116:119], v30, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], a[16:19], v[132:135], v30, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], a[16:19], v[136:139], v30, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], a[24:27], v[152:155], v30, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], a[24:27], v[148:151], v30, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], a[20:23], v[132:135], v30, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], a[20:23], v[136:139], v30, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], a[28:31], v[152:155], v30, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], a[28:31], v[148:151], v30, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], a[16:19], v[140:143], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[52:55], a[16:19], v[144:147], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], a[24:27], v[160:163], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], a[24:27], v[156:159], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], a[20:23], v[140:143], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[56:59], a[20:23], v[144:147], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], a[28:31], v[160:163], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], a[28:31], v[156:159], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], a[32:35], v[172:175], v31, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[52:55], a[32:35], v[176:179], v31, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], a[40:43], v[192:195], v31, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], a[40:43], v[188:191], v31, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], a[36:39], v[172:175], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], a[36:39], v[176:179], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], a[44:47], v[192:195], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], a[44:47], v[188:191], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], a[32:35], v[164:167], v30, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], a[32:35], v[168:171], v30, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], a[40:43], v[184:187], v30, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], a[40:43], v[180:183], v30, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], a[36:39], v[164:167], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[36:39], v[168:171], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[44:47], v[184:187], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], a[44:47], v[180:183], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:53184
		ds_read_b128 v[24:27], v1 offset:53248
		ds_read_b128 v[32:35], v1 offset:53440
		ds_read_b128 v[36:39], v1 offset:53504
		v_cvt_pk_bf16_f32 v40, v68, v69
		v_cvt_pk_bf16_f32 v41, v70, v71
		v_cvt_pk_bf16_f32 v48, v72, v73
		v_cvt_pk_bf16_f32 v49, v74, v75
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_write_b32 v64, v7 offset:6048
		v_cvt_pk_bf16_f32 v52, v76, v77
		v_cvt_pk_bf16_f32 v53, v78, v79
		v_cvt_pk_bf16_f32 v56, v80, v81
		v_cvt_pk_bf16_f32 v57, v82, v83
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[30:31], v11 offset:6048
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v42, v84, v85
		v_cvt_pk_bf16_f32 v43, v86, v87
		v_cvt_pk_bf16_f32 v50, v88, v89
		v_cvt_pk_bf16_f32 v51, v90, v91
		v_cvt_pk_bf16_f32 v54, v92, v93
		v_cvt_pk_bf16_f32 v55, v94, v95
		v_cvt_pk_bf16_f32 v58, v96, v97
		v_cvt_pk_bf16_f32 v59, v98, v99
		v_cvt_pk_bf16_f32 v64, v100, v101
		v_cvt_pk_bf16_f32 v65, v102, v103
		v_cvt_pk_bf16_f32 v68, v104, v105
		v_cvt_pk_bf16_f32 v69, v106, v107
		v_cvt_pk_bf16_f32 v72, v108, v109
		v_cvt_pk_bf16_f32 v73, v110, v111
		v_cvt_pk_bf16_f32 v76, v112, v113
		v_cvt_pk_bf16_f32 v77, v114, v115
		v_cvt_pk_bf16_f32 v66, v116, v117
		v_cvt_pk_bf16_f32 v67, v118, v119
		v_cvt_pk_bf16_f32 v70, v120, v121
		v_cvt_pk_bf16_f32 v71, v122, v123
		v_cvt_pk_bf16_f32 v74, v124, v125
		v_cvt_pk_bf16_f32 v75, v126, v127
		v_cvt_pk_bf16_f32 v78, v128, v129
		v_cvt_pk_bf16_f32 v79, v130, v131
		v_cvt_pk_bf16_f32 v80, v132, v133
		v_cvt_pk_bf16_f32 v81, v134, v135
		v_cvt_pk_bf16_f32 v84, v136, v137
		v_cvt_pk_bf16_f32 v85, v138, v139
		v_cvt_pk_bf16_f32 v88, v140, v141
		v_cvt_pk_bf16_f32 v89, v142, v143
		v_cvt_pk_bf16_f32 v92, v144, v145
		v_cvt_pk_bf16_f32 v93, v146, v147
		v_cvt_pk_bf16_f32 v82, v148, v149
		v_cvt_pk_bf16_f32 v83, v150, v151
		v_cvt_pk_bf16_f32 v86, v152, v153
		v_cvt_pk_bf16_f32 v87, v154, v155
		v_cvt_pk_bf16_f32 v90, v156, v157
		v_cvt_pk_bf16_f32 v91, v158, v159
		v_cvt_pk_bf16_f32 v94, v160, v161
		v_cvt_pk_bf16_f32 v95, v162, v163
		v_cvt_pk_bf16_f32 v96, v164, v165
		v_cvt_pk_bf16_f32 v97, v166, v167
		v_cvt_pk_bf16_f32 v100, v168, v169
		v_cvt_pk_bf16_f32 v101, v170, v171
		v_cvt_pk_bf16_f32 v104, v172, v173
		v_cvt_pk_bf16_f32 v105, v174, v175
		v_cvt_pk_bf16_f32 v108, v176, v177
		v_cvt_pk_bf16_f32 v109, v178, v179
		v_cvt_pk_bf16_f32 v98, v180, v181
		v_cvt_pk_bf16_f32 v99, v182, v183
		v_cvt_pk_bf16_f32 v102, v184, v185
		v_cvt_pk_bf16_f32 v103, v186, v187
		v_cvt_pk_bf16_f32 v106, v188, v189
		v_cvt_pk_bf16_f32 v107, v190, v191
		v_cvt_pk_bf16_f32 v110, v192, v193
		v_cvt_pk_bf16_f32 v111, v194, v195
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[40:43]
		ds_write_b128 v3, v[48:51] offset:4096
		ds_write_b128 v4, v[52:55] offset:8192
		ds_write_b128 v0, v[56:59] offset:12288
		v_lshrrev_b32_e32 v1, 2, v61
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v7, 12, v1
		v_lshl_add_u32 v7, v5, 13, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v1, v5, 1, v1
		v_lshrrev_b32_e32 v5, 1, v61
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v8, 3, v5
		v_accvgpr_read_b32 v11, a1
		v_lshl_add_u32 v11, s21, 2, v11
		v_lshl_add_u32 v5, v5, 6, v11
		v_and_b32_e32 v11, 1, v61
		v_lshl_add_u32 v5, v11, 5, v5
		v_lshlrev_b32_e32 v11, 2, v11
		v_xor_b32_e32 v5, v5, v11
		v_bitop3_b32 v1, v1, v8, v5 bitop3:0x96
		v_lshl_add_u32 v1, v1, 4, v7
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[48:51], v1 offset:256
		ds_read_b128 v[52:55], v1 offset:2048
		ds_read_b128 v[56:59], v1 offset:2304
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[64:67]
		ds_write_b128 v3, v[68:71] offset:4096
		ds_write_b128 v4, v[72:75] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		v_lshlrev_b32_e32 v5, 7, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[60:63], v1
		ds_read_b128 v[64:67], v1 offset:256
		ds_read_b128 v[68:71], v1 offset:2048
		ds_read_b128 v[72:75], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[80:83]
		ds_write_b128 v3, v[84:87] offset:4096
		ds_write_b128 v4, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[76:79], v1
		ds_read_b128 v[80:83], v1 offset:256
		ds_read_b128 v[84:87], v1 offset:2048
		ds_read_b128 v[88:91], v1 offset:2304
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[96:99]
		ds_write_b128 v3, v[100:103] offset:4096
		ds_write_b128 v4, v[104:107] offset:8192
		ds_write_b128 v0, v[108:111] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v1
		ds_read_b128 v[96:99], v1 offset:256
		ds_read_b128 v[100:103], v1 offset:2048
		ds_read_b128 v[104:107], v1 offset:2304
		v_accvgpr_read_b32 v6, a0
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v7, s0, v6
		v_add3_u32 v7, v7, v9, v5
		v_add3_u32 v7, v7, v10, v12
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		v_mov_b64_e32 v[108:109], v[40:41]
		v_mov_b64_e32 v[110:111], v[48:49]
		buffer_store_dwordx4 v[108:111], v7, s[8:11], 0 offen
		s_lshl_b32 s1, s17, 5
		s_add_i32 s2, s0, s1
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s2
		v_mov_b64_e32 v[108:109], v[52:53]
		v_mov_b64_e32 v[110:111], v[56:57]
		buffer_store_dwordx4 v[108:111], v8, s[8:11], 0 offen
		s_lshl_b32 s2, s17, 6
		s_add_i32 s3, s0, s2
		v_add3_u32 v8, v12, v7, s3
		v_mov_b64_e32 v[108:109], v[42:43]
		v_mov_b64_e32 v[110:111], v[50:51]
		buffer_store_dwordx4 v[108:111], v8, s[8:11], 0 offen
		s_mul_i32 s3, 0x60, s17
		s_add_i32 s4, s0, s3
		v_add3_u32 v7, v12, v7, s4
		v_mov_b64_e32 v[40:41], v[54:55]
		v_mov_b64_e32 v[42:43], v[58:59]
		buffer_store_dwordx4 v[40:43], v7, s[8:11], 0 offen
		s_lshl_b32 s4, s17, 7
		s_add_i32 s5, s0, s4
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s5
		v_mov_b64_e32 v[40:41], v[60:61]
		v_mov_b64_e32 v[42:43], v[64:65]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s5, 0xa0, s17
		s_add_i32 s6, s0, s5
		v_add3_u32 v8, v12, v7, s6
		v_mov_b64_e32 v[40:41], v[68:69]
		v_mov_b64_e32 v[42:43], v[72:73]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s6, 0xc0, s17
		s_add_i32 s7, s0, s6
		v_add3_u32 v7, v12, v7, s7
		v_mov_b64_e32 v[40:41], v[62:63]
		v_mov_b64_e32 v[42:43], v[66:67]
		buffer_store_dwordx4 v[40:43], v7, s[8:11], 0 offen
		s_mul_i32 s7, 0xe0, s17
		s_add_i32 s12, s0, s7
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s12
		v_mov_b64_e32 v[40:41], v[70:71]
		v_mov_b64_e32 v[42:43], v[74:75]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_lshl_b32 s12, s17, 8
		s_add_i32 s13, s0, s12
		v_add3_u32 v8, v12, v7, s13
		v_mov_b64_e32 v[40:41], v[76:77]
		v_mov_b64_e32 v[42:43], v[80:81]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s13, 0x120, s17
		s_add_i32 s14, s0, s13
		v_add3_u32 v7, v12, v7, s14
		v_mov_b64_e32 v[40:41], v[84:85]
		v_mov_b64_e32 v[42:43], v[88:89]
		buffer_store_dwordx4 v[40:43], v7, s[8:11], 0 offen
		s_mul_i32 s14, 0x140, s17
		s_add_i32 s15, s0, s14
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s15
		v_mov_b64_e32 v[40:41], v[78:79]
		v_mov_b64_e32 v[42:43], v[82:83]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s15, 0x160, s17
		s_add_i32 s16, s0, s15
		v_add3_u32 v8, v12, v7, s16
		v_mov_b64_e32 v[40:41], v[86:87]
		v_mov_b64_e32 v[42:43], v[90:91]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s16, 0x180, s17
		s_add_i32 s18, s0, s16
		v_add3_u32 v7, v12, v7, s18
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[40:41], v[92:93]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[42:43], v[96:97]
		buffer_store_dwordx4 v[40:43], v7, s[8:11], 0 offen
		s_mul_i32 s18, 0x1a0, s17
		s_add_i32 s19, s0, s18
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s19
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[40:41], v[100:101]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[42:43], v[104:105]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s19, 0x1c0, s17
		s_add_i32 s20, s0, s19
		v_add3_u32 v8, v12, v7, s20
		v_mov_b64_e32 v[40:41], v[94:95]
		v_mov_b64_e32 v[42:43], v[98:99]
		buffer_store_dwordx4 v[40:43], v8, s[8:11], 0 offen
		s_mul_i32 s17, 0x1e0, s17
		s_add_i32 s20, s0, s17
		v_add3_u32 v7, v12, v7, s20
		v_mov_b64_e32 v[40:41], v[102:103]
		v_mov_b64_e32 v[42:43], v[106:107]
		buffer_store_dwordx4 v[40:43], v7, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[48:51], a[68:71], v[196:199], v30, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[68:71], v[200:203], v30, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[56:59], a[76:79], v[216:219], v30, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[48:51], a[76:79], v[212:215], v30, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[52:55], a[72:75], v[196:199], v30, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], a[72:75], v[200:203], v30, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], v[44:47], v[216:219], v30, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[52:55], v[44:47], v[212:215], v30, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], a[68:71], v[204:207], v31, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], a[68:71], v[208:211], v31, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], a[76:79], v[224:227], v31, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[20:23], a[76:79], v[220:223], v31, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], a[72:75], v[204:207], v31, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v40, v196, v197
		v_cvt_pk_bf16_f32 v41, v198, v199
		v_cvt_pk_bf16_f32 v48, v200, v201
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], a[72:75], v[208:211], v31, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v49, v202, v203
		v_cvt_pk_bf16_f32 v42, v212, v213
		v_cvt_pk_bf16_f32 v43, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[44:47], v[224:227], v31, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v52, v204, v205
		v_cvt_pk_bf16_f32 v53, v206, v207
		v_cvt_pk_bf16_f32 v50, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[44:47], v[220:223], v31, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v44, v208, v209
		v_cvt_pk_bf16_f32 v45, v210, v211
		v_cvt_pk_bf16_f32 v51, v218, v219
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[20:23], v[16:19], v[236:239], v31, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v46, v224, v225
		v_cvt_pk_bf16_f32 v47, v226, v227
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[16:19], v[240:243], v31, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[32:35], a[8:11], v[248:251], v31, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v54, v220, v221
		v_cvt_pk_bf16_f32 v55, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[20:23], a[8:11], v[244:247], v31, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[24:27], a[4:7], v[236:239], v31, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[36:39], a[4:7], v[240:243], v31, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[12:15], v[248:251], v31, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[24:27], a[12:15], v[244:247], v31, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[48:51], v[16:19], v[228:231], v30, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[56:59], v[16:19], v[232:235], v30, v15 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[56:59], a[8:11], a[104:107], v30, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[48:51], a[8:11], a[100:103], v30, v15 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[52:55], a[4:7], v[228:231], v30, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v16, v236, v237
		v_cvt_pk_bf16_f32 v17, v238, v239
		v_cvt_pk_bf16_f32 v56, v240, v241
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[4:7], v[232:235], v30, v15 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v57, v242, v243
		v_cvt_pk_bf16_f32 v18, v244, v245
		v_cvt_pk_bf16_f32 v19, v246, v247
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[12:15], a[104:107], v30, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v60, v228, v229
		v_cvt_pk_bf16_f32 v61, v230, v231
		v_cvt_pk_bf16_f32 v58, v248, v249
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[52:55], a[12:15], a[100:103], v30, v15 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v64, v232, v233
		v_cvt_pk_bf16_f32 v65, v234, v235
		v_cvt_pk_bf16_f32 v59, v250, v251
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[48:51], a[16:19], a[108:111], v30, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a104
		v_accvgpr_read_b32 v8, a105
		v_cvt_pk_bf16_f32 v66, v7, v8
		v_accvgpr_read_b32 v7, a106
		v_accvgpr_read_b32 v8, a107
		v_cvt_pk_bf16_f32 v67, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[56:59], a[16:19], a[112:115], v30, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[56:59], a[24:27], a[128:131], v30, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a100
		v_accvgpr_read_b32 v8, a101
		v_cvt_pk_bf16_f32 v62, v7, v8
		v_accvgpr_read_b32 v7, a102
		v_accvgpr_read_b32 v8, a103
		v_cvt_pk_bf16_f32 v63, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[48:51], a[24:27], a[124:127], v30, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[52:55], a[20:23], a[108:111], v30, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[252:255], a[20:23], a[112:115], v30, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[252:255], a[28:31], a[128:131], v30, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[52:55], a[28:31], a[124:127], v30, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[16:19], a[116:119], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], a[16:19], a[120:123], v31, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], a[24:27], a[136:139], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[24:27], a[132:135], v31, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], a[20:23], a[116:119], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a108
		v_accvgpr_read_b32 v8, a109
		v_cvt_pk_bf16_f32 v68, v7, v8
		v_accvgpr_read_b32 v7, a110
		v_accvgpr_read_b32 v8, a111
		v_cvt_pk_bf16_f32 v69, v7, v8
		v_accvgpr_read_b32 v7, a112
		v_accvgpr_read_b32 v8, a113
		v_cvt_pk_bf16_f32 v72, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], a[20:23], a[120:123], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a114
		v_accvgpr_read_b32 v8, a115
		v_cvt_pk_bf16_f32 v73, v7, v8
		v_accvgpr_read_b32 v7, a124
		v_accvgpr_read_b32 v8, a125
		v_cvt_pk_bf16_f32 v70, v7, v8
		v_accvgpr_read_b32 v7, a126
		v_accvgpr_read_b32 v8, a127
		v_cvt_pk_bf16_f32 v71, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[36:39], a[28:31], a[136:139], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a116
		v_accvgpr_read_b32 v8, a117
		v_cvt_pk_bf16_f32 v76, v7, v8
		v_accvgpr_read_b32 v7, a118
		v_accvgpr_read_b32 v8, a119
		v_cvt_pk_bf16_f32 v77, v7, v8
		v_accvgpr_read_b32 v7, a128
		v_accvgpr_read_b32 v8, a129
		v_cvt_pk_bf16_f32 v74, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], a[28:31], a[132:135], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a120
		v_accvgpr_read_b32 v8, a121
		v_cvt_pk_bf16_f32 v80, v7, v8
		v_accvgpr_read_b32 v7, a122
		v_accvgpr_read_b32 v8, a123
		v_cvt_pk_bf16_f32 v81, v7, v8
		v_accvgpr_read_b32 v7, a130
		v_accvgpr_read_b32 v8, a131
		v_cvt_pk_bf16_f32 v75, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[32:35], a[148:151], v31, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a136
		v_accvgpr_read_b32 v8, a137
		v_cvt_pk_bf16_f32 v82, v7, v8
		v_accvgpr_read_b32 v7, a138
		v_accvgpr_read_b32 v8, a139
		v_cvt_pk_bf16_f32 v83, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], a[32:35], a[152:155], v31, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], a[40:43], a[168:171], v31, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a132
		v_accvgpr_read_b32 v8, a133
		v_cvt_pk_bf16_f32 v78, v7, v8
		v_accvgpr_read_b32 v7, a134
		v_accvgpr_read_b32 v8, a135
		v_cvt_pk_bf16_f32 v79, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[20:23], a[40:43], a[164:167], v31, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], a[36:39], a[148:151], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], a[36:39], a[152:155], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], a[44:47], a[168:171], v31, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], a[44:47], a[164:167], v31, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[48:51], a[32:35], a[140:143], v30, v29 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[32:35], a[144:147], v30, v29 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[56:59], a[40:43], a[160:163], v30, v29 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[40:43], a[156:159], v30, v29 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[36:39], a[140:143], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a148
		v_accvgpr_read_b32 v8, a149
		v_cvt_pk_bf16_f32 v20, v7, v8
		v_accvgpr_read_b32 v7, a150
		v_accvgpr_read_b32 v8, a151
		v_cvt_pk_bf16_f32 v21, v7, v8
		v_accvgpr_read_b32 v7, a152
		v_accvgpr_read_b32 v8, a153
		v_cvt_pk_bf16_f32 v24, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[252:255], a[36:39], a[144:147], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a154
		v_accvgpr_read_b32 v8, a155
		v_cvt_pk_bf16_f32 v25, v7, v8
		v_accvgpr_read_b32 v7, a164
		v_accvgpr_read_b32 v8, a165
		v_cvt_pk_bf16_f32 v22, v7, v8
		v_accvgpr_read_b32 v7, a166
		v_accvgpr_read_b32 v8, a167
		v_cvt_pk_bf16_f32 v23, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[252:255], a[44:47], a[160:163], v30, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a140
		v_accvgpr_read_b32 v8, a141
		v_cvt_pk_bf16_f32 v32, v7, v8
		v_accvgpr_read_b32 v7, a142
		v_accvgpr_read_b32 v8, a143
		v_cvt_pk_bf16_f32 v33, v7, v8
		v_accvgpr_read_b32 v7, a168
		v_accvgpr_read_b32 v8, a169
		v_cvt_pk_bf16_f32 v26, v7, v8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[52:55], a[44:47], a[156:159], v30, v29 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v7, a144
		v_accvgpr_read_b32 v8, a145
		v_cvt_pk_bf16_f32 v28, v7, v8
		v_accvgpr_read_b32 v7, a146
		v_accvgpr_read_b32 v8, a147
		v_cvt_pk_bf16_f32 v29, v7, v8
		v_accvgpr_read_b32 v7, a170
		v_accvgpr_read_b32 v8, a171
		v_cvt_pk_bf16_f32 v27, v7, v8
		s_barrier
		v_accvgpr_read_b32 v7, a160
		v_accvgpr_read_b32 v8, a161
		v_cvt_pk_bf16_f32 v30, v7, v8
		v_accvgpr_read_b32 v7, a162
		v_accvgpr_read_b32 v8, a163
		v_cvt_pk_bf16_f32 v31, v7, v8
		ds_write_b128 v2, v[40:43] offset:16384
		ds_write_b128 v3, v[48:51] offset:20480
		v_accvgpr_read_b32 v7, a156
		v_accvgpr_read_b32 v8, a157
		v_cvt_pk_bf16_f32 v34, v7, v8
		ds_write_b128 v4, v[52:55] offset:24576
		ds_write_b128 v0, v[44:47] offset:28672
		v_accvgpr_read_b32 v7, a158
		v_accvgpr_read_b32 v8, a159
		v_cvt_pk_bf16_f32 v35, v7, v8
		s_add_i32 s0, s0, 0x100
		v_add_u32_e32 v7, s0, v6
		v_add3_u32 v7, v7, v9, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v1 offset:16384
		ds_read_b128 v[40:43], v1 offset:16640
		ds_read_b128 v[44:47], v1 offset:18432
		ds_read_b128 v[48:51], v1 offset:18688
		v_add3_u32 v7, v7, v10, v12
		s_add_i32 s1, s0, s1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[52:53], v[36:37]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[54:55], v[40:41]
		buffer_store_dwordx4 v[52:55], v7, s[8:11], 0 offen
		v_add3_u32 v7, v6, v9, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[60:63] offset:16384
		ds_write_b128 v3, v[64:67] offset:20480
		ds_write_b128 v4, v[16:19] offset:24576
		ds_write_b128 v0, v[56:59] offset:28672
		v_add_u32_e32 v7, v7, v10
		v_add3_u32 v8, v12, v7, s1
		v_mov_b64_e32 v[16:17], v[44:45]
		v_mov_b64_e32 v[18:19], v[48:49]
		buffer_store_dwordx4 v[16:19], v8, s[8:11], 0 offen
		s_add_i32 s1, s0, s2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:16384
		ds_read_b128 v[52:55], v1 offset:16640
		ds_read_b128 v[56:59], v1 offset:18432
		ds_read_b128 v[60:63], v1 offset:18688
		v_add3_u32 v8, v12, v7, s1
		v_mov_b64_e32 v[64:65], v[38:39]
		v_mov_b64_e32 v[66:67], v[42:43]
		buffer_store_dwordx4 v[64:67], v8, s[8:11], 0 offen
		s_add_i32 s1, s0, s3
		v_add3_u32 v7, v12, v7, s1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[68:71] offset:16384
		ds_write_b128 v3, v[72:75] offset:20480
		ds_write_b128 v4, v[76:79] offset:24576
		ds_write_b128 v0, v[80:83] offset:28672
		v_mov_b64_e32 v[36:37], v[46:47]
		v_mov_b64_e32 v[38:39], v[50:51]
		buffer_store_dwordx4 v[36:39], v7, s[8:11], 0 offen
		s_add_i32 s1, s0, s4
		v_add3_u32 v7, v6, v9, v5
		v_add_u32_e32 v7, v7, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v1 offset:16384
		ds_read_b128 v[40:43], v1 offset:16640
		ds_read_b128 v[44:47], v1 offset:18432
		ds_read_b128 v[48:51], v1 offset:18688
		v_add3_u32 v8, v12, v7, s1
		v_mov_b64_e32 v[64:65], v[16:17]
		v_mov_b64_e32 v[66:67], v[52:53]
		buffer_store_dwordx4 v[64:67], v8, s[8:11], 0 offen
		s_add_i32 s1, s0, s5
		v_add3_u32 v8, v12, v7, s1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[32:35] offset:16384
		ds_write_b128 v3, v[28:31] offset:20480
		ds_write_b128 v4, v[20:23] offset:24576
		ds_write_b128 v0, v[24:27] offset:28672
		v_mov_b64_e32 v[20:21], v[56:57]
		v_mov_b64_e32 v[22:23], v[60:61]
		buffer_store_dwordx4 v[20:23], v8, s[8:11], 0 offen
		s_add_i32 s1, s0, s6
		v_add3_u32 v0, v12, v7, s1
		v_mov_b64_e32 v[20:21], v[18:19]
		v_mov_b64_e32 v[22:23], v[54:55]
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v1 offset:16384
		ds_read_b128 v[20:23], v1 offset:16640
		ds_read_b128 v[24:27], v1 offset:18432
		ds_read_b128 v[28:31], v1 offset:18688
		s_add_i32 s1, s0, s7
		v_add3_u32 v0, v6, v9, v5
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s1
		v_mov_b64_e32 v[32:33], v[58:59]
		v_mov_b64_e32 v[34:35], v[62:63]
		buffer_store_dwordx4 v[32:35], v1, s[8:11], 0 offen
		s_add_i32 s1, s0, s12
		v_add3_u32 v1, v12, v0, s1
		v_mov_b64_e32 v[32:33], v[36:37]
		v_mov_b64_e32 v[34:35], v[40:41]
		buffer_store_dwordx4 v[32:35], v1, s[8:11], 0 offen
		s_add_i32 s1, s0, s13
		v_add3_u32 v0, v12, v0, s1
		v_mov_b64_e32 v[32:33], v[44:45]
		v_mov_b64_e32 v[34:35], v[48:49]
		buffer_store_dwordx4 v[32:35], v0, s[8:11], 0 offen
		s_add_i32 s1, s0, s14
		v_add3_u32 v0, v6, v9, v5
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s1
		v_mov_b64_e32 v[32:33], v[38:39]
		v_mov_b64_e32 v[34:35], v[42:43]
		buffer_store_dwordx4 v[32:35], v1, s[8:11], 0 offen
		s_add_i32 s1, s0, s15
		v_add3_u32 v1, v12, v0, s1
		v_mov_b64_e32 v[32:33], v[46:47]
		v_mov_b64_e32 v[34:35], v[50:51]
		buffer_store_dwordx4 v[32:35], v1, s[8:11], 0 offen
		s_add_i32 s1, s0, s16
		v_add3_u32 v0, v12, v0, s1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[32:33], v[16:17]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[34:35], v[20:21]
		buffer_store_dwordx4 v[32:35], v0, s[8:11], 0 offen
		s_add_i32 s1, s0, s18
		v_add3_u32 v0, v6, v9, v5
		v_add_u32_e32 v0, v0, v10
		v_add3_u32 v1, v12, v0, s1
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[4:5], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[28:29]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_add_i32 s1, s0, s19
		v_add3_u32 v1, v12, v0, s1
		v_mov_b64_e32 v[4:5], v[18:19]
		v_mov_b64_e32 v[6:7], v[22:23]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_add_i32 s0, s0, s17
		v_add3_u32 v0, v12, v0, s0
		v_mov_b64_e32 v[4:5], v[26:27]
		v_mov_b64_e32 v[6:7], v[30:31]
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
		.amdhsa_next_free_vgpr 428
		.amdhsa_next_free_sgpr 58
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
	.set .L_a4w4_kernel.numbered_sgpr, 58
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
    .sgpr_count:     58
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     428
    .agpr_count:     172
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 100
    wave.regalloc.agpr.dwords: 387
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
