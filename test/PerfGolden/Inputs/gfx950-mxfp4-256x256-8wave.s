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
		v_mov_b32_e32 v1, 0
		s_mov_b32 s16, 1
		s_mov_b32 s17, 0
		s_and_saveexec_b64 s[18:19], s[16:17]
		ds_write_b32 v1, v1
		v_mov_b32_e32 v2, 4
		ds_write_b32 v2, v1
		s_mov_b64 exec, s[18:19]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s22, 0x80000000
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s10
		s_mov_b32 s21, s11
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_mov_b32 s10, 0x1000000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s11, s23
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s10
		s_mov_b32 s3, s23
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
		s_add_u32 s28, s6, s13
		s_addc_u32 s29, s7, 0
		s_mov_b32 s30, 0x20000
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s7, s6, 6
		s_lshl_b32 s13, s7, 10
		s_add_i32 m0, s13, 16
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshlrev_b32_e32 v3, 12, v3
		v_lshl_add_u32 v3, s7, 16, v3
		v_lshrrev_b32_e32 v4, 3, v2
		v_bitop3_b32 v5, v4, 3, v2 bitop3:0x48
		v_lshl_add_u32 v3, v5, 4, v3
		s_lshl_b32 s14, s5, 22
		s_lshl_b32 s15, s4, 20
		s_add_i32 s18, s14, s15
		v_add_u32_e32 v5, s18, v3
		buffer_load_dwordx4 v5, s[8:11], 0 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s18, s14, 0x80000
		v_add_u32_e32 v6, s15, v3
		v_add_u32_e32 v7, s18, v6
		buffer_load_dwordx4 v7, s[8:11], 0 offen lds
		v_lshrrev_b32_e32 v7, 6, v0
		s_add_i32 m0, s13, 0x4010
		v_add3_u32 v12, s14, 64, v6
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_mov_b32 s18, 0
		s_add_i32 m0, s13, 0x6010
		s_add_i32 s19, s14, 0x80040
		v_add_u32_e32 v6, s19, v6
		buffer_load_dwordx4 v6, s[8:11], 0 offen lds
		s_lshl_b32 s19, s12, 20
		s_add_i32 m0, s13, 0x8010
		v_add_u32_e32 v6, s19, v3
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_add_i32 s31, s19, 0x80000
		s_add_i32 m0, s13, 0xa010
		v_add_u32_e32 v12, s31, v3
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_and_b32_e32 v12, 39, v0
		s_add_i32 m0, s13, 0xc010
		v_add3_u32 v13, s19, 64, v3
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_add_i32 s31, s19, 0x80040
		s_add_i32 m0, s13, 0xe010
		v_add_u32_e32 v13, s31, v3
		v_and_or_b32 v14, 1, s7, v12
		v_cmp_eq_u32_e64 vcc, v14, s18
		s_mov_b64 s[32:33], vcc
		s_lshr_b32 s6, s6, 7
		s_lshl_b32 s31, s6, 9
		s_lshl_b32 s6, s6, 6
		s_lshl_b32 s5, s5, 10
		s_add_i32 s34, s6, s5
		s_lshl_b32 s4, s4, 8
		s_add_i32 s34, s34, s4
		v_lshl_add_u32 v14, v4, 12, s4
		v_add_u32_e32 v14, s5, v14
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s31, 0x20010
		v_lshl_add_u32 v13, v4, 12, s34
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add3_u32 v13, s6, 16, v14
		s_add_i32 m0, s31, 0x20020
		v_add3_u32 v15, s6, 32, v14
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add3_u32 v13, s6, 48, v14
		s_add_i32 m0, s31, 0x20030
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s31, 0x20040
		s_nop 0
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[52:53]
		v_lshrrev_b32_e32 v13, 1, v7
		v_or_b32_e32 v12, v12, v13
		v_cmp_eq_u32_e64 vcc, v12, s18
		s_mov_b64 s[34:35], vcc
		s_and_b32 s36, s7, 1
		s_lshl_b32 s37, s36, 10
		s_lshl_b32 s12, s12, 8
		s_lshl_b32 s36, s36, 7
		s_add_i32 s38, s12, s36
		s_add_i32 s39, s12, 16
		s_add_i32 s39, s39, s36
		v_lshl_add_u32 v12, v4, 12, s36
		v_lshl_add_u32 v13, v4, 12, s36
		v_add_u32_e32 v13, s12, v13
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s37, 0x20810
		v_lshl_add_u32 v14, v4, 12, s38
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_lshl_add_u32 v14, v4, 12, s39
		s_add_i32 m0, s37, 0x20820
		v_add3_u32 v15, s12, 32, v12
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add3_u32 v14, s12, 48, v12
		s_add_i32 m0, s37, 0x20830
		v_add3_u32 v12, s12, 64, v12
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_add_u32_e32 v15, 0x50, v13
		s_add_i32 m0, s37, 0x20840
		v_add_u32_e32 v16, 0x60, v13
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v13, 0x70, v13
		s_add_i32 m0, s37, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x20a40
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s6, 0x4000
		s_add_i32 s38, s38, s5
		s_add_i32 s38, s38, s4
		v_lshl_add_u32 v12, v4, 12, s4
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v12, s6, v12
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s31, 0x21010
		v_lshl_add_u32 v13, v4, 12, s38
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v13, 0x4010, v12
		s_add_i32 m0, s31, 0x21020
		v_add_u32_e32 v14, 0x4020, v12
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v12, 0x4030, v12
		s_add_i32 m0, s31, 0x21030
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s31, 0x21040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s12, 0x4000
		s_add_i32 s38, s38, s36
		s_add_i32 s39, s12, 0x4010
		s_add_i32 s39, s39, s36
		v_lshl_add_u32 v12, v4, 12, s36
		v_add_u32_e32 v12, s12, v12
		v_lshl_add_u32 v13, v4, 12, s36
		v_add_u32_e32 v13, s12, v13
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s37, 0x21810
		v_lshl_add_u32 v14, v4, 12, s38
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_lshl_add_u32 v14, v4, 12, s39
		s_add_i32 m0, s37, 0x21820
		v_add_u32_e32 v15, 0x4020, v12
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v14, 0x4030, v12
		s_add_i32 m0, s37, 0x21830
		v_add_u32_e32 v12, 0x4040, v12
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_add_u32_e32 v15, 0x4050, v13
		s_add_i32 m0, s37, 0x21840
		v_add_u32_e32 v16, 0x4060, v13
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v13, 0x4070, v13
		s_add_i32 m0, s37, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x21a40
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s6, 0x8000
		s_add_i32 s38, s38, s5
		s_add_i32 s38, s38, s4
		v_lshl_add_u32 v12, v4, 12, s4
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v12, s6, v12
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s31, 0x22010
		v_lshl_add_u32 v13, v4, 12, s38
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v13, 0x8010, v12
		s_add_i32 m0, s31, 0x22020
		v_add_u32_e32 v14, 0x8020, v12
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v12, 0x8030, v12
		s_add_i32 m0, s31, 0x22030
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s31, 0x22040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s12, 0x8000
		s_add_i32 s38, s38, s36
		s_add_i32 s39, s12, 0x8010
		s_add_i32 s39, s39, s36
		v_lshl_add_u32 v12, v4, 12, s36
		v_add_u32_e32 v12, s12, v12
		v_lshl_add_u32 v13, v4, 12, s36
		v_add_u32_e32 v13, s12, v13
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s37, 0x22810
		v_lshl_add_u32 v14, v4, 12, s38
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_lshl_add_u32 v14, v4, 12, s39
		s_add_i32 m0, s37, 0x22820
		v_add_u32_e32 v15, 0x8020, v12
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v14, 0x8030, v12
		s_add_i32 m0, s37, 0x22830
		v_add_u32_e32 v12, 0x8040, v12
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_add_u32_e32 v15, 0x8050, v13
		s_add_i32 m0, s37, 0x22840
		v_add_u32_e32 v16, 0x8060, v13
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v13, 0x8070, v13
		s_add_i32 m0, s37, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x22a40
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s6, 0xc000
		s_add_i32 s38, s38, s5
		s_add_i32 s38, s38, s4
		v_lshl_add_u32 v12, v4, 12, s4
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v12, s6, v12
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s31, 0x23010
		v_lshl_add_u32 v13, v4, 12, s38
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v13, 0xc010, v12
		s_add_i32 m0, s31, 0x23020
		v_add_u32_e32 v14, 0xc020, v12
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_add_u32_e32 v12, 0xc030, v12
		s_add_i32 m0, s31, 0x23030
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s31, 0x23040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s38, s12, 0xc000
		s_add_i32 s38, s38, s36
		s_add_i32 s39, s12, 0xc010
		s_add_i32 s39, s39, s36
		v_lshl_add_u32 v12, v4, 12, s36
		v_add_u32_e32 v12, s12, v12
		v_lshl_add_u32 v13, v4, 12, s36
		v_add_u32_e32 v13, s12, v13
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s37, 0x23810
		v_lshl_add_u32 v14, v4, 12, s38
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_lshl_add_u32 v14, v4, 12, s39
		s_add_i32 m0, s37, 0x23820
		v_add_u32_e32 v15, 0xc020, v12
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v14, 0xc030, v12
		s_add_i32 m0, s37, 0x23830
		v_add_u32_e32 v12, 0xc040, v12
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_add_u32_e32 v15, 0xc050, v13
		s_add_i32 m0, s37, 0x23840
		v_add_u32_e32 v16, 0xc060, v13
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		v_add_u32_e32 v13, 0xc070, v13
		s_add_i32 m0, s37, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s37, 0x23a40
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[52:53]
		s_add_i32 m0, s13, 0x10010
		s_add_i32 s38, s14, 0x80
		s_add_i32 s38, s38, s15
		v_add_u32_e32 v12, s38, v3
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		v_add_u32_e32 v12, s15, v3
		s_add_i32 m0, s13, 0x12010
		v_add_u32_e32 v12, s14, v12
		v_add_u32_e32 v13, 0x80080, v12
		buffer_load_dwordx4 v13, s[8:11], 0 offen lds
		v_lshlrev_b32_e32 v13, 3, v2
		s_add_i32 m0, s13, 0x14010
		v_add_u32_e32 v14, 0xc0, v12
		buffer_load_dwordx4 v14, s[8:11], 0 offen lds
		v_and_b32_e32 v7, 1, v7
		s_add_i32 m0, s13, 0x16010
		v_add_u32_e32 v12, 0x800c0, v12
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_add_i32 s14, s19, 0x80
		s_add_i32 m0, s13, 0x18010
		v_add_u32_e32 v12, s14, v3
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s19, v3
		s_add_i32 m0, s13, 0x1a010
		v_add_u32_e32 v12, 0x80080, v3
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_lshrrev_b32_e32 v2, 4, v2
		s_add_i32 m0, s13, 0x1c010
		v_add_u32_e32 v12, 0xc0, v3
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_lshrrev_b32_e32 v12, 7, v0
		s_add_i32 m0, s13, 0x1e010
		v_add_u32_e32 v3, 0x800c0, v3
		v_lshlrev_b32_e32 v14, 12, v12
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v15, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v2, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v2, v14, v15, v0
		v_lshlrev_b32_e32 v16, 13, v7
		v_add3_u32 v17, v15, v16, v0
		v_add_u32_e32 v18, 0x100, v5
		v_add_u32_e32 v19, 0x80100, v5
		v_add_u32_e32 v20, 0x140, v5
		v_add_u32_e32 v21, 0x80140, v5
		v_add_u32_e32 v5, 0x100, v6
		v_add_u32_e32 v22, 0x80100, v6
		v_add_u32_e32 v23, 0x140, v6
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[24:27], v2
		ds_read_b128 v[28:31], v2 offset:1024
		ds_read_b128 v[32:35], v2 offset:2048
		ds_read_b128 v[36:39], v2 offset:3072
		ds_read_b128 v[40:43], v2 offset:16384
		ds_read_b128 v[44:47], v2 offset:17408
		ds_read_b128 v[48:51], v2 offset:18432
		ds_read_b128 v[52:55], v2 offset:19456
		v_add_u32_e32 v2, 16, v17
		ds_read_b128 v[56:59], v2 offset:32768
		ds_read_b128 v[60:63], v2 offset:33792
		ds_read_b128 v[64:67], v2 offset:34816
		ds_read_b128 v[68:71], v2 offset:35840
		ds_read_b128 v[72:75], v2 offset:36864
		ds_read_b128 v[76:79], v2 offset:37888
		ds_read_b128 v[80:83], v2 offset:38912
		ds_read_b128 v[84:87], v2 offset:39936
		ds_read_b128 v[88:91], v2 offset:49152
		ds_read_b128 v[92:95], v2 offset:50176
		ds_read_b128 v[96:99], v2 offset:51200
		ds_read_b128 v[100:103], v2 offset:52224
		ds_read_b128 v[104:107], v2 offset:53248
		ds_read_b128 v[108:111], v2 offset:54272
		ds_read_b128 v[112:115], v2 offset:55296
		ds_read_b128 v[116:119], v2 offset:56320
		v_add_u32_e32 v2, 0x80140, v6
		v_lshlrev_b32_e32 v3, 9, v12
		v_lshlrev_b32_e32 v6, 10, v7
		s_add_i32 s14, s6, 0x10000
		s_add_i32 s14, s14, s5
		s_add_i32 s14, s14, s4
		s_add_i32 s15, s6, 0x10010
		s_add_i32 s15, s15, s5
		s_add_i32 s15, s15, s4
		s_add_i32 s19, s6, 0x10020
		s_add_i32 s19, s19, s5
		s_add_i32 s19, s19, s4
		s_add_i32 s38, s6, 0x10030
		s_add_i32 s38, s38, s5
		s_add_i32 s38, s38, s4
		s_add_i32 s39, s12, 0x10000
		s_add_i32 s39, s39, s36
		s_add_i32 s40, s12, 0x10010
		s_add_i32 s40, s40, s36
		s_add_i32 s41, s6, 0x14000
		s_add_i32 s41, s41, s5
		s_add_i32 s41, s41, s4
		s_add_i32 s42, s6, 0x14010
		s_add_i32 s42, s42, s5
		s_add_i32 s42, s42, s4
		s_add_i32 s43, s6, 0x14020
		s_add_i32 s43, s43, s5
		s_add_i32 s43, s43, s4
		s_add_i32 s6, s6, 0x14030
		s_add_i32 s5, s6, s5
		s_add_i32 s4, s5, s4
		s_add_i32 s5, s12, 0x14000
		s_add_i32 s5, s5, s36
		s_add_i32 s6, s12, 0x14010
		s_add_i32 s6, s6, s36
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt vmcnt(8) lgkmcnt(0)
		s_barrier
		s_and_b32 s44, s18, 1
		s_lshl_b32 s44, s44, 13
		s_add_i32 s45, s44, 0x20000
		v_add3_u32 v12, s45, v3, v13
		v_add_u32_e32 v12, 16, v12
		ds_read_b64_tr_b8 v[244:245], v12
		v_add3_u32 v17, s45, v13, v6
		v_add_u32_e32 v17, 16, v17
		ds_read_b64_tr_b8 v[246:247], v17 offset:2048
		ds_read_b64_tr_b8 v[248:249], v17 offset:2560
		ds_read_b64_tr_b8 v[250:251], v12 offset:4096
		ds_read_b64_tr_b8 v[252:253], v17 offset:6144
		ds_read_b64_tr_b8 v[254:255], v17 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[24:27], v[56:59], v[8:11], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[60:63], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[64:67], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[68:71], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mov_b32_e32 v12, 1
		s_and_saveexec_b64 s[46:47], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v17, v1, v12
		s_mov_b64 exec, s[46:47]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[68:71], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[56:59], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[60:63], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[64:67], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[64:67], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[56:59], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[60:63], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[68:71], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[68:71], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[56:59], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[60:63], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], v[64:67], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[40:43], v[88:91], v[8:11], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], v[92:95], v[120:123], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], v[96:99], v[124:127], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[40:43], v[100:103], v[128:131], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[44:47], v[100:103], v[160:163], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], v[88:91], v[148:151], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[44:47], v[92:95], v[152:155], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[44:47], v[96:99], v[156:159], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], v[96:99], v[188:191], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], v[88:91], v[180:183], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[48:51], v[92:95], v[184:187], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[48:51], v[100:103], v[192:195], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], v[100:103], v[224:227], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[52:55], v[88:91], v[212:215], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], v[92:95], v[216:219], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], v[96:99], v[220:223], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v17
		s_and_b32 s45, s45, -8
		s_add_i32 s45, s45, 8
		s_and_saveexec_b64 s[46:47], s[16:17]
		ds_read_b32 v12, v1
		s_xor_b32 s45, s45, -1
		s_add_i32 s45, s45, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s48, v12
		s_add_i32 s48, s48, s45
		s_cmp_ge_u32 s48, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v12, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s48, v12
		s_add_i32 s48, s48, s45
		s_cmp_ge_u32 s48, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[46:47]
		s_add_i32 s45, s31, s44
		s_lshl_b32 s46, s18, 15
		s_add_i32 s47, s14, s46
		s_add_i32 s48, s15, s46
		s_add_i32 s49, s19, s46
		s_add_i32 s50, s38, s46
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s45, 0x20010
		v_lshl_add_u32 v12, v4, 12, s47
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_lshl_add_u32 v12, v4, 12, s48
		s_add_i32 m0, s45, 0x20020
		v_lshl_add_u32 v17, v4, 12, s49
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_lshl_add_u32 v12, v4, 12, s50
		s_add_i32 m0, s45, 0x20030
		s_nop 0
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s45, 0x20040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s44, s37, s44
		s_add_i32 s47, s39, s46
		s_add_i32 s48, s40, s46
		v_lshl_add_u32 v12, v4, 12, s46
		v_add_u32_e32 v12, s36, v12
		v_add_u32_e32 v12, s12, v12
		v_lshl_add_u32 v17, v4, 12, s46
		v_add_u32_e32 v17, s36, v17
		v_add_u32_e32 v17, s12, v17
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s44, 0x20810
		v_lshl_add_u32 v56, v4, 12, s47
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_lshl_add_u32 v56, v4, 12, s48
		s_add_i32 m0, s44, 0x20820
		v_add_u32_e32 v57, 0x10020, v12
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_add_u32_e32 v56, 0x10030, v12
		s_add_i32 m0, s44, 0x20830
		v_add_u32_e32 v12, 0x10040, v12
		buffer_load_dwordx4 v57, s[20:23], 0 offen lds
		v_add_u32_e32 v57, 0x10050, v17
		s_add_i32 m0, s44, 0x20840
		v_add_u32_e32 v58, 0x10060, v17
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_add_u32_e32 v17, 0x10070, v17
		s_add_i32 m0, s44, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v57, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v58, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x20a40
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s47, s41, s46
		s_add_i32 s48, s42, s46
		s_add_i32 s49, s43, s46
		s_add_i32 s50, s4, s46
		s_and_saveexec_b64 s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s45, 0x21010
		v_lshl_add_u32 v12, v4, 12, s47
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_lshl_add_u32 v12, v4, 12, s48
		s_add_i32 m0, s45, 0x21020
		v_lshl_add_u32 v17, v4, 12, s49
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_lshl_add_u32 v12, v4, 12, s50
		s_add_i32 m0, s45, 0x21030
		s_nop 0
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s45, 0x21040
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[52:53], s[32:33]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[52:53]
		s_add_i32 s45, s5, s46
		s_add_i32 s47, s6, s46
		v_lshl_add_u32 v12, v4, 12, s46
		v_add_u32_e32 v12, s36, v12
		v_add_u32_e32 v12, s12, v12
		v_lshl_add_u32 v17, v4, 12, s46
		v_add_u32_e32 v17, s36, v17
		v_add_u32_e32 v17, s12, v17
		s_and_saveexec_b64 s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s44, 0x21810
		v_lshl_add_u32 v56, v4, 12, s45
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_lshl_add_u32 v56, v4, 12, s47
		s_add_i32 m0, s44, 0x21820
		v_add_u32_e32 v57, 0x14020, v12
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_add_u32_e32 v56, 0x14030, v12
		s_add_i32 m0, s44, 0x21830
		v_add_u32_e32 v12, 0x14040, v12
		buffer_load_dwordx4 v57, s[20:23], 0 offen lds
		v_add_u32_e32 v57, 0x14050, v17
		s_add_i32 m0, s44, 0x21840
		v_add_u32_e32 v58, 0x14060, v17
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_add_u32_e32 v17, 0x14070, v17
		s_add_i32 m0, s44, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v57, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v58, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, s44, 0x21a40
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[52:53], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[72:75], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[76:79], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[80:83], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[84:87], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[84:87], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[72:75], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[76:79], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[80:83], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[80:83], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[72:75], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[76:79], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[84:87], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[36:39], v[84:87], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], v[72:75], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], v[76:79], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[36:39], v[80:83], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], v[104:107], v[132:135], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], v[108:111], v[136:139], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[112:115], v[140:143], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[116:119], v[144:147], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[116:119], v[176:179], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[44:47], v[104:107], v[164:167], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[44:47], v[108:111], v[168:171], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[112:115], v[172:175], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[112:115], v[204:207], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[48:51], v[104:107], v[196:199], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[48:51], v[108:111], v[200:203], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[116:119], v[208:211], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[52:55], v[116:119], v[240:243], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[52:55], v[104:107], v[228:231], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], v[108:111], v[232:235], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], v[112:115], v[236:239], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s13, 16
		s_lshl_b32 s44, s18, 7
		buffer_load_dwordx4 v18, s[8:11], s44 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v19, s[8:11], s44 offen lds
		s_nop 0
		s_add_i32 m0, s13, 0x4010
		s_nop 0
		buffer_load_dwordx4 v20, s[8:11], s44 offen lds
		s_nop 0
		s_add_i32 m0, s13, 0x6010
		s_nop 0
		buffer_load_dwordx4 v21, s[8:11], s44 offen lds
		s_nop 0
		s_add_i32 m0, s13, 0x8010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], s44 offen lds
		s_nop 0
		s_add_i32 m0, s13, 0xa010
		s_nop 0
		buffer_load_dwordx4 v22, s[0:3], s44 offen lds
		s_nop 0
		s_add_i32 m0, s13, 0xc010
		s_add_i32 s45, s13, 0x10000
		buffer_load_dwordx4 v23, s[0:3], s44 offen lds
		s_add_i32 s18, s18, 1
		s_add_i32 m0, s13, 0xe010
		s_and_b32 s13, s18, 1
		s_lshl_b32 s13, s13, 16
		v_add_u32_e32 v12, s13, v14
		v_add3_u32 v12, v12, v15, v0
		v_add_u32_e32 v17, s13, v15
		v_add3_u32 v17, v17, v16, v0
		s_and_b32 s13, s45, 0x1ffff
		s_cmp_lt_i32 s18, 30
		buffer_load_dwordx4 v2, s[0:3], s44 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_add_u32_e32 v12, 16, v12
		ds_read_b128 v[24:27], v12
		ds_read_b128 v[28:31], v12 offset:1024
		ds_read_b128 v[32:35], v12 offset:2048
		ds_read_b128 v[36:39], v12 offset:3072
		ds_read_b128 v[40:43], v12 offset:16384
		ds_read_b128 v[44:47], v12 offset:17408
		ds_read_b128 v[48:51], v12 offset:18432
		ds_read_b128 v[52:55], v12 offset:19456
		v_add_u32_e32 v12, 16, v17
		ds_read_b128 v[56:59], v12 offset:32768
		ds_read_b128 v[60:63], v12 offset:33792
		ds_read_b128 v[64:67], v12 offset:34816
		ds_read_b128 v[68:71], v12 offset:35840
		ds_read_b128 v[72:75], v12 offset:36864
		ds_read_b128 v[76:79], v12 offset:37888
		ds_read_b128 v[80:83], v12 offset:38912
		ds_read_b128 v[84:87], v12 offset:39936
		ds_read_b128 v[88:91], v12 offset:49152
		ds_read_b128 v[92:95], v12 offset:50176
		ds_read_b128 v[96:99], v12 offset:51200
		ds_read_b128 v[100:103], v12 offset:52224
		ds_read_b128 v[104:107], v12 offset:53248
		ds_read_b128 v[108:111], v12 offset:54272
		ds_read_b128 v[112:115], v12 offset:55296
		ds_read_b128 v[116:119], v12 offset:56320
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v1, 0x20000, v3
		v_add_u32_e32 v1, v1, v13
		v_add_u32_e32 v1, 16, v1
		ds_read_b64_tr_b8 v[2:3], v1
		v_add_u32_e32 v4, 0x20000, v13
		v_lshl_add_u32 v4, v7, 10, v4
		v_add_u32_e32 v4, 16, v4
		ds_read_b64_tr_b8 v[6:7], v4 offset:2048
		ds_read_b64_tr_b8 v[18:19], v4 offset:2560
		ds_read_b64_tr_b8 v[20:21], v1 offset:4096
		ds_read_b64_tr_b8 v[22:23], v4 offset:6144
		ds_read_b64_tr_b8 v[244:245], v4 offset:6656
		v_mov_b32_e32 v5, 1
		s_and_saveexec_b64 s[0:1], s[16:17]
		v_mov_b32_e32 v12, 4
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v17, v12, v5
		s_mov_b64 exec, s[0:1]
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[24:27], v[56:59], v[8:11], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[60:63], v[120:123], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[64:67], v[124:127], v2, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[68:71], v[128:131], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[72:75], v[132:135], v2, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[76:79], v[136:139], v2, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[80:83], v[140:143], v2, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[84:87], v[144:147], v2, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[84:87], v[176:179], v2, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[72:75], v[164:167], v2, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[76:79], v[168:171], v2, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[80:83], v[172:175], v2, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[80:83], v[204:207], v2, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[72:75], v[196:199], v2, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[76:79], v[200:203], v2, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[84:87], v[208:211], v2, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[36:39], v[84:87], v[240:243], v2, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[36:39], v[72:75], v[228:231], v2, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[36:39], v[76:79], v[232:235], v2, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[36:39], v[80:83], v[236:239], v2, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[56:59], v[212:215], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[56:59], v[148:151], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[60:63], v[152:155], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[64:67], v[156:159], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[68:71], v[160:163], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[68:71], v[192:195], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[56:59], v[180:183], v2, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[60:63], v[184:187], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[64:67], v[188:191], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], v[64:67], v[220:223], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[60:63], v[216:219], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[68:71], v[224:227], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[40:43], v[88:91], v[8:11], v20, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], v[92:95], v[120:123], v20, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], v[96:99], v[124:127], v20, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[40:43], v[100:103], v[128:131], v20, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], v[104:107], v[132:135], v20, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], v[108:111], v[136:139], v20, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[112:115], v[140:143], v20, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[116:119], v[144:147], v20, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[116:119], v[176:179], v20, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[44:47], v[104:107], v[164:167], v20, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[44:47], v[108:111], v[168:171], v20, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[112:115], v[172:175], v20, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[112:115], v[204:207], v20, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[48:51], v[104:107], v[196:199], v20, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[48:51], v[108:111], v[200:203], v20, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[116:119], v[208:211], v20, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[52:55], v[116:119], v[240:243], v20, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[52:55], v[104:107], v[228:231], v20, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[52:55], v[108:111], v[232:235], v20, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[52:55], v[112:115], v[236:239], v20, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[52:55], v[88:91], v[212:215], v20, v22 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], v[88:91], v[148:151], v20, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[44:47], v[92:95], v[152:155], v20, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[44:47], v[96:99], v[156:159], v20, v22 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[44:47], v[100:103], v[160:163], v20, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[48:51], v[100:103], v[192:195], v20, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], v[88:91], v[180:183], v20, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[48:51], v[92:95], v[184:187], v20, v22 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[48:51], v[96:99], v[188:191], v20, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[52:55], v[96:99], v[220:223], v20, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[52:55], v[92:95], v[216:219], v20, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[52:55], v[100:103], v[224:227], v20, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s0, v17
		s_and_b32 s0, s0, -8
		s_add_i32 s0, s0, 8
		s_and_saveexec_b64 s[2:3], s[16:17]
		ds_read_b32 v2, v12
		s_xor_b32 s0, s0, -1
		s_add_i32 s0, s0, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_1
