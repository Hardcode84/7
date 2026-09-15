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
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s4, s4, 6
		v_readfirstlane_b32 s5, v0
		s_lshl_b32 s12, s4, 15
		s_lshr_b32 s15, s14, 4
		s_lshl_b32 s28, s15, 21
		s_add_i32 s29, s12, s28
		s_lshl_b32 s14, s14, 3
		s_add_i32 s13, s13, s14
		s_and_b32 s13, s13, 0x7f
		s_and_b32 s14, s13, 3
		s_lshl_b32 s30, s14, 19
		s_add_i32 s29, s29, s30
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 11, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v3, 4, v3
		s_add_i32 s31, s12, 0x20000
		s_add_i32 s31, s31, s28
		s_add_i32 s31, s31, s30
		s_add_i32 s32, s12, 0x40000
		s_add_i32 s32, s32, s28
		s_add_i32 s32, s32, s30
		s_add_i32 s33, s12, 0x60000
		s_add_i32 s33, s33, s28
		s_add_i32 s33, s33, s30
		s_add_i32 s34, s12, 64
		s_add_i32 s34, s34, s28
		s_add_i32 s34, s34, s30
		s_add_i32 s35, s12, 0x20040
		s_add_i32 s35, s35, s28
		s_add_i32 s35, s35, s30
		s_add_i32 s36, s12, 0x40040
		s_add_i32 s36, s36, s28
		s_add_i32 s36, s36, s30
		s_add_i32 s37, s12, 0x60040
		s_add_i32 s37, s37, s28
		s_add_i32 s37, s37, s30
		s_add_i32 s38, s12, 0x80
		s_add_i32 s38, s38, s28
		s_add_i32 s38, s38, s30
		s_add_i32 s39, s12, 0x20080
		s_add_i32 s39, s39, s28
		s_add_i32 s39, s39, s30
		s_add_i32 s40, s12, 0x40080
		s_add_i32 s40, s40, s28
		s_add_i32 s40, s40, s30
		s_add_i32 s41, s12, 0x60080
		s_add_i32 s41, s41, s28
		s_add_i32 s41, s41, s30
		s_add_i32 s42, s12, 0xc0
		s_add_i32 s42, s42, s28
		s_add_i32 s42, s42, s30
		s_add_i32 s43, s12, 0x200c0
		s_add_i32 s43, s43, s28
		s_add_i32 s43, s43, s30
		s_add_i32 s44, s12, 0x400c0
		s_add_i32 s44, s44, s28
		s_add_i32 s44, s44, s30
		s_add_i32 s12, s12, 0x600c0
		s_add_i32 s12, s12, s28
		s_add_i32 s12, s12, s30
		s_lshr_b32 s5, s5, 6
		s_lshl_b32 s5, s5, 10
		s_mov_b32 m0, s5
		v_add3_u32 v4, s29, v2, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v5, s31, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v6, s32, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v7, s33, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v8, s34, v2, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_add3_u32 v9, s35, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v10, s36, v2, v3
		v_and_b32_e32 v0, 15, v0
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_add3_u32 v11, s37, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, s38, v2, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_add3_u32 v13, s39, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v14, s40, v2, v3
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_add3_u32 v15, s41, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, s42, v2, v3
		v_add3_u32 v17, s43, v2, v3
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		v_add3_u32 v18, s12, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v19, 15, v1
		v_accvgpr_write_b32 a0, v19
		v_lshrrev_b32_e32 v19, 4, v1
		v_accvgpr_read_b32 v20, a0
		v_lshlrev_b32_e32 v20, 4, v20
		v_and_b32_e32 v21, 1, v19
		v_lshlrev_b32_e32 v21, 12, v21
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_lshrrev_b32_e32 v22, 5, v1
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v22, 8, v22
		v_lshlrev_b32_e32 v23, 6, v0
		v_accvgpr_write_b32 a1, v23
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_lshrrev_b32_e32 v0, 1, v0
		s_add_i32 m0, m0, 0x1000
		v_bitop3_b32 v0, v19, v0, 3 bitop3:0x78
		v_accvgpr_write_b32 a2, v0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		v_mov_b64_e32 v[24:25], 0
		v_mov_b64_e32 v[26:27], 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s30, 0x2000000
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_mov_b32 s8, 0x100
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s9, 0x7000
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		s_mov_b32 s10, 0x6000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s11, 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_mov_b32 s12, 0x1000
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v0, s44, v2, v3
		buffer_load_dwordx4 v0, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v2, 2, v1
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v3, v22, v21, v20
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		v_accvgpr_read_b32 v21, a2
		v_accvgpr_read_b32 v22, a1
		v_lshl_add_u32 v21, v21, 4, v22
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		buffer_load_dwordx4 v4, s[16:19], s8 offen lds
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		buffer_load_dwordx4 v5, s[16:19], s8 offen lds
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		buffer_load_dwordx4 v6, s[16:19], s8 offen lds
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		buffer_load_dwordx4 v7, s[16:19], s8 offen lds
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		buffer_load_dwordx4 v8, s[16:19], s8 offen lds
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		buffer_load_dwordx4 v9, s[16:19], s8 offen lds
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		buffer_load_dwordx4 v10, s[16:19], s8 offen lds
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		buffer_load_dwordx4 v11, s[16:19], s8 offen lds
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		buffer_load_dwordx4 v12, s[16:19], s8 offen lds
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s28, s4, 10
		buffer_load_dwordx4 v13, s[16:19], s8 offen lds
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		buffer_load_dwordx4 v14, s[16:19], s8 offen lds
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s28, s28, 0x20000
		buffer_load_dwordx4 v15, s[16:19], s8 offen lds
		s_lshl_b32 s29, s4, 17
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s31, s4, 13
		buffer_load_dwordx4 v16, s[16:19], s8 offen lds
		s_lshr_b32 s13, s13, 2
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s32, s14, 15
		buffer_load_dwordx4 v17, s[16:19], s8 offen lds
		s_lshl_b32 s33, s15, 17
		s_add_i32 m0, m0, 0x1000
		s_lshr_b32 s34, s4, 1
		buffer_load_dwordx4 v0, s[16:19], s8 offen lds
		s_lshl_b32 s35, s4, 2
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v22, s35, v19
		v_and_b32_e32 v22, 7, v22
		buffer_load_dwordx4 v18, s[16:19], s8 offen lds
		v_lshl_add_u32 v20, v22, 12, v20
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s8, s34, 8
		s_add_i32 s34, s8, s33
		s_add_i32 s34, s34, s32
		buffer_load_dwordx4 v20, s[20:23], s34 offen lds
		v_add_u32_e32 v22, s34, v20
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s34, s13, 15
		s_add_i32 s35, s31, s34
		buffer_load_dwordx4 v3, s[24:27], s35 offen lds
		v_add_u32_e32 v22, 0x400, v22
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s8, s8, 0x200
		s_add_i32 s8, s8, s33
		s_add_i32 s8, s8, s32
		buffer_load_dwordx4 v20, s[20:23], s8 offen lds
		s_add_i32 s8, s31, 0x200
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s8, s8, s34
		s_lshl_b32 s31, s13, 19
		s_add_i32 s32, s29, s31
		buffer_load_dwordx4 v3, s[24:27], s8 offen lds
		v_lshl_add_u32 v20, v1, 4, s32
		v_lshl_add_u32 v23, v1, 4, s31
		v_add_u32_e32 v23, s29, v23
		v_add_u32_e32 v112, 0x8000, v23
		v_add_u32_e32 v113, 0x10000, v23
		v_add_u32_e32 v23, 0x18000, v23
		buffer_load_dwordx4 v[116:119], v20, s[0:3], 0 offen
		buffer_load_dwordx4 v[120:123], v112, s[0:3], 0 offen
		buffer_load_dwordx4 v[124:127], v113, s[0:3], 0 offen
		buffer_load_dwordx4 v[128:131], v23, s[0:3], 0 offen
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshl_add_u32 v114, v1, 4, s31
		v_add_u32_e32 v114, s29, v114
		v_add_u32_e32 v115, 0x400, v114
		v_add_u32_e32 v132, 0x8400, v114
		v_add_u32_e32 v114, 0x10400, v114
		v_lshl_add_u32 v133, v1, 4, s31
		v_add_u32_e32 v133, s29, v133
		v_add_u32_e32 v134, 0x18400, v133
		v_add_u32_e32 v135, 0x800, v133
		v_add_u32_e32 v133, 0x8800, v133
		v_lshl_add_u32 v136, v1, 4, s31
		v_add_u32_e32 v136, s29, v136
		v_add_u32_e32 v137, 0x10800, v136
		v_add_u32_e32 v138, 0x18800, v136
		v_add_u32_e32 v136, 0xc00, v136
		v_lshl_add_u32 v1, v1, 4, s31
		v_add_u32_e32 v1, s29, v1
		v_add_u32_e32 v139, 0x8c00, v1
		v_add_u32_e32 v140, 0x10c00, v1
		v_add_u32_e32 v1, 0x18c00, v1
		v_add_u32_e32 v3, s35, v3
		v_add_u32_e32 v3, 0x400, v3
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
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		v_accvgpr_write_b32 a8, 0
		v_accvgpr_write_b32 a9, 0
		v_accvgpr_write_b32 a10, 0
		v_accvgpr_write_b32 a11, 0
		v_accvgpr_write_b32 a12, 0
		v_accvgpr_write_b32 a13, 0
		v_accvgpr_write_b32 a14, 0
		v_accvgpr_write_b32 a15, 0
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
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
		v_mov_b32_e32 v141, v21
		s_mov_b32 s8, s11
		s_mov_b32 s29, s5
		s_mov_b32 s31, s11
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s32, s11, 12
		ds_read_b128 a[88:91], v141
		ds_read_b128 a[92:95], v141 offset:1024
		ds_read_b128 a[96:99], v141 offset:2048
		ds_read_b128 a[100:103], v141 offset:3072
		ds_read_b128 a[104:107], v141 offset:4096
		ds_read_b128 a[108:111], v141 offset:5120
		ds_read_b128 a[112:115], v141 offset:6144
		ds_read_b128 a[116:119], v141 offset:7168
		ds_read_b128 a[120:123], v141 offset:8192
		ds_read_b128 a[124:127], v141 offset:9216
		ds_read_b128 a[128:131], v141 offset:10240
		ds_read_b128 a[132:135], v141 offset:11264
		ds_read_b128 a[136:139], v141 offset:12288
		ds_read_b128 a[140:143], v141 offset:13312
		ds_read_b128 a[144:147], v141 offset:14336
		ds_read_b128 a[148:151], v141 offset:15360
		s_add_i32 s33, s8, 0x20000
		v_add_u32_e32 v142, s33, v2
		ds_read2st64_b32 v[228:229], v142 offset1:1
		ds_read2st64_b32 v[230:231], v142 offset0:2 offset1:3
		ds_read2st64_b32 v[232:233], v142 offset0:4 offset1:5
		ds_read2st64_b32 v[234:235], v142 offset0:6 offset1:7
		s_add_i32 s33, s28, s8
		v_add_u32_e32 v143, s33, v2
		ds_read2st64_b32 v[236:237], v143 offset0:16 offset1:17
		ds_read_b128 a[152:155], v141 offset:16384
		ds_read_b128 a[156:159], v141 offset:17408
		ds_read_b128 a[160:163], v141 offset:18432
		ds_read_b128 a[164:167], v141 offset:19456
		ds_read_b128 a[168:171], v141 offset:20480
		ds_read_b128 a[172:175], v141 offset:21504
		ds_read_b128 a[176:179], v141 offset:22528
		ds_read_b128 a[180:183], v141 offset:23552
		ds_read_b128 a[184:187], v141 offset:24576
		ds_read_b128 a[188:191], v141 offset:25600
		ds_read_b128 a[192:195], v141 offset:26624
		ds_read_b128 a[196:199], v141 offset:27648
		ds_read_b128 a[200:203], v141 offset:28672
		ds_read_b128 a[204:207], v141 offset:29696
		ds_read_b128 a[208:211], v141 offset:30720
		ds_read_b128 a[212:215], v141 offset:31744
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[88:91], v[116:119], v[24:27], v228, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s33, s31, 0x2000
		s_add_i32 s34, s29, 0x10000
		s_add_i32 s8, s8, 0x2000
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], v[120:123], v[108:111], v228, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s8, s8, 0x3fff
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], v[120:123], v[92:95], v228, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], v[116:119], v[96:99], v228, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], v[124:127], v[88:91], v228, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[88:91], v[124:127], v[104:107], v228, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], v[128:131], v[100:103], v228, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v115, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], v[128:131], v[84:87], v228, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v132, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[96:99], v[128:131], v[68:71], v229, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], v[124:127], v[72:75], v229, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[100:103], v[124:127], v[56:59], v229, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[100:103], v[128:131], v[52:55], v229, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[100:103], v[116:119], v[64:67], v229, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], v[116:119], v[80:83], v229, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[96:99], v[120:123], v[76:79], v229, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v114, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[100:103], v[120:123], v[60:63], v229, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v134, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[104:107], v[120:123], v[44:47], v230, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[104:107], v[116:119], v[48:51], v230, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[108:111], v[116:119], v[32:35], v230, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[108:111], v[120:123], v[28:31], v230, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[108:111], v[124:127], v[144:147], v230, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[104:107], v[124:127], v[40:43], v230, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[104:107], v[128:131], v[36:39], v230, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[108:111], v[128:131], v[148:151], v230, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[112:115], v[128:131], v[164:167], v231, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[112:115], v[124:127], v[160:163], v231, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[116:119], v[124:127], v[176:179], v231, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[116:119], v[128:131], v[180:183], v231, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[116:119], v[116:119], v[168:171], v231, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[112:115], v[116:119], v[152:155], v231, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[112:115], v[120:123], v[156:159], v231, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[116:119], v[120:123], v[172:175], v231, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[120:123], v[120:123], v[188:191], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[120:123], v[116:119], v[184:187], v232, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[124:127], v[116:119], v[200:203], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[124:127], v[120:123], v[204:207], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[124:127], v[124:127], v[208:211], v232, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[120:123], v[124:127], v[192:195], v232, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[120:123], v[128:131], v[196:199], v232, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[124:127], v[128:131], v[212:215], v232, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[128:131], v[128:131], a[4:7], v233, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[128:131], v[124:127], v[224:227], v233, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[132:135], v[124:127], a[16:19], v233, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[132:135], v[128:131], a[20:23], v233, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[116:119], a[8:11], v233, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[128:131], v[116:119], v[216:219], v233, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[128:131], v[120:123], v[220:223], v233, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[132:135], v[120:123], a[12:15], v233, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[136:139], v[120:123], a[28:31], v234, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[116:119], a[24:27], v234, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[116:119], a[40:43], v234, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[140:143], v[120:123], a[44:47], v234, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[140:143], v[124:127], a[48:51], v234, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[136:139], v[124:127], a[32:35], v234, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[136:139], v[128:131], a[36:39], v234, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[140:143], v[128:131], a[52:55], v234, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[144:147], v[128:131], a[68:71], v235, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[144:147], v[124:127], a[64:67], v235, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[148:151], v[124:127], a[80:83], v235, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[148:151], v[128:131], a[84:87], v235, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[116:119], a[72:75], v235, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[116:119], a[56:59], v235, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[144:147], v[120:123], a[60:63], v235, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[148:151], v[120:123], a[76:79], v235, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 m0, s29
		s_lshl_b32 s29, s11, 8
		s_add_i32 s35, s29, 0x200
		buffer_load_dwordx4 v4, s[16:19], s35 offen lds
		ds_read_b128 a[88:91], v141 offset:32768
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s29, s34, 0x1ffff
		s_and_b32 s33, s33, 0x3fff
		s_add_i32 s11, s11, 1
		buffer_load_dwordx4 v5, s[16:19], s35 offen lds
		ds_read_b128 a[92:95], v141 offset:33792
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s31, s5, s31
		buffer_load_dwordx4 v6, s[16:19], s35 offen lds
		ds_read_b128 a[96:99], v141 offset:34816
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s34, s12, s32
		buffer_load_dwordx4 v7, s[16:19], s35 offen lds
		ds_read_b128 a[100:103], v141 offset:35840
		ds_read_b128 a[104:107], v141 offset:36864
		ds_read_b128 a[108:111], v141 offset:37888
		ds_read_b128 a[112:115], v141 offset:38912
		ds_read_b128 a[116:119], v141 offset:39936
		ds_read_b128 a[120:123], v141 offset:40960
		ds_read_b128 a[124:127], v141 offset:41984
		ds_read_b128 a[128:131], v141 offset:43008
		ds_read_b128 a[132:135], v141 offset:44032
		ds_read_b128 a[136:139], v141 offset:45056
		ds_read_b128 a[140:143], v141 offset:46080
		ds_read_b128 a[144:147], v141 offset:47104
		ds_read_b128 a[148:151], v141 offset:48128
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[152:155], v[240:243], v[24:27], v228, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[152:155], v[244:247], v[108:111], v228, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[156:159], v[244:247], v[92:95], v228, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[156:159], v[240:243], v[96:99], v228, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[156:159], v[248:251], v[88:91], v228, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[152:155], v[248:251], v[104:107], v228, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[152:155], v[252:255], v[100:103], v228, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[116:119], v135, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[156:159], v[252:255], v[84:87], v228, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[120:123], v133, s[0:3], s32 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[160:163], v[252:255], v[68:71], v229, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[160:163], v[248:251], v[72:75], v229, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[164:167], v[248:251], v[56:59], v229, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[164:167], v[252:255], v[52:55], v229, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[164:167], v[240:243], v[64:67], v229, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[160:163], v[240:243], v[80:83], v229, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[160:163], v[244:247], v[76:79], v229, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[124:127], v137, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[164:167], v[244:247], v[60:63], v229, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[128:131], v138, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[168:171], v[244:247], v[44:47], v230, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[168:171], v[240:243], v[48:51], v230, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[172:175], v[240:243], v[32:35], v230, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[172:175], v[244:247], v[28:31], v230, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[172:175], v[248:251], v[144:147], v230, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[168:171], v[248:251], v[40:43], v230, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[168:171], v[252:255], v[36:39], v230, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[172:175], v[252:255], v[148:151], v230, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[176:179], v[252:255], v[164:167], v231, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[176:179], v[248:251], v[160:163], v231, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[180:183], v[248:251], v[176:179], v231, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[180:183], v[252:255], v[180:183], v231, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[180:183], v[240:243], v[168:171], v231, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[176:179], v[240:243], v[152:155], v231, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[176:179], v[244:247], v[156:159], v231, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[180:183], v[244:247], v[172:175], v231, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[184:187], v[244:247], v[188:191], v232, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[184:187], v[240:243], v[184:187], v232, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[188:191], v[240:243], v[200:203], v232, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[188:191], v[244:247], v[204:207], v232, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[188:191], v[248:251], v[208:211], v232, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[184:187], v[248:251], v[192:195], v232, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[184:187], v[252:255], v[196:199], v232, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[188:191], v[252:255], v[212:215], v232, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[192:195], v[252:255], a[4:7], v233, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[192:195], v[248:251], v[224:227], v233, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[196:199], v[248:251], a[16:19], v233, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[196:199], v[252:255], a[20:23], v233, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[196:199], v[240:243], a[8:11], v233, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[192:195], v[240:243], v[216:219], v233, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[192:195], v[244:247], v[220:223], v233, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[196:199], v[244:247], a[12:15], v233, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[200:203], v[244:247], a[28:31], v234, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[200:203], v[240:243], a[24:27], v234, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[204:207], v[240:243], a[40:43], v234, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[204:207], v[244:247], a[44:47], v234, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[204:207], v[248:251], a[48:51], v234, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[200:203], v[248:251], a[32:35], v234, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[200:203], v[252:255], a[36:39], v234, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[204:207], v[252:255], a[52:55], v234, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[208:211], v[252:255], a[68:71], v235, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[208:211], v[248:251], a[64:67], v235, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[212:215], v[248:251], a[80:83], v235, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[212:215], v[252:255], a[84:87], v235, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[212:215], v[240:243], a[72:75], v235, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[208:211], v[240:243], a[56:59], v235, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[208:211], v[244:247], a[60:63], v235, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[212:215], v[244:247], a[76:79], v235, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		ds_read2st64_b32 v[228:229], v142 offset0:8 offset1:9
		buffer_load_dwordx4 v8, s[16:19], s35 offen lds
		ds_read2st64_b32 v[230:231], v142 offset0:10 offset1:11
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v232, 0x10000, v141
		buffer_load_dwordx4 v9, s[16:19], s35 offen lds
		ds_read2st64_b32 v[234:235], v142 offset0:12 offset1:13
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v10, s[16:19], s35 offen lds
		ds_read2st64_b32 v[236:237], v142 offset0:14 offset1:15
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], s35 offen lds
		ds_read2st64_b32 v[238:239], v143 offset0:18 offset1:19
		ds_read_b128 a[152:155], v141 offset:49152
		ds_read_b128 a[156:159], v141 offset:50176
		ds_read_b128 a[160:163], v141 offset:51200
		ds_read_b128 a[164:167], v141 offset:52224
		ds_read_b128 a[168:171], v141 offset:53248
		ds_read_b128 a[172:175], v141 offset:54272
		ds_read_b128 a[176:179], v141 offset:55296
		ds_read_b128 a[180:183], v141 offset:56320
		ds_read_b128 a[184:187], v141 offset:57344
		ds_read_b128 a[188:191], v141 offset:58368
		ds_read_b128 a[192:195], v141 offset:59392
		ds_read_b128 a[196:199], v141 offset:60416
		ds_read_b128 a[200:203], v141 offset:61440
		ds_read_b128 a[204:207], v141 offset:62464
		ds_read_b128 a[208:211], v141 offset:63488
		ds_read_b128 a[212:215], v141 offset:64512
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[88:91], v[116:119], v[24:27], v228, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v141, 0x1ffff, v232
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[88:91], v[120:123], v[108:111], v228, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], v[120:123], v[92:95], v228, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], v[116:119], v[96:99], v228, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], v[124:127], v[88:91], v228, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[88:91], v[124:127], v[104:107], v228, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[88:91], v[128:131], v[100:103], v228, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v136, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[92:95], v[128:131], v[84:87], v228, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v139, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[96:99], v[128:131], v[68:71], v229, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], v[124:127], v[72:75], v229, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[100:103], v[124:127], v[56:59], v229, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[100:103], v[128:131], v[52:55], v229, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[100:103], v[116:119], v[64:67], v229, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], v[116:119], v[80:83], v229, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[96:99], v[120:123], v[76:79], v229, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v140, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[100:103], v[120:123], v[60:63], v229, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v1, s[0:3], s32 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[104:107], v[120:123], v[44:47], v230, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[104:107], v[116:119], v[48:51], v230, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[108:111], v[116:119], v[32:35], v230, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[108:111], v[120:123], v[28:31], v230, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[108:111], v[124:127], v[144:147], v230, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[104:107], v[124:127], v[40:43], v230, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[104:107], v[128:131], v[36:39], v230, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[108:111], v[128:131], v[148:151], v230, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[112:115], v[128:131], v[164:167], v231, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[112:115], v[124:127], v[160:163], v231, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[116:119], v[124:127], v[176:179], v231, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[116:119], v[128:131], v[180:183], v231, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[116:119], v[116:119], v[168:171], v231, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[112:115], v[116:119], v[152:155], v231, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[112:115], v[120:123], v[156:159], v231, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[116:119], v[120:123], v[172:175], v231, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[120:123], v[120:123], v[188:191], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[120:123], v[116:119], v[184:187], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[124:127], v[116:119], v[200:203], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[124:127], v[120:123], v[204:207], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[124:127], v[124:127], v[208:211], v234, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[120:123], v[124:127], v[192:195], v234, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[120:123], v[128:131], v[196:199], v234, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[124:127], v[128:131], v[212:215], v234, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[128:131], v[128:131], a[4:7], v235, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[128:131], v[124:127], v[224:227], v235, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[132:135], v[124:127], a[16:19], v235, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[132:135], v[128:131], a[20:23], v235, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[116:119], a[8:11], v235, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[128:131], v[116:119], v[216:219], v235, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[128:131], v[120:123], v[220:223], v235, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[132:135], v[120:123], a[12:15], v235, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[136:139], v[120:123], a[28:31], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[116:119], a[24:27], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[116:119], a[40:43], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[140:143], v[120:123], a[44:47], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[140:143], v[124:127], a[48:51], v236, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[136:139], v[124:127], a[32:35], v236, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[136:139], v[128:131], a[36:39], v236, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[140:143], v[128:131], a[52:55], v236, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[144:147], v[128:131], a[68:71], v237, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[144:147], v[124:127], a[64:67], v237, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[148:151], v[124:127], a[80:83], v237, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[148:151], v[128:131], a[84:87], v237, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[116:119], a[72:75], v237, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[116:119], a[56:59], v237, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[144:147], v[120:123], a[60:63], v237, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[148:151], v[120:123], a[76:79], v237, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[116:119], v20, s[0:3], s34 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[152:155], v[240:243], v[24:27], v228, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[120:123], v112, s[0:3], s34 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[152:155], v[244:247], v[108:111], v228, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[124:127], v113, s[0:3], s34 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[156:159], v[244:247], v[92:95], v228, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[128:131], v23, s[0:3], s34 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[156:159], v[240:243], v[96:99], v228, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[156:159], v[248:251], v[88:91], v228, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[152:155], v[248:251], v[104:107], v228, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[152:155], v[252:255], v[100:103], v228, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[156:159], v[252:255], v[84:87], v228, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[160:163], v[252:255], v[68:71], v229, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[160:163], v[248:251], v[72:75], v229, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[164:167], v[248:251], v[56:59], v229, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[164:167], v[252:255], v[52:55], v229, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[164:167], v[240:243], v[64:67], v229, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[160:163], v[240:243], v[80:83], v229, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[160:163], v[244:247], v[76:79], v229, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[164:167], v[244:247], v[60:63], v229, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[168:171], v[244:247], v[44:47], v230, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[168:171], v[240:243], v[48:51], v230, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[172:175], v[240:243], v[32:35], v230, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[172:175], v[244:247], v[28:31], v230, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[172:175], v[248:251], v[144:147], v230, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[168:171], v[248:251], v[40:43], v230, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[168:171], v[252:255], v[36:39], v230, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[172:175], v[252:255], v[148:151], v230, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[176:179], v[252:255], v[164:167], v231, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[176:179], v[248:251], v[160:163], v231, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[180:183], v[248:251], v[176:179], v231, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[180:183], v[252:255], v[180:183], v231, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[180:183], v[240:243], v[168:171], v231, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[176:179], v[240:243], v[152:155], v231, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[176:179], v[244:247], v[156:159], v231, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[180:183], v[244:247], v[172:175], v231, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[184:187], v[244:247], v[188:191], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[184:187], v[240:243], v[184:187], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[188:191], v[240:243], v[200:203], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[188:191], v[244:247], v[204:207], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[188:191], v[248:251], v[208:211], v234, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[184:187], v[248:251], v[192:195], v234, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[184:187], v[252:255], v[196:199], v234, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[188:191], v[252:255], v[212:215], v234, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[192:195], v[252:255], a[4:7], v235, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[192:195], v[248:251], v[224:227], v235, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[196:199], v[248:251], a[16:19], v235, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[196:199], v[252:255], a[20:23], v235, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[196:199], v[240:243], a[8:11], v235, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[192:195], v[240:243], v[216:219], v235, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[192:195], v[244:247], v[220:223], v235, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[196:199], v[244:247], a[12:15], v235, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[200:203], v[244:247], a[28:31], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[200:203], v[240:243], a[24:27], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[204:207], v[240:243], a[40:43], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[204:207], v[244:247], a[44:47], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[204:207], v[248:251], a[48:51], v236, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[200:203], v[248:251], a[32:35], v236, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[200:203], v[252:255], a[36:39], v236, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[204:207], v[252:255], a[52:55], v236, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[208:211], v[252:255], a[68:71], v237, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[208:211], v[248:251], a[64:67], v237, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[212:215], v[248:251], a[80:83], v237, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[212:215], v[252:255], a[84:87], v237, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[212:215], v[240:243], a[72:75], v237, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[208:211], v[240:243], a[56:59], v237, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[208:211], v[244:247], a[60:63], v237, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[212:215], v[244:247], a[76:79], v237, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, s31, 0x20000
		s_nop 0
		buffer_load_dwordx4 v22, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s20, s20, 0x200
		s_addc_u32 s21, s21, 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x200
		s_addc_u32 s25, s25, 0
		s_cmp_lt_i32 s11, 6
		s_mov_b32 s31, s33
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		ds_read_b128 v[4:7], v21
		ds_read_b128 v[8:11], v21 offset:1024
		ds_read_b128 v[12:15], v21 offset:2048
		ds_read_b128 v[228:231], v21 offset:3072
		ds_read_b128 v[232:235], v21 offset:4096
		ds_read_b128 v[236:239], v21 offset:5120
		ds_read_b128 v[240:243], v21 offset:6144
		ds_read_b128 a[88:91], v21 offset:7168
		ds_read_b128 a[92:95], v21 offset:8192
		ds_read_b128 a[96:99], v21 offset:9216
		ds_read_b128 a[100:103], v21 offset:10240
		ds_read_b128 a[104:107], v21 offset:11264
		ds_read_b128 a[108:111], v21 offset:12288
		ds_read_b128 a[112:115], v21 offset:13312
		ds_read_b128 a[116:119], v21 offset:14336
		ds_read_b128 a[120:123], v21 offset:15360
		v_add_u32_e32 v0, 0x20000, v2
		ds_read2st64_b32 v[16:17], v0 offset1:1
		ds_read2st64_b32 v[142:143], v0 offset0:2 offset1:3
		ds_read2st64_b32 v[244:245], v0 offset0:4 offset1:5
		ds_read2st64_b32 v[246:247], v0 offset0:6 offset1:7
		v_add_u32_e32 v2, s28, v2
		ds_read2st64_b32 v[248:249], v2 offset0:16 offset1:17
		ds_read_b128 a[124:127], v21 offset:16384
		ds_read_b128 a[128:131], v21 offset:17408
		ds_read_b128 a[132:135], v21 offset:18432
		ds_read_b128 a[136:139], v21 offset:19456
		ds_read_b128 a[140:143], v21 offset:20480
		ds_read_b128 a[144:147], v21 offset:21504
		ds_read_b128 a[148:151], v21 offset:22528
		ds_read_b128 a[152:155], v21 offset:23552
		ds_read_b128 a[156:159], v21 offset:24576
		ds_read_b128 a[160:163], v21 offset:25600
		ds_read_b128 a[164:167], v21 offset:26624
		ds_read_b128 a[168:171], v21 offset:27648
		ds_read_b128 a[172:175], v21 offset:28672
		ds_read_b128 a[176:179], v21 offset:29696
		ds_read_b128 a[180:183], v21 offset:30720
		ds_read_b128 v[252:255], v21 offset:31744
		s_waitcnt vmcnt(9) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[4:7], v[116:119], v[24:27], v16, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[4:7], v[120:123], v[108:111], v16, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[8:11], v[120:123], v[92:95], v16, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[8:11], v[116:119], v[96:99], v16, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[8:11], v[124:127], v[88:91], v16, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[4:7], v[124:127], v[104:107], v16, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[4:7], v[128:131], v[100:103], v16, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v115, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[8:11], v[128:131], v[84:87], v16, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[8:11], v132, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[128:131], v[68:71], v17, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[124:127], v[72:75], v17, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[228:231], v[124:127], v[56:59], v17, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[228:231], v[128:131], v[52:55], v17, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[228:231], v[116:119], v[64:67], v17, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[116:119], v[80:83], v17, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], v[120:123], v[76:79], v17, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[12:15], v114, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[228:231], v[120:123], v[60:63], v17, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[228:231], v134, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[232:235], v[120:123], v[44:47], v142, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[232:235], v[116:119], v[48:51], v142, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[236:239], v[116:119], v[32:35], v142, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[236:239], v[120:123], v[28:31], v142, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[236:239], v[124:127], v[144:147], v142, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[232:235], v[124:127], v[40:43], v142, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[232:235], v[128:131], v[36:39], v142, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[236:239], v[128:131], v[148:151], v142, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[240:243], v[128:131], v[164:167], v143, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[240:243], v[124:127], v[160:163], v143, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[88:91], v[124:127], v[176:179], v143, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[88:91], v[128:131], v[180:183], v143, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[88:91], v[116:119], v[168:171], v143, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[240:243], v[116:119], v[152:155], v143, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[240:243], v[120:123], v[156:159], v143, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[88:91], v[120:123], v[172:175], v143, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], v[120:123], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], v[116:119], v[184:187], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], v[116:119], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[96:99], v[120:123], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], v[124:127], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], v[124:127], v[192:195], v244, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], v[128:131], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], v[128:131], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[100:103], v[128:131], a[4:7], v245, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[100:103], v[124:127], v[224:227], v245, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[104:107], v[124:127], a[16:19], v245, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[104:107], v[128:131], a[20:23], v245, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[104:107], v[116:119], a[8:11], v245, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[100:103], v[116:119], v[216:219], v245, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[100:103], v[120:123], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[104:107], v[120:123], a[12:15], v245, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[108:111], v[120:123], a[28:31], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[108:111], v[116:119], a[24:27], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[112:115], v[116:119], a[40:43], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[112:115], v[120:123], a[44:47], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[112:115], v[124:127], a[48:51], v246, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[108:111], v[124:127], a[32:35], v246, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[108:111], v[128:131], a[36:39], v246, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[112:115], v[128:131], a[52:55], v246, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[116:119], v[128:131], a[68:71], v247, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[116:119], v[124:127], a[64:67], v247, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[120:123], v[124:127], a[80:83], v247, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[120:123], v[128:131], a[84:87], v247, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[120:123], v[116:119], a[72:75], v247, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[116:119], v[116:119], a[56:59], v247, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[116:119], v[120:123], a[60:63], v247, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[120:123], v[120:123], a[76:79], v247, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[116:119], v21 offset:32768
		ds_read_b128 v[120:123], v21 offset:33792
		ds_read_b128 v[124:127], v21 offset:34816
		ds_read_b128 a[88:91], v21 offset:35840
		ds_read_b128 a[92:95], v21 offset:36864
		ds_read_b128 a[96:99], v21 offset:37888
		ds_read_b128 a[100:103], v21 offset:38912
		ds_read_b128 a[104:107], v21 offset:39936
		ds_read_b128 a[108:111], v21 offset:40960
		ds_read_b128 a[112:115], v21 offset:41984
		ds_read_b128 a[116:119], v21 offset:43008
		ds_read_b128 a[120:123], v21 offset:44032
		ds_read_b128 a[184:187], v21 offset:45056
		ds_read_b128 a[188:191], v21 offset:46080
		ds_read_b128 a[192:195], v21 offset:47104
		ds_read_b128 a[196:199], v21 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[124:127], v[4:7], v[24:27], v16, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[124:127], v[8:11], v[108:111], v16, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[128:131], v[8:11], v[92:95], v16, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[128:131], v[4:7], v[96:99], v16, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[128:131], v[12:15], v[88:91], v16, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[124:127], v[12:15], v[104:107], v16, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[124:127], v[228:231], v[100:103], v16, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[128:131], v135, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[128:131], v[228:231], v[84:87], v16, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[232:235], v133, s[0:3], s10 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[132:135], v[228:231], v[68:71], v17, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[132:135], v[12:15], v[72:75], v17, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[136:139], v[12:15], v[56:59], v17, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[136:139], v[228:231], v[52:55], v17, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[136:139], v[4:7], v[64:67], v17, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[132:135], v[4:7], v[80:83], v17, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[132:135], v[8:11], v[76:79], v17, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[236:239], v137, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[136:139], v[8:11], v[60:63], v17, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v138, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[140:143], v[8:11], v[44:47], v142, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[140:143], v[4:7], v[48:51], v142, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[144:147], v[4:7], v[32:35], v142, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[144:147], v[8:11], v[28:31], v142, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[144:147], v[12:15], v[144:147], v142, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[140:143], v[12:15], v[40:43], v142, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[140:143], v[228:231], v[36:39], v142, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[144:147], v[228:231], v[148:151], v142, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[228:231], v[164:167], v143, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[12:15], v[160:163], v143, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[12:15], v[176:179], v143, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[228:231], v[180:183], v143, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[4:7], v[168:171], v143, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[148:151], v[4:7], v[152:155], v143, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[148:151], v[8:11], v[156:159], v143, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[8:11], v[172:175], v143, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[8:11], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[4:7], v[184:187], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[4:7], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[8:11], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[12:15], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[12:15], v[192:195], v244, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[228:231], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[228:231], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[228:231], a[4:7], v245, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[164:167], v[12:15], v[224:227], v245, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[12:15], a[16:19], v245, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[228:231], a[20:23], v245, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[168:171], v[4:7], a[8:11], v245, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[4:7], v[216:219], v245, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[8:11], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[8:11], a[12:15], v245, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[8:11], a[28:31], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[172:175], v[4:7], a[24:27], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[176:179], v[4:7], a[40:43], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[8:11], a[44:47], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[12:15], a[48:51], v246, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[12:15], a[32:35], v246, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[228:231], a[36:39], v246, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[228:231], a[52:55], v246, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[228:231], a[68:71], v247, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[12:15], a[64:67], v247, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[12:15], a[80:83], v247, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[228:231], a[84:87], v247, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[252:255], v[4:7], a[72:75], v247, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[180:183], v[4:7], a[56:59], v247, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[8:11], a[60:63], v247, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[8:11], a[76:79], v247, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read2st64_b32 v[4:5], v0 offset0:8 offset1:9
		ds_read2st64_b32 v[6:7], v0 offset0:10 offset1:11
		ds_read2st64_b32 v[8:9], v0 offset0:12 offset1:13
		ds_read2st64_b32 v[10:11], v0 offset0:14 offset1:15
		ds_read2st64_b32 v[12:13], v2 offset0:18 offset1:19
		ds_read_b128 a[124:127], v21 offset:49152
		ds_read_b128 a[128:131], v21 offset:50176
		ds_read_b128 a[132:135], v21 offset:51200
		ds_read_b128 a[136:139], v21 offset:52224
		ds_read_b128 a[140:143], v21 offset:53248
		ds_read_b128 a[144:147], v21 offset:54272
		ds_read_b128 a[148:151], v21 offset:55296
		ds_read_b128 a[152:155], v21 offset:56320
		ds_read_b128 a[156:159], v21 offset:57344
		ds_read_b128 a[160:163], v21 offset:58368
		ds_read_b128 a[164:167], v21 offset:59392
		ds_read_b128 a[168:171], v21 offset:60416
		ds_read_b128 a[172:175], v21 offset:61440
		ds_read_b128 a[176:179], v21 offset:62464
		ds_read_b128 a[180:183], v21 offset:63488
		ds_read_b128 a[200:203], v21 offset:64512
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[116:119], v[128:131], v[24:27], v4, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[116:119], v[232:235], v[108:111], v4, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[120:123], v[232:235], v[92:95], v4, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[120:123], v[128:131], v[96:99], v4, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[120:123], v[236:239], v[88:91], v4, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[116:119], v[236:239], v[104:107], v4, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[116:119], v[240:243], v[100:103], v4, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[116:119], v136, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[120:123], v[240:243], v[84:87], v4, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[120:123], v139, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[124:127], v[240:243], v[68:71], v5, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[124:127], v[236:239], v[72:75], v5, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[88:91], v[236:239], v[56:59], v5, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[88:91], v[240:243], v[52:55], v5, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[88:91], v[128:131], v[64:67], v5, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[124:127], v[128:131], v[80:83], v5, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[124:127], v[232:235], v[76:79], v5, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[124:127], v140, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[88:91], v[232:235], v[60:63], v5, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[228:231], v1, s[0:3], s10 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[92:95], v[232:235], v[44:47], v6, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[92:95], v[128:131], v[48:51], v6, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[96:99], v[128:131], v[32:35], v6, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[96:99], v[232:235], v[28:31], v6, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[96:99], v[236:239], v[144:147], v6, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[92:95], v[236:239], v[40:43], v6, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[92:95], v[240:243], v[36:39], v6, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v20, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[96:99], v[240:243], v[148:151], v6, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v112, s[0:3], s9 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a88, v248
		v_accvgpr_write_b32 a89, v249
		v_accvgpr_write_b32 a90, v250
		v_accvgpr_write_b32 a91, v251
		buffer_load_dwordx4 v[248:251], v113, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[100:103], v[240:243], v[164:167], v7, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[100:103], v[236:239], v[160:163], v7, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[104:107], v[236:239], v[176:179], v7, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[104:107], v[240:243], v[180:183], v7, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[104:107], v[128:131], v[168:171], v7, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[100:103], v[128:131], v[152:155], v7, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[100:103], v[232:235], v[156:159], v7, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v23, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[104:107], v[232:235], v[172:175], v7, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[20:23], v115, s[0:3], s9 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a92, v20
		v_accvgpr_write_b32 a93, v21
		v_accvgpr_write_b32 a94, v22
		v_accvgpr_write_b32 a95, v23
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[108:111], v[232:235], v[188:191], v8, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[108:111], v[128:131], v[184:187], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[112:115], v[128:131], v[200:203], v8, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[112:115], v[232:235], v[204:207], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[112:115], v[236:239], v[208:211], v8, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[108:111], v[236:239], v[192:195], v8, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[108:111], v[240:243], v[196:199], v8, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[20:23], v132, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[112:115], v[240:243], v[212:215], v8, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[116:119], v[240:243], a[4:7], v9, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[116:119], v[236:239], v[224:227], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[120:123], v[236:239], a[16:19], v9, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[120:123], v[240:243], a[20:23], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[120:123], v[128:131], a[8:11], v9, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[116:119], v[128:131], v[216:219], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[116:119], v[232:235], v[220:223], v9, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[120:123], v[232:235], a[12:15], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[184:187], v[232:235], a[28:31], v10, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[184:187], v[128:131], a[24:27], v10, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[188:191], v[128:131], a[40:43], v10, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[188:191], v[232:235], a[44:47], v10, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[188:191], v[236:239], a[48:51], v10, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[184:187], v[236:239], a[32:35], v10, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[184:187], v[240:243], a[36:39], v10, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[188:191], v[240:243], a[52:55], v10, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[192:195], v[240:243], a[68:71], v11, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[192:195], v[236:239], a[64:67], v11, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[196:199], v[236:239], a[80:83], v11, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[196:199], v[240:243], a[84:87], v11, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[196:199], v[128:131], a[72:75], v11, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[192:195], v[128:131], a[56:59], v11, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[192:195], v[232:235], a[60:63], v11, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[196:199], v[232:235], a[76:79], v11, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[124:127], v[116:119], v[24:27], v4, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[124:127], v[120:123], v[108:111], v4, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[128:131], v[120:123], v[92:95], v4, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[128:131], v[116:119], v[96:99], v4, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[128:131], v[124:127], v[88:91], v4, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[124:127], v[124:127], v[104:107], v4, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[124:127], v[228:231], v[100:103], v4, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[128:131], v[228:231], v[84:87], v4, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[132:135], v[228:231], v[68:71], v5, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[132:135], v[124:127], v[72:75], v5, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[136:139], v[124:127], v[56:59], v5, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[136:139], v[228:231], v[52:55], v5, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[136:139], v[116:119], v[64:67], v5, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[132:135], v[116:119], v[80:83], v5, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[132:135], v[120:123], v[76:79], v5, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[136:139], v[120:123], v[60:63], v5, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[140:143], v[120:123], v[44:47], v6, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[140:143], v[116:119], v[48:51], v6, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[144:147], v[116:119], v[32:35], v6, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[144:147], v[120:123], v[28:31], v6, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[144:147], v[124:127], v[144:147], v6, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[140:143], v[124:127], v[40:43], v6, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[140:143], v[228:231], v[36:39], v6, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[144:147], v[228:231], v[148:151], v6, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[228:231], v[164:167], v7, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[124:127], v[160:163], v7, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[124:127], v[176:179], v7, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[228:231], v[180:183], v7, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[116:119], v[168:171], v7, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[148:151], v[116:119], v[152:155], v7, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[148:151], v[120:123], v[156:159], v7, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[120:123], v[172:175], v7, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[120:123], v[188:191], v8, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[116:119], v[184:187], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[116:119], v[200:203], v8, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[120:123], v[204:207], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[124:127], v[208:211], v8, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[124:127], v[192:195], v8, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[228:231], v[196:199], v8, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[228:231], v[212:215], v8, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[228:231], a[4:7], v9, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[164:167], v[124:127], v[224:227], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[124:127], a[16:19], v9, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[228:231], a[20:23], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[168:171], v[116:119], a[8:11], v9, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[116:119], v[216:219], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[120:123], v[220:223], v9, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[120:123], a[12:15], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[120:123], a[28:31], v10, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[172:175], v[116:119], a[24:27], v10, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[176:179], v[116:119], a[40:43], v10, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[120:123], a[44:47], v10, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[124:127], a[48:51], v10, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[124:127], a[32:35], v10, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[228:231], a[36:39], v10, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[228:231], a[52:55], v10, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[228:231], a[68:71], v11, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[124:127], a[64:67], v11, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[200:203], v[124:127], a[80:83], v11, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[200:203], v[228:231], a[84:87], v11, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[200:203], v[116:119], a[72:75], v11, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[180:183], v[116:119], a[56:59], v11, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[120:123], a[60:63], v11, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[200:203], v[120:123], a[76:79], v11, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		v_accvgpr_read_b32 v3, a1
		v_add_u32_e32 v3, 0x10000, v3
		v_accvgpr_read_b32 v4, a2
		v_lshl_add_u32 v3, v4, 4, v3
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[8:11], v3 offset:1024
		ds_read_b128 v[12:15], v3 offset:2048
		ds_read_b128 v[116:119], v3 offset:3072
		ds_read_b128 v[120:123], v3 offset:4096
		ds_read_b128 v[124:127], v3 offset:5120
		ds_read_b128 v[128:131], v3 offset:6144
		ds_read_b128 v[228:231], v3 offset:7168
		ds_read_b128 v[232:235], v3 offset:8192
		ds_read_b128 v[236:239], v3 offset:9216
		ds_read_b128 a[96:99], v3 offset:10240
		ds_read_b128 a[100:103], v3 offset:11264
		ds_read_b128 a[104:107], v3 offset:12288
		ds_read_b128 a[108:111], v3 offset:13312
		ds_read_b128 a[112:115], v3 offset:14336
		ds_read_b128 a[116:119], v3 offset:15360
		ds_read_b32 v16, v0 offset:8192
		ds_read_b32 v17, v0 offset:8448
		ds_read_b32 v18, v0 offset:8704
		ds_read_b32 v112, v0 offset:8960
		ds_read_b32 v113, v0 offset:9216
		ds_read_b32 v115, v0 offset:9472
		ds_read_b32 v132, v0 offset:9728
		ds_read_b32 v141, v0 offset:9984
		ds_read_b32 v142, v2 offset:12288
		ds_read_b32 v143, v2 offset:12544
		ds_read_b128 a[120:123], v3 offset:16384
		ds_read_b128 a[124:127], v3 offset:17408
		ds_read_b128 a[128:131], v3 offset:18432
		ds_read_b128 a[132:135], v3 offset:19456
		ds_read_b128 a[136:139], v3 offset:20480
		ds_read_b128 a[140:143], v3 offset:21504
		ds_read_b128 a[144:147], v3 offset:22528
		ds_read_b128 a[148:151], v3 offset:23552
		ds_read_b128 a[152:155], v3 offset:24576
		ds_read_b128 a[156:159], v3 offset:25600
		ds_read_b128 a[160:163], v3 offset:26624
		ds_read_b128 a[164:167], v3 offset:27648
		ds_read_b128 a[168:171], v3 offset:28672
		ds_read_b128 a[172:175], v3 offset:29696
		ds_read_b128 a[176:179], v3 offset:30720
		ds_read_b128 a[180:183], v3 offset:31744
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[4:7], v[244:247], v[24:27], v16, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[4:7], a[88:91], v[108:111], v16, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[8:11], a[88:91], v[92:95], v16, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[8:11], v[244:247], v[96:99], v16, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[8:11], v[248:251], v[88:91], v16, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[4:7], v[248:251], v[104:107], v16, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[4:7], v[252:255], v[100:103], v16, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v114, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[8:11], v[252:255], v[84:87], v16, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[8:11], v134, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[252:255], v[68:71], v17, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[248:251], v[72:75], v17, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[116:119], v[248:251], v[56:59], v17, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[116:119], v[252:255], v[52:55], v17, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[116:119], v[244:247], v[64:67], v17, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[244:247], v[80:83], v17, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], a[88:91], v[76:79], v17, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[12:15], v135, s[0:3], s9 offen
		buffer_load_dwordx4 v[240:243], v133, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[116:119], a[88:91], v[60:63], v17, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[116:119], v137, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[120:123], a[88:91], v[44:47], v18, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[120:123], v[244:247], v[48:51], v18, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[124:127], v[244:247], v[32:35], v18, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[124:127], a[88:91], v[28:31], v18, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[124:127], v[248:251], v[144:147], v18, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[120:123], v[248:251], v[40:43], v18, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[120:123], v[252:255], v[36:39], v18, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[124:127], v[252:255], v[148:151], v18, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[128:131], v[252:255], v[164:167], v112, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[128:131], v[248:251], v[160:163], v112, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[228:231], v[248:251], v[176:179], v112, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[228:231], v[252:255], v[180:183], v112, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[228:231], v[244:247], v[168:171], v112, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[128:131], v[244:247], v[152:155], v112, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[128:131], a[88:91], v[156:159], v112, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[228:231], a[88:91], v[172:175], v112, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], a[88:91], v[188:191], v113, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[232:235], v[244:247], v[184:187], v113, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[236:239], v[244:247], v[200:203], v113, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[236:239], a[88:91], v[204:207], v113, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[236:239], v[248:251], v[208:211], v113, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[232:235], v[248:251], v[192:195], v113, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[232:235], v[252:255], v[196:199], v113, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[236:239], v[252:255], v[212:215], v113, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[96:99], v[252:255], a[4:7], v115, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], v[248:251], v[224:227], v115, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[100:103], v[248:251], a[16:19], v115, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[100:103], v[252:255], a[20:23], v115, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[100:103], v[244:247], a[8:11], v115, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], v[244:247], v[216:219], v115, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[96:99], a[88:91], v[220:223], v115, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[100:103], a[88:91], a[12:15], v115, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[104:107], a[88:91], a[28:31], v132, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[104:107], v[244:247], a[24:27], v132, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[108:111], v[244:247], a[40:43], v132, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[108:111], a[88:91], a[44:47], v132, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[108:111], v[248:251], a[48:51], v132, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[104:107], v[248:251], a[32:35], v132, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[104:107], v[252:255], a[36:39], v132, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[108:111], v[252:255], a[52:55], v132, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[112:115], v[252:255], a[68:71], v141, v143 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[112:115], v[248:251], a[64:67], v141, v143 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[116:119], v[248:251], a[80:83], v141, v143 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[116:119], v[252:255], a[84:87], v141, v143 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[116:119], v[244:247], a[72:75], v141, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[112:115], v[244:247], a[56:59], v141, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[112:115], a[88:91], a[60:63], v141, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[116:119], a[88:91], a[76:79], v141, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[120:123], v3 offset:32768
		ds_read_b128 v[124:127], v3 offset:33792
		ds_read_b128 v[128:131], v3 offset:34816
		ds_read_b128 v[228:231], v3 offset:35840
		ds_read_b128 v[232:235], v3 offset:36864
		ds_read_b128 a[88:91], v3 offset:37888
		ds_read_b128 a[96:99], v3 offset:38912
		ds_read_b128 a[100:103], v3 offset:39936
		ds_read_b128 a[104:107], v3 offset:40960
		ds_read_b128 a[108:111], v3 offset:41984
		ds_read_b128 a[112:115], v3 offset:43008
		ds_read_b128 a[116:119], v3 offset:44032
		ds_read_b128 a[184:187], v3 offset:45056
		ds_read_b128 a[188:191], v3 offset:46080
		ds_read_b128 a[192:195], v3 offset:47104
		ds_read_b128 a[196:199], v3 offset:48128
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], a[120:123], a[92:95], v[24:27], v16, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[120:123], v[20:23], v[108:111], v16, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[124:127], v[20:23], v[92:95], v16, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[124:127], a[92:95], v[96:99], v16, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[124:127], v[4:7], v[88:91], v16, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[120:123], v[4:7], v[104:107], v16, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[120:123], v[8:11], v[100:103], v16, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[236:239], v138, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[124:127], v[8:11], v[84:87], v16, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v136, s[0:3], s9 offen
		buffer_load_dwordx4 v[248:251], v139, s[0:3], s9 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[128:131], v[8:11], v[68:71], v17, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[128:131], v[4:7], v[72:75], v17, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[132:135], v[4:7], v[56:59], v17, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[132:135], v[8:11], v[52:55], v17, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[132:135], a[92:95], v[64:67], v17, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[128:131], a[92:95], v[80:83], v17, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[128:131], v[20:23], v[76:79], v17, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[136:139], v140, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[132:135], v[20:23], v[60:63], v17, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v1, s[0:3], s9 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[136:139], v[20:23], v[44:47], v18, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[136:139], a[92:95], v[48:51], v18, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[140:143], a[92:95], v[32:35], v18, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[140:143], v[20:23], v[28:31], v18, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[140:143], v[4:7], v[144:147], v18, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[136:139], v[4:7], v[40:43], v18, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[136:139], v[8:11], v[36:39], v18, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[140:143], v[8:11], v[148:151], v18, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[144:147], v[8:11], v[164:167], v112, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[144:147], v[4:7], v[160:163], v112, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[148:151], v[4:7], v[176:179], v112, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[148:151], v[8:11], v[180:183], v112, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[148:151], a[92:95], v[168:171], v112, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[144:147], a[92:95], v[152:155], v112, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[144:147], v[20:23], v[156:159], v112, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[148:151], v[20:23], v[172:175], v112, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[152:155], v[20:23], v[188:191], v113, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[152:155], a[92:95], v[184:187], v113, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[156:159], a[92:95], v[200:203], v113, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[156:159], v[20:23], v[204:207], v113, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[156:159], v[4:7], v[208:211], v113, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[152:155], v[4:7], v[192:195], v113, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[152:155], v[8:11], v[196:199], v113, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[156:159], v[8:11], v[212:215], v113, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[160:163], v[8:11], a[4:7], v115, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[160:163], v[4:7], v[224:227], v115, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[164:167], v[4:7], a[16:19], v115, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[164:167], v[8:11], a[20:23], v115, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], a[92:95], a[8:11], v115, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[160:163], a[92:95], v[216:219], v115, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[160:163], v[20:23], v[220:223], v115, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[164:167], v[20:23], a[12:15], v115, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[168:171], v[20:23], a[28:31], v132, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], a[92:95], a[24:27], v132, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], a[92:95], a[40:43], v132, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[172:175], v[20:23], a[44:47], v132, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[172:175], v[4:7], a[48:51], v132, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[168:171], v[4:7], a[32:35], v132, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[168:171], v[8:11], a[36:39], v132, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[172:175], v[8:11], a[52:55], v132, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[176:179], v[8:11], a[68:71], v141, v143 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[176:179], v[4:7], a[64:67], v141, v143 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[180:183], v[4:7], a[80:83], v141, v143 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[180:183], v[8:11], a[84:87], v141, v143 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], a[92:95], a[72:75], v141, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], a[92:95], a[56:59], v141, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[176:179], v[20:23], a[60:63], v141, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[180:183], v[20:23], a[76:79], v141, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b32 v1, v0 offset:10240
		ds_read_b32 v4, v0 offset:10496
		ds_read_b32 v5, v0 offset:10752
		ds_read_b32 v6, v0 offset:11008
		ds_read_b32 v7, v0 offset:11264
		ds_read_b32 v8, v0 offset:11520
		ds_read_b32 v9, v0 offset:11776
		ds_read_b32 v10, v0 offset:12032
		ds_read_b32 v0, v2 offset:12800
		ds_read_b32 v11, v2 offset:13056
		ds_read_b128 v[20:23], v3 offset:49152
		ds_read_b128 v[112:115], v3 offset:50176
		ds_read_b128 v[132:135], v3 offset:51200
		ds_read_b128 a[92:95], v3 offset:52224
		ds_read_b128 a[120:123], v3 offset:53248
		ds_read_b128 a[124:127], v3 offset:54272
		ds_read_b128 a[128:131], v3 offset:55296
		ds_read_b128 a[132:135], v3 offset:56320
		ds_read_b128 a[136:139], v3 offset:57344
		ds_read_b128 a[140:143], v3 offset:58368
		ds_read_b128 a[144:147], v3 offset:59392
		ds_read_b128 a[148:151], v3 offset:60416
		ds_read_b128 a[152:155], v3 offset:61440
		ds_read_b128 a[156:159], v3 offset:62464
		ds_read_b128 a[160:163], v3 offset:63488
		ds_read_b128 v[140:143], v3 offset:64512
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[120:123], v[12:15], v[24:27], v1, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[120:123], v[240:243], v[108:111], v1, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[124:127], v[240:243], v[92:95], v1, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[124:127], v[12:15], v[96:99], v1, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[124:127], v[116:119], v[88:91], v1, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[120:123], v[116:119], v[104:107], v1, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[120:123], v[236:239], v[100:103], v1, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[124:127], v[236:239], v[84:87], v1, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[128:131], v[236:239], v[68:71], v4, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[128:131], v[116:119], v[72:75], v4, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[228:231], v[116:119], v[56:59], v4, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[228:231], v[236:239], v[52:55], v4, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[228:231], v[12:15], v[64:67], v4, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[128:131], v[12:15], v[80:83], v4, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[128:131], v[240:243], v[76:79], v4, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[228:231], v[240:243], v[60:63], v4, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[232:235], v[240:243], v[44:47], v5, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[232:235], v[12:15], v[48:51], v5, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[88:91], v[12:15], v[32:35], v5, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[88:91], v[240:243], v[28:31], v5, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[88:91], v[116:119], v[144:147], v5, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[232:235], v[116:119], v[40:43], v5, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[232:235], v[236:239], v[36:39], v5, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[88:91], v[236:239], v[148:151], v5, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], v[236:239], v[164:167], v6, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], v[116:119], v[160:163], v6, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[100:103], v[116:119], v[176:179], v6, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[100:103], v[236:239], v[180:183], v6, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[100:103], v[12:15], v[168:171], v6, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], v[12:15], v[152:155], v6, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[96:99], v[240:243], v[156:159], v6, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[100:103], v[240:243], v[172:175], v6, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[104:107], v[240:243], v[188:191], v7, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[104:107], v[12:15], v[184:187], v7, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[108:111], v[12:15], v[200:203], v7, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[108:111], v[240:243], v[204:207], v7, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[108:111], v[116:119], v[208:211], v7, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[104:107], v[116:119], v[192:195], v7, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[104:107], v[236:239], v[196:199], v7, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[108:111], v[236:239], v[212:215], v7, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[112:115], v[236:239], a[4:7], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[112:115], v[116:119], v[224:227], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[116:119], v[116:119], a[16:19], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[116:119], v[236:239], a[20:23], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[116:119], v[12:15], a[8:11], v8, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[112:115], v[12:15], v[216:219], v8, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[112:115], v[240:243], v[220:223], v8, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[116:119], v[240:243], a[12:15], v8, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[184:187], v[240:243], a[28:31], v9, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[184:187], v[12:15], a[24:27], v9, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[188:191], v[12:15], a[40:43], v9, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[188:191], v[240:243], a[44:47], v9, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[188:191], v[116:119], a[48:51], v9, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[184:187], v[116:119], a[32:35], v9, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[184:187], v[236:239], a[36:39], v9, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[188:191], v[236:239], a[52:55], v9, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[192:195], v[236:239], a[68:71], v10, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[192:195], v[116:119], a[64:67], v10, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[196:199], v[116:119], a[80:83], v10, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[196:199], v[236:239], a[84:87], v10, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[196:199], v[12:15], a[72:75], v10, v0 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[192:195], v[12:15], a[56:59], v10, v0 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[192:195], v[240:243], a[60:63], v10, v0 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[196:199], v[240:243], a[76:79], v10, v0 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[20:23], v[244:247], v[24:27], v1, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v2, a0
		v_lshlrev_b32_e32 v2, 1, v2
		v_lshl_add_u32 v2, v19, 16, v2
		s_lshl_b32 s0, s4, 7
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[248:251], v[108:111], v1, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s15, 24
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s13, 9
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[112:115], v[248:251], v[92:95], v1, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v3, v24
		s_add_i32 s2, s2, s3
		s_lshl_b32 s4, s14, 22
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[112:115], v[244:247], v[96:99], v1, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s2, s2, s4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[112:115], v[136:139], v[88:91], v1, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[136:139], v[104:107], v1, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[252:255], v[100:103], v1, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[112:115], v[252:255], v[84:87], v1, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[132:135], v[252:255], v[68:71], v4, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[132:135], v[136:139], v[72:75], v4, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[92:95], v[136:139], v[56:59], v4, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[92:95], v[252:255], v[52:55], v4, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[92:95], v[244:247], v[64:67], v4, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[132:135], v[244:247], v[80:83], v4, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[132:135], v[248:251], v[76:79], v4, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[92:95], v[248:251], v[60:63], v4, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[120:123], v[248:251], v[44:47], v5, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[120:123], v[244:247], v[48:51], v5, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[124:127], v[244:247], v[32:35], v5, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[124:127], v[248:251], v[28:31], v5, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[124:127], v[136:139], v[144:147], v5, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[120:123], v[136:139], v[40:43], v5, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[120:123], v[252:255], v[36:39], v5, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[124:127], v[252:255], v[148:151], v5, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[128:131], v[252:255], v[164:167], v6, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[128:131], v[136:139], v[160:163], v6, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[132:135], v[136:139], v[176:179], v6, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[132:135], v[252:255], v[180:183], v6, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[132:135], v[244:247], v[168:171], v6, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[128:131], v[244:247], v[152:155], v6, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[128:131], v[248:251], v[156:159], v6, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[132:135], v[248:251], v[172:175], v6, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[136:139], v[248:251], v[188:191], v7, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[136:139], v[244:247], v[184:187], v7, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[140:143], v[244:247], v[200:203], v7, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[140:143], v[248:251], v[204:207], v7, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[140:143], v[136:139], v[208:211], v7, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[136:139], v[136:139], v[192:195], v7, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[136:139], v[252:255], v[196:199], v7, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[140:143], v[252:255], v[212:215], v7, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[144:147], v[252:255], a[4:7], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[144:147], v[136:139], v[224:227], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[148:151], v[136:139], a[16:19], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[148:151], v[252:255], a[20:23], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[148:151], v[244:247], a[8:11], v8, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[144:147], v[244:247], v[216:219], v8, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[144:147], v[248:251], v[220:223], v8, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[148:151], v[248:251], a[12:15], v8, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[152:155], v[248:251], a[28:31], v9, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[152:155], v[244:247], a[24:27], v9, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[156:159], v[244:247], a[40:43], v9, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[156:159], v[248:251], a[44:47], v9, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[156:159], v[136:139], a[48:51], v9, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[152:155], v[136:139], a[32:35], v9, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[152:155], v[252:255], a[36:39], v9, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[156:159], v[252:255], a[52:55], v9, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[160:163], v[252:255], a[68:71], v10, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[160:163], v[136:139], a[64:67], v10, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[140:143], v[136:139], a[80:83], v10, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[140:143], v[252:255], a[84:87], v10, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[140:143], v[244:247], a[72:75], v10, v0 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[160:163], v[244:247], a[56:59], v10, v0 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[160:163], v[248:251], a[60:63], v10, v0 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[140:143], v[248:251], a[76:79], v10, v0 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s31, s19
		buffer_store_short v3, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v25
		s_add_i32 s5, s0, 0x4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v26
		s_add_i32 s6, s0, 0x8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v27
		s_add_i32 s7, s0, 0xc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v108
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v109
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v110
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v111
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v104
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v105
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v106
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v107
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v100
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v101
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v102
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v103
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v96
		s_add_i32 s2, s0, 0x40000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v97
		s_add_i32 s5, s0, 0x44000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v98
		s_add_i32 s6, s0, 0x48000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v99
		s_add_i32 s7, s0, 0x4c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v92
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v93
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v94
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v95
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v88
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v89
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v90
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v91
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v84
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v85
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v86
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v87
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v80
		s_add_i32 s2, s0, 0x80000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v81
		s_add_i32 s5, s0, 0x84000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v82
		s_add_i32 s6, s0, 0x88000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v83
		s_add_i32 s7, s0, 0x8c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v76
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v77
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v78
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v79
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v72
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v73
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v74
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v75
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v68
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v69
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v70
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v71
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v64
		s_add_i32 s2, s0, 0xc0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v65
		s_add_i32 s5, s0, 0xc4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v66
		s_add_i32 s6, s0, 0xc8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v67
		s_add_i32 s7, s0, 0xcc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v60
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v61
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v62
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v63
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v56
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v57
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v58
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v59
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v52
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v53
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v54
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v55
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v48
		s_add_i32 s2, s0, 0x100000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v49
		s_add_i32 s5, s0, 0x104000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v50
		s_add_i32 s6, s0, 0x108000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v51
		s_add_i32 s7, s0, 0x10c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v44
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v45
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v46
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v47
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v40
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v41
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v42
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v43
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v36
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v37
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v38
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v39
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v32
		s_add_i32 s2, s0, 0x140000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v33
		s_add_i32 s5, s0, 0x144000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v34
		s_add_i32 s6, s0, 0x148000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v35
		s_add_i32 s7, s0, 0x14c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v28
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v29
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v30
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v31
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v144
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v145
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v146
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v147
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v148
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v149
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v150
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v151
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v152
		s_add_i32 s2, s0, 0x180000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v153
		s_add_i32 s5, s0, 0x184000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v154
		s_add_i32 s6, s0, 0x188000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v155
		s_add_i32 s7, s0, 0x18c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v156
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v157
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v158
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v159
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v160
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v161
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v162
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v163
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v164
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v165
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v166
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v167
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v168
		s_add_i32 s2, s0, 0x1c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v169
		s_add_i32 s5, s0, 0x1c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v170
		s_add_i32 s6, s0, 0x1c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v171
		s_add_i32 s7, s0, 0x1cc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v172
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v173
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v174
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v175
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v176
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v177
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v178
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v179
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v180
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v181
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v182
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v183
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v184
		s_add_i32 s2, s0, 0x200000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v185
		s_add_i32 s5, s0, 0x204000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v186
		s_add_i32 s6, s0, 0x208000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v187
		s_add_i32 s7, s0, 0x20c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v188
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v189
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v190
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v191
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v192
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v193
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v194
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v195
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v196
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v197
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v198
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v199
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v200
		s_add_i32 s2, s0, 0x240000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v201
		s_add_i32 s5, s0, 0x244000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v202
		s_add_i32 s6, s0, 0x248000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v203
		s_add_i32 s7, s0, 0x24c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v204
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v205
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v206
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v207
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v208
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v209
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v210
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v211
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v212
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v213
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v214
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v215
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v0, v216
		s_add_i32 s2, s0, 0x280000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v217
		s_add_i32 s5, s0, 0x284000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v218
		s_add_i32 s6, s0, 0x288000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v219
		s_add_i32 s7, s0, 0x28c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v0, v220
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v221
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v222
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v223
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v0, v224
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v225
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v226
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v0, v227
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a4
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a5
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a6
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a7
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a8
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s2, s0, 0x2c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_accvgpr_read_b32 v0, a9
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s5, s0, 0x2c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_accvgpr_read_b32 v0, a10
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s6, s0, 0x2c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_accvgpr_read_b32 v0, a11
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s7, s0, 0x2cc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_accvgpr_read_b32 v0, a12
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a13
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a14
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a15
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a16
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a17
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a18
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a19
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a20
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a21
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a22
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a23
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a24
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s2, s0, 0x300000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_accvgpr_read_b32 v0, a25
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s5, s0, 0x304000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_accvgpr_read_b32 v0, a26
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s6, s0, 0x308000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_accvgpr_read_b32 v0, a27
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s7, s0, 0x30c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_accvgpr_read_b32 v0, a28
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a29
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a30
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a31
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a32
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a33
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a34
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a35
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a36
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a37
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a38
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a39
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a40
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s2, s0, 0x340000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_accvgpr_read_b32 v0, a41
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s5, s0, 0x344000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_accvgpr_read_b32 v0, a42
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s6, s0, 0x348000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_accvgpr_read_b32 v0, a43
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s7, s0, 0x34c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_accvgpr_read_b32 v0, a44
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a45
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a46
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a47
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a48
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a49
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a50
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a51
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a52
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a53
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a54
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a55
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a56
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s2, s0, 0x380000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_accvgpr_read_b32 v0, a57
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s5, s0, 0x384000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_accvgpr_read_b32 v0, a58
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s6, s0, 0x388000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_accvgpr_read_b32 v0, a59
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s7, s0, 0x38c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v0, v2, s[28:31], s7 offen sc0 nt
		v_accvgpr_read_b32 v0, a60
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a61
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a62
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a63
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a64
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a65
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a66
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a67
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a68
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a69
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a70
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a71
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a72
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s2, s0, 0x3c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v0, v2, s[28:31], s2 offen sc0 nt
		v_accvgpr_read_b32 v0, a73
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s5, s0, 0x3c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v0, v2, s[28:31], s5 offen sc0 nt
		v_accvgpr_read_b32 v0, a74
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s6, s0, 0x3c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v0, v2, s[28:31], s6 offen sc0 nt
		v_accvgpr_read_b32 v0, a75
		v_cvt_f16_f32_e64 v0, v0
		s_add_i32 s0, s0, 0x3cc000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		s_add_i32 s0, s0, s4
		buffer_store_short v0, v2, s[28:31], s0 offen sc0 nt
		v_accvgpr_read_b32 v0, a76
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a77
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a78
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a79
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s0 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v0, a80
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a81
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a82
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a83
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s0 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v0, a84
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a85
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a86
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v0, a87
		v_cvt_f16_f32_e64 v0, v0
		buffer_store_short v0, v2, s[28:31], s0 offen offset:96 sc0 nt
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
		.amdhsa_next_free_sgpr 45
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 45
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
    .sgpr_count:     45
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     472
    .agpr_count:     216
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 189
    wave.regalloc.agpr.dwords: 743
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
