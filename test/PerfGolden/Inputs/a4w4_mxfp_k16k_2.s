	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	_a4w4_kernel
	.p2align	8
	.type	_a4w4_kernel,@function
_a4w4_kernel:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .L_a4w4_kernel.kernarg_preload_entry
	.p2align	8
.L_a4w4_kernel.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		v_mov_b32_e32 v4, 0
		s_mov_b32 s18, 1
		s_mov_b32 s19, 0
		s_and_saveexec_b64 s[20:21], s[18:19]
		v_mov_b32_e32 v1, 0x21b40
		ds_write_b32 v1, v4
		v_mov_b32_e32 v2, 0x21b44
		ds_write_b32 v2, v4
		v_mov_b32_e32 v3, 0x21b48
		ds_write_b32 v3, v4
		v_mov_b32_e32 v8, 0x21b4c
		ds_write_b32 v8, v4
		v_mov_b32_e32 v9, 0x21b50
		ds_write_b32 v9, v4
		v_mov_b32_e32 v10, 0x21b54
		ds_write_b32 v10, v4
		v_mov_b32_e32 v11, 0x21b58
		ds_write_b32 v11, v4
		v_mov_b32_e32 v12, 0x21b5c
		ds_write_b32 v12, v4
		v_mov_b32_e32 v13, 0x21b60
		ds_write_b32 v13, v4
		v_mov_b32_e32 v14, 0x21b64
		ds_write_b32 v14, v4
		v_mov_b32_e32 v15, 0x21b68
		ds_write_b32 v15, v4
		v_mov_b32_e32 v16, 0x21b6c
		ds_write_b32 v16, v4
		v_mov_b32_e32 v17, 0x21b70
		ds_write_b32 v17, v4
		v_mov_b32_e32 v5, 0x21b74
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b78
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b7c
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b80
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b84
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b88
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b8c
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b90
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x21b94
		ds_write_b32 v5, v4
		v_mov_b32_e32 v18, 0x21b98
		ds_write_b32 v18, v4
		v_mov_b32_e32 v19, 0x21b9c
		ds_write_b32 v19, v4
		v_mov_b32_e32 v20, 0x21ba0
		ds_write_b32 v20, v4
		v_mov_b32_e32 v21, 0x21ba4
		ds_write_b32 v21, v4
		v_mov_b32_e32 v22, 0x21ba8
		ds_write_b32 v22, v4
		v_mov_b32_e32 v23, 0x21bac
		ds_write_b32 v23, v4
		v_mov_b32_e32 v24, 0x21bb0
		ds_write_b32 v24, v4
		v_mov_b32_e32 v25, 0x21bb4
		ds_write_b32 v25, v4
		v_mov_b32_e32 v26, 0x21bb8
		ds_write_b32 v26, v4
		v_mov_b32_e32 v27, 0x21bbc
		ds_write_b32 v27, v4
		v_mov_b32_e32 v28, 0x21bc0
		ds_write_b32 v28, v4
		v_mov_b32_e32 v29, 0x21bc4
		ds_write_b32 v29, v4
		s_mov_b64 exec, s[20:21]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_load_dword s17, s[0:1], 0x38
		s_load_dword s20, s[0:1], 0x3c
		s_load_dword s21, s[0:1], 0x40
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 s0, s12, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s12, s1, 0
		s_add_i32 s0, s0, s12
		s_ashr_i32 s0, s0, 8
		s_add_i32 s12, s13, 0xff
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s12, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s12, s16, 7
		s_lshr_b32 s13, s16, 3
		s_mul_i32 s12, s12, 32
		s_add_i32 s12, s12, s13
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s12, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s16, s12, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s16, s12
		s_cselect_b32 s16, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		v_mov_b32_e32 v30, s22
		v_cvt_f32_u32_e32 v30, v30
		v_rcp_iflag_f32_e32 v30, v30
		v_mov_b32_e32 v31, 0x4f7ffffe
		v_mul_f32_e32 v30, v31, v30
		v_cvt_u32_f32_e32 v30, v30
		s_nop 0
		v_readfirstlane_b32 s23, v30
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_mul_i32 s25, s24, s23
		s_mul_hi_u32 s25, s23, s25
		s_add_i32 s23, s23, s25
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s25, s23, s22
		s_xor_b32 s25, s25, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s13, s13, s25
		s_cmp_ge_u32 s13, s22
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s23, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s23, s26, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s13, s24
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s13, s26, s13
		s_cmp_ge_u32 s13, s22
		s_cselect_b32 s22, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s25, s23
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s1, s12, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s12, s22, -1
		s_add_i32 s12, s12, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s12, s22
		s_mul_i32 s12, s1, 4
		s_xor_b32 s22, s12, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s0, s0, s22
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s22, s13, s24
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s13, s22, s13
		s_xor_b32 s22, s13, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s22, s13
		v_mov_b32_e32 v30, s0
		v_cvt_f32_u32_e32 v30, v30
		v_rcp_iflag_f32_e32 v30, v30
		s_nop 0
		v_mul_f32_e32 v30, v31, v30
		v_cvt_u32_f32_e32 v30, v30
		s_nop 0
		v_readfirstlane_b32 s16, v30
		s_xor_b32 s22, s0, -1
		s_add_i32 s22, s22, 1
		s_mul_i32 s23, s22, s16
		s_mul_hi_u32 s23, s16, s23
		s_add_i32 s16, s16, s23
		s_mul_hi_u32 s16, s13, s16
		s_mul_i32 s16, s16, s0
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s16, s13, s16
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s16, s22
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s16, s24, s16
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s23, 1, 0
		s_add_i32 s24, s16, s22
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s16, s24, s16
		s_add_i32 s12, s12, s16
		v_readfirstlane_b32 s23, v30
		s_mul_i32 s24, s22, s23
		s_mul_hi_u32 s24, s23, s24
		s_add_i32 s23, s23, s24
		s_mul_hi_u32 s23, s13, s23
		s_mul_i32 s24, s23, s0
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s13, s13, s24
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s24, 1, 0
		s_add_i32 s25, s23, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s23, s25, s23
		s_cselect_b32 s24, 1, 0
		s_add_i32 s22, s13, s22
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s13, s22, s13
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s13, s23, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s13, s23
		s_mul_i32 s12, s12, 0x100
		s_mul_i32 s13, s12, s14
		s_mul_i32 s22, s0, 0x100
		s_add_u32 s24, s2, s13
		s_addc_u32 s25, s3, 0
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_mov_b32 s32, s10
		s_mov_b32 s33, s11
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		v_readfirstlane_b32 s23, v0
		v_lshrrev_b32_e32 v30, 7, v0
		v_mul_lo_u32 v31, s14, v30
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshrrev_b32_e32 v32, 6, v0
		v_and_b32_e32 v32, 1, v32
		v_mul_lo_u32 v33, s14, v32
		v_add_u32_e32 v34, v31, v33
		v_lshrrev_b32_e32 v35, 5, v0
		v_and_b32_e32 v36, 1, v35
		v_mul_lo_u32 v37, s14, v36
		v_lshlrev_b32_e32 v37, 6, v37
		v_lshrrev_b32_e32 v38, 4, v0
		v_and_b32_e32 v38, 1, v38
		v_mul_lo_u32 v39, s14, v38
		v_lshlrev_b32_e32 v39, 5, v39
		v_add3_u32 v34, v34, v37, v39
		v_lshrrev_b32_e32 v40, 3, v0
		v_and_b32_e32 v41, 1, v40
		v_mul_lo_u32 v42, s14, v41
		v_lshlrev_b32_e32 v42, 4, v42
		v_and_b32_e32 v43, 1, v0
		v_lshlrev_b32_e32 v44, 4, v43
		v_add3_u32 v34, v34, v42, v44
		v_lshrrev_b32_e32 v45, 2, v0
		v_and_b32_e32 v45, 1, v45
		v_lshlrev_b32_e32 v46, 6, v45
		v_lshrrev_b32_e32 v47, 1, v0
		v_and_b32_e32 v47, 1, v47
		v_lshlrev_b32_e32 v48, 5, v47
		v_add3_u32 v34, v34, v46, v48
		s_lshr_b32 s23, s23, 6
		s_mul_i32 s23, 0x420, s23
		s_mov_b32 m0, s23
		s_mul_i32 s22, s22, s15
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_lshl_b32 s36, s14, 2
		v_add3_u32 v49, s36, v31, v33
		v_add3_u32 v49, v49, v37, v39
		v_add3_u32 v49, v49, v42, v44
		v_add3_u32 v49, v49, v46, v48
		s_add_i32 m0, s23, 0x1080
		s_mov_b32 s37, 0
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		s_lshl_b32 s38, s14, 3
		v_add3_u32 v50, v31, v33, v37
		v_add3_u32 v50, v50, v39, v42
		v_add3_u32 v50, v50, v44, v46
		s_add_i32 m0, s23, 0x2100
		v_add3_u32 v51, v48, v50, s38
		buffer_load_dwordx4 v51, s[24:27], 0 offen lds
		s_mul_i32 s39, 12, s14
		s_add_i32 m0, s23, 0x3180
		v_add3_u32 v52, v48, v50, s39
		buffer_load_dwordx4 v52, s[24:27], 0 offen lds
		s_lshl_b32 s40, s14, 7
		s_add_i32 m0, s23, 0x4200
		v_add3_u32 v50, v48, v50, s40
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		s_mul_i32 s41, 0x84, s14
		v_add3_u32 v53, v31, v33, v37
		v_add3_u32 v53, v53, v39, v42
		v_add3_u32 v53, v53, v44, v46
		s_add_i32 m0, s23, 0x5280
		v_add3_u32 v54, v48, v53, s41
		buffer_load_dwordx4 v54, s[24:27], 0 offen lds
		s_mul_i32 s42, 0x88, s14
		s_add_i32 m0, s23, 0x6300
		v_add3_u32 v55, v48, v53, s42
		buffer_load_dwordx4 v55, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s23, 0x7380
		v_add3_u32 v53, v48, v53, s14
		s_add_u32 s44, s4, s22
		s_addc_u32 s45, s5, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		v_mul_lo_u32 v56, s15, v30
		v_lshlrev_b32_e32 v56, 1, v56
		v_mul_lo_u32 v57, s15, v32
		v_add_u32_e32 v58, v56, v57
		v_mul_lo_u32 v59, s15, v36
		v_lshlrev_b32_e32 v59, 6, v59
		buffer_load_dwordx4 v53, s[24:27], 0 offen lds
		v_mul_lo_u32 v60, s15, v38
		v_lshlrev_b32_e32 v60, 5, v60
		v_add3_u32 v58, v58, v59, v60
		v_mul_lo_u32 v61, s15, v41
		v_lshlrev_b32_e32 v61, 4, v61
		v_add3_u32 v58, v58, v61, v44
		s_add_i32 m0, s23, 0x107c0
		v_add3_u32 v58, v58, v46, v48
		buffer_load_dwordx4 v58, s[44:47], 0 offen lds
		s_lshl_b32 s43, s15, 2
		v_add3_u32 v62, v56, v57, v59
		v_add3_u32 v62, v62, v60, v61
		v_add3_u32 v62, v62, v44, v46
		s_add_i32 m0, s23, 0x11840
		v_add3_u32 v63, v48, v62, s43
		buffer_load_dwordx4 v63, s[44:47], 0 offen lds
		s_lshl_b32 s48, s15, 3
		s_add_i32 m0, s23, 0x128c0
		v_add3_u32 v64, v48, v62, s48
		buffer_load_dwordx4 v64, s[44:47], 0 offen lds
		s_mul_i32 s49, 12, s15
		s_add_i32 m0, s23, 0x13940
		v_add3_u32 v62, v48, v62, s49
		buffer_load_dwordx4 v62, s[44:47], 0 offen lds
		v_mov_b32_e32 v65, 1
		s_and_saveexec_b64 s[50:51], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v66, v1, v65
		s_mov_b64 exec, s[50:51]
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s1, s1, s20
		s_lshl_b32 s1, s1, 10
		s_mul_i32 s16, s16, s20
		s_lshl_b32 s16, s16, 8
		s_add_i32 s50, s1, s16
		v_mul_lo_u32 v67, s20, v30
		v_lshl_add_u32 v67, v67, 4, s50
		v_mul_lo_u32 v68, s20, v32
		v_lshl_add_u32 v67, v68, 3, v67
		v_mul_lo_u32 v68, s20, v36
		v_lshl_add_u32 v67, v68, 2, v67
		v_mul_lo_u32 v68, s20, v38
		v_lshl_add_u32 v67, v68, 1, v67
		v_mul_lo_u32 v69, s20, v41
		v_add3_u32 v67, v67, v69, v43
		v_lshlrev_b32_e32 v70, 2, v45
		v_lshlrev_b32_e32 v71, 1, v47
		v_add3_u32 v67, v67, v70, v71
		v_lshlrev_b32_e32 v72, 4, v30
		v_lshlrev_b32_e32 v73, 3, v32
		v_lshlrev_b32_e32 v74, 2, v36
		v_add_u32_e32 v75, 32, v41
		v_lshlrev_b32_e32 v76, 1, v38
		v_xor_b32_e32 v75, v75, v76
		v_xor_b32_e32 v75, v74, v75
		v_xor_b32_e32 v75, v73, v75
		v_xor_b32_e32 v75, v72, v75
		v_mul_lo_u32 v77, s20, v75
		v_add3_u32 v77, s50, v77, v43
		v_add3_u32 v77, v77, v70, v71
		v_add_u32_e32 v78, 64, v41
		v_xor_b32_e32 v78, v78, v76
		v_xor_b32_e32 v78, v74, v78
		v_xor_b32_e32 v78, v73, v78
		v_xor_b32_e32 v78, v72, v78
		v_mul_lo_u32 v79, s20, v78
		v_add3_u32 v79, s50, v79, v43
		v_add3_u32 v79, v79, v70, v71
		v_add_u32_e32 v80, 0x60, v41
		v_xor_b32_e32 v80, v80, v76
		v_xor_b32_e32 v80, v74, v80
		v_xor_b32_e32 v80, v73, v80
		v_xor_b32_e32 v80, v72, v80
		v_mul_lo_u32 v81, s20, v80
		v_add3_u32 v81, s50, v81, v43
		v_add3_u32 v81, v81, v70, v71
		v_add_u32_e32 v82, 0x80, v41
		v_xor_b32_e32 v82, v82, v76
		v_xor_b32_e32 v82, v74, v82
		v_xor_b32_e32 v82, v73, v82
		v_xor_b32_e32 v82, v72, v82
		v_mul_lo_u32 v83, s20, v82
		v_add3_u32 v83, s50, v83, v43
		v_add3_u32 v83, v83, v70, v71
		v_add_u32_e32 v84, 0xa0, v41
		v_xor_b32_e32 v84, v84, v76
		v_xor_b32_e32 v84, v74, v84
		v_xor_b32_e32 v84, v73, v84
		v_xor_b32_e32 v84, v72, v84
		v_mul_lo_u32 v85, s20, v84
		v_add3_u32 v85, s50, v85, v43
		v_add3_u32 v85, v85, v70, v71
		v_add_u32_e32 v86, 0xc0, v41
		v_xor_b32_e32 v86, v86, v76
		v_xor_b32_e32 v86, v74, v86
		v_xor_b32_e32 v86, v73, v86
		v_xor_b32_e32 v86, v72, v86
		v_mul_lo_u32 v87, s20, v86
		v_add3_u32 v87, s50, v87, v43
		v_add3_u32 v87, v87, v70, v71
		v_add_u32_e32 v88, 0xe0, v41
		v_xor_b32_e32 v76, v88, v76
		v_xor_b32_e32 v74, v74, v76
		v_xor_b32_e32 v73, v73, v74
		v_xor_b32_e32 v73, v72, v73
		v_mul_lo_u32 v74, s20, v73
		v_add3_u32 v74, s50, v74, v43
		v_add3_u32 v74, v74, v70, v71
		buffer_load_ubyte v76, v67, s[28:31], 0 offen
		buffer_load_ubyte v88, v77, s[28:31], 0 offen
		buffer_load_ubyte v89, v79, s[28:31], 0 offen
		buffer_load_ubyte v90, v81, s[28:31], 0 offen
		buffer_load_ubyte v91, v83, s[28:31], 0 offen
		buffer_load_ubyte v92, v85, s[28:31], 0 offen
		buffer_load_ubyte v93, v87, s[28:31], 0 offen
		buffer_load_ubyte v94, v74, s[28:31], 0 offen
		s_mul_i32 s50, s0, s21
		s_lshl_b32 s50, s50, 8
		v_mul_lo_u32 v95, s21, v30
		v_lshl_add_u32 v95, v95, 4, s50
		v_mul_lo_u32 v96, s21, v32
		v_lshl_add_u32 v95, v96, 3, v95
		v_mul_lo_u32 v96, s21, v36
		v_lshl_add_u32 v95, v96, 2, v95
		v_mul_lo_u32 v96, s21, v38
		v_lshl_add_u32 v95, v96, 1, v95
		v_mul_lo_u32 v97, s21, v41
		v_add3_u32 v95, v95, v97, v43
		v_add3_u32 v95, v95, v70, v71
		v_mul_lo_u32 v98, s21, v75
		v_add3_u32 v70, v43, v70, v71
		v_add3_u32 v71, v98, v70, s50
		v_mul_lo_u32 v98, s21, v78
		v_add3_u32 v98, v98, v70, s50
		v_mul_lo_u32 v99, s21, v80
		v_add3_u32 v70, v99, v70, s50
		buffer_load_ubyte v99, v95, s[32:35], 0 offen
		buffer_load_ubyte v100, v71, s[32:35], 0 offen
		buffer_load_ubyte v101, v98, s[32:35], 0 offen
		buffer_load_ubyte v102, v70, s[32:35], 0 offen
		s_lshl_b32 s51, s15, 7
		v_add3_u32 v103, s51, v56, v57
		v_add3_u32 v103, v103, v59, v60
		v_add3_u32 v103, v103, v61, v44
		s_add_i32 m0, s23, 0x18b80
		v_add3_u32 v103, v103, v46, v48
		buffer_load_dwordx4 v103, s[44:47], 0 offen lds
		s_mul_i32 s52, 0x84, s15
		v_add3_u32 v104, v56, v57, v59
		v_add3_u32 v104, v104, v60, v61
		v_add3_u32 v104, v104, v44, v46
		s_add_i32 m0, s23, 0x19c00
		v_add3_u32 v105, v48, v104, s52
		buffer_load_dwordx4 v105, s[44:47], 0 offen lds
		s_mul_i32 s53, 0x88, s15
		s_add_i32 m0, s23, 0x1ac80
		v_add3_u32 v106, v48, v104, s53
		buffer_load_dwordx4 v106, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s23, 0x1bd00
		v_add3_u32 v104, v48, v104, s15
		buffer_load_dwordx4 v104, s[44:47], 0 offen lds
		s_lshl_b32 s54, s21, 7
		s_add_i32 s55, s54, s50
		v_mul_lo_u32 v107, s21, v43
		v_lshlrev_b32_e32 v107, 2, v107
		v_lshlrev_b32_e32 v96, 6, v96
		v_add3_u32 v108, s55, v107, v96
		v_lshlrev_b32_e32 v97, 5, v97
		v_mul_lo_u32 v109, s21, v45
		v_lshlrev_b32_e32 v109, 4, v109
		v_add3_u32 v108, v108, v97, v109
		v_mul_lo_u32 v110, s21, v47
		v_lshlrev_b32_e32 v110, 3, v110
		v_add3_u32 v108, v108, v110, v35
		s_mul_i32 s55, 0x81, s21
		s_add_i32 s56, s55, s50
		v_add3_u32 v111, v107, v96, v97
		v_add3_u32 v111, v111, v109, v110
		v_add3_u32 v112, v35, v111, s56
		s_mul_i32 s56, 0x82, s21
		s_add_i32 s57, s56, s50
		v_add3_u32 v113, v35, v111, s57
		s_mul_i32 s57, 0x83, s21
		s_add_i32 s58, s57, s50
		v_add3_u32 v111, v35, v111, s58
		buffer_load_ubyte_d16 v114, v108, s[32:35], 0 offen
		buffer_load_ubyte_d16 v115, v112, s[32:35], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v113, s[32:35], 0 offen
		v_mov_b32_e32 v117, 0
		buffer_load_ubyte_d16_hi v117, v111, s[32:35], 0 offen
		v_add_u32_e32 v118, 0x80, v31
		v_add_u32_e32 v118, v118, v33
		v_add3_u32 v118, v118, v37, v39
		v_add3_u32 v118, v118, v42, v44
		s_add_i32 m0, s23, 0x83e0
		v_add3_u32 v118, v118, v46, v48
		buffer_load_dwordx4 v118, s[24:27], 0 offen lds
		s_add_i32 s36, s36, 0x80
		v_add3_u32 v119, s36, v31, v33
		v_add3_u32 v119, v119, v37, v39
		v_add3_u32 v119, v119, v42, v44
		s_add_i32 m0, s23, 0x9460
		v_add3_u32 v119, v119, v46, v48
		buffer_load_dwordx4 v119, s[24:27], 0 offen lds
		s_add_i32 s36, s38, 0x80
		v_add3_u32 v120, s36, v31, v33
		v_add3_u32 v120, v120, v37, v39
		v_add3_u32 v120, v120, v42, v44
		s_add_i32 m0, s23, 0xa4e0
		v_add3_u32 v120, v120, v46, v48
		buffer_load_dwordx4 v120, s[24:27], 0 offen lds
		s_add_i32 s36, s39, 0x80
		v_add3_u32 v121, s36, v31, v33
		v_add3_u32 v121, v121, v37, v39
		v_add3_u32 v121, v121, v42, v44
		s_add_i32 m0, s23, 0xb560
		v_add3_u32 v121, v121, v46, v48
		buffer_load_dwordx4 v121, s[24:27], 0 offen lds
		s_add_i32 s36, s40, 0x80
		v_add3_u32 v122, s36, v31, v33
		v_add3_u32 v122, v122, v37, v39
		v_add3_u32 v122, v122, v42, v44
		s_add_i32 m0, s23, 0xc5e0
		v_add3_u32 v122, v122, v46, v48
		buffer_load_dwordx4 v122, s[24:27], 0 offen lds
		s_add_i32 s36, s41, 0x80
		v_add3_u32 v123, s36, v31, v33
		v_add3_u32 v123, v123, v37, v39
		v_add3_u32 v123, v123, v42, v44
		s_add_i32 m0, s23, 0xd660
		v_add3_u32 v123, v123, v46, v48
		buffer_load_dwordx4 v123, s[24:27], 0 offen lds
		s_add_i32 s36, s42, 0x80
		v_add3_u32 v124, s36, v31, v33
		v_add3_u32 v124, v124, v37, v39
		v_add3_u32 v124, v124, v42, v44
		s_add_i32 m0, s23, 0xe6e0
		v_add3_u32 v124, v124, v46, v48
		buffer_load_dwordx4 v124, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v31, s14, v31, v33
		v_add3_u32 v31, v31, v37, v39
		v_add3_u32 v31, v31, v42, v44
		s_add_i32 m0, s23, 0xf760
		v_add3_u32 v31, v31, v46, v48
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_add_u32_e32 v33, 0x80, v56
		v_add_u32_e32 v33, v33, v57
		v_add3_u32 v33, v33, v59, v60
		v_add3_u32 v33, v33, v61, v44
		s_add_i32 m0, s23, 0x149a0
		v_add3_u32 v33, v33, v46, v48
		buffer_load_dwordx4 v33, s[44:47], 0 offen lds
		s_add_i32 s14, s43, 0x80
		v_add3_u32 v37, v56, v57, v59
		v_add3_u32 v37, v37, v60, v61
		v_add3_u32 v37, v37, v44, v46
		s_add_i32 m0, s23, 0x15a20
		v_add3_u32 v39, v48, v37, s14
		buffer_load_dwordx4 v39, s[44:47], 0 offen lds
		s_add_i32 s14, s48, 0x80
		s_add_i32 m0, s23, 0x16aa0
		v_add3_u32 v42, v48, v37, s14
		buffer_load_dwordx4 v42, s[44:47], 0 offen lds
		s_add_i32 s14, s49, 0x80
		s_add_i32 m0, s23, 0x17b20
		v_add3_u32 v37, v48, v37, s14
		s_add_i32 s14, s1, 8
		s_add_i32 s14, s14, s16
		buffer_load_dwordx4 v37, s[44:47], 0 offen lds
		v_mul_lo_u32 v125, s20, v43
		v_lshlrev_b32_e32 v125, 3, v125
		v_lshlrev_b32_e32 v68, 7, v68
		v_add3_u32 v126, s14, v125, v68
		v_lshlrev_b32_e32 v69, 6, v69
		v_mul_lo_u32 v127, s20, v45
		v_lshlrev_b32_e32 v127, 5, v127
		v_add3_u32 v126, v126, v69, v127
		v_mul_lo_u32 v128, s20, v47
		v_lshlrev_b32_e32 v128, 4, v128
		v_add3_u32 v126, v126, v128, v35
		s_add_i32 s14, s20, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v129, s14, v125, v68
		v_add3_u32 v129, v129, v69, v127
		v_add3_u32 v129, v129, v128, v35
		s_lshl_b32 s14, s20, 1
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v130, v125, v68, v69
		v_add3_u32 v130, v130, v127, v128
		v_add3_u32 v131, v35, v130, s14
		s_mul_i32 s14, 3, s20
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v132, v35, v130, s14
		s_lshl_b32 s14, s20, 2
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v130, v35, v130, s14
		s_mul_i32 s14, 5, s20
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v68, v125, v68, v69
		v_add3_u32 v68, v68, v127, v128
		v_add3_u32 v69, v35, v68, s14
		s_mul_i32 s14, 6, s20
		s_add_i32 s14, s14, 8
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s16
		v_add3_u32 v125, v35, v68, s14
		s_mul_i32 s14, 7, s20
		s_add_i32 s14, s14, 8
		s_add_i32 s1, s14, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v68, v35, v68, s1
		buffer_load_ubyte_d16 v127, v126, s[28:31], 0 offen
		buffer_load_ubyte_d16 v128, v129, s[28:31], 0 offen
		v_mov_b32_e32 v133, 0
		buffer_load_ubyte_d16_hi v133, v131, s[28:31], 0 offen
		v_mov_b32_e32 v134, 0
		buffer_load_ubyte_d16_hi v134, v132, s[28:31], 0 offen
		buffer_load_ubyte_d16 v135, v130, s[28:31], 0 offen
		buffer_load_ubyte_d16 v136, v69, s[28:31], 0 offen
		v_mov_b32_e32 v137, 0
		buffer_load_ubyte_d16_hi v137, v125, s[28:31], 0 offen
		v_mov_b32_e32 v138, 0
		buffer_load_ubyte_d16_hi v138, v68, s[28:31], 0 offen
		s_add_i32 s1, s50, 8
		v_add3_u32 v139, s1, v107, v96
		v_add3_u32 v139, v139, v97, v109
		v_add3_u32 v139, v139, v110, v35
		s_add_i32 s1, s21, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v140, v107, v96, v97
		v_add3_u32 v140, v140, v109, v110
		v_add3_u32 v141, v35, v140, s1
		s_lshl_b32 s1, s21, 1
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v142, v35, v140, s1
		s_mul_i32 s1, 3, s21
		s_add_i32 s1, s1, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v140, v35, v140, s1
		buffer_load_ubyte_d16 v143, v139, s[32:35], 0 offen
		buffer_load_ubyte_d16 v144, v141, s[32:35], 0 offen
		v_mov_b32_e32 v145, 0
		buffer_load_ubyte_d16_hi v145, v142, s[32:35], 0 offen
		v_mov_b32_e32 v146, 0
		buffer_load_ubyte_d16_hi v146, v140, s[32:35], 0 offen
		s_add_i32 s1, s51, 0x80
		v_add3_u32 v147, s1, v56, v57
		v_add3_u32 v147, v147, v59, v60
		v_add3_u32 v147, v147, v61, v44
		s_add_i32 m0, s23, 0x1cd60
		v_add3_u32 v147, v147, v46, v48
		buffer_load_dwordx4 v147, s[44:47], 0 offen lds
		s_add_i32 s1, s52, 0x80
		v_add3_u32 v56, v56, v57, v59
		v_add3_u32 v56, v56, v60, v61
		v_add3_u32 v56, v56, v44, v46
		s_add_i32 m0, s23, 0x1dde0
		v_add3_u32 v57, v48, v56, s1
		buffer_load_dwordx4 v57, s[44:47], 0 offen lds
		s_add_i32 s1, s53, 0x80
		s_add_i32 m0, s23, 0x1ee60
		v_add3_u32 v59, v48, v56, s1
		buffer_load_dwordx4 v59, s[44:47], 0 offen lds
		s_add_i32 s1, s15, 0x80
		s_add_i32 m0, s23, 0x1fee0
		v_add3_u32 v56, v48, v56, s1
		buffer_load_dwordx4 v56, s[44:47], 0 offen lds
		s_add_i32 s1, s54, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v60, s1, v107, v96
		v_add3_u32 v60, v60, v97, v109
		v_add3_u32 v60, v60, v110, v35
		s_add_i32 s1, s55, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v61, v107, v96, v97
		v_add3_u32 v61, v61, v109, v110
		v_add3_u32 v96, v35, v61, s1
		s_add_i32 s1, s56, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v97, v35, v61, s1
		s_add_i32 s1, s57, 8
		s_add_i32 s1, s1, s50
		v_add3_u32 v35, v35, v61, s1
		buffer_load_ubyte_d16 v61, v60, s[32:35], 0 offen
		buffer_load_ubyte_d16 v107, v96, s[32:35], 0 offen
		v_mov_b32_e32 v109, 0
		buffer_load_ubyte_d16_hi v109, v97, s[32:35], 0 offen
		v_mov_b32_e32 v110, 0
		buffer_load_ubyte_d16_hi v110, v35, s[32:35], 0 offen
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s22, 0x100
		v_readfirstlane_b32 s14, v66
		s_and_b32 s14, s14, -4
		s_add_i32 s14, s14, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_0:
		ds_read_b32 v66, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s15, v66
		s_xor_b32 s16, s14, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s15, s15, s16
		s_cmp_ge_u32 s15, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v1, 7, v30
		v_and_b32_e32 v66, 63, v0
		v_lshrrev_b32_e32 v148, 4, v66
		v_lshlrev_b32_e32 v148, 4, v148
		v_and_b32_e32 v66, 15, v66
		v_mov_b32_e32 v149, 0x420
		v_mul_lo_u32 v149, v149, v66
		v_add3_u32 v1, v1, v148, v149
		ds_read_b128 a[0:3], v1
		ds_read_b128 a[4:7], v1 offset:64
		ds_read_b128 a[8:11], v1 offset:256
		ds_read_b128 a[12:15], v1 offset:320
		ds_read_b128 a[16:19], v1 offset:512
		ds_read_b128 a[20:23], v1 offset:576
		ds_read_b128 a[24:27], v1 offset:768
		ds_read_b128 a[28:31], v1 offset:832
		ds_read_b128 a[32:35], v1 offset:16896
		ds_read_b128 a[36:39], v1 offset:16960
		ds_read_b128 a[40:43], v1 offset:17152
		ds_read_b128 a[44:47], v1 offset:17216
		ds_read_b128 a[48:51], v1 offset:17408
		ds_read_b128 a[52:55], v1 offset:17472
		ds_read_b128 a[56:59], v1 offset:17664
		ds_read_b128 a[60:63], v1 offset:17728
		v_add_u32_e32 v66, 0x10000, v148
		v_lshlrev_b32_e32 v148, 7, v32
		v_add3_u32 v66, v66, v148, v149
		ds_read_b128 a[64:67], v66 offset:1984
		ds_read_b128 a[68:71], v66 offset:2048
		ds_read_b128 a[72:75], v66 offset:2240
		ds_read_b128 a[76:79], v66 offset:2304
		ds_read_b128 a[80:83], v66 offset:2496
		ds_read_b128 a[84:87], v66 offset:2560
		ds_read_b128 a[88:91], v66 offset:2752
		ds_read_b128 a[92:95], v66 offset:2816
		v_add_u32_e32 v40, 0x20000, v40
		v_lshlrev_b32_e32 v148, 8, v43
		v_add_u32_e32 v149, v40, v148
		v_lshlrev_b32_e32 v150, 10, v45
		v_lshlrev_b32_e32 v151, 9, v47
		v_add3_u32 v149, v149, v150, v151
		s_waitcnt vmcnt(51)
		ds_write_b8 v149, v76 offset:3904
		v_add_u32_e32 v76, 0x20000, v148
		v_add3_u32 v76, v76, v150, v151
		v_add_u32_e32 v148, v76, v75
		s_waitcnt vmcnt(50)
		ds_write_b8 v148, v88 offset:3904
		v_add_u32_e32 v88, v76, v78
		s_waitcnt vmcnt(49)
		ds_write_b8 v88, v89 offset:3904
		v_add_u32_e32 v89, v76, v80
		s_waitcnt vmcnt(48)
		ds_write_b8 v89, v90 offset:3904
		v_add_u32_e32 v82, v76, v82
		s_waitcnt vmcnt(47)
		ds_write_b8 v82, v91 offset:3904
		v_add_u32_e32 v84, v76, v84
		s_waitcnt vmcnt(46)
		ds_write_b8 v84, v92 offset:3904
		v_add_u32_e32 v86, v76, v86
		s_waitcnt vmcnt(45)
		ds_write_b8 v86, v93 offset:3904
		v_add_u32_e32 v73, v76, v73
		s_waitcnt vmcnt(44)
		ds_write_b8 v73, v94 offset:3904
		s_and_saveexec_b64 s[14:15], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v76, v2, v65
		s_mov_b64 exec, s[14:15]
		v_lshlrev_b32_e32 v90, 7, v43
		v_add_u32_e32 v40, v40, v90
		v_lshlrev_b32_e32 v91, 9, v45
		v_lshlrev_b32_e32 v92, 8, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s14, v76
		s_and_b32 s14, s14, -4
		s_add_i32 s14, s14, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_1:
		ds_read_b32 v76, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s15, v76
		s_xor_b32 s16, s14, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s15, s15, s16
		s_cmp_ge_u32 s15, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_1
