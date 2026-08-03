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
		s_lshl_b32 s12, s5, 17
		s_add_i32 s4, s4, s12
		s_and_b32 s12, s14, 7
		s_lshl_b32 s14, s12, 22
		s_add_i32 s4, s4, s14
		v_readfirstlane_b32 s14, v0
		s_lshl_b32 s15, s12, 19
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 15, v1
		v_add_u32_e32 v3, s15, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 11, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		s_add_i32 s28, s15, 0x20000
		v_add_u32_e32 v7, s28, v2
		s_add_i32 s28, s15, 0x40000
		v_add3_u32 v8, v2, v5, v6
		s_add_i32 s29, s15, 0x60000
		s_add_i32 s30, s15, 0x20040
		v_add_u32_e32 v9, v2, v5
		s_add_i32 s31, s15, 0x40040
		s_add_i32 s32, s15, 0x60040
		s_lshr_b32 s14, s14, 6
		s_lshl_b32 s33, s14, 10
		s_mov_b32 m0, s33
		v_add3_u32 v3, v3, v5, v6
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		v_add3_u32 v5, v7, v5, v6
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v7, s28, v8
		v_add_u32_e32 v10, s29, v8
		v_add3_u32 v8, v8, s15, 64
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v11, v6, v9, s30
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, v6, v9, s31
		v_add3_u32 v6, v6, v9, s32
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s15, 0x4000
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		v_and_b32_e32 v9, 15, v4
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v13, 4, v4
		s_mul_i32 s14, 0xc00, s14
		v_lshlrev_b32_e32 v9, 4, v9
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_lshl_add_u32 v14, v13, 12, v9
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s28, s5, 15
		v_and_b32_e32 v15, 1, v13
		v_lshlrev_b32_e32 v20, 13, v1
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v15, 12, v15
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s12, s12, 15
		v_add3_u32 v9, v20, v15, v9
		v_accvgpr_write_b32 a0, v9
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_mov_b32 s29, 0x80
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s30, 0
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_mov_b32_e32 v9, 0xc00
		v_mul_lo_u32 v9, v9, v1
		s_add_i32 m0, s14, 0x10000
		s_lshl_b32 s31, s13, 17
		v_add_u32_e32 v15, s12, v14
		buffer_load_dwordx4 v14, s[20:23], s12 offen lds
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_add_i32 m0, m0, 0x400
		s_add_i32 s10, s12, 0x4000
		buffer_load_dwordx4 v14, s[20:23], s10 offen lds
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_add_i32 m0, m0, 0x400
		s_add_i32 s8, s31, s28
		v_accvgpr_read_b32 v20, a0
		v_add_u32_e32 v20, s8, v20
		v_lshlrev_b32_e32 v1, 17, v1
		v_accvgpr_read_b32 v21, a0
		buffer_load_dwordx4 v21, s[24:27], s8 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, s33, 0x8000
		v_lshlrev_b32_e32 v21, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v13, v0, 3 bitop3:0x78
		buffer_load_dwordx4 v3, s[16:19], s29 offen lds
		v_lshlrev_b32_e32 v0, 4, v0
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v13, v21, v0
		v_add_u32_e32 v22, 0x100, v15
		v_add_u32_e32 v23, 0x4100, v15
		buffer_load_dwordx4 v5, s[16:19], s29 offen lds
		v_add_u32_e32 v15, 0x100, v20
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s8, s6, s4
		s_addc_u32 s9, s7, 0
		buffer_load_dwordx4 v7, s[16:19], s29 offen lds
		s_mov_b32 s10, 0x20000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s4, 0x5000
		buffer_load_dwordx4 v10, s[16:19], s29 offen lds
		s_mov_b32 s6, 0x3000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s7, 0x2000
		buffer_load_dwordx4 v8, s[16:19], s29 offen lds
		s_mov_b32 s32, 0x1000
		s_add_i32 m0, m0, 0x1000
		v_lshl_add_u32 v2, v4, 3, v2
		buffer_load_dwordx4 v11, s[16:19], s29 offen lds
		v_lshlrev_b32_e32 v20, 2, v4
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s5, s5, 19
		buffer_load_dwordx4 v12, s[16:19], s29 offen lds
		v_lshlrev_b32_e32 v24, 4, v4
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s11, s13, 21
		s_add_i32 s13, s11, s5
		v_add3_u32 v25, s13, v1, v24
		buffer_load_dwordx4 v6, s[16:19], s29 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 a[4:7], v13
		ds_read_b128 a[8:11], v13 offset:1024
		ds_read_b128 a[12:15], v13 offset:2048
		ds_read_b128 a[16:19], v13 offset:3072
		ds_read_b128 a[20:23], v13 offset:4096
		ds_read_b128 a[24:27], v13 offset:5120
		ds_read_b128 a[28:31], v13 offset:6144
		ds_read_b128 a[32:35], v13 offset:7168
		ds_read_b128 a[36:39], v13 offset:8192
		ds_read_b128 a[40:43], v13 offset:9216
		ds_read_b128 a[44:47], v13 offset:10240
		ds_read_b128 a[48:51], v13 offset:11264
		ds_read_b128 a[52:55], v13 offset:12288
		ds_read_b128 a[56:59], v13 offset:13312
		ds_read_b128 a[60:63], v13 offset:14336
		ds_read_b128 a[64:67], v13 offset:15360
		ds_read_b128 a[68:71], v13 offset:16384
		ds_read_b128 a[72:75], v13 offset:17408
		ds_read_b128 a[76:79], v13 offset:18432
		ds_read_b128 a[80:83], v13 offset:19456
		ds_read_b128 a[84:87], v13 offset:20480
		ds_read_b128 a[88:91], v13 offset:21504
		ds_read_b128 a[92:95], v13 offset:22528
		ds_read_b128 a[96:99], v13 offset:23552
		ds_read_b128 a[100:103], v13 offset:24576
		ds_read_b128 a[104:107], v13 offset:25600
		ds_read_b128 a[108:111], v13 offset:26624
		ds_read_b128 a[112:115], v13 offset:27648
		ds_read_b128 a[116:119], v13 offset:28672
		ds_read_b128 a[120:123], v13 offset:29696
		ds_read_b128 a[124:127], v13 offset:30720
		ds_read_b128 a[128:131], v13 offset:31744
		s_add_i32 s13, s11, 0x8000
		s_add_i32 s13, s13, s5
		v_add3_u32 v26, s13, v1, v24
		s_add_i32 s13, s11, 0x10000
		s_add_i32 s13, s13, s5
		v_add3_u32 v27, s13, v1, v24
		s_add_i32 s13, s11, 0x18000
		s_add_i32 s13, s13, s5
		v_add3_u32 v28, s13, v1, v24
		s_add_i32 s13, s11, 0x400
		s_add_i32 s13, s13, s5
		v_add3_u32 v29, s13, v1, v24
		s_add_i32 s13, s11, 0x8400
		s_add_i32 s13, s13, s5
		v_add3_u32 v30, s13, v1, v24
		s_add_i32 s13, s11, 0x10400
		s_add_i32 s13, s13, s5
		v_add3_u32 v31, s13, v1, v24
		s_add_i32 s13, s11, 0x18400
		s_add_i32 s13, s13, s5
		v_add3_u32 v32, s13, v1, v24
		buffer_load_dwordx4 v[36:39], v25, s[0:3], 0 offen
		buffer_load_dwordx4 v[40:43], v26, s[0:3], 0 offen
		buffer_load_dwordx4 v[44:47], v27, s[0:3], 0 offen
		buffer_load_dwordx4 v[48:51], v28, s[0:3], 0 offen
		buffer_load_dwordx4 v[52:55], v29, s[0:3], 0 offen
		buffer_load_dwordx4 v[56:59], v30, s[0:3], 0 offen
		buffer_load_dwordx4 v[60:63], v31, s[0:3], 0 offen
		buffer_load_dwordx4 v[28:31], v32, s[0:3], 0 offen
		s_add_i32 s13, s11, 0x800
		s_add_i32 s13, s13, s5
		s_add_i32 s29, s11, 0x8800
		s_add_i32 s29, s29, s5
		s_add_i32 s34, s11, 0x10800
		s_add_i32 s34, s34, s5
		s_add_i32 s35, s11, 0x18800
		s_add_i32 s35, s35, s5
		s_add_i32 s38, s11, 0xc00
		s_add_i32 s44, s38, s5
		s_add_i32 s38, s11, 0x8c00
		s_add_i32 s45, s38, s5
		s_add_i32 s38, s11, 0x10c00
		s_add_i32 s46, s38, s5
		s_add_i32 s38, s11, 0x18c00
		s_add_i32 s47, s38, s5
		s_mov_b32 s40, s20
		s_mov_b32 s41, s21
		s_mov_b32 s42, s22
		s_mov_b32 s43, s23
		s_mov_b32 s36, s24
		s_mov_b32 s37, s25
		s_mov_b32 s38, s26
		s_mov_b32 s39, s27
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
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
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_and_b32 s48, s30, 1
		s_mul_i32 s48, 0x3000, s48
		s_add_i32 s48, s48, 0x10000
		v_add3_u32 v25, s48, v9, v20
		ds_read2st64_b32 v[26:27], v25 offset1:1
		ds_read2st64_b32 v[248:249], v25 offset0:2 offset1:3
		ds_read2st64_b32 v[250:251], v25 offset0:4 offset1:5
		ds_read2st64_b32 v[252:253], v25 offset0:6 offset1:7
		ds_read2st64_b32 v[254:255], v25 offset0:8 offset1:9
		s_lshl_b32 s48, s30, 7
		s_add_i32 s48, s48, 0x100
		s_add_i32 s49, s33, 0x8000
		s_lshl_b32 s50, s30, 11
		s_add_i32 s30, s30, 1
		s_and_b32 s51, s30, 1
		s_mul_i32 s52, 0x3000, s51
		s_add_i32 s52, s14, s52
		s_add_i32 m0, s52, 0x10000
		s_lshl_b32 s51, s51, 15
		buffer_load_dwordx4 v22, s[40:43], 0 offen lds
		s_waitcnt vmcnt(8) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[4:7], v[36:39], v[16:19], v26, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add3_u32 v25, s51, v21, v0
		s_add_i32 m0, m0, 0x400
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[4:7], v[40:43], v[32:35], v26, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], v[40:43], v[76:79], v26, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[40:43], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], v[36:39], v[72:75], v26, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x400
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], v[44:47], v[80:83], v26, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], v[44:47], v[64:67], v26, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], v[48:51], v[68:71], v26, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], v[48:51], v[84:87], v26, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], v[48:51], v[100:103], v27, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[12:15], v[44:47], v[96:99], v27, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[16:19], v[44:47], v[112:115], v27, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[16:19], v[48:51], v[116:119], v27, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[16:19], v[36:39], v[104:107], v27, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[12:15], v[36:39], v[88:91], v27, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[12:15], v[40:43], v[92:95], v27, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v5, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[16:19], v[40:43], v[108:111], v27, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[20:23], v[40:43], v[124:127], v248, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[20:23], v[36:39], v[120:123], v248, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[24:27], v[36:39], v[136:139], v248, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v7, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[24:27], v[40:43], v[140:143], v248, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[24:27], v[44:47], v[144:147], v248, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[20:23], v[44:47], v[128:131], v248, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[20:23], v[48:51], v[132:135], v248, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[24:27], v[48:51], v[148:151], v248, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[28:31], v[48:51], v[164:167], v249, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[28:31], v[44:47], v[160:163], v249, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[32:35], v[44:47], v[176:179], v249, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[32:35], v[48:51], v[180:183], v249, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[32:35], v[36:39], v[168:171], v249, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[28:31], v[36:39], v[152:155], v249, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v8, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[28:31], v[40:43], v[156:159], v249, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[32:35], v[40:43], v[172:175], v249, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[36:39], v[40:43], v[188:191], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[36:39], v[36:39], v[184:187], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[40:43], v[36:39], v[192:195], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[40:43], v[40:43], v[196:199], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[40:43], v[44:47], a[140:143], v250, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[36:39], v[44:47], a[132:135], v250, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v12, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[36:39], v[48:51], a[136:139], v250, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[40:43], v[48:51], a[144:147], v250, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[44:47], v[48:51], a[152:155], v251, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[44:47], v[44:47], a[148:151], v251, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v6, s[16:19], s48 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], v[44:47], a[156:159], v251, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s33, s49, 0xffff
		s_add_u32 s40, s40, 0x100
		s_addc_u32 s41, s41, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[48:51], v[48:51], a[160:163], v251, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_u32 s36, s36, 0x100
		s_addc_u32 s37, s37, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[48:51], v[36:39], v[208:211], v251, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[44:47], v[36:39], v[200:203], v251, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[44:47], v[40:43], v[204:207], v251, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[48:51], v[40:43], v[212:215], v251, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[52:55], v[40:43], v[220:223], v252, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[52:55], v[36:39], v[216:219], v252, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[56:59], v[36:39], v[224:227], v252, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[56:59], v[40:43], v[228:231], v252, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[56:59], v[44:47], a[172:175], v252, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], v[44:47], a[164:167], v252, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], v[48:51], a[168:171], v252, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], v[48:51], a[176:179], v252, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[60:63], v[48:51], a[184:187], v253, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[60:63], v[44:47], a[180:183], v253, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], v[44:47], a[188:191], v253, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], v[48:51], a[192:195], v253, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], v[36:39], v[240:243], v253, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[60:63], v[36:39], v[232:235], v253, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[60:63], v[40:43], v[236:239], v253, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], v[40:43], v[244:247], v253, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[124:127], v[52:55], v[232:235], v253, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[124:127], v[56:59], v[236:239], v253, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[128:131], v[56:59], v[244:247], v253, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[128:131], v[52:55], v[240:243], v253, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[68:71], v[52:55], v[16:19], v26, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[68:71], v[56:59], v[32:35], v26, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], v[56:59], v[76:79], v26, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], v[52:55], v[72:75], v26, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[72:75], v[60:63], v[80:83], v26, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[68:71], v[60:63], v[64:67], v26, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], v[28:31], v[68:71], v26, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], v[28:31], v[84:87], v26, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], v[28:31], v[100:103], v27, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], v[60:63], v[96:99], v27, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], v[60:63], v[112:115], v27, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[80:83], v[28:31], v[116:119], v27, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], v[52:55], v[104:107], v27, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], v[52:55], v[88:91], v27, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], v[56:59], v[92:95], v27, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], v[56:59], v[108:111], v27, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], v[56:59], v[124:127], v248, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], v[52:55], v[120:123], v248, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[88:91], v[52:55], v[136:139], v248, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], v[56:59], v[140:143], v248, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], v[60:63], v[144:147], v248, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], v[60:63], v[128:131], v248, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], v[28:31], v[132:135], v248, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], v[28:31], v[148:151], v248, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], v[28:31], v[164:167], v249, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], v[60:63], v[160:163], v249, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], v[60:63], v[176:179], v249, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], v[28:31], v[180:183], v249, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], v[52:55], v[168:171], v249, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], v[52:55], v[152:155], v249, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], v[56:59], v[156:159], v249, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[96:99], v[56:59], v[172:175], v249, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[100:103], v[56:59], v[188:191], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[100:103], v[52:55], v[184:187], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[104:107], v[52:55], v[192:195], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[104:107], v[56:59], v[196:199], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[104:107], v[60:63], a[140:143], v250, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[100:103], v[60:63], a[132:135], v250, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[100:103], v[28:31], a[136:139], v250, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[104:107], v[28:31], a[144:147], v250, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[108:111], v[28:31], a[152:155], v251, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[108:111], v[60:63], a[148:151], v251, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[112:115], v[60:63], a[156:159], v251, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[112:115], v[28:31], a[160:163], v251, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[112:115], v[52:55], v[208:211], v251, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[108:111], v[52:55], v[200:203], v251, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[108:111], v[56:59], v[204:207], v251, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[112:115], v[56:59], v[212:215], v251, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[116:119], v[56:59], v[220:223], v252, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[116:119], v[52:55], v[216:219], v252, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[120:123], v[52:55], v[224:227], v252, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[120:123], v[56:59], v[228:231], v252, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[120:123], v[60:63], a[172:175], v252, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[116:119], v[60:63], a[164:167], v252, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[116:119], v[28:31], a[168:171], v252, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[120:123], v[28:31], a[176:179], v252, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[124:127], v[28:31], a[184:187], v253, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[124:127], v[60:63], a[180:183], v253, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[128:131], v[60:63], a[188:191], v253, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[128:131], v[28:31], a[192:195], v253, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 a[4:7], v25
		ds_read_b128 a[8:11], v25 offset:1024
		ds_read_b128 a[12:15], v25 offset:2048
		ds_read_b128 a[16:19], v25 offset:3072
		ds_read_b128 a[20:23], v25 offset:4096
		ds_read_b128 a[24:27], v25 offset:5120
		ds_read_b128 a[28:31], v25 offset:6144
		ds_read_b128 a[32:35], v25 offset:7168
		ds_read_b128 a[36:39], v25 offset:8192
		ds_read_b128 a[40:43], v25 offset:9216
		ds_read_b128 a[44:47], v25 offset:10240
		ds_read_b128 a[48:51], v25 offset:11264
		ds_read_b128 a[52:55], v25 offset:12288
		ds_read_b128 a[56:59], v25 offset:13312
		ds_read_b128 a[60:63], v25 offset:14336
		ds_read_b128 a[64:67], v25 offset:15360
		ds_read_b128 a[68:71], v25 offset:16384
		ds_read_b128 a[72:75], v25 offset:17408
		ds_read_b128 a[76:79], v25 offset:18432
		ds_read_b128 a[80:83], v25 offset:19456
		ds_read_b128 a[84:87], v25 offset:20480
		ds_read_b128 a[88:91], v25 offset:21504
		ds_read_b128 a[92:95], v25 offset:22528
		ds_read_b128 a[96:99], v25 offset:23552
		ds_read_b128 a[100:103], v25 offset:24576
		ds_read_b128 a[104:107], v25 offset:25600
		ds_read_b128 a[108:111], v25 offset:26624
		ds_read_b128 a[112:115], v25 offset:27648
		ds_read_b128 a[116:119], v25 offset:28672
		ds_read_b128 a[120:123], v25 offset:29696
		ds_read_b128 a[124:127], v25 offset:30720
		ds_read_b128 a[128:131], v25 offset:31744
		s_add_i32 s48, s13, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[36:39], v25, s[0:3], 0 offen
		s_add_i32 s48, s29, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[40:43], v25, s[0:3], 0 offen
		s_add_i32 s48, s34, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[44:47], v25, s[0:3], 0 offen
		s_add_i32 s48, s35, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[48:51], v25, s[0:3], 0 offen
		s_add_i32 s48, s44, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[52:55], v25, s[0:3], 0 offen
		s_add_i32 s48, s45, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[56:59], v25, s[0:3], 0 offen
		s_add_i32 s48, s46, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[60:63], v25, s[0:3], 0 offen
		s_add_i32 s48, s47, s50
		v_add3_u32 v25, s48, v1, v24
		buffer_load_dwordx4 v[28:31], v25, s[0:3], 0 offen
		s_cmp_lt_i32 s30, 14
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 m0, s14, 0x13000
		s_add_i32 s13, s12, 0xf00
		buffer_load_dwordx4 v14, s[20:23], s13 offen lds
		v_add_u32_e32 v0, 0x10000, v9
		s_add_i32 m0, m0, 0x400
		s_add_i32 s12, s12, 0x4f00
		s_add_i32 s13, s31, 0xf00
		v_lshl_add_u32 v0, v4, 2, v0
		buffer_load_dwordx4 v14, s[20:23], s12 offen lds
		s_mov_b32 s12, 0x6000
		s_add_i32 m0, m0, 0x400
		s_add_i32 s13, s13, s28
		s_add_i32 s14, s11, 0x7800
		s_add_i32 s14, s14, s5
		v_accvgpr_read_b32 v3, a0
		buffer_load_dwordx4 v3, s[24:27], s13 offen lds
		v_add3_u32 v3, s14, v1, v24
		buffer_load_dwordx4 v[4:7], v3, s[0:3], 0 offen
		s_add_i32 s13, s11, 0xf800
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[8:11], v3, s[0:3], 0 offen
		s_add_i32 s13, s11, 0x17800
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[20:23], v3, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a0, v20
		v_accvgpr_write_b32 a1, v21
		v_accvgpr_write_b32 a2, v22
		v_accvgpr_write_b32 a3, v23
		s_add_i32 s13, s11, 0x1f800
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[20:23], v3, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a196, v20
		v_accvgpr_write_b32 a197, v21
		v_accvgpr_write_b32 a198, v22
		v_accvgpr_write_b32 a199, v23
		s_add_i32 s13, s11, 0x7c00
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[20:23], v3, s[0:3], 0 offen
		s_add_i32 s13, s11, 0xfc00
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[248:251], v3, s[0:3], 0 offen
		s_add_i32 s13, s11, 0x17c00
		s_add_i32 s13, s13, s5
		v_add3_u32 v3, s13, v1, v24
		buffer_load_dwordx4 v[252:255], v3, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a200, v252
		v_accvgpr_write_b32 a201, v253
		v_accvgpr_write_b32 a202, v254
		v_accvgpr_write_b32 a203, v255
		s_add_i32 s11, s11, 0x1fc00
		s_add_i32 s5, s11, s5
		v_add3_u32 v1, s5, v1, v24
		buffer_load_dwordx4 v[24:27], v1, s[0:3], 0 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a204, v24
		v_accvgpr_write_b32 a205, v25
		v_accvgpr_write_b32 a206, v26
		v_accvgpr_write_b32 a207, v27
		ds_read2st64_b32 v[14:15], v0 offset1:1
		ds_read2st64_b32 v[24:25], v0 offset0:2 offset1:3
		ds_read2st64_b32 v[26:27], v0 offset0:4 offset1:5
		ds_read2st64_b32 v[252:253], v0 offset0:6 offset1:7
		ds_read2st64_b32 v[254:255], v0 offset0:8 offset1:9
		s_mov_b32 s0, 0x7000
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[4:7], v[36:39], v[16:19], v14, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[4:7], v[40:43], v[32:35], v14, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], v[40:43], v[76:79], v14, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], v[36:39], v[72:75], v14, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], v[44:47], v[80:83], v14, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], v[44:47], v[64:67], v14, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], v[48:51], v[68:71], v14, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], v[48:51], v[84:87], v14, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], v[48:51], v[100:103], v15, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[12:15], v[44:47], v[96:99], v15, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[16:19], v[44:47], v[112:115], v15, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[16:19], v[48:51], v[116:119], v15, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[16:19], v[36:39], v[104:107], v15, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[12:15], v[36:39], v[88:91], v15, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[12:15], v[40:43], v[92:95], v15, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[16:19], v[40:43], v[108:111], v15, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[20:23], v[40:43], v[124:127], v24, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[20:23], v[36:39], v[120:123], v24, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[24:27], v[36:39], v[136:139], v24, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[24:27], v[40:43], v[140:143], v24, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[24:27], v[44:47], v[144:147], v24, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[20:23], v[44:47], v[128:131], v24, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[20:23], v[48:51], v[132:135], v24, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[24:27], v[48:51], v[148:151], v24, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[28:31], v[48:51], v[164:167], v25, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[28:31], v[44:47], v[160:163], v25, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[32:35], v[44:47], v[176:179], v25, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[32:35], v[48:51], v[180:183], v25, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[32:35], v[36:39], v[168:171], v25, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[28:31], v[36:39], v[152:155], v25, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[28:31], v[40:43], v[156:159], v25, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[32:35], v[40:43], v[172:175], v25, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[36:39], v[40:43], v[188:191], v26, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[36:39], v[36:39], v[184:187], v26, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[40:43], v[36:39], v[192:195], v26, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[40:43], v[40:43], v[196:199], v26, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[40:43], v[44:47], a[140:143], v26, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[36:39], v[44:47], a[132:135], v26, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[36:39], v[48:51], a[136:139], v26, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[40:43], v[48:51], a[144:147], v26, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[44:47], v[48:51], a[152:155], v27, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[44:47], v[44:47], a[148:151], v27, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], v[44:47], a[156:159], v27, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[48:51], v[48:51], a[160:163], v27, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[48:51], v[36:39], v[208:211], v27, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[44:47], v[36:39], v[200:203], v27, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[44:47], v[40:43], v[204:207], v27, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[48:51], v[40:43], v[212:215], v27, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[52:55], v[40:43], v[220:223], v252, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[52:55], v[36:39], v[216:219], v252, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[56:59], v[36:39], v[224:227], v252, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[56:59], v[40:43], v[228:231], v252, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[56:59], v[44:47], a[172:175], v252, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], v[44:47], a[164:167], v252, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], v[48:51], a[168:171], v252, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], v[48:51], a[176:179], v252, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[60:63], v[48:51], a[184:187], v253, v255 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[60:63], v[44:47], a[180:183], v253, v255 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], v[44:47], a[188:191], v253, v255 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], v[48:51], a[192:195], v253, v255 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[64:67], v[36:39], v[240:243], v253, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[60:63], v[36:39], v[232:235], v253, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[60:63], v[40:43], v[236:239], v253, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[64:67], v[40:43], v[244:247], v253, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[124:127], v[52:55], v[232:235], v253, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[124:127], v[56:59], v[236:239], v253, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[128:131], v[56:59], v[244:247], v253, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[128:131], v[52:55], v[240:243], v253, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[68:71], v[52:55], v[16:19], v14, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[68:71], v[56:59], v[32:35], v14, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[72:75], v[56:59], v[76:79], v14, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[72:75], v[52:55], v[72:75], v14, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[72:75], v[60:63], v[80:83], v14, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[68:71], v[60:63], v[64:67], v14, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[68:71], v[28:31], v[68:71], v14, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[72:75], v[28:31], v[84:87], v14, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[76:79], v[28:31], v[100:103], v15, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[76:79], v[60:63], v[96:99], v15, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[80:83], v[60:63], v[112:115], v15, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[80:83], v[28:31], v[116:119], v15, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[80:83], v[52:55], v[104:107], v15, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[76:79], v[52:55], v[88:91], v15, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[76:79], v[56:59], v[92:95], v15, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[80:83], v[56:59], v[108:111], v15, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[84:87], v[56:59], v[124:127], v24, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[84:87], v[52:55], v[120:123], v24, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[88:91], v[52:55], v[136:139], v24, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[88:91], v[56:59], v[140:143], v24, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], v[60:63], v[144:147], v24, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[84:87], v[60:63], v[128:131], v24, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[84:87], v[28:31], v[132:135], v24, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], v[28:31], v[148:151], v24, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[92:95], v[28:31], v[164:167], v25, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[92:95], v[60:63], v[160:163], v25, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[96:99], v[60:63], v[176:179], v25, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[96:99], v[28:31], v[180:183], v25, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[96:99], v[52:55], v[168:171], v25, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[92:95], v[52:55], v[152:155], v25, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[92:95], v[56:59], v[156:159], v25, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[96:99], v[56:59], v[172:175], v25, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[100:103], v[56:59], v[188:191], v26, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[100:103], v[52:55], v[184:187], v26, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[104:107], v[52:55], v[192:195], v26, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[104:107], v[56:59], v[196:199], v26, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[104:107], v[60:63], a[140:143], v26, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[100:103], v[60:63], a[132:135], v26, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[100:103], v[28:31], a[136:139], v26, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[104:107], v[28:31], a[144:147], v26, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[108:111], v[28:31], a[152:155], v27, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[108:111], v[60:63], a[148:151], v27, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[112:115], v[60:63], a[156:159], v27, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[112:115], v[28:31], a[160:163], v27, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[112:115], v[52:55], v[208:211], v27, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[108:111], v[52:55], v[200:203], v27, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[108:111], v[56:59], v[204:207], v27, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[112:115], v[56:59], v[212:215], v27, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[116:119], v[56:59], v[220:223], v252, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[116:119], v[52:55], v[216:219], v252, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[120:123], v[52:55], v[224:227], v252, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[120:123], v[56:59], v[228:231], v252, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[120:123], v[60:63], a[172:175], v252, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[116:119], v[60:63], a[164:167], v252, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[116:119], v[28:31], a[168:171], v252, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[120:123], v[28:31], a[176:179], v252, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[124:127], v[28:31], a[184:187], v253, v255 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[124:127], v[60:63], a[180:183], v253, v255 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[128:131], v[60:63], a[188:191], v253, v255 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[128:131], v[28:31], a[192:195], v253, v255 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[24:27], v13 offset:32768
		ds_read_b128 v[28:31], v13 offset:33792
		ds_read_b128 v[36:39], v13 offset:34816
		ds_read_b128 v[40:43], v13 offset:35840
		ds_read_b128 v[44:47], v13 offset:36864
		ds_read_b128 v[48:51], v13 offset:37888
		ds_read_b128 v[52:55], v13 offset:38912
		ds_read_b128 v[56:59], v13 offset:39936
		ds_read_b128 a[4:7], v13 offset:40960
		ds_read_b128 a[8:11], v13 offset:41984
		ds_read_b128 a[12:15], v13 offset:43008
		ds_read_b128 a[16:19], v13 offset:44032
		ds_read_b128 a[20:23], v13 offset:45056
		ds_read_b128 a[24:27], v13 offset:46080
		ds_read_b128 a[28:31], v13 offset:47104
		ds_read_b128 a[32:35], v13 offset:48128
		ds_read_b128 a[36:39], v13 offset:49152
		ds_read_b128 a[40:43], v13 offset:50176
		ds_read_b128 a[44:47], v13 offset:51200
		ds_read_b128 a[48:51], v13 offset:52224
		ds_read_b128 a[52:55], v13 offset:53248
		ds_read_b128 a[56:59], v13 offset:54272
		ds_read_b128 a[60:63], v13 offset:55296
		ds_read_b128 a[64:67], v13 offset:56320
		ds_read_b128 a[68:71], v13 offset:57344
		ds_read_b128 a[72:75], v13 offset:58368
		ds_read_b128 a[76:79], v13 offset:59392
		ds_read_b128 a[80:83], v13 offset:60416
		ds_read_b128 a[84:87], v13 offset:61440
		ds_read_b128 a[88:91], v13 offset:62464
		ds_read_b128 a[92:95], v13 offset:63488
		ds_read_b128 a[96:99], v13 offset:64512
		ds_read2st64_b32 v[12:13], v0 offset0:48 offset1:49
		ds_read2st64_b32 v[14:15], v0 offset0:50 offset1:51
		ds_read2st64_b32 v[60:61], v0 offset0:52 offset1:53
		ds_read2st64_b32 v[62:63], v0 offset0:54 offset1:55
		ds_read2st64_b32 v[252:253], v0 offset0:56 offset1:57
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], v[4:7], v[16:19], v12, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[24:27], v[8:11], v[32:35], v12, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[28:31], v[8:11], v[76:79], v12, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[28:31], v[4:7], v[72:75], v12, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[36:39], v[4:7], v[88:91], v13, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[36:39], v[8:11], v[92:95], v13, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[40:43], v[8:11], v[108:111], v13, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[40:43], v[4:7], v[104:107], v13, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[44:47], v[4:7], v[120:123], v14, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[44:47], v[8:11], v[124:127], v14, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[48:51], v[8:11], v[140:143], v14, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[48:51], v[4:7], v[136:139], v14, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[52:55], v[4:7], v[152:155], v15, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], v[8:11], v[156:159], v15, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], v[8:11], v[172:175], v15, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], v[4:7], v[168:171], v15, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[4:7], v[184:187], v60, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[4:7], v[8:11], v[188:191], v60, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[8:11], v[8:11], v[196:199], v60, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[8:11], v[4:7], v[192:195], v60, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[12:15], v[4:7], v[200:203], v61, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[12:15], v[8:11], v[204:207], v61, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[16:19], v[8:11], v[212:215], v61, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[16:19], v[4:7], v[208:211], v61, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[20:23], v[4:7], v[216:219], v62, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[20:23], v[8:11], v[220:223], v62, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[24:27], v[8:11], v[228:231], v62, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[24:27], v[4:7], v[224:227], v62, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[28:31], v[4:7], v[232:235], v63, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[28:31], v[8:11], v[236:239], v63, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[32:35], v[8:11], v[244:247], v63, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[32:35], v[4:7], v[240:243], v63, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[92:95], v[20:23], v[232:235], v63, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[92:95], v[248:251], v[236:239], v63, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], a[96:99], v[248:251], v[244:247], v63, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], a[96:99], v[20:23], v[240:243], v63, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[36:39], v[20:23], v[16:19], v12, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[36:39], v[248:251], v[32:35], v12, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], v[248:251], v[76:79], v12, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], v[20:23], v[72:75], v12, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[44:47], v[20:23], v[88:91], v13, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[44:47], v[248:251], v[92:95], v13, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[48:51], v[248:251], v[108:111], v13, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[48:51], v[20:23], v[104:107], v13, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[52:55], v[20:23], v[120:123], v14, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v16, v17
		v_cvt_pk_f16_f32 v1, v18, v19
		s_mov_b32 s11, s19
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen sc0 nt
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[52:55], v[248:251], v[124:127], v14, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[56:59], v[248:251], v[140:143], v14, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[56:59], v[20:23], v[136:139], v14, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[60:63], v[20:23], v[152:155], v15, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[60:63], v[248:251], v[156:159], v15, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[64:67], v[248:251], v[172:175], v15, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[64:67], v[20:23], v[168:171], v15, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[68:71], v[20:23], v[184:187], v60, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[68:71], v[248:251], v[188:191], v60, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[72:75], v[248:251], v[196:199], v60, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[72:75], v[20:23], v[192:195], v60, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[76:79], v[20:23], v[200:203], v61, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[76:79], v[248:251], v[204:207], v61, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[80:83], v[248:251], v[212:215], v61, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[80:83], v[20:23], v[208:211], v61, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[84:87], v[20:23], v[216:219], v62, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[84:87], v[248:251], v[220:223], v62, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[88:91], v[248:251], v[228:231], v62, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[88:91], v[20:23], v[224:227], v62, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v32, v33
		v_cvt_pk_f16_f32 v1, v34, v35
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s15 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s15 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s15 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s15 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s4 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s4 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s4 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s4 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v216, v217
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s12 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s12 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v224, v225
		v_cvt_pk_f16_f32 v1, v226, v227
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s12 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v228, v229
		v_cvt_pk_f16_f32 v1, v230, v231
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s12 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v232, v233
		v_cvt_pk_f16_f32 v1, v234, v235
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s0 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v236, v237
		v_cvt_pk_f16_f32 v1, v238, v239
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s0 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v240, v241
		v_cvt_pk_f16_f32 v1, v242, v243
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s0 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v244, v245
		v_cvt_pk_f16_f32 v1, v246, v247
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s0 offen offset:2560 sc0 nt
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[24:27], a[0:3], v[64:67], v12, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[24:27], a[196:199], v[68:71], v12, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[28:31], a[196:199], v[84:87], v12, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], a[0:3], v[80:83], v12, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[36:39], a[0:3], v[96:99], v13, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[36:39], a[196:199], v[100:103], v13, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[40:43], a[196:199], v[116:119], v13, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[40:43], a[0:3], v[112:115], v13, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[44:47], a[0:3], v[128:131], v14, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], a[196:199], v[132:135], v14, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[48:51], a[196:199], v[148:151], v14, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[48:51], a[0:3], v[144:147], v14, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], a[0:3], v[160:163], v15, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], a[196:199], v[164:167], v15, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], a[196:199], v[180:183], v15, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], a[0:3], v[176:179], v15, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[4:7], a[0:3], a[132:135], v60, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[4:7], a[196:199], a[136:139], v60, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[8:11], a[196:199], a[144:147], v60, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[8:11], a[0:3], a[140:143], v60, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[12:15], a[0:3], a[148:151], v61, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[12:15], a[196:199], a[152:155], v61, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[16:19], a[196:199], a[160:163], v61, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[16:19], a[0:3], a[156:159], v61, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[20:23], a[0:3], a[164:167], v62, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[20:23], a[196:199], a[168:171], v62, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[24:27], a[196:199], a[176:179], v62, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[24:27], a[0:3], a[172:175], v62, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[28:31], a[0:3], a[180:183], v63, v253 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[28:31], a[196:199], a[184:187], v63, v253 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[32:35], a[196:199], a[192:195], v63, v253 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[0:3], a[188:191], v63, v253 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[92:95], a[200:203], a[180:183], v63, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[92:95], a[204:207], a[184:187], v63, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[96:99], a[204:207], a[192:195], v63, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[96:99], a[200:203], a[188:191], v63, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[200:203], v[64:67], v12, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[204:207], v[68:71], v12, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[204:207], v[84:87], v12, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[200:203], v[80:83], v12, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[44:47], a[200:203], v[96:99], v13, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[44:47], a[204:207], v[100:103], v13, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[48:51], a[204:207], v[116:119], v13, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[48:51], a[200:203], v[112:115], v13, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[52:55], a[200:203], v[128:131], v14, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v64, v65
		v_cvt_pk_f16_f32 v1, v66, v67
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:1024 sc0 nt
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[52:55], a[204:207], v[132:135], v14, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[56:59], a[204:207], v[148:151], v14, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[56:59], a[200:203], v[144:147], v14, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[60:63], a[200:203], v[160:163], v15, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[60:63], a[204:207], v[164:167], v15, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[64:67], a[204:207], v[180:183], v15, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[64:67], a[200:203], v[176:179], v15, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[68:71], a[200:203], a[132:135], v60, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[68:71], a[204:207], a[136:139], v60, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[72:75], a[204:207], a[144:147], v60, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[72:75], a[200:203], a[140:143], v60, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[76:79], a[200:203], a[148:151], v61, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[76:79], a[204:207], a[152:155], v61, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[80:83], a[204:207], a[160:163], v61, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[80:83], a[200:203], a[156:159], v61, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[84:87], a[200:203], a[164:167], v62, v253 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[84:87], a[204:207], a[168:171], v62, v253 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[88:91], a[204:207], a[176:179], v62, v253 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[88:91], a[200:203], a[172:175], v62, v253 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v2, s[8:11], 0 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s32 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s7 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v2, s[8:11], s6 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v1, a133
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v1, a135
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s15 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v1, a137
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v1, a139
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s15 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v1, a141
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v1, a143
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s15 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v1, a145
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v1, a147
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s15 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v1, a149
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v1, a151
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s4 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v1, a153
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v1, a155
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s4 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v1, a157
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v1, a159
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s4 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v1, a161
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v1, a163
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s4 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v1, a165
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v1, a167
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s12 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v1, a169
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v1, a171
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s12 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v1, a173
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v1, a175
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s12 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v1, a177
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v1, a179
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s12 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v1, a181
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v1, a183
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s0 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v1, a185
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v1, a187
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s0 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v1, a189
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v1, a191
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s0 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v1, a193
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v1, a195
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[8:11], s0 offen offset:3584 sc0 nt
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
		.amdhsa_next_free_vgpr 464
		.amdhsa_next_free_sgpr 53
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 208
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 53
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
    .sgpr_count:     53
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     464
    .agpr_count:     208
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 78
    wave.regalloc.agpr.dwords: 305
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
