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
		v_mov_b32_e32 v36, 8
		v_mul_lo_u32 v36, v36, v16
		v_cmp_lt_i32_e64 s[24:25], v33, s14
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v37, v10, v12, v16 bitop3:0x96
		v_xor_b32_e32 v37, v37, v36
		v_bitop3_b32 v10, 4, v10, v12 bitop3:0x96
		v_bitop3_b32 v10, v10, v16, v36 bitop3:0x96
		v_cmp_lt_i32_e64 s[26:27], v37, s14
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 s[28:29], v33, s23
		v_cmp_lt_i32_e64 s[30:31], v37, s23
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 s[32:33], v33, s23
		v_cmp_lt_i32_e64 s[34:35], v37, s23
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
		v_xor_b32_e32 v14, v14, v36
		v_bitop3_b32 v38, 16, v9, v16 bitop3:0x96
		v_bitop3_b32 v38, v38, v12, v36 bitop3:0x96
		v_bitop3_b32 v39, 32, v9, v16 bitop3:0x96
		v_bitop3_b32 v39, v39, v12, v36 bitop3:0x96
		v_bitop3_b32 v40, 48, v9, v16 bitop3:0x96
		v_bitop3_b32 v40, v40, v12, v36 bitop3:0x96
		v_bitop3_b32 v41, 64, v9, v16 bitop3:0x96
		v_bitop3_b32 v41, v41, v12, v36 bitop3:0x96
		v_xor_b32_e32 v42, 0x50, v9
		v_xor_b32_e32 v42, v42, v16
		v_xor_b32_e32 v42, v42, v12
		v_xor_b32_e32 v42, v42, v36
		v_xor_b32_e32 v43, 0x60, v9
		v_xor_b32_e32 v43, v43, v16
		v_xor_b32_e32 v43, v43, v12
		v_xor_b32_e32 v43, v43, v36
		v_xor_b32_e32 v9, 0x70, v9
		v_xor_b32_e32 v9, v9, v16
		v_xor_b32_e32 v9, v9, v12
		v_xor_b32_e32 v9, v9, v36
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v4
		v_bitop3_b32 v4, v33, v12, v2 bitop3:0x96
		v_mov_b32_e32 v16, 0x80
		v_mul_lo_u32 v16, v16, v7
		v_xor_b32_e32 v4, v4, v16
		v_bitop3_b32 v7, 1, v34, v35 bitop3:0x96
		v_xor_b32_e32 v7, v7, v12
		v_bitop3_b32 v7, v7, v2, v16 bitop3:0x96
		v_bitop3_b32 v36, 2, v34, v35 bitop3:0x96
		v_xor_b32_e32 v36, v36, v12
		v_bitop3_b32 v36, v36, v2, v16 bitop3:0x96
		v_bitop3_b32 v44, 3, v34, v35 bitop3:0x96
		v_xor_b32_e32 v44, v44, v12
		v_bitop3_b32 v44, v44, v2, v16 bitop3:0x96
		v_bitop3_b32 v45, 4, v34, v35 bitop3:0x96
		v_xor_b32_e32 v45, v45, v12
		v_bitop3_b32 v45, v45, v2, v16 bitop3:0x96
		v_bitop3_b32 v46, 5, v34, v35 bitop3:0x96
		v_xor_b32_e32 v46, v46, v12
		v_bitop3_b32 v46, v46, v2, v16 bitop3:0x96
		v_bitop3_b32 v47, 6, v34, v35 bitop3:0x96
		v_xor_b32_e32 v47, v47, v12
		v_bitop3_b32 v47, v47, v2, v16 bitop3:0x96
		v_bitop3_b32 v34, 7, v34, v35 bitop3:0x96
		v_xor_b32_e32 v12, v34, v12
		v_bitop3_b32 v2, v12, v2, v16 bitop3:0x96
		s_mov_b32 s3, s16
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s37, 1, 0
		s_xor_b32 s38, s1, -1
		s_add_i32 s38, s38, 1
		v_mov_b32_e32 v12, 0x4f7ffffe
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s56, -1
		s_mov_b32 s57, -1
		s_mov_b32 s58, 0
		s_mov_b32 s59, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		s_xor_b32 s39, s12, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v16, s39
		v_mov_b32_e32 v34, s12
		v_cndmask_b32_e64 v16, v34, v16, s[60:61]
		v_cvt_f32_u32_e32 v34, v16
		v_rcp_iflag_f32_e32 v34, v34
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s60, s56, s58
		s_cselect_b32 s61, s57, s59
		v_mul_f32_e32 v34, v12, v34
		v_cvt_u32_f32_e32 v34, v34
		v_xad_u32 v35, v16, -1, 1
		v_mul_lo_u32 v48, v35, v34
		v_mul_hi_u32 v48, v34, v48
		v_add_u32_e32 v34, v34, v48
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		v_mov_b32_e32 v48, s39
		v_mov_b32_e32 v49, s13
		v_cndmask_b32_e64 v48, v49, v48, s[60:61]
		v_cvt_f32_u32_e32 v49, v48
		v_rcp_iflag_f32_e32 v49, v49
		v_and_b32_e32 v13, 1, v13
		v_mul_f32_e32 v49, v12, v49
		v_cvt_u32_f32_e32 v49, v49
		v_xad_u32 v50, v48, -1, 1
		v_mul_lo_u32 v51, v50, v49
		v_mul_hi_u32 v51, v49, v51
		v_add_u32_e32 v49, v49, v51
		v_and_b32_e32 v51, 3, v0
		v_lshlrev_b32_e32 v52, 3, v51
		v_mov_b32_e32 v53, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v54, s17, v15
		v_lshlrev_b32_e32 v54, 3, v54
		v_mul_lo_u32 v55, s17, v11
		v_lshlrev_b32_e32 v55, 1, v55
		v_and_b32_e32 v56, 1, v8
		v_mul_lo_u32 v57, s17, v56
		v_lshlrev_b32_e32 v57, 5, v57
		v_add3_u32 v58, v54, v55, v57
		s_lshl_b32 s39, s17, 3
		v_add_u32_e32 v59, s39, v58
		v_add_u32_e32 v60, 32, v52
		s_lshl_b32 s39, s17, 6
		v_add_u32_e32 v61, s39, v58
		s_mul_i32 s39, 0x48, s17
		v_add_u32_e32 v62, v54, v55
		v_add3_u32 v63, v57, v62, s39
		v_add_u32_e32 v64, 64, v52
		s_lshl_b32 s39, s17, 7
		v_add3_u32 v65, v57, v62, s39
		s_mul_i32 s39, 0x88, s17
		v_add3_u32 v62, v57, v62, s39
		v_and_b32_e32 v66, 63, v0
		v_lshrrev_b32_e32 v67, 4, v66
		v_lshlrev_b32_e32 v67, 4, v67
		v_lshl_add_u32 v15, v15, 9, v67
		v_and_b32_e32 v67, 15, v66
		v_lshrrev_b32_e32 v68, 1, v67
		v_lshlrev_b32_e32 v68, 6, v68
		v_and_b32_e32 v67, 1, v67
		v_mov_b32_e32 v69, 0x420
		v_mul_lo_u32 v69, v69, v67
		v_add3_u32 v15, v15, v68, v69
		v_lshl_add_u32 v13, v13, 6, v52
		v_and_b32_e32 v67, 1, v11
		v_lshl_add_u32 v13, v67, 5, v13
		v_lshlrev_b32_e32 v67, 9, v56
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v68, 0x1080
		v_mul_lo_u32 v68, v68, v6
		v_add3_u32 v6, v13, v67, v68
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v13, 0x840
		v_mul_lo_u32 v13, v13, v3
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v3, 0x420
		v_mul_lo_u32 v3, v3, v1
		v_add3_u32 v1, v6, v13, v3
		v_lshlrev_b32_e32 v3, 4, v51
		v_add_u32_e32 v3, 0xc0, v3
		s_cmp_lt_i32 0, s23
		s_mul_i32 s39, 0xc0, s17
		s_mul_i32 s56, 0xc8, s17
		s_mul_i32 s57, 0x2100, s36
		v_add_u32_e32 v6, s57, v15
		s_mul_i32 s36, 0x4200, s36
		v_add_u32_e32 v13, s36, v1
		s_mul_i32 s36, 0x2100, s21
		v_add_u32_e32 v51, s36, v15
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v67, s21, v1
		v_lshlrev_b32_e32 v56, 1, v56
		v_xor_b32_e32 v56, v0, v56
		v_lshlrev_b32_e32 v68, 4, v56
		v_add_u32_e32 v68, 0x10000, v68
		v_xor_b32_e32 v56, 1, v56
		v_lshlrev_b32_e32 v56, 4, v56
		v_add_u32_e32 v56, 0x10000, v56
		v_lshrrev_b32_e32 v69, 3, v66
		v_and_b32_e32 v69, 3, v69
		v_lshlrev_b32_e32 v70, 13, v69
		v_add_u32_e32 v70, 0x10000, v70
		v_lshlrev_b32_e32 v11, 1, v11
		v_lshrrev_b32_e32 v71, 5, v66
		v_and_b32_e32 v66, 7, v66
		v_lshlrev_b32_e32 v66, 5, v66
		v_add3_u32 v72, v11, v71, v66
		v_and_b32_e32 v73, 1, v0
		v_lshlrev_b32_e32 v73, 1, v73
		v_bitop3_b32 v69, v73, v69, 1 bitop3:0x78
		v_xor_b32_e32 v72, v72, v69
		v_lshl_add_u32 v72, v72, 4, v70
		v_add_u32_e32 v73, 16, v11
		v_add3_u32 v73, v73, v71, v66
		v_xor_b32_e32 v73, v73, v69
		v_lshl_add_u32 v73, v73, 4, v70
		v_add_u32_e32 v74, 0x100, v11
		v_add3_u32 v74, v74, v71, v66
		v_xor_b32_e32 v74, v74, v69
		v_lshl_add_u32 v74, v74, 4, v70
		v_add_u32_e32 v11, 0x110, v11
		v_add3_u32 v11, v11, v71, v66
		v_xor_b32_e32 v11, v11, v69
		v_lshl_add_u32 v11, v11, 4, v70
		v_mul_lo_u32 v8, s19, v8
		v_and_b32_e32 v66, 31, v0
		s_cselect_b32 s21, 1, 0
		s_mul_i32 s36, 0xa0, s19
		s_add_i32 s57, s36, 8
		s_add_i32 s58, s36, 10
		s_add_i32 s59, s36, 12
		s_add_i32 s36, s36, 14
		s_mul_i32 s60, 0xc0, s19
		s_add_i32 s61, s60, 2
		s_add_i32 s60, s60, 4
		s_mul_i32 s62, 0xc0, s19
		s_mul_i32 s63, 0xe0, s19
		s_cmp_lt_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s3, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s16, s3
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s16, s3, 7
		s_lshr_b32 s64, s3, 3
		s_lshr_b32 s65, s64, 2
		s_mul_i32 s65, s65, 32
		s_mul_i32 s16, s16, 4
		s_add_i32 s16, s65, s16
		s_and_b32 s64, s64, 3
		s_add_i32 s16, s16, s64
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s64, 1, 0
		s_xor_b32 s65, s16, -1
		s_add_i32 s65, s65, 1
		s_cmp_lg_u32 s64, 0
		s_cselect_b32 s64, s65, s16
		s_cselect_b32 s65, 1, 0
		s_cmp_lg_u32 s37, 0
		s_cselect_b32 s66, s38, s1
		v_mov_b32_e32 v69, s66
		v_cvt_f32_u32_e32 v69, v69
		v_rcp_iflag_f32_e32 v69, v69
		s_barrier
		v_mul_f32_e32 v69, v12, v69
		v_cvt_u32_f32_e32 v69, v69
		s_nop 0
		v_readfirstlane_b32 s67, v69
		s_xor_b32 s68, s66, -1
		s_add_i32 s68, s68, 1
		s_mul_i32 s69, s68, s67
		s_mul_hi_u32 s69, s67, s69
		s_add_i32 s67, s67, s69
		s_mul_hi_u32 s67, s64, s67
		s_mul_i32 s69, s67, s66
		s_xor_b32 s69, s69, -1
		s_add_i32 s69, s69, 1
		s_add_i32 s64, s64, s69
		s_cmp_ge_u32 s64, s66
		s_cselect_b32 s69, 1, 0
		s_add_i32 s70, s67, 1
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s67, s70, s67
		s_cselect_b32 s69, 1, 0
		s_add_i32 s70, s64, s68
		s_cmp_lg_u32 s69, 0
		s_cselect_b32 s64, s70, s64
		s_cmp_ge_u32 s64, s66
		s_cselect_b32 s66, 1, 0
		s_add_i32 s69, s67, 1
		s_cmp_lg_u32 s66, 0
		s_cselect_b32 s66, s69, s67
		s_cselect_b32 s67, 1, 0
		s_xor_b32 s16, s16, s1
		s_xor_b32 s69, s66, -1
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s16, s69, s66
		s_mul_i32 s66, s16, 4
		s_xor_b32 s66, s66, -1
		s_add_i32 s66, s66, 1
		s_add_i32 s66, s0, s66
		s_cmp_lt_i32 s66, 4
		s_cselect_b32 s66, s66, 4
		s_add_i32 s68, s64, s68
		s_cmp_lg_u32 s67, 0
		s_cselect_b32 s64, s68, s64
		s_xor_b32 s67, s64, -1
		s_add_i32 s67, s67, 1
		s_cmp_lg_u32 s65, 0
		s_cselect_b32 s64, s67, s64
		s_cmp_lt_i32 s64, 0
		s_cselect_b32 s65, 1, 0
		s_xor_b32 s67, s64, -1
		s_add_i32 s67, s67, 1
		s_cmp_lg_u32 s65, 0
		s_cselect_b32 s65, s67, s64
		s_cselect_b32 s67, 1, 0
		s_xor_b32 s68, s66, -1
		s_add_i32 s68, s68, 1
		s_cmp_lt_i32 s66, 0
		s_cselect_b32 s68, s68, s66
		v_mov_b32_e32 v69, s68
		v_cvt_f32_u32_e32 v69, v69
		v_rcp_iflag_f32_e32 v69, v69
		s_nop 0
		v_mul_f32_e32 v69, v12, v69
		v_cvt_u32_f32_e32 v69, v69
		s_nop 0
		v_readfirstlane_b32 s69, v69
		s_xor_b32 s70, s68, -1
		s_add_i32 s70, s70, 1
		s_mul_i32 s71, s70, s69
		s_mul_hi_u32 s71, s69, s71
		s_add_i32 s69, s69, s71
		s_mul_hi_u32 s69, s65, s69
		s_mul_i32 s71, s69, s68
		s_xor_b32 s71, s71, -1
		s_add_i32 s71, s71, 1
		s_add_i32 s65, s65, s71
		s_cmp_ge_u32 s65, s68
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s65, s70
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s65, s72, s65
		s_cselect_b32 s71, 1, 0
		s_cmp_ge_u32 s65, s68
		s_cselect_b32 s68, 1, 0
		s_add_i32 s70, s65, s70
		s_cmp_lg_u32 s68, 0
		s_cselect_b32 s65, s70, s65
		s_cselect_b32 s68, 1, 0
		s_xor_b32 s70, s65, -1
		s_add_i32 s70, s70, 1
		s_cmp_lg_u32 s67, 0
		s_cselect_b32 s65, s70, s65
		s_mul_i32 s67, s16, 4
		s_add_i32 s67, s67, s65
		s_add_i32 s70, s69, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s69, s70, s69
		s_add_i32 s70, s69, 1
		s_cmp_lg_u32 s68, 0
		s_cselect_b32 s68, s70, s69
		s_xor_b32 s64, s64, s66
		s_xor_b32 s66, s68, -1
		s_add_i32 s66, s66, 1
		s_cmp_lt_i32 s64, 0
		s_cselect_b32 s64, s66, s68
		s_mul_i32 s66, s67, 0x80
		v_add_u32_e32 v69, s66, v5
		v_cmp_lt_i32_e64 vcc, v69, s2
		v_xad_u32 v70, v69, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_mul_hi_u32 v70, v69, v34
		v_mul_lo_u32 v70, v70, v16
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v69, 1, v70, v69
		v_add_u32_e32 v70, v69, v35
		v_cmp_ge_u32_e64 vcc, v69, v16
		v_add_u32_e32 v71, s66, v17
		v_add_u32_e32 v75, s66, v18
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_add_u32_e32 v70, v69, v35
		v_cmp_ge_u32_e64 vcc, v69, v16
		v_add_u32_e32 v76, s66, v19
		v_add_u32_e32 v77, s66, v20
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_xad_u32 v70, v69, -1, 1
		v_cndmask_b32_e64 v69, v69, v70, s[68:69]
		v_cmp_lt_i32_e64 vcc, v71, s2
		v_xad_u32 v70, v71, -1, 1
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v70, v71, v70, vcc
		v_mul_hi_u32 v71, v70, v34
		v_mul_lo_u32 v71, v71, v16
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v70, 1, v71, v70
		v_add_u32_e32 v71, v70, v35
		v_cmp_ge_u32_e64 vcc, v70, v16
		v_add_u32_e32 v78, s66, v21
		v_add_u32_e32 v79, s66, v22
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_add_u32_e32 v71, v70, v35
		v_cmp_ge_u32_e64 vcc, v70, v16
		v_add_u32_e32 v80, s66, v23
		v_add_u32_e32 v81, s66, v24
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_xad_u32 v71, v70, -1, 1
		v_cndmask_b32_e64 v70, v70, v71, s[68:69]
		v_cmp_lt_i32_e64 vcc, v75, s2
		s_mov_b64 s[68:69], vcc
		v_xad_u32 v71, v75, -1, 1
		v_cndmask_b32_e32 v71, v75, v71, vcc
		v_mul_hi_u32 v75, v71, v34
		v_mul_lo_u32 v75, v75, v16
		v_xor_b32_e32 v75, -1, v75
		v_add3_u32 v71, 1, v75, v71
		v_add_u32_e32 v75, v71, v35
		v_cmp_ge_u32_e64 vcc, v71, v16
		v_add_u32_e32 v82, s66, v39
		v_xad_u32 v83, v76, -1, 1
		v_cndmask_b32_e32 v71, v71, v75, vcc
		v_cmp_ge_u32_e64 vcc, v71, v16
		v_add_u32_e32 v75, v71, v35
		v_add_u32_e32 v84, s66, v38
		v_cndmask_b32_e32 v71, v71, v75, vcc
		v_xad_u32 v75, v71, -1, 1
		v_cndmask_b32_e64 v71, v71, v75, s[68:69]
		v_cmp_lt_i32_e64 vcc, v76, s2
		v_mul_lo_u32 v71, s18, v71
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v75, v76, v83, vcc
		v_mul_hi_u32 v76, v75, v34
		v_mul_lo_u32 v76, v76, v16
		v_xor_b32_e32 v76, -1, v76
		v_add3_u32 v75, 1, v76, v75
		v_cmp_ge_u32_e64 vcc, v75, v16
		v_add_u32_e32 v76, v75, v35
		v_xad_u32 v83, v77, -1, 1
		v_cndmask_b32_e32 v75, v75, v76, vcc
		v_cmp_ge_u32_e64 vcc, v75, v16
		v_add_u32_e32 v76, v75, v35
		v_add_u32_e32 v85, s66, v14
		v_cndmask_b32_e32 v75, v75, v76, vcc
		v_xad_u32 v76, v75, -1, 1
		v_cndmask_b32_e64 v75, v75, v76, s[68:69]
		v_cmp_lt_i32_e64 vcc, v77, s2
		v_mul_lo_u32 v75, s18, v75
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v76, v77, v83, vcc
		v_mul_hi_u32 v77, v76, v34
		v_mul_lo_u32 v77, v77, v16
		v_xor_b32_e32 v77, -1, v77
		v_add3_u32 v76, 1, v77, v76
		v_cmp_ge_u32_e64 vcc, v76, v16
		v_add_u32_e32 v77, v76, v35
		v_xad_u32 v83, v78, -1, 1
		v_cndmask_b32_e32 v76, v76, v77, vcc
		v_cmp_ge_u32_e64 vcc, v76, v16
		v_add_u32_e32 v77, v76, v35
		v_xad_u32 v86, v79, -1, 1
		v_cndmask_b32_e32 v76, v76, v77, vcc
		v_xad_u32 v77, v76, -1, 1
		v_cndmask_b32_e64 v76, v76, v77, s[68:69]
		v_cmp_lt_i32_e64 vcc, v78, s2
		v_mul_lo_u32 v76, s18, v76
		s_mov_b64 s[68:69], vcc
		v_cndmask_b32_e32 v77, v78, v83, vcc
		v_mul_hi_u32 v78, v77, v34
		v_mul_lo_u32 v78, v78, v16
		v_xor_b32_e32 v78, -1, v78
		v_add3_u32 v77, 1, v78, v77
		v_cmp_ge_u32_e64 vcc, v77, v16
		v_add_u32_e32 v78, v77, v35
		v_xad_u32 v83, v80, -1, 1
		v_cndmask_b32_e32 v77, v77, v78, vcc
		v_cmp_ge_u32_e64 vcc, v77, v16
		v_add_u32_e32 v78, v77, v35
		v_xad_u32 v87, v81, -1, 1
		v_cndmask_b32_e32 v77, v77, v78, vcc
		v_xad_u32 v78, v77, -1, 1
		v_cmp_lt_i32_e64 vcc, v79, s2
		s_lshl_b32 s67, s15, 1
		v_mul_lo_u32 v88, s67, v69
		s_mov_b64 s[70:71], vcc
		v_cndmask_b32_e32 v79, v79, v86, vcc
		v_mul_hi_u32 v86, v79, v34
		v_mul_lo_u32 v86, v86, v16
		v_xor_b32_e32 v86, -1, v86
		v_add3_u32 v79, 1, v86, v79
		v_cmp_ge_u32_e64 vcc, v79, v16
		v_add_u32_e32 v86, v79, v35
		v_mul_lo_u32 v69, s15, v69
		v_cndmask_b32_e32 v79, v79, v86, vcc
		v_cmp_ge_u32_e64 vcc, v79, v16
		v_add_u32_e32 v86, v79, v35
		v_add_lshl_u32 v89, v52, v69, 1
		v_cndmask_b32_e32 v79, v79, v86, vcc
		v_xad_u32 v86, v79, -1, 1
		v_cmp_lt_i32_e64 vcc, v80, s2
		v_cndmask_b32_e64 v89, v53, v89, s[24:25]
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e32 v80, v80, v83, vcc
		v_mul_hi_u32 v83, v80, v34
		v_mul_lo_u32 v83, v83, v16
		v_xor_b32_e32 v83, -1, v83
		v_add3_u32 v80, 1, v83, v80
		v_cmp_ge_u32_e64 vcc, v80, v16
		v_add_u32_e32 v83, v80, v35
		v_add_lshl_u32 v90, v60, v69, 1
		v_cndmask_b32_e32 v80, v80, v83, vcc
		v_cmp_ge_u32_e64 vcc, v80, v16
		v_add_u32_e32 v83, v80, v35
		v_cndmask_b32_e64 v90, v53, v90, s[28:29]
		v_cndmask_b32_e32 v80, v80, v83, vcc
		v_xad_u32 v83, v80, -1, 1
		v_cmp_lt_i32_e64 vcc, v81, s2
		v_add_lshl_u32 v69, v64, v69, 1
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e32 v81, v81, v87, vcc
		v_mul_hi_u32 v87, v81, v34
		v_mul_lo_u32 v87, v87, v16
		v_xor_b32_e32 v87, -1, v87
		v_add3_u32 v81, 1, v87, v81
		v_cmp_ge_u32_e64 vcc, v81, v16
		v_add_u32_e32 v87, v81, v35
		v_cndmask_b32_e64 v69, v53, v69, s[32:33]
		v_cndmask_b32_e32 v81, v81, v87, vcc
		v_cmp_ge_u32_e64 vcc, v81, v16
		v_add_u32_e32 v87, v81, v35
		s_nop 0
		v_cndmask_b32_e32 v81, v81, v87, vcc
		v_xad_u32 v87, v81, -1, 1
		s_mul_i32 s67, s64, 0x100
		v_add_u32_e32 v91, s67, v26
		v_cmp_lt_i32_e64 vcc, v91, s2
		v_xad_u32 v92, v91, -1, 1
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e32 v91, v91, v92, vcc
		v_mul_hi_u32 v92, v91, v49
		v_mul_lo_u32 v92, v92, v48
		v_xor_b32_e32 v92, -1, v92
		v_add3_u32 v91, 1, v92, v91
		v_add_u32_e32 v92, v91, v50
		v_cmp_ge_u32_e64 vcc, v91, v48
		v_add_u32_e32 v93, s67, v25
		v_add_u32_e32 v94, s67, v27
		v_cndmask_b32_e32 v91, v91, v92, vcc
		v_add_u32_e32 v92, v91, v50
		v_cmp_ge_u32_e64 vcc, v91, v48
		v_add_u32_e32 v95, s67, v28
		v_xad_u32 v96, v93, -1, 1
		v_cndmask_b32_e32 v91, v91, v92, vcc
		v_xad_u32 v92, v91, -1, 1
		v_cndmask_b32_e64 v91, v91, v92, s[76:77]
		v_cmp_lt_i32_e64 vcc, v93, s2
		v_add_u32_e32 v92, s67, v29
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e32 v93, v93, v96, vcc
		v_mul_hi_u32 v96, v93, v49
		v_mul_lo_u32 v96, v96, v48
		v_xor_b32_e32 v96, -1, v96
		v_add3_u32 v93, 1, v96, v93
		v_add_u32_e32 v96, v93, v50
		v_cmp_ge_u32_e64 vcc, v93, v48
		v_add_u32_e32 v97, s67, v30
		v_add_u32_e32 v98, s67, v31
		v_cndmask_b32_e32 v93, v93, v96, vcc
		v_add_u32_e32 v96, v93, v50
		v_cmp_ge_u32_e64 vcc, v93, v48
		v_add_u32_e32 v99, s67, v32
		v_xad_u32 v100, v94, -1, 1
		v_cndmask_b32_e32 v93, v93, v96, vcc
		v_xad_u32 v96, v93, -1, 1
		v_cndmask_b32_e64 v93, v93, v96, s[76:77]
		v_cmp_lt_i32_e64 vcc, v94, s2
		v_xad_u32 v96, v95, -1, 1
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e32 v94, v94, v100, vcc
		v_mul_hi_u32 v100, v94, v49
		v_mul_lo_u32 v100, v100, v48
		v_xor_b32_e32 v100, -1, v100
		v_add3_u32 v94, 1, v100, v94
		v_add_u32_e32 v100, v94, v50
		v_cmp_ge_u32_e64 vcc, v94, v48
		v_xad_u32 v101, v92, -1, 1
		v_lshlrev_b32_e32 v102, 1, v93
		v_cndmask_b32_e32 v94, v94, v100, vcc
		v_cmp_ge_u32_e64 vcc, v94, v48
		v_add_u32_e32 v100, v94, v50
		v_xad_u32 v103, v97, -1, 1
		v_cndmask_b32_e32 v94, v94, v100, vcc
		v_xad_u32 v100, v94, -1, 1
		v_cndmask_b32_e64 v94, v94, v100, s[76:77]
		v_cmp_lt_i32_e64 vcc, v95, s2
		v_lshlrev_b32_e32 v100, 1, v94
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e32 v95, v95, v96, vcc
		v_mul_hi_u32 v96, v95, v49
		v_mul_lo_u32 v96, v96, v48
		v_xor_b32_e32 v96, -1, v96
		v_add3_u32 v95, 1, v96, v95
		v_cmp_ge_u32_e64 vcc, v95, v48
		v_add_u32_e32 v96, v95, v50
		v_xad_u32 v104, v98, -1, 1
		v_cndmask_b32_e32 v95, v95, v96, vcc
		v_cmp_ge_u32_e64 vcc, v95, v48
		v_add_u32_e32 v96, v95, v50
		v_lshlrev_b32_e32 v105, 1, v91
		v_cndmask_b32_e32 v95, v95, v96, vcc
		v_xad_u32 v96, v95, -1, 1
		v_cmp_lt_i32_e64 vcc, v92, s2
		v_xad_u32 v106, v99, -1, 1
		s_mov_b64 s[78:79], vcc
		v_cndmask_b32_e32 v92, v92, v101, vcc
		v_mul_hi_u32 v101, v92, v49
		v_mul_lo_u32 v101, v101, v48
		v_xor_b32_e32 v101, -1, v101
		v_add3_u32 v92, 1, v101, v92
		v_cmp_ge_u32_e64 vcc, v92, v48
		v_add_u32_e32 v101, v92, v50
		v_add_u32_e32 v107, v58, v105
		v_cndmask_b32_e32 v92, v92, v101, vcc
		v_cmp_ge_u32_e64 vcc, v92, v48
		v_add_u32_e32 v101, v92, v50
		v_cndmask_b32_e64 v107, v53, v107, s[26:27]
		v_cndmask_b32_e32 v92, v92, v101, vcc
		v_xad_u32 v101, v92, -1, 1
		v_cmp_lt_i32_e64 vcc, v97, s2
		v_add_u32_e32 v108, v59, v105
		s_mov_b64 s[80:81], vcc
		v_cndmask_b32_e32 v97, v97, v103, vcc
		v_mul_hi_u32 v103, v97, v49
		v_mul_lo_u32 v103, v103, v48
		v_xor_b32_e32 v103, -1, v103
		v_add3_u32 v97, 1, v103, v97
		v_cmp_ge_u32_e64 vcc, v97, v48
		v_add_u32_e32 v103, v97, v50
		v_cndmask_b32_e64 v108, v53, v108, s[26:27]
		v_cndmask_b32_e32 v97, v97, v103, vcc
		v_cmp_ge_u32_e64 vcc, v97, v48
		v_add_u32_e32 v103, v97, v50
		v_add_u32_e32 v109, v61, v105
		v_cndmask_b32_e32 v97, v97, v103, vcc
		v_xad_u32 v103, v97, -1, 1
		v_cmp_lt_i32_e64 vcc, v98, s2
		v_cndmask_b32_e64 v109, v53, v109, s[30:31]
		s_mov_b64 s[82:83], vcc
		v_cndmask_b32_e32 v98, v98, v104, vcc
		v_mul_hi_u32 v104, v98, v49
		v_mul_lo_u32 v104, v104, v48
		v_xor_b32_e32 v104, -1, v104
		v_add3_u32 v98, 1, v104, v98
		v_cmp_ge_u32_e64 vcc, v98, v48
		v_add_u32_e32 v104, v98, v50
		v_add_u32_e32 v110, v63, v105
		v_cndmask_b32_e32 v98, v98, v104, vcc
		v_cmp_ge_u32_e64 vcc, v98, v48
		v_add_u32_e32 v104, v98, v50
		v_cndmask_b32_e64 v110, v53, v110, s[30:31]
		v_cndmask_b32_e32 v98, v98, v104, vcc
		v_xad_u32 v104, v98, -1, 1
		v_cmp_lt_i32_e64 vcc, v99, s2
		v_add_u32_e32 v111, v65, v105
		s_mov_b64 s[84:85], vcc
		v_cndmask_b32_e32 v99, v99, v106, vcc
		v_mul_hi_u32 v106, v99, v49
		v_mul_lo_u32 v106, v106, v48
		v_xor_b32_e32 v106, -1, v106
		v_add3_u32 v99, 1, v106, v99
		v_cmp_ge_u32_e64 vcc, v99, v48
		v_add_u32_e32 v106, v99, v50
		v_cndmask_b32_e64 v111, v53, v111, s[34:35]
		v_cndmask_b32_e32 v99, v99, v106, vcc
		v_cmp_ge_u32_e64 vcc, v99, v48
		v_add_u32_e32 v106, v99, v50
		v_add_u32_e32 v112, v62, v105
		v_cndmask_b32_e32 v99, v99, v106, vcc
		v_xad_u32 v106, v99, -1, 1
		v_readfirstlane_b32 s86, v0
		s_lshr_b32 s86, s86, 6
		s_mul_i32 s86, 0x420, s86
		s_mov_b32 m0, s86
		v_mul_lo_u32 v70, s18, v70
		buffer_load_dwordx4 v89, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v77, v77, v78, s[68:69]
		s_add_i32 m0, m0, 0x62e0
		v_cndmask_b32_e64 v78, v79, v86, s[70:71]
		buffer_load_dwordx4 v107, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v79, v80, v83, s[72:73]
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v80, v81, v87, s[74:75]
		buffer_load_dwordx4 v108, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v81, v95, v96, s[76:77]
		s_add_i32 m0, m0, 0xffff9d20
		v_cndmask_b32_e64 v83, v92, v101, s[78:79]
		buffer_load_dwordx4 v90, s[40:43], 0 offen lds
		v_cndmask_b32_e64 v86, v97, v103, s[80:81]
		s_add_i32 m0, m0, 0x83e0
		v_cndmask_b32_e64 v87, v98, v104, s[82:83]
		buffer_load_dwordx4 v109, s[44:47], 0 offen lds
		v_cndmask_b32_e64 v89, v99, v106, s[84:85]
		s_add_i32 m0, m0, 0x2100
		v_cndmask_b32_e64 v90, v53, v112, s[34:35]
		buffer_load_dwordx4 v110, s[44:47], 0 offen lds
		v_mov_b64_e32 v[98:99], 0
		s_add_i32 m0, m0, 0xffff7c20
		v_mov_b64_e32 v[96:97], 0
		buffer_load_dwordx4 v69, s[40:43], 0 offen lds
		v_mov_b64_e32 v[114:115], 0
		s_add_i32 m0, m0, 0xa4e0
		v_mov_b64_e32 v[112:113], 0
		buffer_load_dwordx4 v111, s[44:47], 0 offen lds
		v_mov_b64_e32 v[110:111], 0
		s_add_i32 m0, m0, 0x2100
		v_mov_b64_e32 v[108:109], 0
		buffer_load_dwordx4 v90, s[44:47], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[116:119], v15
		ds_read_b128 v[120:123], v15 offset:2112
		ds_read_b128 v[124:127], v15 offset:4224
		ds_read_b128 v[128:131], v15 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[132:133], v1 offset:25312
		ds_read_b64_tr_b16 v[134:135], v1 offset:33760
		ds_read_b64_tr_b16 v[136:137], v1 offset:25440
		ds_read_b64_tr_b16 v[138:139], v1 offset:33888
		ds_read_b64_tr_b16 v[140:141], v1 offset:25568
		ds_read_b64_tr_b16 v[142:143], v1 offset:34016
		ds_read_b64_tr_b16 v[144:145], v1 offset:25696
		ds_read_b64_tr_b16 v[146:147], v1 offset:34144
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[100:101], s[10:11]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_setprio 0
		v_add_u32_e32 v69, v3, v88
		s_mov_b32 s68, 0
		s_mov_b32 s69, 0
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
		s_cmp_lg_u32 s21, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		v_mfma_f32_16x16x32_f16 v[108:111], v[132:135], v[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[136:139], v[116:119], v[112:115]
		s_lshl_b32 s70, s69, 6
		v_mfma_f32_16x16x32_f16 v[96:99], v[140:143], v[116:119], v[96:99]
		s_cmp_ge_u32 s68, 2
		v_mfma_f32_16x16x32_f16 v[148:151], v[144:147], v[116:119], v[148:151]
		s_cselect_b32 s71, 1, 0
		s_add_i32 s72, s68, -2
		v_mfma_f32_16x16x32_f16 v[164:167], v[144:147], v[120:123], v[164:167]
		s_add_i32 s73, s68, 1
		v_mfma_f32_16x16x32_f16 v[152:155], v[132:135], v[120:123], v[152:155]
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s73
		v_mfma_f32_16x16x32_f16 v[156:159], v[136:139], v[120:123], v[156:159]
		s_add_i32 s72, s69, 3
		v_mfma_f32_16x16x32_f16 v[160:163], v[140:143], v[120:123], v[160:163]
		s_mul_i32 s72, s72, 32
		v_mfma_f32_16x16x32_f16 v[176:179], v[140:143], v[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[168:171], v[132:135], v[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[136:139], v[124:127], v[172:175]
		v_mfma_f32_16x16x32_f16 v[180:183], v[144:147], v[124:127], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[144:147], v[128:131], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[132:135], v[128:131], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[136:139], v[128:131], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[140:143], v[128:131], v[192:195]
		s_setprio 1
		s_barrier
		s_xor_b32 s72, s72, -1
		s_add_i32 s72, s72, 1
		s_add_i32 s72, s14, s72
		v_cmp_lt_i32_e64 vcc, v33, s72
		s_mul_i32 s73, -1, s70
		s_add_i32 s73, s73, 0x80000000
		v_mov_b32_e32 v88, s73
		v_cndmask_b32_e32 v88, v88, v69, vcc
		s_mul_i32 s73, 0x2100, s68
		v_cmp_lt_i32_e64 vcc, v10, s72
		s_add_i32 m0, s86, s73
		v_cmp_lt_i32_e64 s[74:75], v37, s72
		buffer_load_dwordx4 v88, s[40:43], s70 offen lds
		s_mul_i32 s70, s17, s69
		s_lshl_b32 s70, s70, 6
		s_add_i32 s72, s39, s70
		v_add3_u32 v88, s72, v54, v55
		v_add3_u32 v88, v88, v57, v105
		s_mul_i32 s68, 0x4200, s68
		s_add_i32 s68, s86, s68
		s_add_i32 m0, s68, 0x62e0
		v_cndmask_b32_e64 v88, v53, v88, s[74:75]
		buffer_load_dwordx4 v88, s[44:47], 0 offen lds
		s_add_i32 s68, s56, s70
		v_add3_u32 v88, s68, v54, v55
		v_add3_u32 v88, v88, v57, v105
		v_cndmask_b32_e32 v88, v53, v88, vcc
		s_mul_i32 s68, 0x4200, s71
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v90, s68, v1
		buffer_load_dwordx4 v88, s[44:47], 0 offen lds
		s_barrier
		s_mul_i32 s68, 0x2100, s71
		v_add_u32_e32 v88, s68, v15
		s_waitcnt vmcnt(3)
		ds_read_b128 v[116:119], v88
		ds_read_b128 v[120:123], v88 offset:2112
		ds_read_b128 v[124:127], v88 offset:4224
		ds_read_b128 v[128:131], v88 offset:6336
		ds_read_b64_tr_b16 v[132:133], v90 offset:25312
		ds_read_b64_tr_b16 v[134:135], v90 offset:33760
		ds_read_b64_tr_b16 v[136:137], v90 offset:25440
		ds_read_b64_tr_b16 v[138:139], v90 offset:33888
		ds_read_b64_tr_b16 v[140:141], v90 offset:25568
		ds_read_b64_tr_b16 v[142:143], v90 offset:34016
		ds_read_b64_tr_b16 v[144:145], v90 offset:25696
		ds_read_b64_tr_b16 v[146:147], v90 offset:34144
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s69, s69, 1
		s_cmp_lt_i32 s69, s23
		s_mov_b32 s68, s71
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_setprio 0
		s_and_saveexec_b64 s[100:101], s[8:9]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_barrier
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		v_cmp_lt_i32_e64 s[68:69], v85, s12
		v_cmp_lt_i32_e64 s[70:71], v84, s12
		v_cmp_lt_i32_e64 s[72:73], v82, s12
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_ushort v69, v105, s[48:51], 0 offen
		buffer_load_ushort v82, v102, s[48:51], 0 offen
		buffer_load_ushort v84, v100, s[48:51], 0 offen
		v_lshlrev_b32_e32 v85, 1, v81
		buffer_load_ushort v88, v85, s[48:51], 0 offen
		v_lshlrev_b32_e32 v85, 1, v83
		buffer_load_ushort v90, v85, s[48:51], 0 offen
		v_lshlrev_b32_e32 v85, 1, v86
		buffer_load_ushort v92, v85, s[48:51], 0 offen
		v_lshlrev_b32_e32 v85, 1, v87
		buffer_load_ushort v95, v85, s[48:51], 0 offen
		v_lshlrev_b32_e32 v85, 1, v89
		buffer_load_ushort v100, v85, s[48:51], 0 offen
		v_add_lshl_u32 v85, v91, v70, 1
		buffer_load_ushort v101, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v93, v70, 1
		buffer_load_ushort v102, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v94, v70, 1
		buffer_load_ushort v103, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v81, v70, 1
		buffer_load_ushort v104, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v83, v70, 1
		buffer_load_ushort v105, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v86, v70, 1
		buffer_load_ushort v106, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v85, v87, v70, 1
		buffer_load_ushort v107, v85, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v70, 1
		buffer_load_ushort v85, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v91, v71, 1
		buffer_load_ushort v200, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v93, v71, 1
		buffer_load_ushort v201, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v94, v71, 1
		buffer_load_ushort v202, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v81, v71, 1
		buffer_load_ushort v203, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v83, v71, 1
		buffer_load_ushort v204, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v86, v71, 1
		buffer_load_ushort v205, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v87, v71, 1
		buffer_load_ushort v206, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v71, 1
		buffer_load_ushort v71, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v91, v75, 1
		buffer_load_ushort v207, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v93, v75, 1
		buffer_load_ushort v208, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v94, v75, 1
		buffer_load_ushort v209, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v81, v75, 1
		buffer_load_ushort v210, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v83, v75, 1
		buffer_load_ushort v211, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v86, v75, 1
		buffer_load_ushort v212, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v87, v75, 1
		buffer_load_ushort v213, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v75, 1
		buffer_load_ushort v75, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v91, v76, 1
		buffer_load_ushort v214, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v93, v76, 1
		buffer_load_ushort v215, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v94, v76, 1
		buffer_load_ushort v216, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v81, v76, 1
		buffer_load_ushort v217, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v83, v76, 1
		buffer_load_ushort v218, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v86, v76, 1
		buffer_load_ushort v219, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v87, v76, 1
		buffer_load_ushort v220, v70, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v76, 1
		buffer_load_ushort v76, v70, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v70, s18, v77
		v_add_lshl_u32 v77, v91, v70, 1
		buffer_load_ushort v221, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v93, v70, 1
		buffer_load_ushort v222, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v94, v70, 1
		buffer_load_ushort v223, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v81, v70, 1
		buffer_load_ushort v224, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v83, v70, 1
		buffer_load_ushort v225, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v86, v70, 1
		buffer_load_ushort v226, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v77, v87, v70, 1
		buffer_load_ushort v227, v77, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v70, 1
		buffer_load_ushort v77, v70, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v70, s18, v78
		v_add_lshl_u32 v78, v91, v70, 1
		buffer_load_ushort v228, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v93, v70, 1
		buffer_load_ushort v229, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v94, v70, 1
		buffer_load_ushort v230, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v81, v70, 1
		buffer_load_ushort v231, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v83, v70, 1
		buffer_load_ushort v232, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v86, v70, 1
		buffer_load_ushort v233, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v78, v87, v70, 1
		buffer_load_ushort v234, v78, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v70, 1
		buffer_load_ushort v78, v70, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v70, s18, v79
		v_add_lshl_u32 v79, v91, v70, 1
		buffer_load_ushort v235, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v79, v93, v70, 1
		buffer_load_ushort v236, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v79, v94, v70, 1
		buffer_load_ushort v237, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v79, v81, v70, 1
		buffer_load_ushort v238, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v79, v83, v70, 1
		buffer_load_ushort v239, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v79, v86, v70, 1
		buffer_load_ushort v240, v79, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[108:111], v[132:135], v[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[136:139], v[116:119], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[140:143], v[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[148:151], v[144:147], v[116:119], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[144:147], v[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[132:135], v[120:123], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[136:139], v[120:123], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[140:143], v[120:123], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[140:143], v[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[140:143], v[128:131], v[192:195]
		v_mfma_f32_16x16x32_f16 v[168:171], v[132:135], v[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[132:135], v[128:131], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[136:139], v[124:127], v[172:175]
		v_mfma_f32_16x16x32_f16 v[180:183], v[144:147], v[124:127], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[144:147], v[128:131], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[136:139], v[128:131], v[188:191]
		ds_read_b128 v[116:119], v6
		ds_read_b128 v[120:123], v6 offset:2112
		ds_read_b128 v[124:127], v6 offset:4224
		ds_read_b128 v[128:131], v6 offset:6336
		ds_read_b64_tr_b16 v[132:133], v13 offset:25312
		ds_read_b64_tr_b16 v[134:135], v13 offset:33760
		ds_read_b64_tr_b16 v[136:137], v13 offset:25440
		ds_read_b64_tr_b16 v[138:139], v13 offset:33888
		ds_read_b64_tr_b16 v[140:141], v13 offset:25568
		ds_read_b64_tr_b16 v[142:143], v13 offset:34016
		ds_read_b64_tr_b16 v[144:145], v13 offset:25696
		ds_read_b64_tr_b16 v[146:147], v13 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[108:111], v[132:135], v[116:119], v[108:111]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[136:139], v[116:119], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[140:143], v[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[152:155], v[132:135], v[120:123], v[152:155]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[148:151], v[144:147], v[116:119], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[144:147], v[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[136:139], v[120:123], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[140:143], v[120:123], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[140:143], v[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[140:143], v[128:131], v[192:195]
		v_mfma_f32_16x16x32_f16 v[168:171], v[132:135], v[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[132:135], v[128:131], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[136:139], v[124:127], v[172:175]
		v_mfma_f32_16x16x32_f16 v[180:183], v[144:147], v[124:127], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[144:147], v[128:131], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[136:139], v[128:131], v[188:191]
		ds_read_b128 v[116:119], v51
		ds_read_b128 v[120:123], v51 offset:2112
		ds_read_b128 v[124:127], v51 offset:4224
		ds_read_b128 v[128:131], v51 offset:6336
		ds_read_b64_tr_b16 v[132:133], v67 offset:25312
		ds_read_b64_tr_b16 v[134:135], v67 offset:33760
		ds_read_b64_tr_b16 v[136:137], v67 offset:25440
		ds_read_b64_tr_b16 v[138:139], v67 offset:33888
		ds_read_b64_tr_b16 v[140:141], v67 offset:25568
		ds_read_b64_tr_b16 v[142:143], v67 offset:34016
		ds_read_b64_tr_b16 v[144:145], v67 offset:25696
		ds_read_b64_tr_b16 v[146:147], v67 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[108:111], v[132:135], v[116:119], v[108:111]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[136:139], v[116:119], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[140:143], v[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[152:155], v[132:135], v[120:123], v[152:155]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[148:151], v[144:147], v[116:119], v[148:151]
		s_barrier
		s_nop 2
		ds_write_b128 v68, v[108:111] offset:10432
		ds_write_b128 v56, v[112:115] offset:18624
		ds_write_b128 v68, v[96:99] offset:26816
		s_nop 0
		ds_write_b128 v56, v[148:151] offset:35008
		v_add_lshl_u32 v79, v87, v70, 1
		buffer_load_ushort v96, v79, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v70, v89, v70, 1
		buffer_load_ushort v79, v70, s[4:7], 0 offen sc0 nt
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mul_lo_u32 v70, s18, v80
		v_add_lshl_u32 v80, v91, v70, 1
		buffer_load_ushort v91, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v93, v70, 1
		buffer_load_ushort v93, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v94, v70, 1
		buffer_load_ushort v94, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v81, v70, 1
		buffer_load_ushort v81, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v83, v70, 1
		buffer_load_ushort v83, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v86, v70, 1
		buffer_load_ushort v86, v80, s[4:7], 0 offen sc0 nt
		v_add_lshl_u32 v80, v87, v70, 1
		v_add_lshl_u32 v70, v89, v70, 1
		buffer_load_ushort v87, v80, s[4:7], 0 offen sc0 nt
		buffer_load_ushort v80, v70, s[4:7], 0 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[164:167], v[144:147], v[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[156:159], v[136:139], v[120:123], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[140:143], v[120:123], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[140:143], v[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[140:143], v[128:131], v[192:195]
		v_mfma_f32_16x16x32_f16 v[168:171], v[132:135], v[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[132:135], v[128:131], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[136:139], v[124:127], v[172:175]
		v_mfma_f32_16x16x32_f16 v[180:183], v[144:147], v[124:127], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[144:147], v[128:131], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[136:139], v[128:131], v[188:191]
		ds_read_b128 v[108:111], v72 offset:10432
		ds_read_b128 v[112:115], v73 offset:10432
		ds_read_b128 v[116:119], v74 offset:10432
		ds_read_b128 v[120:123], v11 offset:10432
		s_waitcnt vmcnt(62)
		v_cvt_f32_f16_e32 v98, v69
		v_cvt_f32_f16_e32 v99, v82
		v_cvt_f32_f16_e32 v124, v84
		v_cvt_f32_f16_e32 v125, v88
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v68, v[152:155] offset:10432
		ds_write_b128 v56, v[156:159] offset:18624
		ds_write_b128 v68, v[160:163] offset:26816
		ds_write_b128 v56, v[164:167] offset:35008
		v_cvt_f32_f16_e32 v88, v90
		v_cvt_f32_f16_e32 v89, v92
		v_cvt_f32_f16_e32 v126, v95
		v_cvt_f32_f16_e32 v127, v100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[128:131], v72 offset:10432
		ds_read_b128 v[132:135], v73 offset:10432
		ds_read_b128 v[136:139], v74 offset:10432
		ds_read_b128 v[140:143], v11 offset:10432
		v_cvt_f32_f16_e32 v144, v101
		v_cvt_f32_f16_e32 v145, v102
		s_waitcnt vmcnt(61)
		v_cvt_f32_f16_e32 v100, v103
		s_waitcnt vmcnt(60)
		v_cvt_f32_f16_e32 v101, v104
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v68, v[168:171] offset:10432
		ds_write_b128 v56, v[172:175] offset:18624
		ds_write_b128 v68, v[176:179] offset:26816
		ds_write_b128 v56, v[180:183] offset:35008
		s_waitcnt vmcnt(59)
		v_cvt_f32_f16_e32 v102, v105
		s_waitcnt vmcnt(58)
		v_cvt_f32_f16_e32 v103, v106
		s_waitcnt vmcnt(57)
		v_cvt_f32_f16_e32 v104, v107
		s_waitcnt vmcnt(56)
		v_cvt_f32_f16_e32 v105, v85
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[148:151], v72 offset:10432
		ds_read_b128 v[152:155], v73 offset:10432
		ds_read_b128 v[156:159], v74 offset:10432
		ds_read_b128 v[160:163], v11 offset:10432
		s_waitcnt vmcnt(55)
		v_cvt_f32_f16_e32 v84, v200
		s_waitcnt vmcnt(54)
		v_cvt_f32_f16_e32 v85, v201
		s_waitcnt vmcnt(53)
		v_cvt_f32_f16_e32 v106, v202
		s_waitcnt vmcnt(52)
		v_cvt_f32_f16_e32 v107, v203
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v68, v[184:187] offset:10432
		ds_write_b128 v56, v[188:191] offset:18624
		ds_write_b128 v68, v[192:195] offset:26816
		ds_write_b128 v56, v[196:199] offset:35008
		s_waitcnt vmcnt(51)
		v_cvt_f32_f16_e32 v146, v204
		s_waitcnt vmcnt(50)
		v_cvt_f32_f16_e32 v147, v205
		s_waitcnt vmcnt(49)
		v_cvt_f32_f16_e32 v164, v206
		s_waitcnt vmcnt(48)
		v_cvt_f32_f16_e32 v165, v71
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[168:171], v72 offset:10432
		ds_read_b128 v[172:175], v73 offset:10432
		ds_read_b128 v[176:179], v74 offset:10432
		ds_read_b128 v[180:183], v11 offset:10432
		s_waitcnt vmcnt(47)
		v_cvt_f32_f16_e32 v70, v207
		s_waitcnt vmcnt(46)
		v_cvt_f32_f16_e32 v71, v208
		s_waitcnt vmcnt(45)
		v_cvt_f32_f16_e32 v166, v209
		s_waitcnt vmcnt(44)
		v_cvt_f32_f16_e32 v167, v210
		s_waitcnt vmcnt(43)
		v_cvt_f32_f16_e32 v184, v211
		s_waitcnt vmcnt(42)
		v_cvt_f32_f16_e32 v185, v212
		s_waitcnt vmcnt(41)
		v_cvt_f32_f16_e32 v186, v213
		s_waitcnt vmcnt(40)
		v_cvt_f32_f16_e32 v187, v75
		s_waitcnt vmcnt(39)
		v_cvt_f32_f16_e32 v188, v214
		s_waitcnt vmcnt(38)
		v_cvt_f32_f16_e32 v189, v215
		s_waitcnt vmcnt(37)
		v_cvt_f32_f16_e32 v190, v216
		s_waitcnt vmcnt(36)
		v_cvt_f32_f16_e32 v191, v217
		s_waitcnt vmcnt(35)
		v_cvt_f32_f16_e32 v192, v218
		s_waitcnt vmcnt(34)
		v_cvt_f32_f16_e32 v193, v219
		s_waitcnt vmcnt(33)
		v_cvt_f32_f16_e32 v194, v220
		s_waitcnt vmcnt(32)
		v_cvt_f32_f16_e32 v195, v76
		s_waitcnt vmcnt(31)
		v_cvt_f32_f16_e32 v196, v221
		s_waitcnt vmcnt(30)
		v_cvt_f32_f16_e32 v197, v222
		s_waitcnt vmcnt(29)
		v_cvt_f32_f16_e32 v198, v223
		s_waitcnt vmcnt(28)
		v_cvt_f32_f16_e32 v199, v224
		s_waitcnt vmcnt(27)
		v_cvt_f32_f16_e32 v200, v225
		s_waitcnt vmcnt(26)
		v_cvt_f32_f16_e32 v201, v226
		s_waitcnt vmcnt(25)
		v_cvt_f32_f16_e32 v202, v227
		s_waitcnt vmcnt(24)
		v_cvt_f32_f16_e32 v203, v77
		s_waitcnt vmcnt(23)
		v_cvt_f32_f16_e32 v76, v228
		s_waitcnt vmcnt(22)
		v_cvt_f32_f16_e32 v77, v229
		s_waitcnt vmcnt(21)
		v_cvt_f32_f16_e32 v204, v230
		s_waitcnt vmcnt(20)
		v_cvt_f32_f16_e32 v205, v231
		s_waitcnt vmcnt(19)
		v_cvt_f32_f16_e32 v206, v232
		s_waitcnt vmcnt(18)
		v_cvt_f32_f16_e32 v207, v233
		s_waitcnt vmcnt(17)
		v_cvt_f32_f16_e32 v208, v234
		s_waitcnt vmcnt(16)
		v_cvt_f32_f16_e32 v209, v78
		s_waitcnt vmcnt(15)
		v_cvt_f32_f16_e32 v210, v235
		s_waitcnt vmcnt(14)
		v_cvt_f32_f16_e32 v211, v236
		s_waitcnt vmcnt(13)
		v_cvt_f32_f16_e32 v212, v237
		s_waitcnt vmcnt(12)
		v_cvt_f32_f16_e32 v213, v238
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v214, v239
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v215, v240
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v216, v96
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v217, v79
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v78, v91
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v79, v93
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v90, v94
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v91, v81
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v92, v83
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v93, v86
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v82, v87
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v83, v80
		v_pk_add_f32 v[80:81], v[108:109], v[98:99]
		v_pk_fma_f32 v[86:87], v[80:81], v[144:145], v[80:81]
		v_pk_add_f32 v[80:81], v[110:111], v[124:125]
		v_pk_fma_f32 v[94:95], v[80:81], v[100:101], v[80:81]
		v_pk_add_f32 v[80:81], v[112:113], v[88:89]
		v_pk_fma_f32 v[96:97], v[80:81], v[102:103], v[80:81]
		v_pk_add_f32 v[80:81], v[114:115], v[126:127]
		v_pk_fma_f32 v[100:101], v[80:81], v[104:105], v[80:81]
		v_pk_add_f32 v[80:81], v[116:117], v[98:99]
		v_pk_fma_f32 v[102:103], v[80:81], v[84:85], v[80:81]
		v_pk_add_f32 v[80:81], v[118:119], v[124:125]
		v_pk_fma_f32 v[84:85], v[80:81], v[106:107], v[80:81]
		v_pk_add_f32 v[80:81], v[120:121], v[88:89]
		v_pk_fma_f32 v[104:105], v[80:81], v[146:147], v[80:81]
		v_pk_add_f32 v[80:81], v[122:123], v[126:127]
		v_pk_fma_f32 v[106:107], v[80:81], v[164:165], v[80:81]
		v_pk_add_f32 v[80:81], v[128:129], v[98:99]
		v_pk_fma_f32 v[108:109], v[80:81], v[70:71], v[80:81]
		v_pk_add_f32 v[70:71], v[130:131], v[124:125]
		v_pk_fma_f32 v[80:81], v[70:71], v[166:167], v[70:71]
		v_pk_add_f32 v[70:71], v[132:133], v[88:89]
		v_pk_fma_f32 v[110:111], v[70:71], v[184:185], v[70:71]
		v_pk_add_f32 v[70:71], v[134:135], v[126:127]
		v_pk_fma_f32 v[112:113], v[70:71], v[186:187], v[70:71]
		v_pk_add_f32 v[70:71], v[136:137], v[98:99]
		v_pk_fma_f32 v[114:115], v[70:71], v[188:189], v[70:71]
		v_pk_add_f32 v[70:71], v[138:139], v[124:125]
		v_pk_fma_f32 v[116:117], v[70:71], v[190:191], v[70:71]
		v_pk_add_f32 v[70:71], v[140:141], v[88:89]
		v_pk_fma_f32 v[118:119], v[70:71], v[192:193], v[70:71]
		v_pk_add_f32 v[70:71], v[142:143], v[126:127]
		v_pk_fma_f32 v[120:121], v[70:71], v[194:195], v[70:71]
		v_pk_add_f32 v[70:71], v[148:149], v[98:99]
		v_pk_fma_f32 v[122:123], v[70:71], v[196:197], v[70:71]
		v_pk_add_f32 v[70:71], v[150:151], v[124:125]
		v_pk_fma_f32 v[128:129], v[70:71], v[198:199], v[70:71]
		v_pk_add_f32 v[70:71], v[152:153], v[88:89]
		v_pk_fma_f32 v[130:131], v[70:71], v[200:201], v[70:71]
		v_pk_add_f32 v[70:71], v[154:155], v[126:127]
		v_pk_fma_f32 v[132:133], v[70:71], v[202:203], v[70:71]
		v_pk_add_f32 v[70:71], v[156:157], v[98:99]
		v_pk_fma_f32 v[134:135], v[70:71], v[76:77], v[70:71]
		v_pk_add_f32 v[70:71], v[158:159], v[124:125]
		v_pk_fma_f32 v[76:77], v[70:71], v[204:205], v[70:71]
		v_pk_add_f32 v[70:71], v[160:161], v[88:89]
		v_pk_fma_f32 v[136:137], v[70:71], v[206:207], v[70:71]
		v_pk_add_f32 v[70:71], v[162:163], v[126:127]
		v_pk_fma_f32 v[138:139], v[70:71], v[208:209], v[70:71]
		s_waitcnt lgkmcnt(3)
		v_pk_add_f32 v[70:71], v[168:169], v[98:99]
		s_waitcnt lgkmcnt(1)
		v_pk_add_f32 v[98:99], v[176:177], v[98:99]
		v_pk_fma_f32 v[140:141], v[70:71], v[210:211], v[70:71]
		v_pk_fma_f32 v[70:71], v[98:99], v[78:79], v[98:99]
		v_pk_add_f32 v[78:79], v[170:171], v[124:125]
		v_pk_add_f32 v[98:99], v[178:179], v[124:125]
		v_pk_fma_f32 v[124:125], v[78:79], v[212:213], v[78:79]
		v_pk_fma_f32 v[78:79], v[98:99], v[90:91], v[98:99]
		v_pk_add_f32 v[90:91], v[172:173], v[88:89]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[88:89], v[180:181], v[88:89]
		v_pk_fma_f32 v[98:99], v[90:91], v[214:215], v[90:91]
		v_pk_fma_f32 v[90:91], v[88:89], v[92:93], v[88:89]
		v_pk_add_f32 v[88:89], v[174:175], v[126:127]
		v_pk_add_f32 v[92:93], v[182:183], v[126:127]
		v_pk_fma_f32 v[126:127], v[88:89], v[216:217], v[88:89]
		v_pk_fma_f32 v[88:89], v[92:93], v[82:83], v[92:93]
		v_add_u32_e32 v69, s66, v40
		v_add_u32_e32 v75, s66, v41
		v_cmp_lt_i32_e64 s[74:75], v69, s12
		v_cmp_lt_i32_e64 s[76:77], v75, s12
		v_add_u32_e32 v69, s66, v42
		v_add_u32_e32 v75, s66, v43
		v_cmp_lt_i32_e64 s[78:79], v69, s12
		v_cmp_lt_i32_e64 s[80:81], v75, s12
		v_add_u32_e32 v69, s66, v9
		v_cvt_f16_f32_e64 v75, v86
		v_cmp_lt_i32_e64 s[82:83], v69, s12
		v_add_u32_e32 v69, s67, v4
		v_add_u32_e32 v82, s67, v7
		v_cmp_lt_i32_e64 s[84:85], v69, s13
		v_cmp_lt_i32_e64 s[86:87], v82, s13
		v_add_u32_e32 v69, s67, v36
		v_add_u32_e32 v82, s67, v44
		v_cmp_lt_i32_e64 s[88:89], v69, s13
		v_cmp_lt_i32_e64 s[90:91], v82, s13
		v_add_u32_e32 v69, s67, v45
		v_add_u32_e32 v82, s67, v46
		v_cmp_lt_i32_e64 s[92:93], v69, s13
		v_add_u32_e32 v69, s67, v47
		v_add_u32_e32 v83, s67, v2
		v_cmp_lt_i32_e64 s[66:67], v82, s13
		v_cmp_lt_i32_e64 s[94:95], v69, s13
		v_cmp_lt_i32_e64 s[96:97], v83, s13
		v_cvt_f16_f32_e64 v69, v87
		v_cvt_f16_f32_e64 v82, v94
		v_cvt_f16_f32_e64 v83, v95
		v_cvt_f16_f32_e64 v86, v96
		v_cvt_f16_f32_e64 v87, v97
		v_cvt_f16_f32_e64 v92, v100
		v_cvt_f16_f32_e64 v93, v101
		v_cvt_f16_f32_e64 v94, v102
		v_cvt_f16_f32_e64 v95, v103
		v_cvt_f16_f32_e64 v84, v84
		v_cvt_f16_f32_e64 v85, v85
		v_cvt_f16_f32_e64 v96, v104
		v_cvt_f16_f32_e64 v97, v105
		v_cvt_f16_f32_e64 v100, v106
		v_cvt_f16_f32_e64 v101, v107
		v_cvt_f16_f32_e64 v102, v108
		v_cvt_f16_f32_e64 v103, v109
		v_cvt_f16_f32_e64 v80, v80
		v_cvt_f16_f32_e64 v81, v81
		v_cvt_f16_f32_e64 v104, v110
		v_cvt_f16_f32_e64 v105, v111
		v_cvt_f16_f32_e64 v106, v112
		v_cvt_f16_f32_e64 v107, v113
		v_cvt_f16_f32_e64 v108, v114
		v_cvt_f16_f32_e64 v109, v115
		v_cvt_f16_f32_e64 v110, v116
		v_cvt_f16_f32_e64 v111, v117
		v_cvt_f16_f32_e64 v112, v118
		v_cvt_f16_f32_e64 v113, v119
		v_cvt_f16_f32_e64 v114, v120
		v_cvt_f16_f32_e64 v115, v121
		v_cvt_f16_f32_e64 v116, v122
		v_cvt_f16_f32_e64 v117, v123
		v_cvt_f16_f32_e64 v118, v128
		v_cvt_f16_f32_e64 v119, v129
		v_cvt_f16_f32_e64 v120, v130
		v_cvt_f16_f32_e64 v121, v131
		v_cvt_f16_f32_e64 v122, v132
		v_cvt_f16_f32_e64 v123, v133
		v_cvt_f16_f32_e64 v128, v134
		v_cvt_f16_f32_e64 v129, v135
		v_cvt_f16_f32_e64 v76, v76
		v_cvt_f16_f32_e64 v77, v77
		v_cvt_f16_f32_e64 v130, v136
		v_cvt_f16_f32_e64 v131, v137
		v_cvt_f16_f32_e64 v132, v138
		v_cvt_f16_f32_e64 v133, v139
		v_cvt_f16_f32_e64 v134, v140
		v_cvt_f16_f32_e64 v135, v141
		v_cvt_f16_f32_e64 v124, v124
		v_cvt_f16_f32_e64 v125, v125
		v_cvt_f16_f32_e64 v98, v98
		v_cvt_f16_f32_e64 v99, v99
		v_cvt_f16_f32_e64 v126, v126
		v_cvt_f16_f32_e64 v127, v127
		v_cvt_f16_f32_e64 v70, v70
		v_cvt_f16_f32_e64 v71, v71
		v_cvt_f16_f32_e64 v78, v78
		v_cvt_f16_f32_e64 v79, v79
		v_cvt_f16_f32_e64 v90, v90
		v_cvt_f16_f32_e64 v91, v91
		v_cvt_f16_f32_e64 v88, v88
		v_cvt_f16_f32_e64 v89, v89
		s_lshl_b32 s64, s64, 9
		s_mul_i32 s16, s19, s16
		s_lshl_b32 s16, s16, 10
		s_add_i32 s98, s64, s16
		s_mul_i32 s65, s19, s65
		s_lshl_b32 s65, s65, 8
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v136, v8, 1, s98
		v_lshl_add_u32 v136, v66, 4, v136
		s_and_b64 s[98:99], s[68:69], s[84:85]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_2
		buffer_store_short v75, v136, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_2:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 2
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v75, v8, 1, s98
		v_lshl_add_u32 v75, v66, 4, v75
		s_and_b64 s[98:99], s[68:69], s[86:87]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_3
		buffer_store_short v69, v75, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_3:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 4
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[98:99], s[68:69], s[88:89]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_4
		buffer_store_short v82, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_4:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 6
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[98:99], s[68:69], s[90:91]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_5
		buffer_store_short v83, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_5:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 8
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[98:99], s[68:69], s[92:93]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_6
		buffer_store_short v86, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_6:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 10
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[98:99], s[68:69], s[66:67]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_7
		buffer_store_short v87, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_7:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 12
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[98:99], s[68:69], s[94:95]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_8
		buffer_store_short v92, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s64, 14
		s_add_i32 s98, s98, s16
		s_add_i32 s98, s98, s65
		v_lshl_add_u32 v69, v8, 1, s98
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[68:69], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_9
		buffer_store_short v93, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_10
		buffer_store_short v94, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_10
.Ltlx_addmm_glu_kernel_persistent.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_11
		buffer_store_short v95, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_11
.Ltlx_addmm_glu_kernel_persistent.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_12
		buffer_store_short v84, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_12
.Ltlx_addmm_glu_kernel_persistent.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_13
		buffer_store_short v85, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_13
.Ltlx_addmm_glu_kernel_persistent.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_14
		buffer_store_short v96, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_14
.Ltlx_addmm_glu_kernel_persistent.exec_endif_14:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_15
		buffer_store_short v97, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_15:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_15
.Ltlx_addmm_glu_kernel_persistent.exec_endif_15:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 12
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_16
		buffer_store_short v100, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_16:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_16
.Ltlx_addmm_glu_kernel_persistent.exec_endif_16:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 5
		s_add_i32 s68, s68, 14
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[70:71], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_17
		buffer_store_short v101, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_17:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_17
.Ltlx_addmm_glu_kernel_persistent.exec_endif_17:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_18
		buffer_store_short v102, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_18:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_18
.Ltlx_addmm_glu_kernel_persistent.exec_endif_18:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_19
		buffer_store_short v103, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_19:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_19
.Ltlx_addmm_glu_kernel_persistent.exec_endif_19:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_20
		buffer_store_short v80, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_20:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_20
.Ltlx_addmm_glu_kernel_persistent.exec_endif_20:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_21
		buffer_store_short v81, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_21:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_21
.Ltlx_addmm_glu_kernel_persistent.exec_endif_21:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_22
		buffer_store_short v104, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_22:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_22
.Ltlx_addmm_glu_kernel_persistent.exec_endif_22:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_23
		buffer_store_short v105, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_23:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_23
.Ltlx_addmm_glu_kernel_persistent.exec_endif_23:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 12
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_24
		buffer_store_short v106, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_24:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_24
.Ltlx_addmm_glu_kernel_persistent.exec_endif_24:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 6
		s_add_i32 s68, s68, 14
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[72:73], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_25
		buffer_store_short v107, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_25:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_25
.Ltlx_addmm_glu_kernel_persistent.exec_endif_25:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_26
		buffer_store_short v108, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_26:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_26
.Ltlx_addmm_glu_kernel_persistent.exec_endif_26:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_27
		buffer_store_short v109, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_27:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_27
.Ltlx_addmm_glu_kernel_persistent.exec_endif_27:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_28
		buffer_store_short v110, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_28:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_28
.Ltlx_addmm_glu_kernel_persistent.exec_endif_28:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_29
		buffer_store_short v111, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_29:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_29
.Ltlx_addmm_glu_kernel_persistent.exec_endif_29:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_30
		buffer_store_short v112, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_30:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_30
.Ltlx_addmm_glu_kernel_persistent.exec_endif_30:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_31
		buffer_store_short v113, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_31:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_31
.Ltlx_addmm_glu_kernel_persistent.exec_endif_31:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 12
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_32
		buffer_store_short v114, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_32:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_32
.Ltlx_addmm_glu_kernel_persistent.exec_endif_32:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0x60, s19
		s_add_i32 s68, s68, 14
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[74:75], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_33
		buffer_store_short v115, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_33:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_33
.Ltlx_addmm_glu_kernel_persistent.exec_endif_33:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_34
		buffer_store_short v116, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_34:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_34
.Ltlx_addmm_glu_kernel_persistent.exec_endif_34:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_35
		buffer_store_short v117, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_35:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_35
.Ltlx_addmm_glu_kernel_persistent.exec_endif_35:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_36
		buffer_store_short v118, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_36:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_36
.Ltlx_addmm_glu_kernel_persistent.exec_endif_36:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_37
		buffer_store_short v119, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_37:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_37
.Ltlx_addmm_glu_kernel_persistent.exec_endif_37:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_38
		buffer_store_short v120, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_38:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_38
.Ltlx_addmm_glu_kernel_persistent.exec_endif_38:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_39
		buffer_store_short v121, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_39:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_39
.Ltlx_addmm_glu_kernel_persistent.exec_endif_39:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 12
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_40
		buffer_store_short v122, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_40:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_40
.Ltlx_addmm_glu_kernel_persistent.exec_endif_40:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s68, s19, 7
		s_add_i32 s68, s68, 14
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[76:77], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_41
		buffer_store_short v123, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_41:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_41
.Ltlx_addmm_glu_kernel_persistent.exec_endif_41:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0xa0, s19
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_42
		buffer_store_short v128, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_42:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_42
.Ltlx_addmm_glu_kernel_persistent.exec_endif_42:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0xa0, s19
		s_add_i32 s68, s68, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_43
		buffer_store_short v129, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_43:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_43
.Ltlx_addmm_glu_kernel_persistent.exec_endif_43:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0xa0, s19
		s_add_i32 s68, s68, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_44
		buffer_store_short v76, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_44:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_44
.Ltlx_addmm_glu_kernel_persistent.exec_endif_44:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s68, 0xa0, s19
		s_add_i32 s68, s68, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_45
		buffer_store_short v77, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_45:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_45
.Ltlx_addmm_glu_kernel_persistent.exec_endif_45:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s57, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_46
		buffer_store_short v130, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_46:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_46
.Ltlx_addmm_glu_kernel_persistent.exec_endif_46:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s58, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_47
		buffer_store_short v131, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_47:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_47
.Ltlx_addmm_glu_kernel_persistent.exec_endif_47:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s59, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_48
		buffer_store_short v132, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_48:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_48
.Ltlx_addmm_glu_kernel_persistent.exec_endif_48:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s36, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[78:79], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_49
		buffer_store_short v133, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_49:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_49
.Ltlx_addmm_glu_kernel_persistent.exec_endif_49:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_50
		buffer_store_short v134, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_50:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_50
.Ltlx_addmm_glu_kernel_persistent.exec_endif_50:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s61, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_51
		buffer_store_short v135, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_51:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_51
.Ltlx_addmm_glu_kernel_persistent.exec_endif_51:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s60, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_52
		buffer_store_short v124, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_52:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_52
.Ltlx_addmm_glu_kernel_persistent.exec_endif_52:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_53
		buffer_store_short v125, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_53:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_53
.Ltlx_addmm_glu_kernel_persistent.exec_endif_53:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_54
		buffer_store_short v98, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_54:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_54
.Ltlx_addmm_glu_kernel_persistent.exec_endif_54:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[66:67]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_55
		buffer_store_short v99, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_55:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_55
.Ltlx_addmm_glu_kernel_persistent.exec_endif_55:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, 12
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[94:95]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_56
		buffer_store_short v126, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_56:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_56
.Ltlx_addmm_glu_kernel_persistent.exec_endif_56:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s62, 14
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[80:81], s[96:97]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_57
		buffer_store_short v127, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_57:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_57
.Ltlx_addmm_glu_kernel_persistent.exec_endif_57:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[82:83], s[84:85]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_58
		buffer_store_short v70, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_58:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_58
.Ltlx_addmm_glu_kernel_persistent.exec_endif_58:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, 2
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[82:83], s[86:87]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_59
		buffer_store_short v71, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_59:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_59
.Ltlx_addmm_glu_kernel_persistent.exec_endif_59:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, 4
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[82:83], s[88:89]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_60
		buffer_store_short v78, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_60:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_60
.Ltlx_addmm_glu_kernel_persistent.exec_endif_60:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, 6
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[82:83], s[90:91]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_61
		buffer_store_short v79, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_61:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_61
.Ltlx_addmm_glu_kernel_persistent.exec_endif_61:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, 8
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[68:69], s[82:83], s[92:93]
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_62
		buffer_store_short v90, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_62:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_62
.Ltlx_addmm_glu_kernel_persistent.exec_endif_62:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s68, s63, 10
		s_add_i32 s68, s68, s64
		s_add_i32 s68, s68, s16
		s_add_i32 s68, s68, s65
		v_lshl_add_u32 v69, v8, 1, s68
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[66:67], s[82:83], s[66:67]
		s_and_saveexec_b64 s[100:101], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_63
		buffer_store_short v91, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_63:
		s_andn2_b64 exec, s[100:101], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_63
.Ltlx_addmm_glu_kernel_persistent.exec_endif_63:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s66, s63, 12
		s_add_i32 s66, s66, s64
		s_add_i32 s66, s66, s16
		s_add_i32 s66, s66, s65
		v_lshl_add_u32 v69, v8, 1, s66
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[66:67], s[82:83], s[94:95]
		s_and_saveexec_b64 s[100:101], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_64
		buffer_store_short v88, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_64:
		s_andn2_b64 exec, s[100:101], s[66:67]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_64
.Ltlx_addmm_glu_kernel_persistent.exec_endif_64:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s66, s63, 14
		s_add_i32 s64, s66, s64
		s_add_i32 s16, s64, s16
		s_add_i32 s16, s16, s65
		v_lshl_add_u32 v69, v8, 1, s16
		v_lshl_add_u32 v69, v66, 4, v69
		s_and_b64 s[64:65], s[82:83], s[96:97]
		s_and_saveexec_b64 s[100:101], s[64:65]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_else_65
		buffer_store_short v89, v69, s[52:55], 0 offen sc0 nt
.Ltlx_addmm_glu_kernel_persistent.exec_else_65:
		s_andn2_b64 exec, s[100:101], s[64:65]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_65
.Ltlx_addmm_glu_kernel_persistent.exec_endif_65:
		s_mov_b64 exec, s[100:101]
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
		.amdhsa_next_free_vgpr 241
		.amdhsa_next_free_sgpr 102
		.amdhsa_accum_offset 244
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 241
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 102
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
    .sgpr_count:     102
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     241
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 118
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 181
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
