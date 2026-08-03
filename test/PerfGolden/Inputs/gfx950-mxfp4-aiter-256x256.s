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
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dword s12, s[0:1], 0x28
		s_waitcnt lgkmcnt(0)
		s_branch .Lwmma_f16_matmul_tiled.kernarg_preload_entry
	.p2align	8
.Lwmma_f16_matmul_tiled.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_mov_b32 s18, 0x400000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s2, 0x1000000
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s3, s19
		s_mov_b32 s22, 0x40000
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s23, s19
		s_mov_b32 s26, 0x100000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s27, s19
		s_lshl_b32 s4, s13, 19
		s_lshr_b32 s5, s14, 3
		s_lshl_b32 s8, s5, 17
		s_add_i32 s4, s4, s8
		s_and_b32 s8, s14, 7
		s_lshl_b32 s9, s8, 22
		s_add_i32 s4, s4, s9
		v_readfirstlane_b32 s9, v0
		s_lshl_b32 s10, s8, 19
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 15, v1
		v_add_u32_e32 v3, s10, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 11, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		s_add_i32 s11, s10, 0x20000
		v_add_u32_e32 v7, s11, v2
		s_add_i32 s11, s10, 0x40000
		v_add3_u32 v8, v2, v5, v6
		s_add_i32 s12, s10, 0x60000
		s_add_i32 s14, s10, 0x20040
		v_add_u32_e32 v9, v2, v5
		s_add_i32 s15, s10, 0x40040
		s_add_i32 s28, s10, 0x60040
		s_lshr_b32 s9, s9, 6
		s_lshl_b32 s29, s9, 10
		s_mov_b32 m0, s29
		v_add3_u32 v3, v3, v5, v6
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		v_add3_u32 v5, v7, v5, v6
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v7, s11, v8
		v_add_u32_e32 v10, s12, v8
		v_add3_u32 v8, v8, s10, 64
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v11, v6, v9, s14
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, v6, v9, s15
		v_add3_u32 v6, v6, v9, s28
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s10, 0x5000
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_mov_b32 s11, 0x4000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s12, 0x80
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_mov_b32 s14, 0x1000
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v9, 2, v4
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v13, 4, v4
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v14, 4, v4
		v_and_b32_e32 v0, 15, v0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v15, 6, v0
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v14, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_lshl_add_u32 v14, s9, 13, v9
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_add_u32 s32, s6, s4
		s_addc_u32 s33, s7, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s34, 0x20000
		buffer_load_dwordx4 v3, s[16:19], s12 offen lds
		s_mov_b32 s4, 0x6000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s6, 0x3000
		buffer_load_dwordx4 v5, s[16:19], s12 offen lds
		s_mov_b32 s7, 0x2000
		s_add_i32 m0, m0, 0x1000
		v_lshl_add_u32 v2, v4, 3, v2
		buffer_load_dwordx4 v7, s[16:19], s12 offen lds
		s_mov_b32 s9, 0
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s15, s5, 15
		s_lshl_b32 s28, s13, 17
		buffer_load_dwordx4 v10, s[16:19], s12 offen lds
		v_lshlrev_b32_e32 v1, 17, v1
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s8, s8, 15
		v_add_u32_e32 v4, s8, v9
		v_add_u32_e32 v20, 0x1000, v4
		buffer_load_dwordx4 v8, s[16:19], s12 offen lds
		v_add_u32_e32 v21, 0x2000, v4
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v22, 0x3000, v4
		v_add_u32_e32 v23, 0x4000, v4
		v_add_u32_e32 v24, 0x5000, v4
		buffer_load_dwordx4 v11, s[16:19], s12 offen lds
		v_add_u32_e32 v25, 0x6000, v4
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s5, s5, 19
		v_add_u32_e32 v26, 0x7000, v4
		buffer_load_dwordx4 v12, s[16:19], s12 offen lds
		v_add_u32_e32 v27, v15, v0
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s13, s13, 21
		s_add_i32 s30, s13, s5
		v_add3_u32 v28, s30, v1, v13
		buffer_load_dwordx4 v6, s[16:19], s12 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 a[0:3], v27
		ds_read_b128 a[4:7], v27 offset:1024
		ds_read_b128 a[8:11], v27 offset:2048
		ds_read_b128 a[12:15], v27 offset:3072
		ds_read_b128 a[16:19], v27 offset:4096
		ds_read_b128 a[20:23], v27 offset:5120
		ds_read_b128 a[24:27], v27 offset:6144
		ds_read_b128 a[28:31], v27 offset:7168
		ds_read_b128 a[32:35], v27 offset:8192
		ds_read_b128 a[36:39], v27 offset:9216
		ds_read_b128 a[40:43], v27 offset:10240
		ds_read_b128 a[44:47], v27 offset:11264
		ds_read_b128 a[48:51], v27 offset:12288
		ds_read_b128 a[52:55], v27 offset:13312
		ds_read_b128 a[56:59], v27 offset:14336
		ds_read_b128 a[60:63], v27 offset:15360
		ds_read_b128 a[64:67], v27 offset:16384
		ds_read_b128 a[68:71], v27 offset:17408
		ds_read_b128 a[72:75], v27 offset:18432
		ds_read_b128 a[76:79], v27 offset:19456
		ds_read_b128 a[80:83], v27 offset:20480
		ds_read_b128 a[84:87], v27 offset:21504
		ds_read_b128 a[88:91], v27 offset:22528
		ds_read_b128 a[92:95], v27 offset:23552
		ds_read_b128 a[96:99], v27 offset:24576
		ds_read_b128 a[100:103], v27 offset:25600
		ds_read_b128 a[104:107], v27 offset:26624
		ds_read_b128 a[108:111], v27 offset:27648
		ds_read_b128 a[112:115], v27 offset:28672
		ds_read_b128 a[116:119], v27 offset:29696
		ds_read_b128 a[120:123], v27 offset:30720
		ds_read_b128 a[124:127], v27 offset:31744
		s_add_i32 s12, s13, 0x8000
		s_add_i32 s12, s12, s5
		v_add3_u32 v29, s12, v1, v13
		s_add_i32 s12, s13, 0x10000
		s_add_i32 s12, s12, s5
		v_add3_u32 v30, s12, v1, v13
		s_add_i32 s12, s13, 0x18000
		s_add_i32 s12, s12, s5
		v_add3_u32 v31, s12, v1, v13
		s_add_i32 s12, s13, 0x400
		s_add_i32 s12, s12, s5
		v_add3_u32 v32, s12, v1, v13
		s_add_i32 s12, s13, 0x8400
		s_add_i32 s12, s12, s5
		v_add3_u32 v33, s12, v1, v13
		s_add_i32 s12, s13, 0x10400
		s_add_i32 s12, s12, s5
		v_add3_u32 v34, s12, v1, v13
		s_add_i32 s12, s13, 0x18400
		s_add_i32 s12, s12, s5
		v_add3_u32 v35, s12, v1, v13
		buffer_load_dwordx4 v[36:39], v28, s[0:3], 0 offen
		buffer_load_dwordx4 v[40:43], v29, s[0:3], 0 offen
		buffer_load_dwordx4 v[44:47], v30, s[0:3], 0 offen
		buffer_load_dwordx4 v[48:51], v31, s[0:3], 0 offen
		buffer_load_dwordx4 v[28:31], v32, s[0:3], 0 offen
		buffer_load_dwordx4 v[52:55], v33, s[0:3], 0 offen
		buffer_load_dwordx4 v[56:59], v34, s[0:3], 0 offen
		buffer_load_dwordx4 v[60:63], v35, s[0:3], 0 offen
		s_add_i32 s12, s28, s15
		v_add_u32_e32 v32, s12, v14
		v_add_u32_e32 v33, 0x1000, v32
		s_add_i32 s30, s13, 0x800
		s_add_i32 s30, s30, s5
		s_add_i32 s31, s13, 0x8800
		s_add_i32 s31, s31, s5
		s_add_i32 s35, s13, 0x10800
		s_add_i32 s35, s35, s5
		s_add_i32 s36, s13, 0x18800
		s_add_i32 s36, s36, s5
		s_add_i32 s37, s13, 0xc00
		s_add_i32 s37, s37, s5
		s_add_i32 s38, s13, 0x8c00
		s_add_i32 s38, s38, s5
		s_add_i32 s39, s13, 0x10c00
		s_add_i32 s39, s39, s5
		s_add_i32 s40, s13, 0x18c00
		s_add_i32 s40, s40, s5
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
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
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_mov_b32 m0, s29
		s_lshl_b32 s41, s9, 7
		s_add_i32 s41, s41, 0x100
		s_lshl_b32 s42, s9, 8
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v3, s[16:19], s41 offen lds
		s_lshl_b32 s43, s9, 11
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s9, s9, 1
		s_and_b32 s44, s9, 1
		s_lshl_b32 s44, s44, 15
		buffer_load_dwordx4 v5, s[16:19], s41 offen lds
		buffer_load_dword v34, v4, s[20:23], s42 offen
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s29, 0x8000
		s_add_i32 s45, s30, s43
		s_add_i32 s46, s31, s43
		s_add_i32 s47, s35, s43
		v_add3_u32 v35, s47, v1, v13
		s_add_i32 s47, s36, s43
		v_add3_u32 v236, s47, v1, v13
		s_add_i32 s47, s37, s43
		v_add3_u32 v237, s47, v1, v13
		s_add_i32 s47, s38, s43
		v_add3_u32 v238, s47, v1, v13
		s_add_i32 s47, s39, s43
		v_add3_u32 v239, s47, v1, v13
		s_add_i32 s43, s40, s43
		buffer_load_dwordx4 v7, s[16:19], s41 offen lds
		buffer_load_dword v240, v20, s[20:23], s42 offen
		v_add3_u32 v241, s43, v1, v13
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s29, s29, 0xffff
		buffer_load_dwordx4 v10, s[16:19], s41 offen lds
		buffer_load_dword v242, v21, s[20:23], s42 offen
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v243, s44, v15, v0
		buffer_load_dwordx4 v8, s[16:19], s41 offen lds
		buffer_load_dword v244, v22, s[20:23], s42 offen
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v245, s45, v1, v13
		buffer_load_dwordx4 v11, s[16:19], s41 offen lds
		buffer_load_dword v246, v23, s[20:23], s42 offen
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v247, s46, v1, v13
		buffer_load_dwordx4 v12, s[16:19], s41 offen lds
		buffer_load_dword v248, v24, s[20:23], s42 offen
		s_add_i32 m0, m0, 0x1000
		s_cmp_lt_i32 s9, 14
		buffer_load_dwordx4 v6, s[16:19], s41 offen lds
		buffer_load_dword v249, v25, s[20:23], s42 offen
		buffer_load_dword v250, v26, s[20:23], s42 offen
		buffer_load_dword v251, v32, s[24:27], s42 offen
		buffer_load_dword v252, v33, s[24:27], s42 offen
		s_waitcnt vmcnt(26)
		s_barrier
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[0:3], v[36:39], v[16:19], v34, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[0:3], v[40:43], v[64:67], v34, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[4:7], v[40:43], v[80:83], v34, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[4:7], v[36:39], v[76:79], v34, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[4:7], v[44:47], v[84:87], v34, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[0:3], v[44:47], v[68:71], v34, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[0:3], v[48:51], v[72:75], v34, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[4:7], v[48:51], v[88:91], v34, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[8:11], v[48:51], v[104:107], v240, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], v[44:47], v[100:103], v240, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], v[44:47], v[116:119], v240, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], v[48:51], v[120:123], v240, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], v[36:39], v[108:111], v240, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], v[36:39], v[92:95], v240, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], v[40:43], v[96:99], v240, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], v[40:43], v[112:115], v240, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[16:19], v[40:43], v[128:131], v242, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[16:19], v[36:39], v[124:127], v242, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[20:23], v[36:39], v[140:143], v242, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[20:23], v[40:43], v[144:147], v242, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[20:23], v[44:47], v[148:151], v242, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], v[44:47], v[132:135], v242, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], v[48:51], v[136:139], v242, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[20:23], v[48:51], v[152:155], v242, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[24:27], v[48:51], v[168:171], v244, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[24:27], v[44:47], v[164:167], v244, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[28:31], v[44:47], v[180:183], v244, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[28:31], v[48:51], v[184:187], v244, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[28:31], v[36:39], v[172:175], v244, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[24:27], v[36:39], v[156:159], v244, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[24:27], v[40:43], v[160:163], v244, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[28:31], v[40:43], v[176:179], v244, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[32:35], v[40:43], v[192:195], v246, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[32:35], v[36:39], v[188:191], v246, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[36:39], v[36:39], v[204:207], v246, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[36:39], v[40:43], v[208:211], v246, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[36:39], v[44:47], v[212:215], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[32:35], v[44:47], v[196:199], v246, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[32:35], v[48:51], v[200:203], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[36:39], v[48:51], v[216:219], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[40:43], v[48:51], v[232:235], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[40:43], v[44:47], v[228:231], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[44:47], v[44:47], a[136:139], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], v[48:51], a[140:143], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[44:47], v[36:39], a[128:131], v248, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[40:43], v[36:39], v[220:223], v248, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[40:43], v[40:43], v[224:227], v248, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], v[40:43], a[132:135], v248, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], v[40:43], a[148:151], v249, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], v[36:39], a[144:147], v249, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], v[36:39], a[160:163], v249, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], v[40:43], a[164:167], v249, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], v[44:47], a[168:171], v249, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[48:51], v[44:47], a[152:155], v249, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], v[48:51], a[156:159], v249, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[52:55], v[48:51], a[172:175], v249, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[56:59], v[48:51], a[188:191], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[56:59], v[44:47], a[184:187], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[60:63], v[44:47], a[200:203], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[60:63], v[48:51], a[204:207], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[60:63], v[36:39], a[192:195], v250, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], v[36:39], a[176:179], v250, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[36:39], v245, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[56:59], v[40:43], a[180:183], v250, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[60:63], v[40:43], a[196:199], v250, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[40:43], v247, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[120:123], v[28:31], a[176:179], v250, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[44:47], v35, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[120:123], v[52:55], a[180:183], v250, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[48:51], v236, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[124:127], v[52:55], a[196:199], v250, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[124:127], v[28:31], a[192:195], v250, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[64:67], v[28:31], v[16:19], v34, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[64:67], v[52:55], v[64:67], v34, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], v[52:55], v[80:83], v34, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], v[28:31], v[76:79], v34, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], v[56:59], v[84:87], v34, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[64:67], v[56:59], v[68:71], v34, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], v[60:63], v[72:75], v34, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], v[60:63], v[88:91], v34, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], v[60:63], v[104:107], v240, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], v[56:59], v[100:103], v240, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], v[56:59], v[116:119], v240, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], v[60:63], v[120:123], v240, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], v[28:31], v[108:111], v240, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], v[28:31], v[92:95], v240, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[72:75], v[52:55], v[96:99], v240, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], v[52:55], v[112:115], v240, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], v[52:55], v[128:131], v242, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], v[28:31], v[124:127], v242, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], v[28:31], v[140:143], v242, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], v[52:55], v[144:147], v242, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], v[56:59], v[148:151], v242, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[80:83], v[56:59], v[132:135], v242, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], v[60:63], v[136:139], v242, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], v[60:63], v[152:155], v242, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[88:91], v[60:63], v[168:171], v244, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], v[56:59], v[164:167], v244, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], v[56:59], v[180:183], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], v[60:63], v[184:187], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], v[28:31], v[172:175], v244, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], v[28:31], v[156:159], v244, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], v[52:55], v[160:163], v244, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], v[52:55], v[176:179], v244, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], v[52:55], v[192:195], v246, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[96:99], v[28:31], v[188:191], v246, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[100:103], v[28:31], v[204:207], v246, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[100:103], v[52:55], v[208:211], v246, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[100:103], v[56:59], v[212:215], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], v[56:59], v[196:199], v246, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], v[60:63], v[200:203], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[100:103], v[60:63], v[216:219], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[104:107], v[60:63], v[232:235], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[104:107], v[56:59], v[228:231], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[108:111], v[56:59], a[136:139], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[108:111], v[60:63], a[140:143], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[108:111], v[28:31], a[128:131], v248, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[104:107], v[28:31], v[220:223], v248, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[104:107], v[52:55], v[224:227], v248, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[108:111], v[52:55], a[132:135], v248, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[112:115], v[52:55], a[148:151], v249, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[112:115], v[28:31], a[144:147], v249, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[116:119], v[28:31], a[160:163], v249, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[28:31], v237, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[116:119], v[52:55], a[164:167], v249, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[52:55], v238, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[116:119], v[56:59], a[168:171], v249, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[112:115], v[56:59], a[152:155], v249, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[112:115], v[60:63], a[156:159], v249, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[116:119], v[60:63], a[172:175], v249, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[120:123], v[60:63], a[188:191], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[120:123], v[56:59], a[184:187], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[124:127], v[56:59], a[200:203], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[56:59], v239, s[0:3], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[124:127], v[60:63], a[204:207], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[60:63], v241, s[0:3], 0 offen
		ds_read_b128 a[0:3], v243
		ds_read_b128 a[4:7], v243 offset:1024
		ds_read_b128 a[8:11], v243 offset:2048
		ds_read_b128 a[12:15], v243 offset:3072
		ds_read_b128 a[16:19], v243 offset:4096
		ds_read_b128 a[20:23], v243 offset:5120
		ds_read_b128 a[24:27], v243 offset:6144
		ds_read_b128 a[28:31], v243 offset:7168
		ds_read_b128 a[32:35], v243 offset:8192
		ds_read_b128 a[36:39], v243 offset:9216
		ds_read_b128 a[40:43], v243 offset:10240
		ds_read_b128 a[44:47], v243 offset:11264
		ds_read_b128 a[48:51], v243 offset:12288
		ds_read_b128 a[52:55], v243 offset:13312
		ds_read_b128 a[56:59], v243 offset:14336
		ds_read_b128 a[60:63], v243 offset:15360
		ds_read_b128 a[64:67], v243 offset:16384
		ds_read_b128 a[68:71], v243 offset:17408
		ds_read_b128 a[72:75], v243 offset:18432
		ds_read_b128 a[76:79], v243 offset:19456
		ds_read_b128 a[80:83], v243 offset:20480
		ds_read_b128 a[84:87], v243 offset:21504
		ds_read_b128 a[88:91], v243 offset:22528
		ds_read_b128 a[92:95], v243 offset:23552
		ds_read_b128 a[96:99], v243 offset:24576
		ds_read_b128 a[100:103], v243 offset:25600
		ds_read_b128 a[104:107], v243 offset:26624
		ds_read_b128 a[108:111], v243 offset:27648
		ds_read_b128 a[112:115], v243 offset:28672
		ds_read_b128 a[116:119], v243 offset:29696
		ds_read_b128 a[120:123], v243 offset:30720
		ds_read_b128 a[124:127], v243 offset:31744
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		buffer_load_dword v0, v9, s[20:23], s8 offen offset:3584
		s_add_i32 s9, s8, 0x1000
		buffer_load_dword v3, v9, s[20:23], s9 offen offset:3584
		s_add_i32 s16, s8, 0x2000
		buffer_load_dword v4, v9, s[20:23], s16 offen offset:3584
		s_add_i32 s17, s8, 0x3000
		buffer_load_dword v5, v9, s[20:23], s17 offen offset:3584
		s_add_i32 s18, s8, 0x4000
		buffer_load_dword v6, v9, s[20:23], s18 offen offset:3584
		s_add_i32 s29, s8, 0x5000
		buffer_load_dword v7, v9, s[20:23], s29 offen offset:3584
		s_add_i32 s30, s8, 0x6000
		buffer_load_dword v8, v9, s[20:23], s30 offen offset:3584
		s_add_i32 s31, s8, 0x7000
		buffer_load_dword v10, v9, s[20:23], s31 offen offset:3584
		buffer_load_dword v11, v14, s[24:27], s12 offen offset:3584
		s_add_i32 s28, s28, 0x1000
		s_add_i32 s15, s28, s15
		buffer_load_dword v12, v14, s[24:27], s15 offen offset:3584
		s_add_i32 s28, s13, 0x7800
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[20:23], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0xf800
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[32:35], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0x17800
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[236:239], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0x1f800
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[240:243], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0x7c00
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[244:247], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0xfc00
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[248:251], v15, s[0:3], 0 offen
		s_add_i32 s28, s13, 0x17c00
		s_add_i32 s28, s28, s5
		v_add3_u32 v15, s28, v1, v13
		buffer_load_dwordx4 v[252:255], v15, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a208, v252
		v_accvgpr_write_b32 a209, v253
		v_accvgpr_write_b32 a210, v254
		v_accvgpr_write_b32 a211, v255
		s_add_i32 s13, s13, 0x1fc00
		s_add_i32 s5, s13, s5
		v_add3_u32 v1, s5, v1, v13
		buffer_load_dwordx4 v[252:255], v1, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a212, v252
		v_accvgpr_write_b32 a213, v253
		v_accvgpr_write_b32 a214, v254
		v_accvgpr_write_b32 a215, v255
		buffer_load_dword v1, v9, s[20:23], s8 offen offset:3840
		buffer_load_dword v13, v9, s[20:23], s9 offen offset:3840
		buffer_load_dword v15, v9, s[20:23], s16 offen offset:3840
		buffer_load_dword v24, v9, s[20:23], s17 offen offset:3840
		buffer_load_dword v25, v9, s[20:23], s18 offen offset:3840
		buffer_load_dword v26, v9, s[20:23], s29 offen offset:3840
		buffer_load_dword v252, v9, s[20:23], s30 offen offset:3840
		buffer_load_dword v253, v9, s[20:23], s31 offen offset:3840
		buffer_load_dword v9, v14, s[24:27], s12 offen offset:3840
		buffer_load_dword v254, v14, s[24:27], s15 offen offset:3840
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[0:3], v[36:39], v[16:19], v0, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[0:3], v[40:43], v[64:67], v0, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[4:7], v[40:43], v[80:83], v0, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[4:7], v[36:39], v[76:79], v0, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[4:7], v[44:47], v[84:87], v0, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[0:3], v[44:47], v[68:71], v0, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[0:3], v[48:51], v[72:75], v0, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[4:7], v[48:51], v[88:91], v0, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[8:11], v[48:51], v[104:107], v3, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], v[44:47], v[100:103], v3, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], v[44:47], v[116:119], v3, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], v[48:51], v[120:123], v3, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], v[36:39], v[108:111], v3, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], v[36:39], v[92:95], v3, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], v[40:43], v[96:99], v3, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], v[40:43], v[112:115], v3, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[16:19], v[40:43], v[128:131], v4, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[16:19], v[36:39], v[124:127], v4, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[20:23], v[36:39], v[140:143], v4, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[20:23], v[40:43], v[144:147], v4, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[20:23], v[44:47], v[148:151], v4, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], v[44:47], v[132:135], v4, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], v[48:51], v[136:139], v4, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[20:23], v[48:51], v[152:155], v4, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[24:27], v[48:51], v[168:171], v5, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[24:27], v[44:47], v[164:167], v5, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[28:31], v[44:47], v[180:183], v5, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[28:31], v[48:51], v[184:187], v5, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[28:31], v[36:39], v[172:175], v5, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[24:27], v[36:39], v[156:159], v5, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[24:27], v[40:43], v[160:163], v5, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[28:31], v[40:43], v[176:179], v5, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[32:35], v[40:43], v[192:195], v6, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[32:35], v[36:39], v[188:191], v6, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[36:39], v[36:39], v[204:207], v6, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[36:39], v[40:43], v[208:211], v6, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[36:39], v[44:47], v[212:215], v6, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[32:35], v[44:47], v[196:199], v6, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[32:35], v[48:51], v[200:203], v6, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[36:39], v[48:51], v[216:219], v6, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[40:43], v[48:51], v[232:235], v7, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[40:43], v[44:47], v[228:231], v7, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[44:47], v[44:47], a[136:139], v7, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], v[48:51], a[140:143], v7, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[44:47], v[36:39], a[128:131], v7, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[40:43], v[36:39], v[220:223], v7, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[40:43], v[40:43], v[224:227], v7, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], v[40:43], a[132:135], v7, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], v[40:43], a[148:151], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], v[36:39], a[144:147], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], v[36:39], a[160:163], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], v[40:43], a[164:167], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], v[44:47], a[168:171], v8, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[48:51], v[44:47], a[152:155], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], v[48:51], a[156:159], v8, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[52:55], v[48:51], a[172:175], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[56:59], v[48:51], a[188:191], v10, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[56:59], v[44:47], a[184:187], v10, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[60:63], v[44:47], a[200:203], v10, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[60:63], v[48:51], a[204:207], v10, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[60:63], v[36:39], a[192:195], v10, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], v[36:39], a[176:179], v10, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[56:59], v[40:43], a[180:183], v10, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[60:63], v[40:43], a[196:199], v10, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[120:123], v[28:31], a[176:179], v10, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[120:123], v[52:55], a[180:183], v10, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[124:127], v[52:55], a[196:199], v10, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[124:127], v[28:31], a[192:195], v10, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[64:67], v[28:31], v[16:19], v0, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[64:67], v[52:55], v[64:67], v0, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[68:71], v[52:55], v[80:83], v0, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[68:71], v[28:31], v[76:79], v0, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[68:71], v[56:59], v[84:87], v0, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[64:67], v[56:59], v[68:71], v0, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[64:67], v[60:63], v[72:75], v0, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[68:71], v[60:63], v[88:91], v0, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[72:75], v[60:63], v[104:107], v3, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[72:75], v[56:59], v[100:103], v3, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[76:79], v[56:59], v[116:119], v3, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[76:79], v[60:63], v[120:123], v3, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[76:79], v[28:31], v[108:111], v3, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[72:75], v[28:31], v[92:95], v3, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[72:75], v[52:55], v[96:99], v3, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[76:79], v[52:55], v[112:115], v3, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[80:83], v[52:55], v[128:131], v4, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[80:83], v[28:31], v[124:127], v4, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[84:87], v[28:31], v[140:143], v4, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[84:87], v[52:55], v[144:147], v4, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[84:87], v[56:59], v[148:151], v4, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[80:83], v[56:59], v[132:135], v4, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[80:83], v[60:63], v[136:139], v4, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[84:87], v[60:63], v[152:155], v4, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[88:91], v[60:63], v[168:171], v5, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[88:91], v[56:59], v[164:167], v5, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], v[56:59], v[180:183], v5, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], v[60:63], v[184:187], v5, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], v[28:31], v[172:175], v5, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[88:91], v[28:31], v[156:159], v5, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[88:91], v[52:55], v[160:163], v5, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], v[52:55], v[176:179], v5, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], v[52:55], v[192:195], v6, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[96:99], v[28:31], v[188:191], v6, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[100:103], v[28:31], v[204:207], v6, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[100:103], v[52:55], v[208:211], v6, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[100:103], v[56:59], v[212:215], v6, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], v[56:59], v[196:199], v6, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], v[60:63], v[200:203], v6, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[100:103], v[60:63], v[216:219], v6, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[104:107], v[60:63], v[232:235], v7, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[104:107], v[56:59], v[228:231], v7, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[108:111], v[56:59], a[136:139], v7, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[108:111], v[60:63], a[140:143], v7, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[108:111], v[28:31], a[128:131], v7, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[104:107], v[28:31], v[220:223], v7, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[104:107], v[52:55], v[224:227], v7, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[108:111], v[52:55], a[132:135], v7, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[112:115], v[52:55], a[148:151], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[112:115], v[28:31], a[144:147], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[116:119], v[28:31], a[160:163], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[116:119], v[52:55], a[164:167], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[116:119], v[56:59], a[168:171], v8, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[112:115], v[56:59], a[152:155], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[112:115], v[60:63], a[156:159], v8, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[116:119], v[60:63], a[172:175], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[120:123], v[60:63], a[188:191], v10, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[120:123], v[56:59], a[184:187], v10, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[124:127], v[56:59], a[200:203], v10, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[124:127], v[60:63], a[204:207], v10, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[4:7], v27 offset:32768
		ds_read_b128 v[28:31], v27 offset:33792
		ds_read_b128 v[36:39], v27 offset:34816
		ds_read_b128 v[40:43], v27 offset:35840
		ds_read_b128 v[44:47], v27 offset:36864
		ds_read_b128 v[48:51], v27 offset:37888
		ds_read_b128 v[52:55], v27 offset:38912
		ds_read_b128 v[56:59], v27 offset:39936
		ds_read_b128 a[0:3], v27 offset:40960
		ds_read_b128 a[4:7], v27 offset:41984
		ds_read_b128 a[8:11], v27 offset:43008
		ds_read_b128 a[12:15], v27 offset:44032
		ds_read_b128 a[16:19], v27 offset:45056
		ds_read_b128 a[20:23], v27 offset:46080
		ds_read_b128 a[24:27], v27 offset:47104
		ds_read_b128 a[28:31], v27 offset:48128
		ds_read_b128 a[32:35], v27 offset:49152
		ds_read_b128 a[36:39], v27 offset:50176
		ds_read_b128 a[40:43], v27 offset:51200
		ds_read_b128 a[44:47], v27 offset:52224
		ds_read_b128 a[48:51], v27 offset:53248
		ds_read_b128 a[52:55], v27 offset:54272
		ds_read_b128 a[56:59], v27 offset:55296
		ds_read_b128 a[60:63], v27 offset:56320
		ds_read_b128 a[64:67], v27 offset:57344
		ds_read_b128 a[68:71], v27 offset:58368
		ds_read_b128 a[72:75], v27 offset:59392
		ds_read_b128 a[76:79], v27 offset:60416
		ds_read_b128 a[80:83], v27 offset:61440
		ds_read_b128 a[84:87], v27 offset:62464
		ds_read_b128 a[88:91], v27 offset:63488
		ds_read_b128 v[60:63], v27 offset:64512
		s_waitcnt vmcnt(1) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[4:7], v[20:23], v[16:19], v1, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[4:7], v[32:35], v[64:67], v1, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], v[32:35], v[80:83], v1, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[28:31], v[20:23], v[76:79], v1, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[28:31], v[236:239], v[84:87], v1, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[4:7], v[236:239], v[68:71], v1, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[4:7], v[240:243], v[72:75], v1, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[28:31], v[240:243], v[88:91], v1, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[36:39], v[240:243], v[104:107], v13, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[36:39], v[236:239], v[100:103], v13, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], v[236:239], v[116:119], v13, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], v[240:243], v[120:123], v13, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[40:43], v[20:23], v[108:111], v13, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[36:39], v[20:23], v[92:95], v13, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[36:39], v[32:35], v[96:99], v13, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[40:43], v[32:35], v[112:115], v13, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[44:47], v[32:35], v[128:131], v15, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[44:47], v[20:23], v[124:127], v15, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], v[20:23], v[140:143], v15, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[48:51], v[32:35], v[144:147], v15, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[48:51], v[236:239], v[148:151], v15, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], v[236:239], v[132:135], v15, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[44:47], v[240:243], v[136:139], v15, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], v[240:243], v[152:155], v15, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[240:243], v[168:171], v24, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], v[236:239], v[164:167], v24, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], v[236:239], v[180:183], v24, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], v[240:243], v[184:187], v24, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], v[20:23], v[172:175], v24, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], v[20:23], v[156:159], v24, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], v[32:35], v[160:163], v24, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[32:35], v[176:179], v24, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[0:3], v[32:35], v[192:195], v25, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[0:3], v[20:23], v[188:191], v25, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[4:7], v[20:23], v[204:207], v25, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[4:7], v[32:35], v[208:211], v25, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[4:7], v[236:239], v[212:215], v25, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[0:3], v[236:239], v[196:199], v25, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[0:3], v[240:243], v[200:203], v25, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[4:7], v[240:243], v[216:219], v25, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[8:11], v[240:243], v[232:235], v26, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[8:11], v[236:239], v[228:231], v26, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[12:15], v[236:239], a[136:139], v26, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[12:15], v[240:243], a[140:143], v26, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[12:15], v[20:23], a[128:131], v26, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[8:11], v[20:23], v[220:223], v26, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[8:11], v[32:35], v[224:227], v26, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[12:15], v[32:35], a[132:135], v26, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[16:19], v[32:35], a[148:151], v252, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[16:19], v[20:23], a[144:147], v252, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[20:23], v[20:23], a[160:163], v252, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[20:23], v[32:35], a[164:167], v252, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[20:23], v[236:239], a[168:171], v252, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[16:19], v[236:239], a[152:155], v252, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[16:19], v[240:243], a[156:159], v252, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[20:23], v[240:243], a[172:175], v252, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[24:27], v[240:243], a[188:191], v253, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[24:27], v[236:239], a[184:187], v253, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[28:31], v[236:239], a[200:203], v253, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[28:31], v[240:243], a[204:207], v253, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[28:31], v[20:23], a[192:195], v253, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[24:27], v[20:23], a[176:179], v253, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[24:27], v[32:35], a[180:183], v253, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[28:31], v[32:35], a[196:199], v253, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[88:91], v[244:247], a[176:179], v253, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[88:91], v[248:251], a[180:183], v253, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[60:63], v[248:251], a[196:199], v253, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[60:63], v[244:247], a[192:195], v253, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[32:35], v[244:247], v[16:19], v1, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[32:35], v[248:251], v[64:67], v1, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[36:39], v[248:251], v[80:83], v1, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[36:39], v[244:247], v[76:79], v1, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[36:39], a[208:211], v[84:87], v1, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[32:35], a[208:211], v[68:71], v1, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[32:35], a[212:215], v[72:75], v1, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[36:39], a[212:215], v[88:91], v1, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[40:43], a[212:215], v[104:107], v13, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v16, v17
		v_cvt_pk_f16_f32 v1, v18, v19
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[208:211], v[100:103], v13, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[208:211], v[116:119], v13, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[212:215], v[120:123], v13, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], v[244:247], v[108:111], v13, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], v[244:247], v[92:95], v13, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], v[248:251], v[96:99], v13, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], v[248:251], v[112:115], v13, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[48:51], v[248:251], v[128:131], v15, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[48:51], v[244:247], v[124:127], v15, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[52:55], v[244:247], v[140:143], v15, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[52:55], v[248:251], v[144:147], v15, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[52:55], a[208:211], v[148:151], v15, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[48:51], a[208:211], v[132:135], v15, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[212:215], v[136:139], v15, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[52:55], a[212:215], v[152:155], v15, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[56:59], a[212:215], v[168:171], v24, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[56:59], a[208:211], v[164:167], v24, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[60:63], a[208:211], v[180:183], v24, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[60:63], a[212:215], v[184:187], v24, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[60:63], v[244:247], v[172:175], v24, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[56:59], v[244:247], v[156:159], v24, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[56:59], v[248:251], v[160:163], v24, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[60:63], v[248:251], v[176:179], v24, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[64:67], v[248:251], v[192:195], v25, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[64:67], v[244:247], v[188:191], v25, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[68:71], v[244:247], v[204:207], v25, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[68:71], v[248:251], v[208:211], v25, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[68:71], a[208:211], v[212:215], v25, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[64:67], a[208:211], v[196:199], v25, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[64:67], a[212:215], v[200:203], v25, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[68:71], a[212:215], v[216:219], v25, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[72:75], a[212:215], v[232:235], v26, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[72:75], a[208:211], v[228:231], v26, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[76:79], a[208:211], a[136:139], v26, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[76:79], a[212:215], a[140:143], v26, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[76:79], v[244:247], a[128:131], v26, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[72:75], v[244:247], v[220:223], v26, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[72:75], v[248:251], v[224:227], v26, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[76:79], v[248:251], a[132:135], v26, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[80:83], v[248:251], a[148:151], v252, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[80:83], v[244:247], a[144:147], v252, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[84:87], v[244:247], a[160:163], v252, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], v[248:251], a[164:167], v252, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[208:211], a[168:171], v252, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[80:83], a[208:211], a[152:155], v252, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[80:83], a[212:215], a[156:159], v252, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[84:87], a[212:215], a[172:175], v252, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[88:91], a[212:215], a[188:191], v253, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[88:91], a[208:211], a[184:187], v253, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[60:63], a[208:211], a[200:203], v253, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[60:63], a[212:215], a[204:207], v253, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s35, s19
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v64, v65
		v_cvt_pk_f16_f32 v1, v66, v67
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s14 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v216, v217
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s11 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s10 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v224, v225
		v_cvt_pk_f16_f32 v1, v226, v227
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s10 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v228, v229
		v_cvt_pk_f16_f32 v1, v230, v231
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s10 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v232, v233
		v_cvt_pk_f16_f32 v1, v234, v235
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s10 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a128
		v_accvgpr_read_b32 v1, a129
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a130
		v_accvgpr_read_b32 v1, a131
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s10 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v1, a133
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v1, a135
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s10 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v1, a137
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v1, a139
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s10 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v1, a141
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v1, a143
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s10 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v1, a145
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v1, a147
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v1, a149
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v1, a151
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:512 sc0 nt
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v1, a153
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v1, a155
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v1, a157
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v1, a159
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v1, a161
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v1, a163
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v1, a165
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v1, a167
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v1, a169
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v1, a171
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v1, a173
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v1, a175
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s4 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v1, a177
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v1, a179
		v_cvt_pk_f16_f32 v5, v0, v1
		s_mov_b32 s0, 0x7000
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen sc0 nt
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v1, a181
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v1, a183
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:512 sc0 nt
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v1, a185
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v1, a187
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v1, a189
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v1, a191
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v1, a193
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v1, a195
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v1, a197
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v1, a199
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v1, a201
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v1, a203
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v1, a205
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v1, a207
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s0 offen offset:3584 sc0 nt
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 472
		.amdhsa_next_free_sgpr 48
		.amdhsa_accum_offset 256
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 256
	.set .Lwmma_f16_matmul_tiled.num_agpr, 216
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 48
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
      - .address_space:  global
        .name:           arg3
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .name:           arg4
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
      - .name:           arg5
        .offset:         40
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     48
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     472
    .agpr_count:     216
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 78
    wave.regalloc.agpr.dwords: 308
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
