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
		s_mov_b32 s18, 0x1000000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, 0x1000000
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
		s_lshl_b32 s27, s26, 23
		v_lshlrev_b32_e32 v5, 16, v1
		s_and_b32 s28, s25, 63
		v_lshlrev_b32_e32 v6, 12, v3
		s_lshr_b32 s25, s28, 2
		v_add_u32_e32 v3, v5, v6
		s_lshl_b32 s29, s25, 17
		v_lshlrev_b32_e32 v8, 4, v7
		s_add_i32 s30, s27, s29
		v_add_u32_e32 v7, 0x80000, v5
		s_and_b32 s27, s28, 3
		v_add_u32_e32 v9, v7, v6
		s_lshl_b32 s28, s27, 21
		s_add_i32 s29, s30, s28
		s_add_u32 s30, s6, s29
		s_addc_u32 s31, s7, 0
		s_lshr_b32 s28, s24, 6
		s_lshl_b32 s29, s28, 10
		s_mov_b32 m0, s29
		s_lshl_b32 s32, s26, 22
		v_add3_u32 v7, s32, v5, v6
		s_lshl_b32 s33, s27, 20
		v_add3_u32 v10, v7, s33, v8
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_add_i32 s34, s29, 0x2000
		s_mov_b32 m0, s34
		s_add_i32 s34, s32, 0x80000
		v_add3_u32 v7, s34, v5, v6
		s_add_i32 s34, s29, 0x4000
		v_add3_u32 v10, v7, s33, v8
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_mov_b32 m0, s34
		s_add_i32 s34, s32, 64
		v_add3_u32 v7, s34, v5, v6
		s_add_i32 s34, s29, 0x6000
		v_add3_u32 v10, v7, s33, v8
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_mov_b32 m0, s34
		s_add_i32 s34, s32, 0x80040
		v_add3_u32 v7, s34, v5, v6
		s_add_i32 s34, s29, 0x8000
		v_add3_u32 v10, v7, s33, v8
		buffer_load_dwordx4 v10, s[16:19], 0 offen lds
		s_mov_b32 m0, s34
		s_lshl_b32 s34, s25, 20
		v_add3_u32 v7, v3, s34, v8
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v3, v9, s34, v8
		s_add_i32 s35, s29, 0xa000
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, 64, v5, v6
		v_add3_u32 v7, v3, s34, v8
		s_add_i32 s35, s29, 0xc000
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add_u32_e32 v3, 0x80040, v5
		v_add_u32_e32 v7, v3, v6
		s_add_i32 s35, s29, 0xe000
		v_add3_u32 v3, v7, s34, v8
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_lshr_b32 s35, s24, 7
		v_mov_b32_e32 v3, 1
		s_lshl_b32 s24, s35, 9
		v_mov_b32_e32 v7, 39
		s_add_i32 s36, s24, 0x20000
		v_and_b32_e32 v9, v0, v7
		s_lshl_b32 s37, s26, 10
		v_lshlrev_b32_e32 v7, 12, v4
		s_lshl_b32 s26, s35, 6
		v_and_or_b32 v4, v1, v3, v9
		s_add_i32 s35, s37, s26
		v_add_u32_e32 v3, s35, v7
		s_lshl_b32 s35, s27, 8
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 s27, s24, 0x20010
		v_add_u32_e32 v10, s35, v3
		s_add_i32 s38, s37, 16
		s_mov_b32 s40, s10
		s_mov_b32 s41, s11
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s44, s8
		s_mov_b32 s45, s9
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s48, s30
		s_mov_b32 s49, s31
		s_mov_b32 s50, 0x20000
		s_mov_b32 s51, 0x31016000
		s_add_i32 s30, s38, s26
		v_add_u32_e32 v3, s30, v7
		s_add_i32 s30, s24, 0x20020
		v_add_u32_e32 v11, s35, v3
		s_add_i32 s31, s37, 32
		s_add_i32 s38, s31, s26
		v_add_u32_e32 v3, s38, v7
		s_add_i32 s31, s24, 0x20030
		v_add_u32_e32 v16, s35, v3
		s_add_i32 s38, s37, 48
		s_add_i32 s39, s38, s26
		v_add_u32_e32 v3, s39, v7
		s_mov_b32 s38, 0
		v_cmp_eq_u32_e64 vcc, v4, s38
		s_mov_b64 s[52:53], vcc
		v_add_u32_e32 v4, s35, v3
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[68:69]
		v_lshrrev_b32_e32 v3, 1, v1
		s_and_b32 s27, s28, 1
		v_add_u32_e32 v4, 0x50, v7
		v_add_u32_e32 v10, 0x60, v7
		v_add_u32_e32 v11, 0x70, v7
		s_lshl_b32 s28, s27, 10
		s_add_i32 s30, s28, 0x20800
		s_lshl_b32 s31, s25, 8
		v_or_b32_e32 v16, v9, v3
		v_add_u32_e32 v3, s31, v7
		v_add3_u32 v9, 16, v7, s31
		v_add3_u32 v17, 32, v7, s31
		v_add3_u32 v18, 48, v7, s31
		v_add3_u32 v19, 64, v7, s31
		v_add_u32_e32 v20, s31, v4
		v_add_u32_e32 v4, s31, v10
		v_add_u32_e32 v10, s31, v11
		s_lshl_b32 s25, s27, 7
		s_add_i32 s27, s28, 0x20810
		s_add_i32 s36, s28, 0x20820
		s_add_i32 s39, s28, 0x20830
		v_cmp_eq_u32_e64 vcc, v16, s38
		s_mov_b64 s[54:55], vcc
		v_add_u32_e32 v11, s25, v3
		v_add_u32_e32 v3, s25, v9
		v_add_u32_e32 v9, s25, v17
		v_add_u32_e32 v16, s25, v18
		v_add_u32_e32 v17, s25, v19
		v_add_u32_e32 v18, s25, v20
		v_add_u32_e32 v19, s25, v4
		v_add_u32_e32 v4, s25, v10
		s_add_i32 s56, s28, 0x20a00
		s_add_i32 s57, s28, 0x20a10
		s_add_i32 s58, s28, 0x20a20
		s_add_i32 s59, s28, 0x20a30
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v17, s[40:43], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s24, 0x21000
		s_add_i32 s30, s37, 0x4000
		s_add_i32 s36, s30, s26
		v_add_u32_e32 v3, s36, v7
		v_add_u32_e32 v4, s35, v3
		s_add_i32 s30, s24, 0x21010
		s_add_i32 s36, s37, 0x4010
		s_add_i32 s39, s36, s26
		v_add_u32_e32 v3, s39, v7
		v_add_u32_e32 v9, s35, v3
		s_add_i32 s36, s24, 0x21020
		s_add_i32 s39, s37, 0x4020
		s_add_i32 s56, s39, s26
		v_add_u32_e32 v3, s56, v7
		v_add_u32_e32 v10, s35, v3
		s_add_i32 s39, s24, 0x21030
		s_add_i32 s56, s37, 0x4030
		s_add_i32 s57, s56, s26
		v_add_u32_e32 v3, s57, v7
		v_add_u32_e32 v11, s35, v3
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[68:69]
		v_add_u32_e32 v3, 0x4000, v7
		v_add_u32_e32 v4, 0x4010, v7
		v_add_u32_e32 v9, 0x4020, v7
		v_add_u32_e32 v10, 0x4030, v7
		v_add_u32_e32 v11, 0x4040, v7
		v_add_u32_e32 v16, 0x4050, v7
		v_add_u32_e32 v17, 0x4060, v7
		v_add_u32_e32 v18, 0x4070, v7
		v_add_u32_e32 v19, s31, v3
		v_add_u32_e32 v3, s31, v4
		v_add_u32_e32 v4, s31, v9
		v_add_u32_e32 v9, s31, v10
		v_add_u32_e32 v10, s31, v11
		v_add_u32_e32 v11, s31, v16
		v_add_u32_e32 v16, s31, v17
		v_add_u32_e32 v17, s31, v18
		s_add_i32 s27, s28, 0x21800
		s_add_i32 s30, s28, 0x21810
		s_add_i32 s36, s28, 0x21820
		s_add_i32 s39, s28, 0x21830
		v_add_u32_e32 v18, s25, v19
		v_add_u32_e32 v19, s25, v3
		v_add_u32_e32 v3, s25, v4
		v_add_u32_e32 v4, s25, v9
		v_add_u32_e32 v9, s25, v10
		v_add_u32_e32 v10, s25, v11
		v_add_u32_e32 v11, s25, v16
		v_add_u32_e32 v16, s25, v17
		s_add_i32 s56, s28, 0x21a00
		s_add_i32 s57, s28, 0x21a10
		s_add_i32 s58, s28, 0x21a20
		s_add_i32 s59, s28, 0x21a30
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s24, 0x22000
		s_add_i32 s30, s37, 0x8000
		s_add_i32 s36, s30, s26
		v_add_u32_e32 v3, s36, v7
		v_add_u32_e32 v4, s35, v3
		s_add_i32 s30, s24, 0x22010
		s_add_i32 s36, s37, 0x8010
		s_add_i32 s39, s36, s26
		v_add_u32_e32 v3, s39, v7
		v_add_u32_e32 v9, s35, v3
		s_add_i32 s36, s24, 0x22020
		s_add_i32 s39, s37, 0x8020
		s_add_i32 s56, s39, s26
		v_add_u32_e32 v3, s56, v7
		v_add_u32_e32 v10, s35, v3
		s_add_i32 s39, s24, 0x22030
		s_add_i32 s56, s37, 0x8030
		s_add_i32 s57, s56, s26
		v_add_u32_e32 v3, s57, v7
		v_add_u32_e32 v11, s35, v3
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[68:69]
		v_add_u32_e32 v3, 0x8000, v7
		v_add_u32_e32 v4, 0x8010, v7
		v_add_u32_e32 v9, 0x8020, v7
		v_add_u32_e32 v10, 0x8030, v7
		v_add_u32_e32 v11, 0x8040, v7
		v_add_u32_e32 v16, 0x8050, v7
		v_add_u32_e32 v17, 0x8060, v7
		v_add_u32_e32 v18, 0x8070, v7
		v_add_u32_e32 v19, s31, v3
		v_add_u32_e32 v3, s31, v4
		v_add_u32_e32 v4, s31, v9
		v_add_u32_e32 v9, s31, v10
		v_add_u32_e32 v10, s31, v11
		v_add_u32_e32 v11, s31, v16
		v_add_u32_e32 v16, s31, v17
		v_add_u32_e32 v17, s31, v18
		s_add_i32 s27, s28, 0x22800
		s_add_i32 s30, s28, 0x22810
		s_add_i32 s36, s28, 0x22820
		s_add_i32 s39, s28, 0x22830
		v_add_u32_e32 v18, s25, v19
		v_add_u32_e32 v19, s25, v3
		v_add_u32_e32 v3, s25, v4
		v_add_u32_e32 v4, s25, v9
		v_add_u32_e32 v9, s25, v10
		v_add_u32_e32 v10, s25, v11
		v_add_u32_e32 v11, s25, v16
		v_add_u32_e32 v16, s25, v17
		s_add_i32 s56, s28, 0x22a00
		s_add_i32 s57, s28, 0x22a10
		s_add_i32 s58, s28, 0x22a20
		s_add_i32 s59, s28, 0x22a30
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s24, 0x23000
		s_add_i32 s30, s37, 0xc000
		s_add_i32 s36, s30, s26
		v_add_u32_e32 v3, s36, v7
		v_add_u32_e32 v4, s35, v3
		s_add_i32 s30, s24, 0x23010
		s_add_i32 s36, s37, 0xc010
		s_add_i32 s39, s36, s26
		v_add_u32_e32 v3, s39, v7
		v_add_u32_e32 v9, s35, v3
		s_add_i32 s36, s24, 0x23020
		s_add_i32 s39, s37, 0xc020
		s_add_i32 s56, s39, s26
		v_add_u32_e32 v3, s56, v7
		v_add_u32_e32 v10, s35, v3
		s_add_i32 s39, s24, 0x23030
		s_add_i32 s56, s37, 0xc030
		s_add_i32 s57, s56, s26
		v_add_u32_e32 v3, s57, v7
		v_add_u32_e32 v11, s35, v3
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[68:69]
		v_add_u32_e32 v3, 0xc000, v7
		v_add_u32_e32 v4, 0xc010, v7
		v_add_u32_e32 v9, 0xc020, v7
		v_add_u32_e32 v10, 0xc030, v7
		v_add_u32_e32 v11, 0xc040, v7
		v_add_u32_e32 v16, 0xc050, v7
		v_add_u32_e32 v17, 0xc060, v7
		v_add_u32_e32 v18, 0xc070, v7
		v_add_u32_e32 v19, s31, v3
		v_add_u32_e32 v3, s31, v4
		v_add_u32_e32 v4, s31, v9
		v_add_u32_e32 v9, s31, v10
		v_add_u32_e32 v10, s31, v11
		v_add_u32_e32 v11, s31, v16
		v_add_u32_e32 v16, s31, v17
		v_add_u32_e32 v17, s31, v18
		s_add_i32 s27, s28, 0x23800
		s_add_i32 s30, s28, 0x23810
		s_add_i32 s36, s28, 0x23820
		s_add_i32 s39, s28, 0x23830
		v_add_u32_e32 v18, s25, v19
		v_add_u32_e32 v19, s25, v3
		v_add_u32_e32 v3, s25, v4
		v_add_u32_e32 v4, s25, v9
		v_add_u32_e32 v9, s25, v10
		v_add_u32_e32 v10, s25, v11
		v_add_u32_e32 v11, s25, v16
		v_add_u32_e32 v16, s25, v17
		s_add_i32 s56, s28, 0x23a00
		s_add_i32 s57, s28, 0x23a10
		s_add_i32 s58, s28, 0x23a20
		s_add_i32 s59, s28, 0x23a30
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v3, s[40:43], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v4, s[40:43], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v10, s[40:43], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v11, s[40:43], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s29, 0x10000
		s_mov_b32 m0, s27
		s_add_i32 s27, s32, 0x80
		v_add3_u32 v3, s27, v5, v6
		v_add3_u32 v4, v3, s33, v8
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s27, s29, 0x12000
		s_mov_b32 m0, s27
		s_add_i32 s27, s32, 0x80080
		v_add3_u32 v3, s27, v5, v6
		v_add3_u32 v4, v3, s33, v8
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s27, s29, 0x14000
		s_mov_b32 m0, s27
		s_add_i32 s27, s32, 0xc0
		v_add3_u32 v3, s27, v5, v6
		v_add3_u32 v4, v3, s33, v8
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s27, s29, 0x16000
		s_mov_b32 m0, s27
		s_add_i32 s27, s32, 0x800c0
		v_add3_u32 v3, s27, v5, v6
		v_add3_u32 v4, v3, s33, v8
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 s27, s29, 0x18000
		s_mov_b32 m0, s27
		v_add_u32_e32 v3, 0x80, v5
		v_add_u32_e32 v4, v3, v6
		v_add3_u32 v3, v4, s34, v8
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s27, s29, 0x1a000
		s_mov_b32 m0, s27
		v_add_u32_e32 v3, 0x80080, v5
		v_add_u32_e32 v4, v3, v6
		v_add3_u32 v3, v4, s34, v8
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s27, s29, 0x1c000
		s_mov_b32 m0, s27
		v_add_u32_e32 v3, 0xc0, v5
		v_add_u32_e32 v4, v3, v6
		v_add3_u32 v3, v4, s34, v8
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s27, s29, 0x1e000
		s_mov_b32 m0, s27
		v_add_u32_e32 v3, 0x800c0, v5
		v_add_u32_e32 v4, v3, v6
		v_add3_u32 v3, v4, s34, v8
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_waitcnt vmcnt(56)
		s_barrier
		v_and_b32_e32 v3, 15, v0
		v_lshrrev_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v9, 4, v2
		v_and_b32_e32 v10, 3, v4
		v_lshrrev_b32_e32 v4, 7, v0
		v_xor_b32_e32 v11, v9, v10
		v_and_b32_e32 v9, 1, v1
		v_lshlrev_b32_e32 v10, 12, v4
		v_lshlrev_b32_e32 v16, 6, v3
		v_lshlrev_b32_e32 v3, 4, v11
		v_lshlrev_b32_e32 v11, 13, v9
		v_add3_u32 v17, v10, v16, v3
		v_add3_u32 v18, v16, v11, v3
		v_lshlrev_b32_e32 v19, 9, v4
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
		v_add_u32_e32 v4, 0x20000, v19
		v_lshlrev_b32_e32 v17, 3, v2
		v_lshlrev_b32_e32 v2, 10, v9
		s_cmp_lt_i32 0, 30
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
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s27, s38, 2
		s_mul_i32 s30, s27, 0x80
		s_lshl_b32 s36, s30, 0
		s_add_i32 s30, s38, 1
		s_waitcnt vmcnt(32)
		s_barrier
		s_and_b32 s39, s38, 1
		s_lshl_b32 s56, s39, 13
		v_add3_u32 v18, v4, s56, v17
		ds_read_b64_tr_b8 v[240:241], v18
		s_add_i32 s39, s56, 0x20000
		v_add3_u32 v19, s39, v17, v2
		ds_read_b64_tr_b8 v[242:243], v19 offset:2048
		ds_read_b64_tr_b8 v[244:245], v19 offset:2560
		ds_read_b64_tr_b8 v[246:247], v18 offset:4096
		ds_read_b64_tr_b8 v[248:249], v19 offset:6144
		ds_read_b64_tr_b8 v[250:251], v19 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[64:67], v[124:127], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[64:67], v[156:159], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[64:67], v[188:191], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[64:67], v[220:223], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[88:91], v[116:119], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[92:95], v[120:123], v246, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[96:99], v[124:127], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[84:87], v[144:147], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[88:91], v[148:151], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[92:95], v[152:155], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[96:99], v[156:159], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[84:87], v[176:179], v246, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[88:91], v[180:183], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[92:95], v[184:187], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[96:99], v[188:191], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[84:87], v[208:211], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[88:91], v[212:215], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[92:95], v[216:219], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[96:99], v[220:223], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mul_i32 s39, s27, 2
		s_and_b32 s56, s27, 1
		s_lshl_b32 s27, s56, 13
		s_add_i32 s57, s24, s27
		s_add_i32 s58, s57, 0x20000
		s_lshl_b32 s59, s39, 14
		s_add_i32 s60, s59, s37
		s_add_i32 s61, s60, s26
		v_add_u32_e32 v18, s61, v7
		v_add_u32_e32 v19, s35, v18
		s_add_i32 s60, s57, 0x20010
		s_add_i32 s61, s59, 16
		s_add_i32 s62, s61, s37
		s_add_i32 s63, s62, s26
		v_add_u32_e32 v18, s63, v7
		v_add_u32_e32 v241, s35, v18
		s_add_i32 s62, s57, 0x20020
		s_add_i32 s63, s59, 32
		s_add_i32 s64, s63, s37
		s_add_i32 s65, s64, s26
		v_add_u32_e32 v18, s65, v7
		v_add_u32_e32 v242, s35, v18
		s_add_i32 s64, s57, 0x20030
		s_add_i32 s65, s59, 48
		s_add_i32 s66, s65, s37
		s_add_i32 s67, s66, s26
		v_add_u32_e32 v18, s67, v7
		v_add_u32_e32 v243, s35, v18
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		s_mov_b32 m0, s58
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v19, s[44:47], 0 offen lds
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v242, s[44:47], 0 offen lds
		s_mov_b32 m0, s64
		s_nop 0
		buffer_load_dwordx4 v243, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s58, s27, s28
		s_add_i32 s27, s58, 0x20800
		v_add_u32_e32 v18, s59, v7
		v_add_u32_e32 v19, s31, v18
		v_add_u32_e32 v18, s25, v19
		s_add_i32 s60, s58, 0x20810
		v_add_u32_e32 v19, s61, v7
		v_add_u32_e32 v241, s31, v19
		v_add_u32_e32 v19, s25, v241
		s_add_i32 s61, s58, 0x20820
		v_add_u32_e32 v241, s63, v7
		v_add_u32_e32 v242, s31, v241
		v_add_u32_e32 v241, s25, v242
		s_add_i32 s62, s58, 0x20830
		v_add_u32_e32 v242, s65, v7
		v_add_u32_e32 v243, s31, v242
		v_add_u32_e32 v242, s25, v243
		s_add_i32 s63, s58, 0x20a00
		s_add_i32 s64, s59, 64
		v_add_u32_e32 v243, s64, v7
		v_add_u32_e32 v247, s31, v243
		v_add_u32_e32 v243, s25, v247
		s_add_i32 s64, s58, 0x20a10
		s_add_i32 s65, s59, 0x50
		v_add_u32_e32 v247, s65, v7
		v_add_u32_e32 v248, s31, v247
		v_add_u32_e32 v247, s25, v248
		s_add_i32 s65, s58, 0x20a20
		s_add_i32 s66, s59, 0x60
		v_add_u32_e32 v248, s66, v7
		v_add_u32_e32 v249, s31, v248
		v_add_u32_e32 v248, s25, v249
		s_add_i32 s66, s58, 0x20a30
		s_add_i32 s67, s59, 0x70
		v_add_u32_e32 v249, s67, v7
		v_add_u32_e32 v252, s31, v249
		v_add_u32_e32 v249, s25, v252
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v241, s[40:43], 0 offen lds
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v242, s[40:43], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v243, s[40:43], 0 offen lds
		s_mov_b32 m0, s64
		s_nop 0
		buffer_load_dwordx4 v247, s[40:43], 0 offen lds
		s_mov_b32 m0, s65
		s_nop 0
		buffer_load_dwordx4 v248, s[40:43], 0 offen lds
		s_mov_b32 m0, s66
		s_nop 0
		buffer_load_dwordx4 v249, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s39, 1
		s_add_i32 s39, s57, 0x21000
		s_lshl_b32 s59, s27, 14
		s_add_i32 s27, s59, s37
		s_add_i32 s60, s27, s26
		v_add_u32_e32 v18, s60, v7
		v_add_u32_e32 v19, s35, v18
		s_add_i32 s27, s57, 0x21010
		s_add_i32 s60, s59, 16
		s_add_i32 s61, s60, s37
		s_add_i32 s62, s61, s26
		v_add_u32_e32 v18, s62, v7
		v_add_u32_e32 v241, s35, v18
		s_add_i32 s61, s57, 0x21020
		s_add_i32 s62, s59, 32
		s_add_i32 s63, s62, s37
		s_add_i32 s64, s63, s26
		v_add_u32_e32 v18, s64, v7
		v_add_u32_e32 v242, s35, v18
		s_add_i32 s63, s57, 0x21030
		s_add_i32 s57, s59, 48
		s_add_i32 s64, s57, s37
		s_add_i32 s65, s64, s26
		v_add_u32_e32 v18, s65, v7
		v_add_u32_e32 v243, s35, v18
		s_and_saveexec_b64 s[68:69], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v19, s[44:47], 0 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v242, s[44:47], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v243, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[68:69]
		s_add_i32 s27, s58, 0x21800
		v_add_u32_e32 v18, s59, v7
		v_add_u32_e32 v19, s31, v18
		v_add_u32_e32 v18, s25, v19
		s_add_i32 s39, s58, 0x21810
		v_add_u32_e32 v19, s60, v7
		v_add_u32_e32 v241, s31, v19
		v_add_u32_e32 v19, s25, v241
		s_add_i32 s60, s58, 0x21820
		v_add_u32_e32 v241, s62, v7
		v_add_u32_e32 v242, s31, v241
		v_add_u32_e32 v241, s25, v242
		s_add_i32 s61, s58, 0x21830
		v_add_u32_e32 v242, s57, v7
		v_add_u32_e32 v243, s31, v242
		v_add_u32_e32 v242, s25, v243
		s_add_i32 s57, s58, 0x21a00
		s_add_i32 s62, s59, 64
		v_add_u32_e32 v243, s62, v7
		v_add_u32_e32 v247, s31, v243
		v_add_u32_e32 v243, s25, v247
		s_add_i32 s62, s58, 0x21a10
		s_add_i32 s63, s59, 0x50
		v_add_u32_e32 v247, s63, v7
		v_add_u32_e32 v248, s31, v247
		v_add_u32_e32 v247, s25, v248
		s_add_i32 s63, s58, 0x21a20
		s_add_i32 s64, s59, 0x60
		v_add_u32_e32 v248, s64, v7
		v_add_u32_e32 v249, s31, v248
		v_add_u32_e32 v248, s25, v249
		s_add_i32 s64, s58, 0x21a30
		s_add_i32 s58, s59, 0x70
		v_add_u32_e32 v249, s58, v7
		v_add_u32_e32 v252, s31, v249
		v_add_u32_e32 v249, s25, v252
		s_and_saveexec_b64 s[68:69], s[54:55]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v18, s[40:43], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v19, s[40:43], 0 offen lds
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v241, s[40:43], 0 offen lds
		s_mov_b32 m0, s61
		s_nop 0
		buffer_load_dwordx4 v242, s[40:43], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v243, s[40:43], 0 offen lds
		s_mov_b32 m0, s62
		s_nop 0
		buffer_load_dwordx4 v247, s[40:43], 0 offen lds
		s_mov_b32 m0, s63
		s_nop 0
		buffer_load_dwordx4 v248, s[40:43], 0 offen lds
		s_mov_b32 m0, s64
		s_nop 0
		buffer_load_dwordx4 v249, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[68:69]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[68:71], v[128:131], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[72:75], v[132:135], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[76:79], v[136:139], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[80:83], v[140:143], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[68:71], v[160:163], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[72:75], v[164:167], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[76:79], v[168:171], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[80:83], v[172:175], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[68:71], v[192:195], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[72:75], v[196:199], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[76:79], v[200:203], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[80:83], v[204:207], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[68:71], v[224:227], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[72:75], v[228:231], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[76:79], v[232:235], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[80:83], v[236:239], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[100:103], v[128:131], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[104:107], v[132:135], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[108:111], v[136:139], v246, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[112:115], v[140:143], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[100:103], v[160:163], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[104:107], v[164:167], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[108:111], v[168:171], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[112:115], v[172:175], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[100:103], v[192:195], v246, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[104:107], v[196:199], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[108:111], v[200:203], v246, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[112:115], v[204:207], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[100:103], v[224:227], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[104:107], v[228:231], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[108:111], v[232:235], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[112:115], v[236:239], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(24)
		s_barrier
		s_lshl_b32 s27, s56, 16
		s_add_i32 s39, s29, s27
		s_mov_b32 m0, s39
		s_add_i32 s27, s36, s32
		v_add3_u32 v18, s27, v5, v6
		v_add3_u32 v19, v18, s33, v8
		buffer_load_dwordx4 v19, s[16:19], 0 offen lds
		s_add_i32 s27, s39, 0x2000
		s_mov_b32 m0, s27
		s_add_i32 s27, s36, 0x80000
		s_add_i32 s56, s27, s32
		v_add3_u32 v18, s56, v5, v6
		v_add3_u32 v19, v18, s33, v8
		buffer_load_dwordx4 v19, s[16:19], 0 offen lds
		s_add_i32 s56, s39, 0x4000
		s_mov_b32 m0, s56
		s_add_i32 s56, s36, 64
		s_add_i32 s57, s56, s32
		v_add3_u32 v18, s57, v5, v6
		v_add3_u32 v19, v18, s33, v8
		buffer_load_dwordx4 v19, s[16:19], 0 offen lds
		s_add_i32 s57, s39, 0x6000
		s_mov_b32 m0, s57
		s_add_i32 s57, s36, 0x80040
		s_add_i32 s58, s57, s32
		v_add3_u32 v18, s58, v5, v6
		v_add3_u32 v19, v18, s33, v8
		buffer_load_dwordx4 v19, s[16:19], 0 offen lds
		s_add_i32 s58, s39, 0x8000
		s_mov_b32 m0, s58
		v_add3_u32 v18, s36, v5, v6
		v_add3_u32 v19, v18, s34, v8
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 s36, s39, 0xa000
		s_mov_b32 m0, s36
		v_add3_u32 v18, s27, v5, v6
		v_add3_u32 v19, v18, s34, v8
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 s27, s39, 0xc000
		s_mov_b32 m0, s27
		v_add3_u32 v18, s56, v5, v6
		v_add3_u32 v19, v18, s34, v8
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 s27, s39, 0xe000
		s_mov_b32 m0, s27
		v_add3_u32 v18, s57, v5, v6
		v_add3_u32 v19, v18, s34, v8
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_and_b32 s27, s30, 1
		s_lshl_b32 s36, s27, 16
		v_add_u32_e32 v18, s36, v10
		v_add3_u32 v19, v18, v16, v3
		ds_read_b128 v[20:23], v19
		ds_read_b128 v[24:27], v19 offset:1024
		ds_read_b128 v[28:31], v19 offset:2048
		ds_read_b128 v[32:35], v19 offset:3072
		ds_read_b128 v[36:39], v19 offset:16384
		ds_read_b128 v[40:43], v19 offset:17408
		ds_read_b128 v[44:47], v19 offset:18432
		ds_read_b128 v[48:51], v19 offset:19456
		v_add_u32_e32 v18, s36, v16
		v_add3_u32 v19, v18, v11, v3
		ds_read_b128 v[52:55], v19 offset:32768
		ds_read_b128 v[56:59], v19 offset:33792
		ds_read_b128 v[60:63], v19 offset:34816
		ds_read_b128 v[64:67], v19 offset:35840
		ds_read_b128 v[68:71], v19 offset:36864
		ds_read_b128 v[72:75], v19 offset:37888
		ds_read_b128 v[76:79], v19 offset:38912
		ds_read_b128 v[80:83], v19 offset:39936
		ds_read_b128 v[84:87], v19 offset:49152
		ds_read_b128 v[88:91], v19 offset:50176
		ds_read_b128 v[92:95], v19 offset:51200
		ds_read_b128 v[96:99], v19 offset:52224
		ds_read_b128 v[100:103], v19 offset:53248
		ds_read_b128 v[104:107], v19 offset:54272
		ds_read_b128 v[108:111], v19 offset:55296
		ds_read_b128 v[112:115], v19 offset:56320
		s_cmp_lt_i32 s30, 30
		s_mov_b32 s38, s30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(32)
		s_barrier
		v_add_u32_e32 v2, v4, v17
		ds_read_b64_tr_b8 v[4:5], v2
		v_add_u32_e32 v6, 0x20000, v17
		v_lshl_add_u32 v7, v9, 10, v6
		ds_read_b64_tr_b8 v[8:9], v7 offset:2048
		ds_read_b64_tr_b8 v[18:19], v7 offset:2560
		ds_read_b64_tr_b8 v[240:241], v2 offset:4096
		ds_read_b64_tr_b8 v[242:243], v7 offset:6144
		ds_read_b64_tr_b8 v[244:245], v7 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v4, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v4, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v4, v8 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[64:67], v[124:127], v4, v8 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[68:71], v[128:131], v4, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[72:75], v[132:135], v4, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[76:79], v[136:139], v4, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[80:83], v[140:143], v4, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v4, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v4, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v4, v8 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[64:67], v[156:159], v4, v8 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[68:71], v[160:163], v4, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[72:75], v[164:167], v4, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[76:79], v[168:171], v4, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[80:83], v[172:175], v4, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v4, v8 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v4, v8 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v4, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[64:67], v[188:191], v4, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[68:71], v[192:195], v4, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[72:75], v[196:199], v4, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[76:79], v[200:203], v4, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[80:83], v[204:207], v4, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v4, v8 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v4, v8 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v4, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[64:67], v[220:223], v4, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[68:71], v[224:227], v4, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[72:75], v[228:231], v4, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[76:79], v[232:235], v4, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[80:83], v[236:239], v4, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[88:91], v[116:119], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[92:95], v[120:123], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[96:99], v[124:127], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[100:103], v[128:131], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[104:107], v[132:135], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[108:111], v[136:139], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[112:115], v[140:143], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[84:87], v[144:147], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[88:91], v[148:151], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[92:95], v[152:155], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[96:99], v[156:159], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[100:103], v[160:163], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[104:107], v[164:167], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[108:111], v[168:171], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[112:115], v[172:175], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[84:87], v[176:179], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[88:91], v[180:183], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[92:95], v[184:187], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[96:99], v[188:191], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[100:103], v[192:195], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[104:107], v[196:199], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[108:111], v[200:203], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[112:115], v[204:207], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[84:87], v[208:211], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[88:91], v[212:215], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[92:95], v[216:219], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[96:99], v[220:223], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[100:103], v[224:227], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[104:107], v[228:231], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[108:111], v[232:235], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[112:115], v[236:239], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v4, 0x10000, v10
		v_add3_u32 v5, v4, v16, v3
		ds_read_b128 v[20:23], v5
		ds_read_b128 v[24:27], v5 offset:1024
		ds_read_b128 v[28:31], v5 offset:2048
		ds_read_b128 v[32:35], v5 offset:3072
		ds_read_b128 v[36:39], v5 offset:16384
		ds_read_b128 v[40:43], v5 offset:17408
		ds_read_b128 v[44:47], v5 offset:18432
		ds_read_b128 v[48:51], v5 offset:19456
		v_add_u32_e32 v4, 0x10000, v16
		v_add3_u32 v5, v4, v11, v3
		ds_read_b128 v[8:11], v5 offset:32768
		ds_read_b128 v[52:55], v5 offset:33792
		ds_read_b128 v[56:59], v5 offset:34816
		ds_read_b128 v[60:63], v5 offset:35840
		ds_read_b128 v[64:67], v5 offset:36864
		ds_read_b128 v[68:71], v5 offset:37888
		ds_read_b128 v[72:75], v5 offset:38912
		ds_read_b128 v[76:79], v5 offset:39936
		ds_read_b128 v[80:83], v5 offset:49152
		ds_read_b128 v[84:87], v5 offset:50176
		ds_read_b128 v[88:91], v5 offset:51200
		ds_read_b128 v[92:95], v5 offset:52224
		ds_read_b128 v[96:99], v5 offset:53248
		ds_read_b128 v[100:103], v5 offset:54272
		ds_read_b128 v[104:107], v5 offset:55296
		ds_read_b128 v[108:111], v5 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v2 offset:8192
		ds_read_b64_tr_b8 v[18:19], v7 offset:10240
		ds_read_b64_tr_b8 v[112:113], v7 offset:10752
		ds_read_b64_tr_b8 v[114:115], v2 offset:12288
		ds_read_b64_tr_b8 v[2:3], v7 offset:14336
		ds_read_b64_tr_b8 v[240:241], v7 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[8:11], v[12:15], v4, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v4, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v4, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v4, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[8:11], v[144:147], v4, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v4, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v4, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v4, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[8:11], v[176:179], v4, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v4, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v4, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v4, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[8:11], v[208:211], v4, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v4, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v4, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v4, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[80:83], v[12:15], v114, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[84:87], v[116:119], v114, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v114, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v114, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[80:83], v[144:147], v114, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v114, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v114, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v114, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[80:83], v[176:179], v114, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v114, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v114, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v114, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[80:83], v[208:211], v114, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v114, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v114, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v114, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_f16_f32_e64 v2, v12
		v_cvt_f16_f32_e64 v3, v13
		v_cvt_f16_f32_e64 v5, v14
		v_cvt_f16_f32_e64 v6, v15
		v_and_b32_e32 v7, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v3
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v2, v7, v3
		v_and_b32_e32 v7, 0xffff, v5
		v_and_b32_e32 v3, 0xffff, v6
		v_lshlrev_b32_e32 v5, 16, v3
		v_or_b32_e32 v3, v7, v5
		v_lshl_add_u32 v5, v1, 14, v17
		buffer_store_dwordx2 v[2:3], v5, s[48:51], 0 offen
		v_cvt_f16_f32_e64 v1, v116
		v_cvt_f16_f32_e64 v2, v117
		v_cvt_f16_f32_e64 v3, v118
		v_cvt_f16_f32_e64 v6, v119
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:512
		v_cvt_f16_f32_e64 v1, v120
		v_cvt_f16_f32_e64 v2, v121
		v_cvt_f16_f32_e64 v3, v122
		v_cvt_f16_f32_e64 v6, v123
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:1024
		v_cvt_f16_f32_e64 v1, v124
		v_cvt_f16_f32_e64 v2, v125
		v_cvt_f16_f32_e64 v3, v126
		v_cvt_f16_f32_e64 v6, v127
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:1536
		v_cvt_f16_f32_e64 v1, v144
		v_cvt_f16_f32_e64 v2, v145
		v_cvt_f16_f32_e64 v3, v146
		v_cvt_f16_f32_e64 v6, v147
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s16, 0x1000
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen
		v_cvt_f16_f32_e64 v1, v148
		v_cvt_f16_f32_e64 v2, v149
		v_cvt_f16_f32_e64 v3, v150
		v_cvt_f16_f32_e64 v6, v151
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:512
		v_cvt_f16_f32_e64 v1, v152
		v_cvt_f16_f32_e64 v2, v153
		v_cvt_f16_f32_e64 v3, v154
		v_cvt_f16_f32_e64 v6, v155
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:1024
		v_cvt_f16_f32_e64 v1, v156
		v_cvt_f16_f32_e64 v2, v157
		v_cvt_f16_f32_e64 v3, v158
		v_cvt_f16_f32_e64 v6, v159
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:1536
		v_cvt_f16_f32_e64 v1, v176
		v_cvt_f16_f32_e64 v2, v177
		v_cvt_f16_f32_e64 v3, v178
		v_cvt_f16_f32_e64 v6, v179
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s17, 0x2000
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen
		v_cvt_f16_f32_e64 v1, v180
		v_cvt_f16_f32_e64 v2, v181
		v_cvt_f16_f32_e64 v3, v182
		v_cvt_f16_f32_e64 v6, v183
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:512
		v_cvt_f16_f32_e64 v1, v184
		v_cvt_f16_f32_e64 v2, v185
		v_cvt_f16_f32_e64 v3, v186
		v_cvt_f16_f32_e64 v6, v187
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:1024
		v_cvt_f16_f32_e64 v1, v188
		v_cvt_f16_f32_e64 v2, v189
		v_cvt_f16_f32_e64 v3, v190
		v_cvt_f16_f32_e64 v6, v191
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:1536
		v_cvt_f16_f32_e64 v1, v208
		v_cvt_f16_f32_e64 v2, v209
		v_cvt_f16_f32_e64 v3, v210
		v_cvt_f16_f32_e64 v6, v211
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		s_mov_b32 s18, 0x3000
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen
		v_cvt_f16_f32_e64 v1, v212
		v_cvt_f16_f32_e64 v2, v213
		v_cvt_f16_f32_e64 v3, v214
		v_cvt_f16_f32_e64 v6, v215
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:512
		v_cvt_f16_f32_e64 v1, v216
		v_cvt_f16_f32_e64 v2, v217
		v_cvt_f16_f32_e64 v3, v218
		v_cvt_f16_f32_e64 v6, v219
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:1024
		v_cvt_f16_f32_e64 v1, v220
		v_cvt_f16_f32_e64 v2, v221
		v_cvt_f16_f32_e64 v3, v222
		v_cvt_f16_f32_e64 v6, v223
		v_and_b32_e32 v7, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v7, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v6
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v4, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v4, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v4, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v4, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v4, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v4, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v4, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v4, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v4, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v4, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v4, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v4, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v4, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v4, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v4, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v4, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v114, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v114, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v114, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v114, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_f16_f32_e64 v1, v128
		v_cvt_f16_f32_e64 v2, v129
		v_cvt_f16_f32_e64 v3, v130
		v_cvt_f16_f32_e64 v4, v131
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:2048
		v_cvt_f16_f32_e64 v1, v132
		v_cvt_f16_f32_e64 v2, v133
		v_cvt_f16_f32_e64 v3, v134
		v_cvt_f16_f32_e64 v4, v135
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:2560
		v_cvt_f16_f32_e64 v1, v136
		v_cvt_f16_f32_e64 v2, v137
		v_cvt_f16_f32_e64 v3, v138
		v_cvt_f16_f32_e64 v4, v139
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:3072
		v_cvt_f16_f32_e64 v1, v140
		v_cvt_f16_f32_e64 v2, v141
		v_cvt_f16_f32_e64 v3, v142
		v_cvt_f16_f32_e64 v4, v143
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], 0 offen offset:3584
		v_cvt_f16_f32_e64 v1, v160
		v_cvt_f16_f32_e64 v2, v161
		v_cvt_f16_f32_e64 v3, v162
		v_cvt_f16_f32_e64 v4, v163
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:2048
		v_cvt_f16_f32_e64 v1, v164
		v_cvt_f16_f32_e64 v2, v165
		v_cvt_f16_f32_e64 v3, v166
		v_cvt_f16_f32_e64 v4, v167
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:2560
		v_cvt_f16_f32_e64 v1, v168
		v_cvt_f16_f32_e64 v2, v169
		v_cvt_f16_f32_e64 v3, v170
		v_cvt_f16_f32_e64 v4, v171
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:3072
		v_cvt_f16_f32_e64 v1, v172
		v_cvt_f16_f32_e64 v2, v173
		v_cvt_f16_f32_e64 v3, v174
		v_cvt_f16_f32_e64 v4, v175
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s16 offen offset:3584
		v_cvt_f16_f32_e64 v1, v192
		v_cvt_f16_f32_e64 v2, v193
		v_cvt_f16_f32_e64 v3, v194
		v_cvt_f16_f32_e64 v4, v195
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:2048
		v_cvt_f16_f32_e64 v1, v196
		v_cvt_f16_f32_e64 v2, v197
		v_cvt_f16_f32_e64 v3, v198
		v_cvt_f16_f32_e64 v4, v199
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:2560
		v_cvt_f16_f32_e64 v1, v200
		v_cvt_f16_f32_e64 v2, v201
		v_cvt_f16_f32_e64 v3, v202
		v_cvt_f16_f32_e64 v4, v203
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:3072
		v_cvt_f16_f32_e64 v1, v204
		v_cvt_f16_f32_e64 v2, v205
		v_cvt_f16_f32_e64 v3, v206
		v_cvt_f16_f32_e64 v4, v207
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s17 offen offset:3584
		v_cvt_f16_f32_e64 v1, v224
		v_cvt_f16_f32_e64 v2, v225
		v_cvt_f16_f32_e64 v3, v226
		v_cvt_f16_f32_e64 v4, v227
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:2048
		v_cvt_f16_f32_e64 v1, v228
		v_cvt_f16_f32_e64 v2, v229
		v_cvt_f16_f32_e64 v3, v230
		v_cvt_f16_f32_e64 v4, v231
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:2560
		v_cvt_f16_f32_e64 v1, v232
		v_cvt_f16_f32_e64 v2, v233
		v_cvt_f16_f32_e64 v3, v234
		v_cvt_f16_f32_e64 v4, v235
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:3072
		v_cvt_f16_f32_e64 v1, v236
		v_cvt_f16_f32_e64 v2, v237
		v_cvt_f16_f32_e64 v3, v238
		v_cvt_f16_f32_e64 v4, v239
		v_and_b32_e32 v6, 0xffff, v1
		v_and_b32_e32 v1, 0xffff, v2
		v_lshlrev_b32_e32 v2, 16, v1
		v_or_b32_e32 v8, v6, v2
		v_and_b32_e32 v1, 0xffff, v3
		v_and_b32_e32 v2, 0xffff, v4
		v_lshlrev_b32_e32 v3, 16, v2
		v_or_b32_e32 v9, v1, v3
		buffer_store_dwordx2 v[8:9], v5, s[48:51], s18 offen offset:3584
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
		.amdhsa_next_free_vgpr 253
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 253
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
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
    .vgpr_count:     253
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
