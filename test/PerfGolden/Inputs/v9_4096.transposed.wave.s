	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	v9_beyond_hotloop
	.p2align	8
	.type	v9_beyond_hotloop,@function
v9_beyond_hotloop:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dword s12, s[0:1], 0x28
		s_waitcnt lgkmcnt(0)
		s_branch .Lv9_beyond_hotloop.kernarg_preload_entry
	.p2align	8
.Lv9_beyond_hotloop.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_add_i32 s0, s8, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s14, s1, 0
		s_add_i32 s0, s0, s14
		s_ashr_i32 s0, s0, 8
		s_add_i32 s14, s9, 0xff
		s_cmp_lt_i32 s14, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s14, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s14, s13, 7
		s_lshr_b32 s13, s13, 3
		s_cmp_lt_i32 s14, 8
		s_cbranch_scc0 .Lv9_beyond_hotloop.if_else_0
		s_mul_i32 s15, s14, 32
		s_add_i32 s16, s15, s13
		s_branch .Lv9_beyond_hotloop.if_end_0
.Lv9_beyond_hotloop.if_else_0:
		s_add_i32 s14, s14, -8
		s_mul_i32 s14, s14, 31
		s_add_i32 s14, s14, 0x100
		s_add_i32 s16, s14, s13
.Lv9_beyond_hotloop.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s14, s16, -1
		s_add_i32 s14, s14, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s14, s16
		s_cselect_b32 s14, 1, 0
		s_xor_b32 s15, s1, -1
		s_add_i32 s15, s15, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s15, s15, s1
		v_mov_b32_e32 v1, s15
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s17, s15, -1
		v_readfirstlane_b32 s18, v1
		s_add_i32 s17, s17, 1
		s_mul_i32 s19, s17, s18
		s_mul_hi_u32 s19, s18, s19
		s_add_i32 s18, s18, s19
		s_mul_hi_u32 s18, s13, s18
		s_mul_i32 s19, s18, s15
		s_xor_b32 s19, s19, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s13, s13, s19
		s_cmp_ge_u32 s13, s15
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s18, 1
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s18, s20, s18
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s13, s17
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s13, s20, s13
		s_cmp_ge_u32 s13, s15
		s_cselect_b32 s15, 1, 0
		s_add_i32 s19, s18, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s15, s19, s18
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s1, s16, s1
		s_xor_b32 s16, s15, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s16, s15
		s_mul_i32 s15, s1, 4
		s_xor_b32 s16, s15, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s0, s0, s16
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s16, s13, s17
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s13, s16, s13
		s_xor_b32 s16, s13, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s13, s16, s13
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s14, 1, 0
		s_xor_b32 s16, s13, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s14, s16, s13
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s17, s0, -1
		s_add_i32 s17, s17, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s17, s17, s0
		v_mov_b32_e32 v1, s17
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s18, s17, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s18, s18, 1
		v_readfirstlane_b32 s19, v1
		s_mul_i32 s20, s18, s19
		s_mul_hi_u32 s20, s19, s20
		s_add_i32 s19, s19, s20
		s_mul_hi_u32 s19, s14, s19
		s_mul_i32 s20, s19, s17
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s14, s14, s20
		s_cmp_ge_u32 s14, s17
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s14, s18
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s14, s21, s14
		s_cselect_b32 s20, 1, 0
		s_cmp_ge_u32 s14, s17
		s_cselect_b32 s17, 1, 0
		s_add_i32 s18, s14, s18
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s14, s18, s14
		s_cselect_b32 s17, 1, 0
		s_xor_b32 s18, s14, -1
		s_add_i32 s18, s18, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s14, s18, s14
		s_add_i32 s15, s15, s14
		s_add_i32 s16, s19, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s16, s16, s19
		s_add_i32 s18, s16, 1
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s16, s18, s16
		s_xor_b32 s0, s13, s0
		s_xor_b32 s13, s16, -1
		s_add_i32 s13, s13, 1
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s0, s13, s16
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s18
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s13, v0
		s_lshr_b32 s13, s13, 6
		s_mul_i32 s13, 0x420, s13
		s_mov_b32 m0, s13
		v_lshrrev_b32_e32 v1, 8, v0
		v_mul_lo_u32 v2, s10, v1
		v_lshlrev_b32_e32 v2, 6, v2
		v_lshrrev_b32_e32 v3, 7, v0
		v_and_b32_e32 v4, 1, v3
		v_mul_lo_u32 v5, s10, v4
		v_lshlrev_b32_e32 v5, 5, v5
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v7, 1, v6
		v_mul_lo_u32 v8, s10, v7
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v9, v2, v5, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v11, 1, v10
		v_mul_lo_u32 v12, s10, v11
		v_lshlrev_b32_e32 v12, 3, v12
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v14, 1, v13
		v_mul_lo_u32 v15, s10, v14
		v_lshlrev_b32_e32 v15, 2, v15
		v_add3_u32 v9, v9, v12, v15
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v17, 1, v16
		v_mul_lo_u32 v18, s10, v17
		v_lshlrev_b32_e32 v18, 1, v18
		v_and_b32_e32 v19, 1, v0
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v9, v9, v18, v20
		v_lshrrev_b32_e32 v18, 2, v0
		v_and_b32_e32 v21, 1, v18
		v_lshlrev_b32_e32 v22, 6, v21
		v_lshrrev_b32_e32 v23, 1, v0
		v_and_b32_e32 v24, 1, v23
		v_lshlrev_b32_e32 v25, 5, v24
		v_add3_u32 v9, v9, v22, v25
		s_mul_i32 s16, s1, s10
		s_lshl_b32 s16, s16, 11
		s_mul_i32 s17, s14, s10
		s_lshl_b32 s17, s17, 9
		s_add_i32 s28, s16, s17
		v_add_u32_e32 v26, s28, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mul_i32 s15, s15, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s29, s10, 7
		s_add_i32 s30, s29, s16
		s_add_i32 s30, s30, s17
		v_add_u32_e32 v26, s30, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mul_i32 s31, s0, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s32, s10, 8
		s_add_i32 s33, s32, s16
		s_add_i32 s33, s33, s17
		v_add_u32_e32 v26, s33, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		v_mul_lo_u32 v26, s11, v4
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s34, 0x180, s10
		s_add_i32 s35, s34, s16
		s_add_i32 s35, s35, s17
		v_add_u32_e32 v27, s35, v9
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_mul_lo_u32 v27, s11, v1
		s_add_i32 m0, m0, 0xa4e0
		v_lshlrev_b32_e32 v27, 6, v27
		v_lshlrev_b32_e32 v26, 5, v26
		v_mul_lo_u32 v28, s11, v7
		v_lshlrev_b32_e32 v28, 4, v28
		v_add3_u32 v29, v27, v26, v28
		v_mul_lo_u32 v30, s11, v11
		v_lshlrev_b32_e32 v30, 3, v30
		v_mul_lo_u32 v31, s11, v14
		v_lshlrev_b32_e32 v31, 2, v31
		v_add3_u32 v29, v29, v30, v31
		v_mul_lo_u32 v32, s11, v17
		v_lshlrev_b32_e32 v32, 1, v32
		v_add3_u32 v29, v29, v32, v20
		v_add3_u32 v29, v29, v22, v25
		s_mul_i32 s36, s0, s11
		s_lshl_b32 s36, s36, 9
		v_add_u32_e32 v32, s36, v29
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_lshl_b32 s37, s11, 7
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s38, s37, s36
		v_add_u32_e32 v32, s38, v29
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_lshl_b32 s39, s11, 8
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s40, s39, s36
		v_add_u32_e32 v32, s40, v29
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_mul_i32 s41, 0x180, s11
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s42, s41, s36
		v_add_u32_e32 v32, s42, v29
		buffer_load_dwordx4 v32, s[24:27], 0 offen lds
		s_add_i32 s43, s16, 0x80
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s43, s43, s17
		v_add_u32_e32 v32, s43, v9
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		v_add_u32_e32 v9, s17, v9
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v9, s16, v9
		v_add_u32_e32 v9, 0x80, v9
		v_add_u32_e32 v32, s29, v9
		buffer_load_dwordx4 v32, s[20:23], 0 offen lds
		v_add3_u32 v32, s28, v2, v5
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v33, s32, v9
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_lshl_b32 s10, s10, 1
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v9, s34, v9
		s_add_i32 s16, s36, 0x80
		v_add_u32_e32 v33, s16, v29
		v_add_u32_e32 v29, s36, v29
		v_add_u32_e32 v29, 0x80, v29
		v_add_u32_e32 v34, s37, v29
		s_mov_b32 s16, 0x80
		v_add_u32_e32 v35, s39, v29
		s_mov_b32 s17, 0
		v_add_u32_e32 v29, s41, v29
		v_mov_b32_e32 v36, 0x840
		v_mul_lo_u32 v36, v36, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_and_b32_e32 v9, 63, v0
		s_add_i32 m0, m0, 0x62e0
		v_lshrrev_b32_e32 v37, 4, v9
		v_lshlrev_b32_e32 v37, 4, v37
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		v_add_u32_e32 v33, v36, v37
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v9, 15, v9
		v_lshrrev_b32_e32 v36, 3, v9
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		v_mov_b32_e32 v34, 0x420
		v_mul_lo_u32 v34, v34, v36
		s_add_i32 m0, m0, 0x62e0
		v_lshrrev_b32_e32 v36, 2, v9
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		v_and_b32_e32 v35, 1, v36
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v35, 9, v35
		v_add3_u32 v33, v33, v34, v35
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_lshrrev_b32_e32 v29, 1, v9
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 8, v29
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 7, v9
		v_add3_u32 v33, v33, v29, v9
		ds_read_b128 v[40:43], v33
		ds_read_b128 v[44:47], v33 offset:64
		ds_read_b128 v[48:51], v33 offset:8448
		ds_read_b128 v[52:55], v33 offset:8512
		ds_read_b128 v[56:59], v33 offset:16896
		ds_read_b128 v[60:63], v33 offset:16960
		ds_read_b128 v[64:67], v33 offset:25344
		ds_read_b128 v[68:71], v33 offset:25408
		v_add_u32_e32 v36, 0x10000, v37
		v_add_u32_e32 v34, v36, v34
		v_mov_b32_e32 v36, 0x840
		v_mul_lo_u32 v36, v36, v7
		v_add3_u32 v34, v34, v36, v35
		v_add3_u32 v9, v34, v29, v9
		ds_read_b128 v[36:39], v9 offset:2016
		ds_read_b128 v[72:75], v9 offset:2080
		ds_read_b128 v[76:79], v9 offset:6240
		ds_read_b128 v[80:83], v9 offset:6304
		ds_read_b128 v[84:87], v9 offset:10464
		ds_read_b128 v[88:91], v9 offset:10528
		ds_read_b128 v[92:95], v9 offset:14688
		ds_read_b128 v[96:99], v9 offset:14752
		v_cmp_ne_u32_e64 vcc, v1, s17
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[56:57], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		s_setprio 0
		s_mov_b32 s28, s16
		v_mul_lo_u32 v29, s10, v17
		v_add_u32_e32 v34, 0x100, v29
		v_add3_u32 v32, v32, v8, v12
		v_add3_u32 v32, v32, v15, v20
		v_add3_u32 v32, v32, v22, v25
		v_add_u32_e32 v35, v34, v32
		v_add3_u32 v100, s30, v2, v5
		v_add3_u32 v100, v100, v8, v12
		v_add3_u32 v100, v100, v15, v20
		v_add3_u32 v100, v100, v22, v25
		v_add_u32_e32 v101, v34, v100
		v_add3_u32 v102, s33, v2, v5
		v_add3_u32 v102, v102, v8, v12
		v_add3_u32 v102, v102, v15, v20
		v_add3_u32 v102, v102, v22, v25
		v_add_u32_e32 v103, v34, v102
		v_add3_u32 v2, s35, v2, v5
		v_add3_u32 v2, v2, v8, v12
		v_add3_u32 v2, v2, v15, v20
		v_add3_u32 v2, v2, v22, v25
		v_add_u32_e32 v5, v34, v2
		s_lshl_b32 s10, s11, 1
		v_mul_lo_u32 v8, s10, v17
		v_add_u32_e32 v12, 0x100, v8
		v_add3_u32 v15, s36, v27, v26
		v_add3_u32 v15, v15, v28, v30
		v_add3_u32 v15, v15, v31, v20
		v_add3_u32 v15, v15, v22, v25
		v_add_u32_e32 v34, v12, v15
		v_add3_u32 v104, s38, v27, v26
		v_add3_u32 v104, v104, v28, v30
		v_add3_u32 v104, v104, v31, v20
		v_add3_u32 v104, v104, v22, v25
		v_add_u32_e32 v105, v12, v104
		v_add3_u32 v106, s40, v27, v26
		v_add3_u32 v106, v106, v28, v30
		v_add3_u32 v106, v106, v31, v20
		v_add3_u32 v106, v106, v22, v25
		v_add_u32_e32 v107, v12, v106
		v_add3_u32 v26, s42, v27, v26
		v_add3_u32 v26, v26, v28, v30
		v_add3_u32 v20, v26, v31, v20
		v_add3_u32 v20, v20, v22, v25
		v_add_u32_e32 v22, v12, v20
		v_add_u32_e32 v12, 0x180, v29
		v_add_u32_e32 v25, v12, v32
		v_add_u32_e32 v26, v12, v100
		v_add_u32_e32 v27, v12, v102
		v_add_u32_e32 v28, v12, v2
		v_add_u32_e32 v2, 0x180, v8
		v_add_u32_e32 v8, v2, v15
		v_add_u32_e32 v12, v2, v104
		v_add_u32_e32 v15, v2, v106
		v_add_u32_e32 v29, v2, v20
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		s_mov_b32 s2, s17
		s_mov_b32 s3, s28
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
.Lv9_beyond_hotloop.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[108:111], v[36:39], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[36:39], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[36:39], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[36:39], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[68:71], v[164:167]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b128 v[36:39], v9 offset:35776
		ds_read_b128 v[72:75], v9 offset:35840
		ds_read_b128 v[76:79], v9 offset:40000
		ds_read_b128 v[80:83], v9 offset:40064
		ds_read_b128 v[84:87], v9 offset:44224
		ds_read_b128 v[88:91], v9 offset:44288
		ds_read_b128 v[92:95], v9 offset:48448
		ds_read_b128 v[96:99], v9 offset:48512
		s_mov_b32 m0, s13
		s_nop 0
		buffer_load_dwordx4 v35, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v101, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v103, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v105, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[172:175], v[36:39], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[36:39], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[92:95], v[64:67], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[36:39], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[84:87], v[64:67], v[228:231]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[96:99], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[96:99], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[96:99], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[96:99], v[68:71], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[68:71], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[68:71], v[228:231]
		s_setprio 1
		s_barrier
		ds_read_b128 v[36:39], v33 offset:33792
		ds_read_b128 v[40:43], v33 offset:33856
		ds_read_b128 v[44:47], v33 offset:42240
		ds_read_b128 v[48:51], v33 offset:42304
		ds_read_b128 v[52:55], v33 offset:50688
		ds_read_b128 v[56:59], v33 offset:50752
		ds_read_b128 v[60:63], v33 offset:59136
		ds_read_b128 v[64:67], v33 offset:59200
		ds_read_b128 v[68:71], v9 offset:18912
		ds_read_b128 v[72:75], v9 offset:18976
		ds_read_b128 v[76:79], v9 offset:23136
		ds_read_b128 v[80:83], v9 offset:23200
		ds_read_b128 v[84:87], v9 offset:27360
		ds_read_b128 v[88:91], v9 offset:27424
		ds_read_b128 v[92:95], v9 offset:31584
		ds_read_b128 v[96:99], v9 offset:31648
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v107, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[60:63], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[60:63], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		s_setprio 1
		s_barrier
		ds_read_b128 v[68:71], v9 offset:52672
		ds_read_b128 v[72:75], v9 offset:52736
		ds_read_b128 v[76:79], v9 offset:56896
		ds_read_b128 v[80:83], v9 offset:56960
		ds_read_b128 v[84:87], v9 offset:61120
		ds_read_b128 v[88:91], v9 offset:61184
		ds_read_b128 v[92:95], v9 offset:65344
		ds_read_b128 v[96:99], v9 offset:65408
		s_add_i32 m0, m0, 0xfffed740
		s_nop 0
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[92:95], v[60:63], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[68:71], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[60:63], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[84:87], v[60:63], v[228:231]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[96:99], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[96:99], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[96:99], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[96:99], v[64:67], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[64:67], v[228:231]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[40:43], v33
		ds_read_b128 v[44:47], v33 offset:64
		ds_read_b128 v[48:51], v33 offset:8448
		ds_read_b128 v[52:55], v33 offset:8512
		ds_read_b128 v[56:59], v33 offset:16896
		ds_read_b128 v[60:63], v33 offset:16960
		ds_read_b128 v[64:67], v33 offset:25344
		ds_read_b128 v[68:71], v33 offset:25408
		ds_read_b128 v[36:39], v9 offset:2016
		ds_read_b128 v[72:75], v9 offset:2080
		ds_read_b128 v[76:79], v9 offset:6240
		ds_read_b128 v[80:83], v9 offset:6304
		ds_read_b128 v[84:87], v9 offset:10464
		ds_read_b128 v[88:91], v9 offset:10528
		ds_read_b128 v[92:95], v9 offset:14688
		ds_read_b128 v[96:99], v9 offset:14752
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s28, s28, 0x80
		s_add_i32 s3, s3, 0x80
		s_setprio 0
		s_barrier
		s_add_u32 s20, s20, 0x100
		s_addc_u32 s21, s21, 0
		s_add_u32 s24, s24, 0x100
		s_addc_u32 s25, s25, 0
		s_add_i32 s2, s2, 2
		s_cmp_lt_i32 s2, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		v_cmp_eq_u32_e64 vcc, v1, s17
		s_and_saveexec_b64 s[56:57], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[108:111], v[36:39], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[36:39], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[36:39], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[36:39], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[64:67], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[96:99], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[96:99], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[96:99], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[96:99], v[68:71], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[68:71], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[68:71], v[164:167]
		ds_read_b128 v[28:31], v9 offset:35776
		ds_read_b128 v[36:39], v9 offset:35840
		ds_read_b128 v[72:75], v9 offset:40000
		ds_read_b128 v[76:79], v9 offset:40064
		ds_read_b128 v[80:83], v9 offset:44224
		ds_read_b128 v[84:87], v9 offset:44288
		ds_read_b128 v[88:91], v9 offset:48448
		ds_read_b128 v[92:95], v9 offset:48512
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[40:43], v[172:175]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[28:31], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[28:31], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[88:91], v[64:67], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[28:31], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[72:75], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[80:83], v[64:67], v[228:231]
		v_mfma_f32_16x16x32_f16 v[172:175], v[36:39], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[36:39], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[92:95], v[68:71], v[232:235]
		v_mfma_f32_16x16x32_f16 v[220:223], v[36:39], v[68:71], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[84:87], v[68:71], v[228:231]
		ds_read_b128 v[28:31], v33 offset:33792
		ds_read_b128 v[36:39], v33 offset:33856
		ds_read_b128 v[40:43], v33 offset:42240
		ds_read_b128 v[44:47], v33 offset:42304
		ds_read_b128 v[48:51], v33 offset:50688
		ds_read_b128 v[52:55], v33 offset:50752
		ds_read_b128 v[56:59], v33 offset:59136
		ds_read_b128 v[60:63], v33 offset:59200
		ds_read_b128 v[32:35], v9 offset:18912
		ds_read_b128 v[64:67], v9 offset:18976
		ds_read_b128 v[68:71], v9 offset:23136
		ds_read_b128 v[72:75], v9 offset:23200
		ds_read_b128 v[76:79], v9 offset:27360
		ds_read_b128 v[80:83], v9 offset:27424
		ds_read_b128 v[84:87], v9 offset:31584
		ds_read_b128 v[88:91], v9 offset:31648
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[108:111], v[32:35], v[28:31], v[108:111]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[32:35], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[32:35], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[48:51], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[56:59], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[32:35], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[56:59], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[36:39], v[116:119]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[60:63], v[168:171]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[60:63], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[60:63], v[164:167]
		ds_read_b128 v[32:35], v9 offset:52672
		ds_read_b128 v[64:67], v9 offset:52736
		ds_read_b128 v[68:71], v9 offset:56896
		ds_read_b128 v[72:75], v9 offset:56960
		ds_read_b128 v[76:79], v9 offset:61120
		ds_read_b128 v[80:83], v9 offset:61184
		ds_read_b128 v[84:87], v9 offset:65344
		ds_read_b128 v[88:91], v9 offset:65408
		v_cvt_pk_f16_f32 v8, v108, v109
		v_cvt_pk_f16_f32 v9, v110, v111
		v_cvt_pk_f16_f32 v26, v112, v113
		v_cvt_pk_f16_f32 v27, v114, v115
		v_cvt_pk_f16_f32 v92, v116, v117
		v_cvt_pk_f16_f32 v93, v118, v119
		v_cvt_pk_f16_f32 v94, v120, v121
		v_cvt_pk_f16_f32 v95, v122, v123
		v_cvt_pk_f16_f32 v96, v124, v125
		v_cvt_pk_f16_f32 v97, v126, v127
		v_cvt_pk_f16_f32 v98, v128, v129
		v_cvt_pk_f16_f32 v99, v130, v131
		v_cvt_pk_f16_f32 v100, v132, v133
		v_cvt_pk_f16_f32 v101, v134, v135
		v_cvt_pk_f16_f32 v102, v136, v137
		v_cvt_pk_f16_f32 v103, v138, v139
		v_cvt_pk_f16_f32 v104, v140, v141
		v_cvt_pk_f16_f32 v105, v142, v143
		v_cvt_pk_f16_f32 v106, v144, v145
		v_cvt_pk_f16_f32 v107, v146, v147
		v_cvt_pk_f16_f32 v108, v148, v149
		v_cvt_pk_f16_f32 v109, v150, v151
		v_cvt_pk_f16_f32 v110, v152, v153
		v_cvt_pk_f16_f32 v111, v154, v155
		v_cvt_pk_f16_f32 v112, v156, v157
		v_cvt_pk_f16_f32 v113, v158, v159
		v_cvt_pk_f16_f32 v114, v160, v161
		v_cvt_pk_f16_f32 v115, v162, v163
		v_cvt_pk_f16_f32 v116, v164, v165
		v_cvt_pk_f16_f32 v117, v166, v167
		v_cvt_pk_f16_f32 v118, v168, v169
		v_cvt_pk_f16_f32 v119, v170, v171
		v_and_b32_e32 v0, 1, v0
		v_and_b32_e32 v2, 1, v23
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v2
		v_and_b32_e32 v2, 1, v18
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v2
		v_bitop3_b32 v2, v0, v5, v12 bitop3:0x96
		v_and_b32_e32 v15, 1, v16
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v15
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v3
		v_bitop3_b32 v2, v2, v16, v15 bitop3:0x96
		v_and_b32_e32 v3, 1, v1
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v3
		v_xad_u32 v2, v2, v18, s15
		v_bitop3_b32 v3, 64, v0, v5 bitop3:0x96
		v_xor_b32_e32 v3, v3, v12
		v_bitop3_b32 v3, v3, v16, v15 bitop3:0x96
		v_xad_u32 v3, v3, v18, s15
		v_xor_b32_e32 v20, 0x80, v0
		v_xor_b32_e32 v20, v20, v5
		v_xor_b32_e32 v20, v20, v12
		v_bitop3_b32 v20, v20, v16, v15 bitop3:0x96
		v_xad_u32 v20, v20, v18, s15
		v_xor_b32_e32 v0, 0xc0, v0
		v_xor_b32_e32 v0, v0, v5
		v_xor_b32_e32 v0, v0, v12
		v_bitop3_b32 v0, v0, v16, v15 bitop3:0x96
		v_xad_u32 v0, v0, v18, s15
		v_and_b32_e32 v5, 1, v13
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v5
		v_and_b32_e32 v5, 1, v10
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v5
		v_and_b32_e32 v5, 1, v6
		v_mov_b32_e32 v6, 16
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v12, v10, v6 bitop3:0x96
		v_add_u32_e32 v13, s31, v5
		v_bitop3_b32 v15, 32, v12, v10 bitop3:0x96
		v_xor_b32_e32 v15, v15, v6
		v_add_u32_e32 v16, s31, v15
		v_bitop3_b32 v18, 64, v12, v10 bitop3:0x96
		v_xor_b32_e32 v18, v18, v6
		v_add_u32_e32 v22, s31, v18
		v_xor_b32_e32 v12, 0x60, v12
		v_xor_b32_e32 v10, v12, v10
		v_xor_b32_e32 v6, v10, v6
		v_add_u32_e32 v10, s31, v6
		v_cmp_lt_i32_e64 vcc, v2, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v13, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v16, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s20, s2, s10
		s_and_b32 s21, s3, s11
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s2, s22
		s_and_b32 s25, s3, s23
		v_cmp_lt_i32_e64 vcc, v10, s9
		s_mov_b64 s[26:27], vcc
		s_and_b32 s28, s2, s26
		s_and_b32 s29, s3, s27
		v_cmp_lt_i32_e64 vcc, v3, s8
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s32, s4
		s_and_b32 s35, s33, s5
		s_and_b32 s36, s32, s10
		s_and_b32 s37, s33, s11
		s_and_b32 s38, s32, s22
		s_and_b32 s39, s33, s23
		s_and_b32 s40, s32, s26
		s_and_b32 s41, s33, s27
		v_cmp_lt_i32_e64 vcc, v20, s8
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s42, s4
		s_and_b32 s45, s43, s5
		s_and_b32 s46, s42, s10
		s_and_b32 s47, s43, s11
		s_and_b32 s48, s42, s22
		s_and_b32 s49, s43, s23
		s_and_b32 s50, s42, s26
		s_and_b32 s51, s43, s27
		v_cmp_lt_i32_e64 vcc, v0, s8
		s_mov_b64 s[52:53], vcc
		s_and_b32 s54, s52, s4
		s_and_b32 s55, s53, s5
		s_and_b32 s4, s52, s10
		s_and_b32 s5, s53, s11
		s_and_b32 s10, s52, s22
		s_and_b32 s11, s53, s23
		s_and_b32 s22, s52, s26
		s_and_b32 s23, s53, s27
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s1, s1, s12
		s_lshl_b32 s1, s1, 11
		s_add_i32 s8, s0, s1
		s_mul_i32 s13, s14, s12
		s_lshl_b32 s13, s13, 9
		s_add_i32 s8, s8, s13
		v_mul_lo_u32 v0, s12, v1
		v_lshl_add_u32 v2, v0, 6, s8
		v_mul_lo_u32 v3, s12, v19
		v_lshl_add_u32 v2, v3, 1, v2
		v_mul_lo_u32 v10, s12, v4
		v_lshl_add_u32 v2, v10, 5, v2
		v_mul_lo_u32 v12, s12, v17
		v_lshl_add_u32 v2, v12, 4, v2
		v_mul_lo_u32 v13, s12, v21
		v_lshl_add_u32 v2, v13, 3, v2
		v_mul_lo_u32 v16, s12, v24
		v_lshl_add_u32 v2, v16, 2, v2
		v_lshl_add_u32 v20, v7, 5, v2
		v_lshl_add_u32 v20, v11, 4, v20
		v_lshl_add_u32 v20, v14, 3, v20
		s_and_saveexec_b64 s[56:57], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_2
		buffer_store_dwordx2 v[8:9], v20, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_2:
		s_andn2_b64 exec, s[56:57], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_2
