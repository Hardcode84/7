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
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v3, 1, v2
		v_mad_u32_u24 v1, v3, 2, v1
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v4, 1, v3
		v_mad_u32_u24 v1, v4, 4, v1
		v_lshrrev_b32_e32 v4, 3, v0
		v_and_b32_e32 v5, 1, v4
		v_mad_u32_u24 v1, v5, 8, v1
		v_lshrrev_b32_e32 v5, 7, v0
		v_and_b32_e32 v6, 1, v5
		v_mad_u32_u24 v1, v6, 16, v1
		v_lshrrev_b32_e32 v6, 8, v0
		v_and_b32_e32 v7, 1, v6
		v_mad_u32_u24 v1, v7, 32, v1
		v_add_u32_e32 v7, 0x80, v1
		v_add_u32_e32 v8, 0xc0, v1
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
		v_mul_lo_u32 v14, s10, v6
		v_and_b32_e32 v15, 1, v5
		v_mul_lo_u32 v16, s10, v15
		v_lshlrev_b32_e32 v16, 5, v16
		v_lshl_add_u32 v14, v14, 6, v16
		v_lshrrev_b32_e32 v16, 6, v0
		v_and_b32_e32 v16, 1, v16
		v_mul_lo_u32 v17, s10, v16
		v_lshl_add_u32 v14, v17, 4, v14
		v_lshrrev_b32_e32 v17, 5, v0
		v_and_b32_e32 v17, 1, v17
		v_mul_lo_u32 v18, s10, v17
		v_lshl_add_u32 v14, v18, 3, v14
		v_and_b32_e32 v18, 1, v9
		v_mul_lo_u32 v19, s10, v18
		v_lshl_add_u32 v14, v19, 2, v14
		v_and_b32_e32 v4, 1, v4
		v_mul_lo_u32 v19, s10, v4
		v_lshlrev_b32_e32 v19, 1, v19
		v_and_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v21, 4, v20
		v_add3_u32 v14, v14, v19, v21
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v19, 6, v3
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v22, 5, v2
		v_add3_u32 v14, v14, v19, v22
		s_mul_i32 s3, s1, s10
		s_lshl_b32 s3, s3, 11
		s_mul_i32 s4, s16, s10
		s_lshl_b32 s4, s4, 9
		s_add_i32 s5, s3, s4
		v_add_u32_e32 v23, s5, v14
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		v_add_u32_e32 v23, s13, v1
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s15, s10, 7
		s_add_i32 s17, s15, s3
		s_add_i32 s17, s17, s4
		v_add_u32_e32 v24, s17, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_add3_u32 v1, 64, v1, s13
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s18, s10, 8
		s_add_i32 s19, s18, s3
		s_add_i32 s19, s19, s4
		v_add_u32_e32 v24, s19, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s13, v7
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s28, s10, s3
		s_add_i32 s28, s28, s4
		v_add_u32_e32 v24, s28, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_add_u32_e32 v8, s13, v8
		s_add_i32 m0, m0, 0xa4e0
		v_mul_lo_u32 v24, s11, v6
		v_mul_lo_u32 v25, s11, v15
		v_lshlrev_b32_e32 v25, 5, v25
		v_lshl_add_u32 v24, v24, 6, v25
		v_mul_lo_u32 v25, s11, v16
		v_lshl_add_u32 v24, v25, 4, v24
		v_mul_lo_u32 v17, s11, v17
		v_lshl_add_u32 v17, v17, 3, v24
		v_mul_lo_u32 v18, s11, v18
		v_lshl_add_u32 v17, v18, 2, v17
		v_mul_lo_u32 v18, s11, v4
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v17, v17, v18, v21
		v_add3_u32 v17, v17, v19, v22
		s_mul_i32 s13, s0, s11
		s_lshl_b32 s13, s13, 9
		v_add_u32_e32 v18, s13, v17
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_add_u32_e32 v18, s14, v11
		s_add_i32 m0, m0, 0x2100
		s_lshl_b32 s29, s11, 7
		s_add_i32 s30, s29, s13
		v_add_u32_e32 v19, s30, v17
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_add_u32_e32 v19, s14, v10
		s_add_i32 m0, m0, 0x62e0
		s_lshl_b32 s31, s11, 8
		s_add_i32 s32, s31, s13
		v_add_u32_e32 v21, s32, v17
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		v_add_u32_e32 v21, s14, v12
		s_add_i32 m0, m0, 0x2100
		s_mul_i32 s11, 0x180, s11
		s_add_i32 s33, s11, s13
		v_add_u32_e32 v22, s33, v17
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		v_add_u32_e32 v22, s14, v13
		s_add_i32 m0, m0, 0xfffed740
		s_add_i32 s34, s3, 0x80
		s_add_i32 s34, s34, s4
		v_add_u32_e32 v24, s34, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		s_add_i32 s15, s15, 0x80
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s15, s15, s3
		s_add_i32 s15, s15, s4
		v_add_u32_e32 v24, s15, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		s_add_i32 s18, s18, 0x80
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s18, s18, s3
		s_add_i32 s18, s18, s4
		v_add_u32_e32 v24, s18, v14
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		s_add_i32 s10, s10, 0x80
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s3, s10, s3
		s_add_i32 s3, s3, s4
		v_add_u32_e32 v24, s3, v14
		s_add_i32 s4, s13, 0x80
		v_add_u32_e32 v25, s4, v17
		v_and_b32_e32 v0, 63, v0
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_mov_b32_e32 v24, 0x840
		v_mul_lo_u32 v24, v24, v5
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s10, s29, 0x80
		v_lshrrev_b32_e32 v5, 4, v0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		v_lshlrev_b32_e32 v5, 4, v5
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s10, s10, s13
		v_add_u32_e32 v25, s10, v17
		s_add_i32 s29, s31, 0x80
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		v_add_u32_e32 v24, v24, v5
		s_add_i32 m0, m0, 0x62e0
		s_add_i32 s29, s29, s13
		v_add_u32_e32 v25, s29, v17
		s_add_i32 s11, s11, 0x80
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, m0, 0x2100
		s_add_i32 s11, s11, s13
		v_add_u32_e32 v25, s11, v17
		v_lshrrev_b32_e32 v26, 3, v0
		buffer_load_dwordx4 v25, s[24:27], 0 offen lds
		s_waitcnt vmcnt(10)
		s_barrier
		v_mov_b32_e32 v25, 0x420
		v_mul_lo_u32 v25, v25, v26
		v_lshrrev_b32_e32 v26, 2, v0
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v26, 9, v26
		v_add3_u32 v24, v24, v25, v26
		v_lshrrev_b32_e32 v27, 1, v0
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 8, v27
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 7, v0
		v_add3_u32 v24, v24, v27, v0
		ds_read_b128 v[28:31], v24
		ds_read_b128 v[32:35], v24 offset:64
		ds_read_b128 v[36:39], v24 offset:8448
		ds_read_b128 v[40:43], v24 offset:8512
		ds_read_b128 v[44:47], v24 offset:16896
		ds_read_b128 v[48:51], v24 offset:16960
		ds_read_b128 v[52:55], v24 offset:25344
		ds_read_b128 v[56:59], v24 offset:25408
		v_add_u32_e32 v5, 0x10000, v5
		v_add_u32_e32 v5, v5, v25
		v_mov_b32_e32 v25, 0x840
		v_mul_lo_u32 v25, v25, v16
		v_add3_u32 v5, v5, v25, v26
		v_add3_u32 v0, v5, v27, v0
		ds_read_b128 v[60:63], v0 offset:2016
		ds_read_b128 v[64:67], v0 offset:2080
		ds_read_b128 v[68:71], v0 offset:6240
		ds_read_b128 v[72:75], v0 offset:6304
		ds_read_b128 v[76:79], v0 offset:10464
		ds_read_b128 v[80:83], v0 offset:10528
		ds_read_b128 v[84:87], v0 offset:14688
		ds_read_b128 v[88:91], v0 offset:14752
		s_mov_b32 s31, 0x80
		s_mov_b32 s31, s31
		s_mov_b32 s35, 0
		s_lshl_b32 s36, s31, 1
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		s_mov_b32 s31, s36
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
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[28:31], v[92:95]
		s_add_i32 s35, s35, 2
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[60:63], v0 offset:35776
		ds_read_b128 v[64:67], v0 offset:35840
		ds_read_b128 v[68:71], v0 offset:40000
		ds_read_b128 v[72:75], v0 offset:40064
		ds_read_b128 v[76:79], v0 offset:44224
		ds_read_b128 v[80:83], v0 offset:44288
		ds_read_b128 v[84:87], v0 offset:48448
		ds_read_b128 v[88:91], v0 offset:48512
		v_add_u32_e32 v5, s36, v14
		s_mov_b32 m0, s2
		v_add_u32_e32 v16, s17, v5
		s_add_i32 s37, s5, s36
		v_add_u32_e32 v25, s37, v14
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_add_i32 s37, s34, s36
		v_add_u32_e32 v25, s19, v5
		s_add_i32 s38, s32, s31
		v_add_u32_e32 v5, s28, v5
		s_add_i32 s39, s13, s31
		v_add_u32_e32 v26, s39, v17
		s_add_i32 s39, s30, s31
		v_add_u32_e32 v27, s39, v17
		v_add_u32_e32 v220, s38, v17
		s_add_i32 s38, s33, s31
		v_add_u32_e32 v221, s38, v17
		v_add_u32_e32 v222, s37, v14
		v_add_u32_e32 v223, s36, v14
		v_add_u32_e32 v224, s15, v223
		v_add_u32_e32 v225, s18, v223
		s_add_i32 s37, s29, s31
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[28:31], v[156:159]
		s_add_i32 m0, m0, 0x2100
		v_add_u32_e32 v223, s3, v223
		s_add_i32 s38, s4, s31
		v_add_u32_e32 v226, s38, v17
		s_add_i32 s38, s10, s31
		v_add_u32_e32 v227, s38, v17
		s_add_i32 s38, s11, s31
		s_add_i32 s36, s36, 0x100
		s_add_i32 s31, s31, 0x100
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[28:31], v[160:163]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[28:31], v[164:167]
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[28:31], v[168:171]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[36:39], v[184:187]
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[36:39], v[172:175]
		s_add_i32 m0, m0, 0xa4e0
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[36:39], v[176:179]
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[36:39], v[180:183]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[44:47], v[196:199]
		buffer_load_dwordx4 v27, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[28:31], v24 offset:33792
		ds_read_b128 v[32:35], v24 offset:33856
		ds_read_b128 v[36:39], v24 offset:42240
		ds_read_b128 v[40:43], v24 offset:42304
		ds_read_b128 v[44:47], v24 offset:50688
		ds_read_b128 v[48:51], v24 offset:50752
		ds_read_b128 v[52:55], v24 offset:59136
		ds_read_b128 v[56:59], v24 offset:59200
		ds_read_b128 v[60:63], v0 offset:18912
		ds_read_b128 v[64:67], v0 offset:18976
		ds_read_b128 v[68:71], v0 offset:23136
		ds_read_b128 v[72:75], v0 offset:23200
		ds_read_b128 v[76:79], v0 offset:27360
		ds_read_b128 v[80:83], v0 offset:27424
		ds_read_b128 v[84:87], v0 offset:31584
		ds_read_b128 v[88:91], v0 offset:31648
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[28:31], v[92:95]
		s_add_i32 m0, m0, 0x62e0
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[28:31], v[96:99]
		buffer_load_dwordx4 v220, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[28:31], v[100:103]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[28:31], v[104:107]
		buffer_load_dwordx4 v221, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[60:63], v0 offset:52672
		ds_read_b128 v[64:67], v0 offset:52736
		ds_read_b128 v[68:71], v0 offset:56896
		ds_read_b128 v[72:75], v0 offset:56960
		ds_read_b128 v[76:79], v0 offset:61120
		ds_read_b128 v[80:83], v0 offset:61184
		ds_read_b128 v[84:87], v0 offset:65344
		ds_read_b128 v[88:91], v0 offset:65408
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[28:31], v[156:159]
		s_add_i32 m0, m0, 0xfffed740
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[28:31], v[160:163]
		buffer_load_dwordx4 v222, s[20:23], 0 offen lds
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[28:31], v[164:167]
		s_add_i32 m0, m0, 0x2100
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[28:31], v[168:171]
		buffer_load_dwordx4 v224, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[36:39], v[184:187]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[36:39], v[172:175]
		buffer_load_dwordx4 v225, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[36:39], v[176:179]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[36:39], v[180:183]
		buffer_load_dwordx4 v223, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[44:47], v[196:199]
		s_add_i32 m0, m0, 0x62e0
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[44:47], v[188:191]
		buffer_load_dwordx4 v226, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[44:47], v[192:195]
		s_add_i32 m0, m0, 0x2100
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[44:47], v[200:203]
		buffer_load_dwordx4 v227, s[24:27], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[28:31], v24
		ds_read_b128 v[32:35], v24 offset:64
		ds_read_b128 v[36:39], v24 offset:8448
		ds_read_b128 v[40:43], v24 offset:8512
		ds_read_b128 v[44:47], v24 offset:16896
		ds_read_b128 v[48:51], v24 offset:16960
		ds_read_b128 v[52:55], v24 offset:25344
		ds_read_b128 v[56:59], v24 offset:25408
		ds_read_b128 v[60:63], v0 offset:2016
		ds_read_b128 v[64:67], v0 offset:2080
		ds_read_b128 v[68:71], v0 offset:6240
		ds_read_b128 v[72:75], v0 offset:6304
		ds_read_b128 v[76:79], v0 offset:10464
		ds_read_b128 v[80:83], v0 offset:10528
		ds_read_b128 v[84:87], v0 offset:14688
		ds_read_b128 v[88:91], v0 offset:14752
		s_add_i32 m0, m0, 0x62e0
		v_add_u32_e32 v5, s37, v17
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add_u32_e32 v5, s38, v17
		s_add_i32 m0, m0, 0x2100
		s_cmp_lt_i32 s35, 62
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[28:31], v[92:95]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[80:83], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[60:63], v0 offset:35776
		ds_read_b128 v[64:67], v0 offset:35840
		ds_read_b128 v[68:71], v0 offset:40000
		ds_read_b128 v[72:75], v0 offset:40064
		ds_read_b128 v[76:79], v0 offset:44224
		ds_read_b128 v[80:83], v0 offset:44288
		ds_read_b128 v[84:87], v0 offset:48448
		ds_read_b128 v[88:91], v0 offset:48512
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[28:31], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[28:31], v[160:163]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[28:31], v[164:167]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[52:55], v[216:219]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[80:83], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
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
		ds_read_b128 v[28:31], v24 offset:33792
		ds_read_b128 v[32:35], v24 offset:33856
		ds_read_b128 v[36:39], v24 offset:42240
		ds_read_b128 v[40:43], v24 offset:42304
		ds_read_b128 v[44:47], v24 offset:50688
		ds_read_b128 v[48:51], v24 offset:50752
		ds_read_b128 v[52:55], v24 offset:59136
		ds_read_b128 v[56:59], v24 offset:59200
		ds_read_b128 v[24:27], v0 offset:18912
		ds_read_b128 v[60:63], v0 offset:18976
		ds_read_b128 v[64:67], v0 offset:23136
		ds_read_b128 v[68:71], v0 offset:23200
		ds_read_b128 v[72:75], v0 offset:27360
		ds_read_b128 v[76:79], v0 offset:27424
		ds_read_b128 v[80:83], v0 offset:31584
		ds_read_b128 v[84:87], v0 offset:31648
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], v[28:31], v[92:95]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[96:99], v[64:67], v[28:31], v[96:99]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[100:103], v[72:75], v[28:31], v[100:103]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[24:27], v[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[64:67], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[24:27], v[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[64:67], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[52:55], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[24:27], v[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[76:79], v[32:35], v[100:103]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[56:59], v[152:155]
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[56:59], v[148:151]
		ds_read_b128 v[24:27], v0 offset:52672
		ds_read_b128 v[60:63], v0 offset:52736
		ds_read_b128 v[64:67], v0 offset:56896
		ds_read_b128 v[68:71], v0 offset:56960
		ds_read_b128 v[72:75], v0 offset:61120
		ds_read_b128 v[76:79], v0 offset:61184
		ds_read_b128 v[80:83], v0 offset:65344
		ds_read_b128 v[84:87], v0 offset:65408
		v_cvt_pk_f16_f32 v16, v92, v93
		v_cvt_pk_f16_f32 v17, v94, v95
		v_cvt_pk_f16_f32 v88, v96, v97
		v_cvt_pk_f16_f32 v89, v98, v99
		v_cvt_pk_f16_f32 v90, v100, v101
		v_cvt_pk_f16_f32 v91, v102, v103
		v_cvt_pk_f16_f32 v92, v104, v105
		v_cvt_pk_f16_f32 v93, v106, v107
		v_cvt_pk_f16_f32 v94, v108, v109
		v_cvt_pk_f16_f32 v95, v110, v111
		v_cvt_pk_f16_f32 v96, v112, v113
		v_cvt_pk_f16_f32 v97, v114, v115
		v_cvt_pk_f16_f32 v98, v116, v117
		v_cvt_pk_f16_f32 v99, v118, v119
		v_cvt_pk_f16_f32 v100, v120, v121
		v_cvt_pk_f16_f32 v101, v122, v123
		v_cvt_pk_f16_f32 v102, v124, v125
		v_cvt_pk_f16_f32 v103, v126, v127
		v_cvt_pk_f16_f32 v104, v128, v129
		v_cvt_pk_f16_f32 v105, v130, v131
		v_cvt_pk_f16_f32 v106, v132, v133
		v_cvt_pk_f16_f32 v107, v134, v135
		v_cvt_pk_f16_f32 v108, v136, v137
		v_cvt_pk_f16_f32 v109, v138, v139
		v_cvt_pk_f16_f32 v110, v140, v141
		v_cvt_pk_f16_f32 v111, v142, v143
		v_cvt_pk_f16_f32 v112, v144, v145
		v_cvt_pk_f16_f32 v113, v146, v147
		v_cvt_pk_f16_f32 v114, v148, v149
		v_cvt_pk_f16_f32 v115, v150, v151
		v_cvt_pk_f16_f32 v116, v152, v153
		v_cvt_pk_f16_f32 v117, v154, v155
		v_cmp_lt_i32_e64 vcc, v23, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v18, s9
		s_mov_b64 s[4:5], vcc
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		v_cmp_lt_i32_e64 vcc, v19, s9
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s2, s18
		s_and_b32 s21, s3, s19
		v_cmp_lt_i32_e64 vcc, v21, s9
		s_mov_b64 s[24:25], vcc
		s_and_b32 s26, s2, s24
		s_and_b32 s27, s3, s25
		v_cmp_lt_i32_e64 vcc, v22, s9
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s2, s28
		s_and_b32 s31, s3, s29
		v_cmp_lt_i32_e64 vcc, v1, s8
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s32, s4
		s_and_b32 s35, s33, s5
		s_and_b32 s36, s32, s18
		s_and_b32 s37, s33, s19
		s_and_b32 s38, s32, s24
		s_and_b32 s39, s33, s25
		s_and_b32 s40, s32, s28
		s_and_b32 s41, s33, s29
		v_cmp_lt_i32_e64 vcc, v7, s8
		s_mov_b64 s[42:43], vcc
		s_and_b32 s44, s42, s4
		s_and_b32 s45, s43, s5
		s_and_b32 s46, s42, s18
		s_and_b32 s47, s43, s19
		s_and_b32 s48, s42, s24
		s_and_b32 s49, s43, s25
		s_and_b32 s50, s42, s28
		s_and_b32 s51, s43, s29
		v_cmp_lt_i32_e64 vcc, v8, s8
		s_mov_b64 s[52:53], vcc
		s_and_b32 s54, s52, s4
		s_and_b32 s55, s53, s5
		s_and_b32 s4, s52, s18
		s_and_b32 s5, s53, s19
		s_and_b32 s18, s52, s24
		s_and_b32 s19, s53, s25
		s_and_b32 s24, s52, s28
		s_and_b32 s25, s53, s29
		s_lshl_b32 s0, s0, 9
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s8, s0, s1
		s_mul_i32 s13, s12, s16
		s_lshl_b32 s13, s13, 9
		s_add_i32 s8, s8, s13
		v_mul_lo_u32 v0, s12, v6
		v_lshl_add_u32 v1, v0, 6, s8
		v_mul_lo_u32 v5, s12, v20
		v_lshlrev_b32_e32 v5, 1, v5
		v_mul_lo_u32 v6, s12, v15
		v_lshlrev_b32_e32 v6, 5, v6
		v_add3_u32 v1, v1, v5, v6
		v_mul_lo_u32 v4, s12, v4
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v3, s12, v3
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v1, v1, v4, v3
		v_mul_lo_u32 v2, s12, v2
		v_lshlrev_b32_e32 v2, 2, v2
		v_and_b32_e32 v7, 7, v9
		v_lshlrev_b32_e32 v7, 3, v7
		v_add3_u32 v1, v1, v2, v7
		v_mov_b32_e32 v8, 0x80000000
		v_cndmask_b32_e64 v1, v8, v1, s[10:11]
		s_mov_b32 s56, s6
		s_mov_b32 s57, s7
		s_mov_b32 s58, s22
		s_mov_b32 s59, s23
		buffer_store_dwordx2 v[16:17], v1, s[56:59], 0 offen
		s_add_i32 s6, s0, 64
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s13
		v_lshl_add_u32 v1, v0, 6, s6
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[20:21]
		buffer_store_dwordx2 v[88:89], v1, s[56:59], 0 offen
		s_add_i32 s6, s0, 0x80
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s13
		v_lshl_add_u32 v1, v0, 6, s6
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[26:27]
		buffer_store_dwordx2 v[90:91], v1, s[56:59], 0 offen
		s_add_i32 s6, s0, 0xc0
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s13
		v_lshl_add_u32 v1, v0, 6, s6
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[30:31]
		buffer_store_dwordx2 v[92:93], v1, s[56:59], 0 offen
		s_lshl_b32 s6, s12, 7
		s_add_i32 s7, s6, s0
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s13
		v_lshl_add_u32 v1, v0, 6, s7
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[34:35]
		buffer_store_dwordx2 v[94:95], v1, s[56:59], 0 offen
		s_add_i32 s7, s6, 64
		s_add_i32 s7, s7, s0
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s13
		v_lshl_add_u32 v1, v0, 6, s7
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[36:37]
		buffer_store_dwordx2 v[96:97], v1, s[56:59], 0 offen
		s_add_i32 s7, s6, 0x80
		s_add_i32 s7, s7, s0
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s13
		v_lshl_add_u32 v1, v0, 6, s7
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[38:39]
		buffer_store_dwordx2 v[98:99], v1, s[56:59], 0 offen
		s_add_i32 s7, s6, 0xc0
		s_add_i32 s7, s7, s0
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s13
		v_lshl_add_u32 v1, v0, 6, s7
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[40:41]
		buffer_store_dwordx2 v[100:101], v1, s[56:59], 0 offen
		s_lshl_b32 s7, s12, 8
		s_add_i32 s8, s7, s0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v1, v0, 6, s8
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[44:45]
		buffer_store_dwordx2 v[102:103], v1, s[56:59], 0 offen
		s_add_i32 s8, s7, 64
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v1, v0, 6, s8
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[46:47]
		buffer_store_dwordx2 v[104:105], v1, s[56:59], 0 offen
		s_add_i32 s8, s7, 0x80
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v1, v0, 6, s8
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[48:49]
		buffer_store_dwordx2 v[106:107], v1, s[56:59], 0 offen
		s_add_i32 s8, s7, 0xc0
		s_add_i32 s8, s8, s0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s13
		v_lshl_add_u32 v1, v0, 6, s8
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[50:51]
		buffer_store_dwordx2 v[108:109], v1, s[56:59], 0 offen
		s_mul_i32 s8, 0x180, s12
		s_add_i32 s10, s8, s0
		s_add_i32 s10, s10, s1
		s_add_i32 s10, s10, s13
		v_lshl_add_u32 v1, v0, 6, s10
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[54:55]
		buffer_store_dwordx2 v[110:111], v1, s[56:59], 0 offen
		s_add_i32 s10, s8, 64
		s_add_i32 s10, s10, s0
		s_add_i32 s10, s10, s1
		s_add_i32 s10, s10, s13
		v_lshl_add_u32 v1, v0, 6, s10
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[4:5]
		buffer_store_dwordx2 v[112:113], v1, s[56:59], 0 offen
		s_add_i32 s4, s8, 0x80
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s13
		v_lshl_add_u32 v1, v0, 6, s4
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[18:19]
		buffer_store_dwordx2 v[114:115], v1, s[56:59], 0 offen
		s_add_i32 s4, s8, 0xc0
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s13
		v_lshl_add_u32 v1, v0, 6, s4
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[24:25]
		buffer_store_dwordx2 v[116:117], v1, s[56:59], 0 offen
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[28:31], v[156:159]
		s_add_i32 s4, s14, 0x80
		v_add_u32_e32 v1, s4, v11
		v_add_u32_e32 v9, s4, v10
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[28:31], v[160:163]
		v_add_u32_e32 v10, s4, v12
		v_add_u32_e32 v11, s4, v13
		v_cmp_lt_i32_e64 vcc, v1, s9
		s_mov_b64 s[4:5], vcc
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[28:31], v[164:167]
		s_and_b32 s10, s2, s4
		s_and_b32 s11, s3, s5
		v_cmp_lt_i32_e64 vcc, v9, s9
		s_mov_b64 s[14:15], vcc
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[168:171], v[80:83], v[28:31], v[168:171]
		s_and_b32 s16, s2, s14
		s_and_b32 s17, s3, s15
		v_cmp_lt_i32_e64 vcc, v10, s9
		s_mov_b64 s[18:19], vcc
		v_mfma_f32_16x16x32_f16 v[184:187], v[80:83], v[36:39], v[184:187]
		s_and_b32 s20, s2, s18
		s_and_b32 s21, s3, s19
		v_cmp_lt_i32_e64 vcc, v11, s9
		s_mov_b64 s[22:23], vcc
		v_mfma_f32_16x16x32_f16 v[172:175], v[24:27], v[36:39], v[172:175]
		s_and_b32 s24, s2, s22
		s_and_b32 s25, s3, s23
		s_and_b32 s2, s32, s4
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[36:39], v[176:179]
		s_and_b32 s3, s33, s5
		s_and_b32 s26, s32, s14
		s_and_b32 s27, s33, s15
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[36:39], v[180:183]
		s_and_b32 s28, s32, s18
		s_and_b32 s29, s33, s19
		s_and_b32 s30, s32, s22
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[44:47], v[196:199]
		s_and_b32 s31, s33, s23
		s_and_b32 s32, s42, s4
		s_and_b32 s33, s43, s5
		v_mfma_f32_16x16x32_f16 v[188:191], v[24:27], v[44:47], v[188:191]
		s_and_b32 s34, s42, s14
		s_and_b32 s35, s43, s15
		s_and_b32 s36, s42, s18
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[44:47], v[192:195]
		s_and_b32 s37, s43, s19
		s_and_b32 s38, s42, s22
		s_and_b32 s39, s43, s23
		v_mfma_f32_16x16x32_f16 v[200:203], v[80:83], v[44:47], v[200:203]
		s_and_b32 s40, s52, s4
		s_and_b32 s41, s53, s5
		s_and_b32 s4, s52, s14
		v_mfma_f32_16x16x32_f16 v[216:219], v[80:83], v[52:55], v[216:219]
		s_and_b32 s5, s53, s15
		s_and_b32 s14, s52, s18
		s_and_b32 s15, s53, s19
		v_mfma_f32_16x16x32_f16 v[204:207], v[24:27], v[52:55], v[204:207]
		s_and_b32 s18, s52, s22
		s_and_b32 s19, s53, s23
		s_add_i32 s9, s0, 0x100
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[52:55], v[208:211]
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v1, v0, 6, s9
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[52:55], v[212:215]
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[32:35], v[156:159]
		v_cndmask_b32_e64 v1, v8, v1, s[10:11]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[32:35], v[164:167]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[40:43], v[180:183]
		v_cvt_pk_f16_f32 v10, v156, v157
		v_cvt_pk_f16_f32 v11, v158, v159
		v_cvt_pk_f16_f32 v12, v160, v161
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[48:51], v[196:199]
		v_cvt_pk_f16_f32 v13, v162, v163
		v_cvt_pk_f16_f32 v14, v164, v165
		v_cvt_pk_f16_f32 v15, v166, v167
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[48:51], v[188:191]
		v_cvt_pk_f16_f32 v16, v168, v169
		v_cvt_pk_f16_f32 v17, v170, v171
		v_cvt_pk_f16_f32 v18, v172, v173
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[48:51], v[192:195]
		v_cvt_pk_f16_f32 v19, v174, v175
		v_cvt_pk_f16_f32 v20, v176, v177
		v_cvt_pk_f16_f32 v21, v178, v179
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[48:51], v[200:203]
		v_cvt_pk_f16_f32 v22, v180, v181
		v_cvt_pk_f16_f32 v23, v182, v183
		v_cvt_pk_f16_f32 v24, v184, v185
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[56:59], v[216:219]
		v_cvt_pk_f16_f32 v25, v186, v187
		v_cvt_pk_f16_f32 v26, v188, v189
		v_cvt_pk_f16_f32 v27, v190, v191
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[56:59], v[204:207]
		v_cvt_pk_f16_f32 v28, v192, v193
		v_cvt_pk_f16_f32 v29, v194, v195
		v_cvt_pk_f16_f32 v30, v196, v197
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[56:59], v[208:211]
		v_cvt_pk_f16_f32 v31, v198, v199
		v_cvt_pk_f16_f32 v32, v200, v201
		v_cvt_pk_f16_f32 v33, v202, v203
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[56:59], v[212:215]
		v_cvt_pk_f16_f32 v34, v204, v205
		v_cvt_pk_f16_f32 v35, v206, v207
		v_cvt_pk_f16_f32 v36, v216, v217
		v_cvt_pk_f16_f32 v37, v218, v219
		v_cvt_pk_f16_f32 v38, v208, v209
		v_cvt_pk_f16_f32 v39, v210, v211
		buffer_store_dwordx2 v[10:11], v1, s[56:59], 0 offen
		s_add_i32 s9, s0, 0x140
		v_cvt_pk_f16_f32 v10, v212, v213
		v_cvt_pk_f16_f32 v11, v214, v215
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v1, v0, 6, s9
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[16:17]
		buffer_store_dwordx2 v[12:13], v1, s[56:59], 0 offen
		s_add_i32 s9, s0, 0x180
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v1, v0, 6, s9
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[20:21]
		buffer_store_dwordx2 v[14:15], v1, s[56:59], 0 offen
		s_add_i32 s9, s0, 0x1c0
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v1, v0, 6, s9
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[24:25]
		buffer_store_dwordx2 v[16:17], v1, s[56:59], 0 offen
		s_add_i32 s9, s6, 0x100
		s_add_i32 s9, s9, s0
		s_add_i32 s9, s9, s1
		s_add_i32 s9, s9, s13
		v_lshl_add_u32 v1, v0, 6, s9
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[2:3]
		buffer_store_dwordx2 v[18:19], v1, s[56:59], 0 offen
		s_add_i32 s2, s6, 0x140
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[26:27]
		buffer_store_dwordx2 v[20:21], v1, s[56:59], 0 offen
		s_add_i32 s2, s6, 0x180
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[28:29]
		buffer_store_dwordx2 v[22:23], v1, s[56:59], 0 offen
		s_add_i32 s2, s6, 0x1c0
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[30:31]
		buffer_store_dwordx2 v[24:25], v1, s[56:59], 0 offen
		s_add_i32 s2, s7, 0x100
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[32:33]
		buffer_store_dwordx2 v[26:27], v1, s[56:59], 0 offen
		s_add_i32 s2, s7, 0x140
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[34:35]
		buffer_store_dwordx2 v[28:29], v1, s[56:59], 0 offen
		s_add_i32 s2, s7, 0x180
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[36:37]
		buffer_store_dwordx2 v[30:31], v1, s[56:59], 0 offen
		s_add_i32 s2, s7, 0x1c0
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[38:39]
		buffer_store_dwordx2 v[32:33], v1, s[56:59], 0 offen
		s_add_i32 s2, s8, 0x100
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[40:41]
		buffer_store_dwordx2 v[34:35], v1, s[56:59], 0 offen
		s_add_i32 s2, s8, 0x140
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[4:5]
		buffer_store_dwordx2 v[38:39], v1, s[56:59], 0 offen
		s_add_i32 s2, s8, 0x180
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s13
		v_lshl_add_u32 v1, v0, 6, s2
		v_add3_u32 v1, v1, v5, v6
		v_add3_u32 v1, v1, v4, v3
		v_add3_u32 v1, v1, v2, v7
		v_cndmask_b32_e64 v1, v8, v1, s[14:15]
		buffer_store_dwordx2 v[10:11], v1, s[56:59], 0 offen
		s_add_i32 s2, s8, 0x1c0
		s_add_i32 s0, s2, s0
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s13
		v_lshl_add_u32 v0, v0, 6, s0
		v_add3_u32 v0, v0, v5, v6
		v_add3_u32 v0, v0, v4, v3
		v_add3_u32 v0, v0, v2, v7
		v_cndmask_b32_e64 v0, v8, v0, s[18:19]
		buffer_store_dwordx2 v[36:37], v0, s[56:59], 0 offen
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
		.amdhsa_next_free_vgpr 228
		.amdhsa_next_free_sgpr 60
		.amdhsa_accum_offset 228
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
	.set .Lv9_beyond_hotloop.num_vgpr, 228
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 60
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
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     228
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
