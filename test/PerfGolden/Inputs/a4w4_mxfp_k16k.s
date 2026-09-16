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
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		s_add_i32 s1, s12, 0xff
		s_mov_b32 s12, 0xff
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s21, s12, 0
		s_add_i32 s1, s1, s21
		s_ashr_i32 s1, s1, 8
		s_add_i32 s13, s13, 0xff
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s21, s12, 0
		s_add_i32 s13, s13, s21
		s_ashr_i32 s13, s13, 8
		s_and_b32 s21, s16, 7
		s_lshr_b32 s16, s16, 3
		s_cmp_lt_i32 s21, 8
		s_cbranch_scc0 .L_a4w4_kernel.if_else_0
		s_mul_i32 s21, s21, 32
		s_add_i32 s22, s21, s16
		s_branch .L_a4w4_kernel.if_end_0
.L_a4w4_kernel.if_else_0:
		s_sub_i32 s21, s21, 8
		s_mul_i32 s21, s21, 31
		s_add_i32 s21, s21, 0x100
		s_add_i32 s22, s21, s16
.L_a4w4_kernel.if_end_0:
		s_mul_i32 s13, s13, 4
		s_ashr_i32 s16, s22, 31
		s_xor_b32 s21, s22, s16
		s_sub_i32 s21, s21, s16
		s_ashr_i32 s22, s13, 31
		s_xor_b32 s13, s13, s22
		s_sub_i32 s13, s13, s22
		s_xor_b32 s22, s16, s22
		v_mov_b32_e32 v1, s13
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_barrier
		v_readfirstlane_b32 s23, v1
		s_mov_b32 s24, 0
		s_sub_i32 s25, s24, s13
		s_mul_i32 s25, s25, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s21, s23
		s_mul_i32 s25, s23, s13
		s_sub_i32 s21, s21, s25
		s_add_i32 s25, s23, 1
		s_sub_i32 s26, s21, s13
		s_cmp_ge_u32 s21, s13
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s21, s26, s21
		s_add_i32 s25, s23, 1
		s_cmp_ge_u32 s21, s13
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s23, s23, s22
		s_sub_i32 s22, s23, s22
		s_mul_i32 s22, s22, 4
		s_sub_i32 s1, s1, s22
		s_cmp_lt_i32 s1, 4
		s_cselect_b32 s1, s1, 4
		s_sub_i32 s13, s21, s13
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s13, s13, s21
		s_xor_b32 s13, s13, s16
		s_sub_i32 s13, s13, s16
		s_ashr_i32 s16, s13, 31
		s_xor_b32 s13, s13, s16
		s_sub_i32 s13, s13, s16
		v_mov_b32_e32 v1, s1
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_sub_i32 s21, s24, s1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mov_b32 s30, 0x7fffffff
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s21, s21, s23
		s_mul_hi_u32 s21, s23, s21
		s_add_i32 s21, s23, s21
		s_mul_hi_u32 s21, s13, s21
		s_mul_i32 s23, s21, s1
		s_sub_i32 s13, s13, s23
		s_sub_i32 s23, s13, s1
		s_cmp_ge_u32 s13, s1
		s_cselect_b32 s13, s23, s13
		s_cselect_b32 s23, 1, 0
		s_sub_i32 s25, s13, s1
		s_cmp_ge_u32 s13, s1
		s_cselect_b32 s1, s25, s13
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s1, s1, s16
		s_sub_i32 s1, s1, s16
		s_add_i32 s1, s22, s1
		s_add_i32 s22, s21, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s22, s21
		s_add_i32 s22, s21, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s22, s21
		s_xor_b32 s13, s13, s16
		s_sub_i32 s13, s13, s16
		s_mul_i32 s1, s1, 0x100
		s_mul_i32 s16, s1, s15
		s_mul_i32 s13, s13, 0x100
		s_cmp_lt_i32 s14, 0
		s_cselect_b32 s12, s12, 0
		s_add_i32 s12, s14, s12
		s_add_u32 s28, s2, s16
		s_addc_u32 s29, s3, 0
		s_mov_b32 s31, 0x31016000
		s_lshl_b32 s14, s0, 6
		s_lshr_b32 s14, s14, 6
		s_mul_i32 s21, 0x420, s14
		s_mov_b32 m0, s21
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 3, v1
		v_mul_lo_u32 v3, s15, v2
		v_and_b32_e32 v4, 1, v0
		v_lshlrev_b32_e32 v5, 4, v4
		v_lshl_add_u32 v3, v3, 4, v5
		v_lshrrev_b32_e32 v6, 2, v1
		v_accvgpr_write_b32 a0, v6
		v_accvgpr_read_b32 v6, a0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v7, 6, v6
		v_lshrrev_b32_e32 v8, 1, v1
		v_and_b32_e32 v9, 1, v8
		v_lshlrev_b32_e32 v10, 5, v9
		v_add3_u32 v3, v3, v7, v10
		s_mul_i32 s22, s15, s14
		v_add_u32_e32 v11, s22, v3
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s23, s17, 0x80
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s25, s15, 2
		s_add_i32 s26, s25, s22
		v_add_u32_e32 v12, s26, v3
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_mul_i32 s26, s13, s17
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s27, s15, 3
		v_add_u32_e32 v13, s22, v3
		v_add_u32_e32 v14, s27, v13
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s32, s19, 8
		s_add_i32 m0, m0, 0x1080
		s_mul_i32 s33, 12, s15
		v_add_u32_e32 v15, s33, v13
		s_mul_i32 s14, s17, s14
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_mul_i32 s34, s20, 8
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s35, s15, 7
		v_add_u32_e32 v13, s35, v13
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_mul_i32 s36, 0x84, s15
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v16, s22, v3
		v_add_u32_e32 v17, s36, v16
		s_mul_i32 s37, 0x88, s15
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v18, s37, v16
		v_add_u32_e32 v16, s15, v16
		s_mul_i32 s38, 12, s17
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_mul_lo_u32 v19, s17, v2
		s_add_i32 m0, m0, 0x1080
		v_lshl_add_u32 v5, v19, 4, v5
		v_add3_u32 v5, v5, v7, v10
		v_and_b32_e32 v2, 1, v2
		s_mul_i32 s39, s19, s0
		s_mul_i32 s40, s20, s0
		s_mul_i32 s41, 0x84, s17
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_add_u32 s44, s4, s26
		s_addc_u32 s45, s5, 0
		s_add_i32 m0, m0, 0x9460
		v_add_u32_e32 v7, s14, v5
		s_lshl_b32 s42, s17, 2
		s_mov_b32 s46, s30
		s_mov_b32 s47, s31
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_mul_i32 s43, 0x88, s17
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v10, s14, v5
		v_add_u32_e32 v19, s42, v10
		s_lshl_b32 s48, s17, 3
		buffer_load_dwordx4 v19, s[44:47], 0 offen lds
		s_mul_i32 s17, 0x8c, s17
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v20, s48, v10
		v_add_u32_e32 v10, s38, v10
		s_mul_i32 s49, s20, 16
		buffer_load_dwordx4 v20, s[44:47], 0 offen lds
		s_mul_i32 s50, s19, 16
		s_add_i32 m0, m0, 0x1080
		s_lshl_b32 s39, s39, 1
		s_add_i32 s51, s1, s39
		s_lshl_b32 s40, s40, 1
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		v_lshrrev_b32_e32 v21, 5, v1
		v_mul_lo_u32 v22, s19, v21
		v_lshlrev_b32_e32 v23, 3, v4
		v_add3_u32 v24, s51, v22, v23
		v_lshrrev_b32_e32 v25, 4, v1
		v_and_b32_e32 v26, 1, v25
		v_lshlrev_b32_e32 v27, 7, v26
		v_lshlrev_b32_e32 v28, 6, v2
		v_add3_u32 v24, v24, v27, v28
		v_lshlrev_b32_e32 v29, 5, v6
		v_lshlrev_b32_e32 v30, 4, v9
		v_add3_u32 v24, v24, v29, v30
		s_mov_b32 s52, s8
		s_mov_b32 s53, s9
		s_mov_b32 s54, s30
		s_mov_b32 s55, s31
		buffer_load_dwordx2 v[32:33], v24, s[52:55], 0 offen
		s_add_i32 s19, s13, s40
		v_mul_lo_u32 v21, s20, v21
		v_lshlrev_b32_e32 v31, 2, v4
		v_add3_u32 v34, s19, v21, v31
		v_lshlrev_b32_e32 v26, 6, v26
		v_lshlrev_b32_e32 v35, 5, v2
		v_add3_u32 v34, v34, v26, v35
		v_lshlrev_b32_e32 v36, 4, v6
		v_lshlrev_b32_e32 v37, 3, v9
		v_add3_u32 v34, v34, v36, v37
		s_mov_b32 s56, s10
		s_mov_b32 s57, s11
		s_mov_b32 s58, s30
		s_mov_b32 s59, s31
		buffer_load_dword v38, v34, s[56:59], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_add_i32 s19, s23, s14
		v_add_u32_e32 v39, s19, v5
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		v_mov_b32_e32 v40, 0x2100
		v_mul_lo_u32 v40, v40, v2
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v2, s14, v5
		v_add_u32_e32 v41, s41, v2
		buffer_load_dwordx4 v41, s[44:47], 0 offen lds
		v_mov_b32_e32 v42, 0x1080
		v_mul_lo_u32 v42, v42, v6
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v6, s43, v2
		v_add_u32_e32 v2, s17, v2
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		v_and_b32_e32 v1, 15, v1
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s19, s13, 0x80
		s_add_i32 s20, s19, s40
		buffer_load_dwordx4 v2, s[44:47], 0 offen lds
		v_add3_u32 v43, s20, v21, v31
		v_add3_u32 v43, v43, v26, v35
		v_add3_u32 v43, v43, v36, v37
		buffer_load_dword v44, v43, s[56:59], 0 offen
		s_add_i32 m0, m0, 0xfffec6c0
		s_add_i32 s20, s22, 0x80
		v_add_u32_e32 v45, s20, v3
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		s_add_i32 s20, s25, 0x80
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s20, s20, s22
		v_add_u32_e32 v46, s20, v3
		buffer_load_dwordx4 v46, s[28:31], 0 offen lds
		v_add_u32_e32 v47, s22, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v47, 0x80, v47
		v_add_u32_e32 v48, s27, v47
		v_add_u32_e32 v3, s22, v3
		buffer_load_dwordx4 v48, s[28:31], 0 offen lds
		v_add_u32_e32 v3, 0x80, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v49, s33, v47
		v_add_u32_e32 v47, s35, v47
		v_add_u32_e32 v50, s36, v3
		v_add_u32_e32 v51, s37, v3
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s15, v3
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v52, s14, v5
		v_add_u32_e32 v52, 0x80, v52
		v_add_u32_e32 v53, s42, v52
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		v_add_u32_e32 v54, s48, v52
		s_add_i32 m0, m0, 0x1080
		v_add_u32_e32 v52, s38, v52
		v_add_u32_e32 v55, s14, v5
		buffer_load_dwordx4 v50, s[28:31], 0 offen lds
		v_add_u32_e32 v55, 0x80, v55
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s15, s23, 0x80
		v_add_u32_e32 v56, s41, v55
		v_add_u32_e32 v57, s43, v55
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		v_add_u32_e32 v55, s17, v55
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s17, s14, 0x80
		v_add_u32_e32 v58, s17, v5
		v_lshlrev_b32_e32 v59, 4, v8
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_lshlrev_b32_e32 v8, 3, v8
		s_add_i32 m0, m0, 0x5260
		v_mov_b32_e32 v60, 0x840
		v_mul_lo_u32 v60, v60, v9
		v_lshrrev_b32_e32 v61, 2, v1
		buffer_load_dwordx4 v58, s[44:47], 0 offen lds
		v_lshlrev_b32_e32 v61, 5, v61
		s_add_i32 m0, m0, 0x1080
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 1, v1
		s_add_i32 s17, s34, s13
		buffer_load_dwordx4 v53, s[44:47], 0 offen lds
		s_ashr_i32 s12, s12, 8
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s20, s32, s1
		buffer_load_dwordx4 v54, s[44:47], 0 offen lds
		s_mov_b32 s22, s50
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s20, s20, s39
		v_add3_u32 v22, s20, v22, v23
		v_add3_u32 v22, v22, v27, v28
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		v_add3_u32 v22, v22, v29, v30
		buffer_load_dwordx2 v[62:63], v22, s[52:55], 0 offen
		s_add_i32 s17, s17, s40
		v_add3_u32 v27, s17, v21, v31
		v_add3_u32 v27, v27, v26, v35
		v_add3_u32 v27, v27, v36, v37
		buffer_load_dword v64, v27, s[56:59], 0 offen
		s_add_i32 m0, m0, 0x5260
		s_add_i32 s14, s15, s14
		v_add_u32_e32 v5, s14, v5
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		s_mov_b32 s14, s49
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s15, s16, 0x100
		buffer_load_dwordx4 v56, s[44:47], 0 offen lds
		s_add_i32 s16, s26, 0x100
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s17, s34, 0x80
		buffer_load_dwordx4 v57, s[44:47], 0 offen lds
		v_mov_b32_e32 v65, 0x420
		v_mul_lo_u32 v65, v65, v4
		s_add_i32 m0, m0, 0x1080
		s_add_i32 s17, s17, s13
		s_add_i32 s17, s17, s40
		v_add3_u32 v21, s17, v21, v31
		buffer_load_dwordx4 v55, s[44:47], 0 offen lds
		v_add3_u32 v21, v21, v26, v35
		v_add3_u32 v21, v21, v36, v37
		buffer_load_dword v26, v21, s[56:59], 0 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_lshr_b32 s17, s0, 1
		s_lshl_b32 s20, s17, 7
		v_lshl_add_u32 v35, v25, 4, s20
		v_add3_u32 v35, v35, v65, v40
		v_add3_u32 v35, v35, v42, v60
		ds_read_b128 a[4:7], v35
		ds_read_b128 a[8:11], v35 offset:64
		ds_read_b128 a[12:15], v35 offset:256
		ds_read_b128 a[16:19], v35 offset:320
		ds_read_b128 a[20:23], v35 offset:512
		ds_read_b128 a[24:27], v35 offset:576
		ds_read_b128 a[28:31], v35 offset:768
		ds_read_b128 a[32:35], v35 offset:832
		ds_read_b128 a[36:39], v35 offset:16896
		ds_read_b128 a[40:43], v35 offset:16960
		ds_read_b128 a[44:47], v35 offset:17152
		ds_read_b128 a[48:51], v35 offset:17216
		ds_read_b128 a[52:55], v35 offset:17408
		ds_read_b128 a[56:59], v35 offset:17472
		ds_read_b128 a[60:63], v35 offset:17664
		ds_read_b128 a[64:67], v35 offset:17728
		s_and_b32 s20, s0, 1
		s_lshl_b32 s23, s20, 7
		s_add_i32 s23, s23, 0x10000
		v_lshl_add_u32 v36, v25, 4, s23
		v_add3_u32 v36, v36, v65, v40
		v_add3_u32 v36, v36, v42, v60
		ds_read_b128 a[68:71], v36 offset:2016
		ds_read_b128 a[72:75], v36 offset:2080
		ds_read_b128 a[76:79], v36 offset:2272
		ds_read_b128 a[80:83], v36 offset:2336
		ds_read_b128 a[84:87], v36 offset:2528
		ds_read_b128 a[88:91], v36 offset:2592
		ds_read_b128 a[92:95], v36 offset:2784
		ds_read_b128 a[96:99], v36 offset:2848
		s_lshl_b32 s23, s0, 9
		s_add_i32 s23, s23, 0x20000
		v_add3_u32 v37, s23, v59, v23
		s_waitcnt vmcnt(25)
		ds_write_b64 v37, v[32:33] offset:4000
		s_lshl_b32 s23, s0, 8
		s_add_i32 s23, s23, 0x20000
		v_add3_u32 v8, s23, v8, v31
		s_waitcnt vmcnt(24)
		ds_write_b32 v8, v38 offset:6048
		s_waitcnt lgkmcnt(2)
		s_barrier
		s_lshl_b32 s17, s17, 4
		s_add_i32 s17, s17, 0x20000
		v_lshl_add_u32 v31, v25, 8, s17
		v_add3_u32 v31, v31, v61, v23
		v_lshl_add_u32 v31, v1, 10, v31
		ds_read_b64_tr_b8 v[32:33], v31 offset:4000
		ds_read_b64_tr_b8 v[66:67], v31 offset:4128
		s_lshl_b32 s17, s20, 4
		s_add_i32 s17, s17, 0x20000
		v_lshl_add_u32 v38, v25, 7, s17
		v_add3_u32 v38, v38, v61, v23
		v_lshl_add_u32 v1, v1, 9, v38
		ds_read_b64_tr_b8 v[60:61], v1 offset:6048
		s_sub_i32 s12, s12, 2
		s_add_u32 s32, s2, s15
		s_addc_u32 s33, s3, 0
		s_add_u32 s36, s4, s16
		s_addc_u32 s37, s5, 0
		s_add_u32 s40, s8, s22
		s_addc_u32 s41, s9, 0
		s_add_u32 s44, s10, s14
		s_addc_u32 s45, s11, 0
		s_mov_b32 s46, s30
		s_mov_b32 s47, s31
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
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
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v60, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_u32 s32, s2, s15
		s_addc_u32 s33, s3, 0
		s_add_u32 s36, s4, s16
		s_addc_u32 s37, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v60, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_u32 s44, s10, s14
		s_addc_u32 s45, s11, 0
		s_add_u32 s40, s8, s22
		s_addc_u32 s41, s9, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v60, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s15, s15, 0x100
		s_add_i32 s16, s16, 0x100
		s_add_i32 s22, s22, s50
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v60, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 s14, s14, s49
		s_add_i32 s24, s24, 2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v61, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v61, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v61, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v61, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v61, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v61, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v61, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v61, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v60, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v60, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v60, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v60, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v60, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v60, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v60, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v60, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v61, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v61, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v61, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v61, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v61, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v61, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v61, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v61, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v60, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v60, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v60, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v60, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[68:71], v36 offset:35776
		ds_read_b128 a[72:75], v36 offset:35840
		ds_read_b128 a[76:79], v36 offset:36032
		ds_read_b128 a[80:83], v36 offset:36096
		ds_read_b128 a[84:87], v36 offset:36288
		ds_read_b128 a[88:91], v36 offset:36352
		ds_read_b128 a[92:95], v36 offset:36544
		ds_read_b128 a[96:99], v36 offset:36608
		ds_write_b32 v8, v44 offset:6048
		s_mov_b32 m0, s21
		s_waitcnt lgkmcnt(1)
		s_barrier
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[60:61], v1 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[248:249], v24, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v60, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v60, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v60, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		buffer_load_dword v38, v34, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v60, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v61, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v61, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v61, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v61, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], a[8:11], v[208:211], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], a[16:19], v[224:227], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v61, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[92:95], a[20:23], a[100:103], v61, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v61, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[28:31], a[104:107], v61, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[96:99], a[24:27], a[100:103], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[96:99], a[32:35], a[108:111], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v60, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v60, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v60, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x9460
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v60, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[32:35], v[244:247], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[32:35], v[240:243], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v60, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v60, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v60, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v60, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v61, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v61, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v61, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v61, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[96:99], a[40:43], a[124:127], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[96:99], a[48:51], a[140:143], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v61, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v61, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v61, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v61, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[96:99], a[56:59], a[156:159], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[96:99], a[64:67], a[172:175], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v60, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v60, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v60, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v60, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[4:7], v35 offset:33792
		ds_read_b128 a[8:11], v35 offset:33856
		ds_read_b128 a[12:15], v35 offset:34048
		ds_read_b128 a[16:19], v35 offset:34112
		ds_read_b128 a[20:23], v35 offset:34304
		ds_read_b128 a[24:27], v35 offset:34368
		ds_read_b128 a[28:31], v35 offset:34560
		ds_read_b128 a[32:35], v35 offset:34624
		ds_read_b128 a[36:39], v35 offset:50688
		ds_read_b128 a[40:43], v35 offset:50752
		ds_read_b128 a[44:47], v35 offset:50944
		ds_read_b128 a[48:51], v35 offset:51008
		ds_read_b128 a[52:55], v35 offset:51200
		ds_read_b128 a[56:59], v35 offset:51264
		ds_read_b128 a[60:63], v35 offset:51456
		ds_read_b128 a[64:67], v35 offset:51520
		ds_read_b128 a[68:71], v36 offset:18912
		ds_read_b128 a[72:75], v36 offset:18976
		ds_read_b128 a[76:79], v36 offset:19168
		ds_read_b128 a[80:83], v36 offset:19232
		ds_read_b128 a[84:87], v36 offset:19424
		ds_read_b128 a[88:91], v36 offset:19488
		ds_read_b128 a[92:95], v36 offset:19680
		ds_read_b128 v[252:255], v36 offset:19744
		ds_write_b64 v37, v[62:63] offset:4000
		ds_write_b32 v8, v64 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		buffer_load_dwordx4 v39, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[32:33], v31 offset:4000
		ds_read_b64_tr_b8 v[60:61], v31 offset:4128
		ds_read_b64_tr_b8 v[62:63], v1 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v41, s[36:39], 0 offen lds
		buffer_load_dword v44, v43, s[44:47], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v62, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v62, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v62, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v62, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v62, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v62, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v62, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v2, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v62, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v63, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v63, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v63, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v63, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v63, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[8:11], v[80:83], v63, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[16:19], v[96:99], v63, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v63, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v63, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v63, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v63, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v63, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v63, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[24:27], v[112:115], v63, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[32:35], v[128:131], v63, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v63, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v62, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v62, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v62, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v62, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v62, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v62, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v62, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v62, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v62, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v62, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v62, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v62, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v62, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v62, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v62, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v62, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v63, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v63, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v63, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v63, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v63, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[40:43], v[144:147], v63, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[48:51], v[160:163], v63, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v63, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v63, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v63, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v63, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v63, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v63, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[56:59], v[176:179], v63, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[64:67], v[192:195], v63, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v63, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v62, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v62, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v62, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v62, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v62, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v62, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v62, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v62, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		s_barrier
		ds_read_b128 a[68:71], v36 offset:52672
		ds_read_b128 a[72:75], v36 offset:52736
		ds_read_b128 a[76:79], v36 offset:52928
		ds_read_b128 a[80:83], v36 offset:52992
		ds_read_b128 a[84:87], v36 offset:53184
		ds_read_b128 a[88:91], v36 offset:53248
		ds_read_b128 a[92:95], v36 offset:53440
		ds_read_b128 v[252:255], v36 offset:53504
		s_waitcnt vmcnt(19)
		ds_write_b32 v8, v26 offset:6048
		s_add_i32 m0, m0, 0xfffec6c0
		s_waitcnt lgkmcnt(1)
		s_barrier
		buffer_load_dwordx4 v45, s[32:35], 0 offen lds
		ds_read_b64_tr_b8 v[66:67], v1 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v46, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[62:63], v22, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[4:7], v[196:199], v66, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[4:7], v[200:203], v66, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[12:15], v[216:219], v66, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v48, s[32:35], 0 offen lds
		buffer_load_dword v64, v27, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[12:15], v[212:215], v66, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], a[8:11], v[196:199], v66, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[80:83], a[8:11], v[200:203], v66, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v49, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[80:83], a[16:19], v[216:219], v66, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[72:75], a[16:19], v[212:215], v66, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[4:7], v[204:207], v67, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[4:7], v[208:211], v67, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[12:15], v[224:227], v67, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[12:15], v[220:223], v67, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[88:91], a[8:11], v[204:207], v67, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v67, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v50, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v67, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[88:91], a[16:19], v[220:223], v67, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[20:23], v[236:239], v67, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[92:95], a[20:23], a[100:103], v67, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v51, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[28:31], a[108:111], v67, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[28:31], a[104:107], v67, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[88:91], a[24:27], v[236:239], v67, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[252:255], a[24:27], a[100:103], v67, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v67, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v67, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[20:23], v[228:231], v66, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[20:23], v[232:235], v66, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x5260
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[76:79], a[28:31], v[244:247], v66, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[28:31], v[240:243], v66, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[24:27], v[228:231], v66, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[80:83], a[24:27], v[232:235], v66, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[80:83], a[32:35], v[244:247], v66, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[32:35], v[240:243], v66, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[36:39], a[112:115], v66, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[36:39], a[116:119], v66, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[44:47], a[132:135], v66, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[44:47], a[128:131], v66, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v66, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v66, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1080
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v66, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v66, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[36:39], a[120:123], v67, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[36:39], a[124:127], v67, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[44:47], a[140:143], v67, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[44:47], a[136:139], v67, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v67, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v67, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v67, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v67, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[52:55], a[152:155], v67, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[52:55], a[156:159], v67, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[60:63], a[172:175], v67, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[60:63], a[168:171], v67, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v67, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v67, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v67, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[64:67], a[168:171], v67, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[52:55], a[144:147], v66, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[52:55], a[148:151], v66, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[60:63], a[164:167], v66, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[60:63], a[160:163], v66, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v66, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v66, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[64:67], a[164:167], v66, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[64:67], a[160:163], v66, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 a[4:7], v35
		ds_read_b128 a[8:11], v35 offset:64
		ds_read_b128 a[12:15], v35 offset:256
		ds_read_b128 a[16:19], v35 offset:320
		ds_read_b128 a[20:23], v35 offset:512
		ds_read_b128 a[24:27], v35 offset:576
		ds_read_b128 a[28:31], v35 offset:768
		ds_read_b128 a[32:35], v35 offset:832
		ds_read_b128 a[36:39], v35 offset:16896
		ds_read_b128 a[40:43], v35 offset:16960
		ds_read_b128 a[44:47], v35 offset:17152
		ds_read_b128 a[48:51], v35 offset:17216
		ds_read_b128 a[52:55], v35 offset:17408
		ds_read_b128 a[56:59], v35 offset:17472
		ds_read_b128 a[60:63], v35 offset:17664
		ds_read_b128 a[64:67], v35 offset:17728
		ds_read_b128 a[68:71], v36 offset:2016
		ds_read_b128 a[72:75], v36 offset:2080
		ds_read_b128 a[76:79], v36 offset:2272
		ds_read_b128 a[80:83], v36 offset:2336
		ds_read_b128 a[84:87], v36 offset:2528
		ds_read_b128 a[88:91], v36 offset:2592
		ds_read_b128 a[92:95], v36 offset:2784
		ds_read_b128 a[96:99], v36 offset:2848
		ds_write_b64 v37, v[248:249] offset:4000
		ds_write_b32 v8, v38 offset:6048
		s_add_i32 m0, m0, 0x5260
		s_waitcnt lgkmcnt(2)
		s_barrier
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		ds_read_b64_tr_b8 v[32:33], v31 offset:4000
		ds_read_b64_tr_b8 v[66:67], v31 offset:4128
		ds_read_b64_tr_b8 v[60:61], v1 offset:6048
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_nop 0
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1080
		s_cmp_lt_i32 s24, s12
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		buffer_load_dword v26, v21, s[44:47], 0 offen
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], a[4:7], v[68:71], v60, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[76:79], a[4:7], v[72:75], v60, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], a[12:15], v[88:91], v60, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], a[12:15], v[84:87], v60, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[72:75], a[8:11], v[68:71], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[80:83], a[8:11], v[72:75], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[80:83], a[16:19], v[88:91], v60, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], a[16:19], v[84:87], v60, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[84:87], a[4:7], v[76:79], v61, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[92:95], a[4:7], v[80:83], v61, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], a[12:15], v[96:99], v61, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[84:87], a[12:15], v[92:95], v61, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[88:91], a[8:11], v[76:79], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], a[8:11], v[80:83], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], a[16:19], v[96:99], v61, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[88:91], a[16:19], v[92:95], v61, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[84:87], a[20:23], v[108:111], v61, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[20:23], v[112:115], v61, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[28:31], v[128:131], v61, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[28:31], v[124:127], v61, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], a[24:27], v[108:111], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], a[24:27], v[112:115], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[96:99], a[32:35], v[128:131], v61, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], a[32:35], v[124:127], v61, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[68:71], a[20:23], v[100:103], v60, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[76:79], a[20:23], v[104:107], v60, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[28:31], v[120:123], v60, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[28:31], v[116:119], v60, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], a[24:27], v[100:103], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], a[24:27], v[104:107], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[80:83], a[32:35], v[120:123], v60, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[72:75], a[32:35], v[116:119], v60, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[36:39], v[132:135], v60, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[36:39], v[136:139], v60, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[44:47], v[152:155], v60, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[44:47], v[148:151], v60, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[72:75], a[40:43], v[132:135], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], a[40:43], v[136:139], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[80:83], a[48:51], v[152:155], v60, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[72:75], a[48:51], v[148:151], v60, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[36:39], v[140:143], v61, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[36:39], v[144:147], v61, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[44:47], v[160:163], v61, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[44:47], v[156:159], v61, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], a[40:43], v[140:143], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], a[40:43], v[144:147], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], a[48:51], v[160:163], v61, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], a[48:51], v[156:159], v61, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[52:55], v[172:175], v61, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[52:55], v[176:179], v61, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[60:63], v[192:195], v61, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[60:63], v[188:191], v61, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], a[56:59], v[172:175], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], a[56:59], v[176:179], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], a[64:67], v[192:195], v61, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], a[64:67], v[188:191], v61, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[52:55], v[164:167], v60, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[52:55], v[168:171], v60, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[60:63], v[184:187], v60, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[60:63], v[180:183], v60, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[72:75], a[56:59], v[164:167], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[80:83], a[56:59], v[168:171], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[80:83], a[64:67], v[184:187], v60, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[72:75], a[64:67], v[180:183], v60, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(19)
		s_barrier
		ds_read_b128 v[12:15], v36 offset:35776
		ds_read_b128 v[16:19], v36 offset:35840
		ds_read_b128 v[40:43], v36 offset:36032
		ds_read_b128 v[48:51], v36 offset:36096
		ds_read_b128 v[52:55], v36 offset:36288
		ds_read_b128 v[56:59], v36 offset:36352
		ds_read_b128 v[248:251], v36 offset:36544
		ds_read_b128 v[252:255], v36 offset:36608
		ds_write_b32 v8, v44 offset:6048
		v_accvgpr_read_b32 v2, a0
		v_and_b32_e32 v2, 3, v2
		s_lshl_b32 s2, s0, 2
		s_add_i32 s3, s2, 0x80
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v1 offset:6048
		s_add_i32 s4, s2, 0x90
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[12:15], a[4:7], v[196:199], v6, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], a[4:7], v[200:203], v6, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], a[12:15], v[216:219], v6, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[12:15], a[12:15], v[212:215], v6, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[16:19], a[8:11], v[196:199], v6, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[48:51], a[8:11], v[200:203], v6, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], a[16:19], v[216:219], v6, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[16:19], a[16:19], v[212:215], v6, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], a[4:7], v[204:207], v7, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[248:251], a[4:7], v[208:211], v7, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[248:251], a[12:15], v[224:227], v7, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], a[12:15], v[220:223], v7, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], a[8:11], v[204:207], v7, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[8:11], v[208:211], v7, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[16:19], v[224:227], v7, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], a[16:19], v[220:223], v7, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[20:23], v[236:239], v7, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[248:251], a[20:23], a[100:103], v7, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[248:251], a[28:31], a[108:111], v7, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], a[28:31], a[104:107], v7, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], a[24:27], v[236:239], v7, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[252:255], a[24:27], a[100:103], v7, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[32:35], a[108:111], v7, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[56:59], a[32:35], a[104:107], v7, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[12:15], a[20:23], v[228:231], v6, v33 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], a[20:23], v[232:235], v6, v33 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], a[28:31], v[244:247], v6, v33 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[12:15], a[28:31], v[240:243], v6, v33 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[16:19], a[24:27], v[228:231], v6, v33 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], a[24:27], v[232:235], v6, v33 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[32:35], v[244:247], v6, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[16:19], a[32:35], v[240:243], v6, v33 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[12:15], a[36:39], a[112:115], v6, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[36:39], a[116:119], v6, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[44:47], a[132:135], v6, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[12:15], a[44:47], a[128:131], v6, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[16:19], a[40:43], a[112:115], v6, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[40:43], a[116:119], v6, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[48:51], a[132:135], v6, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[16:19], a[48:51], a[128:131], v6, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[36:39], a[120:123], v7, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[248:251], a[36:39], a[124:127], v7, v66 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[248:251], a[44:47], a[140:143], v7, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[44:47], a[136:139], v7, v66 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[40:43], a[120:123], v7, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[40:43], a[124:127], v7, v66 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[48:51], a[140:143], v7, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[48:51], a[136:139], v7, v66 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[52:55], a[152:155], v7, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[248:251], a[52:55], a[156:159], v7, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[248:251], a[60:63], a[172:175], v7, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[60:63], a[168:171], v7, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[56:59], a[152:155], v7, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[56:59], a[156:159], v7, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[64:67], a[172:175], v7, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[64:67], a[168:171], v7, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[12:15], a[52:55], a[144:147], v6, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], a[52:55], a[148:151], v6, v67 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], a[60:63], a[164:167], v6, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[12:15], a[60:63], a[160:163], v6, v67 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[16:19], a[56:59], a[144:147], v6, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[56:59], a[148:151], v6, v67 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[64:67], a[164:167], v6, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[16:19], a[64:67], a[160:163], v6, v67 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		s_barrier
		ds_read_b128 v[12:15], v35 offset:33792
		ds_read_b128 a[0:3], v35 offset:33856
		ds_read_b128 v[16:19], v35 offset:34048
		ds_read_b128 a[4:7], v35 offset:34112
		ds_read_b128 a[8:11], v35 offset:34304
		ds_read_b128 a[12:15], v35 offset:34368
		ds_read_b128 a[16:19], v35 offset:34560
		ds_read_b128 a[20:23], v35 offset:34624
		ds_read_b128 a[24:27], v35 offset:50688
		ds_read_b128 a[28:31], v35 offset:50752
		ds_read_b128 a[32:35], v35 offset:50944
		ds_read_b128 a[36:39], v35 offset:51008
		ds_read_b128 a[40:43], v35 offset:51200
		ds_read_b128 a[44:47], v35 offset:51264
		ds_read_b128 a[48:51], v35 offset:51456
		ds_read_b128 a[52:55], v35 offset:51520
		ds_read_b128 v[32:35], v36 offset:18912
		ds_read_b128 v[40:43], v36 offset:18976
		ds_read_b128 v[44:47], v36 offset:19168
		ds_read_b128 v[48:51], v36 offset:19232
		ds_read_b128 v[52:55], v36 offset:19424
		ds_read_b128 v[56:59], v36 offset:19488
		ds_read_b128 v[248:251], v36 offset:19680
		ds_read_b128 v[252:255], v36 offset:19744
		ds_write_b64 v37, v[62:63] offset:4000
		ds_write_b32 v8, v64 offset:6048
		s_waitcnt lgkmcnt(2)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v31 offset:4000
		ds_read_b64_tr_b8 v[10:11], v31 offset:4128
		ds_read_b64_tr_b8 v[20:21], v1 offset:6048
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[32:35], v[12:15], v[68:71], v20, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[44:47], v[12:15], v[72:75], v20, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[44:47], v[16:19], v[88:91], v20, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[16:19], v[84:87], v20, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[40:43], a[0:3], v[68:71], v20, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[48:51], a[0:3], v[72:75], v20, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[48:51], a[4:7], v[88:91], v20, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[40:43], a[4:7], v[84:87], v20, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[52:55], v[12:15], v[76:79], v21, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[248:251], v[12:15], v[80:83], v21, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[248:251], v[16:19], v[96:99], v21, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[52:55], v[16:19], v[92:95], v21, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[56:59], a[0:3], v[76:79], v21, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], a[0:3], v[80:83], v21, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[252:255], a[4:7], v[96:99], v21, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[56:59], a[4:7], v[92:95], v21, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[52:55], a[8:11], v[108:111], v21, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[248:251], a[8:11], v[112:115], v21, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[248:251], a[16:19], v[128:131], v21, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[52:55], a[16:19], v[124:127], v21, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[56:59], a[12:15], v[108:111], v21, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], a[12:15], v[112:115], v21, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[20:23], v[128:131], v21, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[56:59], a[20:23], v[124:127], v21, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[8:11], v[100:103], v20, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[44:47], a[8:11], v[104:107], v20, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[44:47], a[16:19], v[120:123], v20, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], a[16:19], v[116:119], v20, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[40:43], a[12:15], v[100:103], v20, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[48:51], a[12:15], v[104:107], v20, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[48:51], a[20:23], v[120:123], v20, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], a[20:23], v[116:119], v20, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], a[24:27], v[132:135], v20, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[44:47], a[24:27], v[136:139], v20, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[44:47], a[32:35], v[152:155], v20, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], a[32:35], v[148:151], v20, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], a[28:31], v[132:135], v20, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[48:51], a[28:31], v[136:139], v20, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], a[36:39], v[152:155], v20, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], a[36:39], v[148:151], v20, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[52:55], a[24:27], v[140:143], v21, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[248:251], a[24:27], v[144:147], v21, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[248:251], a[32:35], v[160:163], v21, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], a[32:35], v[156:159], v21, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[56:59], a[28:31], v[140:143], v21, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[28:31], v[144:147], v21, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[36:39], v[160:163], v21, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], a[36:39], v[156:159], v21, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], a[40:43], v[172:175], v21, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[248:251], a[40:43], v[176:179], v21, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[248:251], a[48:51], v[192:195], v21, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], a[48:51], v[188:191], v21, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], a[44:47], v[172:175], v21, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[44:47], v[176:179], v21, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[52:55], v[192:195], v21, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], a[52:55], v[188:191], v21, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], a[40:43], v[164:167], v20, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[44:47], a[40:43], v[168:171], v20, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], a[48:51], v[184:187], v20, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], a[48:51], v[180:183], v20, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], a[44:47], v[164:167], v20, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], a[44:47], v[168:171], v20, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[48:51], a[52:55], v[184:187], v20, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], a[52:55], v[180:183], v20, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		s_barrier
		ds_read_b128 v[32:35], v36 offset:52672
		ds_read_b128 v[40:43], v36 offset:52736
		ds_read_b128 v[44:47], v36 offset:52928
		ds_read_b128 v[48:51], v36 offset:52992
		ds_read_b128 v[52:55], v36 offset:53184
		ds_read_b128 v[56:59], v36 offset:53248
		ds_read_b128 v[60:63], v36 offset:53440
		ds_read_b128 v[64:67], v36 offset:53504
		s_waitcnt vmcnt(0)
		ds_write_b32 v8, v26 offset:6048
		v_cvt_pk_bf16_f32 v36, v68, v69
		v_cvt_pk_bf16_f32 v37, v70, v71
		v_cvt_pk_bf16_f32 v38, v84, v85
		s_waitcnt lgkmcnt(1)
		s_barrier
		ds_read_b64_tr_b8 v[20:21], v1 offset:6048
		s_mul_i32 s1, s1, s18
		v_cvt_pk_bf16_f32 v39, v86, v87
		v_cvt_pk_bf16_f32 v68, v72, v73
		v_cvt_pk_bf16_f32 v69, v74, v75
		v_cvt_pk_bf16_f32 v70, v88, v89
		v_cvt_pk_bf16_f32 v71, v90, v91
		v_cvt_pk_bf16_f32 v72, v76, v77
		v_cvt_pk_bf16_f32 v73, v78, v79
		v_cvt_pk_bf16_f32 v74, v92, v93
		v_cvt_pk_bf16_f32 v75, v94, v95
		v_cvt_pk_bf16_f32 v76, v80, v81
		v_cvt_pk_bf16_f32 v77, v82, v83
		v_cvt_pk_bf16_f32 v78, v96, v97
		v_cvt_pk_bf16_f32 v79, v98, v99
		v_cvt_pk_bf16_f32 v80, v100, v101
		v_cvt_pk_bf16_f32 v81, v102, v103
		v_cvt_pk_bf16_f32 v82, v116, v117
		v_cvt_pk_bf16_f32 v83, v118, v119
		v_cvt_pk_bf16_f32 v84, v104, v105
		v_cvt_pk_bf16_f32 v85, v106, v107
		v_cvt_pk_bf16_f32 v86, v120, v121
		v_cvt_pk_bf16_f32 v87, v122, v123
		v_cvt_pk_bf16_f32 v88, v108, v109
		v_cvt_pk_bf16_f32 v89, v110, v111
		v_cvt_pk_bf16_f32 v90, v124, v125
		v_cvt_pk_bf16_f32 v91, v126, v127
		v_cvt_pk_bf16_f32 v92, v112, v113
		v_cvt_pk_bf16_f32 v93, v114, v115
		v_cvt_pk_bf16_f32 v94, v128, v129
		v_cvt_pk_bf16_f32 v95, v130, v131
		v_cvt_pk_bf16_f32 v96, v132, v133
		v_cvt_pk_bf16_f32 v97, v134, v135
		v_cvt_pk_bf16_f32 v98, v148, v149
		v_cvt_pk_bf16_f32 v99, v150, v151
		v_cvt_pk_bf16_f32 v100, v136, v137
		v_cvt_pk_bf16_f32 v101, v138, v139
		v_cvt_pk_bf16_f32 v102, v152, v153
		v_cvt_pk_bf16_f32 v103, v154, v155
		v_cvt_pk_bf16_f32 v104, v140, v141
		v_cvt_pk_bf16_f32 v105, v142, v143
		v_cvt_pk_bf16_f32 v106, v156, v157
		v_cvt_pk_bf16_f32 v107, v158, v159
		v_cvt_pk_bf16_f32 v108, v144, v145
		v_cvt_pk_bf16_f32 v109, v146, v147
		v_cvt_pk_bf16_f32 v110, v160, v161
		v_cvt_pk_bf16_f32 v111, v162, v163
		v_cvt_pk_bf16_f32 v112, v164, v165
		v_cvt_pk_bf16_f32 v113, v166, v167
		v_cvt_pk_bf16_f32 v114, v180, v181
		v_cvt_pk_bf16_f32 v115, v182, v183
		v_cvt_pk_bf16_f32 v116, v168, v169
		v_cvt_pk_bf16_f32 v117, v170, v171
		v_cvt_pk_bf16_f32 v118, v184, v185
		v_cvt_pk_bf16_f32 v119, v186, v187
		v_cvt_pk_bf16_f32 v120, v172, v173
		v_cvt_pk_bf16_f32 v121, v174, v175
		v_cvt_pk_bf16_f32 v122, v188, v189
		v_cvt_pk_bf16_f32 v123, v190, v191
		v_cvt_pk_bf16_f32 v124, v176, v177
		v_cvt_pk_bf16_f32 v125, v178, v179
		v_cvt_pk_bf16_f32 v126, v192, v193
		v_cvt_pk_bf16_f32 v127, v194, v195
		v_lshrrev_b32_e32 v1, 4, v0
		v_bitop3_b32 v0, v0, 6, v1 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v0
		ds_write_b128 v1, v[36:39]
		v_xor_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 4, v0
		ds_write_b128 v0, v[68:71] offset:4096
		ds_write_b128 v1, v[72:75] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		v_lshlrev_b32_e32 v3, 12, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v5, s2, v25
		v_lshlrev_b32_e32 v8, 5, v4
		v_lshlrev_b32_e32 v22, 6, v9
		v_add3_u32 v5, v5, v8, v22
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v9, 2, v9
		v_add_u32_e32 v24, v4, v9
		v_and_b32_e32 v24, 6, v24
		v_bitop3_b32 v5, v5, v2, v24 bitop3:0x96
		v_lshl_add_u32 v5, v5, 4, v3
		ds_read_b128 v[36:39], v5
		v_add3_u32 v24, s2, 16, v25
		v_add3_u32 v24, v24, v8, v22
		v_add3_u32 v26, 1, v4, v9
		v_and_b32_e32 v26, 6, v26
		v_bitop3_b32 v24, v24, v2, v26 bitop3:0x96
		v_lshl_add_u32 v24, v24, 4, v3
		ds_read_b128 v[68:71], v24
		v_add_u32_e32 v26, s3, v25
		v_add3_u32 v26, v26, v8, v22
		v_add3_u32 v27, 8, v4, v9
		v_and_b32_e32 v27, 6, v27
		v_bitop3_b32 v26, v26, v2, v27 bitop3:0x96
		v_lshl_add_u32 v26, v26, 4, v3
		ds_read_b128 v[72:75], v26
		v_add_u32_e32 v27, s4, v25
		v_add3_u32 v8, v27, v8, v22
		v_add3_u32 v4, 9, v4, v9
		v_and_b32_e32 v4, 6, v4
		v_bitop3_b32 v2, v8, v2, v4 bitop3:0x96
		v_lshl_add_u32 v2, v2, 4, v3
		ds_read_b128 v[76:79], v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v1, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v5
		ds_read_b128 v[84:87], v24
		ds_read_b128 v[88:91], v26
		ds_read_b128 v[92:95], v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[96:99]
		ds_write_b128 v0, v[100:103] offset:4096
		ds_write_b128 v1, v[104:107] offset:8192
		ds_write_b128 v0, v[108:111] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[96:99], v5
		ds_read_b128 v[100:103], v24
		ds_read_b128 v[104:107], v26
		ds_read_b128 v[108:111], v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[112:115]
		ds_write_b128 v0, v[116:119] offset:4096
		ds_write_b128 v1, v[120:123] offset:8192
		ds_write_b128 v0, v[124:127] offset:12288
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v5
		ds_read_b128 v[116:119], v24
		ds_read_b128 v[120:123], v26
		ds_read_b128 v[124:127], v2
		s_mul_i32 s0, s18, s0
		s_lshl_b32 s0, s0, 2
		s_add_i32 s1, s13, s0
		v_mul_lo_u32 v3, s18, v25
		v_add3_u32 v4, s1, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[128:129], v[36:37]
		v_mov_b64_e32 v[130:131], v[68:69]
		s_mov_b32 s10, s30
		s_mov_b32 s11, s31
		buffer_store_dwordx4 v[128:131], v4, s[8:11], 0 offen
		s_lshl_b32 s1, s18, 4
		s_add_i32 s2, s1, s13
		s_add_i32 s2, s2, s0
		v_add3_u32 v4, s2, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[128:129], v[72:73]
		v_mov_b64_e32 v[130:131], v[76:77]
		buffer_store_dwordx4 v[128:131], v4, s[8:11], 0 offen
		s_lshl_b32 s2, s18, 5
		s_add_i32 s3, s2, s13
		s_add_i32 s3, s3, s0
		v_add3_u32 v4, s3, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[128:129], v[38:39]
		v_mov_b64_e32 v[130:131], v[70:71]
		buffer_store_dwordx4 v[128:131], v4, s[8:11], 0 offen
		s_mul_i32 s3, 48, s18
		s_add_i32 s4, s3, s13
		s_add_i32 s4, s4, s0
		v_add3_u32 v4, s4, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[74:75]
		v_mov_b64_e32 v[38:39], v[78:79]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_lshl_b32 s4, s18, 6
		s_add_i32 s5, s4, s13
		s_add_i32 s5, s5, s0
		v_add3_u32 v4, s5, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[80:81]
		v_mov_b64_e32 v[38:39], v[84:85]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s5, 0x50, s18
		s_add_i32 s6, s5, s13
		s_add_i32 s6, s6, s0
		v_add3_u32 v4, s6, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[88:89]
		v_mov_b64_e32 v[38:39], v[92:93]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s6, 0x60, s18
		s_add_i32 s7, s6, s13
		s_add_i32 s7, s7, s0
		v_add3_u32 v4, s7, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[82:83]
		v_mov_b64_e32 v[38:39], v[86:87]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s7, 0x70, s18
		s_add_i32 s12, s7, s13
		s_add_i32 s12, s12, s0
		v_add3_u32 v4, s12, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[90:91]
		v_mov_b64_e32 v[38:39], v[94:95]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_lshl_b32 s12, s18, 7
		s_add_i32 s14, s12, s13
		s_add_i32 s14, s14, s0
		v_add3_u32 v4, s14, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[96:97]
		v_mov_b64_e32 v[38:39], v[100:101]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s14, 0x90, s18
		s_add_i32 s15, s14, s13
		s_add_i32 s15, s15, s0
		v_add3_u32 v4, s15, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[104:105]
		v_mov_b64_e32 v[38:39], v[108:109]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s15, 0xa0, s18
		s_add_i32 s16, s15, s13
		s_add_i32 s16, s16, s0
		v_add3_u32 v4, s16, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[98:99]
		v_mov_b64_e32 v[38:39], v[102:103]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s16, 0xb0, s18
		s_add_i32 s17, s16, s13
		s_add_i32 s17, s17, s0
		v_add3_u32 v4, s17, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[106:107]
		v_mov_b64_e32 v[38:39], v[110:111]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s17, 0xc0, s18
		s_add_i32 s20, s17, s13
		s_add_i32 s20, s20, s0
		v_add3_u32 v4, s20, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[36:37], v[112:113]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[38:39], v[116:117]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s20, 0xd0, s18
		s_add_i32 s21, s20, s13
		s_add_i32 s21, s21, s0
		v_add3_u32 v4, s21, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[36:37], v[120:121]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[38:39], v[124:125]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s21, 0xe0, s18
		s_add_i32 s22, s21, s13
		s_add_i32 s22, s22, s0
		v_add3_u32 v4, s22, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[114:115]
		v_mov_b64_e32 v[38:39], v[118:119]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		s_mul_i32 s18, 0xf0, s18
		s_add_i32 s22, s18, s13
		s_add_i32 s22, s22, s0
		v_add3_u32 v4, s22, v3, v23
		v_add3_u32 v4, v4, v28, v29
		v_add_lshl_u32 v4, v4, v30, 1
		v_mov_b64_e32 v[36:37], v[122:123]
		v_mov_b64_e32 v[38:39], v[126:127]
		buffer_store_dwordx4 v[36:39], v4, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[12:15], v[196:199], v20, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[12:15], v[200:203], v20, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[16:19], v[216:219], v20, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[16:19], v[212:215], v20, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], a[0:3], v[196:199], v20, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[48:51], a[0:3], v[200:203], v20, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], a[4:7], v[216:219], v20, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], a[4:7], v[212:215], v20, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[12:15], v[204:207], v21, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], v[12:15], v[208:211], v21, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], v[16:19], v[224:227], v21, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], v[16:19], v[220:223], v21, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], a[0:3], v[204:207], v21, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], a[0:3], v[208:211], v21, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], a[4:7], v[224:227], v21, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], a[4:7], v[220:223], v21, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], a[8:11], v[236:239], v21, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[60:63], a[8:11], a[100:103], v21, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[60:63], a[16:19], a[108:111], v21, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[52:55], a[16:19], a[104:107], v21, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], a[12:15], v[236:239], v21, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[64:67], a[12:15], a[100:103], v21, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], a[20:23], a[108:111], v21, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[56:59], a[20:23], a[104:107], v21, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], a[8:11], v[228:231], v20, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], a[8:11], v[232:235], v20, v7 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[44:47], a[16:19], v[244:247], v20, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], a[16:19], v[240:243], v20, v7 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], a[12:15], v[228:231], v20, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], a[12:15], v[232:235], v20, v7 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[48:51], a[20:23], v[244:247], v20, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], a[20:23], v[240:243], v20, v7 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], a[24:27], a[112:115], v20, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[24:27], a[116:119], v20, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[32:35], a[132:135], v20, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], a[32:35], a[128:131], v20, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[28:31], a[112:115], v20, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], a[28:31], a[116:119], v20, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], a[36:39], a[132:135], v20, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[36:39], a[128:131], v20, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[24:27], a[120:123], v21, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[60:63], a[24:27], a[124:127], v21, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[60:63], a[32:35], a[140:143], v21, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[32:35], a[136:139], v21, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[56:59], a[28:31], a[120:123], v21, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[64:67], a[28:31], a[124:127], v21, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[64:67], a[36:39], a[140:143], v21, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[56:59], a[36:39], a[136:139], v21, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], a[40:43], a[152:155], v21, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], a[40:43], a[156:159], v21, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], a[48:51], a[172:175], v21, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], a[48:51], a[168:171], v21, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[56:59], a[44:47], a[152:155], v21, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[64:67], a[44:47], a[156:159], v21, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[64:67], a[52:55], a[172:175], v21, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[56:59], a[52:55], a[168:171], v21, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], a[40:43], a[144:147], v20, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], a[40:43], a[148:151], v20, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], a[48:51], a[164:167], v20, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], a[48:51], a[160:163], v20, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], a[44:47], a[144:147], v20, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], a[44:47], a[148:151], v20, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], a[52:55], a[164:167], v20, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], a[52:55], a[160:163], v20, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_barrier
		v_cvt_pk_bf16_f32 v8, v196, v197
		v_cvt_pk_bf16_f32 v9, v198, v199
		v_cvt_pk_bf16_f32 v10, v212, v213
		v_cvt_pk_bf16_f32 v11, v214, v215
		ds_write_b128 v1, v[8:11]
		v_cvt_pk_bf16_f32 v8, v200, v201
		v_cvt_pk_bf16_f32 v9, v202, v203
		v_cvt_pk_bf16_f32 v10, v216, v217
		v_cvt_pk_bf16_f32 v11, v218, v219
		ds_write_b128 v0, v[8:11] offset:4096
		v_cvt_pk_bf16_f32 v8, v204, v205
		v_cvt_pk_bf16_f32 v9, v206, v207
		v_cvt_pk_bf16_f32 v10, v220, v221
		v_cvt_pk_bf16_f32 v11, v222, v223
		ds_write_b128 v1, v[8:11] offset:8192
		v_cvt_pk_bf16_f32 v8, v208, v209
		v_cvt_pk_bf16_f32 v9, v210, v211
		v_cvt_pk_bf16_f32 v10, v224, v225
		v_cvt_pk_bf16_f32 v11, v226, v227
		ds_write_b128 v0, v[8:11] offset:12288
		v_cvt_pk_bf16_f32 v8, v228, v229
		v_cvt_pk_bf16_f32 v9, v230, v231
		v_cvt_pk_bf16_f32 v10, v240, v241
		v_cvt_pk_bf16_f32 v11, v242, v243
		v_cvt_pk_bf16_f32 v12, v232, v233
		v_cvt_pk_bf16_f32 v13, v234, v235
		v_cvt_pk_bf16_f32 v14, v244, v245
		v_cvt_pk_bf16_f32 v15, v246, v247
		v_cvt_pk_bf16_f32 v16, v236, v237
		v_cvt_pk_bf16_f32 v17, v238, v239
		v_accvgpr_read_b32 v4, a104
		v_accvgpr_read_b32 v6, a105
		v_cvt_pk_bf16_f32 v18, v4, v6
		v_accvgpr_read_b32 v4, a106
		v_accvgpr_read_b32 v6, a107
		v_cvt_pk_bf16_f32 v19, v4, v6
		v_accvgpr_read_b32 v4, a100
		v_accvgpr_read_b32 v6, a101
		v_cvt_pk_bf16_f32 v32, v4, v6
		v_accvgpr_read_b32 v4, a102
		v_accvgpr_read_b32 v6, a103
		v_cvt_pk_bf16_f32 v33, v4, v6
		v_accvgpr_read_b32 v4, a108
		v_accvgpr_read_b32 v6, a109
		v_cvt_pk_bf16_f32 v34, v4, v6
		v_accvgpr_read_b32 v4, a110
		v_accvgpr_read_b32 v6, a111
		v_cvt_pk_bf16_f32 v35, v4, v6
		v_accvgpr_read_b32 v4, a112
		v_accvgpr_read_b32 v6, a113
		v_cvt_pk_bf16_f32 v36, v4, v6
		v_accvgpr_read_b32 v4, a114
		v_accvgpr_read_b32 v6, a115
		v_cvt_pk_bf16_f32 v37, v4, v6
		v_accvgpr_read_b32 v4, a128
		v_accvgpr_read_b32 v6, a129
		v_cvt_pk_bf16_f32 v38, v4, v6
		v_accvgpr_read_b32 v4, a130
		v_accvgpr_read_b32 v6, a131
		v_cvt_pk_bf16_f32 v39, v4, v6
		v_accvgpr_read_b32 v4, a116
		v_accvgpr_read_b32 v6, a117
		v_cvt_pk_bf16_f32 v40, v4, v6
		v_accvgpr_read_b32 v4, a118
		v_accvgpr_read_b32 v6, a119
		v_cvt_pk_bf16_f32 v41, v4, v6
		v_accvgpr_read_b32 v4, a132
		v_accvgpr_read_b32 v6, a133
		v_cvt_pk_bf16_f32 v42, v4, v6
		v_accvgpr_read_b32 v4, a134
		v_accvgpr_read_b32 v6, a135
		v_cvt_pk_bf16_f32 v43, v4, v6
		v_accvgpr_read_b32 v4, a120
		v_accvgpr_read_b32 v6, a121
		v_cvt_pk_bf16_f32 v44, v4, v6
		v_accvgpr_read_b32 v4, a122
		v_accvgpr_read_b32 v6, a123
		v_cvt_pk_bf16_f32 v45, v4, v6
		v_accvgpr_read_b32 v4, a136
		v_accvgpr_read_b32 v6, a137
		v_cvt_pk_bf16_f32 v46, v4, v6
		v_accvgpr_read_b32 v4, a138
		v_accvgpr_read_b32 v6, a139
		v_cvt_pk_bf16_f32 v47, v4, v6
		v_accvgpr_read_b32 v4, a124
		v_accvgpr_read_b32 v6, a125
		v_cvt_pk_bf16_f32 v48, v4, v6
		v_accvgpr_read_b32 v4, a126
		v_accvgpr_read_b32 v6, a127
		v_cvt_pk_bf16_f32 v49, v4, v6
		v_accvgpr_read_b32 v4, a140
		v_accvgpr_read_b32 v6, a141
		v_cvt_pk_bf16_f32 v50, v4, v6
		v_accvgpr_read_b32 v4, a142
		v_accvgpr_read_b32 v6, a143
		v_cvt_pk_bf16_f32 v51, v4, v6
		v_accvgpr_read_b32 v4, a144
		v_accvgpr_read_b32 v6, a145
		v_cvt_pk_bf16_f32 v52, v4, v6
		v_accvgpr_read_b32 v4, a146
		v_accvgpr_read_b32 v6, a147
		v_cvt_pk_bf16_f32 v53, v4, v6
		v_accvgpr_read_b32 v4, a160
		v_accvgpr_read_b32 v6, a161
		v_cvt_pk_bf16_f32 v54, v4, v6
		v_accvgpr_read_b32 v4, a162
		v_accvgpr_read_b32 v6, a163
		v_cvt_pk_bf16_f32 v55, v4, v6
		v_accvgpr_read_b32 v4, a148
		v_accvgpr_read_b32 v6, a149
		v_cvt_pk_bf16_f32 v56, v4, v6
		v_accvgpr_read_b32 v4, a150
		v_accvgpr_read_b32 v6, a151
		v_cvt_pk_bf16_f32 v57, v4, v6
		v_accvgpr_read_b32 v4, a164
		v_accvgpr_read_b32 v6, a165
		v_cvt_pk_bf16_f32 v58, v4, v6
		v_accvgpr_read_b32 v4, a166
		v_accvgpr_read_b32 v6, a167
		v_cvt_pk_bf16_f32 v59, v4, v6
		v_accvgpr_read_b32 v4, a152
		v_accvgpr_read_b32 v6, a153
		v_cvt_pk_bf16_f32 v60, v4, v6
		v_accvgpr_read_b32 v4, a154
		v_accvgpr_read_b32 v6, a155
		v_cvt_pk_bf16_f32 v61, v4, v6
		v_accvgpr_read_b32 v4, a168
		v_accvgpr_read_b32 v6, a169
		v_cvt_pk_bf16_f32 v62, v4, v6
		v_accvgpr_read_b32 v4, a170
		v_accvgpr_read_b32 v6, a171
		v_cvt_pk_bf16_f32 v63, v4, v6
		v_accvgpr_read_b32 v4, a156
		v_accvgpr_read_b32 v6, a157
		v_cvt_pk_bf16_f32 v64, v4, v6
		v_accvgpr_read_b32 v4, a158
		v_accvgpr_read_b32 v6, a159
		v_cvt_pk_bf16_f32 v65, v4, v6
		v_accvgpr_read_b32 v4, a172
		v_accvgpr_read_b32 v6, a173
		v_cvt_pk_bf16_f32 v66, v4, v6
		v_accvgpr_read_b32 v4, a174
		v_accvgpr_read_b32 v6, a175
		v_cvt_pk_bf16_f32 v67, v4, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v5
		ds_read_b128 v[72:75], v24
		ds_read_b128 v[76:79], v26
		ds_read_b128 v[80:83], v2
		s_add_i32 s19, s19, s0
		s_add_i32 s1, s1, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[8:11]
		ds_write_b128 v0, v[12:15] offset:4096
		ds_write_b128 v1, v[16:19] offset:8192
		ds_write_b128 v0, v[32:35] offset:12288
		s_add_i32 s2, s2, 0x80
		s_add_i32 s2, s2, s13
		s_add_i32 s2, s2, s0
		s_add_i32 s3, s3, 0x80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v5
		ds_read_b128 v[12:15], v24
		ds_read_b128 v[16:19], v26
		ds_read_b128 v[32:35], v2
		s_add_i32 s3, s3, s13
		s_add_i32 s3, s3, s0
		s_add_i32 s4, s4, 0x80
		s_add_i32 s4, s4, s13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39]
		ds_write_b128 v0, v[40:43] offset:4096
		ds_write_b128 v1, v[44:47] offset:8192
		ds_write_b128 v0, v[48:51] offset:12288
		s_add_i32 s4, s4, s0
		s_add_i32 s5, s5, 0x80
		s_add_i32 s5, s5, s13
		s_add_i32 s5, s5, s0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[36:39], v5
		ds_read_b128 v[40:43], v24
		ds_read_b128 v[44:47], v26
		ds_read_b128 v[48:51], v2
		s_add_i32 s6, s6, 0x80
		s_add_i32 s6, s6, s13
		s_add_i32 s6, s6, s0
		s_add_i32 s7, s7, 0x80
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[52:55]
		ds_write_b128 v0, v[56:59] offset:4096
		ds_write_b128 v1, v[60:63] offset:8192
		ds_write_b128 v0, v[64:67] offset:12288
		s_add_i32 s7, s7, s13
		s_add_i32 s7, s7, s0
		s_add_i32 s12, s12, 0x80
		s_add_i32 s12, s12, s13
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[52:55], v5
		ds_read_b128 v[4:7], v24
		ds_read_b128 v[56:59], v26
		ds_read_b128 v[24:27], v2
		v_add3_u32 v0, s19, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[68:69]
		v_mov_b64_e32 v[62:63], v[72:73]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[76:77]
		v_mov_b64_e32 v[62:63], v[80:81]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s2, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[70:71]
		v_mov_b64_e32 v[62:63], v[74:75]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s3, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[78:79]
		v_mov_b64_e32 v[62:63], v[82:83]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s4, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[8:9]
		v_mov_b64_e32 v[62:63], v[12:13]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s5, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[16:17]
		v_mov_b64_e32 v[62:63], v[32:33]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s6, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[60:61], v[10:11]
		v_mov_b64_e32 v[62:63], v[14:15]
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		v_add3_u32 v0, s7, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[18:19]
		v_mov_b64_e32 v[10:11], v[34:35]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s12, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[36:37]
		v_mov_b64_e32 v[10:11], v[40:41]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s14, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[44:45]
		v_mov_b64_e32 v[10:11], v[48:49]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s15, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[38:39]
		v_mov_b64_e32 v[10:11], v[42:43]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s16, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[46:47]
		v_mov_b64_e32 v[10:11], v[50:51]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s17, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[8:9], v[52:53]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[10:11], v[4:5]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s20, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[8:9], v[56:57]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[10:11], v[24:25]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s21, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s1, s1, s0
		v_add3_u32 v0, s1, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[8:9], v[54:55]
		v_mov_b64_e32 v[10:11], v[6:7]
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen
		s_add_i32 s1, s18, 0x80
		s_add_i32 s1, s1, s13
		s_add_i32 s0, s1, s0
		v_add3_u32 v0, s0, v3, v23
		v_add3_u32 v0, v0, v28, v29
		v_add_lshl_u32 v0, v0, v30, 1
		v_mov_b64_e32 v[4:5], v[58:59]
		v_mov_b64_e32 v[6:7], v[26:27]
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
		.amdhsa_next_free_sgpr 60
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
	.set .L_a4w4_kernel.numbered_sgpr, 60
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
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     432
    .agpr_count:     176
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 97
    wave.regalloc.agpr.dwords: 381
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
