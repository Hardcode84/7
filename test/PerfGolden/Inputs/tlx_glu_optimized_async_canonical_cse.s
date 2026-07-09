	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	tlx_addmm_glu_kernel_optimized_async
	.p2align	8
	.type	tlx_addmm_glu_kernel_optimized_async,@function
tlx_addmm_glu_kernel_optimized_async:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .Ltlx_addmm_glu_kernel_optimized_async.kernarg_preload_entry
	.p2align	8
.Ltlx_addmm_glu_kernel_optimized_async.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s18, s[0:1], 0x3c
		s_load_dword s19, s[0:1], 0x40
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 s0, s12, 0x7f
		s_mov_b32 s1, 0x7f
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s20, s1, 0
		s_add_i32 s0, s0, s20
		s_ashr_i32 s0, s0, 7
		s_add_i32 s20, s13, 0x7f
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s20, s1
		s_ashr_i32 s1, s1, 7
		s_mul_i32 s20, s0, s1
		s_mov_b32 s21, 31
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s21, s21, 0
		s_add_i32 s20, s20, s21
		s_ashr_i32 s20, s20, 5
		s_mul_i32 s20, s20, 32
		s_cmp_ge_i32 s16, s20
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.if_else_0
		s_mov_b32 s20, s16
		s_branch .Ltlx_addmm_glu_kernel_optimized_async.if_end_0
.Ltlx_addmm_glu_kernel_optimized_async.if_else_0:
		s_and_b32 s21, s16, 7
		s_lshr_b32 s16, s16, 3
		s_lshr_b32 s22, s16, 2
		s_mul_i32 s22, s22, 32
		s_mul_i32 s21, s21, 4
		s_add_i32 s21, s22, s21
		s_and_b32 s16, s16, 3
		s_add_i32 s20, s21, s16
