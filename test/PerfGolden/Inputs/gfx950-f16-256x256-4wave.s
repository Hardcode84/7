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
		s_mov_b32 s12, s2
		s_mov_b32 s13, s3
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s14
		s_mov_b32 s3, s15
		s_lshl_b32 s4, s10, 17
		s_lshr_b32 s5, s9, 3
		s_lshl_b32 s5, s5, 22
		s_add_i32 s4, s4, s5
		s_and_b32 s8, s9, 7
		s_lshl_b32 s8, s8, 24
		s_add_i32 s4, s4, s8
		v_readfirstlane_b32 s9, v0
		s_lshr_b32 s9, s9, 6
		s_lshl_b32 s11, s9, 10
		s_mov_b32 m0, s11
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 14, v2
		v_lshl_add_u32 v2, s9, 18, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s16, s5, s8
		v_add_u32_e32 v3, s16, v2
		buffer_load_dwordx4 v3, s[12:15], 0 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s16, s5, 0x100000
		s_add_i32 s16, s16, s8
		v_add_u32_e32 v8, s16, v2
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_lshrrev_b32_e32 v8, 6, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s16, s5, 0x200000
		v_add_u32_e32 v9, s8, v2
		v_add_u32_e32 v10, s16, v9
		buffer_load_dwordx4 v10, s[12:15], 0 offen lds
		v_add3_u32 v10, s5, 64, v9
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s16, s5, 0x300000
		v_add_u32_e32 v9, s16, v9
		buffer_load_dwordx4 v9, s[12:15], 0 offen lds
		v_add_u32_e32 v9, s8, v2
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v9, s5, v9
		buffer_load_dwordx4 v10, s[12:15], 0 offen lds
		v_add_u32_e32 v10, 0x100040, v9
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v11, 0x200040, v9
		buffer_load_dwordx4 v10, s[12:15], 0 offen lds
		v_add_u32_e32 v9, 0x300040, v9
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s16, 0x7000
		buffer_load_dwordx4 v11, s[12:15], 0 offen lds
		s_mov_b32 s17, 0x6000
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s10, s10, 22
		v_add_u32_e32 v10, s10, v2
		v_add_u32_e32 v11, s10, v2
		v_add_u32_e32 v12, 0x100000, v11
		v_add_u32_e32 v13, 0x200000, v11
		v_add_u32_e32 v11, 0x300000, v11
		v_add3_u32 v14, s10, 64, v2
		v_add_u32_e32 v15, s10, v2
		v_add_u32_e32 v16, 0x100040, v15
		v_add_u32_e32 v17, 0x200040, v15
		v_add_u32_e32 v15, 0x300040, v15
		buffer_load_dwordx4 v9, s[12:15], 0 offen lds
		v_add_u32_e32 v9, s8, v2
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v9, s5, v9
		v_add_u32_e32 v18, 0x200080, v9
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_add_u32_e32 v19, 0x300080, v9
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v9, 0xc0, v9
		v_add_u32_e32 v20, s8, v2
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_add_u32_e32 v12, s5, v20
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v20, 0x1000c0, v12
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		v_add_u32_e32 v13, 0x2000c0, v12
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v21, 3, v1
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_add_u32_e32 v11, 0x3000c0, v12
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v12, s10, v2
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_add_u32_e32 v14, 0x200080, v12
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s18, 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_add_u32_e32 v16, 0x300080, v12
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v8, 1, v8
		v_add_u32_e32 v22, s10, v2
		v_lshrrev_b32_e32 v1, 4, v1
		v_lshrrev_b32_e32 v23, 7, v0
		v_lshlrev_b32_e32 v23, 13, v23
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v24, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v1, v0, 3 bitop3:0x78
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v0, 4, v0
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v1, 13, v8
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_add_u32_e32 v8, 0x100, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s19, s5, 0x80
		s_add_i32 s19, s19, s8
		v_add_u32_e32 v15, s19, v2
		buffer_load_dwordx4 v15, s[12:15], 0 offen lds
		v_add_u32_e32 v15, 0x100100, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s5, 0x100080
		s_add_i32 s5, s5, s8
		v_add_u32_e32 v17, s5, v2
		buffer_load_dwordx4 v17, s[12:15], 0 offen lds
		v_add_u32_e32 v17, 0x200100, v3
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v25, 0x300100, v3
		buffer_load_dwordx4 v18, s[12:15], 0 offen lds
		v_add_u32_e32 v18, 0x140, v3
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v26, 0x100140, v3
		buffer_load_dwordx4 v19, s[12:15], 0 offen lds
		v_add_u32_e32 v19, 0x200140, v3
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v27, 0x300140, v3
		buffer_load_dwordx4 v9, s[12:15], 0 offen lds
		v_add_u32_e32 v3, 0x100, v10
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v9, 0x100100, v10
		v_add_u32_e32 v28, 0x200100, v10
		v_add_u32_e32 v29, 0x300100, v10
		v_add_u32_e32 v30, 0x140, v10
		v_add_u32_e32 v31, 0x100140, v10
		v_add_u32_e32 v32, 0x200140, v10
		v_add_u32_e32 v33, 0x300140, v10
		buffer_load_dwordx4 v20, s[12:15], 0 offen lds
		s_add_u32 s20, s6, s4
		s_addc_u32 s21, s7, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s22, 0x20000
		buffer_load_dwordx4 v13, s[12:15], 0 offen lds
		s_mov_b32 s4, 0x5000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s10, 0x80
		v_add_u32_e32 v10, s5, v2
		buffer_load_dwordx4 v11, s[12:15], 0 offen lds
		s_mov_b32 s5, 0x4000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s6, s10, 0x100080
		v_add_u32_e32 v2, s6, v2
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s6, 0x3000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s7, 0x2000
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s8, 0x1000
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v2, 0xc0, v12
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_add_u32_e32 v10, 0x1000c0, v22
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v11, 0x2000c0, v22
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_add_u32_e32 v12, 0x3000c0, v22
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v13, v23, v24, v0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add3_u32 v2, v24, v1, v0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[0:3], v13
		ds_read_b128 a[4:7], v13 offset:1024
		ds_read_b128 a[8:11], v13 offset:2048
		ds_read_b128 a[12:15], v13 offset:3072
		ds_read_b128 a[16:19], v13 offset:4096
		ds_read_b128 a[20:23], v13 offset:5120
		ds_read_b128 a[24:27], v13 offset:6144
		ds_read_b128 a[28:31], v13 offset:7168
		ds_read_b128 a[32:35], v13 offset:16384
		ds_read_b128 a[36:39], v13 offset:17408
		ds_read_b128 a[40:43], v13 offset:18432
		ds_read_b128 a[44:47], v13 offset:19456
		ds_read_b128 a[48:51], v13 offset:20480
		ds_read_b128 a[52:55], v13 offset:21504
		ds_read_b128 a[56:59], v13 offset:22528
		ds_read_b128 a[60:63], v13 offset:23552
		ds_read_b128 a[64:67], v2 offset:32768
		ds_read_b128 a[68:71], v2 offset:33792
		ds_read_b128 a[72:75], v2 offset:34816
		ds_read_b128 a[76:79], v2 offset:35840
		ds_read_b128 a[80:83], v2 offset:36864
		ds_read_b128 a[84:87], v2 offset:37888
		ds_read_b128 a[88:91], v2 offset:38912
		ds_read_b128 a[92:95], v2 offset:39936
		ds_read_b128 a[96:99], v2 offset:49152
		ds_read_b128 a[100:103], v2 offset:50176
		ds_read_b128 a[104:107], v2 offset:51200
		ds_read_b128 a[108:111], v2 offset:52224
		ds_read_b128 a[112:115], v2 offset:53248
		ds_read_b128 a[116:119], v2 offset:54272
		ds_read_b128 a[120:123], v2 offset:55296
		ds_read_b128 a[124:127], v2 offset:56320
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
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
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
	.p2align	2
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_mov_b32 m0, s11
		s_lshl_b32 s10, s18, 7
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v8, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[4:7], a[0:3], a[64:67], v[4:7]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[68:71], v[52:55]
		buffer_load_dwordx4 v15, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[72:75], v[48:51]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[76:79], v[44:47]
		buffer_load_dwordx4 v17, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[80:83], v[40:43]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[84:87], v[36:39]
		buffer_load_dwordx4 v25, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[88:91], v[56:59]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[60:63], a[0:3], a[92:95], v[60:63]
		buffer_load_dwordx4 v18, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[92:95], a[4:7], a[92:95], v[92:95]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[64:67], v[64:67]
		buffer_load_dwordx4 v26, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[68:71], v[68:71]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[72:75], v[72:75]
		buffer_load_dwordx4 v19, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[76:79], v[76:79]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[80:83], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[84:87], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[88:91], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[88:91], v[120:123]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[64:67], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[68:71], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[72:75], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[76:79], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[80:83], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[84:87], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], a[8:11], a[92:95], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[12:15], a[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[68:71], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[72:75], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[76:79], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[84:87], v[148:151]
		buffer_load_dwordx4 v27, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[88:91], v[152:155]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[184:187], a[16:19], a[88:91], v[184:187]
		buffer_load_dwordx4 v3, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[160:163], a[16:19], a[64:67], v[160:163]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[164:167], a[16:19], a[68:71], v[164:167]
		buffer_load_dwordx4 v9, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[168:171], a[16:19], a[72:75], v[168:171]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[172:175], a[16:19], a[76:79], v[172:175]
		buffer_load_dwordx4 v28, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], a[16:19], a[80:83], v[176:179]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[180:183], a[16:19], a[84:87], v[180:183]
		buffer_load_dwordx4 v29, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[188:191], a[16:19], a[92:95], v[188:191]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[220:223], a[20:23], a[92:95], v[220:223]
		buffer_load_dwordx4 v30, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[192:195], a[20:23], a[64:67], v[192:195]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[196:199], a[20:23], a[68:71], v[196:199]
		buffer_load_dwordx4 v31, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[200:203], a[20:23], a[72:75], v[200:203]
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[204:207], a[20:23], a[76:79], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[20:23], a[80:83], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[20:23], a[84:87], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[20:23], a[88:91], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[24:27], a[88:91], v[248:251]
		v_mfma_f32_16x16x32_f16 v[224:227], a[24:27], a[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[24:27], a[68:71], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[24:27], a[72:75], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[24:27], a[76:79], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[24:27], a[80:83], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[24:27], a[84:87], v[244:247]
		v_mfma_f32_16x16x32_f16 a[128:131], a[24:27], a[92:95], a[128:131]
		v_mfma_f32_16x16x32_f16 v[252:255], a[28:31], a[92:95], v[252:255]
		v_mfma_f32_16x16x32_f16 a[132:135], a[28:31], a[64:67], a[132:135]
		v_mfma_f32_16x16x32_f16 a[136:139], a[28:31], a[68:71], a[136:139]
		v_mfma_f32_16x16x32_f16 a[140:143], a[28:31], a[72:75], a[140:143]
		v_mfma_f32_16x16x32_f16 a[144:147], a[28:31], a[76:79], a[144:147]
		v_mfma_f32_16x16x32_f16 a[148:151], a[28:31], a[80:83], a[148:151]
		buffer_load_dwordx4 v32, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 a[152:155], a[28:31], a[84:87], a[152:155]
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s11, s11, 0x10000
		buffer_load_dwordx4 v33, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 a[156:159], a[28:31], a[88:91], a[156:159]
		v_mfma_f32_16x16x32_f16 v[4:7], a[32:35], a[96:99], v[4:7]
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[100:103], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], a[104:107], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], a[108:111], v[44:47]
		s_add_i32 s18, s18, 1
		s_and_b32 s10, s18, 1
		s_lshl_b32 s10, s10, 16
		v_add_u32_e32 v2, s10, v23
		v_add3_u32 v2, v2, v24, v0
		v_add_u32_e32 v10, s10, v24
		v_add3_u32 v10, v10, v1, v0
		s_and_b32 s11, s11, 0x1ffff
		s_cmp_lt_i32 s18, 0x7e
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[0:3], v2
		v_mfma_f32_16x16x32_f16 v[40:43], a[32:35], a[112:115], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], a[32:35], a[116:119], v[36:39]
		v_mfma_f32_16x16x32_f16 v[56:59], a[32:35], a[120:123], v[56:59]
		ds_read_b128 a[64:67], v10 offset:32768
		v_mfma_f32_16x16x32_f16 v[60:63], a[32:35], a[124:127], v[60:63]
		ds_read_b128 a[32:35], v2 offset:16384
		v_mfma_f32_16x16x32_f16 v[64:67], a[36:39], a[96:99], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[36:39], a[100:103], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[36:39], a[104:107], v[72:75]
		ds_read_b128 a[4:7], v2 offset:1024
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], a[108:111], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], a[112:115], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[116:119], v[84:87]
		ds_read_b128 a[68:71], v10 offset:33792
		v_mfma_f32_16x16x32_f16 v[88:91], a[36:39], a[120:123], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[36:39], a[124:127], v[92:95]
		ds_read_b128 a[36:39], v2 offset:17408
		v_mfma_f32_16x16x32_f16 v[96:99], a[40:43], a[96:99], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[40:43], a[100:103], v[100:103]
		ds_read_b128 a[8:11], v2 offset:2048
		v_mfma_f32_16x16x32_f16 v[104:107], a[40:43], a[104:107], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], a[108:111], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], a[112:115], v[112:115]
		ds_read_b128 a[72:75], v10 offset:34816
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[116:119], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], a[40:43], a[120:123], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], a[40:43], a[124:127], v[124:127]
		ds_read_b128 a[40:43], v2 offset:18432
		v_mfma_f32_16x16x32_f16 v[128:131], a[44:47], a[96:99], v[128:131]
		ds_read_b128 a[12:15], v2 offset:3072
		v_mfma_f32_16x16x32_f16 v[132:135], a[44:47], a[100:103], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[44:47], a[104:107], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], a[108:111], v[140:143]
		ds_read_b128 a[76:79], v10 offset:35840
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], a[112:115], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[116:119], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[44:47], a[120:123], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[44:47], a[124:127], v[156:159]
		ds_read_b128 a[16:19], v2 offset:4096
		ds_read_b128 a[44:47], v2 offset:19456
		v_mfma_f32_16x16x32_f16 v[160:163], a[48:51], a[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[48:51], a[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[48:51], a[104:107], v[168:171]
		ds_read_b128 a[80:83], v10 offset:36864
		v_mfma_f32_16x16x32_f16 v[172:175], a[48:51], a[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[48:51], a[112:115], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[48:51], a[116:119], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], a[48:51], a[120:123], v[184:187]
		ds_read_b128 a[20:23], v2 offset:5120
		v_mfma_f32_16x16x32_f16 v[188:191], a[48:51], a[124:127], v[188:191]
		ds_read_b128 a[48:51], v2 offset:20480
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[100:103], v[196:199]
		ds_read_b128 a[84:87], v10 offset:37888
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[112:115], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[116:119], v[212:215]
		ds_read_b128 a[24:27], v2 offset:6144
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[120:123], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[124:127], v[220:223]
		ds_read_b128 a[52:55], v2 offset:21504
		v_mfma_f32_16x16x32_f16 v[224:227], a[56:59], a[96:99], v[224:227]
		ds_read_b128 a[88:91], v10 offset:38912
		v_mfma_f32_16x16x32_f16 v[228:231], a[56:59], a[100:103], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[56:59], a[104:107], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[56:59], a[108:111], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[56:59], a[112:115], v[240:243]
		ds_read_b128 a[28:31], v2 offset:7168
		v_mfma_f32_16x16x32_f16 v[244:247], a[56:59], a[116:119], v[244:247]
		v_mfma_f32_16x16x32_f16 v[248:251], a[56:59], a[120:123], v[248:251]
		v_mfma_f32_16x16x32_f16 a[128:131], a[56:59], a[124:127], a[128:131]
		ds_read_b128 a[92:95], v10 offset:39936
		ds_read_b128 a[56:59], v2 offset:22528
		v_mfma_f32_16x16x32_f16 a[132:135], a[60:63], a[96:99], a[132:135]
		ds_read_b128 a[96:99], v10 offset:49152
		v_mfma_f32_16x16x32_f16 a[136:139], a[60:63], a[100:103], a[136:139]
		ds_read_b128 a[100:103], v10 offset:50176
		v_mfma_f32_16x16x32_f16 a[140:143], a[60:63], a[104:107], a[140:143]
		ds_read_b128 a[104:107], v10 offset:51200
		v_mfma_f32_16x16x32_f16 a[144:147], a[60:63], a[108:111], a[144:147]
		ds_read_b128 a[108:111], v10 offset:52224
		v_mfma_f32_16x16x32_f16 a[148:151], a[60:63], a[112:115], a[148:151]
		ds_read_b128 a[112:115], v10 offset:53248
		v_mfma_f32_16x16x32_f16 a[152:155], a[60:63], a[116:119], a[152:155]
		ds_read_b128 a[116:119], v10 offset:54272
		v_mfma_f32_16x16x32_f16 a[156:159], a[60:63], a[120:123], a[156:159]
		ds_read_b128 a[120:123], v10 offset:55296
		v_mfma_f32_16x16x32_f16 v[252:255], a[60:63], a[124:127], v[252:255]
		ds_read_b128 a[124:127], v10 offset:56320
		ds_read_b128 a[60:63], v2 offset:23552
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], a[0:3], a[64:67], v[4:7]
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[68:71], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[72:75], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[76:79], v[44:47]
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[80:83], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[84:87], v[36:39]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[88:91], v[56:59]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[60:63], a[0:3], a[92:95], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[4:7], a[92:95], v[92:95]
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[64:67], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[68:71], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[72:75], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[76:79], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[80:83], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[84:87], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[88:91], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[88:91], v[120:123]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[64:67], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[68:71], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[72:75], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[76:79], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[80:83], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[84:87], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], a[8:11], a[92:95], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[12:15], a[92:95], v[156:159]
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[64:67], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[68:71], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[72:75], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[76:79], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[80:83], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[84:87], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[88:91], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[16:19], a[88:91], v[184:187]
		v_mfma_f32_16x16x32_f16 v[160:163], a[16:19], a[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[16:19], a[68:71], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[16:19], a[72:75], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[16:19], a[76:79], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[16:19], a[80:83], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[16:19], a[84:87], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], a[16:19], a[92:95], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[20:23], a[92:95], v[220:223]
		v_mfma_f32_16x16x32_f16 v[192:195], a[20:23], a[64:67], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[20:23], a[68:71], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[20:23], a[72:75], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[20:23], a[76:79], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[20:23], a[80:83], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[20:23], a[84:87], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[20:23], a[88:91], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[24:27], a[88:91], v[248:251]
		v_mfma_f32_16x16x32_f16 v[224:227], a[24:27], a[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[24:27], a[68:71], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[24:27], a[72:75], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[24:27], a[76:79], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[24:27], a[80:83], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[24:27], a[84:87], v[244:247]
		v_mfma_f32_16x16x32_f16 a[128:131], a[24:27], a[92:95], a[128:131]
		v_mfma_f32_16x16x32_f16 v[252:255], a[28:31], a[92:95], v[252:255]
		v_mfma_f32_16x16x32_f16 a[132:135], a[28:31], a[64:67], a[132:135]
		v_mfma_f32_16x16x32_f16 a[136:139], a[28:31], a[68:71], a[136:139]
		v_mfma_f32_16x16x32_f16 a[140:143], a[28:31], a[72:75], a[140:143]
		v_mfma_f32_16x16x32_f16 a[144:147], a[28:31], a[76:79], a[144:147]
		v_mfma_f32_16x16x32_f16 a[148:151], a[28:31], a[80:83], a[148:151]
		v_mfma_f32_16x16x32_f16 a[152:155], a[28:31], a[84:87], a[152:155]
		v_mfma_f32_16x16x32_f16 a[156:159], a[28:31], a[88:91], a[156:159]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[4:7], a[32:35], a[96:99], v[4:7]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[100:103], v[52:55]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], a[104:107], v[48:51]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], a[108:111], v[44:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[40:43], a[32:35], a[112:115], v[40:43]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[36:39], a[32:35], a[116:119], v[36:39]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[56:59], a[32:35], a[120:123], v[56:59]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[60:63], a[32:35], a[124:127], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[36:39], a[124:127], v[92:95]
		v_mfma_f32_16x16x32_f16 v[64:67], a[36:39], a[96:99], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[36:39], a[100:103], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[36:39], a[104:107], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], a[108:111], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], a[112:115], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[116:119], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[36:39], a[120:123], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[40:43], a[120:123], v[120:123]
		v_mfma_f32_16x16x32_f16 v[96:99], a[40:43], a[96:99], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[40:43], a[100:103], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[40:43], a[104:107], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], a[108:111], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], a[112:115], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[116:119], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], a[40:43], a[124:127], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[44:47], a[124:127], v[156:159]
		v_mfma_f32_16x16x32_f16 v[128:131], a[44:47], a[96:99], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[44:47], a[100:103], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[44:47], a[104:107], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], a[108:111], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], a[112:115], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[116:119], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[44:47], a[120:123], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[48:51], a[120:123], v[184:187]
		v_mfma_f32_16x16x32_f16 v[160:163], a[48:51], a[96:99], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[48:51], a[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[48:51], a[104:107], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[48:51], a[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[48:51], a[112:115], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[48:51], a[116:119], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], a[48:51], a[124:127], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[124:127], v[220:223]
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[100:103], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[112:115], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[116:119], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[120:123], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[56:59], a[120:123], v[248:251]
		v_mfma_f32_16x16x32_f16 v[224:227], a[56:59], a[96:99], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[56:59], a[100:103], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[56:59], a[104:107], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[56:59], a[108:111], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[56:59], a[112:115], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[56:59], a[116:119], v[244:247]
		v_mfma_f32_16x16x32_f16 a[128:131], a[56:59], a[124:127], a[128:131]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[252:255], a[60:63], a[124:127], v[252:255]
		v_mfma_f32_16x16x32_f16 a[132:135], a[60:63], a[96:99], a[132:135]
		v_mfma_f32_16x16x32_f16 a[136:139], a[60:63], a[100:103], a[136:139]
		v_mfma_f32_16x16x32_f16 a[140:143], a[60:63], a[104:107], a[140:143]
		v_mfma_f32_16x16x32_f16 a[144:147], a[60:63], a[108:111], a[144:147]
		v_mfma_f32_16x16x32_f16 a[148:151], a[60:63], a[112:115], a[148:151]
		v_mfma_f32_16x16x32_f16 a[152:155], a[60:63], a[116:119], a[152:155]
		v_mfma_f32_16x16x32_f16 a[156:159], a[60:63], a[120:123], a[156:159]
		v_add_u32_e32 v2, 0x10000, v23
		v_add3_u32 v2, v2, v24, v0
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[12:15], v2 offset:1024
		ds_read_b128 v[16:19], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 a[0:3], v2 offset:4096
		ds_read_b128 a[4:7], v2 offset:5120
		ds_read_b128 a[8:11], v2 offset:6144
		ds_read_b128 a[12:15], v2 offset:7168
		ds_read_b128 a[16:19], v2 offset:16384
		ds_read_b128 a[20:23], v2 offset:17408
		ds_read_b128 a[24:27], v2 offset:18432
		ds_read_b128 a[28:31], v2 offset:19456
		ds_read_b128 a[32:35], v2 offset:20480
		ds_read_b128 a[36:39], v2 offset:21504
		ds_read_b128 a[40:43], v2 offset:22528
		ds_read_b128 a[44:47], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v24
		v_add3_u32 v0, v2, v1, v0
		ds_read_b128 a[48:51], v0 offset:32768
		ds_read_b128 a[52:55], v0 offset:33792
		ds_read_b128 a[56:59], v0 offset:34816
		ds_read_b128 a[60:63], v0 offset:35840
		ds_read_b128 a[64:67], v0 offset:36864
		ds_read_b128 a[68:71], v0 offset:37888
		ds_read_b128 a[72:75], v0 offset:38912
		ds_read_b128 v[24:27], v0 offset:39936
		ds_read_b128 a[76:79], v0 offset:49152
		ds_read_b128 a[80:83], v0 offset:50176
		ds_read_b128 a[84:87], v0 offset:51200
		ds_read_b128 a[88:91], v0 offset:52224
		ds_read_b128 a[92:95], v0 offset:53248
		ds_read_b128 a[96:99], v0 offset:54272
		ds_read_b128 a[100:103], v0 offset:55296
		ds_read_b128 v[32:35], v0 offset:56320
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[8:11], a[48:51], v[4:7]
		v_lshl_add_u32 v0, s9, 15, v21
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[52:55], v[52:55]
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[56:59], v[48:51]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[60:63], v[44:47]
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[64:67], v[40:43]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[68:71], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[56:59], v[8:11], a[72:75], v[56:59]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[60:63], v[8:11], v[24:27], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], v[12:15], v[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[48:51], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[52:55], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[56:59], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[60:63], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[64:67], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[68:71], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[12:15], a[72:75], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], a[72:75], v[120:123]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[48:51], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[52:55], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[68:71], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], v[24:27], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], v[28:31], v[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[128:131], v[28:31], a[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[28:31], a[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[28:31], a[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[28:31], a[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[28:31], a[64:67], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[28:31], a[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[28:31], a[72:75], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[0:3], a[72:75], v[184:187]
		v_mfma_f32_16x16x32_f16 v[160:163], a[0:3], a[48:51], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[0:3], a[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[0:3], a[56:59], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[0:3], a[60:63], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[0:3], a[64:67], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[0:3], a[68:71], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], a[0:3], v[24:27], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[4:7], v[24:27], v[220:223]
		v_mfma_f32_16x16x32_f16 v[192:195], a[4:7], a[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[4:7], a[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[4:7], a[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[4:7], a[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[4:7], a[64:67], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[4:7], a[68:71], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[4:7], a[72:75], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[8:11], a[72:75], v[248:251]
		v_mfma_f32_16x16x32_f16 v[224:227], a[8:11], a[48:51], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[8:11], a[52:55], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[8:11], a[56:59], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[8:11], a[60:63], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[8:11], a[64:67], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[8:11], a[68:71], v[244:247]
		v_mfma_f32_16x16x32_f16 a[128:131], a[8:11], v[24:27], a[128:131]
		v_mfma_f32_16x16x32_f16 v[252:255], a[12:15], v[24:27], v[252:255]
		v_mfma_f32_16x16x32_f16 a[132:135], a[12:15], a[48:51], a[132:135]
		v_mfma_f32_16x16x32_f16 a[136:139], a[12:15], a[52:55], a[136:139]
		v_mfma_f32_16x16x32_f16 a[140:143], a[12:15], a[56:59], a[140:143]
		v_mfma_f32_16x16x32_f16 a[144:147], a[12:15], a[60:63], a[144:147]
		v_mfma_f32_16x16x32_f16 a[148:151], a[12:15], a[64:67], a[148:151]
		v_mfma_f32_16x16x32_f16 a[152:155], a[12:15], a[68:71], a[152:155]
		v_mfma_f32_16x16x32_f16 a[156:159], a[12:15], a[72:75], a[156:159]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[4:7], a[16:19], a[76:79], v[4:7]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[52:55], a[16:19], a[80:83], v[52:55]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[48:51], a[16:19], a[84:87], v[48:51]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[44:47], a[16:19], a[88:91], v[44:47]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[40:43], a[16:19], a[92:95], v[40:43]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[36:39], a[16:19], a[96:99], v[36:39]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[56:59], a[16:19], a[100:103], v[56:59]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[60:63], a[16:19], v[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[20:23], v[32:35], v[92:95]
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_mfma_f32_16x16x32_f16 v[64:67], a[20:23], a[76:79], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[20:23], a[80:83], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[20:23], a[84:87], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[20:23], a[88:91], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[20:23], a[92:95], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[20:23], a[96:99], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[20:23], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[24:27], a[100:103], v[120:123]
		v_mfma_f32_16x16x32_f16 v[96:99], a[24:27], a[76:79], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[24:27], a[80:83], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[24:27], a[84:87], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[24:27], a[88:91], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[24:27], a[92:95], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[24:27], a[96:99], v[116:119]
		v_mfma_f32_16x16x32_f16 v[124:127], a[24:27], v[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[28:31], v[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[128:131], a[28:31], a[76:79], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[28:31], a[80:83], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[28:31], a[84:87], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[28:31], a[88:91], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[28:31], a[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[28:31], a[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[28:31], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[32:35], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], a[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], a[80:83], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[84:87], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[88:91], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[92:95], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[96:99], v[180:183]
		v_mfma_f32_16x16x32_f16 v[188:191], a[32:35], v[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[36:39], v[32:35], v[220:223]
		v_mfma_f32_16x16x32_f16 v[192:195], a[36:39], a[76:79], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[36:39], a[80:83], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[36:39], a[84:87], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[36:39], a[88:91], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[36:39], a[92:95], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[36:39], a[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[36:39], a[100:103], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[40:43], a[100:103], v[248:251]
		v_mfma_f32_16x16x32_f16 v[224:227], a[40:43], a[76:79], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[40:43], a[80:83], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[40:43], a[84:87], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[40:43], a[88:91], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[40:43], a[92:95], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[40:43], a[96:99], v[244:247]
		v_mfma_f32_16x16x32_f16 a[128:131], a[40:43], v[32:35], a[128:131]
		v_mfma_f32_16x16x32_f16 v[252:255], a[44:47], v[32:35], v[252:255]
		v_mfma_f32_16x16x32_f16 a[132:135], a[44:47], a[76:79], a[132:135]
		v_mfma_f32_16x16x32_f16 a[136:139], a[44:47], a[80:83], a[136:139]
		v_mfma_f32_16x16x32_f16 a[140:143], a[44:47], a[84:87], a[140:143]
		v_mfma_f32_16x16x32_f16 a[144:147], a[44:47], a[88:91], a[144:147]
		v_mfma_f32_16x16x32_f16 a[148:151], a[44:47], a[92:95], a[148:151]
		v_mfma_f32_16x16x32_f16 a[152:155], a[44:47], a[96:99], a[152:155]
		v_mfma_f32_16x16x32_f16 a[156:159], a[44:47], a[100:103], a[156:159]
		s_mov_b32 s23, s15
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:512
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:1024
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:1536
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:2048
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:2560
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:3072
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:3584
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:512
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:1024
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:1536
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:2048
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:2560
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:3072
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:3584
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:512
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:1024
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:1536
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:2048
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:2560
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:3072
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:3584
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:512
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:1024
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:1536
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:2048
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:2560
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:3072
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:3584
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:512
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:1024
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:1536
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:2048
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:2560
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:3072
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s4 offen offset:3584
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:512
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:1024
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:1536
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:2048
		v_cvt_pk_f16_f32 v2, v244, v245
		v_cvt_pk_f16_f32 v3, v246, v247
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:2560
		v_cvt_pk_f16_f32 v2, v248, v249
		v_cvt_pk_f16_f32 v3, v250, v251
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:3072
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s17 offen offset:3584
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:512
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:1024
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:1536
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:2048
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:2560
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s16 offen offset:3072
		v_cvt_pk_f16_f32 v2, v252, v253
		v_cvt_pk_f16_f32 v3, v254, v255
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:3584
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
		.amdhsa_next_free_vgpr 416
		.amdhsa_next_free_sgpr 24
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 160
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 24
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
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     24
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     416
    .agpr_count:     160
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 67
    wave.regalloc.agpr.dwords: 264
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