.L_a4w4_kernel.loop_exit_1:
		s_mov_b64 exec, s[20:21]
		v_add3_u32 v2, v40, v91, v92
		s_waitcnt vmcnt(43)
		ds_write_b8 v2, v99 offset:5952
		v_add_u32_e32 v40, 0x20000, v90
		v_add3_u32 v40, v40, v91, v92
		v_add_u32_e32 v75, v40, v75
		s_waitcnt vmcnt(42)
		ds_write_b8 v75, v100 offset:5952
		v_add_u32_e32 v76, v40, v78
		s_waitcnt vmcnt(41)
		ds_write_b8 v76, v101 offset:5952
		v_add_u32_e32 v40, v40, v80
		s_waitcnt vmcnt(40)
		ds_write_b8 v40, v102 offset:5952
		s_and_saveexec_b64 s[14:15], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v78, v3, v65
		s_mov_b64 exec, s[14:15]
		v_add_u32_e32 v72, 0x20000, v72
		v_lshlrev_b32_e32 v43, 3, v43
		v_add_u32_e32 v72, v72, v43
		v_lshl_add_u32 v72, v36, 9, v72
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s14, v78
		s_and_b32 s14, s14, -4
		s_add_i32 s14, s14, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_2:
		ds_read_b32 v78, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s15, v78
		s_xor_b32 s16, s14, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s15, s15, s16
		s_cmp_ge_u32 s15, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_2
