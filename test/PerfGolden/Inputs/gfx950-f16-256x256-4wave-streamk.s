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
		s_lshr_b32 s1, s0, 6
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s6, s6, 6
		s_mul_i32 s6, 0x410, s6
		s_and_b32 s7, s1, 1
		s_mul_i32 s12, 0x4100, s7
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 4, v1
		v_lshlrev_b32_e32 v3, 4, v2
		v_and_b32_e32 v0, 15, v0
		v_mov_b32_e32 v4, 0x410
		v_mul_lo_u32 v4, v4, v0
		s_lshr_b32 s14, s1, 1
		s_mul_i32 s15, 0x4100, s14
		s_mov_b32 m0, s6
		v_lshrrev_b32_e32 v0, 3, v1
		v_and_b32_e32 v5, 7, v1
		v_lshlrev_b32_e32 v5, 4, v5
		v_lshl_add_u32 v0, v0, 14, v5
		s_lshl_b32 s1, s1, 17
		s_and_b32 s24, s13, 31
		s_lshr_b32 s25, s24, 3
		s_lshl_b32 s25, s25, 22
		s_add_i32 s26, s1, s25
		s_and_b32 s24, s24, 7
		s_lshl_b32 s24, s24, 24
		s_add_i32 s26, s26, s24
		buffer_load_dwordx4 v0, s[16:19], s26 offen lds
		v_add3_u32 v5, s12, v3, v4
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s12, s1, 0x80000
		s_add_i32 s27, s12, s25
		s_add_i32 s27, s27, s24
		buffer_load_dwordx4 v0, s[16:19], s27 offen lds
		v_add3_u32 v6, s15, v3, v4
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s27, s1, 0x100000
		s_add_i32 s28, s27, s25
		s_add_i32 s28, s28, s24
		buffer_load_dwordx4 v0, s[16:19], s28 offen lds
		v_and_b32_e32 v1, 15, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s28, s1, 0x180000
		s_add_i32 s29, s28, s25
		s_add_i32 s29, s29, s24
		buffer_load_dwordx4 v0, s[16:19], s29 offen lds
		v_lshlrev_b32_e32 v1, 4, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s29, s1, 0x200000
		s_add_i32 s30, s29, s25
		s_add_i32 s30, s30, s24
		buffer_load_dwordx4 v0, s[16:19], s30 offen lds
		v_lshl_add_u32 v1, v2, 19, v1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s30, s1, 0x280000
		s_add_i32 s31, s30, s25
		s_add_i32 s31, s31, s24
		buffer_load_dwordx4 v0, s[16:19], s31 offen lds
		v_add_u32_e32 v2, s26, v0
		v_accvgpr_write_b32 a0, v2
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s26, s1, 0x300000
		s_add_i32 s31, s26, s25
		s_add_i32 s31, s31, s24
		buffer_load_dwordx4 v0, s[16:19], s31 offen lds
		v_mov_b32_e32 v2, v5
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s31, s1, 0x380000
		s_add_i32 s32, s31, s25
		s_add_i32 s32, s32, s24
		buffer_load_dwordx4 v0, s[16:19], s32 offen lds
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		s_add_i32 m0, m0, 0x9240
		s_lshr_b32 s32, s13, 5
		s_lshl_b32 s32, s32, 22
		s_add_i32 s33, s1, s32
		buffer_load_dwordx4 v0, s[20:23], s33 offen lds
		v_add_u32_e32 v7, s33, v0
		v_accvgpr_write_b32 a1, v7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s33, s12, s32
		buffer_load_dwordx4 v0, s[20:23], s33 offen lds
		v_mov_b32_e32 v7, v6
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s33, s27, s32
		buffer_load_dwordx4 v0, s[20:23], s33 offen lds
		v_add_u32_e32 v8, 0x10000, v6
		v_accvgpr_write_b32 a2, v8
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s33, s28, s32
		buffer_load_dwordx4 v0, s[20:23], s33 offen lds
		s_add_i32 s33, s1, 0x2280000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s34, s29, s32
		buffer_load_dwordx4 v0, s[20:23], s34 offen lds
		s_add_i32 s34, s1, 0x2200000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s30, s32
		buffer_load_dwordx4 v0, s[20:23], s35 offen lds
		s_add_i32 s35, s1, 0x2180000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s36, s26, s32
		buffer_load_dwordx4 v0, s[20:23], s36 offen lds
		s_add_i32 s36, s1, 0x2100000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s31, s32
		buffer_load_dwordx4 v0, s[20:23], s37 offen lds
		s_add_i32 s37, s1, 0x80
		s_add_i32 m0, m0, 0xffff0c40
		s_add_i32 s38, s37, s25
		s_add_i32 s38, s38, s24
		buffer_load_dwordx4 v0, s[16:19], s38 offen lds
		s_add_i32 s38, s1, 0x80080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s39, s38, s25
		s_add_i32 s39, s39, s24
		buffer_load_dwordx4 v0, s[16:19], s39 offen lds
		s_add_i32 s39, s1, 0x100080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s40, s39, s25
		s_add_i32 s40, s40, s24
		buffer_load_dwordx4 v0, s[16:19], s40 offen lds
		s_add_i32 s40, s1, 0x180080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s41, s40, s25
		s_add_i32 s41, s41, s24
		buffer_load_dwordx4 v0, s[16:19], s41 offen lds
		s_add_i32 s41, s1, 0x200080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s41, s25
		s_add_i32 s42, s42, s24
		buffer_load_dwordx4 v0, s[16:19], s42 offen lds
		s_add_i32 s42, s1, 0x280080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s43, s42, s25
		s_add_i32 s43, s43, s24
		buffer_load_dwordx4 v0, s[16:19], s43 offen lds
		s_add_i32 s43, s1, 0x300080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s43, s25
		s_add_i32 s44, s44, s24
		buffer_load_dwordx4 v0, s[16:19], s44 offen lds
		s_add_i32 s44, s1, 0x380080
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s44, s25
		s_add_i32 s24, s25, s24
		buffer_load_dwordx4 v0, s[16:19], s24 offen lds
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s24, s37, s32
		buffer_load_dwordx4 v0, s[20:23], s24 offen lds
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s24, s38, s32
		buffer_load_dwordx4 v0, s[20:23], s24 offen lds
		s_add_i32 s24, s1, 0x2080000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s25, s39, s32
		buffer_load_dwordx4 v0, s[20:23], s25 offen lds
		s_add_i32 s25, s1, 0x2000000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s40, s32
		buffer_load_dwordx4 v0, s[20:23], s45 offen lds
		s_add_i32 s15, s15, 0x10000
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s45, s41, s32
		buffer_load_dwordx4 v0, s[20:23], s45 offen lds
		s_mov_b32 s45, 1
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s42, s42, s32
		buffer_load_dwordx4 v0, s[20:23], s42 offen lds
		s_mov_b32 s42, s13
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s46, s43, s32
		buffer_load_dwordx4 v0, s[20:23], s46 offen lds
		s_mov_b32 s46, 0
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s32, s44, s32
		buffer_load_dwordx4 v0, s[20:23], s32 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[8:11], v5
		ds_read_b128 a[12:15], v5 offset:128
		ds_read_b128 a[16:19], v5 offset:256
		ds_read_b128 a[20:23], v5 offset:384
		ds_read_b128 a[24:27], v5 offset:512
		ds_read_b128 a[28:31], v5 offset:640
		ds_read_b128 a[32:35], v5 offset:768
		ds_read_b128 a[36:39], v5 offset:896
		v_add3_u32 v3, s15, v3, v4
		ds_read_b128 a[40:43], v3 offset:1024
		ds_read_b128 a[44:47], v3 offset:1152
		ds_read_b128 a[48:51], v3 offset:1280
		ds_read_b128 a[52:55], v3 offset:1408
		ds_read_b128 a[56:59], v3 offset:1536
		ds_read_b128 a[60:63], v3 offset:1664
		ds_read_b128 a[64:67], v3 offset:1792
		ds_read_b128 a[68:71], v3 offset:1920
		s_mov_b32 s15, s46
		s_add_i32 s32, s1, 0x2300000
		s_add_i32 s47, s1, 0x2380000
		s_add_i32 s48, s1, 0x2000080
		s_add_i32 s49, s1, 0x2080080
		s_add_i32 s50, s1, 0x2100080
		s_add_i32 s51, s1, 0x2180080
		s_add_i32 s52, s1, 0x2200080
		s_lshl_b32 s14, s14, 21
		s_lshl_b32 s53, s7, 8
		s_add_i32 s54, s14, s53
		s_add_i32 s55, s14, 0x20000
		s_add_i32 s55, s55, s53
		s_add_i32 s56, s14, 0x40000
		s_add_i32 s56, s56, s53
		s_add_i32 s57, s14, 0x60000
		s_add_i32 s57, s57, s53
		s_add_i32 s58, s14, 0x4000
		s_add_i32 s58, s58, s53
		s_add_i32 s59, s14, 0x24000
		s_add_i32 s59, s59, s53
		s_add_i32 s60, s14, 0x44000
		s_add_i32 s60, s60, s53
		s_add_i32 s61, s14, 0x64000
		s_add_i32 s61, s61, s53
		s_add_i32 s62, s14, 0x8000
		s_add_i32 s62, s62, s53
		s_add_i32 s63, s14, 0x28000
		s_add_i32 s63, s63, s53
		s_add_i32 s64, s14, 0x48000
		s_add_i32 s64, s64, s53
		s_add_i32 s65, s14, 0x68000
		s_add_i32 s65, s65, s53
		s_add_i32 s66, s1, 0x2280080
		s_add_i32 s67, s1, 0x2300080
		s_add_i32 s68, s1, 0x2380080
		s_add_i32 s69, s14, 0xc000
		s_add_i32 s69, s69, s53
		s_add_i32 s70, s14, 0x2c000
		s_add_i32 s70, s70, s53
		s_add_i32 s71, s14, 0x4c000
		s_add_i32 s71, s71, s53
		s_add_i32 s72, s14, 0x6c000
		s_add_i32 s72, s72, s53
		s_add_i32 s73, s14, 0x10000
		s_add_i32 s73, s73, s53
		s_add_i32 s74, s14, 0x30000
		s_add_i32 s74, s74, s53
		s_add_i32 s75, s14, 0x50000
		s_add_i32 s75, s75, s53
		s_add_i32 s76, s14, 0x70000
		s_add_i32 s76, s76, s53
		s_add_i32 s77, s14, 0x14000
		s_add_i32 s77, s77, s53
		s_add_i32 s78, s14, 0x34000
		s_add_i32 s78, s78, s53
		s_add_i32 s79, s14, 0x54000
		s_add_i32 s79, s79, s53
		s_add_i32 s80, s14, 0x74000
		s_add_i32 s80, s80, s53
		s_add_i32 s81, s14, 0x18000
		s_add_i32 s81, s81, s53
		s_add_i32 s82, s14, 0x38000
		s_add_i32 s82, s82, s53
		s_add_i32 s83, s14, 0x58000
		s_add_i32 s83, s83, s53
		s_add_i32 s84, s14, 0x78000
		s_add_i32 s84, s84, s53
		s_add_i32 s85, s14, 0x1c000
		s_add_i32 s85, s85, s53
		s_add_i32 s86, s14, 0x3c000
		s_add_i32 s86, s86, s53
		s_add_i32 s87, s14, 0x5c000
		s_add_i32 s87, s87, s53
		s_add_i32 s14, s14, 0x7c000
		s_add_i32 s14, s14, s53
		s_cmp_eq_u32 s7, 0
		s_cbranch_scc0 .Lgfx950_f16_streamk_gemm.if_else_0
		s_mov_b32 s88, s16
		s_mov_b32 s89, s17
		s_mov_b32 s90, s18
		s_mov_b32 s91, s19
		s_mov_b32 s92, s20
		s_mov_b32 s93, s21
		s_mov_b32 s94, s22
		s_mov_b32 s95, s23
