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
		v_readfirstlane_b32 s2, v0
		s_lshr_b32 s3, s13, 3
		v_lshrrev_b32_e32 v1, 6, v0
		s_lshl_b32 s4, s14, 1
		v_and_b32_e32 v2, 63, v0
		s_add_i32 s5, s4, s3
		v_lshrrev_b32_e32 v3, 2, v2
		s_and_b32 s3, s13, 7
		v_lshrrev_b32_e32 v4, 3, v2
		s_lshl_b32 s4, s3, 5
		v_and_b32_e32 v5, 3, v4
		s_add_i32 s3, s5, s4
		v_and_b32_e32 v6, 3, v2
		s_lshr_b32 s4, s3, 6
		v_xor_b32_e32 v7, v5, v6
		s_lshl_b32 s5, s4, 23
		v_lshlrev_b32_e32 v5, 12, v3
		s_and_b32 s12, s3, 63
		v_lshl_add_u32 v3, v1, 16, v5
		s_lshr_b32 s3, s12, 2
		v_lshl_add_u32 v5, v7, 4, v3
		s_lshl_b32 s13, s3, 17
		s_add_i32 s14, s5, s13
		s_and_b32 s5, s12, 3
		s_lshl_b32 s12, s5, 21
		s_add_i32 s13, s14, s12
		s_add_u32 s14, s6, s13
		s_addc_u32 s15, s7, 0
		s_lshr_b32 s6, s2, 6
		s_lshl_b32 s7, s6, 10
		s_mov_b32 m0, s7
		s_lshl_b32 s12, s4, 22
		s_lshl_b32 s13, s5, 20
		s_add_i32 s24, s12, s13
		v_add_u32_e32 v3, s24, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 s25, s7, 0x2000
		s_mov_b32 m0, s25
		s_add_i32 s26, s12, 0x80000
		s_add_i32 s27, s26, s13
		v_add_u32_e32 v3, s27, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 s26, s7, 0x4000
		s_mov_b32 m0, s26
		s_add_i32 s28, s12, 64
		s_add_i32 s29, s28, s13
		v_add_u32_e32 v3, s29, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 s28, s7, 0x6000
		s_mov_b32 m0, s28
		s_add_i32 s30, s12, 0x80040
		s_add_i32 s31, s30, s13
		v_add_u32_e32 v3, s31, v5
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 s30, s7, 0x8000
		s_mov_b32 m0, s30
		s_lshl_b32 s32, s3, 20
		v_add_u32_e32 v3, s32, v5
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s33, s7, 0xa000
		s_add_i32 s34, s32, 0x80000
		v_add_u32_e32 v3, s34, v5
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s35, s7, 0xc000
		s_add_i32 s36, s32, 64
		v_add_u32_e32 v3, s36, v5
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s37, s7, 0xe000
		s_add_i32 s38, s32, 0x80040
		v_add_u32_e32 v3, s38, v5
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_lshr_b32 s39, s2, 7
		v_lshlrev_b32_e32 v3, 12, v4
		s_lshl_b32 s2, s39, 9
		v_and_b32_e32 v4, 39, v0
		s_lshl_b32 s40, s4, 10
		v_and_or_b32 v6, 1, v1, v4
		s_lshl_b32 s4, s39, 6
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 s39, s40, s4
		s_mov_b32 s44, s10
		s_mov_b32 s45, s11
		s_mov_b32 s46, 0x7fffffff
		s_mov_b32 s47, 0x31016000
		s_mov_b32 s48, s8
		s_mov_b32 s49, s9
		s_mov_b32 s50, 0x7fffffff
		s_mov_b32 s51, 0x31016000
		s_mov_b32 s8, s14
		s_mov_b32 s9, s15
		s_mov_b32 s10, 0x20000
		s_mov_b32 s11, 0x31016000
		s_lshl_b32 s0, s5, 8
		s_add_i32 s1, s39, s0
		v_add_u32_e32 v7, s1, v3
		s_add_i32 s5, s40, 16
		s_add_i32 s14, s5, s4
		s_add_i32 s5, s14, s0
		v_add_u32_e32 v12, s5, v3
		s_add_i32 s14, s40, 32
		s_add_i32 s15, s14, s4
		s_add_i32 s14, s15, s0
		v_add_u32_e32 v13, s14, v3
		s_add_i32 s15, s40, 48
		s_add_i32 s39, s15, s4
		s_mov_b32 s15, 0
		v_cmp_eq_u32_e64 vcc, v6, s15
		s_mov_b64 s[42:43], vcc
		s_add_i32 s41, s39, s0
		v_add_u32_e32 v6, s41, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s2, 0x20000
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x20010
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x20020
		s_nop 0
		buffer_load_dwordx4 v13, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x20030
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[64:65]
		v_lshrrev_b32_e32 v6, 1, v1
		v_or_b32_e32 v7, v4, v6
		v_cmp_eq_u32_e64 vcc, v7, s15
		s_mov_b64 s[52:53], vcc
		s_and_b32 s39, s6, 1
		s_lshl_b32 s6, s39, 10
		s_lshl_b32 s54, s3, 8
		s_lshl_b32 s3, s39, 7
		s_add_i32 s39, s54, s3
		v_add_u32_e32 v4, s39, v3
		s_add_i32 s55, s54, 16
		s_add_i32 s56, s55, s3
		v_add_u32_e32 v6, s56, v3
		s_add_i32 s55, s54, 32
		s_add_i32 s57, s55, s3
		v_add_u32_e32 v7, s57, v3
		s_add_i32 s55, s54, 48
		s_add_i32 s58, s55, s3
		v_add_u32_e32 v12, s58, v3
		s_add_i32 s55, s54, 64
		s_add_i32 s59, s55, s3
		v_add_u32_e32 v13, s59, v3
		s_add_i32 s55, s54, 0x50
		s_add_i32 s60, s55, s3
		v_add_u32_e32 v14, s60, v3
		s_add_i32 s55, s54, 0x60
		s_add_i32 s61, s55, s3
		v_add_u32_e32 v15, s61, v3
		s_add_i32 s55, s54, 0x70
		s_add_i32 s62, s55, s3
		v_add_u32_e32 v16, s62, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s6, 0x20800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s55, s40, 0x4000
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v4, s55, v3
		s_add_i32 s55, s40, 0x4010
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v6, s55, v3
		s_add_i32 s55, s40, 0x4020
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v7, s55, v3
		s_add_i32 s55, s40, 0x4030
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v12, s55, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s2, 0x21000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x21010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x21020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x21030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s55, s54, 0x4000
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v4, s63, v3
		s_add_i32 s55, s54, 0x4010
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v6, s63, v3
		s_add_i32 s55, s54, 0x4020
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v7, s63, v3
		s_add_i32 s55, s54, 0x4030
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v12, s63, v3
		s_add_i32 s55, s54, 0x4040
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v13, s63, v3
		s_add_i32 s55, s54, 0x4050
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v14, s63, v3
		s_add_i32 s55, s54, 0x4060
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v15, s63, v3
		s_add_i32 s55, s54, 0x4070
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v16, s63, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s6, 0x21800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s55, s40, 0x8000
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v4, s55, v3
		s_add_i32 s55, s40, 0x8010
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v6, s55, v3
		s_add_i32 s55, s40, 0x8020
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v7, s55, v3
		s_add_i32 s55, s40, 0x8030
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v12, s55, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s2, 0x22000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x22010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x22020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x22030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s55, s54, 0x8000
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v4, s63, v3
		s_add_i32 s55, s54, 0x8010
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v6, s63, v3
		s_add_i32 s55, s54, 0x8020
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v7, s63, v3
		s_add_i32 s55, s54, 0x8030
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v12, s63, v3
		s_add_i32 s55, s54, 0x8040
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v13, s63, v3
		s_add_i32 s55, s54, 0x8050
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v14, s63, v3
		s_add_i32 s55, s54, 0x8060
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v15, s63, v3
		s_add_i32 s55, s54, 0x8070
		s_add_i32 s63, s55, s3
		v_add_u32_e32 v16, s63, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s6, 0x22800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s55, s40, 0xc000
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v4, s55, v3
		s_add_i32 s55, s40, 0xc010
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v6, s55, v3
		s_add_i32 s55, s40, 0xc020
		s_add_i32 s63, s55, s4
		s_add_i32 s55, s63, s0
		v_add_u32_e32 v7, s55, v3
		s_add_i32 s55, s40, 0xc030
		s_add_i32 s40, s55, s4
		s_add_i32 s4, s40, s0
		v_add_u32_e32 v12, s4, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s2, 0x23000
		s_nop 0
		buffer_load_dwordx4 v4, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x23010
		s_nop 0
		buffer_load_dwordx4 v6, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x23020
		s_nop 0
		buffer_load_dwordx4 v7, s[48:51], 0 offen lds
		s_add_i32 m0, s2, 0x23030
		s_nop 0
		buffer_load_dwordx4 v12, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s0, s54, 0xc000
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v4, s4, v3
		s_add_i32 s0, s54, 0xc010
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v6, s4, v3
		s_add_i32 s0, s54, 0xc020
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v7, s4, v3
		s_add_i32 s0, s54, 0xc030
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v12, s4, v3
		s_add_i32 s0, s54, 0xc040
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v13, s4, v3
		s_add_i32 s0, s54, 0xc050
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v14, s4, v3
		s_add_i32 s0, s54, 0xc060
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v15, s4, v3
		s_add_i32 s0, s54, 0xc070
		s_add_i32 s4, s0, s3
		v_add_u32_e32 v16, s4, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s6, 0x23800
		s_nop 0
		buffer_load_dwordx4 v4, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23810
		s_nop 0
		buffer_load_dwordx4 v6, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23820
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23830
		s_nop 0
		buffer_load_dwordx4 v12, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v13, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v14, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s6, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[64:65]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s0, s12, 0x80
		s_add_i32 s3, s0, s13
		v_add_u32_e32 v4, s3, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		s_add_i32 s0, s12, 0x80080
		s_add_i32 s3, s0, s13
		v_add_u32_e32 v4, s3, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		s_add_i32 s0, s12, 0xc0
		s_add_i32 s3, s0, s13
		v_add_u32_e32 v4, s3, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		s_add_i32 s0, s12, 0x800c0
		s_add_i32 s3, s0, s13
		v_add_u32_e32 v4, s3, v5
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s0, s32, 0x80
		v_add_u32_e32 v4, s0, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		s_add_i32 s0, s32, 0x80080
		v_add_u32_e32 v4, s0, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		s_add_i32 s0, s32, 0xc0
		v_add_u32_e32 v4, s0, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		s_add_i32 s0, s32, 0x800c0
		v_add_u32_e32 v4, s0, v5
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_and_b32_e32 v4, 15, v0
		v_lshrrev_b32_e32 v6, 1, v4
		v_lshrrev_b32_e32 v7, 4, v2
		v_and_b32_e32 v12, 3, v6
		v_lshrrev_b32_e32 v6, 7, v0
		v_xor_b32_e32 v0, v7, v12
		v_and_b32_e32 v7, 1, v1
		v_lshlrev_b32_e32 v12, 12, v6
		v_lshlrev_b32_e32 v13, 6, v4
		v_lshlrev_b32_e32 v4, 4, v0
		v_lshlrev_b32_e32 v0, 13, v7
		v_add3_u32 v14, v12, v13, v4
		v_add3_u32 v15, v13, v0, v4
		ds_read_b128 v[16:19], v14
		ds_read_b128 v[20:23], v14 offset:1024
		ds_read_b128 v[24:27], v14 offset:2048
		ds_read_b128 v[28:31], v14 offset:3072
		ds_read_b128 v[32:35], v14 offset:16384
		ds_read_b128 v[36:39], v14 offset:17408
		ds_read_b128 v[40:43], v14 offset:18432
		ds_read_b128 v[44:47], v14 offset:19456
		ds_read_b128 v[48:51], v15 offset:32768
		ds_read_b128 v[52:55], v15 offset:33792
		ds_read_b128 v[56:59], v15 offset:34816
		ds_read_b128 v[60:63], v15 offset:35840
		ds_read_b128 v[64:67], v15 offset:36864
		ds_read_b128 v[68:71], v15 offset:37888
		ds_read_b128 v[72:75], v15 offset:38912
		ds_read_b128 v[76:79], v15 offset:39936
		ds_read_b128 v[80:83], v15 offset:49152
		ds_read_b128 v[84:87], v15 offset:50176
		ds_read_b128 v[88:91], v15 offset:51200
		ds_read_b128 v[92:95], v15 offset:52224
		ds_read_b128 v[96:99], v15 offset:53248
		ds_read_b128 v[100:103], v15 offset:54272
		ds_read_b128 v[104:107], v15 offset:55296
		ds_read_b128 v[108:111], v15 offset:56320
		v_lshlrev_b32_e32 v14, 9, v6
		v_lshlrev_b32_e32 v6, 3, v2
		v_lshlrev_b32_e32 v2, 10, v7
		s_cmp_lt_i32 0, 30
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
		s_add_i32 s0, s15, 2
		s_mul_i32 s3, s0, 0x80
		s_add_i32 s4, s15, 1
		s_and_b32 s12, s15, 1
		s_lshl_b32 s13, s12, 13
		s_add_i32 s12, s13, 0x20000
		v_add3_u32 v15, s12, v14, v6
		ds_read_b64_tr_b8 v[236:237], v15
		ds_read_b64_tr_b8 v[238:239], v15 offset:4096
		v_add3_u32 v15, s12, v6, v2
		ds_read_b64_tr_b8 v[240:241], v15 offset:2048
		ds_read_b64_tr_b8 v[242:243], v15 offset:2560
		ds_read_b64_tr_b8 v[244:245], v15 offset:6144
		ds_read_b64_tr_b8 v[246:247], v15 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v236, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[52:55], v[112:115], v236, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[56:59], v[116:119], v236, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[60:63], v[120:123], v236, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[48:51], v[140:143], v236, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[52:55], v[144:147], v236, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[56:59], v[148:151], v236, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[60:63], v[152:155], v236, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[48:51], v[172:175], v236, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[52:55], v[176:179], v236, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[56:59], v[180:183], v236, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[60:63], v[184:187], v236, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[48:51], v[204:207], v236, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[52:55], v[208:211], v236, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[56:59], v[212:215], v236, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[60:63], v[216:219], v236, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v238, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[84:87], v[112:115], v238, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[88:91], v[116:119], v238, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[92:95], v[120:123], v238, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[80:83], v[140:143], v238, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[84:87], v[144:147], v238, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[88:91], v[148:151], v238, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[92:95], v[152:155], v238, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[80:83], v[172:175], v238, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[84:87], v[176:179], v238, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[88:91], v[180:183], v238, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[92:95], v[184:187], v238, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[80:83], v[204:207], v238, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[84:87], v[208:211], v238, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[88:91], v[212:215], v238, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[92:95], v[216:219], v238, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mul_i32 s12, s0, 2
		s_and_b32 s13, s0, 1
		s_lshl_b32 s0, s13, 13
		s_add_i32 s13, s2, s0
		s_lshl_b32 s40, s12, 14
		s_add_i32 s54, s1, s40
		v_add_u32_e32 v15, s54, v3
		s_add_i32 s54, s5, s40
		v_add_u32_e32 v237, s54, v3
		s_add_i32 s54, s14, s40
		v_add_u32_e32 v239, s54, v3
		s_add_i32 s54, s41, s40
		v_add_u32_e32 v240, s54, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s13, 0x20000
		s_nop 0
		buffer_load_dwordx4 v15, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x20010
		s_nop 0
		buffer_load_dwordx4 v237, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x20020
		s_nop 0
		buffer_load_dwordx4 v239, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x20030
		s_nop 0
		buffer_load_dwordx4 v240, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s54, s6, s0
		s_add_i32 s0, s39, s40
		v_add_u32_e32 v15, s0, v3
		s_add_i32 s0, s56, s40
		v_add_u32_e32 v237, s0, v3
		s_add_i32 s0, s57, s40
		v_add_u32_e32 v239, s0, v3
		s_add_i32 s0, s58, s40
		v_add_u32_e32 v240, s0, v3
		s_add_i32 s0, s59, s40
		v_add_u32_e32 v241, s0, v3
		s_add_i32 s0, s60, s40
		v_add_u32_e32 v244, s0, v3
		s_add_i32 s0, s61, s40
		v_add_u32_e32 v245, s0, v3
		s_add_i32 s0, s62, s40
		v_add_u32_e32 v248, s0, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s54, 0x20800
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20810
		s_nop 0
		buffer_load_dwordx4 v237, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20820
		s_nop 0
		buffer_load_dwordx4 v239, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20830
		s_nop 0
		buffer_load_dwordx4 v240, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v244, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v245, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v248, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s0, s12, 1
		s_lshl_b32 s12, s0, 14
		s_add_i32 s0, s1, s12
		v_add_u32_e32 v15, s0, v3
		s_add_i32 s0, s5, s12
		v_add_u32_e32 v237, s0, v3
		s_add_i32 s0, s14, s12
		v_add_u32_e32 v239, s0, v3
		s_add_i32 s0, s41, s12
		v_add_u32_e32 v240, s0, v3
		s_and_saveexec_b64 s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s13, 0x21000
		s_nop 0
		buffer_load_dwordx4 v15, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x21010
		s_nop 0
		buffer_load_dwordx4 v237, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x21020
		s_nop 0
		buffer_load_dwordx4 v239, s[48:51], 0 offen lds
		s_add_i32 m0, s13, 0x21030
		s_nop 0
		buffer_load_dwordx4 v240, s[48:51], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[64:65], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s0, s39, s12
		v_add_u32_e32 v15, s0, v3
		s_add_i32 s0, s56, s12
		v_add_u32_e32 v237, s0, v3
		s_add_i32 s0, s57, s12
		v_add_u32_e32 v239, s0, v3
		s_add_i32 s0, s58, s12
		v_add_u32_e32 v240, s0, v3
		s_add_i32 s0, s59, s12
		v_add_u32_e32 v241, s0, v3
		s_add_i32 s0, s60, s12
		v_add_u32_e32 v244, s0, v3
		s_add_i32 s0, s61, s12
		v_add_u32_e32 v245, s0, v3
		s_add_i32 s0, s62, s12
		v_add_u32_e32 v248, s0, v3
		s_and_saveexec_b64 s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s54, 0x21800
		s_nop 0
		buffer_load_dwordx4 v15, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21810
		s_nop 0
		buffer_load_dwordx4 v237, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21820
		s_nop 0
		buffer_load_dwordx4 v239, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21830
		s_nop 0
		buffer_load_dwordx4 v240, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v241, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v244, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v245, s[44:47], 0 offen lds
		s_add_i32 m0, s54, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v248, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[64:65], s[52:53]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[64:65]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[64:67], v[124:127], v236, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[68:71], v[128:131], v236, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[72:75], v[132:135], v236, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[76:79], v[136:139], v236, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[64:67], v[156:159], v236, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[68:71], v[160:163], v236, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[72:75], v[164:167], v236, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[76:79], v[168:171], v236, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[64:67], v[188:191], v236, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[68:71], v[192:195], v236, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[72:75], v[196:199], v236, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[76:79], v[200:203], v236, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[64:67], v[220:223], v236, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[68:71], v[224:227], v236, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[72:75], v[228:231], v236, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[76:79], v[232:235], v236, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[96:99], v[124:127], v238, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[100:103], v[128:131], v238, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[104:107], v[132:135], v238, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[108:111], v[136:139], v238, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[96:99], v[156:159], v238, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[100:103], v[160:163], v238, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[104:107], v[164:167], v238, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[108:111], v[168:171], v238, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[96:99], v[188:191], v238, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[100:103], v[192:195], v238, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[104:107], v[196:199], v238, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[108:111], v[200:203], v238, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[96:99], v[220:223], v238, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s7
		s_add_i32 s0, s24, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_mov_b32 m0, s25
		s_add_i32 s0, s27, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_mov_b32 m0, s26
		s_add_i32 s0, s29, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_mov_b32 m0, s28
		s_add_i32 s0, s31, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_mov_b32 m0, s30
		s_add_i32 s0, s32, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_add_i32 s0, s34, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_add_i32 s0, s36, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_mov_b32 m0, s37
		s_add_i32 s0, s38, s3
		v_add_u32_e32 v15, s0, v5
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[100:103], v[224:227], v238, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[104:107], v[228:231], v238, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[108:111], v[232:235], v238, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_and_b32 s0, s4, 1
		s_lshl_b32 s3, s0, 16
		v_add_u32_e32 v15, s3, v12
		v_add3_u32 v236, v15, v13, v4
		ds_read_b128 v[16:19], v236
		ds_read_b128 v[20:23], v236 offset:1024
		ds_read_b128 v[24:27], v236 offset:2048
		ds_read_b128 v[28:31], v236 offset:3072
		ds_read_b128 v[32:35], v236 offset:16384
		ds_read_b128 v[36:39], v236 offset:17408
		ds_read_b128 v[40:43], v236 offset:18432
		ds_read_b128 v[44:47], v236 offset:19456
		v_add_u32_e32 v15, s3, v13
		v_add3_u32 v236, v15, v0, v4
		ds_read_b128 v[48:51], v236 offset:32768
		ds_read_b128 v[52:55], v236 offset:33792
		ds_read_b128 v[56:59], v236 offset:34816
		ds_read_b128 v[60:63], v236 offset:35840
		ds_read_b128 v[64:67], v236 offset:36864
		ds_read_b128 v[68:71], v236 offset:37888
		ds_read_b128 v[72:75], v236 offset:38912
		ds_read_b128 v[76:79], v236 offset:39936
		ds_read_b128 v[80:83], v236 offset:49152
		ds_read_b128 v[84:87], v236 offset:50176
		ds_read_b128 v[88:91], v236 offset:51200
		ds_read_b128 v[92:95], v236 offset:52224
		ds_read_b128 v[96:99], v236 offset:53248
		ds_read_b128 v[100:103], v236 offset:54272
		ds_read_b128 v[104:107], v236 offset:55296
		ds_read_b128 v[108:111], v236 offset:56320
		s_add_i32 s0, s7, 0x10000
		s_and_b32 s7, s0, 0x1ffff
		s_add_i32 s0, s25, 0x10000
		s_and_b32 s25, s0, 0x1ffff
		s_add_i32 s0, s26, 0x10000
		s_and_b32 s26, s0, 0x1ffff
		s_add_i32 s0, s28, 0x10000
		s_and_b32 s28, s0, 0x1ffff
		s_add_i32 s0, s30, 0x10000
		s_and_b32 s30, s0, 0x1ffff
		s_add_i32 s0, s33, 0x10000
		s_and_b32 s33, s0, 0x1ffff
		s_add_i32 s0, s35, 0x10000
		s_and_b32 s35, s0, 0x1ffff
		s_add_i32 s0, s37, 0x10000
		s_and_b32 s37, s0, 0x1ffff
		s_cmp_lt_i32 s4, 30
		s_mov_b32 s15, s4
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(8)
		s_barrier
		v_add_u32_e32 v2, 0x20000, v14
		v_add_u32_e32 v3, v2, v6
		ds_read_b64_tr_b8 v[14:15], v3
		v_add_u32_e32 v2, 0x20000, v6
		v_lshl_add_u32 v5, v7, 10, v2
		ds_read_b64_tr_b8 v[236:237], v5 offset:2048
		ds_read_b64_tr_b8 v[238:239], v5 offset:2560
		ds_read_b64_tr_b8 v[240:241], v3 offset:4096
		ds_read_b64_tr_b8 v[242:243], v5 offset:6144
		ds_read_b64_tr_b8 v[244:245], v5 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v14, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[52:55], v[112:115], v14, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[56:59], v[116:119], v14, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[60:63], v[120:123], v14, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[64:67], v[124:127], v14, v238 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[68:71], v[128:131], v14, v238 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[72:75], v[132:135], v14, v238 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[76:79], v[136:139], v14, v238 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[48:51], v[140:143], v14, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[52:55], v[144:147], v14, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[56:59], v[148:151], v14, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[60:63], v[152:155], v14, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[64:67], v[156:159], v14, v238 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[68:71], v[160:163], v14, v238 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[72:75], v[164:167], v14, v238 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[76:79], v[168:171], v14, v238 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[48:51], v[172:175], v14, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[52:55], v[176:179], v14, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[56:59], v[180:183], v14, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[60:63], v[184:187], v14, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[64:67], v[188:191], v14, v238 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[68:71], v[192:195], v14, v238 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[72:75], v[196:199], v14, v238 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[76:79], v[200:203], v14, v238 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[48:51], v[204:207], v14, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[52:55], v[208:211], v14, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[56:59], v[212:215], v14, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[60:63], v[216:219], v14, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[64:67], v[220:223], v14, v238 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[68:71], v[224:227], v14, v238 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[72:75], v[228:231], v14, v238 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[76:79], v[232:235], v14, v238 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[84:87], v[112:115], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[88:91], v[116:119], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[92:95], v[120:123], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[96:99], v[124:127], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[100:103], v[128:131], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[104:107], v[132:135], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[108:111], v[136:139], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[80:83], v[140:143], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[84:87], v[144:147], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[88:91], v[148:151], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[92:95], v[152:155], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[96:99], v[156:159], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[100:103], v[160:163], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[104:107], v[164:167], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[108:111], v[168:171], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[80:83], v[172:175], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[84:87], v[176:179], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[88:91], v[180:183], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[92:95], v[184:187], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[96:99], v[188:191], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[100:103], v[192:195], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[104:107], v[196:199], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[108:111], v[200:203], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[80:83], v[204:207], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[84:87], v[208:211], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[88:91], v[212:215], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[92:95], v[216:219], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[96:99], v[220:223], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[100:103], v[224:227], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[104:107], v[228:231], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[108:111], v[232:235], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v12
		v_add3_u32 v7, v2, v13, v4
		ds_read_b128 v[16:19], v7
		ds_read_b128 v[20:23], v7 offset:1024
		ds_read_b128 v[24:27], v7 offset:2048
		ds_read_b128 v[28:31], v7 offset:3072
		ds_read_b128 v[32:35], v7 offset:16384
		ds_read_b128 v[36:39], v7 offset:17408
		ds_read_b128 v[40:43], v7 offset:18432
		ds_read_b128 v[44:47], v7 offset:19456
		v_add_u32_e32 v2, 0x10000, v13
		v_add3_u32 v7, v2, v0, v4
		ds_read_b128 v[12:15], v7 offset:32768
		ds_read_b128 v[48:51], v7 offset:33792
		ds_read_b128 v[52:55], v7 offset:34816
		ds_read_b128 v[56:59], v7 offset:35840
		ds_read_b128 v[60:63], v7 offset:36864
		ds_read_b128 v[64:67], v7 offset:37888
		ds_read_b128 v[68:71], v7 offset:38912
		ds_read_b128 v[72:75], v7 offset:39936
		ds_read_b128 v[76:79], v7 offset:49152
		ds_read_b128 v[80:83], v7 offset:50176
		ds_read_b128 v[84:87], v7 offset:51200
		ds_read_b128 v[88:91], v7 offset:52224
		ds_read_b128 v[92:95], v7 offset:53248
		ds_read_b128 v[96:99], v7 offset:54272
		ds_read_b128 v[100:103], v7 offset:55296
		ds_read_b128 v[104:107], v7 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[108:109], v3 offset:8192
		ds_read_b64_tr_b8 v[110:111], v5 offset:10240
		ds_read_b64_tr_b8 v[236:237], v5 offset:10752
		ds_read_b64_tr_b8 v[238:239], v3 offset:12288
		ds_read_b64_tr_b8 v[2:3], v5 offset:14336
		ds_read_b64_tr_b8 v[240:241], v5 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[12:15], v[8:11], v108, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[48:51], v[112:115], v108, v110 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v108, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v108, v110 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[12:15], v[140:143], v108, v110 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v108, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v108, v110 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v108, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[12:15], v[172:175], v108, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v108, v110 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v108, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v108, v110 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[12:15], v[204:207], v108, v110 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v108, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v108, v110 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v108, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[76:79], v[8:11], v238, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[80:83], v[112:115], v238, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v238, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v238, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[76:79], v[140:143], v238, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v238, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v238, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v238, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[76:79], v[172:175], v238, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v238, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v238, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v238, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[76:79], v[204:207], v238, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v238, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v238, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v238, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		v_lshl_add_u32 v0, v1, 14, v6
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		s_mov_b32 s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		s_mov_b32 s1, 0x2000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:512
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:1536
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		s_mov_b32 s2, 0x3000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v108, v236 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v108, v236 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v108, v236 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v108, v236 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v108, v236 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v108, v236 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v108, v236 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v108, v236 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v108, v236 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v108, v236 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v108, v236 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v108, v236 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v108, v236 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v108, v236 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v108, v236 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v108, v236 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v238, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v238, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v238, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v238, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v238, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v238, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v238, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v238, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v238, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v238, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v238, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v238, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v238, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v238, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v238, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v238, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:3584
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
		.amdhsa_next_free_vgpr 249
		.amdhsa_next_free_sgpr 66
		.amdhsa_accum_offset 252
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 249
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 66
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
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     66
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     249
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
