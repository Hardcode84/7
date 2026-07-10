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
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s16, s10
		s_mov_b32 s17, s11
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_mov_b32 s10, 0x1000000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s11, s19
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s10
		s_mov_b32 s3, s19
		s_lshl_b32 s4, s14, 1
		s_lshr_b32 s5, s13, 3
		s_add_i32 s4, s4, s5
		s_and_b32 s5, s13, 7
		s_lshl_b32 s12, s5, 5
		s_add_i32 s4, s4, s12
		s_and_b32 s4, s4, 63
		s_lshr_b32 s12, s4, 2
		s_lshl_b32 s13, s12, 17
		s_lshr_b32 s5, s5, 1
		s_lshl_b32 s14, s5, 23
		s_add_i32 s13, s13, s14
		s_and_b32 s4, s4, 3
		s_lshl_b32 s14, s4, 21
		s_add_i32 s13, s13, s14
		s_add_u32 s24, s6, s13
		s_addc_u32 s25, s7, 0
		s_mov_b32 s26, 0x20000
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s6, s6, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s13, s7, 0x3000
		s_add_i32 s14, s7, 0x4000
		s_add_i32 s15, s7, 0x5000
		s_add_i32 s28, s7, 0x6000
		s_add_i32 s29, s7, 0x7000
		s_add_i32 s30, s7, 0x8000
		s_add_i32 s31, s7, 0x9000
		s_add_i32 s32, s7, 0xa000
		s_add_i32 s33, s7, 0xb000
		s_add_i32 s34, s7, 0xc000
		s_add_i32 s35, s7, 0xd000
		s_add_i32 s36, s7, 0xe000
		s_add_i32 s37, s7, 0xf000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 m0, s7
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshlrev_b32_e32 v3, 12, v3
		v_lshl_add_u32 v3, s6, 16, v3
		v_lshrrev_b32_e32 v8, 3, v2
		v_bitop3_b32 v8, v8, 3, v2 bitop3:0x48
		v_lshl_add_u32 v3, v8, 4, v3
		s_lshl_b32 s6, s5, 22
		s_lshl_b32 s38, s4, 20
		s_add_i32 s39, s6, s38
		v_add_u32_e32 v8, s39, v3
		buffer_load_dwordx4 v8, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x1000
		s_add_i32 s39, s6, 0x40000
		s_add_i32 s39, s39, s38
		v_add_u32_e32 v9, s39, v3
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x2000
		s_add_i32 s39, s6, 0x80000
		v_add_u32_e32 v9, s38, v3
		v_add_u32_e32 v10, s39, v9
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x3000
		s_add_i32 s39, s6, 0xc0000
		v_add_u32_e32 v10, s39, v9
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x4000
		v_add3_u32 v9, s6, 64, v9
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x5000
		v_add_u32_e32 v9, s38, v3
		v_add_u32_e32 v9, s6, v9
		v_add_u32_e32 v10, 0x40040, v9
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x6000
		v_add_u32_e32 v10, 0x80040, v9
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x7000
		v_add_u32_e32 v9, 0xc0040, v9
		v_and_b32_e32 v10, 1, v1
		s_mov_b32 s39, 0
		v_cmp_eq_u32_e64 vcc, v10, s39
		s_mov_b64 s[40:41], vcc
		v_lshrrev_b32_e32 v10, 7, v0
		v_lshlrev_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v12, 4, v2
		v_lshlrev_b32_e32 v13, 12, v12
		v_and_b32_e32 v14, 15, v0
		v_lshlrev_b32_e32 v15, 2, v14
		v_add3_u32 v11, v11, v13, v15
		v_lshlrev_b32_e32 v13, 10, v10
		v_add_u32_e32 v16, 0x20000, v13
		v_accvgpr_write_b32 a0, v16
		v_lshlrev_b32_e32 v16, 7, v12
		v_accvgpr_read_b32 v17, a0
		v_add3_u32 v17, v17, v16, v15
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x8000
		s_lshl_b32 s42, s12, 20
		v_add_u32_e32 v9, s42, v3
		v_add_u32_e32 v18, s42, v3
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x9000
		v_add_u32_e32 v19, 0x40000, v18
		v_add_u32_e32 v20, 0x80000, v18
		v_add_u32_e32 v18, 0xc0000, v18
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xa000
		v_add3_u32 v19, s42, 64, v3
		v_add_u32_e32 v21, s42, v3
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xb000
		v_add_u32_e32 v20, 0x40040, v21
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xc000
		v_add_u32_e32 v18, 0x80040, v21
		v_add_u32_e32 v21, 0xc0040, v21
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xd000
		s_add_i32 s43, s7, 0x1000
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xe000
		s_add_i32 s44, s7, 0x2000
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xf000
		s_lshl_b32 s5, s5, 10
		s_lshl_b32 s4, s4, 8
		s_add_i32 s45, s5, s4
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_add_i32 s46, s5, 0x4000
		s_add_i32 s46, s46, s4
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v18, v11, s[20:23], s45 offen
		buffer_load_dword v19, v11, s[20:23], s45 offen offset:64
		buffer_load_dword v20, v11, s[20:23], s46 offen
		buffer_load_dword v21, v11, s[20:23], s46 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v17, v18, v19 offset1:2
		ds_write2st64_b32 v17, v20, v21 offset0:16 offset1:18
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[52:53]
		v_lshrrev_b32_e32 v18, 1, v1
		v_cmp_eq_u32_e64 vcc, v18, s39
		s_mov_b64 s[46:47], vcc
		v_lshl_add_u32 v18, v12, 12, v15
		v_and_b32_e32 v19, 1, v1
		v_lshl_add_u32 v18, v19, 7, v18
		s_lshl_b32 s12, s12, 8
		s_add_i32 s45, s12, 0x4000
		v_add_u32_e32 v20, 0x20000, v16
		v_add_u32_e32 v20, v20, v15
		v_lshl_add_u32 v20, v19, 10, v20
		s_and_saveexec_b64 s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v21, v18, s[16:19], s12 offen
		buffer_load_dword v22, v18, s[16:19], s12 offen offset:64
		buffer_load_dword v23, v18, s[16:19], s45 offen
		buffer_load_dword v24, v18, s[16:19], s45 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v20, v21, v22 offset0:8 offset1:10
		ds_write2st64_b32 v20, v23, v24 offset0:24 offset1:26
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s45, s5, 0x8000
		s_add_i32 s45, s45, s4
		s_add_i32 s48, s5, 0xc000
		s_add_i32 s48, s48, s4
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v21, v11, s[20:23], s45 offen
		buffer_load_dword v22, v11, s[20:23], s45 offen offset:64
		buffer_load_dword v23, v11, s[20:23], s48 offen
		buffer_load_dword v24, v11, s[20:23], s48 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v17, v21, v22 offset0:32 offset1:34
		ds_write2st64_b32 v17, v23, v24 offset0:48 offset1:50
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s45, s12, 0x8000
		s_add_i32 s48, s12, 0xc000
		s_and_saveexec_b64 s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v17, v18, s[16:19], s45 offen
		buffer_load_dword v21, v18, s[16:19], s45 offen offset:64
		buffer_load_dword v22, v18, s[16:19], s48 offen
		buffer_load_dword v23, v18, s[16:19], s48 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write2st64_b32 v20, v17, v21 offset0:40 offset1:42
		ds_write2st64_b32 v20, v22, v23 offset0:56 offset1:58
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[52:53]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s45, s6, 0x80
		s_add_i32 s45, s45, s38
		v_add_u32_e32 v17, s45, v3
		buffer_load_dwordx4 v17, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x11000
		s_add_i32 s45, s6, 0x40080
		s_add_i32 s45, s45, s38
		v_add_u32_e32 v17, s45, v3
		buffer_load_dwordx4 v17, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		v_add_u32_e32 v17, s38, v3
		v_add_u32_e32 v17, s6, v17
		v_add_u32_e32 v20, 0x80080, v17
		buffer_load_dwordx4 v20, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x13000
		v_add_u32_e32 v20, 0xc0080, v17
		buffer_load_dwordx4 v20, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		v_add_u32_e32 v17, 0xc0, v17
		buffer_load_dwordx4 v17, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x15000
		v_add_u32_e32 v17, s38, v3
		v_add_u32_e32 v17, s6, v17
		v_add_u32_e32 v20, 0x400c0, v17
		buffer_load_dwordx4 v20, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		v_add_u32_e32 v20, 0x800c0, v17
		buffer_load_dwordx4 v20, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x17000
		v_add_u32_e32 v17, 0xc00c0, v17
		v_add_u32_e32 v20, s42, v3
		v_add_u32_e32 v21, 0x80080, v20
		v_add_u32_e32 v22, 0xc0080, v20
		v_add_u32_e32 v20, 0xc0, v20
		v_add_u32_e32 v23, s42, v3
		v_add_u32_e32 v24, 0x400c0, v23
		v_add_u32_e32 v25, 0x800c0, v23
		v_add_u32_e32 v23, 0xc00c0, v23
		v_lshlrev_b32_e32 v10, 13, v10
		v_lshlrev_b32_e32 v26, 6, v14
		v_lshrrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v14, v12, v14, 3 bitop3:0x78
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v27, v10, v26, v14
		v_lshlrev_b32_e32 v28, 13, v19
		v_add3_u32 v29, v26, v28, v14
		v_add_u32_e32 v30, 0x100, v8
		v_add_u32_e32 v31, 0x40100, v8
		buffer_load_dwordx4 v17, s[8:11], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s6, s42, 0x80
		v_add_u32_e32 v17, s6, v3
		v_add_u32_e32 v32, 0x80100, v8
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x19000
		s_add_i32 s6, s42, 0x40080
		v_add_u32_e32 v3, s6, v3
		v_add_u32_e32 v17, 0xc0100, v8
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		v_add_u32_e32 v3, 0x140, v8
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1b000
		v_add_u32_e32 v21, 0x40140, v8
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		v_add_u32_e32 v22, 0x80140, v8
		v_add_u32_e32 v33, 0xc0140, v8
		v_add_u32_e32 v8, 0x100, v9
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1d000
		v_add_u32_e32 v20, 0x40100, v9
		buffer_load_dwordx4 v24, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		v_add_u32_e32 v24, 0x80100, v9
		v_add_u32_e32 v34, 0xc0100, v9
		v_add_u32_e32 v35, 0x140, v9
		v_add_u32_e32 v36, 0x40140, v9
		v_add_u32_e32 v37, 0x80140, v9
		v_add_u32_e32 v38, 0xc0140, v9
		v_lshlrev_b32_e32 v9, 3, v2
		v_lshlrev_b32_e32 v39, 10, v19
		v_add_u32_e32 v40, v13, v16
		v_lshl_add_u32 v41, v12, 7, v15
		buffer_load_dwordx4 v25, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0x1f000
		s_add_i32 s6, s5, 0x10000
		s_add_i32 s6, s6, s4
		s_add_i32 s5, s5, 0x14000
		buffer_load_dwordx4 v23, s[0:3], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		ds_read_b128 a[4:7], v27
		ds_read_b128 a[8:11], v27 offset:1024
		ds_read_b128 a[12:15], v27 offset:2048
		ds_read_b128 a[16:19], v27 offset:3072
		ds_read_b128 a[20:23], v27 offset:4096
		ds_read_b128 a[24:27], v27 offset:5120
		ds_read_b128 a[28:31], v27 offset:6144
		ds_read_b128 a[32:35], v27 offset:7168
		ds_read_b128 a[36:39], v27 offset:16384
		ds_read_b128 a[40:43], v27 offset:17408
		ds_read_b128 a[44:47], v27 offset:18432
		ds_read_b128 a[48:51], v27 offset:19456
		ds_read_b128 a[52:55], v27 offset:20480
		ds_read_b128 a[56:59], v27 offset:21504
		ds_read_b128 a[60:63], v27 offset:22528
		ds_read_b128 a[64:67], v27 offset:23552
		ds_read_b128 a[68:71], v29 offset:32768
		ds_read_b128 a[72:75], v29 offset:33792
		ds_read_b128 a[76:79], v29 offset:34816
		ds_read_b128 a[80:83], v29 offset:35840
		ds_read_b128 a[84:87], v29 offset:36864
		ds_read_b128 a[88:91], v29 offset:37888
		ds_read_b128 a[92:95], v29 offset:38912
		ds_read_b128 a[96:99], v29 offset:39936
		ds_read_b128 a[100:103], v29 offset:49152
		ds_read_b128 a[104:107], v29 offset:50176
		ds_read_b128 a[108:111], v29 offset:51200
		ds_read_b128 a[112:115], v29 offset:52224
		ds_read_b128 a[116:119], v29 offset:53248
		ds_read_b128 a[120:123], v29 offset:54272
		ds_read_b128 a[124:127], v29 offset:55296
		ds_read_b128 a[128:131], v29 offset:56320
		s_add_i32 s4, s5, s4
		s_add_i32 s5, s12, 0x10000
		s_add_i32 s12, s12, 0x14000
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
		s_and_b32 s38, s39, 1
		s_lshl_b32 s38, s38, 13
		s_add_i32 s42, s38, 0x20000
		v_add_u32_e32 v23, s42, v13
		v_add_u32_e32 v25, v23, v9
		s_waitcnt vmcnt(20)
		ds_read_b64_tr_b8 v[42:43], v25
		ds_read_b64_tr_b8 v[236:237], v25 offset:512
		v_add3_u32 v27, s42, v9, v39
		ds_read_b64_tr_b8 v[238:239], v27 offset:2048
		ds_read_b64_tr_b8 v[240:241], v25 offset:4096
		s_waitcnt vmcnt(19)
		ds_read_b64_tr_b8 v[242:243], v25 offset:4608
		s_waitcnt vmcnt(17)
		ds_read_b64_tr_b8 v[244:245], v27 offset:6144
		ds_read_b64_tr_b8 v[246:247], v27 offset:2560
		ds_read_b64_tr_b8 v[248:249], v27 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v42, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[72:75], v[44:47], v42, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[76:79], v[48:51], v42, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[80:83], v[52:55], v42, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[80:83], v[84:87], v42, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[68:71], v[72:75], v42, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		s_lshl_b32 s42, s39, 15
		s_add_i32 s45, s6, s42
		s_add_i32 s48, s4, s42
		s_add_i32 s49, s38, 0x20200
		s_add_i32 s50, s38, 0x21000
		s_add_i32 s51, s38, 0x21200
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v25, v11, s[20:23], s45 offen
		buffer_load_dword v27, v11, s[20:23], s45 offen offset:64
		buffer_load_dword v29, v11, s[20:23], s48 offen
		buffer_load_dword v43, v11, s[20:23], s48 offen offset:64
		v_add3_u32 v237, v23, v16, v15
		v_add3_u32 v238, v15, v40, s49
		v_add3_u32 v239, v15, v40, s50
		v_add3_u32 v241, v15, v40, s51
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s45, s5, s42
		s_add_i32 s42, s12, s42
		s_add_i32 s48, s38, 0x20800
		v_lshl_add_u32 v23, v12, 7, s48
		s_add_i32 s48, s38, 0x20a00
		s_add_i32 s49, s38, 0x21800
		s_add_i32 s38, s38, 0x21a00
		s_and_saveexec_b64 s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v243, v18, s[16:19], s45 offen
		buffer_load_dword v244, v18, s[16:19], s45 offen offset:64
		buffer_load_dword v245, v18, s[16:19], s42 offen
		s_waitcnt vmcnt(23)
		buffer_load_dword v250, v18, s[16:19], s42 offen offset:64
		v_add3_u32 v251, v23, v15, v39
		v_add3_u32 v252, v39, v41, s48
		v_add3_u32 v253, v39, v41, s49
		v_add3_u32 v254, v39, v41, s38
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s7
		s_lshl_b32 s38, s39, 7
		buffer_load_dwordx4 v30, s[8:11], s38 offen lds
		s_mov_b32 m0, s43
		s_add_i32 s42, s33, 0x10000
		buffer_load_dwordx4 v31, s[8:11], s38 offen lds
		s_mov_b32 m0, s44
		s_add_i32 s45, s31, 0x10000
		buffer_load_dwordx4 v32, s[8:11], s38 offen lds
		s_mov_b32 m0, s13
		s_add_i32 s48, s36, 0x10000
		buffer_load_dwordx4 v17, s[8:11], s38 offen lds
		s_mov_b32 m0, s14
		s_add_i32 s49, s34, 0x10000
		buffer_load_dwordx4 v3, s[8:11], s38 offen lds
		s_mov_b32 m0, s15
		s_add_i32 s50, s32, 0x10000
		buffer_load_dwordx4 v21, s[8:11], s38 offen lds
		s_mov_b32 m0, s28
		s_add_i32 s51, s30, 0x10000
		buffer_load_dwordx4 v22, s[8:11], s38 offen lds
		s_mov_b32 m0, s29
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[84:87], v[56:59], v42, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[88:91], v[60:63], v42, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[92:95], v[64:67], v42, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[96:99], v[68:71], v42, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[96:99], v[100:103], v42, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[84:87], v[88:91], v42, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[88:91], v[92:95], v42, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[92:95], v[96:99], v42, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[92:95], v[128:131], v42, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[84:87], v[120:123], v42, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[88:91], v[124:127], v42, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[96:99], v[132:135], v42, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[96:99], v[164:167], v42, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[84:87], v[152:155], v42, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[88:91], v[156:159], v42, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[92:95], v[160:163], v42, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v236, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[84:87], v[184:187], v236, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[8:11], s38 offen lds
		s_mov_b32 m0, s30
		s_add_i32 s29, s29, 0x10000
		buffer_load_dwordx4 v8, s[0:3], s38 offen lds
		s_mov_b32 m0, s32
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v236, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[0:3], s38 offen lds
		s_mov_b32 m0, s34
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v236, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v35, s[0:3], s38 offen lds
		s_mov_b32 m0, s36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v236, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v37, s[0:3], s38 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v236, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v236, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v236, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v236, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v236, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v236, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v236, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v236, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v236, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v236, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v236, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[116:119], v[56:59], v240, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[120:123], v[60:63], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[124:127], v[64:67], v240, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[128:131], v[68:71], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[128:131], v[100:103], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[116:119], v[88:91], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[120:123], v[92:95], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[124:127], v[96:99], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[124:127], v[128:131], v240, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[116:119], v[120:123], v240, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[120:123], v[124:127], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[128:131], v[132:135], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[128:131], v[164:167], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[116:119], v[152:155], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[120:123], v[156:159], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[124:127], v[160:163], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v237, v25
		ds_write_b32 v238, v27
		ds_write_b32 v239, v29
		ds_write_b32 v241, v43
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[52:53]
		s_and_saveexec_b64 s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v251, v243
		ds_write_b32 v252, v244
		ds_write_b32 v253, v245
		ds_write_b32 v254, v250
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[52:53], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s31
		s_add_i32 s28, s28, 0x10000
		buffer_load_dwordx4 v20, s[0:3], s38 offen lds
		s_add_i32 s30, s44, 0x10000
		s_mov_b32 m0, s33
		s_add_i32 s15, s15, 0x10000
		buffer_load_dwordx4 v34, s[0:3], s38 offen lds
		s_add_i32 s31, s43, 0x10000
		s_mov_b32 m0, s35
		s_add_i32 s14, s14, 0x10000
		buffer_load_dwordx4 v36, s[0:3], s38 offen lds
		s_add_i32 s7, s7, 0x10000
		s_mov_b32 m0, s37
		s_add_i32 s13, s13, 0x10000
		buffer_load_dwordx4 v38, s[0:3], s38 offen lds
		s_add_i32 s39, s39, 1
		s_and_b32 s32, s39, 1
		s_lshl_b32 s32, s32, 16
		v_add_u32_e32 v23, s32, v10
		v_add3_u32 v23, v23, v26, v14
		s_waitcnt vmcnt(23)
		v_add_u32_e32 v25, s32, v26
		v_add3_u32 v25, v25, v28, v14
		s_and_b32 s7, s7, 0x1ffff
		s_and_b32 s43, s31, 0x1ffff
		s_and_b32 s44, s30, 0x1ffff
		s_and_b32 s13, s13, 0x1ffff
		s_and_b32 s14, s14, 0x1ffff
		s_and_b32 s15, s15, 0x1ffff
		s_and_b32 s28, s28, 0x1ffff
		s_and_b32 s29, s29, 0x1ffff
		s_and_b32 s30, s51, 0x1ffff
		s_and_b32 s32, s50, 0x1ffff
		s_and_b32 s34, s49, 0x1ffff
		s_and_b32 s36, s48, 0x1ffff
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
		s_and_b32 s31, s45, 0x1ffff
		s_and_b32 s33, s42, 0x1ffff
		s_add_i32 s35, s35, 0x10000
		s_and_b32 s35, s35, 0x1ffff
		s_add_i32 s37, s37, 0x10000
		s_and_b32 s37, s37, 0x1ffff
		s_cmp_lt_i32 s39, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v3, a0
		v_add_u32_e32 v3, v3, v9
		ds_read_b64_tr_b8 v[12:13], v3
		ds_read_b64_tr_b8 v[16:17], v3 offset:512
		v_add_u32_e32 v8, 0x20000, v9
		v_lshl_add_u32 v8, v19, 10, v8
		ds_read_b64_tr_b8 v[18:19], v8 offset:2048
		ds_read_b64_tr_b8 v[20:21], v8 offset:2560
		ds_read_b64_tr_b8 v[22:23], v3 offset:4096
		ds_read_b64_tr_b8 v[24:25], v3 offset:4608
		ds_read_b64_tr_b8 v[30:31], v8 offset:6144
		ds_read_b64_tr_b8 v[32:33], v8 offset:6656
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[4:7], a[68:71], v[4:7], v12, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[72:75], v[44:47], v12, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[76:79], v[48:51], v12, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[80:83], v[52:55], v12, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[84:87], v[56:59], v12, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[88:91], v[60:63], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[92:95], v[64:67], v12, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[96:99], v[68:71], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[96:99], v[100:103], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[84:87], v[88:91], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[88:91], v[92:95], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[92:95], v[96:99], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[92:95], v[128:131], v12, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[84:87], v[120:123], v12, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[88:91], v[124:127], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[96:99], v[132:135], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[96:99], v[164:167], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[84:87], v[152:155], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[88:91], v[156:159], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[92:95], v[160:163], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[68:71], v[136:139], v12, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[68:71], v[72:75], v12, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[72:75], v[76:79], v12, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[76:79], v[80:83], v12, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[80:83], v[84:87], v12, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[80:83], v[116:119], v12, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[68:71], v[104:107], v12, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[72:75], v[108:111], v12, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[76:79], v[112:115], v12, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[76:79], v[144:147], v12, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[72:75], v[140:143], v12, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[80:83], v[148:151], v12, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[68:71], v[168:171], v16, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[72:75], v[172:175], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[76:79], v[176:179], v16, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[80:83], v[180:183], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[24:27], a[80:83], v[200:203], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[68:71], v[188:191], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[72:75], v[192:195], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[76:79], v[196:199], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[76:79], v[212:215], v16, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[68:71], v[204:207], v16, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[72:75], v[208:211], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[28:31], a[80:83], v[216:219], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[32:35], a[80:83], v[232:235], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[68:71], v[220:223], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[72:75], v[224:227], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[76:79], v[228:231], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v16, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[84:87], v[184:187], v16, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v16, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v16, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v16, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v16, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v16, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v16, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v16, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v16, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v16, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v16, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v16, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v16, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v16, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v16, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[36:39], a[100:103], v[4:7], v22, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[104:107], v[44:47], v22, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[108:111], v[48:51], v22, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[112:115], v[52:55], v22, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[116:119], v[56:59], v22, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[120:123], v[60:63], v22, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[124:127], v[64:67], v22, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[128:131], v[68:71], v22, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[128:131], v[100:103], v22, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[116:119], v[88:91], v22, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[120:123], v[92:95], v22, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[124:127], v[96:99], v22, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[124:127], v[128:131], v22, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[116:119], v[120:123], v22, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[120:123], v[124:127], v22, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[128:131], v[132:135], v22, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[128:131], v[164:167], v22, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[116:119], v[152:155], v22, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[120:123], v[156:159], v22, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[124:127], v[160:163], v22, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[100:103], v[136:139], v22, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[100:103], v[72:75], v22, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[104:107], v[76:79], v22, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[108:111], v[80:83], v22, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[112:115], v[84:87], v22, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[112:115], v[116:119], v22, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[100:103], v[104:107], v22, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[104:107], v[108:111], v22, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[108:111], v[112:115], v22, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[108:111], v[144:147], v22, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[104:107], v[140:143], v22, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[112:115], v[148:151], v22, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[100:103], v[168:171], v24, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[104:107], v[172:175], v24, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[108:111], v[176:179], v24, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[112:115], v[180:183], v24, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[112:115], v[200:203], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[100:103], v[188:191], v24, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[104:107], v[192:195], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[108:111], v[196:199], v24, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[108:111], v[212:215], v24, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[100:103], v[204:207], v24, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[104:107], v[208:211], v24, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[60:63], a[112:115], v[216:219], v24, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[112:115], v[232:235], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[100:103], v[220:223], v24, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[104:107], v[224:227], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[108:111], v[228:231], v24, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v24, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[52:55], a[116:119], v[184:187], v24, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v24, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v24, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v24, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v24, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v24, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v24, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v24, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v24, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v24, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v24, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v24, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v24, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x10000, v10
		v_add3_u32 v10, v10, v26, v14
		ds_read_b128 v[16:19], v10
		ds_read_b128 a[0:3], v10 offset:1024
		ds_read_b128 a[4:7], v10 offset:2048
		ds_read_b128 a[8:11], v10 offset:3072
		ds_read_b128 a[12:15], v10 offset:4096
		ds_read_b128 a[16:19], v10 offset:5120
		ds_read_b128 a[20:23], v10 offset:6144
		ds_read_b128 a[24:27], v10 offset:7168
		ds_read_b128 a[28:31], v10 offset:16384
		ds_read_b128 a[32:35], v10 offset:17408
		ds_read_b128 a[36:39], v10 offset:18432
		ds_read_b128 a[40:43], v10 offset:19456
		ds_read_b128 a[44:47], v10 offset:20480
		ds_read_b128 a[48:51], v10 offset:21504
		ds_read_b128 a[52:55], v10 offset:22528
		ds_read_b128 a[56:59], v10 offset:23552
		v_add_u32_e32 v10, 0x10000, v26
		v_add3_u32 v10, v10, v28, v14
		ds_read_b128 v[12:15], v10 offset:32768
		ds_read_b128 v[20:23], v10 offset:33792
		ds_read_b128 v[24:27], v10 offset:34816
		ds_read_b128 v[28:31], v10 offset:35840
		ds_read_b128 a[60:63], v10 offset:36864
		ds_read_b128 a[64:67], v10 offset:37888
		ds_read_b128 a[68:71], v10 offset:38912
		ds_read_b128 a[72:75], v10 offset:39936
		ds_read_b128 v[32:35], v10 offset:49152
		ds_read_b128 v[36:39], v10 offset:50176
		ds_read_b128 v[40:43], v10 offset:51200
		ds_read_b128 v[236:239], v10 offset:52224
		ds_read_b128 a[76:79], v10 offset:53248
		ds_read_b128 a[80:83], v10 offset:54272
		ds_read_b128 a[84:87], v10 offset:55296
		ds_read_b128 a[88:91], v10 offset:56320
		v_lshlrev_b32_e32 v1, 15, v1
		v_add_u32_e32 v9, v1, v9
		v_and_b32_e32 v0, 63, v0
		s_mov_b32 s0, 32
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v3 offset:8192
		ds_read_b64_tr_b8 v[240:241], v3 offset:8704
		ds_read_b64_tr_b8 v[242:243], v8 offset:10240
		ds_read_b64_tr_b8 v[244:245], v8 offset:10752
		ds_read_b64_tr_b8 v[246:247], v3 offset:12288
		ds_read_b64_tr_b8 v[248:249], v3 offset:12800
		ds_read_b64_tr_b8 v[250:251], v8 offset:14336
		ds_read_b64_tr_b8 v[252:253], v8 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[12:15], v[4:7], v10, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[16:19], v[20:23], v[44:47], v10, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[16:19], v[24:27], v[48:51], v10, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[16:19], v[28:31], v[52:55], v10, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[0:3], v[28:31], v[84:87], v10, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[0:3], v[12:15], v[72:75], v10, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[0:3], v[20:23], v[76:79], v10, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[0:3], v[24:27], v[80:83], v10, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[4:7], v[24:27], v[112:115], v10, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[4:7], v[12:15], v[104:107], v10, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[4:7], v[20:23], v[108:111], v10, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[4:7], v[28:31], v[116:119], v10, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[8:11], v[28:31], v[148:151], v10, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[8:11], v[12:15], v[136:139], v10, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[8:11], v[20:23], v[140:143], v10, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[8:11], v[24:27], v[144:147], v10, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[12:15], v[12:15], v[168:171], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[12:15], v[20:23], v[172:175], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[12:15], v[24:27], v[176:179], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[12:15], v[28:31], v[180:183], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[16:19], v[28:31], v[200:203], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[16:19], v[12:15], v[188:191], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[16:19], v[20:23], v[192:195], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[16:19], v[24:27], v[196:199], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[20:23], v[24:27], v[212:215], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[20:23], v[12:15], v[204:207], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[20:23], v[20:23], v[208:211], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[20:23], v[28:31], v[216:219], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[24:27], v[28:31], v[232:235], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[24:27], v[12:15], v[220:223], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[24:27], v[20:23], v[224:227], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[24:27], v[24:27], v[228:231], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], a[28:31], v[32:35], v[4:7], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[28:31], v[36:39], v[44:47], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[28:31], v[40:43], v[48:51], v246, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[28:31], v[236:239], v[52:55], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[32:35], v[236:239], v[84:87], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[32:35], v[32:35], v[72:75], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[32:35], v[36:39], v[76:79], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[32:35], v[40:43], v[80:83], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[36:39], v[40:43], v[112:115], v246, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[36:39], v[32:35], v[104:107], v246, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[36:39], v[36:39], v[108:111], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[36:39], v[236:239], v[116:119], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[40:43], v[236:239], v[148:151], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[40:43], v[32:35], v[136:139], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[40:43], v[36:39], v[140:143], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[40:43], v[40:43], v[144:147], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[44:47], v[32:35], v[168:171], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[44:47], v[36:39], v[172:175], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[44:47], v[40:43], v[176:179], v248, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[44:47], v[236:239], v[180:183], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[48:51], v[236:239], v[200:203], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[48:51], v[32:35], v[188:191], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[48:51], v[36:39], v[192:195], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[48:51], v[40:43], v[196:199], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[52:55], v[40:43], v[212:215], v248, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[52:55], v[32:35], v[204:207], v248, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[52:55], v[36:39], v[208:211], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[52:55], v[236:239], v[216:219], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[56:59], v[236:239], v[232:235], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[56:59], v[32:35], v[220:223], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[56:59], v[36:39], v[224:227], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[56:59], v[40:43], v[228:231], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v12, v4, v5
		v_cvt_pk_f16_f32 v13, v6, v7
		v_cvt_pk_f16_f32 v4, v44, v45
		v_cvt_pk_f16_f32 v5, v46, v47
		ds_write2st64_b64 v9, v[12:13], v[4:5] offset1:1
		v_cvt_pk_f16_f32 v4, v48, v49
		v_cvt_pk_f16_f32 v5, v50, v51
		v_cvt_pk_f16_f32 v6, v52, v53
		v_cvt_pk_f16_f32 v7, v54, v55
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:2 offset1:3
		v_cvt_pk_f16_f32 v4, v72, v73
		v_cvt_pk_f16_f32 v5, v74, v75
		v_cvt_pk_f16_f32 v6, v76, v77
		v_cvt_pk_f16_f32 v7, v78, v79
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:8 offset1:9
		v_cvt_pk_f16_f32 v4, v80, v81
		v_cvt_pk_f16_f32 v5, v82, v83
		v_cvt_pk_f16_f32 v6, v84, v85
		v_cvt_pk_f16_f32 v7, v86, v87
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:10 offset1:11
		v_cvt_pk_f16_f32 v4, v104, v105
		v_cvt_pk_f16_f32 v5, v106, v107
		v_cvt_pk_f16_f32 v6, v108, v109
		v_cvt_pk_f16_f32 v7, v110, v111
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:16 offset1:17
		v_cvt_pk_f16_f32 v4, v112, v113
		v_cvt_pk_f16_f32 v5, v114, v115
		v_cvt_pk_f16_f32 v6, v116, v117
		v_cvt_pk_f16_f32 v7, v118, v119
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:18 offset1:19
		v_cvt_pk_f16_f32 v4, v136, v137
		v_cvt_pk_f16_f32 v5, v138, v139
		v_cvt_pk_f16_f32 v6, v140, v141
		v_cvt_pk_f16_f32 v7, v142, v143
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:24 offset1:25
		v_cvt_pk_f16_f32 v4, v144, v145
		v_cvt_pk_f16_f32 v5, v146, v147
		v_cvt_pk_f16_f32 v6, v148, v149
		v_cvt_pk_f16_f32 v7, v150, v151
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:26 offset1:27
		v_cvt_pk_f16_f32 v4, v168, v169
		v_cvt_pk_f16_f32 v5, v170, v171
		v_cvt_pk_f16_f32 v6, v172, v173
		v_cvt_pk_f16_f32 v7, v174, v175
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:32 offset1:33
		v_cvt_pk_f16_f32 v4, v176, v177
		v_cvt_pk_f16_f32 v5, v178, v179
		v_cvt_pk_f16_f32 v6, v180, v181
		v_cvt_pk_f16_f32 v7, v182, v183
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:34 offset1:35
		v_cvt_pk_f16_f32 v4, v188, v189
		v_cvt_pk_f16_f32 v5, v190, v191
		v_cvt_pk_f16_f32 v6, v192, v193
		v_cvt_pk_f16_f32 v7, v194, v195
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:40 offset1:41
		v_cvt_pk_f16_f32 v4, v196, v197
		v_cvt_pk_f16_f32 v5, v198, v199
		v_cvt_pk_f16_f32 v6, v200, v201
		v_cvt_pk_f16_f32 v7, v202, v203
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:42 offset1:43
		v_cvt_pk_f16_f32 v4, v204, v205
		v_cvt_pk_f16_f32 v5, v206, v207
		v_cvt_pk_f16_f32 v6, v208, v209
		v_cvt_pk_f16_f32 v7, v210, v211
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:48 offset1:49
		v_cvt_pk_f16_f32 v4, v212, v213
		v_cvt_pk_f16_f32 v5, v214, v215
		v_cvt_pk_f16_f32 v6, v216, v217
		v_cvt_pk_f16_f32 v7, v218, v219
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:50 offset1:51
		v_cvt_pk_f16_f32 v4, v220, v221
		v_cvt_pk_f16_f32 v5, v222, v223
		v_cvt_pk_f16_f32 v6, v224, v225
		v_cvt_pk_f16_f32 v7, v226, v227
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:56 offset1:57
		v_cvt_pk_f16_f32 v4, v228, v229
		v_cvt_pk_f16_f32 v5, v230, v231
		v_cvt_pk_f16_f32 v6, v232, v233
		v_cvt_pk_f16_f32 v7, v234, v235
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:58 offset1:59
		v_cmp_lt_u32_e64 vcc, v0, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v0, v2, 4, v1
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s8, 0x7000
		s_and_saveexec_b64 s[52:53], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[4:7], v0
		ds_read_b128 v[12:15], v0 offset:512
		ds_read_b128 v[20:23], v0 offset:1024
		ds_read_b128 v[24:27], v0 offset:1536
		ds_read_b128 v[28:31], v0 offset:4096
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], 0 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], 0 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], 0 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s0 offen
		ds_read_b128 v[4:7], v0 offset:4608
		ds_read_b128 v[12:15], v0 offset:5120
		ds_read_b128 v[20:23], v0 offset:5632
		ds_read_b128 v[24:27], v0 offset:8192
		ds_read_b128 v[28:31], v0 offset:8704
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s0 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s0 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s0 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], s1 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s1 offen offset:512
		ds_read_b128 v[4:7], v0 offset:9216
		ds_read_b128 v[12:15], v0 offset:9728
		ds_read_b128 v[20:23], v0 offset:12288
		ds_read_b128 v[24:27], v0 offset:12800
		ds_read_b128 v[28:31], v0 offset:13312
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s1 offen offset:1024
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s1 offen offset:1536
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s4 offen
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], s4 offen offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s4 offen offset:1024
		ds_read_b128 v[4:7], v0 offset:13824
		ds_read_b128 v[12:15], v0 offset:16384
		ds_read_b128 v[20:23], v0 offset:16896
		ds_read_b128 v[24:27], v0 offset:17408
		ds_read_b128 v[28:31], v0 offset:17920
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s4 offen offset:1536
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s5 offen
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s5 offen offset:512
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], s5 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s5 offen offset:1536
		ds_read_b128 v[4:7], v0 offset:20480
		ds_read_b128 v[12:15], v0 offset:20992
		ds_read_b128 v[20:23], v0 offset:21504
		ds_read_b128 v[24:27], v0 offset:22016
		ds_read_b128 v[28:31], v0 offset:24576
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s6 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s6 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s6 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], s6 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s7 offen
		ds_read_b128 v[4:7], v0 offset:25088
		ds_read_b128 v[12:15], v0 offset:25600
		ds_read_b128 v[20:23], v0 offset:26112
		ds_read_b128 v[24:27], v0 offset:28672
		ds_read_b128 v[28:31], v0 offset:29184
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s7 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s7 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s7 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[24:27], v0, s[24:27], s8 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[28:31], v0, s[24:27], s8 offen offset:512
		ds_read_b128 v[4:7], v0 offset:29696
		ds_read_b128 v[12:15], v0 offset:30208
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s8 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s8 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[16:19], a[60:63], v[56:59], v10, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[16:19], a[64:67], v[60:63], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[16:19], a[68:71], v[64:67], v10, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], a[72:75], v[68:71], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[0:3], a[72:75], v[100:103], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[0:3], a[60:63], v[88:91], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[0:3], a[64:67], v[92:95], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[0:3], a[68:71], v[96:99], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[4:7], a[68:71], v[128:131], v10, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[4:7], a[60:63], v[120:123], v10, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[4:7], a[64:67], v[124:127], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[4:7], a[72:75], v[132:135], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[8:11], a[72:75], v[164:167], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[8:11], a[60:63], v[152:155], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[8:11], a[64:67], v[156:159], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[8:11], a[68:71], v[160:163], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[12:15], a[68:71], a[136:139], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[12:15], a[60:63], v[184:187], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[12:15], a[64:67], a[132:135], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[12:15], a[72:75], a[140:143], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[16:19], a[72:75], a[156:159], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[16:19], a[60:63], a[144:147], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[16:19], a[64:67], a[148:151], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[16:19], a[68:71], a[152:155], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[20:23], a[68:71], a[168:171], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[20:23], a[60:63], a[160:163], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[20:23], a[64:67], a[164:167], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[20:23], a[72:75], a[172:175], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[24:27], a[72:75], a[188:191], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[24:27], a[60:63], a[176:179], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[24:27], a[64:67], a[180:183], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[24:27], a[68:71], a[184:187], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[28:31], a[76:79], v[56:59], v246, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[28:31], a[80:83], v[60:63], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[28:31], a[84:87], v[64:67], v246, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[28:31], a[88:91], v[68:71], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[32:35], a[88:91], v[100:103], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[32:35], a[76:79], v[88:91], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[32:35], a[80:83], v[92:95], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[32:35], a[84:87], v[96:99], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[36:39], a[84:87], v[128:131], v246, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[36:39], a[76:79], v[120:123], v246, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[36:39], a[80:83], v[124:127], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[36:39], a[88:91], v[132:135], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[40:43], a[88:91], v[164:167], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[40:43], a[76:79], v[152:155], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[40:43], a[80:83], v[156:159], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[40:43], a[84:87], v[160:163], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[44:47], a[84:87], a[136:139], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[44:47], a[76:79], v[184:187], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], a[80:83], a[132:135], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], a[88:91], a[140:143], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[88:91], a[156:159], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], a[76:79], a[144:147], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], a[80:83], a[148:151], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[48:51], a[84:87], a[152:155], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], a[84:87], a[168:171], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], a[76:79], a[160:163], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], a[80:83], a[164:167], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[52:55], a[88:91], a[172:175], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[56:59], a[88:91], a[188:191], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], a[76:79], a[176:179], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[56:59], a[80:83], a[180:183], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[56:59], a[84:87], a[184:187], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		v_cvt_pk_f16_f32 v4, v60, v61
		v_cvt_pk_f16_f32 v5, v62, v63
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:4 offset1:5
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		v_cvt_pk_f16_f32 v4, v68, v69
		v_cvt_pk_f16_f32 v5, v70, v71
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:6 offset1:7
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		v_cvt_pk_f16_f32 v4, v92, v93
		v_cvt_pk_f16_f32 v5, v94, v95
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:12 offset1:13
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		v_cvt_pk_f16_f32 v4, v100, v101
		v_cvt_pk_f16_f32 v5, v102, v103
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:14 offset1:15
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		v_cvt_pk_f16_f32 v4, v124, v125
		v_cvt_pk_f16_f32 v5, v126, v127
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:20 offset1:21
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		v_cvt_pk_f16_f32 v4, v132, v133
		v_cvt_pk_f16_f32 v5, v134, v135
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:22 offset1:23
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		v_cvt_pk_f16_f32 v4, v156, v157
		v_cvt_pk_f16_f32 v5, v158, v159
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:28 offset1:29
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		v_cvt_pk_f16_f32 v4, v164, v165
		v_cvt_pk_f16_f32 v5, v166, v167
		ds_write2st64_b64 v9, v[2:3], v[4:5] offset0:30 offset1:31
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v4, a133
		v_cvt_pk_f16_f32 v6, v1, v4
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v4, a135
		v_cvt_pk_f16_f32 v7, v1, v4
		ds_write2st64_b64 v9, v[2:3], v[6:7] offset0:36 offset1:37
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:38 offset1:39
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:44 offset1:45
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:46 offset1:47
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:52 offset1:53
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:54 offset1:55
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:60 offset1:61
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write2st64_b64 v9, v[4:5], v[6:7] offset0:62 offset1:63
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[52:53], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		ds_read_b128 v[4:7], v0 offset:2048
		ds_read_b128 v[8:11], v0 offset:2560
		ds_read_b128 v[12:15], v0 offset:3072
		ds_read_b128 v[16:19], v0 offset:3584
		ds_read_b128 v[20:23], v0 offset:6144
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], 0 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], 0 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], 0 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], 0 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s0 offen offset:2048
		ds_read_b128 v[4:7], v0 offset:6656
		ds_read_b128 v[8:11], v0 offset:7168
		ds_read_b128 v[12:15], v0 offset:7680
		ds_read_b128 v[16:19], v0 offset:10240
		ds_read_b128 v[20:23], v0 offset:10752
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s0 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s0 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s0 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], s1 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s1 offen offset:2560
		ds_read_b128 v[4:7], v0 offset:11264
		ds_read_b128 v[8:11], v0 offset:11776
		ds_read_b128 v[12:15], v0 offset:14336
		ds_read_b128 v[16:19], v0 offset:14848
		ds_read_b128 v[20:23], v0 offset:15360
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s1 offen offset:3072
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s1 offen offset:3584
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s4 offen offset:2048
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], s4 offen offset:2560
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s4 offen offset:3072
		ds_read_b128 v[4:7], v0 offset:15872
		ds_read_b128 v[8:11], v0 offset:18432
		ds_read_b128 v[12:15], v0 offset:18944
		ds_read_b128 v[16:19], v0 offset:19456
		ds_read_b128 v[20:23], v0 offset:19968
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s4 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s5 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s5 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], s5 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s5 offen offset:3584
		ds_read_b128 v[4:7], v0 offset:22528
		ds_read_b128 v[8:11], v0 offset:23040
		ds_read_b128 v[12:15], v0 offset:23552
		ds_read_b128 v[16:19], v0 offset:24064
		ds_read_b128 v[20:23], v0 offset:26624
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s6 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s6 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s6 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], s6 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s7 offen offset:2048
		ds_read_b128 v[4:7], v0 offset:27136
		ds_read_b128 v[8:11], v0 offset:27648
		ds_read_b128 v[12:15], v0 offset:28160
		ds_read_b128 v[16:19], v0 offset:30720
		ds_read_b128 v[20:23], v0 offset:31232
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s7 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s7 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[24:27], s7 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[24:27], s8 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[24:27], s8 offen offset:2560
		ds_read_b128 v[4:7], v0 offset:31744
		ds_read_b128 v[8:11], v0 offset:32256
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[4:7], v0, s[24:27], s8 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[24:27], s8 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[52:53]
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
		.amdhsa_next_free_sgpr 54
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 255
	.set .Lwmma_f16_matmul_tiled.num_agpr, 192
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 54
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
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     448
    .agpr_count:     192
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 72
    wave.regalloc.agpr.dwords: 281
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
