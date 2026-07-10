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
		v_mov_b32_e32 v14, 0x4f7ffffe
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
		v_mov_b32_e32 v16, s12
		v_mov_b32_e32 v30, s43
		v_cndmask_b32_e64 v16, v16, v30, s[62:63]
		v_cvt_f32_u32_e32 v30, v16
		v_rcp_iflag_f32_e32 v30, v30
		v_xad_u32 v32, v16, -1, 1
		v_mul_f32_e32 v30, v14, v30
		v_cvt_u32_f32_e32 v30, v30
		v_mul_lo_u32 v33, v32, v30
		v_mul_hi_u32 v33, v30, v33
		v_add_u32_e32 v30, v30, v33
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s62, s10, s60
		s_cselect_b32 s63, s11, s61
		s_xor_b32 s10, s13, -1
		s_add_i32 s10, s10, 1
		v_mov_b32_e32 v33, s13
		v_mov_b32_e32 v34, s10
		v_cndmask_b32_e64 v33, v33, v34, s[62:63]
		v_cvt_f32_u32_e32 v34, v33
		v_rcp_iflag_f32_e32 v34, v34
		v_xad_u32 v35, v33, -1, 1
		v_mul_f32_e32 v34, v14, v34
		v_cvt_u32_f32_e32 v34, v34
		v_mul_lo_u32 v36, v35, v34
		v_mul_hi_u32 v36, v34, v36
		v_add_u32_e32 v34, v34, v36
		v_and_b32_e32 v36, 63, v0
		v_lshrrev_b32_e32 v37, 4, v36
		v_lshlrev_b32_e32 v38, 4, v37
		v_lshl_add_u32 v38, v15, 9, v38
		v_and_b32_e32 v39, 15, v36
		v_lshrrev_b32_e32 v40, 1, v39
		v_lshlrev_b32_e32 v40, 6, v40
		v_and_b32_e32 v41, 1, v39
		v_mov_b32_e32 v42, 0x420
		v_mul_lo_u32 v42, v42, v41
		v_add3_u32 v38, v38, v40, v42
		v_lshrrev_b32_e32 v36, 5, v36
		v_lshrrev_b32_e32 v40, 2, v39
		v_mov_b32_e32 v41, 0x420
		v_mul_lo_u32 v41, v41, v40
		v_lshl_add_u32 v36, v36, 9, v41
		v_and_b32_e32 v40, 3, v10
		v_lshlrev_b32_e32 v40, 5, v40
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v41, 0x1080
		v_mul_lo_u32 v41, v41, v37
		v_add3_u32 v36, v36, v40, v41
		v_and_b32_e32 v37, 3, v39
		v_lshl_add_u32 v36, v37, 3, v36
		v_and_b32_e32 v37, 1, v0
		v_lshrrev_b32_e32 v39, 1, v0
		v_and_b32_e32 v39, 1, v39
		v_lshlrev_b32_e32 v40, 5, v39
		v_lshl_add_u32 v40, v37, 4, v40
		v_add_u32_e32 v41, 0xc0, v40
		s_lshl_b32 s10, s15, 1
		s_cmp_lt_i32 0, s23
		s_mul_i32 s11, 0x2100, s42
		v_add_u32_e32 v42, s11, v38
		s_mul_i32 s11, 0x4200, s42
		v_add_u32_e32 v43, s11, v36
		s_mul_i32 s11, 0x2100, s21
		v_add_u32_e32 v44, s11, v38
		s_mul_i32 s11, 0x4200, s21
		v_add_u32_e32 v45, s11, v36
		v_lshlrev_b32_e32 v46, 8, v15
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v47, 7, v13
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v48, 0x408
		v_mul_lo_u32 v48, v48, v10
		v_lshlrev_b32_e32 v49, 2, v37
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v50, 6, v8
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v51, 5, v3
		v_add3_u32 v52, v49, v50, v51
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v53, 4, v1
		v_lshlrev_b32_e32 v54, 3, v39
		v_add3_u32 v52, v52, v53, v54
		v_and_b32_e32 v55, 1, v9
		v_mov_b32_e32 v56, 0x204
		v_mul_lo_u32 v56, v56, v55
		v_bitop3_b32 v52, v48, v52, v56 bitop3:0x96
		v_bitop3_b32 v52, v46, v47, v52 bitop3:0x96
		v_lshlrev_b32_e32 v52, 2, v52
		v_add_u32_e32 v52, 0x10000, v52
		v_add_u32_e32 v57, 0x810, v49
		v_bitop3_b32 v57, v53, v57, v54 bitop3:0x96
		v_bitop3_b32 v57, v50, v51, v57 bitop3:0x96
		v_bitop3_b32 v57, v48, v56, v57 bitop3:0x96
		v_bitop3_b32 v57, v46, v47, v57 bitop3:0x96
		v_lshlrev_b32_e32 v57, 2, v57
		v_add_u32_e32 v57, 0x10000, v57
		v_add_u32_e32 v58, 0x1020, v49
		v_bitop3_b32 v58, v53, v58, v54 bitop3:0x96
		v_bitop3_b32 v58, v50, v51, v58 bitop3:0x96
		v_bitop3_b32 v58, v48, v56, v58 bitop3:0x96
		v_bitop3_b32 v58, v46, v47, v58 bitop3:0x96
		v_lshlrev_b32_e32 v58, 2, v58
		v_add_u32_e32 v58, 0x10000, v58
		v_add_u32_e32 v49, 0x1830, v49
		v_bitop3_b32 v49, v53, v49, v54 bitop3:0x96
		v_bitop3_b32 v49, v50, v51, v49 bitop3:0x96
		v_bitop3_b32 v48, v48, v56, v49 bitop3:0x96
		v_bitop3_b32 v46, v46, v47, v48 bitop3:0x96
		v_lshlrev_b32_e32 v46, 2, v46
		v_add_u32_e32 v46, 0x10000, v46
		v_lshlrev_b32_e32 v47, 5, v15
		v_lshlrev_b32_e32 v48, 4, v13
		v_lshlrev_b32_e32 v49, 3, v10
		v_lshlrev_b32_e32 v50, 2, v55
		v_mov_b32_e32 v51, 0x1020
		v_mul_lo_u32 v51, v51, v8
		v_mov_b32_e32 v8, 0x810
		v_mul_lo_u32 v8, v8, v3
		v_lshlrev_b32_e32 v1, 7, v1
		v_mov_b32_e32 v3, 0x204
		v_mul_lo_u32 v3, v3, v37
		v_mov_b32_e32 v37, 0x408
		v_mul_lo_u32 v37, v37, v39
		v_bitop3_b32 v39, v1, v3, v37 bitop3:0x96
		v_bitop3_b32 v39, v51, v8, v39 bitop3:0x96
		v_bitop3_b32 v39, v49, v50, v39 bitop3:0x96
		v_bitop3_b32 v39, v47, v48, v39 bitop3:0x96
		v_lshlrev_b32_e32 v39, 2, v39
		v_add_u32_e32 v39, 0x10000, v39
		v_xor_b32_e32 v53, 64, v3
		v_bitop3_b32 v53, v1, v37, v53 bitop3:0x96
		v_bitop3_b32 v53, v51, v8, v53 bitop3:0x96
		v_bitop3_b32 v53, v49, v50, v53 bitop3:0x96
		v_bitop3_b32 v53, v47, v48, v53 bitop3:0x96
		v_lshlrev_b32_e32 v53, 2, v53
		v_add_u32_e32 v53, 0x10000, v53
		v_xor_b32_e32 v54, 0x100, v3
		v_bitop3_b32 v54, v1, v37, v54 bitop3:0x96
		v_bitop3_b32 v54, v51, v8, v54 bitop3:0x96
		v_bitop3_b32 v54, v49, v50, v54 bitop3:0x96
		v_bitop3_b32 v54, v47, v48, v54 bitop3:0x96
		v_lshlrev_b32_e32 v54, 2, v54
		v_add_u32_e32 v54, 0x10000, v54
		v_xor_b32_e32 v3, 0x140, v3
		v_bitop3_b32 v1, v1, v37, v3 bitop3:0x96
		v_bitop3_b32 v1, v51, v8, v1 bitop3:0x96
		v_bitop3_b32 v1, v49, v50, v1 bitop3:0x96
		v_bitop3_b32 v1, v47, v48, v1 bitop3:0x96
		v_lshlrev_b32_e32 v1, 2, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v3, s19, v9
		v_lshlrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v8, 31, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_mov_b32_e32 v9, 0x80000000
		s_cselect_b32 s11, 1, 0
		s_lshl_b32 s21, s19, 5
		s_lshl_b32 s42, s19, 6
		s_mul_i32 s43, 0x60, s19
		s_lshl_b32 s60, s19, 7
		s_mul_i32 s61, 0xa0, s19
		s_mul_i32 s62, 0xc0, s19
		s_mul_i32 s63, 0xe0, s19
		v_mul_lo_u32 v15, s17, v15
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshl_add_u32 v13, v15, 4, v13
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v10, v10, 1, v13
		v_mul_lo_u32 v13, s17, v55
		v_lshl_add_u32 v10, v13, 5, v10
		s_lshl_b32 s64, s17, 3
		s_lshl_b32 s65, s17, 6
		s_mul_i32 s66, 0x48, s17
		s_lshl_b32 s67, s17, 7
		s_mul_i32 s68, 0x88, s17
		s_mul_i32 s69, 0xc0, s17
		s_mul_i32 s70, 0xc8, s17
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
		v_mov_b32_e32 v13, s73
		v_cvt_f32_u32_e32 v13, v13
		v_rcp_iflag_f32_e32 v13, v13
		s_xor_b32 s74, s73, -1
		v_mul_f32_e32 v13, v14, v13
		v_cvt_u32_f32_e32 v13, v13
		s_add_i32 s74, s74, 1
		v_readfirstlane_b32 s75, v13
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
		v_mov_b32_e32 v13, s75
		v_cvt_f32_u32_e32 v13, v13
		v_rcp_iflag_f32_e32 v13, v13
		s_xor_b32 s77, s75, -1
		v_mul_f32_e32 v13, v14, v13
		v_cvt_u32_f32_e32 v13, v13
		s_add_i32 s77, s77, 1
		v_readfirstlane_b32 s78, v13
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
		v_add_u32_e32 v13, s73, v2
		v_cmp_lt_i32_e64 vcc, v13, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v15, v13, -1, 1
		v_add_u32_e32 v37, s73, v17
		v_cndmask_b32_e32 v13, v13, v15, vcc
		v_mul_hi_u32 v15, v13, v30
		v_mul_lo_u32 v15, v15, v16
		v_xor_b32_e32 v15, -1, v15
		v_add3_u32 v13, 1, v15, v13
		v_add_u32_e32 v15, v13, v32
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v47, s73, v18
		v_add_u32_e32 v48, s73, v19
		v_cndmask_b32_e32 v13, v13, v15, vcc
		v_add_u32_e32 v15, v13, v32
		v_cmp_ge_u32_e64 vcc, v13, v16
		v_add_u32_e32 v49, s73, v20
		v_add_u32_e32 v50, s73, v21
		v_cndmask_b32_e32 v13, v13, v15, vcc
		v_xad_u32 v15, v13, -1, 1
		v_cmp_lt_i32_e64 vcc, v37, s9
		s_mov_b64 s[76:77], vcc
		v_xad_u32 v51, v37, -1, 1
		v_add_u32_e32 v55, s73, v22
		v_cndmask_b32_e32 v51, v37, v51, vcc
		v_mul_hi_u32 v56, v51, v30
		v_mul_lo_u32 v56, v56, v16
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v51, 1, v56, v51
		v_add_u32_e32 v56, v51, v32
		v_cmp_ge_u32_e64 vcc, v51, v16
		v_add_u32_e32 v59, s73, v23
		v_add_u32_e32 v60, s73, v24
		v_cndmask_b32_e32 v51, v51, v56, vcc
		v_cmp_ge_u32_e64 vcc, v51, v16
		v_cndmask_b32_e64 v13, v13, v15, s[74:75]
		v_add_u32_e32 v15, v51, v32
		v_cndmask_b32_e32 v15, v51, v15, vcc
		v_xad_u32 v51, v15, -1, 1
		v_cmp_lt_i32_e64 vcc, v47, s9
		s_mov_b64 s[74:75], vcc
		v_xad_u32 v56, v47, -1, 1
		v_cndmask_b32_e64 v15, v15, v51, s[76:77]
		v_cndmask_b32_e32 v51, v47, v56, vcc
		v_mul_hi_u32 v56, v51, v30
		v_mul_lo_u32 v56, v56, v16
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v51, 1, v56, v51
		v_cmp_ge_u32_e64 vcc, v51, v16
		v_add_u32_e32 v56, v51, v32
		v_xad_u32 v61, v48, -1, 1
		v_cndmask_b32_e32 v51, v51, v56, vcc
		v_cmp_ge_u32_e64 vcc, v51, v16
		v_add_u32_e32 v56, v51, v32
		v_xad_u32 v62, v49, -1, 1
		v_cndmask_b32_e32 v51, v51, v56, vcc
		v_xad_u32 v56, v51, -1, 1
		v_cmp_lt_i32_e64 vcc, v48, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v51, v51, v56, s[74:75]
		v_xad_u32 v56, v50, -1, 1
		v_cndmask_b32_e32 v61, v48, v61, vcc
		v_mul_hi_u32 v63, v61, v30
		v_mul_lo_u32 v63, v63, v16
		v_xor_b32_e32 v63, -1, v63
		v_add3_u32 v61, 1, v63, v61
		v_cmp_ge_u32_e64 vcc, v61, v16
		v_add_u32_e32 v63, v61, v32
		s_add_i32 s2, s2, 0x100
		v_cndmask_b32_e32 v61, v61, v63, vcc
		v_cmp_ge_u32_e64 vcc, v61, v16
		v_add_u32_e32 v63, v61, v32
		s_mul_i32 s72, s19, s72
		v_cndmask_b32_e32 v61, v61, v63, vcc
		v_xad_u32 v63, v61, -1, 1
		v_cmp_lt_i32_e64 vcc, v49, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v61, v61, v63, s[76:77]
		v_xad_u32 v63, v55, -1, 1
		v_cndmask_b32_e32 v62, v49, v62, vcc
		v_mul_hi_u32 v64, v62, v30
		v_mul_lo_u32 v64, v64, v16
		v_xor_b32_e32 v64, -1, v64
		v_add3_u32 v62, 1, v64, v62
		v_cmp_ge_u32_e64 vcc, v62, v16
		v_add_u32_e32 v64, v62, v32
		s_mul_i32 s16, s19, s16
		v_cndmask_b32_e32 v62, v62, v64, vcc
		v_cmp_ge_u32_e64 vcc, v62, v16
		v_add_u32_e32 v64, v62, v32
		s_lshl_b32 s73, s71, 9
		v_cndmask_b32_e32 v62, v62, v64, vcc
		v_xad_u32 v64, v62, -1, 1
		v_cmp_lt_i32_e64 vcc, v50, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v62, v62, v64, s[74:75]
		v_xad_u32 v64, v59, -1, 1
		v_cndmask_b32_e32 v56, v50, v56, vcc
		v_mul_hi_u32 v65, v56, v30
		v_mul_lo_u32 v65, v65, v16
		v_xor_b32_e32 v65, -1, v65
		v_add3_u32 v56, 1, v65, v56
		v_cmp_ge_u32_e64 vcc, v56, v16
		v_add_u32_e32 v65, v56, v32
		v_xad_u32 v66, v60, -1, 1
		v_cndmask_b32_e32 v56, v56, v65, vcc
		v_cmp_ge_u32_e64 vcc, v56, v16
		v_add_u32_e32 v65, v56, v32
		v_mul_lo_u32 v62, s18, v62
		v_cndmask_b32_e32 v56, v56, v65, vcc
		v_xad_u32 v65, v56, -1, 1
		v_cmp_lt_i32_e64 vcc, v55, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v56, v56, v65, s[76:77]
		v_mul_lo_u32 v56, s18, v56
		v_cndmask_b32_e32 v63, v55, v63, vcc
		v_mul_hi_u32 v65, v63, v30
		v_mul_lo_u32 v65, v65, v16
		v_xor_b32_e32 v65, -1, v65
		v_add3_u32 v63, 1, v65, v63
		v_cmp_ge_u32_e64 vcc, v63, v16
		v_add_u32_e32 v65, v63, v32
		s_mul_i32 s71, s71, 0x100
		v_cndmask_b32_e32 v63, v63, v65, vcc
		v_cmp_ge_u32_e64 vcc, v63, v16
		v_add_u32_e32 v65, v63, v32
		v_add_u32_e32 v67, s71, v26
		v_cndmask_b32_e32 v63, v63, v65, vcc
		v_xad_u32 v65, v63, -1, 1
		v_cmp_lt_i32_e64 vcc, v59, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v63, v63, v65, s[74:75]
		v_mul_lo_u32 v63, s18, v63
		v_cndmask_b32_e32 v64, v59, v64, vcc
		v_mul_hi_u32 v65, v64, v30
		v_mul_lo_u32 v65, v65, v16
		v_xor_b32_e32 v65, -1, v65
		v_add3_u32 v64, 1, v65, v64
		v_cmp_ge_u32_e64 vcc, v64, v16
		v_add_u32_e32 v65, v64, v32
		v_xad_u32 v68, v67, -1, 1
		v_cndmask_b32_e32 v64, v64, v65, vcc
		v_cmp_ge_u32_e64 vcc, v64, v16
		v_add_u32_e32 v65, v64, v32
		v_add_u32_e32 v69, s71, v27
		v_cndmask_b32_e32 v64, v64, v65, vcc
		v_xad_u32 v65, v64, -1, 1
		v_cmp_lt_i32_e64 vcc, v60, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v64, v64, v65, s[76:77]
		v_add_u32_e32 v65, s71, v25
		v_cndmask_b32_e32 v66, v60, v66, vcc
		v_mul_hi_u32 v70, v66, v30
		v_mul_lo_u32 v70, v70, v16
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v66, 1, v70, v66
		v_cmp_ge_u32_e64 vcc, v66, v16
		v_add_u32_e32 v70, v66, v32
		v_add_u32_e32 v71, s71, v28
		v_cndmask_b32_e32 v66, v66, v70, vcc
		v_cmp_ge_u32_e64 vcc, v66, v16
		v_add_u32_e32 v70, v66, v32
		v_add_u32_e32 v72, s71, v29
		v_cndmask_b32_e32 v66, v66, v70, vcc
		v_xad_u32 v70, v66, -1, 1
		v_cmp_lt_i32_e64 vcc, v67, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v66, v66, v70, s[74:75]
		v_xad_u32 v70, v69, -1, 1
		v_cndmask_b32_e32 v68, v67, v68, vcc
		v_mul_hi_u32 v73, v68, v34
		v_mul_lo_u32 v73, v73, v33
		v_xor_b32_e32 v73, -1, v73
		v_add3_u32 v68, 1, v73, v68
		v_add_u32_e32 v73, v68, v35
		v_cmp_ge_u32_e64 vcc, v68, v33
		v_mul_lo_u32 v61, s18, v61
		v_mul_lo_u32 v51, s18, v51
		v_cndmask_b32_e32 v68, v68, v73, vcc
		v_add_u32_e32 v73, v68, v35
		v_cmp_ge_u32_e64 vcc, v68, v33
		v_xad_u32 v74, v65, -1, 1
		v_mul_lo_u32 v15, s18, v15
		v_cndmask_b32_e32 v68, v68, v73, vcc
		v_xad_u32 v73, v68, -1, 1
		v_cmp_lt_i32_e64 vcc, v69, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v68, v68, v73, s[76:77]
		v_xad_u32 v73, v71, -1, 1
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_mul_hi_u32 v70, v69, v34
		v_mul_lo_u32 v70, v70, v33
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v69, 1, v70, v69
		v_cmp_ge_u32_e64 vcc, v69, v33
		v_add_u32_e32 v70, v69, v35
		v_mul_lo_u32 v75, s10, v13
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_cmp_ge_u32_e64 vcc, v69, v33
		v_add_u32_e32 v70, v69, v35
		v_lshlrev_b32_e32 v76, 1, v68
		v_cndmask_b32_e32 v69, v69, v70, vcc
		v_xad_u32 v70, v69, -1, 1
		v_cmp_lt_i32_e64 vcc, v65, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v69, v69, v70, s[74:75]
		v_lshlrev_b32_e32 v69, 1, v69
		v_cndmask_b32_e32 v65, v65, v74, vcc
		v_mul_hi_u32 v70, v65, v34
		v_mul_lo_u32 v70, v70, v33
		v_xor_b32_e32 v70, -1, v70
		v_add3_u32 v65, 1, v70, v65
		v_cmp_ge_u32_e64 vcc, v65, v33
		v_add_u32_e32 v70, v65, v35
		v_xad_u32 v74, v72, -1, 1
		v_cndmask_b32_e32 v65, v65, v70, vcc
		v_cmp_ge_u32_e64 vcc, v65, v33
		v_add_u32_e32 v70, v65, v35
		v_lshl_add_u32 v68, v68, 1, v10
		v_cndmask_b32_e32 v65, v65, v70, vcc
		v_xad_u32 v70, v65, -1, 1
		v_cmp_lt_i32_e64 vcc, v71, s9
		s_mov_b64 s[74:75], vcc
		v_cndmask_b32_e64 v65, v65, v70, s[76:77]
		v_mul_lo_u32 v13, s15, v13
		v_cndmask_b32_e32 v70, v71, v73, vcc
		v_mul_hi_u32 v71, v70, v34
		v_mul_lo_u32 v71, v71, v33
		v_xor_b32_e32 v71, -1, v71
		v_add3_u32 v70, 1, v71, v70
		v_cmp_ge_u32_e64 vcc, v70, v33
		v_add_u32_e32 v71, v70, v35
		v_readfirstlane_b32 s71, v0
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_cmp_ge_u32_e64 vcc, v70, v33
		v_add_u32_e32 v71, v70, v35
		s_lshr_b32 s71, s71, 6
		v_cndmask_b32_e32 v70, v70, v71, vcc
		v_xad_u32 v71, v70, -1, 1
		v_cmp_lt_i32_e64 vcc, v72, s9
		s_mov_b64 s[76:77], vcc
		v_cndmask_b32_e64 v70, v70, v71, s[74:75]
		s_mul_i32 s71, 0x420, s71
		v_cndmask_b32_e32 v71, v72, v74, vcc
		v_mul_hi_u32 v72, v71, v34
		v_mul_lo_u32 v72, v72, v33
		v_xor_b32_e32 v72, -1, v72
		v_add3_u32 v71, 1, v72, v71
		v_cmp_ge_u32_e64 vcc, v71, v33
		v_add_u32_e32 v72, v71, v35
		v_lshl_add_u32 v73, v13, 1, v40
		v_cndmask_b32_e32 v71, v71, v72, vcc
		v_cmp_ge_u32_e64 vcc, v71, v33
		v_add_u32_e32 v72, v71, v35
		s_mov_b32 m0, s71
		v_cndmask_b32_e32 v71, v71, v72, vcc
		v_xad_u32 v72, v71, -1, 1
		v_cndmask_b32_e64 v71, v71, v72, s[76:77]
		s_and_saveexec_b64 s[86:87], s[24:25]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_0
		buffer_load_dwordx4 v73, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_0:
		s_mov_b64 exec, s[86:87]
		s_add_i32 m0, s71, 0x62e0
		s_and_saveexec_b64 s[86:87], s[26:27]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_1
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_1:
		s_mov_b64 exec, s[86:87]
		v_add3_u32 v68, v10, v76, s64
		s_add_i32 m0, s71, 0x83e0
		s_and_saveexec_b64 s[86:87], s[28:29]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_2
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_2:
		s_mov_b64 exec, s[86:87]
		v_lshlrev_b32_e32 v13, 1, v13
		v_add3_u32 v13, v40, v13, 64
		s_add_i32 m0, s71, 0x2100
		s_and_saveexec_b64 s[86:87], s[30:31]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_3
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_3:
		s_mov_b64 exec, s[86:87]
		v_add3_u32 v13, v10, v76, s65
		s_add_i32 m0, s71, 0xa4e0
		s_and_saveexec_b64 s[86:87], s[32:33]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_4
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_4:
		s_mov_b64 exec, s[86:87]
		v_add3_u32 v13, v10, v76, s66
		s_add_i32 m0, s71, 0xc5e0
		s_and_saveexec_b64 s[86:87], s[34:35]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_5
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_5:
		s_mov_b64 exec, s[86:87]
		v_add_u32_e32 v13, 0x80, v73
		s_add_i32 m0, s71, 0x4200
		s_and_saveexec_b64 s[86:87], s[36:37]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_6
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_6:
		s_mov_b64 exec, s[86:87]
		v_add3_u32 v13, v10, v76, s67
		s_add_i32 m0, s71, 0xe6e0
		s_and_saveexec_b64 s[86:87], s[38:39]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_7
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_7:
		s_mov_b64 exec, s[86:87]
		v_add3_u32 v13, v10, v76, s68
		s_add_i32 m0, s71, 0x107e0
		s_and_saveexec_b64 s[86:87], s[40:41]
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_8
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_8:
		s_mov_b64 exec, s[86:87]
		s_waitcnt vmcnt(3)
		s_barrier
		ds_read_b128 v[80:83], v38
		ds_read_b128 v[84:87], v38 offset:2112
		ds_read_b128 v[88:91], v38 offset:4224
		ds_read_b128 v[92:95], v38 offset:6336
		ds_read_b64_tr_b16 v[96:97], v36 offset:25312
		ds_read_b64_tr_b16 v[98:99], v36 offset:33760
		ds_read_b64_tr_b16 v[100:101], v36 offset:25440
		ds_read_b64_tr_b16 v[102:103], v36 offset:33888
		ds_read_b64_tr_b16 v[104:105], v36 offset:25568
		ds_read_b64_tr_b16 v[106:107], v36 offset:34016
		ds_read_b64_tr_b16 v[108:109], v36 offset:25696
		ds_read_b64_tr_b16 v[110:111], v36 offset:34144
		s_mov_b32 s74, 0
		v_add_u32_e32 v13, v41, v75
		s_mov_b32 s75, 0
		s_cmp_lg_u32 s11, 0
		v_mov_b32_e32 v72, v4
		v_mov_b32_e32 v73, v5
		v_mov_b32_e32 v74, v6
		v_mov_b32_e32 v75, v7
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
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_persistent.loop_exit_1
.Ltlx_addmm_glu_kernel_persistent.loop_head_1:
		s_lshl_b32 s76, s75, 6
		s_cmp_ge_u32 s74, 2
		s_cselect_b32 s77, 1, 0
		s_add_i32 s78, s74, -2
		s_add_i32 s79, s74, 1
		s_cmp_lg_u32 s77, 0
		s_cselect_b32 s77, s78, s79
		s_cselect_b32 s80, 1, 0
		s_add_i32 s81, s75, 3
		s_mul_i32 s81, s81, 32
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[72:75], v[96:99], v[80:83], v[72:75]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[84:87], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[92:95], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[92:95], v[164:167]
		s_xor_b32 s81, s81, -1
		s_add_i32 s81, s81, 1
		s_add_i32 s81, s14, s81
		s_barrier
		s_mul_i32 s82, 0x2100, s74
		v_cmp_lt_i32_e64 vcc, v31, s81
		s_add_i32 m0, s71, s82
		s_and_saveexec_b64 s[86:87], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_9
		buffer_load_dwordx4 v13, s[44:47], s76 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_9:
		s_mov_b64 exec, s[86:87]
		s_mul_i32 s74, 0x4200, s74
		s_add_i32 s74, s71, s74
		s_mul_i32 s76, s17, s75
		s_lshl_b32 s76, s76, 6
		s_add_i32 s82, s69, s76
		v_add3_u32 v68, v10, v76, s82
		v_cmp_lt_i32_e64 vcc, v11, s81
		s_add_i32 m0, s74, 0x62e0
		s_and_saveexec_b64 s[86:87], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_10
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_10:
		s_mov_b64 exec, s[86:87]
		s_add_i32 s76, s70, s76
		v_add3_u32 v68, v10, v76, s76
		v_cmp_lt_i32_e64 vcc, v12, s81
		s_add_i32 m0, s74, 0x83e0
		s_and_saveexec_b64 s[86:87], vcc
		s_cbranch_execz .Ltlx_addmm_glu_kernel_persistent.exec_endif_11
		buffer_load_dwordx4 v68, s[48:51], 0 offen lds
