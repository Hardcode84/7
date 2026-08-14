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
		s_add_i32 s14, s14, -8
		s_mul_i32 s14, s14, 31
		s_add_i32 s14, s14, 0x100
		s_add_i32 s15, s14, s13
.Lv9_beyond_hotloop.if_end_0:
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s15, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s14, s15, -1
		s_add_i32 s14, s14, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s14, s15
		s_cselect_b32 s14, 1, 0
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
		s_mul_hi_u32 s18, s13, s18
		s_mul_i32 s19, s18, s16
		s_xor_b32 s19, s19, -1
		s_add_i32 s19, s19, 1
		s_add_i32 s13, s13, s19
		s_cmp_ge_u32 s13, s16
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s18, 1
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s18, s20, s18
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s13, s17
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s13, s20, s13
		s_cmp_ge_u32 s13, s16
		s_cselect_b32 s16, 1, 0
		s_add_i32 s19, s18, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s19, s18
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s1, s15, s1
		s_xor_b32 s15, s16, -1
		s_add_i32 s15, s15, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s15, s16
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
		v_lshrrev_b32_e32 v1, 3, v0
		v_mul_lo_u32 v2, s10, v1
		v_and_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 4, v3
		v_lshl_add_u32 v4, v2, 1, v3
		s_mul_i32 s5, s1, s10
		s_lshl_b32 s5, s5, 11
		s_mul_i32 s13, s14, s10
		s_lshl_b32 s13, s13, 9
		s_add_i32 s24, s5, s13
		v_add_u32_e32 v5, s24, v4
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mul_i32 s15, s15, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s25, s10, 7
		s_add_i32 s26, s25, s5
		s_add_i32 s26, s26, s13
		v_add_u32_e32 v5, s26, v4
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mul_i32 s27, s0, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s28, s10, 8
		s_add_i32 s29, s28, s5
		s_add_i32 s29, s29, s13
		v_add_u32_e32 v5, s29, v4
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_lshl_b32 s0, s0, 9
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s30, s10, s5
		s_add_i32 s30, s30, s13
		v_add_u32_e32 v5, s30, v4
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_lshrrev_b32_e32 v5, 4, v0
		s_add_i32 m0, m0, 0xa4e0
		v_mul_lo_u32 v6, s11, v5
		v_and_b32_e32 v7, 15, v0
		v_lshlrev_b32_e32 v8, 4, v7
		v_lshl_add_u32 v6, v6, 1, v8
		v_add_u32_e32 v8, s0, v6
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_lshl_b32 s31, s11, 6
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s32, s0, s31
		v_add_u32_e32 v8, s32, v6
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s33, s0, 0x100
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v8, s33, v6
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s31, s33, s31
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v8, s31, v6
		s_mul_i32 s34, s11, 64
		s_mul_i32 s35, 0xc0, s11
		s_mov_b32 s36, 0
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_add_u32_e32 v8, s13, v4
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s37, s5, 0x80
		s_add_i32 s13, s37, s13
		v_add_u32_e32 v4, s13, v4
		v_add_u32_e32 v8, s5, v8
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add_u32_e32 v4, 0x80, v8
		v_add_u32_e32 v8, s25, v4
		v_add_u32_e32 v9, s28, v4
		v_add_u32_e32 v4, s10, v4
		s_add_i32 m0, m0, 0x2100
		v_lshrrev_b32_e32 v10, 7, v0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mov_b32_e32 v8, 0x840
		v_mul_lo_u32 v8, v8, v10
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s5, s34, s34
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 4, v11
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_lshlrev_b32_e32 v9, 4, v12
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s10, s11, 7
		v_and_b32_e32 v11, 15, v11
		v_lshrrev_b32_e32 v12, 3, v11
		v_mov_b32_e32 v13, 0x420
		v_mul_lo_u32 v13, v13, v12
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, v8, v9, v13
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s11, s0, s10
		v_add_u32_e32 v8, s11, v6
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_and_b32_e32 v8, 7, v11
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s13, s0, s35
		v_add_u32_e32 v9, s13, v6
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		s_add_i32 s10, s33, s10
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v9, s10, v6
		v_lshl_add_u32 v4, v8, 7, v4
		s_add_i32 s25, s33, s35
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_add_u32_e32 v8, s25, v6
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v9, 3, v0
		v_lshlrev_b32_e32 v9, 3, v9
		v_add_u32_e32 v9, 0x10000, v9
		v_lshrrev_b32_e32 v11, 6, v0
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
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
		v_and_b32_e32 v8, 1, v11
		v_lshlrev_b32_e32 v8, 5, v8
		v_add_u32_e32 v9, v9, v8
		v_lshrrev_b32_e32 v44, 5, v0
		v_and_b32_e32 v45, 1, v44
		v_mov_b32_e32 v46, 0x1080
		v_mul_lo_u32 v46, v46, v45
		v_and_b32_e32 v47, 1, v5
		v_mov_b32_e32 v48, 0x840
		v_mul_lo_u32 v48, v48, v47
		v_add3_u32 v9, v9, v46, v48
		v_and_b32_e32 v46, 1, v1
		v_lshl_add_u32 v9, v46, 9, v9
		v_lshrrev_b32_e32 v46, 2, v0
		v_and_b32_e32 v48, 1, v46
		v_lshl_add_u32 v9, v48, 8, v9
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
		v_lshrrev_b32_e32 v80, 8, v0
		v_cmp_ne_u32_e64 vcc, v80, s36
		v_cmp_eq_u32_e64 s[38:39], v80, s36
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_setprio 0
		v_lshl_add_u32 v81, v2, 1, s24
		v_lshl_add_u32 v82, v2, 1, s26
		v_lshl_add_u32 v83, v2, 1, s29
		v_lshl_add_u32 v2, v2, 1, s30
		s_mov_b32 s24, 0x80
		s_mov_b32 s26, s24
		v_add_u32_e32 v84, 0x100, v3
		v_add_u32_e32 v85, v84, v81
		v_add_u32_e32 v86, v84, v82
		v_add_u32_e32 v87, v84, v83
		v_add_u32_e32 v88, v84, v2
		v_add_u32_e32 v3, 0x180, v3
		v_add_u32_e32 v84, v3, v81
		v_add_u32_e32 v81, v3, v82
		v_add_u32_e32 v82, v3, v83
		v_add_u32_e32 v83, v3, v2
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_lshl_b32 s2, s5, 1
		s_lshl_b32 s3, s34, 1
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
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
.Lv9_beyond_hotloop.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[92:95], v[48:51], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[24:27], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[40:43], v[152:155]
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
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_add_i32 s24, s33, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s28, s0, s2
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		s_add_i32 s29, s32, s2
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s28, v6
		buffer_load_dwordx4 v87, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s29, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s24, v6
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[156:159], v[48:51], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[48:51], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[48:51], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[48:51], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[24:27], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[40:43], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[40:43], v[208:211]
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
		s_add_i32 s24, s31, s2
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		v_add_u32_e32 v2, s24, v6
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[92:95], v[48:51], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[24:27], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[40:43], v[152:155]
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
		s_add_i32 s24, s10, s2
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_add_i32 s28, s11, s2
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s29, s13, s2
		buffer_load_dwordx4 v81, s[20:23], 0 offen lds
		v_add_u32_e32 v2, s28, v6
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v3, s29, v6
		buffer_load_dwordx4 v82, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v83, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s24, v6
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[156:159], v[48:51], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[48:51], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[48:51], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[48:51], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[24:27], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[40:43], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[40:43], v[208:211]
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
		s_add_i32 s2, s25, s2
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v2, s2, v6
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s26, s26, 0x80
		s_add_i32 s2, s5, s3
		s_setprio 0
		s_barrier
		s_add_u32 s20, s20, 0x100
		s_addc_u32 s21, s21, 0
		s_add_i32 s36, s36, 2
		s_cmp_lt_i32 s36, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_setprio 0
		s_and_saveexec_b64 s[100:101], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[92:95], v[48:51], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[24:27], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[40:43], v[152:155]
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
		v_mfma_f32_16x16x32_f16 v[156:159], v[48:51], v[12:15], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[12:15], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[12:15], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[48:51], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[48:51], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[48:51], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[16:19], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[24:27], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[40:43], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[40:43], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[40:43], v[208:211]
		ds_read_b128 v[12:15], v4 offset:33792
		ds_read_b128 v[16:19], v4 offset:33856
		ds_read_b128 v[20:23], v4 offset:42240
		ds_read_b128 v[24:27], v4 offset:42304
		ds_read_b128 v[28:31], v4 offset:50688
		ds_read_b128 v[32:35], v4 offset:50752
		ds_read_b128 v[36:39], v4 offset:59136
		ds_read_b128 v[40:43], v4 offset:59200
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
		v_mfma_f32_16x16x32_f16 v[92:95], v[48:51], v[12:15], v[92:95]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[12:15], v[96:99]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[12:15], v[100:103]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[48:51], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[48:51], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[16:19], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[24:27], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[40:43], v[148:151]
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		v_cvt_pk_f16_f32 v4, v96, v97
		v_cvt_pk_f16_f32 v6, v98, v99
		v_cvt_pk_f16_f32 v48, v100, v101
		v_cvt_pk_f16_f32 v49, v102, v103
		v_cvt_pk_f16_f32 v50, v104, v105
		v_cvt_pk_f16_f32 v51, v106, v107
		v_cvt_pk_f16_f32 v56, v108, v109
		v_cvt_pk_f16_f32 v57, v110, v111
		v_cvt_pk_f16_f32 v58, v112, v113
		v_cvt_pk_f16_f32 v59, v114, v115
		v_cvt_pk_f16_f32 v64, v116, v117
		v_cvt_pk_f16_f32 v65, v118, v119
		v_cvt_pk_f16_f32 v66, v120, v121
		v_cvt_pk_f16_f32 v67, v122, v123
		v_cvt_pk_f16_f32 v68, v132, v133
		v_cvt_pk_f16_f32 v69, v134, v135
		v_cvt_pk_f16_f32 v70, v148, v149
		v_cvt_pk_f16_f32 v71, v150, v151
		v_mfma_f32_16x16x32_f16 v[124:127], v[52:55], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[40:43], v[152:155]
		ds_read_b64_tr_b16 v[52:53], v9 offset:52672
		ds_read_b64_tr_b16 v[54:55], v9 offset:53728
		ds_read_b64_tr_b16 v[60:61], v9 offset:61120
		v_cvt_pk_f16_f32 v72, v124, v125
		v_cvt_pk_f16_f32 v73, v126, v127
		v_cvt_pk_f16_f32 v74, v128, v129
		v_cvt_pk_f16_f32 v75, v130, v131
		v_cvt_pk_f16_f32 v76, v136, v137
		v_cvt_pk_f16_f32 v77, v138, v139
		v_cvt_pk_f16_f32 v78, v140, v141
		v_cvt_pk_f16_f32 v79, v142, v143
		v_cvt_pk_f16_f32 v81, v144, v145
		v_cvt_pk_f16_f32 v82, v146, v147
		v_cvt_pk_f16_f32 v83, v152, v153
		v_cvt_pk_f16_f32 v84, v154, v155
		ds_read_b64_tr_b16 v[62:63], v9 offset:62176
		ds_read_b64_tr_b16 v[88:89], v9 offset:52736
		ds_read_b64_tr_b16 v[90:91], v9 offset:53792
		ds_read_b64_tr_b16 v[92:93], v9 offset:61184
		ds_read_b64_tr_b16 v[94:95], v9 offset:62240
		ds_read_b64_tr_b16 v[96:97], v9 offset:52800
		ds_read_b64_tr_b16 v[98:99], v9 offset:53856
		ds_read_b64_tr_b16 v[100:101], v9 offset:61248
		ds_read_b64_tr_b16 v[102:103], v9 offset:62304
		ds_read_b64_tr_b16 v[104:105], v9 offset:52864
		ds_read_b64_tr_b16 v[106:107], v9 offset:53920
		ds_read_b64_tr_b16 v[108:109], v9 offset:61312
		ds_read_b64_tr_b16 v[110:111], v9 offset:62368
		v_and_b32_e32 v9, 1, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_and_b32_e32 v0, 1, v0
		v_mov_b32_e32 v85, 2
		v_mul_lo_u32 v85, v85, v0
		v_and_b32_e32 v0, 1, v46
		v_mov_b32_e32 v46, 4
		v_mul_lo_u32 v46, v46, v0
		v_bitop3_b32 v0, v9, v85, v46 bitop3:0x96
		v_and_b32_e32 v1, 1, v1
		v_mov_b32_e32 v86, 8
		v_mul_lo_u32 v86, v86, v1
		v_and_b32_e32 v1, 1, v10
		v_mov_b32_e32 v87, 16
		v_mul_lo_u32 v87, v87, v1
		v_bitop3_b32 v0, v0, v86, v87 bitop3:0x96
		v_and_b32_e32 v1, 1, v80
		v_mov_b32_e32 v80, 32
		v_mul_lo_u32 v80, v80, v1
		v_xad_u32 v0, v0, v80, s15
		v_bitop3_b32 v1, 64, v9, v85 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v0, s8
		v_xor_b32_e32 v0, v1, v46
		v_bitop3_b32 v0, v0, v86, v87 bitop3:0x96
		v_xad_u32 v0, v0, v80, s15
		v_xor_b32_e32 v1, 0x80, v9
		v_cmp_lt_i32_e64 s[4:5], v0, s8
		v_xor_b32_e32 v0, v1, v85
		v_xor_b32_e32 v0, v0, v46
		v_bitop3_b32 v0, v0, v86, v87 bitop3:0x96
		v_xad_u32 v0, v0, v80, s15
		v_xor_b32_e32 v1, 0xc0, v9
		v_xor_b32_e32 v1, v1, v85
		v_xor_b32_e32 v1, v1, v46
		v_bitop3_b32 v1, v1, v86, v87 bitop3:0x96
		v_xad_u32 v1, v1, v80, s15
		v_cmp_lt_i32_e64 s[6:7], v0, s8
		v_cmp_lt_i32_e64 s[10:11], v1, s8
		v_and_b32_e32 v0, 1, v5
		v_mov_b32_e32 v1, 4
		v_mul_lo_u32 v1, v1, v0
		v_and_b32_e32 v0, 1, v44
		v_mov_b32_e32 v5, 8
		v_mul_lo_u32 v5, v5, v0
		v_and_b32_e32 v0, 1, v11
		v_mov_b32_e32 v9, 16
		v_mul_lo_u32 v9, v9, v0
		v_bitop3_b32 v0, v1, v5, v9 bitop3:0x96
		v_add_u32_e32 v11, s27, v0
		v_bitop3_b32 v44, 1, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[16:17], v11, s9
		v_xor_b32_e32 v11, v44, v9
		v_add_u32_e32 v44, s27, v11
		v_bitop3_b32 v46, 2, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[18:19], v44, s9
		v_xor_b32_e32 v44, v46, v9
		v_add_u32_e32 v46, s27, v44
		v_bitop3_b32 v80, 3, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[24:25], v46, s9
		v_xor_b32_e32 v46, v80, v9
		v_add_u32_e32 v80, s27, v46
		v_bitop3_b32 v85, 32, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[28:29], v80, s9
		v_xor_b32_e32 v80, v85, v9
		v_add_u32_e32 v85, s27, v80
		v_bitop3_b32 v86, 33, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[30:31], v85, s9
		v_xor_b32_e32 v85, v86, v9
		v_add_u32_e32 v86, s27, v85
		v_bitop3_b32 v87, 34, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[34:35], v86, s9
		v_xor_b32_e32 v86, v87, v9
		v_add_u32_e32 v87, s27, v86
		v_bitop3_b32 v112, 35, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[36:37], v87, s9
		v_xor_b32_e32 v87, v112, v9
		v_add_u32_e32 v112, s27, v87
		v_bitop3_b32 v113, 64, v1, v5 bitop3:0x96
		v_cmp_lt_i32_e64 s[38:39], v112, s9
		v_xor_b32_e32 v112, v113, v9
		v_add_u32_e32 v113, s27, v112
		v_xor_b32_e32 v114, 0x41, v1
		v_cmp_lt_i32_e64 s[40:41], v113, s9
		v_xor_b32_e32 v113, v114, v5
		v_xor_b32_e32 v113, v113, v9
		v_add_u32_e32 v114, s27, v113
		v_xor_b32_e32 v115, 0x42, v1
		v_cmp_lt_i32_e64 s[42:43], v114, s9
		v_xor_b32_e32 v114, v115, v5
		v_xor_b32_e32 v114, v114, v9
		v_add_u32_e32 v115, s27, v114
		v_xor_b32_e32 v116, 0x43, v1
		v_cmp_lt_i32_e64 s[44:45], v115, s9
		v_xor_b32_e32 v115, v116, v5
		v_xor_b32_e32 v115, v115, v9
		v_add_u32_e32 v116, s27, v115
		v_xor_b32_e32 v117, 0x60, v1
		v_cmp_lt_i32_e64 s[46:47], v116, s9
		v_xor_b32_e32 v116, v117, v5
		v_xor_b32_e32 v116, v116, v9
		v_add_u32_e32 v117, s27, v116
		v_xor_b32_e32 v118, 0x61, v1
		v_cmp_lt_i32_e64 s[48:49], v117, s9
		v_xor_b32_e32 v117, v118, v5
		v_xor_b32_e32 v117, v117, v9
		v_add_u32_e32 v118, s27, v117
		v_xor_b32_e32 v119, 0x62, v1
		v_cmp_lt_i32_e64 s[50:51], v118, s9
		v_xor_b32_e32 v118, v119, v5
		v_xor_b32_e32 v118, v118, v9
		v_add_u32_e32 v119, s27, v118
		v_xor_b32_e32 v1, 0x63, v1
		v_xor_b32_e32 v1, v1, v5
		v_xor_b32_e32 v1, v1, v9
		v_cmp_lt_i32_e64 s[52:53], v119, s9
		v_add_u32_e32 v5, s27, v1
		v_mul_lo_u32 v9, s12, v10
		v_cmp_lt_i32_e64 s[54:55], v5, s9
		s_and_b64 s[56:57], s[10:11], s[18:19]
		s_and_b64 s[58:59], s[10:11], s[24:25]
		s_and_b64 s[60:61], s[10:11], s[28:29]
		s_and_b64 s[62:63], s[10:11], s[30:31]
		s_and_b64 s[64:65], s[10:11], s[34:35]
		s_and_b64 s[66:67], s[10:11], s[36:37]
		s_and_b64 s[68:69], s[10:11], s[38:39]
		s_and_b64 s[70:71], s[10:11], s[40:41]
		s_and_b64 s[72:73], s[10:11], s[42:43]
		s_and_b64 s[74:75], s[10:11], s[44:45]
		s_and_b64 s[76:77], s[10:11], s[46:47]
		s_and_b64 s[78:79], s[10:11], s[48:49]
		s_and_b64 s[80:81], s[10:11], s[50:51]
		s_and_b64 s[82:83], s[10:11], s[52:53]
		s_and_b64 s[84:85], s[10:11], s[54:55]
		v_and_b32_e32 v5, 0xffff, v2
		v_lshrrev_b32_e32 v2, 16, v2
		v_and_b32_e32 v2, 0xffff, v2
		v_and_b32_e32 v10, 0xffff, v3
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_and_b32_e32 v119, 0xffff, v4
		v_lshrrev_b32_e32 v4, 16, v4
		v_and_b32_e32 v4, 0xffff, v4
		v_and_b32_e32 v120, 0xffff, v6
		v_lshrrev_b32_e32 v6, 16, v6
		v_and_b32_e32 v6, 0xffff, v6
		v_and_b32_e32 v121, 0xffff, v48
		v_lshrrev_b32_e32 v48, 16, v48
		v_and_b32_e32 v48, 0xffff, v48
		v_and_b32_e32 v122, 0xffff, v49
		v_lshrrev_b32_e32 v49, 16, v49
		v_and_b32_e32 v49, 0xffff, v49
		v_and_b32_e32 v123, 0xffff, v50
		v_lshrrev_b32_e32 v50, 16, v50
		v_and_b32_e32 v50, 0xffff, v50
		v_and_b32_e32 v124, 0xffff, v51
		v_lshrrev_b32_e32 v51, 16, v51
		v_and_b32_e32 v51, 0xffff, v51
		v_and_b32_e32 v125, 0xffff, v56
		v_lshrrev_b32_e32 v56, 16, v56
		v_and_b32_e32 v56, 0xffff, v56
		v_and_b32_e32 v126, 0xffff, v57
		v_lshrrev_b32_e32 v57, 16, v57
		v_and_b32_e32 v57, 0xffff, v57
		v_and_b32_e32 v127, 0xffff, v58
		v_lshrrev_b32_e32 v58, 16, v58
		v_and_b32_e32 v58, 0xffff, v58
		v_and_b32_e32 v128, 0xffff, v59
		v_lshrrev_b32_e32 v59, 16, v59
		v_and_b32_e32 v59, 0xffff, v59
		v_and_b32_e32 v129, 0xffff, v64
		v_lshrrev_b32_e32 v64, 16, v64
		v_and_b32_e32 v64, 0xffff, v64
		v_and_b32_e32 v130, 0xffff, v65
		v_lshrrev_b32_e32 v65, 16, v65
		v_and_b32_e32 v65, 0xffff, v65
		v_and_b32_e32 v131, 0xffff, v66
		v_lshrrev_b32_e32 v66, 16, v66
		v_and_b32_e32 v66, 0xffff, v66
		v_and_b32_e32 v132, 0xffff, v67
		v_lshrrev_b32_e32 v67, 16, v67
		v_and_b32_e32 v67, 0xffff, v67
		v_and_b32_e32 v133, 0xffff, v72
		v_lshrrev_b32_e32 v72, 16, v72
		v_and_b32_e32 v72, 0xffff, v72
		v_and_b32_e32 v134, 0xffff, v73
		v_lshrrev_b32_e32 v73, 16, v73
		v_and_b32_e32 v73, 0xffff, v73
		v_and_b32_e32 v135, 0xffff, v74
		v_lshrrev_b32_e32 v74, 16, v74
		v_and_b32_e32 v74, 0xffff, v74
		v_and_b32_e32 v136, 0xffff, v75
		v_lshrrev_b32_e32 v75, 16, v75
		v_and_b32_e32 v75, 0xffff, v75
		v_and_b32_e32 v137, 0xffff, v68
		v_lshrrev_b32_e32 v68, 16, v68
		v_and_b32_e32 v68, 0xffff, v68
		v_and_b32_e32 v138, 0xffff, v69
		v_lshrrev_b32_e32 v69, 16, v69
		v_and_b32_e32 v69, 0xffff, v69
		v_and_b32_e32 v139, 0xffff, v76
		v_lshrrev_b32_e32 v76, 16, v76
		v_and_b32_e32 v76, 0xffff, v76
		v_and_b32_e32 v140, 0xffff, v77
		v_lshrrev_b32_e32 v77, 16, v77
		v_and_b32_e32 v77, 0xffff, v77
		v_and_b32_e32 v141, 0xffff, v78
		v_lshrrev_b32_e32 v78, 16, v78
		v_and_b32_e32 v78, 0xffff, v78
		v_and_b32_e32 v142, 0xffff, v79
		v_lshrrev_b32_e32 v79, 16, v79
		v_and_b32_e32 v79, 0xffff, v79
		v_and_b32_e32 v143, 0xffff, v81
		v_lshrrev_b32_e32 v81, 16, v81
		v_and_b32_e32 v81, 0xffff, v81
		v_and_b32_e32 v144, 0xffff, v82
		v_lshrrev_b32_e32 v82, 16, v82
		v_and_b32_e32 v82, 0xffff, v82
		v_and_b32_e32 v145, 0xffff, v70
		v_lshrrev_b32_e32 v70, 16, v70
		v_and_b32_e32 v70, 0xffff, v70
		v_and_b32_e32 v146, 0xffff, v71
		v_lshrrev_b32_e32 v71, 16, v71
		v_and_b32_e32 v71, 0xffff, v71
		v_and_b32_e32 v147, 0xffff, v83
		v_lshrrev_b32_e32 v83, 16, v83
		v_and_b32_e32 v83, 0xffff, v83
		v_and_b32_e32 v148, 0xffff, v84
		v_lshrrev_b32_e32 v84, 16, v84
		v_and_b32_e32 v84, 0xffff, v84
		s_mul_i32 s1, s1, s12
		s_lshl_b32 s1, s1, 11
		s_add_i32 s8, s0, s1
		s_mul_i32 s13, s14, s12
		s_lshl_b32 s13, s13, 9
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v149, v9, 5, s8
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v149, v149, v7, v8
		v_lshl_add_u32 v149, v45, 4, v149
		v_lshl_add_u32 v149, v47, 3, v149
		s_and_b64 s[14:15], s[2:3], s[16:17]
		s_and_saveexec_b64 s[100:101], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_2
		buffer_store_short v5, v149, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_2:
		s_andn2_b64 exec, s[100:101], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_2
