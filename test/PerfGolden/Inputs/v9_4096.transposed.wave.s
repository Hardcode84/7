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
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s18
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s13, v0
		s_lshr_b32 s13, s13, 6
		s_mul_i32 s13, 0x420, s13
		s_mov_b32 m0, s13
		v_lshrrev_b32_e32 v1, 3, v0
		v_mul_lo_u32 v2, s10, v1
		v_and_b32_e32 v3, 1, v0
		v_lshlrev_b32_e32 v4, 4, v3
		v_lshl_add_u32 v5, v2, 1, v4
		v_lshrrev_b32_e32 v6, 2, v0
		v_and_b32_e32 v7, 1, v6
		v_lshlrev_b32_e32 v8, 6, v7
		v_lshrrev_b32_e32 v9, 1, v0
		v_and_b32_e32 v10, 1, v9
		v_lshlrev_b32_e32 v11, 5, v10
		v_add3_u32 v5, v5, v8, v11
		s_mul_i32 s16, s1, s10
		s_lshl_b32 s16, s16, 11
		s_mul_i32 s17, s14, s10
		s_lshl_b32 s17, s17, 9
		s_add_i32 s28, s16, s17
		v_add_u32_e32 v12, s28, v5
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mul_i32 s15, s15, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s29, s10, 7
		s_add_i32 s30, s29, s16
		s_add_i32 s30, s30, s17
		v_add_u32_e32 v12, s30, v5
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mul_i32 s31, s0, 0x100
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s32, s10, 8
		s_add_i32 s33, s32, s16
		s_add_i32 s33, s33, s17
		v_add_u32_e32 v12, s33, v5
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mul_i32 s34, s0, s11
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s35, s10, s16
		s_add_i32 s35, s35, s17
		v_add_u32_e32 v12, s35, v5
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mul_lo_u32 v12, s11, v1
		s_add_i32 m0, m0, 0xa4e0
		v_lshl_add_u32 v13, v12, 1, v4
		v_add3_u32 v13, v13, v8, v11
		s_lshl_b32 s34, s34, 9
		v_add_u32_e32 v14, s34, v13
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_lshl_b32 s36, s11, 7
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s37, s36, s34
		v_add_u32_e32 v14, s37, v13
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_lshl_b32 s38, s11, 8
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s39, s38, s34
		v_add_u32_e32 v14, s39, v13
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_mul_i32 s11, 0x180, s11
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s40, s11, s34
		v_add_u32_e32 v14, s40, v13
		s_add_i32 s41, s16, 0x80
		s_mov_b32 s42, 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		v_add_u32_e32 v14, s17, v5
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s17, s41, s17
		v_add_u32_e32 v5, s17, v5
		v_add_u32_e32 v14, s16, v14
		v_add_u32_e32 v14, 0x80, v14
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add_u32_e32 v5, s29, v14
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v15, s32, v14
		v_add_u32_e32 v14, s10, v14
		v_lshrrev_b32_e32 v16, 8, v0
		v_cmp_ne_u32_e64 vcc, v16, s42
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add_u32_e32 v5, s34, v13
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v5, 0x80, v5
		v_add_u32_e32 v17, s36, v5
		v_add_u32_e32 v18, s38, v5
		v_add_u32_e32 v5, s11, v5
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_lshrrev_b32_e32 v15, 6, v0
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s10, s34, 0x80
		v_add_u32_e32 v13, s10, v13
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v20, 63, v0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_mov_b32_e32 v14, 0x840
		v_mul_lo_u32 v14, v14, v19
		s_add_i32 m0, m0, 0x62e0
		v_lshrrev_b32_e32 v21, 4, v20
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v13, 4, v21
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v14, v14, v13
		v_and_b32_e32 v20, 15, v20
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_add_u32_e32 v13, 0x10000, v13
		s_add_i32 m0, m0, 0x62e0
		v_lshrrev_b32_e32 v17, 3, v20
		v_mov_b32_e32 v21, 0x420
		v_mul_lo_u32 v21, v21, v17
		v_add_u32_e32 v13, v13, v21
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_lshrrev_b32_e32 v17, 2, v20
		s_add_i32 m0, m0, 0x2100
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 9, v17
		v_add3_u32 v14, v14, v21, v17
		v_lshrrev_b32_e32 v18, 1, v20
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v5, 1, v18
		v_lshlrev_b32_e32 v5, 8, v5
		v_and_b32_e32 v18, 1, v20
		v_lshlrev_b32_e32 v18, 7, v18
		v_add3_u32 v14, v14, v5, v18
		ds_read_b128 v[20:23], v14
		ds_read_b128 v[24:27], v14 offset:64
		ds_read_b128 v[28:31], v14 offset:8448
		ds_read_b128 v[32:35], v14 offset:8512
		ds_read_b128 v[36:39], v14 offset:16896
		ds_read_b128 v[40:43], v14 offset:16960
		ds_read_b128 v[44:47], v14 offset:25344
		ds_read_b128 v[48:51], v14 offset:25408
		v_and_b32_e32 v52, 1, v15
		v_mov_b32_e32 v53, 0x840
		v_mul_lo_u32 v53, v53, v52
		v_add3_u32 v13, v13, v53, v17
		v_add3_u32 v5, v13, v5, v18
		ds_read_b128 v[56:59], v5 offset:2016
		ds_read_b128 v[60:63], v5 offset:2080
		ds_read_b128 v[64:67], v5 offset:6240
		ds_read_b128 v[68:71], v5 offset:6304
		ds_read_b128 v[72:75], v5 offset:10464
		ds_read_b128 v[76:79], v5 offset:10528
		ds_read_b128 v[80:83], v5 offset:14688
		ds_read_b128 v[84:87], v5 offset:14752
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[54:55], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_0
		s_barrier
