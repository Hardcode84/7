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
		v_readfirstlane_b32 s17, v0
		s_lshl_b32 s17, s17, 2
		s_add_i32 s17, s17, 0x24c88
		v_mov_b32_e32 v4, 0
		s_mov_b32 s18, 1
		s_mov_b32 s19, 0
		s_and_saveexec_b64 s[20:21], s[18:19]
		v_mov_b32_e32 v1, 0x24c00
		ds_write_b32 v1, v4
		v_mov_b32_e32 v2, 0x24c04
		ds_write_b32 v2, v4
		v_mov_b32_e32 v3, 0x24c08
		ds_write_b32 v3, v4
		v_mov_b32_e32 v8, 0x24c0c
		ds_write_b32 v8, v4
		v_mov_b32_e32 v9, 0x24c10
		ds_write_b32 v9, v4
		v_mov_b32_e32 v10, 0x24c14
		ds_write_b32 v10, v4
		v_mov_b32_e32 v11, 0x24c18
		ds_write_b32 v11, v4
		v_mov_b32_e32 v12, 0x24c1c
		ds_write_b32 v12, v4
		v_mov_b32_e32 v13, 0x24c20
		ds_write_b32 v13, v4
		v_mov_b32_e32 v14, 0x24c24
		ds_write_b32 v14, v4
		v_mov_b32_e32 v15, 0x24c28
		ds_write_b32 v15, v4
		v_mov_b32_e32 v16, 0x24c2c
		ds_write_b32 v16, v4
		v_mov_b32_e32 v17, 0x24c30
		ds_write_b32 v17, v4
		v_mov_b32_e32 v5, 0x24c34
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c38
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c3c
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c40
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c44
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c48
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c4c
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c50
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c54
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c58
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c5c
		ds_write_b32 v5, v4
		v_mov_b32_e32 v5, 0x24c60
		ds_write_b32 v5, v4
		v_mov_b32_e32 v18, 0x24c64
		ds_write_b32 v18, v4
		v_mov_b32_e32 v19, 0x24c68
		ds_write_b32 v19, v4
		v_mov_b32_e32 v20, 0x24c6c
		ds_write_b32 v20, v4
		v_mov_b32_e32 v21, 0x24c70
		ds_write_b32 v21, v4
		v_mov_b32_e32 v22, 0x24c74
		ds_write_b32 v22, v4
		v_mov_b32_e32 v23, 0x24c78
		ds_write_b32 v23, v4
		v_mov_b32_e32 v24, 0x24c7c
		ds_write_b32 v24, v4
		v_mov_b32_e32 v25, 0x24c80
		ds_write_b32 v25, v4
		v_mov_b32_e32 v26, 0x24c84
		ds_write_b32 v26, v4
		s_mov_b64 exec, s[20:21]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_load_dword s20, s[0:1], 0x38
		s_load_dword s21, s[0:1], 0x3c
		s_load_dword s22, s[0:1], 0x40
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 s0, s12, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s23, s1, 0
		s_add_i32 s0, s0, s23
		s_ashr_i32 s0, s0, 8
		s_add_i32 s23, s13, 0xff
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s23, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s23, s16, 7
		s_lshr_b32 s16, s16, 3
		s_mul_i32 s23, s23, 32
		s_add_i32 s16, s23, s16
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s23, 1, 0
		s_xor_b32 s24, s16, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s24, s16
		s_cselect_b32 s24, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s26, s1, -1
		s_add_i32 s26, s26, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s25, s26, s1
		v_mov_b32_e32 v27, s25
		v_cvt_f32_u32_e32 v27, v27
		v_rcp_iflag_f32_e32 v27, v27
		v_mov_b32_e32 v28, 0x4f7ffffe
		v_mul_f32_e32 v27, v28, v27
		v_cvt_u32_f32_e32 v27, v27
		s_nop 0
		v_readfirstlane_b32 s26, v27
		s_xor_b32 s27, s25, -1
		s_add_i32 s27, s27, 1
		s_mul_i32 s28, s27, s26
		s_mul_hi_u32 s28, s26, s28
		s_add_i32 s26, s26, s28
		s_mul_hi_u32 s26, s23, s26
		s_mul_i32 s28, s26, s25
		s_xor_b32 s28, s28, -1
		s_add_i32 s28, s28, 1
		s_add_i32 s23, s23, s28
		s_cmp_ge_u32 s23, s25
		s_cselect_b32 s28, 1, 0
		s_add_i32 s29, s26, 1
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s26, s29, s26
		s_cselect_b32 s28, 1, 0
		s_add_i32 s29, s23, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s23, s29, s23
		s_cmp_ge_u32 s23, s25
		s_cselect_b32 s25, 1, 0
		s_add_i32 s28, s26, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s25, s28, s26
		s_cselect_b32 s26, 1, 0
		s_xor_b32 s1, s16, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s16, s25, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s16, s25
		s_mul_i32 s16, s1, 4
		s_xor_b32 s25, s16, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s0, s0, s25
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s25, s23, s27
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s23, s25, s23
		s_xor_b32 s25, s23, -1
		s_add_i32 s25, s25, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s23, s25, s23
		v_mov_b32_e32 v27, s0
		v_cvt_f32_u32_e32 v27, v27
		v_rcp_iflag_f32_e32 v27, v27
		s_nop 0
		v_mul_f32_e32 v27, v28, v27
		v_cvt_u32_f32_e32 v27, v27
		s_nop 0
		v_readfirstlane_b32 s24, v27
		s_xor_b32 s25, s0, -1
		s_add_i32 s25, s25, 1
		s_mul_i32 s26, s25, s24
		s_mul_hi_u32 s26, s24, s26
		s_add_i32 s24, s24, s26
		s_mul_hi_u32 s24, s23, s24
		s_mul_i32 s24, s24, s0
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s23, s24
		s_cmp_ge_u32 s24, s0
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s24, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s24, s27, s24
		s_cmp_ge_u32 s24, s0
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s24, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s24, s27, s24
		s_add_i32 s16, s16, s24
		v_readfirstlane_b32 s26, v27
		s_mul_i32 s27, s25, s26
		s_mul_hi_u32 s27, s26, s27
		s_add_i32 s26, s26, s27
		s_mul_hi_u32 s26, s23, s26
		s_mul_i32 s27, s26, s0
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s23, s23, s27
		s_cmp_ge_u32 s23, s0
		s_cselect_b32 s27, 1, 0
		s_add_i32 s28, s26, 1
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s26, s28, s26
		s_cselect_b32 s27, 1, 0
		s_add_i32 s25, s23, s25
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s23, s25, s23
		s_cmp_ge_u32 s23, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s23, s26, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s23, s26
		s_mul_i32 s16, s16, 0x100
		s_mov_b32 m0, s17
		v_lshrrev_b32_e32 v27, 4, v0
		ds_write_addtid_b32 v27
		v_and_b32_e32 v28, 15, v27
		v_add_u32_e32 v29, 0x50, v28
		v_add_u32_e32 v30, 0x60, v28
		v_add_u32_e32 v31, 0x70, v28
		v_add_u32_e32 v32, 0x80, v28
		v_add_u32_e32 v33, 0x90, v28
		v_add_u32_e32 v34, 0xa0, v28
		v_add_u32_e32 v35, 0xb0, v28
		v_add_u32_e32 v36, 0xc0, v28
		v_add_u32_e32 v37, 0xd0, v28
		v_add_u32_e32 v38, 0xe0, v28
		v_add_u32_e32 v39, 0xf0, v28
		v_and_b32_e32 v40, 15, v0
		s_mov_b32 m0, s17
		v_mov_b32_e32 v41, 8
		v_mul_lo_u32 v41, v41, v40
		ds_write_addtid_b32 v41 offset:1024
		s_mul_i32 s23, s0, 0x100
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		s_mov_b32 s36, s8
		s_mov_b32 s37, s9
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		s_mov_b32 s40, s10
		s_mov_b32 s41, s11
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		v_readfirstlane_b32 s2, v0
		s_mul_i32 s3, s1, s14
		s_lshl_b32 s3, s3, 10
		s_mul_i32 s4, s24, s14
		s_lshl_b32 s4, s4, 8
		s_add_i32 s5, s3, s4
		v_lshrrev_b32_e32 v40, 3, v0
		v_mul_lo_u32 v42, s14, v40
		s_mov_b32 m0, s17
		v_lshlrev_b32_e32 v43, 4, v0
		ds_write_addtid_b32 v43 offset:2048
		v_and_b32_e32 v43, 0x7f, v43
		v_add3_u32 v44, s5, v42, v43
		s_lshr_b32 s2, s2, 6
		s_lshl_b32 s2, s2, 10
		s_mov_b32 m0, s2
		s_mov_b32 m0, s17
		v_add_u32_e32 v45, s16, v28
		ds_write_addtid_b32 v45 offset:3072
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_lshl_b32 s8, s14, 5
		s_add_i32 s9, s8, s3
		s_add_i32 s9, s9, s4
		v_add3_u32 v44, s9, v42, v43
		s_add_i32 m0, s2, 0x1000
		s_mov_b32 m0, s17
		v_add3_u32 v45, 16, v28, s16
		ds_write_addtid_b32 v45 offset:4096
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_lshl_b32 s10, s14, 6
		s_add_i32 s11, s10, s3
		s_add_i32 s11, s11, s4
		v_add3_u32 v44, s11, v42, v43
		s_add_i32 m0, s2, 0x2000
		s_mov_b32 m0, s17
		v_add3_u32 v45, 32, v28, s16
		ds_write_addtid_b32 v45 offset:5120
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_mul_i32 s25, 0x60, s14
		s_add_i32 s26, s25, s3
		s_add_i32 s26, s26, s4
		v_add3_u32 v44, s26, v42, v43
		s_add_i32 m0, s2, 0x3000
		s_mov_b32 m0, s17
		v_add3_u32 v45, 48, v28, s16
		ds_write_addtid_b32 v45 offset:6144
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_lshl_b32 s27, s14, 7
		s_add_i32 s44, s27, s3
		s_add_i32 s44, s44, s4
		v_add3_u32 v44, s44, v42, v43
		s_add_i32 m0, s2, 0x4000
		s_mov_b32 m0, s17
		v_add3_u32 v28, 64, v28, s16
		ds_write_addtid_b32 v28 offset:7168
		buffer_load_dwordx4 v44, s[28:31], 0 offen lds
		s_mul_i32 s45, 0xa0, s14
		s_add_i32 s46, s45, s3
		s_add_i32 s46, s46, s4
		v_add3_u32 v28, s46, v42, v43
		s_add_i32 m0, s2, 0x5000
		s_mov_b32 m0, s17
		v_add_u32_e32 v29, s16, v29
		ds_write_addtid_b32 v29 offset:8192
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_mul_i32 s47, 0xc0, s14
		s_add_i32 s48, s47, s3
		s_add_i32 s48, s48, s4
		v_add3_u32 v28, s48, v42, v43
		s_add_i32 m0, s2, 0x6000
		s_mov_b32 m0, s17
		v_add_u32_e32 v29, s16, v30
		ds_write_addtid_b32 v29 offset:9216
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_mul_i32 s14, 0xe0, s14
		s_add_i32 s49, s14, s3
		s_add_i32 s49, s49, s4
		v_add3_u32 v28, s49, v42, v43
		s_add_i32 m0, s2, 0x7000
		s_mov_b32 m0, s17
		v_add_u32_e32 v29, s16, v31
		ds_write_addtid_b32 v29 offset:10240
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		s_mul_i32 s50, s0, s15
		s_lshl_b32 s50, s50, 8
		v_mul_lo_u32 v28, s15, v40
		v_add3_u32 v29, s50, v28, v43
		s_add_i32 m0, s2, 0x10000
		s_mov_b32 m0, s17
		v_add_u32_e32 v30, s16, v32
		ds_write_addtid_b32 v30 offset:11264
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_lshl_b32 s51, s15, 5
		s_add_i32 s52, s51, s50
		v_add3_u32 v29, s52, v28, v43
		s_add_i32 m0, s2, 0x11000
		v_add_u32_e32 v30, s16, v33
		s_mov_b32 s53, 0
		scratch_store_dword off, v30, s53
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_lshl_b32 s53, s15, 6
		s_add_i32 s54, s53, s50
		v_add3_u32 v29, s54, v28, v43
		s_add_i32 m0, s2, 0x12000
		v_add_u32_e32 v30, s16, v34
		s_mov_b32 s55, 0
		scratch_store_dword off, v30, s55 offset:4
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		s_mul_i32 s55, 0x60, s15
		s_add_i32 s56, s55, s50
		v_add3_u32 v29, s56, v28, v43
		s_add_i32 m0, s2, 0x13000
		v_add_u32_e32 v30, s16, v35
		s_mov_b32 s57, 0
		scratch_store_dword off, v30, s57 offset:8
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		v_mov_b32_e32 v29, 1
		s_and_saveexec_b64 s[58:59], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v30, v1, v29
		s_mov_b64 exec, s[58:59]
		s_waitcnt lgkmcnt(0)
		s_mul_i32 s57, s1, s21
		s_lshl_b32 s57, s57, 10
		s_mul_i32 s58, s24, s21
		s_lshl_b32 s58, s58, 8
		s_add_i32 s59, s57, s58
		v_lshrrev_b32_e32 v31, 7, v0
		v_mul_lo_u32 v32, s21, v31
		v_lshlrev_b32_e32 v33, 7, v32
		v_and_b32_e32 v34, 1, v0
		v_mul_lo_u32 v35, s21, v34
		v_add3_u32 v44, s59, v33, v35
		v_lshrrev_b32_e32 v45, 6, v0
		v_and_b32_e32 v45, 1, v45
		v_mul_lo_u32 v46, s21, v45
		v_lshlrev_b32_e32 v47, 6, v46
		v_lshrrev_b32_e32 v48, 5, v0
		v_and_b32_e32 v48, 1, v48
		s_mov_b32 s60, 0
		scratch_store_dword off, v48, s60 offset:12
		v_mul_lo_u32 v49, s21, v48
		v_lshlrev_b32_e32 v50, 5, v49
		v_add3_u32 v44, v44, v47, v50
		v_and_b32_e32 v27, 1, v27
		v_mul_lo_u32 v51, s21, v27
		v_lshlrev_b32_e32 v52, 4, v51
		v_and_b32_e32 v40, 1, v40
		v_mul_lo_u32 v53, s21, v40
		v_lshlrev_b32_e32 v54, 3, v53
		v_add3_u32 v44, v44, v52, v54
		v_lshrrev_b32_e32 v55, 2, v0
		v_and_b32_e32 v55, 1, v55
		v_mul_lo_u32 v56, s21, v55
		v_lshlrev_b32_e32 v56, 2, v56
		v_lshrrev_b32_e32 v57, 1, v0
		v_and_b32_e32 v57, 1, v57
		v_mul_lo_u32 v58, s21, v57
		v_lshlrev_b32_e32 v58, 1, v58
		v_add3_u32 v44, v44, v56, v58
		buffer_load_dwordx2 v[60:61], v44, s[36:39], 0 offen
		s_mul_i32 s60, s0, s22
		s_lshl_b32 s60, s60, 8
		v_mul_lo_u32 v44, s22, v31
		v_lshlrev_b32_e32 v59, 6, v44
		v_mul_lo_u32 v62, s22, v45
		v_lshlrev_b32_e32 v63, 5, v62
		v_add3_u32 v64, s60, v59, v63
		v_mul_lo_u32 v65, s22, v48
		v_lshlrev_b32_e32 v66, 4, v65
		v_mul_lo_u32 v67, s22, v27
		v_lshlrev_b32_e32 v68, 3, v67
		v_add3_u32 v64, v64, v66, v68
		v_mul_lo_u32 v69, s22, v40
		v_lshlrev_b32_e32 v70, 2, v69
		v_mul_lo_u32 v71, s22, v55
		v_lshlrev_b32_e32 v71, 1, v71
		v_add3_u32 v64, v64, v70, v71
		v_mul_lo_u32 v72, s22, v57
		v_lshlrev_b32_e32 v73, 2, v34
		v_add3_u32 v64, v64, v72, v73
		buffer_load_dword v74, v64, s[40:43], 0 offen
		s_lshl_b32 s61, s15, 7
		s_add_i32 s62, s61, s50
		v_add3_u32 v64, s62, v28, v43
		s_add_i32 m0, s2, 0x18000
		v_add_u32_e32 v36, s16, v36
		s_mov_b32 s63, 0
		scratch_store_dword off, v36, s63 offset:16
		buffer_load_dwordx4 v64, s[32:35], 0 offen lds
		s_mul_i32 s63, 0xa0, s15
		s_add_i32 s64, s63, s50
		v_add3_u32 v36, s64, v28, v43
		s_add_i32 m0, s2, 0x19000
		v_add_u32_e32 v37, s16, v37
		s_mov_b32 s65, 0
		scratch_store_dword off, v37, s65 offset:20
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_mul_i32 s65, 0xc0, s15
		s_add_i32 s66, s65, s50
		v_add3_u32 v36, s66, v28, v43
		s_add_i32 m0, s2, 0x1a000
		v_add_u32_e32 v37, s16, v38
		s_mov_b32 s67, 0
		scratch_store_dword off, v37, s67 offset:24
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_mul_i32 s15, 0xe0, s15
		s_add_i32 s67, s15, s50
		v_add3_u32 v36, s67, v28, v43
		s_add_i32 m0, s2, 0x1b000
		v_add_u32_e32 v37, s16, v39
		s_mov_b32 s16, 0
		scratch_store_dword off, v37, s16 offset:28
		buffer_load_dwordx4 v36, s[32:35], 0 offen lds
		s_lshl_b32 s16, s22, 7
		s_add_i32 s68, s16, s60
		v_lshlrev_b32_e32 v36, 4, v44
		v_lshlrev_b32_e32 v37, 3, v62
		v_add3_u32 v38, s68, v36, v37
		v_lshlrev_b32_e32 v39, 2, v65
		v_lshlrev_b32_e32 v44, 1, v67
		v_add3_u32 v38, v38, v39, v44
		v_add3_u32 v38, v38, v69, v34
		v_lshlrev_b32_e32 v62, 2, v55
		v_lshlrev_b32_e32 v64, 1, v57
		v_add3_u32 v38, v38, v62, v64
		v_lshlrev_b32_e32 v65, 4, v31
		v_lshlrev_b32_e32 v67, 3, v45
		v_lshlrev_b32_e32 v75, 2, v48
		v_add_u32_e32 v76, 32, v40
		v_lshlrev_b32_e32 v77, 1, v27
		v_xor_b32_e32 v76, v76, v77
		v_xor_b32_e32 v76, v75, v76
		v_xor_b32_e32 v76, v67, v76
		v_xor_b32_e32 v76, v65, v76
		v_mul_lo_u32 v78, s22, v76
		v_add3_u32 v79, s68, v78, v34
		v_add3_u32 v79, v79, v62, v64
		v_add_u32_e32 v80, 64, v40
		v_xor_b32_e32 v80, v80, v77
		v_xor_b32_e32 v80, v75, v80
		v_xor_b32_e32 v80, v67, v80
		v_xor_b32_e32 v80, v65, v80
		v_mul_lo_u32 v81, s22, v80
		v_add3_u32 v82, s68, v81, v34
		v_add3_u32 v82, v82, v62, v64
		v_add_u32_e32 v83, 0x60, v40
		v_xor_b32_e32 v83, v83, v77
		v_xor_b32_e32 v83, v75, v83
		v_xor_b32_e32 v83, v67, v83
		v_xor_b32_e32 v83, v65, v83
		v_mul_lo_u32 v84, s22, v83
		v_add3_u32 v85, s68, v84, v34
		v_add3_u32 v85, v85, v62, v64
		buffer_load_ubyte v86, v38, s[40:43], 0 offen
		buffer_load_ubyte v38, v79, s[40:43], 0 offen
		buffer_load_ubyte v79, v82, s[40:43], 0 offen
		buffer_load_ubyte v82, v85, s[40:43], 0 offen
		s_add_i32 s22, s3, 0x80
		s_add_i32 s22, s22, s4
		v_add3_u32 v85, s22, v42, v43
		s_add_i32 m0, s2, 0x8000
		v_add_u32_e32 v41, s23, v41
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s8, s8, 0x80
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v85, s8, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s4
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v85, s10, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s25, s25, 0x80
		s_add_i32 s25, s25, s3
		s_add_i32 s25, s25, s4
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v85, s25, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s27, s27, 0x80
		s_add_i32 s27, s27, s3
		s_add_i32 s27, s27, s4
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v85, s27, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s45, s45, 0x80
		s_add_i32 s45, s45, s3
		s_add_i32 s45, s45, s4
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v85, s45, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s47, s47, 0x80
		s_add_i32 s47, s47, s3
		s_add_i32 s47, s47, s4
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v85, s47, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 s14, s14, 0x80
		s_add_i32 s3, s14, s3
		s_add_i32 s3, s3, s4
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v85, s3, v42, v43
		s_add_i32 s4, s50, 0x80
		v_add3_u32 v87, s4, v28, v43
		v_lshlrev_b32_e32 v32, 4, v32
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s14, s51, 0x80
		s_add_i32 s14, s14, s50
		v_add3_u32 v85, s14, v28, v43
		v_lshlrev_b32_e32 v46, 3, v46
		buffer_load_dwordx4 v87, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s51, s53, 0x80
		s_add_i32 s51, s51, s50
		v_add3_u32 v87, s51, v28, v43
		v_lshlrev_b32_e32 v49, 2, v49
		buffer_load_dwordx4 v85, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s53, s55, 0x80
		s_add_i32 s53, s53, s50
		v_add3_u32 v85, s53, v28, v43
		v_lshlrev_b32_e32 v51, 1, v51
		buffer_load_dwordx4 v87, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s55, s57, 8
		s_add_i32 s55, s55, s58
		v_add3_u32 v87, s55, v32, v46
		v_add3_u32 v87, v87, v49, v51
		buffer_load_dwordx4 v85, s[32:35], 0 offen lds
		v_add3_u32 v85, v87, v53, v34
		v_add3_u32 v85, v85, v62, v64
		v_mul_lo_u32 v87, s21, v76
		v_add3_u32 v88, v34, v62, v64
		v_add3_u32 v89, v87, v88, s55
		v_mul_lo_u32 v90, s21, v80
		v_add3_u32 v91, v90, v88, s55
		v_mul_lo_u32 v92, s21, v83
		v_add3_u32 v88, v92, v88, s55
		v_add_u32_e32 v93, 0x80, v40
		v_xor_b32_e32 v93, v93, v77
		v_xor_b32_e32 v93, v75, v93
		v_xor_b32_e32 v93, v67, v93
		v_xor_b32_e32 v93, v65, v93
		v_mul_lo_u32 v94, s21, v93
		v_add3_u32 v95, s55, v94, v34
		v_add3_u32 v95, v95, v62, v64
		v_add_u32_e32 v96, 0xa0, v40
		v_xor_b32_e32 v96, v96, v77
		v_xor_b32_e32 v96, v75, v96
		v_xor_b32_e32 v96, v67, v96
		v_xor_b32_e32 v96, v65, v96
		v_mul_lo_u32 v97, s21, v96
		v_add3_u32 v98, s55, v97, v34
		v_add3_u32 v98, v98, v62, v64
		v_add_u32_e32 v99, 0xc0, v40
		v_xor_b32_e32 v99, v99, v77
		v_xor_b32_e32 v99, v75, v99
		v_xor_b32_e32 v99, v67, v99
		v_xor_b32_e32 v99, v65, v99
		v_mul_lo_u32 v100, s21, v99
		v_add3_u32 v101, s55, v100, v34
		v_add3_u32 v101, v101, v62, v64
		v_add_u32_e32 v102, 0xe0, v40
		v_xor_b32_e32 v77, v102, v77
		v_xor_b32_e32 v75, v75, v77
		v_xor_b32_e32 v67, v67, v75
		v_xor_b32_e32 v67, v65, v67
		v_mul_lo_u32 v75, s21, v67
		v_add3_u32 v77, s55, v75, v34
		v_add3_u32 v77, v77, v62, v64
		buffer_load_ubyte v102, v85, s[36:39], 0 offen
		buffer_load_ubyte v85, v89, s[36:39], 0 offen
		buffer_load_ubyte v89, v91, s[36:39], 0 offen
		buffer_load_ubyte v91, v88, s[36:39], 0 offen
		buffer_load_ubyte v88, v95, s[36:39], 0 offen
		buffer_load_ubyte v95, v98, s[36:39], 0 offen
		buffer_load_ubyte v98, v101, s[36:39], 0 offen
		buffer_load_ubyte v101, v77, s[36:39], 0 offen
		s_add_i32 s21, s60, 8
		v_add3_u32 v77, s21, v36, v37
		v_add3_u32 v77, v77, v39, v44
		v_add3_u32 v77, v77, v69, v34
		v_add3_u32 v77, v77, v62, v64
		v_add3_u32 v103, v34, v62, v64
		v_add3_u32 v104, v78, v103, s21
		v_add3_u32 v105, v81, v103, s21
		v_add3_u32 v103, v84, v103, s21
		buffer_load_ubyte v106, v77, s[40:43], 0 offen
		buffer_load_ubyte v77, v104, s[40:43], 0 offen
		buffer_load_ubyte v104, v105, s[40:43], 0 offen
		buffer_load_ubyte v105, v103, s[40:43], 0 offen
		s_add_i32 s57, s61, 0x80
		s_add_i32 s57, s57, s50
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v103, s57, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s58, s63, 0x80
		s_add_i32 s58, s58, s50
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v103, s58, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s61, s65, 0x80
		s_add_i32 s61, s61, s50
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v103, s61, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 s15, s15, s50
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v103, s15, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s16, s16, 8
		s_add_i32 s16, s16, s60
		v_add3_u32 v103, s16, v36, v37
		v_add3_u32 v103, v103, v39, v44
		v_add3_u32 v103, v103, v69, v34
		v_add3_u32 v103, v103, v62, v64
		v_add3_u32 v107, v34, v62, v64
		v_add3_u32 v108, v78, v107, s16
		v_add3_u32 v109, v81, v107, s16
		v_add3_u32 v107, v84, v107, s16
		buffer_load_ubyte v110, v103, s[40:43], 0 offen
		buffer_load_ubyte v103, v108, s[40:43], 0 offen
		buffer_load_ubyte v108, v109, s[40:43], 0 offen
		buffer_load_ubyte v109, v107, s[40:43], 0 offen
		v_readfirstlane_b32 s63, v30
		s_and_b32 s63, s63, -4
		s_add_i32 s63, s63, 4
		s_and_saveexec_b64 s[70:71], s[18:19]
