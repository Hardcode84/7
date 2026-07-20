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
		s_lshl_b32 s0, s14, 1
		s_lshr_b32 s1, s13, 3
		s_add_i32 s0, s0, s1
		s_and_b32 s1, s13, 7
		s_lshl_b32 s12, s1, 5
		s_add_i32 s0, s0, s12
		s_and_b32 s0, s0, 63
		s_lshr_b32 s12, s0, 2
		s_lshl_b32 s13, s12, 17
		s_lshr_b32 s1, s1, 1
		s_lshl_b32 s14, s1, 23
		s_add_i32 s13, s13, s14
		s_and_b32 s0, s0, 3
		s_lshl_b32 s14, s0, 21
		s_add_i32 s13, s13, s14
		s_add_u32 s28, s6, s13
		s_addc_u32 s29, s7, 0
		s_mov_b32 s30, 0x20000
		s_mov_b32 s31, s19
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s6, s6, 6
		s_lshl_b32 s7, s6, 10
		s_mov_b32 m0, s7
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 12, v2
		v_lshl_add_u32 v2, s6, 16, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshl_add_u32 v2, v3, 4, v2
		s_lshl_b32 s6, s1, 22
		s_lshl_b32 s13, s0, 20
		s_add_i32 s14, s6, s13
		buffer_load_dwordx4 v2, s[8:11], s14 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s15, s6, 0x40000
		s_add_i32 s15, s15, s13
		buffer_load_dwordx4 v2, s[8:11], s15 offen lds
		v_lshrrev_b32_e32 v3, 6, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s15, s6, 0x80000
		s_add_i32 s15, s15, s13
		buffer_load_dwordx4 v2, s[8:11], s15 offen lds
		s_mov_b32 s15, 0x3000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s32, s6, 0xc0000
		s_add_i32 s32, s32, s13
		buffer_load_dwordx4 v2, s[8:11], s32 offen lds
		s_mov_b32 s32, 0x1000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s33, s6, 64
		s_add_i32 s33, s33, s13
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		v_and_b32_e32 v8, 1, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s33, s6, 0x40040
		s_add_i32 s33, s33, s13
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		v_lshrrev_b32_e32 v9, 4, v1
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s33, s6, 0x80040
		s_add_i32 s33, s33, s13
		v_lshrrev_b32_e32 v10, 7, v0
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s34, s6, 0xc0040
		s_add_i32 s34, s34, s13
		v_and_b32_e32 v11, 1, v3
		v_cmp_eq_u32_e64 vcc, v11, s33
		s_mov_b64 s[36:37], vcc
		buffer_load_dwordx4 v2, s[8:11], s34 offen lds
		v_lshlrev_b32_e32 v11, 7, v10
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s34, s12, 20
		v_lshlrev_b32_e32 v12, 12, v9
		v_and_b32_e32 v13, 15, v0
		v_lshlrev_b32_e32 v14, 2, v13
		buffer_load_dwordx4 v2, s[24:27], s34 offen lds
		v_lshlrev_b32_e32 v15, 10, v10
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s35, s34, 0x40000
		v_add_u32_e32 v16, 0x20000, v15
		v_accvgpr_write_b32 a0, v16
		v_lshlrev_b32_e32 v16, 7, v9
		buffer_load_dwordx4 v2, s[24:27], s35 offen lds
		v_accvgpr_read_b32 v17, a0
		v_add3_u32 v17, v17, v16, v14
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s35, s34, 0x80000
		s_lshl_b32 s1, s1, 10
		buffer_load_dwordx4 v2, s[24:27], s35 offen lds
		s_mov_b32 s35, 0x4000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s38, s34, 0xc0000
		buffer_load_dwordx4 v2, s[24:27], s38 offen lds
		s_mov_b32 s38, 0x2000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s39, s34, 64
		buffer_load_dwordx4 v2, s[24:27], s39 offen lds
		s_mov_b32 s39, 32
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s40, s34, 0x40040
		buffer_load_dwordx4 v2, s[24:27], s40 offen lds
		v_lshrrev_b32_e32 v18, 1, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s40, s34, 0x80040
		buffer_load_dwordx4 v2, s[24:27], s40 offen lds
		v_add3_u32 v11, v11, v12, v14
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s40, s34, 0xc0040
		s_lshl_b32 s0, s0, 8
		s_add_i32 s41, s1, s0
		s_add_i32 s42, s1, 0x4000
		s_add_i32 s42, s42, s0
		buffer_load_dwordx4 v2, s[24:27], s40 offen lds
		s_and_saveexec_b64 s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v12, v11, s[20:23], s41 offen
		buffer_load_dword v19, v11, s[20:23], s41 offen offset:64
		buffer_load_dword v20, v11, s[20:23], s42 offen
		buffer_load_dword v21, v11, s[20:23], s42 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v17, v12, v19 offset1:2
		ds_write2st64_b32 v17, v20, v21 offset0:16 offset1:18
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[44:45]
		v_cmp_eq_u32_e64 vcc, v18, s33
		s_mov_b64 s[40:41], vcc
		v_lshl_add_u32 v12, v9, 12, v14
		v_lshl_add_u32 v12, v8, 7, v12
		s_lshl_b32 s12, s12, 8
		s_add_i32 s42, s12, 0x4000
		v_add_u32_e32 v18, 0x20000, v16
		v_add_u32_e32 v18, v18, v14
		v_lshl_add_u32 v18, v8, 10, v18
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v19, v12, s[16:19], s12 offen
		buffer_load_dword v20, v12, s[16:19], s12 offen offset:64
		buffer_load_dword v21, v12, s[16:19], s42 offen
		buffer_load_dword v22, v12, s[16:19], s42 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v18, v19, v20 offset0:8 offset1:10
		ds_write2st64_b32 v18, v21, v22 offset0:24 offset1:26
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[44:45]
		s_add_i32 s42, s1, 0x8000
		s_add_i32 s42, s42, s0
		s_add_i32 s43, s1, 0xc000
		s_add_i32 s43, s43, s0
		s_and_saveexec_b64 s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v19, v11, s[20:23], s42 offen
		buffer_load_dword v20, v11, s[20:23], s42 offen offset:64
		buffer_load_dword v21, v11, s[20:23], s43 offen
		buffer_load_dword v22, v11, s[20:23], s43 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v17, v19, v20 offset0:32 offset1:34
		ds_write2st64_b32 v17, v21, v22 offset0:48 offset1:50
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[44:45]
		s_add_i32 s42, s12, 0x8000
		s_add_i32 s43, s12, 0xc000
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v17, v12, s[16:19], s42 offen
		buffer_load_dword v19, v12, s[16:19], s42 offen offset:64
		buffer_load_dword v20, v12, s[16:19], s43 offen
		buffer_load_dword v21, v12, s[16:19], s43 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v18, v17, v19 offset0:40 offset1:42
		ds_write2st64_b32 v18, v20, v21 offset0:56 offset1:58
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[44:45]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s42, s6, 0x80
		s_add_i32 s42, s42, s13
		buffer_load_dwordx4 v2, s[8:11], s42 offen lds
		v_and_b32_e32 v0, 63, v0
		v_accvgpr_write_b32 a1, v0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s42, s6, 0x40080
		s_add_i32 s42, s42, s13
		buffer_load_dwordx4 v2, s[8:11], s42 offen lds
		v_lshl_add_u32 v0, v9, 7, v14
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s42, s6, 0x80080
		s_add_i32 s42, s42, s13
		v_add_u32_e32 v17, v15, v16
		buffer_load_dwordx4 v2, s[8:11], s42 offen lds
		v_lshlrev_b32_e32 v18, 10, v8
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s42, s6, 0xc0080
		s_add_i32 s42, s42, s13
		s_add_i32 s43, s12, 0x10000
		buffer_load_dwordx4 v2, s[8:11], s42 offen lds
		v_lshlrev_b32_e32 v19, 3, v1
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s42, s6, 0xc0
		s_add_i32 s42, s42, s13
		v_add_u32_e32 v20, s34, v2
		buffer_load_dwordx4 v2, s[8:11], s42 offen lds
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s4, s6, 0x400c0
		s_add_i32 s4, s4, s13
		buffer_load_dwordx4 v2, s[8:11], s4 offen lds
		s_add_i32 s4, s1, 0x14000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s6, 0x800c0
		s_add_i32 s5, s5, s13
		s_add_i32 s1, s1, 0x10000
		buffer_load_dwordx4 v2, s[8:11], s5 offen lds
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s6, 0xc00c0
		s_add_i32 s2, s2, s13
		v_add_u32_e32 v21, s14, v2
		v_lshrrev_b32_e32 v22, 1, v13
		v_lshlrev_b32_e32 v13, 6, v13
		buffer_load_dwordx4 v2, s[8:11], s2 offen lds
		v_lshlrev_b32_e32 v10, 13, v10
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0x80
		v_bitop3_b32 v22, v9, v22, 3 bitop3:0x78
		v_lshlrev_b32_e32 v22, 4, v22
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add3_u32 v23, v10, v13, v22
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0x40080
		v_lshlrev_b32_e32 v24, 13, v8
		v_add3_u32 v25, v13, v24, v22
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v26, 0x100, v21
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0x80080
		v_add_u32_e32 v27, 0x40100, v21
		v_add_u32_e32 v28, 0x80100, v21
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v29, 0xc0100, v21
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0xc0080
		v_add_u32_e32 v30, 0x140, v21
		v_add_u32_e32 v31, 0x40140, v21
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v32, 0x80140, v21
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0xc0
		v_add_u32_e32 v33, 0xc0140, v21
		v_add_u32_e32 v21, 0x100, v20
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v34, 0x40100, v20
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0x400c0
		v_add_u32_e32 v35, 0x80100, v20
		v_add_u32_e32 v36, 0xc0100, v20
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_add_u32_e32 v37, 0x140, v20
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0x800c0
		v_add_u32_e32 v38, 0x40140, v20
		v_add_u32_e32 v39, 0x80140, v20
		v_add_u32_e32 v40, 0xc0140, v20
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		v_lshlrev_b32_e32 v3, 15, v3
		v_accvgpr_write_b32 a2, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s2, s34, 0xc00c0
		s_add_i32 s1, s1, s0
		s_add_i32 s0, s4, s0
		buffer_load_dwordx4 v2, s[24:27], s2 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[4:7], v23
		ds_read_b128 a[8:11], v23 offset:1024
		ds_read_b128 a[12:15], v23 offset:2048
		ds_read_b128 a[16:19], v23 offset:3072
		ds_read_b128 a[20:23], v23 offset:4096
		ds_read_b128 a[24:27], v23 offset:5120
		ds_read_b128 a[28:31], v23 offset:6144
		ds_read_b128 a[32:35], v23 offset:7168
		ds_read_b128 a[36:39], v23 offset:16384
		ds_read_b128 a[40:43], v23 offset:17408
		ds_read_b128 a[44:47], v23 offset:18432
		ds_read_b128 a[48:51], v23 offset:19456
		ds_read_b128 a[52:55], v23 offset:20480
		ds_read_b128 a[56:59], v23 offset:21504
		ds_read_b128 a[60:63], v23 offset:22528
		ds_read_b128 a[64:67], v23 offset:23552
		ds_read_b128 a[68:71], v25 offset:32768
		ds_read_b128 a[72:75], v25 offset:33792
		ds_read_b128 a[76:79], v25 offset:34816
		ds_read_b128 a[80:83], v25 offset:35840
		ds_read_b128 a[84:87], v25 offset:36864
		ds_read_b128 a[88:91], v25 offset:37888
		ds_read_b128 a[92:95], v25 offset:38912
		ds_read_b128 a[96:99], v25 offset:39936
		ds_read_b128 a[100:103], v25 offset:49152
		ds_read_b128 a[104:107], v25 offset:50176
		ds_read_b128 a[108:111], v25 offset:51200
		ds_read_b128 a[112:115], v25 offset:52224
		ds_read_b128 a[116:119], v25 offset:53248
		ds_read_b128 a[120:123], v25 offset:54272
		ds_read_b128 a[124:127], v25 offset:55296
		ds_read_b128 a[128:131], v25 offset:56320
		s_add_i32 s2, s12, 0x14000
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
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
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
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
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
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
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
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s3, s33, 1
		s_lshl_b32 s3, s3, 13
		s_add_i32 s4, s3, 0x20000
		v_add_u32_e32 v2, s4, v15
		v_add_u32_e32 v3, v2, v19
		ds_read_b64_tr_b8 v[42:43], v3
		ds_read_b64_tr_b8 v[236:237], v3 offset:512
		s_waitcnt vmcnt(22)
		v_add3_u32 v20, s4, v19, v18
		s_waitcnt vmcnt(19)
		ds_read_b64_tr_b8 v[238:239], v20 offset:2048
		s_waitcnt vmcnt(18)
		ds_read_b64_tr_b8 v[240:241], v3 offset:4096
		s_waitcnt vmcnt(17)
		ds_read_b64_tr_b8 v[242:243], v3 offset:4608
		s_waitcnt vmcnt(16)
		ds_read_b64_tr_b8 v[244:245], v20 offset:6144
		ds_read_b64_tr_b8 v[246:247], v20 offset:2560
		ds_read_b64_tr_b8 v[248:249], v20 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v42, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[72:75], v[44:47], v42, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[76:79], v[48:51], v42, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[80:83], v[52:55], v42, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[80:83], v[84:87], v42, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_lshl_b32 s4, s33, 15
		s_add_i32 s5, s1, s4
		s_add_i32 s6, s0, s4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[68:71], v[72:75], v42, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s12, s3, 0x20200
		s_add_i32 s13, s3, 0x21000
		s_add_i32 s14, s3, 0x21200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[72:75], v[76:79], v42, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[76:79], v[80:83], v42, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[76:79], v[112:115], v42, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[68:71], v[104:107], v42, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[72:75], v[108:111], v42, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[80:83], v[116:119], v42, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[80:83], v[148:151], v42, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[68:71], v[136:139], v42, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[72:75], v[140:143], v42, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[76:79], v[144:147], v42, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[68:71], v[168:171], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[72:75], v[172:175], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[76:79], v[176:179], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[80:83], v[180:183], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[24:27], a[80:83], v[200:203], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[68:71], v[188:191], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[72:75], v[192:195], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[76:79], v[196:199], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[76:79], v[212:215], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[68:71], v[204:207], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[72:75], v[208:211], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[28:31], a[80:83], v[216:219], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[32:35], a[80:83], v[232:235], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[68:71], v[220:223], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[72:75], v[224:227], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[76:79], v[228:231], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[36:39], a[100:103], v[4:7], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[104:107], v[44:47], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[108:111], v[48:51], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[112:115], v[52:55], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[112:115], v[84:87], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[100:103], v[72:75], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[104:107], v[76:79], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[108:111], v[80:83], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[108:111], v[112:115], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[100:103], v[104:107], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[104:107], v[108:111], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[112:115], v[116:119], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[112:115], v[148:151], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[100:103], v[136:139], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[104:107], v[140:143], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[108:111], v[144:147], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[100:103], v[168:171], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[104:107], v[172:175], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[108:111], v[176:179], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[112:115], v[180:183], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[112:115], v[200:203], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[100:103], v[188:191], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[104:107], v[192:195], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[108:111], v[196:199], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[108:111], v[212:215], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[100:103], v[204:207], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[104:107], v[208:211], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[60:63], a[112:115], v[216:219], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[112:115], v[232:235], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[100:103], v[220:223], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[104:107], v[224:227], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[108:111], v[228:231], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v3, v11, s[20:23], s5 offen
		buffer_load_dword v20, v11, s[20:23], s5 offen offset:64
		buffer_load_dword v23, v11, s[20:23], s6 offen
		buffer_load_dword v25, v11, s[20:23], s6 offen offset:64
		v_add3_u32 v41, v2, v16, v14
		v_add3_u32 v43, v14, v17, s12
		v_add3_u32 v237, v14, v17, s13
		v_add3_u32 v238, v14, v17, s14
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[44:45]
		s_add_i32 s5, s43, s4
		s_add_i32 s4, s2, s4
		s_add_i32 s6, s3, 0x20800
		v_lshl_add_u32 v2, v9, 7, s6
		s_add_i32 s6, s3, 0x20a00
		s_add_i32 s12, s3, 0x21800
		s_add_i32 s3, s3, 0x21a00
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v239, v12, s[16:19], s5 offen
		buffer_load_dword v241, v12, s[16:19], s5 offen offset:64
		buffer_load_dword v243, v12, s[16:19], s4 offen
		buffer_load_dword v244, v12, s[16:19], s4 offen offset:64
		v_add3_u32 v245, v2, v14, v18
		v_add3_u32 v250, v18, v0, s6
		v_add3_u32 v251, v18, v0, s12
		v_add3_u32 v252, v18, v0, s3
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[44:45]
		s_mov_b32 m0, s7
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[84:87], v[56:59], v42, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[88:91], v[60:63], v42, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[92:95], v[64:67], v42, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[96:99], v[68:71], v42, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[96:99], v[100:103], v42, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[84:87], v[88:91], v42, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[88:91], v[92:95], v42, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[92:95], v[96:99], v42, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[92:95], v[128:131], v42, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v28, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[84:87], v[120:123], v42, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[88:91], v[124:127], v42, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[96:99], v[132:135], v42, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[96:99], v[164:167], v42, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[84:87], v[152:155], v42, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[88:91], v[156:159], v42, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[92:95], v[160:163], v42, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v236, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[84:87], v[184:187], v236, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v236, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v236, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v236, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v236, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v236, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v236, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v236, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v32, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v236, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v236, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v236, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v236, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v236, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v236, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v236, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[116:119], v[56:59], v240, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[120:123], v[60:63], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[124:127], v[64:67], v240, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[128:131], v[68:71], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v21, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[128:131], v[100:103], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[116:119], v[88:91], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[120:123], v[92:95], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[124:127], v[96:99], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[124:127], v[128:131], v240, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[116:119], v[120:123], v240, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[120:123], v[124:127], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[128:131], v[132:135], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v37, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[128:131], v[164:167], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[116:119], v[152:155], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[120:123], v[156:159], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[124:127], v[160:163], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v39, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v242, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[52:55], a[116:119], v[184:187], v242, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v242, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v242, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v242, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v242, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v242, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v242, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v242, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v242, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v242, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v242, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v242, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v242, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v242, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v242, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v41, v3
		ds_write_b32 v43, v20
		ds_write_b32 v237, v23
		ds_write_b32 v238, v25
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[44:45], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v245, v239
		ds_write_b32 v250, v241
		ds_write_b32 v251, v243
		ds_write_b32 v252, v244
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[44:45]
		s_add_i32 m0, s7, 0x9000
		s_add_i32 s3, s7, 0x10000
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_add_i32 s33, s33, 1
		s_add_i32 m0, m0, 0x2000
		s_and_b32 s4, s33, 1
		s_lshl_b32 s4, s4, 16
		v_add_u32_e32 v2, s4, v10
		buffer_load_dwordx4 v36, s[24:27], 0 offen lds
		v_add3_u32 v2, v2, v13, v22
		s_add_i32 m0, m0, 0x2000
		s_waitcnt vmcnt(21)
		v_add_u32_e32 v3, s4, v13
		s_and_b32 s7, s3, 0x1ffff
		buffer_load_dwordx4 v38, s[24:27], 0 offen lds
		s_add_u32 s8, s8, 0x80
		s_addc_u32 s9, s9, 0
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v3, v3, v24, v22
		buffer_load_dwordx4 v40, s[24:27], 0 offen lds
		s_add_u32 s24, s24, 0x80
		s_addc_u32 s25, s25, 0
		s_cmp_lt_i32 s33, 30
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
		ds_read_b128 a[68:71], v3 offset:32768
		ds_read_b128 a[72:75], v3 offset:33792
		ds_read_b128 a[76:79], v3 offset:34816
		ds_read_b128 a[80:83], v3 offset:35840
		ds_read_b128 a[84:87], v3 offset:36864
		ds_read_b128 a[88:91], v3 offset:37888
		ds_read_b128 a[92:95], v3 offset:38912
		ds_read_b128 a[96:99], v3 offset:39936
		ds_read_b128 a[100:103], v3 offset:49152
		ds_read_b128 a[104:107], v3 offset:50176
		ds_read_b128 a[108:111], v3 offset:51200
		ds_read_b128 a[112:115], v3 offset:52224
		ds_read_b128 a[116:119], v3 offset:53248
		ds_read_b128 a[120:123], v3 offset:54272
		ds_read_b128 a[124:127], v3 offset:55296
		ds_read_b128 a[128:131], v3 offset:56320
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v0, a0
		v_add_u32_e32 v0, v0, v19
		ds_read_b64_tr_b8 v[2:3], v0
		ds_read_b64_tr_b8 v[14:15], v0 offset:512
		v_add_u32_e32 v9, 0x20000, v19
		v_lshl_add_u32 v8, v8, 10, v9
		ds_read_b64_tr_b8 v[16:17], v8 offset:2048
		ds_read_b64_tr_b8 v[20:21], v8 offset:2560
		ds_read_b64_tr_b8 v[26:27], v0 offset:4096
		ds_read_b64_tr_b8 v[28:29], v0 offset:4608
		ds_read_b64_tr_b8 v[30:31], v8 offset:6144
		ds_read_b64_tr_b8 v[32:33], v8 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v2, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[72:75], v[44:47], v2, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[76:79], v[48:51], v2, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[80:83], v[52:55], v2, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[84:87], v[56:59], v2, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[88:91], v[60:63], v2, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[92:95], v[64:67], v2, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[96:99], v[68:71], v2, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[96:99], v[100:103], v2, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[84:87], v[88:91], v2, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[88:91], v[92:95], v2, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[92:95], v[96:99], v2, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[92:95], v[128:131], v2, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[84:87], v[120:123], v2, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[88:91], v[124:127], v2, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[96:99], v[132:135], v2, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[96:99], v[164:167], v2, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[84:87], v[152:155], v2, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[88:91], v[156:159], v2, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[92:95], v[160:163], v2, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[68:71], v[136:139], v2, v16 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[68:71], v[72:75], v2, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[72:75], v[76:79], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[76:79], v[80:83], v2, v16 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[80:83], v[84:87], v2, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[80:83], v[116:119], v2, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[68:71], v[104:107], v2, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[72:75], v[108:111], v2, v16 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[76:79], v[112:115], v2, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[76:79], v[144:147], v2, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[72:75], v[140:143], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[80:83], v[148:151], v2, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[68:71], v[168:171], v14, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[72:75], v[172:175], v14, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[76:79], v[176:179], v14, v16 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[80:83], v[180:183], v14, v16 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[24:27], a[80:83], v[200:203], v14, v16 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[68:71], v[188:191], v14, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[72:75], v[192:195], v14, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[76:79], v[196:199], v14, v16 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[76:79], v[212:215], v14, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[68:71], v[204:207], v14, v16 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[72:75], v[208:211], v14, v16 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[28:31], a[80:83], v[216:219], v14, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[32:35], a[80:83], v[232:235], v14, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[68:71], v[220:223], v14, v16 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[72:75], v[224:227], v14, v16 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[76:79], v[228:231], v14, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[84:87], v[184:187], v14, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v14, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v14, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v14, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[36:39], a[100:103], v[4:7], v26, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[104:107], v[44:47], v26, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[108:111], v[48:51], v26, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[112:115], v[52:55], v26, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[116:119], v[56:59], v26, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[120:123], v[60:63], v26, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[124:127], v[64:67], v26, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[128:131], v[68:71], v26, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[128:131], v[100:103], v26, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[116:119], v[88:91], v26, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[120:123], v[92:95], v26, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[124:127], v[96:99], v26, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[124:127], v[128:131], v26, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[116:119], v[120:123], v26, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[120:123], v[124:127], v26, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[128:131], v[132:135], v26, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[128:131], v[164:167], v26, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[116:119], v[152:155], v26, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[120:123], v[156:159], v26, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[124:127], v[160:163], v26, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[100:103], v[136:139], v26, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[100:103], v[72:75], v26, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[104:107], v[76:79], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[108:111], v[80:83], v26, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[112:115], v[84:87], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[112:115], v[116:119], v26, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[100:103], v[104:107], v26, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[104:107], v[108:111], v26, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[108:111], v[112:115], v26, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[108:111], v[144:147], v26, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[104:107], v[140:143], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[112:115], v[148:151], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[100:103], v[168:171], v28, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[104:107], v[172:175], v28, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[108:111], v[176:179], v28, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[112:115], v[180:183], v28, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[112:115], v[200:203], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[100:103], v[188:191], v28, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[104:107], v[192:195], v28, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[108:111], v[196:199], v28, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[108:111], v[212:215], v28, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[100:103], v[204:207], v28, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[104:107], v[208:211], v28, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[60:63], a[112:115], v[216:219], v28, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[112:115], v[232:235], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[100:103], v[220:223], v28, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[104:107], v[224:227], v28, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[108:111], v[228:231], v28, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v28, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[52:55], a[116:119], v[184:187], v28, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v28, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v28, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v28, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v28, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v28, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v28, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v28, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v28, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v28, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v28, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v10
		v_add3_u32 v2, v2, v13, v22
		ds_read_b128 v[28:31], v2
		ds_read_b128 a[4:7], v2 offset:1024
		ds_read_b128 a[8:11], v2 offset:2048
		ds_read_b128 a[12:15], v2 offset:3072
		ds_read_b128 a[16:19], v2 offset:4096
		ds_read_b128 a[20:23], v2 offset:5120
		ds_read_b128 a[24:27], v2 offset:6144
		ds_read_b128 a[28:31], v2 offset:7168
		ds_read_b128 a[32:35], v2 offset:16384
		ds_read_b128 a[36:39], v2 offset:17408
		ds_read_b128 a[40:43], v2 offset:18432
		ds_read_b128 a[44:47], v2 offset:19456
		ds_read_b128 a[48:51], v2 offset:20480
		ds_read_b128 a[52:55], v2 offset:21504
		ds_read_b128 a[56:59], v2 offset:22528
		ds_read_b128 a[60:63], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v13
		v_add3_u32 v2, v2, v24, v22
		ds_read_b128 v[12:15], v2 offset:32768
		ds_read_b128 v[20:23], v2 offset:33792
		ds_read_b128 v[24:27], v2 offset:34816
		ds_read_b128 v[32:35], v2 offset:35840
		ds_read_b128 a[64:67], v2 offset:36864
		ds_read_b128 a[68:71], v2 offset:37888
		ds_read_b128 a[72:75], v2 offset:38912
		ds_read_b128 a[76:79], v2 offset:39936
		ds_read_b128 v[36:39], v2 offset:49152
		ds_read_b128 v[40:43], v2 offset:50176
		ds_read_b128 v[236:239], v2 offset:51200
		ds_read_b128 v[240:243], v2 offset:52224
		ds_read_b128 a[80:83], v2 offset:53248
		ds_read_b128 a[84:87], v2 offset:54272
		ds_read_b128 a[88:91], v2 offset:55296
		ds_read_b128 a[92:95], v2 offset:56320
		v_accvgpr_read_b32 v2, a2
		v_add_u32_e32 v2, v2, v19
		v_accvgpr_read_b32 v3, a1
		v_cmp_lt_u32_e64 vcc, v3, s39
		s_mov_b64 s[0:1], vcc
		v_accvgpr_read_b32 v3, a2
		v_lshl_add_u32 v1, v1, 4, v3
		s_mov_b32 s2, 0x5000
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v0 offset:8192
		ds_read_b64_tr_b8 v[16:17], v0 offset:8704
		ds_read_b64_tr_b8 v[18:19], v8 offset:10240
		ds_read_b64_tr_b8 v[244:245], v8 offset:10752
		ds_read_b64_tr_b8 v[246:247], v0 offset:12288
		ds_read_b64_tr_b8 v[248:249], v0 offset:12800
		ds_read_b64_tr_b8 v[250:251], v8 offset:14336
		ds_read_b64_tr_b8 v[252:253], v8 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[28:31], v[12:15], v[4:7], v10, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[28:31], v[20:23], v[44:47], v10, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[28:31], v[24:27], v[48:51], v10, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[28:31], v[32:35], v[52:55], v10, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[4:7], v[32:35], v[84:87], v10, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[4:7], v[12:15], v[72:75], v10, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[4:7], v[20:23], v[76:79], v10, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[4:7], v[24:27], v[80:83], v10, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[8:11], v[24:27], v[112:115], v10, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[8:11], v[12:15], v[104:107], v10, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[8:11], v[20:23], v[108:111], v10, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[8:11], v[32:35], v[116:119], v10, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[12:15], v[32:35], v[148:151], v10, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[12:15], v[12:15], v[136:139], v10, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[12:15], v[20:23], v[140:143], v10, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[12:15], v[24:27], v[144:147], v10, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[16:19], v[12:15], v[168:171], v16, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[16:19], v[20:23], v[172:175], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[16:19], v[24:27], v[176:179], v16, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[16:19], v[32:35], v[180:183], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[20:23], v[32:35], v[200:203], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[20:23], v[12:15], v[188:191], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[20:23], v[20:23], v[192:195], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[20:23], v[24:27], v[196:199], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[24:27], v[24:27], v[212:215], v16, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[24:27], v[12:15], v[204:207], v16, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[24:27], v[20:23], v[208:211], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[24:27], v[32:35], v[216:219], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[28:31], v[32:35], v[232:235], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[28:31], v[12:15], v[220:223], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[28:31], v[20:23], v[224:227], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[28:31], v[24:27], v[228:231], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[32:35], v[36:39], v[4:7], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[32:35], v[40:43], v[44:47], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[32:35], v[236:239], v[48:51], v246, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[32:35], v[240:243], v[52:55], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[36:39], v[240:243], v[84:87], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[36:39], v[36:39], v[72:75], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[36:39], v[40:43], v[76:79], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[36:39], v[236:239], v[80:83], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[40:43], v[236:239], v[112:115], v246, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[40:43], v[36:39], v[104:107], v246, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[40:43], v[40:43], v[108:111], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[40:43], v[240:243], v[116:119], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[44:47], v[240:243], v[148:151], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[44:47], v[36:39], v[136:139], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[44:47], v[40:43], v[140:143], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[44:47], v[236:239], v[144:147], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[48:51], v[36:39], v[168:171], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[48:51], v[40:43], v[172:175], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[48:51], v[236:239], v[176:179], v248, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[48:51], v[240:243], v[180:183], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[52:55], v[240:243], v[200:203], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[52:55], v[36:39], v[188:191], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[52:55], v[40:43], v[192:195], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[52:55], v[236:239], v[196:199], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[56:59], v[236:239], v[212:215], v248, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[56:59], v[36:39], v[204:207], v248, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[56:59], v[40:43], v[208:211], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[56:59], v[240:243], v[216:219], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[60:63], v[240:243], v[232:235], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[60:63], v[36:39], v[220:223], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[60:63], v[40:43], v[224:227], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[60:63], v[236:239], v[228:231], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_cvt_pk_f16_f32 v8, v4, v5
		v_cvt_pk_f16_f32 v9, v6, v7
		v_cvt_pk_f16_f32 v4, v44, v45
		v_cvt_pk_f16_f32 v5, v46, v47
		ds_write2st64_b64 v2, v[8:9], v[4:5] offset1:1
		v_cvt_pk_f16_f32 v4, v48, v49
		v_cvt_pk_f16_f32 v5, v50, v51
		v_cvt_pk_f16_f32 v6, v52, v53
		v_cvt_pk_f16_f32 v7, v54, v55
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:2 offset1:3
		v_cvt_pk_f16_f32 v4, v72, v73
		v_cvt_pk_f16_f32 v5, v74, v75
		v_cvt_pk_f16_f32 v6, v76, v77
		v_cvt_pk_f16_f32 v7, v78, v79
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:8 offset1:9
		v_cvt_pk_f16_f32 v4, v80, v81
		v_cvt_pk_f16_f32 v5, v82, v83
		v_cvt_pk_f16_f32 v6, v84, v85
		v_cvt_pk_f16_f32 v7, v86, v87
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:10 offset1:11
		v_cvt_pk_f16_f32 v4, v104, v105
		v_cvt_pk_f16_f32 v5, v106, v107
		v_cvt_pk_f16_f32 v6, v108, v109
		v_cvt_pk_f16_f32 v7, v110, v111
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:16 offset1:17
		v_cvt_pk_f16_f32 v4, v112, v113
		v_cvt_pk_f16_f32 v5, v114, v115
		v_cvt_pk_f16_f32 v6, v116, v117
		v_cvt_pk_f16_f32 v7, v118, v119
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:18 offset1:19
		v_cvt_pk_f16_f32 v4, v136, v137
		v_cvt_pk_f16_f32 v5, v138, v139
		v_cvt_pk_f16_f32 v6, v140, v141
		v_cvt_pk_f16_f32 v7, v142, v143
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:24 offset1:25
		v_cvt_pk_f16_f32 v4, v144, v145
		v_cvt_pk_f16_f32 v5, v146, v147
		v_cvt_pk_f16_f32 v6, v148, v149
		v_cvt_pk_f16_f32 v7, v150, v151
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:26 offset1:27
		v_cvt_pk_f16_f32 v4, v168, v169
		v_cvt_pk_f16_f32 v5, v170, v171
		v_cvt_pk_f16_f32 v6, v172, v173
		v_cvt_pk_f16_f32 v7, v174, v175
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:32 offset1:33
		v_cvt_pk_f16_f32 v4, v176, v177
		v_cvt_pk_f16_f32 v5, v178, v179
		v_cvt_pk_f16_f32 v6, v180, v181
		v_cvt_pk_f16_f32 v7, v182, v183
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:34 offset1:35
		v_cvt_pk_f16_f32 v4, v188, v189
		v_cvt_pk_f16_f32 v5, v190, v191
		v_cvt_pk_f16_f32 v6, v192, v193
		v_cvt_pk_f16_f32 v7, v194, v195
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:40 offset1:41
		v_cvt_pk_f16_f32 v4, v196, v197
		v_cvt_pk_f16_f32 v5, v198, v199
		v_cvt_pk_f16_f32 v6, v200, v201
		v_cvt_pk_f16_f32 v7, v202, v203
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:42 offset1:43
		v_cvt_pk_f16_f32 v4, v204, v205
		v_cvt_pk_f16_f32 v5, v206, v207
		v_cvt_pk_f16_f32 v6, v208, v209
		v_cvt_pk_f16_f32 v7, v210, v211
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:48 offset1:49
		v_cvt_pk_f16_f32 v4, v212, v213
		v_cvt_pk_f16_f32 v5, v214, v215
		v_cvt_pk_f16_f32 v6, v216, v217
		v_cvt_pk_f16_f32 v7, v218, v219
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:50 offset1:51
		v_cvt_pk_f16_f32 v4, v220, v221
		v_cvt_pk_f16_f32 v5, v222, v223
		v_cvt_pk_f16_f32 v6, v224, v225
		v_cvt_pk_f16_f32 v7, v226, v227
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:56 offset1:57
		v_cvt_pk_f16_f32 v4, v228, v229
		v_cvt_pk_f16_f32 v5, v230, v231
		v_cvt_pk_f16_f32 v6, v232, v233
		v_cvt_pk_f16_f32 v7, v234, v235
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:58 offset1:59
		s_mov_b32 s3, 0x6000
		s_mov_b32 s4, 0x7000
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[44:45], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[4:7], v1
		ds_read_b128 v[12:15], v1 offset:512
		ds_read_b128 v[20:23], v1 offset:1024
		ds_read_b128 v[24:27], v1 offset:1536
		ds_read_b128 v[32:35], v1 offset:4096
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], 0 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], 0 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], 0 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], 0 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s32 offen
		ds_read_b128 v[4:7], v1 offset:4608
		ds_read_b128 v[12:15], v1 offset:5120
		ds_read_b128 v[20:23], v1 offset:5632
		ds_read_b128 v[24:27], v1 offset:8192
		ds_read_b128 v[32:35], v1 offset:8704
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s32 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s32 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s32 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], s38 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s38 offen offset:512
		ds_read_b128 v[4:7], v1 offset:9216
		ds_read_b128 v[12:15], v1 offset:9728
		ds_read_b128 v[20:23], v1 offset:12288
		ds_read_b128 v[24:27], v1 offset:12800
		ds_read_b128 v[32:35], v1 offset:13312
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s38 offen offset:1024
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s38 offen offset:1536
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s15 offen
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], s15 offen offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s15 offen offset:1024
		ds_read_b128 v[4:7], v1 offset:13824
		ds_read_b128 v[12:15], v1 offset:16384
		ds_read_b128 v[20:23], v1 offset:16896
		ds_read_b128 v[24:27], v1 offset:17408
		ds_read_b128 v[32:35], v1 offset:17920
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s15 offen offset:1536
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s35 offen
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s35 offen offset:512
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], s35 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s35 offen offset:1536
		ds_read_b128 v[4:7], v1 offset:20480
		ds_read_b128 v[12:15], v1 offset:20992
		ds_read_b128 v[20:23], v1 offset:21504
		ds_read_b128 v[24:27], v1 offset:22016
		ds_read_b128 v[32:35], v1 offset:24576
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s2 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s2 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s2 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], s2 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s3 offen
		ds_read_b128 v[4:7], v1 offset:25088
		ds_read_b128 v[12:15], v1 offset:25600
		ds_read_b128 v[20:23], v1 offset:26112
		ds_read_b128 v[24:27], v1 offset:28672
		ds_read_b128 v[32:35], v1 offset:29184
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s3 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s3 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s3 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v1, s[28:31], s4 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[32:35], v1, s[28:31], s4 offen offset:512
		ds_read_b128 v[4:7], v1 offset:29696
		ds_read_b128 v[12:15], v1 offset:30208
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s4 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s4 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[44:45]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[28:31], a[64:67], v[56:59], v10, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[28:31], a[68:71], v[60:63], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[28:31], a[72:75], v[64:67], v10, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[28:31], a[76:79], v[68:71], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[4:7], a[76:79], v[100:103], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[4:7], a[64:67], v[88:91], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[4:7], a[68:71], v[92:95], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[4:7], a[72:75], v[96:99], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[8:11], a[72:75], v[128:131], v10, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[8:11], a[64:67], v[120:123], v10, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[8:11], a[68:71], v[124:127], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[8:11], a[76:79], v[132:135], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[12:15], a[76:79], v[164:167], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[12:15], a[64:67], v[152:155], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[12:15], a[68:71], v[156:159], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[12:15], a[72:75], v[160:163], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[16:19], a[72:75], a[136:139], v16, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[16:19], a[64:67], v[184:187], v16, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[16:19], a[68:71], a[132:135], v16, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[16:19], a[76:79], a[140:143], v16, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[20:23], a[76:79], a[156:159], v16, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[20:23], a[64:67], a[144:147], v16, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[20:23], a[68:71], a[148:151], v16, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[20:23], a[72:75], a[152:155], v16, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[24:27], a[72:75], a[168:171], v16, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[24:27], a[64:67], a[160:163], v16, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[24:27], a[68:71], a[164:167], v16, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[24:27], a[76:79], a[172:175], v16, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[28:31], a[76:79], a[188:191], v16, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[28:31], a[64:67], a[176:179], v16, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[28:31], a[68:71], a[180:183], v16, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[28:31], a[72:75], a[184:187], v16, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[32:35], a[80:83], v[56:59], v246, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[32:35], a[84:87], v[60:63], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[32:35], a[88:91], v[64:67], v246, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[32:35], a[92:95], v[68:71], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[36:39], a[92:95], v[100:103], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[36:39], a[80:83], v[88:91], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[36:39], a[84:87], v[92:95], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[36:39], a[88:91], v[96:99], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[40:43], a[88:91], v[128:131], v246, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v56, v57
		v_cvt_pk_f16_f32 v5, v58, v59
		v_cvt_pk_f16_f32 v6, v60, v61
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[40:43], a[80:83], v[120:123], v246, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v7, v62, v63
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:4 offset1:5
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[40:43], a[84:87], v[124:127], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[40:43], a[92:95], v[132:135], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[44:47], a[92:95], v[164:167], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[44:47], a[80:83], v[152:155], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[44:47], a[84:87], v[156:159], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[44:47], a[88:91], v[160:163], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[48:51], a[88:91], a[136:139], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[48:51], a[80:83], v[184:187], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[48:51], a[84:87], a[132:135], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[48:51], a[92:95], a[140:143], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[52:55], a[92:95], a[156:159], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[52:55], a[80:83], a[144:147], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[52:55], a[84:87], a[148:151], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[52:55], a[88:91], a[152:155], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[56:59], a[88:91], a[168:171], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[56:59], a[80:83], a[160:163], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[56:59], a[84:87], a[164:167], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[56:59], a[92:95], a[172:175], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[60:63], a[92:95], a[188:191], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[60:63], a[80:83], a[176:179], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[60:63], a[84:87], a[180:183], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[60:63], a[88:91], a[184:187], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v64, v65
		v_cvt_pk_f16_f32 v5, v66, v67
		v_cvt_pk_f16_f32 v6, v68, v69
		v_cvt_pk_f16_f32 v7, v70, v71
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:6 offset1:7
		v_cvt_pk_f16_f32 v4, v88, v89
		v_cvt_pk_f16_f32 v5, v90, v91
		v_cvt_pk_f16_f32 v6, v92, v93
		v_cvt_pk_f16_f32 v7, v94, v95
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:12 offset1:13
		v_cvt_pk_f16_f32 v4, v96, v97
		v_cvt_pk_f16_f32 v5, v98, v99
		v_cvt_pk_f16_f32 v6, v100, v101
		v_cvt_pk_f16_f32 v7, v102, v103
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:14 offset1:15
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		v_cvt_pk_f16_f32 v6, v124, v125
		v_cvt_pk_f16_f32 v7, v126, v127
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:20 offset1:21
		v_cvt_pk_f16_f32 v4, v128, v129
		v_cvt_pk_f16_f32 v5, v130, v131
		v_cvt_pk_f16_f32 v6, v132, v133
		v_cvt_pk_f16_f32 v7, v134, v135
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:22 offset1:23
		v_cvt_pk_f16_f32 v4, v152, v153
		v_cvt_pk_f16_f32 v5, v154, v155
		v_cvt_pk_f16_f32 v6, v156, v157
		v_cvt_pk_f16_f32 v7, v158, v159
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:28 offset1:29
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		v_cvt_pk_f16_f32 v6, v164, v165
		v_cvt_pk_f16_f32 v7, v166, v167
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:30 offset1:31
		v_cvt_pk_f16_f32 v4, v184, v185
		v_cvt_pk_f16_f32 v5, v186, v187
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:36 offset1:37
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v3, a137
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v3, a139
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v3, a141
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v3, a143
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:38 offset1:39
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:44 offset1:45
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:46 offset1:47
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:52 offset1:53
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v3, a169
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v3, a171
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v3, a173
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v3, a175
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:54 offset1:55
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v3, a177
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v3, a179
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v3, a181
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v3, a183
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:60 offset1:61
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v3, a185
		v_cvt_pk_f16_f32 v4, v0, v3
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v3, a187
		v_cvt_pk_f16_f32 v5, v0, v3
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v3, a189
		v_cvt_pk_f16_f32 v6, v0, v3
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v3, a191
		v_cvt_pk_f16_f32 v7, v0, v3
		ds_write2st64_b64 v2, v[4:5], v[6:7] offset0:62 offset1:63
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[44:45], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		ds_read_b128 v[4:7], v1 offset:2048
		ds_read_b128 v[8:11], v1 offset:2560
		ds_read_b128 v[12:15], v1 offset:3072
		ds_read_b128 v[16:19], v1 offset:3584
		ds_read_b128 v[20:23], v1 offset:6144
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], 0 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], 0 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], 0 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], 0 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s32 offen offset:2048
		ds_read_b128 v[4:7], v1 offset:6656
		ds_read_b128 v[8:11], v1 offset:7168
		ds_read_b128 v[12:15], v1 offset:7680
		ds_read_b128 v[16:19], v1 offset:10240
		ds_read_b128 v[20:23], v1 offset:10752
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s32 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s32 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s32 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], s38 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s38 offen offset:2560
		ds_read_b128 v[4:7], v1 offset:11264
		ds_read_b128 v[8:11], v1 offset:11776
		ds_read_b128 v[12:15], v1 offset:14336
		ds_read_b128 v[16:19], v1 offset:14848
		ds_read_b128 v[20:23], v1 offset:15360
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s38 offen offset:3072
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s38 offen offset:3584
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s15 offen offset:2048
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], s15 offen offset:2560
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s15 offen offset:3072
		ds_read_b128 v[4:7], v1 offset:15872
		ds_read_b128 v[8:11], v1 offset:18432
		ds_read_b128 v[12:15], v1 offset:18944
		ds_read_b128 v[16:19], v1 offset:19456
		ds_read_b128 v[20:23], v1 offset:19968
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s15 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s35 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s35 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], s35 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s35 offen offset:3584
		ds_read_b128 v[4:7], v1 offset:22528
		ds_read_b128 v[8:11], v1 offset:23040
		ds_read_b128 v[12:15], v1 offset:23552
		ds_read_b128 v[16:19], v1 offset:24064
		ds_read_b128 v[20:23], v1 offset:26624
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s2 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s2 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s2 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], s2 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s3 offen offset:2048
		ds_read_b128 v[4:7], v1 offset:27136
		ds_read_b128 v[8:11], v1 offset:27648
		ds_read_b128 v[12:15], v1 offset:28160
		ds_read_b128 v[16:19], v1 offset:30720
		ds_read_b128 v[20:23], v1 offset:31232
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s3 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s3 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v1, s[28:31], s3 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v1, s[28:31], s4 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v1, s[28:31], s4 offen offset:2560
		ds_read_b128 v[4:7], v1 offset:31744
		ds_read_b128 v[8:11], v1 offset:32256
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[4:7], v1, s[28:31], s4 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v1, s[28:31], s4 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[44:45]
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
		.amdhsa_next_free_sgpr 46
		.amdhsa_accum_offset 256
		.amdhsa_reserve_vcc 1
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 46
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 0
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 1
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
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     448
    .agpr_count:     192
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 74
    wave.regalloc.agpr.dwords: 283
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