.Lgfx950_f16_streamk_gemm.loop_head_0:
		s_mov_b32 s7, s6
		s_and_b32 s34, s42, 31
		s_lshr_b32 s35, s34, 3
		s_lshl_b32 s35, s35, 22
		s_add_i32 s35, s1, s35
		s_and_b32 s34, s34, 7
		s_lshl_b32 s34, s34, 24
		s_add_i32 s35, s35, s34
		v_add_u32_e32 v3, s35, v0
		v_add_u32_e32 v4, 0x80, v3
		v_add_u32_e32 v8, 0x80080, v3
		v_add_u32_e32 v9, 0x100080, v3
		v_add_u32_e32 v10, 0x180080, v3
		v_add_u32_e32 v11, 0x200080, v3
		v_add_u32_e32 v12, 0x280080, v3
		v_add_u32_e32 v13, 0x300080, v3
		v_add_u32_e32 v3, 0x380080, v3
		s_lshr_b32 s36, s42, 5
		s_lshl_b32 s53, s36, 22
		s_add_i32 s53, s1, s53
		v_add_u32_e32 v14, s53, v0
		v_add_u32_e32 v15, 0x80, v14
		v_add_u32_e32 v16, 0x80080, v14
		v_add_u32_e32 v17, 0x100080, v14
		v_add_u32_e32 v18, 0x180080, v14
		v_add_u32_e32 v19, 0x200080, v14
		v_add_u32_e32 v20, 0x280080, v14
		v_add_u32_e32 v21, 0x300080, v14
		v_add_u32_e32 v14, 0x380080, v14
		s_mov_b32 s53, 0
		s_mov_b32 s88, s2
		s_mov_b32 s89, s3
		s_mov_b32 s92, s4
		s_mov_b32 s93, s5
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
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
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
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_1:
		s_add_i32 s53, s53, 1
		s_add_u32 s88, s88, 0x80
		s_addc_u32 s89, s89, 0
		s_add_u32 s92, s92, 0x80
		s_addc_u32 s93, s93, 0
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[8:11], v[24:27]
		v_add_u32_e32 v7, 0x10000, v7
		s_and_b32 s96, s53, 1
		s_mul_i32 s96, 0x8200, s96
		ds_read_b128 a[100:103], v2 offset:64
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[20:23], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[24:27], v[40:43]
		ds_read_b128 a[108:111], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[28:31], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[32:35], v[48:51]
		ds_read_b128 a[112:115], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[36:39], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[36:39], v[84:87]
		ds_read_b128 a[116:119], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[28:31], v[76:79]
		ds_read_b128 a[120:123], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[20:23], v[68:71]
		ds_read_b128 a[124:127], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[12:15], v[60:63]
		ds_read_b128 a[128:131], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[28:31], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[32:35], v[112:115]
		s_mov_b32 m0, s7
		s_add_i32 s7, s6, s96
		ds_read_b128 a[40:43], v7 offset:1088
		buffer_load_dwordx4 v4, s[88:91], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[36:39], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v7 offset:1216
		buffer_load_dwordx4 v8, s[88:91], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[28:31], v[140:143]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[24:27], v[136:139]
		buffer_load_dwordx4 v9, s[88:91], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[20:23], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[16:19], v[128:131]
		buffer_load_dwordx4 v10, s[88:91], 0 offen lds
		ds_read_b128 a[132:135], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[12:15], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[8:11], v[120:123]
		buffer_load_dwordx4 v11, s[88:91], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[8:11], v[152:155]
		ds_read_b128 a[52:55], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[20:23], v[164:167]
		ds_read_b128 a[136:139], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[28:31], v[172:175]
		ds_read_b128 a[140:143], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[56:59], a[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[60:63], a[36:39], v[212:215]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[28:31], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[32:35], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[64:67], a[36:39], v[244:247]
		v_mfma_f32_16x16x32_f16 a[96:99], a[68:71], a[36:39], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], a[68:71], a[32:35], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[28:31], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[16:19], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[12:15], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[8:11], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[100:103], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[104:107], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[108:111], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[112:115], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[116:119], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[120:123], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[124:127], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[128:131], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[128:131], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[124:127], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[120:123], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[116:119], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[116:119], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[120:123], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[124:127], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[128:131], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[132:135], a[128:131], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[132:135], a[124:127], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[132:135], a[120:123], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[132:135], a[116:119], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[132:135], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[132:135], a[108:111], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v12, s[88:91], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v13, s[88:91], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v3, s[88:91], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9240
		s_nop 0
		buffer_load_dwordx4 v15, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v16, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v17, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v18, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v19, s[92:95], 0 offen lds
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v20, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v21, s[92:95], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s96, 0xffffdf80, s15
		buffer_load_dwordx4 v14, s[92:95], 0 offen lds
		s_sub_i32 s15, s45, s15
		s_add_i32 s96, s96, 0x2080
		s_cmp_lt_i32 s53, 0x7e
		s_mul_i32 s96, s96, 4
		v_add_u32_e32 v7, s96, v6
		v_add_u32_e32 v2, s96, v5
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[132:135], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[132:135], a[100:103], v[120:123]
		v_add_u32_e32 v22, 0x10000, v7
		ds_read_b128 a[40:43], v22 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[112:115], v[164:167]
		ds_read_b128 a[44:47], v22 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[116:119], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[120:123], v[172:175]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[128:131], v[180:183]
		ds_read_b128 a[48:51], v22 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[136:139], a[128:131], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[136:139], a[124:127], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[136:139], a[120:123], v[204:207]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[136:139], a[116:119], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[136:139], a[112:115], v[196:199]
		ds_read_b128 a[52:55], v22 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[136:139], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[136:139], a[104:107], v[188:191]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[136:139], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[140:143], a[100:103], v[216:219]
		ds_read_b128 a[56:59], v22 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[140:143], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[140:143], a[108:111], v[224:227]
		ds_read_b128 a[28:31], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[140:143], a[112:115], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[140:143], a[116:119], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[140:143], a[120:123], v[236:239]
		ds_read_b128 a[60:63], v22 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[140:143], a[124:127], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[140:143], a[128:131], v[244:247]
		ds_read_b128 a[32:35], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[128:131], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[64:67], v22 offset:1792
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[36:39], v2 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		ds_read_b128 a[68:71], v22 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[104:107], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[100:103], a[72:75]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_1
.Lgfx950_f16_streamk_gemm.loop_exit_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[8:11], v[24:27]
		ds_read_b128 a[100:103], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[12:15], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[20:23], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[24:27], v[40:43]
		ds_read_b128 a[108:111], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[28:31], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[32:35], v[48:51]
		ds_read_b128 a[112:115], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[36:39], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[36:39], v[84:87]
		ds_read_b128 a[40:43], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[28:31], v[76:79]
		ds_read_b128 a[116:119], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[20:23], v[68:71]
		ds_read_b128 a[120:123], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[12:15], v[60:63]
		ds_read_b128 a[124:127], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[28:31], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v7
		s_mov_b32 m0, s7
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[32:35], v[112:115]
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		s_and_b32 s7, s42, 31
		s_lshr_b32 s7, s7, 3
		s_lshl_b32 s7, s7, 22
		s_add_i32 s35, s12, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		s_add_i32 s35, s27, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		s_add_i32 s35, s28, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		s_add_i32 s35, s29, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		ds_read_b128 v[8:11], v2 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[36:39], v[148:151]
		ds_read_b128 v[12:15], v2 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[28:31], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[24:27], v[136:139]
		ds_read_b128 v[16:19], v2 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[16:19], v[128:131]
		ds_read_b128 v[20:23], v2 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[8:11], v[152:155]
		ds_read_b128 a[44:47], v2 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[20:23], v[164:167]
		ds_read_b128 a[48:51], v2 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[28:31], v[172:175]
		ds_read_b128 a[52:55], v2 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[56:59], a[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[60:63], a[36:39], v[212:215]
		ds_read_b128 v[252:255], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[16:19], a[80:83]
		s_add_i32 s35, s30, s7
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[12:15], a[76:79]
		s_add_i32 s35, s35, s34
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[8:11], a[72:75]
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[24:27], v[232:235]
		s_add_i32 s35, s26, s7
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[24:27], a[84:87]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[28:31], v[236:239]
		s_add_i32 s35, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s35 offen lds
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[28:31], a[88:91]
		s_add_i32 s35, s31, s7
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[32:35], v[240:243]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[244:247], a[64:67], a[36:39], v[244:247]
		s_add_i32 s34, s35, s34
		buffer_load_dwordx4 v0, s[16:19], s34 offen lds
		v_mfma_f32_16x16x32_f16 a[96:99], a[68:71], a[36:39], a[96:99]
		s_lshl_b32 s34, s36, 22
		s_add_i32 s35, s59, s34
		v_mfma_f32_16x16x32_f16 a[92:95], a[68:71], a[32:35], a[92:95]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[100:103], v[24:27]
		s_add_i32 s53, s25, s34
		buffer_load_dwordx4 v0, s[20:23], s53 offen lds
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[104:107], v[28:31]
		s_add_i32 s34, s58, s34
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[108:111], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[112:115], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[40:43], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[116:119], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[120:123], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[124:127], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[124:127], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[120:123], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[120:123], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[124:127], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[124:127], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[120:123], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[108:111], v[128:131]
		s_and_b32 s53, s42, 31
		s_and_b32 s53, s53, 7
		s_lshl_b32 s53, s53, 11
		s_and_b32 s96, s42, 31
		s_lshr_b32 s96, s96, 3
		s_lshl_b32 s96, s96, 9
		s_add_i32 s34, s34, s96
		s_add_i32 s35, s35, s96
		s_lshl_b32 s36, s36, 22
		s_add_i32 s97, s24, s36
		buffer_load_dwordx4 v0, s[20:23], s97 offen lds
		s_add_i32 s97, s57, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s97, s97, s96
		s_lshr_b32 s98, s0, 6
		s_lshl_b32 s98, s98, 17
		s_add_i32 s98, s98, 0x2100000
		s_add_i32 s98, s98, s36
		buffer_load_dwordx4 v0, s[20:23], s98 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_and_b32 s98, s42, 31
		s_and_b32 s98, s98, 7
		s_lshl_b32 s98, s98, 24
		s_lshr_b32 s99, s0, 6
		s_lshl_b32 s99, s99, 17
		s_add_i32 s99, s99, 0x280080
		s_add_i32 s99, s99, s7
		s_add_i32 s99, s99, s98
		s_lshr_b32 s100, s0, 6
		s_lshl_b32 s100, s100, 17
		s_add_i32 s100, s100, 0x2180000
		s_add_i32 s100, s100, s36
		buffer_load_dwordx4 v0, s[20:23], s100 offen lds
		s_add_i32 s100, s37, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s100, s100, s98
		s_lshr_b32 s101, s0, 6
		s_lshl_b32 s101, s101, 17
		s_add_i32 s101, s101, 0x2200000
		s_add_i32 s101, s101, s36
		buffer_load_dwordx4 v0, s[20:23], s101 offen lds
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s101, s33, s36
		buffer_load_dwordx4 v0, s[20:23], s101 offen lds
		s_mul_i32 s101, 0xffffdf80, s15
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s101, s101, 0x2080
		s_lshl_b32 s101, s101, 2
		v_add_u32_e32 v2, s101, v5
		v_accvgpr_read_b32 v3, a2
		v_add_u32_e32 v3, s101, v3
		s_add_i32 s101, s32, s36
		buffer_load_dwordx4 v0, s[20:23], s101 offen lds
		s_sub_i32 s101, s45, s15
		s_sub_i32 s15, s45, s101
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s101, s47, s36
		buffer_load_dwordx4 v0, s[20:23], s101 offen lds
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[100:103], v[120:123]
		ds_read_b128 v[8:11], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[44:47], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[44:47], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[44:47], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[44:47], a[112:115], v[164:167]
		ds_read_b128 v[12:15], v3 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[44:47], a[40:43], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[44:47], a[116:119], v[172:175]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[44:47], a[120:123], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[44:47], a[124:127], v[180:183]
		ds_read_b128 v[16:19], v3 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[48:51], a[124:127], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[48:51], a[120:123], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[48:51], a[116:119], v[204:207]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[48:51], a[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[48:51], a[112:115], v[196:199]
		ds_read_b128 a[24:27], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[48:51], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[48:51], a[104:107], v[188:191]
		ds_read_b128 a[28:31], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[48:51], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[100:103], v[216:219]
		ds_read_b128 a[32:35], v3 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[52:55], a[108:111], v[224:227]
		ds_read_b128 a[36:39], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[52:55], a[112:115], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[52:55], a[40:43], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[52:55], a[116:119], v[236:239]
		ds_read_b128 a[44:47], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], a[120:123], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], a[124:127], v[244:247]
		ds_read_b128 a[48:51], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[120:123], a[92:95]
		ds_read_b128 a[52:55], v3 offset:1792
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[116:119], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[40:43], a[84:87]
		ds_read_b128 a[40:43], v2 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		ds_read_b128 v[20:23], v3 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[104:107], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[100:103], a[72:75]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[8:11], v[24:27]
		ds_read_b128 a[100:103], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[12:15], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[20:23], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[28:31], v[40:43]
		ds_read_b128 a[68:71], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[36:39], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[48:51], v[48:51]
		ds_read_b128 a[108:111], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[40:43], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[40:43], v[84:87]
		ds_read_b128 a[112:115], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[48:51], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[36:39], v[76:79]
		ds_read_b128 a[116:119], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[28:31], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[20:23], v[68:71]
		ds_read_b128 a[64:67], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[12:15], v[60:63]
		ds_read_b128 a[120:123], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[48:51], v[112:115]
		s_add_i32 m0, s6, 0x8200
		s_add_i32 s34, s34, s53
		buffer_load_dwordx4 v0, s[16:19], s100 offen lds
		s_add_i32 s100, s38, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s100, s100, s98
		buffer_load_dwordx4 v0, s[16:19], s100 offen lds
		s_add_i32 s100, s39, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s100, s100, s98
		buffer_load_dwordx4 v0, s[16:19], s100 offen lds
		s_add_i32 s100, s40, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s100, s100, s98
		buffer_load_dwordx4 v0, s[16:19], s100 offen lds
		s_add_i32 s100, s41, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s100, s100, s98
		buffer_load_dwordx4 v0, s[16:19], s100 offen lds
		ds_read_b128 v[8:11], v3 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[24:27], a[40:43], v[148:151]
		ds_read_b128 v[12:15], v3 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[24:27], a[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[24:27], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[24:27], a[28:31], v[136:139]
		ds_read_b128 a[56:59], v3 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[24:27], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[24:27], a[16:19], v[128:131]
		ds_read_b128 a[60:63], v3 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[24:27], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[24:27], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], a[8:11], v[152:155]
		ds_read_b128 a[24:27], v3 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], a[20:23], v[164:167]
		ds_read_b128 a[124:127], v3 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[36:39], v[172:175]
		ds_read_b128 a[128:131], v3 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[48:51], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[44:47], a[40:43], v[212:215]
		ds_read_b128 a[132:135], v3 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[44:47], a[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[44:47], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[44:47], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[44:47], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[44:47], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[44:47], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[44:47], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[52:55], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[52:55], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], v[20:23], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], v[20:23], a[16:19], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], v[20:23], a[12:15], a[76:79]
		buffer_load_dwordx4 v0, s[16:19], s99 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[52:55], a[28:31], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[52:55], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], a[48:51], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], a[40:43], v[244:247]
		v_mfma_f32_16x16x32_f16 a[96:99], v[20:23], a[40:43], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[20:23], a[48:51], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], v[20:23], a[36:39], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[20:23], a[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[72:75], v[20:23], a[8:11], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[100:103], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[104:107], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[68:71], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[108:111], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[112:115], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[116:119], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[64:67], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[120:123], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[64:67], v[80:83]
		v_cvt_pk_f16_f32 v8, v24, v28
		v_cvt_pk_f16_f32 v16, v25, v29
		v_cvt_pk_f16_f32 v9, v32, v36
		v_cvt_pk_f16_f32 v17, v33, v37
		v_cvt_pk_f16_f32 v10, v40, v44
		v_cvt_pk_f16_f32 v18, v41, v45
		v_cvt_pk_f16_f32 v11, v48, v52
		v_cvt_pk_f16_f32 v19, v49, v53
		v_cvt_pk_f16_f32 v20, v26, v30
		v_cvt_pk_f16_f32 v21, v34, v38
		v_cvt_pk_f16_f32 v22, v42, v46
		v_cvt_pk_f16_f32 v23, v50, v54
		v_cvt_pk_f16_f32 v252, v27, v31
		v_cvt_pk_f16_f32 v253, v35, v39
		v_cvt_pk_f16_f32 v254, v43, v47
		v_cvt_pk_f16_f32 v255, v51, v55
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[112:115], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[108:111], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[68:71], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[100:103], v[56:59]
		v_cvt_pk_f16_f32 v15, v80, v84
		v_cvt_pk_f16_f32 v27, v81, v85
		v_cvt_pk_f16_f32 v31, v82, v86
		v_cvt_pk_f16_f32 v35, v83, v87
		v_cvt_pk_f16_f32 v14, v72, v76
		v_cvt_pk_f16_f32 v26, v73, v77
		v_cvt_pk_f16_f32 v13, v64, v68
		v_cvt_pk_f16_f32 v25, v65, v69
		v_cvt_pk_f16_f32 v12, v56, v60
		v_cvt_pk_f16_f32 v24, v57, v61
		v_cvt_pk_f16_f32 v28, v58, v62
		v_cvt_pk_f16_f32 v29, v66, v70
		v_cvt_pk_f16_f32 v30, v74, v78
		v_cvt_pk_f16_f32 v32, v59, v63
		v_cvt_pk_f16_f32 v33, v67, v71
		v_cvt_pk_f16_f32 v34, v75, v79
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[68:71], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[108:111], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[112:115], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[120:123], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[64:67], v[144:147]
		v_cvt_pk_f16_f32 v36, v88, v92
		v_cvt_pk_f16_f32 v40, v89, v93
		v_cvt_pk_f16_f32 v37, v96, v100
		v_cvt_pk_f16_f32 v41, v97, v101
		v_cvt_pk_f16_f32 v38, v104, v108
		v_cvt_pk_f16_f32 v42, v105, v109
		v_cvt_pk_f16_f32 v39, v112, v116
		v_cvt_pk_f16_f32 v43, v113, v117
		v_cvt_pk_f16_f32 v44, v90, v94
		v_cvt_pk_f16_f32 v45, v98, v102
		v_cvt_pk_f16_f32 v46, v106, v110
		v_cvt_pk_f16_f32 v47, v114, v118
		v_cvt_pk_f16_f32 v48, v91, v95
		v_cvt_pk_f16_f32 v49, v99, v103
		v_cvt_pk_f16_f32 v50, v107, v111
		v_cvt_pk_f16_f32 v51, v115, v119
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[112:115], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[108:111], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[68:71], v[128:131]
		v_cvt_pk_f16_f32 v55, v144, v148
		v_cvt_pk_f16_f32 v59, v145, v149
		v_cvt_pk_f16_f32 v63, v146, v150
		v_cvt_pk_f16_f32 v67, v147, v151
		s_add_i32 s99, s43, s7
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v54, v136, v140
		v_cvt_pk_f16_f32 v58, v137, v141
		v_cvt_pk_f16_f32 v53, v128, v132
		v_cvt_pk_f16_f32 v57, v129, v133
		v_cvt_pk_f16_f32 v61, v130, v134
		v_cvt_pk_f16_f32 v62, v138, v142
		v_cvt_pk_f16_f32 v65, v131, v135
		v_cvt_pk_f16_f32 v66, v139, v143
		s_add_i32 s99, s99, s98
		buffer_load_dwordx4 v0, s[16:19], s99 offen lds
		s_add_i32 s7, s44, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s7, s98
		buffer_load_dwordx4 v0, s[16:19], s7 offen lds
		s_add_i32 s7, s56, s36
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		s_add_i32 s98, s48, s36
		buffer_load_dwordx4 v0, s[20:23], s98 offen lds
		s_add_i32 s98, s55, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s98, s98, s96
		s_add_i32 s98, s98, s53
		s_add_i32 s99, s49, s36
		buffer_load_dwordx4 v0, s[20:23], s99 offen lds
		s_add_i32 s35, s35, s53
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s99, s50, s36
		buffer_load_dwordx4 v0, s[20:23], s99 offen lds
		s_add_i32 s97, s97, s53
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s99, s51, s36
		buffer_load_dwordx4 v0, s[20:23], s99 offen lds
		s_add_i32 s99, s54, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s99, s99, s96
		s_add_i32 s99, s99, s53
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s99 offen sc0 nt
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s98 offen sc0 nt
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s7 offen sc0 nt
		buffer_store_dwordx4 v[252:255], v1, s[8:11], s97 offen sc0 nt
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s34 offen sc0 nt
		buffer_store_dwordx4 v[24:27], v1, s[8:11], s35 offen sc0 nt
		s_add_i32 s7, s52, s36
		buffer_load_dwordx4 v0, s[20:23], s7 offen lds
		s_add_i32 s7, s60, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[28:31], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s61, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[32:35], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s62, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[36:39], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s63, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[40:43], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s64, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[44:47], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s65, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[48:51], v1, s[8:11], s7 offen sc0 nt
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s7, s66, s36
		buffer_load_dwordx4 v0, s[20:23], s7 offen lds
		s_add_i32 s7, s69, s36
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s34, s67, s36
		buffer_load_dwordx4 v0, s[20:23], s34 offen lds
		s_mul_i32 s34, 0x2080, s15
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s35, s68, s36
		buffer_load_dwordx4 v0, s[20:23], s35 offen lds
		s_mul_i32 s34, s34, 4
		v_add_u32_e32 v2, s34, v5
		v_add_u32_e32 v7, s34, v6
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[100:103], v[120:123]
		v_add_u32_e32 v3, 0x10000, v7
		ds_read_b128 a[40:43], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[24:27], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[24:27], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[24:27], a[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[24:27], a[108:111], v[164:167]
		ds_read_b128 a[44:47], v3 offset:1152
		v_cvt_pk_f16_f32 v52, v120, v124
		v_cvt_pk_f16_f32 v56, v121, v125
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v60, v122, v126
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[52:55], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[168:171], a[24:27], a[112:115], v[168:171]
		s_add_i32 s7, s70, s36
		v_cvt_pk_f16_f32 v64, v123, v127
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v8, v152, v156
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[56:59], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[172:175], a[24:27], a[116:119], v[172:175]
		s_add_i32 s7, s71, s36
		v_cvt_pk_f16_f32 v9, v160, v164
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v12, v153, v157
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[60:63], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[16:19], v2 offset:256
		s_add_i32 s7, s72, s36
		v_cvt_pk_f16_f32 v10, v168, v172
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v13, v161, v165
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[64:67], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[176:179], a[24:27], a[64:67], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[24:27], a[120:123], v[180:183]
		v_cvt_pk_f16_f32 v14, v169, v173
		v_cvt_pk_f16_f32 v16, v154, v158
		v_cvt_pk_f16_f32 v17, v162, v166
		v_cvt_pk_f16_f32 v18, v170, v174
		v_cvt_pk_f16_f32 v20, v155, v159
		v_cvt_pk_f16_f32 v21, v163, v167
		v_cvt_pk_f16_f32 v22, v171, v175
		ds_read_b128 a[48:51], v3 offset:1280
		v_cvt_pk_f16_f32 v11, v176, v180
		v_cvt_pk_f16_f32 v15, v177, v181
		s_add_i32 s7, s73, s36
		v_cvt_pk_f16_f32 v19, v178, v182
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v23, v179, v183
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[212:215], a[124:127], a[120:123], v[212:215]
		s_add_i32 s7, s74, s36
		v_mfma_f32_16x16x32_f16 v[208:211], a[124:127], a[64:67], v[208:211]
		s_add_i32 s7, s7, s96
		v_mfma_f32_16x16x32_f16 v[204:207], a[124:127], a[116:119], v[204:207]
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[20:23], v2 offset:384
		s_add_i32 s7, s75, s36
		v_mfma_f32_16x16x32_f16 v[200:203], a[124:127], a[112:115], v[200:203]
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v11, v208, v212
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[196:199], a[124:127], a[108:111], v[196:199]
		s_add_i32 s7, s76, s36
		v_cvt_pk_f16_f32 v15, v209, v213
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v10, v200, v204
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[52:55], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[124:127], a[68:71], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[124:127], a[104:107], v[188:191]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[124:127], a[100:103], v[184:187]
		v_cvt_pk_f16_f32 v14, v201, v205
		v_cvt_pk_f16_f32 v18, v202, v206
		v_cvt_pk_f16_f32 v19, v210, v214
		v_cvt_pk_f16_f32 v22, v203, v207
		v_cvt_pk_f16_f32 v23, v211, v215
		v_cvt_pk_f16_f32 v9, v192, v196
		v_cvt_pk_f16_f32 v13, v193, v197
		v_cvt_pk_f16_f32 v17, v194, v198
		v_cvt_pk_f16_f32 v8, v184, v188
		v_cvt_pk_f16_f32 v12, v185, v189
		s_add_i32 s7, s77, s36
		v_cvt_pk_f16_f32 v16, v186, v190
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v20, v187, v191
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[216:219], a[128:131], a[100:103], v[216:219]
		s_add_i32 s7, s78, s36
		v_cvt_pk_f16_f32 v21, v195, v199
		s_add_i32 s7, s7, s96
		ds_read_b128 a[56:59], v3 offset:1536
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[220:223], a[128:131], a[104:107], v[220:223]
		s_add_i32 s7, s79, s36
		v_mfma_f32_16x16x32_f16 v[224:227], a[128:131], a[68:71], v[224:227]
		s_add_i32 s7, s7, s96
		ds_read_b128 a[28:31], v2 offset:640
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[228:231], a[128:131], a[108:111], v[228:231]
		s_add_i32 s7, s80, s36
		v_cvt_pk_f16_f32 v8, v216, v220
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v12, v217, v221
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s7 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[232:235], a[128:131], a[112:115], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[128:131], a[116:119], v[236:239]
		ds_read_b128 a[60:63], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[128:131], a[64:67], v[240:243]
		v_cvt_pk_f16_f32 v9, v224, v228
		v_mfma_f32_16x16x32_f16 v[244:247], a[128:131], a[120:123], v[244:247]
		v_cvt_pk_f16_f32 v13, v225, v229
		v_cvt_pk_f16_f32 v16, v218, v222
		v_cvt_pk_f16_f32 v17, v226, v230
		v_cvt_pk_f16_f32 v20, v219, v223
		v_cvt_pk_f16_f32 v10, v232, v236
		v_cvt_pk_f16_f32 v14, v233, v237
		v_cvt_pk_f16_f32 v18, v234, v238
		v_cvt_pk_f16_f32 v21, v227, v231
		v_cvt_pk_f16_f32 v11, v240, v244
		v_cvt_pk_f16_f32 v15, v241, v245
		s_add_i32 s7, s81, s36
		v_cvt_pk_f16_f32 v19, v242, v246
		s_add_i32 s7, s7, s96
		v_cvt_pk_f16_f32 v22, v235, v239
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[32:35], v2 offset:768
		s_add_i32 s7, s82, s36
		v_mfma_f32_16x16x32_f16 a[96:99], a[132:135], a[120:123], a[96:99]
		s_add_i32 s7, s7, s96
		v_mfma_f32_16x16x32_f16 a[92:95], a[132:135], a[64:67], a[92:95]
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[64:67], v3 offset:1792
		s_add_i32 s7, s83, s36
		v_mfma_f32_16x16x32_f16 a[88:91], a[132:135], a[116:119], a[88:91]
		s_add_i32 s7, s7, s96
		v_mfma_f32_16x16x32_f16 a[84:87], a[132:135], a[112:115], a[84:87]
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[36:39], v2 offset:896
		v_cvt_pk_f16_f32 v23, v243, v247
		v_mfma_f32_16x16x32_f16 v[248:251], a[132:135], a[108:111], v[248:251]
		s_add_i32 s7, s84, s36
		v_mfma_f32_16x16x32_f16 a[80:83], a[132:135], a[68:71], a[80:83]
		s_add_i32 s7, s7, s96
		v_accvgpr_read_b32 v4, a84
		v_accvgpr_read_b32 v8, a88
		v_cvt_pk_f16_f32 v14, v4, v8
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s7 offen sc0 nt
		ds_read_b128 a[68:71], v3 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], a[132:135], a[104:107], a[76:79]
		v_accvgpr_read_b32 v3, a92
		v_accvgpr_read_b32 v4, a96
		v_cvt_pk_f16_f32 v15, v3, v4
		v_mfma_f32_16x16x32_f16 a[72:75], a[132:135], a[100:103], a[72:75]
		v_accvgpr_read_b32 v3, a80
		v_cvt_pk_f16_f32 v13, v3, v248
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_f16_f32 v9, v3, v249
		v_accvgpr_read_b32 v3, a85
		v_accvgpr_read_b32 v4, a89
		v_cvt_pk_f16_f32 v10, v3, v4
		v_accvgpr_read_b32 v3, a93
		v_accvgpr_read_b32 v4, a97
		v_cvt_pk_f16_f32 v11, v3, v4
		v_accvgpr_read_b32 v3, a82
		v_cvt_pk_f16_f32 v17, v3, v250
		v_accvgpr_read_b32 v3, a86
		v_accvgpr_read_b32 v4, a90
		v_cvt_pk_f16_f32 v18, v3, v4
		v_accvgpr_read_b32 v3, a94
		v_accvgpr_read_b32 v4, a98
		v_cvt_pk_f16_f32 v19, v3, v4
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_f16_f32 v21, v3, v251
		v_accvgpr_read_b32 v3, a72
		v_accvgpr_read_b32 v4, a76
		v_cvt_pk_f16_f32 v12, v3, v4
		v_accvgpr_read_b32 v3, a73
		v_accvgpr_read_b32 v4, a77
		v_cvt_pk_f16_f32 v8, v3, v4
		s_add_i32 s7, s85, s36
		v_accvgpr_read_b32 v3, a74
		v_accvgpr_read_b32 v4, a78
		v_cvt_pk_f16_f32 v16, v3, v4
		s_add_i32 s7, s7, s96
		v_accvgpr_read_b32 v3, a75
		v_accvgpr_read_b32 v4, a79
		v_cvt_pk_f16_f32 v20, v3, v4
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s86, s36
		v_accvgpr_read_b32 v3, a87
		v_accvgpr_read_b32 v4, a91
		v_cvt_pk_f16_f32 v22, v3, v4
		s_add_i32 s7, s7, s96
		v_accvgpr_read_b32 v3, a95
		v_accvgpr_read_b32 v4, a99
		v_cvt_pk_f16_f32 v23, v3, v4
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s87, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s14, s36
		s_add_i32 s7, s7, s96
		s_add_i32 s7, s7, s53
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s7 offen sc0 nt
		s_add_i32 s7, s42, 0x100
		s_cmp_lt_i32 s7, 0x300
		s_mov_b32 s42, s7
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_0
.Lgfx950_f16_streamk_gemm.loop_exit_0:
		s_branch .Lgfx950_f16_streamk_gemm.if_end_0
.Lgfx950_f16_streamk_gemm.if_else_0:
		s_mov_b32 s24, s16
		s_mov_b32 s25, s17
		s_mov_b32 s26, s18
		s_mov_b32 s27, s19
		s_mov_b32 s28, s20
		s_mov_b32 s29, s21
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
.Lgfx950_f16_streamk_gemm.loop_head_2:
		s_mov_b32 s1, s6
		s_and_b32 s7, s42, 31
		s_lshr_b32 s12, s7, 3
		s_lshl_b32 s37, s12, 22
		s_lshr_b32 s53, s0, 6
		s_lshl_b32 s53, s53, 17
		s_add_i32 s88, s53, s37
		s_and_b32 s7, s7, 7
		s_lshl_b32 s89, s7, 24
		s_add_i32 s88, s88, s89
		v_add_u32_e32 v3, s88, v0
		v_add_u32_e32 v4, 0x80, v3
		v_add_u32_e32 v8, 0x80080, v3
		v_add_u32_e32 v9, 0x100080, v3
		v_add_u32_e32 v10, 0x180080, v3
		v_add_u32_e32 v11, 0x200080, v3
		v_add_u32_e32 v12, 0x280080, v3
		v_add_u32_e32 v13, 0x300080, v3
		v_add_u32_e32 v3, 0x380080, v3
		s_lshr_b32 s90, s42, 5
		s_lshl_b32 s90, s90, 22
		s_add_i32 s53, s53, s90
		v_add_u32_e32 v14, s53, v0
		v_add_u32_e32 v15, 0x80, v14
		v_add_u32_e32 v16, 0x80080, v14
		v_add_u32_e32 v17, 0x100080, v14
		v_add_u32_e32 v18, 0x180080, v14
		v_add_u32_e32 v19, 0x200080, v14
		v_add_u32_e32 v20, 0x280080, v14
		v_add_u32_e32 v21, 0x300080, v14
		v_add_u32_e32 v14, 0x380080, v14
		s_mov_b32 s53, 0
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
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
	.p2align	5
		s_nop 0
		s_nop 0
		s_nop 0
.Lgfx950_f16_streamk_gemm.loop_head_3:
		s_add_i32 s53, s53, 1
		s_add_u32 s24, s24, 0x80
		s_addc_u32 s25, s25, 0
		s_add_u32 s28, s28, 0x80
		s_addc_u32 s29, s29, 0
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[8:11], v[24:27]
		v_add_u32_e32 v7, 0x10000, v7
		s_and_b32 s91, s53, 1
		s_mul_i32 s91, 0x8200, s91
		ds_read_b128 a[100:103], v2 offset:64
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[12:15], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[20:23], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[24:27], v[40:43]
		ds_read_b128 a[108:111], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[28:31], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[32:35], v[48:51]
		ds_read_b128 a[112:115], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[36:39], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[36:39], v[84:87]
		ds_read_b128 a[116:119], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[28:31], v[76:79]
		ds_read_b128 a[120:123], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[20:23], v[68:71]
		ds_read_b128 a[124:127], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[12:15], v[60:63]
		ds_read_b128 a[128:131], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[28:31], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[32:35], v[112:115]
		s_mov_b32 m0, s1
		s_add_i32 s1, s6, s91
		ds_read_b128 a[40:43], v7 offset:1088
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[36:39], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v7 offset:1216
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[28:31], v[140:143]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[24:27], v[136:139]
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[20:23], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[16:19], v[128:131]
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		ds_read_b128 a[132:135], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[12:15], v[124:127]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[8:11], v[120:123]
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[8:11], v[152:155]
		ds_read_b128 a[52:55], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[20:23], v[164:167]
		ds_read_b128 a[136:139], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[28:31], v[172:175]
		ds_read_b128 a[140:143], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[56:59], a[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[60:63], a[36:39], v[212:215]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[24:27], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[28:31], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[32:35], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[64:67], a[36:39], v[244:247]
		v_mfma_f32_16x16x32_f16 a[96:99], a[68:71], a[36:39], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], a[68:71], a[32:35], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[28:31], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[24:27], a[84:87]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[16:19], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[12:15], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[8:11], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[100:103], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[104:107], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[108:111], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[112:115], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[116:119], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[120:123], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[124:127], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[128:131], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[128:131], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[124:127], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[120:123], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[116:119], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[116:119], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[120:123], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[124:127], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[128:131], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[132:135], a[128:131], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[132:135], a[124:127], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[132:135], a[120:123], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[132:135], a[116:119], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[132:135], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[132:135], a[108:111], v[128:131]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x9240
		s_nop 0
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s91, 0xffffdf80, s15
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_sub_i32 s15, s45, s15
		s_add_i32 s91, s91, 0x2080
		s_cmp_lt_i32 s53, 0x7e
		s_mul_i32 s91, s91, 4
		v_add_u32_e32 v7, s91, v6
		v_add_u32_e32 v2, s91, v5
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[132:135], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[132:135], a[100:103], v[120:123]
		v_add_u32_e32 v22, 0x10000, v7
		ds_read_b128 a[40:43], v22 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[112:115], v[164:167]
		ds_read_b128 a[44:47], v22 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[116:119], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[120:123], v[172:175]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[124:127], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[52:55], a[128:131], v[180:183]
		ds_read_b128 a[48:51], v22 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[136:139], a[128:131], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[136:139], a[124:127], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[136:139], a[120:123], v[204:207]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[136:139], a[116:119], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[136:139], a[112:115], v[196:199]
		ds_read_b128 a[52:55], v22 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[136:139], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[136:139], a[104:107], v[188:191]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[136:139], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[140:143], a[100:103], v[216:219]
		ds_read_b128 a[56:59], v22 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[140:143], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[140:143], a[108:111], v[224:227]
		ds_read_b128 a[28:31], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[140:143], a[112:115], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[140:143], a[116:119], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[140:143], a[120:123], v[236:239]
		ds_read_b128 a[60:63], v22 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[140:143], a[124:127], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[140:143], a[128:131], v[244:247]
		ds_read_b128 a[32:35], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[128:131], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[124:127], a[92:95]
		ds_read_b128 a[64:67], v22 offset:1792
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[36:39], v2 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		ds_read_b128 a[68:71], v22 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[104:107], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[100:103], a[72:75]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_3
.Lgfx950_f16_streamk_gemm.loop_exit_3:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[8:11], v[24:27]
		s_mov_b32 m0, s1
		ds_read_b128 a[100:103], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[12:15], v[28:31]
		s_add_i32 s42, s42, 0x100
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[20:23], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[24:27], v[40:43]
		ds_read_b128 a[108:111], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[28:31], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[32:35], v[48:51]
		ds_read_b128 a[112:115], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], a[40:43], a[36:39], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[44:47], a[36:39], v[84:87]
		ds_read_b128 a[40:43], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[28:31], v[76:79]
		ds_read_b128 a[116:119], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[24:27], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[20:23], v[68:71]
		ds_read_b128 a[120:123], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[12:15], v[60:63]
		ds_read_b128 a[124:127], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[28:31], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v0, s[16:19], s88 offen lds
		v_add_u32_e32 v2, 0x10000, v7
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[32:35], v[112:115]
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x80000
		s_add_i32 s1, s1, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x100000
		s_add_i32 s1, s1, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x180000
		s_add_i32 s1, s1, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x200000
		s_add_i32 s1, s1, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		ds_read_b128 v[8:11], v2 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], a[48:51], a[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[36:39], v[148:151]
		ds_read_b128 v[12:15], v2 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[32:35], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[28:31], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[24:27], v[136:139]
		ds_read_b128 v[16:19], v2 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[16:19], v[128:131]
		ds_read_b128 v[20:23], v2 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[8:11], v[152:155]
		ds_read_b128 a[44:47], v2 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[20:23], v[164:167]
		ds_read_b128 a[48:51], v2 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[28:31], v[172:175]
		ds_read_b128 a[52:55], v2 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[56:59], a[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[60:63], a[36:39], v[212:215]
		ds_read_b128 v[252:255], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[32:35], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[28:31], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[24:27], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[16:19], a[80:83]
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x280000
		s_add_i32 s1, s1, s37
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[12:15], a[76:79]
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[8:11], a[72:75]
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x300000
		s_add_i32 s1, s1, s37
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[24:27], v[232:235]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[24:27], a[84:87]
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[28:31], v[236:239]
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s1, s1, 17
		s_add_i32 s1, s1, 0x380000
		s_add_i32 s1, s1, s37
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[28:31], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[32:35], v[240:243]
		s_add_i32 s1, s1, s89
		buffer_load_dwordx4 v0, s[16:19], s1 offen lds
		v_mfma_f32_16x16x32_f16 v[244:247], a[64:67], a[36:39], v[244:247]
		s_add_i32 s1, s59, s90
		v_mfma_f32_16x16x32_f16 a[96:99], a[68:71], a[36:39], a[96:99]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 a[92:95], a[68:71], a[32:35], a[92:95]
		s_lshr_b32 s53, s0, 6
		s_lshl_b32 s53, s53, 17
		s_add_i32 s53, s53, 0x2000000
		s_add_i32 s53, s53, s90
		buffer_load_dwordx4 v0, s[20:23], s53 offen lds
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[100:103], v[24:27]
		s_add_i32 s53, s58, s90
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[104:107], v[28:31]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[108:111], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[112:115], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[40:43], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[116:119], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[120:123], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[124:127], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[124:127], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[120:123], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[112:115], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[108:111], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[100:103], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[108:111], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[112:115], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[120:123], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[124:127], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], v[20:23], a[124:127], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], a[120:123], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[40:43], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[112:115], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[108:111], v[128:131]
		s_lshl_b32 s7, s7, 11
		s_lshl_b32 s12, s12, 9
		s_add_i32 s53, s53, s12
		s_add_i32 s1, s1, s12
		s_lshr_b32 s88, s0, 6
		s_lshl_b32 s88, s88, 17
		s_add_i32 s88, s88, 0x2080000
		s_add_i32 s88, s88, s90
		buffer_load_dwordx4 v0, s[20:23], s88 offen lds
		s_add_i32 s88, s57, s90
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s88, s88, s12
		s_add_i32 s91, s36, s90
		buffer_load_dwordx4 v0, s[20:23], s91 offen lds
		s_lshr_b32 s91, s0, 6
		s_lshl_b32 s91, s91, 17
		s_add_i32 s91, s91, 0x280080
		s_add_i32 s91, s91, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s91, s91, s89
		s_add_i32 s92, s35, s90
		buffer_load_dwordx4 v0, s[20:23], s92 offen lds
		s_lshr_b32 s92, s0, 6
		s_lshl_b32 s92, s92, 17
		s_add_i32 s92, s92, 0x80
		s_add_i32 s92, s92, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s92, s92, s89
		s_add_i32 s93, s34, s90
		buffer_load_dwordx4 v0, s[20:23], s93 offen lds
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s93, s33, s90
		buffer_load_dwordx4 v0, s[20:23], s93 offen lds
		s_mul_i32 s93, 0xffffdf80, s15
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s93, s93, 0x2080
		s_lshl_b32 s93, s93, 2
		v_add_u32_e32 v2, s93, v5
		v_accvgpr_read_b32 v3, a2
		v_add_u32_e32 v3, s93, v3
		s_add_i32 s93, s32, s90
		buffer_load_dwordx4 v0, s[20:23], s93 offen lds
		s_sub_i32 s93, s45, s15
		s_sub_i32 s15, s45, s93
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s93, s47, s90
		buffer_load_dwordx4 v0, s[20:23], s93 offen lds
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[100:103], v[120:123]
		ds_read_b128 v[8:11], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[44:47], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[44:47], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[44:47], a[108:111], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[44:47], a[112:115], v[164:167]
		ds_read_b128 v[12:15], v3 offset:1152
		v_mfma_f32_16x16x32_f16 v[168:171], a[44:47], a[40:43], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[44:47], a[116:119], v[172:175]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[176:179], a[44:47], a[120:123], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[44:47], a[124:127], v[180:183]
		ds_read_b128 v[16:19], v3 offset:1280
		v_mfma_f32_16x16x32_f16 v[212:215], a[48:51], a[124:127], v[212:215]
		v_mfma_f32_16x16x32_f16 v[208:211], a[48:51], a[120:123], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[48:51], a[116:119], v[204:207]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[200:203], a[48:51], a[40:43], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[48:51], a[112:115], v[196:199]
		ds_read_b128 a[24:27], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[48:51], a[108:111], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[48:51], a[104:107], v[188:191]
		ds_read_b128 a[28:31], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[48:51], a[100:103], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[100:103], v[216:219]
		ds_read_b128 a[32:35], v3 offset:1536
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[104:107], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[52:55], a[108:111], v[224:227]
		ds_read_b128 a[36:39], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[228:231], a[52:55], a[112:115], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[52:55], a[40:43], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[52:55], a[116:119], v[236:239]
		ds_read_b128 a[44:47], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], a[120:123], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], a[124:127], v[244:247]
		ds_read_b128 a[48:51], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[96:99], v[252:255], a[124:127], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[252:255], a[120:123], a[92:95]
		ds_read_b128 a[52:55], v3 offset:1792
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[116:119], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[40:43], a[84:87]
		ds_read_b128 a[40:43], v2 offset:896
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[112:115], v[248:251]
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[108:111], a[80:83]
		ds_read_b128 v[20:23], v3 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[104:107], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[100:103], a[72:75]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[8:11], v[24:27]
		ds_read_b128 a[100:103], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[12:15], v[28:31]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[16:19], v[32:35]
		ds_read_b128 a[104:107], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[20:23], v[36:39]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[28:31], v[40:43]
		ds_read_b128 a[68:71], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[36:39], v[44:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[48:51], v[48:51]
		ds_read_b128 a[108:111], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[40:43], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[40:43], v[84:87]
		ds_read_b128 a[112:115], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[48:51], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[36:39], v[76:79]
		ds_read_b128 a[116:119], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[28:31], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[20:23], v[68:71]
		ds_read_b128 a[64:67], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[16:19], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[12:15], v[60:63]
		ds_read_b128 a[120:123], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[8:11], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[8:11], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[16:19], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[20:23], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[36:39], v[108:111]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], a[48:51], v[112:115]
		s_add_i32 m0, s6, 0x8200
		s_add_i32 s53, s53, s7
		buffer_load_dwordx4 v0, s[16:19], s92 offen lds
		s_add_i32 s92, s38, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s92, s92, s89
		buffer_load_dwordx4 v0, s[16:19], s92 offen lds
		s_add_i32 s92, s39, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s92, s92, s89
		buffer_load_dwordx4 v0, s[16:19], s92 offen lds
		s_add_i32 s92, s40, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s92, s92, s89
		buffer_load_dwordx4 v0, s[16:19], s92 offen lds
		s_add_i32 s92, s41, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s92, s92, s89
		buffer_load_dwordx4 v0, s[16:19], s92 offen lds
		ds_read_b128 v[8:11], v3 offset:1088
		v_mfma_f32_16x16x32_f16 v[116:119], v[16:19], a[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[24:27], a[40:43], v[148:151]
		ds_read_b128 v[12:15], v3 offset:1216
		v_mfma_f32_16x16x32_f16 v[144:147], a[24:27], a[48:51], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[24:27], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[24:27], a[28:31], v[136:139]
		ds_read_b128 a[56:59], v3 offset:1344
		v_mfma_f32_16x16x32_f16 v[132:135], a[24:27], a[20:23], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[24:27], a[16:19], v[128:131]
		ds_read_b128 a[60:63], v3 offset:1472
		v_mfma_f32_16x16x32_f16 v[124:127], a[24:27], a[12:15], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[24:27], a[8:11], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[32:35], a[8:11], v[152:155]
		ds_read_b128 a[24:27], v3 offset:1600
		v_mfma_f32_16x16x32_f16 v[156:159], a[32:35], a[12:15], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[32:35], a[16:19], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[32:35], a[20:23], v[164:167]
		ds_read_b128 a[124:127], v3 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[32:35], a[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[32:35], a[36:39], v[172:175]
		ds_read_b128 a[128:131], v3 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[32:35], a[48:51], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[32:35], a[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[44:47], a[40:43], v[212:215]
		ds_read_b128 a[132:135], v3 offset:1984
		v_mfma_f32_16x16x32_f16 v[208:211], a[44:47], a[48:51], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[44:47], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[44:47], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[44:47], a[20:23], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[44:47], a[16:19], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[44:47], a[12:15], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[44:47], a[8:11], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[52:55], a[8:11], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[52:55], a[12:15], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[52:55], a[16:19], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[52:55], a[20:23], v[228:231]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[248:251], v[20:23], a[20:23], v[248:251]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[80:83], v[20:23], a[16:19], a[80:83]
		buffer_load_dwordx4 v0, s[16:19], s91 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[52:55], a[28:31], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[52:55], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[52:55], a[48:51], v[240:243]
		v_mfma_f32_16x16x32_f16 v[244:247], a[52:55], a[40:43], v[244:247]
		v_mfma_f32_16x16x32_f16 a[96:99], v[20:23], a[40:43], a[96:99]
		v_mfma_f32_16x16x32_f16 a[92:95], v[20:23], a[48:51], a[92:95]
		v_mfma_f32_16x16x32_f16 a[88:91], v[20:23], a[36:39], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[20:23], a[28:31], a[84:87]
		v_mfma_f32_16x16x32_f16 a[76:79], v[20:23], a[12:15], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], v[20:23], a[8:11], a[72:75]
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[100:103], v[24:27]
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[104:107], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[68:71], v[32:35]
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[108:111], v[36:39]
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[112:115], v[40:43]
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[116:119], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], a[64:67], v[48:51]
		v_mfma_f32_16x16x32_f16 v[52:55], v[8:11], a[120:123], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[12:15], a[120:123], v[84:87]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], a[64:67], v[80:83]
		v_cvt_pk_f16_f32 v8, v24, v28
		v_cvt_pk_f16_f32 v16, v25, v29
		v_cvt_pk_f16_f32 v9, v32, v36
		v_cvt_pk_f16_f32 v17, v33, v37
		v_cvt_pk_f16_f32 v10, v40, v44
		v_cvt_pk_f16_f32 v18, v41, v45
		v_cvt_pk_f16_f32 v11, v48, v52
		v_cvt_pk_f16_f32 v19, v49, v53
		v_cvt_pk_f16_f32 v20, v26, v30
		v_cvt_pk_f16_f32 v21, v34, v38
		v_cvt_pk_f16_f32 v22, v42, v46
		v_cvt_pk_f16_f32 v23, v50, v54
		v_cvt_pk_f16_f32 v252, v27, v31
		v_cvt_pk_f16_f32 v253, v35, v39
		v_cvt_pk_f16_f32 v254, v43, v47
		v_cvt_pk_f16_f32 v255, v51, v55
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[112:115], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[108:111], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[68:71], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[104:107], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[100:103], v[56:59]
		v_cvt_pk_f16_f32 v15, v80, v84
		v_cvt_pk_f16_f32 v27, v81, v85
		v_cvt_pk_f16_f32 v31, v82, v86
		v_cvt_pk_f16_f32 v35, v83, v87
		v_cvt_pk_f16_f32 v14, v72, v76
		v_cvt_pk_f16_f32 v26, v73, v77
		v_cvt_pk_f16_f32 v13, v64, v68
		v_cvt_pk_f16_f32 v25, v65, v69
		v_cvt_pk_f16_f32 v12, v56, v60
		v_cvt_pk_f16_f32 v24, v57, v61
		v_cvt_pk_f16_f32 v28, v58, v62
		v_cvt_pk_f16_f32 v29, v66, v70
		v_cvt_pk_f16_f32 v30, v74, v78
		v_cvt_pk_f16_f32 v32, v59, v63
		v_cvt_pk_f16_f32 v33, v67, v71
		v_cvt_pk_f16_f32 v34, v75, v79
		v_mfma_f32_16x16x32_f16 v[88:91], a[56:59], a[100:103], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[56:59], a[104:107], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[56:59], a[68:71], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[56:59], a[108:111], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[56:59], a[112:115], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[56:59], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[56:59], a[64:67], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], a[56:59], a[120:123], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[60:63], a[120:123], v[148:151]
		v_mfma_f32_16x16x32_f16 v[144:147], a[60:63], a[64:67], v[144:147]
		v_cvt_pk_f16_f32 v36, v88, v92
		v_cvt_pk_f16_f32 v40, v89, v93
		v_cvt_pk_f16_f32 v37, v96, v100
		v_cvt_pk_f16_f32 v41, v97, v101
		v_cvt_pk_f16_f32 v38, v104, v108
		v_cvt_pk_f16_f32 v42, v105, v109
		v_cvt_pk_f16_f32 v39, v112, v116
		v_cvt_pk_f16_f32 v43, v113, v117
		v_cvt_pk_f16_f32 v44, v90, v94
		v_cvt_pk_f16_f32 v45, v98, v102
		v_cvt_pk_f16_f32 v46, v106, v110
		v_cvt_pk_f16_f32 v47, v114, v118
		v_cvt_pk_f16_f32 v48, v91, v95
		v_cvt_pk_f16_f32 v49, v99, v103
		v_cvt_pk_f16_f32 v50, v107, v111
		v_cvt_pk_f16_f32 v51, v115, v119
		v_mfma_f32_16x16x32_f16 v[140:143], a[60:63], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[60:63], a[112:115], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[60:63], a[108:111], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[60:63], a[68:71], v[128:131]
		v_cvt_pk_f16_f32 v55, v144, v148
		v_cvt_pk_f16_f32 v59, v145, v149
		v_cvt_pk_f16_f32 v63, v146, v150
		v_cvt_pk_f16_f32 v67, v147, v151
		s_add_i32 s91, s43, s37
		s_add_i32 m0, m0, 0x1040
		v_cvt_pk_f16_f32 v54, v136, v140
		v_cvt_pk_f16_f32 v58, v137, v141
		v_cvt_pk_f16_f32 v53, v128, v132
		v_cvt_pk_f16_f32 v57, v129, v133
		v_cvt_pk_f16_f32 v61, v130, v134
		v_cvt_pk_f16_f32 v62, v138, v142
		v_cvt_pk_f16_f32 v65, v131, v135
		v_cvt_pk_f16_f32 v66, v139, v143
		s_add_i32 s91, s91, s89
		buffer_load_dwordx4 v0, s[16:19], s91 offen lds
		s_add_i32 s37, s44, s37
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s37, s89
		buffer_load_dwordx4 v0, s[16:19], s37 offen lds
		s_add_i32 s37, s56, s90
		s_add_i32 m0, m0, 0x9240
		s_add_i32 s37, s37, s12
		s_add_i32 s37, s37, s7
		s_add_i32 s89, s48, s90
		buffer_load_dwordx4 v0, s[20:23], s89 offen lds
		s_add_i32 s89, s55, s90
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s89, s89, s12
		s_add_i32 s89, s89, s7
		s_add_i32 s91, s49, s90
		buffer_load_dwordx4 v0, s[20:23], s91 offen lds
		s_add_i32 s1, s1, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s91, s50, s90
		buffer_load_dwordx4 v0, s[20:23], s91 offen lds
		s_add_i32 s88, s88, s7
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s91, s51, s90
		buffer_load_dwordx4 v0, s[20:23], s91 offen lds
		s_add_i32 s91, s54, s90
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s91, s91, s12
		s_add_i32 s91, s91, s7
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s91 offen sc0 nt
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s89 offen sc0 nt
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s37 offen sc0 nt
		buffer_store_dwordx4 v[252:255], v1, s[8:11], s88 offen sc0 nt
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s53 offen sc0 nt
		buffer_store_dwordx4 v[24:27], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s52, s90
		buffer_load_dwordx4 v0, s[20:23], s1 offen lds
		s_add_i32 s1, s60, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[28:31], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s61, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[32:35], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s62, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[36:39], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s63, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[40:43], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s64, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[44:47], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s65, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[48:51], v1, s[8:11], s1 offen sc0 nt
		s_waitcnt vmcnt(13)
		s_barrier
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s1, s66, s90
		buffer_load_dwordx4 v0, s[20:23], s1 offen lds
		s_add_i32 s1, s69, s90
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s37, s67, s90
		buffer_load_dwordx4 v0, s[20:23], s37 offen lds
		s_mul_i32 s37, 0x2080, s15
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s53, s68, s90
		buffer_load_dwordx4 v0, s[20:23], s53 offen lds
		s_mul_i32 s37, s37, 4
		v_add_u32_e32 v2, s37, v5
		v_add_u32_e32 v7, s37, v6
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[124:127], a[60:63], a[104:107], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[60:63], a[100:103], v[120:123]
		v_add_u32_e32 v3, 0x10000, v7
		ds_read_b128 a[40:43], v3 offset:1024
		v_mfma_f32_16x16x32_f16 v[152:155], a[24:27], a[100:103], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[24:27], a[104:107], v[156:159]
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[160:163], a[24:27], a[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[24:27], a[108:111], v[164:167]
		ds_read_b128 a[44:47], v3 offset:1152
		v_cvt_pk_f16_f32 v52, v120, v124
		v_cvt_pk_f16_f32 v56, v121, v125
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v60, v122, v126
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[52:55], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[168:171], a[24:27], a[112:115], v[168:171]
		s_add_i32 s1, s70, s90
		v_cvt_pk_f16_f32 v64, v123, v127
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v8, v152, v156
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[56:59], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[172:175], a[24:27], a[116:119], v[172:175]
		s_add_i32 s1, s71, s90
		v_cvt_pk_f16_f32 v9, v160, v164
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v12, v153, v157
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[60:63], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[16:19], v2 offset:256
		s_add_i32 s1, s72, s90
		v_cvt_pk_f16_f32 v10, v168, v172
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v13, v161, v165
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[64:67], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[176:179], a[24:27], a[64:67], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], a[24:27], a[120:123], v[180:183]
		v_cvt_pk_f16_f32 v14, v169, v173
		v_cvt_pk_f16_f32 v16, v154, v158
		v_cvt_pk_f16_f32 v17, v162, v166
		v_cvt_pk_f16_f32 v18, v170, v174
		v_cvt_pk_f16_f32 v20, v155, v159
		v_cvt_pk_f16_f32 v21, v163, v167
		v_cvt_pk_f16_f32 v22, v171, v175
		ds_read_b128 a[48:51], v3 offset:1280
		v_cvt_pk_f16_f32 v11, v176, v180
		v_cvt_pk_f16_f32 v15, v177, v181
		s_add_i32 s1, s73, s90
		v_cvt_pk_f16_f32 v19, v178, v182
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v23, v179, v183
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[212:215], a[124:127], a[120:123], v[212:215]
		s_add_i32 s1, s74, s90
		v_mfma_f32_16x16x32_f16 v[208:211], a[124:127], a[64:67], v[208:211]
		s_add_i32 s1, s1, s12
		v_mfma_f32_16x16x32_f16 v[204:207], a[124:127], a[116:119], v[204:207]
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[20:23], v2 offset:384
		s_add_i32 s1, s75, s90
		v_mfma_f32_16x16x32_f16 v[200:203], a[124:127], a[112:115], v[200:203]
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v11, v208, v212
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[196:199], a[124:127], a[108:111], v[196:199]
		s_add_i32 s1, s76, s90
		v_cvt_pk_f16_f32 v15, v209, v213
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v10, v200, v204
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[52:55], v3 offset:1408
		v_mfma_f32_16x16x32_f16 v[192:195], a[124:127], a[68:71], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[124:127], a[104:107], v[188:191]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[184:187], a[124:127], a[100:103], v[184:187]
		v_cvt_pk_f16_f32 v14, v201, v205
		v_cvt_pk_f16_f32 v18, v202, v206
		v_cvt_pk_f16_f32 v19, v210, v214
		v_cvt_pk_f16_f32 v22, v203, v207
		v_cvt_pk_f16_f32 v23, v211, v215
		v_cvt_pk_f16_f32 v9, v192, v196
		v_cvt_pk_f16_f32 v13, v193, v197
		v_cvt_pk_f16_f32 v17, v194, v198
		v_cvt_pk_f16_f32 v8, v184, v188
		v_cvt_pk_f16_f32 v12, v185, v189
		s_add_i32 s1, s77, s90
		v_cvt_pk_f16_f32 v16, v186, v190
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v20, v187, v191
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[216:219], a[128:131], a[100:103], v[216:219]
		s_add_i32 s1, s78, s90
		v_cvt_pk_f16_f32 v21, v195, v199
		s_add_i32 s1, s1, s12
		ds_read_b128 a[56:59], v3 offset:1536
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[220:223], a[128:131], a[104:107], v[220:223]
		s_add_i32 s1, s79, s90
		v_mfma_f32_16x16x32_f16 v[224:227], a[128:131], a[68:71], v[224:227]
		s_add_i32 s1, s1, s12
		ds_read_b128 a[28:31], v2 offset:640
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[228:231], a[128:131], a[108:111], v[228:231]
		s_add_i32 s1, s80, s90
		v_cvt_pk_f16_f32 v8, v216, v220
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v12, v217, v221
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s1 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[232:235], a[128:131], a[112:115], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[128:131], a[116:119], v[236:239]
		ds_read_b128 a[60:63], v3 offset:1664
		v_mfma_f32_16x16x32_f16 v[240:243], a[128:131], a[64:67], v[240:243]
		v_cvt_pk_f16_f32 v9, v224, v228
		v_mfma_f32_16x16x32_f16 v[244:247], a[128:131], a[120:123], v[244:247]
		v_cvt_pk_f16_f32 v13, v225, v229
		v_cvt_pk_f16_f32 v16, v218, v222
		v_cvt_pk_f16_f32 v17, v226, v230
		v_cvt_pk_f16_f32 v20, v219, v223
		v_cvt_pk_f16_f32 v10, v232, v236
		v_cvt_pk_f16_f32 v14, v233, v237
		v_cvt_pk_f16_f32 v18, v234, v238
		v_cvt_pk_f16_f32 v21, v227, v231
		v_cvt_pk_f16_f32 v11, v240, v244
		v_cvt_pk_f16_f32 v15, v241, v245
		s_add_i32 s1, s81, s90
		v_cvt_pk_f16_f32 v19, v242, v246
		s_add_i32 s1, s1, s12
		v_cvt_pk_f16_f32 v22, v235, v239
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[32:35], v2 offset:768
		s_add_i32 s1, s82, s90
		v_mfma_f32_16x16x32_f16 a[96:99], a[132:135], a[120:123], a[96:99]
		s_add_i32 s1, s1, s12
		v_mfma_f32_16x16x32_f16 a[92:95], a[132:135], a[64:67], a[92:95]
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[64:67], v3 offset:1792
		s_add_i32 s1, s83, s90
		v_mfma_f32_16x16x32_f16 a[88:91], a[132:135], a[116:119], a[88:91]
		s_add_i32 s1, s1, s12
		v_mfma_f32_16x16x32_f16 a[84:87], a[132:135], a[112:115], a[84:87]
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[36:39], v2 offset:896
		v_cvt_pk_f16_f32 v23, v243, v247
		v_mfma_f32_16x16x32_f16 v[248:251], a[132:135], a[108:111], v[248:251]
		s_add_i32 s1, s84, s90
		v_mfma_f32_16x16x32_f16 a[80:83], a[132:135], a[68:71], a[80:83]
		s_add_i32 s1, s1, s12
		v_accvgpr_read_b32 v4, a84
		v_accvgpr_read_b32 v8, a88
		v_cvt_pk_f16_f32 v14, v4, v8
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s1 offen sc0 nt
		ds_read_b128 a[68:71], v3 offset:1920
		v_mfma_f32_16x16x32_f16 a[76:79], a[132:135], a[104:107], a[76:79]
		v_accvgpr_read_b32 v3, a92
		v_accvgpr_read_b32 v4, a96
		v_cvt_pk_f16_f32 v15, v3, v4
		v_mfma_f32_16x16x32_f16 a[72:75], a[132:135], a[100:103], a[72:75]
		v_accvgpr_read_b32 v3, a80
		v_cvt_pk_f16_f32 v13, v3, v248
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_f16_f32 v9, v3, v249
		v_accvgpr_read_b32 v3, a85
		v_accvgpr_read_b32 v4, a89
		v_cvt_pk_f16_f32 v10, v3, v4
		v_accvgpr_read_b32 v3, a93
		v_accvgpr_read_b32 v4, a97
		v_cvt_pk_f16_f32 v11, v3, v4
		v_accvgpr_read_b32 v3, a82
		v_cvt_pk_f16_f32 v17, v3, v250
		v_accvgpr_read_b32 v3, a86
		v_accvgpr_read_b32 v4, a90
		v_cvt_pk_f16_f32 v18, v3, v4
		v_accvgpr_read_b32 v3, a94
		v_accvgpr_read_b32 v4, a98
		v_cvt_pk_f16_f32 v19, v3, v4
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_f16_f32 v21, v3, v251
		v_accvgpr_read_b32 v3, a72
		v_accvgpr_read_b32 v4, a76
		v_cvt_pk_f16_f32 v12, v3, v4
		v_accvgpr_read_b32 v3, a73
		v_accvgpr_read_b32 v4, a77
		v_cvt_pk_f16_f32 v8, v3, v4
		s_add_i32 s1, s85, s90
		v_accvgpr_read_b32 v3, a74
		v_accvgpr_read_b32 v4, a78
		v_cvt_pk_f16_f32 v16, v3, v4
		s_add_i32 s1, s1, s12
		v_accvgpr_read_b32 v3, a75
		v_accvgpr_read_b32 v4, a79
		v_cvt_pk_f16_f32 v20, v3, v4
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s86, s90
		v_accvgpr_read_b32 v3, a87
		v_accvgpr_read_b32 v4, a91
		v_cvt_pk_f16_f32 v22, v3, v4
		s_add_i32 s1, s1, s12
		v_accvgpr_read_b32 v3, a95
		v_accvgpr_read_b32 v4, a99
		v_cvt_pk_f16_f32 v23, v3, v4
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s87, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s1 offen sc0 nt
		s_add_i32 s1, s14, s90
		s_add_i32 s1, s1, s12
		s_add_i32 s1, s1, s7
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s1 offen sc0 nt
		s_cmp_lt_i32 s42, 0x300
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_2
.Lgfx950_f16_streamk_gemm.loop_exit_2:
.Lgfx950_f16_streamk_gemm.if_end_0:
		s_mov_b32 s1, s6
		v_accvgpr_read_b32 v0, a0
		v_add_u32_e32 v0, 0x80, v0
		v_accvgpr_read_b32 v3, a0
		v_add_u32_e32 v3, 0x80080, v3
		v_accvgpr_read_b32 v4, a0
		v_add_u32_e32 v4, 0x100080, v4
		v_accvgpr_read_b32 v8, a0
		v_add_u32_e32 v8, 0x180080, v8
		v_accvgpr_read_b32 v9, a0
		v_add_u32_e32 v9, 0x200080, v9
		v_accvgpr_read_b32 v10, a0
		v_add_u32_e32 v10, 0x280080, v10
		v_accvgpr_read_b32 v11, a0
		v_add_u32_e32 v11, 0x300080, v11
		v_accvgpr_read_b32 v12, a0
		v_add_u32_e32 v12, 0x380080, v12
		v_accvgpr_read_b32 v13, a1
		v_add_u32_e32 v13, 0x6000080, v13
		v_accvgpr_read_b32 v14, a1
		v_add_u32_e32 v14, 0x6080080, v14
		v_accvgpr_read_b32 v15, a1
		v_add_u32_e32 v15, 0x6100080, v15
		v_accvgpr_read_b32 v16, a1
		v_add_u32_e32 v16, 0x6180080, v16
		v_accvgpr_read_b32 v17, a1
		v_add_u32_e32 v17, 0x6200080, v17
		v_accvgpr_read_b32 v18, a1
		v_add_u32_e32 v18, 0x6280080, v18
		v_accvgpr_read_b32 v19, a1
		v_add_u32_e32 v19, 0x6300080, v19
		v_accvgpr_read_b32 v20, a1
		v_add_u32_e32 v20, 0x6380080, v20
		s_cbranch_scc0 .Lgfx950_f16_streamk_gemm.if_else_1
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
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
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
.Lgfx950_f16_streamk_gemm.loop_head_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		ds_read_b128 a[92:95], v2 offset:64
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[12:15], v[24:27]
		s_add_i32 s46, s46, 1
		s_and_b32 s2, s46, 1
		s_mul_i32 s2, 0x8200, s2
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[16:19], v[28:31]
		ds_read_b128 a[96:99], v2 offset:192
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[20:23], v[32:35]
		s_mul_i32 s3, 0xffffdf80, s15
		s_sub_i32 s15, s45, s15
		s_add_i32 s3, s3, 0x2080
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[24:27], v[36:39]
		ds_read_b128 a[100:103], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[28:31], v[40:43]
		s_mul_i32 s3, s3, 4
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[32:35], v[44:47]
		ds_read_b128 a[104:107], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[36:39], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[36:39], v[80:83]
		ds_read_b128 a[108:111], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[28:31], v[72:75]
		ds_read_b128 a[112:115], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[24:27], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[20:23], v[64:67]
		ds_read_b128 a[116:119], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[16:19], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[12:15], v[56:59]
		ds_read_b128 a[120:123], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[8:11], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[8:11], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[28:31], v[104:107]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[32:35], v[108:111]
		s_mov_b32 m0, s1
		ds_read_b128 a[40:43], v7 offset:1088
		buffer_load_dwordx4 v0, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[36:39], v[144:147]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v7 offset:1216
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[32:35], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[28:31], v[136:139]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[24:27], v[132:135]
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[20:23], v[128:131]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[16:19], v[124:127]
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[124:127], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[12:15], v[120:123]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[8:11], v[116:119]
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[8:11], v[148:151]
		ds_read_b128 a[52:55], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[12:15], v[152:155]
		s_add_i32 s1, s6, s2
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[20:23], v[160:163]
		ds_read_b128 a[128:131], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[28:31], v[168:171]
		ds_read_b128 a[132:135], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[36:39], v[176:179]
		v_add_u32_e32 v2, s3, v5
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[36:39], v[208:211]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[32:35], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[12:15], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[8:11], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[8:11], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[12:15], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[16:19], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[20:23], v[224:227]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[20:23], a[72:75]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[24:27], v[228:231]
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[28:31], v[232:235]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[32:35], v[236:239]
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[36:39], v[240:243]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 a[0:3], a[68:71], a[16:19], a[0:3]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[12:15], v[248:251]
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[8:11], v[244:247]
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[92:95], a[4:7]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v7, s3, v6
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v21, 0x10000, v7
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[96:99], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[100:103], v[28:31]
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[104:107], v[32:35]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[108:111], v[36:39]
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[112:115], v[40:43]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[116:119], v[44:47]
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[120:123], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[120:123], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[112:115], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[108:111], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[104:107], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[100:103], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[96:99], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[92:95], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[92:95], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[96:99], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[100:103], v[92:95]
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[104:107], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[108:111], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[112:115], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[120:123], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[124:127], a[120:123], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[124:127], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[124:127], a[112:115], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[124:127], a[108:111], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[124:127], a[104:107], v[128:131]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[124:127], a[124:127], a[100:103], v[124:127]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[120:123], a[124:127], a[96:99], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[124:127], a[92:95], v[116:119]
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		ds_read_b128 a[40:43], v21 offset:1024
		v_mfma_f32_16x16x32_f16 v[148:151], a[52:55], a[92:95], v[148:151]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[152:155], a[52:55], a[96:99], v[152:155]
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[156:159], a[52:55], a[100:103], v[156:159]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v21 offset:1152
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[160:163], a[52:55], a[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[52:55], a[108:111], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[52:55], a[112:115], v[168:171]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[172:175], a[52:55], a[116:119], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[52:55], a[120:123], v[176:179]
		ds_read_b128 a[48:51], v21 offset:1280
		v_mfma_f32_16x16x32_f16 v[208:211], a[128:131], a[120:123], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[128:131], a[116:119], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[128:131], a[112:115], v[200:203]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[196:199], a[128:131], a[108:111], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[128:131], a[104:107], v[192:195]
		ds_read_b128 a[52:55], v21 offset:1408
		v_mfma_f32_16x16x32_f16 v[188:191], a[128:131], a[100:103], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[96:99], v[184:187]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[92:95], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[92:95], v[212:215]
		ds_read_b128 a[56:59], v21 offset:1536
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[96:99], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[100:103], v[220:223]
		ds_read_b128 a[28:31], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[104:107], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[108:111], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[112:115], v[232:235]
		ds_read_b128 a[60:63], v21 offset:1664
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[116:119], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[120:123], v[240:243]
		ds_read_b128 a[32:35], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[64:67], v21 offset:1792
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		ds_read_b128 a[36:39], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[0:3], v[252:255], a[100:103], a[0:3]
		ds_read_b128 a[68:71], v21 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[96:99], v[248:251]
		s_cmp_lt_i32 s46, 0x7e
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], a[92:95], v[244:247]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_4
.Lgfx950_f16_streamk_gemm.loop_exit_4:
		s_branch .Lgfx950_f16_streamk_gemm.if_end_1