.L_a4w4_kernel.loop_exit_2:
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v3, 8, v38
		v_lshlrev_b32_e32 v78, 6, v41
		v_add3_u32 v3, v72, v3, v78
		v_lshlrev_b32_e32 v72, 5, v45
		v_lshlrev_b32_e32 v47, 10, v47
		v_add3_u32 v3, v3, v72, v47
		ds_read_b64_tr_b8 v[90:91], v3 offset:3904
		ds_read_b64_tr_b8 v[92:93], v3 offset:4032
		v_add_u32_e32 v43, 0x20000, v43
		v_lshl_add_u32 v43, v32, 4, v43
		v_lshl_add_u32 v43, v36, 8, v43
		v_lshlrev_b32_e32 v80, 7, v38
		v_add3_u32 v43, v43, v80, v78
		v_add3_u32 v43, v43, v72, v151
		ds_read_b64_tr_b8 v[100:101], v43 offset:5952
		s_mov_b32 s14, 16
		s_mov_b32 s15, s14
		v_lshlrev_b32_e32 v72, 2, v0
		v_add_u32_e32 v72, 0x20000, v72
		v_lshlrev_b32_e32 v78, 3, v0
		v_add_u32_e32 v78, 0x20000, v78
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_add_u32 s40, s8, s15
		s_addc_u32 s41, s9, 0
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_add_u32 s44, s10, s15
		s_addc_u32 s45, s11, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		s_mov_b32 s14, s15
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
		v_accvgpr_write_b32 a212, 0
		v_accvgpr_write_b32 a213, 0
		v_accvgpr_write_b32 a214, 0
		v_accvgpr_write_b32 a215, 0
		v_accvgpr_write_b32 a216, 0
		v_accvgpr_write_b32 a217, 0
		v_accvgpr_write_b32 a218, 0
		v_accvgpr_write_b32 a219, 0
		v_accvgpr_write_b32 a220, 0
		v_accvgpr_write_b32 a221, 0
		v_accvgpr_write_b32 a222, 0
		v_accvgpr_write_b32 a223, 0
		v_accvgpr_write_b32 a224, 0
		v_accvgpr_write_b32 a225, 0
		v_accvgpr_write_b32 a226, 0
		v_accvgpr_write_b32 a227, 0
		v_accvgpr_write_b32 a228, 0
		v_accvgpr_write_b32 a229, 0
		v_accvgpr_write_b32 a230, 0
		v_accvgpr_write_b32 a231, 0
		v_accvgpr_write_b32 a232, 0
		v_accvgpr_write_b32 a233, 0
		v_accvgpr_write_b32 a234, 0
		v_accvgpr_write_b32 a235, 0
		v_accvgpr_write_b32 a236, 0
		v_accvgpr_write_b32 a237, 0
		v_accvgpr_write_b32 a238, 0
		v_accvgpr_write_b32 a239, 0
		v_accvgpr_write_b32 a240, 0
		v_accvgpr_write_b32 a241, 0
		v_accvgpr_write_b32 a242, 0
		v_accvgpr_write_b32 a243, 0
		v_accvgpr_write_b32 a244, 0
		v_accvgpr_write_b32 a245, 0
		v_accvgpr_write_b32 a246, 0
		v_accvgpr_write_b32 a247, 0
		v_accvgpr_write_b32 a248, 0
		v_accvgpr_write_b32 a249, 0
		v_accvgpr_write_b32 a250, 0
		v_accvgpr_write_b32 a251, 0
		v_accvgpr_write_b32 a252, 0
		v_accvgpr_write_b32 a253, 0
		v_accvgpr_write_b32 a254, 0
		v_accvgpr_write_b32 a255, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
