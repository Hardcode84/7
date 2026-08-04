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
		s_cmp_ge_u32 s0, 4
		s_cselect_b32 s1, 1, 0
		v_readfirstlane_b32 s8, v0
		s_lshr_b32 s8, s8, 6
		s_lshl_b32 s11, s8, 10
		s_mov_b32 m0, s11
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 14, v2
		v_lshl_add_u32 v2, s0, 18, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_lshr_b32 s0, s9, 3
		s_lshl_b32 s8, s0, 22
		s_and_b32 s9, s9, 7
		s_lshl_b32 s12, s9, 24
		s_add_i32 s13, s8, s12
		buffer_load_dwordx4 v2, s[16:19], s13 offen lds
		v_add_u32_e32 v3, s13, v2
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s13, s8, 0x200000
		s_add_i32 s13, s13, s12
		buffer_load_dwordx4 v2, s[16:19], s13 offen lds
		v_lshrrev_b32_e32 v8, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s13, s8, 64
		s_add_i32 s13, s13, s12
		buffer_load_dwordx4 v2, s[16:19], s13 offen lds
		s_mov_b32 vcc_lo, s1
		s_mov_b32 vcc_hi, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s1, s8, 0x200040
		s_add_i32 s1, s1, s12
		buffer_load_dwordx4 v2, s[16:19], s1 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s1, s10, 22
		buffer_load_dwordx4 v2, s[20:23], s1 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s1, 0x200000
		buffer_load_dwordx4 v2, s[20:23], s2 offen lds
		v_and_b32_e32 v8, 3, v8
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s1, 64
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s2 offen lds
		s_mov_b32 s2, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s1, 0x200040
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_add_u32_e32 v9, s1, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s8, 0x80
		s_add_i32 s3, s3, s12
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_lshrrev_b32_e32 v10, 4, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s8, 0x200080
		s_add_i32 s3, s3, s12
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_lshrrev_b32_e32 v11, 8, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s8, 0xc0
		s_add_i32 s3, s3, s12
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s8, 0x2000c0
		s_add_i32 s3, s3, s12
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_lshlrev_b32_e32 v12, 13, v11
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s1, 0x80
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_lshlrev_b32_e32 v13, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s1, 0x200080
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_lshrrev_b32_e32 v0, 1, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s1, 0xc0
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_bitop3_b32 v0, v10, v0, 3 bitop3:0x78
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s1, 0x2000c0
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v2, v12, v13, v0
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 v[32:35], v2 offset:4096
		ds_read_b128 v[36:39], v2 offset:5120
		ds_read_b128 v[40:43], v2 offset:6144
		ds_read_b128 v[44:47], v2 offset:7168
		ds_read_b128 v[48:51], v2 offset:16384
		ds_read_b128 v[52:55], v2 offset:17408
		ds_read_b128 v[56:59], v2 offset:18432
		ds_read_b128 v[60:63], v2 offset:19456
		ds_read_b128 v[64:67], v2 offset:20480
		ds_read_b128 v[68:71], v2 offset:21504
		ds_read_b128 v[72:75], v2 offset:22528
		ds_read_b128 v[76:79], v2 offset:23552
		v_lshlrev_b32_e32 v2, 12, v8
		v_add3_u32 v14, v13, v2, v0
		ds_read_b128 v[80:83], v14 offset:32768
		ds_read_b128 v[84:87], v14 offset:33792
		ds_read_b128 v[88:91], v14 offset:34816
		ds_read_b128 v[92:95], v14 offset:35840
		ds_read_b128 v[96:99], v14 offset:49152
		ds_read_b128 v[100:103], v14 offset:50176
		ds_read_b128 v[104:107], v14 offset:51200
		ds_read_b128 v[108:111], v14 offset:52224
		v_add_u32_e32 v14, 0x100, v3
		v_add_u32_e32 v15, 0x200100, v3
		v_add_u32_e32 v112, 0x140, v3
		v_add_u32_e32 v113, 0x200140, v3
		v_add_u32_e32 v3, 0x100, v9
		v_add_u32_e32 v114, 0x200100, v9
		v_add_u32_e32 v115, 0x140, v9
		v_add_u32_e32 v116, 0x200140, v9
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
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		s_mov_b32 m0, s11
		s_add_i32 s3, s11, 0x10000
		s_add_i32 s2, s2, 1
		s_and_b32 s4, s2, 1
		s_lshl_b32 s4, s4, 16
		s_and_b32 s11, s3, 0x1ffff
		v_add_u32_e32 v9, s4, v12
		v_add3_u32 v9, v9, v13, v0
		v_add_u32_e32 v117, s4, v13
		v_add3_u32 v117, v117, v2, v0
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[84:87], v[120:123]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[88:91], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[16:19], v[92:95], v[128:131]
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], v[92:95], v[144:147]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[80:83], v[132:135]
		buffer_load_dwordx4 v112, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[88:91], v[140:143]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[88:91], v[156:159]
		buffer_load_dwordx4 v113, s[16:19], 0 offen lds
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[80:83], v[148:151]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[160:163], v[24:27], v[92:95], v[160:163]
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], v[28:31], v[92:95], v[176:179]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[80:83], v[164:167]
		buffer_load_dwordx4 v114, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[84:87], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[88:91], v[172:175]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[108:111], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[100:103], v[136:139]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[88:91], v[188:191]
		s_cbranch_vccnz .Lwmma_f16_matmul_tiled.dma_issue_delay_0
		s_nop 15
		s_nop 15
		s_nop 13