.Lv9_beyond_hotloop.exec_endif_2:
		s_mov_b64 exec, s[56:57]
		v_lshlrev_b32_e32 v8, 4, v7
		v_lshl_add_u32 v9, v14, 2, 32
		v_lshlrev_b32_e32 v20, 3, v11
		v_bitop3_b32 v9, v8, v9, v20 bitop3:0x96
		v_lshl_add_u32 v22, v9, 1, v2
		s_and_saveexec_b64 s[56:57], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_3
		buffer_store_dwordx2 v[26:27], v22, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_3:
		s_andn2_b64 exec, s[56:57], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_3
.Lv9_beyond_hotloop.exec_endif_3:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v22, v14, 2, 64
		v_bitop3_b32 v22, v8, v22, v20 bitop3:0x96
		v_lshl_add_u32 v23, v22, 1, v2
		s_and_saveexec_b64 s[56:57], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_4
		buffer_store_dwordx2 v[92:93], v23, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_4:
		s_andn2_b64 exec, s[56:57], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_4
.Lv9_beyond_hotloop.exec_endif_4:
		s_mov_b64 exec, s[56:57]
		v_lshlrev_b32_e32 v23, 2, v14
		v_add_u32_e32 v23, 0x60, v23
		v_bitop3_b32 v8, v8, v23, v20 bitop3:0x96
		v_lshl_add_u32 v2, v8, 1, v2
		s_and_saveexec_b64 s[56:57], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_5
		buffer_store_dwordx2 v[94:95], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_5:
		s_andn2_b64 exec, s[56:57], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_5
