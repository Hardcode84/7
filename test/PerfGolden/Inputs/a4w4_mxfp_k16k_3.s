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
		v_mov_b32_e32 v18, 0x21b74
		ds_write_b32 v18, v4
		v_mov_b32_e32 v19, 0x21b78
		ds_write_b32 v19, v4
		v_mov_b32_e32 v20, 0x21b7c
		ds_write_b32 v20, v4
		v_mov_b32_e32 v21, 0x21b80
		ds_write_b32 v21, v4
		v_mov_b32_e32 v22, 0x21b84
		ds_write_b32 v22, v4
		v_mov_b32_e32 v23, 0x21b88
		ds_write_b32 v23, v4
		v_mov_b32_e32 v24, 0x21b8c
		ds_write_b32 v24, v4
		v_mov_b32_e32 v25, 0x21b90
		ds_write_b32 v25, v4
		v_mov_b32_e32 v26, 0x21b94
		ds_write_b32 v26, v4
		v_mov_b32_e32 v27, 0x21b98
		ds_write_b32 v27, v4
		v_mov_b32_e32 v28, 0x21b9c
		ds_write_b32 v28, v4
		v_mov_b32_e32 v29, 0x21ba0
		ds_write_b32 v29, v4
		v_mov_b32_e32 v30, 0x21ba4
		ds_write_b32 v30, v4
		v_mov_b32_e32 v31, 0x21ba8
		ds_write_b32 v31, v4
		v_mov_b32_e32 v32, 0x21bac
		ds_write_b32 v32, v4
		v_mov_b32_e32 v33, 0x21bb0
		ds_write_b32 v33, v4
		v_mov_b32_e32 v34, 0x21bb4
		ds_write_b32 v34, v4
		v_mov_b32_e32 v35, 0x21bb8
		ds_write_b32 v35, v4
		v_mov_b32_e32 v36, 0x21bbc
		ds_write_b32 v36, v4
		v_mov_b32_e32 v37, 0x21bc0
		ds_write_b32 v37, v4
		v_mov_b32_e32 v38, 0x21bc4
		ds_write_b32 v38, v4
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
		v_mov_b32_e32 v39, s22
		v_cvt_f32_u32_e32 v39, v39
		v_rcp_iflag_f32_e32 v39, v39
		v_mov_b32_e32 v40, 0x4f7ffffe
		v_mul_f32_e32 v39, v40, v39
		v_cvt_u32_f32_e32 v39, v39
		s_nop 0
		v_readfirstlane_b32 s23, v39
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
		v_mov_b32_e32 v39, s0
		v_cvt_f32_u32_e32 v39, v39
		v_rcp_iflag_f32_e32 v39, v39
		s_nop 0
		v_mul_f32_e32 v39, v40, v39
		v_cvt_u32_f32_e32 v39, v39
		s_nop 0
		v_readfirstlane_b32 s16, v39
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
		v_readfirstlane_b32 s23, v39
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
		v_lshrrev_b32_e32 v39, 7, v0
		v_mul_lo_u32 v40, s14, v39
		v_lshlrev_b32_e32 v40, 1, v40
		v_lshrrev_b32_e32 v41, 6, v0
		v_and_b32_e32 v41, 1, v41
		v_mul_lo_u32 v42, s14, v41
		v_add_u32_e32 v43, v40, v42
		v_lshrrev_b32_e32 v44, 5, v0
		v_and_b32_e32 v44, 1, v44
		v_mul_lo_u32 v45, s14, v44
		v_lshlrev_b32_e32 v45, 6, v45
		v_lshrrev_b32_e32 v46, 4, v0
		v_and_b32_e32 v47, 1, v46
		v_mul_lo_u32 v48, s14, v47
		v_lshlrev_b32_e32 v48, 5, v48
		v_add3_u32 v43, v43, v45, v48
		v_lshrrev_b32_e32 v49, 3, v0
		v_and_b32_e32 v49, 1, v49
		v_mul_lo_u32 v50, s14, v49
		v_lshlrev_b32_e32 v50, 4, v50
		v_and_b32_e32 v51, 1, v0
		v_lshlrev_b32_e32 v52, 4, v51
		v_add3_u32 v43, v43, v50, v52
		v_lshrrev_b32_e32 v53, 2, v0
		v_and_b32_e32 v53, 1, v53
		v_lshlrev_b32_e32 v54, 6, v53
		v_lshrrev_b32_e32 v55, 1, v0
		v_and_b32_e32 v55, 1, v55
		v_lshlrev_b32_e32 v56, 5, v55
		v_add3_u32 v43, v43, v54, v56
		s_lshr_b32 s23, s23, 6
		s_mul_i32 s23, 0x420, s23
		s_mov_b32 m0, s23
		s_mul_i32 s22, s22, s15
		buffer_load_dwordx4 v43, s[24:27], 0 offen lds
		s_lshl_b32 s36, s14, 2
		v_add3_u32 v57, s36, v40, v42
		v_add3_u32 v57, v57, v45, v48
		v_add3_u32 v57, v57, v50, v52
		v_add3_u32 v57, v57, v54, v56
		s_add_i32 m0, s23, 0x1080
		s_mov_b32 s37, 0
		buffer_load_dwordx4 v57, s[24:27], 0 offen lds
		s_lshl_b32 s38, s14, 3
		v_add3_u32 v58, v40, v42, v45
		v_add3_u32 v58, v58, v48, v50
		v_add3_u32 v58, v58, v52, v54
		s_add_i32 m0, s23, 0x2100
		v_add3_u32 v59, v56, v58, s38
		buffer_load_dwordx4 v59, s[24:27], 0 offen lds
		s_mul_i32 s39, 12, s14
		s_add_i32 m0, s23, 0x3180
		v_add3_u32 v60, v56, v58, s39
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		s_lshl_b32 s40, s14, 7
		s_add_i32 m0, s23, 0x4200
		v_add3_u32 v58, v56, v58, s40
		buffer_load_dwordx4 v58, s[24:27], 0 offen lds
		s_mul_i32 s41, 0x84, s14
		v_add3_u32 v61, v40, v42, v45
		v_add3_u32 v61, v61, v48, v50
		v_add3_u32 v61, v61, v52, v54
		s_add_i32 m0, s23, 0x5280
		v_add3_u32 v62, v56, v61, s41
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		s_mul_i32 s42, 0x88, s14
		s_add_i32 m0, s23, 0x6300
		v_add3_u32 v63, v56, v61, s42
		buffer_load_dwordx4 v63, s[24:27], 0 offen lds
		s_mul_i32 s14, 0x8c, s14
		s_add_i32 m0, s23, 0x7380
		v_add3_u32 v61, v56, v61, s14
		s_add_u32 s44, s4, s22
		s_addc_u32 s45, s5, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		v_mul_lo_u32 v64, s15, v39
		v_lshlrev_b32_e32 v64, 1, v64
		v_mul_lo_u32 v65, s15, v41
		v_add_u32_e32 v66, v64, v65
		v_mul_lo_u32 v67, s15, v44
		v_lshlrev_b32_e32 v67, 6, v67
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		v_mul_lo_u32 v68, s15, v47
		v_lshlrev_b32_e32 v68, 5, v68
		v_add3_u32 v66, v66, v67, v68
		v_mul_lo_u32 v69, s15, v49
		v_lshlrev_b32_e32 v69, 4, v69
		v_add3_u32 v66, v66, v69, v52
		s_add_i32 m0, s23, 0x107c0
		v_add3_u32 v66, v66, v54, v56
		buffer_load_dwordx4 v66, s[44:47], 0 offen lds
		s_lshl_b32 s43, s15, 2
		v_add3_u32 v70, v64, v65, v67
		v_add3_u32 v70, v70, v68, v69
		v_add3_u32 v70, v70, v52, v54
		s_add_i32 m0, s23, 0x11840
		v_add3_u32 v71, v56, v70, s43
		buffer_load_dwordx4 v71, s[44:47], 0 offen lds
		s_lshl_b32 s48, s15, 3
		s_add_i32 m0, s23, 0x128c0
		v_add3_u32 v72, v56, v70, s48
		buffer_load_dwordx4 v72, s[44:47], 0 offen lds
		s_mul_i32 s49, 12, s15
		s_add_i32 m0, s23, 0x13940
		v_add3_u32 v70, v56, v70, s49
		buffer_load_dwordx4 v70, s[44:47], 0 offen lds
		v_mov_b32_e32 v73, 1
		s_and_saveexec_b64 s[50:51], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v74, v1, v73
		s_mov_b64 exec, s[50:51]
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s16, s16, 8
		s_add_i32 s1, s1, s16
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v75, s20, v39
		v_lshlrev_b32_e32 v75, 2, v75
		v_mul_lo_u32 v76, s20, v41
		v_lshlrev_b32_e32 v76, 1, v76
		v_add3_u32 v77, s1, v75, v76
		v_mul_lo_u32 v78, s20, v44
		v_lshlrev_b32_e32 v79, 3, v51
		v_add3_u32 v77, v77, v78, v79
		v_lshlrev_b32_e32 v80, 7, v47
		v_lshlrev_b32_e32 v81, 6, v49
		v_add3_u32 v77, v77, v80, v81
		v_lshlrev_b32_e32 v82, 5, v53
		v_lshlrev_b32_e32 v83, 4, v55
		v_add3_u32 v77, v77, v82, v83
		buffer_load_dwordx2 v[84:85], v77, s[28:31], 0 offen
		s_lshl_b32 s16, s0, 8
		v_mul_lo_u32 v86, s21, v39
		v_lshlrev_b32_e32 v86, 2, v86
		v_mul_lo_u32 v87, s21, v41
		v_lshlrev_b32_e32 v87, 1, v87
		v_add3_u32 v88, s16, v86, v87
		v_mul_lo_u32 v89, s21, v44
		v_lshlrev_b32_e32 v90, 2, v51
		v_add3_u32 v88, v88, v89, v90
		v_lshlrev_b32_e32 v91, 6, v47
		v_lshlrev_b32_e32 v92, 5, v49
		v_add3_u32 v88, v88, v91, v92
		v_lshlrev_b32_e32 v93, 4, v53
		v_lshlrev_b32_e32 v94, 3, v55
		v_add3_u32 v88, v88, v93, v94
		buffer_load_dword v95, v88, s[32:35], 0 offen
		s_lshl_b32 s50, s15, 7
		v_add3_u32 v96, s50, v64, v65
		v_add3_u32 v96, v96, v67, v68
		v_add3_u32 v96, v96, v69, v52
		s_add_i32 m0, s23, 0x18b80
		v_add3_u32 v96, v96, v54, v56
		buffer_load_dwordx4 v96, s[44:47], 0 offen lds
		s_mul_i32 s51, 0x84, s15
		v_add3_u32 v97, v64, v65, v67
		v_add3_u32 v97, v97, v68, v69
		v_add3_u32 v97, v97, v52, v54
		s_add_i32 m0, s23, 0x19c00
		v_add3_u32 v98, v56, v97, s51
		buffer_load_dwordx4 v98, s[44:47], 0 offen lds
		s_mul_i32 s52, 0x88, s15
		s_add_i32 m0, s23, 0x1ac80
		v_add3_u32 v99, v56, v97, s52
		buffer_load_dwordx4 v99, s[44:47], 0 offen lds
		s_mul_i32 s15, 0x8c, s15
		s_add_i32 m0, s23, 0x1bd00
		v_add3_u32 v97, v56, v97, s15
		buffer_load_dwordx4 v97, s[44:47], 0 offen lds
		s_add_i32 s53, s16, 0x80
		v_add3_u32 v100, s53, v86, v87
		v_add3_u32 v100, v100, v89, v90
		v_add3_u32 v100, v100, v91, v92
		v_add3_u32 v100, v100, v93, v94
		buffer_load_dword v101, v100, s[32:35], 0 offen
		v_add_u32_e32 v102, 0x80, v40
		v_add_u32_e32 v102, v102, v42
		v_add3_u32 v102, v102, v45, v48
		v_add3_u32 v102, v102, v50, v52
		s_add_i32 m0, s23, 0x83e0
		v_add3_u32 v102, v102, v54, v56
		buffer_load_dwordx4 v102, s[24:27], 0 offen lds
		s_add_i32 s36, s36, 0x80
		v_add3_u32 v103, s36, v40, v42
		v_add3_u32 v103, v103, v45, v48
		v_add3_u32 v103, v103, v50, v52
		s_add_i32 m0, s23, 0x9460
		v_add3_u32 v103, v103, v54, v56
		buffer_load_dwordx4 v103, s[24:27], 0 offen lds
		s_add_i32 s36, s38, 0x80
		v_add3_u32 v104, s36, v40, v42
		v_add3_u32 v104, v104, v45, v48
		v_add3_u32 v104, v104, v50, v52
		s_add_i32 m0, s23, 0xa4e0
		v_add3_u32 v104, v104, v54, v56
		buffer_load_dwordx4 v104, s[24:27], 0 offen lds
		s_add_i32 s36, s39, 0x80
		v_add3_u32 v105, s36, v40, v42
		v_add3_u32 v105, v105, v45, v48
		v_add3_u32 v105, v105, v50, v52
		s_add_i32 m0, s23, 0xb560
		v_add3_u32 v105, v105, v54, v56
		buffer_load_dwordx4 v105, s[24:27], 0 offen lds
		s_add_i32 s36, s40, 0x80
		v_add3_u32 v106, s36, v40, v42
		v_add3_u32 v106, v106, v45, v48
		v_add3_u32 v106, v106, v50, v52
		s_add_i32 m0, s23, 0xc5e0
		v_add3_u32 v106, v106, v54, v56
		buffer_load_dwordx4 v106, s[24:27], 0 offen lds
		s_add_i32 s36, s41, 0x80
		v_add3_u32 v107, s36, v40, v42
		v_add3_u32 v107, v107, v45, v48
		v_add3_u32 v107, v107, v50, v52
		s_add_i32 m0, s23, 0xd660
		v_add3_u32 v107, v107, v54, v56
		buffer_load_dwordx4 v107, s[24:27], 0 offen lds
		s_add_i32 s36, s42, 0x80
		v_add3_u32 v108, s36, v40, v42
		v_add3_u32 v108, v108, v45, v48
		v_add3_u32 v108, v108, v50, v52
		s_add_i32 m0, s23, 0xe6e0
		v_add3_u32 v108, v108, v54, v56
		buffer_load_dwordx4 v108, s[24:27], 0 offen lds
		s_add_i32 s14, s14, 0x80
		v_add3_u32 v40, s14, v40, v42
		v_add3_u32 v40, v40, v45, v48
		v_add3_u32 v40, v40, v50, v52
		s_add_i32 m0, s23, 0xf760
		v_add3_u32 v40, v40, v54, v56
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		v_add_u32_e32 v42, 0x80, v64
		v_add_u32_e32 v42, v42, v65
		v_add3_u32 v42, v42, v67, v68
		v_add3_u32 v42, v42, v69, v52
		s_add_i32 m0, s23, 0x149a0
		v_add3_u32 v42, v42, v54, v56
		buffer_load_dwordx4 v42, s[44:47], 0 offen lds
		s_add_i32 s14, s43, 0x80
		v_add3_u32 v45, v64, v65, v67
		v_add3_u32 v45, v45, v68, v69
		v_add3_u32 v45, v45, v52, v54
		s_add_i32 m0, s23, 0x15a20
		v_add3_u32 v48, v56, v45, s14
		buffer_load_dwordx4 v48, s[44:47], 0 offen lds
		s_add_i32 s14, s48, 0x80
		s_add_i32 m0, s23, 0x16aa0
		v_add3_u32 v50, v56, v45, s14
		buffer_load_dwordx4 v50, s[44:47], 0 offen lds
		s_add_i32 s14, s49, 0x80
		s_add_i32 m0, s23, 0x17b20
		v_add3_u32 v45, v56, v45, s14
		s_lshl_b32 s14, s20, 3
		s_add_i32 s1, s1, s14
		buffer_load_dwordx4 v45, s[44:47], 0 offen lds
		v_add3_u32 v75, s1, v75, v76
		v_add3_u32 v75, v75, v78, v79
		v_add3_u32 v75, v75, v80, v81
		v_add3_u32 v75, v75, v82, v83
		buffer_load_dwordx2 v[110:111], v75, s[28:31], 0 offen
		s_lshl_b32 s1, s21, 3
		s_add_i32 s14, s16, s1
		v_add3_u32 v76, s14, v86, v87
		v_add3_u32 v76, v76, v89, v90
		v_add3_u32 v76, v76, v91, v92
		v_add3_u32 v76, v76, v93, v94
		buffer_load_dword v78, v76, s[32:35], 0 offen
		s_add_i32 s14, s50, 0x80
		v_add3_u32 v83, s14, v64, v65
		v_add3_u32 v83, v83, v67, v68
		v_add3_u32 v83, v83, v69, v52
		s_add_i32 m0, s23, 0x1cd60
		v_add3_u32 v83, v83, v54, v56
		s_waitcnt vmcnt(15)
		buffer_load_dwordx4 v83, s[44:47], 0 offen lds
		s_add_i32 s14, s51, 0x80
		v_add3_u32 v64, v64, v65, v67
		v_add3_u32 v64, v64, v68, v69
		v_add3_u32 v64, v64, v52, v54
		s_add_i32 m0, s23, 0x1dde0
		v_add3_u32 v65, v56, v64, s14
		buffer_load_dwordx4 v65, s[44:47], 0 offen lds
		s_add_i32 s14, s52, 0x80
		s_add_i32 m0, s23, 0x1ee60
		v_add3_u32 v67, v56, v64, s14
		buffer_load_dwordx4 v67, s[44:47], 0 offen lds
		s_add_i32 s14, s15, 0x80
		s_add_i32 m0, s23, 0x1fee0
		v_add3_u32 v64, v56, v64, s14
		buffer_load_dwordx4 v64, s[44:47], 0 offen lds
		s_add_i32 s1, s53, s1
		v_add3_u32 v68, s1, v86, v87
		v_add3_u32 v68, v68, v89, v90
		v_add3_u32 v68, v68, v91, v92
		v_add3_u32 v68, v68, v93, v94
		buffer_load_dword v69, v68, s[32:35], 0 offen
		s_add_i32 s1, s13, 0x100
		s_add_i32 s13, s22, 0x100
		s_mul_i32 s14, s20, 16
		s_mul_i32 s15, s21, 16
		v_readfirstlane_b32 s16, v74
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_0:
		ds_read_b32 v74, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v74
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v1, 7, v39
		v_and_b32_e32 v74, 63, v0
		v_lshrrev_b32_e32 v86, 4, v74
		v_lshlrev_b32_e32 v86, 4, v86
		v_and_b32_e32 v74, 15, v74
		v_mov_b32_e32 v87, 0x420
		v_mul_lo_u32 v87, v87, v74
		v_add3_u32 v1, v1, v86, v87
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
		v_add_u32_e32 v74, 0x10000, v86
		v_lshlrev_b32_e32 v86, 7, v41
		v_add3_u32 v74, v74, v86, v87
		ds_read_b128 a[64:67], v74 offset:1984
		ds_read_b128 a[68:71], v74 offset:2048
		ds_read_b128 a[72:75], v74 offset:2240
		ds_read_b128 a[76:79], v74 offset:2304
		ds_read_b128 a[80:83], v74 offset:2496
		ds_read_b128 a[84:87], v74 offset:2560
		ds_read_b128 a[88:91], v74 offset:2752
		ds_read_b128 a[92:95], v74 offset:2816
		v_lshlrev_b32_e32 v86, 3, v0
		v_add_u32_e32 v86, 0x20000, v86
		ds_write_b64 v86, v[84:85] offset:3904
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v84, v2, v73
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v85, 2, v0
		v_add_u32_e32 v85, 0x20000, v85
		ds_write_b32 v85, v95 offset:5952
		s_and_saveexec_b64 s[20:21], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v87, v3, v73
		s_mov_b64 exec, s[20:21]
		v_readfirstlane_b32 s16, v84
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_1:
		ds_read_b32 v84, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v84
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_1
.L_a4w4_kernel.loop_exit_1:
		s_mov_b64 exec, s[20:21]
		v_lshlrev_b32_e32 v2, 4, v39
		v_add_u32_e32 v2, 0x20000, v2
		v_add_u32_e32 v2, v2, v79
		v_readfirstlane_b32 s16, v87
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[20:21], s[18:19]
.L_a4w4_kernel.loop_head_2:
		ds_read_b32 v84, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v84
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s22, s22, s24
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_2
.L_a4w4_kernel.loop_exit_2:
		s_mov_b64 exec, s[20:21]
		v_lshl_add_u32 v2, v44, 9, v2
		v_lshlrev_b32_e32 v3, 8, v47
		v_add3_u32 v2, v2, v3, v81
		v_lshlrev_b32_e32 v3, 10, v55
		v_add3_u32 v2, v2, v82, v3
		ds_read_b64_tr_b8 v[90:91], v2 offset:3904
		ds_read_b64_tr_b8 v[92:93], v2 offset:4032
		v_add_u32_e32 v79, 0x20000, v79
		v_lshl_add_u32 v79, v41, 4, v79
		v_lshlrev_b32_e32 v84, 8, v44
		v_add3_u32 v79, v79, v84, v80
		v_add3_u32 v79, v79, v81, v82
		v_lshl_add_u32 v55, v55, 9, v79
		ds_read_b64_tr_b8 v[80:81], v55 offset:5952
		s_mov_b32 s16, s14
		s_mov_b32 s20, s15
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_add_u32 s40, s8, s16
		s_addc_u32 s41, s9, 0
		s_mov_b32 s42, s26
		s_mov_b32 s43, s27
		s_add_u32 s44, s10, s20
		s_addc_u32 s45, s11, 0
		s_mov_b32 s46, s26
		s_mov_b32 s47, s27
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
.L_a4w4_kernel.loop_head_3:
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt vmcnt(20)
		ds_add_rtn_u32 v79, v8, v73
		s_mov_b64 exec, s[24:25]
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt vmcnt(7)
		ds_add_rtn_u32 v82, v10, v73
		s_mov_b64 exec, s[24:25]
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt vmcnt(1)
		ds_add_rtn_u32 v84, v13, v73
		s_mov_b64 exec, s[24:25]
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v80, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v80, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[8:11], v[120:123], v80, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[8:11], v[116:119], v80, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[12:15], v[120:123], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[12:15], v[116:119], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v81, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[0:3], v[112:115], v81, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v81, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[8:11], v[124:127], v81, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[4:7], v[112:115], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[12:15], v[128:131], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[12:15], v[124:127], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v81, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v81, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v81, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v81, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[20:23], v[140:143], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[20:23], v[144:147], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[28:31], v[160:163], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[28:31], v[156:159], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[16:19], v[132:135], v80, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v80, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v80, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[24:27], v[148:151], v80, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[20:23], v[132:135], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[20:23], v[136:139], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[28:31], v[152:155], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[28:31], v[148:151], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[32:35], v[164:167], v80, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v80, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v80, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[40:43], v[180:183], v80, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[36:39], v[164:167], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[36:39], v[168:171], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[44:47], v[184:187], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[44:47], v[180:183], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v81, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v81, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v81, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v81, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[36:39], v[172:175], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[36:39], v[176:179], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[44:47], v[192:195], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[44:47], v[188:191], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v81, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v81, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v81, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v81, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[52:55], v[204:207], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[52:55], v[208:211], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[60:63], v[224:227], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[60:63], v[220:223], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[48:51], v[196:199], v80, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v80, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v80, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[56:59], v[212:215], v80, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[52:55], v[196:199], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[52:55], v[200:203], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[60:63], v[216:219], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[60:63], v[212:215], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_readfirstlane_b32 s21, v79
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_4:
		ds_read_b32 v79, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v79
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_4
.L_a4w4_kernel.loop_exit_4:
		s_mov_b64 exec, s[24:25]
		ds_read_b128 a[64:67], v74 offset:35712
		ds_read_b128 a[68:71], v74 offset:35776
		ds_read_b128 a[72:75], v74 offset:35968
		ds_read_b128 a[76:79], v74 offset:36032
		ds_read_b128 a[80:83], v74 offset:36224
		ds_read_b128 a[84:87], v74 offset:36288
		ds_read_b128 a[88:91], v74 offset:36480
		ds_read_b128 v[252:255], v74 offset:36544
		ds_write_b32 v85, v101 offset:5952
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v79, v9, v73
		s_mov_b64 exec, s[24:25]
		s_add_u32 s28, s2, s1
		s_addc_u32 s29, s3, 0
		s_mov_b32 m0, s23
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v79
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_5:
		ds_read_b32 v79, v9
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v79
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_5
.L_a4w4_kernel.loop_exit_5:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[80:81], v55 offset:5952
		buffer_load_dwordx4 v43, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x1080
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[0:3], v[228:231], v80, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v57, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x2100
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[0:3], v[232:235], v80, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x3180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[8:11], a[100:103], v80, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x4200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[8:11], v[244:247], v80, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v58, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x5280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[4:7], v[228:231], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v62, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x6300
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[4:7], v[232:235], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v63, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x7380
		s_add_u32 s32, s4, s13
		s_addc_u32 s33, s5, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[12:15], a[100:103], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[12:15], v[244:247], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[0:3], v[236:239], v81, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[0:3], v[240:243], v81, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[8:11], a[108:111], v81, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[8:11], a[104:107], v81, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[4:7], v[236:239], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[4:7], v[240:243], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[12:15], a[108:111], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[12:15], a[104:107], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[16:19], a[120:123], v81, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[16:19], a[124:127], v81, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[24:27], a[140:143], v81, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[24:27], a[136:139], v81, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[20:23], a[120:123], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[20:23], a[124:127], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[28:31], a[140:143], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[28:31], a[136:139], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[16:19], a[112:115], v80, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[16:19], a[116:119], v80, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[24:27], a[132:135], v80, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[24:27], a[128:131], v80, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[20:23], a[112:115], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[20:23], a[116:119], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v61, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x107c0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[28:31], a[132:135], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v66, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x11840
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[28:31], a[128:131], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v71, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x128c0
		s_add_u32 s44, s10, s20
		s_addc_u32 s45, s11, 0
		buffer_load_dwordx4 v72, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x13940
		s_add_u32 s40, s8, s16
		s_addc_u32 s41, s9, 0
		buffer_load_dwordx4 v70, s[32:35], 0 offen lds
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v79, v15, v73
		s_mov_b64 exec, s[24:25]
		buffer_load_dwordx2 v[90:91], v77, s[40:43], 0 offen
		buffer_load_dword v87, v88, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[32:35], a[144:147], v80, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[32:35], a[148:151], v80, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[40:43], a[164:167], v80, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[40:43], a[160:163], v80, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[36:39], a[144:147], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[36:39], a[148:151], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[44:47], a[164:167], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[44:47], a[160:163], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[32:35], a[152:155], v81, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[32:35], a[156:159], v81, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[40:43], a[172:175], v81, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[40:43], a[168:171], v81, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[36:39], a[152:155], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[36:39], a[156:159], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[44:47], a[172:175], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[44:47], a[168:171], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[48:51], a[184:187], v81, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[48:51], a[188:191], v81, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[56:59], a[204:207], v81, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[56:59], a[200:203], v81, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[52:55], a[184:187], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[52:55], a[188:191], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[60:63], a[204:207], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[60:63], a[200:203], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[48:51], a[176:179], v80, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[48:51], a[180:183], v80, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[56:59], a[196:199], v80, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[56:59], a[192:195], v80, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[52:55], a[176:179], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[52:55], a[180:183], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[60:63], a[196:199], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[60:63], a[192:195], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s21, v82
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_6:
		ds_read_b32 v80, v10
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v80
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_6
.L_a4w4_kernel.loop_exit_6:
		s_mov_b64 exec, s[24:25]
		ds_read_b128 a[0:3], v1 offset:33760
		ds_read_b128 a[4:7], v1 offset:33824
		ds_read_b128 a[8:11], v1 offset:34016
		ds_read_b128 a[12:15], v1 offset:34080
		ds_read_b128 a[16:19], v1 offset:34272
		ds_read_b128 a[20:23], v1 offset:34336
		ds_read_b128 a[24:27], v1 offset:34528
		ds_read_b128 a[28:31], v1 offset:34592
		ds_read_b128 a[32:35], v1 offset:50656
		ds_read_b128 a[36:39], v1 offset:50720
		ds_read_b128 a[40:43], v1 offset:50912
		ds_read_b128 a[44:47], v1 offset:50976
		ds_read_b128 a[48:51], v1 offset:51168
		ds_read_b128 a[52:55], v1 offset:51232
		ds_read_b128 a[56:59], v1 offset:51424
		ds_read_b128 a[60:63], v1 offset:51488
		ds_read_b128 a[64:67], v74 offset:18848
		ds_read_b128 a[68:71], v74 offset:18912
		ds_read_b128 a[72:75], v74 offset:19104
		ds_read_b128 a[76:79], v74 offset:19168
		ds_read_b128 a[80:83], v74 offset:19360
		ds_read_b128 a[84:87], v74 offset:19424
		ds_read_b128 v[92:95], v74 offset:19616
		ds_read_b128 a[88:91], v74 offset:19680
		ds_write_b64 v86, v[110:111] offset:3904
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v80, v11, v73
		s_mov_b64 exec, s[24:25]
		ds_write_b32 v85, v78 offset:5952
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v78, v12, v73
		s_mov_b64 exec, s[24:25]
		s_add_i32 m0, s23, 0x18b80
		v_readfirstlane_b32 s21, v80
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_7:
		ds_read_b32 v80, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v80
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_7
.L_a4w4_kernel.loop_exit_7:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[80:81], v2 offset:3904
		v_readfirstlane_b32 s21, v78
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_8:
		ds_read_b32 v78, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v78
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_8
.L_a4w4_kernel.loop_exit_8:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[252:253], v2 offset:4032
		ds_read_b64_tr_b8 v[110:111], v55 offset:5952
		buffer_load_dwordx4 v96, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x19c00
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v110, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v98, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1ac80
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v110, v80 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v99, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1bd00
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[8:11], v[120:123], v110, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v97, s[32:35], 0 offen lds
		buffer_load_dword v101, v100, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[8:11], v[116:119], v110, v80 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v110, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v110, v80 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[12:15], v[120:123], v110, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[12:15], v[116:119], v110, v80 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v111, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[92:95], a[0:3], v[112:115], v111, v80 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[92:95], a[8:11], v[128:131], v111, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[8:11], v[124:127], v111, v80 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v111, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[4:7], v[112:115], v111, v80 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[12:15], v[128:131], v111, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[12:15], v[124:127], v111, v80 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v111, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[92:95], a[16:19], v[144:147], v111, v81 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[92:95], a[24:27], v[160:163], v111, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v111, v81 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[20:23], v[140:143], v111, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[20:23], v[144:147], v111, v81 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[28:31], v[160:163], v111, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[28:31], v[156:159], v111, v81 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[16:19], v[132:135], v110, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v110, v81 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v110, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[24:27], v[148:151], v110, v81 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[20:23], v[132:135], v110, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[20:23], v[136:139], v110, v81 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[28:31], v[152:155], v110, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[28:31], v[148:151], v110, v81 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[32:35], v[164:167], v110, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v110, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v110, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[40:43], v[180:183], v110, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[36:39], v[164:167], v110, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[36:39], v[168:171], v110, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[44:47], v[184:187], v110, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[44:47], v[180:183], v110, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v111, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[92:95], a[32:35], v[176:179], v111, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], a[40:43], v[192:195], v111, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v111, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[36:39], v[172:175], v111, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[36:39], v[176:179], v111, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[44:47], v[192:195], v111, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[44:47], v[188:191], v111, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v111, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], a[48:51], v[208:211], v111, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[92:95], a[56:59], v[224:227], v111, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v111, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[52:55], v[204:207], v111, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[52:55], v[208:211], v111, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[60:63], v[224:227], v111, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[60:63], v[220:223], v111, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[48:51], v[196:199], v110, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v110, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v110, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[56:59], v[212:215], v110, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[52:55], v[196:199], v110, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[52:55], v[200:203], v110, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[60:63], v[216:219], v110, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[60:63], v[212:215], v110, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s21, v84
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_9:
		ds_read_b32 v78, v13
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v78
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_9
.L_a4w4_kernel.loop_exit_9:
		s_mov_b64 exec, s[24:25]
		ds_read_b128 a[64:67], v74 offset:52576
		ds_read_b128 a[68:71], v74 offset:52640
		ds_read_b128 a[72:75], v74 offset:52832
		ds_read_b128 a[76:79], v74 offset:52896
		ds_read_b128 a[80:83], v74 offset:53088
		ds_read_b128 a[84:87], v74 offset:53152
		ds_read_b128 a[88:91], v74 offset:53344
		ds_read_b128 v[92:95], v74 offset:53408
		ds_write_b32 v85, v69 offset:5952
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v69, v14, v73
		s_mov_b64 exec, s[24:25]
		s_add_i32 m0, s23, 0x83e0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v69
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_10:
		ds_read_b32 v69, v14
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v69
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_10
.L_a4w4_kernel.loop_exit_10:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[254:255], v55 offset:5952
		buffer_load_dwordx4 v102, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x9460
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[0:3], v[228:231], v254, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v103, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xa4e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[0:3], v[232:235], v254, v80 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v104, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xb560
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[72:75], a[8:11], a[100:103], v254, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v105, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xc5e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], a[8:11], v[244:247], v254, v80 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v106, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xd660
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[68:71], a[4:7], v[228:231], v254, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v107, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xe6e0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[76:79], a[4:7], v[232:235], v254, v80 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v108, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0xf760
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[76:79], a[12:15], a[100:103], v254, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[68:71], a[12:15], v[244:247], v254, v80 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[80:83], a[0:3], v[236:239], v255, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[88:91], a[0:3], v[240:243], v255, v80 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[88:91], a[8:11], a[108:111], v255, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[80:83], a[8:11], a[104:107], v255, v80 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[84:87], a[4:7], v[236:239], v255, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[92:95], a[4:7], v[240:243], v255, v80 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], a[12:15], a[108:111], v255, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[84:87], a[12:15], a[104:107], v255, v80 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[80:83], a[16:19], a[120:123], v255, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[88:91], a[16:19], a[124:127], v255, v81 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[88:91], a[24:27], a[140:143], v255, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[80:83], a[24:27], a[136:139], v255, v81 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[84:87], a[20:23], a[120:123], v255, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], a[20:23], a[124:127], v255, v81 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], a[28:31], a[140:143], v255, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[84:87], a[28:31], a[136:139], v255, v81 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[64:67], a[16:19], a[112:115], v254, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[72:75], a[16:19], a[116:119], v254, v81 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[72:75], a[24:27], a[132:135], v254, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[64:67], a[24:27], a[128:131], v254, v81 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[68:71], a[20:23], a[112:115], v254, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[76:79], a[20:23], a[116:119], v254, v81 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], a[28:31], a[132:135], v254, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_add_i32 m0, s23, 0x149a0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[68:71], a[28:31], a[128:131], v254, v81 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x15a20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[64:67], a[32:35], a[144:147], v254, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v48, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x16aa0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[72:75], a[32:35], a[148:151], v254, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v50, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x17b20
		s_add_i32 s37, s37, 2
		buffer_load_dwordx4 v45, s[32:35], 0 offen lds
		buffer_load_dwordx2 v[110:111], v75, s[40:43], 0 offen
		buffer_load_dword v78, v76, s[44:47], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[72:75], a[40:43], a[164:167], v254, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[64:67], a[40:43], a[160:163], v254, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[68:71], a[36:39], a[144:147], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[36:39], a[148:151], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[76:79], a[44:47], a[164:167], v254, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[44:47], a[160:163], v254, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[32:35], a[152:155], v255, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[88:91], a[32:35], a[156:159], v255, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[40:43], a[172:175], v255, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[80:83], a[40:43], a[168:171], v255, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[84:87], a[36:39], a[152:155], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], a[36:39], a[156:159], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], a[44:47], a[172:175], v255, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[44:47], a[168:171], v255, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[80:83], a[48:51], a[184:187], v255, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[48:51], a[188:191], v255, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[88:91], a[56:59], a[204:207], v255, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[80:83], a[56:59], a[200:203], v255, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[84:87], a[52:55], a[184:187], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[92:95], a[52:55], a[188:191], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[92:95], a[60:63], a[204:207], v255, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[84:87], a[60:63], a[200:203], v255, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[48:51], a[176:179], v254, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[72:75], a[48:51], a[180:183], v254, v253 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[72:75], a[56:59], a[196:199], v254, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[56:59], a[192:195], v254, v253 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[52:55], a[176:179], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[76:79], a[52:55], a[180:183], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[76:79], a[60:63], a[196:199], v254, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[60:63], a[192:195], v254, v253 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s21, v79
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_11:
		ds_read_b32 v69, v15
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v69
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_11
.L_a4w4_kernel.loop_exit_11:
		s_mov_b64 exec, s[24:25]
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
		ds_read_b128 a[64:67], v74 offset:1984
		ds_read_b128 a[68:71], v74 offset:2048
		ds_read_b128 a[72:75], v74 offset:2240
		ds_read_b128 a[76:79], v74 offset:2304
		ds_read_b128 a[80:83], v74 offset:2496
		ds_read_b128 a[84:87], v74 offset:2560
		ds_read_b128 a[88:91], v74 offset:2752
		ds_read_b128 a[92:95], v74 offset:2816
		s_waitcnt vmcnt(20)
		ds_write_b64 v86, v[90:91] offset:3904
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v69, v16, v73
		s_mov_b64 exec, s[24:25]
		s_waitcnt vmcnt(19)
		ds_write_b32 v85, v87 offset:5952
		s_and_saveexec_b64 s[24:25], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v79, v17, v73
		s_mov_b64 exec, s[24:25]
		s_add_i32 m0, s23, 0x1cd60
		s_add_i32 s20, s20, s15
		v_readfirstlane_b32 s21, v69
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_12:
		ds_read_b32 v69, v16
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v69
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_12
.L_a4w4_kernel.loop_exit_12:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[90:91], v2 offset:3904
		v_readfirstlane_b32 s21, v79
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_13:
		ds_read_b32 v69, v17
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v69
		s_xor_b32 s36, s21, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s22, s22, s36
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_13
.L_a4w4_kernel.loop_exit_13:
		s_mov_b64 exec, s[24:25]
		ds_read_b64_tr_b8 v[92:93], v2 offset:4032
		ds_read_b64_tr_b8 v[80:81], v55 offset:5952
		buffer_load_dwordx4 v83, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1dde0
		s_add_i32 s16, s16, s14
		buffer_load_dwordx4 v65, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1ee60
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v67, s[32:35], 0 offen lds
		s_add_i32 m0, s23, 0x1fee0
		s_add_i32 s1, s1, 0x100
		buffer_load_dwordx4 v64, s[32:35], 0 offen lds
		buffer_load_dword v69, v68, s[44:47], 0 offen
		s_cmp_lt_i32 s37, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_3