.L_a4w4_kernel.loop_head_0:
		ds_read_b32 v30, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s65, v30
		s_xor_b32 s69, s63, -1
		s_add_i32 s69, s69, 1
		s_add_i32 s65, s65, s69
		s_cmp_ge_u32 s65, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_0
.L_a4w4_kernel.loop_exit_0:
		s_mov_b64 exec, s[70:71]
		v_lshlrev_b32_e32 v1, 11, v31
		v_and_b32_e32 v30, 63, v0
		v_lshrrev_b32_e32 v107, 4, v30
		v_lshlrev_b32_e32 v107, 4, v107
		v_and_b32_e32 v30, 15, v30
		v_lshlrev_b32_e32 v30, 7, v30
		v_add3_u32 v1, v1, v107, v30
		ds_read_b128 a[0:3], v1
		ds_read_b128 a[4:7], v1 offset:64
		ds_read_b128 a[8:11], v1 offset:4096
		ds_read_b128 a[12:15], v1 offset:4160
		ds_read_b128 a[16:19], v1 offset:8192
		ds_read_b128 a[20:23], v1 offset:8256
		ds_read_b128 a[24:27], v1 offset:12288
		ds_read_b128 a[28:31], v1 offset:12352
		ds_read_b128 a[32:35], v1 offset:16384
		ds_read_b128 a[36:39], v1 offset:16448
		ds_read_b128 a[40:43], v1 offset:20480
		ds_read_b128 a[44:47], v1 offset:20544
		ds_read_b128 a[48:51], v1 offset:24576
		ds_read_b128 a[52:55], v1 offset:24640
		ds_read_b128 a[56:59], v1 offset:28672
		ds_read_b128 a[60:63], v1 offset:28736
		v_add_u32_e32 v107, 0x10000, v107
		v_lshlrev_b32_e32 v111, 11, v45
		v_add3_u32 v30, v107, v111, v30
		ds_read_b128 a[64:67], v30
		ds_read_b128 a[68:71], v30 offset:64
		ds_read_b128 a[72:75], v30 offset:4096
		ds_read_b128 a[76:79], v30 offset:4160
		ds_read_b128 a[80:83], v30 offset:8192
		ds_read_b128 a[84:87], v30 offset:8256
		ds_read_b128 a[88:91], v30 offset:12288
		ds_read_b128 a[92:95], v30 offset:12352
		v_lshlrev_b32_e32 v107, 3, v0
		v_add_u32_e32 v107, 0x20000, v107
		s_waitcnt vmcnt(41)
		ds_write_b64 v107, v[60:61]
		s_and_saveexec_b64 s[70:71], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v60, v2, v29
		s_mov_b64 exec, s[70:71]
		v_lshlrev_b32_e32 v61, 2, v0
		v_add_u32_e32 v61, 0x20000, v61
		v_lshlrev_b32_e32 v111, 7, v31
		v_add_u32_e32 v111, 0x20000, v111
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s63, v60
		s_and_b32 s63, s63, -4
		s_add_i32 s63, s63, 4
		s_and_saveexec_b64 s[70:71], s[18:19]
.L_a4w4_kernel.loop_head_1:
		ds_read_b32 v60, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s65, v60
		s_xor_b32 s69, s63, -1
		s_add_i32 s69, s69, 1
		s_add_i32 s65, s65, s69
		s_cmp_ge_u32 s65, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_1
.L_a4w4_kernel.loop_exit_1:
		s_mov_b64 exec, s[70:71]
		s_waitcnt vmcnt(40)
		ds_write_b32 v61, v74 offset:2048
		s_and_saveexec_b64 s[70:71], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v3, v29
		s_mov_b64 exec, s[70:71]
		v_lshlrev_b32_e32 v60, 3, v34
		v_add_u32_e32 v74, v111, v60
		v_lshlrev_b32_e32 v48, 1, v48
		v_add_u32_e32 v111, v74, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s63, v2
		s_and_b32 s63, s63, -4
		s_add_i32 s63, s63, 4
		s_and_saveexec_b64 s[70:71], s[18:19]
.L_a4w4_kernel.loop_head_2:
		ds_read_b32 v2, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s65, v2
		s_xor_b32 s69, s63, -1
		s_add_i32 s69, s69, 1
		s_add_i32 s65, s65, s69
		s_cmp_ge_u32 s65, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_2
