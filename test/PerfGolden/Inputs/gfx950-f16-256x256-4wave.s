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
		v_readfirstlane_b32 s1, v0
		s_lshr_b32 s1, s1, 6
		s_mul_i32 s1, 0x410, s1
		s_and_b32 s8, s0, 1
		s_mul_i32 s11, 0x4100, s8
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_accvgpr_write_b32 a0, v2
		v_accvgpr_read_b32 v2, a0
		v_lshlrev_b32_e32 v2, 4, v2
		v_and_b32_e32 v0, 15, v0
		v_mov_b32_e32 v3, 0x410
		v_mul_lo_u32 v3, v3, v0
		s_lshr_b32 s12, s0, 1
		s_mul_i32 s13, 0x4100, s12
		s_mov_b32 m0, s1
		v_lshrrev_b32_e32 v0, 3, v1
		v_and_b32_e32 v4, 7, v1
		v_lshlrev_b32_e32 v4, 4, v4
		v_lshl_add_u32 v0, v0, 14, v4
		s_lshl_b32 s0, s0, 17
		s_lshr_b32 s24, s9, 3
		s_lshl_b32 s25, s24, 22
		s_add_i32 s25, s0, s25
		s_and_b32 s9, s9, 7
		s_lshl_b32 s26, s9, 24
		s_add_i32 s25, s25, s26
		buffer_load_dwordx4 v0, s[16:19], s25 offen lds
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s11, s25, 0x80000
		buffer_load_dwordx4 v0, s[16:19], s11 offen lds
		v_add3_u32 v5, s13, v2, v3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s11, s25, 0x100000
		buffer_load_dwordx4 v0, s[16:19], s11 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s2, s25, 0x180000
		buffer_load_dwordx4 v0, s[16:19], s2 offen lds
		s_mov_b32 s2, s1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s25, 0x200000
		v_add_u32_e32 v6, s25, v0
		buffer_load_dwordx4 v0, s[16:19], s3 offen lds
		v_mov_b32_e32 v7, v5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s25, 0x280000
		buffer_load_dwordx4 v0, s[16:19], s3 offen lds
		v_add_u32_e32 v8, 0x100080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s25, 0x300000
		buffer_load_dwordx4 v0, s[16:19], s3 offen lds
		v_add_u32_e32 v9, 0x280080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s25, 0x380000
		s_lshl_b32 s10, s10, 22
		buffer_load_dwordx4 v0, s[16:19], s3 offen lds
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s0, s10, s0
		buffer_load_dwordx4 v0, s[20:23], s0 offen lds
		v_add_u32_e32 v10, s0, v0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s0, 0x80000
		buffer_load_dwordx4 v0, s[20:23], s3 offen lds
		v_add_u32_e32 v11, 0x100080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s0, 0x100000
		buffer_load_dwordx4 v0, s[20:23], s3 offen lds
		v_add_u32_e32 v12, 0x280080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s0, 0x180000
		buffer_load_dwordx4 v0, s[20:23], s3 offen lds
		v_and_b32_e32 v1, 15, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s0, 0x200000
		buffer_load_dwordx4 v0, s[20:23], s3 offen lds
		s_mov_b32 s3, 1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s11, s0, 0x280000
		buffer_load_dwordx4 v0, s[20:23], s11 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s0, 0x300000
		buffer_load_dwordx4 v0, s[20:23], s4 offen lds
		s_mov_b32 s4, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x380000
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_mov_b32_e32 v13, v4
		s_add_i32 m0, m0, 0xffff0c40
		s_add_i32 s5, s25, 0x80
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v14, 0x80, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x80080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v15, 0x80080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x100080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v16, 0x180080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x180080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v17, 0x200080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x200080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v18, 0x300080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x280080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v6, 0x380080, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x300080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v19, 0x80, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s25, 0x380080
		buffer_load_dwordx4 v0, s[16:19], s5 offen lds
		v_add_u32_e32 v20, 0x80080, v10
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s5, s0, 0x80
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_add_u32_e32 v21, 0x180080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x80080
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_add_u32_e32 v22, 0x200080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x100080
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_add_u32_e32 v23, 0x300080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x180080
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_add_u32_e32 v10, 0x380080, v10
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x200080
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		v_lshlrev_b32_e32 v1, 4, v1
		v_accvgpr_write_b32 a1, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s0, 0x280080
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		s_add_i32 s5, s13, 0x10000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s11, s0, 0x300080
		buffer_load_dwordx4 v0, s[20:23], s11 offen lds
		s_add_i32 s0, s0, 0x380080
		s_add_i32 m0, m0, 0x1040
		v_add3_u32 v1, s5, v2, v3
		buffer_load_dwordx4 v0, s[20:23], s0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[8:11], v4
		ds_read_b128 a[12:15], v4 offset:128
		ds_read_b128 a[16:19], v4 offset:256
		ds_read_b128 a[20:23], v4 offset:384
		ds_read_b128 a[24:27], v4 offset:512
		ds_read_b128 a[28:31], v4 offset:640
		ds_read_b128 a[32:35], v4 offset:768
		ds_read_b128 a[36:39], v4 offset:896
		ds_read_b128 a[40:43], v1 offset:1024
		ds_read_b128 a[44:47], v1 offset:1152
		ds_read_b128 a[48:51], v1 offset:1280
		ds_read_b128 a[52:55], v1 offset:1408
		ds_read_b128 a[56:59], v1 offset:1536
		ds_read_b128 a[60:63], v1 offset:1664
		ds_read_b128 a[64:67], v1 offset:1792
		ds_read_b128 a[68:71], v1 offset:1920
		s_cmp_eq_u32 s8, 0
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
		v_mov_b64_e32 v[0:1], 0
		v_mov_b64_e32 v[2:3], 0
		v_mov_b64_e32 v[24:25], 0
		v_mov_b64_e32 v[26:27], 0
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
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
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		s_mov_b32 s0, s4
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		ds_read_b128 a[92:95], v13 offset:64
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		v_mfma_f32_16x16x32_f16 v[0:3], a[40:43], a[12:15], v[0:3]
		s_add_i32 s4, s4, 1
		s_and_b32 s5, s4, 1
		s_mul_i32 s5, 0x8200, s5
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[16:19], v[24:27]
		ds_read_b128 a[96:99], v13 offset:192
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[20:23], v[28:31]
		s_mul_i32 s11, 0xffffdf80, s0
		s_sub_i32 s0, s3, s0
		s_add_i32 s11, s11, 0x2080
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[24:27], v[32:35]
		ds_read_b128 a[100:103], v13 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[28:31], v[36:39]
		s_mul_i32 s11, s11, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[32:35], v[40:43]
		ds_read_b128 a[104:107], v13 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[36:39], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[36:39], v[76:79]
		ds_read_b128 a[108:111], v13 offset:576
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[28:31], v[68:71]
		ds_read_b128 a[112:115], v13 offset:704
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[20:23], v[60:63]
		ds_read_b128 a[116:119], v13 offset:832
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[12:15], v[52:55]
		ds_read_b128 a[120:123], v13 offset:960
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[8:11], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[28:31], v[100:103]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[32:35], v[104:107]
		s_mov_b32 m0, s2
		ds_read_b128 a[40:43], v7 offset:1088
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[36:39], v[140:143]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v7 offset:1216
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[28:31], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[24:27], v[128:131]
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[20:23], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[16:19], v[120:123]
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		ds_read_b128 a[124:127], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[12:15], v[116:119]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[112:115], a[52:55], a[8:11], v[112:115]
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], a[56:59], a[8:11], v[144:147]
		ds_read_b128 a[52:55], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[12:15], v[148:151]
		s_add_i32 s2, s1, s5
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[20:23], v[156:159]
		ds_read_b128 a[128:131], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[28:31], v[164:167]
		ds_read_b128 a[132:135], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[36:39], v[172:175]
		v_add_u32_e32 v13, s11, v4
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[36:39], v[204:207]
		ds_read_b128 a[136:139], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[64:67], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[20:23], v[220:223]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[24:27], v[224:227]
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[28:31], v[228:231]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[32:35], v[232:235]
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[16:19], a[72:75]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[12:15], v[244:247]
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[68:71], a[8:11], v[240:243]
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[92:95], a[4:7]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v7, s11, v5
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_add_u32_e32 v252, 0x10000, v7
		v_mfma_f32_16x16x32_f16 v[0:3], a[40:43], a[96:99], v[0:3]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[100:103], v[24:27]
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[104:107], v[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[108:111], v[32:35]
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[112:115], v[36:39]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[116:119], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[120:123], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[120:123], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[116:119], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[96:99], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[92:95], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[92:95], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[96:99], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[100:103], v[88:91]
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[116:119], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[120:123], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[124:127], a[120:123], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[124:127], a[116:119], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[124:127], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[124:127], a[108:111], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[124:127], a[104:107], v[124:127]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[120:123], a[124:127], a[100:103], v[120:123]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[8:11], v13
		v_mfma_f32_16x16x32_f16 v[116:119], a[124:127], a[96:99], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[124:127], a[92:95], v[112:115]
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		ds_read_b128 a[40:43], v252 offset:1024
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[92:95], v[144:147]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[96:99], v[148:151]
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		ds_read_b128 a[12:15], v13 offset:128
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[100:103], v[152:155]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v252 offset:1152
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[112:115], v[164:167]
		ds_read_b128 a[16:19], v13 offset:256
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[116:119], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[120:123], v[172:175]
		ds_read_b128 a[48:51], v252 offset:1280
		v_mfma_f32_16x16x32_f16 v[204:207], a[128:131], a[120:123], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[128:131], a[116:119], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[128:131], a[112:115], v[196:199]
		ds_read_b128 a[20:23], v13 offset:384
		v_mfma_f32_16x16x32_f16 v[192:195], a[128:131], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[128:131], a[104:107], v[188:191]
		ds_read_b128 a[52:55], v252 offset:1408
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[96:99], v[180:183]
		ds_read_b128 a[24:27], v13 offset:512
		v_mfma_f32_16x16x32_f16 v[176:179], a[128:131], a[92:95], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[132:135], a[92:95], v[208:211]
		ds_read_b128 a[56:59], v252 offset:1536
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[100:103], v[216:219]
		ds_read_b128 a[28:31], v13 offset:640
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[108:111], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[112:115], v[228:231]
		ds_read_b128 a[60:63], v252 offset:1664
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[116:119], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[120:123], v[236:239]
		ds_read_b128 a[32:35], v13 offset:768
		v_mfma_f32_16x16x32_f16 a[88:91], a[136:139], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[136:139], a[116:119], a[84:87]
		ds_read_b128 a[64:67], v252 offset:1792
		v_mfma_f32_16x16x32_f16 a[80:83], a[136:139], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[136:139], a[108:111], a[76:79]
		ds_read_b128 a[36:39], v13 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], a[136:139], a[104:107], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[136:139], a[100:103], a[72:75]
		ds_read_b128 a[68:71], v252 offset:1920
		v_mfma_f32_16x16x32_f16 v[244:247], a[136:139], a[96:99], v[244:247]
		s_cmp_lt_i32 s4, 0x7e
		v_mfma_f32_16x16x32_f16 v[240:243], a[136:139], a[92:95], v[240:243]
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
		v_mov_b64_e32 v[0:1], 0
		v_mov_b64_e32 v[2:3], 0
		v_mov_b64_e32 v[24:25], 0
		v_mov_b64_e32 v[26:27], 0
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
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
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		s_mov_b32 s0, s4
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		ds_read_b128 a[92:95], v13 offset:64
		v_mfma_f32_16x16x32_f16 v[0:3], a[40:43], a[12:15], v[0:3]
		s_add_i32 s4, s4, 1
		s_and_b32 s5, s4, 1
		s_mul_i32 s5, 0x8200, s5
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[16:19], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[20:23], v[28:31]
		ds_read_b128 a[96:99], v13 offset:192
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[24:27], v[32:35]
		ds_read_b128 a[100:103], v13 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[28:31], v[36:39]
		s_mul_i32 s11, 0xffffdf80, s0
		s_sub_i32 s0, s3, s0
		s_add_i32 s11, s11, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[32:35], v[40:43]
		ds_read_b128 a[104:107], v13 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[36:39], v[44:47]
		s_mul_i32 s11, s11, 4
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[36:39], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[32:35], v[72:75]
		ds_read_b128 a[108:111], v13 offset:576
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[28:31], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[24:27], v[64:67]
		ds_read_b128 a[112:115], v13 offset:704
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[16:19], v[56:59]
		ds_read_b128 a[116:119], v13 offset:832
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[8:11], v[48:51]
		ds_read_b128 a[120:123], v13 offset:960
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[28:31], v[100:103]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[32:35], v[104:107]
		s_mov_b32 m0, s2
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[36:39], v[140:143]
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		ds_read_b128 a[40:43], v7 offset:1088
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[28:31], v[132:135]
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		ds_read_b128 a[44:47], v7 offset:1216
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[24:27], v[128:131]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[16:19], v[120:123]
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[52:55], a[8:11], v[112:115]
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		ds_read_b128 a[52:55], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[144:147], a[56:59], a[8:11], v[144:147]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[124:127], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[12:15], v[148:151]
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[16:19], v[152:155]
		s_add_i32 s2, s1, s5
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[24:27], v[160:163]
		ds_read_b128 a[128:131], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[32:35], v[168:171]
		ds_read_b128 a[132:135], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[36:39], v[172:175]
		v_add_u32_e32 v13, s11, v4
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[32:35], v[200:203]
		ds_read_b128 a[136:139], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[64:67], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[20:23], v[220:223]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[28:31], v[228:231]
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[32:35], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[36:39], v[236:239]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[12:15], v[244:247]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[240:243], a[68:71], a[8:11], v[240:243]
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s11, v5
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[92:95], a[4:7]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v252, 0x10000, v7
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[0:3], a[40:43], a[96:99], v[0:3]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[100:103], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[104:107], v[28:31]
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[108:111], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[112:115], v[36:39]
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[116:119], v[40:43]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[120:123], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[120:123], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[116:119], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[96:99], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[92:95], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[92:95], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[96:99], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[104:107], v[92:95]
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[116:119], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[120:123], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[120:123], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[116:119], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[108:111], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[104:107], v[124:127]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[100:103], v[120:123]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		ds_read_b128 a[8:11], v13
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[96:99], v[116:119]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[40:43], v252 offset:1024
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		ds_read_b128 a[12:15], v13 offset:128
		v_mfma_f32_16x16x32_f16 v[112:115], a[52:55], a[92:95], v[112:115]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v252 offset:1152
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], a[124:127], a[92:95], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[124:127], a[96:99], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[124:127], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[124:127], a[104:107], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[124:127], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[124:127], a[112:115], v[164:167]
		ds_read_b128 a[16:19], v13 offset:256
		v_mfma_f32_16x16x32_f16 v[168:171], a[124:127], a[116:119], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[124:127], a[120:123], v[172:175]
		ds_read_b128 a[48:51], v252 offset:1280
		v_mfma_f32_16x16x32_f16 v[204:207], a[128:131], a[120:123], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[128:131], a[116:119], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[128:131], a[112:115], v[196:199]
		ds_read_b128 a[20:23], v13 offset:384
		v_mfma_f32_16x16x32_f16 v[192:195], a[128:131], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[128:131], a[104:107], v[188:191]
		ds_read_b128 a[52:55], v252 offset:1408
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[96:99], v[180:183]
		ds_read_b128 a[24:27], v13 offset:512
		v_mfma_f32_16x16x32_f16 v[176:179], a[128:131], a[92:95], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[132:135], a[92:95], v[208:211]
		ds_read_b128 a[56:59], v252 offset:1536
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[96:99], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[100:103], v[216:219]
		ds_read_b128 a[28:31], v13 offset:640
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[108:111], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[112:115], v[228:231]
		ds_read_b128 a[60:63], v252 offset:1664
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[116:119], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[120:123], v[236:239]
		ds_read_b128 a[32:35], v13 offset:768
		v_mfma_f32_16x16x32_f16 a[88:91], a[136:139], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[136:139], a[116:119], a[84:87]
		ds_read_b128 a[64:67], v252 offset:1792
		v_mfma_f32_16x16x32_f16 a[80:83], a[136:139], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[136:139], a[108:111], a[76:79]
		ds_read_b128 a[36:39], v13 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], a[136:139], a[104:107], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[136:139], a[100:103], a[72:75]
		ds_read_b128 a[68:71], v252 offset:1920
		v_mfma_f32_16x16x32_f16 v[244:247], a[136:139], a[96:99], v[244:247]
		s_cmp_lt_i32 s4, 0x7e
		v_mfma_f32_16x16x32_f16 v[240:243], a[136:139], a[92:95], v[240:243]
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v6, 0x10000, v7
		ds_read_b128 v[8:11], v6 offset:1088
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[8:11], v[48:51]
		ds_read_b128 v[16:19], v6 offset:1216
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[8:11], v[80:83]
		ds_read_b128 v[20:23], v6 offset:1344
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[112:115], a[52:55], a[8:11], v[112:115]
		ds_read_b128 a[92:95], v6 offset:1472
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[144:147], a[56:59], a[8:11], v[144:147]
		ds_read_b128 a[96:99], v6 offset:1600
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[8:11], v[176:179]
		ds_read_b128 a[100:103], v6 offset:1728
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[208:211], a[64:67], a[8:11], v[208:211]
		ds_read_b128 a[104:107], v6 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[240:243], a[68:71], a[8:11], v[240:243]
		ds_read_b128 a[8:11], v6 offset:1984
		v_mfma_f32_16x16x32_f16 v[0:3], a[40:43], a[12:15], v[0:3]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[12:15], v[244:247]
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[16:19], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[20:23], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[24:27], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[24:27], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[28:31], v[228:231]
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[28:31], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[28:31], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[32:35], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[32:35], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[36:39], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[36:39], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		ds_read_b128 a[12:15], v13 offset:64
		ds_read_b128 a[16:19], v13 offset:192
		ds_read_b128 a[20:23], v13 offset:320
		ds_read_b128 a[24:27], v13 offset:448
		ds_read_b128 a[28:31], v13 offset:576
		ds_read_b128 a[32:35], v13 offset:704
		ds_read_b128 a[36:39], v13 offset:832
		ds_read_b128 v[252:255], v13 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], v[8:11], a[12:15], a[4:7]
		s_mul_i32 s0, 0xffffdf80, s0
		s_add_i32 s0, s0, 0x2080
		s_mul_i32 s0, s0, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[0:3], v[8:11], a[16:19], v[0:3]
		v_add_u32_e32 v4, s0, v4
		v_add_u32_e32 v5, s0, v5
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[20:23], v[24:27]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[24:27], v[28:31]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[28:31], v[32:35]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[32:35], v[36:39]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[36:39], v[40:43]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], v[252:255], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], v[252:255], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[36:39], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[32:35], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[28:31], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], a[24:27], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], a[20:23], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], a[16:19], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], a[12:15], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], v[20:23], a[12:15], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[20:23], a[16:19], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[20:23], a[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], a[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[28:31], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], v[252:255], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[92:95], v[252:255], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[92:95], a[36:39], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[92:95], a[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[92:95], a[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[92:95], a[24:27], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[92:95], a[20:23], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[92:95], a[16:19], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[92:95], a[12:15], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[96:99], a[12:15], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[96:99], a[16:19], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[96:99], a[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[96:99], a[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[96:99], a[28:31], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[96:99], a[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[96:99], a[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[96:99], v[252:255], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[100:103], v[252:255], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[100:103], a[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[100:103], a[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[100:103], a[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[100:103], a[24:27], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[100:103], a[20:23], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[100:103], a[16:19], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[100:103], a[12:15], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[104:107], a[12:15], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[104:107], a[16:19], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[104:107], a[20:23], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[104:107], a[24:27], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[104:107], a[28:31], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[104:107], a[32:35], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[104:107], a[36:39], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[104:107], v[252:255], v[236:239]
		v_mfma_f32_16x16x32_f16 a[88:91], a[8:11], v[252:255], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[8:11], a[36:39], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[8:11], a[32:35], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[8:11], a[28:31], a[76:79]
		v_mfma_f32_16x16x32_f16 v[248:251], a[8:11], a[24:27], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[8:11], a[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 v[244:247], a[8:11], a[16:19], v[244:247]
		v_mfma_f32_16x16x32_f16 v[240:243], a[8:11], a[12:15], v[240:243]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v4
		ds_read_b128 v[12:15], v4 offset:128
		ds_read_b128 v[16:19], v4 offset:256
		ds_read_b128 v[20:23], v4 offset:384
		ds_read_b128 a[8:11], v4 offset:512
		ds_read_b128 a[12:15], v4 offset:640
		ds_read_b128 a[16:19], v4 offset:768
		ds_read_b128 a[20:23], v4 offset:896
		v_add_u32_e32 v5, 0x10000, v5
		ds_read_b128 a[24:27], v5 offset:1024
		ds_read_b128 a[28:31], v5 offset:1152
		ds_read_b128 a[32:35], v5 offset:1280
		ds_read_b128 a[36:39], v5 offset:1408
		ds_read_b128 a[40:43], v5 offset:1536
		ds_read_b128 a[44:47], v5 offset:1664
		ds_read_b128 a[48:51], v5 offset:1792
		ds_read_b128 a[52:55], v5 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[24:27], v[8:11], a[4:7]
		ds_read_b128 a[56:59], v5 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[48:51], a[28:31], v[8:11], v[48:51]
		ds_read_b128 a[60:63], v5 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[80:83], a[32:35], v[8:11], v[80:83]
		ds_read_b128 a[64:67], v5 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[112:115], a[36:39], v[8:11], v[112:115]
		ds_read_b128 a[68:71], v5 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[144:147], a[40:43], v[8:11], v[144:147]
		ds_read_b128 a[92:95], v5 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[176:179], a[44:47], v[8:11], v[176:179]
		ds_read_b128 a[96:99], v5 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[208:211], a[48:51], v[8:11], v[208:211]
		ds_read_b128 v[252:255], v5 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], v[8:11], v[240:243]
		ds_read_b128 a[100:103], v5 offset:1984
		v_mfma_f32_16x16x32_f16 v[0:3], a[24:27], v[12:15], v[0:3]
		v_mfma_f32_16x16x32_f16 v[52:55], a[28:31], v[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[32:35], v[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[36:39], v[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[40:43], v[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[44:47], v[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[48:51], v[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], v[12:15], v[244:247]
		v_mfma_f32_16x16x32_f16 a[72:75], a[52:55], v[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], a[24:27], v[16:19], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[28:31], v[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[32:35], v[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[36:39], v[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[40:43], v[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[44:47], v[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[48:51], v[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[48:51], v[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[28:31], a[24:27], v[20:23], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[28:31], v[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[32:35], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[36:39], v[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[40:43], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[44:47], v[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[248:251], a[52:55], v[20:23], v[248:251]
		v_mfma_f32_16x16x32_f16 a[76:79], a[52:55], a[8:11], a[76:79]
		v_mfma_f32_16x16x32_f16 v[32:35], a[24:27], a[8:11], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[28:31], a[8:11], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[32:35], a[8:11], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[36:39], a[8:11], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[40:43], a[8:11], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[44:47], a[8:11], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[48:51], a[8:11], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[48:51], a[12:15], v[228:231]
		v_mfma_f32_16x16x32_f16 v[36:39], a[24:27], a[12:15], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[28:31], a[12:15], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[32:35], a[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[36:39], a[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[40:43], a[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[44:47], a[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 a[80:83], a[52:55], a[12:15], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[52:55], a[16:19], a[84:87]
		v_mfma_f32_16x16x32_f16 v[40:43], a[24:27], a[16:19], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[28:31], a[16:19], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[32:35], a[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[36:39], a[16:19], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[40:43], a[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[44:47], a[16:19], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[48:51], a[16:19], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[48:51], a[20:23], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[24:27], a[20:23], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[28:31], a[20:23], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[32:35], a[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[36:39], a[20:23], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[40:43], a[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[44:47], a[20:23], v[204:207]
		v_mfma_f32_16x16x32_f16 a[88:91], a[52:55], a[20:23], a[88:91]
		ds_read_b128 a[8:11], v4 offset:64
		ds_read_b128 a[12:15], v4 offset:192
		ds_read_b128 a[16:19], v4 offset:320
		ds_read_b128 a[20:23], v4 offset:448
		ds_read_b128 a[24:27], v4 offset:576
		ds_read_b128 v[8:11], v4 offset:704
		ds_read_b128 v[12:15], v4 offset:832
		ds_read_b128 v[16:19], v4 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[56:59], a[8:11], a[4:7]
		v_accvgpr_read_b32 v4, a1
		v_accvgpr_read_b32 v5, a0
		v_lshl_add_u32 v4, v5, 19, v4
		s_lshl_b32 s0, s12, 21
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[0:3], a[56:59], a[12:15], v[0:3]
		s_add_i32 s0, s10, s0
		s_lshl_b32 s1, s24, 9
		s_add_i32 s0, s0, s1
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[24:27], a[56:59], a[16:19], v[24:27]
		s_lshl_b32 s1, s9, 11
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s8, 8
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[28:31], a[56:59], a[20:23], v[28:31]
		v_accvgpr_read_b32 v5, a4
		v_cvt_pk_f16_f32 v20, v5, v0
		s_add_i32 s0, s0, s1
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[32:35], a[56:59], a[24:27], v[32:35]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[36:39], a[56:59], v[8:11], v[36:39]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[40:43], a[56:59], v[12:15], v[40:43]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[44:47], a[56:59], v[16:19], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[60:63], v[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[60:63], v[12:15], v[72:75]
		v_cvt_pk_f16_f32 v21, v24, v28
		v_mfma_f32_16x16x32_f16 v[68:71], a[60:63], v[8:11], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[60:63], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[60:63], a[20:23], v[60:63]
		v_cvt_pk_f16_f32 v22, v32, v36
		v_mfma_f32_16x16x32_f16 v[56:59], a[60:63], a[16:19], v[56:59]
		v_cvt_pk_f16_f32 v23, v40, v44
		v_mfma_f32_16x16x32_f16 v[52:55], a[60:63], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[60:63], a[8:11], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[64:67], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[64:67], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[64:67], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[64:67], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[64:67], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[64:67], v[8:11], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[64:67], v[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[64:67], v[16:19], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[68:71], v[16:19], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[68:71], v[12:15], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[68:71], v[8:11], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[68:71], a[24:27], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[68:71], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[68:71], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[68:71], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[68:71], a[8:11], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[92:95], a[8:11], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[92:95], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[92:95], a[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[92:95], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[92:95], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[92:95], v[8:11], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[92:95], v[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[92:95], v[16:19], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], v[16:19], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[96:99], v[12:15], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[96:99], v[8:11], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[96:99], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[96:99], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[96:99], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[96:99], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], v[252:255], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[252:255], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[252:255], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[252:255], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[252:255], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[252:255], v[8:11], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[252:255], v[12:15], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], v[16:19], v[236:239]
		v_mfma_f32_16x16x32_f16 a[88:91], a[100:103], v[16:19], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[100:103], v[12:15], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[100:103], v[8:11], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[100:103], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 v[248:251], a[100:103], a[20:23], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[100:103], a[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[244:247], a[100:103], a[12:15], v[244:247]
		v_mfma_f32_16x16x32_f16 v[240:243], a[100:103], a[8:11], v[240:243]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx4 v[20:23], v4, s[12:15], s0 offen sc0 nt
		s_add_i32 s1, s0, 0x4000
		v_cvt_pk_f16_f32 v8, v48, v52
		v_cvt_pk_f16_f32 v9, v56, v60
		v_cvt_pk_f16_f32 v10, v64, v68
		v_cvt_pk_f16_f32 v11, v72, v76
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x8000
		v_cvt_pk_f16_f32 v8, v80, v84
		v_cvt_pk_f16_f32 v9, v88, v92
		v_cvt_pk_f16_f32 v10, v96, v100
		v_cvt_pk_f16_f32 v11, v104, v108
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0xc000
		v_cvt_pk_f16_f32 v8, v112, v116
		v_cvt_pk_f16_f32 v9, v120, v124
		v_cvt_pk_f16_f32 v10, v128, v132
		v_cvt_pk_f16_f32 v11, v136, v140
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x10000
		v_cvt_pk_f16_f32 v8, v144, v148
		v_cvt_pk_f16_f32 v9, v152, v156
		v_cvt_pk_f16_f32 v10, v160, v164
		v_cvt_pk_f16_f32 v11, v168, v172
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x14000
		v_cvt_pk_f16_f32 v8, v176, v180
		v_cvt_pk_f16_f32 v9, v184, v188
		v_cvt_pk_f16_f32 v10, v192, v196
		v_cvt_pk_f16_f32 v11, v200, v204
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x18000
		v_cvt_pk_f16_f32 v8, v208, v212
		v_cvt_pk_f16_f32 v9, v216, v220
		v_cvt_pk_f16_f32 v10, v224, v228
		v_cvt_pk_f16_f32 v11, v232, v236
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x1c000
		v_cvt_pk_f16_f32 v8, v240, v244
		v_accvgpr_read_b32 v0, a72
		v_cvt_pk_f16_f32 v9, v0, v248
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v5, a80
		v_cvt_pk_f16_f32 v10, v0, v5
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v5, a88
		v_cvt_pk_f16_f32 v11, v0, v5
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x20000
		v_accvgpr_read_b32 v0, a5
		v_cvt_pk_f16_f32 v8, v0, v1
		v_cvt_pk_f16_f32 v9, v25, v29
		v_cvt_pk_f16_f32 v10, v33, v37
		v_cvt_pk_f16_f32 v11, v41, v45
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x24000
		v_cvt_pk_f16_f32 v8, v49, v53
		v_cvt_pk_f16_f32 v9, v57, v61
		v_cvt_pk_f16_f32 v10, v65, v69
		v_cvt_pk_f16_f32 v11, v73, v77
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x28000
		v_cvt_pk_f16_f32 v8, v81, v85
		v_cvt_pk_f16_f32 v9, v89, v93
		v_cvt_pk_f16_f32 v10, v97, v101
		v_cvt_pk_f16_f32 v11, v105, v109
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x2c000
		v_cvt_pk_f16_f32 v8, v113, v117
		v_cvt_pk_f16_f32 v9, v121, v125
		v_cvt_pk_f16_f32 v10, v129, v133
		v_cvt_pk_f16_f32 v11, v137, v141
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x30000
		v_cvt_pk_f16_f32 v8, v145, v149
		v_cvt_pk_f16_f32 v9, v153, v157
		v_cvt_pk_f16_f32 v10, v161, v165
		v_cvt_pk_f16_f32 v11, v169, v173
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x34000
		v_cvt_pk_f16_f32 v8, v177, v181
		v_cvt_pk_f16_f32 v9, v185, v189
		v_cvt_pk_f16_f32 v10, v193, v197
		v_cvt_pk_f16_f32 v11, v201, v205
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x38000
		v_cvt_pk_f16_f32 v8, v209, v213
		v_cvt_pk_f16_f32 v9, v217, v221
		v_cvt_pk_f16_f32 v10, v225, v229
		v_cvt_pk_f16_f32 v11, v233, v237
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x3c000
		v_cvt_pk_f16_f32 v8, v241, v245
		v_accvgpr_read_b32 v0, a73
		v_cvt_pk_f16_f32 v9, v0, v249
		v_accvgpr_read_b32 v0, a77
		v_accvgpr_read_b32 v1, a81
		v_cvt_pk_f16_f32 v10, v0, v1
		v_accvgpr_read_b32 v0, a85
		v_accvgpr_read_b32 v1, a89
		v_cvt_pk_f16_f32 v11, v0, v1
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x40000
		v_accvgpr_read_b32 v0, a6
		v_cvt_pk_f16_f32 v8, v0, v2
		v_cvt_pk_f16_f32 v9, v26, v30
		v_cvt_pk_f16_f32 v10, v34, v38
		v_cvt_pk_f16_f32 v11, v42, v46
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x44000
		v_cvt_pk_f16_f32 v8, v50, v54
		v_cvt_pk_f16_f32 v9, v58, v62
		v_cvt_pk_f16_f32 v10, v66, v70
		v_cvt_pk_f16_f32 v11, v74, v78
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x48000
		v_cvt_pk_f16_f32 v8, v82, v86
		v_cvt_pk_f16_f32 v9, v90, v94
		v_cvt_pk_f16_f32 v10, v98, v102
		v_cvt_pk_f16_f32 v11, v106, v110
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x4c000
		v_cvt_pk_f16_f32 v8, v114, v118
		v_cvt_pk_f16_f32 v9, v122, v126
		v_cvt_pk_f16_f32 v10, v130, v134
		v_cvt_pk_f16_f32 v11, v138, v142
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x50000
		v_cvt_pk_f16_f32 v8, v146, v150
		v_cvt_pk_f16_f32 v9, v154, v158
		v_cvt_pk_f16_f32 v10, v162, v166
		v_cvt_pk_f16_f32 v11, v170, v174
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x54000
		v_cvt_pk_f16_f32 v8, v178, v182
		v_cvt_pk_f16_f32 v9, v186, v190
		v_cvt_pk_f16_f32 v10, v194, v198
		v_cvt_pk_f16_f32 v11, v202, v206
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x58000
		v_cvt_pk_f16_f32 v8, v210, v214
		v_cvt_pk_f16_f32 v9, v218, v222
		v_cvt_pk_f16_f32 v10, v226, v230
		v_cvt_pk_f16_f32 v11, v234, v238
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x5c000
		v_cvt_pk_f16_f32 v8, v242, v246
		v_accvgpr_read_b32 v0, a74
		v_cvt_pk_f16_f32 v9, v0, v250
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v1, a82
		v_cvt_pk_f16_f32 v10, v0, v1
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v1, a90
		v_cvt_pk_f16_f32 v11, v0, v1
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x60000
		v_accvgpr_read_b32 v0, a7
		v_cvt_pk_f16_f32 v8, v0, v3
		v_cvt_pk_f16_f32 v9, v27, v31
		v_cvt_pk_f16_f32 v10, v35, v39
		v_cvt_pk_f16_f32 v11, v43, v47
		buffer_store_dwordx4 v[8:11], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x64000
		v_cvt_pk_f16_f32 v0, v51, v55
		v_cvt_pk_f16_f32 v1, v59, v63
		v_cvt_pk_f16_f32 v2, v67, v71
		v_cvt_pk_f16_f32 v3, v75, v79
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x68000
		v_cvt_pk_f16_f32 v0, v83, v87
		v_cvt_pk_f16_f32 v1, v91, v95
		v_cvt_pk_f16_f32 v2, v99, v103
		v_cvt_pk_f16_f32 v3, v107, v111
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6c000
		v_cvt_pk_f16_f32 v0, v115, v119
		v_cvt_pk_f16_f32 v1, v123, v127
		v_cvt_pk_f16_f32 v2, v131, v135
		v_cvt_pk_f16_f32 v3, v139, v143
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x70000
		v_cvt_pk_f16_f32 v0, v147, v151
		v_cvt_pk_f16_f32 v1, v155, v159
		v_cvt_pk_f16_f32 v2, v163, v167
		v_cvt_pk_f16_f32 v3, v171, v175
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x74000
		v_cvt_pk_f16_f32 v0, v179, v183
		v_cvt_pk_f16_f32 v1, v187, v191
		v_cvt_pk_f16_f32 v2, v195, v199
		v_cvt_pk_f16_f32 v3, v203, v207
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x78000
		v_cvt_pk_f16_f32 v0, v211, v215
		v_cvt_pk_f16_f32 v1, v219, v223
		v_cvt_pk_f16_f32 v2, v227, v231
		v_cvt_pk_f16_f32 v3, v235, v239
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s1 offen sc0 nt
		s_add_i32 s0, s0, 0x7c000
		v_cvt_pk_f16_f32 v0, v243, v247
		v_accvgpr_read_b32 v1, a75
		v_cvt_pk_f16_f32 v1, v1, v251
		v_accvgpr_read_b32 v2, a79
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_f16_f32 v2, v2, v3
		v_accvgpr_read_b32 v3, a87
		v_accvgpr_read_b32 v5, a91
		v_cvt_pk_f16_f32 v3, v3, v5
		buffer_store_dwordx4 v[0:3], v4, s[12:15], s0 offen sc0 nt
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 133120
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
		.amdhsa_next_free_vgpr 396
		.amdhsa_next_free_sgpr 27
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 140
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 27
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
    .group_segment_fixed_size: 133120
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     27
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     396
    .agpr_count:     140
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 93
    wave.regalloc.agpr.dwords: 362
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
