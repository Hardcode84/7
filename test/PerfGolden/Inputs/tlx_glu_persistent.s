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
		v_add_u32_e32 v25, 1, v26
		v_add_u32_e32 v27, 2, v26
		v_add_u32_e32 v28, 3, v26
		v_add_u32_e32 v29, 4, v26
		v_add_u32_e32 v30, 5, v26
		v_add_u32_e32 v31, 6, v26
		v_add_u32_e32 v32, 7, v26
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v33, 1, v0
		v_mov_b32_e32 v34, 8
		v_mul_lo_u32 v34, v34, v33
		v_lshrrev_b32_e32 v33, 1, v0
		v_and_b32_e32 v35, 1, v33
		v_mov_b32_e32 v36, 16
		v_mul_lo_u32 v36, v36, v35
		v_xor_b32_e32 v34, v34, v36
		v_mov_b32_e32 v35, 8
		v_mul_lo_u32 v35, v35, v16
		v_cmp_lt_i32_e64 s[24:25], v34, s14
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v36, v10, v12, v16 bitop3:0x96
		v_xor_b32_e32 v36, v36, v35
		v_bitop3_b32 v10, 4, v10, v12 bitop3:0x96
		v_bitop3_b32 v10, v10, v16, v35 bitop3:0x96
		v_cmp_lt_i32_e64 s[26:27], v36, s14
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 s[28:29], v34, s23
		v_cmp_lt_i32_e64 s[30:31], v36, s23
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 s[32:33], v34, s23
		v_cmp_lt_i32_e64 s[34:35], v36, s23
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
		v_cmp_eq_u32_e64 s[8:9], v15, s2
		v_cmp_ne_u32_e64 s[10:11], v15, s2
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v12
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v14
		v_bitop3_b32 v14, v9, v16, v12 bitop3:0x96
		v_xor_b32_e32 v14, v14, v35
		v_bitop3_b32 v37, 16, v9, v16 bitop3:0x96
		v_bitop3_b32 v37, v37, v12, v35 bitop3:0x96
		v_bitop3_b32 v38, 32, v9, v16 bitop3:0x96
		v_bitop3_b32 v38, v38, v12, v35 bitop3:0x96
		v_bitop3_b32 v39, 48, v9, v16 bitop3:0x96
		v_bitop3_b32 v39, v39, v12, v35 bitop3:0x96
		v_bitop3_b32 v40, 64, v9, v16 bitop3:0x96
		v_bitop3_b32 v40, v40, v12, v35 bitop3:0x96
		v_xor_b32_e32 v41, 0x50, v9
		v_xor_b32_e32 v41, v41, v16
		v_xor_b32_e32 v41, v41, v12
		v_xor_b32_e32 v41, v41, v35
		v_xor_b32_e32 v42, 0x60, v9
		v_xor_b32_e32 v42, v42, v16
		v_xor_b32_e32 v42, v42, v12
		v_xor_b32_e32 v42, v42, v35
		v_xor_b32_e32 v9, 0x70, v9
		v_xor_b32_e32 v9, v9, v16
		v_xor_b32_e32 v9, v9, v12
		v_xor_b32_e32 v9, v9, v35
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v4
		v_bitop3_b32 v2, v34, v12, v2 bitop3:0x96
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
		s_cmp_lt_i32 s13, 0
		v_mul_f32_e32 v12, v4, v12
		v_cvt_u32_f32_e32 v12, v12
		v_xad_u32 v16, v7, -1, 1
		v_mul_lo_u32 v35, v16, v12
		v_mul_hi_u32 v35, v12, v35
		v_add_u32_e32 v12, v12, v35
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v35, s13
		v_mov_b32_e32 v43, s39
		v_cndmask_b32_e64 v35, v35, v43, s[60:61]
		v_cvt_f32_u32_e32 v43, v35
		v_rcp_iflag_f32_e32 v43, v43
		v_and_b32_e32 v33, 1, v33
		v_mul_f32_e32 v43, v4, v43
		v_cvt_u32_f32_e32 v43, v43
		v_xad_u32 v44, v35, -1, 1
		v_mul_lo_u32 v45, v44, v43
		v_mul_hi_u32 v45, v43, v45
		v_add_u32_e32 v43, v43, v45
		v_and_b32_e32 v45, 1, v0
		v_lshlrev_b32_e32 v45, 4, v45
		v_lshlrev_b32_e32 v33, 5, v33
		v_add_u32_e32 v46, v45, v33
		v_mov_b32_e32 v47, 0x80000000
		v_lshlrev_b32_e32 v48, 3, v15
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v49, 1, v13
		v_and_b32_e32 v50, 1, v11
		v_add3_u32 v48, v48, v49, v50
		v_and_b32_e32 v49, 1, v8
		v_lshl_add_u32 v48, v49, 4, v48
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v51, s17, v48
		v_lshlrev_b32_e32 v51, 1, v51
		v_add_u32_e32 v48, 4, v48
		v_mul_lo_u32 v48, s17, v48
		v_lshlrev_b32_e32 v48, 1, v48
		s_lshl_b32 s39, s17, 6
		s_lshl_b32 s56, s17, 7
		v_and_b32_e32 v52, 63, v0
		v_lshrrev_b32_e32 v53, 4, v52
		v_lshlrev_b32_e32 v54, 4, v53
		v_lshl_add_u32 v15, v15, 9, v54
		v_and_b32_e32 v54, 15, v52
		v_lshrrev_b32_e32 v55, 1, v54
		v_lshlrev_b32_e32 v55, 6, v55
		v_and_b32_e32 v54, 1, v54
		v_mov_b32_e32 v56, 0x420
		v_mul_lo_u32 v56, v56, v54
		v_add3_u32 v15, v15, v55, v56
		v_and_b32_e32 v54, 3, v0
		v_and_b32_e32 v55, 3, v11
		v_lshlrev_b32_e32 v55, 5, v55
		v_lshl_add_u32 v54, v54, 3, v55
		v_lshlrev_b32_e32 v55, 9, v49
		v_and_b32_e32 v56, 7, v1
		v_mov_b32_e32 v57, 0x420
		v_mul_lo_u32 v57, v57, v56
		v_add3_u32 v54, v54, v55, v57
		v_add_u32_e32 v55, 0xc0, v46
		s_lshl_b32 s57, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s58, 0xc0, s17
		s_mul_i32 s59, 0x2100, s36
		v_add_u32_e32 v56, s59, v15
		s_mul_i32 s36, 0x4200, s36
		v_add_u32_e32 v57, s36, v54
		s_mul_i32 s36, 0x2100, s21
		v_add_u32_e32 v58, s36, v15
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v59, s21, v54
		v_lshlrev_b32_e32 v49, 1, v49
		v_lshlrev_b32_e32 v50, 2, v50
		v_lshlrev_b32_e32 v13, 3, v13
		v_xor_b32_e32 v13, v50, v13
		v_bitop3_b32 v13, v0, v49, v13 bitop3:0x96
		v_lshlrev_b32_e32 v49, 4, v13
		v_add_u32_e32 v49, 0x10000, v49
		v_xor_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_add_u32_e32 v13, 0x10000, v13
		v_and_b32_e32 v50, 1, v53
		v_lshlrev_b32_e32 v50, 14, v50
		v_add_u32_e32 v50, 0x10000, v50
		v_lshrrev_b32_e32 v53, 3, v52
		v_and_b32_e32 v53, 1, v53
		v_lshl_add_u32 v50, v53, 13, v50
		v_lshrrev_b32_e32 v60, 5, v52
		v_lshl_add_u32 v11, v11, 1, v60
		v_lshrrev_b32_e32 v60, 2, v52
		v_and_b32_e32 v60, 1, v60
		v_lshl_add_u32 v11, v60, 7, v11
		v_lshrrev_b32_e32 v61, 1, v52
		v_and_b32_e32 v61, 1, v61
		v_lshl_add_u32 v11, v61, 6, v11
		v_and_b32_e32 v52, 1, v52
		v_lshl_add_u32 v11, v52, 5, v11
		v_lshlrev_b32_e32 v52, 1, v52
		v_lshlrev_b32_e32 v61, 2, v61
		v_lshlrev_b32_e32 v60, 3, v60
		v_bitop3_b32 v53, v61, v60, v53 bitop3:0x96
		v_bitop3_b32 v11, v11, v52, v53 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, v50
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
		v_mov_b32_e32 v50, s68
		v_cvt_f32_u32_e32 v50, v50
		v_rcp_iflag_f32_e32 v50, v50
		s_barrier
		v_mul_f32_e32 v50, v4, v50
		v_cvt_u32_f32_e32 v50, v50
		s_xor_b32 s69, s68, -1
		v_readfirstlane_b32 s70, v50
		s_add_i32 s69, s69, 1
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
		v_mov_b32_e32 v50, s70
		v_cvt_f32_u32_e32 v50, v50
		v_rcp_iflag_f32_e32 v50, v50
		s_nop 0
		v_mul_f32_e32 v50, v4, v50
		v_cvt_u32_f32_e32 v50, v50
		s_xor_b32 s72, s70, -1
		v_readfirstlane_b32 s73, v50
		s_add_i32 s72, s72, 1
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
		v_add_u32_e32 v50, s68, v5
		v_cmp_lt_i32_e64 vcc, v50, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v52, v50, -1, 1
		v_add_u32_e32 v53, s68, v17
		v_cndmask_b32_e32 v50, v50, v52, vcc
		v_mul_hi_u32 v52, v50, v12
		v_mul_lo_u32 v52, v52, v7
		v_xor_b32_e32 v52, -1, v52
		v_add3_u32 v50, 1, v52, v50
		v_add_u32_e32 v52, v50, v16
		v_cmp_ge_u32_e64 vcc, v50, v7
		v_add_u32_e32 v60, s68, v18
		v_add_u32_e32 v61, s68, v19
		v_cndmask_b32_e32 v50, v50, v52, vcc
		v_add_u32_e32 v52, v50, v16
		v_cmp_ge_u32_e64 vcc, v50, v7
		v_add_u32_e32 v62, s68, v20
		v_add_u32_e32 v63, s68, v21
		v_cndmask_b32_e32 v50, v50, v52, vcc
		v_xad_u32 v52, v50, -1, 1
		v_cmp_lt_i32_e64 vcc, v53, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v64, v53, -1, 1
		v_add_u32_e32 v65, s68, v22
		v_cndmask_b32_e32 v53, v53, v64, vcc
		v_mul_hi_u32 v64, v53, v12
		v_mul_lo_u32 v64, v64, v7
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v53, 1, v64, v53
		v_add_u32_e32 v64, v53, v16
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_add_u32_e32 v66, s68, v23
		v_add_u32_e32 v67, s68, v24
		v_cndmask_b32_e32 v53, v53, v64, vcc
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_cndmask_b32_e64 v50, v50, v52, s[70:71]
		v_add_u32_e32 v52, v53, v16
		v_cndmask_b32_e32 v52, v53, v52, vcc
		v_xad_u32 v53, v52, -1, 1
		v_cmp_lt_i32_e64 vcc, v60, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v64, v60, -1, 1
		v_cndmask_b32_e64 v52, v52, v53, s[72:73]
		v_cndmask_b32_e32 v53, v60, v64, vcc
		v_mul_hi_u32 v60, v53, v12
		v_mul_lo_u32 v60, v60, v7
		v_xor_b32_e32 v60, -1, v60
		v_add3_u32 v53, 1, v60, v53
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_add_u32_e32 v60, v53, v16
		s_mul_i32 s67, s19, s67
		v_cndmask_b32_e32 v53, v53, v60, vcc
		v_cmp_ge_u32_e64 vcc, v53, v7
		v_add_u32_e32 v60, v53, v16
		v_mul_lo_u32 v52, s18, v52
		v_cndmask_b32_e32 v53, v53, v60, vcc
		v_xad_u32 v60, v53, -1, 1
		v_cmp_lt_i32_e64 vcc, v61, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v64, v61, -1, 1
		v_cndmask_b32_e64 v53, v53, v60, s[70:71]
		v_cndmask_b32_e32 v60, v61, v64, vcc
		v_mul_hi_u32 v61, v60, v12
		v_mul_lo_u32 v61, v61, v7
		v_xor_b32_e32 v61, -1, v61
		v_add3_u32 v60, 1, v61, v60
		v_cmp_ge_u32_e64 vcc, v60, v7
		v_add_u32_e32 v61, v60, v16
		v_mul_lo_u32 v53, s18, v53
		v_cndmask_b32_e32 v60, v60, v61, vcc
		v_cmp_ge_u32_e64 vcc, v60, v7
		v_add_u32_e32 v61, v60, v16
		s_lshr_b32 s65, s65, 6
		v_cndmask_b32_e32 v60, v60, v61, vcc
		v_xad_u32 v61, v60, -1, 1
		v_cmp_lt_i32_e64 vcc, v62, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v64, v62, -1, 1
		v_cndmask_b32_e64 v60, v60, v61, s[72:73]
		v_cndmask_b32_e32 v61, v62, v64, vcc
		v_mul_hi_u32 v62, v61, v12
		v_mul_lo_u32 v62, v62, v7
		v_xor_b32_e32 v62, -1, v62
		v_add3_u32 v61, 1, v62, v61
		v_cmp_ge_u32_e64 vcc, v61, v7
		v_add_u32_e32 v62, v61, v16
		v_mul_lo_u32 v60, s18, v60
		v_cndmask_b32_e32 v61, v61, v62, vcc
		v_cmp_ge_u32_e64 vcc, v61, v7
		v_add_u32_e32 v62, v61, v16
		v_xad_u32 v64, v63, -1, 1
		v_cndmask_b32_e32 v61, v61, v62, vcc
		v_xad_u32 v62, v61, -1, 1
		v_cmp_lt_i32_e64 vcc, v63, s2
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v61, v61, v62, s[70:71]
		s_mul_i32 s69, s66, 0x100
		v_cndmask_b32_e32 v62, v63, v64, vcc
		v_mul_hi_u32 v63, v62, v12
		v_mul_lo_u32 v63, v63, v7
		v_xor_b32_e32 v63, -1, v63
		v_add3_u32 v62, 1, v63, v62
		v_cmp_ge_u32_e64 vcc, v62, v7
		v_add_u32_e32 v63, v62, v16
		v_add_u32_e32 v64, s68, v9
		v_cndmask_b32_e32 v62, v62, v63, vcc
		v_cmp_ge_u32_e64 vcc, v62, v7
		v_add_u32_e32 v63, v62, v16
		v_add_u32_e32 v68, s68, v42
		v_cndmask_b32_e32 v62, v62, v63, vcc
		v_xad_u32 v63, v62, -1, 1
		v_cmp_lt_i32_e64 vcc, v65, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v69, v65, -1, 1
		v_cndmask_b32_e64 v62, v62, v63, s[72:73]
		v_cndmask_b32_e32 v63, v65, v69, vcc
		v_mul_hi_u32 v65, v63, v12
		v_mul_lo_u32 v65, v65, v7
		v_xor_b32_e32 v65, -1, v65
		v_add3_u32 v63, 1, v65, v63
		v_cmp_ge_u32_e64 vcc, v63, v7
		v_add_u32_e32 v65, v63, v16
		v_add_u32_e32 v69, s68, v41
		v_cndmask_b32_e32 v63, v63, v65, vcc
		v_cmp_ge_u32_e64 vcc, v63, v7
		v_add_u32_e32 v65, v63, v16
		v_add_u32_e32 v70, s68, v40
		v_cndmask_b32_e32 v63, v63, v65, vcc
		v_xad_u32 v65, v63, -1, 1
		v_cmp_lt_i32_e64 vcc, v66, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v71, v66, -1, 1
		v_cndmask_b32_e64 v63, v63, v65, s[70:71]
		v_cndmask_b32_e32 v65, v66, v71, vcc
		v_mul_hi_u32 v66, v65, v12
		v_mul_lo_u32 v66, v66, v7
		v_xor_b32_e32 v66, -1, v66
		v_add3_u32 v65, 1, v66, v65
		v_cmp_ge_u32_e64 vcc, v65, v7
		v_add_u32_e32 v66, v65, v16
		v_add_u32_e32 v71, s68, v39
		v_cndmask_b32_e32 v65, v65, v66, vcc
		v_cmp_ge_u32_e64 vcc, v65, v7
		v_add_u32_e32 v66, v65, v16
		v_add_u32_e32 v72, s68, v38
		v_cndmask_b32_e32 v65, v65, v66, vcc
		v_xad_u32 v66, v65, -1, 1
		v_cmp_lt_i32_e64 vcc, v67, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v73, v67, -1, 1
		v_cndmask_b32_e64 v65, v65, v66, s[72:73]
		v_cndmask_b32_e32 v66, v67, v73, vcc
		v_mul_hi_u32 v67, v66, v12
		v_mul_lo_u32 v67, v67, v7
		v_xor_b32_e32 v67, -1, v67
		v_add3_u32 v66, 1, v67, v66
		v_cmp_ge_u32_e64 vcc, v66, v7
		v_add_u32_e32 v67, v66, v16
		v_add_u32_e32 v73, s68, v37
		v_cndmask_b32_e32 v66, v66, v67, vcc
		v_cmp_ge_u32_e64 vcc, v66, v7
		v_add_u32_e32 v67, v66, v16
		v_mul_lo_u32 v65, s18, v65
		v_cndmask_b32_e32 v66, v66, v67, vcc
		v_xad_u32 v67, v66, -1, 1
		v_add_u32_e32 v74, s69, v26
		v_cmp_lt_i32_e64 vcc, v74, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v75, v74, -1, 1
		v_cndmask_b32_e64 v66, v66, v67, s[70:71]
		v_cndmask_b32_e32 v67, v74, v75, vcc
		v_mul_hi_u32 v74, v67, v43
		v_mul_lo_u32 v74, v74, v35
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v67, 1, v74, v67
		v_add_u32_e32 v74, v67, v44
		v_cmp_ge_u32_e64 vcc, v67, v35
		v_add_u32_e32 v75, s69, v25
		v_add_u32_e32 v76, s69, v27
		v_cndmask_b32_e32 v67, v67, v74, vcc
		v_add_u32_e32 v74, v67, v44
		v_cmp_ge_u32_e64 vcc, v67, v35
		v_add_u32_e32 v77, s69, v28
		v_add_u32_e32 v78, s69, v29
		v_cndmask_b32_e32 v67, v67, v74, vcc
		v_xad_u32 v74, v67, -1, 1
		v_cmp_lt_i32_e64 vcc, v75, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v79, v75, -1, 1
		v_add_u32_e32 v80, s69, v30
		v_cndmask_b32_e32 v75, v75, v79, vcc
		v_mul_hi_u32 v79, v75, v43
		v_mul_lo_u32 v79, v79, v35
		v_xor_b32_e32 v79, -1, v79
		v_add3_u32 v75, 1, v79, v75
		v_add_u32_e32 v79, v75, v44
		v_cmp_ge_u32_e64 vcc, v75, v35
		v_add_u32_e32 v81, s69, v31
		v_add_u32_e32 v82, s69, v32
		v_cndmask_b32_e32 v75, v75, v79, vcc
		v_cmp_ge_u32_e64 vcc, v75, v35
		v_cndmask_b32_e64 v67, v67, v74, s[72:73]
		v_add_u32_e32 v74, v75, v44
		v_cndmask_b32_e32 v74, v75, v74, vcc
		v_xad_u32 v75, v74, -1, 1
		v_cmp_lt_i32_e64 vcc, v76, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v79, v76, -1, 1
		v_cndmask_b32_e64 v74, v74, v75, s[70:71]
		v_cndmask_b32_e32 v75, v76, v79, vcc
		v_mul_hi_u32 v76, v75, v43
		v_mul_lo_u32 v76, v76, v35
		v_xor_b32_e32 v76, -1, v76
		v_add3_u32 v75, 1, v76, v75
		v_cmp_ge_u32_e64 vcc, v75, v35
		v_add_u32_e32 v76, v75, v44
		v_add_u32_e32 v79, s68, v14
		v_cndmask_b32_e32 v75, v75, v76, vcc
		v_cmp_ge_u32_e64 vcc, v75, v35
		v_add_u32_e32 v76, v75, v44
		v_mul_lo_u32 v66, s18, v66
		v_cndmask_b32_e32 v75, v75, v76, vcc
		v_xad_u32 v76, v75, -1, 1
		v_cmp_lt_i32_e64 vcc, v77, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v83, v77, -1, 1
		v_cndmask_b32_e64 v75, v75, v76, s[72:73]
		v_cndmask_b32_e32 v76, v77, v83, vcc
		v_mul_hi_u32 v77, v76, v43
		v_mul_lo_u32 v77, v77, v35
		v_xor_b32_e32 v77, -1, v77
		v_add3_u32 v76, 1, v77, v76
		v_cmp_ge_u32_e64 vcc, v76, v35
		v_add_u32_e32 v77, v76, v44
		v_mul_lo_u32 v63, s18, v63
		v_cndmask_b32_e32 v76, v76, v77, vcc
		v_cmp_ge_u32_e64 vcc, v76, v35
		v_add_u32_e32 v77, v76, v44
		v_mul_lo_u32 v62, s18, v62
		v_cndmask_b32_e32 v76, v76, v77, vcc
		v_xad_u32 v77, v76, -1, 1
		v_cmp_lt_i32_e64 vcc, v78, s2
		s_mov_b64 s[72:73], vcc
		v_xad_u32 v83, v78, -1, 1
		v_cndmask_b32_e64 v76, v76, v77, s[70:71]
		v_cndmask_b32_e32 v77, v78, v83, vcc
		v_mul_hi_u32 v78, v77, v43
		v_mul_lo_u32 v78, v78, v35
		v_xor_b32_e32 v78, -1, v78
		v_add3_u32 v77, 1, v78, v77
		v_cmp_ge_u32_e64 vcc, v77, v35
		v_add_u32_e32 v78, v77, v44
		v_mul_lo_u32 v61, s18, v61
		v_cndmask_b32_e32 v77, v77, v78, vcc
		v_cmp_ge_u32_e64 vcc, v77, v35
		v_add_u32_e32 v78, v77, v44
		s_mul_i32 s65, 0x420, s65
		v_cndmask_b32_e32 v77, v77, v78, vcc
		v_xad_u32 v78, v77, -1, 1
		v_cmp_lt_i32_e64 vcc, v80, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v83, v80, -1, 1
		v_cndmask_b32_e64 v77, v77, v78, s[72:73]
		v_cndmask_b32_e32 v78, v80, v83, vcc
		v_mul_hi_u32 v80, v78, v43
		v_mul_lo_u32 v80, v80, v35
		v_xor_b32_e32 v80, -1, v80
		v_add3_u32 v78, 1, v80, v78
		v_cmp_ge_u32_e64 vcc, v78, v35
		v_add_u32_e32 v80, v78, v44
		s_mov_b32 m0, s65
		v_cndmask_b32_e32 v78, v78, v80, vcc
		v_cmp_ge_u32_e64 vcc, v78, v35
		v_add_u32_e32 v80, v78, v44
		v_xad_u32 v83, v81, -1, 1
		v_cndmask_b32_e32 v78, v78, v80, vcc
		v_xad_u32 v80, v78, -1, 1
		v_cmp_lt_i32_e64 vcc, v81, s2
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v78, v78, v80, s[70:71]
		v_mul_lo_u32 v80, s57, v50
		v_cndmask_b32_e32 v81, v81, v83, vcc
		v_mul_hi_u32 v83, v81, v43
		v_mul_lo_u32 v83, v83, v35
		v_xor_b32_e32 v83, -1, v83
		v_add3_u32 v81, 1, v83, v81
		v_cmp_ge_u32_e64 vcc, v81, v35
		v_add_u32_e32 v83, v81, v44
		v_mul_lo_u32 v50, s15, v50
		v_cndmask_b32_e32 v81, v81, v83, vcc
		v_cmp_ge_u32_e64 vcc, v81, v35
		v_add_u32_e32 v83, v81, v44
		v_lshl_add_u32 v50, v50, 1, v46
		v_cndmask_b32_e32 v81, v81, v83, vcc
		v_xad_u32 v83, v81, -1, 1
		v_cmp_lt_i32_e64 vcc, v82, s2
		s_mov_b64 s[70:71], vcc
		v_xad_u32 v84, v82, -1, 1
		v_cndmask_b32_e64 v81, v81, v83, s[72:73]
		v_cndmask_b32_e32 v82, v82, v84, vcc
		v_mul_hi_u32 v83, v82, v43
		v_mul_lo_u32 v83, v83, v35
		v_xor_b32_e32 v83, -1, v83
		v_add3_u32 v82, 1, v83, v82
		v_cmp_ge_u32_e64 vcc, v82, v35
		v_add_u32_e32 v83, v82, v44
		v_lshlrev_b32_e32 v84, 1, v67
		v_cndmask_b32_e32 v82, v82, v83, vcc
		v_cmp_ge_u32_e64 vcc, v82, v35
		v_add_u32_e32 v83, v82, v44
		v_cndmask_b32_e64 v85, v47, v50, s[24:25]
		v_cndmask_b32_e32 v82, v82, v83, vcc
		buffer_load_dwordx4 v85, s[40:43], 0 offen lds
		v_xad_u32 v83, v82, -1, 1
		v_add_u32_e32 v85, v51, v84
		v_cndmask_b32_e64 v86, v47, v85, s[26:27]
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v87, v48, v84
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v86, v47, v87, s[26:27]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v88, 64, v50
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v86, v47, v88, s[28:29]
		s_add_i32 m0, m0, 0xffff9d20
		v_add_u32_e32 v50, 0x80, v50
		buffer_load_dwordx4 v86, s[40:43], 0 offen lds
		v_add_u32_e32 v86, s39, v85
		v_cndmask_b32_e64 v86, v47, v86, s[30:31]
		s_add_i32 m0, m0, 0x83e0
		v_cndmask_b32_e64 v50, v47, v50, s[32:33]
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_add_u32_e32 v86, s39, v87
		v_cndmask_b32_e64 v86, v47, v86, s[30:31]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v88, s56, v85
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v86, v47, v88, s[34:35]
		s_add_i32 m0, m0, 0xffff7c20
		v_add_u32_e32 v88, s56, v87
		buffer_load_dwordx4 v50, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v50, v47, v88, s[34:35]
		s_add_i32 m0, m0, 0xa4e0
		s_mul_i32 s16, s19, s16
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		s_lshl_b32 s66, s66, 9
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v82, v82, v83, s[70:71]
		buffer_load_dwordx4 v50, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[88:91], v15
		ds_read_b128 v[92:95], v15 offset:2112
		ds_read_b128 v[96:99], v15 offset:4224
		ds_read_b128 v[100:103], v15 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[104:105], v54 offset:25312
		ds_read_b64_tr_b16 v[106:107], v54 offset:33760
		ds_read_b64_tr_b16 v[108:109], v54 offset:25440
		ds_read_b64_tr_b16 v[110:111], v54 offset:33888
		ds_read_b64_tr_b16 v[112:113], v54 offset:25568
		ds_read_b64_tr_b16 v[114:115], v54 offset:34016
		ds_read_b64_tr_b16 v[116:117], v54 offset:25696
		ds_read_b64_tr_b16 v[118:119], v54 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[86:87], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[86:87]
		s_setprio 0
		v_add_u32_e32 v50, v55, v80
		s_mov_b32 s68, 0
		s_mov_b32 s70, 0
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
		s_cmp_lg_u32 s21, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_cmp_ge_u32 s68, 2
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s68, -2
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		s_add_i32 s73, s68, 1
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s73
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		s_add_i32 s72, s70, 3
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[92:95], v[140:143]
		s_mul_i32 s72, s72, 32
		v_mfma_f32_16x16x32_f16 v[144:147], v[112:115], v[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[112:115], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[116:119], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[116:119], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[100:103], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[112:115], v[100:103], v[176:179]
		s_setprio 1
		s_barrier
		s_xor_b32 s72, s72, -1
		s_add_i32 s72, s72, 1
		s_add_i32 s72, s14, s72
		v_cmp_lt_i32_e64 vcc, v34, s72
		v_cmp_lt_i32_e64 s[74:75], v36, s72
		s_lshl_b32 s73, s70, 6
		v_cndmask_b32_e32 v80, v47, v50, vcc
		s_mul_i32 s76, 0x2100, s68
		v_cmp_lt_i32_e64 vcc, v10, s72
		s_add_i32 m0, s65, s76
		s_mul_i32 s68, 0x4200, s68
		buffer_load_dwordx4 v80, s[40:43], s73 offen lds
		s_mul_i32 s72, s17, s70
		s_lshl_b32 s72, s72, 6
		s_add_i32 s72, s58, s72
		v_add_u32_e32 v80, s72, v85
		v_cndmask_b32_e64 v80, v47, v80, s[74:75]
		s_add_i32 s68, s65, s68
		v_add_u32_e32 v83, s72, v87
		s_add_i32 m0, s68, 0x62e0
		v_cndmask_b32_e32 v83, v47, v83, vcc
		buffer_load_dwordx4 v80, s[44:47], 0 offen lds
		s_mul_i32 s68, 0x4200, s71
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v80, s68, v54
		buffer_load_dwordx4 v83, s[44:47], 0 offen lds
		s_barrier
		s_mul_i32 s68, 0x2100, s71
		v_add_u32_e32 v83, s68, v15
		s_waitcnt vmcnt(3)
		ds_read_b128 v[88:91], v83
		ds_read_b128 v[92:95], v83 offset:2112
		ds_read_b128 v[96:99], v83 offset:4224
		ds_read_b128 v[100:103], v83 offset:6336
		ds_read_b64_tr_b16 v[104:105], v80 offset:25312
		ds_read_b64_tr_b16 v[106:107], v80 offset:33760
		ds_read_b64_tr_b16 v[108:109], v80 offset:25440
		ds_read_b64_tr_b16 v[110:111], v80 offset:33888
		ds_read_b64_tr_b16 v[112:113], v80 offset:25568
		ds_read_b64_tr_b16 v[114:115], v80 offset:34016
		ds_read_b64_tr_b16 v[116:117], v80 offset:25696
		ds_read_b64_tr_b16 v[118:119], v80 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s70, s70, 1
		s_cmp_lt_i32 s70, s23
		s_mov_b32 s68, s71
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
		buffer_load_dwordx4 v[184:187], v84, s[48:51], 0 offen
		v_add_lshl_u32 v50, v67, v52, 1
		buffer_load_ushort v80, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v52, 1
		buffer_load_ushort v83, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v52, 1
		buffer_load_ushort v84, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v52, 1
		buffer_load_ushort v85, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v52, 1
		buffer_load_ushort v86, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v52, 1
		buffer_load_ushort v87, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v52, 1
		buffer_load_ushort v188, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v52, 1
		buffer_load_ushort v52, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v53, 1
		buffer_load_ushort v189, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v53, 1
		buffer_load_ushort v190, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v53, 1
		buffer_load_ushort v191, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v53, 1
		buffer_load_ushort v192, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v53, 1
		buffer_load_ushort v193, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v53, 1
		buffer_load_ushort v194, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v53, 1
		buffer_load_ushort v195, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v53, 1
		buffer_load_ushort v53, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v60, 1
		buffer_load_ushort v196, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v60, 1
		buffer_load_ushort v197, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v60, 1
		buffer_load_ushort v198, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v60, 1
		buffer_load_ushort v199, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v60, 1
		buffer_load_ushort v200, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v60, 1
		buffer_load_ushort v201, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v60, 1
		buffer_load_ushort v202, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v60, 1
		buffer_load_ushort v60, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v61, 1
		buffer_load_ushort v203, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v61, 1
		buffer_load_ushort v204, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v61, 1
		buffer_load_ushort v205, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v61, 1
		buffer_load_ushort v206, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v61, 1
		buffer_load_ushort v207, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v61, 1
		buffer_load_ushort v208, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v61, 1
		buffer_load_ushort v209, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v61, 1
		buffer_load_ushort v61, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v62, 1
		buffer_load_ushort v210, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v62, 1
		buffer_load_ushort v211, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v62, 1
		buffer_load_ushort v212, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v62, 1
		buffer_load_ushort v213, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v62, 1
		buffer_load_ushort v214, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v62, 1
		buffer_load_ushort v215, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v62, 1
		buffer_load_ushort v216, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v62, 1
		buffer_load_ushort v62, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v63, 1
		buffer_load_ushort v217, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v63, 1
		buffer_load_ushort v218, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v63, 1
		buffer_load_ushort v219, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v63, 1
		buffer_load_ushort v220, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v63, 1
		buffer_load_ushort v221, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v63, 1
		buffer_load_ushort v222, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v63, 1
		buffer_load_ushort v223, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v63, 1
		buffer_load_ushort v63, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v65, 1
		buffer_load_ushort v224, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v65, 1
		buffer_load_ushort v225, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v65, 1
		buffer_load_ushort v226, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v65, 1
		buffer_load_ushort v227, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v65, 1
		buffer_load_ushort v228, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v65, 1
		buffer_load_ushort v229, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v65, 1
		buffer_load_ushort v230, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v65, 1
		buffer_load_ushort v65, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v67, v66, 1
		buffer_load_ushort v67, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v74, v66, 1
		buffer_load_ushort v74, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v75, v66, 1
		buffer_load_ushort v75, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v76, v66, 1
		buffer_load_ushort v76, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v77, v66, 1
		buffer_load_ushort v77, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v78, v66, 1
		buffer_load_ushort v78, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v81, v66, 1
		buffer_load_ushort v81, v50, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v50, v82, v66, 1
		buffer_load_ushort v66, v50, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[112:115], v[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[112:115], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[116:119], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[116:119], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[100:103], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[112:115], v[100:103], v[176:179]
		ds_read_b128 v[88:91], v56
		ds_read_b128 v[92:95], v56 offset:2112
		ds_read_b128 v[96:99], v56 offset:4224
		ds_read_b128 v[100:103], v56 offset:6336
		ds_read_b64_tr_b16 v[104:105], v57 offset:25312
		ds_read_b64_tr_b16 v[106:107], v57 offset:33760
		ds_read_b64_tr_b16 v[108:109], v57 offset:25440
		ds_read_b64_tr_b16 v[110:111], v57 offset:33888
		ds_read_b64_tr_b16 v[112:113], v57 offset:25568
		ds_read_b64_tr_b16 v[114:115], v57 offset:34016
		ds_read_b64_tr_b16 v[116:117], v57 offset:25696
		ds_read_b64_tr_b16 v[118:119], v57 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		v_cmp_lt_i32_e64 s[70:71], v79, s12
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[112:115], v[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[112:115], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[116:119], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[116:119], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[100:103], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[112:115], v[100:103], v[176:179]
		ds_read_b128 v[88:91], v58
		ds_read_b128 v[92:95], v58 offset:2112
		ds_read_b128 v[96:99], v58 offset:4224
		ds_read_b128 v[100:103], v58 offset:6336
		ds_read_b64_tr_b16 v[104:105], v59 offset:25312
		ds_read_b64_tr_b16 v[106:107], v59 offset:33760
		ds_read_b64_tr_b16 v[108:109], v59 offset:25440
		ds_read_b64_tr_b16 v[110:111], v59 offset:33888
		ds_read_b64_tr_b16 v[112:113], v59 offset:25568
		ds_read_b64_tr_b16 v[114:115], v59 offset:34016
		ds_read_b64_tr_b16 v[116:117], v59 offset:25696
		ds_read_b64_tr_b16 v[118:119], v59 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		v_cmp_lt_i32_e64 s[72:73], v73, s12
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		s_barrier
		s_nop 2
		ds_write_b128 v49, v[120:123] offset:10432
		ds_write_b128 v13, v[124:127] offset:18624
		ds_write_b128 v49, v[128:131] offset:26816
		s_nop 0
		ds_write_b128 v13, v[132:135] offset:35008
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[112:115], v[92:95], v[144:147]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[160:163], v[112:115], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[116:119], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[116:119], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[100:103], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[112:115], v[100:103], v[176:179]
		ds_read_b128 v[88:91], v11 offset:10432
		ds_read_b128 v[92:95], v11 offset:10688
		ds_read_b128 v[96:99], v11 offset:14528
		ds_read_b128 v[100:103], v11 offset:14784
		v_cmp_lt_i32_e64 s[74:75], v72, s12
		v_cmp_lt_i32_e64 s[76:77], v71, s12
		v_cmp_lt_i32_e64 s[78:79], v70, s12
		v_cmp_lt_i32_e64 s[80:81], v69, s12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v49, v[136:139] offset:10432
		ds_write_b128 v13, v[140:143] offset:18624
		ds_write_b128 v49, v[144:147] offset:26816
		ds_write_b128 v13, v[148:151] offset:35008
		v_cmp_lt_i32_e64 s[82:83], v68, s12
		v_cmp_lt_i32_e64 s[84:85], v64, s12
		s_waitcnt vmcnt(62)
		v_cvt_f32_f16_e32 v68, v80
		v_cvt_f32_f16_e32 v69, v83
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[104:107], v11 offset:10432
		ds_read_b128 v[108:111], v11 offset:10688
		ds_read_b128 v[112:115], v11 offset:14528
		ds_read_b128 v[116:119], v11 offset:14784
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v70, v84
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v71, v85
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v72, v86
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v73, v87
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v49, v[152:155] offset:10432
		ds_write_b128 v13, v[156:159] offset:18624
		ds_write_b128 v49, v[160:163] offset:26816
		ds_write_b128 v13, v[164:167] offset:35008
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v82, v188
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v83, v52
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v84, v189
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v85, v190
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[120:123], v11 offset:10432
		ds_read_b128 v[124:127], v11 offset:10688
		ds_read_b128 v[128:131], v11 offset:14528
		ds_read_b128 v[132:135], v11 offset:14784
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v86, v191
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v87, v192
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v136, v193
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v137, v194
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v49, v[168:171] offset:10432
		ds_write_b128 v13, v[172:175] offset:18624
		ds_write_b128 v49, v[176:179] offset:26816
		ds_write_b128 v13, v[180:183] offset:35008
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v138, v195
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v139, v53
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v52, v196
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v53, v197
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[140:143], v11 offset:10432
		ds_read_b128 v[144:147], v11 offset:10688
		ds_read_b128 v[148:151], v11 offset:14528
		ds_read_b128 v[152:155], v11 offset:14784
		v_cvt_f32_f16_e32 v156, v184
		v_cvt_f32_f16_sdwa v157, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v158, v185
		v_cvt_f32_f16_sdwa v159, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v160, v186
		v_cvt_f32_f16_sdwa v161, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v162, v187
		v_cvt_f32_f16_sdwa v163, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v164, v198
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v165, v199
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v166, v200
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v167, v201
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v168, v202
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v169, v60
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v170, v203
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v171, v204
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v172, v205
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v173, v206
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v174, v207
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v175, v208
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v176, v209
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v177, v61
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v60, v210
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v61, v211
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v178, v212
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v179, v213
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v180, v214
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v181, v215
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v182, v216
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v183, v62
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v184, v217
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v185, v218
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v186, v219
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v187, v220
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v188, v221
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v189, v222
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v190, v223
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v191, v63
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v62, v224
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v63, v225
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v192, v226
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v193, v227
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v194, v228
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v195, v229
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v196, v230
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v197, v65
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v64, v67
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v65, v74
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v198, v75
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v199, v76
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v74, v77
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v75, v78
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v76, v81
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v77, v66
		v_pk_add_f32 v[66:67], v[88:89], v[156:157]
		v_pk_add_f32 v[78:79], v[90:91], v[158:159]
		v_pk_add_f32 v[80:81], v[92:93], v[160:161]
		v_pk_add_f32 v[88:89], v[94:95], v[162:163]
		v_pk_add_f32 v[90:91], v[96:97], v[156:157]
		v_pk_add_f32 v[92:93], v[98:99], v[158:159]
		v_pk_add_f32 v[94:95], v[100:101], v[160:161]
		v_pk_add_f32 v[96:97], v[102:103], v[162:163]
		v_pk_add_f32 v[98:99], v[104:105], v[156:157]
		v_pk_add_f32 v[100:101], v[106:107], v[158:159]
		v_pk_add_f32 v[102:103], v[108:109], v[160:161]
		v_pk_add_f32 v[104:105], v[110:111], v[162:163]
		v_pk_add_f32 v[106:107], v[112:113], v[156:157]
		v_pk_add_f32 v[108:109], v[114:115], v[158:159]
		v_pk_add_f32 v[110:111], v[116:117], v[160:161]
		v_pk_add_f32 v[112:113], v[118:119], v[162:163]
		v_pk_add_f32 v[114:115], v[120:121], v[156:157]
		v_pk_add_f32 v[116:117], v[122:123], v[158:159]
		v_pk_add_f32 v[118:119], v[124:125], v[160:161]
		v_pk_add_f32 v[120:121], v[126:127], v[162:163]
		v_pk_add_f32 v[122:123], v[128:129], v[156:157]
		v_pk_add_f32 v[124:125], v[130:131], v[158:159]
		v_pk_add_f32 v[126:127], v[132:133], v[160:161]
		v_pk_add_f32 v[128:129], v[134:135], v[162:163]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[130:131], v[140:141], v[156:157]
		v_pk_add_f32 v[132:133], v[142:143], v[158:159]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[134:135], v[144:145], v[160:161]
		v_pk_add_f32 v[140:141], v[146:147], v[162:163]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[142:143], v[148:149], v[156:157]
		v_pk_add_f32 v[144:145], v[150:151], v[158:159]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[146:147], v[152:153], v[160:161]
		v_pk_add_f32 v[148:149], v[154:155], v[162:163]
		v_pk_fma_f32 v[150:151], v[66:67], v[68:69], v[66:67]
		v_pk_fma_f32 v[66:67], v[78:79], v[70:71], v[78:79]
		v_pk_fma_f32 v[68:69], v[80:81], v[72:73], v[80:81]
		v_pk_fma_f32 v[70:71], v[88:89], v[82:83], v[88:89]
		v_pk_fma_f32 v[72:73], v[90:91], v[84:85], v[90:91]
		v_pk_fma_f32 v[78:79], v[92:93], v[86:87], v[92:93]
		v_pk_fma_f32 v[80:81], v[94:95], v[136:137], v[94:95]
		v_pk_fma_f32 v[82:83], v[96:97], v[138:139], v[96:97]
		v_pk_fma_f32 v[84:85], v[98:99], v[52:53], v[98:99]
		v_pk_fma_f32 v[52:53], v[100:101], v[164:165], v[100:101]
		v_pk_fma_f32 v[86:87], v[102:103], v[166:167], v[102:103]
		v_pk_fma_f32 v[88:89], v[104:105], v[168:169], v[104:105]
		v_pk_fma_f32 v[90:91], v[106:107], v[170:171], v[106:107]
		v_pk_fma_f32 v[92:93], v[108:109], v[172:173], v[108:109]
		v_pk_fma_f32 v[94:95], v[110:111], v[174:175], v[110:111]
		v_pk_fma_f32 v[96:97], v[112:113], v[176:177], v[112:113]
		v_pk_fma_f32 v[98:99], v[114:115], v[60:61], v[114:115]
		v_pk_fma_f32 v[60:61], v[116:117], v[178:179], v[116:117]
		v_pk_fma_f32 v[100:101], v[118:119], v[180:181], v[118:119]
		v_pk_fma_f32 v[102:103], v[120:121], v[182:183], v[120:121]
		v_pk_fma_f32 v[104:105], v[122:123], v[184:185], v[122:123]
		v_pk_fma_f32 v[106:107], v[124:125], v[186:187], v[124:125]
		v_pk_fma_f32 v[108:109], v[126:127], v[188:189], v[126:127]
		v_pk_fma_f32 v[110:111], v[128:129], v[190:191], v[128:129]
		v_pk_fma_f32 v[112:113], v[130:131], v[62:63], v[130:131]
		v_pk_fma_f32 v[62:63], v[132:133], v[192:193], v[132:133]
		v_pk_fma_f32 v[114:115], v[134:135], v[194:195], v[134:135]
		v_pk_fma_f32 v[116:117], v[140:141], v[196:197], v[140:141]
		v_pk_fma_f32 v[118:119], v[142:143], v[64:65], v[142:143]
		v_pk_fma_f32 v[64:65], v[144:145], v[198:199], v[144:145]
		v_pk_fma_f32 v[120:121], v[146:147], v[74:75], v[146:147]
		v_pk_fma_f32 v[74:75], v[148:149], v[76:77], v[148:149]
		v_add_u32_e32 v50, s69, v2
		v_cvt_pk_f16_f32 v124, v150, v151
		v_cmp_lt_i32_e64 s[68:69], v50, s13
		v_cvt_pk_f16_f32 v125, v66, v67
		s_and_b64 s[70:71], s[70:71], s[68:69]
		v_cvt_pk_f16_f32 v126, v68, v69
		s_and_b64 s[72:73], s[72:73], s[68:69]
		v_cvt_pk_f16_f32 v127, v70, v71
		s_and_b64 s[74:75], s[74:75], s[68:69]
		s_and_b64 s[76:77], s[76:77], s[68:69]
		s_and_b64 s[78:79], s[78:79], s[68:69]
		s_and_b64 s[80:81], s[80:81], s[68:69]
		s_and_b64 s[82:83], s[82:83], s[68:69]
		s_and_b64 s[68:69], s[84:85], s[68:69]
		s_lshl_b32 s16, s16, 10
		s_add_i32 s65, s66, s16
		s_lshl_b32 s67, s67, 8
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_dwordx4 v[124:127], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[86:87]
		v_cvt_pk_f16_f32 v68, v72, v73
		v_cvt_pk_f16_f32 v69, v78, v79
		v_cvt_pk_f16_f32 v70, v80, v81
		v_cvt_pk_f16_f32 v71, v82, v83
		s_add_i32 s65, s36, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v84, v85
		v_cvt_pk_f16_f32 v69, v52, v53
		v_cvt_pk_f16_f32 v70, v86, v87
		v_cvt_pk_f16_f32 v71, v88, v89
		s_add_i32 s65, s59, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[86:87], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v90, v91
		v_cvt_pk_f16_f32 v69, v92, v93
		v_cvt_pk_f16_f32 v70, v94, v95
		v_cvt_pk_f16_f32 v71, v96, v97
		s_add_i32 s65, s60, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v98, v99
		v_cvt_pk_f16_f32 v69, v60, v61
		v_cvt_pk_f16_f32 v70, v100, v101
		v_cvt_pk_f16_f32 v71, v102, v103
		s_add_i32 s65, s61, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v104, v105
		v_cvt_pk_f16_f32 v69, v106, v107
		v_cvt_pk_f16_f32 v70, v108, v109
		v_cvt_pk_f16_f32 v71, v110, v111
		s_add_i32 s65, s62, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v112, v113
		v_cvt_pk_f16_f32 v69, v62, v63
		v_cvt_pk_f16_f32 v70, v114, v115
		v_cvt_pk_f16_f32 v71, v116, v117
		s_add_i32 s65, s63, s66
		s_add_i32 s65, s65, s16
		s_add_i32 s65, s65, s67
		v_add3_u32 v50, s65, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_dwordx4 v[68:71], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[86:87]
		v_cvt_pk_f16_f32 v60, v118, v119
		v_cvt_pk_f16_f32 v61, v64, v65
		v_cvt_pk_f16_f32 v62, v120, v121
		v_cvt_pk_f16_f32 v63, v74, v75
		s_add_i32 s65, s64, s66
		s_add_i32 s16, s65, s16
		s_add_i32 s16, s16, s67
		v_add3_u32 v50, s16, v8, v45
		v_lshl_add_u32 v50, v6, 8, v50
		v_lshl_add_u32 v50, v3, 7, v50
		v_add3_u32 v50, v50, v1, v33
		s_and_saveexec_b64 s[86:87], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_dwordx4 v[60:63], v50, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[86:87], s[68:69]
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
		.amdhsa_next_free_vgpr 231
		.amdhsa_next_free_sgpr 88
		.amdhsa_accum_offset 232
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 231
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
    .vgpr_count:     231
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