.L_a4w4_kernel.loop_exit_2:
		s_mov_b64 exec, s[70:71]
		v_lshlrev_b32_e32 v2, 6, v40
		v_add3_u32 v3, v111, v27, v2
		v_lshlrev_b32_e32 v111, 5, v55
		v_lshlrev_b32_e32 v112, 4, v57
		v_add3_u32 v3, v3, v111, v112
		ds_read_u8 v113, v3
		v_add3_u32 v74, v74, v2, v111
		v_add_u32_e32 v114, 4, v27
		v_xor_b32_e32 v114, v114, v48
		v_add3_u32 v74, v74, v112, v114
		ds_read_u8 v115, v74
		v_add_u32_e32 v116, 0x20000, v48
		v_add_u32_e32 v116, v116, v27
		v_lshlrev_b32_e32 v117, 3, v40
		v_add_u32_e32 v118, 32, v34
		v_xor_b32_e32 v118, v118, v64
		v_xor_b32_e32 v118, v62, v118
		v_xor_b32_e32 v118, v117, v118
		v_xor_b32_e32 v119, v65, v118
		v_lshl_add_u32 v120, v119, 3, v116
		ds_read_u8 v121, v120
		v_add_u32_e32 v122, 0x20000, v114
		v_lshl_add_u32 v119, v119, 3, v122
		ds_read_u8 v123, v119
		v_add_u32_e32 v124, 64, v34
		v_xor_b32_e32 v124, v124, v64
		v_xor_b32_e32 v124, v62, v124
		v_xor_b32_e32 v124, v117, v124
		v_xor_b32_e32 v125, v65, v124
		v_lshl_add_u32 v126, v125, 3, v116
		ds_read_u8 v127, v126
		v_lshl_add_u32 v125, v125, 3, v122
		ds_read_u8 v128, v125
		v_add_u32_e32 v129, 0x60, v34
		v_xor_b32_e32 v129, v129, v64
		v_xor_b32_e32 v129, v62, v129
		v_xor_b32_e32 v129, v117, v129
		v_xor_b32_e32 v130, v65, v129
		v_lshl_add_u32 v131, v130, 3, v116
		ds_read_u8 v132, v131
		v_lshl_add_u32 v130, v130, 3, v122
		ds_read_u8 v133, v130
		v_add_u32_e32 v134, 0x80, v34
		v_xor_b32_e32 v134, v134, v64
		v_xor_b32_e32 v134, v62, v134
		v_xor_b32_e32 v134, v117, v134
		v_xor_b32_e32 v134, v65, v134
		v_lshl_add_u32 v135, v134, 3, v116
		ds_read_u8 v136, v135
		v_lshl_add_u32 v134, v134, 3, v122
		ds_read_u8 v137, v134
		v_add_u32_e32 v138, 0xa0, v34
		v_xor_b32_e32 v138, v138, v64
		v_xor_b32_e32 v138, v62, v138
		v_xor_b32_e32 v138, v117, v138
		v_xor_b32_e32 v138, v65, v138
		v_lshl_add_u32 v139, v138, 3, v116
		ds_read_u8 v140, v139
		v_lshl_add_u32 v138, v138, 3, v122
		ds_read_u8 v141, v138
		v_add_u32_e32 v142, 0xc0, v34
		v_xor_b32_e32 v142, v142, v64
		v_xor_b32_e32 v142, v62, v142
		v_xor_b32_e32 v142, v117, v142
		v_xor_b32_e32 v142, v65, v142
		v_lshl_add_u32 v143, v142, 3, v116
		ds_read_u8 v144, v143
		v_lshl_add_u32 v142, v142, 3, v122
		ds_read_u8 v145, v142
		v_add_u32_e32 v146, 0xe0, v34
		v_xor_b32_e32 v146, v146, v64
		v_xor_b32_e32 v146, v62, v146
		v_xor_b32_e32 v117, v117, v146
		v_xor_b32_e32 v65, v65, v117
		v_lshl_add_u32 v117, v65, 3, v116
		ds_read_u8 v146, v117
		v_lshl_add_u32 v65, v65, 3, v122
		ds_read_u8 v147, v65
		v_add_u32_e32 v60, 0x20000, v60
		v_lshl_add_u32 v60, v45, 7, v60
		v_add_u32_e32 v148, v60, v48
		v_add3_u32 v148, v148, v27, v2
		v_add3_u32 v148, v148, v111, v112
		ds_read_u8 v149, v148 offset:2048
		v_add3_u32 v2, v60, v2, v111
		v_add3_u32 v2, v2, v112, v114
		ds_read_u8 v60, v2 offset:2048
		v_lshlrev_b32_e32 v111, 4, v45
		v_xor_b32_e32 v112, v111, v118
		v_lshl_add_u32 v114, v112, 3, v116
		ds_read_u8 v118, v114 offset:2048
		v_lshl_add_u32 v112, v112, 3, v122
		ds_read_u8 v150, v112 offset:2048
		v_xor_b32_e32 v124, v111, v124
		v_lshl_add_u32 v151, v124, 3, v116
		ds_read_u8 v152, v151 offset:2048
		v_lshl_add_u32 v124, v124, 3, v122
		ds_read_u8 v153, v124 offset:2048
		v_xor_b32_e32 v111, v111, v129
		v_lshl_add_u32 v116, v111, 3, v116
		ds_read_u8 v129, v116 offset:2048
		v_lshl_add_u32 v111, v111, 3, v122
		ds_read_u8 v122, v111 offset:2048
		s_mov_b32 s63, 0x100
		s_mov_b32 s65, s63
		s_mov_b32 s63, 16
		s_mov_b32 s69, s63
		s_mov_b32 s63, 0
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v154, 0x20000, v34
		v_add3_u32 v154, v154, v62, v64
		v_lshl_add_u32 v76, v76, 3, v154
		v_lshl_add_u32 v80, v80, 3, v154
		v_lshl_add_u32 v83, v83, 3, v154
		v_lshl_add_u32 v93, v93, 3, v154
		v_lshl_add_u32 v96, v96, 3, v154
		v_lshl_add_u32 v99, v99, 3, v154
		v_lshl_add_u32 v67, v67, 3, v154
		v_add3_u32 v154, v34, v62, v64
		v_add3_u32 v155, v34, v62, v64
		v_add3_u32 v156, v34, v62, v64
		v_add3_u32 v157, v34, v62, v64
		v_add3_u32 v158, v34, v62, v64
		s_mov_b32 s70, s65
		s_mov_b32 s71, s69
		v_accvgpr_write_b32 a96, v4
		v_accvgpr_write_b32 a97, v5
		v_accvgpr_write_b32 a98, v6
		v_accvgpr_write_b32 a99, v7
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
.L_a4w4_kernel.loop_head_3:
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt vmcnt(36)
		ds_add_rtn_u32 v159, v8, v29
		s_mov_b64 exec, s[72:73]
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt vmcnt(20)
		ds_add_rtn_u32 v252, v10, v29
		s_mov_b64 exec, s[72:73]
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt vmcnt(4)
		ds_add_rtn_u32 v253, v13, v29
		s_mov_b64 exec, s[72:73]
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v113, 0xff, v113
		v_and_b32_e32 v115, 0xff, v115
		v_lshlrev_b32_e32 v115, 8, v115
		v_or_b32_e32 v113, v113, v115
		v_and_b32_e32 v115, 0xff, v121
		v_lshlrev_b32_e32 v115, 16, v115
		v_and_b32_e32 v121, 0xff, v123
		v_lshlrev_b32_e32 v121, 24, v121
		v_or3_b32 v113, v113, v115, v121
		v_and_b32_e32 v115, 0xff, v127
		v_and_b32_e32 v121, 0xff, v128
		v_lshlrev_b32_e32 v121, 8, v121
		v_or_b32_e32 v115, v115, v121
		v_and_b32_e32 v121, 0xff, v132
		v_lshlrev_b32_e32 v121, 16, v121
		v_and_b32_e32 v123, 0xff, v133
		v_lshlrev_b32_e32 v123, 24, v123
		v_or3_b32 v115, v115, v121, v123
		v_and_b32_e32 v121, 0xff, v136
		v_and_b32_e32 v123, 0xff, v137
		v_lshlrev_b32_e32 v123, 8, v123
		v_or_b32_e32 v121, v121, v123
		v_and_b32_e32 v123, 0xff, v140
		v_lshlrev_b32_e32 v123, 16, v123
		v_and_b32_e32 v127, 0xff, v141
		v_lshlrev_b32_e32 v127, 24, v127
		v_or3_b32 v121, v121, v123, v127
		v_and_b32_e32 v123, 0xff, v144
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v127, 0xff, v145
		v_lshlrev_b32_e32 v127, 8, v127
		v_or_b32_e32 v123, v123, v127
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v127, 0xff, v146
		v_lshlrev_b32_e32 v127, 16, v127
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v128, 0xff, v147
		v_lshlrev_b32_e32 v128, 24, v128
		v_or3_b32 v123, v123, v127, v128
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v127, 0xff, v149
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v60, 0xff, v60
		v_lshlrev_b32_e32 v60, 8, v60
		v_or_b32_e32 v60, v127, v60
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v118, 0xff, v118
		v_lshlrev_b32_e32 v118, 16, v118
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v127, 0xff, v150
		v_lshlrev_b32_e32 v127, 24, v127
		v_or3_b32 v60, v60, v118, v127
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v118, 0xff, v152
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v127, 0xff, v153
		v_lshlrev_b32_e32 v127, 8, v127
		v_or_b32_e32 v118, v118, v127
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v127, 0xff, v129
		v_lshlrev_b32_e32 v127, 16, v127
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v122, 0xff, v122
		v_lshlrev_b32_e32 v122, 24, v122
		v_or3_b32 v118, v118, v127, v122
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v60, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v60, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v60, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v60, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v60, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v60, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v60, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v60, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v118, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v118, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v118, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v118, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v118, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v118, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v118, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v118, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v118, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v118, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v118, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v118, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v60, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v60, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v60, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v60, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v60, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v60, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v60, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v60, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v60, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v60, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v60, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[40:43], a[108:111], v60, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v60, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v60, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[44:47], a[112:115], v60, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[44:47], a[108:111], v60, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[32:35], a[100:103], v118, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v118, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v118, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v118, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[36:39], a[100:103], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[36:39], a[104:107], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[44:47], a[120:123], v118, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[44:47], a[116:119], v118, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v118, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v118, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v118, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v118, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[52:55], a[132:135], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[52:55], a[136:139], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[60:63], a[152:155], v118, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[60:63], a[148:151], v118, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[48:51], a[124:127], v60, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v60, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v60, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[56:59], a[140:143], v60, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[52:55], a[124:127], v60, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[52:55], a[128:131], v60, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[60:63], a[144:147], v60, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[60:63], a[140:143], v60, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_readfirstlane_b32 s72, v159
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_4:
		ds_read_b32 v60, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v60
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_4
.L_a4w4_kernel.loop_exit_4:
		s_mov_b64 exec, s[74:75]
		ds_read_b128 a[64:67], v30 offset:32768
		ds_read_b128 a[68:71], v30 offset:32832
		ds_read_b128 a[72:75], v30 offset:36864
		ds_read_b128 a[76:79], v30 offset:36928
		ds_read_b128 a[80:83], v30 offset:40960
		ds_read_b128 a[84:87], v30 offset:41024
		ds_read_b128 a[88:91], v30 offset:45056
		ds_read_b128 v[144:147], v30 offset:45120
		ds_write_b8 v0, v86 offset:2048
		ds_write_b8 v76, v38 offset:2048
		ds_write_b8 v80, v79 offset:2048
		ds_write_b8 v83, v82 offset:2048
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v38, v9, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s5, s65
		s_mov_b32 m0, s2
		v_add3_u32 v60, s72, v42, v43
		buffer_load_dwordx4 v60, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v38
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_5:
		ds_read_b32 v38, v9
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v38
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_5
.L_a4w4_kernel.loop_exit_5:
		s_mov_b64 exec, s[74:75]
		ds_read_u8 v38, v148 offset:2048
		ds_read_u8 v60, v2 offset:2048
		ds_read_u8 v79, v114 offset:2048
		ds_read_u8 v82, v112 offset:2048
		ds_read_u8 v86, v151 offset:2048
		ds_read_u8 v118, v124 offset:2048
		ds_read_u8 v122, v116 offset:2048
		ds_read_u8 v127, v111 offset:2048
		s_add_i32 s72, s9, s65
		s_add_i32 m0, s2, 0x1000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s11, s65
		s_add_i32 m0, s2, 0x2000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s26, s65
		s_add_i32 m0, s2, 0x3000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s44, s65
		s_add_i32 m0, s2, 0x4000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s46, s65
		s_add_i32 m0, s2, 0x5000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s48, s65
		s_add_i32 m0, s2, 0x6000
		v_add3_u32 v128, s72, v42, v43
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 s72, s49, s65
		s_add_i32 m0, s2, 0x7000
		v_add3_u32 v128, s72, v42, v43
		s_add_i32 s72, s50, s70
		v_add3_u32 v129, s72, v28, v43
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v38, 0xff, v38
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v60, 0xff, v60
		v_lshlrev_b32_e32 v60, 8, v60
		v_or_b32_e32 v38, v38, v60
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v60, 0xff, v79
		v_lshlrev_b32_e32 v60, 16, v60
		buffer_load_dwordx4 v128, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x10000
		s_add_i32 s72, s52, s70
		v_add3_u32 v79, s72, v28, v43
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v82, 0xff, v82
		v_lshlrev_b32_e32 v82, 24, v82
		v_or3_b32 v38, v38, v60, v82
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v60, 0xff, v86
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v82, 0xff, v118
		v_lshlrev_b32_e32 v82, 8, v82
		v_or_b32_e32 v60, v60, v82
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v82, 0xff, v122
		v_lshlrev_b32_e32 v82, 16, v82
		buffer_load_dwordx4 v129, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x11000
		s_add_i32 s72, s54, s70
		v_add3_u32 v86, s72, v28, v43
		buffer_load_dwordx4 v79, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x12000
		s_add_i32 s72, s56, s70
		v_add3_u32 v79, s72, v28, v43
		buffer_load_dwordx4 v86, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x13000
		s_add_i32 s72, s59, s69
		v_add3_u32 v86, s72, v33, v35
		buffer_load_dwordx4 v79, s[32:35], 0 offen lds
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v118, v15, v29
		s_mov_b64 exec, s[72:73]
		v_add3_u32 v79, v86, v47, v50
		v_add3_u32 v79, v79, v52, v54
		v_add3_u32 v79, v79, v56, v58
		buffer_load_dwordx2 v[128:129], v79, s[36:39], 0 offen
		s_add_i32 s72, s60, s71
		v_add3_u32 v79, s72, v59, v63
		v_add3_u32 v79, v79, v66, v68
		v_add3_u32 v79, v79, v70, v71
		v_add3_u32 v79, v79, v72, v73
		buffer_load_dword v122, v79, s[40:43], 0 offen
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v79, 0xff, v127
		v_lshlrev_b32_e32 v79, 24, v79
		v_or3_b32 v60, v60, v82, v79
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[0:3], a[156:159], v38, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[0:3], a[160:163], v38, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[8:11], a[176:179], v38, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[8:11], a[172:175], v38, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[4:7], a[156:159], v38, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[4:7], a[160:163], v38, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[12:15], a[176:179], v38, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[12:15], a[172:175], v38, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[0:3], a[164:167], v60, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[88:91], a[0:3], a[168:171], v60, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[88:91], a[8:11], a[184:187], v60, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[80:83], a[8:11], a[180:183], v60, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[4:7], a[164:167], v60, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], a[4:7], a[168:171], v60, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], a[12:15], a[184:187], v60, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[12:15], a[180:183], v60, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[80:83], a[16:19], a[196:199], v60, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[88:91], a[16:19], a[200:203], v60, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], a[88:91], a[24:27], a[216:219], v60, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[80:83], a[24:27], a[212:215], v60, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[20:23], a[196:199], v60, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], a[20:23], a[200:203], v60, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], a[28:31], a[216:219], v60, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[28:31], a[212:215], v60, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[16:19], a[188:191], v38, v115 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[16:19], a[192:195], v38, v115 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[24:27], a[208:211], v38, v115 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[24:27], a[204:207], v38, v115 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[20:23], a[188:191], v38, v115 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[20:23], a[192:195], v38, v115 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[28:31], a[208:211], v38, v115 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[28:31], a[204:207], v38, v115 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[32:35], a[220:223], v38, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[32:35], a[224:227], v38, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[40:43], a[240:243], v38, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[40:43], a[236:239], v38, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[36:39], a[220:223], v38, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[36:39], a[224:227], v38, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[76:79], a[44:47], a[240:243], v38, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[68:71], a[44:47], a[236:239], v38, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[80:83], a[32:35], a[228:231], v60, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], a[88:91], a[32:35], a[232:235], v60, v121 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], a[88:91], a[40:43], a[248:251], v60, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[80:83], a[40:43], a[244:247], v60, v121 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[36:39], a[228:231], v60, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], a[36:39], a[232:235], v60, v121 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], a[44:47], a[248:251], v60, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[84:87], a[44:47], a[244:247], v60, v121 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[48:51], v[224:227], v60, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], a[48:51], v[228:231], v60, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[88:91], a[56:59], v[244:247], v60, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[56:59], v[240:243], v60, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v60, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[144:147], a[52:55], v[228:231], v60, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[144:147], a[60:63], v[244:247], v60, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v60, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[64:67], a[48:51], a[252:255], v38, v123 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[48:51], v[220:223], v38, v123 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[56:59], v[236:239], v38, v123 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[56:59], v[232:235], v38, v123 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[68:71], a[52:55], a[252:255], v38, v123 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v38, v123 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v38, v123 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v38, v123 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s72, v252
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_6:
		ds_read_b32 v38, v10
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v38
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_6
.L_a4w4_kernel.loop_exit_6:
		s_mov_b64 exec, s[74:75]
		ds_read_b128 a[0:3], v1 offset:32768
		ds_read_b128 a[4:7], v1 offset:32832
		ds_read_b128 a[8:11], v1 offset:36864
		ds_read_b128 a[12:15], v1 offset:36928
		ds_read_b128 a[16:19], v1 offset:40960
		ds_read_b128 a[20:23], v1 offset:41024
		ds_read_b128 a[24:27], v1 offset:45056
		ds_read_b128 a[28:31], v1 offset:45120
		ds_read_b128 a[32:35], v1 offset:49152
		ds_read_b128 a[36:39], v1 offset:49216
		ds_read_b128 a[40:43], v1 offset:53248
		ds_read_b128 a[44:47], v1 offset:53312
		ds_read_b128 a[48:51], v1 offset:57344
		ds_read_b128 a[52:55], v1 offset:57408
		ds_read_b128 a[56:59], v1 offset:61440
		ds_read_b128 a[60:63], v1 offset:61504
		ds_read_b128 a[64:67], v30 offset:16384
		ds_read_b128 a[68:71], v30 offset:16448
		ds_read_b128 a[72:75], v30 offset:20480
		ds_read_b128 a[76:79], v30 offset:20544
		ds_read_b128 a[80:83], v30 offset:24576
		ds_read_b128 a[84:87], v30 offset:24640
		ds_read_b128 a[88:91], v30 offset:28672
		ds_read_b128 v[144:147], v30 offset:28736
		ds_write_b8 v0, v102
		ds_write_b8 v76, v85
		ds_write_b8 v80, v89
		ds_write_b8 v83, v91
		ds_write_b8 v93, v88
		ds_write_b8 v96, v95
		ds_write_b8 v99, v98
		ds_write_b8 v67, v101
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v38, v11, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s62, s70
		s_add_i32 m0, s2, 0x18000
		v_add3_u32 v60, s72, v28, v43
		buffer_load_dwordx4 v60, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v38
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_7:
		ds_read_b32 v38, v11
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v38
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_7
.L_a4w4_kernel.loop_exit_7:
		s_mov_b64 exec, s[74:75]
		ds_write_b8 v0, v106 offset:2048
		ds_write_b8 v76, v77 offset:2048
		ds_write_b8 v80, v104 offset:2048
		ds_write_b8 v83, v105 offset:2048
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v38, v12, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s64, s70
		s_add_i32 m0, s2, 0x19000
		v_add3_u32 v60, s72, v28, v43
		buffer_load_dwordx4 v60, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v38
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_8:
		ds_read_b32 v38, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v38
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_8
.L_a4w4_kernel.loop_exit_8:
		s_mov_b64 exec, s[74:75]
		ds_read_u8 v60, v3
		ds_read_u8 v77, v74
		ds_read_u8 v85, v120
		ds_read_u8 v88, v119
		ds_read_u8 v89, v126
		ds_read_u8 v91, v125
		ds_read_u8 v95, v131
		ds_read_u8 v98, v130
		ds_read_u8 v101, v135
		ds_read_u8 v102, v134
		ds_read_u8 v104, v139
		ds_read_u8 v105, v138
		ds_read_u8 v106, v143
		ds_read_u8 v113, v142
		ds_read_u8 v115, v117
		ds_read_u8 v121, v65
		ds_read_u8 v123, v148 offset:2048
		ds_read_u8 v127, v2 offset:2048
		ds_read_u8 v132, v114 offset:2048
		ds_read_u8 v133, v112 offset:2048
		ds_read_u8 v136, v151 offset:2048
		ds_read_u8 v137, v124 offset:2048
		ds_read_u8 v140, v116 offset:2048
		ds_read_u8 v141, v111 offset:2048
		s_add_i32 s72, s66, s70
		s_add_i32 m0, s2, 0x1a000
		v_add3_u32 v38, s72, v28, v43
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s72, s67, s70
		s_add_i32 m0, s2, 0x1b000
		v_add3_u32 v38, s72, v28, v43
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s72, s68, s71
		v_add3_u32 v38, s72, v36, v37
		v_add3_u32 v38, v38, v39, v44
		v_add3_u32 v38, v38, v69, v34
		v_add3_u32 v38, v38, v62, v64
		v_add3_u32 v79, v78, v154, s72
		v_add3_u32 v82, v81, v154, s72
		v_add3_u32 v149, v84, v154, s72
		buffer_load_ubyte v86, v38, s[40:43], 0 offen
		buffer_load_ubyte v38, v79, s[40:43], 0 offen
		buffer_load_ubyte v79, v82, s[40:43], 0 offen
		buffer_load_ubyte v82, v149, s[40:43], 0 offen
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v60, 0xff, v60
		v_and_b32_e32 v77, 0xff, v77
		v_lshlrev_b32_e32 v77, 8, v77
		v_or_b32_e32 v60, v60, v77
		v_and_b32_e32 v77, 0xff, v85
		v_lshlrev_b32_e32 v77, 16, v77
		v_and_b32_e32 v85, 0xff, v88
		v_lshlrev_b32_e32 v85, 24, v85
		v_or3_b32 v60, v60, v77, v85
		v_and_b32_e32 v77, 0xff, v89
		v_and_b32_e32 v85, 0xff, v91
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v77, v77, v85
		v_and_b32_e32 v85, 0xff, v95
		v_lshlrev_b32_e32 v85, 16, v85
		v_and_b32_e32 v88, 0xff, v98
		v_lshlrev_b32_e32 v88, 24, v88
		v_or3_b32 v149, v77, v85, v88
		v_and_b32_e32 v77, 0xff, v101
		v_and_b32_e32 v85, 0xff, v102
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v77, v77, v85
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v85, 0xff, v104
		v_lshlrev_b32_e32 v85, 16, v85
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v88, 0xff, v105
		v_lshlrev_b32_e32 v88, 24, v88
		v_or3_b32 v150, v77, v85, v88
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v77, 0xff, v106
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v85, 0xff, v113
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v77, v77, v85
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v85, 0xff, v115
		v_lshlrev_b32_e32 v85, 16, v85
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v88, 0xff, v121
		v_lshlrev_b32_e32 v88, 24, v88
		v_or3_b32 v113, v77, v85, v88
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v77, 0xff, v123
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v85, 0xff, v127
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v77, v77, v85
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v85, 0xff, v132
		v_lshlrev_b32_e32 v85, 16, v85
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v88, 0xff, v133
		v_lshlrev_b32_e32 v88, 24, v88
		v_or3_b32 v77, v77, v85, v88
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v85, 0xff, v136
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v88, 0xff, v137
		v_lshlrev_b32_e32 v88, 8, v88
		v_or_b32_e32 v85, v85, v88
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v88, 0xff, v140
		v_lshlrev_b32_e32 v88, 16, v88
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v89, 0xff, v141
		v_lshlrev_b32_e32 v89, 24, v89
		v_or3_b32 v85, v85, v88, v89
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v77, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v77, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v77, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v77, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v77, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v77, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v77, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v77, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v85, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v85, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v85, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v85, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v85, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[144:147], a[4:7], v[160:163], v85, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[144:147], a[12:15], v[176:179], v85, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v85, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v85, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v85, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v85, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v85, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v85, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[144:147], a[20:23], v[192:195], v85, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[144:147], a[28:31], v[208:211], v85, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v85, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v77, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v77, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v77, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v77, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v77, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v77, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v77, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v77, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v77, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v77, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v77, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[40:43], a[108:111], v77, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v77, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v77, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[44:47], a[112:115], v77, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[44:47], a[108:111], v77, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[32:35], a[100:103], v85, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v85, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v85, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v85, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[36:39], a[100:103], v85, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], a[36:39], a[104:107], v85, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], a[44:47], a[120:123], v85, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[44:47], a[116:119], v85, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v85, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v85, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v85, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v85, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[52:55], a[132:135], v85, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], a[52:55], a[136:139], v85, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], a[60:63], a[152:155], v85, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[60:63], a[148:151], v85, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[48:51], a[124:127], v77, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v77, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v77, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[56:59], a[140:143], v77, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[52:55], a[124:127], v77, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[52:55], a[128:131], v77, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[60:63], a[144:147], v77, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[60:63], a[140:143], v77, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s72, v253
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_9:
		ds_read_b32 v77, v13
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v77
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_9
.L_a4w4_kernel.loop_exit_9:
		s_mov_b64 exec, s[74:75]
		ds_read_b128 a[64:67], v30 offset:49152
		ds_read_b128 a[68:71], v30 offset:49216
		ds_read_b128 a[72:75], v30 offset:53248
		ds_read_b128 a[76:79], v30 offset:53312
		ds_read_b128 a[80:83], v30 offset:57344
		ds_read_b128 a[84:87], v30 offset:57408
		ds_read_b128 v[144:147], v30 offset:61440
		ds_read_b128 v[252:255], v30 offset:61504
		ds_write_b8 v0, v110 offset:2048
		ds_write_b8 v76, v103 offset:2048
		ds_write_b8 v80, v108 offset:2048
		ds_write_b8 v83, v109 offset:2048
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v77, v14, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s22, s65
		s_add_i32 m0, s2, 0x8000
		v_add3_u32 v85, s72, v42, v43
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v77
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_10:
		ds_read_b32 v77, v14
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v77
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_10
.L_a4w4_kernel.loop_exit_10:
		s_mov_b64 exec, s[74:75]
		ds_read_u8 v77, v148 offset:2048
		ds_read_u8 v85, v2 offset:2048
		ds_read_u8 v88, v114 offset:2048
		ds_read_u8 v89, v112 offset:2048
		ds_read_u8 v91, v151 offset:2048
		ds_read_u8 v95, v124 offset:2048
		ds_read_u8 v98, v116 offset:2048
		ds_read_u8 v103, v111 offset:2048
		s_add_i32 s72, s8, s65
		s_add_i32 m0, s2, 0x9000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s10, s65
		s_add_i32 m0, s2, 0xa000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s25, s65
		s_add_i32 m0, s2, 0xb000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s27, s65
		s_add_i32 m0, s2, 0xc000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s45, s65
		s_add_i32 m0, s2, 0xd000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s47, s65
		s_add_i32 m0, s2, 0xe000
		v_add3_u32 v101, s72, v42, v43
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 s72, s3, s65
		s_add_i32 m0, s2, 0xf000
		v_add3_u32 v101, s72, v42, v43
		s_add_i32 s72, s4, s70
		v_add3_u32 v102, s72, v28, v43
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v77, 0xff, v77
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v85, 0xff, v85
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v77, v77, v85
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v85, 0xff, v88
		v_lshlrev_b32_e32 v85, 16, v85
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_i32 m0, s2, 0x14000
		s_add_i32 s72, s14, s70
		v_add3_u32 v88, s72, v28, v43
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v89, 0xff, v89
		v_lshlrev_b32_e32 v89, 24, v89
		v_or3_b32 v108, v77, v85, v89
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v77, 0xff, v91
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v85, 0xff, v95
		v_lshlrev_b32_e32 v85, 8, v85
		v_or_b32_e32 v109, v77, v85
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v77, 0xff, v98
		v_lshlrev_b32_e32 v110, 16, v77
		buffer_load_dwordx4 v102, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x15000
		s_add_i32 s72, s51, s70
		v_add3_u32 v77, s72, v28, v43
		buffer_load_dwordx4 v88, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x16000
		s_add_i32 s72, s53, s70
		v_add3_u32 v85, s72, v28, v43
		buffer_load_dwordx4 v77, s[32:35], 0 offen lds
		s_add_i32 m0, s2, 0x17000
		s_add_i32 s72, s55, s69
		v_add3_u32 v77, s72, v32, v46
		buffer_load_dwordx4 v85, s[32:35], 0 offen lds
		v_add3_u32 v77, v77, v49, v51
		v_add3_u32 v77, v77, v53, v34
		v_add3_u32 v77, v77, v62, v64
		v_add3_u32 v85, s72, v87, v34
		v_add3_u32 v88, v85, v62, v64
		v_add3_u32 v91, v90, v155, s72
		v_add3_u32 v95, v92, v155, s72
		v_add3_u32 v98, v94, v155, s72
		v_add3_u32 v101, v97, v156, s72
		v_add3_u32 v104, v100, v156, s72
		v_add3_u32 v105, v75, v156, s72
		buffer_load_ubyte v102, v77, s[36:39], 0 offen
		buffer_load_ubyte v85, v88, s[36:39], 0 offen
		buffer_load_ubyte v89, v91, s[36:39], 0 offen
		buffer_load_ubyte v91, v95, s[36:39], 0 offen
		buffer_load_ubyte v88, v98, s[36:39], 0 offen
		buffer_load_ubyte v95, v101, s[36:39], 0 offen
		buffer_load_ubyte v98, v104, s[36:39], 0 offen
		buffer_load_ubyte v101, v105, s[36:39], 0 offen
		s_add_i32 s72, s21, s71
		v_add3_u32 v77, s72, v36, v37
		v_add3_u32 v77, v77, v39, v44
		v_add3_u32 v77, v77, v69, v34
		v_add3_u32 v77, v77, v62, v64
		v_add3_u32 v104, v78, v157, s72
		v_add3_u32 v105, v81, v157, s72
		v_add3_u32 v115, v84, v157, s72
		buffer_load_ubyte v106, v77, s[40:43], 0 offen
		buffer_load_ubyte v77, v104, s[40:43], 0 offen
		buffer_load_ubyte v104, v105, s[40:43], 0 offen
		buffer_load_ubyte v105, v115, s[40:43], 0 offen
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v103, 0xff, v103
		v_lshlrev_b32_e32 v103, 24, v103
		v_or3_b32 v103, v109, v110, v103
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[0:3], a[156:159], v108, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[72:75], a[0:3], a[160:163], v108, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[72:75], a[8:11], a[176:179], v108, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[8:11], a[172:175], v108, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[68:71], a[4:7], a[156:159], v108, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[76:79], a[4:7], a[160:163], v108, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[76:79], a[12:15], a[176:179], v108, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[68:71], a[12:15], a[172:175], v108, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[80:83], a[0:3], a[164:167], v103, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], a[0:3], a[168:171], v103, v60 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], a[8:11], a[184:187], v103, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[80:83], a[8:11], a[180:183], v103, v60 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[4:7], a[164:167], v103, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[4:7], a[168:171], v103, v60 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[252:255], a[12:15], a[184:187], v103, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[84:87], a[12:15], a[180:183], v103, v60 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[80:83], a[16:19], a[196:199], v103, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[144:147], a[16:19], a[200:203], v103, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[144:147], a[24:27], a[216:219], v103, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[80:83], a[24:27], a[212:215], v103, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[84:87], a[20:23], a[196:199], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], a[20:23], a[200:203], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], a[28:31], a[216:219], v103, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], a[84:87], a[28:31], a[212:215], v103, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[16:19], a[188:191], v108, v149 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[72:75], a[16:19], a[192:195], v108, v149 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[72:75], a[24:27], a[208:211], v108, v149 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[24:27], a[204:207], v108, v149 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[68:71], a[20:23], a[188:191], v108, v149 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[76:79], a[20:23], a[192:195], v108, v149 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[76:79], a[28:31], a[208:211], v108, v149 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[68:71], a[28:31], a[204:207], v108, v149 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[32:35], a[220:223], v108, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[72:75], a[32:35], a[224:227], v108, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[72:75], a[40:43], a[240:243], v108, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[40:43], a[236:239], v108, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[68:71], a[36:39], a[220:223], v108, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[76:79], a[36:39], a[224:227], v108, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[76:79], a[44:47], a[240:243], v108, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[68:71], a[44:47], a[236:239], v108, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[80:83], a[32:35], a[228:231], v103, v150 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[144:147], a[32:35], a[232:235], v103, v150 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[144:147], a[40:43], a[248:251], v103, v150 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[80:83], a[40:43], a[244:247], v103, v150 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], a[84:87], a[36:39], a[228:231], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[252:255], a[36:39], a[232:235], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[252:255], a[44:47], a[248:251], v103, v150 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], a[84:87], a[44:47], a[244:247], v103, v150 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[80:83], a[48:51], v[224:227], v103, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[144:147], a[48:51], v[228:231], v103, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[144:147], a[56:59], v[244:247], v103, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[80:83], a[56:59], v[240:243], v103, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[84:87], a[52:55], v[224:227], v103, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[52:55], v[228:231], v103, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[60:63], v[244:247], v103, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[84:87], a[60:63], v[240:243], v103, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[64:67], a[48:51], a[252:255], v108, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], a[48:51], v[220:223], v108, v113 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[72:75], a[56:59], v[236:239], v108, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[56:59], v[232:235], v108, v113 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[68:71], a[52:55], a[252:255], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[76:79], a[52:55], v[220:223], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[76:79], a[60:63], v[236:239], v108, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[68:71], a[60:63], v[232:235], v108, v113 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s72, v118
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_11:
		ds_read_b32 v60, v15
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v60
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_11
.L_a4w4_kernel.loop_exit_11:
		s_mov_b64 exec, s[74:75]
		ds_read_b128 a[0:3], v1
		ds_read_b128 a[4:7], v1 offset:64
		ds_read_b128 a[8:11], v1 offset:4096
		ds_read_b128 a[12:15], v1 offset:4160
		ds_read_b128 a[16:19], v1 offset:8192
		ds_read_b128 a[20:23], v1 offset:8256
		ds_read_b128 a[24:27], v1 offset:12288
		ds_read_b128 a[28:31], v1 offset:12352
		ds_read_b128 a[32:35], v1 offset:16384
		ds_read_b128 a[36:39], v1 offset:16448
		ds_read_b128 a[40:43], v1 offset:20480
		ds_read_b128 a[44:47], v1 offset:20544
		ds_read_b128 a[48:51], v1 offset:24576
		ds_read_b128 a[52:55], v1 offset:24640
		ds_read_b128 a[56:59], v1 offset:28672
		ds_read_b128 a[60:63], v1 offset:28736
		ds_read_b128 a[64:67], v30
		ds_read_b128 a[68:71], v30 offset:64
		ds_read_b128 a[72:75], v30 offset:4096
		ds_read_b128 a[76:79], v30 offset:4160
		ds_read_b128 a[80:83], v30 offset:8192
		ds_read_b128 a[84:87], v30 offset:8256
		ds_read_b128 a[88:91], v30 offset:12288
		ds_read_b128 a[92:95], v30 offset:12352
		s_waitcnt vmcnt(33)
		ds_write_b64 v107, v[128:129]
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v60, v16, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s57, s70
		s_add_i32 m0, s2, 0x1c000
		v_add3_u32 v103, s72, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v60
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_12:
		ds_read_b32 v60, v16
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v60
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_12
.L_a4w4_kernel.loop_exit_12:
		s_mov_b64 exec, s[74:75]
		s_waitcnt vmcnt(33)
		ds_write_b32 v61, v122 offset:2048
		s_and_saveexec_b64 s[72:73], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v60, v17, v29
		s_mov_b64 exec, s[72:73]
		s_add_i32 s72, s58, s70
		s_add_i32 m0, s2, 0x1d000
		v_add3_u32 v103, s72, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s72, v60
		s_and_b32 s72, s72, -4
		s_add_i32 s72, s72, 4
		s_and_saveexec_b64 s[74:75], s[18:19]
