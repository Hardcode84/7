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
		s_mov_b32 s18, 0x80000000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s16, s10
		s_mov_b32 s17, s11
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_mov_b32 s0, 0x1000000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s10, s0
		s_mov_b32 s11, s19
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s0
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		s_lshl_b32 s1, s0, 10
		s_mov_b32 m0, s1
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 12, v2
		v_lshl_add_u32 v2, s0, 16, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_and_b32 s0, s13, 7
		s_lshr_b32 s12, s0, 1
		s_lshl_b32 s15, s12, 22
		s_lshl_b32 s14, s14, 1
		s_lshr_b32 s13, s13, 3
		s_add_i32 s13, s14, s13
		s_lshl_b32 s0, s0, 5
		s_add_i32 s0, s13, s0
		s_and_b32 s0, s0, 63
		s_and_b32 s13, s0, 3
		s_lshl_b32 s14, s13, 20
		s_add_i32 s28, s15, s14
		buffer_load_dwordx4 v2, s[8:11], s28 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0x40000
		s_add_i32 s29, s29, s14
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_lshrrev_b32_e32 v3, 6, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0x80000
		s_add_i32 s29, s29, s14
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_lshrrev_b32_e32 v8, 1, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0xc0000
		s_add_i32 s29, s29, s14
		v_lshrrev_b32_e32 v9, 4, v1
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_lshrrev_b32_e32 v10, 7, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 64
		s_add_i32 s29, s29, s14
		s_mov_b32 s30, 0
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_and_b32_e32 v11, 1, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0x40040
		s_add_i32 s29, s29, s14
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_lshlrev_b32_e32 v12, 7, v10
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0x80040
		s_add_i32 s29, s29, s14
		v_lshlrev_b32_e32 v13, 12, v9
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s29, s15, 0xc0040
		s_add_i32 s29, s29, s14
		s_lshr_b32 s0, s0, 2
		v_lshlrev_b32_e32 v14, 2, v0
		buffer_load_dwordx4 v2, s[8:11], s29 offen lds
		v_add3_u32 v12, v12, v13, v14
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s29, s0, 20
		v_lshlrev_b32_e32 v13, 10, v10
		v_add_u32_e32 v15, 0x20000, v13
		v_accvgpr_write_b32 a0, v15
		v_lshlrev_b32_e32 v15, 7, v9
		buffer_load_dwordx4 v2, s[24:27], s29 offen lds
		s_mov_b32 s34, 0x2000000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s31, s29, 0x40000
		buffer_load_dwordx4 v2, s[24:27], s31 offen lds
		v_and_b32_e32 v3, 1, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s31, s29, 0x80000
		buffer_load_dwordx4 v2, s[24:27], s31 offen lds
		v_cmp_eq_u32_e64 s[32:33], v11, s30
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s31, s29, 0xc0000
		buffer_load_dwordx4 v2, s[24:27], s31 offen lds
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, v11, v15, v14
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s31, s29, 64
		buffer_load_dwordx4 v2, s[24:27], s31 offen lds
		s_lshl_b32 s31, s12, 10
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s35, s29, 0x40040
		buffer_load_dwordx4 v2, s[24:27], s35 offen lds
		s_lshl_b32 s35, s13, 8
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s36, s29, 0x80040
		buffer_load_dwordx4 v2, s[24:27], s36 offen lds
		s_add_i32 s36, s29, 0xc0040
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s37, s31, s35
		s_add_i32 s38, s31, 0x4000
		s_add_i32 s38, s38, s35
		buffer_load_dwordx4 v2, s[24:27], s36 offen lds
		s_and_saveexec_b64 s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v16, v12, s[20:23], s37 offen
		buffer_load_dword v17, v12, s[20:23], s37 offen offset:64
		buffer_load_dword v18, v12, s[20:23], s38 offen
		buffer_load_dword v19, v12, s[20:23], s38 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v11, v16, v17 offset1:2
		ds_write2st64_b32 v11, v18, v19 offset0:16 offset1:18
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[42:43]
		v_cmp_eq_u32_e64 s[36:37], v8, s30
		v_lshl_add_u32 v8, v9, 12, v14
		v_lshl_add_u32 v8, v3, 7, v8
		s_lshl_b32 s38, s0, 8
		s_add_i32 s39, s38, 0x4000
		v_add_u32_e32 v16, 0x20000, v15
		v_add_u32_e32 v16, v16, v14
		v_lshl_add_u32 v16, v3, 10, v16
		s_and_saveexec_b64 s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v17, v8, s[16:19], s38 offen
		buffer_load_dword v18, v8, s[16:19], s38 offen offset:64
		buffer_load_dword v19, v8, s[16:19], s39 offen
		buffer_load_dword v20, v8, s[16:19], s39 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v16, v17, v18 offset0:8 offset1:10
		ds_write2st64_b32 v16, v19, v20 offset0:24 offset1:26
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[42:43]
		s_add_i32 s39, s31, 0x8000
		s_add_i32 s39, s39, s35
		s_add_i32 s40, s31, 0xc000
		s_add_i32 s40, s40, s35
		s_and_saveexec_b64 s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v17, v12, s[20:23], s39 offen
		buffer_load_dword v18, v12, s[20:23], s39 offen offset:64
		buffer_load_dword v19, v12, s[20:23], s40 offen
		buffer_load_dword v20, v12, s[20:23], s40 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v11, v17, v18 offset0:32 offset1:34
		ds_write2st64_b32 v11, v19, v20 offset0:48 offset1:50
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[42:43]
		s_add_i32 s39, s38, 0x8000
		s_add_i32 s40, s38, 0xc000
		s_and_saveexec_b64 s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v11, v8, s[16:19], s39 offen
		buffer_load_dword v17, v8, s[16:19], s39 offen offset:64
		buffer_load_dword v18, v8, s[16:19], s40 offen
		buffer_load_dword v19, v8, s[16:19], s40 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v16, v11, v17 offset0:40 offset1:42
		ds_write2st64_b32 v16, v18, v19 offset0:56 offset1:58
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[42:43]
		s_add_i32 m0, s1, 0x10000
		s_add_i32 s39, s15, 0x80
		s_add_i32 s39, s39, s14
		buffer_load_dwordx4 v2, s[8:11], s39 offen lds
		v_and_b32_e32 v11, 15, v1
		v_accvgpr_write_b32 a1, v11
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s39, s15, 0x40080
		s_add_i32 s39, s39, s14
		buffer_load_dwordx4 v2, s[8:11], s39 offen lds
		v_lshl_add_u32 v11, v9, 7, v14
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s39, s15, 0x80080
		s_add_i32 s39, s39, s14
		v_add_u32_e32 v16, v13, v15
		buffer_load_dwordx4 v2, s[8:11], s39 offen lds
		v_lshlrev_b32_e32 v17, 10, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s39, s15, 0xc0080
		s_add_i32 s39, s39, s14
		s_add_i32 s40, s38, 0x10000
		buffer_load_dwordx4 v2, s[8:11], s39 offen lds
		v_lshlrev_b32_e32 v1, 3, v1
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s39, s15, 0xc0
		s_add_i32 s39, s39, s14
		v_add_u32_e32 v18, s29, v2
		buffer_load_dwordx4 v2, s[8:11], s39 offen lds
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s4, s15, 0x400c0
		s_add_i32 s4, s4, s14
		buffer_load_dwordx4 v2, s[8:11], s4 offen lds
		s_add_i32 s4, s31, 0x14000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s15, 0x800c0
		s_add_i32 s5, s5, s14
		s_add_i32 s31, s31, 0x10000
		buffer_load_dwordx4 v2, s[8:11], s5 offen lds
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s15, 0xc00c0
		s_add_i32 s2, s2, s14
		v_add_u32_e32 v19, s28, v2
		v_lshrrev_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v0, 6, v0
		buffer_load_dwordx4 v2, s[8:11], s2 offen lds
		v_lshlrev_b32_e32 v21, 13, v10
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0x80
		v_bitop3_b32 v20, v9, v20, 3 bitop3:0x78
		v_lshlrev_b32_e32 v20, 4, v20
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add3_u32 v22, v21, v0, v20
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0x40080
		v_lshlrev_b32_e32 v23, 13, v3
		v_add3_u32 v24, v0, v23, v20
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v25, 0x100, v19
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0x80080
		v_add_u32_e32 v26, 0x40100, v19
		v_add_u32_e32 v27, 0x80100, v19
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v28, 0xc0100, v19
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0xc0080
		v_add_u32_e32 v29, 0x140, v19
		v_add_u32_e32 v30, 0x40140, v19
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v31, 0x80140, v19
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0xc0
		v_add_u32_e32 v32, 0xc0140, v19
		v_add_u32_e32 v19, 0x100, v18
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v33, 0x40100, v18
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0x400c0
		v_add_u32_e32 v34, 0x80100, v18
		v_add_u32_e32 v35, 0xc0100, v18
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v36, 0x140, v18
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0x800c0
		v_add_u32_e32 v37, 0x40140, v18
		v_add_u32_e32 v38, 0x80140, v18
		v_add_u32_e32 v39, 0xc0140, v18
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_lshlrev_b32_e32 v18, 3, v9
		v_accvgpr_write_b32 a2, v18
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s29, 0xc00c0
		s_add_i32 s3, s31, s35
		s_add_i32 s4, s4, s35
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[4:7], v22
		ds_read_b128 a[8:11], v22 offset:1024
		ds_read_b128 a[12:15], v22 offset:2048
		ds_read_b128 a[16:19], v22 offset:3072
		ds_read_b128 a[20:23], v22 offset:4096
		ds_read_b128 a[24:27], v22 offset:5120
		ds_read_b128 a[28:31], v22 offset:6144
		ds_read_b128 a[32:35], v22 offset:7168
		ds_read_b128 a[36:39], v22 offset:16384
		ds_read_b128 a[40:43], v22 offset:17408
		ds_read_b128 a[44:47], v22 offset:18432
		ds_read_b128 a[48:51], v22 offset:19456
		ds_read_b128 a[52:55], v22 offset:20480
		ds_read_b128 a[56:59], v22 offset:21504
		ds_read_b128 a[60:63], v22 offset:22528
		ds_read_b128 a[64:67], v22 offset:23552
		ds_read_b128 a[68:71], v24 offset:32768
		ds_read_b128 a[72:75], v24 offset:33792
		ds_read_b128 a[76:79], v24 offset:34816
		ds_read_b128 a[80:83], v24 offset:35840
		ds_read_b128 a[84:87], v24 offset:36864
		ds_read_b128 a[88:91], v24 offset:37888
		ds_read_b128 a[92:95], v24 offset:38912
		ds_read_b128 a[96:99], v24 offset:39936
		ds_read_b128 a[100:103], v24 offset:49152
		ds_read_b128 a[104:107], v24 offset:50176
		ds_read_b128 a[108:111], v24 offset:51200
		ds_read_b128 a[112:115], v24 offset:52224
		ds_read_b128 a[116:119], v24 offset:53248
		ds_read_b128 a[120:123], v24 offset:54272
		ds_read_b128 a[124:127], v24 offset:55296
		ds_read_b128 a[128:131], v24 offset:56320
		s_add_i32 s2, s38, 0x14000
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
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s5, s30, 1
		s_lshl_b32 s5, s5, 13
		s_add_i32 s14, s5, 0x20000
		v_add_u32_e32 v2, s14, v13
		v_add_u32_e32 v18, v2, v1
		s_waitcnt vmcnt(20)
		ds_read_b64_tr_b8 v[232:233], v18
		ds_read_b64_tr_b8 v[234:235], v18 offset:512
		v_add3_u32 v22, s14, v1, v17
		ds_read_b64_tr_b8 v[236:237], v22 offset:2048
		ds_read_b64_tr_b8 v[238:239], v18 offset:4096
		s_waitcnt vmcnt(19)
		ds_read_b64_tr_b8 v[240:241], v18 offset:4608
		s_waitcnt vmcnt(17)
		ds_read_b64_tr_b8 v[242:243], v22 offset:6144
		ds_read_b64_tr_b8 v[244:245], v22 offset:2560
		ds_read_b64_tr_b8 v[246:247], v22 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v232, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[4:7], a[72:75], v[40:43], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[76:79], v[44:47], v232, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[80:83], v[48:51], v232, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[80:83], v[80:83], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_lshl_b32 s14, s30, 15
		s_add_i32 s15, s3, s14
		s_add_i32 s28, s4, s14
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[8:11], a[68:71], v[68:71], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s29, s5, 0x20200
		s_add_i32 s31, s5, 0x21000
		s_add_i32 s35, s5, 0x21200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[72:75], v[72:75], v232, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[76:79], v[76:79], v232, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[76:79], v[108:111], v232, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], a[68:71], v[100:103], v232, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[72:75], v[104:107], v232, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[80:83], v[112:115], v232, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[80:83], v[144:147], v232, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], a[68:71], v[132:135], v232, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[72:75], v[136:139], v232, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[76:79], v[140:143], v232, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[20:23], a[68:71], v[164:167], v234, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[72:75], v[168:171], v234, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[76:79], v[172:175], v234, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[80:83], v[176:179], v234, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[80:83], v[196:199], v234, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[24:27], a[68:71], v[184:187], v234, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[72:75], v[188:191], v234, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[76:79], v[192:195], v234, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[76:79], v[208:211], v234, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[28:31], a[68:71], v[200:203], v234, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[72:75], v[204:207], v234, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[80:83], v[212:215], v234, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[80:83], v[228:231], v234, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[32:35], a[68:71], v[216:219], v234, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[72:75], v[220:223], v234, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[76:79], v[224:227], v234, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[36:39], a[100:103], v[4:7], v238, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[36:39], a[104:107], v[40:43], v238, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[108:111], v[44:47], v238, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[112:115], v[48:51], v238, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[112:115], v[80:83], v238, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[40:43], a[100:103], v[68:71], v238, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[104:107], v[72:75], v238, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[108:111], v[76:79], v238, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[108:111], v[108:111], v238, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[44:47], a[100:103], v[100:103], v238, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[104:107], v[104:107], v238, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[112:115], v[112:115], v238, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[112:115], v[144:147], v238, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[48:51], a[100:103], v[132:135], v238, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[104:107], v[136:139], v238, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[108:111], v[140:143], v238, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[52:55], a[100:103], v[164:167], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[104:107], v[168:171], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[108:111], v[172:175], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[112:115], v[176:179], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[112:115], v[196:199], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[56:59], a[100:103], v[184:187], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[104:107], v[188:191], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[108:111], v[192:195], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[108:111], v[208:211], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[60:63], a[100:103], v[200:203], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[104:107], v[204:207], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[112:115], v[212:215], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[112:115], v[228:231], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[100:103], v[216:219], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[104:107], v[220:223], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[108:111], v[224:227], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v18, v12, s[20:23], s15 offen
		buffer_load_dword v22, v12, s[20:23], s15 offen offset:64
		buffer_load_dword v24, v12, s[20:23], s28 offen
		buffer_load_dword v233, v12, s[20:23], s28 offen offset:64
		v_add3_u32 v235, v2, v15, v14
		v_add3_u32 v236, v14, v16, s29
		v_add3_u32 v237, v14, v16, s31
		v_add3_u32 v239, v14, v16, s35
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[42:43]
		s_add_i32 s15, s40, s14
		s_add_i32 s14, s2, s14
		s_add_i32 s28, s5, 0x20800
		v_lshl_add_u32 v2, v9, 7, s28
		s_add_i32 s28, s5, 0x20a00
		s_add_i32 s29, s5, 0x21800
		s_add_i32 s5, s5, 0x21a00
		s_and_saveexec_b64 s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v241, v8, s[16:19], s15 offen
		buffer_load_dword v242, v8, s[16:19], s15 offen offset:64
		buffer_load_dword v243, v8, s[16:19], s14 offen
		s_waitcnt vmcnt(23)
		buffer_load_dword v248, v8, s[16:19], s14 offen offset:64
		v_add3_u32 v249, v2, v14, v17
		v_add3_u32 v250, v17, v11, s28
		v_add3_u32 v251, v17, v11, s29
		v_add3_u32 v252, v17, v11, s5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[42:43]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[84:87], v[52:55], v232, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[88:91], v[56:59], v232, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[92:95], v[60:63], v232, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[96:99], v[64:67], v232, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[96:99], v[96:99], v232, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[84:87], v[84:87], v232, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[88:91], v[88:91], v232, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[92:95], v[92:95], v232, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[92:95], v[124:127], v232, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[84:87], v[116:119], v232, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[88:91], v[120:123], v232, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[96:99], v[128:131], v232, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[96:99], v[160:163], v232, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[84:87], v[148:151], v232, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v28, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[88:91], v[152:155], v232, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[92:95], v[156:159], v232, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v234, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[84:87], v[180:183], v234, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v234, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v234, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v234, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v234, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v234, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v234, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v234, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v234, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v234, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v234, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v234, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v234, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v234, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v234, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[116:119], v[52:55], v238, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v32, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[120:123], v[56:59], v238, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[124:127], v[60:63], v238, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[128:131], v[64:67], v238, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[128:131], v[96:99], v238, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[116:119], v[84:87], v238, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[120:123], v[88:91], v238, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[124:127], v[92:95], v238, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[124:127], v[124:127], v238, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[116:119], v[116:119], v238, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[120:123], v[120:123], v238, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[128:131], v[128:131], v238, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[128:131], v[160:163], v238, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[116:119], v[148:151], v238, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[120:123], v[152:155], v238, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[124:127], v[156:159], v238, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v240, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v38, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[116:119], v[180:183], v240, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v240, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v240, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v235, v18
		ds_write_b32 v236, v22
		ds_write_b32 v237, v24
		ds_write_b32 v239, v233
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[42:43], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[42:43]
		s_and_saveexec_b64 s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v249, v241
		ds_write_b32 v250, v242
		ds_write_b32 v251, v243
		ds_write_b32 v252, v248
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[42:43], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[42:43]
		s_add_i32 m0, s1, 0x9000
		s_add_i32 s1, s1, 0x10000
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 s30, s30, 1
		s_add_i32 m0, m0, 0x2000
		s_and_b32 s5, s30, 1
		s_lshl_b32 s5, s5, 16
		v_add_u32_e32 v2, s5, v21
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		v_add3_u32 v2, v2, v0, v20
		s_add_i32 m0, m0, 0x2000
		s_waitcnt vmcnt(21)
		v_add_u32_e32 v18, s5, v0
		s_and_b32 s1, s1, 0x1ffff
		buffer_load_dwordx4 v37, s[24:27], 0 offen lds
		s_add_u32 s8, s8, 0x80
		s_addc_u32 s9, s9, 0
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v18, v18, v23, v20
		buffer_load_dwordx4 v39, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x80
		s_addc_u32 s25, s25, 0
		s_cmp_lt_i32 s30, 30
		s_barrier
		ds_read_b128 a[4:7], v2
		ds_read_b128 a[8:11], v2 offset:1024
		ds_read_b128 a[12:15], v2 offset:2048
		ds_read_b128 a[16:19], v2 offset:3072
		ds_read_b128 a[20:23], v2 offset:4096
		ds_read_b128 a[24:27], v2 offset:5120
		ds_read_b128 a[28:31], v2 offset:6144
		ds_read_b128 a[32:35], v2 offset:7168
		ds_read_b128 a[36:39], v2 offset:16384
		ds_read_b128 a[40:43], v2 offset:17408
		ds_read_b128 a[44:47], v2 offset:18432
		ds_read_b128 a[48:51], v2 offset:19456
		ds_read_b128 a[52:55], v2 offset:20480
		ds_read_b128 a[56:59], v2 offset:21504
		ds_read_b128 a[60:63], v2 offset:22528
		ds_read_b128 a[64:67], v2 offset:23552
		ds_read_b128 a[68:71], v18 offset:32768
		ds_read_b128 a[72:75], v18 offset:33792
		ds_read_b128 a[76:79], v18 offset:34816
		ds_read_b128 a[80:83], v18 offset:35840
		ds_read_b128 a[84:87], v18 offset:36864
		ds_read_b128 a[88:91], v18 offset:37888
		ds_read_b128 a[92:95], v18 offset:38912
		ds_read_b128 a[96:99], v18 offset:39936
		ds_read_b128 a[100:103], v18 offset:49152
		ds_read_b128 a[104:107], v18 offset:50176
		ds_read_b128 a[108:111], v18 offset:51200
		ds_read_b128 a[112:115], v18 offset:52224
		ds_read_b128 a[116:119], v18 offset:53248
		ds_read_b128 a[120:123], v18 offset:54272
		ds_read_b128 a[124:127], v18 offset:55296
		ds_read_b128 a[128:131], v18 offset:56320
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v2, a0
		v_add_u32_e32 v2, v2, v1
		ds_read_b64_tr_b8 v[8:9], v2
		ds_read_b64_tr_b8 v[12:13], v2 offset:512
		v_add_u32_e32 v1, 0x20000, v1
		v_lshl_add_u32 v1, v3, 10, v1
		ds_read_b64_tr_b8 v[14:15], v1 offset:2048
		ds_read_b64_tr_b8 v[16:17], v1 offset:2560
		ds_read_b64_tr_b8 v[18:19], v2 offset:4096
		ds_read_b64_tr_b8 v[24:25], v2 offset:4608
		ds_read_b64_tr_b8 v[26:27], v1 offset:6144
		ds_read_b64_tr_b8 v[28:29], v1 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v8, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[4:7], a[72:75], v[40:43], v8, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[76:79], v[44:47], v8, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[80:83], v[48:51], v8, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[84:87], v[52:55], v8, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[88:91], v[56:59], v8, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[92:95], v[60:63], v8, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[96:99], v[64:67], v8, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[96:99], v[96:99], v8, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[84:87], v[84:87], v8, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[88:91], v[88:91], v8, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[92:95], v[92:95], v8, v16 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[92:95], v[124:127], v8, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[84:87], v[116:119], v8, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[88:91], v[120:123], v8, v16 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[96:99], v[128:131], v8, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[96:99], v[160:163], v8, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[84:87], v[148:151], v8, v16 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[88:91], v[152:155], v8, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[92:95], v[156:159], v8, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], a[68:71], v[132:135], v8, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[8:11], a[68:71], v[68:71], v8, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[72:75], v[72:75], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[76:79], v[76:79], v8, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[80:83], v[80:83], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[80:83], v[112:115], v8, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], a[68:71], v[100:103], v8, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[72:75], v[104:107], v8, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[76:79], v[108:111], v8, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[76:79], v[140:143], v8, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[72:75], v[136:139], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[80:83], v[144:147], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[20:23], a[68:71], v[164:167], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[72:75], v[168:171], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[76:79], v[172:175], v12, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[80:83], v[176:179], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[80:83], v[196:199], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[24:27], a[68:71], v[184:187], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[72:75], v[188:191], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[76:79], v[192:195], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[76:79], v[208:211], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[28:31], a[68:71], v[200:203], v12, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[72:75], v[204:207], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[80:83], v[212:215], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[80:83], v[228:231], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[32:35], a[68:71], v[216:219], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[72:75], v[220:223], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[76:79], v[224:227], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v12, v16 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[84:87], v[180:183], v12, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v12, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v12, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v12, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v12, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v12, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v12, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v12, v16 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v12, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v12, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v12, v16 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v12, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v12, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v12, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v12, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[36:39], a[100:103], v[4:7], v18, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[36:39], a[104:107], v[40:43], v18, v26 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[108:111], v[44:47], v18, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[112:115], v[48:51], v18, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[116:119], v[52:55], v18, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[120:123], v[56:59], v18, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[124:127], v[60:63], v18, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[128:131], v[64:67], v18, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[128:131], v[96:99], v18, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[116:119], v[84:87], v18, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[120:123], v[88:91], v18, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[124:127], v[92:95], v18, v28 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[124:127], v[124:127], v18, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[116:119], v[116:119], v18, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[120:123], v[120:123], v18, v28 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[128:131], v[128:131], v18, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[128:131], v[160:163], v18, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[116:119], v[148:151], v18, v28 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[120:123], v[152:155], v18, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[124:127], v[156:159], v18, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[48:51], a[100:103], v[132:135], v18, v26 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[40:43], a[100:103], v[68:71], v18, v26 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[104:107], v[72:75], v18, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[108:111], v[76:79], v18, v26 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[112:115], v[80:83], v18, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[112:115], v[112:115], v18, v26 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[44:47], a[100:103], v[100:103], v18, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[104:107], v[104:107], v18, v26 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[108:111], v[108:111], v18, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[108:111], v[140:143], v18, v26 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[104:107], v[136:139], v18, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[112:115], v[144:147], v18, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[52:55], a[100:103], v[164:167], v24, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[104:107], v[168:171], v24, v26 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[108:111], v[172:175], v24, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[112:115], v[176:179], v24, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[112:115], v[196:199], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[56:59], a[100:103], v[184:187], v24, v26 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[104:107], v[188:191], v24, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[108:111], v[192:195], v24, v26 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[108:111], v[208:211], v24, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[60:63], a[100:103], v[200:203], v24, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[104:107], v[204:207], v24, v26 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[112:115], v[212:215], v24, v26 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[112:115], v[228:231], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[100:103], v[216:219], v24, v26 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[104:107], v[220:223], v24, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[108:111], v[224:227], v24, v26 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v24, v28 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[116:119], v[180:183], v24, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v24, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v24, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v24, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v24, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v24, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v24, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v24, v28 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v24, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v24, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v24, v28 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v24, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v24, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v24, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v24, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v8, 0x10000, v21
		v_add3_u32 v8, v8, v0, v20
		ds_read_b128 v[12:15], v8
		ds_read_b128 v[16:19], v8 offset:1024
		ds_read_b128 a[4:7], v8 offset:2048
		ds_read_b128 a[8:11], v8 offset:3072
		ds_read_b128 a[12:15], v8 offset:4096
		ds_read_b128 a[16:19], v8 offset:5120
		ds_read_b128 a[20:23], v8 offset:6144
		ds_read_b128 a[24:27], v8 offset:7168
		ds_read_b128 a[28:31], v8 offset:16384
		ds_read_b128 a[32:35], v8 offset:17408
		ds_read_b128 a[36:39], v8 offset:18432
		ds_read_b128 a[40:43], v8 offset:19456
		ds_read_b128 a[44:47], v8 offset:20480
		ds_read_b128 a[48:51], v8 offset:21504
		ds_read_b128 a[52:55], v8 offset:22528
		ds_read_b128 a[56:59], v8 offset:23552
		v_add_u32_e32 v0, 0x10000, v0
		v_add3_u32 v0, v0, v23, v20
		ds_read_b128 v[20:23], v0 offset:32768
		ds_read_b128 v[24:27], v0 offset:33792
		ds_read_b128 v[28:31], v0 offset:34816
		ds_read_b128 v[32:35], v0 offset:35840
		ds_read_b128 a[60:63], v0 offset:36864
		ds_read_b128 a[64:67], v0 offset:37888
		ds_read_b128 a[68:71], v0 offset:38912
		ds_read_b128 a[72:75], v0 offset:39936
		ds_read_b128 v[36:39], v0 offset:49152
		ds_read_b128 v[232:235], v0 offset:50176
		ds_read_b128 v[236:239], v0 offset:51200
		ds_read_b128 v[240:243], v0 offset:52224
		ds_read_b128 a[76:79], v0 offset:53248
		ds_read_b128 a[80:83], v0 offset:54272
		ds_read_b128 a[84:87], v0 offset:55296
		ds_read_b128 a[88:91], v0 offset:56320
		v_accvgpr_read_b32 v0, a2
		v_lshl_add_u32 v0, v10, 8, v0
		v_lshl_add_u32 v0, v3, 20, v0
		v_accvgpr_read_b32 v3, a1
		v_lshl_add_u32 v0, v3, 13, v0
		s_lshl_b32 s0, s0, 21
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[8:9], v2 offset:8192
		ds_read_b64_tr_b8 v[10:11], v2 offset:8704
		ds_read_b64_tr_b8 v[244:245], v1 offset:10240
		ds_read_b64_tr_b8 v[246:247], v1 offset:10752
		ds_read_b64_tr_b8 v[248:249], v2 offset:12288
		ds_read_b64_tr_b8 v[250:251], v2 offset:12800
		ds_read_b64_tr_b8 v[2:3], v1 offset:14336
		ds_read_b64_tr_b8 v[252:253], v1 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[20:23], v[4:7], v8, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s12, 11
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s13, 9
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[12:15], v[24:27], v[40:43], v8, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s2, s3
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[12:15], v[28:31], v[44:47], v8, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[12:15], v[32:35], v[48:51], v8, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[32:35], v[80:83], v8, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[20:23], v[68:71], v8, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[24:27], v[72:75], v8, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[28:31], v[76:79], v8, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[4:7], v[28:31], v[108:111], v8, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[4:7], v[20:23], v[100:103], v8, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[4:7], v[24:27], v[104:107], v8, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[4:7], v[32:35], v[112:115], v8, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[8:11], v[32:35], v[144:147], v8, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[8:11], v[20:23], v[132:135], v8, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[8:11], v[24:27], v[136:139], v8, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[8:11], v[28:31], v[140:143], v8, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[12:15], v[20:23], v[164:167], v10, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[12:15], v[24:27], v[168:171], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[12:15], v[28:31], v[172:175], v10, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[12:15], v[32:35], v[176:179], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[16:19], v[32:35], v[196:199], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[16:19], v[20:23], v[184:187], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[16:19], v[24:27], v[188:191], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[16:19], v[28:31], v[192:195], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[20:23], v[28:31], v[208:211], v10, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[20:23], v[20:23], v[200:203], v10, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[20:23], v[24:27], v[204:207], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[20:23], v[32:35], v[212:215], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[24:27], v[32:35], v[228:231], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[24:27], v[20:23], v[216:219], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[24:27], v[24:27], v[220:223], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[24:27], v[28:31], v[224:227], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[28:31], v[36:39], v[4:7], v248, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[28:31], v[232:235], v[40:43], v248, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[28:31], v[236:239], v[44:47], v248, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[28:31], v[240:243], v[48:51], v248, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[32:35], v[240:243], v[80:83], v248, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[32:35], v[36:39], v[68:71], v248, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[32:35], v[232:235], v[72:75], v248, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[32:35], v[236:239], v[76:79], v248, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[36:39], v[236:239], v[108:111], v248, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v20, v4, v5
		v_cvt_pk_f16_f32 v21, v6, v7
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s35, s19
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[20:21], v0, s[32:35], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[36:39], v[36:39], v[100:103], v248, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[36:39], v[232:235], v[104:107], v248, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[36:39], v[240:243], v[112:115], v248, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[40:43], v[240:243], v[144:147], v248, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[40:43], v[36:39], v[132:135], v248, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[40:43], v[232:235], v[136:139], v248, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[40:43], v[236:239], v[140:143], v248, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[44:47], v[36:39], v[164:167], v250, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[44:47], v[232:235], v[168:171], v250, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[44:47], v[236:239], v[172:175], v250, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[44:47], v[240:243], v[176:179], v250, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[48:51], v[240:243], v[196:199], v250, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[48:51], v[36:39], v[184:187], v250, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[48:51], v[232:235], v[188:191], v250, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[48:51], v[236:239], v[192:195], v250, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[52:55], v[236:239], v[208:211], v250, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[52:55], v[36:39], v[200:203], v250, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[52:55], v[232:235], v[204:207], v250, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[52:55], v[240:243], v[212:215], v250, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[56:59], v[240:243], v[228:231], v250, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[56:59], v[36:39], v[216:219], v250, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[56:59], v[232:235], v[220:223], v250, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[56:59], v[236:239], v[224:227], v250, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		s_add_i32 s4, s0, 0x20000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		s_add_i32 s5, s0, 0x40000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		s_add_i32 s6, s0, 0x60000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:32
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:32
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:32
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:32
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:64
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:64
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:64
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:64
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:96
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:96
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:96
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:96
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:128
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:128
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:128
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:128
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:160
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:160
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:160
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:160
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:192
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:192
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:192
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:192
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:224
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:224
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:224
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s6 offen offset:224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[12:15], a[60:63], v[52:55], v8, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s0, 0x80000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[12:15], a[64:67], v[56:59], v8, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[12:15], a[68:71], v[60:63], v8, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[12:15], a[72:75], v[64:67], v8, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], a[72:75], v[96:99], v8, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], a[60:63], v[84:87], v8, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], a[64:67], v[88:91], v8, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], a[68:71], v[92:95], v8, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[4:7], a[68:71], v[124:127], v8, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[4:7], a[60:63], v[116:119], v8, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[4:7], a[64:67], v[120:123], v8, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[4:7], a[72:75], v[128:131], v8, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[8:11], a[72:75], v[160:163], v8, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[8:11], a[60:63], v[148:151], v8, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[8:11], a[64:67], v[152:155], v8, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[8:11], a[68:71], v[156:159], v8, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[12:15], a[68:71], a[136:139], v10, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[12:15], a[60:63], v[180:183], v10, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[12:15], a[64:67], a[132:135], v10, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[12:15], a[72:75], a[140:143], v10, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[16:19], a[72:75], a[156:159], v10, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[16:19], a[60:63], a[144:147], v10, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[16:19], a[64:67], a[148:151], v10, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[16:19], a[68:71], a[152:155], v10, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[20:23], a[68:71], a[168:171], v10, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[20:23], a[60:63], a[160:163], v10, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[20:23], a[64:67], a[164:167], v10, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[20:23], a[72:75], a[172:175], v10, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[24:27], a[72:75], a[188:191], v10, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[24:27], a[60:63], a[176:179], v10, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[24:27], a[64:67], a[180:183], v10, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[24:27], a[68:71], a[184:187], v10, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[28:31], a[76:79], v[52:55], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[28:31], a[80:83], v[56:59], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[28:31], a[84:87], v[60:63], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[28:31], a[88:91], v[64:67], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[32:35], a[88:91], v[96:99], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[32:35], a[76:79], v[84:87], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[32:35], a[80:83], v[88:91], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[32:35], a[84:87], v[92:95], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[36:39], a[84:87], v[124:127], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[36:39], a[76:79], v[116:119], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[36:39], a[80:83], v[120:123], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[36:39], a[88:91], v[128:131], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[40:43], a[88:91], v[160:163], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[40:43], a[76:79], v[148:151], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[40:43], a[80:83], v[152:155], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[40:43], a[84:87], v[156:159], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[44:47], a[84:87], a[136:139], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[44:47], a[76:79], v[180:183], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], a[80:83], a[132:135], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], a[88:91], a[140:143], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[88:91], a[156:159], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], a[76:79], a[144:147], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], a[80:83], a[148:151], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[48:51], a[84:87], a[152:155], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], a[84:87], a[168:171], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], a[76:79], a[160:163], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], a[80:83], a[164:167], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[52:55], a[88:91], a[172:175], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[56:59], a[88:91], a[188:191], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], a[76:79], a[176:179], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[56:59], a[80:83], a[180:183], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[56:59], a[84:87], a[184:187], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		s_add_i32 s4, s0, 0xa0000
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		s_add_i32 s5, s0, 0xc0000
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		s_add_i32 s0, s0, 0xe0000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:32
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:32
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:32
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:32
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:64
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:64
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:64
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:64
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:96
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s4 offen offset:96
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s5 offen offset:96
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:96
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:128
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s4 offen offset:128
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s5 offen offset:128
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:128
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:160
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s4 offen offset:160
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s5 offen offset:160
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:160
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:192
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s4 offen offset:192
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s5 offen offset:192
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:192
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:224
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s4 offen offset:224
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s5 offen offset:224
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:224
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
		.amdhsa_next_free_vgpr 448
		.amdhsa_next_free_sgpr 44
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 192
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 44
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
    .sgpr_count:     44
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     448
    .agpr_count:     192
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 73
    wave.regalloc.agpr.dwords: 279
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
