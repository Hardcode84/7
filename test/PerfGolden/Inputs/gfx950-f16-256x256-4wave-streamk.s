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
		s_mul_i32 s1, 0x410, s0
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_lshlrev_b32_e32 v3, 4, v2
		v_and_b32_e32 v4, 15, v0
		v_mov_b32_e32 v5, 0x410
		v_mul_lo_u32 v5, v5, v4
		v_lshrrev_b32_e32 v4, 6, v0
		v_and_b32_e32 v4, 1, v4
		v_mov_b32_e32 v6, 0x4100
		v_mul_lo_u32 v6, v6, v4
		v_lshrrev_b32_e32 v0, 7, v0
		v_mov_b32_e32 v7, 0x4100
		v_mul_lo_u32 v7, v7, v0
		v_add_u32_e32 v7, 0x8200, v7
		s_mov_b32 m0, s1
		v_lshrrev_b32_e32 v8, 3, v1
		v_lshlrev_b32_e32 v8, 14, v8
		v_lshl_add_u32 v8, s0, 17, v8
		v_and_b32_e32 v9, 7, v1
		v_lshl_add_u32 v8, v9, 4, v8
		s_and_b32 s0, s13, 31
		s_lshr_b32 s6, s0, 3
		s_lshl_b32 s7, s6, 22
		s_and_b32 s0, s0, 7
		s_lshl_b32 s12, s0, 24
		s_add_i32 s14, s7, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		v_add3_u32 v6, v3, v5, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s15, s7, 0x80000
		s_add_i32 s15, s15, s12
		v_add3_u32 v3, v7, v3, v5
		buffer_load_dwordx4 v8, s[16:19], s15 offen lds
		v_and_b32_e32 v1, 15, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s15, s7, 0x100000
		s_add_i32 s15, s15, s12
		v_lshlrev_b32_e32 v2, 19, v2
		buffer_load_dwordx4 v8, s[16:19], s15 offen lds
		v_lshl_add_u32 v0, v0, 21, v2
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s15, s7, 0x180000
		s_add_i32 s15, s15, s12
		v_lshl_add_u32 v0, v4, 8, v0
		buffer_load_dwordx4 v8, s[16:19], s15 offen lds
		v_lshl_add_u32 v0, v1, 4, v0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s15, s7, 0x200000
		s_add_i32 s15, s15, s12
		buffer_load_dwordx4 v8, s[16:19], s15 offen lds
		s_mov_b32 s15, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s24, s7, 0x280000
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v8, s[16:19], s24 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s24, s7, 0x300000
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v8, s[16:19], s24 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s24, s7, 0x380000
		s_add_i32 s24, s24, s12
		buffer_load_dwordx4 v8, s[16:19], s24 offen lds
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
		s_add_i32 m0, m0, 0x1040
		s_lshr_b32 s24, s13, 5
		s_lshl_b32 s24, s24, 22
		buffer_load_dwordx4 v8, s[20:23], s24 offen lds
		v_add_u32_e32 v1, s24, v8
		v_accvgpr_write_b32 a4, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s24, 0x80000
		buffer_load_dwordx4 v8, s[20:23], s25 offen lds
		s_mov_b32 s25, s13
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s13, s24, 0x100000
		buffer_load_dwordx4 v8, s[20:23], s13 offen lds
		s_mov_b32 s13, s15
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s24, 0x180000
		buffer_load_dwordx4 v8, s[20:23], s26 offen lds
		v_add_u32_e32 v1, s14, v8
		v_accvgpr_write_b32 a5, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s24, 0x200000
		buffer_load_dwordx4 v8, s[20:23], s14 offen lds
		v_mov_b32_e32 v1, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s24, 0x280000
		buffer_load_dwordx4 v8, s[20:23], s14 offen lds
		v_mov_b32_e32 v2, v3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s24, 0x300000
		buffer_load_dwordx4 v8, s[20:23], s14 offen lds
		v_accvgpr_write_b32 a8, 0
		v_accvgpr_write_b32 a9, 0
		v_accvgpr_write_b32 a10, 0
		v_accvgpr_write_b32 a11, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s24, 0x380000
		buffer_load_dwordx4 v8, s[20:23], s14 offen lds
		s_add_i32 s14, s7, 0x80
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x100080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x200080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s14, s7, 0x300080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s14, s14, s12
		buffer_load_dwordx4 v8, s[16:19], s14 offen lds
		s_add_i32 s7, s7, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s7, s12
		buffer_load_dwordx4 v8, s[16:19], s7 offen lds
		v_accvgpr_write_b32 a12, 0
		v_accvgpr_write_b32 a13, 0
		v_accvgpr_write_b32 a14, 0
		v_accvgpr_write_b32 a15, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s24, 0x80
		buffer_load_dwordx4 v8, s[20:23], s7 offen lds
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s24, 0x80080
		buffer_load_dwordx4 v8, s[20:23], s7 offen lds
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s24, 0x100080
		buffer_load_dwordx4 v8, s[20:23], s7 offen lds
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s24, 0x180080
		buffer_load_dwordx4 v8, s[20:23], s7 offen lds
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s24, 0x200080
		buffer_load_dwordx4 v8, s[20:23], s7 offen lds
		s_mov_b32 s7, s1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s12, s24, 0x280080
		buffer_load_dwordx4 v8, s[20:23], s12 offen lds
		s_mov_b32 s28, s20
		s_mov_b32 s29, s21
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s12, s24, 0x300080
		buffer_load_dwordx4 v8, s[20:23], s12 offen lds
		s_mov_b32 s32, s16
		s_mov_b32 s33, s17
		s_mov_b32 s34, s18
		s_mov_b32 s35, s19
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s12, s24, 0x380080
		buffer_load_dwordx4 v8, s[20:23], s12 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[32:35], v6
		ds_read_b128 a[36:39], v6 offset:128
		ds_read_b128 a[40:43], v6 offset:256
		ds_read_b128 a[44:47], v6 offset:384
		ds_read_b128 a[48:51], v6 offset:512
		ds_read_b128 a[52:55], v6 offset:640
		ds_read_b128 a[56:59], v6 offset:768
		ds_read_b128 a[60:63], v6 offset:896
		ds_read_b128 a[64:67], v3
		ds_read_b128 a[68:71], v3 offset:128
		ds_read_b128 a[72:75], v3 offset:256
		ds_read_b128 a[76:79], v3 offset:384
		ds_read_b128 a[80:83], v3 offset:512
		ds_read_b128 a[84:87], v3 offset:640
		ds_read_b128 a[88:91], v3 offset:768
		ds_read_b128 a[92:95], v3 offset:896
