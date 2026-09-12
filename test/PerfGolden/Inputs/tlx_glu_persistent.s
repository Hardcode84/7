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
		v_readfirstlane_b32 s21, v0
		s_lshr_b32 s21, s21, 6
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
		v_and_b32_e32 v11, 1, v11
		v_add3_u32 v5, v5, v10, v11
		v_lshrrev_b32_e32 v12, 7, v0
		v_and_b32_e32 v12, 1, v12
		v_mad_u32_u24 v5, v12, 32, v5
		v_lshrrev_b32_e32 v13, 8, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v5, v14, 64, v5
		v_and_b32_e32 v15, 15, v8
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
		s_add_i32 s22, s14, 31
		s_mov_b32 s23, 31
		s_cmp_lt_i32 s22, 0
		s_cselect_b32 s24, s23, 0
		s_add_i32 s22, s22, s24
		s_ashr_i32 s22, s22, 5
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
		v_bitop3_b32 v33, v10, v11, v14 bitop3:0x96
		v_xor_b32_e32 v33, v33, v32
		v_bitop3_b32 v10, 4, v10, v11 bitop3:0x96
		v_bitop3_b32 v10, v10, v14, v32 bitop3:0x96
		v_cmp_lt_i32_e64 s[26:27], v33, s14
		s_sub_i32 s28, s14, 32
		v_cmp_lt_i32_e64 s[30:31], v31, s28
		v_cmp_lt_i32_e64 s[32:33], v33, s28
		s_sub_i32 s28, s14, 64
		v_cmp_lt_i32_e64 s[34:35], v31, s28
		v_cmp_lt_i32_e64 s[36:37], v33, s28
		s_sub_i32 s28, s22, 3
		s_sub_i32 s29, s22, 2
		s_ashr_i32 s38, s29, 31
		s_xor_b32 s29, s29, s38
		s_sub_i32 s29, s29, s38
		s_mul_hi_u32 s39, s29, 0xaaaaaaab
		s_lshr_b32 s39, s39, 1
		s_mul_i32 s39, s39, 3
		s_sub_i32 s29, s29, s39
		s_xor_b32 s29, s29, s38
		s_sub_i32 s29, s29, s38
		s_add_i32 s22, s22, -1
		s_ashr_i32 s38, s22, 31
		s_xor_b32 s22, s22, s38
		s_sub_i32 s22, s22, s38
		s_mul_hi_u32 s39, s22, 0xaaaaaaab
		s_lshr_b32 s39, s39, 1
		s_mul_i32 s39, s39, 3
		s_sub_i32 s22, s22, s39
		s_xor_b32 s22, s22, s38
		s_sub_i32 s22, s22, s38
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s23, s23, 0
		s_add_i32 s23, s20, s23
		s_ashr_i32 s23, s23, 5
		s_mul_i32 s23, s23, 32
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
		v_mov_b32_e32 v13, 2
		v_mul_lo_u32 v13, v13, v11
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v12
		v_bitop3_b32 v12, v9, v13, v11 bitop3:0x96
		v_xor_b32_e32 v12, v12, v32
		v_bitop3_b32 v14, 16, v9, v13 bitop3:0x96
		v_bitop3_b32 v14, v14, v11, v32 bitop3:0x96
		v_bitop3_b32 v34, 32, v9, v13 bitop3:0x96
		v_bitop3_b32 v34, v34, v11, v32 bitop3:0x96
		v_bitop3_b32 v35, 48, v9, v13 bitop3:0x96
		v_bitop3_b32 v35, v35, v11, v32 bitop3:0x96
		v_bitop3_b32 v36, 64, v9, v13 bitop3:0x96
		v_bitop3_b32 v36, v36, v11, v32 bitop3:0x96
		v_xor_b32_e32 v37, 0x50, v9
		v_xor_b32_e32 v37, v37, v13
		v_xor_b32_e32 v37, v37, v11
		v_xor_b32_e32 v37, v37, v32
		v_xor_b32_e32 v38, 0x60, v9
		v_xor_b32_e32 v38, v38, v13
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v38, v32
		v_xor_b32_e32 v9, 0x70, v9
		v_xor_b32_e32 v9, v9, v13
		v_xor_b32_e32 v9, v9, v11
		v_xor_b32_e32 v9, v9, v32
		v_mov_b32_e32 v11, 32
		v_mul_lo_u32 v11, v11, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v4
		v_bitop3_b32 v2, v31, v11, v2 bitop3:0x96
		v_mov_b32_e32 v4, 0x80
		v_mul_lo_u32 v4, v4, v7
		v_xor_b32_e32 v2, v2, v4
		s_mov_b32 s3, s16
		s_ashr_i32 s38, s1, 31
		s_xor_b32 s1, s1, s38
		s_sub_i32 s1, s1, s38
		v_mov_b32_e32 v4, s1
		v_cvt_f32_u32_e32 v4, v4
		v_rcp_iflag_f32_e32 v4, v4
		v_mov_b32_e32 v7, 0x4f7ffffe
		v_mul_f32_e32 v4, v7, v4
		v_cvt_u32_f32_e32 v4, v4
		s_sub_i32 s39, s2, s1
		s_ashr_i32 s56, s12, 31
		s_xor_b32 s57, s12, s56
		s_sub_i32 s56, s57, s56
		v_mov_b32_e32 v11, s56
		v_cvt_f32_u32_e32 v13, v11
		v_rcp_iflag_f32_e32 v13, v13
		v_and_b32_e32 v6, 1, v6
		v_mul_f32_e32 v13, v7, v13
		v_cvt_u32_f32_e32 v13, v13
		s_sub_i32 s57, s2, s56
		v_mul_lo_u32 v32, s57, v13
		v_mul_hi_u32 v32, v13, v32
		v_add_u32_e32 v13, v13, v32
		s_ashr_i32 s57, s13, 31
		s_xor_b32 s58, s13, s57
		s_sub_i32 s57, s58, s57
		v_mov_b32_e32 v32, s57
		v_cvt_f32_u32_e32 v39, v32
		v_rcp_iflag_f32_e32 v39, v39
		v_mov_b32_e32 v40, 0x1080
		v_mul_lo_u32 v40, v40, v6
		v_mul_f32_e32 v6, v7, v39
		v_cvt_u32_f32_e32 v6, v6
		s_sub_i32 s58, s2, s57
		v_mul_lo_u32 v39, s58, v6
		v_mul_hi_u32 v39, v6, v39
		v_add_u32_e32 v6, v6, v39
		v_and_b32_e32 v39, 3, v0
		v_lshlrev_b32_e32 v41, 3, v39
		v_mov_b32_e32 v42, 0x80000000
		s_lshr_b32 s58, s21, 2
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s59, s17, s58
		s_lshl_b32 s59, s59, 3
		s_mul_i32 s60, s17, s21
		s_lshl_b32 s60, s60, 1
		v_and_b32_e32 v43, 1, v8
		v_mul_lo_u32 v44, s17, v43
		v_lshlrev_b32_e32 v44, 5, v44
		v_add_u32_e32 v45, s60, v44
		v_add_u32_e32 v46, s59, v45
		s_lshl_b32 s61, s17, 3
		s_add_i32 s61, s61, s59
		v_add_u32_e32 v47, s61, v45
		v_add_u32_e32 v48, 32, v41
		s_lshl_b32 s61, s17, 6
		s_add_i32 s61, s61, s59
		v_add_u32_e32 v45, s61, v45
		s_mul_i32 s61, 0x48, s17
		v_add_u32_e32 v49, s60, v44
		v_add_u32_e32 v49, s59, v49
		v_add_u32_e32 v50, s61, v49
		v_add_u32_e32 v51, 64, v41
		s_lshl_b32 s61, s17, 7
		v_add_u32_e32 v52, s61, v49
		s_mul_i32 s61, 0x88, s17
		v_add_u32_e32 v49, s61, v49
		s_lshl_b32 s58, s58, 9
		v_and_b32_e32 v53, 63, v0
		v_lshrrev_b32_e32 v54, 4, v53
		v_lshlrev_b32_e32 v54, 4, v54
		v_add_u32_e32 v55, s58, v54
		v_and_b32_e32 v56, 15, v53
		v_lshrrev_b32_e32 v57, 1, v56
		v_lshlrev_b32_e32 v57, 6, v57
		v_and_b32_e32 v56, 1, v56
		v_mov_b32_e32 v58, 0x420
		v_mul_lo_u32 v58, v58, v56
		v_add3_u32 v55, v55, v57, v58
		s_lshr_b32 s61, s21, 1
		s_and_b32 s61, s61, 1
		s_lshl_b32 s61, s61, 6
		s_and_b32 s62, s21, 1
		s_lshl_b32 s62, s62, 5
		s_add_i32 s63, s61, s62
		v_add_u32_e32 v56, s63, v41
		v_lshlrev_b32_e32 v59, 9, v43
		v_add3_u32 v56, v56, v59, v40
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v60, 0x840
		v_mul_lo_u32 v60, v60, v3
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v3, 0x420
		v_mul_lo_u32 v3, v3, v1
		v_add3_u32 v1, v56, v60, v3
		v_lshlrev_b32_e32 v39, 4, v39
		v_add_u32_e32 v39, 0xc0, v39
		s_lshl_b32 s64, s15, 1
		s_cmp_lt_i32 0, s28
		s_mul_i32 s65, 0xc0, s17
		s_cselect_b32 s66, 1, 0
		s_add_i32 s65, s65, s59
		s_add_i32 s65, s65, s60
		s_mul_i32 s67, 0xc8, s17
		s_add_i32 s59, s67, s59
		s_add_i32 s59, s59, s60
		v_add3_u32 v54, v54, v57, v58
		v_add3_u32 v40, v41, v59, v40
		v_add3_u32 v3, v40, v60, v3
		s_mul_i32 s60, 0x2100, s29
		s_add_i32 s60, s60, s58
		v_add_u32_e32 v40, s60, v54
		s_mul_i32 s29, 0x4200, s29
		s_add_i32 s29, s29, s61
		s_add_i32 s29, s29, s62
		v_add_u32_e32 v56, s29, v3
		s_mul_i32 s29, 0x2100, s22
		s_add_i32 s29, s29, s58
		v_add_u32_e32 v57, s29, v54
		s_mul_i32 s22, 0x4200, s22
		s_add_i32 s22, s22, s61
		s_add_i32 s22, s22, s62
		v_add_u32_e32 v58, s22, v3
		v_lshlrev_b32_e32 v43, 1, v43
		v_xor_b32_e32 v43, v0, v43
		v_lshlrev_b32_e32 v59, 4, v43
		v_add_u32_e32 v59, 0x10000, v59
		v_xor_b32_e32 v43, 1, v43
		v_lshlrev_b32_e32 v43, 4, v43
		v_add_u32_e32 v43, 0x10000, v43
		v_lshrrev_b32_e32 v60, 3, v53
		v_and_b32_e32 v60, 3, v60
		v_lshlrev_b32_e32 v61, 13, v60
		v_add_u32_e32 v61, 0x10000, v61
		s_lshl_b32 s21, s21, 1
		v_lshrrev_b32_e32 v62, 5, v53
		v_and_b32_e32 v53, 7, v53
		v_lshlrev_b32_e32 v53, 5, v53
		v_add3_u32 v63, s21, v62, v53
		v_and_b32_e32 v64, 1, v0
		v_lshlrev_b32_e32 v64, 1, v64
		v_bitop3_b32 v60, v64, v60, 1 bitop3:0x78
		v_xor_b32_e32 v63, v63, v60
		v_lshl_add_u32 v63, v63, 4, v61
		s_add_i32 s22, s21, 16
		v_add3_u32 v64, s22, v62, v53
		v_xor_b32_e32 v64, v64, v60
		v_lshl_add_u32 v64, v64, 4, v61
		s_add_i32 s22, s21, 0x100
		v_add3_u32 v65, s22, v62, v53
		v_xor_b32_e32 v65, v65, v60
		v_lshl_add_u32 v65, v65, 4, v61
		s_add_i32 s21, s21, 0x110
		v_add3_u32 v53, s21, v62, v53
		v_xor_b32_e32 v53, v53, v60
		v_lshl_add_u32 v53, v53, 4, v61
		v_mul_lo_u32 v8, s19, v8
		v_and_b32_e32 v60, 31, v0
		s_lshl_b32 s21, s19, 5
		s_lshl_b32 s22, s19, 6
		s_mul_i32 s29, 0x60, s19
		s_lshl_b32 s60, s19, 7
		s_cmp_lt_i32 s16, s20
		s_mul_i32 s16, 0xa0, s19
		s_mul_i32 s61, 0xc0, s19
		s_mul_i32 s62, 0xe0, s19
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s3, s23
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s67, s3
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s67, s3, 7
		s_lshr_b32 s68, s3, 3
		s_lshr_b32 s69, s68, 2
		s_mul_i32 s69, s69, 32
		s_mul_i32 s67, s67, 4
		s_add_i32 s67, s69, s67
		s_and_b32 s68, s68, 3
		s_add_i32 s67, s67, s68
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		v_readfirstlane_b32 s68, v4
		s_ashr_i32 s69, s67, 31
		v_readfirstlane_b32 s70, v0
		s_xor_b32 s67, s67, s69
		s_sub_i32 s67, s67, s69
		s_xor_b32 s71, s69, s38
		s_mul_i32 s72, s39, s68
		s_mul_hi_u32 s72, s68, s72
		s_add_i32 s68, s68, s72
		s_mul_hi_u32 s68, s67, s68
		s_mul_i32 s72, s68, s1
		s_sub_i32 s67, s67, s72
		s_cmp_ge_u32 s67, s1
		s_cselect_b32 s72, 1, 0
		s_add_i32 s73, s68, 1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s68, s73, s68
		s_cselect_b32 s72, 1, 0
		s_sub_i32 s73, s67, s1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s67, s73, s67
		s_cmp_ge_u32 s67, s1
		s_cselect_b32 s72, 1, 0
		s_add_i32 s73, s68, 1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s68, s73, s68
		s_cselect_b32 s72, 1, 0
		s_xor_b32 s68, s68, s71
		s_sub_i32 s68, s68, s71
		s_mul_i32 s71, s68, 4
		s_sub_i32 s73, s0, s71
		s_cmp_lt_i32 s73, 4
		s_cselect_b32 s73, s73, 4
		s_sub_i32 s74, s67, s1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s67, s74, s67
		s_xor_b32 s67, s67, s69
		s_sub_i32 s67, s67, s69
		s_ashr_i32 s69, s67, 31
		s_xor_b32 s67, s67, s69
		s_sub_i32 s67, s67, s69
		s_ashr_i32 s72, s73, 31
		s_xor_b32 s73, s73, s72
		s_sub_i32 s73, s73, s72
		v_mov_b32_e32 v61, s73
		v_cvt_f32_u32_e32 v61, v61
		v_rcp_iflag_f32_e32 v61, v61
		s_barrier
		v_mul_f32_e32 v61, v7, v61
		v_cvt_u32_f32_e32 v61, v61
		s_sub_i32 s74, s2, s73
		v_readfirstlane_b32 s75, v61
		s_mul_i32 s74, s74, s75
		s_mul_hi_u32 s74, s75, s74
		s_add_i32 s74, s75, s74
		s_mul_hi_u32 s74, s67, s74
		s_mul_i32 s75, s74, s73
		s_sub_i32 s67, s67, s75
		s_cmp_ge_u32 s67, s73
		s_cselect_b32 s75, 1, 0
		s_sub_i32 s76, s67, s73
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s67, s76, s67
		s_cselect_b32 s75, 1, 0
		s_cmp_ge_u32 s67, s73
		s_cselect_b32 s76, 1, 0
		s_sub_i32 s73, s67, s73
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s67, s73, s67
		s_cselect_b32 s73, 1, 0
		s_xor_b32 s67, s67, s69
		s_sub_i32 s67, s67, s69
		s_xor_b32 s69, s69, s72
		s_add_i32 s71, s71, s67
		s_add_i32 s72, s74, 1
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s72, s72, s74
		s_add_i32 s74, s72, 1
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s72, s74, s72
		s_xor_b32 s72, s72, s69
		s_sub_i32 s69, s72, s69
		s_mul_i32 s71, s71, 0x80
		v_add_u32_e32 v61, s71, v5
		v_ashrrev_i32_e32 v62, 31, v61
		v_xor_b32_e32 v61, v61, v62
		v_sub_u32_e32 v61, v61, v62
		v_mul_hi_u32 v66, v61, v13
		v_mul_lo_u32 v66, v66, s56
		v_sub_u32_e32 v61, v61, v66
		v_sub_u32_e32 v66, v61, v11
		v_cmp_ge_u32_e64 vcc, v61, s56
		v_add_u32_e32 v67, s71, v15
		s_lshr_b32 s70, s70, 6
		v_cndmask_b32_e32 v61, v61, v66, vcc
		v_sub_u32_e32 v66, v61, v11
		v_cmp_ge_u32_e64 vcc, v61, s56
		v_add_u32_e32 v68, s71, v16
		v_add_u32_e32 v69, s71, v17
		v_cndmask_b32_e32 v61, v61, v66, vcc
		v_xor_b32_e32 v61, v61, v62
		v_ashrrev_i32_e32 v66, 31, v67
		v_xor_b32_e32 v67, v67, v66
		v_sub_u32_e32 v67, v67, v66
		v_mul_hi_u32 v70, v67, v13
		v_mul_lo_u32 v70, v70, s56
		v_sub_u32_e32 v67, v67, v70
		v_sub_u32_e32 v70, v67, v11
		v_cmp_ge_u32_e64 vcc, v67, s56
		v_add_u32_e32 v71, s71, v18
		v_add_u32_e32 v72, s71, v19
		v_cndmask_b32_e32 v67, v67, v70, vcc
		v_sub_u32_e32 v70, v67, v11
		v_cmp_ge_u32_e64 vcc, v67, s56
		v_add_u32_e32 v73, s71, v20
		v_add_u32_e32 v74, s71, v21
		v_cndmask_b32_e32 v67, v67, v70, vcc
		v_xor_b32_e32 v67, v67, v66
		v_ashrrev_i32_e32 v70, 31, v68
		v_xor_b32_e32 v68, v68, v70
		v_sub_u32_e32 v68, v68, v70
		v_mul_hi_u32 v75, v68, v13
		v_mul_lo_u32 v75, v75, s56
		v_sub_u32_e32 v68, v68, v75
		v_sub_u32_e32 v75, v68, v11
		v_cmp_ge_u32_e64 vcc, v68, s56
		v_add_u32_e32 v76, s71, v22
		v_sub_u32_e32 v61, v61, v62
		v_cndmask_b32_e32 v62, v68, v75, vcc
		v_cmp_ge_u32_e64 vcc, v62, s56
		v_sub_u32_e32 v66, v67, v66
		v_sub_u32_e32 v67, v62, v11
		v_cndmask_b32_e32 v62, v62, v67, vcc
		v_xor_b32_e32 v62, v62, v70
		v_ashrrev_i32_e32 v67, 31, v69
		v_xor_b32_e32 v68, v69, v67
		v_sub_u32_e32 v68, v68, v67
		v_mul_hi_u32 v69, v68, v13
		v_mul_lo_u32 v69, v69, s56
		v_sub_u32_e32 v68, v68, v69
		v_cmp_ge_u32_e64 vcc, v68, s56
		v_sub_u32_e32 v62, v62, v70
		v_sub_u32_e32 v69, v68, v11
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_cmp_ge_u32_e64 vcc, v68, s56
		v_sub_u32_e32 v69, v68, v11
		v_ashrrev_i32_e32 v70, 31, v71
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_xor_b32_e32 v68, v68, v67
		v_xor_b32_e32 v69, v71, v70
		v_sub_u32_e32 v69, v69, v70
		v_mul_hi_u32 v71, v69, v13
		v_mul_lo_u32 v71, v71, s56
		v_sub_u32_e32 v69, v69, v71
		v_cmp_ge_u32_e64 vcc, v69, s56
		v_sub_u32_e32 v67, v68, v67
		v_sub_u32_e32 v68, v69, v11
		v_cndmask_b32_e32 v68, v69, v68, vcc
		v_cmp_ge_u32_e64 vcc, v68, s56
		v_sub_u32_e32 v69, v68, v11
		v_ashrrev_i32_e32 v71, 31, v72
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_xor_b32_e32 v68, v68, v70
		v_xor_b32_e32 v69, v72, v71
		v_sub_u32_e32 v69, v69, v71
		v_mul_hi_u32 v72, v69, v13
		v_mul_lo_u32 v72, v72, s56
		v_sub_u32_e32 v69, v69, v72
		v_cmp_ge_u32_e64 vcc, v69, s56
		v_sub_u32_e32 v68, v68, v70
		v_sub_u32_e32 v70, v69, v11
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_cmp_ge_u32_e64 vcc, v69, s56
		v_sub_u32_e32 v70, v69, v11
		v_ashrrev_i32_e32 v72, 31, v73
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_xor_b32_e32 v69, v69, v71
		v_xor_b32_e32 v70, v73, v72
		v_sub_u32_e32 v70, v70, v72
		v_mul_hi_u32 v73, v70, v13
		v_mul_lo_u32 v73, v73, s56
		v_sub_u32_e32 v70, v70, v73
		v_cmp_ge_u32_e64 vcc, v70, s56
		v_sub_u32_e32 v69, v69, v71
		v_sub_u32_e32 v71, v70, v11
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_cmp_ge_u32_e64 vcc, v70, s56
		v_sub_u32_e32 v71, v70, v11
		v_ashrrev_i32_e32 v73, 31, v74
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_xor_b32_e32 v70, v70, v72
		v_xor_b32_e32 v71, v74, v73
		v_sub_u32_e32 v71, v71, v73
		v_mul_hi_u32 v74, v71, v13
		v_mul_lo_u32 v74, v74, s56
		v_sub_u32_e32 v71, v71, v74
		v_cmp_ge_u32_e64 vcc, v71, s56
		v_sub_u32_e32 v70, v70, v72
		v_sub_u32_e32 v72, v71, v11
		v_cndmask_b32_e32 v71, v71, v72, vcc
		v_cmp_ge_u32_e64 vcc, v71, s56
		v_sub_u32_e32 v72, v71, v11
		v_ashrrev_i32_e32 v74, 31, v76
		v_cndmask_b32_e32 v71, v71, v72, vcc
		v_xor_b32_e32 v71, v71, v73
		v_xor_b32_e32 v72, v76, v74
		v_sub_u32_e32 v72, v72, v74
		v_mul_hi_u32 v75, v72, v13
		v_mul_lo_u32 v75, v75, s56
		v_sub_u32_e32 v72, v72, v75
		v_cmp_ge_u32_e64 vcc, v72, s56
		v_sub_u32_e32 v71, v71, v73
		v_sub_u32_e32 v73, v72, v11
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_cmp_ge_u32_e64 vcc, v72, s56
		v_sub_u32_e32 v73, v72, v11
		v_mul_lo_u32 v75, s15, v61
		s_mul_i32 s72, s69, 0x100
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_xor_b32_e32 v72, v72, v74
		v_add_u32_e32 v73, s72, v24
		v_ashrrev_i32_e32 v76, 31, v73
		v_xor_b32_e32 v73, v73, v76
		v_sub_u32_e32 v73, v73, v76
		v_mul_hi_u32 v77, v73, v6
		v_mul_lo_u32 v77, v77, s57
		v_sub_u32_e32 v73, v73, v77
		v_sub_u32_e32 v77, v73, v32
		v_cmp_ge_u32_e64 vcc, v73, s57
		v_sub_u32_e32 v72, v72, v74
		v_add_u32_e32 v74, s72, v23
		v_cndmask_b32_e32 v73, v73, v77, vcc
		v_sub_u32_e32 v77, v73, v32
		v_cmp_ge_u32_e64 vcc, v73, s57
		v_add_u32_e32 v78, s72, v25
		v_add_u32_e32 v79, s72, v26
		v_cndmask_b32_e32 v73, v73, v77, vcc
		v_xor_b32_e32 v73, v73, v76
		v_ashrrev_i32_e32 v77, 31, v74
		v_xor_b32_e32 v74, v74, v77
		v_sub_u32_e32 v74, v74, v77
		v_mul_hi_u32 v80, v74, v6
		v_mul_lo_u32 v80, v80, s57
		v_sub_u32_e32 v74, v74, v80
		v_sub_u32_e32 v80, v74, v32
		v_cmp_ge_u32_e64 vcc, v74, s57
		v_add_u32_e32 v81, s72, v27
		v_add_u32_e32 v82, s72, v28
		v_cndmask_b32_e32 v74, v74, v80, vcc
		v_sub_u32_e32 v80, v74, v32
		v_cmp_ge_u32_e64 vcc, v74, s57
		v_add_u32_e32 v83, s72, v29
		v_add_u32_e32 v84, s72, v30
		v_cndmask_b32_e32 v74, v74, v80, vcc
		v_xor_b32_e32 v74, v74, v77
		v_ashrrev_i32_e32 v80, 31, v78
		v_xor_b32_e32 v78, v78, v80
		v_sub_u32_e32 v78, v78, v80
		v_mul_hi_u32 v85, v78, v6
		v_mul_lo_u32 v85, v85, s57
		v_sub_u32_e32 v78, v78, v85
		v_sub_u32_e32 v85, v78, v32
		v_cmp_ge_u32_e64 vcc, v78, s57
		v_sub_u32_e32 v73, v73, v76
		v_sub_u32_e32 v74, v74, v77
		v_cndmask_b32_e32 v76, v78, v85, vcc
		v_cmp_ge_u32_e64 vcc, v76, s57
		v_sub_u32_e32 v77, v76, v32
		v_ashrrev_i32_e32 v78, 31, v79
		v_cndmask_b32_e32 v76, v76, v77, vcc
		v_xor_b32_e32 v76, v76, v80
		v_xor_b32_e32 v77, v79, v78
		v_sub_u32_e32 v77, v77, v78
		v_mul_hi_u32 v79, v77, v6
		v_mul_lo_u32 v79, v79, s57
		v_sub_u32_e32 v77, v77, v79
		v_cmp_ge_u32_e64 vcc, v77, s57
		v_sub_u32_e32 v76, v76, v80
		v_sub_u32_e32 v79, v77, v32
		v_cndmask_b32_e32 v77, v77, v79, vcc
		v_cmp_ge_u32_e64 vcc, v77, s57
		v_sub_u32_e32 v79, v77, v32
		v_ashrrev_i32_e32 v80, 31, v81
		v_cndmask_b32_e32 v77, v77, v79, vcc
		v_xor_b32_e32 v77, v77, v78
		v_xor_b32_e32 v79, v81, v80
		v_sub_u32_e32 v79, v79, v80
		v_mul_hi_u32 v81, v79, v6
		v_mul_lo_u32 v81, v81, s57
		v_sub_u32_e32 v79, v79, v81
		v_cmp_ge_u32_e64 vcc, v79, s57
		v_sub_u32_e32 v77, v77, v78
		v_sub_u32_e32 v78, v79, v32
		v_cndmask_b32_e32 v78, v79, v78, vcc
		v_cmp_ge_u32_e64 vcc, v78, s57
		v_sub_u32_e32 v79, v78, v32
		v_ashrrev_i32_e32 v81, 31, v82
		v_cndmask_b32_e32 v78, v78, v79, vcc
		v_xor_b32_e32 v78, v78, v80
		v_xor_b32_e32 v79, v82, v81
		v_sub_u32_e32 v79, v79, v81
		v_mul_hi_u32 v82, v79, v6
		v_mul_lo_u32 v82, v82, s57
		v_sub_u32_e32 v79, v79, v82
		v_cmp_ge_u32_e64 vcc, v79, s57
		v_sub_u32_e32 v78, v78, v80
		v_sub_u32_e32 v80, v79, v32
		v_cndmask_b32_e32 v79, v79, v80, vcc
		v_cmp_ge_u32_e64 vcc, v79, s57
		v_sub_u32_e32 v80, v79, v32
		v_ashrrev_i32_e32 v82, 31, v83
		v_cndmask_b32_e32 v79, v79, v80, vcc
		v_xor_b32_e32 v79, v79, v81
		v_xor_b32_e32 v80, v83, v82
		v_sub_u32_e32 v80, v80, v82
		v_mul_hi_u32 v83, v80, v6
		v_mul_lo_u32 v83, v83, s57
		v_sub_u32_e32 v80, v80, v83
		v_cmp_ge_u32_e64 vcc, v80, s57
		v_sub_u32_e32 v79, v79, v81
		v_sub_u32_e32 v81, v80, v32
		v_cndmask_b32_e32 v80, v80, v81, vcc
		v_cmp_ge_u32_e64 vcc, v80, s57
		v_sub_u32_e32 v81, v80, v32
		v_ashrrev_i32_e32 v83, 31, v84
		v_cndmask_b32_e32 v80, v80, v81, vcc
		v_xor_b32_e32 v80, v80, v82
		v_xor_b32_e32 v81, v84, v83
		v_sub_u32_e32 v81, v81, v83
		v_mul_hi_u32 v84, v81, v6
		v_mul_lo_u32 v84, v84, s57
		v_sub_u32_e32 v81, v81, v84
		v_cmp_ge_u32_e64 vcc, v81, s57
		v_sub_u32_e32 v80, v80, v82
		v_sub_u32_e32 v82, v81, v32
		v_cndmask_b32_e32 v81, v81, v82, vcc
		v_cmp_ge_u32_e64 vcc, v81, s57
		v_sub_u32_e32 v82, v81, v32
		s_mul_i32 s70, 0x420, s70
		v_cndmask_b32_e32 v81, v81, v82, vcc
		v_xor_b32_e32 v81, v81, v83
		v_add_lshl_u32 v82, v41, v75, 1
		v_cndmask_b32_e64 v82, v42, v82, s[24:25]
		s_mov_b32 m0, s70
		v_lshlrev_b32_e32 v84, 1, v73
		buffer_load_dwordx4 v82, s[40:43], 0 offen lds
		v_add_u32_e32 v82, v46, v84
		v_cndmask_b32_e64 v82, v42, v82, s[26:27]
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v85, v47, v84
		buffer_load_dwordx4 v82, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v82, v42, v85, s[26:27]
		s_add_i32 m0, m0, 0x2100
		v_add_lshl_u32 v85, v48, v75, 1
		buffer_load_dwordx4 v82, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v82, v42, v85, s[30:31]
		s_add_i32 m0, m0, 0xffff9d20
		v_add_lshl_u32 v75, v51, v75, 1
		buffer_load_dwordx4 v82, s[40:43], 0 offen lds
		v_add_u32_e32 v82, v45, v84
		v_cndmask_b32_e64 v82, v42, v82, s[32:33]
		s_add_i32 m0, m0, 0x83e0
		v_cndmask_b32_e64 v75, v42, v75, s[34:35]
		buffer_load_dwordx4 v82, s[44:47], 0 offen lds
		v_add_u32_e32 v82, v50, v84
		v_cndmask_b32_e64 v82, v42, v82, s[32:33]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v85, v52, v84
		buffer_load_dwordx4 v82, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v82, v42, v85, s[36:37]
		s_add_i32 m0, m0, 0xffff7c20
		v_add_u32_e32 v85, v49, v84
		buffer_load_dwordx4 v75, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v75, v42, v85, s[36:37]
		s_add_i32 m0, m0, 0xa4e0
		v_sub_u32_e32 v81, v81, v83
		buffer_load_dwordx4 v82, s[44:47], 0 offen lds
		v_mov_b64_e32 v[88:89], 0
		s_add_i32 m0, m0, 0x2100
		v_mul_lo_u32 v61, s64, v61
		buffer_load_dwordx4 v75, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[92:95], v55
		ds_read_b128 v[96:99], v55 offset:2112
		ds_read_b128 v[100:103], v55 offset:4224
		ds_read_b128 v[104:107], v55 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[108:109], v1 offset:25312
		ds_read_b64_tr_b16 v[110:111], v1 offset:33760
		ds_read_b64_tr_b16 v[112:113], v1 offset:25440
		ds_read_b64_tr_b16 v[114:115], v1 offset:33888
		ds_read_b64_tr_b16 v[116:117], v1 offset:25568
		ds_read_b64_tr_b16 v[118:119], v1 offset:34016
		ds_read_b64_tr_b16 v[120:121], v1 offset:25696
		ds_read_b64_tr_b16 v[122:123], v1 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[88:89], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[88:89]
		s_setprio 0
		s_mov_b32 s73, 0
		v_add_u32_e32 v61, v39, v61
		s_mov_b32 s74, 0
		v_mov_b64_e32 v[90:91], 0
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
		s_cmp_lg_u32 s66, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[88:91], v[108:111], v[92:95], v[88:91]
		v_mfma_f32_16x16x32_f16 v[124:127], v[112:115], v[92:95], v[124:127]
		s_lshl_b32 s75, s74, 6
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[92:95], v[128:131]
		s_cmp_ge_u32 s73, 2
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[92:95], v[132:135]
		s_cselect_b32 s76, 1, 0
		s_sub_i32 s77, s73, 2
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[96:99], v[148:151]
		s_add_i32 s78, s73, 1
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[96:99], v[136:139]
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s76, s77, s78
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[96:99], v[140:143]
		s_add_i32 s77, s74, 3
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[96:99], v[144:147]
		s_mul_i32 s77, s77, 32
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[100:103], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[104:107], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[104:107], v[176:179]
		s_setprio 1
		s_barrier
		s_sub_i32 s77, s14, s77
		v_cmp_lt_i32_e64 vcc, v31, s77
		s_mul_i32 s78, -1, s75
		s_add_i32 s78, s78, 0x80000000
		v_mov_b32_e32 v75, s78
		v_cndmask_b32_e32 v75, v75, v61, vcc
		s_mul_i32 s78, 0x2100, s73
		v_cmp_lt_i32_e64 vcc, v10, s77
		s_add_i32 m0, s70, s78
		v_cmp_lt_i32_e64 s[78:79], v33, s77
		buffer_load_dwordx4 v75, s[40:43], s75 offen lds
		s_mul_i32 s75, s17, s74
		s_lshl_b32 s75, s75, 6
		s_add_i32 s77, s65, s75
		v_add3_u32 v75, s77, v44, v84
		s_mul_i32 s73, 0x4200, s73
		s_add_i32 s73, s70, s73
		s_add_i32 m0, s73, 0x62e0
		v_cndmask_b32_e64 v75, v42, v75, s[78:79]
		buffer_load_dwordx4 v75, s[44:47], 0 offen lds
		s_add_i32 s73, s59, s75
		v_add3_u32 v75, s73, v44, v84
		v_cndmask_b32_e32 v75, v42, v75, vcc
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s73, 0x4200, s76
		buffer_load_dwordx4 v75, s[44:47], 0 offen lds
		s_barrier
		s_mul_i32 s75, 0x2100, s76
		s_add_i32 s75, s58, s75
		v_add_u32_e32 v75, s75, v54
		s_waitcnt vmcnt(3)
		ds_read_b128 v[92:95], v75
		ds_read_b128 v[96:99], v75 offset:2112
		ds_read_b128 v[100:103], v75 offset:4224
		ds_read_b128 v[104:107], v75 offset:6336
		s_add_i32 s73, s63, s73
		v_add_u32_e32 v75, s73, v3
		ds_read_b64_tr_b16 v[108:109], v75 offset:25312
		ds_read_b64_tr_b16 v[110:111], v75 offset:33760
		ds_read_b64_tr_b16 v[112:113], v75 offset:25440
		ds_read_b64_tr_b16 v[114:115], v75 offset:33888
		ds_read_b64_tr_b16 v[116:117], v75 offset:25568
		ds_read_b64_tr_b16 v[118:119], v75 offset:34016
		ds_read_b64_tr_b16 v[120:121], v75 offset:25696
		ds_read_b64_tr_b16 v[122:123], v75 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s74, s74, 1
		s_cmp_lt_i32 s74, s28
		s_mov_b32 s73, s76
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_setprio 0
		s_and_saveexec_b64 s[88:89], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[88:89]
		v_add_u32_e32 v61, s72, v2
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_ushort v75, v84, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v74
		buffer_load_ushort v83, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v76
		buffer_load_ushort v84, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v77
		buffer_load_ushort v85, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v78
		buffer_load_ushort v86, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v79
		buffer_load_ushort v87, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v80
		buffer_load_ushort v184, v82, s[48:51], 0 offen
		v_lshlrev_b32_e32 v82, 1, v81
		buffer_load_ushort v185, v82, s[48:51], 0 offen
		v_mul_lo_u32 v66, s18, v66
		v_add_lshl_u32 v82, v73, v66, 1
		buffer_load_ushort v186, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v74, v66, 1
		buffer_load_ushort v187, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v76, v66, 1
		buffer_load_ushort v188, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v77, v66, 1
		buffer_load_ushort v189, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v78, v66, 1
		buffer_load_ushort v190, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v79, v66, 1
		buffer_load_ushort v191, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v82, v80, v66, 1
		buffer_load_ushort v192, v82, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v81, v66, 1
		buffer_load_ushort v82, v66, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v62
		v_add_lshl_u32 v66, v73, v62, 1
		buffer_load_ushort v193, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v74, v62, 1
		buffer_load_ushort v194, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v76, v62, 1
		buffer_load_ushort v195, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v77, v62, 1
		buffer_load_ushort v196, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v78, v62, 1
		v_cmp_lt_i32_e64 s[72:73], v61, s13
		buffer_load_ushort v61, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v79, v62, 1
		buffer_load_ushort v197, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v66, v80, v62, 1
		buffer_load_ushort v198, v66, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v66, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v67
		v_add_lshl_u32 v67, v73, v62, 1
		buffer_load_ushort v199, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v74, v62, 1
		buffer_load_ushort v200, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v76, v62, 1
		buffer_load_ushort v201, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v77, v62, 1
		buffer_load_ushort v202, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v78, v62, 1
		buffer_load_ushort v203, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v79, v62, 1
		buffer_load_ushort v204, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v67, v80, v62, 1
		buffer_load_ushort v205, v67, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v67, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v68
		v_add_lshl_u32 v68, v73, v62, 1
		buffer_load_ushort v206, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v74, v62, 1
		buffer_load_ushort v207, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v76, v62, 1
		buffer_load_ushort v208, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v77, v62, 1
		buffer_load_ushort v209, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v78, v62, 1
		buffer_load_ushort v210, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v79, v62, 1
		buffer_load_ushort v211, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v68, v80, v62, 1
		buffer_load_ushort v212, v68, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v68, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v69
		v_add_lshl_u32 v69, v73, v62, 1
		buffer_load_ushort v213, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v74, v62, 1
		buffer_load_ushort v214, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v76, v62, 1
		buffer_load_ushort v215, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v77, v62, 1
		buffer_load_ushort v216, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v78, v62, 1
		buffer_load_ushort v217, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v79, v62, 1
		buffer_load_ushort v218, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v69, v80, v62, 1
		buffer_load_ushort v219, v69, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v69, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v70
		v_add_lshl_u32 v70, v73, v62, 1
		buffer_load_ushort v220, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v74, v62, 1
		buffer_load_ushort v221, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v76, v62, 1
		buffer_load_ushort v222, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v77, v62, 1
		buffer_load_ushort v223, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v78, v62, 1
		buffer_load_ushort v224, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v79, v62, 1
		buffer_load_ushort v225, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v80, v62, 1
		buffer_load_ushort v226, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v70, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v71
		v_add_lshl_u32 v71, v73, v62, 1
		buffer_load_ushort v227, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v74, v62, 1
		buffer_load_ushort v228, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v76, v62, 1
		buffer_load_ushort v229, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v77, v62, 1
		buffer_load_ushort v230, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v78, v62, 1
		buffer_load_ushort v231, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v79, v62, 1
		buffer_load_ushort v232, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v80, v62, 1
		buffer_load_ushort v233, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v71, v62, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v62, s18, v72
		v_add_lshl_u32 v72, v73, v62, 1
		buffer_load_ushort v73, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v74, v62, 1
		buffer_load_ushort v74, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v76, v62, 1
		buffer_load_ushort v76, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v77, v62, 1
		buffer_load_ushort v77, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v78, v62, 1
		buffer_load_ushort v78, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v79, v62, 1
		buffer_load_ushort v79, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v80, v62, 1
		v_add_lshl_u32 v62, v81, v62, 1
		buffer_load_ushort v80, v72, s[4:7], 0 offen sc0 nt
		buffer_load_ushort v72, v62, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[88:91], v[108:111], v[92:95], v[88:91]
		v_mfma_f32_16x16x32_f16 v[124:127], v[112:115], v[92:95], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[92:95], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[92:95], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[96:99], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[104:107], v[176:179]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[100:103], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[104:107], v[172:175]
		ds_read_b128 v[92:95], v40
		ds_read_b128 v[96:99], v40 offset:2112
		ds_read_b128 v[100:103], v40 offset:4224
		ds_read_b128 v[104:107], v40 offset:6336
		ds_read_b64_tr_b16 v[108:109], v56 offset:25312
		ds_read_b64_tr_b16 v[110:111], v56 offset:33760
		ds_read_b64_tr_b16 v[112:113], v56 offset:25440
		ds_read_b64_tr_b16 v[114:115], v56 offset:33888
		ds_read_b64_tr_b16 v[116:117], v56 offset:25568
		ds_read_b64_tr_b16 v[118:119], v56 offset:34016
		ds_read_b64_tr_b16 v[120:121], v56 offset:25696
		ds_read_b64_tr_b16 v[122:123], v56 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[108:111], v[92:95], v[88:91]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[112:115], v[92:95], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[92:95], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[96:99], v[136:139]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[92:95], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[104:107], v[176:179]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[100:103], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[104:107], v[172:175]
		ds_read_b128 v[92:95], v57
		ds_read_b128 v[96:99], v57 offset:2112
		ds_read_b128 v[100:103], v57 offset:4224
		ds_read_b128 v[104:107], v57 offset:6336
		ds_read_b64_tr_b16 v[108:109], v58 offset:25312
		ds_read_b64_tr_b16 v[110:111], v58 offset:33760
		ds_read_b64_tr_b16 v[112:113], v58 offset:25440
		ds_read_b64_tr_b16 v[114:115], v58 offset:33888
		ds_read_b64_tr_b16 v[116:117], v58 offset:25568
		ds_read_b64_tr_b16 v[118:119], v58 offset:34016
		ds_read_b64_tr_b16 v[120:121], v58 offset:25696
		ds_read_b64_tr_b16 v[122:123], v58 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[108:111], v[92:95], v[88:91]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[112:115], v[92:95], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[92:95], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[96:99], v[136:139]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[92:95], v[132:135]
		s_barrier
		s_nop 2
		ds_write_b128 v59, v[88:91] offset:10432
		ds_write_b128 v43, v[124:127] offset:18624
		ds_write_b128 v59, v[128:131] offset:26816
		s_nop 0
		ds_write_b128 v43, v[132:135] offset:35008
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[104:107], v[176:179]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[100:103], v[156:159]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[104:107], v[172:175]
		ds_read_b128 v[88:91], v63 offset:10432
		ds_read_b128 v[92:95], v64 offset:10432
		ds_read_b128 v[96:99], v65 offset:10432
		ds_read_b128 v[100:103], v53 offset:10432
		s_waitcnt vmcnt(62)
		v_cvt_f32_f16_e32 v104, v75
		v_cvt_f32_f16_e32 v105, v83
		v_cvt_f32_f16_e32 v106, v84
		v_cvt_f32_f16_e32 v107, v85
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v59, v[136:139] offset:10432
		ds_write_b128 v43, v[140:143] offset:18624
		ds_write_b128 v59, v[144:147] offset:26816
		ds_write_b128 v43, v[148:151] offset:35008
		v_cvt_f32_f16_e32 v84, v86
		v_cvt_f32_f16_e32 v85, v87
		v_cvt_f32_f16_e32 v86, v184
		v_cvt_f32_f16_e32 v87, v185
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[108:111], v63 offset:10432
		ds_read_b128 v[112:115], v64 offset:10432
		ds_read_b128 v[116:119], v65 offset:10432
		ds_read_b128 v[120:123], v53 offset:10432
		v_cvt_f32_f16_e32 v124, v186
		v_cvt_f32_f16_e32 v125, v187
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v126, v188
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v127, v189
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v59, v[152:155] offset:10432
		ds_write_b128 v43, v[156:159] offset:18624
		ds_write_b128 v59, v[160:163] offset:26816
		ds_write_b128 v43, v[164:167] offset:35008
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v128, v190
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v129, v191
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v130, v192
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v131, v82
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[132:135], v63 offset:10432
		ds_read_b128 v[136:139], v64 offset:10432
		ds_read_b128 v[140:143], v65 offset:10432
		ds_read_b128 v[144:147], v53 offset:10432
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v82, v193
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v83, v194
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v148, v195
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v149, v196
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v59, v[168:171] offset:10432
		ds_write_b128 v43, v[172:175] offset:18624
		ds_write_b128 v59, v[176:179] offset:26816
		ds_write_b128 v43, v[180:183] offset:35008
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v150, v61
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v151, v197
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v152, v198
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v153, v66
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[156:159], v63 offset:10432
		ds_read_b128 v[160:163], v64 offset:10432
		ds_read_b128 v[164:167], v65 offset:10432
		ds_read_b128 v[168:171], v53 offset:10432
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v154, v199
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v155, v200
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v172, v201
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v173, v202
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v174, v203
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v175, v204
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v176, v205
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v177, v67
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v66, v206
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v67, v207
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v178, v208
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v179, v209
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v180, v210
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v181, v211
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v182, v212
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v183, v68
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v184, v213
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v185, v214
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v186, v215
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v187, v216
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v188, v217
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v189, v218
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v190, v219
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v191, v69
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v68, v220
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v69, v221
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v192, v222
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v193, v223
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v194, v224
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v195, v225
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v196, v226
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v197, v70
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v198, v227
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v199, v228
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v200, v229
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v201, v230
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v202, v231
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v203, v232
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v204, v233
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v205, v71
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v70, v73
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v71, v74
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v74, v76
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v75, v77
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v76, v78
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v77, v79
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v78, v80
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v79, v72
		v_pk_add_f32 v[72:73], v[88:89], v[104:105]
		v_pk_fma_f32 v[80:81], v[72:73], v[124:125], v[72:73]
		v_cvt_pk_f16_f32 v208, v80, v81
		v_pk_add_f32 v[72:73], v[90:91], v[106:107]
		v_pk_fma_f32 v[80:81], v[72:73], v[126:127], v[72:73]
		v_pk_add_f32 v[72:73], v[92:93], v[84:85]
		v_pk_add_f32 v[88:89], v[94:95], v[86:87]
		v_pk_add_f32 v[90:91], v[96:97], v[104:105]
		v_pk_add_f32 v[92:93], v[98:99], v[106:107]
		v_pk_add_f32 v[94:95], v[100:101], v[84:85]
		v_pk_add_f32 v[96:97], v[102:103], v[86:87]
		v_pk_add_f32 v[98:99], v[108:109], v[104:105]
		v_pk_add_f32 v[100:101], v[110:111], v[106:107]
		v_pk_add_f32 v[102:103], v[112:113], v[84:85]
		v_pk_add_f32 v[108:109], v[114:115], v[86:87]
		v_pk_add_f32 v[110:111], v[116:117], v[104:105]
		v_pk_add_f32 v[112:113], v[118:119], v[106:107]
		v_pk_add_f32 v[114:115], v[120:121], v[84:85]
		v_pk_add_f32 v[116:117], v[122:123], v[86:87]
		v_pk_add_f32 v[118:119], v[132:133], v[104:105]
		v_pk_add_f32 v[120:121], v[134:135], v[106:107]
		v_pk_add_f32 v[122:123], v[136:137], v[84:85]
		v_pk_add_f32 v[124:125], v[138:139], v[86:87]
		v_pk_add_f32 v[126:127], v[140:141], v[104:105]
		v_pk_add_f32 v[132:133], v[142:143], v[106:107]
		v_pk_add_f32 v[134:135], v[144:145], v[84:85]
		v_pk_add_f32 v[136:137], v[146:147], v[86:87]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[138:139], v[156:157], v[104:105]
		v_pk_add_f32 v[140:141], v[158:159], v[106:107]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[142:143], v[160:161], v[84:85]
		v_pk_add_f32 v[144:145], v[162:163], v[86:87]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[104:105], v[164:165], v[104:105]
		v_pk_add_f32 v[106:107], v[166:167], v[106:107]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[84:85], v[168:169], v[84:85]
		v_pk_add_f32 v[86:87], v[170:171], v[86:87]
		v_pk_fma_f32 v[146:147], v[72:73], v[128:129], v[72:73]
		v_pk_fma_f32 v[72:73], v[88:89], v[130:131], v[88:89]
		v_pk_fma_f32 v[88:89], v[90:91], v[82:83], v[90:91]
		v_pk_fma_f32 v[82:83], v[92:93], v[148:149], v[92:93]
		v_pk_fma_f32 v[90:91], v[94:95], v[150:151], v[94:95]
		v_pk_fma_f32 v[92:93], v[96:97], v[152:153], v[96:97]
		v_pk_fma_f32 v[94:95], v[98:99], v[154:155], v[98:99]
		v_pk_fma_f32 v[96:97], v[100:101], v[172:173], v[100:101]
		v_pk_fma_f32 v[98:99], v[102:103], v[174:175], v[102:103]
		v_pk_fma_f32 v[100:101], v[108:109], v[176:177], v[108:109]
		v_pk_fma_f32 v[102:103], v[110:111], v[66:67], v[110:111]
		v_pk_fma_f32 v[66:67], v[112:113], v[178:179], v[112:113]
		v_pk_fma_f32 v[108:109], v[114:115], v[180:181], v[114:115]
		v_pk_fma_f32 v[110:111], v[116:117], v[182:183], v[116:117]
		v_pk_fma_f32 v[112:113], v[118:119], v[184:185], v[118:119]
		v_pk_fma_f32 v[114:115], v[120:121], v[186:187], v[120:121]
		v_pk_fma_f32 v[116:117], v[122:123], v[188:189], v[122:123]
		v_pk_fma_f32 v[118:119], v[124:125], v[190:191], v[124:125]
		v_pk_fma_f32 v[120:121], v[126:127], v[68:69], v[126:127]
		v_pk_fma_f32 v[68:69], v[132:133], v[192:193], v[132:133]
		v_pk_fma_f32 v[122:123], v[134:135], v[194:195], v[134:135]
		v_pk_fma_f32 v[124:125], v[136:137], v[196:197], v[136:137]
		v_pk_fma_f32 v[126:127], v[138:139], v[198:199], v[138:139]
		v_pk_fma_f32 v[128:129], v[140:141], v[200:201], v[140:141]
		v_pk_fma_f32 v[130:131], v[142:143], v[202:203], v[142:143]
		v_pk_fma_f32 v[132:133], v[144:145], v[204:205], v[144:145]
		v_pk_fma_f32 v[134:135], v[104:105], v[70:71], v[104:105]
		v_pk_fma_f32 v[70:71], v[106:107], v[74:75], v[106:107]
		v_pk_fma_f32 v[74:75], v[84:85], v[76:77], v[84:85]
		v_pk_fma_f32 v[76:77], v[86:87], v[78:79], v[86:87]
		v_add_u32_e32 v61, s71, v12
		v_add_u32_e32 v62, s71, v14
		v_add_u32_e32 v78, s71, v34
		v_add_u32_e32 v79, s71, v35
		v_add_u32_e32 v84, s71, v36
		v_add_u32_e32 v85, s71, v37
		v_add_u32_e32 v86, s71, v38
		v_add_u32_e32 v87, s71, v9
		v_cmp_lt_i32_e64 s[70:71], v61, s12
		v_cmp_lt_i32_e64 s[74:75], v62, s12
		v_cmp_lt_i32_e64 s[76:77], v78, s12
		v_cmp_lt_i32_e64 s[78:79], v79, s12
		v_cmp_lt_i32_e64 s[80:81], v84, s12
		v_cmp_lt_i32_e64 s[82:83], v85, s12
		v_cmp_lt_i32_e64 s[84:85], v86, s12
		v_cmp_lt_i32_e64 s[86:87], v87, s12
		v_cvt_pk_f16_f32 v209, v80, v81
		s_and_b64 s[70:71], s[70:71], s[72:73]
		v_cvt_pk_f16_f32 v210, v146, v147
		s_and_b64 s[74:75], s[74:75], s[72:73]
		v_cvt_pk_f16_f32 v211, v72, v73
		s_and_b64 s[76:77], s[76:77], s[72:73]
		s_and_b64 s[78:79], s[78:79], s[72:73]
		s_and_b64 s[80:81], s[80:81], s[72:73]
		s_and_b64 s[82:83], s[82:83], s[72:73]
		s_and_b64 s[84:85], s[84:85], s[72:73]
		s_and_b64 s[72:73], s[86:87], s[72:73]
		s_lshl_b32 s69, s69, 9
		s_mul_i32 s68, s19, s68
		s_lshl_b32 s68, s68, 10
		s_add_i32 s86, s69, s68
		s_mul_i32 s67, s19, s67
		s_lshl_b32 s67, s67, 8
		s_add_i32 s86, s86, s67
		v_lshl_add_u32 v61, v8, 1, s86
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_dwordx4 v[208:211], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[88:89], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[88:89]
		v_cvt_pk_f16_f32 v84, v88, v89
		v_cvt_pk_f16_f32 v85, v82, v83
		v_cvt_pk_f16_f32 v86, v90, v91
		v_cvt_pk_f16_f32 v87, v92, v93
		s_add_i32 s70, s21, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_dwordx4 v[84:87], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[88:89], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[88:89]
		v_cvt_pk_f16_f32 v80, v94, v95
		v_cvt_pk_f16_f32 v81, v96, v97
		v_cvt_pk_f16_f32 v82, v98, v99
		v_cvt_pk_f16_f32 v83, v100, v101
		s_add_i32 s70, s22, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[88:89], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[88:89]
		s_nop 0
		v_cvt_pk_f16_f32 v80, v102, v103
		v_cvt_pk_f16_f32 v81, v66, v67
		v_cvt_pk_f16_f32 v82, v108, v109
		v_cvt_pk_f16_f32 v83, v110, v111
		s_add_i32 s70, s29, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[88:89], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[88:89]
		s_nop 0
		v_cvt_pk_f16_f32 v80, v112, v113
		v_cvt_pk_f16_f32 v81, v114, v115
		v_cvt_pk_f16_f32 v82, v116, v117
		v_cvt_pk_f16_f32 v83, v118, v119
		s_add_i32 s70, s60, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[88:89], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[88:89]
		s_nop 0
		v_cvt_pk_f16_f32 v80, v120, v121
		v_cvt_pk_f16_f32 v81, v68, v69
		v_cvt_pk_f16_f32 v82, v122, v123
		v_cvt_pk_f16_f32 v83, v124, v125
		s_add_i32 s70, s16, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[88:89], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[88:89]
		s_nop 0
		v_cvt_pk_f16_f32 v80, v126, v127
		v_cvt_pk_f16_f32 v81, v128, v129
		v_cvt_pk_f16_f32 v82, v130, v131
		v_cvt_pk_f16_f32 v83, v132, v133
		s_add_i32 s70, s61, s69
		s_add_i32 s70, s70, s68
		s_add_i32 s70, s70, s67
		v_lshl_add_u32 v61, v8, 1, s70
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[84:85]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[88:89], s[84:85]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[88:89]
		s_nop 0
		v_cvt_pk_f16_f32 v80, v134, v135
		v_cvt_pk_f16_f32 v81, v70, v71
		v_cvt_pk_f16_f32 v82, v74, v75
		v_cvt_pk_f16_f32 v83, v76, v77
		s_add_i32 s69, s62, s69
		s_add_i32 s68, s69, s68
		s_add_i32 s67, s68, s67
		v_lshl_add_u32 v61, v8, 1, s67
		v_lshl_add_u32 v61, v60, 4, v61
		s_and_saveexec_b64 s[88:89], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_dwordx4 v[80:83], v61, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[88:89], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[88:89]
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
		.amdhsa_next_free_vgpr 234
		.amdhsa_next_free_sgpr 90
		.amdhsa_accum_offset 236
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 234
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 90
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
    .sgpr_count:     90
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     234
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