.Lv9_beyond_hotloop.exec_endif_5:
		s_mov_b64 exec, s[56:57]
		v_lshlrev_b32_e32 v1, 5, v1
		v_lshlrev_b32_e32 v2, 4, v4
		v_lshlrev_b32_e32 v4, 3, v17
		v_lshlrev_b32_e32 v17, 2, v21
		v_add_u32_e32 v20, 64, v19
		v_lshlrev_b32_e32 v21, 1, v24
		v_xor_b32_e32 v20, v20, v21
		v_bitop3_b32 v20, v4, v17, v20 bitop3:0x96
		v_bitop3_b32 v20, v1, v2, v20 bitop3:0x96
		v_mul_lo_u32 v20, s12, v20
		v_lshl_add_u32 v23, v20, 1, s8
		v_lshl_add_u32 v24, v7, 5, v23
		v_lshl_add_u32 v24, v11, 4, v24
		v_lshl_add_u32 v24, v14, 3, v24
		s_and_saveexec_b64 s[56:57], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_6
		buffer_store_dwordx2 v[96:97], v24, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_6:
		s_andn2_b64 exec, s[56:57], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_6
.Lv9_beyond_hotloop.exec_endif_6:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v24, v9, 1, v23
		s_and_saveexec_b64 s[56:57], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_7
		buffer_store_dwordx2 v[98:99], v24, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_7:
		s_andn2_b64 exec, s[56:57], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_7
