	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	wmma_f16_matmul_tiled
	.p2align	8
	.type	wmma_f16_matmul_tiled,@function
wmma_f16_matmul_tiled:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dword s8, s[0:1], 0x18
		s_waitcnt lgkmcnt(0)
		s_branch .Lwmma_f16_matmul_tiled.kernarg_preload_entry
	.p2align	8
.Lwmma_f16_matmul_tiled.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_mov_b32 s14, 0x8000000
		s_mov_b32 s15, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, s14
		s_mov_b32 s19, s15
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s14
		s_mov_b32 s23, s15
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		s_lshl_b32 s1, s0, 10
		v_lshrrev_b32_e32 v1, 8, v0
		v_lshlrev_b32_e32 v2, 12, v1
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v6, 4, v5
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v6, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v7, 0x8000, v4
		v_lshrrev_b32_e32 v0, 6, v0
		v_and_b32_e32 v0, 3, v0
		v_lshlrev_b32_e32 v8, 11, v0
		s_add_i32 m0, s1, 0x8000
		v_lshrrev_b32_e32 v9, 2, v5
		v_lshlrev_b32_e32 v9, 14, v9
		v_lshl_add_u32 v9, s0, 18, v9
		v_lshrrev_b32_e32 v10, 3, v5
		v_bitop3_b32 v10, v10, 3, v5 bitop3:0x48
		v_lshl_add_u32 v9, v10, 4, v9
		s_lshl_b32 s8, s10, 22
		buffer_load_dwordx4 v9, s[20:23], s8 offen lds
		v_add3_u32 v2, v2, v4, v3
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s10, s8, 64
		buffer_load_dwordx4 v9, s[20:23], s10 offen lds
		v_add3_u32 v3, v7, v8, v3
		s_mov_b32 m0, s1
		s_lshr_b32 s10, s9, 3
		s_lshl_b32 s11, s10, 22
		s_and_b32 s9, s9, 7
		s_lshl_b32 s12, s9, 24
		s_add_i32 s13, s11, s12
		buffer_load_dwordx4 v9, s[16:19], s13 offen lds
		s_add_i32 s24, s11, 64
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v9, s[16:19], s24 offen lds
		s_lshl_b32 s9, s9, 11
		s_add_i32 m0, m0, 0xffffe000
		s_add_i32 s24, s11, 0x200000
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v9, s[16:19], s24 offen lds
		v_and_b32_e32 v4, 15, v5
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s24, s11, 0x200040
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v9, s[16:19], s24 offen lds
		v_lshlrev_b32_e32 v5, 3, v6
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s24, s8, 0x200000
		buffer_load_dwordx4 v9, s[20:23], s24 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s8, 0x200040
		buffer_load_dwordx4 v9, s[20:23], s4 offen lds
		v_add_u32_e32 v6, s13, v9
		s_add_i32 m0, m0, 0xa000
		s_add_i32 s4, s8, 0x80
		buffer_load_dwordx4 v9, s[20:23], s4 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s2, s8, 0xc0
		s_add_i32 s3, s11, 0x80
		buffer_load_dwordx4 v9, s[20:23], s2 offen lds
		s_mov_b32 s2, 1
		s_add_i32 m0, m0, 0xffff4000
		s_add_i32 s3, s3, s12
		s_add_i32 s4, s11, 0xc0
		buffer_load_dwordx4 v9, s[16:19], s3 offen lds
		s_mov_b32 s3, 0
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s4, s12
		buffer_load_dwordx4 v9, s[16:19], s4 offen lds
		v_add_u32_e32 v7, s8, v9
		s_add_i32 m0, m0, 0xffffe000
		s_add_i32 s4, s11, 0x200080
		s_add_i32 s4, s4, s12
		buffer_load_dwordx4 v9, s[16:19], s4 offen lds
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s11, 0x2000c0
		s_add_i32 s4, s4, s12
		buffer_load_dwordx4 v9, s[16:19], s4 offen lds
		v_mov_b32_e32 v8, v3
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s8, 0x200080
		buffer_load_dwordx4 v9, s[20:23], s4 offen lds
		v_mov_b32_e32 v10, v2
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s4, s8, 0x2000c0
		buffer_load_dwordx4 v9, s[20:23], s4 offen lds
		s_waitcnt vmcnt(12)
		s_barrier
		ds_read_b128 v[16:19], v3
		ds_read_b128 v[20:23], v3 offset:1024
		ds_read_b128 v[24:27], v3 offset:16384
		ds_read_b128 v[28:31], v3 offset:17408
		ds_read_b128 v[32:35], v2
		ds_read_b128 v[36:39], v2 offset:1024
		ds_read_b128 v[40:43], v2 offset:2048
		ds_read_b128 v[44:47], v2 offset:3072
		ds_read_b128 v[48:51], v2 offset:16384
		ds_read_b128 v[52:55], v2 offset:17408
		ds_read_b128 v[56:59], v2 offset:18432
		ds_read_b128 v[60:63], v2 offset:19456
		s_cmp_lt_u32 s3, 0
		s_cselect_b32 s4, s2, 0
		s_cmp_eq_u32 s3, 0
		s_cselect_b32 s5, s2, 0
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_u32 s0, 4
		s_cselect_b32 s11, s2, 0
		s_and_b32 s11, s5, s11
		s_or_b32 s4, s4, s11
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s4, 1, 0
		s_cmp_gt_u32 s3, 0
		s_cselect_b32 s11, s2, 0
		s_cmp_ge_u32 s0, 4
		s_cselect_b32 s0, s2, 0
		s_and_b32 s0, s5, s0
		s_or_b32 s0, s11, s0
		s_cmp_lg_u32 s0, 0
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_end_0
		s_barrier