.L_a4w4_kernel.loop_head_3:
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt vmcnt(36)
		ds_add_rtn_u32 v80, v8, v65
		s_mov_b64 exec, s[20:21]
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt vmcnt(20)
		ds_add_rtn_u32 v94, v10, v65
		s_mov_b64 exec, s[20:21]
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt vmcnt(4)
		ds_add_rtn_u32 v99, v13, v65
		s_mov_b64 exec, s[20:21]
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[0:3], v[240:243], v100, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v100, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[72:75], a[8:11], v[160:163], v100, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[64:67], a[8:11], v[156:159], v100, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[12:15], v[160:163], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[12:15], v[156:159], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v101, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[88:91], a[0:3], v[152:155], v101, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[88:91], a[8:11], v[168:171], v101, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[80:83], a[8:11], v[164:167], v101, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[4:7], v[152:155], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[12:15], v[168:171], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[12:15], v[164:167], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[80:83], a[16:19], v[180:183], v101, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[88:91], a[16:19], v[184:187], v101, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[88:91], a[24:27], v[200:203], v101, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[80:83], a[24:27], v[196:199], v101, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[20:23], v[180:183], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[20:23], v[184:187], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[28:31], v[200:203], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[28:31], v[196:199], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[64:67], a[16:19], v[172:175], v100, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[72:75], a[16:19], v[176:179], v100, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[72:75], a[24:27], v[192:195], v100, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[64:67], a[24:27], v[188:191], v100, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[20:23], v[172:175], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[20:23], v[176:179], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[28:31], v[192:195], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[28:31], v[188:191], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[64:67], a[32:35], v[204:207], v100, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[72:75], a[32:35], v[208:211], v100, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[72:75], a[40:43], v[224:227], v100, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[40:43], v[220:223], v100, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[36:39], v[204:207], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[36:39], v[208:211], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[44:47], v[224:227], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[44:47], v[220:223], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[80:83], a[32:35], v[212:215], v101, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[88:91], a[32:35], v[216:219], v101, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[88:91], a[40:43], v[232:235], v101, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[80:83], a[40:43], v[228:231], v101, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[36:39], v[212:215], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[36:39], v[216:219], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[44:47], v[232:235], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[44:47], v[228:231], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v101, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v101, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v101, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v101, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[64:67], a[48:51], v[236:239], v100, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v100, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v100, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v100, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[52:55], v[236:239], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_readfirstlane_b32 s16, v80
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_4:
		ds_read_b32 v80, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v80
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_4
.L_a4w4_kernel.loop_exit_4:
		s_mov_b64 exec, s[20:21]
		ds_read_b128 a[64:67], v66 offset:35712
		ds_read_b128 a[68:71], v66 offset:35776
		ds_read_b128 a[72:75], v66 offset:35968
		ds_read_b128 a[76:79], v66 offset:36032
		ds_read_b128 a[80:83], v66 offset:36224
		ds_read_b128 a[84:87], v66 offset:36288
		ds_read_b128 a[88:91], v66 offset:36480
		ds_read_b128 a[92:95], v66 offset:36544
		v_or_b32_e32 v80, v115, v117
		v_lshlrev_b32_e32 v80, 8, v80
		v_or3_b32 v80, v114, v116, v80
		ds_write_b32 v72, v80 offset:5952
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v80, v9, v65
		s_mov_b64 exec, s[20:21]
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s23
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v80
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_5:
		ds_read_b32 v80, v9
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v80
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_5
.L_a4w4_kernel.loop_exit_5:
		s_mov_b64 exec, s[20:21]
		ds_read_b64_tr_b8 v[100:101], v43 offset:5952
		buffer_load_dwordx4 v34, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[0:3], a[128:131], v100, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v49, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[0:3], a[132:135], v100, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v51, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[8:11], a[148:151], v100, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v52, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[8:11], a[144:147], v100, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v50, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x6300
		v_or_b32_e32 v80, v144, v146
		buffer_load_dwordx4 v55, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x7380
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[0:3], a[136:139], v101, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[0:3], a[140:143], v101, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[8:11], a[156:159], v101, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[8:11], a[152:155], v101, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[4:7], a[140:143], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[12:15], a[156:159], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[16:19], a[168:171], v101, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[16:19], a[172:175], v101, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[24:27], a[188:191], v101, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[24:27], a[184:187], v101, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[20:23], a[172:175], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[92:95], a[28:31], a[188:191], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[16:19], a[160:163], v100, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[16:19], a[164:167], v100, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[24:27], a[180:183], v100, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[24:27], a[176:179], v100, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v53, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x107c0
		v_or_b32_e32 v90, v136, v138
		v_accvgpr_write_b32 a0, v90
		buffer_load_dwordx4 v58, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x11840
		v_or_b32_e32 v90, v128, v134
		v_accvgpr_write_b32 a1, v90
		buffer_load_dwordx4 v63, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x128c0
		s_add_u32 s44, s10, s14
		s_addc_u32 s45, s11, 0
		buffer_load_dwordx4 v64, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x13940
		s_add_u32 s40, s8, s15
		s_addc_u32 s41, s9, 0
		buffer_load_dwordx4 v62, s[32:35], 0 offen lds
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v90, v15, v65
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a2, v90
		s_mov_b64 exec, s[20:21]
		buffer_load_ubyte v90, v67, s[40:43], 0 offen
		buffer_load_ubyte v102, v77, s[40:43], 0 offen
		buffer_load_ubyte v150, v79, s[40:43], 0 offen
		buffer_load_ubyte v151, v81, s[40:43], 0 offen
		buffer_load_ubyte v244, v83, s[40:43], 0 offen
		buffer_load_ubyte v245, v85, s[40:43], 0 offen
		buffer_load_ubyte v246, v87, s[40:43], 0 offen
		buffer_load_ubyte v247, v74, s[40:43], 0 offen
		buffer_load_ubyte v248, v95, s[44:47], 0 offen
		buffer_load_ubyte v249, v71, s[44:47], 0 offen
		buffer_load_ubyte v250, v98, s[44:47], 0 offen
		buffer_load_ubyte v251, v70, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[32:35], a[192:195], v100, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[32:35], a[196:199], v100, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[72:75], a[40:43], a[212:215], v100, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[64:67], a[40:43], a[208:211], v100, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[32:35], a[200:203], v101, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[32:35], a[204:207], v101, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[88:91], a[40:43], a[220:223], v101, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[80:83], a[40:43], a[216:219], v101, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[92:95], a[36:39], a[204:207], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[92:95], a[44:47], a[220:223], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[80:83], a[48:51], a[232:235], v101, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[88:91], a[48:51], a[236:239], v101, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[88:91], a[56:59], a[252:255], v101, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[80:83], a[56:59], a[248:251], v101, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[92:95], a[52:55], a[236:239], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[92:95], a[60:63], a[252:255], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[64:67], a[48:51], a[224:227], v100, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[72:75], a[48:51], a[228:231], v100, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[72:75], a[56:59], a[244:247], v100, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[64:67], a[56:59], a[240:243], v100, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s16, v94
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_6:
		ds_read_b32 v91, v10
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v91
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_6
.L_a4w4_kernel.loop_exit_6:
		s_mov_b64 exec, s[20:21]
		ds_read_b128 a[4:7], v1 offset:33760
		ds_read_b128 a[8:11], v1 offset:33824
		ds_read_b128 a[12:15], v1 offset:34016
		ds_read_b128 a[16:19], v1 offset:34080
		ds_read_b128 a[20:23], v1 offset:34272
		ds_read_b128 a[24:27], v1 offset:34336
		ds_read_b128 a[28:31], v1 offset:34528
		ds_read_b128 a[32:35], v1 offset:34592
		ds_read_b128 a[36:39], v1 offset:50656
		ds_read_b128 a[40:43], v1 offset:50720
		ds_read_b128 a[44:47], v1 offset:50912
		ds_read_b128 a[48:51], v1 offset:50976
		ds_read_b128 a[52:55], v1 offset:51168
		ds_read_b128 a[56:59], v1 offset:51232
		ds_read_b128 a[60:63], v1 offset:51424
		ds_read_b128 a[64:67], v1 offset:51488
		ds_read_b128 a[68:71], v66 offset:18848
		ds_read_b128 a[72:75], v66 offset:18912
		ds_read_b128 a[76:79], v66 offset:19104
		ds_read_b128 a[80:83], v66 offset:19168
		ds_read_b128 a[84:87], v66 offset:19360
		ds_read_b128 a[88:91], v66 offset:19424
		ds_read_b128 a[92:95], v66 offset:19616
		ds_read_b128 v[252:255], v66 offset:19680
		v_accvgpr_read_b32 v91, a1
		v_lshlrev_b32_e32 v91, 8, v91
		v_or3_b32 v92, v127, v133, v91
		v_accvgpr_read_b32 v91, a0
		v_lshlrev_b32_e32 v91, 8, v91
		v_or3_b32 v93, v135, v137, v91
		ds_write_b64 v78, v[92:93] offset:3904
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v91, v11, v65
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v80, 8, v80
		v_or3_b32 v80, v143, v145, v80
		s_add_i32 m0, s23, 0x18b80
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v91
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_7:
		ds_read_b32 v91, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v91
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_7
.L_a4w4_kernel.loop_exit_7:
		s_mov_b64 exec, s[20:21]
		ds_write_b32 v72, v80 offset:5952
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v80, v12, v65
		s_mov_b64 exec, s[20:21]
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x19c00
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v80
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_8:
		ds_read_b32 v80, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v80
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_8
.L_a4w4_kernel.loop_exit_8:
		s_mov_b64 exec, s[20:21]
		ds_read_b64_tr_b8 v[92:93], v3 offset:3904
		ds_read_b64_tr_b8 a[0:1], v3 offset:4032
		ds_read_b64_tr_b8 v[100:101], v43 offset:5952
		buffer_load_dwordx4 v105, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1ac80
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v100, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v106, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1bd00
		v_or_b32_e32 v80, v107, v110
		buffer_load_dwordx4 v104, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v114, v108, s[44:47], 0 offen
		buffer_load_ubyte_d16 v115, v112, s[44:47], 0 offen
		v_mov_b32_e32 v116, 0
		buffer_load_ubyte_d16_hi v116, v113, s[44:47], 0 offen
		v_mov_b32_e32 v117, 0
		buffer_load_ubyte_d16_hi v117, v111, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v100, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[12:15], v[160:163], v100, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[12:15], v[156:159], v100, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[72:75], a[8:11], v[240:243], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[80:83], a[8:11], a[96:99], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[80:83], a[16:19], v[160:163], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[72:75], a[16:19], v[156:159], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v101, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[4:7], v[152:155], v101, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[12:15], v[168:171], v101, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[12:15], v[164:167], v101, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[88:91], a[8:11], v[4:7], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], a[8:11], v[152:155], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], a[16:19], v[168:171], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], a[16:19], v[164:167], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[20:23], v[180:183], v101, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[20:23], v[184:187], v101, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[28:31], v[200:203], v101, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[28:31], v[196:199], v101, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], a[24:27], v[180:183], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], a[24:27], v[184:187], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], a[32:35], v[200:203], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], a[32:35], v[196:199], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[20:23], v[172:175], v100, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[20:23], v[176:179], v100, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[28:31], v[192:195], v100, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[28:31], v[188:191], v100, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[72:75], a[24:27], v[172:175], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[80:83], a[24:27], v[176:179], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[80:83], a[32:35], v[192:195], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[72:75], a[32:35], v[188:191], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[36:39], v[204:207], v100, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[36:39], v[208:211], v100, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[44:47], v[224:227], v100, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[44:47], v[220:223], v100, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[72:75], a[40:43], v[204:207], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], a[40:43], v[208:211], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[48:51], v[224:227], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[48:51], v[220:223], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[36:39], v[212:215], v101, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[36:39], v[216:219], v101, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[44:47], v[232:235], v101, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[44:47], v[228:231], v101, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[88:91], a[40:43], v[212:215], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], a[40:43], v[216:219], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[252:255], a[48:51], v[232:235], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[48:51], v[228:231], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v101, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v101, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v101, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v101, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[56:59], a[104:107], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[56:59], a[108:111], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[64:67], a[124:127], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[64:67], a[120:123], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[52:55], v[236:239], v100, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v100, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v100, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v100, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[56:59], v[236:239], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[56:59], a[100:103], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[64:67], a[116:119], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v91, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[64:67], a[112:115], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s16, v99
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_9:
		ds_read_b32 v91, v13
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v91
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_9
.L_a4w4_kernel.loop_exit_9:
		s_mov_b64 exec, s[20:21]
		ds_read_b128 a[68:71], v66 offset:52576
		ds_read_b128 a[72:75], v66 offset:52640
		ds_read_b128 a[76:79], v66 offset:52832
		ds_read_b128 a[80:83], v66 offset:52896
		ds_read_b128 a[84:87], v66 offset:53088
		ds_read_b128 a[88:91], v66 offset:53152
		ds_read_b128 a[92:95], v66 offset:53344
		ds_read_b128 v[252:255], v66 offset:53408
		v_lshlrev_b32_e32 v80, 8, v80
		v_or3_b32 v61, v61, v109, v80
		ds_write_b32 v72, v61 offset:5952
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v61, v14, v65
		s_mov_b64 exec, s[20:21]
		s_add_i32 m0, s23, 0x83e0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v61
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_10:
		ds_read_b32 v61, v14
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v61
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_10
.L_a4w4_kernel.loop_exit_10:
		s_mov_b64 exec, s[20:21]
		ds_read_b64_tr_b8 v[100:101], v43 offset:5952
		buffer_load_dwordx4 v118, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x9460
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[4:7], a[128:131], v100, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v119, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xa4e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[4:7], a[132:135], v100, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v120, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[12:15], a[148:151], v100, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v121, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[12:15], a[144:147], v100, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v122, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[8:11], a[128:131], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v123, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[8:11], a[132:135], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v124, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[16:19], a[148:151], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[16:19], a[144:147], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[4:7], a[136:139], v101, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[92:95], a[4:7], a[140:143], v101, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[92:95], a[12:15], a[156:159], v101, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[12:15], a[152:155], v101, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[8:11], a[136:139], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[8:11], a[140:143], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[16:19], a[156:159], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[16:19], a[152:155], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[20:23], a[168:171], v101, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[92:95], a[20:23], a[172:175], v101, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[92:95], a[28:31], a[188:191], v101, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[28:31], a[184:187], v101, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[24:27], a[168:171], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[24:27], a[172:175], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[32:35], a[188:191], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[88:91], a[32:35], a[184:187], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[20:23], a[160:163], v100, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[20:23], a[164:167], v100, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[28:31], a[180:183], v100, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[28:31], a[176:179], v100, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[24:27], a[160:163], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[24:27], a[164:167], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[80:83], a[32:35], a[180:183], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x149a0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[32:35], a[176:179], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x15a20
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[36:39], a[192:195], v100, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v39, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x16aa0
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[36:39], a[196:199], v100, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x17b20
		s_add_i32 s37, s37, 2
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v127, v126, s[40:43], 0 offen
		buffer_load_ubyte_d16 v128, v129, s[40:43], 0 offen
		v_mov_b32_e32 v133, 0
		buffer_load_ubyte_d16_hi v133, v131, s[40:43], 0 offen
		v_mov_b32_e32 v134, 0
		buffer_load_ubyte_d16_hi v134, v132, s[40:43], 0 offen
		buffer_load_ubyte_d16 v135, v130, s[40:43], 0 offen
		buffer_load_ubyte_d16 v136, v69, s[40:43], 0 offen
		v_mov_b32_e32 v137, 0
		buffer_load_ubyte_d16_hi v137, v125, s[40:43], 0 offen
		v_mov_b32_e32 v138, 0
		buffer_load_ubyte_d16_hi v138, v68, s[40:43], 0 offen
		buffer_load_ubyte_d16 v143, v139, s[44:47], 0 offen
		buffer_load_ubyte_d16 v144, v141, s[44:47], 0 offen
		v_mov_b32_e32 v145, 0
		buffer_load_ubyte_d16_hi v145, v142, s[44:47], 0 offen
		v_mov_b32_e32 v146, 0
		buffer_load_ubyte_d16_hi v146, v140, s[44:47], 0 offen
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[76:79], a[44:47], a[212:215], v100, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[44:47], a[208:211], v100, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[40:43], a[192:195], v100, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[80:83], a[40:43], a[196:199], v100, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[80:83], a[48:51], a[212:215], v100, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[48:51], a[208:211], v100, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[36:39], a[200:203], v101, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[92:95], a[36:39], a[204:207], v101, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[92:95], a[44:47], a[220:223], v101, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[84:87], a[44:47], a[216:219], v101, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[88:91], a[40:43], a[200:203], v101, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[40:43], a[204:207], v101, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], a[48:51], a[220:223], v101, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a0
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[88:91], a[48:51], a[216:219], v101, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[84:87], a[52:55], a[232:235], v101, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[92:95], a[52:55], a[236:239], v101, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[92:95], a[60:63], a[252:255], v101, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[84:87], a[60:63], a[248:251], v101, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[88:91], a[56:59], a[232:235], v101, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[252:255], a[56:59], a[236:239], v101, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[252:255], a[64:67], a[252:255], v101, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[88:91], a[64:67], a[248:251], v101, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[52:55], a[224:227], v100, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[76:79], a[52:55], a[228:231], v100, v61 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[76:79], a[60:63], a[244:247], v100, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[60:63], a[240:243], v100, v61 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[56:59], a[224:227], v100, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[80:83], a[56:59], a[228:231], v100, v61 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[80:83], a[64:67], a[244:247], v100, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a1
		s_nop 1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[64:67], a[240:243], v100, v61 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v61, a2
		s_nop 0
		v_readfirstlane_b32 s16, v61
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_11:
		ds_read_b32 v61, v15
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v61
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_11
.L_a4w4_kernel.loop_exit_11:
		s_mov_b64 exec, s[20:21]
		ds_read_b128 a[0:3], v1
		ds_read_b128 a[4:7], v1 offset:64
		ds_read_b128 a[8:11], v1 offset:256
		ds_read_b128 a[12:15], v1 offset:320
		ds_read_b128 a[16:19], v1 offset:512
		ds_read_b128 a[20:23], v1 offset:576
		ds_read_b128 a[24:27], v1 offset:768
		ds_read_b128 a[28:31], v1 offset:832
		ds_read_b128 a[32:35], v1 offset:16896
		ds_read_b128 a[36:39], v1 offset:16960
		ds_read_b128 a[40:43], v1 offset:17152
		ds_read_b128 a[44:47], v1 offset:17216
		ds_read_b128 a[48:51], v1 offset:17408
		ds_read_b128 a[52:55], v1 offset:17472
		ds_read_b128 a[56:59], v1 offset:17664
		ds_read_b128 a[60:63], v1 offset:17728
		ds_read_b128 a[64:67], v66 offset:1984
		ds_read_b128 a[68:71], v66 offset:2048
		ds_read_b128 a[72:75], v66 offset:2240
		ds_read_b128 a[76:79], v66 offset:2304
		ds_read_b128 a[80:83], v66 offset:2496
		ds_read_b128 a[84:87], v66 offset:2560
		ds_read_b128 a[88:91], v66 offset:2752
		ds_read_b128 a[92:95], v66 offset:2816
		s_waitcnt vmcnt(43)
		ds_write_b8 v149, v90 offset:3904
		s_waitcnt vmcnt(42)
		ds_write_b8 v148, v102 offset:3904
		s_waitcnt vmcnt(41)
		ds_write_b8 v88, v150 offset:3904
		s_waitcnt vmcnt(40)
		ds_write_b8 v89, v151 offset:3904
		s_waitcnt vmcnt(39)
		ds_write_b8 v82, v244 offset:3904
		s_waitcnt vmcnt(38)
		ds_write_b8 v84, v245 offset:3904
		s_waitcnt vmcnt(37)
		ds_write_b8 v86, v246 offset:3904
		s_waitcnt vmcnt(36)
		ds_write_b8 v73, v247 offset:3904
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v61, v16, v65
		s_mov_b64 exec, s[20:21]
		s_add_i32 m0, s23, 0x1cd60
		s_add_i32 s14, s14, 16
		buffer_load_dwordx4 v147, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1dde0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v61
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_12:
		ds_read_b32 v61, v16
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v61
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_12
.L_a4w4_kernel.loop_exit_12:
		s_mov_b64 exec, s[20:21]
		s_waitcnt vmcnt(36)
		ds_write_b8 v2, v248 offset:5952
		s_waitcnt vmcnt(35)
		ds_write_b8 v75, v249 offset:5952
		s_waitcnt vmcnt(34)
		ds_write_b8 v76, v250 offset:5952
		s_waitcnt vmcnt(33)
		ds_write_b8 v40, v251 offset:5952
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v61, v17, v65
		s_mov_b64 exec, s[20:21]
		s_add_i32 s15, s15, 16
		buffer_load_dwordx4 v57, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1ee60
		s_add_i32 s13, s13, 0x100
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v61
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_13:
		ds_read_b32 v61, v17
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v61
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_13
.L_a4w4_kernel.loop_exit_13:
		s_mov_b64 exec, s[20:21]
		ds_read_b64_tr_b8 v[90:91], v3 offset:3904
		ds_read_b64_tr_b8 v[92:93], v3 offset:4032
		ds_read_b64_tr_b8 v[100:101], v43 offset:5952
		buffer_load_dwordx4 v59, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1fee0
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v56, s[32:35], 0 offen lds
		buffer_load_ubyte_d16 v61, v60, s[44:47], 0 offen
		buffer_load_ubyte_d16 v107, v96, s[44:47], 0 offen
		v_mov_b32_e32 v109, 0
		buffer_load_ubyte_d16_hi v109, v97, s[44:47], 0 offen
		v_mov_b32_e32 v110, 0
		buffer_load_ubyte_d16_hi v110, v35, s[44:47], 0 offen
		s_cmp_lt_i32 s37, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_3