.Lv9_beyond_hotloop.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s0, 2
		s_add_i32 s14, s8, s1
		s_add_i32 s14, s14, s13
		v_lshl_add_u32 v5, v9, 5, s14
		v_add3_u32 v5, v5, v7, v8
		v_lshl_add_u32 v5, v45, 4, v5
		v_lshl_add_u32 v5, v47, 3, v5
		s_and_b64 s[14:15], s[2:3], s[18:19]
		s_and_saveexec_b64 s[100:101], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_3
		buffer_store_short v2, v5, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_3:
		s_andn2_b64 exec, s[100:101], s[14:15]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_3
.Lv9_beyond_hotloop.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s14, s0, 4
		s_add_i32 s15, s14, s1
		s_add_i32 s15, s15, s13
		v_lshl_add_u32 v2, v9, 5, s15
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[86:87], s[2:3], s[24:25]
		s_and_saveexec_b64 s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_4
		buffer_store_short v10, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_4:
		s_andn2_b64 exec, s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_4
.Lv9_beyond_hotloop.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s15, s0, 6
		s_add_i32 s26, s15, s1
		s_add_i32 s26, s26, s13
		v_lshl_add_u32 v2, v9, 5, s26
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[86:87], s[2:3], s[28:29]
		s_and_saveexec_b64 s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_5
		buffer_store_short v3, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_5:
		s_andn2_b64 exec, s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_5