.Lv9_beyond_hotloop.exec_endif_7:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v24, v22, 1, v23
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_8
		buffer_store_dwordx2 v[100:101], v24, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_8:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_8
.Lv9_beyond_hotloop.exec_endif_8:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v23, v8, 1, v23
		s_and_saveexec_b64 s[56:57], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_9
		buffer_store_dwordx2 v[102:103], v23, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_9:
		s_andn2_b64 exec, s[56:57], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_9
.Lv9_beyond_hotloop.exec_endif_9:
		s_mov_b64 exec, s[56:57]
		v_add_u32_e32 v23, 0x80, v19
		v_xor_b32_e32 v23, v23, v21
		v_bitop3_b32 v23, v4, v17, v23 bitop3:0x96
		v_bitop3_b32 v23, v1, v2, v23 bitop3:0x96
		v_mul_lo_u32 v23, s12, v23
		v_lshl_add_u32 v24, v23, 1, s8
		v_lshl_add_u32 v25, v7, 5, v24
		v_lshl_add_u32 v25, v11, 4, v25
		v_lshl_add_u32 v25, v14, 3, v25
		s_and_saveexec_b64 s[56:57], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_10
		buffer_store_dwordx2 v[104:105], v25, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_10:
		s_andn2_b64 exec, s[56:57], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_10
