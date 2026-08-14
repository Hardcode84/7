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
		s_load_dword s20, s[0:1], 0x44
		s_add_i32 s0, s12, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s12, s1, 0
		s_add_i32 s0, s0, s12
		s_ashr_i32 s0, s0, 8
		s_add_i32 s12, s13, 0xff
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s13, s1, 0
		s_add_i32 s12, s12, s13
		s_ashr_i32 s12, s12, 8
		s_and_b32 s13, s16, 7
		s_lshr_b32 s16, s16, 3
		s_cmp_lt_i32 s13, 8
		s_cbranch_scc0 .L_a4w4_kernel.if_else_0
		s_mul_i32 s13, s13, 32
		s_add_i32 s21, s13, s16
		s_branch .L_a4w4_kernel.if_end_0
.L_a4w4_kernel.if_else_0:
		s_add_i32 s13, s13, -8
		s_mul_i32 s13, s13, 31
		s_add_i32 s13, s13, 0x100
		s_add_i32 s21, s13, s16
.L_a4w4_kernel.if_end_0:
		s_mul_i32 s12, s12, 4
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s16, s21, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s16, s21
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s22, s12, -1
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s22, s22, s12
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_barrier
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s13, s13, s25
		s_cmp_ge_u32 s13, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s23, s26, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s13, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s13, s26, s13
		s_cmp_ge_u32 s13, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s23
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s12, s21, s12
		s_xor_b32 s21, s22, -1
		s_add_i32 s21, s21, 1
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s12, s21, s22
		s_mul_i32 s12, s12, 4
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s0, s0, s21
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s21, s13, s24
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s13, s21, s13
		s_xor_b32 s21, s13, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s21, s13
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s21, s13, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s21, s13
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s22, s22, s0
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s23, s22, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s23, s23, 1
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s25, s23, s24
		s_mul_hi_u32 s25, s24, s25
		s_add_i32 s24, s24, s25
		s_mul_hi_u32 s24, s16, s24
		s_mul_i32 s25, s24, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s16, s16, s25
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s16, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s16, s26, s16
		s_cselect_b32 s25, 1, 0
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s23, s16, s23
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s16, s23, s16
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s16, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s23, s16
		s_add_i32 s12, s12, s16
		s_add_i32 s16, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s16, s16, s24
		s_add_i32 s21, s16, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s16, s21, s16
		s_xor_b32 s0, s13, s0
		s_xor_b32 s13, s16, -1
		s_add_i32 s13, s13, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s13, s16
		s_mul_i32 s12, s12, 0x100
		s_mul_i32 s13, s12, s15
		s_mul_i32 s0, s0, 0x100
		s_cmp_lt_i32 s14, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s14, s1
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 6, v1
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s14, s17, 0x80
		v_readfirstlane_b32 s16, v2
		s_lshr_b32 s16, s16, 6
		s_mul_i32 s16, 0x420, s16
		s_mov_b32 m0, s16
		v_mul_lo_u32 v2, s15, v1
		v_and_b32_e32 v3, 63, v0
		v_lshrrev_b32_e32 v4, 3, v3
		v_mul_lo_u32 v5, s15, v4
		v_lshlrev_b32_e32 v5, 4, v5
		v_and_b32_e32 v6, 1, v0
		v_lshlrev_b32_e32 v7, 4, v6
		v_add3_u32 v2, v2, v5, v7
		v_lshrrev_b32_e32 v5, 2, v3
		v_accvgpr_write_b32 a0, v5
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v8, 6, v5
		v_lshrrev_b32_e32 v9, 1, v3
		v_and_b32_e32 v10, 1, v9
		v_lshlrev_b32_e32 v11, 5, v10
		v_add3_u32 v2, v2, v8, v11
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_mul_i32 s21, s0, s17
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s22, s15, 2
		v_add_u32_e32 v12, s22, v2
		s_mul_i32 s23, s19, 8
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mul_i32 s28, 12, s15
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s29, s15, 3
		v_add_u32_e32 v13, s29, v2
		s_mul_i32 s30, s20, 8
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_mul_i32 s31, 0x84, s15
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v14, s28, v2
		s_mov_b32 s32, 0
		s_mul_i32 s33, 0x88, s15
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_mul_i32 s34, 0x8c, s15
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s15, s15, 7
		v_add_u32_e32 v15, s15, v2
		s_ashr_i32 s1, s1, 8
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_mul_i32 s35, 12, s17
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v16, s31, v2
		s_mul_i32 s36, 0x84, s17
		s_mul_i32 s37, 0x88, s17
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_mul_i32 s38, 0x8c, s17
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v17, s33, v2
		s_mul_i32 s39, s20, 16
		s_mul_i32 s40, s19, 16
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_mul_lo_u32 v18, s17, v1
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v19, s34, v2
		s_mov_b32 s41, s40
		s_mov_b32 s42, s39
		s_add_u32 s44, s4, s21
		s_addc_u32 s45, s5, 0
		v_mul_lo_u32 v20, s17, v4
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v20, 4, v20
		s_add_i32 m0, m0, 0x9460
		v_add3_u32 v7, v18, v20, v7
		v_add3_u32 v7, v7, v8, v11
		v_and_b32_e32 v4, 1, v4
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_lshl_b32 s43, s17, 2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v8, s43, v7
		s_lshl_b32 s17, s17, 3
		v_add_u32_e32 v11, s17, v7
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
		v_add_u32_e32 v18, s35, v7
		s_add_i32 m0, m0, 0x1080
		v_mul_lo_u32 v20, s19, v1
		v_lshl_add_u32 v21, v20, 1, s12
		v_lshrrev_b32_e32 v22, 5, v3
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		v_mul_lo_u32 v23, s19, v22
		s_add_i32 m0, m0, 0x1080
		v_mul_lo_u32 v22, s20, v22
		v_mul_lo_u32 v24, s20, v1
		v_lshlrev_b32_e32 v25, 3, v6
		buffer_load_dwordx4 v18, s[44:47], 0 offen lds
		v_add3_u32 v21, v21, v23, v25
		v_lshrrev_b32_e32 v26, 4, v3
		v_and_b32_e32 v27, 1, v26
		v_lshlrev_b32_e32 v28, 7, v27
		v_lshlrev_b32_e32 v29, 6, v4
		v_add3_u32 v21, v21, v28, v29
		v_lshlrev_b32_e32 v30, 5, v5
		v_lshlrev_b32_e32 v31, 4, v10
		v_add3_u32 v21, v21, v30, v31
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		buffer_load_dwordx2 v[32:33], v21, s[48:51], 0 offen
		v_lshl_add_u32 v34, v24, 1, s0
		v_lshlrev_b32_e32 v35, 2, v6
		v_add3_u32 v34, v34, v22, v35
		v_lshlrev_b32_e32 v27, 6, v27
		v_lshlrev_b32_e32 v36, 5, v4
		v_add3_u32 v34, v34, v27, v36
		v_lshlrev_b32_e32 v37, 4, v5
		v_lshlrev_b32_e32 v38, 3, v10
		v_add3_u32 v34, v34, v37, v38
		s_mov_b32 s52, s10
		s_mov_b32 s53, s11
		s_mov_b32 s54, s26
		s_mov_b32 s55, s27
		buffer_load_dword v39, v34, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		v_add_u32_e32 v40, s14, v7
		buffer_load_dwordx4 v40, s[44:47], 0 offen lds
		v_mov_b32_e32 v41, 0x2100
		v_mul_lo_u32 v41, v41, v4
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v4, s36, v7
		v_and_b32_e32 v3, 15, v3
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		v_mov_b32_e32 v42, 0x1080
		v_mul_lo_u32 v42, v42, v5
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v5, s37, v7
		v_add_u32_e32 v43, s38, v7
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		v_add_u32_e32 v44, 0x80, v2
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s19, s0, 0x80
		v_lshl_add_u32 v45, v24, 1, s19
		v_add3_u32 v45, v45, v22, v35
		buffer_load_dwordx4 v43, s[44:47], 0 offen lds
		v_add3_u32 v45, v45, v27, v36
		v_add3_u32 v45, v45, v37, v38
		buffer_load_dword v46, v45, s[52:55], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s20, s22, 0x80
		buffer_load_dwordx4 v44, s[24:27], 0 offen lds
		v_add_u32_e32 v47, s20, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v48, 0x80, v2
		v_add_u32_e32 v49, s29, v48
		v_add_u32_e32 v50, s28, v48
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		v_add_u32_e32 v48, s15, v48
		s_add_i32 m0, m0, 0x1080
		v_lshrrev_b32_e32 v51, 7, v0
		v_add_u32_e32 v52, 0x80, v2
		v_add_u32_e32 v53, s31, v52
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		v_add_u32_e32 v54, s33, v52
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v52, s34, v52
		v_add_u32_e32 v55, 0x80, v7
		v_add_u32_e32 v56, 0x80, v7
		v_add_u32_e32 v57, s43, v56
		v_add_u32_e32 v58, s17, v56
		v_add_u32_e32 v56, s35, v56
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		v_add_u32_e32 v59, 0x80, v7
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v60, s36, v59
		v_add_u32_e32 v61, s37, v59
		v_add_u32_e32 v59, s38, v59
		buffer_load_dwordx4 v48, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v62, 4, v26
		s_add_i32 m0, m0, 0x1080
		v_lshl_add_u32 v63, v51, 7, v62
		v_add_u32_e32 v62, 0x10000, v62
		v_lshlrev_b32_e32 v51, 4, v51
		buffer_load_dwordx4 v53, s[24:27], 0 offen lds
		v_add_u32_e32 v51, 0x20000, v51
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s15, s21, 0x100
		v_lshl_add_u32 v51, v26, 8, v51
		v_and_b32_e32 v64, 1, v1
		v_accvgpr_write_b32 a1, v64
		buffer_load_dwordx4 v54, s[24:27], 0 offen lds
		v_mov_b32_e32 v64, 0x420
		v_mul_lo_u32 v64, v64, v6
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v63, v63, v64, v41
		buffer_load_dwordx4 v52, s[24:27], 0 offen lds
		v_add_u32_e32 v62, v62, v64
		s_add_i32 m0, m0, 0x5260
		v_add_u32_e32 v64, s14, v7
		v_mov_b32_e32 v65, 0x840
		v_mul_lo_u32 v65, v65, v10
		buffer_load_dwordx4 v55, s[44:47], 0 offen lds
		v_add3_u32 v63, v63, v42, v65
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s30, s0
		v_lshl_add_u32 v66, v24, 1, s14
		v_add3_u32 v66, v66, v22, v35
		buffer_load_dwordx4 v57, s[44:47], 0 offen lds
		v_add3_u32 v66, v66, v27, v36
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s23, s12
		v_lshl_add_u32 v20, v20, 1, s14
		v_add3_u32 v20, v20, v23, v25
		v_add3_u32 v20, v20, v28, v29
		v_add3_u32 v20, v20, v30, v31
		v_add3_u32 v23, v66, v37, v38
		buffer_load_dwordx4 v58, s[44:47], 0 offen lds
		v_accvgpr_read_b32 v28, a1
		v_lshlrev_b32_e32 v28, 7, v28
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v28, v62, v28, v41
		v_add3_u32 v28, v28, v42, v65
		v_lshlrev_b32_e32 v41, 9, v1
		buffer_load_dwordx4 v56, s[44:47], 0 offen lds
		buffer_load_dwordx2 v[66:67], v20, s[48:51], 0 offen
		buffer_load_dword v42, v23, s[52:55], 0 offen
		s_add_i32 m0, m0, 0x5260
		v_add_u32_e32 v41, 0x20000, v41
		v_lshlrev_b32_e32 v62, 4, v9
		buffer_load_dwordx4 v64, s[44:47], 0 offen lds
		v_add3_u32 v41, v41, v62, v25
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s14, s13, 0x100
		v_lshlrev_b32_e32 v9, 3, v9
		v_lshlrev_b32_e32 v62, 8, v1
		buffer_load_dwordx4 v60, s[44:47], 0 offen lds
		v_add_u32_e32 v62, 0x20000, v62
		s_add_i32 m0, m0, 0x1080
		v_add3_u32 v9, v62, v9, v35
		s_add_i32 s13, s30, 0x80
		v_lshrrev_b32_e32 v62, 2, v3
		buffer_load_dwordx4 v61, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v62, 5, v62
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s13, s13, s0
		v_lshl_add_u32 v24, v24, 1, s13
		v_add3_u32 v22, v24, v22, v35
		buffer_load_dwordx4 v59, s[44:47], 0 offen lds
		v_add3_u32 v22, v22, v27, v36
		v_add3_u32 v22, v22, v37, v38
		buffer_load_dword v24, v22, s[52:55], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		ds_read_b128 a[4:7], v63
		ds_read_b128 a[8:11], v63 offset:64
		ds_read_b128 a[12:15], v63 offset:256
		ds_read_b128 a[16:19], v63 offset:320
		ds_read_b128 a[20:23], v63 offset:512
		ds_read_b128 a[24:27], v63 offset:576
		ds_read_b128 a[28:31], v63 offset:768
		ds_read_b128 a[32:35], v63 offset:832
		ds_read_b128 a[36:39], v63 offset:16896
		ds_read_b128 a[40:43], v63 offset:16960
		ds_read_b128 a[44:47], v63 offset:17152
		ds_read_b128 a[48:51], v63 offset:17216
		ds_read_b128 a[52:55], v63 offset:17408
		ds_read_b128 a[56:59], v63 offset:17472
		ds_read_b128 a[60:63], v63 offset:17664
		ds_read_b128 a[64:67], v63 offset:17728
		ds_read_b128 a[68:71], v28 offset:2016
		ds_read_b128 a[72:75], v28 offset:2080
		ds_read_b128 a[76:79], v28 offset:2272
		ds_read_b128 a[80:83], v28 offset:2336
		ds_read_b128 a[84:87], v28 offset:2528
		ds_read_b128 a[88:91], v28 offset:2592
		ds_read_b128 a[92:95], v28 offset:2784
		ds_read_b128 a[96:99], v28 offset:2848
		s_waitcnt vmcnt(25)
		ds_write_b64 v41, v[32:33] offset:4000
		s_waitcnt vmcnt(24)
		ds_write_b32 v9, v39 offset:6048
		v_add3_u32 v27, v51, v62, v25
		v_lshrrev_b32_e32 v3, 1, v3
		s_waitcnt lgkmcnt(2)
		s_barrier
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v27, v3, 10, v27
		ds_read_b64_tr_b8 v[32:33], v27 offset:4000
		ds_read_b64_tr_b8 v[36:37], v27 offset:4128
		v_lshlrev_b32_e32 v39, 7, v26
		v_add_u32_e32 v39, 0x20000, v39
		v_add3_u32 v39, v39, v62, v25
		v_accvgpr_read_b32 v51, a1
		v_lshl_add_u32 v39, v51, 4, v39
		v_lshl_add_u32 v3, v3, 9, v39
		ds_read_b64_tr_b8 v[68:69], v3 offset:6048
		s_add_i32 s1, s1, -2
		s_add_u32 s20, s2, s14
		s_addc_u32 s21, s3, 0
		s_add_u32 s28, s4, s15
		s_addc_u32 s29, s5, 0
		s_add_u32 s44, s8, s41
		s_addc_u32 s45, s9, 0
		s_add_u32 s48, s10, s42
		s_addc_u32 s49, s11, 0
		s_mov_b32 s50, s26
		s_mov_b32 s51, s27
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_mov_b32 s22, s26
		s_mov_b32 s23, s27
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
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
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
.L_a4w4_kernel.loop_head_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v68, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_u32 s20, s2, s14
		s_addc_u32 s21, s3, 0
		s_add_u32 s28, s4, s15
		s_addc_u32 s29, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v68, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_u32 s48, s10, s42
		s_addc_u32 s49, s11, 0
		s_add_u32 s44, s8, s41
		s_addc_u32 s45, s9, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v68, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s14, s14, 0x100
		s_add_i32 s15, s15, 0x100
		s_add_i32 s41, s41, s40
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v68, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s42, s42, s39
		s_add_i32 s32, s32, 2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v69, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v69, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v69, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v69, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[8:11], v[80:83], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], a[8:11], v[84:87], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], a[16:19], v[100:103], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[16:19], v[96:99], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v69, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v69, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v69, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v69, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[24:27], v[112:115], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], a[24:27], v[116:119], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[32:35], v[132:135], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[32:35], v[128:131], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v68, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v68, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v68, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v68, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v68, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v68, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v68, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v68, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v69, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v69, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v69, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v69, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[40:43], v[144:147], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[40:43], v[148:151], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[48:51], v[164:167], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[48:51], v[160:163], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v69, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v69, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v69, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v69, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[56:59], v[176:179], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[56:59], v[180:183], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[64:67], v[196:199], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[64:67], v[192:195], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v68, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v68, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v68, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v68, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[68:71], v28 offset:35776
		ds_read_b128 a[72:75], v28 offset:35840
		ds_read_b128 a[76:79], v28 offset:36032
		ds_read_b128 a[80:83], v28 offset:36096
		ds_read_b128 a[84:87], v28 offset:36288
		ds_read_b128 a[88:91], v28 offset:36352
		ds_read_b128 a[92:95], v28 offset:36544
		ds_read_b128 a[96:99], v28 offset:36608
		ds_write_b32 v9, v46 offset:6048
		s_mov_b32 m0, s16
		s_waitcnt lgkmcnt(1)
		s_barrier
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		ds_read_b64_tr_b8 v[68:69], v3 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		buffer_load_dwordx2 v[70:71], v21, s[44:47], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v68, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v68, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v68, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		buffer_load_dword v39, v34, s[48:51], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v68, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[8:11], v[200:203], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[8:11], v[204:207], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[16:19], v[220:223], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[16:19], v[216:219], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v69, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v69, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v69, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v69, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[8:11], v[208:211], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], a[8:11], v[212:215], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[96:99], a[16:19], v[228:231], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[16:19], v[224:227], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v69, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[92:95], a[20:23], a[100:103], v69, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v69, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[28:31], a[104:107], v69, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[96:99], a[24:27], a[100:103], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[96:99], a[32:35], a[108:111], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v68, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v68, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[28:31], v[248:251], v68, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x9460
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[28:31], v[244:247], v68, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[24:27], v[232:235], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[24:27], v[236:239], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[80:83], a[32:35], v[248:251], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[32:35], v[244:247], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v68, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v68, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v68, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v68, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v69, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v69, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v69, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v69, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[96:99], a[40:43], a[124:127], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[96:99], a[48:51], a[140:143], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v69, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v69, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v69, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v69, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[96:99], a[56:59], a[156:159], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[96:99], a[64:67], a[172:175], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v68, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v68, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v68, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v68, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[4:7], v63 offset:33792
		ds_read_b128 a[8:11], v63 offset:33856
		ds_read_b128 a[12:15], v63 offset:34048
		ds_read_b128 a[16:19], v63 offset:34112
		ds_read_b128 a[20:23], v63 offset:34304
		ds_read_b128 a[24:27], v63 offset:34368
		ds_read_b128 a[28:31], v63 offset:34560
		ds_read_b128 a[32:35], v63 offset:34624
		ds_read_b128 a[36:39], v63 offset:50688
		ds_read_b128 a[40:43], v63 offset:50752
		ds_read_b128 a[44:47], v63 offset:50944
		ds_read_b128 a[48:51], v63 offset:51008
		ds_read_b128 a[52:55], v63 offset:51200
		ds_read_b128 a[56:59], v63 offset:51264
		ds_read_b128 a[60:63], v63 offset:51456
		ds_read_b128 a[64:67], v63 offset:51520
		ds_read_b128 a[68:71], v28 offset:18912
		ds_read_b128 a[72:75], v28 offset:18976
		ds_read_b128 a[76:79], v28 offset:19168
		ds_read_b128 a[80:83], v28 offset:19232
		ds_read_b128 a[84:87], v28 offset:19424
		ds_read_b128 a[88:91], v28 offset:19488
		ds_read_b128 a[92:95], v28 offset:19680
		ds_read_b128 v[252:255], v28 offset:19744
		ds_write_b64 v41, v[66:67] offset:4000
		ds_write_b32 v9, v42 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[32:33], v27 offset:4000
		ds_read_b64_tr_b8 v[36:37], v27 offset:4128
		ds_read_b64_tr_b8 v[66:67], v3 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		buffer_load_dword v46, v45, s[48:51], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v66, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v66, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v66, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v66, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v66, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v66, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v66, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v66, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v67, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v67, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v67, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v67, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[8:11], v[80:83], v67, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], a[8:11], v[84:87], v67, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], a[16:19], v[100:103], v67, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[16:19], v[96:99], v67, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v67, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v67, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v67, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v67, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[24:27], v[112:115], v67, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], a[24:27], v[116:119], v67, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[32:35], v[132:135], v67, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[32:35], v[128:131], v67, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v66, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v66, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v66, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v66, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v66, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v66, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v66, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v66, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v66, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v66, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v66, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v66, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v66, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v66, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v66, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v66, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v67, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v67, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v67, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v67, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[40:43], v[144:147], v67, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[40:43], v[148:151], v67, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[48:51], v[164:167], v67, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[48:51], v[160:163], v67, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v67, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v67, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v67, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v67, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[56:59], v[176:179], v67, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[56:59], v[180:183], v67, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[64:67], v[196:199], v67, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[64:67], v[192:195], v67, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v66, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v66, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v66, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v66, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v66, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v66, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v66, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v66, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[68:71], v28 offset:52672
		ds_read_b128 a[72:75], v28 offset:52736
		ds_read_b128 a[76:79], v28 offset:52928
		ds_read_b128 a[80:83], v28 offset:52992
		ds_read_b128 a[84:87], v28 offset:53184
		ds_read_b128 a[88:91], v28 offset:53248
		ds_read_b128 a[92:95], v28 offset:53440
		ds_read_b128 v[252:255], v28 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v9, v24 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(1)
		s_barrier
		buffer_load_dwordx4 v44, s[20:23], 0 offen lds
		ds_read_b64_tr_b8 v[68:69], v3 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v47, s[20:23], 0 offen lds
		buffer_load_dwordx2 v[66:67], v20, s[44:47], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[68:71], a[4:7], v[200:203], v68, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], a[4:7], v[204:207], v68, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[12:15], v[220:223], v68, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		buffer_load_dword v42, v23, s[48:51], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[12:15], v[216:219], v68, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[8:11], v[200:203], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[8:11], v[204:207], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[16:19], v[220:223], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[16:19], v[216:219], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[84:87], a[4:7], v[208:211], v69, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], a[4:7], v[212:215], v69, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[92:95], a[12:15], v[228:231], v69, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[12:15], v[224:227], v69, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[8:11], v[208:211], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[8:11], v[212:215], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v53, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[16:19], v[228:231], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[16:19], v[224:227], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[20:23], v[240:243], v69, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[92:95], a[20:23], a[100:103], v69, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v54, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v69, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[28:31], a[104:107], v69, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[24:27], v[240:243], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[252:255], a[24:27], a[100:103], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[20:23], v[232:235], v68, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v52, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[20:23], v[236:239], v68, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x5260
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[76:79], a[28:31], v[248:251], v68, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[28:31], v[244:247], v68, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[24:27], v[232:235], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v55, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[24:27], v[236:239], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[80:83], a[32:35], v[248:251], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[72:75], a[32:35], v[244:247], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v68, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v57, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v68, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v68, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v68, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v58, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v69, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v56, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v69, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v69, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v69, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v69, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v69, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v69, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v69, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v68, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v68, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v68, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v68, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[4:7], v63
		ds_read_b128 a[8:11], v63 offset:64
		ds_read_b128 a[12:15], v63 offset:256
		ds_read_b128 a[16:19], v63 offset:320
		ds_read_b128 a[20:23], v63 offset:512
		ds_read_b128 a[24:27], v63 offset:576
		ds_read_b128 a[28:31], v63 offset:768
		ds_read_b128 a[32:35], v63 offset:832
		ds_read_b128 a[36:39], v63 offset:16896
		ds_read_b128 a[40:43], v63 offset:16960
		ds_read_b128 a[44:47], v63 offset:17152
		ds_read_b128 a[48:51], v63 offset:17216
		ds_read_b128 a[52:55], v63 offset:17408
		ds_read_b128 a[56:59], v63 offset:17472
		ds_read_b128 a[60:63], v63 offset:17664
		ds_read_b128 a[64:67], v63 offset:17728
		ds_read_b128 a[68:71], v28 offset:2016
		ds_read_b128 a[72:75], v28 offset:2080
		ds_read_b128 a[76:79], v28 offset:2272
		ds_read_b128 a[80:83], v28 offset:2336
		ds_read_b128 a[84:87], v28 offset:2528
		ds_read_b128 a[88:91], v28 offset:2592
		ds_read_b128 a[92:95], v28 offset:2784
		ds_read_b128 a[96:99], v28 offset:2848
		ds_write_b64 v41, v[70:71] offset:4000
		ds_write_b32 v9, v39 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		buffer_load_dwordx4 v64, s[28:31], 0 offen lds
		ds_read_b64_tr_b8 v[32:33], v27 offset:4000
		ds_read_b64_tr_b8 v[36:37], v27 offset:4128
		ds_read_b64_tr_b8 v[68:69], v3 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v61, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_cmp_lt_i32 s32, s1
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		buffer_load_dword v24, v22, s[48:51], 0 offen
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[68:71], a[4:7], v[72:75], v68, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[76:79], a[4:7], v[76:79], v68, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], a[12:15], v[92:95], v68, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], a[12:15], v[88:91], v68, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], a[8:11], v[72:75], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[80:83], a[8:11], v[76:79], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[80:83], a[16:19], v[92:95], v68, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[72:75], a[16:19], v[88:91], v68, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[84:87], a[4:7], v[80:83], v69, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], a[4:7], v[84:87], v69, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[92:95], a[12:15], v[100:103], v69, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[84:87], a[12:15], v[96:99], v69, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[88:91], a[8:11], v[80:83], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], a[8:11], v[84:87], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], a[16:19], v[100:103], v69, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[88:91], a[16:19], v[96:99], v69, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[84:87], a[20:23], v[112:115], v69, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[92:95], a[20:23], v[116:119], v69, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[92:95], a[28:31], v[132:135], v69, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], a[28:31], v[128:131], v69, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[24:27], v[112:115], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], a[24:27], v[116:119], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[96:99], a[32:35], v[132:135], v69, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[32:35], v[128:131], v69, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[68:71], a[20:23], v[104:107], v68, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], a[20:23], v[108:111], v68, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[76:79], a[28:31], v[124:127], v68, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[68:71], a[28:31], v[120:123], v68, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], a[24:27], v[104:107], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], a[24:27], v[108:111], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[32:35], v[124:127], v68, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[32:35], v[120:123], v68, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[68:71], a[36:39], v[136:139], v68, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[76:79], a[36:39], v[140:143], v68, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[76:79], a[44:47], v[156:159], v68, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[68:71], a[44:47], v[152:155], v68, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[40:43], v[136:139], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[40:43], v[140:143], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[48:51], v[156:159], v68, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[48:51], v[152:155], v68, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], a[36:39], v[144:147], v69, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], a[36:39], v[148:151], v69, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], a[44:47], v[164:167], v69, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[84:87], a[44:47], v[160:163], v69, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[40:43], v[144:147], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], a[40:43], v[148:151], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], a[48:51], v[164:167], v69, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[48:51], v[160:163], v69, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[84:87], a[52:55], v[176:179], v69, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], a[52:55], v[180:183], v69, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], a[60:63], v[196:199], v69, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[84:87], a[60:63], v[192:195], v69, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[56:59], v[176:179], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], a[56:59], v[180:183], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], a[64:67], v[196:199], v69, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[64:67], v[192:195], v69, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[68:71], a[52:55], v[168:171], v68, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[76:79], a[52:55], v[172:175], v68, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[76:79], a[60:63], v[188:191], v68, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], a[60:63], v[184:187], v68, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[56:59], v[168:171], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[56:59], v[172:175], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[64:67], v[188:191], v68, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[64:67], v[184:187], v68, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 v[12:15], v28 offset:35776
		ds_read_b128 v[16:19], v28 offset:35840
		ds_read_b128 v[20:23], v28 offset:36032
		ds_read_b128 v[48:51], v28 offset:36096
		ds_read_b128 v[52:55], v28 offset:36288
		ds_read_b128 v[56:59], v28 offset:36352
		ds_read_b128 v[68:71], v28 offset:36544
		ds_read_b128 v[252:255], v28 offset:36608
		ds_write_b32 v9, v46 offset:6048
		v_accvgpr_read_b32 v2, a1
		v_lshlrev_b32_e32 v2, 3, v2
		v_accvgpr_read_b32 v4, a0
		v_and_b32_e32 v4, 3, v4
		v_bitop3_b32 v5, v35, v38, v4 bitop3:0x96
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[34:35], v3 offset:6048
		v_lshlrev_b32_e32 v4, 12, v4
		v_lshlrev_b32_e32 v6, 5, v6
		v_lshlrev_b32_e32 v7, 6, v10
		v_lshrrev_b32_e32 v8, 5, v0
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[12:15], a[4:7], v[200:203], v34, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], a[4:7], v[204:207], v34, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[20:23], a[12:15], v[220:223], v34, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[12:15], a[12:15], v[216:219], v34, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[16:19], a[8:11], v[200:203], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], a[8:11], v[204:207], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], a[16:19], v[220:223], v34, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[16:19], a[16:19], v[216:219], v34, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[52:55], a[4:7], v[208:211], v35, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], a[4:7], v[212:215], v35, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[68:71], a[12:15], v[228:231], v35, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], a[12:15], v[224:227], v35, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], a[8:11], v[208:211], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], a[8:11], v[212:215], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[16:19], v[228:231], v35, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], a[16:19], v[224:227], v35, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[52:55], a[20:23], v[240:243], v35, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[68:71], a[20:23], a[100:103], v35, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[68:71], a[28:31], a[108:111], v35, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], a[28:31], a[104:107], v35, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], a[24:27], v[240:243], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[252:255], a[24:27], a[100:103], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v35, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[56:59], a[32:35], a[104:107], v35, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[12:15], a[20:23], v[232:235], v34, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[20:23], a[20:23], v[236:239], v34, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[20:23], a[28:31], v[248:251], v34, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[12:15], a[28:31], v[244:247], v34, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[16:19], a[24:27], v[232:235], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[24:27], v[236:239], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[48:51], a[32:35], v[248:251], v34, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[16:19], a[32:35], v[244:247], v34, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[12:15], a[36:39], a[112:115], v34, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], a[36:39], a[116:119], v34, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], a[44:47], a[132:135], v34, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[12:15], a[44:47], a[128:131], v34, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[16:19], a[40:43], a[112:115], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[40:43], a[116:119], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[48:51], a[132:135], v34, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[16:19], a[48:51], a[128:131], v34, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[36:39], a[120:123], v35, v36 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[68:71], a[36:39], a[124:127], v35, v36 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[68:71], a[44:47], a[140:143], v35, v36 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[44:47], a[136:139], v35, v36 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[40:43], a[120:123], v35, v36 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v35, v36 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v35, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[48:51], a[136:139], v35, v36 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[52:55], a[152:155], v35, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[68:71], a[52:55], a[156:159], v35, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[68:71], a[60:63], a[172:175], v35, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[60:63], a[168:171], v35, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[56:59], a[152:155], v35, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v35, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v35, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[64:67], a[168:171], v35, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[12:15], a[52:55], a[144:147], v34, v37 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], a[52:55], a[148:151], v34, v37 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[20:23], a[60:63], a[164:167], v34, v37 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[12:15], a[60:63], a[160:163], v34, v37 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[16:19], a[56:59], a[144:147], v34, v37 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[56:59], a[148:151], v34, v37 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[64:67], a[164:167], v34, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[16:19], a[64:67], a[160:163], v34, v37 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		s_barrier
		ds_read_b128 v[12:15], v63 offset:33792
		ds_read_b128 v[16:19], v63 offset:33856
		ds_read_b128 v[20:23], v63 offset:34048
		ds_read_b128 v[32:35], v63 offset:34112
		ds_read_b128 a[0:3], v63 offset:34304
		ds_read_b128 a[4:7], v63 offset:34368
		ds_read_b128 a[8:11], v63 offset:34560
		ds_read_b128 a[12:15], v63 offset:34624
		ds_read_b128 a[16:19], v63 offset:50688
		ds_read_b128 a[20:23], v63 offset:50752
		ds_read_b128 a[24:27], v63 offset:50944
		ds_read_b128 a[28:31], v63 offset:51008
		ds_read_b128 a[32:35], v63 offset:51200
		ds_read_b128 a[36:39], v63 offset:51264
		ds_read_b128 a[40:43], v63 offset:51456
		ds_read_b128 a[44:47], v63 offset:51520
		ds_read_b128 v[36:39], v28 offset:18912
		ds_read_b128 v[44:47], v28 offset:18976
		ds_read_b128 v[48:51], v28 offset:19168
		ds_read_b128 v[52:55], v28 offset:19232
		ds_read_b128 v[56:59], v28 offset:19424
		ds_read_b128 v[60:63], v28 offset:19488
		ds_read_b128 v[68:71], v28 offset:19680
		ds_read_b128 v[252:255], v28 offset:19744
		ds_write_b64 v41, v[66:67] offset:4000
		ds_write_b32 v9, v42 offset:6048
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 2, v8
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v27 offset:4000
		ds_read_b64_tr_b8 v[40:41], v27 offset:4128
		ds_read_b64_tr_b8 v[42:43], v3 offset:6048
		v_bitop3_b32 v0, v0, v8, v2 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v0
		v_xor_b32_e32 v8, 1, v0
		v_lshlrev_b32_e32 v8, 4, v8
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[36:39], v[12:15], v[72:75], v42, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[48:51], v[12:15], v[76:79], v42, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[48:51], v[20:23], v[92:95], v42, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[36:39], v[20:23], v[88:91], v42, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[44:47], v[16:19], v[72:75], v42, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[52:55], v[16:19], v[76:79], v42, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[52:55], v[32:35], v[92:95], v42, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[44:47], v[32:35], v[88:91], v42, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[56:59], v[12:15], v[80:83], v43, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], v[12:15], v[84:87], v43, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], v[20:23], v[100:103], v43, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[56:59], v[20:23], v[96:99], v43, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[60:63], v[16:19], v[80:83], v43, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], v[16:19], v[84:87], v43, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], v[32:35], v[100:103], v43, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[60:63], v[32:35], v[96:99], v43, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[56:59], a[0:3], v[112:115], v43, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], a[0:3], v[116:119], v43, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], a[8:11], v[132:135], v43, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[56:59], a[8:11], v[128:131], v43, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[60:63], a[4:7], v[112:115], v43, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], a[4:7], v[116:119], v43, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], a[12:15], v[132:135], v43, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[60:63], a[12:15], v[128:131], v43, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[36:39], a[0:3], v[104:107], v42, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[48:51], a[0:3], v[108:111], v42, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[48:51], a[8:11], v[124:127], v42, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], a[8:11], v[120:123], v42, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[44:47], a[4:7], v[104:107], v42, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[52:55], a[4:7], v[108:111], v42, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[52:55], a[12:15], v[124:127], v42, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[44:47], a[12:15], v[120:123], v42, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], a[16:19], v[136:139], v42, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], a[16:19], v[140:143], v42, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], a[24:27], v[156:159], v42, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], a[24:27], v[152:155], v42, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[44:47], a[20:23], v[136:139], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[52:55], a[20:23], v[140:143], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], a[28:31], v[156:159], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[44:47], a[28:31], v[152:155], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[56:59], a[16:19], v[144:147], v43, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], a[16:19], v[148:151], v43, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[68:71], a[24:27], v[164:167], v43, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], a[24:27], v[160:163], v43, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[60:63], a[20:23], v[144:147], v43, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], a[20:23], v[148:151], v43, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], a[28:31], v[164:167], v43, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[60:63], a[28:31], v[160:163], v43, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], a[32:35], v[176:179], v43, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[68:71], a[32:35], v[180:183], v43, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], a[40:43], v[196:199], v43, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], a[40:43], v[192:195], v43, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], a[36:39], v[176:179], v43, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], a[36:39], v[180:183], v43, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], a[44:47], v[196:199], v43, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], a[44:47], v[192:195], v43, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[32:35], v[168:171], v42, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], a[32:35], v[172:175], v42, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], a[40:43], v[188:191], v42, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[40:43], v[184:187], v42, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[44:47], a[36:39], v[168:171], v42, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], a[36:39], v[172:175], v42, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], a[44:47], v[188:191], v42, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], a[44:47], v[184:187], v42, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[36:39], v28 offset:52672
		ds_read_b128 v[44:47], v28 offset:52736
		ds_read_b128 v[48:51], v28 offset:52928
		ds_read_b128 v[52:55], v28 offset:52992
		ds_read_b128 v[56:59], v28 offset:53184
		ds_read_b128 v[60:63], v28 offset:53248
		ds_read_b128 v[64:67], v28 offset:53440
		ds_read_b128 v[68:71], v28 offset:53504
		s_waitcnt vmcnt(0)
		ds_write_b32 v9, v24 offset:6048
		v_cvt_pk_bf16_f32 v252, v72, v73
		v_cvt_pk_bf16_f32 v253, v74, v75
		v_cvt_pk_bf16_f32 v254, v88, v89
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[42:43], v3 offset:6048
		s_mul_i32 s1, s12, s18
		v_cvt_pk_bf16_f32 v255, v90, v91
		ds_write_b128 v2, v[252:255]
		v_cvt_pk_bf16_f32 v72, v76, v77
		v_cvt_pk_bf16_f32 v73, v78, v79
		v_cvt_pk_bf16_f32 v74, v92, v93
		v_cvt_pk_bf16_f32 v75, v94, v95
		ds_write_b128 v8, v[72:75] offset:4096
		v_cvt_pk_bf16_f32 v72, v80, v81
		v_cvt_pk_bf16_f32 v73, v82, v83
		v_cvt_pk_bf16_f32 v74, v96, v97
		v_cvt_pk_bf16_f32 v75, v98, v99
		v_cvt_pk_bf16_f32 v76, v84, v85
		v_cvt_pk_bf16_f32 v77, v86, v87
		v_cvt_pk_bf16_f32 v78, v100, v101
		v_cvt_pk_bf16_f32 v79, v102, v103
		v_cvt_pk_bf16_f32 v80, v104, v105
		v_cvt_pk_bf16_f32 v81, v106, v107
		v_cvt_pk_bf16_f32 v82, v120, v121
		v_cvt_pk_bf16_f32 v83, v122, v123
		v_cvt_pk_bf16_f32 v84, v108, v109
		v_cvt_pk_bf16_f32 v85, v110, v111
		v_cvt_pk_bf16_f32 v86, v124, v125
		v_cvt_pk_bf16_f32 v87, v126, v127
		v_cvt_pk_bf16_f32 v88, v112, v113
		v_cvt_pk_bf16_f32 v89, v114, v115
		v_cvt_pk_bf16_f32 v90, v128, v129
		v_cvt_pk_bf16_f32 v91, v130, v131
		v_cvt_pk_bf16_f32 v92, v116, v117
		v_cvt_pk_bf16_f32 v93, v118, v119
		v_cvt_pk_bf16_f32 v94, v132, v133
		v_cvt_pk_bf16_f32 v95, v134, v135
		v_cvt_pk_bf16_f32 v96, v136, v137
		v_cvt_pk_bf16_f32 v97, v138, v139
		v_cvt_pk_bf16_f32 v98, v152, v153
		v_cvt_pk_bf16_f32 v99, v154, v155
		v_cvt_pk_bf16_f32 v100, v140, v141
		v_cvt_pk_bf16_f32 v101, v142, v143
		v_cvt_pk_bf16_f32 v102, v156, v157
		v_cvt_pk_bf16_f32 v103, v158, v159
		v_cvt_pk_bf16_f32 v104, v144, v145
		v_cvt_pk_bf16_f32 v105, v146, v147
		v_cvt_pk_bf16_f32 v106, v160, v161
		v_cvt_pk_bf16_f32 v107, v162, v163
		v_cvt_pk_bf16_f32 v108, v148, v149
		v_cvt_pk_bf16_f32 v109, v150, v151
		v_cvt_pk_bf16_f32 v110, v164, v165
		v_cvt_pk_bf16_f32 v111, v166, v167
		v_cvt_pk_bf16_f32 v112, v168, v169
		v_cvt_pk_bf16_f32 v113, v170, v171
		v_cvt_pk_bf16_f32 v114, v184, v185
		v_cvt_pk_bf16_f32 v115, v186, v187
		v_cvt_pk_bf16_f32 v116, v172, v173
		v_cvt_pk_bf16_f32 v117, v174, v175
		v_cvt_pk_bf16_f32 v118, v188, v189
		v_cvt_pk_bf16_f32 v119, v190, v191
		v_cvt_pk_bf16_f32 v120, v176, v177
		v_cvt_pk_bf16_f32 v121, v178, v179
		v_cvt_pk_bf16_f32 v122, v192, v193
		v_cvt_pk_bf16_f32 v123, v194, v195
		v_cvt_pk_bf16_f32 v124, v180, v181
		v_cvt_pk_bf16_f32 v125, v182, v183
		v_cvt_pk_bf16_f32 v126, v196, v197
		v_cvt_pk_bf16_f32 v127, v198, v199
		v_xor_b32_e32 v3, 2, v0
		v_lshlrev_b32_e32 v3, 4, v3
		ds_write_b128 v3, v[72:75] offset:8192
		v_xor_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[76:79] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		v_lshlrev_b32_e32 v9, 2, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v24, v9, v26
		v_add3_u32 v24, v24, v6, v7
		v_xor_b32_e32 v24, v24, v5
		v_lshl_add_u32 v24, v24, 4, v4
		ds_read_b128 v[72:75], v24
		v_add3_u32 v27, 16, v9, v26
		v_add3_u32 v27, v27, v6, v7
		v_xor_b32_e32 v27, v27, v5
		v_lshl_add_u32 v27, v27, 4, v4
		ds_read_b128 v[76:79], v27
		v_add_u32_e32 v28, 0x80, v9
		v_add_u32_e32 v28, v28, v26
		v_add3_u32 v28, v28, v6, v7
		v_xor_b32_e32 v28, v28, v5
		v_lshl_add_u32 v28, v28, 4, v4
		ds_read_b128 v[128:131], v28
		v_add_u32_e32 v9, 0x90, v9
		v_add_u32_e32 v9, v9, v26
		v_add3_u32 v6, v9, v6, v7
		v_xor_b32_e32 v5, v6, v5
		v_lshl_add_u32 v4, v5, 4, v4
		ds_read_b128 v[132:135], v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[80:83]
		ds_write_b128 v8, v[84:87] offset:4096
		ds_write_b128 v3, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v24
		ds_read_b128 v[84:87], v27
		ds_read_b128 v[88:91], v28
		ds_read_b128 v[92:95], v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[96:99]
		ds_write_b128 v8, v[100:103] offset:4096
		ds_write_b128 v3, v[104:107] offset:8192
		ds_write_b128 v0, v[108:111] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[96:99], v24
		ds_read_b128 v[100:103], v27
		ds_read_b128 v[104:107], v28
		ds_read_b128 v[108:111], v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[112:115]
		ds_write_b128 v8, v[116:119] offset:4096
		ds_write_b128 v3, v[120:123] offset:8192
		ds_write_b128 v0, v[124:127] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v24
		ds_read_b128 v[116:119], v27
		ds_read_b128 v[120:123], v28
		ds_read_b128 v[124:127], v4
		v_mul_lo_u32 v1, s18, v1
		v_lshlrev_b32_e32 v1, 2, v1
		v_add_u32_e32 v5, s0, v1
		v_mul_lo_u32 v6, s18, v26
		v_add3_u32 v5, v5, v6, v25
		v_add3_u32 v5, v5, v29, v30
		v_add_lshl_u32 v5, v5, v31, 1
		v_mov_b64_e32 v[136:137], v[72:73]
		v_mov_b64_e32 v[138:139], v[76:77]
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		buffer_store_dwordx4 v[136:139], v5, s[8:11], 0 offen
		s_lshl_b32 s1, s18, 4
		s_add_i32 s2, s1, s0
		v_add3_u32 v5, v1, v6, v25
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v7, v30, v5, s2
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[136:137], v[128:129]
		v_mov_b64_e32 v[138:139], v[132:133]
		buffer_store_dwordx4 v[136:139], v7, s[8:11], 0 offen
		s_lshl_b32 s2, s18, 5
		s_add_i32 s3, s2, s0
		v_add3_u32 v7, v30, v5, s3
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[136:137], v[74:75]
		v_mov_b64_e32 v[138:139], v[78:79]
		buffer_store_dwordx4 v[136:139], v7, s[8:11], 0 offen
		s_mul_i32 s3, 48, s18
		s_add_i32 s4, s3, s0
		v_add3_u32 v5, v30, v5, s4
		v_add_lshl_u32 v5, v5, v31, 1
		v_mov_b64_e32 v[72:73], v[130:131]
		v_mov_b64_e32 v[74:75], v[134:135]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		s_lshl_b32 s4, s18, 6
		s_add_i32 s5, s4, s0
		v_add3_u32 v5, v1, v6, v25
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v7, v30, v5, s5
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[80:81]
		v_mov_b64_e32 v[74:75], v[84:85]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s5, 0x50, s18
		s_add_i32 s6, s5, s0
		v_add3_u32 v7, v30, v5, s6
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[88:89]
		v_mov_b64_e32 v[74:75], v[92:93]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s6, 0x60, s18
		s_add_i32 s7, s6, s0
		v_add3_u32 v5, v30, v5, s7
		v_add_lshl_u32 v5, v5, v31, 1
		v_mov_b64_e32 v[72:73], v[82:83]
		v_mov_b64_e32 v[74:75], v[86:87]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		s_mul_i32 s7, 0x70, s18
		s_add_i32 s12, s7, s0
		v_add3_u32 v5, v1, v6, v25
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v7, v30, v5, s12
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[90:91]
		v_mov_b64_e32 v[74:75], v[94:95]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_lshl_b32 s12, s18, 7
		s_add_i32 s13, s12, s0
		v_add3_u32 v7, v30, v5, s13
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[96:97]
		v_mov_b64_e32 v[74:75], v[100:101]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s13, 0x90, s18
		s_add_i32 s14, s13, s0
		v_add3_u32 v5, v30, v5, s14
		v_add_lshl_u32 v5, v5, v31, 1
		v_mov_b64_e32 v[72:73], v[104:105]
		v_mov_b64_e32 v[74:75], v[108:109]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		s_mul_i32 s14, 0xa0, s18
		s_add_i32 s15, s14, s0
		v_add3_u32 v5, v1, v6, v25
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v7, v30, v5, s15
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[98:99]
		v_mov_b64_e32 v[74:75], v[102:103]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s15, 0xb0, s18
		s_add_i32 s16, s15, s0
		v_add3_u32 v7, v30, v5, s16
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[106:107]
		v_mov_b64_e32 v[74:75], v[110:111]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s16, 0xc0, s18
		s_add_i32 s17, s16, s0
		v_add3_u32 v5, v30, v5, s17
		v_add_lshl_u32 v5, v5, v31, 1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[72:73], v[112:113]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[74:75], v[116:117]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		s_mul_i32 s17, 0xd0, s18
		s_add_i32 s20, s17, s0
		v_add3_u32 v5, v1, v6, v25
		v_add_u32_e32 v5, v5, v29
		v_add3_u32 v7, v30, v5, s20
		v_add_lshl_u32 v7, v7, v31, 1
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[72:73], v[120:121]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[74:75], v[124:125]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s20, 0xe0, s18
		s_add_i32 s21, s20, s0
		v_add3_u32 v7, v30, v5, s21
		v_add_lshl_u32 v7, v7, v31, 1
		v_mov_b64_e32 v[72:73], v[114:115]
		v_mov_b64_e32 v[74:75], v[118:119]
		buffer_store_dwordx4 v[72:75], v7, s[8:11], 0 offen
		s_mul_i32 s18, 0xf0, s18
		s_add_i32 s21, s18, s0
		v_add3_u32 v5, v30, v5, s21
		v_add_lshl_u32 v5, v5, v31, 1
		v_mov_b64_e32 v[72:73], v[122:123]
		v_mov_b64_e32 v[74:75], v[126:127]
		buffer_store_dwordx4 v[72:75], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[12:15], v[200:203], v42, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[12:15], v[204:207], v42, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[20:23], v[220:223], v42, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[20:23], v[216:219], v42, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[16:19], v[200:203], v42, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[16:19], v[204:207], v42, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], v[32:35], v[220:223], v42, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[32:35], v[216:219], v42, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], v[12:15], v[208:211], v43, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[12:15], v[212:215], v43, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[64:67], v[20:23], v[228:231], v43, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], v[20:23], v[224:227], v43, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], v[16:19], v[208:211], v43, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], v[16:19], v[212:215], v43, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[68:71], v[32:35], v[228:231], v43, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], v[32:35], v[224:227], v43, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], a[0:3], v[240:243], v43, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[64:67], a[0:3], a[100:103], v43, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], a[8:11], a[108:111], v43, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[56:59], a[8:11], a[104:107], v43, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[60:63], a[4:7], v[240:243], v43, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[68:71], a[4:7], a[100:103], v43, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[68:71], a[12:15], a[108:111], v43, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[60:63], a[12:15], a[104:107], v43, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[0:3], v[232:235], v42, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], a[0:3], v[236:239], v42, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[48:51], a[8:11], v[248:251], v42, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[36:39], a[8:11], v[244:247], v42, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], a[4:7], v[232:235], v42, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[4:7], v[236:239], v42, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[52:55], a[12:15], v[248:251], v42, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[44:47], a[12:15], v[244:247], v42, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], a[16:19], a[112:115], v42, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[16:19], a[116:119], v42, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[24:27], a[132:135], v42, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], a[24:27], a[128:131], v42, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], a[20:23], a[112:115], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[20:23], a[116:119], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[28:31], a[132:135], v42, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], a[28:31], a[128:131], v42, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[16:19], a[120:123], v43, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[64:67], a[16:19], a[124:127], v43, v40 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[64:67], a[24:27], a[140:143], v43, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[24:27], a[136:139], v43, v40 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[60:63], a[20:23], a[120:123], v43, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[68:71], a[20:23], a[124:127], v43, v40 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[68:71], a[28:31], a[140:143], v43, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[60:63], a[28:31], a[136:139], v43, v40 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[32:35], a[152:155], v43, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[64:67], a[32:35], a[156:159], v43, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[64:67], a[40:43], a[172:175], v43, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[40:43], a[168:171], v43, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[60:63], a[36:39], a[152:155], v43, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[68:71], a[36:39], a[156:159], v43, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[68:71], a[44:47], a[172:175], v43, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[60:63], a[44:47], a[168:171], v43, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], a[32:35], a[144:147], v42, v41 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[32:35], a[148:151], v42, v41 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[40:43], a[164:167], v42, v41 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], a[40:43], a[160:163], v42, v41 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], a[36:39], a[144:147], v42, v41 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], a[36:39], a[148:151], v42, v41 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], a[44:47], a[164:167], v42, v41 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[44:47], a[44:47], a[160:163], v42, v41 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		v_cvt_pk_bf16_f32 v12, v200, v201
		v_cvt_pk_bf16_f32 v13, v202, v203
		v_cvt_pk_bf16_f32 v14, v216, v217
		v_cvt_pk_bf16_f32 v15, v218, v219
		ds_write_b128 v2, v[12:15]
		v_cvt_pk_bf16_f32 v12, v204, v205
		v_cvt_pk_bf16_f32 v13, v206, v207
		v_cvt_pk_bf16_f32 v14, v220, v221
		v_cvt_pk_bf16_f32 v15, v222, v223
		ds_write_b128 v8, v[12:15] offset:4096
		v_cvt_pk_bf16_f32 v12, v208, v209
		v_cvt_pk_bf16_f32 v13, v210, v211
		v_cvt_pk_bf16_f32 v14, v224, v225
		v_cvt_pk_bf16_f32 v15, v226, v227
		ds_write_b128 v3, v[12:15] offset:8192
		v_cvt_pk_bf16_f32 v12, v212, v213
		v_cvt_pk_bf16_f32 v13, v214, v215
		v_cvt_pk_bf16_f32 v14, v228, v229
		v_cvt_pk_bf16_f32 v15, v230, v231
		ds_write_b128 v0, v[12:15] offset:12288
		v_cvt_pk_bf16_f32 v12, v232, v233
		v_cvt_pk_bf16_f32 v13, v234, v235
		v_cvt_pk_bf16_f32 v14, v244, v245
		v_cvt_pk_bf16_f32 v15, v246, v247
		v_cvt_pk_bf16_f32 v16, v236, v237
		v_cvt_pk_bf16_f32 v17, v238, v239
		v_cvt_pk_bf16_f32 v18, v248, v249
		v_cvt_pk_bf16_f32 v19, v250, v251
		v_cvt_pk_bf16_f32 v20, v240, v241
		v_cvt_pk_bf16_f32 v21, v242, v243
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v7, a105
		v_cvt_pk_bf16_f32 v22, v5, v7
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v7, a107
		v_cvt_pk_bf16_f32 v23, v5, v7
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v7, a101
		v_cvt_pk_bf16_f32 v32, v5, v7
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v7, a103
		v_cvt_pk_bf16_f32 v33, v5, v7
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v7, a109
		v_cvt_pk_bf16_f32 v34, v5, v7
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v7, a111
		v_cvt_pk_bf16_f32 v35, v5, v7
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v7, a113
		v_cvt_pk_bf16_f32 v36, v5, v7
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v7, a115
		v_cvt_pk_bf16_f32 v37, v5, v7
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v7, a129
		v_cvt_pk_bf16_f32 v38, v5, v7
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v7, a131
		v_cvt_pk_bf16_f32 v39, v5, v7
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v7, a117
		v_cvt_pk_bf16_f32 v40, v5, v7
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v7, a119
		v_cvt_pk_bf16_f32 v41, v5, v7
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v7, a133
		v_cvt_pk_bf16_f32 v42, v5, v7
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v7, a135
		v_cvt_pk_bf16_f32 v43, v5, v7
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v7, a121
		v_cvt_pk_bf16_f32 v44, v5, v7
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v7, a123
		v_cvt_pk_bf16_f32 v45, v5, v7
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v7, a137
		v_cvt_pk_bf16_f32 v46, v5, v7
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v7, a139
		v_cvt_pk_bf16_f32 v47, v5, v7
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v7, a125
		v_cvt_pk_bf16_f32 v48, v5, v7
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v7, a127
		v_cvt_pk_bf16_f32 v49, v5, v7
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v7, a141
		v_cvt_pk_bf16_f32 v50, v5, v7
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v7, a143
		v_cvt_pk_bf16_f32 v51, v5, v7
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v7, a145
		v_cvt_pk_bf16_f32 v52, v5, v7
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v7, a147
		v_cvt_pk_bf16_f32 v53, v5, v7
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v7, a161
		v_cvt_pk_bf16_f32 v54, v5, v7
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v7, a163
		v_cvt_pk_bf16_f32 v55, v5, v7
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v7, a149
		v_cvt_pk_bf16_f32 v56, v5, v7
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v7, a151
		v_cvt_pk_bf16_f32 v57, v5, v7
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v7, a165
		v_cvt_pk_bf16_f32 v58, v5, v7
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v7, a167
		v_cvt_pk_bf16_f32 v59, v5, v7
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v7, a153
		v_cvt_pk_bf16_f32 v60, v5, v7
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v7, a155
		v_cvt_pk_bf16_f32 v61, v5, v7
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v7, a169
		v_cvt_pk_bf16_f32 v62, v5, v7
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v7, a171
		v_cvt_pk_bf16_f32 v63, v5, v7
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v7, a157
		v_cvt_pk_bf16_f32 v64, v5, v7
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v7, a159
		v_cvt_pk_bf16_f32 v65, v5, v7
		v_accvgpr_read_b32 v5, a172
		v_accvgpr_read_b32 v7, a173
		v_cvt_pk_bf16_f32 v66, v5, v7
		v_accvgpr_read_b32 v5, a174
		v_accvgpr_read_b32 v7, a175
		v_cvt_pk_bf16_f32 v67, v5, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v24
		ds_read_b128 v[72:75], v27
		ds_read_b128 v[76:79], v28
		ds_read_b128 v[80:83], v4
		s_add_i32 s1, s1, 0x80
		s_add_i32 s1, s1, s0
		s_add_i32 s2, s2, 0x80
		s_add_i32 s2, s2, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[12:15]
		ds_write_b128 v8, v[16:19] offset:4096
		ds_write_b128 v3, v[20:23] offset:8192
		ds_write_b128 v0, v[32:35] offset:12288
		s_add_i32 s3, s3, 0x80
		s_add_i32 s3, s3, s0
		s_add_i32 s4, s4, 0x80
		s_add_i32 s4, s4, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v24
		ds_read_b128 v[16:19], v27
		ds_read_b128 v[20:23], v28
		ds_read_b128 v[32:35], v4
		s_add_i32 s5, s5, 0x80
		s_add_i32 s5, s5, s0
		s_add_i32 s6, s6, 0x80
		s_add_i32 s6, s6, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[36:39]
		ds_write_b128 v8, v[40:43] offset:4096
		ds_write_b128 v3, v[44:47] offset:8192
		ds_write_b128 v0, v[48:51] offset:12288
		s_add_i32 s7, s7, 0x80
		s_add_i32 s7, s7, s0
		s_add_i32 s12, s12, 0x80
		s_add_i32 s12, s12, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v24
		ds_read_b128 v[40:43], v27
		ds_read_b128 v[44:47], v28
		ds_read_b128 v[48:51], v4
		s_add_i32 s13, s13, 0x80
		s_add_i32 s13, s13, s0
		s_add_i32 s14, s14, 0x80
		s_add_i32 s14, s14, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[52:55]
		ds_write_b128 v8, v[56:59] offset:4096
		ds_write_b128 v3, v[60:63] offset:8192
		ds_write_b128 v0, v[64:67] offset:12288
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s0
		s_add_i32 s16, s16, 0x80
		s_add_i32 s16, s16, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v24
		ds_read_b128 v[52:55], v27
		ds_read_b128 v[56:59], v28
		ds_read_b128 v[60:63], v4
		v_add_u32_e32 v0, s19, v1
		v_add3_u32 v0, v0, v6, v25
		v_add3_u32 v0, v0, v29, v30
		v_add_lshl_u32 v0, v0, v31, 1
		v_mov_b64_e32 v[64:65], v[68:69]
		v_mov_b64_e32 v[66:67], v[72:73]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		v_add3_u32 v0, v1, v6, v25
		v_add_u32_e32 v0, v0, v29
		v_add3_u32 v2, v30, v0, s1
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[64:65], v[76:77]
		v_mov_b64_e32 v[66:67], v[80:81]
		buffer_store_dwordx4 v[64:67], v2, s[8:11], 0 offen
		v_add3_u32 v2, v30, v0, s2
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[64:65], v[70:71]
		v_mov_b64_e32 v[66:67], v[74:75]
		buffer_store_dwordx4 v[64:67], v2, s[8:11], 0 offen
		v_add3_u32 v0, v30, v0, s3
		v_add_lshl_u32 v0, v0, v31, 1
		v_mov_b64_e32 v[64:65], v[78:79]
		v_mov_b64_e32 v[66:67], v[82:83]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		v_add3_u32 v0, v1, v6, v25
		v_add_u32_e32 v0, v0, v29
		v_add3_u32 v2, v30, v0, s4
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[64:65], v[12:13]
		v_mov_b64_e32 v[66:67], v[16:17]
		buffer_store_dwordx4 v[64:67], v2, s[8:11], 0 offen
		v_add3_u32 v2, v30, v0, s5
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[64:65], v[20:21]
		v_mov_b64_e32 v[66:67], v[32:33]
		buffer_store_dwordx4 v[64:67], v2, s[8:11], 0 offen
		v_add3_u32 v0, v30, v0, s6
		v_add_lshl_u32 v0, v0, v31, 1
		v_mov_b64_e32 v[64:65], v[14:15]
		v_mov_b64_e32 v[66:67], v[18:19]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		v_add3_u32 v0, v1, v6, v25
		v_add_u32_e32 v0, v0, v29
		v_add3_u32 v2, v30, v0, s7
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[12:13], v[22:23]
		v_mov_b64_e32 v[14:15], v[34:35]
		buffer_store_dwordx4 v[12:15], v2, s[8:11], 0 offen
		v_add3_u32 v2, v30, v0, s12
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[12:13], v[36:37]
		v_mov_b64_e32 v[14:15], v[40:41]
		buffer_store_dwordx4 v[12:15], v2, s[8:11], 0 offen
		v_add3_u32 v0, v30, v0, s13
		v_add_lshl_u32 v0, v0, v31, 1
		v_mov_b64_e32 v[12:13], v[44:45]
		v_mov_b64_e32 v[14:15], v[48:49]
		buffer_store_dwordx4 v[12:15], v0, s[8:11], 0 offen
		v_add3_u32 v0, v1, v6, v25
		v_add_u32_e32 v0, v0, v29
		v_add3_u32 v2, v30, v0, s14
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[12:13], v[38:39]
		v_mov_b64_e32 v[14:15], v[42:43]
		buffer_store_dwordx4 v[12:15], v2, s[8:11], 0 offen
		v_add3_u32 v2, v30, v0, s15
		v_add_lshl_u32 v2, v2, v31, 1
		v_mov_b64_e32 v[12:13], v[46:47]
		v_mov_b64_e32 v[14:15], v[50:51]
		buffer_store_dwordx4 v[12:15], v2, s[8:11], 0 offen
		v_add3_u32 v0, v30, v0, s16
		v_add_lshl_u32 v0, v0, v31, 1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[12:13], v[8:9]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[14:15], v[52:53]
		buffer_store_dwordx4 v[12:15], v0, s[8:11], 0 offen
		s_add_i32 s1, s17, 0x80
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, v1, v6, v25
		v_add_u32_e32 v0, v0, v29
		v_add3_u32 v1, v30, v0, s1
		v_add_lshl_u32 v1, v1, v31, 1
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[4:5], v[56:57]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[6:7], v[60:61]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_add_i32 s1, s20, 0x80
		s_add_i32 s1, s1, s0
		v_add3_u32 v1, v30, v0, s1
		v_add_lshl_u32 v1, v1, v31, 1
		v_mov_b64_e32 v[4:5], v[10:11]
		v_mov_b64_e32 v[6:7], v[54:55]
		buffer_store_dwordx4 v[4:7], v1, s[8:11], 0 offen
		s_add_i32 s1, s18, 0x80
		s_add_i32 s0, s1, s0
		v_add3_u32 v0, v30, v0, s0
		v_add_lshl_u32 v0, v0, v31, 1
		v_mov_b64_e32 v[4:5], v[58:59]
		v_mov_b64_e32 v[6:7], v[62:63]
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
		.amdhsa_next_free_vgpr 432
		.amdhsa_next_free_sgpr 56
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
	.set .L_a4w4_kernel.num_agpr, 176
	.set .L_a4w4_kernel.numbered_sgpr, 56
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
      - .name:           arg12
        .offset:         68
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 138144
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     56
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     432
    .agpr_count:     176
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 96
    wave.regalloc.agpr.dwords: 374
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