.Lv9_beyond_hotloop.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s26, s0, 64
		s_add_i32 s32, s26, s1
		s_add_i32 s32, s32, s13
		v_lshl_add_u32 v2, v9, 5, s32
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[86:87], s[2:3], s[30:31]
		s_and_saveexec_b64 s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_6
		buffer_store_short v119, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_6:
		s_andn2_b64 exec, s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_6
.Lv9_beyond_hotloop.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s32, s0, 0x42
		s_add_i32 s86, s32, s1
		s_add_i32 s86, s86, s13
		v_lshl_add_u32 v2, v9, 5, s86
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[86:87], s[2:3], s[34:35]
		s_and_saveexec_b64 s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_7
		buffer_store_short v4, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_7:
		s_andn2_b64 exec, s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_7
.Lv9_beyond_hotloop.exec_endif_7:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s86, s0, 0x44
		s_add_i32 s87, s86, s1
		s_add_i32 s87, s87, s13
		v_lshl_add_u32 v2, v9, 5, s87
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[88:89], s[2:3], s[36:37]
		s_and_saveexec_b64 s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_8
		buffer_store_short v120, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_8
.Lv9_beyond_hotloop.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s87, s0, 0x46
		s_add_i32 s88, s87, s1
		s_add_i32 s88, s88, s13
		v_lshl_add_u32 v2, v9, 5, s88
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[88:89], s[2:3], s[38:39]
		s_and_saveexec_b64 s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_9
		buffer_store_short v6, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_9
