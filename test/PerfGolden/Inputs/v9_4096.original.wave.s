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
		s_mov_b32 s16, s4
		s_mov_b32 s17, s5
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s4, s4, 6
		s_mul_i32 s4, 0x420, s4
		s_mov_b32 m0, s4
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
		s_mul_i32 s5, s1, s10
		s_lshl_b32 s5, s5, 11
		s_mul_i32 s13, s14, s10
		s_lshl_b32 s13, s13, 9
		s_add_i32 s24, s5, s13
		v_add_u32_e32 v26, s24, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mul_i32 s15, s15, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s25, s10, 7
		s_add_i32 s26, s25, s5
		s_add_i32 s26, s26, s13
		v_add_u32_e32 v26, s26, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mul_i32 s27, s0, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s28, s10, 8
		s_add_i32 s29, s28, s5
		s_add_i32 s29, s29, s13
		v_add_u32_e32 v26, s29, v9
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		v_mul_lo_u32 v26, s11, v4
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s30, 0x180, s10
		s_add_i32 s31, s30, s5
		s_add_i32 s31, s31, s13
		v_add_u32_e32 v27, s31, v9
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_mul_lo_u32 v27, s11, v1
		s_add_i32 m0, m0, 0xa4e0
		v_lshlrev_b32_e32 v26, 4, v26
		v_lshl_add_u32 v26, v27, 5, v26
		v_mul_lo_u32 v27, s11, v7
		v_lshl_add_u32 v26, v27, 3, v26
		v_mul_lo_u32 v27, s11, v11
		v_lshl_add_u32 v26, v27, 2, v26
		v_mul_lo_u32 v27, s11, v14
		v_lshlrev_b32_e32 v27, 1, v27
		v_add3_u32 v26, v26, v27, v20
		v_lshl_add_u32 v26, v17, 7, v26
		v_add3_u32 v26, v26, v22, v25
		s_lshl_b32 s0, s0, 9
		v_add_u32_e32 v27, s0, v26
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_lshl_b32 s32, s11, 6
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s33, s0, s32
		v_add_u32_e32 v27, s33, v26
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_add_i32 s34, s0, 0x100
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v27, s34, v26
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_add_i32 s32, s34, s32
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v27, s32, v26
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_mul_i32 s35, s11, 64
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s36, s5, 0x80
		s_add_i32 s36, s36, s13
		v_add_u32_e32 v27, s36, v9
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_add_u32_e32 v9, s13, v9
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v9, s5, v9
		v_add_u32_e32 v9, 0x80, v9
		v_add_u32_e32 v27, s25, v9
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_and_b32_e32 v27, 3, v0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v28, s28, v9
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_add_i32 s5, s35, s35
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v9, s30, v9
		s_lshl_b32 s13, s11, 7
		s_mul_i32 s11, 0xc0, s11
		v_mov_b32_e32 v28, 0x840
		v_mul_lo_u32 v28, v28, v3
		v_and_b32_e32 v29, 63, v0
		v_lshrrev_b32_e32 v30, 4, v29
		v_lshlrev_b32_e32 v30, 4, v30
		v_and_b32_e32 v29, 15, v29
		v_lshrrev_b32_e32 v31, 3, v29
		v_mov_b32_e32 v32, 0x420
		v_mul_lo_u32 v32, v32, v31
		v_add3_u32 v28, v28, v30, v32
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_lshrrev_b32_e32 v9, 2, v29
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s25, s0, s13
		v_add_u32_e32 v30, s25, v26
		buffer_load_dwordx4 v30, s[16:19], 0 offen lds
		v_and_b32_e32 v9, 1, v9
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s28, s0, s11
		v_add_u32_e32 v30, s28, v26
		buffer_load_dwordx4 v30, s[16:19], 0 offen lds
		s_add_i32 s13, s34, s13
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v30, s13, v26
		buffer_load_dwordx4 v30, s[16:19], 0 offen lds
		s_add_i32 s11, s34, s11
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v30, s11, v26
		v_lshl_add_u32 v9, v9, 9, v28
		buffer_load_dwordx4 v30, s[16:19], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_lshrrev_b32_e32 v28, 1, v29
		v_and_b32_e32 v28, 1, v28
		v_lshl_add_u32 v9, v28, 8, v9
		v_and_b32_e32 v28, 1, v29
		v_lshl_add_u32 v9, v28, 7, v9
		ds_read_b128 v[28:31], v9
		ds_read_b128 v[32:35], v9 offset:64
		ds_read_b128 v[36:39], v9 offset:8448
		ds_read_b128 v[40:43], v9 offset:8512
		ds_read_b128 v[44:47], v9 offset:16896
		ds_read_b128 v[48:51], v9 offset:16960
		ds_read_b128 v[52:55], v9 offset:25344
		ds_read_b128 v[56:59], v9 offset:25408
		v_lshlrev_b32_e32 v27, 3, v27
		v_add_u32_e32 v27, 0x10000, v27
		v_lshlrev_b32_e32 v60, 5, v7
		v_and_b32_e32 v61, 3, v13
		v_mov_b32_e32 v62, 0x840
		v_mul_lo_u32 v62, v62, v61
		v_add3_u32 v27, v27, v60, v62
		v_and_b32_e32 v61, 3, v18
		v_lshl_add_u32 v27, v61, 8, v27
		ds_read_b64_tr_b16 v[64:65], v27 offset:2016
		ds_read_b64_tr_b16 v[66:67], v27 offset:3072
		ds_read_b64_tr_b16 v[68:69], v27 offset:10464
		ds_read_b64_tr_b16 v[70:71], v27 offset:11520
		ds_read_b64_tr_b16 v[72:73], v27 offset:2080
		ds_read_b64_tr_b16 v[74:75], v27 offset:3136
		ds_read_b64_tr_b16 v[76:77], v27 offset:10528
		ds_read_b64_tr_b16 v[78:79], v27 offset:11584
		ds_read_b64_tr_b16 v[80:81], v27 offset:2144
		ds_read_b64_tr_b16 v[82:83], v27 offset:3200
		ds_read_b64_tr_b16 v[84:85], v27 offset:10592
		ds_read_b64_tr_b16 v[86:87], v27 offset:11648
		ds_read_b64_tr_b16 v[88:89], v27 offset:2208
		ds_read_b64_tr_b16 v[90:91], v27 offset:3264
		ds_read_b64_tr_b16 v[92:93], v27 offset:10656
		ds_read_b64_tr_b16 v[94:95], v27 offset:11712
		s_mov_b32 s30, 0
		v_cmp_ne_u32_e64 vcc, v1, s30
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[58:59], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[58:59]
		s_setprio 0
		s_mov_b32 s36, 0x80
		s_mov_b32 s37, s36
		s_lshl_b32 s10, s10, 1
		v_mul_lo_u32 v61, s10, v17
		v_add_u32_e32 v62, 0x100, v61
		v_add3_u32 v63, s24, v2, v5
		v_add3_u32 v63, v63, v8, v12
		v_add3_u32 v63, v63, v15, v20
		v_add3_u32 v63, v63, v22, v25
		v_add_u32_e32 v96, v62, v63
		v_add3_u32 v97, s26, v2, v5
		v_add3_u32 v97, v97, v8, v12
		v_add3_u32 v97, v97, v15, v20
		v_add3_u32 v97, v97, v22, v25
		v_add_u32_e32 v98, v62, v97
		v_add3_u32 v99, s29, v2, v5
		v_add3_u32 v99, v99, v8, v12
		v_add3_u32 v99, v99, v15, v20
		v_add3_u32 v99, v99, v22, v25
		v_add_u32_e32 v100, v62, v99
		v_add3_u32 v2, s31, v2, v5
		v_add3_u32 v2, v2, v8, v12
		v_add3_u32 v2, v2, v15, v20
		v_add3_u32 v2, v2, v22, v25
		v_add_u32_e32 v5, v62, v2
		v_add_u32_e32 v8, 0x180, v61
		v_add_u32_e32 v12, v8, v63
		v_add_u32_e32 v15, v8, v97
		v_add_u32_e32 v20, v8, v99
		v_add_u32_e32 v22, v8, v2
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_lshl_b32 s2, s5, 1
		s_lshl_b32 s3, s35, 1
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		s_mov_b32 s5, s30
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
.Lv9_beyond_hotloop.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[52:55], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[52:55], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[56:59], v[160:163]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b64_tr_b16 v[64:65], v27 offset:35776
		ds_read_b64_tr_b16 v[66:67], v27 offset:36832
		ds_read_b64_tr_b16 v[68:69], v27 offset:44224
		ds_read_b64_tr_b16 v[70:71], v27 offset:45280
		ds_read_b64_tr_b16 v[72:73], v27 offset:35840
		ds_read_b64_tr_b16 v[74:75], v27 offset:36896
		ds_read_b64_tr_b16 v[76:77], v27 offset:44288
		ds_read_b64_tr_b16 v[78:79], v27 offset:45344
		ds_read_b64_tr_b16 v[80:81], v27 offset:35904
		ds_read_b64_tr_b16 v[82:83], v27 offset:36960
		ds_read_b64_tr_b16 v[84:85], v27 offset:44352
		ds_read_b64_tr_b16 v[86:87], v27 offset:45408
		ds_read_b64_tr_b16 v[88:89], v27 offset:35968
		ds_read_b64_tr_b16 v[90:91], v27 offset:37024
		ds_read_b64_tr_b16 v[92:93], v27 offset:44416
		ds_read_b64_tr_b16 v[94:95], v27 offset:45472
		s_mov_b32 m0, s4
		s_add_i32 s10, s2, s3
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		s_add_i32 s24, s34, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s26, s0, s2
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_add_u32_e32 v2, s26, v26
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s26, s33, s2
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_add_u32_e32 v8, s26, v26
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s24, v26
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[52:55], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[52:55], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[52:55], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[56:59], v[224:227]
		s_setprio 1
		s_barrier
		ds_read_b128 v[28:31], v9 offset:33792
		ds_read_b128 v[32:35], v9 offset:33856
		ds_read_b128 v[36:39], v9 offset:42240
		ds_read_b128 v[40:43], v9 offset:42304
		ds_read_b128 v[44:47], v9 offset:50688
		ds_read_b128 v[48:51], v9 offset:50752
		ds_read_b128 v[52:55], v9 offset:59136
		ds_read_b128 v[56:59], v9 offset:59200
		ds_read_b64_tr_b16 v[64:65], v27 offset:18912
		ds_read_b64_tr_b16 v[66:67], v27 offset:19968
		ds_read_b64_tr_b16 v[68:69], v27 offset:27360
		ds_read_b64_tr_b16 v[70:71], v27 offset:28416
		ds_read_b64_tr_b16 v[72:73], v27 offset:18976
		ds_read_b64_tr_b16 v[74:75], v27 offset:20032
		ds_read_b64_tr_b16 v[76:77], v27 offset:27424
		ds_read_b64_tr_b16 v[78:79], v27 offset:28480
		ds_read_b64_tr_b16 v[80:81], v27 offset:19040
		ds_read_b64_tr_b16 v[82:83], v27 offset:20096
		ds_read_b64_tr_b16 v[84:85], v27 offset:27488
		ds_read_b64_tr_b16 v[86:87], v27 offset:28544
		ds_read_b64_tr_b16 v[88:89], v27 offset:19104
		ds_read_b64_tr_b16 v[90:91], v27 offset:20160
		ds_read_b64_tr_b16 v[92:93], v27 offset:27552
		ds_read_b64_tr_b16 v[94:95], v27 offset:28608
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s24, s32, s2
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		v_add_u32_e32 v2, s24, v26
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[52:55], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[52:55], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[56:59], v[160:163]
		s_setprio 1
		s_barrier
		ds_read_b64_tr_b16 v[64:65], v27 offset:52672
		ds_read_b64_tr_b16 v[66:67], v27 offset:53728
		ds_read_b64_tr_b16 v[68:69], v27 offset:61120
		ds_read_b64_tr_b16 v[70:71], v27 offset:62176
		ds_read_b64_tr_b16 v[72:73], v27 offset:52736
		ds_read_b64_tr_b16 v[74:75], v27 offset:53792
		ds_read_b64_tr_b16 v[76:77], v27 offset:61184
		ds_read_b64_tr_b16 v[78:79], v27 offset:62240
		ds_read_b64_tr_b16 v[80:81], v27 offset:52800
		ds_read_b64_tr_b16 v[82:83], v27 offset:53856
		ds_read_b64_tr_b16 v[84:85], v27 offset:61248
		ds_read_b64_tr_b16 v[86:87], v27 offset:62304
		ds_read_b64_tr_b16 v[88:89], v27 offset:52864
		ds_read_b64_tr_b16 v[90:91], v27 offset:53920
		ds_read_b64_tr_b16 v[92:93], v27 offset:61312
		ds_read_b64_tr_b16 v[94:95], v27 offset:62368
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s24, s13, s2
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 s26, s25, s2
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s26, v26
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 s26, s28, s2
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v8, s26, v26
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s24, v26
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[52:55], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[52:55], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[52:55], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[56:59], v[224:227]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[28:31], v9
		ds_read_b128 v[32:35], v9 offset:64
		ds_read_b128 v[36:39], v9 offset:8448
		ds_read_b128 v[40:43], v9 offset:8512
		ds_read_b128 v[44:47], v9 offset:16896
		ds_read_b128 v[48:51], v9 offset:16960
		ds_read_b128 v[52:55], v9 offset:25344
		ds_read_b128 v[56:59], v9 offset:25408
		ds_read_b64_tr_b16 v[64:65], v27 offset:2016
		ds_read_b64_tr_b16 v[66:67], v27 offset:3072
		ds_read_b64_tr_b16 v[68:69], v27 offset:10464
		ds_read_b64_tr_b16 v[70:71], v27 offset:11520
		ds_read_b64_tr_b16 v[72:73], v27 offset:2080
		ds_read_b64_tr_b16 v[74:75], v27 offset:3136
		ds_read_b64_tr_b16 v[76:77], v27 offset:10528
		ds_read_b64_tr_b16 v[78:79], v27 offset:11584
		ds_read_b64_tr_b16 v[80:81], v27 offset:2144
		ds_read_b64_tr_b16 v[82:83], v27 offset:3200
		ds_read_b64_tr_b16 v[84:85], v27 offset:10592
		ds_read_b64_tr_b16 v[86:87], v27 offset:11648
		ds_read_b64_tr_b16 v[88:89], v27 offset:2208
		ds_read_b64_tr_b16 v[90:91], v27 offset:3264
		ds_read_b64_tr_b16 v[92:93], v27 offset:10656
		ds_read_b64_tr_b16 v[94:95], v27 offset:11712
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s2, s11, s2
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s2, v26
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s37, s37, 0x80
		s_add_i32 s2, s10, s3
		s_setprio 0
		s_barrier
		s_add_u32 s20, s20, 0x100
		s_addc_u32 s21, s21, 0
		s_add_i32 s5, s5, 2
		s_cmp_lt_i32 s5, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		v_cmp_eq_u32_e64 vcc, v1, s30
		s_and_saveexec_b64 s[58:59], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[58:59]
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[52:55], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[52:55], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[56:59], v[160:163]
		ds_read_b64_tr_b16 v[64:65], v27 offset:35776
		ds_read_b64_tr_b16 v[66:67], v27 offset:36832
		ds_read_b64_tr_b16 v[68:69], v27 offset:44224
		ds_read_b64_tr_b16 v[70:71], v27 offset:45280
		ds_read_b64_tr_b16 v[72:73], v27 offset:35840
		ds_read_b64_tr_b16 v[74:75], v27 offset:36896
		ds_read_b64_tr_b16 v[76:77], v27 offset:44288
		ds_read_b64_tr_b16 v[78:79], v27 offset:45344
		ds_read_b64_tr_b16 v[80:81], v27 offset:35904
		ds_read_b64_tr_b16 v[82:83], v27 offset:36960
		ds_read_b64_tr_b16 v[84:85], v27 offset:44352
		ds_read_b64_tr_b16 v[86:87], v27 offset:45408
		ds_read_b64_tr_b16 v[88:89], v27 offset:35968
		ds_read_b64_tr_b16 v[90:91], v27 offset:37024
		ds_read_b64_tr_b16 v[92:93], v27 offset:44416
		ds_read_b64_tr_b16 v[94:95], v27 offset:45472
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[28:31], v[168:171]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[28:31], v[172:175]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[28:31], v[176:179]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[52:55], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[52:55], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[52:55], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[32:35], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[56:59], v[224:227]
		ds_read_b128 v[28:31], v9 offset:33792
		ds_read_b128 v[32:35], v9 offset:33856
		ds_read_b128 v[36:39], v9 offset:42240
		ds_read_b128 v[40:43], v9 offset:42304
		ds_read_b128 v[44:47], v9 offset:50688
		ds_read_b128 v[48:51], v9 offset:50752
		ds_read_b128 v[52:55], v9 offset:59136
		ds_read_b128 v[56:59], v9 offset:59200
		ds_read_b64_tr_b16 v[64:65], v27 offset:18912
		ds_read_b64_tr_b16 v[66:67], v27 offset:19968
		ds_read_b64_tr_b16 v[68:69], v27 offset:27360
		ds_read_b64_tr_b16 v[70:71], v27 offset:28416
		ds_read_b64_tr_b16 v[72:73], v27 offset:18976
		ds_read_b64_tr_b16 v[74:75], v27 offset:20032
		ds_read_b64_tr_b16 v[76:77], v27 offset:27424
		ds_read_b64_tr_b16 v[78:79], v27 offset:28480
		ds_read_b64_tr_b16 v[80:81], v27 offset:19040
		ds_read_b64_tr_b16 v[82:83], v27 offset:20096
		ds_read_b64_tr_b16 v[84:85], v27 offset:27488
		ds_read_b64_tr_b16 v[86:87], v27 offset:28544
		ds_read_b64_tr_b16 v[88:89], v27 offset:19104
		ds_read_b64_tr_b16 v[90:91], v27 offset:20160
		ds_read_b64_tr_b16 v[92:93], v27 offset:27552
		ds_read_b64_tr_b16 v[94:95], v27 offset:28608
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[28:31], v[104:107]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[28:31], v[108:111]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[28:31], v[112:115]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[52:55], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[52:55], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[32:35], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[56:59], v[160:163]
		ds_read_b64_tr_b16 v[64:65], v27 offset:52672
		ds_read_b64_tr_b16 v[66:67], v27 offset:53728
		ds_read_b64_tr_b16 v[68:69], v27 offset:61120
		ds_read_b64_tr_b16 v[70:71], v27 offset:62176
		ds_read_b64_tr_b16 v[72:73], v27 offset:52736
		ds_read_b64_tr_b16 v[74:75], v27 offset:53792
		ds_read_b64_tr_b16 v[76:77], v27 offset:61184
		ds_read_b64_tr_b16 v[78:79], v27 offset:62240
		ds_read_b64_tr_b16 v[80:81], v27 offset:52800
		ds_read_b64_tr_b16 v[82:83], v27 offset:53856
		ds_read_b64_tr_b16 v[84:85], v27 offset:61248
		ds_read_b64_tr_b16 v[86:87], v27 offset:62304
		ds_read_b64_tr_b16 v[88:89], v27 offset:52864
		ds_read_b64_tr_b16 v[90:91], v27 offset:53920
		ds_read_b64_tr_b16 v[92:93], v27 offset:61312
		ds_read_b64_tr_b16 v[94:95], v27 offset:62368
		v_cvt_pk_f16_f32 v8, v104, v105
		v_cvt_pk_f16_f32 v9, v106, v107
		v_cvt_pk_f16_f32 v26, v108, v109
		v_cvt_pk_f16_f32 v27, v110, v111
		v_cvt_pk_f16_f32 v62, v112, v113
		v_cvt_pk_f16_f32 v63, v114, v115
		v_cvt_pk_f16_f32 v96, v116, v117
		v_cvt_pk_f16_f32 v97, v118, v119
		v_cvt_pk_f16_f32 v98, v120, v121
		v_cvt_pk_f16_f32 v99, v122, v123
		v_cvt_pk_f16_f32 v100, v124, v125
		v_cvt_pk_f16_f32 v101, v126, v127
		v_cvt_pk_f16_f32 v102, v128, v129
		v_cvt_pk_f16_f32 v103, v130, v131
		v_cvt_pk_f16_f32 v104, v132, v133
		v_cvt_pk_f16_f32 v105, v134, v135
		v_cvt_pk_f16_f32 v106, v136, v137
		v_cvt_pk_f16_f32 v107, v138, v139
		v_cvt_pk_f16_f32 v108, v140, v141
		v_cvt_pk_f16_f32 v109, v142, v143
		v_cvt_pk_f16_f32 v110, v144, v145
		v_cvt_pk_f16_f32 v111, v146, v147
		v_cvt_pk_f16_f32 v112, v148, v149
		v_cvt_pk_f16_f32 v113, v150, v151
		v_cvt_pk_f16_f32 v114, v152, v153
		v_cvt_pk_f16_f32 v115, v154, v155
		v_cvt_pk_f16_f32 v116, v156, v157
		v_cvt_pk_f16_f32 v117, v158, v159
		v_cvt_pk_f16_f32 v118, v160, v161
		v_cvt_pk_f16_f32 v119, v162, v163
		v_cvt_pk_f16_f32 v120, v164, v165
		v_cvt_pk_f16_f32 v121, v166, v167
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
		v_add_u32_e32 v13, s27, v5
		v_bitop3_b32 v15, 32, v12, v10 bitop3:0x96
		v_xor_b32_e32 v15, v15, v6
		v_add_u32_e32 v16, s27, v15
		v_bitop3_b32 v18, 64, v12, v10 bitop3:0x96
		v_xor_b32_e32 v18, v18, v6
		v_add_u32_e32 v22, s27, v18
		v_xor_b32_e32 v12, 0x60, v12
		v_xor_b32_e32 v10, v12, v10
		v_xor_b32_e32 v6, v10, v6
		v_add_u32_e32 v10, s27, v6
		v_cmp_lt_i32_e64 vcc, v2, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v13, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v16, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s16, s2, s10
		s_and_b32 s17, s3, s11
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[18:19], vcc
		s_and_b32 s24, s2, s18
		s_and_b32 s25, s3, s19
		v_cmp_lt_i32_e64 vcc, v10, s9
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s2, s28
		s_and_b32 s31, s3, s29
		v_cmp_lt_i32_e64 vcc, v3, s8
		s_mov_b64 s[32:33], vcc
		s_and_b32 s36, s32, s4
		s_and_b32 s37, s33, s5
		s_and_b32 s38, s32, s10
		s_and_b32 s39, s33, s11
		s_and_b32 s40, s32, s18
		s_and_b32 s41, s33, s19
		s_and_b32 s42, s32, s28
		s_and_b32 s43, s33, s29
		v_cmp_lt_i32_e64 vcc, v20, s8
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s44, s4
		s_and_b32 s47, s45, s5
		s_and_b32 s48, s44, s10
		s_and_b32 s49, s45, s11
		s_and_b32 s50, s44, s18
		s_and_b32 s51, s45, s19
		s_and_b32 s52, s44, s28
		s_and_b32 s53, s45, s29
		v_cmp_lt_i32_e64 vcc, v0, s8
		s_mov_b64 s[54:55], vcc
		s_and_b32 s56, s54, s4
		s_and_b32 s57, s55, s5
		s_and_b32 s4, s54, s10
		s_and_b32 s5, s55, s11
		s_and_b32 s10, s54, s18
		s_and_b32 s11, s55, s19
		s_and_b32 s18, s54, s28
		s_and_b32 s19, s55, s29
		s_mul_i32 s1, s1, s12
		s_lshl_b32 s1, s1, 11
		s_add_i32 s0, s0, s1
		s_mul_i32 s8, s14, s12
		s_lshl_b32 s8, s8, 9
		s_add_i32 s0, s0, s8
		v_mul_lo_u32 v0, s12, v1
		v_lshl_add_u32 v2, v0, 6, s0
		v_mul_lo_u32 v3, s12, v19
		v_lshl_add_u32 v2, v3, 1, v2
		v_mul_lo_u32 v10, s12, v4
		v_lshl_add_u32 v2, v10, 5, v2
		v_mul_lo_u32 v12, s12, v17
		v_lshl_add_u32 v2, v12, 4, v2
		v_mul_lo_u32 v13, s12, v21
		v_lshl_add_u32 v2, v13, 3, v2
		v_mul_lo_u32 v16, s12, v24
		v_lshlrev_b32_e32 v20, 2, v16
		v_add3_u32 v22, v2, v20, v60
		v_lshl_add_u32 v22, v11, 4, v22
		v_lshl_add_u32 v22, v14, 3, v22
		s_and_saveexec_b64 s[58:59], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_2
		buffer_store_dwordx2 v[8:9], v22, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_2:
		s_andn2_b64 exec, s[58:59], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_2