.Lgfx950_f16_streamk_gemm.loop_head_0:
		s_mov_b32 s12, s1
		s_and_b32 s14, s25, 31
		s_lshr_b32 s26, s14, 3
		s_lshl_b32 s27, s26, 22
		s_and_b32 s14, s14, 7
		s_lshl_b32 s36, s14, 24
		s_add_i32 s37, s27, s36
		v_add_u32_e32 v4, s37, v8
		v_add_u32_e32 v5, 0x80, v4
		v_add_u32_e32 v7, 0x80080, v4
		v_add_u32_e32 v9, 0x100080, v4
		v_add_u32_e32 v10, 0x180080, v4
		v_add_u32_e32 v11, 0x200080, v4
		v_add_u32_e32 v12, 0x280080, v4
		v_add_u32_e32 v13, 0x300080, v4
		v_add_u32_e32 v14, 0x380080, v4
		s_lshr_b32 s38, s25, 5
		s_lshl_b32 s38, s38, 22
		v_add_u32_e32 v4, s38, v8
		v_add_u32_e32 v15, 0x80, v4
		v_add_u32_e32 v16, 0x80080, v4
		v_add_u32_e32 v17, 0x100080, v4
		v_add_u32_e32 v18, 0x180080, v4
		v_add_u32_e32 v19, 0x200080, v4
		v_add_u32_e32 v20, 0x280080, v4
		v_add_u32_e32 v21, 0x300080, v4
		v_add_u32_e32 v22, 0x380080, v4
		s_mov_b32 s39, 0
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
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
		v_mov_b64_e32 v[248:249], 0
		v_mov_b64_e32 v[250:251], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_1:
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[32:35], v[24:27]
		ds_read_b128 a[124:127], v1 offset:64
		s_add_u32 s32, s32, 0x80
		s_addc_u32 s33, s33, 0
		v_mfma_f32_16x16x32_f16 v[28:31], a[64:67], a[36:39], v[28:31]
		s_add_u32 s28, s28, 0x80
		s_addc_u32 s29, s29, 0
		s_add_i32 s39, s39, 1
		v_mfma_f32_16x16x32_f16 v[32:35], a[64:67], a[40:43], v[32:35]
		ds_read_b128 a[128:131], v1 offset:192
		v_mfma_f32_16x16x32_f16 v[36:39], a[64:67], a[44:47], v[36:39]
		s_and_b32 s40, s39, 1
		s_mul_i32 s40, 0x10400, s40
		s_xor_b32 s13, s13, -1
		v_mfma_f32_16x16x32_f16 v[40:43], a[64:67], a[48:51], v[40:43]
		ds_read_b128 a[132:135], v1 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[64:67], a[52:55], v[44:47]
		s_add_i32 s13, s13, 1
		s_add_i32 s13, s13, 0x4100
		s_mul_i32 s41, s13, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[64:67], a[56:59], v[48:51]
		ds_read_b128 a[136:139], v1 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[64:67], a[60:63], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[68:71], a[60:63], v[84:87]
		ds_read_b128 a[140:143], v1 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[68:71], a[56:59], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[68:71], a[52:55], v[76:79]
		ds_read_b128 a[144:147], v1 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[68:71], a[48:51], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[68:71], a[44:47], v[68:71]
		ds_read_b128 a[148:151], v1 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[68:71], a[40:43], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[68:71], a[36:39], v[60:63]
		ds_read_b128 a[152:155], v1 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[32:35], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[32:35], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[72:75], a[36:39], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[72:75], a[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[72:75], a[44:47], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[72:75], a[48:51], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[72:75], a[52:55], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[72:75], a[56:59], v[112:115]
		s_mov_b32 m0, s12
		ds_read_b128 a[64:67], v2 offset:64
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[72:75], a[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[76:79], a[60:63], v[148:151]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[144:147], a[76:79], a[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[76:79], a[52:55], v[140:143]
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		ds_read_b128 a[68:71], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[136:139], a[76:79], a[48:51], v[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[76:79], a[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[76:79], a[40:43], v[128:131]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		ds_read_b128 a[72:75], v2 offset:320
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[76:79], a[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[80:83], a[32:35], v[152:155]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		ds_read_b128 a[76:79], v2 offset:448
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[156:159], a[80:83], a[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[80:83], a[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[80:83], a[44:47], v[164:167]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		ds_read_b128 a[156:159], v2 offset:576
		ds_read_b128 a[160:163], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[168:171], a[80:83], a[48:51], v[168:171]
		s_add_i32 s12, s1, s40
		v_mfma_f32_16x16x32_f16 v[172:175], a[80:83], a[52:55], v[172:175]
		ds_read_b128 a[164:167], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[176:179], a[80:83], a[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[80:83], a[60:63], v[180:183]
		v_add_u32_e32 v1, s41, v6
		v_mfma_f32_16x16x32_f16 v[212:215], a[84:87], a[60:63], v[212:215]
		ds_read_b128 v[252:255], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[208:211], a[84:87], a[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[84:87], a[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[84:87], a[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[84:87], a[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[84:87], a[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[84:87], a[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[84:87], a[32:35], v[184:187]
		v_add_u32_e32 v2, s41, v3
		v_mfma_f32_16x16x32_f16 v[216:219], a[88:91], a[32:35], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[88:91], a[36:39], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[88:91], a[40:43], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[88:91], a[44:47], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[92:95], a[44:47], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[232:235], a[88:91], a[48:51], v[232:235]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[88:91], a[52:55], v[236:239]
		v_mfma_f32_16x16x32_f16 a[112:115], a[92:95], a[52:55], a[112:115]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[240:243], a[88:91], a[56:59], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[88:91], a[60:63], v[244:247]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[120:123], a[92:95], a[60:63], a[120:123]
		v_mfma_f32_16x16x32_f16 a[116:119], a[92:95], a[56:59], a[116:119]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[108:111], a[92:95], a[48:51], a[108:111]
		v_mfma_f32_16x16x32_f16 a[104:107], a[92:95], a[40:43], a[104:107]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[100:103], a[92:95], a[36:39], a[100:103]
		v_mfma_f32_16x16x32_f16 a[96:99], a[92:95], a[32:35], a[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[124:127], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[64:67], a[128:131], v[28:31]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[64:67], a[132:135], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], a[64:67], a[136:139], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[64:67], a[140:143], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[64:67], a[144:147], v[44:47]
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[64:67], a[148:151], v[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[52:55], a[64:67], a[152:155], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[68:71], a[152:155], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[68:71], a[148:151], v[80:83]
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[76:79], a[68:71], a[144:147], v[76:79]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[72:75], a[68:71], a[140:143], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[68:71], a[136:139], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[68:71], a[132:135], v[64:67]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[60:63], a[68:71], a[128:131], v[60:63]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[124:127], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[124:127], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[72:75], a[128:131], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[72:75], a[132:135], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[72:75], a[136:139], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[72:75], a[140:143], v[104:107]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[108:111], a[72:75], a[144:147], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[72:75], a[148:151], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[72:75], a[152:155], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[76:79], a[152:155], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[76:79], a[148:151], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[76:79], a[144:147], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[76:79], a[140:143], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[76:79], a[136:139], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[76:79], a[132:135], v[128:131]
		s_waitcnt vmcnt(13)
		s_barrier
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		ds_read_b128 a[32:35], v1
		v_mfma_f32_16x16x32_f16 v[124:127], a[76:79], a[128:131], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[124:127], v[120:123]
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		ds_read_b128 a[64:67], v2
		v_mfma_f32_16x16x32_f16 v[152:155], a[156:159], a[124:127], v[152:155]
		s_add_i32 m0, m0, 0x1040
		s_cmp_lt_i32 s39, 0x7e
		v_mfma_f32_16x16x32_f16 v[156:159], a[156:159], a[128:131], v[156:159]
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		ds_read_b128 a[36:39], v1 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[156:159], a[132:135], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[156:159], a[136:139], v[164:167]
		ds_read_b128 a[68:71], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[168:171], a[156:159], a[140:143], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[156:159], a[144:147], v[172:175]
		ds_read_b128 a[40:43], v1 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[156:159], a[148:151], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[156:159], a[152:155], v[180:183]
		ds_read_b128 a[72:75], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[212:215], a[160:163], a[152:155], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[160:163], a[148:151], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[160:163], a[144:147], v[204:207]
		ds_read_b128 a[44:47], v1 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[160:163], a[140:143], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[160:163], a[136:139], v[196:199]
		ds_read_b128 a[76:79], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[192:195], a[160:163], a[132:135], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[160:163], a[128:131], v[188:191]
		ds_read_b128 a[48:51], v1 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[160:163], a[124:127], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[164:167], a[124:127], v[216:219]
		ds_read_b128 a[80:83], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[220:223], a[164:167], a[128:131], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[164:167], a[132:135], v[224:227]
		ds_read_b128 a[52:55], v1 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[164:167], a[136:139], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[164:167], a[140:143], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[164:167], a[144:147], v[236:239]
		ds_read_b128 a[84:87], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[240:243], a[164:167], a[148:151], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[164:167], a[152:155], v[244:247]
		ds_read_b128 a[56:59], v1 offset:768
		v_mfma_f32_16x16x32_f16 a[120:123], v[252:255], a[152:155], a[120:123]
		v_mfma_f32_16x16x32_f16 a[116:119], v[252:255], a[148:151], a[116:119]
		ds_read_b128 a[88:91], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[112:115], v[252:255], a[144:147], a[112:115]
		v_mfma_f32_16x16x32_f16 a[108:111], v[252:255], a[140:143], a[108:111]
		ds_read_b128 a[60:63], v1 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[136:139], v[248:251]
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[132:135], a[104:107]
		ds_read_b128 a[92:95], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[128:131], a[100:103]
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_1
.Lgfx950_f16_streamk_gemm.loop_exit_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[32:35], v[24:27]
		ds_read_b128 a[124:127], v1 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[64:67], a[36:39], v[28:31]
		s_xor_b32 s39, s13, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s39, s39, 0x4100
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[64:67], a[40:43], v[32:35]
		ds_read_b128 a[128:131], v1 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], a[64:67], a[44:47], v[36:39]
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s13, s39, 0x4100
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], a[64:67], a[48:51], v[40:43]
		ds_read_b128 a[132:135], v1 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[64:67], a[52:55], v[44:47]
		s_add_i32 s25, s25, 0x100
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[64:67], a[56:59], v[48:51]
		ds_read_b128 a[136:139], v1 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[64:67], a[60:63], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[68:71], a[60:63], v[84:87]
		ds_read_b128 a[64:67], v1 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[68:71], a[56:59], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[68:71], a[52:55], v[76:79]
		ds_read_b128 a[140:143], v1 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[68:71], a[48:51], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[68:71], a[44:47], v[68:71]
		ds_read_b128 a[144:147], v1 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[68:71], a[40:43], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[68:71], a[36:39], v[60:63]
		ds_read_b128 a[148:151], v1 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[32:35], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[32:35], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[72:75], a[36:39], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[72:75], a[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[72:75], a[44:47], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[72:75], a[48:51], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[72:75], a[52:55], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[72:75], a[56:59], v[112:115]
		s_mov_b32 m0, s12
		s_add_i32 s12, s27, 0x280000
		buffer_load_dwordx4 v8, s[16:19], s37 offen lds
		s_add_i32 s37, s27, 0x80000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s37, s36
		s_add_i32 s39, s27, 0x100000
		buffer_load_dwordx4 v8, s[16:19], s37 offen lds
		s_add_i32 s37, s39, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s39, s27, 0x180000
		s_add_i32 s39, s39, s36
		s_add_i32 s40, s27, 0x200000
		buffer_load_dwordx4 v8, s[16:19], s37 offen lds
		s_add_i32 s37, s40, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s12, s12, s36
		s_add_i32 s40, s27, 0x300000
		s_add_i32 s40, s40, s36
		buffer_load_dwordx4 v8, s[16:19], s39 offen lds
		s_add_i32 s39, s27, 0x380000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s39, s39, s36
		s_add_i32 s41, s38, 0x24000
		s_add_i32 s42, s38, 0x2000000
		buffer_load_dwordx4 v8, s[16:19], s37 offen lds
		ds_read_b128 v[12:15], v2 offset:64
		v_mfma_f32_16x16x32_f16 v[116:119], a[72:75], a[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[76:79], a[60:63], v[148:151]
		ds_read_b128 v[16:19], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[144:147], a[76:79], a[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[76:79], a[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[76:79], a[48:51], v[136:139]
		ds_read_b128 v[20:23], v2 offset:320
		v_mfma_f32_16x16x32_f16 v[132:135], a[76:79], a[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[76:79], a[40:43], v[128:131]
		ds_read_b128 a[68:71], v2 offset:448
		v_mfma_f32_16x16x32_f16 v[124:127], a[76:79], a[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[80:83], a[32:35], v[152:155]
		ds_read_b128 a[72:75], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[156:159], a[80:83], a[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[80:83], a[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[80:83], a[44:47], v[164:167]
		ds_read_b128 a[76:79], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[168:171], a[80:83], a[48:51], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[80:83], a[52:55], v[172:175]
		ds_read_b128 a[152:155], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[176:179], a[80:83], a[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[80:83], a[60:63], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[84:87], a[60:63], v[212:215]
		ds_read_b128 v[252:255], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[208:211], a[84:87], a[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[84:87], a[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[84:87], a[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[84:87], a[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[84:87], a[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[84:87], a[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[84:87], a[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[88:91], a[32:35], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[88:91], a[36:39], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[88:91], a[40:43], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[88:91], a[44:47], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[92:95], a[44:47], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[104:107], a[92:95], a[40:43], a[104:107]
		buffer_load_dwordx4 v8, s[16:19], s12 offen lds
		v_mfma_f32_16x16x32_f16 a[100:103], a[92:95], a[36:39], a[100:103]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[96:99], a[92:95], a[32:35], a[96:99]
		s_add_i32 s12, s38, 0x4000
		s_add_i32 s37, s38, 0x2080000
		buffer_load_dwordx4 v8, s[16:19], s40 offen lds
		s_add_i32 s40, s27, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s38, 0x2100000
		s_add_i32 s44, s27, 0x80080
		s_add_i32 s45, s38, 0x2180000
		buffer_load_dwordx4 v8, s[16:19], s39 offen lds
		s_add_i32 s39, s27, 0x80
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s46, s38, 0x2200000
		v_mfma_f32_16x16x32_f16 v[232:235], a[88:91], a[48:51], v[232:235]
		v_mfma_f32_16x16x32_f16 a[108:111], a[92:95], a[48:51], a[108:111]
		buffer_load_dwordx4 v8, s[20:23], s42 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[88:91], a[52:55], v[236:239]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[112:115], a[92:95], a[52:55], a[112:115]
		v_mfma_f32_16x16x32_f16 v[240:243], a[88:91], a[56:59], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[88:91], a[60:63], v[244:247]
		buffer_load_dwordx4 v8, s[20:23], s37 offen lds
		v_mfma_f32_16x16x32_f16 a[120:123], a[92:95], a[60:63], a[120:123]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[116:119], a[92:95], a[56:59], a[116:119]
		v_mfma_f32_16x16x32_f16 v[24:27], v[12:15], a[124:127], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[12:15], a[128:131], v[28:31]
		buffer_load_dwordx4 v8, s[20:23], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], v[12:15], a[132:135], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], a[136:139], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], a[64:67], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[12:15], a[140:143], v[44:47]
		buffer_load_dwordx4 v8, s[20:23], s45 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], a[144:147], v[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[148:151], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], a[148:151], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], a[144:147], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], a[140:143], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[64:67], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[136:139], v[68:71]
		buffer_load_dwordx4 v8, s[20:23], s46 offen lds
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[132:135], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], a[128:131], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], a[124:127], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[20:23], a[124:127], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], a[128:131], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[132:135], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[136:139], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[64:67], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], a[140:143], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[20:23], a[144:147], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], a[148:151], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[68:71], a[148:151], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[68:71], a[144:147], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[68:71], a[140:143], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[68:71], a[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[68:71], a[136:139], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], a[68:71], a[132:135], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s38, 0x2280000
		buffer_load_dwordx4 v8, s[20:23], s37 offen lds
		s_mul_i32 s37, -4, s13
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s38, 0x2300000
		s_add_i32 s43, s38, 0x2380000
		s_add_i32 s37, s37, 0x10000
		buffer_load_dwordx4 v8, s[20:23], s42 offen lds
		s_add_i32 s39, s39, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s44, s36
		s_add_i32 s44, s27, 0x100080
		s_add_i32 s44, s44, s36
		buffer_load_dwordx4 v8, s[20:23], s43 offen lds
		v_add_u32_e32 v1, s37, v6
		ds_read_b128 a[32:35], v1 offset:1024
		v_mfma_f32_16x16x32_f16 v[124:127], a[68:71], a[128:131], v[124:127]
		v_add_u32_e32 v2, s37, v3
		v_mfma_f32_16x16x32_f16 v[120:123], a[68:71], a[124:127], v[120:123]
		ds_read_b128 v[12:15], v2 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[72:75], a[124:127], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[72:75], a[128:131], v[156:159]
		ds_read_b128 a[36:39], v1 offset:1152
		v_mfma_f32_16x16x32_f16 v[160:163], a[72:75], a[132:135], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[72:75], a[136:139], v[164:167]
		ds_read_b128 v[16:19], v2 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[72:75], a[64:67], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[72:75], a[140:143], v[172:175]
		ds_read_b128 a[40:43], v1 offset:1280
		v_mfma_f32_16x16x32_f16 v[176:179], a[72:75], a[144:147], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[72:75], a[148:151], v[180:183]
		ds_read_b128 a[44:47], v2 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[76:79], a[148:151], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[76:79], a[144:147], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[76:79], a[140:143], v[204:207]
		ds_read_b128 a[48:51], v1 offset:1408
		v_mfma_f32_16x16x32_f16 v[200:203], a[76:79], a[64:67], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[76:79], a[136:139], v[196:199]
		ds_read_b128 a[52:55], v2 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[76:79], a[132:135], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[76:79], a[128:131], v[188:191]
		ds_read_b128 a[56:59], v1 offset:1536
		v_mfma_f32_16x16x32_f16 v[184:187], a[76:79], a[124:127], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[152:155], a[124:127], v[216:219]
		ds_read_b128 a[60:63], v2 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[152:155], a[128:131], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[152:155], a[132:135], v[224:227]
		ds_read_b128 a[68:71], v1 offset:1664
		v_mfma_f32_16x16x32_f16 v[228:231], a[152:155], a[136:139], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[152:155], a[64:67], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[152:155], a[140:143], v[236:239]
		ds_read_b128 a[72:75], v2 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[152:155], a[144:147], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[152:155], a[148:151], v[244:247]
		ds_read_b128 a[76:79], v1 offset:1792
		v_mfma_f32_16x16x32_f16 a[120:123], v[252:255], a[148:151], a[120:123]
		v_mfma_f32_16x16x32_f16 a[116:119], v[252:255], a[144:147], a[116:119]
		ds_read_b128 a[80:83], v2 offset:1792
		v_mfma_f32_16x16x32_f16 a[112:115], v[252:255], a[140:143], a[112:115]
		v_mfma_f32_16x16x32_f16 a[108:111], v[252:255], a[64:67], a[108:111]
		ds_read_b128 a[64:67], v1 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[136:139], v[248:251]
		v_mfma_f32_16x16x32_f16 a[104:107], v[252:255], a[132:135], a[104:107]
		ds_read_b128 v[20:23], v2 offset:1920
		v_mfma_f32_16x16x32_f16 a[100:103], v[252:255], a[128:131], a[100:103]
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], v[12:15], a[32:35], v[24:27]
		ds_read_b128 a[124:127], v1 offset:1088
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], v[12:15], a[36:39], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], v[12:15], a[40:43], v[32:35]
		ds_read_b128 a[128:131], v1 offset:1216
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], a[48:51], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], a[56:59], v[40:43]
		ds_read_b128 a[92:95], v1 offset:1344
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], v[12:15], a[68:71], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], a[76:79], v[48:51]
		ds_read_b128 a[132:135], v1 offset:1472
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[64:67], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], a[64:67], v[84:87]
		ds_read_b128 a[136:139], v1 offset:1600
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], a[76:79], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], a[68:71], v[76:79]
		ds_read_b128 a[140:143], v1 offset:1728
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[56:59], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[48:51], v[68:71]
		ds_read_b128 a[88:91], v1 offset:1856
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[40:43], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], a[36:39], v[60:63]
		ds_read_b128 a[144:147], v1 offset:1984
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], a[32:35], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[44:47], a[32:35], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[44:47], a[36:39], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[44:47], a[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[44:47], a[48:51], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[44:47], a[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[44:47], a[68:71], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[44:47], a[76:79], v[112:115]
		s_add_i32 m0, s1, 0x10400
		s_add_i32 s37, s27, 0x180080
		buffer_load_dwordx4 v8, s[16:19], s39 offen lds
		s_add_i32 s37, s37, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s39, s27, 0x200080
		s_add_i32 s39, s39, s36
		s_add_i32 s40, s40, s36
		buffer_load_dwordx4 v8, s[16:19], s42 offen lds
		s_add_i32 s42, s27, 0x300080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s42, s36
		s_add_i32 s27, s27, 0x380080
		s_add_i32 s27, s27, s36
		buffer_load_dwordx4 v8, s[16:19], s44 offen lds
		s_add_i32 s36, s38, 0x60000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s38, 0x2000080
		s_add_i32 s44, s38, 0x40000
		s_add_i32 s45, s38, 0x2080080
		buffer_load_dwordx4 v8, s[16:19], s37 offen lds
		s_add_i32 s37, s38, 0x20000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s46, s38, 0x2100080
		s_lshl_b32 s14, s14, 11
		s_add_i32 s47, s38, 0x2180080
		buffer_load_dwordx4 v8, s[16:19], s39 offen lds
		ds_read_b128 v[12:15], v2 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], a[44:47], a[64:67], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[64:67], v[148:151]
		ds_read_b128 a[44:47], v2 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[76:79], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[68:71], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[56:59], v[136:139]
		ds_read_b128 a[84:87], v2 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[40:43], v[128:131]
		ds_read_b128 a[148:151], v2 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[32:35], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[60:63], a[32:35], v[152:155]
		ds_read_b128 a[52:55], v2 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[60:63], a[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[60:63], a[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[60:63], a[48:51], v[164:167]
		ds_read_b128 a[152:155], v2 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[60:63], a[56:59], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[60:63], a[68:71], v[172:175]
		ds_read_b128 a[156:159], v2 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[76:79], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[64:67], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[72:75], a[64:67], v[212:215]
		ds_read_b128 a[160:163], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[72:75], a[76:79], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[72:75], a[68:71], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[72:75], a[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[72:75], a[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[72:75], a[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[72:75], a[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[72:75], a[32:35], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[80:83], a[32:35], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[80:83], a[36:39], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[80:83], a[40:43], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[80:83], a[48:51], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], v[20:23], a[48:51], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[104:107], v[20:23], a[40:43], a[104:107]
		buffer_load_dwordx4 v8, s[16:19], s40 offen lds
		v_mfma_f32_16x16x32_f16 a[100:103], v[20:23], a[36:39], a[100:103]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[96:99], v[20:23], a[32:35], a[96:99]
		s_lshl_b32 s26, s26, 9
		s_add_i32 s39, s38, 0x2200080
		buffer_load_dwordx4 v8, s[16:19], s42 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[80:83], a[56:59], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[108:111], v[20:23], a[56:59], a[108:111]
		v_mfma_f32_16x16x32_f16 v[236:239], a[80:83], a[68:71], v[236:239]
		v_mfma_f32_16x16x32_f16 a[112:115], v[20:23], a[68:71], a[112:115]
		buffer_load_dwordx4 v8, s[16:19], s27 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[80:83], a[76:79], v[240:243]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[244:247], a[80:83], a[64:67], v[244:247]
		v_mfma_f32_16x16x32_f16 a[120:123], v[20:23], a[64:67], a[120:123]
		v_mfma_f32_16x16x32_f16 a[116:119], v[20:23], a[76:79], a[116:119]
		buffer_load_dwordx4 v8, s[20:23], s43 offen lds
		v_mfma_f32_16x16x32_f16 v[24:27], v[12:15], a[124:127], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[28:31], v[12:15], a[128:131], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[12:15], a[92:95], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], a[132:135], v[36:39]
		buffer_load_dwordx4 v8, s[20:23], s45 offen lds
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], a[136:139], v[40:43]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[44:47], v[12:15], a[140:143], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], a[88:91], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[144:147], v[52:55]
		buffer_load_dwordx4 v8, s[20:23], s46 offen lds
		v_cvt_pk_f16_f32 v12, v24, v28
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v13, v32, v36
		v_cvt_pk_f16_f32 v16, v25, v29
		v_cvt_pk_f16_f32 v17, v33, v37
		buffer_load_dwordx4 v8, s[20:23], s47 offen lds
		v_cvt_pk_f16_f32 v14, v40, v44
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v15, v48, v52
		v_cvt_pk_f16_f32 v18, v41, v45
		v_cvt_pk_f16_f32 v19, v49, v53
		v_cvt_pk_f16_f32 v20, v26, v30
		v_cvt_pk_f16_f32 v21, v34, v38
		v_cvt_pk_f16_f32 v22, v42, v46
		buffer_load_dwordx4 v8, s[20:23], s39 offen lds
		v_cvt_pk_f16_f32 v23, v50, v54
		s_add_i32 s27, s38, s26
		v_cvt_pk_f16_f32 v252, v27, v31
		s_add_i32 s27, s27, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s27 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[144:147], v[84:87]
		s_add_i32 s27, s37, s26
		v_cvt_pk_f16_f32 v253, v35, v39
		s_add_i32 s27, s27, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s27 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[88:91], v[80:83]
		s_add_i32 s27, s44, s26
		v_cvt_pk_f16_f32 v254, v43, v47
		s_add_i32 s27, s27, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s27 offen sc0 nt
		s_add_i32 s27, s36, s26
		v_cvt_pk_f16_f32 v255, v51, v55
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[140:143], v[76:79]
		s_add_i32 s27, s27, s14
		buffer_store_dwordx4 v[252:255], v0, s[8:11], s27 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[136:139], v[72:75]
		v_cvt_pk_f16_f32 v15, v80, v84
		s_add_i32 s12, s12, s26
		s_add_i32 s12, s12, s14
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[132:135], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[92:95], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[128:131], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[124:127], v[56:59]
		v_cvt_pk_f16_f32 v19, v81, v85
		v_cvt_pk_f16_f32 v14, v72, v76
		v_cvt_pk_f16_f32 v18, v73, v77
		v_cvt_pk_f16_f32 v22, v74, v78
		v_cvt_pk_f16_f32 v23, v82, v86
		v_cvt_pk_f16_f32 v26, v75, v79
		v_cvt_pk_f16_f32 v13, v64, v68
		v_cvt_pk_f16_f32 v17, v65, v69
		v_cvt_pk_f16_f32 v12, v56, v60
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s41, s26
		v_cvt_pk_f16_f32 v16, v57, v61
		v_cvt_pk_f16_f32 v20, v58, v62
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x44000
		v_cvt_pk_f16_f32 v21, v66, v70
		v_cvt_pk_f16_f32 v24, v59, v63
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v25, v67, v71
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x64000
		v_cvt_pk_f16_f32 v27, v83, v87
		v_mfma_f32_16x16x32_f16 v[88:91], a[84:87], a[124:127], v[88:91]
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[92:95], a[84:87], a[128:131], v[92:95]
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[24:27], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[96:99], a[84:87], a[92:95], v[96:99]
		s_add_i32 s12, s38, 0x8000
		s_add_i32 s12, s12, s26
		s_add_i32 s12, s12, s14
		v_mfma_f32_16x16x32_f16 v[100:103], a[84:87], a[132:135], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[84:87], a[136:139], v[104:107]
		v_cvt_pk_f16_f32 v12, v88, v92
		v_mfma_f32_16x16x32_f16 v[108:111], a[84:87], a[140:143], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[84:87], a[88:91], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[84:87], a[144:147], v[116:119]
		v_cvt_pk_f16_f32 v16, v89, v93
		v_cvt_pk_f16_f32 v20, v90, v94
		v_cvt_pk_f16_f32 v24, v91, v95
		v_cvt_pk_f16_f32 v13, v96, v100
		v_cvt_pk_f16_f32 v17, v97, v101
		v_cvt_pk_f16_f32 v21, v98, v102
		v_cvt_pk_f16_f32 v14, v104, v108
		v_cvt_pk_f16_f32 v18, v105, v109
		v_cvt_pk_f16_f32 v15, v112, v116
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x28000
		v_cvt_pk_f16_f32 v19, v113, v117
		v_cvt_pk_f16_f32 v22, v106, v110
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v23, v114, v118
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[148:151], a[148:151], a[144:147], v[148:151]
		s_add_i32 s12, s38, 0x48000
		v_cvt_pk_f16_f32 v25, v99, v103
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v26, v107, v111
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x68000
		v_cvt_pk_f16_f32 v27, v115, v119
		v_mfma_f32_16x16x32_f16 v[144:147], a[148:151], a[88:91], v[144:147]
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[140:143], a[148:151], a[140:143], v[140:143]
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[24:27], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[136:139], a[148:151], a[136:139], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[148:151], a[132:135], v[132:135]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[128:131], a[148:151], a[92:95], v[128:131]
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v15, v144, v148
		s_add_i32 s12, s38, 0x2280080
		buffer_load_dwordx4 v8, s[20:23], s12 offen lds
		v_cvt_pk_f16_f32 v19, v145, v149
		s_add_i32 s12, s38, 0xc000
		v_cvt_pk_f16_f32 v14, v136, v140
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v13, v128, v132
		s_add_i32 s27, s38, 0x2300080
		buffer_load_dwordx4 v8, s[20:23], s27 offen lds
		v_cvt_pk_f16_f32 v17, v129, v133
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v18, v137, v141
		s_add_i32 s27, s38, 0x2380080
		v_cvt_pk_f16_f32 v21, v130, v134
		buffer_load_dwordx4 v8, s[20:23], s27 offen lds
		v_cvt_pk_f16_f32 v22, v138, v142
		s_mul_i32 s27, s13, 4
		v_add_u32_e32 v1, s27, v6
		v_add_u32_e32 v2, s27, v3
		ds_read_b128 a[32:35], v1
		v_mfma_f32_16x16x32_f16 v[124:127], a[148:151], a[128:131], v[124:127]
		s_add_i32 s12, s12, s26
		s_add_i32 s12, s12, s14
		v_mfma_f32_16x16x32_f16 v[120:123], a[148:151], a[124:127], v[120:123]
		v_cvt_pk_f16_f32 v23, v146, v150
		v_cvt_pk_f16_f32 v25, v131, v135
		v_cvt_pk_f16_f32 v26, v139, v143
		v_cvt_pk_f16_f32 v27, v147, v151
		s_add_i32 s27, s38, 0x2c000
		s_add_i32 s27, s27, s26
		s_add_i32 s27, s27, s14
		s_add_i32 s36, s38, 0x4c000
		v_cvt_pk_f16_f32 v12, v120, v124
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s36, s26
		v_cvt_pk_f16_f32 v16, v121, v125
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s27 offen sc0 nt
		s_add_i32 s12, s12, s14
		v_cvt_pk_f16_f32 v20, v122, v126
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x6c000
		v_cvt_pk_f16_f32 v24, v123, v127
		ds_read_b128 a[64:67], v2
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[124:127], v[152:155]
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[24:27], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[128:131], v[156:159]
		ds_read_b128 a[36:39], v1 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[92:95], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[132:135], v[164:167]
		ds_read_b128 a[68:71], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[136:139], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[140:143], v[172:175]
		ds_read_b128 a[40:43], v1 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[88:91], v[176:179]
		v_cvt_pk_f16_f32 v12, v152, v156
		s_add_i32 s12, s38, 0x10000
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[144:147], v[180:183]
		v_cvt_pk_f16_f32 v13, v160, v164
		v_cvt_pk_f16_f32 v16, v153, v157
		v_cvt_pk_f16_f32 v14, v168, v172
		v_cvt_pk_f16_f32 v17, v161, v165
		v_cvt_pk_f16_f32 v18, v169, v173
		v_cvt_pk_f16_f32 v20, v154, v158
		v_cvt_pk_f16_f32 v21, v162, v166
		v_cvt_pk_f16_f32 v22, v170, v174
		v_cvt_pk_f16_f32 v15, v176, v180
		v_cvt_pk_f16_f32 v19, v177, v181
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		ds_read_b128 a[72:75], v2 offset:256
		s_add_i32 s12, s38, 0x30000
		v_cvt_pk_f16_f32 v23, v178, v182
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v12, v155, v159
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[212:215], a[152:155], a[144:147], v[212:215]
		s_add_i32 s12, s38, 0x50000
		v_cvt_pk_f16_f32 v13, v163, v167
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v14, v171, v175
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x70000
		v_cvt_pk_f16_f32 v15, v179, v183
		v_mfma_f32_16x16x32_f16 v[208:211], a[152:155], a[88:91], v[208:211]
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[204:207], a[152:155], a[140:143], v[204:207]
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		ds_read_b128 a[44:47], v1 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[152:155], a[136:139], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[152:155], a[132:135], v[196:199]
		ds_read_b128 a[76:79], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[192:195], a[152:155], a[92:95], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[152:155], a[128:131], v[188:191]
		ds_read_b128 a[48:51], v1 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[152:155], a[124:127], v[184:187]
		v_cvt_pk_f16_f32 v15, v208, v212
		v_cvt_pk_f16_f32 v19, v209, v213
		v_cvt_pk_f16_f32 v14, v200, v204
		v_cvt_pk_f16_f32 v18, v201, v205
		v_cvt_pk_f16_f32 v22, v202, v206
		v_cvt_pk_f16_f32 v13, v192, v196
		v_cvt_pk_f16_f32 v17, v193, v197
		v_cvt_pk_f16_f32 v21, v194, v198
		v_cvt_pk_f16_f32 v12, v184, v188
		v_cvt_pk_f16_f32 v16, v185, v189
		s_add_i32 s12, s38, 0x14000
		v_cvt_pk_f16_f32 v20, v186, v190
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v23, v210, v214
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[216:219], a[156:159], a[124:127], v[216:219]
		s_add_i32 s12, s38, 0x34000
		v_cvt_pk_f16_f32 v12, v187, v191
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v13, v195, v199
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		ds_read_b128 a[80:83], v2 offset:512
		s_add_i32 s12, s38, 0x54000
		v_cvt_pk_f16_f32 v14, v203, v207
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v15, v211, v215
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[220:223], a[156:159], a[128:131], v[220:223]
		s_add_i32 s12, s38, 0x74000
		v_mfma_f32_16x16x32_f16 v[224:227], a[156:159], a[92:95], v[224:227]
		s_add_i32 s12, s12, s26
		ds_read_b128 a[52:55], v1 offset:640
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[228:231], a[156:159], a[132:135], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[156:159], a[136:139], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[156:159], a[140:143], v[236:239]
		ds_read_b128 a[84:87], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[240:243], a[156:159], a[88:91], v[240:243]
		v_cvt_pk_f16_f32 v12, v216, v220
		s_add_i32 s12, s38, 0x18000
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 v[244:247], a[156:159], a[144:147], v[244:247]
		v_cvt_pk_f16_f32 v13, v224, v228
		v_cvt_pk_f16_f32 v16, v217, v221
		v_cvt_pk_f16_f32 v14, v232, v236
		v_cvt_pk_f16_f32 v17, v225, v229
		v_cvt_pk_f16_f32 v18, v233, v237
		v_cvt_pk_f16_f32 v20, v218, v222
		v_cvt_pk_f16_f32 v21, v226, v230
		v_cvt_pk_f16_f32 v22, v234, v238
		v_cvt_pk_f16_f32 v15, v240, v244
		v_cvt_pk_f16_f32 v19, v241, v245
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		ds_read_b128 a[56:59], v1 offset:768
		s_add_i32 s12, s38, 0x38000
		v_mfma_f32_16x16x32_f16 a[120:123], a[160:163], a[144:147], a[120:123]
		s_add_i32 s12, s12, s26
		v_mfma_f32_16x16x32_f16 a[116:119], a[160:163], a[88:91], a[116:119]
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x58000
		v_cvt_pk_f16_f32 v23, v242, v246
		v_cvt_pk_f16_f32 v12, v219, v223
		s_add_i32 s12, s12, s26
		v_cvt_pk_f16_f32 v13, v227, v231
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x78000
		v_cvt_pk_f16_f32 v14, v235, v239
		v_cvt_pk_f16_f32 v15, v243, v247
		v_accvgpr_read_b32 v4, a116
		v_accvgpr_read_b32 v5, a120
		v_cvt_pk_f16_f32 v19, v4, v5
		s_add_i32 s12, s12, s26
		v_accvgpr_read_b32 v4, a117
		v_accvgpr_read_b32 v5, a121
		v_cvt_pk_f16_f32 v23, v4, v5
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		ds_read_b128 a[88:91], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[112:115], a[160:163], a[140:143], a[112:115]
		v_mfma_f32_16x16x32_f16 a[108:111], a[160:163], a[136:139], a[108:111]
		ds_read_b128 a[60:63], v1 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], a[160:163], a[132:135], v[248:251]
		v_mfma_f32_16x16x32_f16 a[104:107], a[160:163], a[92:95], a[104:107]
		ds_read_b128 a[92:95], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[100:103], a[160:163], a[128:131], a[100:103]
		s_add_i32 s12, s38, 0x1c000
		s_add_i32 s12, s12, s26
		s_add_i32 s12, s12, s14
		v_mfma_f32_16x16x32_f16 a[96:99], a[160:163], a[124:127], a[96:99]
		v_accvgpr_read_b32 v4, a108
		v_accvgpr_read_b32 v5, a112
		v_cvt_pk_f16_f32 v18, v4, v5
		v_accvgpr_read_b32 v4, a109
		v_accvgpr_read_b32 v5, a113
		v_cvt_pk_f16_f32 v22, v4, v5
		v_accvgpr_read_b32 v4, a104
		v_cvt_pk_f16_f32 v17, v4, v248
		v_accvgpr_read_b32 v4, a105
		v_cvt_pk_f16_f32 v21, v4, v249
		v_accvgpr_read_b32 v4, a106
		v_cvt_pk_f16_f32 v13, v4, v250
		v_accvgpr_read_b32 v4, a110
		v_accvgpr_read_b32 v5, a114
		v_cvt_pk_f16_f32 v14, v4, v5
		v_accvgpr_read_b32 v4, a118
		v_accvgpr_read_b32 v5, a122
		v_cvt_pk_f16_f32 v15, v4, v5
		v_accvgpr_read_b32 v4, a107
		v_cvt_pk_f16_f32 v25, v4, v251
		v_accvgpr_read_b32 v4, a96
		v_accvgpr_read_b32 v5, a100
		v_cvt_pk_f16_f32 v16, v4, v5
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x3c000
		v_accvgpr_read_b32 v4, a97
		v_accvgpr_read_b32 v5, a101
		v_cvt_pk_f16_f32 v20, v4, v5
		v_accvgpr_read_b32 v4, a98
		v_accvgpr_read_b32 v5, a102
		v_cvt_pk_f16_f32 v12, v4, v5
		s_add_i32 s12, s12, s26
		v_accvgpr_read_b32 v4, a99
		v_accvgpr_read_b32 v5, a103
		v_cvt_pk_f16_f32 v24, v4, v5
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x5c000
		v_accvgpr_read_b32 v4, a111
		v_accvgpr_read_b32 v5, a115
		v_cvt_pk_f16_f32 v26, v4, v5
		s_add_i32 s12, s12, s26
		v_accvgpr_read_b32 v4, a119
		v_accvgpr_read_b32 v5, a123
		v_cvt_pk_f16_f32 v27, v4, v5
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s12 offen sc0 nt
		s_add_i32 s12, s38, 0x7c000
		s_add_i32 s12, s12, s26
		s_add_i32 s12, s12, s14
		buffer_store_dwordx4 v[24:27], v0, s[8:11], s12 offen sc0 nt
		s_cmp_lt_i32 s25, 0x300
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_0
.Lgfx950_f16_streamk_gemm.loop_exit_0:
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v5, 0x80, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v7, 0x80080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v8, 0x100080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v9, 0x180080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v10, 0x200080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v11, 0x280080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v12, 0x300080, v4
		v_accvgpr_read_b32 v4, a5
		v_add_u32_e32 v13, 0x380080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v14, 0x6000080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v15, 0x6080080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v16, 0x6100080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v17, 0x6180080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v18, 0x6200080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v19, 0x6280080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v20, 0x6300080, v4
		v_accvgpr_read_b32 v4, a4
		v_add_u32_e32 v21, 0x6380080, v4
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
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[0:3], a[64:67], a[32:35], a[0:3]
		ds_read_b128 a[4:7], v1 offset:64
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[28:31], a[64:67], a[36:39], a[28:31]
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		s_add_i32 s15, s15, 1
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 a[24:27], a[64:67], a[40:43], a[24:27]
		ds_read_b128 a[96:99], v1 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 a[20:23], a[64:67], a[44:47], a[20:23]
		s_and_b32 s2, s15, 1
		s_mul_i32 s2, 0x10400, s2
		s_xor_b32 s3, s13, -1
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 a[16:19], a[64:67], a[48:51], a[16:19]
		ds_read_b128 a[100:103], v1 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 a[12:15], a[64:67], a[52:55], a[12:15]
		s_add_i32 s3, s3, 1
		s_add_i32 s13, s3, 0x4100
		s_mul_i32 s3, s13, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[8:11], a[64:67], a[56:59], a[8:11]
		ds_read_b128 a[104:107], v1 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[60:63], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[60:63], v[56:59]
		ds_read_b128 a[108:111], v1 offset:576
		v_mfma_f32_16x16x32_f16 v[52:55], a[68:71], a[56:59], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[68:71], a[52:55], v[48:51]
		ds_read_b128 a[112:115], v1 offset:704
		v_mfma_f32_16x16x32_f16 v[44:47], a[68:71], a[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[40:43], a[68:71], a[44:47], v[40:43]
		ds_read_b128 a[116:119], v1 offset:832
		v_mfma_f32_16x16x32_f16 v[36:39], a[68:71], a[40:43], v[36:39]
		v_mfma_f32_16x16x32_f16 v[32:35], a[68:71], a[36:39], v[32:35]
		ds_read_b128 a[120:123], v1 offset:960
		v_mfma_f32_16x16x32_f16 v[28:31], a[68:71], a[32:35], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[72:75], a[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], a[72:75], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[72:75], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[72:75], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[72:75], a[48:51], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[72:75], a[52:55], v[80:83]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[84:87], a[72:75], a[56:59], v[84:87]
		s_mov_b32 m0, s7
		ds_read_b128 a[64:67], v2 offset:64
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[60:63], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[60:63], v[120:123]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[116:119], a[76:79], a[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[76:79], a[52:55], v[112:115]
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		ds_read_b128 a[68:71], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[108:111], a[76:79], a[48:51], v[108:111]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[104:107], a[76:79], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], a[76:79], a[40:43], v[100:103]
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[72:75], v2 offset:320
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[96:99], a[76:79], a[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[92:95], a[76:79], a[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[80:83], a[32:35], v[124:127]
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b128 a[76:79], v2 offset:448
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[80:83], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[80:83], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[80:83], a[44:47], v[136:139]
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		ds_read_b128 a[124:127], v2 offset:576
		ds_read_b128 a[128:131], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[140:143], a[80:83], a[48:51], v[140:143]
		s_add_i32 s7, s1, s2
		v_mfma_f32_16x16x32_f16 v[144:147], a[80:83], a[52:55], v[144:147]
		ds_read_b128 a[132:135], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[148:151], a[80:83], a[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[80:83], a[60:63], v[152:155]
		v_add_u32_e32 v1, s3, v6
		v_mfma_f32_16x16x32_f16 v[184:187], a[84:87], a[60:63], v[184:187]
		ds_read_b128 v[252:255], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[180:183], a[84:87], a[56:59], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[84:87], a[52:55], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[84:87], a[48:51], v[172:175]
		v_mfma_f32_16x16x32_f16 v[168:171], a[84:87], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[164:167], a[84:87], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[160:163], a[84:87], a[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[156:159], a[84:87], a[32:35], v[156:159]
		v_add_u32_e32 v2, s3, v3
		v_mfma_f32_16x16x32_f16 v[188:191], a[88:91], a[32:35], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[88:91], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[88:91], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[88:91], a[44:47], v[200:203]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[232:235], a[92:95], a[44:47], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[204:207], a[88:91], a[48:51], v[204:207]
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[208:211], a[88:91], a[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 v[240:243], a[92:95], a[52:55], v[240:243]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[212:215], a[88:91], a[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[88:91], a[60:63], v[216:219]
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[248:251], a[92:95], a[60:63], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], a[92:95], a[56:59], v[244:247]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[92:95], a[48:51], v[236:239]
		v_mfma_f32_16x16x32_f16 v[228:231], a[92:95], a[40:43], v[228:231]
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[224:227], a[92:95], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 v[220:223], a[92:95], a[32:35], v[220:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[0:3], a[64:67], a[4:7], a[0:3]
		v_mfma_f32_16x16x32_f16 a[28:31], a[64:67], a[96:99], a[28:31]
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[24:27], a[64:67], a[100:103], a[24:27]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[20:23], a[64:67], a[104:107], a[20:23]
		v_mfma_f32_16x16x32_f16 a[16:19], a[64:67], a[108:111], a[16:19]
		v_mfma_f32_16x16x32_f16 a[12:15], a[64:67], a[112:115], a[12:15]
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[8:11], a[64:67], a[116:119], a[8:11]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[120:123], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[120:123], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[68:71], a[116:119], v[52:55]
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], a[68:71], a[112:115], v[48:51]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[44:47], a[68:71], a[108:111], v[44:47]
		v_mfma_f32_16x16x32_f16 v[40:43], a[68:71], a[104:107], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], a[68:71], a[100:103], v[36:39]
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[68:71], a[96:99], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[28:31], a[68:71], a[4:7], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[72:75], a[4:7], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], a[72:75], a[96:99], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[72:75], a[100:103], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[72:75], a[104:107], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[72:75], a[108:111], v[76:79]
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[80:83], a[72:75], a[112:115], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[72:75], a[116:119], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[120:123], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[120:123], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[76:79], a[116:119], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[76:79], a[112:115], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[76:79], a[108:111], v[108:111]
		v_mfma_f32_16x16x32_f16 v[104:107], a[76:79], a[104:107], v[104:107]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[100:103], a[76:79], a[100:103], v[100:103]
		s_waitcnt vmcnt(13)
		s_barrier
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		ds_read_b128 a[32:35], v1
		v_mfma_f32_16x16x32_f16 v[96:99], a[76:79], a[96:99], v[96:99]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[92:95], a[76:79], a[4:7], v[92:95]
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		ds_read_b128 a[64:67], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[124:127], a[4:7], v[124:127]
		s_add_i32 m0, m0, 0x1040
		s_cmp_lt_i32 s15, 0x7e
		v_mfma_f32_16x16x32_f16 v[128:131], a[124:127], a[96:99], v[128:131]
		buffer_load_dwordx4 v21, s[20:23], 0 offen lds
		ds_read_b128 a[36:39], v1 offset:128
		v_mfma_f32_16x16x32_f16 v[132:135], a[124:127], a[100:103], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[124:127], a[104:107], v[136:139]
		ds_read_b128 a[68:71], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[140:143], a[124:127], a[108:111], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[124:127], a[112:115], v[144:147]
		ds_read_b128 a[40:43], v1 offset:256
		v_mfma_f32_16x16x32_f16 v[148:151], a[124:127], a[116:119], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[124:127], a[120:123], v[152:155]
		ds_read_b128 a[72:75], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[120:123], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[116:119], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[128:131], a[112:115], v[176:179]
		ds_read_b128 a[44:47], v1 offset:384
		v_mfma_f32_16x16x32_f16 v[172:175], a[128:131], a[108:111], v[172:175]
		v_mfma_f32_16x16x32_f16 v[168:171], a[128:131], a[104:107], v[168:171]
		ds_read_b128 a[76:79], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[164:167], a[128:131], a[100:103], v[164:167]
		v_mfma_f32_16x16x32_f16 v[160:163], a[128:131], a[96:99], v[160:163]
		ds_read_b128 a[48:51], v1 offset:512
		v_mfma_f32_16x16x32_f16 v[156:159], a[128:131], a[4:7], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[132:135], a[4:7], v[188:191]
		ds_read_b128 a[80:83], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[192:195], a[132:135], a[96:99], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[132:135], a[100:103], v[196:199]
		ds_read_b128 a[52:55], v1 offset:640
		v_mfma_f32_16x16x32_f16 v[200:203], a[132:135], a[104:107], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[132:135], a[108:111], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[132:135], a[112:115], v[208:211]
		ds_read_b128 a[84:87], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[116:119], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[120:123], v[216:219]
		ds_read_b128 a[56:59], v1 offset:768
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[120:123], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], a[116:119], v[244:247]
		ds_read_b128 a[88:91], v2 offset:768
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], a[112:115], v[240:243]
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], a[108:111], v[236:239]
		ds_read_b128 a[60:63], v1 offset:896
		v_mfma_f32_16x16x32_f16 v[232:235], v[252:255], a[104:107], v[232:235]
		v_mfma_f32_16x16x32_f16 v[228:231], v[252:255], a[100:103], v[228:231]
		ds_read_b128 a[92:95], v2 offset:896
		v_mfma_f32_16x16x32_f16 v[224:227], v[252:255], a[96:99], v[224:227]
		v_mfma_f32_16x16x32_f16 v[220:223], v[252:255], a[4:7], v[220:223]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_2
.Lgfx950_f16_streamk_gemm.loop_exit_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[0:3], a[64:67], a[32:35], a[0:3]
		ds_read_b128 v[8:11], v2 offset:64
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[28:31], a[68:71], a[32:35], v[28:31]
		ds_read_b128 v[12:15], v2 offset:192
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[60:63], a[72:75], a[32:35], v[60:63]
		ds_read_b128 v[16:19], v2 offset:320
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[92:95], a[76:79], a[32:35], v[92:95]
		ds_read_b128 v[20:23], v2 offset:448
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[124:127], a[80:83], a[32:35], v[124:127]
		ds_read_b128 a[4:7], v2 offset:576
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[156:159], a[84:87], a[32:35], v[156:159]
		ds_read_b128 a[96:99], v2 offset:704
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[188:191], a[88:91], a[32:35], v[188:191]
		ds_read_b128 a[100:103], v2 offset:832
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[220:223], a[92:95], a[32:35], v[220:223]
		ds_read_b128 a[32:35], v2 offset:960
		v_mfma_f32_16x16x32_f16 a[28:31], a[64:67], a[36:39], a[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[68:71], a[36:39], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[72:75], a[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[76:79], a[36:39], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[80:83], a[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[84:87], a[36:39], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[88:91], a[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[92:95], a[36:39], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[92:95], a[40:43], v[228:231]
		v_mfma_f32_16x16x32_f16 a[24:27], a[64:67], a[40:43], a[24:27]
		v_mfma_f32_16x16x32_f16 v[36:39], a[68:71], a[40:43], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[72:75], a[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[76:79], a[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[80:83], a[40:43], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[84:87], a[40:43], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[88:91], a[40:43], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[88:91], a[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 a[20:23], a[64:67], a[44:47], a[20:23]
		v_mfma_f32_16x16x32_f16 v[40:43], a[68:71], a[44:47], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[72:75], a[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[76:79], a[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[80:83], a[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[84:87], a[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[232:235], a[92:95], a[44:47], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[92:95], a[48:51], v[236:239]
		v_mfma_f32_16x16x32_f16 a[16:19], a[64:67], a[48:51], a[16:19]
		v_mfma_f32_16x16x32_f16 v[44:47], a[68:71], a[48:51], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[72:75], a[48:51], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[76:79], a[48:51], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[80:83], a[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[84:87], a[48:51], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[88:91], a[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[88:91], a[52:55], v[208:211]
		v_mfma_f32_16x16x32_f16 a[12:15], a[64:67], a[52:55], a[12:15]
		v_mfma_f32_16x16x32_f16 v[48:51], a[68:71], a[52:55], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[72:75], a[52:55], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[76:79], a[52:55], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[80:83], a[52:55], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[84:87], a[52:55], v[176:179]
		v_mfma_f32_16x16x32_f16 v[240:243], a[92:95], a[52:55], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[92:95], a[56:59], v[244:247]
		v_mfma_f32_16x16x32_f16 a[8:11], a[64:67], a[56:59], a[8:11]
		v_mfma_f32_16x16x32_f16 v[52:55], a[68:71], a[56:59], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[72:75], a[56:59], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[76:79], a[56:59], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[80:83], a[56:59], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[84:87], a[56:59], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[88:91], a[56:59], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[88:91], a[60:63], v[216:219]
		v_mfma_f32_16x16x32_f16 v[24:27], a[64:67], a[60:63], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[68:71], a[60:63], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[72:75], a[60:63], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[76:79], a[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[80:83], a[60:63], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[84:87], a[60:63], v[184:187]
		v_mfma_f32_16x16x32_f16 v[248:251], a[92:95], a[60:63], v[248:251]
		ds_read_b128 a[36:39], v1 offset:64
		ds_read_b128 a[40:43], v1 offset:192
		ds_read_b128 a[44:47], v1 offset:320
		ds_read_b128 a[48:51], v1 offset:448
		ds_read_b128 a[52:55], v1 offset:576
		ds_read_b128 a[56:59], v1 offset:704
		ds_read_b128 a[60:63], v1 offset:832
		ds_read_b128 v[252:255], v1 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], v[8:11], a[36:39], a[0:3]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[28:31], v[8:11], a[40:43], a[28:31]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[24:27], v[8:11], a[44:47], a[24:27]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[20:23], v[8:11], a[48:51], a[20:23]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 a[16:19], v[8:11], a[52:55], a[16:19]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 a[12:15], v[8:11], a[56:59], a[12:15]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 a[8:11], v[8:11], a[60:63], a[8:11]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], v[252:255], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], v[252:255], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[60:63], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], v[12:15], a[56:59], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], v[12:15], a[52:55], v[44:47]
		v_mfma_f32_16x16x32_f16 v[40:43], v[12:15], a[48:51], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], v[12:15], a[44:47], v[36:39]
		v_mfma_f32_16x16x32_f16 v[32:35], v[12:15], a[40:43], v[32:35]
		v_mfma_f32_16x16x32_f16 v[28:31], v[12:15], a[36:39], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], a[36:39], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[16:19], a[40:43], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[16:19], a[44:47], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[16:19], a[48:51], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[16:19], a[52:55], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[16:19], a[56:59], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], a[60:63], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], v[252:255], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], v[252:255], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], a[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], v[20:23], a[56:59], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], v[20:23], a[52:55], v[108:111]
		v_mfma_f32_16x16x32_f16 v[104:107], v[20:23], a[48:51], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], v[20:23], a[44:47], v[100:103]
		v_mfma_f32_16x16x32_f16 v[96:99], v[20:23], a[40:43], v[96:99]
		v_mfma_f32_16x16x32_f16 v[92:95], v[20:23], a[36:39], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[4:7], a[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], a[4:7], a[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[4:7], a[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[4:7], a[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[4:7], a[52:55], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[4:7], a[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[4:7], a[60:63], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[4:7], v[252:255], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], v[252:255], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[96:99], a[60:63], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[96:99], a[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[96:99], a[52:55], v[172:175]
		v_mfma_f32_16x16x32_f16 v[168:171], a[96:99], a[48:51], v[168:171]
		v_mfma_f32_16x16x32_f16 v[164:167], a[96:99], a[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[160:163], a[96:99], a[40:43], v[160:163]
		v_mfma_f32_16x16x32_f16 v[156:159], a[96:99], a[36:39], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[100:103], a[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], a[100:103], a[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], a[100:103], a[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[100:103], a[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], a[100:103], a[52:55], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[100:103], a[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], a[100:103], a[60:63], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[100:103], v[252:255], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[32:35], v[252:255], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], a[32:35], a[60:63], v[244:247]
		v_mfma_f32_16x16x32_f16 v[240:243], a[32:35], a[56:59], v[240:243]
		v_mfma_f32_16x16x32_f16 v[236:239], a[32:35], a[52:55], v[236:239]
		v_mfma_f32_16x16x32_f16 v[232:235], a[32:35], a[48:51], v[232:235]
		v_mfma_f32_16x16x32_f16 v[228:231], a[32:35], a[44:47], v[228:231]
		v_mfma_f32_16x16x32_f16 v[224:227], a[32:35], a[40:43], v[224:227]
		v_mfma_f32_16x16x32_f16 v[220:223], a[32:35], a[36:39], v[220:223]
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s1, -4, s13
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v1, s1, v6
		ds_read_b128 v[4:7], v1 offset:1024
		ds_read_b128 v[8:11], v1 offset:1152
		ds_read_b128 v[12:15], v1 offset:1280
		ds_read_b128 v[16:19], v1 offset:1408
		ds_read_b128 v[20:23], v1 offset:1536
		ds_read_b128 a[4:7], v1 offset:1664
		ds_read_b128 a[32:35], v1 offset:1792
		ds_read_b128 a[36:39], v1 offset:1920
		v_add_u32_e32 v2, s1, v3
		ds_read_b128 a[40:43], v2 offset:1024
		ds_read_b128 a[44:47], v2 offset:1152
		ds_read_b128 a[48:51], v2 offset:1280
		ds_read_b128 a[52:55], v2 offset:1408
		ds_read_b128 a[56:59], v2 offset:1536
		ds_read_b128 a[60:63], v2 offset:1664
		ds_read_b128 a[64:67], v2 offset:1792
		ds_read_b128 a[68:71], v2 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], a[40:43], v[4:7], a[0:3]
		ds_read_b128 a[72:75], v2 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[28:31], a[44:47], v[4:7], v[28:31]
		ds_read_b128 a[76:79], v2 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[60:63], a[48:51], v[4:7], v[60:63]
		ds_read_b128 a[80:83], v2 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[92:95], a[52:55], v[4:7], v[92:95]
		ds_read_b128 a[84:87], v2 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[124:127], a[56:59], v[4:7], v[124:127]
		ds_read_b128 a[88:91], v2 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[156:159], a[60:63], v[4:7], v[156:159]
		ds_read_b128 a[92:95], v2 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[188:191], a[64:67], v[4:7], v[188:191]
		ds_read_b128 v[252:255], v2 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[220:223], a[68:71], v[4:7], v[220:223]
		ds_read_b128 a[96:99], v2 offset:1984
		v_mfma_f32_16x16x32_f16 a[28:31], a[40:43], v[8:11], a[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[44:47], v[8:11], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[48:51], v[8:11], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[52:55], v[8:11], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[56:59], v[8:11], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[60:63], v[8:11], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[64:67], v[8:11], v[192:195]
		v_mfma_f32_16x16x32_f16 v[224:227], a[68:71], v[8:11], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[68:71], v[12:15], v[228:231]
		v_mfma_f32_16x16x32_f16 a[24:27], a[40:43], v[12:15], a[24:27]
		v_mfma_f32_16x16x32_f16 v[36:39], a[44:47], v[12:15], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[48:51], v[12:15], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[52:55], v[12:15], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[56:59], v[12:15], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[60:63], v[12:15], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[64:67], v[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], a[64:67], v[16:19], v[200:203]
		v_mfma_f32_16x16x32_f16 a[20:23], a[40:43], v[16:19], a[20:23]
		v_mfma_f32_16x16x32_f16 v[40:43], a[44:47], v[16:19], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[48:51], v[16:19], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[52:55], v[16:19], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[56:59], v[16:19], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[60:63], v[16:19], v[168:171]
		v_mfma_f32_16x16x32_f16 v[232:235], a[68:71], v[16:19], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[68:71], v[20:23], v[236:239]
		v_mfma_f32_16x16x32_f16 a[16:19], a[40:43], v[20:23], a[16:19]
		v_mfma_f32_16x16x32_f16 v[44:47], a[44:47], v[20:23], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[48:51], v[20:23], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[52:55], v[20:23], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[56:59], v[20:23], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[60:63], v[20:23], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[64:67], v[20:23], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], a[64:67], a[4:7], v[208:211]
		v_mfma_f32_16x16x32_f16 a[12:15], a[40:43], a[4:7], a[12:15]
		v_mfma_f32_16x16x32_f16 v[48:51], a[44:47], a[4:7], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[48:51], a[4:7], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[52:55], a[4:7], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[56:59], a[4:7], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[60:63], a[4:7], v[176:179]
		v_mfma_f32_16x16x32_f16 v[240:243], a[68:71], a[4:7], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[32:35], v[244:247]
		v_mfma_f32_16x16x32_f16 a[8:11], a[40:43], a[32:35], a[8:11]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[32:35], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[32:35], v[84:87]
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[32:35], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[32:35], v[148:151]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[32:35], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[32:35], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[36:39], v[216:219]
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[36:39], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[36:39], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[36:39], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[36:39], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[36:39], v[248:251]
		ds_read_b128 a[4:7], v1 offset:1088
		ds_read_b128 a[32:35], v1 offset:1216
		ds_read_b128 a[36:39], v1 offset:1344
		ds_read_b128 a[40:43], v1 offset:1472
		ds_read_b128 a[44:47], v1 offset:1600
		ds_read_b128 a[48:51], v1 offset:1728
		ds_read_b128 a[52:55], v1 offset:1856
		ds_read_b128 v[4:7], v1 offset:1984
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[0:3], a[72:75], a[4:7], a[0:3]
		s_add_i32 s1, s24, 0x6000000
		s_lshl_b32 s2, s6, 9
		s_add_i32 s1, s1, s2
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 a[28:31], a[72:75], a[32:35], a[28:31]
		s_lshl_b32 s0, s0, 11
		s_add_i32 s1, s1, s0
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 a[24:27], a[72:75], a[36:39], a[24:27]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 a[20:23], a[72:75], a[40:43], a[20:23]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 a[16:19], a[72:75], a[44:47], a[16:19]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 a[12:15], a[72:75], a[48:51], a[12:15]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 a[8:11], a[72:75], a[52:55], a[8:11]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[24:27], a[72:75], v[4:7], v[24:27]
		v_accvgpr_read_b32 v1, a0
		v_accvgpr_read_b32 v2, a28
		v_cvt_pk_f16_f32 v8, v1, v2
		v_accvgpr_read_b32 v1, a1
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v12, v1, v2
		v_accvgpr_read_b32 v1, a2
		v_accvgpr_read_b32 v2, a30
		v_cvt_pk_f16_f32 v16, v1, v2
		v_accvgpr_read_b32 v1, a3
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v20, v1, v2
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a24
		v_cvt_pk_f16_f32 v9, v2, v1
		v_accvgpr_read_b32 v1, a21
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v13, v2, v1
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v2, a16
		v_cvt_pk_f16_f32 v10, v2, v1
		v_accvgpr_read_b32 v1, a13
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v14, v2, v1
		v_accvgpr_read_b32 v1, a8
		v_cvt_pk_f16_f32 v11, v1, v24
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6020000
		v_accvgpr_read_b32 v1, a9
		v_cvt_pk_f16_f32 v15, v1, v25
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6040000
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a26
		v_cvt_pk_f16_f32 v17, v2, v1
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v2, a18
		v_cvt_pk_f16_f32 v18, v2, v1
		v_accvgpr_read_b32 v1, a10
		v_cvt_pk_f16_f32 v19, v1, v26
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6060000
		v_accvgpr_read_b32 v1, a23
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v21, v2, v1
		v_accvgpr_read_b32 v1, a15
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v22, v2, v1
		v_accvgpr_read_b32 v1, a11
		v_cvt_pk_f16_f32 v23, v1, v27
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[56:59], a[76:79], v[4:7], v[56:59]
		s_add_i32 s1, s24, 0x6004000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[52:55], a[76:79], a[52:55], v[52:55]
		v_mfma_f32_16x16x32_f16 v[48:51], a[76:79], a[48:51], v[48:51]
		v_mfma_f32_16x16x32_f16 v[44:47], a[76:79], a[44:47], v[44:47]
		v_mfma_f32_16x16x32_f16 v[40:43], a[76:79], a[40:43], v[40:43]
		v_mfma_f32_16x16x32_f16 v[36:39], a[76:79], a[36:39], v[36:39]
		v_mfma_f32_16x16x32_f16 v[32:35], a[76:79], a[32:35], v[32:35]
		v_mfma_f32_16x16x32_f16 v[28:31], a[76:79], a[4:7], v[28:31]
		s_add_i32 s3, s24, 0x6024000
		s_add_i32 s3, s3, s2
		v_cvt_pk_f16_f32 v11, v52, v56
		v_cvt_pk_f16_f32 v15, v53, v57
		v_cvt_pk_f16_f32 v10, v44, v48
		v_cvt_pk_f16_f32 v14, v45, v49
		v_cvt_pk_f16_f32 v9, v36, v40
		v_cvt_pk_f16_f32 v13, v37, v41
		v_cvt_pk_f16_f32 v8, v28, v32
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s3, s0
		v_cvt_pk_f16_f32 v12, v29, v33
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6044000
		v_cvt_pk_f16_f32 v8, v30, v34
		v_cvt_pk_f16_f32 v9, v38, v42
		v_cvt_pk_f16_f32 v10, v46, v50
		v_cvt_pk_f16_f32 v11, v54, v58
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6064000
		v_cvt_pk_f16_f32 v8, v31, v35
		v_cvt_pk_f16_f32 v9, v39, v43
		v_cvt_pk_f16_f32 v10, v47, v51
		v_cvt_pk_f16_f32 v11, v55, v59
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[60:63], a[80:83], a[4:7], v[60:63]
		s_add_i32 s1, s24, 0x6008000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[64:67], a[80:83], a[32:35], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], a[80:83], a[36:39], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], a[80:83], a[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], a[80:83], a[44:47], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], a[80:83], a[48:51], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], a[80:83], a[52:55], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[80:83], v[4:7], v[88:91]
		s_add_i32 s3, s24, 0x6028000
		s_add_i32 s3, s3, s2
		v_cvt_pk_f16_f32 v8, v60, v64
		v_cvt_pk_f16_f32 v12, v61, v65
		v_cvt_pk_f16_f32 v9, v68, v72
		v_cvt_pk_f16_f32 v13, v69, v73
		v_cvt_pk_f16_f32 v10, v76, v80
		v_cvt_pk_f16_f32 v14, v77, v81
		v_cvt_pk_f16_f32 v11, v84, v88
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s3, s0
		v_cvt_pk_f16_f32 v15, v85, v89
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6048000
		v_cvt_pk_f16_f32 v8, v62, v66
		v_cvt_pk_f16_f32 v9, v70, v74
		v_cvt_pk_f16_f32 v10, v78, v82
		v_cvt_pk_f16_f32 v11, v86, v90
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6068000
		v_cvt_pk_f16_f32 v8, v63, v67
		v_cvt_pk_f16_f32 v9, v71, v75
		v_cvt_pk_f16_f32 v10, v79, v83
		v_cvt_pk_f16_f32 v11, v87, v91
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[120:123], a[84:87], v[4:7], v[120:123]
		s_add_i32 s1, s24, 0x600c000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[116:119], a[84:87], a[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[112:115], a[84:87], a[48:51], v[112:115]
		v_mfma_f32_16x16x32_f16 v[108:111], a[84:87], a[44:47], v[108:111]
		v_mfma_f32_16x16x32_f16 v[104:107], a[84:87], a[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[100:103], a[84:87], a[36:39], v[100:103]
		v_mfma_f32_16x16x32_f16 v[96:99], a[84:87], a[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[92:95], a[84:87], a[4:7], v[92:95]
		s_add_i32 s3, s24, 0x602c000
		s_add_i32 s3, s3, s2
		v_cvt_pk_f16_f32 v11, v116, v120
		v_cvt_pk_f16_f32 v15, v117, v121
		v_cvt_pk_f16_f32 v10, v108, v112
		v_cvt_pk_f16_f32 v14, v109, v113
		v_cvt_pk_f16_f32 v9, v100, v104
		v_cvt_pk_f16_f32 v13, v101, v105
		v_cvt_pk_f16_f32 v8, v92, v96
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s3, s0
		v_cvt_pk_f16_f32 v12, v93, v97
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x604c000
		v_cvt_pk_f16_f32 v8, v94, v98
		v_cvt_pk_f16_f32 v9, v102, v106
		v_cvt_pk_f16_f32 v10, v110, v114
		v_cvt_pk_f16_f32 v11, v118, v122
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x606c000
		v_cvt_pk_f16_f32 v8, v95, v99
		v_cvt_pk_f16_f32 v9, v103, v107
		v_cvt_pk_f16_f32 v10, v111, v115
		v_cvt_pk_f16_f32 v11, v119, v123
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[124:127], a[88:91], a[4:7], v[124:127]
		s_add_i32 s1, s24, 0x6010000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[128:131], a[88:91], a[32:35], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], a[88:91], a[36:39], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], a[88:91], a[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], a[88:91], a[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], a[88:91], a[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], a[88:91], a[52:55], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[88:91], v[4:7], v[152:155]
		s_add_i32 s3, s24, 0x6030000
		s_add_i32 s3, s3, s2
		v_cvt_pk_f16_f32 v8, v124, v128
		v_cvt_pk_f16_f32 v12, v125, v129
		v_cvt_pk_f16_f32 v9, v132, v136
		v_cvt_pk_f16_f32 v13, v133, v137
		v_cvt_pk_f16_f32 v10, v140, v144
		v_cvt_pk_f16_f32 v14, v141, v145
		v_cvt_pk_f16_f32 v11, v148, v152
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s3, s0
		v_cvt_pk_f16_f32 v15, v149, v153
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6050000
		v_cvt_pk_f16_f32 v8, v126, v130
		v_cvt_pk_f16_f32 v9, v134, v138
		v_cvt_pk_f16_f32 v10, v142, v146
		v_cvt_pk_f16_f32 v11, v150, v154
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6070000
		v_cvt_pk_f16_f32 v8, v127, v131
		v_cvt_pk_f16_f32 v9, v135, v139
		v_cvt_pk_f16_f32 v10, v143, v147
		v_cvt_pk_f16_f32 v11, v151, v155
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[184:187], a[92:95], v[4:7], v[184:187]
		s_add_i32 s1, s24, 0x6014000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[180:183], a[92:95], a[52:55], v[180:183]
		v_mfma_f32_16x16x32_f16 v[176:179], a[92:95], a[48:51], v[176:179]
		v_mfma_f32_16x16x32_f16 v[172:175], a[92:95], a[44:47], v[172:175]
		v_mfma_f32_16x16x32_f16 v[168:171], a[92:95], a[40:43], v[168:171]
		v_mfma_f32_16x16x32_f16 v[164:167], a[92:95], a[36:39], v[164:167]
		v_mfma_f32_16x16x32_f16 v[160:163], a[92:95], a[32:35], v[160:163]
		v_mfma_f32_16x16x32_f16 v[156:159], a[92:95], a[4:7], v[156:159]
		s_add_i32 s3, s24, 0x6034000
		s_add_i32 s3, s3, s2
		v_cvt_pk_f16_f32 v11, v180, v184
		v_cvt_pk_f16_f32 v15, v181, v185
		v_cvt_pk_f16_f32 v10, v172, v176
		v_cvt_pk_f16_f32 v14, v173, v177
		v_cvt_pk_f16_f32 v9, v164, v168
		v_cvt_pk_f16_f32 v13, v165, v169
		v_cvt_pk_f16_f32 v8, v156, v160
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s3, s0
		v_cvt_pk_f16_f32 v12, v157, v161
		buffer_store_dwordx4 v[12:15], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6054000
		v_cvt_pk_f16_f32 v8, v158, v162
		v_cvt_pk_f16_f32 v9, v166, v170
		v_cvt_pk_f16_f32 v10, v174, v178
		v_cvt_pk_f16_f32 v11, v182, v186
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x6074000
		v_cvt_pk_f16_f32 v8, v159, v163
		v_cvt_pk_f16_f32 v9, v167, v171
		v_cvt_pk_f16_f32 v10, v175, v179
		v_cvt_pk_f16_f32 v11, v183, v187
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[8:11], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[188:191], v[252:255], a[4:7], v[188:191]
		s_add_i32 s1, s24, 0x6018000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		v_mfma_f32_16x16x32_f16 v[192:195], v[252:255], a[32:35], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[252:255], a[36:39], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[252:255], a[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[252:255], a[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[252:255], a[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[212:215], v[252:255], a[52:55], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[252:255], v[4:7], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[96:99], v[4:7], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], a[96:99], a[52:55], v[244:247]
		v_cvt_pk_f16_f32 v4, v188, v192
		v_mfma_f32_16x16x32_f16 v[240:243], a[96:99], a[48:51], v[240:243]
		v_cvt_pk_f16_f32 v5, v196, v200
		v_mfma_f32_16x16x32_f16 v[236:239], a[96:99], a[44:47], v[236:239]
		v_cvt_pk_f16_f32 v6, v204, v208
		v_mfma_f32_16x16x32_f16 v[232:235], a[96:99], a[40:43], v[232:235]
		v_cvt_pk_f16_f32 v7, v212, v216
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[228:231], a[96:99], a[36:39], v[228:231]
		v_cvt_pk_f16_f32 v4, v189, v193
		v_cvt_pk_f16_f32 v5, v197, v201
		v_cvt_pk_f16_f32 v6, v205, v209
		v_cvt_pk_f16_f32 v7, v213, v217
		s_add_i32 s1, s24, 0x6038000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[224:227], a[96:99], a[32:35], v[224:227]
		v_cvt_pk_f16_f32 v4, v190, v194
		v_cvt_pk_f16_f32 v5, v198, v202
		v_cvt_pk_f16_f32 v6, v206, v210
		v_cvt_pk_f16_f32 v7, v214, v218
		s_add_i32 s1, s24, 0x6058000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[220:223], a[96:99], a[4:7], v[220:223]
		v_cvt_pk_f16_f32 v4, v191, v195
		v_cvt_pk_f16_f32 v5, v199, v203
		v_cvt_pk_f16_f32 v6, v207, v211
		v_cvt_pk_f16_f32 v7, v215, v219
		s_add_i32 s1, s24, 0x6078000
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x601c000
		v_cvt_pk_f16_f32 v4, v220, v224
		v_cvt_pk_f16_f32 v5, v228, v232
		v_cvt_pk_f16_f32 v6, v236, v240
		v_cvt_pk_f16_f32 v7, v244, v248
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x603c000
		v_cvt_pk_f16_f32 v4, v221, v225
		v_cvt_pk_f16_f32 v5, v229, v233
		v_cvt_pk_f16_f32 v6, v237, v241
		v_cvt_pk_f16_f32 v7, v245, v249
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x605c000
		v_cvt_pk_f16_f32 v4, v222, v226
		v_cvt_pk_f16_f32 v5, v230, v234
		v_cvt_pk_f16_f32 v6, v238, v242
		v_cvt_pk_f16_f32 v7, v246, v250
		s_add_i32 s1, s1, s2
		s_add_i32 s1, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s24, 0x607c000
		v_cvt_pk_f16_f32 v4, v223, v227
		v_cvt_pk_f16_f32 v5, v231, v235
		v_cvt_pk_f16_f32 v6, v239, v243
		v_cvt_pk_f16_f32 v7, v247, v251
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		buffer_store_dwordx4 v[4:7], v0, s[8:11], s0 offen sc0 nt
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
		.amdhsa_next_free_vgpr 424
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
	.set .Lgfx950_f16_streamk_gemm.num_agpr, 168
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
    .vgpr_count:     424
    .agpr_count:     168
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 139
    wave.regalloc.agpr.dwords: 546
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