.Lv9_beyond_hotloop.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s88, s0, 0x80
		s_add_i32 s89, s88, s1
		s_add_i32 s89, s89, s13
		v_lshl_add_u32 v2, v9, 5, s89
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[90:91], s[2:3], s[40:41]
		s_and_saveexec_b64 s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_10
		buffer_store_short v121, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_10
.Lv9_beyond_hotloop.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s89, s0, 0x82
		s_add_i32 s90, s89, s1
		s_add_i32 s90, s90, s13
		v_lshl_add_u32 v2, v9, 5, s90
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[90:91], s[2:3], s[42:43]
		s_and_saveexec_b64 s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_11
		buffer_store_short v48, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_11
.Lv9_beyond_hotloop.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s90, s0, 0x84
		s_add_i32 s91, s90, s1
		s_add_i32 s91, s91, s13
		v_lshl_add_u32 v2, v9, 5, s91
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[92:93], s[2:3], s[44:45]
		s_and_saveexec_b64 s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_12
		buffer_store_short v122, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_12
.Lv9_beyond_hotloop.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s91, s0, 0x86
		s_add_i32 s92, s91, s1
		s_add_i32 s92, s92, s13
		v_lshl_add_u32 v2, v9, 5, s92
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[92:93], s[2:3], s[46:47]
		s_and_saveexec_b64 s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_13
		buffer_store_short v49, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_13
.Lv9_beyond_hotloop.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s92, s0, 0xc0
		s_add_i32 s93, s92, s1
		s_add_i32 s93, s93, s13
		v_lshl_add_u32 v2, v9, 5, s93
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[94:95], s[2:3], s[48:49]
		s_and_saveexec_b64 s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_14
		buffer_store_short v123, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_14
.Lv9_beyond_hotloop.exec_endif_14:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s93, s0, 0xc2
		s_add_i32 s94, s93, s1
		s_add_i32 s94, s94, s13
		v_lshl_add_u32 v2, v9, 5, s94
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[94:95], s[2:3], s[50:51]
		s_and_saveexec_b64 s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_15
		buffer_store_short v50, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_15:
		s_andn2_b64 exec, s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_15
.Lv9_beyond_hotloop.exec_endif_15:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s94, s0, 0xc4
		s_add_i32 s95, s94, s1
		s_add_i32 s95, s95, s13
		v_lshl_add_u32 v2, v9, 5, s95
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[96:97], s[2:3], s[52:53]
		s_and_saveexec_b64 s[100:101], s[96:97]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_16
		buffer_store_short v124, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_16:
		s_andn2_b64 exec, s[100:101], s[96:97]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_16
.Lv9_beyond_hotloop.exec_endif_16:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s95, s0, 0xc6
		s_add_i32 s96, s95, s1
		s_add_i32 s96, s96, s13
		v_lshl_add_u32 v2, v9, 5, s96
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[96:97], s[2:3], s[54:55]
		s_and_saveexec_b64 s[100:101], s[96:97]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_17
		buffer_store_short v51, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_17:
		s_andn2_b64 exec, s[100:101], s[96:97]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_17
.Lv9_beyond_hotloop.exec_endif_17:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s96, s12, 7
		s_add_i32 s97, s0, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[16:17]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_18
		buffer_store_short v125, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_18:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_18
.Lv9_beyond_hotloop.exec_endif_18:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s8, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[18:19]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_19
		buffer_store_short v56, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_19:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_19
.Lv9_beyond_hotloop.exec_endif_19:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s14, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[24:25]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_20
		buffer_store_short v126, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_20:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_20
.Lv9_beyond_hotloop.exec_endif_20:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s15, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[28:29]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_21
		buffer_store_short v57, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_21:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_21
.Lv9_beyond_hotloop.exec_endif_21:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s26, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[30:31]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_22
		buffer_store_short v127, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_22:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_22
.Lv9_beyond_hotloop.exec_endif_22:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s32, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[34:35]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_23
		buffer_store_short v58, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_23:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_23
.Lv9_beyond_hotloop.exec_endif_23:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s86, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[36:37]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_24
		buffer_store_short v128, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_24:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_24
.Lv9_beyond_hotloop.exec_endif_24:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s87, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[38:39]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_25
		buffer_store_short v59, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_25:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_25
.Lv9_beyond_hotloop.exec_endif_25:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s88, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[40:41]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_26
		buffer_store_short v129, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_26:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_26
.Lv9_beyond_hotloop.exec_endif_26:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s89, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[42:43]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_27
		buffer_store_short v64, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_27:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_27