.Lv9_beyond_hotloop.exec_endif_2:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v2, v16, 2, v2
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshl_add_u32 v8, v14, 2, 32
		v_lshlrev_b32_e32 v9, 3, v11
		v_bitop3_b32 v8, v7, v8, v9 bitop3:0x96
		v_lshl_add_u32 v22, v8, 1, v2
		s_and_saveexec_b64 s[58:59], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_3
		buffer_store_dwordx2 v[26:27], v22, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_3:
		s_andn2_b64 exec, s[58:59], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_3
.Lv9_beyond_hotloop.exec_endif_3:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v22, v14, 2, 64
		v_bitop3_b32 v22, v7, v22, v9 bitop3:0x96
		v_lshl_add_u32 v23, v22, 1, v2
		s_and_saveexec_b64 s[58:59], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_4
		buffer_store_dwordx2 v[62:63], v23, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_4:
		s_andn2_b64 exec, s[58:59], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_4
.Lv9_beyond_hotloop.exec_endif_4:
		s_mov_b64 exec, s[58:59]
		v_lshlrev_b32_e32 v23, 2, v14
		v_add_u32_e32 v23, 0x60, v23
		v_bitop3_b32 v7, v7, v23, v9 bitop3:0x96
		v_lshl_add_u32 v2, v7, 1, v2
		s_and_saveexec_b64 s[58:59], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_5
		buffer_store_dwordx2 v[96:97], v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_5:
		s_andn2_b64 exec, s[58:59], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_5