.Lv9_beyond_hotloop.exec_endif_0:
		s_mov_b64 exec, s[54:55]
		s_setprio 0
		s_mov_b32 s10, 0x80
		s_mov_b32 s11, s10
		v_add3_u32 v4, v4, v8, v11
		v_add_u32_e32 v8, 0x100, v4
		v_lshl_add_u32 v11, v2, 1, s28
		v_add_u32_e32 v13, v8, v11
		v_lshl_add_u32 v17, v2, 1, s30
		v_add_u32_e32 v18, v8, v17
		v_lshl_add_u32 v53, v2, 1, s33
		v_add_u32_e32 v54, v8, v53
		v_lshl_add_u32 v2, v2, 1, s35
		v_add_u32_e32 v55, v8, v2
		v_lshl_add_u32 v88, v12, 1, s34
		v_add_u32_e32 v89, v8, v88
		v_lshl_add_u32 v90, v12, 1, s37
		v_add_u32_e32 v91, v8, v90
		v_lshl_add_u32 v92, v12, 1, s39
		v_add_u32_e32 v93, v8, v92
		v_lshl_add_u32 v12, v12, 1, s40
		v_add_u32_e32 v94, v8, v12
		v_add_u32_e32 v4, 0x180, v4
		v_add_u32_e32 v8, v4, v11
		v_add_u32_e32 v11, v4, v17
		v_add_u32_e32 v17, v4, v53
		v_add_u32_e32 v53, v4, v2
		v_add_u32_e32 v2, v4, v88
		v_add_u32_e32 v88, v4, v90
		v_add_u32_e32 v90, v4, v92
		v_add_u32_e32 v92, v4, v12
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		s_mov_b32 s2, s42
		s_mov_b32 s3, s11
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
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
.Lv9_beyond_hotloop.loop_head_0:
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[44:47], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[44:47], v[152:155]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[48:51], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[48:51], v[152:155]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		ds_read_b128 v[56:59], v5 offset:35776
		ds_read_b128 v[60:63], v5 offset:35840
		ds_read_b128 v[64:67], v5 offset:40000
		ds_read_b128 v[68:71], v5 offset:40064
		ds_read_b128 v[72:75], v5 offset:44224
		ds_read_b128 v[76:79], v5 offset:44288
		ds_read_b128 v[80:83], v5 offset:48448
		ds_read_b128 v[84:87], v5 offset:48512
		s_mov_b32 m0, s13
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v54, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v55, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xa4e0
		s_nop 0
		buffer_load_dwordx4 v89, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v91, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[80:83], v[44:47], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[44:47], v[216:219]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[84:87], v[48:51], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[48:51], v[216:219]
		s_setprio 1
		s_barrier
		ds_read_b128 v[20:23], v14 offset:33792
		ds_read_b128 v[24:27], v14 offset:33856
		ds_read_b128 v[28:31], v14 offset:42240
		ds_read_b128 v[32:35], v14 offset:42304
		ds_read_b128 v[36:39], v14 offset:50688
		ds_read_b128 v[40:43], v14 offset:50752
		ds_read_b128 v[44:47], v14 offset:59136
		ds_read_b128 v[48:51], v14 offset:59200
		ds_read_b128 v[56:59], v5 offset:18912
		ds_read_b128 v[60:63], v5 offset:18976
		ds_read_b128 v[64:67], v5 offset:23136
		ds_read_b128 v[68:71], v5 offset:23200
		ds_read_b128 v[72:75], v5 offset:27360
		ds_read_b128 v[76:79], v5 offset:27424
		ds_read_b128 v[80:83], v5 offset:31584
		ds_read_b128 v[84:87], v5 offset:31648
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v93, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[44:47], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[44:47], v[152:155]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[48:51], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[48:51], v[152:155]
		s_setprio 1
		s_barrier
		ds_read_b128 v[56:59], v5 offset:52672
		ds_read_b128 v[60:63], v5 offset:52736
		ds_read_b128 v[64:67], v5 offset:56896
		ds_read_b128 v[68:71], v5 offset:56960
		ds_read_b128 v[72:75], v5 offset:61120
		ds_read_b128 v[76:79], v5 offset:61184
		ds_read_b128 v[80:83], v5 offset:65344
		ds_read_b128 v[84:87], v5 offset:65408
		s_add_i32 m0, m0, 0xfffed740
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v53, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v88, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[80:83], v[44:47], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[44:47], v[216:219]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[84:87], v[48:51], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[48:51], v[216:219]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[20:23], v14
		ds_read_b128 v[24:27], v14 offset:64
		ds_read_b128 v[28:31], v14 offset:8448
		ds_read_b128 v[32:35], v14 offset:8512
		ds_read_b128 v[36:39], v14 offset:16896
		ds_read_b128 v[40:43], v14 offset:16960
		ds_read_b128 v[44:47], v14 offset:25344
		ds_read_b128 v[48:51], v14 offset:25408
		ds_read_b128 v[56:59], v5 offset:2016
		ds_read_b128 v[60:63], v5 offset:2080
		ds_read_b128 v[64:67], v5 offset:6240
		ds_read_b128 v[68:71], v5 offset:6304
		ds_read_b128 v[72:75], v5 offset:10464
		ds_read_b128 v[76:79], v5 offset:10528
		ds_read_b128 v[80:83], v5 offset:14688
		ds_read_b128 v[84:87], v5 offset:14752
		s_add_i32 m0, m0, 0x62e0
		s_nop 0
		buffer_load_dwordx4 v90, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v92, s[24:27], 0 offen lds
		s_setprio 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s11, s11, 0x80
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
		v_cmp_eq_u32_e64 vcc, v16, s42
		s_and_saveexec_b64 s[54:55], vcc
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_1
		s_barrier
