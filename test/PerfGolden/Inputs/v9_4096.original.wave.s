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
		v_mov_b32_e32 v4, 0
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
		s_mul_i32 s14, s14, 32
		s_add_i32 s13, s14, s13
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s14, 1, 0
		s_xor_b32 s15, s13, -1
		s_add_i32 s15, s15, 1
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s14, s15, s13
		s_cselect_b32 s15, 1, 0
		s_xor_b32 s16, s1, -1
		s_add_i32 s16, s16, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s16, s16, s1
		v_mov_b32_e32 v1, s16
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s17, s16, -1
		v_readfirstlane_b32 s18, v1
		s_add_i32 s17, s17, 1
		s_mul_i32 s19, s17, s18
		s_mul_hi_u32 s19, s18, s19
		s_add_i32 s18, s18, s19
		s_mul_hi_u32 s18, s14, s18
		s_mul_i32 s19, s18, s16
		s_xor_b32 s19, s19, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s14, s14, s19
		s_cmp_ge_u32 s14, s16
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s18, 1
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s18, s20, s18
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s14, s17
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s14, s20, s14
		s_cmp_ge_u32 s14, s16
		s_cselect_b32 s16, 1, 0
		s_add_i32 s19, s18, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s19, s18
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s1, s13, s1
		s_xor_b32 s13, s16, -1
		s_add_i32 s13, s13, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s13, s16
		s_mul_i32 s13, s1, 4
		s_xor_b32 s16, s13, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s0, s0, s16
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s16, s14, s17
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s14, s16, s14
		s_xor_b32 s16, s14, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s14, s16, s14
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s15, s0, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s15, s15, 1
		v_readfirstlane_b32 s16, v1
		s_mul_i32 s17, s15, s16
		s_mul_hi_u32 s17, s16, s17
		s_add_i32 s16, s16, s17
		s_mul_hi_u32 s16, s14, s16
		s_mul_i32 s16, s16, s0
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s16, s14, s16
		s_add_i32 s17, s16, s15
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s17, s16
		s_add_i32 s17, s16, s15
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s17, s16
		s_add_i32 s13, s13, s16
		v_readfirstlane_b32 s17, v1
		s_mul_i32 s18, s15, s17
		s_mul_hi_u32 s18, s17, s18
		s_add_i32 s17, s17, s18
		s_mul_hi_u32 s17, s14, s17
		s_mul_i32 s18, s17, s0
		s_xor_b32 s18, s18, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s14, s14, s18
		s_cmp_ge_u32 s14, s0
		s_cselect_b32 s18, 1, 0
		s_add_i32 s19, s17, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s17, s19, s17
		s_cselect_b32 s18, 1, 0
		s_add_i32 s15, s14, s15
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s14, s15, s14
		s_add_i32 s15, s17, 1
		s_cmp_ge_u32 s14, s0
		s_cselect_b32 s0, s15, s17
		s_mul_i32 s13, s13, 0x100
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v3, 1, v2
		v_mad_u32_u24 v1, v3, 2, v1
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v5, 1, v3
		v_mad_u32_u24 v1, v5, 4, v1
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v5, 1, v8
		v_mad_u32_u24 v1, v5, 8, v1
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v5, 1, v9
		v_mad_u32_u24 v1, v5, 16, v1
		v_lshrrev_b32_e32 v10, 8, v0
		v_and_b32_e32 v5, 1, v10
		v_mad_u32_u24 v1, v5, 32, v1
		v_add_u32_e32 v5, 0x80, v1
		v_add_u32_e32 v6, 0xc0, v1
		v_add_u32_e32 v11, s13, v1
		v_add3_u32 v1, 64, v1, s13
		v_add_u32_e32 v12, s13, v5
		v_add_u32_e32 v13, s13, v6
		s_mul_i32 s13, s0, 0x100
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v5, 7, v14
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v5
		v_add_u32_e32 v16, 32, v15
		v_add_u32_e32 v17, 64, v15
		v_add_u32_e32 v18, 0x60, v15
		v_add_u32_e32 v19, s13, v15
		v_add_u32_e32 v20, s13, v16
		v_add_u32_e32 v21, s13, v17
		v_add_u32_e32 v22, s13, v18
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		v_readfirstlane_b32 s2, v0
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s2, 0x420, s2
		s_mov_b32 m0, s2
		v_mul_lo_u32 v5, s10, v8
		v_lshlrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v7, 63, v6
		v_lshlrev_b32_e32 v7, 1, v7
		v_lshl_add_u32 v23, v5, 1, v7
		s_mul_i32 s3, s10, s1
		s_lshl_b32 s3, s3, 11
		s_mul_i32 s4, s10, s16
		s_lshl_b32 s4, s4, 9
		s_add_i32 s5, s3, s4
		v_add_u32_e32 v5, s5, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x2100
		s_lshl_b32 s14, s10, 7
		s_add_i32 s15, s14, s3
		s_add_i32 s15, s15, s4
		v_add_u32_e32 v5, s15, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x4200
		s_lshl_b32 s17, s10, 8
		s_add_i32 s18, s17, s3
		s_add_i32 s18, s18, s4
		v_add_u32_e32 v5, s18, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x6300
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s19, s10, s3
		s_add_i32 s19, s19, s4
		v_add_u32_e32 v5, s19, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x107c0
		v_mul_lo_u32 v5, s11, v14
		v_and_b32_e32 v6, 0x7f, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_lshl_add_u32 v24, v5, 1, v6
		s_lshl_b32 s0, s0, 9
		v_add_u32_e32 v5, s0, v24
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x128c0
		s_lshl_b32 s28, s11, 6
		s_add_i32 s29, s28, s0
		v_add_u32_e32 v5, s29, v24
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x18b80
		s_add_i32 s30, s0, 0x100
		v_add_u32_e32 v5, s30, v24
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ac80
		s_add_i32 s28, s28, 0x100
		s_add_i32 s28, s28, s0
		v_add_u32_e32 v5, s28, v24
		s_mul_i32 s31, s11, 64
		s_mul_i32 s32, 0xc0, s11
		v_mov_b32_e32 v6, 0x840
		v_mul_lo_u32 v6, v6, v9
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v25, 4, v7
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x83e0
		s_add_i32 s33, s3, 0x80
		s_add_i32 s33, s33, s4
		v_add_u32_e32 v5, s33, v23
		v_lshlrev_b32_e32 v26, 4, v25
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xa4e0
		s_add_i32 s14, s14, 0x80
		s_add_i32 s14, s14, s3
		s_add_i32 s14, s14, s4
		v_add_u32_e32 v5, s14, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xc5e0
		s_add_i32 s17, s17, 0x80
		s_add_i32 s17, s17, s3
		s_add_i32 s17, s17, s4
		v_add_u32_e32 v5, s17, v23
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xe6e0
		s_add_i32 s10, s10, 0x80
		s_add_i32 s3, s10, s3
		s_add_i32 s3, s3, s4
		v_add_u32_e32 v5, s3, v23
		v_and_b32_e32 v7, 15, v7
		v_lshrrev_b32_e32 v27, 3, v7
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x149a0
		s_lshl_b32 s4, s11, 7
		s_add_i32 s10, s4, s0
		v_add_u32_e32 v5, s10, v24
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x16aa0
		s_add_i32 s11, s32, s0
		v_add_u32_e32 v5, s11, v24
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1cd60
		s_add_i32 s4, s4, 0x100
		s_add_i32 s4, s4, s0
		v_add_u32_e32 v5, s4, v24
		v_mov_b32_e32 v28, 0x420
		v_mul_lo_u32 v28, v28, v27
		v_add3_u32 v6, v6, v26, v28
		v_lshrrev_b32_e32 v26, 2, v7
		v_and_b32_e32 v27, 1, v26
		v_lshl_add_u32 v6, v27, 9, v6
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ee60
		s_add_i32 s32, s32, 0x100
		s_add_i32 s32, s32, s0
		v_add_u32_e32 v5, s32, v24
		s_add_i32 s34, s31, s31
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_lshrrev_b32_e32 v5, 1, v7
		v_and_b32_e32 v5, 1, v5
		v_lshl_add_u32 v5, v5, 8, v6
		v_and_b32_e32 v6, 1, v7
		v_lshl_add_u32 v27, v6, 7, v5
		ds_read_b128 v[28:31], v27
		ds_read_b128 v[32:35], v27 offset:64
		ds_read_b128 v[36:39], v27 offset:8448
		ds_read_b128 v[40:43], v27 offset:8512
		ds_read_b128 v[44:47], v27 offset:16896
		ds_read_b128 v[48:51], v27 offset:16960
		ds_read_b128 v[52:55], v27 offset:25344
		ds_read_b128 v[56:59], v27 offset:25408
		v_mov_b32_e32 v5, 0x840
		v_mul_lo_u32 v5, v5, v25
		v_add_u32_e32 v5, 0x10000, v5
		v_lshlrev_b32_e32 v6, 8, v26
		v_lshrrev_b32_e32 v25, 6, v0
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v26, 5, v25
		v_add3_u32 v5, v5, v6, v26
		v_and_b32_e32 v6, 3, v7
		v_lshl_add_u32 v60, v6, 3, v5
		ds_read_b64_tr_b16 v[64:65], v60 offset:1984
		ds_read_b64_tr_b16 v[66:67], v60 offset:3040
		ds_read_b64_tr_b16 v[68:69], v60 offset:10432
		ds_read_b64_tr_b16 v[70:71], v60 offset:11488
		ds_read_b64_tr_b16 v[72:73], v60 offset:2048
		ds_read_b64_tr_b16 v[74:75], v60 offset:3104
		ds_read_b64_tr_b16 v[76:77], v60 offset:10496
		ds_read_b64_tr_b16 v[78:79], v60 offset:11552
		ds_read_b64_tr_b16 v[80:81], v60 offset:2112
		ds_read_b64_tr_b16 v[82:83], v60 offset:3168
		ds_read_b64_tr_b16 v[84:85], v60 offset:10560
		ds_read_b64_tr_b16 v[86:87], v60 offset:11616
		ds_read_b64_tr_b16 v[88:89], v60 offset:2176
		ds_read_b64_tr_b16 v[90:91], v60 offset:3232
		ds_read_b64_tr_b16 v[92:93], v60 offset:10624
		ds_read_b64_tr_b16 v[94:95], v60 offset:11680
		s_mov_b32 s35, 0x80
		s_mov_b32 s35, s35
		s_mov_b32 s36, 0
		s_lshl_b32 s37, s35, 1
		s_lshl_b32 s35, s34, 1
		s_lshl_b32 s31, s31, 1
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		v_mov_b32_e32 v96, v4
		v_mov_b32_e32 v97, v5
		v_mov_b32_e32 v98, v6
		v_mov_b32_e32 v99, v7
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
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[64:67], v[28:31], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[32:35], v[4:7]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		ds_read_b64_tr_b16 v[64:65], v60 offset:35712
		ds_read_b64_tr_b16 v[66:67], v60 offset:36768
		ds_read_b64_tr_b16 v[68:69], v60 offset:44160
		ds_read_b64_tr_b16 v[70:71], v60 offset:45216
		ds_read_b64_tr_b16 v[72:73], v60 offset:35776
		ds_read_b64_tr_b16 v[74:75], v60 offset:36832
		ds_read_b64_tr_b16 v[76:77], v60 offset:44224
		ds_read_b64_tr_b16 v[78:79], v60 offset:45280
		ds_read_b64_tr_b16 v[80:81], v60 offset:35840
		ds_read_b64_tr_b16 v[82:83], v60 offset:36896
		ds_read_b64_tr_b16 v[84:85], v60 offset:44288
		ds_read_b64_tr_b16 v[86:87], v60 offset:45344
		ds_read_b64_tr_b16 v[88:89], v60 offset:35904
		ds_read_b64_tr_b16 v[90:91], v60 offset:36960
		ds_read_b64_tr_b16 v[92:93], v60 offset:44352
		ds_read_b64_tr_b16 v[94:95], v60 offset:45408
		s_mov_b32 m0, s2
		s_add_i32 s34, s5, s37
		v_add_u32_e32 v61, s34, v23
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x2100
		v_add_u32_e32 v61, s37, v23
		v_add_u32_e32 v62, s15, v61
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x4200
		v_add_u32_e32 v62, s18, v61
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x6300
		v_add_u32_e32 v61, s19, v61
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x107c0
		s_add_i32 s34, s0, s35
		v_add_u32_e32 v61, s34, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x128c0
		s_add_i32 s34, s29, s35
		v_add_u32_e32 v61, s34, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[28:31], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[28:31], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[28:31], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[56:59], v[212:215]
		ds_read_b128 v[28:31], v27 offset:33760
		ds_read_b128 v[32:35], v27 offset:33824
		ds_read_b128 v[36:39], v27 offset:42208
		ds_read_b128 v[40:43], v27 offset:42272
		ds_read_b128 v[44:47], v27 offset:50656
		ds_read_b128 v[48:51], v27 offset:50720
		ds_read_b128 v[52:55], v27 offset:59104
		ds_read_b128 v[56:59], v27 offset:59168
		ds_read_b64_tr_b16 v[64:65], v60 offset:18848
		ds_read_b64_tr_b16 v[66:67], v60 offset:19904
		ds_read_b64_tr_b16 v[68:69], v60 offset:27296
		ds_read_b64_tr_b16 v[70:71], v60 offset:28352
		ds_read_b64_tr_b16 v[72:73], v60 offset:18912
		ds_read_b64_tr_b16 v[74:75], v60 offset:19968
		ds_read_b64_tr_b16 v[76:77], v60 offset:27360
		ds_read_b64_tr_b16 v[78:79], v60 offset:28416
		ds_read_b64_tr_b16 v[80:81], v60 offset:18976
		ds_read_b64_tr_b16 v[82:83], v60 offset:20032
		ds_read_b64_tr_b16 v[84:85], v60 offset:27424
		ds_read_b64_tr_b16 v[86:87], v60 offset:28480
		ds_read_b64_tr_b16 v[88:89], v60 offset:19040
		ds_read_b64_tr_b16 v[90:91], v60 offset:20096
		ds_read_b64_tr_b16 v[92:93], v60 offset:27488
		ds_read_b64_tr_b16 v[94:95], v60 offset:28544
		s_add_i32 m0, s2, 0x18b80
		s_add_i32 s34, s30, s35
		v_add_u32_e32 v61, s34, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ac80
		s_add_i32 s34, s28, s35
		v_add_u32_e32 v61, s34, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[64:67], v[28:31], v[4:7]
		s_add_i32 s34, s35, s31
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[32:35], v[4:7]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		ds_read_b64_tr_b16 v[64:65], v60 offset:52576
		ds_read_b64_tr_b16 v[66:67], v60 offset:53632
		ds_read_b64_tr_b16 v[68:69], v60 offset:61024
		ds_read_b64_tr_b16 v[70:71], v60 offset:62080
		ds_read_b64_tr_b16 v[72:73], v60 offset:52640
		ds_read_b64_tr_b16 v[74:75], v60 offset:53696
		ds_read_b64_tr_b16 v[76:77], v60 offset:61088
		ds_read_b64_tr_b16 v[78:79], v60 offset:62144
		ds_read_b64_tr_b16 v[80:81], v60 offset:52704
		ds_read_b64_tr_b16 v[82:83], v60 offset:53760
		ds_read_b64_tr_b16 v[84:85], v60 offset:61152
		ds_read_b64_tr_b16 v[86:87], v60 offset:62208
		ds_read_b64_tr_b16 v[88:89], v60 offset:52768
		ds_read_b64_tr_b16 v[90:91], v60 offset:53824
		ds_read_b64_tr_b16 v[92:93], v60 offset:61216
		ds_read_b64_tr_b16 v[94:95], v60 offset:62272
		s_add_i32 m0, s2, 0x83e0
		s_add_i32 s38, s33, s37
		v_add_u32_e32 v61, s38, v23
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xa4e0
		v_add_u32_e32 v61, s37, v23
		v_add_u32_e32 v62, s14, v61
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xc5e0
		v_add_u32_e32 v62, s17, v61
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xe6e0
		v_add_u32_e32 v61, s3, v61
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x149a0
		s_add_i32 s38, s10, s35
		v_add_u32_e32 v61, s38, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x16aa0
		s_add_i32 s38, s11, s35
		v_add_u32_e32 v61, s38, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[28:31], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[28:31], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[28:31], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[56:59], v[212:215]
		ds_read_b128 v[28:31], v27
		ds_read_b128 v[32:35], v27 offset:64
		ds_read_b128 v[36:39], v27 offset:8448
		ds_read_b128 v[40:43], v27 offset:8512
		ds_read_b128 v[44:47], v27 offset:16896
		ds_read_b128 v[48:51], v27 offset:16960
		ds_read_b128 v[52:55], v27 offset:25344
		ds_read_b128 v[56:59], v27 offset:25408
		ds_read_b64_tr_b16 v[64:65], v60 offset:1984
		ds_read_b64_tr_b16 v[66:67], v60 offset:3040
		ds_read_b64_tr_b16 v[68:69], v60 offset:10432
		ds_read_b64_tr_b16 v[70:71], v60 offset:11488
		ds_read_b64_tr_b16 v[72:73], v60 offset:2048
		ds_read_b64_tr_b16 v[74:75], v60 offset:3104
		ds_read_b64_tr_b16 v[76:77], v60 offset:10496
		ds_read_b64_tr_b16 v[78:79], v60 offset:11552
		ds_read_b64_tr_b16 v[80:81], v60 offset:2112
		ds_read_b64_tr_b16 v[82:83], v60 offset:3168
		ds_read_b64_tr_b16 v[84:85], v60 offset:10560
		ds_read_b64_tr_b16 v[86:87], v60 offset:11616
		ds_read_b64_tr_b16 v[88:89], v60 offset:2176
		ds_read_b64_tr_b16 v[90:91], v60 offset:3232
		ds_read_b64_tr_b16 v[92:93], v60 offset:10624
		ds_read_b64_tr_b16 v[94:95], v60 offset:11680
		s_add_i32 m0, s2, 0x1cd60
		s_add_i32 s38, s4, s35
		v_add_u32_e32 v61, s38, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ee60
		s_add_i32 s35, s32, s35
		v_add_u32_e32 v61, s35, v24
		buffer_load_dwordx4 v61, s[24:27], 0 offen lds
		s_add_i32 s37, s37, 0x100
		s_add_i32 s35, s34, s31
		s_add_i32 s36, s36, 2
		s_cmp_lt_i32 s36, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[64:67], v[28:31], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[32:35], v[4:7]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		ds_read_b64_tr_b16 v[64:65], v60 offset:35712
		ds_read_b64_tr_b16 v[66:67], v60 offset:36768
		ds_read_b64_tr_b16 v[68:69], v60 offset:44160
		ds_read_b64_tr_b16 v[70:71], v60 offset:45216
		ds_read_b64_tr_b16 v[72:73], v60 offset:35776
		ds_read_b64_tr_b16 v[74:75], v60 offset:36832
		ds_read_b64_tr_b16 v[76:77], v60 offset:44224
		ds_read_b64_tr_b16 v[78:79], v60 offset:45280
		ds_read_b64_tr_b16 v[80:81], v60 offset:35840
		ds_read_b64_tr_b16 v[82:83], v60 offset:36896
		ds_read_b64_tr_b16 v[84:85], v60 offset:44288
		ds_read_b64_tr_b16 v[86:87], v60 offset:45344
		ds_read_b64_tr_b16 v[88:89], v60 offset:35904
		ds_read_b64_tr_b16 v[90:91], v60 offset:36960
		ds_read_b64_tr_b16 v[92:93], v60 offset:44352
		ds_read_b64_tr_b16 v[94:95], v60 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[28:31], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[28:31], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[28:31], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[56:59], v[212:215]
		ds_read_b128 v[28:31], v27 offset:33760
		ds_read_b128 v[32:35], v27 offset:33824
		ds_read_b128 v[36:39], v27 offset:42208
		ds_read_b128 v[40:43], v27 offset:42272
		ds_read_b128 v[44:47], v27 offset:50656
		ds_read_b128 v[48:51], v27 offset:50720
		ds_read_b128 v[52:55], v27 offset:59104
		ds_read_b128 v[56:59], v27 offset:59168
		ds_read_b64_tr_b16 v[64:65], v60 offset:18848
		ds_read_b64_tr_b16 v[66:67], v60 offset:19904
		ds_read_b64_tr_b16 v[68:69], v60 offset:27296
		ds_read_b64_tr_b16 v[70:71], v60 offset:28352
		ds_read_b64_tr_b16 v[72:73], v60 offset:18912
		ds_read_b64_tr_b16 v[74:75], v60 offset:19968
		ds_read_b64_tr_b16 v[76:77], v60 offset:27360
		ds_read_b64_tr_b16 v[78:79], v60 offset:28416
		ds_read_b64_tr_b16 v[80:81], v60 offset:18976
		ds_read_b64_tr_b16 v[82:83], v60 offset:20032
		ds_read_b64_tr_b16 v[84:85], v60 offset:27424
		ds_read_b64_tr_b16 v[86:87], v60 offset:28480
		ds_read_b64_tr_b16 v[88:89], v60 offset:19040
		ds_read_b64_tr_b16 v[90:91], v60 offset:20096
		ds_read_b64_tr_b16 v[92:93], v60 offset:27488
		ds_read_b64_tr_b16 v[94:95], v60 offset:28544
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[64:67], v[28:31], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[4:7], v[68:71], v[32:35], v[4:7]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[56:59], v[148:151]
		ds_read_b64_tr_b16 v[64:65], v60 offset:52576
		ds_read_b64_tr_b16 v[66:67], v60 offset:53632
		ds_read_b64_tr_b16 v[68:69], v60 offset:61024
		ds_read_b64_tr_b16 v[70:71], v60 offset:62080
		ds_read_b64_tr_b16 v[72:73], v60 offset:52640
		ds_read_b64_tr_b16 v[74:75], v60 offset:53696
		ds_read_b64_tr_b16 v[76:77], v60 offset:61088
		ds_read_b64_tr_b16 v[78:79], v60 offset:62144
		ds_read_b64_tr_b16 v[80:81], v60 offset:52704
		ds_read_b64_tr_b16 v[82:83], v60 offset:53760
		ds_read_b64_tr_b16 v[84:85], v60 offset:61152
		ds_read_b64_tr_b16 v[86:87], v60 offset:62208
		ds_read_b64_tr_b16 v[88:89], v60 offset:52768
		ds_read_b64_tr_b16 v[90:91], v60 offset:53824
		ds_read_b64_tr_b16 v[92:93], v60 offset:61216
		ds_read_b64_tr_b16 v[94:95], v60 offset:62272
		v_cvt_pk_f16_f32 v60, v4, v5
		v_cvt_pk_f16_f32 v61, v6, v7
		v_cvt_pk_f16_f32 v4, v96, v97
		v_cvt_pk_f16_f32 v5, v98, v99
		v_cvt_pk_f16_f32 v6, v100, v101
		v_cvt_pk_f16_f32 v7, v102, v103
		v_cvt_pk_f16_f32 v62, v104, v105
		v_cvt_pk_f16_f32 v63, v106, v107
		v_cvt_pk_f16_f32 v96, v108, v109
		v_cvt_pk_f16_f32 v97, v110, v111
		v_cvt_pk_f16_f32 v98, v112, v113
		v_cvt_pk_f16_f32 v99, v114, v115
		v_cvt_pk_f16_f32 v100, v116, v117
		v_cvt_pk_f16_f32 v101, v118, v119
		v_cvt_pk_f16_f32 v102, v120, v121
		v_cvt_pk_f16_f32 v103, v122, v123
		v_cvt_pk_f16_f32 v104, v124, v125
		v_cvt_pk_f16_f32 v105, v126, v127
		v_cvt_pk_f16_f32 v106, v128, v129
		v_cvt_pk_f16_f32 v107, v130, v131
		v_cvt_pk_f16_f32 v108, v132, v133
		v_cvt_pk_f16_f32 v109, v134, v135
		v_cvt_pk_f16_f32 v110, v136, v137
		v_cvt_pk_f16_f32 v111, v138, v139
		v_cvt_pk_f16_f32 v112, v140, v141
		v_cvt_pk_f16_f32 v113, v142, v143
		v_cvt_pk_f16_f32 v114, v144, v145
		v_cvt_pk_f16_f32 v115, v146, v147
		v_cvt_pk_f16_f32 v116, v148, v149
		v_cvt_pk_f16_f32 v117, v150, v151
		v_cvt_pk_f16_f32 v118, v152, v153
		v_cvt_pk_f16_f32 v119, v154, v155
		v_cmp_lt_i32_e64 vcc, v11, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v19, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		s_mul_i32 s14, s1, s12
		s_lshl_b32 s14, s14, 11
		s_add_i32 s15, s0, s14
		s_mul_i32 s17, s16, s12
		s_lshl_b32 s17, s17, 9
		s_add_i32 s15, s15, s17
		v_mul_lo_u32 v11, s12, v10
		v_lshl_add_u32 v19, v11, 6, s15
		v_and_b32_e32 v23, 1, v0
		v_mul_lo_u32 v24, s12, v23
		v_lshlrev_b32_e32 v24, 1, v24
		v_and_b32_e32 v27, 1, v9
		v_mul_lo_u32 v120, s12, v27
		v_lshlrev_b32_e32 v120, 5, v120
		v_add3_u32 v19, v19, v24, v120
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v121, s12, v8
		v_lshlrev_b32_e32 v121, 4, v121
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v122, s12, v3
		v_lshlrev_b32_e32 v122, 3, v122
		v_add3_u32 v19, v19, v121, v122
		v_and_b32_e32 v2, 1, v2
		v_mul_lo_u32 v123, s12, v2
		v_lshlrev_b32_e32 v123, 2, v123
		v_add3_u32 v19, v19, v123, v26
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v124, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v125, 3, v14
		v_add3_u32 v19, v19, v124, v125
		v_mov_b32_e32 v126, 0x80000000
		v_cndmask_b32_e64 v19, v126, v19, s[10:11]
		s_mov_b32 s24, s6
		s_mov_b32 s25, s7
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		buffer_store_dwordx2 v[60:61], v19, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v20, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		v_mul_lo_u32 v9, s12, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_add_u32_e32 v19, s15, v9
		v_add3_u32 v19, v19, v24, v121
		v_add3_u32 v19, v19, v122, v123
		v_lshlrev_b32_e32 v20, 4, v25
		v_lshlrev_b32_e32 v14, 2, v14
		v_add_u32_e32 v25, 32, v14
		v_lshlrev_b32_e32 v0, 3, v0
		v_bitop3_b32 v25, v20, v25, v0 bitop3:0x96
		v_lshl_add_u32 v60, v25, 1, v19
		v_cndmask_b32_e64 v60, v126, v60, s[10:11]
		buffer_store_dwordx2 v[4:5], v60, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s18, s2, s10
		s_and_b32 s19, s3, s11
		v_add_u32_e32 v4, 64, v14
		v_bitop3_b32 v4, v20, v4, v0 bitop3:0x96
		v_lshl_add_u32 v5, v4, 1, v19
		v_cndmask_b32_e64 v5, v126, v5, s[18:19]
		buffer_store_dwordx2 v[6:7], v5, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s2, s18
		s_and_b32 s21, s3, s19
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s0, s0, s1
		s_mul_i32 s16, s12, s16
		s_lshl_b32 s16, s16, 9
		s_add_i32 s0, s0, s16
		v_add3_u32 v5, s0, v9, v24
		v_add3_u32 v5, v5, v121, v122
		v_add_u32_e32 v6, 0x60, v14
		v_bitop3_b32 v0, v20, v6, v0 bitop3:0x96
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v5, v5, v123, v0
		v_cndmask_b32_e64 v5, v126, v5, s[20:21]
		buffer_store_dwordx2 v[62:63], v5, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v1, s8
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s20, s4
		s_and_b32 s23, s21, s5
		v_lshlrev_b32_e32 v1, 5, v10
		v_lshlrev_b32_e32 v5, 4, v27
		v_lshlrev_b32_e32 v6, 3, v8
		v_lshlrev_b32_e32 v3, 2, v3
		v_add_u32_e32 v7, 64, v23
		v_lshlrev_b32_e32 v2, 1, v2
		v_xor_b32_e32 v7, v7, v2
		v_bitop3_b32 v7, v6, v3, v7 bitop3:0x96
		v_bitop3_b32 v7, v1, v5, v7 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v8, s15, v7
		v_add_u32_e32 v10, v8, v26
		v_add3_u32 v10, v10, v124, v125
		v_cndmask_b32_e64 v10, v126, v10, s[22:23]
		buffer_store_dwordx2 v[96:97], v10, s[24:27], 0 offen
		s_and_b32 s22, s20, s6
		s_and_b32 s23, s21, s7
		v_lshl_add_u32 v10, v25, 1, v8
		v_cndmask_b32_e64 v10, v126, v10, s[22:23]
		buffer_store_dwordx2 v[98:99], v10, s[24:27], 0 offen
		s_and_b32 s22, s20, s10
		s_and_b32 s23, s21, s11
		v_lshl_add_u32 v8, v4, 1, v8
		v_cndmask_b32_e64 v8, v126, v8, s[22:23]
		buffer_store_dwordx2 v[100:101], v8, s[24:27], 0 offen
		s_and_b32 s22, s20, s18
		s_and_b32 s23, s21, s19
		v_add3_u32 v8, s0, v7, v0
		v_cndmask_b32_e64 v8, v126, v8, s[22:23]
		buffer_store_dwordx2 v[102:103], v8, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v12, s8
		s_mov_b64 s[22:23], vcc
		s_and_b32 s28, s22, s4
		s_and_b32 s29, s23, s5
		v_add_u32_e32 v8, 0x80, v23
		v_xor_b32_e32 v8, v8, v2
		v_bitop3_b32 v8, v6, v3, v8 bitop3:0x96
		v_bitop3_b32 v8, v1, v5, v8 bitop3:0x96
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v10, s15, v8
		v_add_u32_e32 v12, v10, v26
		v_add3_u32 v12, v12, v124, v125
		v_cndmask_b32_e64 v12, v126, v12, s[28:29]
		buffer_store_dwordx2 v[104:105], v12, s[24:27], 0 offen
		s_and_b32 s28, s22, s6
		s_and_b32 s29, s23, s7
		v_lshl_add_u32 v12, v25, 1, v10
		v_cndmask_b32_e64 v12, v126, v12, s[28:29]
		buffer_store_dwordx2 v[106:107], v12, s[24:27], 0 offen
		s_and_b32 s28, s22, s10
		s_and_b32 s29, s23, s11
		v_lshl_add_u32 v10, v4, 1, v10
		v_cndmask_b32_e64 v10, v126, v10, s[28:29]
		buffer_store_dwordx2 v[108:109], v10, s[24:27], 0 offen
		s_and_b32 s28, s22, s18
		s_and_b32 s29, s23, s19
		v_add3_u32 v10, s0, v8, v0
		v_cndmask_b32_e64 v10, v126, v10, s[28:29]
		buffer_store_dwordx2 v[110:111], v10, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v13, s8
		s_mov_b64 s[28:29], vcc
		s_and_b32 s32, s28, s4
		s_and_b32 s33, s29, s5
		v_add_u32_e32 v10, 0xc0, v23
		v_xor_b32_e32 v2, v10, v2
		v_bitop3_b32 v2, v6, v3, v2 bitop3:0x96
		v_bitop3_b32 v1, v1, v5, v2 bitop3:0x96
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v2, v1, 1, s0
		v_add_u32_e32 v3, v2, v26
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[32:33]
		buffer_store_dwordx2 v[112:113], v3, s[24:27], 0 offen
		s_and_b32 s4, s28, s6
		s_and_b32 s5, s29, s7
		v_lshl_add_u32 v3, v25, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[4:5]
		buffer_store_dwordx2 v[114:115], v3, s[24:27], 0 offen
		s_and_b32 s4, s28, s10
		s_and_b32 s5, s29, s11
		v_lshl_add_u32 v3, v4, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[4:5]
		buffer_store_dwordx2 v[116:117], v3, s[24:27], 0 offen
		s_and_b32 s4, s28, s18
		s_and_b32 s5, s29, s19
		v_add_u32_e32 v2, v2, v0
		v_cndmask_b32_e64 v2, v126, v2, s[4:5]
		buffer_store_dwordx2 v[118:119], v2, s[24:27], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[28:31], v[156:159]
		s_add_i32 s0, s13, 0x80
		v_add_u32_e32 v2, s0, v15
		v_add_u32_e32 v3, s0, v16
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[28:31], v[160:163]
		v_add_u32_e32 v5, s0, v17
		v_add_u32_e32 v6, s0, v18
		v_cmp_lt_i32_e64 vcc, v2, s9
		s_mov_b64 s[4:5], vcc
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[28:31], v[164:167]
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		s_add_i32 s0, s30, s14
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[28:31], v[168:171]
		s_add_i32 s0, s0, s17
		v_lshl_add_u32 v2, v11, 6, s0
		v_add3_u32 v2, v2, v24, v120
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[36:39], v[184:187]
		v_add3_u32 v2, v2, v121, v122
		v_add3_u32 v2, v2, v123, v26
		v_add3_u32 v2, v2, v124, v125
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[36:39], v[172:175]
		v_cndmask_b32_e64 v2, v126, v2, s[6:7]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[32:35], v[156:159]
		s_nop 7
		v_cvt_pk_f16_f32 v10, v156, v157
		v_cvt_pk_f16_f32 v11, v158, v159
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[32:35], v[160:163]
		s_nop 7
		v_cvt_pk_f16_f32 v12, v160, v161
		v_cvt_pk_f16_f32 v13, v162, v163
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[32:35], v[164:167]
		s_nop 7
		v_cvt_pk_f16_f32 v14, v164, v165
		v_cvt_pk_f16_f32 v15, v166, v167
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[32:35], v[168:171]
		s_nop 7
		v_cvt_pk_f16_f32 v16, v168, v169
		v_cvt_pk_f16_f32 v17, v170, v171
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[40:43], v[184:187]
		s_nop 7
		v_cvt_pk_f16_f32 v18, v184, v185
		v_cvt_pk_f16_f32 v19, v186, v187
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[40:43], v[172:175]
		s_nop 7
		v_cvt_pk_f16_f32 v20, v172, v173
		v_cvt_pk_f16_f32 v21, v174, v175
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[40:43], v[176:179]
		s_nop 7
		v_cvt_pk_f16_f32 v22, v176, v177
		v_cvt_pk_f16_f32 v23, v178, v179
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[40:43], v[180:183]
		s_nop 7
		v_cvt_pk_f16_f32 v28, v180, v181
		v_cvt_pk_f16_f32 v29, v182, v183
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[48:51], v[196:199]
		s_nop 7
		v_cvt_pk_f16_f32 v30, v196, v197
		v_cvt_pk_f16_f32 v31, v198, v199
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[48:51], v[188:191]
		s_nop 7
		v_cvt_pk_f16_f32 v32, v188, v189
		v_cvt_pk_f16_f32 v33, v190, v191
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[48:51], v[192:195]
		s_nop 7
		v_cvt_pk_f16_f32 v34, v192, v193
		v_cvt_pk_f16_f32 v35, v194, v195
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[48:51], v[200:203]
		s_nop 7
		v_cvt_pk_f16_f32 v36, v200, v201
		v_cvt_pk_f16_f32 v37, v202, v203
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[56:59], v[216:219]
		s_nop 7
		v_cvt_pk_f16_f32 v38, v216, v217
		v_cvt_pk_f16_f32 v39, v218, v219
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[56:59], v[204:207]
		s_nop 7
		v_cvt_pk_f16_f32 v40, v204, v205
		v_cvt_pk_f16_f32 v41, v206, v207
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[56:59], v[208:211]
		s_nop 7
		v_cvt_pk_f16_f32 v42, v208, v209
		v_cvt_pk_f16_f32 v43, v210, v211
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[56:59], v[212:215]
		s_nop 7
		v_cvt_pk_f16_f32 v44, v212, v213
		v_cvt_pk_f16_f32 v45, v214, v215
		buffer_store_dwordx2 v[10:11], v2, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v3, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		v_add_u32_e32 v2, s0, v9
		v_add3_u32 v2, v2, v24, v121
		v_add3_u32 v2, v2, v122, v123
		v_lshl_add_u32 v3, v25, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[10:11]
		buffer_store_dwordx2 v[12:13], v3, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s12, s2, s10
		s_and_b32 s13, s3, s11
		v_lshl_add_u32 v2, v4, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[12:13]
		buffer_store_dwordx2 v[14:15], v2, s[24:27], 0 offen
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[12:13], vcc
		s_and_b32 s8, s2, s12
		s_and_b32 s9, s3, s13
		s_add_i32 s1, s30, s1
		s_add_i32 s1, s1, s16
		v_add3_u32 v2, s1, v9, v24
		v_add3_u32 v2, v2, v121, v122
		v_add3_u32 v2, v2, v123, v0
		v_cndmask_b32_e64 v2, v126, v2, s[8:9]
		buffer_store_dwordx2 v[16:17], v2, s[24:27], 0 offen
		s_and_b32 s2, s20, s4
		s_and_b32 s3, s21, s5
		v_add_u32_e32 v2, s0, v7
		v_add_u32_e32 v3, v2, v26
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[20:21], v3, s[24:27], 0 offen
		s_and_b32 s2, s20, s6
		s_and_b32 s3, s21, s7
		v_lshl_add_u32 v3, v25, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[22:23], v3, s[24:27], 0 offen
		s_and_b32 s2, s20, s10
		s_and_b32 s3, s21, s11
		v_lshl_add_u32 v2, v4, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[28:29], v2, s[24:27], 0 offen
		s_and_b32 s2, s20, s12
		s_and_b32 s3, s21, s13
		v_add3_u32 v2, s1, v7, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[18:19], v2, s[24:27], 0 offen
		s_and_b32 s2, s22, s4
		s_and_b32 s3, s23, s5
		v_add_u32_e32 v2, s0, v8
		v_add_u32_e32 v3, v2, v26
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[32:33], v3, s[24:27], 0 offen
		s_and_b32 s2, s22, s6
		s_and_b32 s3, s23, s7
		v_lshl_add_u32 v3, v25, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[34:35], v3, s[24:27], 0 offen
		s_and_b32 s2, s22, s10
		s_and_b32 s3, s23, s11
		v_lshl_add_u32 v2, v4, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[30:31], v2, s[24:27], 0 offen
		s_and_b32 s2, s22, s12
		s_and_b32 s3, s23, s13
		v_add3_u32 v2, s1, v8, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[36:37], v2, s[24:27], 0 offen
		s_and_b32 s2, s28, s4
		s_and_b32 s3, s29, s5
		v_lshl_add_u32 v1, v1, 1, s1
		v_add_u32_e32 v2, v1, v26
		v_add3_u32 v2, v2, v124, v125
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[40:41], v2, s[24:27], 0 offen
		s_and_b32 s0, s28, s6
		s_and_b32 s1, s29, s7
		v_lshl_add_u32 v2, v25, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[42:43], v2, s[24:27], 0 offen
		s_and_b32 s0, s28, s10
		s_and_b32 s1, s29, s11
		v_lshl_add_u32 v2, v4, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[44:45], v2, s[24:27], 0 offen
		s_and_b32 s0, s28, s12
		s_and_b32 s1, s29, s13
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v126, v0, s[0:1]
		buffer_store_dwordx2 v[38:39], v0, s[24:27], 0 offen
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
		.amdhsa_next_free_sgpr 39
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
	.set .Lv9_beyond_hotloop.numbered_sgpr, 39
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
    .sgpr_count:     39
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     220
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
