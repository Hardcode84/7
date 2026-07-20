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
		s_mov_b32 s0, 0x8000000
		s_mov_b32 s15, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, s0
		s_mov_b32 s19, s15
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s0
		s_mov_b32 s23, s15
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		s_cmp_ge_u32 s0, 4
		s_cselect_b32 s1, 1, 0
		s_lshl_b32 s8, s10, 17
		s_lshr_b32 s11, s9, 3
		s_lshl_b32 s11, s11, 22
		s_add_i32 s8, s8, s11
		s_and_b32 s9, s9, 7
		s_lshl_b32 s9, s9, 24
		s_add_i32 s8, s8, s9
		s_add_u32 s12, s6, s8
		s_addc_u32 s13, s7, 0
		s_mov_b32 s14, 0x20000
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s6, s6, 6
		s_lshl_b32 s7, s6, 10
		s_mov_b32 m0, s7
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 14, v2
		v_lshl_add_u32 v2, s0, 18, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s6, s11, s9
		buffer_load_dwordx4 v2, s[16:19], s6 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s8, s11, 0x200000
		s_add_i32 s8, s8, s9
		buffer_load_dwordx4 v2, s[16:19], s8 offen lds
		v_lshrrev_b32_e32 v3, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s8, s11, 64
		s_add_i32 s8, s8, s9
		buffer_load_dwordx4 v2, s[16:19], s8 offen lds
		s_mov_b32 s8, 0x2000
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s24, s11, 0x200040
		s_add_i32 s24, s24, s9
		buffer_load_dwordx4 v2, s[16:19], s24 offen lds
		v_lshlrev_b32_e32 v8, 3, v1
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s10, s10, 22
		buffer_load_dwordx4 v2, s[20:23], s10 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s10, 0x200000
		buffer_load_dwordx4 v2, s[20:23], s4 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s10, 64
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s2 offen lds
		s_mov_b32 s2, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s10, 0x200040
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_add_u32_e32 v9, s10, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s11, 0x80
		s_add_i32 s3, s3, s9
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_add_u32_e32 v10, s6, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s11, 0x200080
		s_add_i32 s3, s3, s9
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_and_b32_e32 v3, 3, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s11, 0xc0
		s_add_i32 s3, s3, s9
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_lshrrev_b32_e32 v1, 4, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s11, 0x2000c0
		s_add_i32 s3, s3, s9
		buffer_load_dwordx4 v2, s[16:19], s3 offen lds
		v_lshrrev_b32_e32 v11, 8, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s10, 0x80
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_lshlrev_b32_e32 v11, 13, v11
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s10, 0x200080
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s10, 0xc0
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		v_lshlrev_b32_e32 v12, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s10, 0x2000c0
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v1, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v1, v11, v12, v0
		ds_read_b128 v[16:19], v1
		ds_read_b128 v[20:23], v1 offset:1024
		ds_read_b128 v[24:27], v1 offset:2048
		ds_read_b128 v[28:31], v1 offset:3072
		ds_read_b128 v[32:35], v1 offset:4096
		ds_read_b128 v[36:39], v1 offset:5120
		ds_read_b128 v[40:43], v1 offset:6144
		ds_read_b128 v[44:47], v1 offset:7168
		ds_read_b128 v[48:51], v1 offset:16384
		ds_read_b128 v[52:55], v1 offset:17408
		ds_read_b128 v[56:59], v1 offset:18432
		ds_read_b128 v[60:63], v1 offset:19456
		ds_read_b128 v[64:67], v1 offset:20480
		ds_read_b128 v[68:71], v1 offset:21504
		ds_read_b128 v[72:75], v1 offset:22528
		ds_read_b128 v[76:79], v1 offset:23552
		v_lshlrev_b32_e32 v1, 12, v3
		v_add3_u32 v2, v12, v1, v0
		ds_read_b128 v[80:83], v2 offset:32768
		ds_read_b128 v[84:87], v2 offset:33792
		ds_read_b128 v[88:91], v2 offset:34816
		ds_read_b128 v[92:95], v2 offset:35840
		ds_read_b128 v[96:99], v2 offset:49152
		ds_read_b128 v[100:103], v2 offset:50176
		ds_read_b128 v[104:107], v2 offset:51200
		ds_read_b128 v[108:111], v2 offset:52224
		v_add_u32_e32 v2, 0x100, v10
		v_add_u32_e32 v3, 0x200100, v10
		v_add_u32_e32 v13, 0x140, v10
		v_add_u32_e32 v14, 0x200140, v10
		v_add_u32_e32 v10, 0x100, v9
		v_add_u32_e32 v15, 0x200100, v9
		v_add_u32_e32 v112, 0x140, v9
		v_add_u32_e32 v113, 0x200140, v9
		s_mov_b32 vcc_lo, s1
		s_mov_b32 vcc_hi, 0
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
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_mov_b32 m0, s7
		s_add_i32 s1, s7, 0x10000
		s_add_i32 s2, s2, 1
		s_and_b32 s3, s2, 1
		s_lshl_b32 s3, s3, 16
		v_add_u32_e32 v9, s3, v11
		v_add3_u32 v9, v9, v12, v0
		v_add_u32_e32 v114, s3, v12
		v_add3_u32 v114, v114, v1, v0
		s_and_b32 s7, s1, 0x1ffff
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[84:87], v[116:119]
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[88:91], v[120:123]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[92:95], v[124:127]
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[92:95], v[140:143]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], v[80:83], v[128:131]
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[84:87], v[132:135]
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[88:91], v[136:139]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[88:91], v[152:155]
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], v[80:83], v[144:147]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[108:111], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[52:55], v[96:99], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[100:103], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[104:107], v[136:139]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[84:87], v[148:151]
		s_cbranch_vccnz .Lwmma_f16_matmul_tiled.dma_issue_delay_0
		s_nop 15
		s_nop 15
		s_nop 13
