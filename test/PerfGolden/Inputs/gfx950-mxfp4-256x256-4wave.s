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
		s_lshr_b32 s16, s13, 3
		v_and_b32_e32 v1, 63, v0
		s_lshl_b32 s17, s14, 1
		s_add_i32 s18, s17, s16
		s_and_b32 s16, s13, 7
		s_lshl_b32 s17, s16, 5
		v_lshrrev_b32_e32 v2, 3, v1
		s_add_i32 s16, s18, s17
		v_lshrrev_b32_e32 v3, 2, v1
		s_lshr_b32 s17, s16, 6
		s_lshl_b32 s18, s17, 23
		s_and_b32 s19, s16, 63
		v_lshrrev_b32_e32 v4, 6, v0
		v_and_b32_e32 v5, 3, v2
		v_and_b32_e32 v2, 3, v1
		s_lshr_b32 s16, s19, 2
		v_lshlrev_b32_e32 v6, 12, v3
		s_lshl_b32 s20, s16, 17
		s_add_i32 s21, s18, s20
		v_readfirstlane_b32 s18, v0
		s_and_b32 s20, s19, 3
		v_xor_b32_e32 v3, v5, v2
		s_lshl_b32 s19, s20, 21
		v_lshl_add_u32 v2, v4, 16, v6
		s_add_i32 s22, s21, s19
		s_add_u32 s24, s6, s22
		s_addc_u32 s25, s7, 0
		s_lshr_b32 s19, s18, 6
		s_lshl_b32 s18, s19, 10
		v_lshl_add_u32 v5, v3, 4, v2
		s_lshl_b32 s19, s17, 22
		s_lshl_b32 s21, s20, 20
		s_add_i32 s22, s19, s21
		v_mov_b32_e32 v2, s22
		s_nop 0
		v_readfirstlane_b32 s22, v2
		s_nop 1
		v_add_u32_e32 v3, s22, v5
		s_mov_b32 m0, s18
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s30, 0x1000000
		s_mov_b32 s31, 0x31016000
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x1000
		s_add_i32 s22, s19, 0x40000
		s_add_i32 s23, s22, s21
		v_mov_b32_e32 v3, s23
		s_nop 0
		v_readfirstlane_b32 s22, v3
		s_nop 1
		v_add_u32_e32 v6, s22, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x2000
		s_add_i32 s22, s19, 0x80000
		s_add_i32 s23, s22, s21
		v_add_u32_e32 v6, s23, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x3000
		s_add_i32 s22, s19, 0xc0000
		s_add_i32 s26, s22, s21
		v_add_u32_e32 v6, s26, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x4000
		s_add_i32 s22, s19, 64
		s_add_i32 s27, s22, s21
		v_add_u32_e32 v6, s27, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x5000
		s_add_i32 s22, s19, 0x40040
		s_add_i32 s32, s22, s21
		v_add_u32_e32 v6, s32, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x6000
		s_add_i32 s22, s19, 0x80040
		s_add_i32 s33, s22, s21
		v_add_u32_e32 v6, s33, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x7000
		s_add_i32 s22, s19, 0xc0040
		s_add_i32 s34, s22, s21
		v_add_u32_e32 v6, s34, v5
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x8000
		s_lshl_b32 s22, s16, 20
		v_add_u32_e32 v6, s22, v5
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, 0x1000000
		s_mov_b32 s39, 0x31016000
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x9000
		s_add_i32 s35, s22, 0x40000
		v_add_u32_e32 v6, s35, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xa000
		s_add_i32 s40, s22, 0x80000
		v_add_u32_e32 v6, s40, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xb000
		s_add_i32 s41, s22, 0xc0000
		v_add_u32_e32 v6, s41, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xc000
		s_add_i32 s42, s22, 64
		v_add_u32_e32 v6, s42, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xd000
		s_add_i32 s43, s22, 0x40040
		v_add_u32_e32 v6, s43, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xe000
		s_add_i32 s44, s22, 0x80040
		v_add_u32_e32 v6, s44, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0xf000
		s_add_i32 s45, s22, 0xc0040
		v_add_u32_e32 v6, s45, v5
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		v_lshrrev_b32_e32 v6, 7, v0
		v_lshrrev_b32_e32 v7, 4, v1
		v_lshlrev_b32_e32 v8, 10, v6
		v_and_b32_e32 v9, 15, v0
		v_and_b32_e32 v10, 1, v4
		v_lshlrev_b32_e32 v11, 7, v6
		v_lshlrev_b32_e32 v12, 12, v7
		v_lshlrev_b32_e32 v13, 2, v9
		v_lshlrev_b32_e32 v14, 7, v7
		v_add_u32_e32 v15, 0x20000, v8
		v_accvgpr_write_b32 a0, v15
		s_mov_b32 s46, 0
		s_lshl_b32 s47, s17, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_cmp_eq_u32_e64 vcc, v10, s46
		s_mov_b64 s[48:49], vcc
		v_add3_u32 v10, v11, v12, v13
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v12, v11, v14, v13
		s_lshl_b32 s17, s20, 8
		s_add_i32 s20, s47, s17
		s_add_i32 s50, s47, 0x4000
		s_add_i32 s51, s50, s17
		s_mov_b32 s52, s10
		s_mov_b32 s53, s11
		s_mov_b32 s54, 0x7fffffff
		s_mov_b32 s55, 0x31016000
		s_mov_b32 s56, s8
		s_mov_b32 s57, s9
		s_mov_b32 s58, 0x7fffffff
		s_mov_b32 s59, 0x31016000
		s_mov_b32 s60, s24
		s_mov_b32 s61, s25
		s_mov_b32 s62, 0x20000
		s_mov_b32 s63, 0x31016000
		s_and_saveexec_b64 s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v11, v10, s[56:59], s20 offen
		buffer_load_dword v15, v10, s[56:59], s20 offen offset:64
		buffer_load_dword v20, v10, s[56:59], s51 offen
		buffer_load_dword v21, v10, s[56:59], s51 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v11
		ds_write_b32 v12, v15 offset:512
		ds_write_b32 v12, v20 offset:4096
		ds_write_b32 v12, v21 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[68:69]
		v_add_u32_e32 v11, 0x20000, v14
		v_lshrrev_b32_e32 v15, 1, v4
		v_lshl_add_u32 v20, v7, 12, v13
		v_and_b32_e32 v21, 1, v4
		v_add_u32_e32 v22, v11, v13
		v_cmp_eq_u32_e64 vcc, v15, s46
		s_mov_b64 s[24:25], vcc
		v_lshl_add_u32 v11, v21, 7, v20
		v_lshl_add_u32 v15, v21, 10, v22
		s_lshl_b32 s50, s16, 8
		s_add_i32 s16, s50, 0x4000
		s_and_saveexec_b64 s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v20, v11, s[52:55], s50 offen
		buffer_load_dword v22, v11, s[52:55], s50 offen offset:64
		buffer_load_dword v23, v11, s[52:55], s16 offen
		buffer_load_dword v24, v11, s[52:55], s16 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v15, v20 offset:2048
		ds_write_b32 v15, v22 offset:2560
		ds_write_b32 v15, v23 offset:6144
		ds_write_b32 v15, v24 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s16, s47, 0x8000
		s_add_i32 s51, s16, s17
		s_add_i32 s16, s47, 0xc000
		s_add_i32 s47, s16, s17
		s_and_saveexec_b64 s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v20, v10, s[56:59], s51 offen
		buffer_load_dword v22, v10, s[56:59], s51 offen offset:64
		buffer_load_dword v23, v10, s[56:59], s47 offen
		buffer_load_dword v24, v10, s[56:59], s47 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v20 offset:8192
		ds_write_b32 v12, v22 offset:8704
		ds_write_b32 v12, v23 offset:12288
		ds_write_b32 v12, v24 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s16, s50, 0x8000
		s_add_i32 s17, s50, 0xc000
		s_and_saveexec_b64 s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v12, v11, s[52:55], s16 offen
		buffer_load_dword v20, v11, s[52:55], s16 offen offset:64
		buffer_load_dword v22, v11, s[52:55], s17 offen
		buffer_load_dword v23, v11, s[52:55], s17 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v15, v12 offset:10240
		ds_write_b32 v15, v20 offset:10752
		ds_write_b32 v15, v22 offset:14336
		ds_write_b32 v15, v23 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[68:69]
		s_add_i32 m0, s18, 0x10000
		s_add_i32 s16, s19, 0x80
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x11000
		s_add_i32 s16, s19, 0x40080
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x12000
		s_add_i32 s16, s19, 0x80080
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x13000
		s_add_i32 s16, s19, 0xc0080
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x14000
		s_add_i32 s16, s19, 0xc0
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x15000
		s_add_i32 s16, s19, 0x400c0
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x16000
		s_add_i32 s16, s19, 0x800c0
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x17000
		s_add_i32 s16, s19, 0xc00c0
		s_add_i32 s17, s16, s21
		v_add_u32_e32 v12, s17, v5
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 m0, s18, 0x18000
		s_add_i32 s16, s22, 0x80
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x19000
		s_add_i32 s16, s22, 0x40080
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1a000
		s_add_i32 s16, s22, 0x80080
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1b000
		s_add_i32 s16, s22, 0xc0080
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1c000
		s_add_i32 s16, s22, 0xc0
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1d000
		s_add_i32 s16, s22, 0x400c0
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1e000
		s_add_i32 s16, s22, 0x800c0
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s18, 0x1f000
		s_add_i32 s16, s22, 0xc00c0
		v_add_u32_e32 v12, s16, v5
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		v_lshlrev_b32_e32 v12, 13, v6
		v_lshlrev_b32_e32 v6, 6, v9
		v_lshrrev_b32_e32 v15, 1, v9
		v_and_b32_e32 v9, 3, v15
		v_xor_b32_e32 v15, v7, v9
		v_lshlrev_b32_e32 v7, 4, v15
		v_add3_u32 v9, v12, v6, v7
		ds_read_b128 v[24:27], v9
		ds_read_b128 v[28:31], v9 offset:1024
		ds_read_b128 v[32:35], v9 offset:2048
		ds_read_b128 v[36:39], v9 offset:3072
		ds_read_b128 v[40:43], v9 offset:4096
		ds_read_b128 v[44:47], v9 offset:5120
		ds_read_b128 v[48:51], v9 offset:6144
		ds_read_b128 v[52:55], v9 offset:7168
		ds_read_b128 v[56:59], v9 offset:16384
		ds_read_b128 v[60:63], v9 offset:17408
		ds_read_b128 v[64:67], v9 offset:18432
		ds_read_b128 v[68:71], v9 offset:19456
		ds_read_b128 v[72:75], v9 offset:20480
		ds_read_b128 v[76:79], v9 offset:21504
		ds_read_b128 v[80:83], v9 offset:22528
		ds_read_b128 v[84:87], v9 offset:23552
		v_lshlrev_b32_e32 v9, 13, v21
		v_add3_u32 v15, v6, v9, v7
		ds_read_b128 v[88:91], v15 offset:32768
		ds_read_b128 v[92:95], v15 offset:33792
		ds_read_b128 v[96:99], v15 offset:34816
		ds_read_b128 v[100:103], v15 offset:35840
		ds_read_b128 v[104:107], v15 offset:36864
		ds_read_b128 v[108:111], v15 offset:37888
		ds_read_b128 v[112:115], v15 offset:38912
		ds_read_b128 v[116:119], v15 offset:39936
		ds_read_b128 v[120:123], v15 offset:49152
		ds_read_b128 v[124:127], v15 offset:50176
		ds_read_b128 v[128:131], v15 offset:51200
		ds_read_b128 v[132:135], v15 offset:52224
		ds_read_b128 v[136:139], v15 offset:53248
		ds_read_b128 v[140:143], v15 offset:54272
		ds_read_b128 v[144:147], v15 offset:55296
		ds_read_b128 v[148:151], v15 offset:56320
		s_cmp_lt_i32 0, 30
		v_lshlrev_b32_e32 v15, 3, v1
		v_lshlrev_b32_e32 v20, 10, v21
		v_mov_b64_e32 v[152:153], 0
		v_mov_b64_e32 v[154:155], 0
		v_mov_b64_e32 v[156:157], 0
		v_mov_b64_e32 v[158:159], 0
		v_mov_b64_e32 v[160:161], 0
		v_mov_b64_e32 v[162:163], 0
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_accvgpr_write_b32 a4, v164
		v_accvgpr_write_b32 a5, v165
		v_accvgpr_write_b32 a6, v166
		v_accvgpr_write_b32 a7, v167
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_accvgpr_write_b32 a8, v164
		v_accvgpr_write_b32 a9, v165
		v_accvgpr_write_b32 a10, v166
		v_accvgpr_write_b32 a11, v167
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_accvgpr_write_b32 a12, v164
		v_accvgpr_write_b32 a13, v165
		v_accvgpr_write_b32 a14, v166
		v_accvgpr_write_b32 a15, v167
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_accvgpr_write_b32 a16, v164
		v_accvgpr_write_b32 a17, v165
		v_accvgpr_write_b32 a18, v166
		v_accvgpr_write_b32 a19, v167
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
		v_accvgpr_write_b32 a20, v180
		v_accvgpr_write_b32 a21, v181
		v_accvgpr_write_b32 a22, v182
		v_accvgpr_write_b32 a23, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a24, v180
		v_accvgpr_write_b32 a25, v181
		v_accvgpr_write_b32 a26, v182
		v_accvgpr_write_b32 a27, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a28, v180
		v_accvgpr_write_b32 a29, v181
		v_accvgpr_write_b32 a30, v182
		v_accvgpr_write_b32 a31, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a32, v180
		v_accvgpr_write_b32 a33, v181
		v_accvgpr_write_b32 a34, v182
		v_accvgpr_write_b32 a35, v183
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
		v_accvgpr_write_b32 a36, v196
		v_accvgpr_write_b32 a37, v197
		v_accvgpr_write_b32 a38, v198
		v_accvgpr_write_b32 a39, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a40, v196
		v_accvgpr_write_b32 a41, v197
		v_accvgpr_write_b32 a42, v198
		v_accvgpr_write_b32 a43, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a44, v196
		v_accvgpr_write_b32 a45, v197
		v_accvgpr_write_b32 a46, v198
		v_accvgpr_write_b32 a47, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a48, v196
		v_accvgpr_write_b32 a49, v197
		v_accvgpr_write_b32 a50, v198
		v_accvgpr_write_b32 a51, v199
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
		v_accvgpr_write_b32 a52, v212
		v_accvgpr_write_b32 a53, v213
		v_accvgpr_write_b32 a54, v214
		v_accvgpr_write_b32 a55, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a56, v212
		v_accvgpr_write_b32 a57, v213
		v_accvgpr_write_b32 a58, v214
		v_accvgpr_write_b32 a59, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a60, v212
		v_accvgpr_write_b32 a61, v213
		v_accvgpr_write_b32 a62, v214
		v_accvgpr_write_b32 a63, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a64, v212
		v_accvgpr_write_b32 a65, v213
		v_accvgpr_write_b32 a66, v214
		v_accvgpr_write_b32 a67, v215
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
		v_accvgpr_write_b32 a68, v228
		v_accvgpr_write_b32 a69, v229
		v_accvgpr_write_b32 a70, v230
		v_accvgpr_write_b32 a71, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a72, v228
		v_accvgpr_write_b32 a73, v229
		v_accvgpr_write_b32 a74, v230
		v_accvgpr_write_b32 a75, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a76, v228
		v_accvgpr_write_b32 a77, v229
		v_accvgpr_write_b32 a78, v230
		v_accvgpr_write_b32 a79, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a80, v228
		v_accvgpr_write_b32 a81, v229
		v_accvgpr_write_b32 a82, v230
		v_accvgpr_write_b32 a83, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a84, v228
		v_accvgpr_write_b32 a85, v229
		v_accvgpr_write_b32 a86, v230
		v_accvgpr_write_b32 a87, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a88, v228
		v_accvgpr_write_b32 a89, v229
		v_accvgpr_write_b32 a90, v230
		v_accvgpr_write_b32 a91, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a92, v228
		v_accvgpr_write_b32 a93, v229
		v_accvgpr_write_b32 a94, v230
		v_accvgpr_write_b32 a95, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a96, v228
		v_accvgpr_write_b32 a97, v229
		v_accvgpr_write_b32 a98, v230
		v_accvgpr_write_b32 a99, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a100, v228
		v_accvgpr_write_b32 a101, v229
		v_accvgpr_write_b32 a102, v230
		v_accvgpr_write_b32 a103, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a104, v228
		v_accvgpr_write_b32 a105, v229
		v_accvgpr_write_b32 a106, v230
		v_accvgpr_write_b32 a107, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a108, v228
		v_accvgpr_write_b32 a109, v229
		v_accvgpr_write_b32 a110, v230
		v_accvgpr_write_b32 a111, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a112, v228
		v_accvgpr_write_b32 a113, v229
		v_accvgpr_write_b32 a114, v230
		v_accvgpr_write_b32 a115, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a116, v228
		v_accvgpr_write_b32 a117, v229
		v_accvgpr_write_b32 a118, v230
		v_accvgpr_write_b32 a119, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a120, v228
		v_accvgpr_write_b32 a121, v229
		v_accvgpr_write_b32 a122, v230
		v_accvgpr_write_b32 a123, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a124, v228
		v_accvgpr_write_b32 a125, v229
		v_accvgpr_write_b32 a126, v230
		v_accvgpr_write_b32 a127, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a128, v228
		v_accvgpr_write_b32 a129, v229
		v_accvgpr_write_b32 a130, v230
		v_accvgpr_write_b32 a131, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a132, v228
		v_accvgpr_write_b32 a133, v229
		v_accvgpr_write_b32 a134, v230
		v_accvgpr_write_b32 a135, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a136, v228
		v_accvgpr_write_b32 a137, v229
		v_accvgpr_write_b32 a138, v230
		v_accvgpr_write_b32 a139, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a140, v228
		v_accvgpr_write_b32 a141, v229
		v_accvgpr_write_b32 a142, v230
		v_accvgpr_write_b32 a143, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a144, v228
		v_accvgpr_write_b32 a145, v229
		v_accvgpr_write_b32 a146, v230
		v_accvgpr_write_b32 a147, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a148, v228
		v_accvgpr_write_b32 a149, v229
		v_accvgpr_write_b32 a150, v230
		v_accvgpr_write_b32 a151, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a152, v228
		v_accvgpr_write_b32 a153, v229
		v_accvgpr_write_b32 a154, v230
		v_accvgpr_write_b32 a155, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a156, v228
		v_accvgpr_write_b32 a157, v229
		v_accvgpr_write_b32 a158, v230
		v_accvgpr_write_b32 a159, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a160, v228
		v_accvgpr_write_b32 a161, v229
		v_accvgpr_write_b32 a162, v230
		v_accvgpr_write_b32 a163, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a164, v228
		v_accvgpr_write_b32 a165, v229
		v_accvgpr_write_b32 a166, v230
		v_accvgpr_write_b32 a167, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a168, v228
		v_accvgpr_write_b32 a169, v229
		v_accvgpr_write_b32 a170, v230
		v_accvgpr_write_b32 a171, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a172, v228
		v_accvgpr_write_b32 a173, v229
		v_accvgpr_write_b32 a174, v230
		v_accvgpr_write_b32 a175, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a176, v228
		v_accvgpr_write_b32 a177, v229
		v_accvgpr_write_b32 a178, v230
		v_accvgpr_write_b32 a179, v231
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s16, s46, 2
		s_mul_i32 s17, s16, 0x80
		s_lshl_b32 s19, s17, 0
		s_add_i32 s17, s46, 1
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s21, s46, 1
		s_lshl_b32 s47, s21, 13
		s_add_i32 s21, s47, 0x20000
		v_add3_u32 v22, s21, v8, v15
		ds_read_b64_tr_b8 v[228:229], v22
		ds_read_b64_tr_b8 v[230:231], v22 offset:512
		v_add3_u32 v23, s21, v15, v20
		ds_read_b64_tr_b8 v[232:233], v23 offset:2048
		ds_read_b64_tr_b8 v[234:235], v22 offset:4096
		ds_read_b64_tr_b8 v[236:237], v22 offset:4608
		ds_read_b64_tr_b8 v[238:239], v23 offset:6144
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], v[88:91], v[16:19], v228, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[92:95], v[152:155], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[96:99], v[156:159], v228, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[100:103], v[160:163], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[88:91], v[164:167], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[92:95], v[168:171], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[96:99], v[172:175], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[100:103], v[176:179], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[88:91], v[180:183], v228, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[92:95], v[184:187], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[96:99], v[188:191], v228, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[100:103], v[192:195], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[88:91], v[196:199], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[92:95], v[200:203], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], v[96:99], v[204:207], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], v[100:103], v[208:211], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], v[88:91], v[212:215], v230, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], v[92:95], v[216:219], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], v[96:99], v[220:223], v230, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[100:103], v[224:227], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[44:47], v[88:91], a[84:87], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[44:47], v[92:95], a[88:91], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[44:47], v[96:99], a[92:95], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[100:103], a[96:99], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], v[88:91], a[116:119], v230, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], v[92:95], a[120:123], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], v[96:99], a[124:127], v230, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], v[100:103], a[128:131], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], v[88:91], a[148:151], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], v[92:95], a[152:155], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[52:55], v[96:99], a[156:159], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[100:103], a[160:163], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[56:59], v[120:123], v[16:19], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[56:59], v[124:127], v[152:155], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], v[128:131], v[156:159], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], v[132:135], v[160:163], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[60:63], v[120:123], v[164:167], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[60:63], v[124:127], v[168:171], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[60:63], v[128:131], v[172:175], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], v[132:135], v[176:179], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], v[120:123], v[180:183], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[64:67], v[124:127], v[184:187], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[64:67], v[128:131], v[188:191], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[64:67], v[132:135], v[192:195], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], v[120:123], v[196:199], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[68:71], v[124:127], v[200:203], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], v[128:131], v[204:207], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[68:71], v[132:135], v[208:211], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[72:75], v[120:123], v[212:215], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[72:75], v[124:127], v[216:219], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[72:75], v[128:131], v[220:223], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[72:75], v[132:135], v[224:227], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[76:79], v[120:123], a[84:87], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[76:79], v[124:127], a[88:91], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[76:79], v[128:131], a[92:95], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[76:79], v[132:135], a[96:99], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[80:83], v[120:123], a[116:119], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[80:83], v[124:127], a[120:123], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[128:131], a[124:127], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[80:83], v[132:135], a[128:131], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[84:87], v[120:123], a[148:151], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], v[124:127], a[152:155], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[128:131], a[156:159], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[84:87], v[132:135], a[160:163], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[232:233], v23 offset:2560
		ds_read_b64_tr_b8 v[238:239], v23 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s21, s16, 2
		s_add_i32 s47, s21, 1
		s_lshl_b32 s51, s21, 14
		s_add_i32 s21, s20, s51
		s_lshl_b32 s64, s47, 14
		s_add_i32 s47, s20, s64
		s_and_b32 s65, s16, 1
		s_lshl_b32 s16, s65, 13
		s_add_i32 s66, s16, 0x20000
		v_add_u32_e32 v22, s66, v8
		s_add_i32 s66, s16, 0x20200
		v_add_u32_e32 v23, s66, v8
		s_add_i32 s66, s16, 0x21000
		v_add_u32_e32 v229, s66, v8
		s_add_i32 s66, s16, 0x21200
		v_add_u32_e32 v231, s66, v8
		s_and_saveexec_b64 s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v235, v10, s[56:59], s21 offen
		buffer_load_dword v240, v10, s[56:59], s21 offen offset:64
		buffer_load_dword v242, v10, s[56:59], s47 offen
		buffer_load_dword v244, v10, s[56:59], s47 offen offset:64
		v_add3_u32 v237, v22, v14, v13
		v_add3_u32 v241, v23, v14, v13
		v_add3_u32 v243, v229, v14, v13
		v_add3_u32 v245, v231, v14, v13
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s21, s50, s51
		s_add_i32 s47, s50, s64
		s_add_i32 s51, s16, 0x20800
		v_add_u32_e32 v22, s51, v14
		s_add_i32 s51, s16, 0x20a00
		v_add_u32_e32 v23, s51, v14
		s_add_i32 s51, s16, 0x21800
		v_add_u32_e32 v229, s51, v14
		s_add_i32 s51, s16, 0x21a00
		v_add_u32_e32 v231, s51, v14
		s_and_saveexec_b64 s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v246, v11, s[52:55], s21 offen
		buffer_load_dword v248, v11, s[52:55], s21 offen offset:64
		buffer_load_dword v250, v11, s[52:55], s47 offen
		buffer_load_dword v252, v11, s[52:55], s47 offen offset:64
		v_add3_u32 v247, v22, v13, v20
		v_add3_u32 v249, v23, v13, v20
		v_add3_u32 v251, v229, v13, v20
		v_add3_u32 v253, v231, v13, v20
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[68:69]
		s_lshl_b32 s16, s65, 16
		s_add_i32 s21, s18, s16
		s_mov_b32 m0, s21
		v_readfirstlane_b32 s16, v2
		s_add_i32 s47, s16, s19
		v_add_u32_e32 v22, s47, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		s_add_i32 m0, s21, 0x1000
		v_readfirstlane_b32 s16, v3
		s_add_i32 s47, s16, s19
		v_add_u32_e32 v22, s47, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[24:27], v[104:107], a[4:7], v228, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[24:27], v[108:111], a[8:11], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[24:27], v[112:115], a[12:15], v228, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[24:27], v[116:119], a[16:19], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x2000
		s_add_i32 s16, s23, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], v[104:107], a[20:23], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], v[108:111], a[24:27], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], v[112:115], a[28:31], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], v[116:119], a[32:35], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], v[104:107], a[36:39], v228, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], v[108:111], a[40:43], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x3000
		s_add_i32 s16, s26, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[112:115], a[44:47], v228, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], v[116:119], a[48:51], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], v[104:107], a[52:55], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], v[108:111], a[56:59], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], v[112:115], a[60:63], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], v[116:119], a[64:67], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x4000
		s_add_i32 s16, s27, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[40:43], v[104:107], a[68:71], v230, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[40:43], v[108:111], a[72:75], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[40:43], v[112:115], a[76:79], v230, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[40:43], v[116:119], a[80:83], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], v[104:107], a[100:103], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[108:111], a[104:107], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x5000
		s_add_i32 s16, s32, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[44:47], v[112:115], a[108:111], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[116:119], a[112:115], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[104:107], a[132:135], v230, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[108:111], a[136:139], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], v[112:115], a[140:143], v230, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[116:119], a[144:147], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x6000
		s_add_i32 s16, s33, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], v[104:107], a[164:167], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[108:111], a[168:171], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[52:55], v[112:115], a[172:175], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[116:119], a[176:179], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[56:59], v[136:139], a[4:7], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[56:59], v[140:143], a[8:11], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x7000
		s_add_i32 s16, s34, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[56:59], v[144:147], a[12:15], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[56:59], v[148:151], a[16:19], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[60:63], v[136:139], a[20:23], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[60:63], v[140:143], a[24:27], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[60:63], v[144:147], a[28:31], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[60:63], v[148:151], a[32:35], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0x8000
		s_add_i32 s16, s22, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[64:67], v[136:139], a[36:39], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[64:67], v[140:143], a[40:43], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[64:67], v[144:147], a[44:47], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[64:67], v[148:151], a[48:51], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[68:71], v[136:139], a[52:55], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[68:71], v[140:143], a[56:59], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0xa000
		s_add_i32 s16, s40, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[68:71], v[144:147], a[60:63], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[68:71], v[148:151], a[64:67], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[72:75], v[136:139], a[68:71], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[72:75], v[140:143], a[72:75], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[72:75], v[144:147], a[76:79], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[72:75], v[148:151], a[80:83], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0xc000
		s_add_i32 s16, s42, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[76:79], v[136:139], a[100:103], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], v[140:143], a[104:107], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[76:79], v[144:147], a[108:111], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[148:151], a[112:115], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], v[136:139], a[132:135], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], v[140:143], a[136:139], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s21, 0xe000
		s_add_i32 s16, s44, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[144:147], a[140:143], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[148:151], a[144:147], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[84:87], v[136:139], a[164:167], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], v[140:143], a[168:171], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[144:147], a[172:175], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[84:87], v[148:151], a[176:179], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v237, v235
		ds_write_b32 v241, v240
		ds_write_b32 v243, v242
		ds_write_b32 v245, v244
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[68:69], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[68:69]
		s_and_saveexec_b64 s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v247, v246
		ds_write_b32 v249, v248
		ds_write_b32 v251, v250
		ds_write_b32 v253, v252
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[68:69], s[24:25]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[68:69]
		s_add_i32 m0, s21, 0x9000
		s_add_i32 s16, s35, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 m0, s21, 0xb000
		s_add_i32 s16, s41, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 m0, s21, 0xd000
		s_add_i32 s16, s43, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_add_i32 m0, s21, 0xf000
		s_add_i32 s16, s45, s19
		v_add_u32_e32 v22, s16, v5
		buffer_load_dwordx4 v22, s[36:39], 0 offen lds
		s_waitcnt vmcnt(24)
		s_barrier
		s_and_b32 s16, s17, 1
		s_lshl_b32 s19, s16, 16
		v_add_u32_e32 v22, s19, v12
		v_add3_u32 v23, v22, v6, v7
		ds_read_b128 v[24:27], v23
		ds_read_b128 v[28:31], v23 offset:1024
		ds_read_b128 v[32:35], v23 offset:2048
		ds_read_b128 v[36:39], v23 offset:3072
		ds_read_b128 v[40:43], v23 offset:4096
		ds_read_b128 v[44:47], v23 offset:5120
		ds_read_b128 v[48:51], v23 offset:6144
		ds_read_b128 v[52:55], v23 offset:7168
		ds_read_b128 v[56:59], v23 offset:16384
		ds_read_b128 v[60:63], v23 offset:17408
		ds_read_b128 v[64:67], v23 offset:18432
		ds_read_b128 v[68:71], v23 offset:19456
		ds_read_b128 v[72:75], v23 offset:20480
		ds_read_b128 v[76:79], v23 offset:21504
		ds_read_b128 v[80:83], v23 offset:22528
		ds_read_b128 v[84:87], v23 offset:23552
		v_add_u32_e32 v22, s19, v6
		v_add3_u32 v23, v22, v9, v7
		ds_read_b128 v[88:91], v23 offset:32768
		ds_read_b128 v[92:95], v23 offset:33792
		ds_read_b128 v[96:99], v23 offset:34816
		ds_read_b128 v[100:103], v23 offset:35840
		ds_read_b128 v[104:107], v23 offset:36864
		ds_read_b128 v[108:111], v23 offset:37888
		ds_read_b128 v[112:115], v23 offset:38912
		ds_read_b128 v[116:119], v23 offset:39936
		ds_read_b128 v[120:123], v23 offset:49152
		ds_read_b128 v[124:127], v23 offset:50176
		ds_read_b128 v[128:131], v23 offset:51200
		ds_read_b128 v[132:135], v23 offset:52224
		ds_read_b128 v[136:139], v23 offset:53248
		ds_read_b128 v[140:143], v23 offset:54272
		ds_read_b128 v[144:147], v23 offset:55296
		ds_read_b128 v[148:151], v23 offset:56320
		s_cmp_lt_i32 s17, 30
		s_mov_b32 s46, s17
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v2, a0
		v_add_u32_e32 v3, v2, v15
		ds_read_b64_tr_b8 v[10:11], v3
		ds_read_b64_tr_b8 v[22:23], v3 offset:512
		v_add_u32_e32 v2, 0x20000, v15
		v_lshl_add_u32 v5, v21, 10, v2
		ds_read_b64_tr_b8 v[20:21], v5 offset:2048
		ds_read_b64_tr_b8 v[228:229], v5 offset:2560
		ds_read_b64_tr_b8 v[230:231], v3 offset:4096
		ds_read_b64_tr_b8 v[232:233], v3 offset:4608
		ds_read_b64_tr_b8 v[234:235], v5 offset:6144
		ds_read_b64_tr_b8 v[236:237], v5 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], v[88:91], v[16:19], v10, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[92:95], v[152:155], v10, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[96:99], v[156:159], v10, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[100:103], v[160:163], v10, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[24:27], v[104:107], a[4:7], v10, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[24:27], v[108:111], a[8:11], v10, v228 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[24:27], v[112:115], a[12:15], v10, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[24:27], v[116:119], a[16:19], v10, v228 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[88:91], v[164:167], v10, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[92:95], v[168:171], v10, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[96:99], v[172:175], v10, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[100:103], v[176:179], v10, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], v[104:107], a[20:23], v10, v228 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], v[108:111], a[24:27], v10, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], v[112:115], a[28:31], v10, v228 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], v[116:119], a[32:35], v10, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[88:91], v[180:183], v10, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[92:95], v[184:187], v10, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[96:99], v[188:191], v10, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[100:103], v[192:195], v10, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], v[104:107], a[36:39], v10, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], v[108:111], a[40:43], v10, v228 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[112:115], a[44:47], v10, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], v[116:119], a[48:51], v10, v228 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[88:91], v[196:199], v10, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[92:95], v[200:203], v10, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], v[96:99], v[204:207], v10, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], v[100:103], v[208:211], v10, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], v[104:107], a[52:55], v10, v228 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], v[108:111], a[56:59], v10, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], v[112:115], a[60:63], v10, v228 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], v[116:119], a[64:67], v10, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], v[88:91], v[212:215], v22, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], v[92:95], v[216:219], v22, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], v[96:99], v[220:223], v22, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[100:103], v[224:227], v22, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[40:43], v[104:107], a[68:71], v22, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[40:43], v[108:111], a[72:75], v22, v228 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[40:43], v[112:115], a[76:79], v22, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[40:43], v[116:119], a[80:83], v22, v228 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[44:47], v[88:91], a[84:87], v22, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[44:47], v[92:95], a[88:91], v22, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[44:47], v[96:99], a[92:95], v22, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[100:103], a[96:99], v22, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], v[104:107], a[100:103], v22, v228 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[108:111], a[104:107], v22, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[44:47], v[112:115], a[108:111], v22, v228 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[116:119], a[112:115], v22, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[48:51], v[88:91], a[116:119], v22, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], v[92:95], a[120:123], v22, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], v[96:99], a[124:127], v22, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], v[100:103], a[128:131], v22, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[104:107], a[132:135], v22, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[108:111], a[136:139], v22, v228 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], v[112:115], a[140:143], v22, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[116:119], a[144:147], v22, v228 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[52:55], v[88:91], a[148:151], v22, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], v[92:95], a[152:155], v22, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[52:55], v[96:99], a[156:159], v22, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[100:103], a[160:163], v22, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], v[104:107], a[164:167], v22, v228 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[108:111], a[168:171], v22, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[52:55], v[112:115], a[172:175], v22, v228 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[116:119], a[176:179], v22, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[56:59], v[120:123], v[16:19], v230, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[56:59], v[124:127], v[152:155], v230, v234 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[56:59], v[128:131], v[156:159], v230, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[56:59], v[132:135], v[160:163], v230, v234 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[56:59], v[136:139], a[4:7], v230, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[56:59], v[140:143], a[8:11], v230, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[56:59], v[144:147], a[12:15], v230, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[56:59], v[148:151], a[16:19], v230, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[60:63], v[120:123], v[164:167], v230, v234 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[60:63], v[124:127], v[168:171], v230, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[60:63], v[128:131], v[172:175], v230, v234 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[60:63], v[132:135], v[176:179], v230, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[60:63], v[136:139], a[20:23], v230, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[60:63], v[140:143], a[24:27], v230, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[60:63], v[144:147], a[28:31], v230, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[60:63], v[148:151], a[32:35], v230, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[64:67], v[120:123], v[180:183], v230, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[64:67], v[124:127], v[184:187], v230, v234 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[64:67], v[128:131], v[188:191], v230, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[64:67], v[132:135], v[192:195], v230, v234 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[64:67], v[136:139], a[36:39], v230, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[64:67], v[140:143], a[40:43], v230, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[64:67], v[144:147], a[44:47], v230, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[64:67], v[148:151], a[48:51], v230, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[68:71], v[120:123], v[196:199], v230, v234 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[68:71], v[124:127], v[200:203], v230, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[68:71], v[128:131], v[204:207], v230, v234 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[68:71], v[132:135], v[208:211], v230, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[68:71], v[136:139], a[52:55], v230, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[68:71], v[140:143], a[56:59], v230, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[68:71], v[144:147], a[60:63], v230, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[68:71], v[148:151], a[64:67], v230, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[72:75], v[120:123], v[212:215], v232, v234 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[72:75], v[124:127], v[216:219], v232, v234 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[72:75], v[128:131], v[220:223], v232, v234 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[72:75], v[132:135], v[224:227], v232, v234 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[72:75], v[136:139], a[68:71], v232, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[72:75], v[140:143], a[72:75], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[72:75], v[144:147], a[76:79], v232, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[72:75], v[148:151], a[80:83], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[76:79], v[120:123], a[84:87], v232, v234 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[76:79], v[124:127], a[88:91], v232, v234 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[76:79], v[128:131], a[92:95], v232, v234 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[76:79], v[132:135], a[96:99], v232, v234 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[76:79], v[136:139], a[100:103], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], v[140:143], a[104:107], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[76:79], v[144:147], a[108:111], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[148:151], a[112:115], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[80:83], v[120:123], a[116:119], v232, v234 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[80:83], v[124:127], a[120:123], v232, v234 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[128:131], a[124:127], v232, v234 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[80:83], v[132:135], a[128:131], v232, v234 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], v[136:139], a[132:135], v232, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], v[140:143], a[136:139], v232, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[144:147], a[140:143], v232, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[148:151], a[144:147], v232, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[84:87], v[120:123], a[148:151], v232, v234 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], v[124:127], a[152:155], v232, v234 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[128:131], a[156:159], v232, v234 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[84:87], v[132:135], a[160:163], v232, v234 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[84:87], v[136:139], a[164:167], v232, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], v[140:143], a[168:171], v232, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[144:147], a[172:175], v232, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[84:87], v[148:151], a[176:179], v232, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v12
		v_add3_u32 v8, v2, v6, v7
		ds_read_b128 v[20:23], v8
		ds_read_b128 v[24:27], v8 offset:1024
		ds_read_b128 v[28:31], v8 offset:2048
		ds_read_b128 v[32:35], v8 offset:3072
		ds_read_b128 v[36:39], v8 offset:4096
		ds_read_b128 v[40:43], v8 offset:5120
		ds_read_b128 v[44:47], v8 offset:6144
		ds_read_b128 v[48:51], v8 offset:7168
		ds_read_b128 v[52:55], v8 offset:16384
		ds_read_b128 v[56:59], v8 offset:17408
		ds_read_b128 v[60:63], v8 offset:18432
		ds_read_b128 v[64:67], v8 offset:19456
		ds_read_b128 v[68:71], v8 offset:20480
		ds_read_b128 v[72:75], v8 offset:21504
		ds_read_b128 v[76:79], v8 offset:22528
		ds_read_b128 v[80:83], v8 offset:23552
		v_add_u32_e32 v2, 0x10000, v6
		v_add3_u32 v6, v2, v9, v7
		ds_read_b128 v[8:11], v6 offset:32768
		ds_read_b128 v[84:87], v6 offset:33792
		ds_read_b128 v[88:91], v6 offset:34816
		ds_read_b128 v[92:95], v6 offset:35840
		ds_read_b128 v[96:99], v6 offset:36864
		ds_read_b128 v[100:103], v6 offset:37888
		ds_read_b128 v[104:107], v6 offset:38912
		ds_read_b128 v[108:111], v6 offset:39936
		ds_read_b128 v[112:115], v6 offset:49152
		ds_read_b128 v[116:119], v6 offset:50176
		ds_read_b128 v[120:123], v6 offset:51200
		ds_read_b128 v[124:127], v6 offset:52224
		ds_read_b128 v[128:131], v6 offset:53248
		ds_read_b128 v[132:135], v6 offset:54272
		ds_read_b128 v[136:139], v6 offset:55296
		ds_read_b128 v[140:143], v6 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v3 offset:8192
		ds_read_b64_tr_b8 v[12:13], v3 offset:8704
		ds_read_b64_tr_b8 v[144:145], v5 offset:10240
		ds_read_b64_tr_b8 v[146:147], v5 offset:10752
		ds_read_b64_tr_b8 v[148:149], v3 offset:12288
		ds_read_b64_tr_b8 v[150:151], v3 offset:12800
		ds_read_b64_tr_b8 v[2:3], v5 offset:14336
		ds_read_b64_tr_b8 v[228:229], v5 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[8:11], v[16:19], v6, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[84:87], v[152:155], v6, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[88:91], v[156:159], v6, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[92:95], v[160:163], v6, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[8:11], v[164:167], v6, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[84:87], v[168:171], v6, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[88:91], v[172:175], v6, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[92:95], v[176:179], v6, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[8:11], v[180:183], v6, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[84:87], v[184:187], v6, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[88:91], v[188:191], v6, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[92:95], v[192:195], v6, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[8:11], v[196:199], v6, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[84:87], v[200:203], v6, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[88:91], v[204:207], v6, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[92:95], v[208:211], v6, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[8:11], v[212:215], v12, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[84:87], v[216:219], v12, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], v[88:91], v[220:223], v12, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[92:95], v[224:227], v12, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[8:11], a[84:87], v12, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], v[84:87], a[88:91], v12, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], v[88:91], a[92:95], v12, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], v[92:95], a[96:99], v12, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[8:11], a[116:119], v12, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], v[84:87], a[120:123], v12, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], v[88:91], a[124:127], v12, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], v[92:95], a[128:131], v12, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[8:11], a[148:151], v12, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], v[84:87], a[152:155], v12, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], v[88:91], a[156:159], v12, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], v[92:95], a[160:163], v12, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[112:115], v[16:19], v148, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[52:55], v[116:119], v[152:155], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[52:55], v[120:123], v[156:159], v148, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[52:55], v[124:127], v[160:163], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[56:59], v[112:115], v[164:167], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], v[116:119], v[168:171], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], v[120:123], v[172:175], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[124:127], v[176:179], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[60:63], v[112:115], v[180:183], v148, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], v[116:119], v[184:187], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[60:63], v[120:123], v[188:191], v148, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], v[124:127], v[192:195], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], v[112:115], v[196:199], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[64:67], v[116:119], v[200:203], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], v[120:123], v[204:207], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[124:127], v[208:211], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], v[112:115], v[212:215], v150, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], v[116:119], v[216:219], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], v[120:123], v[220:223], v150, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], v[124:127], v[224:227], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[72:75], v[112:115], a[84:87], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[72:75], v[116:119], a[88:91], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[72:75], v[120:123], a[92:95], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[72:75], v[124:127], a[96:99], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[112:115], a[116:119], v150, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], v[116:119], a[120:123], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[76:79], v[120:123], a[124:127], v150, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], v[124:127], a[128:131], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], v[112:115], a[148:151], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], v[116:119], a[152:155], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], v[120:123], a[156:159], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[80:83], v[124:127], a[160:163], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		v_lshlrev_b32_e32 v5, 15, v4
		v_add_u32_e32 v4, v5, v15
		ds_write_b64 v4, v[2:3]
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		ds_write_b64 v4, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		ds_write_b64 v4, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		ds_write_b64 v4, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		ds_write_b64 v4, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v4, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v4, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v4, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v4, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v4, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v4, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v4, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v4, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v4, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v4, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v4, v[2:3] offset:13824
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v4, v[2:3] offset:16384
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v4, v[2:3] offset:16896
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v4, v[2:3] offset:17408
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v4, v[2:3] offset:17920
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v3, a85
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v3, a87
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:20480
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:20992
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:21504
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:22016
		v_accvgpr_read_b32 v2, a116
		v_accvgpr_read_b32 v3, a117
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a118
		v_accvgpr_read_b32 v3, a119
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:24576
		v_accvgpr_read_b32 v2, a120
		v_accvgpr_read_b32 v3, a121
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a122
		v_accvgpr_read_b32 v3, a123
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:25088
		v_accvgpr_read_b32 v2, a124
		v_accvgpr_read_b32 v3, a125
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a126
		v_accvgpr_read_b32 v3, a127
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:25600
		v_accvgpr_read_b32 v2, a128
		v_accvgpr_read_b32 v3, a129
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a130
		v_accvgpr_read_b32 v3, a131
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:26112
		v_accvgpr_read_b32 v2, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:28672
		v_accvgpr_read_b32 v2, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:29184
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:29696
		v_accvgpr_read_b32 v2, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_f16_f32 v8, v2, v3
		v_accvgpr_read_b32 v2, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_f16_f32 v9, v2, v3
		ds_write_b64 v4, v[8:9] offset:30208
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v2, 63, v0
		s_mov_b32 s16, 32
		v_cmp_lt_u32_e64 vcc, v2, s16
		s_mov_b64 s[18:19], vcc
		v_lshl_add_u32 v2, v1, 4, v5
		s_mov_b32 s16, 0x1000
		s_mov_b32 s17, 0x2000
		s_mov_b32 s20, 0x3000
		s_mov_b32 s21, 0x4000
		s_mov_b32 s22, 0x5000
		s_mov_b32 s23, 0x6000
		s_mov_b32 s24, 0x7000
		s_and_saveexec_b64 s[68:69], s[18:19]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[8:11], v2
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], 0 offen
		ds_read_b128 v[8:11], v2 offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], 0 offen offset:512
		ds_read_b128 v[8:11], v2 offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], 0 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], 0 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s16 offen
		ds_read_b128 v[8:11], v2 offset:4608
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s16 offen offset:512
		ds_read_b128 v[8:11], v2 offset:5120
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s16 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:5632
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s16 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s17 offen
		ds_read_b128 v[8:11], v2 offset:8704
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s17 offen offset:512
		ds_read_b128 v[8:11], v2 offset:9216
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s17 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:9728
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s17 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s20 offen
		ds_read_b128 v[8:11], v2 offset:12800
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s20 offen offset:512
		ds_read_b128 v[8:11], v2 offset:13312
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s20 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:13824
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s20 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s21 offen
		ds_read_b128 v[8:11], v2 offset:16896
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s21 offen offset:512
		ds_read_b128 v[8:11], v2 offset:17408
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s21 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:17920
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s21 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s22 offen
		ds_read_b128 v[8:11], v2 offset:20992
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s22 offen offset:512
		ds_read_b128 v[8:11], v2 offset:21504
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s22 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:22016
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s22 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:24576
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s23 offen
		ds_read_b128 v[8:11], v2 offset:25088
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s23 offen offset:512
		ds_read_b128 v[8:11], v2 offset:25600
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s23 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:26112
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s23 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:28672
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s24 offen
		ds_read_b128 v[8:11], v2 offset:29184
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s24 offen offset:512
		ds_read_b128 v[8:11], v2 offset:29696
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s24 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:30208
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], s24 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[68:69]
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[96:99], a[4:7], v6, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[100:103], a[8:11], v6, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[104:107], a[12:15], v6, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[108:111], a[16:19], v6, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[24:27], v[96:99], a[20:23], v6, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[24:27], v[100:103], a[24:27], v6, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[24:27], v[104:107], a[28:31], v6, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[108:111], a[32:35], v6, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], v[96:99], a[36:39], v6, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], v[100:103], a[40:43], v6, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], v[104:107], a[44:47], v6, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], v[108:111], a[48:51], v6, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], v[96:99], a[52:55], v6, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], v[100:103], a[56:59], v6, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], v[104:107], a[60:63], v6, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], v[108:111], a[64:67], v6, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], v[96:99], a[68:71], v12, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], v[100:103], a[72:75], v12, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[104:107], a[76:79], v12, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], v[108:111], a[80:83], v12, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[96:99], a[100:103], v12, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[100:103], a[104:107], v12, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[104:107], a[108:111], v12, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], v[108:111], a[112:115], v12, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], v[96:99], a[132:135], v12, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[100:103], a[136:139], v12, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[104:107], a[140:143], v12, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], v[108:111], a[144:147], v12, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[96:99], a[164:167], v12, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[100:103], a[168:171], v12, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], v[104:107], a[172:175], v12, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], v[108:111], a[176:179], v12, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[52:55], v[128:131], a[4:7], v148, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v3, a5
		v_cvt_pk_f16_f32 v6, v1, v3
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v3, a7
		v_cvt_pk_f16_f32 v7, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[52:55], v[132:135], a[8:11], v148, v228 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v3, a9
		v_cvt_pk_f16_f32 v8, v1, v3
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v3, a11
		v_cvt_pk_f16_f32 v9, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[52:55], v[136:139], a[12:15], v148, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v3, a13
		v_cvt_pk_f16_f32 v10, v1, v3
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v3, a15
		v_cvt_pk_f16_f32 v11, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[52:55], v[140:143], a[16:19], v148, v228 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v3, a17
		v_cvt_pk_f16_f32 v12, v1, v3
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v3, a19
		v_cvt_pk_f16_f32 v13, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[56:59], v[128:131], a[20:23], v148, v228 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v3, a21
		v_cvt_pk_f16_f32 v14, v1, v3
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v3, a23
		v_cvt_pk_f16_f32 v15, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[56:59], v[132:135], a[24:27], v148, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v3, a25
		v_cvt_pk_f16_f32 v16, v1, v3
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v3, a27
		v_cvt_pk_f16_f32 v17, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[56:59], v[136:139], a[28:31], v148, v228 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v3, a29
		v_cvt_pk_f16_f32 v18, v1, v3
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v3, a31
		v_cvt_pk_f16_f32 v19, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[56:59], v[140:143], a[32:35], v148, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v3, a33
		v_cvt_pk_f16_f32 v20, v1, v3
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v3, a35
		v_cvt_pk_f16_f32 v21, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[60:63], v[128:131], a[36:39], v148, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v3, a37
		v_cvt_pk_f16_f32 v22, v1, v3
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v3, a39
		v_cvt_pk_f16_f32 v23, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[60:63], v[132:135], a[40:43], v148, v228 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v3, a41
		v_cvt_pk_f16_f32 v24, v1, v3
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v3, a43
		v_cvt_pk_f16_f32 v25, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[60:63], v[136:139], a[44:47], v148, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v3, a45
		v_cvt_pk_f16_f32 v26, v1, v3
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v3, a47
		v_cvt_pk_f16_f32 v27, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[60:63], v[140:143], a[48:51], v148, v228 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v3, a49
		v_cvt_pk_f16_f32 v28, v1, v3
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v3, a51
		v_cvt_pk_f16_f32 v29, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[64:67], v[128:131], a[52:55], v148, v228 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v3, a53
		v_cvt_pk_f16_f32 v30, v1, v3
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v3, a55
		v_cvt_pk_f16_f32 v31, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[64:67], v[132:135], a[56:59], v148, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v3, a57
		v_cvt_pk_f16_f32 v32, v1, v3
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v3, a59
		v_cvt_pk_f16_f32 v33, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[64:67], v[136:139], a[60:63], v148, v228 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v3, a61
		v_cvt_pk_f16_f32 v34, v1, v3
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v3, a63
		v_cvt_pk_f16_f32 v35, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[64:67], v[140:143], a[64:67], v148, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v3, a65
		v_cvt_pk_f16_f32 v36, v1, v3
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v3, a67
		v_cvt_pk_f16_f32 v37, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[68:71], v[128:131], a[68:71], v150, v228 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v3, a69
		v_cvt_pk_f16_f32 v38, v1, v3
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v3, a71
		v_cvt_pk_f16_f32 v39, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[68:71], v[132:135], a[72:75], v150, v228 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v3, a73
		v_cvt_pk_f16_f32 v40, v1, v3
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v3, a75
		v_cvt_pk_f16_f32 v41, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[68:71], v[136:139], a[76:79], v150, v228 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v3, a77
		v_cvt_pk_f16_f32 v42, v1, v3
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v3, a79
		v_cvt_pk_f16_f32 v43, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[68:71], v[140:143], a[80:83], v150, v228 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_f16_f32 v44, v1, v3
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_f16_f32 v45, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[72:75], v[128:131], a[100:103], v150, v228 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v3, a101
		v_cvt_pk_f16_f32 v46, v1, v3
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v3, a103
		v_cvt_pk_f16_f32 v47, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], v[132:135], a[104:107], v150, v228 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v3, a105
		v_cvt_pk_f16_f32 v48, v1, v3
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v3, a107
		v_cvt_pk_f16_f32 v49, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[72:75], v[136:139], a[108:111], v150, v228 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v3, a109
		v_cvt_pk_f16_f32 v50, v1, v3
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v3, a111
		v_cvt_pk_f16_f32 v51, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[72:75], v[140:143], a[112:115], v150, v228 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v3, a113
		v_cvt_pk_f16_f32 v52, v1, v3
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v3, a115
		v_cvt_pk_f16_f32 v53, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[128:131], a[132:135], v150, v228 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_f16_f32 v54, v1, v3
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_f16_f32 v55, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[132:135], a[136:139], v150, v228 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v3, a137
		v_cvt_pk_f16_f32 v56, v1, v3
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v3, a139
		v_cvt_pk_f16_f32 v57, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[136:139], a[140:143], v150, v228 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v3, a141
		v_cvt_pk_f16_f32 v58, v1, v3
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v3, a143
		v_cvt_pk_f16_f32 v59, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], v[140:143], a[144:147], v150, v228 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_f16_f32 v60, v1, v3
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_f16_f32 v61, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], v[128:131], a[164:167], v150, v228 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_f16_f32 v62, v1, v3
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_f16_f32 v63, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], v[132:135], a[168:171], v150, v228 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v3, a169
		v_cvt_pk_f16_f32 v64, v1, v3
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v3, a171
		v_cvt_pk_f16_f32 v65, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[136:139], a[172:175], v150, v228 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v3, a173
		v_cvt_pk_f16_f32 v66, v1, v3
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v3, a175
		v_cvt_pk_f16_f32 v67, v1, v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[80:83], v[140:143], a[176:179], v150, v228 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_nop 7
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v3, a177
		v_cvt_pk_f16_f32 v68, v1, v3
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v3, a179
		v_cvt_pk_f16_f32 v69, v1, v3
		ds_write_b64 v4, v[6:7] offset:2048
		ds_write_b64 v4, v[8:9] offset:2560
		ds_write_b64 v4, v[10:11] offset:3072
		ds_write_b64 v4, v[12:13] offset:3584
		ds_write_b64 v4, v[14:15] offset:6144
		ds_write_b64 v4, v[16:17] offset:6656
		ds_write_b64 v4, v[18:19] offset:7168
		ds_write_b64 v4, v[20:21] offset:7680
		ds_write_b64 v4, v[22:23] offset:10240
		ds_write_b64 v4, v[24:25] offset:10752
		ds_write_b64 v4, v[26:27] offset:11264
		ds_write_b64 v4, v[28:29] offset:11776
		ds_write_b64 v4, v[30:31] offset:14336
		ds_write_b64 v4, v[32:33] offset:14848
		ds_write_b64 v4, v[34:35] offset:15360
		ds_write_b64 v4, v[36:37] offset:15872
		ds_write_b64 v4, v[38:39] offset:18432
		ds_write_b64 v4, v[40:41] offset:18944
		ds_write_b64 v4, v[42:43] offset:19456
		ds_write_b64 v4, v[44:45] offset:19968
		ds_write_b64 v4, v[46:47] offset:22528
		ds_write_b64 v4, v[48:49] offset:23040
		ds_write_b64 v4, v[50:51] offset:23552
		ds_write_b64 v4, v[52:53] offset:24064
		ds_write_b64 v4, v[54:55] offset:26624
		ds_write_b64 v4, v[56:57] offset:27136
		ds_write_b64 v4, v[58:59] offset:27648
		ds_write_b64 v4, v[60:61] offset:28160
		ds_write_b64 v4, v[62:63] offset:30720
		ds_write_b64 v4, v[64:65] offset:31232
		ds_write_b64 v4, v[66:67] offset:31744
		ds_write_b64 v4, v[68:69] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[68:69], s[18:19]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		ds_read_b128 v[4:7], v2 offset:2048
		ds_read_b128 v[8:11], v2 offset:2560
		ds_read_b128 v[12:15], v2 offset:3072
		ds_read_b128 v[16:19], v2 offset:3584
		ds_read_b128 v[20:23], v2 offset:6144
		ds_read_b128 v[24:27], v2 offset:6656
		ds_read_b128 v[28:31], v2 offset:7168
		ds_read_b128 v[32:35], v2 offset:7680
		ds_read_b128 v[36:39], v2 offset:10240
		ds_read_b128 v[40:43], v2 offset:10752
		ds_read_b128 v[44:47], v2 offset:11264
		ds_read_b128 v[48:51], v2 offset:11776
		ds_read_b128 v[52:55], v2 offset:14336
		ds_read_b128 v[56:59], v2 offset:14848
		ds_read_b128 v[60:63], v2 offset:15360
		ds_read_b128 v[64:67], v2 offset:15872
		ds_read_b128 v[68:71], v2 offset:18432
		ds_read_b128 v[72:75], v2 offset:18944
		ds_read_b128 v[76:79], v2 offset:19456
		ds_read_b128 v[80:83], v2 offset:19968
		ds_read_b128 v[84:87], v2 offset:22528
		ds_read_b128 v[88:91], v2 offset:23040
		ds_read_b128 v[92:95], v2 offset:23552
		ds_read_b128 v[96:99], v2 offset:24064
		ds_read_b128 v[100:103], v2 offset:26624
		ds_read_b128 v[104:107], v2 offset:27136
		ds_read_b128 v[108:111], v2 offset:27648
		ds_read_b128 v[112:115], v2 offset:28160
		ds_read_b128 v[116:119], v2 offset:30720
		ds_read_b128 v[120:123], v2 offset:31232
		ds_read_b128 v[124:127], v2 offset:31744
		ds_read_b128 v[128:131], v2 offset:32256
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		buffer_store_dwordx4 v[4:7], v2, s[60:63], 0 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[8:11], v2, s[60:63], 0 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[12:15], v2, s[60:63], 0 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[16:19], v2, s[60:63], 0 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[20:23], v2, s[60:63], s16 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[24:27], v2, s[60:63], s16 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[28:31], v2, s[60:63], s16 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[32:35], v2, s[60:63], s16 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[36:39], v2, s[60:63], s17 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[40:43], v2, s[60:63], s17 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[44:47], v2, s[60:63], s17 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[48:51], v2, s[60:63], s17 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[52:55], v2, s[60:63], s20 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[56:59], v2, s[60:63], s20 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[60:63], v2, s[60:63], s20 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[64:67], v2, s[60:63], s20 offen offset:3584
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		buffer_store_dwordx4 v[68:71], v2, s[60:63], s21 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[72:75], v2, s[60:63], s21 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[76:79], v2, s[60:63], s21 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[80:83], v2, s[60:63], s21 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[84:87], v2, s[60:63], s22 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[88:91], v2, s[60:63], s22 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[92:95], v2, s[60:63], s22 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[96:99], v2, s[60:63], s22 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[100:103], v2, s[60:63], s23 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[104:107], v2, s[60:63], s23 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[108:111], v2, s[60:63], s23 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[112:115], v2, s[60:63], s23 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[116:119], v2, s[60:63], s24 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[120:123], v2, s[60:63], s24 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[124:127], v2, s[60:63], s24 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[128:131], v2, s[60:63], s24 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[68:69]
		s_waitcnt vmcnt(0)
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
		.amdhsa_next_free_vgpr 436
		.amdhsa_next_free_sgpr 70
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 254
	.set .Lwmma_f16_matmul_tiled.num_agpr, 180
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 70
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
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     70
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     436
    .agpr_count:     180
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
