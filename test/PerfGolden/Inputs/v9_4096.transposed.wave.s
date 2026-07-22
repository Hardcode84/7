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
		s_lshr_b32 s0, s0, 8
		s_add_i32 s1, s9, 0xff
		s_lshr_b32 s1, s1, 8
		s_and_b32 s14, s13, 7
		s_lshr_b32 s13, s13, 3
		s_mul_i32 s14, s14, 32
		s_add_i32 s13, s14, s13
		s_mul_i32 s1, s1, 4
		v_mov_b32_e32 v1, s1
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s14, s1, -1
		v_readfirstlane_b32 s15, v1
		s_add_i32 s14, s14, 1
		s_mul_i32 s16, s14, s15
		s_mul_hi_u32 s16, s15, s16
		s_add_i32 s15, s15, s16
		s_mul_hi_u32 s15, s13, s15
		s_mul_i32 s16, s15, s1
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s13, s13, s16
		s_cmp_ge_u32 s13, s1
		s_cselect_b32 s16, 1, 0
		s_add_i32 s17, s15, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s15, s17, s15
		s_cselect_b32 s16, 1, 0
		s_add_i32 s17, s13, s14
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s17, s13
		s_cmp_ge_u32 s13, s1
		s_cselect_b32 s1, 1, 0
		s_add_i32 s16, s15, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s16, s15
		s_mul_i32 s15, s1, 4
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s17, s15, -1
		s_add_i32 s17, s17, 1
		s_add_i32 s0, s0, s17
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s14, s13, s14
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s13, s14, s13
		v_mov_b32_e32 v1, s0
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		s_xor_b32 s14, s0, -1
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_add_i32 s14, s14, 1
		v_readfirstlane_b32 s16, v1
		s_mul_i32 s17, s14, s16
		s_mul_hi_u32 s17, s16, s17
		s_add_i32 s16, s16, s17
		s_mul_hi_u32 s16, s13, s16
		s_mul_i32 s16, s16, s0
		s_xor_b32 s16, s16, -1
		s_add_i32 s16, s16, 1
		s_add_i32 s16, s13, s16
		s_add_i32 s17, s16, s14
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s17, s16
		s_add_i32 s17, s16, s14
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s16, s17, s16
		s_add_i32 s15, s15, s16
		v_readfirstlane_b32 s17, v1
		s_mul_i32 s18, s14, s17
		s_mul_hi_u32 s18, s17, s18
		s_add_i32 s17, s17, s18
		s_mul_hi_u32 s17, s13, s17
		s_mul_i32 s18, s17, s0
		s_xor_b32 s18, s18, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s13, s13, s18
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s18, 1, 0
		s_add_i32 s19, s17, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s17, s19, s17
		s_cselect_b32 s18, 1, 0
		s_add_i32 s14, s13, s14
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s13, s14, s13
		s_add_i32 s14, s17, 1
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s0, s14, s17
		s_mul_i32 s13, s15, 0x100
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v2, 1, v0
		v_lshrrev_b32_e32 v3, 1, v0
		v_and_b32_e32 v4, 1, v3
		v_mad_u32_u24 v2, v4, 2, v2
		v_lshrrev_b32_e32 v4, 2, v0
		v_and_b32_e32 v5, 1, v4
		v_mad_u32_u24 v2, v5, 4, v2
		v_and_b32_e32 v5, 1, v1
		v_mad_u32_u24 v2, v5, 8, v2
		v_lshrrev_b32_e32 v5, 7, v0
		v_and_b32_e32 v6, 1, v5
		v_mad_u32_u24 v2, v6, 16, v2
		v_lshrrev_b32_e32 v6, 8, v0
		v_and_b32_e32 v7, 1, v6
		v_mad_u32_u24 v2, v7, 32, v2
		v_add_u32_e32 v7, 0x80, v2
		v_add_u32_e32 v8, 0xc0, v2
		s_mul_i32 s14, s0, 0x100
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v10, 7, v9
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v10
		v_add_u32_e32 v10, 32, v11
		v_add_u32_e32 v12, 64, v11
		v_add_u32_e32 v13, 0x60, v11
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
		v_readfirstlane_b32 s15, v0
		s_lshr_b32 s15, s15, 6
		s_mul_i32 s15, 0x420, s15
		s_mov_b32 m0, s15
		v_mul_lo_u32 v14, s10, v1
		v_lshlrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 63, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_lshl_add_u32 v16, v14, 1, v15
		s_mul_i32 s17, s10, s1
		s_lshl_b32 s17, s17, 11
		s_mul_i32 s18, s10, s16
		s_lshl_b32 s18, s18, 9
		s_add_i32 s19, s17, s18
		v_add_u32_e32 v17, s19, v16
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_add_u32_e32 v17, s13, v2
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s20, s10, 7
		s_add_i32 s21, s20, s17
		s_add_i32 s21, s21, s18
		v_add_u32_e32 v18, s21, v16
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_add3_u32 v2, 64, v2, s13
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s32, s10, 8
		s_add_i32 s33, s32, s17
		s_add_i32 s33, s33, s18
		v_add_u32_e32 v18, s33, v16
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_add_u32_e32 v7, s13, v7
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s34, s10, s17
		s_add_i32 s34, s34, s18
		v_add_u32_e32 v18, s34, v16
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_add_u32_e32 v8, s13, v8
		s_add_i32 m0, m0, 0xa4c0
		v_mul_lo_u32 v18, s11, v1
		v_lshl_add_u32 v19, v18, 1, v15
		s_mul_i32 s13, s11, s0
		s_lshl_b32 s13, s13, 9
		v_add_u32_e32 v20, s13, v19
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_add_u32_e32 v20, s14, v11
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s35, s11, 7
		s_add_i32 s36, s35, s13
		v_add_u32_e32 v21, s36, v19
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_add_u32_e32 v21, s14, v10
		s_add_i32 m0, m0, 0x62c0
		s_lshl_b32 s37, s11, 8
		s_add_i32 s38, s37, s13
		v_add_u32_e32 v22, s38, v19
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_add_u32_e32 v22, s14, v12
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s11, 0x180, s11
		s_add_i32 s39, s11, s13
		v_add_u32_e32 v23, s39, v19
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		v_add_u32_e32 v23, s14, v13
		s_add_i32 m0, m0, 0xfffed760
		s_add_i32 s40, s17, 0x80
		s_add_i32 s40, s40, s18
		v_add_u32_e32 v24, s40, v16
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add_u32_e32 v16, s18, v16
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v16, s17, v16
		v_add_u32_e32 v16, 0x80, v16
		v_add_u32_e32 v24, s20, v16
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add_u32_e32 v24, 0x100, v15
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v25, s32, v16
		s_mov_b32 s17, 0x80
		v_add_u32_e32 v16, s10, v16
		v_add_u32_e32 v26, s13, v19
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		v_add_u32_e32 v25, 0x80, v26
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s10, s13, 0x80
		v_add_u32_e32 v19, s10, v19
		v_add_u32_e32 v26, s35, v25
		v_lshrrev_b32_e32 v27, 6, v0
		v_add_u32_e32 v28, s37, v25
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		v_and_b32_e32 v16, 63, v0
		s_add_i32 m0, m0, 0x62c0
		v_add_u32_e32 v25, s11, v25
		v_mov_b32_e32 v29, 0x840
		v_mul_lo_u32 v29, v29, v5
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v19, 4, v16
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v19, 4, v19
		v_add_u32_e32 v29, v29, v19
		v_and_b32_e32 v16, 15, v16
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v26, 3, v16
		s_add_i32 m0, m0, 0x62c0
		v_mov_b32_e32 v30, 0x420
		v_mul_lo_u32 v30, v30, v26
		v_lshrrev_b32_e32 v26, 2, v16
		buffer_load_dwordx4 v28, s[28:31], 0 offen lds
		v_and_b32_e32 v26, 1, v26
		s_add_i32 m0, m0, 0x2100
		v_lshlrev_b32_e32 v26, 9, v26
		v_add3_u32 v28, v29, v30, v26
		v_lshrrev_b32_e32 v29, 1, v16
		buffer_load_dwordx4 v25, s[28:31], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v25, 1, v29
		v_lshlrev_b32_e32 v25, 8, v25
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 7, v16
		v_add3_u32 v28, v28, v25, v16
		ds_read_b128 v[32:35], v28
		ds_read_b128 v[36:39], v28 offset:64
		ds_read_b128 v[40:43], v28 offset:8448
		ds_read_b128 v[44:47], v28 offset:8512
		ds_read_b128 v[48:51], v28 offset:16896
		ds_read_b128 v[52:55], v28 offset:16960
		ds_read_b128 v[56:59], v28 offset:25344
		ds_read_b128 v[60:63], v28 offset:25408
		v_add_u32_e32 v19, 0x10000, v19
		v_add_u32_e32 v19, v19, v30
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v29, 0x840
		v_mul_lo_u32 v29, v29, v27
		v_add3_u32 v19, v19, v29, v26
		v_add3_u32 v16, v19, v25, v16
		ds_read_b128 v[64:67], v16 offset:1984
		ds_read_b128 v[68:71], v16 offset:2048
		ds_read_b128 v[72:75], v16 offset:6208
		ds_read_b128 v[76:79], v16 offset:6272
		ds_read_b128 v[80:83], v16 offset:10432
		ds_read_b128 v[84:87], v16 offset:10496
		ds_read_b128 v[88:91], v16 offset:14656
		ds_read_b128 v[92:95], v16 offset:14720
		s_mov_b32 s10, s17
		v_lshl_add_u32 v19, v14, 1, s19
		v_add_u32_e32 v25, v24, v19
		v_lshl_add_u32 v26, v14, 1, s21
		v_add_u32_e32 v29, v24, v26
		v_lshl_add_u32 v30, v14, 1, s33
		v_add_u32_e32 v31, v24, v30
		v_lshl_add_u32 v14, v14, 1, s34
		v_add_u32_e32 v96, v24, v14
		v_lshl_add_u32 v97, v18, 1, s13
		v_add_u32_e32 v98, v24, v97
		v_lshl_add_u32 v99, v18, 1, s36
		v_add_u32_e32 v100, v24, v99
		v_lshl_add_u32 v101, v18, 1, s38
		v_add_u32_e32 v102, v24, v101
		v_lshl_add_u32 v18, v18, 1, s39
		v_add_u32_e32 v103, v24, v18
		v_add_u32_e32 v15, 0x180, v15
		v_add_u32_e32 v24, v15, v19
		v_add_u32_e32 v19, v15, v26
		v_add_u32_e32 v26, v15, v30
		v_add_u32_e32 v30, v15, v14
		v_add_u32_e32 v14, v15, v97
		v_add_u32_e32 v97, v15, v99
		v_add_u32_e32 v99, v15, v101
		v_add_u32_e32 v101, v15, v18
		s_mov_b32 s11, 0
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		s_mov_b32 s2, s10
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
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		s_add_i32 s10, s10, 0x80
		s_add_i32 s2, s2, 0x80
		s_add_i32 s11, s11, 2
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[56:59], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[60:63], v[160:163]
		ds_read_b128 v[64:67], v16 offset:35712
		ds_read_b128 v[68:71], v16 offset:35776
		ds_read_b128 v[72:75], v16 offset:39936
		ds_read_b128 v[76:79], v16 offset:40000
		ds_read_b128 v[80:83], v16 offset:44160
		ds_read_b128 v[84:87], v16 offset:44224
		ds_read_b128 v[88:91], v16 offset:48384
		ds_read_b128 v[92:95], v16 offset:48448
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[32:35], v[172:175]
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[32:35], v[180:183]
		buffer_load_dwordx4 v29, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[40:43], v[196:199]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[40:43], v[184:187]
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[40:43], v[188:191]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		buffer_load_dwordx4 v96, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		s_add_i32 m0, m0, 0xa4c0
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[48:51], v[200:203]
		buffer_load_dwordx4 v98, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[48:51], v[204:207]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[48:51], v[212:215]
		buffer_load_dwordx4 v100, s[28:31], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[56:59], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[36:39], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[60:63], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[60:63], v[224:227]
		ds_read_b128 v[32:35], v28 offset:33760
		ds_read_b128 v[36:39], v28 offset:33824
		ds_read_b128 v[40:43], v28 offset:42208
		ds_read_b128 v[44:47], v28 offset:42272
		ds_read_b128 v[48:51], v28 offset:50656
		ds_read_b128 v[52:55], v28 offset:50720
		ds_read_b128 v[56:59], v28 offset:59104
		ds_read_b128 v[60:63], v28 offset:59168
		ds_read_b128 v[64:67], v16 offset:18848
		ds_read_b128 v[68:71], v16 offset:18912
		ds_read_b128 v[72:75], v16 offset:23072
		ds_read_b128 v[76:79], v16 offset:23136
		ds_read_b128 v[80:83], v16 offset:27296
		ds_read_b128 v[84:87], v16 offset:27360
		ds_read_b128 v[88:91], v16 offset:31520
		ds_read_b128 v[92:95], v16 offset:31584
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		s_add_i32 m0, m0, 0x62c0
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		buffer_load_dwordx4 v102, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[32:35], v[116:119]
		buffer_load_dwordx4 v103, s[28:31], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[56:59], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[60:63], v[160:163]
		ds_read_b128 v[64:67], v16 offset:52576
		ds_read_b128 v[68:71], v16 offset:52640
		ds_read_b128 v[72:75], v16 offset:56800
		ds_read_b128 v[76:79], v16 offset:56864
		ds_read_b128 v[80:83], v16 offset:61024
		ds_read_b128 v[84:87], v16 offset:61088
		ds_read_b128 v[88:91], v16 offset:65248
		ds_read_b128 v[92:95], v16 offset:65312
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		s_add_i32 m0, m0, 0xfffed760
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[32:35], v[172:175]
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[32:35], v[180:183]
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[40:43], v[196:199]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[40:43], v[184:187]
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[40:43], v[188:191]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		buffer_load_dwordx4 v30, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x100
		s_addc_u32 s25, s25, 0
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		s_add_i32 m0, m0, 0x62c0
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[48:51], v[200:203]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[48:51], v[204:207]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[48:51], v[212:215]
		buffer_load_dwordx4 v97, s[28:31], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[56:59], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[36:39], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[60:63], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[60:63], v[224:227]
		ds_read_b128 v[32:35], v28
		ds_read_b128 v[36:39], v28 offset:64
		ds_read_b128 v[40:43], v28 offset:8448
		ds_read_b128 v[44:47], v28 offset:8512
		ds_read_b128 v[48:51], v28 offset:16896
		ds_read_b128 v[52:55], v28 offset:16960
		ds_read_b128 v[56:59], v28 offset:25344
		ds_read_b128 v[60:63], v28 offset:25408
		ds_read_b128 v[64:67], v16 offset:1984
		ds_read_b128 v[68:71], v16 offset:2048
		ds_read_b128 v[72:75], v16 offset:6208
		ds_read_b128 v[76:79], v16 offset:6272
		ds_read_b128 v[80:83], v16 offset:10432
		ds_read_b128 v[84:87], v16 offset:10496
		ds_read_b128 v[88:91], v16 offset:14656
		ds_read_b128 v[92:95], v16 offset:14720
		s_add_i32 m0, m0, 0x62c0
		s_nop 0
		buffer_load_dwordx4 v99, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2100
		s_nop 0
		buffer_load_dwordx4 v101, s[28:31], 0 offen lds
		s_add_u32 s28, s28, 0x100
		s_addc_u32 s29, s29, 0
		s_cmp_lt_i32 s11, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[56:59], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[68:71], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[84:87], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[92:95], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[92:95], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[68:71], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[84:87], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[84:87], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[68:71], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[92:95], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[92:95], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[68:71], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[84:87], v[60:63], v[160:163]
		ds_read_b128 v[64:67], v16 offset:35712
		ds_read_b128 v[68:71], v16 offset:35776
		ds_read_b128 v[72:75], v16 offset:39936
		ds_read_b128 v[76:79], v16 offset:40000
		ds_read_b128 v[80:83], v16 offset:44160
		ds_read_b128 v[84:87], v16 offset:44224
		ds_read_b128 v[88:91], v16 offset:48384
		ds_read_b128 v[92:95], v16 offset:48448
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[32:35], v[172:175]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[56:59], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[84:87], v[36:39], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[92:95], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[92:95], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[84:87], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[84:87], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[92:95], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[92:95], v[60:63], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[68:71], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[76:79], v[60:63], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[84:87], v[60:63], v[224:227]
		ds_read_b128 v[32:35], v28 offset:33760
		ds_read_b128 v[36:39], v28 offset:33824
		ds_read_b128 v[40:43], v28 offset:42208
		ds_read_b128 v[44:47], v28 offset:42272
		ds_read_b128 v[48:51], v28 offset:50656
		ds_read_b128 v[52:55], v28 offset:50720
		ds_read_b128 v[56:59], v28 offset:59104
		ds_read_b128 v[60:63], v28 offset:59168
		ds_read_b128 v[28:31], v16 offset:18848
		ds_read_b128 v[64:67], v16 offset:18912
		ds_read_b128 v[68:71], v16 offset:23072
		ds_read_b128 v[72:75], v16 offset:23136
		ds_read_b128 v[76:79], v16 offset:27296
		ds_read_b128 v[80:83], v16 offset:27360
		ds_read_b128 v[84:87], v16 offset:31520
		ds_read_b128 v[88:91], v16 offset:31584
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[32:35], v[104:107]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[32:35], v[108:111]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[32:35], v[112:115]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[28:31], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[28:31], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[48:51], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[28:31], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[56:59], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[56:59], v[160:163]
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[36:39], v[112:115]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[88:91], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[88:91], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[148:151], v[88:91], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[164:167], v[88:91], v[60:63], v[164:167]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[60:63], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[60:63], v[160:163]
		ds_read_b128 v[28:31], v16 offset:52576
		ds_read_b128 v[64:67], v16 offset:52640
		ds_read_b128 v[68:71], v16 offset:56800
		ds_read_b128 v[72:75], v16 offset:56864
		ds_read_b128 v[76:79], v16 offset:61024
		ds_read_b128 v[80:83], v16 offset:61088
		ds_read_b128 v[84:87], v16 offset:65248
		ds_read_b128 v[88:91], v16 offset:65312
		v_cvt_pk_f16_f32 v14, v104, v105
		v_cvt_pk_f16_f32 v15, v106, v107
		v_cvt_pk_f16_f32 v18, v108, v109
		v_cvt_pk_f16_f32 v19, v110, v111
		v_cvt_pk_f16_f32 v24, v112, v113
		v_cvt_pk_f16_f32 v25, v114, v115
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
		v_cmp_lt_i32_e64 vcc, v17, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v20, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s13, s1, s12
		s_lshl_b32 s13, s13, 11
		s_add_i32 s15, s0, s13
		s_mul_i32 s17, s16, s12
		s_lshl_b32 s17, s17, 9
		s_add_i32 s15, s15, s17
		v_mul_lo_u32 v16, s12, v6
		v_lshl_add_u32 v17, v16, 6, s15
		v_and_b32_e32 v20, 1, v0
		v_mul_lo_u32 v26, s12, v20
		v_lshlrev_b32_e32 v26, 1, v26
		v_and_b32_e32 v118, 1, v5
		v_mul_lo_u32 v119, s12, v118
		v_lshlrev_b32_e32 v119, 5, v119
		v_add3_u32 v17, v17, v26, v119
		v_and_b32_e32 v1, 1, v1
		v_mul_lo_u32 v120, s12, v1
		v_lshlrev_b32_e32 v120, 4, v120
		v_and_b32_e32 v4, 1, v4
		v_mul_lo_u32 v121, s12, v4
		v_lshlrev_b32_e32 v121, 3, v121
		v_add3_u32 v17, v17, v120, v121
		v_and_b32_e32 v3, 1, v3
		v_mul_lo_u32 v122, s12, v3
		v_lshlrev_b32_e32 v122, 2, v122
		v_lshlrev_b32_e32 v123, 5, v27
		v_add3_u32 v17, v17, v122, v123
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v124, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v125, 3, v9
		v_add3_u32 v17, v17, v124, v125
		v_mov_b32_e32 v126, 0x80000000
		v_cndmask_b32_e64 v17, v126, v17, s[10:11]
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		buffer_store_dwordx2 v[14:15], v17, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		v_mul_lo_u32 v5, s12, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_add_u32_e32 v14, s15, v5
		v_add3_u32 v14, v14, v26, v120
		v_add3_u32 v14, v14, v121, v122
		v_lshlrev_b32_e32 v15, 4, v27
		v_lshlrev_b32_e32 v9, 2, v9
		v_add_u32_e32 v17, 32, v9
		v_lshlrev_b32_e32 v0, 3, v0
		v_bitop3_b32 v17, v15, v17, v0 bitop3:0x96
		v_lshl_add_u32 v21, v17, 1, v14
		v_cndmask_b32_e64 v21, v126, v21, s[10:11]
		buffer_store_dwordx2 v[18:19], v21, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s18, s2, s10
		s_and_b32 s19, s3, s11
		v_add_u32_e32 v18, 64, v9
		v_bitop3_b32 v18, v15, v18, v0 bitop3:0x96
		v_lshl_add_u32 v14, v18, 1, v14
		v_cndmask_b32_e64 v14, v126, v14, s[18:19]
		buffer_store_dwordx2 v[24:25], v14, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v23, s9
		s_mov_b64 s[18:19], vcc
		s_and_b32 s24, s2, s18
		s_and_b32 s25, s3, s19
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s26, s0, s1
		s_mul_i32 s16, s12, s16
		s_lshl_b32 s16, s16, 9
		s_add_i32 s26, s26, s16
		v_add3_u32 v14, s26, v5, v26
		v_add3_u32 v14, v14, v120, v121
		v_add_u32_e32 v9, 0x60, v9
		v_bitop3_b32 v0, v15, v9, v0 bitop3:0x96
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v9, v14, v122, v0
		v_cndmask_b32_e64 v9, v126, v9, s[24:25]
		buffer_store_dwordx2 v[92:93], v9, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v2, s8
		s_mov_b64 s[24:25], vcc
		s_and_b32 s28, s24, s4
		s_and_b32 s29, s25, s5
		v_lshlrev_b32_e32 v2, 5, v6
		v_lshlrev_b32_e32 v6, 4, v118
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v9, 64, v20
		v_lshlrev_b32_e32 v3, 1, v3
		v_xor_b32_e32 v9, v9, v3
		v_bitop3_b32 v9, v1, v4, v9 bitop3:0x96
		v_bitop3_b32 v9, v2, v6, v9 bitop3:0x96
		v_mul_lo_u32 v9, s12, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v14, s15, v9
		v_add_u32_e32 v15, v14, v123
		v_add3_u32 v15, v15, v124, v125
		v_cndmask_b32_e64 v15, v126, v15, s[28:29]
		buffer_store_dwordx2 v[94:95], v15, s[20:23], 0 offen
		s_and_b32 s28, s24, s6
		s_and_b32 s29, s25, s7
		v_lshl_add_u32 v15, v17, 1, v14
		v_cndmask_b32_e64 v15, v126, v15, s[28:29]
		buffer_store_dwordx2 v[96:97], v15, s[20:23], 0 offen
		s_and_b32 s28, s24, s10
		s_and_b32 s29, s25, s11
		v_lshl_add_u32 v14, v18, 1, v14
		v_cndmask_b32_e64 v14, v126, v14, s[28:29]
		buffer_store_dwordx2 v[98:99], v14, s[20:23], 0 offen
		s_and_b32 s28, s24, s18
		s_and_b32 s29, s25, s19
		v_add3_u32 v14, s26, v9, v0
		v_cndmask_b32_e64 v14, v126, v14, s[28:29]
		buffer_store_dwordx2 v[100:101], v14, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v7, s8
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s28, s4
		s_and_b32 s31, s29, s5
		v_add_u32_e32 v7, 0x80, v20
		v_xor_b32_e32 v7, v7, v3
		v_bitop3_b32 v7, v1, v4, v7 bitop3:0x96
		v_bitop3_b32 v7, v2, v6, v7 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add_u32_e32 v14, s15, v7
		v_add_u32_e32 v15, v14, v123
		v_add3_u32 v15, v15, v124, v125
		v_cndmask_b32_e64 v15, v126, v15, s[30:31]
		buffer_store_dwordx2 v[102:103], v15, s[20:23], 0 offen
		s_and_b32 s30, s28, s6
		s_and_b32 s31, s29, s7
		v_lshl_add_u32 v15, v17, 1, v14
		v_cndmask_b32_e64 v15, v126, v15, s[30:31]
		buffer_store_dwordx2 v[104:105], v15, s[20:23], 0 offen
		s_and_b32 s30, s28, s10
		s_and_b32 s31, s29, s11
		v_lshl_add_u32 v14, v18, 1, v14
		v_cndmask_b32_e64 v14, v126, v14, s[30:31]
		buffer_store_dwordx2 v[106:107], v14, s[20:23], 0 offen
		s_and_b32 s30, s28, s18
		s_and_b32 s31, s29, s19
		v_add3_u32 v14, s26, v7, v0
		v_cndmask_b32_e64 v14, v126, v14, s[30:31]
		buffer_store_dwordx2 v[108:109], v14, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v8, s8
		s_mov_b64 s[30:31], vcc
		s_and_b32 s32, s30, s4
		s_and_b32 s33, s31, s5
		v_add_u32_e32 v8, 0xc0, v20
		v_xor_b32_e32 v3, v8, v3
		v_bitop3_b32 v1, v1, v4, v3 bitop3:0x96
		v_bitop3_b32 v1, v2, v6, v1 bitop3:0x96
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v2, v1, 1, s26
		v_add_u32_e32 v3, v2, v123
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[32:33]
		buffer_store_dwordx2 v[110:111], v3, s[20:23], 0 offen
		s_and_b32 s4, s30, s6
		s_and_b32 s5, s31, s7
		v_lshl_add_u32 v3, v17, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[4:5]
		buffer_store_dwordx2 v[112:113], v3, s[20:23], 0 offen
		s_and_b32 s4, s30, s10
		s_and_b32 s5, s31, s11
		v_lshl_add_u32 v3, v18, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[4:5]
		buffer_store_dwordx2 v[114:115], v3, s[20:23], 0 offen
		s_and_b32 s4, s30, s18
		s_and_b32 s5, s31, s19
		v_add_u32_e32 v2, v2, v0
		v_cndmask_b32_e64 v2, v126, v2, s[4:5]
		buffer_store_dwordx2 v[116:117], v2, s[20:23], 0 offen
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[32:35], v[168:171]
		s_add_i32 s4, s14, 0x80
		v_add_u32_e32 v2, s4, v11
		v_add_u32_e32 v3, s4, v10
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[32:35], v[172:175]
		v_add_u32_e32 v4, s4, v12
		v_add_u32_e32 v6, s4, v13
		v_cmp_lt_i32_e64 vcc, v2, s9
		s_mov_b64 s[4:5], vcc
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[32:35], v[176:179]
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		s_add_i32 s0, s0, 0x100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[32:35], v[180:183]
		s_add_i32 s8, s0, s13
		s_add_i32 s8, s8, s17
		v_lshl_add_u32 v2, v16, 6, s8
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[40:43], v[196:199]
		v_add3_u32 v2, v2, v26, v119
		v_add3_u32 v2, v2, v120, v121
		v_add3_u32 v2, v2, v122, v123
		v_mfma_f32_16x16x32_f16 v[184:187], v[28:31], v[40:43], v[184:187]
		v_add3_u32 v2, v2, v124, v125
		v_cndmask_b32_e64 v2, v126, v2, s[6:7]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[200:203], v[28:31], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[48:51], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[84:87], v[56:59], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[28:31], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[68:71], v[56:59], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[56:59], v[224:227]
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[36:39], v[176:179]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[180:183], v[88:91], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[88:91], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[52:55], v[208:211]
		v_cvt_pk_f16_f32 v10, v168, v169
		v_cvt_pk_f16_f32 v11, v170, v171
		v_cvt_pk_f16_f32 v12, v172, v173
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[52:55], v[200:203]
		v_cvt_pk_f16_f32 v13, v174, v175
		v_cvt_pk_f16_f32 v14, v176, v177
		v_cvt_pk_f16_f32 v15, v178, v179
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[52:55], v[204:207]
		v_cvt_pk_f16_f32 v20, v180, v181
		v_cvt_pk_f16_f32 v21, v182, v183
		v_cvt_pk_f16_f32 v22, v184, v185
		v_mfma_f32_16x16x32_f16 v[212:215], v[88:91], v[52:55], v[212:215]
		v_cvt_pk_f16_f32 v23, v186, v187
		v_cvt_pk_f16_f32 v24, v188, v189
		v_cvt_pk_f16_f32 v25, v190, v191
		v_mfma_f32_16x16x32_f16 v[228:231], v[88:91], v[60:63], v[228:231]
		v_cvt_pk_f16_f32 v28, v192, v193
		v_cvt_pk_f16_f32 v29, v194, v195
		v_cvt_pk_f16_f32 v30, v196, v197
		v_mfma_f32_16x16x32_f16 v[216:219], v[64:67], v[60:63], v[216:219]
		v_cvt_pk_f16_f32 v31, v198, v199
		v_cvt_pk_f16_f32 v32, v200, v201
		v_cvt_pk_f16_f32 v33, v202, v203
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[60:63], v[220:223]
		v_cvt_pk_f16_f32 v34, v204, v205
		v_cvt_pk_f16_f32 v35, v206, v207
		v_cvt_pk_f16_f32 v36, v208, v209
		v_mfma_f32_16x16x32_f16 v[224:227], v[80:83], v[60:63], v[224:227]
		v_cvt_pk_f16_f32 v37, v210, v211
		v_cvt_pk_f16_f32 v38, v212, v213
		v_cvt_pk_f16_f32 v39, v214, v215
		v_cvt_pk_f16_f32 v40, v216, v217
		v_cvt_pk_f16_f32 v41, v218, v219
		v_cvt_pk_f16_f32 v42, v220, v221
		v_cvt_pk_f16_f32 v43, v222, v223
		v_cvt_pk_f16_f32 v44, v228, v229
		v_cvt_pk_f16_f32 v46, v224, v225
		v_cvt_pk_f16_f32 v47, v226, v227
		v_cvt_pk_f16_f32 v45, v230, v231
		buffer_store_dwordx2 v[10:11], v2, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v3, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		v_add_u32_e32 v2, s8, v5
		v_add3_u32 v2, v2, v26, v120
		v_add3_u32 v2, v2, v121, v122
		v_lshl_add_u32 v3, v17, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[10:11]
		buffer_store_dwordx2 v[12:13], v3, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v4, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s12, s2, s10
		s_and_b32 s13, s3, s11
		v_lshl_add_u32 v2, v18, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[12:13]
		buffer_store_dwordx2 v[14:15], v2, s[20:23], 0 offen
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[12:13], vcc
		s_and_b32 s14, s2, s12
		s_and_b32 s15, s3, s13
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s16
		v_add3_u32 v2, s0, v5, v26
		v_add3_u32 v2, v2, v120, v121
		v_add3_u32 v2, v2, v122, v0
		v_cndmask_b32_e64 v2, v126, v2, s[14:15]
		buffer_store_dwordx2 v[20:21], v2, s[20:23], 0 offen
		s_and_b32 s2, s24, s4
		s_and_b32 s3, s25, s5
		v_add_u32_e32 v2, s8, v9
		v_add_u32_e32 v3, v2, v123
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[22:23], v3, s[20:23], 0 offen
		s_and_b32 s2, s24, s6
		s_and_b32 s3, s25, s7
		v_lshl_add_u32 v3, v17, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[24:25], v3, s[20:23], 0 offen
		s_and_b32 s2, s24, s10
		s_and_b32 s3, s25, s11
		v_lshl_add_u32 v2, v18, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[28:29], v2, s[20:23], 0 offen
		s_and_b32 s2, s24, s12
		s_and_b32 s3, s25, s13
		v_add3_u32 v2, s0, v9, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[30:31], v2, s[20:23], 0 offen
		s_and_b32 s2, s28, s4
		s_and_b32 s3, s29, s5
		v_add_u32_e32 v2, s8, v7
		v_add_u32_e32 v3, v2, v123
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[32:33], v3, s[20:23], 0 offen
		s_and_b32 s2, s28, s6
		s_and_b32 s3, s29, s7
		v_lshl_add_u32 v3, v17, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[34:35], v3, s[20:23], 0 offen
		s_and_b32 s2, s28, s10
		s_and_b32 s3, s29, s11
		v_lshl_add_u32 v2, v18, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[36:37], v2, s[20:23], 0 offen
		s_and_b32 s2, s28, s12
		s_and_b32 s3, s29, s13
		v_add3_u32 v2, s0, v7, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[38:39], v2, s[20:23], 0 offen
		s_and_b32 s2, s30, s4
		s_and_b32 s3, s31, s5
		v_lshl_add_u32 v1, v1, 1, s0
		v_add_u32_e32 v2, v1, v123
		v_add3_u32 v2, v2, v124, v125
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[40:41], v2, s[20:23], 0 offen
		s_and_b32 s0, s30, s6
		s_and_b32 s1, s31, s7
		v_lshl_add_u32 v2, v17, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[42:43], v2, s[20:23], 0 offen
		s_and_b32 s0, s30, s10
		s_and_b32 s1, s31, s11
		v_lshl_add_u32 v2, v18, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[46:47], v2, s[20:23], 0 offen
		s_and_b32 s0, s30, s12
		s_and_b32 s1, s31, s13
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v126, v0, s[0:1]
		buffer_store_dwordx2 v[44:45], v0, s[20:23], 0 offen
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
		.amdhsa_next_free_vgpr 232
		.amdhsa_next_free_sgpr 41
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
	.set .Lv9_beyond_hotloop.numbered_sgpr, 41
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
    .sgpr_count:     41
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