.Ltlx_addmm_glu_kernel_persistent.exec_endif_11:
		s_mov_b64 exec, s[86:87]
		s_waitcnt vmcnt(3)
		s_barrier
		s_mul_i32 s74, 0x2100, s77
		v_add_u32_e32 v68, s74, v38
		ds_read_b128 v[80:83], v68
		ds_read_b128 v[84:87], v68 offset:2112
		ds_read_b128 v[88:91], v68 offset:4224
		ds_read_b128 v[92:95], v68 offset:6336
		s_mul_i32 s74, 0x4200, s77
		v_add_u32_e32 v68, s74, v36
		ds_read_b64_tr_b16 v[96:97], v68 offset:25312
		ds_read_b64_tr_b16 v[98:99], v68 offset:33760
		ds_read_b64_tr_b16 v[100:101], v68 offset:25440
		ds_read_b64_tr_b16 v[102:103], v68 offset:33888
		ds_read_b64_tr_b16 v[104:105], v68 offset:25568
		ds_read_b64_tr_b16 v[106:107], v68 offset:34016
		ds_read_b64_tr_b16 v[108:109], v68 offset:25696
		ds_read_b64_tr_b16 v[110:111], v68 offset:34144
		s_cmp_lg_u32 s80, 0
		s_cselect_b32 s74, s78, s79
		s_add_i32 s75, s75, 1
		s_cmp_lt_i32 s75, s23
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_persistent.loop_head_1
.Ltlx_addmm_glu_kernel_persistent.loop_exit_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[72:75], v[96:99], v[80:83], v[72:75]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[84:87], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[92:95], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[92:95], v[164:167]
		ds_read_b128 v[80:83], v42
		ds_read_b128 v[84:87], v42 offset:2112
		ds_read_b128 v[88:91], v42 offset:4224
		ds_read_b128 v[92:95], v42 offset:6336
		ds_read_b64_tr_b16 v[96:97], v43 offset:25312
		ds_read_b64_tr_b16 v[98:99], v43 offset:33760
		ds_read_b64_tr_b16 v[100:101], v43 offset:25440
		ds_read_b64_tr_b16 v[102:103], v43 offset:33888
		ds_read_b64_tr_b16 v[104:105], v43 offset:25568
		ds_read_b64_tr_b16 v[106:107], v43 offset:34016
		ds_read_b64_tr_b16 v[108:109], v43 offset:25696
		ds_read_b64_tr_b16 v[110:111], v43 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[72:75], v[96:99], v[80:83], v[72:75]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[80:83], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[84:87], v[124:127]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[88:91], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[92:95], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[92:95], v[164:167]
		ds_read_b128 v[80:83], v44
		ds_read_b128 v[84:87], v44 offset:2112
		ds_read_b128 v[88:91], v44 offset:4224
		ds_read_b128 v[92:95], v44 offset:6336
		ds_read_b64_tr_b16 v[96:97], v45 offset:25312
		ds_read_b64_tr_b16 v[98:99], v45 offset:33760
		ds_read_b64_tr_b16 v[100:101], v45 offset:25440
		ds_read_b64_tr_b16 v[102:103], v45 offset:33888
		ds_read_b64_tr_b16 v[104:105], v45 offset:25568
		ds_read_b64_tr_b16 v[106:107], v45 offset:34016
		ds_read_b64_tr_b16 v[108:109], v45 offset:25696
		ds_read_b64_tr_b16 v[110:111], v45 offset:34144
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[72:75], v[96:99], v[80:83], v[72:75]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[80:83], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[80:83], v[116:119]
		buffer_load_dwordx2 v[78:79], v69, s[52:55], 0 offen
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[108:111], v[80:83], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[108:111], v[84:87], v[136:139]
		v_lshlrev_b32_e32 v13, 1, v65
		buffer_load_dwordx2 v[68:69], v13, s[52:55], 0 offen
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[84:87], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[84:87], v[128:131]
		v_lshlrev_b32_e32 v13, 1, v70
		buffer_load_dwordx2 v[80:81], v13, s[52:55], 0 offen
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[104:107], v[88:91], v[148:151]
		v_lshlrev_b32_e32 v13, 1, v71
		buffer_load_dwordx2 v[70:71], v13, s[52:55], 0 offen
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[108:111], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[92:95], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[92:95], v[164:167]
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v84, v78
		v_cvt_f32_f16_sdwa v85, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v79
		v_cvt_f32_f16_sdwa v87, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v88, v68
		v_cvt_f32_f16_sdwa v89, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v90, v69
		v_cvt_f32_f16_sdwa v91, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v92, v80
		v_cvt_f32_f16_sdwa v93, v80 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v94, v81
		v_cvt_f32_f16_sdwa v95, v81 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v80, v70
		v_lshl_add_u32 v13, v15, 1, v76
		buffer_load_dwordx4 v[96:99], v13, s[4:7], 0 offen sc0 nt
		v_cvt_f32_f16_sdwa v81, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v71
		v_cvt_f32_f16_sdwa v83, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_lshl_add_u32 v13, v51, 1, v76
		buffer_load_dwordx4 v[68:71], v13, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v13, v61, 1, v76
		buffer_load_dwordx4 v[100:103], v13, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v13, v62, 1, v76
		buffer_load_dwordx4 v[104:107], v13, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v13, v56, 1, v76
		buffer_load_dwordx4 v[108:111], v13, s[4:7], 0 offen sc0 nt
		v_lshl_add_u32 v13, v63, 1, v76
		buffer_load_dwordx4 v[172:175], v13, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v13, s18, v64
		v_lshl_add_u32 v13, v13, 1, v76
		buffer_load_dwordx4 v[176:179], v13, s[4:7], 0 offen sc0 nt
		v_mul_lo_u32 v13, s18, v66
		v_lshl_add_u32 v13, v13, 1, v76
		buffer_load_dwordx4 v[76:79], v13, s[4:7], 0 offen sc0 nt
		s_barrier
		s_waitcnt vmcnt(7)
		v_cvt_f32_f16_e32 v62, v96
		v_cvt_f32_f16_sdwa v63, v96 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v64, v97
		v_cvt_f32_f16_sdwa v65, v97 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v96, v98
		v_cvt_f32_f16_sdwa v97, v98 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v180, v99
		v_cvt_f32_f16_sdwa v181, v99 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(6)
		v_cvt_f32_f16_e32 v98, v68
		v_cvt_f32_f16_sdwa v99, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v182, v69
		v_cvt_f32_f16_sdwa v183, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v68, v70
		v_cvt_f32_f16_sdwa v69, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v184, v71
		v_cvt_f32_f16_sdwa v185, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(5)
		v_cvt_f32_f16_e32 v70, v100
		v_cvt_f32_f16_sdwa v71, v100 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v186, v101
		v_cvt_f32_f16_sdwa v187, v101 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v100, v102
		v_cvt_f32_f16_sdwa v101, v102 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v188, v103
		v_cvt_f32_f16_sdwa v189, v103 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(4)
		v_cvt_f32_f16_e32 v102, v104
		v_cvt_f32_f16_sdwa v103, v104 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v190, v105
		v_cvt_f32_f16_sdwa v191, v105 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v104, v106
		v_cvt_f32_f16_sdwa v105, v106 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v192, v107
		v_cvt_f32_f16_sdwa v193, v107 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(3)
		v_cvt_f32_f16_e32 v106, v108
		v_cvt_f32_f16_sdwa v107, v108 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v194, v109
		v_cvt_f32_f16_sdwa v195, v109 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v108, v110
		v_cvt_f32_f16_sdwa v109, v110 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v196, v111
		v_cvt_f32_f16_sdwa v197, v111 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(2)
		v_cvt_f32_f16_e32 v110, v172
		v_cvt_f32_f16_sdwa v111, v172 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v198, v173
		v_cvt_f32_f16_sdwa v199, v173 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v172, v174
		v_cvt_f32_f16_sdwa v173, v174 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v200, v175
		v_cvt_f32_f16_sdwa v201, v175 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v174, v176
		v_cvt_f32_f16_sdwa v175, v176 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v202, v177
		v_cvt_f32_f16_sdwa v203, v177 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v176, v178
		v_cvt_f32_f16_sdwa v177, v178 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v204, v179
		v_cvt_f32_f16_sdwa v205, v179 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v178, v76
		v_cvt_f32_f16_sdwa v179, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v206, v77
		v_cvt_f32_f16_sdwa v207, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v76, v78
		v_cvt_f32_f16_sdwa v77, v78 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v208, v79
		v_cvt_f32_f16_sdwa v209, v79 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_pk_add_f32 v[212:213], v[72:73], v[84:85]
		v_pk_add_f32 v[214:215], v[74:75], v[86:87]
		ds_write_b128 v52, v[212:215] offset:10432
		v_pk_add_f32 v[72:73], v[112:113], v[88:89]
		v_pk_add_f32 v[74:75], v[114:115], v[90:91]
		ds_write_b128 v57, v[72:75] offset:10432
		v_pk_add_f32 v[72:73], v[116:117], v[92:93]
		v_pk_add_f32 v[74:75], v[118:119], v[94:95]
		ds_write_b128 v58, v[72:75] offset:10432
		v_pk_add_f32 v[72:73], v[120:121], v[80:81]
		v_pk_add_f32 v[74:75], v[122:123], v[82:83]
		ds_write_b128 v46, v[72:75] offset:10432
		v_pk_add_f32 v[72:73], v[124:125], v[84:85]
		v_pk_add_f32 v[74:75], v[126:127], v[86:87]
		v_pk_add_f32 v[112:113], v[128:129], v[88:89]
		v_pk_add_f32 v[114:115], v[130:131], v[90:91]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_add_f32 v[116:117], v[132:133], v[92:93]
		v_pk_add_f32 v[118:119], v[134:135], v[94:95]
		v_pk_add_f32 v[120:121], v[136:137], v[80:81]
		v_pk_add_f32 v[122:123], v[138:139], v[82:83]
		v_pk_add_f32 v[124:125], v[140:141], v[84:85]
		v_pk_add_f32 v[126:127], v[142:143], v[86:87]
		v_pk_add_f32 v[128:129], v[144:145], v[88:89]
		v_pk_add_f32 v[130:131], v[146:147], v[90:91]
		v_pk_add_f32 v[132:133], v[148:149], v[92:93]
		v_pk_add_f32 v[134:135], v[150:151], v[94:95]
		v_pk_add_f32 v[136:137], v[152:153], v[80:81]
		v_pk_add_f32 v[138:139], v[154:155], v[82:83]
		v_pk_add_f32 v[140:141], v[156:157], v[84:85]
		v_pk_add_f32 v[142:143], v[158:159], v[86:87]
		v_pk_add_f32 v[84:85], v[160:161], v[88:89]
		v_pk_add_f32 v[86:87], v[162:163], v[90:91]
		v_pk_add_f32 v[88:89], v[164:165], v[92:93]
		v_pk_add_f32 v[90:91], v[166:167], v[94:95]
		v_pk_add_f32 v[92:93], v[168:169], v[80:81]
		v_pk_add_f32 v[94:95], v[170:171], v[82:83]
		ds_read_b128 v[80:83], v39 offset:10432
		ds_read_b128 v[144:147], v53 offset:10432
		ds_read_b128 v[148:151], v54 offset:10432
		ds_read_b128 v[152:155], v1 offset:10432
		v_cmp_lt_i32_e64 vcc, v37, s12
		s_mov_b64 s[74:75], vcc
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[160:161], v[80:81], v[62:63], v[80:81]
		v_pk_fma_f32 v[162:163], v[82:83], v[64:65], v[82:83]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[164:165], v[144:145], v[96:97], v[144:145]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v52, v[72:75] offset:10432
		ds_write_b128 v57, v[112:115] offset:10432
		ds_write_b128 v58, v[116:119] offset:10432
		ds_write_b128 v46, v[120:123] offset:10432
		v_pk_fma_f32 v[166:167], v[146:147], v[180:181], v[146:147]
		v_pk_fma_f32 v[112:113], v[148:149], v[98:99], v[148:149]
		v_pk_fma_f32 v[114:115], v[150:151], v[182:183], v[150:151]
		v_pk_fma_f32 v[116:117], v[152:153], v[68:69], v[152:153]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[72:75], v39 offset:10432
		ds_read_b128 v[80:83], v53 offset:10432
		ds_read_b128 v[96:99], v54 offset:10432
		ds_read_b128 v[120:123], v1 offset:10432
		v_pk_fma_f32 v[118:119], v[154:155], v[184:185], v[154:155]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[144:145], v[72:73], v[70:71], v[72:73]
		v_pk_fma_f32 v[146:147], v[74:75], v[186:187], v[74:75]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[148:149], v[80:81], v[100:101], v[80:81]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v52, v[124:127] offset:10432
		ds_write_b128 v57, v[128:131] offset:10432
		ds_write_b128 v58, v[132:135] offset:10432
		ds_write_b128 v46, v[136:139] offset:10432
		v_pk_fma_f32 v[150:151], v[82:83], v[188:189], v[82:83]
		v_pk_fma_f32 v[128:129], v[96:97], v[102:103], v[96:97]
		v_pk_fma_f32 v[130:131], v[98:99], v[190:191], v[98:99]
		v_pk_fma_f32 v[132:133], v[120:121], v[104:105], v[120:121]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v39 offset:10432
		ds_read_b128 v[72:75], v53 offset:10432
		ds_read_b128 v[80:83], v54 offset:10432
		ds_read_b128 v[96:99], v1 offset:10432
		v_pk_fma_f32 v[134:135], v[122:123], v[192:193], v[122:123]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[120:121], v[68:69], v[106:107], v[68:69]
		v_pk_fma_f32 v[122:123], v[70:71], v[194:195], v[70:71]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[124:125], v[72:73], v[108:109], v[72:73]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v52, v[140:143] offset:10432
		ds_write_b128 v57, v[84:87] offset:10432
		ds_write_b128 v58, v[88:91] offset:10432
		ds_write_b128 v46, v[92:95] offset:10432
		v_pk_fma_f32 v[126:127], v[74:75], v[196:197], v[74:75]
		v_pk_fma_f32 v[88:89], v[80:81], v[110:111], v[80:81]
		v_pk_fma_f32 v[90:91], v[82:83], v[198:199], v[82:83]
		v_pk_fma_f32 v[92:93], v[96:97], v[172:173], v[96:97]
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 v[68:71], v39 offset:10432
		ds_read_b128 v[72:75], v53 offset:10432
		ds_read_b128 v[80:83], v54 offset:10432
		ds_read_b128 v[84:87], v1 offset:10432
		v_pk_fma_f32 v[94:95], v[98:99], v[200:201], v[98:99]
		s_waitcnt lgkmcnt(3)
		v_pk_fma_f32 v[96:97], v[68:69], v[174:175], v[68:69]
		v_pk_fma_f32 v[98:99], v[70:71], v[202:203], v[70:71]
		s_waitcnt lgkmcnt(2)
		v_pk_fma_f32 v[100:101], v[72:73], v[176:177], v[72:73]
		v_pk_fma_f32 v[102:103], v[74:75], v[204:205], v[74:75]
		s_waitcnt lgkmcnt(1)
		v_pk_fma_f32 v[104:105], v[80:81], v[178:179], v[80:81]
		v_pk_fma_f32 v[106:107], v[82:83], v[206:207], v[82:83]
		s_waitcnt lgkmcnt(0)
		v_pk_fma_f32 v[108:109], v[84:85], v[76:77], v[84:85]
		v_pk_fma_f32 v[110:111], v[86:87], v[208:209], v[86:87]
		v_cmp_lt_i32_e64 vcc, v67, s13
		s_mov_b64 s[76:77], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v160, v161
		v_cvt_pk_f16_f32 v65, v162, v163
		v_cvt_pk_f16_f32 v66, v164, v165
		v_cvt_pk_f16_f32 v67, v166, v167
		s_lshl_b32 s16, s16, 10
		s_add_i32 s71, s73, s16
		s_lshl_b32 s72, s72, 8
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[64:67], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v47, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v112, v113
		v_cvt_pk_f16_f32 v65, v114, v115
		v_cvt_pk_f16_f32 v66, v116, v117
		v_cvt_pk_f16_f32 v67, v118, v119
		s_add_i32 s71, s21, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[64:67], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v48, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v144, v145
		v_cvt_pk_f16_f32 v65, v146, v147
		v_cvt_pk_f16_f32 v66, v148, v149
		v_cvt_pk_f16_f32 v67, v150, v151
		s_add_i32 s71, s42, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[64:67], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v49, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v64, v128, v129
		v_cvt_pk_f16_f32 v65, v130, v131
		v_cvt_pk_f16_f32 v66, v132, v133
		v_cvt_pk_f16_f32 v67, v134, v135
		s_add_i32 s71, s43, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[64:67], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v50, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v48, v120, v121
		v_cvt_pk_f16_f32 v49, v122, v123
		v_cvt_pk_f16_f32 v50, v124, v125
		v_cvt_pk_f16_f32 v51, v126, v127
		s_add_i32 s71, s60, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[48:51], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v55, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v48, v88, v89
		v_cvt_pk_f16_f32 v49, v90, v91
		v_cvt_pk_f16_f32 v50, v92, v93
		v_cvt_pk_f16_f32 v51, v94, v95
		s_add_i32 s71, s61, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[48:51], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v59, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v48, v96, v97
		v_cvt_pk_f16_f32 v49, v98, v99
		v_cvt_pk_f16_f32 v50, v100, v101
		v_cvt_pk_f16_f32 v51, v102, v103
		s_add_i32 s71, s62, s73
		s_add_i32 s71, s71, s16
		s_add_i32 s71, s71, s72
		v_add3_u32 v13, s71, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[48:51], v13, s[56:59], 0 offen sc0 nt
		v_cmp_lt_i32_e64 vcc, v60, s12
		s_mov_b64 s[74:75], vcc
		s_and_b32 s78, s74, s76
		s_and_b32 s79, s75, s77
		v_cvt_pk_f16_f32 v48, v104, v105
		v_cvt_pk_f16_f32 v49, v106, v107
		v_cvt_pk_f16_f32 v50, v108, v109
		v_cvt_pk_f16_f32 v51, v110, v111
		s_add_i32 s71, s63, s73
		s_add_i32 s16, s71, s16
		s_add_i32 s16, s16, s72
		v_add3_u32 v13, s16, v3, v8
		v_cndmask_b32_e64 v13, v9, v13, s[78:79]
		buffer_store_dwordx4 v[48:51], v13, s[56:59], 0 offen sc0 nt
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
		.amdhsa_next_free_vgpr 216
		.amdhsa_next_free_sgpr 88
		.amdhsa_accum_offset 216
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
	.set .Ltlx_addmm_glu_kernel_persistent.num_vgpr, 216
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
    .vgpr_count:     216
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