.Lwmma_f16_matmul_tiled.loop_head_2:
		s_sleep 1
		ds_read_b32 v2, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
.Lwmma_f16_matmul_tiled.loop_exit_2:
		s_branch .Lwmma_f16_matmul_tiled.if_end_1
.Lwmma_f16_matmul_tiled.if_else_1:
.Lwmma_f16_matmul_tiled.if_end_1:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v2, 0x10000, v14
		v_add3_u32 v2, v2, v15, v0
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[20:23], v2
		ds_read_b128 v[24:27], v2 offset:1024
		ds_read_b128 v[28:31], v2 offset:2048
		ds_read_b128 v[32:35], v2 offset:3072
		ds_read_b128 v[36:39], v2 offset:16384
		ds_read_b128 v[40:43], v2 offset:17408
		ds_read_b128 v[44:47], v2 offset:18432
		ds_read_b128 v[48:51], v2 offset:19456
		v_add_u32_e32 v2, 0x10000, v15
		v_add3_u32 v0, v2, v16, v0
		v_add_u32_e32 v0, 16, v0
		ds_read_b128 v[16:19], v0 offset:32768
		ds_read_b128 v[52:55], v0 offset:33792
		ds_read_b128 v[56:59], v0 offset:34816
		ds_read_b128 v[60:63], v0 offset:35840
		ds_read_b128 v[64:67], v0 offset:36864
		ds_read_b128 v[68:71], v0 offset:37888
		ds_read_b128 v[72:75], v0 offset:38912
		ds_read_b128 v[76:79], v0 offset:39936
		ds_read_b128 v[80:83], v0 offset:49152
		ds_read_b128 v[84:87], v0 offset:50176
		ds_read_b128 v[88:91], v0 offset:51200
		ds_read_b128 v[92:95], v0 offset:52224
		ds_read_b128 v[96:99], v0 offset:53248
		ds_read_b128 v[100:103], v0 offset:54272
		ds_read_b128 v[104:107], v0 offset:55296
		ds_read_b128 v[108:111], v0 offset:56320
		v_lshl_add_u32 v0, s7, 14, v13
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s2, 0x3000
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[2:3], v1 offset:8192
		ds_read_b64_tr_b8 v[6:7], v4 offset:10240
		ds_read_b64_tr_b8 v[12:13], v4 offset:10752
		ds_read_b64_tr_b8 v[14:15], v1 offset:12288
		ds_read_b64_tr_b8 v[112:113], v4 offset:14336
		ds_read_b64_tr_b8 v[114:115], v4 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[16:19], v[8:11], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[52:55], v[120:123], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v2, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[60:63], v[160:163], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[16:19], v[148:151], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[52:55], v[152:155], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[56:59], v[156:159], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[56:59], v[188:191], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[16:19], v[180:183], v2, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[52:55], v[184:187], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[60:63], v[192:195], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[60:63], v[224:227], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[16:19], v[212:215], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[52:55], v[216:219], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[56:59], v[220:223], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[80:83], v[8:11], v14, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[84:87], v[120:123], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[88:91], v[124:127], v14, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[92:95], v[128:131], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[92:95], v[160:163], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[80:83], v[148:151], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[84:87], v[152:155], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[88:91], v[156:159], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[88:91], v[188:191], v14, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v8, v9
		v_cvt_pk_f16_f32 v5, v10, v11
		s_mov_b32 s31, s23
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[4:5], v0, s[28:31], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[80:83], v[180:183], v14, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[84:87], v[184:187], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[92:95], v[192:195], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[92:95], v[224:227], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[80:83], v[212:215], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[84:87], v[216:219], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[88:91], v[220:223], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		buffer_store_dwordx2 v[4:5], v0, s[28:31], 0 offen offset:512
		v_cvt_pk_f16_f32 v4, v124, v125
		v_cvt_pk_f16_f32 v5, v126, v127
		buffer_store_dwordx2 v[4:5], v0, s[28:31], 0 offen offset:1024
		v_cvt_pk_f16_f32 v4, v128, v129
		v_cvt_pk_f16_f32 v5, v130, v131
		buffer_store_dwordx2 v[4:5], v0, s[28:31], 0 offen offset:1536
		v_cvt_pk_f16_f32 v4, v148, v149
		v_cvt_pk_f16_f32 v5, v150, v151
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen
		v_cvt_pk_f16_f32 v4, v152, v153
		v_cvt_pk_f16_f32 v5, v154, v155
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:512
		v_cvt_pk_f16_f32 v4, v156, v157
		v_cvt_pk_f16_f32 v5, v158, v159
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:1024
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:1536
		v_cvt_pk_f16_f32 v4, v180, v181
		v_cvt_pk_f16_f32 v5, v182, v183
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s1 offen
		v_cvt_pk_f16_f32 v4, v184, v185
		v_cvt_pk_f16_f32 v5, v186, v187
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s1 offen offset:512
		v_cvt_pk_f16_f32 v4, v188, v189
		v_cvt_pk_f16_f32 v5, v190, v191
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s1 offen offset:1024
		v_cvt_pk_f16_f32 v4, v192, v193
		v_cvt_pk_f16_f32 v5, v194, v195
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s1 offen offset:1536
		v_cvt_pk_f16_f32 v4, v212, v213
		v_cvt_pk_f16_f32 v5, v214, v215
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v4, v216, v217
		v_cvt_pk_f16_f32 v5, v218, v219
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:512
		v_cvt_pk_f16_f32 v4, v220, v221
		v_cvt_pk_f16_f32 v5, v222, v223
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_cvt_pk_f16_f32 v4, v224, v225
		v_cvt_pk_f16_f32 v5, v226, v227
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[64:67], v[132:135], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[68:71], v[136:139], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[72:75], v[140:143], v2, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[76:79], v[144:147], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[76:79], v[176:179], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[64:67], v[164:167], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[68:71], v[168:171], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[72:75], v[172:175], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[72:75], v[204:207], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[64:67], v[196:199], v2, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[68:71], v[200:203], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[76:79], v[208:211], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[76:79], v[240:243], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[64:67], v[228:231], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[68:71], v[232:235], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[72:75], v[236:239], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[96:99], v[132:135], v14, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[100:103], v[136:139], v14, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[104:107], v[140:143], v14, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[108:111], v[144:147], v14, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[108:111], v[176:179], v14, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[96:99], v[164:167], v14, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[100:103], v[168:171], v14, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[104:107], v[172:175], v14, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[104:107], v[204:207], v14, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[96:99], v[196:199], v14, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[100:103], v[200:203], v14, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[108:111], v[208:211], v14, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[108:111], v[240:243], v14, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[96:99], v[228:231], v14, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[100:103], v[232:235], v14, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[104:107], v[236:239], v14, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 16
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
		.amdhsa_next_free_vgpr 256
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
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
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 2
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 1
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
