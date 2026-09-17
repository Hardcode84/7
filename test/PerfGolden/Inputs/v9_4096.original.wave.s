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
		s_mul_i32 s14, s14, 32
		s_add_i32 s15, s14, s13
		s_branch .Lv9_beyond_hotloop.if_end_0
.Lv9_beyond_hotloop.if_else_0:
		s_sub_i32 s14, s14, 8
		s_mul_i32 s14, s14, 31
		s_add_i32 s14, s14, 0x100
		s_add_i32 s15, s14, s13
.Lv9_beyond_hotloop.if_end_0:
		s_mul_i32 s1, s1, 4
		s_ashr_i32 s13, s15, 31
		s_xor_b32 s14, s15, s13
		s_sub_i32 s14, s14, s13
		s_ashr_i32 s15, s1, 31
		s_xor_b32 s1, s1, s15
		s_sub_i32 s1, s1, s15
		s_xor_b32 s15, s13, s15
		v_mov_b32_e32 v1, s1
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mov_b32 s16, 0
		v_readfirstlane_b32 s17, v1
		s_sub_i32 s18, s16, s1
		s_mul_i32 s18, s18, s17
		s_mul_hi_u32 s18, s17, s18
		s_add_i32 s17, s17, s18
		s_mul_hi_u32 s17, s14, s17
		s_mul_i32 s18, s17, s1
		s_sub_i32 s14, s14, s18
		s_add_i32 s18, s17, 1
		s_sub_i32 s19, s14, s1
		s_cmp_ge_u32 s14, s1
		s_cselect_b32 s17, s18, s17
		s_cselect_b32 s14, s19, s14
		s_add_i32 s18, s17, 1
		s_cmp_ge_u32 s14, s1
		s_cselect_b32 s17, s18, s17
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s17, s17, s15
		s_sub_i32 s15, s17, s15
		s_mul_i32 s17, s15, 4
		s_sub_i32 s0, s0, s17
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_sub_i32 s1, s14, s1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s1, s1, s14
		s_xor_b32 s1, s1, s13
		s_sub_i32 s1, s1, s13
		s_ashr_i32 s13, s1, 31
		s_xor_b32 s1, s1, s13
		s_sub_i32 s1, s1, s13
		s_ashr_i32 s14, s0, 31
		s_xor_b32 s0, s0, s14
		s_sub_i32 s0, s0, s14
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_sub_i32 s18, s16, s0
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		v_readfirstlane_b32 s19, v0
		v_readfirstlane_b32 s20, v1
		s_mul_i32 s18, s18, s20
		s_mul_hi_u32 s18, s20, s18
		s_add_i32 s18, s20, s18
		s_mul_hi_u32 s18, s1, s18
		s_mul_i32 s20, s18, s0
		s_sub_i32 s1, s1, s20
		s_sub_i32 s20, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s1, s20, s1
		s_cselect_b32 s20, 1, 0
		s_sub_i32 s21, s1, s0
		s_cmp_ge_u32 s1, s0
		s_cselect_b32 s0, s21, s1
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s0, s0, s13
		s_sub_i32 s0, s0, s13
		s_add_i32 s17, s17, s0
		s_xor_b32 s13, s13, s14
		s_add_i32 s14, s18, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s14, s14, s18
		s_add_i32 s18, s14, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s18, s14
		s_xor_b32 s1, s1, s13
		s_sub_i32 s1, s1, s13
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s4, s4, 6
		s_mul_i32 s4, 0x420, s4
		s_mov_b32 m0, s4
		v_lshrrev_b32_e32 v1, 3, v0
		v_mul_lo_u32 v2, s10, v1
		v_and_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 4, v3
		v_lshl_add_u32 v4, v2, 1, v3
		s_mul_i32 s5, s15, s10
		s_lshl_b32 s5, s5, 11
		s_mul_i32 s13, s0, s10
		s_lshl_b32 s13, s13, 9
		s_add_i32 s14, s5, s13
		v_add_u32_e32 v5, s14, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s17, s17, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s18, s10, 7
		s_add_i32 s18, s18, s5
		s_add_i32 s18, s18, s13
		v_add_u32_e32 v5, s18, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s28, s1, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s29, s10, 8
		s_add_i32 s29, s29, s5
		s_add_i32 s29, s29, s13
		v_add_u32_e32 v5, s29, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshr_b32 s19, s19, 6
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s5, s10, s5
		s_add_i32 s5, s5, s13
		v_add_u32_e32 v5, s5, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v5, 4, v0
		s_add_i32 m0, m0, 0xa4e0
		v_mul_lo_u32 v6, s11, v5
		v_and_b32_e32 v7, 15, v0
		v_lshlrev_b32_e32 v8, 4, v7
		v_lshl_add_u32 v6, v6, 1, v8
		s_lshl_b32 s1, s1, 9
		v_add_u32_e32 v8, s1, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_lshl_b32 s10, s11, 6
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s10, s1, s10
		v_add_u32_e32 v8, s10, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s13, s1, 0x100
		v_add_u32_e32 v8, s13, v6
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s13, s10, 0x100
		v_add_u32_e32 v9, s13, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mul_i32 s13, s11, 64
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s30, 0xc0, s11
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_add_u32_e32 v8, 0x80, v4
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s31, s14, 0x80
		v_add_u32_e32 v4, s31, v4
		v_add_u32_e32 v9, s18, v8
		v_add_u32_e32 v10, s29, v8
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_add_u32_e32 v4, s5, v8
		s_add_i32 m0, m0, 0x2100
		s_lshr_b32 s31, s19, 1
		s_mul_i32 s32, 0x840, s31
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v11, 4, v8
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v9, 4, v11
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v8, 15, v8
		s_add_i32 s33, s13, s13
		v_lshrrev_b32_e32 v11, 3, v8
		v_and_b32_e32 v8, 7, v8
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_mov_b32_e32 v10, 0x420
		v_mul_lo_u32 v10, v10, v11
		v_add3_u32 v9, s32, v9, v10
		s_add_i32 m0, m0, 0x2100
		v_lshl_add_u32 v8, v8, 7, v9
		s_lshl_b32 s11, s11, 7
		v_and_b32_e32 v9, 3, v0
		v_lshrrev_b32_e32 v10, 5, v0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_and_b32_e32 v4, 1, v10
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s11, s1, s11
		v_add_u32_e32 v11, s11, v6
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		v_mov_b32_e32 v11, 0x1080
		v_mul_lo_u32 v11, v11, v4
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s30, s1, s30
		v_add_u32_e32 v12, s30, v6
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 s32, s11, 0x100
		v_add_u32_e32 v12, s32, v6
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s32, s30, 0x100
		v_add_u32_e32 v13, s32, v6
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_and_b32_e32 v12, 1, v5
		s_add_i32 m0, m0, 0x2100
		s_and_b32 s19, s19, 1
		s_lshl_b32 s19, s19, 5
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		ds_read_b128 v[16:19], v8
		ds_read_b128 v[20:23], v8 offset:64
		ds_read_b128 v[24:27], v8 offset:8448
		ds_read_b128 v[28:31], v8 offset:8512
		ds_read_b128 v[32:35], v8 offset:16896
		ds_read_b128 v[36:39], v8 offset:16960
		ds_read_b128 v[40:43], v8 offset:25344
		ds_read_b128 v[44:47], v8 offset:25408
		s_add_i32 s32, s19, 0x10000
		v_lshl_add_u32 v9, v9, 3, s32
		v_mov_b32_e32 v13, 0x840
		v_mul_lo_u32 v13, v13, v12
		v_add3_u32 v9, v9, v11, v13
		v_and_b32_e32 v11, 1, v1
		v_lshl_add_u32 v9, v11, 9, v9
		v_lshrrev_b32_e32 v11, 2, v0
		v_and_b32_e32 v13, 1, v11
		v_lshl_add_u32 v9, v13, 8, v9
		ds_read_b64_tr_b16 v[48:49], v9 offset:2016
		ds_read_b64_tr_b16 v[50:51], v9 offset:3072
		ds_read_b64_tr_b16 v[52:53], v9 offset:10464
		ds_read_b64_tr_b16 v[54:55], v9 offset:11520
		ds_read_b64_tr_b16 v[56:57], v9 offset:2080
		ds_read_b64_tr_b16 v[58:59], v9 offset:3136
		ds_read_b64_tr_b16 v[60:61], v9 offset:10528
		ds_read_b64_tr_b16 v[62:63], v9 offset:11584
		ds_read_b64_tr_b16 v[64:65], v9 offset:2144
		ds_read_b64_tr_b16 v[66:67], v9 offset:3200
		ds_read_b64_tr_b16 v[68:69], v9 offset:10592
		ds_read_b64_tr_b16 v[70:71], v9 offset:11648
		ds_read_b64_tr_b16 v[72:73], v9 offset:2208
		ds_read_b64_tr_b16 v[74:75], v9 offset:3264
		ds_read_b64_tr_b16 v[76:77], v9 offset:10656
		ds_read_b64_tr_b16 v[78:79], v9 offset:11712
		v_lshrrev_b32_e32 v13, 8, v0
		v_cmp_ne_u32_e64 vcc, v13, s16
		v_cmp_eq_u32_e64 s[34:35], v13, s16
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[64:65], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[64:65]
		s_setprio 0
		v_lshl_add_u32 v14, v2, 1, s14
		v_lshl_add_u32 v15, v2, 1, s18
		v_lshl_add_u32 v80, v2, 1, s29
		v_lshl_add_u32 v2, v2, 1, s5
		s_mov_b32 s5, 0x80
		s_mov_b32 s14, s5
		v_add_u32_e32 v81, 0x100, v3
		v_add_u32_e32 v82, v81, v14
		v_add_u32_e32 v83, v81, v15
		v_add_u32_e32 v84, v81, v80
		v_add_u32_e32 v81, v81, v2
		v_add_u32_e32 v3, 0x180, v3
		v_add_u32_e32 v14, v3, v14
		v_add_u32_e32 v15, v3, v15
		v_add_u32_e32 v80, v3, v80
		v_add_u32_e32 v2, v3, v2
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_lshl_b32 s2, s33, 1
		s_lshl_b32 s3, s13, 1
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
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
.Lv9_beyond_hotloop.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[44:47], v[148:151]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b64_tr_b16 v[48:49], v9 offset:35776
		ds_read_b64_tr_b16 v[50:51], v9 offset:36832
		ds_read_b64_tr_b16 v[52:53], v9 offset:44224
		ds_read_b64_tr_b16 v[54:55], v9 offset:45280
		ds_read_b64_tr_b16 v[56:57], v9 offset:35840
		ds_read_b64_tr_b16 v[58:59], v9 offset:36896
		ds_read_b64_tr_b16 v[60:61], v9 offset:44288
		ds_read_b64_tr_b16 v[62:63], v9 offset:45344
		ds_read_b64_tr_b16 v[64:65], v9 offset:35904
		ds_read_b64_tr_b16 v[66:67], v9 offset:36960
		ds_read_b64_tr_b16 v[68:69], v9 offset:44352
		ds_read_b64_tr_b16 v[70:71], v9 offset:45408
		ds_read_b64_tr_b16 v[72:73], v9 offset:35968
		ds_read_b64_tr_b16 v[74:75], v9 offset:37024
		ds_read_b64_tr_b16 v[76:77], v9 offset:44416
		ds_read_b64_tr_b16 v[78:79], v9 offset:45472
		s_mov_b32 m0, s4
		s_add_i32 s5, s2, s3
		buffer_load_dwordx4 v82, s[24:27], 0 offen lds
		s_add_i32 s13, s1, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s18, s10, s2
		buffer_load_dwordx4 v83, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s13, v6
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v85, s18, v6
		buffer_load_dwordx4 v84, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s18, s18, 0x100
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[44:47], v[204:207]
		s_setprio 1
		s_barrier
		ds_read_b128 v[16:19], v8 offset:33792
		ds_read_b128 v[20:23], v8 offset:33856
		ds_read_b128 v[24:27], v8 offset:42240
		ds_read_b128 v[28:31], v8 offset:42304
		ds_read_b128 v[32:35], v8 offset:50688
		ds_read_b128 v[36:39], v8 offset:50752
		ds_read_b128 v[40:43], v8 offset:59136
		ds_read_b128 v[44:47], v8 offset:59200
		ds_read_b64_tr_b16 v[48:49], v9 offset:18912
		ds_read_b64_tr_b16 v[50:51], v9 offset:19968
		ds_read_b64_tr_b16 v[52:53], v9 offset:27360
		ds_read_b64_tr_b16 v[54:55], v9 offset:28416
		ds_read_b64_tr_b16 v[56:57], v9 offset:18976
		ds_read_b64_tr_b16 v[58:59], v9 offset:20032
		ds_read_b64_tr_b16 v[60:61], v9 offset:27424
		ds_read_b64_tr_b16 v[62:63], v9 offset:28480
		ds_read_b64_tr_b16 v[64:65], v9 offset:19040
		ds_read_b64_tr_b16 v[66:67], v9 offset:20096
		ds_read_b64_tr_b16 v[68:69], v9 offset:27488
		ds_read_b64_tr_b16 v[70:71], v9 offset:28544
		ds_read_b64_tr_b16 v[72:73], v9 offset:19104
		ds_read_b64_tr_b16 v[74:75], v9 offset:20160
		ds_read_b64_tr_b16 v[76:77], v9 offset:27552
		ds_read_b64_tr_b16 v[78:79], v9 offset:28608
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v3, s13, v6
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s18, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[44:47], v[148:151]
		s_setprio 1
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v9 offset:52672
		ds_read_b64_tr_b16 v[50:51], v9 offset:53728
		ds_read_b64_tr_b16 v[52:53], v9 offset:61120
		ds_read_b64_tr_b16 v[54:55], v9 offset:62176
		ds_read_b64_tr_b16 v[56:57], v9 offset:52736
		ds_read_b64_tr_b16 v[58:59], v9 offset:53792
		ds_read_b64_tr_b16 v[60:61], v9 offset:61184
		ds_read_b64_tr_b16 v[62:63], v9 offset:62240
		ds_read_b64_tr_b16 v[64:65], v9 offset:52800
		ds_read_b64_tr_b16 v[66:67], v9 offset:53856
		ds_read_b64_tr_b16 v[68:69], v9 offset:61248
		ds_read_b64_tr_b16 v[70:71], v9 offset:62304
		ds_read_b64_tr_b16 v[72:73], v9 offset:52864
		ds_read_b64_tr_b16 v[74:75], v9 offset:53920
		ds_read_b64_tr_b16 v[76:77], v9 offset:61312
		ds_read_b64_tr_b16 v[78:79], v9 offset:62368
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s13, s11, s2
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_add_i32 s2, s30, s2
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s13, v6
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		v_add_u32_e32 v85, s2, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s2, s2, 0x100
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s13, s13, 0x100
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[44:47], v[204:207]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v8
		ds_read_b128 v[20:23], v8 offset:64
		ds_read_b128 v[24:27], v8 offset:8448
		ds_read_b128 v[28:31], v8 offset:8512
		ds_read_b128 v[32:35], v8 offset:16896
		ds_read_b128 v[36:39], v8 offset:16960
		ds_read_b128 v[40:43], v8 offset:25344
		ds_read_b128 v[44:47], v8 offset:25408
		ds_read_b64_tr_b16 v[48:49], v9 offset:2016
		ds_read_b64_tr_b16 v[50:51], v9 offset:3072
		ds_read_b64_tr_b16 v[52:53], v9 offset:10464
		ds_read_b64_tr_b16 v[54:55], v9 offset:11520
		ds_read_b64_tr_b16 v[56:57], v9 offset:2080
		ds_read_b64_tr_b16 v[58:59], v9 offset:3136
		ds_read_b64_tr_b16 v[60:61], v9 offset:10528
		ds_read_b64_tr_b16 v[62:63], v9 offset:11584
		ds_read_b64_tr_b16 v[64:65], v9 offset:2144
		ds_read_b64_tr_b16 v[66:67], v9 offset:3200
		ds_read_b64_tr_b16 v[68:69], v9 offset:10592
		ds_read_b64_tr_b16 v[70:71], v9 offset:11648
		ds_read_b64_tr_b16 v[72:73], v9 offset:2208
		ds_read_b64_tr_b16 v[74:75], v9 offset:3264
		ds_read_b64_tr_b16 v[76:77], v9 offset:10656
		ds_read_b64_tr_b16 v[78:79], v9 offset:11712
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v3, s13, v6
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s2, v6
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s14, s14, 0x80
		s_add_i32 s2, s5, s3
		s_setprio 0
		s_barrier
		s_add_u32 s24, s24, 0x100
		s_addc_u32 s25, s25, 0
		s_add_i32 s16, s16, 2
		s_cmp_lt_i32 s16, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[64:65]
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[44:47], v[148:151]
		ds_read_b64_tr_b16 v[48:49], v9 offset:35776
		ds_read_b64_tr_b16 v[50:51], v9 offset:36832
		ds_read_b64_tr_b16 v[52:53], v9 offset:44224
		ds_read_b64_tr_b16 v[54:55], v9 offset:45280
		ds_read_b64_tr_b16 v[56:57], v9 offset:35840
		ds_read_b64_tr_b16 v[58:59], v9 offset:36896
		ds_read_b64_tr_b16 v[60:61], v9 offset:44288
		ds_read_b64_tr_b16 v[62:63], v9 offset:45344
		ds_read_b64_tr_b16 v[64:65], v9 offset:35904
		ds_read_b64_tr_b16 v[66:67], v9 offset:36960
		ds_read_b64_tr_b16 v[68:69], v9 offset:44352
		ds_read_b64_tr_b16 v[70:71], v9 offset:45408
		ds_read_b64_tr_b16 v[72:73], v9 offset:35968
		ds_read_b64_tr_b16 v[74:75], v9 offset:37024
		ds_read_b64_tr_b16 v[76:77], v9 offset:44416
		ds_read_b64_tr_b16 v[78:79], v9 offset:45472
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[16:19], v[152:155]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[16:19], v[156:159]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[16:19], v[160:163]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[44:47], v[204:207]
		ds_read_b128 v[16:19], v8 offset:33792
		ds_read_b128 v[20:23], v8 offset:33856
		ds_read_b128 v[24:27], v8 offset:42240
		ds_read_b128 v[28:31], v8 offset:42304
		ds_read_b128 v[32:35], v8 offset:50688
		ds_read_b128 v[36:39], v8 offset:50752
		ds_read_b128 v[40:43], v8 offset:59136
		ds_read_b128 v[44:47], v8 offset:59200
		ds_read_b64_tr_b16 v[48:49], v9 offset:18912
		ds_read_b64_tr_b16 v[50:51], v9 offset:19968
		ds_read_b64_tr_b16 v[52:53], v9 offset:27360
		ds_read_b64_tr_b16 v[54:55], v9 offset:28416
		ds_read_b64_tr_b16 v[56:57], v9 offset:18976
		ds_read_b64_tr_b16 v[58:59], v9 offset:20032
		ds_read_b64_tr_b16 v[60:61], v9 offset:27424
		ds_read_b64_tr_b16 v[62:63], v9 offset:28480
		ds_read_b64_tr_b16 v[64:65], v9 offset:19040
		ds_read_b64_tr_b16 v[66:67], v9 offset:20096
		ds_read_b64_tr_b16 v[68:69], v9 offset:27488
		ds_read_b64_tr_b16 v[70:71], v9 offset:28544
		ds_read_b64_tr_b16 v[72:73], v9 offset:19104
		ds_read_b64_tr_b16 v[74:75], v9 offset:20160
		ds_read_b64_tr_b16 v[76:77], v9 offset:27552
		ds_read_b64_tr_b16 v[78:79], v9 offset:28608
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[16:19], v[88:91]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[16:19], v[92:95]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[16:19], v[96:99]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[44:47], v[144:147]
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		v_cvt_pk_f16_f32 v14, v92, v93
		v_cvt_pk_f16_f32 v15, v94, v95
		v_cvt_pk_f16_f32 v48, v96, v97
		v_cvt_pk_f16_f32 v49, v98, v99
		v_cvt_pk_f16_f32 v50, v100, v101
		v_cvt_pk_f16_f32 v51, v102, v103
		v_cvt_pk_f16_f32 v56, v104, v105
		v_cvt_pk_f16_f32 v57, v106, v107
		v_cvt_pk_f16_f32 v58, v108, v109
		v_cvt_pk_f16_f32 v59, v110, v111
		v_cvt_pk_f16_f32 v64, v112, v113
		v_cvt_pk_f16_f32 v65, v114, v115
		v_cvt_pk_f16_f32 v66, v116, v117
		v_cvt_pk_f16_f32 v67, v118, v119
		v_cvt_pk_f16_f32 v68, v128, v129
		v_cvt_pk_f16_f32 v69, v130, v131
		v_cvt_pk_f16_f32 v70, v144, v145
		v_cvt_pk_f16_f32 v71, v146, v147
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[44:47], v[148:151]
		ds_read_b64_tr_b16 v[52:53], v9 offset:52672
		ds_read_b64_tr_b16 v[54:55], v9 offset:53728
		ds_read_b64_tr_b16 v[60:61], v9 offset:61120
		v_cvt_pk_f16_f32 v72, v120, v121
		v_cvt_pk_f16_f32 v73, v122, v123
		v_cvt_pk_f16_f32 v74, v124, v125
		v_cvt_pk_f16_f32 v75, v126, v127
		v_cvt_pk_f16_f32 v76, v132, v133
		v_cvt_pk_f16_f32 v77, v134, v135
		v_cvt_pk_f16_f32 v78, v136, v137
		v_cvt_pk_f16_f32 v79, v138, v139
		v_cvt_pk_f16_f32 v80, v140, v141
		v_cvt_pk_f16_f32 v81, v142, v143
		v_cvt_pk_f16_f32 v82, v148, v149
		v_cvt_pk_f16_f32 v83, v150, v151
		ds_read_b64_tr_b16 v[62:63], v9 offset:62176
		ds_read_b64_tr_b16 v[84:85], v9 offset:52736
		ds_read_b64_tr_b16 v[86:87], v9 offset:53792
		ds_read_b64_tr_b16 v[88:89], v9 offset:61184
		ds_read_b64_tr_b16 v[90:91], v9 offset:62240
		ds_read_b64_tr_b16 v[92:93], v9 offset:52800
		ds_read_b64_tr_b16 v[94:95], v9 offset:53856
		ds_read_b64_tr_b16 v[96:97], v9 offset:61248
		ds_read_b64_tr_b16 v[98:99], v9 offset:62304
		ds_read_b64_tr_b16 v[100:101], v9 offset:52864
		ds_read_b64_tr_b16 v[102:103], v9 offset:53920
		ds_read_b64_tr_b16 v[104:105], v9 offset:61312
		ds_read_b64_tr_b16 v[106:107], v9 offset:62368
		v_and_b32_e32 v6, 1, v0
		v_lshrrev_b32_e32 v8, 1, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_and_b32_e32 v8, 1, v11
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v8, v6, v9, v11 bitop3:0x96
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v108, 8
		v_mul_lo_u32 v108, v108, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v109, 16
		v_mul_lo_u32 v109, v109, v1
		v_bitop3_b32 v1, v8, v108, v109 bitop3:0x96
		v_and_b32_e32 v8, 1, v13
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v8
		v_xad_u32 v1, v1, v13, s17
		v_bitop3_b32 v8, 64, v6, v9 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v1, s8
		v_xor_b32_e32 v1, v8, v11
		v_bitop3_b32 v1, v1, v108, v109 bitop3:0x96
		v_xad_u32 v1, v1, v13, s17
		v_xor_b32_e32 v8, 0x80, v6
		v_cmp_lt_i32_e64 s[4:5], v1, s8
		v_xor_b32_e32 v1, v8, v9
		v_xor_b32_e32 v1, v1, v11
		v_bitop3_b32 v1, v1, v108, v109 bitop3:0x96
		v_xad_u32 v1, v1, v13, s17
		v_xor_b32_e32 v6, 0xc0, v6
		v_xor_b32_e32 v6, v6, v9
		v_xor_b32_e32 v6, v6, v11
		v_bitop3_b32 v6, v6, v108, v109 bitop3:0x96
		v_xad_u32 v6, v6, v13, s17
		v_cmp_lt_i32_e64 s[10:11], v1, s8
		v_cmp_lt_i32_e64 s[16:17], v6, s8
		v_and_b32_e32 v1, 1, v5
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v1
		v_and_b32_e32 v1, 1, v10
		v_mov_b32_e32 v6, 8
		v_mul_lo_u32 v6, v6, v1
		v_lshrrev_b32_e32 v0, 6, v0
		v_and_b32_e32 v0, 1, v0
		v_mov_b32_e32 v1, 16
		v_mul_lo_u32 v1, v1, v0
		v_bitop3_b32 v0, v5, v6, v1 bitop3:0x96
		v_add_u32_e32 v8, s28, v0
		v_bitop3_b32 v9, 32, v5, v6 bitop3:0x96
		v_cmp_lt_i32_e64 s[20:21], v8, s9
		v_xor_b32_e32 v8, v9, v1
		v_add_u32_e32 v9, s28, v8
		v_bitop3_b32 v10, 64, v5, v6 bitop3:0x96
		v_cmp_lt_i32_e64 s[24:25], v9, s9
		v_xor_b32_e32 v9, v10, v1
		v_add_u32_e32 v10, s28, v9
		v_xor_b32_e32 v5, 0x60, v5
		v_xor_b32_e32 v5, v5, v6
		v_xor_b32_e32 v1, v5, v1
		v_cmp_lt_i32_e64 s[26:27], v10, s9
		v_add_u32_e32 v5, s28, v1
		s_and_b64 s[32:33], s[2:3], s[20:21]
		v_cmp_lt_i32_e64 s[34:35], v5, s9
		s_and_b64 s[36:37], s[2:3], s[24:25]
		s_and_b64 s[38:39], s[2:3], s[26:27]
		s_and_b64 s[40:41], s[2:3], s[34:35]
		s_and_b64 s[42:43], s[4:5], s[20:21]
		s_and_b64 s[44:45], s[4:5], s[24:25]
		s_and_b64 s[46:47], s[4:5], s[26:27]
		s_and_b64 s[48:49], s[4:5], s[34:35]
		s_and_b64 s[50:51], s[10:11], s[20:21]
		s_and_b64 s[52:53], s[10:11], s[24:25]
		s_and_b64 s[54:55], s[10:11], s[26:27]
		s_and_b64 s[56:57], s[10:11], s[34:35]
		s_and_b64 s[20:21], s[16:17], s[20:21]
		s_and_b64 s[24:25], s[16:17], s[24:25]
		s_and_b64 s[26:27], s[16:17], s[26:27]
		s_and_b64 s[34:35], s[16:17], s[34:35]
		s_mul_i32 s8, s15, s12
		s_lshl_b32 s8, s8, 11
		s_add_i32 s13, s1, s8
		s_mul_i32 s0, s0, s12
		s_lshl_b32 s0, s0, 9
		s_add_i32 s13, s13, s0
		s_mul_i32 s14, s12, s31
		s_lshl_b32 s14, s14, 5
		s_add_i32 s13, s13, s14
		s_add_i32 s13, s13, s19
		v_mul_lo_u32 v5, s12, v7
		v_lshl_add_u32 v6, v5, 1, s13
		v_lshlrev_b32_e32 v4, 4, v4
		v_lshlrev_b32_e32 v7, 3, v12
		v_add3_u32 v6, v6, v4, v7
		v_mov_b32_e32 v10, 0x7fffffff
		v_cndmask_b32_e64 v6, v10, v6, s[32:33]
		s_mov_b32 s60, s6
		s_mov_b32 s61, s7
		s_mov_b32 s62, s22
		s_mov_b32 s63, s23
		buffer_store_dwordx2 v[2:3], v6, s[60:63], 0 offen
		s_add_i32 s6, s13, 64
		v_lshl_add_u32 v2, v5, 1, v4
		v_add3_u32 v3, v7, v2, s6
		v_cndmask_b32_e64 v3, v10, v3, s[36:37]
		buffer_store_dwordx2 v[14:15], v3, s[60:63], 0 offen
		s_add_i32 s6, s13, 0x80
		v_add3_u32 v3, v7, v2, s6
		v_cndmask_b32_e64 v3, v10, v3, s[38:39]
		buffer_store_dwordx2 v[48:49], v3, s[60:63], 0 offen
		s_add_i32 s6, s13, 0xc0
		v_add3_u32 v2, v7, v2, s6
		v_cndmask_b32_e64 v2, v10, v2, s[40:41]
		buffer_store_dwordx2 v[50:51], v2, s[60:63], 0 offen
		s_lshl_b32 s6, s12, 7
		s_add_i32 s6, s1, s6
		s_add_i32 s6, s6, s8
		s_add_i32 s6, s6, s0
		s_add_i32 s6, s6, s14
		s_add_i32 s6, s6, s19
		v_lshl_add_u32 v2, v5, 1, s6
		v_add3_u32 v2, v2, v4, v7
		v_cndmask_b32_e64 v2, v10, v2, s[42:43]
		buffer_store_dwordx2 v[56:57], v2, s[60:63], 0 offen
		s_add_i32 s7, s6, 64
		v_lshl_add_u32 v2, v5, 1, v4
		v_add3_u32 v3, v7, v2, s7
		v_cndmask_b32_e64 v3, v10, v3, s[44:45]
		buffer_store_dwordx2 v[58:59], v3, s[60:63], 0 offen
		s_add_i32 s7, s6, 0x80
		v_add3_u32 v3, v7, v2, s7
		v_cndmask_b32_e64 v3, v10, v3, s[46:47]
		buffer_store_dwordx2 v[64:65], v3, s[60:63], 0 offen
		s_add_i32 s7, s6, 0xc0
		v_add3_u32 v2, v7, v2, s7
		v_cndmask_b32_e64 v2, v10, v2, s[48:49]
		buffer_store_dwordx2 v[66:67], v2, s[60:63], 0 offen
		s_lshl_b32 s7, s12, 8
		s_add_i32 s7, s1, s7
		s_add_i32 s7, s7, s8
		s_add_i32 s7, s7, s0
		s_add_i32 s7, s7, s14
		s_add_i32 s7, s7, s19
		v_lshl_add_u32 v2, v5, 1, s7
		v_add3_u32 v2, v2, v4, v7
		v_cndmask_b32_e64 v2, v10, v2, s[50:51]
		buffer_store_dwordx2 v[72:73], v2, s[60:63], 0 offen
		s_add_i32 s15, s7, 64
		v_lshl_add_u32 v2, v5, 1, v4
		v_add3_u32 v3, v7, v2, s15
		v_cndmask_b32_e64 v3, v10, v3, s[52:53]
		buffer_store_dwordx2 v[74:75], v3, s[60:63], 0 offen
		s_add_i32 s15, s7, 0x80
		v_add3_u32 v3, v7, v2, s15
		v_cndmask_b32_e64 v3, v10, v3, s[54:55]
		buffer_store_dwordx2 v[68:69], v3, s[60:63], 0 offen
		s_add_i32 s15, s7, 0xc0
		v_add3_u32 v2, v7, v2, s15
		v_cndmask_b32_e64 v2, v10, v2, s[56:57]
		buffer_store_dwordx2 v[76:77], v2, s[60:63], 0 offen
		s_mul_i32 s12, 0x180, s12
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s8
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s14
		s_add_i32 s0, s0, s19
		v_lshl_add_u32 v2, v5, 1, s0
		v_add3_u32 v2, v2, v4, v7
		v_cndmask_b32_e64 v2, v10, v2, s[20:21]
		buffer_store_dwordx2 v[78:79], v2, s[60:63], 0 offen
		s_add_i32 s1, s0, 64
		v_lshl_add_u32 v2, v5, 1, v4
		v_add3_u32 v3, v7, v2, s1
		v_cndmask_b32_e64 v3, v10, v3, s[24:25]
		buffer_store_dwordx2 v[80:81], v3, s[60:63], 0 offen
		s_add_i32 s1, s0, 0x80
		v_add3_u32 v3, v7, v2, s1
		v_cndmask_b32_e64 v3, v10, v3, s[26:27]
		buffer_store_dwordx2 v[70:71], v3, s[60:63], 0 offen
		s_add_i32 s1, s0, 0xc0
		v_add3_u32 v2, v7, v2, s1
		v_cndmask_b32_e64 v2, v10, v2, s[34:35]
		buffer_store_dwordx2 v[82:83], v2, s[60:63], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[16:19], v[152:155]
		s_add_i32 s1, s28, 0x80
		v_add_u32_e32 v0, s1, v0
		v_add_u32_e32 v2, s1, v8
		v_cmp_lt_i32_e64 s[14:15], v0, s9
		v_cmp_lt_i32_e64 s[18:19], v2, s9
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[16:19], v[156:159]
		v_add_u32_e32 v0, s1, v9
		v_add_u32_e32 v1, s1, v1
		v_cmp_lt_i32_e64 s[20:21], v0, s9
		v_cmp_lt_i32_e64 s[22:23], v1, s9
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[16:19], v[160:163]
		s_and_b64 s[8:9], s[2:3], s[14:15]
		s_and_b64 s[24:25], s[2:3], s[18:19]
		s_and_b64 s[26:27], s[2:3], s[20:21]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[16:19], v[164:167]
		s_and_b64 s[2:3], s[2:3], s[22:23]
		s_and_b64 s[28:29], s[4:5], s[14:15]
		s_and_b64 s[30:31], s[4:5], s[18:19]
		v_mfma_f32_16x16x32_f16 v[180:183], v[100:103], v[24:27], v[180:183]
		s_and_b64 s[32:33], s[4:5], s[20:21]
		s_and_b64 s[4:5], s[4:5], s[22:23]
		s_and_b64 s[34:35], s[10:11], s[14:15]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[24:27], v[168:171]
		s_and_b64 s[36:37], s[10:11], s[18:19]
		s_and_b64 s[38:39], s[10:11], s[20:21]
		s_and_b64 s[10:11], s[10:11], s[22:23]
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		s_and_b64 s[14:15], s[16:17], s[14:15]
		s_and_b64 s[18:19], s[16:17], s[18:19]
		s_and_b64 s[20:21], s[16:17], s[20:21]
		s_and_b64 s[16:17], s[16:17], s[22:23]
		v_mfma_f32_16x16x32_f16 v[176:179], v[92:95], v[24:27], v[176:179]
		s_add_i32 s1, s13, 0x100
		v_lshl_add_u32 v0, v5, 1, s1
		v_add3_u32 v0, v0, v4, v7
		v_mfma_f32_16x16x32_f16 v[192:195], v[92:95], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[92:95], v[40:43], v[208:211]
		v_cndmask_b32_e64 v0, v10, v0, s[8:9]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[100:103], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[100:103], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[20:23], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[104:107], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[36:39], v[192:195]
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		v_cvt_pk_f16_f32 v8, v156, v157
		v_mfma_f32_16x16x32_f16 v[184:187], v[60:63], v[36:39], v[184:187]
		v_cvt_pk_f16_f32 v9, v158, v159
		v_cvt_pk_f16_f32 v12, v160, v161
		v_cvt_pk_f16_f32 v13, v162, v163
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[36:39], v[188:191]
		v_cvt_pk_f16_f32 v14, v164, v165
		v_cvt_pk_f16_f32 v15, v166, v167
		v_cvt_pk_f16_f32 v16, v168, v169
		v_mfma_f32_16x16x32_f16 v[196:199], v[104:107], v[36:39], v[196:199]
		v_cvt_pk_f16_f32 v17, v170, v171
		v_cvt_pk_f16_f32 v18, v172, v173
		v_cvt_pk_f16_f32 v19, v174, v175
		v_mfma_f32_16x16x32_f16 v[212:215], v[104:107], v[44:47], v[212:215]
		v_cvt_pk_f16_f32 v20, v176, v177
		v_cvt_pk_f16_f32 v21, v178, v179
		v_cvt_pk_f16_f32 v22, v180, v181
		v_mfma_f32_16x16x32_f16 v[200:203], v[60:63], v[44:47], v[200:203]
		v_cvt_pk_f16_f32 v23, v182, v183
		v_cvt_pk_f16_f32 v24, v184, v185
		v_cvt_pk_f16_f32 v25, v186, v187
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[44:47], v[204:207]
		v_cvt_pk_f16_f32 v26, v188, v189
		v_cvt_pk_f16_f32 v27, v190, v191
		v_cvt_pk_f16_f32 v28, v192, v193
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[44:47], v[208:211]
		v_cvt_pk_f16_f32 v29, v194, v195
		v_cvt_pk_f16_f32 v30, v196, v197
		v_cvt_pk_f16_f32 v31, v198, v199
		v_cvt_pk_f16_f32 v32, v200, v201
		v_cvt_pk_f16_f32 v33, v202, v203
		v_cvt_pk_f16_f32 v34, v204, v205
		v_cvt_pk_f16_f32 v35, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[60:63], 0 offen
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		s_add_i32 s1, s13, 0x140
		v_lshl_add_u32 v6, v5, 1, v4
		v_add3_u32 v11, v7, v6, s1
		v_cndmask_b32_e64 v11, v10, v11, s[24:25]
		buffer_store_dwordx2 v[8:9], v11, s[60:63], 0 offen
		s_add_i32 s1, s13, 0x180
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[26:27]
		buffer_store_dwordx2 v[12:13], v8, s[60:63], 0 offen
		s_add_i32 s1, s13, 0x1c0
		v_add3_u32 v6, v7, v6, s1
		v_cndmask_b32_e64 v6, v10, v6, s[2:3]
		buffer_store_dwordx2 v[14:15], v6, s[60:63], 0 offen
		s_add_i32 s1, s6, 0x100
		v_lshl_add_u32 v6, v5, 1, v4
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[28:29]
		buffer_store_dwordx2 v[16:17], v8, s[60:63], 0 offen
		s_add_i32 s1, s6, 0x140
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[30:31]
		buffer_store_dwordx2 v[18:19], v8, s[60:63], 0 offen
		s_add_i32 s1, s6, 0x180
		v_add3_u32 v6, v7, v6, s1
		v_cndmask_b32_e64 v6, v10, v6, s[32:33]
		buffer_store_dwordx2 v[20:21], v6, s[60:63], 0 offen
		s_add_i32 s1, s6, 0x1c0
		v_lshl_add_u32 v6, v5, 1, v4
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[4:5]
		buffer_store_dwordx2 v[22:23], v8, s[60:63], 0 offen
		s_add_i32 s1, s7, 0x100
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[34:35]
		buffer_store_dwordx2 v[24:25], v8, s[60:63], 0 offen
		s_add_i32 s1, s7, 0x140
		v_add3_u32 v6, v7, v6, s1
		v_cndmask_b32_e64 v6, v10, v6, s[36:37]
		buffer_store_dwordx2 v[26:27], v6, s[60:63], 0 offen
		s_add_i32 s1, s7, 0x180
		v_lshl_add_u32 v6, v5, 1, v4
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[38:39]
		buffer_store_dwordx2 v[28:29], v8, s[60:63], 0 offen
		s_add_i32 s1, s7, 0x1c0
		v_add3_u32 v8, v7, v6, s1
		v_cndmask_b32_e64 v8, v10, v8, s[10:11]
		buffer_store_dwordx2 v[30:31], v8, s[60:63], 0 offen
		s_add_i32 s1, s0, 0x100
		v_add3_u32 v6, v7, v6, s1
		v_cndmask_b32_e64 v6, v10, v6, s[14:15]
		buffer_store_dwordx2 v[32:33], v6, s[60:63], 0 offen
		s_add_i32 s1, s0, 0x140
		v_lshl_add_u32 v4, v5, 1, v4
		v_add3_u32 v5, v7, v4, s1
		v_cndmask_b32_e64 v5, v10, v5, s[18:19]
		buffer_store_dwordx2 v[34:35], v5, s[60:63], 0 offen
		s_add_i32 s1, s0, 0x180
		v_add3_u32 v5, v7, v4, s1
		v_cndmask_b32_e64 v5, v10, v5, s[20:21]
		buffer_store_dwordx2 v[0:1], v5, s[60:63], 0 offen
		s_add_i32 s0, s0, 0x1c0
		v_add3_u32 v0, v7, v4, s0
		v_cndmask_b32_e64 v0, v10, v0, s[16:17]
		buffer_store_dwordx2 v[2:3], v0, s[60:63], 0 offen
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
		.amdhsa_next_free_vgpr 216
		.amdhsa_next_free_sgpr 66
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
	.set .Lv9_beyond_hotloop.num_vgpr, 216
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 66
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
    .sgpr_count:     66
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
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
