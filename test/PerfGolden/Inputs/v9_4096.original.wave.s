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
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_add_i32 s0, s8, 0xff
		s_cmp_lt_i32 s0, 0
		s_mov_b32 s1, 0xff
		s_cselect_b32 s2, s1, 0
		s_add_i32 s0, s0, s2
		s_ashr_i32 s0, s0, 8
		s_add_i32 s2, s9, 0xff
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s2, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s2, s13, 7
		s_lshr_b32 s3, s13, 3
		s_mul_i32 s2, s2, 32
		s_add_i32 s2, s2, s3
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s2, -1
		s_add_i32 s4, s4, 1
		s_mul_i32 s1, s1, 4
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s3, s4, s2
		s_cselect_b32 s4, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s5, 1, 0
		s_xor_b32 s13, s1, -1
		s_add_i32 s13, s13, 1
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s5, s13, s1
		v_mov_b32_e32 v1, s5
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_nop 0
		v_readfirstlane_b32 s13, v1
		s_xor_b32 s14, s5, -1
		s_add_i32 s14, s14, 1
		s_mul_i32 s15, s14, s13
		s_mul_hi_u32 s15, s13, s15
		s_add_i32 s13, s13, s15
		s_mul_hi_u32 s13, s3, s13
		s_mul_i32 s15, s13, s5
		s_xor_b32 s15, s15, -1
		s_add_i32 s15, s15, 1
		s_add_i32 s3, s3, s15
		s_cmp_ge_u32 s3, s5
		s_cselect_b32 s15, 1, 0
		s_add_i32 s24, s13, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s13, s24, s13
		s_cselect_b32 s15, 1, 0
		s_add_i32 s24, s3, s14
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s3, s24, s3
		s_cmp_ge_u32 s3, s5
		s_cselect_b32 s5, 1, 0
		s_add_i32 s15, s13, 1
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s5, s15, s13
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s1, s2, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s2, s5, -1
		s_add_i32 s2, s2, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s2, s5
		s_mul_i32 s2, s1, 4
		s_xor_b32 s5, s2, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s0, s0, s5
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_nop 0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s5, s3, s14
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s3, s5, s3
		s_xor_b32 s5, s3, -1
		v_readfirstlane_b32 s13, v1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s3, s5, s3
		s_xor_b32 s4, s0, -1
		s_add_i32 s4, s4, 1
		s_mul_i32 s5, s4, s13
		s_mul_hi_u32 s5, s13, s5
		s_add_i32 s5, s13, s5
		s_mul_hi_u32 s5, s3, s5
		s_mul_i32 s5, s5, s0
		s_xor_b32 s5, s5, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s5, s3, s5
		s_cmp_ge_u32 s5, s0
		v_readfirstlane_b32 s13, v1
		s_cselect_b32 s14, 1, 0
		s_add_i32 s15, s5, s4
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s5, s15, s5
		s_cmp_ge_u32 s5, s0
		s_cselect_b32 s14, 1, 0
		s_add_i32 s15, s5, s4
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s5, s15, s5
		s_mul_i32 s14, s4, s13
		s_add_i32 s2, s2, s5
		s_mul_hi_u32 s14, s13, s14
		s_add_i32 s13, s13, s14
		s_mul_hi_u32 s13, s3, s13
		v_lshlrev_b32_e32 v1, 3, v0
		s_mul_i32 s14, s13, s0
		s_xor_b32 s14, s14, -1
		s_add_i32 s14, s14, 1
		s_add_i32 s3, s3, s14
		v_lshrrev_b32_e32 v2, 3, v0
		v_and_b32_e32 v3, 63, v1
		s_cmp_ge_u32 s3, s0
		s_cselect_b32 s14, 1, 0
		s_add_i32 s15, s13, 1
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s13, s15, s13
		s_cselect_b32 s14, 1, 0
		s_add_i32 s4, s3, s4
		v_readfirstlane_b32 s15, v0
		v_mul_lo_u32 v4, s10, v2
		v_lshlrev_b32_e32 v3, 1, v3
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s3, s4, s3
		s_cmp_ge_u32 s3, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s3, s13, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s3, s13
		v_lshl_add_u32 v3, v4, 1, v3
		s_lshr_b32 s3, s15, 6
		s_mul_i32 s4, s10, s1
		s_lshl_b32 s4, s4, 11
		s_mul_i32 s13, s10, s5
		s_lshl_b32 s13, s13, 9
		s_add_i32 s14, s4, s13
		v_add_u32_e32 v4, s14, v3
		s_mul_i32 s3, 0x420, s3
		s_mov_b32 m0, s3
		s_nop 0
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s15, s3, 0x2100
		s_lshl_b32 s24, s10, 7
		s_add_i32 s25, s24, s4
		s_add_i32 s25, s25, s13
		s_mov_b32 m0, s15
		v_add_u32_e32 v4, s25, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s26, s3, 0x4200
		s_lshl_b32 s27, s10, 8
		s_add_i32 s28, s27, s4
		s_add_i32 s28, s28, s13
		s_mov_b32 m0, s26
		v_add_u32_e32 v4, s28, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s29, s3, 0x6300
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s30, s10, s4
		s_add_i32 s30, s30, s13
		s_mov_b32 m0, s29
		v_add_u32_e32 v4, s30, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_lshrrev_b32_e32 v4, 4, v0
		v_and_b32_e32 v1, 0x7f, v1
		v_mul_lo_u32 v5, s11, v4
		v_lshlrev_b32_e32 v1, 1, v1
		v_lshl_add_u32 v1, v5, 1, v1
		s_add_i32 s31, s3, 0x107c0
		s_lshl_b32 s32, s0, 9
		s_mov_b32 m0, s31
		v_add_u32_e32 v5, s32, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s33, s3, 0x128c0
		s_lshl_b32 s34, s11, 6
		s_add_i32 s35, s34, s32
		s_mov_b32 m0, s33
		v_add_u32_e32 v5, s35, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s36, s3, 0x18b80
		s_add_i32 s37, s32, 0x100
		s_mov_b32 m0, s36
		v_add_u32_e32 v5, s37, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s38, s3, 0x1ac80
		s_add_i32 s34, s34, 0x100
		s_add_i32 s34, s34, s32
		s_mov_b32 m0, s38
		v_add_u32_e32 v5, s34, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s39, s3, 0x83e0
		s_add_i32 s40, s4, 0x80
		s_add_i32 s40, s40, s13
		s_mov_b32 m0, s39
		v_add_u32_e32 v5, s40, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_add_i32 s41, s3, 0xa4e0
		s_add_i32 s24, s24, 0x80
		s_add_i32 s24, s24, s4
		s_add_i32 s24, s24, s13
		s_mov_b32 m0, s41
		v_add_u32_e32 v5, s24, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_add_i32 s42, s3, 0xc5e0
		s_add_i32 s27, s27, 0x80
		s_add_i32 s27, s27, s4
		s_add_i32 s27, s27, s13
		s_mov_b32 m0, s42
		v_add_u32_e32 v5, s27, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_add_i32 s43, s3, 0xe6e0
		s_add_i32 s10, s10, 0x80
		s_add_i32 s4, s10, s4
		s_add_i32 s4, s4, s13
		s_mov_b32 m0, s43
		v_add_u32_e32 v5, s4, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_add_i32 s10, s3, 0x149a0
		s_lshl_b32 s13, s11, 7
		s_add_i32 s44, s13, s32
		s_mov_b32 m0, s10
		v_add_u32_e32 v5, s44, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s45, s3, 0x16aa0
		s_mul_i32 s46, 0xc0, s11
		s_add_i32 s47, s46, s32
		s_mov_b32 m0, s45
		v_add_u32_e32 v5, s47, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s48, s3, 0x1cd60
		s_add_i32 s13, s13, 0x100
		s_add_i32 s13, s13, s32
		s_mov_b32 m0, s48
		v_add_u32_e32 v5, s13, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s49, s3, 0x1ee60
		s_add_i32 s46, s46, 0x100
		s_add_i32 s46, s46, s32
		s_mov_b32 m0, s49
		v_add_u32_e32 v5, s46, v1
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
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
		v_mad_u32_u24 v6, v7, 16, v6
		v_and_b32_e32 v7, 1, v10
		v_and_b32_e32 v11, 7, v4
		v_mad_u32_u24 v6, v7, 32, v6
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v11
		v_add_u32_e32 v11, 0x80, v6
		v_add_u32_e32 v12, 0xc0, v6
		v_add_u32_e32 v13, 32, v7
		v_add_u32_e32 v14, 64, v7
		v_add_u32_e32 v15, 0x60, v7
		s_mul_i32 s2, s2, 0x100
		s_mul_i32 s0, s0, 0x100
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_add_u32_e32 v20, s2, v6
		v_add3_u32 v6, 64, v6, s2
		v_add_u32_e32 v11, s2, v11
		v_add_u32_e32 v12, s2, v12
		v_add_u32_e32 v21, s0, v7
		v_add_u32_e32 v22, s0, v13
		v_add_u32_e32 v23, s0, v14
		v_add_u32_e32 v24, s0, v15
		s_mul_i32 s2, s11, 64
		s_add_i32 s11, s2, s2
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v25, 63, v0
		v_and_b32_e32 v26, 15, v25
		v_lshl_add_u32 v27, v9, 4, v26
		v_lshrrev_b32_e32 v25, 4, v25
		v_lshrrev_b32_e32 v28, 2, v26
		v_lshrrev_b32_e32 v27, 5, v27
		v_lshl_add_u32 v29, v25, 3, v28
		v_mov_b32_e32 v30, 0x1080
		v_mul_lo_u32 v30, v30, v27
		v_lshrrev_b32_e32 v27, 3, v26
		v_and_b32_e32 v31, 1, v9
		v_lshrrev_b32_e32 v29, 4, v29
		v_lshl_add_u32 v30, v25, 4, v30
		v_mov_b32_e32 v32, 0x420
		v_mul_lo_u32 v32, v32, v27
		v_mov_b32_e32 v27, 0x840
		v_mul_lo_u32 v27, v27, v31
		v_mov_b32_e32 v33, 0x1080
		v_mul_lo_u32 v33, v33, v29
		v_lshrrev_b32_e32 v29, 6, v0
		v_add3_u32 v27, v30, v32, v27
		v_and_b32_e32 v30, 1, v28
		v_lshrrev_b32_e32 v32, 1, v26
		v_add_u32_e32 v33, 0x10000, v33
		v_and_b32_e32 v29, 1, v29
		v_and_b32_e32 v25, 1, v25
		v_lshl_add_u32 v27, v30, 9, v27
		v_and_b32_e32 v30, 1, v32
		v_lshl_add_u32 v28, v28, 8, v33
		v_lshlrev_b32_e32 v32, 5, v29
		v_mov_b32_e32 v33, 0x840
		v_mul_lo_u32 v33, v33, v25
		v_lshl_add_u32 v25, v30, 8, v27
		v_and_b32_e32 v27, 1, v26
		v_add3_u32 v28, v28, v32, v33
		v_and_b32_e32 v26, 3, v26
		v_lshl_add_u32 v25, v27, 7, v25
		v_lshl_add_u32 v26, v26, 3, v28
		ds_read_b128 v[36:39], v25
		ds_read_b128 v[40:43], v25 offset:64
		ds_read_b128 v[44:47], v25 offset:8448
		ds_read_b128 v[48:51], v25 offset:8512
		ds_read_b128 v[52:55], v25 offset:16896
		ds_read_b128 v[56:59], v25 offset:16960
		ds_read_b128 v[60:63], v25 offset:25344
		ds_read_b128 v[64:67], v25 offset:25408
		ds_read_b64_tr_b16 v[68:69], v26 offset:1984
		ds_read_b64_tr_b16 v[70:71], v26 offset:3040
		ds_read_b64_tr_b16 v[72:73], v26 offset:10432
		ds_read_b64_tr_b16 v[74:75], v26 offset:11488
		ds_read_b64_tr_b16 v[76:77], v26 offset:2048
		ds_read_b64_tr_b16 v[78:79], v26 offset:3104
		ds_read_b64_tr_b16 v[80:81], v26 offset:10496
		ds_read_b64_tr_b16 v[82:83], v26 offset:11552
		ds_read_b64_tr_b16 v[84:85], v26 offset:2112
		ds_read_b64_tr_b16 v[86:87], v26 offset:3168
		ds_read_b64_tr_b16 v[88:89], v26 offset:10560
		ds_read_b64_tr_b16 v[90:91], v26 offset:11616
		ds_read_b64_tr_b16 v[92:93], v26 offset:2176
		ds_read_b64_tr_b16 v[94:95], v26 offset:3232
		ds_read_b64_tr_b16 v[96:97], v26 offset:10624
		ds_read_b64_tr_b16 v[98:99], v26 offset:11680
		v_mov_b32_e32 v100, v16
		v_mov_b32_e32 v101, v17
		v_mov_b32_e32 v102, v18
		v_mov_b32_e32 v103, v19
		s_mov_b32 s50, 0x80
		s_lshl_b32 s51, s50, 1
		s_lshl_b32 s50, s11, 1
		s_mov_b32 s11, 0
		s_lshl_b32 s2, s2, 1
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
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
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[72:75], v[40:43], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[40:43], v[100:103]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[36:39], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[64:67], v[156:159]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b64_tr_b16 v[68:69], v26 offset:35712
		ds_read_b64_tr_b16 v[70:71], v26 offset:36768
		ds_read_b64_tr_b16 v[72:73], v26 offset:44160
		ds_read_b64_tr_b16 v[74:75], v26 offset:45216
		ds_read_b64_tr_b16 v[76:77], v26 offset:35776
		ds_read_b64_tr_b16 v[78:79], v26 offset:36832
		ds_read_b64_tr_b16 v[80:81], v26 offset:44224
		ds_read_b64_tr_b16 v[82:83], v26 offset:45280
		ds_read_b64_tr_b16 v[84:85], v26 offset:35840
		ds_read_b64_tr_b16 v[86:87], v26 offset:36896
		ds_read_b64_tr_b16 v[88:89], v26 offset:44288
		ds_read_b64_tr_b16 v[90:91], v26 offset:45344
		ds_read_b64_tr_b16 v[92:93], v26 offset:35904
		ds_read_b64_tr_b16 v[94:95], v26 offset:36960
		ds_read_b64_tr_b16 v[96:97], v26 offset:44352
		ds_read_b64_tr_b16 v[98:99], v26 offset:45408
		s_mov_b32 m0, s3
		s_add_i32 s52, s14, s51
		v_add_u32_e32 v27, s52, v3
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_mov_b32 m0, s15
		v_add_u32_e32 v27, s51, v3
		v_add_u32_e32 v28, s25, v27
		buffer_load_dwordx4 v28, s[16:19], 0 offen lds
		s_mov_b32 m0, s26
		v_add_u32_e32 v28, s28, v27
		buffer_load_dwordx4 v28, s[16:19], 0 offen lds
		s_mov_b32 m0, s29
		v_add_u32_e32 v27, s30, v27
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_mov_b32 m0, s31
		s_add_i32 s52, s32, s50
		v_add_u32_e32 v27, s52, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[36:39], v[160:163]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[40:43], v[160:163]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[36:39], v[168:171]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[36:39], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[172:175], v[96:99], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[48:51], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[44:47], v[188:191]
		s_mov_b32 m0, s33
		s_add_i32 s52, s35, s50
		v_add_u32_e32 v27, s52, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[188:191], v[96:99], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[56:59], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[96:99], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[64:67], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[220:223], v[96:99], v[64:67], v[220:223]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[36:39], v25 offset:33760
		ds_read_b128 v[40:43], v25 offset:33824
		ds_read_b128 v[44:47], v25 offset:42208
		ds_read_b128 v[48:51], v25 offset:42272
		ds_read_b128 v[52:55], v25 offset:50656
		ds_read_b128 v[56:59], v25 offset:50720
		ds_read_b128 v[60:63], v25 offset:59104
		ds_read_b128 v[64:67], v25 offset:59168
		ds_read_b64_tr_b16 v[68:69], v26 offset:18848
		ds_read_b64_tr_b16 v[70:71], v26 offset:19904
		ds_read_b64_tr_b16 v[72:73], v26 offset:27296
		ds_read_b64_tr_b16 v[74:75], v26 offset:28352
		ds_read_b64_tr_b16 v[76:77], v26 offset:18912
		ds_read_b64_tr_b16 v[78:79], v26 offset:19968
		ds_read_b64_tr_b16 v[80:81], v26 offset:27360
		ds_read_b64_tr_b16 v[82:83], v26 offset:28416
		ds_read_b64_tr_b16 v[84:85], v26 offset:18976
		ds_read_b64_tr_b16 v[86:87], v26 offset:20032
		ds_read_b64_tr_b16 v[88:89], v26 offset:27424
		ds_read_b64_tr_b16 v[90:91], v26 offset:28480
		ds_read_b64_tr_b16 v[92:93], v26 offset:19040
		ds_read_b64_tr_b16 v[94:95], v26 offset:20096
		ds_read_b64_tr_b16 v[96:97], v26 offset:27488
		ds_read_b64_tr_b16 v[98:99], v26 offset:28544
		s_mov_b32 m0, s36
		s_add_i32 s52, s37, s50
		v_add_u32_e32 v27, s52, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[72:75], v[40:43], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[40:43], v[100:103]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[36:39], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[44:47], v[124:127]
		s_mov_b32 m0, s38
		s_add_i32 s52, s34, s50
		v_add_u32_e32 v27, s52, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[64:67], v[156:159]
		s_add_i32 s52, s50, s2
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b64_tr_b16 v[68:69], v26 offset:52576
		ds_read_b64_tr_b16 v[70:71], v26 offset:53632
		ds_read_b64_tr_b16 v[72:73], v26 offset:61024
		ds_read_b64_tr_b16 v[74:75], v26 offset:62080
		ds_read_b64_tr_b16 v[76:77], v26 offset:52640
		ds_read_b64_tr_b16 v[78:79], v26 offset:53696
		ds_read_b64_tr_b16 v[80:81], v26 offset:61088
		ds_read_b64_tr_b16 v[82:83], v26 offset:62144
		ds_read_b64_tr_b16 v[84:85], v26 offset:52704
		ds_read_b64_tr_b16 v[86:87], v26 offset:53760
		ds_read_b64_tr_b16 v[88:89], v26 offset:61152
		ds_read_b64_tr_b16 v[90:91], v26 offset:62208
		ds_read_b64_tr_b16 v[92:93], v26 offset:52768
		ds_read_b64_tr_b16 v[94:95], v26 offset:53824
		ds_read_b64_tr_b16 v[96:97], v26 offset:61216
		ds_read_b64_tr_b16 v[98:99], v26 offset:62272
		s_mov_b32 m0, s39
		s_add_i32 s53, s40, s51
		v_add_u32_e32 v27, s53, v3
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_mov_b32 m0, s41
		v_add_u32_e32 v27, s51, v3
		v_add_u32_e32 v28, s24, v27
		buffer_load_dwordx4 v28, s[16:19], 0 offen lds
		s_mov_b32 m0, s42
		v_add_u32_e32 v28, s27, v27
		buffer_load_dwordx4 v28, s[16:19], 0 offen lds
		s_mov_b32 m0, s43
		v_add_u32_e32 v27, s4, v27
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_mov_b32 m0, s10
		s_add_i32 s53, s44, s50
		v_add_u32_e32 v27, s53, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[36:39], v[160:163]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[40:43], v[160:163]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[36:39], v[168:171]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[36:39], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[172:175], v[96:99], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[48:51], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[44:47], v[188:191]
		s_mov_b32 m0, s45
		s_add_i32 s53, s47, s50
		v_add_u32_e32 v27, s53, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[188:191], v[96:99], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[56:59], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[96:99], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[64:67], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[220:223], v[96:99], v[64:67], v[220:223]
		s_add_i32 s53, s13, s50
		v_add_u32_e32 v27, s53, v1
		s_mov_b32 m0, s48
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_add_i32 s50, s46, s50
		s_mov_b32 m0, s49
		v_add_u32_e32 v27, s50, v1
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		ds_read_b128 v[36:39], v25
		ds_read_b128 v[40:43], v25 offset:64
		ds_read_b128 v[44:47], v25 offset:8448
		ds_read_b128 v[48:51], v25 offset:8512
		ds_read_b128 v[52:55], v25 offset:16896
		ds_read_b128 v[56:59], v25 offset:16960
		ds_read_b128 v[60:63], v25 offset:25344
		ds_read_b128 v[64:67], v25 offset:25408
		ds_read_b64_tr_b16 v[68:69], v26 offset:1984
		ds_read_b64_tr_b16 v[70:71], v26 offset:3040
		ds_read_b64_tr_b16 v[72:73], v26 offset:10432
		ds_read_b64_tr_b16 v[74:75], v26 offset:11488
		ds_read_b64_tr_b16 v[76:77], v26 offset:2048
		ds_read_b64_tr_b16 v[78:79], v26 offset:3104
		ds_read_b64_tr_b16 v[80:81], v26 offset:10496
		ds_read_b64_tr_b16 v[82:83], v26 offset:11552
		ds_read_b64_tr_b16 v[84:85], v26 offset:2112
		ds_read_b64_tr_b16 v[86:87], v26 offset:3168
		ds_read_b64_tr_b16 v[88:89], v26 offset:10560
		ds_read_b64_tr_b16 v[90:91], v26 offset:11616
		ds_read_b64_tr_b16 v[92:93], v26 offset:2176
		ds_read_b64_tr_b16 v[94:95], v26 offset:3232
		ds_read_b64_tr_b16 v[96:97], v26 offset:10624
		ds_read_b64_tr_b16 v[98:99], v26 offset:11680
		s_add_i32 s51, s51, 0x100
		s_add_i32 s50, s52, s2
		s_add_i32 s11, s11, 2
		s_cmp_lt_i32 s11, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[16:19], v[72:75], v[40:43], v[16:19]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[40:43], v[100:103]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[36:39], v[104:107]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[96:99], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[96:99], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[56:59], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[96:99], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[96:99], v[64:67], v[156:159]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b64_tr_b16 v[68:69], v26 offset:35712
		ds_read_b64_tr_b16 v[70:71], v26 offset:36768
		ds_read_b64_tr_b16 v[72:73], v26 offset:44160
		ds_read_b64_tr_b16 v[74:75], v26 offset:45216
		ds_read_b64_tr_b16 v[76:77], v26 offset:35776
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[36:39], v[160:163]
		ds_read_b64_tr_b16 v[78:79], v26 offset:36832
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[44:47], v[176:179]
		ds_read_b64_tr_b16 v[80:81], v26 offset:44224
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[52:55], v[192:195]
		ds_read_b64_tr_b16 v[82:83], v26 offset:45280
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[60:63], v[208:211]
		ds_read_b64_tr_b16 v[68:69], v26 offset:35840
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[40:43], v[160:163]
		ds_read_b64_tr_b16 v[70:71], v26 offset:36896
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[48:51], v[176:179]
		ds_read_b64_tr_b16 v[84:85], v26 offset:44288
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[56:59], v[192:195]
		ds_read_b64_tr_b16 v[86:87], v26 offset:45344
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[64:67], v[208:211]
		ds_read_b64_tr_b16 v[72:73], v26 offset:35904
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[36:39], v[164:167]
		ds_read_b64_tr_b16 v[74:75], v26 offset:36960
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[44:47], v[180:183]
		ds_read_b64_tr_b16 v[88:89], v26 offset:44352
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[52:55], v[196:199]
		ds_read_b64_tr_b16 v[90:91], v26 offset:45408
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[60:63], v[212:215]
		ds_read_b128 v[76:79], v25 offset:33760
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[40:43], v[164:167]
		ds_read_b128 v[92:95], v25 offset:33824
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[48:51], v[180:183]
		ds_read_b128 v[96:99], v25 offset:42208
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[56:59], v[196:199]
		ds_read_b128 v[224:227], v25 offset:42272
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[64:67], v[212:215]
		ds_read_b128 v[80:83], v25 offset:50656
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[36:39], v[168:171]
		ds_read_b128 v[228:231], v25 offset:50720
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[44:47], v[184:187]
		ds_read_b128 v[232:235], v25 offset:59104
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[52:55], v[200:203]
		ds_read_b128 v[236:239], v25 offset:59168
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[60:63], v[216:219]
		ds_read_b64_tr_b16 v[68:69], v26 offset:18848
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[40:43], v[168:171]
		ds_read_b64_tr_b16 v[70:71], v26 offset:19904
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[48:51], v[184:187]
		ds_read_b64_tr_b16 v[240:241], v26 offset:27296
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[56:59], v[200:203]
		ds_read_b64_tr_b16 v[242:243], v26 offset:28352
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[64:67], v[216:219]
		ds_read_b64_tr_b16 v[84:85], v26 offset:18912
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[36:39], v[172:175]
		ds_read_b64_tr_b16 v[86:87], v26 offset:19968
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[44:47], v[188:191]
		ds_read_b64_tr_b16 v[36:37], v26 offset:27360
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[52:55], v[204:207]
		ds_read_b64_tr_b16 v[38:39], v26 offset:28416
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[60:63], v[220:223]
		ds_read_b64_tr_b16 v[44:45], v26 offset:18976
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[40:43], v[172:175]
		ds_read_b64_tr_b16 v[46:47], v26 offset:20032
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[48:51], v[188:191]
		ds_read_b64_tr_b16 v[40:41], v26 offset:27424
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[56:59], v[204:207]
		ds_read_b64_tr_b16 v[42:43], v26 offset:28480
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[64:67], v[220:223]
		ds_read_b64_tr_b16 v[48:49], v26 offset:19040
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[76:79], v[16:19]
		ds_read_b64_tr_b16 v[50:51], v26 offset:20096
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[96:99], v[112:115]
		ds_read_b64_tr_b16 v[52:53], v26 offset:27488
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[80:83], v[128:131]
		ds_read_b64_tr_b16 v[54:55], v26 offset:28544
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[232:235], v[144:147]
		ds_read_b64_tr_b16 v[56:57], v26 offset:52576
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[16:19], v[240:243], v[92:95], v[16:19]
		ds_read_b64_tr_b16 v[58:59], v26 offset:53632
		v_mfma_f32_16x16x32_f16 v[112:115], v[240:243], v[224:227], v[112:115]
		ds_read_b64_tr_b16 v[60:61], v26 offset:61024
		v_mfma_f32_16x16x32_f16 v[128:131], v[240:243], v[228:231], v[128:131]
		ds_read_b64_tr_b16 v[62:63], v26 offset:62080
		v_mfma_f32_16x16x32_f16 v[144:147], v[240:243], v[236:239], v[144:147]
		ds_read_b64_tr_b16 v[64:65], v26 offset:52640
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[76:79], v[100:103]
		ds_read_b64_tr_b16 v[66:67], v26 offset:53696
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[96:99], v[116:119]
		ds_read_b64_tr_b16 v[68:69], v26 offset:61088
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[80:83], v[132:135]
		ds_read_b64_tr_b16 v[70:71], v26 offset:62144
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[232:235], v[148:151]
		ds_read_b64_tr_b16 v[72:73], v26 offset:52704
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[100:103], v[36:39], v[92:95], v[100:103]
		ds_read_b64_tr_b16 v[74:75], v26 offset:53760
		v_mfma_f32_16x16x32_f16 v[116:119], v[36:39], v[224:227], v[116:119]
		ds_read_b64_tr_b16 v[84:85], v26 offset:61152
		v_mfma_f32_16x16x32_f16 v[132:135], v[36:39], v[228:231], v[132:135]
		ds_read_b64_tr_b16 v[86:87], v26 offset:62208
		v_mfma_f32_16x16x32_f16 v[148:151], v[36:39], v[236:239], v[148:151]
		ds_read_b64_tr_b16 v[36:37], v26 offset:52768
		v_mfma_f32_16x16x32_f16 v[104:107], v[44:47], v[76:79], v[104:107]
		ds_read_b64_tr_b16 v[38:39], v26 offset:53824
		v_mfma_f32_16x16x32_f16 v[120:123], v[44:47], v[96:99], v[120:123]
		ds_read_b64_tr_b16 v[88:89], v26 offset:61216
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[80:83], v[136:139]
		ds_read_b64_tr_b16 v[90:91], v26 offset:62272
		v_mfma_f32_16x16x32_f16 v[152:155], v[44:47], v[232:235], v[152:155]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[104:107], v[40:43], v[92:95], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[224:227], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[40:43], v[228:231], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[40:43], v[236:239], v[152:155]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[76:79], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[96:99], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[80:83], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[48:51], v[232:235], v[156:159]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[92:95], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[224:227], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[228:231], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[236:239], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[96:99], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[80:83], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[232:235], v[208:211]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[224:227], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[228:231], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[236:239], v[208:211]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[76:79], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[96:99], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[80:83], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[232:235], v[212:215]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[224:227], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[228:231], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[236:239], v[212:215]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[76:79], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[96:99], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[80:83], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[232:235], v[216:219]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[92:95], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[224:227], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[228:231], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[236:239], v[216:219]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[172:175], v[36:39], v[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[36:39], v[96:99], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[80:83], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[36:39], v[232:235], v[220:223]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[224:227], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[228:231], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[236:239], v[220:223]
		v_cvt_pk_f16_f32 v26, v16, v17
		v_cvt_pk_f16_f32 v27, v18, v19
		v_cvt_pk_f16_f32 v16, v100, v101
		v_cvt_pk_f16_f32 v17, v102, v103
		v_cvt_pk_f16_f32 v18, v104, v105
		v_cvt_pk_f16_f32 v19, v106, v107
		v_cvt_pk_f16_f32 v34, v108, v109
		v_cvt_pk_f16_f32 v35, v110, v111
		v_cvt_pk_f16_f32 v36, v112, v113
		v_cvt_pk_f16_f32 v37, v114, v115
		v_cvt_pk_f16_f32 v38, v116, v117
		v_cvt_pk_f16_f32 v39, v118, v119
		v_cvt_pk_f16_f32 v40, v120, v121
		v_cvt_pk_f16_f32 v41, v122, v123
		v_cvt_pk_f16_f32 v42, v124, v125
		v_cvt_pk_f16_f32 v43, v126, v127
		v_cvt_pk_f16_f32 v44, v128, v129
		v_cvt_pk_f16_f32 v45, v130, v131
		v_cvt_pk_f16_f32 v46, v132, v133
		v_cvt_pk_f16_f32 v47, v134, v135
		v_cvt_pk_f16_f32 v48, v136, v137
		v_cvt_pk_f16_f32 v49, v138, v139
		v_cvt_pk_f16_f32 v50, v140, v141
		v_cvt_pk_f16_f32 v51, v142, v143
		v_cvt_pk_f16_f32 v52, v144, v145
		v_cvt_pk_f16_f32 v53, v146, v147
		v_cvt_pk_f16_f32 v54, v148, v149
		v_cvt_pk_f16_f32 v55, v150, v151
		v_cvt_pk_f16_f32 v56, v152, v153
		v_cvt_pk_f16_f32 v57, v154, v155
		v_cvt_pk_f16_f32 v58, v156, v157
		v_cvt_pk_f16_f32 v59, v158, v159
		v_cmp_lt_i32_e64 vcc, v20, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v6, s8
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v11, s8
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v12, s8
		s_mov_b64 s[16:17], vcc
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[18:19], vcc
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
		s_and_b32 s6, s2, s18
		s_and_b32 s7, s3, s19
		s_mul_i32 s4, s1, s12
		s_lshl_b32 s4, s4, 11
		s_add_i32 s8, s32, s4
		s_mul_i32 s13, s5, s12
		s_lshl_b32 s13, s13, 9
		s_add_i32 s8, s8, s13
		v_mul_lo_u32 v1, s12, v10
		v_lshl_add_u32 v3, v1, 6, s8
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
		v_add3_u32 v3, v3, v22, v32
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v24, 3, v4
		v_add3_u32 v3, v3, v23, v24
		v_mov_b32_e32 v25, 0x80000000
		v_cndmask_b32_e64 v3, v25, v3, s[6:7]
		buffer_store_dwordx2 v[26:27], v3, s[28:31], 0 offen
		s_and_b32 s6, s2, s20
		s_and_b32 s7, s3, s21
		v_mul_lo_u32 v3, s12, v9
		v_lshlrev_b32_e32 v3, 5, v3
		v_add_u32_e32 v9, s8, v3
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
		s_and_b32 s6, s2, s22
		s_and_b32 s7, s3, s23
		v_add_u32_e32 v16, 64, v4
		v_xor_b32_e32 v16, v16, v0
		v_xor_b32_e32 v16, v26, v16
		v_lshl_add_u32 v9, v16, 1, v9
		v_cndmask_b32_e64 v9, v25, v9, s[6:7]
		buffer_store_dwordx2 v[18:19], v9, s[28:31], 0 offen
		s_and_b32 s6, s2, s24
		s_and_b32 s7, s3, s25
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s26, s32, s1
		s_mul_i32 s5, s12, s5
		s_lshl_b32 s5, s5, 9
		s_add_i32 s26, s26, s5
		v_add3_u32 v9, s26, v3, v11
		v_add3_u32 v9, v9, v20, v21
		v_add_u32_e32 v4, 0x60, v4
		v_xor_b32_e32 v0, v4, v0
		v_xor_b32_e32 v0, v26, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v4, v9, v22, v0
		v_cndmask_b32_e64 v4, v25, v4, s[6:7]
		buffer_store_dwordx2 v[34:35], v4, s[28:31], 0 offen
		s_and_b32 s6, s10, s18
		s_and_b32 s7, s11, s19
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
		v_add_u32_e32 v17, s8, v10
		v_add_u32_e32 v18, v17, v32
		v_add3_u32 v18, v18, v23, v24
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[36:37], v18, s[28:31], 0 offen
		s_and_b32 s6, s10, s20
		s_and_b32 s7, s11, s21
		v_lshl_add_u32 v18, v27, 1, v17
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[38:39], v18, s[28:31], 0 offen
		s_and_b32 s6, s10, s22
		s_and_b32 s7, s11, s23
		v_lshl_add_u32 v17, v16, 1, v17
		v_cndmask_b32_e64 v17, v25, v17, s[6:7]
		buffer_store_dwordx2 v[40:41], v17, s[28:31], 0 offen
		s_and_b32 s6, s10, s24
		s_and_b32 s7, s11, s25
		v_add3_u32 v17, s26, v10, v0
		v_cndmask_b32_e64 v17, v25, v17, s[6:7]
		buffer_store_dwordx2 v[42:43], v17, s[28:31], 0 offen
		s_and_b32 s6, s14, s18
		s_and_b32 s7, s15, s19
		v_add_u32_e32 v17, 0x80, v6
		v_xor_b32_e32 v17, v17, v5
		v_xor_b32_e32 v17, v8, v17
		v_xor_b32_e32 v17, v2, v17
		v_xor_b32_e32 v17, v9, v17
		v_xor_b32_e32 v17, v4, v17
		v_mul_lo_u32 v17, s12, v17
		v_lshlrev_b32_e32 v17, 1, v17
		v_add_u32_e32 v18, s8, v17
		v_add_u32_e32 v19, v18, v32
		v_add3_u32 v19, v19, v23, v24
		v_cndmask_b32_e64 v19, v25, v19, s[6:7]
		buffer_store_dwordx2 v[44:45], v19, s[28:31], 0 offen
		s_and_b32 s6, s14, s20
		s_and_b32 s7, s15, s21
		v_lshl_add_u32 v19, v27, 1, v18
		v_cndmask_b32_e64 v19, v25, v19, s[6:7]
		buffer_store_dwordx2 v[46:47], v19, s[28:31], 0 offen
		s_and_b32 s6, s14, s22
		s_and_b32 s7, s15, s23
		v_lshl_add_u32 v18, v16, 1, v18
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[48:49], v18, s[28:31], 0 offen
		s_and_b32 s6, s14, s24
		s_and_b32 s7, s15, s25
		v_add3_u32 v18, s26, v17, v0
		v_cndmask_b32_e64 v18, v25, v18, s[6:7]
		buffer_store_dwordx2 v[50:51], v18, s[28:31], 0 offen
		s_and_b32 s6, s16, s18
		s_and_b32 s7, s17, s19
		v_add_u32_e32 v6, 0xc0, v6
		v_xor_b32_e32 v5, v6, v5
		v_xor_b32_e32 v5, v8, v5
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v9, v2
		v_xor_b32_e32 v2, v4, v2
		v_mul_lo_u32 v2, s12, v2
		v_lshl_add_u32 v4, v2, 1, s26
		v_add_u32_e32 v5, v4, v32
		v_add3_u32 v5, v5, v23, v24
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[52:53], v5, s[28:31], 0 offen
		s_and_b32 s6, s16, s20
		s_and_b32 s7, s17, s21
		v_lshl_add_u32 v5, v27, 1, v4
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[54:55], v5, s[28:31], 0 offen
		s_and_b32 s6, s16, s22
		s_and_b32 s7, s17, s23
		v_lshl_add_u32 v5, v16, 1, v4
		v_cndmask_b32_e64 v5, v25, v5, s[6:7]
		buffer_store_dwordx2 v[56:57], v5, s[28:31], 0 offen
		s_and_b32 s6, s16, s24
		s_and_b32 s7, s17, s25
		v_add_u32_e32 v4, v4, v0
		v_cndmask_b32_e64 v4, v25, v4, s[6:7]
		buffer_store_dwordx2 v[58:59], v4, s[28:31], 0 offen
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		v_cvt_pk_f16_f32 v8, v164, v165
		v_cvt_pk_f16_f32 v9, v166, v167
		v_cvt_pk_f16_f32 v18, v168, v169
		v_cvt_pk_f16_f32 v19, v170, v171
		v_cvt_pk_f16_f32 v28, v172, v173
		v_cvt_pk_f16_f32 v29, v174, v175
		v_cvt_pk_f16_f32 v30, v176, v177
		v_cvt_pk_f16_f32 v31, v178, v179
		v_cvt_pk_f16_f32 v34, v180, v181
		v_cvt_pk_f16_f32 v35, v182, v183
		v_cvt_pk_f16_f32 v36, v184, v185
		v_cvt_pk_f16_f32 v37, v186, v187
		v_cvt_pk_f16_f32 v38, v188, v189
		v_cvt_pk_f16_f32 v39, v190, v191
		v_cvt_pk_f16_f32 v40, v192, v193
		v_cvt_pk_f16_f32 v41, v194, v195
		v_cvt_pk_f16_f32 v42, v196, v197
		v_cvt_pk_f16_f32 v43, v198, v199
		v_cvt_pk_f16_f32 v44, v200, v201
		v_cvt_pk_f16_f32 v45, v202, v203
		v_cvt_pk_f16_f32 v46, v204, v205
		v_cvt_pk_f16_f32 v47, v206, v207
		v_cvt_pk_f16_f32 v48, v208, v209
		v_cvt_pk_f16_f32 v49, v210, v211
		v_cvt_pk_f16_f32 v50, v212, v213
		v_cvt_pk_f16_f32 v51, v214, v215
		v_cvt_pk_f16_f32 v52, v216, v217
		v_cvt_pk_f16_f32 v53, v218, v219
		v_cvt_pk_f16_f32 v54, v220, v221
		v_cvt_pk_f16_f32 v55, v222, v223
		s_add_i32 s0, s0, 0x80
		v_add_u32_e32 v6, s0, v7
		v_add_u32_e32 v7, s0, v13
		v_add_u32_e32 v13, s0, v14
		v_add_u32_e32 v14, s0, v15
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v7, s9
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v13, s9
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_i32_e64 vcc, v14, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s8, s2, s6
		s_and_b32 s9, s3, s7
		s_add_i32 s0, s37, s4
		s_add_i32 s0, s0, s13
		v_lshl_add_u32 v1, v1, 6, s0
		v_add3_u32 v1, v1, v11, v12
		v_add3_u32 v1, v1, v20, v21
		v_add3_u32 v1, v1, v22, v32
		v_add3_u32 v1, v1, v23, v24
		v_cndmask_b32_e64 v1, v25, v1, s[8:9]
		buffer_store_dwordx2 v[4:5], v1, s[28:31], 0 offen
		s_and_b32 s8, s2, s18
		s_and_b32 s9, s3, s19
		v_add_u32_e32 v1, s0, v3
		v_add3_u32 v1, v1, v11, v20
		v_add3_u32 v1, v1, v21, v22
		v_lshl_add_u32 v4, v27, 1, v1
		v_cndmask_b32_e64 v4, v25, v4, s[8:9]
		buffer_store_dwordx2 v[8:9], v4, s[28:31], 0 offen
		s_and_b32 s8, s2, s20
		s_and_b32 s9, s3, s21
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[8:9]
		buffer_store_dwordx2 v[18:19], v1, s[28:31], 0 offen
		s_and_b32 s8, s2, s22
		s_and_b32 s9, s3, s23
		s_add_i32 s1, s37, s1
		s_add_i32 s1, s1, s5
		v_add3_u32 v1, s1, v3, v11
		v_add3_u32 v1, v1, v20, v21
		v_add3_u32 v1, v1, v22, v0
		v_cndmask_b32_e64 v1, v25, v1, s[8:9]
		buffer_store_dwordx2 v[28:29], v1, s[28:31], 0 offen
		s_and_b32 s2, s10, s6
		s_and_b32 s3, s11, s7
		v_add_u32_e32 v1, s0, v10
		v_add_u32_e32 v3, v1, v32
		v_add3_u32 v3, v3, v23, v24
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[30:31], v3, s[28:31], 0 offen
		s_and_b32 s2, s10, s18
		s_and_b32 s3, s11, s19
		v_lshl_add_u32 v3, v27, 1, v1
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[34:35], v3, s[28:31], 0 offen
		s_and_b32 s2, s10, s20
		s_and_b32 s3, s11, s21
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[36:37], v1, s[28:31], 0 offen
		s_and_b32 s2, s10, s22
		s_and_b32 s3, s11, s23
		v_add3_u32 v1, s1, v10, v0
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[38:39], v1, s[28:31], 0 offen
		s_and_b32 s2, s14, s6
		s_and_b32 s3, s15, s7
		v_add_u32_e32 v1, s0, v17
		v_add_u32_e32 v3, v1, v32
		v_add3_u32 v3, v3, v23, v24
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[40:41], v3, s[28:31], 0 offen
		s_and_b32 s2, s14, s18
		s_and_b32 s3, s15, s19
		v_lshl_add_u32 v3, v27, 1, v1
		v_cndmask_b32_e64 v3, v25, v3, s[2:3]
		buffer_store_dwordx2 v[42:43], v3, s[28:31], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_lshl_add_u32 v1, v16, 1, v1
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[44:45], v1, s[28:31], 0 offen
		s_and_b32 s2, s14, s22
		s_and_b32 s3, s15, s23
		v_add3_u32 v1, s1, v17, v0
		v_cndmask_b32_e64 v1, v25, v1, s[2:3]
		buffer_store_dwordx2 v[46:47], v1, s[28:31], 0 offen
		s_and_b32 s2, s16, s6
		s_and_b32 s3, s17, s7
		v_lshl_add_u32 v1, v2, 1, s1
		v_add_u32_e32 v2, v1, v32
		v_add3_u32 v2, v2, v23, v24
		v_cndmask_b32_e64 v2, v25, v2, s[2:3]
		buffer_store_dwordx2 v[48:49], v2, s[28:31], 0 offen
		s_and_b32 s0, s16, s18
		s_and_b32 s1, s17, s19
		v_lshl_add_u32 v2, v27, 1, v1
		v_cndmask_b32_e64 v2, v25, v2, s[0:1]
		buffer_store_dwordx2 v[50:51], v2, s[28:31], 0 offen
		s_and_b32 s0, s16, s20
		s_and_b32 s1, s17, s21
		v_lshl_add_u32 v2, v16, 1, v1
		v_cndmask_b32_e64 v2, v25, v2, s[0:1]
		buffer_store_dwordx2 v[52:53], v2, s[28:31], 0 offen
		s_and_b32 s0, s16, s22
		s_and_b32 s1, s17, s23
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
		.amdhsa_next_free_vgpr 244
		.amdhsa_next_free_sgpr 54
		.amdhsa_accum_offset 244
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
	.set .Lv9_beyond_hotloop.num_vgpr, 244
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
    .vgpr_count:     244
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