.L_a4w4_kernel.loop_head_13:
		ds_read_b32 v60, v17
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s73, v60
		s_xor_b32 s76, s72, -1
		s_add_i32 s76, s76, 1
		s_add_i32 s73, s73, s76
		s_cmp_ge_u32 s73, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_13
.L_a4w4_kernel.loop_exit_13:
		s_mov_b64 exec, s[74:75]
		ds_read_u8 v113, v3
		ds_read_u8 v115, v74
		ds_read_u8 v121, v120
		ds_read_u8 v123, v119
		ds_read_u8 v127, v126
		ds_read_u8 v128, v125
		ds_read_u8 v132, v131
		ds_read_u8 v133, v130
		ds_read_u8 v136, v135
		ds_read_u8 v137, v134
		ds_read_u8 v140, v139
		ds_read_u8 v141, v138
		ds_read_u8 v144, v143
		ds_read_u8 v145, v142
		ds_read_u8 v146, v117
		ds_read_u8 v147, v65
		ds_read_u8 v149, v148 offset:2048
		ds_read_u8 v60, v2 offset:2048
		ds_read_u8 v118, v114 offset:2048
		ds_read_u8 v150, v112 offset:2048
		ds_read_u8 v152, v151 offset:2048
		ds_read_u8 v153, v124 offset:2048
		ds_read_u8 v129, v116 offset:2048
		ds_read_u8 v122, v111 offset:2048
		s_add_i32 s72, s61, s70
		s_add_i32 m0, s2, 0x1e000
		v_add3_u32 v103, s72, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s72, s15, s70
		s_add_i32 m0, s2, 0x1f000
		v_add3_u32 v103, s72, v28, v43
		buffer_load_dwordx4 v103, s[32:35], 0 offen lds
		s_add_i32 s72, s16, s71
		v_add3_u32 v103, s72, v36, v37
		v_add3_u32 v103, v103, v39, v44
		v_add3_u32 v103, v103, v69, v34
		v_add3_u32 v103, v103, v62, v64
		v_add3_u32 v108, v78, v158, s72
		v_add3_u32 v109, v81, v158, s72
		v_add3_u32 v159, v84, v158, s72
		buffer_load_ubyte v110, v103, s[40:43], 0 offen
		buffer_load_ubyte v103, v108, s[40:43], 0 offen
		buffer_load_ubyte v108, v109, s[40:43], 0 offen
		buffer_load_ubyte v109, v159, s[40:43], 0 offen
		s_add_i32 s65, s65, 0x100
		s_add_i32 s70, s70, 0x100
		s_add_i32 s69, s69, 16
		s_add_i32 s71, s71, 16
		s_add_i32 s63, s63, 2
		s_cmp_lt_i32 s63, 62
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_3
.L_a4w4_kernel.loop_exit_3:
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, s30
		s_mov_b32 s11, s31
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v8, 0x24c34
		s_waitcnt vmcnt(4)
		ds_add_rtn_u32 v9, v8, v29
		s_mov_b64 exec, s[2:3]
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v10, 0xff, v113
		v_and_b32_e32 v11, 0xff, v115
		v_lshlrev_b32_e32 v11, 8, v11
		v_or_b32_e32 v10, v10, v11
		v_and_b32_e32 v11, 0xff, v121
		v_lshlrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v12, 0xff, v123
		v_lshlrev_b32_e32 v12, 24, v12
		v_or3_b32 v10, v10, v11, v12
		v_and_b32_e32 v11, 0xff, v127
		v_and_b32_e32 v12, 0xff, v128
		v_lshlrev_b32_e32 v12, 8, v12
		v_or_b32_e32 v11, v11, v12
		v_and_b32_e32 v12, 0xff, v132
		v_lshlrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v13, 0xff, v133
		v_lshlrev_b32_e32 v13, 24, v13
		v_or3_b32 v11, v11, v12, v13
		v_and_b32_e32 v12, 0xff, v136
		v_and_b32_e32 v13, 0xff, v137
		v_lshlrev_b32_e32 v13, 8, v13
		v_or_b32_e32 v12, v12, v13
		v_and_b32_e32 v13, 0xff, v140
		v_lshlrev_b32_e32 v13, 16, v13
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v14, 0xff, v141
		v_lshlrev_b32_e32 v14, 24, v14
		v_or3_b32 v12, v12, v13, v14
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v13, 0xff, v144
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v14, 0xff, v145
		v_lshlrev_b32_e32 v14, 8, v14
		v_or_b32_e32 v13, v13, v14
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v14, 0xff, v146
		v_lshlrev_b32_e32 v14, 16, v14
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v15, 0xff, v147
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v13, v13, v14, v15
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v14, 0xff, v149
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v15, 0xff, v60
		v_lshlrev_b32_e32 v15, 8, v15
		v_or_b32_e32 v14, v14, v15
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v15, 0xff, v118
		v_lshlrev_b32_e32 v15, 16, v15
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v16, 0xff, v150
		v_lshlrev_b32_e32 v16, 24, v16
		v_or3_b32 v14, v14, v15, v16
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v15, 0xff, v152
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v16, 0xff, v153
		v_lshlrev_b32_e32 v16, 8, v16
		v_or_b32_e32 v15, v15, v16
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v16, 0xff, v129
		v_lshlrev_b32_e32 v16, 16, v16
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v17, 0xff, v122
		v_lshlrev_b32_e32 v17, 24, v17
		v_or3_b32 v15, v15, v16, v17
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[64:67], a[0:3], v[248:251], v14, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[72:75], a[0:3], a[96:99], v14, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[72:75], a[8:11], v[168:171], v14, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[64:67], a[8:11], v[164:167], v14, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], a[68:71], a[4:7], v[248:251], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[76:79], a[4:7], a[96:99], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[76:79], a[12:15], v[168:171], v14, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[68:71], a[12:15], v[164:167], v14, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[80:83], a[0:3], v[4:7], v15, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], a[0:3], v[160:163], v15, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], a[8:11], v[176:179], v15, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[80:83], a[8:11], v[172:175], v15, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[84:87], a[4:7], v[4:7], v15, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], a[4:7], v[160:163], v15, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], a[12:15], v[176:179], v15, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[84:87], a[12:15], v[172:175], v15, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[80:83], a[16:19], v[188:191], v15, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], a[16:19], v[192:195], v15, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[88:91], a[24:27], v[208:211], v15, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[80:83], a[24:27], v[204:207], v15, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[84:87], a[20:23], v[188:191], v15, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], a[20:23], v[192:195], v15, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], a[28:31], v[208:211], v15, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[84:87], a[28:31], v[204:207], v15, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[16:19], v[180:183], v14, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[72:75], a[16:19], v[184:187], v14, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[72:75], a[24:27], v[200:203], v14, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[24:27], v[196:199], v14, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[68:71], a[20:23], v[180:183], v14, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[76:79], a[20:23], v[184:187], v14, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], a[28:31], v[200:203], v14, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[68:71], a[28:31], v[196:199], v14, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[64:67], a[32:35], v[212:215], v14, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[72:75], a[32:35], v[216:219], v14, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[72:75], a[40:43], a[112:115], v14, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[64:67], a[40:43], a[108:111], v14, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[36:39], v[212:215], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[76:79], a[36:39], v[216:219], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[76:79], a[44:47], a[112:115], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[68:71], a[44:47], a[108:111], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[80:83], a[32:35], a[100:103], v15, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[88:91], a[32:35], a[104:107], v15, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[88:91], a[40:43], a[120:123], v15, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[80:83], a[40:43], a[116:119], v15, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[84:87], a[36:39], a[100:103], v15, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[92:95], a[36:39], a[104:107], v15, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[92:95], a[44:47], a[120:123], v15, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[84:87], a[44:47], a[116:119], v15, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[80:83], a[48:51], a[132:135], v15, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[88:91], a[48:51], a[136:139], v15, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[88:91], a[56:59], a[152:155], v15, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], a[56:59], a[148:151], v15, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[84:87], a[52:55], a[132:135], v15, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[92:95], a[52:55], a[136:139], v15, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[92:95], a[60:63], a[152:155], v15, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[84:87], a[60:63], a[148:151], v15, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[64:67], a[48:51], a[124:127], v14, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[72:75], a[48:51], a[128:131], v14, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[56:59], a[144:147], v14, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[64:67], a[56:59], a[140:143], v14, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[68:71], a[52:55], a[124:127], v14, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], a[52:55], a[128:131], v14, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[76:79], a[60:63], a[144:147], v14, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[68:71], a[60:63], a[140:143], v14, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s2, v9
		s_and_b32 s2, s2, -4
		s_add_i32 s2, s2, 4
		s_and_saveexec_b64 s[4:5], s[18:19]
