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
		v_mov_b32_e32 v1, 0
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
		v_lshrrev_b32_e32 v2, 2, v0
		v_and_b32_e32 v2, 1, v2
		v_lshrrev_b32_e32 v3, 3, v0
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v4, 4
		v_mul_lo_u32 v4, v4, v3
		v_mad_u32_u24 v2, v2, 2, v4
		v_lshrrev_b32_e32 v3, 4, v0
		v_and_b32_e32 v4, 1, v3
		v_mad_u32_u24 v2, v4, 8, v2
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 16
		v_mul_lo_u32 v6, v6, v5
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v7, 1, v5
		v_add3_u32 v2, v2, v6, v7
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v9, 1, v8
		v_mad_u32_u24 v2, v9, 32, v2
		v_lshrrev_b32_e32 v10, 8, v0
		v_and_b32_e32 v11, 1, v10
		v_mad_u32_u24 v2, v11, 64, v2
		v_and_b32_e32 v12, 15, v4
		v_add_u32_e32 v13, 16, v12
		v_add_u32_e32 v14, 32, v12
		v_add_u32_e32 v15, 48, v12
		v_add_u32_e32 v16, 64, v12
		v_add_u32_e32 v17, 0x50, v12
		v_add_u32_e32 v18, 0x60, v12
		v_add_u32_e32 v19, 0x70, v12
		v_and_b32_e32 v20, 31, v0
		v_mov_b32_e32 v21, 8
		v_mul_lo_u32 v21, v21, v20
		v_and_b32_e32 v3, 15, v3
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v3
		v_add_u32_e32 v3, 64, v20
		v_add_u32_e32 v22, 0x80, v20
		v_add_u32_e32 v23, 0xc0, v20
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v24, 3, v0
		v_mov_b32_e32 v25, 8
		v_mul_lo_u32 v25, v25, v24
		v_add_u32_e32 v6, v6, v7
		v_mad_u32_u24 v6, v9, 2, v6
		v_mad_u32_u24 v6, v11, 8, v6
		v_add_u32_e32 v7, 4, v6
		v_cmp_lt_i32_e64 vcc, v25, s14
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v6, s14
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v7, s14
		s_mov_b64 s[28:29], vcc
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 vcc, v25, s23
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[34:35], vcc
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v25, s23
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[40:41], vcc
		s_add_i32 s23, s21, -3
		s_add_i32 s42, s21, -2
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s43, 1, 0
		s_xor_b32 s44, s42, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s42, s44, s42
		s_mul_hi_u32 s43, s42, 0xaaaaaaab
		s_cselect_b32 s44, 1, 0
		s_lshr_b32 s43, s43, 1
		s_mul_i32 s43, s43, 3
		s_xor_b32 s43, s43, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s42, s42, s43
		s_xor_b32 s43, s42, -1
		s_add_i32 s43, s43, 1
		s_cmp_lg_u32 s44, 0
		s_cselect_b32 s42, s43, s42
		s_add_i32 s21, s21, -1
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s43, 1, 0
		s_xor_b32 s44, s21, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s21, s44, s21
		s_mul_hi_u32 s43, s21, 0xaaaaaaab
		s_cselect_b32 s44, 1, 0
		s_lshr_b32 s43, s43, 1
		s_mul_i32 s43, s43, 3
		s_xor_b32 s43, s43, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s21, s21, s43
		s_xor_b32 s43, s21, -1
		s_add_i32 s43, s43, 1
		s_cmp_lg_u32 s44, 0
		s_cselect_b32 s21, s43, s21
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s22, s22, 0
		s_add_i32 s22, s20, s22
		s_ashr_i32 s22, s22, 5
		s_mul_i32 s22, s22, 32
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s44, s2
		s_mov_b32 s45, s3
		s_mov_b32 s48, s4
		s_mov_b32 s49, s5
		s_mov_b32 s50, s46
		s_mov_b32 s51, s47
		s_mov_b32 s52, s6
		s_mov_b32 s53, s7
		s_mov_b32 s54, s46
		s_mov_b32 s55, s47
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s46
		s_mov_b32 s7, s47
		s_mov_b32 s56, s10
		s_mov_b32 s57, s11
		s_mov_b32 s58, s46
		s_mov_b32 s59, s47
		v_mbcnt_lo_u32_b32 v9, -1, 0
		v_mbcnt_hi_u32_b32 v9, -1, v9
		s_mov_b32 s2, s16
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s8, s1, -1
		s_add_i32 s8, s8, 1
		v_mov_b32_e32 v11, 0x4f7ffffe
		s_mov_b32 s9, 0
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s10, -1
		s_mov_b32 s11, -1
		s_mov_b32 s60, 0
		s_mov_b32 s61, 0
		s_cselect_b32 s62, s10, s60
		s_cselect_b32 s63, s11, s61
		s_xor_b32 s43, s12, -1
		s_add_i32 s43, s43, 1
		v_mov_b32_e32 v24, s12
		v_mov_b32_e32 v26, s43
		v_cndmask_b32_e64 v24, v24, v26, s[62:63]
		v_cvt_f32_u32_e32 v26, v24
		v_rcp_iflag_f32_e32 v26, v26
		v_xad_u32 v27, v24, -1, 1
		v_mul_f32_e32 v26, v11, v26
		v_cvt_u32_f32_e32 v26, v26
		v_mul_lo_u32 v28, v27, v26
		v_mul_hi_u32 v28, v26, v28
		v_add_u32_e32 v26, v26, v28
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s62, s10, s60
		s_cselect_b32 s63, s11, s61
		s_xor_b32 s10, s13, -1
		s_add_i32 s10, s10, 1
		v_mov_b32_e32 v28, s13
		v_mov_b32_e32 v29, s10
		v_cndmask_b32_e64 v28, v28, v29, s[62:63]
		v_cvt_f32_u32_e32 v29, v28
		v_rcp_iflag_f32_e32 v29, v29
		v_xad_u32 v30, v28, -1, 1
		v_mul_f32_e32 v29, v11, v29
		v_cvt_u32_f32_e32 v29, v29
		v_mul_lo_u32 v31, v30, v29
		v_mul_hi_u32 v31, v29, v31
		v_add_u32_e32 v29, v29, v31
		v_and_b32_e32 v31, 1, v0
		v_lshrrev_b32_e32 v32, 1, v0
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v32, 5, v32
		v_lshl_add_u32 v31, v31, 4, v32
		v_mov_b32_e32 v32, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v33, s17, v10
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v34, s17, v8
		v_lshlrev_b32_e32 v34, 2, v34
		v_lshl_add_u32 v33, v33, 4, v34
		v_and_b32_e32 v34, 1, v5
		v_mul_lo_u32 v35, s17, v34
		v_lshl_add_u32 v33, v35, 1, v33
		v_and_b32_e32 v35, 1, v4
		v_mul_lo_u32 v35, s17, v35
		v_lshl_add_u32 v33, v35, 5, v33
		s_lshl_b32 s10, s17, 3
		s_lshl_b32 s11, s17, 6
		s_mul_i32 s43, 0x48, s17
		s_lshl_b32 s60, s17, 7
		s_mul_i32 s61, 0x88, s17
		v_and_b32_e32 v35, 63, v0
		v_lshrrev_b32_e32 v36, 4, v35
		v_lshlrev_b32_e32 v37, 4, v36
		v_lshl_add_u32 v37, v10, 9, v37
		v_and_b32_e32 v38, 15, v35
		v_lshrrev_b32_e32 v39, 1, v38
		v_lshlrev_b32_e32 v39, 6, v39
		v_and_b32_e32 v40, 1, v38
		v_mov_b32_e32 v41, 0x420
		v_mul_lo_u32 v41, v41, v40
		v_add3_u32 v37, v37, v39, v41
		v_lshrrev_b32_e32 v39, 5, v35
		v_lshrrev_b32_e32 v40, 2, v38
		v_mov_b32_e32 v41, 0x420
		v_mul_lo_u32 v41, v41, v40
		v_lshl_add_u32 v40, v39, 9, v41
		v_and_b32_e32 v5, 3, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_and_b32_e32 v36, 1, v36
		v_mov_b32_e32 v41, 0x1080
		v_mul_lo_u32 v41, v41, v36
		v_add3_u32 v5, v40, v5, v41
		v_and_b32_e32 v38, 3, v38
		v_lshl_add_u32 v5, v38, 3, v5
		v_add_u32_e32 v38, 0xc0, v31
		s_lshl_b32 s62, s15, 1
		s_cmp_lt_i32 0, s23
		v_mov_b32_e32 v40, 1
		s_mul_i32 s63, 0xc0, s17
		s_mul_i32 s64, 0xc8, s17
		s_mul_i32 s65, 0x2100, s42
		v_add_u32_e32 v41, s65, v37
		s_mul_i32 s42, 0x4200, s42
		v_add_u32_e32 v42, s42, v5
		s_mul_i32 s42, 0x2100, s21
		v_add_u32_e32 v43, s42, v37
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v44, s21, v5
		v_lshlrev_b32_e32 v45, 4, v0
		v_add_u32_e32 v45, 0x10000, v45
		v_xor_b32_e32 v46, 1, v0
		v_lshlrev_b32_e32 v46, 4, v46
		v_add_u32_e32 v47, 0x10000, v46
		v_add_u32_e32 v46, 0x20000, v46
		v_lshlrev_b32_e32 v48, 14, v36
		v_add_u32_e32 v48, 0x10000, v48
		v_lshrrev_b32_e32 v49, 3, v35
		v_and_b32_e32 v49, 1, v49
		v_lshl_add_u32 v48, v49, 13, v48
		v_lshrrev_b32_e32 v50, 2, v35
		v_and_b32_e32 v50, 1, v50
		v_lshrrev_b32_e32 v51, 1, v35
		v_and_b32_e32 v51, 1, v51
		v_lshlrev_b32_e32 v52, 6, v51
		v_lshl_add_u32 v52, v50, 7, v52
		v_lshlrev_b32_e32 v10, 3, v10
		v_lshlrev_b32_e32 v8, 2, v8
		v_and_b32_e32 v35, 1, v35
		v_lshl_add_u32 v53, v35, 5, v39
		v_lshlrev_b32_e32 v34, 1, v34
		v_xor_b32_e32 v53, v53, v34
		v_bitop3_b32 v53, v10, v8, v53 bitop3:0x96
		v_add_u32_e32 v54, v52, v53
		v_xor_b32_e32 v55, v54, v49
		v_lshl_add_u32 v55, v55, 4, v48
		v_lshl_add_u32 v35, v35, 5, 16
		v_bitop3_b32 v34, v34, v35, v39 bitop3:0x96
		v_bitop3_b32 v8, v10, v8, v34 bitop3:0x96
		v_add_u32_e32 v10, v52, v8
		v_xor_b32_e32 v34, v10, v49
		v_lshl_add_u32 v34, v34, 4, v48
		v_add_u32_e32 v35, 4, v51
		v_lshlrev_b32_e32 v39, 1, v50
		v_xor_b32_e32 v35, v35, v39
		v_lshl_add_u32 v39, v35, 6, v53
		v_xor_b32_e32 v50, v39, v49
		v_lshl_add_u32 v50, v50, 4, v48
		v_lshl_add_u32 v8, v35, 6, v8
		v_xor_b32_e32 v35, v8, v49
		v_lshl_add_u32 v35, v35, 4, v48
		v_lshl_add_u32 v48, v49, 2, 16
		v_lshlrev_b32_e32 v36, 3, v36
		v_xor_b32_e32 v48, v48, v36
		v_lshrrev_b32_e32 v48, 2, v48
		v_and_b32_e32 v51, 1, v48
		v_xor_b32_e32 v52, v54, v51
		v_lshlrev_b32_e32 v48, 13, v48
		v_add_u32_e32 v48, 0x10000, v48
		v_lshl_add_u32 v52, v52, 4, v48
		v_xor_b32_e32 v53, v10, v51
		v_lshl_add_u32 v53, v53, 4, v48
		v_xor_b32_e32 v56, v39, v51
		v_lshl_add_u32 v56, v56, 4, v48
		v_xor_b32_e32 v51, v8, v51
		v_lshl_add_u32 v48, v51, 4, v48
		v_lshl_add_u32 v51, v49, 2, 32
		v_xor_b32_e32 v51, v51, v36
		v_lshrrev_b32_e32 v51, 2, v51
		v_and_b32_e32 v57, 1, v51
		v_xor_b32_e32 v58, v54, v57
		v_lshlrev_b32_e32 v51, 13, v51
		v_lshl_add_u32 v58, v58, 4, v51
		v_xor_b32_e32 v59, v10, v57
		v_lshl_add_u32 v59, v59, 4, v51
		v_xor_b32_e32 v60, v39, v57
		v_lshl_add_u32 v60, v60, 4, v51
		v_xor_b32_e32 v57, v8, v57
		v_lshl_add_u32 v51, v57, 4, v51
		v_lshl_add_u32 v49, v49, 2, 48
		v_xor_b32_e32 v36, v49, v36
		v_lshrrev_b32_e32 v36, 2, v36
		v_and_b32_e32 v49, 1, v36
		v_xor_b32_e32 v54, v54, v49
		v_lshlrev_b32_e32 v36, 13, v36
		v_lshl_add_u32 v54, v54, 4, v36
		v_xor_b32_e32 v10, v10, v49
		v_lshl_add_u32 v10, v10, 4, v36
		v_xor_b32_e32 v39, v39, v49
		v_lshl_add_u32 v39, v39, 4, v36
		v_xor_b32_e32 v8, v8, v49
		v_lshl_add_u32 v8, v8, 4, v36
		v_mul_lo_u32 v4, s19, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_and_b32_e32 v36, 31, v0
		v_lshlrev_b32_e32 v36, 4, v36
		s_cselect_b32 s21, 1, 0
		s_lshl_b32 s42, s19, 5
		s_lshl_b32 s65, s19, 6
		s_mul_i32 s66, 0x60, s19
		s_lshl_b32 s67, s19, 7
		s_mul_i32 s68, 0xa0, s19
		s_mul_i32 s69, 0xc0, s19
		s_mul_i32 s70, 0xe0, s19
		s_cmp_lt_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s2, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s16, s2
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s71, s2, 7
		s_lshr_b32 s72, s2, 3
		s_lshr_b32 s73, s72, 2
		s_mul_i32 s73, s73, 32
		s_mul_i32 s71, s71, 4
		s_add_i32 s71, s73, s71
		s_and_b32 s72, s72, 3
		s_add_i32 s16, s71, s72
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		s_barrier
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s71, 1, 0
		s_xor_b32 s72, s16, -1
		s_add_i32 s72, s72, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s16
		s_cselect_b32 s72, 1, 0
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s73, s8, s1
		v_mov_b32_e32 v49, s73
		v_cvt_f32_u32_e32 v49, v49
		v_rcp_iflag_f32_e32 v49, v49
		s_xor_b32 s74, s73, -1
		v_mul_f32_e32 v49, v11, v49
		v_cvt_u32_f32_e32 v49, v49
		s_add_i32 s74, s74, 1
		v_readfirstlane_b32 s75, v49
		s_mul_i32 s76, s74, s75
		s_mul_hi_u32 s76, s75, s76
		s_add_i32 s75, s75, s76
		s_mul_hi_u32 s75, s71, s75
		s_mul_i32 s76, s75, s73
		s_xor_b32 s76, s76, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s71, s71, s76
		s_cmp_ge_u32 s71, s73
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s75, 1
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s75, s77, s75
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s71, s74
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s71, s77, s71
		s_cmp_ge_u32 s71, s73
		s_cselect_b32 s73, 1, 0
		s_add_i32 s76, s75, 1
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s73, s76, s75
		s_cselect_b32 s75, 1, 0
		s_xor_b32 s16, s16, s1
		s_xor_b32 s76, s73, -1
		s_add_i32 s76, s76, 1
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s16, s76, s73
		s_mul_i32 s73, s16, 4
		s_xor_b32 s76, s73, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s76, s0, s76
		s_cmp_lt_i32 s76, 4
		s_cselect_b32 s76, s76, 4
		s_add_i32 s74, s71, s74
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s71, s74, s71
		s_xor_b32 s74, s71, -1
		s_add_i32 s74, s74, 1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s71, s74, s71
		s_cmp_lt_i32 s71, 0
		s_cselect_b32 s72, 1, 0
		s_xor_b32 s74, s71, -1
		s_add_i32 s74, s74, 1
		s_cmp_lg_u32 s72, 0
		s_cselect_b32 s72, s74, s71
		s_cselect_b32 s74, 1, 0
		s_xor_b32 s75, s76, -1
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s76, 0
		s_cselect_b32 s75, s75, s76
		v_mov_b32_e32 v49, s75
		v_cvt_f32_u32_e32 v49, v49
		v_rcp_iflag_f32_e32 v49, v49
		s_xor_b32 s77, s75, -1
		v_mul_f32_e32 v49, v11, v49
		v_cvt_u32_f32_e32 v49, v49
		s_add_i32 s77, s77, 1
		v_readfirstlane_b32 s78, v49
		s_mul_i32 s79, s77, s78
		s_mul_hi_u32 s79, s78, s79
		s_add_i32 s78, s78, s79
		s_mul_hi_u32 s78, s72, s78
		s_mul_i32 s79, s78, s75
		s_xor_b32 s79, s79, -1
		s_add_i32 s79, s79, 1
		s_add_i32 s72, s72, s79
		s_cmp_ge_u32 s72, s75
		s_cselect_b32 s79, 1, 0
		s_add_i32 s80, s72, s77
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s72, s80, s72
		s_cselect_b32 s79, 1, 0
		s_cmp_ge_u32 s72, s75
		s_cselect_b32 s75, 1, 0
		s_add_i32 s77, s72, s77
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s72, s77, s72
		s_cselect_b32 s75, 1, 0
		s_xor_b32 s77, s72, -1
		s_add_i32 s77, s77, 1
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s72, s77, s72
		s_add_i32 s73, s73, s72
		s_add_i32 s74, s78, 1
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s74, s74, s78
		s_add_i32 s77, s74, 1
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s74, s77, s74
		s_xor_b32 s71, s71, s76
		s_xor_b32 s75, s74, -1
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s71, 0
		s_cselect_b32 s71, s75, s74
		s_mul_i32 s73, s73, 0x80
		v_add_u32_e32 v49, s73, v2
		v_cmp_lt_i32_e64 vcc, v49, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v57, v49, -1, 1
		v_add_u32_e32 v61, s73, v12
		v_cndmask_b32_e32 v49, v49, v57, vcc
		v_mul_hi_u32 v57, v49, v26
		v_mul_lo_u32 v57, v57, v24
		v_xor_b32_e32 v57, -1, v57
		v_add3_u32 v49, 1, v57, v49
		v_add_u32_e32 v57, v49, v27
		v_cmp_ge_u32_e64 vcc, v49, v24
		v_add_u32_e32 v62, s73, v13
		v_add_u32_e32 v63, s73, v14
		v_cndmask_b32_e32 v49, v49, v57, vcc
		v_add_u32_e32 v57, v49, v27
		v_cmp_ge_u32_e64 vcc, v49, v24
		v_add_u32_e32 v64, s73, v15
		v_add_u32_e32 v65, s73, v16
		v_cndmask_b32_e32 v49, v49, v57, vcc
		v_xad_u32 v57, v49, -1, 1
		v_cmp_lt_i32_e64 vcc, v61, s9
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v66, v61, -1, 1
		v_add_u32_e32 v67, s73, v17
		v_cndmask_b32_e32 v66, v61, v66, vcc
		v_mul_hi_u32 v68, v66, v26
		v_mul_lo_u32 v68, v68, v24
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v66, 1, v68, v66
		v_add_u32_e32 v68, v66, v27
		v_cmp_ge_u32_e64 vcc, v66, v24
		v_add_u32_e32 v69, s73, v18
		v_add_u32_e32 v70, s73, v19
		v_cndmask_b32_e32 v66, v66, v68, vcc
		v_cmp_ge_u32_e64 vcc, v66, v24
		v_cndmask_b32_e64 v49, v49, v57, s[74:75]
		v_add_u32_e32 v57, v66, v27
		v_cndmask_b32_e32 v57, v66, v57, vcc
		v_xad_u32 v66, v57, -1, 1
		v_cmp_lt_i32_e64 vcc, v62, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v68, v62, -1, 1
		v_cndmask_b32_e64 v57, v57, v66, s[76:77]
		v_cndmask_b32_e32 v66, v62, v68, vcc
		v_mul_hi_u32 v68, v66, v26
		v_mul_lo_u32 v68, v68, v24
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v66, 1, v68, v66
		v_cmp_ge_u32_e64 vcc, v66, v24
		v_add_u32_e32 v68, v66, v27
		v_xad_u32 v71, v63, -1, 1
		v_cndmask_b32_e32 v66, v66, v68, vcc
		v_cmp_ge_u32_e64 vcc, v66, v24
		v_add_u32_e32 v68, v66, v27
		v_xad_u32 v72, v64, -1, 1
		v_cndmask_b32_e32 v66, v66, v68, vcc
		v_xad_u32 v68, v66, -1, 1
		v_cmp_lt_i32_e64 vcc, v63, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v66, v66, v68, s[74:75]
		v_xad_u32 v68, v65, -1, 1
		v_cndmask_b32_e32 v71, v63, v71, vcc
		v_mul_hi_u32 v73, v71, v26
		v_mul_lo_u32 v73, v73, v24
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v71, 1, v73, v71
		v_cmp_ge_u32_e64 vcc, v71, v24
		v_add_u32_e32 v73, v71, v27
		s_add_i32 s2, s2, 0x130
		v_cndmask_b32_e32 v71, v71, v73, vcc
		v_cmp_ge_u32_e64 vcc, v71, v24
		v_add_u32_e32 v73, v71, v27
		v_xad_u32 v74, v67, -1, 1
		v_cndmask_b32_e32 v71, v71, v73, vcc
		v_xad_u32 v73, v71, -1, 1
		v_cmp_lt_i32_e64 vcc, v64, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v71, v71, v73, s[76:77]
		s_mul_i32 s72, s19, s72
		v_cndmask_b32_e32 v72, v64, v72, vcc
		v_mul_hi_u32 v73, v72, v26
		v_mul_lo_u32 v73, v73, v24
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v72, 1, v73, v72
		v_cmp_ge_u32_e64 vcc, v72, v24
		v_add_u32_e32 v73, v72, v27
		s_mul_i32 s16, s19, s16
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_cmp_ge_u32_e64 vcc, v72, v24
		v_add_u32_e32 v73, v72, v27
		v_xad_u32 v75, v69, -1, 1
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_xad_u32 v73, v72, -1, 1
		v_cmp_lt_i32_e64 vcc, v65, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v72, v72, v73, s[74:75]
		s_lshl_b32 s73, s71, 9
		v_cndmask_b32_e32 v68, v65, v68, vcc
		v_mul_hi_u32 v73, v68, v26
		v_mul_lo_u32 v73, v73, v24
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v68, 1, v73, v68
		v_cmp_ge_u32_e64 vcc, v68, v24
		v_add_u32_e32 v73, v68, v27
		v_xad_u32 v76, v70, -1, 1
		v_cndmask_b32_e32 v68, v68, v73, vcc
		v_cmp_ge_u32_e64 vcc, v68, v24
		v_add_u32_e32 v73, v68, v27
		s_mul_i32 s71, s71, 0x100
		v_cndmask_b32_e32 v68, v68, v73, vcc
		v_xad_u32 v73, v68, -1, 1
		v_cmp_lt_i32_e64 vcc, v67, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v68, v68, v73, s[76:77]
		v_mul_lo_u32 v68, s18, v68
		v_cndmask_b32_e32 v73, v67, v74, vcc
		v_mul_hi_u32 v74, v73, v26
		v_mul_lo_u32 v74, v74, v24
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v73, 1, v74, v73
		v_cmp_ge_u32_e64 vcc, v73, v24
		v_add_u32_e32 v74, v73, v27
		v_add_u32_e32 v77, s71, v21
		v_cndmask_b32_e32 v73, v73, v74, vcc
		v_cmp_ge_u32_e64 vcc, v73, v24
		v_add_u32_e32 v74, v73, v27
		v_xad_u32 v78, v77, -1, 1
		v_cndmask_b32_e32 v73, v73, v74, vcc
		v_xad_u32 v74, v73, -1, 1
		v_cmp_lt_i32_e64 vcc, v69, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v73, v73, v74, s[74:75]
		v_mul_lo_u32 v73, s18, v73
		v_cndmask_b32_e32 v74, v69, v75, vcc
		v_mul_hi_u32 v75, v74, v26
		v_mul_lo_u32 v75, v75, v24
		v_xor_b32_e32 v75, -1, v75
		v_add3_u32 v74, 1, v75, v74
		v_cmp_ge_u32_e64 vcc, v74, v24
		v_add_u32_e32 v75, v74, v27
		v_add_u32_e32 v79, s71, v20
		v_cndmask_b32_e32 v74, v74, v75, vcc
		v_cmp_ge_u32_e64 vcc, v74, v24
		v_add_u32_e32 v75, v74, v27
		v_add_u32_e32 v80, s71, v3
		v_cndmask_b32_e32 v74, v74, v75, vcc
		v_xad_u32 v75, v74, -1, 1
		v_cmp_lt_i32_e64 vcc, v70, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v74, v74, v75, s[76:77]
		v_add_u32_e32 v75, s71, v22
		v_cndmask_b32_e32 v76, v70, v76, vcc
		v_mul_hi_u32 v81, v76, v26
		v_mul_lo_u32 v81, v81, v24
		v_xor_b32_e32 v81, -1, v81
		v_add3_u32 v76, 1, v81, v76
		v_cmp_ge_u32_e64 vcc, v76, v24
		v_add_u32_e32 v81, v76, v27
		v_add_u32_e32 v82, s71, v23
		v_cndmask_b32_e32 v76, v76, v81, vcc
		v_cmp_ge_u32_e64 vcc, v76, v24
		v_add_u32_e32 v81, v76, v27
		v_xad_u32 v83, v79, -1, 1
		v_cndmask_b32_e32 v76, v76, v81, vcc
		v_xad_u32 v81, v76, -1, 1
		v_cmp_lt_i32_e64 vcc, v77, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v76, v76, v81, s[74:75]
		v_mul_lo_u32 v72, s18, v72
		v_cndmask_b32_e32 v78, v77, v78, vcc
		v_mul_hi_u32 v81, v78, v29
		v_mul_lo_u32 v81, v81, v28
		v_xor_b32_e32 v81, -1, v81
		v_add3_u32 v78, 1, v81, v78
		v_add_u32_e32 v81, v78, v30
		v_cmp_ge_u32_e64 vcc, v78, v28
		v_mul_lo_u32 v71, s18, v71
		v_xad_u32 v84, v80, -1, 1
		v_cndmask_b32_e32 v78, v78, v81, vcc
		v_add_u32_e32 v81, v78, v30
		v_cmp_ge_u32_e64 vcc, v78, v28
		v_mul_lo_u32 v66, s18, v66
		v_mul_lo_u32 v57, s18, v57
		v_cndmask_b32_e32 v78, v78, v81, vcc
		v_xad_u32 v81, v78, -1, 1
		v_cmp_lt_i32_e64 vcc, v79, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v78, v78, v81, s[76:77]
		v_xad_u32 v81, v75, -1, 1
		v_cndmask_b32_e32 v79, v79, v83, vcc
		v_mul_hi_u32 v83, v79, v29
		v_mul_lo_u32 v83, v83, v28
		v_xor_b32_e32 v83, -1, v83
		v_add3_u32 v79, 1, v83, v79
		v_cmp_ge_u32_e64 vcc, v79, v28
		v_add_u32_e32 v83, v79, v30
		v_mul_lo_u32 v85, s62, v49
		v_cndmask_b32_e32 v79, v79, v83, vcc
		v_cmp_ge_u32_e64 vcc, v79, v28
		v_add_u32_e32 v83, v79, v30
		v_xad_u32 v86, v82, -1, 1
		v_cndmask_b32_e32 v79, v79, v83, vcc
		v_xad_u32 v83, v79, -1, 1
		v_cmp_lt_i32_e64 vcc, v80, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v79, v79, v83, s[74:75]
		v_lshlrev_b32_e32 v79, 1, v79
		v_cndmask_b32_e32 v80, v80, v84, vcc
		v_mul_hi_u32 v83, v80, v29
		v_mul_lo_u32 v83, v83, v28
		v_xor_b32_e32 v83, -1, v83
		v_add3_u32 v80, 1, v83, v80
		v_cmp_ge_u32_e64 vcc, v80, v28
		v_add_u32_e32 v83, v80, v30
		v_lshlrev_b32_e32 v78, 1, v78
		v_cndmask_b32_e32 v80, v80, v83, vcc
		v_cmp_ge_u32_e64 vcc, v80, v28
		v_add_u32_e32 v83, v80, v30
		v_mul_lo_u32 v49, s15, v49
		v_cndmask_b32_e32 v80, v80, v83, vcc
		v_xad_u32 v83, v80, -1, 1
		v_cmp_lt_i32_e64 vcc, v75, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v80, v80, v83, s[76:77]
		v_readfirstlane_b32 s71, v0
		v_cndmask_b32_e32 v75, v75, v81, vcc
		v_mul_hi_u32 v81, v75, v29
		v_mul_lo_u32 v81, v81, v28
		v_xor_b32_e32 v81, -1, v81
		v_add3_u32 v75, 1, v81, v75
		v_cmp_ge_u32_e64 vcc, v75, v28
		v_add_u32_e32 v81, v75, v30
		v_lshl_add_u32 v49, v49, 1, v31
		v_cndmask_b32_e32 v75, v75, v81, vcc
		v_cmp_ge_u32_e64 vcc, v75, v28
		v_add_u32_e32 v81, v75, v30
		v_cndmask_b32_e64 v83, v32, v49, s[24:25]
		v_cndmask_b32_e32 v75, v75, v81, vcc
		v_xad_u32 v81, v75, -1, 1
		v_cmp_lt_i32_e64 vcc, v82, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v75, v75, v81, s[74:75]
		s_lshr_b32 s71, s71, 6
		v_cndmask_b32_e32 v81, v82, v86, vcc
		v_mul_hi_u32 v82, v81, v29
		v_mul_lo_u32 v82, v82, v28
		v_xor_b32_e32 v82, -1, v82
		v_add3_u32 v81, 1, v82, v81
		v_cmp_ge_u32_e64 vcc, v81, v28
		v_add_u32_e32 v82, v81, v30
		s_mul_i32 s71, 0x420, s71
		v_cndmask_b32_e32 v81, v81, v82, vcc
		v_cmp_ge_u32_e64 vcc, v81, v28
		v_add_u32_e32 v82, v81, v30
		s_mov_b32 m0, s71
		v_cndmask_b32_e32 v81, v81, v82, vcc
		buffer_load_dwordx4 v83, s[44:47], 0 offen lds
		s_barrier
		v_xad_u32 v82, v81, -1, 1
		v_add_u32_e32 v83, v33, v78
		s_add_i32 m0, s71, 0x62e0
		v_cndmask_b32_e64 v84, v32, v83, s[26:27]
		buffer_load_dwordx4 v84, s[48:51], 0 offen lds
		v_add_u32_e32 v84, s10, v83
		s_add_i32 m0, s71, 0x83e0
		v_cndmask_b32_e64 v84, v32, v84, s[28:29]
		buffer_load_dwordx4 v84, s[48:51], 0 offen lds
		s_barrier
		v_add_u32_e32 v84, 64, v49
		s_add_i32 m0, s71, 0x2100
		v_cndmask_b32_e64 v84, v32, v84, s[30:31]
		buffer_load_dwordx4 v84, s[44:47], 0 offen lds
		s_barrier
		v_add_u32_e32 v84, s11, v83
		s_add_i32 m0, s71, 0xa4e0
		v_cndmask_b32_e64 v84, v32, v84, s[32:33]
		buffer_load_dwordx4 v84, s[48:51], 0 offen lds
		v_add_u32_e32 v84, s43, v83
		s_add_i32 m0, s71, 0xc5e0
		v_cndmask_b32_e64 v84, v32, v84, s[34:35]
		buffer_load_dwordx4 v84, s[48:51], 0 offen lds
		s_barrier
		v_add_u32_e32 v49, 0x80, v49
		s_add_i32 m0, s71, 0x4200
		v_cndmask_b32_e64 v49, v32, v49, s[36:37]
		buffer_load_dwordx4 v49, s[44:47], 0 offen lds
		s_barrier
		v_add_u32_e32 v49, s60, v83
		s_add_i32 m0, s71, 0xe6e0
		v_cndmask_b32_e64 v49, v32, v49, s[38:39]
		v_add_u32_e32 v84, s61, v83
		v_cndmask_b32_e64 v84, v32, v84, s[40:41]
		s_mov_b32 s74, 0
		v_add_u32_e32 v86, v38, v85
		s_mov_b32 s75, 0
		buffer_load_dwordx4 v49, s[48:51], 0 offen lds
		s_add_i32 m0, s71, 0x107e0
		v_cndmask_b32_e64 v49, v81, v82, s[76:77]
		buffer_load_dwordx4 v84, s[48:51], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[88:91], v37
		ds_read_b128 v[92:95], v37 offset:2112
		ds_read_b128 v[96:99], v37 offset:4224
		ds_read_b128 v[100:103], v37 offset:6336
		ds_read_b64_tr_b16 v[104:105], v5 offset:25312
		ds_read_b64_tr_b16 v[106:107], v5 offset:33760
		ds_read_b64_tr_b16 v[108:109], v5 offset:25440
		ds_read_b64_tr_b16 v[110:111], v5 offset:33888
		ds_read_b64_tr_b16 v[112:113], v5 offset:25568
		ds_read_b64_tr_b16 v[114:115], v5 offset:34016
		ds_read_b64_tr_b16 v[116:117], v5 offset:25696
		ds_read_b64_tr_b16 v[118:119], v5 offset:34144
		s_cmp_lg_u32 s21, 0
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_cmp_ge_u32 s74, 2
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s74, -2
		s_add_i32 s78, s74, 1
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s76, s77, s78
		s_cselect_b32 s79, 1, 0
		s_add_i32 s80, s75, 3
		s_mul_i32 s80, s80, 32
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		s_xor_b32 s80, s80, -1
		s_add_i32 s80, s80, 1
		s_add_i32 s80, s14, s80
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		v_cmp_lt_i32_e64 vcc, v25, s80
		s_lshl_b32 s81, s75, 6
		v_add_u32_e32 v81, s75, v9
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
		v_cndmask_b32_e32 v82, v1, v40, vcc
		v_add_u32_e32 v82, v82, v81
		v_add_u32_e32 v84, 1, v81
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
		s_barrier
		v_cmp_eq_u32_e64 vcc, v82, v84
		s_mul_i32 s82, 0x2100, s74
		s_add_i32 m0, s71, s82
		v_cndmask_b32_e32 v82, v32, v86, vcc
		buffer_load_dwordx4 v82, s[44:47], s81 offen lds
		v_cmp_lt_i32_e64 vcc, v6, s80
		s_mul_i32 s74, 0x4200, s74
		s_add_i32 s74, s71, s74
		v_cndmask_b32_e32 v82, v1, v40, vcc
		v_add_u32_e32 v82, v82, v81
		v_cmp_eq_u32_e64 vcc, v82, v84
		s_mov_b64 s[82:83], vcc
		v_cmp_lt_i32_e64 vcc, v7, s80
		s_mul_i32 s80, s17, s75
		s_lshl_b32 s80, s80, 6
		v_cndmask_b32_e32 v82, v1, v40, vcc
		s_add_i32 s81, s63, s80
		v_add_u32_e32 v85, s81, v83
		v_cndmask_b32_e64 v85, v32, v85, s[82:83]
		s_add_i32 m0, s74, 0x62e0
		s_add_i32 s75, s75, 1
		buffer_load_dwordx4 v85, s[48:51], 0 offen lds
		v_add_u32_e32 v81, v82, v81
		s_add_i32 s80, s64, s80
		v_cmp_eq_u32_e64 vcc, v81, v84
		v_add_u32_e32 v81, s80, v83
		s_mul_i32 s80, 0x4200, s76
		v_cndmask_b32_e32 v81, v32, v81, vcc
		s_add_i32 m0, s74, 0x83e0
		s_mul_i32 s74, 0x2100, s76
		buffer_load_dwordx4 v81, s[48:51], 0 offen lds
		v_add_u32_e32 v81, s74, v37
		ds_read_b128 v[88:91], v81
		ds_read_b128 v[92:95], v81 offset:2112
		ds_read_b128 v[96:99], v81 offset:4224
		ds_read_b128 v[100:103], v81 offset:6336
		v_add_u32_e32 v81, s80, v5
		ds_read_b64_tr_b16 v[104:105], v81 offset:25312
		ds_read_b64_tr_b16 v[106:107], v81 offset:33760
		ds_read_b64_tr_b16 v[108:109], v81 offset:25440
		ds_read_b64_tr_b16 v[110:111], v81 offset:33888
		ds_read_b64_tr_b16 v[112:113], v81 offset:25568
		ds_read_b64_tr_b16 v[114:115], v81 offset:34016
		ds_read_b64_tr_b16 v[116:117], v81 offset:25696
		ds_read_b64_tr_b16 v[118:119], v81 offset:34144
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s74, s77, s78
		s_cmp_lt_i32 s75, s23
		s_waitcnt vmcnt(3)
		s_barrier
		s_mov_b32 s75, s75
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_dwordx2 v[82:83], v79, s[52:55], 0 offen
		v_lshlrev_b32_e32 v79, 1, v80
		buffer_load_dwordx2 v[80:81], v79, s[52:55], 0 offen
		v_lshlrev_b32_e32 v75, 1, v75
		buffer_load_dwordx2 v[84:85], v75, s[52:55], 0 offen
		v_lshlrev_b32_e32 v49, 1, v49
		buffer_load_dwordx2 v[86:87], v49, s[52:55], 0 offen
		v_lshl_add_u32 v49, v57, 1, v78
		buffer_load_dwordx4 v[184:187], v49, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v49, v66, 1, v78
		buffer_load_dwordx4 v[188:191], v49, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v49, v71, 1, v78
		buffer_load_dwordx4 v[192:195], v49, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v49, v72, 1, v78
		buffer_load_dwordx4 v[196:199], v49, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v49, v68, 1, v78
		buffer_load_dwordx4 v[200:203], v49, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v49, v73, 1, v78
		buffer_load_dwordx4 v[204:207], v49, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v49, s18, v74
		v_lshl_add_u32 v49, v49, 1, v78
		buffer_load_dwordx4 v[72:75], v49, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v49, s18, v76
		v_lshl_add_u32 v49, v49, 1, v78
		buffer_load_dwordx4 v[208:211], v49, s[4:7], 0 offen sc0 nt
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
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
		ds_read_b128 v[88:91], v41
		ds_read_b128 v[92:95], v41 offset:2112
		ds_read_b128 v[96:99], v41 offset:4224
		ds_read_b128 v[100:103], v41 offset:6336
		ds_read_b64_tr_b16 v[104:105], v42 offset:25312
		ds_read_b64_tr_b16 v[106:107], v42 offset:33760
		ds_read_b64_tr_b16 v[108:109], v42 offset:25440
		ds_read_b64_tr_b16 v[110:111], v42 offset:33888
		ds_read_b64_tr_b16 v[112:113], v42 offset:25568
		ds_read_b64_tr_b16 v[114:115], v42 offset:34016
		ds_read_b64_tr_b16 v[116:117], v42 offset:25696
		ds_read_b64_tr_b16 v[118:119], v42 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
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
		ds_read_b128 v[88:91], v43
		ds_read_b128 v[92:95], v43 offset:2112
		ds_read_b128 v[96:99], v43 offset:4224
		ds_read_b128 v[100:103], v43 offset:6336
		ds_read_b64_tr_b16 v[104:105], v44 offset:25312
		ds_read_b64_tr_b16 v[106:107], v44 offset:33760
		ds_read_b64_tr_b16 v[108:109], v44 offset:25440
		ds_read_b64_tr_b16 v[110:111], v44 offset:33888
		ds_read_b64_tr_b16 v[112:113], v44 offset:25568
		ds_read_b64_tr_b16 v[114:115], v44 offset:34016
		ds_read_b64_tr_b16 v[116:117], v44 offset:25696
		ds_read_b64_tr_b16 v[118:119], v44 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[108:111], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[128:131], v[112:115], v[88:91], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[104:107], v[92:95], v[136:139]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[116:119], v[88:91], v[132:135]
		s_barrier
		v_mfma_f32_16x16x32_f16 v[148:151], v[116:119], v[92:95], v[148:151]
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
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v78, v82
		v_cvt_f32_f16_sdwa v79, v82 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v83
		v_cvt_f32_f16_sdwa v89, v83 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v82, v80
		v_cvt_f32_f16_sdwa v83, v80 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v81
		v_cvt_f32_f16_sdwa v91, v81 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v80, v84
		v_cvt_f32_f16_sdwa v81, v84 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v92, v85
		v_cvt_f32_f16_sdwa v93, v85 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v84, v86
		v_cvt_f32_f16_sdwa v85, v86 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v87
		v_cvt_f32_f16_sdwa v95, v87 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v86, v184
		v_cvt_f32_f16_sdwa v87, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v185
		v_cvt_f32_f16_sdwa v97, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v186
		v_cvt_f32_f16_sdwa v99, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v100, v187
		v_cvt_f32_f16_sdwa v101, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v102, v188
		v_cvt_f32_f16_sdwa v103, v188 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v189
		v_cvt_f32_f16_sdwa v105, v189 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v106, v190
		v_cvt_f32_f16_sdwa v107, v190 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v108, v191
		v_cvt_f32_f16_sdwa v109, v191 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v110, v192
		v_cvt_f32_f16_sdwa v111, v192 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v112, v193
		v_cvt_f32_f16_sdwa v113, v193 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v114, v194
		v_cvt_f32_f16_sdwa v115, v194 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v116, v195
		v_cvt_f32_f16_sdwa v117, v195 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v118, v196
		v_cvt_f32_f16_sdwa v119, v196 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v184, v197
		v_cvt_f32_f16_sdwa v185, v197 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v186, v198
		v_cvt_f32_f16_sdwa v187, v198 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v188, v199
		v_cvt_f32_f16_sdwa v189, v199 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v190, v200
		v_cvt_f32_f16_sdwa v191, v200 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v192, v201
		v_cvt_f32_f16_sdwa v193, v201 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v194, v202
		v_cvt_f32_f16_sdwa v195, v202 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v196, v203
		v_cvt_f32_f16_sdwa v197, v203 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v198, v204
		v_cvt_f32_f16_sdwa v199, v204 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v200, v205
		v_cvt_f32_f16_sdwa v201, v205 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v202, v206
		v_cvt_f32_f16_sdwa v203, v206 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v204, v207
		v_cvt_f32_f16_sdwa v205, v207 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v206, v72
		v_cvt_f32_f16_sdwa v207, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v212, v73
		v_cvt_f32_f16_sdwa v213, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v74
		v_cvt_f32_f16_sdwa v73, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v214, v75
		v_cvt_f32_f16_sdwa v215, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v74, v208
		v_cvt_f32_f16_sdwa v75, v208 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v216, v209
		v_cvt_f32_f16_sdwa v217, v209 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v208, v210
		v_cvt_f32_f16_sdwa v209, v210 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v218, v211
		v_cvt_f32_f16_sdwa v219, v211 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[220:221], v[120:121], v[78:79]
		v_pk_add_f32 v[222:223], v[122:123], v[88:89]
		ds_write_b128 v45, v[220:223] offset:10432
		v_pk_add_f32 v[120:121], v[124:125], v[82:83]
		v_pk_add_f32 v[122:123], v[126:127], v[90:91]
		ds_write_b128 v47, v[120:123] offset:18624
		v_pk_add_f32 v[120:121], v[128:129], v[80:81]
		v_pk_add_f32 v[122:123], v[130:131], v[92:93]
		ds_write_b128 v45, v[120:123] offset:26816
		v_pk_add_f32 v[120:121], v[132:133], v[84:85]
		v_pk_add_f32 v[122:123], v[134:135], v[94:95]
		ds_write_b128 v47, v[120:123] offset:35008
		v_pk_add_f32 v[120:121], v[136:137], v[78:79]
		v_pk_add_f32 v[122:123], v[138:139], v[88:89]
		ds_write_b128 v45, v[120:123] offset:43200
		v_pk_add_f32 v[120:121], v[140:141], v[82:83]
		v_pk_add_f32 v[122:123], v[142:143], v[90:91]
		ds_write_b128 v47, v[120:123] offset:51392
		v_pk_add_f32 v[120:121], v[144:145], v[80:81]
		v_pk_add_f32 v[122:123], v[146:147], v[92:93]
		ds_write_b128 v45, v[120:123] offset:59584
		v_pk_add_f32 v[120:121], v[148:149], v[84:85]
		v_pk_add_f32 v[122:123], v[150:151], v[94:95]
		ds_write_b128 v46, v[120:123] offset:2240
		v_pk_add_f32 v[120:121], v[152:153], v[78:79]
		v_pk_add_f32 v[122:123], v[154:155], v[88:89]
		v_pk_add_f32 v[124:125], v[156:157], v[82:83]
		v_pk_add_f32 v[126:127], v[158:159], v[90:91]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_add_f32 v[128:129], v[160:161], v[80:81]
		v_pk_add_f32 v[130:131], v[162:163], v[92:93]
		v_pk_add_f32 v[132:133], v[164:165], v[84:85]
		v_pk_add_f32 v[134:135], v[166:167], v[94:95]
		v_pk_add_f32 v[136:137], v[168:169], v[78:79]
		v_pk_add_f32 v[138:139], v[170:171], v[88:89]
		v_pk_add_f32 v[140:141], v[172:173], v[82:83]
		v_pk_add_f32 v[142:143], v[174:175], v[90:91]
		v_pk_add_f32 v[88:89], v[176:177], v[80:81]
		v_pk_add_f32 v[90:91], v[178:179], v[92:93]
		v_pk_add_f32 v[80:81], v[180:181], v[84:85]
		v_pk_add_f32 v[82:83], v[182:183], v[94:95]
		ds_read_b128 v[92:95], v55 offset:10432
		ds_read_b128 v[144:147], v34 offset:10432
		ds_read_b128 v[148:151], v50 offset:10432
		ds_read_b128 v[152:155], v35 offset:10432
		ds_read_b128 v[156:159], v52 offset:10432
		ds_read_b128 v[160:163], v53 offset:10432
		ds_read_b128 v[164:167], v56 offset:10432
		ds_read_b128 v[168:171], v48 offset:10432
		s_waitcnt lgkmcnt(7)
		v_pk_fma_f32 v[78:79], v[92:93], v[86:87], v[92:93]
		v_pk_fma_f32 v[84:85], v[94:95], v[96:97], v[94:95]
		s_waitcnt lgkmcnt(6)
		v_pk_fma_f32 v[86:87], v[144:145], v[98:99], v[144:145]
		v_pk_fma_f32 v[92:93], v[146:147], v[100:101], v[146:147]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v45, v[120:123] offset:10432
		ds_write_b128 v47, v[124:127] offset:18624
		ds_write_b128 v45, v[128:131] offset:26816
		ds_write_b128 v47, v[132:135] offset:35008
		ds_write_b128 v45, v[136:139] offset:43200
		ds_write_b128 v47, v[140:143] offset:51392
		ds_write_b128 v45, v[88:91] offset:59584
		ds_write_b128 v46, v[80:83] offset:2240
		v_pk_fma_f32 v[80:81], v[148:149], v[102:103], v[148:149]
		v_pk_fma_f32 v[82:83], v[150:151], v[104:105], v[150:151]
		v_pk_fma_f32 v[88:89], v[152:153], v[106:107], v[152:153]
		v_pk_fma_f32 v[90:91], v[154:155], v[108:109], v[154:155]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[96:99], v58 offset:10432
		ds_read_b128 v[100:103], v59 offset:10432
		ds_read_b128 v[104:107], v60 offset:10432
		ds_read_b128 v[120:123], v51 offset:10432
		ds_read_b128 v[124:127], v54 offset:10432
		ds_read_b128 v[128:131], v10 offset:10432
		ds_read_b128 v[132:135], v39 offset:10432
		ds_read_b128 v[136:139], v8 offset:10432
		v_pk_fma_f32 v[94:95], v[156:157], v[110:111], v[156:157]
		v_pk_fma_f32 v[108:109], v[158:159], v[112:113], v[158:159]
		v_pk_fma_f32 v[110:111], v[160:161], v[114:115], v[160:161]
		v_pk_fma_f32 v[112:113], v[162:163], v[116:117], v[162:163]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_fma_f32 v[114:115], v[164:165], v[118:119], v[164:165]
		v_pk_fma_f32 v[116:117], v[166:167], v[184:185], v[166:167]
		v_pk_fma_f32 v[118:119], v[168:169], v[186:187], v[168:169]
		v_pk_fma_f32 v[140:141], v[170:171], v[188:189], v[170:171]
		v_pk_fma_f32 v[142:143], v[96:97], v[190:191], v[96:97]
		v_pk_fma_f32 v[96:97], v[98:99], v[192:193], v[98:99]
		v_pk_fma_f32 v[98:99], v[100:101], v[194:195], v[100:101]
		v_pk_fma_f32 v[100:101], v[102:103], v[196:197], v[102:103]
		v_pk_fma_f32 v[102:103], v[104:105], v[198:199], v[104:105]
		v_pk_fma_f32 v[104:105], v[106:107], v[200:201], v[106:107]
		v_pk_fma_f32 v[106:107], v[120:121], v[202:203], v[120:121]
		v_pk_fma_f32 v[120:121], v[122:123], v[204:205], v[122:123]
		v_pk_fma_f32 v[122:123], v[124:125], v[206:207], v[124:125]
		v_pk_fma_f32 v[124:125], v[126:127], v[212:213], v[126:127]
		v_pk_fma_f32 v[126:127], v[128:129], v[72:73], v[128:129]
		v_pk_fma_f32 v[72:73], v[130:131], v[214:215], v[130:131]
		v_pk_fma_f32 v[128:129], v[132:133], v[74:75], v[132:133]
		v_pk_fma_f32 v[74:75], v[134:135], v[216:217], v[134:135]
		v_pk_fma_f32 v[130:131], v[136:137], v[208:209], v[136:137]
		v_pk_fma_f32 v[132:133], v[138:139], v[218:219], v[138:139]
		v_cmp_lt_i32_e64 vcc, v61, s12
		s_mov_b64 s[74:75], vcc
		v_cmp_lt_i32_e64 vcc, v77, s13
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v136, v78, v79
		v_cvt_pk_f16_f32 v137, v84, v85
		v_cvt_pk_f16_f32 v138, v86, v87
		v_cvt_pk_f16_f32 v139, v92, v93
		s_lshl_b32 s16, s16, 10
		s_add_i32 s71, s73, s16
		s_lshl_b32 s72, s72, 8
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[136:139], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v62, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v76, v80, v81
		v_cvt_pk_f16_f32 v77, v82, v83
		v_cvt_pk_f16_f32 v78, v88, v89
		v_cvt_pk_f16_f32 v79, v90, v91
		s_add_i32 s71, s42, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[76:79], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v63, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v76, v94, v95
		v_cvt_pk_f16_f32 v77, v108, v109
		v_cvt_pk_f16_f32 v78, v110, v111
		v_cvt_pk_f16_f32 v79, v112, v113
		s_add_i32 s71, s65, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[76:79], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v64, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v76, v114, v115
		v_cvt_pk_f16_f32 v77, v116, v117
		v_cvt_pk_f16_f32 v78, v118, v119
		v_cvt_pk_f16_f32 v79, v140, v141
		s_add_i32 s71, s66, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[76:79], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v65, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v76, v142, v143
		v_cvt_pk_f16_f32 v77, v96, v97
		v_cvt_pk_f16_f32 v78, v98, v99
		v_cvt_pk_f16_f32 v79, v100, v101
		s_add_i32 s71, s67, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[76:79], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v67, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v102, v103
		v_cvt_pk_f16_f32 v65, v104, v105
		v_cvt_pk_f16_f32 v66, v106, v107
		v_cvt_pk_f16_f32 v67, v120, v121
		s_add_i32 s71, s68, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[64:67], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v69, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v122, v123
		v_cvt_pk_f16_f32 v65, v124, v125
		v_cvt_pk_f16_f32 v66, v126, v127
		v_cvt_pk_f16_f32 v67, v72, v73
		s_add_i32 s71, s69, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v49, s71, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[64:67], v49, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v70, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v128, v129
		v_cvt_pk_f16_f32 v65, v74, v75
		v_cvt_pk_f16_f32 v66, v130, v131
		v_cvt_pk_f16_f32 v67, v132, v133
		s_add_i32 s71, s70, s73
		s_add_i32 s16, s71, s16
		s_add_i32 s16, s16, s72
		v_add3_u32 v49, s16, v4, v36
		v_cndmask_b32_e64 v49, v32, v49, s[78:79]
		buffer_store_dwordx4 v[64:67], v49, s[56:59], 0 offen sc0 nt
		s_cmp_lt_i32 s2, s20
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_0
.Ltlx_addmm_glu_kernel_persistent.loop_exit_0:
		s_endpgm
	.size	tlx_addmm_glu_kernel_persistent, .-tlx_addmm_glu_kernel_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel tlx_addmm_glu_kernel_persistent
		.amdhsa_group_segment_fixed_size 141504
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
		.amdhsa_next_free_vgpr 224
		.amdhsa_next_free_sgpr 86
		.amdhsa_accum_offset 224
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 224
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 86
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
    .group_segment_fixed_size: 141504
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     86
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     224
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