.Lv9_beyond_hotloop.exec_endif_5:
		s_mov_b64 exec, s[58:59]
		v_lshlrev_b32_e32 v1, 5, v1
		v_lshlrev_b32_e32 v2, 4, v4
		v_lshlrev_b32_e32 v4, 3, v17
		v_lshlrev_b32_e32 v9, 2, v21
		v_add_u32_e32 v17, 64, v19
		v_lshlrev_b32_e32 v21, 1, v24
		v_xor_b32_e32 v17, v17, v21
		v_bitop3_b32 v17, v4, v9, v17 bitop3:0x96
		v_bitop3_b32 v17, v1, v2, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshlrev_b32_e32 v23, 1, v17
		v_add3_u32 v24, s0, v23, v60
		v_lshl_add_u32 v24, v11, 4, v24
		v_lshl_add_u32 v24, v14, 3, v24
		s_and_saveexec_b64 s[58:59], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_6
		buffer_store_dwordx2 v[98:99], v24, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_6:
		s_andn2_b64 exec, s[58:59], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_6
.Lv9_beyond_hotloop.exec_endif_6:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v24, v17, 1, s0
		v_lshl_add_u32 v25, v8, 1, v24
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_7
		buffer_store_dwordx2 v[100:101], v25, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_7:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_7
