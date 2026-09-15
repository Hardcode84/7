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
		s_add_i32 s28, s18, s5
		s_add_i32 s28, s28, s13
		v_add_u32_e32 v5, s28, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s29, s1, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s30, s10, 8
		s_add_i32 s31, s30, s5
		s_add_i32 s31, s31, s13
		v_add_u32_e32 v5, s31, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshr_b32 s19, s19, 6
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s32, s10, s5
		s_add_i32 s32, s32, s13
		v_add_u32_e32 v5, s32, v4
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
		s_lshl_b32 s33, s11, 6
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s34, s1, s33
		v_add_u32_e32 v8, s34, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s35, s1, 0x100
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v8, s35, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s33, s35, s33
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v8, s33, v6
		s_mul_i32 s36, s11, 64
		s_mul_i32 s37, 0xc0, s11
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_add_u32_e32 v8, s13, v4
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s38, s5, 0x80
		s_add_i32 s13, s38, s13
		v_add_u32_e32 v4, s13, v4
		v_add_u32_e32 v8, s5, v8
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_add_u32_e32 v4, 0x80, v8
		v_add_u32_e32 v8, s18, v4
		v_add_u32_e32 v9, s30, v4
		v_add_u32_e32 v4, s10, v4
		s_add_i32 m0, m0, 0x2100
		s_lshr_b32 s5, s19, 1
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mul_i32 s10, 0x840, s5
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s13, s36, s36
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v10, 4, v8
		v_lshlrev_b32_e32 v10, 4, v10
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_and_b32_e32 v8, 15, v8
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s11, s11, 7
		v_lshrrev_b32_e32 v9, 3, v8
		v_mov_b32_e32 v11, 0x420
		v_mul_lo_u32 v11, v11, v9
		v_add3_u32 v9, s10, v10, v11
		v_and_b32_e32 v8, 7, v8
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_lshl_add_u32 v4, v8, 7, v9
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s10, s1, s11
		v_add_u32_e32 v8, s10, v6
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_and_b32_e32 v8, 3, v0
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s18, s1, s37
		v_add_u32_e32 v9, s18, v6
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s11, s35, s11
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v9, s11, v6
		s_add_i32 s30, s35, s37
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_add_u32_e32 v9, s30, v6
		s_add_i32 m0, m0, 0x2100
		s_and_b32 s19, s19, 1
		s_lshl_b32 s19, s19, 5
		s_add_i32 s37, s19, 0x10000
		v_lshl_add_u32 v8, v8, 3, s37
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		ds_read_b128 v[12:15], v4
		ds_read_b128 v[16:19], v4 offset:64
		ds_read_b128 v[20:23], v4 offset:8448
		ds_read_b128 v[24:27], v4 offset:8512
		ds_read_b128 v[28:31], v4 offset:16896
		ds_read_b128 v[32:35], v4 offset:16960
		ds_read_b128 v[36:39], v4 offset:25344
		ds_read_b128 v[40:43], v4 offset:25408
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 0x1080
		v_mul_lo_u32 v11, v11, v10
		v_and_b32_e32 v44, 1, v5
		v_mov_b32_e32 v45, 0x840
		v_mul_lo_u32 v45, v45, v44
		v_add3_u32 v8, v8, v11, v45
		v_and_b32_e32 v11, 1, v1
		v_lshl_add_u32 v8, v11, 9, v8
		v_lshrrev_b32_e32 v11, 2, v0
		v_and_b32_e32 v45, 1, v11
		v_lshl_add_u32 v8, v45, 8, v8
		ds_read_b64_tr_b16 v[48:49], v8 offset:2016
		ds_read_b64_tr_b16 v[50:51], v8 offset:3072
		ds_read_b64_tr_b16 v[52:53], v8 offset:10464
		ds_read_b64_tr_b16 v[54:55], v8 offset:11520
		ds_read_b64_tr_b16 v[56:57], v8 offset:2080
		ds_read_b64_tr_b16 v[58:59], v8 offset:3136
		ds_read_b64_tr_b16 v[60:61], v8 offset:10528
		ds_read_b64_tr_b16 v[62:63], v8 offset:11584
		ds_read_b64_tr_b16 v[64:65], v8 offset:2144
		ds_read_b64_tr_b16 v[66:67], v8 offset:3200
		ds_read_b64_tr_b16 v[68:69], v8 offset:10592
		ds_read_b64_tr_b16 v[70:71], v8 offset:11648
		ds_read_b64_tr_b16 v[72:73], v8 offset:2208
		ds_read_b64_tr_b16 v[74:75], v8 offset:3264
		ds_read_b64_tr_b16 v[76:77], v8 offset:10656
		ds_read_b64_tr_b16 v[78:79], v8 offset:11712
		v_lshrrev_b32_e32 v45, 8, v0
		v_cmp_ne_u32_e64 vcc, v45, s16
		v_cmp_eq_u32_e64 s[38:39], v45, s16
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[60:61], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[60:61]
		s_setprio 0
		v_lshl_add_u32 v46, v2, 1, s14
		v_lshl_add_u32 v47, v2, 1, s28
		v_lshl_add_u32 v80, v2, 1, s31
		v_lshl_add_u32 v2, v2, 1, s32
		s_mov_b32 s14, 0x80
		s_mov_b32 s28, s14
		v_add_u32_e32 v81, 0x100, v3
		v_add_u32_e32 v82, v81, v46
		v_add_u32_e32 v83, v81, v47
		v_add_u32_e32 v84, v81, v80
		v_add_u32_e32 v81, v81, v2
		v_add_u32_e32 v3, 0x180, v3
		v_add_u32_e32 v46, v3, v46
		v_add_u32_e32 v47, v3, v47
		v_add_u32_e32 v80, v3, v80
		v_add_u32_e32 v2, v3, v2
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_lshl_b32 s2, s13, 1
		s_lshl_b32 s3, s36, 1
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
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[40:43], v[148:151]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b64_tr_b16 v[48:49], v8 offset:35776
		ds_read_b64_tr_b16 v[50:51], v8 offset:36832
		ds_read_b64_tr_b16 v[52:53], v8 offset:44224
		ds_read_b64_tr_b16 v[54:55], v8 offset:45280
		ds_read_b64_tr_b16 v[56:57], v8 offset:35840
		ds_read_b64_tr_b16 v[58:59], v8 offset:36896
		ds_read_b64_tr_b16 v[60:61], v8 offset:44288
		ds_read_b64_tr_b16 v[62:63], v8 offset:45344
		ds_read_b64_tr_b16 v[64:65], v8 offset:35904
		ds_read_b64_tr_b16 v[66:67], v8 offset:36960
		ds_read_b64_tr_b16 v[68:69], v8 offset:44352
		ds_read_b64_tr_b16 v[70:71], v8 offset:45408
		ds_read_b64_tr_b16 v[72:73], v8 offset:35968
		ds_read_b64_tr_b16 v[74:75], v8 offset:37024
		ds_read_b64_tr_b16 v[76:77], v8 offset:44416
		ds_read_b64_tr_b16 v[78:79], v8 offset:45472
		s_mov_b32 m0, s4
		s_add_i32 s13, s2, s3
		buffer_load_dwordx4 v82, s[24:27], 0 offen lds
		s_add_i32 s14, s35, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s31, s1, s2
		buffer_load_dwordx4 v83, s[24:27], 0 offen lds
		s_add_i32 s32, s34, s2
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s31, v6
		buffer_load_dwordx4 v84, s[24:27], 0 offen lds
		v_add_u32_e32 v85, s32, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s14, v6
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[40:43], v[204:207]
		s_setprio 1
		s_barrier
		ds_read_b128 v[12:15], v4 offset:33792
		ds_read_b128 v[16:19], v4 offset:33856
		ds_read_b128 v[20:23], v4 offset:42240
		ds_read_b128 v[24:27], v4 offset:42304
		ds_read_b128 v[28:31], v4 offset:50688
		ds_read_b128 v[32:35], v4 offset:50752
		ds_read_b128 v[36:39], v4 offset:59136
		ds_read_b128 v[40:43], v4 offset:59200
		ds_read_b64_tr_b16 v[48:49], v8 offset:18912
		ds_read_b64_tr_b16 v[50:51], v8 offset:19968
		ds_read_b64_tr_b16 v[52:53], v8 offset:27360
		ds_read_b64_tr_b16 v[54:55], v8 offset:28416
		ds_read_b64_tr_b16 v[56:57], v8 offset:18976
		ds_read_b64_tr_b16 v[58:59], v8 offset:20032
		ds_read_b64_tr_b16 v[60:61], v8 offset:27424
		ds_read_b64_tr_b16 v[62:63], v8 offset:28480
		ds_read_b64_tr_b16 v[64:65], v8 offset:19040
		ds_read_b64_tr_b16 v[66:67], v8 offset:20096
		ds_read_b64_tr_b16 v[68:69], v8 offset:27488
		ds_read_b64_tr_b16 v[70:71], v8 offset:28544
		ds_read_b64_tr_b16 v[72:73], v8 offset:19104
		ds_read_b64_tr_b16 v[74:75], v8 offset:20160
		ds_read_b64_tr_b16 v[76:77], v8 offset:27552
		ds_read_b64_tr_b16 v[78:79], v8 offset:28608
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s14, s33, s2
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s14, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[40:43], v[148:151]
		s_setprio 1
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v8 offset:52672
		ds_read_b64_tr_b16 v[50:51], v8 offset:53728
		ds_read_b64_tr_b16 v[52:53], v8 offset:61120
		ds_read_b64_tr_b16 v[54:55], v8 offset:62176
		ds_read_b64_tr_b16 v[56:57], v8 offset:52736
		ds_read_b64_tr_b16 v[58:59], v8 offset:53792
		ds_read_b64_tr_b16 v[60:61], v8 offset:61184
		ds_read_b64_tr_b16 v[62:63], v8 offset:62240
		ds_read_b64_tr_b16 v[64:65], v8 offset:52800
		ds_read_b64_tr_b16 v[66:67], v8 offset:53856
		ds_read_b64_tr_b16 v[68:69], v8 offset:61248
		ds_read_b64_tr_b16 v[70:71], v8 offset:62304
		ds_read_b64_tr_b16 v[72:73], v8 offset:52864
		ds_read_b64_tr_b16 v[74:75], v8 offset:53920
		ds_read_b64_tr_b16 v[76:77], v8 offset:61312
		ds_read_b64_tr_b16 v[78:79], v8 offset:62368
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s14, s11, s2
		buffer_load_dwordx4 v46, s[24:27], 0 offen lds
		s_add_i32 s31, s10, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s32, s18, s2
		buffer_load_dwordx4 v47, s[24:27], 0 offen lds
		v_add_u32_e32 v3, s31, v6
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v85, s32, v6
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s14, v6
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[40:43], v[204:207]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[12:15], v4
		ds_read_b128 v[16:19], v4 offset:64
		ds_read_b128 v[20:23], v4 offset:8448
		ds_read_b128 v[24:27], v4 offset:8512
		ds_read_b128 v[28:31], v4 offset:16896
		ds_read_b128 v[32:35], v4 offset:16960
		ds_read_b128 v[36:39], v4 offset:25344
		ds_read_b128 v[40:43], v4 offset:25408
		ds_read_b64_tr_b16 v[48:49], v8 offset:2016
		ds_read_b64_tr_b16 v[50:51], v8 offset:3072
		ds_read_b64_tr_b16 v[52:53], v8 offset:10464
		ds_read_b64_tr_b16 v[54:55], v8 offset:11520
		ds_read_b64_tr_b16 v[56:57], v8 offset:2080
		ds_read_b64_tr_b16 v[58:59], v8 offset:3136
		ds_read_b64_tr_b16 v[60:61], v8 offset:10528
		ds_read_b64_tr_b16 v[62:63], v8 offset:11584
		ds_read_b64_tr_b16 v[64:65], v8 offset:2144
		ds_read_b64_tr_b16 v[66:67], v8 offset:3200
		ds_read_b64_tr_b16 v[68:69], v8 offset:10592
		ds_read_b64_tr_b16 v[70:71], v8 offset:11648
		ds_read_b64_tr_b16 v[72:73], v8 offset:2208
		ds_read_b64_tr_b16 v[74:75], v8 offset:3264
		ds_read_b64_tr_b16 v[76:77], v8 offset:10656
		ds_read_b64_tr_b16 v[78:79], v8 offset:11712
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s2, s30, s2
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s2, v6
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s28, s28, 0x80
		s_add_i32 s2, s13, s3
		s_setprio 0
		s_barrier
		s_add_u32 s24, s24, 0x100
		s_addc_u32 s25, s25, 0
		s_add_i32 s16, s16, 2
		s_cmp_lt_i32 s16, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[60:61], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[60:61]
		s_mov_b32 s24, s6
		s_mov_b32 s25, s7
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[40:43], v[148:151]
		ds_read_b64_tr_b16 v[48:49], v8 offset:35776
		ds_read_b64_tr_b16 v[50:51], v8 offset:36832
		ds_read_b64_tr_b16 v[52:53], v8 offset:44224
		ds_read_b64_tr_b16 v[54:55], v8 offset:45280
		ds_read_b64_tr_b16 v[56:57], v8 offset:35840
		ds_read_b64_tr_b16 v[58:59], v8 offset:36896
		ds_read_b64_tr_b16 v[60:61], v8 offset:44288
		ds_read_b64_tr_b16 v[62:63], v8 offset:45344
		ds_read_b64_tr_b16 v[64:65], v8 offset:35904
		ds_read_b64_tr_b16 v[66:67], v8 offset:36960
		ds_read_b64_tr_b16 v[68:69], v8 offset:44352
		ds_read_b64_tr_b16 v[70:71], v8 offset:45408
		ds_read_b64_tr_b16 v[72:73], v8 offset:35968
		ds_read_b64_tr_b16 v[74:75], v8 offset:37024
		ds_read_b64_tr_b16 v[76:77], v8 offset:44416
		ds_read_b64_tr_b16 v[78:79], v8 offset:45472
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[12:15], v[152:155]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[12:15], v[156:159]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[12:15], v[160:163]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[56:59], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[56:59], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[56:59], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[16:19], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[40:43], v[204:207]
		ds_read_b128 v[12:15], v4 offset:33792
		ds_read_b128 v[16:19], v4 offset:33856
		ds_read_b128 v[20:23], v4 offset:42240
		ds_read_b128 v[24:27], v4 offset:42304
		ds_read_b128 v[28:31], v4 offset:50688
		ds_read_b128 v[32:35], v4 offset:50752
		ds_read_b128 v[36:39], v4 offset:59136
		ds_read_b128 v[40:43], v4 offset:59200
		ds_read_b64_tr_b16 v[48:49], v8 offset:18912
		ds_read_b64_tr_b16 v[50:51], v8 offset:19968
		ds_read_b64_tr_b16 v[52:53], v8 offset:27360
		ds_read_b64_tr_b16 v[54:55], v8 offset:28416
		ds_read_b64_tr_b16 v[56:57], v8 offset:18976
		ds_read_b64_tr_b16 v[58:59], v8 offset:20032
		ds_read_b64_tr_b16 v[60:61], v8 offset:27424
		ds_read_b64_tr_b16 v[62:63], v8 offset:28480
		ds_read_b64_tr_b16 v[64:65], v8 offset:19040
		ds_read_b64_tr_b16 v[66:67], v8 offset:20096
		ds_read_b64_tr_b16 v[68:69], v8 offset:27488
		ds_read_b64_tr_b16 v[70:71], v8 offset:28544
		ds_read_b64_tr_b16 v[72:73], v8 offset:19104
		ds_read_b64_tr_b16 v[74:75], v8 offset:20160
		ds_read_b64_tr_b16 v[76:77], v8 offset:27552
		ds_read_b64_tr_b16 v[78:79], v8 offset:28608
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[12:15], v[88:91]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[12:15], v[92:95]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[12:15], v[96:99]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[16:19], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[40:43], v[144:147]
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		v_cvt_pk_f16_f32 v46, v92, v93
		v_cvt_pk_f16_f32 v47, v94, v95
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
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[40:43], v[148:151]
		ds_read_b64_tr_b16 v[52:53], v8 offset:52672
		ds_read_b64_tr_b16 v[54:55], v8 offset:53728
		ds_read_b64_tr_b16 v[60:61], v8 offset:61120
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
		ds_read_b64_tr_b16 v[62:63], v8 offset:62176
		ds_read_b64_tr_b16 v[84:85], v8 offset:52736
		ds_read_b64_tr_b16 v[86:87], v8 offset:53792
		ds_read_b64_tr_b16 v[88:89], v8 offset:61184
		ds_read_b64_tr_b16 v[90:91], v8 offset:62240
		ds_read_b64_tr_b16 v[92:93], v8 offset:52800
		ds_read_b64_tr_b16 v[94:95], v8 offset:53856
		ds_read_b64_tr_b16 v[96:97], v8 offset:61248
		ds_read_b64_tr_b16 v[98:99], v8 offset:62304
		ds_read_b64_tr_b16 v[100:101], v8 offset:52864
		ds_read_b64_tr_b16 v[102:103], v8 offset:53920
		ds_read_b64_tr_b16 v[104:105], v8 offset:61312
		ds_read_b64_tr_b16 v[106:107], v8 offset:62368
		v_and_b32_e32 v4, 1, v0
		v_lshrrev_b32_e32 v6, 1, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v6
		v_and_b32_e32 v6, 1, v11
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v6
		v_bitop3_b32 v6, v4, v8, v11 bitop3:0x96
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v108, 8
		v_mul_lo_u32 v108, v108, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v109, 16
		v_mul_lo_u32 v109, v109, v1
		v_bitop3_b32 v1, v6, v108, v109 bitop3:0x96
		v_and_b32_e32 v6, 1, v45
		v_mov_b32_e32 v45, 32
		v_mul_lo_u32 v45, v45, v6
		v_xad_u32 v1, v1, v45, s17
		v_bitop3_b32 v6, 64, v4, v8 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v1, s8
		v_xor_b32_e32 v1, v6, v11
		v_bitop3_b32 v1, v1, v108, v109 bitop3:0x96
		v_xad_u32 v1, v1, v45, s17
		v_xor_b32_e32 v6, 0x80, v4
		v_cmp_lt_i32_e64 s[6:7], v1, s8
		v_xor_b32_e32 v1, v6, v8
		v_xor_b32_e32 v1, v1, v11
		v_bitop3_b32 v1, v1, v108, v109 bitop3:0x96
		v_xad_u32 v1, v1, v45, s17
		v_xor_b32_e32 v4, 0xc0, v4
		v_xor_b32_e32 v4, v4, v8
		v_xor_b32_e32 v4, v4, v11
		v_bitop3_b32 v4, v4, v108, v109 bitop3:0x96
		v_xad_u32 v4, v4, v45, s17
		v_cmp_lt_i32_e64 s[10:11], v1, s8
		v_cmp_lt_i32_e64 s[16:17], v4, s8
		v_and_b32_e32 v1, 1, v5
		v_mov_b32_e32 v4, 4
		v_mul_lo_u32 v4, v4, v1
		v_and_b32_e32 v1, 1, v9
		v_mov_b32_e32 v5, 8
		v_mul_lo_u32 v5, v5, v1
		v_lshrrev_b32_e32 v0, 6, v0
		v_and_b32_e32 v0, 1, v0
		v_mov_b32_e32 v1, 16
		v_mul_lo_u32 v1, v1, v0
		v_bitop3_b32 v0, v4, v5, v1 bitop3:0x96
		v_add_u32_e32 v6, s29, v0
		v_bitop3_b32 v8, 32, v4, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[20:21], v6, s9
		v_xor_b32_e32 v6, v8, v1
		v_add_u32_e32 v8, s29, v6
		v_bitop3_b32 v9, 64, v4, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[22:23], v8, s9
		v_xor_b32_e32 v8, v9, v1
		v_add_u32_e32 v9, s29, v8
		v_xor_b32_e32 v4, 0x60, v4
		v_xor_b32_e32 v4, v4, v5
		v_xor_b32_e32 v1, v4, v1
		v_cmp_lt_i32_e64 s[30:31], v9, s9
		v_add_u32_e32 v4, s29, v1
		s_and_b64 s[32:33], s[2:3], s[20:21]
		v_cmp_lt_i32_e64 s[36:37], v4, s9
		s_and_b64 s[38:39], s[2:3], s[22:23]
		s_and_b64 s[40:41], s[2:3], s[30:31]
		s_and_b64 s[42:43], s[2:3], s[36:37]
		s_and_b64 s[44:45], s[6:7], s[20:21]
		s_and_b64 s[46:47], s[6:7], s[22:23]
		s_and_b64 s[48:49], s[6:7], s[30:31]
		s_and_b64 s[50:51], s[6:7], s[36:37]
		s_and_b64 s[52:53], s[10:11], s[20:21]
		s_and_b64 s[54:55], s[10:11], s[22:23]
		s_and_b64 s[56:57], s[10:11], s[30:31]
		s_and_b64 s[58:59], s[10:11], s[36:37]
		s_and_b64 s[20:21], s[16:17], s[20:21]
		s_and_b64 s[22:23], s[16:17], s[22:23]
		s_and_b64 s[30:31], s[16:17], s[30:31]
		s_and_b64 s[36:37], s[16:17], s[36:37]
		s_mul_i32 s4, s15, s12
		s_lshl_b32 s4, s4, 11
		s_add_i32 s8, s1, s4
		s_mul_i32 s0, s0, s12
		s_lshl_b32 s0, s0, 9
		s_add_i32 s8, s8, s0
		s_mul_i32 s5, s12, s5
		s_lshl_b32 s5, s5, 5
		s_add_i32 s8, s8, s5
		s_add_i32 s8, s8, s19
		v_mul_lo_u32 v4, s12, v7
		v_lshl_add_u32 v5, v4, 1, s8
		v_lshl_add_u32 v5, v10, 4, v5
		v_lshl_add_u32 v5, v44, 3, v5
		s_and_saveexec_b64 s[60:61], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_2
		buffer_store_dwordx2 v[2:3], v5, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_2:
		s_andn2_b64 exec, s[60:61], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_2
