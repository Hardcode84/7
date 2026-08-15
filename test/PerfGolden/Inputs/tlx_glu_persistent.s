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
		v_and_b32_e32 v33, 1, v33
		v_mov_b32_e32 v35, 16
		v_mul_lo_u32 v35, v35, v33
		v_xor_b32_e32 v33, v34, v35
		v_mov_b32_e32 v34, 8
		v_mul_lo_u32 v34, v34, v16
		v_cmp_lt_i32_e64 s[24:25], v33, s14
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v35, v10, v12, v16 bitop3:0x96
		v_xor_b32_e32 v35, v35, v34
		v_bitop3_b32 v10, 4, v10, v12 bitop3:0x96
		v_bitop3_b32 v10, v10, v16, v34 bitop3:0x96
		v_cmp_lt_i32_e64 s[26:27], v35, s14
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 s[28:29], v33, s23
		v_cmp_lt_i32_e64 s[30:31], v35, s23
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 s[32:33], v33, s23
		v_cmp_lt_i32_e64 s[34:35], v35, s23
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
		v_xor_b32_e32 v14, v14, v34
		v_bitop3_b32 v36, 16, v9, v16 bitop3:0x96
		v_bitop3_b32 v36, v36, v12, v34 bitop3:0x96
		v_bitop3_b32 v37, 32, v9, v16 bitop3:0x96
		v_bitop3_b32 v37, v37, v12, v34 bitop3:0x96
		v_bitop3_b32 v38, 48, v9, v16 bitop3:0x96
		v_bitop3_b32 v38, v38, v12, v34 bitop3:0x96
		v_bitop3_b32 v39, 64, v9, v16 bitop3:0x96
		v_bitop3_b32 v39, v39, v12, v34 bitop3:0x96
		v_xor_b32_e32 v40, 0x50, v9
		v_xor_b32_e32 v40, v40, v16
		v_xor_b32_e32 v40, v40, v12
		v_xor_b32_e32 v40, v40, v34
		v_xor_b32_e32 v41, 0x60, v9
		v_xor_b32_e32 v41, v41, v16
		v_xor_b32_e32 v41, v41, v12
		v_xor_b32_e32 v41, v41, v34
		v_xor_b32_e32 v9, 0x70, v9
		v_xor_b32_e32 v9, v9, v16
		v_xor_b32_e32 v9, v9, v12
		v_xor_b32_e32 v9, v9, v34
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v4
		v_bitop3_b32 v2, v33, v12, v2 bitop3:0x96
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
		v_mov_b32_e32 v7, s39
		v_mov_b32_e32 v12, s12
		v_cndmask_b32_e64 v7, v12, v7, s[60:61]
		v_cvt_f32_u32_e32 v12, v7
		v_rcp_iflag_f32_e32 v12, v12
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		v_mul_f32_e32 v12, v4, v12
		v_cvt_u32_f32_e32 v12, v12
		v_xad_u32 v16, v7, -1, 1
		v_mul_lo_u32 v34, v16, v12
		v_mul_hi_u32 v34, v12, v34
		v_add_u32_e32 v12, v12, v34
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v34, s39
		v_mov_b32_e32 v42, s13
		v_cndmask_b32_e64 v34, v42, v34, s[60:61]
		v_cvt_f32_u32_e32 v42, v34
		v_rcp_iflag_f32_e32 v42, v42
		v_and_b32_e32 v13, 1, v13
		v_mul_f32_e32 v42, v4, v42
		v_cvt_u32_f32_e32 v42, v42
		v_xad_u32 v43, v34, -1, 1
		v_mul_lo_u32 v44, v43, v42
		v_mul_hi_u32 v44, v42, v44
		v_add_u32_e32 v42, v42, v44
		v_and_b32_e32 v44, 3, v0
		v_lshlrev_b32_e32 v45, 3, v44
		v_mov_b32_e32 v46, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v47, s17, v15
		v_lshlrev_b32_e32 v47, 3, v47
		v_mul_lo_u32 v48, s17, v11
		v_lshlrev_b32_e32 v48, 1, v48
		v_and_b32_e32 v49, 1, v8
		v_mul_lo_u32 v50, s17, v49
		v_lshlrev_b32_e32 v50, 5, v50
		v_add3_u32 v51, v47, v48, v50
		s_lshl_b32 s39, s17, 3
		v_add_u32_e32 v52, s39, v51
		v_add_u32_e32 v53, 32, v45
		s_lshl_b32 s39, s17, 6
		v_add_u32_e32 v54, s39, v51
		s_mul_i32 s39, 0x48, s17
		v_add_u32_e32 v55, v47, v48
		v_add3_u32 v56, v50, v55, s39
		v_add_u32_e32 v57, 64, v45
		s_lshl_b32 s39, s17, 7
		v_add3_u32 v58, v50, v55, s39
		s_mul_i32 s39, 0x88, s17
		v_add3_u32 v55, v50, v55, s39
		v_and_b32_e32 v59, 63, v0
		v_lshrrev_b32_e32 v60, 4, v59
		v_lshlrev_b32_e32 v60, 4, v60
		v_lshl_add_u32 v15, v15, 9, v60
		v_and_b32_e32 v60, 15, v59
		v_lshrrev_b32_e32 v61, 1, v60
		v_lshlrev_b32_e32 v61, 6, v61
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 0x420
		v_mul_lo_u32 v62, v62, v60
		v_add3_u32 v15, v15, v61, v62
		v_lshl_add_u32 v13, v13, 6, v45
		v_and_b32_e32 v60, 1, v11
		v_lshl_add_u32 v13, v60, 5, v13
		v_lshlrev_b32_e32 v60, 9, v49
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v61, 0x1080
		v_mul_lo_u32 v61, v61, v6
		v_add3_u32 v6, v13, v60, v61
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v13, 0x840
		v_mul_lo_u32 v13, v13, v3
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v3, 0x420
		v_mul_lo_u32 v3, v3, v1
		v_add3_u32 v1, v6, v13, v3
		v_lshlrev_b32_e32 v3, 4, v44
		v_add_u32_e32 v3, 0xc0, v3
		s_lshl_b32 s39, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s56, 0xc0, s17
		s_mul_i32 s57, 0xc8, s17
		s_mul_i32 s58, 0x2100, s36
		v_add_u32_e32 v6, s58, v15
		s_mul_i32 s36, 0x4200, s36
		v_add_u32_e32 v13, s36, v1
		s_mul_i32 s36, 0x2100, s21
		v_add_u32_e32 v44, s36, v15
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v60, s21, v1
		v_lshlrev_b32_e32 v49, 1, v49
		v_xor_b32_e32 v49, v0, v49
		v_lshlrev_b32_e32 v61, 4, v49
		v_add_u32_e32 v61, 0x10000, v61
		v_xor_b32_e32 v49, 1, v49
		v_lshlrev_b32_e32 v49, 4, v49
		v_add_u32_e32 v49, 0x10000, v49
		v_lshrrev_b32_e32 v62, 3, v59
		v_and_b32_e32 v62, 3, v62
		v_lshlrev_b32_e32 v63, 13, v62
		v_add_u32_e32 v63, 0x10000, v63
		v_lshlrev_b32_e32 v11, 1, v11
		v_lshrrev_b32_e32 v64, 5, v59
		v_and_b32_e32 v59, 7, v59
		v_lshlrev_b32_e32 v59, 5, v59
		v_add3_u32 v65, v11, v64, v59
		v_and_b32_e32 v66, 1, v0
		v_lshlrev_b32_e32 v66, 1, v66
		v_bitop3_b32 v62, v66, v62, 1 bitop3:0x78
		v_xor_b32_e32 v65, v65, v62
		v_lshl_add_u32 v65, v65, 4, v63
		v_add_u32_e32 v66, 16, v11
		v_add3_u32 v66, v66, v64, v59
		v_xor_b32_e32 v66, v66, v62
		v_lshl_add_u32 v66, v66, 4, v63
		v_add_u32_e32 v67, 0x100, v11
		v_add3_u32 v67, v67, v64, v59
		v_xor_b32_e32 v67, v67, v62
		v_lshl_add_u32 v67, v67, 4, v63
		v_add_u32_e32 v11, 0x110, v11
		v_add3_u32 v11, v11, v64, v59
		v_xor_b32_e32 v11, v11, v62
		v_lshl_add_u32 v11, v11, 4, v63
		v_mul_lo_u32 v8, s19, v8
		v_and_b32_e32 v59, 31, v0
		s_cselect_b32 s21, 1, 0
		s_lshl_b32 s36, s19, 5
		s_lshl_b32 s58, s19, 6
		s_mul_i32 s59, 0x60, s19
		s_lshl_b32 s60, s19, 7
		s_cmp_lt_i32 s16, s20
		s_mul_i32 s16, 0xa0, s19
		s_mul_i32 s61, 0xc0, s19
		s_mul_i32 s62, 0xe0, s19
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s3, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s63, s3
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s63, s3, 7
		s_lshr_b32 s64, s3, 3
		s_lshr_b32 s65, s64, 2
		s_mul_i32 s65, s65, 32
		s_mul_i32 s63, s63, 4
		s_add_i32 s63, s65, s63
		s_and_b32 s64, s64, 3
		s_add_i32 s63, s63, s64
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		v_readfirstlane_b32 s64, v0
		s_cmp_lt_i32 s63, 0
		s_cselect_b32 s65, 1, 0
		s_xor_b32 s66, s63, -1
		s_add_i32 s66, s66, 1
		s_cmp_lg_u32 s65, 0
		s_cselect_b32 s65, s66, s63
		s_cselect_b32 s66, 1, 0
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s67, s38, s1
		v_mov_b32_e32 v62, s67
		v_cvt_f32_u32_e32 v62, v62
		v_rcp_iflag_f32_e32 v62, v62
		s_barrier
		v_mul_f32_e32 v62, v4, v62
		v_cvt_u32_f32_e32 v62, v62
		s_xor_b32 s68, s67, -1
		v_readfirstlane_b32 s69, v62
		s_add_i32 s68, s68, 1
		s_mul_i32 s70, s68, s69
		s_mul_hi_u32 s70, s69, s70
		s_add_i32 s69, s69, s70
		s_mul_hi_u32 s69, s65, s69
		s_mul_i32 s70, s69, s67
		s_xor_b32 s70, s70, -1
		s_add_i32 s70, s70, 1
		s_add_i32 s65, s65, s70
		s_cmp_ge_u32 s65, s67
		s_cselect_b32 s70, 1, 0
		s_add_i32 s71, s69, 1
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s69, s71, s69
		s_cselect_b32 s70, 1, 0
		s_add_i32 s71, s65, s68
		s_cmp_lg_u32 s70, 0
		s_cselect_b32 s65, s71, s65
		s_cmp_ge_u32 s65, s67
		s_cselect_b32 s67, 1, 0
		s_add_i32 s70, s69, 1
		s_cmp_lg_u32 s67, 0
		s_cselect_b32 s67, s70, s69
		s_cselect_b32 s69, 1, 0
		s_xor_b32 s63, s63, s1
		s_xor_b32 s70, s67, -1
		s_add_i32 s70, s70, 1
		s_cmp_lt_i32 s63, 0
		s_cselect_b32 s63, s70, s67
		s_mul_i32 s67, s63, 4
		s_xor_b32 s70, s67, -1
		s_add_i32 s70, s70, 1
		s_add_i32 s70, s0, s70
		s_cmp_lt_i32 s70, 4
		s_cselect_b32 s70, s70, 4
		s_add_i32 s68, s65, s68
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s65, s68, s65
		s_xor_b32 s68, s65, -1
		s_add_i32 s68, s68, 1
		s_cmp_lg_u32 s66, 0
		s_cselect_b32 s65, s68, s65
		s_cmp_lt_i32 s65, 0
		s_cselect_b32 s66, 1, 0
		s_xor_b32 s68, s65, -1
		s_add_i32 s68, s68, 1
		s_cmp_lg_u32 s66, 0
		s_cselect_b32 s66, s68, s65
		s_cselect_b32 s68, 1, 0
		s_xor_b32 s69, s70, -1
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s70, 0
		s_cselect_b32 s69, s69, s70
		v_mov_b32_e32 v62, s69
		v_cvt_f32_u32_e32 v62, v62
		v_rcp_iflag_f32_e32 v62, v62
		s_xor_b32 s71, s69, -1
		v_mul_f32_e32 v62, v4, v62
		v_cvt_u32_f32_e32 v62, v62
		s_add_i32 s71, s71, 1
		v_readfirstlane_b32 s72, v62
		s_mul_i32 s73, s71, s72
		s_mul_hi_u32 s73, s72, s73
		s_add_i32 s72, s72, s73
		s_mul_hi_u32 s72, s66, s72
		s_mul_i32 s73, s72, s69
		s_xor_b32 s73, s73, -1
		s_add_i32 s73, s73, 1
		s_add_i32 s66, s66, s73
		s_cmp_ge_u32 s66, s69
		s_cselect_b32 s73, 1, 0
		s_add_i32 s74, s66, s71
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s66, s74, s66
		s_cselect_b32 s73, 1, 0
		s_cmp_ge_u32 s66, s69
		s_cselect_b32 s69, 1, 0
		s_add_i32 s71, s66, s71
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s66, s71, s66
		s_cselect_b32 s69, 1, 0
		s_xor_b32 s71, s66, -1
		s_add_i32 s71, s71, 1
		s_cmp_lg_u32 s68, 0
		s_cselect_b32 s66, s71, s66
		s_add_i32 s67, s67, s66
		s_add_i32 s68, s72, 1
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s68, s68, s72
		s_add_i32 s71, s68, 1
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s68, s71, s68
		s_xor_b32 s65, s65, s70
		s_xor_b32 s69, s68, -1
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s65, 0
		s_cselect_b32 s65, s69, s68
		s_mul_i32 s67, s67, 0x80
		v_add_u32_e32 v62, s67, v5
		v_cmp_lt_i32_e64 vcc, v62, s2
		v_xad_u32 v63, v62, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v62, v62, v63, vcc
		v_mul_hi_u32 v63, v62, v12
		v_mul_lo_u32 v63, v63, v7
		v_xor_b32_e32 v63, -1, v63
		v_add3_u32 v62, 1, v63, v62
		v_add_u32_e32 v63, v62, v16
		v_cmp_ge_u32_e64 vcc, v62, v7
		v_add_u32_e32 v64, s67, v17
		v_add_u32_e32 v68, s67, v18
		v_cndmask_b32_e32 v62, v62, v63, vcc
		v_add_u32_e32 v63, v62, v16
		v_cmp_ge_u32_e64 vcc, v62, v7
		v_add_u32_e32 v69, s67, v19
		v_add_u32_e32 v70, s67, v20
		v_cndmask_b32_e32 v62, v62, v63, vcc
		v_xad_u32 v63, v62, -1, 1
		v_cndmask_b32_e64 v62, v62, v63, s[68:69]
		v_cmp_lt_i32_e64 vcc, v64, s2
		v_xad_u32 v63, v64, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v63, v64, v63, vcc
		v_mul_hi_u32 v64, v63, v12
		v_mul_lo_u32 v64, v64, v7
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v63, 1, v64, v63
		v_add_u32_e32 v64, v63, v16
		v_cmp_ge_u32_e64 vcc, v63, v7
		v_add_u32_e32 v71, s67, v21
		v_add_u32_e32 v72, s67, v22
		v_cndmask_b32_e32 v63, v63, v64, vcc
		v_add_u32_e32 v64, v63, v16
		v_cmp_ge_u32_e64 vcc, v63, v7
		v_add_u32_e32 v73, s67, v23
		v_add_u32_e32 v74, s67, v24
		v_cndmask_b32_e32 v63, v63, v64, vcc
		v_xad_u32 v64, v63, -1, 1
		v_cndmask_b32_e64 v63, v63, v64, s[68:69]
		v_cmp_lt_i32_e64 vcc, v68, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v64, v68, -1, 1
		v_cndmask_b32_e32 v64, v68, v64, vcc
		v_mul_hi_u32 v68, v64, v12
		v_mul_lo_u32 v68, v68, v7
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v64, 1, v68, v64
		v_add_u32_e32 v68, v64, v16
		v_cmp_ge_u32_e64 vcc, v64, v7
		s_lshr_b32 s64, s64, 6
		s_mul_i32 s64, 0x420, s64
		v_cndmask_b32_e32 v64, v64, v68, vcc
		v_cmp_ge_u32_e64 vcc, v64, v7
		v_add_u32_e32 v68, v64, v16
		v_add_u32_e32 v75, s67, v37
		v_cndmask_b32_e32 v64, v64, v68, vcc
		v_xad_u32 v68, v64, -1, 1
		v_cndmask_b32_e64 v64, v64, v68, s[68:69]
		v_cmp_lt_i32_e64 vcc, v69, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v68, v69, -1, 1
		v_cndmask_b32_e32 v68, v69, v68, vcc
		v_mul_hi_u32 v69, v68, v12
		v_mul_lo_u32 v69, v69, v7
		v_xor_b32_e32 v69, -1, v69
		v_add3_u32 v68, 1, v69, v68
		v_cmp_ge_u32_e64 vcc, v68, v7
		v_add_u32_e32 v69, v68, v16
		s_mov_b32 m0, s64
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_cmp_ge_u32_e64 vcc, v68, v7
		v_add_u32_e32 v69, v68, v16
		v_add_u32_e32 v76, s67, v36
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_xad_u32 v69, v68, -1, 1
		v_cndmask_b32_e64 v68, v68, v69, s[68:69]
		v_cmp_lt_i32_e64 vcc, v70, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v69, v70, -1, 1
		v_cndmask_b32_e32 v69, v70, v69, vcc
		v_mul_hi_u32 v70, v69, v12
		v_mul_lo_u32 v70, v70, v7
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v69, 1, v70, v69
		v_cmp_ge_u32_e64 vcc, v69, v7
		v_add_u32_e32 v70, v69, v16
		s_mul_i32 s70, s65, 0x100
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_cmp_ge_u32_e64 vcc, v69, v7
		v_add_u32_e32 v70, v69, v16
		v_add_u32_e32 v77, s67, v14
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_xad_u32 v70, v69, -1, 1
		v_cndmask_b32_e64 v69, v69, v70, s[68:69]
		v_cmp_lt_i32_e64 vcc, v71, s2
		v_mul_lo_u32 v69, s18, v69
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v70, v71, -1, 1
		v_cndmask_b32_e32 v70, v71, v70, vcc
		v_mul_hi_u32 v71, v70, v12
		v_mul_lo_u32 v71, v71, v7
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v70, 1, v71, v70
		v_cmp_ge_u32_e64 vcc, v70, v7
		v_add_u32_e32 v71, v70, v16
		v_xad_u32 v78, v72, -1, 1
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_cmp_ge_u32_e64 vcc, v70, v7
		v_add_u32_e32 v71, v70, v16
		v_xad_u32 v79, v73, -1, 1
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_xad_u32 v71, v70, -1, 1
		v_cndmask_b32_e64 v70, v70, v71, s[68:69]
		v_cmp_lt_i32_e64 vcc, v72, s2
		v_xad_u32 v71, v74, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v72, v72, v78, vcc
		v_mul_hi_u32 v78, v72, v12
		v_mul_lo_u32 v78, v78, v7
		v_xor_b32_e32 v78, -1, v78
		v_add3_u32 v72, 1, v78, v72
		v_cmp_ge_u32_e64 vcc, v72, v7
		v_add_u32_e32 v78, v72, v16
		v_add_u32_e32 v80, s70, v26
		v_cndmask_b32_e32 v72, v72, v78, vcc
		v_cmp_ge_u32_e64 vcc, v72, v7
		v_add_u32_e32 v78, v72, v16
		v_xad_u32 v81, v80, -1, 1
		v_cndmask_b32_e32 v72, v72, v78, vcc
		v_xad_u32 v78, v72, -1, 1
		v_cndmask_b32_e64 v72, v72, v78, s[68:69]
		v_cmp_lt_i32_e64 vcc, v73, s2
		v_add_u32_e32 v78, s70, v25
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v73, v73, v79, vcc
		v_mul_hi_u32 v79, v73, v12
		v_mul_lo_u32 v79, v79, v7
		v_xor_b32_e32 v79, -1, v79
		v_add3_u32 v73, 1, v79, v73
		v_cmp_ge_u32_e64 vcc, v73, v7
		v_add_u32_e32 v79, v73, v16
		v_add_u32_e32 v82, s70, v27
		v_cndmask_b32_e32 v73, v73, v79, vcc
		v_cmp_ge_u32_e64 vcc, v73, v7
		v_add_u32_e32 v79, v73, v16
		v_add_u32_e32 v83, s70, v28
		v_cndmask_b32_e32 v73, v73, v79, vcc
		v_xad_u32 v79, v73, -1, 1
		v_cndmask_b32_e64 v73, v73, v79, s[68:69]
		v_cmp_lt_i32_e64 vcc, v74, s2
		v_xad_u32 v79, v78, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v71, v74, v71, vcc
		v_mul_hi_u32 v74, v71, v12
		v_mul_lo_u32 v74, v74, v7
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v71, 1, v74, v71
		v_cmp_ge_u32_e64 vcc, v71, v7
		v_add_u32_e32 v74, v71, v16
		v_add_u32_e32 v84, s70, v29
		v_cndmask_b32_e32 v71, v71, v74, vcc
		v_cmp_ge_u32_e64 vcc, v71, v7
		v_add_u32_e32 v74, v71, v16
		v_add_u32_e32 v85, s70, v30
		v_cndmask_b32_e32 v71, v71, v74, vcc
		v_xad_u32 v74, v71, -1, 1
		v_cndmask_b32_e64 v71, v71, v74, s[68:69]
		v_cmp_lt_i32_e64 vcc, v80, s2
		v_add_u32_e32 v74, s70, v31
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v80, v80, v81, vcc
		v_mul_hi_u32 v81, v80, v42
		v_mul_lo_u32 v81, v81, v34
		v_xor_b32_e32 v81, -1, v81
		v_add3_u32 v80, 1, v81, v80
		v_add_u32_e32 v81, v80, v43
		v_cmp_ge_u32_e64 vcc, v80, v34
		v_add_u32_e32 v86, s70, v32
		v_xad_u32 v87, v82, -1, 1
		v_cndmask_b32_e32 v80, v80, v81, vcc
		v_add_u32_e32 v81, v80, v43
		v_cmp_ge_u32_e64 vcc, v80, v34
		v_xad_u32 v88, v83, -1, 1
		v_xad_u32 v89, v84, -1, 1
		v_cndmask_b32_e32 v80, v80, v81, vcc
		v_xad_u32 v81, v80, -1, 1
		v_cndmask_b32_e64 v80, v80, v81, s[68:69]
		v_cmp_lt_i32_e64 vcc, v78, s2
		v_xad_u32 v81, v85, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v78, v78, v79, vcc
		v_mul_hi_u32 v79, v78, v42
		v_mul_lo_u32 v79, v79, v34
		v_xor_b32_e32 v79, -1, v79
		v_add3_u32 v78, 1, v79, v78
		v_add_u32_e32 v79, v78, v43
		v_cmp_ge_u32_e64 vcc, v78, v34
		v_mul_lo_u32 v90, s39, v62
		v_mul_lo_u32 v62, s15, v62
		v_cndmask_b32_e32 v78, v78, v79, vcc
		v_add_u32_e32 v79, v78, v43
		v_cmp_ge_u32_e64 vcc, v78, v34
		v_xad_u32 v91, v74, -1, 1
		v_lshlrev_b32_e32 v92, 1, v80
		v_cndmask_b32_e32 v78, v78, v79, vcc
		v_xad_u32 v79, v78, -1, 1
		v_cndmask_b32_e64 v78, v78, v79, s[68:69]
		v_cmp_lt_i32_e64 vcc, v82, s2
		v_lshlrev_b32_e32 v79, 1, v78
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v82, v82, v87, vcc
		v_mul_hi_u32 v87, v82, v42
		v_mul_lo_u32 v87, v87, v34
		v_xor_b32_e32 v87, -1, v87
		v_add3_u32 v82, 1, v87, v82
		v_add_u32_e32 v87, v82, v43
		v_cmp_ge_u32_e64 vcc, v82, v34
		v_xad_u32 v93, v86, -1, 1
		v_add_lshl_u32 v94, v45, v62, 1
		v_cndmask_b32_e32 v82, v82, v87, vcc
		v_cmp_ge_u32_e64 vcc, v82, v34
		v_add_u32_e32 v87, v82, v43
		v_cndmask_b32_e64 v94, v46, v94, s[24:25]
		v_cndmask_b32_e32 v82, v82, v87, vcc
		buffer_load_dwordx4 v94, s[40:43], 0 offen lds
		v_xad_u32 v87, v82, -1, 1
		v_cndmask_b32_e64 v82, v82, v87, s[68:69]
		v_cmp_lt_i32_e64 vcc, v83, s2
		v_lshlrev_b32_e32 v87, 1, v82
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v83, v83, v88, vcc
		v_mul_hi_u32 v88, v83, v42
		v_mul_lo_u32 v88, v88, v34
		v_xor_b32_e32 v88, -1, v88
		v_add3_u32 v83, 1, v88, v83
		v_cmp_ge_u32_e64 vcc, v83, v34
		v_add_u32_e32 v88, v83, v43
		s_add_i32 m0, m0, 0x62e0
		v_cndmask_b32_e32 v83, v83, v88, vcc
		v_cmp_ge_u32_e64 vcc, v83, v34
		v_add_u32_e32 v88, v83, v43
		v_add_u32_e32 v94, v51, v92
		v_cndmask_b32_e32 v83, v83, v88, vcc
		v_xad_u32 v88, v83, -1, 1
		v_cndmask_b32_e64 v83, v83, v88, s[68:69]
		v_cmp_lt_i32_e64 vcc, v84, s2
		v_cndmask_b32_e64 v88, v46, v94, s[26:27]
		s_mov_b64 s[68:69], vcc
		buffer_load_dwordx4 v88, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v84, v84, v89, vcc
		v_mul_hi_u32 v88, v84, v42
		v_mul_lo_u32 v88, v88, v34
		v_xor_b32_e32 v88, -1, v88
		v_add3_u32 v84, 1, v88, v84
		v_cmp_ge_u32_e64 vcc, v84, v34
		v_add_u32_e32 v88, v84, v43
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e32 v84, v84, v88, vcc
		v_cmp_ge_u32_e64 vcc, v84, v34
		v_add_u32_e32 v88, v84, v43
		v_add_u32_e32 v89, v52, v92
		v_cndmask_b32_e32 v84, v84, v88, vcc
		v_xad_u32 v88, v84, -1, 1
		v_cndmask_b32_e64 v84, v84, v88, s[68:69]
		v_cmp_lt_i32_e64 vcc, v85, s2
		v_cndmask_b32_e64 v88, v46, v89, s[26:27]
		s_mov_b64 s[68:69], vcc
		buffer_load_dwordx4 v88, s[44:47], 0 offen lds
		v_cndmask_b32_e32 v81, v85, v81, vcc
		v_mul_hi_u32 v85, v81, v42
		v_mul_lo_u32 v85, v85, v34
		v_xor_b32_e32 v85, -1, v85
		v_add3_u32 v81, 1, v85, v81
		v_cmp_ge_u32_e64 vcc, v81, v34
		v_add_u32_e32 v85, v81, v43
		s_add_i32 m0, m0, 0xffff9d20
		v_cndmask_b32_e32 v81, v81, v85, vcc
		v_cmp_ge_u32_e64 vcc, v81, v34
		v_add_u32_e32 v85, v81, v43
		v_add_lshl_u32 v88, v53, v62, 1
		v_cndmask_b32_e32 v81, v81, v85, vcc
		v_xad_u32 v85, v81, -1, 1
		v_cndmask_b32_e64 v81, v81, v85, s[68:69]
		v_cmp_lt_i32_e64 vcc, v74, s2
		v_cndmask_b32_e64 v85, v46, v88, s[28:29]
		s_mov_b64 s[68:69], vcc
		buffer_load_dwordx4 v85, s[40:43], 0 offen lds
		v_cndmask_b32_e32 v74, v74, v91, vcc
		v_mul_hi_u32 v85, v74, v42
		v_mul_lo_u32 v85, v85, v34
		v_xor_b32_e32 v85, -1, v85
		v_add3_u32 v74, 1, v85, v74
		v_cmp_ge_u32_e64 vcc, v74, v34
		v_add_u32_e32 v85, v74, v43
		s_add_i32 m0, m0, 0x83e0
		v_cndmask_b32_e32 v74, v74, v85, vcc
		v_cmp_ge_u32_e64 vcc, v74, v34
		v_add_u32_e32 v85, v74, v43
		v_add_lshl_u32 v62, v57, v62, 1
		v_cndmask_b32_e32 v74, v74, v85, vcc
		v_xad_u32 v85, v74, -1, 1
		v_cndmask_b32_e64 v74, v74, v85, s[68:69]
		v_cmp_lt_i32_e64 vcc, v86, s2
		v_cndmask_b32_e64 v62, v46, v62, s[32:33]
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v85, v86, v93, vcc
		v_mul_hi_u32 v86, v85, v42
		v_mul_lo_u32 v86, v86, v34
		v_xor_b32_e32 v86, -1, v86
		v_add3_u32 v85, 1, v86, v85
		v_cmp_ge_u32_e64 vcc, v85, v34
		v_add_u32_e32 v86, v85, v43
		v_add_u32_e32 v88, v54, v92
		v_cndmask_b32_e32 v85, v85, v86, vcc
		v_cmp_ge_u32_e64 vcc, v85, v34
		v_add_u32_e32 v86, v85, v43
		v_cndmask_b32_e64 v88, v46, v88, s[30:31]
		v_cndmask_b32_e32 v85, v85, v86, vcc
		buffer_load_dwordx4 v88, s[44:47], 0 offen lds
		v_xad_u32 v86, v85, -1, 1
		v_cndmask_b32_e64 v85, v85, v86, s[68:69]
		v_add_u32_e32 v86, v56, v92
		v_cndmask_b32_e64 v86, v46, v86, s[30:31]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v88, v58, v92
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v86, v46, v88, s[34:35]
		s_add_i32 m0, m0, 0xffff7c20
		v_add_u32_e32 v88, v55, v92
		buffer_load_dwordx4 v62, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v62, v46, v88, s[34:35]
		s_add_i32 m0, m0, 0xa4e0
		v_mul_lo_u32 v63, s18, v63
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_mul_lo_u32 v64, s18, v64
		s_add_i32 m0, m0, 0x2100
		v_mul_lo_u32 v68, s18, v68
		buffer_load_dwordx4 v62, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[96:99], v15
		ds_read_b128 v[100:103], v15 offset:2112
		ds_read_b128 v[104:107], v15 offset:4224
		ds_read_b128 v[108:111], v15 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[112:113], v1 offset:25312
		ds_read_b64_tr_b16 v[114:115], v1 offset:33760
		ds_read_b64_tr_b16 v[116:117], v1 offset:25440
		ds_read_b64_tr_b16 v[118:119], v1 offset:33888
		ds_read_b64_tr_b16 v[120:121], v1 offset:25568
		ds_read_b64_tr_b16 v[122:123], v1 offset:34016
		ds_read_b64_tr_b16 v[124:125], v1 offset:25696
		ds_read_b64_tr_b16 v[126:127], v1 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[86:87], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[86:87]
		s_setprio 0
		v_add_u32_e32 v62, v3, v90
		s_mov_b32 s68, 0
		s_mov_b32 s69, 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
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
		s_cmp_lg_u32 s21, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[88:91], v[112:115], v[96:99], v[88:91]
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[96:99], v[128:131]
		s_lshl_b32 s71, s69, 6
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[96:99], v[132:135]
		s_cmp_ge_u32 s68, 2
		v_mfma_f32_16x16x32_f16 v[136:139], v[124:127], v[96:99], v[136:139]
		s_cselect_b32 s72, 1, 0
		s_add_i32 s73, s68, -2
		v_mfma_f32_16x16x32_f16 v[152:155], v[124:127], v[100:103], v[152:155]
		s_add_i32 s74, s68, 1
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[100:103], v[140:143]
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s72, s73, s74
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[100:103], v[144:147]
		s_add_i32 s73, s69, 3
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[100:103], v[148:151]
		s_mul_i32 s73, s73, 32
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[104:107], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[168:171], v[124:127], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[124:127], v[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[108:111], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[108:111], v[180:183]
		s_setprio 1
		s_barrier
		s_xor_b32 s73, s73, -1
		s_add_i32 s73, s73, 1
		s_add_i32 s73, s14, s73
		v_cmp_lt_i32_e64 vcc, v33, s73
		s_mul_i32 s74, -1, s71
		v_cmp_lt_i32_e64 s[76:77], v35, s73
		s_add_i32 s74, s74, 0x80000000
		v_mov_b32_e32 v86, s74
		v_cndmask_b32_e32 v86, v86, v62, vcc
		v_cmp_lt_i32_e64 vcc, v10, s73
		s_mul_i32 s73, 0x2100, s68
		s_add_i32 m0, s64, s73
		s_mul_i32 s68, 0x4200, s68
		buffer_load_dwordx4 v86, s[40:43], s71 offen lds
		s_mul_i32 s71, s17, s69
		s_lshl_b32 s71, s71, 6
		s_add_i32 s73, s56, s71
		v_add3_u32 v86, s73, v47, v48
		v_add3_u32 v86, v86, v50, v92
		v_cndmask_b32_e64 v86, v46, v86, s[76:77]
		s_add_i32 s68, s64, s68
		s_add_i32 m0, s68, 0x62e0
		s_add_i32 s68, s57, s71
		v_add3_u32 v93, s68, v47, v48
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		v_add3_u32 v86, v93, v50, v92
		v_cndmask_b32_e32 v86, v46, v86, vcc
		s_mul_i32 s68, 0x4200, s72
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v93, s68, v1
		buffer_load_dwordx4 v86, s[44:47], 0 offen lds
		s_barrier
		s_mul_i32 s68, 0x2100, s72
		v_add_u32_e32 v86, s68, v15
		s_waitcnt vmcnt(3)
		ds_read_b128 v[96:99], v86
		ds_read_b128 v[100:103], v86 offset:2112
		ds_read_b128 v[104:107], v86 offset:4224
		ds_read_b128 v[108:111], v86 offset:6336
		ds_read_b64_tr_b16 v[112:113], v93 offset:25312
		ds_read_b64_tr_b16 v[114:115], v93 offset:33760
		ds_read_b64_tr_b16 v[116:117], v93 offset:25440
		ds_read_b64_tr_b16 v[118:119], v93 offset:33888
		ds_read_b64_tr_b16 v[120:121], v93 offset:25568
		ds_read_b64_tr_b16 v[122:123], v93 offset:34016
		ds_read_b64_tr_b16 v[124:125], v93 offset:25696
		ds_read_b64_tr_b16 v[126:127], v93 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s69, s23
		s_mov_b32 s68, s72
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_setprio 0
		s_and_saveexec_b64 s[86:87], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[86:87]
		v_add_u32_e32 v62, s70, v2
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_ushort v86, v92, s[48:51], 0 offen
		buffer_load_ushort v92, v79, s[48:51], 0 offen
		buffer_load_ushort v79, v87, s[48:51], 0 offen
		v_lshlrev_b32_e32 v87, 1, v83
		buffer_load_ushort v93, v87, s[48:51], 0 offen
		v_lshlrev_b32_e32 v87, 1, v84
		buffer_load_ushort v94, v87, s[48:51], 0 offen
		v_lshlrev_b32_e32 v87, 1, v81
		buffer_load_ushort v95, v87, s[48:51], 0 offen
		v_lshlrev_b32_e32 v87, 1, v74
		buffer_load_ushort v188, v87, s[48:51], 0 offen
		v_lshlrev_b32_e32 v87, 1, v85
		buffer_load_ushort v189, v87, s[48:51], 0 offen
		v_add_lshl_u32 v87, v80, v63, 1
		buffer_load_ushort v190, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v78, v63, 1
		buffer_load_ushort v191, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v82, v63, 1
		buffer_load_ushort v192, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v83, v63, 1
		buffer_load_ushort v193, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v84, v63, 1
		v_cmp_lt_i32_e64 s[68:69], v77, s12
		buffer_load_ushort v77, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v81, v63, 1
		buffer_load_ushort v194, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v87, v74, v63, 1
		buffer_load_ushort v195, v87, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v63, 1
		buffer_load_ushort v87, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v80, v64, 1
		buffer_load_ushort v196, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v78, v64, 1
		buffer_load_ushort v197, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v82, v64, 1
		buffer_load_ushort v198, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v83, v64, 1
		buffer_load_ushort v199, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v84, v64, 1
		v_cmp_lt_i32_e64 s[70:71], v76, s12
		buffer_load_ushort v76, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v81, v64, 1
		buffer_load_ushort v200, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v74, v64, 1
		buffer_load_ushort v201, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v64, 1
		buffer_load_ushort v64, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v80, v68, 1
		buffer_load_ushort v202, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v78, v68, 1
		buffer_load_ushort v203, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v82, v68, 1
		buffer_load_ushort v204, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v83, v68, 1
		buffer_load_ushort v205, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v84, v68, 1
		v_cmp_lt_i32_e64 s[72:73], v75, s12
		buffer_load_ushort v75, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v81, v68, 1
		buffer_load_ushort v206, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v74, v68, 1
		buffer_load_ushort v207, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v68, 1
		buffer_load_ushort v68, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v80, v69, 1
		buffer_load_ushort v208, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v78, v69, 1
		buffer_load_ushort v209, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v82, v69, 1
		buffer_load_ushort v210, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v83, v69, 1
		buffer_load_ushort v211, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v84, v69, 1
		v_cmp_lt_i32_e64 s[74:75], v62, s13
		buffer_load_ushort v62, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v81, v69, 1
		buffer_load_ushort v212, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v74, v69, 1
		buffer_load_ushort v213, v63, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v69, 1
		buffer_load_ushort v69, v63, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v63, s18, v70
		v_add_lshl_u32 v70, v80, v63, 1
		buffer_load_ushort v214, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v78, v63, 1
		buffer_load_ushort v215, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v82, v63, 1
		buffer_load_ushort v216, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v83, v63, 1
		buffer_load_ushort v217, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v84, v63, 1
		buffer_load_ushort v218, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v81, v63, 1
		buffer_load_ushort v219, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v74, v63, 1
		buffer_load_ushort v220, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v63, 1
		buffer_load_ushort v70, v63, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v63, s18, v72
		v_add_lshl_u32 v72, v80, v63, 1
		buffer_load_ushort v221, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v78, v63, 1
		buffer_load_ushort v222, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v82, v63, 1
		buffer_load_ushort v223, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v83, v63, 1
		buffer_load_ushort v224, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v84, v63, 1
		buffer_load_ushort v225, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v81, v63, 1
		buffer_load_ushort v226, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v72, v74, v63, 1
		buffer_load_ushort v227, v72, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v63, 1
		buffer_load_ushort v72, v63, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v63, s18, v73
		v_add_lshl_u32 v73, v80, v63, 1
		buffer_load_ushort v228, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v78, v63, 1
		buffer_load_ushort v229, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v82, v63, 1
		buffer_load_ushort v230, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v83, v63, 1
		buffer_load_ushort v231, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v84, v63, 1
		buffer_load_ushort v232, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v81, v63, 1
		buffer_load_ushort v233, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v73, v74, v63, 1
		buffer_load_ushort v234, v73, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v63, v85, v63, 1
		buffer_load_ushort v73, v63, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v63, s18, v71
		v_add_lshl_u32 v71, v80, v63, 1
		buffer_load_ushort v80, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v78, v63, 1
		buffer_load_ushort v78, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v82, v63, 1
		buffer_load_ushort v82, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v83, v63, 1
		buffer_load_ushort v83, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v84, v63, 1
		buffer_load_ushort v84, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v81, v63, 1
		buffer_load_ushort v81, v71, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v71, v74, v63, 1
		v_add_lshl_u32 v63, v85, v63, 1
		buffer_load_ushort v74, v71, s[4:7], 0 offen sc0 nt
		buffer_load_ushort v71, v63, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[88:91], v[112:115], v[96:99], v[88:91]
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[96:99], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[124:127], v[96:99], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[124:127], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[100:103], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[100:103], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[100:103], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[104:107], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[108:111], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[168:171], v[124:127], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[124:127], v[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[108:111], v[176:179]
		ds_read_b128 v[96:99], v6
		ds_read_b128 v[100:103], v6 offset:2112
		ds_read_b128 v[104:107], v6 offset:4224
		ds_read_b128 v[108:111], v6 offset:6336
		ds_read_b64_tr_b16 v[112:113], v13 offset:25312
		ds_read_b64_tr_b16 v[114:115], v13 offset:33760
		ds_read_b64_tr_b16 v[116:117], v13 offset:25440
		ds_read_b64_tr_b16 v[118:119], v13 offset:33888
		ds_read_b64_tr_b16 v[120:121], v13 offset:25568
		ds_read_b64_tr_b16 v[122:123], v13 offset:34016
		ds_read_b64_tr_b16 v[124:125], v13 offset:25696
		ds_read_b64_tr_b16 v[126:127], v13 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[112:115], v[96:99], v[88:91]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[96:99], v[128:131]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[100:103], v[140:143]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[136:139], v[124:127], v[96:99], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[124:127], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[100:103], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[100:103], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[104:107], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[108:111], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[168:171], v[124:127], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[124:127], v[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[108:111], v[176:179]
		ds_read_b128 v[96:99], v44
		ds_read_b128 v[100:103], v44 offset:2112
		ds_read_b128 v[104:107], v44 offset:4224
		ds_read_b128 v[108:111], v44 offset:6336
		ds_read_b64_tr_b16 v[112:113], v60 offset:25312
		ds_read_b64_tr_b16 v[114:115], v60 offset:33760
		ds_read_b64_tr_b16 v[116:117], v60 offset:25440
		ds_read_b64_tr_b16 v[118:119], v60 offset:33888
		ds_read_b64_tr_b16 v[120:121], v60 offset:25568
		ds_read_b64_tr_b16 v[122:123], v60 offset:34016
		ds_read_b64_tr_b16 v[124:125], v60 offset:25696
		ds_read_b64_tr_b16 v[126:127], v60 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[112:115], v[96:99], v[88:91]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[128:131], v[116:119], v[96:99], v[128:131]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[132:135], v[120:123], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[112:115], v[100:103], v[140:143]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[136:139], v[124:127], v[96:99], v[136:139]
		s_barrier
		s_nop 2
		ds_write_b128 v61, v[88:91] offset:10432
		ds_write_b128 v49, v[128:131] offset:18624
		ds_write_b128 v61, v[132:135] offset:26816
		s_nop 0
		ds_write_b128 v49, v[136:139] offset:35008
		v_mfma_f32_16x16x32_f16 v[152:155], v[124:127], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[116:119], v[100:103], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[120:123], v[100:103], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[120:123], v[104:107], v[164:167]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[156:159], v[112:115], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[116:119], v[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[168:171], v[124:127], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[124:127], v[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[112:115], v[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[116:119], v[108:111], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[120:123], v[108:111], v[180:183]
		ds_read_b128 v[88:91], v65 offset:10432
		ds_read_b128 v[96:99], v66 offset:10432
		ds_read_b128 v[100:103], v67 offset:10432
		ds_read_b128 v[104:107], v11 offset:10432
		s_waitcnt vmcnt(62)
		v_cvt_f32_f16_e32 v108, v86
		v_cvt_f32_f16_e32 v109, v92
		v_cvt_f32_f16_e32 v110, v79
		v_cvt_f32_f16_e32 v111, v93
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v61, v[140:143] offset:10432
		ds_write_b128 v49, v[144:147] offset:18624
		ds_write_b128 v61, v[148:151] offset:26816
		ds_write_b128 v49, v[152:155] offset:35008
		v_cvt_f32_f16_e32 v92, v94
		v_cvt_f32_f16_e32 v93, v95
		v_cvt_f32_f16_e32 v94, v188
		v_cvt_f32_f16_e32 v95, v189
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[112:115], v65 offset:10432
		ds_read_b128 v[116:119], v66 offset:10432
		ds_read_b128 v[120:123], v67 offset:10432
		ds_read_b128 v[124:127], v11 offset:10432
		v_cvt_f32_f16_e32 v128, v190
		v_cvt_f32_f16_e32 v129, v191
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v130, v192
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v131, v193
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v61, v[156:159] offset:10432
		ds_write_b128 v49, v[160:163] offset:18624
		ds_write_b128 v61, v[164:167] offset:26816
		ds_write_b128 v49, v[168:171] offset:35008
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v132, v77
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v133, v194
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v134, v195
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v135, v87
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[136:139], v65 offset:10432
		ds_read_b128 v[140:143], v66 offset:10432
		ds_read_b128 v[144:147], v67 offset:10432
		ds_read_b128 v[148:151], v11 offset:10432
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v86, v196
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v87, v197
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v152, v198
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v153, v199
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v61, v[172:175] offset:10432
		ds_write_b128 v49, v[176:179] offset:18624
		ds_write_b128 v61, v[180:183] offset:26816
		ds_write_b128 v49, v[184:187] offset:35008
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v154, v76
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v155, v200
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v76, v201
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v77, v64
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[156:159], v65 offset:10432
		ds_read_b128 v[160:163], v66 offset:10432
		ds_read_b128 v[164:167], v67 offset:10432
		ds_read_b128 v[168:171], v11 offset:10432
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v172, v202
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v173, v203
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v174, v204
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v175, v205
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v176, v75
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v177, v206
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v178, v207
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v179, v68
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v180, v208
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v181, v209
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v182, v210
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v183, v211
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v184, v62
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v185, v212
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v62, v213
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v63, v69
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v68, v214
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v69, v215
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v186, v216
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v187, v217
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v188, v218
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v189, v219
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v190, v220
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v191, v70
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v192, v221
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v193, v222
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v194, v223
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v195, v224
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v196, v225
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v197, v226
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v198, v227
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v199, v72
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v200, v228
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v201, v229
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v202, v230
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v203, v231
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v204, v232
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v205, v233
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v206, v234
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v207, v73
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v72, v80
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v73, v78
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v78, v82
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v79, v83
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v82, v84
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v83, v81
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v80, v74
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v81, v71
		v_pk_add_f32 v[70:71], v[88:89], v[108:109]
		v_pk_add_f32 v[74:75], v[90:91], v[110:111]
		v_pk_add_f32 v[84:85], v[96:97], v[92:93]
		v_pk_add_f32 v[88:89], v[98:99], v[94:95]
		v_pk_add_f32 v[90:91], v[100:101], v[108:109]
		v_pk_add_f32 v[96:97], v[102:103], v[110:111]
		v_pk_add_f32 v[98:99], v[104:105], v[92:93]
		v_pk_add_f32 v[100:101], v[106:107], v[94:95]
		v_pk_add_f32 v[102:103], v[112:113], v[108:109]
		v_pk_add_f32 v[104:105], v[114:115], v[110:111]
		v_pk_add_f32 v[106:107], v[116:117], v[92:93]
		v_pk_add_f32 v[112:113], v[118:119], v[94:95]
		v_pk_add_f32 v[114:115], v[120:121], v[108:109]
		v_pk_add_f32 v[116:117], v[122:123], v[110:111]
		v_pk_add_f32 v[118:119], v[124:125], v[92:93]
		v_pk_add_f32 v[120:121], v[126:127], v[94:95]
		v_pk_add_f32 v[122:123], v[136:137], v[108:109]
		v_pk_add_f32 v[124:125], v[138:139], v[110:111]
		v_pk_add_f32 v[126:127], v[140:141], v[92:93]
		v_pk_add_f32 v[136:137], v[142:143], v[94:95]
		v_pk_add_f32 v[138:139], v[144:145], v[108:109]
		v_pk_add_f32 v[140:141], v[146:147], v[110:111]
		v_pk_add_f32 v[142:143], v[148:149], v[92:93]
		v_pk_add_f32 v[144:145], v[150:151], v[94:95]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[146:147], v[156:157], v[108:109]
		v_pk_add_f32 v[148:149], v[158:159], v[110:111]
		s_waitcnt lgkmcnt(2)
		v_pk_add_f32 v[150:151], v[160:161], v[92:93]
		v_pk_add_f32 v[156:157], v[162:163], v[94:95]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[108:109], v[164:165], v[108:109]
		v_pk_add_f32 v[110:111], v[166:167], v[110:111]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[92:93], v[168:169], v[92:93]
		v_pk_add_f32 v[94:95], v[170:171], v[94:95]
		v_pk_fma_f32 v[158:159], v[70:71], v[128:129], v[70:71]
		v_pk_fma_f32 v[70:71], v[74:75], v[130:131], v[74:75]
		v_pk_fma_f32 v[74:75], v[84:85], v[132:133], v[84:85]
		v_pk_fma_f32 v[84:85], v[88:89], v[134:135], v[88:89]
		v_pk_fma_f32 v[88:89], v[90:91], v[86:87], v[90:91]
		v_pk_fma_f32 v[86:87], v[96:97], v[152:153], v[96:97]
		v_pk_fma_f32 v[90:91], v[98:99], v[154:155], v[98:99]
		v_pk_fma_f32 v[96:97], v[100:101], v[76:77], v[100:101]
		v_pk_fma_f32 v[76:77], v[102:103], v[172:173], v[102:103]
		v_pk_fma_f32 v[98:99], v[104:105], v[174:175], v[104:105]
		v_pk_fma_f32 v[100:101], v[106:107], v[176:177], v[106:107]
		v_pk_fma_f32 v[102:103], v[112:113], v[178:179], v[112:113]
		v_pk_fma_f32 v[104:105], v[114:115], v[180:181], v[114:115]
		v_pk_fma_f32 v[106:107], v[116:117], v[182:183], v[116:117]
		v_pk_fma_f32 v[112:113], v[118:119], v[184:185], v[118:119]
		v_pk_fma_f32 v[114:115], v[120:121], v[62:63], v[120:121]
		v_pk_fma_f32 v[62:63], v[122:123], v[68:69], v[122:123]
		v_pk_fma_f32 v[68:69], v[124:125], v[186:187], v[124:125]
		v_pk_fma_f32 v[116:117], v[126:127], v[188:189], v[126:127]
		v_pk_fma_f32 v[118:119], v[136:137], v[190:191], v[136:137]
		v_pk_fma_f32 v[120:121], v[138:139], v[192:193], v[138:139]
		v_pk_fma_f32 v[122:123], v[140:141], v[194:195], v[140:141]
		v_pk_fma_f32 v[124:125], v[142:143], v[196:197], v[142:143]
		v_pk_fma_f32 v[126:127], v[144:145], v[198:199], v[144:145]
		v_pk_fma_f32 v[128:129], v[146:147], v[200:201], v[146:147]
		v_pk_fma_f32 v[130:131], v[148:149], v[202:203], v[148:149]
		v_pk_fma_f32 v[132:133], v[150:151], v[204:205], v[150:151]
		v_pk_fma_f32 v[134:135], v[156:157], v[206:207], v[156:157]
		v_pk_fma_f32 v[136:137], v[108:109], v[72:73], v[108:109]
		v_pk_fma_f32 v[72:73], v[110:111], v[78:79], v[110:111]
		v_pk_fma_f32 v[78:79], v[92:93], v[82:83], v[92:93]
		v_pk_fma_f32 v[82:83], v[94:95], v[80:81], v[94:95]
		v_add_u32_e32 v64, s67, v38
		v_add_u32_e32 v80, s67, v39
		v_add_u32_e32 v81, s67, v40
		v_add_u32_e32 v92, s67, v41
		v_add_u32_e32 v93, s67, v9
		v_cmp_lt_i32_e64 s[76:77], v64, s12
		v_cmp_lt_i32_e64 s[78:79], v80, s12
		v_cmp_lt_i32_e64 s[80:81], v81, s12
		v_cmp_lt_i32_e64 s[82:83], v92, s12
		v_cmp_lt_i32_e64 s[84:85], v93, s12
		v_cvt_pk_f16_f32 v92, v158, v159
		s_and_b64 s[68:69], s[68:69], s[74:75]
		v_cvt_pk_f16_f32 v93, v70, v71
		s_and_b64 s[70:71], s[70:71], s[74:75]
		v_cvt_pk_f16_f32 v94, v74, v75
		s_and_b64 s[72:73], s[72:73], s[74:75]
		v_cvt_pk_f16_f32 v95, v84, v85
		s_and_b64 s[76:77], s[76:77], s[74:75]
		s_and_b64 s[78:79], s[78:79], s[74:75]
		s_and_b64 s[80:81], s[80:81], s[74:75]
		s_and_b64 s[82:83], s[82:83], s[74:75]
		s_and_b64 s[74:75], s[84:85], s[74:75]
		s_lshl_b32 s64, s65, 9
		s_mul_i32 s63, s19, s63
		s_lshl_b32 s63, s63, 10
		s_add_i32 s65, s64, s63
		s_mul_i32 s66, s19, s66
		s_lshl_b32 s66, s66, 8
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v64, v8, 1, s65
		v_lshl_add_u32 v64, v59, 4, v64
		s_and_saveexec_b64 s[86:87], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_dwordx4 v[92:95], v64, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[86:87], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v92, v88, v89
		v_cvt_pk_f16_f32 v93, v86, v87
		v_cvt_pk_f16_f32 v94, v90, v91
		v_cvt_pk_f16_f32 v95, v96, v97
		s_add_i32 s65, s36, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v64, v8, 1, s65
		v_lshl_add_u32 v64, v59, 4, v64
		s_and_saveexec_b64 s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_dwordx4 v[92:95], v64, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[86:87], s[70:71]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[86:87]
		v_cvt_pk_f16_f32 v84, v76, v77
		v_cvt_pk_f16_f32 v85, v98, v99
		v_cvt_pk_f16_f32 v86, v100, v101
		v_cvt_pk_f16_f32 v87, v102, v103
		s_add_i32 s65, s58, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v64, v8, 1, s65
		v_lshl_add_u32 v64, v59, 4, v64
		s_and_saveexec_b64 s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_dwordx4 v[84:87], v64, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[86:87], s[72:73]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v84, v104, v105
		v_cvt_pk_f16_f32 v85, v106, v107
		v_cvt_pk_f16_f32 v86, v112, v113
		v_cvt_pk_f16_f32 v87, v114, v115
		s_add_i32 s65, s59, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v64, v8, 1, s65
		v_lshl_add_u32 v64, v59, 4, v64
		s_and_saveexec_b64 s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_dwordx4 v[84:87], v64, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[86:87], s[76:77]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v84, v62, v63
		v_cvt_pk_f16_f32 v85, v68, v69
		v_cvt_pk_f16_f32 v86, v116, v117
		v_cvt_pk_f16_f32 v87, v118, v119
		s_add_i32 s65, s60, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v62, v8, 1, s65
		v_lshl_add_u32 v62, v59, 4, v62
		s_and_saveexec_b64 s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_dwordx4 v[84:87], v62, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[86:87], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[86:87]
		v_cvt_pk_f16_f32 v68, v120, v121
		v_cvt_pk_f16_f32 v69, v122, v123
		v_cvt_pk_f16_f32 v70, v124, v125
		v_cvt_pk_f16_f32 v71, v126, v127
		s_add_i32 s65, s16, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v62, v8, 1, s65
		v_lshl_add_u32 v62, v59, 4, v62
		s_and_saveexec_b64 s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_dwordx4 v[68:71], v62, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[86:87], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v128, v129
		v_cvt_pk_f16_f32 v69, v130, v131
		v_cvt_pk_f16_f32 v70, v132, v133
		v_cvt_pk_f16_f32 v71, v134, v135
		s_add_i32 s65, s61, s64
		s_add_i32 s65, s65, s63
		s_add_i32 s65, s65, s66
		v_lshl_add_u32 v62, v8, 1, s65
		v_lshl_add_u32 v62, v59, 4, v62
		s_and_saveexec_b64 s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_dwordx4 v[68:71], v62, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[86:87], s[82:83]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[86:87]
		s_nop 0
		v_cvt_pk_f16_f32 v68, v136, v137
		v_cvt_pk_f16_f32 v69, v72, v73
		v_cvt_pk_f16_f32 v70, v78, v79
		v_cvt_pk_f16_f32 v71, v82, v83
		s_add_i32 s64, s62, s64
		s_add_i32 s63, s64, s63
		s_add_i32 s63, s63, s66
		v_lshl_add_u32 v62, v8, 1, s63
		v_lshl_add_u32 v62, v59, 4, v62
		s_and_saveexec_b64 s[86:87], s[74:75]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_dwordx4 v[68:71], v62, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[86:87], s[74:75]
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
		.amdhsa_next_free_vgpr 235
		.amdhsa_next_free_sgpr 88
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 235
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
    .vgpr_count:     235
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
