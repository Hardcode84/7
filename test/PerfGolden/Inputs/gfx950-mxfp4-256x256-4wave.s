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
		s_lshl_b32 s15, s14, 1
		v_and_b32_e32 v1, 63, v0
		s_add_i32 s14, s15, s12
		s_and_b32 s12, s13, 7
		s_lshl_b32 s13, s12, 5
		v_lshrrev_b32_e32 v2, 3, v1
		s_add_i32 s12, s14, s13
		v_lshrrev_b32_e32 v3, 2, v1
		s_lshr_b32 s13, s12, 6
		s_lshl_b32 s14, s13, 23
		s_and_b32 s15, s12, 63
		v_lshrrev_b32_e32 v4, 6, v0
		v_accvgpr_write_b32 a0, v4
		v_and_b32_e32 v4, 3, v2
		v_and_b32_e32 v2, 3, v1
		s_lshr_b32 s12, s15, 2
		v_lshlrev_b32_e32 v5, 12, v3
		s_lshl_b32 s16, s12, 17
		s_add_i32 s17, s14, s16
		v_readfirstlane_b32 s14, v0
		s_and_b32 s16, s15, 3
		v_xor_b32_e32 v3, v4, v2
		s_lshl_b32 s15, s16, 21
		v_accvgpr_read_b32 v2, a0
		v_lshl_add_u32 v4, v2, 16, v5
		s_add_i32 s18, s17, s15
		s_add_u32 s20, s6, s18
		s_addc_u32 s21, s7, 0
		s_lshr_b32 s6, s14, 6
		s_lshl_b32 s7, s6, 10
		v_lshl_add_u32 v2, v3, 4, v4
		s_lshl_b32 s6, s13, 22
		s_lshl_b32 s14, s16, 20
		s_add_i32 s15, s6, s14
		v_add_u32_e32 v3, s15, v2
		s_mov_b32 m0, s7
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s27, 0x31016000
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_add_i32 s2, s7, 0x1000
		s_add_i32 s3, s6, 0x40000
		s_add_i32 s15, s3, s14
		v_add_u32_e32 v4, s15, v2
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s3, s7, 0x2000
		s_add_i32 s15, s6, 0x80000
		s_add_i32 s17, s15, s14
		v_add_u32_e32 v4, s17, v2
		s_mov_b32 m0, s3
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s15, s7, 0x3000
		s_add_i32 s17, s6, 0xc0000
		s_add_i32 s18, s17, s14
		v_add_u32_e32 v4, s18, v2
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s17, s7, 0x4000
		s_add_i32 s18, s6, 64
		s_add_i32 s19, s18, s14
		v_add_u32_e32 v4, s19, v2
		s_mov_b32 m0, s17
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s18, s7, 0x5000
		s_add_i32 s19, s6, 0x40040
		s_add_i32 s22, s19, s14
		v_add_u32_e32 v4, s22, v2
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s19, s7, 0x6000
		s_add_i32 s22, s6, 0x80040
		s_add_i32 s23, s22, s14
		v_add_u32_e32 v4, s23, v2
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s22, s7, 0x7000
		s_add_i32 s23, s6, 0xc0040
		s_add_i32 s28, s23, s14
		v_add_u32_e32 v4, s28, v2
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_add_i32 s23, s7, 0x8000
		s_lshl_b32 s28, s12, 20
		v_add_u32_e32 v4, s28, v2
		s_mov_b32 m0, s23
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, 0x1000000
		s_mov_b32 s35, 0x31016000
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_add_i32 s4, s7, 0x9000
		s_add_i32 s5, s28, 0x40000
		v_add_u32_e32 v5, s5, v2
		s_mov_b32 m0, s4
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s5, s7, 0xa000
		s_add_i32 s29, s28, 0x80000
		v_add_u32_e32 v5, s29, v2
		s_mov_b32 m0, s5
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s29, s7, 0xb000
		s_add_i32 s30, s28, 0xc0000
		v_add_u32_e32 v5, s30, v2
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_add3_u32 v5, s28, 64, v2
		s_add_i32 s30, s7, 0xc000
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s31, s7, 0xd000
		s_add_i32 s36, s28, 0x40040
		v_add_u32_e32 v5, s36, v2
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s36, s7, 0xe000
		s_add_i32 s37, s28, 0x80040
		v_add_u32_e32 v5, s37, v2
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s37, s7, 0xf000
		s_add_i32 s38, s28, 0xc0040
		v_add_u32_e32 v5, s38, v2
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshrrev_b32_e32 v6, 4, v1
		v_lshlrev_b32_e32 v7, 10, v5
		v_and_b32_e32 v8, 15, v0
		v_accvgpr_read_b32 v0, a0
		v_and_b32_e32 v9, 1, v0
		v_lshlrev_b32_e32 v0, 7, v5
		v_lshlrev_b32_e32 v10, 12, v6
		v_lshlrev_b32_e32 v11, 2, v8
		v_lshlrev_b32_e32 v12, 7, v6
		v_add_u32_e32 v13, 0x20000, v7
		v_accvgpr_write_b32 a1, v13
		s_mov_b32 s38, 0
		s_lshl_b32 s39, s13, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_cmp_eq_u32_e64 vcc, v9, s38
		s_mov_b64 s[40:41], vcc
		v_add3_u32 v13, v0, v10, v11
		v_accvgpr_read_b32 v0, a1
		v_add3_u32 v10, v0, v12, v11
		s_lshl_b32 s13, s16, 8
		s_add_i32 s16, s39, s13
		s_add_i32 s42, s39, 0x4000
		s_add_i32 s43, s42, s13
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
		s_mov_b32 s8, s20
		s_mov_b32 s9, s21
		s_mov_b32 s10, 0x20000
		s_mov_b32 s11, 0x31016000
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v0, v13, s[48:51], s16 offen
		buffer_load_dword v14, v13, s[48:51], s16 offen offset:64
		buffer_load_dword v15, v13, s[48:51], s43 offen
		buffer_load_dword v20, v13, s[48:51], s43 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v10, v0
		ds_write_b32 v10, v14 offset:512
		ds_write_b32 v10, v15 offset:4096
		ds_write_b32 v10, v20 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[52:53]
		v_add_u32_e32 v0, 0x20000, v12
		v_lshl_add_u32 v14, v6, 12, v11
		v_add_u32_e32 v15, v0, v11
		v_cmp_eq_u32_e64 vcc, v5, s38
		s_mov_b64 s[0:1], vcc
		v_lshl_add_u32 v0, v9, 7, v14
		v_lshl_add_u32 v14, v9, 10, v15
		s_lshl_b32 s16, s12, 8
		s_add_i32 s12, s16, 0x4000
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v15, v0, s[44:47], s16 offen
		buffer_load_dword v20, v0, s[44:47], s16 offen offset:64
		buffer_load_dword v21, v0, s[44:47], s12 offen
		buffer_load_dword v22, v0, s[44:47], s12 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v14, v15 offset:2048
		ds_write_b32 v14, v20 offset:2560
		ds_write_b32 v14, v21 offset:6144
		ds_write_b32 v14, v22 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s12, s39, 0x8000
		s_add_i32 s20, s12, s13
		s_add_i32 s12, s39, 0xc000
		s_add_i32 s21, s12, s13
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v15, v13, s[48:51], s20 offen
		buffer_load_dword v20, v13, s[48:51], s20 offen offset:64
		buffer_load_dword v21, v13, s[48:51], s21 offen
		buffer_load_dword v22, v13, s[48:51], s21 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v10, v15 offset:8192
		ds_write_b32 v10, v20 offset:8704
		ds_write_b32 v10, v21 offset:12288
		ds_write_b32 v10, v22 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s12, s16, 0x8000
		s_add_i32 s20, s16, 0xc000
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v10, v0, s[44:47], s12 offen
		buffer_load_dword v15, v0, s[44:47], s12 offen offset:64
		buffer_load_dword v20, v0, s[44:47], s20 offen
		buffer_load_dword v21, v0, s[44:47], s20 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v14, v10 offset:10240
		ds_write_b32 v14, v15 offset:10752
		ds_write_b32 v14, v20 offset:14336
		ds_write_b32 v14, v21 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[52:53]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s12, s6, 0x80
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x11000
		s_add_i32 s12, s6, 0x40080
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		s_add_i32 s12, s6, 0x80080
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x13000
		s_add_i32 s12, s6, 0xc0080
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		s_add_i32 s12, s6, 0xc0
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x15000
		s_add_i32 s12, s6, 0x400c0
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		s_add_i32 s12, s6, 0x800c0
		s_add_i32 s20, s12, s14
		v_add_u32_e32 v10, s20, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x17000
		s_add_i32 s12, s6, 0xc00c0
		s_add_i32 s6, s12, s14
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s6, s28, 0x80
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x19000
		s_add_i32 s6, s28, 0x40080
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		s_add_i32 s6, s28, 0x80080
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1b000
		s_add_i32 s6, s28, 0xc0080
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		s_add_i32 s6, s28, 0xc0
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1d000
		s_add_i32 s6, s28, 0x400c0
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		s_add_i32 s6, s28, 0x800c0
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x1f000
		s_add_i32 s6, s28, 0xc00c0
		v_add_u32_e32 v10, s6, v2
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		v_lshlrev_b32_e32 v2, 13, v5
		v_lshlrev_b32_e32 v5, 6, v8
		v_lshrrev_b32_e32 v10, 1, v8
		v_and_b32_e32 v8, 3, v10
		v_xor_b32_e32 v10, v6, v8
		v_lshlrev_b32_e32 v6, 4, v10
		v_add3_u32 v8, v2, v5, v6
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
		v_lshlrev_b32_e32 v8, 13, v9
		v_add3_u32 v10, v5, v8, v6
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
		v_add_u32_e32 v14, 0x40100, v3
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
		v_lshlrev_b32_e32 v160, 10, v9
		s_cselect_b32 s6, 1, 0
		s_add_i32 s12, s39, 0x10000
		s_add_i32 s14, s12, s13
		v_mov_b32_e32 v161, s14
		s_add_i32 s12, s39, 0x14000
		s_add_i32 s14, s12, s13
		v_mov_b32_e32 v162, s14
		s_add_i32 s12, s16, 0x10000
		v_mov_b32_e32 v163, s12
		s_add_i32 s12, s16, 0x14000
		v_mov_b32_e32 v164, s12
		s_cmp_lg_u32 s6, 0
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a4, v180
		v_accvgpr_write_b32 a5, v181
		v_accvgpr_write_b32 a6, v182
		v_accvgpr_write_b32 a7, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a8, v180
		v_accvgpr_write_b32 a9, v181
		v_accvgpr_write_b32 a10, v182
		v_accvgpr_write_b32 a11, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a12, v180
		v_accvgpr_write_b32 a13, v181
		v_accvgpr_write_b32 a14, v182
		v_accvgpr_write_b32 a15, v183
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a16, v180
		v_accvgpr_write_b32 a17, v181
		v_accvgpr_write_b32 a18, v182
		v_accvgpr_write_b32 a19, v183
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
		v_accvgpr_write_b32 a20, v196
		v_accvgpr_write_b32 a21, v197
		v_accvgpr_write_b32 a22, v198
		v_accvgpr_write_b32 a23, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a24, v196
		v_accvgpr_write_b32 a25, v197
		v_accvgpr_write_b32 a26, v198
		v_accvgpr_write_b32 a27, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a28, v196
		v_accvgpr_write_b32 a29, v197
		v_accvgpr_write_b32 a30, v198
		v_accvgpr_write_b32 a31, v199
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a32, v196
		v_accvgpr_write_b32 a33, v197
		v_accvgpr_write_b32 a34, v198
		v_accvgpr_write_b32 a35, v199
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
		v_accvgpr_write_b32 a36, v212
		v_accvgpr_write_b32 a37, v213
		v_accvgpr_write_b32 a38, v214
		v_accvgpr_write_b32 a39, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a40, v212
		v_accvgpr_write_b32 a41, v213
		v_accvgpr_write_b32 a42, v214
		v_accvgpr_write_b32 a43, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a44, v212
		v_accvgpr_write_b32 a45, v213
		v_accvgpr_write_b32 a46, v214
		v_accvgpr_write_b32 a47, v215
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a48, v212
		v_accvgpr_write_b32 a49, v213
		v_accvgpr_write_b32 a50, v214
		v_accvgpr_write_b32 a51, v215
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
		v_accvgpr_write_b32 a52, v228
		v_accvgpr_write_b32 a53, v229
		v_accvgpr_write_b32 a54, v230
		v_accvgpr_write_b32 a55, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a56, v228
		v_accvgpr_write_b32 a57, v229
		v_accvgpr_write_b32 a58, v230
		v_accvgpr_write_b32 a59, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a60, v228
		v_accvgpr_write_b32 a61, v229
		v_accvgpr_write_b32 a62, v230
		v_accvgpr_write_b32 a63, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a64, v228
		v_accvgpr_write_b32 a65, v229
		v_accvgpr_write_b32 a66, v230
		v_accvgpr_write_b32 a67, v231
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
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a180, v228
		v_accvgpr_write_b32 a181, v229
		v_accvgpr_write_b32 a182, v230
		v_accvgpr_write_b32 a183, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a184, v228
		v_accvgpr_write_b32 a185, v229
		v_accvgpr_write_b32 a186, v230
		v_accvgpr_write_b32 a187, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a188, v228
		v_accvgpr_write_b32 a189, v229
		v_accvgpr_write_b32 a190, v230
		v_accvgpr_write_b32 a191, v231
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a192, v228
		v_accvgpr_write_b32 a193, v229
		v_accvgpr_write_b32 a194, v230
		v_accvgpr_write_b32 a195, v231
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s6, s38, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s12, s38, 1
		s_lshl_b32 s13, s12, 13
		s_add_i32 s12, s13, 0x20000
		v_add_u32_e32 v165, s12, v7
		v_add_u32_e32 v166, v165, v4
		ds_read_b64_tr_b8 v[228:229], v166
		ds_read_b64_tr_b8 v[230:231], v166 offset:512
		v_add3_u32 v167, s12, v4, v160
		ds_read_b64_tr_b8 v[232:233], v167 offset:2048
		ds_read_b64_tr_b8 v[234:235], v166 offset:4096
		ds_read_b64_tr_b8 v[236:237], v166 offset:4608
		ds_read_b64_tr_b8 v[238:239], v167 offset:6144
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[84:87], v[16:19], v228, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[88:91], v[168:171], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[92:95], v[172:175], v228, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[96:99], v[176:179], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[84:87], v[180:183], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[88:91], v[184:187], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[92:95], v[188:191], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[96:99], v[192:195], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[84:87], v[196:199], v228, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[88:91], v[200:203], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[92:95], v[204:207], v228, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[96:99], v[208:211], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[84:87], v[212:215], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[88:91], v[216:219], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[92:95], v[220:223], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[96:99], v[224:227], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], v[84:87], a[68:71], v230, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], v[88:91], a[72:75], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[92:95], a[76:79], v230, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], v[96:99], a[80:83], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[84:87], a[100:103], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[88:91], a[104:107], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[92:95], a[108:111], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], v[96:99], a[112:115], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], v[84:87], a[132:135], v230, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[88:91], a[136:139], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[92:95], a[140:143], v230, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], v[96:99], a[144:147], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[84:87], a[164:167], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[88:91], a[168:171], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], v[92:95], a[172:175], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], v[96:99], a[176:179], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[116:119], v[16:19], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[120:123], v[168:171], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], v[124:127], v[172:175], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[52:55], v[128:131], v[176:179], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], v[116:119], v[180:183], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], v[120:123], v[184:187], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], v[124:127], v[188:191], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], v[128:131], v[192:195], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[60:63], v[116:119], v[196:199], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], v[120:123], v[200:203], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], v[124:127], v[204:207], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], v[128:131], v[208:211], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[116:119], v[212:215], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[64:67], v[120:123], v[216:219], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[124:127], v[220:223], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], v[128:131], v[224:227], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[68:71], v[116:119], a[68:71], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[68:71], v[120:123], a[72:75], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[68:71], v[124:127], a[76:79], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[68:71], v[128:131], a[80:83], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[72:75], v[116:119], a[100:103], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], v[120:123], a[104:107], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[72:75], v[124:127], a[108:111], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[72:75], v[128:131], a[112:115], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[116:119], a[132:135], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[120:123], a[136:139], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[124:127], a[140:143], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], v[128:131], a[144:147], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], v[116:119], a[164:167], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], v[120:123], a[168:171], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[124:127], a[172:175], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[80:83], v[128:131], a[176:179], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[232:233], v167 offset:2560
		ds_read_b64_tr_b8 v[238:239], v167 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s12, s38, 15
		v_readfirstlane_b32 s14, v161
		s_add_i32 s16, s14, s12
		v_readfirstlane_b32 s14, v162
		s_add_i32 s20, s14, s12
		s_add_i32 s14, s13, 0x20200
		v_add_u32_e32 v166, s14, v7
		s_add_i32 s14, s13, 0x21000
		v_add_u32_e32 v167, s14, v7
		s_add_i32 s14, s13, 0x21200
		v_add_u32_e32 v229, s14, v7
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v231, v13, s[48:51], s16 offen
		buffer_load_dword v237, v13, s[48:51], s16 offen offset:64
		buffer_load_dword v241, v13, s[48:51], s20 offen
		buffer_load_dword v243, v13, s[48:51], s20 offen offset:64
		v_add3_u32 v235, v165, v12, v11
		v_add3_u32 v240, v166, v12, v11
		v_add3_u32 v242, v167, v12, v11
		v_add3_u32 v244, v229, v12, v11
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[52:53]
		v_readfirstlane_b32 s14, v163
		s_add_i32 s16, s14, s12
		v_readfirstlane_b32 s14, v164
		s_add_i32 s20, s14, s12
		s_add_i32 s12, s13, 0x20800
		v_add_u32_e32 v165, s12, v12
		s_add_i32 s12, s13, 0x20a00
		v_add_u32_e32 v166, s12, v12
		s_add_i32 s12, s13, 0x21800
		v_add_u32_e32 v167, s12, v12
		s_add_i32 s12, s13, 0x21a00
		v_add_u32_e32 v229, s12, v12
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v245, v0, s[44:47], s16 offen
		buffer_load_dword v247, v0, s[44:47], s16 offen offset:64
		buffer_load_dword v249, v0, s[44:47], s20 offen
		buffer_load_dword v251, v0, s[44:47], s20 offen offset:64
		v_add3_u32 v246, v165, v11, v160
		v_add3_u32 v248, v166, v11, v160
		v_add3_u32 v250, v167, v11, v160
		v_add3_u32 v252, v229, v11, v160
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s7
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], s6 offen lds
		s_mov_b32 m0, s2
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[100:103], a[4:7], v228, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[104:107], a[8:11], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[108:111], a[12:15], v228, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[112:115], a[16:19], v228, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s3
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[24:27], v[100:103], a[20:23], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[24:27], v[104:107], a[24:27], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[24:27], v[108:111], a[28:31], v228, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[112:115], a[32:35], v228, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], v[100:103], a[36:39], v228, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], v[104:107], a[40:43], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v148, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], v[108:111], a[44:47], v228, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], v[112:115], a[48:51], v228, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], v[100:103], a[52:55], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], v[104:107], a[56:59], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], v[108:111], a[60:63], v228, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], v[112:115], a[64:67], v228, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s17
		s_nop 0
		buffer_load_dwordx4 v149, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[36:39], v[100:103], a[84:87], v230, v232 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[36:39], v[104:107], a[88:91], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[36:39], v[108:111], a[92:95], v230, v232 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], v[112:115], a[96:99], v230, v232 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], v[100:103], a[116:119], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], v[104:107], a[120:123], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s18
		s_nop 0
		buffer_load_dwordx4 v150, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], v[108:111], a[124:127], v230, v232 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], v[112:115], a[128:131], v230, v232 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], v[100:103], a[148:151], v230, v232 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], v[104:107], a[152:155], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[44:47], v[108:111], a[156:159], v230, v232 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[44:47], v[112:115], a[160:163], v230, v232 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v151, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], v[100:103], a[180:183], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[48:51], v[104:107], a[184:187], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[48:51], v[108:111], a[188:191], v230, v232 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[48:51], v[112:115], a[192:195], v230, v232 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[52:55], v[132:135], a[4:7], v234, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[52:55], v[136:139], a[8:11], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v152, s[24:27], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[52:55], v[140:143], a[12:15], v234, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[52:55], v[144:147], a[16:19], v234, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[56:59], v[132:135], a[20:23], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[56:59], v[136:139], a[24:27], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[56:59], v[140:143], a[28:31], v234, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[56:59], v[144:147], a[32:35], v234, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v3, s[32:35], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[60:63], v[132:135], a[36:39], v234, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[60:63], v[136:139], a[40:43], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[60:63], v[140:143], a[44:47], v234, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[60:63], v[144:147], a[48:51], v234, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[64:67], v[132:135], a[52:55], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[64:67], v[136:139], a[56:59], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s5
		s_nop 0
		buffer_load_dwordx4 v154, s[32:35], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[64:67], v[140:143], a[60:63], v234, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[64:67], v[144:147], a[64:67], v234, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[68:71], v[132:135], a[84:87], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[68:71], v[136:139], a[88:91], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[68:71], v[140:143], a[92:95], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[68:71], v[144:147], a[96:99], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v156, s[32:35], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[72:75], v[132:135], a[116:119], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[72:75], v[136:139], a[120:123], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[72:75], v[140:143], a[124:127], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[72:75], v[144:147], a[128:131], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[76:79], v[132:135], a[148:151], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], v[136:139], a[152:155], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v158, s[32:35], s6 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[76:79], v[140:143], a[156:159], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], v[144:147], a[160:163], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[80:83], v[132:135], a[180:183], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[80:83], v[136:139], a[184:187], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[80:83], v[140:143], a[188:191], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[80:83], v[144:147], a[192:195], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v235, v231
		ds_write_b32 v240, v237
		ds_write_b32 v242, v241
		ds_write_b32 v244, v243
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[52:53], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[52:53]
		s_and_saveexec_b64 s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v246, v245
		ds_write_b32 v248, v247
		ds_write_b32 v250, v249
		ds_write_b32 v252, v251
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[52:53], s[0:1]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 m0, s4
		s_nop 0
		buffer_load_dwordx4 v153, s[32:35], s6 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v155, s[32:35], s6 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v157, s[32:35], s6 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v159, s[32:35], s6 offen lds
		s_waitcnt vmcnt(24)
		s_barrier
		s_add_i32 s38, s38, 1
		s_and_b32 s6, s38, 1
		s_lshl_b32 s12, s6, 16
		v_add_u32_e32 v165, s12, v2
		v_add3_u32 v166, v165, v5, v6
		ds_read_b128 v[20:23], v166
		ds_read_b128 v[24:27], v166 offset:1024
		ds_read_b128 v[28:31], v166 offset:2048
		ds_read_b128 v[32:35], v166 offset:3072
		ds_read_b128 v[36:39], v166 offset:4096
		ds_read_b128 v[40:43], v166 offset:5120
		ds_read_b128 v[44:47], v166 offset:6144
		ds_read_b128 v[48:51], v166 offset:7168
		ds_read_b128 v[52:55], v166 offset:16384
		ds_read_b128 v[56:59], v166 offset:17408
		ds_read_b128 v[60:63], v166 offset:18432
		ds_read_b128 v[64:67], v166 offset:19456
		ds_read_b128 v[68:71], v166 offset:20480
		ds_read_b128 v[72:75], v166 offset:21504
		ds_read_b128 v[76:79], v166 offset:22528
		ds_read_b128 v[80:83], v166 offset:23552
		v_add_u32_e32 v165, s12, v5
		v_add3_u32 v166, v165, v8, v6
		ds_read_b128 v[84:87], v166 offset:32768
		ds_read_b128 v[88:91], v166 offset:33792
		ds_read_b128 v[92:95], v166 offset:34816
		ds_read_b128 v[96:99], v166 offset:35840
		ds_read_b128 v[100:103], v166 offset:36864
		ds_read_b128 v[104:107], v166 offset:37888
		ds_read_b128 v[108:111], v166 offset:38912
		ds_read_b128 v[112:115], v166 offset:39936
		ds_read_b128 v[116:119], v166 offset:49152
		ds_read_b128 v[120:123], v166 offset:50176
		ds_read_b128 v[124:127], v166 offset:51200
		ds_read_b128 v[128:131], v166 offset:52224
		ds_read_b128 v[132:135], v166 offset:53248
		ds_read_b128 v[136:139], v166 offset:54272
		ds_read_b128 v[140:143], v166 offset:55296
		ds_read_b128 v[144:147], v166 offset:56320
		s_add_i32 s6, s7, 0x10000
		s_and_b32 s7, s6, 0x1ffff
		s_add_i32 s6, s2, 0x10000
		s_and_b32 s2, s6, 0x1ffff
		s_add_i32 s6, s3, 0x10000
		s_and_b32 s3, s6, 0x1ffff
		s_add_i32 s6, s15, 0x10000
		s_and_b32 s15, s6, 0x1ffff
		s_add_i32 s6, s17, 0x10000
		s_and_b32 s17, s6, 0x1ffff
		s_add_i32 s6, s18, 0x10000
		s_and_b32 s18, s6, 0x1ffff
		s_add_i32 s6, s19, 0x10000
		s_and_b32 s19, s6, 0x1ffff
		s_add_i32 s6, s22, 0x10000
		s_and_b32 s22, s6, 0x1ffff
		s_add_i32 s6, s23, 0x10000
		s_and_b32 s23, s6, 0x1ffff
		s_add_i32 s6, s5, 0x10000
		s_and_b32 s5, s6, 0x1ffff
		s_add_i32 s6, s30, 0x10000
		s_and_b32 s30, s6, 0x1ffff
		s_add_i32 s6, s36, 0x10000
		s_and_b32 s36, s6, 0x1ffff
		s_add_i32 s6, s4, 0x10000
		s_and_b32 s4, s6, 0x1ffff
		s_add_i32 s6, s29, 0x10000
		s_and_b32 s29, s6, 0x1ffff
		s_add_i32 s6, s31, 0x10000
		s_and_b32 s31, s6, 0x1ffff
		s_add_i32 s6, s37, 0x10000
		s_and_b32 s37, s6, 0x1ffff
		s_cmp_lt_i32 s38, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v0, a1
		v_add_u32_e32 v3, v0, v4
		ds_read_b64_tr_b8 v[10:11], v3
		ds_read_b64_tr_b8 v[12:13], v3 offset:512
		v_add_u32_e32 v0, 0x20000, v4
		v_lshl_add_u32 v7, v9, 10, v0
		ds_read_b64_tr_b8 v[14:15], v7 offset:2048
		ds_read_b64_tr_b8 v[148:149], v7 offset:2560
		ds_read_b64_tr_b8 v[150:151], v3 offset:4096
		ds_read_b64_tr_b8 v[152:153], v3 offset:4608
		ds_read_b64_tr_b8 v[154:155], v7 offset:6144
		ds_read_b64_tr_b8 v[156:157], v7 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[84:87], v[16:19], v10, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[88:91], v[168:171], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[92:95], v[172:175], v10, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[96:99], v[176:179], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[100:103], a[4:7], v10, v148 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[104:107], a[8:11], v10, v148 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[108:111], a[12:15], v10, v148 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[112:115], a[16:19], v10, v148 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[84:87], v[180:183], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[88:91], v[184:187], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[92:95], v[188:191], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[96:99], v[192:195], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[24:27], v[100:103], a[20:23], v10, v148 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[24:27], v[104:107], a[24:27], v10, v148 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[24:27], v[108:111], a[28:31], v10, v148 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[112:115], a[32:35], v10, v148 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[84:87], v[196:199], v10, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[88:91], v[200:203], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[92:95], v[204:207], v10, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[96:99], v[208:211], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], v[100:103], a[36:39], v10, v148 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], v[104:107], a[40:43], v10, v148 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], v[108:111], a[44:47], v10, v148 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], v[112:115], a[48:51], v10, v148 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[84:87], v[212:215], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[88:91], v[216:219], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[92:95], v[220:223], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[96:99], v[224:227], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], v[100:103], a[52:55], v10, v148 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], v[104:107], a[56:59], v10, v148 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], v[108:111], a[60:63], v10, v148 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], v[112:115], a[64:67], v10, v148 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], v[84:87], a[68:71], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], v[88:91], a[72:75], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[92:95], a[76:79], v12, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], v[96:99], a[80:83], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[36:39], v[100:103], a[84:87], v12, v148 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[36:39], v[104:107], a[88:91], v12, v148 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[36:39], v[108:111], a[92:95], v12, v148 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], v[112:115], a[96:99], v12, v148 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], v[84:87], a[100:103], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], v[88:91], a[104:107], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[92:95], a[108:111], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], v[96:99], a[112:115], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], v[100:103], a[116:119], v12, v148 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], v[104:107], a[120:123], v12, v148 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], v[108:111], a[124:127], v12, v148 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], v[112:115], a[128:131], v12, v148 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], v[84:87], a[132:135], v12, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], v[88:91], a[136:139], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[92:95], a[140:143], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], v[96:99], a[144:147], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[44:47], v[100:103], a[148:151], v12, v148 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], v[104:107], a[152:155], v12, v148 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[44:47], v[108:111], a[156:159], v12, v148 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[44:47], v[112:115], a[160:163], v12, v148 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[48:51], v[84:87], a[164:167], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[48:51], v[88:91], a[168:171], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[48:51], v[92:95], a[172:175], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[48:51], v[96:99], a[176:179], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[48:51], v[100:103], a[180:183], v12, v148 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[48:51], v[104:107], a[184:187], v12, v148 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[48:51], v[108:111], a[188:191], v12, v148 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[48:51], v[112:115], a[192:195], v12, v148 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[52:55], v[116:119], v[16:19], v150, v154 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[52:55], v[120:123], v[168:171], v150, v154 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[52:55], v[124:127], v[172:175], v150, v154 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[52:55], v[128:131], v[176:179], v150, v154 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[52:55], v[132:135], a[4:7], v150, v156 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[52:55], v[136:139], a[8:11], v150, v156 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[52:55], v[140:143], a[12:15], v150, v156 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[52:55], v[144:147], a[16:19], v150, v156 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[56:59], v[116:119], v[180:183], v150, v154 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[56:59], v[120:123], v[184:187], v150, v154 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[56:59], v[124:127], v[188:191], v150, v154 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[56:59], v[128:131], v[192:195], v150, v154 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[56:59], v[132:135], a[20:23], v150, v156 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[56:59], v[136:139], a[24:27], v150, v156 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[56:59], v[140:143], a[28:31], v150, v156 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[56:59], v[144:147], a[32:35], v150, v156 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[60:63], v[116:119], v[196:199], v150, v154 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[60:63], v[120:123], v[200:203], v150, v154 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[60:63], v[124:127], v[204:207], v150, v154 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[60:63], v[128:131], v[208:211], v150, v154 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[60:63], v[132:135], a[36:39], v150, v156 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[60:63], v[136:139], a[40:43], v150, v156 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[60:63], v[140:143], a[44:47], v150, v156 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[60:63], v[144:147], a[48:51], v150, v156 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[64:67], v[116:119], v[212:215], v150, v154 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[64:67], v[120:123], v[216:219], v150, v154 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[64:67], v[124:127], v[220:223], v150, v154 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[64:67], v[128:131], v[224:227], v150, v154 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[64:67], v[132:135], a[52:55], v150, v156 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[64:67], v[136:139], a[56:59], v150, v156 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[64:67], v[140:143], a[60:63], v150, v156 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[64:67], v[144:147], a[64:67], v150, v156 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[68:71], v[116:119], a[68:71], v152, v154 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[68:71], v[120:123], a[72:75], v152, v154 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[68:71], v[124:127], a[76:79], v152, v154 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[68:71], v[128:131], a[80:83], v152, v154 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[68:71], v[132:135], a[84:87], v152, v156 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[68:71], v[136:139], a[88:91], v152, v156 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[68:71], v[140:143], a[92:95], v152, v156 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[68:71], v[144:147], a[96:99], v152, v156 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[72:75], v[116:119], a[100:103], v152, v154 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[72:75], v[120:123], a[104:107], v152, v154 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[72:75], v[124:127], a[108:111], v152, v154 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[72:75], v[128:131], a[112:115], v152, v154 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[72:75], v[132:135], a[116:119], v152, v156 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[72:75], v[136:139], a[120:123], v152, v156 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[72:75], v[140:143], a[124:127], v152, v156 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[72:75], v[144:147], a[128:131], v152, v156 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[76:79], v[116:119], a[132:135], v152, v154 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[76:79], v[120:123], a[136:139], v152, v154 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[76:79], v[124:127], a[140:143], v152, v154 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[76:79], v[128:131], a[144:147], v152, v154 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[76:79], v[132:135], a[148:151], v152, v156 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], v[136:139], a[152:155], v152, v156 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[76:79], v[140:143], a[156:159], v152, v156 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], v[144:147], a[160:163], v152, v156 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[80:83], v[116:119], a[164:167], v152, v154 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[80:83], v[120:123], a[168:171], v152, v154 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[80:83], v[124:127], a[172:175], v152, v154 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[80:83], v[128:131], a[176:179], v152, v154 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[80:83], v[132:135], a[180:183], v152, v156 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[80:83], v[136:139], a[184:187], v152, v156 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[80:83], v[140:143], a[188:191], v152, v156 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[80:83], v[144:147], a[192:195], v152, v156 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v0, 0x10000, v2
		v_add3_u32 v2, v0, v5, v6
		ds_read_b128 v[12:15], v2
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 v[32:35], v2 offset:4096
		ds_read_b128 v[36:39], v2 offset:5120
		ds_read_b128 v[40:43], v2 offset:6144
		ds_read_b128 v[44:47], v2 offset:7168
		ds_read_b128 v[48:51], v2 offset:16384
		ds_read_b128 v[52:55], v2 offset:17408
		ds_read_b128 v[56:59], v2 offset:18432
		ds_read_b128 v[60:63], v2 offset:19456
		ds_read_b128 v[64:67], v2 offset:20480
		ds_read_b128 v[68:71], v2 offset:21504
		ds_read_b128 v[72:75], v2 offset:22528
		ds_read_b128 v[76:79], v2 offset:23552
		v_add_u32_e32 v0, 0x10000, v5
		v_add3_u32 v2, v0, v8, v6
		ds_read_b128 v[8:11], v2 offset:32768
		ds_read_b128 v[80:83], v2 offset:33792
		ds_read_b128 v[84:87], v2 offset:34816
		ds_read_b128 v[88:91], v2 offset:35840
		ds_read_b128 v[92:95], v2 offset:36864
		ds_read_b128 v[96:99], v2 offset:37888
		ds_read_b128 v[100:103], v2 offset:38912
		ds_read_b128 v[104:107], v2 offset:39936
		ds_read_b128 v[108:111], v2 offset:49152
		ds_read_b128 v[112:115], v2 offset:50176
		ds_read_b128 v[116:119], v2 offset:51200
		ds_read_b128 v[120:123], v2 offset:52224
		ds_read_b128 v[124:127], v2 offset:53248
		ds_read_b128 v[128:131], v2 offset:54272
		ds_read_b128 v[132:135], v2 offset:55296
		ds_read_b128 v[136:139], v2 offset:56320
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[12:15], v[8:11], v[16:19], v140, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[80:83], v[168:171], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[84:87], v[172:175], v140, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[88:91], v[176:179], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[8:11], v[180:183], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[80:83], v[184:187], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[84:87], v[188:191], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[88:91], v[192:195], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[8:11], v[196:199], v140, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[80:83], v[200:203], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[84:87], v[204:207], v140, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[88:91], v[208:211], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[8:11], v[212:215], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[80:83], v[216:219], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[84:87], v[220:223], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[88:91], v[224:227], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[32:35], v[8:11], a[68:71], v142, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[32:35], v[80:83], a[72:75], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[32:35], v[84:87], a[76:79], v142, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[32:35], v[88:91], a[80:83], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], v[8:11], a[100:103], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], v[80:83], a[104:107], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], v[84:87], a[108:111], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], v[88:91], a[112:115], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], v[8:11], a[132:135], v142, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], v[80:83], a[136:139], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[40:43], v[84:87], a[140:143], v142, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], v[88:91], a[144:147], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], v[8:11], a[164:167], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[44:47], v[80:83], a[168:171], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[44:47], v[84:87], a[172:175], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[44:47], v[88:91], a[176:179], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[48:51], v[108:111], v[16:19], v148, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], v[112:115], v[168:171], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], v[116:119], v[172:175], v148, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[120:123], v[176:179], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[52:55], v[108:111], v[180:183], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], v[112:115], v[184:187], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], v[116:119], v[188:191], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[120:123], v[192:195], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[56:59], v[108:111], v[196:199], v148, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], v[112:115], v[200:203], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], v[116:119], v[204:207], v148, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], v[120:123], v[208:211], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[60:63], v[108:111], v[212:215], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[60:63], v[112:115], v[216:219], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[60:63], v[116:119], v[220:223], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], v[120:123], v[224:227], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[64:67], v[108:111], a[68:71], v150, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[64:67], v[112:115], a[72:75], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[64:67], v[116:119], a[76:79], v150, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[64:67], v[120:123], a[80:83], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[68:71], v[108:111], a[100:103], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], v[112:115], a[104:107], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[68:71], v[116:119], a[108:111], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], v[120:123], a[112:115], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[72:75], v[108:111], a[132:135], v150, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[72:75], v[112:115], a[136:139], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[72:75], v[116:119], a[140:143], v150, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[72:75], v[120:123], a[144:147], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[76:79], v[108:111], a[164:167], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[76:79], v[112:115], a[168:171], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[76:79], v[116:119], a[172:175], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[76:79], v[120:123], a[176:179], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		v_accvgpr_read_b32 v0, a0
		v_lshlrev_b32_e32 v5, 15, v0
		v_add_u32_e32 v0, v5, v4
		ds_write_b64 v0, v[2:3]
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v0, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v0, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v0, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v0, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v0, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v0, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v0, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v0, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v0, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v0, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v0, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v0, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v0, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v0, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v0, v[2:3] offset:13824
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v3, a69
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v3, a71
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:16384
		v_accvgpr_read_b32 v2, a72
		v_accvgpr_read_b32 v3, a73
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a74
		v_accvgpr_read_b32 v3, a75
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:16896
		v_accvgpr_read_b32 v2, a76
		v_accvgpr_read_b32 v3, a77
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a78
		v_accvgpr_read_b32 v3, a79
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:17408
		v_accvgpr_read_b32 v2, a80
		v_accvgpr_read_b32 v3, a81
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a82
		v_accvgpr_read_b32 v3, a83
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:17920
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v3, a101
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v3, a103
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:20480
		v_accvgpr_read_b32 v2, a104
		v_accvgpr_read_b32 v3, a105
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a106
		v_accvgpr_read_b32 v3, a107
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:20992
		v_accvgpr_read_b32 v2, a108
		v_accvgpr_read_b32 v3, a109
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a110
		v_accvgpr_read_b32 v3, a111
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:21504
		v_accvgpr_read_b32 v2, a112
		v_accvgpr_read_b32 v3, a113
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a114
		v_accvgpr_read_b32 v3, a115
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:22016
		v_accvgpr_read_b32 v2, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:24576
		v_accvgpr_read_b32 v2, a136
		v_accvgpr_read_b32 v3, a137
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a138
		v_accvgpr_read_b32 v3, a139
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:25088
		v_accvgpr_read_b32 v2, a140
		v_accvgpr_read_b32 v3, a141
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a142
		v_accvgpr_read_b32 v3, a143
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:25600
		v_accvgpr_read_b32 v2, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:26112
		v_accvgpr_read_b32 v2, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:28672
		v_accvgpr_read_b32 v2, a168
		v_accvgpr_read_b32 v3, a169
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a170
		v_accvgpr_read_b32 v3, a171
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:29184
		v_accvgpr_read_b32 v2, a172
		v_accvgpr_read_b32 v3, a173
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a174
		v_accvgpr_read_b32 v3, a175
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:29696
		v_accvgpr_read_b32 v2, a176
		v_accvgpr_read_b32 v3, a177
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a178
		v_accvgpr_read_b32 v3, a179
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v0, v[6:7] offset:30208
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s0, 32
		v_cmp_lt_u32_e64 vcc, v1, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v2, v1, 4, v5
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s12, 0x7000
		s_and_saveexec_b64 s[52:53], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[4:7], v2
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], 0 offen
		ds_read_b128 v[4:7], v2 offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], 0 offen offset:512
		ds_read_b128 v[4:7], v2 offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], 0 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], 0 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s0 offen
		ds_read_b128 v[4:7], v2 offset:4608
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s0 offen offset:512
		ds_read_b128 v[4:7], v2 offset:5120
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s0 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:5632
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s0 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s1 offen
		ds_read_b128 v[4:7], v2 offset:8704
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s1 offen offset:512
		ds_read_b128 v[4:7], v2 offset:9216
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s1 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:9728
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s1 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s4 offen
		ds_read_b128 v[4:7], v2 offset:12800
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s4 offen offset:512
		ds_read_b128 v[4:7], v2 offset:13312
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s4 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:13824
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s4 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s5 offen
		ds_read_b128 v[4:7], v2 offset:16896
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s5 offen offset:512
		ds_read_b128 v[4:7], v2 offset:17408
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s5 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:17920
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s5 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s6 offen
		ds_read_b128 v[4:7], v2 offset:20992
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s6 offen offset:512
		ds_read_b128 v[4:7], v2 offset:21504
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s6 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:22016
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s6 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:24576
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s7 offen
		ds_read_b128 v[4:7], v2 offset:25088
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s7 offen offset:512
		ds_read_b128 v[4:7], v2 offset:25600
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s7 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:26112
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s7 offen offset:1536
		ds_read_b128 v[4:7], v2 offset:28672
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s12 offen
		ds_read_b128 v[4:7], v2 offset:29184
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s12 offen offset:512
		ds_read_b128 v[4:7], v2 offset:29696
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s12 offen offset:1024
		ds_read_b128 v[4:7], v2 offset:30208
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[4:7], v2, s[8:11], s12 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[92:95], a[4:7], v140, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[96:99], a[8:11], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[100:103], a[12:15], v140, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[104:107], a[16:19], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[92:95], a[20:23], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[96:99], a[24:27], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[100:103], a[28:31], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[104:107], a[32:35], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[24:27], v[92:95], a[36:39], v140, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[24:27], v[96:99], a[40:43], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[24:27], v[100:103], a[44:47], v140, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[104:107], a[48:51], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[28:31], v[92:95], a[52:55], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[28:31], v[96:99], a[56:59], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[28:31], v[100:103], a[60:63], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], v[104:107], a[64:67], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[32:35], v[92:95], a[84:87], v142, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[32:35], v[96:99], a[88:91], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[32:35], v[100:103], a[92:95], v142, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[32:35], v[104:107], a[96:99], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], v[92:95], a[116:119], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[36:39], v[96:99], a[120:123], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[36:39], v[100:103], a[124:127], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[36:39], v[104:107], a[128:131], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], v[92:95], a[148:151], v142, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[40:43], v[96:99], a[152:155], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[40:43], v[100:103], a[156:159], v142, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[40:43], v[104:107], a[160:163], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[44:47], v[92:95], a[180:183], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[44:47], v[96:99], a[184:187], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[44:47], v[100:103], a[188:191], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[44:47], v[104:107], a[192:195], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[48:51], v[124:127], a[4:7], v148, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[48:51], v[128:131], a[8:11], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[48:51], v[132:135], a[12:15], v148, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[48:51], v[136:139], a[16:19], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[52:55], v[124:127], a[20:23], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[52:55], v[128:131], a[24:27], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[52:55], v[132:135], a[28:31], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[52:55], v[136:139], a[32:35], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[56:59], v[124:127], a[36:39], v148, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[56:59], v[128:131], a[40:43], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[56:59], v[132:135], a[44:47], v148, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[56:59], v[136:139], a[48:51], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[60:63], v[124:127], a[52:55], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[60:63], v[128:131], a[56:59], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[60:63], v[132:135], a[60:63], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[60:63], v[136:139], a[64:67], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[64:67], v[124:127], a[84:87], v150, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[64:67], v[128:131], a[88:91], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[64:67], v[132:135], a[92:95], v150, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[64:67], v[136:139], a[96:99], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[68:71], v[124:127], a[116:119], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[68:71], v[128:131], a[120:123], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[68:71], v[132:135], a[124:127], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[68:71], v[136:139], a[128:131], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[72:75], v[124:127], a[148:151], v150, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[72:75], v[128:131], a[152:155], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[72:75], v[132:135], a[156:159], v150, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[72:75], v[136:139], a[160:163], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[76:79], v[124:127], a[180:183], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[76:79], v[128:131], a[184:187], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[76:79], v[132:135], a[188:191], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[76:79], v[136:139], a[192:195], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v3, a5
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v3, a7
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:2048
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v3, a9
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v3, a11
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:2560
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v3, a13
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v3, a15
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:3072
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v3, a17
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v3, a19
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:3584
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v3, a21
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v3, a23
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:6144
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v3, a25
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v3, a27
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:6656
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v3, a29
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v3, a31
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:7168
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v3, a33
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v3, a35
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:7680
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v3, a37
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v3, a39
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:10240
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v3, a41
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v3, a43
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:10752
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v3, a45
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v3, a47
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:11264
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v3, a49
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v3, a51
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:11776
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v3, a53
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v3, a55
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:14336
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v3, a57
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v3, a59
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:14848
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v3, a61
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v3, a63
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:15360
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v3, a65
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v3, a67
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:15872
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v3, a85
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v3, a87
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:18432
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:18944
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:19456
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:19968
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v3, a117
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v3, a119
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:22528
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v3, a121
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v3, a123
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:23040
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v3, a125
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v3, a127
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:23552
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v3, a129
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v3, a131
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:24064
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:26624
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:27136
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:27648
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:28160
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v3, a181
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v3, a183
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:30720
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v3, a185
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v3, a187
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:31232
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v3, a189
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v3, a191
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:31744
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v3, a193
		v_cvt_pk_f16_f32 v4, v1, v3
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v3, a195
		v_cvt_pk_f16_f32 v5, v1, v3
		ds_write_b64 v0, v[4:5] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[52:53], s[2:3]
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
		buffer_store_dwordx4 v[4:7], v2, s[8:11], 0 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[8:11], v2, s[8:11], 0 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[12:15], v2, s[8:11], 0 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[16:19], v2, s[8:11], 0 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[20:23], v2, s[8:11], s0 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[24:27], v2, s[8:11], s0 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[28:31], v2, s[8:11], s0 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[32:35], v2, s[8:11], s0 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[36:39], v2, s[8:11], s1 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[40:43], v2, s[8:11], s1 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[44:47], v2, s[8:11], s1 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[48:51], v2, s[8:11], s1 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[52:55], v2, s[8:11], s4 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[56:59], v2, s[8:11], s4 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[60:63], v2, s[8:11], s4 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[64:67], v2, s[8:11], s4 offen offset:3584
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		buffer_store_dwordx4 v[68:71], v2, s[8:11], s5 offen offset:2048
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[72:75], v2, s[8:11], s5 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[76:79], v2, s[8:11], s5 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[80:83], v2, s[8:11], s5 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[84:87], v2, s[8:11], s6 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[88:91], v2, s[8:11], s6 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[92:95], v2, s[8:11], s6 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[96:99], v2, s[8:11], s6 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[100:103], v2, s[8:11], s7 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[104:107], v2, s[8:11], s7 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[108:111], v2, s[8:11], s7 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[112:115], v2, s[8:11], s7 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[116:119], v2, s[8:11], s12 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[120:123], v2, s[8:11], s12 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[124:127], v2, s[8:11], s12 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[128:131], v2, s[8:11], s12 offen offset:3584
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
		.amdhsa_next_free_vgpr 452
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 253
	.set .Lwmma_f16_matmul_tiled.num_agpr, 196
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
    .vgpr_count:     452
    .agpr_count:     196
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