.Lv9_beyond_hotloop.exec_endif_10:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v25, v9, 1, v24
		s_and_saveexec_b64 s[56:57], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_11
		buffer_store_dwordx2 v[106:107], v25, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_11:
		s_andn2_b64 exec, s[56:57], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_11
.Lv9_beyond_hotloop.exec_endif_11:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v25, v22, 1, v24
		s_and_saveexec_b64 s[56:57], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_12
		buffer_store_dwordx2 v[108:109], v25, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_12:
		s_andn2_b64 exec, s[56:57], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_12
.Lv9_beyond_hotloop.exec_endif_12:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v24, v8, 1, v24
		s_and_saveexec_b64 s[56:57], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_13
		buffer_store_dwordx2 v[110:111], v24, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_13:
		s_andn2_b64 exec, s[56:57], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_13
.Lv9_beyond_hotloop.exec_endif_13:
		s_mov_b64 exec, s[56:57]
		v_add_u32_e32 v19, 0xc0, v19
		v_xor_b32_e32 v19, v19, v21
		v_bitop3_b32 v4, v4, v17, v19 bitop3:0x96
		v_bitop3_b32 v1, v1, v2, v4 bitop3:0x96
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v2, v1, 1, s8
		v_lshl_add_u32 v4, v7, 5, v2
		v_lshl_add_u32 v4, v11, 4, v4
		v_lshl_add_u32 v4, v14, 3, v4
		s_and_saveexec_b64 s[56:57], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_14
		buffer_store_dwordx2 v[112:113], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_14:
		s_andn2_b64 exec, s[56:57], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_14
