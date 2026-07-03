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
		v_mov_b32_e32 v1, 0x4f7ffffe
		s_add_i32 s0, s8, 0xff
		v_lshrrev_b32_e32 v2, 3, v0
		s_mov_b32 s1, 0xff
		v_readfirstlane_b32 s14, v0
		v_mul_lo_u32 v3, s10, v2
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s15, s1, 0
		v_lshlrev_b32_e32 v4, 3, v0
		s_add_i32 s0, s0, s15
		v_and_b32_e32 v4, 63, v4
		s_ashr_i32 s0, s0, 8
		v_lshlrev_b32_e32 v4, 1, v4
		s_add_i32 s15, s9, 0xff
		v_lshl_add_u32 v3, v3, 1, v4
		v_mul_lo_u32 v5, s11, v2
		s_cmp_lt_i32 s15, 0
		s_cselect_b32 s1, s1, 0
		v_lshl_add_u32 v4, v5, 1, v4
		s_add_i32 s1, s15, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s15, s13, 7
		s_lshr_b32 s13, s13, 3
		s_mul_i32 s15, s15, 32
		s_add_i32 s13, s15, s13
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s15, 1, 0
		s_xor_b32 s16, s13, -1
		s_add_i32 s16, s16, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s15, s16, s13
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s17, s1, -1
		s_add_i32 s17, s17, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s17, s17, s1
		v_mov_b32_e32 v5, s17
		s_xor_b32 s18, s17, -1
		v_cvt_f32_u32_e32 v5, v5
		s_add_i32 s18, s18, 1
		v_rcp_iflag_f32_e32 v5, v5
		s_mov_b32 s22, 0x7fffffff
		v_mul_f32_e32 v5, v1, v5
		s_mov_b32 s23, 0x31016000
		v_cvt_u32_f32_e32 v5, v5
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		v_readfirstlane_b32 s2, v5
		s_mul_i32 s3, s18, s2
		s_mul_hi_u32 s3, s2, s3
		s_add_i32 s2, s2, s3
		s_mul_hi_u32 s2, s15, s2
		s_mul_i32 s3, s2, s17
		s_xor_b32 s3, s3, -1
		s_add_i32 s3, s3, 1
		s_add_i32 s3, s15, s3
		s_cmp_ge_u32 s3, s17
		s_cselect_b32 s15, 1, 0
		s_add_i32 s19, s2, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s2, s19, s2
		s_cselect_b32 s15, 1, 0
		s_add_i32 s19, s3, s18
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s3, s19, s3
		s_cmp_ge_u32 s3, s17
		s_cselect_b32 s15, 1, 0
		s_add_i32 s17, s2, 1
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s2, s17, s2
		s_cselect_b32 s15, 1, 0
		s_xor_b32 s1, s13, s1
		s_xor_b32 s13, s2, -1
		s_add_i32 s13, s13, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s13, s2
		s_mul_i32 s2, s1, 4
		s_xor_b32 s13, s2, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s0, s0, s13
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		v_mov_b32_e32 v5, s0
		s_add_i32 s13, s3, s18
		v_cvt_f32_u32_e32 v5, v5
		s_cmp_lg_u32 s15, 0
		s_cselect_b32 s3, s13, s3
		v_rcp_iflag_f32_e32 v5, v5
		s_xor_b32 s13, s3, -1
		v_mul_f32_e32 v1, v1, v5
		s_add_i32 s13, s13, 1
		v_cvt_u32_f32_e32 v1, v1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s3, s13, s3
		v_readfirstlane_b32 s13, v1
		s_xor_b32 s15, s0, -1
		v_readfirstlane_b32 s16, v1
		s_add_i32 s15, s15, 1
		s_mul_i32 s17, s15, s13
		s_mul_hi_u32 s17, s13, s17
		s_add_i32 s13, s13, s17
		s_mul_hi_u32 s13, s3, s13
		s_mul_i32 s13, s13, s0
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s3, s13
		s_add_i32 s17, s13, s15
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s13, s17, s13
		s_add_i32 s17, s13, s15
		s_cmp_ge_u32 s13, s0
		s_cselect_b32 s13, s17, s13
		s_add_i32 s2, s2, s13
		s_mul_i32 s17, s15, s16
		s_mul_hi_u32 s17, s16, s17
		s_add_i32 s16, s16, s17
		s_mul_hi_u32 s16, s3, s16
		s_mul_i32 s17, s16, s0
		s_xor_b32 s17, s17, -1
		s_add_i32 s17, s17, 1
		s_add_i32 s3, s3, s17
		s_cmp_ge_u32 s3, s0
		s_cselect_b32 s17, 1, 0
		s_add_i32 s18, s16, 1
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s16, s18, s16
		s_cselect_b32 s17, 1, 0
		s_add_i32 s15, s3, s15
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s3, s15, s3
		s_add_i32 s15, s16, 1
		s_cmp_ge_u32 s3, s0
		s_cselect_b32 s0, s15, s16
		s_lshr_b32 s3, s14, 6
		s_mul_i32 s3, 0x420, s3
		s_mov_b32 m0, s3
		s_mul_i32 s14, s10, s1
		s_lshl_b32 s14, s14, 11
		s_mul_i32 s15, s10, s13
		s_lshl_b32 s15, s15, 9
		s_add_i32 s16, s14, s15
		v_add_u32_e32 v1, s16, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x2100
		s_lshl_b32 s17, s10, 7
		s_add_i32 s18, s17, s14
		s_add_i32 s18, s18, s15
		v_add_u32_e32 v1, s18, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x4200
		s_lshl_b32 s19, s10, 8
		s_add_i32 s24, s19, s14
		s_add_i32 s24, s24, s15
		v_add_u32_e32 v1, s24, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x6300
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s25, s10, s14
		s_add_i32 s25, s25, s15
		v_add_u32_e32 v1, s25, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
		s_add_i32 m0, s3, 0x107c0
		s_mul_i32 s4, s11, s0
		s_lshl_b32 s4, s4, 9
		v_add_u32_e32 v1, s4, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x128c0
		s_lshl_b32 s5, s11, 7
		s_add_i32 s26, s5, s4
		v_add_u32_e32 v1, s26, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x18b80
		s_lshl_b32 s27, s11, 8
		s_add_i32 s32, s27, s4
		v_add_u32_e32 v1, s32, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x1ac80
		s_mul_i32 s11, 0x180, s11
		s_add_i32 s33, s11, s4
		v_add_u32_e32 v1, s33, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x83e0
		s_add_i32 s34, s14, 0x80
		s_add_i32 s34, s34, s15
		v_add_u32_e32 v1, s34, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xa4e0
		s_add_i32 s17, s17, 0x80
		s_add_i32 s17, s17, s14
		s_add_i32 s17, s17, s15
		v_add_u32_e32 v1, s17, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xc5e0
		s_add_i32 s19, s19, 0x80
		s_add_i32 s19, s19, s14
		s_add_i32 s19, s19, s15
		v_add_u32_e32 v1, s19, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xe6e0
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s14
		s_add_i32 s10, s10, s15
		v_add_u32_e32 v1, s10, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x149a0
		s_add_i32 s14, s4, 0x80
		v_add_u32_e32 v1, s14, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x16aa0
		s_add_i32 s5, s5, 0x80
		s_add_i32 s5, s5, s4
		v_add_u32_e32 v1, s5, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x1cd60
		s_add_i32 s15, s27, 0x80
		s_add_i32 s15, s15, s4
		v_add_u32_e32 v1, s15, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x1ee60
		s_add_i32 s11, s11, 0x80
		s_add_i32 s11, s11, s4
		v_add_u32_e32 v1, s11, v4
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v1, 1, v0
		v_and_b32_e32 v5, 1, v0
		v_and_b32_e32 v6, 1, v1
		v_lshrrev_b32_e32 v7, 2, v0
		s_mul_i32 s2, s2, 0x100
		v_mad_u32_u24 v5, v6, 2, v5
		s_mul_i32 s27, s0, 0x100
		v_and_b32_e32 v6, 1, v7
		v_mad_u32_u24 v5, v6, 4, v5
		v_and_b32_e32 v6, 1, v2
		v_lshrrev_b32_e32 v8, 7, v0
		v_mad_u32_u24 v5, v6, 8, v5
		v_and_b32_e32 v6, 1, v8
		v_lshrrev_b32_e32 v9, 8, v0
		v_lshrrev_b32_e32 v10, 4, v0
		v_mad_u32_u24 v5, v6, 16, v5
		v_and_b32_e32 v6, 1, v9
		v_and_b32_e32 v11, 7, v10
		v_mad_u32_u24 v5, v6, 32, v5
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v11
		v_add_u32_e32 v11, 0x80, v5
		v_add_u32_e32 v12, 0xc0, v5
		v_add_u32_e32 v13, 32, v6
		v_add_u32_e32 v14, 64, v6
		v_add_u32_e32 v15, 0x60, v6
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_add_u32_e32 v20, s2, v5
		v_add3_u32 v5, 64, v5, s2
		v_add_u32_e32 v11, s2, v11
		v_add_u32_e32 v12, s2, v12
		v_add_u32_e32 v21, s27, v6
		v_add_u32_e32 v22, s27, v13
		v_add_u32_e32 v23, s27, v14
		v_add_u32_e32 v24, s27, v15
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v25, 63, v0
		v_and_b32_e32 v26, 15, v25
		v_lshl_add_u32 v27, v8, 4, v26
		v_lshrrev_b32_e32 v25, 4, v25
		v_lshrrev_b32_e32 v27, 5, v27
		v_lshlrev_b32_e32 v25, 4, v25
		v_lshrrev_b32_e32 v28, 3, v26
		v_lshrrev_b32_e32 v29, 2, v26
		v_lshrrev_b32_e32 v30, 6, v0
		v_mov_b32_e32 v31, 0x1080
		v_mul_lo_u32 v31, v31, v27
		v_mov_b32_e32 v27, 0x420
		v_mul_lo_u32 v27, v27, v28
		v_and_b32_e32 v28, 1, v8
		v_and_b32_e32 v29, 1, v29
		v_lshrrev_b32_e32 v32, 1, v26
		v_add_u32_e32 v33, 0x10000, v25
		v_and_b32_e32 v30, 1, v30
		v_add3_u32 v25, v31, v25, v27
		v_mov_b32_e32 v31, 0x840
		v_mul_lo_u32 v31, v31, v28
		v_lshlrev_b32_e32 v29, 9, v29
		v_and_b32_e32 v32, 1, v32
		v_and_b32_e32 v26, 1, v26
		v_add_u32_e32 v27, v33, v27
		v_mov_b32_e32 v33, 0x840
		v_mul_lo_u32 v33, v33, v30
		v_add3_u32 v25, v25, v31, v29
		v_lshlrev_b32_e32 v31, 8, v32
		v_lshlrev_b32_e32 v26, 7, v26
		v_add3_u32 v27, v27, v33, v29
		v_add3_u32 v25, v25, v31, v26
		v_add3_u32 v26, v27, v31, v26
		ds_read_b128 v[32:35], v25
		ds_read_b128 v[36:39], v25 offset:64
		ds_read_b128 v[40:43], v25 offset:8448
		ds_read_b128 v[44:47], v25 offset:8512
		ds_read_b128 v[48:51], v25 offset:16896
		ds_read_b128 v[52:55], v25 offset:16960
		ds_read_b128 v[56:59], v25 offset:25344
		ds_read_b128 v[60:63], v25 offset:25408
		ds_read_b128 v[64:67], v26 offset:1984
		ds_read_b128 v[68:71], v26 offset:2048
		ds_read_b128 v[72:75], v26 offset:6208
		ds_read_b128 v[76:79], v26 offset:6272
		ds_read_b128 v[80:83], v26 offset:10432
		ds_read_b128 v[84:87], v26 offset:10496
		ds_read_b128 v[88:91], v26 offset:14656
		ds_read_b128 v[92:95], v26 offset:14720
		v_mov_b32_e32 v96, v16
		v_mov_b32_e32 v97, v17
		v_mov_b32_e32 v98, v18
		v_mov_b32_e32 v99, v19
		s_mov_b32 s2, 0x80
		s_mov_b32 s35, s2
		s_lshl_b32 s2, s35, 1
		s_mov_b32 s35, 0
		s_mov_b32 s36, s2
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
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[64:67], v26 offset:35712
		ds_read_b128 v[68:71], v26 offset:35776
		ds_read_b128 v[72:75], v26 offset:39936
		ds_read_b128 v[76:79], v26 offset:40000
		ds_read_b128 v[80:83], v26 offset:44160
		ds_read_b128 v[84:87], v26 offset:44224
		ds_read_b128 v[88:91], v26 offset:48384
		ds_read_b128 v[92:95], v26 offset:48448
		s_mov_b32 m0, s3
		s_add_i32 s37, s16, s2
		v_add_u32_e32 v27, s37, v3
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x2100
		v_add_u32_e32 v27, s2, v3
		v_add_u32_e32 v29, s18, v27
		buffer_load_dwordx4 v29, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x4200
		v_add_u32_e32 v29, s24, v27
		buffer_load_dwordx4 v29, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0x6300
		v_add_u32_e32 v27, s25, v27
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		s_add_i32 m0, s3, 0x107c0
		s_add_i32 s37, s4, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		s_add_i32 m0, s3, 0x128c0
		s_add_i32 s37, s26, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[32:35], v25 offset:33760
		ds_read_b128 v[36:39], v25 offset:33824
		ds_read_b128 v[40:43], v25 offset:42208
		ds_read_b128 v[44:47], v25 offset:42272
		ds_read_b128 v[48:51], v25 offset:50656
		ds_read_b128 v[52:55], v25 offset:50720
		ds_read_b128 v[56:59], v25 offset:59104
		ds_read_b128 v[60:63], v25 offset:59168
		ds_read_b128 v[64:67], v26 offset:18848
		ds_read_b128 v[68:71], v26 offset:18912
		ds_read_b128 v[72:75], v26 offset:23072
		ds_read_b128 v[76:79], v26 offset:23136
		ds_read_b128 v[80:83], v26 offset:27296
		ds_read_b128 v[84:87], v26 offset:27360
		ds_read_b128 v[88:91], v26 offset:31520
		ds_read_b128 v[92:95], v26 offset:31584
		s_add_i32 m0, s3, 0x18b80
		s_add_i32 s37, s32, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		s_add_i32 m0, s3, 0x1ac80
		s_add_i32 s37, s33, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[64:67], v26 offset:52576
		ds_read_b128 v[68:71], v26 offset:52640
		ds_read_b128 v[72:75], v26 offset:56800
		ds_read_b128 v[76:79], v26 offset:56864
		ds_read_b128 v[80:83], v26 offset:61024
		ds_read_b128 v[84:87], v26 offset:61088
		ds_read_b128 v[88:91], v26 offset:65248
		ds_read_b128 v[92:95], v26 offset:65312
		s_add_i32 m0, s3, 0x83e0
		s_add_i32 s37, s34, s2
		v_add_u32_e32 v27, s37, v3
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xa4e0
		v_add_u32_e32 v27, s2, v3
		v_add_u32_e32 v29, s17, v27
		buffer_load_dwordx4 v29, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xc5e0
		v_add_u32_e32 v29, s19, v27
		buffer_load_dwordx4 v29, s[20:23], 0 offen lds
		s_add_i32 m0, s3, 0xe6e0
		v_add_u32_e32 v27, s10, v27
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		s_add_i32 m0, s3, 0x149a0
		s_add_i32 s37, s14, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		s_add_i32 m0, s3, 0x16aa0
		s_add_i32 s37, s5, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		s_add_i32 m0, s3, 0x1cd60
		s_add_i32 s37, s15, s36
		v_add_u32_e32 v27, s37, v4
		s_waitcnt vmcnt(8)
		s_barrier
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		s_add_i32 m0, s3, 0x1ee60
		s_add_i32 s37, s11, s36
		v_add_u32_e32 v27, s37, v4
		buffer_load_dwordx4 v27, s[28:31], 0 offen lds
		ds_read_b128 v[32:35], v25
		ds_read_b128 v[36:39], v25 offset:64
		ds_read_b128 v[40:43], v25 offset:8448
		ds_read_b128 v[44:47], v25 offset:8512
		ds_read_b128 v[48:51], v25 offset:16896
		ds_read_b128 v[52:55], v25 offset:16960
		ds_read_b128 v[56:59], v25 offset:25344
		ds_read_b128 v[60:63], v25 offset:25408
		ds_read_b128 v[64:67], v26 offset:1984
		ds_read_b128 v[68:71], v26 offset:2048
		ds_read_b128 v[72:75], v26 offset:6208
		ds_read_b128 v[76:79], v26 offset:6272
		ds_read_b128 v[80:83], v26 offset:10432
		ds_read_b128 v[84:87], v26 offset:10496
		ds_read_b128 v[88:91], v26 offset:14656
		ds_read_b128 v[92:95], v26 offset:14720
		s_add_i32 s2, s2, 0x100
		s_add_i32 s36, s36, 0x100
		s_add_i32 s35, s35, 2
		s_cmp_lt_i32 s35, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[64:67], v26 offset:35712
		ds_read_b128 v[68:71], v26 offset:35776
		ds_read_b128 v[72:75], v26 offset:39936
		ds_read_b128 v[76:79], v26 offset:40000
		ds_read_b128 v[80:83], v26 offset:44160
		ds_read_b128 v[84:87], v26 offset:44224
		ds_read_b128 v[88:91], v26 offset:48384
		ds_read_b128 v[92:95], v26 offset:48448
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		ds_read_b128 v[32:35], v25 offset:33760
		ds_read_b128 v[36:39], v25 offset:33824
		ds_read_b128 v[40:43], v25 offset:42208
		ds_read_b128 v[44:47], v25 offset:42272
		ds_read_b128 v[48:51], v25 offset:50656
		ds_read_b128 v[52:55], v25 offset:50720
		ds_read_b128 v[56:59], v25 offset:59104
		ds_read_b128 v[60:63], v25 offset:59168
		ds_read_b128 v[64:67], v26 offset:18848
		ds_read_b128 v[68:71], v26 offset:18912
		ds_read_b128 v[72:75], v26 offset:23072
		ds_read_b128 v[76:79], v26 offset:23136
		ds_read_b128 v[80:83], v26 offset:27296
		ds_read_b128 v[84:87], v26 offset:27360
		ds_read_b128 v[88:91], v26 offset:31520
		ds_read_b128 v[92:95], v26 offset:31584
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[16:19], v[64:67], v[32:35], v[16:19]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[88:91], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[88:91], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[80:83], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[80:83], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[88:91], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[88:91], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[80:83], v[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[16:19], v[68:71], v[36:39], v[16:19]
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[84:87], v[36:39], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[92:95], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[92:95], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[84:87], v[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[84:87], v[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[92:95], v[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[92:95], v[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[84:87], v[60:63], v[148:151]
		ds_read_b128 v[64:67], v26 offset:52576
		ds_read_b128 v[68:71], v26 offset:52640
		ds_read_b128 v[72:75], v26 offset:56800
		ds_read_b128 v[76:79], v26 offset:56864
		ds_read_b128 v[80:83], v26 offset:61024
		ds_read_b128 v[84:87], v26 offset:61088
		ds_read_b128 v[88:91], v26 offset:65248
		ds_read_b128 v[92:95], v26 offset:65312
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
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s18, s30
		s_mov_b32 s19, s31
		v_cmp_lt_i32_e64 vcc, v20, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s10, s1, s12
		s_lshl_b32 s10, s10, 11
		s_add_i32 s11, s0, s10
		s_mul_i32 s14, s13, s12
		s_lshl_b32 s14, s14, 9
		s_add_i32 s11, s11, s14
		v_mul_lo_u32 v3, s12, v9
		v_lshl_add_u32 v4, v3, 6, s11
		v_and_b32_e32 v20, 1, v0
		v_mul_lo_u32 v21, s12, v20
		v_lshlrev_b32_e32 v21, 1, v21
		v_mul_lo_u32 v25, s12, v28
		v_lshlrev_b32_e32 v25, 5, v25
		v_add3_u32 v4, v4, v21, v25
		v_and_b32_e32 v2, 1, v2
		v_mul_lo_u32 v29, s12, v2
		v_lshlrev_b32_e32 v29, 4, v29
		v_and_b32_e32 v7, 1, v7
		v_mul_lo_u32 v31, s12, v7
		v_lshlrev_b32_e32 v31, 3, v31
		v_add3_u32 v4, v4, v29, v31
		v_and_b32_e32 v1, 1, v1
		v_mul_lo_u32 v122, s12, v1
		v_lshlrev_b32_e32 v122, 2, v122
		v_lshlrev_b32_e32 v123, 5, v30
		v_add3_u32 v4, v4, v122, v123
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v124, 4, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v125, 3, v10
		v_add3_u32 v4, v4, v124, v125
		v_mov_b32_e32 v126, 0x80000000
		v_cndmask_b32_e64 v4, v126, v4, s[6:7]
		buffer_store_dwordx2 v[26:27], v4, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s20, s2, s6
		s_and_b32 s21, s3, s7
		v_mul_lo_u32 v4, s12, v8
		v_lshlrev_b32_e32 v4, 5, v4
		v_add_u32_e32 v8, s11, v4
		v_add3_u32 v8, v8, v21, v29
		v_add3_u32 v8, v8, v31, v122
		v_lshlrev_b32_e32 v22, 4, v30
		v_lshlrev_b32_e32 v10, 2, v10
		v_add_u32_e32 v26, 32, v10
		v_lshlrev_b32_e32 v0, 3, v0
		v_xor_b32_e32 v26, v26, v0
		v_xor_b32_e32 v26, v22, v26
		v_lshl_add_u32 v27, v26, 1, v8
		v_cndmask_b32_e64 v27, v126, v27, s[20:21]
		buffer_store_dwordx2 v[16:17], v27, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v23, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s2, s20
		s_and_b32 s23, s3, s21
		v_add_u32_e32 v16, 64, v10
		v_xor_b32_e32 v16, v16, v0
		v_xor_b32_e32 v16, v22, v16
		v_lshl_add_u32 v8, v16, 1, v8
		v_cndmask_b32_e64 v8, v126, v8, s[22:23]
		buffer_store_dwordx2 v[18:19], v8, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v24, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s2, s22
		s_and_b32 s25, s3, s23
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s15, s0, s1
		s_mul_i32 s13, s12, s13
		s_lshl_b32 s13, s13, 9
		s_add_i32 s15, s15, s13
		v_add3_u32 v8, s15, v4, v21
		v_add3_u32 v8, v8, v29, v31
		v_add_u32_e32 v10, 0x60, v10
		v_xor_b32_e32 v0, v10, v0
		v_xor_b32_e32 v0, v22, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v8, v8, v122, v0
		v_cndmask_b32_e64 v8, v126, v8, s[24:25]
		buffer_store_dwordx2 v[96:97], v8, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v5, s8
		s_mov_b64 s[24:25], vcc
		s_and_b32 s28, s24, s4
		s_and_b32 s29, s25, s5
		v_lshlrev_b32_e32 v5, 5, v9
		v_lshlrev_b32_e32 v8, 4, v28
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v7, 2, v7
		v_add_u32_e32 v9, 64, v20
		v_lshlrev_b32_e32 v1, 1, v1
		v_xor_b32_e32 v9, v9, v1
		v_xor_b32_e32 v9, v7, v9
		v_xor_b32_e32 v9, v2, v9
		v_xor_b32_e32 v9, v8, v9
		v_xor_b32_e32 v9, v5, v9
		v_mul_lo_u32 v9, s12, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add_u32_e32 v10, s11, v9
		v_add_u32_e32 v17, v10, v123
		v_add3_u32 v17, v17, v124, v125
		v_cndmask_b32_e64 v17, v126, v17, s[28:29]
		buffer_store_dwordx2 v[98:99], v17, s[16:19], 0 offen
		s_and_b32 s28, s24, s6
		s_and_b32 s29, s25, s7
		v_lshl_add_u32 v17, v26, 1, v10
		v_cndmask_b32_e64 v17, v126, v17, s[28:29]
		buffer_store_dwordx2 v[100:101], v17, s[16:19], 0 offen
		s_and_b32 s28, s24, s20
		s_and_b32 s29, s25, s21
		v_lshl_add_u32 v10, v16, 1, v10
		v_cndmask_b32_e64 v10, v126, v10, s[28:29]
		buffer_store_dwordx2 v[102:103], v10, s[16:19], 0 offen
		s_and_b32 s28, s24, s22
		s_and_b32 s29, s25, s23
		v_add3_u32 v10, s15, v9, v0
		v_cndmask_b32_e64 v10, v126, v10, s[28:29]
		buffer_store_dwordx2 v[104:105], v10, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v11, s8
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s28, s4
		s_and_b32 s31, s29, s5
		v_add_u32_e32 v10, 0x80, v20
		v_xor_b32_e32 v10, v10, v1
		v_xor_b32_e32 v10, v7, v10
		v_xor_b32_e32 v10, v2, v10
		v_xor_b32_e32 v10, v8, v10
		v_xor_b32_e32 v10, v5, v10
		v_mul_lo_u32 v10, s12, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v11, s11, v10
		v_add_u32_e32 v17, v11, v123
		v_add3_u32 v17, v17, v124, v125
		v_cndmask_b32_e64 v17, v126, v17, s[30:31]
		buffer_store_dwordx2 v[106:107], v17, s[16:19], 0 offen
		s_and_b32 s30, s28, s6
		s_and_b32 s31, s29, s7
		v_lshl_add_u32 v17, v26, 1, v11
		v_cndmask_b32_e64 v17, v126, v17, s[30:31]
		buffer_store_dwordx2 v[108:109], v17, s[16:19], 0 offen
		s_and_b32 s30, s28, s20
		s_and_b32 s31, s29, s21
		v_lshl_add_u32 v11, v16, 1, v11
		v_cndmask_b32_e64 v11, v126, v11, s[30:31]
		buffer_store_dwordx2 v[110:111], v11, s[16:19], 0 offen
		s_and_b32 s30, s28, s22
		s_and_b32 s31, s29, s23
		v_add3_u32 v11, s15, v10, v0
		v_cndmask_b32_e64 v11, v126, v11, s[30:31]
		buffer_store_dwordx2 v[112:113], v11, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v12, s8
		s_mov_b64 s[30:31], vcc
		s_and_b32 s32, s30, s4
		s_and_b32 s33, s31, s5
		v_add_u32_e32 v11, 0xc0, v20
		v_xor_b32_e32 v1, v11, v1
		v_xor_b32_e32 v1, v7, v1
		v_xor_b32_e32 v1, v2, v1
		v_xor_b32_e32 v1, v8, v1
		v_xor_b32_e32 v1, v5, v1
		v_mul_lo_u32 v1, s12, v1
		v_lshl_add_u32 v2, v1, 1, s15
		v_add_u32_e32 v5, v2, v123
		v_add3_u32 v5, v5, v124, v125
		v_cndmask_b32_e64 v5, v126, v5, s[32:33]
		buffer_store_dwordx2 v[114:115], v5, s[16:19], 0 offen
		s_and_b32 s4, s30, s6
		s_and_b32 s5, s31, s7
		v_lshl_add_u32 v5, v26, 1, v2
		v_cndmask_b32_e64 v5, v126, v5, s[4:5]
		buffer_store_dwordx2 v[116:117], v5, s[16:19], 0 offen
		s_and_b32 s4, s30, s20
		s_and_b32 s5, s31, s21
		v_lshl_add_u32 v5, v16, 1, v2
		v_cndmask_b32_e64 v5, v126, v5, s[4:5]
		buffer_store_dwordx2 v[118:119], v5, s[16:19], 0 offen
		s_and_b32 s4, s30, s22
		s_and_b32 s5, s31, s23
		v_add_u32_e32 v2, v2, v0
		v_cndmask_b32_e64 v2, v126, v2, s[4:5]
		buffer_store_dwordx2 v[120:121], v2, s[16:19], 0 offen
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[88:91], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[88:91], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[80:83], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[80:83], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[88:91], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[88:91], v[56:59], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[64:67], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[80:83], v[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[84:87], v[36:39], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[92:95], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[92:95], v[44:47], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[84:87], v[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[84:87], v[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[92:95], v[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[92:95], v[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[84:87], v[60:63], v[212:215]
		v_cvt_pk_f16_f32 v18, v156, v157
		v_cvt_pk_f16_f32 v19, v158, v159
		v_cvt_pk_f16_f32 v22, v160, v161
		v_cvt_pk_f16_f32 v23, v162, v163
		v_cvt_pk_f16_f32 v32, v164, v165
		v_cvt_pk_f16_f32 v33, v166, v167
		v_cvt_pk_f16_f32 v34, v168, v169
		v_cvt_pk_f16_f32 v35, v170, v171
		v_cvt_pk_f16_f32 v36, v172, v173
		v_cvt_pk_f16_f32 v37, v174, v175
		v_cvt_pk_f16_f32 v38, v176, v177
		v_cvt_pk_f16_f32 v39, v178, v179
		v_cvt_pk_f16_f32 v40, v180, v181
		v_cvt_pk_f16_f32 v41, v182, v183
		v_cvt_pk_f16_f32 v42, v184, v185
		v_cvt_pk_f16_f32 v43, v186, v187
		v_cvt_pk_f16_f32 v44, v188, v189
		v_cvt_pk_f16_f32 v45, v190, v191
		v_cvt_pk_f16_f32 v46, v192, v193
		v_cvt_pk_f16_f32 v47, v194, v195
		v_cvt_pk_f16_f32 v48, v196, v197
		v_cvt_pk_f16_f32 v49, v198, v199
		v_cvt_pk_f16_f32 v50, v200, v201
		v_cvt_pk_f16_f32 v51, v202, v203
		v_cvt_pk_f16_f32 v52, v204, v205
		v_cvt_pk_f16_f32 v53, v206, v207
		v_cvt_pk_f16_f32 v54, v208, v209
		v_cvt_pk_f16_f32 v55, v210, v211
		v_cvt_pk_f16_f32 v56, v212, v213
		v_cvt_pk_f16_f32 v57, v214, v215
		v_cvt_pk_f16_f32 v58, v216, v217
		v_cvt_pk_f16_f32 v59, v218, v219
		s_add_i32 s4, s27, 0x80
		v_add_u32_e32 v2, s4, v6
		v_add_u32_e32 v5, s4, v13
		v_add_u32_e32 v6, s4, v14
		v_add_u32_e32 v7, s4, v15
		v_cmp_lt_i32_e64 vcc, v2, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s6, s2, s4
		s_and_b32 s7, s3, s5
		s_add_i32 s0, s0, 0x100
		s_add_i32 s8, s0, s10
		s_add_i32 s8, s8, s14
		v_lshl_add_u32 v2, v3, 6, s8
		v_add3_u32 v2, v2, v21, v25
		v_add3_u32 v2, v2, v29, v31
		v_add3_u32 v2, v2, v122, v123
		v_add3_u32 v2, v2, v124, v125
		v_cndmask_b32_e64 v2, v126, v2, s[6:7]
		buffer_store_dwordx2 v[18:19], v2, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[6:7], vcc
		s_and_b32 s10, s2, s6
		s_and_b32 s11, s3, s7
		v_add_u32_e32 v2, s8, v4
		v_add3_u32 v2, v2, v21, v29
		v_add3_u32 v2, v2, v31, v122
		v_lshl_add_u32 v3, v26, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[10:11]
		buffer_store_dwordx2 v[22:23], v3, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v6, s9
		s_mov_b64 s[10:11], vcc
		s_and_b32 s14, s2, s10
		s_and_b32 s15, s3, s11
		v_lshl_add_u32 v2, v16, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[14:15]
		buffer_store_dwordx2 v[32:33], v2, s[16:19], 0 offen
		v_cmp_lt_i32_e64 vcc, v7, s9
		s_mov_b64 s[14:15], vcc
		s_and_b32 s20, s2, s14
		s_and_b32 s21, s3, s15
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s13
		v_add3_u32 v2, s0, v4, v21
		v_add3_u32 v2, v2, v29, v31
		v_add3_u32 v2, v2, v122, v0
		v_cndmask_b32_e64 v2, v126, v2, s[20:21]
		buffer_store_dwordx2 v[34:35], v2, s[16:19], 0 offen
		s_and_b32 s2, s24, s4
		s_and_b32 s3, s25, s5
		v_add_u32_e32 v2, s8, v9
		v_add_u32_e32 v3, v2, v123
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[36:37], v3, s[16:19], 0 offen
		s_and_b32 s2, s24, s6
		s_and_b32 s3, s25, s7
		v_lshl_add_u32 v3, v26, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[38:39], v3, s[16:19], 0 offen
		s_and_b32 s2, s24, s10
		s_and_b32 s3, s25, s11
		v_lshl_add_u32 v2, v16, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[40:41], v2, s[16:19], 0 offen
		s_and_b32 s2, s24, s14
		s_and_b32 s3, s25, s15
		v_add3_u32 v2, s0, v9, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[42:43], v2, s[16:19], 0 offen
		s_and_b32 s2, s28, s4
		s_and_b32 s3, s29, s5
		v_add_u32_e32 v2, s8, v10
		v_add_u32_e32 v3, v2, v123
		v_add3_u32 v3, v3, v124, v125
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[44:45], v3, s[16:19], 0 offen
		s_and_b32 s2, s28, s6
		s_and_b32 s3, s29, s7
		v_lshl_add_u32 v3, v26, 1, v2
		v_cndmask_b32_e64 v3, v126, v3, s[2:3]
		buffer_store_dwordx2 v[46:47], v3, s[16:19], 0 offen
		s_and_b32 s2, s28, s10
		s_and_b32 s3, s29, s11
		v_lshl_add_u32 v2, v16, 1, v2
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[48:49], v2, s[16:19], 0 offen
		s_and_b32 s2, s28, s14
		s_and_b32 s3, s29, s15
		v_add3_u32 v2, s0, v10, v0
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[50:51], v2, s[16:19], 0 offen
		s_and_b32 s2, s30, s4
		s_and_b32 s3, s31, s5
		v_lshl_add_u32 v1, v1, 1, s0
		v_add_u32_e32 v2, v1, v123
		v_add3_u32 v2, v2, v124, v125
		v_cndmask_b32_e64 v2, v126, v2, s[2:3]
		buffer_store_dwordx2 v[52:53], v2, s[16:19], 0 offen
		s_and_b32 s0, s30, s6
		s_and_b32 s1, s31, s7
		v_lshl_add_u32 v2, v26, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[54:55], v2, s[16:19], 0 offen
		s_and_b32 s0, s30, s10
		s_and_b32 s1, s31, s11
		v_lshl_add_u32 v2, v16, 1, v1
		v_cndmask_b32_e64 v2, v126, v2, s[0:1]
		buffer_store_dwordx2 v[56:57], v2, s[16:19], 0 offen
		s_and_b32 s0, s30, s14
		s_and_b32 s1, s31, s15
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v126, v0, s[0:1]
		buffer_store_dwordx2 v[58:59], v0, s[16:19], 0 offen
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
		.amdhsa_next_free_sgpr 38
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
	.set .Lv9_beyond_hotloop.numbered_sgpr, 38
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
    .sgpr_count:     38
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
