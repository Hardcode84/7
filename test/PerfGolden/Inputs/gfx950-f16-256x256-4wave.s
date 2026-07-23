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
		s_mul_i32 s1, 0x410, s0
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_accvgpr_write_b32 a0, v2
		v_accvgpr_read_b32 v2, a0
		v_lshlrev_b32_e32 v2, 4, v2
		v_and_b32_e32 v3, 15, v0
		v_mov_b32_e32 v4, 0x410
		v_mul_lo_u32 v4, v4, v3
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_accvgpr_write_b32 a1, v3
		v_accvgpr_read_b32 v3, a1
		v_mov_b32_e32 v5, 0x4100
		v_mul_lo_u32 v5, v5, v3
		v_lshrrev_b32_e32 v0, 7, v0
		v_accvgpr_write_b32 a2, v0
		v_accvgpr_read_b32 v0, a2
		v_mov_b32_e32 v3, 0x4100
		v_mul_lo_u32 v3, v3, v0
		v_add_u32_e32 v0, 0x8200, v3
		s_mov_b32 m0, s1
		v_lshrrev_b32_e32 v3, 3, v1
		v_lshlrev_b32_e32 v3, 14, v3
		v_lshl_add_u32 v3, s0, 17, v3
		v_and_b32_e32 v6, 7, v1
		v_lshl_add_u32 v3, v6, 4, v3
		s_lshr_b32 s0, s9, 3
		s_lshl_b32 s8, s0, 22
		s_and_b32 s9, s9, 7
		s_lshl_b32 s11, s9, 24
		s_add_i32 s12, s8, s11
		buffer_load_dwordx4 v3, s[16:19], s12 offen lds
		v_add3_u32 v5, v2, v4, v5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s13, s8, 0x80000
		s_add_i32 s13, s13, s11
		v_add3_u32 v0, v0, v2, v4
		buffer_load_dwordx4 v3, s[16:19], s13 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s13, s8, 0x100000
		s_add_i32 s13, s13, s11
		buffer_load_dwordx4 v3, s[16:19], s13 offen lds
		v_and_b32_e32 v1, 15, v1
		v_accvgpr_write_b32 a3, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s13, s8, 0x180000
		s_add_i32 s13, s13, s11
		v_add_u32_e32 v1, s12, v3
		buffer_load_dwordx4 v3, s[16:19], s13 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s8, 0x200000
		s_add_i32 s4, s4, s11
		buffer_load_dwordx4 v3, s[16:19], s4 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s2, s8, 0x280000
		s_add_i32 s2, s2, s11
		buffer_load_dwordx4 v3, s[16:19], s2 offen lds
		s_mov_b32 s2, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s8, 0x300000
		s_add_i32 s3, s3, s11
		buffer_load_dwordx4 v3, s[16:19], s3 offen lds
		v_mov_b32_e32 v2, v0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s3, s8, 0x380000
		s_add_i32 s3, s3, s11
		v_add_u32_e32 v4, 0x80, v1
		buffer_load_dwordx4 v3, s[16:19], s3 offen lds
		v_add_u32_e32 v6, 0x80080, v1
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s3, s10, 22
		v_add_u32_e32 v7, s3, v3
		v_add_u32_e32 v12, 0x100080, v1
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		v_add_u32_e32 v13, 0x180080, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s3, 0x80000
		v_add_u32_e32 v14, 0x200080, v1
		v_add_u32_e32 v15, 0x280080, v1
		v_add_u32_e32 v16, 0x300080, v1
		v_add_u32_e32 v17, 0x380080, v1
		buffer_load_dwordx4 v3, s[20:23], s4 offen lds
		v_add_u32_e32 v1, 0x80, v7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s3, 0x100000
		v_add_u32_e32 v18, 0x80080, v7
		v_add_u32_e32 v19, 0x100080, v7
		buffer_load_dwordx4 v3, s[20:23], s4 offen lds
		v_add_u32_e32 v20, 0x180080, v7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s3, 0x180000
		v_add_u32_e32 v21, 0x200080, v7
		v_add_u32_e32 v22, 0x280080, v7
		buffer_load_dwordx4 v3, s[20:23], s4 offen lds
		v_add_u32_e32 v23, 0x300080, v7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s3, 0x200000
		v_add_u32_e32 v24, 0x380080, v7
		buffer_load_dwordx4 v3, s[20:23], s4 offen lds
		v_mov_b32_e32 v7, v5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s4, s3, 0x280000
		buffer_load_dwordx4 v3, s[20:23], s4 offen lds
		s_mov_b32 s4, s1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x300000
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x380000
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		s_add_i32 s5, s8, 0x80
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x100080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x200080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x300080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_add_i32 s5, s8, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s5, s11
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x80
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x80080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x100080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x180080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x200080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x280080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x300080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s5, s3, 0x380080
		buffer_load_dwordx4 v3, s[20:23], s5 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[4:7], v5
		ds_read_b128 a[8:11], v5 offset:128
		ds_read_b128 a[12:15], v5 offset:256
		ds_read_b128 a[16:19], v5 offset:384
		ds_read_b128 a[20:23], v5 offset:512
		ds_read_b128 a[24:27], v5 offset:640
		ds_read_b128 a[28:31], v5 offset:768
		ds_read_b128 a[32:35], v5 offset:896
		ds_read_b128 a[36:39], v0
		ds_read_b128 a[40:43], v0 offset:128
		ds_read_b128 a[44:47], v0 offset:256
		ds_read_b128 a[48:51], v0 offset:384
		ds_read_b128 a[52:55], v0 offset:512
		ds_read_b128 a[56:59], v0 offset:640
		ds_read_b128 a[60:63], v0 offset:768
		ds_read_b128 a[64:67], v0 offset:896
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
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
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
		s_mov_b32 s5, s2
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[8:11], a[36:39], a[4:7], v[8:11]
		ds_read_b128 a[96:99], v7 offset:64
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[8:11], v[60:63]
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		s_add_i32 s2, s2, 1
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[12:15], v[56:59]
		ds_read_b128 a[100:103], v7 offset:192
		v_mfma_f32_16x16x32_f16 v[52:55], a[36:39], a[16:19], v[52:55]
		s_and_b32 s8, s2, 1
		s_mul_i32 s8, 0x10400, s8
		s_xor_b32 s10, s5, -1
		v_mfma_f32_16x16x32_f16 v[48:51], a[36:39], a[20:23], v[48:51]
		ds_read_b128 a[104:107], v7 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[36:39], a[24:27], v[44:47]
		s_add_i32 s10, s10, 1
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[40:43], a[36:39], a[28:31], v[40:43]
		ds_read_b128 a[108:111], v7 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[36:39], a[36:39], a[32:35], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], a[40:43], a[32:35], v[84:87]
		ds_read_b128 a[112:115], v7 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[40:43], a[28:31], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[40:43], a[24:27], v[76:79]
		ds_read_b128 a[116:119], v7 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[40:43], a[20:23], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[40:43], a[16:19], v[68:71]
		ds_read_b128 a[120:123], v7 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[40:43], a[12:15], v[64:67]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[8:11], v[28:31]
		ds_read_b128 a[124:127], v7 offset:960
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[4:7], v[32:35]
		v_mfma_f32_16x16x32_f16 v[88:91], a[44:47], a[4:7], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[44:47], a[8:11], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[44:47], a[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[44:47], a[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[44:47], a[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[44:47], a[24:27], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[44:47], a[28:31], v[112:115]
		s_mov_b32 m0, s4
		ds_read_b128 a[36:39], v2 offset:64
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[44:47], a[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[48:51], a[32:35], v[148:151]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[144:147], a[48:51], a[28:31], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[48:51], a[24:27], v[140:143]
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		ds_read_b128 a[40:43], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[136:139], a[48:51], a[20:23], v[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[48:51], a[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[48:51], a[12:15], v[128:131]
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		ds_read_b128 a[44:47], v2 offset:320
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[48:51], a[8:11], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[48:51], a[4:7], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[4:7], v[152:155]
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v2 offset:448
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[8:11], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[16:19], v[164:167]
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		ds_read_b128 a[128:131], v2 offset:576
		ds_read_b128 a[132:135], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[20:23], v[168:171]
		s_add_i32 s4, s1, s8
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[24:27], v[172:175]
		ds_read_b128 a[136:139], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[56:59], a[32:35], v[212:215]
		ds_read_b128 v[252:255], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[208:211], a[56:59], a[28:31], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[56:59], a[24:27], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[56:59], a[20:23], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[56:59], a[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[56:59], a[12:15], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[56:59], a[8:11], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[56:59], a[4:7], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[4:7], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[8:11], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[12:15], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[16:19], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[20:23], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[24:27], v[236:239]
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[28:31], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[32:35], v[244:247]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[92:95], a[64:67], a[32:35], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[64:67], a[28:31], a[88:91]
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[84:87], a[64:67], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[64:67], a[20:23], a[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[76:79], a[64:67], a[16:19], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[64:67], a[12:15], a[72:75]
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], a[64:67], a[8:11], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], a[64:67], a[4:7], a[68:71]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s5, -4, s5
		s_add_i32 s5, s5, 0x10000
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s5, v5
		v_mfma_f32_16x16x32_f16 v[8:11], a[36:39], a[96:99], v[8:11]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v25, s5, v0
		s_add_i32 s5, s10, 0x4100
		s_mul_i32 s8, s5, 4
		v_add_u32_e32 v7, s8, v5
		v_add_u32_e32 v2, s8, v0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[100:103], v[60:63]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[104:107], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[36:39], a[108:111], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[36:39], a[112:115], v[48:51]
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[44:47], a[36:39], a[116:119], v[44:47]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[40:43], a[36:39], a[120:123], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], a[36:39], a[124:127], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], a[40:43], a[124:127], v[84:87]
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[80:83], a[40:43], a[120:123], v[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[76:79], a[40:43], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[40:43], a[112:115], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[40:43], a[108:111], v[68:71]
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[64:67], a[40:43], a[104:107], v[64:67]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[100:103], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[96:99], v[32:35]
		v_mfma_f32_16x16x32_f16 v[88:91], a[44:47], a[96:99], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[44:47], a[100:103], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[44:47], a[104:107], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[44:47], a[108:111], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[44:47], a[112:115], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[44:47], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[44:47], a[120:123], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[44:47], a[124:127], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[48:51], a[124:127], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[48:51], a[120:123], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[48:51], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[48:51], a[112:115], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[48:51], a[108:111], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], a[48:51], a[104:107], v[128:131]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[4:7], v3 offset:1024
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		ds_read_b128 a[36:39], v25 offset:1024
		v_mfma_f32_16x16x32_f16 v[124:127], a[48:51], a[100:103], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[48:51], a[96:99], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[128:131], a[96:99], v[152:155]
		buffer_load_dwordx4 v23, s[20:23], 0 offen lds
		ds_read_b128 a[8:11], v3 offset:1152
		v_mfma_f32_16x16x32_f16 v[156:159], a[128:131], a[100:103], v[156:159]
		s_add_i32 m0, m0, 0x1040
		s_cmp_lt_i32 s2, 0x7e
		v_mfma_f32_16x16x32_f16 v[160:163], a[128:131], a[104:107], v[160:163]
		buffer_load_dwordx4 v24, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[164:167], a[128:131], a[108:111], v[164:167]
		ds_read_b128 a[40:43], v25 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[128:131], a[112:115], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[128:131], a[116:119], v[172:175]
		ds_read_b128 a[12:15], v3 offset:1280
		v_mfma_f32_16x16x32_f16 v[176:179], a[128:131], a[120:123], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[124:127], v[180:183]
		ds_read_b128 a[44:47], v25 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[124:127], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[132:135], a[120:123], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[132:135], a[116:119], v[204:207]
		ds_read_b128 a[16:19], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[200:203], a[132:135], a[112:115], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[132:135], a[108:111], v[196:199]
		ds_read_b128 a[48:51], v25 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[132:135], a[104:107], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[132:135], a[100:103], v[188:191]
		ds_read_b128 a[20:23], v3 offset:1536
		v_mfma_f32_16x16x32_f16 v[184:187], a[132:135], a[96:99], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[136:139], a[96:99], v[216:219]
		ds_read_b128 a[52:55], v25 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[136:139], a[100:103], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[136:139], a[104:107], v[224:227]
		ds_read_b128 a[24:27], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[228:231], a[136:139], a[108:111], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[136:139], a[112:115], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[136:139], a[116:119], v[236:239]
		ds_read_b128 a[56:59], v25 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[136:139], a[120:123], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[136:139], a[124:127], v[244:247]
		ds_read_b128 a[28:31], v3 offset:1792
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		ds_read_b128 a[60:63], v25 offset:1792
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		ds_read_b128 a[32:35], v3 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		ds_read_b128 a[64:67], v25 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[100:103], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[96:99], a[68:71]
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[8:11], a[36:39], a[4:7], v[8:11]
		ds_read_b128 v[12:15], v2 offset:64
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[4:7], v[32:35]
		ds_read_b128 v[16:19], v2 offset:192
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[88:91], a[44:47], a[4:7], v[88:91]
		ds_read_b128 v[20:23], v2 offset:320
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[120:123], a[48:51], a[4:7], v[120:123]
		ds_read_b128 v[24:27], v2 offset:448
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[4:7], v[152:155]
		ds_read_b128 a[96:99], v2 offset:576
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[184:187], a[56:59], a[4:7], v[184:187]
		ds_read_b128 a[100:103], v2 offset:704
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[4:7], v[216:219]
		ds_read_b128 a[104:107], v2 offset:832
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[68:71], a[64:67], a[4:7], a[68:71]
		ds_read_b128 a[4:7], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[8:11], v[60:63]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[8:11], v[28:31]
		v_mfma_f32_16x16x32_f16 v[92:95], a[44:47], a[8:11], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[48:51], a[8:11], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[8:11], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[56:59], a[8:11], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[8:11], v[220:223]
		v_mfma_f32_16x16x32_f16 v[248:251], a[64:67], a[8:11], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[64:67], a[12:15], a[72:75]
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[12:15], v[56:59]
		v_mfma_f32_16x16x32_f16 v[64:67], a[40:43], a[12:15], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[44:47], a[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[48:51], a[12:15], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[56:59], a[12:15], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[12:15], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[16:19], v[228:231]
		v_mfma_f32_16x16x32_f16 v[52:55], a[36:39], a[16:19], v[52:55]
		v_mfma_f32_16x16x32_f16 v[68:71], a[40:43], a[16:19], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[44:47], a[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[48:51], a[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[56:59], a[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 a[76:79], a[64:67], a[16:19], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], a[64:67], a[20:23], a[80:83]
		v_mfma_f32_16x16x32_f16 v[48:51], a[36:39], a[20:23], v[48:51]
		v_mfma_f32_16x16x32_f16 v[72:75], a[40:43], a[20:23], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[44:47], a[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[48:51], a[20:23], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[56:59], a[20:23], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[20:23], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[24:27], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[36:39], a[24:27], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[40:43], a[24:27], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[44:47], a[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[48:51], a[24:27], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[56:59], a[24:27], v[204:207]
		v_mfma_f32_16x16x32_f16 a[84:87], a[64:67], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[64:67], a[28:31], a[88:91]
		v_mfma_f32_16x16x32_f16 v[40:43], a[36:39], a[28:31], v[40:43]
		v_mfma_f32_16x16x32_f16 v[80:83], a[40:43], a[28:31], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[44:47], a[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[48:51], a[28:31], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[56:59], a[28:31], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[28:31], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[32:35], v[244:247]
		v_mfma_f32_16x16x32_f16 v[36:39], a[36:39], a[32:35], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], a[40:43], a[32:35], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[44:47], a[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[48:51], a[32:35], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[56:59], a[32:35], v[212:215]
		v_mfma_f32_16x16x32_f16 a[92:95], a[64:67], a[32:35], a[92:95]
		ds_read_b128 a[8:11], v7 offset:64
		ds_read_b128 a[12:15], v7 offset:192
		ds_read_b128 a[16:19], v7 offset:320
		ds_read_b128 a[20:23], v7 offset:448
		ds_read_b128 a[24:27], v7 offset:576
		ds_read_b128 a[28:31], v7 offset:704
		ds_read_b128 a[32:35], v7 offset:832
		ds_read_b128 v[252:255], v7 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[8:11], v[12:15], a[8:11], v[8:11]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[12:15], v[60:63]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[16:19], v[56:59]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[20:23], v[52:55]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], a[24:27], v[48:51]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[44:47], v[12:15], a[28:31], v[44:47]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], a[32:35], v[40:43]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], v[252:255], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], v[252:255], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], a[28:31], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[28:31], v[16:19], a[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[16:19], a[8:11], v[32:35]
		v_mfma_f32_16x16x32_f16 v[88:91], v[20:23], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], a[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[20:23], a[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], v[252:255], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[24:27], v[252:255], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[24:27], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[24:27], a[28:31], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[24:27], a[24:27], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[24:27], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[24:27], a[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[24:27], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[24:27], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[96:99], a[8:11], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[96:99], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[96:99], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[96:99], a[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[96:99], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[96:99], a[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[96:99], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[96:99], v[252:255], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[100:103], v[252:255], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[100:103], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[100:103], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[100:103], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[100:103], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[100:103], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[100:103], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[100:103], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[104:107], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[104:107], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[104:107], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[104:107], a[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[104:107], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[104:107], a[28:31], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[104:107], a[32:35], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[104:107], v[252:255], v[244:247]
		v_mfma_f32_16x16x32_f16 a[92:95], a[4:7], v[252:255], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[4:7], a[32:35], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[4:7], a[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[4:7], a[24:27], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[4:7], a[20:23], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[4:7], a[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[248:251], a[4:7], a[12:15], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], a[4:7], a[8:11], a[68:71]
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s1, -4, s5
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v1, s1, v5
		ds_read_b128 v[4:7], v1 offset:1024
		ds_read_b128 v[12:15], v1 offset:1152
		ds_read_b128 v[16:19], v1 offset:1280
		ds_read_b128 v[20:23], v1 offset:1408
		ds_read_b128 v[24:27], v1 offset:1536
		ds_read_b128 a[4:7], v1 offset:1664
		ds_read_b128 a[8:11], v1 offset:1792
		ds_read_b128 a[12:15], v1 offset:1920
		v_add_u32_e32 v0, s1, v0
		ds_read_b128 a[16:19], v0 offset:1024
		ds_read_b128 a[20:23], v0 offset:1152
		ds_read_b128 a[24:27], v0 offset:1280
		ds_read_b128 a[28:31], v0 offset:1408
		ds_read_b128 a[32:35], v0 offset:1536
		ds_read_b128 a[36:39], v0 offset:1664
		ds_read_b128 a[40:43], v0 offset:1792
		ds_read_b128 a[44:47], v0 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[8:11], a[16:19], v[4:7], v[8:11]
		ds_read_b128 a[48:51], v0 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[32:35], a[20:23], v[4:7], v[32:35]
		ds_read_b128 a[52:55], v0 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[88:91], a[24:27], v[4:7], v[88:91]
		ds_read_b128 a[56:59], v0 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[120:123], a[28:31], v[4:7], v[120:123]
		ds_read_b128 a[60:63], v0 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], v[4:7], v[152:155]
		ds_read_b128 a[64:67], v0 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[184:187], a[36:39], v[4:7], v[184:187]
		ds_read_b128 a[96:99], v0 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[216:219], a[40:43], v[4:7], v[216:219]
		ds_read_b128 v[252:255], v0 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[68:71], a[44:47], v[4:7], a[68:71]
		ds_read_b128 a[100:103], v0 offset:1984
		v_mfma_f32_16x16x32_f16 v[60:63], a[16:19], v[12:15], v[60:63]
		v_mfma_f32_16x16x32_f16 v[28:31], a[20:23], v[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[92:95], a[24:27], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[28:31], v[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[36:39], v[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[40:43], v[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[248:251], a[44:47], v[12:15], v[248:251]
		v_mfma_f32_16x16x32_f16 a[72:75], a[44:47], v[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 v[56:59], a[16:19], v[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[64:67], a[20:23], v[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[24:27], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[28:31], v[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[36:39], v[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[40:43], v[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[40:43], v[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[52:55], a[16:19], v[20:23], v[52:55]
		v_mfma_f32_16x16x32_f16 v[68:71], a[20:23], v[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[24:27], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[28:31], v[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[36:39], v[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 a[76:79], a[44:47], v[20:23], a[76:79]
		v_mfma_f32_16x16x32_f16 a[80:83], a[44:47], v[24:27], a[80:83]
		v_mfma_f32_16x16x32_f16 v[48:51], a[16:19], v[24:27], v[48:51]
		v_mfma_f32_16x16x32_f16 v[72:75], a[20:23], v[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[24:27], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[28:31], v[24:27], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[36:39], v[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[40:43], v[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[40:43], a[4:7], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[16:19], a[4:7], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[20:23], a[4:7], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[24:27], a[4:7], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[28:31], a[4:7], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[4:7], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[36:39], a[4:7], v[204:207]
		v_mfma_f32_16x16x32_f16 a[84:87], a[44:47], a[4:7], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[44:47], a[8:11], a[88:91]
		v_mfma_f32_16x16x32_f16 v[40:43], a[16:19], a[8:11], v[40:43]
		v_mfma_f32_16x16x32_f16 v[80:83], a[20:23], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[24:27], a[8:11], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[28:31], a[8:11], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[36:39], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[40:43], a[8:11], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[40:43], a[12:15], v[244:247]
		v_mfma_f32_16x16x32_f16 v[36:39], a[16:19], a[12:15], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], a[20:23], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[24:27], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[28:31], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[36:39], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 a[92:95], a[44:47], a[12:15], a[92:95]
		ds_read_b128 a[4:7], v1 offset:1088
		ds_read_b128 a[8:11], v1 offset:1216
		ds_read_b128 a[12:15], v1 offset:1344
		ds_read_b128 a[16:19], v1 offset:1472
		ds_read_b128 v[4:7], v1 offset:1600
		ds_read_b128 v[12:15], v1 offset:1728
		ds_read_b128 v[16:19], v1 offset:1856
		ds_read_b128 v[20:23], v1 offset:1984
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[8:11], a[48:51], a[4:7], v[8:11]
		v_accvgpr_read_b32 v0, a0
		v_lshlrev_b32_e32 v0, 19, v0
		v_accvgpr_read_b32 v1, a2
		v_lshl_add_u32 v0, v1, 21, v0
		v_accvgpr_read_b32 v1, a1
		v_lshl_add_u32 v0, v1, 8, v0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[60:63], a[48:51], a[8:11], v[60:63]
		v_accvgpr_read_b32 v1, a3
		v_lshl_add_u32 v0, v1, 4, v0
		s_lshl_b32 s0, s0, 9
		s_add_i32 s1, s3, s0
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[56:59], a[48:51], a[12:15], v[56:59]
		s_lshl_b32 s2, s9, 11
		s_add_i32 s1, s1, s2
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[16:19], v[52:55]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], v[4:7], v[48:51]
		v_cvt_pk_f16_f32 v24, v8, v60
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], v[12:15], v[44:47]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], v[16:19], v[40:43]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], v[20:23], v[36:39]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], v[20:23], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], v[16:19], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], v[12:15], v[76:79]
		v_cvt_pk_f16_f32 v25, v56, v52
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], v[4:7], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[16:19], v[68:71]
		v_cvt_pk_f16_f32 v26, v48, v44
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[12:15], v[64:67]
		v_cvt_pk_f16_f32 v27, v40, v36
		v_mfma_f32_16x16x32_f16 v[28:31], a[52:55], a[8:11], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[52:55], a[4:7], v[32:35]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[4:7], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[8:11], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], v[4:7], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], v[12:15], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], v[16:19], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], v[20:23], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], v[20:23], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], v[16:19], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], v[12:15], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], v[4:7], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[12:15], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[8:11], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[4:7], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[4:7], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[8:11], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], v[4:7], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[64:67], v[12:15], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[64:67], v[16:19], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[64:67], v[20:23], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[96:99], v[20:23], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[96:99], v[16:19], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], v[12:15], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[96:99], v[4:7], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[96:99], a[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[96:99], a[12:15], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[96:99], a[8:11], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], a[4:7], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], v[252:255], a[4:7], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[252:255], a[8:11], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[252:255], a[12:15], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[252:255], a[16:19], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[252:255], v[4:7], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], v[12:15], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], v[16:19], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], v[20:23], v[244:247]
		v_mfma_f32_16x16x32_f16 a[92:95], a[100:103], v[20:23], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[100:103], v[16:19], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[100:103], v[12:15], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[100:103], v[4:7], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[100:103], a[16:19], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[100:103], a[12:15], a[72:75]
		v_mfma_f32_16x16x32_f16 v[248:251], a[100:103], a[8:11], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], a[100:103], a[4:7], a[68:71]
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		buffer_store_dwordx4 v[24:27], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x4000
		v_cvt_pk_f16_f32 v4, v32, v28
		v_cvt_pk_f16_f32 v5, v64, v68
		v_cvt_pk_f16_f32 v6, v72, v76
		v_cvt_pk_f16_f32 v7, v80, v84
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x8000
		v_cvt_pk_f16_f32 v4, v88, v92
		v_cvt_pk_f16_f32 v5, v96, v100
		v_cvt_pk_f16_f32 v6, v104, v108
		v_cvt_pk_f16_f32 v7, v112, v116
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0xc000
		v_cvt_pk_f16_f32 v4, v120, v124
		v_cvt_pk_f16_f32 v5, v128, v132
		v_cvt_pk_f16_f32 v6, v136, v140
		v_cvt_pk_f16_f32 v7, v144, v148
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x10000
		v_cvt_pk_f16_f32 v4, v152, v156
		v_cvt_pk_f16_f32 v5, v160, v164
		v_cvt_pk_f16_f32 v6, v168, v172
		v_cvt_pk_f16_f32 v7, v176, v180
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x14000
		v_cvt_pk_f16_f32 v4, v184, v188
		v_cvt_pk_f16_f32 v5, v192, v196
		v_cvt_pk_f16_f32 v6, v200, v204
		v_cvt_pk_f16_f32 v7, v208, v212
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x18000
		v_cvt_pk_f16_f32 v4, v216, v220
		v_cvt_pk_f16_f32 v5, v224, v228
		v_cvt_pk_f16_f32 v6, v232, v236
		v_cvt_pk_f16_f32 v7, v240, v244
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x1c000
		v_accvgpr_read_b32 v1, a68
		v_cvt_pk_f16_f32 v4, v1, v248
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a76
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a84
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a92
		v_cvt_pk_f16_f32 v7, v1, v2
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x20000
		v_cvt_pk_f16_f32 v4, v9, v61
		v_cvt_pk_f16_f32 v5, v57, v53
		v_cvt_pk_f16_f32 v6, v49, v45
		v_cvt_pk_f16_f32 v7, v41, v37
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x24000
		v_cvt_pk_f16_f32 v4, v33, v29
		v_cvt_pk_f16_f32 v5, v65, v69
		v_cvt_pk_f16_f32 v6, v73, v77
		v_cvt_pk_f16_f32 v7, v81, v85
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x28000
		v_cvt_pk_f16_f32 v4, v89, v93
		v_cvt_pk_f16_f32 v5, v97, v101
		v_cvt_pk_f16_f32 v6, v105, v109
		v_cvt_pk_f16_f32 v7, v113, v117
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x2c000
		v_cvt_pk_f16_f32 v4, v121, v125
		v_cvt_pk_f16_f32 v5, v129, v133
		v_cvt_pk_f16_f32 v6, v137, v141
		v_cvt_pk_f16_f32 v7, v145, v149
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x30000
		v_cvt_pk_f16_f32 v4, v153, v157
		v_cvt_pk_f16_f32 v5, v161, v165
		v_cvt_pk_f16_f32 v6, v169, v173
		v_cvt_pk_f16_f32 v7, v177, v181
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x34000
		v_cvt_pk_f16_f32 v4, v185, v189
		v_cvt_pk_f16_f32 v5, v193, v197
		v_cvt_pk_f16_f32 v6, v201, v205
		v_cvt_pk_f16_f32 v7, v209, v213
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x38000
		v_cvt_pk_f16_f32 v4, v217, v221
		v_cvt_pk_f16_f32 v5, v225, v229
		v_cvt_pk_f16_f32 v6, v233, v237
		v_cvt_pk_f16_f32 v7, v241, v245
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x3c000
		v_accvgpr_read_b32 v1, a69
		v_cvt_pk_f16_f32 v4, v1, v249
		v_accvgpr_read_b32 v1, a73
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a81
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a89
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v7, v1, v2
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x40000
		v_cvt_pk_f16_f32 v4, v10, v62
		v_cvt_pk_f16_f32 v5, v58, v54
		v_cvt_pk_f16_f32 v6, v50, v46
		v_cvt_pk_f16_f32 v7, v42, v38
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x44000
		v_cvt_pk_f16_f32 v4, v34, v30
		v_cvt_pk_f16_f32 v5, v66, v70
		v_cvt_pk_f16_f32 v6, v74, v78
		v_cvt_pk_f16_f32 v7, v82, v86
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x48000
		v_cvt_pk_f16_f32 v4, v90, v94
		v_cvt_pk_f16_f32 v5, v98, v102
		v_cvt_pk_f16_f32 v6, v106, v110
		v_cvt_pk_f16_f32 v7, v114, v118
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x4c000
		v_cvt_pk_f16_f32 v4, v122, v126
		v_cvt_pk_f16_f32 v5, v130, v134
		v_cvt_pk_f16_f32 v6, v138, v142
		v_cvt_pk_f16_f32 v7, v146, v150
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x50000
		v_cvt_pk_f16_f32 v4, v154, v158
		v_cvt_pk_f16_f32 v5, v162, v166
		v_cvt_pk_f16_f32 v6, v170, v174
		v_cvt_pk_f16_f32 v7, v178, v182
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x54000
		v_cvt_pk_f16_f32 v4, v186, v190
		v_cvt_pk_f16_f32 v5, v194, v198
		v_cvt_pk_f16_f32 v6, v202, v206
		v_cvt_pk_f16_f32 v7, v210, v214
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x58000
		v_cvt_pk_f16_f32 v4, v218, v222
		v_cvt_pk_f16_f32 v5, v226, v230
		v_cvt_pk_f16_f32 v6, v234, v238
		v_cvt_pk_f16_f32 v7, v242, v246
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x5c000
		v_accvgpr_read_b32 v1, a70
		v_cvt_pk_f16_f32 v4, v1, v250
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a78
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a86
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a94
		v_cvt_pk_f16_f32 v7, v1, v2
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x60000
		v_cvt_pk_f16_f32 v4, v11, v63
		v_cvt_pk_f16_f32 v5, v59, v55
		v_cvt_pk_f16_f32 v6, v51, v47
		v_cvt_pk_f16_f32 v7, v43, v39
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x64000
		v_cvt_pk_f16_f32 v4, v35, v31
		v_cvt_pk_f16_f32 v5, v67, v71
		v_cvt_pk_f16_f32 v6, v75, v79
		v_cvt_pk_f16_f32 v7, v83, v87
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x68000
		v_cvt_pk_f16_f32 v4, v91, v95
		v_cvt_pk_f16_f32 v5, v99, v103
		v_cvt_pk_f16_f32 v6, v107, v111
		v_cvt_pk_f16_f32 v7, v115, v119
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x6c000
		v_cvt_pk_f16_f32 v4, v123, v127
		v_cvt_pk_f16_f32 v5, v131, v135
		v_cvt_pk_f16_f32 v6, v139, v143
		v_cvt_pk_f16_f32 v7, v147, v151
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x70000
		v_cvt_pk_f16_f32 v4, v155, v159
		v_cvt_pk_f16_f32 v5, v163, v167
		v_cvt_pk_f16_f32 v6, v171, v175
		v_cvt_pk_f16_f32 v7, v179, v183
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x74000
		v_cvt_pk_f16_f32 v4, v187, v191
		v_cvt_pk_f16_f32 v5, v195, v199
		v_cvt_pk_f16_f32 v6, v203, v207
		v_cvt_pk_f16_f32 v7, v211, v215
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x78000
		v_cvt_pk_f16_f32 v4, v219, v223
		v_cvt_pk_f16_f32 v5, v227, v231
		v_cvt_pk_f16_f32 v6, v235, v239
		v_cvt_pk_f16_f32 v7, v243, v247
		s_add_i32 s1, s1, s0
		s_add_i32 s1, s1, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s1 offen sc0 nt
		s_add_i32 s1, s3, 0x7c000
		v_accvgpr_read_b32 v1, a71
		v_cvt_pk_f16_f32 v4, v1, v251
		v_accvgpr_read_b32 v1, a75
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a83
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a91
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v7, v1, v2
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s2
		buffer_store_dwordx4 v[4:7], v0, s[12:15], s0 offen sc0 nt
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
		.amdhsa_next_free_vgpr 396
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 140
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
    .vgpr_count:     396
    .agpr_count:     140
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 76
    wave.regalloc.agpr.dwords: 288
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
