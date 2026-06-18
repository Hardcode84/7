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
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, 0x4000000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, 0x4000000
		s_mov_b32 s23, 0x31016000
		v_readfirstlane_b32 s24, v0
		s_lshr_b32 s25, s13, 3
		v_lshrrev_b32_e32 v1, 6, v0
		s_lshl_b32 s26, s14, 1
		v_and_b32_e32 v2, 63, v0
		s_add_i32 s27, s26, s25
		v_lshrrev_b32_e32 v3, 2, v2
		s_and_b32 s25, s13, 7
		v_lshrrev_b32_e32 v4, 3, v2
		s_lshl_b32 s26, s25, 5
		v_and_b32_e32 v5, 3, v4
		s_add_i32 s25, s27, s26
		v_and_b32_e32 v6, 3, v2
		s_lshr_b32 s26, s25, 6
		v_xor_b32_e32 v7, v5, v6
		s_lshl_b32 s27, s26, 2
		v_lshlrev_b32_e32 v5, 18, v1
		s_and_b32 s26, s25, 63
		v_lshlrev_b32_e32 v6, 14, v3
		s_and_b32 s25, s26, 3
		v_lshlrev_b32_e32 v3, 4, v7
		s_add_i32 s28, s27, s25
		s_lshr_b32 s25, s26, 2
		s_lshl_b32 s26, s28, 21
		s_lshl_b32 s27, s25, 17
		s_add_i32 s29, s26, s27
		s_add_u32 s26, s6, s29
		s_addc_u32 s27, s7, 0
		s_lshr_b32 s29, s24, 6
		s_lshl_b32 s30, s29, 10
		s_mov_b32 m0, s30
		s_lshl_b32 s31, s28, 22
		v_add_u32_e32 v7, s31, v5
		s_add_i32 s32, s30, 0x2000
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s31, 0x200000
		v_add_u32_e32 v7, s32, v5
		s_add_i32 s32, s30, 0x4000
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s31, 64
		v_add_u32_e32 v7, s32, v5
		s_add_i32 s32, s30, 0x6000
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_mov_b32 m0, s32
		s_add_i32 s32, s31, 0x200040
		v_add_u32_e32 v7, s32, v5
		s_add_i32 s32, s30, 0x8000
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_mov_b32 m0, s32
		s_lshl_b32 s32, s25, 22
		v_add_u32_e32 v7, s32, v5
		s_add_i32 s33, s30, 0xa000
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s34, s32, 0x200000
		v_add_u32_e32 v7, s34, v5
		s_mov_b32 m0, s33
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s33, s30, 0xc000
		s_add_i32 s34, s32, 64
		v_add_u32_e32 v7, s34, v5
		s_mov_b32 m0, s33
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s33, s30, 0xe000
		s_add_i32 s34, s32, 0x200040
		v_add_u32_e32 v7, s34, v5
		s_mov_b32 m0, s33
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mov_b32_e32 v7, 1
		s_mov_b32 s33, 0
		v_mov_b32_e32 v8, 39
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s44, s26
		s_mov_b32 s45, s27
		s_mov_b32 s46, 0x20000
		s_mov_b32 s47, 0x31016000
		v_and_b32_e32 v9, v0, v8
		v_and_or_b32 v8, v1, v7, v9
		v_mov_b32_e32 v12, 0
		v_mov_b32_e32 v13, 0
		v_mov_b32_e32 v14, 0
		v_mov_b32_e32 v15, 0
		v_cmp_eq_u32_e64 vcc, v8, s33
		s_mov_b64 s[26:27], vcc
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
		s_lshr_b32 s34, s24, 7
		s_lshl_b32 s35, s34, 9
		s_add_i32 s48, s35, 0x20000
		s_mov_b32 m0, s48
		s_lshl_b32 s48, s28, 8
		s_lshl_b32 s49, s34, 6
		s_add_i32 s34, s48, s49
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s34, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s34, s35, 0x20010
		s_mov_b32 m0, s34
		s_add_i32 s34, s48, 16
		s_add_i32 s50, s34, s49
		v_add_u32_e32 v8, s50, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s34, s35, 0x20020
		s_mov_b32 m0, s34
		s_add_i32 s34, s48, 32
		s_add_i32 s50, s34, s49
		v_add_u32_e32 v8, s50, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s34, s35, 0x20030
		s_mov_b32 m0, s34
		s_add_i32 s34, s48, 48
		s_add_i32 s35, s34, s49
		v_add_u32_e32 v8, s35, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[58:59]
		v_lshrrev_b32_e32 v7, 1, v1
		v_or_b32_e32 v8, v9, v7
		v_cmp_eq_u32_e64 vcc, v8, s33
		s_mov_b64 s[34:35], vcc
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
		s_and_b32 s48, s29, 1
		s_lshl_b32 s49, s48, 10
		s_add_i32 s50, s49, 0x20800
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s25, 8
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s50, v7
		s_lshl_b32 s51, s48, 7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20810
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 16
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20820
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 32
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20830
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 48
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20a00
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 64
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20a10
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x50
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20a20
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x60
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x20a30
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x70
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v7, s51, v8
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
		s_lshr_b32 s48, s24, 7
		s_lshl_b32 s49, s48, 9
		s_add_i32 s50, s49, 0x21000
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s28, 8
		s_add_i32 s51, s50, 0x4000
		s_lshl_b32 s52, s48, 6
		s_add_i32 s48, s51, s52
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s48, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x21010
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4010
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x21020
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4020
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x21030
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4030
		s_add_i32 s49, s48, s52
		v_add_u32_e32 v8, s49, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
		s_and_b32 s48, s29, 1
		s_lshl_b32 s49, s48, 10
		s_add_i32 s50, s49, 0x21800
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s25, 8
		s_add_i32 s51, s50, 0x4000
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s51, v7
		s_lshl_b32 s51, s48, 7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21810
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4010
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21820
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4020
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21830
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4030
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21a00
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4040
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21a10
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4050
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21a20
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4060
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x21a30
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x4070
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v7, s51, v8
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		s_lshr_b32 s48, s24, 7
		s_lshl_b32 s49, s48, 9
		s_add_i32 s50, s49, 0x22000
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s28, 8
		s_add_i32 s51, s50, 0x8000
		s_lshl_b32 s52, s48, 6
		s_add_i32 s48, s51, s52
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s48, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x22010
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8010
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x22020
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8020
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x22030
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8030
		s_add_i32 s49, s48, s52
		v_add_u32_e32 v8, s49, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		s_and_b32 s48, s29, 1
		s_lshl_b32 s49, s48, 10
		s_add_i32 s50, s49, 0x22800
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s25, 8
		s_add_i32 s51, s50, 0x8000
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s51, v7
		s_lshl_b32 s51, s48, 7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22810
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8010
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22820
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8020
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22830
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8030
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22a00
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8040
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22a10
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8050
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22a20
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8060
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x22a30
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x8070
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v7, s51, v8
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
		s_lshr_b32 s48, s24, 7
		s_lshl_b32 s49, s48, 9
		s_add_i32 s50, s49, 0x23000
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s28, 8
		s_add_i32 s51, s50, 0xc000
		s_lshl_b32 s52, s48, 6
		s_add_i32 s48, s51, s52
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s48, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x23010
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc010
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x23020
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc020
		s_add_i32 s51, s48, s52
		v_add_u32_e32 v8, s51, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_add_i32 s48, s49, 0x23030
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc030
		s_add_i32 s49, s48, s52
		v_add_u32_e32 v8, s49, v7
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
		s_and_b32 s48, s29, 1
		s_lshl_b32 s49, s48, 10
		s_add_i32 s50, s49, 0x23800
		s_mov_b32 m0, s50
		s_lshl_b32 s50, s25, 8
		s_add_i32 s51, s50, 0xc000
		v_lshlrev_b32_e32 v7, 12, v4
		v_add_u32_e32 v8, s51, v7
		s_lshl_b32 s51, s48, 7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23810
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc010
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23820
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc020
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23830
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc030
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23a00
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc040
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23a10
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc050
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23a20
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc060
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v9, s51, v8
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_add_i32 s48, s49, 0x23a30
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0xc070
		v_add_u32_e32 v8, s48, v7
		v_add_u32_e32 v7, s51, v8
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s48, s30, 0x10000
		s_mov_b32 m0, s48
		s_add_i32 s48, s31, 0x80
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s48, s30, 0x12000
		s_mov_b32 m0, s48
		s_add_i32 s48, s31, 0x200080
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s48, s30, 0x14000
		s_mov_b32 m0, s48
		s_add_i32 s48, s31, 0xc0
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s48, s30, 0x16000
		s_mov_b32 m0, s48
		s_add_i32 s48, s31, 0x2000c0
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[16:19], 0 offen lds
		s_add_i32 s48, s30, 0x18000
		s_mov_b32 m0, s48
		s_add_i32 s48, s32, 0x80
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s48, s30, 0x1a000
		s_mov_b32 m0, s48
		s_add_i32 s48, s32, 0x200080
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s48, s30, 0x1c000
		s_mov_b32 m0, s48
		s_add_i32 s48, s32, 0xc0
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s48, s30, 0x1e000
		s_mov_b32 m0, s48
		s_add_i32 s48, s32, 0x2000c0
		v_add_u32_e32 v7, s48, v5
		v_add3_u32 v8, v7, v6, v3
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_waitcnt vmcnt(56)
		s_barrier
		v_and_b32_e32 v7, 15, v0
		v_lshrrev_b32_e32 v8, 1, v7
		v_lshrrev_b32_e32 v9, 4, v2
		v_and_b32_e32 v10, 3, v8
		v_lshrrev_b32_e32 v8, 7, v0
		v_xor_b32_e32 v11, v9, v10
		v_and_b32_e32 v9, 1, v1
		v_lshlrev_b32_e32 v10, 6, v7
		v_lshlrev_b32_e32 v7, 4, v11
		v_lshlrev_b32_e32 v11, 12, v8
		v_lshlrev_b32_e32 v16, 13, v9
		v_add3_u32 v17, v11, v10, v7
		v_add3_u32 v18, v10, v16, v7
		v_lshlrev_b32_e32 v19, 9, v8
		ds_read_b128 v[20:23], v17
		ds_read_b128 v[24:27], v17 offset:1024
		ds_read_b128 v[28:31], v17 offset:2048
		ds_read_b128 v[32:35], v17 offset:3072
		ds_read_b128 v[36:39], v17 offset:16384
		ds_read_b128 v[40:43], v17 offset:17408
		ds_read_b128 v[44:47], v17 offset:18432
		ds_read_b128 v[48:51], v17 offset:19456
		ds_read_b128 v[52:55], v18 offset:32768
		ds_read_b128 v[56:59], v18 offset:33792
		ds_read_b128 v[60:63], v18 offset:34816
		ds_read_b128 v[64:67], v18 offset:35840
		ds_read_b128 v[68:71], v18 offset:36864
		ds_read_b128 v[72:75], v18 offset:37888
		ds_read_b128 v[76:79], v18 offset:38912
		ds_read_b128 v[80:83], v18 offset:39936
		ds_read_b128 v[84:87], v18 offset:49152
		ds_read_b128 v[88:91], v18 offset:50176
		ds_read_b128 v[92:95], v18 offset:51200
		ds_read_b128 v[96:99], v18 offset:52224
		ds_read_b128 v[100:103], v18 offset:53248
		ds_read_b128 v[104:107], v18 offset:54272
		ds_read_b128 v[108:111], v18 offset:55296
		ds_read_b128 v[112:115], v18 offset:56320
		v_add_u32_e32 v17, 0x20000, v19
		v_lshlrev_b32_e32 v18, 3, v2
		v_lshlrev_b32_e32 v116, 10, v9
		v_mov_b32_e32 v120, 0
		v_mov_b32_e32 v121, 0
		v_mov_b32_e32 v122, 0
		v_mov_b32_e32 v123, 0
		v_mov_b32_e32 v124, 0
		v_mov_b32_e32 v125, 0
		v_mov_b32_e32 v126, 0
		v_mov_b32_e32 v127, 0
		v_mov_b32_e32 v128, 0
		v_mov_b32_e32 v129, 0
		v_mov_b32_e32 v130, 0
		v_mov_b32_e32 v131, 0
		v_mov_b32_e32 v132, 0
		v_mov_b32_e32 v133, 0
		v_mov_b32_e32 v134, 0
		v_mov_b32_e32 v135, 0
		v_mov_b32_e32 v136, 0
		v_mov_b32_e32 v137, 0
		v_mov_b32_e32 v138, 0
		v_mov_b32_e32 v139, 0
		v_mov_b32_e32 v140, 0
		v_mov_b32_e32 v141, 0
		v_mov_b32_e32 v142, 0
		v_mov_b32_e32 v143, 0
		v_mov_b32_e32 v144, 0
		v_mov_b32_e32 v145, 0
		v_mov_b32_e32 v146, 0
		v_mov_b32_e32 v147, 0
		v_mov_b32_e32 v148, 0
		v_mov_b32_e32 v149, 0
		v_mov_b32_e32 v150, 0
		v_mov_b32_e32 v151, 0
		v_mov_b32_e32 v152, 0
		v_mov_b32_e32 v153, 0
		v_mov_b32_e32 v154, 0
		v_mov_b32_e32 v155, 0
		v_mov_b32_e32 v156, 0
		v_mov_b32_e32 v157, 0
		v_mov_b32_e32 v158, 0
		v_mov_b32_e32 v159, 0
		v_mov_b32_e32 v160, 0
		v_mov_b32_e32 v161, 0
		v_mov_b32_e32 v162, 0
		v_mov_b32_e32 v163, 0
		v_mov_b32_e32 v164, 0
		v_mov_b32_e32 v165, 0
		v_mov_b32_e32 v166, 0
		v_mov_b32_e32 v167, 0
		v_mov_b32_e32 v168, 0
		v_mov_b32_e32 v169, 0
		v_mov_b32_e32 v170, 0
		v_mov_b32_e32 v171, 0
		v_mov_b32_e32 v172, 0
		v_mov_b32_e32 v173, 0
		v_mov_b32_e32 v174, 0
		v_mov_b32_e32 v175, 0
		v_mov_b32_e32 v176, 0
		v_mov_b32_e32 v177, 0
		v_mov_b32_e32 v178, 0
		v_mov_b32_e32 v179, 0
		v_mov_b32_e32 v180, 0
		v_mov_b32_e32 v181, 0
		v_mov_b32_e32 v182, 0
		v_mov_b32_e32 v183, 0
		v_mov_b32_e32 v184, 0
		v_mov_b32_e32 v185, 0
		v_mov_b32_e32 v186, 0
		v_mov_b32_e32 v187, 0
		v_mov_b32_e32 v188, 0
		v_mov_b32_e32 v189, 0
		v_mov_b32_e32 v190, 0
		v_mov_b32_e32 v191, 0
		v_mov_b32_e32 v192, 0
		v_mov_b32_e32 v193, 0
		v_mov_b32_e32 v194, 0
		v_mov_b32_e32 v195, 0
		v_mov_b32_e32 v196, 0
		v_mov_b32_e32 v197, 0
		v_mov_b32_e32 v198, 0
		v_mov_b32_e32 v199, 0
		v_mov_b32_e32 v200, 0
		v_mov_b32_e32 v201, 0
		v_mov_b32_e32 v202, 0
		v_mov_b32_e32 v203, 0
		v_mov_b32_e32 v204, 0
		v_mov_b32_e32 v205, 0
		v_mov_b32_e32 v206, 0
		v_mov_b32_e32 v207, 0
		v_mov_b32_e32 v208, 0
		v_mov_b32_e32 v209, 0
		v_mov_b32_e32 v210, 0
		v_mov_b32_e32 v211, 0
		v_mov_b32_e32 v212, 0
		v_mov_b32_e32 v213, 0
		v_mov_b32_e32 v214, 0
		v_mov_b32_e32 v215, 0
		v_mov_b32_e32 v216, 0
		v_mov_b32_e32 v217, 0
		v_mov_b32_e32 v218, 0
		v_mov_b32_e32 v219, 0
		v_mov_b32_e32 v220, 0
		v_mov_b32_e32 v221, 0
		v_mov_b32_e32 v222, 0
		v_mov_b32_e32 v223, 0
		v_mov_b32_e32 v224, 0
		v_mov_b32_e32 v225, 0
		v_mov_b32_e32 v226, 0
		v_mov_b32_e32 v227, 0
		v_mov_b32_e32 v228, 0
		v_mov_b32_e32 v229, 0
		v_mov_b32_e32 v230, 0
		v_mov_b32_e32 v231, 0
		v_mov_b32_e32 v232, 0
		v_mov_b32_e32 v233, 0
		v_mov_b32_e32 v234, 0
		v_mov_b32_e32 v235, 0
		v_mov_b32_e32 v236, 0
		v_mov_b32_e32 v237, 0
		v_mov_b32_e32 v238, 0
		v_mov_b32_e32 v239, 0
		v_mov_b32_e32 v240, 0
		v_mov_b32_e32 v241, 0
		v_mov_b32_e32 v242, 0
		v_mov_b32_e32 v243, 0
		v_add_u32_e32 v117, 0x21000, v19
		s_cmp_lt_i32 0, 0x7e
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s48, s33, 2
		s_mul_i32 s49, s48, 0x80
		s_lshl_b32 s50, s49, 0
		s_add_i32 s49, s33, 1
		s_waitcnt vmcnt(32)
		s_barrier
		s_and_b32 s51, s33, 1
		s_lshl_b32 s52, s51, 13
		v_add3_u32 v19, v17, s52, v18
		ds_read_b64_tr_b8 v[118:119], v19
		s_add_i32 s51, s52, 0x20800
		v_add3_u32 v19, s51, v18, v116
		ds_read_b64_tr_b8 v[244:245], v19
		s_add_i32 s51, s52, 0x20a00
		v_add3_u32 v19, s51, v18, v116
		ds_read_b64_tr_b8 v[246:247], v19
		v_add3_u32 v19, v117, s52, v18
		ds_read_b64_tr_b8 v[248:249], v19
		s_add_i32 s51, s52, 0x21800
		v_add3_u32 v19, s51, v18, v116
		ds_read_b64_tr_b8 v[250:251], v19
		s_add_i32 s51, s52, 0x21a00
		v_add3_u32 v19, s51, v18, v116
		ds_read_b64_tr_b8 v[252:253], v19
		s_waitcnt lgkmcnt(4)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v118, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v118, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v118, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v118, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v118, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v118, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v118, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v118, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v118, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v118, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v118, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v118, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v118, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v118, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v118, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v118, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		s_mul_i32 s51, s48, 2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v248, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v248, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v248, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		s_lshr_b32 s52, s24, 7
		s_lshl_b32 s53, s52, 9
		s_and_b32 s54, s48, 1
		s_lshl_b32 s55, s54, 13
		s_add_i32 s54, s53, s55
		s_add_i32 s53, s54, 0x20000
		s_mov_b32 m0, s53
		s_lshl_b32 s53, s51, 14
		s_lshl_b32 s55, s28, 8
		s_add_i32 s56, s53, s55
		s_lshl_b32 s57, s52, 6
		s_add_i32 s52, s56, s57
		v_lshlrev_b32_e32 v19, 12, v4
		v_add_u32_e32 v119, s52, v19
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s52, s54, 0x20010
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 16
		s_add_i32 s56, s52, s55
		s_add_i32 s52, s56, s57
		v_add_u32_e32 v119, s52, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s52, s54, 0x20020
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 32
		s_add_i32 s56, s52, s55
		s_add_i32 s52, s56, s57
		v_add_u32_e32 v119, s52, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s52, s54, 0x20030
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 48
		s_add_i32 s53, s52, s55
		s_add_i32 s52, s53, s57
		v_add_u32_e32 v119, s52, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		s_and_b32 s52, s48, 1
		s_lshl_b32 s53, s52, 13
		s_and_b32 s52, s29, 1
		s_lshl_b32 s54, s52, 10
		s_add_i32 s55, s53, s54
		s_add_i32 s53, s55, 0x20800
		s_mov_b32 m0, s53
		s_lshl_b32 s53, s51, 14
		s_lshl_b32 s54, s25, 8
		s_add_i32 s56, s53, s54
		v_lshlrev_b32_e32 v19, 12, v4
		v_add_u32_e32 v119, s56, v19
		s_lshl_b32 s56, s52, 7
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20810
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 16
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20820
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 32
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20830
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 48
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20a00
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 64
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20a10
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 0x50
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20a20
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 0x60
		s_add_i32 s57, s52, s54
		v_add_u32_e32 v119, s57, v19
		v_add_u32_e32 v244, s56, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s52, s55, 0x20a30
		s_mov_b32 m0, s52
		s_add_i32 s52, s53, 0x70
		s_add_i32 s53, s52, s54
		v_add_u32_e32 v119, s53, v19
		v_add_u32_e32 v19, s56, v119
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s52, s51, 1
		s_and_saveexec_b64 s[58:59], s[26:27]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
		s_lshr_b32 s51, s24, 7
		s_lshl_b32 s53, s51, 9
		s_and_b32 s54, s48, 1
		s_lshl_b32 s55, s54, 13
		s_add_i32 s54, s53, s55
		s_add_i32 s53, s54, 0x21000
		s_mov_b32 m0, s53
		s_lshl_b32 s53, s52, 14
		s_lshl_b32 s55, s28, 8
		s_add_i32 s56, s53, s55
		s_lshl_b32 s57, s51, 6
		s_add_i32 s51, s56, s57
		v_lshlrev_b32_e32 v19, 12, v4
		v_add_u32_e32 v119, s51, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s51, s54, 0x21010
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 16
		s_add_i32 s56, s51, s55
		s_add_i32 s51, s56, s57
		v_add_u32_e32 v119, s51, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s51, s54, 0x21020
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 32
		s_add_i32 s56, s51, s55
		s_add_i32 s51, s56, s57
		v_add_u32_e32 v119, s51, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
		s_add_i32 s51, s54, 0x21030
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 48
		s_add_i32 s53, s51, s55
		s_add_i32 s51, s53, s57
		v_add_u32_e32 v119, s51, v19
		buffer_load_dwordx4 v119, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
		s_and_b32 s51, s48, 1
		s_lshl_b32 s53, s51, 13
		s_and_b32 s51, s29, 1
		s_lshl_b32 s54, s51, 10
		s_add_i32 s55, s53, s54
		s_add_i32 s53, s55, 0x21800
		s_mov_b32 m0, s53
		s_lshl_b32 s53, s52, 14
		s_lshl_b32 s52, s25, 8
		s_add_i32 s54, s53, s52
		v_lshlrev_b32_e32 v19, 12, v4
		v_add_u32_e32 v119, s54, v19
		s_lshl_b32 s54, s51, 7
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21810
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 16
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21820
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 32
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21830
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 48
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21a00
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 64
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21a10
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 0x50
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21a20
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 0x60
		s_add_i32 s56, s51, s52
		v_add_u32_e32 v119, s56, v19
		v_add_u32_e32 v244, s54, v119
		buffer_load_dwordx4 v244, s[36:39], 0 offen lds
		s_add_i32 s51, s55, 0x21a30
		s_mov_b32 m0, s51
		s_add_i32 s51, s53, 0x70
		s_add_i32 s53, s51, s52
		v_add_u32_e32 v119, s53, v19
		v_add_u32_e32 v19, s54, v119
		buffer_load_dwordx4 v19, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[58:59]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v118, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v118, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v118, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v118, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s51, s48, 1
		s_lshl_b32 s48, s51, 16
		s_add_i32 s51, s30, s48
		s_mov_b32 m0, s51
		s_add_i32 s48, s50, s31
		v_add_u32_e32 v19, s48, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[16:19], 0 offen lds
		s_add_i32 s48, s51, 0x2000
		s_mov_b32 m0, s48
		s_add_i32 s48, s50, 0x200000
		s_add_i32 s52, s48, s31
		v_add_u32_e32 v19, s52, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[16:19], 0 offen lds
		s_add_i32 s52, s51, 0x4000
		s_mov_b32 m0, s52
		s_add_i32 s52, s50, 64
		s_add_i32 s53, s52, s31
		v_add_u32_e32 v19, s53, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[16:19], 0 offen lds
		s_add_i32 s53, s51, 0x6000
		s_mov_b32 m0, s53
		s_add_i32 s53, s50, 0x200040
		s_add_i32 s54, s53, s31
		v_add_u32_e32 v19, s54, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[16:19], 0 offen lds
		s_add_i32 s54, s51, 0x8000
		s_mov_b32 m0, s54
		s_add_i32 s54, s50, s32
		v_add_u32_e32 v19, s54, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		s_add_i32 s50, s51, 0xa000
		s_mov_b32 m0, s50
		s_add_i32 s50, s48, s32
		v_add_u32_e32 v19, s50, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		s_add_i32 s48, s51, 0xc000
		s_mov_b32 m0, s48
		s_add_i32 s48, s52, s32
		v_add_u32_e32 v19, s48, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		s_add_i32 s48, s51, 0xe000
		s_mov_b32 m0, s48
		s_add_i32 s48, s53, s32
		v_add_u32_e32 v19, s48, v5
		v_add3_u32 v118, v19, v6, v3
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(32)
		s_barrier
		s_and_b32 s48, s49, 1
		s_lshl_b32 s50, s48, 16
		v_add_u32_e32 v19, s50, v11
		v_add3_u32 v118, v19, v10, v7
		ds_read_b128 v[20:23], v118
		ds_read_b128 v[24:27], v118 offset:1024
		ds_read_b128 v[28:31], v118 offset:2048
		ds_read_b128 v[32:35], v118 offset:3072
		ds_read_b128 v[36:39], v118 offset:16384
		ds_read_b128 v[40:43], v118 offset:17408
		ds_read_b128 v[44:47], v118 offset:18432
		ds_read_b128 v[48:51], v118 offset:19456
		v_add_u32_e32 v19, s50, v10
		v_add3_u32 v118, v19, v16, v7
		ds_read_b128 v[52:55], v118 offset:32768
		ds_read_b128 v[56:59], v118 offset:33792
		ds_read_b128 v[60:63], v118 offset:34816
		ds_read_b128 v[64:67], v118 offset:35840
		ds_read_b128 v[68:71], v118 offset:36864
		ds_read_b128 v[72:75], v118 offset:37888
		ds_read_b128 v[76:79], v118 offset:38912
		ds_read_b128 v[80:83], v118 offset:39936
		ds_read_b128 v[84:87], v118 offset:49152
		ds_read_b128 v[88:91], v118 offset:50176
		ds_read_b128 v[92:95], v118 offset:51200
		ds_read_b128 v[96:99], v118 offset:52224
		ds_read_b128 v[100:103], v118 offset:53248
		ds_read_b128 v[104:107], v118 offset:54272
		ds_read_b128 v[108:111], v118 offset:55296
		ds_read_b128 v[112:115], v118 offset:56320
		s_cmp_lt_i32 s49, 0x7e
		s_mov_b32 s33, s49
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(32)
		s_barrier
		v_lshlrev_b32_e32 v3, 9, v8
		v_add_u32_e32 v4, 0x20000, v3
		v_lshlrev_b32_e32 v5, 3, v2
		v_add_u32_e32 v6, v4, v5
		ds_read_b64_tr_b8 v[18:19], v6
		v_add_u32_e32 v4, 0x20800, v5
		v_lshlrev_b32_e32 v6, 10, v9
		v_add_u32_e32 v8, v4, v6
		ds_read_b64_tr_b8 v[116:117], v8
		v_add_u32_e32 v4, 0x20a00, v5
		v_add_u32_e32 v8, v4, v6
		ds_read_b64_tr_b8 v[118:119], v8
		v_add_u32_e32 v4, 0x21000, v3
		v_add_u32_e32 v8, v4, v5
		ds_read_b64_tr_b8 v[244:245], v8
		v_add_u32_e32 v4, 0x21800, v5
		v_add_u32_e32 v8, v4, v6
		ds_read_b64_tr_b8 v[246:247], v8
		v_add_u32_e32 v4, 0x21a00, v5
		v_add_u32_e32 v8, v4, v6
		ds_read_b64_tr_b8 v[248:249], v8
		s_waitcnt lgkmcnt(4)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v18, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v18, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v18, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v18, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v18, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v18, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v18, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v18, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v18, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v18, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v18, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v18, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v18, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v18, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v18, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v18, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v18, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v18, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v18, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v18, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v18, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v18, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v18, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v18, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v18, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v18, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v18, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v18, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v18, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v18, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v18, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v18, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v4, 0x10000, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[20:23], v8
		v_add_u32_e32 v4, 0x10400, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[24:27], v8
		v_add_u32_e32 v4, 0x10800, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[28:31], v8
		v_add_u32_e32 v4, 0x10c00, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[32:35], v8
		v_add_u32_e32 v4, 0x14000, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[36:39], v8
		v_add_u32_e32 v4, 0x14400, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[40:43], v8
		v_add_u32_e32 v4, 0x14800, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[44:47], v8
		v_add_u32_e32 v4, 0x14c00, v11
		v_add3_u32 v8, v4, v10, v7
		ds_read_b128 v[48:51], v8
		v_add_u32_e32 v4, 0x18000, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[52:55], v8
		v_add_u32_e32 v4, 0x18400, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[56:59], v8
		v_add_u32_e32 v4, 0x18800, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[60:63], v8
		v_add_u32_e32 v4, 0x18c00, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[64:67], v8
		v_add_u32_e32 v4, 0x19000, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[68:71], v8
		v_add_u32_e32 v4, 0x19400, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[72:75], v8
		v_add_u32_e32 v4, 0x19800, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[76:79], v8
		v_add_u32_e32 v4, 0x19c00, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[80:83], v8
		v_add_u32_e32 v4, 0x1c000, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[84:87], v8
		v_add_u32_e32 v4, 0x1c400, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[88:91], v8
		v_add_u32_e32 v4, 0x1c800, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[92:95], v8
		v_add_u32_e32 v4, 0x1cc00, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[96:99], v8
		v_add_u32_e32 v4, 0x1d000, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[100:103], v8
		v_add_u32_e32 v4, 0x1d400, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[104:107], v8
		v_add_u32_e32 v4, 0x1d800, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[108:111], v8
		v_add_u32_e32 v4, 0x1dc00, v10
		v_add3_u32 v8, v4, v16, v7
		ds_read_b128 v[16:19], v8
		s_barrier
		v_add_u32_e32 v4, 0x22000, v3
		v_add_u32_e32 v7, v4, v5
		ds_read_b64_tr_b8 v[8:9], v7
		v_add_u32_e32 v4, 0x22800, v5
		v_add_u32_e32 v7, v4, v6
		ds_read_b64_tr_b8 v[10:11], v7
		v_add_u32_e32 v4, 0x22a00, v5
		v_add_u32_e32 v7, v4, v6
		ds_read_b64_tr_b8 v[112:113], v7
		v_add_u32_e32 v4, 0x23000, v3
		v_add_u32_e32 v3, v4, v5
		ds_read_b64_tr_b8 v[114:115], v3
		v_add_u32_e32 v3, 0x23800, v5
		v_add_u32_e32 v4, v3, v6
		ds_read_b64_tr_b8 v[116:117], v4
		v_add_u32_e32 v3, 0x23a00, v5
		v_add_u32_e32 v4, v3, v6
		ds_read_b64_tr_b8 v[6:7], v4
		s_waitcnt lgkmcnt(4)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v8, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v8, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v114, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v114, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v114, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v114, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v114, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v114, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v114, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v114, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v114, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v114, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v114, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v114, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v114, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v114, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v114, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v114, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_nop 0
		v_lshlrev_b32_e32 v3, 2, v2
		v_cvt_f16_f32_e64 v2, v12
		v_cvt_f16_f32_e64 v4, v13
		v_cvt_f16_f32_e64 v5, v14
		v_cvt_f16_f32_e64 v9, v15
		v_and_b32_e32 v10, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v4, 16, v2
		v_or_b32_e32 v12, v10, v4
		v_and_b32_e32 v2, 0xffff, v5
		v_and_b32_e32 v4, 0xffff, v9
		v_lshlrev_b32_e32 v5, 16, v4
		v_or_b32_e32 v13, v2, v5
		v_lshlrev_b32_e32 v2, 14, v1
		v_lshl_add_u32 v1, v3, 1, v2
		buffer_store_dwordx2 v[12:13], v1, s[44:47], 0 offen
		v_cvt_f16_f32_e64 v2, v120
		v_cvt_f16_f32_e64 v3, v121
		v_cvt_f16_f32_e64 v4, v122
		v_cvt_f16_f32_e64 v5, v123
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:512
		v_cvt_f16_f32_e64 v2, v124
		v_cvt_f16_f32_e64 v3, v125
		v_cvt_f16_f32_e64 v4, v126
		v_cvt_f16_f32_e64 v5, v127
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:1024
		v_cvt_f16_f32_e64 v2, v128
		v_cvt_f16_f32_e64 v3, v129
		v_cvt_f16_f32_e64 v4, v130
		v_cvt_f16_f32_e64 v5, v131
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:1536
		v_cvt_f16_f32_e64 v2, v148
		v_cvt_f16_f32_e64 v3, v149
		v_cvt_f16_f32_e64 v4, v150
		v_cvt_f16_f32_e64 v5, v151
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x1000
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v152
		v_cvt_f16_f32_e64 v3, v153
		v_cvt_f16_f32_e64 v4, v154
		v_cvt_f16_f32_e64 v5, v155
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x1200
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v156
		v_cvt_f16_f32_e64 v3, v157
		v_cvt_f16_f32_e64 v4, v158
		v_cvt_f16_f32_e64 v5, v159
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x1400
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v160
		v_cvt_f16_f32_e64 v3, v161
		v_cvt_f16_f32_e64 v4, v162
		v_cvt_f16_f32_e64 v5, v163
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x1600
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v180
		v_cvt_f16_f32_e64 v3, v181
		v_cvt_f16_f32_e64 v4, v182
		v_cvt_f16_f32_e64 v5, v183
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x2000
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v184
		v_cvt_f16_f32_e64 v3, v185
		v_cvt_f16_f32_e64 v4, v186
		v_cvt_f16_f32_e64 v5, v187
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x2200
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v188
		v_cvt_f16_f32_e64 v3, v189
		v_cvt_f16_f32_e64 v4, v190
		v_cvt_f16_f32_e64 v5, v191
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x2400
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v192
		v_cvt_f16_f32_e64 v3, v193
		v_cvt_f16_f32_e64 v4, v194
		v_cvt_f16_f32_e64 v5, v195
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x2600
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v212
		v_cvt_f16_f32_e64 v3, v213
		v_cvt_f16_f32_e64 v4, v214
		v_cvt_f16_f32_e64 v5, v215
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x3000
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v216
		v_cvt_f16_f32_e64 v3, v217
		v_cvt_f16_f32_e64 v4, v218
		v_cvt_f16_f32_e64 v5, v219
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x3200
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v220
		v_cvt_f16_f32_e64 v3, v221
		v_cvt_f16_f32_e64 v4, v222
		v_cvt_f16_f32_e64 v5, v223
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x3400
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v224
		v_cvt_f16_f32_e64 v3, v225
		v_cvt_f16_f32_e64 v4, v226
		v_cvt_f16_f32_e64 v5, v227
		v_and_b32_e32 v9, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v9, v3
		v_and_b32_e32 v9, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v9, v4
		s_mov_b32 s16, 0x3600
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v8, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v8, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v8, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v8, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v8, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v8, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v8, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v8, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v8, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v8, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v8, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v8, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v8, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v8, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v8, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v8, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v114, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v114, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v114, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[16:19], v[144:147], v114, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v114, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v114, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v114, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[16:19], v[176:179], v114, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v114, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v114, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v114, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[16:19], v[208:211], v114, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v114, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v114, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v114, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[16:19], v[240:243], v114, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v2, v132
		v_cvt_f16_f32_e64 v3, v133
		v_cvt_f16_f32_e64 v4, v134
		v_cvt_f16_f32_e64 v5, v135
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:2048
		v_cvt_f16_f32_e64 v2, v136
		v_cvt_f16_f32_e64 v3, v137
		v_cvt_f16_f32_e64 v4, v138
		v_cvt_f16_f32_e64 v5, v139
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:2560
		v_cvt_f16_f32_e64 v2, v140
		v_cvt_f16_f32_e64 v3, v141
		v_cvt_f16_f32_e64 v4, v142
		v_cvt_f16_f32_e64 v5, v143
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:3072
		v_cvt_f16_f32_e64 v2, v144
		v_cvt_f16_f32_e64 v3, v145
		v_cvt_f16_f32_e64 v4, v146
		v_cvt_f16_f32_e64 v5, v147
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		buffer_store_dwordx2 v[2:3], v1, s[44:47], 0 offen offset:3584
		v_cvt_f16_f32_e64 v2, v164
		v_cvt_f16_f32_e64 v3, v165
		v_cvt_f16_f32_e64 v4, v166
		v_cvt_f16_f32_e64 v5, v167
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x1800
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v168
		v_cvt_f16_f32_e64 v3, v169
		v_cvt_f16_f32_e64 v4, v170
		v_cvt_f16_f32_e64 v5, v171
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x1a00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v172
		v_cvt_f16_f32_e64 v3, v173
		v_cvt_f16_f32_e64 v4, v174
		v_cvt_f16_f32_e64 v5, v175
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x1c00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v176
		v_cvt_f16_f32_e64 v3, v177
		v_cvt_f16_f32_e64 v4, v178
		v_cvt_f16_f32_e64 v5, v179
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x1e00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v196
		v_cvt_f16_f32_e64 v3, v197
		v_cvt_f16_f32_e64 v4, v198
		v_cvt_f16_f32_e64 v5, v199
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x2800
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v200
		v_cvt_f16_f32_e64 v3, v201
		v_cvt_f16_f32_e64 v4, v202
		v_cvt_f16_f32_e64 v5, v203
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x2a00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v204
		v_cvt_f16_f32_e64 v3, v205
		v_cvt_f16_f32_e64 v4, v206
		v_cvt_f16_f32_e64 v5, v207
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x2c00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v208
		v_cvt_f16_f32_e64 v3, v209
		v_cvt_f16_f32_e64 v4, v210
		v_cvt_f16_f32_e64 v5, v211
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x2e00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v228
		v_cvt_f16_f32_e64 v3, v229
		v_cvt_f16_f32_e64 v4, v230
		v_cvt_f16_f32_e64 v5, v231
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x3800
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v232
		v_cvt_f16_f32_e64 v3, v233
		v_cvt_f16_f32_e64 v4, v234
		v_cvt_f16_f32_e64 v5, v235
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x3a00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v236
		v_cvt_f16_f32_e64 v3, v237
		v_cvt_f16_f32_e64 v4, v238
		v_cvt_f16_f32_e64 v5, v239
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x3c00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
		v_cvt_f16_f32_e64 v2, v240
		v_cvt_f16_f32_e64 v3, v241
		v_cvt_f16_f32_e64 v4, v242
		v_cvt_f16_f32_e64 v5, v243
		v_and_b32_e32 v6, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v6, v3
		v_and_b32_e32 v6, 0xffff, v4
		v_and_b32_e32 v3, 0xffff, v5
		v_lshlrev_b32_e32 v4, 16, v3
		v_or_b32_e32 v3, v6, v4
		s_mov_b32 s16, 0x3e00
		buffer_store_dwordx2 v[2:3], v1, s[44:47], s16 offen
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
		.amdhsa_next_free_vgpr 254
		.amdhsa_next_free_sgpr 60
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 60
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
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     254
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
