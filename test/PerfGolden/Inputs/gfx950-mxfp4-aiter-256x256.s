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
		s_lshr_b32 s4, s14, 4
		s_lshl_b32 s5, s4, 24
		s_lshl_b32 s12, s14, 3
		s_add_i32 s12, s13, s12
		s_and_b32 s12, s12, 0x7f
		s_lshr_b32 s13, s12, 2
		s_lshl_b32 s14, s13, 17
		s_add_i32 s5, s5, s14
		s_and_b32 s12, s12, 3
		s_lshl_b32 s14, s12, 22
		s_add_i32 s5, s5, s14
		v_readfirstlane_b32 s14, v0
		s_lshl_b32 s15, s4, 21
		s_lshl_b32 s28, s12, 19
		s_add_i32 s29, s15, s28
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 15, v1
		v_add_u32_e32 v3, s29, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 11, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		s_add_i32 s29, s15, 0x20000
		s_add_i32 s29, s29, s28
		v_add_u32_e32 v7, v2, v5
		s_add_i32 s30, s15, 0x40000
		s_add_i32 s30, s30, s28
		s_add_i32 s31, s15, 0x60000
		s_add_i32 s31, s31, s28
		s_add_i32 s32, s15, 64
		s_add_i32 s32, s32, s28
		v_add_u32_e32 v8, v2, v5
		s_add_i32 s33, s15, 0x20040
		s_add_i32 s33, s33, s28
		s_add_i32 s34, s15, 0x40040
		s_add_i32 s34, s34, s28
		s_add_i32 s35, s15, 0x60040
		s_add_i32 s35, s35, s28
		v_add_u32_e32 v9, v2, v5
		s_add_i32 s36, s15, 0x80
		s_add_i32 s36, s36, s28
		s_add_i32 s37, s15, 0x20080
		s_add_i32 s37, s37, s28
		s_add_i32 s38, s15, 0x40080
		s_add_i32 s38, s38, s28
		v_add_u32_e32 v10, v2, v5
		s_add_i32 s39, s15, 0x60080
		s_add_i32 s39, s39, s28
		s_add_i32 s40, s15, 0xc0
		s_add_i32 s40, s40, s28
		s_add_i32 s41, s15, 0x200c0
		s_add_i32 s41, s41, s28
		v_add_u32_e32 v11, v2, v5
		s_add_i32 s42, s15, 0x400c0
		s_add_i32 s42, s42, s28
		s_add_i32 s15, s15, 0x600c0
		s_add_i32 s15, s15, s28
		s_lshr_b32 s14, s14, 6
		s_lshl_b32 s28, s14, 10
		s_mov_b32 m0, s28
		v_add3_u32 v3, v3, v5, v6
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		v_add3_u32 v5, v6, v7, s29
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, v6, v7, s30
		v_add3_u32 v7, v6, v7, s31
		v_add3_u32 v13, v6, v8, s32
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v14, v6, v8, s33
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v8, v6, v8, s34
		v_add3_u32 v15, v6, v9, s35
		v_add3_u32 v16, v6, v9, s36
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_add3_u32 v9, v6, v9, s37
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v17, v6, v10, s38
		v_add3_u32 v18, v6, v10, s39
		v_add3_u32 v10, v6, v10, s40
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_add3_u32 v19, v6, v11, s41
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v20, v6, v11, s42
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_mov_b32 s29, 0x5000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s30, 0x2000
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		v_lshl_add_u32 v2, v4, 3, v2
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v21, 10, v1
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v22, 2, v4
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v23, 15, v0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v1, 17, v1
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v24, 15, v4
		v_lshrrev_b32_e32 v25, 4, v4
		v_lshrrev_b32_e32 v0, 7, v0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v0, 8, v0
		s_add_i32 m0, m0, 0x1000
		v_lshl_add_u32 v26, s14, 2, v25
		v_and_b32_e32 v26, 7, v26
		v_lshlrev_b32_e32 v26, 12, v26
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v24, 4, v24
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v27, 1, v25
		v_lshrrev_b32_e32 v28, 5, v4
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		v_lshlrev_b32_e32 v28, 8, v28
		s_add_i32 m0, m0, 0x1000
		v_lshl_add_u32 v28, s14, 13, v28
		v_lshlrev_b32_e32 v27, 12, v27
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s14, 0
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_mov_b32 s31, 0x1000
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v29, 1, v23
		v_bitop3_b32 v25, v25, v29, 3 bitop3:0x78
		v_accvgpr_write_b32 a0, v25
		buffer_load_dwordx4 v19, s[16:19], 0 offen lds
		v_accvgpr_read_b32 v25, a0
		v_lshlrev_b32_e32 v25, 4, v25
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s32, s6, s5
		s_addc_u32 s33, s7, 0
		buffer_load_dwordx4 v20, s[16:19], 0 offen lds
		s_mov_b32 s34, 0x20000
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v6, v6, v11, s15
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 s5, 0x100
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s6, 0x4000
		buffer_load_dwordx4 v3, s[16:19], s5 offen lds
		s_mov_b32 s7, 0x3000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s15, 0x7000
		buffer_load_dwordx4 v5, s[16:19], s5 offen lds
		s_mov_b32 s36, 0x6000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		buffer_load_dwordx4 v12, s[16:19], s5 offen lds
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_add_i32 m0, m0, 0x1000
		v_lshlrev_b32_e32 v4, 4, v4
		buffer_load_dwordx4 v7, s[16:19], s5 offen lds
		v_add3_u32 v0, v0, v26, v24
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v11, v28, v27, v24
		buffer_load_dwordx4 v13, s[16:19], s5 offen lds
		v_lshlrev_b32_e32 v23, 6, v23
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		buffer_load_dwordx4 v14, s[16:19], s5 offen lds
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		buffer_load_dwordx4 v8, s[16:19], s5 offen lds
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		buffer_load_dwordx4 v15, s[16:19], s5 offen lds
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		buffer_load_dwordx4 v16, s[16:19], s5 offen lds
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		buffer_load_dwordx4 v9, s[16:19], s5 offen lds
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		buffer_load_dwordx4 v17, s[16:19], s5 offen lds
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		buffer_load_dwordx4 v18, s[16:19], s5 offen lds
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		buffer_load_dwordx4 v10, s[16:19], s5 offen lds
		s_lshl_b32 s8, s13, 15
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v24, s8, v11
		v_add_u32_e32 v26, 0x400, v24
		buffer_load_dwordx4 v19, s[16:19], s5 offen lds
		s_lshl_b32 s9, s12, 15
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s4, s4, 17
		buffer_load_dwordx4 v20, s[16:19], s5 offen lds
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		buffer_load_dwordx4 v6, s[16:19], s5 offen lds
		s_add_i32 s5, s4, s9
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v24, s5, v0
		v_add_u32_e32 v27, 0x400, v24
		buffer_load_dwordx4 v0, s[20:23], s5 offen lds
		s_lshl_b32 s5, s13, 19
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v24, s5, v1, v4
		buffer_load_dwordx4 v11, s[24:27], s8 offen lds
		s_add_i32 s4, s4, 0x200
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s4, s4, s9
		buffer_load_dwordx4 v0, s[20:23], s4 offen lds
		s_add_i32 s4, s8, 0x200
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s8, s5, 0x8000
		v_add3_u32 v0, s8, v1, v4
		s_add_i32 s8, s5, 0x10000
		v_add3_u32 v100, s8, v1, v4
		buffer_load_dwordx4 v11, s[24:27], s4 offen lds
		s_add_i32 s4, s5, 0x18000
		v_add3_u32 v11, s4, v1, v4
		buffer_load_dwordx4 v[104:107], v24, s[0:3], 0 offen
		buffer_load_dwordx4 v[108:111], v0, s[0:3], 0 offen
		buffer_load_dwordx4 v[112:115], v100, s[0:3], 0 offen
		buffer_load_dwordx4 v[116:119], v11, s[0:3], 0 offen
		s_waitcnt vmcnt(6)
		s_barrier
		s_add_i32 s4, s5, 0x400
		v_add3_u32 v101, s4, v1, v4
		s_add_i32 s4, s5, 0x8400
		v_add3_u32 v102, s4, v1, v4
		s_add_i32 s4, s5, 0x10400
		v_add3_u32 v103, s4, v1, v4
		s_add_i32 s4, s5, 0x18400
		v_add3_u32 v120, s4, v1, v4
		s_add_i32 s4, s5, 0x800
		v_add3_u32 v121, s4, v1, v4
		s_add_i32 s4, s5, 0x8800
		v_add3_u32 v122, s4, v1, v4
		s_add_i32 s4, s5, 0x10800
		v_add3_u32 v123, s4, v1, v4
		s_add_i32 s4, s5, 0x18800
		v_add3_u32 v124, s4, v1, v4
		s_add_i32 s4, s5, 0xc00
		v_add3_u32 v125, s4, v1, v4
		s_add_i32 s4, s5, 0x8c00
		v_add3_u32 v126, s4, v1, v4
		s_add_i32 s4, s5, 0x10c00
		v_add3_u32 v127, s4, v1, v4
		s_add_i32 s4, s5, 0x18c00
		v_add3_u32 v1, s4, v1, v4
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
		s_mov_b32 s4, s14
		s_mov_b32 s5, s31
		s_mov_b32 s8, s14
		s_mov_b32 s9, s28
		s_mov_b32 s10, s14
		s_mov_b32 s11, s14
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s4, s11, 12
		buffer_load_dwordx4 v[224:227], v101, s[0:3], s4 offen
		buffer_load_dwordx4 v[228:231], v102, s[0:3], s4 offen
		buffer_load_dwordx4 v[232:235], v103, s[0:3], s4 offen
		buffer_load_dwordx4 v[236:239], v120, s[0:3], s4 offen
		s_and_b32 s12, s11, 1
		s_lshl_b32 s12, s12, 16
		v_add3_u32 v4, s12, v23, v25
		ds_read_b128 a[92:95], v4
		ds_read_b128 a[96:99], v4 offset:1024
		ds_read_b128 a[100:103], v4 offset:2048
		ds_read_b128 a[104:107], v4 offset:3072
		ds_read_b128 a[108:111], v4 offset:4096
		ds_read_b128 a[112:115], v4 offset:5120
		ds_read_b128 a[116:119], v4 offset:6144
		ds_read_b128 a[120:123], v4 offset:7168
		ds_read_b128 a[124:127], v4 offset:8192
		ds_read_b128 a[128:131], v4 offset:9216
		ds_read_b128 a[132:135], v4 offset:10240
		ds_read_b128 a[136:139], v4 offset:11264
		ds_read_b128 a[140:143], v4 offset:12288
		ds_read_b128 a[144:147], v4 offset:13312
		ds_read_b128 a[148:151], v4 offset:14336
		ds_read_b128 a[152:155], v4 offset:15360
		s_add_i32 s12, s8, 0x20000
		v_add_u32_e32 v240, s12, v22
		ds_read2st64_b32 v[242:243], v240 offset1:1
		ds_read2st64_b32 v[244:245], v240 offset0:2 offset1:3
		ds_read2st64_b32 v[246:247], v240 offset0:4 offset1:5
		ds_read2st64_b32 v[248:249], v240 offset0:6 offset1:7
		v_add3_u32 v241, s12, v21, v22
		ds_read2st64_b32 v[250:251], v241 offset0:16 offset1:17
		ds_read_b128 a[156:159], v4 offset:16384
		ds_read_b128 a[160:163], v4 offset:17408
		ds_read_b128 a[164:167], v4 offset:18432
		ds_read_b128 a[168:171], v4 offset:19456
		ds_read_b128 a[172:175], v4 offset:20480
		ds_read_b128 a[176:179], v4 offset:21504
		ds_read_b128 a[180:183], v4 offset:22528
		ds_read_b128 a[184:187], v4 offset:23552
		ds_read_b128 a[188:191], v4 offset:24576
		ds_read_b128 a[192:195], v4 offset:25600
		ds_read_b128 a[196:199], v4 offset:26624
		ds_read_b128 a[200:203], v4 offset:27648
		ds_read_b128 a[204:207], v4 offset:28672
		ds_read_b128 a[208:211], v4 offset:29696
		ds_read_b128 a[212:215], v4 offset:30720
		ds_read_b128 a[216:219], v4 offset:31744
		s_waitcnt vmcnt(7) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[92:95], v[104:107], v[32:35], v242, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s12, s10, 0x2000
		s_add_i32 s13, s9, 0x10000
		s_add_i32 s8, s8, 0x2000
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], v[108:111], v[96:99], v242, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s8, s8, 0x3fff
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], v[108:111], v[80:83], v242, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], v[104:107], v[84:87], v242, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[96:99], v[112:115], v[76:79], v242, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], v[112:115], v[92:95], v242, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], v[116:119], v[88:91], v242, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], v[116:119], v[72:75], v242, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[100:103], v[116:119], v[56:59], v243, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[100:103], v[112:115], v[60:63], v243, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[104:107], v[112:115], v[44:47], v243, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[104:107], v[116:119], v[40:43], v243, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[104:107], v[104:107], v[52:55], v243, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[100:103], v[104:107], v[68:71], v243, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[100:103], v[108:111], v[64:67], v243, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[104:107], v[108:111], v[48:51], v243, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[108:111], v[108:111], v[28:31], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[108:111], v[104:107], v[36:39], v244, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[112:115], v[104:107], v[136:139], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[112:115], v[108:111], v[140:143], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[112:115], v[112:115], v[144:147], v244, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[108:111], v[112:115], v[128:131], v244, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[108:111], v[116:119], v[132:135], v244, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[112:115], v[116:119], v[148:151], v244, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[116:119], v[116:119], v[164:167], v245, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[116:119], v[112:115], v[160:163], v245, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[120:123], v[112:115], v[176:179], v245, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[120:123], v[116:119], v[180:183], v245, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[120:123], v[104:107], v[168:171], v245, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[116:119], v[104:107], v[152:155], v245, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[116:119], v[108:111], v[156:159], v245, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[120:123], v[108:111], v[172:175], v245, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[124:127], v[108:111], v[188:191], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[124:127], v[104:107], v[184:187], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[128:131], v[104:107], v[200:203], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[128:131], v[108:111], v[204:207], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[128:131], v[112:115], v[208:211], v246, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[124:127], v[112:115], v[192:195], v246, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[124:127], v[116:119], v[196:199], v246, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[128:131], v[116:119], v[212:215], v246, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[116:119], a[8:11], v247, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[132:135], v[112:115], a[4:7], v247, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[136:139], v[112:115], a[20:23], v247, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[116:119], a[24:27], v247, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[136:139], v[104:107], a[12:15], v247, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[132:135], v[104:107], v[216:219], v247, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[132:135], v[108:111], v[220:223], v247, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[136:139], v[108:111], a[16:19], v247, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[140:143], v[108:111], a[32:35], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[140:143], v[104:107], a[28:31], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[144:147], v[104:107], a[44:47], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[144:147], v[108:111], a[48:51], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[144:147], v[112:115], a[52:55], v248, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[140:143], v[112:115], a[36:39], v248, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[116:119], a[40:43], v248, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[116:119], a[56:59], v248, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[116:119], a[72:75], v249, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[148:151], v[112:115], a[68:71], v249, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[152:155], v[112:115], a[84:87], v249, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[152:155], v[116:119], a[88:91], v249, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[152:155], v[104:107], a[76:79], v249, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[148:151], v[104:107], a[60:63], v249, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[148:151], v[108:111], a[64:67], v249, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[152:155], v[108:111], a[80:83], v249, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 m0, s9
		s_lshl_b32 s9, s11, 8
		s_add_i32 s35, s9, 0x200
		buffer_load_dwordx4 v3, s[16:19], s35 offen lds
		ds_read_b128 a[92:95], v4 offset:32768
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s9, s13, 0x1ffff
		s_and_b32 s12, s12, 0x3fff
		s_add_i32 s11, s11, 1
		buffer_load_dwordx4 v5, s[16:19], s35 offen lds
		ds_read_b128 a[96:99], v4 offset:33792
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s10, s28, s10
		buffer_load_dwordx4 v12, s[16:19], s35 offen lds
		ds_read_b128 a[100:103], v4 offset:34816
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s5, s4
		buffer_load_dwordx4 v7, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[104:107], v121, s[0:3], s4 offen
		buffer_load_dwordx4 v[108:111], v122, s[0:3], s4 offen
		buffer_load_dwordx4 v[112:115], v123, s[0:3], s4 offen
		buffer_load_dwordx4 v[116:119], v124, s[0:3], s4 offen
		ds_read_b128 a[104:107], v4 offset:35840
		ds_read_b128 a[108:111], v4 offset:36864
		ds_read_b128 a[112:115], v4 offset:37888
		ds_read_b128 a[116:119], v4 offset:38912
		ds_read_b128 a[120:123], v4 offset:39936
		ds_read_b128 a[124:127], v4 offset:40960
		ds_read_b128 a[128:131], v4 offset:41984
		ds_read_b128 a[132:135], v4 offset:43008
		ds_read_b128 a[136:139], v4 offset:44032
		ds_read_b128 a[140:143], v4 offset:45056
		ds_read_b128 a[144:147], v4 offset:46080
		ds_read_b128 a[148:151], v4 offset:47104
		ds_read_b128 a[152:155], v4 offset:48128
		s_waitcnt vmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[156:159], v[224:227], v[32:35], v242, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[156:159], v[228:231], v[96:99], v242, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[160:163], v[228:231], v[80:83], v242, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[160:163], v[224:227], v[84:87], v242, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[160:163], v[232:235], v[76:79], v242, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[156:159], v[232:235], v[92:95], v242, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[156:159], v[236:239], v[88:91], v242, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[160:163], v[236:239], v[72:75], v242, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[164:167], v[236:239], v[56:59], v243, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[164:167], v[232:235], v[60:63], v243, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[168:171], v[232:235], v[44:47], v243, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[168:171], v[236:239], v[40:43], v243, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[168:171], v[224:227], v[52:55], v243, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[164:167], v[224:227], v[68:71], v243, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[164:167], v[228:231], v[64:67], v243, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[168:171], v[228:231], v[48:51], v243, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[172:175], v[228:231], v[28:31], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[172:175], v[224:227], v[36:39], v244, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[176:179], v[224:227], v[136:139], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[176:179], v[228:231], v[140:143], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[176:179], v[232:235], v[144:147], v244, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[172:175], v[232:235], v[128:131], v244, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[172:175], v[236:239], v[132:135], v244, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[176:179], v[236:239], v[148:151], v244, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[180:183], v[236:239], v[164:167], v245, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[180:183], v[232:235], v[160:163], v245, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[184:187], v[232:235], v[176:179], v245, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[184:187], v[236:239], v[180:183], v245, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[184:187], v[224:227], v[168:171], v245, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[180:183], v[224:227], v[152:155], v245, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[180:183], v[228:231], v[156:159], v245, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		buffer_load_dwordx4 v13, s[16:19], s35 offen lds
		ds_read2st64_b32 v[226:227], v240 offset0:10 offset1:11
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], s35 offen lds
		ds_read2st64_b32 v[228:229], v240 offset0:12 offset1:13
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v8, s[16:19], s35 offen lds
		ds_read2st64_b32 v[230:231], v240 offset0:14 offset1:15
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[232:235], v125, s[0:3], s4 offen
		buffer_load_dwordx4 v[236:239], v126, s[0:3], s4 offen
		buffer_load_dwordx4 v[244:247], v127, s[0:3], s4 offen
		buffer_load_dwordx4 v[248:251], v1, s[0:3], s4 offen
		ds_read2st64_b32 v[242:243], v241 offset0:18 offset1:19
		ds_read_b128 a[156:159], v4 offset:49152
		ds_read_b128 a[160:163], v4 offset:50176
		ds_read_b128 a[164:167], v4 offset:51200
		ds_read_b128 a[168:171], v4 offset:52224
		ds_read_b128 a[172:175], v4 offset:53248
		ds_read_b128 a[176:179], v4 offset:54272
		ds_read_b128 a[180:183], v4 offset:55296
		ds_read_b128 a[184:187], v4 offset:56320
		ds_read_b128 a[188:191], v4 offset:57344
		ds_read_b128 a[192:195], v4 offset:58368
		ds_read_b128 a[196:199], v4 offset:59392
		ds_read_b128 a[200:203], v4 offset:60416
		ds_read_b128 a[204:207], v4 offset:61440
		ds_read_b128 a[208:211], v4 offset:62464
		ds_read_b128 a[212:215], v4 offset:63488
		ds_read_b128 v[252:255], v4 offset:64512
		s_waitcnt vmcnt(11) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[92:95], v[104:107], v[32:35], v224, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[92:95], v[108:111], v[96:99], v224, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[96:99], v[108:111], v[80:83], v224, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[96:99], v[104:107], v[84:87], v224, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[96:99], v[112:115], v[76:79], v224, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[92:95], v[112:115], v[92:95], v224, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[92:95], v[116:119], v[88:91], v224, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[96:99], v[116:119], v[72:75], v224, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[100:103], v[116:119], v[56:59], v225, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[100:103], v[112:115], v[60:63], v225, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[104:107], v[112:115], v[44:47], v225, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[104:107], v[116:119], v[40:43], v225, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[104:107], v[104:107], v[52:55], v225, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[100:103], v[104:107], v[68:71], v225, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[100:103], v[108:111], v[64:67], v225, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[104:107], v[108:111], v[48:51], v225, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[108:111], v[108:111], v[28:31], v226, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[108:111], v[104:107], v[36:39], v226, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[112:115], v[104:107], v[136:139], v226, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[112:115], v[108:111], v[140:143], v226, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[112:115], v[112:115], v[144:147], v226, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[108:111], v[112:115], v[128:131], v226, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[108:111], v[116:119], v[132:135], v226, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[112:115], v[116:119], v[148:151], v226, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[116:119], v[116:119], v[164:167], v227, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[116:119], v[112:115], v[160:163], v227, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[120:123], v[112:115], v[176:179], v227, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[120:123], v[116:119], v[180:183], v227, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[120:123], v[104:107], v[168:171], v227, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[116:119], v[104:107], v[152:155], v227, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[116:119], v[108:111], v[156:159], v227, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[120:123], v[108:111], v[172:175], v227, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[124:127], v[108:111], v[188:191], v228, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[124:127], v[104:107], v[184:187], v228, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[128:131], v[104:107], v[200:203], v228, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[128:131], v[108:111], v[204:207], v228, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[128:131], v[112:115], v[208:211], v228, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[124:127], v[112:115], v[192:195], v228, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[124:127], v[116:119], v[196:199], v228, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[128:131], v[116:119], v[212:215], v228, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[132:135], v[116:119], a[8:11], v229, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[132:135], v[112:115], a[4:7], v229, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[136:139], v[112:115], a[20:23], v229, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[136:139], v[116:119], a[24:27], v229, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[136:139], v[104:107], a[12:15], v229, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[132:135], v[104:107], v[216:219], v229, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[132:135], v[108:111], v[220:223], v229, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[136:139], v[108:111], a[16:19], v229, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[140:143], v[108:111], a[32:35], v230, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[140:143], v[104:107], a[28:31], v230, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[144:147], v[104:107], a[44:47], v230, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[144:147], v[108:111], a[48:51], v230, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[144:147], v[112:115], a[52:55], v230, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[140:143], v[112:115], a[36:39], v230, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[140:143], v[116:119], a[40:43], v230, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[144:147], v[116:119], a[56:59], v230, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[148:151], v[116:119], a[72:75], v231, v243 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[148:151], v[112:115], a[68:71], v231, v243 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[152:155], v[112:115], a[84:87], v231, v243 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[152:155], v[116:119], a[88:91], v231, v243 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[152:155], v[104:107], a[76:79], v231, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[148:151], v[104:107], a[60:63], v231, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[148:151], v[108:111], a[64:67], v231, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[152:155], v[108:111], a[80:83], v231, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], s35 offen lds
		buffer_load_dwordx4 v[104:107], v24, s[0:3], s5 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[156:159], v[232:235], v[32:35], v224, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[108:111], v0, s[0:3], s5 offen
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[156:159], v[236:239], v[96:99], v224, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[112:115], v100, s[0:3], s5 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[160:163], v[236:239], v[80:83], v224, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[116:119], v11, s[0:3], s5 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[160:163], v[232:235], v[84:87], v224, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[160:163], v[244:247], v[76:79], v224, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[156:159], v[244:247], v[92:95], v224, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[156:159], v[248:251], v[88:91], v224, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[160:163], v[248:251], v[72:75], v224, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[164:167], v[248:251], v[56:59], v225, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[164:167], v[244:247], v[60:63], v225, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[168:171], v[244:247], v[44:47], v225, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[168:171], v[248:251], v[40:43], v225, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[168:171], v[232:235], v[52:55], v225, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[164:167], v[232:235], v[68:71], v225, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[164:167], v[236:239], v[64:67], v225, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[168:171], v[236:239], v[48:51], v225, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[172:175], v[236:239], v[28:31], v226, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[172:175], v[232:235], v[36:39], v226, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[176:179], v[232:235], v[136:139], v226, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[176:179], v[236:239], v[140:143], v226, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[176:179], v[244:247], v[144:147], v226, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[172:175], v[244:247], v[128:131], v226, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[172:175], v[248:251], v[132:135], v226, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[176:179], v[248:251], v[148:151], v226, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[180:183], v[248:251], v[164:167], v227, v243 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[180:183], v[244:247], v[160:163], v227, v243 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[184:187], v[244:247], v[176:179], v227, v243 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[184:187], v[248:251], v[180:183], v227, v243 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[184:187], v[232:235], v[168:171], v227, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[180:183], v[232:235], v[152:155], v227, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[180:183], v[236:239], v[156:159], v227, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		buffer_load_dwordx4 v10, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v19, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v20, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v6, s[16:19], s35 offen lds
		s_nop 0
		s_add_i32 m0, s10, 0x20000
		s_nop 0
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_add_u32 s20, s20, 0x200
		s_addc_u32 s21, s21, 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x200
		s_addc_u32 s25, s25, 0
		s_cmp_lt_i32 s11, 6
		s_mov_b32 s4, s14
		s_mov_b32 s5, s31
		s_mov_b32 s10, s12
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		v_accvgpr_read_b32 v3, a0
		v_lshl_add_u32 v3, v3, 4, v23
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[12:15], v3 offset:1024
		ds_read_b128 v[16:19], v3 offset:2048
		ds_read_b128 v[224:227], v3 offset:3072
		ds_read_b128 v[228:231], v3 offset:4096
		ds_read_b128 v[232:235], v3 offset:5120
		ds_read_b128 v[236:239], v3 offset:6144
		ds_read_b128 v[240:243], v3 offset:7168
		ds_read_b128 a[92:95], v3 offset:8192
		ds_read_b128 a[96:99], v3 offset:9216
		ds_read_b128 a[100:103], v3 offset:10240
		ds_read_b128 a[104:107], v3 offset:11264
		ds_read_b128 a[108:111], v3 offset:12288
		ds_read_b128 a[112:115], v3 offset:13312
		ds_read_b128 a[116:119], v3 offset:14336
		ds_read_b128 a[120:123], v3 offset:15360
		v_add_u32_e32 v8, 0x20000, v22
		ds_read2st64_b32 v[26:27], v8 offset1:1
		ds_read2st64_b32 v[244:245], v8 offset0:2 offset1:3
		ds_read2st64_b32 v[246:247], v8 offset0:4 offset1:5
		ds_read2st64_b32 v[248:249], v8 offset0:6 offset1:7
		v_add_u32_e32 v9, 0x20000, v21
		v_add_u32_e32 v9, v9, v22
		ds_read2st64_b32 v[20:21], v9 offset0:16 offset1:17
		ds_read_b128 a[124:127], v3 offset:16384
		ds_read_b128 a[128:131], v3 offset:17408
		ds_read_b128 a[132:135], v3 offset:18432
		ds_read_b128 a[136:139], v3 offset:19456
		ds_read_b128 a[140:143], v3 offset:20480
		ds_read_b128 a[144:147], v3 offset:21504
		ds_read_b128 a[148:151], v3 offset:22528
		ds_read_b128 a[152:155], v3 offset:23552
		ds_read_b128 a[156:159], v3 offset:24576
		ds_read_b128 a[160:163], v3 offset:25600
		ds_read_b128 a[164:167], v3 offset:26624
		ds_read_b128 a[168:171], v3 offset:27648
		ds_read_b128 a[172:175], v3 offset:28672
		ds_read_b128 a[176:179], v3 offset:29696
		ds_read_b128 a[180:183], v3 offset:30720
		ds_read_b128 v[252:255], v3 offset:31744
		s_waitcnt vmcnt(9) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[4:7], v[104:107], v[32:35], v26, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[4:7], v[108:111], v[96:99], v26, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[108:111], v[80:83], v26, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[104:107], v[84:87], v26, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], v[112:115], v[76:79], v26, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[4:7], v[112:115], v[92:95], v26, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[4:7], v[116:119], v[88:91], v26, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[12:15], v[116:119], v[72:75], v26, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[16:19], v[116:119], v[56:59], v27, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[16:19], v[112:115], v[60:63], v27, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[224:227], v[112:115], v[44:47], v27, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[224:227], v[116:119], v[40:43], v27, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[224:227], v[104:107], v[52:55], v27, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[104:107], v[68:71], v27, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[16:19], v[108:111], v[64:67], v27, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[224:227], v[108:111], v[48:51], v27, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[228:231], v[108:111], v[28:31], v244, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[228:231], v[104:107], v[36:39], v244, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[104:107], v[136:139], v244, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[108:111], v[140:143], v244, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[112:115], v[144:147], v244, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[228:231], v[112:115], v[128:131], v244, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[228:231], v[116:119], v[132:135], v244, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[116:119], v[148:151], v244, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[116:119], v[164:167], v245, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[112:115], v[160:163], v245, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[240:243], v[112:115], v[176:179], v245, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[240:243], v[116:119], v[180:183], v245, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[240:243], v[104:107], v[168:171], v245, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[236:239], v[104:107], v[152:155], v245, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[108:111], v[156:159], v245, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[240:243], v[108:111], v[172:175], v245, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[92:95], v[108:111], v[188:191], v246, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[92:95], v[104:107], v[184:187], v246, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[96:99], v[104:107], v[200:203], v246, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[96:99], v[108:111], v[204:207], v246, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[96:99], v[112:115], v[208:211], v246, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[92:95], v[112:115], v[192:195], v246, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[92:95], v[116:119], v[196:199], v246, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[96:99], v[116:119], v[212:215], v246, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[100:103], v[116:119], a[8:11], v247, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[100:103], v[112:115], a[4:7], v247, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[104:107], v[112:115], a[20:23], v247, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[104:107], v[116:119], a[24:27], v247, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[104:107], v[104:107], a[12:15], v247, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[100:103], v[104:107], v[216:219], v247, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[100:103], v[108:111], v[220:223], v247, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[104:107], v[108:111], a[16:19], v247, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[108:111], v[108:111], a[32:35], v248, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[108:111], v[104:107], a[28:31], v248, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[112:115], v[104:107], a[44:47], v248, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[112:115], v[108:111], a[48:51], v248, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[112:115], v[112:115], a[52:55], v248, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[108:111], v[112:115], a[36:39], v248, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[108:111], v[116:119], a[40:43], v248, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[112:115], v[116:119], a[56:59], v248, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[116:119], v[116:119], a[72:75], v249, v21 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[116:119], v[112:115], a[68:71], v249, v21 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[120:123], v[112:115], a[84:87], v249, v21 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[120:123], v[116:119], a[88:91], v249, v21 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[120:123], v[104:107], a[76:79], v249, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[116:119], v[104:107], a[60:63], v249, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[116:119], v[108:111], a[64:67], v249, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[120:123], v[108:111], a[80:83], v249, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v101, s[0:3], s36 offen
		buffer_load_dwordx4 v[12:15], v102, s[0:3], s36 offen
		buffer_load_dwordx4 v[16:19], v103, s[0:3], s36 offen
		buffer_load_dwordx4 v[104:107], v120, s[0:3], s36 offen
		s_barrier
		ds_read_b128 v[108:111], v3 offset:32768
		ds_read_b128 v[112:115], v3 offset:33792
		ds_read_b128 v[116:119], v3 offset:34816
		ds_read_b128 v[224:227], v3 offset:35840
		ds_read_b128 v[228:231], v3 offset:36864
		ds_read_b128 v[232:235], v3 offset:37888
		ds_read_b128 v[236:239], v3 offset:38912
		ds_read_b128 a[92:95], v3 offset:39936
		ds_read_b128 a[96:99], v3 offset:40960
		ds_read_b128 a[100:103], v3 offset:41984
		ds_read_b128 a[104:107], v3 offset:43008
		ds_read_b128 a[108:111], v3 offset:44032
		ds_read_b128 a[112:115], v3 offset:45056
		ds_read_b128 a[116:119], v3 offset:46080
		ds_read_b128 a[120:123], v3 offset:47104
		ds_read_b128 v[240:243], v3 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[124:127], v[4:7], v[32:35], v26, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[124:127], v[12:15], v[96:99], v26, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[128:131], v[12:15], v[80:83], v26, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[128:131], v[4:7], v[84:87], v26, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[128:131], v[16:19], v[76:79], v26, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[124:127], v[16:19], v[92:95], v26, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[124:127], v[104:107], v[88:91], v26, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[128:131], v[104:107], v[72:75], v26, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[132:135], v[104:107], v[56:59], v27, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[132:135], v[16:19], v[60:63], v27, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[136:139], v[16:19], v[44:47], v27, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[136:139], v[104:107], v[40:43], v27, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[136:139], v[4:7], v[52:55], v27, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[132:135], v[4:7], v[68:71], v27, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[132:135], v[12:15], v[64:67], v27, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[136:139], v[12:15], v[48:51], v27, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[140:143], v[12:15], v[28:31], v244, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[140:143], v[4:7], v[36:39], v244, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[144:147], v[4:7], v[136:139], v244, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[144:147], v[12:15], v[140:143], v244, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[144:147], v[16:19], v[144:147], v244, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[140:143], v[16:19], v[128:131], v244, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[140:143], v[104:107], v[132:135], v244, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[144:147], v[104:107], v[148:151], v244, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[104:107], v[164:167], v245, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[16:19], v[160:163], v245, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[16:19], v[176:179], v245, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[104:107], v[180:183], v245, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[4:7], v[168:171], v245, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[148:151], v[4:7], v[152:155], v245, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[148:151], v[12:15], v[156:159], v245, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[12:15], v[172:175], v245, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[12:15], v[188:191], v246, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[4:7], v[184:187], v246, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[4:7], v[200:203], v246, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[12:15], v[204:207], v246, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[16:19], v[208:211], v246, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[16:19], v[192:195], v246, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[104:107], v[196:199], v246, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[104:107], v[212:215], v246, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[104:107], a[8:11], v247, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[16:19], a[4:7], v247, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[16:19], a[20:23], v247, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[104:107], a[24:27], v247, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[4:7], a[12:15], v247, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[4:7], v[216:219], v247, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[12:15], v[220:223], v247, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[12:15], a[16:19], v247, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[12:15], a[32:35], v248, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[4:7], a[28:31], v248, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[4:7], a[44:47], v248, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[12:15], a[48:51], v248, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[16:19], a[52:55], v248, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[16:19], a[36:39], v248, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[104:107], a[40:43], v248, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[104:107], a[56:59], v248, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], v[104:107], a[72:75], v249, v21 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[16:19], a[68:71], v249, v21 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[16:19], a[84:87], v249, v21 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[104:107], a[88:91], v249, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[4:7], a[76:79], v249, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[4:7], a[60:63], v249, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[12:15], a[64:67], v249, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[12:15], a[80:83], v249, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v121, s[0:3], s36 offen
		buffer_load_dwordx4 v[12:15], v122, s[0:3], s36 offen
		buffer_load_dwordx4 v[16:19], v123, s[0:3], s36 offen
		buffer_load_dwordx4 v[104:107], v124, s[0:3], s36 offen
		s_barrier
		ds_read2st64_b32 v[20:21], v8 offset0:8 offset1:9
		ds_read2st64_b32 v[26:27], v8 offset0:10 offset1:11
		ds_read2st64_b32 v[244:245], v8 offset0:12 offset1:13
		ds_read2st64_b32 v[246:247], v8 offset0:14 offset1:15
		ds_read2st64_b32 v[248:249], v9 offset0:18 offset1:19
		ds_read_b128 a[124:127], v3 offset:49152
		ds_read_b128 a[128:131], v3 offset:50176
		ds_read_b128 a[132:135], v3 offset:51200
		ds_read_b128 a[136:139], v3 offset:52224
		ds_read_b128 a[140:143], v3 offset:53248
		ds_read_b128 a[144:147], v3 offset:54272
		ds_read_b128 a[148:151], v3 offset:55296
		ds_read_b128 a[152:155], v3 offset:56320
		ds_read_b128 a[156:159], v3 offset:57344
		ds_read_b128 a[160:163], v3 offset:58368
		ds_read_b128 a[164:167], v3 offset:59392
		ds_read_b128 a[168:171], v3 offset:60416
		ds_read_b128 a[172:175], v3 offset:61440
		ds_read_b128 a[176:179], v3 offset:62464
		ds_read_b128 a[180:183], v3 offset:63488
		ds_read_b128 v[252:255], v3 offset:64512
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[108:111], v[4:7], v[32:35], v20, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[108:111], v[12:15], v[96:99], v20, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[112:115], v[12:15], v[80:83], v20, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[112:115], v[4:7], v[84:87], v20, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[112:115], v[16:19], v[76:79], v20, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[108:111], v[16:19], v[92:95], v20, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[108:111], v[104:107], v[88:91], v20, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[112:115], v[104:107], v[72:75], v20, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[116:119], v[104:107], v[56:59], v21, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[116:119], v[16:19], v[60:63], v21, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[224:227], v[16:19], v[44:47], v21, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[224:227], v[104:107], v[40:43], v21, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[224:227], v[4:7], v[52:55], v21, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[116:119], v[4:7], v[68:71], v21, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[116:119], v[12:15], v[64:67], v21, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[224:227], v[12:15], v[48:51], v21, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[228:231], v[12:15], v[28:31], v26, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[228:231], v[4:7], v[36:39], v26, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[4:7], v[136:139], v26, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[12:15], v[140:143], v26, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[16:19], v[144:147], v26, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[228:231], v[16:19], v[128:131], v26, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[228:231], v[104:107], v[132:135], v26, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[104:107], v[148:151], v26, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[104:107], v[164:167], v27, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[16:19], v[160:163], v27, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[92:95], v[16:19], v[176:179], v27, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[92:95], v[104:107], v[180:183], v27, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[92:95], v[4:7], v[168:171], v27, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[236:239], v[4:7], v[152:155], v27, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[12:15], v[156:159], v27, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[92:95], v[12:15], v[172:175], v27, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[96:99], v[12:15], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[96:99], v[4:7], v[184:187], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[100:103], v[4:7], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[100:103], v[12:15], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[100:103], v[16:19], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[96:99], v[16:19], v[192:195], v244, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[96:99], v[104:107], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[100:103], v[104:107], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[104:107], v[104:107], a[8:11], v245, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[104:107], v[16:19], a[4:7], v245, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[108:111], v[16:19], a[20:23], v245, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[108:111], v[104:107], a[24:27], v245, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[108:111], v[4:7], a[12:15], v245, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[104:107], v[4:7], v[216:219], v245, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[104:107], v[12:15], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[108:111], v[12:15], a[16:19], v245, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[112:115], v[12:15], a[32:35], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[108:111], v125, s[0:3], s36 offen
		buffer_load_dwordx4 v[112:115], v126, s[0:3], s36 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[112:115], v[4:7], a[28:31], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[116:119], v[4:7], a[44:47], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[116:119], v127, s[0:3], s36 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[116:119], v[12:15], a[48:51], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[224:227], v1, s[0:3], s36 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[116:119], v[16:19], a[52:55], v246, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[112:115], v[16:19], a[36:39], v246, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[112:115], v[104:107], a[40:43], v246, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[116:119], v[104:107], a[56:59], v246, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[120:123], v[104:107], a[72:75], v247, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[120:123], v[16:19], a[68:71], v247, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[240:243], v[16:19], a[84:87], v247, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[240:243], v[104:107], a[88:91], v247, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[240:243], v[4:7], a[76:79], v247, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[120:123], v[4:7], a[60:63], v247, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[120:123], v[12:15], a[64:67], v247, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[240:243], v[12:15], a[80:83], v247, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[124:127], v[108:111], v[32:35], v20, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[124:127], v[112:115], v[96:99], v20, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[128:131], v[112:115], v[80:83], v20, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[128:131], v[108:111], v[84:87], v20, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[128:131], v[116:119], v[76:79], v20, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[124:127], v[116:119], v[92:95], v20, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[124:127], v[224:227], v[88:91], v20, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[128:131], v[224:227], v[72:75], v20, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[132:135], v[224:227], v[56:59], v21, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[132:135], v[116:119], v[60:63], v21, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[136:139], v[116:119], v[44:47], v21, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[136:139], v[224:227], v[40:43], v21, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[136:139], v[108:111], v[52:55], v21, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[132:135], v[108:111], v[68:71], v21, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[132:135], v[112:115], v[64:67], v21, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[136:139], v[112:115], v[48:51], v21, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[140:143], v[112:115], v[28:31], v26, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[140:143], v[108:111], v[36:39], v26, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[144:147], v[108:111], v[136:139], v26, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[144:147], v[112:115], v[140:143], v26, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[144:147], v[116:119], v[144:147], v26, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[140:143], v[116:119], v[128:131], v26, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[140:143], v[224:227], v[132:135], v26, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[144:147], v[224:227], v[148:151], v26, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[148:151], v[224:227], v[164:167], v27, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[148:151], v[116:119], v[160:163], v27, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[152:155], v[116:119], v[176:179], v27, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[152:155], v[224:227], v[180:183], v27, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[152:155], v[108:111], v[168:171], v27, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[148:151], v[108:111], v[152:155], v27, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[148:151], v[112:115], v[156:159], v27, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[152:155], v[112:115], v[172:175], v27, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[156:159], v[112:115], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[156:159], v[108:111], v[184:187], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[160:163], v[108:111], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[160:163], v[112:115], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[160:163], v[116:119], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[156:159], v[116:119], v[192:195], v244, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[156:159], v[224:227], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[160:163], v[224:227], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[164:167], v[224:227], a[8:11], v245, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[164:167], v[116:119], a[4:7], v245, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[168:171], v[116:119], a[20:23], v245, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[168:171], v[224:227], a[24:27], v245, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[168:171], v[108:111], a[12:15], v245, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[164:167], v[108:111], v[216:219], v245, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[164:167], v[112:115], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[168:171], v[112:115], a[16:19], v245, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[172:175], v[112:115], a[32:35], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[172:175], v[108:111], a[28:31], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[176:179], v[108:111], a[44:47], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[176:179], v[112:115], a[48:51], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[176:179], v[116:119], a[52:55], v246, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[172:175], v[116:119], a[36:39], v246, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[172:175], v[224:227], a[40:43], v246, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[176:179], v[224:227], a[56:59], v246, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[180:183], v[224:227], a[72:75], v247, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[180:183], v[116:119], a[68:71], v247, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[116:119], a[84:87], v247, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[224:227], a[88:91], v247, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[108:111], a[76:79], v247, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[180:183], v[108:111], a[60:63], v247, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[180:183], v[112:115], a[64:67], v247, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[112:115], a[80:83], v247, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v24, s[0:3], s15 offen
		buffer_load_dwordx4 v[12:15], v0, s[0:3], s15 offen
		buffer_load_dwordx4 v[16:19], v100, s[0:3], s15 offen
		buffer_load_dwordx4 v[24:27], v11, s[0:3], s15 offen
		s_barrier
		v_add_u32_e32 v0, 0x10000, v23
		v_accvgpr_read_b32 v3, a0
		v_lshl_add_u32 v0, v3, 4, v0
		ds_read_b128 v[20:23], v0
		ds_read_b128 v[104:107], v0 offset:1024
		ds_read_b128 v[108:111], v0 offset:2048
		ds_read_b128 v[112:115], v0 offset:3072
		ds_read_b128 v[116:119], v0 offset:4096
		ds_read_b128 v[224:227], v0 offset:5120
		ds_read_b128 v[228:231], v0 offset:6144
		ds_read_b128 v[232:235], v0 offset:7168
		ds_read_b128 v[236:239], v0 offset:8192
		ds_read_b128 v[240:243], v0 offset:9216
		ds_read_b128 a[0:3], v0 offset:10240
		ds_read_b128 a[92:95], v0 offset:11264
		ds_read_b128 a[96:99], v0 offset:12288
		ds_read_b128 a[100:103], v0 offset:13312
		ds_read_b128 a[104:107], v0 offset:14336
		ds_read_b128 a[108:111], v0 offset:15360
		ds_read_b32 v3, v8 offset:8192
		ds_read_b32 v10, v8 offset:8448
		ds_read_b32 v11, v8 offset:8704
		ds_read_b32 v100, v8 offset:8960
		ds_read_b32 v244, v8 offset:9216
		ds_read_b32 v245, v8 offset:9472
		ds_read_b32 v246, v8 offset:9728
		ds_read_b32 v247, v8 offset:9984
		ds_read_b32 v248, v9 offset:12288
		ds_read_b32 v249, v9 offset:12544
		ds_read_b128 a[112:115], v0 offset:16384
		ds_read_b128 a[116:119], v0 offset:17408
		ds_read_b128 a[120:123], v0 offset:18432
		ds_read_b128 a[124:127], v0 offset:19456
		ds_read_b128 a[128:131], v0 offset:20480
		ds_read_b128 a[132:135], v0 offset:21504
		ds_read_b128 a[136:139], v0 offset:22528
		ds_read_b128 a[140:143], v0 offset:23552
		ds_read_b128 a[144:147], v0 offset:24576
		ds_read_b128 a[148:151], v0 offset:25600
		ds_read_b128 a[152:155], v0 offset:26624
		ds_read_b128 a[156:159], v0 offset:27648
		ds_read_b128 a[160:163], v0 offset:28672
		ds_read_b128 a[164:167], v0 offset:29696
		ds_read_b128 a[168:171], v0 offset:30720
		ds_read_b128 v[252:255], v0 offset:31744
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[20:23], v[4:7], v[32:35], v3, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[12:15], v[96:99], v3, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[104:107], v[12:15], v[80:83], v3, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[104:107], v[4:7], v[84:87], v3, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[104:107], v[16:19], v[76:79], v3, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], v[16:19], v[92:95], v3, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[24:27], v[88:91], v3, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[104:107], v[24:27], v[72:75], v3, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[108:111], v[24:27], v[56:59], v10, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[108:111], v[16:19], v[60:63], v10, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[112:115], v[16:19], v[44:47], v10, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[112:115], v[24:27], v[40:43], v10, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[112:115], v[4:7], v[52:55], v10, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[108:111], v[4:7], v[68:71], v10, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[108:111], v[12:15], v[64:67], v10, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[112:115], v[12:15], v[48:51], v10, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[116:119], v[12:15], v[28:31], v11, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[116:119], v[4:7], v[36:39], v11, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[4:7], v[136:139], v11, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[12:15], v[140:143], v11, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[16:19], v[144:147], v11, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[116:119], v[16:19], v[128:131], v11, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[116:119], v[24:27], v[132:135], v11, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[24:27], v[148:151], v11, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[24:27], v[164:167], v100, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[16:19], v[160:163], v100, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[232:235], v[16:19], v[176:179], v100, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[24:27], v[180:183], v100, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[232:235], v[4:7], v[168:171], v100, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[228:231], v[4:7], v[152:155], v100, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[12:15], v[156:159], v100, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[232:235], v[12:15], v[172:175], v100, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[236:239], v[12:15], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[236:239], v[4:7], v[184:187], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[240:243], v[4:7], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[240:243], v[12:15], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[240:243], v[16:19], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[236:239], v[16:19], v[192:195], v244, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[236:239], v[24:27], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[240:243], v[24:27], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[0:3], v[24:27], a[8:11], v245, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[0:3], v[16:19], a[4:7], v245, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[92:95], v[16:19], a[20:23], v245, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[92:95], v[24:27], a[24:27], v245, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[92:95], v[4:7], a[12:15], v245, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[0:3], v[4:7], v[216:219], v245, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[0:3], v[12:15], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[92:95], v[12:15], a[16:19], v245, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[96:99], v[12:15], a[32:35], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[96:99], v[4:7], a[28:31], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[100:103], v[4:7], a[44:47], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[100:103], v[12:15], a[48:51], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[100:103], v[16:19], a[52:55], v246, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[96:99], v[16:19], a[36:39], v246, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[96:99], v[24:27], a[40:43], v246, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[100:103], v[24:27], a[56:59], v246, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[104:107], v[24:27], a[72:75], v247, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[104:107], v[16:19], a[68:71], v247, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[108:111], v[16:19], a[84:87], v247, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[108:111], v[24:27], a[88:91], v247, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[108:111], v[4:7], a[76:79], v247, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[104:107], v[4:7], a[60:63], v247, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[104:107], v[12:15], a[64:67], v247, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[108:111], v[12:15], a[80:83], v247, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v101, s[0:3], s15 offen
		buffer_load_dwordx4 v[12:15], v102, s[0:3], s15 offen
		buffer_load_dwordx4 v[16:19], v103, s[0:3], s15 offen
		buffer_load_dwordx4 v[20:23], v120, s[0:3], s15 offen
		s_barrier
		ds_read_b128 v[24:27], v0 offset:32768
		ds_read_b128 v[104:107], v0 offset:33792
		ds_read_b128 v[108:111], v0 offset:34816
		ds_read_b128 v[112:115], v0 offset:35840
		ds_read_b128 v[116:119], v0 offset:36864
		ds_read_b128 v[224:227], v0 offset:37888
		ds_read_b128 v[228:231], v0 offset:38912
		ds_read_b128 v[232:235], v0 offset:39936
		ds_read_b128 v[236:239], v0 offset:40960
		ds_read_b128 a[0:3], v0 offset:41984
		ds_read_b128 a[92:95], v0 offset:43008
		ds_read_b128 a[96:99], v0 offset:44032
		ds_read_b128 a[100:103], v0 offset:45056
		ds_read_b128 a[104:107], v0 offset:46080
		ds_read_b128 a[108:111], v0 offset:47104
		ds_read_b128 v[240:243], v0 offset:48128
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], a[112:115], v[4:7], v[32:35], v3, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[112:115], v[12:15], v[96:99], v3, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[116:119], v[12:15], v[80:83], v3, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[116:119], v[4:7], v[84:87], v3, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[116:119], v[16:19], v[76:79], v3, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[112:115], v[16:19], v[92:95], v3, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[112:115], v[20:23], v[88:91], v3, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[116:119], v[20:23], v[72:75], v3, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[120:123], v[20:23], v[56:59], v10, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[120:123], v[16:19], v[60:63], v10, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[124:127], v[16:19], v[44:47], v10, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[124:127], v[20:23], v[40:43], v10, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[124:127], v[4:7], v[52:55], v10, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[120:123], v[4:7], v[68:71], v10, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[120:123], v[12:15], v[64:67], v10, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[124:127], v[12:15], v[48:51], v10, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[128:131], v[12:15], v[28:31], v11, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[128:131], v[4:7], v[36:39], v11, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[132:135], v[4:7], v[136:139], v11, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[132:135], v[12:15], v[140:143], v11, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[132:135], v[16:19], v[144:147], v11, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[128:131], v[16:19], v[128:131], v11, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[128:131], v[20:23], v[132:135], v11, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[132:135], v[20:23], v[148:151], v11, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[136:139], v[20:23], v[164:167], v100, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[136:139], v[16:19], v[160:163], v100, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[140:143], v[16:19], v[176:179], v100, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[140:143], v[20:23], v[180:183], v100, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[140:143], v[4:7], v[168:171], v100, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[136:139], v[4:7], v[152:155], v100, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[136:139], v[12:15], v[156:159], v100, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[140:143], v[12:15], v[172:175], v100, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[144:147], v[12:15], v[188:191], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[144:147], v[4:7], v[184:187], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[148:151], v[4:7], v[200:203], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[148:151], v[12:15], v[204:207], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[148:151], v[16:19], v[208:211], v244, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[144:147], v[16:19], v[192:195], v244, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[144:147], v[20:23], v[196:199], v244, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[148:151], v[20:23], v[212:215], v244, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[152:155], v[20:23], a[8:11], v245, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[152:155], v[16:19], a[4:7], v245, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[156:159], v[16:19], a[20:23], v245, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[156:159], v[20:23], a[24:27], v245, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[156:159], v[4:7], a[12:15], v245, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[152:155], v[4:7], v[216:219], v245, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[152:155], v[12:15], v[220:223], v245, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[156:159], v[12:15], a[16:19], v245, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[160:163], v[12:15], a[32:35], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[160:163], v[4:7], a[28:31], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[164:167], v[4:7], a[44:47], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[164:167], v[12:15], a[48:51], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[164:167], v[16:19], a[52:55], v246, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[160:163], v[16:19], a[36:39], v246, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[160:163], v[20:23], a[40:43], v246, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[164:167], v[20:23], a[56:59], v246, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[168:171], v[20:23], a[72:75], v247, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[168:171], v[16:19], a[68:71], v247, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[16:19], a[84:87], v247, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[20:23], a[88:91], v247, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[4:7], a[76:79], v247, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[168:171], v[4:7], a[60:63], v247, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[168:171], v[12:15], a[64:67], v247, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[12:15], a[80:83], v247, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[4:7], v121, s[0:3], s15 offen
		buffer_load_dwordx4 v[12:15], v122, s[0:3], s15 offen
		buffer_load_dwordx4 v[16:19], v123, s[0:3], s15 offen
		buffer_load_dwordx4 v[20:23], v124, s[0:3], s15 offen
		s_barrier
		ds_read_b32 v3, v8 offset:10240
		ds_read_b32 v10, v8 offset:10496
		ds_read_b32 v11, v8 offset:10752
		ds_read_b32 v100, v8 offset:11008
		ds_read_b32 v101, v8 offset:11264
		ds_read_b32 v102, v8 offset:11520
		ds_read_b32 v103, v8 offset:11776
		ds_read_b32 v120, v8 offset:12032
		ds_read_b32 v8, v9 offset:12800
		ds_read_b32 v121, v9 offset:13056
		ds_read_b128 v[244:247], v0 offset:49152
		ds_read_b128 v[248:251], v0 offset:50176
		ds_read_b128 a[112:115], v0 offset:51200
		ds_read_b128 a[116:119], v0 offset:52224
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
		s_waitcnt vmcnt(3) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[24:27], v[4:7], v[32:35], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[24:27], v[12:15], v[96:99], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[104:107], v[12:15], v[80:83], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[104:107], v[4:7], v[84:87], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[104:107], v[16:19], v[76:79], v3, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[24:27], v[16:19], v[92:95], v3, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[24:27], v[20:23], v[88:91], v3, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[104:107], v[20:23], v[72:75], v3, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[108:111], v[20:23], v[56:59], v10, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[108:111], v[16:19], v[60:63], v10, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[112:115], v[16:19], v[44:47], v10, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[112:115], v[20:23], v[40:43], v10, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[112:115], v[4:7], v[52:55], v10, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[108:111], v[4:7], v[68:71], v10, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[108:111], v[12:15], v[64:67], v10, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[112:115], v[12:15], v[48:51], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[116:119], v[12:15], v[28:31], v11, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[116:119], v[4:7], v[36:39], v11, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[4:7], v[136:139], v11, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[12:15], v[140:143], v11, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[16:19], v[144:147], v11, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[116:119], v[16:19], v[128:131], v11, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[116:119], v[20:23], v[132:135], v11, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[20:23], v[148:151], v11, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[20:23], v[164:167], v100, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[16:19], v[160:163], v100, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[232:235], v[16:19], v[176:179], v100, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[20:23], v[180:183], v100, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[232:235], v[4:7], v[168:171], v100, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[228:231], v[4:7], v[152:155], v100, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[12:15], v[156:159], v100, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[232:235], v[12:15], v[172:175], v100, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[236:239], v[12:15], v[188:191], v101, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[236:239], v[4:7], v[184:187], v101, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[0:3], v[4:7], v[200:203], v101, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[0:3], v[12:15], v[204:207], v101, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[0:3], v[16:19], v[208:211], v101, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[236:239], v[16:19], v[192:195], v101, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[236:239], v[20:23], v[196:199], v101, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[0:3], v[20:23], v[212:215], v101, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[92:95], v[20:23], a[8:11], v102, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[92:95], v[16:19], a[4:7], v102, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[96:99], v[16:19], a[20:23], v102, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[96:99], v[20:23], a[24:27], v102, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[96:99], v[4:7], a[12:15], v102, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[92:95], v[4:7], v[216:219], v102, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[92:95], v[12:15], v[220:223], v102, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[96:99], v[12:15], a[16:19], v102, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[100:103], v[12:15], a[32:35], v103, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[24:27], v125, s[0:3], s15 offen
		buffer_load_dwordx4 v[104:107], v126, s[0:3], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[100:103], v[4:7], a[28:31], v103, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[104:107], v[4:7], a[44:47], v103, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[108:111], v127, s[0:3], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[104:107], v[12:15], a[48:51], v103, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v[112:115], v1, s[0:3], s15 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[104:107], v[16:19], a[52:55], v103, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[100:103], v[16:19], a[36:39], v103, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[100:103], v[20:23], a[40:43], v103, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[104:107], v[20:23], a[56:59], v103, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[108:111], v[20:23], a[72:75], v120, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[108:111], v[16:19], a[68:71], v120, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[240:243], v[16:19], a[84:87], v120, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[240:243], v[20:23], a[88:91], v120, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[240:243], v[4:7], a[76:79], v120, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[108:111], v[4:7], a[60:63], v120, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[108:111], v[12:15], a[64:67], v120, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[240:243], v[12:15], a[80:83], v120, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt vmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[32:35], v[244:247], v[24:27], v[32:35], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[244:247], v[104:107], v[96:99], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[248:251], v[104:107], v[80:83], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[248:251], v[24:27], v[84:87], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[248:251], v[108:111], v[76:79], v3, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[244:247], v[108:111], v[92:95], v3, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[244:247], v[112:115], v[88:91], v3, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[248:251], v[112:115], v[72:75], v3, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(13)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[112:115], v[112:115], v[56:59], v10, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v32, v33
		v_cvt_pk_f16_f32 v1, v34, v35
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[112:115], v[108:111], v[60:63], v10, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[116:119], v[108:111], v[44:47], v10, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[116:119], v[112:115], v[40:43], v10, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[116:119], v[24:27], v[52:55], v10, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[112:115], v[24:27], v[68:71], v10, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[112:115], v[104:107], v[64:67], v10, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[116:119], v[104:107], v[48:51], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(11)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], a[120:123], v[104:107], v[28:31], v11, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], a[120:123], v[24:27], v[36:39], v11, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(10)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[124:127], v[24:27], v[136:139], v11, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[124:127], v[104:107], v[140:143], v11, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[124:127], v[108:111], v[144:147], v11, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[120:123], v[108:111], v[128:131], v11, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[120:123], v[112:115], v[132:135], v11, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[124:127], v[112:115], v[148:151], v11, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[128:131], v[112:115], v[164:167], v100, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[128:131], v[108:111], v[160:163], v100, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[132:135], v[108:111], v[176:179], v100, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[132:135], v[112:115], v[180:183], v100, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[132:135], v[24:27], v[168:171], v100, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[128:131], v[24:27], v[152:155], v100, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[128:131], v[104:107], v[156:159], v100, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[132:135], v[104:107], v[172:175], v100, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[136:139], v[104:107], v[188:191], v101, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[136:139], v[24:27], v[184:187], v101, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[140:143], v[24:27], v[200:203], v101, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[140:143], v[104:107], v[204:207], v101, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[140:143], v[108:111], v[208:211], v101, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[136:139], v[108:111], v[192:195], v101, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[136:139], v[112:115], v[196:199], v101, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[140:143], v[112:115], v[212:215], v101, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], a[144:147], v[112:115], a[8:11], v102, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], a[144:147], v[108:111], a[4:7], v102, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[148:151], v[108:111], a[20:23], v102, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[148:151], v[112:115], a[24:27], v102, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], a[148:151], v[24:27], a[12:15], v102, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[144:147], v[24:27], v[216:219], v102, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[144:147], v[104:107], v[220:223], v102, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[148:151], v[104:107], a[16:19], v102, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[152:155], v[104:107], a[32:35], v103, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[152:155], v[24:27], a[28:31], v103, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[156:159], v[24:27], a[44:47], v103, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[156:159], v[104:107], a[48:51], v103, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[156:159], v[108:111], a[52:55], v103, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[152:155], v[108:111], a[36:39], v103, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[152:155], v[112:115], a[40:43], v103, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[156:159], v[112:115], a[56:59], v103, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[160:163], v[112:115], a[72:75], v120, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[160:163], v[108:111], a[68:71], v120, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[252:255], v[108:111], a[84:87], v120, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[252:255], v[112:115], a[88:91], v120, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[252:255], v[24:27], a[76:79], v120, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[160:163], v[24:27], a[60:63], v120, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[160:163], v[104:107], a[64:67], v120, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[252:255], v[104:107], a[80:83], v120, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s35, s19
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v2, s[32:35], 0 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v64, v65
		v_cvt_pk_f16_f32 v1, v66, v67
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v60, v61
		v_cvt_pk_f16_f32 v1, v62, v63
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v56, v57
		v_cvt_pk_f16_f32 v1, v58, v59
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v52, v53
		v_cvt_pk_f16_f32 v1, v54, v55
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v48, v49
		v_cvt_pk_f16_f32 v1, v50, v51
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v44, v45
		v_cvt_pk_f16_f32 v1, v46, v47
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v40, v41
		v_cvt_pk_f16_f32 v1, v42, v43
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s31 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v36, v37
		v_cvt_pk_f16_f32 v1, v38, v39
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v28, v29
		v_cvt_pk_f16_f32 v1, v30, v31
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s30 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s7 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:512 sc0 nt
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:1024 sc0 nt
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:1536 sc0 nt
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:2048 sc0 nt
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:2560 sc0 nt
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:3072 sc0 nt
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s6 offen offset:3584 sc0 nt
		v_cvt_pk_f16_f32 v0, v216, v217
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s29 offen sc0 nt
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		buffer_store_dwordx2 v[0:1], v2, s[32:35], s29 offen offset:512 sc0 nt
		v_accvgpr_read_b32 v0, a4
		v_accvgpr_read_b32 v1, a5
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a6
		v_accvgpr_read_b32 v1, a7
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a8
		v_accvgpr_read_b32 v1, a9
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a10
		v_accvgpr_read_b32 v1, a11
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a12
		v_accvgpr_read_b32 v1, a13
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a14
		v_accvgpr_read_b32 v1, a15
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a16
		v_accvgpr_read_b32 v1, a17
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a18
		v_accvgpr_read_b32 v1, a19
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a20
		v_accvgpr_read_b32 v1, a21
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a22
		v_accvgpr_read_b32 v1, a23
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a24
		v_accvgpr_read_b32 v1, a25
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a26
		v_accvgpr_read_b32 v1, a27
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s29 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a28
		v_accvgpr_read_b32 v1, a29
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a30
		v_accvgpr_read_b32 v1, a31
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen sc0 nt
		v_accvgpr_read_b32 v0, a32
		v_accvgpr_read_b32 v1, a33
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a34
		v_accvgpr_read_b32 v1, a35
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:512 sc0 nt
		v_accvgpr_read_b32 v0, a36
		v_accvgpr_read_b32 v1, a37
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a38
		v_accvgpr_read_b32 v1, a39
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a40
		v_accvgpr_read_b32 v1, a41
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a42
		v_accvgpr_read_b32 v1, a43
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a44
		v_accvgpr_read_b32 v1, a45
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a46
		v_accvgpr_read_b32 v1, a47
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a48
		v_accvgpr_read_b32 v1, a49
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a50
		v_accvgpr_read_b32 v1, a51
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a52
		v_accvgpr_read_b32 v1, a53
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a54
		v_accvgpr_read_b32 v1, a55
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a56
		v_accvgpr_read_b32 v1, a57
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a58
		v_accvgpr_read_b32 v1, a59
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s36 offen offset:3584 sc0 nt
		v_accvgpr_read_b32 v0, a60
		v_accvgpr_read_b32 v1, a61
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a62
		v_accvgpr_read_b32 v1, a63
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen sc0 nt
		v_accvgpr_read_b32 v0, a64
		v_accvgpr_read_b32 v1, a65
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a66
		v_accvgpr_read_b32 v1, a67
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:512 sc0 nt
		v_accvgpr_read_b32 v0, a68
		v_accvgpr_read_b32 v1, a69
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a70
		v_accvgpr_read_b32 v1, a71
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:1024 sc0 nt
		v_accvgpr_read_b32 v0, a72
		v_accvgpr_read_b32 v1, a73
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a74
		v_accvgpr_read_b32 v1, a75
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:1536 sc0 nt
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v1, a77
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v1, a79
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:2048 sc0 nt
		v_accvgpr_read_b32 v0, a80
		v_accvgpr_read_b32 v1, a81
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a82
		v_accvgpr_read_b32 v1, a83
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:2560 sc0 nt
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v1, a85
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v1, a87
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:3072 sc0 nt
		v_accvgpr_read_b32 v0, a88
		v_accvgpr_read_b32 v1, a89
		v_cvt_pk_f16_f32 v4, v0, v1
		v_accvgpr_read_b32 v0, a90
		v_accvgpr_read_b32 v1, a91
		v_cvt_pk_f16_f32 v5, v0, v1
		buffer_store_dwordx2 v[4:5], v2, s[32:35], s15 offen offset:3584 sc0 nt
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
		.amdhsa_next_free_sgpr 43
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 43
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
    .sgpr_count:     43
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     476
    .agpr_count:     220
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 173
    wave.regalloc.agpr.dwords: 685
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
