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
		s_lshr_b32 s12, s13, 3
		s_lshl_b32 s14, s14, 1
		s_add_i32 s12, s14, s12
		s_and_b32 s13, s13, 7
		s_lshl_b32 s13, s13, 5
		s_add_i32 s12, s12, s13
		s_lshr_b32 s13, s12, 6
		s_lshl_b32 s14, s13, 23
		s_and_b32 s12, s12, 63
		s_lshr_b32 s15, s12, 2
		s_lshl_b32 s16, s15, 17
		s_add_i32 s14, s14, s16
		s_and_b32 s12, s12, 3
		v_readfirstlane_b32 s16, v0
		s_lshl_b32 s17, s12, 21
		s_add_i32 s14, s14, s17
		s_add_u32 s6, s6, s14
		s_addc_u32 s7, s7, 0
		v_and_b32_e32 v1, 63, v0
		s_lshr_b32 s14, s16, 6
		s_lshl_b32 s16, s14, 10
		s_add_i32 s14, s16, 0x1000
		s_add_i32 s17, s16, 0x2000
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshrrev_b32_e32 v3, 3, v1
		s_add_i32 s18, s16, 0x3000
		s_add_i32 s19, s16, 0x4000
		s_add_i32 s20, s16, 0x5000
		s_add_i32 s21, s16, 0x6000
		v_lshrrev_b32_e32 v4, 6, v0
		v_accvgpr_write_b32 a0, v4
		v_and_b32_e32 v3, 3, v3
		v_and_b32_e32 v4, 3, v1
		s_add_i32 s22, s16, 0x7000
		v_lshlrev_b32_e32 v2, 12, v2
		s_add_i32 s23, s16, 0x8000
		s_add_i32 s24, s16, 0x9000
		s_add_i32 s25, s16, 0xa000
		v_xor_b32_e32 v3, v3, v4
		s_add_i32 s26, s16, 0xb000
		v_accvgpr_read_b32 v4, a0
		v_lshl_add_u32 v2, v4, 16, v2
		s_add_i32 s27, s16, 0xc000
		s_add_i32 s28, s16, 0xd000
		s_add_i32 s29, s16, 0xe000
		s_add_i32 s30, s16, 0xf000
		v_lshl_add_u32 v2, v3, 4, v2
		s_lshl_b32 s31, s13, 22
		s_lshl_b32 s32, s12, 20
		s_add_i32 s33, s31, s32
		v_add_u32_e32 v3, s33, v2
		s_mov_b32 m0, s16
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s38, 0x1000000
		s_mov_b32 s39, 0x31016000
		buffer_load_dwordx4 v3, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0x40000
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0x80000
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s17
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0xc0000
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 64
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0x40040
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0x80040
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_add_i32 s2, s31, 0xc0040
		s_add_i32 s2, s2, s32
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v4, s[36:39], 0 offen lds
		s_lshl_b32 s2, s15, 20
		v_add_u32_e32 v4, s2, v2
		s_mov_b32 m0, s23
		s_mov_b32 s40, s4
		s_mov_b32 s41, s5
		s_mov_b32 s42, 0x1000000
		s_mov_b32 s43, 0x31016000
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0x40000
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0x80000
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0xc0000
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		v_add3_u32 v5, s2, 64, v2
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0x40040
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0x80040
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		s_add_i32 s3, s2, 0xc0040
		v_add_u32_e32 v5, s3, v2
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshrrev_b32_e32 v6, 4, v1
		v_lshlrev_b32_e32 v7, 10, v5
		v_and_b32_e32 v0, 15, v0
		v_accvgpr_read_b32 v8, a0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v9, 7, v5
		v_lshlrev_b32_e32 v10, 12, v6
		v_lshlrev_b32_e32 v11, 2, v0
		v_lshlrev_b32_e32 v12, 7, v6
		v_add_u32_e32 v13, 0x20000, v7
		v_accvgpr_write_b32 a1, v13
		s_mov_b32 s3, 0
		s_lshl_b32 s4, s13, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_cmp_eq_u32_e64 vcc, v8, s3
		s_mov_b64 s[34:35], vcc
		v_add3_u32 v9, v9, v10, v11
		v_accvgpr_read_b32 v10, a1
		v_add3_u32 v10, v10, v12, v11
		s_lshl_b32 s5, s12, 8
		s_add_i32 s12, s4, s5
		s_add_i32 s13, s4, 0x4000
		s_add_i32 s13, s13, s5
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, 0x20000
		s_mov_b32 s11, 0x31016000
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v13, v9, s[48:51], s12 offen
		buffer_load_dword v14, v9, s[48:51], s12 offen offset:64
		buffer_load_dword v15, v9, s[48:51], s13 offen
		buffer_load_dword v20, v9, s[48:51], s13 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v10, v13
		ds_write_b32 v10, v14 offset:512
		ds_write_b32 v10, v15 offset:4096
		ds_write_b32 v10, v20 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[52:53]
		v_add_u32_e32 v13, 0x20000, v12
		v_lshl_add_u32 v14, v6, 12, v11
		v_add_u32_e32 v13, v13, v11
		v_cmp_eq_u32_e64 vcc, v5, s3
		s_mov_b64 s[0:1], vcc
		v_lshl_add_u32 v14, v8, 7, v14
		v_lshl_add_u32 v13, v8, 10, v13
		s_lshl_b32 s6, s15, 8
		s_add_i32 s7, s6, 0x4000
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v15, v14, s[44:47], s6 offen
		buffer_load_dword v20, v14, s[44:47], s6 offen offset:64
		buffer_load_dword v21, v14, s[44:47], s7 offen
		buffer_load_dword v22, v14, s[44:47], s7 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v13, v15 offset:2048
		ds_write_b32 v13, v20 offset:2560
		ds_write_b32 v13, v21 offset:6144
		ds_write_b32 v13, v22 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s7, s4, 0x8000
		s_add_i32 s7, s7, s5
		s_add_i32 s12, s4, 0xc000
		s_add_i32 s12, s12, s5
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v15, v9, s[48:51], s7 offen
		buffer_load_dword v20, v9, s[48:51], s7 offen offset:64
		buffer_load_dword v21, v9, s[48:51], s12 offen
		buffer_load_dword v22, v9, s[48:51], s12 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v10, v15 offset:8192
		ds_write_b32 v10, v20 offset:8704
		ds_write_b32 v10, v21 offset:12288
		ds_write_b32 v10, v22 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s7, s6, 0x8000
		s_add_i32 s12, s6, 0xc000
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v10, v14, s[44:47], s7 offen
		buffer_load_dword v15, v14, s[44:47], s7 offen offset:64
		buffer_load_dword v20, v14, s[44:47], s12 offen
		buffer_load_dword v21, v14, s[44:47], s12 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v13, v10 offset:10240
		ds_write_b32 v13, v15 offset:10752
		ds_write_b32 v13, v20 offset:14336
		ds_write_b32 v13, v21 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[52:53]
		s_add_i32 m0, s16, 0x10000
		s_add_i32 s7, s31, 0x80
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x11000
		s_add_i32 s7, s31, 0x40080
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x12000
		s_add_i32 s7, s31, 0x80080
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x13000
		s_add_i32 s7, s31, 0xc0080
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x14000
		s_add_i32 s7, s31, 0xc0
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x15000
		s_add_i32 s7, s31, 0x400c0
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x16000
		s_add_i32 s7, s31, 0x800c0
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x17000
		s_add_i32 s7, s31, 0xc00c0
		s_add_i32 s7, s7, s32
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[36:39], 0 offen lds
		s_add_i32 m0, s16, 0x18000
		s_add_i32 s7, s2, 0x80
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x19000
		s_add_i32 s7, s2, 0x40080
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1a000
		s_add_i32 s7, s2, 0x80080
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1b000
		s_add_i32 s7, s2, 0xc0080
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1c000
		s_add_i32 s7, s2, 0xc0
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1d000
		s_add_i32 s7, s2, 0x400c0
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1e000
		s_add_i32 s7, s2, 0x800c0
		v_add_u32_e32 v10, s7, v2
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_add_i32 m0, s16, 0x1f000
		s_add_i32 s2, s2, 0xc00c0
		v_add_u32_e32 v2, s2, v2
		buffer_load_dwordx4 v2, s[40:43], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		v_lshlrev_b32_e32 v2, 13, v5
		v_lshlrev_b32_e32 v5, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_and_b32_e32 v0, 3, v0
		v_xor_b32_e32 v0, v6, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v6, v2, v5, v0
		ds_read_b128 v[20:23], v6
		ds_read_b128 v[24:27], v6 offset:1024
		ds_read_b128 v[28:31], v6 offset:2048
		ds_read_b128 v[32:35], v6 offset:3072
		ds_read_b128 v[36:39], v6 offset:4096
		ds_read_b128 v[40:43], v6 offset:5120
		ds_read_b128 v[44:47], v6 offset:6144
		ds_read_b128 v[48:51], v6 offset:7168
		ds_read_b128 v[52:55], v6 offset:16384
		ds_read_b128 v[56:59], v6 offset:17408
		ds_read_b128 v[60:63], v6 offset:18432
		ds_read_b128 v[64:67], v6 offset:19456
		ds_read_b128 v[68:71], v6 offset:20480
		ds_read_b128 v[72:75], v6 offset:21504
		ds_read_b128 v[76:79], v6 offset:22528
		ds_read_b128 v[80:83], v6 offset:23552
		v_lshlrev_b32_e32 v6, 13, v8
		v_add3_u32 v10, v5, v6, v0
		ds_read_b128 v[84:87], v10 offset:32768
		ds_read_b128 v[88:91], v10 offset:33792
		ds_read_b128 v[92:95], v10 offset:34816
		ds_read_b128 v[96:99], v10 offset:35840
		ds_read_b128 v[100:103], v10 offset:36864
		ds_read_b128 v[104:107], v10 offset:37888
		ds_read_b128 v[108:111], v10 offset:38912
		ds_read_b128 v[112:115], v10 offset:39936
		ds_read_b128 v[116:119], v10 offset:49152
		ds_read_b128 v[120:123], v10 offset:50176
		ds_read_b128 v[124:127], v10 offset:51200
		ds_read_b128 v[128:131], v10 offset:52224
		ds_read_b128 v[132:135], v10 offset:53248
		ds_read_b128 v[136:139], v10 offset:54272
		ds_read_b128 v[140:143], v10 offset:55296
		ds_read_b128 v[144:147], v10 offset:56320
		v_add_u32_e32 v10, 0x100, v3
		v_add_u32_e32 v13, 0x40100, v3
		v_add_u32_e32 v15, 0x80100, v3
		v_add_u32_e32 v148, 0xc0100, v3
		v_add_u32_e32 v149, 0x140, v3
		v_add_u32_e32 v150, 0x40140, v3
		v_add_u32_e32 v151, 0x80140, v3
		v_add_u32_e32 v152, 0xc0140, v3
		v_add_u32_e32 v3, 0x100, v4
		v_add_u32_e32 v153, 0x40100, v4
		v_add_u32_e32 v154, 0x80100, v4
		v_add_u32_e32 v155, 0xc0100, v4
		v_add_u32_e32 v156, 0x140, v4
		v_add_u32_e32 v157, 0x40140, v4
		v_add_u32_e32 v158, 0x80140, v4
		v_add_u32_e32 v159, 0xc0140, v4
		s_cmp_lt_i32 0, 30
		v_lshlrev_b32_e32 v4, 3, v1
		v_lshlrev_b32_e32 v160, 10, v8
		s_cselect_b32 s2, 1, 0
		s_add_i32 s7, s4, 0x10000
		s_add_i32 s7, s7, s5
		s_add_i32 s4, s4, 0x14000
		s_add_i32 s4, s4, s5
		s_add_i32 s5, s6, 0x10000
		s_add_i32 s6, s6, 0x14000
		s_cmp_lg_u32 s2, 0
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_accvgpr_write_b32 a4, v176
		v_accvgpr_write_b32 a5, v177
		v_accvgpr_write_b32 a6, v178
		v_accvgpr_write_b32 a7, v179
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_accvgpr_write_b32 a8, v176
		v_accvgpr_write_b32 a9, v177
		v_accvgpr_write_b32 a10, v178
		v_accvgpr_write_b32 a11, v179
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_accvgpr_write_b32 a12, v176
		v_accvgpr_write_b32 a13, v177
		v_accvgpr_write_b32 a14, v178
		v_accvgpr_write_b32 a15, v179
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_accvgpr_write_b32 a16, v176
		v_accvgpr_write_b32 a17, v177
		v_accvgpr_write_b32 a18, v178
		v_accvgpr_write_b32 a19, v179
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
		v_accvgpr_write_b32 a20, v192
		v_accvgpr_write_b32 a21, v193
		v_accvgpr_write_b32 a22, v194
		v_accvgpr_write_b32 a23, v195
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a24, v192
		v_accvgpr_write_b32 a25, v193
		v_accvgpr_write_b32 a26, v194
		v_accvgpr_write_b32 a27, v195
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a28, v192
		v_accvgpr_write_b32 a29, v193
		v_accvgpr_write_b32 a30, v194
		v_accvgpr_write_b32 a31, v195
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a32, v192
		v_accvgpr_write_b32 a33, v193
		v_accvgpr_write_b32 a34, v194
		v_accvgpr_write_b32 a35, v195
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
		v_accvgpr_write_b32 a36, v208
		v_accvgpr_write_b32 a37, v209
		v_accvgpr_write_b32 a38, v210
		v_accvgpr_write_b32 a39, v211
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a40, v208
		v_accvgpr_write_b32 a41, v209
		v_accvgpr_write_b32 a42, v210
		v_accvgpr_write_b32 a43, v211
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a44, v208
		v_accvgpr_write_b32 a45, v209
		v_accvgpr_write_b32 a46, v210
		v_accvgpr_write_b32 a47, v211
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a48, v208
		v_accvgpr_write_b32 a49, v209
		v_accvgpr_write_b32 a50, v210
		v_accvgpr_write_b32 a51, v211
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
		v_accvgpr_write_b32 a52, v224
		v_accvgpr_write_b32 a53, v225
		v_accvgpr_write_b32 a54, v226
		v_accvgpr_write_b32 a55, v227
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a56, v224
		v_accvgpr_write_b32 a57, v225
		v_accvgpr_write_b32 a58, v226
		v_accvgpr_write_b32 a59, v227
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a60, v224
		v_accvgpr_write_b32 a61, v225
		v_accvgpr_write_b32 a62, v226
		v_accvgpr_write_b32 a63, v227
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a64, v224
		v_accvgpr_write_b32 a65, v225
		v_accvgpr_write_b32 a66, v226
		v_accvgpr_write_b32 a67, v227
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
		v_accvgpr_write_b32 a68, v240
		v_accvgpr_write_b32 a69, v241
		v_accvgpr_write_b32 a70, v242
		v_accvgpr_write_b32 a71, v243
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a72, v240
		v_accvgpr_write_b32 a73, v241
		v_accvgpr_write_b32 a74, v242
		v_accvgpr_write_b32 a75, v243
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a76, v240
		v_accvgpr_write_b32 a77, v241
		v_accvgpr_write_b32 a78, v242
		v_accvgpr_write_b32 a79, v243
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a80, v240
		v_accvgpr_write_b32 a81, v241
		v_accvgpr_write_b32 a82, v242
		v_accvgpr_write_b32 a83, v243
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a84, v244
		v_accvgpr_write_b32 a85, v245
		v_accvgpr_write_b32 a86, v246
		v_accvgpr_write_b32 a87, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a88, v244
		v_accvgpr_write_b32 a89, v245
		v_accvgpr_write_b32 a90, v246
		v_accvgpr_write_b32 a91, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a92, v244
		v_accvgpr_write_b32 a93, v245
		v_accvgpr_write_b32 a94, v246
		v_accvgpr_write_b32 a95, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a96, v244
		v_accvgpr_write_b32 a97, v245
		v_accvgpr_write_b32 a98, v246
		v_accvgpr_write_b32 a99, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a100, v244
		v_accvgpr_write_b32 a101, v245
		v_accvgpr_write_b32 a102, v246
		v_accvgpr_write_b32 a103, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a104, v244
		v_accvgpr_write_b32 a105, v245
		v_accvgpr_write_b32 a106, v246
		v_accvgpr_write_b32 a107, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a108, v244
		v_accvgpr_write_b32 a109, v245
		v_accvgpr_write_b32 a110, v246
		v_accvgpr_write_b32 a111, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a112, v244
		v_accvgpr_write_b32 a113, v245
		v_accvgpr_write_b32 a114, v246
		v_accvgpr_write_b32 a115, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a116, v244
		v_accvgpr_write_b32 a117, v245
		v_accvgpr_write_b32 a118, v246
		v_accvgpr_write_b32 a119, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a120, v244
		v_accvgpr_write_b32 a121, v245
		v_accvgpr_write_b32 a122, v246
		v_accvgpr_write_b32 a123, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a124, v244
		v_accvgpr_write_b32 a125, v245
		v_accvgpr_write_b32 a126, v246
		v_accvgpr_write_b32 a127, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a128, v244
		v_accvgpr_write_b32 a129, v245
		v_accvgpr_write_b32 a130, v246
		v_accvgpr_write_b32 a131, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a132, v244
		v_accvgpr_write_b32 a133, v245
		v_accvgpr_write_b32 a134, v246
		v_accvgpr_write_b32 a135, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a136, v244
		v_accvgpr_write_b32 a137, v245
		v_accvgpr_write_b32 a138, v246
		v_accvgpr_write_b32 a139, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a140, v244
		v_accvgpr_write_b32 a141, v245
		v_accvgpr_write_b32 a142, v246
		v_accvgpr_write_b32 a143, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a144, v244
		v_accvgpr_write_b32 a145, v245
		v_accvgpr_write_b32 a146, v246
		v_accvgpr_write_b32 a147, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a148, v244
		v_accvgpr_write_b32 a149, v245
		v_accvgpr_write_b32 a150, v246
		v_accvgpr_write_b32 a151, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a152, v244
		v_accvgpr_write_b32 a153, v245
		v_accvgpr_write_b32 a154, v246
		v_accvgpr_write_b32 a155, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a156, v244
		v_accvgpr_write_b32 a157, v245
		v_accvgpr_write_b32 a158, v246
		v_accvgpr_write_b32 a159, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a160, v244
		v_accvgpr_write_b32 a161, v245
		v_accvgpr_write_b32 a162, v246
		v_accvgpr_write_b32 a163, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_write_b32 a166, v246
		v_accvgpr_write_b32 a167, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_write_b32 a170, v246
		v_accvgpr_write_b32 a171, v247
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
		v_accvgpr_write_b32 a172, v244
		v_accvgpr_write_b32 a173, v245
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s2, s3, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s12, s3, 1
		s_lshl_b32 s12, s12, 13
		s_add_i32 s13, s12, 0x20000
		v_add_u32_e32 v161, s13, v7
		v_add_u32_e32 v162, v161, v4
		ds_read_b64_tr_b8 v[244:245], v162
		ds_read_b64_tr_b8 v[246:247], v162 offset:512
		v_add3_u32 v163, s13, v4, v160
		ds_read_b64_tr_b8 v[248:249], v163 offset:2048
		ds_read_b64_tr_b8 v[250:251], v162 offset:4096
		ds_read_b64_tr_b8 v[252:253], v162 offset:4608
		ds_read_b64_tr_b8 v[254:255], v163 offset:6144
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[84:87], v[16:19], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[88:91], v[164:167], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[92:95], v[168:171], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[96:99], v[172:175], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[84:87], v[176:179], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[88:91], v[180:183], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[92:95], v[184:187], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[96:99], v[188:191], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[84:87], v[192:195], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[88:91], v[196:199], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[92:95], v[200:203], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[96:99], v[204:207], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[84:87], v[208:211], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[88:91], v[212:215], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[92:95], v[216:219], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[96:99], v[220:223], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[84:87], v[224:227], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], v[88:91], v[228:231], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], v[92:95], v[232:235], v246, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[36:39], v[96:99], v[236:239], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], v[84:87], v[240:243], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[88:91], a[84:87], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], v[92:95], a[88:91], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], v[96:99], a[92:95], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[84:87], a[112:115], v246, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[88:91], a[116:119], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], v[92:95], a[120:123], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], v[96:99], a[124:127], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[84:87], a[144:147], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[88:91], a[148:151], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], v[92:95], a[152:155], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], v[96:99], a[156:159], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[116:119], v[16:19], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], v[120:123], v[164:167], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[124:127], v[168:171], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], v[128:131], v[172:175], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[116:119], v[176:179], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], v[120:123], v[180:183], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], v[124:127], v[184:187], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], v[128:131], v[188:191], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], v[116:119], v[192:195], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[60:63], v[120:123], v[196:199], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], v[124:127], v[200:203], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], v[128:131], v[204:207], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[116:119], v[208:211], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[120:123], v[212:215], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[64:67], v[124:127], v[216:219], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[128:131], v[220:223], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], v[116:119], v[224:227], v252, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[68:71], v[120:123], v[228:231], v252, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[68:71], v[124:127], v[232:235], v252, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], v[128:131], v[236:239], v252, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[72:75], v[116:119], v[240:243], v252, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[72:75], v[120:123], a[84:87], v252, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[72:75], v[124:127], a[88:91], v252, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[72:75], v[128:131], a[92:95], v252, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[116:119], a[112:115], v252, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[120:123], a[116:119], v252, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], v[124:127], a[120:123], v252, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[76:79], v[128:131], a[124:127], v252, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[116:119], a[144:147], v252, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], v[120:123], a[148:151], v252, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], v[124:127], a[152:155], v252, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], v[128:131], a[156:159], v252, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[84:85], v163 offset:2560
		ds_read_b64_tr_b8 v[86:87], v163 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s13, s3, 15
		s_add_i32 s15, s7, s13
		s_add_i32 s31, s4, s13
		s_add_i32 s32, s12, 0x20200
		v_add_u32_e32 v88, s32, v7
		s_add_i32 s32, s12, 0x21000
		v_add_u32_e32 v89, s32, v7
		s_add_i32 s32, s12, 0x21200
		v_add_u32_e32 v90, s32, v7
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v91, v9, s[48:51], s15 offen
		buffer_load_dword v92, v9, s[48:51], s15 offen offset:64
		buffer_load_dword v93, v9, s[48:51], s31 offen
		buffer_load_dword v94, v9, s[48:51], s31 offen offset:64
		v_add3_u32 v95, v161, v12, v11
		v_add3_u32 v96, v88, v12, v11
		v_add3_u32 v97, v89, v12, v11
		v_add3_u32 v98, v90, v12, v11
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s15, s5, s13
		s_add_i32 s13, s6, s13
		s_add_i32 s31, s12, 0x20800
		v_add_u32_e32 v88, s31, v12
		s_add_i32 s31, s12, 0x20a00
		v_add_u32_e32 v89, s31, v12
		s_add_i32 s31, s12, 0x21800
		v_add_u32_e32 v90, s31, v12
		s_add_i32 s12, s12, 0x21a00
		v_add_u32_e32 v99, s12, v12
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v116, v14, s[44:47], s15 offen
		buffer_load_dword v117, v14, s[44:47], s15 offen offset:64
		buffer_load_dword v118, v14, s[44:47], s13 offen
		buffer_load_dword v119, v14, s[44:47], s13 offen offset:64
		v_add3_u32 v120, v88, v11, v160
		v_add3_u32 v121, v89, v11, v160
		v_add3_u32 v122, v90, v11, v160
		v_add3_u32 v123, v99, v11, v160
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s16
		s_nop 0
		buffer_load_dwordx4 v10, s[36:39], s2 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v13, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[100:103], a[4:7], v244, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[104:107], a[8:11], v244, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[108:111], a[12:15], v244, v84 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[112:115], a[16:19], v244, v84 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s17
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[24:27], v[100:103], a[20:23], v244, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[24:27], v[104:107], a[24:27], v244, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[24:27], v[108:111], a[28:31], v244, v84 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[112:115], a[32:35], v244, v84 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], v[100:103], a[36:39], v244, v84 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], v[104:107], a[40:43], v244, v84 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v148, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], v[108:111], a[44:47], v244, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], v[112:115], a[48:51], v244, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], v[100:103], a[52:55], v244, v84 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], v[104:107], a[56:59], v244, v84 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], v[108:111], a[60:63], v244, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], v[112:115], a[64:67], v244, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v149, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], v[100:103], a[68:71], v246, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], v[104:107], a[72:75], v246, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[108:111], a[76:79], v246, v84 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], v[112:115], a[80:83], v246, v84 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], v[100:103], a[96:99], v246, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[104:107], a[100:103], v246, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v150, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[108:111], a[104:107], v246, v84 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[112:115], a[108:111], v246, v84 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], v[100:103], a[128:131], v246, v84 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], v[104:107], a[132:135], v246, v84 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[108:111], a[136:139], v246, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[112:115], a[140:143], v246, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v151, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], v[100:103], a[160:163], v246, v84 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[104:107], a[164:167], v246, v84 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[108:111], a[168:171], v246, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], v[112:115], a[172:175], v246, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[52:55], v[132:135], a[4:7], v250, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[52:55], v[136:139], a[8:11], v250, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v152, s[36:39], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[52:55], v[140:143], a[12:15], v250, v86 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[52:55], v[144:147], a[16:19], v250, v86 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[56:59], v[132:135], a[20:23], v250, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[56:59], v[136:139], a[24:27], v250, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[56:59], v[140:143], a[28:31], v250, v86 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[56:59], v[144:147], a[32:35], v250, v86 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v3, s[40:43], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[60:63], v[132:135], a[36:39], v250, v86 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[60:63], v[136:139], a[40:43], v250, v86 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[60:63], v[140:143], a[44:47], v250, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[60:63], v[144:147], a[48:51], v250, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[64:67], v[132:135], a[52:55], v250, v86 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[64:67], v[136:139], a[56:59], v250, v86 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v154, s[40:43], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[64:67], v[140:143], a[60:63], v250, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[64:67], v[144:147], a[64:67], v250, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[68:71], v[132:135], a[68:71], v252, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[68:71], v[136:139], a[72:75], v252, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[68:71], v[140:143], a[76:79], v252, v86 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[68:71], v[144:147], a[80:83], v252, v86 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v156, s[40:43], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[72:75], v[132:135], a[96:99], v252, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[72:75], v[136:139], a[100:103], v252, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], v[140:143], a[104:107], v252, v86 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[72:75], v[144:147], a[108:111], v252, v86 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], v[132:135], a[128:131], v252, v86 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[136:139], a[132:135], v252, v86 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v158, s[40:43], s2 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[140:143], a[136:139], v252, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[144:147], a[140:143], v252, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[80:83], v[132:135], a[160:163], v252, v86 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], v[136:139], a[164:167], v252, v86 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], v[140:143], a[168:171], v252, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[144:147], a[172:175], v252, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v95, v91
		ds_write_b32 v96, v92
		ds_write_b32 v97, v93
		ds_write_b32 v98, v94
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[52:53]
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v120, v116
		ds_write_b32 v121, v117
		ds_write_b32 v122, v118
		ds_write_b32 v123, v119
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v153, s[40:43], s2 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v155, s[40:43], s2 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v157, s[40:43], s2 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v159, s[40:43], s2 offen lds
		s_waitcnt vmcnt(24)
		s_barrier
		s_add_i32 s3, s3, 1
		s_and_b32 s2, s3, 1
		s_lshl_b32 s2, s2, 16
		v_add_u32_e32 v20, s2, v2
		v_add3_u32 v84, v20, v5, v0
		ds_read_b128 v[20:23], v84
		ds_read_b128 v[24:27], v84 offset:1024
		ds_read_b128 v[28:31], v84 offset:2048
		ds_read_b128 v[32:35], v84 offset:3072
		ds_read_b128 v[36:39], v84 offset:4096
		ds_read_b128 v[40:43], v84 offset:5120
		ds_read_b128 v[44:47], v84 offset:6144
		ds_read_b128 v[48:51], v84 offset:7168
		ds_read_b128 v[52:55], v84 offset:16384
		ds_read_b128 v[56:59], v84 offset:17408
		ds_read_b128 v[60:63], v84 offset:18432
		ds_read_b128 v[64:67], v84 offset:19456
		ds_read_b128 v[68:71], v84 offset:20480
		ds_read_b128 v[72:75], v84 offset:21504
		ds_read_b128 v[76:79], v84 offset:22528
		ds_read_b128 v[80:83], v84 offset:23552
		v_add_u32_e32 v84, s2, v5
		v_add3_u32 v161, v84, v6, v0
		ds_read_b128 v[84:87], v161 offset:32768
		ds_read_b128 v[88:91], v161 offset:33792
		ds_read_b128 v[92:95], v161 offset:34816
		ds_read_b128 v[96:99], v161 offset:35840
		ds_read_b128 v[100:103], v161 offset:36864
		ds_read_b128 v[104:107], v161 offset:37888
		ds_read_b128 v[108:111], v161 offset:38912
		ds_read_b128 v[112:115], v161 offset:39936
		ds_read_b128 v[116:119], v161 offset:49152
		ds_read_b128 v[120:123], v161 offset:50176
		ds_read_b128 v[124:127], v161 offset:51200
		ds_read_b128 v[128:131], v161 offset:52224
		ds_read_b128 v[132:135], v161 offset:53248
		ds_read_b128 v[136:139], v161 offset:54272
		ds_read_b128 v[140:143], v161 offset:55296
		ds_read_b128 v[144:147], v161 offset:56320
		s_add_i32 s2, s16, 0x10000
		s_and_b32 s16, s2, 0x1ffff
		s_add_i32 s2, s14, 0x10000
		s_and_b32 s14, s2, 0x1ffff
		s_add_i32 s2, s17, 0x10000
		s_and_b32 s17, s2, 0x1ffff
		s_add_i32 s2, s18, 0x10000
		s_and_b32 s18, s2, 0x1ffff
		s_add_i32 s2, s19, 0x10000
		s_and_b32 s19, s2, 0x1ffff
		s_add_i32 s2, s20, 0x10000
		s_and_b32 s20, s2, 0x1ffff
		s_add_i32 s2, s21, 0x10000
		s_and_b32 s21, s2, 0x1ffff
		s_add_i32 s2, s22, 0x10000
		s_and_b32 s22, s2, 0x1ffff
		s_add_i32 s2, s23, 0x10000
		s_and_b32 s23, s2, 0x1ffff
		s_add_i32 s2, s25, 0x10000
		s_and_b32 s25, s2, 0x1ffff
		s_add_i32 s2, s27, 0x10000
		s_and_b32 s27, s2, 0x1ffff
		s_add_i32 s2, s29, 0x10000
		s_and_b32 s29, s2, 0x1ffff
		s_add_i32 s2, s24, 0x10000
		s_and_b32 s24, s2, 0x1ffff
		s_add_i32 s2, s26, 0x10000
		s_and_b32 s26, s2, 0x1ffff
		s_add_i32 s2, s28, 0x10000
		s_and_b32 s28, s2, 0x1ffff
		s_add_i32 s2, s30, 0x10000
		s_and_b32 s30, s2, 0x1ffff
		s_cmp_lt_i32 s3, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v3, a1
		v_add_u32_e32 v3, v3, v4
		ds_read_b64_tr_b8 v[10:11], v3
		ds_read_b64_tr_b8 v[12:13], v3 offset:512
		v_add_u32_e32 v7, 0x20000, v4
		v_lshl_add_u32 v7, v8, 10, v7
		ds_read_b64_tr_b8 v[8:9], v7 offset:2048
		ds_read_b64_tr_b8 v[14:15], v7 offset:2560
		ds_read_b64_tr_b8 v[148:149], v3 offset:4096
		ds_read_b64_tr_b8 v[150:151], v3 offset:4608
		ds_read_b64_tr_b8 v[152:153], v7 offset:6144
		ds_read_b64_tr_b8 v[154:155], v7 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[84:87], v[16:19], v10, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[88:91], v[164:167], v10, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[92:95], v[168:171], v10, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[96:99], v[172:175], v10, v8 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[100:103], a[4:7], v10, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[104:107], a[8:11], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[108:111], a[12:15], v10, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[112:115], a[16:19], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[84:87], v[176:179], v10, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[88:91], v[180:183], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[92:95], v[184:187], v10, v8 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[96:99], v[188:191], v10, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[24:27], v[100:103], a[20:23], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[24:27], v[104:107], a[24:27], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[24:27], v[108:111], a[28:31], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[112:115], a[32:35], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[84:87], v[192:195], v10, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[88:91], v[196:199], v10, v8 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[92:95], v[200:203], v10, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[96:99], v[204:207], v10, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], v[100:103], a[36:39], v10, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], v[104:107], a[40:43], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], v[108:111], a[44:47], v10, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], v[112:115], a[48:51], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[84:87], v[208:211], v10, v8 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[88:91], v[212:215], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[92:95], v[216:219], v10, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[96:99], v[220:223], v10, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], v[100:103], a[52:55], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], v[104:107], a[56:59], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], v[108:111], a[60:63], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], v[112:115], a[64:67], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[84:87], v[224:227], v12, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], v[88:91], v[228:231], v12, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], v[92:95], v[232:235], v12, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[36:39], v[96:99], v[236:239], v12, v8 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], v[100:103], a[68:71], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], v[104:107], a[72:75], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[108:111], a[76:79], v12, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], v[112:115], a[80:83], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], v[84:87], v[240:243], v12, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[88:91], a[84:87], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], v[92:95], a[88:91], v12, v8 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], v[96:99], a[92:95], v12, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], v[100:103], a[96:99], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[104:107], a[100:103], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[108:111], a[104:107], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[112:115], a[108:111], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[84:87], a[112:115], v12, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[88:91], a[116:119], v12, v8 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], v[92:95], a[120:123], v12, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], v[96:99], a[124:127], v12, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], v[100:103], a[128:131], v12, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], v[104:107], a[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[108:111], a[136:139], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[112:115], a[140:143], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[84:87], a[144:147], v12, v8 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[88:91], a[148:151], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], v[92:95], a[152:155], v12, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], v[96:99], a[156:159], v12, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[48:51], v[100:103], a[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[104:107], a[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[108:111], a[168:171], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], v[112:115], a[172:175], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[116:119], v[16:19], v148, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[52:55], v[120:123], v[164:167], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[124:127], v[168:171], v148, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], v[128:131], v[172:175], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[52:55], v[132:135], a[4:7], v148, v154 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[52:55], v[136:139], a[8:11], v148, v154 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[52:55], v[140:143], a[12:15], v148, v154 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[52:55], v[144:147], a[16:19], v148, v154 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[116:119], v[176:179], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], v[120:123], v[180:183], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], v[124:127], v[184:187], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], v[128:131], v[188:191], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[56:59], v[132:135], a[20:23], v148, v154 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[56:59], v[136:139], a[24:27], v148, v154 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[56:59], v[140:143], a[28:31], v148, v154 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[56:59], v[144:147], a[32:35], v148, v154 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], v[116:119], v[192:195], v148, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[60:63], v[120:123], v[196:199], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], v[124:127], v[200:203], v148, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], v[128:131], v[204:207], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[60:63], v[132:135], a[36:39], v148, v154 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[60:63], v[136:139], a[40:43], v148, v154 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[60:63], v[140:143], a[44:47], v148, v154 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[60:63], v[144:147], a[48:51], v148, v154 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[116:119], v[208:211], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[120:123], v[212:215], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[64:67], v[124:127], v[216:219], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[128:131], v[220:223], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[64:67], v[132:135], a[52:55], v148, v154 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[64:67], v[136:139], a[56:59], v148, v154 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[64:67], v[140:143], a[60:63], v148, v154 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[64:67], v[144:147], a[64:67], v148, v154 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], v[116:119], v[224:227], v150, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[68:71], v[120:123], v[228:231], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[68:71], v[124:127], v[232:235], v150, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[68:71], v[128:131], v[236:239], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[68:71], v[132:135], a[68:71], v150, v154 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[68:71], v[136:139], a[72:75], v150, v154 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[68:71], v[140:143], a[76:79], v150, v154 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[68:71], v[144:147], a[80:83], v150, v154 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[72:75], v[116:119], v[240:243], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[72:75], v[120:123], a[84:87], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[72:75], v[124:127], a[88:91], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[72:75], v[128:131], a[92:95], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[72:75], v[132:135], a[96:99], v150, v154 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[72:75], v[136:139], a[100:103], v150, v154 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], v[140:143], a[104:107], v150, v154 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[72:75], v[144:147], a[108:111], v150, v154 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[116:119], a[112:115], v150, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[120:123], a[116:119], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[76:79], v[124:127], a[120:123], v150, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[76:79], v[128:131], a[124:127], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[76:79], v[132:135], a[128:131], v150, v154 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[136:139], a[132:135], v150, v154 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[140:143], a[136:139], v150, v154 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[144:147], a[140:143], v150, v154 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[116:119], a[144:147], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], v[120:123], a[148:151], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[80:83], v[124:127], a[152:155], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[80:83], v[128:131], a[156:159], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[80:83], v[132:135], a[160:163], v150, v154 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], v[136:139], a[164:167], v150, v154 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], v[140:143], a[168:171], v150, v154 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[144:147], a[172:175], v150, v154 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v2
		v_add3_u32 v2, v2, v5, v0
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[12:15], v2 offset:1024
		ds_read_b128 v[20:23], v2 offset:2048
		ds_read_b128 v[24:27], v2 offset:3072
		ds_read_b128 v[28:31], v2 offset:4096
		ds_read_b128 v[32:35], v2 offset:5120
		ds_read_b128 v[36:39], v2 offset:6144
		ds_read_b128 v[40:43], v2 offset:7168
		ds_read_b128 v[44:47], v2 offset:16384
		ds_read_b128 v[48:51], v2 offset:17408
		ds_read_b128 v[52:55], v2 offset:18432
		ds_read_b128 v[56:59], v2 offset:19456
		ds_read_b128 v[60:63], v2 offset:20480
		ds_read_b128 v[64:67], v2 offset:21504
		ds_read_b128 v[68:71], v2 offset:22528
		ds_read_b128 v[72:75], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v5
		v_add3_u32 v0, v2, v6, v0
		ds_read_b128 v[76:79], v0 offset:32768
		ds_read_b128 v[80:83], v0 offset:33792
		ds_read_b128 v[84:87], v0 offset:34816
		ds_read_b128 v[88:91], v0 offset:35840
		ds_read_b128 v[92:95], v0 offset:36864
		ds_read_b128 v[96:99], v0 offset:37888
		ds_read_b128 v[100:103], v0 offset:38912
		ds_read_b128 v[104:107], v0 offset:39936
		ds_read_b128 v[108:111], v0 offset:49152
		ds_read_b128 v[112:115], v0 offset:50176
		ds_read_b128 v[116:119], v0 offset:51200
		ds_read_b128 v[120:123], v0 offset:52224
		ds_read_b128 v[124:127], v0 offset:53248
		ds_read_b128 v[128:131], v0 offset:54272
		ds_read_b128 v[132:135], v0 offset:55296
		ds_read_b128 v[136:139], v0 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[140:141], v3 offset:8192
		ds_read_b64_tr_b8 v[142:143], v3 offset:8704
		ds_read_b64_tr_b8 v[144:145], v7 offset:10240
		ds_read_b64_tr_b8 v[146:147], v7 offset:10752
		ds_read_b64_tr_b8 v[148:149], v3 offset:12288
		ds_read_b64_tr_b8 v[150:151], v3 offset:12800
		ds_read_b64_tr_b8 v[2:3], v7 offset:14336
		ds_read_b64_tr_b8 v[152:153], v7 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[8:11], v[76:79], v[16:19], v140, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[8:11], v[80:83], v[164:167], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[8:11], v[84:87], v[168:171], v140, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[8:11], v[88:91], v[172:175], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[76:79], v[176:179], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], v[80:83], v[180:183], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[12:15], v[84:87], v[184:187], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[12:15], v[88:91], v[188:191], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[76:79], v[192:195], v140, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], v[80:83], v[196:199], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], v[84:87], v[200:203], v140, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], v[88:91], v[204:207], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[80:83], v[212:215], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[84:87], v[216:219], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[88:91], v[220:223], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[76:79], v[224:227], v142, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[80:83], v[228:231], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[84:87], v[232:235], v142, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[88:91], v[236:239], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[76:79], v[240:243], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[32:35], v[80:83], a[84:87], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[32:35], v[84:87], a[88:91], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[32:35], v[88:91], a[92:95], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], v[76:79], a[112:115], v142, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], v[80:83], a[116:119], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], v[84:87], a[120:123], v142, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], v[88:91], a[124:127], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], v[76:79], a[144:147], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], v[80:83], a[148:151], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], v[84:87], a[152:155], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[40:43], v[88:91], a[156:159], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[44:47], v[108:111], v[16:19], v148, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[44:47], v[112:115], v[164:167], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[44:47], v[116:119], v[168:171], v148, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[120:123], v[172:175], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[108:111], v[176:179], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], v[112:115], v[180:183], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[48:51], v[116:119], v[184:187], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], v[120:123], v[188:191], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[108:111], v[192:195], v148, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[52:55], v[112:115], v[196:199], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], v[116:119], v[200:203], v148, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[120:123], v[204:207], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], v[108:111], v[208:211], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[56:59], v[112:115], v[212:215], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], v[116:119], v[216:219], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], v[120:123], v[220:223], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], v[108:111], v[224:227], v150, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[60:63], v[112:115], v[228:231], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[60:63], v[116:119], v[232:235], v150, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[60:63], v[120:123], v[236:239], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[64:67], v[108:111], v[240:243], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[64:67], v[112:115], a[84:87], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[64:67], v[116:119], a[88:91], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[64:67], v[120:123], a[92:95], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], v[108:111], a[112:115], v150, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[68:71], v[112:115], a[116:119], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], v[116:119], a[120:123], v150, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[68:71], v[120:123], a[124:127], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[72:75], v[108:111], a[144:147], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[72:75], v[112:115], a[148:151], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[72:75], v[116:119], a[152:155], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[72:75], v[120:123], a[156:159], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		v_accvgpr_read_b32 v0, a0
		v_lshlrev_b32_e32 v0, 15, v0
		v_add_u32_e32 v4, v0, v4
		ds_write_b64 v4, v[2:3]
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		ds_write_b64 v4, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v4, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v4, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v4, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v4, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v4, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v4, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v4, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v4, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v4, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v4, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v4, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v4, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v4, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v4, v[2:3] offset:13824
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v4, v[2:3] offset:16384
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		ds_write_b64 v4, v[2:3] offset:16896
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		ds_write_b64 v4, v[2:3] offset:17408
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		ds_write_b64 v4, v[2:3] offset:17920
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		ds_write_b64 v4, v[2:3] offset:20480
		v_accvgpr_read_b32 v2, a84
		v_accvgpr_read_b32 v3, a85
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a86
		v_accvgpr_read_b32 v3, a87
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:20992
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:21504
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:22016
		v_accvgpr_read_b32 v2, a112
		v_accvgpr_read_b32 v3, a113
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a114
		v_accvgpr_read_b32 v3, a115
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:24576
		v_accvgpr_read_b32 v2, a116
		v_accvgpr_read_b32 v3, a117
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a118
		v_accvgpr_read_b32 v3, a119
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:25088
		v_accvgpr_read_b32 v2, a120
		v_accvgpr_read_b32 v3, a121
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a122
		v_accvgpr_read_b32 v3, a123
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:25600
		v_accvgpr_read_b32 v2, a124
		v_accvgpr_read_b32 v3, a125
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a126
		v_accvgpr_read_b32 v3, a127
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:26112
		v_accvgpr_read_b32 v2, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:28672
		v_accvgpr_read_b32 v2, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:29184
		v_accvgpr_read_b32 v2, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:29696
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v4, v[6:7] offset:30208
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s0, 32
		v_cmp_lt_u32_e64 vcc, v1, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v0, v1, 4, v0
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s12, 0x7000
		s_and_saveexec_b64 s[52:53], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[16:19], v0
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen
		ds_read_b128 v[16:19], v0 offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen offset:512
		ds_read_b128 v[16:19], v0 offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s0 offen
		ds_read_b128 v[16:19], v0 offset:4608
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s0 offen offset:512
		ds_read_b128 v[16:19], v0 offset:5120
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s0 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:5632
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s0 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s1 offen
		ds_read_b128 v[16:19], v0 offset:8704
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s1 offen offset:512
		ds_read_b128 v[16:19], v0 offset:9216
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s1 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:9728
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s1 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s4 offen
		ds_read_b128 v[16:19], v0 offset:12800
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s4 offen offset:512
		ds_read_b128 v[16:19], v0 offset:13312
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s4 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:13824
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s4 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s5 offen
		ds_read_b128 v[16:19], v0 offset:16896
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s5 offen offset:512
		ds_read_b128 v[16:19], v0 offset:17408
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s5 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:17920
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s5 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s6 offen
		ds_read_b128 v[16:19], v0 offset:20992
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s6 offen offset:512
		ds_read_b128 v[16:19], v0 offset:21504
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s6 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:22016
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s6 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:24576
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s7 offen
		ds_read_b128 v[16:19], v0 offset:25088
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s7 offen offset:512
		ds_read_b128 v[16:19], v0 offset:25600
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s7 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:26112
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s7 offen offset:1536
		ds_read_b128 v[16:19], v0 offset:28672
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen
		ds_read_b128 v[16:19], v0 offset:29184
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen offset:512
		ds_read_b128 v[16:19], v0 offset:29696
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen offset:1024
		ds_read_b128 v[16:19], v0 offset:30208
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], s12 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[92:95], a[4:7], v140, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[96:99], a[8:11], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[100:103], a[12:15], v140, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[104:107], a[16:19], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[92:95], a[20:23], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[96:99], a[24:27], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[100:103], a[28:31], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[104:107], a[32:35], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[92:95], a[36:39], v140, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[96:99], a[40:43], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[100:103], a[44:47], v140, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[104:107], a[48:51], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[92:95], a[52:55], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[96:99], a[56:59], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[100:103], a[60:63], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[104:107], a[64:67], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[28:31], v[92:95], a[68:71], v142, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[28:31], v[96:99], a[72:75], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[28:31], v[100:103], a[76:79], v142, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], v[104:107], a[80:83], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[32:35], v[92:95], a[96:99], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[32:35], v[96:99], a[100:103], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[32:35], v[100:103], a[104:107], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[32:35], v[104:107], a[108:111], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], v[92:95], a[128:131], v142, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[36:39], v[96:99], a[132:135], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[36:39], v[100:103], a[136:139], v142, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[36:39], v[104:107], a[140:143], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], v[92:95], a[160:163], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[40:43], v[96:99], a[164:167], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[40:43], v[100:103], a[168:171], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[40:43], v[104:107], a[172:175], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[44:47], v[124:127], a[4:7], v148, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[44:47], v[128:131], a[8:11], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[44:47], v[132:135], a[12:15], v148, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[44:47], v[136:139], a[16:19], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[48:51], v[124:127], a[20:23], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[48:51], v[128:131], a[24:27], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[48:51], v[132:135], a[28:31], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[48:51], v[136:139], a[32:35], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[52:55], v[124:127], a[36:39], v148, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[52:55], v[128:131], a[40:43], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[52:55], v[132:135], a[44:47], v148, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[52:55], v[136:139], a[48:51], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[56:59], v[124:127], a[52:55], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[56:59], v[128:131], a[56:59], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[56:59], v[132:135], a[60:63], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[56:59], v[136:139], a[64:67], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[60:63], v[124:127], a[68:71], v150, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[60:63], v[128:131], a[72:75], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[60:63], v[132:135], a[76:79], v150, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[60:63], v[136:139], a[80:83], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[64:67], v[124:127], a[96:99], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[64:67], v[128:131], a[100:103], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[64:67], v[132:135], a[104:107], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[64:67], v[136:139], a[108:111], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], v[124:127], a[128:131], v150, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[68:71], v[128:131], a[132:135], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[68:71], v[132:135], a[136:139], v150, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[68:71], v[136:139], a[140:143], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[72:75], v[124:127], a[160:163], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[72:75], v[128:131], a[164:167], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[72:75], v[132:135], a[168:171], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[72:75], v[136:139], a[172:175], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v2, a5
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v2, a7
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:2048
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v2, a9
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v2, a11
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:2560
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v2, a13
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v2, a15
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:3072
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:3584
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:6144
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:6656
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:7168
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:7680
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:10240
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:10752
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:11264
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:11776
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:14336
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:14848
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:15360
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:15872
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:18432
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:18944
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:19456
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:19968
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:22528
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:23040
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:23552
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:24064
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:26624
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:27136
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:27648
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:28160
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:30720
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:31232
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:31744
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v4, v[6:7] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[52:53], s[2:3]
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
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		buffer_store_dwordx4 v[4:7], v0, s[8:11], 0 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[8:11], v0, s[8:11], 0 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[12:15], v0, s[8:11], 0 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[16:19], v0, s[8:11], 0 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[20:23], v0, s[8:11], s0 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[24:27], v0, s[8:11], s0 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[28:31], v0, s[8:11], s0 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[32:35], v0, s[8:11], s0 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[36:39], v0, s[8:11], s1 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[40:43], v0, s[8:11], s1 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[44:47], v0, s[8:11], s1 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[48:51], v0, s[8:11], s1 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[52:55], v0, s[8:11], s4 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[56:59], v0, s[8:11], s4 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[60:63], v0, s[8:11], s4 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[64:67], v0, s[8:11], s4 offen offset:3584
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		buffer_store_dwordx4 v[68:71], v0, s[8:11], s5 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[72:75], v0, s[8:11], s5 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[76:79], v0, s[8:11], s5 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[80:83], v0, s[8:11], s5 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[84:87], v0, s[8:11], s6 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[88:91], v0, s[8:11], s6 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[92:95], v0, s[8:11], s6 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[96:99], v0, s[8:11], s6 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[100:103], v0, s[8:11], s7 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[104:107], v0, s[8:11], s7 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[108:111], v0, s[8:11], s7 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[112:115], v0, s[8:11], s7 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[116:119], v0, s[8:11], s12 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[120:123], v0, s[8:11], s12 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[124:127], v0, s[8:11], s12 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[128:131], v0, s[8:11], s12 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[52:53]
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
		.amdhsa_next_free_vgpr 432
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 256
	.set .Lwmma_f16_matmul_tiled.num_agpr, 176
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
    .vgpr_count:     432
    .agpr_count:     176
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