.Lv9_beyond_hotloop.exec_endif_7:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v25, v22, 1, v24
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_8
		buffer_store_dwordx2 v[102:103], v25, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_8:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_8
.Lv9_beyond_hotloop.exec_endif_8:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v24, v7, 1, v24
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_9
		buffer_store_dwordx2 v[104:105], v24, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_9:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_9
.Lv9_beyond_hotloop.exec_endif_9:
		s_mov_b64 exec, s[58:59]
		v_add_u32_e32 v24, 0x80, v19
		v_xor_b32_e32 v24, v24, v21
		v_bitop3_b32 v24, v4, v9, v24 bitop3:0x96
		v_bitop3_b32 v24, v1, v2, v24 bitop3:0x96
		v_mul_lo_u32 v24, s12, v24
		v_lshlrev_b32_e32 v25, 1, v24
		v_add3_u32 v26, s0, v25, v60
		v_lshl_add_u32 v26, v11, 4, v26
		v_lshl_add_u32 v26, v14, 3, v26
		s_and_saveexec_b64 s[58:59], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_10
		buffer_store_dwordx2 v[106:107], v26, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_10:
		s_andn2_b64 exec, s[58:59], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_10
.Lv9_beyond_hotloop.exec_endif_10:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v26, v24, 1, s0
		v_lshl_add_u32 v27, v8, 1, v26
		s_and_saveexec_b64 s[58:59], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_11
		buffer_store_dwordx2 v[108:109], v27, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_11:
		s_andn2_b64 exec, s[58:59], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_11