.Lv9_beyond_hotloop.exec_endif_27:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s90, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[44:45]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_28
		buffer_store_short v130, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_28:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_28
.Lv9_beyond_hotloop.exec_endif_28:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s91, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[46:47]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_29
		buffer_store_short v65, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_29:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_29
.Lv9_beyond_hotloop.exec_endif_29:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s92, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[48:49]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_30
		buffer_store_short v131, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_30:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_30
.Lv9_beyond_hotloop.exec_endif_30:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s93, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[50:51]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_31
		buffer_store_short v66, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_31:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_31
.Lv9_beyond_hotloop.exec_endif_31:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s94, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[52:53]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_32
		buffer_store_short v132, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_32:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_32
.Lv9_beyond_hotloop.exec_endif_32:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s97, s95, s96
		s_add_i32 s97, s97, s1
		s_add_i32 s97, s97, s13
		v_lshl_add_u32 v2, v9, 5, s97
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[4:5], s[54:55]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_33
		buffer_store_short v67, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_33:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_33
.Lv9_beyond_hotloop.exec_endif_33:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s97, s12, 8
		s_add_i32 s98, s0, s97
		s_add_i32 s98, s98, s1
		s_add_i32 s98, s98, s13
		v_lshl_add_u32 v2, v9, 5, s98
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[98:99], s[6:7], s[16:17]
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_34
		buffer_store_short v133, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_34:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_34
.Lv9_beyond_hotloop.exec_endif_34:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s98, s8, s97
		s_add_i32 s98, s98, s1
		s_add_i32 s98, s98, s13
		v_lshl_add_u32 v2, v9, 5, s98
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[18:19]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_35
		buffer_store_short v72, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_35:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_35
.Lv9_beyond_hotloop.exec_endif_35:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s14, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[24:25]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_36
		buffer_store_short v134, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_36:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_36
.Lv9_beyond_hotloop.exec_endif_36:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s15, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[28:29]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_37
		buffer_store_short v73, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_37:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_37
.Lv9_beyond_hotloop.exec_endif_37:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s26, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[30:31]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_38
		buffer_store_short v135, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_38:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_38
.Lv9_beyond_hotloop.exec_endif_38:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s32, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[34:35]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_39
		buffer_store_short v74, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_39:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_39
.Lv9_beyond_hotloop.exec_endif_39:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s86, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[36:37]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_40
		buffer_store_short v136, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_40:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_40
.Lv9_beyond_hotloop.exec_endif_40:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s87, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[38:39]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_41
		buffer_store_short v75, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_41:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_41
.Lv9_beyond_hotloop.exec_endif_41:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s88, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[40:41]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_42
		buffer_store_short v137, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_42:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_42
.Lv9_beyond_hotloop.exec_endif_42:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s89, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[42:43]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_43
		buffer_store_short v68, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_43:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_43
.Lv9_beyond_hotloop.exec_endif_43:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s90, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[44:45]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_44
		buffer_store_short v138, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_44:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_44
.Lv9_beyond_hotloop.exec_endif_44:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s91, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[46:47]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_45
		buffer_store_short v69, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_45:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_45
.Lv9_beyond_hotloop.exec_endif_45:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s92, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[48:49]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_46
		buffer_store_short v139, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_46:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_46
.Lv9_beyond_hotloop.exec_endif_46:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s93, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[50:51]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_47
		buffer_store_short v76, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_47:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_47
.Lv9_beyond_hotloop.exec_endif_47:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s94, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[52:53]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_48
		buffer_store_short v140, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_48:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_48
.Lv9_beyond_hotloop.exec_endif_48:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s18, s95, s97
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[18:19], s[6:7], s[54:55]
		s_and_saveexec_b64 s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_49
		buffer_store_short v77, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_49:
		s_andn2_b64 exec, s[100:101], s[18:19]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_49
.Lv9_beyond_hotloop.exec_endif_49:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s12, 0x180, s12
		s_add_i32 s18, s0, s12
		s_add_i32 s18, s18, s1
		s_add_i32 s18, s18, s13
		v_lshl_add_u32 v2, v9, 5, s18
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_b64 s[16:17], s[10:11], s[16:17]
		s_and_saveexec_b64 s[100:101], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_50
		buffer_store_short v141, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_50:
		s_andn2_b64 exec, s[100:101], s[16:17]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_50
.Lv9_beyond_hotloop.exec_endif_50:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s8, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_51
		buffer_store_short v78, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_51:
		s_andn2_b64 exec, s[100:101], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_51
.Lv9_beyond_hotloop.exec_endif_51:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s14, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_52
		buffer_store_short v142, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_52:
		s_andn2_b64 exec, s[100:101], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_52
.Lv9_beyond_hotloop.exec_endif_52:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s15, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[60:61]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_53
		buffer_store_short v79, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_53:
		s_andn2_b64 exec, s[100:101], s[60:61]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_53
.Lv9_beyond_hotloop.exec_endif_53:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s26, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[62:63]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_54
		buffer_store_short v143, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_54:
		s_andn2_b64 exec, s[100:101], s[62:63]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_54
.Lv9_beyond_hotloop.exec_endif_54:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s32, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[64:65]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_55
		buffer_store_short v81, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_55:
		s_andn2_b64 exec, s[100:101], s[64:65]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_55
.Lv9_beyond_hotloop.exec_endif_55:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s86, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[66:67]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_56
		buffer_store_short v144, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_56:
		s_andn2_b64 exec, s[100:101], s[66:67]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_56
.Lv9_beyond_hotloop.exec_endif_56:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s87, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_57
		buffer_store_short v82, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_57:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_57
.Lv9_beyond_hotloop.exec_endif_57:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s88, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[70:71]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_58
		buffer_store_short v145, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_58:
		s_andn2_b64 exec, s[100:101], s[70:71]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_58
.Lv9_beyond_hotloop.exec_endif_58:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s89, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[72:73]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_59
		buffer_store_short v70, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_59:
		s_andn2_b64 exec, s[100:101], s[72:73]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_59
.Lv9_beyond_hotloop.exec_endif_59:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s90, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[74:75]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_60
		buffer_store_short v146, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_60:
		s_andn2_b64 exec, s[100:101], s[74:75]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_60
.Lv9_beyond_hotloop.exec_endif_60:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s91, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[76:77]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_61
		buffer_store_short v71, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_61:
		s_andn2_b64 exec, s[100:101], s[76:77]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_61
.Lv9_beyond_hotloop.exec_endif_61:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s92, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[78:79]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_62
		buffer_store_short v147, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_62:
		s_andn2_b64 exec, s[100:101], s[78:79]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_62
.Lv9_beyond_hotloop.exec_endif_62:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s93, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[80:81]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_63
		buffer_store_short v83, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_63:
		s_andn2_b64 exec, s[100:101], s[80:81]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_63
.Lv9_beyond_hotloop.exec_endif_63:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s94, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[82:83]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_64
		buffer_store_short v148, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_64:
		s_andn2_b64 exec, s[100:101], s[82:83]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_64
.Lv9_beyond_hotloop.exec_endif_64:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s95, s12
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v2, v9, 5, s8
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[84:85]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_65
		buffer_store_short v84, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_65:
		s_andn2_b64 exec, s[100:101], s[84:85]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_65