.Lv9_beyond_hotloop.exec_endif_2:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s1, 64
		s_add_i32 s13, s8, s4
		s_add_i32 s13, s13, s0
		s_add_i32 s13, s13, s5
		s_add_i32 s13, s13, s19
		v_lshl_add_u32 v2, v4, 1, s13
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_3
		buffer_store_dwordx2 v[46:47], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_3:
		s_andn2_b64 exec, s[60:61], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_3
.Lv9_beyond_hotloop.exec_endif_3:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s13, s1, 0x80
		s_add_i32 s14, s13, s4
		s_add_i32 s14, s14, s0
		s_add_i32 s14, s14, s5
		s_add_i32 s14, s14, s19
		v_lshl_add_u32 v2, v4, 1, s14
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_4
		buffer_store_dwordx2 v[48:49], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_4:
		s_andn2_b64 exec, s[60:61], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_4
.Lv9_beyond_hotloop.exec_endif_4:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s14, s1, 0xc0
		s_add_i32 s15, s14, s4
		s_add_i32 s15, s15, s0
		s_add_i32 s15, s15, s5
		s_add_i32 s15, s15, s19
		v_lshl_add_u32 v2, v4, 1, s15
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_5
		buffer_store_dwordx2 v[50:51], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_5:
		s_andn2_b64 exec, s[60:61], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_5