.Lv9_beyond_hotloop.exec_endif_11:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v27, v22, 1, v26
		s_and_saveexec_b64 s[58:59], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_12
		buffer_store_dwordx2 v[110:111], v27, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_12:
		s_andn2_b64 exec, s[58:59], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_12
.Lv9_beyond_hotloop.exec_endif_12:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v26, v7, 1, v26
		s_and_saveexec_b64 s[58:59], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_13
		buffer_store_dwordx2 v[112:113], v26, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_13:
		s_andn2_b64 exec, s[58:59], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_13
.Lv9_beyond_hotloop.exec_endif_13:
		s_mov_b64 exec, s[58:59]
		v_add_u32_e32 v19, 0xc0, v19
		v_xor_b32_e32 v19, v19, v21
		v_bitop3_b32 v4, v4, v9, v19 bitop3:0x96
		v_bitop3_b32 v1, v1, v2, v4 bitop3:0x96
		v_mul_lo_u32 v1, s12, v1
		v_lshlrev_b32_e32 v2, 1, v1
		v_add3_u32 v4, s0, v2, v60
		v_lshl_add_u32 v4, v11, 4, v4
		v_lshl_add_u32 v4, v14, 3, v4
		s_and_saveexec_b64 s[58:59], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_14
		buffer_store_dwordx2 v[114:115], v4, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_14:
		s_andn2_b64 exec, s[58:59], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_14