.Ltlx_addmm_glu_kernel_optimized_async.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s20, 0
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s21, s20, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s21, s20
		s_cselect_b32 s21, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		v_mov_b32_e32 v1, s22
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s16, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s16, s16, s25
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s23, s26, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s16, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s16, s26, s16
		s_cmp_ge_u32 s16, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s23
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s1, s20, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s20, s22, -1
		s_add_i32 s20, s20, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s20, s22
		s_mul_i32 s20, s1, 4
		s_xor_b32 s22, s20, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s0, s0, s22
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s22, s16, s24
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s16, s22, s16
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s16
		s_cselect_b32 s22, 1, 0
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s24, s0, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s24, s0
		v_mov_b32_e32 v1, s23
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_xor_b32 s25, s23, -1
		s_add_i32 s25, s25, 1
		s_mul_i32 s26, s25, s24
		s_mul_hi_u32 s26, s24, s26
		s_add_i32 s24, s24, s26
		s_mul_hi_u32 s24, s21, s24
		s_mul_i32 s26, s24, s23
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		s_add_i32 s21, s21, s26
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s21, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s21, s27, s21
		s_cselect_b32 s26, 1, 0
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s23, 1, 0
		s_add_i32 s25, s21, s25
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s21, s25, s21
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s25, s21, -1
		s_add_i32 s25, s25, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s21, s25, s21
		s_add_i32 s20, s20, s21
		s_add_i32 s22, s24, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s22, s22, s24
		s_add_i32 s24, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s0, s16, s0
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, 1, 0
		s_xor_b32 s16, s22, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s16, s22
		s_mul_i32 s16, s20, 0x80
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v3, 1, v1
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v9
		v_mad_u32_u24 v10, v3, 16, v10
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v12, 1, v11
		v_mad_u32_u24 v10, v12, 64, v10
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v14, 1, v13
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v16, 1, v15
		v_mov_b32_e32 v17, 2
		v_mul_lo_u32 v17, v17, v16
		v_add3_u32 v10, v10, v14, v17
		v_lshrrev_b32_e32 v16, 8, v0
		v_and_b32_e32 v18, 1, v16
		v_mad_u32_u24 v10, v18, 4, v10
		v_and_b32_e32 v19, 15, v0
		v_and_b32_e32 v20, 63, v0
		v_and_b32_e32 v21, 15, v8
		v_mov_b32_e32 v22, 4
		v_mul_lo_u32 v22, v22, v21
		v_and_b32_e32 v21, 7, v13
		v_add_u32_e32 v23, 0x48, v21
		v_add_u32_e32 v24, 0x50, v21
		v_add_u32_e32 v25, 0x58, v21
		v_add_u32_e32 v26, 0x60, v21
		v_add_u32_e32 v27, 0x68, v21
		v_add_u32_e32 v28, 0x70, v21
		v_add_u32_e32 v29, 0x78, v21
		v_and_b32_e32 v30, 1, v0
		v_lshrrev_b32_e32 v31, 1, v0
		v_and_b32_e32 v32, 1, v31
		v_mad_u32_u24 v30, v32, 2, v30
		v_lshrrev_b32_e32 v32, 2, v0
		v_and_b32_e32 v33, 1, v32
		v_mad_u32_u24 v30, v33, 4, v30
		v_mad_u32_u24 v3, v3, 8, v30
		v_mad_u32_u24 v3, v18, 16, v3
		v_add_u32_e32 v30, 0x60, v3
		v_add_u32_e32 v33, s16, v10
		s_mul_i32 s20, s0, 0x80
		s_mov_b32 s22, 0
		v_cmp_lt_i32_e64 vcc, v33, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v34, v33, -1, 1
		v_add3_u32 v10, 8, v10, s16
		v_cndmask_b32_e32 v33, v33, v34, vcc
		s_cmp_lt_i32 s12, 0
		s_mov_b32 s26, -1
		s_mov_b32 s27, -1
		s_mov_b32 s28, 0
		s_mov_b32 s29, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_xor_b32 s23, s12, -1
		s_add_i32 s23, s23, 1
		v_mov_b32_e32 v34, s12
		v_mov_b32_e32 v35, s23
		v_cndmask_b32_e64 v34, v34, v35, s[30:31]
		v_cvt_f32_u32_e32 v35, v34
		v_rcp_iflag_f32_e32 v35, v35
		s_nop 0
		v_mul_f32_e32 v35, v2, v35
		v_cvt_u32_f32_e32 v35, v35
		v_xad_u32 v36, v34, -1, 1
		v_mul_lo_u32 v37, v36, v35
		v_mul_hi_u32 v37, v35, v37
		v_add_u32_e32 v35, v35, v37
		v_mul_hi_u32 v37, v33, v35
		v_mul_lo_u32 v37, v37, v34
		v_xor_b32_e32 v37, -1, v37
		v_add3_u32 v33, 1, v37, v33
		v_add_u32_e32 v37, v33, v36
		v_add_u32_e32 v38, s16, v21
		v_cmp_ge_u32_e64 vcc, v33, v34
		s_nop 1
		v_cndmask_b32_e32 v33, v33, v37, vcc
		v_add_u32_e32 v37, v33, v36
		v_add3_u32 v39, 8, v21, s16
		v_cmp_ge_u32_e64 vcc, v33, v34
		s_nop 1
		v_cndmask_b32_e32 v33, v33, v37, vcc
		v_xad_u32 v37, v33, -1, 1
		v_cmp_lt_i32_e64 vcc, v10, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v40, v10, -1, 1
		v_add3_u32 v41, 16, v21, s16
		v_cndmask_b32_e32 v10, v10, v40, vcc
		v_mul_hi_u32 v40, v10, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v10, 1, v40, v10
		v_add_u32_e32 v40, v10, v36
		v_add3_u32 v42, 24, v21, s16
		v_cmp_ge_u32_e64 vcc, v10, v34
		s_nop 1
		v_cndmask_b32_e32 v10, v10, v40, vcc
		v_add_u32_e32 v40, v10, v36
		v_add3_u32 v43, 32, v21, s16
		v_cmp_ge_u32_e64 vcc, v10, v34
		s_nop 1
		v_cndmask_b32_e32 v10, v10, v40, vcc
		v_xad_u32 v40, v10, -1, 1
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v44, v38, -1, 1
		v_add3_u32 v45, 40, v21, s16
		v_cndmask_b32_e32 v38, v38, v44, vcc
		v_mul_hi_u32 v44, v38, v35
		v_mul_lo_u32 v44, v44, v34
		v_xor_b32_e32 v44, -1, v44
		v_add3_u32 v38, 1, v44, v38
		v_add_u32_e32 v44, v38, v36
		v_add3_u32 v46, 48, v21, s16
		v_cmp_ge_u32_e64 vcc, v38, v34
		s_nop 1
		v_cndmask_b32_e32 v38, v38, v44, vcc
		v_add_u32_e32 v44, v38, v36
		v_add3_u32 v47, 56, v21, s16
		v_cmp_ge_u32_e64 vcc, v38, v34
		s_nop 1
		v_cndmask_b32_e32 v38, v38, v44, vcc
		v_xad_u32 v44, v38, -1, 1
		v_cmp_lt_i32_e64 vcc, v39, s22
		s_mov_b64 s[34:35], vcc
		v_xad_u32 v48, v39, -1, 1
		v_add3_u32 v21, 64, v21, s16
		v_cndmask_b32_e32 v39, v39, v48, vcc
		v_mul_hi_u32 v48, v39, v35
		v_mul_lo_u32 v48, v48, v34
		v_xor_b32_e32 v48, -1, v48
		v_add3_u32 v39, 1, v48, v39
		v_add_u32_e32 v48, v39, v36
		v_add_u32_e32 v23, s16, v23
		v_cmp_ge_u32_e64 vcc, v39, v34
		s_nop 1
		v_cndmask_b32_e32 v39, v39, v48, vcc
		v_add_u32_e32 v48, v39, v36
		v_add_u32_e32 v24, s16, v24
		v_cmp_ge_u32_e64 vcc, v39, v34
		s_nop 1
		v_cndmask_b32_e32 v39, v39, v48, vcc
		v_xad_u32 v48, v39, -1, 1
		v_cmp_lt_i32_e64 vcc, v41, s22
		s_mov_b64 s[36:37], vcc
		v_xad_u32 v49, v41, -1, 1
		v_add_u32_e32 v25, s16, v25
		v_cndmask_b32_e32 v41, v41, v49, vcc
		v_mul_hi_u32 v49, v41, v35
		v_mul_lo_u32 v49, v49, v34
		v_xor_b32_e32 v49, -1, v49
		v_add3_u32 v41, 1, v49, v41
		v_add_u32_e32 v49, v41, v36
		v_add_u32_e32 v26, s16, v26
		v_cmp_ge_u32_e64 vcc, v41, v34
		s_nop 1
		v_cndmask_b32_e32 v41, v41, v49, vcc
		v_add_u32_e32 v49, v41, v36
		v_add_u32_e32 v27, s16, v27
		v_cmp_ge_u32_e64 vcc, v41, v34
		s_nop 1
		v_cndmask_b32_e32 v41, v41, v49, vcc
		v_xad_u32 v49, v41, -1, 1
		v_cmp_lt_i32_e64 vcc, v42, s22
		s_mov_b64 s[38:39], vcc
		v_xad_u32 v50, v42, -1, 1
		v_add_u32_e32 v28, s16, v28
		v_cndmask_b32_e32 v42, v42, v50, vcc
		v_mul_hi_u32 v50, v42, v35
		v_mul_lo_u32 v50, v50, v34
		v_xor_b32_e32 v50, -1, v50
		v_add3_u32 v42, 1, v50, v42
		v_add_u32_e32 v50, v42, v36
		v_add_u32_e32 v29, s16, v29
		v_cmp_ge_u32_e64 vcc, v42, v34
		s_nop 1
		v_cndmask_b32_e32 v42, v42, v50, vcc
		v_add_u32_e32 v50, v42, v36
		v_add_u32_e32 v51, s16, v3
		v_cmp_ge_u32_e64 vcc, v42, v34
		s_nop 1
		v_cndmask_b32_e32 v42, v42, v50, vcc
		v_xad_u32 v50, v42, -1, 1
		v_cmp_lt_i32_e64 vcc, v43, s22
		s_mov_b64 s[40:41], vcc
		v_xad_u32 v52, v43, -1, 1
		v_add3_u32 v53, 32, v3, s16
		v_cndmask_b32_e32 v43, v43, v52, vcc
		v_mul_hi_u32 v52, v43, v35
		v_mul_lo_u32 v52, v52, v34
		v_xor_b32_e32 v52, -1, v52
		v_add3_u32 v43, 1, v52, v43
		v_add_u32_e32 v52, v43, v36
		v_add3_u32 v3, 64, v3, s16
		v_cmp_ge_u32_e64 vcc, v43, v34
		s_nop 1
		v_cndmask_b32_e32 v43, v43, v52, vcc
		v_add_u32_e32 v52, v43, v36
		v_add_u32_e32 v30, s16, v30
		v_cmp_ge_u32_e64 vcc, v43, v34
		s_nop 1
		v_cndmask_b32_e32 v43, v43, v52, vcc
		v_xad_u32 v52, v43, -1, 1
		v_cmp_lt_i32_e64 vcc, v45, s22
		s_mov_b64 s[42:43], vcc
		v_xad_u32 v54, v45, -1, 1
		v_mad_u32_u24 v19, v19, 8, s20
		v_cndmask_b32_e32 v45, v45, v54, vcc
		v_mul_hi_u32 v54, v45, v35
		v_mul_lo_u32 v54, v54, v34
		v_xor_b32_e32 v54, -1, v54
		v_add3_u32 v45, 1, v54, v45
		v_add_u32_e32 v54, v45, v36
		v_mad_u32_u24 v20, v20, 2, s20
		v_cmp_ge_u32_e64 vcc, v45, v34
		s_nop 1
		v_cndmask_b32_e32 v45, v45, v54, vcc
		v_add_u32_e32 v54, v45, v36
		v_add_u32_e32 v55, s20, v22
		v_cmp_ge_u32_e64 vcc, v45, v34
		s_nop 1
		v_cndmask_b32_e32 v45, v45, v54, vcc
		v_xad_u32 v54, v45, -1, 1
		v_cmp_lt_i32_e64 vcc, v46, s22
		s_mov_b64 s[44:45], vcc
		v_xad_u32 v56, v46, -1, 1
		v_add3_u32 v22, 64, v22, s20
		v_cndmask_b32_e32 v46, v46, v56, vcc
		v_mul_hi_u32 v56, v46, v35
		v_mul_lo_u32 v56, v56, v34
		v_xor_b32_e32 v56, -1, v56
		v_add3_u32 v46, 1, v56, v46
		v_add_u32_e32 v56, v46, v36
		v_cndmask_b32_e64 v33, v33, v37, s[24:25]
		v_cmp_ge_u32_e64 vcc, v46, v34
		s_nop 1
		v_cndmask_b32_e32 v37, v46, v56, vcc
		v_add_u32_e32 v46, v37, v36
		v_cndmask_b32_e64 v10, v10, v40, s[30:31]
		v_cmp_ge_u32_e64 vcc, v37, v34
		s_nop 1
		v_cndmask_b32_e32 v37, v37, v46, vcc
		v_xad_u32 v40, v37, -1, 1
		v_cmp_lt_i32_e64 vcc, v47, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v46, v47, -1, 1
		v_cndmask_b32_e64 v38, v38, v44, s[32:33]
		v_cndmask_b32_e32 v44, v47, v46, vcc
		v_mul_hi_u32 v46, v44, v35
		v_mul_lo_u32 v46, v46, v34
		v_xor_b32_e32 v46, -1, v46
		v_add3_u32 v44, 1, v46, v44
		v_add_u32_e32 v46, v44, v36
		v_cndmask_b32_e64 v39, v39, v48, s[34:35]
		v_cmp_ge_u32_e64 vcc, v44, v34
		s_nop 1
		v_cndmask_b32_e32 v44, v44, v46, vcc
		v_add_u32_e32 v46, v44, v36
		v_cndmask_b32_e64 v41, v41, v49, s[36:37]
		v_cmp_ge_u32_e64 vcc, v44, v34
		s_nop 1
		v_cndmask_b32_e32 v44, v44, v46, vcc
		v_xad_u32 v46, v44, -1, 1
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v47, v21, -1, 1
		v_cndmask_b32_e64 v42, v42, v50, s[38:39]
		v_cndmask_b32_e32 v21, v21, v47, vcc
		v_mul_hi_u32 v47, v21, v35
		v_mul_lo_u32 v47, v47, v34
		v_xor_b32_e32 v47, -1, v47
		v_add3_u32 v21, 1, v47, v21
		v_add_u32_e32 v47, v21, v36
		v_cndmask_b32_e64 v43, v43, v52, s[40:41]
		v_cmp_ge_u32_e64 vcc, v21, v34
		s_nop 1
		v_cndmask_b32_e32 v21, v21, v47, vcc
		v_add_u32_e32 v47, v21, v36
		v_cndmask_b32_e64 v45, v45, v54, s[42:43]
		v_cmp_ge_u32_e64 vcc, v21, v34
		s_nop 1
		v_cndmask_b32_e32 v21, v21, v47, vcc
		v_xad_u32 v47, v21, -1, 1
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[32:33], vcc
		v_xad_u32 v48, v23, -1, 1
		v_cndmask_b32_e64 v37, v37, v40, s[44:45]
		v_cndmask_b32_e32 v23, v23, v48, vcc
		v_mul_hi_u32 v40, v23, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v23, 1, v40, v23
		v_add_u32_e32 v40, v23, v36
		v_cndmask_b32_e64 v44, v44, v46, s[24:25]
		v_cmp_ge_u32_e64 vcc, v23, v34
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v40, vcc
		v_add_u32_e32 v40, v23, v36
		v_cndmask_b32_e64 v21, v21, v47, s[30:31]
		v_cmp_ge_u32_e64 vcc, v23, v34
		s_nop 1
		v_cndmask_b32_e32 v23, v23, v40, vcc
		v_xad_u32 v40, v23, -1, 1
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v46, v24, -1, 1
		v_cndmask_b32_e64 v23, v23, v40, s[32:33]
		v_cndmask_b32_e32 v24, v24, v46, vcc
		v_mul_hi_u32 v40, v24, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v24, 1, v40, v24
		v_add_u32_e32 v40, v24, v36
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v39, s18, v39
		v_cmp_ge_u32_e64 vcc, v24, v34
		s_nop 1
		v_cndmask_b32_e32 v24, v24, v40, vcc
		v_add_u32_e32 v40, v24, v36
		v_mul_lo_u32 v38, s18, v38
		v_cmp_ge_u32_e64 vcc, v24, v34
		s_nop 1
		v_cndmask_b32_e32 v24, v24, v40, vcc
		v_xad_u32 v40, v24, -1, 1
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v46, v25, -1, 1
		v_cndmask_b32_e64 v24, v24, v40, s[24:25]
		v_cndmask_b32_e32 v25, v25, v46, vcc
		v_mul_hi_u32 v40, v25, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v25, 1, v40, v25
		v_add_u32_e32 v40, v25, v36
		s_lshl_b32 s16, s17, 3
		v_cmp_ge_u32_e64 vcc, v25, v34
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v40, vcc
		v_add_u32_e32 v40, v25, v36
		v_and_b32_e32 v46, 1, v8
		v_cmp_ge_u32_e64 vcc, v25, v34
		s_nop 1
		v_cndmask_b32_e32 v25, v25, v40, vcc
		v_xad_u32 v40, v25, -1, 1
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v47, v26, -1, 1
		v_cndmask_b32_e64 v25, v25, v40, s[30:31]
		v_cndmask_b32_e32 v26, v26, v47, vcc
		v_mul_hi_u32 v40, v26, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v26, 1, v40, v26
		v_add_u32_e32 v40, v26, v36
		v_and_b32_e32 v11, 1, v11
		v_cmp_ge_u32_e64 vcc, v26, v34
		s_nop 1
		v_cndmask_b32_e32 v26, v26, v40, vcc
		v_add_u32_e32 v40, v26, v36
		v_and_b32_e32 v47, 1, v13
		v_cmp_ge_u32_e64 vcc, v26, v34
		s_nop 1
		v_cndmask_b32_e32 v26, v26, v40, vcc
		v_xad_u32 v40, v26, -1, 1
		v_cmp_lt_i32_e64 vcc, v27, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v48, v27, -1, 1
		v_cndmask_b32_e64 v26, v26, v40, s[24:25]
		v_cndmask_b32_e32 v27, v27, v48, vcc
		v_mul_hi_u32 v40, v27, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v27, 1, v40, v27
		v_add_u32_e32 v40, v27, v36
		v_and_b32_e32 v15, 1, v15
		v_cmp_ge_u32_e64 vcc, v27, v34
		s_nop 1
		v_cndmask_b32_e32 v27, v27, v40, vcc
		v_add_u32_e32 v40, v27, v36
		v_mul_lo_u32 v48, s17, v16
		v_cmp_ge_u32_e64 vcc, v27, v34
		s_nop 1
		v_cndmask_b32_e32 v27, v27, v40, vcc
		v_xad_u32 v40, v27, -1, 1
		v_cmp_lt_i32_e64 vcc, v28, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v49, v28, -1, 1
		v_cndmask_b32_e64 v27, v27, v40, s[30:31]
		v_cndmask_b32_e32 v28, v28, v49, vcc
		v_mul_hi_u32 v40, v28, v35
		v_mul_lo_u32 v40, v40, v34
		v_xor_b32_e32 v40, -1, v40
		v_add3_u32 v28, 1, v40, v28
		v_add_u32_e32 v40, v28, v36
		v_mul_lo_u32 v49, s15, v10
		v_cmp_ge_u32_e64 vcc, v28, v34
		s_nop 1
		v_cndmask_b32_e32 v28, v28, v40, vcc
		v_add_u32_e32 v40, v28, v36
		v_and_b32_e32 v31, 1, v31
		v_cmp_ge_u32_e64 vcc, v28, v34
		s_nop 1
		v_cndmask_b32_e32 v28, v28, v40, vcc
		v_xad_u32 v40, v28, -1, 1
		v_cmp_lt_i32_e64 vcc, v29, s22
		s_mov_b64 s[30:31], vcc
		v_xad_u32 v50, v29, -1, 1
		v_cndmask_b32_e64 v28, v28, v40, s[24:25]
		v_cndmask_b32_e32 v29, v29, v50, vcc
		v_mul_hi_u32 v35, v29, v35
		v_mul_lo_u32 v35, v35, v34
		v_xor_b32_e32 v35, -1, v35
		v_add3_u32 v29, 1, v35, v29
		v_add_u32_e32 v35, v29, v36
		v_mov_b32_e32 v40, s13
		v_cmp_ge_u32_e64 vcc, v29, v34
		s_nop 1
		v_cndmask_b32_e32 v29, v29, v35, vcc
		v_add_u32_e32 v35, v29, v36
		s_xor_b32 s20, s13, -1
		v_cmp_ge_u32_e64 vcc, v29, v34
		s_nop 1
		v_cndmask_b32_e32 v29, v29, v35, vcc
		v_xad_u32 v34, v29, -1, 1
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v35, v19, -1, 1
		v_cndmask_b32_e64 v29, v29, v34, s[30:31]
		v_cndmask_b32_e32 v19, v19, v35, vcc
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s30, s26, s28
		s_cselect_b32 s31, s27, s29
		s_add_i32 s20, s20, 1
		v_mov_b32_e32 v34, s20
		v_cndmask_b32_e64 v34, v40, v34, s[30:31]
		v_cvt_f32_u32_e32 v35, v34
		v_rcp_iflag_f32_e32 v35, v35
		s_nop 0
		v_mul_f32_e32 v2, v2, v35
		v_cvt_u32_f32_e32 v2, v2
		v_xad_u32 v35, v34, -1, 1
		v_mul_lo_u32 v36, v35, v2
		v_mul_hi_u32 v36, v2, v36
		v_add_u32_e32 v2, v2, v36
		v_mul_hi_u32 v36, v19, v2
		v_mul_lo_u32 v36, v36, v34
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v19, 1, v36, v19
		v_add_u32_e32 v36, v19, v35
		v_and_b32_e32 v32, 1, v32
		v_cmp_ge_u32_e64 vcc, v19, v34
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v36, vcc
		v_add_u32_e32 v36, v19, v35
		v_and_b32_e32 v40, 1, v0
		v_cmp_ge_u32_e64 vcc, v19, v34
		s_nop 1
		v_cndmask_b32_e32 v19, v19, v36, vcc
		v_xad_u32 v36, v19, -1, 1
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v50, v20, -1, 1
		v_cndmask_b32_e64 v19, v19, v36, s[24:25]
		v_cndmask_b32_e32 v20, v20, v50, vcc
		v_mul_hi_u32 v36, v20, v2
		v_mul_lo_u32 v36, v36, v34
		v_xor_b32_e32 v36, -1, v36
		v_add3_u32 v20, 1, v36, v20
		v_add_u32_e32 v36, v20, v35
		v_mul_lo_u32 v50, s15, v33
		v_cmp_ge_u32_e64 vcc, v20, v34
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v36, vcc
		v_add_u32_e32 v36, v20, v35
		s_mov_b32 s30, 0x7fffffff
		v_cmp_ge_u32_e64 vcc, v20, v34
		s_nop 1
		v_cndmask_b32_e32 v20, v20, v36, vcc
		v_xad_u32 v36, v20, -1, 1
		v_cmp_lt_i32_e64 vcc, v55, s22
		s_mov_b64 s[24:25], vcc
		v_xad_u32 v52, v55, -1, 1
		v_cndmask_b32_e64 v20, v20, v36, s[26:27]
		v_cndmask_b32_e32 v36, v55, v52, vcc
		v_mul_hi_u32 v52, v36, v2
		v_mul_lo_u32 v52, v52, v34
		v_xor_b32_e32 v52, -1, v52
		v_add3_u32 v36, 1, v52, v36
		v_add_u32_e32 v52, v36, v35
		v_mov_b32_e32 v54, 32
		v_mul_lo_u32 v54, v54, v12
		v_cmp_ge_u32_e64 vcc, v36, v34
		s_nop 1
		v_cndmask_b32_e32 v12, v36, v52, vcc
		v_add_u32_e32 v36, v12, v35
		v_and_b32_e32 v52, 7, v0
		v_cmp_ge_u32_e64 vcc, v12, v34
		s_nop 1
		v_cndmask_b32_e32 v12, v12, v36, vcc
		v_xad_u32 v36, v12, -1, 1
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[26:27], vcc
		v_xad_u32 v56, v22, -1, 1
		v_cndmask_b32_e64 v12, v12, v36, s[24:25]
		v_cndmask_b32_e32 v36, v22, v56, vcc
		v_mul_hi_u32 v2, v36, v2
		v_mul_lo_u32 v2, v2, v34
		v_xor_b32_e32 v2, -1, v2
		v_add3_u32 v2, 1, v2, v36
		v_add_u32_e32 v36, v2, v35
		s_mov_b32 s20, 63
		v_cmp_ge_u32_e64 vcc, v2, v34
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v36, vcc
		v_add_u32_e32 v35, v2, v35
		s_add_i32 s23, s14, 63
		v_cmp_ge_u32_e64 vcc, v2, v34
		s_nop 1
		v_cndmask_b32_e32 v2, v2, v35, vcc
		v_xad_u32 v34, v2, -1, 1
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s20, s20, 0
		s_add_i32 s20, s23, s20
		v_mov_b32_e32 v35, 8
		v_mul_lo_u32 v35, v35, v52
		v_mad_u32_u24 v9, v9, 16, v54
		v_add3_u32 v9, v9, v14, v17
		v_mad_u32_u24 v9, v18, 8, v9
		v_add_u32_e32 v14, 4, v9
		v_cmp_lt_i32_e64 vcc, v35, s14
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s2, v0
		v_lshlrev_b32_e32 v17, 4, v40
		v_lshl_add_u32 v18, v50, 1, v17
		v_lshlrev_b32_e32 v36, 6, v32
		v_lshlrev_b32_e32 v50, 5, v31
		v_add3_u32 v18, v18, v36, v50
		v_mov_b32_e32 v52, 0x80000000
		v_cndmask_b32_e32 v54, v52, v18, vcc
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v2, v2, v34, s[26:27]
		v_lshl_add_u32 v34, v49, 1, v17
		v_add3_u32 v34, v34, v36, v50
		s_add_i32 m0, s3, 0x2100
		v_cndmask_b32_e32 v49, v52, v34, vcc
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		s_ashr_i32 s4, s20, 6
		v_lshlrev_b32_e32 v48, 4, v48
		v_lshl_add_u32 v19, v19, 1, v48
		v_mul_lo_u32 v48, s17, v15
		v_lshl_add_u32 v19, v48, 2, v19
		v_mul_lo_u32 v48, s17, v47
		v_lshl_add_u32 v19, v48, 1, v19
		v_mul_lo_u32 v48, s17, v11
		v_lshl_add_u32 v19, v48, 6, v19
		v_mul_lo_u32 v48, s17, v46
		v_lshl_add_u32 v19, v48, 5, v19
		s_add_i32 m0, s3, 0xc5e0
		v_cmp_lt_i32_e64 vcc, v9, s14
		s_mov_b64 s[24:25], vcc
		v_cndmask_b32_e64 v48, v52, v19, s[24:25]
		buffer_load_dwordx4 v48, s[32:35], 0 offen lds
		v_add_u32_e32 v48, s16, v19
		v_cmp_lt_i32_e64 vcc, v14, s14
		s_add_i32 m0, s3, 0xe6e0
		s_nop 0
		v_cndmask_b32_e32 v48, v52, v48, vcc
		buffer_load_dwordx4 v48, s[32:35], 0 offen lds
		s_lshl_b32 s5, s15, 1
		s_add_i32 s15, s14, 0xffffffc0
		v_cmp_lt_i32_e64 vcc, v35, s15
		v_add_u32_e32 v48, 0x80, v18
		v_add3_u32 v17, v17, v36, v50
		s_add_i32 m0, s3, 0x4200
		v_cndmask_b32_e32 v36, v52, v48, vcc
		buffer_load_dwordx4 v36, s[28:31], 0 offen lds
		v_add_u32_e32 v36, 0x80, v34
		s_add_i32 m0, s3, 0x6300
		v_cndmask_b32_e32 v36, v52, v36, vcc
		buffer_load_dwordx4 v36, s[28:31], 0 offen lds
		s_lshl_b32 s16, s17, 7
		v_add_u32_e32 v36, s16, v19
		s_add_i32 m0, s3, 0x107e0
		v_cmp_lt_i32_e64 vcc, v9, s15
		s_mov_b64 s[24:25], vcc
		v_cndmask_b32_e64 v36, v52, v36, s[24:25]
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_mul_i32 s16, 0x88, s17
		v_add_u32_e32 v36, s16, v19
		v_cmp_lt_i32_e64 vcc, v14, s15
		s_add_i32 m0, s3, 0x128e0
		s_nop 0
		v_cndmask_b32_e32 v36, v52, v36, vcc
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		v_and_b32_e32 v13, 3, v13
		s_add_i32 s15, s14, 0xffffff80
		v_cmp_lt_i32_e64 vcc, v35, s15
		v_add_u32_e32 v18, 0x100, v18
		v_and_b32_e32 v0, 63, v0
		s_add_i32 m0, s3, 0x8400
		v_cndmask_b32_e32 v18, v52, v18, vcc
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_add_u32_e32 v18, 0x100, v34
		v_cndmask_b32_e32 v18, v52, v18, vcc
		s_add_i32 m0, s3, 0xa500
		s_lshl_b32 s16, s17, 8
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_add_u32_e32 v18, s16, v19
		s_add_i32 m0, s3, 0x149e0
		v_cmp_lt_i32_e64 vcc, v9, s15
		s_mov_b64 s[24:25], vcc
		v_cndmask_b32_e64 v18, v52, v18, s[24:25]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_mul_i32 s16, 0x108, s17
		v_add_u32_e32 v18, s16, v19
		v_cmp_lt_i32_e64 vcc, v14, s15
		s_nop 1
		v_cndmask_b32_e32 v18, v52, v18, vcc
		s_add_i32 m0, s3, 0x16ae0
		v_lshlrev_b32_e32 v34, 7, v16
		v_lshrrev_b32_e32 v36, 4, v0
		v_lshlrev_b32_e32 v48, 4, v36
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_and_b32_e32 v18, 15, v0
		v_mov_b32_e32 v49, 0x420
		v_mul_lo_u32 v49, v49, v18
		v_add3_u32 v50, v34, v48, v49
		ds_read_b128 v[56:59], v50
		ds_read_b128 v[60:63], v50 offset:64
		ds_read_b128 v[64:67], v50 offset:256
		ds_read_b128 v[68:71], v50 offset:320
		ds_read_b128 v[72:75], v50 offset:512
		ds_read_b128 v[76:79], v50 offset:576
		ds_read_b128 v[80:83], v50 offset:768
		ds_read_b128 v[84:87], v50 offset:832
		v_lshrrev_b32_e32 v0, 5, v0
		v_lshlrev_b32_e32 v0, 8, v0
		v_lshrrev_b32_e32 v54, 2, v18
		v_mov_b32_e32 v88, 0x420
		v_mul_lo_u32 v88, v88, v54
		v_lshlrev_b32_e32 v13, 5, v13
		v_add3_u32 v54, v0, v88, v13
		v_and_b32_e32 v36, 1, v36
		v_mov_b32_e32 v89, 0x1080
		v_mul_lo_u32 v89, v89, v36
		v_and_b32_e32 v18, 3, v18
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v36, v54, v89, v18
		ds_read_b64_tr_b16 v[92:93], v36 offset:50656
		ds_read_b64_tr_b16 v[94:95], v36 offset:59104
		ds_read_b64_tr_b16 v[96:97], v36 offset:51168
		ds_read_b64_tr_b16 v[98:99], v36 offset:59616
		ds_read_b64_tr_b16 v[100:101], v36 offset:50784
		ds_read_b64_tr_b16 v[102:103], v36 offset:59232
		ds_read_b64_tr_b16 v[104:105], v36 offset:51296
		ds_read_b64_tr_b16 v[106:107], v36 offset:59744
		s_add_i32 s15, s4, -3
		v_add_u32_e32 v17, 0x180, v17
		v_mul_lo_u32 v33, s5, v33
		v_add_u32_e32 v54, v17, v33
		v_mul_lo_u32 v10, s5, v10
		v_add_u32_e32 v33, v17, v10
		s_mul_i32 s5, 0x180, s17
		s_mul_i32 s16, 0x188, s17
		v_mov_b32_e32 v108, v4
		v_mov_b32_e32 v109, v5
		v_mov_b32_e32 v110, v6
		v_mov_b32_e32 v111, v7
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
		s_cmp_lt_i32 0, s15
		s_cbranch_scc0 .Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_head_0:
		s_add_i32 s20, s22, 3
		s_mul_i32 s20, s20, 64
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[92:95], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[96:99], v[60:63], v[4:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[104:107], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[76:79], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s20, s14, s20
		v_cmp_lt_i32_e64 vcc, v35, s20
		s_lshl_b32 s23, s22, 7
		s_mul_hi_u32 s24, s22, 0xaaaaaaab
		v_cndmask_b32_e32 v10, v52, v54, vcc
		s_lshr_b32 s24, s24, 1
		s_mul_i32 s24, s24, 3
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s22, s24
		s_mul_i32 s24, 0x4200, s24
		s_add_i32 s24, s3, s24
		s_mov_b32 m0, s24
		v_cndmask_b32_e32 v17, v52, v33, vcc
		buffer_load_dwordx4 v10, s[28:31], s23 offen lds
		s_add_i32 m0, s24, 0x2100
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], s23 offen lds
		s_mul_i32 s23, s17, s22
		s_lshl_b32 s23, s23, 7
		s_add_i32 s25, s5, s23
		v_add_u32_e32 v10, s25, v19
		s_add_i32 m0, s24, 0xc5e0
		v_cmp_lt_i32_e64 vcc, v9, s20
		s_mov_b64 s[26:27], vcc
		v_cndmask_b32_e64 v10, v52, v10, s[26:27]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 s23, s16, s23
		v_add_u32_e32 v10, s23, v19
		v_cmp_lt_i32_e64 vcc, v14, s20
		s_add_i32 m0, s24, 0xe6e0
		s_nop 0
		v_cndmask_b32_e32 v10, v52, v10, vcc
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 s22, s22, 1
		s_mul_hi_u32 s20, s22, 0xaaaaaaab
		s_lshr_b32 s20, s20, 1
		s_mul_i32 s20, s20, 3
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s20, s22, s20
		s_mul_i32 s20, 0x4200, s20
		v_add_u32_e32 v10, s20, v34
		v_add3_u32 v10, v10, v48, v49
		ds_read_b128 v[56:59], v10
		ds_read_b128 v[60:63], v10 offset:64
		ds_read_b128 v[64:67], v10 offset:256
		ds_read_b128 v[68:71], v10 offset:320
		ds_read_b128 v[72:75], v10 offset:512
		ds_read_b128 v[76:79], v10 offset:576
		ds_read_b128 v[80:83], v10 offset:768
		ds_read_b128 v[84:87], v10 offset:832
		v_add_u32_e32 v10, s20, v0
		v_add3_u32 v10, v10, v88, v13
		v_add3_u32 v10, v10, v89, v18
		ds_read_b64_tr_b16 v[92:93], v10 offset:50656
		ds_read_b64_tr_b16 v[94:95], v10 offset:59104
		ds_read_b64_tr_b16 v[96:97], v10 offset:51168
		ds_read_b64_tr_b16 v[98:99], v10 offset:59616
		ds_read_b64_tr_b16 v[100:101], v10 offset:50784
		ds_read_b64_tr_b16 v[102:103], v10 offset:59232
		ds_read_b64_tr_b16 v[104:105], v10 offset:51296
		ds_read_b64_tr_b16 v[106:107], v10 offset:59744
		s_waitcnt vmcnt(4) lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s22, s15
		s_cbranch_scc1 .Ltlx_addmm_glu_kernel_optimized_async.loop_head_0
