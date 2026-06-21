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
		v_lshlrev_b32_e32 v5, 12, v3
		s_and_b32 s28, s25, 63
		v_lshl_add_u32 v3, v1, 16, v5
		s_lshr_b32 s25, s28, 2
		v_lshl_add_u32 v5, v7, 4, v3
		s_lshl_b32 s29, s25, 17
		s_add_i32 s30, s27, s29
		s_and_b32 s27, s28, 3
		s_lshl_b32 s28, s27, 21
		s_add_i32 s29, s30, s28
		s_add_u32 s30, s6, s29
		s_addc_u32 s31, s7, 0
		s_lshr_b32 s28, s24, 6
		s_lshl_b32 s29, s28, 10
		s_mov_b32 m0, s29
		s_lshl_b32 s32, s26, 22
		s_lshl_b32 s33, s27, 20
		s_add_i32 s34, s32, s33
		v_add_u32_e32 v3, s34, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x2000
		s_add_i32 s35, s32, 0x80000
		s_add_i32 s36, s35, s33
		v_add_u32_e32 v3, s36, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x4000
		s_add_i32 s35, s32, 64
		s_add_i32 s37, s35, s33
		v_add_u32_e32 v3, s37, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x6000
		s_add_i32 s35, s32, 0x80040
		s_add_i32 s38, s35, s33
		v_add_u32_e32 v3, s38, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x8000
		s_lshl_b32 s35, s25, 20
		v_add_u32_e32 v3, s35, v5
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0xa000
		s_add_i32 s39, s35, 0x80000
		v_add_u32_e32 v3, s39, v5
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0xc000
		s_add_i32 s40, s35, 64
		v_add_u32_e32 v3, s40, v5
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0xe000
		s_add_i32 s41, s35, 0x80040
		v_add_u32_e32 v3, s41, v5
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_lshr_b32 s42, s24, 7
		v_lshlrev_b32_e32 v3, 12, v4
		s_lshl_b32 s24, s42, 9
		v_and_b32_e32 v4, 39, v0
		s_lshl_b32 s43, s26, 10
		v_and_or_b32 v6, 1, v1, v4
		s_lshl_b32 s26, s42, 6
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 s42, s43, s26
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
		s_mov_b32 s52, s30
		s_mov_b32 s53, s31
		s_mov_b32 s54, 0x20000
		s_mov_b32 s55, 0x31016000
		s_lshl_b32 s30, s27, 8
		s_add_i32 s27, s42, s30
		v_add_u32_e32 v7, s27, v3
		s_add_i32 s31, s43, 16
		s_add_i32 s42, s31, s26
		s_add_i32 s31, s42, s30
		v_add_u32_e32 v12, s31, v3
		s_add_i32 s42, s43, 32
		s_add_i32 s56, s42, s26
		s_add_i32 s42, s56, s30
		v_add_u32_e32 v13, s42, v3
		s_add_i32 s56, s43, 48
		s_add_i32 s57, s56, s26
		s_mov_b32 s56, 0
		v_cmp_eq_u32_e64 vcc, v6, s56
		s_mov_b64 s[58:59], vcc
		s_add_i32 s60, s57, s30
		v_add_u32_e32 v6, s60, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s24, 0x20000
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x20010
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x20020
		s_nop 0
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x20030
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[74:75]
		v_lshrrev_b32_e32 v6, 1, v1
		v_or_b32_e32 v7, v4, v6
		v_cmp_eq_u32_e64 vcc, v7, s56
		s_mov_b64 s[62:63], vcc
		s_and_b32 s57, s28, 1
		s_lshl_b32 s28, s57, 10
		s_lshl_b32 s61, s25, 8
		s_lshl_b32 s25, s57, 7
		s_add_i32 s57, s61, s25
		v_add_u32_e32 v4, s57, v3
		s_add_i32 s64, s61, 16
		s_add_i32 s65, s64, s25
		v_add_u32_e32 v6, s65, v3
		s_add_i32 s64, s61, 32
		s_add_i32 s66, s64, s25
		v_add_u32_e32 v7, s66, v3
		s_add_i32 s64, s61, 48
		s_add_i32 s67, s64, s25
		v_add_u32_e32 v12, s67, v3
		s_add_i32 s64, s61, 64
		s_add_i32 s68, s64, s25
		v_add_u32_e32 v13, s68, v3
		s_add_i32 s64, s61, 0x50
		s_add_i32 s69, s64, s25
		v_add_u32_e32 v14, s69, v3
		s_add_i32 s64, s61, 0x60
		s_add_i32 s70, s64, s25
		v_add_u32_e32 v15, s70, v3
		s_add_i32 s64, s61, 0x70
		s_add_i32 s71, s64, s25
		v_add_u32_e32 v16, s71, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s28, 0x20800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s43, 0x4000
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v4, s64, v3
		s_add_i32 s64, s43, 0x4010
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v6, s64, v3
		s_add_i32 s64, s43, 0x4020
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v7, s64, v3
		s_add_i32 s64, s43, 0x4030
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v12, s64, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s24, 0x21000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x21010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x21020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x21030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s61, 0x4000
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v4, s72, v3
		s_add_i32 s64, s61, 0x4010
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v6, s72, v3
		s_add_i32 s64, s61, 0x4020
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v7, s72, v3
		s_add_i32 s64, s61, 0x4030
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v12, s72, v3
		s_add_i32 s64, s61, 0x4040
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v13, s72, v3
		s_add_i32 s64, s61, 0x4050
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v14, s72, v3
		s_add_i32 s64, s61, 0x4060
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v15, s72, v3
		s_add_i32 s64, s61, 0x4070
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v16, s72, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s28, 0x21800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s43, 0x8000
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v4, s64, v3
		s_add_i32 s64, s43, 0x8010
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v6, s64, v3
		s_add_i32 s64, s43, 0x8020
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v7, s64, v3
		s_add_i32 s64, s43, 0x8030
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v12, s64, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s24, 0x22000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x22010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x22020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x22030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s61, 0x8000
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v4, s72, v3
		s_add_i32 s64, s61, 0x8010
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v6, s72, v3
		s_add_i32 s64, s61, 0x8020
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v7, s72, v3
		s_add_i32 s64, s61, 0x8030
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v12, s72, v3
		s_add_i32 s64, s61, 0x8040
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v13, s72, v3
		s_add_i32 s64, s61, 0x8050
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v14, s72, v3
		s_add_i32 s64, s61, 0x8060
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v15, s72, v3
		s_add_i32 s64, s61, 0x8070
		s_add_i32 s72, s64, s25
		v_add_u32_e32 v16, s72, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s28, 0x22800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s43, 0xc000
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v4, s64, v3
		s_add_i32 s64, s43, 0xc010
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v6, s64, v3
		s_add_i32 s64, s43, 0xc020
		s_add_i32 s72, s64, s26
		s_add_i32 s64, s72, s30
		v_add_u32_e32 v7, s64, v3
		s_add_i32 s64, s43, 0xc030
		s_add_i32 s43, s64, s26
		s_add_i32 s26, s43, s30
		v_add_u32_e32 v12, s26, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s24, 0x23000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x23010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x23020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s24, 0x23030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s26, s61, 0xc000
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v4, s30, v3
		s_add_i32 s26, s61, 0xc010
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v6, s30, v3
		s_add_i32 s26, s61, 0xc020
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v7, s30, v3
		s_add_i32 s26, s61, 0xc030
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v12, s30, v3
		s_add_i32 s26, s61, 0xc040
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v13, s30, v3
		s_add_i32 s26, s61, 0xc050
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v14, s30, v3
		s_add_i32 s26, s61, 0xc060
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v15, s30, v3
		s_add_i32 s26, s61, 0xc070
		s_add_i32 s30, s26, s25
		v_add_u32_e32 v16, s30, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s28, 0x23800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s28, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[74:75]
		s_add_i32 m0, s29, 0x10000
		s_add_i32 s25, s32, 0x80
		s_add_i32 s26, s25, s33
		v_add_u32_e32 v4, s26, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x12000
		s_add_i32 s25, s32, 0x80080
		s_add_i32 s26, s25, s33
		v_add_u32_e32 v4, s26, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x14000
		s_add_i32 s25, s32, 0xc0
		s_add_i32 s26, s25, s33
		v_add_u32_e32 v4, s26, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x16000
		s_add_i32 s25, s32, 0x800c0
		s_add_i32 s26, s25, s33
		v_add_u32_e32 v4, s26, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s29, 0x18000
		s_add_i32 s25, s35, 0x80
		v_add_u32_e32 v4, s25, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0x1a000
		s_add_i32 s25, s35, 0x80080
		v_add_u32_e32 v4, s25, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0x1c000
		s_add_i32 s25, s35, 0xc0
		v_add_u32_e32 v4, s25, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s29, 0x1e000
		s_add_i32 s25, s35, 0x800c0
		v_add_u32_e32 v4, s25, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_and_b32_e32 v4, 15, v0
		v_lshrrev_b32_e32 v6, 1, v4
		v_lshrrev_b32_e32 v7, 4, v2
		v_and_b32_e32 v12, 3, v6
		v_lshrrev_b32_e32 v6, 7, v0
		v_xor_b32_e32 v13, v7, v12
		v_and_b32_e32 v7, 1, v1
		v_lshlrev_b32_e32 v12, 12, v6
		v_lshlrev_b32_e32 v14, 6, v4
		v_lshlrev_b32_e32 v4, 4, v13
		v_lshlrev_b32_e32 v13, 13, v7
		v_add3_u32 v15, v12, v14, v4
		v_add3_u32 v16, v14, v13, v4
		ds_read_b128 v[20:23], v15
		ds_read_b128 v[24:27], v15 offset:1024
		ds_read_b128 v[28:31], v15 offset:2048
		ds_read_b128 v[32:35], v15 offset:3072
		ds_read_b128 v[36:39], v15 offset:16384
		ds_read_b128 v[40:43], v15 offset:17408
		ds_read_b128 v[44:47], v15 offset:18432
		ds_read_b128 v[48:51], v15 offset:19456
		ds_read_b128 v[52:55], v16 offset:32768
		ds_read_b128 v[56:59], v16 offset:33792
		ds_read_b128 v[60:63], v16 offset:34816
		ds_read_b128 v[64:67], v16 offset:35840
		ds_read_b128 v[68:71], v16 offset:36864
		ds_read_b128 v[72:75], v16 offset:37888
		ds_read_b128 v[76:79], v16 offset:38912
		ds_read_b128 v[80:83], v16 offset:39936
		ds_read_b128 v[84:87], v16 offset:49152
		ds_read_b128 v[88:91], v16 offset:50176
		ds_read_b128 v[92:95], v16 offset:51200
		ds_read_b128 v[96:99], v16 offset:52224
		ds_read_b128 v[100:103], v16 offset:53248
		ds_read_b128 v[104:107], v16 offset:54272
		ds_read_b128 v[108:111], v16 offset:55296
		ds_read_b128 v[112:115], v16 offset:56320
		v_lshlrev_b32_e32 v15, 9, v6
		v_lshlrev_b32_e32 v6, 3, v2
		v_lshlrev_b32_e32 v2, 10, v7
		s_cmp_lt_i32 0, 30
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
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
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s25, s56, 2
		s_mul_i32 s26, s25, 0x80
		s_lshl_b32 s30, s26, 0
		s_add_i32 s26, s56, 1
		s_and_b32 s32, s56, 1
		s_lshl_b32 s33, s32, 13
		s_add_i32 s32, s33, 0x20000
		v_add3_u32 v236, s32, v15, v6
		ds_read_b64_tr_b8 v[238:239], v236
		ds_read_b64_tr_b8 v[240:241], v236 offset:4096
		v_add3_u32 v236, s32, v6, v2
		ds_read_b64_tr_b8 v[242:243], v236 offset:2048
		ds_read_b64_tr_b8 v[244:245], v236 offset:2560
		ds_read_b64_tr_b8 v[246:247], v236 offset:6144
		ds_read_b64_tr_b8 v[248:249], v236 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[52:55], v[8:11], v238, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[56:59], v[16:19], v238, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[60:63], v[116:119], v238, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[64:67], v[120:123], v238, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[52:55], v[140:143], v238, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[56:59], v[144:147], v238, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[60:63], v[148:151], v238, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[64:67], v[152:155], v238, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[52:55], v[172:175], v238, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[56:59], v[176:179], v238, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[60:63], v[180:183], v238, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[64:67], v[184:187], v238, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[52:55], v[204:207], v238, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[56:59], v[208:211], v238, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[60:63], v[212:215], v238, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[64:67], v[216:219], v238, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[84:87], v[8:11], v240, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[36:39], v[88:91], v[16:19], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[92:95], v[116:119], v240, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[96:99], v[120:123], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[84:87], v[140:143], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[88:91], v[144:147], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[92:95], v[148:151], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[96:99], v[152:155], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[84:87], v[172:175], v240, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[88:91], v[176:179], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[92:95], v[180:183], v240, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[96:99], v[184:187], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[84:87], v[204:207], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[88:91], v[208:211], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[92:95], v[212:215], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[96:99], v[216:219], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mul_i32 s32, s25, 2
		s_and_b32 s33, s25, 1
		s_lshl_b32 s25, s33, 13
		s_add_i32 s43, s24, s25
		s_lshl_b32 s61, s32, 14
		s_add_i32 s64, s27, s61
		v_add_u32_e32 v236, s64, v3
		s_add_i32 s64, s31, s61
		v_add_u32_e32 v237, s64, v3
		s_add_i32 s64, s42, s61
		v_add_u32_e32 v239, s64, v3
		s_add_i32 s64, s60, s61
		v_add_u32_e32 v241, s64, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v236, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x20010
		s_nop 0
		buffer_load_dwordx4 v237, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x20020
		s_nop 0
		buffer_load_dwordx4 v239, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x20030
		s_nop 0
		buffer_load_dwordx4 v241, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s64, s28, s25
		s_add_i32 s25, s57, s61
		v_add_u32_e32 v236, s25, v3
		s_add_i32 s25, s65, s61
		v_add_u32_e32 v237, s25, v3
		s_add_i32 s25, s66, s61
		v_add_u32_e32 v239, s25, v3
		s_add_i32 s25, s67, s61
		v_add_u32_e32 v241, s25, v3
		s_add_i32 s25, s68, s61
		v_add_u32_e32 v242, s25, v3
		s_add_i32 s25, s69, s61
		v_add_u32_e32 v243, s25, v3
		s_add_i32 s25, s70, s61
		v_add_u32_e32 v246, s25, v3
		s_add_i32 s25, s71, s61
		v_add_u32_e32 v247, s25, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s64, 0x20800
		s_nop 0
		buffer_load_dwordx4 v236, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20810
		s_nop 0
		buffer_load_dwordx4 v237, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20820
		s_nop 0
		buffer_load_dwordx4 v239, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20830
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v242, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v243, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v246, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v247, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s25, s32, 1
		s_lshl_b32 s32, s25, 14
		s_add_i32 s25, s27, s32
		v_add_u32_e32 v236, s25, v3
		s_add_i32 s25, s31, s32
		v_add_u32_e32 v237, s25, v3
		s_add_i32 s25, s42, s32
		v_add_u32_e32 v239, s25, v3
		s_add_i32 s25, s60, s32
		v_add_u32_e32 v241, s25, v3
		s_and_saveexec_b64 s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s43, 0x21000
		s_nop 0
		buffer_load_dwordx4 v236, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x21010
		s_nop 0
		buffer_load_dwordx4 v237, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x21020
		s_nop 0
		buffer_load_dwordx4 v239, s[48:51], 0 offen lds
		s_add_i32 m0, s43, 0x21030
		s_nop 0
		buffer_load_dwordx4 v241, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[74:75], s[58:59]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[74:75]
		s_add_i32 s25, s57, s32
		v_add_u32_e32 v236, s25, v3
		s_add_i32 s25, s65, s32
		v_add_u32_e32 v237, s25, v3
		s_add_i32 s25, s66, s32
		v_add_u32_e32 v239, s25, v3
		s_add_i32 s25, s67, s32
		v_add_u32_e32 v241, s25, v3
		s_add_i32 s25, s68, s32
		v_add_u32_e32 v242, s25, v3
		s_add_i32 s25, s69, s32
		v_add_u32_e32 v243, s25, v3
		s_add_i32 s25, s70, s32
		v_add_u32_e32 v246, s25, v3
		s_add_i32 s25, s71, s32
		v_add_u32_e32 v247, s25, v3
		s_and_saveexec_b64 s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s64, 0x21800
		s_nop 0
		buffer_load_dwordx4 v236, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21810
		s_nop 0
		buffer_load_dwordx4 v237, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21820
		s_nop 0
		buffer_load_dwordx4 v239, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21830
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v242, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v243, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v246, s[44:47], 0 offen lds
		s_add_i32 m0, s64, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v247, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[74:75], s[62:63]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[74:75]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[68:71], v[124:127], v238, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[72:75], v[128:131], v238, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[76:79], v[132:135], v238, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[80:83], v[136:139], v238, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[68:71], v[156:159], v238, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[72:75], v[160:163], v238, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[76:79], v[164:167], v238, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[80:83], v[168:171], v238, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[68:71], v[188:191], v238, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[72:75], v[192:195], v238, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[76:79], v[196:199], v238, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[80:83], v[200:203], v238, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[68:71], v[220:223], v238, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[72:75], v[224:227], v238, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[76:79], v[228:231], v238, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[80:83], v[232:235], v238, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[100:103], v[124:127], v240, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[104:107], v[128:131], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[108:111], v[132:135], v240, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[112:115], v[136:139], v240, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[100:103], v[156:159], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[104:107], v[160:163], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[108:111], v[164:167], v240, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[112:115], v[168:171], v240, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[100:103], v[188:191], v240, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[104:107], v[192:195], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[108:111], v[196:199], v240, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[112:115], v[200:203], v240, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[100:103], v[220:223], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_lshl_b32 s25, s33, 16
		s_add_i32 s32, s29, s25
		s_mov_b32 m0, s32
		s_add_i32 s25, s34, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[16:19], 0 offen lds
		s_add_i32 m0, s32, 0x2000
		s_add_i32 s25, s36, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[16:19], 0 offen lds
		s_add_i32 m0, s32, 0x4000
		s_add_i32 s25, s37, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[16:19], 0 offen lds
		s_add_i32 m0, s32, 0x6000
		s_add_i32 s25, s38, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[16:19], 0 offen lds
		s_add_i32 m0, s32, 0x8000
		s_add_i32 s25, s35, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[20:23], 0 offen lds
		s_add_i32 m0, s32, 0xa000
		s_add_i32 s25, s39, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[20:23], 0 offen lds
		s_add_i32 m0, s32, 0xc000
		s_add_i32 s25, s40, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[20:23], 0 offen lds
		s_add_i32 m0, s32, 0xe000
		s_add_i32 s25, s41, s30
		v_add_u32_e32 v236, s25, v5
		buffer_load_dwordx4 v236, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[104:107], v[224:227], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[108:111], v[228:231], v240, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[112:115], v[232:235], v240, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_and_b32 s25, s26, 1
		s_lshl_b32 s30, s25, 16
		v_add_u32_e32 v236, s30, v12
		v_add3_u32 v237, v236, v14, v4
		ds_read_b128 v[20:23], v237
		ds_read_b128 v[24:27], v237 offset:1024
		ds_read_b128 v[28:31], v237 offset:2048
		ds_read_b128 v[32:35], v237 offset:3072
		ds_read_b128 v[36:39], v237 offset:16384
		ds_read_b128 v[40:43], v237 offset:17408
		ds_read_b128 v[44:47], v237 offset:18432
		ds_read_b128 v[48:51], v237 offset:19456
		v_add_u32_e32 v236, s30, v14
		v_add3_u32 v237, v236, v13, v4
		ds_read_b128 v[52:55], v237 offset:32768
		ds_read_b128 v[56:59], v237 offset:33792
		ds_read_b128 v[60:63], v237 offset:34816
		ds_read_b128 v[64:67], v237 offset:35840
		ds_read_b128 v[68:71], v237 offset:36864
		ds_read_b128 v[72:75], v237 offset:37888
		ds_read_b128 v[76:79], v237 offset:38912
		ds_read_b128 v[80:83], v237 offset:39936
		ds_read_b128 v[84:87], v237 offset:49152
		ds_read_b128 v[88:91], v237 offset:50176
		ds_read_b128 v[92:95], v237 offset:51200
		ds_read_b128 v[96:99], v237 offset:52224
		ds_read_b128 v[100:103], v237 offset:53248
		ds_read_b128 v[104:107], v237 offset:54272
		ds_read_b128 v[108:111], v237 offset:55296
		ds_read_b128 v[112:115], v237 offset:56320
		s_cmp_lt_i32 s26, 30
		s_mov_b32 s56, s26
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(8)
		s_barrier
		v_add_u32_e32 v2, 0x20000, v15
		v_add_u32_e32 v3, v2, v6
		ds_read_b64_tr_b8 v[236:237], v3
		v_add_u32_e32 v2, 0x20000, v6
		v_lshl_add_u32 v5, v7, 10, v2
		ds_read_b64_tr_b8 v[238:239], v5 offset:2048
		ds_read_b64_tr_b8 v[240:241], v5 offset:2560
		ds_read_b64_tr_b8 v[242:243], v3 offset:4096
		ds_read_b64_tr_b8 v[244:245], v5 offset:6144
		ds_read_b64_tr_b8 v[246:247], v5 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[52:55], v[8:11], v236, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[56:59], v[16:19], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[60:63], v[116:119], v236, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[64:67], v[120:123], v236, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[68:71], v[124:127], v236, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[72:75], v[128:131], v236, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[76:79], v[132:135], v236, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[80:83], v[136:139], v236, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[52:55], v[140:143], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[56:59], v[144:147], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[60:63], v[148:151], v236, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[64:67], v[152:155], v236, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[68:71], v[156:159], v236, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[72:75], v[160:163], v236, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[76:79], v[164:167], v236, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[80:83], v[168:171], v236, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[52:55], v[172:175], v236, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[56:59], v[176:179], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[60:63], v[180:183], v236, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[64:67], v[184:187], v236, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[68:71], v[188:191], v236, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[72:75], v[192:195], v236, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[76:79], v[196:199], v236, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[80:83], v[200:203], v236, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[52:55], v[204:207], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[56:59], v[208:211], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[60:63], v[212:215], v236, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[64:67], v[216:219], v236, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[68:71], v[220:223], v236, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[72:75], v[224:227], v236, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[76:79], v[228:231], v236, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[80:83], v[232:235], v236, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[84:87], v[8:11], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[36:39], v[88:91], v[16:19], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[92:95], v[116:119], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[96:99], v[120:123], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[100:103], v[124:127], v242, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[104:107], v[128:131], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[108:111], v[132:135], v242, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[112:115], v[136:139], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[84:87], v[140:143], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[88:91], v[144:147], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[92:95], v[148:151], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[96:99], v[152:155], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[100:103], v[156:159], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[104:107], v[160:163], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[108:111], v[164:167], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[112:115], v[168:171], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[84:87], v[172:175], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[88:91], v[176:179], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[92:95], v[180:183], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[96:99], v[184:187], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[100:103], v[188:191], v242, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[104:107], v[192:195], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[108:111], v[196:199], v242, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[112:115], v[200:203], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[84:87], v[204:207], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[88:91], v[208:211], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[92:95], v[212:215], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[96:99], v[216:219], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[100:103], v[220:223], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[104:107], v[224:227], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[108:111], v[228:231], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[112:115], v[232:235], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v12
		v_add3_u32 v7, v2, v14, v4
		ds_read_b128 v[20:23], v7
		ds_read_b128 v[24:27], v7 offset:1024
		ds_read_b128 v[28:31], v7 offset:2048
		ds_read_b128 v[32:35], v7 offset:3072
		ds_read_b128 v[36:39], v7 offset:16384
		ds_read_b128 v[40:43], v7 offset:17408
		ds_read_b128 v[44:47], v7 offset:18432
		ds_read_b128 v[48:51], v7 offset:19456
		v_add_u32_e32 v2, 0x10000, v14
		v_add3_u32 v7, v2, v13, v4
		ds_read_b128 v[12:15], v7 offset:32768
		ds_read_b128 v[52:55], v7 offset:33792
		ds_read_b128 v[56:59], v7 offset:34816
		ds_read_b128 v[60:63], v7 offset:35840
		ds_read_b128 v[64:67], v7 offset:36864
		ds_read_b128 v[68:71], v7 offset:37888
		ds_read_b128 v[72:75], v7 offset:38912
		ds_read_b128 v[76:79], v7 offset:39936
		ds_read_b128 v[80:83], v7 offset:49152
		ds_read_b128 v[84:87], v7 offset:50176
		ds_read_b128 v[88:91], v7 offset:51200
		ds_read_b128 v[92:95], v7 offset:52224
		ds_read_b128 v[96:99], v7 offset:53248
		ds_read_b128 v[100:103], v7 offset:54272
		ds_read_b128 v[104:107], v7 offset:55296
		ds_read_b128 v[108:111], v7 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[112:113], v3 offset:8192
		ds_read_b64_tr_b8 v[114:115], v5 offset:10240
		ds_read_b64_tr_b8 v[236:237], v5 offset:10752
		ds_read_b64_tr_b8 v[238:239], v3 offset:12288
		ds_read_b64_tr_b8 v[2:3], v5 offset:14336
		ds_read_b64_tr_b8 v[240:241], v5 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[12:15], v[8:11], v112, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[52:55], v[16:19], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v112, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[12:15], v[140:143], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[12:15], v[172:175], v112, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v112, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[12:15], v[204:207], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[80:83], v[8:11], v238, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[36:39], v[84:87], v[16:19], v238, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[36:39], v[88:91], v[116:119], v238, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[92:95], v[120:123], v238, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[80:83], v[140:143], v238, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[84:87], v[144:147], v238, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[88:91], v[148:151], v238, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[92:95], v[152:155], v238, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[44:47], v[80:83], v[172:175], v238, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[44:47], v[84:87], v[176:179], v238, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[88:91], v[180:183], v238, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[92:95], v[184:187], v238, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[48:51], v[80:83], v[204:207], v238, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[48:51], v[84:87], v[208:211], v238, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[88:91], v[212:215], v238, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[92:95], v[216:219], v238, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		v_lshl_add_u32 v4, v1, 14, v6
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		s_mov_b32 s16, 0x1000
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:512
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:1024
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		s_mov_b32 s17, 0x2000
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:512
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:1024
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:1536
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		s_mov_b32 s18, 0x3000
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:512
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:1024
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[64:67], v[124:127], v112, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[68:71], v[128:131], v112, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[72:75], v[132:135], v112, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[76:79], v[136:139], v112, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[64:67], v[156:159], v112, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[68:71], v[160:163], v112, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[72:75], v[164:167], v112, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[76:79], v[168:171], v112, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[64:67], v[188:191], v112, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[68:71], v[192:195], v112, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[72:75], v[196:199], v112, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[76:79], v[200:203], v112, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[64:67], v[220:223], v112, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[68:71], v[224:227], v112, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[72:75], v[228:231], v112, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[76:79], v[232:235], v112, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[96:99], v[124:127], v238, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[100:103], v[128:131], v238, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[104:107], v[132:135], v238, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[108:111], v[136:139], v238, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[96:99], v[156:159], v238, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[100:103], v[160:163], v238, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[104:107], v[164:167], v238, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[108:111], v[168:171], v238, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[96:99], v[188:191], v238, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[100:103], v[192:195], v238, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[104:107], v[196:199], v238, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[108:111], v[200:203], v238, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[96:99], v[220:223], v238, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[100:103], v[224:227], v238, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[104:107], v[228:231], v238, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[108:111], v[232:235], v238, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v4, s[52:55], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:2048
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:2560
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:3072
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s16 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:2048
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:2560
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:3072
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s17 offen offset:3584
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:2048
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:2560
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:3072
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v4, s[52:55], s18 offen offset:3584
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
		.amdhsa_next_free_vgpr 250
		.amdhsa_next_free_sgpr 76
		.amdhsa_accum_offset 252
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 250
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 76
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
    .sgpr_count:     76
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     250
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