.Lv9_beyond_hotloop.exec_endif_14:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v4, v9, 1, v2
		s_and_saveexec_b64 s[56:57], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_15
		buffer_store_dwordx2 v[114:115], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_15:
		s_andn2_b64 exec, s[56:57], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_15
.Lv9_beyond_hotloop.exec_endif_15:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v4, v22, 1, v2
		s_and_saveexec_b64 s[56:57], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_16
		buffer_store_dwordx2 v[116:117], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_16:
		s_andn2_b64 exec, s[56:57], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_16
.Lv9_beyond_hotloop.exec_endif_16:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v8, 1, v2
		s_and_saveexec_b64 s[56:57], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_17
		buffer_store_dwordx2 v[118:119], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_17:
		s_andn2_b64 exec, s[56:57], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_17
.Lv9_beyond_hotloop.exec_endif_17:
		s_mov_b64 exec, s[56:57]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[172:175], v[32:35], v[28:31], v[172:175]
		s_add_i32 s4, s31, 0x80
		v_add_u32_e32 v2, s4, v5
		v_add_u32_e32 v4, s4, v15
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_add_u32_e32 v5, s4, v18
		v_add_u32_e32 v6, s4, v6
		v_cmp_lt_i32_e64 vcc, v2, s9
		s_mov_b64 s[4:5], vcc
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[28:31], v[180:183]
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v4, s9
		s_mov_b64 s[10:11], vcc
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[28:31], v[184:187]
		s_and_b32 s14, s2, s10
		s_and_b32 s15, s3, s11
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[20:21], vcc
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[40:43], v[200:203]
		s_and_b32 s22, s2, s20
		s_and_b32 s23, s3, s21
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[24:25], vcc
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[40:43], v[188:191]
		s_and_b32 s8, s2, s24
		s_and_b32 s9, s3, s25
		s_and_b32 s2, s32, s4
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[40:43], v[192:195]
		s_and_b32 s3, s33, s5
		s_and_b32 s26, s32, s10
		s_and_b32 s27, s33, s11
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[40:43], v[196:199]
		s_and_b32 s28, s32, s20
		s_and_b32 s29, s33, s21
		s_and_b32 s30, s32, s24
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[48:51], v[212:215]
		s_and_b32 s31, s33, s25
		s_and_b32 s32, s42, s4
		s_and_b32 s33, s43, s5
		v_mfma_f32_16x16x32_f16 v[204:207], v[32:35], v[48:51], v[204:207]
		s_and_b32 s34, s42, s10
		s_and_b32 s35, s43, s11
		s_and_b32 s36, s42, s20
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[48:51], v[208:211]
		s_and_b32 s37, s43, s21
		s_and_b32 s38, s42, s24
		s_and_b32 s39, s43, s25
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[48:51], v[216:219]
		s_and_b32 s40, s52, s4
		s_and_b32 s41, s53, s5
		s_and_b32 s4, s52, s10
		v_mfma_f32_16x16x32_f16 v[232:235], v[84:87], v[56:59], v[232:235]
		s_and_b32 s5, s53, s11
		s_and_b32 s10, s52, s20
		s_and_b32 s11, s53, s21
		v_mfma_f32_16x16x32_f16 v[220:223], v[32:35], v[56:59], v[220:223]
		s_and_b32 s20, s52, s24
		s_and_b32 s21, s53, s25
		s_add_i32 s0, s0, 0x100
		v_mfma_f32_16x16x32_f16 v[224:227], v[68:71], v[56:59], v[224:227]
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s13
		v_lshl_add_u32 v0, v0, 6, s0
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[56:59], v[228:231]
		v_lshl_add_u32 v0, v3, 1, v0
		v_lshl_add_u32 v0, v10, 5, v0
		v_lshl_add_u32 v0, v12, 4, v0
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[36:39], v[172:175]
		v_lshl_add_u32 v0, v13, 3, v0
		v_lshl_add_u32 v0, v16, 2, v0
		v_lshl_add_u32 v2, v7, 5, v0
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[36:39], v[176:179]
		v_lshl_add_u32 v2, v11, 4, v2
		v_lshl_add_u32 v2, v14, 3, v2
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[36:39], v[180:183]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[36:39], v[184:187]
		v_cvt_pk_f16_f32 v4, v172, v173
		v_cvt_pk_f16_f32 v5, v174, v175
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[44:47], v[188:191]
		v_cvt_pk_f16_f32 v12, v176, v177
		v_cvt_pk_f16_f32 v13, v178, v179
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[44:47], v[192:195]
		v_cvt_pk_f16_f32 v16, v180, v181
		v_cvt_pk_f16_f32 v17, v182, v183
		v_cvt_pk_f16_f32 v18, v184, v185
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[44:47], v[196:199]
		v_cvt_pk_f16_f32 v19, v186, v187
		v_cvt_pk_f16_f32 v24, v188, v189
		v_cvt_pk_f16_f32 v25, v190, v191
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[52:55], v[212:215]
		v_cvt_pk_f16_f32 v26, v192, v193
		v_cvt_pk_f16_f32 v27, v194, v195
		v_cvt_pk_f16_f32 v28, v200, v201
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[52:55], v[204:207]
		v_cvt_pk_f16_f32 v30, v196, v197
		v_cvt_pk_f16_f32 v31, v198, v199
		v_cvt_pk_f16_f32 v29, v202, v203
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[52:55], v[208:211]
		v_cvt_pk_f16_f32 v32, v212, v213
		v_cvt_pk_f16_f32 v33, v214, v215
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[232:235], v[88:91], v[60:63], v[232:235]
		v_cvt_pk_f16_f32 v34, v204, v205
		v_cvt_pk_f16_f32 v35, v206, v207
		v_mfma_f32_16x16x32_f16 v[220:223], v[64:67], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[72:75], v[60:63], v[224:227]
		v_cvt_pk_f16_f32 v36, v208, v209
		v_cvt_pk_f16_f32 v37, v210, v211
		v_mfma_f32_16x16x32_f16 v[228:231], v[80:83], v[60:63], v[228:231]
		v_cvt_pk_f16_f32 v38, v216, v217
		v_cvt_pk_f16_f32 v39, v218, v219
		v_cvt_pk_f16_f32 v40, v232, v233
		v_cvt_pk_f16_f32 v41, v234, v235
		v_cvt_pk_f16_f32 v42, v220, v221
		v_cvt_pk_f16_f32 v43, v222, v223
		v_cvt_pk_f16_f32 v44, v224, v225
		v_cvt_pk_f16_f32 v45, v226, v227
		v_cvt_pk_f16_f32 v46, v228, v229
		v_cvt_pk_f16_f32 v47, v230, v231
		s_and_saveexec_b64 s[56:57], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_18
		buffer_store_dwordx2 v[4:5], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_18:
		s_andn2_b64 exec, s[56:57], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_18