.Lv9_beyond_hotloop.exec_endif_5:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s15, s12, 7
		s_add_i32 s18, s1, s15
		s_add_i32 s18, s18, s4
		s_add_i32 s18, s18, s0
		s_add_i32 s18, s18, s5
		s_add_i32 s18, s18, s19
		v_lshl_add_u32 v2, v4, 1, s18
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_6
		buffer_store_dwordx2 v[56:57], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_6:
		s_andn2_b64 exec, s[60:61], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_6
.Lv9_beyond_hotloop.exec_endif_6:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s18, s8, s15
		s_add_i32 s18, s18, s4
		s_add_i32 s18, s18, s0
		s_add_i32 s18, s18, s5
		s_add_i32 s18, s18, s19
		v_lshl_add_u32 v2, v4, 1, s18
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_7
		buffer_store_dwordx2 v[58:59], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_7:
		s_andn2_b64 exec, s[60:61], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_7
.Lv9_beyond_hotloop.exec_endif_7:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s18, s13, s15
		s_add_i32 s18, s18, s4
		s_add_i32 s18, s18, s0
		s_add_i32 s18, s18, s5
		s_add_i32 s18, s18, s19
		v_lshl_add_u32 v2, v4, 1, s18
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_8
		buffer_store_dwordx2 v[64:65], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_8:
		s_andn2_b64 exec, s[60:61], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_8