.L_a4w4_kernel.loop_head_14:
		ds_read_b32 v9, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v9
		s_xor_b32 s6, s2, -1
		s_add_i32 s6, s6, 1
		s_add_i32 s3, s3, s6
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_14
.L_a4w4_kernel.loop_exit_14:
		s_mov_b64 exec, s[4:5]
		ds_read_b128 v[60:63], v30 offset:32768
		ds_read_b128 a[64:67], v30 offset:32832
		ds_read_b128 v[68:71], v30 offset:36864
		ds_read_b128 a[68:71], v30 offset:36928
		ds_read_b128 v[144:147], v30 offset:40960
		ds_read_b128 v[152:155], v30 offset:41024
		ds_read_b128 v[156:159], v30 offset:45056
		ds_read_b128 v[252:255], v30 offset:45120
		ds_write_b8 v0, v86 offset:2048
		ds_write_b8 v76, v38 offset:2048
		ds_write_b8 v80, v79 offset:2048
		ds_write_b8 v83, v82 offset:2048
		s_and_saveexec_b64 s[2:3], s[18:19]
		v_mov_b32_e32 v8, 0x24c38
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v9, v8, v29
		s_mov_b64 exec, s[2:3]
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v14 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[2:3], vcc
		ds_read_addtid_b32 v14 offset:4096
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[4:5], vcc
		ds_read_addtid_b32 v14 offset:5120
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[6:7], vcc
		ds_read_addtid_b32 v14 offset:6144
		s_waitcnt lgkmcnt(0)
		v_cmp_lt_i32_e64 vcc, v14, s12
		s_mov_b64 s[14:15], vcc
		v_readfirstlane_b32 s16, v9
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[26:27], s[18:19]
.L_a4w4_kernel.loop_head_15:
		ds_read_b32 v9, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v9
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s21, s21, s22
		s_cmp_ge_u32 s21, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_15
.L_a4w4_kernel.loop_exit_15:
		s_mov_b64 exec, s[26:27]
		ds_read_u8 v8, v148 offset:2048
		ds_read_u8 v9, v2 offset:2048
		ds_read_u8 v14, v114 offset:2048
		ds_read_u8 v15, v112 offset:2048
		ds_read_u8 v16, v151 offset:2048
		ds_read_u8 v17, v124 offset:2048
		ds_read_u8 v28, v116 offset:2048
		ds_read_u8 v32, v111 offset:2048
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v8, 0xff, v8
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v9, 0xff, v9
		v_lshlrev_b32_e32 v9, 8, v9
		v_or_b32_e32 v8, v8, v9
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v9, 0xff, v14
		v_lshlrev_b32_e32 v9, 16, v9
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v14, 0xff, v15
		v_lshlrev_b32_e32 v14, 24, v14
		v_or3_b32 v8, v8, v9, v14
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v9, 0xff, v16
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v14, 0xff, v17
		v_lshlrev_b32_e32 v14, 8, v14
		v_or_b32_e32 v9, v9, v14
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v14, 0xff, v28
		v_lshlrev_b32_e32 v14, 16, v14
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v15, 0xff, v32
		v_lshlrev_b32_e32 v15, 24, v15
		v_or3_b32 v9, v9, v14, v15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[60:63], a[0:3], a[156:159], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[68:71], a[0:3], a[160:163], v8, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[68:71], a[8:11], a[176:179], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[60:63], a[8:11], a[172:175], v8, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[64:67], a[4:7], a[156:159], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[68:71], a[4:7], a[160:163], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[68:71], a[12:15], a[176:179], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[64:67], a[12:15], a[172:175], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[144:147], a[0:3], a[164:167], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[156:159], a[0:3], a[168:171], v9, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[156:159], a[8:11], a[184:187], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[144:147], a[8:11], a[180:183], v9, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[152:155], a[4:7], a[164:167], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[252:255], a[4:7], a[168:171], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[252:255], a[12:15], a[184:187], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[152:155], a[12:15], a[180:183], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[144:147], a[16:19], a[196:199], v9, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[156:159], a[16:19], a[200:203], v9, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[156:159], a[24:27], a[216:219], v9, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[144:147], a[24:27], a[212:215], v9, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[152:155], a[20:23], a[196:199], v9, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], a[20:23], a[200:203], v9, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], a[28:31], a[216:219], v9, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[152:155], a[28:31], a[212:215], v9, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[60:63], a[16:19], a[188:191], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[68:71], a[16:19], a[192:195], v8, v11 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[68:71], a[24:27], a[208:211], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], a[24:27], a[204:207], v8, v11 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[20:23], a[188:191], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[68:71], a[20:23], a[192:195], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[68:71], a[28:31], a[208:211], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[64:67], a[28:31], a[204:207], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[60:63], a[32:35], a[220:223], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[68:71], a[32:35], a[224:227], v8, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[68:71], a[40:43], a[240:243], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[60:63], a[40:43], a[236:239], v8, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], a[64:67], a[36:39], a[220:223], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], a[68:71], a[36:39], a[224:227], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], a[68:71], a[44:47], a[240:243], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], a[64:67], a[44:47], a[236:239], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[144:147], a[32:35], a[228:231], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[156:159], a[32:35], a[232:235], v9, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[156:159], a[40:43], a[248:251], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[144:147], a[40:43], a[244:247], v9, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[152:155], a[36:39], a[228:231], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[252:255], a[36:39], a[232:235], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[252:255], a[44:47], a[248:251], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[152:155], a[44:47], a[244:247], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[144:147], a[48:51], v[224:227], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[156:159], a[48:51], v[228:231], v9, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[156:159], a[56:59], v[244:247], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[144:147], a[56:59], v[240:243], v9, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[152:155], a[52:55], v[224:227], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], a[52:55], v[228:231], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[252:255], a[60:63], v[244:247], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[152:155], a[60:63], v[240:243], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[60:63], a[48:51], a[252:255], v8, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], a[48:51], v[220:223], v8, v13 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], a[56:59], v[236:239], v8, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[60:63], a[56:59], v[232:235], v8, v13 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], a[64:67], a[52:55], a[252:255], v8, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[68:71], a[52:55], v[220:223], v8, v13 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[68:71], a[60:63], v[236:239], v8, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[60:63], v[232:235], v8, v13 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v1 offset:32768
		ds_read_b128 a[0:3], v1 offset:32832
		ds_read_b128 a[4:7], v1 offset:36864
		ds_read_b128 a[8:11], v1 offset:36928
		ds_read_b128 a[12:15], v1 offset:40960
		ds_read_b128 a[16:19], v1 offset:41024
		ds_read_b128 a[20:23], v1 offset:45056
		ds_read_b128 a[24:27], v1 offset:45120
		ds_read_b128 a[28:31], v1 offset:49152
		ds_read_b128 a[32:35], v1 offset:49216
		ds_read_b128 a[36:39], v1 offset:53248
		ds_read_b128 a[40:43], v1 offset:53312
		ds_read_b128 a[44:47], v1 offset:57344
		ds_read_b128 a[48:51], v1 offset:57408
		ds_read_b128 a[52:55], v1 offset:61440
		ds_read_b128 a[56:59], v1 offset:61504
		ds_read_b128 v[12:15], v30 offset:16384
		ds_read_b128 v[36:39], v30 offset:16448
		ds_read_b128 v[60:63], v30 offset:20480
		ds_read_b128 v[68:71], v30 offset:20544
		ds_read_b128 v[144:147], v30 offset:24576
		ds_read_b128 v[152:155], v30 offset:24640
		ds_read_b128 v[156:159], v30 offset:28672
		ds_read_b128 v[252:255], v30 offset:28736
		ds_write_b8 v0, v102
		ds_write_b8 v76, v85
		ds_write_b8 v80, v89
		ds_write_b8 v83, v91
		ds_write_b8 v93, v88
		ds_write_b8 v96, v95
		ds_write_b8 v99, v98
		ds_write_b8 v67, v101
		s_and_saveexec_b64 s[26:27], s[18:19]
		v_mov_b32_e32 v1, 0x24c3c
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v16, v1, v29
		s_mov_b64 exec, s[26:27]
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[26:27], vcc
		ds_read_addtid_b32 v17 offset:8192
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[28:29], vcc
		ds_read_addtid_b32 v17 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[30:31], vcc
		ds_read_addtid_b32 v17 offset:10240
		s_waitcnt lgkmcnt(0)
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[32:33], vcc
		v_readfirstlane_b32 s16, v16
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[34:35], s[18:19]
.L_a4w4_kernel.loop_head_16:
		ds_read_b32 v16, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v16
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s21, s21, s22
		s_cmp_ge_u32 s21, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_16
.L_a4w4_kernel.loop_exit_16:
		s_mov_b64 exec, s[34:35]
		ds_write_b8 v0, v106 offset:2048
		ds_write_b8 v76, v77 offset:2048
		ds_write_b8 v80, v104 offset:2048
		ds_write_b8 v83, v105 offset:2048
		s_and_saveexec_b64 s[34:35], s[18:19]
		v_mov_b32_e32 v1, 0x24c40
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v16, v1, v29
		s_mov_b64 exec, s[34:35]
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:11264
		s_waitcnt lgkmcnt(0)
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[34:35], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v17, off, s16
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[36:37], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v17, off, s16 offset:4
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[38:39], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v17, off, s16 offset:8
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v17, s12
		s_mov_b64 s[40:41], vcc
		v_readfirstlane_b32 s16, v16
		s_and_b32 s16, s16, -4
		s_add_i32 s16, s16, 4
		s_and_saveexec_b64 s[42:43], s[18:19]
.L_a4w4_kernel.loop_head_17:
		ds_read_b32 v16, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v16
		s_xor_b32 s22, s16, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s21, s21, s22
		s_cmp_ge_u32 s21, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_17
