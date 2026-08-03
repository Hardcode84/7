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
		s_lshr_b32 s5, s14, 4
		s_lshl_b32 s12, s5, 21
		s_lshl_b32 s14, s14, 3
		s_add_i32 s13, s13, s14
		s_and_b32 s13, s13, 0x7f
		s_and_b32 s14, s13, 3
		s_lshl_b32 s15, s14, 19
		s_add_i32 s28, s12, s15
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshl_add_u32 v2, v1, 15, s28
		v_and_b32_e32 v3, 63, v0
		v_lshrrev_b32_e32 v4, 2, v3
		v_lshlrev_b32_e32 v4, 11, v4
		v_lshrrev_b32_e32 v5, 3, v3
		v_bitop3_b32 v5, v5, 3, v3 bitop3:0x48
		v_lshlrev_b32_e32 v5, 4, v5
		s_add_i32 s28, s12, 0x20000
		s_add_i32 s28, s28, s15
		v_lshl_add_u32 v6, v1, 15, v4
		s_add_i32 s29, s12, 0x40000
		s_add_i32 s29, s29, s15
		s_add_i32 s30, s12, 0x60000
		s_add_i32 s30, s30, s15
		s_add_i32 s31, s12, 64
		s_add_i32 s31, s31, s15
		v_lshl_add_u32 v7, v1, 15, v4
		s_add_i32 s32, s12, 0x20040
		s_add_i32 s32, s32, s15
		s_add_i32 s33, s12, 0x40040
		s_add_i32 s33, s33, s15
		s_add_i32 s34, s12, 0x60040
		s_add_i32 s34, s34, s15
		v_lshl_add_u32 v8, v1, 15, v4
		s_add_i32 s35, s12, 0x80
		s_add_i32 s35, s35, s15
		s_add_i32 s36, s12, 0x20080
		s_add_i32 s36, s36, s15
		s_add_i32 s37, s12, 0x40080
		s_add_i32 s37, s37, s15
		v_lshl_add_u32 v9, v1, 15, v4
		s_add_i32 s38, s12, 0x60080
		s_add_i32 s38, s38, s15
		s_add_i32 s39, s12, 0xc0
		s_add_i32 s39, s39, s15
		s_add_i32 s40, s12, 0x200c0
		s_add_i32 s40, s40, s15
		v_lshl_add_u32 v10, v1, 15, v4
		s_add_i32 s41, s12, 0x400c0
		s_add_i32 s41, s41, s15
		s_add_i32 s12, s12, 0x600c0
		s_add_i32 s12, s12, s15
		s_lshr_b32 s4, s4, 6
		s_lshl_b32 s15, s4, 10
		s_mov_b32 m0, s15
		v_add3_u32 v2, v2, v4, v5
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		v_add3_u32 v4, v5, v6, s28
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v11, v5, v6, s29
		v_add3_u32 v6, v5, v6, s30
		v_add3_u32 v12, v5, v7, s31
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v13, v5, v7, s32
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v7, v5, v7, s33
		v_add3_u32 v14, v5, v8, s34
		v_add3_u32 v15, v5, v8, s35
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_add3_u32 v8, v5, v8, s36
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, v5, v9, s37
		v_add3_u32 v17, v5, v9, s38
		v_add3_u32 v9, v5, v9, s39
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_add3_u32 v18, v5, v10, s40
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s28, 0x100
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_mov_b32 s29, 0x7000
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v19, 2, v3
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		v_and_b32_e32 v20, 15, v0
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v21, 4, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v22, 15, v3
		v_accvgpr_write_b32 a0, v22
		v_lshrrev_b32_e32 v22, 4, v3
		v_lshrrev_b32_e32 v0, 7, v0
		v_lshlrev_b32_e32 v0, 8, v0
		v_lshl_add_u32 v23, s4, 2, v22
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		v_and_b32_e32 v23, 7, v23
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v23, 12, v23
		v_accvgpr_read_b32 v24, a0
		v_lshlrev_b32_e32 v24, 4, v24
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_and_b32_e32 v25, 1, v22
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v3, 5, v3
		v_lshlrev_b32_e32 v3, 8, v3
		v_lshl_add_u32 v3, s4, 13, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v25, 12, v25
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s8, 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s9, 0x1000
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v26, 6, v20
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v20, 1, v20
		v_bitop3_b32 v20, v22, v20, 3 bitop3:0x78
		v_accvgpr_write_b32 a1, v20
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		s_mov_b32 s34, 0x2000000
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v20, v5, v10, s41
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		v_add3_u32 v5, v5, v10, s12
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s12, 0x6000
		buffer_load_dwordx4 v20, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v10, 10, v1
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v0, v0, v23, v24
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v3, v3, v25, v24
		buffer_load_dwordx4 v2, s[16:19], s28 offen lds
		v_lshlrev_b32_e32 v1, 17, v1
		s_add_i32 m0, m0, 0x1000
		v_accvgpr_read_b32 v23, a1
		v_lshlrev_b32_e32 v23, 4, v23
		buffer_load_dwordx4 v4, s[16:19], s28 offen lds
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		buffer_load_dwordx4 v11, s[16:19], s28 offen lds
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		buffer_load_dwordx4 v6, s[16:19], s28 offen lds
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		buffer_load_dwordx4 v12, s[16:19], s28 offen lds
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		buffer_load_dwordx4 v13, s[16:19], s28 offen lds
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		buffer_load_dwordx4 v7, s[16:19], s28 offen lds
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		buffer_load_dwordx4 v14, s[16:19], s28 offen lds
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		buffer_load_dwordx4 v15, s[16:19], s28 offen lds
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		buffer_load_dwordx4 v8, s[16:19], s28 offen lds
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		buffer_load_dwordx4 v16, s[16:19], s28 offen lds
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		buffer_load_dwordx4 v17, s[16:19], s28 offen lds
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[116:117], 0
		v_mov_b64_e32 v[118:119], 0
		buffer_load_dwordx4 v9, s[16:19], s28 offen lds
		v_mov_b64_e32 v[120:121], 0
		v_mov_b64_e32 v[122:123], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[124:125], 0
		v_mov_b64_e32 v[126:127], 0
		buffer_load_dwordx4 v18, s[16:19], s28 offen lds
		s_lshr_b32 s10, s13, 2
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s11, s14, 15
		buffer_load_dwordx4 v20, s[16:19], s28 offen lds
		v_mov_b64_e32 v[128:129], 0
		v_mov_b64_e32 v[130:131], 0
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s13, s10, 19
		buffer_load_dwordx4 v5, s[16:19], s28 offen lds
		s_lshl_b32 s28, s5, 17
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s30, s28, s11
		v_add_u32_e32 v24, s30, v0
		v_add_u32_e32 v25, 0x400, v24
		buffer_load_dwordx4 v0, s[20:23], s30 offen lds
		s_lshl_b32 s30, s10, 15
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v24, s13, v1, v21
		buffer_load_dwordx4 v3, s[24:27], s30 offen lds
		v_add_u32_e32 v27, s30, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s28, s28, 0x200
		s_add_i32 s11, s28, s11
		v_add_u32_e32 v132, 0x400, v27
		buffer_load_dwordx4 v0, s[20:23], s11 offen lds
		s_add_i32 s11, s30, 0x200
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s28, s13, 0x8000
		v_add3_u32 v0, s28, v1, v21
		s_add_i32 s28, s13, 0x10000
		v_add3_u32 v27, s28, v1, v21
		buffer_load_dwordx4 v3, s[24:27], s11 offen lds
		s_add_i32 s11, s13, 0x18000
		v_add3_u32 v3, s11, v1, v21
		buffer_load_dwordx4 v[136:139], v24, s[0:3], 0 offen
		buffer_load_dwordx4 v[140:143], v0, s[0:3], 0 offen
		buffer_load_dwordx4 v[144:147], v27, s[0:3], 0 offen
		buffer_load_dwordx4 v[148:151], v3, s[0:3], 0 offen
		s_waitcnt vmcnt(6)
		s_barrier
		s_add_i32 s11, s13, 0x400
		v_add3_u32 v133, s11, v1, v21
		s_add_i32 s11, s13, 0x8400
		v_add3_u32 v134, s11, v1, v21
		s_add_i32 s11, s13, 0x10400
		v_add3_u32 v135, s11, v1, v21
		s_add_i32 s11, s13, 0x18400
		v_add3_u32 v152, s11, v1, v21
		s_add_i32 s11, s13, 0x800
		v_add3_u32 v153, s11, v1, v21
		s_add_i32 s11, s13, 0x8800
		v_add3_u32 v154, s11, v1, v21
		s_add_i32 s11, s13, 0x10800
		v_add3_u32 v155, s11, v1, v21
		s_add_i32 s11, s13, 0x18800
		v_add3_u32 v156, s11, v1, v21
		s_add_i32 s11, s13, 0xc00
		v_add3_u32 v157, s11, v1, v21
		s_add_i32 s11, s13, 0x8c00
		v_add3_u32 v158, s11, v1, v21
		s_add_i32 s11, s13, 0x10c00
		v_add3_u32 v159, s11, v1, v21
		s_add_i32 s11, s13, 0x18c00
		v_add3_u32 v1, s11, v1, v21
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
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		s_mov_b32 s11, s8
		s_mov_b32 s13, s8
		s_mov_b32 s28, s15
		s_mov_b32 s30, s8
		s_mov_b32 s31, s8
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s11, s31, 12
		buffer_load_dwordx4 v[224:227], v133, s[0:3], s11 offen
		buffer_load_dwordx4 v[228:231], v134, s[0:3], s11 offen
		buffer_load_dwordx4 v[232:235], v135, s[0:3], s11 offen
		buffer_load_dwordx4 v[236:239], v152, s[0:3], s11 offen
		s_and_b32 s32, s31, 1
		s_lshl_b32 s32, s32, 16
		v_add3_u32 v21, s32, v26, v23
		ds_read_b128 a[92:95], v21
		ds_read_b128 a[96:99], v21 offset:1024
		ds_read_b128 a[100:103], v21 offset:2048
		ds_read_b128 a[104:107], v21 offset:3072
		ds_read_b128 a[108:111], v21 offset:4096
		ds_read_b128 a[112:115], v21 offset:5120
		ds_read_b128 a[116:119], v21 offset:6144
		ds_read_b128 a[120:123], v21 offset:7168
		ds_read_b128 a[124:127], v21 offset:8192
		ds_read_b128 a[128:131], v21 offset:9216
		ds_read_b128 a[132:135], v21 offset:10240
		ds_read_b128 a[136:139], v21 offset:11264
		ds_read_b128 a[140:143], v21 offset:12288
		ds_read_b128 a[144:147], v21 offset:13312
		ds_read_b128 a[148:151], v21 offset:14336
		ds_read_b128 a[152:155], v21 offset:15360
		s_add_i32 s32, s13, 0x20000
		v_add_u32_e32 v240, s32, v19
		ds_read2st64_b32 v[242:243], v240 offset1:1
		ds_read2st64_b32 v[244:245], v240 offset0:2 offset1:3
		ds_read2st64_b32 v[246:247], v240 offset0:4 offset1:5
		ds_read2st64_b32 v[248:249], v240 offset0:6 offset1:7
		v_add3_u32 v241, s32, v10, v19
		ds_read2st64_b32 v[250:251], v241 offset0:16 offset1:17
		ds_read_b128 a[156:159], v21 offset:16384
		ds_read_b128 a[160:163], v21 offset:17408
		ds_read_b128 a[164:167], v21 offset:18432
		ds_read_b128 a[168:171], v21 offset:19456
		ds_read_b128 a[172:175], v21 offset:20480
		ds_read_b128 a[176:179], v21 offset:21504
		ds_read_b128 a[180:183], v21 offset:22528
		ds_read_b128 a[184:187], v21 offset:23552
		ds_read_b128 a[188:191], v21 offset:24576
		ds_read_b128 a[192:195], v21 offset:25600
		ds_read_b128 a[196:199], v21 offset:26624
		ds_read_b128 a[200:203], v21 offset:27648
		ds_read_b128 a[204:207], v21 offset:28672
		ds_read_b128 a[208:211], v21 offset:29696
		ds_read_b128 a[212:215], v21 offset:30720
		ds_read_b128 a[216:219], v21 offset:31744
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[92:95], v[136:139], v[28:31], v242, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s32, s30, 0x2000
		s_add_i32 s33, s28, 0x10000
		s_add_i32 s13, s13, 0x2000
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], v[140:143], v[128:131], v242, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s13, s13, 0x3fff
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], v[140:143], v[112:115], v242, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], v[136:139], v[116:119], v242, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[96:99], v[144:147], v[108:111], v242, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], v[144:147], v[124:127], v242, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], v[148:151], v[120:123], v242, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], v[148:151], v[104:107], v242, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[100:103], v[148:151], v[88:91], v243, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[100:103], v[144:147], v[92:95], v243, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[104:107], v[144:147], v[76:79], v243, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[104:107], v[148:151], v[72:75], v243, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[104:107], v[136:139], v[84:87], v243, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[100:103], v[136:139], v[100:103], v243, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[100:103], v[140:143], v[96:99], v243, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[104:107], v[140:143], v[80:83], v243, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[108:111], v[140:143], v[64:67], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[108:111], v[136:139], v[68:71], v244, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[112:115], v[136:139], v[52:55], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[112:115], v[140:143], v[48:51], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[112:115], v[144:147], v[44:47], v244, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[108:111], v[144:147], v[60:63], v244, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[108:111], v[148:151], v[56:59], v244, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[112:115], v[148:151], v[40:43], v244, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[116:119], v[148:151], v[164:167], v245, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[116:119], v[144:147], v[160:163], v245, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[120:123], v[144:147], v[176:179], v245, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[120:123], v[148:151], v[180:183], v245, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[120:123], v[136:139], v[168:171], v245, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[116:119], v[136:139], v[36:39], v245, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[116:119], v[140:143], v[32:35], v245, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[120:123], v[140:143], v[172:175], v245, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[124:127], v[140:143], v[188:191], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[124:127], v[136:139], v[184:187], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[128:131], v[136:139], v[200:203], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[128:131], v[140:143], v[204:207], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[128:131], v[144:147], v[208:211], v246, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[124:127], v[144:147], v[192:195], v246, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[124:127], v[148:151], v[196:199], v246, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[128:131], v[148:151], v[212:215], v246, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[148:151], a[8:11], v247, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[132:135], v[144:147], a[4:7], v247, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[136:139], v[144:147], a[20:23], v247, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[148:151], a[24:27], v247, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[136:139], v[136:139], a[12:15], v247, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[132:135], v[136:139], v[216:219], v247, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[132:135], v[140:143], v[220:223], v247, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[136:139], v[140:143], a[16:19], v247, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[140:143], v[140:143], a[32:35], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[140:143], v[136:139], a[28:31], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[144:147], v[136:139], a[44:47], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[144:147], v[140:143], a[48:51], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[144:147], v[144:147], a[52:55], v248, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[140:143], v[144:147], a[36:39], v248, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[148:151], a[40:43], v248, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[148:151], a[56:59], v248, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[148:151], a[72:75], v249, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[148:151], v[144:147], a[68:71], v249, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[152:155], v[144:147], a[84:87], v249, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[152:155], v[148:151], a[88:91], v249, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[152:155], v[136:139], a[76:79], v249, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[148:151], v[136:139], a[60:63], v249, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[148:151], v[140:143], a[64:67], v249, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[152:155], v[140:143], a[80:83], v249, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 m0, s28
		s_lshl_b32 s28, s31, 8
		s_add_i32 s35, s28, 0x200
		buffer_load_dwordx4 v2, s[16:19], s35 offen lds
		ds_read_b128 a[92:95], v21 offset:32768
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s28, s33, 0x1ffff
		s_and_b32 s32, s32, 0x3fff
		s_add_i32 s31, s31, 1
		buffer_load_dwordx4 v4, s[16:19], s35 offen lds
		ds_read_b128 a[96:99], v21 offset:33792
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s30, s15, s30
		buffer_load_dwordx4 v11, s[16:19], s35 offen lds
		ds_read_b128 a[100:103], v21 offset:34816
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s33, s9, s11
		buffer_load_dwordx4 v6, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[136:139], v153, s[0:3], s11 offen
		buffer_load_dwordx4 v[140:143], v154, s[0:3], s11 offen
		buffer_load_dwordx4 v[144:147], v155, s[0:3], s11 offen
		buffer_load_dwordx4 v[148:151], v156, s[0:3], s11 offen
		ds_read_b128 a[104:107], v21 offset:35840
		ds_read_b128 a[108:111], v21 offset:36864
		ds_read_b128 a[112:115], v21 offset:37888
		ds_read_b128 a[116:119], v21 offset:38912
		ds_read_b128 a[120:123], v21 offset:39936
		ds_read_b128 a[124:127], v21 offset:40960
		ds_read_b128 a[128:131], v21 offset:41984
		ds_read_b128 a[132:135], v21 offset:43008
		ds_read_b128 a[136:139], v21 offset:44032
		ds_read_b128 a[140:143], v21 offset:45056
		ds_read_b128 a[144:147], v21 offset:46080
		ds_read_b128 a[148:151], v21 offset:47104
		ds_read_b128 a[152:155], v21 offset:48128
		s_waitcnt vmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[156:159], v[224:227], v[28:31], v242, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[156:159], v[228:231], v[128:131], v242, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[160:163], v[228:231], v[112:115], v242, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[160:163], v[224:227], v[116:119], v242, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[160:163], v[232:235], v[108:111], v242, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[156:159], v[232:235], v[124:127], v242, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[156:159], v[236:239], v[120:123], v242, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[160:163], v[236:239], v[104:107], v242, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[164:167], v[236:239], v[88:91], v243, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[164:167], v[232:235], v[92:95], v243, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[168:171], v[232:235], v[76:79], v243, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[168:171], v[236:239], v[72:75], v243, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[168:171], v[224:227], v[84:87], v243, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[164:167], v[224:227], v[100:103], v243, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[164:167], v[228:231], v[96:99], v243, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[168:171], v[228:231], v[80:83], v243, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[172:175], v[228:231], v[64:67], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[172:175], v[224:227], v[68:71], v244, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[176:179], v[224:227], v[52:55], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[176:179], v[228:231], v[48:51], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[176:179], v[232:235], v[44:47], v244, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[172:175], v[232:235], v[60:63], v244, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[172:175], v[236:239], v[56:59], v244, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[176:179], v[236:239], v[40:43], v244, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[180:183], v[236:239], v[164:167], v245, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[180:183], v[232:235], v[160:163], v245, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[184:187], v[232:235], v[176:179], v245, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[184:187], v[236:239], v[180:183], v245, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[184:187], v[224:227], v[168:171], v245, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[180:183], v[224:227], v[36:39], v245, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[180:183], v[228:231], v[32:35], v245, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[184:187], v[228:231], v[172:175], v245, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[188:191], v[228:231], v[188:191], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[188:191], v[224:227], v[184:187], v246, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[192:195], v[224:227], v[200:203], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[192:195], v[228:231], v[204:207], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[192:195], v[232:235], v[208:211], v246, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[188:191], v[232:235], v[192:195], v246, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[188:191], v[236:239], v[196:199], v246, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[192:195], v[236:239], v[212:215], v246, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[196:199], v[236:239], a[8:11], v247, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[196:199], v[232:235], a[4:7], v247, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[200:203], v[232:235], a[20:23], v247, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[200:203], v[236:239], a[24:27], v247, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[200:203], v[224:227], a[12:15], v247, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[196:199], v[224:227], v[216:219], v247, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[196:199], v[228:231], v[220:223], v247, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[200:203], v[228:231], a[16:19], v247, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[204:207], v[228:231], a[32:35], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[204:207], v[224:227], a[28:31], v248, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[208:211], v[224:227], a[44:47], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[208:211], v[228:231], a[48:51], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[208:211], v[232:235], a[52:55], v248, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[204:207], v[232:235], a[36:39], v248, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[204:207], v[236:239], a[40:43], v248, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[208:211], v[236:239], a[56:59], v248, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[212:215], v[236:239], a[72:75], v249, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[212:215], v[232:235], a[68:71], v249, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[216:219], v[232:235], a[84:87], v249, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[216:219], v[236:239], a[88:91], v249, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[216:219], v[224:227], a[76:79], v249, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[212:215], v[224:227], a[60:63], v249, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[212:215], v[228:231], a[64:67], v249, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[216:219], v[228:231], a[80:83], v249, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		ds_read2st64_b32 v[224:225], v240 offset0:8 offset1:9
		buffer_load_dwordx4 v12, s[16:19], s35 offen lds
		ds_read2st64_b32 v[226:227], v240 offset0:10 offset1:11
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], s35 offen lds
		ds_read2st64_b32 v[228:229], v240 offset0:12 offset1:13
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v7, s[16:19], s35 offen lds
		ds_read2st64_b32 v[230:231], v240 offset0:14 offset1:15
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[232:235], v157, s[0:3], s11 offen
		buffer_load_dwordx4 v[236:239], v158, s[0:3], s11 offen
		buffer_load_dwordx4 v[244:247], v159, s[0:3], s11 offen
		buffer_load_dwordx4 v[248:251], v1, s[0:3], s11 offen
		ds_read2st64_b32 v[242:243], v241 offset0:18 offset1:19
		ds_read_b128 a[156:159], v21 offset:49152
		ds_read_b128 a[160:163], v21 offset:50176
		ds_read_b128 a[164:167], v21 offset:51200
		ds_read_b128 a[168:171], v21 offset:52224
		ds_read_b128 a[172:175], v21 offset:53248
		ds_read_b128 a[176:179], v21 offset:54272
		ds_read_b128 a[180:183], v21 offset:55296
		ds_read_b128 a[184:187], v21 offset:56320
		ds_read_b128 a[188:191], v21 offset:57344
		ds_read_b128 a[192:195], v21 offset:58368
		ds_read_b128 a[196:199], v21 offset:59392
		ds_read_b128 a[200:203], v21 offset:60416
		ds_read_b128 a[204:207], v21 offset:61440
		ds_read_b128 a[208:211], v21 offset:62464
		ds_read_b128 a[212:215], v21 offset:63488
		ds_read_b128 v[252:255], v21 offset:64512
		s_waitcnt vmcnt(11) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[92:95], v[136:139], v[28:31], v224, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[92:95], v[140:143], v[128:131], v224, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[96:99], v[140:143], v[112:115], v224, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[96:99], v[136:139], v[116:119], v224, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[96:99], v[144:147], v[108:111], v224, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[92:95], v[144:147], v[124:127], v224, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[92:95], v[148:151], v[120:123], v224, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[96:99], v[148:151], v[104:107], v224, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[100:103], v[148:151], v[88:91], v225, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[100:103], v[144:147], v[92:95], v225, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[104:107], v[144:147], v[76:79], v225, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[104:107], v[148:151], v[72:75], v225, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[104:107], v[136:139], v[84:87], v225, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[100:103], v[136:139], v[100:103], v225, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[100:103], v[140:143], v[96:99], v225, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[104:107], v[140:143], v[80:83], v225, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[108:111], v[140:143], v[64:67], v226, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[108:111], v[136:139], v[68:71], v226, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[112:115], v[136:139], v[52:55], v226, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[112:115], v[140:143], v[48:51], v226, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[112:115], v[144:147], v[44:47], v226, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[108:111], v[144:147], v[60:63], v226, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[108:111], v[148:151], v[56:59], v226, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[112:115], v[148:151], v[40:43], v226, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[116:119], v[148:151], v[164:167], v227, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[116:119], v[144:147], v[160:163], v227, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[120:123], v[144:147], v[176:179], v227, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[120:123], v[148:151], v[180:183], v227, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[120:123], v[136:139], v[168:171], v227, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[116:119], v[136:139], v[36:39], v227, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[116:119], v[140:143], v[32:35], v227, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[120:123], v[140:143], v[172:175], v227, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[124:127], v[140:143], v[188:191], v228, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[124:127], v[136:139], v[184:187], v228, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[128:131], v[136:139], v[200:203], v228, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[128:131], v[140:143], v[204:207], v228, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[128:131], v[144:147], v[208:211], v228, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[124:127], v[144:147], v[192:195], v228, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[124:127], v[148:151], v[196:199], v228, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[128:131], v[148:151], v[212:215], v228, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[148:151], a[8:11], v229, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[132:135], v[144:147], a[4:7], v229, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[136:139], v[144:147], a[20:23], v229, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[148:151], a[24:27], v229, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[136:139], v[136:139], a[12:15], v229, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[132:135], v[136:139], v[216:219], v229, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[132:135], v[140:143], v[220:223], v229, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[136:139], v[140:143], a[16:19], v229, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[140:143], v[140:143], a[32:35], v230, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[140:143], v[136:139], a[28:31], v230, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[144:147], v[136:139], a[44:47], v230, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[144:147], v[140:143], a[48:51], v230, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[144:147], v[144:147], a[52:55], v230, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[140:143], v[144:147], a[36:39], v230, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[148:151], a[40:43], v230, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[148:151], a[56:59], v230, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[148:151], a[72:75], v231, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[148:151], v[144:147], a[68:71], v231, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[152:155], v[144:147], a[84:87], v231, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[152:155], v[148:151], a[88:91], v231, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[152:155], v[136:139], a[76:79], v231, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[148:151], v[136:139], a[60:63], v231, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[148:151], v[140:143], a[64:67], v231, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[152:155], v[140:143], a[80:83], v231, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v8, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[136:139], v24, s[0:3], s33 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[156:159], v[232:235], v[28:31], v224, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[140:143], v0, s[0:3], s33 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[156:159], v[236:239], v[128:131], v224, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[144:147], v27, s[0:3], s33 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[160:163], v[236:239], v[112:115], v224, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[148:151], v3, s[0:3], s33 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[160:163], v[232:235], v[116:119], v224, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[160:163], v[244:247], v[108:111], v224, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[156:159], v[244:247], v[124:127], v224, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[156:159], v[248:251], v[120:123], v224, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[160:163], v[248:251], v[104:107], v224, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[164:167], v[248:251], v[88:91], v225, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[164:167], v[244:247], v[92:95], v225, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[168:171], v[244:247], v[76:79], v225, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[168:171], v[248:251], v[72:75], v225, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[168:171], v[232:235], v[84:87], v225, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[164:167], v[232:235], v[100:103], v225, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[164:167], v[236:239], v[96:99], v225, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[168:171], v[236:239], v[80:83], v225, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[172:175], v[236:239], v[64:67], v226, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[172:175], v[232:235], v[68:71], v226, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[176:179], v[232:235], v[52:55], v226, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[176:179], v[236:239], v[48:51], v226, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[176:179], v[244:247], v[44:47], v226, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[172:175], v[244:247], v[60:63], v226, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[172:175], v[248:251], v[56:59], v226, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[176:179], v[248:251], v[40:43], v226, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[180:183], v[248:251], v[164:167], v227, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[180:183], v[244:247], v[160:163], v227, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[184:187], v[244:247], v[176:179], v227, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[184:187], v[248:251], v[180:183], v227, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[184:187], v[232:235], v[168:171], v227, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[180:183], v[232:235], v[36:39], v227, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[180:183], v[236:239], v[32:35], v227, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[184:187], v[236:239], v[172:175], v227, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[188:191], v[236:239], v[188:191], v228, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[188:191], v[232:235], v[184:187], v228, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[192:195], v[232:235], v[200:203], v228, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[192:195], v[236:239], v[204:207], v228, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[192:195], v[244:247], v[208:211], v228, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[188:191], v[244:247], v[192:195], v228, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[188:191], v[248:251], v[196:199], v228, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[192:195], v[248:251], v[212:215], v228, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[196:199], v[248:251], a[8:11], v229, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[196:199], v[244:247], a[4:7], v229, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[200:203], v[244:247], a[20:23], v229, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[200:203], v[248:251], a[24:27], v229, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[200:203], v[232:235], a[12:15], v229, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[196:199], v[232:235], v[216:219], v229, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[196:199], v[236:239], v[220:223], v229, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[200:203], v[236:239], a[16:19], v229, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[204:207], v[236:239], a[32:35], v230, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[204:207], v[232:235], a[28:31], v230, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[208:211], v[232:235], a[44:47], v230, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[208:211], v[236:239], a[48:51], v230, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[208:211], v[244:247], a[52:55], v230, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[204:207], v[244:247], a[36:39], v230, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[204:207], v[248:251], a[40:43], v230, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[208:211], v[248:251], a[56:59], v230, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[212:215], v[248:251], a[72:75], v231, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[212:215], v[244:247], a[68:71], v231, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[244:247], a[84:87], v231, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[248:251], a[88:91], v231, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[232:235], a[76:79], v231, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[212:215], v[232:235], a[60:63], v231, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[212:215], v[236:239], a[64:67], v231, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[236:239], a[80:83], v231, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v20, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v5, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, s30, 0x20000
		s_nop 0
		buffer_load_dwordx4 v25, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s20, s20, 0x200
		s_addc_u32 s21, s21, 0
		buffer_load_dwordx4 v132, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x200
		s_addc_u32 s25, s25, 0
		s_cmp_lt_i32 s31, 6
		s_mov_b32 s11, s8
		s_mov_b32 s30, s32
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		v_accvgpr_read_b32 v2, a1
		v_lshl_add_u32 v2, v2, 4, v26
		ds_read_b128 v[4:7], v2
		ds_read_b128 v[12:15], v2 offset:1024
		ds_read_b128 v[224:227], v2 offset:2048
		ds_read_b128 v[228:231], v2 offset:3072
		ds_read_b128 v[232:235], v2 offset:4096
		ds_read_b128 v[236:239], v2 offset:5120
		ds_read_b128 v[240:243], v2 offset:6144
		ds_read_b128 v[244:247], v2 offset:7168
		ds_read_b128 a[92:95], v2 offset:8192
		ds_read_b128 a[96:99], v2 offset:9216
		ds_read_b128 a[100:103], v2 offset:10240
		ds_read_b128 a[104:107], v2 offset:11264
		ds_read_b128 a[108:111], v2 offset:12288
		ds_read_b128 a[112:115], v2 offset:13312
		ds_read_b128 a[116:119], v2 offset:14336
		ds_read_b128 a[120:123], v2 offset:15360
		v_add_u32_e32 v8, 0x20000, v19
		ds_read2st64_b32 v[16:17], v8 offset1:1
		ds_read2st64_b32 v[20:21], v8 offset0:2 offset1:3
		ds_read2st64_b32 v[248:249], v8 offset0:4 offset1:5
		ds_read2st64_b32 v[250:251], v8 offset0:6 offset1:7
		v_add_u32_e32 v9, 0x20000, v10
		v_add_u32_e32 v9, v9, v19
		ds_read2st64_b32 v[10:11], v9 offset0:16 offset1:17
		ds_read_b128 a[124:127], v2 offset:16384
		ds_read_b128 a[128:131], v2 offset:17408
		ds_read_b128 a[132:135], v2 offset:18432
		ds_read_b128 a[136:139], v2 offset:19456
		ds_read_b128 a[140:143], v2 offset:20480
		ds_read_b128 a[144:147], v2 offset:21504
		ds_read_b128 a[148:151], v2 offset:22528
		ds_read_b128 a[152:155], v2 offset:23552
		ds_read_b128 a[156:159], v2 offset:24576
		ds_read_b128 a[160:163], v2 offset:25600
		ds_read_b128 a[164:167], v2 offset:26624
		ds_read_b128 a[168:171], v2 offset:27648
		ds_read_b128 a[172:175], v2 offset:28672
		ds_read_b128 a[176:179], v2 offset:29696
		ds_read_b128 a[180:183], v2 offset:30720
		ds_read_b128 v[252:255], v2 offset:31744
		s_waitcnt vmcnt(9) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[4:7], v[136:139], v[28:31], v16, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[4:7], v[140:143], v[128:131], v16, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[12:15], v[140:143], v[112:115], v16, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[136:139], v[116:119], v16, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], v[144:147], v[108:111], v16, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[4:7], v[144:147], v[124:127], v16, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[4:7], v[148:151], v[120:123], v16, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[12:15], v[148:151], v[104:107], v16, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[224:227], v[148:151], v[88:91], v17, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[224:227], v[144:147], v[92:95], v17, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[228:231], v[144:147], v[76:79], v17, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[228:231], v[148:151], v[72:75], v17, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[228:231], v[136:139], v[84:87], v17, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[224:227], v[136:139], v[100:103], v17, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[224:227], v[140:143], v[96:99], v17, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[228:231], v[140:143], v[80:83], v17, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[232:235], v[140:143], v[64:67], v20, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[232:235], v[136:139], v[68:71], v20, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[236:239], v[136:139], v[52:55], v20, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[236:239], v[140:143], v[48:51], v20, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[236:239], v[144:147], v[44:47], v20, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[232:235], v[144:147], v[60:63], v20, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[232:235], v[148:151], v[56:59], v20, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[236:239], v[148:151], v[40:43], v20, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[240:243], v[148:151], v[164:167], v21, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[240:243], v[144:147], v[160:163], v21, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[244:247], v[144:147], v[176:179], v21, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[148:151], v[180:183], v21, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[244:247], v[136:139], v[168:171], v21, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[240:243], v[136:139], v[36:39], v21, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[240:243], v[140:143], v[32:35], v21, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[244:247], v[140:143], v[172:175], v21, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], v[140:143], v[188:191], v248, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], v[136:139], v[184:187], v248, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], v[136:139], v[200:203], v248, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[96:99], v[140:143], v[204:207], v248, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], v[144:147], v[208:211], v248, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], v[144:147], v[192:195], v248, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], v[148:151], v[196:199], v248, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], v[148:151], v[212:215], v248, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[100:103], v[148:151], a[8:11], v249, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[100:103], v[144:147], a[4:7], v249, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[104:107], v[144:147], a[20:23], v249, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[104:107], v[148:151], a[24:27], v249, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[104:107], v[136:139], a[12:15], v249, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[100:103], v[136:139], v[216:219], v249, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[100:103], v[140:143], v[220:223], v249, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[104:107], v[140:143], a[16:19], v249, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[108:111], v[140:143], a[32:35], v250, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[108:111], v[136:139], a[28:31], v250, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[112:115], v[136:139], a[44:47], v250, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[112:115], v[140:143], a[48:51], v250, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[112:115], v[144:147], a[52:55], v250, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[108:111], v[144:147], a[36:39], v250, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[108:111], v[148:151], a[40:43], v250, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[112:115], v[148:151], a[56:59], v250, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[116:119], v[148:151], a[72:75], v251, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[116:119], v[144:147], a[68:71], v251, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[120:123], v[144:147], a[84:87], v251, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[120:123], v[148:151], a[88:91], v251, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[120:123], v[136:139], a[76:79], v251, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[116:119], v[136:139], a[60:63], v251, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[116:119], v[140:143], a[64:67], v251, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[120:123], v[140:143], a[80:83], v251, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v133, s[0:3], s12 offen
		buffer_load_dwordx4 v[12:15], v134, s[0:3], s12 offen
		buffer_load_dwordx4 v[136:139], v135, s[0:3], s12 offen
		buffer_load_dwordx4 v[140:143], v152, s[0:3], s12 offen
		s_barrier
		ds_read_b128 v[144:147], v2 offset:32768
		ds_read_b128 v[148:151], v2 offset:33792
		ds_read_b128 v[224:227], v2 offset:34816
		ds_read_b128 v[228:231], v2 offset:35840
		ds_read_b128 v[232:235], v2 offset:36864
		ds_read_b128 v[236:239], v2 offset:37888
		ds_read_b128 v[240:243], v2 offset:38912
		ds_read_b128 a[92:95], v2 offset:39936
		ds_read_b128 a[96:99], v2 offset:40960
		ds_read_b128 a[100:103], v2 offset:41984
		ds_read_b128 a[104:107], v2 offset:43008
		ds_read_b128 a[108:111], v2 offset:44032
		ds_read_b128 a[112:115], v2 offset:45056
		ds_read_b128 a[116:119], v2 offset:46080
		ds_read_b128 a[120:123], v2 offset:47104
		ds_read_b128 v[244:247], v2 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[124:127], v[4:7], v[28:31], v16, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[124:127], v[12:15], v[128:131], v16, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[128:131], v[12:15], v[112:115], v16, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[128:131], v[4:7], v[116:119], v16, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[128:131], v[136:139], v[108:111], v16, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[124:127], v[136:139], v[124:127], v16, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[124:127], v[140:143], v[120:123], v16, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[128:131], v[140:143], v[104:107], v16, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[132:135], v[140:143], v[88:91], v17, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[132:135], v[136:139], v[92:95], v17, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[136:139], v[136:139], v[76:79], v17, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[136:139], v[140:143], v[72:75], v17, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[136:139], v[4:7], v[84:87], v17, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[132:135], v[4:7], v[100:103], v17, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[132:135], v[12:15], v[96:99], v17, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[136:139], v[12:15], v[80:83], v17, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[140:143], v[12:15], v[64:67], v20, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[140:143], v[4:7], v[68:71], v20, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[144:147], v[4:7], v[52:55], v20, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[144:147], v[12:15], v[48:51], v20, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[144:147], v[136:139], v[44:47], v20, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[140:143], v[136:139], v[60:63], v20, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[140:143], v[140:143], v[56:59], v20, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[144:147], v[140:143], v[40:43], v20, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[140:143], v[164:167], v21, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[136:139], v[160:163], v21, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[136:139], v[176:179], v21, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[140:143], v[180:183], v21, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[4:7], v[168:171], v21, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[148:151], v[4:7], v[36:39], v21, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[148:151], v[12:15], v[32:35], v21, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[12:15], v[172:175], v21, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[12:15], v[188:191], v248, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[4:7], v[184:187], v248, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[4:7], v[200:203], v248, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[12:15], v[204:207], v248, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[136:139], v[208:211], v248, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[136:139], v[192:195], v248, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[140:143], v[196:199], v248, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[140:143], v[212:215], v248, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[140:143], a[8:11], v249, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[136:139], a[4:7], v249, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[136:139], a[20:23], v249, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[140:143], a[24:27], v249, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[4:7], a[12:15], v249, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[4:7], v[216:219], v249, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[12:15], v[220:223], v249, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[12:15], a[16:19], v249, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[12:15], a[32:35], v250, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[4:7], a[28:31], v250, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[4:7], a[44:47], v250, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[12:15], a[48:51], v250, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[136:139], a[52:55], v250, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[136:139], a[36:39], v250, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[140:143], a[40:43], v250, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[140:143], a[56:59], v250, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], v[140:143], a[72:75], v251, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[136:139], a[68:71], v251, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[136:139], a[84:87], v251, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[140:143], a[88:91], v251, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[4:7], a[76:79], v251, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[4:7], a[60:63], v251, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[12:15], a[64:67], v251, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[12:15], a[80:83], v251, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v153, s[0:3], s12 offen
		buffer_load_dwordx4 v[12:15], v154, s[0:3], s12 offen
		buffer_load_dwordx4 v[16:19], v155, s[0:3], s12 offen
		buffer_load_dwordx4 v[136:139], v156, s[0:3], s12 offen
		s_barrier
		ds_read2st64_b32 v[10:11], v8 offset0:8 offset1:9
		ds_read2st64_b32 v[20:21], v8 offset0:10 offset1:11
		ds_read2st64_b32 v[140:141], v8 offset0:12 offset1:13
		ds_read2st64_b32 v[142:143], v8 offset0:14 offset1:15
		ds_read2st64_b32 v[248:249], v9 offset0:18 offset1:19
		ds_read_b128 a[124:127], v2 offset:49152
		ds_read_b128 a[128:131], v2 offset:50176
		ds_read_b128 a[132:135], v2 offset:51200
		ds_read_b128 a[136:139], v2 offset:52224
		ds_read_b128 a[140:143], v2 offset:53248
		ds_read_b128 a[144:147], v2 offset:54272
		ds_read_b128 a[148:151], v2 offset:55296
		ds_read_b128 a[152:155], v2 offset:56320
		ds_read_b128 a[156:159], v2 offset:57344
		ds_read_b128 a[160:163], v2 offset:58368
		ds_read_b128 a[164:167], v2 offset:59392
		ds_read_b128 a[168:171], v2 offset:60416
		ds_read_b128 a[172:175], v2 offset:61440
		ds_read_b128 a[176:179], v2 offset:62464
		ds_read_b128 a[180:183], v2 offset:63488
		ds_read_b128 v[252:255], v2 offset:64512
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[144:147], v[4:7], v[28:31], v10, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[144:147], v[12:15], v[128:131], v10, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[148:151], v[12:15], v[112:115], v10, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[148:151], v[4:7], v[116:119], v10, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[148:151], v[16:19], v[108:111], v10, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[144:147], v[16:19], v[124:127], v10, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[144:147], v[136:139], v[120:123], v10, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[148:151], v[136:139], v[104:107], v10, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[224:227], v[136:139], v[88:91], v11, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[224:227], v[16:19], v[92:95], v11, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[228:231], v[16:19], v[76:79], v11, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[228:231], v[136:139], v[72:75], v11, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[228:231], v[4:7], v[84:87], v11, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[224:227], v[4:7], v[100:103], v11, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[224:227], v[12:15], v[96:99], v11, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[228:231], v[12:15], v[80:83], v11, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[232:235], v[12:15], v[64:67], v20, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[232:235], v[4:7], v[68:71], v20, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[236:239], v[4:7], v[52:55], v20, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[236:239], v[12:15], v[48:51], v20, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[236:239], v[16:19], v[44:47], v20, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[232:235], v[16:19], v[60:63], v20, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[232:235], v[136:139], v[56:59], v20, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[236:239], v[136:139], v[40:43], v20, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[240:243], v[136:139], v[164:167], v21, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[240:243], v[16:19], v[160:163], v21, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], v[16:19], v[176:179], v21, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], v[136:139], v[180:183], v21, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], v[4:7], v[168:171], v21, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[240:243], v[4:7], v[36:39], v21, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[240:243], v[12:15], v[32:35], v21, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], v[12:15], v[172:175], v21, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[96:99], v[12:15], v[188:191], v140, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], v[4:7], v[184:187], v140, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[100:103], v[4:7], v[200:203], v140, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[100:103], v[12:15], v[204:207], v140, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[100:103], v[16:19], v[208:211], v140, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], v[16:19], v[192:195], v140, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], v[136:139], v[196:199], v140, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[100:103], v[136:139], v[212:215], v140, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[104:107], v[136:139], a[8:11], v141, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[104:107], v[16:19], a[4:7], v141, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[108:111], v[16:19], a[20:23], v141, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[108:111], v[136:139], a[24:27], v141, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[108:111], v[4:7], a[12:15], v141, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[104:107], v[4:7], v[216:219], v141, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[104:107], v[12:15], v[220:223], v141, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[108:111], v[12:15], a[16:19], v141, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[112:115], v[12:15], a[32:35], v142, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[144:147], v157, s[0:3], s12 offen
		buffer_load_dwordx4 v[148:151], v158, s[0:3], s12 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[112:115], v[4:7], a[28:31], v142, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[116:119], v[4:7], a[44:47], v142, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[224:227], v159, s[0:3], s12 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[116:119], v[12:15], a[48:51], v142, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[228:231], v1, s[0:3], s12 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[116:119], v[16:19], a[52:55], v142, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[112:115], v[16:19], a[36:39], v142, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[112:115], v[136:139], a[40:43], v142, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[116:119], v[136:139], a[56:59], v142, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[120:123], v[136:139], a[72:75], v143, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[120:123], v[16:19], a[68:71], v143, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[244:247], v[16:19], a[84:87], v143, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[244:247], v[136:139], a[88:91], v143, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[244:247], v[4:7], a[76:79], v143, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[120:123], v[4:7], a[60:63], v143, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[120:123], v[12:15], a[64:67], v143, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[244:247], v[12:15], a[80:83], v143, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[124:127], v[144:147], v[28:31], v10, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[124:127], v[148:151], v[128:131], v10, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[128:131], v[148:151], v[112:115], v10, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[128:131], v[144:147], v[116:119], v10, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[128:131], v[224:227], v[108:111], v10, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[124:127], v[224:227], v[124:127], v10, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[124:127], v[228:231], v[120:123], v10, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[128:131], v[228:231], v[104:107], v10, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[132:135], v[228:231], v[88:91], v11, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[132:135], v[224:227], v[92:95], v11, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[136:139], v[224:227], v[76:79], v11, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[136:139], v[228:231], v[72:75], v11, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[136:139], v[144:147], v[84:87], v11, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[132:135], v[144:147], v[100:103], v11, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[132:135], v[148:151], v[96:99], v11, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[136:139], v[148:151], v[80:83], v11, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[140:143], v[148:151], v[64:67], v20, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[140:143], v[144:147], v[68:71], v20, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[144:147], v[144:147], v[52:55], v20, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[144:147], v[148:151], v[48:51], v20, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[144:147], v[224:227], v[44:47], v20, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[140:143], v[224:227], v[60:63], v20, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[140:143], v[228:231], v[56:59], v20, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[144:147], v[228:231], v[40:43], v20, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[228:231], v[164:167], v21, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[224:227], v[160:163], v21, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[224:227], v[176:179], v21, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[228:231], v[180:183], v21, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[144:147], v[168:171], v21, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[148:151], v[144:147], v[36:39], v21, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[148:151], v[148:151], v[32:35], v21, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[148:151], v[172:175], v21, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[148:151], v[188:191], v140, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[144:147], v[184:187], v140, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[144:147], v[200:203], v140, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[148:151], v[204:207], v140, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[224:227], v[208:211], v140, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[224:227], v[192:195], v140, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[228:231], v[196:199], v140, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[228:231], v[212:215], v140, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[228:231], a[8:11], v141, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[224:227], a[4:7], v141, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[224:227], a[20:23], v141, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[228:231], a[24:27], v141, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[144:147], a[12:15], v141, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[144:147], v[216:219], v141, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[148:151], v[220:223], v141, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[148:151], a[16:19], v141, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[148:151], a[32:35], v142, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[144:147], a[28:31], v142, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[144:147], a[44:47], v142, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[148:151], a[48:51], v142, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[224:227], a[52:55], v142, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[224:227], a[36:39], v142, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[228:231], a[40:43], v142, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[228:231], a[56:59], v142, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], v[228:231], a[72:75], v143, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[224:227], a[68:71], v143, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[224:227], a[84:87], v143, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[228:231], a[88:91], v143, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[144:147], a[76:79], v143, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[144:147], a[60:63], v143, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[148:151], a[64:67], v143, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[148:151], a[80:83], v143, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v24, s[0:3], s29 offen
		buffer_load_dwordx4 v[12:15], v0, s[0:3], s29 offen
		buffer_load_dwordx4 v[16:19], v27, s[0:3], s29 offen
		buffer_load_dwordx4 v[136:139], v3, s[0:3], s29 offen
		s_barrier
		v_add_u32_e32 v0, 0x10000, v26
		v_accvgpr_read_b32 v2, a1
		v_lshl_add_u32 v0, v2, 4, v0
		ds_read_b128 v[24:27], v0
		ds_read_b128 v[140:143], v0 offset:1024
		ds_read_b128 v[144:147], v0 offset:2048
		ds_read_b128 v[148:151], v0 offset:3072
		ds_read_b128 v[224:227], v0 offset:4096
		ds_read_b128 v[228:231], v0 offset:5120
		ds_read_b128 v[232:235], v0 offset:6144
		ds_read_b128 v[236:239], v0 offset:7168
		ds_read_b128 v[240:243], v0 offset:8192
		ds_read_b128 v[244:247], v0 offset:9216
		ds_read_b128 a[92:95], v0 offset:10240
		ds_read_b128 a[96:99], v0 offset:11264
		ds_read_b128 a[100:103], v0 offset:12288
		ds_read_b128 a[104:107], v0 offset:13312
		ds_read_b128 a[108:111], v0 offset:14336
		ds_read_b128 a[112:115], v0 offset:15360
		ds_read_b32 v2, v8 offset:8192
		ds_read_b32 v3, v8 offset:8448
		ds_read_b32 v10, v8 offset:8704
		ds_read_b32 v11, v8 offset:8960
		ds_read_b32 v20, v8 offset:9216
		ds_read_b32 v21, v8 offset:9472
		ds_read_b32 v23, v8 offset:9728
		ds_read_b32 v132, v8 offset:9984
		ds_read_b32 v248, v9 offset:12288
		ds_read_b32 v249, v9 offset:12544
		ds_read_b128 a[116:119], v0 offset:16384
		ds_read_b128 a[120:123], v0 offset:17408
		ds_read_b128 a[124:127], v0 offset:18432
		ds_read_b128 a[128:131], v0 offset:19456
		ds_read_b128 a[132:135], v0 offset:20480
		ds_read_b128 a[136:139], v0 offset:21504
		ds_read_b128 a[140:143], v0 offset:22528
		ds_read_b128 a[144:147], v0 offset:23552
		ds_read_b128 a[148:151], v0 offset:24576
		ds_read_b128 a[152:155], v0 offset:25600
		ds_read_b128 a[156:159], v0 offset:26624
		ds_read_b128 a[160:163], v0 offset:27648
		ds_read_b128 a[164:167], v0 offset:28672
		ds_read_b128 a[168:171], v0 offset:29696
		ds_read_b128 a[172:175], v0 offset:30720
		ds_read_b128 v[252:255], v0 offset:31744
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[24:27], v[4:7], v[28:31], v2, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[12:15], v[128:131], v2, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[140:143], v[12:15], v[112:115], v2, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[140:143], v[4:7], v[116:119], v2, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[140:143], v[16:19], v[108:111], v2, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[16:19], v[124:127], v2, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[136:139], v[120:123], v2, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[140:143], v[136:139], v[104:107], v2, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[144:147], v[136:139], v[88:91], v3, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[144:147], v[16:19], v[92:95], v3, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[148:151], v[16:19], v[76:79], v3, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[148:151], v[136:139], v[72:75], v3, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[148:151], v[4:7], v[84:87], v3, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[144:147], v[4:7], v[100:103], v3, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[144:147], v[12:15], v[96:99], v3, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[148:151], v[12:15], v[80:83], v3, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[224:227], v[12:15], v[64:67], v10, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[224:227], v[4:7], v[68:71], v10, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[228:231], v[4:7], v[52:55], v10, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[228:231], v[12:15], v[48:51], v10, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[228:231], v[16:19], v[44:47], v10, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[224:227], v[16:19], v[60:63], v10, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[224:227], v[136:139], v[56:59], v10, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[228:231], v[136:139], v[40:43], v10, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[136:139], v[164:167], v11, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[16:19], v[160:163], v11, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[236:239], v[16:19], v[176:179], v11, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[236:239], v[136:139], v[180:183], v11, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[236:239], v[4:7], v[168:171], v11, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[232:235], v[4:7], v[36:39], v11, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[232:235], v[12:15], v[32:35], v11, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[236:239], v[12:15], v[172:175], v11, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[12:15], v[188:191], v20, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[4:7], v[184:187], v20, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[4:7], v[200:203], v20, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[244:247], v[12:15], v[204:207], v20, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[16:19], v[208:211], v20, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[16:19], v[192:195], v20, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[136:139], v[196:199], v20, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[136:139], v[212:215], v20, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[92:95], v[136:139], a[8:11], v21, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[92:95], v[16:19], a[4:7], v21, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[96:99], v[16:19], a[20:23], v21, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[96:99], v[136:139], a[24:27], v21, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[96:99], v[4:7], a[12:15], v21, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], v[4:7], v[216:219], v21, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[92:95], v[12:15], v[220:223], v21, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[96:99], v[12:15], a[16:19], v21, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[100:103], v[12:15], a[32:35], v23, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[100:103], v[4:7], a[28:31], v23, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[104:107], v[4:7], a[44:47], v23, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[104:107], v[12:15], a[48:51], v23, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[104:107], v[16:19], a[52:55], v23, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[100:103], v[16:19], a[36:39], v23, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[100:103], v[136:139], a[40:43], v23, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[104:107], v[136:139], a[56:59], v23, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[108:111], v[136:139], a[72:75], v132, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[108:111], v[16:19], a[68:71], v132, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[112:115], v[16:19], a[84:87], v132, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[112:115], v[136:139], a[88:91], v132, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[112:115], v[4:7], a[76:79], v132, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[108:111], v[4:7], a[60:63], v132, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[108:111], v[12:15], a[64:67], v132, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[112:115], v[12:15], a[80:83], v132, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v133, s[0:3], s29 offen
		buffer_load_dwordx4 v[12:15], v134, s[0:3], s29 offen
		buffer_load_dwordx4 v[16:19], v135, s[0:3], s29 offen
		buffer_load_dwordx4 v[24:27], v152, s[0:3], s29 offen
		s_barrier
		ds_read_b128 v[136:139], v0 offset:32768
		ds_read_b128 v[140:143], v0 offset:33792
		ds_read_b128 v[144:147], v0 offset:34816
		ds_read_b128 v[148:151], v0 offset:35840
		ds_read_b128 v[224:227], v0 offset:36864
		ds_read_b128 v[228:231], v0 offset:37888
		ds_read_b128 v[232:235], v0 offset:38912
		ds_read_b128 v[236:239], v0 offset:39936
		ds_read_b128 v[240:243], v0 offset:40960
		ds_read_b128 a[92:95], v0 offset:41984
		ds_read_b128 a[96:99], v0 offset:43008
		ds_read_b128 a[100:103], v0 offset:44032
		ds_read_b128 a[104:107], v0 offset:45056
		ds_read_b128 a[108:111], v0 offset:46080
		ds_read_b128 a[112:115], v0 offset:47104
		ds_read_b128 v[244:247], v0 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[116:119], v[4:7], v[28:31], v2, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[116:119], v[12:15], v[128:131], v2, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[120:123], v[12:15], v[112:115], v2, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[120:123], v[4:7], v[116:119], v2, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[120:123], v[16:19], v[108:111], v2, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[116:119], v[16:19], v[124:127], v2, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[116:119], v[24:27], v[120:123], v2, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[120:123], v[24:27], v[104:107], v2, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[124:127], v[24:27], v[88:91], v3, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[124:127], v[16:19], v[92:95], v3, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[128:131], v[16:19], v[76:79], v3, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[128:131], v[24:27], v[72:75], v3, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[128:131], v[4:7], v[84:87], v3, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[124:127], v[4:7], v[100:103], v3, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[124:127], v[12:15], v[96:99], v3, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[128:131], v[12:15], v[80:83], v3, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[132:135], v[12:15], v[64:67], v10, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[132:135], v[4:7], v[68:71], v10, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[136:139], v[4:7], v[52:55], v10, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[136:139], v[12:15], v[48:51], v10, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[136:139], v[16:19], v[44:47], v10, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[132:135], v[16:19], v[60:63], v10, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[132:135], v[24:27], v[56:59], v10, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[136:139], v[24:27], v[40:43], v10, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[140:143], v[24:27], v[164:167], v11, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[140:143], v[16:19], v[160:163], v11, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[144:147], v[16:19], v[176:179], v11, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[144:147], v[24:27], v[180:183], v11, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[144:147], v[4:7], v[168:171], v11, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[140:143], v[4:7], v[36:39], v11, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[140:143], v[12:15], v[32:35], v11, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[144:147], v[12:15], v[172:175], v11, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[148:151], v[12:15], v[188:191], v20, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[148:151], v[4:7], v[184:187], v20, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[152:155], v[4:7], v[200:203], v20, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[152:155], v[12:15], v[204:207], v20, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[152:155], v[16:19], v[208:211], v20, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[148:151], v[16:19], v[192:195], v20, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[148:151], v[24:27], v[196:199], v20, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[152:155], v[24:27], v[212:215], v20, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[156:159], v[24:27], a[8:11], v21, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[156:159], v[16:19], a[4:7], v21, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[160:163], v[16:19], a[20:23], v21, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[160:163], v[24:27], a[24:27], v21, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[160:163], v[4:7], a[12:15], v21, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[156:159], v[4:7], v[216:219], v21, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[156:159], v[12:15], v[220:223], v21, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[160:163], v[12:15], a[16:19], v21, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[164:167], v[12:15], a[32:35], v23, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[164:167], v[4:7], a[28:31], v23, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[168:171], v[4:7], a[44:47], v23, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[168:171], v[12:15], a[48:51], v23, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[168:171], v[16:19], a[52:55], v23, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[164:167], v[16:19], a[36:39], v23, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[164:167], v[24:27], a[40:43], v23, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[168:171], v[24:27], a[56:59], v23, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[172:175], v[24:27], a[72:75], v132, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[172:175], v[16:19], a[68:71], v132, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[16:19], a[84:87], v132, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[24:27], a[88:91], v132, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[4:7], a[76:79], v132, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[172:175], v[4:7], a[60:63], v132, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[172:175], v[12:15], a[64:67], v132, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[12:15], a[80:83], v132, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v153, s[0:3], s29 offen
		buffer_load_dwordx4 v[12:15], v154, s[0:3], s29 offen
		buffer_load_dwordx4 v[16:19], v155, s[0:3], s29 offen
		buffer_load_dwordx4 v[24:27], v156, s[0:3], s29 offen
		s_barrier
		ds_read_b32 v2, v8 offset:10240
		ds_read_b32 v3, v8 offset:10496
		ds_read_b32 v10, v8 offset:10752
		ds_read_b32 v11, v8 offset:11008
		ds_read_b32 v20, v8 offset:11264
		ds_read_b32 v21, v8 offset:11520
		ds_read_b32 v23, v8 offset:11776
		ds_read_b32 v132, v8 offset:12032
		ds_read_b32 v8, v9 offset:12800
		ds_read_b32 v133, v9 offset:13056
		ds_read_b128 v[152:155], v0 offset:49152
		ds_read_b128 v[248:251], v0 offset:50176
		ds_read_b128 a[116:119], v0 offset:51200
		ds_read_b128 a[120:123], v0 offset:52224
		ds_read_b128 a[124:127], v0 offset:53248
		ds_read_b128 a[128:131], v0 offset:54272
		ds_read_b128 a[132:135], v0 offset:55296
		ds_read_b128 a[136:139], v0 offset:56320
		ds_read_b128 a[140:143], v0 offset:57344
		ds_read_b128 a[144:147], v0 offset:58368
		ds_read_b128 a[148:151], v0 offset:59392
		ds_read_b128 a[152:155], v0 offset:60416
		ds_read_b128 a[156:159], v0 offset:61440
		ds_read_b128 a[160:163], v0 offset:62464
		ds_read_b128 a[164:167], v0 offset:63488
		ds_read_b128 v[252:255], v0 offset:64512
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[136:139], v[4:7], v[28:31], v2, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[136:139], v[12:15], v[128:131], v2, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[140:143], v[12:15], v[112:115], v2, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[140:143], v[4:7], v[116:119], v2, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[140:143], v[16:19], v[108:111], v2, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[136:139], v[16:19], v[124:127], v2, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[136:139], v[24:27], v[120:123], v2, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[140:143], v[24:27], v[104:107], v2, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[144:147], v[24:27], v[88:91], v3, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[144:147], v[16:19], v[92:95], v3, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[148:151], v[16:19], v[76:79], v3, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[148:151], v[24:27], v[72:75], v3, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[148:151], v[4:7], v[84:87], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[144:147], v[4:7], v[100:103], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[144:147], v[12:15], v[96:99], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[148:151], v[12:15], v[80:83], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[224:227], v[12:15], v[64:67], v10, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[224:227], v[4:7], v[68:71], v10, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[228:231], v[4:7], v[52:55], v10, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[228:231], v[12:15], v[48:51], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[228:231], v[16:19], v[44:47], v10, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[224:227], v[16:19], v[60:63], v10, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[224:227], v[24:27], v[56:59], v10, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[228:231], v[24:27], v[40:43], v10, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[24:27], v[164:167], v11, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[16:19], v[160:163], v11, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[236:239], v[16:19], v[176:179], v11, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[236:239], v[24:27], v[180:183], v11, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[236:239], v[4:7], v[168:171], v11, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[232:235], v[4:7], v[36:39], v11, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[232:235], v[12:15], v[32:35], v11, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[236:239], v[12:15], v[172:175], v11, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[12:15], v[188:191], v20, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[4:7], v[184:187], v20, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[92:95], v[4:7], v[200:203], v20, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[92:95], v[12:15], v[204:207], v20, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[92:95], v[16:19], v[208:211], v20, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[16:19], v[192:195], v20, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[24:27], v[196:199], v20, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[92:95], v[24:27], v[212:215], v20, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[96:99], v[24:27], a[8:11], v21, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[96:99], v[16:19], a[4:7], v21, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[100:103], v[16:19], a[20:23], v21, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[100:103], v[24:27], a[24:27], v21, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[100:103], v[4:7], a[12:15], v21, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[96:99], v[4:7], v[216:219], v21, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[96:99], v[12:15], v[220:223], v21, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[100:103], v[12:15], a[16:19], v21, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[104:107], v[12:15], a[32:35], v23, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[136:139], v157, s[0:3], s29 offen
		buffer_load_dwordx4 v[140:143], v158, s[0:3], s29 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[104:107], v[4:7], a[28:31], v23, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[108:111], v[4:7], a[44:47], v23, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[144:147], v159, s[0:3], s29 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[108:111], v[12:15], a[48:51], v23, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[148:151], v1, s[0:3], s29 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[108:111], v[16:19], a[52:55], v23, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[104:107], v[16:19], a[36:39], v23, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[104:107], v[24:27], a[40:43], v23, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[108:111], v[24:27], a[56:59], v23, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[112:115], v[24:27], a[72:75], v132, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[112:115], v[16:19], a[68:71], v132, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[244:247], v[16:19], a[84:87], v132, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[244:247], v[24:27], a[88:91], v132, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[244:247], v[4:7], a[76:79], v132, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[112:115], v[4:7], a[60:63], v132, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[112:115], v[12:15], a[64:67], v132, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[244:247], v[12:15], a[80:83], v132, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[152:155], v[136:139], v[28:31], v2, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v0, 16, v22
		v_lshl_add_u32 v0, s4, 7, v0
		v_accvgpr_read_b32 v1, a0
		v_lshl_add_u32 v0, v1, 1, v0
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[152:155], v[140:143], v[128:131], v2, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s0, s5, 24
		s_lshl_b32 s1, s10, 9
		s_add_i32 s2, s0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[248:251], v[140:143], v[112:115], v2, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v1, v28
		s_lshl_b32 s3, s14, 22
		s_add_i32 s2, s2, s3
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[248:251], v[136:139], v[116:119], v2, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[248:251], v[144:147], v[108:111], v2, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[152:155], v[144:147], v[124:127], v2, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[152:155], v[148:151], v[120:123], v2, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[248:251], v[148:151], v[104:107], v2, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[116:119], v[148:151], v[88:91], v3, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[116:119], v[144:147], v[92:95], v3, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[120:123], v[144:147], v[76:79], v3, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[120:123], v[148:151], v[72:75], v3, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[120:123], v[136:139], v[84:87], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[116:119], v[136:139], v[100:103], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[116:119], v[140:143], v[96:99], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[120:123], v[140:143], v[80:83], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[124:127], v[140:143], v[64:67], v10, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[124:127], v[136:139], v[68:71], v10, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[128:131], v[136:139], v[52:55], v10, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[128:131], v[140:143], v[48:51], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[128:131], v[144:147], v[44:47], v10, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[124:127], v[144:147], v[60:63], v10, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[124:127], v[148:151], v[56:59], v10, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[128:131], v[148:151], v[40:43], v10, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[132:135], v[148:151], v[164:167], v11, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[132:135], v[144:147], v[160:163], v11, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[136:139], v[144:147], v[176:179], v11, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[136:139], v[148:151], v[180:183], v11, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[136:139], v[136:139], v[168:171], v11, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[132:135], v[136:139], v[36:39], v11, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[132:135], v[140:143], v[32:35], v11, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[136:139], v[140:143], v[172:175], v11, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[140:143], v[140:143], v[188:191], v20, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[140:143], v[136:139], v[184:187], v20, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[144:147], v[136:139], v[200:203], v20, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[144:147], v[140:143], v[204:207], v20, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[144:147], v[144:147], v[208:211], v20, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[140:143], v[144:147], v[192:195], v20, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[140:143], v[148:151], v[196:199], v20, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[144:147], v[148:151], v[212:215], v20, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[148:151], v[148:151], a[8:11], v21, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[148:151], v[144:147], a[4:7], v21, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[152:155], v[144:147], a[20:23], v21, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[152:155], v[148:151], a[24:27], v21, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[152:155], v[136:139], a[12:15], v21, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[148:151], v[136:139], v[216:219], v21, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[148:151], v[140:143], v[220:223], v21, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[152:155], v[140:143], a[16:19], v21, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[156:159], v[140:143], a[32:35], v23, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[156:159], v[136:139], a[28:31], v23, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[160:163], v[136:139], a[44:47], v23, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[160:163], v[140:143], a[48:51], v23, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[160:163], v[144:147], a[52:55], v23, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[156:159], v[144:147], a[36:39], v23, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[156:159], v[148:151], a[40:43], v23, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[160:163], v[148:151], a[56:59], v23, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[164:167], v[148:151], a[72:75], v132, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[164:167], v[144:147], a[68:71], v132, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[144:147], a[84:87], v132, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[148:151], a[88:91], v132, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[136:139], a[76:79], v132, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[164:167], v[136:139], a[60:63], v132, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[164:167], v[140:143], a[64:67], v132, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[140:143], a[80:83], v132, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s35, s19
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v29
		s_add_i32 s4, s0, 0x4000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v30
		s_add_i32 s5, s0, 0x8000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v31
		s_add_i32 s6, s0, 0xc000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v128
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v129
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v130
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v131
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v124
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v125
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v126
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v127
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v120
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v121
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v122
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v123
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v116
		s_add_i32 s2, s0, 0x40000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v117
		s_add_i32 s4, s0, 0x44000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v118
		s_add_i32 s5, s0, 0x48000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v119
		s_add_i32 s6, s0, 0x4c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v112
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v113
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v114
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v115
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v108
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v109
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v110
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v111
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v104
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v105
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v106
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v107
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v100
		s_add_i32 s2, s0, 0x80000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v101
		s_add_i32 s4, s0, 0x84000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v102
		s_add_i32 s5, s0, 0x88000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v103
		s_add_i32 s6, s0, 0x8c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v96
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v97
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v98
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v99
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v92
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v93
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v94
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v95
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v88
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v89
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v90
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v91
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v84
		s_add_i32 s2, s0, 0xc0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v85
		s_add_i32 s4, s0, 0xc4000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v86
		s_add_i32 s5, s0, 0xc8000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v87
		s_add_i32 s6, s0, 0xcc000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v80
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v81
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v82
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v83
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v76
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v77
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v78
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v79
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v72
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v73
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v74
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v75
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v68
		s_add_i32 s2, s0, 0x100000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v69
		s_add_i32 s4, s0, 0x104000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v70
		s_add_i32 s5, s0, 0x108000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v71
		s_add_i32 s6, s0, 0x10c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v64
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v65
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v66
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v67
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v60
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v61
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v62
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v63
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v56
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v57
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v58
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v59
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v52
		s_add_i32 s2, s0, 0x140000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v53
		s_add_i32 s4, s0, 0x144000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v54
		s_add_i32 s5, s0, 0x148000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v55
		s_add_i32 s6, s0, 0x14c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v48
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v49
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v50
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v51
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v44
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v45
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v46
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v47
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v40
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v41
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v42
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v43
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v36
		s_add_i32 s2, s0, 0x180000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v37
		s_add_i32 s4, s0, 0x184000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v38
		s_add_i32 s5, s0, 0x188000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v39
		s_add_i32 s6, s0, 0x18c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v32
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v33
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v34
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v35
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v160
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v161
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v162
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v163
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v164
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v165
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v166
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v167
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v168
		s_add_i32 s2, s0, 0x1c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v169
		s_add_i32 s4, s0, 0x1c4000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v170
		s_add_i32 s5, s0, 0x1c8000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v171
		s_add_i32 s6, s0, 0x1cc000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v172
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v173
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v174
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v175
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v176
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v177
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v178
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v179
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v180
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v181
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v182
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v183
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v184
		s_add_i32 s2, s0, 0x200000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v185
		s_add_i32 s4, s0, 0x204000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v186
		s_add_i32 s5, s0, 0x208000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v187
		s_add_i32 s6, s0, 0x20c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v188
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v189
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v190
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v191
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v192
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v193
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v194
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v195
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v196
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v197
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v198
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v199
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v200
		s_add_i32 s2, s0, 0x240000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v201
		s_add_i32 s4, s0, 0x244000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v202
		s_add_i32 s5, s0, 0x248000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v203
		s_add_i32 s6, s0, 0x24c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v204
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v205
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v206
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v207
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v208
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v209
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v210
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v211
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_cvt_f16_f32_e64 v1, v212
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v213
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v214
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v215
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_cvt_f16_f32_e64 v1, v216
		s_add_i32 s2, s0, 0x280000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v217
		s_add_i32 s4, s0, 0x284000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v218
		s_add_i32 s5, s0, 0x288000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v219
		s_add_i32 s6, s0, 0x28c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_cvt_f16_f32_e64 v1, v220
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v221
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v222
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_cvt_f16_f32_e64 v1, v223
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a4
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a5
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a6
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a7
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a8
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a9
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a10
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a11
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a12
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x2c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a13
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s4, s0, 0x2c4000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v1, a14
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x2c8000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a15
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x2cc000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a16
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a17
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a18
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a19
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a20
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a21
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a22
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a23
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a24
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a25
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a26
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a27
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a28
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x300000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a29
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s4, s0, 0x304000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v1, a30
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x308000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a31
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x30c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a32
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a33
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a34
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a35
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a36
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a37
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a38
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a39
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a40
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a41
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a42
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a43
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a44
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x340000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a45
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s4, s0, 0x344000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v1, a46
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x348000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a47
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x34c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a48
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a49
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a50
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a51
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a52
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a53
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a54
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a55
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a56
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a57
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a58
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a59
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a60
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x380000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a61
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s4, s0, 0x384000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v1, a62
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x388000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a63
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s6, s0, 0x38c000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_short v1, v0, s[32:35], s6 offen sc0 nt
		v_accvgpr_read_b32 v1, a64
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a65
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a66
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a67
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a68
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a69
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a70
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a71
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a72
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a73
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a74
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a75
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s6 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a76
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s2, s0, 0x3c0000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_short v1, v0, s[32:35], s2 offen sc0 nt
		v_accvgpr_read_b32 v1, a77
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s4, s0, 0x3c4000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_short v1, v0, s[32:35], s4 offen sc0 nt
		v_accvgpr_read_b32 v1, a78
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s5, s0, 0x3c8000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_short v1, v0, s[32:35], s5 offen sc0 nt
		v_accvgpr_read_b32 v1, a79
		v_cvt_f16_f32_e64 v1, v1
		s_add_i32 s0, s0, 0x3cc000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		buffer_store_short v1, v0, s[32:35], s0 offen sc0 nt
		v_accvgpr_read_b32 v1, a80
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a81
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a82
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a83
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s0 offen offset:32 sc0 nt
		v_accvgpr_read_b32 v1, a84
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a85
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a86
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a87
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s0 offen offset:64 sc0 nt
		v_accvgpr_read_b32 v1, a88
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s2 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a89
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s4 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a90
		v_cvt_f16_f32_e64 v1, v1
		buffer_store_short v1, v0, s[32:35], s5 offen offset:96 sc0 nt
		v_accvgpr_read_b32 v1, a91
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
		.amdhsa_next_free_vgpr 476
		.amdhsa_next_free_sgpr 42
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 220
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 42
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
    .sgpr_count:     42
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     476
    .agpr_count:     220
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 174
    wave.regalloc.agpr.dwords: 686
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
