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
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s19, s23
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s26, 0x40000
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s27, s23
		s_mov_b32 s30, 0x100000
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		v_readfirstlane_b32 s1, v0
		s_lshl_b32 s4, s0, 15
		s_lshr_b32 s5, s14, 4
		s_lshl_b32 s12, s5, 21
		s_add_i32 s15, s4, s12
		s_lshl_b32 s14, s14, 3
		s_add_i32 s13, s13, s14
		s_and_b32 s13, s13, 0x7f
		s_and_b32 s14, s13, 3
		s_lshl_b32 s32, s14, 19
		s_add_i32 s15, s15, s32
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 11, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v3, 4, v3
		s_add_i32 s33, s4, 0x20000
		s_add_i32 s33, s33, s12
		s_add_i32 s33, s33, s32
		s_add_i32 s34, s4, 0x40000
		s_add_i32 s34, s34, s12
		s_add_i32 s34, s34, s32
		s_add_i32 s35, s4, 0x60000
		s_add_i32 s35, s35, s12
		s_add_i32 s35, s35, s32
		s_add_i32 s36, s4, 64
		s_add_i32 s36, s36, s12
		s_add_i32 s36, s36, s32
		s_add_i32 s37, s4, 0x20040
		s_add_i32 s37, s37, s12
		s_add_i32 s37, s37, s32
		s_add_i32 s38, s4, 0x40040
		s_add_i32 s38, s38, s12
		s_add_i32 s38, s38, s32
		s_add_i32 s39, s4, 0x60040
		s_add_i32 s39, s39, s12
		s_add_i32 s39, s39, s32
		s_add_i32 s40, s4, 0x80
		s_add_i32 s40, s40, s12
		s_add_i32 s40, s40, s32
		s_add_i32 s41, s4, 0x20080
		s_add_i32 s41, s41, s12
		s_add_i32 s41, s41, s32
		s_add_i32 s42, s4, 0x40080
		s_add_i32 s42, s42, s12
		s_add_i32 s42, s42, s32
		s_add_i32 s43, s4, 0x60080
		s_add_i32 s43, s43, s12
		s_add_i32 s43, s43, s32
		s_add_i32 s44, s4, 0xc0
		s_add_i32 s44, s44, s12
		s_add_i32 s44, s44, s32
		s_add_i32 s45, s4, 0x200c0
		s_add_i32 s45, s45, s12
		s_add_i32 s45, s45, s32
		s_add_i32 s46, s4, 0x400c0
		s_add_i32 s46, s46, s12
		s_add_i32 s46, s46, s32
		s_add_i32 s4, s4, 0x600c0
		s_add_i32 s4, s4, s12
		s_add_i32 s4, s4, s32
		s_lshr_b32 s1, s1, 6
		s_lshl_b32 s1, s1, 10
		s_mov_b32 m0, s1
		v_add3_u32 v4, s15, v2, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v5, s33, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v6, s34, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v7, s35, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v8, s36, v2, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_add3_u32 v9, s37, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v10, s38, v2, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_add3_u32 v11, s39, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, s40, v2, v3
		v_and_b32_e32 v0, 15, v0
		s_mov_b32 s12, 0x100
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_add3_u32 v13, s41, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v14, s42, v2, v3
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_add3_u32 v15, s43, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, s44, v2, v3
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		v_add3_u32 v17, s45, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v18, s46, v2, v3
		v_add3_u32 v2, s4, v2, v3
		v_and_b32_e32 v3, 15, v1
		v_accvgpr_write_b32 a0, v3
		v_lshrrev_b32_e32 v3, 4, v1
		v_accvgpr_read_b32 v19, a0
		v_lshlrev_b32_e32 v19, 4, v19
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_and_b32_e32 v20, 1, v3
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v20, 12, v20
		v_lshrrev_b32_e32 v21, 5, v1
		v_lshlrev_b32_e32 v21, 8, v21
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_add3_u32 v20, v21, v20, v19
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v21, 6, v0
		v_accvgpr_write_b32 a1, v21
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v3, v0, 3 bitop3:0x78
		v_accvgpr_write_b32 a2, v0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		v_accvgpr_read_b32 v0, a2
		v_accvgpr_read_b32 v21, a1
		v_lshl_add_u32 v0, v0, 4, v21
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v21, 0x200, v6
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		v_add_u32_e32 v22, 0x200, v7
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v23, 0x200, v10
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_add_u32_e32 v24, 0x200, v11
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v25, 0x200, v14
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		v_add_u32_e32 v26, 0x200, v15
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v27, 0x200, v18
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_add_u32_e32 v28, 0x200, v2
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_mov_b32 s34, 0x2000000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		buffer_load_dwordx4 v4, s[16:19], s12 offen lds
		s_mov_b32 s2, 0x7000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s3, 0x6000
		buffer_load_dwordx4 v5, s[16:19], s12 offen lds
		s_mov_b32 s4, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s8, 0x1000
		buffer_load_dwordx4 v6, s[16:19], s12 offen lds
		v_lshlrev_b32_e32 v6, 2, v1
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v4, 0x200, v4
		buffer_load_dwordx4 v7, s[16:19], s12 offen lds
		v_add_u32_e32 v5, 0x200, v5
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v7, 0x200, v8
		buffer_load_dwordx4 v8, s[16:19], s12 offen lds
		v_add_u32_e32 v8, 0x200, v9
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v29, 0x200, v12
		buffer_load_dwordx4 v9, s[16:19], s12 offen lds
		v_add_u32_e32 v9, 0x200, v13
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v30, 0x200, v16
		buffer_load_dwordx4 v10, s[16:19], s12 offen lds
		v_add_u32_e32 v10, 0x200, v17
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		buffer_load_dwordx4 v11, s[16:19], s12 offen lds
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		buffer_load_dwordx4 v12, s[16:19], s12 offen lds
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s9, s0, 10
		buffer_load_dwordx4 v13, s[16:19], s12 offen lds
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		buffer_load_dwordx4 v14, s[16:19], s12 offen lds
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s9, s9, 0x20000
		buffer_load_dwordx4 v15, s[16:19], s12 offen lds
		s_lshl_b32 s10, s0, 17
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s11, s0, 13
		buffer_load_dwordx4 v16, s[16:19], s12 offen lds
		s_lshr_b32 s13, s13, 2
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s15, s14, 15
		buffer_load_dwordx4 v17, s[16:19], s12 offen lds
		s_lshl_b32 s32, s5, 17
		s_add_i32 m0, m0, 0x1000
		s_lshr_b32 s33, s0, 1
		buffer_load_dwordx4 v18, s[16:19], s12 offen lds
		s_lshl_b32 s35, s0, 2
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v11, s35, v3
		v_and_b32_e32 v11, 7, v11
		buffer_load_dwordx4 v2, s[16:19], s12 offen lds
		v_lshl_add_u32 v2, v11, 12, v19
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s12, s33, 8
		s_add_i32 s33, s12, s32
		s_add_i32 s33, s33, s15
		buffer_load_dwordx4 v2, s[24:27], s33 offen lds
		v_add_u32_e32 v11, s33, v2
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s33, s13, 15
		s_add_i32 s35, s11, s33
		buffer_load_dwordx4 v20, s[28:31], s35 offen lds
		v_add_u32_e32 v11, 0x400, v11
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s12, s12, 0x200
		s_add_i32 s12, s12, s32
		s_add_i32 s12, s12, s15
		buffer_load_dwordx4 v2, s[24:27], s12 offen lds
		s_add_i32 s11, s11, 0x200
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s11, s11, s33
		s_lshl_b32 s12, s13, 19
		s_add_i32 s15, s10, s12
		buffer_load_dwordx4 v20, s[28:31], s11 offen lds
		v_lshl_add_u32 v2, v1, 4, s15
		v_lshl_add_u32 v12, v1, 4, s12
		v_add_u32_e32 v12, s10, v12
		v_add_u32_e32 v13, 0x8000, v12
		v_add_u32_e32 v14, 0x10000, v12
		v_add_u32_e32 v12, 0x18000, v12
		buffer_load_dwordx4 v[16:19], v2, s[20:23], 0 offen
		buffer_load_dwordx4 v[64:67], v13, s[20:23], 0 offen
		buffer_load_dwordx4 v[68:71], v14, s[20:23], 0 offen
		buffer_load_dwordx4 v[72:75], v12, s[20:23], 0 offen
		s_waitcnt vmcnt(6)
		s_barrier
		v_lshl_add_u32 v15, v1, 4, s12
		v_add_u32_e32 v15, s10, v15
		v_add_u32_e32 v31, 0x400, v15
		v_add_u32_e32 v76, 0x8400, v15
		v_add_u32_e32 v15, 0x10400, v15
		v_lshl_add_u32 v77, v1, 4, s12
		v_add_u32_e32 v77, s10, v77
		v_add_u32_e32 v78, 0x18400, v77
		v_add_u32_e32 v79, 0x800, v77
		v_add_u32_e32 v77, 0x8800, v77
		v_lshl_add_u32 v80, v1, 4, s12
		v_add_u32_e32 v80, s10, v80
		v_add_u32_e32 v81, 0x10800, v80
		v_add_u32_e32 v82, 0x18800, v80
		v_add_u32_e32 v80, 0xc00, v80
		v_lshl_add_u32 v1, v1, 4, s12
		v_add_u32_e32 v1, s10, v1
		v_add_u32_e32 v83, 0x8c00, v1
		v_add_u32_e32 v84, 0x10c00, v1
		v_add_u32_e32 v1, 0x18c00, v1
		v_add_u32_e32 v20, s35, v20
		v_add_u32_e32 v20, 0x400, v20
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
		v_mov_b32_e32 v85, v0
		s_mov_b32 s10, s4
		s_mov_b32 s11, s1
		s_mov_b32 s12, s4
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s15, s4, 12
		ds_read_b128 a[88:91], v85
		ds_read_b128 a[92:95], v85 offset:1024
		ds_read_b128 a[96:99], v85 offset:2048
		ds_read_b128 a[100:103], v85 offset:3072
		ds_read_b128 a[104:107], v85 offset:4096
		ds_read_b128 a[108:111], v85 offset:5120
		ds_read_b128 a[112:115], v85 offset:6144
		ds_read_b128 a[116:119], v85 offset:7168
		ds_read_b128 a[120:123], v85 offset:8192
		ds_read_b128 a[124:127], v85 offset:9216
		ds_read_b128 a[128:131], v85 offset:10240
		ds_read_b128 a[132:135], v85 offset:11264
		ds_read_b128 a[136:139], v85 offset:12288
		ds_read_b128 a[140:143], v85 offset:13312
		ds_read_b128 a[144:147], v85 offset:14336
		ds_read_b128 a[148:151], v85 offset:15360
		s_add_i32 s32, s10, 0x20000
		v_add_u32_e32 v86, s32, v6
		ds_read2st64_b32 v[228:229], v86 offset1:1
		ds_read2st64_b32 v[230:231], v86 offset0:2 offset1:3
		ds_read2st64_b32 v[232:233], v86 offset0:4 offset1:5
		ds_read2st64_b32 v[234:235], v86 offset0:6 offset1:7
		s_add_i32 s32, s9, s10
		v_add_u32_e32 v87, s32, v6
		ds_read2st64_b32 v[236:237], v87 offset0:16 offset1:17
		ds_read_b128 a[152:155], v85 offset:16384
		ds_read_b128 a[156:159], v85 offset:17408
		ds_read_b128 a[160:163], v85 offset:18432
		ds_read_b128 a[164:167], v85 offset:19456
		ds_read_b128 a[168:171], v85 offset:20480
		ds_read_b128 a[172:175], v85 offset:21504
		ds_read_b128 a[176:179], v85 offset:22528
		ds_read_b128 a[180:183], v85 offset:23552
		ds_read_b128 a[184:187], v85 offset:24576
		ds_read_b128 a[188:191], v85 offset:25600
		ds_read_b128 a[192:195], v85 offset:26624
		ds_read_b128 a[196:199], v85 offset:27648
		ds_read_b128 a[200:203], v85 offset:28672
		ds_read_b128 a[204:207], v85 offset:29696
		ds_read_b128 a[208:211], v85 offset:30720
		ds_read_b128 a[212:215], v85 offset:31744
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[88:91], v[16:19], v[32:35], v228, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s32, s12, 0x2000
		s_add_i32 s33, s11, 0x10000
		s_add_i32 s10, s10, 0x2000
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[88:91], v[64:67], v[60:63], v228, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s10, s10, 0x3fff
		s_add_i32 s4, s4, 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[92:95], v[64:67], v[44:47], v228, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[92:95], v[16:19], v[48:51], v228, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[92:95], v[68:71], v[40:43], v228, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[88:91], v[68:71], v[56:59], v228, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[88:91], v[72:75], v[52:55], v228, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v31, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[92:95], v[72:75], v[36:39], v228, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v76, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], v[72:75], v[100:103], v229, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], v[68:71], v[96:99], v229, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[100:103], v[68:71], v[112:115], v229, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[100:103], v[72:75], v[116:119], v229, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[100:103], v[16:19], v[104:107], v229, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], v[16:19], v[88:91], v229, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[96:99], v[64:67], v[92:95], v229, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v15, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[100:103], v[64:67], v[108:111], v229, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v78, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[104:107], v[64:67], v[124:127], v230, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[104:107], v[16:19], v[120:123], v230, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[108:111], v[16:19], v[136:139], v230, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[108:111], v[64:67], v[140:143], v230, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[108:111], v[68:71], v[144:147], v230, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[104:107], v[68:71], v[128:131], v230, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[104:107], v[72:75], v[132:135], v230, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[108:111], v[72:75], v[148:151], v230, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[112:115], v[72:75], v[164:167], v231, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[112:115], v[68:71], v[160:163], v231, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[116:119], v[68:71], v[176:179], v231, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[116:119], v[72:75], v[180:183], v231, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[116:119], v[16:19], v[168:171], v231, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[112:115], v[16:19], v[152:155], v231, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[112:115], v[64:67], v[156:159], v231, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[116:119], v[64:67], v[172:175], v231, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[120:123], v[64:67], v[188:191], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[120:123], v[16:19], v[184:187], v232, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[124:127], v[16:19], v[200:203], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[124:127], v[64:67], v[204:207], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[124:127], v[68:71], v[208:211], v232, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[120:123], v[68:71], v[192:195], v232, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[120:123], v[72:75], v[196:199], v232, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[124:127], v[72:75], v[212:215], v232, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[128:131], v[72:75], a[4:7], v233, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[128:131], v[68:71], v[224:227], v233, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[132:135], v[68:71], a[16:19], v233, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[132:135], v[72:75], a[20:23], v233, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[16:19], a[8:11], v233, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[128:131], v[16:19], v[216:219], v233, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[128:131], v[64:67], v[220:223], v233, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[132:135], v[64:67], a[12:15], v233, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[136:139], v[64:67], a[28:31], v234, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[16:19], a[24:27], v234, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[16:19], a[40:43], v234, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[140:143], v[64:67], a[44:47], v234, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[140:143], v[68:71], a[48:51], v234, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[136:139], v[68:71], a[32:35], v234, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[136:139], v[72:75], a[36:39], v234, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[140:143], v[72:75], a[52:55], v234, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[144:147], v[72:75], a[68:71], v235, v237 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[144:147], v[68:71], a[64:67], v235, v237 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[148:151], v[68:71], a[80:83], v235, v237 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[148:151], v[72:75], a[84:87], v235, v237 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[16:19], a[72:75], v235, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[16:19], a[56:59], v235, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[144:147], v[64:67], a[60:63], v235, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[148:151], v[64:67], a[76:79], v235, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 m0, s11
		ds_read_b128 a[88:91], v85 offset:32768
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		ds_read_b128 a[92:95], v85 offset:33792
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s11, s33, 0x1ffff
		s_and_b32 s32, s32, 0x3fff
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		ds_read_b128 a[96:99], v85 offset:34816
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s12, s1, s12
		buffer_load_dwordx4 v21, s[16:19], 0 offen lds
		ds_read_b128 a[100:103], v85 offset:35840
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s33, s8, s15
		buffer_load_dwordx4 v22, s[16:19], 0 offen lds
		ds_read_b128 a[104:107], v85 offset:36864
		ds_read_b128 a[108:111], v85 offset:37888
		ds_read_b128 a[112:115], v85 offset:38912
		ds_read_b128 a[116:119], v85 offset:39936
		ds_read_b128 a[120:123], v85 offset:40960
		ds_read_b128 a[124:127], v85 offset:41984
		ds_read_b128 a[128:131], v85 offset:43008
		ds_read_b128 a[132:135], v85 offset:44032
		ds_read_b128 a[136:139], v85 offset:45056
		ds_read_b128 a[140:143], v85 offset:46080
		ds_read_b128 a[144:147], v85 offset:47104
		ds_read_b128 a[148:151], v85 offset:48128
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[152:155], v[240:243], v[32:35], v228, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[152:155], v[244:247], v[60:63], v228, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[156:159], v[244:247], v[44:47], v228, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[156:159], v[240:243], v[48:51], v228, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[156:159], v[248:251], v[40:43], v228, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[152:155], v[248:251], v[56:59], v228, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[152:155], v[252:255], v[52:55], v228, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[16:19], v79, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[156:159], v[252:255], v[36:39], v228, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[64:67], v77, s[20:23], s15 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[160:163], v[252:255], v[100:103], v229, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[160:163], v[248:251], v[96:99], v229, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[164:167], v[248:251], v[112:115], v229, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[164:167], v[252:255], v[116:119], v229, v237 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[164:167], v[240:243], v[104:107], v229, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[160:163], v[240:243], v[88:91], v229, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[160:163], v[244:247], v[92:95], v229, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[68:71], v81, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[164:167], v[244:247], v[108:111], v229, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[72:75], v82, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[168:171], v[244:247], v[124:127], v230, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[168:171], v[240:243], v[120:123], v230, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[172:175], v[240:243], v[136:139], v230, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[172:175], v[244:247], v[140:143], v230, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[172:175], v[248:251], v[144:147], v230, v237 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[168:171], v[248:251], v[128:131], v230, v237 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[168:171], v[252:255], v[132:135], v230, v237 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		ds_read2st64_b32 v[228:229], v86 offset0:8 offset1:9
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		ds_read2st64_b32 v[230:231], v86 offset0:10 offset1:11
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v232, 0x10000, v85
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read2st64_b32 v[234:235], v86 offset0:12 offset1:13
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v23, s[16:19], 0 offen lds
		ds_read2st64_b32 v[236:237], v86 offset0:14 offset1:15
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v24, s[16:19], 0 offen lds
		ds_read2st64_b32 v[238:239], v87 offset0:18 offset1:19
		ds_read_b128 a[152:155], v85 offset:49152
		ds_read_b128 a[156:159], v85 offset:50176
		ds_read_b128 a[160:163], v85 offset:51200
		ds_read_b128 a[164:167], v85 offset:52224
		ds_read_b128 a[168:171], v85 offset:53248
		ds_read_b128 a[172:175], v85 offset:54272
		ds_read_b128 a[176:179], v85 offset:55296
		ds_read_b128 a[180:183], v85 offset:56320
		ds_read_b128 a[184:187], v85 offset:57344
		ds_read_b128 a[188:191], v85 offset:58368
		ds_read_b128 a[192:195], v85 offset:59392
		ds_read_b128 a[196:199], v85 offset:60416
		ds_read_b128 a[200:203], v85 offset:61440
		ds_read_b128 a[204:207], v85 offset:62464
		ds_read_b128 a[208:211], v85 offset:63488
		ds_read_b128 a[212:215], v85 offset:64512
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[88:91], v[16:19], v[32:35], v228, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v85, 0x1ffff, v232
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[88:91], v[64:67], v[60:63], v228, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[92:95], v[64:67], v[44:47], v228, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[92:95], v[16:19], v[48:51], v228, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[92:95], v[68:71], v[40:43], v228, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[88:91], v[68:71], v[56:59], v228, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[88:91], v[72:75], v[52:55], v228, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v80, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[92:95], v[72:75], v[36:39], v228, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v83, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[96:99], v[72:75], v[100:103], v229, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[96:99], v[68:71], v[96:99], v229, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[100:103], v[68:71], v[112:115], v229, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[100:103], v[72:75], v[116:119], v229, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[100:103], v[16:19], v[104:107], v229, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[96:99], v[16:19], v[88:91], v229, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[96:99], v[64:67], v[92:95], v229, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v84, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[100:103], v[64:67], v[108:111], v229, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v1, s[20:23], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[104:107], v[64:67], v[124:127], v230, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[104:107], v[16:19], v[120:123], v230, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[108:111], v[16:19], v[136:139], v230, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[108:111], v[64:67], v[140:143], v230, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[108:111], v[68:71], v[144:147], v230, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[104:107], v[68:71], v[128:131], v230, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[104:107], v[72:75], v[132:135], v230, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[108:111], v[72:75], v[148:151], v230, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[112:115], v[72:75], v[164:167], v231, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[112:115], v[68:71], v[160:163], v231, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[116:119], v[68:71], v[176:179], v231, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[116:119], v[72:75], v[180:183], v231, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[116:119], v[16:19], v[168:171], v231, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[112:115], v[16:19], v[152:155], v231, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[112:115], v[64:67], v[156:159], v231, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[116:119], v[64:67], v[172:175], v231, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[120:123], v[64:67], v[188:191], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[120:123], v[16:19], v[184:187], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[124:127], v[16:19], v[200:203], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[124:127], v[64:67], v[204:207], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[124:127], v[68:71], v[208:211], v234, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[120:123], v[68:71], v[192:195], v234, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[120:123], v[72:75], v[196:199], v234, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[124:127], v[72:75], v[212:215], v234, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[128:131], v[72:75], a[4:7], v235, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[128:131], v[68:71], v[224:227], v235, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[132:135], v[68:71], a[16:19], v235, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[132:135], v[72:75], a[20:23], v235, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[16:19], a[8:11], v235, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[128:131], v[16:19], v[216:219], v235, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[128:131], v[64:67], v[220:223], v235, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[132:135], v[64:67], a[12:15], v235, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[136:139], v[64:67], a[28:31], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[16:19], a[24:27], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[16:19], a[40:43], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[140:143], v[64:67], a[44:47], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[140:143], v[68:71], a[48:51], v236, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[136:139], v[68:71], a[32:35], v236, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[136:139], v[72:75], a[36:39], v236, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[140:143], v[72:75], a[52:55], v236, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[144:147], v[72:75], a[68:71], v237, v239 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[144:147], v[68:71], a[64:67], v237, v239 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[148:151], v[68:71], a[80:83], v237, v239 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[148:151], v[72:75], a[84:87], v237, v239 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[16:19], a[72:75], v237, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[16:19], a[56:59], v237, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[144:147], v[64:67], a[60:63], v237, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[148:151], v[64:67], a[76:79], v237, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v29, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v25, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v26, s[16:19], 0 offen lds
		buffer_load_dwordx4 v[16:19], v2, s[20:23], s33 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[152:155], v[240:243], v[32:35], v228, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[64:67], v13, s[20:23], s33 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[152:155], v[244:247], v[60:63], v228, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[68:71], v14, s[20:23], s33 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[156:159], v[244:247], v[44:47], v228, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[72:75], v12, s[20:23], s33 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[156:159], v[240:243], v[48:51], v228, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[156:159], v[248:251], v[40:43], v228, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[152:155], v[248:251], v[56:59], v228, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[152:155], v[252:255], v[52:55], v228, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[156:159], v[252:255], v[36:39], v228, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[160:163], v[252:255], v[100:103], v229, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[160:163], v[248:251], v[96:99], v229, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[164:167], v[248:251], v[112:115], v229, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[164:167], v[252:255], v[116:119], v229, v239 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[164:167], v[240:243], v[104:107], v229, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[160:163], v[240:243], v[88:91], v229, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[160:163], v[244:247], v[92:95], v229, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[164:167], v[244:247], v[108:111], v229, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[168:171], v[244:247], v[124:127], v230, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[168:171], v[240:243], v[120:123], v230, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[172:175], v[240:243], v[136:139], v230, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[172:175], v[244:247], v[140:143], v230, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[172:175], v[248:251], v[144:147], v230, v239 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[168:171], v[248:251], v[128:131], v230, v239 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[168:171], v[252:255], v[132:135], v230, v239 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		buffer_load_dwordx4 v30, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v27, s[16:19], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v28, s[16:19], 0 offen lds
		s_add_u32 s16, s16, 0x100
		s_addc_u32 s17, s17, 0
		s_add_i32 m0, s12, 0x20000
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s24, s24, 0x200
		s_addc_u32 s25, s25, 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_add_u32 s28, s28, 0x200
		s_addc_u32 s29, s29, 0
		s_cmp_lt_i32 s4, 6
		s_mov_b32 s12, s32
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		ds_read_b128 v[8:11], v0
		ds_read_b128 v[20:23], v0 offset:1024
		ds_read_b128 v[24:27], v0 offset:2048
		ds_read_b128 v[228:231], v0 offset:3072
		ds_read_b128 v[232:235], v0 offset:4096
		ds_read_b128 v[236:239], v0 offset:5120
		ds_read_b128 v[240:243], v0 offset:6144
		ds_read_b128 v[244:247], v0 offset:7168
		ds_read_b128 a[88:91], v0 offset:8192
		ds_read_b128 a[92:95], v0 offset:9216
		ds_read_b128 a[96:99], v0 offset:10240
		ds_read_b128 a[100:103], v0 offset:11264
		ds_read_b128 a[104:107], v0 offset:12288
		ds_read_b128 a[108:111], v0 offset:13312
		ds_read_b128 a[112:115], v0 offset:14336
		ds_read_b128 a[116:119], v0 offset:15360
		v_add_u32_e32 v4, 0x20000, v6
		ds_read2st64_b32 v[28:29], v4 offset1:1
		ds_read2st64_b32 v[86:87], v4 offset0:2 offset1:3
		ds_read2st64_b32 v[248:249], v4 offset0:4 offset1:5
		ds_read2st64_b32 v[250:251], v4 offset0:6 offset1:7
		v_add_u32_e32 v5, s9, v6
		ds_read2st64_b32 v[6:7], v5 offset0:16 offset1:17
		ds_read_b128 a[120:123], v0 offset:16384
		ds_read_b128 a[124:127], v0 offset:17408
		ds_read_b128 a[128:131], v0 offset:18432
		ds_read_b128 a[132:135], v0 offset:19456
		ds_read_b128 a[136:139], v0 offset:20480
		ds_read_b128 a[140:143], v0 offset:21504
		ds_read_b128 a[144:147], v0 offset:22528
		ds_read_b128 a[148:151], v0 offset:23552
		ds_read_b128 a[152:155], v0 offset:24576
		ds_read_b128 a[156:159], v0 offset:25600
		ds_read_b128 a[160:163], v0 offset:26624
		ds_read_b128 a[164:167], v0 offset:27648
		ds_read_b128 a[168:171], v0 offset:28672
		ds_read_b128 a[172:175], v0 offset:29696
		ds_read_b128 a[176:179], v0 offset:30720
		ds_read_b128 v[252:255], v0 offset:31744
		s_waitcnt vmcnt(9) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[8:11], v[16:19], v[32:35], v28, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[8:11], v[64:67], v[60:63], v28, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[20:23], v[64:67], v[44:47], v28, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[20:23], v[16:19], v[48:51], v28, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[20:23], v[68:71], v[40:43], v28, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[8:11], v[68:71], v[56:59], v28, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[8:11], v[72:75], v[52:55], v28, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[8:11], v31, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[20:23], v[72:75], v[36:39], v28, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[20:23], v76, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[24:27], v[72:75], v[100:103], v29, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[24:27], v[68:71], v[96:99], v29, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[228:231], v[68:71], v[112:115], v29, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[228:231], v[72:75], v[116:119], v29, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[228:231], v[16:19], v[104:107], v29, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], v[16:19], v[88:91], v29, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[24:27], v[64:67], v[92:95], v29, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[24:27], v15, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[228:231], v[64:67], v[108:111], v29, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[228:231], v78, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[232:235], v[64:67], v[124:127], v86, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[232:235], v[16:19], v[120:123], v86, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[236:239], v[16:19], v[136:139], v86, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[236:239], v[64:67], v[140:143], v86, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[236:239], v[68:71], v[144:147], v86, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[232:235], v[68:71], v[128:131], v86, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[232:235], v[72:75], v[132:135], v86, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[236:239], v[72:75], v[148:151], v86, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[240:243], v[72:75], v[164:167], v87, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[240:243], v[68:71], v[160:163], v87, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[244:247], v[68:71], v[176:179], v87, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[72:75], v[180:183], v87, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[244:247], v[16:19], v[168:171], v87, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[240:243], v[16:19], v[152:155], v87, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[240:243], v[64:67], v[156:159], v87, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[244:247], v[64:67], v[172:175], v87, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[88:91], v[64:67], v[188:191], v248, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[88:91], v[16:19], v[184:187], v248, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], v[16:19], v[200:203], v248, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], v[64:67], v[204:207], v248, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], v[68:71], v[208:211], v248, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[88:91], v[68:71], v[192:195], v248, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[88:91], v[72:75], v[196:199], v248, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], v[72:75], v[212:215], v248, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[96:99], v[72:75], a[4:7], v249, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], v[68:71], v[224:227], v249, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[100:103], v[68:71], a[16:19], v249, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[100:103], v[72:75], a[20:23], v249, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[100:103], v[16:19], a[8:11], v249, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], v[16:19], v[216:219], v249, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[96:99], v[64:67], v[220:223], v249, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[100:103], v[64:67], a[12:15], v249, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[104:107], v[64:67], a[28:31], v250, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[104:107], v[16:19], a[24:27], v250, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[108:111], v[16:19], a[40:43], v250, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[108:111], v[64:67], a[44:47], v250, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[108:111], v[68:71], a[48:51], v250, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[104:107], v[68:71], a[32:35], v250, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[104:107], v[72:75], a[36:39], v250, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[108:111], v[72:75], a[52:55], v250, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[112:115], v[72:75], a[68:71], v251, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[112:115], v[68:71], a[64:67], v251, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[116:119], v[68:71], a[80:83], v251, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[116:119], v[72:75], a[84:87], v251, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[116:119], v[16:19], a[72:75], v251, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[112:115], v[16:19], a[56:59], v251, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[112:115], v[64:67], a[60:63], v251, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[116:119], v[64:67], a[76:79], v251, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[16:19], v0 offset:32768
		ds_read_b128 v[64:67], v0 offset:33792
		ds_read_b128 v[68:71], v0 offset:34816
		ds_read_b128 v[72:75], v0 offset:35840
		ds_read_b128 a[88:91], v0 offset:36864
		ds_read_b128 a[92:95], v0 offset:37888
		ds_read_b128 a[96:99], v0 offset:38912
		ds_read_b128 a[100:103], v0 offset:39936
		ds_read_b128 a[104:107], v0 offset:40960
		ds_read_b128 a[108:111], v0 offset:41984
		ds_read_b128 a[112:115], v0 offset:43008
		ds_read_b128 a[116:119], v0 offset:44032
		ds_read_b128 a[180:183], v0 offset:45056
		ds_read_b128 a[184:187], v0 offset:46080
		ds_read_b128 a[188:191], v0 offset:47104
		ds_read_b128 a[192:195], v0 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[120:123], v[8:11], v[32:35], v28, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[120:123], v[20:23], v[60:63], v28, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[124:127], v[20:23], v[44:47], v28, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[124:127], v[8:11], v[48:51], v28, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[124:127], v[24:27], v[40:43], v28, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[120:123], v[24:27], v[56:59], v28, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[120:123], v[228:231], v[52:55], v28, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[232:235], v79, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[124:127], v[228:231], v[36:39], v28, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[236:239], v77, s[20:23], s3 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[128:131], v[228:231], v[100:103], v29, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[128:131], v[24:27], v[96:99], v29, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[132:135], v[24:27], v[112:115], v29, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[132:135], v[228:231], v[116:119], v29, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[132:135], v[8:11], v[104:107], v29, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[128:131], v[8:11], v[88:91], v29, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[128:131], v[20:23], v[92:95], v29, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[240:243], v81, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[132:135], v[20:23], v[108:111], v29, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[244:247], v82, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[136:139], v[20:23], v[124:127], v86, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[136:139], v[8:11], v[120:123], v86, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[140:143], v[8:11], v[136:139], v86, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[140:143], v[20:23], v[140:143], v86, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[140:143], v[24:27], v[144:147], v86, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[136:139], v[24:27], v[128:131], v86, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[136:139], v[228:231], v[132:135], v86, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[140:143], v[228:231], v[148:151], v86, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[144:147], v[228:231], v[164:167], v87, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[144:147], v[24:27], v[160:163], v87, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[148:151], v[24:27], v[176:179], v87, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[148:151], v[228:231], v[180:183], v87, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[148:151], v[8:11], v[168:171], v87, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[144:147], v[8:11], v[152:155], v87, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[144:147], v[20:23], v[156:159], v87, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[148:151], v[20:23], v[172:175], v87, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[152:155], v[20:23], v[188:191], v248, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[152:155], v[8:11], v[184:187], v248, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[156:159], v[8:11], v[200:203], v248, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[156:159], v[20:23], v[204:207], v248, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[156:159], v[24:27], v[208:211], v248, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[152:155], v[24:27], v[192:195], v248, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[152:155], v[228:231], v[196:199], v248, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[156:159], v[228:231], v[212:215], v248, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[160:163], v[228:231], a[4:7], v249, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[160:163], v[24:27], v[224:227], v249, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[164:167], v[24:27], a[16:19], v249, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[164:167], v[228:231], a[20:23], v249, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[8:11], a[8:11], v249, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[160:163], v[8:11], v[216:219], v249, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[160:163], v[20:23], v[220:223], v249, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[164:167], v[20:23], a[12:15], v249, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[168:171], v[20:23], a[28:31], v250, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[8:11], a[24:27], v250, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[8:11], a[40:43], v250, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[172:175], v[20:23], a[44:47], v250, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[172:175], v[24:27], a[48:51], v250, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[168:171], v[24:27], a[32:35], v250, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[168:171], v[228:231], a[36:39], v250, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[172:175], v[228:231], a[52:55], v250, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[176:179], v[228:231], a[68:71], v251, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[176:179], v[24:27], a[64:67], v251, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[24:27], a[80:83], v251, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[228:231], a[84:87], v251, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[252:255], v[8:11], a[72:75], v251, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[8:11], a[56:59], v251, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[176:179], v[20:23], a[60:63], v251, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[20:23], a[76:79], v251, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read2st64_b32 v[6:7], v4 offset0:8 offset1:9
		ds_read2st64_b32 v[8:9], v4 offset0:10 offset1:11
		ds_read2st64_b32 v[10:11], v4 offset0:12 offset1:13
		ds_read2st64_b32 v[20:21], v4 offset0:14 offset1:15
		ds_read2st64_b32 v[22:23], v5 offset0:18 offset1:19
		ds_read_b128 a[120:123], v0 offset:49152
		ds_read_b128 a[124:127], v0 offset:50176
		ds_read_b128 a[128:131], v0 offset:51200
		ds_read_b128 a[132:135], v0 offset:52224
		ds_read_b128 a[136:139], v0 offset:53248
		ds_read_b128 a[140:143], v0 offset:54272
		ds_read_b128 a[144:147], v0 offset:55296
		ds_read_b128 a[148:151], v0 offset:56320
		ds_read_b128 a[152:155], v0 offset:57344
		ds_read_b128 a[156:159], v0 offset:58368
		ds_read_b128 a[160:163], v0 offset:59392
		ds_read_b128 a[164:167], v0 offset:60416
		ds_read_b128 a[168:171], v0 offset:61440
		ds_read_b128 a[172:175], v0 offset:62464
		ds_read_b128 a[176:179], v0 offset:63488
		ds_read_b128 a[196:199], v0 offset:64512
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[16:19], v[232:235], v[32:35], v6, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[16:19], v[236:239], v[60:63], v6, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[64:67], v[236:239], v[44:47], v6, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[64:67], v[232:235], v[48:51], v6, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[64:67], v[240:243], v[40:43], v6, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[16:19], v[240:243], v[56:59], v6, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[16:19], v[244:247], v[52:55], v6, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[16:19], v80, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[64:67], v[244:247], v[36:39], v6, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[24:27], v83, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], v[244:247], v[100:103], v7, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[68:71], v[240:243], v[96:99], v7, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[72:75], v[240:243], v[112:115], v7, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[72:75], v[244:247], v[116:119], v7, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[72:75], v[232:235], v[104:107], v7, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[68:71], v[232:235], v[88:91], v7, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[68:71], v[236:239], v[92:95], v7, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[64:67], v84, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[72:75], v[236:239], v[108:111], v7, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[68:71], v1, s[20:23], s3 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], v[236:239], v[124:127], v8, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[88:91], v[232:235], v[120:123], v8, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], v[232:235], v[136:139], v8, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], v[236:239], v[140:143], v8, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], v[240:243], v[144:147], v8, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], v[240:243], v[128:131], v8, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], v[244:247], v[132:135], v8, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[72:75], v2, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], v[244:247], v[148:151], v8, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[228:231], v13, s[20:23], s2 offen
		s_waitcnt vmcnt(0)
		v_accvgpr_write_b32 a88, v228
		v_accvgpr_write_b32 a89, v229
		v_accvgpr_write_b32 a90, v230
		v_accvgpr_write_b32 a91, v231
		buffer_load_dwordx4 v[228:231], v14, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], v[244:247], v[164:167], v9, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], v[240:243], v[160:163], v9, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[100:103], v[240:243], v[176:179], v9, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[100:103], v[244:247], v[180:183], v9, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[100:103], v[232:235], v[168:171], v9, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], v[232:235], v[152:155], v9, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[96:99], v[236:239], v[156:159], v9, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v12, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[100:103], v[236:239], v[172:175], v9, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[252:255], v31, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[104:107], v[236:239], v[188:191], v10, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[104:107], v[232:235], v[184:187], v10, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[108:111], v[232:235], v[200:203], v10, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[108:111], v[236:239], v[204:207], v10, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[108:111], v[240:243], v[208:211], v10, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[104:107], v[240:243], v[192:195], v10, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[104:107], v[244:247], v[196:199], v10, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[28:31], v76, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[108:111], v[244:247], v[212:215], v10, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[112:115], v[244:247], a[4:7], v11, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[112:115], v[240:243], v[224:227], v11, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[116:119], v[240:243], a[16:19], v11, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[116:119], v[244:247], a[20:23], v11, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[116:119], v[232:235], a[8:11], v11, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[112:115], v[232:235], v[216:219], v11, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[112:115], v[236:239], v[220:223], v11, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[116:119], v[236:239], a[12:15], v11, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[180:183], v[236:239], a[28:31], v20, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[180:183], v[232:235], a[24:27], v20, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[184:187], v[232:235], a[40:43], v20, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[184:187], v[236:239], a[44:47], v20, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[184:187], v[240:243], a[48:51], v20, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[180:183], v[240:243], a[32:35], v20, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[180:183], v[244:247], a[36:39], v20, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[184:187], v[244:247], a[52:55], v20, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[188:191], v[244:247], a[68:71], v21, v23 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[188:191], v[240:243], a[64:67], v21, v23 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[192:195], v[240:243], a[80:83], v21, v23 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[192:195], v[244:247], a[84:87], v21, v23 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[192:195], v[232:235], a[72:75], v21, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[188:191], v[232:235], a[56:59], v21, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[188:191], v[236:239], a[60:63], v21, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[192:195], v[236:239], a[76:79], v21, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[120:123], v[16:19], v[32:35], v6, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[120:123], v[24:27], v[60:63], v6, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[124:127], v[24:27], v[44:47], v6, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[124:127], v[16:19], v[48:51], v6, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[124:127], v[64:67], v[40:43], v6, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[120:123], v[64:67], v[56:59], v6, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[120:123], v[68:71], v[52:55], v6, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[124:127], v[68:71], v[36:39], v6, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[128:131], v[68:71], v[100:103], v7, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[128:131], v[64:67], v[96:99], v7, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[132:135], v[64:67], v[112:115], v7, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[132:135], v[68:71], v[116:119], v7, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[132:135], v[16:19], v[104:107], v7, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[128:131], v[16:19], v[88:91], v7, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[128:131], v[24:27], v[92:95], v7, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[132:135], v[24:27], v[108:111], v7, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[136:139], v[24:27], v[124:127], v8, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[136:139], v[16:19], v[120:123], v8, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[140:143], v[16:19], v[136:139], v8, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[140:143], v[24:27], v[140:143], v8, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[140:143], v[64:67], v[144:147], v8, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[136:139], v[64:67], v[128:131], v8, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[136:139], v[68:71], v[132:135], v8, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[140:143], v[68:71], v[148:151], v8, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[144:147], v[68:71], v[164:167], v9, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[144:147], v[64:67], v[160:163], v9, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[148:151], v[64:67], v[176:179], v9, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[148:151], v[68:71], v[180:183], v9, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[148:151], v[16:19], v[168:171], v9, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[144:147], v[16:19], v[152:155], v9, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[144:147], v[24:27], v[156:159], v9, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[148:151], v[24:27], v[172:175], v9, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[152:155], v[24:27], v[188:191], v10, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[152:155], v[16:19], v[184:187], v10, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[156:159], v[16:19], v[200:203], v10, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[156:159], v[24:27], v[204:207], v10, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[156:159], v[64:67], v[208:211], v10, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[152:155], v[64:67], v[192:195], v10, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[152:155], v[68:71], v[196:199], v10, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[156:159], v[68:71], v[212:215], v10, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[160:163], v[68:71], a[4:7], v11, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[160:163], v[64:67], v[224:227], v11, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[164:167], v[64:67], a[16:19], v11, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[164:167], v[68:71], a[20:23], v11, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[16:19], a[8:11], v11, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[160:163], v[16:19], v[216:219], v11, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[160:163], v[24:27], v[220:223], v11, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[164:167], v[24:27], a[12:15], v11, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[168:171], v[24:27], a[28:31], v20, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[16:19], a[24:27], v20, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[16:19], a[40:43], v20, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[172:175], v[24:27], a[44:47], v20, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[172:175], v[64:67], a[48:51], v20, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[168:171], v[64:67], a[32:35], v20, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[168:171], v[68:71], a[36:39], v20, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[172:175], v[68:71], a[52:55], v20, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[176:179], v[68:71], a[68:71], v21, v23 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[176:179], v[64:67], a[64:67], v21, v23 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[196:199], v[64:67], a[80:83], v21, v23 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[196:199], v[68:71], a[84:87], v21, v23 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[196:199], v[16:19], a[72:75], v21, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[16:19], a[56:59], v21, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[176:179], v[24:27], a[60:63], v21, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[196:199], v[24:27], a[76:79], v21, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		v_accvgpr_read_b32 v0, a1
		v_add_u32_e32 v0, 0x10000, v0
		v_accvgpr_read_b32 v2, a2
		v_lshl_add_u32 v0, v2, 4, v0
		ds_read_b128 v[8:11], v0
		ds_read_b128 v[16:19], v0 offset:1024
		ds_read_b128 v[20:23], v0 offset:2048
		ds_read_b128 v[24:27], v0 offset:3072
		ds_read_b128 v[64:67], v0 offset:4096
		ds_read_b128 v[68:71], v0 offset:5120
		ds_read_b128 v[232:235], v0 offset:6144
		ds_read_b128 v[236:239], v0 offset:7168
		ds_read_b128 v[240:243], v0 offset:8192
		ds_read_b128 a[92:95], v0 offset:9216
		ds_read_b128 a[96:99], v0 offset:10240
		ds_read_b128 a[100:103], v0 offset:11264
		ds_read_b128 a[104:107], v0 offset:12288
		ds_read_b128 a[108:111], v0 offset:13312
		ds_read_b128 a[112:115], v0 offset:14336
		ds_read_b128 a[116:119], v0 offset:15360
		ds_read_b32 v2, v4 offset:8192
		ds_read_b32 v6, v4 offset:8448
		ds_read_b32 v7, v4 offset:8704
		ds_read_b32 v12, v4 offset:8960
		ds_read_b32 v13, v4 offset:9216
		ds_read_b32 v14, v4 offset:9472
		ds_read_b32 v76, v4 offset:9728
		ds_read_b32 v85, v4 offset:9984
		ds_read_b32 v86, v5 offset:12288
		ds_read_b32 v87, v5 offset:12544
		ds_read_b128 a[120:123], v0 offset:16384
		ds_read_b128 a[124:127], v0 offset:17408
		ds_read_b128 a[128:131], v0 offset:18432
		ds_read_b128 a[132:135], v0 offset:19456
		ds_read_b128 a[136:139], v0 offset:20480
		ds_read_b128 a[140:143], v0 offset:21504
		ds_read_b128 a[144:147], v0 offset:22528
		ds_read_b128 a[148:151], v0 offset:23552
		ds_read_b128 a[152:155], v0 offset:24576
		ds_read_b128 a[156:159], v0 offset:25600
		ds_read_b128 a[160:163], v0 offset:26624
		ds_read_b128 a[164:167], v0 offset:27648
		ds_read_b128 a[168:171], v0 offset:28672
		ds_read_b128 a[172:175], v0 offset:29696
		ds_read_b128 a[176:179], v0 offset:30720
		ds_read_b128 a[180:183], v0 offset:31744
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[8:11], v[72:75], v[32:35], v2, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[8:11], a[88:91], v[60:63], v2, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[16:19], a[88:91], v[44:47], v2, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[16:19], v[72:75], v[48:51], v2, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[16:19], v[228:231], v[40:43], v2, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[8:11], v[228:231], v[56:59], v2, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[8:11], v[248:251], v[52:55], v2, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[8:11], v15, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[16:19], v[248:251], v[36:39], v2, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[16:19], v78, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[248:251], v[100:103], v6, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[228:231], v[96:99], v6, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[24:27], v[228:231], v[112:115], v6, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[248:251], v[116:119], v6, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[72:75], v[104:107], v6, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[72:75], v[88:91], v6, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], a[88:91], v[92:95], v6, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[20:23], v79, s[20:23], s2 offen
		buffer_load_dwordx4 v[244:247], v77, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[24:27], a[88:91], v[108:111], v6, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[24:27], v81, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], a[88:91], v[124:127], v7, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[72:75], v[120:123], v7, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[72:75], v[136:139], v7, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], a[88:91], v[140:143], v7, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[228:231], v[144:147], v7, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], v[228:231], v[128:131], v7, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], v[248:251], v[132:135], v7, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[248:251], v[148:151], v7, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[248:251], v[164:167], v12, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[228:231], v[160:163], v12, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[236:239], v[228:231], v[176:179], v12, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[236:239], v[248:251], v[180:183], v12, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[236:239], v[72:75], v[168:171], v12, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[72:75], v[152:155], v12, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[232:235], a[88:91], v[156:159], v12, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[236:239], a[88:91], v[172:175], v12, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], a[88:91], v[188:191], v13, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[72:75], v[184:187], v13, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], v[72:75], v[200:203], v13, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], a[88:91], v[204:207], v13, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], v[228:231], v[208:211], v13, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[228:231], v[192:195], v13, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[248:251], v[196:199], v13, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], v[248:251], v[212:215], v13, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[96:99], v[248:251], a[4:7], v14, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[96:99], v[228:231], v[224:227], v14, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[100:103], v[228:231], a[16:19], v14, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[100:103], v[248:251], a[20:23], v14, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[100:103], v[72:75], a[8:11], v14, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], v[72:75], v[216:219], v14, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[96:99], a[88:91], v[220:223], v14, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[100:103], a[88:91], a[12:15], v14, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[104:107], a[88:91], a[28:31], v76, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[104:107], v[72:75], a[24:27], v76, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[108:111], v[72:75], a[40:43], v76, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[108:111], a[88:91], a[44:47], v76, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[108:111], v[228:231], a[48:51], v76, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[104:107], v[228:231], a[32:35], v76, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[104:107], v[248:251], a[36:39], v76, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[108:111], v[248:251], a[52:55], v76, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[112:115], v[248:251], a[68:71], v85, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[112:115], v[228:231], a[64:67], v85, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[116:119], v[228:231], a[80:83], v85, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[116:119], v[248:251], a[84:87], v85, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[116:119], v[72:75], a[72:75], v85, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[112:115], v[72:75], a[56:59], v85, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[112:115], a[88:91], a[60:63], v85, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[116:119], a[88:91], a[76:79], v85, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b128 v[64:67], v0 offset:32768
		ds_read_b128 v[68:71], v0 offset:33792
		ds_read_b128 v[72:75], v0 offset:34816
		ds_read_b128 v[228:231], v0 offset:35840
		ds_read_b128 a[88:91], v0 offset:36864
		ds_read_b128 a[92:95], v0 offset:37888
		ds_read_b128 a[96:99], v0 offset:38912
		ds_read_b128 a[100:103], v0 offset:39936
		ds_read_b128 a[104:107], v0 offset:40960
		ds_read_b128 a[108:111], v0 offset:41984
		ds_read_b128 a[112:115], v0 offset:43008
		ds_read_b128 a[116:119], v0 offset:44032
		ds_read_b128 a[184:187], v0 offset:45056
		ds_read_b128 a[188:191], v0 offset:46080
		ds_read_b128 a[192:195], v0 offset:47104
		ds_read_b128 a[196:199], v0 offset:48128
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[120:123], v[252:255], v[32:35], v2, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[120:123], v[28:31], v[60:63], v2, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[124:127], v[28:31], v[44:47], v2, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[124:127], v[252:255], v[48:51], v2, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[124:127], v[8:11], v[40:43], v2, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[120:123], v[8:11], v[56:59], v2, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[120:123], v[16:19], v[52:55], v2, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[232:235], v82, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[124:127], v[16:19], v[36:39], v2, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[236:239], v80, s[20:23], s2 offen
		buffer_load_dwordx4 v[240:243], v83, s[20:23], s2 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[128:131], v[16:19], v[100:103], v6, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[128:131], v[8:11], v[96:99], v6, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[132:135], v[8:11], v[112:115], v6, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[132:135], v[16:19], v[116:119], v6, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[132:135], v[252:255], v[104:107], v6, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[128:131], v[252:255], v[88:91], v6, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[128:131], v[28:31], v[92:95], v6, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[80:83], v84, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[132:135], v[28:31], v[108:111], v6, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[248:251], v1, s[20:23], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[136:139], v[28:31], v[124:127], v7, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[136:139], v[252:255], v[120:123], v7, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[140:143], v[252:255], v[136:139], v7, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[140:143], v[28:31], v[140:143], v7, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[140:143], v[8:11], v[144:147], v7, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[136:139], v[8:11], v[128:131], v7, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[136:139], v[16:19], v[132:135], v7, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[140:143], v[16:19], v[148:151], v7, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[144:147], v[16:19], v[164:167], v12, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[144:147], v[8:11], v[160:163], v12, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[148:151], v[8:11], v[176:179], v12, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[148:151], v[16:19], v[180:183], v12, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[148:151], v[252:255], v[168:171], v12, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[144:147], v[252:255], v[152:155], v12, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[144:147], v[28:31], v[156:159], v12, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[148:151], v[28:31], v[172:175], v12, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[152:155], v[28:31], v[188:191], v13, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[152:155], v[252:255], v[184:187], v13, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[156:159], v[252:255], v[200:203], v13, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[156:159], v[28:31], v[204:207], v13, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[156:159], v[8:11], v[208:211], v13, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[152:155], v[8:11], v[192:195], v13, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[152:155], v[16:19], v[196:199], v13, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[156:159], v[16:19], v[212:215], v13, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[160:163], v[16:19], a[4:7], v14, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[160:163], v[8:11], v[224:227], v14, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[164:167], v[8:11], a[16:19], v14, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[164:167], v[16:19], a[20:23], v14, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[252:255], a[8:11], v14, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[160:163], v[252:255], v[216:219], v14, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[160:163], v[28:31], v[220:223], v14, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[164:167], v[28:31], a[12:15], v14, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[168:171], v[28:31], a[28:31], v76, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[252:255], a[24:27], v76, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[252:255], a[40:43], v76, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[172:175], v[28:31], a[44:47], v76, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[172:175], v[8:11], a[48:51], v76, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[168:171], v[8:11], a[32:35], v76, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[168:171], v[16:19], a[36:39], v76, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[172:175], v[16:19], a[52:55], v76, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[176:179], v[16:19], a[68:71], v85, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[176:179], v[8:11], a[64:67], v85, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[180:183], v[8:11], a[80:83], v85, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[180:183], v[16:19], a[84:87], v85, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], v[252:255], a[72:75], v85, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[252:255], a[56:59], v85, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[176:179], v[28:31], a[60:63], v85, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[180:183], v[28:31], a[76:79], v85, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		ds_read_b32 v1, v4 offset:10240
		ds_read_b32 v2, v4 offset:10496
		ds_read_b32 v6, v4 offset:10752
		ds_read_b32 v7, v4 offset:11008
		ds_read_b32 v8, v4 offset:11264
		ds_read_b32 v9, v4 offset:11520
		ds_read_b32 v10, v4 offset:11776
		ds_read_b32 v11, v4 offset:12032
		ds_read_b32 v4, v5 offset:12800
		ds_read_b32 v12, v5 offset:13056
		ds_read_b128 v[16:19], v0 offset:49152
		ds_read_b128 v[28:31], v0 offset:50176
		ds_read_b128 v[76:79], v0 offset:51200
		ds_read_b128 v[84:87], v0 offset:52224
		ds_read_b128 a[120:123], v0 offset:53248
		ds_read_b128 a[124:127], v0 offset:54272
		ds_read_b128 a[128:131], v0 offset:55296
		ds_read_b128 a[132:135], v0 offset:56320
		ds_read_b128 a[136:139], v0 offset:57344
		ds_read_b128 a[140:143], v0 offset:58368
		ds_read_b128 a[144:147], v0 offset:59392
		ds_read_b128 a[148:151], v0 offset:60416
		ds_read_b128 a[152:155], v0 offset:61440
		ds_read_b128 a[156:159], v0 offset:62464
		ds_read_b128 a[160:163], v0 offset:63488
		ds_read_b128 v[252:255], v0 offset:64512
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[64:67], v[20:23], v[32:35], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[64:67], v[244:247], v[60:63], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[68:71], v[244:247], v[44:47], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[68:71], v[20:23], v[48:51], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[68:71], v[24:27], v[40:43], v1, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[64:67], v[24:27], v[56:59], v1, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[64:67], v[232:235], v[52:55], v1, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[68:71], v[232:235], v[36:39], v1, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[72:75], v[232:235], v[100:103], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[72:75], v[24:27], v[96:99], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[228:231], v[24:27], v[112:115], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[228:231], v[232:235], v[116:119], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[228:231], v[20:23], v[104:107], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[72:75], v[20:23], v[88:91], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[72:75], v[244:247], v[92:95], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[228:231], v[244:247], v[108:111], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[88:91], v[244:247], v[124:127], v6, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[88:91], v[20:23], v[120:123], v6, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[92:95], v[20:23], v[136:139], v6, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[92:95], v[244:247], v[140:143], v6, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[92:95], v[24:27], v[144:147], v6, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[88:91], v[24:27], v[128:131], v6, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[88:91], v[232:235], v[132:135], v6, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[92:95], v[232:235], v[148:151], v6, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[96:99], v[232:235], v[164:167], v7, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[96:99], v[24:27], v[160:163], v7, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[100:103], v[24:27], v[176:179], v7, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[100:103], v[232:235], v[180:183], v7, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[100:103], v[20:23], v[168:171], v7, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[96:99], v[20:23], v[152:155], v7, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[96:99], v[244:247], v[156:159], v7, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[100:103], v[244:247], v[172:175], v7, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[104:107], v[244:247], v[188:191], v8, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[104:107], v[20:23], v[184:187], v8, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[108:111], v[20:23], v[200:203], v8, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[108:111], v[244:247], v[204:207], v8, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[108:111], v[24:27], v[208:211], v8, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[104:107], v[24:27], v[192:195], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[104:107], v[232:235], v[196:199], v8, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[108:111], v[232:235], v[212:215], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[112:115], v[232:235], a[4:7], v9, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[112:115], v[24:27], v[224:227], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[116:119], v[24:27], a[16:19], v9, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[116:119], v[232:235], a[20:23], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[116:119], v[20:23], a[8:11], v9, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[112:115], v[20:23], v[216:219], v9, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[112:115], v[244:247], v[220:223], v9, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[116:119], v[244:247], a[12:15], v9, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[184:187], v[244:247], a[28:31], v10, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[184:187], v[20:23], a[24:27], v10, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[188:191], v[20:23], a[40:43], v10, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[188:191], v[244:247], a[44:47], v10, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[188:191], v[24:27], a[48:51], v10, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[184:187], v[24:27], a[32:35], v10, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[184:187], v[232:235], a[36:39], v10, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[188:191], v[232:235], a[52:55], v10, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[192:195], v[232:235], a[68:71], v11, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[192:195], v[24:27], a[64:67], v11, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[196:199], v[24:27], a[80:83], v11, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[196:199], v[232:235], a[84:87], v11, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[196:199], v[20:23], a[72:75], v11, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[192:195], v[20:23], a[56:59], v11, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[192:195], v[244:247], a[60:63], v11, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[196:199], v[244:247], a[76:79], v11, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[16:19], v[236:239], v[32:35], v1, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v0, a0
		v_lshlrev_b32_e32 v0, 1, v0
		v_lshl_add_u32 v0, v3, 16, v0
		s_lshl_b32 s0, s0, 7
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[16:19], v[240:243], v[60:63], v1, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s5, 24
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s13, 9
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[28:31], v[240:243], v[44:47], v1, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v3, v32
		s_add_i32 s2, s2, s3
		s_lshl_b32 s4, s14, 22
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[28:31], v[236:239], v[48:51], v1, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s2, s2, s4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[28:31], v[80:83], v[40:43], v1, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[16:19], v[80:83], v[56:59], v1, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[16:19], v[248:251], v[52:55], v1, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[28:31], v[248:251], v[36:39], v1, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[76:79], v[248:251], v[100:103], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[76:79], v[80:83], v[96:99], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[84:87], v[80:83], v[112:115], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[84:87], v[248:251], v[116:119], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[84:87], v[236:239], v[104:107], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[76:79], v[236:239], v[88:91], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[76:79], v[240:243], v[92:95], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[84:87], v[240:243], v[108:111], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[120:123], v[240:243], v[124:127], v6, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[120:123], v[236:239], v[120:123], v6, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[124:127], v[236:239], v[136:139], v6, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[124:127], v[240:243], v[140:143], v6, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[124:127], v[80:83], v[144:147], v6, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[120:123], v[80:83], v[128:131], v6, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[120:123], v[248:251], v[132:135], v6, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[124:127], v[248:251], v[148:151], v6, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[128:131], v[248:251], v[164:167], v7, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[128:131], v[80:83], v[160:163], v7, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[132:135], v[80:83], v[176:179], v7, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[132:135], v[248:251], v[180:183], v7, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[132:135], v[236:239], v[168:171], v7, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[128:131], v[236:239], v[152:155], v7, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[128:131], v[240:243], v[156:159], v7, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[132:135], v[240:243], v[172:175], v7, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[136:139], v[240:243], v[188:191], v8, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[136:139], v[236:239], v[184:187], v8, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[140:143], v[236:239], v[200:203], v8, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[140:143], v[240:243], v[204:207], v8, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[140:143], v[80:83], v[208:211], v8, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[136:139], v[80:83], v[192:195], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[136:139], v[248:251], v[196:199], v8, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[140:143], v[248:251], v[212:215], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[144:147], v[248:251], a[4:7], v9, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[144:147], v[80:83], v[224:227], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[148:151], v[80:83], a[16:19], v9, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[148:151], v[248:251], a[20:23], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[148:151], v[236:239], a[8:11], v9, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[144:147], v[236:239], v[216:219], v9, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[144:147], v[240:243], v[220:223], v9, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[148:151], v[240:243], a[12:15], v9, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[152:155], v[240:243], a[28:31], v10, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[152:155], v[236:239], a[24:27], v10, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[156:159], v[236:239], a[40:43], v10, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[156:159], v[240:243], a[44:47], v10, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[156:159], v[80:83], a[48:51], v10, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[152:155], v[80:83], a[32:35], v10, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[152:155], v[248:251], a[36:39], v10, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[156:159], v[248:251], a[52:55], v10, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[160:163], v[248:251], a[68:71], v11, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[160:163], v[80:83], a[64:67], v11, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[80:83], a[80:83], v11, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[248:251], a[84:87], v11, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[252:255], v[236:239], a[72:75], v11, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[160:163], v[236:239], a[56:59], v11, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[160:163], v[240:243], a[60:63], v11, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[240:243], a[76:79], v11, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s35, s23
		buffer_store_short v3, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v33
		s_add_i32 s5, s0, 0x4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v34
		s_add_i32 s6, s0, 0x8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v35
		s_add_i32 s7, s0, 0xc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v60
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v61
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v62
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v63
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v56
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v57
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v58
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v59
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v52
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v53
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v54
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v55
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v48
		s_add_i32 s2, s0, 0x40000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v49
		s_add_i32 s5, s0, 0x44000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v50
		s_add_i32 s6, s0, 0x48000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v51
		s_add_i32 s7, s0, 0x4c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v44
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v45
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v46
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v47
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v40
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v41
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v42
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v43
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v36
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v37
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v38
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v39
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v88
		s_add_i32 s2, s0, 0x80000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v89
		s_add_i32 s5, s0, 0x84000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v90
		s_add_i32 s6, s0, 0x88000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v91
		s_add_i32 s7, s0, 0x8c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v92
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v93
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v94
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v95
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v96
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v97
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v98
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v99
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v100
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v101
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v102
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v103
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v104
		s_add_i32 s2, s0, 0xc0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v105
		s_add_i32 s5, s0, 0xc4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v106
		s_add_i32 s6, s0, 0xc8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v107
		s_add_i32 s7, s0, 0xcc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v108
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v109
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v110
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v111
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v112
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v113
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v114
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v115
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v116
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v117
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v118
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v119
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v120
		s_add_i32 s2, s0, 0x100000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v121
		s_add_i32 s5, s0, 0x104000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v122
		s_add_i32 s6, s0, 0x108000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v123
		s_add_i32 s7, s0, 0x10c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v124
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v125
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v126
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v127
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v128
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v129
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v130
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v131
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v132
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v133
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v134
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v135
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v136
		s_add_i32 s2, s0, 0x140000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v137
		s_add_i32 s5, s0, 0x144000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v138
		s_add_i32 s6, s0, 0x148000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v139
		s_add_i32 s7, s0, 0x14c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v140
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v141
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v142
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v143
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v144
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v145
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v146
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v147
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v148
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v149
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v150
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v151
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v152
		s_add_i32 s2, s0, 0x180000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v153
		s_add_i32 s5, s0, 0x184000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v154
		s_add_i32 s6, s0, 0x188000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v155
		s_add_i32 s7, s0, 0x18c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v156
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v157
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v158
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v159
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v160
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v161
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v162
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v163
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v164
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v165
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v166
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v167
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v168
		s_add_i32 s2, s0, 0x1c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v169
		s_add_i32 s5, s0, 0x1c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v170
		s_add_i32 s6, s0, 0x1c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v171
		s_add_i32 s7, s0, 0x1cc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v172
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v173
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v174
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v175
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v176
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v177
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v178
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v179
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v180
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v181
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v182
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v183
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v184
		s_add_i32 s2, s0, 0x200000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v185
		s_add_i32 s5, s0, 0x204000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v186
		s_add_i32 s6, s0, 0x208000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v187
		s_add_i32 s7, s0, 0x20c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v188
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v189
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v190
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v191
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v192
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v193
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v194
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v195
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v196
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v197
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v198
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v199
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v200
		s_add_i32 s2, s0, 0x240000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v201
		s_add_i32 s5, s0, 0x244000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v202
		s_add_i32 s6, s0, 0x248000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v203
		s_add_i32 s7, s0, 0x24c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v204
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v205
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v206
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v207
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v208
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v209
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v210
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v211
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v212
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v213
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v214
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v215
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v216
		s_add_i32 s2, s0, 0x280000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v217
		s_add_i32 s5, s0, 0x284000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v218
		s_add_i32 s6, s0, 0x288000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v219
		s_add_i32 s7, s0, 0x28c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v220
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v221
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v222
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v223
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v224
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v225
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v226
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v227
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a4
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a5
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a6
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a7
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a8
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x2c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a9
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x2c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a10
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x2c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a11
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s7, s0, 0x2cc000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_accvgpr_read_b32 v1, a12
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a13
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a14
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a15
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a16
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a17
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a18
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a19
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a20
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a21
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a22
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a23
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a24
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x300000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a25
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x304000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a26
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x308000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a27
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s7, s0, 0x30c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_accvgpr_read_b32 v1, a28
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a29
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a30
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a31
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a32
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a33
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a34
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a35
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a36
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a37
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a38
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a39
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a40
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x340000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a41
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x344000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a42
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x348000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a43
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s7, s0, 0x34c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_accvgpr_read_b32 v1, a44
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a45
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a46
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a47
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a48
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a49
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a50
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a51
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a52
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a53
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a54
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a55
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a56
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x380000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a57
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x384000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a58
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x388000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a59
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s7, s0, 0x38c000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		buffer_store_short v1, v0, s[32:35], s7 offen sc0 nt
		v_accvgpr_read_b32 v1, a60
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a61
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a62
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a63
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a64
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a65
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a66
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a67
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a68
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a69
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a70
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a71
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s7 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a72
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x3c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a73
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x3c4000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		s_add_i32 s5, s5, s4
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a74
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x3c8000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		s_add_i32 s6, s6, s4
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a75
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s0, s0, 0x3cc000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		s_add_i32 s0, s0, s4
		buffer_store_short v1, v0, s[32:35], s0 offen sc0 nt
		v_accvgpr_read_b32 v1, a76
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a77
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a78
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a79
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s0 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a80
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a81
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a82
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a83
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s0 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a84
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a85
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a86
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a87
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s0 offen offset:96 sc0 nt
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 256
	.set .Lwmma_f16_matmul_tiled.num_agpr, 216
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 47
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
    .sgpr_count:     47
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     472
    .agpr_count:     216
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 187
    wave.regalloc.agpr.dwords: 735
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