.Lv9_beyond_hotloop.exec_endif_8:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s18, s14, s15
		s_add_i32 s18, s18, s4
		s_add_i32 s18, s18, s0
		s_add_i32 s18, s18, s5
		s_add_i32 s18, s18, s19
		v_lshl_add_u32 v2, v4, 1, s18
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_9
		buffer_store_dwordx2 v[66:67], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_9:
		s_andn2_b64 exec, s[60:61], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_9
.Lv9_beyond_hotloop.exec_endif_9:
		s_mov_b64 exec, s[60:61]
		s_lshl_b32 s18, s12, 8
		s_add_i32 s28, s1, s18
		s_add_i32 s28, s28, s4
		s_add_i32 s28, s28, s0
		s_add_i32 s28, s28, s5
		s_add_i32 s28, s28, s19
		v_lshl_add_u32 v2, v4, 1, s28
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_10
		buffer_store_dwordx2 v[72:73], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_10:
		s_andn2_b64 exec, s[60:61], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_10
.Lv9_beyond_hotloop.exec_endif_10:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s28, s8, s18
		s_add_i32 s28, s28, s4
		s_add_i32 s28, s28, s0
		s_add_i32 s28, s28, s5
		s_add_i32 s28, s28, s19
		v_lshl_add_u32 v2, v4, 1, s28
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_11
		buffer_store_dwordx2 v[74:75], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_11:
		s_andn2_b64 exec, s[60:61], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_11