.Lv9_beyond_hotloop.exec_endif_18:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v9, 1, v0
		s_and_saveexec_b64 s[56:57], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_19
		buffer_store_dwordx2 v[12:13], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_19:
		s_andn2_b64 exec, s[56:57], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_19
.Lv9_beyond_hotloop.exec_endif_19:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v22, 1, v0
		s_and_saveexec_b64 s[56:57], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_20
		buffer_store_dwordx2 v[16:17], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_20:
		s_andn2_b64 exec, s[56:57], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_20
.Lv9_beyond_hotloop.exec_endif_20:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v8, 1, v0
		s_and_saveexec_b64 s[56:57], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_21
		buffer_store_dwordx2 v[18:19], v0, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_21:
		s_andn2_b64 exec, s[56:57], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_21
.Lv9_beyond_hotloop.exec_endif_21:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v20, 1, s0
		v_lshl_add_u32 v2, v7, 5, v0
		v_lshl_add_u32 v2, v11, 4, v2
		v_lshl_add_u32 v2, v14, 3, v2
		s_and_saveexec_b64 s[56:57], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_22
		buffer_store_dwordx2 v[24:25], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_22:
		s_andn2_b64 exec, s[56:57], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_22
.Lv9_beyond_hotloop.exec_endif_22:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v9, 1, v0
		s_and_saveexec_b64 s[56:57], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_23
		buffer_store_dwordx2 v[26:27], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_23:
		s_andn2_b64 exec, s[56:57], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_23