.Lgfx950_f16_streamk_gemm.if_else_1:
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
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
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
.Lgfx950_f16_streamk_gemm.loop_head_5:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v7, 0x10000, v7
		s_add_u32 s16, s16, 0x80
		s_addc_u32 s17, s17, 0
		s_add_u32 s20, s20, 0x80
		s_addc_u32 s21, s21, 0
		ds_read_b128 a[92:95], v2 offset:64
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[12:15], v[24:27]
		s_add_i32 s46, s46, 1
		s_and_b32 s2, s46, 1
		s_mul_i32 s2, 0x8200, s2
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[16:19], v[28:31]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[20:23], v[32:35]
		ds_read_b128 a[96:99], v2 offset:192
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[24:27], v[36:39]
		ds_read_b128 a[100:103], v2 offset:320
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[28:31], v[40:43]
		s_mul_i32 s3, 0xffffdf80, s15
		s_sub_i32 s15, s45, s15
		s_add_i32 s3, s3, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[32:35], v[44:47]
		ds_read_b128 a[104:107], v2 offset:448
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[36:39], v[48:51]
		s_mul_i32 s3, s3, 4
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[32:35], v[76:79]
		ds_read_b128 a[108:111], v2 offset:576
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[28:31], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[24:27], v[68:71]
		ds_read_b128 a[112:115], v2 offset:704
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[20:23], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[16:19], v[60:63]
		ds_read_b128 a[116:119], v2 offset:832
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[12:15], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[8:11], v[52:55]
		ds_read_b128 a[120:123], v2 offset:960
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[8:11], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[28:31], v[104:107]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[32:35], v[108:111]
		s_mov_b32 m0, s1
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[36:39], v[144:147]
		buffer_load_dwordx4 v0, s[16:19], 0 offen lds
		ds_read_b128 a[40:43], v7 offset:1088
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[32:35], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[28:31], v[136:139]
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		ds_read_b128 a[44:47], v7 offset:1216
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[24:27], v[132:135]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[16:19], v[124:127]
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		ds_read_b128 a[48:51], v7 offset:1344
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[8:11], v[116:119]
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		ds_read_b128 a[52:55], v7 offset:1472
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[8:11], v[148:151]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[124:127], v7 offset:1600
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[12:15], v[152:155]
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[16:19], v[156:159]
		s_add_i32 s1, s6, s2
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[24:27], v[164:167]
		ds_read_b128 a[128:131], v7 offset:1728
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[32:35], v[172:175]
		ds_read_b128 a[132:135], v7 offset:1856
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[36:39], v[176:179]
		v_add_u32_e32 v2, s3, v5
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[32:35], v[204:207]
		ds_read_b128 v[252:255], v7 offset:1984
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[12:15], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[8:11], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[8:11], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[12:15], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[16:19], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[20:23], v[224:227]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[20:23], a[72:75]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[24:27], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[28:31], v[232:235]
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[32:35], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[36:39], v[240:243]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		v_mfma_f32_16x16x32_f16 a[0:3], a[68:71], a[16:19], a[0:3]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[12:15], v[248:251]
		s_add_i32 m0, m0, 0x9240
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[8:11], v[244:247]
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s3, v6
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[92:95], a[4:7]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v21, 0x10000, v7
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[96:99], v[24:27]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[100:103], v[28:31]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[104:107], v[32:35]
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[108:111], v[36:39]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[112:115], v[40:43]
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[116:119], v[44:47]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[120:123], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[120:123], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[116:119], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[112:115], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[108:111], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[104:107], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[100:103], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[96:99], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[92:95], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[92:95], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[96:99], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[100:103], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[104:107], v[96:99]
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[108:111], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[112:115], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[116:119], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[120:123], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[120:123], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[116:119], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[112:115], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[108:111], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[104:107], v[128:131]
		s_waitcnt vmcnt(13)
		s_barrier
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[100:103], v[124:127]
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		ds_read_b128 a[8:11], v2
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[96:99], v[120:123]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[40:43], v21 offset:1024
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		ds_read_b128 a[12:15], v2 offset:128
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[92:95], v[116:119]
		s_add_i32 m0, m0, 0x1040
		ds_read_b128 a[44:47], v21 offset:1152
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[148:151], a[124:127], a[92:95], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[124:127], a[96:99], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[124:127], a[100:103], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[124:127], a[104:107], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[124:127], a[108:111], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[124:127], a[112:115], v[168:171]
		ds_read_b128 a[16:19], v2 offset:256
		v_mfma_f32_16x16x32_f16 v[172:175], a[124:127], a[116:119], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[124:127], a[120:123], v[176:179]
		ds_read_b128 a[48:51], v21 offset:1280
		v_mfma_f32_16x16x32_f16 v[208:211], a[128:131], a[120:123], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[128:131], a[116:119], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[128:131], a[112:115], v[200:203]
		ds_read_b128 a[20:23], v2 offset:384
		v_mfma_f32_16x16x32_f16 v[196:199], a[128:131], a[108:111], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[128:131], a[104:107], v[192:195]
		ds_read_b128 a[52:55], v21 offset:1408
		v_mfma_f32_16x16x32_f16 v[188:191], a[128:131], a[100:103], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[128:131], a[96:99], v[184:187]
		ds_read_b128 a[24:27], v2 offset:512
		v_mfma_f32_16x16x32_f16 v[180:183], a[128:131], a[92:95], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[132:135], a[92:95], v[212:215]
		ds_read_b128 a[56:59], v21 offset:1536
		v_mfma_f32_16x16x32_f16 v[216:219], a[132:135], a[96:99], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[132:135], a[100:103], v[220:223]
		ds_read_b128 a[28:31], v2 offset:640
		v_mfma_f32_16x16x32_f16 v[224:227], a[132:135], a[104:107], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[132:135], a[108:111], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[132:135], a[112:115], v[232:235]
		ds_read_b128 a[60:63], v21 offset:1664
		v_mfma_f32_16x16x32_f16 v[236:239], a[132:135], a[116:119], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[132:135], a[120:123], v[240:243]
		ds_read_b128 a[32:35], v2 offset:768
		v_mfma_f32_16x16x32_f16 a[88:91], v[252:255], a[120:123], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], v[252:255], a[116:119], a[84:87]
		ds_read_b128 a[64:67], v21 offset:1792
		v_mfma_f32_16x16x32_f16 a[80:83], v[252:255], a[112:115], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], v[252:255], a[108:111], a[76:79]
		ds_read_b128 a[36:39], v2 offset:896
		v_mfma_f32_16x16x32_f16 a[72:75], v[252:255], a[104:107], a[72:75]
		v_mfma_f32_16x16x32_f16 a[0:3], v[252:255], a[100:103], a[0:3]
		ds_read_b128 a[68:71], v21 offset:1920
		v_mfma_f32_16x16x32_f16 v[248:251], v[252:255], a[96:99], v[248:251]
		s_cmp_lt_i32 s46, 0x7e
		v_mfma_f32_16x16x32_f16 v[244:247], v[252:255], a[92:95], v[244:247]
		s_cbranch_scc1 .Lgfx950_f16_streamk_gemm.loop_head_5