.Lv9_beyond_hotloop.exec_endif_11:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s28, s13, s18
		s_add_i32 s28, s28, s4
		s_add_i32 s28, s28, s0
		s_add_i32 s28, s28, s5
		s_add_i32 s28, s28, s19
		v_lshl_add_u32 v2, v4, 1, s28
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_12
		buffer_store_dwordx2 v[68:69], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_12:
		s_andn2_b64 exec, s[60:61], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_12
.Lv9_beyond_hotloop.exec_endif_12:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s28, s14, s18
		s_add_i32 s28, s28, s4
		s_add_i32 s28, s28, s0
		s_add_i32 s28, s28, s5
		s_add_i32 s28, s28, s19
		v_lshl_add_u32 v2, v4, 1, s28
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_13
		buffer_store_dwordx2 v[76:77], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_13:
		s_andn2_b64 exec, s[60:61], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_13
.Lv9_beyond_hotloop.exec_endif_13:
		s_mov_b64 exec, s[60:61]
		s_mul_i32 s12, 0x180, s12
		s_add_i32 s28, s1, s12
		s_add_i32 s28, s28, s4
		s_add_i32 s28, s28, s0
		s_add_i32 s28, s28, s5
		s_add_i32 s28, s28, s19
		v_lshl_add_u32 v2, v4, 1, s28
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_14
		buffer_store_dwordx2 v[78:79], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_14:
		s_andn2_b64 exec, s[60:61], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_14