.Lv9_beyond_hotloop.exec_endif_23:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v22, 1, v0
		s_and_saveexec_b64 s[56:57], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_24
		buffer_store_dwordx2 v[30:31], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_24:
		s_andn2_b64 exec, s[56:57], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_24
.Lv9_beyond_hotloop.exec_endif_24:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v8, 1, v0
		s_and_saveexec_b64 s[56:57], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_25
		buffer_store_dwordx2 v[28:29], v0, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_25:
		s_andn2_b64 exec, s[56:57], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_25
.Lv9_beyond_hotloop.exec_endif_25:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v23, 1, s0
		v_lshl_add_u32 v2, v7, 5, v0
		v_lshl_add_u32 v2, v11, 4, v2
		v_lshl_add_u32 v2, v14, 3, v2
		s_and_saveexec_b64 s[56:57], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_26
		buffer_store_dwordx2 v[34:35], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_26:
		s_andn2_b64 exec, s[56:57], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_26
.Lv9_beyond_hotloop.exec_endif_26:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v9, 1, v0
		s_and_saveexec_b64 s[56:57], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_27
		buffer_store_dwordx2 v[36:37], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_27:
		s_andn2_b64 exec, s[56:57], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_27
.Lv9_beyond_hotloop.exec_endif_27:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v2, v22, 1, v0
		s_and_saveexec_b64 s[56:57], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_28
		buffer_store_dwordx2 v[32:33], v2, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_28:
		s_andn2_b64 exec, s[56:57], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_28
.Lv9_beyond_hotloop.exec_endif_28:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v8, 1, v0
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_29
		buffer_store_dwordx2 v[38:39], v0, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_29:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_29
.Lv9_beyond_hotloop.exec_endif_29:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v1, 1, s0
		v_lshl_add_u32 v1, v7, 5, v0
		v_lshl_add_u32 v1, v11, 4, v1
		v_lshl_add_u32 v1, v14, 3, v1
		s_and_saveexec_b64 s[56:57], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_30
		buffer_store_dwordx2 v[42:43], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_30:
		s_andn2_b64 exec, s[56:57], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_30
.Lv9_beyond_hotloop.exec_endif_30:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v1, v9, 1, v0
		s_and_saveexec_b64 s[56:57], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_31
		buffer_store_dwordx2 v[44:45], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_31:
		s_andn2_b64 exec, s[56:57], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_31
.Lv9_beyond_hotloop.exec_endif_31:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v1, v22, 1, v0
		s_and_saveexec_b64 s[56:57], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_32
		buffer_store_dwordx2 v[46:47], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_32:
		s_andn2_b64 exec, s[56:57], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_32
.Lv9_beyond_hotloop.exec_endif_32:
		s_mov_b64 exec, s[56:57]
		v_lshl_add_u32 v0, v8, 1, v0
		s_and_saveexec_b64 s[56:57], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_33
		buffer_store_dwordx2 v[40:41], v0, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_33:
		s_andn2_b64 exec, s[56:57], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_33
.Lv9_beyond_hotloop.exec_endif_33:
		s_mov_b64 exec, s[56:57]
		s_endpgm
	.size	v9_beyond_hotloop, .-v9_beyond_hotloop
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel v9_beyond_hotloop
		.amdhsa_group_segment_fixed_size 135072
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 236
		.amdhsa_next_free_sgpr 58
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
	.set .Lv9_beyond_hotloop.num_vgpr, 236
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 58
	.set .Lv9_beyond_hotloop.num_named_barrier, 0
	.set .Lv9_beyond_hotloop.private_seg_size, 0
	.set .Lv9_beyond_hotloop.uses_vcc, 1
	.set .Lv9_beyond_hotloop.uses_flat_scratch, 0
	.set .Lv9_beyond_hotloop.has_dyn_sized_stack, 0
	.set .Lv9_beyond_hotloop.has_recursion, 0
	.set .Lv9_beyond_hotloop.has_indirect_call, 0
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
      - .name:           arg3
        .offset:         24
        .size:           4
        .value_kind:     by_value
      - .name:           arg4
        .offset:         28
        .size:           4
        .value_kind:     by_value
      - .name:           arg5
        .offset:         32
        .size:           4
        .value_kind:     by_value
      - .name:           arg6
        .offset:         36
        .size:           4
        .value_kind:     by_value
      - .name:           arg7
        .offset:         40
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 135072
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           v9_beyond_hotloop
    .private_segment_fixed_size: 0
    .sgpr_count:     58
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     236
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
