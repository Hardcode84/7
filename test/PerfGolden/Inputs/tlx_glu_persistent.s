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
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_and_b32_e32 v8, 1, v3
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v8
		v_mad_u32_u24 v2, v2, 2, v9
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v9, 1, v8
		v_mad_u32_u24 v2, v9, 8, v2
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v10
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v12, 1, v10
		v_add3_u32 v2, v2, v11, v12
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v2, v14, 32, v2
		v_lshrrev_b32_e32 v15, 8, v0
		v_and_b32_e32 v16, 1, v15
		v_mad_u32_u24 v2, v16, 64, v2
		v_and_b32_e32 v17, 15, v9
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
		v_and_b32_e32 v25, 15, v8
		v_mov_b32_e32 v27, 4
		v_mul_lo_u32 v27, v27, v25
		v_add_u32_e32 v25, 64, v27
		v_add_u32_e32 v28, 0x80, v27
		v_add_u32_e32 v29, 0xc0, v27
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v30, 3, v0
		v_mov_b32_e32 v31, 8
		v_mul_lo_u32 v31, v31, v30
		v_add_u32_e32 v11, v11, v12
		v_mad_u32_u24 v11, v14, 2, v11
		v_mad_u32_u24 v11, v16, 8, v11
		v_add_u32_e32 v12, 4, v11
		v_cmp_lt_i32_e64 vcc, v31, s14
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v11, s14
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v12, s14
		s_mov_b64 s[28:29], vcc
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v11, s23
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[34:35], vcc
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v11, s23
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[40:41], vcc
		s_add_i32 s23, s21, -3
		s_add_i32 s42, s21, -2
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s43, 1, 0
		s_xor_b32 s44, s42, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s42, s44, s42
		s_cselect_b32 s43, 1, 0
		s_and_b32 s44, s42, 0xffff
		s_lshr_b32 s45, s42, 16
		s_mul_i32 s46, s44, 0xaaab
		s_mul_i32 s44, s44, 0xaaaa
		s_mul_i32 s47, s45, 0xaaab
		s_mul_i32 s45, s45, 0xaaaa
		s_lshr_b32 s46, s46, 16
		s_and_b32 s48, s44, 0xffff
		s_and_b32 s49, s47, 0xffff
		s_add_i32 s46, s46, s48
		s_add_i32 s46, s46, s49
		s_lshr_b32 s44, s44, 16
		s_add_i32 s44, s45, s44
		s_lshr_b32 s45, s47, 16
		s_add_i32 s44, s44, s45
		s_lshr_b32 s45, s46, 16
		s_add_i32 s44, s44, s45
		s_lshr_b32 s44, s44, 1
		s_mul_i32 s44, s44, 3
		s_xor_b32 s44, s44, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s42, s42, s44
		s_xor_b32 s44, s42, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s42, s44, s42
		s_add_i32 s21, s21, -1
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s43, 1, 0
		s_xor_b32 s44, s21, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s21, s44, s21
		s_cselect_b32 s43, 1, 0
		s_and_b32 s44, s21, 0xffff
		s_lshr_b32 s45, s21, 16
		s_mul_i32 s46, s44, 0xaaab
		s_mul_i32 s44, s44, 0xaaaa
		s_mul_i32 s47, s45, 0xaaab
		s_mul_i32 s45, s45, 0xaaaa
		s_lshr_b32 s46, s46, 16
		s_and_b32 s48, s44, 0xffff
		s_and_b32 s49, s47, 0xffff
		s_add_i32 s46, s46, s48
		s_add_i32 s46, s46, s49
		s_lshr_b32 s44, s44, 16
		s_add_i32 s44, s45, s44
		s_lshr_b32 s45, s47, 16
		s_add_i32 s44, s44, s45
		s_lshr_b32 s45, s46, 16
		s_add_i32 s44, s44, s45
		s_lshr_b32 s44, s44, 1
		s_mul_i32 s44, s44, 3
		s_xor_b32 s44, s44, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s21, s21, s44
		s_xor_b32 s44, s21, -1
		s_add_i32 s44, s44, 1
		s_cmp_lg_u32 s43, 0
		s_cselect_b32 s21, s44, s21
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
		s_mov_b32 s2, s16
		s_cmp_lt_i32 s16, s20
		s_cselect_b32 s3, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s8, 1, 0
		s_xor_b32 s9, s1, -1
		s_add_i32 s9, s9, 1
		v_mov_b32_e32 v14, 0x4f7ffffe
		s_mov_b32 s10, 0
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s60, -1
		s_mov_b32 s61, -1
		s_mov_b32 s62, 0
		s_mov_b32 s63, 0
		s_cselect_b32 s64, s60, s62
		s_cselect_b32 s65, s61, s63
		s_xor_b32 s11, s12, -1
		s_add_i32 s11, s11, 1
		v_mov_b32_e32 v16, s12
		v_mov_b32_e32 v30, s11
		v_cndmask_b32_e64 v16, v16, v30, s[64:65]
		v_cvt_f32_u32_e32 v30, v16
		v_rcp_iflag_f32_e32 v30, v30
		s_nop 0
		v_mul_f32_e32 v30, v14, v30
		v_cvt_u32_f32_e32 v30, v30
		v_xad_u32 v32, v16, -1, 1
		v_mul_lo_u32 v33, v32, v30
		v_mul_hi_u32 v33, v30, v33
		v_add_u32_e32 v30, v30, v33
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s64, s60, s62
		s_cselect_b32 s65, s61, s63
		s_xor_b32 s11, s13, -1
		s_add_i32 s11, s11, 1
		v_mov_b32_e32 v33, s13
		v_mov_b32_e32 v34, s11
		v_cndmask_b32_e64 v33, v33, v34, s[64:65]
		v_cvt_f32_u32_e32 v34, v33
		v_rcp_iflag_f32_e32 v34, v34
		s_nop 0
		v_mul_f32_e32 v34, v14, v34
		v_cvt_u32_f32_e32 v34, v34
		v_xad_u32 v35, v33, -1, 1
		v_mul_lo_u32 v36, v35, v34
		v_mul_hi_u32 v36, v34, v36
		v_add_u32_e32 v34, v34, v36
		v_lshlrev_b32_e32 v36, 9, v15
		v_and_b32_e32 v37, 63, v0
		v_lshrrev_b32_e32 v38, 4, v37
		v_lshlrev_b32_e32 v39, 4, v38
		v_add_u32_e32 v40, v36, v39
		v_and_b32_e32 v41, 15, v37
		v_lshrrev_b32_e32 v42, 1, v41
		v_lshlrev_b32_e32 v42, 6, v42
		v_and_b32_e32 v43, 1, v41
		v_mov_b32_e32 v44, 0x420
		v_mul_lo_u32 v44, v44, v43
		v_add3_u32 v40, v40, v42, v44
		v_lshrrev_b32_e32 v37, 5, v37
		v_lshlrev_b32_e32 v37, 9, v37
		v_lshrrev_b32_e32 v43, 2, v41
		v_mov_b32_e32 v45, 0x420
		v_mul_lo_u32 v45, v45, v43
		v_and_b32_e32 v43, 3, v10
		v_lshlrev_b32_e32 v43, 5, v43
		v_add3_u32 v46, v37, v45, v43
		v_and_b32_e32 v38, 1, v38
		v_mov_b32_e32 v47, 0x1080
		v_mul_lo_u32 v47, v47, v38
		v_and_b32_e32 v38, 3, v41
		v_lshlrev_b32_e32 v38, 3, v38
		v_add3_u32 v41, v46, v47, v38
		v_and_b32_e32 v46, 1, v0
		v_lshrrev_b32_e32 v48, 1, v0
		v_and_b32_e32 v48, 1, v48
		v_lshlrev_b32_e32 v49, 5, v48
		v_lshl_add_u32 v49, v46, 4, v49
		v_add_u32_e32 v50, 0xc0, v49
		s_lshl_b32 s11, s15, 1
		s_mul_i32 s16, 0x2100, s42
		v_add_u32_e32 v51, s16, v40
		s_mul_i32 s16, 0x4200, s42
		v_add_u32_e32 v52, s16, v41
		s_mul_i32 s16, 0x2100, s21
		v_add_u32_e32 v53, s16, v40
		s_mul_i32 s16, 0x4200, s21
		v_add_u32_e32 v54, s16, v41
		v_lshlrev_b32_e32 v55, 4, v0
		v_add_u32_e32 v55, 0x10000, v55
		v_lshlrev_b32_e32 v56, 4, v9
		v_add_u32_e32 v56, 0x10000, v56
		v_lshl_add_u32 v46, v46, 9, v56
		v_and_b32_e32 v8, 1, v8
		v_lshl_add_u32 v8, v8, 14, v46
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v3, v3, 13, v8
		v_and_b32_e32 v1, 1, v1
		v_lshl_add_u32 v1, v1, 11, v3
		v_lshl_add_u32 v1, v48, 10, v1
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v3, s19, v9
		v_lshlrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v8, 31, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_mov_b32_e32 v46, 0x80000000
		s_cmp_lt_i32 0, s23
		s_cselect_b32 s16, 1, 0
		s_lshl_b32 s21, s19, 5
		s_lshl_b32 s42, s19, 6
		s_mul_i32 s43, 0x60, s19
		s_lshl_b32 s60, s19, 7
		s_mul_i32 s61, 0xa0, s19
		s_mul_i32 s62, 0xc0, s19
		s_mul_i32 s63, 0xe0, s19
		v_mul_lo_u32 v15, s17, v15
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshl_add_u32 v13, v15, 4, v13
		v_and_b32_e32 v10, 1, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v10, v10, 1, v13
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v9, s17, v9
		v_lshl_add_u32 v9, v9, 5, v10
		s_lshl_b32 s64, s17, 3
		s_lshl_b32 s65, s17, 6
		s_mul_i32 s66, 0x48, s17
		s_lshl_b32 s67, s17, 7
		s_mul_i32 s68, 0x88, s17
		s_mul_i32 s69, 0xc0, s17
		s_mul_i32 s70, 0xc8, s17
		s_cmp_lg_u32 s3, 0
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_0
.Ltlx_addmm_glu_kernel_persistent.loop_head_0:
		s_cmp_ge_i32 s2, s22
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.if_else_0
		s_mov_b32 s3, s2
		s_branch .Ltlx_addmm_glu_kernel_persistent.if_end_0