.Lv9_beyond_hotloop.exec_endif_14:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v4, v1, 1, s0
		v_lshl_add_u32 v9, v8, 1, v4
		s_and_saveexec_b64 s[58:59], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_15
		buffer_store_dwordx2 v[116:117], v9, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_15:
		s_andn2_b64 exec, s[58:59], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_15
.Lv9_beyond_hotloop.exec_endif_15:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v9, v22, 1, v4
		s_and_saveexec_b64 s[58:59], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_16
		buffer_store_dwordx2 v[118:119], v9, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_16:
		s_andn2_b64 exec, s[58:59], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_16
.Lv9_beyond_hotloop.exec_endif_16:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v4, v7, 1, v4
		s_and_saveexec_b64 s[58:59], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_17
		buffer_store_dwordx2 v[120:121], v4, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_17:
		s_andn2_b64 exec, s[58:59], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_17
.Lv9_beyond_hotloop.exec_endif_17:
		s_mov_b64 exec, s[58:59]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[28:31], v[168:171]
		s_add_i32 s0, s27, 0x80
		v_add_u32_e32 v4, s0, v5
		v_add_u32_e32 v5, s0, v15
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[28:31], v[172:175]
		v_add_u32_e32 v9, s0, v18
		v_add_u32_e32 v6, s0, v6
		v_cmp_lt_i32_e64 vcc, v4, s9
		s_mov_b64 s[4:5], vcc
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[28:31], v[176:179]
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[10:11], vcc
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[28:31], v[180:183]
		s_and_b32 s12, s2, s10
		s_and_b32 s13, s3, s11
		v_cmp_lt_i32_e64 vcc, v9, s9
		s_mov_b64 s[14:15], vcc
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[36:39], v[196:199]
		s_and_b32 s16, s2, s14
		s_and_b32 s17, s3, s15
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[18:19], vcc
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[36:39], v[184:187]
		s_and_b32 s24, s2, s18
		s_and_b32 s25, s3, s19
		s_and_b32 s2, s32, s4
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[36:39], v[188:191]
		s_and_b32 s3, s33, s5
		s_and_b32 s26, s32, s10
		s_and_b32 s27, s33, s11
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[36:39], v[192:195]
		s_and_b32 s28, s32, s14
		s_and_b32 s29, s33, s15
		s_and_b32 s30, s32, s18
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[44:47], v[208:211]
		s_and_b32 s31, s33, s19
		s_and_b32 s32, s44, s4
		s_and_b32 s33, s45, s5
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[44:47], v[200:203]
		s_and_b32 s36, s44, s10
		s_and_b32 s37, s45, s11
		s_and_b32 s38, s44, s14
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[44:47], v[204:207]
		s_and_b32 s39, s45, s15
		s_and_b32 s40, s44, s18
		s_and_b32 s41, s45, s19
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[44:47], v[212:215]
		s_and_b32 s42, s54, s4
		s_and_b32 s43, s55, s5
		s_and_b32 s4, s54, s10
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[52:55], v[228:231]
		s_and_b32 s5, s55, s11
		s_and_b32 s10, s54, s14
		s_and_b32 s11, s55, s15
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[52:55], v[216:219]
		s_and_b32 s14, s54, s18
		s_and_b32 s15, s55, s19
		s_add_i32 s0, s34, s1
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[52:55], v[220:223]
		s_add_i32 s0, s0, s8
		v_lshl_add_u32 v0, v0, 6, s0
		v_lshl_add_u32 v0, v3, 1, v0
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[52:55], v[224:227]
		v_lshl_add_u32 v0, v10, 5, v0
		v_lshl_add_u32 v0, v12, 4, v0
		v_lshl_add_u32 v0, v13, 3, v0
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[32:35], v[168:171]
		v_add3_u32 v3, v0, v20, v60
		v_lshl_add_u32 v3, v11, 4, v3
		v_lshl_add_u32 v3, v14, 3, v3
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[32:35], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[40:43], v[184:187]
		v_cvt_pk_f16_f32 v4, v168, v169
		v_cvt_pk_f16_f32 v5, v170, v171
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[40:43], v[192:195]
		v_cvt_pk_f16_f32 v12, v172, v173
		v_cvt_pk_f16_f32 v13, v174, v175
		v_cvt_pk_f16_f32 v18, v176, v177
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[48:51], v[208:211]
		v_cvt_pk_f16_f32 v19, v178, v179
		v_cvt_pk_f16_f32 v20, v180, v181
		v_cvt_pk_f16_f32 v21, v182, v183
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[48:51], v[200:203]
		v_cvt_pk_f16_f32 v26, v184, v185
		v_cvt_pk_f16_f32 v27, v186, v187
		v_cvt_pk_f16_f32 v28, v188, v189
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[48:51], v[204:207]
		v_cvt_pk_f16_f32 v29, v190, v191
		v_cvt_pk_f16_f32 v30, v192, v193
		v_cvt_pk_f16_f32 v31, v194, v195
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[48:51], v[212:215]
		v_cvt_pk_f16_f32 v32, v196, v197
		v_cvt_pk_f16_f32 v33, v198, v199
		v_cvt_pk_f16_f32 v34, v200, v201
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[56:59], v[228:231]
		v_cvt_pk_f16_f32 v35, v202, v203
		v_cvt_pk_f16_f32 v36, v204, v205
		v_cvt_pk_f16_f32 v37, v206, v207
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[56:59], v[216:219]
		v_cvt_pk_f16_f32 v38, v208, v209
		v_cvt_pk_f16_f32 v39, v210, v211
		v_cvt_pk_f16_f32 v40, v212, v213
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[56:59], v[220:223]
		v_cvt_pk_f16_f32 v41, v214, v215
		v_cvt_pk_f16_f32 v42, v228, v229
		v_cvt_pk_f16_f32 v43, v230, v231
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[56:59], v[224:227]
		v_cvt_pk_f16_f32 v44, v216, v217
		v_cvt_pk_f16_f32 v45, v218, v219
		s_nop 1
		v_cvt_pk_f16_f32 v46, v220, v221
		v_cvt_pk_f16_f32 v47, v222, v223
		s_nop 1
		v_cvt_pk_f16_f32 v48, v224, v225
		v_cvt_pk_f16_f32 v49, v226, v227
		s_and_saveexec_b64 s[58:59], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_18
		buffer_store_dwordx2 v[4:5], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_18:
		s_andn2_b64 exec, s[58:59], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_18