.L_a4w4_kernel.loop_exit_3:
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt vmcnt(1)
		ds_add_rtn_u32 v8, v18, v73
		s_mov_b64 exec, s[2:3]
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v80, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v80, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[72:75], a[8:11], v[120:123], v80, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[64:67], a[8:11], v[116:119], v80, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], a[12:15], v[120:123], v80, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[68:71], a[12:15], v[116:119], v80, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v81, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[88:91], a[0:3], v[112:115], v81, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], a[8:11], v[128:131], v81, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], a[8:11], v[124:127], v81, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[92:95], a[4:7], v[112:115], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], a[12:15], v[128:131], v81, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], a[12:15], v[124:127], v81, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[80:83], a[16:19], v[140:143], v81, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], a[16:19], v[144:147], v81, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[24:27], v[160:163], v81, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[80:83], a[24:27], v[156:159], v81, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], a[20:23], v[140:143], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], a[20:23], v[144:147], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[28:31], v[160:163], v81, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[84:87], a[28:31], v[156:159], v81, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[64:67], a[16:19], v[132:135], v80, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[72:75], a[16:19], v[136:139], v80, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[72:75], a[24:27], v[152:155], v80, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[64:67], a[24:27], v[148:151], v80, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[68:71], a[20:23], v[132:135], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[76:79], a[20:23], v[136:139], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[76:79], a[28:31], v[152:155], v80, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[68:71], a[28:31], v[148:151], v80, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[32:35], v[164:167], v80, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[32:35], v[168:171], v80, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[40:43], v[184:187], v80, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[40:43], v[180:183], v80, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[36:39], v[164:167], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[36:39], v[168:171], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[44:47], v[184:187], v80, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[44:47], v[180:183], v80, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[32:35], v[172:175], v81, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[32:35], v[176:179], v81, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[40:43], v[192:195], v81, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[40:43], v[188:191], v81, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[36:39], v[172:175], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[36:39], v[176:179], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[44:47], v[192:195], v81, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[44:47], v[188:191], v81, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[48:51], v[204:207], v81, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[48:51], v[208:211], v81, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], a[56:59], v[224:227], v81, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[80:83], a[56:59], v[220:223], v81, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[52:55], v[204:207], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[52:55], v[208:211], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[92:95], a[60:63], v[224:227], v81, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], a[60:63], v[220:223], v81, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[48:51], v[196:199], v80, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[48:51], v[200:203], v80, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[56:59], v[216:219], v80, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[56:59], v[212:215], v80, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[52:55], v[196:199], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[52:55], v[200:203], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[60:63], v[216:219], v80, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[60:63], v[212:215], v80, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v8
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_14:
		ds_read_b32 v8, v18
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v8
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_14
.L_a4w4_kernel.loop_exit_14:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v74 offset:35712
		ds_read_b128 v[12:15], v74 offset:35776
		ds_read_b128 v[60:63], v74 offset:35968
		ds_read_b128 v[64:67], v74 offset:36032
		ds_read_b128 v[80:83], v74 offset:36224
		ds_read_b128 v[96:99], v74 offset:36288
		ds_read_b128 v[104:107], v74 offset:36480
		ds_read_b128 v[252:255], v74 offset:36544
		ds_write_b32 v85, v101 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v16, v19, v73
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshlrev_b32_e32 v17, 9, v51
		v_lshl_add_u32 v17, v46, 4, v17
		v_lshl_add_u32 v17, v49, 13, v17
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v16
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_15:
		ds_read_b32 v16, v19
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v16
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_15
.L_a4w4_kernel.loop_exit_15:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[18:19], v55 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[8:11], a[0:3], v[228:231], v18, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[60:63], a[0:3], v[232:235], v18, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[60:63], a[8:11], a[100:103], v18, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[8:11], a[8:11], v[244:247], v18, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[12:15], a[4:7], v[228:231], v18, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[64:67], a[4:7], v[232:235], v18, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[64:67], a[12:15], a[100:103], v18, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[12:15], a[12:15], v[244:247], v18, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[80:83], a[0:3], v[236:239], v19, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[104:107], a[0:3], v[240:243], v19, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[104:107], a[8:11], a[108:111], v19, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[80:83], a[8:11], a[104:107], v19, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[96:99], a[4:7], v[236:239], v19, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[252:255], a[4:7], v[240:243], v19, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[252:255], a[12:15], a[108:111], v19, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], a[12:15], a[104:107], v19, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[80:83], a[16:19], a[120:123], v19, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], a[16:19], a[124:127], v19, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], a[24:27], a[140:143], v19, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], a[24:27], a[136:139], v19, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], a[20:23], a[120:123], v19, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[252:255], a[20:23], a[124:127], v19, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[252:255], a[28:31], a[140:143], v19, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], a[28:31], a[136:139], v19, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[8:11], a[16:19], a[112:115], v18, v91 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[60:63], a[16:19], a[116:119], v18, v91 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[60:63], a[24:27], a[132:135], v18, v91 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[8:11], a[24:27], a[128:131], v18, v91 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[12:15], a[20:23], a[112:115], v18, v91 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[64:67], a[20:23], a[116:119], v18, v91 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[64:67], a[28:31], a[132:135], v18, v91 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[12:15], a[28:31], a[128:131], v18, v91 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[8:11], a[32:35], a[144:147], v18, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[60:63], a[32:35], a[148:151], v18, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[60:63], a[40:43], a[164:167], v18, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[8:11], a[40:43], a[160:163], v18, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[12:15], a[36:39], a[144:147], v18, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[64:67], a[36:39], a[148:151], v18, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[64:67], a[44:47], a[164:167], v18, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[12:15], a[44:47], a[160:163], v18, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], a[32:35], a[152:155], v19, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], a[32:35], a[156:159], v19, v92 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], a[40:43], a[172:175], v19, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], a[40:43], a[168:171], v19, v92 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], a[36:39], a[152:155], v19, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[252:255], a[36:39], a[156:159], v19, v92 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[252:255], a[44:47], a[172:175], v19, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], a[44:47], a[168:171], v19, v92 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[80:83], a[48:51], a[184:187], v19, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], a[48:51], a[188:191], v19, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], a[56:59], a[204:207], v19, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[80:83], a[56:59], a[200:203], v19, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], a[52:55], a[184:187], v19, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[252:255], a[52:55], a[188:191], v19, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], a[60:63], a[204:207], v19, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], a[60:63], a[200:203], v19, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[8:11], a[48:51], a[176:179], v18, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[60:63], a[48:51], a[180:183], v18, v93 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], a[56:59], a[196:199], v18, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[8:11], a[56:59], a[192:195], v18, v93 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[12:15], a[52:55], a[176:179], v18, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[64:67], a[52:55], a[180:183], v18, v93 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[64:67], a[60:63], a[196:199], v18, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[12:15], a[60:63], a[192:195], v18, v93 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v1 offset:33760
		ds_read_b128 v[12:15], v1 offset:33824
		ds_read_b128 v[60:63], v1 offset:34016
		ds_read_b128 a[0:3], v1 offset:34080
		ds_read_b128 a[4:7], v1 offset:34272
		ds_read_b128 a[8:11], v1 offset:34336
		ds_read_b128 a[12:15], v1 offset:34528
		ds_read_b128 a[16:19], v1 offset:34592
		ds_read_b128 a[20:23], v1 offset:50656
		ds_read_b128 a[24:27], v1 offset:50720
		ds_read_b128 a[28:31], v1 offset:50912
		ds_read_b128 a[32:35], v1 offset:50976
		ds_read_b128 a[36:39], v1 offset:51168
		ds_read_b128 a[40:43], v1 offset:51232
		ds_read_b128 a[44:47], v1 offset:51424
		ds_read_b128 a[48:51], v1 offset:51488
		ds_read_b128 v[64:67], v74 offset:18848
		ds_read_b128 v[80:83], v74 offset:18912
		ds_read_b128 v[88:91], v74 offset:19104
		ds_read_b128 v[92:95], v74 offset:19168
		ds_read_b128 v[96:99], v74 offset:19360
		ds_read_b128 v[100:103], v74 offset:19424
		ds_read_b128 v[104:107], v74 offset:19616
		ds_read_b128 v[252:255], v74 offset:19680
		ds_write_b64 v86, v[110:111] offset:3904
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v20, v73
		s_mov_b64 exec, s[2:3]
		ds_write_b32 v85, v78 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v16, v21, v73
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v18, 12, v53
		v_add3_u32 v3, v17, v18, v3
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_16:
		ds_read_b32 v1, v20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_16
