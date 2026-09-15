	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	gfx950_f16_streamk_gemm
	.p2align	8
	.type	gfx950_f16_streamk_gemm,@function
gfx950_f16_streamk_gemm:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dword s12, s[0:1], 0x28
		s_waitcnt lgkmcnt(0)
		s_branch .Lgfx950_f16_streamk_gemm.kernarg_preload_entry
	.p2align	8
.Lgfx950_f16_streamk_gemm.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_mov_b32 s10, 0x8000000
		s_mov_b32 s11, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, s10
		s_mov_b32 s19, s11
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s10
		s_mov_b32 s23, s11
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		v_readfirstlane_b32 s1, v0
		s_lshr_b32 s1, s1, 6
		s_mul_i32 s1, 0x410, s1
		s_and_b32 s6, s0, 1
		s_mul_i32 s7, 0x4100, s6
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_lshlrev_b32_e32 v3, 4, v2
		v_and_b32_e32 v0, 15, v0
		v_mov_b32_e32 v4, 0x410
		v_mul_lo_u32 v4, v4, v0
		s_lshr_b32 s12, s0, 1
		s_mul_i32 s14, 0x4100, s12
		s_mov_b32 m0, s1
		v_lshrrev_b32_e32 v0, 3, v1
		v_and_b32_e32 v5, 7, v1
		v_lshlrev_b32_e32 v5, 4, v5
		v_lshl_add_u32 v0, v0, 14, v5
		s_lshl_b32 s0, s0, 17
		s_and_b32 s15, s13, 31
		s_lshr_b32 s24, s15, 3
		s_lshl_b32 s25, s24, 22
		s_add_i32 s25, s0, s25
		s_and_b32 s15, s15, 7
		s_lshl_b32 s26, s15, 24
		s_add_i32 s25, s25, s26
		buffer_load_dwordx4 v0, s[16:19], s25 offen lds
		v_add3_u32 v5, s7, v3, v4
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s25, 0x80000
		v_and_b32_e32 v1, 15, v1
		v_lshlrev_b32_e32 v1, 4, v1
		buffer_load_dwordx4 v0, s[16:19], s7 offen lds
		v_add3_u32 v6, s14, v3, v4
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s25, 0x100000
		buffer_load_dwordx4 v0, s[16:19], s7 offen lds
		s_mov_b32 s7, s13
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s25, 0x180000
		s_mov_b32 s27, 0
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s25, 0x200000
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s25, 0x280000
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		v_mov_b32_e32 v7, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s25, 0x300000
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s25, 0x380000
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		v_lshl_add_u32 v1, v2, 19, v1
		s_add_i32 m0, m0, 0x9240
		s_lshr_b32 s13, s13, 5
		s_lshl_b32 s13, s13, 22
		s_add_i32 s26, s0, s13
		buffer_load_dwordx4 v0, s[20:23], s26 offen lds
		v_add_u32_e32 v2, s26, v0
		v_accvgpr_write_b32 a4, v2
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s28, s26, 0x80000
		buffer_load_dwordx4 v0, s[20:23], s28 offen lds
		s_mov_b32 s28, 1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s29, s26, 0x100000
		buffer_load_dwordx4 v0, s[20:23], s29 offen lds
		s_mov_b32 s29, s27
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x180000
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		v_add_u32_e32 v2, s25, v0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x200000
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		v_mov_b32_e32 v8, v5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x280000
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		v_add_u32_e32 v9, 0x10000, v6
		v_accvgpr_write_b32 a5, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x300000
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x380000
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0xffff0c40
		s_add_i32 s30, s25, 0x80
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		s_lshl_b32 s15, s15, 11
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x80080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		s_lshl_b32 s24, s24, 9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x100080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_add_u32_e32 v9, 0x380080, v2
		v_accvgpr_write_b32 a6, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x180080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_add_u32_e32 v9, 0x300080, v2
		v_accvgpr_write_b32 a7, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x200080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_add_u32_e32 v9, 0x280080, v2
		v_accvgpr_write_b32 a8, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x280080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_add_u32_e32 v9, 0x200080, v2
		v_accvgpr_write_b32 a9, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s25, 0x300080
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_add_u32_e32 v9, 0x180080, v2
		v_accvgpr_write_b32 a10, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s25, 0x380080
		buffer_load_dwordx4 v0, s[16:19], s25 offen lds
		v_add_u32_e32 v9, 0x100080, v2
		v_accvgpr_write_b32 a11, v9
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s25, s26, 0x80
		buffer_load_dwordx4 v0, s[20:23], s25 offen lds
		v_add_u32_e32 v9, 0x80080, v2
		v_accvgpr_write_b32 a12, v9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s26, 0x80080
		buffer_load_dwordx4 v0, s[20:23], s25 offen lds
		v_add_u32_e32 v2, 0x80, v2
		v_accvgpr_write_b32 a13, v2
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s26, 0x100080
		buffer_load_dwordx4 v0, s[20:23], s25 offen lds
		s_mov_b32 s25, s1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s26, 0x180080
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		s_lshl_b32 s30, s6, 8
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s31, s26, 0x200080
		buffer_load_dwordx4 v0, s[20:23], s31 offen lds
		s_lshl_b32 s12, s12, 21
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s31, s26, 0x280080
		buffer_load_dwordx4 v0, s[20:23], s31 offen lds
		s_add_i32 s14, s14, 0x10000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s31, s26, 0x300080
		buffer_load_dwordx4 v0, s[20:23], s31 offen lds
		s_add_i32 s26, s26, 0x380080
		s_add_i32 m0, m0, 0x1040
		v_add3_u32 v2, s14, v3, v4
		buffer_load_dwordx4 v0, s[20:23], s26 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[16:19], v5
		ds_read_b128 a[20:23], v5 offset:128
		ds_read_b128 a[24:27], v5 offset:256
		ds_read_b128 a[28:31], v5 offset:384
		ds_read_b128 a[32:35], v5 offset:512
		ds_read_b128 a[36:39], v5 offset:640
		ds_read_b128 a[40:43], v5 offset:768
		ds_read_b128 a[44:47], v5 offset:896
		ds_read_b128 a[48:51], v2 offset:1024
		ds_read_b128 a[52:55], v2 offset:1152
		ds_read_b128 a[56:59], v2 offset:1280
		ds_read_b128 a[60:63], v2 offset:1408
		ds_read_b128 a[64:67], v2 offset:1536
		ds_read_b128 a[68:71], v2 offset:1664
		ds_read_b128 a[72:75], v2 offset:1792
		ds_read_b128 a[76:79], v2 offset:1920
		s_add_i32 s14, s12, s30
		s_cmp_eq_u32 s6, 0
		s_cbranch_scc0 .Lgfx950_f16_streamk_gemm.if_else_0
		s_mov_b32 s32, s16
		s_mov_b32 s33, s17
		s_mov_b32 s34, s18
		s_mov_b32 s35, s19
		s_mov_b32 s36, s20
		s_mov_b32 s37, s21
		s_mov_b32 s38, s22
		s_mov_b32 s39, s23