.Lv9_beyond_hotloop.exec_endif_65:
		s_mov_b64 exec, s[100:101]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[156:159], v[52:55], v[12:15], v[156:159]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[160:163], v[88:91], v[12:15], v[160:163]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[164:167], v[96:99], v[12:15], v[164:167]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[168:171], v[104:107], v[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[104:107], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[52:55], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[88:91], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[96:99], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[96:99], v[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[96:99], v[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], v[52:55], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[52:55], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[88:91], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[104:107], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[104:107], v[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[88:91], v[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[92:95], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[100:103], v[16:19], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[108:111], v[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[108:111], v[24:27], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[92:95], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[100:103], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[100:103], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[212:215], v[100:103], v[40:43], v[212:215]
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		v_cvt_pk_f16_f32 v6, v164, v165
		v_cvt_pk_f16_f32 v10, v166, v167
		v_cvt_pk_f16_f32 v12, v168, v169
		v_cvt_pk_f16_f32 v13, v170, v171
		v_cvt_pk_f16_f32 v14, v172, v173
		v_cvt_pk_f16_f32 v15, v174, v175
		v_cvt_pk_f16_f32 v16, v176, v177
		v_cvt_pk_f16_f32 v17, v178, v179
		v_cvt_pk_f16_f32 v18, v180, v181
		v_cvt_pk_f16_f32 v19, v182, v183
		v_cvt_pk_f16_f32 v20, v184, v185
		v_cvt_pk_f16_f32 v21, v186, v187
		v_cvt_pk_f16_f32 v22, v196, v197
		v_cvt_pk_f16_f32 v23, v198, v199
		v_cvt_pk_f16_f32 v24, v212, v213
		v_cvt_pk_f16_f32 v25, v214, v215
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[40:43], v[204:207]
		v_and_b32_e32 v26, 0xffff, v2
		v_lshrrev_b32_e32 v2, 16, v2
		v_and_b32_e32 v2, 0xffff, v2
		v_mfma_f32_16x16x32_f16 v[192:195], v[92:95], v[32:35], v[192:195]
		v_and_b32_e32 v27, 0xffff, v3
		v_lshrrev_b32_e32 v3, 16, v3
		v_and_b32_e32 v3, 0xffff, v3
		v_mfma_f32_16x16x32_f16 v[200:203], v[108:111], v[32:35], v[200:203]
		v_cvt_pk_f16_f32 v28, v188, v189
		v_cvt_pk_f16_f32 v29, v190, v191
		v_cvt_pk_f16_f32 v30, v204, v205
		v_mfma_f32_16x16x32_f16 v[216:219], v[108:111], v[40:43], v[216:219]
		v_cvt_pk_f16_f32 v31, v192, v193
		v_cvt_pk_f16_f32 v32, v194, v195
		v_cvt_pk_f16_f32 v33, v206, v207
		v_mfma_f32_16x16x32_f16 v[208:211], v[92:95], v[40:43], v[208:211]
		v_cvt_pk_f16_f32 v34, v200, v201
		v_cvt_pk_f16_f32 v35, v202, v203
		v_and_b32_e32 v36, 0xffff, v4
		v_lshrrev_b32_e32 v4, 16, v4
		v_cvt_pk_f16_f32 v37, v216, v217
		v_cvt_pk_f16_f32 v38, v218, v219
		v_and_b32_e32 v4, 0xffff, v4
		v_and_b32_e32 v39, 0xffff, v5
		v_cvt_pk_f16_f32 v40, v208, v209
		v_cvt_pk_f16_f32 v41, v210, v211
		s_add_i32 s8, s27, 0x80
		v_add_u32_e32 v0, s8, v0
		v_add_u32_e32 v11, s8, v11
		v_cmp_lt_i32_e64 s[14:15], v0, s9
		v_cmp_lt_i32_e64 s[16:17], v11, s9
		v_add_u32_e32 v0, s8, v44
		v_add_u32_e32 v11, s8, v46
		v_cmp_lt_i32_e64 s[18:19], v0, s9
		v_cmp_lt_i32_e64 s[24:25], v11, s9
		v_add_u32_e32 v0, s8, v80
		v_add_u32_e32 v11, s8, v85
		v_add_u32_e32 v42, s8, v86
		v_add_u32_e32 v43, s8, v87
		v_add_u32_e32 v44, s8, v112
		v_add_u32_e32 v46, s8, v113
		v_add_u32_e32 v48, s8, v114
		v_add_u32_e32 v49, s8, v115
		v_add_u32_e32 v50, s8, v116
		v_add_u32_e32 v51, s8, v117
		v_add_u32_e32 v52, s8, v118
		v_add_u32_e32 v1, s8, v1
		v_cmp_lt_i32_e64 s[26:27], v0, s9
		v_cmp_lt_i32_e64 s[28:29], v11, s9
		v_cmp_lt_i32_e64 s[30:31], v42, s9
		v_cmp_lt_i32_e64 s[34:35], v43, s9
		v_cmp_lt_i32_e64 s[36:37], v44, s9
		v_cmp_lt_i32_e64 s[38:39], v46, s9
		v_cmp_lt_i32_e64 s[40:41], v48, s9
		v_cmp_lt_i32_e64 s[42:43], v49, s9
		v_cmp_lt_i32_e64 s[44:45], v50, s9
		v_cmp_lt_i32_e64 s[46:47], v51, s9
		v_cmp_lt_i32_e64 s[48:49], v52, s9
		v_cmp_lt_i32_e64 s[50:51], v1, s9
		s_and_b64 s[8:9], s[2:3], s[14:15]
		s_and_b64 s[52:53], s[2:3], s[16:17]
		s_and_b64 s[54:55], s[2:3], s[18:19]
		s_and_b64 s[56:57], s[2:3], s[24:25]
		s_and_b64 s[58:59], s[2:3], s[26:27]
		s_and_b64 s[60:61], s[2:3], s[28:29]
		s_and_b64 s[62:63], s[2:3], s[30:31]
		s_and_b64 s[64:65], s[2:3], s[34:35]
		s_and_b64 s[66:67], s[2:3], s[36:37]
		s_and_b64 s[68:69], s[2:3], s[38:39]
		s_and_b64 s[70:71], s[2:3], s[40:41]
		s_and_b64 s[72:73], s[2:3], s[42:43]
		s_and_b64 s[74:75], s[2:3], s[44:45]
		s_and_b64 s[76:77], s[2:3], s[46:47]
		s_and_b64 s[78:79], s[2:3], s[48:49]
		s_and_b64 s[2:3], s[2:3], s[50:51]
		s_and_b64 s[80:81], s[10:11], s[34:35]
		s_and_b64 s[82:83], s[10:11], s[36:37]
		s_and_b64 s[84:85], s[10:11], s[38:39]
		s_and_b64 s[86:87], s[10:11], s[40:41]
		s_and_b64 s[88:89], s[10:11], s[42:43]
		s_and_b64 s[90:91], s[10:11], s[44:45]
		s_and_b64 s[92:93], s[10:11], s[46:47]
		s_and_b64 s[94:95], s[10:11], s[48:49]
		s_and_b64 s[98:99], s[10:11], s[50:51]
		v_lshrrev_b32_e32 v0, 16, v5
		v_and_b32_e32 v0, 0xffff, v0
		v_and_b32_e32 v1, 0xffff, v6
		v_lshrrev_b32_e32 v5, 16, v6
		v_and_b32_e32 v5, 0xffff, v5
		v_and_b32_e32 v6, 0xffff, v10
		v_lshrrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v10, 0xffff, v10
		v_and_b32_e32 v11, 0xffff, v12
		v_lshrrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v12, 0xffff, v12
		v_and_b32_e32 v42, 0xffff, v13
		v_lshrrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v13, 0xffff, v13
		v_and_b32_e32 v43, 0xffff, v14
		v_lshrrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v14, 0xffff, v14
		v_and_b32_e32 v44, 0xffff, v15
		v_lshrrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v15, 0xffff, v15
		v_and_b32_e32 v46, 0xffff, v16
		v_lshrrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v16, 0xffff, v16
		v_and_b32_e32 v48, 0xffff, v17
		v_lshrrev_b32_e32 v17, 16, v17
		v_and_b32_e32 v17, 0xffff, v17
		v_and_b32_e32 v49, 0xffff, v18
		v_lshrrev_b32_e32 v18, 16, v18
		v_and_b32_e32 v18, 0xffff, v18
		v_and_b32_e32 v50, 0xffff, v19
		v_lshrrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v19, 0xffff, v19
		v_and_b32_e32 v51, 0xffff, v20
		v_lshrrev_b32_e32 v20, 16, v20
		v_and_b32_e32 v20, 0xffff, v20
		v_and_b32_e32 v52, 0xffff, v21
		v_lshrrev_b32_e32 v21, 16, v21
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v53, 0xffff, v28
		v_lshrrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v28, 0xffff, v28
		v_and_b32_e32 v54, 0xffff, v29
		v_lshrrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v29, 0xffff, v29
		v_and_b32_e32 v55, 0xffff, v31
		v_lshrrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v31, 0xffff, v31
		v_and_b32_e32 v56, 0xffff, v32
		v_lshrrev_b32_e32 v32, 16, v32
		v_and_b32_e32 v32, 0xffff, v32
		v_and_b32_e32 v57, 0xffff, v22
		v_lshrrev_b32_e32 v22, 16, v22
		v_and_b32_e32 v22, 0xffff, v22
		v_and_b32_e32 v58, 0xffff, v23
		v_lshrrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v23, 0xffff, v23
		v_and_b32_e32 v59, 0xffff, v34
		v_lshrrev_b32_e32 v34, 16, v34
		v_and_b32_e32 v34, 0xffff, v34
		v_and_b32_e32 v60, 0xffff, v35
		v_lshrrev_b32_e32 v35, 16, v35
		v_and_b32_e32 v35, 0xffff, v35
		v_and_b32_e32 v61, 0xffff, v30
		v_lshrrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v30, 0xffff, v30
		v_and_b32_e32 v62, 0xffff, v33
		v_lshrrev_b32_e32 v33, 16, v33
		v_and_b32_e32 v33, 0xffff, v33
		v_and_b32_e32 v63, 0xffff, v40
		v_lshrrev_b32_e32 v40, 16, v40
		v_and_b32_e32 v40, 0xffff, v40
		v_and_b32_e32 v64, 0xffff, v41
		v_lshrrev_b32_e32 v41, 16, v41
		v_and_b32_e32 v41, 0xffff, v41
		v_and_b32_e32 v65, 0xffff, v24
		v_lshrrev_b32_e32 v24, 16, v24
		v_and_b32_e32 v24, 0xffff, v24
		v_and_b32_e32 v66, 0xffff, v25
		v_lshrrev_b32_e32 v25, 16, v25
		v_and_b32_e32 v25, 0xffff, v25
		v_and_b32_e32 v67, 0xffff, v37
		v_lshrrev_b32_e32 v37, 16, v37
		v_and_b32_e32 v37, 0xffff, v37
		v_and_b32_e32 v68, 0xffff, v38
		v_lshrrev_b32_e32 v38, 16, v38
		v_and_b32_e32 v38, 0xffff, v38
		s_add_i32 s32, s33, s1
		s_add_i32 s32, s32, s13
		v_lshl_add_u32 v69, v9, 5, s32
		v_add3_u32 v69, v69, v7, v8
		v_lshl_add_u32 v69, v45, 4, v69
		v_lshl_add_u32 v69, v47, 3, v69
		s_and_saveexec_b64 s[100:101], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_66
		buffer_store_short v26, v69, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_66:
		s_andn2_b64 exec, s[100:101], s[8:9]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_66
.Lv9_beyond_hotloop.exec_endif_66:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s8, s0, 0x102
		s_add_i32 s9, s8, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v26, v9, 5, s9
		v_add3_u32 v26, v26, v7, v8
		v_lshl_add_u32 v26, v45, 4, v26
		v_lshl_add_u32 v26, v47, 3, v26
		s_and_saveexec_b64 s[100:101], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_67
		buffer_store_short v2, v26, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_67:
		s_andn2_b64 exec, s[100:101], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_67
.Lv9_beyond_hotloop.exec_endif_67:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s9, s0, 0x104
		s_add_i32 s32, s9, s1
		s_add_i32 s32, s32, s13
		v_lshl_add_u32 v2, v9, 5, s32
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_68
		buffer_store_short v27, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_68:
		s_andn2_b64 exec, s[100:101], s[54:55]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_68
.Lv9_beyond_hotloop.exec_endif_68:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s32, s0, 0x106
		s_add_i32 s52, s32, s1
		s_add_i32 s52, s52, s13
		v_lshl_add_u32 v2, v9, 5, s52
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_69
		buffer_store_short v3, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_69:
		s_andn2_b64 exec, s[100:101], s[56:57]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_69
.Lv9_beyond_hotloop.exec_endif_69:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s52, s0, 0x140
		s_add_i32 s53, s52, s1
		s_add_i32 s53, s53, s13
		v_lshl_add_u32 v2, v9, 5, s53
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_70
		buffer_store_short v36, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_70:
		s_andn2_b64 exec, s[100:101], s[58:59]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_70
.Lv9_beyond_hotloop.exec_endif_70:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s53, s0, 0x142
		s_add_i32 s54, s53, s1
		s_add_i32 s54, s54, s13
		v_lshl_add_u32 v2, v9, 5, s54
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[60:61]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_71
		buffer_store_short v4, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_71:
		s_andn2_b64 exec, s[100:101], s[60:61]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_71
.Lv9_beyond_hotloop.exec_endif_71:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s54, s0, 0x144
		s_add_i32 s55, s54, s1
		s_add_i32 s55, s55, s13
		v_lshl_add_u32 v2, v9, 5, s55
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[62:63]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_72
		buffer_store_short v39, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_72:
		s_andn2_b64 exec, s[100:101], s[62:63]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_72
.Lv9_beyond_hotloop.exec_endif_72:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s55, s0, 0x146
		s_add_i32 s56, s55, s1
		s_add_i32 s56, s56, s13
		v_lshl_add_u32 v2, v9, 5, s56
		v_add3_u32 v2, v2, v7, v8
		v_lshl_add_u32 v2, v45, 4, v2
		v_lshl_add_u32 v2, v47, 3, v2
		s_and_saveexec_b64 s[100:101], s[64:65]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_73
		buffer_store_short v0, v2, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_73:
		s_andn2_b64 exec, s[100:101], s[64:65]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_73
.Lv9_beyond_hotloop.exec_endif_73:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s56, s0, 0x180
		s_add_i32 s57, s56, s1
		s_add_i32 s57, s57, s13
		v_lshl_add_u32 v0, v9, 5, s57
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[66:67]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_74
		buffer_store_short v1, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_74:
		s_andn2_b64 exec, s[100:101], s[66:67]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_74
.Lv9_beyond_hotloop.exec_endif_74:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s57, s0, 0x182
		s_add_i32 s58, s57, s1
		s_add_i32 s58, s58, s13
		v_lshl_add_u32 v0, v9, 5, s58
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[68:69]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_75
		buffer_store_short v5, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_75:
		s_andn2_b64 exec, s[100:101], s[68:69]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_75
.Lv9_beyond_hotloop.exec_endif_75:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s58, s0, 0x184
		s_add_i32 s59, s58, s1
		s_add_i32 s59, s59, s13
		v_lshl_add_u32 v0, v9, 5, s59
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[70:71]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_76
		buffer_store_short v6, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_76:
		s_andn2_b64 exec, s[100:101], s[70:71]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_76
.Lv9_beyond_hotloop.exec_endif_76:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s59, s0, 0x186
		s_add_i32 s60, s59, s1
		s_add_i32 s60, s60, s13
		v_lshl_add_u32 v0, v9, 5, s60
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[72:73]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_77
		buffer_store_short v10, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_77:
		s_andn2_b64 exec, s[100:101], s[72:73]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_77
.Lv9_beyond_hotloop.exec_endif_77:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s60, s0, 0x1c0
		s_add_i32 s61, s60, s1
		s_add_i32 s61, s61, s13
		v_lshl_add_u32 v0, v9, 5, s61
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[74:75]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_78
		buffer_store_short v11, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_78:
		s_andn2_b64 exec, s[100:101], s[74:75]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_78
.Lv9_beyond_hotloop.exec_endif_78:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s61, s0, 0x1c2
		s_add_i32 s62, s61, s1
		s_add_i32 s62, s62, s13
		v_lshl_add_u32 v0, v9, 5, s62
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[76:77]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_79
		buffer_store_short v12, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_79:
		s_andn2_b64 exec, s[100:101], s[76:77]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_79
.Lv9_beyond_hotloop.exec_endif_79:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s62, s0, 0x1c4
		s_add_i32 s63, s62, s1
		s_add_i32 s63, s63, s13
		v_lshl_add_u32 v0, v9, 5, s63
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[78:79]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_80
		buffer_store_short v42, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_80:
		s_andn2_b64 exec, s[100:101], s[78:79]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_80
.Lv9_beyond_hotloop.exec_endif_80:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s0, s0, 0x1c6
		s_add_i32 s63, s0, s1
		s_add_i32 s63, s63, s13
		v_lshl_add_u32 v0, v9, 5, s63
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_81
		buffer_store_short v13, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_81:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_81
.Lv9_beyond_hotloop.exec_endif_81:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s33, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[14:15]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_82
		buffer_store_short v43, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_82:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_82
.Lv9_beyond_hotloop.exec_endif_82:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s8, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[16:17]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_83
		buffer_store_short v14, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_83:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_83
.Lv9_beyond_hotloop.exec_endif_83:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s9, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[18:19]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_84
		buffer_store_short v44, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_84:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_84
.Lv9_beyond_hotloop.exec_endif_84:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s32, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[24:25]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_85
		buffer_store_short v15, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_85:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_85
.Lv9_beyond_hotloop.exec_endif_85:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s52, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[26:27]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_86
		buffer_store_short v46, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_86:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_86
.Lv9_beyond_hotloop.exec_endif_86:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s53, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[28:29]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_87
		buffer_store_short v16, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_87:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_87
.Lv9_beyond_hotloop.exec_endif_87:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s54, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[30:31]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_88
		buffer_store_short v48, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_88:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_88
.Lv9_beyond_hotloop.exec_endif_88:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s55, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[34:35]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_89
		buffer_store_short v17, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_89:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_89
.Lv9_beyond_hotloop.exec_endif_89:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s56, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[36:37]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_90
		buffer_store_short v49, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_90:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_90
.Lv9_beyond_hotloop.exec_endif_90:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s57, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[38:39]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_91
		buffer_store_short v18, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_91:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_91
.Lv9_beyond_hotloop.exec_endif_91:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s58, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[40:41]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_92
		buffer_store_short v50, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_92:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_92
.Lv9_beyond_hotloop.exec_endif_92:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s59, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[42:43]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_93
		buffer_store_short v19, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_93:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_93
.Lv9_beyond_hotloop.exec_endif_93:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s60, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[44:45]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_94
		buffer_store_short v51, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_94:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_94
.Lv9_beyond_hotloop.exec_endif_94:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s61, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[46:47]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_95
		buffer_store_short v20, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_95:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_95
.Lv9_beyond_hotloop.exec_endif_95:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s62, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[48:49]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_96
		buffer_store_short v52, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_96:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_96
.Lv9_beyond_hotloop.exec_endif_96:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s0, s96
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[4:5], s[50:51]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_97
		buffer_store_short v21, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_97:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_97
.Lv9_beyond_hotloop.exec_endif_97:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s33, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[14:15]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_98
		buffer_store_short v53, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_98:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_98
.Lv9_beyond_hotloop.exec_endif_98:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s8, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[16:17]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_99
		buffer_store_short v28, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_99:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_99
.Lv9_beyond_hotloop.exec_endif_99:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s9, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[18:19]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_100
		buffer_store_short v54, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_100:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_100
.Lv9_beyond_hotloop.exec_endif_100:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s32, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[24:25]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_101
		buffer_store_short v29, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_101:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_101
.Lv9_beyond_hotloop.exec_endif_101:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s52, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[26:27]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_102
		buffer_store_short v55, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_102:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_102
.Lv9_beyond_hotloop.exec_endif_102:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s53, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[28:29]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_103
		buffer_store_short v31, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_103:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_103
.Lv9_beyond_hotloop.exec_endif_103:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s54, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[30:31]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_104
		buffer_store_short v56, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_104:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_104
.Lv9_beyond_hotloop.exec_endif_104:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s55, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[34:35]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_105
		buffer_store_short v32, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_105:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_105
.Lv9_beyond_hotloop.exec_endif_105:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s56, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[36:37]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_106
		buffer_store_short v57, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_106:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_106
.Lv9_beyond_hotloop.exec_endif_106:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s57, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[38:39]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_107
		buffer_store_short v22, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_107:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_107
.Lv9_beyond_hotloop.exec_endif_107:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s58, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[40:41]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_108
		buffer_store_short v58, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_108:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_108
.Lv9_beyond_hotloop.exec_endif_108:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s59, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[42:43]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_109
		buffer_store_short v23, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_109:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_109
.Lv9_beyond_hotloop.exec_endif_109:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s60, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[44:45]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_110
		buffer_store_short v59, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_110:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_110
.Lv9_beyond_hotloop.exec_endif_110:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s61, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[46:47]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_111
		buffer_store_short v34, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_111:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_111
.Lv9_beyond_hotloop.exec_endif_111:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s62, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[48:49]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_112
		buffer_store_short v60, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_112:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_112
.Lv9_beyond_hotloop.exec_endif_112:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s0, s97
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[6:7], s[50:51]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_113
		buffer_store_short v35, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_113:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_113
.Lv9_beyond_hotloop.exec_endif_113:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s33, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[14:15]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_114
		buffer_store_short v61, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_114:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_114
.Lv9_beyond_hotloop.exec_endif_114:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s8, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[16:17]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_115
		buffer_store_short v30, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_115:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_115
.Lv9_beyond_hotloop.exec_endif_115:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s9, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[18:19]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_116
		buffer_store_short v62, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_116:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_116
.Lv9_beyond_hotloop.exec_endif_116:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s32, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[24:25]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_117
		buffer_store_short v33, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_117:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_117
.Lv9_beyond_hotloop.exec_endif_117:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s52, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[26:27]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_118
		buffer_store_short v63, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_118:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_118
.Lv9_beyond_hotloop.exec_endif_118:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s53, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[28:29]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_119
		buffer_store_short v40, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_119:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_119
.Lv9_beyond_hotloop.exec_endif_119:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s54, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_b64 s[2:3], s[10:11], s[30:31]
		s_and_saveexec_b64 s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_120
		buffer_store_short v64, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_120:
		s_andn2_b64 exec, s[100:101], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_120
.Lv9_beyond_hotloop.exec_endif_120:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s55, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[80:81]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_121
		buffer_store_short v41, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_121:
		s_andn2_b64 exec, s[100:101], s[80:81]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_121
.Lv9_beyond_hotloop.exec_endif_121:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s56, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[82:83]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_122
		buffer_store_short v65, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_122:
		s_andn2_b64 exec, s[100:101], s[82:83]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_122
.Lv9_beyond_hotloop.exec_endif_122:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s57, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[84:85]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_123
		buffer_store_short v24, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_123:
		s_andn2_b64 exec, s[100:101], s[84:85]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_123
.Lv9_beyond_hotloop.exec_endif_123:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s58, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_124
		buffer_store_short v66, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_124:
		s_andn2_b64 exec, s[100:101], s[86:87]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_124
.Lv9_beyond_hotloop.exec_endif_124:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s59, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_125
		buffer_store_short v25, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_125:
		s_andn2_b64 exec, s[100:101], s[88:89]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_125
.Lv9_beyond_hotloop.exec_endif_125:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s60, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_126
		buffer_store_short v67, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_126:
		s_andn2_b64 exec, s[100:101], s[90:91]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_126
.Lv9_beyond_hotloop.exec_endif_126:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s61, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_127
		buffer_store_short v37, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_127:
		s_andn2_b64 exec, s[100:101], s[92:93]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_127
.Lv9_beyond_hotloop.exec_endif_127:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s2, s62, s12
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v0, v9, 5, s2
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_128
		buffer_store_short v68, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_128:
		s_andn2_b64 exec, s[100:101], s[94:95]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_128
.Lv9_beyond_hotloop.exec_endif_128:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s0, s0, s12
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s13
		v_lshl_add_u32 v0, v9, 5, s0
		v_add3_u32 v0, v0, v7, v8
		v_lshl_add_u32 v0, v45, 4, v0
		v_lshl_add_u32 v0, v47, 3, v0
		s_and_saveexec_b64 s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_129
		buffer_store_short v38, v0, s[20:23], 0 offen
.Lv9_beyond_hotloop.exec_else_129:
		s_andn2_b64 exec, s[100:101], s[98:99]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_129
.Lv9_beyond_hotloop.exec_endif_129:
		s_mov_b64 exec, s[100:101]
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
		.amdhsa_next_free_vgpr 220
		.amdhsa_next_free_sgpr 102
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
	.set .Lv9_beyond_hotloop.numbered_sgpr, 102
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
    .sgpr_count:     102
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     220
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 89
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 176
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