.Lwmma_f16_matmul_tiled.dma_issue_delay_0:
		buffer_load_dwordx4 v112, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[92:95], v[156:159]
		s_add_i32 m0, m0, 0x2000
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[28:31], v[80:83], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[88:91], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[88:91], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[32:35], v[80:83], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[84:87], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[92:95], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[92:95], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[36:39], v[80:83], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[84:87], v[196:199]
		buffer_load_dwordx4 v113, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[88:91], v[200:203]
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[88:91], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[40:43], v[80:83], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[84:87], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[92:95], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[92:95], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[44:47], v[80:83], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[84:87], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[88:91], v[232:235]
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[96:99], v[4:7]
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[100:103], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[104:107], v[120:123]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v9
		ds_read_b128 v[48:51], v9 offset:16384
		ds_read_b128 v[80:83], v114 offset:32768
		ds_read_b128 v[20:23], v9 offset:1024
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[108:111], v[140:143]
		ds_read_b128 v[52:55], v9 offset:17408
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[100:103], v[148:151]
		ds_read_b128 v[84:87], v114 offset:33792
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[104:107], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[108:111], v[156:159]
		ds_read_b128 v[24:27], v9 offset:2048
		ds_read_b128 v[56:59], v9 offset:18432
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[100:103], v[164:167]
		ds_read_b128 v[88:91], v114 offset:34816
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[108:111], v[172:175]
		ds_read_b128 v[60:63], v9 offset:19456
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[96:99], v[176:179]
		ds_read_b128 v[28:31], v9 offset:3072
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[104:107], v[184:187]
		ds_read_b128 v[92:95], v114 offset:35840
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[108:111], v[188:191]
		ds_read_b128 v[64:67], v9 offset:20480
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[96:99], v[192:195]
		ds_read_b128 v[32:35], v9 offset:4096
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[100:103], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[108:111], v[204:207]
		ds_read_b128 v[36:39], v9 offset:5120
		ds_read_b128 v[68:71], v9 offset:21504
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[96:99], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[100:103], v[212:215]
		ds_read_b128 v[40:43], v9 offset:6144
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[104:107], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[108:111], v[220:223]
		ds_read_b128 v[44:47], v9 offset:7168
		ds_read_b128 v[72:75], v9 offset:22528
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[96:99], v[224:227]
		ds_read_b128 v[96:99], v114 offset:49152
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[100:103], v[228:231]
		ds_read_b128 v[100:103], v114 offset:50176
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[104:107], v[232:235]
		ds_read_b128 v[104:107], v114 offset:51200
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[108:111], v[236:239]
		ds_read_b128 v[108:111], v114 offset:52224
		ds_read_b128 v[76:79], v9 offset:23552
		s_cmp_lt_i32 s2, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[84:87], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[88:91], v[120:123]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[92:95], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[92:95], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], v[80:83], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[84:87], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[88:91], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], v[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[84:87], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[92:95], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[28:31], v[80:83], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[84:87], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[88:91], v[168:171]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[88:91], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[32:35], v[80:83], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[84:87], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[92:95], v[188:191]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[92:95], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[36:39], v[80:83], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[84:87], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[88:91], v[200:203]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[88:91], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[40:43], v[80:83], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[84:87], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[92:95], v[220:223]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[92:95], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[44:47], v[80:83], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[84:87], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[88:91], v[232:235]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[96:99], v[4:7]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[100:103], v[116:119]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[104:107], v[120:123]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[108:111], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[108:111], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[52:55], v[96:99], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[100:103], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[104:107], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[104:107], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[100:103], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[108:111], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[104:107], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[96:99], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[108:111], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[100:103], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[104:107], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[96:99], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[100:103], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[108:111], v[220:223]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[108:111], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[96:99], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[100:103], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[104:107], v[232:235]
		v_add_u32_e32 v2, 0x10000, v11
		v_add3_u32 v2, v2, v12, v0
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
		v_add_u32_e32 v2, 0x10000, v12
		v_add3_u32 v0, v2, v1, v0
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
		v_lshl_add_u32 v0, s0, 14, v8
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[80:83], v[116:119]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[84:87], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[88:91], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], v[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], v[12:15], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], v[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], v[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], v[84:87], v[152:155]
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], v[12:15], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[80:83], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], v[88:91], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[28:31], v[88:91], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[28:31], v[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[28:31], v[80:83], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[28:31], v[84:87], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[84:87], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[32:35], v[12:15], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[80:83], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[88:91], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[88:91], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[36:39], v[12:15], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[80:83], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[84:87], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[84:87], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[40:43], v[12:15], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[80:83], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[88:91], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[88:91], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[44:47], v[12:15], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[80:83], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[84:87], v[232:235]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[92:95], v[4:7]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[96:99], v[116:119]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[100:103], v[120:123]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[124:127], v[48:51], v[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[52:55], v[104:107], v[140:143]
		v_mfma_f32_16x16x32_f16 v[128:131], v[52:55], v[92:95], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[96:99], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[100:103], v[136:139]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[100:103], v[152:155]
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_mfma_f32_16x16x32_f16 v[144:147], v[56:59], v[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], v[56:59], v[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[104:107], v[172:175]
		v_mfma_f32_16x16x32_f16 v[160:163], v[60:63], v[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[60:63], v[96:99], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[100:103], v[168:171]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[92:95], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[96:99], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[104:107], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[104:107], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[92:95], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[96:99], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[100:103], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[100:103], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[92:95], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[104:107], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[92:95], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[96:99], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[100:103], v[232:235]
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[12:15], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		s_mov_b32 s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:512
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:1024
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:1536
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:2048
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:2560
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:3072
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s8 offen offset:3584
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		s_mov_b32 s0, 0x3000
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s0 offen offset:3584
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
		.amdhsa_next_free_vgpr 240
		.amdhsa_next_free_sgpr 25
		.amdhsa_accum_offset 240
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 240
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 25
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
    .sgpr_count:     25
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     240
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
