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
		s_add_i32 s14, s8, 0xff
		s_mov_b32 s15, 0xff
		s_cmp_lt_i32 s14, 0
		s_cselect_b32 s16, s15, 0
		s_add_i32 s14, s14, s16
		s_ashr_i32 s14, s14, 8
		s_add_i32 s16, s9, 0xff
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s15, s15, 0
		s_add_i32 s15, s16, s15
		s_ashr_i32 s15, s15, 8
		s_and_b32 s16, s13, 7
		s_lshr_b32 s13, s13, 3
		s_mul_i32 s16, s16, 32
		s_add_i32 s13, s16, s13
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s17, s13, -1
		s_add_i32 s17, s17, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s17, s13
		s_mul_i32 s15, s15, 4
		s_cselect_b32 s17, 1, 0
		s_cmp_lt_i32 s15, 0
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s19, s15, -1
		s_add_i32 s19, s19, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s18, s19, s15
		v_mov_b32_e32 v1, s18
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s19, v1
		s_xor_b32 s20, s18, -1
		s_add_i32 s20, s20, 1
		s_mul_i32 s21, s20, s19
		s_mul_hi_u32 s21, s19, s21
		s_add_i32 s19, s19, s21
		s_mul_hi_u32 s19, s16, s19
		s_mul_i32 s21, s19, s18
		s_xor_b32 s21, s21, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, s18
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s19, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s19, s22, s19
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s16, s20
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_cmp_ge_u32 s16, s18
		s_cselect_b32 s18, 1, 0
		s_add_i32 s21, s19, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s18, s21, s19
		s_cselect_b32 s19, 1, 0
		s_xor_b32 s13, s13, s15
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s15, s18, -1
		s_add_i32 s15, s15, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s15, s18
		s_mul_i32 s15, s13, 4
		s_xor_b32 s18, s15, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s14, s14, s18
		s_cmp_lt_i32 s14, 4
		s_cselect_b32 s14, s14, 4
		v_mov_b32_e32 v1, s14
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s18, s16, s20
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s16, s18, s16
		s_xor_b32 s18, s16, -1
		v_readfirstlane_b32 s19, v1
		s_add_i32 s18, s18, 1
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s16, s18, s16
		s_xor_b32 s17, s14, -1
		s_add_i32 s17, s17, 1
		s_mul_i32 s18, s17, s19
		s_mul_hi_u32 s18, s19, s18
		s_add_i32 s18, s19, s18
		s_mul_hi_u32 s18, s16, s18
		s_mul_i32 s18, s18, s14
		s_xor_b32 s18, s18, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s18, s16, s18
		s_cmp_ge_u32 s18, s14
		v_readfirstlane_b32 s19, v1
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s18, s17
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s18, s21, s18
		s_cmp_ge_u32 s18, s14
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s18, s17
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s18, s21, s18
		s_mul_i32 s20, s17, s19
		s_add_i32 s15, s15, s18
		s_mul_hi_u32 s20, s19, s20
		s_add_i32 s19, s19, s20
		s_mul_hi_u32 s19, s16, s19
		s_mul_i32 s20, s19, s14
		v_lshlrev_b32_e32 v1, 3, v0
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s16, s16, s20
		v_lshrrev_b32_e32 v2, 3, v0
		s_cmp_ge_u32 s16, s14
		v_and_b32_e32 v3, 63, v1
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s19, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s19, s21, s19
		s_cselect_b32 s20, 1, 0
		s_add_i32 s17, s16, s17
		v_readfirstlane_b32 s21, v0
		v_lshlrev_b32_e32 v3, 1, v3
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s16, s17, s16
		v_mul_lo_u32 v4, s10, v2
		s_cmp_ge_u32 s16, s14
		s_cselect_b32 s14, 1, 0
		s_add_i32 s16, s19, 1
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s14, s16, s19
		v_lshl_add_u32 v3, v4, 1, v3
		s_mul_i32 s16, s10, s13
		s_lshr_b32 s17, s21, 6
		s_mul_i32 s19, s10, s18
		s_lshl_b32 s16, s16, 11
		s_lshl_b32 s19, s19, 9
		s_add_i32 s20, s16, s19
		v_add_u32_e32 v4, s20, v3
		s_mul_i32 s17, 0x420, s17
		s_mov_b32 m0, s17
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s2, s17, 0x2100
		s_lshl_b32 s3, s10, 7
		s_add_i32 s21, s3, s16
		s_add_i32 s21, s21, s19
		s_mov_b32 m0, s2
		v_add_u32_e32 v4, s21, v3
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s22, s17, 0x4200
		s_lshl_b32 s23, s10, 8
		s_add_i32 s28, s23, s16
		s_add_i32 s28, s28, s19
		s_mov_b32 m0, s22
		v_add_u32_e32 v4, s28, v3
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s29, s17, 0x6300
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s30, s10, s16
		s_add_i32 s30, s30, s19
		s_mov_b32 m0, s29
		v_add_u32_e32 v4, s30, v3
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v1, 0x7f, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_mul_lo_u32 v5, s11, v4
		v_lshl_add_u32 v1, v5, 1, v1
		s_add_i32 s31, s17, 0x107c0
		s_lshl_b32 s32, s14, 9
		v_add_u32_e32 v5, s32, v1
		s_mov_b32 m0, s31
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s4, s17, 0x128c0
		s_lshl_b32 s5, s11, 6
		s_add_i32 s33, s5, s32
		s_mov_b32 m0, s4
		v_add_u32_e32 v5, s33, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s34, s17, 0x18b80
		s_add_i32 s35, s32, 0x100
		s_mov_b32 m0, s34
		v_add_u32_e32 v5, s35, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s40, s17, 0x1ac80
		s_add_i32 s5, s5, 0x100
		s_add_i32 s5, s5, s32
		s_mov_b32 m0, s40
		v_add_u32_e32 v5, s5, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s41, s17, 0x83e0
		s_add_i32 s42, s16, 0x80
		s_add_i32 s42, s42, s19
		s_mov_b32 m0, s41
		v_add_u32_e32 v5, s42, v3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 s43, s17, 0xa4e0
		s_add_i32 s3, s3, 0x80
		s_add_i32 s3, s3, s16
		s_add_i32 s3, s3, s19
		s_mov_b32 m0, s43
		v_add_u32_e32 v5, s3, v3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 s44, s17, 0xc5e0
		s_add_i32 s23, s23, 0x80
		s_add_i32 s23, s23, s16
		s_add_i32 s23, s23, s19
		s_mov_b32 m0, s44
		v_add_u32_e32 v5, s23, v3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 s45, s17, 0xe6e0
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s16
		s_add_i32 s10, s10, s19
		s_mov_b32 m0, s45
		v_add_u32_e32 v5, s10, v3
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 s16, s17, 0x149a0
		s_lshl_b32 s19, s11, 7
		s_add_i32 s46, s19, s32
		s_mov_b32 m0, s16
		v_add_u32_e32 v5, s46, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_mul_i32 s47, 0xc0, s11
		s_add_i32 s48, s17, 0x16aa0
		s_add_i32 s49, s47, s32
		s_mov_b32 m0, s48
		v_add_u32_e32 v5, s49, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s50, s17, 0x1cd60
		s_add_i32 s19, s19, 0x100
		s_add_i32 s19, s19, s32
		s_mov_b32 m0, s50
		v_add_u32_e32 v5, s19, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		s_add_i32 s51, s17, 0x1ee60
		s_add_i32 s47, s47, 0x100
		s_add_i32 s47, s47, s32
		s_mov_b32 m0, s51
		v_add_u32_e32 v5, s47, v1
		buffer_load_dwordx4 v5, s[36:39], 0 offen lds
		v_lshrrev_b32_e32 v5, 1, v0
		v_and_b32_e32 v6, 1, v0
		v_and_b32_e32 v7, 1, v5
		v_lshrrev_b32_e32 v8, 2, v0
		v_mad_u32_u24 v6, v7, 2, v6
		v_and_b32_e32 v7, 1, v8
		v_mad_u32_u24 v6, v7, 4, v6
		v_and_b32_e32 v7, 1, v2
		v_lshrrev_b32_e32 v9, 7, v0
		v_mad_u32_u24 v6, v7, 8, v6
		v_and_b32_e32 v7, 1, v9
		v_lshrrev_b32_e32 v10, 8, v0
		v_and_b32_e32 v11, 1, v10
		v_and_b32_e32 v12, 7, v4
		v_mad_u32_u24 v6, v7, 16, v6
		v_mad_u32_u24 v6, v11, 32, v6
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v12
		v_add_u32_e32 v11, 0x80, v6
		v_add_u32_e32 v12, 0xc0, v6
		v_add_u32_e32 v13, 32, v7
		v_add_u32_e32 v14, 0x60, v7
		v_add_u32_e32 v15, 64, v7
		s_mul_i32 s15, s15, 0x100
		s_mul_i32 s14, s14, 0x100
		v_mov_b32_e32 v16, 0
		v_add_u32_e32 v20, s15, v6
		v_add3_u32 v6, 64, v6, s15
		v_add_u32_e32 v11, s15, v11
		v_add_u32_e32 v12, s15, v12
		v_add_u32_e32 v21, s14, v7
		v_add_u32_e32 v22, s14, v13
		v_add_u32_e32 v23, s14, v15
		v_add_u32_e32 v24, s14, v14
		s_mul_i32 s11, s11, 64
		s_add_i32 s15, s11, s11
		v_mov_b32_e32 v17, 0
		v_mov_b64_e32 v[18:19], 0
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v25, 63, v0
		v_and_b32_e32 v26, 15, v25
		v_lshl_add_u32 v27, v9, 4, v26
		v_lshrrev_b32_e32 v25, 4, v25
		v_lshrrev_b32_e32 v28, 2, v26
		v_lshl_add_u32 v29, v25, 3, v28
		v_lshrrev_b32_e32 v27, 5, v27
		v_lshrrev_b32_e32 v30, 3, v26
		v_and_b32_e32 v31, 1, v9
		v_lshrrev_b32_e32 v29, 4, v29
		v_mov_b32_e32 v32, 0x1080
		v_mul_lo_u32 v32, v32, v27
		v_lshl_add_u32 v27, v25, 4, v32
		v_mov_b32_e32 v32, 0x420
		v_mul_lo_u32 v32, v32, v30
		v_mov_b32_e32 v30, 0x1080
		v_mul_lo_u32 v30, v30, v29
		v_lshrrev_b32_e32 v29, 6, v0
		v_mov_b32_e32 v33, 0x840
		v_mul_lo_u32 v33, v33, v31
		v_add3_u32 v27, v27, v32, v33
		v_and_b32_e32 v32, 1, v28
		v_lshrrev_b32_e32 v33, 1, v26
		v_and_b32_e32 v29, 1, v29
		v_and_b32_e32 v25, 1, v25
		v_add_u32_e32 v30, 0x10000, v30
		v_lshl_add_u32 v27, v32, 9, v27
		v_and_b32_e32 v32, 1, v33
		v_lshl_add_u32 v28, v28, 8, v30
		v_lshlrev_b32_e32 v30, 5, v29
		v_mov_b32_e32 v33, 0x840
		v_mul_lo_u32 v33, v33, v25
		v_lshl_add_u32 v25, v32, 8, v27
		v_and_b32_e32 v27, 1, v26
		v_add3_u32 v28, v28, v30, v33
		v_and_b32_e32 v26, 3, v26
		v_lshl_add_u32 v25, v27, 7, v25
		v_lshl_add_u32 v26, v26, 3, v28
		ds_read_b128 v[32:35], v25
		ds_read_b128 v[36:39], v25 offset:64
		ds_read_b128 v[40:43], v25 offset:8448
		ds_read_b128 v[44:47], v25 offset:8512
		ds_read_b128 v[48:51], v25 offset:16896
		ds_read_b128 v[52:55], v25 offset:16960
		ds_read_b128 v[56:59], v25 offset:25344
		ds_read_b128 v[60:63], v25 offset:25408
		ds_read_b64_tr_b16 v[64:65], v26 offset:1984
		ds_read_b64_tr_b16 v[66:67], v26 offset:3040
		ds_read_b64_tr_b16 v[68:69], v26 offset:10432
		ds_read_b64_tr_b16 v[70:71], v26 offset:11488
		ds_read_b64_tr_b16 v[72:73], v26 offset:2048
		ds_read_b64_tr_b16 v[74:75], v26 offset:3104
		ds_read_b64_tr_b16 v[76:77], v26 offset:10496
		ds_read_b64_tr_b16 v[78:79], v26 offset:11552
		ds_read_b64_tr_b16 v[80:81], v26 offset:2112
		ds_read_b64_tr_b16 v[82:83], v26 offset:3168
		ds_read_b64_tr_b16 v[84:85], v26 offset:10560
		ds_read_b64_tr_b16 v[86:87], v26 offset:11616
		ds_read_b64_tr_b16 v[88:89], v26 offset:2176
		ds_read_b64_tr_b16 v[90:91], v26 offset:3232
		ds_read_b64_tr_b16 v[92:93], v26 offset:10624
		ds_read_b64_tr_b16 v[94:95], v26 offset:11680
		s_mov_b32 s0, 0x80
		v_mov_b32_e32 v96, v16
		v_mov_b32_e32 v97, v17
		v_mov_b32_e32 v98, v18
		v_mov_b32_e32 v99, v19
		s_lshl_b32 s1, s0, 1
		s_lshl_b32 s0, s15, 1
		s_lshl_b32 s11, s11, 1
		s_mov_b32 s15, 0
		s_cmp_lt_i32 0, 62
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
		s_cbranch_scc0 .Lv9_beyond_hotloop.loop_exit_0
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		s_mov_b32 m0, s17
		s_add_i32 s52, s20, s1
		v_add_u32_e32 v27, s52, v3
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mov_b32 m0, s2
		s_add_i32 s52, s21, s1
		v_add_u32_e32 v27, s52, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mov_b32 m0, s22
		s_add_i32 s52, s28, s1
		v_add_u32_e32 v27, s52, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_add_i32 s52, s30, s1
		s_mov_b32 m0, s29
		v_add_u32_e32 v27, s52, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_add_i32 s52, s32, s0
		s_mov_b32 m0, s31
		v_add_u32_e32 v27, s52, v1
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b64_tr_b16 v[64:65], v26 offset:35712
		s_add_i32 s52, s33, s0
		ds_read_b64_tr_b16 v[66:67], v26 offset:36768
		v_add_u32_e32 v27, s52, v1
		ds_read_b64_tr_b16 v[68:69], v26 offset:35776
		s_mov_b32 m0, s4
		s_nop 0
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b64_tr_b16 v[70:71], v26 offset:36832
		ds_read_b64_tr_b16 v[72:73], v26 offset:35840
		ds_read_b64_tr_b16 v[74:75], v26 offset:36896
		ds_read_b64_tr_b16 v[76:77], v26 offset:35904
		ds_read_b64_tr_b16 v[78:79], v26 offset:36960
		ds_read_b64_tr_b16 v[80:81], v26 offset:44160
		ds_read_b64_tr_b16 v[82:83], v26 offset:45216
		ds_read_b64_tr_b16 v[84:85], v26 offset:44224
		ds_read_b64_tr_b16 v[86:87], v26 offset:45280
		ds_read_b64_tr_b16 v[88:89], v26 offset:44288
		ds_read_b64_tr_b16 v[90:91], v26 offset:45344
		ds_read_b64_tr_b16 v[92:93], v26 offset:44352
		ds_read_b64_tr_b16 v[94:95], v26 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[56:59], v[216:219]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[36:39], v[156:159]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[36:39], v[160:163]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		s_add_i32 s52, s35, s0
		v_add_u32_e32 v27, s52, v1
		s_mov_b32 m0, s34
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b128 v[32:35], v25 offset:33760
		s_add_i32 s52, s5, s0
		ds_read_b128 v[36:39], v25 offset:42208
		v_add_u32_e32 v27, s52, v1
		ds_read_b128 v[40:43], v25 offset:50656
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b128 v[44:47], v25 offset:59104
		ds_read_b64_tr_b16 v[48:49], v26 offset:18848
		ds_read_b64_tr_b16 v[50:51], v26 offset:19904
		ds_read_b64_tr_b16 v[52:53], v26 offset:18912
		ds_read_b64_tr_b16 v[54:55], v26 offset:19968
		ds_read_b64_tr_b16 v[56:57], v26 offset:18976
		ds_read_b64_tr_b16 v[58:59], v26 offset:20032
		ds_read_b64_tr_b16 v[60:61], v26 offset:19040
		ds_read_b64_tr_b16 v[62:63], v26 offset:20096
		ds_read_b128 v[64:67], v25 offset:33824
		ds_read_b128 v[68:71], v25 offset:42272
		ds_read_b128 v[72:75], v25 offset:50720
		ds_read_b128 v[76:79], v25 offset:59168
		ds_read_b64_tr_b16 v[80:81], v26 offset:27296
		ds_read_b64_tr_b16 v[82:83], v26 offset:28352
		ds_read_b64_tr_b16 v[84:85], v26 offset:27360
		ds_read_b64_tr_b16 v[86:87], v26 offset:28416
		ds_read_b64_tr_b16 v[88:89], v26 offset:27424
		ds_read_b64_tr_b16 v[90:91], v26 offset:28480
		ds_read_b64_tr_b16 v[92:93], v26 offset:27488
		ds_read_b64_tr_b16 v[94:95], v26 offset:28544
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[16:19], v[48:51], v[32:35], v[16:19]
		s_add_i32 s52, s0, s11
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[52:55], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[100:103], v[56:59], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[104:107], v[60:63], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[52:55], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[60:63], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[52:55], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[56:59], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[52:55], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[44:47], v[152:155]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[16:19], v[80:83], v[64:67], v[16:19]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[96:99], v[84:87], v[64:67], v[96:99]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[100:103], v[88:91], v[64:67], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[64:67], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[68:71], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[68:71], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[68:71], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[72:75], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[72:75], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[72:75], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[72:75], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[76:79], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[76:79], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[76:79], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[76:79], v[152:155]
		s_mov_b32 m0, s41
		s_add_i32 s53, s42, s1
		v_add_u32_e32 v27, s53, v3
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mov_b32 m0, s43
		s_add_i32 s53, s3, s1
		v_add_u32_e32 v27, s53, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_mov_b32 m0, s44
		s_add_i32 s53, s23, s1
		v_add_u32_e32 v27, s53, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_add_i32 s53, s10, s1
		s_mov_b32 m0, s45
		v_add_u32_e32 v27, s53, v3
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_add_i32 s53, s46, s0
		s_mov_b32 m0, s16
		v_add_u32_e32 v27, s53, v1
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b64_tr_b16 v[48:49], v26 offset:52576
		s_add_i32 s53, s49, s0
		ds_read_b64_tr_b16 v[50:51], v26 offset:53632
		v_add_u32_e32 v27, s53, v1
		ds_read_b64_tr_b16 v[52:53], v26 offset:52640
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b64_tr_b16 v[54:55], v26 offset:53696
		ds_read_b64_tr_b16 v[56:57], v26 offset:52704
		ds_read_b64_tr_b16 v[58:59], v26 offset:53760
		ds_read_b64_tr_b16 v[60:61], v26 offset:52768
		ds_read_b64_tr_b16 v[62:63], v26 offset:53824
		ds_read_b64_tr_b16 v[80:81], v26 offset:61024
		ds_read_b64_tr_b16 v[82:83], v26 offset:62080
		ds_read_b64_tr_b16 v[84:85], v26 offset:61088
		ds_read_b64_tr_b16 v[86:87], v26 offset:62144
		ds_read_b64_tr_b16 v[88:89], v26 offset:61152
		ds_read_b64_tr_b16 v[90:91], v26 offset:62208
		ds_read_b64_tr_b16 v[92:93], v26 offset:61216
		ds_read_b64_tr_b16 v[94:95], v26 offset:62272
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[48:51], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[160:163], v[52:55], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[164:167], v[56:59], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[48:51], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[52:55], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[56:59], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[60:63], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[48:51], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[52:55], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[56:59], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[60:63], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[48:51], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[52:55], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[56:59], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[60:63], v[44:47], v[216:219]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[64:67], v[156:159]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[64:67], v[160:163]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[64:67], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[68:71], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[68:71], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[68:71], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[68:71], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[72:75], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[72:75], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[72:75], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[72:75], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[76:79], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[76:79], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[76:79], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[76:79], v[216:219]
		s_add_i32 s53, s19, s0
		v_add_u32_e32 v27, s53, v1
		s_mov_b32 m0, s50
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		s_add_i32 s0, s47, s0
		s_mov_b32 m0, s51
		v_add_u32_e32 v27, s0, v1
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		ds_read_b128 v[32:35], v25
		ds_read_b128 v[36:39], v25 offset:64
		ds_read_b128 v[40:43], v25 offset:8448
		ds_read_b128 v[44:47], v25 offset:8512
		ds_read_b128 v[48:51], v25 offset:16896
		ds_read_b128 v[52:55], v25 offset:16960
		ds_read_b128 v[56:59], v25 offset:25344
		ds_read_b128 v[60:63], v25 offset:25408
		ds_read_b64_tr_b16 v[64:65], v26 offset:1984
		ds_read_b64_tr_b16 v[66:67], v26 offset:3040
		ds_read_b64_tr_b16 v[68:69], v26 offset:10432
		ds_read_b64_tr_b16 v[70:71], v26 offset:11488
		ds_read_b64_tr_b16 v[72:73], v26 offset:2048
		ds_read_b64_tr_b16 v[74:75], v26 offset:3104
		ds_read_b64_tr_b16 v[76:77], v26 offset:10496
		ds_read_b64_tr_b16 v[78:79], v26 offset:11552
		ds_read_b64_tr_b16 v[80:81], v26 offset:2112
		ds_read_b64_tr_b16 v[82:83], v26 offset:3168
		ds_read_b64_tr_b16 v[84:85], v26 offset:10560
		ds_read_b64_tr_b16 v[86:87], v26 offset:11616
		ds_read_b64_tr_b16 v[88:89], v26 offset:2176
		ds_read_b64_tr_b16 v[90:91], v26 offset:3232
		ds_read_b64_tr_b16 v[92:93], v26 offset:10624
		ds_read_b64_tr_b16 v[94:95], v26 offset:11680
		s_add_i32 s1, s1, 0x100
		s_add_i32 s0, s52, s11
		s_add_i32 s15, s15, 2
		s_cmp_lt_i32 s15, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b64_tr_b16 v[64:65], v26 offset:35712
		ds_read_b64_tr_b16 v[66:67], v26 offset:36768
		ds_read_b64_tr_b16 v[68:69], v26 offset:44160
		ds_read_b64_tr_b16 v[70:71], v26 offset:45216
		ds_read_b64_tr_b16 v[72:73], v26 offset:35776
		ds_read_b64_tr_b16 v[74:75], v26 offset:36832
		ds_read_b64_tr_b16 v[76:77], v26 offset:44224
		ds_read_b64_tr_b16 v[78:79], v26 offset:45280
		ds_read_b64_tr_b16 v[80:81], v26 offset:35840
		ds_read_b64_tr_b16 v[82:83], v26 offset:36896
		ds_read_b64_tr_b16 v[84:85], v26 offset:44288
		ds_read_b64_tr_b16 v[86:87], v26 offset:45344
		ds_read_b64_tr_b16 v[88:89], v26 offset:35904
		ds_read_b64_tr_b16 v[90:91], v26 offset:36960
		ds_read_b64_tr_b16 v[92:93], v26 offset:44352
		ds_read_b64_tr_b16 v[94:95], v26 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		ds_read_b128 v[32:35], v25 offset:33760
		ds_read_b128 v[36:39], v25 offset:33824
		ds_read_b128 v[40:43], v25 offset:42208
		ds_read_b128 v[44:47], v25 offset:42272
		ds_read_b128 v[48:51], v25 offset:50656
		ds_read_b128 v[52:55], v25 offset:50720
		ds_read_b128 v[56:59], v25 offset:59104
		ds_read_b128 v[60:63], v25 offset:59168
		ds_read_b64_tr_b16 v[64:65], v26 offset:18848
		ds_read_b64_tr_b16 v[66:67], v26 offset:19904
		ds_read_b64_tr_b16 v[68:69], v26 offset:27296
		ds_read_b64_tr_b16 v[70:71], v26 offset:28352
		ds_read_b64_tr_b16 v[72:73], v26 offset:18912
		ds_read_b64_tr_b16 v[74:75], v26 offset:19968
		ds_read_b64_tr_b16 v[76:77], v26 offset:27360
		ds_read_b64_tr_b16 v[78:79], v26 offset:28416
		ds_read_b64_tr_b16 v[80:81], v26 offset:18976
		ds_read_b64_tr_b16 v[82:83], v26 offset:20032
		ds_read_b64_tr_b16 v[84:85], v26 offset:27424
		ds_read_b64_tr_b16 v[86:87], v26 offset:28480
		ds_read_b64_tr_b16 v[88:89], v26 offset:19040
		ds_read_b64_tr_b16 v[90:91], v26 offset:20096
		ds_read_b64_tr_b16 v[92:93], v26 offset:27488
		ds_read_b64_tr_b16 v[94:95], v26 offset:28544
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		ds_read_b64_tr_b16 v[64:65], v26 offset:52576
		ds_read_b64_tr_b16 v[66:67], v26 offset:53632
		ds_read_b64_tr_b16 v[68:69], v26 offset:61024
		ds_read_b64_tr_b16 v[70:71], v26 offset:62080
		ds_read_b64_tr_b16 v[72:73], v26 offset:52640
		ds_read_b64_tr_b16 v[74:75], v26 offset:53696
		ds_read_b64_tr_b16 v[76:77], v26 offset:61088
		ds_read_b64_tr_b16 v[78:79], v26 offset:62144
		ds_read_b64_tr_b16 v[80:81], v26 offset:52704
		ds_read_b64_tr_b16 v[82:83], v26 offset:53760
		ds_read_b64_tr_b16 v[84:85], v26 offset:61152
		ds_read_b64_tr_b16 v[86:87], v26 offset:62208
		ds_read_b64_tr_b16 v[88:89], v26 offset:52768
		ds_read_b64_tr_b16 v[90:91], v26 offset:53824
		ds_read_b64_tr_b16 v[92:93], v26 offset:61216
		ds_read_b64_tr_b16 v[94:95], v26 offset:62272
		v_cvt_pk_f16_f32 v26, v16, v17
		v_cvt_pk_f16_f32 v27, v18, v19
		v_cvt_pk_f16_f32 v16, v96, v97
		v_cvt_pk_f16_f32 v17, v98, v99
		v_cvt_pk_f16_f32 v18, v100, v101
		v_cvt_pk_f16_f32 v19, v102, v103
		v_cvt_pk_f16_f32 v96, v104, v105
		v_cvt_pk_f16_f32 v97, v106, v107
		v_cvt_pk_f16_f32 v98, v108, v109
		v_cvt_pk_f16_f32 v99, v110, v111
		v_cvt_pk_f16_f32 v100, v112, v113
		v_cvt_pk_f16_f32 v101, v114, v115
		v_cvt_pk_f16_f32 v102, v116, v117
		v_cvt_pk_f16_f32 v103, v118, v119
		v_cvt_pk_f16_f32 v104, v120, v121
		v_cvt_pk_f16_f32 v105, v122, v123
		v_cvt_pk_f16_f32 v106, v124, v125
		v_cvt_pk_f16_f32 v107, v126, v127
		v_cvt_pk_f16_f32 v108, v128, v129
		v_cvt_pk_f16_f32 v109, v130, v131
		v_cvt_pk_f16_f32 v110, v132, v133
		v_cvt_pk_f16_f32 v111, v134, v135
		v_cvt_pk_f16_f32 v112, v136, v137
		v_cvt_pk_f16_f32 v113, v138, v139
		v_cvt_pk_f16_f32 v114, v140, v141
		v_cvt_pk_f16_f32 v115, v142, v143
		v_cvt_pk_f16_f32 v116, v144, v145
		v_cvt_pk_f16_f32 v117, v146, v147
		v_cvt_pk_f16_f32 v118, v148, v149
		v_cvt_pk_f16_f32 v119, v150, v151
		v_cvt_pk_f16_f32 v120, v152, v153
		v_cvt_pk_f16_f32 v121, v154, v155
		v_cmp_lt_i32_e64 vcc, v20, s8
		s_mov_b64 s[0:1], vcc
		v_cmp_lt_i32_e64 vcc, v6, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v11, s8
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v12, s8
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[16:17], vcc
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_i32_e64 vcc, v23, s9
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_i32_e64 vcc, v24, s9
		s_mov_b64 s[24:25], vcc
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_and_b32 s6, s0, s16
		s_and_b32 s7, s1, s17
		s_mul_i32 s8, s13, s12
		s_lshl_b32 s8, s8, 11
		s_add_i32 s15, s32, s8
		s_mul_i32 s19, s18, s12
		s_lshl_b32 s19, s19, 9
		s_add_i32 s15, s15, s19
		v_mul_lo_u32 v1, s12, v10
		v_lshl_add_u32 v3, v1, 6, s15
		v_and_b32_e32 v6, 1, v0
		v_mul_lo_u32 v11, s12, v6
		v_lshlrev_b32_e32 v11, 1, v11
		v_mul_lo_u32 v12, s12, v31
		v_lshlrev_b32_e32 v12, 5, v12
		v_add3_u32 v3, v3, v11, v12
		v_and_b32_e32 v2, 1, v2
		v_mul_lo_u32 v20, s12, v2
		v_lshlrev_b32_e32 v20, 4, v20
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v21, s12, v8
		v_lshlrev_b32_e32 v21, 3, v21
		v_add3_u32 v3, v3, v20, v21
		v_and_b32_e32 v5, 1, v5
		v_mul_lo_u32 v22, s12, v5
		v_lshlrev_b32_e32 v22, 2, v22
		v_add3_u32 v3, v3, v22, v30
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v24, 3, v4
		v_add3_u32 v3, v3, v23, v24
		v_mov_b32_e32 v25, 0x80000000
		v_cndmask_b32_e64 v3, v25, v3, s[6:7]
		buffer_store_dwordx2 v[26:27], v3, s[28:31], 0 offen
		s_and_b32 s6, s0, s20
		s_and_b32 s7, s1, s21
		v_mul_lo_u32 v3, s12, v9
		v_lshlrev_b32_e32 v3, 5, v3
		v_add_u32_e32 v9, s15, v3
		v_add3_u32 v9, v9, v11, v20
		v_add3_u32 v9, v9, v21, v22
		v_lshlrev_b32_e32 v26, 4, v29
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v27, 32, v4
		v_lshlrev_b32_e32 v0, 3, v0
		v_xor_b32_e32 v27, v27, v0
		v_xor_b32_e32 v27, v26, v27
		v_lshl_add_u32 v28, v27, 1, v9
		v_cndmask_b32_e64 v28, v25, v28, s[6:7]
		buffer_store_dwordx2 v[16:17], v28, s[28:31], 0 offen
		s_and_b32 s6, s0, s22
		s_and_b32 s7, s1, s23
		v_add_u32_e32 v16, 64, v4
		v_xor_b32_e32 v16, v16, v0
		v_xor_b32_e32 v16, v26, v16
		v_lshl_add_u32 v9, v16, 1, v9
		v_cndmask_b32_e64 v9, v25, v9, s[6:7]
		buffer_store_dwordx2 v[18:19], v9, s[28:31], 0 offen
		s_and_b32 s6, s0, s24
		s_and_b32 s7, s1, s25
		s_mul_i32 s13, s12, s13
		s_lshl_b32 s13, s13, 11
		s_add_i32 s26, s32, s13
		s_mul_i32 s18, s12, s18
		s_lshl_b32 s18, s18, 9
		s_add_i32 s26, s26, s18
		v_add3_u32 v9, s26, v3, v11
		v_add3_u32 v9, v9, v20, v21
		v_add_u32_e32 v4, 0x60, v4
		v_xor_b32_e32 v0, v4, v0
		v_xor_b32_e32 v0, v26, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v4, v9, v22, v0
		v_cndmask_b32_e64 v4, v25, v4, s[6:7]
		buffer_store_dwordx2 v[96:97], v4, s[28:31], 0 offen
		s_and_b32 s6, s2, s16
		s_and_b32 s7, s3, s17
		v_lshlrev_b32_e32 v4, 5, v10
		v_lshlrev_b32_e32 v9, 4, v31
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v8, 2, v8
		v_add_u32_e32 v10, 64, v6
		v_lshlrev_b32_e32 v5, 1, v5
		v_xor_b32_e32 v10, v10, v5
		v_xor_b32_e32 v10, v8, v10
		v_xor_b32_e32 v10, v2, v10
		v_xor_b32_e32 v10, v9, v10
		v_xor_b32_e32 v10, v4, v10
		v_mul_lo_u32 v10, s12, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v17, s15, v10
		v_add_u32_e32 v18, v17, v30
		v_add3_u32 v18, v18, v23, v24
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[98:99], v18, s[28:31], 0 offen
		s_and_b32 s6, s2, s20
		s_and_b32 s7, s3, s21
		v_lshl_add_u32 v18, v27, 1, v17
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[100:101], v18, s[28:31], 0 offen
		s_and_b32 s6, s2, s22
		s_and_b32 s7, s3, s23
		v_lshl_add_u32 v17, v16, 1, v17
		v_cndmask_b32_e64 v17, v25, v17, s[6:7]
		buffer_store_dwordx2 v[102:103], v17, s[28:31], 0 offen
		s_and_b32 s6, s2, s24
		s_and_b32 s7, s3, s25
		v_add3_u32 v17, s26, v10, v0
		v_cndmask_b32_e64 v17, v25, v17, s[6:7]
		buffer_store_dwordx2 v[104:105], v17, s[28:31], 0 offen
		s_and_b32 s6, s4, s16
		s_and_b32 s7, s5, s17
		v_add_u32_e32 v17, 0x80, v6
		v_xor_b32_e32 v17, v17, v5
		v_xor_b32_e32 v17, v8, v17
		v_xor_b32_e32 v17, v2, v17
		v_xor_b32_e32 v17, v9, v17
		v_xor_b32_e32 v17, v4, v17
		v_mul_lo_u32 v17, s12, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v18, s15, v17
		v_add_u32_e32 v19, v18, v30
		v_add3_u32 v19, v19, v23, v24
		v_cndmask_b32_e64 v19, v25, v19, s[6:7]
		buffer_store_dwordx2 v[106:107], v19, s[28:31], 0 offen
		s_and_b32 s6, s4, s20
		s_and_b32 s7, s5, s21
		v_lshl_add_u32 v19, v27, 1, v18
		v_cndmask_b32_e64 v19, v25, v19, s[6:7]
		buffer_store_dwordx2 v[108:109], v19, s[28:31], 0 offen
		s_and_b32 s6, s4, s22
		s_and_b32 s7, s5, s23
		v_lshl_add_u32 v18, v16, 1, v18
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[110:111], v18, s[28:31], 0 offen
		s_and_b32 s6, s4, s24
		s_and_b32 s7, s5, s25
		v_add3_u32 v18, s26, v17, v0
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[112:113], v18, s[28:31], 0 offen
		s_and_b32 s6, s10, s16
		s_and_b32 s7, s11, s17
		v_add_u32_e32 v6, 0xc0, v6
		v_xor_b32_e32 v5, v6, v5
		v_xor_b32_e32 v5, v8, v5
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v9, v2
		v_xor_b32_e32 v2, v4, v2
		v_mul_lo_u32 v2, s12, v2
		v_lshl_add_u32 v4, v2, 1, s26
		v_add_u32_e32 v5, v4, v30
		v_add3_u32 v5, v5, v23, v24
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[114:115], v5, s[28:31], 0 offen
		s_and_b32 s6, s10, s20
		s_and_b32 s7, s11, s21
		v_lshl_add_u32 v5, v27, 1, v4
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[116:117], v5, s[28:31], 0 offen
		s_and_b32 s6, s10, s22
		s_and_b32 s7, s11, s23
		v_lshl_add_u32 v5, v16, 1, v4
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[118:119], v5, s[28:31], 0 offen
		s_and_b32 s6, s10, s24
		s_and_b32 s7, s11, s25
		v_add_u32_e32 v4, v4, v0
		v_cndmask_b32_e64 v4, v25, v4, s[6:7]
		buffer_store_dwordx2 v[120:121], v4, s[28:31], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_cvt_pk_f16_f32 v4, v156, v157
		v_cvt_pk_f16_f32 v5, v158, v159
		v_cvt_pk_f16_f32 v8, v160, v161
		v_cvt_pk_f16_f32 v9, v162, v163
		v_cvt_pk_f16_f32 v18, v164, v165
		v_cvt_pk_f16_f32 v19, v166, v167
		v_cvt_pk_f16_f32 v28, v168, v169
		v_cvt_pk_f16_f32 v29, v170, v171
		v_cvt_pk_f16_f32 v32, v172, v173
		v_cvt_pk_f16_f32 v33, v174, v175
		v_cvt_pk_f16_f32 v34, v176, v177
		v_cvt_pk_f16_f32 v35, v178, v179
		v_cvt_pk_f16_f32 v36, v180, v181
		v_cvt_pk_f16_f32 v37, v182, v183
		v_cvt_pk_f16_f32 v38, v184, v185
		v_cvt_pk_f16_f32 v39, v186, v187
		v_cvt_pk_f16_f32 v40, v188, v189
		v_cvt_pk_f16_f32 v41, v190, v191
		v_cvt_pk_f16_f32 v42, v192, v193
		v_cvt_pk_f16_f32 v43, v194, v195
		v_cvt_pk_f16_f32 v44, v196, v197
		v_cvt_pk_f16_f32 v45, v198, v199
		v_cvt_pk_f16_f32 v46, v200, v201
		v_cvt_pk_f16_f32 v47, v202, v203
		v_cvt_pk_f16_f32 v48, v204, v205
		v_cvt_pk_f16_f32 v49, v206, v207
		v_cvt_pk_f16_f32 v50, v208, v209
		v_cvt_pk_f16_f32 v51, v210, v211
		v_cvt_pk_f16_f32 v52, v212, v213
		v_cvt_pk_f16_f32 v53, v214, v215
		v_cvt_pk_f16_f32 v54, v216, v217
		v_cvt_pk_f16_f32 v55, v218, v219
		s_add_i32 s6, s14, 0x80
		v_add_u32_e32 v6, s6, v7
		v_add_u32_e32 v7, s6, v13
		v_add_u32_e32 v13, s6, v15
		v_add_u32_e32 v14, s6, v14
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v7, s9
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v13, s9
		s_mov_b64 s[16:17], vcc
		v_cmp_lt_i32_e64 vcc, v14, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s0, s6
		s_and_b32 s23, s1, s7
		s_add_i32 s8, s35, s8
		s_add_i32 s8, s8, s19
		v_lshl_add_u32 v1, v1, 6, s8
		v_add3_u32 v1, v1, v11, v12
		v_add3_u32 v1, v1, v20, v21
		v_add3_u32 v1, v1, v22, v30
		v_add3_u32 v1, v1, v23, v24
		v_cndmask_b32_e64 v1, v25, v1, s[22:23]
		buffer_store_dwordx2 v[4:5], v1, s[28:31], 0 offen
		s_and_b32 s22, s0, s14
		s_and_b32 s23, s1, s15
		v_add_u32_e32 v1, s8, v3
		v_add3_u32 v1, v1, v11, v20
		v_add3_u32 v1, v1, v21, v22
		v_lshl_add_u32 v4, v27, 1, v1
		v_cndmask_b32_e64 v4, v25, v4, s[22:23]
		buffer_store_dwordx2 v[8:9], v4, s[28:31], 0 offen
		s_and_b32 s22, s0, s16
		s_and_b32 s23, s1, s17
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[22:23]
		buffer_store_dwordx2 v[18:19], v1, s[28:31], 0 offen
		s_and_b32 s22, s0, s20
		s_and_b32 s23, s1, s21
		s_add_i32 s0, s35, s13
		s_add_i32 s0, s0, s18
		v_add3_u32 v1, s0, v3, v11
		v_add3_u32 v1, v1, v20, v21
		v_add3_u32 v1, v1, v22, v0
		v_cndmask_b32_e64 v1, v25, v1, s[22:23]
		buffer_store_dwordx2 v[28:29], v1, s[28:31], 0 offen
		s_and_b32 s12, s2, s6
		s_and_b32 s13, s3, s7
		v_add_u32_e32 v1, s8, v10
		v_add_u32_e32 v3, v1, v30
		v_add3_u32 v3, v3, v23, v24
		v_cndmask_b32_e64 v3, v25, v3, s[12:13]
		buffer_store_dwordx2 v[32:33], v3, s[28:31], 0 offen
		s_and_b32 s12, s2, s14
		s_and_b32 s13, s3, s15
		v_lshl_add_u32 v3, v27, 1, v1
		v_cndmask_b32_e64 v3, v25, v3, s[12:13]
		buffer_store_dwordx2 v[34:35], v3, s[28:31], 0 offen
		s_and_b32 s12, s2, s16
		s_and_b32 s13, s3, s17
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[12:13]
		buffer_store_dwordx2 v[36:37], v1, s[28:31], 0 offen
		s_and_b32 s12, s2, s20
		s_and_b32 s13, s3, s21
		v_add3_u32 v1, s0, v10, v0
		v_cndmask_b32_e64 v1, v25, v1, s[12:13]
		buffer_store_dwordx2 v[38:39], v1, s[28:31], 0 offen
		s_and_b32 s2, s4, s6
		s_and_b32 s3, s5, s7
		v_add_u32_e32 v1, s8, v17
		v_add_u32_e32 v3, v1, v30
		v_add3_u32 v3, v3, v23, v24
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[40:41], v3, s[28:31], 0 offen
		s_and_b32 s2, s4, s14
		s_and_b32 s3, s5, s15
		v_lshl_add_u32 v3, v27, 1, v1
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[42:43], v3, s[28:31], 0 offen
		s_and_b32 s2, s4, s16
		s_and_b32 s3, s5, s17
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[44:45], v1, s[28:31], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_add3_u32 v1, s0, v17, v0
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[46:47], v1, s[28:31], 0 offen
		s_and_b32 s2, s10, s6
		s_and_b32 s3, s11, s7
		v_lshl_add_u32 v1, v2, 1, s0
		v_add_u32_e32 v2, v1, v30
		v_add3_u32 v2, v2, v23, v24
		v_cndmask_b32_e64 v2, v25, v2, s[2:3]
		buffer_store_dwordx2 v[48:49], v2, s[28:31], 0 offen
		s_and_b32 s0, s10, s14
		s_and_b32 s1, s11, s15
		v_lshl_add_u32 v2, v27, 1, v1
		v_cndmask_b32_e64 v2, v25, v2, s[0:1]
		buffer_store_dwordx2 v[50:51], v2, s[28:31], 0 offen
		s_and_b32 s0, s10, s16
		s_and_b32 s1, s11, s17
		v_lshl_add_u32 v2, v16, 1, v1
		v_cndmask_b32_e64 v2, v25, v2, s[0:1]
		buffer_store_dwordx2 v[52:53], v2, s[28:31], 0 offen
		s_and_b32 s0, s10, s20
		s_and_b32 s1, s11, s21
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v25, v0, s[0:1]
		buffer_store_dwordx2 v[54:55], v0, s[28:31], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	v9_beyond_hotloop, .-v9_beyond_hotloop
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel v9_beyond_hotloop
		.amdhsa_group_segment_fixed_size 134976
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
		.amdhsa_next_free_vgpr 220
		.amdhsa_next_free_sgpr 54
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
	.set .Lv9_beyond_hotloop.num_vgpr, 220
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 54
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
    .group_segment_fixed_size: 134976
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           v9_beyond_hotloop
    .private_segment_fixed_size: 0
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     220
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
