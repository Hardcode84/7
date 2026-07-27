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
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s16, s4
		s_mov_b32 s17, s5
		s_mov_b32 s18, s10
		s_mov_b32 s19, s11
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s22, s10
		s_mov_b32 s23, s11
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_lshlrev_b32_e32 v3, 4, v2
		v_and_b32_e32 v4, 15, v0
		v_mov_b32_e32 v5, 0x410
		v_mul_lo_u32 v5, v5, v4
		v_lshrrev_b32_e32 v4, 6, v0
		v_and_b32_e32 v6, 1, v4
		v_mov_b32_e32 v7, 0x4100
		v_mul_lo_u32 v7, v7, v6
		v_add3_u32 v7, v3, v5, v7
		v_lshrrev_b32_e32 v8, 7, v0
		v_mov_b32_e32 v9, 0x4100
		v_mul_lo_u32 v9, v9, v8
		v_add_u32_e32 v9, 0x8200, v9
		v_add3_u32 v3, v9, v3, v5
		s_mov_b32 s0, s13
		v_lshrrev_b32_e32 v5, 3, v1
		v_lshlrev_b32_e32 v5, 14, v5
		v_lshl_add_u32 v4, v4, 17, v5
		v_and_b32_e32 v5, 7, v1
		v_lshl_add_u32 v4, v5, 4, v4
		v_lshlrev_b32_e32 v2, 19, v2
		v_lshl_add_u32 v2, v8, 21, v2
		v_lshl_add_u32 v2, v6, 8, v2
		v_and_b32_e32 v1, 15, v1
		v_lshl_add_u32 v1, v1, 4, v2
		s_mov_b32 s12, s8
		s_mov_b32 s13, s9
		s_mov_b32 s14, s10
		s_mov_b32 s15, s11
		s_mov_b32 s24, s16
		s_mov_b32 s25, s17
		s_mov_b32 s26, s18
		s_mov_b32 s27, s19