.Lv9_beyond_hotloop.exec_endif_1:
		s_mov_b64 exec, s[54:55]
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[44:47], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[44:47], v[152:155]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[48:51], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[48:51], v[152:155]
		ds_read_b128 v[56:59], v5 offset:35776
		ds_read_b128 v[60:63], v5 offset:35840
		ds_read_b128 v[64:67], v5 offset:40000
		ds_read_b128 v[68:71], v5 offset:40064
		ds_read_b128 v[72:75], v5 offset:44224
		ds_read_b128 v[76:79], v5 offset:44288
		ds_read_b128 v[80:83], v5 offset:48448
		ds_read_b128 v[84:87], v5 offset:48512
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[20:23], v[160:163]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[20:23], v[164:167]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[20:23], v[168:171]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[80:83], v[44:47], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[44:47], v[216:219]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[24:27], v[168:171]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[84:87], v[48:51], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[48:51], v[216:219]
		ds_read_b128 v[20:23], v14 offset:33792
		ds_read_b128 v[24:27], v14 offset:33856
		ds_read_b128 v[28:31], v14 offset:42240
		ds_read_b128 v[32:35], v14 offset:42304
		ds_read_b128 v[36:39], v14 offset:50688
		ds_read_b128 v[40:43], v14 offset:50752
		ds_read_b128 v[44:47], v14 offset:59136
		ds_read_b128 v[48:51], v14 offset:59200
		ds_read_b128 v[56:59], v5 offset:18912
		ds_read_b128 v[60:63], v5 offset:18976
		ds_read_b128 v[64:67], v5 offset:23136
		ds_read_b128 v[68:71], v5 offset:23200
		ds_read_b128 v[72:75], v5 offset:27360
		ds_read_b128 v[76:79], v5 offset:27424
		ds_read_b128 v[80:83], v5 offset:31584
		ds_read_b128 v[84:87], v5 offset:31648
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[96:99], v[56:59], v[20:23], v[96:99]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[100:103], v[64:67], v[20:23], v[100:103]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[20:23], v[104:107]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[108:111], v[80:83], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[80:83], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[64:67], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[64:67], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[80:83], v[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[80:83], v[44:47], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[44:47], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[44:47], v[152:155]
		v_mfma_f32_16x16x32_f16 v[96:99], v[60:63], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[76:79], v[24:27], v[104:107]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[108:111], v[84:87], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[84:87], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[112:115], v[60:63], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[76:79], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[136:139], v[76:79], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[140:143], v[84:87], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[84:87], v[48:51], v[156:159]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[76:79], v[48:51], v[152:155]
		ds_read_b128 v[56:59], v5 offset:52672
		ds_read_b128 v[60:63], v5 offset:52736
		ds_read_b128 v[64:67], v5 offset:56896
		ds_read_b128 v[68:71], v5 offset:56960
		ds_read_b128 v[72:75], v5 offset:61120
		ds_read_b128 v[76:79], v5 offset:61184
		ds_read_b128 v[80:83], v5 offset:65344
		ds_read_b128 v[84:87], v5 offset:65408
		v_cvt_pk_f16_f32 v4, v96, v97
		v_cvt_pk_f16_f32 v5, v98, v99
		v_cvt_pk_f16_f32 v12, v100, v101
		v_cvt_pk_f16_f32 v13, v102, v103
		v_cvt_pk_f16_f32 v54, v104, v105
		v_cvt_pk_f16_f32 v55, v106, v107
		v_cvt_pk_f16_f32 v88, v108, v109
		v_cvt_pk_f16_f32 v89, v110, v111
		v_cvt_pk_f16_f32 v90, v112, v113
		v_cvt_pk_f16_f32 v91, v114, v115
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
		v_and_b32_e32 v2, 1, v0
		v_and_b32_e32 v8, 1, v9
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v6
		v_bitop3_b32 v6, v2, v9, v8 bitop3:0x96
		v_and_b32_e32 v11, 1, v1
		v_mov_b32_e32 v14, 8
		v_mul_lo_u32 v14, v14, v11
		v_and_b32_e32 v11, 1, v19
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v11
		v_bitop3_b32 v6, v6, v14, v17 bitop3:0x96
		v_and_b32_e32 v11, 1, v16
		v_mov_b32_e32 v16, 32
		v_mul_lo_u32 v16, v16, v11
		v_xad_u32 v6, v6, v16, s15
		v_bitop3_b32 v11, 64, v2, v9 bitop3:0x96
		v_xor_b32_e32 v11, v11, v8
		v_bitop3_b32 v11, v11, v14, v17 bitop3:0x96
		v_xad_u32 v11, v11, v16, s15
		v_xor_b32_e32 v18, 0x80, v2
		v_xor_b32_e32 v18, v18, v9
		v_xor_b32_e32 v18, v18, v8
		v_bitop3_b32 v18, v18, v14, v17 bitop3:0x96
		v_xad_u32 v18, v18, v16, s15
		v_xor_b32_e32 v2, 0xc0, v2
		v_xor_b32_e32 v2, v2, v9
		v_xor_b32_e32 v2, v2, v8
		v_bitop3_b32 v2, v2, v14, v17 bitop3:0x96
		v_xad_u32 v2, v2, v16, s15
		v_cmp_lt_i32_e64 s[2:3], v6, s8
		v_cmp_lt_i32_e64 s[4:5], v11, s8
		v_cmp_lt_i32_e64 s[6:7], v18, s8
		v_cmp_lt_i32_e64 s[10:11], v2, s8
		v_lshrrev_b32_e32 v2, 4, v0
		v_and_b32_e32 v6, 1, v2
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v6
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v6, 1, v0
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v6
		v_and_b32_e32 v6, 1, v15
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v6
		v_bitop3_b32 v6, v8, v9, v11 bitop3:0x96
		v_add_u32_e32 v14, s31, v6
		v_bitop3_b32 v15, 32, v8, v9 bitop3:0x96
		v_xor_b32_e32 v15, v15, v11
		v_add_u32_e32 v16, s31, v15
		v_bitop3_b32 v17, 64, v8, v9 bitop3:0x96
		v_xor_b32_e32 v17, v17, v11
		v_add_u32_e32 v18, s31, v17
		v_xor_b32_e32 v8, 0x60, v8
		v_xor_b32_e32 v8, v8, v9
		v_xor_b32_e32 v8, v8, v11
		v_add_u32_e32 v9, s31, v8
		v_cmp_lt_i32_e64 s[20:21], v14, s9
		v_cmp_lt_i32_e64 s[22:23], v16, s9
		v_cmp_lt_i32_e64 s[24:25], v18, s9
		v_cmp_lt_i32_e64 s[26:27], v9, s9
		s_and_b64 s[28:29], s[2:3], s[20:21]
		s_and_b64 s[32:33], s[2:3], s[22:23]
		s_and_b64 s[34:35], s[2:3], s[24:25]
		s_and_b64 s[36:37], s[2:3], s[26:27]
		s_and_b64 s[38:39], s[4:5], s[20:21]
		s_and_b64 s[40:41], s[4:5], s[22:23]
		s_and_b64 s[42:43], s[4:5], s[24:25]
		s_and_b64 s[44:45], s[4:5], s[26:27]
		s_and_b64 s[46:47], s[6:7], s[20:21]
		s_and_b64 s[48:49], s[6:7], s[22:23]
		s_and_b64 s[50:51], s[6:7], s[24:25]
		s_and_b64 s[52:53], s[6:7], s[26:27]
		s_and_b64 s[20:21], s[10:11], s[20:21]
		s_and_b64 s[22:23], s[10:11], s[22:23]
		s_and_b64 s[24:25], s[10:11], s[24:25]
		s_and_b64 s[26:27], s[10:11], s[26:27]
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s8, s1, s12
		s_lshl_b32 s8, s8, 11
		s_add_i32 s13, s0, s8
		s_mul_i32 s15, s14, s12
		s_lshl_b32 s15, s15, 9
		s_add_i32 s13, s13, s15
		v_mul_lo_u32 v9, s12, v19
		v_lshl_add_u32 v11, v9, 5, s13
		v_mul_lo_u32 v14, s12, v3
		v_lshl_add_u32 v11, v14, 1, v11
		v_and_b32_e32 v1, 1, v1
		v_mul_lo_u32 v16, s12, v1
		v_lshl_add_u32 v11, v16, 4, v11
		v_mul_lo_u32 v18, s12, v7
		v_lshl_add_u32 v11, v18, 3, v11
		v_mul_lo_u32 v53, s12, v10
		v_lshl_add_u32 v11, v53, 2, v11
		v_lshl_add_u32 v11, v52, 5, v11
		v_and_b32_e32 v0, 1, v0
		v_lshl_add_u32 v11, v0, 4, v11
		v_and_b32_e32 v2, 1, v2
		v_lshl_add_u32 v11, v2, 3, v11
		s_and_saveexec_b64 s[54:55], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_2
		buffer_store_dwordx2 v[4:5], v11, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_2:
		s_andn2_b64 exec, s[54:55], s[28:29]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_2
.Lv9_beyond_hotloop.exec_endif_2:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s13, s0, 64
		s_add_i32 s13, s13, s8
		s_add_i32 s13, s13, s15
		v_lshl_add_u32 v4, v9, 5, s13
		v_lshl_add_u32 v4, v14, 1, v4
		v_lshl_add_u32 v4, v16, 4, v4
		v_lshl_add_u32 v4, v18, 3, v4
		v_lshl_add_u32 v4, v53, 2, v4
		v_lshl_add_u32 v4, v52, 5, v4
		v_lshl_add_u32 v4, v0, 4, v4
		v_lshl_add_u32 v4, v2, 3, v4
		s_and_saveexec_b64 s[54:55], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_3
		buffer_store_dwordx2 v[12:13], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_3:
		s_andn2_b64 exec, s[54:55], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_3
.Lv9_beyond_hotloop.exec_endif_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s13, s0, 0x80
		s_add_i32 s13, s13, s8
		s_add_i32 s13, s13, s15
		v_lshl_add_u32 v4, v9, 5, s13
		v_lshl_add_u32 v4, v14, 1, v4
		v_lshl_add_u32 v4, v16, 4, v4
		v_lshl_add_u32 v4, v18, 3, v4
		v_lshl_add_u32 v4, v53, 2, v4
		v_lshl_add_u32 v4, v52, 5, v4
		v_lshl_add_u32 v4, v0, 4, v4
		v_lshl_add_u32 v4, v2, 3, v4
		s_and_saveexec_b64 s[54:55], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_4
		buffer_store_dwordx2 v[54:55], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_4:
		s_andn2_b64 exec, s[54:55], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_4
.Lv9_beyond_hotloop.exec_endif_4:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s13, s0, 0xc0
		s_add_i32 s13, s13, s8
		s_add_i32 s13, s13, s15
		v_lshl_add_u32 v4, v9, 5, s13
		v_lshl_add_u32 v4, v14, 1, v4
		v_lshl_add_u32 v4, v16, 4, v4
		v_lshl_add_u32 v4, v18, 3, v4
		v_lshl_add_u32 v4, v53, 2, v4
		v_lshl_add_u32 v4, v52, 5, v4
		v_lshl_add_u32 v4, v0, 4, v4
		v_lshl_add_u32 v4, v2, 3, v4
		s_and_saveexec_b64 s[54:55], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_5
		buffer_store_dwordx2 v[88:89], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_5:
		s_andn2_b64 exec, s[54:55], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_5
.Lv9_beyond_hotloop.exec_endif_5:
		s_mov_b64 exec, s[54:55]
		s_lshl_b32 s13, s12, 7
		s_add_i32 s28, s0, s13
		s_add_i32 s28, s28, s8
		s_add_i32 s28, s28, s15
		v_lshl_add_u32 v4, v9, 5, s28
		v_lshl_add_u32 v4, v14, 1, v4
		v_lshl_add_u32 v4, v16, 4, v4
		v_lshl_add_u32 v4, v18, 3, v4
		v_lshl_add_u32 v4, v53, 2, v4
		v_lshl_add_u32 v4, v52, 5, v4
		v_lshl_add_u32 v4, v0, 4, v4
		v_lshl_add_u32 v4, v2, 3, v4
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_6
		buffer_store_dwordx2 v[90:91], v4, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_6:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_6
.Lv9_beyond_hotloop.exec_endif_6:
		s_mov_b64 exec, s[54:55]
		s_lshl_b32 s1, s1, 2
		s_add_i32 s1, s1, s14
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 9
		s_add_i32 s1, s0, s1
		v_lshlrev_b32_e32 v4, 4, v19
		v_add3_u32 v5, 64, v4, v3
		v_lshl_add_u32 v5, v1, 3, v5
		v_lshl_add_u32 v5, v7, 2, v5
		v_lshl_add_u32 v5, v10, 1, v5
		v_mul_lo_u32 v5, s12, v5
		v_lshl_add_u32 v5, v5, 1, s1
		v_lshl_add_u32 v11, v2, 2, 32
		v_lshlrev_b32_e32 v12, 3, v0
		v_lshlrev_b32_e32 v13, 4, v52
		v_bitop3_b32 v11, v11, v12, v13 bitop3:0x96
		v_lshl_add_u32 v19, v11, 1, v5
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_7
		buffer_store_dwordx2 v[92:93], v19, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_7:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_7
.Lv9_beyond_hotloop.exec_endif_7:
		s_mov_b64 exec, s[54:55]
		v_lshl_add_u32 v19, v2, 2, 64
		v_bitop3_b32 v19, v19, v12, v13 bitop3:0x96
		v_lshl_add_u32 v54, v19, 1, v5
		s_and_saveexec_b64 s[54:55], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_8
		buffer_store_dwordx2 v[94:95], v54, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_8:
		s_andn2_b64 exec, s[54:55], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_8
.Lv9_beyond_hotloop.exec_endif_8:
		s_mov_b64 exec, s[54:55]
		v_lshlrev_b32_e32 v54, 2, v2
		v_add_u32_e32 v54, 0x60, v54
		v_bitop3_b32 v12, v54, v12, v13 bitop3:0x96
		v_lshl_add_u32 v5, v12, 1, v5
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_9
		buffer_store_dwordx2 v[96:97], v5, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_9:
		s_andn2_b64 exec, s[54:55], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_9
.Lv9_beyond_hotloop.exec_endif_9:
		s_mov_b64 exec, s[54:55]
		s_lshl_b32 s14, s12, 8
		s_add_i32 s28, s0, s14
		s_add_i32 s28, s28, s8
		s_add_i32 s28, s28, s15
		v_lshl_add_u32 v5, v9, 5, s28
		v_lshl_add_u32 v5, v14, 1, v5
		v_lshl_add_u32 v5, v16, 4, v5
		v_lshl_add_u32 v5, v18, 3, v5
		v_lshl_add_u32 v5, v53, 2, v5
		v_lshl_add_u32 v5, v52, 5, v5
		v_lshl_add_u32 v5, v0, 4, v5
		v_lshl_add_u32 v5, v2, 3, v5
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_10
		buffer_store_dwordx2 v[98:99], v5, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_10:
		s_andn2_b64 exec, s[54:55], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_10
.Lv9_beyond_hotloop.exec_endif_10:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v5, 0x80, v4
		v_add_u32_e32 v5, v5, v3
		v_lshl_add_u32 v5, v1, 3, v5
		v_lshl_add_u32 v5, v7, 2, v5
		v_lshl_add_u32 v5, v10, 1, v5
		v_mul_lo_u32 v5, s12, v5
		v_lshl_add_u32 v5, v5, 1, s1
		v_lshl_add_u32 v13, v11, 1, v5
		s_and_saveexec_b64 s[54:55], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_11
		buffer_store_dwordx2 v[100:101], v13, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_11:
		s_andn2_b64 exec, s[54:55], s[48:49]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_11
.Lv9_beyond_hotloop.exec_endif_11:
		s_mov_b64 exec, s[54:55]
		v_lshl_add_u32 v13, v19, 1, v5
		s_and_saveexec_b64 s[54:55], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_12
		buffer_store_dwordx2 v[102:103], v13, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_12:
		s_andn2_b64 exec, s[54:55], s[50:51]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_12
.Lv9_beyond_hotloop.exec_endif_12:
		s_mov_b64 exec, s[54:55]
		v_lshl_add_u32 v5, v12, 1, v5
		s_and_saveexec_b64 s[54:55], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_13
		buffer_store_dwordx2 v[104:105], v5, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_13:
		s_andn2_b64 exec, s[54:55], s[52:53]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_13
.Lv9_beyond_hotloop.exec_endif_13:
		s_mov_b64 exec, s[54:55]
		s_mul_i32 s28, 0x180, s12
		s_add_i32 s29, s0, s28
		s_add_i32 s29, s29, s8
		s_add_i32 s29, s29, s15
		v_lshl_add_u32 v5, v9, 5, s29
		v_lshl_add_u32 v5, v14, 1, v5
		v_lshl_add_u32 v5, v16, 4, v5
		v_lshl_add_u32 v5, v18, 3, v5
		v_lshl_add_u32 v5, v53, 2, v5
		v_lshl_add_u32 v5, v52, 5, v5
		v_lshl_add_u32 v5, v0, 4, v5
		v_lshl_add_u32 v5, v2, 3, v5
		s_and_saveexec_b64 s[54:55], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_14
		buffer_store_dwordx2 v[106:107], v5, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_14:
		s_andn2_b64 exec, s[54:55], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_14
.Lv9_beyond_hotloop.exec_endif_14:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v4, 0xc0, v4
		v_add_u32_e32 v3, v4, v3
		v_lshl_add_u32 v1, v1, 3, v3
		v_lshl_add_u32 v1, v7, 2, v1
		v_lshl_add_u32 v1, v10, 1, v1
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v1, v1, 1, s1
		v_lshl_add_u32 v3, v11, 1, v1
		s_and_saveexec_b64 s[54:55], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_15
		buffer_store_dwordx2 v[108:109], v3, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_15:
		s_andn2_b64 exec, s[54:55], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_15
.Lv9_beyond_hotloop.exec_endif_15:
		s_mov_b64 exec, s[54:55]
		v_lshl_add_u32 v3, v19, 1, v1
		s_and_saveexec_b64 s[54:55], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_16
		buffer_store_dwordx2 v[110:111], v3, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_16:
		s_andn2_b64 exec, s[54:55], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_16
.Lv9_beyond_hotloop.exec_endif_16:
		s_mov_b64 exec, s[54:55]
		v_lshl_add_u32 v1, v12, 1, v1
		s_and_saveexec_b64 s[54:55], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_17
		buffer_store_dwordx2 v[112:113], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_17:
		s_andn2_b64 exec, s[54:55], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_17
.Lv9_beyond_hotloop.exec_endif_17:
		s_mov_b64 exec, s[54:55]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[20:23], v[160:163]
		s_add_i32 s1, s31, 0x80
		v_add_u32_e32 v1, s1, v6
		v_add_u32_e32 v3, s1, v15
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[20:23], v[164:167]
		v_cmp_lt_i32_e64 s[20:21], v1, s9
		v_cmp_lt_i32_e64 s[22:23], v3, s9
		v_add_u32_e32 v1, s1, v17
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[20:23], v[168:171]
		v_cmp_lt_i32_e64 s[24:25], v1, s9
		v_add_u32_e32 v1, s1, v8
		s_and_b64 s[26:27], s[2:3], s[20:21]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[172:175], v[80:83], v[20:23], v[172:175]
		v_cmp_lt_i32_e64 s[30:31], v1, s9
		s_and_b64 s[32:33], s[2:3], s[22:23]
		s_and_b64 s[34:35], s[2:3], s[24:25]
		v_mfma_f32_16x16x32_f16 v[188:191], v[80:83], v[28:31], v[188:191]
		s_and_b64 s[2:3], s[2:3], s[30:31]
		s_and_b64 s[36:37], s[4:5], s[20:21]
		s_and_b64 s[38:39], s[4:5], s[22:23]
		v_mfma_f32_16x16x32_f16 v[176:179], v[56:59], v[28:31], v[176:179]
		s_and_b64 s[40:41], s[4:5], s[24:25]
		s_and_b64 s[4:5], s[4:5], s[30:31]
		s_and_b64 s[42:43], s[6:7], s[20:21]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[28:31], v[180:183]
		s_and_b64 s[44:45], s[6:7], s[22:23]
		s_and_b64 s[46:47], s[6:7], s[24:25]
		s_and_b64 s[6:7], s[6:7], s[30:31]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[28:31], v[184:187]
		s_and_b64 s[20:21], s[10:11], s[20:21]
		s_and_b64 s[22:23], s[10:11], s[22:23]
		s_and_b64 s[24:25], s[10:11], s[24:25]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[36:39], v[200:203]
		s_and_b64 s[10:11], s[10:11], s[30:31]
		s_add_i32 s1, s0, 0x100
		s_add_i32 s9, s1, s8
		v_mfma_f32_16x16x32_f16 v[192:195], v[56:59], v[36:39], v[192:195]
		s_add_i32 s9, s9, s15
		v_lshl_add_u32 v1, v9, 5, s9
		v_lshl_add_u32 v1, v14, 1, v1
		v_mfma_f32_16x16x32_f16 v[196:199], v[64:67], v[36:39], v[196:199]
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_mfma_f32_16x16x32_f16 v[204:207], v[80:83], v[36:39], v[204:207]
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		v_mfma_f32_16x16x32_f16 v[220:223], v[80:83], v[44:47], v[220:223]
		v_mfma_f32_16x16x32_f16 v[208:211], v[56:59], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[64:67], v[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[44:47], v[216:219]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[76:79], v[24:27], v[168:171]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[172:175], v[84:87], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[84:87], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[76:79], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[200:203], v[76:79], v[40:43], v[200:203]
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		v_cvt_pk_f16_f32 v6, v164, v165
		v_mfma_f32_16x16x32_f16 v[192:195], v[60:63], v[40:43], v[192:195]
		v_cvt_pk_f16_f32 v7, v166, v167
		v_cvt_pk_f16_f32 v10, v168, v169
		v_cvt_pk_f16_f32 v11, v170, v171
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[40:43], v[196:199]
		v_cvt_pk_f16_f32 v12, v172, v173
		v_cvt_pk_f16_f32 v13, v174, v175
		v_cvt_pk_f16_f32 v20, v176, v177
		v_mfma_f32_16x16x32_f16 v[204:207], v[84:87], v[40:43], v[204:207]
		v_cvt_pk_f16_f32 v21, v178, v179
		v_cvt_pk_f16_f32 v22, v180, v181
		v_cvt_pk_f16_f32 v23, v182, v183
		v_mfma_f32_16x16x32_f16 v[220:223], v[84:87], v[48:51], v[220:223]
		v_cvt_pk_f16_f32 v24, v184, v185
		v_cvt_pk_f16_f32 v25, v186, v187
		v_cvt_pk_f16_f32 v26, v188, v189
		v_mfma_f32_16x16x32_f16 v[208:211], v[60:63], v[48:51], v[208:211]
		v_cvt_pk_f16_f32 v27, v190, v191
		v_cvt_pk_f16_f32 v28, v192, v193
		v_cvt_pk_f16_f32 v29, v194, v195
		v_mfma_f32_16x16x32_f16 v[212:215], v[68:71], v[48:51], v[212:215]
		v_cvt_pk_f16_f32 v30, v196, v197
		v_cvt_pk_f16_f32 v31, v198, v199
		v_cvt_pk_f16_f32 v32, v200, v201
		v_mfma_f32_16x16x32_f16 v[216:219], v[76:79], v[48:51], v[216:219]
		v_cvt_pk_f16_f32 v33, v202, v203
		v_cvt_pk_f16_f32 v34, v204, v205
		v_cvt_pk_f16_f32 v35, v206, v207
		v_cvt_pk_f16_f32 v36, v208, v209
		v_cvt_pk_f16_f32 v37, v210, v211
		v_cvt_pk_f16_f32 v38, v212, v213
		v_cvt_pk_f16_f32 v39, v214, v215
		v_cvt_pk_f16_f32 v40, v220, v221
		v_cvt_pk_f16_f32 v42, v216, v217
		v_cvt_pk_f16_f32 v43, v218, v219
		v_cvt_pk_f16_f32 v41, v222, v223
		s_and_saveexec_b64 s[54:55], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_18
		buffer_store_dwordx2 v[4:5], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_18:
		s_andn2_b64 exec, s[54:55], s[26:27]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_18
.Lv9_beyond_hotloop.exec_endif_18:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s9, s0, 0x140
		s_add_i32 s12, s9, s8
		s_add_i32 s12, s12, s15
		v_lshl_add_u32 v1, v9, 5, s12
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_19
		buffer_store_dwordx2 v[6:7], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_19:
		s_andn2_b64 exec, s[54:55], s[32:33]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_19
.Lv9_beyond_hotloop.exec_endif_19:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s12, s0, 0x180
		s_add_i32 s26, s12, s8
		s_add_i32 s26, s26, s15
		v_lshl_add_u32 v1, v9, 5, s26
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_20
		buffer_store_dwordx2 v[10:11], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_20:
		s_andn2_b64 exec, s[54:55], s[34:35]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_20
.Lv9_beyond_hotloop.exec_endif_20:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s0, s0, 0x1c0
		s_add_i32 s26, s0, s8
		s_add_i32 s26, s26, s15
		v_lshl_add_u32 v1, v9, 5, s26
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_21
		buffer_store_dwordx2 v[12:13], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_21:
		s_andn2_b64 exec, s[54:55], s[2:3]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_21
.Lv9_beyond_hotloop.exec_endif_21:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s1, s13
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_22
		buffer_store_dwordx2 v[20:21], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_22:
		s_andn2_b64 exec, s[54:55], s[36:37]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_22
.Lv9_beyond_hotloop.exec_endif_22:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s9, s13
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_23
		buffer_store_dwordx2 v[22:23], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_23:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_23
.Lv9_beyond_hotloop.exec_endif_23:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s12, s13
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_24
		buffer_store_dwordx2 v[24:25], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_24:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_24
.Lv9_beyond_hotloop.exec_endif_24:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s0, s13
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_25
		buffer_store_dwordx2 v[26:27], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_25:
		s_andn2_b64 exec, s[54:55], s[4:5]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_25
.Lv9_beyond_hotloop.exec_endif_25:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s1, s14
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_26
		buffer_store_dwordx2 v[28:29], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_26:
		s_andn2_b64 exec, s[54:55], s[42:43]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_26
.Lv9_beyond_hotloop.exec_endif_26:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s9, s14
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_27
		buffer_store_dwordx2 v[30:31], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_27:
		s_andn2_b64 exec, s[54:55], s[44:45]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_27
.Lv9_beyond_hotloop.exec_endif_27:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s12, s14
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_28
		buffer_store_dwordx2 v[32:33], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_28:
		s_andn2_b64 exec, s[54:55], s[46:47]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_28
.Lv9_beyond_hotloop.exec_endif_28:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s2, s0, s14
		s_add_i32 s2, s2, s8
		s_add_i32 s2, s2, s15
		v_lshl_add_u32 v1, v9, 5, s2
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_29
		buffer_store_dwordx2 v[34:35], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_29:
		s_andn2_b64 exec, s[54:55], s[6:7]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_29
.Lv9_beyond_hotloop.exec_endif_29:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s1, s1, s28
		s_add_i32 s1, s1, s8
		s_add_i32 s1, s1, s15
		v_lshl_add_u32 v1, v9, 5, s1
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_30
		buffer_store_dwordx2 v[36:37], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_30:
		s_andn2_b64 exec, s[54:55], s[20:21]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_30
.Lv9_beyond_hotloop.exec_endif_30:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s1, s9, s28
		s_add_i32 s1, s1, s8
		s_add_i32 s1, s1, s15
		v_lshl_add_u32 v1, v9, 5, s1
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_31
		buffer_store_dwordx2 v[38:39], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_31:
		s_andn2_b64 exec, s[54:55], s[22:23]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_31
.Lv9_beyond_hotloop.exec_endif_31:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s1, s12, s28
		s_add_i32 s1, s1, s8
		s_add_i32 s1, s1, s15
		v_lshl_add_u32 v1, v9, 5, s1
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v1, v0, 4, v1
		v_lshl_add_u32 v1, v2, 3, v1
		s_and_saveexec_b64 s[54:55], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_32
		buffer_store_dwordx2 v[42:43], v1, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_32:
		s_andn2_b64 exec, s[54:55], s[24:25]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_32
.Lv9_beyond_hotloop.exec_endif_32:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s0, s0, s28
		s_add_i32 s0, s0, s8
		s_add_i32 s0, s0, s15
		v_lshl_add_u32 v1, v9, 5, s0
		v_lshl_add_u32 v1, v14, 1, v1
		v_lshl_add_u32 v1, v16, 4, v1
		v_lshl_add_u32 v1, v18, 3, v1
		v_lshl_add_u32 v1, v53, 2, v1
		v_lshl_add_u32 v1, v52, 5, v1
		v_lshl_add_u32 v0, v0, 4, v1
		v_lshl_add_u32 v0, v2, 3, v0
		s_and_saveexec_b64 s[54:55], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_else_33
		buffer_store_dwordx2 v[40:41], v0, s[16:19], 0 offen
.Lv9_beyond_hotloop.exec_else_33:
		s_andn2_b64 exec, s[54:55], s[10:11]
		s_cbranch_execz .Lv9_beyond_hotloop.exec_endif_33
.Lv9_beyond_hotloop.exec_endif_33:
		s_mov_b64 exec, s[54:55]
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
		.amdhsa_next_free_vgpr 224
		.amdhsa_next_free_sgpr 56
		.amdhsa_accum_offset 224
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
	.set .Lv9_beyond_hotloop.num_vgpr, 224
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 56
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
    .sgpr_count:     56
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     224
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