.L_a4w4_kernel.loop_exit_17:
		s_mov_b64 exec, s[42:43]
		ds_read_u8 v1, v3
		ds_read_u8 v3, v74
		ds_read_u8 v16, v120
		ds_read_u8 v17, v119
		ds_read_u8 v28, v126
		ds_read_u8 v32, v125
		ds_read_u8 v33, v131
		ds_read_u8 v35, v130
		ds_read_u8 v42, v135
		ds_read_u8 v43, v134
		ds_read_u8 v44, v139
		ds_read_u8 v46, v138
		ds_read_u8 v47, v143
		ds_read_u8 v49, v142
		ds_read_u8 v50, v117
		ds_read_u8 v51, v65
		ds_read_u8 v52, v148 offset:2048
		ds_read_u8 v53, v2 offset:2048
		ds_read_u8 v54, v114 offset:2048
		ds_read_u8 v56, v112 offset:2048
		ds_read_u8 v58, v151 offset:2048
		ds_read_u8 v59, v124 offset:2048
		ds_read_u8 v64, v116 offset:2048
		ds_read_u8 v65, v111 offset:2048
		s_waitcnt lgkmcnt(14)
		v_and_b32_e32 v1, 0xff, v1
		v_and_b32_e32 v3, 0xff, v3
		v_lshlrev_b32_e32 v3, 8, v3
		v_or_b32_e32 v1, v1, v3
		v_and_b32_e32 v3, 0xff, v16
		v_lshlrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v16, 0xff, v17
		v_lshlrev_b32_e32 v16, 24, v16
		v_or3_b32 v1, v1, v3, v16
		v_and_b32_e32 v3, 0xff, v28
		v_and_b32_e32 v16, 0xff, v32
		v_lshlrev_b32_e32 v16, 8, v16
		v_or_b32_e32 v3, v3, v16
		v_and_b32_e32 v16, 0xff, v33
		v_lshlrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v17, 0xff, v35
		v_lshlrev_b32_e32 v17, 24, v17
		v_or3_b32 v3, v3, v16, v17
		v_and_b32_e32 v16, 0xff, v42
		v_and_b32_e32 v17, 0xff, v43
		v_lshlrev_b32_e32 v17, 8, v17
		v_or_b32_e32 v16, v16, v17
		s_waitcnt lgkmcnt(13)
		v_and_b32_e32 v17, 0xff, v44
		v_lshlrev_b32_e32 v17, 16, v17
		s_waitcnt lgkmcnt(12)
		v_and_b32_e32 v28, 0xff, v46
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v16, v16, v17, v28
		s_waitcnt lgkmcnt(11)
		v_and_b32_e32 v17, 0xff, v47
		s_waitcnt lgkmcnt(10)
		v_and_b32_e32 v28, 0xff, v49
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v17, v17, v28
		s_waitcnt lgkmcnt(9)
		v_and_b32_e32 v28, 0xff, v50
		v_lshlrev_b32_e32 v28, 16, v28
		s_waitcnt lgkmcnt(8)
		v_and_b32_e32 v32, 0xff, v51
		v_lshlrev_b32_e32 v32, 24, v32
		v_or3_b32 v17, v17, v28, v32
		s_waitcnt lgkmcnt(7)
		v_and_b32_e32 v28, 0xff, v52
		s_waitcnt lgkmcnt(6)
		v_and_b32_e32 v32, 0xff, v53
		v_lshlrev_b32_e32 v32, 8, v32
		v_or_b32_e32 v28, v28, v32
		s_waitcnt lgkmcnt(5)
		v_and_b32_e32 v32, 0xff, v54
		v_lshlrev_b32_e32 v32, 16, v32
		s_waitcnt lgkmcnt(4)
		v_and_b32_e32 v33, 0xff, v56
		v_lshlrev_b32_e32 v33, 24, v33
		v_or3_b32 v28, v28, v32, v33
		s_waitcnt lgkmcnt(3)
		v_and_b32_e32 v32, 0xff, v58
		s_waitcnt lgkmcnt(2)
		v_and_b32_e32 v33, 0xff, v59
		v_lshlrev_b32_e32 v33, 8, v33
		v_or_b32_e32 v32, v32, v33
		s_waitcnt lgkmcnt(1)
		v_and_b32_e32 v33, 0xff, v64
		v_lshlrev_b32_e32 v33, 16, v33
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v35, 0xff, v65
		v_lshlrev_b32_e32 v35, 24, v35
		v_or3_b32 v32, v32, v33, v35
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[12:15], v[8:11], v[248:251], v28, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[60:63], v[8:11], a[96:99], v28, v1 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[60:63], a[4:7], v[168:171], v28, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[12:15], a[4:7], v[164:167], v28, v1 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[248:251], v[36:39], a[0:3], v[248:251], v28, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[68:71], a[0:3], a[96:99], v28, v1 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[68:71], a[8:11], v[168:171], v28, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], a[8:11], v[164:167], v28, v1 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[144:147], v[8:11], v[4:7], v32, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[156:159], v[8:11], v[160:163], v32, v1 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[156:159], a[4:7], v[176:179], v32, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[144:147], a[4:7], v[172:175], v32, v1 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[152:155], a[0:3], v[4:7], v32, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], a[0:3], v[160:163], v32, v1 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], a[8:11], v[176:179], v32, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[152:155], a[8:11], v[172:175], v32, v1 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[144:147], a[12:15], v[188:191], v32, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[156:159], a[12:15], v[192:195], v32, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[156:159], a[20:23], v[208:211], v32, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[144:147], a[20:23], v[204:207], v32, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[152:155], a[16:19], v[188:191], v32, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], a[16:19], v[192:195], v32, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], a[24:27], v[208:211], v32, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[152:155], a[24:27], v[204:207], v32, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], a[12:15], v[180:183], v28, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], a[12:15], v[184:187], v28, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], a[20:23], v[200:203], v28, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[12:15], a[20:23], v[196:199], v28, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], a[16:19], v[180:183], v28, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[68:71], a[16:19], v[184:187], v28, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[68:71], a[24:27], v[200:203], v28, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], a[24:27], v[196:199], v28, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[12:15], a[28:31], v[212:215], v28, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[60:63], a[28:31], v[216:219], v28, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[60:63], a[36:39], a[112:115], v28, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[12:15], a[36:39], a[108:111], v28, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], a[32:35], v[212:215], v28, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], a[32:35], v[216:219], v28, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], a[40:43], a[112:115], v28, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[40:43], a[108:111], v28, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[144:147], a[28:31], a[100:103], v32, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[156:159], a[28:31], a[104:107], v32, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[156:159], a[36:39], a[120:123], v32, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[144:147], a[36:39], a[116:119], v32, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[152:155], a[32:35], a[100:103], v32, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[252:255], a[32:35], a[104:107], v32, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[252:255], a[40:43], a[120:123], v32, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[152:155], a[40:43], a[116:119], v32, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[144:147], a[44:47], a[132:135], v32, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[156:159], a[44:47], a[136:139], v32, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[156:159], a[52:55], a[152:155], v32, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[144:147], a[52:55], a[148:151], v32, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[152:155], a[48:51], a[132:135], v32, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[252:255], a[48:51], a[136:139], v32, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[252:255], a[56:59], a[152:155], v32, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[152:155], a[56:59], a[148:151], v32, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[12:15], a[44:47], a[124:127], v28, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[60:63], a[44:47], a[128:131], v28, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[60:63], a[52:55], a[144:147], v28, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[12:15], a[52:55], a[140:143], v28, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], a[48:51], a[124:127], v28, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], a[48:51], a[128:131], v28, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[68:71], a[56:59], a[144:147], v28, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[36:39], a[56:59], a[140:143], v28, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v30 offset:49152
		ds_read_b128 v[36:39], v30 offset:49216
		ds_read_b128 v[60:63], v30 offset:53248
		ds_read_b128 v[64:67], v30 offset:53312
		ds_read_b128 v[68:71], v30 offset:57344
		ds_read_b128 v[72:75], v30 offset:57408
		ds_read_b128 v[84:87], v30 offset:61440
		ds_read_b128 v[88:91], v30 offset:61504
		ds_write_b8 v0, v110 offset:2048
		ds_write_b8 v76, v103 offset:2048
		ds_write_b8 v80, v108 offset:2048
		ds_write_b8 v83, v109 offset:2048
		s_and_saveexec_b64 s[42:43], s[18:19]
		v_mov_b32_e32 v0, 0x24c44
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v28, v0, v29
		s_mov_b64 exec, s[42:43]
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v30, off, s16 offset:16
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v30, s12
		s_mov_b64 s[42:43], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v30, off, s16 offset:20
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v30, s12
		s_mov_b64 s[44:45], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v30, off, s16 offset:24
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v30, s12
		s_mov_b64 s[46:47], vcc
		s_mov_b32 s16, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v30, off, s16 offset:28
		s_waitcnt vmcnt(0)
		v_cmp_lt_i32_e64 vcc, v30, s12
		s_mov_b64 s[48:49], vcc
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v28
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[50:51], s[18:19]
.L_a4w4_kernel.loop_head_18:
		ds_read_b32 v28, v0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v28
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_18
.L_a4w4_kernel.loop_exit_18:
		s_mov_b64 exec, s[50:51]
		ds_read_u8 v0, v148 offset:2048
		ds_read_u8 v28, v2 offset:2048
		ds_read_u8 v2, v114 offset:2048
		ds_read_u8 v30, v112 offset:2048
		ds_read_u8 v32, v151 offset:2048
		ds_read_u8 v33, v124 offset:2048
		ds_read_u8 v35, v116 offset:2048
		ds_read_u8 v42, v111 offset:2048
		v_cmp_lt_i32_e64 vcc, v41, s13
		s_mov_b64 s[50:51], vcc
		v_cvt_pk_bf16_f32 v76, v248, v249
		v_cvt_pk_bf16_f32 v77, v250, v251
		v_accvgpr_read_b32 v41, a96
		v_accvgpr_read_b32 v43, a97
		v_cvt_pk_bf16_f32 v80, v41, v43
		v_accvgpr_read_b32 v41, a98
		v_accvgpr_read_b32 v43, a99
		v_cvt_pk_bf16_f32 v81, v41, v43
		v_cvt_pk_bf16_f32 v92, v4, v5
		v_cvt_pk_bf16_f32 v93, v6, v7
		v_cvt_pk_bf16_f32 v4, v160, v161
		v_cvt_pk_bf16_f32 v5, v162, v163
		v_cvt_pk_bf16_f32 v78, v164, v165
		v_cvt_pk_bf16_f32 v79, v166, v167
		v_cvt_pk_bf16_f32 v82, v168, v169
		v_cvt_pk_bf16_f32 v83, v170, v171
		v_cvt_pk_bf16_f32 v94, v172, v173
		v_cvt_pk_bf16_f32 v95, v174, v175
		v_cvt_pk_bf16_f32 v6, v176, v177
		v_cvt_pk_bf16_f32 v7, v178, v179
		v_cvt_pk_bf16_f32 v96, v180, v181
		v_cvt_pk_bf16_f32 v97, v182, v183
		v_cvt_pk_bf16_f32 v100, v184, v185
		v_cvt_pk_bf16_f32 v101, v186, v187
		v_cvt_pk_bf16_f32 v104, v188, v189
		v_cvt_pk_bf16_f32 v105, v190, v191
		v_cvt_pk_bf16_f32 v108, v192, v193
		v_cvt_pk_bf16_f32 v109, v194, v195
		v_cvt_pk_bf16_f32 v98, v196, v197
		v_cvt_pk_bf16_f32 v99, v198, v199
		v_cvt_pk_bf16_f32 v102, v200, v201
		v_cvt_pk_bf16_f32 v103, v202, v203
		v_cvt_pk_bf16_f32 v106, v204, v205
		v_cvt_pk_bf16_f32 v107, v206, v207
		v_cvt_pk_bf16_f32 v110, v208, v209
		v_cvt_pk_bf16_f32 v111, v210, v211
		v_cvt_pk_bf16_f32 v112, v212, v213
		v_cvt_pk_bf16_f32 v113, v214, v215
		v_cvt_pk_bf16_f32 v116, v216, v217
		v_cvt_pk_bf16_f32 v117, v218, v219
		v_accvgpr_read_b32 v41, a100
		v_accvgpr_read_b32 v43, a101
		v_cvt_pk_bf16_f32 v120, v41, v43
		v_accvgpr_read_b32 v41, a102
		v_accvgpr_read_b32 v43, a103
		v_cvt_pk_bf16_f32 v121, v41, v43
		v_accvgpr_read_b32 v41, a104
		v_accvgpr_read_b32 v43, a105
		v_cvt_pk_bf16_f32 v124, v41, v43
		v_accvgpr_read_b32 v41, a106
		v_accvgpr_read_b32 v43, a107
		v_cvt_pk_bf16_f32 v125, v41, v43
		v_accvgpr_read_b32 v41, a108
		v_accvgpr_read_b32 v43, a109
		v_cvt_pk_bf16_f32 v114, v41, v43
		v_accvgpr_read_b32 v41, a110
		v_accvgpr_read_b32 v43, a111
		v_cvt_pk_bf16_f32 v115, v41, v43
		v_accvgpr_read_b32 v41, a112
		v_accvgpr_read_b32 v43, a113
		v_cvt_pk_bf16_f32 v118, v41, v43
		v_accvgpr_read_b32 v41, a114
		v_accvgpr_read_b32 v43, a115
		v_cvt_pk_bf16_f32 v119, v41, v43
		v_accvgpr_read_b32 v41, a116
		v_accvgpr_read_b32 v43, a117
		v_cvt_pk_bf16_f32 v122, v41, v43
		v_accvgpr_read_b32 v41, a118
		v_accvgpr_read_b32 v43, a119
		v_cvt_pk_bf16_f32 v123, v41, v43
		v_accvgpr_read_b32 v41, a120
		v_accvgpr_read_b32 v43, a121
		v_cvt_pk_bf16_f32 v126, v41, v43
		v_accvgpr_read_b32 v41, a122
		v_accvgpr_read_b32 v43, a123
		v_cvt_pk_bf16_f32 v127, v41, v43
		v_accvgpr_read_b32 v41, a124
		v_accvgpr_read_b32 v43, a125
		v_cvt_pk_bf16_f32 v128, v41, v43
		v_accvgpr_read_b32 v41, a126
		v_accvgpr_read_b32 v43, a127
		v_cvt_pk_bf16_f32 v129, v41, v43
		v_accvgpr_read_b32 v41, a128
		v_accvgpr_read_b32 v43, a129
		v_cvt_pk_bf16_f32 v132, v41, v43
		v_accvgpr_read_b32 v41, a130
		v_accvgpr_read_b32 v43, a131
		v_cvt_pk_bf16_f32 v133, v41, v43
		v_accvgpr_read_b32 v41, a132
		v_accvgpr_read_b32 v43, a133
		v_cvt_pk_bf16_f32 v136, v41, v43
		v_accvgpr_read_b32 v41, a134
		v_accvgpr_read_b32 v43, a135
		v_cvt_pk_bf16_f32 v137, v41, v43
		v_accvgpr_read_b32 v41, a136
		v_accvgpr_read_b32 v43, a137
		v_cvt_pk_bf16_f32 v140, v41, v43
		v_accvgpr_read_b32 v41, a138
		v_accvgpr_read_b32 v43, a139
		v_cvt_pk_bf16_f32 v141, v41, v43
		v_accvgpr_read_b32 v41, a140
		v_accvgpr_read_b32 v43, a141
		v_cvt_pk_bf16_f32 v130, v41, v43
		v_accvgpr_read_b32 v41, a142
		v_accvgpr_read_b32 v43, a143
		v_cvt_pk_bf16_f32 v131, v41, v43
		v_accvgpr_read_b32 v41, a144
		v_accvgpr_read_b32 v43, a145
		v_cvt_pk_bf16_f32 v134, v41, v43
		v_accvgpr_read_b32 v41, a146
		v_accvgpr_read_b32 v43, a147
		v_cvt_pk_bf16_f32 v135, v41, v43
		v_accvgpr_read_b32 v41, a148
		v_accvgpr_read_b32 v43, a149
		v_cvt_pk_bf16_f32 v138, v41, v43
		v_accvgpr_read_b32 v41, a150
		v_accvgpr_read_b32 v43, a151
		v_cvt_pk_bf16_f32 v139, v41, v43
		v_accvgpr_read_b32 v41, a152
		v_accvgpr_read_b32 v43, a153
		v_cvt_pk_bf16_f32 v142, v41, v43
		v_accvgpr_read_b32 v41, a154
		v_accvgpr_read_b32 v43, a155
		s_mov_b32 m0, s17
		v_cvt_pk_bf16_f32 v143, v41, v43
		ds_read_addtid_b32 v41 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v41, 0x20000, v41
		ds_write_b128 v41, v[76:79] offset:3072
		ds_write_b128 v41, v[80:83] offset:7168
		ds_write_b128 v41, v[92:95] offset:11264
		ds_write_b128 v41, v[4:7] offset:15360
		s_and_saveexec_b64 s[52:53], s[18:19]
		v_mov_b32_e32 v4, 0x24c48
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v5, v4, v29
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v6
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v6, 4, v6
		v_add_u32_e32 v6, 0x20000, v6
		v_lshl_add_u32 v6, v34, 9, v6
		v_lshl_add_u32 v6, v40, 13, v6
		v_readfirstlane_b32 s12, v5
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[52:53], s[18:19]
.L_a4w4_kernel.loop_head_19:
		ds_read_b32 v5, v4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v5
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_19
.L_a4w4_kernel.loop_exit_19:
		s_mov_b64 exec, s[52:53]
		v_lshl_add_u32 v4, v55, 12, v6
		v_lshl_add_u32 v4, v57, 10, v4
		ds_read_b128 v[76:79], v4 offset:3072
		ds_read_b128 v[80:83], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[92:93], v[76:77]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[94:95], v[80:81]
		v_mov_b64_e32 v[144:145], v[78:79]
		v_mov_b64_e32 v[146:147], v[82:83]
		ds_read_b128 v[76:79], v4 offset:5120
		ds_read_b128 v[80:83], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[148:149], v[76:77]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[150:151], v[80:81]
		v_mov_b64_e32 v[152:153], v[78:79]
		v_mov_b64_e32 v[154:155], v[82:83]
		s_and_saveexec_b64 s[52:53], s[18:19]
		v_mov_b32_e32 v5, 0x24c4c
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[52:53]
		s_and_b32 s52, s2, s50
		s_and_b32 s53, s3, s51
		s_lshl_b32 s0, s0, 9
		v_lshlrev_b32_e32 v7, 4, v34
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_20:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_20
.L_a4w4_kernel.loop_exit_20:
		s_mov_b64 exec, s[54:55]
		ds_write_b128 v41, v[96:99] offset:3072
		ds_write_b128 v41, v[100:103] offset:7168
		ds_write_b128 v41, v[104:107] offset:11264
		ds_write_b128 v41, v[108:111] offset:15360
		s_and_saveexec_b64 s[54:55], s[18:19]
		v_mov_b32_e32 v5, 0x24c50
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[54:55]
		v_lshlrev_b32_e32 v34, 7, v40
		v_lshlrev_b32_e32 v40, 6, v55
		v_lshlrev_b32_e32 v43, 5, v57
		v_mov_b32_e32 v44, 0x80000000
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_21:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_21
.L_a4w4_kernel.loop_exit_21:
		s_mov_b64 exec, s[54:55]
		ds_read_b128 v[52:55], v4 offset:3072
		ds_read_b128 v[56:59], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[76:77], v[52:53]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[78:79], v[56:57]
		v_mov_b64_e32 v[80:81], v[54:55]
		v_mov_b64_e32 v[82:83], v[58:59]
		ds_read_b128 v[52:55], v4 offset:5120
		ds_read_b128 v[56:59], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[96:97], v[52:53]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[98:99], v[56:57]
		v_mov_b64_e32 v[100:101], v[54:55]
		v_mov_b64_e32 v[102:103], v[58:59]
		s_and_saveexec_b64 s[54:55], s[18:19]
		v_mov_b32_e32 v5, 0x24c54
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[54:55]
		v_lshlrev_b32_e32 v46, 3, v31
		v_lshlrev_b32_e32 v47, 2, v45
		v_add_u32_e32 v49, 16, v27
		v_xor_b32_e32 v49, v49, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_22:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_22
.L_a4w4_kernel.loop_exit_22:
		s_mov_b64 exec, s[54:55]
		ds_write_b128 v41, v[112:115] offset:3072
		ds_write_b128 v41, v[116:119] offset:7168
		ds_write_b128 v41, v[120:123] offset:11264
		ds_write_b128 v41, v[124:127] offset:15360
		s_and_saveexec_b64 s[54:55], s[18:19]
		v_mov_b32_e32 v5, 0x24c58
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[54:55]
		v_xor_b32_e32 v49, v47, v49
		v_xor_b32_e32 v49, v46, v49
		v_add_u32_e32 v50, 32, v27
		v_xor_b32_e32 v50, v50, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_23:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_23
.L_a4w4_kernel.loop_exit_23:
		s_mov_b64 exec, s[54:55]
		ds_read_b128 v[52:55], v4 offset:3072
		ds_read_b128 v[56:59], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[104:105], v[52:53]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[106:107], v[56:57]
		v_mov_b64_e32 v[108:109], v[54:55]
		v_mov_b64_e32 v[110:111], v[58:59]
		ds_read_b128 v[52:55], v4 offset:5120
		ds_read_b128 v[56:59], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[112:113], v[52:53]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[114:115], v[56:57]
		v_mov_b64_e32 v[116:117], v[54:55]
		v_mov_b64_e32 v[118:119], v[58:59]
		s_and_saveexec_b64 s[54:55], s[18:19]
		v_mov_b32_e32 v5, 0x24c5c
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[54:55]
		v_xor_b32_e32 v50, v47, v50
		v_xor_b32_e32 v50, v46, v50
		v_add_u32_e32 v51, 48, v27
		v_xor_b32_e32 v51, v51, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_24:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_24