.L_a4w4_kernel.loop_exit_3:
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v2, 0x21b74
		s_waitcnt vmcnt(4)
		ds_add_rtn_u32 v8, v2, v65
		s_mov_b64 exec, s[2:3]
		v_or_b32_e32 v9, v115, v117
		v_lshlrev_b32_e32 v9, 8, v9
		v_or3_b32 v9, v114, v116, v9
		v_or_b32_e32 v10, v128, v134
		v_lshlrev_b32_e32 v10, 8, v10
		v_or3_b32 v12, v127, v133, v10
		v_or_b32_e32 v10, v136, v138
		v_lshlrev_b32_e32 v10, 8, v10
		v_or3_b32 v13, v135, v137, v10
		v_or_b32_e32 v10, v144, v146
		v_lshlrev_b32_e32 v10, 8, v10
		v_or3_b32 v10, v143, v145, v10
		s_waitcnt vmcnt(0)
		v_or_b32_e32 v11, v107, v110
		v_lshlrev_b32_e32 v11, 8, v11
		v_or3_b32 v11, v61, v109, v11
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], a[0:3], v[240:243], v100, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v100, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[72:75], a[8:11], v[160:163], v100, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[64:67], a[8:11], v[156:159], v100, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[68:71], a[4:7], v[240:243], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[76:79], a[12:15], v[160:163], v100, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[68:71], a[12:15], v[156:159], v100, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v101, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[88:91], a[0:3], v[152:155], v101, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[88:91], a[8:11], v[168:171], v101, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[80:83], a[8:11], v[164:167], v101, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], a[4:7], v[152:155], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], a[12:15], v[168:171], v101, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[84:87], a[12:15], v[164:167], v101, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[80:83], a[16:19], v[180:183], v101, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[88:91], a[16:19], v[184:187], v101, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[88:91], a[24:27], v[200:203], v101, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[80:83], a[24:27], v[196:199], v101, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[84:87], a[20:23], v[180:183], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], a[20:23], v[184:187], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], a[28:31], v[200:203], v101, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[84:87], a[28:31], v[196:199], v101, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[64:67], a[16:19], v[172:175], v100, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[72:75], a[16:19], v[176:179], v100, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[72:75], a[24:27], v[192:195], v100, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[64:67], a[24:27], v[188:191], v100, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[68:71], a[20:23], v[172:175], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[76:79], a[20:23], v[176:179], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[76:79], a[28:31], v[192:195], v100, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], a[28:31], v[188:191], v100, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[64:67], a[32:35], v[204:207], v100, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[72:75], a[32:35], v[208:211], v100, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[72:75], a[40:43], v[224:227], v100, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[40:43], v[220:223], v100, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], a[36:39], v[204:207], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[76:79], a[36:39], v[208:211], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[76:79], a[44:47], v[224:227], v100, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[44:47], v[220:223], v100, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[80:83], a[32:35], v[212:215], v101, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[88:91], a[32:35], v[216:219], v101, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[88:91], a[40:43], v[232:235], v101, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[80:83], a[40:43], v[228:231], v101, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[84:87], a[36:39], v[212:215], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], a[36:39], v[216:219], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], a[44:47], v[232:235], v101, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[84:87], a[44:47], v[228:231], v101, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[48:51], a[104:107], v101, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[48:51], a[108:111], v101, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[56:59], a[124:127], v101, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[56:59], a[120:123], v101, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[52:55], a[104:107], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[92:95], a[52:55], a[108:111], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[92:95], a[60:63], a[124:127], v101, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[60:63], a[120:123], v101, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[64:67], a[48:51], v[236:239], v100, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[48:51], a[100:103], v100, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[56:59], a[116:119], v100, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[56:59], a[112:115], v100, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[52:55], v[236:239], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[52:55], a[100:103], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[60:63], a[116:119], v100, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[60:63], a[112:115], v100, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v8
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_14:
		ds_read_b32 v8, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v8
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_14
.L_a4w4_kernel.loop_exit_14:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[52:55], v66 offset:35712
		ds_read_b128 v[56:59], v66 offset:35776
		ds_read_b128 v[60:63], v66 offset:35968
		ds_read_b128 v[68:71], v66 offset:36032
		ds_read_b128 v[80:83], v66 offset:36224
		ds_read_b128 v[84:87], v66 offset:36288
		ds_read_b128 v[96:99], v66 offset:36480
		ds_read_b128 v[100:103], v66 offset:36544
		ds_write_b32 v72, v9 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v2, 0x21b78
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v8, v2, v65
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v14, 1, v0
		v_lshlrev_b32_e32 v14, 9, v14
		v_lshrrev_b32_e32 v0, 4, v0
		v_lshl_add_u32 v0, v0, 4, v14
		v_lshl_add_u32 v0, v41, 13, v0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v8
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_15:
		ds_read_b32 v8, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v8
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_15
.L_a4w4_kernel.loop_exit_15:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[14:15], v43 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[0:3], a[128:131], v14, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[0:3], a[132:135], v14, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[8:11], a[148:151], v14, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[8:11], a[144:147], v14, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[56:59], a[4:7], a[128:131], v14, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[68:71], a[4:7], a[132:135], v14, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[68:71], a[12:15], a[148:151], v14, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[56:59], a[12:15], a[144:147], v14, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], a[0:3], a[136:139], v15, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], a[0:3], a[140:143], v15, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], a[8:11], a[156:159], v15, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], a[8:11], a[152:155], v15, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[84:87], a[4:7], a[136:139], v15, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], a[4:7], a[140:143], v15, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], a[12:15], a[156:159], v15, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], a[12:15], a[152:155], v15, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], a[16:19], a[168:171], v15, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], a[16:19], a[172:175], v15, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], a[24:27], a[188:191], v15, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[80:83], a[24:27], a[184:187], v15, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], a[20:23], a[168:171], v15, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], a[20:23], a[172:175], v15, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], a[28:31], a[188:191], v15, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[84:87], a[28:31], a[184:187], v15, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], a[16:19], a[160:163], v14, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[16:19], a[164:167], v14, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[60:63], a[24:27], a[180:183], v14, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], a[24:27], a[176:179], v14, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[56:59], a[20:23], a[160:163], v14, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[68:71], a[20:23], a[164:167], v14, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[68:71], a[28:31], a[180:183], v14, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[56:59], a[28:31], a[176:179], v14, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[52:55], a[32:35], a[192:195], v14, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], a[32:35], a[196:199], v14, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[60:63], a[40:43], a[212:215], v14, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[52:55], a[40:43], a[208:211], v14, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], a[36:39], a[192:195], v14, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[68:71], a[36:39], a[196:199], v14, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[68:71], a[44:47], a[212:215], v14, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], a[44:47], a[208:211], v14, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[80:83], a[32:35], a[200:203], v15, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], a[32:35], a[204:207], v15, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[96:99], a[40:43], a[220:223], v15, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[80:83], a[40:43], a[216:219], v15, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[84:87], a[36:39], a[200:203], v15, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], a[36:39], a[204:207], v15, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], a[44:47], a[220:223], v15, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[84:87], a[44:47], a[216:219], v15, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[80:83], a[48:51], a[232:235], v15, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[96:99], a[48:51], a[236:239], v15, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[96:99], a[56:59], a[252:255], v15, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[80:83], a[56:59], a[248:251], v15, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[84:87], a[52:55], a[232:235], v15, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[100:103], a[52:55], a[236:239], v15, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[100:103], a[60:63], a[252:255], v15, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[84:87], a[60:63], a[248:251], v15, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[52:55], a[48:51], a[224:227], v14, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[60:63], a[48:51], a[228:231], v14, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[60:63], a[56:59], a[244:247], v14, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[52:55], a[56:59], a[240:243], v14, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[56:59], a[52:55], a[224:227], v14, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[68:71], a[52:55], a[228:231], v14, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[68:71], a[60:63], a[244:247], v14, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[56:59], a[60:63], a[240:243], v14, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v1 offset:33760
		ds_read_b128 v[56:59], v1 offset:33824
		ds_read_b128 v[60:63], v1 offset:34016
		ds_read_b128 v[68:71], v1 offset:34080
		ds_read_b128 v[80:83], v1 offset:34272
		ds_read_b128 v[84:87], v1 offset:34336
		ds_read_b128 v[88:91], v1 offset:34528
		ds_read_b128 v[92:95], v1 offset:34592
		ds_read_b128 v[96:99], v1 offset:50656
		ds_read_b128 v[100:103], v1 offset:50720
		ds_read_b128 v[104:107], v1 offset:50912
		ds_read_b128 v[108:111], v1 offset:50976
		ds_read_b128 v[112:115], v1 offset:51168
		ds_read_b128 v[116:119], v1 offset:51232
		ds_read_b128 v[120:123], v1 offset:51424
		ds_read_b128 v[124:127], v1 offset:51488
		ds_read_b128 v[128:131], v66 offset:18848
		ds_read_b128 v[132:135], v66 offset:18912
		ds_read_b128 v[136:139], v66 offset:19104
		ds_read_b128 v[140:143], v66 offset:19168
		ds_read_b128 v[144:147], v66 offset:19360
		ds_read_b128 v[148:151], v66 offset:19424
		ds_read_b128 v[244:247], v66 offset:19616
		ds_read_b128 v[248:251], v66 offset:19680
		ds_write_b64 v78, v[12:13] offset:3904
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b7c
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v1, v65
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v8, 12, v45
		v_add3_u32 v0, v0, v8, v47
		v_lshlrev_b32_e32 v8, 7, v41
		v_lshlrev_b32_e32 v12, 3, v30
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_16:
		ds_read_b32 v2, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_16