.Lwmma_f16_matmul_tiled.dma_issue_delay_0:
		buffer_load_dwordx4 v115, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[80:83], v[180:183]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[84:87], v[184:187]
		v_mfma_f32_16x16x32_f16 v[192:195], v[32:35], v[92:95], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[36:39], v[92:95], v[208:211]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[80:83], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[84:87], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[88:91], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[88:91], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[88:91], v[236:239]
		buffer_load_dwordx4 v116, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[80:83], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[80:83], v[228:231]
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[84:87], v[216:219]
		v_mfma_f32_16x16x32_f16 v[224:227], v[40:43], v[92:95], v[224:227]
		v_mfma_f32_16x16x32_f16 v[240:243], v[44:47], v[92:95], v[240:243]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[84:87], v[232:235]
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[96:99], v[4:7]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[100:103], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[104:107], v[124:127]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v9
		ds_read_b128 v[48:51], v9 offset:16384
		ds_read_b128 v[80:83], v117 offset:32768
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[104:107], v[140:143]
		ds_read_b128 v[20:23], v9 offset:1024
		v_mfma_f32_16x16x32_f16 v[144:147], v[52:55], v[108:111], v[144:147]
		ds_read_b128 v[52:55], v9 offset:17408
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[100:103], v[152:155]
		ds_read_b128 v[84:87], v117 offset:33792
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[108:111], v[160:163]
		ds_read_b128 v[24:27], v9 offset:2048
		ds_read_b128 v[56:59], v9 offset:18432
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[100:103], v[168:171]
		ds_read_b128 v[88:91], v117 offset:34816
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[104:107], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[108:111], v[176:179]
		ds_read_b128 v[60:63], v9 offset:19456
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[96:99], v[180:183]
		ds_read_b128 v[28:31], v9 offset:3072
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[104:107], v[188:191]
		ds_read_b128 v[92:95], v117 offset:35840
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[108:111], v[192:195]
		ds_read_b128 v[64:67], v9 offset:20480
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[96:99], v[196:199]
		ds_read_b128 v[32:35], v9 offset:4096
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[100:103], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[104:107], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[108:111], v[208:211]
		ds_read_b128 v[36:39], v9 offset:5120
		ds_read_b128 v[68:71], v9 offset:21504
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[100:103], v[216:219]
		ds_read_b128 v[40:43], v9 offset:6144
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[72:75], v[108:111], v[224:227]
		ds_read_b128 v[44:47], v9 offset:7168
		ds_read_b128 v[72:75], v9 offset:22528
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[96:99], v[228:231]
		ds_read_b128 v[96:99], v117 offset:49152
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[100:103], v[232:235]
		ds_read_b128 v[100:103], v117 offset:50176
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[104:107], v[236:239]
		ds_read_b128 v[104:107], v117 offset:51200
		v_mfma_f32_16x16x32_f16 v[240:243], v[76:79], v[108:111], v[240:243]
		ds_read_b128 v[108:111], v117 offset:52224
		ds_read_b128 v[76:79], v9 offset:23552
		s_cmp_lt_i32 s2, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[84:87], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[88:91], v[124:127]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[128:131], v[16:19], v[92:95], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], v[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[160:163], v[24:27], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[28:31], v[92:95], v[176:179]
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[80:83], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[84:87], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[88:91], v[172:175]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[88:91], v[188:191]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[80:83], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[84:87], v[184:187]
		v_mfma_f32_16x16x32_f16 v[192:195], v[32:35], v[92:95], v[192:195]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[208:211], v[36:39], v[92:95], v[208:211]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[80:83], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[84:87], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[88:91], v[204:207]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[88:91], v[220:223]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[88:91], v[236:239]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[80:83], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[80:83], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[84:87], v[216:219]
		v_mfma_f32_16x16x32_f16 v[224:227], v[40:43], v[92:95], v[224:227]
		v_mfma_f32_16x16x32_f16 v[240:243], v[44:47], v[92:95], v[240:243]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[84:87], v[232:235]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[96:99], v[4:7]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[100:103], v[120:123]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[104:107], v[124:127]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[108:111], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[52:55], v[108:111], v[144:147]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[100:103], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[104:107], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[108:111], v[176:179]
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[104:107], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[104:107], v[188:191]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[96:99], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[108:111], v[208:211]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[96:99], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[100:103], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[104:107], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[104:107], v[220:223]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[104:107], v[236:239]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[96:99], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[100:103], v[216:219]
		v_mfma_f32_16x16x32_f16 v[224:227], v[72:75], v[108:111], v[224:227]
		v_mfma_f32_16x16x32_f16 v[240:243], v[76:79], v[108:111], v[240:243]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[100:103], v[232:235]
		v_add_u32_e32 v3, 0x10000, v12
		v_add3_u32 v3, v3, v13, v0
		ds_read_b128 v[16:19], v3
		ds_read_b128 v[20:23], v3 offset:1024
		ds_read_b128 v[24:27], v3 offset:2048
		ds_read_b128 v[28:31], v3 offset:3072
		ds_read_b128 v[32:35], v3 offset:4096
		ds_read_b128 v[36:39], v3 offset:5120
		ds_read_b128 v[40:43], v3 offset:6144
		ds_read_b128 v[44:47], v3 offset:7168
		ds_read_b128 v[48:51], v3 offset:16384
		ds_read_b128 v[52:55], v3 offset:17408
		ds_read_b128 v[56:59], v3 offset:18432
		ds_read_b128 v[60:63], v3 offset:19456
		ds_read_b128 v[64:67], v3 offset:20480
		ds_read_b128 v[68:71], v3 offset:21504
		ds_read_b128 v[72:75], v3 offset:22528
		ds_read_b128 v[76:79], v3 offset:23552
		v_add_u32_e32 v3, 0x10000, v13
		v_add3_u32 v0, v3, v2, v0
		ds_read_b128 v[12:15], v0 offset:32768
		ds_read_b128 v[80:83], v0 offset:33792
		ds_read_b128 v[84:87], v0 offset:34816
		ds_read_b128 v[88:91], v0 offset:35840
		ds_read_b128 v[92:95], v0 offset:49152
		ds_read_b128 v[96:99], v0 offset:50176
		ds_read_b128 v[100:103], v0 offset:51200
		ds_read_b128 v[104:107], v0 offset:52224
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[12:15], v[4:7]
		v_lshlrev_b32_e32 v0, 3, v10
		v_lshl_add_u32 v0, v11, 8, v0
		v_lshl_add_u32 v0, v8, 20, v0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[80:83], v[120:123]
		v_and_b32_e32 v1, 15, v1
		v_lshl_add_u32 v0, v1, 14, v0
		s_lshl_b32 s0, s0, 9
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[84:87], v[124:127]
		s_add_i32 s2, s1, s0
		s_lshl_b32 s3, s9, 11
		s_add_i32 s2, s2, s3
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[128:131], v[16:19], v[88:91], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], v[88:91], v[144:147]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[80:83], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[84:87], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[84:87], v[156:159]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[80:83], v[152:155]
		v_mfma_f32_16x16x32_f16 v[160:163], v[24:27], v[88:91], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[28:31], v[88:91], v[176:179]
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[80:83], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[84:87], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[84:87], v[188:191]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[80:83], v[184:187]
		v_mfma_f32_16x16x32_f16 v[192:195], v[32:35], v[88:91], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[36:39], v[88:91], v[208:211]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[80:83], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[84:87], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[84:87], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[84:87], v[236:239]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[12:15], v[228:231]
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[80:83], v[216:219]
		v_mfma_f32_16x16x32_f16 v[224:227], v[40:43], v[88:91], v[224:227]
		v_mfma_f32_16x16x32_f16 v[240:243], v[44:47], v[88:91], v[240:243]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[80:83], v[232:235]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[92:95], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[96:99], v[120:123]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[100:103], v[124:127]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[104:107], v[128:131]
		v_mfma_f32_16x16x32_f16 v[144:147], v[52:55], v[104:107], v[144:147]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[92:95], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[96:99], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[100:103], v[140:143]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[100:103], v[156:159]
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		v_cvt_pk_f16_f32 v6, v124, v125
		v_cvt_pk_f16_f32 v7, v126, v127
		v_cvt_pk_f16_f32 v8, v128, v129
		v_cvt_pk_f16_f32 v9, v130, v131
		v_cvt_pk_f16_f32 v10, v132, v133
		v_cvt_pk_f16_f32 v11, v134, v135
		v_cvt_pk_f16_f32 v12, v136, v137
		v_cvt_pk_f16_f32 v13, v138, v139
		v_cvt_pk_f16_f32 v14, v140, v141
		v_cvt_pk_f16_f32 v15, v142, v143
		v_cvt_pk_f16_f32 v16, v144, v145
		v_cvt_pk_f16_f32 v17, v146, v147
		v_cvt_pk_f16_f32 v18, v156, v157
		v_cvt_pk_f16_f32 v19, v158, v159
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[92:95], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[160:163], v[56:59], v[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[176:179], v[60:63], v[104:107], v[176:179]
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[92:95], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[96:99], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[100:103], v[172:175]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[100:103], v[188:191]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[92:95], v[180:183]
		v_cvt_pk_f16_f32 v20, v148, v149
		v_cvt_pk_f16_f32 v21, v150, v151
		v_cvt_pk_f16_f32 v22, v152, v153
		v_cvt_pk_f16_f32 v23, v154, v155
		v_cvt_pk_f16_f32 v24, v160, v161
		v_cvt_pk_f16_f32 v25, v162, v163
		v_cvt_pk_f16_f32 v26, v164, v165
		v_cvt_pk_f16_f32 v27, v166, v167
		v_cvt_pk_f16_f32 v28, v168, v169
		v_cvt_pk_f16_f32 v29, v170, v171
		v_cvt_pk_f16_f32 v30, v172, v173
		v_cvt_pk_f16_f32 v31, v174, v175
		v_cvt_pk_f16_f32 v32, v176, v177
		v_cvt_pk_f16_f32 v33, v178, v179
		v_cvt_pk_f16_f32 v34, v180, v181
		v_cvt_pk_f16_f32 v35, v182, v183
		v_cvt_pk_f16_f32 v36, v188, v189
		v_cvt_pk_f16_f32 v37, v190, v191
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[96:99], v[184:187]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[104:107], v[192:195]
		v_mfma_f32_16x16x32_f16 v[208:211], v[68:71], v[104:107], v[208:211]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[92:95], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[96:99], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[100:103], v[204:207]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[100:103], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[100:103], v[236:239]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[92:95], v[212:215]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[92:95], v[228:231]
		v_cvt_pk_f16_f32 v38, v184, v185
		v_cvt_pk_f16_f32 v39, v186, v187
		v_cvt_pk_f16_f32 v40, v192, v193
		v_cvt_pk_f16_f32 v41, v194, v195
		v_cvt_pk_f16_f32 v42, v196, v197
		v_cvt_pk_f16_f32 v43, v198, v199
		v_cvt_pk_f16_f32 v44, v200, v201
		v_cvt_pk_f16_f32 v45, v202, v203
		v_cvt_pk_f16_f32 v46, v204, v205
		v_cvt_pk_f16_f32 v47, v206, v207
		v_cvt_pk_f16_f32 v48, v208, v209
		v_cvt_pk_f16_f32 v49, v210, v211
		v_cvt_pk_f16_f32 v50, v212, v213
		v_cvt_pk_f16_f32 v51, v214, v215
		v_cvt_pk_f16_f32 v52, v220, v221
		v_cvt_pk_f16_f32 v53, v222, v223
		v_cvt_pk_f16_f32 v54, v228, v229
		v_cvt_pk_f16_f32 v55, v230, v231
		v_cvt_pk_f16_f32 v56, v236, v237
		v_cvt_pk_f16_f32 v57, v238, v239
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[96:99], v[216:219]
		v_mfma_f32_16x16x32_f16 v[224:227], v[72:75], v[104:107], v[224:227]
		v_mfma_f32_16x16x32_f16 v[240:243], v[76:79], v[104:107], v[240:243]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[96:99], v[232:235]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s2 offen
		s_add_i32 s4, s1, 0x40000
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s3
		buffer_store_dwordx2 v[4:5], v0, s[12:15], s4 offen
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		v_cvt_pk_f16_f32 v4, v224, v225
		v_cvt_pk_f16_f32 v5, v226, v227
		v_cvt_pk_f16_f32 v58, v232, v233
		v_cvt_pk_f16_f32 v59, v234, v235
		v_cvt_pk_f16_f32 v60, v240, v241
		v_cvt_pk_f16_f32 v61, v242, v243
		s_add_i32 s5, s1, 0x80000
		s_add_i32 s5, s5, s0
		s_add_i32 s5, s5, s3
		buffer_store_dwordx2 v[6:7], v0, s[12:15], s5 offen
		s_add_i32 s1, s1, 0xc0000
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s3
		buffer_store_dwordx2 v[8:9], v0, s[12:15], s0 offen
		buffer_store_dwordx2 v[10:11], v0, s[12:15], s2 offen offset:32
		buffer_store_dwordx2 v[12:13], v0, s[12:15], s4 offen offset:32
		buffer_store_dwordx2 v[14:15], v0, s[12:15], s5 offen offset:32
		buffer_store_dwordx2 v[16:17], v0, s[12:15], s0 offen offset:32
		buffer_store_dwordx2 v[20:21], v0, s[12:15], s2 offen offset:64
		buffer_store_dwordx2 v[22:23], v0, s[12:15], s4 offen offset:64
		buffer_store_dwordx2 v[18:19], v0, s[12:15], s5 offen offset:64
		buffer_store_dwordx2 v[24:25], v0, s[12:15], s0 offen offset:64
		buffer_store_dwordx2 v[26:27], v0, s[12:15], s2 offen offset:96
		buffer_store_dwordx2 v[28:29], v0, s[12:15], s4 offen offset:96
		buffer_store_dwordx2 v[30:31], v0, s[12:15], s5 offen offset:96
		buffer_store_dwordx2 v[32:33], v0, s[12:15], s0 offen offset:96
		buffer_store_dwordx2 v[34:35], v0, s[12:15], s2 offen offset:128
		buffer_store_dwordx2 v[38:39], v0, s[12:15], s4 offen offset:128
		buffer_store_dwordx2 v[36:37], v0, s[12:15], s5 offen offset:128
		buffer_store_dwordx2 v[40:41], v0, s[12:15], s0 offen offset:128
		buffer_store_dwordx2 v[42:43], v0, s[12:15], s2 offen offset:160
		buffer_store_dwordx2 v[44:45], v0, s[12:15], s4 offen offset:160
		buffer_store_dwordx2 v[46:47], v0, s[12:15], s5 offen offset:160
		buffer_store_dwordx2 v[48:49], v0, s[12:15], s0 offen offset:160
		buffer_store_dwordx2 v[50:51], v0, s[12:15], s2 offen offset:192
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s4 offen offset:192
		buffer_store_dwordx2 v[52:53], v0, s[12:15], s5 offen offset:192
		buffer_store_dwordx2 v[4:5], v0, s[12:15], s0 offen offset:192
		buffer_store_dwordx2 v[54:55], v0, s[12:15], s2 offen offset:224
		buffer_store_dwordx2 v[58:59], v0, s[12:15], s4 offen offset:224
		buffer_store_dwordx2 v[56:57], v0, s[12:15], s5 offen offset:224
		buffer_store_dwordx2 v[60:61], v0, s[12:15], s0 offen offset:224
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
		.amdhsa_next_free_vgpr 244
		.amdhsa_next_free_sgpr 24
		.amdhsa_accum_offset 244
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 244
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 24
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 0
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 1
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
    .sgpr_count:     24
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     244
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