.Lv9_beyond_hotloop.exec_endif_18:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v16, 2, v0
		v_lshl_add_u32 v3, v8, 1, v0
		s_and_saveexec_b64 s[58:59], s[12:13]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_19
		buffer_store_dwordx2 v[12:13], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_19:
		s_andn2_b64 exec, s[58:59], s[12:13]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_19
.Lv9_beyond_hotloop.exec_endif_19:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v3, v22, 1, v0
		s_and_saveexec_b64 s[58:59], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_20
		buffer_store_dwordx2 v[18:19], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_20:
		s_andn2_b64 exec, s[58:59], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_20
.Lv9_beyond_hotloop.exec_endif_20:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v7, 1, v0
		s_and_saveexec_b64 s[58:59], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_21
		buffer_store_dwordx2 v[20:21], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_21:
		s_andn2_b64 exec, s[58:59], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_21
.Lv9_beyond_hotloop.exec_endif_21:
		s_mov_b64 exec, s[58:59]
		v_add3_u32 v0, s0, v23, v60
		v_lshl_add_u32 v0, v11, 4, v0
		v_lshl_add_u32 v0, v14, 3, v0
		s_and_saveexec_b64 s[58:59], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_22
		buffer_store_dwordx2 v[26:27], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_22:
		s_andn2_b64 exec, s[58:59], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_22