.L_a4w4_kernel.loop_exit_16:
		s_mov_b64 exec, s[2:3]
		ds_write_b32 v72, v10 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b80
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v1, v65
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v10, 2, v32
		v_add_u32_e32 v13, 16, v38
		v_lshlrev_b32_e32 v14, 1, v36
		v_xor_b32_e32 v13, v13, v14
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_17:
		ds_read_b32 v2, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_17
.L_a4w4_kernel.loop_exit_17:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[16:17], v3 offset:3904
		ds_read_b64_tr_b8 v[34:35], v3 offset:4032
		ds_read_b64_tr_b8 v[2:3], v43 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[128:131], v[52:55], v[240:243], v2, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[136:139], v[52:55], a[96:99], v2, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[136:139], v[60:63], v[160:163], v2, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[128:131], v[60:63], v[156:159], v2, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[132:135], v[56:59], v[240:243], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[140:143], v[56:59], a[96:99], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[140:143], v[68:71], v[160:163], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[132:135], v[68:71], v[156:159], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[144:147], v[52:55], v[4:7], v3, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[244:247], v[52:55], v[152:155], v3, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[244:247], v[60:63], v[168:171], v3, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[144:147], v[60:63], v[164:167], v3, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[148:151], v[56:59], v[4:7], v3, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[248:251], v[56:59], v[152:155], v3, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[248:251], v[68:71], v[168:171], v3, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[148:151], v[68:71], v[164:167], v3, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[144:147], v[80:83], v[180:183], v3, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[244:247], v[80:83], v[184:187], v3, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[88:91], v[200:203], v3, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[144:147], v[88:91], v[196:199], v3, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[148:151], v[84:87], v[180:183], v3, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[248:251], v[84:87], v[184:187], v3, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[248:251], v[92:95], v[200:203], v3, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[148:151], v[92:95], v[196:199], v3, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[128:131], v[80:83], v[172:175], v2, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[136:139], v[80:83], v[176:179], v2, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[136:139], v[88:91], v[192:195], v2, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[128:131], v[88:91], v[188:191], v2, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[132:135], v[84:87], v[172:175], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[140:143], v[84:87], v[176:179], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[140:143], v[92:95], v[192:195], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[132:135], v[92:95], v[188:191], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[128:131], v[96:99], v[204:207], v2, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[136:139], v[96:99], v[208:211], v2, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[136:139], v[104:107], v[224:227], v2, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[128:131], v[104:107], v[220:223], v2, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[132:135], v[100:103], v[204:207], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[140:143], v[100:103], v[208:211], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[140:143], v[108:111], v[224:227], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[132:135], v[108:111], v[220:223], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[144:147], v[96:99], v[212:215], v3, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[96:99], v[216:219], v3, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[244:247], v[104:107], v[232:235], v3, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[144:147], v[104:107], v[228:231], v3, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[148:151], v[100:103], v[212:215], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[248:251], v[100:103], v[216:219], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[248:251], v[108:111], v[232:235], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[148:151], v[108:111], v[228:231], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], v[112:115], a[104:107], v3, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[244:247], v[112:115], a[108:111], v3, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[244:247], v[120:123], a[124:127], v3, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], v[120:123], a[120:123], v3, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[148:151], v[116:119], a[104:107], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[248:251], v[116:119], a[108:111], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[248:251], v[124:127], a[124:127], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[148:151], v[124:127], a[120:123], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[128:131], v[112:115], v[236:239], v2, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[136:139], v[112:115], a[100:103], v2, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[136:139], v[120:123], a[116:119], v2, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[128:131], v[120:123], a[112:115], v2, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[132:135], v[116:119], v[236:239], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[140:143], v[116:119], a[100:103], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[140:143], v[124:127], a[116:119], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[132:135], v[124:127], a[112:115], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v66 offset:52576
		ds_read_b128 v[128:131], v66 offset:52640
		ds_read_b128 v[132:135], v66 offset:52832
		ds_read_b128 v[136:139], v66 offset:52896
		ds_read_b128 v[140:143], v66 offset:53088
		ds_read_b128 v[144:147], v66 offset:53152
		ds_read_b128 v[148:151], v66 offset:53344
		ds_read_b128 v[244:247], v66 offset:53408
		ds_write_b32 v72, v11 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b84
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v1, v65
		s_mov_b64 exec, s[2:3]
		v_cvt_pk_bf16_f32 v72, v240, v241
		v_cvt_pk_bf16_f32 v73, v242, v243
		v_accvgpr_read_b32 v3, a96
		v_accvgpr_read_b32 v11, a97
		v_cvt_pk_bf16_f32 v240, v3, v11
		v_accvgpr_read_b32 v3, a98
		v_accvgpr_read_b32 v11, a99
		v_cvt_pk_bf16_f32 v241, v3, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_18:
		ds_read_b32 v2, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_18
.L_a4w4_kernel.loop_exit_18:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[2:3], v43 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_cvt_pk_bf16_f32 v41, v6, v7
		v_cvt_pk_bf16_f32 v4, v152, v153
		v_cvt_pk_bf16_f32 v5, v154, v155
		v_cvt_pk_bf16_f32 v74, v156, v157
		v_cvt_pk_bf16_f32 v75, v158, v159
		v_cvt_pk_bf16_f32 v242, v160, v161
		v_cvt_pk_bf16_f32 v243, v162, v163
		v_cvt_pk_bf16_f32 v42, v164, v165
		v_cvt_pk_bf16_f32 v43, v166, v167
		v_cvt_pk_bf16_f32 v6, v168, v169
		v_cvt_pk_bf16_f32 v7, v170, v171
		v_cvt_pk_bf16_f32 v152, v172, v173
		v_cvt_pk_bf16_f32 v153, v174, v175
		v_cvt_pk_bf16_f32 v156, v176, v177
		v_cvt_pk_bf16_f32 v157, v178, v179
		v_cvt_pk_bf16_f32 v160, v180, v181
		v_cvt_pk_bf16_f32 v161, v182, v183
		v_cvt_pk_bf16_f32 v164, v184, v185
		v_cvt_pk_bf16_f32 v165, v186, v187
		v_cvt_pk_bf16_f32 v154, v188, v189
		v_cvt_pk_bf16_f32 v155, v190, v191
		v_cvt_pk_bf16_f32 v158, v192, v193
		v_cvt_pk_bf16_f32 v159, v194, v195
		v_cvt_pk_bf16_f32 v162, v196, v197
		v_cvt_pk_bf16_f32 v163, v198, v199
		v_cvt_pk_bf16_f32 v166, v200, v201
		v_cvt_pk_bf16_f32 v167, v202, v203
		v_cvt_pk_bf16_f32 v168, v204, v205
		v_cvt_pk_bf16_f32 v169, v206, v207
		v_cvt_pk_bf16_f32 v172, v208, v209
		v_cvt_pk_bf16_f32 v173, v210, v211
		v_cvt_pk_bf16_f32 v176, v212, v213
		v_cvt_pk_bf16_f32 v177, v214, v215
		v_cvt_pk_bf16_f32 v180, v216, v217
		v_cvt_pk_bf16_f32 v181, v218, v219
		v_cvt_pk_bf16_f32 v170, v220, v221
		v_cvt_pk_bf16_f32 v171, v222, v223
		v_cvt_pk_bf16_f32 v174, v224, v225
		v_cvt_pk_bf16_f32 v175, v226, v227
		v_cvt_pk_bf16_f32 v178, v228, v229
		v_cvt_pk_bf16_f32 v179, v230, v231
		v_cvt_pk_bf16_f32 v182, v232, v233
		v_cvt_pk_bf16_f32 v183, v234, v235
		v_cvt_pk_bf16_f32 v184, v236, v237
		v_cvt_pk_bf16_f32 v185, v238, v239
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v11, a101
		v_cvt_pk_bf16_f32 v188, v1, v11
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v11, a103
		v_cvt_pk_bf16_f32 v189, v1, v11
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v11, a105
		v_cvt_pk_bf16_f32 v192, v1, v11
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v11, a107
		v_cvt_pk_bf16_f32 v193, v1, v11
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v11, a109
		v_cvt_pk_bf16_f32 v196, v1, v11
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v11, a111
		v_cvt_pk_bf16_f32 v197, v1, v11
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v11, a113
		v_cvt_pk_bf16_f32 v186, v1, v11
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v11, a115
		v_cvt_pk_bf16_f32 v187, v1, v11
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v11, a117
		v_cvt_pk_bf16_f32 v190, v1, v11
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v11, a119
		v_cvt_pk_bf16_f32 v191, v1, v11
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v11, a121
		v_cvt_pk_bf16_f32 v194, v1, v11
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v11, a123
		v_cvt_pk_bf16_f32 v195, v1, v11
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v11, a125
		v_cvt_pk_bf16_f32 v198, v1, v11
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v11, a127
		v_cvt_pk_bf16_f32 v199, v1, v11
		ds_write_b128 v9, v[72:75]
		ds_write_b128 v9, v[240:243] offset:4096
		ds_write_b128 v9, v[40:43] offset:8192
		ds_write_b128 v9, v[4:7] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b88
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v4, v1, v65
		s_mov_b64 exec, s[2:3]
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		s_lshl_b32 s0, s0, 9
		v_xor_b32_e32 v5, v10, v13
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_19:
		ds_read_b32 v4, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v4
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_19
.L_a4w4_kernel.loop_exit_19:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[72:75], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[200:201], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[202:203], v[72:73]
		v_mov_b64_e32 v[204:205], v[42:43]
		v_mov_b64_e32 v[206:207], v[74:75]
		ds_read_b128 v[40:43], v0 offset:2048
		ds_read_b128 v[72:75], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[208:209], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[210:211], v[72:73]
		v_mov_b64_e32 v[212:213], v[42:43]
		v_mov_b64_e32 v[214:215], v[74:75]
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b8c
		ds_add_rtn_u32 v4, v1, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v5, v12, v5
		v_add_u32_e32 v6, 32, v38
		v_xor_b32_e32 v6, v6, v14
		v_xor_b32_e32 v6, v10, v6
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_20:
		ds_read_b32 v4, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v4
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_20
.L_a4w4_kernel.loop_exit_20:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[152:155]
		ds_write_b128 v9, v[156:159] offset:4096
		ds_write_b128 v9, v[160:163] offset:8192
		ds_write_b128 v9, v[164:167] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b90
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v4, v1, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v6, v12, v6
		v_add_u32_e32 v7, 48, v38
		v_xor_b32_e32 v7, v7, v14
		v_xor_b32_e32 v7, v10, v7
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_21:
		ds_read_b32 v4, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v4
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_21
.L_a4w4_kernel.loop_exit_21:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[72:75], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[152:153], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[154:155], v[72:73]
		v_mov_b64_e32 v[156:157], v[42:43]
		v_mov_b64_e32 v[158:159], v[74:75]
		ds_read_b128 v[40:43], v0 offset:2048
		ds_read_b128 v[72:75], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[160:161], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[162:163], v[72:73]
		v_mov_b64_e32 v[164:165], v[42:43]
		v_mov_b64_e32 v[166:167], v[74:75]
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v1, 0x21b94
		ds_add_rtn_u32 v4, v1, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v7, v12, v7
		v_add_u32_e32 v11, 64, v38
		v_xor_b32_e32 v11, v11, v14
		v_xor_b32_e32 v11, v10, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_22:
		ds_read_b32 v4, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v4
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_22
.L_a4w4_kernel.loop_exit_22:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[168:171]
		ds_write_b128 v9, v[172:175] offset:4096
		ds_write_b128 v9, v[176:179] offset:8192
		ds_write_b128 v9, v[180:183] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v18, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v4, v12, v11
		v_add_u32_e32 v11, 0x50, v38
		v_xor_b32_e32 v11, v11, v14
		v_xor_b32_e32 v11, v10, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_23:
		ds_read_b32 v1, v18
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_23
.L_a4w4_kernel.loop_exit_23:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[72:75], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[168:169], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[170:171], v[72:73]
		v_mov_b64_e32 v[172:173], v[42:43]
		v_mov_b64_e32 v[174:175], v[74:75]
		ds_read_b128 v[40:43], v0 offset:2048
		ds_read_b128 v[72:75], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[176:177], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[178:179], v[72:73]
		v_mov_b64_e32 v[180:181], v[42:43]
		v_mov_b64_e32 v[182:183], v[74:75]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v19, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v11, v12, v11
		v_add_u32_e32 v13, 0x60, v38
		v_xor_b32_e32 v13, v13, v14
		v_xor_b32_e32 v13, v10, v13
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_24:
		ds_read_b32 v1, v19
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_24
.L_a4w4_kernel.loop_exit_24:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[184:187]
		ds_write_b128 v9, v[188:191] offset:4096
		ds_write_b128 v9, v[192:195] offset:8192
		ds_write_b128 v9, v[196:199] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v20, v65
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v13, v12, v13
		v_add_u32_e32 v15, 0x70, v38
		v_xor_b32_e32 v15, v15, v14
		v_xor_b32_e32 v15, v10, v15
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_25:
		ds_read_b32 v1, v20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_25
