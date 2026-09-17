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
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s13, v0
		s_lshr_b32 s13, s13, 6
		s_mul_i32 s13, 0x420, s13
		s_mov_b32 m0, s13
		v_lshrrev_b32_e32 v1, 3, v0
		v_mul_lo_u32 v2, s10, v1
		v_and_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 4, v3
		v_lshl_add_u32 v4, v2, 1, v3
		s_mul_i32 s14, s15, s10
		s_lshl_b32 s14, s14, 11
		s_mul_i32 s18, s0, s10
		s_lshl_b32 s18, s18, 9
		s_add_i32 s20, s14, s18
		v_add_u32_e32 v5, s20, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s17, s17, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s21, s10, 7
		s_add_i32 s21, s21, s14
		s_add_i32 s21, s21, s18
		v_add_u32_e32 v5, s21, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_mul_i32 s32, s1, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s33, s10, 8
		s_add_i32 s33, s33, s14
		s_add_i32 s33, s33, s18
		v_add_u32_e32 v5, s33, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_lshr_b32 s19, s19, 6
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s10, s10, s14
		s_add_i32 s10, s10, s18
		v_add_u32_e32 v5, s10, v4
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_mul_lo_u32 v5, s11, v1
		s_add_i32 m0, m0, 0xa4e0
		v_lshl_add_u32 v6, v5, 1, v3
		s_mul_i32 s14, s1, s11
		s_lshl_b32 s14, s14, 9
		v_add_u32_e32 v7, s14, v6
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_lshl_b32 s18, s11, 7
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s18, s18, s14
		v_add_u32_e32 v7, s18, v6
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_lshl_b32 s34, s11, 8
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s34, s34, s14
		v_add_u32_e32 v7, s34, v6
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_mul_i32 s11, 0x180, s11
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s11, s11, s14
		v_add_u32_e32 v7, s11, v6
		s_add_i32 s35, s20, 0x80
		v_add_u32_e32 v8, s35, v4
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_add_u32_e32 v4, 0x80, v4
		s_add_i32 m0, m0, 0xfffed740
		v_add_u32_e32 v7, s21, v4
		v_add_u32_e32 v9, s33, v4
		v_add_u32_e32 v4, s10, v4
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v8, 8, v0
		s_add_i32 m0, m0, 0x2100
		v_cmp_ne_u32_e64 vcc, v8, s16
		v_add_u32_e32 v10, 0x80, v6
		v_add_u32_e32 v11, s18, v10
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		v_add_u32_e32 v7, s34, v10
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v13, 4, v12
		v_and_b32_e32 v12, 15, v12
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v9, 3, v12
		s_add_i32 m0, m0, 0x2100
		v_mov_b32_e32 v14, 0x420
		v_mul_lo_u32 v14, v14, v9
		v_and_b32_e32 v9, 7, v12
		v_lshlrev_b32_e32 v9, 7, v9
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s35, s14, 0x80
		v_add_u32_e32 v4, s35, v6
		s_add_i32 m0, m0, 0x62e0
		s_mov_b32 s35, 0x80
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cmp_eq_u32_e64 s[36:37], v8, s16
		s_add_i32 m0, m0, 0x2100
		s_and_b32 s38, s19, 1
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_add_u32_e32 v4, s11, v10
		s_add_i32 m0, m0, 0x62e0
		s_lshr_b32 s19, s19, 1
		s_mul_i32 s39, 0x840, s19
		v_lshl_add_u32 v6, v13, 4, s39
		v_add3_u32 v6, v6, v14, v9
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_mul_i32 s39, 0x840, s38
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s39, s39, 0x10000
		v_lshl_add_u32 v7, v13, 4, s39
		v_add3_u32 v7, v7, v14, v9
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		ds_read_b128 v[12:15], v6
		ds_read_b128 v[16:19], v6 offset:64
		ds_read_b128 v[20:23], v6 offset:8448
		ds_read_b128 v[24:27], v6 offset:8512
		ds_read_b128 v[28:31], v6 offset:16896
		ds_read_b128 v[32:35], v6 offset:16960
		ds_read_b128 v[36:39], v6 offset:25344
		ds_read_b128 v[40:43], v6 offset:25408
		ds_read_b128 v[44:47], v7 offset:2016
		ds_read_b128 v[48:51], v7 offset:2080
		ds_read_b128 v[52:55], v7 offset:6240
		ds_read_b128 v[56:59], v7 offset:6304
		ds_read_b128 v[60:63], v7 offset:10464
		ds_read_b128 v[64:67], v7 offset:10528
		ds_read_b128 v[68:71], v7 offset:14688
		ds_read_b128 v[72:75], v7 offset:14752
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[60:61], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[60:61]
		s_setprio 0
		v_lshl_add_u32 v4, v2, 1, s20
		v_lshl_add_u32 v9, v2, 1, s21
		v_lshl_add_u32 v10, v2, 1, s33
		v_lshl_add_u32 v2, v2, 1, s10
		v_lshl_add_u32 v11, v5, 1, s14
		v_lshl_add_u32 v76, v5, 1, s18
		v_lshl_add_u32 v77, v5, 1, s34
		v_lshl_add_u32 v5, v5, 1, s11
		s_mov_b32 s10, s35
		v_add_u32_e32 v78, 0x100, v3
		v_add_u32_e32 v79, v78, v4
		v_add_u32_e32 v80, v78, v9
		v_add_u32_e32 v81, v78, v10
		v_add_u32_e32 v82, v78, v2
		v_add_u32_e32 v83, v78, v11
		v_add_u32_e32 v84, v78, v76
		v_add_u32_e32 v85, v78, v77
		v_add_u32_e32 v78, v78, v5
		v_add_u32_e32 v3, 0x180, v3
		v_add_u32_e32 v4, v3, v4
		v_add_u32_e32 v9, v3, v9
		v_add_u32_e32 v10, v3, v10
		v_add_u32_e32 v2, v3, v2
		v_add_u32_e32 v11, v3, v11
		v_add_u32_e32 v76, v3, v76
		v_add_u32_e32 v77, v3, v77
		v_add_u32_e32 v3, v3, v5
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		s_mov_b32 s2, s10
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
		v_mfma_f32_16x16x32_f16 v[88:91], v[44:47], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[44:47], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[44:47], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[36:39], v[148:151]
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
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b128 v[44:47], v7 offset:35776
		ds_read_b128 v[48:51], v7 offset:35840
		ds_read_b128 v[52:55], v7 offset:40000
		ds_read_b128 v[56:59], v7 offset:40064
		ds_read_b128 v[60:63], v7 offset:44224
		ds_read_b128 v[64:67], v7 offset:44288
		ds_read_b128 v[68:71], v7 offset:48448
		ds_read_b128 v[72:75], v7 offset:48512
		s_mov_b32 m0, s13
		s_nop 0
		buffer_load_dwordx4 v79, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v81, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v82, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v83, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v84, s[28:31], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[44:47], v[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[44:47], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[44:47], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[44:47], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[36:39], v[204:207]
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
		s_setprio 1
		s_barrier
		ds_read_b128 v[12:15], v6 offset:33792
		ds_read_b128 v[16:19], v6 offset:33856
		ds_read_b128 v[20:23], v6 offset:42240
		ds_read_b128 v[24:27], v6 offset:42304
		ds_read_b128 v[28:31], v6 offset:50688
		ds_read_b128 v[32:35], v6 offset:50752
		ds_read_b128 v[36:39], v6 offset:59136
		ds_read_b128 v[40:43], v6 offset:59200
		ds_read_b128 v[44:47], v7 offset:18912
		ds_read_b128 v[48:51], v7 offset:18976
		ds_read_b128 v[52:55], v7 offset:23136
		ds_read_b128 v[56:59], v7 offset:23200
		ds_read_b128 v[60:63], v7 offset:27360
		ds_read_b128 v[64:67], v7 offset:27424
		ds_read_b128 v[68:71], v7 offset:31584
		ds_read_b128 v[72:75], v7 offset:31648
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v85, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v78, s[28:31], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[44:47], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[44:47], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[44:47], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[36:39], v[148:151]
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
		s_setprio 1
		s_barrier
		ds_read_b128 v[44:47], v7 offset:52672
		ds_read_b128 v[48:51], v7 offset:52736
		ds_read_b128 v[52:55], v7 offset:56896
		ds_read_b128 v[56:59], v7 offset:56960
		ds_read_b128 v[60:63], v7 offset:61120
		ds_read_b128 v[64:67], v7 offset:61184
		ds_read_b128 v[68:71], v7 offset:65344
		ds_read_b128 v[72:75], v7 offset:65408
		s_add_i32 m0, m0, 0xfffed740
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v76, s[28:31], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[152:155], v[44:47], v[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[44:47], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[44:47], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[44:47], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[36:39], v[204:207]
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
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[12:15], v6
		ds_read_b128 v[16:19], v6 offset:64
		ds_read_b128 v[20:23], v6 offset:8448
		ds_read_b128 v[24:27], v6 offset:8512
		ds_read_b128 v[28:31], v6 offset:16896
		ds_read_b128 v[32:35], v6 offset:16960
		ds_read_b128 v[36:39], v6 offset:25344
		ds_read_b128 v[40:43], v6 offset:25408
		ds_read_b128 v[44:47], v7 offset:2016
		ds_read_b128 v[48:51], v7 offset:2080
		ds_read_b128 v[52:55], v7 offset:6240
		ds_read_b128 v[56:59], v7 offset:6304
		ds_read_b128 v[60:63], v7 offset:10464
		ds_read_b128 v[64:67], v7 offset:10528
		ds_read_b128 v[68:71], v7 offset:14688
		ds_read_b128 v[72:75], v7 offset:14752
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v77, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s10, s10, 0x80
		s_add_i32 s2, s2, 0x80
		s_setprio 0
		s_barrier
		s_add_u32 s24, s24, 0x100
		s_addc_u32 s25, s25, 0
		s_add_u32 s28, s28, 0x100
		s_addc_u32 s29, s29, 0
		s_add_i32 s16, s16, 2
		s_cmp_lt_i32 s16, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[60:61], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[60:61]
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[88:91], v[44:47], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[44:47], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[44:47], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[36:39], v[148:151]
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
		ds_read_b128 v[44:47], v7 offset:35776
		ds_read_b128 v[48:51], v7 offset:35840
		ds_read_b128 v[52:55], v7 offset:40000
		ds_read_b128 v[56:59], v7 offset:40064
		ds_read_b128 v[60:63], v7 offset:44224
		ds_read_b128 v[64:67], v7 offset:44288
		ds_read_b128 v[68:71], v7 offset:48448
		ds_read_b128 v[72:75], v7 offset:48512
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[152:155], v[44:47], v[12:15], v[152:155]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[12:15], v[156:159]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[12:15], v[160:163]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[44:47], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[184:187], v[44:47], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[44:47], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[16:19], v[160:163]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[12:15], v6 offset:33792
		ds_read_b128 v[16:19], v6 offset:33856
		ds_read_b128 v[20:23], v6 offset:42240
		ds_read_b128 v[24:27], v6 offset:42304
		ds_read_b128 v[28:31], v6 offset:50688
		ds_read_b128 v[32:35], v6 offset:50752
		ds_read_b128 v[36:39], v6 offset:59136
		ds_read_b128 v[40:43], v6 offset:59200
		ds_read_b128 v[44:47], v7 offset:18912
		ds_read_b128 v[48:51], v7 offset:18976
		ds_read_b128 v[52:55], v7 offset:23136
		ds_read_b128 v[56:59], v7 offset:23200
		ds_read_b128 v[60:63], v7 offset:27360
		ds_read_b128 v[64:67], v7 offset:27424
		ds_read_b128 v[68:71], v7 offset:31584
		ds_read_b128 v[72:75], v7 offset:31648
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[88:91], v[44:47], v[12:15], v[88:91]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[12:15], v[92:95]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[12:15], v[96:99]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[44:47], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[120:123], v[44:47], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[56:59], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[16:19], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[40:43], v[144:147]
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		v_cvt_pk_f16_f32 v4, v92, v93
		v_cvt_pk_f16_f32 v5, v94, v95
		v_cvt_pk_f16_f32 v10, v96, v97
		v_cvt_pk_f16_f32 v11, v98, v99
		v_cvt_pk_f16_f32 v44, v100, v101
		v_cvt_pk_f16_f32 v45, v102, v103
		v_cvt_pk_f16_f32 v46, v104, v105
		v_cvt_pk_f16_f32 v47, v106, v107
		v_cvt_pk_f16_f32 v52, v108, v109
		v_cvt_pk_f16_f32 v53, v110, v111
		v_cvt_pk_f16_f32 v54, v112, v113
		v_cvt_pk_f16_f32 v55, v114, v115
		v_cvt_pk_f16_f32 v60, v116, v117
		v_cvt_pk_f16_f32 v61, v118, v119
		v_cvt_pk_f16_f32 v62, v128, v129
		v_cvt_pk_f16_f32 v63, v130, v131
		v_cvt_pk_f16_f32 v64, v144, v145
		v_cvt_pk_f16_f32 v65, v146, v147
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[48:51], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[56:59], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[40:43], v[148:151]
		ds_read_b128 v[48:51], v7 offset:52672
		ds_read_b128 v[56:59], v7 offset:52736
		ds_read_b128 v[68:71], v7 offset:56896
		v_cvt_pk_f16_f32 v66, v120, v121
		v_cvt_pk_f16_f32 v67, v122, v123
		v_cvt_pk_f16_f32 v72, v124, v125
		v_cvt_pk_f16_f32 v73, v126, v127
		v_cvt_pk_f16_f32 v74, v132, v133
		v_cvt_pk_f16_f32 v75, v134, v135
		v_cvt_pk_f16_f32 v76, v136, v137
		v_cvt_pk_f16_f32 v77, v138, v139
		v_cvt_pk_f16_f32 v78, v140, v141
		v_cvt_pk_f16_f32 v79, v142, v143
		v_cvt_pk_f16_f32 v80, v148, v149
		v_cvt_pk_f16_f32 v81, v150, v151
		ds_read_b128 v[84:87], v7 offset:56960
		ds_read_b128 v[88:91], v7 offset:61120
		ds_read_b128 v[92:95], v7 offset:61184
		ds_read_b128 v[96:99], v7 offset:65344
		ds_read_b128 v[100:103], v7 offset:65408
		v_and_b32_e32 v6, 1, v0
		v_lshrrev_b32_e32 v7, 1, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v7
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v82, 4
		v_mul_lo_u32 v82, v82, v7
		v_bitop3_b32 v7, v6, v9, v82 bitop3:0x96
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v83, 8
		v_mul_lo_u32 v83, v83, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v104, 16
		v_mul_lo_u32 v104, v104, v1
		v_bitop3_b32 v1, v7, v83, v104 bitop3:0x96
		v_and_b32_e32 v7, 1, v8
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v7
		v_xad_u32 v1, v1, v8, s17
		v_bitop3_b32 v7, 64, v6, v9 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v1, s8
		v_xor_b32_e32 v1, v7, v82
		v_bitop3_b32 v1, v1, v83, v104 bitop3:0x96
		v_xad_u32 v1, v1, v8, s17
		v_xor_b32_e32 v7, 0x80, v6
		v_cmp_lt_i32_e64 s[4:5], v1, s8
		v_xor_b32_e32 v1, v7, v9
		v_xor_b32_e32 v1, v1, v82
		v_bitop3_b32 v1, v1, v83, v104 bitop3:0x96
		v_xad_u32 v1, v1, v8, s17
		v_xor_b32_e32 v6, 0xc0, v6
		v_xor_b32_e32 v6, v6, v9
		v_xor_b32_e32 v6, v6, v82
		v_bitop3_b32 v6, v6, v83, v104 bitop3:0x96
		v_xad_u32 v6, v6, v8, s17
		v_cmp_lt_i32_e64 s[10:11], v1, s8
		v_cmp_lt_i32_e64 s[16:17], v6, s8
		v_lshrrev_b32_e32 v1, 4, v0
		v_and_b32_e32 v6, 1, v1
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v8, 1, v6
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v82, 16
		v_mul_lo_u32 v82, v82, v8
		v_bitop3_b32 v8, v7, v9, v82 bitop3:0x96
		v_add_u32_e32 v83, s32, v8
		v_bitop3_b32 v104, 32, v7, v9 bitop3:0x96
		v_cmp_lt_i32_e64 s[20:21], v83, s9
		v_xor_b32_e32 v83, v104, v82
		v_add_u32_e32 v104, s32, v83
		v_bitop3_b32 v105, 64, v7, v9 bitop3:0x96
		v_cmp_lt_i32_e64 s[24:25], v104, s9
		v_xor_b32_e32 v104, v105, v82
		v_add_u32_e32 v105, s32, v104
		v_xor_b32_e32 v7, 0x60, v7
		v_xor_b32_e32 v7, v7, v9
		v_xor_b32_e32 v7, v7, v82
		v_cmp_lt_i32_e64 s[26:27], v105, s9
		v_add_u32_e32 v9, s32, v7
		s_and_b64 s[28:29], s[2:3], s[20:21]
		v_cmp_lt_i32_e64 s[30:31], v9, s9
		s_and_b64 s[34:35], s[2:3], s[24:25]
		s_and_b64 s[36:37], s[2:3], s[26:27]
		s_and_b64 s[40:41], s[2:3], s[30:31]
		s_and_b64 s[42:43], s[4:5], s[20:21]
		s_and_b64 s[44:45], s[4:5], s[24:25]
		s_and_b64 s[46:47], s[4:5], s[26:27]
		s_and_b64 s[48:49], s[4:5], s[30:31]
		s_and_b64 s[50:51], s[10:11], s[20:21]
		s_and_b64 s[52:53], s[10:11], s[24:25]
		s_and_b64 s[54:55], s[10:11], s[26:27]
		s_and_b64 s[56:57], s[10:11], s[30:31]
		s_and_b64 s[58:59], s[16:17], s[20:21]
		s_and_b64 s[24:25], s[16:17], s[24:25]
		s_and_b64 s[26:27], s[16:17], s[26:27]
		s_and_b64 s[30:31], s[16:17], s[30:31]
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s8, s15, s12
		s_lshl_b32 s8, s8, 11
		s_add_i32 s13, s1, s8
		s_mul_i32 s0, s0, s12
		s_lshl_b32 s0, s0, 9
		s_add_i32 s13, s13, s0
		s_mul_i32 s14, s12, s19
		s_lshl_b32 s14, s14, 5
		s_add_i32 s13, s13, s14
		s_lshl_b32 s15, s38, 5
		s_add_i32 s13, s13, s15
		v_and_b32_e32 v0, 15, v0
		v_mul_lo_u32 v0, s12, v0
		v_lshl_add_u32 v9, v0, 1, s13
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 4, v6
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 3, v1
		v_add3_u32 v9, v9, v6, v1
		v_mov_b32_e32 v82, 0x7fffffff
		v_cndmask_b32_e64 v9, v82, v9, s[28:29]
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		buffer_store_dwordx2 v[2:3], v9, s[20:23], 0 offen
		s_add_i32 s6, s13, 64
		v_lshl_add_u32 v2, v0, 1, v6
		v_add3_u32 v3, v1, v2, s6
		v_cndmask_b32_e64 v3, v82, v3, s[34:35]
		buffer_store_dwordx2 v[4:5], v3, s[20:23], 0 offen
		s_add_i32 s6, s13, 0x80
		v_add3_u32 v3, v1, v2, s6
		v_cndmask_b32_e64 v3, v82, v3, s[36:37]
		buffer_store_dwordx2 v[10:11], v3, s[20:23], 0 offen
		s_add_i32 s6, s13, 0xc0
		v_add3_u32 v2, v1, v2, s6
		v_cndmask_b32_e64 v2, v82, v2, s[40:41]
		buffer_store_dwordx2 v[44:45], v2, s[20:23], 0 offen
		s_lshl_b32 s6, s12, 7
		s_add_i32 s6, s1, s6
		s_add_i32 s6, s6, s8
		s_add_i32 s6, s6, s0
		s_add_i32 s6, s6, s14
		s_add_i32 s6, s6, s15
		v_lshl_add_u32 v2, v0, 1, s6
		v_add3_u32 v2, v2, v6, v1
		v_cndmask_b32_e64 v2, v82, v2, s[42:43]
		buffer_store_dwordx2 v[46:47], v2, s[20:23], 0 offen
		s_add_i32 s7, s6, 64
		v_lshl_add_u32 v2, v0, 1, v6
		v_add3_u32 v3, v1, v2, s7
		v_cndmask_b32_e64 v3, v82, v3, s[44:45]
		buffer_store_dwordx2 v[52:53], v3, s[20:23], 0 offen
		s_add_i32 s7, s6, 0x80
		v_add3_u32 v3, v1, v2, s7
		v_cndmask_b32_e64 v3, v82, v3, s[46:47]
		buffer_store_dwordx2 v[54:55], v3, s[20:23], 0 offen
		s_add_i32 s7, s6, 0xc0
		v_add3_u32 v2, v1, v2, s7
		v_cndmask_b32_e64 v2, v82, v2, s[48:49]
		buffer_store_dwordx2 v[60:61], v2, s[20:23], 0 offen
		s_lshl_b32 s7, s12, 8
		s_add_i32 s7, s1, s7
		s_add_i32 s7, s7, s8
		s_add_i32 s7, s7, s0
		s_add_i32 s7, s7, s14
		s_add_i32 s7, s7, s15
		v_lshl_add_u32 v2, v0, 1, s7
		v_add3_u32 v2, v2, v6, v1
		v_cndmask_b32_e64 v2, v82, v2, s[50:51]
		buffer_store_dwordx2 v[66:67], v2, s[20:23], 0 offen
		s_add_i32 s18, s7, 64
		v_lshl_add_u32 v2, v0, 1, v6
		v_add3_u32 v3, v1, v2, s18
		v_cndmask_b32_e64 v3, v82, v3, s[52:53]
		buffer_store_dwordx2 v[72:73], v3, s[20:23], 0 offen
		s_add_i32 s18, s7, 0x80
		v_add3_u32 v3, v1, v2, s18
		v_cndmask_b32_e64 v3, v82, v3, s[54:55]
		buffer_store_dwordx2 v[62:63], v3, s[20:23], 0 offen
		s_add_i32 s18, s7, 0xc0
		v_add3_u32 v2, v1, v2, s18
		v_cndmask_b32_e64 v2, v82, v2, s[56:57]
		buffer_store_dwordx2 v[74:75], v2, s[20:23], 0 offen
		s_mul_i32 s12, 0x180, s12
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s8
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s14
		s_add_i32 s0, s0, s15
		v_lshl_add_u32 v2, v0, 1, s0
		v_add3_u32 v2, v2, v6, v1
		v_cndmask_b32_e64 v2, v82, v2, s[58:59]
		buffer_store_dwordx2 v[76:77], v2, s[20:23], 0 offen
		s_add_i32 s1, s0, 64
		v_lshl_add_u32 v2, v0, 1, v6
		v_add3_u32 v3, v1, v2, s1
		v_cndmask_b32_e64 v3, v82, v3, s[24:25]
		buffer_store_dwordx2 v[78:79], v3, s[20:23], 0 offen
		s_add_i32 s1, s0, 0x80
		v_add3_u32 v3, v1, v2, s1
		v_cndmask_b32_e64 v3, v82, v3, s[26:27]
		buffer_store_dwordx2 v[64:65], v3, s[20:23], 0 offen
		s_add_i32 s1, s0, 0xc0
		v_add3_u32 v2, v1, v2, s1
		v_cndmask_b32_e64 v2, v82, v2, s[30:31]
		buffer_store_dwordx2 v[80:81], v2, s[20:23], 0 offen
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[152:155], v[48:51], v[12:15], v[152:155]
		s_add_i32 s1, s32, 0x80
		v_add_u32_e32 v2, s1, v8
		v_add_u32_e32 v3, s1, v83
		v_cmp_lt_i32_e64 s[14:15], v2, s9
		v_cmp_lt_i32_e64 s[18:19], v3, s9
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[12:15], v[156:159]
		v_add_u32_e32 v2, s1, v104
		v_add_u32_e32 v3, s1, v7
		v_cmp_lt_i32_e64 s[24:25], v2, s9
		v_cmp_lt_i32_e64 s[26:27], v3, s9
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[12:15], v[160:163]
		s_and_b64 s[8:9], s[2:3], s[14:15]
		s_and_b64 s[28:29], s[2:3], s[18:19]
		s_and_b64 s[30:31], s[2:3], s[24:25]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[12:15], v[164:167]
		s_and_b64 s[2:3], s[2:3], s[26:27]
		s_and_b64 s[32:33], s[4:5], s[14:15]
		s_and_b64 s[34:35], s[4:5], s[18:19]
		v_mfma_f32_16x16x32_f16 v[180:183], v[96:99], v[20:23], v[180:183]
		s_and_b64 s[36:37], s[4:5], s[24:25]
		s_and_b64 s[4:5], s[4:5], s[26:27]
		s_and_b64 s[38:39], s[10:11], s[14:15]
		v_mfma_f32_16x16x32_f16 v[168:171], v[48:51], v[20:23], v[168:171]
		s_and_b64 s[40:41], s[10:11], s[18:19]
		s_and_b64 s[42:43], s[10:11], s[24:25]
		s_and_b64 s[10:11], s[10:11], s[26:27]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[20:23], v[172:175]
		s_and_b64 s[14:15], s[16:17], s[14:15]
		s_and_b64 s[18:19], s[16:17], s[18:19]
		s_and_b64 s[24:25], s[16:17], s[24:25]
		s_and_b64 s[16:17], s[16:17], s[26:27]
		v_mfma_f32_16x16x32_f16 v[176:179], v[88:91], v[20:23], v[176:179]
		s_add_i32 s1, s13, 0x100
		v_lshl_add_u32 v2, v0, 1, s1
		v_add3_u32 v2, v2, v6, v1
		v_mfma_f32_16x16x32_f16 v[192:195], v[88:91], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[88:91], v[36:39], v[208:211]
		v_cndmask_b32_e64 v2, v82, v2, s[8:9]
		v_mfma_f32_16x16x32_f16 v[184:187], v[48:51], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[48:51], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[196:199], v[96:99], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[96:99], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[16:19], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[100:103], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[168:171], v[56:59], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[92:95], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[92:95], v[32:35], v[192:195]
		v_cvt_pk_f16_f32 v4, v152, v153
		v_cvt_pk_f16_f32 v5, v154, v155
		v_cvt_pk_f16_f32 v8, v156, v157
		v_mfma_f32_16x16x32_f16 v[184:187], v[56:59], v[32:35], v[184:187]
		v_cvt_pk_f16_f32 v9, v158, v159
		v_cvt_pk_f16_f32 v10, v160, v161
		v_cvt_pk_f16_f32 v11, v162, v163
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_cvt_pk_f16_f32 v12, v164, v165
		v_cvt_pk_f16_f32 v13, v166, v167
		v_cvt_pk_f16_f32 v14, v168, v169
		v_mfma_f32_16x16x32_f16 v[196:199], v[100:103], v[32:35], v[196:199]
		v_cvt_pk_f16_f32 v15, v170, v171
		v_cvt_pk_f16_f32 v16, v172, v173
		v_cvt_pk_f16_f32 v17, v174, v175
		v_mfma_f32_16x16x32_f16 v[212:215], v[100:103], v[40:43], v[212:215]
		v_cvt_pk_f16_f32 v18, v176, v177
		v_cvt_pk_f16_f32 v19, v178, v179
		v_cvt_pk_f16_f32 v20, v180, v181
		v_mfma_f32_16x16x32_f16 v[200:203], v[56:59], v[40:43], v[200:203]
		v_cvt_pk_f16_f32 v21, v182, v183
		v_cvt_pk_f16_f32 v22, v184, v185
		v_cvt_pk_f16_f32 v23, v186, v187
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_cvt_pk_f16_f32 v24, v188, v189
		v_cvt_pk_f16_f32 v25, v190, v191
		v_cvt_pk_f16_f32 v26, v192, v193
		v_mfma_f32_16x16x32_f16 v[208:211], v[92:95], v[40:43], v[208:211]
		v_cvt_pk_f16_f32 v27, v194, v195
		v_cvt_pk_f16_f32 v28, v196, v197
		v_cvt_pk_f16_f32 v29, v198, v199
		v_cvt_pk_f16_f32 v30, v200, v201
		v_cvt_pk_f16_f32 v31, v202, v203
		v_cvt_pk_f16_f32 v32, v204, v205
		v_cvt_pk_f16_f32 v33, v206, v207
		buffer_store_dwordx2 v[4:5], v2, s[20:23], 0 offen
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		v_cvt_pk_f16_f32 v4, v212, v213
		v_cvt_pk_f16_f32 v5, v214, v215
		s_add_i32 s1, s13, 0x140
		v_lshl_add_u32 v7, v0, 1, v6
		v_add3_u32 v34, v1, v7, s1
		v_cndmask_b32_e64 v34, v82, v34, s[28:29]
		buffer_store_dwordx2 v[8:9], v34, s[20:23], 0 offen
		s_add_i32 s1, s13, 0x180
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[30:31]
		buffer_store_dwordx2 v[10:11], v8, s[20:23], 0 offen
		s_add_i32 s1, s13, 0x1c0
		v_add3_u32 v7, v1, v7, s1
		v_cndmask_b32_e64 v7, v82, v7, s[2:3]
		buffer_store_dwordx2 v[12:13], v7, s[20:23], 0 offen
		s_add_i32 s1, s6, 0x100
		v_lshl_add_u32 v7, v0, 1, v6
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[32:33]
		buffer_store_dwordx2 v[14:15], v8, s[20:23], 0 offen
		s_add_i32 s1, s6, 0x140
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[34:35]
		buffer_store_dwordx2 v[16:17], v8, s[20:23], 0 offen
		s_add_i32 s1, s6, 0x180
		v_add3_u32 v7, v1, v7, s1
		v_cndmask_b32_e64 v7, v82, v7, s[36:37]
		buffer_store_dwordx2 v[18:19], v7, s[20:23], 0 offen
		s_add_i32 s1, s6, 0x1c0
		v_lshl_add_u32 v7, v0, 1, v6
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[4:5]
		buffer_store_dwordx2 v[20:21], v8, s[20:23], 0 offen
		s_add_i32 s1, s7, 0x100
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[38:39]
		buffer_store_dwordx2 v[22:23], v8, s[20:23], 0 offen
		s_add_i32 s1, s7, 0x140
		v_add3_u32 v7, v1, v7, s1
		v_cndmask_b32_e64 v7, v82, v7, s[40:41]
		buffer_store_dwordx2 v[24:25], v7, s[20:23], 0 offen
		s_add_i32 s1, s7, 0x180
		v_lshl_add_u32 v7, v0, 1, v6
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[42:43]
		buffer_store_dwordx2 v[26:27], v8, s[20:23], 0 offen
		s_add_i32 s1, s7, 0x1c0
		v_add3_u32 v8, v1, v7, s1
		v_cndmask_b32_e64 v8, v82, v8, s[10:11]
		buffer_store_dwordx2 v[28:29], v8, s[20:23], 0 offen
		s_add_i32 s1, s0, 0x100
		v_add3_u32 v7, v1, v7, s1
		v_cndmask_b32_e64 v7, v82, v7, s[14:15]
		buffer_store_dwordx2 v[30:31], v7, s[20:23], 0 offen
		s_add_i32 s1, s0, 0x140
		v_lshl_add_u32 v0, v0, 1, v6
		v_add3_u32 v6, v1, v0, s1
		v_cndmask_b32_e64 v6, v82, v6, s[18:19]
		buffer_store_dwordx2 v[32:33], v6, s[20:23], 0 offen
		s_add_i32 s1, s0, 0x180
		v_add3_u32 v6, v1, v0, s1
		v_cndmask_b32_e64 v6, v82, v6, s[24:25]
		buffer_store_dwordx2 v[2:3], v6, s[20:23], 0 offen
		s_add_i32 s0, s0, 0x1c0
		v_add3_u32 v0, v1, v0, s0
		v_cndmask_b32_e64 v0, v82, v0, s[16:17]
		buffer_store_dwordx2 v[4:5], v0, s[20:23], 0 offen
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