.Ltlx_addmm_glu_kernel_optimized_async.loop_exit_0:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		s_mul_i32 s2, 0x108, s2
		s_add_i32 m0, s2, 0x18bc0
		v_lshlrev_b32_e32 v0, 1, v20
		v_lshl_add_u32 v9, v38, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x19400
		v_lshl_add_u32 v9, v39, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x19c40
		v_mul_lo_u32 v9, s18, v41
		v_lshl_add_u32 v9, v9, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1a480
		v_mul_lo_u32 v9, s18, v42
		v_lshl_add_u32 v9, v9, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1acc0
		v_mul_lo_u32 v9, s18, v43
		v_lshl_add_u32 v9, v9, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1b500
		v_mul_lo_u32 v9, s18, v45
		v_lshl_add_u32 v9, v9, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1bd40
		v_mul_lo_u32 v9, s18, v37
		v_lshl_add_u32 v9, v9, 1, v0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1c580
		v_mul_lo_u32 v9, s18, v44
		v_lshl_add_u32 v9, v9, 1, v0
		v_mul_lo_u32 v10, s18, v21
		v_lshl_add_u32 v10, v10, 1, v0
		v_mul_lo_u32 v13, s18, v23
		v_lshl_add_u32 v13, v13, 1, v0
		v_mul_lo_u32 v14, s18, v24
		v_lshl_add_u32 v14, v14, 1, v0
		v_mul_lo_u32 v17, s18, v25
		v_lshl_add_u32 v17, v17, 1, v0
		v_mul_lo_u32 v18, s18, v26
		v_lshl_add_u32 v18, v18, 1, v0
		v_mul_lo_u32 v19, s18, v27
		v_lshl_add_u32 v19, v19, 1, v0
		v_mul_lo_u32 v20, s18, v28
		v_lshl_add_u32 v20, v20, 1, v0
		v_mul_lo_u32 v21, s18, v29
		v_lshl_add_u32 v0, v21, 1, v0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[92:95], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[100:103], v[56:59], v[108:111]
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1cdc0
		v_mfma_f32_16x16x32_f16 v[116:119], v[100:103], v[64:67], v[116:119]
		buffer_load_dword v10, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1d600
		v_mfma_f32_16x16x32_f16 v[112:115], v[92:95], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[72:75], v[120:123]
		buffer_load_dword v13, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1de40
		v_mfma_f32_16x16x32_f16 v[124:127], v[100:103], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[100:103], v[80:83], v[132:135]
		buffer_load_dword v14, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1e680
		v_mfma_f32_16x16x32_f16 v[128:131], v[92:95], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[96:99], v[60:63], v[4:7]
		buffer_load_dword v17, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1eec0
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[104:107], v[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[104:107], v[68:71], v[116:119]
		buffer_load_dword v18, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1f700
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[76:79], v[120:123]
		buffer_load_dword v19, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ff40
		v_mfma_f32_16x16x32_f16 v[124:127], v[104:107], v[76:79], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[104:107], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[84:87], v[128:131]
		v_lshlrev_b32_e32 v9, 1, v12
		v_lshlrev_b32_e32 v2, 1, v2
		v_mov_b32_e32 v10, 0x1080
		v_mul_lo_u32 v10, v10, v16
		v_add_u32_e32 v10, 0x10000, v10
		v_mov_b32_e32 v12, 0x108
		v_mul_lo_u32 v12, v12, v40
		v_add_u32_e32 v10, v10, v12
		v_lshlrev_b32_e32 v12, 6, v15
		v_add_u32_e32 v13, v10, v12
		v_lshlrev_b32_e32 v14, 5, v47
		v_lshlrev_b32_e32 v17, 4, v11
		v_add3_u32 v13, v13, v14, v17
		v_lshlrev_b32_e32 v18, 3, v46
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v19, 0x840
		v_mul_lo_u32 v19, v19, v1
		v_add3_u32 v13, v13, v18, v19
		v_mov_b32_e32 v21, 0x420
		v_mul_lo_u32 v21, v21, v32
		v_mov_b32_e32 v23, 0x210
		v_mul_lo_u32 v23, v23, v31
		buffer_load_dword v20, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x20780
		s_add_i32 s2, s4, -2
		buffer_load_dword v0, s[24:27], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s5, s2, -1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s5, s2
		s_cselect_b32 s3, 1, 0
		s_and_b32 s5, s2, 0xffff
		s_lshr_b32 s6, s2, 16
		s_mul_i32 s7, s5, 0xaaab
		s_mul_i32 s5, s5, 0xaaaa
		s_mul_i32 s8, s6, 0xaaab
		s_mul_i32 s6, s6, 0xaaaa
		s_lshr_b32 s7, s7, 16
		s_and_b32 s9, s5, 0xffff
		s_and_b32 s10, s8, 0xffff
		s_add_i32 s7, s7, s9
		s_add_i32 s7, s7, s10
		s_lshr_b32 s5, s5, 16
		s_add_i32 s5, s6, s5
		s_lshr_b32 s6, s8, 16
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s5, s5, s6
		s_lshr_b32 s6, s7, 16
		s_add_i32 s5, s5, s6
		s_lshr_b32 s5, s5, 1
		s_mul_i32 s5, s5, 3
		s_xor_b32 s5, s5, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s2, s2, s5
		s_xor_b32 s5, s2, -1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s5, s2
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v0, s2, v50
		ds_read_b128 v[24:27], v0
		ds_read_b128 v[56:59], v0 offset:64
		ds_read_b128 v[60:63], v0 offset:256
		ds_read_b128 v[64:67], v0 offset:320
		ds_read_b128 v[68:71], v0 offset:512
		ds_read_b128 v[72:75], v0 offset:576
		ds_read_b128 v[76:79], v0 offset:768
		ds_read_b128 v[80:83], v0 offset:832
		s_barrier
		v_add_u32_e32 v0, s2, v36
		ds_read_b64_tr_b16 v[84:85], v0 offset:50656
		ds_read_b64_tr_b16 v[86:87], v0 offset:59104
		ds_read_b64_tr_b16 v[88:89], v0 offset:51168
		ds_read_b64_tr_b16 v[90:91], v0 offset:59616
		ds_read_b64_tr_b16 v[92:93], v0 offset:50784
		ds_read_b64_tr_b16 v[94:95], v0 offset:59232
		ds_read_b64_tr_b16 v[96:97], v0 offset:51296
		ds_read_b64_tr_b16 v[98:99], v0 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[24:27], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[88:91], v[56:59], v[4:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[96:99], v[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[88:91], v[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[96:99], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[88:91], v[80:83], v[128:131]
		s_add_i32 s2, s4, -1
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_cselect_b32 s3, 1, 0
		s_and_b32 s4, s2, 0xffff
		s_lshr_b32 s5, s2, 16
		s_mul_i32 s6, s4, 0xaaab
		s_mul_i32 s4, s4, 0xaaaa
		s_mul_i32 s7, s5, 0xaaab
		s_mul_i32 s5, s5, 0xaaaa
		s_lshr_b32 s6, s6, 16
		s_and_b32 s8, s4, 0xffff
		s_and_b32 s9, s7, 0xffff
		s_add_i32 s6, s6, s8
		s_add_i32 s6, s6, s9
		s_lshr_b32 s4, s4, 16
		s_add_i32 s4, s5, s4
		s_lshr_b32 s5, s7, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s6, 16
		s_add_i32 s4, s4, s5
		s_lshr_b32 s4, s4, 1
		s_mul_i32 s4, s4, 3
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s2, s2, s4
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s2, s4, s2
		s_mul_i32 s2, 0x4200, s2
		v_add_u32_e32 v0, s2, v50
		ds_read_b128 v[24:27], v0
		ds_read_b128 v[56:59], v0 offset:64
		ds_read_b128 v[60:63], v0 offset:256
		ds_read_b128 v[64:67], v0 offset:320
		ds_read_b128 v[68:71], v0 offset:512
		ds_read_b128 v[72:75], v0 offset:576
		ds_read_b128 v[76:79], v0 offset:768
		ds_read_b128 v[80:83], v0 offset:832
		v_add_u32_e32 v0, s2, v36
		ds_read_b64_tr_b16 v[36:37], v0 offset:50656
		ds_read_b64_tr_b16 v[38:39], v0 offset:59104
		ds_read_b64_tr_b16 v[84:85], v0 offset:51168
		ds_read_b64_tr_b16 v[86:87], v0 offset:59616
		ds_read_b64_tr_b16 v[88:89], v0 offset:50784
		ds_read_b64_tr_b16 v[90:91], v0 offset:59232
		ds_read_b64_tr_b16 v[92:93], v0 offset:51296
		ds_read_b64_tr_b16 v[94:95], v0 offset:59744
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[4:7], v[36:39], v[24:27], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[36:39], v[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[36:39], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[68:71], v[124:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[76:79], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[36:39], v[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[4:7], v[84:87], v[56:59], v[4:7]
		s_nop 7
		v_mov_b64_e32 v[24:25], v[4:5]
		v_mov_b64_e32 v[4:5], v[6:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[56:59], v[108:111]
		s_nop 7
		v_mov_b64_e32 v[6:7], v[108:109]
		v_mov_b64_e32 v[26:27], v[110:111]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[64:67], v[116:119]
		s_nop 7
		v_mov_b64_e32 v[28:29], v[116:117]
		v_mov_b64_e32 v[34:35], v[118:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[64:67], v[112:115]
		s_nop 7
		v_mov_b64_e32 v[36:37], v[112:113]
		v_mov_b64_e32 v[38:39], v[114:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[72:75], v[120:123]
		s_nop 7
		v_mov_b64_e32 v[42:43], v[120:121]
		v_mov_b64_e32 v[44:45], v[122:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[72:75], v[124:127]
		s_nop 7
		v_mov_b64_e32 v[48:49], v[124:125]
		v_mov_b64_e32 v[56:57], v[126:127]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[80:83], v[132:135]
		s_nop 7
		v_mov_b64_e32 v[58:59], v[132:133]
		v_mov_b64_e32 v[60:61], v[134:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[80:83], v[128:131]
		s_nop 7
		v_mov_b64_e32 v[62:63], v[128:129]
		v_mov_b64_e32 v[64:65], v[130:131]
		buffer_load_dwordx2 v[66:67], v9, s[32:35], 0 offen
		buffer_load_dwordx2 v[68:69], v2, s[32:35], 0 offen
		s_waitcnt vmcnt(1)
		v_cvt_f32_f16_e32 v72, v66
		v_cvt_f32_f16_sdwa v73, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v74, v67
		v_cvt_f32_f16_sdwa v75, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[66:67], v[72:73]
		v_mov_b64_e32 v[70:71], v[74:75]
		s_waitcnt vmcnt(0)
		v_cvt_f32_f16_e32 v72, v68
		v_cvt_f32_f16_sdwa v73, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v74, v69
		v_cvt_f32_f16_sdwa v75, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[68:69], v[72:73]
		v_mov_b64_e32 v[72:73], v[74:75]
		v_pk_add_f32 v[76:77], v[24:25], v[66:67]
		v_pk_add_f32 v[78:79], v[4:5], v[70:71]
		v_mov_b64_e32 v[4:5], v[76:77]
		v_mov_b64_e32 v[24:25], v[78:79]
		v_pk_add_f32 v[76:77], v[6:7], v[68:69]
		v_pk_add_f32 v[78:79], v[26:27], v[72:73]
		v_mov_b64_e32 v[6:7], v[76:77]
		v_mov_b64_e32 v[26:27], v[78:79]
		v_pk_add_f32 v[76:77], v[36:37], v[66:67]
		v_pk_add_f32 v[78:79], v[38:39], v[70:71]
		v_mov_b64_e32 v[36:37], v[76:77]
		v_mov_b64_e32 v[38:39], v[78:79]
		v_pk_add_f32 v[76:77], v[28:29], v[68:69]
		v_pk_add_f32 v[78:79], v[34:35], v[72:73]
		v_mov_b64_e32 v[28:29], v[76:77]
		v_mov_b64_e32 v[34:35], v[78:79]
		v_pk_add_f32 v[76:77], v[42:43], v[66:67]
		v_pk_add_f32 v[78:79], v[44:45], v[70:71]
		v_mov_b64_e32 v[42:43], v[76:77]
		v_mov_b64_e32 v[44:45], v[78:79]
		v_pk_add_f32 v[76:77], v[48:49], v[68:69]
		v_pk_add_f32 v[78:79], v[56:57], v[72:73]
		v_mov_b64_e32 v[48:49], v[76:77]
		v_mov_b64_e32 v[56:57], v[78:79]
		v_pk_add_f32 v[76:77], v[62:63], v[66:67]
		v_pk_add_f32 v[78:79], v[64:65], v[70:71]
		v_mov_b64_e32 v[62:63], v[76:77]
		v_mov_b64_e32 v[64:65], v[78:79]
		v_pk_add_f32 v[76:77], v[58:59], v[68:69]
		v_pk_add_f32 v[78:79], v[60:61], v[72:73]
		v_mov_b64_e32 v[58:59], v[76:77]
		v_mov_b64_e32 v[60:61], v[78:79]
		v_add3_u32 v0, v13, v21, v23
		ds_read_b64 v[66:67], v0 offset:35776
		v_lshlrev_b32_e32 v0, 5, v15
		v_lshlrev_b32_e32 v2, 4, v47
		v_lshl_add_u32 v9, v46, 2, 64
		v_lshlrev_b32_e32 v11, 3, v11
		v_xor_b32_e32 v9, v9, v11
		v_bitop3_b32 v0, v0, v2, v9 bitop3:0x96
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 6, v9
		v_add3_u32 v10, v10, v2, v9
		v_lshrrev_b32_e32 v11, 4, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 5, v11
		v_add3_u32 v10, v10, v11, v19
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_add3_u32 v10, v10, v13, v21
		v_lshrrev_b32_e32 v15, 2, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_add3_u32 v10, v10, v15, v23
		v_lshrrev_b32_e32 v19, 1, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v10, v10, v19, v0
		ds_read_b64 v[20:21], v10 offset:35776
		v_add_u32_e32 v10, 0x10000, v12
		v_add_u32_e32 v10, v10, v14
		v_lshlrev_b32_e32 v12, 4, v16
		v_lshlrev_b32_e32 v14, 3, v1
		v_lshlrev_b32_e32 v23, 2, v32
		v_add_u32_e32 v33, 32, v40
		v_lshlrev_b32_e32 v41, 1, v31
		v_bitop3_b32 v33, v23, v33, v41 bitop3:0x96
		v_bitop3_b32 v33, v12, v14, v33 bitop3:0x96
		v_lshrrev_b32_e32 v46, 6, v33
		v_and_b32_e32 v46, 1, v46
		v_mov_b32_e32 v47, 0x4200
		v_mul_lo_u32 v47, v47, v46
		v_add_u32_e32 v46, v10, v47
		v_lshrrev_b32_e32 v50, 5, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v54, 0x2100
		v_mul_lo_u32 v54, v54, v50
		v_add3_u32 v46, v46, v17, v54
		v_lshrrev_b32_e32 v50, 4, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v68, 0x1080
		v_mul_lo_u32 v68, v68, v50
		v_add3_u32 v46, v46, v18, v68
		v_lshrrev_b32_e32 v50, 3, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v69, 0x840
		v_mul_lo_u32 v69, v69, v50
		v_lshrrev_b32_e32 v50, 2, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v70, 0x420
		v_mul_lo_u32 v70, v70, v50
		v_add3_u32 v46, v46, v69, v70
		v_lshrrev_b32_e32 v50, 1, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v71, 0x210
		v_mul_lo_u32 v71, v71, v50
		v_and_b32_e32 v33, 1, v33
		v_mov_b32_e32 v50, 0x108
		v_mul_lo_u32 v50, v50, v33
		v_add3_u32 v33, v46, v71, v50
		ds_read_b64 v[72:73], v33 offset:35776
		v_add_u32_e32 v33, 0x10000, v47
		v_add_u32_e32 v33, v33, v2
		v_add3_u32 v33, v33, v54, v9
		v_add3_u32 v33, v33, v68, v11
		v_add3_u32 v33, v33, v69, v13
		v_add3_u32 v33, v33, v70, v15
		v_add3_u32 v33, v33, v71, v19
		v_add3_u32 v33, v33, v50, v0
		ds_read_b64 v[46:47], v33 offset:35776
		v_add_u32_e32 v33, 64, v40
		v_bitop3_b32 v33, v23, v33, v41 bitop3:0x96
		v_bitop3_b32 v33, v12, v14, v33 bitop3:0x96
		v_lshrrev_b32_e32 v50, 6, v33
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v54, 0x4200
		v_mul_lo_u32 v54, v54, v50
		v_add_u32_e32 v50, v10, v54
		v_lshrrev_b32_e32 v68, 5, v33
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v69, 0x2100
		v_mul_lo_u32 v69, v69, v68
		v_add3_u32 v50, v50, v17, v69
		v_lshrrev_b32_e32 v68, 4, v33
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v70, 0x1080
		v_mul_lo_u32 v70, v70, v68
		v_add3_u32 v50, v50, v18, v70
		v_lshrrev_b32_e32 v68, 3, v33
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v71, 0x840
		v_mul_lo_u32 v71, v71, v68
		v_lshrrev_b32_e32 v68, 2, v33
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v74, 0x420
		v_mul_lo_u32 v74, v74, v68
		v_add3_u32 v50, v50, v71, v74
		v_lshrrev_b32_e32 v68, 1, v33
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v75, 0x210
		v_mul_lo_u32 v75, v75, v68
		v_and_b32_e32 v33, 1, v33
		v_mov_b32_e32 v68, 0x108
		v_mul_lo_u32 v68, v68, v33
		v_add3_u32 v33, v50, v75, v68
		ds_read_b64 v[76:77], v33 offset:35776
		v_add_u32_e32 v33, 0x10000, v54
		v_add_u32_e32 v33, v33, v2
		v_add3_u32 v33, v33, v69, v9
		v_add3_u32 v33, v33, v70, v11
		v_add3_u32 v33, v33, v71, v13
		v_add3_u32 v33, v33, v74, v15
		v_add3_u32 v33, v33, v75, v19
		v_add3_u32 v33, v33, v68, v0
		ds_read_b64 v[68:69], v33 offset:35776
		v_add_u32_e32 v33, 0x60, v40
		v_bitop3_b32 v23, v23, v33, v41 bitop3:0x96
		v_bitop3_b32 v12, v12, v14, v23 bitop3:0x96
		v_lshrrev_b32_e32 v14, 6, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v23, 0x4200
		v_mul_lo_u32 v23, v23, v14
		v_add_u32_e32 v10, v10, v23
		v_lshrrev_b32_e32 v14, 5, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v33, 0x2100
		v_mul_lo_u32 v33, v33, v14
		v_add3_u32 v10, v10, v17, v33
		v_lshrrev_b32_e32 v14, 4, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v17, 0x1080
		v_mul_lo_u32 v17, v17, v14
		v_add3_u32 v10, v10, v18, v17
		v_lshrrev_b32_e32 v14, 3, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v18, 0x840
		v_mul_lo_u32 v18, v18, v14
		v_lshrrev_b32_e32 v14, 2, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v41, 0x420
		v_mul_lo_u32 v41, v41, v14
		v_add3_u32 v10, v10, v18, v41
		v_lshrrev_b32_e32 v14, 1, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v50, 0x210
		v_mul_lo_u32 v50, v50, v14
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 0x108
		v_mul_lo_u32 v14, v14, v12
		v_add3_u32 v10, v10, v50, v14
		ds_read_b64 v[70:71], v10 offset:35776
		v_add_u32_e32 v10, 0x10000, v23
		v_add_u32_e32 v2, v10, v2
		v_add3_u32 v2, v2, v33, v9
		v_add3_u32 v2, v2, v17, v11
		v_add3_u32 v2, v2, v18, v13
		v_add3_u32 v2, v2, v41, v15
		v_add3_u32 v2, v2, v50, v19
		v_add3_u32 v0, v2, v14, v0
		ds_read_b64 v[10:11], v0 offset:35776
		s_waitcnt lgkmcnt(7)
		v_cvt_f32_f16_e32 v12, v66
		v_cvt_f32_f16_sdwa v13, v66 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v14, v67
		v_cvt_f32_f16_sdwa v15, v67 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[12:13], v[14:15]
		s_waitcnt lgkmcnt(6)
		v_cvt_f32_f16_e32 v80, v20
		v_cvt_f32_f16_sdwa v81, v20 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v21
		v_cvt_f32_f16_sdwa v83, v21 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[14:15], v[80:81]
		v_mov_b64_e32 v[20:21], v[82:83]
		s_waitcnt lgkmcnt(5)
		v_cvt_f32_f16_e32 v80, v72
		v_cvt_f32_f16_sdwa v81, v72 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v73
		v_cvt_f32_f16_sdwa v83, v73 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[66:67], v[80:81]
		v_mov_b64_e32 v[72:73], v[82:83]
		s_waitcnt lgkmcnt(4)
		v_cvt_f32_f16_e32 v80, v46
		v_cvt_f32_f16_sdwa v81, v46 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v47
		v_cvt_f32_f16_sdwa v83, v47 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[46:47], v[80:81]
		v_mov_b64_e32 v[74:75], v[82:83]
		s_waitcnt lgkmcnt(3)
		v_cvt_f32_f16_e32 v80, v76
		v_cvt_f32_f16_sdwa v81, v76 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v77
		v_cvt_f32_f16_sdwa v83, v77 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[76:77], v[80:81]
		v_mov_b64_e32 v[78:79], v[82:83]
		s_waitcnt lgkmcnt(2)
		v_cvt_f32_f16_e32 v80, v68
		v_cvt_f32_f16_sdwa v81, v68 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v82, v69
		v_cvt_f32_f16_sdwa v83, v69 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[68:69], v[80:81]
		v_mov_b64_e32 v[80:81], v[82:83]
		s_waitcnt lgkmcnt(1)
		v_cvt_f32_f16_e32 v84, v70
		v_cvt_f32_f16_sdwa v85, v70 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v71
		v_cvt_f32_f16_sdwa v87, v71 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[70:71], v[84:85]
		v_mov_b64_e32 v[82:83], v[86:87]
		s_waitcnt lgkmcnt(0)
		v_cvt_f32_f16_e32 v84, v10
		v_cvt_f32_f16_sdwa v85, v10 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_cvt_f32_f16_e32 v86, v11
		v_cvt_f32_f16_sdwa v87, v11 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
		v_mov_b64_e32 v[10:11], v[84:85]
		v_mov_b64_e32 v[84:85], v[86:87]
		v_pk_fma_f32 v[88:89], v[4:5], v[18:19], v[4:5]
		v_pk_fma_f32 v[90:91], v[24:25], v[12:13], v[24:25]
		v_pk_fma_f32 v[92:93], v[6:7], v[14:15], v[6:7]
		v_pk_fma_f32 v[94:95], v[26:27], v[20:21], v[26:27]
		v_pk_fma_f32 v[4:5], v[36:37], v[66:67], v[36:37]
		v_pk_fma_f32 v[6:7], v[38:39], v[72:73], v[38:39]
		v_pk_fma_f32 v[12:13], v[28:29], v[46:47], v[28:29]
		v_pk_fma_f32 v[14:15], v[34:35], v[74:75], v[34:35]
		v_pk_fma_f32 v[24:25], v[42:43], v[76:77], v[42:43]
		v_pk_fma_f32 v[26:27], v[44:45], v[78:79], v[44:45]
		v_pk_fma_f32 v[36:37], v[48:49], v[68:69], v[48:49]
		v_pk_fma_f32 v[38:39], v[56:57], v[80:81], v[56:57]
		v_pk_fma_f32 v[44:45], v[62:63], v[70:71], v[62:63]
		v_pk_fma_f32 v[46:47], v[64:65], v[82:83], v[64:65]
		v_pk_fma_f32 v[64:65], v[58:59], v[10:11], v[58:59]
		v_pk_fma_f32 v[66:67], v[60:61], v[84:85], v[60:61]
		v_cmp_lt_i32_e64 vcc, v51, s12
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v53, s12
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v3, s12
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v30, s12
		s_mov_b64 s[8:9], vcc
		v_cmp_lt_i32_e64 vcc, v55, s13
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v22, s13
		s_mov_b64 s[14:15], vcc
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		v_cvt_pk_f16_f32 v10, v92, v93
		v_cvt_pk_f16_f32 v11, v94, v95
		v_cvt_pk_f16_f32 v18, v4, v5
		v_cvt_pk_f16_f32 v19, v6, v7
		v_cvt_pk_f16_f32 v4, v12, v13
		v_cvt_pk_f16_f32 v5, v14, v15
		v_cvt_pk_f16_f32 v6, v24, v25
		v_cvt_pk_f16_f32 v7, v26, v27
		v_cvt_pk_f16_f32 v12, v36, v37
		v_cvt_pk_f16_f32 v13, v38, v39
		v_cvt_pk_f16_f32 v14, v44, v45
		v_cvt_pk_f16_f32 v15, v46, v47
		v_cvt_pk_f16_f32 v20, v64, v65
		v_cvt_pk_f16_f32 v21, v66, v67
		s_and_b32 s12, s2, s10
		s_and_b32 s13, s3, s11
		s_lshl_b32 s0, s0, 8
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 10
		s_add_i32 s16, s0, s1
		s_mul_i32 s17, s21, s19
		s_lshl_b32 s17, s17, 8
		s_add_i32 s16, s16, s17
		v_mul_lo_u32 v0, s19, v16
		v_lshlrev_b32_e32 v0, 5, v0
		v_mul_lo_u32 v9, s19, v40
		v_lshlrev_b32_e32 v9, 1, v9
		v_add3_u32 v16, s16, v0, v9
		v_mul_lo_u32 v1, s19, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_mul_lo_u32 v17, s19, v32
		v_lshlrev_b32_e32 v17, 3, v17
		v_add3_u32 v16, v16, v1, v17
		v_mul_lo_u32 v22, s19, v31
		v_lshlrev_b32_e32 v22, 2, v22
		v_and_b32_e32 v8, 15, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_add3_u32 v16, v16, v22, v8
		v_cndmask_b32_e64 v16, v52, v16, s[12:13]
		buffer_store_dwordx2 v[2:3], v16, s[36:39], 0 offen
		s_and_b32 s12, s2, s14
		s_and_b32 s13, s3, s15
		s_add_i32 s2, s0, 0x80
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s17
		v_add3_u32 v2, s2, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[12:13]
		buffer_store_dwordx2 v[10:11], v2, s[36:39], 0 offen
		s_and_b32 s2, s4, s10
		s_and_b32 s3, s5, s11
		s_lshl_b32 s12, s19, 6
		s_add_i32 s13, s12, s0
		s_add_i32 s13, s13, s1
		s_add_i32 s13, s13, s17
		v_add3_u32 v2, s13, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[2:3]
		buffer_store_dwordx2 v[18:19], v2, s[36:39], 0 offen
		s_and_b32 s2, s4, s14
		s_and_b32 s3, s5, s15
		s_add_i32 s4, s12, 0x80
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s17
		v_add3_u32 v2, s4, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[2:3]
		buffer_store_dwordx2 v[4:5], v2, s[36:39], 0 offen
		s_and_b32 s2, s6, s10
		s_and_b32 s3, s7, s11
		s_lshl_b32 s4, s19, 7
		s_add_i32 s5, s4, s0
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s17
		v_add3_u32 v2, s5, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[2:3]
		buffer_store_dwordx2 v[6:7], v2, s[36:39], 0 offen
		s_and_b32 s2, s6, s14
		s_and_b32 s3, s7, s15
		s_add_i32 s4, s4, 0x80
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s17
		v_add3_u32 v2, s4, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[2:3]
		buffer_store_dwordx2 v[12:13], v2, s[36:39], 0 offen
		s_and_b32 s2, s8, s10
		s_and_b32 s3, s9, s11
		s_mul_i32 s4, 0xc0, s19
		s_add_i32 s5, s4, s0
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s17
		v_add3_u32 v2, s5, v0, v9
		v_add3_u32 v2, v2, v1, v17
		v_add3_u32 v2, v2, v22, v8
		v_cndmask_b32_e64 v2, v52, v2, s[2:3]
		buffer_store_dwordx2 v[14:15], v2, s[36:39], 0 offen
		s_and_b32 s2, s8, s14
		s_and_b32 s3, s9, s15
		s_add_i32 s4, s4, 0x80
		s_add_i32 s0, s4, s0
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s17
		v_add3_u32 v0, s0, v0, v9
		v_add3_u32 v0, v0, v1, v17
		v_add3_u32 v0, v0, v22, v8
		v_cndmask_b32_e64 v0, v52, v0, s[2:3]
		buffer_store_dwordx2 v[20:21], v0, s[36:39], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	tlx_addmm_glu_kernel_optimized_async, .-tlx_addmm_glu_kernel_optimized_async
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel tlx_addmm_glu_kernel_optimized_async
		.amdhsa_group_segment_fixed_size 135104
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
		.amdhsa_next_free_vgpr 136
		.amdhsa_next_free_sgpr 46
		.amdhsa_accum_offset 136
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
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_vgpr, 136
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_agpr, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.numbered_sgpr, 46
	.set .Ltlx_addmm_glu_kernel_optimized_async.num_named_barrier, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.private_seg_size, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.uses_vcc, 1
	.set .Ltlx_addmm_glu_kernel_optimized_async.uses_flat_scratch, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_dyn_sized_stack, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_recursion, 0
	.set .Ltlx_addmm_glu_kernel_optimized_async.has_indirect_call, 0
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
    .group_segment_fixed_size: 135104
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 512
    .name:           tlx_addmm_glu_kernel_optimized_async
    .private_segment_fixed_size: 0
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         tlx_addmm_glu_kernel_optimized_async.kd
    .uses_dynamic_stack: false
    .vgpr_count:     136
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