.L_a4w4_kernel.loop_exit_24:
		s_mov_b64 exec, s[54:55]
		ds_write_b128 v41, v[128:131] offset:3072
		ds_write_b128 v41, v[132:135] offset:7168
		ds_write_b128 v41, v[136:139] offset:11264
		ds_write_b128 v41, v[140:143] offset:15360
		s_and_saveexec_b64 s[54:55], s[18:19]
		v_mov_b32_e32 v5, 0x24c60
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v6, v5, v29
		s_mov_b64 exec, s[54:55]
		v_xor_b32_e32 v51, v47, v51
		v_xor_b32_e32 v51, v46, v51
		v_add_u32_e32 v52, 64, v27
		v_xor_b32_e32 v52, v52, v48
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v6
		s_and_b32 s12, s12, -4
		s_add_i32 s12, s12, 4
		s_and_saveexec_b64 s[54:55], s[18:19]
.L_a4w4_kernel.loop_head_25:
		ds_read_b32 v6, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s21, s12, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_25
.L_a4w4_kernel.loop_exit_25:
		s_mov_b64 exec, s[54:55]
		ds_read_b128 v[56:59], v4 offset:3072
		ds_read_b128 v[120:123], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[124:125], v[56:57]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[126:127], v[120:121]
		v_mov_b64_e32 v[128:129], v[58:59]
		v_mov_b64_e32 v[130:131], v[122:123]
		ds_read_b128 v[56:59], v4 offset:5120
		ds_read_b128 v[120:123], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[132:133], v[56:57]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[134:135], v[120:121]
		v_mov_b64_e32 v[136:137], v[58:59]
		v_mov_b64_e32 v[138:139], v[122:123]
		s_and_saveexec_b64 s[54:55], s[18:19]
		ds_add_rtn_u32 v5, v18, v29
		s_mov_b64 exec, s[54:55]
		s_mul_i32 s1, s1, s20
		s_lshl_b32 s1, s1, 11
		s_add_i32 s12, s0, s1
		s_mul_i32 s16, s24, s20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s21, v5
		s_and_b32 s21, s21, -4
		s_add_i32 s21, s21, 4
		s_and_saveexec_b64 s[24:25], s[18:19]
.L_a4w4_kernel.loop_head_26:
		ds_read_b32 v5, v18
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v5
		s_xor_b32 s54, s21, -1
		s_add_i32 s54, s54, 1
		s_add_i32 s22, s22, s54
		s_cmp_ge_u32 s22, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_26
.L_a4w4_kernel.loop_exit_26:
		s_mov_b64 exec, s[24:25]
		s_lshl_b32 s16, s16, 9
		s_add_i32 s12, s12, s16
		v_mul_lo_u32 v5, s20, v31
		v_lshlrev_b32_e32 v5, 4, v5
		v_mul_lo_u32 v6, s20, v45
		v_lshlrev_b32_e32 v6, 3, v6
		v_add3_u32 v18, s12, v5, v6
		s_mov_b32 s21, 0
		scratch_load_dword v31, off, s21 offset:12
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v31, s20, v31
		v_lshlrev_b32_e32 v31, 2, v31
		v_mul_lo_u32 v45, s20, v27
		v_lshlrev_b32_e32 v45, 1, v45
		v_add3_u32 v18, v18, v31, v45
		v_add3_u32 v18, v18, v7, v34
		v_add3_u32 v18, v18, v40, v43
		v_cndmask_b32_e64 v18, v44, v18, s[52:53]
		buffer_store_dwordx4 v[92:95], v18, s[8:11], 0 offen
		s_and_b32 s24, s4, s50
		s_and_b32 s25, s5, s51
		v_mul_lo_u32 v18, s20, v49
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v49, s12, v18
		v_add3_u32 v49, v49, v7, v34
		v_add3_u32 v49, v49, v40, v43
		v_cndmask_b32_e64 v49, v44, v49, s[24:25]
		buffer_store_dwordx4 v[148:151], v49, s[8:11], 0 offen
		s_and_b32 s24, s6, s50
		s_and_b32 s25, s7, s51
		v_mul_lo_u32 v49, s20, v50
		v_lshlrev_b32_e32 v49, 1, v49
		v_add_u32_e32 v50, s12, v49
		v_add3_u32 v50, v50, v7, v34
		v_add3_u32 v50, v50, v40, v43
		v_cndmask_b32_e64 v50, v44, v50, s[24:25]
		buffer_store_dwordx4 v[144:147], v50, s[8:11], 0 offen
		s_and_b32 s24, s14, s50
		s_and_b32 s25, s15, s51
		v_mul_lo_u32 v50, s20, v51
		v_lshlrev_b32_e32 v50, 1, v50
		v_add_u32_e32 v51, s12, v50
		v_add3_u32 v51, v51, v7, v34
		v_add3_u32 v51, v51, v40, v43
		v_cndmask_b32_e64 v51, v44, v51, s[24:25]
		buffer_store_dwordx4 v[152:155], v51, s[8:11], 0 offen
		s_and_b32 s24, s26, s50
		s_and_b32 s25, s27, s51
		v_xor_b32_e32 v51, v47, v52
		v_xor_b32_e32 v51, v46, v51
		v_mul_lo_u32 v51, s20, v51
		v_lshlrev_b32_e32 v51, 1, v51
		v_add_u32_e32 v52, s12, v51
		v_add3_u32 v52, v52, v7, v34
		v_add3_u32 v52, v52, v40, v43
		v_cndmask_b32_e64 v52, v44, v52, s[24:25]
		buffer_store_dwordx4 v[76:79], v52, s[8:11], 0 offen
		s_and_b32 s24, s28, s50
		s_and_b32 s25, s29, s51
		v_add_u32_e32 v52, 0x50, v27
		v_xor_b32_e32 v52, v52, v48
		v_xor_b32_e32 v52, v47, v52
		v_xor_b32_e32 v52, v46, v52
		v_mul_lo_u32 v52, s20, v52
		v_lshlrev_b32_e32 v52, 1, v52
		v_add_u32_e32 v53, s12, v52
		v_add3_u32 v53, v53, v7, v34
		v_add3_u32 v53, v53, v40, v43
		v_cndmask_b32_e64 v53, v44, v53, s[24:25]
		buffer_store_dwordx4 v[96:99], v53, s[8:11], 0 offen
		s_and_b32 s24, s30, s50
		s_and_b32 s25, s31, s51
		v_add_u32_e32 v53, 0x60, v27
		v_xor_b32_e32 v53, v53, v48
		v_xor_b32_e32 v53, v47, v53
		v_xor_b32_e32 v53, v46, v53
		v_mul_lo_u32 v53, s20, v53
		v_lshlrev_b32_e32 v53, 1, v53
		v_add_u32_e32 v54, s12, v53
		v_add3_u32 v54, v54, v7, v34
		v_add3_u32 v54, v54, v40, v43
		v_cndmask_b32_e64 v54, v44, v54, s[24:25]
		buffer_store_dwordx4 v[80:83], v54, s[8:11], 0 offen
		s_and_b32 s24, s32, s50
		s_and_b32 s25, s33, s51
		v_add_u32_e32 v54, 0x70, v27
		v_xor_b32_e32 v54, v54, v48
		v_xor_b32_e32 v54, v47, v54
		v_xor_b32_e32 v54, v46, v54
		v_mul_lo_u32 v54, s20, v54
		v_lshlrev_b32_e32 v54, 1, v54
		v_add_u32_e32 v55, s12, v54
		v_add3_u32 v55, v55, v7, v34
		v_add3_u32 v55, v55, v40, v43
		v_cndmask_b32_e64 v55, v44, v55, s[24:25]
		buffer_store_dwordx4 v[100:103], v55, s[8:11], 0 offen
		s_and_b32 s24, s34, s50
		s_and_b32 s25, s35, s51
		v_add_u32_e32 v55, 0x80, v27
		v_xor_b32_e32 v55, v55, v48
		v_xor_b32_e32 v55, v47, v55
		v_xor_b32_e32 v55, v46, v55
		v_mul_lo_u32 v55, s20, v55
		v_lshlrev_b32_e32 v55, 1, v55
		v_add_u32_e32 v56, s12, v55
		v_add3_u32 v56, v56, v7, v34
		v_add3_u32 v56, v56, v40, v43
		v_cndmask_b32_e64 v56, v44, v56, s[24:25]
		buffer_store_dwordx4 v[104:107], v56, s[8:11], 0 offen
		s_and_b32 s24, s36, s50
		s_and_b32 s25, s37, s51
		v_add_u32_e32 v56, 0x90, v27
		v_xor_b32_e32 v56, v56, v48
		v_xor_b32_e32 v56, v47, v56
		v_xor_b32_e32 v56, v46, v56
		v_mul_lo_u32 v56, s20, v56
		v_lshlrev_b32_e32 v56, 1, v56
		v_add_u32_e32 v57, s12, v56
		v_add3_u32 v57, v57, v7, v34
		v_add3_u32 v57, v57, v40, v43
		v_cndmask_b32_e64 v57, v44, v57, s[24:25]
		buffer_store_dwordx4 v[112:115], v57, s[8:11], 0 offen
		s_and_b32 s24, s38, s50
		s_and_b32 s25, s39, s51
		v_add_u32_e32 v57, 0xa0, v27
		v_xor_b32_e32 v57, v57, v48
		v_xor_b32_e32 v57, v47, v57
		v_xor_b32_e32 v57, v46, v57
		v_mul_lo_u32 v57, s20, v57
		v_lshlrev_b32_e32 v57, 1, v57
		v_add_u32_e32 v58, s12, v57
		v_add3_u32 v58, v58, v7, v34
		v_add3_u32 v58, v58, v40, v43
		v_cndmask_b32_e64 v58, v44, v58, s[24:25]
		buffer_store_dwordx4 v[108:111], v58, s[8:11], 0 offen
		s_and_b32 s24, s40, s50
		s_and_b32 s25, s41, s51
		v_add_u32_e32 v58, 0xb0, v27
		v_xor_b32_e32 v58, v58, v48
		v_xor_b32_e32 v58, v47, v58
		v_xor_b32_e32 v58, v46, v58
		v_mul_lo_u32 v58, s20, v58
		v_lshlrev_b32_e32 v58, 1, v58
		v_add_u32_e32 v59, s12, v58
		v_add3_u32 v59, v59, v7, v34
		v_add3_u32 v59, v59, v40, v43
		v_cndmask_b32_e64 v59, v44, v59, s[24:25]
		buffer_store_dwordx4 v[116:119], v59, s[8:11], 0 offen
		s_and_b32 s24, s42, s50
		s_and_b32 s25, s43, s51
		v_add_u32_e32 v59, 0xc0, v27
		v_xor_b32_e32 v59, v59, v48
		v_xor_b32_e32 v59, v47, v59
		v_xor_b32_e32 v59, v46, v59
		v_mul_lo_u32 v59, s20, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add_u32_e32 v76, s12, v59
		v_add3_u32 v76, v76, v7, v34
		v_add3_u32 v76, v76, v40, v43
		v_cndmask_b32_e64 v76, v44, v76, s[24:25]
		buffer_store_dwordx4 v[124:127], v76, s[8:11], 0 offen
		s_and_b32 s24, s44, s50
		s_and_b32 s25, s45, s51
		v_add_u32_e32 v76, 0xd0, v27
		v_xor_b32_e32 v76, v76, v48
		v_xor_b32_e32 v76, v47, v76
		v_xor_b32_e32 v76, v46, v76
		v_mul_lo_u32 v76, s20, v76
		v_lshlrev_b32_e32 v76, 1, v76
		v_add_u32_e32 v77, s12, v76
		v_add3_u32 v77, v77, v7, v34
		v_add3_u32 v77, v77, v40, v43
		v_cndmask_b32_e64 v77, v44, v77, s[24:25]
		buffer_store_dwordx4 v[132:135], v77, s[8:11], 0 offen
		s_and_b32 s24, s46, s50
		s_and_b32 s25, s47, s51
		v_add_u32_e32 v77, 0xe0, v27
		v_xor_b32_e32 v77, v77, v48
		v_xor_b32_e32 v77, v47, v77
		v_xor_b32_e32 v77, v46, v77
		v_mul_lo_u32 v77, s20, v77
		v_lshlrev_b32_e32 v77, 1, v77
		v_add_u32_e32 v78, s12, v77
		v_add3_u32 v78, v78, v7, v34
		v_add3_u32 v78, v78, v40, v43
		v_cndmask_b32_e64 v78, v44, v78, s[24:25]
		buffer_store_dwordx4 v[128:131], v78, s[8:11], 0 offen
		s_and_b32 s24, s48, s50
		s_and_b32 s25, s49, s51
		v_add_u32_e32 v27, 0xf0, v27
		v_xor_b32_e32 v27, v27, v48
		v_xor_b32_e32 v27, v47, v27
		v_xor_b32_e32 v27, v46, v27
		v_mul_lo_u32 v27, s20, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_add_u32_e32 v46, s12, v27
		v_add3_u32 v46, v46, v7, v34
		v_add3_u32 v46, v46, v40, v43
		v_cndmask_b32_e64 v46, v44, v46, s[24:25]
		buffer_store_dwordx4 v[136:139], v46, s[8:11], 0 offen
		v_and_b32_e32 v0, 0xff, v0
		v_and_b32_e32 v28, 0xff, v28
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v0, v0, v28
		v_and_b32_e32 v2, 0xff, v2
		v_lshlrev_b32_e32 v2, 16, v2
		v_and_b32_e32 v28, 0xff, v30
		v_lshlrev_b32_e32 v28, 24, v28
		v_or3_b32 v0, v0, v2, v28
		v_and_b32_e32 v2, 0xff, v32
		v_and_b32_e32 v28, 0xff, v33
		v_lshlrev_b32_e32 v28, 8, v28
		v_or_b32_e32 v2, v2, v28
		v_and_b32_e32 v28, 0xff, v35
		v_lshlrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v30, 0xff, v42
		v_lshlrev_b32_e32 v30, 24, v30
		v_or3_b32 v2, v2, v28, v30
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[12:15], v[8:11], a[156:159], v0, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[60:63], v[8:11], a[160:163], v0, v1 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[60:63], a[4:7], a[176:179], v0, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[12:15], a[4:7], a[172:175], v0, v1 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], a[0:3], a[156:159], v0, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[64:67], a[0:3], a[160:163], v0, v1 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[64:67], a[8:11], a[176:179], v0, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], a[8:11], a[172:175], v0, v1 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[68:71], v[8:11], a[164:167], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], v[8:11], a[168:171], v2, v1 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[84:87], a[4:7], a[184:187], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[68:71], a[4:7], a[180:183], v2, v1 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[72:75], a[0:3], a[164:167], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[88:91], a[0:3], a[168:171], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[88:91], a[8:11], a[184:187], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[72:75], a[8:11], a[180:183], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[68:71], a[12:15], a[196:199], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[84:87], a[12:15], a[200:203], v2, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[84:87], a[20:23], a[216:219], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[68:71], a[20:23], a[212:215], v2, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[72:75], a[16:19], a[196:199], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[88:91], a[16:19], a[200:203], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[88:91], a[24:27], a[216:219], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[72:75], a[24:27], a[212:215], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[12:15], a[12:15], a[188:191], v0, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[60:63], a[12:15], a[192:195], v0, v3 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[60:63], a[20:23], a[208:211], v0, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[12:15], a[20:23], a[204:207], v0, v3 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], a[16:19], a[188:191], v0, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[64:67], a[16:19], a[192:195], v0, v3 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[64:67], a[24:27], a[208:211], v0, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], a[24:27], a[204:207], v0, v3 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[12:15], a[28:31], a[220:223], v0, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[60:63], a[28:31], a[224:227], v0, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[60:63], a[36:39], a[240:243], v0, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[12:15], a[36:39], a[236:239], v0, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], a[32:35], a[220:223], v0, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[64:67], a[32:35], a[224:227], v0, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[64:67], a[40:43], a[240:243], v0, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], a[40:43], a[236:239], v0, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[68:71], a[28:31], a[228:231], v2, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[84:87], a[28:31], a[232:235], v2, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[84:87], a[36:39], a[248:251], v2, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[68:71], a[36:39], a[244:247], v2, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[72:75], a[32:35], a[228:231], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[88:91], a[32:35], a[232:235], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[88:91], a[40:43], a[248:251], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[72:75], a[40:43], a[244:247], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], a[44:47], v[224:227], v2, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[84:87], a[44:47], v[228:231], v2, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[84:87], a[52:55], v[244:247], v2, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[68:71], a[52:55], v[240:243], v2, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[72:75], a[48:51], v[224:227], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[88:91], a[48:51], v[228:231], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[88:91], a[56:59], v[244:247], v2, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[72:75], a[56:59], v[240:243], v2, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[12:15], a[44:47], a[252:255], v0, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[60:63], a[44:47], v[220:223], v0, v17 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[60:63], a[52:55], v[236:239], v0, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[12:15], a[52:55], v[232:235], v0, v17 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], a[48:51], a[252:255], v0, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], a[48:51], v[220:223], v0, v17 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], a[56:59], v[236:239], v0, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], a[56:59], v[232:235], v0, v17 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s17
		s_add_i32 s12, s23, 0x80
		ds_read_addtid_b32 v0 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v0, s12, v0
		v_cmp_lt_i32_e64 vcc, v0, s13
		s_mov_b64 s[20:21], vcc
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v1, a157
		v_cvt_pk_bf16_f32 v8, v0, v1
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v1, a159
		v_cvt_pk_bf16_f32 v9, v0, v1
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v1, a161
		v_cvt_pk_bf16_f32 v12, v0, v1
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v1, a163
		v_cvt_pk_bf16_f32 v13, v0, v1
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v1, a165
		v_cvt_pk_bf16_f32 v36, v0, v1
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v1, a167
		v_cvt_pk_bf16_f32 v37, v0, v1
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v1, a169
		v_cvt_pk_bf16_f32 v60, v0, v1
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v1, a171
		v_cvt_pk_bf16_f32 v61, v0, v1
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v1, a173
		v_cvt_pk_bf16_f32 v10, v0, v1
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v1, a175
		v_cvt_pk_bf16_f32 v11, v0, v1
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v1, a177
		v_cvt_pk_bf16_f32 v14, v0, v1
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v1, a179
		v_cvt_pk_bf16_f32 v15, v0, v1
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v1, a181
		v_cvt_pk_bf16_f32 v38, v0, v1
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v1, a183
		v_cvt_pk_bf16_f32 v39, v0, v1
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v1, a185
		v_cvt_pk_bf16_f32 v62, v0, v1
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v1, a187
		v_cvt_pk_bf16_f32 v63, v0, v1
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v1, a189
		v_cvt_pk_bf16_f32 v64, v0, v1
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v1, a191
		v_cvt_pk_bf16_f32 v65, v0, v1
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v1, a193
		v_cvt_pk_bf16_f32 v68, v0, v1
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v1, a195
		v_cvt_pk_bf16_f32 v69, v0, v1
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v1, a197
		v_cvt_pk_bf16_f32 v72, v0, v1
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v1, a199
		v_cvt_pk_bf16_f32 v73, v0, v1
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v1, a201
		v_cvt_pk_bf16_f32 v80, v0, v1
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v1, a203
		v_cvt_pk_bf16_f32 v81, v0, v1
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v1, a205
		v_cvt_pk_bf16_f32 v66, v0, v1
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v1, a207
		v_cvt_pk_bf16_f32 v67, v0, v1
		v_accvgpr_read_b32 v0, a208
		v_accvgpr_read_b32 v1, a209
		v_cvt_pk_bf16_f32 v70, v0, v1
		v_accvgpr_read_b32 v0, a210
		v_accvgpr_read_b32 v1, a211
		v_cvt_pk_bf16_f32 v71, v0, v1
		v_accvgpr_read_b32 v0, a212
		v_accvgpr_read_b32 v1, a213
		v_cvt_pk_bf16_f32 v74, v0, v1
		v_accvgpr_read_b32 v0, a214
		v_accvgpr_read_b32 v1, a215
		v_cvt_pk_bf16_f32 v75, v0, v1
		v_accvgpr_read_b32 v0, a216
		v_accvgpr_read_b32 v1, a217
		v_cvt_pk_bf16_f32 v82, v0, v1
		v_accvgpr_read_b32 v0, a218
		v_accvgpr_read_b32 v1, a219
		v_cvt_pk_bf16_f32 v83, v0, v1
		v_accvgpr_read_b32 v0, a220
		v_accvgpr_read_b32 v1, a221
		v_cvt_pk_bf16_f32 v84, v0, v1
		v_accvgpr_read_b32 v0, a222
		v_accvgpr_read_b32 v1, a223
		v_cvt_pk_bf16_f32 v85, v0, v1
		v_accvgpr_read_b32 v0, a224
		v_accvgpr_read_b32 v1, a225
		v_cvt_pk_bf16_f32 v88, v0, v1
		v_accvgpr_read_b32 v0, a226
		v_accvgpr_read_b32 v1, a227
		v_cvt_pk_bf16_f32 v89, v0, v1
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v1, a229
		v_cvt_pk_bf16_f32 v92, v0, v1
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v1, a231
		v_cvt_pk_bf16_f32 v93, v0, v1
		v_accvgpr_read_b32 v0, a232
		v_accvgpr_read_b32 v1, a233
		v_cvt_pk_bf16_f32 v96, v0, v1
		v_accvgpr_read_b32 v0, a234
		v_accvgpr_read_b32 v1, a235
		v_cvt_pk_bf16_f32 v97, v0, v1
		v_accvgpr_read_b32 v0, a236
		v_accvgpr_read_b32 v1, a237
		v_cvt_pk_bf16_f32 v86, v0, v1
		v_accvgpr_read_b32 v0, a238
		v_accvgpr_read_b32 v1, a239
		v_cvt_pk_bf16_f32 v87, v0, v1
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v1, a241
		v_cvt_pk_bf16_f32 v90, v0, v1
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v1, a243
		v_cvt_pk_bf16_f32 v91, v0, v1
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v1, a245
		v_cvt_pk_bf16_f32 v94, v0, v1
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v1, a247
		v_cvt_pk_bf16_f32 v95, v0, v1
		v_accvgpr_read_b32 v0, a248
		v_accvgpr_read_b32 v1, a249
		v_cvt_pk_bf16_f32 v98, v0, v1
		v_accvgpr_read_b32 v0, a250
		v_accvgpr_read_b32 v1, a251
		v_cvt_pk_bf16_f32 v99, v0, v1
		v_accvgpr_read_b32 v0, a252
		v_accvgpr_read_b32 v1, a253
		v_cvt_pk_bf16_f32 v100, v0, v1
		v_accvgpr_read_b32 v0, a254
		v_accvgpr_read_b32 v1, a255
		v_cvt_pk_bf16_f32 v101, v0, v1
		v_cvt_pk_bf16_f32 v0, v220, v221
		v_cvt_pk_bf16_f32 v1, v222, v223
		v_cvt_pk_bf16_f32 v104, v224, v225
		v_cvt_pk_bf16_f32 v105, v226, v227
		v_cvt_pk_bf16_f32 v108, v228, v229
		v_cvt_pk_bf16_f32 v109, v230, v231
		v_cvt_pk_bf16_f32 v102, v232, v233
		v_cvt_pk_bf16_f32 v103, v234, v235
		v_cvt_pk_bf16_f32 v2, v236, v237
		v_cvt_pk_bf16_f32 v3, v238, v239
		v_cvt_pk_bf16_f32 v106, v240, v241
		v_cvt_pk_bf16_f32 v107, v242, v243
		v_cvt_pk_bf16_f32 v110, v244, v245
		v_cvt_pk_bf16_f32 v111, v246, v247
		ds_write_b128 v41, v[8:11] offset:3072
		ds_write_b128 v41, v[12:15] offset:7168
		ds_write_b128 v41, v[36:39] offset:11264
		ds_write_b128 v41, v[60:63] offset:15360
		s_and_saveexec_b64 s[12:13], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v8, v19, v29
		s_mov_b64 exec, s[12:13]
		s_and_b32 s12, s2, s20
		s_and_b32 s13, s3, s21
		s_add_i32 s0, s0, 0x100
		s_add_i32 s0, s0, s1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v8
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_27:
		ds_read_b32 v8, v19
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s17, v8
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s17, s17, s22
		s_cmp_ge_u32 s17, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_27