.Lgfx950_f16_streamk_gemm.loop_head_0:
		s_mov_b32 s6, s1
		s_and_b32 s26, s7, 31
		s_lshr_b32 s31, s26, 3
		s_lshl_b32 s40, s31, 22
		s_add_i32 s40, s0, s40
		s_and_b32 s26, s26, 7
		s_lshl_b32 s41, s26, 24
		s_add_i32 s40, s40, s41
		v_add_u32_e32 v2, s40, v0
		v_add_u32_e32 v3, 0x80, v2
		v_add_u32_e32 v4, 0x80080, v2
		v_add_u32_e32 v9, 0x100080, v2
		v_add_u32_e32 v10, 0x180080, v2
		v_add_u32_e32 v11, 0x200080, v2
		v_add_u32_e32 v12, 0x280080, v2
		v_add_u32_e32 v13, 0x300080, v2
		v_add_u32_e32 v2, 0x380080, v2
		s_lshr_b32 s41, s7, 5
		s_lshl_b32 s41, s41, 22
		s_add_i32 s42, s0, s41
		v_add_u32_e32 v14, s42, v0
		v_add_u32_e32 v15, 0x80, v14
		v_add_u32_e32 v16, 0x80080, v14
		v_add_u32_e32 v17, 0x100080, v14
		v_add_u32_e32 v18, 0x180080, v14
		v_add_u32_e32 v19, 0x200080, v14
		v_add_u32_e32 v20, 0x280080, v14
		v_add_u32_e32 v21, 0x300080, v14
		v_add_u32_e32 v14, 0x380080, v14
		s_mov_b32 s43, 0
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
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
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_1:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[16:19], v[24:27]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s32, s32, 0x80
		s_addc_u32 s33, s33, 0
		ds_read_b128 a[108:111], v8 offset:64
		s_add_u32 s36, s36, 0x80
		s_addc_u32 s37, s37, 0
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[20:23], v[28:31]
		s_add_i32 s43, s43, 1
		s_and_b32 s44, s43, 1
		s_mul_i32 s44, 0x8200, s44
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[24:27], v[32:35]
		ds_read_b128 a[112:115], v8 offset:192
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[28:31], v[36:39]
		s_mul_i32 s45, 0xffffdf80, s29
		s_sub_i32 s29, s28, s29
		s_add_i32 s45, s45, 0x2080
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[32:35], v[40:43]
		ds_read_b128 a[116:119], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[36:39], v[44:47]
		s_mul_i32 s45, s45, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[40:43], v[48:51]
		ds_read_b128 a[120:123], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[44:47], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[44:47], v[84:87]
		ds_read_b128 a[124:127], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[40:43], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[36:39], v[76:79]
		ds_read_b128 a[128:131], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[28:31], v[68:71]
		ds_read_b128 a[132:135], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[20:23], v[60:63]
		ds_read_b128 a[136:139], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[40:43], v[112:115]
		s_mov_b32 m0, s6
		ds_read_b128 a[48:51], v7 offset:1088
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[44:47], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v7 offset:1216
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[36:39], v[140:143]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[32:35], v[136:139]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		ds_read_b128 a[56:59], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[28:31], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[24:27], v[128:131]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		ds_read_b128 a[140:143], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[20:23], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[16:19], v[120:123]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[16:19], v[152:155]
		ds_read_b128 a[60:63], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[20:23], v[156:159]
		s_add_i32 s6, s1, s44
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[28:31], v[164:167]
		ds_read_b128 a[144:147], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[64:67], a[36:39], v[172:175]
		ds_read_b128 a[148:151], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[64:67], a[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[64:67], a[44:47], v[180:183]
		v_add_u32_e32 v8, s45, v5
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[44:47], v[212:215]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[32:35], v[232:235]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[72:75], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 a[96:99], a[76:79], a[36:39], a[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[240:243], a[72:75], a[40:43], v[240:243]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[244:247], a[72:75], a[44:47], v[244:247]
		v_mfma_f32_16x16x32_f16 a[104:107], a[76:79], a[44:47], a[104:107]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[100:103], a[76:79], a[40:43], a[100:103]
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[32:35], a[92:95]
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[24:27], a[84:87]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[20:23], v[248:251]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[16:19], a[80:83]
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[108:111], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v7, s45, v6
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		v_add_u32_e32 v22, 0x10000, v7
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[112:115], v[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[116:119], v[32:35]
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[120:123], v[36:39]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[124:127], v[40:43]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[128:131], v[44:47]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[132:135], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[136:139], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[136:139], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[132:135], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[128:131], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[124:127], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[108:111], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[116:119], v[96:99]
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[120:123], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[124:127], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[128:131], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[132:135], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[136:139], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[140:143], a[136:139], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[140:143], a[132:135], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[140:143], a[128:131], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[140:143], a[124:127], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[140:143], a[120:123], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], a[140:143], a[116:119], v[128:131]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[124:127], a[140:143], a[112:115], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[140:143], a[108:111], v[120:123]
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		ds_read_b128 a[48:51], v22 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[60:63], a[108:111], v[152:155]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[156:159], a[60:63], a[112:115], v[156:159]
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[60:63], a[116:119], v[160:163]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v22 offset:1152
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[164:167], a[60:63], a[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[60:63], a[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[60:63], a[128:131], v[172:175]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[132:135], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[136:139], v[180:183]
		ds_read_b128 a[56:59], v22 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[144:147], a[136:139], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[144:147], a[132:135], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[144:147], a[128:131], v[204:207]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[144:147], a[124:127], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[144:147], a[120:123], v[196:199]
		ds_read_b128 a[60:63], v22 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[144:147], a[116:119], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[144:147], a[112:115], v[188:191]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[144:147], a[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[148:151], a[108:111], v[216:219]
		ds_read_b128 a[64:67], v22 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[148:151], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[148:151], a[116:119], v[224:227]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[148:151], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[148:151], a[124:127], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[148:151], a[128:131], v[236:239]
		ds_read_b128 a[68:71], v22 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[148:151], a[132:135], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[148:151], a[136:139], v[244:247]
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[136:139], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[132:135], a[100:103]
		ds_read_b128 a[72:75], v22 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[128:131], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[76:79], v22 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		s_cmp_lt_i32 s43, 0x7e
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_1
.Lgfx950_f16_streamk_gemm.loop_exit_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[16:19], v[24:27]
		ds_read_b128 a[108:111], v8 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[20:23], v[28:31]
		s_sub_i32 s43, s28, s29
		s_sub_i32 s29, s28, s43
		s_add_i32 s7, s7, 0x100
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[24:27], v[32:35]
		ds_read_b128 a[112:115], v8 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[32:35], v[40:43]
		ds_read_b128 a[116:119], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[36:39], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[40:43], v[48:51]
		ds_read_b128 a[120:123], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[44:47], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[44:47], v[84:87]
		ds_read_b128 a[48:51], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[40:43], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[36:39], v[76:79]
		ds_read_b128 a[124:127], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[28:31], v[68:71]
		ds_read_b128 a[128:131], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[20:23], v[60:63]
		ds_read_b128 a[132:135], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v7
		s_mov_b32 m0, s6
		s_add_i32 s6, s40, 0x80000
		buffer_load_dwordx4 v0, s[16:19], s40 offen lds
		s_add_i32 s43, s40, 0x100000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s40, 0x180000
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x200000
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[40:43], v[112:115]
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		s_add_i32 s43, s40, 0x280000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s40, 0x300000
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		s_add_i32 s44, s40, 0x380000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s46, s42, 0x2000000
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		ds_read_b128 v[8:11], v2 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[44:47], v[148:151]
		ds_read_b128 v[12:15], v2 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[32:35], v[136:139]
		ds_read_b128 v[16:19], v2 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[24:27], v[128:131]
		ds_read_b128 v[20:23], v2 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[16:19], v[152:155]
		ds_read_b128 a[52:55], v2 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[28:31], v[164:167]
		ds_read_b128 a[56:59], v2 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[64:67], a[36:39], v[172:175]
		ds_read_b128 a[60:63], v2 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[64:67], a[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[64:67], a[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[44:47], v[212:215]
		ds_read_b128 v[252:255], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[24:27], a[84:87]
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[16:19], a[80:83]
		buffer_load_dwordx4 v0, s[16:19], s45 offen lds
		s_add_i32 s6, s42, 0x2080000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s42, 0x2100000
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		s_add_i32 s44, s42, 0x2180000
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s45, s42, 0x2200000
		buffer_load_dwordx4 v0, s[20:23], s46 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[32:35], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[32:35], a[92:95]
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[72:75], a[36:39], v[236:239]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[96:99], a[76:79], a[36:39], a[96:99]
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[72:75], a[40:43], v[240:243]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[244:247], a[72:75], a[44:47], v[244:247]
		buffer_load_dwordx4 v0, s[20:23], s44 offen lds
		v_mfma_f32_16x16x32_f16 a[104:107], a[76:79], a[44:47], a[104:107]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[100:103], a[76:79], a[40:43], a[100:103]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[108:111], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[112:115], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[116:119], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[120:123], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[48:51], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[124:127], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[128:131], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[132:135], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[132:135], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[128:131], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[124:127], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[48:51], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[108:111], v[88:91]
		buffer_load_dwordx4 v0, s[20:23], s45 offen lds
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[120:123], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[48:51], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[124:127], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[128:131], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[132:135], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[132:135], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[128:131], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[124:127], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[120:123], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[116:119], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s6, s42, 0x2280000
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		s_mul_i32 s6, 0xffffdf80, s29
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s42, 0x2300000
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		s_add_i32 s43, s42, 0x2380000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s6, s6, 0x2080
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		s_lshl_b32 s6, s6, 2
		v_add_u32_e32 v2, s6, v5
		ds_read_b128 a[16:19], v2
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[112:115], v[124:127]
		v_accvgpr_read_b32 v3, a5
		v_add_u32_e32 v3, s6, v3
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[108:111], v[120:123]
		ds_read_b128 v[8:11], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[112:115], v[156:159]
		ds_read_b128 a[20:23], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[116:119], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[120:123], v[164:167]
		ds_read_b128 v[12:15], v3 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[48:51], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[124:127], v[172:175]
		ds_read_b128 a[24:27], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[128:131], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[132:135], v[180:183]
		ds_read_b128 v[16:19], v3 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[56:59], a[132:135], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[56:59], a[128:131], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[56:59], a[124:127], v[204:207]
		ds_read_b128 a[28:31], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[56:59], a[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[56:59], a[120:123], v[196:199]
		ds_read_b128 a[32:35], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[56:59], a[116:119], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[56:59], a[112:115], v[188:191]
		ds_read_b128 a[36:39], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[56:59], a[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[108:111], v[216:219]
		ds_read_b128 a[40:43], v3 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[116:119], v[224:227]
		ds_read_b128 a[44:47], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[48:51], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[124:127], v[236:239]
		ds_read_b128 a[52:55], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[128:131], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[132:135], v[244:247]
		ds_read_b128 a[56:59], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[132:135], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[128:131], a[100:103]
		ds_read_b128 a[60:63], v3 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[48:51], a[92:95]
		ds_read_b128 a[48:51], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 v[20:23], v3 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[16:19], v[24:27]
		ds_read_b128 a[108:111], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[20:23], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[24:27], v[32:35]
		ds_read_b128 a[112:115], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[36:39], v[40:43]
		ds_read_b128 a[76:79], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[44:47], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[56:59], v[48:51]
		ds_read_b128 a[116:119], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[48:51], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[48:51], v[84:87]
		ds_read_b128 a[120:123], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[56:59], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[44:47], v[76:79]
		ds_read_b128 a[124:127], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[36:39], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[28:31], v[68:71]
		ds_read_b128 a[72:75], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[20:23], v[60:63]
		ds_read_b128 a[128:131], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[44:47], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[56:59], v[112:115]
		s_add_i32 m0, s1, 0x8200
		s_add_i32 s6, s40, 0x80
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s40, 0x100080
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s40, 0x200080
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		s_add_i32 s43, s40, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s40, 0x300080
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s40, s42, 0x2000080
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		ds_read_b128 v[8:11], v3 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[32:35], a[48:51], v[148:151]
		ds_read_b128 v[12:15], v3 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[32:35], a[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[32:35], a[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[32:35], a[36:39], v[136:139]
		ds_read_b128 v[16:19], v3 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[32:35], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[32:35], a[24:27], v[128:131]
		ds_read_b128 a[64:67], v3 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[32:35], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[32:35], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[40:43], a[16:19], v[152:155]
		ds_read_b128 a[32:35], v3 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[40:43], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[40:43], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[40:43], a[28:31], v[164:167]
		ds_read_b128 a[68:71], v3 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[40:43], a[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[40:43], a[44:47], v[172:175]
		ds_read_b128 a[132:135], v3 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[40:43], a[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[40:43], a[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[48:51], v[212:215]
		ds_read_b128 v[252:255], v3 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[52:55], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[52:55], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[88:91], v[20:23], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], v[20:23], a[24:27], a[84:87]
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], v[20:23], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], v[20:23], a[16:19], a[80:83]
		buffer_load_dwordx4 v0, s[16:19], s45 offen lds
		s_add_i32 s43, s42, 0x2080080
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s26, s26, 11
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s42, 0x2100080
		s_add_i32 m0, m0, 0x9240
		s_lshl_b32 s31, s31, 9
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		s_add_i32 s40, s42, 0x2180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s41, s14, s41
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		s_add_i32 s43, s42, 0x2200080
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[36:39], v[232:235]
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		v_mfma_f32_16x16x32_f16 a[92:95], v[20:23], a[36:39], a[92:95]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[44:47], v[236:239]
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		v_mfma_f32_16x16x32_f16 a[96:99], v[20:23], a[44:47], a[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[56:59], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[48:51], v[244:247]
		v_mfma_f32_16x16x32_f16 a[104:107], v[20:23], a[48:51], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[20:23], a[56:59], a[100:103]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[108:111], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[112:115], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[76:79], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[116:119], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[120:123], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[124:127], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[72:75], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[128:131], v[52:55]
		s_add_i32 s6, s41, s31
		s_add_i32 s6, s6, s26
		v_cvt_pk_f16_f32 v8, v24, v28
		v_cvt_pk_f16_f32 v20, v25, v29
		v_cvt_pk_f16_f32 v9, v32, v36
		v_cvt_pk_f16_f32 v21, v33, v37
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		v_cvt_pk_f16_f32 v10, v40, v44
		v_cvt_pk_f16_f32 v11, v48, v52
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s6 offen sc0 nt
		s_add_i32 s26, s6, 0x20000
		v_cvt_pk_f16_f32 v22, v41, v45
		v_cvt_pk_f16_f32 v23, v49, v53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x40000
		v_cvt_pk_f16_f32 v8, v26, v30
		v_cvt_pk_f16_f32 v9, v34, v38
		v_cvt_pk_f16_f32 v10, v42, v46
		v_cvt_pk_f16_f32 v11, v50, v54
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x60000
		v_cvt_pk_f16_f32 v8, v27, v31
		v_cvt_pk_f16_f32 v9, v35, v39
		v_cvt_pk_f16_f32 v10, v43, v47
		v_cvt_pk_f16_f32 v11, v51, v55
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[128:131], v[84:87]
		s_add_i32 s26, s6, 0x4000
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[72:75], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[124:127], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[120:123], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[116:119], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[76:79], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[108:111], v[56:59]
		s_add_i32 s31, s6, 0x24000
		s_add_i32 s40, s6, 0x44000
		v_cvt_pk_f16_f32 v11, v80, v84
		v_cvt_pk_f16_f32 v15, v81, v85
		v_cvt_pk_f16_f32 v10, v72, v76
		v_cvt_pk_f16_f32 v14, v73, v77
		v_cvt_pk_f16_f32 v9, v64, v68
		v_cvt_pk_f16_f32 v13, v65, v69
		v_cvt_pk_f16_f32 v8, v56, v60
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x64000
		v_cvt_pk_f16_f32 v12, v57, v61
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		v_cvt_pk_f16_f32 v8, v58, v62
		v_cvt_pk_f16_f32 v9, v66, v70
		v_cvt_pk_f16_f32 v10, v74, v78
		v_cvt_pk_f16_f32 v11, v82, v86
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s40 offen sc0 nt
		s_nop 0
		v_cvt_pk_f16_f32 v8, v59, v63
		v_cvt_pk_f16_f32 v9, v67, v71
		v_cvt_pk_f16_f32 v10, v75, v79
		v_cvt_pk_f16_f32 v11, v83, v87
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[108:111], v[88:91]
		s_add_i32 s26, s6, 0x8000
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[76:79], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[116:119], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[120:123], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[124:127], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[128:131], v[116:119]
		s_add_i32 s31, s6, 0x28000
		s_add_i32 s40, s6, 0x48000
		v_cvt_pk_f16_f32 v8, v88, v92
		v_cvt_pk_f16_f32 v12, v89, v93
		v_cvt_pk_f16_f32 v9, v96, v100
		v_cvt_pk_f16_f32 v13, v97, v101
		v_cvt_pk_f16_f32 v10, v104, v108
		v_cvt_pk_f16_f32 v14, v105, v109
		v_cvt_pk_f16_f32 v11, v112, v116
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x68000
		v_cvt_pk_f16_f32 v15, v113, v117
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[148:151], a[64:67], a[128:131], v[148:151]
		v_cvt_pk_f16_f32 v8, v90, v94
		v_cvt_pk_f16_f32 v9, v98, v102
		v_cvt_pk_f16_f32 v10, v106, v110
		v_cvt_pk_f16_f32 v11, v114, v118
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s40 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], a[72:75], v[144:147]
		v_cvt_pk_f16_f32 v8, v91, v95
		v_cvt_pk_f16_f32 v9, v99, v103
		v_cvt_pk_f16_f32 v10, v107, v111
		v_cvt_pk_f16_f32 v11, v115, v119
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[124:127], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[64:67], a[120:123], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[64:67], a[116:119], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_cvt_pk_f16_f32 v15, v144, v148
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v19, v145, v149
		s_add_i32 s26, s42, 0x2280080
		v_cvt_pk_f16_f32 v23, v146, v150
		buffer_load_dwordx4 v0, s[20:23], s26 offen lds
		v_cvt_pk_f16_f32 v14, v136, v140
		s_add_i32 s26, s6, 0xc000
		v_cvt_pk_f16_f32 v18, v137, v141
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v22, v138, v142
		s_add_i32 s31, s42, 0x2300080
		buffer_load_dwordx4 v0, s[20:23], s31 offen lds
		v_cvt_pk_f16_f32 v26, v139, v143
		s_mul_i32 s31, 0x2080, s29
		v_cvt_pk_f16_f32 v27, v147, v151
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[64:67], a[76:79], v[128:131]
		s_add_i32 s40, s42, 0x2380080
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		s_mul_i32 s31, s31, 4
		v_add_u32_e32 v8, s31, v5
		v_add_u32_e32 v7, s31, v6
		s_add_i32 s31, s6, 0x2c000
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[124:127], a[64:67], a[112:115], v[124:127]
		v_cvt_pk_f16_f32 v13, v128, v132
		v_mfma_f32_16x16x32_f16 v[120:123], a[64:67], a[108:111], v[120:123]
		v_cvt_pk_f16_f32 v17, v129, v133
		v_cvt_pk_f16_f32 v21, v130, v134
		v_cvt_pk_f16_f32 v25, v131, v135
		s_add_i32 s40, s6, 0x4c000
		s_add_i32 s41, s6, 0x6c000
		s_add_i32 s42, s6, 0x10000
		s_add_i32 s43, s6, 0x30000
		s_add_i32 s44, s6, 0x50000
		v_cvt_pk_f16_f32 v12, v120, v124
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x70000
		v_cvt_pk_f16_f32 v16, v121, v125
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s31, s6, 0x14000
		v_cvt_pk_f16_f32 v20, v122, v126
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s40 offen sc0 nt
		s_add_i32 s40, s6, 0x34000
		v_cvt_pk_f16_f32 v24, v123, v127
		buffer_store_dwordx4 v[24:27], v1, s[8:11], s41 offen sc0 nt
		v_add_u32_e32 v2, 0x10000, v7
		ds_read_b128 a[48:51], v2 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], a[112:115], v[156:159]
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], a[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], a[116:119], v[164:167]
		ds_read_b128 a[52:55], v2 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[120:123], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[124:127], v[172:175]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[72:75], v[176:179]
		v_cvt_pk_f16_f32 v12, v152, v156
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[128:131], v[180:183]
		v_cvt_pk_f16_f32 v16, v153, v157
		v_cvt_pk_f16_f32 v13, v160, v164
		v_cvt_pk_f16_f32 v17, v161, v165
		v_cvt_pk_f16_f32 v20, v154, v158
		v_cvt_pk_f16_f32 v14, v168, v172
		v_cvt_pk_f16_f32 v18, v169, v173
		v_cvt_pk_f16_f32 v21, v162, v166
		v_cvt_pk_f16_f32 v22, v170, v174
		v_cvt_pk_f16_f32 v15, v176, v180
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s42 offen sc0 nt
		s_add_i32 s41, s6, 0x54000
		v_cvt_pk_f16_f32 v19, v177, v181
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s43 offen sc0 nt
		s_add_i32 s42, s6, 0x74000
		v_cvt_pk_f16_f32 v23, v178, v182
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s44 offen sc0 nt
		s_add_i32 s43, s6, 0x18000
		v_cvt_pk_f16_f32 v12, v155, v159
		v_cvt_pk_f16_f32 v13, v163, v167
		v_cvt_pk_f16_f32 v14, v171, v175
		v_cvt_pk_f16_f32 v15, v179, v183
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		ds_read_b128 a[56:59], v2 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[128:131], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[72:75], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[124:127], v[204:207]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[120:123], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[116:119], v[196:199]
		ds_read_b128 a[60:63], v2 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[76:79], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[112:115], v[188:191]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[108:111], v[184:187]
		v_cvt_pk_f16_f32 v15, v208, v212
		v_cvt_pk_f16_f32 v19, v209, v213
		v_cvt_pk_f16_f32 v14, v200, v204
		v_cvt_pk_f16_f32 v18, v201, v205
		v_cvt_pk_f16_f32 v22, v202, v206
		v_cvt_pk_f16_f32 v13, v192, v196
		v_cvt_pk_f16_f32 v17, v193, v197
		v_cvt_pk_f16_f32 v21, v194, v198
		v_cvt_pk_f16_f32 v12, v184, v188
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[108:111], v[216:219]
		v_cvt_pk_f16_f32 v16, v185, v189
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s40 offen sc0 nt
		s_add_i32 s26, s6, 0x38000
		v_cvt_pk_f16_f32 v20, v186, v190
		v_cvt_pk_f16_f32 v23, v210, v214
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s41 offen sc0 nt
		s_add_i32 s31, s6, 0x58000
		v_cvt_pk_f16_f32 v12, v187, v191
		v_cvt_pk_f16_f32 v13, v195, v199
		v_cvt_pk_f16_f32 v14, v203, v207
		v_cvt_pk_f16_f32 v15, v211, v215
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s42 offen sc0 nt
		ds_read_b128 a[64:67], v2 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[76:79], v[224:227]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[116:119], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[120:123], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[124:127], v[236:239]
		ds_read_b128 a[68:71], v2 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[72:75], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[132:135], a[128:131], v[244:247]
		v_cvt_pk_f16_f32 v12, v216, v220
		v_cvt_pk_f16_f32 v16, v217, v221
		v_cvt_pk_f16_f32 v20, v218, v222
		v_cvt_pk_f16_f32 v13, v224, v228
		v_cvt_pk_f16_f32 v17, v225, v229
		v_cvt_pk_f16_f32 v14, v232, v236
		v_cvt_pk_f16_f32 v18, v233, v237
		v_cvt_pk_f16_f32 v21, v226, v230
		v_cvt_pk_f16_f32 v15, v240, v244
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s43 offen sc0 nt
		s_add_i32 s40, s6, 0x78000
		v_cvt_pk_f16_f32 v19, v241, v245
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x1c000
		v_cvt_pk_f16_f32 v22, v234, v238
		v_cvt_pk_f16_f32 v23, v242, v246
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s31, s6, 0x3c000
		v_cvt_pk_f16_f32 v12, v219, v223
		v_cvt_pk_f16_f32 v13, v227, v231
		v_cvt_pk_f16_f32 v14, v235, v239
		v_cvt_pk_f16_f32 v15, v243, v247
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s40 offen sc0 nt
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[128:131], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[72:75], a[100:103]
		ds_read_b128 a[72:75], v2 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[120:123], a[92:95]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[116:119], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[76:79], a[84:87]
		ds_read_b128 a[76:79], v2 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v3, a104
		v_cvt_pk_f16_f32 v15, v2, v3
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		v_accvgpr_read_b32 v2, a101
		v_accvgpr_read_b32 v3, a105
		v_cvt_pk_f16_f32 v19, v2, v3
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a96
		v_cvt_pk_f16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a93
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_f16_f32 v18, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a98
		v_cvt_pk_f16_f32 v22, v2, v3
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v3, a88
		v_cvt_pk_f16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a85
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v17, v2, v3
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v3, a90
		v_cvt_pk_f16_f32 v21, v2, v3
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v3, a106
		v_cvt_pk_f16_f32 v23, v2, v3
		v_accvgpr_read_b32 v2, a80
		v_cvt_pk_f16_f32 v12, v2, v248
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x5c000
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v16, v2, v249
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s6, s6, 0x7c000
		v_accvgpr_read_b32 v2, a82
		v_cvt_pk_f16_f32 v20, v2, v250
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s26 offen sc0 nt
		s_cmp_lt_i32 s7, 0x300
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v12, v2, v251
		v_accvgpr_read_b32 v2, a87
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a95
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_f16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a103
		v_accvgpr_read_b32 v3, a107
		v_cvt_pk_f16_f32 v15, v2, v3
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s6 offen sc0 nt
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_0
.Lgfx950_f16_streamk_gemm.loop_exit_0:
		s_branch .Lgfx950_f16_streamk_gemm.if_end_0
.Lgfx950_f16_streamk_gemm.if_else_0:
		s_mov_b32 s32, s16
		s_mov_b32 s33, s17
		s_mov_b32 s34, s18
		s_mov_b32 s35, s19
		s_mov_b32 s36, s20
		s_mov_b32 s37, s21
		s_mov_b32 s38, s22
		s_mov_b32 s39, s23
.Lgfx950_f16_streamk_gemm.loop_head_2:
		s_mov_b32 s6, s1
		s_and_b32 s26, s7, 31
		s_lshr_b32 s31, s26, 3
		s_lshl_b32 s40, s31, 22
		s_add_i32 s40, s0, s40
		s_and_b32 s26, s26, 7
		s_lshl_b32 s41, s26, 24
		s_add_i32 s40, s40, s41
		v_add_u32_e32 v2, s40, v0
		v_add_u32_e32 v3, 0x80, v2
		v_add_u32_e32 v4, 0x80080, v2
		v_add_u32_e32 v9, 0x100080, v2
		v_add_u32_e32 v10, 0x180080, v2
		v_add_u32_e32 v11, 0x200080, v2
		v_add_u32_e32 v12, 0x280080, v2
		v_add_u32_e32 v13, 0x300080, v2
		v_add_u32_e32 v2, 0x380080, v2
		s_lshr_b32 s41, s7, 5
		s_lshl_b32 s41, s41, 22
		s_add_i32 s42, s0, s41
		v_add_u32_e32 v14, s42, v0
		v_add_u32_e32 v15, 0x80, v14
		v_add_u32_e32 v16, 0x80080, v14
		v_add_u32_e32 v17, 0x100080, v14
		v_add_u32_e32 v18, 0x180080, v14
		v_add_u32_e32 v19, 0x200080, v14
		v_add_u32_e32 v20, 0x280080, v14
		v_add_u32_e32 v21, 0x300080, v14
		v_add_u32_e32 v14, 0x380080, v14
		s_mov_b32 s43, 0
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
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
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_3:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[16:19], v[24:27]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s32, s32, 0x80
		s_addc_u32 s33, s33, 0
		s_add_u32 s36, s36, 0x80
		s_addc_u32 s37, s37, 0
		ds_read_b128 a[108:111], v8 offset:64
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[20:23], v[28:31]
		s_add_i32 s43, s43, 1
		s_and_b32 s44, s43, 1
		s_mul_i32 s44, 0x8200, s44
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[24:27], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[28:31], v[36:39]
		ds_read_b128 a[112:115], v8 offset:192
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[32:35], v[40:43]
		ds_read_b128 a[116:119], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[36:39], v[44:47]
		s_mul_i32 s45, 0xffffdf80, s29
		s_sub_i32 s29, s28, s29
		s_add_i32 s45, s45, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[40:43], v[48:51]
		ds_read_b128 a[120:123], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[44:47], v[52:55]
		s_mul_i32 s45, s45, 4
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[44:47], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[40:43], v[80:83]
		ds_read_b128 a[124:127], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[36:39], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[32:35], v[72:75]
		ds_read_b128 a[128:131], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[28:31], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[24:27], v[64:67]
		ds_read_b128 a[132:135], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[16:19], v[56:59]
		ds_read_b128 a[136:139], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[40:43], v[112:115]
		s_mov_b32 m0, s6
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[44:47], v[148:151]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1088
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[36:39], v[140:143]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		ds_read_b128 a[52:55], v7 offset:1216
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[32:35], v[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[24:27], v[128:131]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		ds_read_b128 a[56:59], v7 offset:1344
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[16:19], v[120:123]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		ds_read_b128 a[60:63], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[16:19], v[152:155]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[140:143], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[20:23], v[156:159]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[24:27], v[160:163]
		s_add_i32 s6, s1, s44
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[32:35], v[168:171]
		ds_read_b128 a[144:147], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[172:175], a[64:67], a[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[64:67], a[40:43], v[176:179]
		ds_read_b128 a[148:151], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[180:183], a[64:67], a[44:47], v[180:183]
		v_add_u32_e32 v8, s45, v5
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[44:47], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[40:43], v[208:211]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[32:35], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[72:75], a[36:39], v[236:239]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[72:75], a[40:43], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[72:75], a[44:47], v[244:247]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[104:107], a[76:79], a[44:47], a[104:107]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[100:103], a[76:79], a[40:43], a[100:103]
		v_mfma_f32_16x16x32_f16 a[96:99], a[76:79], a[36:39], a[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[32:35], a[92:95]
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[16:19], a[80:83]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_add_u32_e32 v7, s45, v6
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[108:111], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v22, 0x10000, v7
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[112:115], v[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[116:119], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[120:123], v[36:39]
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[124:127], v[40:43]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[128:131], v[44:47]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[132:135], v[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[136:139], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[136:139], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[132:135], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[128:131], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[124:127], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[108:111], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[120:123], v[100:103]
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[124:127], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[128:131], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[132:135], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[136:139], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[136:139], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[132:135], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[128:131], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[124:127], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[120:123], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[116:119], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v20, s[36:39], 0 offen lds
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[112:115], v[124:127]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[48:51], v22 offset:1024
		buffer_load_dwordx4 v21, s[36:39], 0 offen lds
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[108:111], v[120:123]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v22 offset:1152
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[140:143], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[140:143], a[112:115], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[140:143], a[116:119], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[140:143], a[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[140:143], a[124:127], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[140:143], a[128:131], v[172:175]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[140:143], a[132:135], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[140:143], a[136:139], v[180:183]
		ds_read_b128 a[56:59], v22 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[144:147], a[136:139], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[144:147], a[132:135], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[144:147], a[128:131], v[204:207]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[144:147], a[124:127], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[144:147], a[120:123], v[196:199]
		ds_read_b128 a[60:63], v22 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[144:147], a[116:119], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[144:147], a[112:115], v[188:191]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[144:147], a[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[148:151], a[108:111], v[216:219]
		ds_read_b128 a[64:67], v22 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[148:151], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[148:151], a[116:119], v[224:227]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[148:151], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[148:151], a[124:127], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[148:151], a[128:131], v[236:239]
		ds_read_b128 a[68:71], v22 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[148:151], a[132:135], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[148:151], a[136:139], v[244:247]
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[136:139], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[132:135], a[100:103]
		ds_read_b128 a[72:75], v22 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[128:131], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[76:79], v22 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		s_cmp_lt_i32 s43, 0x7e
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_3
.Lgfx950_f16_streamk_gemm.loop_exit_3:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[16:19], v[24:27]
		s_mov_b32 m0, s6
		ds_read_b128 a[108:111], v8 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[20:23], v[28:31]
		s_sub_i32 s6, s28, s29
		s_sub_i32 s29, s28, s6
		s_add_i32 s7, s7, 0x100
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[24:27], v[32:35]
		ds_read_b128 a[112:115], v8 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[32:35], v[40:43]
		ds_read_b128 a[116:119], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[36:39], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], a[40:43], v[48:51]
		ds_read_b128 a[120:123], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], a[44:47], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], a[44:47], v[84:87]
		ds_read_b128 a[48:51], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], a[40:43], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[36:39], v[76:79]
		ds_read_b128 a[124:127], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[28:31], v[68:71]
		ds_read_b128 a[128:131], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[20:23], v[60:63]
		ds_read_b128 a[132:135], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v0, s[16:19], s40 offen lds
		s_add_i32 s6, s40, 0x80000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s40, 0x100000
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x180000
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v2, 0x10000, v7
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		s_add_i32 s43, s40, 0x200000
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[40:43], v[112:115]
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x280000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s40, 0x300000
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		ds_read_b128 v[8:11], v2 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[44:47], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[44:47], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 v[12:15], v2 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[40:43], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[32:35], v[136:139]
		ds_read_b128 v[16:19], v2 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[24:27], v[128:131]
		ds_read_b128 v[20:23], v2 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[16:19], v[152:155]
		ds_read_b128 a[52:55], v2 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[28:31], v[164:167]
		ds_read_b128 a[56:59], v2 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[64:67], a[36:39], v[172:175]
		ds_read_b128 a[60:63], v2 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[64:67], a[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[64:67], a[44:47], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[44:47], v[212:215]
		ds_read_b128 v[252:255], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[40:43], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[24:27], a[84:87]
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[16:19], a[80:83]
		s_add_i32 s6, s40, 0x380000
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s42, 0x2000000
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s43, s42, 0x2080000
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		s_add_i32 s6, s42, 0x2100000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s42, 0x2180000
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		s_add_i32 s43, s42, 0x2200000
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[32:35], v[232:235]
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[32:35], a[92:95]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[72:75], a[36:39], v[236:239]
		buffer_load_dwordx4 v0, s[20:23], s44 offen lds
		v_mfma_f32_16x16x32_f16 a[96:99], a[76:79], a[36:39], a[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[240:243], a[72:75], a[40:43], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[72:75], a[44:47], v[244:247]
		v_mfma_f32_16x16x32_f16 a[104:107], a[76:79], a[44:47], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], a[76:79], a[40:43], a[100:103]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[108:111], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[112:115], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[116:119], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[120:123], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[48:51], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[124:127], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[128:131], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[132:135], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[132:135], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[128:131], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[124:127], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[48:51], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[120:123], v[68:71]
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[108:111], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[120:123], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[48:51], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[124:127], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[128:131], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[132:135], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[132:135], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[128:131], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[124:127], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[120:123], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[116:119], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s6, s42, 0x2280000
		s_mul_i32 s43, 0xffffdf80, s29
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		s_add_i32 s6, s42, 0x2300000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s42, 0x2380000
		buffer_load_dwordx4 v0, s[20:23], s6 offen lds
		s_add_i32 s6, s43, 0x2080
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s6, s6, 2
		buffer_load_dwordx4 v0, s[20:23], s44 offen lds
		v_add_u32_e32 v2, s6, v5
		s_add_i32 m0, s1, 0x8200
		ds_read_b128 a[16:19], v2
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[112:115], v[124:127]
		v_accvgpr_read_b32 v3, a5
		v_add_u32_e32 v3, s6, v3
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[108:111], v[120:123]
		ds_read_b128 v[8:11], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[112:115], v[156:159]
		ds_read_b128 a[20:23], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[116:119], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[120:123], v[164:167]
		ds_read_b128 v[12:15], v3 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[48:51], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[124:127], v[172:175]
		ds_read_b128 a[24:27], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[128:131], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[132:135], v[180:183]
		ds_read_b128 v[16:19], v3 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[56:59], a[132:135], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[56:59], a[128:131], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[56:59], a[124:127], v[204:207]
		ds_read_b128 a[28:31], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[56:59], a[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[56:59], a[120:123], v[196:199]
		ds_read_b128 a[32:35], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[56:59], a[116:119], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[56:59], a[112:115], v[188:191]
		ds_read_b128 a[36:39], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[56:59], a[108:111], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[108:111], v[216:219]
		ds_read_b128 a[40:43], v3 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[116:119], v[224:227]
		ds_read_b128 a[44:47], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[48:51], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[124:127], v[236:239]
		ds_read_b128 a[52:55], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[128:131], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[132:135], v[244:247]
		ds_read_b128 a[56:59], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[132:135], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[128:131], a[100:103]
		ds_read_b128 a[60:63], v3 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[48:51], a[92:95]
		ds_read_b128 a[48:51], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 v[20:23], v3 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[16:19], v[24:27]
		ds_read_b128 a[108:111], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[20:23], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[24:27], v[32:35]
		ds_read_b128 a[112:115], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[36:39], v[40:43]
		ds_read_b128 a[76:79], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[44:47], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[56:59], v[48:51]
		ds_read_b128 a[116:119], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[48:51], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[48:51], v[84:87]
		ds_read_b128 a[120:123], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[56:59], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[44:47], v[76:79]
		ds_read_b128 a[124:127], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[36:39], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[28:31], v[68:71]
		ds_read_b128 a[72:75], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[20:23], v[60:63]
		ds_read_b128 a[128:131], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[36:39], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[44:47], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[56:59], v[112:115]
		s_add_i32 s6, s40, 0x80
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s40, 0x100080
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s40, 0x200080
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		s_add_i32 s43, s40, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s40, 0x300080
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_add_i32 s6, s40, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s40, s42, 0x2000080
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		s_add_i32 s44, s42, 0x2080080
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 v[8:11], v3 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[32:35], a[48:51], v[148:151]
		ds_read_b128 v[12:15], v3 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[32:35], a[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[32:35], a[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[32:35], a[36:39], v[136:139]
		ds_read_b128 v[16:19], v3 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[32:35], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[32:35], a[24:27], v[128:131]
		ds_read_b128 a[64:67], v3 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[32:35], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[32:35], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[40:43], a[16:19], v[152:155]
		ds_read_b128 a[32:35], v3 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[40:43], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[40:43], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[40:43], a[28:31], v[164:167]
		ds_read_b128 a[68:71], v3 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[40:43], a[36:39], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[40:43], a[44:47], v[172:175]
		ds_read_b128 a[132:135], v3 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[40:43], a[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[40:43], a[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[48:51], v[212:215]
		ds_read_b128 v[252:255], v3 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[36:39], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[52:55], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[52:55], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[60:63], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[60:63], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[60:63], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[60:63], a[28:31], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		v_mfma_f32_16x16x32_f16 a[88:91], v[20:23], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], v[20:23], a[24:27], a[84:87]
		buffer_load_dwordx4 v0, s[16:19], s45 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], v[20:23], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], v[20:23], a[16:19], a[80:83]
		buffer_load_dwordx4 v0, s[16:19], s6 offen lds
		s_lshl_b32 s6, s26, 11
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s26, s42, 0x2100080
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		s_lshl_b32 s31, s31, 9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s40, s42, 0x2180080
		buffer_load_dwordx4 v0, s[20:23], s44 offen lds
		s_add_i32 s41, s14, s41
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s42, 0x2200080
		buffer_load_dwordx4 v0, s[20:23], s26 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[60:63], a[36:39], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[92:95], v[20:23], a[36:39], a[92:95]
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[60:63], a[44:47], v[236:239]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[96:99], v[20:23], a[44:47], a[96:99]
		v_mfma_f32_16x16x32_f16 v[240:243], a[60:63], a[56:59], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[60:63], a[48:51], v[244:247]
		v_mfma_f32_16x16x32_f16 a[104:107], v[20:23], a[48:51], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[20:23], a[56:59], a[100:103]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[108:111], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[112:115], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[76:79], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[116:119], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[120:123], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[124:127], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[72:75], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[128:131], v[52:55]
		s_add_i32 s26, s41, s31
		s_add_i32 s6, s26, s6
		v_cvt_pk_f16_f32 v8, v24, v28
		v_cvt_pk_f16_f32 v20, v25, v29
		v_cvt_pk_f16_f32 v9, v32, v36
		buffer_load_dwordx4 v0, s[20:23], s43 offen lds
		v_cvt_pk_f16_f32 v10, v40, v44
		v_cvt_pk_f16_f32 v21, v33, v37
		v_cvt_pk_f16_f32 v11, v48, v52
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s6 offen sc0 nt
		s_add_i32 s26, s6, 0x20000
		v_cvt_pk_f16_f32 v22, v41, v45
		v_cvt_pk_f16_f32 v23, v49, v53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x40000
		v_cvt_pk_f16_f32 v8, v26, v30
		v_cvt_pk_f16_f32 v9, v34, v38
		v_cvt_pk_f16_f32 v10, v42, v46
		v_cvt_pk_f16_f32 v11, v50, v54
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x60000
		v_cvt_pk_f16_f32 v8, v27, v31
		v_cvt_pk_f16_f32 v9, v35, v39
		v_cvt_pk_f16_f32 v10, v43, v47
		v_cvt_pk_f16_f32 v11, v51, v55
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[128:131], v[84:87]
		s_add_i32 s26, s6, 0x4000
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[72:75], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[124:127], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[120:123], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[116:119], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[76:79], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[108:111], v[56:59]
		s_add_i32 s31, s6, 0x24000
		s_add_i32 s40, s6, 0x44000
		v_cvt_pk_f16_f32 v11, v80, v84
		v_cvt_pk_f16_f32 v15, v81, v85
		v_cvt_pk_f16_f32 v10, v72, v76
		v_cvt_pk_f16_f32 v14, v73, v77
		v_cvt_pk_f16_f32 v9, v64, v68
		v_cvt_pk_f16_f32 v13, v65, v69
		v_cvt_pk_f16_f32 v8, v56, v60
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x64000
		v_cvt_pk_f16_f32 v12, v57, v61
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		v_cvt_pk_f16_f32 v8, v58, v62
		v_cvt_pk_f16_f32 v9, v66, v70
		v_cvt_pk_f16_f32 v10, v74, v78
		v_cvt_pk_f16_f32 v11, v82, v86
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s40 offen sc0 nt
		s_nop 0
		v_cvt_pk_f16_f32 v8, v59, v63
		v_cvt_pk_f16_f32 v9, v67, v71
		v_cvt_pk_f16_f32 v10, v75, v79
		v_cvt_pk_f16_f32 v11, v83, v87
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[108:111], v[88:91]
		s_add_i32 s26, s6, 0x8000
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[76:79], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[116:119], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[120:123], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[124:127], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[72:75], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[128:131], v[116:119]
		s_add_i32 s31, s6, 0x28000
		s_add_i32 s40, s6, 0x48000
		v_cvt_pk_f16_f32 v8, v88, v92
		v_cvt_pk_f16_f32 v12, v89, v93
		v_cvt_pk_f16_f32 v9, v96, v100
		v_cvt_pk_f16_f32 v13, v97, v101
		v_cvt_pk_f16_f32 v10, v104, v108
		v_cvt_pk_f16_f32 v14, v105, v109
		v_cvt_pk_f16_f32 v11, v112, v116
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x68000
		v_cvt_pk_f16_f32 v15, v113, v117
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[148:151], a[64:67], a[128:131], v[148:151]
		v_cvt_pk_f16_f32 v8, v90, v94
		v_cvt_pk_f16_f32 v9, v98, v102
		v_cvt_pk_f16_f32 v10, v106, v110
		v_cvt_pk_f16_f32 v11, v114, v118
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s40 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], a[72:75], v[144:147]
		v_cvt_pk_f16_f32 v8, v91, v95
		v_cvt_pk_f16_f32 v9, v99, v103
		v_cvt_pk_f16_f32 v10, v107, v111
		v_cvt_pk_f16_f32 v11, v115, v119
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s26 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[124:127], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[64:67], a[120:123], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[64:67], a[116:119], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_cvt_pk_f16_f32 v15, v144, v148
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v19, v145, v149
		s_add_i32 s26, s42, 0x2280080
		buffer_load_dwordx4 v0, s[20:23], s26 offen lds
		v_cvt_pk_f16_f32 v23, v146, v150
		s_add_i32 s26, s6, 0xc000
		v_cvt_pk_f16_f32 v14, v136, v140
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v18, v137, v141
		s_add_i32 s31, s42, 0x2300080
		buffer_load_dwordx4 v0, s[20:23], s31 offen lds
		v_cvt_pk_f16_f32 v22, v138, v142
		s_mul_i32 s31, 0x2080, s29
		v_cvt_pk_f16_f32 v26, v139, v143
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v27, v147, v151
		s_add_i32 s40, s42, 0x2380080
		buffer_load_dwordx4 v0, s[20:23], s40 offen lds
		v_mfma_f32_16x16x32_f16 v[128:131], a[64:67], a[76:79], v[128:131]
		s_mul_i32 s31, s31, 4
		v_add_u32_e32 v8, s31, v5
		v_add_u32_e32 v7, s31, v6
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[124:127], a[64:67], a[112:115], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[64:67], a[108:111], v[120:123]
		s_add_i32 s31, s6, 0x2c000
		s_add_i32 s40, s6, 0x4c000
		v_cvt_pk_f16_f32 v13, v128, v132
		v_cvt_pk_f16_f32 v17, v129, v133
		v_cvt_pk_f16_f32 v21, v130, v134
		v_cvt_pk_f16_f32 v25, v131, v135
		s_add_i32 s41, s6, 0x6c000
		s_add_i32 s42, s6, 0x10000
		v_cvt_pk_f16_f32 v12, v120, v124
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x30000
		v_cvt_pk_f16_f32 v16, v121, v125
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s31, s6, 0x50000
		v_cvt_pk_f16_f32 v20, v122, v126
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s40 offen sc0 nt
		s_add_i32 s40, s6, 0x70000
		v_cvt_pk_f16_f32 v24, v123, v127
		buffer_store_dwordx4 v[24:27], v1, s[8:11], s41 offen sc0 nt
		v_add_u32_e32 v2, 0x10000, v7
		ds_read_b128 a[48:51], v2 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], a[112:115], v[156:159]
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], a[76:79], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], a[116:119], v[164:167]
		ds_read_b128 a[52:55], v2 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[120:123], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[124:127], v[172:175]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[72:75], v[176:179]
		v_cvt_pk_f16_f32 v12, v152, v156
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[128:131], v[180:183]
		v_cvt_pk_f16_f32 v16, v153, v157
		v_cvt_pk_f16_f32 v13, v160, v164
		v_cvt_pk_f16_f32 v17, v161, v165
		v_cvt_pk_f16_f32 v20, v154, v158
		v_cvt_pk_f16_f32 v14, v168, v172
		v_cvt_pk_f16_f32 v18, v169, v173
		v_cvt_pk_f16_f32 v21, v162, v166
		v_cvt_pk_f16_f32 v22, v170, v174
		v_cvt_pk_f16_f32 v15, v176, v180
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s42 offen sc0 nt
		s_add_i32 s41, s6, 0x14000
		v_cvt_pk_f16_f32 v19, v177, v181
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x34000
		v_cvt_pk_f16_f32 v23, v178, v182
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s31, s6, 0x54000
		v_cvt_pk_f16_f32 v12, v155, v159
		v_cvt_pk_f16_f32 v13, v163, v167
		v_cvt_pk_f16_f32 v14, v171, v175
		v_cvt_pk_f16_f32 v15, v179, v183
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s40 offen sc0 nt
		ds_read_b128 a[56:59], v2 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[68:71], a[128:131], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[68:71], a[72:75], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[68:71], a[124:127], v[204:207]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[120:123], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[116:119], v[196:199]
		ds_read_b128 a[60:63], v2 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[76:79], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[112:115], v[188:191]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[108:111], v[184:187]
		v_cvt_pk_f16_f32 v15, v208, v212
		v_cvt_pk_f16_f32 v19, v209, v213
		v_cvt_pk_f16_f32 v14, v200, v204
		v_cvt_pk_f16_f32 v18, v201, v205
		v_cvt_pk_f16_f32 v22, v202, v206
		v_cvt_pk_f16_f32 v13, v192, v196
		v_cvt_pk_f16_f32 v17, v193, v197
		v_cvt_pk_f16_f32 v21, v194, v198
		v_cvt_pk_f16_f32 v12, v184, v188
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s41 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[108:111], v[216:219]
		v_cvt_pk_f16_f32 v16, v185, v189
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x74000
		v_cvt_pk_f16_f32 v20, v186, v190
		v_cvt_pk_f16_f32 v23, v210, v214
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s31, s6, 0x18000
		v_cvt_pk_f16_f32 v12, v187, v191
		v_cvt_pk_f16_f32 v13, v195, v199
		v_cvt_pk_f16_f32 v14, v203, v207
		v_cvt_pk_f16_f32 v15, v211, v215
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		ds_read_b128 a[64:67], v2 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[76:79], v[224:227]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[116:119], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[120:123], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[124:127], v[236:239]
		ds_read_b128 a[68:71], v2 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[72:75], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[132:135], a[128:131], v[244:247]
		v_cvt_pk_f16_f32 v12, v216, v220
		v_cvt_pk_f16_f32 v16, v217, v221
		v_cvt_pk_f16_f32 v20, v218, v222
		v_cvt_pk_f16_f32 v13, v224, v228
		v_cvt_pk_f16_f32 v17, v225, v229
		v_cvt_pk_f16_f32 v14, v232, v236
		v_cvt_pk_f16_f32 v18, v233, v237
		v_cvt_pk_f16_f32 v21, v226, v230
		v_cvt_pk_f16_f32 v15, v240, v244
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s31 offen sc0 nt
		s_add_i32 s26, s6, 0x38000
		v_cvt_pk_f16_f32 v19, v241, v245
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x58000
		v_cvt_pk_f16_f32 v22, v234, v238
		v_cvt_pk_f16_f32 v23, v242, v246
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x78000
		v_cvt_pk_f16_f32 v12, v219, v223
		v_cvt_pk_f16_f32 v13, v227, v231
		v_cvt_pk_f16_f32 v14, v235, v239
		v_cvt_pk_f16_f32 v15, v243, v247
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[128:131], a[104:107]
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[72:75], a[100:103]
		ds_read_b128 a[72:75], v2 offset:1792
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[120:123], a[92:95]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[116:119], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[76:79], a[84:87]
		ds_read_b128 a[76:79], v2 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v3, a104
		v_cvt_pk_f16_f32 v15, v2, v3
		s_add_i32 s26, s6, 0x1c000
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a96
		v_cvt_pk_f16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a93
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_f16_f32 v18, v2, v3
		v_accvgpr_read_b32 v2, a101
		v_accvgpr_read_b32 v3, a105
		v_cvt_pk_f16_f32 v19, v2, v3
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v3, a88
		v_cvt_pk_f16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a85
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v17, v2, v3
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v3, a90
		v_cvt_pk_f16_f32 v21, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a98
		v_cvt_pk_f16_f32 v22, v2, v3
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v3, a106
		v_cvt_pk_f16_f32 v23, v2, v3
		v_accvgpr_read_b32 v2, a80
		v_cvt_pk_f16_f32 v12, v2, v248
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x3c000
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v16, v2, v249
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s26, s6, 0x5c000
		v_accvgpr_read_b32 v2, a82
		v_cvt_pk_f16_f32 v20, v2, v250
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s26 offen sc0 nt
		s_add_i32 s6, s6, 0x7c000
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v12, v2, v251
		v_accvgpr_read_b32 v2, a87
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v13, v2, v3
		v_accvgpr_read_b32 v2, a95
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_f16_f32 v14, v2, v3
		v_accvgpr_read_b32 v2, a103
		v_accvgpr_read_b32 v3, a107
		v_cvt_pk_f16_f32 v15, v2, v3
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s6 offen sc0 nt
		s_cmp_lt_i32 s7, 0x300
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_2
.Lgfx950_f16_streamk_gemm.loop_exit_2:
.Lgfx950_f16_streamk_gemm.if_end_0:
		v_accvgpr_read_b32 v0, a4
		v_add_u32_e32 v0, 0x6000080, v0
		v_accvgpr_read_b32 v2, a4
		v_add_u32_e32 v2, 0x6080080, v2
		v_accvgpr_read_b32 v3, a4
		v_add_u32_e32 v3, 0x6100080, v3
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v4, 0x6180080, v4
		v_accvgpr_read_b32 v9, a4
		v_add_u32_e32 v9, 0x6200080, v9
		v_accvgpr_read_b32 v10, a4
		v_add_u32_e32 v10, 0x6280080, v10
		v_accvgpr_read_b32 v11, a4
		v_add_u32_e32 v11, 0x6300080, v11
		v_accvgpr_read_b32 v12, a4
		v_add_u32_e32 v12, 0x6380080, v12
		s_cbranch_scc0 .Lgfx950_f16_streamk_gemm.if_else_1
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_mov_b64_e32 v[20:21], 0
		v_mov_b64_e32 v[22:23], 0
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
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
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], a[16:19], a[0:3]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		ds_read_b128 a[96:99], v8 offset:64
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], a[48:51], a[20:23], v[16:19]
		s_add_i32 s27, s27, 1
		s_and_b32 s0, s27, 1
		s_mul_i32 s0, 0x8200, s0
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[20:23], a[48:51], a[24:27], v[20:23]
		ds_read_b128 a[100:103], v8 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[28:31], v[24:27]
		s_mul_i32 s2, 0xffffdf80, s29
		s_sub_i32 s29, s28, s29
		s_add_i32 s2, s2, 0x2080
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[32:35], v[28:31]
		ds_read_b128 a[104:107], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[36:39], v[32:35]
		s_mul_i32 s2, s2, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[40:43], v[36:39]
		ds_read_b128 a[108:111], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[44:47], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[44:47], v[72:75]
		ds_read_b128 a[112:115], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[36:39], v[64:67]
		ds_read_b128 a[116:119], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[28:31], v[56:59]
		ds_read_b128 a[120:123], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[52:55], a[52:55], a[24:27], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], a[20:23], v[48:51]
		ds_read_b128 a[124:127], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[16:19], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], a[20:23], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[56:59], a[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[28:31], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[36:39], v[96:99]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[40:43], v[100:103]
		s_mov_b32 m0, s25
		ds_read_b128 a[48:51], v7 offset:1088
		v_accvgpr_read_b32 v8, a13
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[44:47], v[136:139]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v7 offset:1216
		v_accvgpr_read_b32 v8, a12
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[36:39], v[128:131]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[32:35], v[124:127]
		v_accvgpr_read_b32 v8, a11
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[56:59], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[28:31], v[120:123]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[116:119], a[60:63], a[24:27], v[116:119]
		v_accvgpr_read_b32 v8, a10
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[128:131], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[112:115], a[60:63], a[20:23], v[112:115]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[108:111], a[60:63], a[16:19], v[108:111]
		v_accvgpr_read_b32 v8, a9
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[16:19], v[140:143]
		ds_read_b128 a[60:63], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], a[20:23], v[144:147]
		s_add_i32 s25, s1, s0
		v_mfma_f32_16x16x32_f16 v[148:151], a[64:67], a[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[28:31], v[152:155]
		ds_read_b128 a[132:135], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[36:39], v[160:163]
		ds_read_b128 a[136:139], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[44:47], v[168:171]
		v_add_u32_e32 v8, s2, v5
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[44:47], v[200:203]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[68:71], a[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[68:71], a[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[68:71], a[16:19], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[72:75], a[16:19], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[72:75], a[20:23], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[72:75], a[24:27], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[28:31], v[216:219]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[28:31], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[32:35], v[220:223]
		v_accvgpr_read_b32 v7, a8
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[36:39], a[84:87]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[40:43], v[228:231]
		v_accvgpr_read_b32 v7, a7
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[44:47], v[232:235]
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[44:47], a[92:95]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[40:43], a[88:91]
		v_accvgpr_read_b32 v7, a6
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[32:35], a[80:83]
		v_mfma_f32_16x16x32_f16 v[244:247], a[76:79], a[24:27], v[244:247]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[240:243], a[76:79], a[20:23], v[240:243]
		buffer_load_dwordx4 v0, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[76:79], a[16:19], v[236:239]
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], a[96:99], a[0:3]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v7, s2, v6
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add_u32_e32 v13, 0x10000, v7
		v_mfma_f32_16x16x32_f16 v[16:19], a[48:51], a[100:103], v[16:19]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[20:23], a[48:51], a[104:107], v[20:23]
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[108:111], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[112:115], v[28:31]
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[116:119], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[120:123], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[124:127], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[124:127], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[52:55], a[104:107], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], a[100:103], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[96:99], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[96:99], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], a[100:103], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[56:59], a[104:107], v[84:87]
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[108:111], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[120:123], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[124:127], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[128:131], a[124:127], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[128:131], a[120:123], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[128:131], a[116:119], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[128:131], a[112:115], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[128:131], a[108:111], v[120:123]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[116:119], a[128:131], a[104:107], v[116:119]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[112:115], a[128:131], a[100:103], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[128:131], a[96:99], v[108:111]
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		ds_read_b128 a[48:51], v13 offset:1024
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[96:99], v[140:143]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[100:103], v[144:147]
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[104:107], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v13 offset:1152
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[60:63], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[60:63], a[112:115], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[60:63], a[116:119], v[160:163]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[164:167], a[60:63], a[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[60:63], a[124:127], v[168:171]
		ds_read_b128 a[56:59], v13 offset:1280
		v_mfma_f32_16x16x32_f16 v[200:203], a[132:135], a[124:127], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[132:135], a[120:123], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[132:135], a[116:119], v[192:195]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[188:191], a[132:135], a[112:115], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[132:135], a[108:111], v[184:187]
		ds_read_b128 a[60:63], v13 offset:1408
		v_mfma_f32_16x16x32_f16 v[180:183], a[132:135], a[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[132:135], a[100:103], v[176:179]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[172:175], a[132:135], a[96:99], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[136:139], a[96:99], v[204:207]
		ds_read_b128 a[64:67], v13 offset:1536
		v_mfma_f32_16x16x32_f16 v[208:211], a[136:139], a[100:103], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[136:139], a[104:107], v[212:215]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[216:219], a[136:139], a[108:111], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[136:139], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[136:139], a[116:119], v[224:227]
		ds_read_b128 a[68:71], v13 offset:1664
		v_mfma_f32_16x16x32_f16 v[228:231], a[136:139], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[136:139], a[124:127], v[232:235]
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		ds_read_b128 a[72:75], v13 offset:1792
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[108:111], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], a[104:107], v[244:247]
		ds_read_b128 a[76:79], v13 offset:1920
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], a[100:103], v[240:243]
		s_cmp_lt_i32 s27, 0x7e
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], a[96:99], v[236:239]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_4
.Lgfx950_f16_streamk_gemm.loop_exit_4:
		s_branch .Lgfx950_f16_streamk_gemm.if_end_1
.Lgfx950_f16_streamk_gemm.if_else_1:
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_mov_b64_e32 v[20:21], 0
		v_mov_b64_e32 v[22:23], 0
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
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
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_5:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], a[16:19], a[0:3]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		ds_read_b128 a[96:99], v8 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[16:19], a[48:51], a[20:23], v[16:19]
		s_add_i32 s27, s27, 1
		s_and_b32 s0, s27, 1
		s_mul_i32 s0, 0x8200, s0
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[20:23], a[48:51], a[24:27], v[20:23]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[28:31], v[24:27]
		ds_read_b128 a[100:103], v8 offset:192
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[32:35], v[28:31]
		ds_read_b128 a[104:107], v8 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[36:39], v[32:35]
		s_mul_i32 s2, 0xffffdf80, s29
		s_sub_i32 s29, s28, s29
		s_add_i32 s2, s2, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[40:43], v[36:39]
		ds_read_b128 a[108:111], v8 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[44:47], v[40:43]
		s_mul_i32 s2, s2, 4
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[40:43], v[68:71]
		ds_read_b128 a[112:115], v8 offset:576
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[32:35], v[60:63]
		ds_read_b128 a[116:119], v8 offset:704
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[28:31], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[52:55], a[24:27], v[52:55]
		ds_read_b128 a[120:123], v8 offset:832
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], a[20:23], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[16:19], v[44:47]
		ds_read_b128 a[124:127], v8 offset:960
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], a[20:23], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[56:59], a[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[28:31], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[36:39], v[96:99]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[40:43], v[100:103]
		s_mov_b32 m0, s25
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[44:47], v[136:139]
		v_accvgpr_read_b32 v8, a13
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1088
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[36:39], v[128:131]
		v_accvgpr_read_b32 v8, a12
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[52:55], v7 offset:1216
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[32:35], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[60:63], a[24:27], v[116:119]
		v_accvgpr_read_b32 v8, a11
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[56:59], v7 offset:1344
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[112:115], a[60:63], a[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[60:63], a[16:19], v[108:111]
		v_accvgpr_read_b32 v8, a10
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[60:63], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[16:19], v[140:143]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[128:131], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], a[20:23], v[144:147]
		v_accvgpr_read_b32 v8, a9
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[148:151], a[64:67], a[24:27], v[148:151]
		s_add_i32 s25, s1, s0
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[28:31], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[32:35], v[156:159]
		ds_read_b128 a[132:135], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[40:43], v[164:167]
		ds_read_b128 a[136:139], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[44:47], v[168:171]
		v_add_u32_e32 v8, s2, v5
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[40:43], v[196:199]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[68:71], a[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[68:71], a[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[68:71], a[16:19], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[72:75], a[16:19], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[72:75], a[20:23], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[72:75], a[24:27], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[28:31], v[216:219]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[28:31], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[32:35], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[36:39], v[224:227]
		v_accvgpr_read_b32 v7, a8
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[44:47], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[44:47], a[92:95]
		v_accvgpr_read_b32 v7, a7
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[40:43], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[36:39], a[84:87]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[32:35], a[80:83]
		v_accvgpr_read_b32 v7, a6
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[244:247], a[76:79], a[24:27], v[244:247]
		v_mfma_f32_16x16x32_f16 v[240:243], a[76:79], a[20:23], v[240:243]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[236:239], a[76:79], a[16:19], v[236:239]
		buffer_load_dwordx4 v0, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s2, v6
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], a[96:99], a[0:3]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v13, 0x10000, v7
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[16:19], a[48:51], a[100:103], v[16:19]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[20:23], a[48:51], a[104:107], v[20:23]
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[108:111], v[24:27]
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[112:115], v[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[116:119], v[32:35]
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[120:123], v[36:39]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[124:127], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[124:127], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[120:123], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[116:119], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[112:115], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[108:111], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[52:55], a[104:107], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], a[100:103], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[96:99], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[96:99], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], a[100:103], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[56:59], a[104:107], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[108:111], v[88:91]
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[112:115], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[116:119], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[120:123], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[124:127], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[124:127], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[120:123], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[116:119], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[112:115], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[108:111], v[120:123]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[116:119], a[60:63], a[104:107], v[116:119]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		ds_read_b128 a[16:19], v8
		v_mfma_f32_16x16x32_f16 v[112:115], a[60:63], a[100:103], v[112:115]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[48:51], v13 offset:1024
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		ds_read_b128 a[20:23], v8 offset:128
		v_mfma_f32_16x16x32_f16 v[108:111], a[60:63], a[96:99], v[108:111]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[52:55], v13 offset:1152
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[140:143], a[128:131], a[96:99], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[128:131], a[100:103], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[128:131], a[104:107], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[128:131], a[108:111], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[128:131], a[112:115], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[128:131], a[116:119], v[160:163]
		ds_read_b128 a[24:27], v8 offset:256
		v_mfma_f32_16x16x32_f16 v[164:167], a[128:131], a[120:123], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[128:131], a[124:127], v[168:171]
		ds_read_b128 a[56:59], v13 offset:1280
		v_mfma_f32_16x16x32_f16 v[200:203], a[132:135], a[124:127], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[132:135], a[120:123], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[132:135], a[116:119], v[192:195]
		ds_read_b128 a[28:31], v8 offset:384
		v_mfma_f32_16x16x32_f16 v[188:191], a[132:135], a[112:115], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[132:135], a[108:111], v[184:187]
		ds_read_b128 a[60:63], v13 offset:1408
		v_mfma_f32_16x16x32_f16 v[180:183], a[132:135], a[104:107], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[132:135], a[100:103], v[176:179]
		ds_read_b128 a[32:35], v8 offset:512
		v_mfma_f32_16x16x32_f16 v[172:175], a[132:135], a[96:99], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[136:139], a[96:99], v[204:207]
		ds_read_b128 a[64:67], v13 offset:1536
		v_mfma_f32_16x16x32_f16 v[208:211], a[136:139], a[100:103], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[136:139], a[104:107], v[212:215]
		ds_read_b128 a[36:39], v8 offset:640
		v_mfma_f32_16x16x32_f16 v[216:219], a[136:139], a[108:111], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[136:139], a[112:115], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[136:139], a[116:119], v[224:227]
		ds_read_b128 a[68:71], v13 offset:1664
		v_mfma_f32_16x16x32_f16 v[228:231], a[136:139], a[120:123], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[136:139], a[124:127], v[232:235]
		ds_read_b128 a[40:43], v8 offset:768
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		ds_read_b128 a[72:75], v13 offset:1792
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		ds_read_b128 a[44:47], v8 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[108:111], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], a[104:107], v[244:247]
		ds_read_b128 a[76:79], v13 offset:1920
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], a[100:103], v[240:243]
		s_cmp_lt_i32 s27, 0x7e
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], a[96:99], v[236:239]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_5
.Lgfx950_f16_streamk_gemm.loop_exit_5:
.Lgfx950_f16_streamk_gemm.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], a[16:19], a[0:3]
		v_add_u32_e32 v0, 0x10000, v7
		ds_read_b128 v[12:15], v0 offset:1088
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[16:19], v[44:47]
		ds_read_b128 a[4:7], v0 offset:1216
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[16:19], v[76:79]
		ds_read_b128 a[8:11], v0 offset:1344
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[108:111], a[60:63], a[16:19], v[108:111]
		ds_read_b128 a[12:15], v0 offset:1472
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[16:19], v[140:143]
		ds_read_b128 a[96:99], v0 offset:1600
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[172:175], a[68:71], a[16:19], v[172:175]
		ds_read_b128 a[100:103], v0 offset:1728
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[204:207], a[72:75], a[16:19], v[204:207]
		ds_read_b128 a[104:107], v0 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[236:239], a[76:79], a[16:19], v[236:239]
		ds_read_b128 a[16:19], v0 offset:1984
		v_mfma_f32_16x16x32_f16 v[16:19], a[48:51], a[20:23], v[16:19]
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], a[20:23], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], a[20:23], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[60:63], a[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], a[20:23], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[68:71], a[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[72:75], a[20:23], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[76:79], a[20:23], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[76:79], a[24:27], v[244:247]
		v_mfma_f32_16x16x32_f16 v[20:23], a[48:51], a[24:27], v[20:23]
		v_mfma_f32_16x16x32_f16 v[52:55], a[52:55], a[24:27], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[56:59], a[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[60:63], a[24:27], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[64:67], a[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[68:71], a[24:27], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[72:75], a[24:27], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[72:75], a[28:31], v[216:219]
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[28:31], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[28:31], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[28:31], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[64:67], a[28:31], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[68:71], a[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[248:251], a[76:79], a[28:31], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], a[76:79], a[32:35], a[80:83]
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[32:35], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[32:35], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[64:67], a[32:35], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[68:71], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[72:75], a[32:35], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[72:75], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[36:39], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[64:67], a[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[68:71], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 a[84:87], a[76:79], a[36:39], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[76:79], a[40:43], a[88:91]
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[40:43], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[64:67], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[68:71], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[228:231], a[72:75], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[72:75], a[44:47], v[232:235]
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[44:47], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[64:67], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[68:71], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 a[92:95], a[76:79], a[44:47], a[92:95]
		ds_read_b128 a[20:23], v8 offset:64
		ds_read_b128 a[24:27], v8 offset:192
		ds_read_b128 a[28:31], v8 offset:320
		ds_read_b128 a[32:35], v8 offset:448
		ds_read_b128 a[36:39], v8 offset:576
		ds_read_b128 a[40:43], v8 offset:704
		ds_read_b128 a[44:47], v8 offset:832
		ds_read_b128 v[252:255], v8 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], v[12:15], a[20:23], a[0:3]
		s_mul_i32 s0, 0xffffdf80, s29
		s_add_i32 s0, s0, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[16:19], v[12:15], a[24:27], v[16:19]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[20:23], v[12:15], a[28:31], v[20:23]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[24:27], v[12:15], a[32:35], v[24:27]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[28:31], v[12:15], a[36:39], v[28:31]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[32:35], v[12:15], a[40:43], v[32:35]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], a[44:47], v[36:39]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], v[252:255], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[4:7], v[252:255], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[4:7], a[44:47], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[4:7], a[40:43], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[4:7], a[36:39], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[4:7], a[32:35], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[4:7], a[28:31], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[4:7], a[24:27], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[4:7], a[20:23], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[8:11], a[20:23], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[8:11], a[24:27], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[8:11], a[28:31], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[8:11], a[32:35], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[8:11], a[36:39], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[8:11], a[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[8:11], a[44:47], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[8:11], v[252:255], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[12:15], v[252:255], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[12:15], a[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[12:15], a[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[12:15], a[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[12:15], a[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[12:15], a[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[12:15], a[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[12:15], a[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[96:99], a[20:23], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[96:99], a[24:27], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[96:99], a[28:31], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[96:99], a[32:35], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[96:99], a[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[96:99], a[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[96:99], a[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[96:99], v[252:255], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[100:103], v[252:255], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[100:103], a[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[100:103], a[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[100:103], a[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[100:103], a[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[100:103], a[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[100:103], a[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[100:103], a[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[104:107], a[20:23], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[104:107], a[24:27], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[104:107], a[28:31], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[104:107], a[32:35], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[104:107], a[36:39], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[104:107], a[40:43], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[104:107], a[44:47], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[104:107], v[252:255], v[232:235]
		v_mfma_f32_16x16x32_f16 a[92:95], a[16:19], v[252:255], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[16:19], a[44:47], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[16:19], a[40:43], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[16:19], a[36:39], a[80:83]
		v_mfma_f32_16x16x32_f16 v[248:251], a[16:19], a[32:35], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], a[16:19], a[28:31], v[244:247]
		v_mfma_f32_16x16x32_f16 v[240:243], a[16:19], a[24:27], v[240:243]
		v_mfma_f32_16x16x32_f16 v[236:239], a[16:19], a[20:23], v[236:239]
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshl_b32 s0, s0, 2
		v_add_u32_e32 v0, s0, v5
		ds_read_b128 v[8:11], v0
		ds_read_b128 v[12:15], v0 offset:128
		ds_read_b128 a[4:7], v0 offset:256
		ds_read_b128 a[8:11], v0 offset:384
		ds_read_b128 a[12:15], v0 offset:512
		ds_read_b128 a[16:19], v0 offset:640
		ds_read_b128 a[20:23], v0 offset:768
		ds_read_b128 a[24:27], v0 offset:896
		s_add_i32 s0, s0, 0x10000
		v_add_u32_e32 v2, s0, v6
		ds_read_b128 a[28:31], v2 offset:1024
		ds_read_b128 a[32:35], v2 offset:1152
		ds_read_b128 a[36:39], v2 offset:1280
		ds_read_b128 a[40:43], v2 offset:1408
		ds_read_b128 a[44:47], v2 offset:1536
		ds_read_b128 a[48:51], v2 offset:1664
		ds_read_b128 v[4:7], v2 offset:1792
		ds_read_b128 a[52:55], v2 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], a[28:31], v[8:11], a[0:3]
		ds_read_b128 a[56:59], v2 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], v[8:11], v[44:47]
		ds_read_b128 a[60:63], v2 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], v[8:11], v[76:79]
		ds_read_b128 a[64:67], v2 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], v[8:11], v[108:111]
		ds_read_b128 a[68:71], v2 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], v[8:11], v[140:143]
		ds_read_b128 a[72:75], v2 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[172:175], a[48:51], v[8:11], v[172:175]
		ds_read_b128 a[76:79], v2 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[204:207], v[4:7], v[8:11], v[204:207]
		ds_read_b128 a[96:99], v2 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[236:239], a[52:55], v[8:11], v[236:239]
		ds_read_b128 a[100:103], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[16:19], a[28:31], v[12:15], v[16:19]
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], v[12:15], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], v[12:15], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], v[12:15], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], v[12:15], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[48:51], v[12:15], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], v[4:7], v[12:15], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], v[12:15], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], a[4:7], v[244:247]
		v_mfma_f32_16x16x32_f16 v[20:23], a[28:31], a[4:7], v[20:23]
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[4:7], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[4:7], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[4:7], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[4:7], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[48:51], a[4:7], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], v[4:7], a[4:7], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[4:7], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[24:27], a[28:31], a[8:11], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[32:35], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[36:39], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[40:43], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[44:47], a[8:11], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[48:51], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[248:251], a[52:55], a[8:11], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], a[52:55], a[12:15], a[80:83]
		v_mfma_f32_16x16x32_f16 v[28:31], a[28:31], a[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[32:35], a[12:15], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[36:39], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[40:43], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[44:47], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[48:51], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], v[4:7], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[4:7], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[32:35], a[28:31], a[16:19], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[32:35], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[36:39], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[40:43], a[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[44:47], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[48:51], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 a[84:87], a[52:55], a[16:19], a[84:87]
		v_mfma_f32_16x16x32_f16 a[88:91], a[52:55], a[20:23], a[88:91]
		v_mfma_f32_16x16x32_f16 v[36:39], a[28:31], a[20:23], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[32:35], a[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[36:39], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[40:43], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[44:47], a[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[48:51], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[228:231], v[4:7], a[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[4:7], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[40:43], a[28:31], a[24:27], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[32:35], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[36:39], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[40:43], a[24:27], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[44:47], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[48:51], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 a[92:95], a[52:55], a[24:27], a[92:95]
		ds_read_b128 a[4:7], v0 offset:64
		ds_read_b128 a[8:11], v0 offset:192
		ds_read_b128 a[12:15], v0 offset:320
		ds_read_b128 a[16:19], v0 offset:448
		ds_read_b128 a[20:23], v0 offset:576
		ds_read_b128 a[24:27], v0 offset:704
		ds_read_b128 a[28:31], v0 offset:832
		ds_read_b128 a[32:35], v0 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], a[56:59], a[4:7], a[0:3]
		s_add_i32 s0, s12, s13
		s_add_i32 s0, s0, s24
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[16:19], a[56:59], a[8:11], v[16:19]
		s_add_i32 s0, s0, s30
		s_add_i32 s0, s0, s15
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[20:23], a[56:59], a[12:15], v[20:23]
		s_add_i32 s1, s0, 0x6000000
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[24:27], a[56:59], a[16:19], v[24:27]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[28:31], a[56:59], a[20:23], v[28:31]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[32:35], a[56:59], a[24:27], v[32:35]
		v_accvgpr_read_b32 v0, a0
		v_cvt_pk_f16_f32 v4, v0, v16
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[36:39], a[56:59], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[40:43], a[56:59], a[32:35], v[40:43]
		v_accvgpr_read_b32 v0, a1
		v_cvt_pk_f16_f32 v8, v0, v17
		v_accvgpr_read_b32 v0, a2
		v_cvt_pk_f16_f32 v12, v0, v18
		v_accvgpr_read_b32 v0, a3
		v_cvt_pk_f16_f32 v252, v0, v19
		v_cvt_pk_f16_f32 v5, v20, v24
		v_cvt_pk_f16_f32 v9, v21, v25
		v_cvt_pk_f16_f32 v6, v28, v32
		v_cvt_pk_f16_f32 v10, v29, v33
		v_cvt_pk_f16_f32 v13, v22, v26
		v_cvt_pk_f16_f32 v7, v36, v40
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6020000
		v_cvt_pk_f16_f32 v11, v37, v41
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6040000
		v_cvt_pk_f16_f32 v14, v30, v34
		v_cvt_pk_f16_f32 v15, v38, v42
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6060000
		v_cvt_pk_f16_f32 v253, v23, v27
		v_cvt_pk_f16_f32 v254, v31, v35
		v_cvt_pk_f16_f32 v255, v39, v43
		buffer_store_dwordx4 v[252:255], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[72:75], a[60:63], a[32:35], v[72:75]
		s_add_i32 s1, s0, 0x6004000
		v_mfma_f32_16x16x32_f16 v[68:71], a[60:63], a[28:31], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[60:63], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[60:63], a[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[60:63], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[60:63], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[60:63], a[8:11], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[60:63], a[4:7], v[44:47]
		s_add_i32 s2, s0, 0x6024000
		s_add_i32 s3, s0, 0x6044000
		v_cvt_pk_f16_f32 v7, v68, v72
		v_cvt_pk_f16_f32 v11, v69, v73
		v_cvt_pk_f16_f32 v6, v60, v64
		v_cvt_pk_f16_f32 v10, v61, v65
		v_cvt_pk_f16_f32 v5, v52, v56
		v_cvt_pk_f16_f32 v9, v53, v57
		v_cvt_pk_f16_f32 v4, v44, v48
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6064000
		v_cvt_pk_f16_f32 v8, v45, v49
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		v_cvt_pk_f16_f32 v4, v46, v50
		v_cvt_pk_f16_f32 v5, v54, v58
		v_cvt_pk_f16_f32 v6, v62, v66
		v_cvt_pk_f16_f32 v7, v70, v74
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s3 offen sc0 nt
		s_nop 0
		v_cvt_pk_f16_f32 v4, v47, v51
		v_cvt_pk_f16_f32 v5, v55, v59
		v_cvt_pk_f16_f32 v6, v63, v67
		v_cvt_pk_f16_f32 v7, v71, v75
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[76:79], a[64:67], a[4:7], v[76:79]
		s_add_i32 s1, s0, 0x6008000
		v_mfma_f32_16x16x32_f16 v[80:83], a[64:67], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[64:67], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[64:67], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[64:67], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[64:67], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[64:67], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[64:67], a[32:35], v[104:107]
		s_add_i32 s2, s0, 0x6028000
		s_add_i32 s3, s0, 0x6048000
		v_cvt_pk_f16_f32 v4, v76, v80
		v_cvt_pk_f16_f32 v8, v77, v81
		v_cvt_pk_f16_f32 v5, v84, v88
		v_cvt_pk_f16_f32 v9, v85, v89
		v_cvt_pk_f16_f32 v6, v92, v96
		v_cvt_pk_f16_f32 v10, v93, v97
		v_cvt_pk_f16_f32 v7, v100, v104
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6068000
		v_cvt_pk_f16_f32 v11, v101, v105
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[136:139], a[68:71], a[32:35], v[136:139]
		v_cvt_pk_f16_f32 v4, v78, v82
		v_cvt_pk_f16_f32 v5, v86, v90
		v_cvt_pk_f16_f32 v6, v94, v98
		v_cvt_pk_f16_f32 v7, v102, v106
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s3 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[132:135], a[68:71], a[28:31], v[132:135]
		v_cvt_pk_f16_f32 v4, v79, v83
		v_cvt_pk_f16_f32 v5, v87, v91
		v_cvt_pk_f16_f32 v6, v95, v99
		v_cvt_pk_f16_f32 v7, v103, v107
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[128:131], a[68:71], a[24:27], v[128:131]
		s_add_i32 s1, s0, 0x600c000
		v_mfma_f32_16x16x32_f16 v[124:127], a[68:71], a[20:23], v[124:127]
		v_cvt_pk_f16_f32 v7, v132, v136
		v_mfma_f32_16x16x32_f16 v[120:123], a[68:71], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[68:71], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[68:71], a[8:11], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[68:71], a[4:7], v[108:111]
		v_cvt_pk_f16_f32 v11, v133, v137
		v_cvt_pk_f16_f32 v15, v134, v138
		v_cvt_pk_f16_f32 v19, v135, v139
		v_cvt_pk_f16_f32 v6, v124, v128
		v_cvt_pk_f16_f32 v10, v125, v129
		v_cvt_pk_f16_f32 v14, v126, v130
		v_cvt_pk_f16_f32 v5, v116, v120
		v_cvt_pk_f16_f32 v9, v117, v121
		v_cvt_pk_f16_f32 v4, v108, v112
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x602c000
		v_cvt_pk_f16_f32 v8, v109, v113
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x604c000
		v_cvt_pk_f16_f32 v12, v110, v114
		v_cvt_pk_f16_f32 v13, v118, v122
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x606c000
		v_cvt_pk_f16_f32 v16, v111, v115
		v_cvt_pk_f16_f32 v17, v119, v123
		v_cvt_pk_f16_f32 v18, v127, v131
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[140:143], a[72:75], a[4:7], v[140:143]
		s_add_i32 s1, s0, 0x6010000
		v_mfma_f32_16x16x32_f16 v[144:147], a[72:75], a[8:11], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[72:75], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[72:75], a[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[72:75], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[72:75], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[72:75], a[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[72:75], a[32:35], v[168:171]
		s_add_i32 s2, s0, 0x6030000
		s_add_i32 s3, s0, 0x6050000
		v_cvt_pk_f16_f32 v4, v140, v144
		v_cvt_pk_f16_f32 v8, v141, v145
		v_cvt_pk_f16_f32 v5, v148, v152
		v_cvt_pk_f16_f32 v9, v149, v153
		v_cvt_pk_f16_f32 v6, v156, v160
		v_cvt_pk_f16_f32 v10, v157, v161
		v_cvt_pk_f16_f32 v7, v164, v168
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6070000
		v_cvt_pk_f16_f32 v11, v165, v169
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[200:203], a[76:79], a[32:35], v[200:203]
		v_cvt_pk_f16_f32 v4, v142, v146
		v_cvt_pk_f16_f32 v5, v150, v154
		v_cvt_pk_f16_f32 v6, v158, v162
		v_cvt_pk_f16_f32 v7, v166, v170
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s3 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[196:199], a[76:79], a[28:31], v[196:199]
		v_cvt_pk_f16_f32 v4, v143, v147
		v_cvt_pk_f16_f32 v5, v151, v155
		v_cvt_pk_f16_f32 v6, v159, v163
		v_cvt_pk_f16_f32 v7, v167, v171
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[192:195], a[76:79], a[24:27], v[192:195]
		s_add_i32 s1, s0, 0x6014000
		v_mfma_f32_16x16x32_f16 v[188:191], a[76:79], a[20:23], v[188:191]
		v_cvt_pk_f16_f32 v7, v196, v200
		v_mfma_f32_16x16x32_f16 v[184:187], a[76:79], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[76:79], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[76:79], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[76:79], a[4:7], v[172:175]
		v_cvt_pk_f16_f32 v11, v197, v201
		v_cvt_pk_f16_f32 v15, v198, v202
		v_cvt_pk_f16_f32 v19, v199, v203
		v_cvt_pk_f16_f32 v6, v188, v192
		v_cvt_pk_f16_f32 v10, v189, v193
		v_cvt_pk_f16_f32 v14, v190, v194
		v_cvt_pk_f16_f32 v5, v180, v184
		v_cvt_pk_f16_f32 v9, v181, v185
		v_cvt_pk_f16_f32 v4, v172, v176
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6034000
		v_cvt_pk_f16_f32 v8, v173, v177
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6054000
		v_cvt_pk_f16_f32 v12, v174, v178
		v_cvt_pk_f16_f32 v13, v182, v186
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x6074000
		v_cvt_pk_f16_f32 v16, v175, v179
		v_cvt_pk_f16_f32 v17, v183, v187
		v_cvt_pk_f16_f32 v18, v191, v195
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], a[4:7], v[204:207]
		s_add_i32 s1, s0, 0x6018000
		v_mfma_f32_16x16x32_f16 v[208:211], a[96:99], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[96:99], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[96:99], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[96:99], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[96:99], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[96:99], a[28:31], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[96:99], a[32:35], v[232:235]
		v_mfma_f32_16x16x32_f16 a[92:95], a[100:103], a[32:35], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[100:103], a[28:31], a[88:91]
		v_cvt_pk_f16_f32 v4, v204, v208
		v_mfma_f32_16x16x32_f16 a[84:87], a[100:103], a[24:27], a[84:87]
		v_cvt_pk_f16_f32 v5, v212, v216
		v_mfma_f32_16x16x32_f16 a[80:83], a[100:103], a[20:23], a[80:83]
		v_cvt_pk_f16_f32 v6, v220, v224
		v_mfma_f32_16x16x32_f16 v[248:251], a[100:103], a[16:19], v[248:251]
		v_cvt_pk_f16_f32 v7, v228, v232
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[244:247], a[100:103], a[12:15], v[244:247]
		v_cvt_pk_f16_f32 v4, v205, v209
		v_cvt_pk_f16_f32 v5, v213, v217
		v_cvt_pk_f16_f32 v6, v221, v225
		v_cvt_pk_f16_f32 v7, v229, v233
		s_add_i32 s1, s0, 0x6038000
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[240:243], a[100:103], a[8:11], v[240:243]
		v_cvt_pk_f16_f32 v4, v206, v210
		v_cvt_pk_f16_f32 v5, v214, v218
		v_cvt_pk_f16_f32 v6, v222, v226
		v_cvt_pk_f16_f32 v7, v230, v234
		s_add_i32 s1, s0, 0x6058000
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[236:239], a[100:103], a[4:7], v[236:239]
		v_cvt_pk_f16_f32 v4, v207, v211
		v_cvt_pk_f16_f32 v5, v215, v219
		v_cvt_pk_f16_f32 v6, v223, v227
		v_cvt_pk_f16_f32 v7, v231, v235
		s_add_i32 s1, s0, 0x6078000
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x601c000
		v_cvt_pk_f16_f32 v5, v244, v248
		v_cvt_pk_f16_f32 v4, v236, v240
		v_accvgpr_read_b32 v0, a80
		v_accvgpr_read_b32 v2, a84
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a88
		v_accvgpr_read_b32 v2, a92
		v_cvt_pk_f16_f32 v7, v0, v2
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x603c000
		v_cvt_pk_f16_f32 v4, v237, v241
		v_cvt_pk_f16_f32 v5, v245, v249
		v_accvgpr_read_b32 v0, a81
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a89
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v7, v0, v2
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s0, 0x605c000
		v_cvt_pk_f16_f32 v4, v238, v242
		v_cvt_pk_f16_f32 v5, v246, v250
		v_accvgpr_read_b32 v0, a82
		v_accvgpr_read_b32 v2, a86
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a90
		v_accvgpr_read_b32 v2, a94
		v_cvt_pk_f16_f32 v7, v0, v2
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s0, s0, 0x607c000
		v_cvt_pk_f16_f32 v4, v239, v243
		v_cvt_pk_f16_f32 v5, v247, v251
		v_accvgpr_read_b32 v0, a83
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a91
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v7, v0, v2
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s0 offen sc0 nt
		s_endpgm
	.size	gfx950_f16_streamk_gemm, .-gfx950_f16_streamk_gemm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel gfx950_f16_streamk_gemm
		.amdhsa_group_segment_fixed_size 133120
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 408
		.amdhsa_next_free_sgpr 47
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
	.set .Lgfx950_f16_streamk_gemm.num_vgpr, 256
	.set .Lgfx950_f16_streamk_gemm.num_agpr, 152
	.set .Lgfx950_f16_streamk_gemm.numbered_sgpr, 47
	.set .Lgfx950_f16_streamk_gemm.num_named_barrier, 0
	.set .Lgfx950_f16_streamk_gemm.private_seg_size, 0
	.set .Lgfx950_f16_streamk_gemm.uses_vcc, 0
	.set .Lgfx950_f16_streamk_gemm.uses_flat_scratch, 0
	.set .Lgfx950_f16_streamk_gemm.has_dyn_sized_stack, 0
	.set .Lgfx950_f16_streamk_gemm.has_recursion, 0
	.set .Lgfx950_f16_streamk_gemm.has_indirect_call, 0
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
    .group_segment_fixed_size: 133120
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           gfx950_f16_streamk_gemm
    .private_segment_fixed_size: 0
    .sgpr_count:     47
    .sgpr_spill_count: 0
    .symbol:         gfx950_f16_streamk_gemm.kd
    .uses_dynamic_stack: false
    .vgpr_count:     408
    .agpr_count:     152
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 219
    wave.regalloc.agpr.dwords: 842
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
