	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	tlx_addmm_glu_kernel_persistent
	.p2align	8
	.type	tlx_addmm_glu_kernel_persistent,@function
tlx_addmm_glu_kernel_persistent:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .Ltlx_addmm_glu_kernel_persistent.kernarg_preload_entry
	.p2align	8
.Ltlx_addmm_glu_kernel_persistent.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s18, s[0:1], 0x3c
		s_load_dword s19, s[0:1], 0x40
		s_add_i32 s0, s12, 0x7f
		s_mov_b32 s1, 0x7f
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s0, s0, s1
		s_ashr_i32 s0, s0, 7
		s_add_i32 s1, s13, 0xff
		s_mov_b32 s20, 0xff
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, s20, 0
		s_add_i32 s1, s1, s20
		s_ashr_i32 s1, s1, 8
		s_mul_i32 s20, s0, s1
		s_mul_i32 s1, s1, 4
		v_lshrrev_b32_e32 v1, 2, v0
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 3, v0
		v_and_b32_e32 v4, 1, v3
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_mad_u32_u24 v5, v2, 2, v5
		v_lshrrev_b32_e32 v6, 4, v0
		v_and_b32_e32 v7, 1, v6
		v_mad_u32_u24 v5, v7, 8, v5
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v9
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v12, 1, v11
		v_add3_u32 v5, v5, v10, v12
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v5, v14, 32, v5
		v_lshrrev_b32_e32 v15, 8, v0
		v_and_b32_e32 v16, 1, v15
		v_mad_u32_u24 v5, v16, 64, v5
		v_and_b32_e32 v17, 15, v8
		v_add_u32_e32 v18, 16, v17
		v_add_u32_e32 v19, 32, v17
		v_add_u32_e32 v20, 48, v17
		v_add_u32_e32 v21, 64, v17
		v_add_u32_e32 v22, 0x50, v17
		v_add_u32_e32 v23, 0x60, v17
		v_add_u32_e32 v24, 0x70, v17
		v_and_b32_e32 v25, 31, v0
		v_mov_b32_e32 v26, 8
		v_mul_lo_u32 v26, v26, v25
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v25, 1, v0
		v_mov_b32_e32 v27, 8
		v_mul_lo_u32 v27, v27, v25
		v_lshrrev_b32_e32 v25, 1, v0
		v_and_b32_e32 v28, 1, v25
		v_mov_b32_e32 v29, 16
		v_mul_lo_u32 v29, v29, v28
		v_xor_b32_e32 v27, v27, v29
		v_cmp_lt_i32_e64 vcc, v27, s14
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v28, 2
		v_mul_lo_u32 v28, v28, v14
		v_bitop3_b32 v29, v10, v12, v28 bitop3:0x96
		v_mov_b32_e32 v30, 8
		v_mul_lo_u32 v30, v30, v16
		v_xor_b32_e32 v16, v29, v30
		v_bitop3_b32 v10, 4, v10, v12 bitop3:0x96
		v_bitop3_b32 v10, v10, v28, v30 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s14
		s_mov_b64 s[26:27], vcc
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 vcc, v27, s23
		s_mov_b64 s[28:29], vcc
		v_cmp_lt_i32_e64 vcc, v16, s23
		s_mov_b64 s[30:31], vcc
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v27, s23
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v16, s23
		s_mov_b64 s[34:35], vcc
		s_add_i32 s23, s21, -3
		s_add_i32 s36, s21, -2
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s37, 1, 0
		s_xor_b32 s38, s36, -1
		s_add_i32 s38, s38, 1
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s36, s38, s36
		s_mul_hi_u32 s37, s36, 0xaaaaaaab
		s_cselect_b32 s38, 1, 0
		s_lshr_b32 s37, s37, 1
		s_mul_i32 s37, s37, 3
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s36, s36, s37
		s_xor_b32 s37, s36, -1
		s_add_i32 s37, s37, 1
		s_cmp_lg_u32 s38, 0
		s_cselect_b32 s36, s37, s36
		s_add_i32 s21, s21, -1
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s37, 1, 0
		s_xor_b32 s38, s21, -1
		s_add_i32 s38, s38, 1
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s21, s38, s21
		s_mul_hi_u32 s37, s21, 0xaaaaaaab
		s_cselect_b32 s38, 1, 0
		s_lshr_b32 s37, s37, 1
		s_mul_i32 s37, s37, 3
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s21, s21, s37
		s_xor_b32 s37, s21, -1
		s_add_i32 s37, s37, 1
		s_cmp_lg_u32 s38, 0
		s_cselect_b32 s21, s37, s21
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s22, s22, 0
		s_add_i32 s22, s20, s22
		s_ashr_i32 s22, s22, 5
		s_mul_i32 s22, s22, 32
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		s_mov_b32 s44, s4
		s_mov_b32 s45, s5
		s_mov_b32 s46, s42
		s_mov_b32 s47, s43
		s_mov_b32 s48, s6
		s_mov_b32 s49, s7
		s_mov_b32 s50, s42
		s_mov_b32 s51, s43
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s42
		s_mov_b32 s7, s43
		s_mov_b32 s52, s10
		s_mov_b32 s53, s11
		s_mov_b32 s54, s42
		s_mov_b32 s55, s43
		s_mov_b32 s2, 0
		v_cmp_eq_u32_e64 vcc, v15, s2
		s_mov_b64 s[8:9], vcc
		v_cmp_ne_u32_e64 vcc, v15, s2
		s_mov_b64 s[10:11], vcc
		v_mov_b32_e32 v28, 2
		v_mul_lo_u32 v28, v28, v12
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v14
		v_bitop3_b32 v14, v9, v28, v12 bitop3:0x96
		v_xor_b32_e32 v14, v14, v30
		v_bitop3_b32 v29, 16, v9, v28 bitop3:0x96
		v_bitop3_b32 v29, v29, v12, v30 bitop3:0x96
		v_bitop3_b32 v31, 32, v9, v28 bitop3:0x96
		v_bitop3_b32 v31, v31, v12, v30 bitop3:0x96
		v_bitop3_b32 v32, 48, v9, v28 bitop3:0x96
		v_bitop3_b32 v32, v32, v12, v30 bitop3:0x96
		v_bitop3_b32 v33, 64, v9, v28 bitop3:0x96
		v_bitop3_b32 v33, v33, v12, v30 bitop3:0x96
		v_xor_b32_e32 v34, 0x50, v9
		v_xor_b32_e32 v34, v34, v28
		v_xor_b32_e32 v34, v34, v12
		v_xor_b32_e32 v34, v34, v30
		v_xor_b32_e32 v35, 0x60, v9
		v_xor_b32_e32 v35, v35, v28
		v_xor_b32_e32 v35, v35, v12
		v_xor_b32_e32 v35, v35, v30
		v_xor_b32_e32 v9, 0x70, v9
		v_xor_b32_e32 v9, v9, v28
		v_xor_b32_e32 v9, v9, v12
		v_xor_b32_e32 v9, v9, v30
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v4
		v_bitop3_b32 v2, v27, v12, v2 bitop3:0x96
		v_mov_b32_e32 v4, 0x80
		v_mul_lo_u32 v4, v4, v7
		v_xor_b32_e32 v2, v2, v4
		s_mov_b32 s3, s16
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s37, 1, 0
		s_xor_b32 s38, s1, -1
		s_add_i32 s38, s38, 1
		v_mov_b32_e32 v4, 0x4f7ffffe
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s56, -1
		s_mov_b32 s57, -1
		s_mov_b32 s58, 0
		s_mov_b32 s59, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		s_xor_b32 s39, s12, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v7, s12
		v_mov_b32_e32 v12, s39
		v_cndmask_b32_e64 v7, v7, v12, s[60:61]
		v_cvt_f32_u32_e32 v12, v7
		v_rcp_iflag_f32_e32 v12, v12
		v_xad_u32 v28, v7, -1, 1
		v_mul_f32_e32 v12, v4, v12
		v_cvt_u32_f32_e32 v12, v12
		v_mul_lo_u32 v30, v28, v12
		v_mul_hi_u32 v30, v12, v30
		v_add_u32_e32 v12, v12, v30
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v30, s13
		v_mov_b32_e32 v36, s39
		v_cndmask_b32_e64 v30, v30, v36, s[60:61]
		v_cvt_f32_u32_e32 v36, v30
		v_rcp_iflag_f32_e32 v36, v36
		v_xad_u32 v37, v30, -1, 1
		v_mul_f32_e32 v36, v4, v36
		v_cvt_u32_f32_e32 v36, v36
		v_mul_lo_u32 v38, v37, v36
		v_mul_hi_u32 v38, v36, v38
		v_add_u32_e32 v36, v36, v38
		v_and_b32_e32 v38, 1, v0
		v_lshlrev_b32_e32 v38, 4, v38
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 5, v25
		v_add_u32_e32 v39, v38, v25
		v_mov_b32_e32 v40, 0x80000000
		v_lshlrev_b32_e32 v41, 3, v15
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v42, 1, v13
		v_and_b32_e32 v43, 1, v11
		v_add3_u32 v41, v41, v42, v43
		v_and_b32_e32 v42, 1, v8
		v_lshl_add_u32 v41, v42, 4, v41
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v44, s17, v41
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v41, 4, v41
		v_mul_lo_u32 v41, s17, v41
		v_lshlrev_b32_e32 v41, 1, v41
		s_lshl_b32 s39, s17, 6
		s_lshl_b32 s56, s17, 7
		v_and_b32_e32 v45, 63, v0
		v_lshrrev_b32_e32 v46, 4, v45
		v_lshlrev_b32_e32 v47, 4, v46
		v_lshl_add_u32 v15, v15, 9, v47
		v_and_b32_e32 v47, 15, v45
		v_lshrrev_b32_e32 v48, 1, v47
		v_lshlrev_b32_e32 v48, 6, v48
		v_and_b32_e32 v47, 1, v47
		v_mov_b32_e32 v49, 0x420
		v_mul_lo_u32 v49, v49, v47
		v_add3_u32 v15, v15, v48, v49
		v_and_b32_e32 v47, 3, v0
		v_and_b32_e32 v48, 3, v11
		v_lshlrev_b32_e32 v48, 5, v48
		v_lshl_add_u32 v47, v47, 3, v48
		v_lshlrev_b32_e32 v48, 9, v42
		v_and_b32_e32 v49, 7, v1
		v_mov_b32_e32 v50, 0x420
		v_mul_lo_u32 v50, v50, v49
		v_add3_u32 v47, v47, v48, v50
		v_add_u32_e32 v48, 0xc0, v39
		s_lshl_b32 s57, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s58, 0xc0, s17
		s_mul_i32 s59, 0x2100, s36
		v_add_u32_e32 v49, s59, v15
		s_mul_i32 s36, 0x4200, s36
		v_add_u32_e32 v50, s36, v47
		s_mul_i32 s36, 0x2100, s21
		v_add_u32_e32 v51, s36, v15
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v52, s21, v47
		v_lshlrev_b32_e32 v13, 3, v13
		v_lshlrev_b32_e32 v43, 2, v43
		v_lshlrev_b32_e32 v42, 1, v42
		v_xor_b32_e32 v42, v0, v42
		v_bitop3_b32 v13, v13, v43, v42 bitop3:0x96
		v_lshlrev_b32_e32 v42, 4, v13
		v_add_u32_e32 v42, 0x10000, v42
		v_xor_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_add_u32_e32 v13, 0x10000, v13
		v_and_b32_e32 v43, 1, v46
		v_lshlrev_b32_e32 v43, 14, v43
		v_add_u32_e32 v43, 0x10000, v43
		v_lshrrev_b32_e32 v46, 3, v45
		v_and_b32_e32 v46, 1, v46
		v_lshl_add_u32 v43, v46, 13, v43
		v_lshrrev_b32_e32 v53, 2, v45
		v_and_b32_e32 v53, 1, v53
		v_lshlrev_b32_e32 v54, 3, v53
		v_lshrrev_b32_e32 v55, 1, v45
		v_and_b32_e32 v55, 1, v55
		v_lshlrev_b32_e32 v56, 2, v55
		v_lshrrev_b32_e32 v57, 5, v45
		v_lshl_add_u32 v11, v11, 1, v57
		v_lshl_add_u32 v11, v53, 7, v11
		v_lshl_add_u32 v11, v55, 6, v11
		v_and_b32_e32 v45, 1, v45
		v_lshl_add_u32 v11, v45, 5, v11
		v_lshlrev_b32_e32 v45, 1, v45
		v_bitop3_b32 v11, v56, v11, v45 bitop3:0x96
		v_bitop3_b32 v11, v46, v54, v11 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, v43
		v_mul_lo_u32 v8, s19, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_and_b32_e32 v6, 1, v6
		v_and_b32_e32 v3, 1, v3
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 6, v1
		s_cselect_b32 s21, 1, 0
		s_lshl_b32 s36, s19, 5
		s_lshl_b32 s59, s19, 6
		s_mul_i32 s60, 0x60, s19
		s_lshl_b32 s61, s19, 7
		s_mul_i32 s62, 0xa0, s19
		s_mul_i32 s63, 0xc0, s19
		s_mul_i32 s64, 0xe0, s19
		s_cmp_lt_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s3, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s16, s3
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s16, s3, 7
		s_lshr_b32 s65, s3, 3
		s_lshr_b32 s66, s65, 2
		s_mul_i32 s66, s66, 32
		s_mul_i32 s16, s16, 4
		s_add_i32 s16, s66, s16
		s_and_b32 s65, s65, 3
		s_add_i32 s16, s16, s65
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		v_readfirstlane_b32 s65, v0
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s66, 1, 0
		s_xor_b32 s67, s16, -1
		s_add_i32 s67, s67, 1
		s_cmp_lg_u32 s66, 0
		s_cselect_b32 s66, s67, s16
		s_cselect_b32 s67, 1, 0
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s68, s38, s1
		v_mov_b32_e32 v43, s68
		v_cvt_f32_u32_e32 v43, v43
		v_rcp_iflag_f32_e32 v43, v43
		s_xor_b32 s69, s68, -1
		v_mul_f32_e32 v43, v4, v43
		v_cvt_u32_f32_e32 v43, v43
		s_add_i32 s69, s69, 1
		v_readfirstlane_b32 s70, v43
		s_mul_i32 s71, s69, s70
		s_mul_hi_u32 s71, s70, s71
		s_add_i32 s70, s70, s71
		s_mul_hi_u32 s70, s66, s70
		s_mul_i32 s71, s70, s68
		s_xor_b32 s71, s71, -1
		s_add_i32 s71, s71, 1
		s_add_i32 s66, s66, s71
		s_cmp_ge_u32 s66, s68
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s70, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s70, s72, s70
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s66, s69
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s66, s72, s66
		s_cmp_ge_u32 s66, s68
		s_cselect_b32 s68, 1, 0
		s_add_i32 s71, s70, 1
		s_cmp_lg_u32 s68, 0
		s_cselect_b32 s68, s71, s70
		s_cselect_b32 s70, 1, 0
		s_xor_b32 s16, s16, s1
		s_xor_b32 s71, s68, -1
		s_add_i32 s71, s71, 1
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s16, s71, s68
		s_mul_i32 s68, s16, 4
		s_xor_b32 s71, s68, -1
		s_add_i32 s71, s71, 1
		s_add_i32 s71, s0, s71
		s_cmp_lt_i32 s71, 4
		s_cselect_b32 s71, s71, 4
		s_add_i32 s69, s66, s69
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s66, s69, s66
		s_xor_b32 s69, s66, -1
		s_add_i32 s69, s69, 1
		s_cmp_lg_u32 s67, 0
		s_cselect_b32 s66, s69, s66
		s_cmp_lt_i32 s66, 0
		s_cselect_b32 s67, 1, 0
		s_xor_b32 s69, s66, -1
		s_add_i32 s69, s69, 1
		s_cmp_lg_u32 s67, 0
		s_cselect_b32 s67, s69, s66
		s_cselect_b32 s69, 1, 0
		s_xor_b32 s70, s71, -1
		s_add_i32 s70, s70, 1
		s_cmp_lt_i32 s71, 0
		s_cselect_b32 s70, s70, s71
		v_mov_b32_e32 v43, s70
		v_cvt_f32_u32_e32 v43, v43
		v_rcp_iflag_f32_e32 v43, v43
		s_xor_b32 s72, s70, -1
		v_mul_f32_e32 v43, v4, v43
		v_cvt_u32_f32_e32 v43, v43
		s_add_i32 s72, s72, 1
		v_readfirstlane_b32 s73, v43
		s_mul_i32 s74, s72, s73
		s_mul_hi_u32 s74, s73, s74
		s_add_i32 s73, s73, s74
		s_mul_hi_u32 s73, s67, s73
		s_mul_i32 s74, s73, s70
		s_xor_b32 s74, s74, -1
		s_add_i32 s74, s74, 1
		s_add_i32 s67, s67, s74
		s_cmp_ge_u32 s67, s70
		s_cselect_b32 s74, 1, 0
		s_add_i32 s75, s67, s72
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s67, s75, s67
		s_cselect_b32 s74, 1, 0
		s_cmp_ge_u32 s67, s70
		s_cselect_b32 s70, 1, 0
		s_add_i32 s72, s67, s72
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s67, s72, s67
		s_cselect_b32 s70, 1, 0
		s_xor_b32 s72, s67, -1
		s_add_i32 s72, s72, 1
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s67, s72, s67
		s_add_i32 s68, s68, s67
		s_add_i32 s69, s73, 1
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s69, s69, s73
		s_add_i32 s72, s69, 1
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s69, s72, s69
		s_xor_b32 s66, s66, s71
		s_xor_b32 s70, s69, -1
		s_add_i32 s70, s70, 1
		s_cmp_lt_i32 s66, 0
		s_cselect_b32 s66, s70, s69
		s_mul_i32 s68, s68, 0x80
		v_add_u32_e32 v43, s68, v5
		v_cmp_lt_i32_e64 vcc, v43, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v45, v43, -1, 1
		v_add_u32_e32 v46, s68, v17
		v_cndmask_b32_e32 v43, v43, v45, vcc
		v_mul_hi_u32 v45, v43, v12
		v_mul_lo_u32 v45, v45, v7
		v_xor_b32_e32 v45, -1, v45
		v_add3_u32 v43, 1, v45, v43
		v_add_u32_e32 v45, v43, v28
		v_cmp_ge_u32_e64 vcc, v43, v7
		v_add_u32_e32 v53, s68, v18
		v_add_u32_e32 v54, s68, v19
		v_cndmask_b32_e32 v43, v43, v45, vcc
		v_add_u32_e32 v45, v43, v28
		v_cmp_ge_u32_e64 vcc, v43, v7
		v_add_u32_e32 v55, s68, v20
		v_add_u32_e32 v56, s68, v21
		v_cndmask_b32_e32 v43, v43, v45, vcc
		v_xad_u32 v45, v43, -1, 1
		v_cmp_lt_i32_e64 vcc, v46, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v57, v46, -1, 1
		v_add_u32_e32 v58, s68, v22
		v_cndmask_b32_e32 v46, v46, v57, vcc
		v_mul_hi_u32 v57, v46, v12
		v_mul_lo_u32 v57, v57, v7
		v_xor_b32_e32 v57, -1, v57
		v_add3_u32 v46, 1, v57, v46
		v_add_u32_e32 v57, v46, v28
		v_cmp_ge_u32_e64 vcc, v46, v7
		v_add_u32_e32 v59, s68, v23
		v_add_u32_e32 v60, s68, v24
		v_cndmask_b32_e32 v46, v46, v57, vcc
		v_cmp_ge_u32_e64 vcc, v46, v7
		v_cndmask_b32_e64 v43, v43, v45, s[70:71]
		v_add_u32_e32 v45, v46, v28
		v_cndmask_b32_e32 v45, v46, v45, vcc
		v_xad_u32 v46, v45, -1, 1
		v_cmp_lt_i32_e64 vcc, v53, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v57, v53, -1, 1
		v_cndmask_b32_e64 v45, v45, v46, s[72:73]
		v_cndmask_b32_e32 v46, v53, v57, vcc
		v_mul_hi_u32 v53, v46, v12
		v_mul_lo_u32 v53, v53, v7
		v_xor_b32_e32 v53, -1, v53
		v_add3_u32 v46, 1, v53, v46
		v_cmp_ge_u32_e64 vcc, v46, v7
		v_add_u32_e32 v53, v46, v28
		v_add_u32_e32 v57, s68, v9
		v_cndmask_b32_e32 v46, v46, v53, vcc
		v_cmp_ge_u32_e64 vcc, v46, v7
		v_add_u32_e32 v53, v46, v28
		v_add_u32_e32 v61, s68, v35
		v_cndmask_b32_e32 v46, v46, v53, vcc
		v_xad_u32 v53, v46, -1, 1
		v_cmp_lt_i32_e64 vcc, v54, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v62, v54, -1, 1
		v_cndmask_b32_e64 v46, v46, v53, s[70:71]
		v_cndmask_b32_e32 v53, v54, v62, vcc
		v_mul_hi_u32 v54, v53, v12
		v_mul_lo_u32 v54, v54, v7
		v_xor_b32_e32 v54, -1, v54
		v_add3_u32 v53, 1, v54, v53
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_add_u32_e32 v54, v53, v28
		v_add_u32_e32 v62, s68, v34
		v_cndmask_b32_e32 v53, v53, v54, vcc
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_add_u32_e32 v54, v53, v28
		v_add_u32_e32 v63, s68, v33
		v_cndmask_b32_e32 v53, v53, v54, vcc
		v_xad_u32 v54, v53, -1, 1
		v_cmp_lt_i32_e64 vcc, v55, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v64, v55, -1, 1
		v_cndmask_b32_e64 v53, v53, v54, s[72:73]
		v_cndmask_b32_e32 v54, v55, v64, vcc
		v_mul_hi_u32 v55, v54, v12
		v_mul_lo_u32 v55, v55, v7
		v_xor_b32_e32 v55, -1, v55
		v_add3_u32 v54, 1, v55, v54
		v_cmp_ge_u32_e64 vcc, v54, v7
		v_add_u32_e32 v55, v54, v28
		v_add_u32_e32 v64, s68, v32
		v_cndmask_b32_e32 v54, v54, v55, vcc
		v_cmp_ge_u32_e64 vcc, v54, v7
		v_add_u32_e32 v55, v54, v28
		v_add_u32_e32 v65, s68, v31
		v_cndmask_b32_e32 v54, v54, v55, vcc
		v_xad_u32 v55, v54, -1, 1
		v_cmp_lt_i32_e64 vcc, v56, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v66, v56, -1, 1
		v_cndmask_b32_e64 v54, v54, v55, s[70:71]
		v_cndmask_b32_e32 v55, v56, v66, vcc
		v_mul_hi_u32 v56, v55, v12
		v_mul_lo_u32 v56, v56, v7
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v55, 1, v56, v55
		v_cmp_ge_u32_e64 vcc, v55, v7
		v_add_u32_e32 v56, v55, v28
		v_add_u32_e32 v66, s68, v29
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_cmp_ge_u32_e64 vcc, v55, v7
		v_add_u32_e32 v56, v55, v28
		v_add_u32_e32 v67, s68, v14
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_xad_u32 v56, v55, -1, 1
		v_cmp_lt_i32_e64 vcc, v58, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v68, v58, -1, 1
		v_cndmask_b32_e64 v55, v55, v56, s[72:73]
		v_cndmask_b32_e32 v56, v58, v68, vcc
		v_mul_hi_u32 v58, v56, v12
		v_mul_lo_u32 v58, v58, v7
		v_xor_b32_e32 v58, -1, v58
		v_add3_u32 v56, 1, v58, v56
		v_cmp_ge_u32_e64 vcc, v56, v7
		v_add_u32_e32 v58, v56, v28
		v_mul_lo_u32 v55, s18, v55
		v_cndmask_b32_e32 v56, v56, v58, vcc
		v_cmp_ge_u32_e64 vcc, v56, v7
		v_add_u32_e32 v58, v56, v28
		v_mul_lo_u32 v54, s18, v54
		v_cndmask_b32_e32 v56, v56, v58, vcc
		v_xad_u32 v58, v56, -1, 1
		v_cmp_lt_i32_e64 vcc, v59, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v68, v59, -1, 1
		v_cndmask_b32_e64 v56, v56, v58, s[68:69]
		v_cndmask_b32_e32 v58, v59, v68, vcc
		v_mul_hi_u32 v59, v58, v12
		v_mul_lo_u32 v59, v59, v7
		v_xor_b32_e32 v59, -1, v59
		v_add3_u32 v58, 1, v59, v58
		v_cmp_ge_u32_e64 vcc, v58, v7
		v_add_u32_e32 v59, v58, v28
		v_mul_lo_u32 v53, s18, v53
		v_cndmask_b32_e32 v58, v58, v59, vcc
		v_cmp_ge_u32_e64 vcc, v58, v7
		v_add_u32_e32 v59, v58, v28
		v_mul_lo_u32 v46, s18, v46
		v_cndmask_b32_e32 v58, v58, v59, vcc
		v_xad_u32 v59, v58, -1, 1
		v_cmp_lt_i32_e64 vcc, v60, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v68, v60, -1, 1
		v_cndmask_b32_e64 v58, v58, v59, s[70:71]
		v_cndmask_b32_e32 v59, v60, v68, vcc
		v_mul_hi_u32 v60, v59, v12
		v_mul_lo_u32 v60, v60, v7
		v_xor_b32_e32 v60, -1, v60
		v_add3_u32 v59, 1, v60, v59
		v_cmp_ge_u32_e64 vcc, v59, v7
		v_add_u32_e32 v60, v59, v28
		v_mul_lo_u32 v45, s18, v45
		v_cndmask_b32_e32 v59, v59, v60, vcc
		v_cmp_ge_u32_e64 vcc, v59, v7
		v_add_u32_e32 v60, v59, v28
		s_mul_i32 s70, s66, 0x100
		v_cndmask_b32_e32 v59, v59, v60, vcc
		v_xad_u32 v60, v59, -1, 1
		v_add_u32_e32 v68, s70, v26
		v_cmp_lt_i32_e64 vcc, v68, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v69, v68, -1, 1
		v_cndmask_b32_e64 v59, v59, v60, s[68:69]
		v_cndmask_b32_e32 v60, v68, v69, vcc
		v_mul_hi_u32 v68, v60, v36
		v_mul_lo_u32 v68, v68, v30
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v60, 1, v68, v60
		v_cmp_ge_u32_e64 vcc, v60, v30
		v_add_u32_e32 v68, v60, v37
		v_mul_lo_u32 v69, s15, v43
		v_cndmask_b32_e32 v60, v60, v68, vcc
		v_cmp_ge_u32_e64 vcc, v60, v30
		v_add_u32_e32 v68, v60, v37
		v_lshl_add_u32 v69, v69, 1, v39
		v_cndmask_b32_e32 v60, v60, v68, vcc
		v_xad_u32 v68, v60, -1, 1
		v_cndmask_b32_e64 v70, v40, v69, s[24:25]
		v_cndmask_b32_e64 v60, v60, v68, s[72:73]
		s_lshr_b32 s65, s65, 6
		v_lshlrev_b32_e32 v68, 1, v60
		s_mul_i32 s65, 0x420, s65
		v_add_u32_e32 v71, v44, v68
		s_mov_b32 m0, s65
		v_cndmask_b32_e64 v72, v40, v71, s[26:27]
		buffer_load_dwordx4 v70, s[40:43], 0 offen lds
		v_add_u32_e32 v70, v41, v68
		s_add_i32 m0, m0, 0x62e0
		v_cndmask_b32_e64 v73, v40, v70, s[26:27]
		buffer_load_dwordx4 v72, s[44:47], 0 offen lds
		s_barrier
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v72, 64, v69
		buffer_load_dwordx4 v73, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v72, v40, v72, s[28:29]
		s_add_i32 m0, m0, 0xffff9d20
		v_add_u32_e32 v73, s39, v71
		buffer_load_dwordx4 v72, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v72, v40, v73, s[30:31]
		s_add_i32 m0, m0, 0x83e0
		v_add_u32_e32 v73, s39, v70
		buffer_load_dwordx4 v72, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v72, v40, v73, s[30:31]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v69, 0x80, v69
		buffer_load_dwordx4 v72, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v69, v40, v69, s[32:33]
		s_add_i32 m0, m0, 0xffff7c20
		v_add_u32_e32 v72, s56, v71
		buffer_load_dwordx4 v69, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v69, v40, v72, s[34:35]
		s_add_i32 m0, m0, 0xa4e0
		v_add_u32_e32 v72, s56, v70
		buffer_load_dwordx4 v69, s[44:47], 0 offen lds
		v_mul_lo_u32 v43, s57, v43
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v69, v40, v72, s[34:35]
		buffer_load_dwordx4 v69, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[72:75], v15
		ds_read_b128 v[76:79], v15 offset:2112
		ds_read_b128 v[80:83], v15 offset:4224
		ds_read_b128 v[84:87], v15 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[88:89], v47 offset:25312
		ds_read_b64_tr_b16 v[90:91], v47 offset:33760
		ds_read_b64_tr_b16 v[92:93], v47 offset:25440
		ds_read_b64_tr_b16 v[94:95], v47 offset:33888
		ds_read_b64_tr_b16 v[96:97], v47 offset:25568
		ds_read_b64_tr_b16 v[98:99], v47 offset:34016
		ds_read_b64_tr_b16 v[100:101], v47 offset:25696
		ds_read_b64_tr_b16 v[102:103], v47 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[86:87], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[86:87]
		s_setprio 0
		v_add_u32_e32 v69, v48, v43
		s_mov_b32 s68, 0
		s_mov_b32 s69, 0
		s_cmp_lg_u32 s21, 0
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		s_cmp_ge_u32 s68, 2
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s68, -2
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[72:75], v[116:119]
		s_add_i32 s73, s68, 1
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[76:79], v[132:135]
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s73
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[76:79], v[120:123]
		s_cselect_b32 s74, 1, 0
		s_add_i32 s75, s69, 3
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[76:79], v[124:127]
		s_mul_i32 s75, s75, 32
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[80:83], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[80:83], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[84:87], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[84:87], v[160:163]
		s_setprio 1
		s_barrier
		s_xor_b32 s75, s75, -1
		s_add_i32 s75, s75, 1
		s_add_i32 s75, s14, s75
		v_cmp_lt_i32_e64 vcc, v27, s75
		s_lshl_b32 s76, s69, 6
		s_mul_i32 s77, 0x2100, s68
		v_cndmask_b32_e32 v43, v40, v69, vcc
		v_cmp_lt_i32_e64 vcc, v16, s75
		s_mov_b64 s[78:79], vcc
		s_add_i32 m0, s65, s77
		s_mul_i32 s77, s17, s69
		buffer_load_dwordx4 v43, s[40:43], s76 offen lds
		v_cmp_lt_i32_e64 vcc, v10, s75
		s_lshl_b32 s75, s77, 6
		s_add_i32 s75, s58, s75
		v_add_u32_e32 v43, s75, v71
		v_cndmask_b32_e64 v43, v40, v43, s[78:79]
		s_mul_i32 s68, 0x4200, s68
		v_add_u32_e32 v72, s75, v70
		s_add_i32 s68, s65, s68
		v_cndmask_b32_e32 v72, v40, v72, vcc
		s_add_i32 m0, s68, 0x62e0
		s_mul_i32 s68, 0x4200, s71
		buffer_load_dwordx4 v43, s[44:47], 0 offen lds
		s_mul_i32 s71, 0x2100, s71
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v43, s71, v15
		buffer_load_dwordx4 v72, s[44:47], 0 offen lds
		s_barrier
		s_waitcnt vmcnt(3)
		ds_read_b128 v[72:75], v43
		ds_read_b128 v[76:79], v43 offset:2112
		ds_read_b128 v[80:83], v43 offset:4224
		ds_read_b128 v[84:87], v43 offset:6336
		v_add_u32_e32 v43, s68, v47
		ds_read_b64_tr_b16 v[88:89], v43 offset:25312
		ds_read_b64_tr_b16 v[90:91], v43 offset:33760
		ds_read_b64_tr_b16 v[92:93], v43 offset:25440
		ds_read_b64_tr_b16 v[94:95], v43 offset:33888
		ds_read_b64_tr_b16 v[96:97], v43 offset:25568
		ds_read_b64_tr_b16 v[98:99], v43 offset:34016
		ds_read_b64_tr_b16 v[100:101], v43 offset:25696
		ds_read_b64_tr_b16 v[102:103], v43 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s68, s72, s73
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s69, s23
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_setprio 0
		s_and_saveexec_b64 s[86:87], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[86:87]
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_dwordx4 v[168:171], v68, s[48:51], 0 offen
		v_add_lshl_u32 v43, v60, v45, 1
		buffer_load_dwordx4 v[68:71], v43, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v43, v60, v46, 1
		buffer_load_dwordx4 v[172:175], v43, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v43, v60, v53, 1
		buffer_load_dwordx4 v[176:179], v43, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v43, v60, v54, 1
		buffer_load_dwordx4 v[180:183], v43, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v43, v60, v55, 1
		buffer_load_dwordx4 v[184:187], v43, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v43, s18, v56
		v_add_lshl_u32 v43, v60, v43, 1
		buffer_load_dwordx4 v[188:191], v43, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v43, s18, v58
		v_add_lshl_u32 v43, v60, v43, 1
		buffer_load_dwordx4 v[192:195], v43, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v43, s18, v59
		v_add_lshl_u32 v43, v60, v43, 1
		buffer_load_dwordx4 v[196:199], v43, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[72:75], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[80:83], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[80:83], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[84:87], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[84:87], v[160:163]
		ds_read_b128 v[72:75], v49
		ds_read_b128 v[76:79], v49 offset:2112
		ds_read_b128 v[80:83], v49 offset:4224
		ds_read_b128 v[84:87], v49 offset:6336
		ds_read_b64_tr_b16 v[88:89], v50 offset:25312
		ds_read_b64_tr_b16 v[90:91], v50 offset:33760
		ds_read_b64_tr_b16 v[92:93], v50 offset:25440
		ds_read_b64_tr_b16 v[94:95], v50 offset:33888
		ds_read_b64_tr_b16 v[96:97], v50 offset:25568
		ds_read_b64_tr_b16 v[98:99], v50 offset:34016
		ds_read_b64_tr_b16 v[100:101], v50 offset:25696
		ds_read_b64_tr_b16 v[102:103], v50 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[76:79], v[120:123]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[72:75], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[80:83], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[80:83], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[84:87], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[84:87], v[160:163]
		ds_read_b128 v[72:75], v51
		ds_read_b128 v[76:79], v51 offset:2112
		ds_read_b128 v[80:83], v51 offset:4224
		ds_read_b128 v[84:87], v51 offset:6336
		ds_read_b64_tr_b16 v[88:89], v52 offset:25312
		ds_read_b64_tr_b16 v[90:91], v52 offset:33760
		ds_read_b64_tr_b16 v[92:93], v52 offset:25440
		ds_read_b64_tr_b16 v[94:95], v52 offset:33888
		ds_read_b64_tr_b16 v[96:97], v52 offset:25568
		ds_read_b64_tr_b16 v[98:99], v52 offset:34016
		ds_read_b64_tr_b16 v[100:101], v52 offset:25696
		ds_read_b64_tr_b16 v[102:103], v52 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[76:79], v[120:123]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[72:75], v[116:119]
		s_barrier
		s_nop 2
		ds_write_b128 v42, v[104:107] offset:10432
		ds_write_b128 v13, v[108:111] offset:18624
		ds_write_b128 v42, v[112:115] offset:26816
		s_nop 0
		ds_write_b128 v13, v[116:119] offset:35008
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[80:83], v[144:147]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[80:83], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[80:83], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[84:87], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[84:87], v[160:163]
		ds_read_b128 v[72:75], v11 offset:10432
		ds_read_b128 v[76:79], v11 offset:10688
		ds_read_b128 v[80:83], v11 offset:14528
		ds_read_b128 v[84:87], v11 offset:14784
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v54, v168
		v_cvt_f32_f16_sdwa v55, v168 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v58, v169
		v_cvt_f32_f16_sdwa v59, v169 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v42, v[120:123] offset:10432
		ds_write_b128 v13, v[124:127] offset:18624
		ds_write_b128 v42, v[128:131] offset:26816
		ds_write_b128 v13, v[132:135] offset:35008
		v_cvt_f32_f16_e32 v88, v170
		v_cvt_f32_f16_sdwa v89, v170 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v171
		v_cvt_f32_f16_sdwa v91, v171 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[92:95], v11 offset:10432
		ds_read_b128 v[96:99], v11 offset:10688
		ds_read_b128 v[100:103], v11 offset:14528
		ds_read_b128 v[104:107], v11 offset:14784
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v108, v68
		v_cvt_f32_f16_sdwa v109, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v110, v69
		v_cvt_f32_f16_sdwa v111, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v42, v[136:139] offset:10432
		ds_write_b128 v13, v[140:143] offset:18624
		ds_write_b128 v42, v[144:147] offset:26816
		ds_write_b128 v13, v[148:151] offset:35008
		v_cvt_f32_f16_e32 v68, v70
		v_cvt_f32_f16_sdwa v69, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v112, v71
		v_cvt_f32_f16_sdwa v113, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[116:119], v11 offset:10432
		ds_read_b128 v[120:123], v11 offset:10688
		ds_read_b128 v[124:127], v11 offset:14528
		ds_read_b128 v[128:131], v11 offset:14784
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v70, v172
		v_cvt_f32_f16_sdwa v71, v172 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v114, v173
		v_cvt_f32_f16_sdwa v115, v173 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v42, v[152:155] offset:10432
		ds_write_b128 v13, v[156:159] offset:18624
		ds_write_b128 v42, v[160:163] offset:26816
		ds_write_b128 v13, v[164:167] offset:35008
		v_cvt_f32_f16_e32 v132, v174
		v_cvt_f32_f16_sdwa v133, v174 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v134, v175
		v_cvt_f32_f16_sdwa v135, v175 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[136:139], v11 offset:10432
		ds_read_b128 v[140:143], v11 offset:10688
		ds_read_b128 v[144:147], v11 offset:14528
		ds_read_b128 v[148:151], v11 offset:14784
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v152, v176
		v_cvt_f32_f16_sdwa v153, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v154, v177
		v_cvt_f32_f16_sdwa v155, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v156, v178
		v_cvt_f32_f16_sdwa v157, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v158, v179
		v_cvt_f32_f16_sdwa v159, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v160, v180
		v_cvt_f32_f16_sdwa v161, v180 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v162, v181
		v_cvt_f32_f16_sdwa v163, v181 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v164, v182
		v_cvt_f32_f16_sdwa v165, v182 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v166, v183
		v_cvt_f32_f16_sdwa v167, v183 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v168, v184
		v_cvt_f32_f16_sdwa v169, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v170, v185
		v_cvt_f32_f16_sdwa v171, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v172, v186
		v_cvt_f32_f16_sdwa v173, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v174, v187
		v_cvt_f32_f16_sdwa v175, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v176, v188
		v_cvt_f32_f16_sdwa v177, v188 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v178, v189
		v_cvt_f32_f16_sdwa v179, v189 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v180, v190
		v_cvt_f32_f16_sdwa v181, v190 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v182, v191
		v_cvt_f32_f16_sdwa v183, v191 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v184, v192
		v_cvt_f32_f16_sdwa v185, v192 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v186, v193
		v_cvt_f32_f16_sdwa v187, v193 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v188, v194
		v_cvt_f32_f16_sdwa v189, v194 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v190, v195
		v_cvt_f32_f16_sdwa v191, v195 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v192, v196
		v_cvt_f32_f16_sdwa v193, v196 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v194, v197
		v_cvt_f32_f16_sdwa v195, v197 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v196, v198
		v_cvt_f32_f16_sdwa v197, v198 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v200, v199
		v_cvt_f32_f16_sdwa v201, v199 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[72:73], v[72:73], v[54:55]
		v_pk_add_f32 v[74:75], v[74:75], v[58:59]
		v_pk_add_f32 v[76:77], v[76:77], v[88:89]
		v_pk_add_f32 v[78:79], v[78:79], v[90:91]
		v_pk_add_f32 v[80:81], v[80:81], v[54:55]
		v_pk_add_f32 v[82:83], v[82:83], v[58:59]
		v_pk_add_f32 v[84:85], v[84:85], v[88:89]
		v_pk_add_f32 v[86:87], v[86:87], v[90:91]
		v_pk_add_f32 v[92:93], v[92:93], v[54:55]
		v_pk_add_f32 v[94:95], v[94:95], v[58:59]
		v_pk_add_f32 v[96:97], v[96:97], v[88:89]
		v_pk_add_f32 v[98:99], v[98:99], v[90:91]
		v_pk_add_f32 v[100:101], v[100:101], v[54:55]
		v_pk_add_f32 v[102:103], v[102:103], v[58:59]
		v_pk_add_f32 v[104:105], v[104:105], v[88:89]
		v_pk_add_f32 v[106:107], v[106:107], v[90:91]
		v_pk_add_f32 v[116:117], v[116:117], v[54:55]
		v_pk_add_f32 v[118:119], v[118:119], v[58:59]
		v_pk_add_f32 v[120:121], v[120:121], v[88:89]
		v_pk_add_f32 v[122:123], v[122:123], v[90:91]
		v_pk_add_f32 v[124:125], v[124:125], v[54:55]
		v_pk_add_f32 v[126:127], v[126:127], v[58:59]
		v_pk_add_f32 v[128:129], v[128:129], v[88:89]
		v_pk_add_f32 v[130:131], v[130:131], v[90:91]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[136:137], v[136:137], v[54:55]
		v_pk_add_f32 v[138:139], v[138:139], v[58:59]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[140:141], v[140:141], v[88:89]
		v_pk_add_f32 v[142:143], v[142:143], v[90:91]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[54:55], v[144:145], v[54:55]
		v_pk_add_f32 v[58:59], v[146:147], v[58:59]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[88:89], v[148:149], v[88:89]
		v_pk_add_f32 v[90:91], v[150:151], v[90:91]
		v_pk_fma_f32 v[144:145], v[72:73], v[108:109], v[72:73]
		v_pk_fma_f32 v[72:73], v[74:75], v[110:111], v[74:75]
		v_pk_fma_f32 v[74:75], v[76:77], v[68:69], v[76:77]
		v_pk_fma_f32 v[68:69], v[78:79], v[112:113], v[78:79]
		v_pk_fma_f32 v[76:77], v[80:81], v[70:71], v[80:81]
		v_pk_fma_f32 v[70:71], v[82:83], v[114:115], v[82:83]
		v_pk_fma_f32 v[78:79], v[84:85], v[132:133], v[84:85]
		v_pk_fma_f32 v[80:81], v[86:87], v[134:135], v[86:87]
		v_pk_fma_f32 v[82:83], v[92:93], v[152:153], v[92:93]
		v_pk_fma_f32 v[84:85], v[94:95], v[154:155], v[94:95]
		v_pk_fma_f32 v[86:87], v[96:97], v[156:157], v[96:97]
		v_pk_fma_f32 v[92:93], v[98:99], v[158:159], v[98:99]
		v_pk_fma_f32 v[94:95], v[100:101], v[160:161], v[100:101]
		v_pk_fma_f32 v[96:97], v[102:103], v[162:163], v[102:103]
		v_pk_fma_f32 v[98:99], v[104:105], v[164:165], v[104:105]
		v_pk_fma_f32 v[100:101], v[106:107], v[166:167], v[106:107]
		v_pk_fma_f32 v[102:103], v[116:117], v[168:169], v[116:117]
		v_pk_fma_f32 v[104:105], v[118:119], v[170:171], v[118:119]
		v_pk_fma_f32 v[106:107], v[120:121], v[172:173], v[120:121]
		v_pk_fma_f32 v[108:109], v[122:123], v[174:175], v[122:123]
		v_pk_fma_f32 v[110:111], v[124:125], v[176:177], v[124:125]
		v_pk_fma_f32 v[112:113], v[126:127], v[178:179], v[126:127]
		v_pk_fma_f32 v[114:115], v[128:129], v[180:181], v[128:129]
		v_pk_fma_f32 v[116:117], v[130:131], v[182:183], v[130:131]
		v_pk_fma_f32 v[118:119], v[136:137], v[184:185], v[136:137]
		v_pk_fma_f32 v[120:121], v[138:139], v[186:187], v[138:139]
		v_pk_fma_f32 v[122:123], v[140:141], v[188:189], v[140:141]
		v_pk_fma_f32 v[124:125], v[142:143], v[190:191], v[142:143]
		v_pk_fma_f32 v[126:127], v[54:55], v[192:193], v[54:55]
		v_pk_fma_f32 v[54:55], v[58:59], v[194:195], v[58:59]
		v_pk_fma_f32 v[58:59], v[88:89], v[196:197], v[88:89]
		v_pk_fma_f32 v[88:89], v[90:91], v[200:201], v[90:91]
		v_cmp_lt_i32_e64 vcc, v67, s12
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v66, s12
		s_mov_b64 s[72:73], vcc
		v_cmp_lt_i32_e64 vcc, v65, s12
		s_mov_b64 s[74:75], vcc
		v_cmp_lt_i32_e64 vcc, v64, s12
		s_mov_b64 s[76:77], vcc
		v_cmp_lt_i32_e64 vcc, v63, s12
		s_mov_b64 s[78:79], vcc
		v_cmp_lt_i32_e64 vcc, v62, s12
		s_mov_b64 s[80:81], vcc
		v_cmp_lt_i32_e64 vcc, v61, s12
		s_mov_b64 s[82:83], vcc
		v_cmp_lt_i32_e64 vcc, v57, s12
		s_mov_b64 s[84:85], vcc
		v_add_u32_e32 v43, s70, v2
		v_cmp_lt_i32_e64 vcc, v43, s13
		s_mov_b64 s[70:71], vcc
		v_cvt_pk_f16_f32 v60, v144, v145
		s_and_b64 s[68:69], s[68:69], s[70:71]
		v_cvt_pk_f16_f32 v61, v72, v73
		s_and_b64 s[72:73], s[72:73], s[70:71]
		v_cvt_pk_f16_f32 v62, v74, v75
		s_and_b64 s[74:75], s[74:75], s[70:71]
		v_cvt_pk_f16_f32 v63, v68, v69
		s_and_b64 s[76:77], s[76:77], s[70:71]
		s_and_b64 s[78:79], s[78:79], s[70:71]
		s_and_b64 s[80:81], s[80:81], s[70:71]
		s_and_b64 s[82:83], s[82:83], s[70:71]
		s_and_b64 s[70:71], s[84:85], s[70:71]
		s_lshl_b32 s65, s66, 9
		s_mul_i32 s16, s19, s16
		s_lshl_b32 s16, s16, 10
		s_add_i32 s66, s65, s16
		s_mul_i32 s67, s19, s67
		s_lshl_b32 s67, s67, 8
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[86:87], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v76, v77
		v_cvt_pk_f16_f32 v61, v70, v71
		v_cvt_pk_f16_f32 v62, v78, v79
		v_cvt_pk_f16_f32 v63, v80, v81
		s_add_i32 s66, s36, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v82, v83
		v_cvt_pk_f16_f32 v61, v84, v85
		v_cvt_pk_f16_f32 v62, v86, v87
		v_cvt_pk_f16_f32 v63, v92, v93
		s_add_i32 s66, s59, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[86:87], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v94, v95
		v_cvt_pk_f16_f32 v61, v96, v97
		v_cvt_pk_f16_f32 v62, v98, v99
		v_cvt_pk_f16_f32 v63, v100, v101
		s_add_i32 s66, s60, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v102, v103
		v_cvt_pk_f16_f32 v61, v104, v105
		v_cvt_pk_f16_f32 v62, v106, v107
		v_cvt_pk_f16_f32 v63, v108, v109
		s_add_i32 s66, s61, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v110, v111
		v_cvt_pk_f16_f32 v61, v112, v113
		v_cvt_pk_f16_f32 v62, v114, v115
		v_cvt_pk_f16_f32 v63, v116, v117
		s_add_i32 s66, s62, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v118, v119
		v_cvt_pk_f16_f32 v61, v120, v121
		v_cvt_pk_f16_f32 v62, v122, v123
		v_cvt_pk_f16_f32 v63, v124, v125
		s_add_i32 s66, s63, s65
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s67
		v_add3_u32 v43, s66, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v60, v126, v127
		v_cvt_pk_f16_f32 v61, v54, v55
		v_cvt_pk_f16_f32 v62, v58, v59
		v_cvt_pk_f16_f32 v63, v88, v89
		s_add_i32 s65, s64, s65
		s_add_i32 s16, s65, s16
		s_add_i32 s16, s16, s67
		v_add3_u32 v43, s16, v8, v38
		v_lshl_add_u32 v43, v6, 8, v43
		v_lshl_add_u32 v43, v3, 7, v43
		v_add3_u32 v43, v43, v1, v25
		s_and_saveexec_b64 s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_dwordx4 v[60:63], v43, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[86:87]
		s_barrier
		s_add_i32 s3, s3, 0x100
		s_cmp_lt_i32 s3, s20
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_0
.Ltlx_addmm_glu_kernel_persistent.loop_exit_0:
		s_endpgm
	.size	tlx_addmm_glu_kernel_persistent, .-tlx_addmm_glu_kernel_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel tlx_addmm_glu_kernel_persistent
		.amdhsa_group_segment_fixed_size 108736
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
		.amdhsa_next_free_vgpr 202
		.amdhsa_next_free_sgpr 88
		.amdhsa_accum_offset 204
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 202
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 88
	.set .Ltlx_addmm_glu_kernel_persistent.num_named_barrier, 0
	.set .Ltlx_addmm_glu_kernel_persistent.private_seg_size, 0
	.set .Ltlx_addmm_glu_kernel_persistent.uses_vcc, 1
	.set .Ltlx_addmm_glu_kernel_persistent.uses_flat_scratch, 0
	.set .Ltlx_addmm_glu_kernel_persistent.has_dyn_sized_stack, 0
	.set .Ltlx_addmm_glu_kernel_persistent.has_recursion, 0
	.set .Ltlx_addmm_glu_kernel_persistent.has_indirect_call, 0
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
    .group_segment_fixed_size: 108736
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     88
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     202
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 1
    wave.regalloc.agpr.dwords: 0
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