.Lv9_beyond_hotloop.exec_endif_14:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s8, s12
		s_add_i32 s8, s8, s4
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s5
		s_add_i32 s8, s8, s19
		v_lshl_add_u32 v2, v4, 1, s8
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_15
		buffer_store_dwordx2 v[80:81], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_15:
		s_andn2_b64 exec, s[60:61], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_15
.Lv9_beyond_hotloop.exec_endif_15:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s13, s12
		s_add_i32 s8, s8, s4
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s5
		s_add_i32 s8, s8, s19
		v_lshl_add_u32 v2, v4, 1, s8
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_16
		buffer_store_dwordx2 v[70:71], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_16:
		s_andn2_b64 exec, s[60:61], s[30:31]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_16
.Lv9_beyond_hotloop.exec_endif_16:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s14, s12
		s_add_i32 s8, s8, s4
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s5
		s_add_i32 s8, s8, s19
		v_lshl_add_u32 v2, v4, 1, s8
		v_lshl_add_u32 v2, v10, 4, v2
		v_lshl_add_u32 v2, v44, 3, v2
		s_and_saveexec_b64 s[60:61], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_17
		buffer_store_dwordx2 v[82:83], v2, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_17:
		s_andn2_b64 exec, s[60:61], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_17
.Lv9_beyond_hotloop.exec_endif_17:
		s_mov_b64 exec, s[60:61]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[12:15], v[152:155]
		s_add_i32 s8, s29, 0x80
		v_add_u32_e32 v0, s8, v0
		v_add_u32_e32 v2, s8, v6
		v_cmp_lt_i32_e64 s[20:21], v0, s9
		v_cmp_lt_i32_e64 s[22:23], v2, s9
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[12:15], v[156:159]
		v_add_u32_e32 v0, s8, v8
		v_add_u32_e32 v1, s8, v1
		v_cmp_lt_i32_e64 s[28:29], v0, s9
		v_cmp_lt_i32_e64 s[30:31], v1, s9
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[12:15], v[160:163]
		s_and_b64 s[8:9], s[2:3], s[20:21]
		s_and_b64 s[32:33], s[2:3], s[22:23]
		s_and_b64 s[36:37], s[2:3], s[28:29]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[12:15], v[164:167]
		s_and_b64 s[2:3], s[2:3], s[30:31]
		s_and_b64 s[38:39], s[6:7], s[20:21]
		s_and_b64 s[40:41], s[6:7], s[22:23]
		v_mfma_f32_16x16x32_f16 v[180:183], v[100:103], v[20:23], v[180:183]
		s_and_b64 s[42:43], s[6:7], s[28:29]
		s_and_b64 s[6:7], s[6:7], s[30:31]
		s_and_b64 s[44:45], s[10:11], s[20:21]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[20:23], v[168:171]
		s_and_b64 s[46:47], s[10:11], s[22:23]
		s_and_b64 s[48:49], s[10:11], s[28:29]
		s_and_b64 s[10:11], s[10:11], s[30:31]
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[20:23], v[172:175]
		s_and_b64 s[20:21], s[16:17], s[20:21]
		s_and_b64 s[22:23], s[16:17], s[22:23]
		s_and_b64 s[28:29], s[16:17], s[28:29]
		s_and_b64 s[16:17], s[16:17], s[30:31]
		v_mfma_f32_16x16x32_f16 v[176:179], v[92:95], v[20:23], v[176:179]
		s_add_i32 s13, s35, s4
		s_add_i32 s13, s13, s0
		s_add_i32 s13, s13, s5
		v_mfma_f32_16x16x32_f16 v[192:195], v[92:95], v[28:31], v[192:195]
		s_add_i32 s13, s13, s19
		v_lshl_add_u32 v0, v4, 1, s13
		v_lshl_add_u32 v0, v10, 4, v0
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[28:31], v[184:187]
		v_lshl_add_u32 v0, v44, 3, v0
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[100:103], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[100:103], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[200:203], v[52:55], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[92:95], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[16:19], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[164:167], v[104:107], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[104:107], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[32:35], v[192:195]
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		v_cvt_pk_f16_f32 v6, v156, v157
		v_mfma_f32_16x16x32_f16 v[184:187], v[60:63], v[32:35], v[184:187]
		v_cvt_pk_f16_f32 v7, v158, v159
		v_cvt_pk_f16_f32 v8, v160, v161
		v_cvt_pk_f16_f32 v9, v162, v163
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[32:35], v[188:191]
		v_cvt_pk_f16_f32 v12, v164, v165
		v_cvt_pk_f16_f32 v13, v166, v167
		v_cvt_pk_f16_f32 v14, v168, v169
		v_mfma_f32_16x16x32_f16 v[196:199], v[104:107], v[32:35], v[196:199]
		v_cvt_pk_f16_f32 v15, v170, v171
		v_cvt_pk_f16_f32 v16, v172, v173
		v_cvt_pk_f16_f32 v17, v174, v175
		v_mfma_f32_16x16x32_f16 v[212:215], v[104:107], v[40:43], v[212:215]
		v_cvt_pk_f16_f32 v18, v176, v177
		v_cvt_pk_f16_f32 v19, v178, v179
		v_cvt_pk_f16_f32 v20, v180, v181
		v_mfma_f32_16x16x32_f16 v[200:203], v[60:63], v[40:43], v[200:203]
		v_cvt_pk_f16_f32 v21, v182, v183
		v_cvt_pk_f16_f32 v22, v184, v185
		v_cvt_pk_f16_f32 v23, v186, v187
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[40:43], v[204:207]
		v_cvt_pk_f16_f32 v24, v188, v189
		v_cvt_pk_f16_f32 v25, v190, v191
		v_cvt_pk_f16_f32 v26, v192, v193
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[40:43], v[208:211]
		v_cvt_pk_f16_f32 v27, v194, v195
		v_cvt_pk_f16_f32 v28, v196, v197
		v_cvt_pk_f16_f32 v29, v198, v199
		v_cvt_pk_f16_f32 v30, v200, v201
		v_cvt_pk_f16_f32 v31, v202, v203
		v_cvt_pk_f16_f32 v32, v204, v205
		v_cvt_pk_f16_f32 v33, v206, v207
		v_cvt_pk_f16_f32 v34, v212, v213
		v_cvt_pk_f16_f32 v36, v208, v209
		v_cvt_pk_f16_f32 v37, v210, v211
		v_cvt_pk_f16_f32 v35, v214, v215
		s_and_saveexec_b64 s[60:61], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_18
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_18:
		s_andn2_b64 exec, s[60:61], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_18