.Lv9_beyond_hotloop.exec_endif_22:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v17, 1, s0
		v_lshl_add_u32 v3, v8, 1, v0
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_23
		buffer_store_dwordx2 v[28:29], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_23:
		s_andn2_b64 exec, s[58:59], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_23
.Lv9_beyond_hotloop.exec_endif_23:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v3, v22, 1, v0
		s_and_saveexec_b64 s[58:59], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_24
		buffer_store_dwordx2 v[30:31], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_24:
		s_andn2_b64 exec, s[58:59], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_24
.Lv9_beyond_hotloop.exec_endif_24:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v7, 1, v0
		s_and_saveexec_b64 s[58:59], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_25
		buffer_store_dwordx2 v[32:33], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_25:
		s_andn2_b64 exec, s[58:59], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_25
.Lv9_beyond_hotloop.exec_endif_25:
		s_mov_b64 exec, s[58:59]
		v_add3_u32 v0, s0, v25, v60
		v_lshl_add_u32 v0, v11, 4, v0
		v_lshl_add_u32 v0, v14, 3, v0
		s_and_saveexec_b64 s[58:59], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_26
		buffer_store_dwordx2 v[34:35], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_26:
		s_andn2_b64 exec, s[58:59], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_26
.Lv9_beyond_hotloop.exec_endif_26:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v24, 1, s0
		v_lshl_add_u32 v3, v8, 1, v0
		s_and_saveexec_b64 s[58:59], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_27
		buffer_store_dwordx2 v[36:37], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_27:
		s_andn2_b64 exec, s[58:59], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_27
.Lv9_beyond_hotloop.exec_endif_27:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v3, v22, 1, v0
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_28
		buffer_store_dwordx2 v[38:39], v3, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_28:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_28
.Lv9_beyond_hotloop.exec_endif_28:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v7, 1, v0
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_29
		buffer_store_dwordx2 v[40:41], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_29:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_29
.Lv9_beyond_hotloop.exec_endif_29:
		s_mov_b64 exec, s[58:59]
		v_add3_u32 v0, s0, v2, v60
		v_lshl_add_u32 v0, v11, 4, v0
		v_lshl_add_u32 v0, v14, 3, v0
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_30
		buffer_store_dwordx2 v[44:45], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_30:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_30
.Lv9_beyond_hotloop.exec_endif_30:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v1, 1, s0
		v_lshl_add_u32 v1, v8, 1, v0
		s_and_saveexec_b64 s[58:59], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_31
		buffer_store_dwordx2 v[46:47], v1, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_31:
		s_andn2_b64 exec, s[58:59], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_31
.Lv9_beyond_hotloop.exec_endif_31:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v1, v22, 1, v0
		s_and_saveexec_b64 s[58:59], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_32
		buffer_store_dwordx2 v[48:49], v1, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_32:
		s_andn2_b64 exec, s[58:59], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_32
.Lv9_beyond_hotloop.exec_endif_32:
		s_mov_b64 exec, s[58:59]
		v_lshl_add_u32 v0, v7, 1, v0
		s_and_saveexec_b64 s[58:59], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_33
		buffer_store_dwordx2 v[42:43], v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_33:
		s_andn2_b64 exec, s[58:59], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_33
.Lv9_beyond_hotloop.exec_endif_33:
		s_mov_b64 exec, s[58:59]
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
		.amdhsa_next_free_vgpr 232
		.amdhsa_next_free_sgpr 60
		.amdhsa_accum_offset 232
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
	.set .Lv9_beyond_hotloop.num_vgpr, 232
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 60
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
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     232
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
