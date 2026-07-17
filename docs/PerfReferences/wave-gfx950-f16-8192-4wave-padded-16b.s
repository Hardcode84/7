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
		s_mul_i32 s11, 0x410, s9
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
		v_lshrrev_b32_e32 v4, 6, v0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s16, s5, 0x100000
		s_add_i32 s16, s16, s8
		v_add_u32_e32 v5, s16, v2
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, s8, v2
		s_add_i32 m0, s11, 0x2080
		s_add_i32 s16, s5, 0x200000
		v_add_u32_e32 v6, s16, v5
		v_add3_u32 v7, s5, 64, v5
		buffer_load_dwordx4 v6, s[12:15], 0 offen lds
		v_add_u32_e32 v6, s8, v2
		s_add_i32 m0, s11, 0x30c0
		s_add_i32 s16, s5, 0x300000
		v_add_u32_e32 v5, s16, v5
		v_add_u32_e32 v6, s5, v6
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, 0x100040, v6
		s_add_i32 m0, s11, 0x4100
		v_add_u32_e32 v8, 0x200040, v6
		v_add_u32_e32 v6, 0x300040, v6
		buffer_load_dwordx4 v7, s[12:15], 0 offen lds
		v_add_u32_e32 v7, s8, v2
		s_add_i32 m0, s11, 0x5140
		v_add_u32_e32 v7, s5, v7
		v_add_u32_e32 v9, 0x200080, v7
		v_add_u32_e32 v10, 0x300080, v7
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, 0xc0, v7
		s_add_i32 m0, s11, 0x6180
		v_add_u32_e32 v7, s8, v2
		v_add_u32_e32 v7, s5, v7
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_add_u32_e32 v8, 0x2000c0, v7
		s_add_i32 m0, s11, 0x71c0
		s_lshl_b32 s10, s10, 22
		v_add_u32_e32 v11, s10, v2
		v_add_u32_e32 v12, s10, v2
		v_add_u32_e32 v13, 0x100000, v12
		v_add_u32_e32 v14, 0x200000, v12
		v_add_u32_e32 v12, 0x300000, v12
		buffer_load_dwordx4 v6, s[12:15], 0 offen lds
		v_add3_u32 v6, s10, 64, v2
		s_add_i32 m0, s11, 0x8200
		v_add_u32_e32 v15, s10, v2
		v_add_u32_e32 v16, 0x100040, v15
		v_add_u32_e32 v17, 0x200040, v15
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_add_u32_e32 v15, 0x300040, v15
		s_add_i32 m0, s11, 0x9240
		v_add_u32_e32 v18, s10, v2
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		v_add_u32_e32 v13, 0x200080, v18
		s_add_i32 m0, s11, 0xa280
		v_and_b32_e32 v4, 1, v4
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_add_u32_e32 v14, 0xc0, v18
		s_add_i32 m0, s11, 0xb2c0
		v_add_u32_e32 v19, s10, v2
		v_lshrrev_b32_e32 v20, 4, v1
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_add_u32_e32 v12, 0x2000c0, v19
		s_add_i32 m0, s11, 0xc300
		v_lshrrev_b32_e32 v21, 7, v0
		v_mov_b32_e32 v22, 0x2080
		v_mul_lo_u32 v22, v22, v21
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, s11, 0xd340
		v_lshlrev_b32_e32 v6, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v20, v0, 3 bitop3:0x78
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v0, 4, v0
		s_add_i32 m0, s11, 0xe380
		v_mov_b32_e32 v16, 0x2080
		v_mul_lo_u32 v16, v16, v4
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_add_u32_e32 v4, 0x300100, v3
		s_add_i32 m0, s11, 0xf3c0
		v_add_u32_e32 v17, 0x200140, v3
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_add_u32_e32 v15, 0x300140, v3
		s_add_i32 m0, s11, 0x10400
		s_add_i32 s16, s5, 0x80
		s_add_i32 s16, s16, s8
		v_add_u32_e32 v20, s16, v2
		buffer_load_dwordx4 v20, s[12:15], 0 offen lds
		v_add_u32_e32 v20, 0x100, v11
		s_add_i32 m0, s11, 0x11440
		s_add_i32 s5, s5, 0x100080
		s_add_i32 s5, s5, s8
		v_add_u32_e32 v21, s5, v2
		buffer_load_dwordx4 v21, s[12:15], 0 offen lds
		v_add_u32_e32 v21, 0x100100, v11
		s_add_i32 m0, s11, 0x12480
		v_add_u32_e32 v23, 0x140, v11
		buffer_load_dwordx4 v9, s[12:15], 0 offen lds
		v_add_u32_e32 v9, 0x100140, v11
		s_add_i32 m0, s11, 0x134c0
		v_add_u32_e32 v24, 0x300140, v11
		buffer_load_dwordx4 v10, s[12:15], 0 offen lds
		s_add_u32 s16, s6, s4
		s_addc_u32 s17, s7, 0
		s_add_i32 m0, s11, 0x14500
		s_mov_b32 s18, 0x20000
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		s_add_i32 m0, s11, 0x15540
		v_add_u32_e32 v5, 0x1000c0, v7
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_lshlrev_b32_e32 v1, 3, v1
		s_add_i32 m0, s11, 0x16580
		v_add_u32_e32 v5, 0x3000c0, v7
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		s_mov_b32 s4, 0
		s_add_i32 m0, s11, 0x175c0
		s_add_i32 s5, s10, 0x80
		v_add_u32_e32 v7, s5, v2
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, 0x300080, v18
		s_add_i32 m0, s11, 0x18600
		s_add_i32 s5, s10, 0x100080
		v_add_u32_e32 v2, s5, v2
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_add_u32_e32 v7, 0x1000c0, v19
		s_add_i32 m0, s11, 0x19640
		v_add_u32_e32 v8, 0x3000c0, v19
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add3_u32 v2, v22, v6, v0
		s_add_i32 m0, s11, 0x1a680
		v_add3_u32 v10, v6, v16, v0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		v_add_u32_e32 v13, 0x100, v3
		s_add_i32 m0, s11, 0x1b6c0
		v_add_u32_e32 v18, 0x100100, v3
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add_u32_e32 v5, 0x200100, v3
		s_add_i32 m0, s11, 0x1c700
		v_add_u32_e32 v19, 0x140, v3
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_add_u32_e32 v14, 0x100140, v3
		s_add_i32 m0, s11, 0x1d740
		v_add_u32_e32 v3, 0x200100, v11
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_add_u32_e32 v7, 0x300100, v11
		s_add_i32 m0, s11, 0x1e780
		v_add_u32_e32 v25, 0x200140, v11
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_add_i32 m0, s11, 0x1f7c0
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[0:3], v2
		ds_read_b128 a[4:7], v2 offset:1040
		ds_read_b128 a[8:11], v2 offset:2080
		ds_read_b128 a[12:15], v2 offset:3120
		ds_read_b128 a[16:19], v2 offset:4160
		ds_read_b128 a[20:23], v2 offset:5200
		ds_read_b128 a[24:27], v2 offset:6240
		ds_read_b128 a[28:31], v2 offset:7280
		ds_read_b128 a[32:35], v10 offset:33280
		ds_read_b128 a[36:39], v10 offset:34320
		ds_read_b128 a[40:43], v10 offset:35360
		ds_read_b128 a[44:47], v10 offset:36400
		ds_read_b128 a[48:51], v10 offset:37440
		ds_read_b128 a[52:55], v10 offset:38480
		ds_read_b128 a[56:59], v10 offset:39520
		ds_read_b128 a[60:63], v10 offset:40560
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
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
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[252:253], 0
		v_mov_b64_e32 v[254:255], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
	.p2align	2
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], a[0:3], a[32:35], v[28:31]
		s_and_b32 s5, s4, 1
		s_mul_i32 s5, 0x10400, s5
		v_add_u32_e32 v8, s5, v6
		v_add3_u32 v8, v8, v16, v0
		ds_read_b128 a[96:99], v8 offset:49920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[36:39], v[36:39]
		ds_read_b128 a[100:103], v8 offset:50960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[40:43], v[32:35]
		ds_read_b128 a[104:107], v8 offset:52000
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[44:47], v[40:43]
		ds_read_b128 a[108:111], v8 offset:53040
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[48:51], v[44:47]
		ds_read_b128 a[112:115], v8 offset:54080
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[52:55], v[48:51]
		ds_read_b128 a[116:119], v8 offset:55120
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[56:59], v[52:55]
		ds_read_b128 a[120:123], v8 offset:56160
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[60:63], v[56:59]
		ds_read_b128 a[124:127], v8 offset:57200
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[48:51], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[52:55], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[56:59], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[60:63], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[92:95], a[8:11], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[56:59], v[116:119]
		s_barrier
		s_add_i32 s6, s11, s5
		s_mov_b32 m0, s6
		s_lshl_b32 s7, s4, 7
		buffer_load_dwordx4 v13, s[12:15], s7 offen lds
		v_add_u32_e32 v8, s5, v22
		s_add_i32 m0, m0, 0x1040
		v_add3_u32 v8, v8, v6, v0
		v_mfma_f32_16x16x32_f16 v[124:127], a[12:15], a[32:35], v[124:127]
		buffer_load_dwordx4 v18, s[12:15], s7 offen lds
		ds_read_b128 a[0:3], v8 offset:16640
		s_add_i32 m0, s6, 0x2080
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[44:47], v[136:139]
		buffer_load_dwordx4 v5, s[12:15], s7 offen lds
		ds_read_b128 a[4:7], v8 offset:17680
		s_add_i32 m0, s6, 0x30c0
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[56:59], v[148:151]
		buffer_load_dwordx4 v4, s[12:15], s7 offen lds
		ds_read_b128 a[8:11], v8 offset:18720
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[16:19], a[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[16:19], a[36:39], v[160:163]
		ds_read_b128 a[12:15], v8 offset:19760
		v_mfma_f32_16x16x32_f16 v[164:167], a[16:19], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[16:19], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[16:19], a[48:51], v[172:175]
		ds_read_b128 a[128:131], v8 offset:20800
		v_mfma_f32_16x16x32_f16 v[176:179], a[16:19], a[52:55], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[16:19], a[56:59], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], a[16:19], a[60:63], v[184:187]
		ds_read_b128 a[16:19], v8 offset:21840
		v_mfma_f32_16x16x32_f16 v[188:191], a[20:23], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[20:23], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[20:23], a[40:43], v[196:199]
		ds_read_b128 a[132:135], v8 offset:22880
		v_mfma_f32_16x16x32_f16 v[200:203], a[20:23], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[20:23], a[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[20:23], a[52:55], v[208:211]
		ds_read_b128 v[252:255], v8 offset:23920
		v_mfma_f32_16x16x32_f16 v[212:215], a[20:23], a[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[20:23], a[60:63], v[216:219]
		s_add_i32 m0, s6, 0x4100
		v_mfma_f32_16x16x32_f16 v[220:223], a[24:27], a[32:35], v[220:223]
		s_waitcnt vmcnt(4) lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v19, s[12:15], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[224:227], a[24:27], a[36:39], v[224:227]
		s_add_i32 m0, s6, 0x5140
		v_mfma_f32_16x16x32_f16 v[228:231], a[24:27], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[24:27], a[44:47], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[24:27], a[48:51], v[236:239]
		buffer_load_dwordx4 v14, s[12:15], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[24:27], a[52:55], v[240:243]
		s_add_i32 m0, s6, 0x6180
		v_mfma_f32_16x16x32_f16 v[244:247], a[24:27], a[56:59], v[244:247]
		v_mfma_f32_16x16x32_f16 v[248:251], a[24:27], a[60:63], v[248:251]
		v_mfma_f32_16x16x32_f16 a[92:95], a[28:31], a[60:63], a[92:95]
		buffer_load_dwordx4 v17, s[12:15], s7 offen lds
		v_mfma_f32_16x16x32_f16 a[64:67], a[28:31], a[32:35], a[64:67]
		s_add_i32 m0, s6, 0x71c0
		v_mfma_f32_16x16x32_f16 a[68:71], a[28:31], a[36:39], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], a[28:31], a[40:43], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[28:31], a[44:47], a[76:79]
		buffer_load_dwordx4 v15, s[12:15], s7 offen lds
		v_mfma_f32_16x16x32_f16 a[80:83], a[28:31], a[48:51], a[80:83]
		s_add_i32 m0, s6, 0x8200
		v_mfma_f32_16x16x32_f16 a[84:87], a[28:31], a[52:55], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[28:31], a[56:59], a[88:91]
		v_mfma_f32_16x16x32_f16 v[28:31], a[0:3], a[96:99], v[28:31]
		buffer_load_dwordx4 v20, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[100:103], v[36:39]
		s_add_i32 m0, s6, 0x9240
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[104:107], v[32:35]
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[108:111], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[112:115], v[44:47]
		buffer_load_dwordx4 v21, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[116:119], v[48:51]
		s_add_i32 m0, s6, 0xa280
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[124:127], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[124:127], v[88:91]
		buffer_load_dwordx4 v3, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[96:99], v[60:63]
		s_add_i32 m0, s6, 0xb2c0
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[100:103], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[104:107], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[108:111], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[112:115], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[116:119], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[120:123], v[84:87]
		buffer_load_dwordx4 v7, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[120:123], v[116:119]
		s_add_i32 m0, s6, 0xc300
		v_mfma_f32_16x16x32_f16 v[92:95], a[8:11], a[96:99], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[100:103], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[104:107], v[100:103]
		buffer_load_dwordx4 v23, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[108:111], v[104:107]
		s_add_i32 m0, s6, 0xd340
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[112:115], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[116:119], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[124:127], v[120:123]
		buffer_load_dwordx4 v9, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[124:127], v[152:155]
		s_add_i32 m0, s6, 0xe380
		v_mfma_f32_16x16x32_f16 v[124:127], a[12:15], a[96:99], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[100:103], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[104:107], v[132:135]
		buffer_load_dwordx4 v25, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[108:111], v[136:139]
		s_add_i32 m0, s6, 0xf3c0
		s_add_i32 s4, s4, 1
		s_and_b32 s5, s4, 1
		s_mul_i32 s5, 0x10400, s5
		buffer_load_dwordx4 v24, s[0:3], s7 offen lds
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[112:115], v[140:143]
		v_add_u32_e32 v8, s5, v22
		v_add3_u32 v8, v8, v6, v0
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[116:119], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[120:123], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], a[128:131], a[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[128:131], a[100:103], v[160:163]
		ds_read_b128 a[0:3], v8
		v_mfma_f32_16x16x32_f16 v[164:167], a[128:131], a[104:107], v[164:167]
		v_add_u32_e32 v11, s5, v6
		v_add3_u32 v11, v11, v16, v0
		v_mfma_f32_16x16x32_f16 v[168:171], a[128:131], a[108:111], v[168:171]
		ds_read_b128 a[32:35], v11 offset:33280
		v_mfma_f32_16x16x32_f16 v[172:175], a[128:131], a[112:115], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[128:131], a[116:119], v[176:179]
		ds_read_b128 a[4:7], v8 offset:1040
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[120:123], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[124:127], v[184:187]
		ds_read_b128 a[36:39], v11 offset:34320
		v_mfma_f32_16x16x32_f16 v[188:191], a[16:19], a[96:99], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[16:19], a[100:103], v[192:195]
		ds_read_b128 a[8:11], v8 offset:2080
		v_mfma_f32_16x16x32_f16 v[196:199], a[16:19], a[104:107], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[16:19], a[108:111], v[200:203]
		ds_read_b128 a[40:43], v11 offset:35360
		v_mfma_f32_16x16x32_f16 v[204:207], a[16:19], a[112:115], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[16:19], a[116:119], v[208:211]
		ds_read_b128 a[12:15], v8 offset:3120
		v_mfma_f32_16x16x32_f16 v[212:215], a[16:19], a[120:123], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[16:19], a[124:127], v[216:219]
		ds_read_b128 a[44:47], v11 offset:36400
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[96:99], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[100:103], v[224:227]
		ds_read_b128 a[16:19], v8 offset:4160
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[104:107], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[108:111], v[232:235]
		ds_read_b128 a[48:51], v11 offset:37440
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[112:115], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[116:119], v[240:243]
		ds_read_b128 a[20:23], v8 offset:5200
		v_mfma_f32_16x16x32_f16 v[244:247], a[132:135], a[120:123], v[244:247]
		v_mfma_f32_16x16x32_f16 v[248:251], a[132:135], a[124:127], v[248:251]
		ds_read_b128 a[52:55], v11 offset:38480
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[96:99], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[100:103], a[68:71]
		ds_read_b128 a[24:27], v8 offset:6240
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		ds_read_b128 a[56:59], v11 offset:39520
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[28:31], v8 offset:7280
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[60:63], v11 offset:40560
		s_cmp_lt_i32 s4, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[0:3], a[32:35], v[28:31]
		ds_read_b128 a[96:99], v10 offset:49920
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[36:39], v[36:39]
		ds_read_b128 a[100:103], v10 offset:50960
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[40:43], v[32:35]
		ds_read_b128 a[104:107], v10 offset:52000
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[44:47], v[40:43]
		ds_read_b128 a[108:111], v10 offset:53040
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[48:51], v[44:47]
		ds_read_b128 a[112:115], v10 offset:54080
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[52:55], v[48:51]
		ds_read_b128 a[116:119], v10 offset:55120
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[56:59], v[52:55]
		ds_read_b128 a[120:123], v10 offset:56160
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[60:63], v[56:59]
		ds_read_b128 a[0:3], v10 offset:57200
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[48:51], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[52:55], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[56:59], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[60:63], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[92:95], a[8:11], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], a[12:15], a[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[16:19], a[60:63], v[184:187]
		v_mfma_f32_16x16x32_f16 v[156:159], a[16:19], a[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[16:19], a[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[16:19], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[16:19], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[16:19], a[48:51], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[16:19], a[52:55], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[16:19], a[56:59], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[20:23], a[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], a[20:23], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[20:23], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[20:23], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[20:23], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[20:23], a[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[20:23], a[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], a[20:23], a[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[24:27], a[60:63], v[248:251]
		v_mfma_f32_16x16x32_f16 v[220:223], a[24:27], a[32:35], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[24:27], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[24:27], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[24:27], a[44:47], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[24:27], a[48:51], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[24:27], a[52:55], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[24:27], a[56:59], v[244:247]
		v_mfma_f32_16x16x32_f16 a[88:91], a[28:31], a[56:59], a[88:91]
		v_mfma_f32_16x16x32_f16 a[64:67], a[28:31], a[32:35], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], a[28:31], a[36:39], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], a[28:31], a[40:43], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[28:31], a[44:47], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], a[28:31], a[48:51], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[28:31], a[52:55], a[84:87]
		v_mfma_f32_16x16x32_f16 a[92:95], a[28:31], a[60:63], a[92:95]
		ds_read_b128 v[8:11], v2 offset:16640
		ds_read_b128 v[12:15], v2 offset:17680
		ds_read_b128 v[24:27], v2 offset:18720
		ds_read_b128 a[4:7], v2 offset:19760
		ds_read_b128 a[8:11], v2 offset:20800
		ds_read_b128 a[12:15], v2 offset:21840
		ds_read_b128 a[16:19], v2 offset:22880
		ds_read_b128 v[252:255], v2 offset:23920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[96:99], v[28:31]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[100:103], v[36:39]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[104:107], v[32:35]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[108:111], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[112:115], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[116:119], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[8:11], a[0:3], v[56:59]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[12:15], a[0:3], v[88:91]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[96:99], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[100:103], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[104:107], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[108:111], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[112:115], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[116:119], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[120:123], v[84:87]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[116:119], v[24:27], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], a[96:99], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[24:27], a[100:103], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[24:27], a[104:107], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[24:27], a[108:111], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[24:27], a[112:115], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[24:27], a[116:119], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[24:27], a[0:3], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], a[4:7], a[0:3], v[152:155]
		v_mfma_f32_16x16x32_f16 v[124:127], a[4:7], a[96:99], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], a[4:7], a[100:103], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[4:7], a[104:107], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[4:7], a[108:111], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[4:7], a[112:115], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[4:7], a[116:119], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[4:7], a[120:123], v[148:151]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], a[8:11], a[120:123], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], a[8:11], a[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[8:11], a[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[8:11], a[104:107], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[8:11], a[108:111], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[8:11], a[112:115], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[8:11], a[116:119], v[176:179]
		v_mfma_f32_16x16x32_f16 v[184:187], a[8:11], a[0:3], v[184:187]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[216:219], a[12:15], a[0:3], v[216:219]
		v_mfma_f32_16x16x32_f16 v[188:191], a[12:15], a[96:99], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[12:15], a[100:103], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[12:15], a[104:107], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[12:15], a[108:111], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[12:15], a[112:115], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[12:15], a[116:119], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[12:15], a[120:123], v[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[244:247], a[16:19], a[120:123], v[244:247]
		v_mfma_f32_16x16x32_f16 v[220:223], a[16:19], a[96:99], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[16:19], a[100:103], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[16:19], a[104:107], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[16:19], a[108:111], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[16:19], a[112:115], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[16:19], a[116:119], v[240:243]
		v_mfma_f32_16x16x32_f16 v[248:251], a[16:19], a[0:3], v[248:251]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[0:3], a[92:95]
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[96:99], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[100:103], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v22
		v_add3_u32 v2, v2, v6, v0
		ds_read_b128 v[8:11], v2 offset:1024
		ds_read_b128 v[12:15], v2 offset:2064
		ds_read_b128 v[20:23], v2 offset:3104
		ds_read_b128 v[24:27], v2 offset:4144
		ds_read_b128 a[0:3], v2 offset:5184
		ds_read_b128 a[4:7], v2 offset:6224
		ds_read_b128 a[8:11], v2 offset:7264
		ds_read_b128 a[12:15], v2 offset:8304
		v_add_u32_e32 v3, 0x10000, v6
		v_add3_u32 v0, v3, v16, v0
		ds_read_b128 v[4:7], v0 offset:34304
		ds_read_b128 a[16:19], v0 offset:35344
		ds_read_b128 a[20:23], v0 offset:36384
		ds_read_b128 a[24:27], v0 offset:37424
		ds_read_b128 a[28:31], v0 offset:38464
		ds_read_b128 a[32:35], v0 offset:39504
		ds_read_b128 v[16:19], v0 offset:40544
		ds_read_b128 a[36:39], v0 offset:41584
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], v[4:7], v[28:31]
		ds_read_b128 a[40:43], v0 offset:50944
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[16:19], v[36:39]
		ds_read_b128 a[44:47], v0 offset:51984
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[20:23], v[32:35]
		ds_read_b128 a[48:51], v0 offset:53024
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[24:27], v[40:43]
		ds_read_b128 a[52:55], v0 offset:54064
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[28:31], v[44:47]
		ds_read_b128 a[56:59], v0 offset:55104
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[32:35], v[48:51]
		ds_read_b128 a[60:63], v0 offset:56144
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], v[16:19], v[52:55]
		ds_read_b128 a[96:99], v0 offset:57184
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], v[8:11], a[36:39], v[56:59]
		ds_read_b128 a[100:103], v0 offset:58224
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], v[4:7], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[28:31], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], v[16:19], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[12:15], a[36:39], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], v[4:7], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], a[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[20:23], a[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], v[16:19], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[16:19], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[24:27], v[4:7], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[24:27], a[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[24:27], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[24:27], a[24:27], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[24:27], a[28:31], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], a[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[0:3], a[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[156:159], a[0:3], v[4:7], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[0:3], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[0:3], a[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[0:3], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[0:3], a[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[0:3], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[0:3], v[16:19], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[4:7], v[16:19], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], a[4:7], v[4:7], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[4:7], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[4:7], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[4:7], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[4:7], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[4:7], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], a[4:7], a[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[8:11], a[36:39], v[248:251]
		v_mfma_f32_16x16x32_f16 v[220:223], a[8:11], v[4:7], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[8:11], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[8:11], a[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[8:11], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[8:11], a[28:31], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[8:11], a[32:35], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[8:11], v[16:19], v[244:247]
		v_mfma_f32_16x16x32_f16 a[88:91], a[12:15], v[16:19], a[88:91]
		v_mfma_f32_16x16x32_f16 a[64:67], a[12:15], v[4:7], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], a[12:15], a[16:19], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], a[12:15], a[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[12:15], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], a[12:15], a[28:31], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[12:15], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 a[92:95], a[12:15], a[36:39], a[92:95]
		ds_read_b128 v[4:7], v2 offset:17664
		ds_read_b128 v[8:11], v2 offset:18704
		ds_read_b128 v[12:15], v2 offset:19744
		ds_read_b128 v[16:19], v2 offset:20784
		ds_read_b128 v[20:23], v2 offset:21824
		ds_read_b128 v[24:27], v2 offset:22864
		ds_read_b128 a[0:3], v2 offset:23904
		ds_read_b128 v[252:255], v2 offset:24944
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[4:7], a[40:43], v[28:31]
		v_lshl_add_u32 v0, s9, 15, v1
		v_mfma_f32_16x16x32_f16 v[36:39], v[4:7], a[44:47], v[36:39]
		v_mfma_f32_16x16x32_f16 v[32:35], v[4:7], a[48:51], v[32:35]
		v_mfma_f32_16x16x32_f16 v[40:43], v[4:7], a[52:55], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[4:7], a[56:59], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[4:7], a[60:63], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[4:7], a[96:99], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[4:7], a[100:103], v[56:59]
		v_cvt_pk_f16_f32 v2, v28, v29
		v_cvt_pk_f16_f32 v3, v30, v31
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[8:11], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[60:63], v[8:11], a[40:43], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[8:11], a[44:47], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[8:11], a[48:51], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[8:11], a[52:55], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[8:11], a[56:59], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[8:11], a[60:63], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[8:11], a[96:99], v[84:87]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[116:119], v[12:15], a[96:99], v[116:119]
		v_mfma_f32_16x16x32_f16 v[92:95], v[12:15], a[40:43], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[12:15], a[44:47], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[12:15], a[48:51], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[12:15], a[52:55], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[12:15], a[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[12:15], a[60:63], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[12:15], a[100:103], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], v[16:19], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[124:127], v[16:19], a[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[16:19], a[44:47], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[16:19], a[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[16:19], a[52:55], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[16:19], a[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[16:19], a[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[16:19], a[96:99], v[148:151]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], v[20:23], a[96:99], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], v[20:23], a[40:43], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[20:23], a[44:47], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[20:23], a[48:51], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[20:23], a[52:55], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[20:23], a[56:59], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[20:23], a[60:63], v[176:179]
		v_mfma_f32_16x16x32_f16 v[184:187], v[20:23], a[100:103], v[184:187]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[216:219], v[24:27], a[100:103], v[216:219]
		v_mfma_f32_16x16x32_f16 v[188:191], v[24:27], a[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[24:27], a[44:47], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[24:27], a[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[24:27], a[52:55], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[24:27], a[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[24:27], a[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[24:27], a[96:99], v[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[244:247], a[0:3], a[96:99], v[244:247]
		v_mfma_f32_16x16x32_f16 v[220:223], a[0:3], a[40:43], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[0:3], a[44:47], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[0:3], a[48:51], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[0:3], a[52:55], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[0:3], a[56:59], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[0:3], a[60:63], v[240:243]
		v_mfma_f32_16x16x32_f16 v[248:251], a[0:3], a[100:103], v[248:251]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[100:103], a[92:95]
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[40:43], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[44:47], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[48:51], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[52:55], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[56:59], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[60:63], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[96:99], a[88:91]
		s_mov_b32 s19, s15
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v32, v33
		v_cvt_pk_f16_f32 v3, v34, v35
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		s_mov_b32 s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		s_mov_b32 s0, 0x2000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		s_mov_b32 s0, 0x3000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_mov_b32 s0, 0x4000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		s_mov_b32 s0, 0x5000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		s_mov_b32 s0, 0x6000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v244, v245
		v_cvt_pk_f16_f32 v3, v246, v247
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v248, v249
		v_cvt_pk_f16_f32 v3, v250, v251
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		s_mov_b32 s0, 0x7000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3584
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
		.amdhsa_next_free_vgpr 392
		.amdhsa_next_free_sgpr 20
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 136
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 20
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
    .sgpr_count:     20
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     392
    .agpr_count:     136
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 71
    wave.regalloc.agpr.dwords: 280
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