.Lv9_beyond_hotloop.exec_endif_18:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s8, s1, 0x140
		s_add_i32 s9, s8, s4
		s_add_i32 s9, s9, s0
		s_add_i32 s9, s9, s5
		s_add_i32 s9, s9, s19
		v_lshl_add_u32 v0, v4, 1, s9
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_19
		buffer_store_dwordx2 v[6:7], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_19:
		s_andn2_b64 exec, s[60:61], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_19
.Lv9_beyond_hotloop.exec_endif_19:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s9, s1, 0x180
		s_add_i32 s13, s9, s4
		s_add_i32 s13, s13, s0
		s_add_i32 s13, s13, s5
		s_add_i32 s13, s13, s19
		v_lshl_add_u32 v0, v4, 1, s13
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_20
		buffer_store_dwordx2 v[8:9], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_20:
		s_andn2_b64 exec, s[60:61], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_20
.Lv9_beyond_hotloop.exec_endif_20:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s1, s1, 0x1c0
		s_add_i32 s13, s1, s4
		s_add_i32 s13, s13, s0
		s_add_i32 s13, s13, s5
		s_add_i32 s13, s13, s19
		v_lshl_add_u32 v0, v4, 1, s13
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_21
		buffer_store_dwordx2 v[12:13], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_21:
		s_andn2_b64 exec, s[60:61], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_21