.L_a4w4_kernel.loop_exit_25:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[40:43], v0
		ds_read_b128 v[72:75], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[184:185], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[186:187], v[72:73]
		v_mov_b64_e32 v[188:189], v[42:43]
		v_mov_b64_e32 v[190:191], v[74:75]
		ds_read_b128 v[40:43], v0 offset:2048
		ds_read_b128 v[72:75], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[192:193], v[40:41]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[194:195], v[72:73]
		v_mov_b64_e32 v[196:197], v[42:43]
		v_mov_b64_e32 v[198:199], v[74:75]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v21, v65
		s_mov_b64 exec, s[2:3]
		v_mul_lo_u32 v18, s17, v30
		v_lshlrev_b32_e32 v18, 4, v18
		v_mul_lo_u32 v19, s17, v32
		v_lshlrev_b32_e32 v19, 3, v19
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_26:
		ds_read_b32 v1, v21
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_26
.L_a4w4_kernel.loop_exit_26:
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, s0, v18, v19
		v_mul_lo_u32 v20, s17, v36
		v_lshlrev_b32_e32 v20, 2, v20
		v_mul_lo_u32 v21, s17, v38
		v_lshlrev_b32_e32 v21, 1, v21
		v_add3_u32 v1, v1, v20, v21
		v_add3_u32 v1, v1, v44, v8
		v_add3_u32 v1, v1, v46, v48
		buffer_store_dwordx4 v[200:203], v1, s[8:11], 0 offen
		v_mul_lo_u32 v1, s17, v5
		v_lshlrev_b32_e32 v1, 1, v1
		v_add_u32_e32 v5, s0, v1
		v_add3_u32 v5, v5, v44, v8
		v_add3_u32 v5, v5, v46, v48
		buffer_store_dwordx4 v[208:211], v5, s[8:11], 0 offen
		v_mul_lo_u32 v5, s17, v6
		v_lshlrev_b32_e32 v5, 1, v5
		v_add_u32_e32 v6, s0, v5
		v_add3_u32 v6, v6, v44, v8
		v_add3_u32 v6, v6, v46, v48
		buffer_store_dwordx4 v[204:207], v6, s[8:11], 0 offen
		v_mul_lo_u32 v6, s17, v7
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v7, s0, v6
		v_add3_u32 v7, v7, v44, v8
		v_add3_u32 v7, v7, v46, v48
		buffer_store_dwordx4 v[212:215], v7, s[8:11], 0 offen
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v7, s0, v4
		v_add3_u32 v7, v7, v44, v8
		v_add3_u32 v7, v7, v46, v48
		buffer_store_dwordx4 v[152:155], v7, s[8:11], 0 offen
		v_mul_lo_u32 v7, s17, v11
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v11, s0, v7
		v_add3_u32 v11, v11, v44, v8
		v_add3_u32 v11, v11, v46, v48
		buffer_store_dwordx4 v[160:163], v11, s[8:11], 0 offen
		v_mul_lo_u32 v11, s17, v13
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v13, s0, v11
		v_add3_u32 v13, v13, v44, v8
		v_add3_u32 v13, v13, v46, v48
		buffer_store_dwordx4 v[156:159], v13, s[8:11], 0 offen
		v_xor_b32_e32 v13, v12, v15
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add_u32_e32 v15, s0, v13
		v_add3_u32 v15, v15, v44, v8
		v_add3_u32 v15, v15, v46, v48
		buffer_store_dwordx4 v[164:167], v15, s[8:11], 0 offen
		v_add_u32_e32 v15, 0x80, v38
		v_xor_b32_e32 v15, v15, v14
		v_xor_b32_e32 v15, v10, v15
		v_xor_b32_e32 v15, v12, v15
		v_mul_lo_u32 v15, s17, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add_u32_e32 v30, s0, v15
		v_add3_u32 v30, v30, v44, v8
		v_add3_u32 v30, v30, v46, v48
		buffer_store_dwordx4 v[168:171], v30, s[8:11], 0 offen
		v_add_u32_e32 v30, 0x90, v38
		v_xor_b32_e32 v30, v30, v14
		v_xor_b32_e32 v30, v10, v30
		v_xor_b32_e32 v30, v12, v30
		v_mul_lo_u32 v30, s17, v30
		v_lshlrev_b32_e32 v30, 1, v30
		v_add_u32_e32 v31, s0, v30
		v_add3_u32 v31, v31, v44, v8
		v_add3_u32 v31, v31, v46, v48
		buffer_store_dwordx4 v[176:179], v31, s[8:11], 0 offen
		v_add_u32_e32 v31, 0xa0, v38
		v_xor_b32_e32 v31, v31, v14
		v_xor_b32_e32 v31, v10, v31
		v_xor_b32_e32 v31, v12, v31
		v_mul_lo_u32 v31, s17, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add_u32_e32 v32, s0, v31
		v_add3_u32 v32, v32, v44, v8
		v_add3_u32 v32, v32, v46, v48
		buffer_store_dwordx4 v[172:175], v32, s[8:11], 0 offen
		v_add_u32_e32 v32, 0xb0, v38
		v_xor_b32_e32 v32, v32, v14
		v_xor_b32_e32 v32, v10, v32
		v_xor_b32_e32 v32, v12, v32
		v_mul_lo_u32 v32, s17, v32
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v33, s0, v32
		v_add3_u32 v33, v33, v44, v8
		v_add3_u32 v33, v33, v46, v48
		buffer_store_dwordx4 v[180:183], v33, s[8:11], 0 offen
		v_add_u32_e32 v33, 0xc0, v38
		v_xor_b32_e32 v33, v33, v14
		v_xor_b32_e32 v33, v10, v33
		v_xor_b32_e32 v33, v12, v33
		v_mul_lo_u32 v33, s17, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v36, s0, v33
		v_add3_u32 v36, v36, v44, v8
		v_add3_u32 v36, v36, v46, v48
		buffer_store_dwordx4 v[184:187], v36, s[8:11], 0 offen
		v_add_u32_e32 v36, 0xd0, v38
		v_xor_b32_e32 v36, v36, v14
		v_xor_b32_e32 v36, v10, v36
		v_xor_b32_e32 v36, v12, v36
		v_mul_lo_u32 v36, s17, v36
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v37, s0, v36
		v_add3_u32 v37, v37, v44, v8
		v_add3_u32 v37, v37, v46, v48
		buffer_store_dwordx4 v[192:195], v37, s[8:11], 0 offen
		v_add_u32_e32 v37, 0xe0, v38
		v_xor_b32_e32 v37, v37, v14
		v_xor_b32_e32 v37, v10, v37
		v_xor_b32_e32 v37, v12, v37
		v_mul_lo_u32 v37, s17, v37
		v_lshlrev_b32_e32 v37, 1, v37
		v_add_u32_e32 v39, s0, v37
		v_add3_u32 v39, v39, v44, v8
		v_add3_u32 v39, v39, v46, v48
		buffer_store_dwordx4 v[188:191], v39, s[8:11], 0 offen
		v_add_u32_e32 v38, 0xf0, v38
		v_xor_b32_e32 v14, v38, v14
		v_xor_b32_e32 v10, v10, v14
		v_xor_b32_e32 v10, v12, v10
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v12, s0, v10
		v_add3_u32 v12, v12, v44, v8
		v_add3_u32 v12, v12, v46, v48
		buffer_store_dwordx4 v[196:199], v12, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], v[52:55], a[128:131], v2, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[132:135], v[52:55], a[132:135], v2, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[132:135], v[60:63], a[148:151], v2, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], v[60:63], a[144:147], v2, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[128:131], v[56:59], a[128:131], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[136:139], v[56:59], a[132:135], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[136:139], v[68:71], a[148:151], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[128:131], v[68:71], a[144:147], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[140:143], v[52:55], a[136:139], v3, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[148:151], v[52:55], a[140:143], v3, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[148:151], v[60:63], a[156:159], v3, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[140:143], v[60:63], a[152:155], v3, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], v[56:59], a[136:139], v3, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[244:247], v[56:59], a[140:143], v3, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[244:247], v[68:71], a[156:159], v3, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], v[68:71], a[152:155], v3, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[140:143], v[80:83], a[168:171], v3, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[148:151], v[80:83], a[172:175], v3, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[148:151], v[88:91], a[188:191], v3, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[140:143], v[88:91], a[184:187], v3, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], v[84:87], a[168:171], v3, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[244:247], v[84:87], a[172:175], v3, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[244:247], v[92:95], a[188:191], v3, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], v[92:95], a[184:187], v3, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], v[80:83], a[160:163], v2, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[132:135], v[80:83], a[164:167], v2, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[132:135], v[88:91], a[180:183], v2, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[76:79], v[88:91], a[176:179], v2, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[128:131], v[84:87], a[160:163], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[136:139], v[84:87], a[164:167], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[136:139], v[92:95], a[180:183], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[128:131], v[92:95], a[176:179], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[76:79], v[96:99], a[192:195], v2, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[132:135], v[96:99], a[196:199], v2, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[132:135], v[104:107], a[212:215], v2, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[76:79], v[104:107], a[208:211], v2, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[128:131], v[100:103], a[192:195], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[136:139], v[100:103], a[196:199], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[136:139], v[108:111], a[212:215], v2, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[128:131], v[108:111], a[208:211], v2, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[140:143], v[96:99], a[200:203], v3, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[148:151], v[96:99], a[204:207], v3, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[148:151], v[104:107], a[220:223], v3, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[140:143], v[104:107], a[216:219], v3, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], v[100:103], a[200:203], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[244:247], v[100:103], a[204:207], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[244:247], v[108:111], a[220:223], v3, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], v[108:111], a[216:219], v3, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[140:143], v[112:115], a[232:235], v3, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[148:151], v[112:115], a[236:239], v3, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[148:151], v[120:123], a[252:255], v3, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[140:143], v[120:123], a[248:251], v3, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], v[116:119], a[232:235], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[244:247], v[116:119], a[236:239], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[244:247], v[124:127], a[252:255], v3, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], v[124:127], a[248:251], v3, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[76:79], v[112:115], a[224:227], v2, v35 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[132:135], v[112:115], a[228:231], v2, v35 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[132:135], v[120:123], a[244:247], v2, v35 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[76:79], v[120:123], a[240:243], v2, v35 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[128:131], v[116:119], a[224:227], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[136:139], v[116:119], a[228:231], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[136:139], v[124:127], a[244:247], v2, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[128:131], v[124:127], a[240:243], v2, v35 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a128
		v_accvgpr_read_b32 v3, a129
		v_cvt_pk_bf16_f32 v40, v2, v3
		v_accvgpr_read_b32 v2, a130
		v_accvgpr_read_b32 v3, a131
		v_cvt_pk_bf16_f32 v41, v2, v3
		v_accvgpr_read_b32 v2, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_bf16_f32 v52, v2, v3
		v_accvgpr_read_b32 v2, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_bf16_f32 v53, v2, v3
		v_accvgpr_read_b32 v2, a136
		v_accvgpr_read_b32 v3, a137
		v_cvt_pk_bf16_f32 v56, v2, v3
		v_accvgpr_read_b32 v2, a138
		v_accvgpr_read_b32 v3, a139
		v_cvt_pk_bf16_f32 v57, v2, v3
		v_accvgpr_read_b32 v2, a140
		v_accvgpr_read_b32 v3, a141
		v_cvt_pk_bf16_f32 v60, v2, v3
		v_accvgpr_read_b32 v2, a142
		v_accvgpr_read_b32 v3, a143
		v_cvt_pk_bf16_f32 v61, v2, v3
		v_accvgpr_read_b32 v2, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_bf16_f32 v42, v2, v3
		v_accvgpr_read_b32 v2, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_bf16_f32 v43, v2, v3
		v_accvgpr_read_b32 v2, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_bf16_f32 v54, v2, v3
		v_accvgpr_read_b32 v2, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_bf16_f32 v55, v2, v3
		v_accvgpr_read_b32 v2, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_bf16_f32 v58, v2, v3
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_bf16_f32 v59, v2, v3
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_bf16_f32 v62, v2, v3
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_bf16_f32 v63, v2, v3
		v_accvgpr_read_b32 v2, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_bf16_f32 v68, v2, v3
		v_accvgpr_read_b32 v2, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_bf16_f32 v69, v2, v3
		v_accvgpr_read_b32 v2, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_bf16_f32 v72, v2, v3
		v_accvgpr_read_b32 v2, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_bf16_f32 v73, v2, v3
		v_accvgpr_read_b32 v2, a168
		v_accvgpr_read_b32 v3, a169
		v_cvt_pk_bf16_f32 v76, v2, v3
		v_accvgpr_read_b32 v2, a170
		v_accvgpr_read_b32 v3, a171
		v_cvt_pk_bf16_f32 v77, v2, v3
		v_accvgpr_read_b32 v2, a172
		v_accvgpr_read_b32 v3, a173
		v_cvt_pk_bf16_f32 v80, v2, v3
		v_accvgpr_read_b32 v2, a174
		v_accvgpr_read_b32 v3, a175
		v_cvt_pk_bf16_f32 v81, v2, v3
		v_accvgpr_read_b32 v2, a176
		v_accvgpr_read_b32 v3, a177
		v_cvt_pk_bf16_f32 v70, v2, v3
		v_accvgpr_read_b32 v2, a178
		v_accvgpr_read_b32 v3, a179
		v_cvt_pk_bf16_f32 v71, v2, v3
		v_accvgpr_read_b32 v2, a180
		v_accvgpr_read_b32 v3, a181
		v_cvt_pk_bf16_f32 v74, v2, v3
		v_accvgpr_read_b32 v2, a182
		v_accvgpr_read_b32 v3, a183
		v_cvt_pk_bf16_f32 v75, v2, v3
		v_accvgpr_read_b32 v2, a184
		v_accvgpr_read_b32 v3, a185
		v_cvt_pk_bf16_f32 v78, v2, v3
		v_accvgpr_read_b32 v2, a186
		v_accvgpr_read_b32 v3, a187
		v_cvt_pk_bf16_f32 v79, v2, v3
		v_accvgpr_read_b32 v2, a188
		v_accvgpr_read_b32 v3, a189
		v_cvt_pk_bf16_f32 v82, v2, v3
		v_accvgpr_read_b32 v2, a190
		v_accvgpr_read_b32 v3, a191
		v_cvt_pk_bf16_f32 v83, v2, v3
		v_accvgpr_read_b32 v2, a192
		v_accvgpr_read_b32 v3, a193
		v_cvt_pk_bf16_f32 v84, v2, v3
		v_accvgpr_read_b32 v2, a194
		v_accvgpr_read_b32 v3, a195
		v_cvt_pk_bf16_f32 v85, v2, v3
		v_accvgpr_read_b32 v2, a196
		v_accvgpr_read_b32 v3, a197
		v_cvt_pk_bf16_f32 v88, v2, v3
		v_accvgpr_read_b32 v2, a198
		v_accvgpr_read_b32 v3, a199
		v_cvt_pk_bf16_f32 v89, v2, v3
		v_accvgpr_read_b32 v2, a200
		v_accvgpr_read_b32 v3, a201
		v_cvt_pk_bf16_f32 v92, v2, v3
		v_accvgpr_read_b32 v2, a202
		v_accvgpr_read_b32 v3, a203
		v_cvt_pk_bf16_f32 v93, v2, v3
		v_accvgpr_read_b32 v2, a204
		v_accvgpr_read_b32 v3, a205
		v_cvt_pk_bf16_f32 v96, v2, v3
		v_accvgpr_read_b32 v2, a206
		v_accvgpr_read_b32 v3, a207
		v_cvt_pk_bf16_f32 v97, v2, v3
		v_accvgpr_read_b32 v2, a208
		v_accvgpr_read_b32 v3, a209
		v_cvt_pk_bf16_f32 v86, v2, v3
		v_accvgpr_read_b32 v2, a210
		v_accvgpr_read_b32 v3, a211
		v_cvt_pk_bf16_f32 v87, v2, v3
		v_accvgpr_read_b32 v2, a212
		v_accvgpr_read_b32 v3, a213
		v_cvt_pk_bf16_f32 v90, v2, v3
		v_accvgpr_read_b32 v2, a214
		v_accvgpr_read_b32 v3, a215
		v_cvt_pk_bf16_f32 v91, v2, v3
		v_accvgpr_read_b32 v2, a216
		v_accvgpr_read_b32 v3, a217
		v_cvt_pk_bf16_f32 v94, v2, v3
		v_accvgpr_read_b32 v2, a218
		v_accvgpr_read_b32 v3, a219
		v_cvt_pk_bf16_f32 v95, v2, v3
		v_accvgpr_read_b32 v2, a220
		v_accvgpr_read_b32 v3, a221
		v_cvt_pk_bf16_f32 v98, v2, v3
		v_accvgpr_read_b32 v2, a222
		v_accvgpr_read_b32 v3, a223
		v_cvt_pk_bf16_f32 v99, v2, v3
		v_accvgpr_read_b32 v2, a224
		v_accvgpr_read_b32 v3, a225
		v_cvt_pk_bf16_f32 v100, v2, v3
		v_accvgpr_read_b32 v2, a226
		v_accvgpr_read_b32 v3, a227
		v_cvt_pk_bf16_f32 v101, v2, v3
		v_accvgpr_read_b32 v2, a228
		v_accvgpr_read_b32 v3, a229
		v_cvt_pk_bf16_f32 v104, v2, v3
		v_accvgpr_read_b32 v2, a230
		v_accvgpr_read_b32 v3, a231
		v_cvt_pk_bf16_f32 v105, v2, v3
		v_accvgpr_read_b32 v2, a232
		v_accvgpr_read_b32 v3, a233
		v_cvt_pk_bf16_f32 v108, v2, v3
		v_accvgpr_read_b32 v2, a234
		v_accvgpr_read_b32 v3, a235
		v_cvt_pk_bf16_f32 v109, v2, v3
		v_accvgpr_read_b32 v2, a236
		v_accvgpr_read_b32 v3, a237
		v_cvt_pk_bf16_f32 v112, v2, v3
		v_accvgpr_read_b32 v2, a238
		v_accvgpr_read_b32 v3, a239
		v_cvt_pk_bf16_f32 v113, v2, v3
		v_accvgpr_read_b32 v2, a240
		v_accvgpr_read_b32 v3, a241
		v_cvt_pk_bf16_f32 v102, v2, v3
		v_accvgpr_read_b32 v2, a242
		v_accvgpr_read_b32 v3, a243
		v_cvt_pk_bf16_f32 v103, v2, v3
		v_accvgpr_read_b32 v2, a244
		v_accvgpr_read_b32 v3, a245
		v_cvt_pk_bf16_f32 v106, v2, v3
		v_accvgpr_read_b32 v2, a246
		v_accvgpr_read_b32 v3, a247
		v_cvt_pk_bf16_f32 v107, v2, v3
		v_accvgpr_read_b32 v2, a248
		v_accvgpr_read_b32 v3, a249
		v_cvt_pk_bf16_f32 v110, v2, v3
		v_accvgpr_read_b32 v2, a250
		v_accvgpr_read_b32 v3, a251
		v_cvt_pk_bf16_f32 v111, v2, v3
		v_accvgpr_read_b32 v2, a252
		v_accvgpr_read_b32 v3, a253
		v_cvt_pk_bf16_f32 v114, v2, v3
		v_accvgpr_read_b32 v2, a254
		v_accvgpr_read_b32 v3, a255
		v_cvt_pk_bf16_f32 v115, v2, v3
		ds_write_b128 v9, v[40:43]
		ds_write_b128 v9, v[52:55] offset:4096
		ds_write_b128 v9, v[56:59] offset:8192
		ds_write_b128 v9, v[60:63] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v22, v65
		s_mov_b64 exec, s[2:3]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v3, s0, v18, v19
		v_add3_u32 v3, v3, v20, v21
		v_add3_u32 v3, v3, v44, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_27:
		ds_read_b32 v2, v22
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_27
.L_a4w4_kernel.loop_exit_27:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[16:19], v0
		ds_read_b128 v[40:43], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[52:53], v[16:17]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[54:55], v[40:41]
		v_mov_b64_e32 v[56:57], v[18:19]
		v_mov_b64_e32 v[58:59], v[42:43]
		ds_read_b128 v[16:19], v0 offset:2048
		ds_read_b128 v[40:43], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[60:61], v[16:17]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[62:63], v[40:41]
		v_mov_b64_e32 v[116:117], v[18:19]
		v_mov_b64_e32 v[118:119], v[42:43]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v2, v23, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v3, v3, v46, v48
		buffer_store_dwordx4 v[52:55], v3, s[8:11], 0 offen
		v_add3_u32 v3, v44, v8, v46
		v_add_u32_e32 v3, v3, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_28:
		ds_read_b32 v2, v23
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_28
.L_a4w4_kernel.loop_exit_28:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[68:71]
		ds_write_b128 v9, v[72:75] offset:4096
		ds_write_b128 v9, v[76:79] offset:8192
		ds_write_b128 v9, v[80:83] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v24, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, v1, v3, s0
		buffer_store_dwordx4 v[60:63], v1, s[8:11], 0 offen
		v_add3_u32 v1, v5, v3, s0
		buffer_store_dwordx4 v[56:59], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_29:
		ds_read_b32 v1, v24
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_29
.L_a4w4_kernel.loop_exit_29:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[16:19], v0
		ds_read_b128 v[20:23], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[40:41], v[16:17]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[42:43], v[20:21]
		v_mov_b64_e32 v[52:53], v[18:19]
		v_mov_b64_e32 v[54:55], v[22:23]
		ds_read_b128 v[16:19], v0 offset:2048
		ds_read_b128 v[20:23], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[56:57], v[16:17]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[58:59], v[20:21]
		v_mov_b64_e32 v[60:61], v[18:19]
		v_mov_b64_e32 v[62:63], v[22:23]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v25, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v2, v6, v3, s0
		buffer_store_dwordx4 v[116:119], v2, s[8:11], 0 offen
		v_add3_u32 v2, v44, v8, v46
		v_add_u32_e32 v2, v2, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_30:
		ds_read_b32 v1, v25
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_30
.L_a4w4_kernel.loop_exit_30:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[84:87]
		ds_write_b128 v9, v[88:91] offset:4096
		ds_write_b128 v9, v[92:95] offset:8192
		ds_write_b128 v9, v[96:99] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v26, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v3, v4, v2, s0
		buffer_store_dwordx4 v[40:43], v3, s[8:11], 0 offen
		v_add3_u32 v3, v7, v2, s0
		buffer_store_dwordx4 v[56:59], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_31:
		ds_read_b32 v1, v26
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_31
.L_a4w4_kernel.loop_exit_31:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[4:7], v0
		ds_read_b128 v[16:19], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[20:21], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[22:23], v[16:17]
		v_mov_b64_e32 v[40:41], v[6:7]
		v_mov_b64_e32 v[42:43], v[18:19]
		ds_read_b128 v[4:7], v0 offset:2048
		ds_read_b128 v[16:19], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[56:57], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[58:59], v[16:17]
		v_mov_b64_e32 v[68:69], v[6:7]
		v_mov_b64_e32 v[70:71], v[18:19]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v27, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v2, v11, v2, s0
		buffer_store_dwordx4 v[52:55], v2, s[8:11], 0 offen
		v_add3_u32 v2, v44, v8, v46
		v_add_u32_e32 v2, v2, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_32:
		ds_read_b32 v1, v27
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_32
.L_a4w4_kernel.loop_exit_32:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v9, v[100:103]
		ds_write_b128 v9, v[104:107] offset:4096
		ds_write_b128 v9, v[108:111] offset:8192
		ds_write_b128 v9, v[112:115] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v28, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v3, v13, v2, s0
		buffer_store_dwordx4 v[60:63], v3, s[8:11], 0 offen
		v_add3_u32 v3, v15, v2, s0
		buffer_store_dwordx4 v[20:23], v3, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_33:
		ds_read_b32 v1, v28
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_33
.L_a4w4_kernel.loop_exit_33:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[4:7], v0
		ds_read_b128 v[12:15], v0 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[20:21], v[6:7]
		v_mov_b64_e32 v[22:23], v[14:15]
		ds_read_b128 v[4:7], v0 offset:2048
		ds_read_b128 v[12:15], v0 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[24:25], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[26:27], v[12:13]
		v_mov_b64_e32 v[52:53], v[6:7]
		v_mov_b64_e32 v[54:55], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v0, v29, v65
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, v30, v2, s0
		buffer_store_dwordx4 v[56:59], v1, s[8:11], 0 offen
		v_add3_u32 v1, v44, v8, v46
		v_add_u32_e32 v1, v1, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v0
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_34:
		ds_read_b32 v0, v29
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v0
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_34
.L_a4w4_kernel.loop_exit_34:
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v0, v31, v1, s0
		buffer_store_dwordx4 v[40:43], v0, s[8:11], 0 offen
		v_add3_u32 v0, v32, v1, s0
		buffer_store_dwordx4 v[68:71], v0, s[8:11], 0 offen
		v_add3_u32 v0, v33, v1, s0
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v44, v8, v46
		v_add_u32_e32 v0, v0, v48
		v_add3_u32 v1, v36, v0, s0
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v1, v37, v0, s0
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		v_add3_u32 v0, v10, v0, s0
		buffer_store_dwordx4 v[52:55], v0, s[8:11], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 138184
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
		.amdhsa_next_free_vgpr 512
		.amdhsa_next_free_sgpr 59
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .L_a4w4_kernel.num_vgpr, 256
	.set .L_a4w4_kernel.num_agpr, 256
	.set .L_a4w4_kernel.numbered_sgpr, 59
	.set .L_a4w4_kernel.num_named_barrier, 0
	.set .L_a4w4_kernel.private_seg_size, 0
	.set .L_a4w4_kernel.uses_vcc, 0
	.set .L_a4w4_kernel.uses_flat_scratch, 0
	.set .L_a4w4_kernel.has_dyn_sized_stack, 0
	.set .L_a4w4_kernel.has_recursion, 0
	.set .L_a4w4_kernel.has_indirect_call, 0
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
    .group_segment_fixed_size: 138184
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     59
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 118
    wave.regalloc.agpr.dwords: 413
    wave.regalloc.remat.dwords: 11
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