.Ltlx_addmm_glu_kernel_persistent.if_else_0:
		s_and_b32 s71, s2, 7
		s_lshr_b32 s72, s2, 3
		s_lshr_b32 s73, s72, 2
		s_mul_i32 s73, s73, 32
		s_mul_i32 s71, s71, 4
		s_add_i32 s71, s73, s71
		s_and_b32 s72, s72, 3
		s_add_i32 s3, s71, s72
.Ltlx_addmm_glu_kernel_persistent.if_end_0:
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s71, 1, 0
		s_xor_b32 s72, s3, -1
		s_add_i32 s72, s72, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s3
		s_cselect_b32 s72, 1, 0
		s_cmp_lg_u32 s8, 0
		s_cselect_b32 s73, s9, s1
		v_mov_b32_e32 v10, s73
		v_cvt_f32_u32_e32 v10, v10
		v_rcp_iflag_f32_e32 v10, v10
		s_nop 0
		v_mul_f32_e32 v10, v14, v10
		v_cvt_u32_f32_e32 v10, v10
		s_nop 0
		v_readfirstlane_b32 s74, v10
		s_xor_b32 s75, s73, -1
		s_add_i32 s75, s75, 1
		s_mul_i32 s76, s75, s74
		s_mul_hi_u32 s76, s74, s76
		s_add_i32 s74, s74, s76
		s_mul_hi_u32 s74, s71, s74
		s_mul_i32 s76, s74, s73
		s_xor_b32 s76, s76, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s71, s71, s76
		s_cmp_ge_u32 s71, s73
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s74, 1
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s74, s77, s74
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s71, s75
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s71, s77, s71
		s_cmp_ge_u32 s71, s73
		s_cselect_b32 s73, 1, 0
		s_add_i32 s76, s74, 1
		s_cmp_lg_u32 s73, 0
		s_cselect_b32 s73, s76, s74
		s_cselect_b32 s74, 1, 0
		s_xor_b32 s3, s3, s1
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s76, s73, -1
		s_add_i32 s76, s76, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s3, s76, s73
		s_mul_i32 s73, s3, 4
		s_xor_b32 s76, s73, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s76, s0, s76
		s_cmp_lt_i32 s76, 4
		s_cselect_b32 s76, s76, 4
		s_add_i32 s75, s71, s75
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s71, s75, s71
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
		s_cmp_lt_i32 s76, 0
		s_cselect_b32 s75, 1, 0
		s_xor_b32 s77, s76, -1
		s_add_i32 s77, s77, 1
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s75, s77, s76
		v_mov_b32_e32 v10, s75
		v_cvt_f32_u32_e32 v10, v10
		v_rcp_iflag_f32_e32 v10, v10
		s_nop 0
		v_mul_f32_e32 v10, v14, v10
		v_cvt_u32_f32_e32 v10, v10
		s_nop 0
		v_readfirstlane_b32 s77, v10
		s_xor_b32 s78, s75, -1
		s_add_i32 s78, s78, 1
		s_mul_i32 s79, s78, s77
		s_mul_hi_u32 s79, s77, s79
		s_add_i32 s77, s77, s79
		s_mul_hi_u32 s77, s72, s77
		s_mul_i32 s79, s77, s75
		s_xor_b32 s79, s79, -1
		s_add_i32 s79, s79, 1
		s_add_i32 s72, s72, s79
		s_cmp_ge_u32 s72, s75
		s_cselect_b32 s79, 1, 0
		s_add_i32 s80, s72, s78
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s72, s80, s72
		s_cselect_b32 s79, 1, 0
		s_cmp_ge_u32 s72, s75
		s_cselect_b32 s75, 1, 0
		s_add_i32 s78, s72, s78
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s72, s78, s72
		s_cselect_b32 s75, 1, 0
		s_xor_b32 s78, s72, -1
		s_add_i32 s78, s78, 1
		s_cmp_lg_u32 s74, 0
		s_cselect_b32 s72, s78, s72
		s_add_i32 s73, s73, s72
		s_add_i32 s74, s77, 1
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s74, s74, s77
		s_add_i32 s77, s74, 1
		s_cmp_lg_u32 s75, 0
		s_cselect_b32 s74, s77, s74
		s_xor_b32 s71, s71, s76
		s_cmp_lt_i32 s71, 0
		s_cselect_b32 s71, 1, 0
		s_xor_b32 s75, s74, -1
		s_add_i32 s75, s75, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s75, s74
		s_mul_i32 s73, s73, 0x80
		v_add_u32_e32 v10, s73, v2
		v_cmp_lt_i32_e64 vcc, v10, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v13, v10, -1, 1
		v_add_u32_e32 v15, s73, v17
		v_cndmask_b32_e32 v10, v10, v13, vcc
		v_mul_hi_u32 v13, v10, v30
		v_mul_lo_u32 v13, v13, v16
		v_xor_b32_e32 v13, -1, v13
		v_add3_u32 v10, 1, v13, v10
		v_add_u32_e32 v13, v10, v32
		v_add_u32_e32 v48, s73, v18
		v_cmp_ge_u32_e64 vcc, v10, v16
		s_nop 1
		v_cndmask_b32_e32 v10, v10, v13, vcc
		v_add_u32_e32 v13, v10, v32
		v_add_u32_e32 v56, s73, v19
		v_cmp_ge_u32_e64 vcc, v10, v16
		s_nop 1
		v_cndmask_b32_e32 v10, v10, v13, vcc
		v_xad_u32 v13, v10, -1, 1
		v_cmp_lt_i32_e64 vcc, v15, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v57, v15, -1, 1
		v_add_u32_e32 v58, s73, v20
		v_cndmask_b32_e32 v57, v15, v57, vcc
		v_mul_hi_u32 v59, v57, v30
		v_mul_lo_u32 v59, v59, v16
		v_xor_b32_e32 v59, -1, v59
		v_add3_u32 v57, 1, v59, v57
		v_add_u32_e32 v59, v57, v32
		v_add_u32_e32 v60, s73, v21
		v_cmp_ge_u32_e64 vcc, v57, v16
		s_nop 1
		v_cndmask_b32_e32 v57, v57, v59, vcc
		v_add_u32_e32 v59, v57, v32
		v_add_u32_e32 v61, s73, v22
		v_cmp_ge_u32_e64 vcc, v57, v16
		s_nop 1
		v_cndmask_b32_e32 v57, v57, v59, vcc
		v_xad_u32 v59, v57, -1, 1
		v_cmp_lt_i32_e64 vcc, v48, s10
		s_mov_b64 s[78:79], vcc
		v_xad_u32 v62, v48, -1, 1
		v_add_u32_e32 v63, s73, v23
		v_cndmask_b32_e32 v62, v48, v62, vcc
		v_mul_hi_u32 v64, v62, v30
		v_mul_lo_u32 v64, v64, v16
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v62, 1, v64, v62
		v_add_u32_e32 v64, v62, v32
		v_add_u32_e32 v65, s73, v24
		v_cmp_ge_u32_e64 vcc, v62, v16
		s_nop 1
		v_cndmask_b32_e32 v62, v62, v64, vcc
		v_add_u32_e32 v64, v62, v32
		v_cndmask_b32_e64 v10, v10, v13, s[74:75]
		v_cmp_ge_u32_e64 vcc, v62, v16
		s_nop 1
		v_cndmask_b32_e32 v13, v62, v64, vcc
		v_xad_u32 v62, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v56, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v64, v56, -1, 1
		v_cndmask_b32_e64 v57, v57, v59, s[76:77]
		v_cndmask_b32_e32 v59, v56, v64, vcc
		v_mul_hi_u32 v64, v59, v30
		v_mul_lo_u32 v64, v64, v16
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v59, 1, v64, v59
		v_add_u32_e32 v64, v59, v32
		v_cndmask_b32_e64 v13, v13, v62, s[78:79]
		v_cmp_ge_u32_e64 vcc, v59, v16
		s_nop 1
		v_cndmask_b32_e32 v59, v59, v64, vcc
		v_add_u32_e32 v62, v59, v32
		v_cmp_ge_u32_e64 vcc, v59, v16
		s_nop 1
		v_cndmask_b32_e32 v59, v59, v62, vcc
		v_xad_u32 v62, v59, -1, 1
		v_cmp_lt_i32_e64 vcc, v58, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v64, v58, -1, 1
		v_cndmask_b32_e64 v59, v59, v62, s[74:75]
		v_cndmask_b32_e32 v62, v58, v64, vcc
		v_mul_hi_u32 v64, v62, v30
		v_mul_lo_u32 v64, v64, v16
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v62, 1, v64, v62
		v_add_u32_e32 v64, v62, v32
		v_cmp_ge_u32_e64 vcc, v62, v16
		s_nop 1
		v_cndmask_b32_e32 v62, v62, v64, vcc
		v_add_u32_e32 v64, v62, v32
		v_cmp_ge_u32_e64 vcc, v62, v16
		s_nop 1
		v_cndmask_b32_e32 v62, v62, v64, vcc
		v_xad_u32 v64, v62, -1, 1
		v_cmp_lt_i32_e64 vcc, v60, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v66, v60, -1, 1
		v_cndmask_b32_e64 v62, v62, v64, s[76:77]
		v_cndmask_b32_e32 v64, v60, v66, vcc
		v_mul_hi_u32 v66, v64, v30
		v_mul_lo_u32 v66, v66, v16
		v_xor_b32_e32 v66, -1, v66
		v_add3_u32 v64, 1, v66, v64
		v_add_u32_e32 v66, v64, v32
		s_add_i32 s2, s2, 0x100
		v_cmp_ge_u32_e64 vcc, v64, v16
		s_nop 1
		v_cndmask_b32_e32 v64, v64, v66, vcc
		v_add_u32_e32 v66, v64, v32
		s_mul_i32 s72, s19, s72
		v_cmp_ge_u32_e64 vcc, v64, v16
		s_nop 1
		v_cndmask_b32_e32 v64, v64, v66, vcc
		v_xad_u32 v66, v64, -1, 1
		v_cmp_lt_i32_e64 vcc, v61, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v67, v61, -1, 1
		v_cndmask_b32_e64 v64, v64, v66, s[74:75]
		v_cndmask_b32_e32 v66, v61, v67, vcc
		v_mul_hi_u32 v67, v66, v30
		v_mul_lo_u32 v67, v67, v16
		v_xor_b32_e32 v67, -1, v67
		v_add3_u32 v66, 1, v67, v66
		v_add_u32_e32 v67, v66, v32
		s_mul_i32 s3, s19, s3
		v_cmp_ge_u32_e64 vcc, v66, v16
		s_nop 1
		v_cndmask_b32_e32 v66, v66, v67, vcc
		v_add_u32_e32 v67, v66, v32
		s_lshl_b32 s73, s71, 9
		v_cmp_ge_u32_e64 vcc, v66, v16
		s_nop 1
		v_cndmask_b32_e32 v66, v66, v67, vcc
		v_xad_u32 v67, v66, -1, 1
		v_cmp_lt_i32_e64 vcc, v63, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v68, v63, -1, 1
		v_cndmask_b32_e64 v66, v66, v67, s[76:77]
		v_cndmask_b32_e32 v67, v63, v68, vcc
		v_mul_hi_u32 v68, v67, v30
		v_mul_lo_u32 v68, v68, v16
		v_xor_b32_e32 v68, -1, v68
		v_add3_u32 v67, 1, v68, v67
		v_add_u32_e32 v68, v67, v32
		v_mul_lo_u32 v64, s18, v64
		v_cmp_ge_u32_e64 vcc, v67, v16
		s_nop 1
		v_cndmask_b32_e32 v67, v67, v68, vcc
		v_add_u32_e32 v68, v67, v32
		v_mul_lo_u32 v62, s18, v62
		v_cmp_ge_u32_e64 vcc, v67, v16
		s_nop 1
		v_cndmask_b32_e32 v67, v67, v68, vcc
		v_xad_u32 v68, v67, -1, 1
		v_cmp_lt_i32_e64 vcc, v65, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v69, v65, -1, 1
		v_cndmask_b32_e64 v67, v67, v68, s[74:75]
		v_cndmask_b32_e32 v68, v65, v69, vcc
		v_mul_hi_u32 v69, v68, v30
		v_mul_lo_u32 v69, v69, v16
		v_xor_b32_e32 v69, -1, v69
		v_add3_u32 v68, 1, v69, v68
		v_add_u32_e32 v69, v68, v32
		v_mul_lo_u32 v59, s18, v59
		v_cmp_ge_u32_e64 vcc, v68, v16
		s_nop 1
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_add_u32_e32 v69, v68, v32
		s_mul_i32 s71, s71, 0x100
		v_cmp_ge_u32_e64 vcc, v68, v16
		s_nop 1
		v_cndmask_b32_e32 v68, v68, v69, vcc
		v_xad_u32 v69, v68, -1, 1
		v_add_u32_e32 v70, s71, v26
		v_cmp_lt_i32_e64 vcc, v70, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v71, v70, -1, 1
		v_cndmask_b32_e64 v68, v68, v69, s[76:77]
		v_cndmask_b32_e32 v69, v70, v71, vcc
		v_mul_hi_u32 v71, v69, v34
		v_mul_lo_u32 v71, v71, v33
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v69, 1, v71, v69
		v_add_u32_e32 v71, v69, v35
		v_add_u32_e32 v72, s71, v27
		v_cmp_ge_u32_e64 vcc, v69, v33
		s_nop 1
		v_cndmask_b32_e32 v69, v69, v71, vcc
		v_add_u32_e32 v71, v69, v35
		v_add_u32_e32 v73, s71, v25
		v_cmp_ge_u32_e64 vcc, v69, v33
		s_nop 1
		v_cndmask_b32_e32 v69, v69, v71, vcc
		v_xad_u32 v71, v69, -1, 1
		v_cmp_lt_i32_e64 vcc, v72, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v74, v72, -1, 1
		v_add_u32_e32 v75, s71, v28
		v_cndmask_b32_e32 v72, v72, v74, vcc
		v_mul_hi_u32 v74, v72, v34
		v_mul_lo_u32 v74, v74, v33
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v72, 1, v74, v72
		v_add_u32_e32 v74, v72, v35
		v_add_u32_e32 v76, s71, v29
		v_cmp_ge_u32_e64 vcc, v72, v33
		s_nop 1
		v_cndmask_b32_e32 v72, v72, v74, vcc
		v_add_u32_e32 v74, v72, v35
		v_cndmask_b32_e64 v69, v69, v71, s[74:75]
		v_cmp_ge_u32_e64 vcc, v72, v33
		s_nop 1
		v_cndmask_b32_e32 v71, v72, v74, vcc
		v_xad_u32 v72, v71, -1, 1
		v_cmp_lt_i32_e64 vcc, v73, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v74, v73, -1, 1
		v_cndmask_b32_e64 v71, v71, v72, s[76:77]
		v_cndmask_b32_e32 v72, v73, v74, vcc
		v_mul_hi_u32 v73, v72, v34
		v_mul_lo_u32 v73, v73, v33
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v72, 1, v73, v72
		v_add_u32_e32 v73, v72, v35
		v_mul_lo_u32 v13, s18, v13
		v_cmp_ge_u32_e64 vcc, v72, v33
		s_nop 1
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_add_u32_e32 v73, v72, v35
		v_mul_lo_u32 v57, s18, v57
		v_cmp_ge_u32_e64 vcc, v72, v33
		s_nop 1
		v_cndmask_b32_e32 v72, v72, v73, vcc
		v_xad_u32 v73, v72, -1, 1
		v_cmp_lt_i32_e64 vcc, v75, s10
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v74, v75, -1, 1
		v_cndmask_b32_e64 v72, v72, v73, s[74:75]
		v_cndmask_b32_e32 v73, v75, v74, vcc
		v_mul_hi_u32 v74, v73, v34
		v_mul_lo_u32 v74, v74, v33
		v_xor_b32_e32 v74, -1, v74
		v_add3_u32 v73, 1, v74, v73
		v_add_u32_e32 v74, v73, v35
		v_lshlrev_b32_e32 v71, 1, v71
		v_cmp_ge_u32_e64 vcc, v73, v33
		s_nop 1
		v_cndmask_b32_e32 v73, v73, v74, vcc
		v_add_u32_e32 v74, v73, v35
		v_mul_lo_u32 v75, s11, v10
		v_cmp_ge_u32_e64 vcc, v73, v33
		s_nop 1
		v_cndmask_b32_e32 v73, v73, v74, vcc
		v_xad_u32 v74, v73, -1, 1
		v_cmp_lt_i32_e64 vcc, v76, s10
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v77, v76, -1, 1
		v_cndmask_b32_e64 v73, v73, v74, s[76:77]
		v_cndmask_b32_e32 v74, v76, v77, vcc
		v_mul_hi_u32 v76, v74, v34
		v_mul_lo_u32 v76, v76, v33
		v_xor_b32_e32 v76, -1, v76
		v_add3_u32 v74, 1, v76, v74
		v_add_u32_e32 v76, v74, v35
		v_lshlrev_b32_e32 v77, 1, v69
		v_cmp_ge_u32_e64 vcc, v74, v33
		s_nop 1
		v_cndmask_b32_e32 v74, v74, v76, vcc
		v_add_u32_e32 v76, v74, v35
		v_mul_lo_u32 v10, s15, v10
		v_cmp_ge_u32_e64 vcc, v74, v33
		s_nop 1
		v_cndmask_b32_e32 v74, v74, v76, vcc
		v_xad_u32 v76, v74, -1, 1
		v_cndmask_b32_e64 v74, v74, v76, s[74:75]
		v_readfirstlane_b32 s71, v0
		s_lshr_b32 s71, s71, 6
		s_mul_i32 s71, 0x420, s71
		v_lshl_add_u32 v76, v10, 1, v49
		s_and_saveexec_b64 s[82:83], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		s_mov_b32 m0, s71
		s_nop 0
		buffer_load_dwordx4 v76, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		s_add_i32 m0, s71, 0x62e0
		v_lshl_add_u32 v69, v69, 1, v9
		buffer_load_dwordx4 v69, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
		s_add_i32 m0, s71, 0x83e0
		v_add3_u32 v69, v9, v77, s64
		buffer_load_dwordx4 v69, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[82:83]
		v_lshlrev_b32_e32 v10, 1, v10
		s_and_saveexec_b64 s[82:83], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
		s_add_i32 m0, s71, 0x2100
		v_add3_u32 v10, v49, v10, 64
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[32:33]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
		s_add_i32 m0, s71, 0xa4e0
		v_add3_u32 v10, v9, v77, s65
		buffer_load_dwordx4 v10, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
		s_add_i32 m0, s71, 0xc5e0
		v_add3_u32 v10, v9, v77, s66
		buffer_load_dwordx4 v10, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[36:37]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
		s_add_i32 m0, s71, 0x4200
		v_add_u32_e32 v10, 0x80, v76
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[38:39]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
		s_add_i32 m0, s71, 0xe6e0
		v_add3_u32 v10, v9, v77, s67
		buffer_load_dwordx4 v10, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[82:83]
		s_and_saveexec_b64 s[82:83], s[40:41]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
		s_add_i32 m0, s71, 0x107e0
		v_add3_u32 v10, v9, v77, s68
		buffer_load_dwordx4 v10, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[82:83]
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[80:83], v40
		ds_read_b128 v[84:87], v40 offset:2112
		ds_read_b128 v[88:91], v40 offset:4224
		ds_read_b128 v[92:95], v40 offset:6336
		ds_read_b64_tr_b16 v[96:97], v41 offset:25312
		ds_read_b64_tr_b16 v[98:99], v41 offset:33760
		ds_read_b64_tr_b16 v[100:101], v41 offset:25440
		ds_read_b64_tr_b16 v[102:103], v41 offset:33888
		ds_read_b64_tr_b16 v[104:105], v41 offset:25568
		ds_read_b64_tr_b16 v[106:107], v41 offset:34016
		ds_read_b64_tr_b16 v[108:109], v41 offset:25696
		ds_read_b64_tr_b16 v[110:111], v41 offset:34144
		v_add_u32_e32 v10, v50, v75
		s_mov_b32 s74, 0
		s_cmp_lg_u32 s16, 0
		v_mov_b32_e32 v112, v4
		v_mov_b32_e32 v113, v5
		v_mov_b32_e32 v114, v6
		v_mov_b32_e32 v115, v7
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		s_waitcnt lgkmcnt(8)
		s_barrier
		s_add_i32 s75, s74, 3
		s_mul_i32 s75, s75, 32
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		s_waitcnt lgkmcnt(0)
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
		s_xor_b32 s75, s75, -1
		s_add_i32 s75, s75, 1
		s_add_i32 s75, s14, s75
		s_mul_hi_u32 s76, s74, 0xaaaaaaab
		s_lshr_b32 s76, s76, 1
		s_mul_i32 s76, s76, 3
		s_xor_b32 s76, s76, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s76, s74, s76
		s_mul_i32 s77, 0x2100, s76
		v_cmp_lt_i32_e64 vcc, v31, s75
		s_mov_b64 s[78:79], vcc
		s_and_saveexec_b64 s[82:83], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
		s_add_i32 m0, s71, s77
		s_lshl_b32 s77, s74, 6
		buffer_load_dwordx4 v10, s[44:47], s77 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[82:83]
		s_barrier
		s_mul_i32 s76, 0x4200, s76
		s_add_i32 s76, s71, s76
		s_mul_i32 s77, s17, s74
		s_lshl_b32 s77, s77, 6
		s_add_i32 s78, s69, s77
		v_cmp_lt_i32_e64 vcc, v11, s75
		s_mov_b64 s[80:81], vcc
		s_and_saveexec_b64 s[82:83], s[80:81]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_10
		s_add_i32 m0, s76, 0x62e0
		v_add3_u32 v69, v9, v77, s78
		buffer_load_dwordx4 v69, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_10:
		s_mov_b64 exec, s[82:83]
		s_add_i32 s77, s70, s77
		v_cmp_lt_i32_e64 vcc, v12, s75
		s_mov_b64 s[78:79], vcc
		s_and_saveexec_b64 s[82:83], s[78:79]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_11
		s_add_i32 m0, s76, 0x83e0
		v_add3_u32 v69, v9, v77, s77
		buffer_load_dwordx4 v69, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_11:
		s_mov_b64 exec, s[82:83]
		s_waitcnt vmcnt(3)
		s_barrier
		s_add_i32 s74, s74, 1
		s_mul_hi_u32 s75, s74, 0xaaaaaaab
		s_lshr_b32 s75, s75, 1
		s_mul_i32 s75, s75, 3
		s_xor_b32 s75, s75, -1
		s_add_i32 s75, s75, 1
		s_add_i32 s75, s74, s75
		s_mul_i32 s76, 0x2100, s75
		v_add3_u32 v69, s76, v36, v39
		v_add3_u32 v69, v69, v42, v44
		ds_read_b128 v[80:83], v69
		ds_read_b128 v[84:87], v69 offset:2112
		ds_read_b128 v[88:91], v69 offset:4224
		ds_read_b128 v[92:95], v69 offset:6336
		s_mul_i32 s75, 0x4200, s75
		v_add_u32_e32 v69, s75, v37
		v_add3_u32 v69, v69, v45, v43
		v_add3_u32 v69, v69, v47, v38
		ds_read_b64_tr_b16 v[96:97], v69 offset:25312
		ds_read_b64_tr_b16 v[98:99], v69 offset:33760
		ds_read_b64_tr_b16 v[100:101], v69 offset:25440
		ds_read_b64_tr_b16 v[102:103], v69 offset:33888
		ds_read_b64_tr_b16 v[104:105], v69 offset:25568
		ds_read_b64_tr_b16 v[106:107], v69 offset:34016
		ds_read_b64_tr_b16 v[108:109], v69 offset:25696
		ds_read_b64_tr_b16 v[110:111], v69 offset:34144
		s_cmp_lt_i32 s74, s23
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[80:83], v51
		ds_read_b128 v[84:87], v51 offset:2112
		ds_read_b128 v[88:91], v51 offset:4224
		ds_read_b128 v[92:95], v51 offset:6336
		s_barrier
		ds_read_b64_tr_b16 v[96:97], v52 offset:25312
		ds_read_b64_tr_b16 v[98:99], v52 offset:33760
		ds_read_b64_tr_b16 v[100:101], v52 offset:25440
		ds_read_b64_tr_b16 v[102:103], v52 offset:33888
		ds_read_b64_tr_b16 v[104:105], v52 offset:25568
		ds_read_b64_tr_b16 v[106:107], v52 offset:34016
		ds_read_b64_tr_b16 v[108:109], v52 offset:25696
		ds_read_b64_tr_b16 v[110:111], v52 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[80:83], v53
		ds_read_b128 v[84:87], v53 offset:2112
		ds_read_b128 v[88:91], v53 offset:4224
		ds_read_b128 v[92:95], v53 offset:6336
		ds_read_b64_tr_b16 v[96:97], v54 offset:25312
		ds_read_b64_tr_b16 v[98:99], v54 offset:33760
		ds_read_b64_tr_b16 v[100:101], v54 offset:25440
		ds_read_b64_tr_b16 v[102:103], v54 offset:33888
		ds_read_b64_tr_b16 v[104:105], v54 offset:25568
		ds_read_b64_tr_b16 v[106:107], v54 offset:34016
		ds_read_b64_tr_b16 v[108:109], v54 offset:25696
		ds_read_b64_tr_b16 v[110:111], v54 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[104:107], v[80:83], v[120:123]
		s_waitcnt lgkmcnt(0)
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
		buffer_load_dwordx2 v[78:79], v71, s[52:55], 0 offen
		v_lshlrev_b32_e32 v10, 1, v72
		buffer_load_dwordx2 v[80:81], v10, s[52:55], 0 offen
		v_lshlrev_b32_e32 v10, 1, v73
		buffer_load_dwordx2 v[72:73], v10, s[52:55], 0 offen
		v_lshlrev_b32_e32 v10, 1, v74
		buffer_load_dwordx2 v[74:75], v10, s[52:55], 0 offen
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v84, v78
		v_cvt_f32_f16_sdwa v85, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v79
		v_cvt_f32_f16_sdwa v87, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v88, v80
		v_cvt_f32_f16_sdwa v89, v80 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v81
		v_cvt_f32_f16_sdwa v91, v81 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v80, v72
		v_cvt_f32_f16_sdwa v81, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v73
		v_cvt_f32_f16_sdwa v83, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v92, v74
		v_cvt_f32_f16_sdwa v93, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v75
		v_cvt_f32_f16_sdwa v95, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_lshl_add_u32 v10, v57, 1, v77
		buffer_load_dwordx4 v[72:75], v10, s[4:7], 0 offen
		v_lshl_add_u32 v10, v13, 1, v77
		buffer_load_dwordx4 v[96:99], v10, s[4:7], 0 offen
		v_lshl_add_u32 v10, v59, 1, v77
		buffer_load_dwordx4 v[100:103], v10, s[4:7], 0 offen
		v_lshl_add_u32 v10, v62, 1, v77
		buffer_load_dwordx4 v[104:107], v10, s[4:7], 0 offen
		v_lshl_add_u32 v10, v64, 1, v77
		buffer_load_dwordx4 v[108:111], v10, s[4:7], 0 offen
		v_mul_lo_u32 v10, s18, v66
		v_lshl_add_u32 v10, v10, 1, v77
		buffer_load_dwordx4 v[176:179], v10, s[4:7], 0 offen
		v_mul_lo_u32 v10, s18, v67
		v_lshl_add_u32 v10, v10, 1, v77
		buffer_load_dwordx4 v[180:183], v10, s[4:7], 0 offen
		v_mul_lo_u32 v10, s18, v68
		v_lshl_add_u32 v10, v10, 1, v77
		buffer_load_dwordx4 v[76:79], v10, s[4:7], 0 offen
		s_barrier
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v66, v72
		v_cvt_f32_f16_sdwa v67, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v73
		v_cvt_f32_f16_sdwa v69, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v72, v74
		v_cvt_f32_f16_sdwa v73, v74 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v184, v75
		v_cvt_f32_f16_sdwa v185, v75 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v74, v96
		v_cvt_f32_f16_sdwa v75, v96 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v186, v97
		v_cvt_f32_f16_sdwa v187, v97 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v98
		v_cvt_f32_f16_sdwa v97, v98 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v188, v99
		v_cvt_f32_f16_sdwa v189, v99 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v98, v100
		v_cvt_f32_f16_sdwa v99, v100 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v190, v101
		v_cvt_f32_f16_sdwa v191, v101 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v100, v102
		v_cvt_f32_f16_sdwa v101, v102 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v192, v103
		v_cvt_f32_f16_sdwa v193, v103 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v102, v104
		v_cvt_f32_f16_sdwa v103, v104 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v194, v105
		v_cvt_f32_f16_sdwa v195, v105 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v106
		v_cvt_f32_f16_sdwa v105, v106 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v196, v107
		v_cvt_f32_f16_sdwa v197, v107 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v106, v108
		v_cvt_f32_f16_sdwa v107, v108 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v198, v109
		v_cvt_f32_f16_sdwa v199, v109 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v108, v110
		v_cvt_f32_f16_sdwa v109, v110 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v200, v111
		v_cvt_f32_f16_sdwa v201, v111 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v110, v176
		v_cvt_f32_f16_sdwa v111, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v202, v177
		v_cvt_f32_f16_sdwa v203, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v176, v178
		v_cvt_f32_f16_sdwa v177, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v204, v179
		v_cvt_f32_f16_sdwa v205, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v178, v180
		v_cvt_f32_f16_sdwa v179, v180 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v206, v181
		v_cvt_f32_f16_sdwa v207, v181 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v180, v182
		v_cvt_f32_f16_sdwa v181, v182 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v208, v183
		v_cvt_f32_f16_sdwa v209, v183 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v182, v76
		v_cvt_f32_f16_sdwa v183, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v210, v77
		v_cvt_f32_f16_sdwa v211, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v76, v78
		v_cvt_f32_f16_sdwa v77, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v212, v79
		v_cvt_f32_f16_sdwa v213, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[78:79], v[84:85]
		v_mov_b64_e32 v[84:85], v[112:113]
		v_pk_add_f32 v[216:217], v[84:85], v[78:79]
		v_mov_b64_e32 v[84:85], v[86:87]
		v_mov_b64_e32 v[86:87], v[114:115]
		v_pk_add_f32 v[218:219], v[86:87], v[84:85]
		ds_write_b128 v55, v[216:219] offset:10432
		v_mov_b64_e32 v[86:87], v[88:89]
		v_mov_b64_e32 v[88:89], v[116:117]
		v_pk_add_f32 v[112:113], v[88:89], v[86:87]
		v_mov_b64_e32 v[88:89], v[90:91]
		v_mov_b64_e32 v[90:91], v[118:119]
		v_pk_add_f32 v[114:115], v[90:91], v[88:89]
		ds_write_b128 v55, v[112:115] offset:18624
		v_mov_b64_e32 v[90:91], v[80:81]
		v_mov_b64_e32 v[80:81], v[120:121]
		v_pk_add_f32 v[112:113], v[80:81], v[90:91]
		v_mov_b64_e32 v[80:81], v[82:83]
		v_mov_b64_e32 v[82:83], v[122:123]
		v_pk_add_f32 v[114:115], v[82:83], v[80:81]
		ds_write_b128 v55, v[112:115] offset:26816
		v_mov_b64_e32 v[82:83], v[92:93]
		v_mov_b64_e32 v[92:93], v[124:125]
		v_pk_add_f32 v[112:113], v[92:93], v[82:83]
		v_mov_b64_e32 v[92:93], v[94:95]
		v_mov_b64_e32 v[94:95], v[126:127]
		v_pk_add_f32 v[114:115], v[94:95], v[92:93]
		ds_write_b128 v55, v[112:115] offset:35008
		v_mov_b64_e32 v[94:95], v[128:129]
		v_pk_add_f32 v[112:113], v[94:95], v[78:79]
		v_mov_b64_e32 v[94:95], v[130:131]
		v_pk_add_f32 v[114:115], v[94:95], v[84:85]
		v_mov_b64_e32 v[94:95], v[132:133]
		v_pk_add_f32 v[116:117], v[94:95], v[86:87]
		v_mov_b64_e32 v[94:95], v[134:135]
		v_pk_add_f32 v[118:119], v[94:95], v[88:89]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b64_e32 v[94:95], v[136:137]
		v_pk_add_f32 v[120:121], v[94:95], v[90:91]
		v_mov_b64_e32 v[94:95], v[138:139]
		v_pk_add_f32 v[122:123], v[94:95], v[80:81]
		v_mov_b64_e32 v[94:95], v[140:141]
		v_pk_add_f32 v[124:125], v[94:95], v[82:83]
		v_mov_b64_e32 v[94:95], v[142:143]
		v_pk_add_f32 v[126:127], v[94:95], v[92:93]
		v_mov_b64_e32 v[94:95], v[144:145]
		v_pk_add_f32 v[128:129], v[94:95], v[78:79]
		v_mov_b64_e32 v[94:95], v[146:147]
		v_pk_add_f32 v[130:131], v[94:95], v[84:85]
		v_mov_b64_e32 v[94:95], v[148:149]
		v_pk_add_f32 v[132:133], v[94:95], v[86:87]
		v_mov_b64_e32 v[94:95], v[150:151]
		v_pk_add_f32 v[134:135], v[94:95], v[88:89]
		v_mov_b64_e32 v[94:95], v[152:153]
		v_pk_add_f32 v[136:137], v[94:95], v[90:91]
		v_mov_b64_e32 v[94:95], v[154:155]
		v_pk_add_f32 v[138:139], v[94:95], v[80:81]
		v_mov_b64_e32 v[94:95], v[156:157]
		v_pk_add_f32 v[140:141], v[94:95], v[82:83]
		v_mov_b64_e32 v[94:95], v[158:159]
		v_pk_add_f32 v[142:143], v[94:95], v[92:93]
		v_mov_b64_e32 v[94:95], v[160:161]
		v_pk_add_f32 v[144:145], v[94:95], v[78:79]
		v_mov_b64_e32 v[78:79], v[162:163]
		v_pk_add_f32 v[146:147], v[78:79], v[84:85]
		v_mov_b64_e32 v[78:79], v[164:165]
		v_pk_add_f32 v[148:149], v[78:79], v[86:87]
		v_mov_b64_e32 v[78:79], v[166:167]
		v_pk_add_f32 v[150:151], v[78:79], v[88:89]
		v_mov_b64_e32 v[78:79], v[168:169]
		v_pk_add_f32 v[84:85], v[78:79], v[90:91]
		v_mov_b64_e32 v[78:79], v[170:171]
		v_pk_add_f32 v[86:87], v[78:79], v[80:81]
		v_mov_b64_e32 v[78:79], v[172:173]
		v_pk_add_f32 v[88:89], v[78:79], v[82:83]
		v_mov_b64_e32 v[78:79], v[174:175]
		v_pk_add_f32 v[90:91], v[78:79], v[92:93]
		ds_read_b128 v[80:83], v1 offset:10432
		ds_read_b128 v[92:95], v1 offset:10688
		ds_read_b128 v[152:155], v1 offset:14528
		ds_read_b128 v[156:159], v1 offset:14784
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v55, v[112:115] offset:10432
		ds_write_b128 v55, v[116:119] offset:18624
		ds_write_b128 v55, v[120:123] offset:26816
		ds_write_b128 v55, v[124:127] offset:35008
		v_mov_b64_e32 v[78:79], v[80:81]
		v_pk_fma_f32 v[112:113], v[78:79], v[66:67], v[78:79]
		v_mov_b64_e32 v[66:67], v[82:83]
		v_pk_fma_f32 v[114:115], v[66:67], v[68:69], v[66:67]
		v_mov_b64_e32 v[66:67], v[92:93]
		v_pk_fma_f32 v[116:117], v[66:67], v[72:73], v[66:67]
		v_mov_b64_e32 v[66:67], v[94:95]
		v_pk_fma_f32 v[118:119], v[66:67], v[184:185], v[66:67]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v1 offset:10432
		ds_read_b128 v[92:95], v1 offset:10688
		ds_read_b128 v[120:123], v1 offset:14528
		ds_read_b128 v[124:127], v1 offset:14784
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v55, v[128:131] offset:10432
		ds_write_b128 v55, v[132:135] offset:18624
		ds_write_b128 v55, v[136:139] offset:26816
		ds_write_b128 v55, v[140:143] offset:35008
		v_mov_b64_e32 v[66:67], v[152:153]
		v_pk_fma_f32 v[128:129], v[66:67], v[74:75], v[66:67]
		v_mov_b64_e32 v[66:67], v[154:155]
		v_pk_fma_f32 v[130:131], v[66:67], v[186:187], v[66:67]
		v_mov_b64_e32 v[66:67], v[156:157]
		v_pk_fma_f32 v[132:133], v[66:67], v[96:97], v[66:67]
		v_mov_b64_e32 v[66:67], v[158:159]
		v_pk_fma_f32 v[134:135], v[66:67], v[188:189], v[66:67]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v1 offset:10432
		ds_read_b128 v[136:139], v1 offset:10688
		ds_read_b128 v[140:143], v1 offset:14528
		ds_read_b128 v[152:155], v1 offset:14784
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v55, v[144:147] offset:10432
		ds_write_b128 v55, v[148:151] offset:18624
		ds_write_b128 v55, v[84:87] offset:26816
		ds_write_b128 v55, v[88:91] offset:35008
		v_mov_b64_e32 v[66:67], v[80:81]
		v_pk_fma_f32 v[144:145], v[66:67], v[98:99], v[66:67]
		v_mov_b64_e32 v[66:67], v[82:83]
		v_pk_fma_f32 v[146:147], v[66:67], v[190:191], v[66:67]
		v_mov_b64_e32 v[66:67], v[92:93]
		v_pk_fma_f32 v[148:149], v[66:67], v[100:101], v[66:67]
		v_mov_b64_e32 v[66:67], v[94:95]
		v_pk_fma_f32 v[150:151], v[66:67], v[192:193], v[66:67]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[80:83], v1 offset:10432
		ds_read_b128 v[84:87], v1 offset:10688
		ds_read_b128 v[88:91], v1 offset:14528
		ds_read_b128 v[92:95], v1 offset:14784
		v_mov_b64_e32 v[66:67], v[120:121]
		v_pk_fma_f32 v[160:161], v[66:67], v[102:103], v[66:67]
		v_mov_b64_e32 v[66:67], v[122:123]
		v_pk_fma_f32 v[162:163], v[66:67], v[194:195], v[66:67]
		v_mov_b64_e32 v[66:67], v[124:125]
		v_pk_fma_f32 v[164:165], v[66:67], v[104:105], v[66:67]
		v_mov_b64_e32 v[66:67], v[126:127]
		v_pk_fma_f32 v[166:167], v[66:67], v[196:197], v[66:67]
		v_mov_b64_e32 v[66:67], v[72:73]
		v_pk_fma_f32 v[96:97], v[66:67], v[106:107], v[66:67]
		v_mov_b64_e32 v[66:67], v[74:75]
		v_pk_fma_f32 v[98:99], v[66:67], v[198:199], v[66:67]
		v_mov_b64_e32 v[66:67], v[136:137]
		v_pk_fma_f32 v[100:101], v[66:67], v[108:109], v[66:67]
		v_mov_b64_e32 v[66:67], v[138:139]
		v_pk_fma_f32 v[102:103], v[66:67], v[200:201], v[66:67]
		v_mov_b64_e32 v[66:67], v[140:141]
		v_pk_fma_f32 v[120:121], v[66:67], v[110:111], v[66:67]
		v_mov_b64_e32 v[66:67], v[142:143]
		v_pk_fma_f32 v[122:123], v[66:67], v[202:203], v[66:67]
		v_mov_b64_e32 v[66:67], v[152:153]
		v_pk_fma_f32 v[124:125], v[66:67], v[176:177], v[66:67]
		v_mov_b64_e32 v[66:67], v[154:155]
		v_pk_fma_f32 v[126:127], v[66:67], v[204:205], v[66:67]
		s_waitcnt lgkmcnt(3)
		v_mov_b64_e32 v[66:67], v[80:81]
		v_pk_fma_f32 v[104:105], v[66:67], v[178:179], v[66:67]
		v_mov_b64_e32 v[66:67], v[82:83]
		v_pk_fma_f32 v[106:107], v[66:67], v[206:207], v[66:67]
		s_waitcnt lgkmcnt(2)
		v_mov_b64_e32 v[66:67], v[84:85]
		v_pk_fma_f32 v[108:109], v[66:67], v[180:181], v[66:67]
		v_mov_b64_e32 v[66:67], v[86:87]
		v_pk_fma_f32 v[110:111], v[66:67], v[208:209], v[66:67]
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[66:67], v[88:89]
		v_pk_fma_f32 v[80:81], v[66:67], v[182:183], v[66:67]
		v_mov_b64_e32 v[66:67], v[90:91]
		v_pk_fma_f32 v[82:83], v[66:67], v[210:211], v[66:67]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[66:67], v[92:93]
		v_pk_fma_f32 v[84:85], v[66:67], v[76:77], v[66:67]
		v_mov_b64_e32 v[66:67], v[94:95]
		v_pk_fma_f32 v[86:87], v[66:67], v[212:213], v[66:67]
		v_cmp_lt_i32_e64 vcc, v70, s13
		s_mov_b64 s[74:75], vcc
		v_cmp_lt_i32_e64 vcc, v15, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v68, v112, v113
		v_cvt_pk_f16_f32 v69, v114, v115
		v_cvt_pk_f16_f32 v70, v116, v117
		v_cvt_pk_f16_f32 v71, v118, v119
		s_lshl_b32 s3, s3, 10
		s_add_i32 s71, s73, s3
		s_lshl_b32 s72, s72, 8
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[68:71], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v48, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v68, v128, v129
		v_cvt_pk_f16_f32 v69, v130, v131
		v_cvt_pk_f16_f32 v70, v132, v133
		v_cvt_pk_f16_f32 v71, v134, v135
		s_add_i32 s71, s21, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[68:71], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v56, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v68, v144, v145
		v_cvt_pk_f16_f32 v69, v146, v147
		v_cvt_pk_f16_f32 v70, v148, v149
		v_cvt_pk_f16_f32 v71, v150, v151
		s_add_i32 s71, s42, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[68:71], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v58, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v56, v160, v161
		v_cvt_pk_f16_f32 v57, v162, v163
		v_cvt_pk_f16_f32 v58, v164, v165
		v_cvt_pk_f16_f32 v59, v166, v167
		s_add_i32 s71, s43, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[56:59], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v60, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v56, v96, v97
		v_cvt_pk_f16_f32 v57, v98, v99
		v_cvt_pk_f16_f32 v58, v100, v101
		v_cvt_pk_f16_f32 v59, v102, v103
		s_add_i32 s71, s60, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[56:59], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v61, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v56, v120, v121
		v_cvt_pk_f16_f32 v57, v122, v123
		v_cvt_pk_f16_f32 v58, v124, v125
		v_cvt_pk_f16_f32 v59, v126, v127
		s_add_i32 s71, s61, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[56:59], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v63, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v56, v104, v105
		v_cvt_pk_f16_f32 v57, v106, v107
		v_cvt_pk_f16_f32 v58, v108, v109
		v_cvt_pk_f16_f32 v59, v110, v111
		s_add_i32 s71, s62, s73
		s_add_i32 s71, s71, s3
		s_add_i32 s71, s71, s72
		v_add3_u32 v10, s71, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[56:59], v10, s[56:59], 0 offen
		v_cmp_lt_i32_e64 vcc, v65, s12
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s76, s74
		s_and_b32 s79, s77, s75
		v_cvt_pk_f16_f32 v56, v80, v81
		v_cvt_pk_f16_f32 v57, v82, v83
		v_cvt_pk_f16_f32 v58, v84, v85
		v_cvt_pk_f16_f32 v59, v86, v87
		s_add_i32 s71, s63, s73
		s_add_i32 s3, s71, s3
		s_add_i32 s3, s3, s72
		v_add3_u32 v10, s3, v3, v8
		v_cndmask_b32_e64 v10, v46, v10, s[78:79]
		buffer_store_dwordx4 v[56:59], v10, s[56:59], 0 offen
		s_cmp_lt_i32 s2, s20
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_0
.Ltlx_addmm_glu_kernel_persistent.loop_exit_0:
		s_waitcnt vmcnt(0)
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
		.amdhsa_next_free_vgpr 220
		.amdhsa_next_free_sgpr 84
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 220
	.set .Ltlx_addmm_glu_kernel_persistent.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_persistent.numbered_sgpr, 84
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
    .sgpr_count:     84
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     220
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
