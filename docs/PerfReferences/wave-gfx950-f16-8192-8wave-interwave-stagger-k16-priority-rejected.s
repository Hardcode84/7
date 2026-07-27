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
		s_mov_b32 s14, 0x20000
		v_readfirstlane_b32 s12, v0
		s_lshr_b32 s12, s12, 6
		s_lshl_b32 s24, s12, 10
		s_mov_b32 m0, s24
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 14, v2
		v_lshl_add_u32 v2, s0, 18, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s12, s11, s9
		buffer_load_dwordx4 v2, s[16:19], s12 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s13, s11, 0x200000
		s_add_i32 s13, s13, s9
		buffer_load_dwordx4 v2, s[16:19], s13 offen lds
		v_lshrrev_b32_e32 v3, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s13, s11, 64
		s_add_i32 s13, s13, s9
		buffer_load_dwordx4 v2, s[16:19], s13 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s11, 0x200040
		s_add_i32 s4, s4, s9
		buffer_load_dwordx4 v2, s[16:19], s4 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s2, s10, 22
		buffer_load_dwordx4 v2, s[20:23], s2 offen lds
		v_and_b32_e32 v3, 3, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s2, 0x200000
		buffer_load_dwordx4 v2, s[20:23], s3 offen lds
		s_mov_b32 s3, 0x2000
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s2, 64
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s4 offen lds
		v_lshlrev_b32_e32 v8, 3, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s2, 0x200040
		buffer_load_dwordx4 v2, s[20:23], s4 offen lds
		v_lshrrev_b32_e32 v1, 4, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s11, 0x80
		s_add_i32 s4, s4, s9
		buffer_load_dwordx4 v2, s[16:19], s4 offen lds
		v_lshlrev_b32_e32 v3, 12, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s11, 0x200080
		s_add_i32 s4, s4, s9
		buffer_load_dwordx4 v2, s[16:19], s4 offen lds
		s_mov_b32 s4, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s5, s11, 0xc0
		s_add_i32 s5, s5, s9
		buffer_load_dwordx4 v2, s[16:19], s5 offen lds
		v_add_u32_e32 v9, s2, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s5, s11, 0x2000c0
		s_add_i32 s5, s5, s9
		buffer_load_dwordx4 v2, s[16:19], s5 offen lds
		v_add_u32_e32 v10, s12, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s5, s2, 0x80
		buffer_load_dwordx4 v2, s[20:23], s5 offen lds
		s_mov_b32 s5, 0x100
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s9, s2, 0x200080
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 15
		s_nop 3
		buffer_load_dwordx4 v2, s[20:23], s9 offen lds
		s_add_u32 s12, s6, s8
		s_addc_u32 s13, s7, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s6, s2, 0xc0
		buffer_load_dwordx4 v2, s[20:23], s6 offen lds
		v_lshrrev_b32_e32 v11, 8, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s2, 0x2000c0
		buffer_load_dwordx4 v2, s[20:23], s2 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v2, 13, v11
		v_and_b32_e32 v11, 15, v0
		v_lshlrev_b32_e32 v12, 6, v11
		v_lshrrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v1, v1, v11, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v11, v2, v12, v1
		ds_read_b128 v[16:19], v11
		ds_read_b128 v[20:23], v11 offset:1024
		ds_read_b128 v[24:27], v11 offset:2048
		ds_read_b128 v[28:31], v11 offset:3072
		ds_read_b128 v[32:35], v11 offset:4096
		ds_read_b128 v[36:39], v11 offset:5120
		ds_read_b128 v[40:43], v11 offset:6144
		ds_read_b128 v[44:47], v11 offset:7168
		ds_read_b128 v[48:51], v11 offset:16384
		ds_read_b128 v[52:55], v11 offset:17408
		ds_read_b128 v[56:59], v11 offset:18432
		ds_read_b128 v[60:63], v11 offset:19456
		ds_read_b128 v[64:67], v11 offset:20480
		ds_read_b128 v[68:71], v11 offset:21504
		ds_read_b128 v[72:75], v11 offset:22528
		ds_read_b128 v[76:79], v11 offset:23552
		v_add3_u32 v11, v12, v3, v1
		ds_read_b128 v[80:83], v11 offset:32768
		ds_read_b128 v[84:87], v11 offset:33792
		ds_read_b128 v[88:91], v11 offset:34816
		ds_read_b128 v[92:95], v11 offset:35840
		ds_read_b128 v[96:99], v11 offset:49152
		ds_read_b128 v[100:103], v11 offset:50176
		ds_read_b128 v[104:107], v11 offset:51200
		ds_read_b128 v[108:111], v11 offset:52224
		v_cmp_ge_u32_e64 vcc, v0, s5
		s_and_saveexec_b64 s[26:27], vcc
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
		s_barrier
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[26:27]
		v_add_u32_e32 v11, 0x100, v10
		v_add_u32_e32 v13, 0x200100, v10
		v_add_u32_e32 v14, 0x140, v10
		v_add_u32_e32 v15, 0x200140, v10
		v_add_u32_e32 v10, 0x100, v9
		v_add_u32_e32 v112, 0x200100, v9
		v_add_u32_e32 v113, 0x140, v9
		v_add_u32_e32 v114, 0x200140, v9
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
		s_waitcnt vmcnt(0) lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[84:87], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[88:91], v[120:123]
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
		s_setprio 1
		s_add_i32 s4, s4, 1
		s_and_b32 s1, s4, 1
		s_lshl_b32 s1, s1, 16
		v_add_u32_e32 v9, s1, v2
		v_add3_u32 v9, v9, v12, v1
		ds_read_b128 v[16:19], v9
		v_add_u32_e32 v20, s1, v12
		v_add3_u32 v115, v20, v3, v1
		ds_read_b128 v[240:243], v115 offset:32768
		ds_read_b128 v[20:23], v9 offset:1024
		ds_read_b128 v[244:247], v115 offset:33792
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[176:179], v[32:35], v[80:83], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[84:87], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[88:91], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[92:95], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[92:95], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[36:39], v[80:83], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[84:87], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[88:91], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[40:43], v[88:91], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[40:43], v[80:83], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[40:43], v[84:87], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[40:43], v[92:95], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[44:47], v[92:95], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[44:47], v[80:83], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[44:47], v[84:87], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[44:47], v[88:91], v[232:235]
		s_setprio 1
		ds_read_b128 v[24:27], v9 offset:2048
		ds_read_b128 v[88:91], v115 offset:34816
		ds_read_b128 v[28:31], v9 offset:3072
		ds_read_b128 v[92:95], v115 offset:35840
		ds_read_b128 v[32:35], v9 offset:4096
		ds_read_b128 v[36:39], v9 offset:5120
		ds_read_b128 v[40:43], v9 offset:6144
		ds_read_b128 v[44:47], v9 offset:7168
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_setprio 0
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[4:7], v[48:51], v[96:99], v[4:7]
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[100:103], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[104:107], v[120:123]
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
		s_setprio 1
		ds_read_b128 v[48:51], v9 offset:16384
		ds_read_b128 v[248:251], v115 offset:49152
		ds_read_b128 v[52:55], v9 offset:17408
		ds_read_b128 v[252:255], v115 offset:50176
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v112, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[96:99], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[104:107], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[108:111], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[100:103], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[104:107], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[96:99], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[100:103], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[108:111], v[220:223]
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[108:111], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[96:99], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[100:103], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[104:107], v[232:235]
		s_setprio 1
		ds_read_b128 v[56:59], v9 offset:18432
		ds_read_b128 v[104:107], v115 offset:51200
		ds_read_b128 v[60:63], v9 offset:19456
		ds_read_b128 v[108:111], v115 offset:52224
		ds_read_b128 v[64:67], v9 offset:20480
		ds_read_b128 v[68:71], v9 offset:21504
		ds_read_b128 v[72:75], v9 offset:22528
		ds_read_b128 v[76:79], v9 offset:23552
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		s_cbranch_vccnz .Lwmma_f16_matmul_tiled.dma_issue_delay_0
		s_nop 15
		s_nop 15
		s_nop 13
