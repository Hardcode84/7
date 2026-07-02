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
		s_lshr_b32 s0, s13, 3
		s_lshl_b32 s1, s14, 1
		s_add_i32 s0, s1, s0
		s_and_b32 s1, s13, 7
		s_lshl_b32 s1, s1, 5
		s_add_i32 s0, s0, s1
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s12, s1, 23
		s_and_b32 s0, s0, 63
		s_lshr_b32 s13, s0, 2
		s_lshl_b32 s14, s13, 17
		s_add_i32 s12, s12, s14
		v_readfirstlane_b32 s14, v0
		s_and_b32 s0, s0, 3
		s_lshl_b32 s15, s0, 21
		s_add_i32 s12, s12, s15
		s_add_u32 s16, s6, s12
		s_addc_u32 s17, s7, 0
		v_and_b32_e32 v1, 63, v0
		s_lshr_b32 s6, s14, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s6, s7, 0x1000
		s_add_i32 s12, s7, 0x2000
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshrrev_b32_e32 v3, 3, v1
		s_add_i32 s14, s7, 0x3000
		s_add_i32 s15, s7, 0x4000
		s_add_i32 s20, s7, 0x5000
		s_add_i32 s21, s7, 0x6000
		v_lshrrev_b32_e32 v4, 6, v0
		v_lshlrev_b32_e32 v2, 12, v2
		v_and_b32_e32 v3, 3, v3
		v_and_b32_e32 v5, 3, v1
		s_add_i32 s22, s7, 0x7000
		s_add_i32 s23, s7, 0x8000
		s_add_i32 s24, s7, 0x9000
		s_add_i32 s25, s7, 0xa000
		v_lshl_add_u32 v2, v4, 16, v2
		v_xor_b32_e32 v3, v3, v5
		s_add_i32 s26, s7, 0xb000
		s_add_i32 s27, s7, 0xc000
		s_add_i32 s28, s7, 0xd000
		s_add_i32 s29, s7, 0xe000
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s30, s7, 0xf000
		s_lshl_b32 s31, s1, 22
		s_lshl_b32 s32, s0, 20
		s_add_i32 s18, s31, s32
		v_add_u32_e32 v3, s18, v2
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s42, 0x1000000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		s_mov_b32 m0, s7
		s_mov_b32 s43, s39
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_add_i32 s2, s31, 0x40000
		s_add_i32 s2, s2, s32
		s_mov_b32 m0, s6
		v_add_u32_e32 v5, s2, v2
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		v_add_u32_e32 v5, s32, v2
		s_add_i32 s2, s31, 0x80000
		s_mov_b32 m0, s12
		v_add_u32_e32 v6, s2, v5
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_add_i32 s2, s31, 0xc0000
		s_mov_b32 m0, s14
		v_add_u32_e32 v6, s2, v5
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_mov_b32 m0, s15
		v_add3_u32 v5, s31, 64, v5
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		v_add_u32_e32 v5, s32, v2
		v_add_u32_e32 v5, s31, v5
		s_mov_b32 m0, s20
		v_add_u32_e32 v6, 0x40040, v5
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_mov_b32 m0, s21
		v_add_u32_e32 v6, 0x80040, v5
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_mov_b32 m0, s22
		v_add_u32_e32 v5, 0xc0040, v5
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_lshl_b32 s2, s13, 20
		v_add_u32_e32 v5, s2, v2
		s_mov_b32 s44, s4
		s_mov_b32 s45, s5
		s_mov_b32 s46, s42
		s_mov_b32 m0, s23
		s_mov_b32 s47, s43
		buffer_load_dwordx4 v5, s[44:47], 0 offen lds
		v_add_u32_e32 v6, s2, v2
		s_mov_b32 m0, s24
		v_add_u32_e32 v7, 0x40000, v6
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_mov_b32 m0, s25
		v_add_u32_e32 v7, 0x80000, v6
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_mov_b32 m0, s26
		v_add_u32_e32 v6, 0xc0000, v6
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_mov_b32 m0, s27
		v_add3_u32 v6, s2, 64, v2
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		v_add_u32_e32 v6, s2, v2
		s_mov_b32 m0, s28
		v_add_u32_e32 v7, 0x40040, v6
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_mov_b32 m0, s29
		v_add_u32_e32 v7, 0x80040, v6
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_mov_b32 m0, s30
		v_add_u32_e32 v6, 0xc0040, v6
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		v_lshrrev_b32_e32 v6, 7, v0
		v_lshrrev_b32_e32 v7, 4, v1
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v9, 10, v6
		v_and_b32_e32 v10, 1, v4
		v_lshlrev_b32_e32 v11, 7, v6
		v_lshlrev_b32_e32 v12, 12, v7
		v_lshlrev_b32_e32 v13, 2, v8
		v_add_u32_e32 v14, 0x20000, v9
		v_accvgpr_write_b32 a0, v14
		v_lshlrev_b32_e32 v14, 7, v7
		s_mov_b32 s3, 0
		s_lshl_b32 s1, s1, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_cmp_eq_u32_e64 vcc, v10, s3
		s_mov_b64 s[4:5], vcc
		v_add3_u32 v10, v11, v12, v13
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, v11, v14, v13
		s_lshl_b32 s0, s0, 8
		s_add_i32 s33, s1, s0
		s_mov_b32 s38, 0x7fffffff
		s_add_i32 s34, s1, 0x4000
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, s38
		s_mov_b32 s51, s43
		s_mov_b32 s18, 0x20000
		s_mov_b32 s19, s43
		s_add_i32 s8, s34, s0
		s_and_saveexec_b64 s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v12, v10, s[48:51], s33 offen
		buffer_load_dword v15, v10, s[48:51], s33 offen offset:64
		buffer_load_dword v20, v10, s[48:51], s8 offen
		buffer_load_dword v21, v10, s[48:51], s8 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v11, v12
		ds_write_b32 v11, v15 offset:512
		ds_write_b32 v11, v20 offset:4096
		ds_write_b32 v11, v21 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v12, 0x20000, v14
		v_lshrrev_b32_e32 v15, 1, v4
		v_lshl_add_u32 v20, v7, 12, v13
		v_and_b32_e32 v21, 1, v4
		v_add_u32_e32 v12, v12, v13
		v_cmp_eq_u32_e64 vcc, v15, s3
		s_mov_b64 s[8:9], vcc
		v_lshl_add_u32 v15, v21, 7, v20
		v_lshl_add_u32 v12, v21, 10, v12
		s_lshl_b32 s10, s13, 8
		s_add_i32 s11, s10, 0x4000
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v20, v15, s[36:39], s10 offen
		buffer_load_dword v22, v15, s[36:39], s10 offen offset:64
		buffer_load_dword v23, v15, s[36:39], s11 offen
		buffer_load_dword v24, v15, s[36:39], s11 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v20 offset:2048
		ds_write_b32 v12, v22 offset:2560
		ds_write_b32 v12, v23 offset:6144
		ds_write_b32 v12, v24 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s1, 0x8000
		s_add_i32 s11, s11, s0
		s_add_i32 s13, s1, 0xc000
		s_add_i32 s13, s13, s0
		s_and_saveexec_b64 s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v20, v10, s[48:51], s11 offen
		buffer_load_dword v22, v10, s[48:51], s11 offen offset:64
		buffer_load_dword v23, v10, s[48:51], s13 offen
		buffer_load_dword v24, v10, s[48:51], s13 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v11, v20 offset:8192
		ds_write_b32 v11, v22 offset:8704
		ds_write_b32 v11, v23 offset:12288
		ds_write_b32 v11, v24 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s10, 0x8000
		s_add_i32 s13, s10, 0xc000
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v11, v15, s[36:39], s11 offen
		buffer_load_dword v20, v15, s[36:39], s11 offen offset:64
		buffer_load_dword v22, v15, s[36:39], s13 offen
		buffer_load_dword v23, v15, s[36:39], s13 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v11 offset:10240
		ds_write_b32 v12, v20 offset:10752
		ds_write_b32 v12, v22 offset:14336
		ds_write_b32 v12, v23 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s11, s31, 0x80
		s_add_i32 s11, s11, s32
		v_add_u32_e32 v11, s11, v2
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x11000
		s_add_i32 s11, s31, 0x40080
		s_add_i32 s11, s11, s32
		v_add_u32_e32 v11, s11, v2
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		v_add_u32_e32 v11, s32, v2
		v_add_u32_e32 v11, s31, v11
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x13000
		v_add_u32_e32 v12, 0xc0080, v11
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		v_add_u32_e32 v11, 0xc0, v11
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x15000
		v_add_u32_e32 v11, s32, v2
		v_add_u32_e32 v11, s31, v11
		v_add_u32_e32 v12, 0x400c0, v11
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		v_add_u32_e32 v12, 0x800c0, v11
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x17000
		v_add_u32_e32 v11, 0xc00c0, v11
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s11, s2, 0x80
		v_add_u32_e32 v11, s11, v2
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x19000
		s_add_i32 s11, s2, 0x40080
		v_add_u32_e32 v11, s11, v2
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		v_add_u32_e32 v11, s2, v2
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1b000
		v_add_u32_e32 v12, 0xc0080, v11
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		v_add_u32_e32 v11, 0xc0, v11
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1d000
		v_add_u32_e32 v2, s2, v2
		v_add_u32_e32 v11, 0x400c0, v2
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		v_add_u32_e32 v11, 0x800c0, v2
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s7, 0x1f000
		v_add_u32_e32 v2, 0xc00c0, v2
		buffer_load_dwordx4 v2, s[44:47], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		v_lshlrev_b32_e32 v2, 13, v6
		v_lshlrev_b32_e32 v6, 6, v8
		v_lshrrev_b32_e32 v8, 1, v8
		v_and_b32_e32 v8, 3, v8
		v_xor_b32_e32 v8, v7, v8
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v11, v2, v6, v8
		ds_read_b128 a[4:7], v11
		ds_read_b128 a[8:11], v11 offset:1024
		ds_read_b128 a[12:15], v11 offset:2048
		ds_read_b128 a[16:19], v11 offset:3072
		ds_read_b128 a[20:23], v11 offset:4096
		ds_read_b128 a[24:27], v11 offset:5120
		ds_read_b128 a[28:31], v11 offset:6144
		ds_read_b128 a[32:35], v11 offset:7168
		ds_read_b128 a[36:39], v11 offset:16384
		ds_read_b128 a[40:43], v11 offset:17408
		ds_read_b128 a[44:47], v11 offset:18432
		ds_read_b128 a[48:51], v11 offset:19456
		ds_read_b128 a[52:55], v11 offset:20480
		ds_read_b128 a[56:59], v11 offset:21504
		ds_read_b128 a[60:63], v11 offset:22528
		ds_read_b128 a[64:67], v11 offset:23552
		v_lshlrev_b32_e32 v11, 13, v21
		v_add3_u32 v12, v6, v11, v8
		ds_read_b128 a[68:71], v12 offset:32768
		ds_read_b128 a[72:75], v12 offset:33792
		ds_read_b128 a[76:79], v12 offset:34816
		ds_read_b128 a[80:83], v12 offset:35840
		ds_read_b128 a[84:87], v12 offset:36864
		ds_read_b128 a[88:91], v12 offset:37888
		ds_read_b128 a[92:95], v12 offset:38912
		ds_read_b128 a[96:99], v12 offset:39936
		ds_read_b128 a[100:103], v12 offset:49152
		ds_read_b128 a[104:107], v12 offset:50176
		ds_read_b128 a[108:111], v12 offset:51200
		ds_read_b128 a[112:115], v12 offset:52224
		ds_read_b128 a[116:119], v12 offset:53248
		ds_read_b128 a[120:123], v12 offset:54272
		ds_read_b128 a[124:127], v12 offset:55296
		ds_read_b128 a[128:131], v12 offset:56320
		v_add_u32_e32 v12, 0x100, v3
		v_add_u32_e32 v20, 0x40100, v3
		v_add_u32_e32 v22, 0x80100, v3
		v_add_u32_e32 v23, 0xc0100, v3
		v_add_u32_e32 v24, 0x140, v3
		v_add_u32_e32 v25, 0x40140, v3
		v_add_u32_e32 v26, 0x80140, v3
		v_add_u32_e32 v27, 0xc0140, v3
		v_add_u32_e32 v3, 0x100, v5
		v_add_u32_e32 v28, 0x40100, v5
		v_add_u32_e32 v29, 0x80100, v5
		v_add_u32_e32 v30, 0xc0100, v5
		v_add_u32_e32 v31, 0x140, v5
		v_add_u32_e32 v32, 0x40140, v5
		v_add_u32_e32 v33, 0x80140, v5
		v_add_u32_e32 v34, 0xc0140, v5
		v_lshlrev_b32_e32 v5, 3, v1
		v_lshlrev_b32_e32 v35, 10, v21
		s_add_i32 s2, s1, 0x10000
		s_add_i32 s2, s2, s0
		s_add_i32 s1, s1, 0x14000
		s_add_i32 s0, s1, s0
		v_add_u32_e32 v36, v9, v14
		s_add_i32 s1, s10, 0x10000
		s_add_i32 s10, s10, 0x14000
		v_lshl_add_u32 v37, v7, 7, v13
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
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
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
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
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
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
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
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s11, s3, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s13, s3, 1
		s_lshl_b32 s13, s13, 13
		s_add_i32 s31, s13, 0x20000
		v_add_u32_e32 v38, s31, v9
		v_add_u32_e32 v39, v38, v5
		ds_read_b64_tr_b8 v[232:233], v39
		ds_read_b64_tr_b8 v[234:235], v39 offset:512
		v_add3_u32 v236, s31, v5, v35
		ds_read_b64_tr_b8 v[238:239], v236 offset:2048
		ds_read_b64_tr_b8 v[240:241], v39 offset:4096
		ds_read_b64_tr_b8 v[242:243], v39 offset:4608
		ds_read_b64_tr_b8 v[244:245], v236 offset:6144
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[4:7], a[68:71], v[16:19], v232, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[4:7], a[72:75], v[40:43], v232, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[76:79], v[44:47], v232, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[80:83], v[48:51], v232, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[8:11], a[68:71], v[68:71], v232, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[72:75], v[72:75], v232, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[76:79], v[76:79], v232, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[80:83], v[80:83], v232, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], a[68:71], v[100:103], v232, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[72:75], v[104:107], v232, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[76:79], v[108:111], v232, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[80:83], v[112:115], v232, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], a[68:71], v[132:135], v232, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[72:75], v[136:139], v232, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[76:79], v[140:143], v232, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[80:83], v[144:147], v232, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[20:23], a[68:71], v[164:167], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[72:75], v[168:171], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[76:79], v[172:175], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[80:83], v[176:179], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[24:27], a[68:71], v[184:187], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[72:75], v[188:191], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[76:79], v[192:195], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[80:83], v[196:199], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[28:31], a[68:71], v[200:203], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[72:75], v[204:207], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[76:79], v[208:211], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[80:83], v[212:215], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[32:35], a[68:71], v[216:219], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[72:75], v[220:223], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[76:79], v[224:227], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[80:83], v[228:231], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[36:39], a[100:103], v[16:19], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[36:39], a[104:107], v[40:43], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[108:111], v[44:47], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[112:115], v[48:51], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[40:43], a[100:103], v[68:71], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[104:107], v[72:75], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[108:111], v[76:79], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[112:115], v[80:83], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[44:47], a[100:103], v[100:103], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[104:107], v[104:107], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[108:111], v[108:111], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[112:115], v[112:115], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[48:51], a[100:103], v[132:135], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[104:107], v[136:139], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[108:111], v[140:143], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[112:115], v[144:147], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[52:55], a[100:103], v[164:167], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[104:107], v[168:171], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[108:111], v[172:175], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[112:115], v[176:179], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[56:59], a[100:103], v[184:187], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[104:107], v[188:191], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[108:111], v[192:195], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[112:115], v[196:199], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[60:63], a[100:103], v[200:203], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[104:107], v[204:207], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[108:111], v[208:211], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[112:115], v[212:215], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[100:103], v[216:219], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[104:107], v[220:223], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[108:111], v[224:227], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[112:115], v[228:231], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[238:239], v236 offset:2560
		ds_read_b64_tr_b8 v[244:245], v236 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s31, s3, 15
		s_add_i32 s32, s2, s31
		s_add_i32 s33, s0, s31
		s_add_i32 s34, s13, 0x20200
		s_add_i32 s35, s13, 0x21000
		s_add_i32 s52, s13, 0x21200
		s_and_saveexec_b64 s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v39, v10, s[48:51], s32 offen
		buffer_load_dword v233, v10, s[48:51], s32 offen offset:64
		buffer_load_dword v235, v10, s[48:51], s33 offen
		buffer_load_dword v236, v10, s[48:51], s33 offen offset:64
		v_add3_u32 v237, v38, v14, v13
		v_add3_u32 v241, v13, v36, s34
		v_add3_u32 v243, v13, v36, s35
		v_add3_u32 v246, v13, v36, s52
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s32, s1, s31
		s_add_i32 s31, s10, s31
		s_add_i32 s33, s13, 0x20800
		v_lshl_add_u32 v38, v7, 7, s33
		s_add_i32 s33, s13, 0x20a00
		s_add_i32 s34, s13, 0x21800
		s_add_i32 s13, s13, 0x21a00
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v247, v15, s[36:39], s32 offen
		buffer_load_dword v248, v15, s[36:39], s32 offen offset:64
		buffer_load_dword v249, v15, s[36:39], s31 offen
		buffer_load_dword v250, v15, s[36:39], s31 offen offset:64
		v_add3_u32 v251, v38, v13, v35
		v_add3_u32 v252, v35, v37, s33
		v_add3_u32 v253, v35, v37, s34
		v_add3_u32 v254, v35, v37, s13
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[54:55]
		s_mov_b32 m0, s7
		s_nop 0
		buffer_load_dwordx4 v12, s[40:43], s11 offen lds
		s_mov_b32 m0, s6
		s_nop 0
		buffer_load_dwordx4 v20, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[84:87], v[52:55], v232, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[88:91], v[56:59], v232, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[92:95], v[60:63], v232, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s12
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[96:99], v[64:67], v232, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[84:87], v[84:87], v232, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[88:91], v[88:91], v232, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[92:95], v[92:95], v232, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[96:99], v[96:99], v232, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[84:87], v[116:119], v232, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s14
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[88:91], v[120:123], v232, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[92:95], v[124:127], v232, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[96:99], v[128:131], v232, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[84:87], v[148:151], v232, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[88:91], v[152:155], v232, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[92:95], v[156:159], v232, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[96:99], v[160:163], v232, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v24, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[84:87], v[180:183], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s20
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v25, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s21
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v26, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[116:119], v[52:55], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s22
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[120:123], v[56:59], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v27, s[40:43], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[124:127], v[60:63], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[128:131], v[64:67], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[116:119], v[84:87], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[120:123], v[88:91], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[124:127], v[92:95], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s23
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[128:131], v[96:99], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[44:47], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[116:119], v[116:119], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[120:123], v[120:123], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[124:127], v[124:127], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[128:131], v[128:131], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[116:119], v[148:151], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s25
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[120:123], v[152:155], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v29, s[44:47], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[124:127], v[156:159], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[128:131], v[160:163], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[116:119], v[180:183], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s27
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v31, s[44:47], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v33, s[44:47], s11 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v237, v39
		ds_write_b32 v241, v233
		ds_write_b32 v243, v235
		ds_write_b32 v246, v236
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[54:55], s[4:5]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[54:55]
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v251, v247
		ds_write_b32 v252, v248
		ds_write_b32 v253, v249
		ds_write_b32 v254, v250
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[54:55]
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v28, s[44:47], s11 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v30, s[44:47], s11 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v32, s[44:47], s11 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v34, s[44:47], s11 offen lds
		s_waitcnt vmcnt(24)
		s_barrier
		s_add_i32 s3, s3, 1
		s_and_b32 s11, s3, 1
		s_lshl_b32 s11, s11, 16
		v_add_u32_e32 v38, s11, v2
		v_add3_u32 v38, v38, v6, v8
		ds_read_b128 a[4:7], v38
		ds_read_b128 a[8:11], v38 offset:1024
		ds_read_b128 a[12:15], v38 offset:2048
		ds_read_b128 a[16:19], v38 offset:3072
		ds_read_b128 a[20:23], v38 offset:4096
		ds_read_b128 a[24:27], v38 offset:5120
		ds_read_b128 a[28:31], v38 offset:6144
		ds_read_b128 a[32:35], v38 offset:7168
		ds_read_b128 a[36:39], v38 offset:16384
		ds_read_b128 a[40:43], v38 offset:17408
		ds_read_b128 a[44:47], v38 offset:18432
		ds_read_b128 a[48:51], v38 offset:19456
		ds_read_b128 a[52:55], v38 offset:20480
		ds_read_b128 a[56:59], v38 offset:21504
		ds_read_b128 a[60:63], v38 offset:22528
		ds_read_b128 a[64:67], v38 offset:23552
		v_add_u32_e32 v38, s11, v6
		v_add3_u32 v38, v38, v11, v8
		ds_read_b128 a[68:71], v38 offset:32768
		ds_read_b128 a[72:75], v38 offset:33792
		ds_read_b128 a[76:79], v38 offset:34816
		ds_read_b128 a[80:83], v38 offset:35840
		ds_read_b128 a[84:87], v38 offset:36864
		ds_read_b128 a[88:91], v38 offset:37888
		ds_read_b128 a[92:95], v38 offset:38912
		ds_read_b128 a[96:99], v38 offset:39936
		ds_read_b128 a[100:103], v38 offset:49152
		ds_read_b128 a[104:107], v38 offset:50176
		ds_read_b128 a[108:111], v38 offset:51200
		ds_read_b128 a[112:115], v38 offset:52224
		ds_read_b128 a[116:119], v38 offset:53248
		ds_read_b128 a[120:123], v38 offset:54272
		ds_read_b128 a[124:127], v38 offset:55296
		ds_read_b128 a[128:131], v38 offset:56320
		s_add_i32 s7, s7, 0x10000
		s_and_b32 s7, s7, 0x1ffff
		s_add_i32 s6, s6, 0x10000
		s_and_b32 s6, s6, 0x1ffff
		s_add_i32 s11, s12, 0x10000
		s_and_b32 s12, s11, 0x1ffff
		s_add_i32 s11, s14, 0x10000
		s_and_b32 s14, s11, 0x1ffff
		s_add_i32 s11, s15, 0x10000
		s_and_b32 s15, s11, 0x1ffff
		s_add_i32 s11, s20, 0x10000
		s_and_b32 s20, s11, 0x1ffff
		s_add_i32 s11, s21, 0x10000
		s_and_b32 s21, s11, 0x1ffff
		s_add_i32 s11, s22, 0x10000
		s_and_b32 s22, s11, 0x1ffff
		s_add_i32 s11, s23, 0x10000
		s_and_b32 s23, s11, 0x1ffff
		s_add_i32 s11, s25, 0x10000
		s_and_b32 s25, s11, 0x1ffff
		s_add_i32 s11, s27, 0x10000
		s_and_b32 s27, s11, 0x1ffff
		s_add_i32 s11, s29, 0x10000
		s_and_b32 s29, s11, 0x1ffff
		s_add_i32 s11, s24, 0x10000
		s_and_b32 s24, s11, 0x1ffff
		s_add_i32 s11, s26, 0x10000
		s_and_b32 s26, s11, 0x1ffff
		s_add_i32 s11, s28, 0x10000
		s_and_b32 s28, s11, 0x1ffff
		s_add_i32 s11, s30, 0x10000
		s_and_b32 s30, s11, 0x1ffff
		s_cmp_lt_i32 s3, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v3, a0
		v_add_u32_e32 v3, v3, v5
		ds_read_b64_tr_b8 v[12:13], v3
		ds_read_b64_tr_b8 v[14:15], v3 offset:512
		v_add_u32_e32 v7, 0x20000, v5
		v_lshl_add_u32 v7, v21, 10, v7
		ds_read_b64_tr_b8 v[20:21], v7 offset:2048
		ds_read_b64_tr_b8 v[22:23], v7 offset:2560
		ds_read_b64_tr_b8 v[24:25], v3 offset:4096
		ds_read_b64_tr_b8 v[26:27], v3 offset:4608
		ds_read_b64_tr_b8 v[28:29], v7 offset:6144
		ds_read_b64_tr_b8 v[30:31], v7 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[4:7], a[68:71], v[16:19], v12, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[4:7], a[72:75], v[40:43], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[4:7], a[76:79], v[44:47], v12, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[4:7], a[80:83], v[48:51], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[4:7], a[84:87], v[52:55], v12, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[88:91], v[56:59], v12, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[92:95], v[60:63], v12, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[96:99], v[64:67], v12, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[8:11], a[68:71], v[68:71], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[8:11], a[72:75], v[72:75], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[8:11], a[76:79], v[76:79], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[8:11], a[80:83], v[80:83], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[84:87], v[84:87], v12, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[88:91], v[88:91], v12, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[92:95], v[92:95], v12, v22 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[96:99], v[96:99], v12, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[12:15], a[68:71], v[100:103], v12, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[12:15], a[72:75], v[104:107], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[12:15], a[76:79], v[108:111], v12, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[12:15], a[80:83], v[112:115], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[84:87], v[116:119], v12, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[88:91], v[120:123], v12, v22 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[92:95], v[124:127], v12, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[96:99], v[128:131], v12, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[16:19], a[68:71], v[132:135], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[16:19], a[72:75], v[136:139], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[16:19], a[76:79], v[140:143], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[16:19], a[80:83], v[144:147], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[84:87], v[148:151], v12, v22 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[88:91], v[152:155], v12, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[92:95], v[156:159], v12, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[96:99], v[160:163], v12, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[20:23], a[68:71], v[164:167], v14, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[20:23], a[72:75], v[168:171], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[20:23], a[76:79], v[172:175], v14, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[80:83], v[176:179], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[84:87], v[180:183], v14, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[20:23], a[88:91], a[132:135], v14, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[92:95], a[136:139], v14, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[96:99], a[140:143], v14, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[24:27], a[68:71], v[184:187], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[24:27], a[72:75], v[188:191], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[76:79], v[192:195], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[80:83], v[196:199], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[24:27], a[84:87], a[144:147], v14, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[24:27], a[88:91], a[148:151], v14, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[92:95], a[152:155], v14, v22 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[96:99], a[156:159], v14, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[28:31], a[68:71], v[200:203], v14, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[28:31], a[72:75], v[204:207], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[76:79], v[208:211], v14, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[80:83], v[212:215], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[28:31], a[84:87], a[160:163], v14, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[28:31], a[88:91], a[164:167], v14, v22 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[92:95], a[168:171], v14, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[96:99], a[172:175], v14, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[32:35], a[68:71], v[216:219], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[32:35], a[72:75], v[220:223], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[76:79], v[224:227], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[80:83], v[228:231], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[32:35], a[84:87], a[176:179], v14, v22 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[32:35], a[88:91], a[180:183], v14, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[92:95], a[184:187], v14, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[96:99], a[188:191], v14, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[36:39], a[100:103], v[16:19], v24, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[36:39], a[104:107], v[40:43], v24, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[36:39], a[108:111], v[44:47], v24, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[36:39], a[112:115], v[48:51], v24, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[36:39], a[116:119], v[52:55], v24, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[120:123], v[56:59], v24, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[124:127], v[60:63], v24, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[128:131], v[64:67], v24, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[40:43], a[100:103], v[68:71], v24, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[40:43], a[104:107], v[72:75], v24, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[40:43], a[108:111], v[76:79], v24, v28 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[40:43], a[112:115], v[80:83], v24, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[116:119], v[84:87], v24, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[120:123], v[88:91], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[124:127], v[92:95], v24, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[128:131], v[96:99], v24, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[44:47], a[100:103], v[100:103], v24, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[44:47], a[104:107], v[104:107], v24, v28 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[44:47], a[108:111], v[108:111], v24, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[44:47], a[112:115], v[112:115], v24, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[116:119], v[116:119], v24, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[120:123], v[120:123], v24, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[124:127], v[124:127], v24, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[128:131], v[128:131], v24, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[48:51], a[100:103], v[132:135], v24, v28 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[48:51], a[104:107], v[136:139], v24, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[48:51], a[108:111], v[140:143], v24, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[48:51], a[112:115], v[144:147], v24, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[116:119], v[148:151], v24, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[120:123], v[152:155], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[124:127], v[156:159], v24, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[128:131], v[160:163], v24, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[52:55], a[100:103], v[164:167], v26, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[52:55], a[104:107], v[168:171], v26, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[52:55], a[108:111], v[172:175], v26, v28 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[112:115], v[176:179], v26, v28 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[116:119], v[180:183], v26, v30 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[52:55], a[120:123], a[132:135], v26, v30 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[124:127], a[136:139], v26, v30 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[128:131], a[140:143], v26, v30 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[56:59], a[100:103], v[184:187], v26, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[56:59], a[104:107], v[188:191], v26, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[108:111], v[192:195], v26, v28 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[112:115], v[196:199], v26, v28 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[56:59], a[116:119], a[144:147], v26, v30 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[56:59], a[120:123], a[148:151], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[124:127], a[152:155], v26, v30 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[128:131], a[156:159], v26, v30 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[60:63], a[100:103], v[200:203], v26, v28 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[60:63], a[104:107], v[204:207], v26, v28 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[108:111], v[208:211], v26, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[112:115], v[212:215], v26, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[60:63], a[116:119], a[160:163], v26, v30 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[60:63], a[120:123], a[164:167], v26, v30 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[124:127], a[168:171], v26, v30 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[128:131], a[172:175], v26, v30 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[64:67], a[100:103], v[216:219], v26, v28 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[64:67], a[104:107], v[220:223], v26, v28 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[108:111], v[224:227], v26, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[112:115], v[228:231], v26, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[64:67], a[116:119], a[176:179], v26, v30 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[64:67], a[120:123], a[180:183], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[124:127], a[184:187], v26, v30 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[128:131], a[188:191], v26, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v2
		v_add3_u32 v2, v2, v6, v8
		ds_read_b128 v[12:15], v2
		ds_read_b128 a[0:3], v2 offset:1024
		ds_read_b128 a[4:7], v2 offset:2048
		ds_read_b128 a[8:11], v2 offset:3072
		ds_read_b128 a[12:15], v2 offset:4096
		ds_read_b128 a[16:19], v2 offset:5120
		ds_read_b128 a[20:23], v2 offset:6144
		ds_read_b128 a[24:27], v2 offset:7168
		ds_read_b128 a[28:31], v2 offset:16384
		ds_read_b128 a[32:35], v2 offset:17408
		ds_read_b128 a[36:39], v2 offset:18432
		ds_read_b128 a[40:43], v2 offset:19456
		ds_read_b128 a[44:47], v2 offset:20480
		ds_read_b128 a[48:51], v2 offset:21504
		ds_read_b128 a[52:55], v2 offset:22528
		ds_read_b128 a[56:59], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v6
		v_add3_u32 v2, v2, v11, v8
		ds_read_b128 v[8:11], v2 offset:32768
		ds_read_b128 v[20:23], v2 offset:33792
		ds_read_b128 v[24:27], v2 offset:34816
		ds_read_b128 v[28:31], v2 offset:35840
		ds_read_b128 a[60:63], v2 offset:36864
		ds_read_b128 a[64:67], v2 offset:37888
		ds_read_b128 a[68:71], v2 offset:38912
		ds_read_b128 a[72:75], v2 offset:39936
		ds_read_b128 v[32:35], v2 offset:49152
		ds_read_b128 v[36:39], v2 offset:50176
		ds_read_b128 v[232:235], v2 offset:51200
		ds_read_b128 v[236:239], v2 offset:52224
		ds_read_b128 a[76:79], v2 offset:53248
		ds_read_b128 a[80:83], v2 offset:54272
		ds_read_b128 a[84:87], v2 offset:55296
		ds_read_b128 a[88:91], v2 offset:56320
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[240:241], v3 offset:8192
		ds_read_b64_tr_b8 v[242:243], v3 offset:8704
		ds_read_b64_tr_b8 v[244:245], v7 offset:10240
		ds_read_b64_tr_b8 v[246:247], v7 offset:10752
		ds_read_b64_tr_b8 v[248:249], v3 offset:12288
		ds_read_b64_tr_b8 v[250:251], v3 offset:12800
		ds_read_b64_tr_b8 v[2:3], v7 offset:14336
		ds_read_b64_tr_b8 v[252:253], v7 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[12:15], v[8:11], v[16:19], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], v[12:15], v[20:23], v[40:43], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[12:15], v[24:27], v[44:47], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], v[12:15], v[28:31], v[48:51], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[0:3], v[8:11], v[68:71], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[0:3], v[20:23], v[72:75], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[0:3], v[24:27], v[76:79], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[0:3], v[28:31], v[80:83], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[4:7], v[8:11], v[100:103], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[4:7], v[20:23], v[104:107], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[4:7], v[24:27], v[108:111], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[4:7], v[28:31], v[112:115], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[8:11], v[8:11], v[132:135], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[8:11], v[20:23], v[136:139], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[8:11], v[24:27], v[140:143], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[8:11], v[28:31], v[144:147], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[12:15], v[8:11], v[164:167], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[12:15], v[20:23], v[168:171], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[12:15], v[24:27], v[172:175], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[12:15], v[28:31], v[176:179], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[16:19], v[8:11], v[184:187], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[16:19], v[20:23], v[188:191], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[16:19], v[24:27], v[192:195], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[16:19], v[28:31], v[196:199], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[20:23], v[8:11], v[200:203], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[20:23], v[20:23], v[204:207], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[20:23], v[24:27], v[208:211], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[20:23], v[28:31], v[212:215], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[24:27], v[8:11], v[216:219], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[24:27], v[20:23], v[220:223], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[24:27], v[24:27], v[224:227], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[24:27], v[28:31], v[228:231], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[28:31], v[32:35], v[16:19], v248, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[40:43], a[28:31], v[36:39], v[40:43], v248, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], a[28:31], v[232:235], v[44:47], v248, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[48:51], a[28:31], v[236:239], v[48:51], v248, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[32:35], v[32:35], v[68:71], v248, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[32:35], v[36:39], v[72:75], v248, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[32:35], v[232:235], v[76:79], v248, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[32:35], v[236:239], v[80:83], v248, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[36:39], v[32:35], v[100:103], v248, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[36:39], v[36:39], v[104:107], v248, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[36:39], v[232:235], v[108:111], v248, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[36:39], v[236:239], v[112:115], v248, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[40:43], v[32:35], v[132:135], v248, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[40:43], v[36:39], v[136:139], v248, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[40:43], v[232:235], v[140:143], v248, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[40:43], v[236:239], v[144:147], v248, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[44:47], v[32:35], v[164:167], v250, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[44:47], v[36:39], v[168:171], v250, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[44:47], v[232:235], v[172:175], v250, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[44:47], v[236:239], v[176:179], v250, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[48:51], v[32:35], v[184:187], v250, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[48:51], v[36:39], v[188:191], v250, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[48:51], v[232:235], v[192:195], v250, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[48:51], v[236:239], v[196:199], v250, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[52:55], v[32:35], v[200:203], v250, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[52:55], v[36:39], v[204:207], v250, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[52:55], v[232:235], v[208:211], v250, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[52:55], v[236:239], v[212:215], v250, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[56:59], v[32:35], v[216:219], v250, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[56:59], v[36:39], v[220:223], v250, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[56:59], v[232:235], v[224:227], v250, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[56:59], v[236:239], v[228:231], v250, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		v_lshlrev_b32_e32 v4, 15, v4
		v_add_u32_e32 v5, v4, v5
		ds_write_b64 v5, v[2:3]
		v_cvt_pk_f16_f32 v2, v40, v41
		v_cvt_pk_f16_f32 v3, v42, v43
		ds_write_b64 v5, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		ds_write_b64 v5, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v48, v49
		v_cvt_pk_f16_f32 v3, v50, v51
		ds_write_b64 v5, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		ds_write_b64 v5, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		ds_write_b64 v5, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		ds_write_b64 v5, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		ds_write_b64 v5, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		ds_write_b64 v5, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		ds_write_b64 v5, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		ds_write_b64 v5, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		ds_write_b64 v5, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		ds_write_b64 v5, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		ds_write_b64 v5, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		ds_write_b64 v5, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		ds_write_b64 v5, v[2:3] offset:13824
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		ds_write_b64 v5, v[2:3] offset:16384
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v5, v[2:3] offset:16896
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v5, v[2:3] offset:17408
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v5, v[2:3] offset:17920
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v5, v[2:3] offset:20480
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v5, v[2:3] offset:20992
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v5, v[2:3] offset:21504
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v5, v[2:3] offset:22016
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v5, v[2:3] offset:24576
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v5, v[2:3] offset:25088
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v5, v[2:3] offset:25600
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v5, v[2:3] offset:26112
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v5, v[2:3] offset:28672
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v5, v[2:3] offset:29184
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v5, v[2:3] offset:29696
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		ds_write_b64 v5, v[2:3] offset:30208
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v0, 63, v0
		s_mov_b32 s0, 32
		v_cmp_lt_u32_e64 vcc, v0, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v0, v1, 4, v4
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s8, 0x7000
		s_and_saveexec_b64 s[54:55], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[8:11], v0
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], 0 offen
		ds_read_b128 v[8:11], v0 offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], 0 offen offset:512
		ds_read_b128 v[8:11], v0 offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], 0 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], 0 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s0 offen
		ds_read_b128 v[8:11], v0 offset:4608
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s0 offen offset:512
		ds_read_b128 v[8:11], v0 offset:5120
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s0 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:5632
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s0 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s1 offen
		ds_read_b128 v[8:11], v0 offset:8704
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s1 offen offset:512
		ds_read_b128 v[8:11], v0 offset:9216
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s1 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:9728
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s1 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s4 offen
		ds_read_b128 v[8:11], v0 offset:12800
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s4 offen offset:512
		ds_read_b128 v[8:11], v0 offset:13312
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s4 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:13824
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s4 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s5 offen
		ds_read_b128 v[8:11], v0 offset:16896
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s5 offen offset:512
		ds_read_b128 v[8:11], v0 offset:17408
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s5 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:17920
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s5 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s6 offen
		ds_read_b128 v[8:11], v0 offset:20992
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s6 offen offset:512
		ds_read_b128 v[8:11], v0 offset:21504
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s6 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:22016
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s6 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:24576
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s7 offen
		ds_read_b128 v[8:11], v0 offset:25088
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s7 offen offset:512
		ds_read_b128 v[8:11], v0 offset:25600
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s7 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:26112
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s7 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:28672
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s8 offen
		ds_read_b128 v[8:11], v0 offset:29184
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s8 offen offset:512
		ds_read_b128 v[8:11], v0 offset:29696
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s8 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:30208
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[16:19], s8 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[54:55]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[12:15], a[60:63], v[52:55], v240, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[12:15], a[64:67], v[56:59], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[12:15], a[68:71], v[60:63], v240, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[12:15], a[72:75], v[64:67], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[0:3], a[60:63], v[84:87], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[0:3], a[64:67], v[88:91], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[0:3], a[68:71], v[92:95], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[0:3], a[72:75], v[96:99], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[4:7], a[60:63], v[116:119], v240, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[4:7], a[64:67], v[120:123], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[4:7], a[68:71], v[124:127], v240, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[4:7], a[72:75], v[128:131], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[8:11], a[60:63], v[148:151], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[8:11], a[64:67], v[152:155], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[8:11], a[68:71], v[156:159], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[8:11], a[72:75], v[160:163], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[12:15], a[60:63], v[180:183], v242, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[12:15], a[64:67], a[132:135], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[12:15], a[68:71], a[136:139], v242, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[12:15], a[72:75], a[140:143], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[16:19], a[60:63], a[144:147], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[16:19], a[64:67], a[148:151], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[16:19], a[68:71], a[152:155], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[16:19], a[72:75], a[156:159], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[20:23], a[60:63], a[160:163], v242, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[20:23], a[64:67], a[164:167], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[20:23], a[68:71], a[168:171], v242, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[20:23], a[72:75], a[172:175], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[24:27], a[60:63], a[176:179], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[24:27], a[64:67], a[180:183], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[24:27], a[68:71], a[184:187], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[24:27], a[72:75], a[188:191], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], a[28:31], a[76:79], v[52:55], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[28:31], a[80:83], v[56:59], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[28:31], a[84:87], v[60:63], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[28:31], a[88:91], v[64:67], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[32:35], a[76:79], v[84:87], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[32:35], a[80:83], v[88:91], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[32:35], a[84:87], v[92:95], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[32:35], a[88:91], v[96:99], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[36:39], a[76:79], v[116:119], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[36:39], a[80:83], v[120:123], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[36:39], a[84:87], v[124:127], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[36:39], a[88:91], v[128:131], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[40:43], a[76:79], v[148:151], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[40:43], a[80:83], v[152:155], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[40:43], a[84:87], v[156:159], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[40:43], a[88:91], v[160:163], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[44:47], a[76:79], v[180:183], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[44:47], a[80:83], a[132:135], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[44:47], a[84:87], a[136:139], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[44:47], a[88:91], a[140:143], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[48:51], a[76:79], a[144:147], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[48:51], a[80:83], a[148:151], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[48:51], a[84:87], a[152:155], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[48:51], a[88:91], a[156:159], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[52:55], a[76:79], a[160:163], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[52:55], a[80:83], a[164:167], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[52:55], a[84:87], a[168:171], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[52:55], a[88:91], a[172:175], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[56:59], a[76:79], a[176:179], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[56:59], a[80:83], a[180:183], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[56:59], a[84:87], a[184:187], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[56:59], a[88:91], a[188:191], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		ds_write_b64 v5, v[2:3] offset:2048
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		ds_write_b64 v5, v[2:3] offset:2560
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		ds_write_b64 v5, v[2:3] offset:3072
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		ds_write_b64 v5, v[2:3] offset:3584
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		ds_write_b64 v5, v[2:3] offset:6144
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		ds_write_b64 v5, v[2:3] offset:6656
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		ds_write_b64 v5, v[2:3] offset:7168
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		ds_write_b64 v5, v[2:3] offset:7680
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		ds_write_b64 v5, v[2:3] offset:10240
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		ds_write_b64 v5, v[2:3] offset:10752
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		ds_write_b64 v5, v[2:3] offset:11264
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		ds_write_b64 v5, v[2:3] offset:11776
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		ds_write_b64 v5, v[2:3] offset:14336
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		ds_write_b64 v5, v[2:3] offset:14848
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		ds_write_b64 v5, v[2:3] offset:15360
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		ds_write_b64 v5, v[2:3] offset:15872
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v5, v[2:3] offset:18432
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:18944
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:19456
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:19968
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:22528
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:23040
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:23552
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:24064
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:26624
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:27136
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:27648
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:28160
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:30720
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:31232
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:31744
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[54:55], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		ds_read_b128 v[4:7], v0 offset:2048
		ds_read_b128 v[8:11], v0 offset:2560
		ds_read_b128 v[12:15], v0 offset:3072
		ds_read_b128 v[16:19], v0 offset:3584
		ds_read_b128 v[20:23], v0 offset:6144
		ds_read_b128 v[24:27], v0 offset:6656
		ds_read_b128 v[28:31], v0 offset:7168
		ds_read_b128 v[32:35], v0 offset:7680
		ds_read_b128 v[36:39], v0 offset:10240
		ds_read_b128 v[40:43], v0 offset:10752
		ds_read_b128 v[44:47], v0 offset:11264
		ds_read_b128 v[48:51], v0 offset:11776
		ds_read_b128 v[52:55], v0 offset:14336
		ds_read_b128 v[56:59], v0 offset:14848
		ds_read_b128 v[60:63], v0 offset:15360
		ds_read_b128 v[64:67], v0 offset:15872
		ds_read_b128 v[68:71], v0 offset:18432
		ds_read_b128 v[72:75], v0 offset:18944
		ds_read_b128 v[76:79], v0 offset:19456
		ds_read_b128 v[80:83], v0 offset:19968
		ds_read_b128 v[84:87], v0 offset:22528
		ds_read_b128 v[88:91], v0 offset:23040
		ds_read_b128 v[92:95], v0 offset:23552
		ds_read_b128 v[96:99], v0 offset:24064
		ds_read_b128 v[100:103], v0 offset:26624
		ds_read_b128 v[104:107], v0 offset:27136
		ds_read_b128 v[108:111], v0 offset:27648
		ds_read_b128 v[112:115], v0 offset:28160
		ds_read_b128 v[116:119], v0 offset:30720
		ds_read_b128 v[120:123], v0 offset:31232
		ds_read_b128 v[124:127], v0 offset:31744
		ds_read_b128 v[128:131], v0 offset:32256
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[4:7], v0, s[16:19], 0 offen offset:2048
		buffer_store_dwordx4 v[8:11], v0, s[16:19], 0 offen offset:2560
		buffer_store_dwordx4 v[12:15], v0, s[16:19], 0 offen offset:3072
		buffer_store_dwordx4 v[16:19], v0, s[16:19], 0 offen offset:3584
		buffer_store_dwordx4 v[20:23], v0, s[16:19], s0 offen offset:2048
		buffer_store_dwordx4 v[24:27], v0, s[16:19], s0 offen offset:2560
		buffer_store_dwordx4 v[28:31], v0, s[16:19], s0 offen offset:3072
		buffer_store_dwordx4 v[32:35], v0, s[16:19], s0 offen offset:3584
		buffer_store_dwordx4 v[36:39], v0, s[16:19], s1 offen offset:2048
		buffer_store_dwordx4 v[40:43], v0, s[16:19], s1 offen offset:2560
		buffer_store_dwordx4 v[44:47], v0, s[16:19], s1 offen offset:3072
		buffer_store_dwordx4 v[48:51], v0, s[16:19], s1 offen offset:3584
		buffer_store_dwordx4 v[52:55], v0, s[16:19], s4 offen offset:2048
		buffer_store_dwordx4 v[56:59], v0, s[16:19], s4 offen offset:2560
		buffer_store_dwordx4 v[60:63], v0, s[16:19], s4 offen offset:3072
		buffer_store_dwordx4 v[64:67], v0, s[16:19], s4 offen offset:3584
		buffer_store_dwordx4 v[68:71], v0, s[16:19], s5 offen offset:2048
		buffer_store_dwordx4 v[72:75], v0, s[16:19], s5 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[76:79], v0, s[16:19], s5 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[80:83], v0, s[16:19], s5 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[84:87], v0, s[16:19], s6 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[88:91], v0, s[16:19], s6 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[92:95], v0, s[16:19], s6 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[96:99], v0, s[16:19], s6 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[100:103], v0, s[16:19], s7 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[104:107], v0, s[16:19], s7 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[108:111], v0, s[16:19], s7 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[112:115], v0, s[16:19], s7 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[116:119], v0, s[16:19], s8 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[120:123], v0, s[16:19], s8 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[124:127], v0, s[16:19], s8 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[128:131], v0, s[16:19], s8 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[54:55]
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
		.amdhsa_next_free_vgpr 448
		.amdhsa_next_free_sgpr 56
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 56
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
    .sgpr_count:     56
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
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