.Lgfx950_f16_streamk_gemm.loop_exit_5:
.Lgfx950_f16_streamk_gemm.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 a[4:7], a[40:43], a[8:11], a[4:7]
		v_add_u32_e32 v0, 0x10000, v7
		ds_read_b128 v[8:11], v0 offset:1088
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[52:55], a[44:47], a[8:11], v[52:55]
		ds_read_b128 v[12:15], v0 offset:1216
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[84:87], a[48:51], a[8:11], v[84:87]
		ds_read_b128 v[16:19], v0 offset:1344
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[116:119], a[52:55], a[8:11], v[116:119]
		ds_read_b128 v[20:23], v0 offset:1472
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[148:151], a[56:59], a[8:11], v[148:151]
		ds_read_b128 a[92:95], v0 offset:1600
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[180:183], a[60:63], a[8:11], v[180:183]
		ds_read_b128 a[96:99], v0 offset:1728
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[212:215], a[64:67], a[8:11], v[212:215]
		ds_read_b128 a[100:103], v0 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[244:247], a[68:71], a[8:11], v[244:247]
		ds_read_b128 a[8:11], v0 offset:1984
		v_mfma_f32_16x16x32_f16 v[24:27], a[40:43], a[12:15], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[44:47], a[12:15], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[48:51], a[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[52:55], a[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[56:59], a[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[60:63], a[12:15], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], a[64:67], a[12:15], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[68:71], a[12:15], v[248:251]
		v_mfma_f32_16x16x32_f16 a[0:3], a[68:71], a[16:19], a[0:3]
		v_mfma_f32_16x16x32_f16 v[28:31], a[40:43], a[16:19], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[44:47], a[16:19], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[48:51], a[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[52:55], a[16:19], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[56:59], a[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[60:63], a[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], a[64:67], a[16:19], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[64:67], a[20:23], v[224:227]
		v_mfma_f32_16x16x32_f16 v[32:35], a[40:43], a[20:23], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[44:47], a[20:23], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[48:51], a[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[52:55], a[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[56:59], a[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[60:63], a[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 a[72:75], a[68:71], a[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[68:71], a[24:27], a[76:79]
		v_mfma_f32_16x16x32_f16 v[36:39], a[40:43], a[24:27], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[44:47], a[24:27], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[48:51], a[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[52:55], a[24:27], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[56:59], a[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[60:63], a[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[228:231], a[64:67], a[24:27], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[64:67], a[28:31], v[232:235]
		v_mfma_f32_16x16x32_f16 v[40:43], a[40:43], a[28:31], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[44:47], a[28:31], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[48:51], a[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[52:55], a[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[56:59], a[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[60:63], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 a[80:83], a[68:71], a[28:31], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[68:71], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 v[44:47], a[40:43], a[32:35], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[44:47], a[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[48:51], a[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[52:55], a[32:35], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[56:59], a[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[60:63], a[32:35], v[204:207]
		v_mfma_f32_16x16x32_f16 v[236:239], a[64:67], a[32:35], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[64:67], a[36:39], v[240:243]
		v_mfma_f32_16x16x32_f16 v[48:51], a[40:43], a[36:39], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[44:47], a[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[48:51], a[36:39], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[52:55], a[36:39], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[56:59], a[36:39], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[60:63], a[36:39], v[208:211]
		v_mfma_f32_16x16x32_f16 a[88:91], a[68:71], a[36:39], a[88:91]
		ds_read_b128 a[12:15], v2 offset:64
		ds_read_b128 a[16:19], v2 offset:192
		ds_read_b128 a[20:23], v2 offset:320
		ds_read_b128 a[24:27], v2 offset:448
		ds_read_b128 a[28:31], v2 offset:576
		ds_read_b128 a[32:35], v2 offset:704
		ds_read_b128 a[36:39], v2 offset:832
		ds_read_b128 v[252:255], v2 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], v[8:11], a[12:15], a[4:7]
		s_mul_i32 s1, 0xffffdf80, s15
		s_add_i32 s1, s1, 0x2080
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[24:27], v[8:11], a[16:19], v[24:27]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[28:31], v[8:11], a[20:23], v[28:31]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[32:35], v[8:11], a[24:27], v[32:35]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[36:39], v[8:11], a[28:31], v[36:39]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[40:43], v[8:11], a[32:35], v[40:43]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[44:47], v[8:11], a[36:39], v[44:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[48:51], v[8:11], v[252:255], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], v[12:15], v[252:255], v[80:83]
		v_mfma_f32_16x16x32_f16 v[76:79], v[12:15], a[36:39], v[76:79]
		v_mfma_f32_16x16x32_f16 v[72:75], v[12:15], a[32:35], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], v[12:15], a[28:31], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], v[12:15], a[24:27], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], v[12:15], a[20:23], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], v[12:15], a[16:19], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], v[12:15], a[12:15], v[52:55]
		v_mfma_f32_16x16x32_f16 v[84:87], v[16:19], a[12:15], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[16:19], a[16:19], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[16:19], a[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[16:19], a[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[16:19], a[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[16:19], a[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[16:19], a[36:39], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[16:19], v[252:255], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], v[20:23], v[252:255], v[144:147]
		v_mfma_f32_16x16x32_f16 v[140:143], v[20:23], a[36:39], v[140:143]
		v_mfma_f32_16x16x32_f16 v[136:139], v[20:23], a[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], v[20:23], a[28:31], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], v[20:23], a[24:27], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], v[20:23], a[20:23], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], v[20:23], a[16:19], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], v[20:23], a[12:15], v[116:119]
		v_mfma_f32_16x16x32_f16 v[148:151], a[92:95], a[12:15], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], a[92:95], a[16:19], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], a[92:95], a[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[92:95], a[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[92:95], a[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[92:95], a[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[92:95], a[36:39], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[92:95], v[252:255], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[96:99], v[252:255], v[208:211]
		v_mfma_f32_16x16x32_f16 v[204:207], a[96:99], a[36:39], v[204:207]
		v_mfma_f32_16x16x32_f16 v[200:203], a[96:99], a[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[96:99], a[28:31], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[96:99], a[24:27], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[96:99], a[20:23], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[96:99], a[16:19], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[96:99], a[12:15], v[180:183]
		v_mfma_f32_16x16x32_f16 v[212:215], a[100:103], a[12:15], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], a[100:103], a[16:19], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], a[100:103], a[20:23], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], a[100:103], a[24:27], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], a[100:103], a[28:31], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], a[100:103], a[32:35], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], a[100:103], a[36:39], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], a[100:103], v[252:255], v[240:243]
		v_mfma_f32_16x16x32_f16 a[88:91], a[8:11], v[252:255], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[8:11], a[36:39], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[8:11], a[32:35], a[80:83]
		v_mfma_f32_16x16x32_f16 a[76:79], a[8:11], a[28:31], a[76:79]
		v_mfma_f32_16x16x32_f16 a[72:75], a[8:11], a[24:27], a[72:75]
		v_mfma_f32_16x16x32_f16 a[0:3], a[8:11], a[20:23], a[0:3]
		v_mfma_f32_16x16x32_f16 v[248:251], a[8:11], a[16:19], v[248:251]
		v_mfma_f32_16x16x32_f16 v[244:247], a[8:11], a[12:15], v[244:247]
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshl_b32 s1, s1, 2
		v_add_u32_e32 v0, s1, v5
		ds_read_b128 v[8:11], v0
		ds_read_b128 v[12:15], v0 offset:128
		ds_read_b128 v[16:19], v0 offset:256
		ds_read_b128 v[20:23], v0 offset:384
		ds_read_b128 a[8:11], v0 offset:512
		ds_read_b128 a[12:15], v0 offset:640
		ds_read_b128 a[16:19], v0 offset:768
		ds_read_b128 a[20:23], v0 offset:896
		s_add_i32 s1, s1, 0x10000
		v_add_u32_e32 v2, s1, v6
		ds_read_b128 a[24:27], v2 offset:1024
		ds_read_b128 a[28:31], v2 offset:1152
		ds_read_b128 a[32:35], v2 offset:1280
		ds_read_b128 a[36:39], v2 offset:1408
		ds_read_b128 a[40:43], v2 offset:1536
		ds_read_b128 a[44:47], v2 offset:1664
		ds_read_b128 v[4:7], v2 offset:1792
		ds_read_b128 a[48:51], v2 offset:1920
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[24:27], v[8:11], a[4:7]
		ds_read_b128 a[52:55], v2 offset:1088
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[52:55], a[28:31], v[8:11], v[52:55]
		ds_read_b128 a[56:59], v2 offset:1216
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[84:87], a[32:35], v[8:11], v[84:87]
		ds_read_b128 a[60:63], v2 offset:1344
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[116:119], a[36:39], v[8:11], v[116:119]
		ds_read_b128 a[64:67], v2 offset:1472
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[148:151], a[40:43], v[8:11], v[148:151]
		ds_read_b128 a[68:71], v2 offset:1600
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[180:183], a[44:47], v[8:11], v[180:183]
		ds_read_b128 a[92:95], v2 offset:1728
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[212:215], v[4:7], v[8:11], v[212:215]
		ds_read_b128 v[252:255], v2 offset:1856
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[244:247], a[48:51], v[8:11], v[244:247]
		ds_read_b128 a[96:99], v2 offset:1984
		v_mfma_f32_16x16x32_f16 v[24:27], a[24:27], v[12:15], v[24:27]
		v_mfma_f32_16x16x32_f16 v[56:59], a[28:31], v[12:15], v[56:59]
		v_mfma_f32_16x16x32_f16 v[88:91], a[32:35], v[12:15], v[88:91]
		v_mfma_f32_16x16x32_f16 v[120:123], a[36:39], v[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[152:155], a[40:43], v[12:15], v[152:155]
		v_mfma_f32_16x16x32_f16 v[184:187], a[44:47], v[12:15], v[184:187]
		v_mfma_f32_16x16x32_f16 v[216:219], v[4:7], v[12:15], v[216:219]
		v_mfma_f32_16x16x32_f16 v[248:251], a[48:51], v[12:15], v[248:251]
		v_mfma_f32_16x16x32_f16 a[0:3], a[48:51], v[16:19], a[0:3]
		v_mfma_f32_16x16x32_f16 v[28:31], a[24:27], v[16:19], v[28:31]
		v_mfma_f32_16x16x32_f16 v[60:63], a[28:31], v[16:19], v[60:63]
		v_mfma_f32_16x16x32_f16 v[92:95], a[32:35], v[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[124:127], a[36:39], v[16:19], v[124:127]
		v_mfma_f32_16x16x32_f16 v[156:159], a[40:43], v[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[188:191], a[44:47], v[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[220:223], v[4:7], v[16:19], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[4:7], v[20:23], v[224:227]
		v_mfma_f32_16x16x32_f16 v[32:35], a[24:27], v[20:23], v[32:35]
		v_mfma_f32_16x16x32_f16 v[64:67], a[28:31], v[20:23], v[64:67]
		v_mfma_f32_16x16x32_f16 v[96:99], a[32:35], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[128:131], a[36:39], v[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[160:163], a[40:43], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[192:195], a[44:47], v[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 a[72:75], a[48:51], v[20:23], a[72:75]
		v_mfma_f32_16x16x32_f16 a[76:79], a[48:51], a[8:11], a[76:79]
		v_mfma_f32_16x16x32_f16 v[36:39], a[24:27], a[8:11], v[36:39]
		v_mfma_f32_16x16x32_f16 v[68:71], a[28:31], a[8:11], v[68:71]
		v_mfma_f32_16x16x32_f16 v[100:103], a[32:35], a[8:11], v[100:103]
		v_mfma_f32_16x16x32_f16 v[132:135], a[36:39], a[8:11], v[132:135]
		v_mfma_f32_16x16x32_f16 v[164:167], a[40:43], a[8:11], v[164:167]
		v_mfma_f32_16x16x32_f16 v[196:199], a[44:47], a[8:11], v[196:199]
		v_mfma_f32_16x16x32_f16 v[228:231], v[4:7], a[8:11], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[4:7], a[12:15], v[232:235]
		v_mfma_f32_16x16x32_f16 v[40:43], a[24:27], a[12:15], v[40:43]
		v_mfma_f32_16x16x32_f16 v[72:75], a[28:31], a[12:15], v[72:75]
		v_mfma_f32_16x16x32_f16 v[104:107], a[32:35], a[12:15], v[104:107]
		v_mfma_f32_16x16x32_f16 v[136:139], a[36:39], a[12:15], v[136:139]
		v_mfma_f32_16x16x32_f16 v[168:171], a[40:43], a[12:15], v[168:171]
		v_mfma_f32_16x16x32_f16 v[200:203], a[44:47], a[12:15], v[200:203]
		v_mfma_f32_16x16x32_f16 a[80:83], a[48:51], a[12:15], a[80:83]
		v_mfma_f32_16x16x32_f16 a[84:87], a[48:51], a[16:19], a[84:87]
		v_mfma_f32_16x16x32_f16 v[44:47], a[24:27], a[16:19], v[44:47]
		v_mfma_f32_16x16x32_f16 v[76:79], a[28:31], a[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[108:111], a[32:35], a[16:19], v[108:111]
		v_mfma_f32_16x16x32_f16 v[140:143], a[36:39], a[16:19], v[140:143]
		v_mfma_f32_16x16x32_f16 v[172:175], a[40:43], a[16:19], v[172:175]
		v_mfma_f32_16x16x32_f16 v[204:207], a[44:47], a[16:19], v[204:207]
		v_mfma_f32_16x16x32_f16 v[236:239], v[4:7], a[16:19], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], v[4:7], a[20:23], v[240:243]
		v_mfma_f32_16x16x32_f16 v[48:51], a[24:27], a[20:23], v[48:51]
		v_mfma_f32_16x16x32_f16 v[80:83], a[28:31], a[20:23], v[80:83]
		v_mfma_f32_16x16x32_f16 v[112:115], a[32:35], a[20:23], v[112:115]
		v_mfma_f32_16x16x32_f16 v[144:147], a[36:39], a[20:23], v[144:147]
		v_mfma_f32_16x16x32_f16 v[176:179], a[40:43], a[20:23], v[176:179]
		v_mfma_f32_16x16x32_f16 v[208:211], a[44:47], a[20:23], v[208:211]
		v_mfma_f32_16x16x32_f16 a[88:91], a[48:51], a[20:23], a[88:91]
		ds_read_b128 a[8:11], v0 offset:64
		ds_read_b128 a[12:15], v0 offset:192
		ds_read_b128 a[16:19], v0 offset:320
		ds_read_b128 a[20:23], v0 offset:448
		ds_read_b128 a[24:27], v0 offset:576
		ds_read_b128 a[28:31], v0 offset:704
		ds_read_b128 a[32:35], v0 offset:832
		ds_read_b128 v[4:7], v0 offset:960
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 a[4:7], a[52:55], a[8:11], a[4:7]
		s_lshr_b32 s1, s0, 6
		s_lshr_b32 s1, s1, 1
		s_lshl_b32 s1, s1, 21
		s_add_i32 s2, s1, 0x6000000
		s_lshr_b32 s3, s13, 5
		s_lshl_b32 s3, s3, 22
		s_add_i32 s2, s2, s3
		s_and_b32 s4, s13, 31
		s_lshr_b32 s4, s4, 3
		s_lshl_b32 s4, s4, 9
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[24:27], a[52:55], a[12:15], v[24:27]
		s_add_i32 s2, s2, s4
		s_lshr_b32 s0, s0, 6
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 8
		s_add_i32 s2, s2, s0
		s_and_b32 s5, s13, 31
		s_and_b32 s5, s5, 7
		s_lshl_b32 s5, s5, 11
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[28:31], a[52:55], a[16:19], v[28:31]
		s_add_i32 s2, s2, s5
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[32:35], a[52:55], a[20:23], v[32:35]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[36:39], a[52:55], a[24:27], v[36:39]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[40:43], a[52:55], a[28:31], v[40:43]
		v_accvgpr_read_b32 v0, a4
		v_cvt_pk_f16_f32 v8, v0, v24
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[44:47], a[52:55], a[32:35], v[44:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[48:51], a[52:55], v[4:7], v[48:51]
		v_accvgpr_read_b32 v0, a5
		v_cvt_pk_f16_f32 v12, v0, v25
		v_accvgpr_read_b32 v0, a6
		v_cvt_pk_f16_f32 v16, v0, v26
		v_accvgpr_read_b32 v0, a7
		v_cvt_pk_f16_f32 v20, v0, v27
		v_cvt_pk_f16_f32 v9, v28, v32
		v_cvt_pk_f16_f32 v13, v29, v33
		v_cvt_pk_f16_f32 v10, v36, v40
		v_cvt_pk_f16_f32 v14, v37, v41
		v_cvt_pk_f16_f32 v17, v30, v34
		v_cvt_pk_f16_f32 v11, v44, v48
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6020000
		v_cvt_pk_f16_f32 v15, v45, v49
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6040000
		v_cvt_pk_f16_f32 v18, v38, v42
		v_cvt_pk_f16_f32 v19, v46, v50
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6060000
		v_cvt_pk_f16_f32 v21, v31, v35
		v_cvt_pk_f16_f32 v22, v39, v43
		v_cvt_pk_f16_f32 v23, v47, v51
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[80:83], a[56:59], v[4:7], v[80:83]
		s_add_i32 s2, s1, 0x6004000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[76:79], a[56:59], a[32:35], v[76:79]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[72:75], a[56:59], a[28:31], v[72:75]
		v_mfma_f32_16x16x32_f16 v[68:71], a[56:59], a[24:27], v[68:71]
		v_mfma_f32_16x16x32_f16 v[64:67], a[56:59], a[20:23], v[64:67]
		v_mfma_f32_16x16x32_f16 v[60:63], a[56:59], a[16:19], v[60:63]
		v_mfma_f32_16x16x32_f16 v[56:59], a[56:59], a[12:15], v[56:59]
		v_mfma_f32_16x16x32_f16 v[52:55], a[56:59], a[8:11], v[52:55]
		v_cvt_pk_f16_f32 v11, v76, v80
		v_cvt_pk_f16_f32 v15, v77, v81
		v_cvt_pk_f16_f32 v19, v78, v82
		v_cvt_pk_f16_f32 v23, v79, v83
		v_cvt_pk_f16_f32 v10, v68, v72
		v_cvt_pk_f16_f32 v14, v69, v73
		v_cvt_pk_f16_f32 v9, v60, v64
		v_cvt_pk_f16_f32 v13, v61, v65
		v_cvt_pk_f16_f32 v8, v52, v56
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6024000
		v_cvt_pk_f16_f32 v12, v53, v57
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6044000
		v_cvt_pk_f16_f32 v16, v54, v58
		v_cvt_pk_f16_f32 v17, v62, v66
		v_cvt_pk_f16_f32 v18, v70, v74
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6064000
		v_cvt_pk_f16_f32 v20, v55, v59
		v_cvt_pk_f16_f32 v21, v63, v67
		v_cvt_pk_f16_f32 v22, v71, v75
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[84:87], a[60:63], a[8:11], v[84:87]
		s_add_i32 s2, s1, 0x6008000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[88:91], a[60:63], a[12:15], v[88:91]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[92:95], a[60:63], a[16:19], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], a[60:63], a[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], a[60:63], a[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], a[60:63], a[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], a[60:63], a[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], a[60:63], v[4:7], v[112:115]
		v_cvt_pk_f16_f32 v8, v84, v88
		v_cvt_pk_f16_f32 v12, v85, v89
		v_cvt_pk_f16_f32 v16, v86, v90
		v_cvt_pk_f16_f32 v20, v87, v91
		v_cvt_pk_f16_f32 v9, v92, v96
		v_cvt_pk_f16_f32 v13, v93, v97
		v_cvt_pk_f16_f32 v10, v100, v104
		v_cvt_pk_f16_f32 v14, v101, v105
		v_cvt_pk_f16_f32 v11, v108, v112
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6028000
		v_cvt_pk_f16_f32 v15, v109, v113
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6048000
		v_cvt_pk_f16_f32 v17, v94, v98
		v_cvt_pk_f16_f32 v18, v102, v106
		v_cvt_pk_f16_f32 v19, v110, v114
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6068000
		v_cvt_pk_f16_f32 v21, v95, v99
		v_cvt_pk_f16_f32 v22, v103, v107
		v_cvt_pk_f16_f32 v23, v111, v115
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[144:147], a[64:67], v[4:7], v[144:147]
		s_add_i32 s2, s1, 0x600c000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[140:143], a[64:67], a[32:35], v[140:143]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[136:139], a[64:67], a[28:31], v[136:139]
		v_mfma_f32_16x16x32_f16 v[132:135], a[64:67], a[24:27], v[132:135]
		v_mfma_f32_16x16x32_f16 v[128:131], a[64:67], a[20:23], v[128:131]
		v_mfma_f32_16x16x32_f16 v[124:127], a[64:67], a[16:19], v[124:127]
		v_mfma_f32_16x16x32_f16 v[120:123], a[64:67], a[12:15], v[120:123]
		v_mfma_f32_16x16x32_f16 v[116:119], a[64:67], a[8:11], v[116:119]
		v_cvt_pk_f16_f32 v11, v140, v144
		v_cvt_pk_f16_f32 v15, v141, v145
		v_cvt_pk_f16_f32 v19, v142, v146
		v_cvt_pk_f16_f32 v23, v143, v147
		v_cvt_pk_f16_f32 v10, v132, v136
		v_cvt_pk_f16_f32 v14, v133, v137
		v_cvt_pk_f16_f32 v9, v124, v128
		v_cvt_pk_f16_f32 v13, v125, v129
		v_cvt_pk_f16_f32 v8, v116, v120
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x602c000
		v_cvt_pk_f16_f32 v12, v117, v121
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x604c000
		v_cvt_pk_f16_f32 v16, v118, v122
		v_cvt_pk_f16_f32 v17, v126, v130
		v_cvt_pk_f16_f32 v18, v134, v138
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x606c000
		v_cvt_pk_f16_f32 v20, v119, v123
		v_cvt_pk_f16_f32 v21, v127, v131
		v_cvt_pk_f16_f32 v22, v135, v139
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[148:151], a[68:71], a[8:11], v[148:151]
		s_add_i32 s2, s1, 0x6010000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[152:155], a[68:71], a[12:15], v[152:155]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[156:159], a[68:71], a[16:19], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], a[68:71], a[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], a[68:71], a[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], a[68:71], a[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], a[68:71], a[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], a[68:71], v[4:7], v[176:179]
		v_cvt_pk_f16_f32 v8, v148, v152
		v_cvt_pk_f16_f32 v12, v149, v153
		v_cvt_pk_f16_f32 v16, v150, v154
		v_cvt_pk_f16_f32 v20, v151, v155
		v_cvt_pk_f16_f32 v9, v156, v160
		v_cvt_pk_f16_f32 v13, v157, v161
		v_cvt_pk_f16_f32 v10, v164, v168
		v_cvt_pk_f16_f32 v14, v165, v169
		v_cvt_pk_f16_f32 v11, v172, v176
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6030000
		v_cvt_pk_f16_f32 v15, v173, v177
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6050000
		v_cvt_pk_f16_f32 v17, v158, v162
		v_cvt_pk_f16_f32 v18, v166, v170
		v_cvt_pk_f16_f32 v19, v174, v178
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6070000
		v_cvt_pk_f16_f32 v21, v159, v163
		v_cvt_pk_f16_f32 v22, v167, v171
		v_cvt_pk_f16_f32 v23, v175, v179
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[208:211], a[92:95], v[4:7], v[208:211]
		s_add_i32 s2, s1, 0x6014000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[204:207], a[92:95], a[32:35], v[204:207]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[200:203], a[92:95], a[28:31], v[200:203]
		v_mfma_f32_16x16x32_f16 v[196:199], a[92:95], a[24:27], v[196:199]
		v_mfma_f32_16x16x32_f16 v[192:195], a[92:95], a[20:23], v[192:195]
		v_mfma_f32_16x16x32_f16 v[188:191], a[92:95], a[16:19], v[188:191]
		v_mfma_f32_16x16x32_f16 v[184:187], a[92:95], a[12:15], v[184:187]
		v_mfma_f32_16x16x32_f16 v[180:183], a[92:95], a[8:11], v[180:183]
		v_cvt_pk_f16_f32 v11, v204, v208
		v_cvt_pk_f16_f32 v15, v205, v209
		v_cvt_pk_f16_f32 v19, v206, v210
		v_cvt_pk_f16_f32 v23, v207, v211
		v_cvt_pk_f16_f32 v10, v196, v200
		v_cvt_pk_f16_f32 v14, v197, v201
		v_cvt_pk_f16_f32 v9, v188, v192
		v_cvt_pk_f16_f32 v13, v189, v193
		v_cvt_pk_f16_f32 v8, v180, v184
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6034000
		v_cvt_pk_f16_f32 v12, v181, v185
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[12:15], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6054000
		v_cvt_pk_f16_f32 v16, v182, v186
		v_cvt_pk_f16_f32 v17, v190, v194
		v_cvt_pk_f16_f32 v18, v198, v202
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[16:19], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x6074000
		v_cvt_pk_f16_f32 v20, v183, v187
		v_cvt_pk_f16_f32 v21, v191, v195
		v_cvt_pk_f16_f32 v22, v199, v203
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[20:23], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[212:215], v[252:255], a[8:11], v[212:215]
		s_add_i32 s2, s1, 0x6018000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		v_mfma_f32_16x16x32_f16 v[216:219], v[252:255], a[12:15], v[216:219]
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		v_mfma_f32_16x16x32_f16 v[220:223], v[252:255], a[16:19], v[220:223]
		v_mfma_f32_16x16x32_f16 v[224:227], v[252:255], a[20:23], v[224:227]
		v_mfma_f32_16x16x32_f16 v[228:231], v[252:255], a[24:27], v[228:231]
		v_mfma_f32_16x16x32_f16 v[232:235], v[252:255], a[28:31], v[232:235]
		v_mfma_f32_16x16x32_f16 v[236:239], v[252:255], a[32:35], v[236:239]
		v_mfma_f32_16x16x32_f16 v[240:243], v[252:255], v[4:7], v[240:243]
		v_cvt_pk_f16_f32 v8, v212, v216
		v_mfma_f32_16x16x32_f16 a[88:91], a[96:99], v[4:7], a[88:91]
		v_mfma_f32_16x16x32_f16 a[84:87], a[96:99], a[32:35], a[84:87]
		v_mfma_f32_16x16x32_f16 a[80:83], a[96:99], a[28:31], a[80:83]
		v_cvt_pk_f16_f32 v9, v220, v224
		v_mfma_f32_16x16x32_f16 a[76:79], a[96:99], a[24:27], a[76:79]
		v_cvt_pk_f16_f32 v10, v228, v232
		v_mfma_f32_16x16x32_f16 a[72:75], a[96:99], a[20:23], a[72:75]
		v_cvt_pk_f16_f32 v11, v236, v240
		buffer_store_dwordx4 v[8:11], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 a[0:3], a[96:99], a[16:19], a[0:3]
		v_cvt_pk_f16_f32 v4, v213, v217
		v_cvt_pk_f16_f32 v5, v221, v225
		v_cvt_pk_f16_f32 v6, v229, v233
		v_cvt_pk_f16_f32 v7, v237, v241
		s_add_i32 s2, s1, 0x6038000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[248:251], a[96:99], a[12:15], v[248:251]
		v_cvt_pk_f16_f32 v4, v214, v218
		v_cvt_pk_f16_f32 v5, v222, v226
		v_cvt_pk_f16_f32 v6, v230, v234
		v_cvt_pk_f16_f32 v7, v238, v242
		s_add_i32 s2, s1, 0x6058000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		v_mfma_f32_16x16x32_f16 v[244:247], a[96:99], a[8:11], v[244:247]
		v_cvt_pk_f16_f32 v4, v215, v219
		v_cvt_pk_f16_f32 v5, v223, v227
		v_cvt_pk_f16_f32 v6, v231, v235
		v_cvt_pk_f16_f32 v7, v239, v243
		s_add_i32 s2, s1, 0x6078000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x601c000
		v_cvt_pk_f16_f32 v4, v244, v248
		v_accvgpr_read_b32 v0, a0
		v_accvgpr_read_b32 v2, a72
		v_cvt_pk_f16_f32 v5, v0, v2
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v2, a80
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v2, a88
		v_cvt_pk_f16_f32 v7, v0, v2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x603c000
		v_cvt_pk_f16_f32 v4, v245, v249
		v_accvgpr_read_b32 v0, a1
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v5, v0, v2
		v_accvgpr_read_b32 v0, a77
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a85
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v7, v0, v2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s2, s1, 0x605c000
		v_cvt_pk_f16_f32 v4, v246, v250
		v_accvgpr_read_b32 v0, a2
		v_accvgpr_read_b32 v2, a74
		v_cvt_pk_f16_f32 v5, v0, v2
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v2, a82
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v2, a90
		v_cvt_pk_f16_f32 v7, v0, v2
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s0
		s_add_i32 s2, s2, s5
		buffer_store_dwordx4 v[4:7], v1, s[8:11], s2 offen sc0 nt
		s_add_i32 s1, s1, 0x607c000
		v_cvt_pk_f16_f32 v4, v247, v251
		v_accvgpr_read_b32 v0, a3
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v0, v2
		v_accvgpr_read_b32 v0, a79
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v6, v0, v2
		v_accvgpr_read_b32 v0, a87
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v7, v0, v2
		s_add_i32 s1, s1, s3
		s_add_i32 s1, s1, s4
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s5
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
		.amdhsa_next_free_vgpr 400
		.amdhsa_next_free_sgpr 102
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
	.set .Lgfx950_f16_streamk_gemm.num_agpr, 144
	.set .Lgfx950_f16_streamk_gemm.numbered_sgpr, 102
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
    .sgpr_count:     102
    .sgpr_spill_count: 0
    .symbol:         gfx950_f16_streamk_gemm.kd
    .uses_dynamic_stack: false
    .vgpr_count:     400
    .agpr_count:     144
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 238
    wave.regalloc.agpr.dwords: 831
    wave.regalloc.remat.dwords: 29
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
