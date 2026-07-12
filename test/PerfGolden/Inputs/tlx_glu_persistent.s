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
		v_mad_u32_u24 v2, v2, 2, v5
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v5, 1, v4
		v_mad_u32_u24 v2, v5, 8, v2
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v6, 1, v5
		v_mov_b32_e32 v7, 16
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v8, 1, v6
		v_add3_u32 v2, v2, v7, v8
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v10, 1, v9
		v_mad_u32_u24 v2, v10, 32, v2
		v_lshrrev_b32_e32 v11, 8, v0
		v_and_b32_e32 v12, 1, v11
		v_mad_u32_u24 v2, v12, 64, v2
		v_and_b32_e32 v13, 15, v5
		v_add_u32_e32 v14, 16, v13
		v_add_u32_e32 v15, 32, v13
		v_add_u32_e32 v16, 48, v13
		v_add_u32_e32 v17, 64, v13
		v_add_u32_e32 v18, 0x50, v13
		v_add_u32_e32 v19, 0x60, v13
		v_add_u32_e32 v20, 0x70, v13
		v_and_b32_e32 v21, 31, v0
		v_mov_b32_e32 v22, 8
		v_mul_lo_u32 v22, v22, v21
		v_and_b32_e32 v21, 15, v4
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_add_u32_e32 v21, 64, v23
		v_add_u32_e32 v24, 0x80, v23
		v_add_u32_e32 v25, 0xc0, v23
		s_add_i32 s21, s14, 31
		s_mov_b32 s22, 31
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 5
		v_and_b32_e32 v26, 3, v0
		v_mov_b32_e32 v27, 8
		v_mul_lo_u32 v27, v27, v26
		v_add_u32_e32 v7, v7, v8
		v_mad_u32_u24 v7, v10, 2, v7
		v_mad_u32_u24 v7, v12, 8, v7
		v_add_u32_e32 v8, 4, v7
		v_cmp_lt_i32_e64 vcc, v27, s14
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v7, s14
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v8, s14
		s_mov_b64 s[28:29], vcc
		s_add_i32 s23, s14, 0xffffffe0
		v_cmp_lt_i32_e64 vcc, v27, s23
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v8, s23
		s_mov_b64 s[34:35], vcc
		s_add_i32 s23, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v27, s23
		s_mov_b64 s[36:37], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v8, s23
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
		s_mov_b32 s2, s16
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s8, s1, -1
		s_add_i32 s8, s8, 1
		v_mov_b32_e32 v10, 0x4f7ffffe
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
		v_mov_b32_e32 v12, s12
		v_mov_b32_e32 v26, s43
		v_cndmask_b32_e64 v12, v12, v26, s[62:63]
		v_cvt_f32_u32_e32 v26, v12
		v_rcp_iflag_f32_e32 v26, v26
		v_xad_u32 v28, v12, -1, 1
		v_mul_f32_e32 v26, v10, v26
		v_cvt_u32_f32_e32 v26, v26
		v_mul_lo_u32 v29, v28, v26
		v_mul_hi_u32 v29, v26, v29
		v_add_u32_e32 v26, v26, v29
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s62, s10, s60
		s_cselect_b32 s63, s11, s61
		s_xor_b32 s10, s13, -1
		s_add_i32 s10, s10, 1
		v_mov_b32_e32 v29, s13
		v_mov_b32_e32 v30, s10
		v_cndmask_b32_e64 v29, v29, v30, s[62:63]
		v_cvt_f32_u32_e32 v30, v29
		v_rcp_iflag_f32_e32 v30, v30
		v_xad_u32 v31, v29, -1, 1
		v_mul_f32_e32 v30, v10, v30
		v_cvt_u32_f32_e32 v30, v30
		v_mul_lo_u32 v32, v31, v30
		v_mul_hi_u32 v32, v30, v32
		v_add_u32_e32 v30, v30, v32
		v_and_b32_e32 v32, 1, v0
		v_lshrrev_b32_e32 v33, 1, v0
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v34, 5, v33
		v_lshl_add_u32 v34, v32, 4, v34
		v_mov_b32_e32 v35, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v36, s17, v11
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v37, s17, v9
		v_lshlrev_b32_e32 v37, 2, v37
		v_lshl_add_u32 v36, v36, 4, v37
		v_and_b32_e32 v37, 1, v6
		v_mul_lo_u32 v38, s17, v37
		v_lshl_add_u32 v36, v38, 1, v36
		v_and_b32_e32 v38, 1, v5
		v_mul_lo_u32 v39, s17, v38
		v_lshl_add_u32 v36, v39, 5, v36
		s_lshl_b32 s10, s17, 3
		s_lshl_b32 s11, s17, 6
		s_mul_i32 s43, 0x48, s17
		s_lshl_b32 s60, s17, 7
		s_mul_i32 s61, 0x88, s17
		v_and_b32_e32 v39, 63, v0
		v_lshrrev_b32_e32 v40, 4, v39
		v_lshlrev_b32_e32 v41, 4, v40
		v_lshl_add_u32 v41, v11, 9, v41
		v_and_b32_e32 v42, 15, v39
		v_lshrrev_b32_e32 v43, 1, v42
		v_lshlrev_b32_e32 v43, 6, v43
		v_and_b32_e32 v44, 1, v42
		v_mov_b32_e32 v45, 0x420
		v_mul_lo_u32 v45, v45, v44
		v_add3_u32 v41, v41, v43, v45
		v_lshrrev_b32_e32 v39, 5, v39
		v_lshrrev_b32_e32 v43, 2, v42
		v_mov_b32_e32 v44, 0x420
		v_mul_lo_u32 v44, v44, v43
		v_lshl_add_u32 v39, v39, 9, v44
		v_and_b32_e32 v6, 3, v6
		v_lshlrev_b32_e32 v6, 5, v6
		v_and_b32_e32 v40, 1, v40
		v_mov_b32_e32 v43, 0x1080
		v_mul_lo_u32 v43, v43, v40
		v_add3_u32 v6, v39, v6, v43
		v_and_b32_e32 v39, 3, v42
		v_lshl_add_u32 v6, v39, 3, v6
		v_add_u32_e32 v39, 0xc0, v34
		s_lshl_b32 s62, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s63, 0xc0, s17
		s_mul_i32 s64, 0xc8, s17
		s_mul_i32 s65, 0x2100, s42
		v_add_u32_e32 v40, s65, v41
		s_mul_i32 s42, 0x4200, s42
		v_add_u32_e32 v42, s42, v6
		s_mul_i32 s42, 0x2100, s21
		v_add_u32_e32 v43, s42, v41
		s_mul_i32 s21, 0x4200, s21
		v_add_u32_e32 v44, s21, v6
		v_lshlrev_b32_e32 v45, 6, v11
		v_lshlrev_b32_e32 v46, 8, v9
		v_lshlrev_b32_e32 v47, 3, v37
		v_lshlrev_b32_e32 v48, 2, v38
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v49, 7, v4
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v50, 0x1020
		v_mul_lo_u32 v50, v50, v3
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v51, 0x810
		v_mul_lo_u32 v51, v51, v1
		v_mov_b32_e32 v52, 0x204
		v_mul_lo_u32 v52, v52, v32
		v_mov_b32_e32 v53, 0x408
		v_mul_lo_u32 v53, v53, v33
		v_bitop3_b32 v51, v51, v52, v53 bitop3:0x96
		v_bitop3_b32 v49, v49, v50, v51 bitop3:0x96
		v_bitop3_b32 v47, v47, v48, v49 bitop3:0x96
		v_bitop3_b32 v45, v45, v46, v47 bitop3:0x96
		v_lshlrev_b32_e32 v46, 2, v45
		v_add_u32_e32 v46, 0x10000, v46
		v_xor_b32_e32 v47, 16, v45
		v_lshlrev_b32_e32 v47, 2, v47
		v_add_u32_e32 v47, 0x10000, v47
		v_xor_b32_e32 v48, 32, v45
		v_lshlrev_b32_e32 v48, 2, v48
		v_add_u32_e32 v48, 0x10000, v48
		v_xor_b32_e32 v45, 48, v45
		v_lshlrev_b32_e32 v45, 2, v45
		v_add_u32_e32 v45, 0x10000, v45
		v_mov_b32_e32 v49, 0x1020
		v_mul_lo_u32 v49, v49, v11
		v_mov_b32_e32 v11, 0x810
		v_mul_lo_u32 v11, v11, v9
		v_mov_b32_e32 v9, 0x408
		v_mul_lo_u32 v9, v9, v37
		v_mov_b32_e32 v37, 0x204
		v_mul_lo_u32 v37, v37, v38
		v_lshlrev_b32_e32 v4, 5, v4
		v_lshlrev_b32_e32 v1, 8, v1
		v_lshl_add_u32 v1, v32, 2, v1
		v_lshl_add_u32 v1, v33, 3, v1
		v_lshlrev_b32_e32 v3, 4, v3
		v_bitop3_b32 v1, v4, v1, v3 bitop3:0x96
		v_bitop3_b32 v1, v9, v37, v1 bitop3:0x96
		v_bitop3_b32 v1, v49, v11, v1 bitop3:0x96
		v_lshlrev_b32_e32 v1, 2, v1
		v_add_u32_e32 v1, 0x10000, v1
		v_mul_lo_u32 v3, s19, v5
		v_lshlrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v4, 31, v0
		v_lshlrev_b32_e32 v4, 4, v4
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
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s71, 1, 0
		s_xor_b32 s72, s16, -1
		s_add_i32 s72, s72, 1
		s_cmp_lg_u32 s71, 0
		s_cselect_b32 s71, s72, s16
		s_cselect_b32 s72, 1, 0
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s73, s8, s1
		v_mov_b32_e32 v5, s73
		v_cvt_f32_u32_e32 v5, v5
		v_rcp_iflag_f32_e32 v5, v5
		s_xor_b32 s74, s73, -1
		v_mul_f32_e32 v5, v10, v5
		v_cvt_u32_f32_e32 v5, v5
		s_add_i32 s74, s74, 1
		v_readfirstlane_b32 s75, v5
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
		v_mov_b32_e32 v5, s75
		v_cvt_f32_u32_e32 v5, v5
		v_rcp_iflag_f32_e32 v5, v5
		s_xor_b32 s77, s75, -1
		v_mul_f32_e32 v5, v10, v5
		v_cvt_u32_f32_e32 v5, v5
		s_add_i32 s77, s77, 1
		v_readfirstlane_b32 s78, v5
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
		v_add_u32_e32 v5, s73, v2
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v9, v5, -1, 1
		v_add_u32_e32 v11, s73, v13
		v_cndmask_b32_e32 v5, v5, v9, vcc
		v_mul_hi_u32 v9, v5, v26
		v_mul_lo_u32 v9, v9, v12
		v_xor_b32_e32 v9, -1, v9
		v_add3_u32 v5, 1, v9, v5
		v_add_u32_e32 v9, v5, v28
		v_cmp_ge_u32_e64 vcc, v5, v12
		v_add_u32_e32 v32, s73, v14
		v_add_u32_e32 v33, s73, v15
		v_cndmask_b32_e32 v5, v5, v9, vcc
		v_add_u32_e32 v9, v5, v28
		v_cmp_ge_u32_e64 vcc, v5, v12
		v_add_u32_e32 v37, s73, v16
		v_add_u32_e32 v38, s73, v17
		v_cndmask_b32_e32 v5, v5, v9, vcc
		v_xad_u32 v9, v5, -1, 1
		v_cmp_lt_i32_e64 vcc, v11, s9
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v49, v11, -1, 1
		v_add_u32_e32 v50, s73, v18
		v_cndmask_b32_e32 v49, v11, v49, vcc
		v_mul_hi_u32 v51, v49, v26
		v_mul_lo_u32 v51, v51, v12
		v_xor_b32_e32 v51, -1, v51
		v_add3_u32 v49, 1, v51, v49
		v_add_u32_e32 v51, v49, v28
		v_cmp_ge_u32_e64 vcc, v49, v12
		v_add_u32_e32 v52, s73, v19
		v_add_u32_e32 v53, s73, v20
		v_cndmask_b32_e32 v49, v49, v51, vcc
		v_cmp_ge_u32_e64 vcc, v49, v12
		v_cndmask_b32_e64 v5, v5, v9, s[74:75]
		v_add_u32_e32 v9, v49, v28
		v_cndmask_b32_e32 v9, v49, v9, vcc
		v_xad_u32 v49, v9, -1, 1
		v_cmp_lt_i32_e64 vcc, v32, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v51, v32, -1, 1
		v_cndmask_b32_e64 v9, v9, v49, s[76:77]
		v_cndmask_b32_e32 v49, v32, v51, vcc
		v_mul_hi_u32 v51, v49, v26
		v_mul_lo_u32 v51, v51, v12
		v_xor_b32_e32 v51, -1, v51
		v_add3_u32 v49, 1, v51, v49
		v_cmp_ge_u32_e64 vcc, v49, v12
		v_add_u32_e32 v51, v49, v28
		v_xad_u32 v54, v33, -1, 1
		v_cndmask_b32_e32 v49, v49, v51, vcc
		v_cmp_ge_u32_e64 vcc, v49, v12
		v_add_u32_e32 v51, v49, v28
		v_xad_u32 v55, v37, -1, 1
		v_cndmask_b32_e32 v49, v49, v51, vcc
		v_xad_u32 v51, v49, -1, 1
		v_cmp_lt_i32_e64 vcc, v33, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v49, v49, v51, s[74:75]
		v_xad_u32 v51, v38, -1, 1
		v_cndmask_b32_e32 v54, v33, v54, vcc
		v_mul_hi_u32 v56, v54, v26
		v_mul_lo_u32 v56, v56, v12
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v54, 1, v56, v54
		v_cmp_ge_u32_e64 vcc, v54, v12
		v_add_u32_e32 v56, v54, v28
		s_add_i32 s2, s2, 0x100
		v_cndmask_b32_e32 v54, v54, v56, vcc
		v_cmp_ge_u32_e64 vcc, v54, v12
		v_add_u32_e32 v56, v54, v28
		v_xad_u32 v57, v50, -1, 1
		v_cndmask_b32_e32 v54, v54, v56, vcc
		v_xad_u32 v56, v54, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v54, v54, v56, s[76:77]
		s_mul_i32 s72, s19, s72
		v_cndmask_b32_e32 v55, v37, v55, vcc
		v_mul_hi_u32 v56, v55, v26
		v_mul_lo_u32 v56, v56, v12
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v55, 1, v56, v55
		v_cmp_ge_u32_e64 vcc, v55, v12
		v_add_u32_e32 v56, v55, v28
		s_mul_i32 s16, s19, s16
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_cmp_ge_u32_e64 vcc, v55, v12
		v_add_u32_e32 v56, v55, v28
		v_xad_u32 v58, v52, -1, 1
		v_cndmask_b32_e32 v55, v55, v56, vcc
		v_xad_u32 v56, v55, -1, 1
		v_cmp_lt_i32_e64 vcc, v38, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v55, v55, v56, s[74:75]
		s_lshl_b32 s73, s71, 9
		v_cndmask_b32_e32 v51, v38, v51, vcc
		v_mul_hi_u32 v56, v51, v26
		v_mul_lo_u32 v56, v56, v12
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v51, 1, v56, v51
		v_cmp_ge_u32_e64 vcc, v51, v12
		v_add_u32_e32 v56, v51, v28
		v_xad_u32 v59, v53, -1, 1
		v_cndmask_b32_e32 v51, v51, v56, vcc
		v_cmp_ge_u32_e64 vcc, v51, v12
		v_add_u32_e32 v56, v51, v28
		s_mul_i32 s71, s71, 0x100
		v_cndmask_b32_e32 v51, v51, v56, vcc
		v_xad_u32 v56, v51, -1, 1
		v_cmp_lt_i32_e64 vcc, v50, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v51, v51, v56, s[76:77]
		v_mul_lo_u32 v51, s18, v51
		v_cndmask_b32_e32 v56, v50, v57, vcc
		v_mul_hi_u32 v57, v56, v26
		v_mul_lo_u32 v57, v57, v12
		v_xor_b32_e32 v57, -1, v57
		v_add3_u32 v56, 1, v57, v56
		v_cmp_ge_u32_e64 vcc, v56, v12
		v_add_u32_e32 v57, v56, v28
		v_add_u32_e32 v60, s71, v22
		v_cndmask_b32_e32 v56, v56, v57, vcc
		v_cmp_ge_u32_e64 vcc, v56, v12
		v_add_u32_e32 v57, v56, v28
		v_xad_u32 v61, v60, -1, 1
		v_cndmask_b32_e32 v56, v56, v57, vcc
		v_xad_u32 v57, v56, -1, 1
		v_cmp_lt_i32_e64 vcc, v52, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v56, v56, v57, s[74:75]
		v_mul_lo_u32 v56, s18, v56
		v_cndmask_b32_e32 v57, v52, v58, vcc
		v_mul_hi_u32 v58, v57, v26
		v_mul_lo_u32 v58, v58, v12
		v_xor_b32_e32 v58, -1, v58
		v_add3_u32 v57, 1, v58, v57
		v_cmp_ge_u32_e64 vcc, v57, v12
		v_add_u32_e32 v58, v57, v28
		v_add_u32_e32 v62, s71, v23
		v_cndmask_b32_e32 v57, v57, v58, vcc
		v_cmp_ge_u32_e64 vcc, v57, v12
		v_add_u32_e32 v58, v57, v28
		v_add_u32_e32 v63, s71, v21
		v_cndmask_b32_e32 v57, v57, v58, vcc
		v_xad_u32 v58, v57, -1, 1
		v_cmp_lt_i32_e64 vcc, v53, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v57, v57, v58, s[76:77]
		v_add_u32_e32 v58, s71, v24
		v_cndmask_b32_e32 v59, v53, v59, vcc
		v_mul_hi_u32 v64, v59, v26
		v_mul_lo_u32 v64, v64, v12
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v59, 1, v64, v59
		v_cmp_ge_u32_e64 vcc, v59, v12
		v_add_u32_e32 v64, v59, v28
		v_add_u32_e32 v65, s71, v25
		v_cndmask_b32_e32 v59, v59, v64, vcc
		v_cmp_ge_u32_e64 vcc, v59, v12
		v_add_u32_e32 v64, v59, v28
		v_xad_u32 v66, v62, -1, 1
		v_cndmask_b32_e32 v59, v59, v64, vcc
		v_xad_u32 v64, v59, -1, 1
		v_cmp_lt_i32_e64 vcc, v60, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v59, v59, v64, s[74:75]
		v_mul_lo_u32 v55, s18, v55
		v_cndmask_b32_e32 v61, v60, v61, vcc
		v_mul_hi_u32 v64, v61, v30
		v_mul_lo_u32 v64, v64, v29
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v61, 1, v64, v61
		v_add_u32_e32 v64, v61, v31
		v_cmp_ge_u32_e64 vcc, v61, v29
		v_mul_lo_u32 v54, s18, v54
		v_xad_u32 v67, v63, -1, 1
		v_cndmask_b32_e32 v61, v61, v64, vcc
		v_add_u32_e32 v64, v61, v31
		v_cmp_ge_u32_e64 vcc, v61, v29
		v_mul_lo_u32 v49, s18, v49
		v_mul_lo_u32 v9, s18, v9
		v_cndmask_b32_e32 v61, v61, v64, vcc
		v_xad_u32 v64, v61, -1, 1
		v_cmp_lt_i32_e64 vcc, v62, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v61, v61, v64, s[76:77]
		v_xad_u32 v64, v58, -1, 1
		v_cndmask_b32_e32 v62, v62, v66, vcc
		v_mul_hi_u32 v66, v62, v30
		v_mul_lo_u32 v66, v66, v29
		v_xor_b32_e32 v66, -1, v66
		v_add3_u32 v62, 1, v66, v62
		v_cmp_ge_u32_e64 vcc, v62, v29
		v_add_u32_e32 v66, v62, v31
		v_mul_lo_u32 v68, s62, v5
		v_cndmask_b32_e32 v62, v62, v66, vcc
		v_cmp_ge_u32_e64 vcc, v62, v29
		v_add_u32_e32 v66, v62, v31
		v_xad_u32 v69, v65, -1, 1
		v_cndmask_b32_e32 v62, v62, v66, vcc
		v_xad_u32 v66, v62, -1, 1
		v_cmp_lt_i32_e64 vcc, v63, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v62, v62, v66, s[74:75]
		v_lshlrev_b32_e32 v62, 1, v62
		v_cndmask_b32_e32 v63, v63, v67, vcc
		v_mul_hi_u32 v66, v63, v30
		v_mul_lo_u32 v66, v66, v29
		v_xor_b32_e32 v66, -1, v66
		v_add3_u32 v63, 1, v66, v63
		v_cmp_ge_u32_e64 vcc, v63, v29
		v_add_u32_e32 v66, v63, v31
		v_lshlrev_b32_e32 v61, 1, v61
		v_cndmask_b32_e32 v63, v63, v66, vcc
		v_cmp_ge_u32_e64 vcc, v63, v29
		v_add_u32_e32 v66, v63, v31
		v_mul_lo_u32 v5, s15, v5
		v_cndmask_b32_e32 v63, v63, v66, vcc
		v_xad_u32 v66, v63, -1, 1
		v_cmp_lt_i32_e64 vcc, v58, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v63, v63, v66, s[76:77]
		v_readfirstlane_b32 s71, v0
		v_cndmask_b32_e32 v58, v58, v64, vcc
		v_mul_hi_u32 v64, v58, v30
		v_mul_lo_u32 v64, v64, v29
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v58, 1, v64, v58
		v_cmp_ge_u32_e64 vcc, v58, v29
		v_add_u32_e32 v64, v58, v31
		v_lshl_add_u32 v5, v5, 1, v34
		v_cndmask_b32_e32 v58, v58, v64, vcc
		v_cmp_ge_u32_e64 vcc, v58, v29
		v_add_u32_e32 v64, v58, v31
		v_cndmask_b32_e64 v66, v35, v5, s[24:25]
		v_cndmask_b32_e32 v58, v58, v64, vcc
		v_xad_u32 v64, v58, -1, 1
		v_cmp_lt_i32_e64 vcc, v65, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v58, v58, v64, s[74:75]
		s_lshr_b32 s71, s71, 6
		v_cndmask_b32_e32 v64, v65, v69, vcc
		v_mul_hi_u32 v65, v64, v30
		v_mul_lo_u32 v65, v65, v29
		v_xor_b32_e32 v65, -1, v65
		v_add3_u32 v64, 1, v65, v64
		v_cmp_ge_u32_e64 vcc, v64, v29
		v_add_u32_e32 v65, v64, v31
		s_mul_i32 s71, 0x420, s71
		v_cndmask_b32_e32 v64, v64, v65, vcc
		v_cmp_ge_u32_e64 vcc, v64, v29
		v_add_u32_e32 v65, v64, v31
		s_mov_b32 m0, s71
		v_cndmask_b32_e32 v64, v64, v65, vcc
		buffer_load_dwordx4 v66, s[44:47], 0 offen lds
		v_xad_u32 v65, v64, -1, 1
		v_add_u32_e32 v66, v36, v61
		s_add_i32 m0, s71, 0x62e0
		v_cndmask_b32_e64 v67, v35, v66, s[26:27]
		buffer_load_dwordx4 v67, s[48:51], 0 offen lds
		v_add_u32_e32 v67, s10, v66
		s_add_i32 m0, s71, 0x83e0
		v_cndmask_b32_e64 v67, v35, v67, s[28:29]
		buffer_load_dwordx4 v67, s[48:51], 0 offen lds
		v_add_u32_e32 v67, 64, v5
		s_add_i32 m0, s71, 0x2100
		v_cndmask_b32_e64 v67, v35, v67, s[30:31]
		buffer_load_dwordx4 v67, s[44:47], 0 offen lds
		v_add_u32_e32 v67, s11, v66
		s_add_i32 m0, s71, 0xa4e0
		v_cndmask_b32_e64 v67, v35, v67, s[32:33]
		buffer_load_dwordx4 v67, s[48:51], 0 offen lds
		v_add_u32_e32 v67, s43, v66
		s_add_i32 m0, s71, 0xc5e0
		v_cndmask_b32_e64 v67, v35, v67, s[34:35]
		buffer_load_dwordx4 v67, s[48:51], 0 offen lds
		v_add_u32_e32 v5, 0x80, v5
		s_add_i32 m0, s71, 0x4200
		v_cndmask_b32_e64 v5, v35, v5, s[36:37]
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		v_add_u32_e32 v5, s60, v66
		s_add_i32 m0, s71, 0xe6e0
		v_cndmask_b32_e64 v5, v35, v5, s[38:39]
		v_add_u32_e32 v67, s61, v66
		v_cndmask_b32_e64 v67, v35, v67, s[40:41]
		s_mov_b32 s74, 0
		v_add_u32_e32 v69, v39, v68
		s_mov_b32 s75, 0
		buffer_load_dwordx4 v5, s[48:51], 0 offen lds
		s_add_i32 m0, s71, 0x107e0
		v_cndmask_b32_e64 v5, v64, v65, s[76:77]
		buffer_load_dwordx4 v67, s[48:51], 0 offen lds
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[72:75], v41
		ds_read_b128 v[76:79], v41 offset:2112
		ds_read_b128 v[80:83], v41 offset:4224
		ds_read_b128 v[84:87], v41 offset:6336
		ds_read_b64_tr_b16 v[88:89], v6 offset:25312
		ds_read_b64_tr_b16 v[90:91], v6 offset:33760
		ds_read_b64_tr_b16 v[92:93], v6 offset:25440
		ds_read_b64_tr_b16 v[94:95], v6 offset:33888
		ds_read_b64_tr_b16 v[96:97], v6 offset:25568
		ds_read_b64_tr_b16 v[98:99], v6 offset:34016
		ds_read_b64_tr_b16 v[100:101], v6 offset:25696
		ds_read_b64_tr_b16 v[102:103], v6 offset:34144
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
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		s_cmp_ge_u32 s74, 2
		s_cselect_b32 s76, 1, 0
		s_add_i32 s77, s74, -2
		s_add_i32 s78, s74, 1
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		s_cmp_lg_u32 s76, 0
		s_cselect_b32 s76, s77, s78
		s_cselect_b32 s79, 1, 0
		s_add_i32 s80, s75, 3
		s_mul_i32 s80, s80, 32
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		s_xor_b32 s80, s80, -1
		s_add_i32 s80, s80, 1
		s_add_i32 s80, s14, s80
		s_waitcnt lgkmcnt(0)
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
		s_barrier
		v_cmp_lt_i32_e64 vcc, v27, s80
		s_lshl_b32 s81, s75, 6
		s_mul_i32 s82, 0x2100, s74
		v_cndmask_b32_e32 v64, v35, v69, vcc
		s_add_i32 m0, s71, s82
		s_mul_i32 s82, s17, s75
		buffer_load_dwordx4 v64, s[44:47], s81 offen lds
		v_cmp_lt_i32_e64 vcc, v7, s80
		s_mov_b64 s[84:85], vcc
		s_lshl_b32 s81, s82, 6
		s_add_i32 s82, s63, s81
		v_add_u32_e32 v64, s82, v66
		s_mul_i32 s74, 0x4200, s74
		s_add_i32 s74, s71, s74
		s_add_i32 m0, s74, 0x62e0
		v_cndmask_b32_e64 v64, v35, v64, s[84:85]
		buffer_load_dwordx4 v64, s[48:51], 0 offen lds
		s_add_i32 s81, s64, s81
		v_cmp_lt_i32_e64 vcc, v8, s80
		v_add_u32_e32 v64, s81, v66
		s_mul_i32 s80, 0x4200, s76
		v_cndmask_b32_e32 v64, v35, v64, vcc
		s_add_i32 m0, s74, 0x83e0
		s_mul_i32 s74, 0x2100, s76
		buffer_load_dwordx4 v64, s[48:51], 0 offen lds
		v_add_u32_e32 v64, s74, v41
		ds_read_b128 v[72:75], v64
		ds_read_b128 v[76:79], v64 offset:2112
		ds_read_b128 v[80:83], v64 offset:4224
		ds_read_b128 v[84:87], v64 offset:6336
		v_add_u32_e32 v64, s80, v6
		ds_read_b64_tr_b16 v[88:89], v64 offset:25312
		ds_read_b64_tr_b16 v[90:91], v64 offset:33760
		ds_read_b64_tr_b16 v[92:93], v64 offset:25440
		ds_read_b64_tr_b16 v[94:95], v64 offset:33888
		ds_read_b64_tr_b16 v[96:97], v64 offset:25568
		ds_read_b64_tr_b16 v[98:99], v64 offset:34016
		ds_read_b64_tr_b16 v[100:101], v64 offset:25696
		ds_read_b64_tr_b16 v[102:103], v64 offset:34144
		s_cmp_lg_u32 s79, 0
		s_cselect_b32 s74, s77, s78
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s75, s23
		s_waitcnt vmcnt(3)
		s_barrier
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_dwordx2 v[64:65], v62, s[52:55], 0 offen
		v_lshlrev_b32_e32 v62, 1, v63
		buffer_load_dwordx2 v[66:67], v62, s[52:55], 0 offen
		v_lshlrev_b32_e32 v58, 1, v58
		buffer_load_dwordx2 v[62:63], v58, s[52:55], 0 offen
		v_lshlrev_b32_e32 v5, 1, v5
		buffer_load_dwordx2 v[68:69], v5, s[52:55], 0 offen
		v_lshl_add_u32 v5, v9, 1, v61
		buffer_load_dwordx4 v[168:171], v5, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v5, v49, 1, v61
		buffer_load_dwordx4 v[172:175], v5, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v5, v54, 1, v61
		buffer_load_dwordx4 v[176:179], v5, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v5, v55, 1, v61
		buffer_load_dwordx4 v[180:183], v5, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v5, v51, 1, v61
		buffer_load_dwordx4 v[184:187], v5, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v5, v56, 1, v61
		buffer_load_dwordx4 v[188:191], v5, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v5, s18, v57
		v_lshl_add_u32 v5, v5, 1, v61
		buffer_load_dwordx4 v[192:195], v5, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v5, s18, v59
		v_lshl_add_u32 v5, v5, 1, v61
		buffer_load_dwordx4 v[56:59], v5, s[4:7], 0 offen sc0 nt
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[72:75], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[72:75], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[72:75], v[112:115]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[72:75], v40
		ds_read_b128 v[76:79], v40 offset:2112
		ds_read_b128 v[80:83], v40 offset:4224
		ds_read_b128 v[84:87], v40 offset:6336
		ds_read_b64_tr_b16 v[88:89], v42 offset:25312
		ds_read_b64_tr_b16 v[90:91], v42 offset:33760
		ds_read_b64_tr_b16 v[92:93], v42 offset:25440
		ds_read_b64_tr_b16 v[94:95], v42 offset:33888
		ds_read_b64_tr_b16 v[96:97], v42 offset:25568
		ds_read_b64_tr_b16 v[98:99], v42 offset:34016
		ds_read_b64_tr_b16 v[100:101], v42 offset:25696
		ds_read_b64_tr_b16 v[102:103], v42 offset:34144
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
		ds_read_b128 v[72:75], v43
		ds_read_b128 v[76:79], v43 offset:2112
		ds_read_b128 v[80:83], v43 offset:4224
		ds_read_b128 v[84:87], v43 offset:6336
		ds_read_b64_tr_b16 v[88:89], v44 offset:25312
		ds_read_b64_tr_b16 v[90:91], v44 offset:33760
		ds_read_b64_tr_b16 v[92:93], v44 offset:25440
		ds_read_b64_tr_b16 v[94:95], v44 offset:33888
		ds_read_b64_tr_b16 v[96:97], v44 offset:25568
		ds_read_b64_tr_b16 v[98:99], v44 offset:34016
		ds_read_b64_tr_b16 v[100:101], v44 offset:25696
		ds_read_b64_tr_b16 v[102:103], v44 offset:34144
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
		s_waitcnt vmcnt(11)
		v_cvt_f32_f16_e32 v72, v64
		v_cvt_f32_f16_sdwa v73, v64 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v74, v65
		v_cvt_f32_f16_sdwa v75, v65 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(10)
		v_cvt_f32_f16_e32 v76, v66
		v_cvt_f32_f16_sdwa v77, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v78, v67
		v_cvt_f32_f16_sdwa v79, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(9)
		v_cvt_f32_f16_e32 v64, v62
		v_cvt_f32_f16_sdwa v65, v62 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v66, v63
		v_cvt_f32_f16_sdwa v67, v63 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(8)
		v_cvt_f32_f16_e32 v80, v68
		v_cvt_f32_f16_sdwa v81, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v69
		v_cvt_f32_f16_sdwa v83, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v54, v168
		v_cvt_f32_f16_sdwa v55, v168 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v62, v169
		v_cvt_f32_f16_sdwa v63, v169 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v170
		v_cvt_f32_f16_sdwa v69, v170 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v70, v171
		v_cvt_f32_f16_sdwa v71, v171 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v84, v172
		v_cvt_f32_f16_sdwa v85, v172 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v173
		v_cvt_f32_f16_sdwa v87, v173 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v88, v174
		v_cvt_f32_f16_sdwa v89, v174 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v175
		v_cvt_f32_f16_sdwa v91, v175 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v92, v176
		v_cvt_f32_f16_sdwa v93, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v177
		v_cvt_f32_f16_sdwa v95, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v178
		v_cvt_f32_f16_sdwa v97, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v98, v179
		v_cvt_f32_f16_sdwa v99, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v100, v180
		v_cvt_f32_f16_sdwa v101, v180 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v102, v181
		v_cvt_f32_f16_sdwa v103, v181 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v168, v182
		v_cvt_f32_f16_sdwa v169, v182 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v170, v183
		v_cvt_f32_f16_sdwa v171, v183 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v172, v184
		v_cvt_f32_f16_sdwa v173, v184 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v174, v185
		v_cvt_f32_f16_sdwa v175, v185 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v176, v186
		v_cvt_f32_f16_sdwa v177, v186 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v178, v187
		v_cvt_f32_f16_sdwa v179, v187 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v180, v188
		v_cvt_f32_f16_sdwa v181, v188 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v182, v189
		v_cvt_f32_f16_sdwa v183, v189 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v184, v190
		v_cvt_f32_f16_sdwa v185, v190 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v186, v191
		v_cvt_f32_f16_sdwa v187, v191 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v188, v192
		v_cvt_f32_f16_sdwa v189, v192 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v190, v193
		v_cvt_f32_f16_sdwa v191, v193 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v192, v194
		v_cvt_f32_f16_sdwa v193, v194 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v196, v195
		v_cvt_f32_f16_sdwa v197, v195 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v194, v56
		v_cvt_f32_f16_sdwa v195, v56 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v198, v57
		v_cvt_f32_f16_sdwa v199, v57 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v56, v58
		v_cvt_f32_f16_sdwa v57, v58 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v200, v59
		v_cvt_f32_f16_sdwa v201, v59 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[204:205], v[104:105], v[72:73]
		v_pk_add_f32 v[206:207], v[106:107], v[74:75]
		ds_write_b128 v46, v[204:207] offset:10432
		v_pk_add_f32 v[104:105], v[108:109], v[76:77]
		v_pk_add_f32 v[106:107], v[110:111], v[78:79]
		ds_write_b128 v47, v[104:107] offset:10432
		v_pk_add_f32 v[104:105], v[112:113], v[64:65]
		v_pk_add_f32 v[106:107], v[114:115], v[66:67]
		ds_write_b128 v48, v[104:107] offset:10432
		v_pk_add_f32 v[104:105], v[116:117], v[80:81]
		v_pk_add_f32 v[106:107], v[118:119], v[82:83]
		ds_write_b128 v45, v[104:107] offset:10432
		v_pk_add_f32 v[104:105], v[120:121], v[72:73]
		v_pk_add_f32 v[106:107], v[122:123], v[74:75]
		v_pk_add_f32 v[108:109], v[124:125], v[76:77]
		v_pk_add_f32 v[110:111], v[126:127], v[78:79]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_add_f32 v[112:113], v[128:129], v[64:65]
		v_pk_add_f32 v[114:115], v[130:131], v[66:67]
		v_pk_add_f32 v[116:117], v[132:133], v[80:81]
		v_pk_add_f32 v[118:119], v[134:135], v[82:83]
		v_pk_add_f32 v[120:121], v[136:137], v[72:73]
		v_pk_add_f32 v[122:123], v[138:139], v[74:75]
		v_pk_add_f32 v[124:125], v[140:141], v[76:77]
		v_pk_add_f32 v[126:127], v[142:143], v[78:79]
		v_pk_add_f32 v[128:129], v[144:145], v[64:65]
		v_pk_add_f32 v[130:131], v[146:147], v[66:67]
		v_pk_add_f32 v[132:133], v[148:149], v[80:81]
		v_pk_add_f32 v[134:135], v[150:151], v[82:83]
		v_pk_add_f32 v[136:137], v[152:153], v[72:73]
		v_pk_add_f32 v[138:139], v[154:155], v[74:75]
		v_pk_add_f32 v[72:73], v[156:157], v[76:77]
		v_pk_add_f32 v[74:75], v[158:159], v[78:79]
		v_pk_add_f32 v[76:77], v[160:161], v[64:65]
		v_pk_add_f32 v[78:79], v[162:163], v[66:67]
		v_pk_add_f32 v[64:65], v[164:165], v[80:81]
		v_pk_add_f32 v[66:67], v[166:167], v[82:83]
		ds_read_b128 v[80:83], v1 offset:10432
		ds_read_b128 v[140:143], v1 offset:10944
		ds_read_b128 v[144:147], v1 offset:10688
		ds_read_b128 v[148:151], v1 offset:11200
		v_cmp_lt_i32_e64 vcc, v11, s12
		s_mov_b64 s[74:75], vcc
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[152:153], v[80:81], v[54:55], v[80:81]
		v_pk_fma_f32 v[154:155], v[82:83], v[62:63], v[82:83]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[156:157], v[140:141], v[68:69], v[140:141]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v46, v[104:107] offset:10432
		ds_write_b128 v47, v[108:111] offset:10432
		ds_write_b128 v48, v[112:115] offset:10432
		ds_write_b128 v45, v[116:119] offset:10432
		v_pk_fma_f32 v[158:159], v[142:143], v[70:71], v[142:143]
		v_pk_fma_f32 v[104:105], v[144:145], v[84:85], v[144:145]
		v_pk_fma_f32 v[106:107], v[146:147], v[86:87], v[146:147]
		v_pk_fma_f32 v[108:109], v[148:149], v[88:89], v[148:149]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v1 offset:10432
		ds_read_b128 v[80:83], v1 offset:10944
		ds_read_b128 v[84:87], v1 offset:10688
		ds_read_b128 v[112:115], v1 offset:11200
		v_pk_fma_f32 v[110:111], v[150:151], v[90:91], v[150:151]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[144:145], v[68:69], v[92:93], v[68:69]
		v_pk_fma_f32 v[146:147], v[70:71], v[94:95], v[70:71]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[148:149], v[80:81], v[96:97], v[80:81]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v46, v[120:123] offset:10432
		ds_write_b128 v47, v[124:127] offset:10432
		ds_write_b128 v48, v[128:131] offset:10432
		ds_write_b128 v45, v[132:135] offset:10432
		v_pk_fma_f32 v[150:151], v[82:83], v[98:99], v[82:83]
		v_pk_fma_f32 v[88:89], v[84:85], v[100:101], v[84:85]
		v_pk_fma_f32 v[90:91], v[86:87], v[102:103], v[86:87]
		v_pk_fma_f32 v[92:93], v[112:113], v[168:169], v[112:113]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v1 offset:10432
		ds_read_b128 v[80:83], v1 offset:10944
		ds_read_b128 v[84:87], v1 offset:10688
		ds_read_b128 v[96:99], v1 offset:11200
		v_pk_fma_f32 v[94:95], v[114:115], v[170:171], v[114:115]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[112:113], v[68:69], v[172:173], v[68:69]
		v_pk_fma_f32 v[114:115], v[70:71], v[174:175], v[70:71]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[116:117], v[80:81], v[176:177], v[80:81]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v46, v[136:139] offset:10432
		ds_write_b128 v47, v[72:75] offset:10432
		ds_write_b128 v48, v[76:79] offset:10432
		ds_write_b128 v45, v[64:67] offset:10432
		v_pk_fma_f32 v[118:119], v[82:83], v[178:179], v[82:83]
		v_pk_fma_f32 v[64:65], v[84:85], v[180:181], v[84:85]
		v_pk_fma_f32 v[66:67], v[86:87], v[182:183], v[86:87]
		v_pk_fma_f32 v[68:69], v[96:97], v[184:185], v[96:97]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v1 offset:10432
		ds_read_b128 v[76:79], v1 offset:10944
		ds_read_b128 v[80:83], v1 offset:10688
		ds_read_b128 v[84:87], v1 offset:11200
		v_pk_fma_f32 v[70:71], v[98:99], v[186:187], v[98:99]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[96:97], v[72:73], v[188:189], v[72:73]
		v_pk_fma_f32 v[98:99], v[74:75], v[190:191], v[74:75]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[100:101], v[76:77], v[192:193], v[76:77]
		v_pk_fma_f32 v[102:103], v[78:79], v[196:197], v[78:79]
		s_waitcnt lgkmcnt(1)
		v_pk_fma_f32 v[72:73], v[80:81], v[194:195], v[80:81]
		v_pk_fma_f32 v[74:75], v[82:83], v[198:199], v[82:83]
		s_waitcnt lgkmcnt(0)
		v_pk_fma_f32 v[76:77], v[84:85], v[56:57], v[84:85]
		v_pk_fma_f32 v[78:79], v[86:87], v[200:201], v[86:87]
		v_cmp_lt_i32_e64 vcc, v60, s13
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v152, v153
		v_cvt_pk_f16_f32 v57, v154, v155
		v_cvt_pk_f16_f32 v58, v156, v157
		v_cvt_pk_f16_f32 v59, v158, v159
		s_lshl_b32 s16, s16, 10
		s_add_i32 s71, s73, s16
		s_lshl_b32 s72, s72, 8
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v32, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v104, v105
		v_cvt_pk_f16_f32 v57, v106, v107
		v_cvt_pk_f16_f32 v58, v108, v109
		v_cvt_pk_f16_f32 v59, v110, v111
		s_add_i32 s71, s42, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v33, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v144, v145
		v_cvt_pk_f16_f32 v57, v146, v147
		v_cvt_pk_f16_f32 v58, v148, v149
		v_cvt_pk_f16_f32 v59, v150, v151
		s_add_i32 s71, s65, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v37, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v88, v89
		v_cvt_pk_f16_f32 v57, v90, v91
		v_cvt_pk_f16_f32 v58, v92, v93
		v_cvt_pk_f16_f32 v59, v94, v95
		s_add_i32 s71, s66, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v38, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v112, v113
		v_cvt_pk_f16_f32 v57, v114, v115
		v_cvt_pk_f16_f32 v58, v116, v117
		v_cvt_pk_f16_f32 v59, v118, v119
		s_add_i32 s71, s67, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v50, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v64, v65
		v_cvt_pk_f16_f32 v57, v66, v67
		v_cvt_pk_f16_f32 v58, v68, v69
		v_cvt_pk_f16_f32 v59, v70, v71
		s_add_i32 s71, s68, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v52, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v56, v96, v97
		v_cvt_pk_f16_f32 v57, v98, v99
		v_cvt_pk_f16_f32 v58, v100, v101
		v_cvt_pk_f16_f32 v59, v102, v103
		s_add_i32 s71, s69, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v5, s71, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[56:59], v5, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v53, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v52, v72, v73
		v_cvt_pk_f16_f32 v53, v74, v75
		v_cvt_pk_f16_f32 v54, v76, v77
		v_cvt_pk_f16_f32 v55, v78, v79
		s_add_i32 s71, s70, s73
		s_add_i32 s16, s71, s16
		s_add_i32 s16, s16, s72
		v_add3_u32 v5, s16, v3, v4
		v_cndmask_b32_e64 v5, v35, v5, s[78:79]
		buffer_store_dwordx4 v[52:55], v5, s[56:59], 0 offen sc0 nt
		s_cmp_lt_i32 s2, s20
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
		.amdhsa_next_free_vgpr 208
		.amdhsa_next_free_sgpr 86
		.amdhsa_accum_offset 208
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 208
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
    .group_segment_fixed_size: 108736
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     86
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     208
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