.Lgfx950_f16_streamk_gemm.loop_head_0:
		v_readfirstlane_b32 s1, v0
		v_mov_b32_e32 v2, v7
		s_lshr_b32 s1, s1, 6
		v_mov_b32_e32 v5, v3
		s_mul_i32 s1, 0x410, s1
		s_mov_b32 m0, s1
		s_and_b32 s6, s0, 31
		s_lshr_b32 s7, s6, 3
		s_lshl_b32 s28, s7, 22
		s_and_b32 s6, s6, 7
		s_lshl_b32 s29, s6, 24
		s_add_i32 s30, s28, s29
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		v_add_u32_e32 v6, s30, v4
		s_add_i32 s30, s28, 0x80000
		v_add_u32_e32 v8, 0x80, v6
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v9, 0x80080, v6
		s_add_i32 s30, s30, s29
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		v_add_u32_e32 v10, 0x100080, v6
		s_add_i32 s30, s28, 0x100000
		v_add_u32_e32 v11, 0x180080, v6
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v12, 0x200080, v6
		s_add_i32 s30, s30, s29
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		v_add_u32_e32 v13, 0x280080, v6
		s_add_i32 s30, s28, 0x180000
		v_add_u32_e32 v14, 0x300080, v6
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v15, 0x380080, v6
		s_add_i32 s30, s30, s29
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		s_add_i32 s30, s28, 0x200000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s30, s29
		s_add_i32 s31, s28, 0x280000
		s_add_i32 s31, s31, s29
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		s_add_i32 s30, s28, 0x300000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s30, s29
		s_add_i32 s32, s28, 0x380000
		s_add_i32 s32, s32, s29
		buffer_load_dwordx4 v4, s[8:11], s31 offen lds
		s_lshr_b32 s31, s0, 5
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s31, s31, 22
		s_add_i32 s33, s31, 0x80000
		buffer_load_dwordx4 v4, s[8:11], s30 offen lds
		s_add_i32 s30, s31, 0x48000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s34, s31, 0x100000
		s_add_i32 s35, s31, 0x180000
		buffer_load_dwordx4 v4, s[8:11], s32 offen lds
		s_add_i32 s32, s31, 0x8000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s36, s31, 0x200000
		s_add_i32 s37, s31, 0x280000
		buffer_load_dwordx4 v4, s[16:19], s31 offen lds
		s_add_i32 s38, s31, 0x300000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s39, s31, 0x380000
		s_add_i32 s40, s28, 0x80
		s_add_i32 s40, s40, s29
		buffer_load_dwordx4 v4, s[16:19], s33 offen lds
		s_add_i32 s33, s28, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s33, s33, s29
		s_add_i32 s41, s28, 0x100080
		s_add_i32 s41, s41, s29
		s_add_i32 s42, s28, 0x180080
		buffer_load_dwordx4 v4, s[16:19], s34 offen lds
		s_add_i32 s34, s42, s29
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s28, 0x200080
		s_add_i32 s42, s42, s29
		s_add_i32 s43, s28, 0x280080
		buffer_load_dwordx4 v4, s[16:19], s35 offen lds
		s_add_i32 s35, s43, s29
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s28, 0x300080
		s_add_i32 s28, s28, 0x380080
		buffer_load_dwordx4 v4, s[16:19], s36 offen lds
		s_add_i32 s28, s28, s29
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s36, s31, 0x60000
		buffer_load_dwordx4 v4, s[16:19], s37 offen lds
		s_add_i32 s37, s31, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s31, 0x20000
		buffer_load_dwordx4 v4, s[16:19], s38 offen lds
		s_add_i32 s38, s31, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s31, 0x280080
		buffer_load_dwordx4 v4, s[16:19], s39 offen lds
		v_add_u32_e32 v6, s31, v4
		s_add_i32 m0, m0, 0x1040
		s_mov_b32 s39, 0
		s_mov_b32 s46, s1
		buffer_load_dwordx4 v4, s[8:11], s40 offen lds
		v_add_u32_e32 v16, 0x80, v6
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v17, 0x80080, v6
		v_add_u32_e32 v18, 0x100080, v6
		v_add_u32_e32 v19, 0x180080, v6
		v_add_u32_e32 v20, 0x200080, v6
		buffer_load_dwordx4 v4, s[8:11], s33 offen lds
		v_add_u32_e32 v21, 0x280080, v6
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v22, 0x300080, v6
		v_add_u32_e32 v23, 0x380080, v6
		s_mov_b32 s33, 0
		buffer_load_dwordx4 v4, s[8:11], s41 offen lds
		s_mov_b32 s12, s2
		s_mov_b32 s13, s3
		s_add_i32 m0, m0, 0x1040
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		buffer_load_dwordx4 v4, s[8:11], s34 offen lds
		s_add_i32 s34, s31, 0x68000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s40, s31, 0x28000
		buffer_load_dwordx4 v4, s[8:11], s42 offen lds
		s_add_i32 s41, s31, 0x64000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s31, 0x44000
		buffer_load_dwordx4 v4, s[8:11], s35 offen lds
		s_add_i32 s35, s31, 0x24000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s29, s43, s29
		buffer_load_dwordx4 v4, s[8:11], s29 offen lds
		s_add_i32 s29, s31, 0x4000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s31, 0x80
		buffer_load_dwordx4 v4, s[8:11], s28 offen lds
		s_add_i32 s28, s31, 0x40000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s47, s31, 0x100080
		buffer_load_dwordx4 v4, s[16:19], s43 offen lds
		s_lshl_b32 s6, s6, 11
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s31, 0x200080
		buffer_load_dwordx4 v4, s[16:19], s37 offen lds
		s_lshl_b32 s7, s7, 9
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s31, 0x300080
		buffer_load_dwordx4 v4, s[16:19], s47 offen lds
		s_add_i32 s47, s31, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s32, s32, s7
		buffer_load_dwordx4 v4, s[16:19], s38 offen lds
		s_add_i32 s38, s41, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s41, s42, s7
		buffer_load_dwordx4 v4, s[16:19], s43 offen lds
		s_add_i32 s35, s35, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s29, s29, s7
		buffer_load_dwordx4 v4, s[16:19], s45 offen lds
		s_add_i32 s36, s36, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s28, s28, s7
		buffer_load_dwordx4 v4, s[16:19], s37 offen lds
		s_add_i32 s37, s44, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s31, s7
		buffer_load_dwordx4 v4, s[16:19], s47 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[0:3], v7
		ds_read_b128 a[4:7], v7 offset:128
		ds_read_b128 a[8:11], v7 offset:256
		ds_read_b128 a[12:15], v7 offset:384
		ds_read_b128 a[16:19], v7 offset:512
		ds_read_b128 a[20:23], v7 offset:640
		ds_read_b128 a[24:27], v7 offset:768
		ds_read_b128 a[28:31], v7 offset:896
		ds_read_b128 a[32:35], v3
		ds_read_b128 a[36:39], v3 offset:128
		ds_read_b128 a[40:43], v3 offset:256
		ds_read_b128 a[44:47], v3 offset:384
		ds_read_b128 a[48:51], v3 offset:512
		ds_read_b128 a[52:55], v3 offset:640
		ds_read_b128 a[56:59], v3 offset:768
		ds_read_b128 a[60:63], v3 offset:896
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
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
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
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_1:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[32:35], a[0:3], v[24:27]
		ds_read_b128 a[92:95], v2 offset:64
		s_add_u32 s12, s12, 0x80
		s_addc_u32 s13, s13, 0
		v_mfma_f32_16x16x32_f16 v[28:31], a[32:35], a[4:7], v[28:31]
		s_add_u32 s24, s24, 0x80
		s_addc_u32 s25, s25, 0
		s_add_i32 s33, s33, 1
		v_mfma_f32_16x16x32_f16 v[32:35], a[32:35], a[8:11], v[32:35]
		ds_read_b128 a[96:99], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[36:39], a[32:35], a[12:15], v[36:39]
		s_and_b32 s43, s33, 1
		s_mul_i32 s43, 0x10400, s43
		s_xor_b32 s39, s39, -1
		v_mfma_f32_16x16x32_f16 v[40:43], a[32:35], a[16:19], v[40:43]
		ds_read_b128 a[100:103], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], a[20:23], v[44:47]
		s_add_i32 s39, s39, 1
		s_add_i32 s39, s39, 0x4100
		s_mul_i32 s44, s39, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], a[24:27], v[48:51]
		ds_read_b128 a[104:107], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[28:31], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[28:31], v[84:87]
		ds_read_b128 a[108:111], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], a[24:27], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], a[20:23], v[76:79]
		ds_read_b128 a[112:115], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[36:39], a[16:19], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[36:39], a[12:15], v[68:71]
		ds_read_b128 a[116:119], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[36:39], a[8:11], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[4:7], v[60:63]
		ds_read_b128 a[120:123], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[0:3], v[56:59]
		v_add_u32_e32 v2, s44, v7
		v_mfma_f32_16x16x32_f16 v[88:91], a[40:43], a[0:3], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[40:43], a[4:7], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[40:43], a[8:11], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[40:43], a[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[40:43], a[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], a[20:23], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], a[24:27], v[112:115]
		s_mov_b32 m0, s46
		ds_read_b128 a[32:35], v5 offset:64
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[28:31], v[148:151]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], a[24:27], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], a[20:23], v[140:143]
		buffer_load_dwordx4 v9, s[12:15], 0 offen lds
		ds_read_b128 a[36:39], v5 offset:192
		v_mfma_f32_16x16x32_f16 v[136:139], a[44:47], a[16:19], v[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[44:47], a[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[44:47], a[8:11], v[128:131]
		buffer_load_dwordx4 v10, s[12:15], 0 offen lds
		ds_read_b128 a[40:43], v5 offset:320
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[44:47], a[4:7], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[44:47], a[0:3], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[48:51], a[0:3], v[152:155]
		buffer_load_dwordx4 v11, s[12:15], 0 offen lds
		ds_read_b128 a[44:47], v5 offset:448
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[156:159], a[48:51], a[4:7], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[48:51], a[8:11], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[48:51], a[12:15], v[164:167]
		buffer_load_dwordx4 v12, s[12:15], 0 offen lds
		ds_read_b128 a[124:127], v5 offset:576
		ds_read_b128 a[128:131], v5 offset:704
		v_mfma_f32_16x16x32_f16 v[168:171], a[48:51], a[16:19], v[168:171]
		s_add_i32 s46, s1, s43
		v_mfma_f32_16x16x32_f16 v[172:175], a[48:51], a[20:23], v[172:175]
		ds_read_b128 a[132:135], v5 offset:832
		v_mfma_f32_16x16x32_f16 v[176:179], a[48:51], a[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[48:51], a[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[28:31], v[212:215]
		ds_read_b128 v[252:255], v5 offset:960
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[24:27], v[208:211]
		v_add_u32_e32 v5, s44, v3
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[20:23], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[16:19], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[8:11], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[52:55], a[4:7], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[52:55], a[0:3], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[56:59], a[0:3], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[56:59], a[4:7], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[56:59], a[8:11], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[56:59], a[12:15], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[232:235], a[56:59], a[16:19], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[56:59], a[20:23], v[236:239]
		buffer_load_dwordx4 v13, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[56:59], a[24:27], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[56:59], a[28:31], v[244:247]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[88:91], a[60:63], a[28:31], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[60:63], a[24:27], a[84:87]
		buffer_load_dwordx4 v14, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[80:83], a[60:63], a[20:23], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[60:63], a[16:19], a[76:79]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[72:75], a[60:63], a[12:15], a[72:75]
		v_mfma_f32_16x16x32_f16 a[68:71], a[60:63], a[8:11], a[68:71]
		buffer_load_dwordx4 v15, s[12:15], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], a[60:63], a[4:7], v[248:251]
		v_mfma_f32_16x16x32_f16 a[64:67], a[60:63], a[0:3], a[64:67]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[24:27], a[32:35], a[92:95], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[32:35], a[96:99], v[28:31]
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[32:35], a[100:103], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], a[32:35], a[104:107], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[32:35], a[108:111], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], a[112:115], v[44:47]
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], a[116:119], v[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[120:123], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], a[116:119], v[80:83]
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], a[112:115], v[76:79]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[72:75], a[36:39], a[108:111], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[36:39], a[104:107], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[36:39], a[100:103], v[64:67]
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[96:99], v[60:63]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[92:95], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[40:43], a[92:95], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[40:43], a[96:99], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[40:43], a[100:103], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[40:43], a[104:107], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[40:43], a[108:111], v[104:107]
		buffer_load_dwordx4 v20, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], a[112:115], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], a[116:119], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[120:123], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], a[116:119], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], a[112:115], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[44:47], a[108:111], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[44:47], a[104:107], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[44:47], a[100:103], v[128:131]
		s_waitcnt vmcnt(13)
		s_barrier
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		ds_read_b128 a[0:3], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[44:47], a[96:99], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[44:47], a[92:95], v[120:123]
		buffer_load_dwordx4 v22, s[24:27], 0 offen lds
		ds_read_b128 a[32:35], v5
		v_mfma_f32_16x16x32_f16 v[152:155], a[124:127], a[92:95], v[152:155]
		s_add_i32 m0, m0, 0x1040
		s_cmp_lt_i32 s33, 0x7e
		v_mfma_f32_16x16x32_f16 v[156:159], a[124:127], a[96:99], v[156:159]
		buffer_load_dwordx4 v23, s[24:27], 0 offen lds
		ds_read_b128 a[4:7], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[124:127], a[100:103], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[124:127], a[104:107], v[164:167]
		ds_read_b128 a[36:39], v5 offset:128
		v_mfma_f32_16x16x32_f16 v[168:171], a[124:127], a[108:111], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[124:127], a[112:115], v[172:175]
		ds_read_b128 a[8:11], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[124:127], a[116:119], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[124:127], a[120:123], v[180:183]
		ds_read_b128 a[40:43], v5 offset:256
		v_mfma_f32_16x16x32_f16 v[212:215], a[128:131], a[120:123], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[128:131], a[116:119], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[128:131], a[112:115], v[204:207]
		ds_read_b128 a[12:15], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[128:131], a[108:111], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[128:131], a[104:107], v[196:199]
		ds_read_b128 a[44:47], v5 offset:384
		v_mfma_f32_16x16x32_f16 v[192:195], a[128:131], a[100:103], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[128:131], a[96:99], v[188:191]
		ds_read_b128 a[16:19], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[92:95], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[92:95], v[216:219]
		ds_read_b128 a[48:51], v5 offset:512
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[96:99], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[100:103], v[224:227]
		ds_read_b128 a[20:23], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[104:107], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[108:111], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[112:115], v[236:239]
		ds_read_b128 a[52:55], v5 offset:640
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[116:119], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[132:135], a[120:123], v[244:247]
		ds_read_b128 a[24:27], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[56:59], v5 offset:768
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		ds_read_b128 a[28:31], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[68:71], v[252:255], a[100:103], a[68:71]
		ds_read_b128 a[60:63], v5 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[96:99], v[248:251]
		v_mfma_f32_16x16x32_f16 a[64:67], v[252:255], a[92:95], a[64:67]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_1
