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
		v_lshrrev_b32_e32 v4, 6, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s16, s5, 0x100000
		s_add_i32 s16, s16, s8
		v_add_u32_e32 v5, s16, v2
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, s8, v2
		s_add_i32 m0, s11, 0x2000
		s_add_i32 s16, s5, 0x200000
		v_add_u32_e32 v6, s16, v5
		v_add3_u32 v7, s5, 64, v5
		buffer_load_dwordx4 v6, s[12:15], 0 offen lds
		v_add_u32_e32 v6, s8, v2
		s_add_i32 m0, s11, 0x3000
		s_add_i32 s16, s5, 0x300000
		v_add_u32_e32 v5, s16, v5
		v_add_u32_e32 v6, s5, v6
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, 0x100040, v6
		s_add_i32 m0, s11, 0x4000
		v_add_u32_e32 v8, 0x200040, v6
		v_add_u32_e32 v6, 0x300040, v6
		buffer_load_dwordx4 v7, s[12:15], 0 offen lds
		s_mov_b32 s16, 0x6000
		s_add_i32 m0, s11, 0x5000
		s_mov_b32 s17, 0x4000
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, s8, v2
		s_add_i32 m0, s11, 0x6000
		v_add_u32_e32 v5, s5, v5
		v_add_u32_e32 v7, 0x200080, v5
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_add_u32_e32 v8, 0x300080, v5
		s_add_i32 m0, s11, 0x7000
		s_lshl_b32 s10, s10, 22
		v_add_u32_e32 v9, s10, v2
		v_add_u32_e32 v10, s10, v2
		v_add_u32_e32 v11, 0x100000, v10
		v_add_u32_e32 v12, 0x200000, v10
		v_add_u32_e32 v10, 0x300000, v10
		buffer_load_dwordx4 v6, s[12:15], 0 offen lds
		v_add3_u32 v6, s10, 64, v2
		s_add_i32 m0, s11, 0x8000
		v_add_u32_e32 v13, s10, v2
		v_add_u32_e32 v14, 0x100040, v13
		v_add_u32_e32 v15, 0x200040, v13
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		v_add_u32_e32 v13, 0x300040, v13
		s_add_i32 m0, s11, 0x9000
		v_add_u32_e32 v5, 0xc0, v5
		v_add_u32_e32 v16, s8, v2
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_add_u32_e32 v11, s5, v16
		s_add_i32 m0, s11, 0xa000
		v_add_u32_e32 v16, 0x1000c0, v11
		v_add_u32_e32 v17, 0x2000c0, v11
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v12, 3, v1
		s_add_i32 m0, s11, 0xb000
		v_add_u32_e32 v11, 0x3000c0, v11
		v_add_u32_e32 v18, s10, v2
		v_add_u32_e32 v19, 0x200080, v18
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s18, 0
		s_add_i32 m0, s11, 0xc000
		v_and_b32_e32 v4, 1, v4
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_add_u32_e32 v6, s10, v2
		s_add_i32 m0, s11, 0xd000
		v_lshrrev_b32_e32 v1, 4, v1
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_lshrrev_b32_e32 v10, 7, v0
		s_add_i32 m0, s11, 0xe000
		v_lshlrev_b32_e32 v10, 13, v10
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v14, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v1, v0, 3 bitop3:0x78
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v0, 4, v0
		s_add_i32 m0, s11, 0xf000
		v_lshlrev_b32_e32 v1, 13, v4
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		v_add_u32_e32 v4, 0x100, v3
		s_add_i32 m0, s11, 0x10000
		s_add_i32 s19, s5, 0x80
		s_add_i32 s19, s19, s8
		v_add_u32_e32 v13, s19, v2
		buffer_load_dwordx4 v13, s[12:15], 0 offen lds
		v_add_u32_e32 v13, 0x100100, v3
		s_add_i32 m0, s11, 0x11000
		s_add_i32 s5, s5, 0x100080
		s_add_i32 s5, s5, s8
		v_add_u32_e32 v15, s5, v2
		buffer_load_dwordx4 v15, s[12:15], 0 offen lds
		v_add_u32_e32 v15, 0x200100, v3
		s_add_i32 m0, s11, 0x12000
		v_add_u32_e32 v20, 0x100140, v3
		buffer_load_dwordx4 v7, s[12:15], 0 offen lds
		v_add_u32_e32 v7, 0x200140, v3
		s_add_i32 m0, s11, 0x13000
		v_add_u32_e32 v21, 0x100, v9
		v_add_u32_e32 v22, 0x100100, v9
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_add_u32_e32 v8, 0x200100, v9
		s_add_i32 m0, s11, 0x14000
		v_add_u32_e32 v23, 0x300100, v9
		v_add_u32_e32 v24, 0x140, v9
		v_add_u32_e32 v25, 0x100140, v9
		buffer_load_dwordx4 v5, s[12:15], 0 offen lds
		v_add_u32_e32 v5, 0x200140, v9
		s_add_i32 m0, s11, 0x15000
		v_add_u32_e32 v26, 0x300140, v9
		buffer_load_dwordx4 v16, s[12:15], 0 offen lds
		s_add_u32 s20, s6, s4
		s_addc_u32 s21, s7, 0
		s_add_i32 m0, s11, 0x16000
		s_mov_b32 s22, 0x20000
		buffer_load_dwordx4 v17, s[12:15], 0 offen lds
		s_mov_b32 s4, 0x7000
		s_add_i32 m0, s11, 0x17000
		s_add_i32 s5, s10, 0x80
		v_add_u32_e32 v9, s5, v2
		buffer_load_dwordx4 v11, s[12:15], 0 offen lds
		s_mov_b32 s5, 0x5000
		s_add_i32 m0, s11, 0x18000
		s_add_i32 s6, s10, 0x100080
		v_add_u32_e32 v2, s6, v2
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		s_add_i32 m0, s11, 0x19000
		s_mov_b32 s6, 0x3000
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s7, 0x2000
		s_add_i32 m0, s11, 0x1a000
		s_mov_b32 s8, 0x1000
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		v_add_u32_e32 v2, 0x300080, v18
		s_add_i32 m0, s11, 0x1b000
		v_add_u32_e32 v9, 0xc0, v18
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add_u32_e32 v2, 0x1000c0, v6
		s_add_i32 m0, s11, 0x1c000
		v_add_u32_e32 v11, 0x2000c0, v6
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		v_add_u32_e32 v6, 0x3000c0, v6
		s_add_i32 m0, s11, 0x1d000
		v_add3_u32 v9, v10, v14, v0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add3_u32 v2, v14, v1, v0
		s_add_i32 m0, s11, 0x1e000
		v_add_u32_e32 v16, 0x300100, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_add_u32_e32 v11, 0x140, v3
		s_add_i32 m0, s11, 0x1f000
		v_add_u32_e32 v17, 0x300140, v3
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[0:3], v9
		ds_read_b128 a[4:7], v9 offset:1024
		ds_read_b128 a[8:11], v9 offset:2048
		ds_read_b128 a[12:15], v9 offset:3072
		ds_read_b128 a[16:19], v9 offset:4096
		ds_read_b128 a[20:23], v9 offset:5120
		ds_read_b128 a[24:27], v9 offset:6144
		ds_read_b128 a[28:31], v9 offset:7168
		ds_read_b128 a[32:35], v2 offset:32768
		ds_read_b128 a[36:39], v2 offset:33792
		ds_read_b128 a[40:43], v2 offset:34816
		ds_read_b128 a[44:47], v2 offset:35840
		ds_read_b128 a[48:51], v2 offset:36864
		ds_read_b128 a[52:55], v2 offset:37888
		ds_read_b128 a[56:59], v2 offset:38912
		ds_read_b128 a[60:63], v2 offset:39936
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
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
		s_and_b32 s10, s18, 1
		s_lshl_b32 s10, s10, 16
		v_add_u32_e32 v3, s10, v14
		v_add3_u32 v3, v3, v1, v0
		ds_read_b128 a[96:99], v3 offset:49152
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[36:39], v[32:35]
		ds_read_b128 a[100:103], v3 offset:50176
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[40:43], v[36:39]
		ds_read_b128 a[104:107], v3 offset:51200
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[44:47], v[40:43]
		ds_read_b128 a[108:111], v3 offset:52224
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[48:51], v[44:47]
		ds_read_b128 a[112:115], v3 offset:53248
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[52:55], v[48:51]
		ds_read_b128 a[116:119], v3 offset:54272
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[56:59], v[52:55]
		ds_read_b128 a[120:123], v3 offset:55296
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[60:63], v[56:59]
		ds_read_b128 a[124:127], v3 offset:56320
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[32:35], v[60:63]
		v_add_u32_e32 v3, s10, v10
		v_add3_u32 v3, v3, v14, v0
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
		ds_read_b128 a[0:3], v3 offset:16384
		ds_read_b128 a[4:7], v3 offset:17408
		s_mov_b32 m0, s11
		s_lshl_b32 s10, s18, 7
		v_mfma_f32_16x16x32_f16 v[124:127], a[12:15], a[32:35], v[124:127]
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v4, s[12:15], s10 offen lds
		ds_read_b128 a[8:11], v3 offset:18432
		s_add_i32 m0, m0, 0x1000
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], a[44:47], v[136:139]
		buffer_load_dwordx4 v13, s[12:15], s10 offen lds
		ds_read_b128 a[128:131], v3 offset:19456
		s_add_i32 m0, s11, 0x2000
		v_mfma_f32_16x16x32_f16 v[140:143], a[12:15], a[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[12:15], a[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[12:15], a[56:59], v[148:151]
		buffer_load_dwordx4 v15, s[12:15], s10 offen lds
		ds_read_b128 a[132:135], v3 offset:20480
		s_add_i32 m0, s11, 0x3000
		v_mfma_f32_16x16x32_f16 v[152:155], a[12:15], a[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[16:19], a[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[16:19], a[36:39], v[160:163]
		buffer_load_dwordx4 v16, s[12:15], s10 offen lds
		ds_read_b128 a[136:139], v3 offset:21504
		s_add_i32 m0, s11, 0x4000
		v_mfma_f32_16x16x32_f16 v[164:167], a[16:19], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[16:19], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[16:19], a[48:51], v[172:175]
		buffer_load_dwordx4 v11, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[176:179], a[16:19], a[52:55], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[16:19], a[56:59], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], a[16:19], a[60:63], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], a[20:23], a[32:35], v[188:191]
		ds_read_b128 a[140:143], v3 offset:22528
		v_mfma_f32_16x16x32_f16 v[192:195], a[20:23], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[20:23], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[20:23], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[20:23], a[48:51], v[204:207]
		ds_read_b128 v[252:255], v3 offset:23552
		v_mfma_f32_16x16x32_f16 v[208:211], a[20:23], a[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[20:23], a[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[20:23], a[60:63], v[216:219]
		s_add_i32 m0, s11, 0x5000
		s_waitcnt vmcnt(5) lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v20, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[220:223], a[24:27], a[32:35], v[220:223]
		s_add_i32 m0, s11, 0x6000
		v_mfma_f32_16x16x32_f16 v[224:227], a[24:27], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[24:27], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[24:27], a[44:47], v[232:235]
		buffer_load_dwordx4 v7, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[24:27], a[48:51], v[236:239]
		s_add_i32 m0, s11, 0x7000
		v_mfma_f32_16x16x32_f16 v[240:243], a[24:27], a[52:55], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[24:27], a[56:59], v[244:247]
		v_mfma_f32_16x16x32_f16 v[248:251], a[24:27], a[60:63], v[248:251]
		buffer_load_dwordx4 v17, s[12:15], s10 offen lds
		v_mfma_f32_16x16x32_f16 a[92:95], a[28:31], a[60:63], a[92:95]
		s_add_i32 m0, s11, 0x8000
		v_mfma_f32_16x16x32_f16 a[64:67], a[28:31], a[32:35], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], a[28:31], a[36:39], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], a[28:31], a[40:43], a[72:75]
		buffer_load_dwordx4 v21, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 a[76:79], a[28:31], a[44:47], a[76:79]
		s_add_i32 m0, s11, 0x9000
		v_mfma_f32_16x16x32_f16 a[80:83], a[28:31], a[48:51], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[28:31], a[52:55], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[28:31], a[56:59], a[88:91]
		buffer_load_dwordx4 v22, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[28:31], a[0:3], a[96:99], v[28:31]
		s_add_i32 m0, s11, 0xa000
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[100:103], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[104:107], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[108:111], v[40:43]
		buffer_load_dwordx4 v8, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[112:115], v[44:47]
		s_add_i32 m0, s11, 0xb000
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[116:119], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[124:127], v[56:59]
		buffer_load_dwordx4 v23, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[88:91], a[4:7], a[124:127], v[88:91]
		s_add_i32 m0, s11, 0xc000
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[96:99], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[100:103], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[104:107], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], a[108:111], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[4:7], a[112:115], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[4:7], a[116:119], v[80:83]
		buffer_load_dwordx4 v24, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[84:87], a[4:7], a[120:123], v[84:87]
		s_add_i32 m0, s11, 0xd000
		v_mfma_f32_16x16x32_f16 v[116:119], a[8:11], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[92:95], a[8:11], a[96:99], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[100:103], v[96:99]
		buffer_load_dwordx4 v25, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[104:107], v[100:103]
		s_add_i32 m0, s11, 0xe000
		s_add_i32 s19, s11, 0x10000
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], a[108:111], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[8:11], a[112:115], v[108:111]
		buffer_load_dwordx4 v5, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], a[8:11], a[116:119], v[112:115]
		s_add_i32 m0, s11, 0xf000
		s_add_i32 s18, s18, 1
		s_and_b32 s11, s18, 1
		s_lshl_b32 s11, s11, 16
		buffer_load_dwordx4 v26, s[0:3], s10 offen lds
		v_mfma_f32_16x16x32_f16 v[120:123], a[8:11], a[124:127], v[120:123]
		v_add_u32_e32 v3, s11, v10
		v_add3_u32 v3, v3, v14, v0
		v_mfma_f32_16x16x32_f16 v[152:155], a[128:131], a[124:127], v[152:155]
		v_mfma_f32_16x16x32_f16 v[124:127], a[128:131], a[96:99], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], a[128:131], a[100:103], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[128:131], a[104:107], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[128:131], a[108:111], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[128:131], a[112:115], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[128:131], a[116:119], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[128:131], a[120:123], v[148:151]
		v_mfma_f32_16x16x32_f16 v[156:159], a[132:135], a[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[132:135], a[100:103], v[160:163]
		ds_read_b128 a[0:3], v3
		v_mfma_f32_16x16x32_f16 v[164:167], a[132:135], a[104:107], v[164:167]
		v_add_u32_e32 v6, s11, v14
		v_add3_u32 v6, v6, v1, v0
		v_mfma_f32_16x16x32_f16 v[168:171], a[132:135], a[108:111], v[168:171]
		ds_read_b128 a[32:35], v6 offset:32768
		v_mfma_f32_16x16x32_f16 v[172:175], a[132:135], a[112:115], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[132:135], a[116:119], v[176:179]
		ds_read_b128 a[4:7], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[180:183], a[132:135], a[120:123], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], a[132:135], a[124:127], v[184:187]
		ds_read_b128 a[36:39], v6 offset:33792
		v_mfma_f32_16x16x32_f16 v[188:191], a[136:139], a[96:99], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[136:139], a[100:103], v[192:195]
		ds_read_b128 a[8:11], v3 offset:2048
		v_mfma_f32_16x16x32_f16 v[196:199], a[136:139], a[104:107], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[136:139], a[108:111], v[200:203]
		ds_read_b128 a[40:43], v6 offset:34816
		v_mfma_f32_16x16x32_f16 v[204:207], a[136:139], a[112:115], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[136:139], a[116:119], v[208:211]
		ds_read_b128 a[12:15], v3 offset:3072
		v_mfma_f32_16x16x32_f16 v[212:215], a[136:139], a[120:123], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[136:139], a[124:127], v[216:219]
		ds_read_b128 a[44:47], v6 offset:35840
		v_mfma_f32_16x16x32_f16 v[220:223], a[140:143], a[96:99], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[140:143], a[100:103], v[224:227]
		ds_read_b128 a[16:19], v3 offset:4096
		v_mfma_f32_16x16x32_f16 v[228:231], a[140:143], a[104:107], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[140:143], a[108:111], v[232:235]
		ds_read_b128 a[48:51], v6 offset:36864
		v_mfma_f32_16x16x32_f16 v[236:239], a[140:143], a[112:115], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[140:143], a[116:119], v[240:243]
		ds_read_b128 a[20:23], v3 offset:5120
		v_mfma_f32_16x16x32_f16 v[244:247], a[140:143], a[120:123], v[244:247]
		v_mfma_f32_16x16x32_f16 v[248:251], a[140:143], a[124:127], v[248:251]
		ds_read_b128 a[52:55], v6 offset:37888
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[96:99], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[100:103], a[68:71]
		ds_read_b128 a[24:27], v3 offset:6144
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		ds_read_b128 a[56:59], v6 offset:38912
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[28:31], v3 offset:7168
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[60:63], v6 offset:39936
		s_and_b32 s11, s19, 0x1ffff
		s_cmp_lt_i32 s18, 0x7e
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[0:3], a[32:35], v[28:31]
		ds_read_b128 a[96:99], v2 offset:49152
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[32:35], a[0:3], a[36:39], v[32:35]
		ds_read_b128 a[100:103], v2 offset:50176
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[36:39], a[0:3], a[40:43], v[36:39]
		ds_read_b128 a[104:107], v2 offset:51200
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[40:43], a[0:3], a[44:47], v[40:43]
		ds_read_b128 a[108:111], v2 offset:52224
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[44:47], a[0:3], a[48:51], v[44:47]
		ds_read_b128 a[112:115], v2 offset:53248
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[48:51], a[0:3], a[52:55], v[48:51]
		ds_read_b128 a[116:119], v2 offset:54272
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[52:55], a[0:3], a[56:59], v[52:55]
		ds_read_b128 a[120:123], v2 offset:55296
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], a[0:3], a[60:63], v[56:59]
		ds_read_b128 a[0:3], v2 offset:56320
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
		ds_read_b128 v[4:7], v9 offset:16384
		ds_read_b128 v[16:19], v9 offset:17408
		ds_read_b128 v[20:23], v9 offset:18432
		ds_read_b128 v[24:27], v9 offset:19456
		ds_read_b128 a[4:7], v9 offset:20480
		ds_read_b128 a[8:11], v9 offset:21504
		ds_read_b128 a[12:15], v9 offset:22528
		ds_read_b128 v[252:255], v9 offset:23552
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[4:7], a[96:99], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[4:7], a[100:103], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[4:7], a[104:107], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[4:7], a[108:111], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[4:7], a[112:115], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[4:7], a[116:119], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[4:7], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[4:7], a[0:3], v[56:59]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[0:3], v[88:91]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], a[96:99], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[100:103], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[104:107], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[108:111], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], a[112:115], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], a[116:119], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], a[120:123], v[84:87]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], a[96:99], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[100:103], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[104:107], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[108:111], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], a[112:115], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[20:23], a[116:119], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[0:3], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], v[24:27], a[0:3], v[152:155]
		v_mfma_f32_16x16x32_f16 v[124:127], v[24:27], a[96:99], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[24:27], a[100:103], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[24:27], a[104:107], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[24:27], a[108:111], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[24:27], a[112:115], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], a[116:119], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], a[120:123], v[148:151]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], a[4:7], a[120:123], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], a[4:7], a[96:99], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[4:7], a[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[4:7], a[104:107], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[4:7], a[108:111], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[4:7], a[112:115], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[4:7], a[116:119], v[176:179]
		v_mfma_f32_16x16x32_f16 v[184:187], a[4:7], a[0:3], v[184:187]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[216:219], a[8:11], a[0:3], v[216:219]
		v_mfma_f32_16x16x32_f16 v[188:191], a[8:11], a[96:99], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[8:11], a[100:103], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[8:11], a[104:107], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[8:11], a[108:111], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[8:11], a[112:115], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[8:11], a[116:119], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[8:11], a[120:123], v[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[244:247], a[12:15], a[120:123], v[244:247]
		v_mfma_f32_16x16x32_f16 v[220:223], a[12:15], a[96:99], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[12:15], a[100:103], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[12:15], a[104:107], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[12:15], a[108:111], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[12:15], a[112:115], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[12:15], a[116:119], v[240:243]
		v_mfma_f32_16x16x32_f16 v[248:251], a[12:15], a[0:3], v[248:251]
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
		v_add_u32_e32 v2, 0x10000, v10
		v_add3_u32 v2, v2, v14, v0
		ds_read_b128 v[4:7], v2
		ds_read_b128 v[8:11], v2 offset:1024
		ds_read_b128 v[16:19], v2 offset:2048
		ds_read_b128 v[20:23], v2 offset:3072
		ds_read_b128 v[24:27], v2 offset:4096
		ds_read_b128 a[0:3], v2 offset:5120
		ds_read_b128 a[4:7], v2 offset:6144
		ds_read_b128 a[8:11], v2 offset:7168
		v_add_u32_e32 v3, 0x10000, v14
		v_add3_u32 v0, v3, v1, v0
		ds_read_b128 a[12:15], v0 offset:32768
		ds_read_b128 a[16:19], v0 offset:33792
		ds_read_b128 a[20:23], v0 offset:34816
		ds_read_b128 a[24:27], v0 offset:35840
		ds_read_b128 a[28:31], v0 offset:36864
		ds_read_b128 a[32:35], v0 offset:37888
		ds_read_b128 a[36:39], v0 offset:38912
		ds_read_b128 a[40:43], v0 offset:39936
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[4:7], a[12:15], v[28:31]
		ds_read_b128 a[44:47], v0 offset:49152
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[32:35], v[4:7], a[16:19], v[32:35]
		ds_read_b128 a[48:51], v0 offset:50176
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[36:39], v[4:7], a[20:23], v[36:39]
		ds_read_b128 a[52:55], v0 offset:51200
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[40:43], v[4:7], a[24:27], v[40:43]
		ds_read_b128 a[56:59], v0 offset:52224
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[44:47], v[4:7], a[28:31], v[44:47]
		ds_read_b128 a[60:63], v0 offset:53248
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[48:51], v[4:7], a[32:35], v[48:51]
		ds_read_b128 a[96:99], v0 offset:54272
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], v[4:7], a[36:39], v[52:55]
		ds_read_b128 a[100:103], v0 offset:55296
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], v[4:7], a[40:43], v[56:59]
		ds_read_b128 a[104:107], v0 offset:56320
		v_mfma_f32_16x16x32_f16 v[60:63], v[8:11], a[12:15], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[8:11], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[8:11], a[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[8:11], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[8:11], a[28:31], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[8:11], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[8:11], a[36:39], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[8:11], a[40:43], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], a[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[36:39], v[148:151]
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[24:27], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[28:31], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[152:155], v[20:23], a[40:43], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], v[24:27], a[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[24:27], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[24:27], a[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[24:27], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[24:27], a[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[24:27], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[24:27], a[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[0:3], a[36:39], v[212:215]
		v_mfma_f32_16x16x32_f16 v[188:191], a[0:3], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[0:3], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[0:3], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[0:3], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[0:3], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[0:3], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[216:219], a[0:3], a[40:43], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[4:7], a[40:43], v[248:251]
		v_mfma_f32_16x16x32_f16 v[220:223], a[4:7], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[4:7], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[4:7], a[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[4:7], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[4:7], a[28:31], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[4:7], a[32:35], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[4:7], a[36:39], v[244:247]
		v_mfma_f32_16x16x32_f16 a[88:91], a[8:11], a[36:39], a[88:91]
		v_mfma_f32_16x16x32_f16 a[64:67], a[8:11], a[12:15], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], a[8:11], a[16:19], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], a[8:11], a[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[8:11], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], a[8:11], a[28:31], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[8:11], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 a[92:95], a[8:11], a[40:43], a[92:95]
		ds_read_b128 v[4:7], v2 offset:16384
		ds_read_b128 v[8:11], v2 offset:17408
		ds_read_b128 v[16:19], v2 offset:18432
		ds_read_b128 v[20:23], v2 offset:19456
		ds_read_b128 v[24:27], v2 offset:20480
		ds_read_b128 a[0:3], v2 offset:21504
		ds_read_b128 a[4:7], v2 offset:22528
		ds_read_b128 v[252:255], v2 offset:23552
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], v[4:7], a[44:47], v[28:31]
		v_lshl_add_u32 v0, s9, 15, v12
		v_mfma_f32_16x16x32_f16 v[32:35], v[4:7], a[48:51], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[4:7], a[52:55], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[4:7], a[56:59], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[4:7], a[60:63], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[4:7], a[96:99], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[4:7], a[100:103], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[4:7], a[104:107], v[56:59]
		v_cvt_pk_f16_f32 v2, v28, v29
		v_cvt_pk_f16_f32 v3, v30, v31
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[8:11], a[104:107], v[88:91]
		v_mfma_f32_16x16x32_f16 v[60:63], v[8:11], a[44:47], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[8:11], a[48:51], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[8:11], a[52:55], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[8:11], a[56:59], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[8:11], a[60:63], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[8:11], a[96:99], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[8:11], a[100:103], v[84:87]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[100:103], v[116:119]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[44:47], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[48:51], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[52:55], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[60:63], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[96:99], v[112:115]
		v_mfma_f32_16x16x32_f16 v[120:123], v[16:19], a[104:107], v[120:123]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], v[20:23], a[104:107], v[152:155]
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[44:47], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[52:55], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[96:99], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[100:103], v[148:151]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[180:183], v[24:27], a[100:103], v[180:183]
		v_mfma_f32_16x16x32_f16 v[156:159], v[24:27], a[44:47], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[24:27], a[48:51], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[24:27], a[52:55], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[24:27], a[56:59], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[24:27], a[60:63], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[24:27], a[96:99], v[176:179]
		v_mfma_f32_16x16x32_f16 v[184:187], v[24:27], a[104:107], v[184:187]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[216:219], a[0:3], a[104:107], v[216:219]
		v_mfma_f32_16x16x32_f16 v[188:191], a[0:3], a[44:47], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[0:3], a[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[0:3], a[52:55], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[0:3], a[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[0:3], a[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[0:3], a[96:99], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[0:3], a[100:103], v[212:215]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[244:247], a[4:7], a[100:103], v[244:247]
		v_mfma_f32_16x16x32_f16 v[220:223], a[4:7], a[44:47], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[4:7], a[48:51], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[4:7], a[52:55], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[4:7], a[56:59], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[4:7], a[60:63], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[4:7], a[96:99], v[240:243]
		v_mfma_f32_16x16x32_f16 v[248:251], a[4:7], a[104:107], v[248:251]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[104:107], a[92:95]
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[44:47], a[64:67]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[48:51], a[68:71]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[52:55], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[56:59], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[60:63], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[96:99], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[100:103], a[88:91]
		s_mov_b32 s23, s15
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen
		v_cvt_pk_f16_f32 v2, v32, v33
		v_cvt_pk_f16_f32 v3, v34, v35
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:512
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:1024
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:1536
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:2048
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:2560
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:3072
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s8 offen offset:3584
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:512
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:1024
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:1536
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:2048
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:2560
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:3072
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s7 offen offset:3584
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s6 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:3072
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s17 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:512
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:1024
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:1536
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:2048
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:2560
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:3072
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s5 offen offset:3584
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:512
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:1024
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:1536
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:2048
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:2560
		v_cvt_pk_f16_f32 v2, v244, v245
		v_cvt_pk_f16_f32 v3, v246, v247
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:3072
		v_cvt_pk_f16_f32 v2, v248, v249
		v_cvt_pk_f16_f32 v3, v250, v251
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s16 offen offset:3584
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:512
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:1024
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:1536
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:2048
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:2560
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:3072
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s4 offen offset:3584
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
		.amdhsa_next_free_vgpr 400
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 144
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
    .vgpr_count:     400
    .agpr_count:     144
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 72
    wave.regalloc.agpr.dwords: 284
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
