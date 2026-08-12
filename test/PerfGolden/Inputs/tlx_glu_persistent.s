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
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v4, 4
		v_mul_lo_u32 v4, v4, v3
		v_mad_u32_u24 v4, v2, 2, v4
		v_lshrrev_b32_e32 v5, 4, v0
		v_and_b32_e32 v5, 1, v5
		v_mad_u32_u24 v4, v5, 8, v4
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v10, 1, v9
		v_add3_u32 v4, v4, v8, v10
		v_lshrrev_b32_e32 v11, 7, v0
		v_and_b32_e32 v12, 1, v11
		v_mad_u32_u24 v4, v12, 32, v4
		v_lshrrev_b32_e32 v13, 8, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v4, v14, 64, v4
		v_and_b32_e32 v15, 15, v6
		v_add_u32_e32 v16, 16, v15
		v_add_u32_e32 v17, 32, v15
		v_add_u32_e32 v18, 48, v15
		v_add_u32_e32 v19, 64, v15
		v_add_u32_e32 v20, 0x50, v15
		v_add_u32_e32 v21, 0x60, v15
		v_add_u32_e32 v22, 0x70, v15
		v_and_b32_e32 v23, 31, v0
		v_mov_b32_e32 v24, 8
		v_mul_lo_u32 v24, v24, v23
		v_add_u32_e32 v23, 1, v24
		v_add_u32_e32 v25, 2, v24
		v_add_u32_e32 v26, 3, v24
		v_add_u32_e32 v27, 4, v24
		v_add_u32_e32 v28, 5, v24
		v_add_u32_e32 v29, 6, v24
		v_add_u32_e32 v30, 7, v24
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v31, 1, v0
		v_mov_b32_e32 v32, 8
		v_mul_lo_u32 v32, v32, v31
		v_lshrrev_b32_e32 v31, 1, v0
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v33, 16
		v_mul_lo_u32 v33, v33, v31
		v_xor_b32_e32 v31, v32, v33
		v_mov_b32_e32 v32, 8
		v_mul_lo_u32 v32, v32, v14
		v_cmp_lt_i32_e64 s[24:25], v31, s14
		v_mov_b32_e32 v14, 2
		v_mul_lo_u32 v14, v14, v12
		v_bitop3_b32 v8, v8, v10, v14 bitop3:0x96
		v_xor_b32_e32 v8, v8, v32
		v_mov_b32_e32 v14, 2
		v_mul_lo_u32 v14, v14, v10
		v_cmp_lt_i32_e64 s[26:27], v8, s14
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 s[28:29], v31, s23
		v_cmp_lt_i32_e64 s[30:31], v8, s23
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 s[32:33], v31, s23
		v_cmp_lt_i32_e64 s[34:35], v8, s23
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
		v_cmp_eq_u32_e64 s[8:9], v13, s2
		v_cmp_ne_u32_e64 s[10:11], v13, s2
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v12
		v_bitop3_b32 v12, v7, v14, v10 bitop3:0x96
		v_xor_b32_e32 v12, v12, v32
		v_bitop3_b32 v33, 16, v7, v14 bitop3:0x96
		v_bitop3_b32 v33, v33, v10, v32 bitop3:0x96
		v_bitop3_b32 v34, 32, v7, v14 bitop3:0x96
		v_bitop3_b32 v34, v34, v10, v32 bitop3:0x96
		v_bitop3_b32 v35, 48, v7, v14 bitop3:0x96
		v_bitop3_b32 v35, v35, v10, v32 bitop3:0x96
		v_bitop3_b32 v36, 64, v7, v14 bitop3:0x96
		v_bitop3_b32 v36, v36, v10, v32 bitop3:0x96
		v_xor_b32_e32 v37, 0x50, v7
		v_xor_b32_e32 v37, v37, v14
		v_xor_b32_e32 v37, v37, v10
		v_xor_b32_e32 v37, v37, v32
		v_xor_b32_e32 v38, 0x60, v7
		v_xor_b32_e32 v38, v38, v14
		v_xor_b32_e32 v38, v38, v10
		v_xor_b32_e32 v38, v38, v32
		v_xor_b32_e32 v7, 0x70, v7
		v_xor_b32_e32 v7, v7, v14
		v_xor_b32_e32 v7, v7, v10
		v_xor_b32_e32 v7, v7, v32
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v3
		v_bitop3_b32 v2, v31, v10, v2 bitop3:0x96
		v_mov_b32_e32 v3, 0x80
		v_mul_lo_u32 v3, v3, v5
		v_xor_b32_e32 v2, v2, v3
		s_mov_b32 s3, s16
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s37, 1, 0
		s_xor_b32 s38, s1, -1
		s_add_i32 s38, s38, 1
		v_mov_b32_e32 v3, 0x4f7ffffe
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s56, -1
		s_mov_b32 s57, -1
		s_mov_b32 s58, 0
		s_mov_b32 s59, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		s_xor_b32 s39, s12, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v5, s39
		v_mov_b32_e32 v10, s12
		v_cndmask_b32_e64 v5, v10, v5, s[60:61]
		v_cvt_f32_u32_e32 v10, v5
		v_rcp_iflag_f32_e32 v10, v10
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		v_mul_f32_e32 v10, v3, v10
		v_cvt_u32_f32_e32 v10, v10
		v_xad_u32 v14, v5, -1, 1
		v_mul_lo_u32 v32, v14, v10
		v_mul_hi_u32 v32, v10, v32
		v_add_u32_e32 v10, v10, v32
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v32, s39
		v_mov_b32_e32 v39, s13
		v_cndmask_b32_e64 v32, v39, v32, s[60:61]
		v_cvt_f32_u32_e32 v39, v32
		v_rcp_iflag_f32_e32 v39, v39
		v_and_b32_e32 v1, 7, v1
		v_mul_f32_e32 v39, v3, v39
		v_cvt_u32_f32_e32 v39, v39
		v_xad_u32 v40, v32, -1, 1
		v_mul_lo_u32 v41, v40, v39
		v_mul_hi_u32 v41, v39, v41
		v_add_u32_e32 v39, v39, v41
		v_and_b32_e32 v41, 3, v0
		v_lshlrev_b32_e32 v42, 4, v41
		v_mov_b32_e32 v43, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v44, s17, v13
		v_mul_lo_u32 v45, s17, v9
		v_lshlrev_b32_e32 v45, 1, v45
		v_lshl_add_u32 v44, v44, 3, v45
		v_and_b32_e32 v45, 1, v6
		v_mul_lo_u32 v46, s17, v45
		v_lshl_add_u32 v44, v46, 5, v44
		s_lshl_b32 s39, s17, 3
		s_lshl_b32 s56, s17, 6
		s_mul_i32 s57, 0x48, s17
		s_lshl_b32 s58, s17, 7
		s_mul_i32 s59, 0x88, s17
		v_and_b32_e32 v46, 63, v0
		v_lshrrev_b32_e32 v47, 4, v46
		v_lshlrev_b32_e32 v48, 4, v47
		v_lshl_add_u32 v13, v13, 9, v48
		v_and_b32_e32 v48, 15, v46
		v_lshrrev_b32_e32 v49, 1, v48
		v_lshlrev_b32_e32 v49, 6, v49
		v_and_b32_e32 v48, 1, v48
		v_mov_b32_e32 v50, 0x420
		v_mul_lo_u32 v50, v50, v48
		v_add3_u32 v13, v13, v49, v50
		v_and_b32_e32 v48, 3, v9
		v_lshlrev_b32_e32 v48, 5, v48
		v_lshl_add_u32 v41, v41, 3, v48
		v_lshlrev_b32_e32 v48, 9, v45
		v_mov_b32_e32 v49, 0x420
		v_mul_lo_u32 v49, v49, v1
		v_add3_u32 v1, v41, v48, v49
		v_add_u32_e32 v41, 0xc0, v42
		s_lshl_b32 s60, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s61, 0xc0, s17
		s_mul_i32 s62, 0xc8, s17
		s_mul_i32 s63, 0x2100, s36
		v_add_u32_e32 v48, s63, v13
		s_mul_i32 s36, 0x4200, s36
		v_add_u32_e32 v49, s36, v1
		s_mul_i32 s36, 0x2100, s21
		v_add_u32_e32 v50, s36, v13
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v51, s21, v1
		v_lshlrev_b32_e32 v45, 1, v45
		v_and_b32_e32 v52, 1, v9
		v_lshlrev_b32_e32 v52, 2, v52
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 3, v11
		v_xor_b32_e32 v11, v52, v11
		v_bitop3_b32 v11, v0, v45, v11 bitop3:0x96
		v_lshlrev_b32_e32 v45, 4, v11
		v_add_u32_e32 v45, 0x10000, v45
		v_xor_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 4, v11
		v_add_u32_e32 v11, 0x10000, v11
		v_lshrrev_b32_e32 v52, 3, v46
		v_and_b32_e32 v53, 3, v52
		v_lshlrev_b32_e32 v53, 13, v53
		v_add_u32_e32 v53, 0x10000, v53
		v_lshrrev_b32_e32 v54, 5, v46
		v_lshl_add_u32 v9, v9, 1, v54
		v_and_b32_e32 v54, 7, v46
		v_lshl_add_u32 v9, v54, 5, v9
		v_and_b32_e32 v55, 1, v0
		v_lshlrev_b32_e32 v55, 1, v55
		v_lshrrev_b32_e32 v46, 1, v46
		v_bitop3_b32 v46, v46, 3, 1 bitop3:0x80
		v_lshlrev_b32_e32 v46, 2, v46
		v_lshrrev_b32_e32 v54, 2, v54
		v_lshlrev_b32_e32 v54, 3, v54
		v_and_b32_e32 v52, 1, v52
		v_bitop3_b32 v46, v46, v54, v52 bitop3:0x96
		v_bitop3_b32 v9, v9, v55, v46 bitop3:0x96
		v_lshlrev_b32_e32 v9, 4, v9
		v_add_u32_e32 v46, v53, v9
		v_and_b32_e32 v47, 1, v47
		v_lshlrev_b32_e32 v47, 14, v47
		v_add_u32_e32 v47, 0x10000, v47
		v_lshlrev_b32_e32 v52, 13, v52
		v_add3_u32 v9, v47, v52, v9
		v_mul_lo_u32 v6, s19, v6
		v_and_b32_e32 v47, 31, v0
		s_cselect_b32 s21, 1, 0
		s_lshl_b32 s36, s19, 5
		s_lshl_b32 s63, s19, 6
		s_mul_i32 s64, 0x60, s19
		s_lshl_b32 s65, s19, 7
		s_cmp_lt_i32 s16, s20
		s_mul_i32 s16, 0xa0, s19
		s_mul_i32 s66, 0xc0, s19
		s_mul_i32 s67, 0xe0, s19
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s3, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s68, s3
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s68, s3, 7
		s_lshr_b32 s69, s3, 3
		s_lshr_b32 s70, s69, 2
		s_mul_i32 s70, s70, 32
		s_mul_i32 s68, s68, 4
		s_add_i32 s68, s70, s68
		s_and_b32 s69, s69, 3
		s_add_i32 s68, s68, s69
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		v_readfirstlane_b32 s69, v0
		s_cmp_lt_i32 s68, 0
		s_cselect_b32 s70, 1, 0
		s_xor_b32 s71, s68, -1
		s_add_i32 s71, s71, 1
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s70, s71, s68
		s_cselect_b32 s71, 1, 0
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s72, s38, s1
		v_mov_b32_e32 v52, s72
		v_cvt_f32_u32_e32 v52, v52
		v_rcp_iflag_f32_e32 v52, v52
		s_barrier
		v_mul_f32_e32 v52, v3, v52
		v_cvt_u32_f32_e32 v52, v52
		s_xor_b32 s73, s72, -1
		v_readfirstlane_b32 s74, v52
		s_add_i32 s73, s73, 1
		s_mul_i32 s75, s73, s74
		s_mul_hi_u32 s75, s74, s75
		s_add_i32 s74, s74, s75
		s_mul_hi_u32 s74, s70, s74
		s_mul_i32 s75, s74, s72
		s_xor_b32 s75, s75, -1
		s_add_i32 s75, s75, 1
		s_add_i32 s70, s70, s75
		s_cmp_ge_u32 s70, s72
		s_cselect_b32 s75, 1, 0
		s_add_i32 s76, s74, 1
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s74, s76, s74
		s_cselect_b32 s75, 1, 0
		s_add_i32 s76, s70, s73
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s70, s76, s70
		s_cmp_ge_u32 s70, s72
		s_cselect_b32 s72, 1, 0
		s_add_i32 s75, s74, 1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s72, s75, s74
		s_cselect_b32 s74, 1, 0
		s_xor_b32 s68, s68, s1
		s_xor_b32 s75, s72, -1
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s68, 0
		s_cselect_b32 s68, s75, s72
		s_mul_i32 s72, s68, 4
		s_xor_b32 s75, s72, -1
		s_add_i32 s75, s75, 1
		s_add_i32 s75, s0, s75
		s_cmp_lt_i32 s75, 4
		s_cselect_b32 s75, s75, 4
		s_add_i32 s73, s70, s73
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s70, s73, s70
		s_xor_b32 s73, s70, -1
		s_add_i32 s73, s73, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s70, s73, s70
		s_cmp_lt_i32 s70, 0
		s_cselect_b32 s71, 1, 0
		s_xor_b32 s73, s70, -1
		s_add_i32 s73, s73, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s73, s70
		s_cselect_b32 s73, 1, 0
		s_xor_b32 s74, s75, -1
		s_add_i32 s74, s74, 1
		s_cmp_lt_i32 s75, 0
		s_cselect_b32 s74, s74, s75
		v_mov_b32_e32 v52, s74
		v_cvt_f32_u32_e32 v52, v52
		v_rcp_iflag_f32_e32 v52, v52
		s_xor_b32 s76, s74, -1
		v_mul_f32_e32 v52, v3, v52
		v_cvt_u32_f32_e32 v52, v52
		s_add_i32 s76, s76, 1
		v_readfirstlane_b32 s77, v52
		s_mul_i32 s78, s76, s77
		s_mul_hi_u32 s78, s77, s78
		s_add_i32 s77, s77, s78
		s_mul_hi_u32 s77, s71, s77
		s_mul_i32 s78, s77, s74
		s_xor_b32 s78, s78, -1
		s_add_i32 s78, s78, 1
		s_add_i32 s71, s71, s78
		s_cmp_ge_u32 s71, s74
		s_cselect_b32 s78, 1, 0
		s_add_i32 s79, s71, s76
		s_cmp_lg_u32 s78, 0
		s_cselect_b32 s71, s79, s71
		s_cselect_b32 s78, 1, 0
		s_cmp_ge_u32 s71, s74
		s_cselect_b32 s74, 1, 0
		s_add_i32 s76, s71, s76
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s71, s76, s71
		s_cselect_b32 s74, 1, 0
		s_xor_b32 s76, s71, -1
		s_add_i32 s76, s76, 1
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s71, s76, s71
		s_add_i32 s72, s72, s71
		s_add_i32 s73, s77, 1
		s_cmp_lg_u32 s78, 0
		s_cselect_b32 s73, s73, s77
		s_add_i32 s76, s73, 1
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s73, s76, s73
		s_xor_b32 s70, s70, s75
		s_xor_b32 s74, s73, -1
		s_add_i32 s74, s74, 1
		s_cmp_lt_i32 s70, 0
		s_cselect_b32 s70, s74, s73
		s_mul_i32 s72, s72, 0x80
		v_add_u32_e32 v52, s72, v4
		v_cmp_lt_i32_e64 vcc, v52, s2
		v_xad_u32 v53, v52, -1, 1
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v52, v52, v53, vcc
		v_mul_hi_u32 v53, v52, v10
		v_mul_lo_u32 v53, v53, v5
		v_xor_b32_e32 v53, -1, v53
		v_add3_u32 v52, 1, v53, v52
		v_add_u32_e32 v53, v52, v14
		v_cmp_ge_u32_e64 vcc, v52, v5
		v_add_u32_e32 v54, s72, v15
		v_add_u32_e32 v55, s72, v16
		v_cndmask_b32_e32 v52, v52, v53, vcc
		v_add_u32_e32 v53, v52, v14
		v_cmp_ge_u32_e64 vcc, v52, v5
		v_add_u32_e32 v56, s72, v17
		v_add_u32_e32 v57, s72, v18
		v_cndmask_b32_e32 v52, v52, v53, vcc
		v_xad_u32 v53, v52, -1, 1
		v_cndmask_b32_e64 v52, v52, v53, s[74:75]
		v_cmp_lt_i32_e64 vcc, v54, s2
		v_xad_u32 v53, v54, -1, 1
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v53, v54, v53, vcc
		v_mul_hi_u32 v54, v53, v10
		v_mul_lo_u32 v54, v54, v5
		v_xor_b32_e32 v54, -1, v54
		v_add3_u32 v53, 1, v54, v53
		v_add_u32_e32 v54, v53, v14
		v_cmp_ge_u32_e64 vcc, v53, v5
		v_add_u32_e32 v58, s72, v19
		v_add_u32_e32 v59, s72, v20
		v_cndmask_b32_e32 v53, v53, v54, vcc
		v_add_u32_e32 v54, v53, v14
		v_cmp_ge_u32_e64 vcc, v53, v5
		v_add_u32_e32 v60, s72, v21
		v_add_u32_e32 v61, s72, v22
		v_cndmask_b32_e32 v53, v53, v54, vcc
		v_xad_u32 v54, v53, -1, 1
		v_cndmask_b32_e64 v53, v53, v54, s[74:75]
		v_cmp_lt_i32_e64 vcc, v55, s2
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v54, v55, -1, 1
		v_cndmask_b32_e32 v54, v55, v54, vcc
		v_mul_hi_u32 v55, v54, v10
		v_mul_lo_u32 v55, v55, v5
		v_xor_b32_e32 v55, -1, v55
		v_add3_u32 v54, 1, v55, v54
		v_add_u32_e32 v55, v54, v14
		v_cmp_ge_u32_e64 vcc, v54, v5
		s_lshr_b32 s69, s69, 6
		s_mul_i32 s69, 0x420, s69
		v_cndmask_b32_e32 v54, v54, v55, vcc
		v_cmp_ge_u32_e64 vcc, v54, v5
		v_add_u32_e32 v55, v54, v14
		v_add_u32_e32 v62, s72, v35
		v_cndmask_b32_e32 v54, v54, v55, vcc
		v_xad_u32 v55, v54, -1, 1
		v_cndmask_b32_e64 v54, v54, v55, s[74:75]
		v_cmp_lt_i32_e64 vcc, v56, s2
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v55, v56, -1, 1
		v_cndmask_b32_e32 v55, v56, v55, vcc
		v_mul_hi_u32 v56, v55, v10
		v_mul_lo_u32 v56, v56, v5
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v55, 1, v56, v55
		v_cmp_ge_u32_e64 vcc, v55, v5
		v_add_u32_e32 v56, v55, v14
		s_mov_b32 m0, s69
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_cmp_ge_u32_e64 vcc, v55, v5
		v_add_u32_e32 v56, v55, v14
		v_add_u32_e32 v63, s72, v34
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_xad_u32 v56, v55, -1, 1
		v_cndmask_b32_e64 v55, v55, v56, s[74:75]
		v_cmp_lt_i32_e64 vcc, v57, s2
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v56, v57, -1, 1
		v_cndmask_b32_e32 v56, v57, v56, vcc
		v_mul_hi_u32 v57, v56, v10
		v_mul_lo_u32 v57, v57, v5
		v_xor_b32_e32 v57, -1, v57
		v_add3_u32 v56, 1, v57, v56
		v_cmp_ge_u32_e64 vcc, v56, v5
		v_add_u32_e32 v57, v56, v14
		s_mul_i32 s73, s70, 0x100
		v_cndmask_b32_e32 v56, v56, v57, vcc
		v_cmp_ge_u32_e64 vcc, v56, v5
		v_add_u32_e32 v57, v56, v14
		v_add_u32_e32 v64, s72, v33
		v_cndmask_b32_e32 v56, v56, v57, vcc
		v_xad_u32 v57, v56, -1, 1
		v_cndmask_b32_e64 v56, v56, v57, s[74:75]
		v_cmp_lt_i32_e64 vcc, v58, s2
		v_mul_lo_u32 v56, s18, v56
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v57, v58, -1, 1
		v_cndmask_b32_e32 v57, v58, v57, vcc
		v_mul_hi_u32 v58, v57, v10
		v_mul_lo_u32 v58, v58, v5
		v_xor_b32_e32 v58, -1, v58
		v_add3_u32 v57, 1, v58, v57
		v_cmp_ge_u32_e64 vcc, v57, v5
		v_add_u32_e32 v58, v57, v14
		v_add_u32_e32 v65, s72, v12
		v_cndmask_b32_e32 v57, v57, v58, vcc
		v_cmp_ge_u32_e64 vcc, v57, v5
		v_add_u32_e32 v58, v57, v14
		v_xad_u32 v66, v59, -1, 1
		v_cndmask_b32_e32 v57, v57, v58, vcc
		v_xad_u32 v58, v57, -1, 1
		v_cndmask_b32_e64 v57, v57, v58, s[74:75]
		v_cmp_lt_i32_e64 vcc, v59, s2
		v_mul_lo_u32 v57, s18, v57
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v58, v59, v66, vcc
		v_mul_hi_u32 v59, v58, v10
		v_mul_lo_u32 v59, v59, v5
		v_xor_b32_e32 v59, -1, v59
		v_add3_u32 v58, 1, v59, v58
		v_cmp_ge_u32_e64 vcc, v58, v5
		v_add_u32_e32 v59, v58, v14
		v_xad_u32 v66, v60, -1, 1
		v_cndmask_b32_e32 v58, v58, v59, vcc
		v_cmp_ge_u32_e64 vcc, v58, v5
		v_add_u32_e32 v59, v58, v14
		v_xad_u32 v67, v61, -1, 1
		v_cndmask_b32_e32 v58, v58, v59, vcc
		v_xad_u32 v59, v58, -1, 1
		v_cndmask_b32_e64 v58, v58, v59, s[74:75]
		v_cmp_lt_i32_e64 vcc, v60, s2
		v_add_u32_e32 v59, s73, v24
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v60, v60, v66, vcc
		v_mul_hi_u32 v66, v60, v10
		v_mul_lo_u32 v66, v66, v5
		v_xor_b32_e32 v66, -1, v66
		v_add3_u32 v60, 1, v66, v60
		v_cmp_ge_u32_e64 vcc, v60, v5
		v_add_u32_e32 v66, v60, v14
		v_xad_u32 v68, v59, -1, 1
		v_cndmask_b32_e32 v60, v60, v66, vcc
		v_cmp_ge_u32_e64 vcc, v60, v5
		v_add_u32_e32 v66, v60, v14
		v_add_u32_e32 v69, s73, v23
		v_cndmask_b32_e32 v60, v60, v66, vcc
		v_xad_u32 v66, v60, -1, 1
		v_cndmask_b32_e64 v60, v60, v66, s[74:75]
		v_cmp_lt_i32_e64 vcc, v61, s2
		v_add_u32_e32 v66, s73, v25
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v61, v61, v67, vcc
		v_mul_hi_u32 v67, v61, v10
		v_mul_lo_u32 v67, v67, v5
		v_xor_b32_e32 v67, -1, v67
		v_add3_u32 v61, 1, v67, v61
		v_cmp_ge_u32_e64 vcc, v61, v5
		v_add_u32_e32 v67, v61, v14
		v_add_u32_e32 v70, s73, v26
		v_cndmask_b32_e32 v61, v61, v67, vcc
		v_cmp_ge_u32_e64 vcc, v61, v5
		v_add_u32_e32 v67, v61, v14
		v_xad_u32 v71, v69, -1, 1
		v_cndmask_b32_e32 v61, v61, v67, vcc
		v_xad_u32 v67, v61, -1, 1
		v_cndmask_b32_e64 v61, v61, v67, s[74:75]
		v_cmp_lt_i32_e64 vcc, v59, s2
		v_add_u32_e32 v67, s73, v27
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v59, v59, v68, vcc
		v_mul_hi_u32 v68, v59, v39
		v_mul_lo_u32 v68, v68, v32
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v59, 1, v68, v59
		v_add_u32_e32 v68, v59, v40
		v_cmp_ge_u32_e64 vcc, v59, v32
		v_add_u32_e32 v72, s73, v28
		v_add_u32_e32 v73, s73, v29
		v_cndmask_b32_e32 v59, v59, v68, vcc
		v_add_u32_e32 v68, v59, v40
		v_cmp_ge_u32_e64 vcc, v59, v32
		v_add_u32_e32 v74, s73, v30
		v_xad_u32 v75, v66, -1, 1
		v_cndmask_b32_e32 v59, v59, v68, vcc
		v_xad_u32 v68, v59, -1, 1
		v_cndmask_b32_e64 v59, v59, v68, s[74:75]
		v_cmp_lt_i32_e64 vcc, v69, s2
		v_xad_u32 v68, v70, -1, 1
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v69, v69, v71, vcc
		v_mul_hi_u32 v71, v69, v39
		v_mul_lo_u32 v71, v71, v32
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v69, 1, v71, v69
		v_add_u32_e32 v71, v69, v40
		v_cmp_ge_u32_e64 vcc, v69, v32
		v_xad_u32 v76, v67, -1, 1
		v_xad_u32 v77, v72, -1, 1
		v_cndmask_b32_e32 v69, v69, v71, vcc
		v_add_u32_e32 v71, v69, v40
		v_cmp_ge_u32_e64 vcc, v69, v32
		v_mul_lo_u32 v78, s60, v52
		v_mul_lo_u32 v52, s15, v52
		v_cndmask_b32_e32 v69, v69, v71, vcc
		v_xad_u32 v71, v69, -1, 1
		v_cndmask_b32_e64 v69, v69, v71, s[74:75]
		v_cmp_lt_i32_e64 vcc, v66, s2
		v_lshl_add_u32 v52, v52, 1, v42
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v66, v66, v75, vcc
		v_mul_hi_u32 v71, v66, v39
		v_mul_lo_u32 v71, v71, v32
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v66, 1, v71, v66
		v_add_u32_e32 v71, v66, v40
		v_cmp_ge_u32_e64 vcc, v66, v32
		v_xad_u32 v75, v73, -1, 1
		v_lshlrev_b32_e32 v79, 1, v59
		v_cndmask_b32_e32 v66, v66, v71, vcc
		v_cmp_ge_u32_e64 vcc, v66, v32
		v_add_u32_e32 v71, v66, v40
		v_xad_u32 v80, v74, -1, 1
		v_cndmask_b32_e32 v66, v66, v71, vcc
		v_xad_u32 v71, v66, -1, 1
		v_cndmask_b32_e64 v66, v66, v71, s[74:75]
		v_cmp_lt_i32_e64 vcc, v70, s2
		v_cndmask_b32_e64 v71, v43, v52, s[24:25]
		s_mov_b64 s[74:75], vcc
		buffer_load_dwordx4 v71, s[40:43], 0 offen lds
		v_cndmask_b32_e32 v68, v70, v68, vcc
		v_mul_hi_u32 v70, v68, v39
		v_mul_lo_u32 v70, v70, v32
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v68, 1, v70, v68
		v_cmp_ge_u32_e64 vcc, v68, v32
		v_add_u32_e32 v70, v68, v40
		s_add_i32 m0, m0, 0x62e0
		v_cndmask_b32_e32 v68, v68, v70, vcc
		v_cmp_ge_u32_e64 vcc, v68, v32
		v_add_u32_e32 v70, v68, v40
		v_add_u32_e32 v71, v44, v79
		v_cndmask_b32_e32 v68, v68, v70, vcc
		v_xad_u32 v70, v68, -1, 1
		v_cndmask_b32_e64 v68, v68, v70, s[74:75]
		v_cmp_lt_i32_e64 vcc, v67, s2
		v_cndmask_b32_e64 v70, v43, v71, s[26:27]
		s_mov_b64 s[74:75], vcc
		buffer_load_dwordx4 v70, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v67, v67, v76, vcc
		v_mul_hi_u32 v70, v67, v39
		v_mul_lo_u32 v70, v70, v32
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v67, 1, v70, v67
		v_cmp_ge_u32_e64 vcc, v67, v32
		v_add_u32_e32 v70, v67, v40
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v67, v67, v70, vcc
		v_cmp_ge_u32_e64 vcc, v67, v32
		v_add_u32_e32 v70, v67, v40
		v_add_u32_e32 v76, s39, v71
		v_cndmask_b32_e32 v67, v67, v70, vcc
		v_xad_u32 v70, v67, -1, 1
		v_cndmask_b32_e64 v67, v67, v70, s[74:75]
		v_cmp_lt_i32_e64 vcc, v72, s2
		v_cndmask_b32_e64 v70, v43, v76, s[26:27]
		s_mov_b64 s[74:75], vcc
		buffer_load_dwordx4 v70, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v70, v72, v77, vcc
		v_mul_hi_u32 v72, v70, v39
		v_mul_lo_u32 v72, v72, v32
		v_xor_b32_e32 v72, -1, v72
		v_add3_u32 v70, 1, v72, v70
		v_cmp_ge_u32_e64 vcc, v70, v32
		v_add_u32_e32 v72, v70, v40
		s_add_i32 m0, m0, 0xffff9d20
		v_cndmask_b32_e32 v70, v70, v72, vcc
		v_cmp_ge_u32_e64 vcc, v70, v32
		v_add_u32_e32 v72, v70, v40
		v_add_u32_e32 v76, 64, v52
		v_cndmask_b32_e32 v70, v70, v72, vcc
		v_xad_u32 v72, v70, -1, 1
		v_cndmask_b32_e64 v70, v70, v72, s[74:75]
		v_cmp_lt_i32_e64 vcc, v73, s2
		v_cndmask_b32_e64 v72, v43, v76, s[28:29]
		s_mov_b64 s[74:75], vcc
		buffer_load_dwordx4 v72, s[40:43], 0 offen lds
		v_cndmask_b32_e32 v72, v73, v75, vcc
		v_mul_hi_u32 v73, v72, v39
		v_mul_lo_u32 v73, v73, v32
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v72, 1, v73, v72
		v_cmp_ge_u32_e64 vcc, v72, v32
		v_add_u32_e32 v73, v72, v40
		s_add_i32 m0, m0, 0x83e0
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_cmp_ge_u32_e64 vcc, v72, v32
		v_add_u32_e32 v73, v72, v40
		v_add_u32_e32 v52, 0x80, v52
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_xad_u32 v73, v72, -1, 1
		v_cndmask_b32_e64 v72, v72, v73, s[74:75]
		v_cmp_lt_i32_e64 vcc, v74, s2
		v_cndmask_b32_e64 v52, v43, v52, s[32:33]
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v73, v74, v80, vcc
		v_mul_hi_u32 v74, v73, v39
		v_mul_lo_u32 v74, v74, v32
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v73, 1, v74, v73
		v_cmp_ge_u32_e64 vcc, v73, v32
		v_add_u32_e32 v74, v73, v40
		v_add_u32_e32 v75, s56, v71
		v_cndmask_b32_e32 v73, v73, v74, vcc
		v_cmp_ge_u32_e64 vcc, v73, v32
		v_add_u32_e32 v74, v73, v40
		v_cndmask_b32_e64 v75, v43, v75, s[30:31]
		v_cndmask_b32_e32 v73, v73, v74, vcc
		buffer_load_dwordx4 v75, s[44:47], 0 offen lds
		v_xad_u32 v74, v73, -1, 1
		v_cndmask_b32_e64 v73, v73, v74, s[74:75]
		v_add_u32_e32 v74, s57, v71
		v_cndmask_b32_e64 v74, v43, v74, s[30:31]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v75, s58, v71
		buffer_load_dwordx4 v74, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v74, v43, v75, s[34:35]
		s_add_i32 m0, m0, 0xffff7c20
		v_add_u32_e32 v75, s59, v71
		buffer_load_dwordx4 v52, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v52, v43, v75, s[34:35]
		s_add_i32 m0, m0, 0xa4e0
		v_mul_lo_u32 v53, s18, v53
		buffer_load_dwordx4 v74, s[44:47], 0 offen lds
		v_mul_lo_u32 v54, s18, v54
		s_add_i32 m0, m0, 0x2100
		v_mul_lo_u32 v55, s18, v55
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[80:83], v13
		ds_read_b128 v[84:87], v13 offset:2112
		ds_read_b128 v[88:91], v13 offset:4224
		ds_read_b128 v[92:95], v13 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[96:97], v1 offset:25312
		ds_read_b64_tr_b16 v[98:99], v1 offset:33760
		ds_read_b64_tr_b16 v[100:101], v1 offset:25440
		ds_read_b64_tr_b16 v[102:103], v1 offset:33888
		ds_read_b64_tr_b16 v[104:105], v1 offset:25568
		ds_read_b64_tr_b16 v[106:107], v1 offset:34016
		ds_read_b64_tr_b16 v[108:109], v1 offset:25696
		ds_read_b64_tr_b16 v[110:111], v1 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[90:91], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[90:91]
		s_setprio 0
		v_add_u32_e32 v52, v41, v78
		s_mov_b32 s74, 0
		s_mov_b32 s75, 0
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
		s_cmp_lg_u32 s21, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_cmp_ge_u32 s74, 2
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s74, -2
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		s_add_i32 s78, s74, 1
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[84:87], v[140:143]
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s76, s77, s78
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		s_add_i32 s77, s75, 3
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		s_mul_i32 s77, s77, 32
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[92:95], v[168:171]
		s_setprio 1
		s_barrier
		s_xor_b32 s77, s77, -1
		s_add_i32 s77, s77, 1
		s_add_i32 s77, s14, s77
		v_cmp_lt_i32_e64 vcc, v31, s77
		s_lshl_b32 s78, s75, 6
		s_mul_i32 s79, 0x2100, s74
		v_cndmask_b32_e32 v74, v43, v52, vcc
		v_cmp_lt_i32_e64 vcc, v8, s77
		s_add_i32 m0, s69, s79
		s_mul_i32 s77, s17, s75
		buffer_load_dwordx4 v74, s[40:43], s78 offen lds
		s_lshl_b32 s77, s77, 6
		s_add_i32 s78, s61, s77
		v_add_u32_e32 v74, s78, v71
		v_cndmask_b32_e32 v74, v43, v74, vcc
		s_mul_i32 s74, 0x4200, s74
		s_add_i32 s74, s69, s74
		s_add_i32 m0, s74, 0x62e0
		s_add_i32 s74, s62, s77
		buffer_load_dwordx4 v74, s[44:47], 0 offen lds
		v_add_u32_e32 v74, s74, v71
		v_cndmask_b32_e32 v74, v43, v74, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s74, 0x2100, s76
		buffer_load_dwordx4 v74, s[44:47], 0 offen lds
		s_barrier
		v_add_u32_e32 v74, s74, v13
		s_waitcnt vmcnt(3)
		ds_read_b128 v[80:83], v74
		ds_read_b128 v[84:87], v74 offset:2112
		ds_read_b128 v[88:91], v74 offset:4224
		ds_read_b128 v[92:95], v74 offset:6336
		s_mul_i32 s74, 0x4200, s76
		v_add_u32_e32 v74, s74, v1
		ds_read_b64_tr_b16 v[96:97], v74 offset:25312
		ds_read_b64_tr_b16 v[98:99], v74 offset:33760
		ds_read_b64_tr_b16 v[100:101], v74 offset:25440
		ds_read_b64_tr_b16 v[102:103], v74 offset:33888
		ds_read_b64_tr_b16 v[104:105], v74 offset:25568
		ds_read_b64_tr_b16 v[106:107], v74 offset:34016
		ds_read_b64_tr_b16 v[108:109], v74 offset:25696
		ds_read_b64_tr_b16 v[110:111], v74 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s75, s23
		s_mov_b32 s74, s76
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_setprio 0
		s_and_saveexec_b64 s[90:91], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[90:91]
		v_add_u32_e32 v52, s73, v2
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_dwordx4 v[176:179], v79, s[48:51], 0 offen
		v_add_lshl_u32 v71, v59, v53, 1
		buffer_load_ushort v74, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v69, v53, 1
		buffer_load_ushort v75, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v66, v53, 1
		buffer_load_ushort v76, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v68, v53, 1
		buffer_load_ushort v77, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v67, v53, 1
		buffer_load_ushort v78, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v70, v53, 1
		buffer_load_ushort v79, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v72, v53, 1
		buffer_load_ushort v180, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v53, 1
		buffer_load_ushort v71, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v59, v54, 1
		buffer_load_ushort v181, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v69, v54, 1
		buffer_load_ushort v182, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v66, v54, 1
		buffer_load_ushort v183, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v68, v54, 1
		buffer_load_ushort v184, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v67, v54, 1
		buffer_load_ushort v185, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v70, v54, 1
		buffer_load_ushort v186, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v72, v54, 1
		buffer_load_ushort v187, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v54, 1
		buffer_load_ushort v54, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v59, v55, 1
		buffer_load_ushort v188, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v69, v55, 1
		buffer_load_ushort v189, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v66, v55, 1
		buffer_load_ushort v190, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v68, v55, 1
		buffer_load_ushort v191, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v67, v55, 1
		buffer_load_ushort v192, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v70, v55, 1
		buffer_load_ushort v193, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v72, v55, 1
		buffer_load_ushort v194, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v55, 1
		buffer_load_ushort v55, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v59, v56, 1
		buffer_load_ushort v195, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v69, v56, 1
		buffer_load_ushort v196, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v66, v56, 1
		v_cmp_lt_i32_e64 s[74:75], v65, s12
		buffer_load_ushort v65, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v68, v56, 1
		buffer_load_ushort v197, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v67, v56, 1
		buffer_load_ushort v198, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v70, v56, 1
		buffer_load_ushort v199, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v72, v56, 1
		buffer_load_ushort v200, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v56, 1
		buffer_load_ushort v56, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v59, v57, 1
		buffer_load_ushort v201, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v69, v57, 1
		buffer_load_ushort v202, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v66, v57, 1
		v_cmp_lt_i32_e64 s[76:77], v64, s12
		buffer_load_ushort v64, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v68, v57, 1
		buffer_load_ushort v203, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v67, v57, 1
		buffer_load_ushort v204, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v70, v57, 1
		buffer_load_ushort v205, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v72, v57, 1
		buffer_load_ushort v206, v53, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v57, 1
		buffer_load_ushort v57, v53, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v53, s18, v58
		v_add_lshl_u32 v58, v59, v53, 1
		buffer_load_ushort v207, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v69, v53, 1
		v_cmp_lt_i32_e64 s[78:79], v63, s12
		buffer_load_ushort v63, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v66, v53, 1
		buffer_load_ushort v208, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v68, v53, 1
		buffer_load_ushort v209, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v67, v53, 1
		buffer_load_ushort v210, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v70, v53, 1
		buffer_load_ushort v211, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v58, v72, v53, 1
		buffer_load_ushort v212, v58, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v53, 1
		buffer_load_ushort v58, v53, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v53, s18, v60
		v_add_lshl_u32 v60, v59, v53, 1
		buffer_load_ushort v213, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v69, v53, 1
		v_cmp_lt_i32_e64 s[80:81], v62, s12
		buffer_load_ushort v62, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v66, v53, 1
		buffer_load_ushort v214, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v68, v53, 1
		buffer_load_ushort v215, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v67, v53, 1
		buffer_load_ushort v216, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v70, v53, 1
		buffer_load_ushort v217, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v60, v72, v53, 1
		buffer_load_ushort v218, v60, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v53, v73, v53, 1
		buffer_load_ushort v60, v53, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v53, s18, v61
		v_add_lshl_u32 v59, v59, v53, 1
		buffer_load_ushort v61, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v69, v53, 1
		buffer_load_ushort v69, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v66, v53, 1
		buffer_load_ushort v66, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v68, v53, 1
		buffer_load_ushort v68, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v67, v53, 1
		buffer_load_ushort v67, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v70, v53, 1
		buffer_load_ushort v70, v59, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v59, v72, v53, 1
		v_add_lshl_u32 v53, v73, v53, 1
		buffer_load_ushort v72, v59, s[4:7], 0 offen sc0 nt
		buffer_load_ushort v59, v53, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[84:87], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[92:95], v[168:171]
		ds_read_b128 v[80:83], v48
		ds_read_b128 v[84:87], v48 offset:2112
		ds_read_b128 v[88:91], v48 offset:4224
		ds_read_b128 v[92:95], v48 offset:6336
		ds_read_b64_tr_b16 v[96:97], v49 offset:25312
		ds_read_b64_tr_b16 v[98:99], v49 offset:33760
		ds_read_b64_tr_b16 v[100:101], v49 offset:25440
		ds_read_b64_tr_b16 v[102:103], v49 offset:33888
		ds_read_b64_tr_b16 v[104:105], v49 offset:25568
		ds_read_b64_tr_b16 v[106:107], v49 offset:34016
		ds_read_b64_tr_b16 v[108:109], v49 offset:25696
		ds_read_b64_tr_b16 v[110:111], v49 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[84:87], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[92:95], v[168:171]
		ds_read_b128 v[80:83], v50
		ds_read_b128 v[84:87], v50 offset:2112
		ds_read_b128 v[88:91], v50 offset:4224
		ds_read_b128 v[92:95], v50 offset:6336
		ds_read_b64_tr_b16 v[96:97], v51 offset:25312
		ds_read_b64_tr_b16 v[98:99], v51 offset:33760
		ds_read_b64_tr_b16 v[100:101], v51 offset:25440
		ds_read_b64_tr_b16 v[102:103], v51 offset:33888
		ds_read_b64_tr_b16 v[104:105], v51 offset:25568
		ds_read_b64_tr_b16 v[106:107], v51 offset:34016
		ds_read_b64_tr_b16 v[108:109], v51 offset:25696
		ds_read_b64_tr_b16 v[110:111], v51 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[80:83], v[124:127]
		s_barrier
		s_nop 2
		ds_write_b128 v45, v[112:115] offset:10432
		ds_write_b128 v11, v[116:119] offset:18624
		ds_write_b128 v45, v[120:123] offset:26816
		s_nop 0
		ds_write_b128 v11, v[124:127] offset:35008
		v_mfma_f32_16x16x32_f16 v[140:143], v[108:111], v[84:87], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[104:107], v[88:91], v[152:155]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[100:103], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[108:111], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[108:111], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[92:95], v[168:171]
		ds_read_b128 v[80:83], v46 offset:10432
		ds_read_b128 v[84:87], v46 offset:10688
		ds_read_b128 v[88:91], v46 offset:14528
		ds_read_b128 v[92:95], v46 offset:14784
		s_waitcnt vmcnt(62)
		v_cvt_f32_f16_e32 v96, v74
		v_cvt_f32_f16_e32 v97, v75
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v74, v76
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v75, v77
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v45, v[128:131] offset:10432
		ds_write_b128 v11, v[132:135] offset:18624
		ds_write_b128 v45, v[136:139] offset:26816
		ds_write_b128 v11, v[140:143] offset:35008
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v76, v78
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v77, v79
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v78, v180
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v79, v71
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[100:103], v9 offset:10432
		ds_read_b128 v[104:107], v9 offset:10688
		ds_read_b128 v[108:111], v9 offset:14528
		ds_read_b128 v[112:115], v9 offset:14784
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v98, v181
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v99, v182
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v116, v183
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v117, v184
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v45, v[144:147] offset:10432
		ds_write_b128 v11, v[148:151] offset:18624
		ds_write_b128 v45, v[152:155] offset:26816
		ds_write_b128 v11, v[156:159] offset:35008
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v118, v185
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v119, v186
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v120, v187
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v121, v54
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[124:127], v9 offset:10432
		ds_read_b128 v[128:131], v9 offset:10688
		ds_read_b128 v[132:135], v9 offset:14528
		ds_read_b128 v[136:139], v9 offset:14784
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v122, v188
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v123, v189
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v140, v190
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v141, v191
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v45, v[160:163] offset:10432
		ds_write_b128 v11, v[164:167] offset:18624
		ds_write_b128 v45, v[168:171] offset:26816
		ds_write_b128 v11, v[172:175] offset:35008
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v142, v192
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v143, v193
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v144, v194
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v145, v55
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[148:151], v9 offset:10432
		ds_read_b128 v[152:155], v9 offset:10688
		ds_read_b128 v[156:159], v9 offset:14528
		ds_read_b128 v[160:163], v9 offset:14784
		v_cvt_f32_f16_e32 v54, v176
		v_cvt_f32_f16_sdwa v55, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v146, v177
		v_cvt_f32_f16_sdwa v147, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v164, v178
		v_cvt_f32_f16_sdwa v165, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v166, v179
		v_cvt_f32_f16_sdwa v167, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v168, v195
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v169, v196
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v170, v65
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v171, v197
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v172, v198
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v173, v199
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v174, v200
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v175, v56
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v176, v201
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v177, v202
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v178, v64
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v179, v203
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v64, v204
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v65, v205
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v180, v206
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v181, v57
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v56, v207
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v57, v63
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v182, v208
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v183, v209
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v184, v210
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v185, v211
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v186, v212
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v187, v58
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v188, v213
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v189, v62
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v62, v214
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v63, v215
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v190, v216
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v191, v217
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v192, v218
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v193, v60
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v194, v61
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v195, v69
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v60, v66
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v61, v68
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v68, v67
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v69, v70
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v66, v72
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v67, v59
		v_pk_add_f32 v[58:59], v[80:81], v[54:55]
		v_pk_add_f32 v[70:71], v[82:83], v[146:147]
		v_pk_add_f32 v[72:73], v[84:85], v[164:165]
		v_pk_add_f32 v[80:81], v[86:87], v[166:167]
		v_pk_add_f32 v[82:83], v[88:89], v[54:55]
		v_pk_add_f32 v[84:85], v[90:91], v[146:147]
		v_pk_add_f32 v[86:87], v[92:93], v[164:165]
		v_pk_add_f32 v[88:89], v[94:95], v[166:167]
		v_pk_add_f32 v[90:91], v[100:101], v[54:55]
		v_pk_add_f32 v[92:93], v[102:103], v[146:147]
		v_pk_add_f32 v[94:95], v[104:105], v[164:165]
		v_pk_add_f32 v[100:101], v[106:107], v[166:167]
		v_pk_add_f32 v[102:103], v[108:109], v[54:55]
		v_pk_add_f32 v[104:105], v[110:111], v[146:147]
		v_pk_add_f32 v[106:107], v[112:113], v[164:165]
		v_pk_add_f32 v[108:109], v[114:115], v[166:167]
		v_pk_add_f32 v[110:111], v[124:125], v[54:55]
		v_pk_add_f32 v[112:113], v[126:127], v[146:147]
		v_pk_add_f32 v[114:115], v[128:129], v[164:165]
		v_pk_add_f32 v[124:125], v[130:131], v[166:167]
		v_pk_add_f32 v[126:127], v[132:133], v[54:55]
		v_pk_add_f32 v[128:129], v[134:135], v[146:147]
		v_pk_add_f32 v[130:131], v[136:137], v[164:165]
		v_pk_add_f32 v[132:133], v[138:139], v[166:167]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[134:135], v[148:149], v[54:55]
		v_pk_add_f32 v[136:137], v[150:151], v[146:147]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[138:139], v[152:153], v[164:165]
		v_pk_add_f32 v[148:149], v[154:155], v[166:167]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[54:55], v[156:157], v[54:55]
		v_pk_add_f32 v[146:147], v[158:159], v[146:147]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[150:151], v[160:161], v[164:165]
		v_pk_add_f32 v[152:153], v[162:163], v[166:167]
		v_pk_fma_f32 v[154:155], v[58:59], v[96:97], v[58:59]
		v_pk_fma_f32 v[58:59], v[70:71], v[74:75], v[70:71]
		v_pk_fma_f32 v[70:71], v[72:73], v[76:77], v[72:73]
		v_pk_fma_f32 v[72:73], v[80:81], v[78:79], v[80:81]
		v_pk_fma_f32 v[74:75], v[82:83], v[98:99], v[82:83]
		v_pk_fma_f32 v[76:77], v[84:85], v[116:117], v[84:85]
		v_pk_fma_f32 v[78:79], v[86:87], v[118:119], v[86:87]
		v_pk_fma_f32 v[80:81], v[88:89], v[120:121], v[88:89]
		v_pk_fma_f32 v[82:83], v[90:91], v[122:123], v[90:91]
		v_pk_fma_f32 v[84:85], v[92:93], v[140:141], v[92:93]
		v_pk_fma_f32 v[86:87], v[94:95], v[142:143], v[94:95]
		v_pk_fma_f32 v[88:89], v[100:101], v[144:145], v[100:101]
		v_pk_fma_f32 v[90:91], v[102:103], v[168:169], v[102:103]
		v_pk_fma_f32 v[92:93], v[104:105], v[170:171], v[104:105]
		v_pk_fma_f32 v[94:95], v[106:107], v[172:173], v[106:107]
		v_pk_fma_f32 v[96:97], v[108:109], v[174:175], v[108:109]
		v_pk_fma_f32 v[98:99], v[110:111], v[176:177], v[110:111]
		v_pk_fma_f32 v[100:101], v[112:113], v[178:179], v[112:113]
		v_pk_fma_f32 v[102:103], v[114:115], v[64:65], v[114:115]
		v_pk_fma_f32 v[64:65], v[124:125], v[180:181], v[124:125]
		v_pk_fma_f32 v[104:105], v[126:127], v[56:57], v[126:127]
		v_pk_fma_f32 v[56:57], v[128:129], v[182:183], v[128:129]
		v_pk_fma_f32 v[106:107], v[130:131], v[184:185], v[130:131]
		v_pk_fma_f32 v[108:109], v[132:133], v[186:187], v[132:133]
		v_pk_fma_f32 v[110:111], v[134:135], v[188:189], v[134:135]
		v_pk_fma_f32 v[112:113], v[136:137], v[62:63], v[136:137]
		v_pk_fma_f32 v[62:63], v[138:139], v[190:191], v[138:139]
		v_pk_fma_f32 v[114:115], v[148:149], v[192:193], v[148:149]
		v_pk_fma_f32 v[116:117], v[54:55], v[194:195], v[54:55]
		v_pk_fma_f32 v[54:55], v[146:147], v[60:61], v[146:147]
		v_pk_fma_f32 v[60:61], v[150:151], v[68:69], v[150:151]
		v_pk_fma_f32 v[68:69], v[152:153], v[66:67], v[152:153]
		v_add_u32_e32 v53, s72, v36
		v_add_u32_e32 v66, s72, v37
		v_add_u32_e32 v67, s72, v38
		v_add_u32_e32 v118, s72, v7
		v_cmp_lt_i32_e64 s[72:73], v53, s12
		v_cmp_lt_i32_e64 s[82:83], v66, s12
		v_cmp_lt_i32_e64 s[84:85], v67, s12
		v_cmp_lt_i32_e64 s[86:87], v118, s12
		v_cmp_lt_i32_e64 s[88:89], v52, s13
		v_cvt_pk_f16_f32 v120, v154, v155
		s_and_b64 s[74:75], s[74:75], s[88:89]
		v_cvt_pk_f16_f32 v121, v58, v59
		s_and_b64 s[76:77], s[76:77], s[88:89]
		v_cvt_pk_f16_f32 v122, v70, v71
		s_and_b64 s[78:79], s[78:79], s[88:89]
		v_cvt_pk_f16_f32 v123, v72, v73
		s_and_b64 s[80:81], s[80:81], s[88:89]
		s_and_b64 s[72:73], s[72:73], s[88:89]
		s_and_b64 s[82:83], s[82:83], s[88:89]
		s_and_b64 s[84:85], s[84:85], s[88:89]
		s_and_b64 s[86:87], s[86:87], s[88:89]
		s_lshl_b32 s69, s70, 9
		s_mul_i32 s68, s19, s68
		s_lshl_b32 s68, s68, 10
		s_add_i32 s70, s69, s68
		s_mul_i32 s71, s19, s71
		s_lshl_b32 s71, s71, 8
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_dwordx4 v[120:123], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[90:91], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[90:91]
		s_nop 0
		v_cvt_pk_f16_f32 v120, v74, v75
		v_cvt_pk_f16_f32 v121, v76, v77
		v_cvt_pk_f16_f32 v122, v78, v79
		v_cvt_pk_f16_f32 v123, v80, v81
		s_add_i32 s70, s36, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_dwordx4 v[120:123], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[90:91], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[90:91]
		v_cvt_pk_f16_f32 v72, v82, v83
		v_cvt_pk_f16_f32 v73, v84, v85
		v_cvt_pk_f16_f32 v74, v86, v87
		v_cvt_pk_f16_f32 v75, v88, v89
		s_add_i32 s70, s63, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_dwordx4 v[72:75], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[90:91], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[90:91]
		s_nop 0
		v_cvt_pk_f16_f32 v72, v90, v91
		v_cvt_pk_f16_f32 v73, v92, v93
		v_cvt_pk_f16_f32 v74, v94, v95
		v_cvt_pk_f16_f32 v75, v96, v97
		s_add_i32 s70, s64, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_dwordx4 v[72:75], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[90:91], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[90:91]
		s_nop 0
		v_cvt_pk_f16_f32 v72, v98, v99
		v_cvt_pk_f16_f32 v73, v100, v101
		v_cvt_pk_f16_f32 v74, v102, v103
		v_cvt_pk_f16_f32 v75, v64, v65
		s_add_i32 s70, s65, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_dwordx4 v[72:75], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[90:91], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[90:91]
		v_cvt_pk_f16_f32 v64, v104, v105
		v_cvt_pk_f16_f32 v65, v56, v57
		v_cvt_pk_f16_f32 v66, v106, v107
		v_cvt_pk_f16_f32 v67, v108, v109
		s_add_i32 s70, s16, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_dwordx4 v[64:67], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[90:91], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[90:91]
		v_cvt_pk_f16_f32 v56, v110, v111
		v_cvt_pk_f16_f32 v57, v112, v113
		v_cvt_pk_f16_f32 v58, v62, v63
		v_cvt_pk_f16_f32 v59, v114, v115
		s_add_i32 s70, s66, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s71
		v_lshl_add_u32 v52, v6, 1, s70
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[84:85]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_dwordx4 v[56:59], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[90:91], s[84:85]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[90:91]
		s_nop 0
		v_cvt_pk_f16_f32 v56, v116, v117
		v_cvt_pk_f16_f32 v57, v54, v55
		v_cvt_pk_f16_f32 v58, v60, v61
		v_cvt_pk_f16_f32 v59, v68, v69
		s_add_i32 s69, s67, s69
		s_add_i32 s68, s69, s68
		s_add_i32 s68, s68, s71
		v_lshl_add_u32 v52, v6, 1, s68
		v_lshl_add_u32 v52, v47, 4, v52
		s_and_saveexec_b64 s[90:91], s[86:87]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_dwordx4 v[56:59], v52, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[90:91], s[86:87]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[90:91]
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
		.amdhsa_next_free_vgpr 219
		.amdhsa_next_free_sgpr 92
		.amdhsa_accum_offset 220
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 219
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 92
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
    .sgpr_count:     92
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     219
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