.L_a4w4_kernel.loop_exit_27:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[8:11], v4 offset:3072
		ds_read_b128 v[12:15], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[36:37], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[38:39], v[12:13]
		v_mov_b64_e32 v[60:61], v[10:11]
		v_mov_b64_e32 v[62:63], v[14:15]
		ds_read_b128 v[8:11], v4 offset:5120
		ds_read_b128 v[12:15], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[112:113], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[114:115], v[12:13]
		v_mov_b64_e32 v[116:117], v[10:11]
		v_mov_b64_e32 v[118:119], v[14:15]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v8, v20, v29
		s_mov_b64 exec, s[2:3]
		s_add_i32 s0, s0, s16
		v_add3_u32 v5, s0, v5, v6
		v_add3_u32 v5, v5, v31, v45
		v_add3_u32 v5, v5, v7, v34
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v8
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_28:
		ds_read_b32 v6, v20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s16, v6
		s_xor_b32 s17, s1, -1
		s_add_i32 s17, s17, 1
		s_add_i32 s16, s16, s17
		s_cmp_ge_u32 s16, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_28
.L_a4w4_kernel.loop_exit_28:
		s_mov_b64 exec, s[2:3]
		ds_write_b128 v41, v[64:67] offset:3072
		ds_write_b128 v41, v[68:71] offset:7168
		ds_write_b128 v41, v[72:75] offset:11264
		ds_write_b128 v41, v[80:83] offset:15360
		s_and_saveexec_b64 s[2:3], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v6, v21, v29
		s_mov_b64 exec, s[2:3]
		v_add3_u32 v5, v5, v40, v43
		v_cndmask_b32_e64 v5, v44, v5, s[12:13]
		buffer_store_dwordx4 v[36:39], v5, s[8:11], 0 offen
		s_and_b32 s2, s4, s20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[12:13], s[18:19]
.L_a4w4_kernel.loop_head_29:
		ds_read_b32 v5, v21
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v5
		s_xor_b32 s4, s1, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s3, s3, s4
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_29
.L_a4w4_kernel.loop_exit_29:
		s_mov_b64 exec, s[12:13]
		ds_read_b128 v[8:11], v4 offset:3072
		ds_read_b128 v[12:15], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[36:37], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[38:39], v[12:13]
		v_mov_b64_e32 v[64:65], v[10:11]
		v_mov_b64_e32 v[66:67], v[14:15]
		ds_read_b128 v[8:11], v4 offset:5120
		ds_read_b128 v[12:15], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[68:69], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[70:71], v[12:13]
		v_mov_b64_e32 v[72:73], v[10:11]
		v_mov_b64_e32 v[74:75], v[14:15]
		s_and_saveexec_b64 s[12:13], s[18:19]
		ds_add_rtn_u32 v5, v22, v29
		s_mov_b64 exec, s[12:13]
		s_and_b32 s3, s5, s21
		v_add3_u32 v6, v7, v34, v40
		v_add_u32_e32 v6, v6, v43
		v_add3_u32 v8, v18, v6, s0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[4:5], s[18:19]
.L_a4w4_kernel.loop_head_30:
		ds_read_b32 v5, v22
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s12, v5
		s_xor_b32 s13, s1, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s12, s12, s13
		s_cmp_ge_u32 s12, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_30
.L_a4w4_kernel.loop_exit_30:
		s_mov_b64 exec, s[4:5]
		ds_write_b128 v41, v[84:87] offset:3072
		ds_write_b128 v41, v[88:91] offset:7168
		ds_write_b128 v41, v[92:95] offset:11264
		ds_write_b128 v41, v[96:99] offset:15360
		s_and_saveexec_b64 s[4:5], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v5, v23, v29
		s_mov_b64 exec, s[4:5]
		v_cndmask_b32_e64 v8, v44, v8, s[2:3]
		buffer_store_dwordx4 v[112:115], v8, s[8:11], 0 offen
		s_and_b32 s2, s6, s20
		s_and_b32 s3, s7, s21
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[4:5], s[18:19]
.L_a4w4_kernel.loop_head_31:
		ds_read_b32 v5, v23
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s6, v5
		s_xor_b32 s7, s1, -1
		s_add_i32 s7, s7, 1
		s_add_i32 s6, s6, s7
		s_cmp_ge_u32 s6, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_31
.L_a4w4_kernel.loop_exit_31:
		s_mov_b64 exec, s[4:5]
		ds_read_b128 v[8:11], v4 offset:3072
		ds_read_b128 v[12:15], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[16:17], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[18:19], v[12:13]
		v_mov_b64_e32 v[20:21], v[10:11]
		v_mov_b64_e32 v[22:23], v[14:15]
		ds_read_b128 v[8:11], v4 offset:5120
		ds_read_b128 v[12:15], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[80:81], v[8:9]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[82:83], v[12:13]
		v_mov_b64_e32 v[84:85], v[10:11]
		v_mov_b64_e32 v[86:87], v[14:15]
		s_and_saveexec_b64 s[4:5], s[18:19]
		ds_add_rtn_u32 v5, v24, v29
		s_mov_b64 exec, s[4:5]
		v_add3_u32 v8, v49, v6, s0
		v_cndmask_b32_e64 v8, v44, v8, s[2:3]
		buffer_store_dwordx4 v[60:63], v8, s[8:11], 0 offen
		s_and_b32 s2, s14, s20
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[4:5], s[18:19]
.L_a4w4_kernel.loop_head_32:
		ds_read_b32 v5, v24
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v5
		s_xor_b32 s6, s1, -1
		s_add_i32 s6, s6, 1
		s_add_i32 s3, s3, s6
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_32
.L_a4w4_kernel.loop_exit_32:
		s_mov_b64 exec, s[4:5]
		ds_write_b128 v41, v[100:103] offset:3072
		ds_write_b128 v41, v[0:3] offset:7168
		ds_write_b128 v41, v[104:107] offset:11264
		ds_write_b128 v41, v[108:111] offset:15360
		s_and_saveexec_b64 s[4:5], s[18:19]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v0, v25, v29
		s_mov_b64 exec, s[4:5]
		s_and_b32 s3, s15, s21
		v_add3_u32 v1, v50, v6, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[116:119], v1, s[8:11], 0 offen
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v0
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[18:19]
.L_a4w4_kernel.loop_head_33:
		ds_read_b32 v0, v25
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v0
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_33
.L_a4w4_kernel.loop_exit_33:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[0:3], v4 offset:3072
		ds_read_b128 v[8:11], v4 offset:3328
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[12:13], v[0:1]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[14:15], v[8:9]
		v_mov_b64_e32 v[60:61], v[2:3]
		v_mov_b64_e32 v[62:63], v[10:11]
		ds_read_b128 v[0:3], v4 offset:5120
		ds_read_b128 v[8:11], v4 offset:5376
		s_waitcnt lgkmcnt(1)
		v_mov_b64_e32 v[88:89], v[0:1]
		s_waitcnt lgkmcnt(0)
		v_mov_b64_e32 v[90:91], v[8:9]
		v_mov_b64_e32 v[92:93], v[2:3]
		v_mov_b64_e32 v[94:95], v[10:11]
		s_and_saveexec_b64 s[2:3], s[18:19]
		ds_add_rtn_u32 v0, v26, v29
		s_mov_b64 exec, s[2:3]
		s_and_b32 s2, s26, s20
		s_and_b32 s3, s27, s21
		v_add3_u32 v1, v7, v34, v40
		v_add_u32_e32 v1, v1, v43
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v0
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[4:5], s[18:19]
.L_a4w4_kernel.loop_head_34:
		ds_read_b32 v0, v26
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s6, v0
		s_xor_b32 s7, s1, -1
		s_add_i32 s7, s7, 1
		s_add_i32 s6, s6, s7
		s_cmp_ge_u32 s6, 0x80000000
		s_cbranch_scc1 .L_a4w4_kernel.loop_head_34
.L_a4w4_kernel.loop_exit_34:
		s_mov_b64 exec, s[4:5]
		v_add3_u32 v0, v51, v1, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[36:39], v0, s[8:11], 0 offen
		s_and_b32 s2, s28, s20
		s_and_b32 s3, s29, s21
		v_add3_u32 v0, v52, v1, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[68:71], v0, s[8:11], 0 offen
		s_and_b32 s2, s30, s20
		s_and_b32 s3, s31, s21
		v_add3_u32 v0, v53, v1, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[64:67], v0, s[8:11], 0 offen
		s_and_b32 s2, s32, s20
		s_and_b32 s3, s33, s21
		v_add3_u32 v0, v7, v34, v40
		v_add_u32_e32 v0, v0, v43
		v_add3_u32 v1, v54, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[72:75], v1, s[8:11], 0 offen
		s_and_b32 s2, s34, s20
		s_and_b32 s3, s35, s21
		v_add3_u32 v1, v55, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[16:19], v1, s[8:11], 0 offen
		s_and_b32 s2, s36, s20
		s_and_b32 s3, s37, s21
		v_add3_u32 v0, v56, v0, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[80:83], v0, s[8:11], 0 offen
		s_and_b32 s2, s38, s20
		s_and_b32 s3, s39, s21
		v_add3_u32 v0, v7, v34, v40
		v_add_u32_e32 v0, v0, v43
		v_add3_u32 v1, v57, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[20:23], v1, s[8:11], 0 offen
		s_and_b32 s2, s40, s20
		s_and_b32 s3, s41, s21
		v_add3_u32 v1, v58, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[84:87], v1, s[8:11], 0 offen
		s_and_b32 s2, s42, s20
		s_and_b32 s3, s43, s21
		v_add3_u32 v0, v59, v0, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[12:15], v0, s[8:11], 0 offen
		s_and_b32 s2, s44, s20
		s_and_b32 s3, s45, s21
		v_add3_u32 v0, v7, v34, v40
		v_add_u32_e32 v0, v0, v43
		v_add3_u32 v1, v76, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[88:91], v1, s[8:11], 0 offen
		s_and_b32 s2, s46, s20
		s_and_b32 s3, s47, s21
		v_add3_u32 v1, v77, v0, s0
		v_cndmask_b32_e64 v1, v44, v1, s[2:3]
		buffer_store_dwordx4 v[60:63], v1, s[8:11], 0 offen
		s_and_b32 s2, s48, s20
		s_and_b32 s3, s49, s21
		v_add3_u32 v0, v27, v0, s0
		v_cndmask_b32_e64 v0, v44, v0, s[2:3]
		buffer_store_dwordx4 v[92:95], v0, s[8:11], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	_a4w4_kernel, .-_a4w4_kernel
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _a4w4_kernel
		.amdhsa_group_segment_fixed_size 162952
		.amdhsa_private_segment_fixed_size 32
		.amdhsa_kernarg_size 72
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 512
		.amdhsa_next_free_sgpr 77
		.amdhsa_accum_offset 256
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
	.set .L_a4w4_kernel.num_vgpr, 256
	.set .L_a4w4_kernel.num_agpr, 256
	.set .L_a4w4_kernel.numbered_sgpr, 77
	.set .L_a4w4_kernel.num_named_barrier, 0
	.set .L_a4w4_kernel.private_seg_size, 32
	.set .L_a4w4_kernel.uses_vcc, 1
	.set .L_a4w4_kernel.uses_flat_scratch, 1
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
    .group_segment_fixed_size: 162952
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 256
    .name:           _a4w4_kernel
    .private_segment_fixed_size: 32
    .sgpr_count:     77
    .sgpr_spill_count: 0
    .symbol:         _a4w4_kernel.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 8
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 150
    wave.regalloc.agpr.dwords: 468
    wave.regalloc.remat.dwords: 12
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 12
    wave.regalloc.scratch.dwords: 8
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