.Lwmma_f16_matmul_tiled.dma_issue_delay_0:
		buffer_load_dwordx4 v113, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s1, s24, 0x10000
		buffer_load_dwordx4 v114, s[20:23], 0 offen lds
		s_setprio 0
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s24, s1, 0x1ffff
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s4, 0x7e
		s_waitcnt lgkmcnt(14)
		v_mov_b32_e32 v80, v240
		v_mov_b32_e32 v81, v241
		v_mov_b32_e32 v82, v242
		v_mov_b32_e32 v83, v243
		v_mov_b32_e32 v84, v244
		v_mov_b32_e32 v85, v245
		v_mov_b32_e32 v86, v246
		v_mov_b32_e32 v87, v247
		s_waitcnt lgkmcnt(10)
		v_mov_b32_e32 v96, v248
		v_mov_b32_e32 v97, v249
		v_mov_b32_e32 v98, v250
		v_mov_b32_e32 v99, v251
		s_waitcnt lgkmcnt(8)
		v_mov_b32_e32 v100, v252
		v_mov_b32_e32 v101, v253
		v_mov_b32_e32 v102, v254
		v_mov_b32_e32 v103, v255
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		v_cmp_lt_u32_e64 vcc, v0, s5
		s_and_saveexec_b64 s[26:27], vcc
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
		s_barrier
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[26:27]
		s_barrier
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[80:83], v[4:7]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[84:87], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], v[88:91], v[120:123]
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
		v_mfma_f32_16x16x32_f16 v[184:187], v[32:35], v[88:91], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[32:35], v[80:83], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[32:35], v[84:87], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[32:35], v[92:95], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[36:39], v[92:95], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[36:39], v[80:83], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[84:87], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[36:39], v[88:91], v[200:203]
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
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[120:123], v[48:51], v[104:107], v[120:123]
		s_waitcnt lgkmcnt(4)
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
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[104:107], v[184:187]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[96:99], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[64:67], v[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[108:111], v[188:191]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[100:103], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[68:71], v[104:107], v[200:203]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[216:219], v[72:75], v[104:107], v[216:219]
		v_mfma_f32_16x16x32_f16 v[208:211], v[72:75], v[96:99], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[100:103], v[212:215]
		v_mfma_f32_16x16x32_f16 v[220:223], v[72:75], v[108:111], v[220:223]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[236:239], v[76:79], v[108:111], v[236:239]
		v_mfma_f32_16x16x32_f16 v[224:227], v[76:79], v[96:99], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[76:79], v[100:103], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[76:79], v[104:107], v[232:235]
		v_add_u32_e32 v0, 0x10000, v2
		v_add3_u32 v0, v0, v12, v1
		ds_read_b128 v[16:19], v0
		ds_read_b128 v[20:23], v0 offset:1024
		ds_read_b128 v[24:27], v0 offset:2048
		ds_read_b128 v[28:31], v0 offset:3072
		ds_read_b128 v[32:35], v0 offset:4096
		ds_read_b128 v[36:39], v0 offset:5120
		ds_read_b128 v[40:43], v0 offset:6144
		ds_read_b128 v[44:47], v0 offset:7168
		ds_read_b128 v[48:51], v0 offset:16384
		ds_read_b128 v[52:55], v0 offset:17408
		ds_read_b128 v[56:59], v0 offset:18432
		ds_read_b128 v[60:63], v0 offset:19456
		ds_read_b128 v[64:67], v0 offset:20480
		ds_read_b128 v[68:71], v0 offset:21504
		ds_read_b128 v[72:75], v0 offset:22528
		ds_read_b128 v[76:79], v0 offset:23552
		v_add_u32_e32 v0, 0x10000, v12
		v_add3_u32 v0, v0, v3, v1
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
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:512
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:1024
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:1536
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:2048
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:2560
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:3072
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[12:15], s3 offen offset:3584
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 28
		.amdhsa_accum_offset 256
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 256
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 28
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
    .sgpr_count:     28
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
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