.Lgfx950_f16_streamk_gemm.loop_exit_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[32:35], a[0:3], v[24:27]
		ds_read_b128 v[8:11], v5 offset:64
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[56:59], a[36:39], a[0:3], v[56:59]
		ds_read_b128 v[12:15], v5 offset:192
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[88:91], a[40:43], a[0:3], v[88:91]
		ds_read_b128 v[16:19], v5 offset:320
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[120:123], a[44:47], a[0:3], v[120:123]
		ds_read_b128 v[20:23], v5 offset:448
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[152:155], a[48:51], a[0:3], v[152:155]
		ds_read_b128 a[92:95], v5 offset:576
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[184:187], a[52:55], a[0:3], v[184:187]
		ds_read_b128 a[96:99], v5 offset:704
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[216:219], a[56:59], a[0:3], v[216:219]
		ds_read_b128 a[100:103], v5 offset:832
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[64:67], a[60:63], a[0:3], a[64:67]
		ds_read_b128 a[0:3], v5 offset:960
		v_mfma_f32_16x16x32_f16 v[28:31], a[32:35], a[4:7], v[28:31]
		s_add_i32 s0, s0, 0x100
		v_mfma_f32_16x16x32_f16 v[60:63], a[36:39], a[4:7], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[40:43], a[4:7], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[44:47], a[4:7], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[48:51], a[4:7], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[52:55], a[4:7], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[56:59], a[4:7], v[220:223]
		v_mfma_f32_16x16x32_f16 v[248:251], a[60:63], a[4:7], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], a[60:63], a[8:11], a[68:71]
		v_mfma_f32_16x16x32_f16 v[32:35], a[32:35], a[8:11], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[36:39], a[8:11], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[40:43], a[8:11], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[44:47], a[8:11], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[48:51], a[8:11], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[52:55], a[8:11], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[56:59], a[8:11], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[56:59], a[12:15], v[228:231]
		v_mfma_f32_16x16x32_f16 v[36:39], a[32:35], a[12:15], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[36:39], a[12:15], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[40:43], a[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[44:47], a[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[48:51], a[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[52:55], a[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 a[72:75], a[60:63], a[12:15], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[60:63], a[16:19], a[76:79]
		v_mfma_f32_16x16x32_f16 v[40:43], a[32:35], a[16:19], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[36:39], a[16:19], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[40:43], a[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[44:47], a[16:19], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[48:51], a[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[52:55], a[16:19], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[56:59], a[16:19], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[56:59], a[20:23], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[32:35], a[20:23], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[36:39], a[20:23], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[40:43], a[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[44:47], a[20:23], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[48:51], a[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[52:55], a[20:23], v[204:207]
		v_mfma_f32_16x16x32_f16 a[80:83], a[60:63], a[20:23], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[60:63], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 v[48:51], a[32:35], a[24:27], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[36:39], a[24:27], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[40:43], a[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[44:47], a[24:27], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[48:51], a[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[52:55], a[24:27], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[56:59], a[24:27], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[56:59], a[28:31], v[244:247]
		v_mfma_f32_16x16x32_f16 v[52:55], a[32:35], a[28:31], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[36:39], a[28:31], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[40:43], a[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[44:47], a[28:31], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[48:51], a[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[52:55], a[28:31], v[212:215]
		v_mfma_f32_16x16x32_f16 a[88:91], a[60:63], a[28:31], a[88:91]
		ds_read_b128 a[4:7], v2 offset:64
		ds_read_b128 a[8:11], v2 offset:192
		ds_read_b128 a[12:15], v2 offset:320
		ds_read_b128 a[16:19], v2 offset:448
		ds_read_b128 a[20:23], v2 offset:576
		ds_read_b128 a[24:27], v2 offset:704
		ds_read_b128 a[28:31], v2 offset:832
		ds_read_b128 v[252:255], v2 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[4:7], v[24:27]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[8:11], v[28:31]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[12:15], v[32:35]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[16:19], v[36:39]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[20:23], v[40:43]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[24:27], v[44:47]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[28:31], v[48:51]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], v[252:255], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], v[252:255], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[28:31], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[24:27], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[20:23], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[16:19], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[12:15], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[8:11], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[4:7], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[4:7], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[8:11], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[12:15], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[16:19], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[20:23], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], v[252:255], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], v[252:255], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[28:31], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[24:27], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[20:23], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[16:19], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[12:15], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[8:11], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[4:7], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[92:95], a[4:7], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[92:95], a[8:11], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[92:95], a[12:15], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[92:95], a[16:19], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[92:95], a[20:23], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[92:95], a[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[92:95], a[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[92:95], v[252:255], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[96:99], v[252:255], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[96:99], a[28:31], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], a[24:27], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[96:99], a[20:23], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[96:99], a[16:19], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[96:99], a[12:15], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[96:99], a[8:11], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], a[4:7], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[100:103], a[4:7], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[100:103], a[8:11], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[100:103], a[12:15], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[100:103], a[16:19], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[100:103], a[20:23], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[100:103], a[24:27], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[100:103], a[28:31], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[100:103], v[252:255], v[244:247]
		v_mfma_f32_16x16x32_f16 a[88:91], a[0:3], v[252:255], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[0:3], a[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[0:3], a[24:27], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[0:3], a[20:23], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[0:3], a[16:19], a[72:75]
		v_mfma_f32_16x16x32_f16 a[68:71], a[0:3], a[12:15], a[68:71]
		v_mfma_f32_16x16x32_f16 v[248:251], a[0:3], a[8:11], v[248:251]
		v_mfma_f32_16x16x32_f16 a[64:67], a[0:3], a[4:7], a[64:67]
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s1, -4, s39
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v2, s1, v7
		ds_read_b128 v[8:11], v2 offset:1024
		ds_read_b128 v[12:15], v2 offset:1152
		ds_read_b128 v[16:19], v2 offset:1280
		ds_read_b128 v[20:23], v2 offset:1408
		ds_read_b128 a[0:3], v2 offset:1536
		ds_read_b128 a[4:7], v2 offset:1664
		ds_read_b128 a[8:11], v2 offset:1792
		ds_read_b128 a[12:15], v2 offset:1920
		v_add_u32_e32 v5, s1, v3
		ds_read_b128 a[16:19], v5 offset:1024
		ds_read_b128 a[20:23], v5 offset:1152
		ds_read_b128 a[24:27], v5 offset:1280
		ds_read_b128 a[28:31], v5 offset:1408
		ds_read_b128 a[32:35], v5 offset:1536
		ds_read_b128 a[36:39], v5 offset:1664
		ds_read_b128 a[40:43], v5 offset:1792
		ds_read_b128 a[44:47], v5 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[16:19], v[8:11], v[24:27]
		ds_read_b128 a[48:51], v5 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[56:59], a[20:23], v[8:11], v[56:59]
		ds_read_b128 a[52:55], v5 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[88:91], a[24:27], v[8:11], v[88:91]
		ds_read_b128 a[56:59], v5 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[120:123], a[28:31], v[8:11], v[120:123]
		ds_read_b128 a[60:63], v5 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], v[8:11], v[152:155]
		ds_read_b128 a[92:95], v5 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[184:187], a[36:39], v[8:11], v[184:187]
		ds_read_b128 a[96:99], v5 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[216:219], a[40:43], v[8:11], v[216:219]
		ds_read_b128 v[252:255], v5 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[64:67], a[44:47], v[8:11], a[64:67]
		ds_read_b128 a[100:103], v5 offset:1984
		v_mfma_f32_16x16x32_f16 v[28:31], a[16:19], v[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[20:23], v[12:15], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[24:27], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[28:31], v[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], v[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[36:39], v[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[40:43], v[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[248:251], a[44:47], v[12:15], v[248:251]
		v_mfma_f32_16x16x32_f16 a[68:71], a[44:47], v[16:19], a[68:71]
		v_mfma_f32_16x16x32_f16 v[32:35], a[16:19], v[16:19], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[20:23], v[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[24:27], v[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[28:31], v[16:19], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], v[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[36:39], v[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[40:43], v[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[40:43], v[20:23], v[228:231]
		v_mfma_f32_16x16x32_f16 v[36:39], a[16:19], v[20:23], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[20:23], v[20:23], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[24:27], v[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[28:31], v[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], v[20:23], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[36:39], v[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 a[72:75], a[44:47], v[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[44:47], a[0:3], a[76:79]
		v_mfma_f32_16x16x32_f16 v[40:43], a[16:19], a[0:3], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[20:23], a[0:3], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[24:27], a[0:3], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[28:31], a[0:3], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[0:3], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[36:39], a[0:3], v[200:203]
		v_mfma_f32_16x16x32_f16 v[232:235], a[40:43], a[0:3], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[40:43], a[4:7], v[236:239]
		v_mfma_f32_16x16x32_f16 v[44:47], a[16:19], a[4:7], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[20:23], a[4:7], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[24:27], a[4:7], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[28:31], a[4:7], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[4:7], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[36:39], a[4:7], v[204:207]
		v_mfma_f32_16x16x32_f16 a[80:83], a[44:47], a[4:7], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[44:47], a[8:11], a[84:87]
		v_mfma_f32_16x16x32_f16 v[48:51], a[16:19], a[8:11], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[20:23], a[8:11], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[24:27], a[8:11], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[28:31], a[8:11], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[36:39], a[8:11], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[40:43], a[8:11], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[40:43], a[12:15], v[244:247]
		v_mfma_f32_16x16x32_f16 v[52:55], a[16:19], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[20:23], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[24:27], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[28:31], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[36:39], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 a[88:91], a[44:47], a[12:15], a[88:91]
		ds_read_b128 a[0:3], v2 offset:1088
		ds_read_b128 a[4:7], v2 offset:1216
		ds_read_b128 a[8:11], v2 offset:1344
		ds_read_b128 a[12:15], v2 offset:1472
		ds_read_b128 a[16:19], v2 offset:1600
		ds_read_b128 a[20:23], v2 offset:1728
		ds_read_b128 v[8:11], v2 offset:1856
		ds_read_b128 v[12:15], v2 offset:1984
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[48:51], a[0:3], v[24:27]
		s_add_i32 s1, s42, s6
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[28:31], a[48:51], a[4:7], v[28:31]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[32:35], a[48:51], a[8:11], v[32:35]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[36:39], a[48:51], a[12:15], v[36:39]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[40:43], a[48:51], a[16:19], v[40:43]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[44:47], a[48:51], a[20:23], v[44:47]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[48:51], a[48:51], v[8:11], v[48:51]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[52:55], a[48:51], v[12:15], v[52:55]
		s_add_i32 s33, s37, s6
		s_nop 0
		v_cvt_pk_f16_f32 v16, v24, v28
		v_cvt_pk_f16_f32 v20, v25, v29
		v_cvt_pk_f16_f32 v17, v32, v36
		v_cvt_pk_f16_f32 v21, v33, v37
		v_cvt_pk_f16_f32 v18, v40, v44
		v_cvt_pk_f16_f32 v22, v41, v45
		v_cvt_pk_f16_f32 v19, v48, v52
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		v_cvt_pk_f16_f32 v23, v49, v53
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s33 offen sc0 nt
		s_add_i32 s1, s28, s6
		v_cvt_pk_f16_f32 v16, v26, v30
		v_cvt_pk_f16_f32 v17, v34, v38
		v_cvt_pk_f16_f32 v18, v42, v46
		v_cvt_pk_f16_f32 v19, v50, v54
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_nop 0
		v_cvt_pk_f16_f32 v16, v27, v31
		v_cvt_pk_f16_f32 v17, v35, v39
		v_cvt_pk_f16_f32 v18, v43, v47
		v_cvt_pk_f16_f32 v19, v51, v55
		v_mfma_f32_16x16x32_f16 v[84:87], a[52:55], v[12:15], v[84:87]
		s_add_i32 s1, s36, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[80:83], a[52:55], v[8:11], v[80:83]
		s_add_i32 s1, s29, s6
		v_mfma_f32_16x16x32_f16 v[76:79], a[52:55], a[20:23], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[52:55], a[16:19], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[52:55], a[12:15], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[52:55], a[8:11], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[52:55], a[4:7], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[52:55], a[0:3], v[56:59]
		s_nop 0
		v_cvt_pk_f16_f32 v19, v80, v84
		v_cvt_pk_f16_f32 v23, v81, v85
		s_add_i32 s28, s35, s6
		v_cvt_pk_f16_f32 v18, v72, v76
		v_cvt_pk_f16_f32 v22, v73, v77
		v_cvt_pk_f16_f32 v17, v64, v68
		v_cvt_pk_f16_f32 v21, v65, v69
		v_cvt_pk_f16_f32 v16, v56, v60
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		v_cvt_pk_f16_f32 v20, v57, v61
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s41, s6
		v_cvt_pk_f16_f32 v16, v58, v62
		v_cvt_pk_f16_f32 v17, v66, v70
		v_cvt_pk_f16_f32 v18, v74, v78
		v_cvt_pk_f16_f32 v19, v82, v86
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_nop 0
		v_cvt_pk_f16_f32 v16, v59, v63
		v_cvt_pk_f16_f32 v17, v67, v71
		v_cvt_pk_f16_f32 v18, v75, v79
		v_cvt_pk_f16_f32 v19, v83, v87
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[0:3], v[88:91]
		s_add_i32 s1, s38, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[4:7], v[92:95]
		s_add_i32 s1, s32, s6
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[8:11], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], v[8:11], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], v[12:15], v[116:119]
		s_nop 0
		v_cvt_pk_f16_f32 v16, v88, v92
		v_cvt_pk_f16_f32 v20, v89, v93
		s_add_i32 s28, s40, s7
		s_add_i32 s28, s28, s6
		v_cvt_pk_f16_f32 v17, v96, v100
		v_cvt_pk_f16_f32 v21, v97, v101
		v_cvt_pk_f16_f32 v18, v104, v108
		v_cvt_pk_f16_f32 v22, v105, v109
		v_cvt_pk_f16_f32 v19, v112, v116
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s30, s7
		v_cvt_pk_f16_f32 v23, v113, v117
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s6
		v_cvt_pk_f16_f32 v16, v90, v94
		v_cvt_pk_f16_f32 v17, v98, v102
		v_cvt_pk_f16_f32 v18, v106, v110
		v_cvt_pk_f16_f32 v19, v114, v118
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s34, s7
		v_cvt_pk_f16_f32 v16, v91, v95
		v_cvt_pk_f16_f32 v17, v99, v103
		v_cvt_pk_f16_f32 v18, v107, v111
		v_cvt_pk_f16_f32 v19, v115, v119
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], v[12:15], v[148:151]
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], v[8:11], v[144:147]
		s_add_i32 s1, s31, 0xc000
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[20:23], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[16:19], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[8:11], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[4:7], v[124:127]
		v_cvt_pk_f16_f32 v19, v144, v148
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[0:3], v[120:123]
		v_cvt_pk_f16_f32 v23, v145, v149
		s_add_i32 s28, s31, 0x2c000
		s_add_i32 s28, s28, s7
		v_cvt_pk_f16_f32 v18, v136, v140
		v_cvt_pk_f16_f32 v22, v137, v141
		v_cvt_pk_f16_f32 v17, v128, v132
		v_cvt_pk_f16_f32 v21, v129, v133
		s_add_i32 s28, s28, s6
		v_cvt_pk_f16_f32 v16, v120, v124
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x4c000
		v_cvt_pk_f16_f32 v20, v121, v125
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s7
		v_cvt_pk_f16_f32 v16, v122, v126
		v_cvt_pk_f16_f32 v17, v130, v134
		v_cvt_pk_f16_f32 v18, v138, v142
		v_cvt_pk_f16_f32 v19, v146, v150
		v_cvt_pk_f16_f32 v20, v123, v127
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x6c000
		v_cvt_pk_f16_f32 v21, v131, v135
		v_cvt_pk_f16_f32 v22, v139, v143
		v_cvt_pk_f16_f32 v23, v147, v151
		v_mfma_f32_16x16x32_f16 v[152:155], a[92:95], a[0:3], v[152:155]
		s_add_i32 s1, s1, s7
		v_mfma_f32_16x16x32_f16 v[156:159], a[92:95], a[4:7], v[156:159]
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[160:163], a[92:95], a[8:11], v[160:163]
		s_add_i32 s1, s31, 0x10000
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		v_mfma_f32_16x16x32_f16 v[164:167], a[92:95], a[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[92:95], a[16:19], v[168:171]
		v_cvt_pk_f16_f32 v16, v152, v156
		v_mfma_f32_16x16x32_f16 v[172:175], a[92:95], a[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[92:95], v[8:11], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[92:95], v[12:15], v[180:183]
		v_cvt_pk_f16_f32 v20, v153, v157
		s_add_i32 s28, s31, 0x30000
		s_add_i32 s28, s28, s7
		v_cvt_pk_f16_f32 v17, v160, v164
		v_cvt_pk_f16_f32 v21, v161, v165
		s_add_i32 s28, s28, s6
		v_cvt_pk_f16_f32 v18, v168, v172
		v_cvt_pk_f16_f32 v22, v169, v173
		v_cvt_pk_f16_f32 v19, v176, v180
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x50000
		v_cvt_pk_f16_f32 v23, v177, v181
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s7
		v_cvt_pk_f16_f32 v16, v154, v158
		v_cvt_pk_f16_f32 v17, v162, v166
		v_cvt_pk_f16_f32 v18, v170, v174
		v_cvt_pk_f16_f32 v19, v178, v182
		v_cvt_pk_f16_f32 v20, v155, v159
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x70000
		v_cvt_pk_f16_f32 v21, v163, v167
		v_cvt_pk_f16_f32 v22, v171, v175
		v_cvt_pk_f16_f32 v23, v179, v183
		v_mfma_f32_16x16x32_f16 v[212:215], a[96:99], v[12:15], v[212:215]
		s_add_i32 s1, s1, s7
		v_mfma_f32_16x16x32_f16 v[208:211], a[96:99], v[8:11], v[208:211]
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], a[20:23], v[204:207]
		s_add_i32 s1, s31, 0x14000
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		v_mfma_f32_16x16x32_f16 v[200:203], a[96:99], a[16:19], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[96:99], a[12:15], v[196:199]
		v_cvt_pk_f16_f32 v19, v208, v212
		v_mfma_f32_16x16x32_f16 v[192:195], a[96:99], a[8:11], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[96:99], a[4:7], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], a[0:3], v[184:187]
		v_cvt_pk_f16_f32 v23, v209, v213
		s_add_i32 s28, s31, 0x34000
		s_add_i32 s28, s28, s7
		v_cvt_pk_f16_f32 v18, v200, v204
		v_cvt_pk_f16_f32 v22, v201, v205
		s_add_i32 s28, s28, s6
		v_cvt_pk_f16_f32 v17, v192, v196
		v_cvt_pk_f16_f32 v21, v193, v197
		v_cvt_pk_f16_f32 v16, v184, v188
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x54000
		v_cvt_pk_f16_f32 v20, v185, v189
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s7
		v_cvt_pk_f16_f32 v16, v186, v190
		v_cvt_pk_f16_f32 v17, v194, v198
		v_cvt_pk_f16_f32 v18, v202, v206
		v_cvt_pk_f16_f32 v19, v210, v214
		v_cvt_pk_f16_f32 v20, v187, v191
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x74000
		v_cvt_pk_f16_f32 v21, v195, v199
		v_cvt_pk_f16_f32 v22, v203, v207
		v_cvt_pk_f16_f32 v23, v211, v215
		v_mfma_f32_16x16x32_f16 v[216:219], v[252:255], a[0:3], v[216:219]
		s_add_i32 s1, s1, s7
		v_mfma_f32_16x16x32_f16 v[220:223], v[252:255], a[4:7], v[220:223]
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[224:227], v[252:255], a[8:11], v[224:227]
		s_add_i32 s1, s31, 0x18000
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		v_mfma_f32_16x16x32_f16 v[228:231], v[252:255], a[12:15], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[252:255], a[16:19], v[232:235]
		v_cvt_pk_f16_f32 v16, v216, v220
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], a[20:23], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], v[8:11], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], v[12:15], v[244:247]
		v_cvt_pk_f16_f32 v20, v217, v221
		s_add_i32 s28, s31, 0x38000
		s_add_i32 s28, s28, s7
		v_cvt_pk_f16_f32 v17, v224, v228
		v_cvt_pk_f16_f32 v21, v225, v229
		s_add_i32 s28, s28, s6
		v_cvt_pk_f16_f32 v18, v232, v236
		v_cvt_pk_f16_f32 v22, v233, v237
		v_cvt_pk_f16_f32 v19, v240, v244
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x58000
		v_cvt_pk_f16_f32 v23, v241, v245
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s7
		v_cvt_pk_f16_f32 v16, v218, v222
		v_cvt_pk_f16_f32 v17, v226, v230
		v_cvt_pk_f16_f32 v18, v234, v238
		v_cvt_pk_f16_f32 v19, v242, v246
		v_cvt_pk_f16_f32 v20, v219, v223
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[16:19], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x78000
		v_cvt_pk_f16_f32 v21, v227, v231
		v_cvt_pk_f16_f32 v22, v235, v239
		v_cvt_pk_f16_f32 v23, v243, v247
		v_mfma_f32_16x16x32_f16 a[88:91], a[100:103], v[12:15], a[88:91]
		s_add_i32 s1, s1, s7
		v_mfma_f32_16x16x32_f16 a[84:87], a[100:103], v[8:11], a[84:87]
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[20:23], v1, s[20:23], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 a[80:83], a[100:103], a[20:23], a[80:83]
		s_add_i32 s1, s31, 0x1c000
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		v_mfma_f32_16x16x32_f16 a[76:79], a[100:103], a[16:19], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[100:103], a[12:15], a[72:75]
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v5, a88
		v_cvt_pk_f16_f32 v11, v2, v5
		v_mfma_f32_16x16x32_f16 a[68:71], a[100:103], a[8:11], a[68:71]
		v_mfma_f32_16x16x32_f16 v[248:251], a[100:103], a[4:7], v[248:251]
		v_mfma_f32_16x16x32_f16 a[64:67], a[100:103], a[0:3], a[64:67]
		v_accvgpr_read_b32 v2, a85
		v_accvgpr_read_b32 v5, a89
		v_cvt_pk_f16_f32 v15, v2, v5
		s_add_i32 s28, s31, 0x3c000
		s_add_i32 s28, s28, s7
		v_accvgpr_read_b32 v2, a76
		v_accvgpr_read_b32 v5, a80
		v_cvt_pk_f16_f32 v10, v2, v5
		v_accvgpr_read_b32 v2, a77
		v_accvgpr_read_b32 v5, a81
		v_cvt_pk_f16_f32 v14, v2, v5
		s_add_i32 s28, s28, s6
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v5, a72
		v_cvt_pk_f16_f32 v9, v2, v5
		v_accvgpr_read_b32 v2, a69
		v_accvgpr_read_b32 v5, a73
		v_cvt_pk_f16_f32 v13, v2, v5
		v_accvgpr_read_b32 v2, a64
		v_cvt_pk_f16_f32 v8, v2, v248
		buffer_store_dwordx4 v[8:11], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x5c000
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v12, v2, v249
		buffer_store_dwordx4 v[12:15], v1, s[20:23], s28 offen sc0 nt
		s_add_i32 s1, s1, s7
		v_accvgpr_read_b32 v2, a66
		v_cvt_pk_f16_f32 v8, v2, v250
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v5, a74
		v_cvt_pk_f16_f32 v9, v2, v5
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v5, a82
		v_cvt_pk_f16_f32 v10, v2, v5
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v5, a90
		v_cvt_pk_f16_f32 v11, v2, v5
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v12, v2, v251
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[8:11], v1, s[20:23], s1 offen sc0 nt
		s_add_i32 s1, s31, 0x7c000
		v_accvgpr_read_b32 v2, a71
		v_accvgpr_read_b32 v5, a75
		v_cvt_pk_f16_f32 v13, v2, v5
		v_accvgpr_read_b32 v2, a79
		v_accvgpr_read_b32 v5, a83
		v_cvt_pk_f16_f32 v14, v2, v5
		v_accvgpr_read_b32 v2, a87
		v_accvgpr_read_b32 v5, a91
		v_cvt_pk_f16_f32 v15, v2, v5
		s_add_i32 s1, s1, s7
		s_add_i32 s1, s1, s6
		buffer_store_dwordx4 v[12:15], v1, s[20:23], s1 offen sc0 nt
		s_barrier
		s_cmp_lt_i32 s0, 0x400
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_0
.Lgfx950_f16_streamk_gemm.loop_exit_0:
		s_endpgm
	.size	gfx950_f16_streamk_gemm, .-gfx950_f16_streamk_gemm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel gfx950_f16_streamk_gemm
		.amdhsa_group_segment_fixed_size 0
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
		.amdhsa_next_free_vgpr 392
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
	.set .Lgfx950_f16_streamk_gemm.num_vgpr, 256
	.set .Lgfx950_f16_streamk_gemm.num_agpr, 136
	.set .Lgfx950_f16_streamk_gemm.numbered_sgpr, 48
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           gfx950_f16_streamk_gemm
    .private_segment_fixed_size: 0
    .sgpr_count:     48
    .sgpr_spill_count: 0
    .symbol:         gfx950_f16_streamk_gemm.kd
    .uses_dynamic_stack: false
    .vgpr_count:     392
    .agpr_count:     136
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 75
    wave.regalloc.agpr.dwords: 296
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