.L_a4w4_kernel.loop_exit_16:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[18:19], v2 offset:3904
		v_readfirstlane_b32 s1, v16
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_17:
		ds_read_b32 v1, v21
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_17
.L_a4w4_kernel.loop_exit_17:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[16:17], v2 offset:4032
		ds_read_b64_tr_b8 v[20:21], v55 offset:5952
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[64:67], v[8:11], v[248:251], v20, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[8:11], a[96:99], v20, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[88:91], v[60:63], v[120:123], v20, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[60:63], v[116:119], v20, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[80:83], v[12:15], v[248:251], v20, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[12:15], a[96:99], v20, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[92:95], a[0:3], v[120:123], v20, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[80:83], a[0:3], v[116:119], v20, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[96:99], v[8:11], v[4:7], v21, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[104:107], v[8:11], v[112:115], v21, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[104:107], v[60:63], v[128:131], v21, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[96:99], v[60:63], v[124:127], v21, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[100:103], v[12:15], v[4:7], v21, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], v[12:15], v[112:115], v21, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], a[0:3], v[128:131], v21, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[100:103], a[0:3], v[124:127], v21, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[96:99], a[4:7], v[140:143], v21, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[104:107], a[4:7], v[144:147], v21, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[104:107], a[12:15], v[160:163], v21, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[96:99], a[12:15], v[156:159], v21, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[100:103], a[8:11], v[140:143], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], a[8:11], v[144:147], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[16:19], v[160:163], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[100:103], a[16:19], v[156:159], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], a[4:7], v[132:135], v20, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[88:91], a[4:7], v[136:139], v20, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[88:91], a[12:15], v[152:155], v20, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[64:67], a[12:15], v[148:151], v20, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[80:83], a[8:11], v[132:135], v20, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[92:95], a[8:11], v[136:139], v20, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[92:95], a[16:19], v[152:155], v20, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], a[16:19], v[148:151], v20, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[64:67], a[20:23], v[164:167], v20, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[88:91], a[20:23], v[168:171], v20, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[88:91], a[28:31], v[184:187], v20, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], a[28:31], v[180:183], v20, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[80:83], a[24:27], v[164:167], v20, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[92:95], a[24:27], v[168:171], v20, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[92:95], a[32:35], v[184:187], v20, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[80:83], a[32:35], v[180:183], v20, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[96:99], a[20:23], v[172:175], v21, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[104:107], a[20:23], v[176:179], v21, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[104:107], a[28:31], v[192:195], v21, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[96:99], a[28:31], v[188:191], v21, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[100:103], a[24:27], v[172:175], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[24:27], v[176:179], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[32:35], v[192:195], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[100:103], a[32:35], v[188:191], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[96:99], a[36:39], v[204:207], v21, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[104:107], a[36:39], v[208:211], v21, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[104:107], a[44:47], v[224:227], v21, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[96:99], a[44:47], v[220:223], v21, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[100:103], a[40:43], v[204:207], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[40:43], v[208:211], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], a[48:51], v[224:227], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[100:103], a[48:51], v[220:223], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], a[36:39], v[196:199], v20, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[88:91], a[36:39], v[200:203], v20, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[88:91], a[44:47], v[216:219], v20, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], a[44:47], v[212:215], v20, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[80:83], a[40:43], v[196:199], v20, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], a[40:43], v[200:203], v20, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[92:95], a[48:51], v[216:219], v20, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[80:83], a[48:51], v[212:215], v20, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v74 offset:52576
		ds_read_b128 v[76:79], v74 offset:52640
		ds_read_b128 v[80:83], v74 offset:52832
		ds_read_b128 v[88:91], v74 offset:52896
		ds_read_b128 v[92:95], v74 offset:53088
		ds_read_b128 v[96:99], v74 offset:53152
		ds_read_b128 v[100:103], v74 offset:53344
		ds_read_b128 v[104:107], v74 offset:53408
		s_waitcnt vmcnt(0)
		ds_write_b32 v85, v69 offset:5952
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v22, v73
		s_mov_b64 exec, s[2:3]
		v_cvt_pk_bf16_f32 v68, v248, v249
		v_cvt_pk_bf16_f32 v69, v250, v251
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v20, a97
		v_cvt_pk_bf16_f32 v84, v2, v20
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v20, a99
		v_cvt_pk_bf16_f32 v85, v2, v20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_18:
		ds_read_b32 v1, v22
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_18
.L_a4w4_kernel.loop_exit_18:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[20:21], v55 offset:5952
		s_mul_i32 s1, s12, s17
		v_cvt_pk_bf16_f32 v108, v4, v5
		v_cvt_pk_bf16_f32 v109, v6, v7
		v_cvt_pk_bf16_f32 v4, v112, v113
		v_cvt_pk_bf16_f32 v5, v114, v115
		v_cvt_pk_bf16_f32 v70, v116, v117
		v_cvt_pk_bf16_f32 v71, v118, v119
		v_cvt_pk_bf16_f32 v86, v120, v121
		v_cvt_pk_bf16_f32 v87, v122, v123
		v_cvt_pk_bf16_f32 v110, v124, v125
		v_cvt_pk_bf16_f32 v111, v126, v127
		v_cvt_pk_bf16_f32 v6, v128, v129
		v_cvt_pk_bf16_f32 v7, v130, v131
		v_cvt_pk_bf16_f32 v112, v132, v133
		v_cvt_pk_bf16_f32 v113, v134, v135
		v_cvt_pk_bf16_f32 v116, v136, v137
		v_cvt_pk_bf16_f32 v117, v138, v139
		v_cvt_pk_bf16_f32 v120, v140, v141
		v_cvt_pk_bf16_f32 v121, v142, v143
		v_cvt_pk_bf16_f32 v124, v144, v145
		v_cvt_pk_bf16_f32 v125, v146, v147
		v_cvt_pk_bf16_f32 v114, v148, v149
		v_cvt_pk_bf16_f32 v115, v150, v151
		v_cvt_pk_bf16_f32 v118, v152, v153
		v_cvt_pk_bf16_f32 v119, v154, v155
		v_cvt_pk_bf16_f32 v122, v156, v157
		v_cvt_pk_bf16_f32 v123, v158, v159
		v_cvt_pk_bf16_f32 v126, v160, v161
		v_cvt_pk_bf16_f32 v127, v162, v163
		v_cvt_pk_bf16_f32 v128, v164, v165
		v_cvt_pk_bf16_f32 v129, v166, v167
		v_cvt_pk_bf16_f32 v132, v168, v169
		v_cvt_pk_bf16_f32 v133, v170, v171
		v_cvt_pk_bf16_f32 v136, v172, v173
		v_cvt_pk_bf16_f32 v137, v174, v175
		v_cvt_pk_bf16_f32 v140, v176, v177
		v_cvt_pk_bf16_f32 v141, v178, v179
		v_cvt_pk_bf16_f32 v130, v180, v181
		v_cvt_pk_bf16_f32 v131, v182, v183
		v_cvt_pk_bf16_f32 v134, v184, v185
		v_cvt_pk_bf16_f32 v135, v186, v187
		v_cvt_pk_bf16_f32 v138, v188, v189
		v_cvt_pk_bf16_f32 v139, v190, v191
		v_cvt_pk_bf16_f32 v142, v192, v193
		v_cvt_pk_bf16_f32 v143, v194, v195
		v_cvt_pk_bf16_f32 v144, v196, v197
		v_cvt_pk_bf16_f32 v145, v198, v199
		v_cvt_pk_bf16_f32 v148, v200, v201
		v_cvt_pk_bf16_f32 v149, v202, v203
		v_cvt_pk_bf16_f32 v152, v204, v205
		v_cvt_pk_bf16_f32 v153, v206, v207
		v_cvt_pk_bf16_f32 v156, v208, v209
		v_cvt_pk_bf16_f32 v157, v210, v211
		v_cvt_pk_bf16_f32 v146, v212, v213
		v_cvt_pk_bf16_f32 v147, v214, v215
		v_cvt_pk_bf16_f32 v150, v216, v217
		v_cvt_pk_bf16_f32 v151, v218, v219
		v_cvt_pk_bf16_f32 v154, v220, v221
		v_cvt_pk_bf16_f32 v155, v222, v223
		v_cvt_pk_bf16_f32 v158, v224, v225
		v_cvt_pk_bf16_f32 v159, v226, v227
		ds_write_b128 v0, v[68:71]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[108:111] offset:8192
		ds_write_b128 v0, v[4:7] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v23, v73
		s_mov_b64 exec, s[2:3]
		s_lshl_b32 s1, s1, 1
		s_add_u32 s8, s6, s1
		s_addc_u32 s9, s7, 0
		s_mov_b32 s10, s26
		s_mov_b32 s11, s27
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v2, 7, v49
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_19:
		ds_read_b32 v1, v23
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_19
.L_a4w4_kernel.loop_exit_19:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[48:51], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[68:69], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[70:71], v[48:49]
		v_mov_b64_e32 v[84:85], v[6:7]
		v_mov_b64_e32 v[86:87], v[50:51]
		ds_read_b128 v[4:7], v3 offset:2048
		ds_read_b128 v[48:51], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[108:109], v[4:5]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[110:111], v[48:49]
		v_mov_b64_e32 v[160:161], v[6:7]
		v_mov_b64_e32 v[162:163], v[50:51]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v24, v73
		s_mov_b64 exec, s[2:3]
		v_lshlrev_b32_e32 v4, 3, v39
		v_lshlrev_b32_e32 v5, 2, v41
		v_add_u32_e32 v6, 16, v47
		v_lshlrev_b32_e32 v7, 1, v44
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_20:
		ds_read_b32 v1, v24
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_20
.L_a4w4_kernel.loop_exit_20:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[112:115]
		ds_write_b128 v0, v[116:119] offset:4096
		ds_write_b128 v0, v[120:123] offset:8192
		ds_write_b128 v0, v[124:127] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v25, v73
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v6, v6, v7
		v_xor_b32_e32 v6, v5, v6
		v_xor_b32_e32 v6, v4, v6
		v_add_u32_e32 v22, 32, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_21:
		ds_read_b32 v1, v25
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_21
.L_a4w4_kernel.loop_exit_21:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[48:51], v3
		ds_read_b128 v[112:115], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[116:117], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[118:119], v[112:113]
		v_mov_b64_e32 v[120:121], v[50:51]
		v_mov_b64_e32 v[122:123], v[114:115]
		ds_read_b128 v[48:51], v3 offset:2048
		ds_read_b128 v[112:115], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[124:125], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[126:127], v[112:113]
		v_mov_b64_e32 v[164:165], v[50:51]
		v_mov_b64_e32 v[166:167], v[114:115]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v26, v73
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v22, v22, v7
		v_xor_b32_e32 v22, v5, v22
		v_xor_b32_e32 v22, v4, v22
		v_add_u32_e32 v23, 48, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_22:
		ds_read_b32 v1, v26
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_22
.L_a4w4_kernel.loop_exit_22:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[128:131]
		ds_write_b128 v0, v[132:135] offset:4096
		ds_write_b128 v0, v[136:139] offset:8192
		ds_write_b128 v0, v[140:143] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v27, v73
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v23, v23, v7
		v_xor_b32_e32 v23, v5, v23
		v_xor_b32_e32 v23, v4, v23
		v_add_u32_e32 v24, 64, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_23:
		ds_read_b32 v1, v27
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_23
.L_a4w4_kernel.loop_exit_23:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[48:51], v3
		ds_read_b128 v[112:115], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[128:129], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[130:131], v[112:113]
		v_mov_b64_e32 v[132:133], v[50:51]
		v_mov_b64_e32 v[134:135], v[114:115]
		ds_read_b128 v[48:51], v3 offset:2048
		ds_read_b128 v[112:115], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[136:137], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[138:139], v[112:113]
		v_mov_b64_e32 v[140:141], v[50:51]
		v_mov_b64_e32 v[142:143], v[114:115]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v28, v73
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v24, v24, v7
		v_xor_b32_e32 v24, v5, v24
		v_xor_b32_e32 v24, v4, v24
		v_add_u32_e32 v25, 0x50, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_24:
		ds_read_b32 v1, v28
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_24
.L_a4w4_kernel.loop_exit_24:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[144:147]
		ds_write_b128 v0, v[148:151] offset:4096
		ds_write_b128 v0, v[152:155] offset:8192
		ds_write_b128 v0, v[156:159] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v29, v73
		s_mov_b64 exec, s[2:3]
		v_xor_b32_e32 v25, v25, v7
		v_xor_b32_e32 v25, v5, v25
		v_xor_b32_e32 v25, v4, v25
		v_add_u32_e32 v26, 0x60, v47
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_25:
		ds_read_b32 v1, v29
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_25
.L_a4w4_kernel.loop_exit_25:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[48:51], v3
		ds_read_b128 v[112:115], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[144:145], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[146:147], v[112:113]
		v_mov_b64_e32 v[148:149], v[50:51]
		v_mov_b64_e32 v[150:151], v[114:115]
		ds_read_b128 v[48:51], v3 offset:2048
		ds_read_b128 v[112:115], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[152:153], v[48:49]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[154:155], v[112:113]
		v_mov_b64_e32 v[156:157], v[50:51]
		v_mov_b64_e32 v[158:159], v[114:115]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v30, v73
		s_mov_b64 exec, s[2:3]
		v_mul_lo_u32 v27, s17, v39
		v_lshlrev_b32_e32 v27, 4, v27
		v_mul_lo_u32 v28, s17, v41
		v_lshlrev_b32_e32 v28, 3, v28
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_26:
		ds_read_b32 v1, v30
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_26
.L_a4w4_kernel.loop_exit_26:
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, s0, v27, v28
		v_mul_lo_u32 v29, s17, v44
		v_lshlrev_b32_e32 v29, 2, v29
		v_mul_lo_u32 v30, s17, v47
		v_lshlrev_b32_e32 v30, 1, v30
		v_add3_u32 v1, v1, v29, v30
		v_add3_u32 v1, v1, v52, v2
		v_add3_u32 v1, v1, v54, v56
		buffer_store_dwordx4 v[68:71], v1, s[8:11], 0 offen
		v_mul_lo_u32 v1, s17, v6
		v_lshlrev_b32_e32 v1, 1, v1
		v_add_u32_e32 v6, s0, v1
		v_add3_u32 v6, v6, v52, v2
		v_add3_u32 v6, v6, v54, v56
		buffer_store_dwordx4 v[108:111], v6, s[8:11], 0 offen
		v_mul_lo_u32 v6, s17, v22
		v_lshlrev_b32_e32 v6, 1, v6
		v_add_u32_e32 v22, s0, v6
		v_add3_u32 v22, v22, v52, v2
		v_add3_u32 v22, v22, v54, v56
		buffer_store_dwordx4 v[84:87], v22, s[8:11], 0 offen
		v_mul_lo_u32 v22, s17, v23
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v23, s0, v22
		v_add3_u32 v23, v23, v52, v2
		v_add3_u32 v23, v23, v54, v56
		buffer_store_dwordx4 v[160:163], v23, s[8:11], 0 offen
		v_mul_lo_u32 v23, s17, v24
		v_lshlrev_b32_e32 v23, 1, v23
		v_add_u32_e32 v24, s0, v23
		v_add3_u32 v24, v24, v52, v2
		v_add3_u32 v24, v24, v54, v56
		buffer_store_dwordx4 v[116:119], v24, s[8:11], 0 offen
		v_mul_lo_u32 v24, s17, v25
		v_lshlrev_b32_e32 v24, 1, v24
		v_add_u32_e32 v25, s0, v24
		v_add3_u32 v25, v25, v52, v2
		v_add3_u32 v25, v25, v54, v56
		buffer_store_dwordx4 v[124:127], v25, s[8:11], 0 offen
		v_xor_b32_e32 v25, v26, v7
		v_xor_b32_e32 v25, v5, v25
		v_xor_b32_e32 v25, v4, v25
		v_mul_lo_u32 v25, s17, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add_u32_e32 v26, s0, v25
		v_add3_u32 v26, v26, v52, v2
		v_add3_u32 v26, v26, v54, v56
		buffer_store_dwordx4 v[120:123], v26, s[8:11], 0 offen
		v_add_u32_e32 v26, 0x70, v47
		v_xor_b32_e32 v26, v26, v7
		v_xor_b32_e32 v26, v5, v26
		v_xor_b32_e32 v26, v4, v26
		v_mul_lo_u32 v26, s17, v26
		v_lshlrev_b32_e32 v26, 1, v26
		v_add_u32_e32 v39, s0, v26
		v_add3_u32 v39, v39, v52, v2
		v_add3_u32 v39, v39, v54, v56
		buffer_store_dwordx4 v[164:167], v39, s[8:11], 0 offen
		v_add_u32_e32 v39, 0x80, v47
		v_xor_b32_e32 v39, v39, v7
		v_xor_b32_e32 v39, v5, v39
		v_xor_b32_e32 v39, v4, v39
		v_mul_lo_u32 v39, s17, v39
		v_lshlrev_b32_e32 v39, 1, v39
		v_add_u32_e32 v40, s0, v39
		v_add3_u32 v40, v40, v52, v2
		v_add3_u32 v40, v40, v54, v56
		buffer_store_dwordx4 v[128:131], v40, s[8:11], 0 offen
		v_add_u32_e32 v40, 0x90, v47
		v_xor_b32_e32 v40, v40, v7
		v_xor_b32_e32 v40, v5, v40
		v_xor_b32_e32 v40, v4, v40
		v_mul_lo_u32 v40, s17, v40
		v_lshlrev_b32_e32 v40, 1, v40
		v_add_u32_e32 v41, s0, v40
		v_add3_u32 v41, v41, v52, v2
		v_add3_u32 v41, v41, v54, v56
		buffer_store_dwordx4 v[136:139], v41, s[8:11], 0 offen
		v_add_u32_e32 v41, 0xa0, v47
		v_xor_b32_e32 v41, v41, v7
		v_xor_b32_e32 v41, v5, v41
		v_xor_b32_e32 v41, v4, v41
		v_mul_lo_u32 v41, s17, v41
		v_lshlrev_b32_e32 v41, 1, v41
		v_add_u32_e32 v42, s0, v41
		v_add3_u32 v42, v42, v52, v2
		v_add3_u32 v42, v42, v54, v56
		buffer_store_dwordx4 v[132:135], v42, s[8:11], 0 offen
		v_add_u32_e32 v42, 0xb0, v47
		v_xor_b32_e32 v42, v42, v7
		v_xor_b32_e32 v42, v5, v42
		v_xor_b32_e32 v42, v4, v42
		v_mul_lo_u32 v42, s17, v42
		v_lshlrev_b32_e32 v42, 1, v42
		v_add_u32_e32 v43, s0, v42
		v_add3_u32 v43, v43, v52, v2
		v_add3_u32 v43, v43, v54, v56
		buffer_store_dwordx4 v[140:143], v43, s[8:11], 0 offen
		v_add_u32_e32 v43, 0xc0, v47
		v_xor_b32_e32 v43, v43, v7
		v_xor_b32_e32 v43, v5, v43
		v_xor_b32_e32 v43, v4, v43
		v_mul_lo_u32 v43, s17, v43
		v_lshlrev_b32_e32 v43, 1, v43
		v_add_u32_e32 v44, s0, v43
		v_add3_u32 v44, v44, v52, v2
		v_add3_u32 v44, v44, v54, v56
		buffer_store_dwordx4 v[144:147], v44, s[8:11], 0 offen
		v_add_u32_e32 v44, 0xd0, v47
		v_xor_b32_e32 v44, v44, v7
		v_xor_b32_e32 v44, v5, v44
		v_xor_b32_e32 v44, v4, v44
		v_mul_lo_u32 v44, s17, v44
		v_lshlrev_b32_e32 v44, 1, v44
		v_add_u32_e32 v45, s0, v44
		v_add3_u32 v45, v45, v52, v2
		v_add3_u32 v45, v45, v54, v56
		buffer_store_dwordx4 v[152:155], v45, s[8:11], 0 offen
		v_add_u32_e32 v45, 0xe0, v47
		v_xor_b32_e32 v45, v45, v7
		v_xor_b32_e32 v45, v5, v45
		v_xor_b32_e32 v45, v4, v45
		v_mul_lo_u32 v45, s17, v45
		v_lshlrev_b32_e32 v45, 1, v45
		v_add_u32_e32 v46, s0, v45
		v_add3_u32 v46, v46, v52, v2
		v_add3_u32 v46, v46, v54, v56
		buffer_store_dwordx4 v[148:151], v46, s[8:11], 0 offen
		v_add_u32_e32 v46, 0xf0, v47
		v_xor_b32_e32 v7, v46, v7
		v_xor_b32_e32 v5, v5, v7
		v_xor_b32_e32 v4, v4, v5
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 1, v4
		v_add_u32_e32 v5, s0, v4
		v_add3_u32 v5, v5, v52, v2
		v_add3_u32 v5, v5, v54, v56
		buffer_store_dwordx4 v[156:159], v5, s[8:11], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[64:67], v[8:11], v[228:231], v20, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[80:83], v[8:11], v[232:235], v20, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[80:83], v[60:63], a[100:103], v20, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[64:67], v[60:63], v[244:247], v20, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[76:79], v[12:15], v[228:231], v20, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[88:91], v[12:15], v[232:235], v20, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], a[0:3], a[100:103], v20, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[76:79], a[0:3], v[244:247], v20, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[92:95], v[8:11], v[236:239], v21, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[100:103], v[8:11], v[240:243], v21, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[60:63], a[108:111], v21, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[60:63], a[104:107], v21, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[96:99], v[12:15], v[236:239], v21, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[104:107], v[12:15], v[240:243], v21, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[104:107], a[0:3], a[108:111], v21, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], a[0:3], a[104:107], v21, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], a[4:7], a[120:123], v21, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], a[4:7], a[124:127], v21, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], a[12:15], a[140:143], v21, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], a[12:15], a[136:139], v21, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], a[8:11], a[120:123], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], a[8:11], a[124:127], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], a[16:19], a[140:143], v21, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], a[16:19], a[136:139], v21, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[64:67], a[4:7], a[112:115], v20, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[80:83], a[4:7], a[116:119], v20, v19 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], a[12:15], a[132:135], v20, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[64:67], a[12:15], a[128:131], v20, v19 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], a[8:11], a[112:115], v20, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], a[8:11], a[116:119], v20, v19 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], a[16:19], a[132:135], v20, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], a[16:19], a[128:131], v20, v19 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[64:67], a[20:23], a[144:147], v20, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], a[20:23], a[148:151], v20, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], a[28:31], a[164:167], v20, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[64:67], a[28:31], a[160:163], v20, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], a[24:27], a[144:147], v20, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[88:91], a[24:27], a[148:151], v20, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[88:91], a[32:35], a[164:167], v20, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], a[32:35], a[160:163], v20, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], a[20:23], a[152:155], v21, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], a[20:23], a[156:159], v21, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], a[28:31], a[172:175], v21, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], a[28:31], a[168:171], v21, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], a[24:27], a[152:155], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], a[24:27], a[156:159], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], a[32:35], a[172:175], v21, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], a[32:35], a[168:171], v21, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[92:95], a[36:39], a[184:187], v21, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], a[36:39], a[188:191], v21, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], a[44:47], a[204:207], v21, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[92:95], a[44:47], a[200:203], v21, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], a[40:43], a[184:187], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], a[40:43], a[188:191], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], a[48:51], a[204:207], v21, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], a[48:51], a[200:203], v21, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[64:67], a[36:39], a[176:179], v20, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[80:83], a[36:39], a[180:183], v20, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[80:83], a[44:47], a[196:199], v20, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[64:67], a[44:47], a[192:195], v20, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[76:79], a[40:43], a[176:179], v20, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[88:91], a[40:43], a[180:183], v20, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[88:91], a[48:51], a[196:199], v20, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[76:79], a[48:51], a[192:195], v20, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_bf16_f32 v8, v228, v229
		v_cvt_pk_bf16_f32 v9, v230, v231
		v_cvt_pk_bf16_f32 v12, v232, v233
		v_cvt_pk_bf16_f32 v13, v234, v235
		v_cvt_pk_bf16_f32 v16, v236, v237
		v_cvt_pk_bf16_f32 v17, v238, v239
		v_cvt_pk_bf16_f32 v48, v240, v241
		v_cvt_pk_bf16_f32 v49, v242, v243
		v_cvt_pk_bf16_f32 v10, v244, v245
		v_cvt_pk_bf16_f32 v11, v246, v247
		v_accvgpr_read_b32 v5, a100
		v_accvgpr_read_b32 v7, a101
		v_cvt_pk_bf16_f32 v14, v5, v7
		v_accvgpr_read_b32 v5, a102
		v_accvgpr_read_b32 v7, a103
		v_cvt_pk_bf16_f32 v15, v5, v7
		v_accvgpr_read_b32 v5, a104
		v_accvgpr_read_b32 v7, a105
		v_cvt_pk_bf16_f32 v18, v5, v7
		v_accvgpr_read_b32 v5, a106
		v_accvgpr_read_b32 v7, a107
		v_cvt_pk_bf16_f32 v19, v5, v7
		v_accvgpr_read_b32 v5, a108
		v_accvgpr_read_b32 v7, a109
		v_cvt_pk_bf16_f32 v50, v5, v7
		v_accvgpr_read_b32 v5, a110
		v_accvgpr_read_b32 v7, a111
		v_cvt_pk_bf16_f32 v51, v5, v7
		v_accvgpr_read_b32 v5, a112
		v_accvgpr_read_b32 v7, a113
		v_cvt_pk_bf16_f32 v60, v5, v7
		v_accvgpr_read_b32 v5, a114
		v_accvgpr_read_b32 v7, a115
		v_cvt_pk_bf16_f32 v61, v5, v7
		v_accvgpr_read_b32 v5, a116
		v_accvgpr_read_b32 v7, a117
		v_cvt_pk_bf16_f32 v64, v5, v7
		v_accvgpr_read_b32 v5, a118
		v_accvgpr_read_b32 v7, a119
		v_cvt_pk_bf16_f32 v65, v5, v7
		v_accvgpr_read_b32 v5, a120
		v_accvgpr_read_b32 v7, a121
		v_cvt_pk_bf16_f32 v68, v5, v7
		v_accvgpr_read_b32 v5, a122
		v_accvgpr_read_b32 v7, a123
		v_cvt_pk_bf16_f32 v69, v5, v7
		v_accvgpr_read_b32 v5, a124
		v_accvgpr_read_b32 v7, a125
		v_cvt_pk_bf16_f32 v76, v5, v7
		v_accvgpr_read_b32 v5, a126
		v_accvgpr_read_b32 v7, a127
		v_cvt_pk_bf16_f32 v77, v5, v7
		v_accvgpr_read_b32 v5, a128
		v_accvgpr_read_b32 v7, a129
		v_cvt_pk_bf16_f32 v62, v5, v7
		v_accvgpr_read_b32 v5, a130
		v_accvgpr_read_b32 v7, a131
		v_cvt_pk_bf16_f32 v63, v5, v7
		v_accvgpr_read_b32 v5, a132
		v_accvgpr_read_b32 v7, a133
		v_cvt_pk_bf16_f32 v66, v5, v7
		v_accvgpr_read_b32 v5, a134
		v_accvgpr_read_b32 v7, a135
		v_cvt_pk_bf16_f32 v67, v5, v7
		v_accvgpr_read_b32 v5, a136
		v_accvgpr_read_b32 v7, a137
		v_cvt_pk_bf16_f32 v70, v5, v7
		v_accvgpr_read_b32 v5, a138
		v_accvgpr_read_b32 v7, a139
		v_cvt_pk_bf16_f32 v71, v5, v7
		v_accvgpr_read_b32 v5, a140
		v_accvgpr_read_b32 v7, a141
		v_cvt_pk_bf16_f32 v78, v5, v7
		v_accvgpr_read_b32 v5, a142
		v_accvgpr_read_b32 v7, a143
		v_cvt_pk_bf16_f32 v79, v5, v7
		v_accvgpr_read_b32 v5, a144
		v_accvgpr_read_b32 v7, a145
		v_cvt_pk_bf16_f32 v80, v5, v7
		v_accvgpr_read_b32 v5, a146
		v_accvgpr_read_b32 v7, a147
		v_cvt_pk_bf16_f32 v81, v5, v7
		v_accvgpr_read_b32 v5, a148
		v_accvgpr_read_b32 v7, a149
		v_cvt_pk_bf16_f32 v84, v5, v7
		v_accvgpr_read_b32 v5, a150
		v_accvgpr_read_b32 v7, a151
		v_cvt_pk_bf16_f32 v85, v5, v7
		v_accvgpr_read_b32 v5, a152
		v_accvgpr_read_b32 v7, a153
		v_cvt_pk_bf16_f32 v88, v5, v7
		v_accvgpr_read_b32 v5, a154
		v_accvgpr_read_b32 v7, a155
		v_cvt_pk_bf16_f32 v89, v5, v7
		v_accvgpr_read_b32 v5, a156
		v_accvgpr_read_b32 v7, a157
		v_cvt_pk_bf16_f32 v92, v5, v7
		v_accvgpr_read_b32 v5, a158
		v_accvgpr_read_b32 v7, a159
		v_cvt_pk_bf16_f32 v93, v5, v7
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v7, a161
		v_cvt_pk_bf16_f32 v82, v5, v7
		v_accvgpr_read_b32 v5, a162
		v_accvgpr_read_b32 v7, a163
		v_cvt_pk_bf16_f32 v83, v5, v7
		v_accvgpr_read_b32 v5, a164
		v_accvgpr_read_b32 v7, a165
		v_cvt_pk_bf16_f32 v86, v5, v7
		v_accvgpr_read_b32 v5, a166
		v_accvgpr_read_b32 v7, a167
		v_cvt_pk_bf16_f32 v87, v5, v7
		v_accvgpr_read_b32 v5, a168
		v_accvgpr_read_b32 v7, a169
		v_cvt_pk_bf16_f32 v90, v5, v7
		v_accvgpr_read_b32 v5, a170
		v_accvgpr_read_b32 v7, a171
		v_cvt_pk_bf16_f32 v91, v5, v7
		v_accvgpr_read_b32 v5, a172
		v_accvgpr_read_b32 v7, a173
		v_cvt_pk_bf16_f32 v94, v5, v7
		v_accvgpr_read_b32 v5, a174
		v_accvgpr_read_b32 v7, a175
		v_cvt_pk_bf16_f32 v95, v5, v7
		v_accvgpr_read_b32 v5, a176
		v_accvgpr_read_b32 v7, a177
		v_cvt_pk_bf16_f32 v96, v5, v7
		v_accvgpr_read_b32 v5, a178
		v_accvgpr_read_b32 v7, a179
		v_cvt_pk_bf16_f32 v97, v5, v7
		v_accvgpr_read_b32 v5, a180
		v_accvgpr_read_b32 v7, a181
		v_cvt_pk_bf16_f32 v100, v5, v7
		v_accvgpr_read_b32 v5, a182
		v_accvgpr_read_b32 v7, a183
		v_cvt_pk_bf16_f32 v101, v5, v7
		v_accvgpr_read_b32 v5, a184
		v_accvgpr_read_b32 v7, a185
		v_cvt_pk_bf16_f32 v104, v5, v7
		v_accvgpr_read_b32 v5, a186
		v_accvgpr_read_b32 v7, a187
		v_cvt_pk_bf16_f32 v105, v5, v7
		v_accvgpr_read_b32 v5, a188
		v_accvgpr_read_b32 v7, a189
		v_cvt_pk_bf16_f32 v108, v5, v7
		v_accvgpr_read_b32 v5, a190
		v_accvgpr_read_b32 v7, a191
		v_cvt_pk_bf16_f32 v109, v5, v7
		v_accvgpr_read_b32 v5, a192
		v_accvgpr_read_b32 v7, a193
		v_cvt_pk_bf16_f32 v98, v5, v7
		v_accvgpr_read_b32 v5, a194
		v_accvgpr_read_b32 v7, a195
		v_cvt_pk_bf16_f32 v99, v5, v7
		v_accvgpr_read_b32 v5, a196
		v_accvgpr_read_b32 v7, a197
		v_cvt_pk_bf16_f32 v102, v5, v7
		v_accvgpr_read_b32 v5, a198
		v_accvgpr_read_b32 v7, a199
		v_cvt_pk_bf16_f32 v103, v5, v7
		v_accvgpr_read_b32 v5, a200
		v_accvgpr_read_b32 v7, a201
		v_cvt_pk_bf16_f32 v106, v5, v7
		v_accvgpr_read_b32 v5, a202
		v_accvgpr_read_b32 v7, a203
		v_cvt_pk_bf16_f32 v107, v5, v7
		v_accvgpr_read_b32 v5, a204
		v_accvgpr_read_b32 v7, a205
		v_cvt_pk_bf16_f32 v110, v5, v7
		v_accvgpr_read_b32 v5, a206
		v_accvgpr_read_b32 v7, a207
		v_cvt_pk_bf16_f32 v111, v5, v7
		ds_write_b128 v0, v[8:11]
		ds_write_b128 v0, v[12:15] offset:4096
		ds_write_b128 v0, v[16:19] offset:8192
		ds_write_b128 v0, v[48:51] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v5, v31, v73
		s_mov_b64 exec, s[2:3]
		s_add_i32 s0, s0, 0x100
		v_add3_u32 v7, s0, v27, v28
		v_add3_u32 v7, v7, v29, v30
		v_add3_u32 v7, v7, v52, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_27:
		ds_read_b32 v5, v31
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v5
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_27
.L_a4w4_kernel.loop_exit_27:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v3
		ds_read_b128 v[12:15], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[28:29], v[10:11]
		v_mov_b64_e32 v[30:31], v[14:15]
		ds_read_b128 v[8:11], v3 offset:2048
		ds_read_b128 v[12:15], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[48:49], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[50:51], v[12:13]
		v_mov_b64_e32 v[112:113], v[10:11]
		v_mov_b64_e32 v[114:115], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v5, v32, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v7, v7, v54, v56
		buffer_store_dwordx4 v[16:19], v7, s[8:11], 0 offen
		v_add3_u32 v7, v52, v2, v54
		v_add_u32_e32 v7, v7, v56
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_28:
		ds_read_b32 v5, v32
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v5
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_28
.L_a4w4_kernel.loop_exit_28:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[60:63]
		ds_write_b128 v0, v[64:67] offset:4096
		ds_write_b128 v0, v[68:71] offset:8192
		ds_write_b128 v0, v[76:79] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v5, v33, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, v1, v7, s0
		buffer_store_dwordx4 v[48:51], v1, s[8:11], 0 offen
		v_add3_u32 v1, v6, v7, s0
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_29:
		ds_read_b32 v1, v33
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_29
.L_a4w4_kernel.loop_exit_29:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v3
		ds_read_b128 v[12:15], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[28:29], v[10:11]
		v_mov_b64_e32 v[30:31], v[14:15]
		ds_read_b128 v[8:11], v3 offset:2048
		ds_read_b128 v[12:15], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[48:49], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[50:51], v[12:13]
		v_mov_b64_e32 v[60:61], v[10:11]
		v_mov_b64_e32 v[62:63], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v34, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v5, v22, v7, s0
		buffer_store_dwordx4 v[112:115], v5, s[8:11], 0 offen
		v_add3_u32 v5, v52, v2, v54
		v_add_u32_e32 v5, v5, v56
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_30:
		ds_read_b32 v1, v34
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_30
.L_a4w4_kernel.loop_exit_30:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[80:83]
		ds_write_b128 v0, v[84:87] offset:4096
		ds_write_b128 v0, v[88:91] offset:8192
		ds_write_b128 v0, v[92:95] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v35, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v6, v23, v5, s0
		buffer_store_dwordx4 v[16:19], v6, s[8:11], 0 offen
		v_add3_u32 v6, v24, v5, s0
		buffer_store_dwordx4 v[48:51], v6, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_31:
		ds_read_b32 v1, v35
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_31
.L_a4w4_kernel.loop_exit_31:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v3
		ds_read_b128 v[12:15], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[20:21], v[10:11]
		v_mov_b64_e32 v[22:23], v[14:15]
		ds_read_b128 v[8:11], v3 offset:2048
		ds_read_b128 v[12:15], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[32:33], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[34:35], v[12:13]
		v_mov_b64_e32 v[48:49], v[10:11]
		v_mov_b64_e32 v[50:51], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v1, v36, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v5, v25, v5, s0
		buffer_store_dwordx4 v[28:31], v5, s[8:11], 0 offen
		v_add3_u32 v5, v52, v2, v54
		v_add_u32_e32 v5, v5, v56
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_32:
		ds_read_b32 v1, v36
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_32
.L_a4w4_kernel.loop_exit_32:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v0, v[96:99]
		ds_write_b128 v0, v[100:103] offset:4096
		ds_write_b128 v0, v[104:107] offset:8192
		ds_write_b128 v0, v[108:111] offset:12288
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v0, v37, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, v26, v5, s0
		buffer_store_dwordx4 v[60:63], v1, s[8:11], 0 offen
		v_add3_u32 v1, v39, v5, s0
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v0
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_33:
		ds_read_b32 v0, v37
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v0
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_33
.L_a4w4_kernel.loop_exit_33:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v3
		ds_read_b128 v[12:15], v3 offset:256
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[24:25], v[10:11]
		v_mov_b64_e32 v[26:27], v[14:15]
		ds_read_b128 v[8:11], v3 offset:2048
		ds_read_b128 v[12:15], v3 offset:2304
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[28:29], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[30:31], v[12:13]
		v_mov_b64_e32 v[60:61], v[10:11]
		v_mov_b64_e32 v[62:63], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v0, v38, v73
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v1, v40, v5, s0
		buffer_store_dwordx4 v[32:35], v1, s[8:11], 0 offen
		v_add3_u32 v1, v52, v2, v54
		v_add_u32_e32 v1, v1, v56
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v0
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_34:
		ds_read_b32 v0, v38
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v0
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_34
.L_a4w4_kernel.loop_exit_34:
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v0, v41, v1, s0
		buffer_store_dwordx4 v[20:23], v0, s[8:11], 0 offen
		v_add3_u32 v0, v42, v1, s0
		buffer_store_dwordx4 v[48:51], v0, s[8:11], 0 offen
		v_add3_u32 v0, v43, v1, s0
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		v_add3_u32 v0, v52, v2, v54
		v_add_u32_e32 v0, v0, v56
		v_add3_u32 v1, v44, v0, s0
		buffer_store_dwordx4 v[28:31], v1, s[8:11], 0 offen
		v_add3_u32 v1, v45, v0, s0
		buffer_store_dwordx4 v[24:27], v1, s[8:11], 0 offen
		v_add3_u32 v0, v4, v0, s0
		buffer_store_dwordx4 v[60:63], v0, s[8:11], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 138192
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
		.amdhsa_next_free_vgpr 464
		.amdhsa_next_free_sgpr 54
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
	.set .L_a4w4_kernel.num_agpr, 208
	.set .L_a4w4_kernel.numbered_sgpr, 54
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
    .group_segment_fixed_size: 138192
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     464
    .agpr_count:     208
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 103
    wave.regalloc.agpr.dwords: 408
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