.Lwmma_f16_matmul_tiled.if_end_0:
		v_add_u32_e32 v9, 0x100, v6
		v_add_u32_e32 v11, 0x200100, v6
		v_add_u32_e32 v64, 0x140, v6
		v_add_u32_e32 v65, 0x200140, v6
		v_add_u32_e32 v66, 0x100, v7
		v_add_u32_e32 v67, 0x200100, v7
		v_add_u32_e32 v68, 0x140, v7
		v_add_u32_e32 v69, 0x200140, v7
		v_add_u32_e32 v70, 0x180, v6
		v_add_u32_e32 v71, 0x200180, v6
		v_add_u32_e32 v72, 0x1c0, v6
		v_add_u32_e32 v73, 0x2001c0, v6
		v_add_u32_e32 v6, 0x180, v7
		v_add_u32_e32 v74, 0x200180, v7
		v_add_u32_e32 v75, 0x1c0, v7
		v_add_u32_e32 v76, 0x2001c0, v7
		v_add_u32_e32 v7, 0x10000, v3
		v_add_u32_e32 v77, 0x10000, v2
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
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
		s_mov_b32 s0, s3
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_xor_b32 s0, s0, -1
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[12:15], v[32:35], v[16:19], v[12:15]
		v_mfma_f32_16x16x32_f16 v[92:95], v[36:39], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[108:111], v[40:43], v[16:19], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[44:47], v[16:19], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[44:47], v[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[40:43], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[36:39], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[32:35], v[20:23], v[80:83]
		v_mfma_f32_16x16x32_f16 v[12:15], v[48:51], v[24:27], v[12:15]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[24:27], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[52:55], v[28:31], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[48:51], v[28:31], v[80:83]
		s_setprio 1
		s_barrier
		s_add_i32 m0, s1, 0x8000
		s_add_i32 s0, s0, 1
		buffer_load_dwordx4 v66, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s0, s0, 0x4000
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		ds_read_b128 v[204:207], v10 offset:8192
		ds_read_b128 v[208:211], v10 offset:9216
		ds_read_b128 v[212:215], v10 offset:10240
		ds_read_b128 v[216:219], v10 offset:11264
		ds_read_b128 v[220:223], v10 offset:24576
		ds_read_b128 v[224:227], v10 offset:25600
		ds_read_b128 v[228:231], v10 offset:26624
		ds_read_b128 v[232:235], v10 offset:27648
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[140:143], v[204:207], v[16:19], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[208:211], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[212:215], v[16:19], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[216:219], v[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[216:219], v[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[212:215], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[208:211], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[204:207], v[20:23], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[220:223], v[24:27], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[224:227], v[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[228:231], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[232:235], v[24:27], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[232:235], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[228:231], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[224:227], v[28:31], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[220:223], v[28:31], v[144:147]
		s_setprio 1
		s_barrier
		s_mov_b32 m0, s1
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v64, s[16:19], 0 offen lds
		ds_read_b128 v[16:19], v8 offset:8192
		ds_read_b128 v[20:23], v8 offset:9216
		ds_read_b128 v[24:27], v8 offset:24576
		ds_read_b128 v[28:31], v8 offset:25600
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[84:87], v[32:35], v[16:19], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[32:35], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[36:39], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[36:39], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[40:43], v[16:19], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[44:47], v[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[20:23], v[136:139]
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[28:31], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[60:63], v[24:27], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[28:31], v[136:139]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0xffffe000
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v65, s[16:19], 0 offen lds
		ds_read_b128 v[32:35], v7
		ds_read_b128 v[36:39], v7 offset:1024
		ds_read_b128 v[40:43], v7 offset:16384
		ds_read_b128 v[44:47], v7 offset:17408
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[148:151], v[204:207], v[16:19], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[204:207], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[208:211], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[208:211], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[212:215], v[16:19], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[216:219], v[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[216:219], v[20:23], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[212:215], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[148:151], v[220:223], v[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[220:223], v[28:31], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[224:227], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[224:227], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[228:231], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[232:235], v[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[232:235], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[228:231], v[28:31], v[184:187]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0x4000
		s_xor_b32 s0, s0, -1
		buffer_load_dwordx4 v67, s[20:23], 0 offen lds
		s_add_i32 s0, s0, 1
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s0, s0, 0x4000
		buffer_load_dwordx4 v69, s[20:23], 0 offen lds
		ds_read_b128 v[16:19], v77
		ds_read_b128 v[20:23], v77 offset:1024
		ds_read_b128 v[24:27], v77 offset:2048
		ds_read_b128 v[28:31], v77 offset:3072
		ds_read_b128 v[48:51], v77 offset:16384
		ds_read_b128 v[52:55], v77 offset:17408
		ds_read_b128 v[56:59], v77 offset:18432
		ds_read_b128 v[60:63], v77 offset:19456
		s_mul_i32 s2, s0, 4
		v_add_u32_e32 v10, s2, v2
		v_add_u32_e32 v8, s2, v3
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[12:15], v[16:19], v[32:35], v[12:15]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[108:111], v[24:27], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[28:31], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[28:31], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[24:27], v[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], v[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], v[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[12:15], v[48:51], v[40:43], v[12:15]
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[40:43], v[92:95]
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[40:43], v[108:111]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[52:55], v[44:47], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[48:51], v[44:47], v[80:83]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0xa000
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v75, s[20:23], 0 offen lds
		ds_read_b128 v[204:207], v77 offset:8192
		ds_read_b128 v[208:211], v77 offset:9216
		ds_read_b128 v[212:215], v77 offset:10240
		ds_read_b128 v[216:219], v77 offset:11264
		ds_read_b128 v[220:223], v77 offset:24576
		ds_read_b128 v[224:227], v77 offset:25600
		ds_read_b128 v[228:231], v77 offset:26624
		ds_read_b128 v[232:235], v77 offset:27648
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[140:143], v[204:207], v[32:35], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[208:211], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[212:215], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[216:219], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[216:219], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[212:215], v[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[208:211], v[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[204:207], v[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[220:223], v[40:43], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[224:227], v[40:43], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[228:231], v[40:43], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[232:235], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[232:235], v[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[228:231], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[224:227], v[44:47], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[220:223], v[44:47], v[144:147]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0xffff4000
		s_nop 0
		buffer_load_dwordx4 v70, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v72, s[16:19], 0 offen lds
		ds_read_b128 v[32:35], v7 offset:8192
		ds_read_b128 v[36:39], v7 offset:9216
		ds_read_b128 v[40:43], v7 offset:24576
		ds_read_b128 v[44:47], v7 offset:25600
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], v[32:35], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], v[36:39], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], v[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[24:27], v[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[24:27], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[28:31], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[28:31], v[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[40:43], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[44:47], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[44:47], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[60:63], v[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[44:47], v[136:139]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0xffffe000
		s_nop 0
		buffer_load_dwordx4 v71, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_nop 0
		buffer_load_dwordx4 v73, s[16:19], 0 offen lds
		ds_read_b128 v[16:19], v8
		ds_read_b128 v[20:23], v8 offset:1024
		ds_read_b128 v[24:27], v8 offset:16384
		ds_read_b128 v[28:31], v8 offset:17408
		s_setprio 0
		s_waitcnt vmcnt(10) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[148:151], v[204:207], v[32:35], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[204:207], v[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[208:211], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[208:211], v[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[212:215], v[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[216:219], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[216:219], v[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[212:215], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[148:151], v[220:223], v[40:43], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[220:223], v[44:47], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[224:227], v[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[224:227], v[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[228:231], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[232:235], v[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[232:235], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[228:231], v[44:47], v[184:187]
		s_setprio 1
		s_barrier
		s_add_i32 m0, m0, 0x4000
		s_add_u32 s16, s16, 0x100
		s_addc_u32 s17, s17, 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s3, s3, 1
		buffer_load_dwordx4 v76, s[20:23], 0 offen lds
		ds_read_b128 v[32:35], v10
		ds_read_b128 v[36:39], v10 offset:1024
		ds_read_b128 v[40:43], v10 offset:2048
		ds_read_b128 v[44:47], v10 offset:3072
		ds_read_b128 v[48:51], v10 offset:16384
		ds_read_b128 v[52:55], v10 offset:17408
		ds_read_b128 v[56:59], v10 offset:18432
		ds_read_b128 v[60:63], v10 offset:19456
		s_add_u32 s20, s20, 0x100
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s3, 63
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_cmp_lg_u32 s4, 0
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_end_1
		s_barrier
.Lwmma_f16_matmul_tiled.if_end_1:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[12:15], v[32:35], v[16:19], v[12:15]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[92:95], v[36:39], v[16:19], v[92:95]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[40:43], v[16:19], v[108:111]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[44:47], v[16:19], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[44:47], v[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[40:43], v[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[36:39], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[32:35], v[20:23], v[80:83]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[12:15], v[48:51], v[24:27], v[12:15]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[92:95], v[52:55], v[24:27], v[92:95]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[108:111], v[56:59], v[24:27], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[24:27], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[60:63], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[56:59], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[52:55], v[28:31], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[48:51], v[28:31], v[80:83]
		s_setprio 1
		s_waitcnt vmcnt(10)
		s_barrier
		ds_read_b128 v[64:67], v10 offset:8192
		ds_read_b128 v[68:71], v10 offset:9216
		ds_read_b128 v[72:75], v10 offset:10240
		ds_read_b128 v[204:207], v10 offset:11264
		ds_read_b128 v[208:211], v10 offset:24576
		ds_read_b128 v[212:215], v10 offset:25600
		ds_read_b128 v[216:219], v10 offset:26624
		ds_read_b128 v[220:223], v10 offset:27648
		s_setprio 0
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[16:19], v[140:143]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[16:19], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[16:19], v[172:175]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[188:191], v[204:207], v[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[204:207], v[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[64:67], v[20:23], v[144:147]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[140:143], v[208:211], v[24:27], v[140:143]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[156:159], v[212:215], v[24:27], v[156:159]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[172:175], v[216:219], v[24:27], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[188:191], v[220:223], v[24:27], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[220:223], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[216:219], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[212:215], v[28:31], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[208:211], v[28:31], v[144:147]
		s_setprio 1
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v8 offset:8192
		ds_read_b128 v[20:23], v8 offset:9216
		ds_read_b128 v[24:27], v8 offset:24576
		ds_read_b128 v[28:31], v8 offset:25600
		s_setprio 0
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[84:87], v[32:35], v[16:19], v[84:87]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[88:91], v[32:35], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[36:39], v[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[36:39], v[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[40:43], v[16:19], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[44:47], v[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[44:47], v[20:23], v[136:139]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[24:27], v[84:87]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[88:91], v[48:51], v[28:31], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[60:63], v[24:27], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[28:31], v[136:139]
		s_setprio 1
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[8:11], v7
		ds_read_b128 v[32:35], v7 offset:1024
		ds_read_b128 v[36:39], v7 offset:16384
		ds_read_b128 v[40:43], v7 offset:17408
		s_setprio 0
		v_mfma_f32_16x16x32_f16 v[148:151], v[64:67], v[16:19], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[68:71], v[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[16:19], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[204:207], v[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[204:207], v[20:23], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[148:151], v[208:211], v[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[208:211], v[28:31], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[212:215], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[212:215], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[180:183], v[216:219], v[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[196:199], v[220:223], v[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[220:223], v[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[184:187], v[216:219], v[28:31], v[184:187]
		s_setprio 1
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[16:19], v77
		ds_read_b128 v[20:23], v77 offset:1024
		ds_read_b128 v[24:27], v77 offset:2048
		ds_read_b128 v[28:31], v77 offset:3072
		ds_read_b128 v[44:47], v77 offset:16384
		ds_read_b128 v[48:51], v77 offset:17408
		ds_read_b128 v[52:55], v77 offset:18432
		ds_read_b128 v[56:59], v77 offset:19456
		s_setprio 0
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[12:15], v[16:19], v[8:11], v[12:15]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], v[8:11], v[92:95]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[108:111], v[24:27], v[8:11], v[108:111]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[28:31], v[8:11], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[28:31], v[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[24:27], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], v[32:35], v[80:83]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[12:15], v[44:47], v[36:39], v[12:15]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[92:95], v[48:51], v[36:39], v[92:95]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[108:111], v[52:55], v[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[56:59], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[56:59], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[112:115], v[52:55], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[96:99], v[48:51], v[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[80:83], v[44:47], v[40:43], v[80:83]
		s_setprio 1
		s_waitcnt vmcnt(2)
		s_barrier
		ds_read_b128 v[60:63], v77 offset:8192
		ds_read_b128 v[64:67], v77 offset:9216
		ds_read_b128 v[68:71], v77 offset:10240
		ds_read_b128 v[72:75], v77 offset:11264
		ds_read_b128 v[204:207], v77 offset:24576
		ds_read_b128 v[208:211], v77 offset:25600
		ds_read_b128 v[212:215], v77 offset:26624
		ds_read_b128 v[216:219], v77 offset:27648
		s_setprio 0
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[8:11], v[140:143]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[8:11], v[156:159]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[8:11], v[172:175]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[8:11], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[60:63], v[32:35], v[144:147]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[140:143], v[204:207], v[36:39], v[140:143]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[156:159], v[208:211], v[36:39], v[156:159]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[172:175], v[212:215], v[36:39], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[188:191], v[216:219], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[216:219], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[176:179], v[212:215], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[160:163], v[208:211], v[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[144:147], v[204:207], v[40:43], v[144:147]
		s_setprio 1
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v7 offset:8192
		ds_read_b128 v[32:35], v7 offset:9216
		ds_read_b128 v[36:39], v7 offset:24576
		ds_read_b128 v[40:43], v7 offset:25600
		s_setprio 0
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_lshl_add_u32 v1, v1, 7, v5
		v_lshl_add_u32 v0, v0, 19, v1
		v_lshl_add_u32 v0, v4, 14, v0
		v_cvt_pk_f16_f32 v4, v80, v81
		v_cvt_pk_f16_f32 v5, v82, v83
		v_cvt_pk_f16_f32 v6, v92, v93
		v_cvt_pk_f16_f32 v7, v94, v95
		v_cvt_pk_f16_f32 v12, v96, v97
		v_cvt_pk_f16_f32 v13, v98, v99
		v_cvt_pk_f16_f32 v14, v108, v109
		v_cvt_pk_f16_f32 v15, v110, v111
		v_cvt_pk_f16_f32 v76, v112, v113
		v_cvt_pk_f16_f32 v77, v114, v115
		v_cvt_pk_f16_f32 v78, v124, v125
		v_cvt_pk_f16_f32 v79, v126, v127
		v_cvt_pk_f16_f32 v80, v128, v129
		v_cvt_pk_f16_f32 v81, v130, v131
		v_cvt_pk_f16_f32 v82, v140, v141
		v_cvt_pk_f16_f32 v83, v142, v143
		v_cvt_pk_f16_f32 v92, v144, v145
		v_cvt_pk_f16_f32 v93, v146, v147
		v_cvt_pk_f16_f32 v94, v156, v157
		v_cvt_pk_f16_f32 v95, v158, v159
		v_cvt_pk_f16_f32 v96, v160, v161
		v_cvt_pk_f16_f32 v97, v162, v163
		v_cvt_pk_f16_f32 v98, v172, v173
		v_cvt_pk_f16_f32 v99, v174, v175
		v_cvt_pk_f16_f32 v108, v176, v177
		v_cvt_pk_f16_f32 v109, v178, v179
		v_cvt_pk_f16_f32 v110, v188, v189
		v_cvt_pk_f16_f32 v111, v190, v191
		v_cvt_pk_f16_f32 v112, v192, v193
		v_cvt_pk_f16_f32 v113, v194, v195
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], v[8:11], v[84:87]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], v[32:35], v[88:91]
		s_lshl_b32 s0, s10, 9
		s_add_i32 s1, s8, s0
		s_add_i32 s1, s1, s9
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], v[8:11], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[24:27], v[8:11], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[24:27], v[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[28:31], v[8:11], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[28:31], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[8:11], v[196:199]
		v_mfma_f32_16x16x32_f16 v[148:151], v[60:63], v[8:11], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[32:35], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[64:67], v[8:11], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[8:11], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[68:71], v[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[84:87], v[44:47], v[36:39], v[84:87]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[88:91], v[44:47], v[40:43], v[88:91]
		v_mfma_f32_16x16x32_f16 v[100:103], v[48:51], v[36:39], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[48:51], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[116:119], v[52:55], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[132:135], v[56:59], v[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[56:59], v[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[200:203], v[216:219], v[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], v[216:219], v[36:39], v[196:199]
		v_cvt_pk_f16_f32 v8, v84, v85
		v_cvt_pk_f16_f32 v9, v86, v87
		v_cvt_pk_f16_f32 v10, v88, v89
		v_cvt_pk_f16_f32 v11, v90, v91
		v_cvt_pk_f16_f32 v16, v100, v101
		v_cvt_pk_f16_f32 v17, v102, v103
		v_cvt_pk_f16_f32 v18, v104, v105
		v_cvt_pk_f16_f32 v19, v106, v107
		v_cvt_pk_f16_f32 v20, v116, v117
		v_cvt_pk_f16_f32 v21, v118, v119
		v_cvt_pk_f16_f32 v22, v120, v121
		v_cvt_pk_f16_f32 v23, v122, v123
		v_cvt_pk_f16_f32 v24, v132, v133
		v_cvt_pk_f16_f32 v25, v134, v135
		v_cvt_pk_f16_f32 v26, v136, v137
		v_cvt_pk_f16_f32 v27, v138, v139
		v_cvt_pk_f16_f32 v28, v196, v197
		v_cvt_pk_f16_f32 v29, v198, v199
		v_cvt_pk_f16_f32 v30, v200, v201
		v_cvt_pk_f16_f32 v31, v202, v203
		v_mfma_f32_16x16x32_f16 v[148:151], v[204:207], v[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[204:207], v[40:43], v[152:155]
		v_mfma_f32_16x16x32_f16 v[164:167], v[208:211], v[36:39], v[164:167]
		v_mfma_f32_16x16x32_f16 v[180:183], v[212:215], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[212:215], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[168:171], v[208:211], v[40:43], v[168:171]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s1 offen
		s_add_i32 s2, s8, 0x40000
		s_add_i32 s2, s2, s0
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		v_cvt_pk_f16_f32 v32, v152, v153
		v_cvt_pk_f16_f32 v33, v154, v155
		v_cvt_pk_f16_f32 v34, v164, v165
		v_cvt_pk_f16_f32 v35, v166, v167
		v_cvt_pk_f16_f32 v36, v168, v169
		v_cvt_pk_f16_f32 v37, v170, v171
		v_cvt_pk_f16_f32 v38, v180, v181
		v_cvt_pk_f16_f32 v39, v182, v183
		v_cvt_pk_f16_f32 v40, v184, v185
		v_cvt_pk_f16_f32 v41, v186, v187
		s_add_i32 s2, s2, s9
		buffer_store_dwordx2 v[4:5], v0, s[12:15], s2 offen
		s_add_i32 s3, s24, s0
		s_add_i32 s3, s3, s9
		buffer_store_dwordx2 v[8:9], v0, s[12:15], s3 offen
		s_add_i32 s4, s8, 0x240000
		s_add_i32 s0, s4, s0
		s_add_i32 s0, s0, s9
		buffer_store_dwordx2 v[10:11], v0, s[12:15], s0 offen
		buffer_store_dwordx2 v[6:7], v0, s[12:15], s1 offen offset:32
		buffer_store_dwordx2 v[12:13], v0, s[12:15], s2 offen offset:32
		buffer_store_dwordx2 v[16:17], v0, s[12:15], s3 offen offset:32
		buffer_store_dwordx2 v[18:19], v0, s[12:15], s0 offen offset:32
		buffer_store_dwordx2 v[14:15], v0, s[12:15], s1 offen offset:64
		buffer_store_dwordx2 v[76:77], v0, s[12:15], s2 offen offset:64
		buffer_store_dwordx2 v[20:21], v0, s[12:15], s3 offen offset:64
		buffer_store_dwordx2 v[22:23], v0, s[12:15], s0 offen offset:64
		buffer_store_dwordx2 v[78:79], v0, s[12:15], s1 offen offset:96
		buffer_store_dwordx2 v[80:81], v0, s[12:15], s2 offen offset:96
		buffer_store_dwordx2 v[24:25], v0, s[12:15], s3 offen offset:96
		buffer_store_dwordx2 v[26:27], v0, s[12:15], s0 offen offset:96
		buffer_store_dwordx2 v[82:83], v0, s[12:15], s1 offen offset:256
		buffer_store_dwordx2 v[92:93], v0, s[12:15], s2 offen offset:256
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:256
		buffer_store_dwordx2 v[32:33], v0, s[12:15], s0 offen offset:256
		buffer_store_dwordx2 v[94:95], v0, s[12:15], s1 offen offset:288
		buffer_store_dwordx2 v[96:97], v0, s[12:15], s2 offen offset:288
		buffer_store_dwordx2 v[34:35], v0, s[12:15], s3 offen offset:288
		buffer_store_dwordx2 v[36:37], v0, s[12:15], s0 offen offset:288
		buffer_store_dwordx2 v[98:99], v0, s[12:15], s1 offen offset:320
		buffer_store_dwordx2 v[108:109], v0, s[12:15], s2 offen offset:320
		buffer_store_dwordx2 v[38:39], v0, s[12:15], s3 offen offset:320
		buffer_store_dwordx2 v[40:41], v0, s[12:15], s0 offen offset:320
		buffer_store_dwordx2 v[110:111], v0, s[12:15], s1 offen offset:352
		buffer_store_dwordx2 v[112:113], v0, s[12:15], s2 offen offset:352
		buffer_store_dwordx2 v[28:29], v0, s[12:15], s3 offen offset:352
		buffer_store_dwordx2 v[30:31], v0, s[12:15], s0 offen offset:352
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 32
		.amdhsa_user_sgpr_count 9
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 7
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 236
		.amdhsa_next_free_sgpr 25
		.amdhsa_accum_offset 236
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 236
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 25
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 0
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 0
	.set .Lwmma_f16_matmul_tiled.uses_flat_scratch, 0
	.set .Lwmma_f16_matmul_tiled.has_dyn_sized_stack, 0
	.set .Lwmma_f16_matmul_tiled.has_recursion, 0
	.set .Lwmma_f16_matmul_tiled.has_indirect_call, 0
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     25
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     236
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