.Lv9_beyond_hotloop.exec_endif_21:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s35, s15
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_22
		buffer_store_dwordx2 v[14:15], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_22:
		s_andn2_b64 exec, s[60:61], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_22
.Lv9_beyond_hotloop.exec_endif_22:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s8, s15
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_23
		buffer_store_dwordx2 v[16:17], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_23:
		s_andn2_b64 exec, s[60:61], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_23
.Lv9_beyond_hotloop.exec_endif_23:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s9, s15
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_24
		buffer_store_dwordx2 v[18:19], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_24:
		s_andn2_b64 exec, s[60:61], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_24
.Lv9_beyond_hotloop.exec_endif_24:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s1, s15
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_25
		buffer_store_dwordx2 v[20:21], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_25:
		s_andn2_b64 exec, s[60:61], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_25
.Lv9_beyond_hotloop.exec_endif_25:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s35, s18
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_26
		buffer_store_dwordx2 v[22:23], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_26:
		s_andn2_b64 exec, s[60:61], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_26
.Lv9_beyond_hotloop.exec_endif_26:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s8, s18
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_27
		buffer_store_dwordx2 v[24:25], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_27:
		s_andn2_b64 exec, s[60:61], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_27
.Lv9_beyond_hotloop.exec_endif_27:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s9, s18
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_28
		buffer_store_dwordx2 v[26:27], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_28:
		s_andn2_b64 exec, s[60:61], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_28
.Lv9_beyond_hotloop.exec_endif_28:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s1, s18
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_29
		buffer_store_dwordx2 v[28:29], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_29:
		s_andn2_b64 exec, s[60:61], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_29
.Lv9_beyond_hotloop.exec_endif_29:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s35, s12
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_30
		buffer_store_dwordx2 v[30:31], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_30:
		s_andn2_b64 exec, s[60:61], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_30
.Lv9_beyond_hotloop.exec_endif_30:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s8, s12
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_31
		buffer_store_dwordx2 v[32:33], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_31:
		s_andn2_b64 exec, s[60:61], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_31
.Lv9_beyond_hotloop.exec_endif_31:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s2, s9, s12
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s19
		v_lshl_add_u32 v0, v4, 1, s2
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_32
		buffer_store_dwordx2 v[36:37], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_32:
		s_andn2_b64 exec, s[60:61], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_32
.Lv9_beyond_hotloop.exec_endif_32:
		s_mov_b64 exec, s[60:61]
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s4
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s5
		s_add_i32 s0, s0, s19
		v_lshl_add_u32 v0, v4, 1, s0
		v_lshl_add_u32 v0, v10, 4, v0
		v_lshl_add_u32 v0, v44, 3, v0
		s_and_saveexec_b64 s[60:61], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_33
		buffer_store_dwordx2 v[34:35], v0, s[24:27], 0 offen
.Lv9_beyond_hotloop.exec_else_33:
		s_andn2_b64 exec, s[60:61], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_33
.Lv9_beyond_hotloop.exec_endif_33:
		s_mov_b64 exec, s[60:61]
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
		.amdhsa_next_free_sgpr 62
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
	.set .Lv9_beyond_hotloop.numbered_sgpr, 62
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
    .sgpr_count:     62
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
