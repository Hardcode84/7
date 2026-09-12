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
		s_mov_b32 s0, 0x1000000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s10, s0
		s_mov_b32 s11, s23
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s0
		s_mov_b32 s31, s23
		s_mov_b32 s34, 0x2000000
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		v_readfirstlane_b32 s1, v0
		s_lshr_b32 s12, s1, 6
		s_lshl_b32 s15, s12, 10
		s_add_i32 m0, s15, 16
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshrrev_b32_e32 v4, 3, v2
		v_bitop3_b32 v5, v4, 3, v2 bitop3:0x48
		v_lshlrev_b32_e32 v5, 4, v5
		v_lshl_add_u32 v3, v3, 12, v5
		s_lshl_b32 s18, s0, 16
		s_and_b32 s19, s13, 7
		s_lshr_b32 s19, s19, 1
		s_lshl_b32 s32, s19, 22
		s_add_i32 s33, s18, s32
		s_lshl_b32 s35, s13, 5
		s_lshl_b32 s14, s14, 1
		s_add_i32 s14, s35, s14
		s_lshr_b32 s13, s13, 3
		s_add_i32 s13, s14, s13
		s_and_b32 s13, s13, 63
		s_and_b32 s14, s13, 3
		s_lshl_b32 s35, s14, 20
		s_add_i32 s33, s33, s35
		buffer_load_dwordx4 v3, s[8:11], s33 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s18, 0x80000
		s_add_i32 s37, s36, s32
		s_add_i32 s37, s37, s35
		buffer_load_dwordx4 v3, s[8:11], s37 offen lds
		v_lshlrev_b32_e32 v4, 12, v4
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s37, s18, 64
		s_add_i32 s38, s37, s32
		s_add_i32 s38, s38, s35
		buffer_load_dwordx4 v3, s[8:11], s38 offen lds
		s_lshr_b32 s1, s1, 7
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s38, s18, 0x80040
		s_add_i32 s39, s38, s32
		s_add_i32 s39, s39, s35
		buffer_load_dwordx4 v3, s[8:11], s39 offen lds
		s_lshr_b32 s13, s13, 2
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s39, s13, 20
		s_add_i32 s40, s18, s39
		buffer_load_dwordx4 v3, s[28:31], s40 offen lds
		s_mov_b32 s41, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s36, s39
		buffer_load_dwordx4 v3, s[28:31], s36 offen lds
		v_and_b32_e32 v5, 39, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s37, s39
		buffer_load_dwordx4 v3, s[28:31], s36 offen lds
		v_lshrrev_b32_e32 v6, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s38, s39
		s_lshl_b32 s37, s1, 9
		s_lshl_b32 s1, s1, 6
		s_lshl_b32 s38, s19, 10
		s_add_i32 s42, s1, s38
		s_lshl_b32 s43, s14, 8
		s_add_i32 s44, s1, 16
		s_add_i32 s44, s44, s38
		buffer_load_dwordx4 v3, s[28:31], s36 offen lds
		v_and_or_b32 v7, 1, s0, v5
		s_add_i32 s36, s1, 32
		v_cmp_eq_u32_e64 s[46:47], v7, s41
		s_add_i32 s36, s36, s38
		s_add_i32 s45, s1, 48
		s_add_i32 s45, s45, s38
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s37, 0x20010
		s_add_i32 s42, s42, s43
		buffer_load_dwordx4 v4, s[24:27], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s44, s43
		buffer_load_dwordx4 v4, s[24:27], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s36, s43
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s45, s43
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[66:67]
		v_lshrrev_b32_e32 v6, 1, v6
		v_or_b32_e32 v5, v5, v6
		s_and_b32 s12, s12, 1
		v_cmp_eq_u32_e64 s[44:45], v5, s41
		s_lshl_b32 s36, s12, 10
		s_lshl_b32 s42, s13, 8
		s_lshl_b32 s12, s12, 7
		s_add_i32 s48, s42, 16
		s_add_i32 s49, s42, 32
		s_add_i32 s50, s42, 48
		s_add_i32 s51, s42, 64
		s_add_i32 s52, s42, 0x50
		s_add_i32 s53, s42, 0x60
		s_add_i32 s54, s42, 0x70
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s36, 0x20810
		s_add_i32 s55, s42, s12
		buffer_load_dwordx4 v4, s[20:23], s55 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s48, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s48, s51, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s52, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s53, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s54, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s1, 0x4000
		s_add_i32 s48, s48, s38
		s_add_i32 s49, s1, 0x4010
		s_add_i32 s49, s49, s38
		s_add_i32 s50, s1, 0x4020
		s_add_i32 s50, s50, s38
		s_add_i32 s51, s1, 0x4030
		s_add_i32 s51, s51, s38
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s37, 0x21010
		s_add_i32 s48, s48, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s42, 0x4000
		s_add_i32 s49, s42, 0x4010
		s_add_i32 s50, s42, 0x4020
		s_add_i32 s51, s42, 0x4030
		s_add_i32 s52, s42, 0x4040
		s_add_i32 s53, s42, 0x4050
		s_add_i32 s54, s42, 0x4060
		s_add_i32 s55, s42, 0x4070
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s36, 0x21810
		s_add_i32 s48, s48, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s48, s52, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s53, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s54, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s55, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s1, 0x8000
		s_add_i32 s48, s48, s38
		s_add_i32 s49, s1, 0x8010
		s_add_i32 s49, s49, s38
		s_add_i32 s50, s1, 0x8020
		s_add_i32 s50, s50, s38
		s_add_i32 s51, s1, 0x8030
		s_add_i32 s51, s51, s38
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s37, 0x22010
		s_add_i32 s48, s48, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s42, 0x8000
		s_add_i32 s49, s42, 0x8010
		s_add_i32 s50, s42, 0x8020
		s_add_i32 s51, s42, 0x8030
		s_add_i32 s52, s42, 0x8040
		s_add_i32 s53, s42, 0x8050
		s_add_i32 s54, s42, 0x8060
		s_add_i32 s55, s42, 0x8070
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s36, 0x22810
		s_add_i32 s48, s48, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s48, s52, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s53, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s54, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s55, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s1, 0xc000
		s_add_i32 s48, s48, s38
		s_add_i32 s49, s1, 0xc010
		s_add_i32 s49, s49, s38
		s_add_i32 s50, s1, 0xc020
		s_add_i32 s50, s50, s38
		s_add_i32 s51, s1, 0xc030
		s_add_i32 s51, s51, s38
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s37, 0x23010
		s_add_i32 s48, s48, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s43
		buffer_load_dwordx4 v4, s[24:27], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s48, s42, 0xc000
		s_add_i32 s49, s42, 0xc010
		s_add_i32 s50, s42, 0xc020
		s_add_i32 s51, s42, 0xc030
		s_add_i32 s52, s42, 0xc040
		s_add_i32 s53, s42, 0xc050
		s_add_i32 s54, s42, 0xc060
		s_add_i32 s55, s42, 0xc070
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s36, 0x23810
		s_add_i32 s48, s48, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s49, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s50, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s51, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s48, s52, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s53, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s54, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s48, s55, s12
		buffer_load_dwordx4 v4, s[20:23], s48 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[66:67]
		v_add_u32_e32 v5, s40, v3
		v_add_u32_e32 v6, s33, v3
		s_add_i32 m0, s15, 0x10010
		s_add_i32 s33, s18, 0x80
		s_add_i32 s40, s33, s32
		s_add_i32 s40, s40, s35
		buffer_load_dwordx4 v3, s[8:11], s40 offen lds
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s18, 0x80080
		s_add_i32 s5, s4, s32
		s_add_i32 s5, s5, s35
		buffer_load_dwordx4 v3, s[8:11], s5 offen lds
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s18, 0xc0
		s_add_i32 s3, s2, s32
		s_add_i32 s3, s3, s35
		buffer_load_dwordx4 v3, s[8:11], s3 offen lds
		v_lshrrev_b32_e32 v7, 4, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s18, 0x800c0
		s_add_i32 s5, s3, s32
		s_add_i32 s5, s5, s35
		buffer_load_dwordx4 v3, s[8:11], s5 offen lds
		v_and_b32_e32 v12, 15, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s5, s33, s39
		buffer_load_dwordx4 v3, s[28:31], s5 offen lds
		s_and_b32 s5, s0, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s4, s39
		buffer_load_dwordx4 v3, s[28:31], s4 offen lds
		v_lshlrev_b32_e32 v0, 1, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s2, s39
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		s_lshr_b32 s0, s0, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s3, s39
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v0, 2, v0
		s_lshl_b32 s3, s0, 12
		s_lshl_b32 s4, s5, 13
		s_lshl_b32 s18, s0, 9
		s_add_i32 s18, s18, 0x20000
		s_lshl_b32 s32, s5, 10
		s_add_i32 s32, s32, 0x20000
		s_add_i32 s33, s1, 0x10000
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v3, 6, v12
		v_lshrrev_b32_e32 v12, 1, v12
		v_bitop3_b32 v12, v7, v12, 3 bitop3:0x78
		v_lshlrev_b32_e32 v12, 4, v12
		v_add3_u32 v13, s3, v3, v12
		v_add_u32_e32 v13, 16, v13
		ds_read_b128 v[16:19], v13
		ds_read_b128 v[20:23], v13 offset:1024
		ds_read_b128 v[24:27], v13 offset:2048
		ds_read_b128 v[28:31], v13 offset:3072
		ds_read_b128 v[32:35], v13 offset:16384
		ds_read_b128 v[36:39], v13 offset:17408
		ds_read_b128 v[40:43], v13 offset:18432
		ds_read_b128 v[44:47], v13 offset:19456
		v_add3_u32 v13, s4, v3, v12
		v_add_u32_e32 v13, 16, v13
		ds_read_b128 v[48:51], v13 offset:32768
		ds_read_b128 v[52:55], v13 offset:33792
		ds_read_b128 v[56:59], v13 offset:34816
		ds_read_b128 v[60:63], v13 offset:35840
		ds_read_b128 v[64:67], v13 offset:36864
		ds_read_b128 v[68:71], v13 offset:37888
		ds_read_b128 v[72:75], v13 offset:38912
		ds_read_b128 v[76:79], v13 offset:39936
		ds_read_b128 v[80:83], v13 offset:49152
		ds_read_b128 v[84:87], v13 offset:50176
		ds_read_b128 v[88:91], v13 offset:51200
		ds_read_b128 v[92:95], v13 offset:52224
		ds_read_b128 v[96:99], v13 offset:53248
		ds_read_b128 v[100:103], v13 offset:54272
		ds_read_b128 v[104:107], v13 offset:55296
		ds_read_b128 v[108:111], v13 offset:56320
		v_add_u32_e32 v13, 0x100, v6
		v_add_u32_e32 v14, 0x80100, v6
		v_add_u32_e32 v15, 0x140, v6
		v_add_u32_e32 v6, 0x80140, v6
		v_add_u32_e32 v112, 0x100, v5
		v_add_u32_e32 v113, 0x80100, v5
		v_add_u32_e32 v114, 0x140, v5
		v_add_u32_e32 v5, 0x80140, v5
		v_lshlrev_b32_e32 v115, 7, v7
		s_add_i32 s2, s33, s38
		s_add_i32 s2, s2, s43
		s_add_i32 s33, s1, 0x10010
		s_add_i32 s33, s33, s38
		s_add_i32 s33, s33, s43
		s_add_i32 s35, s1, 0x10020
		s_add_i32 s35, s35, s38
		s_add_i32 s35, s35, s43
		s_add_i32 s39, s1, 0x10030
		s_add_i32 s39, s39, s38
		s_add_i32 s39, s39, s43
		s_add_i32 s40, s42, 0x10000
		s_add_i32 s40, s40, s12
		s_add_i32 s48, s42, 0x10010
		s_add_i32 s48, s48, s12
		s_add_i32 s49, s42, 0x10020
		s_add_i32 s49, s49, s12
		s_add_i32 s50, s42, 0x10030
		s_add_i32 s50, s50, s12
		s_add_i32 s51, s42, 0x10040
		s_add_i32 s51, s51, s12
		s_add_i32 s52, s42, 0x10050
		s_add_i32 s52, s52, s12
		s_add_i32 s53, s42, 0x10060
		s_add_i32 s53, s53, s12
		s_add_i32 s54, s42, 0x10070
		s_add_i32 s54, s54, s12
		s_add_i32 s55, s1, 0x14000
		s_add_i32 s55, s55, s38
		s_add_i32 s55, s55, s43
		s_add_i32 s56, s1, 0x14010
		s_add_i32 s56, s56, s38
		s_add_i32 s56, s56, s43
		s_add_i32 s57, s1, 0x14020
		s_add_i32 s57, s57, s38
		s_add_i32 s57, s57, s43
		s_add_i32 s1, s1, 0x14030
		s_add_i32 s1, s1, s38
		s_add_i32 s1, s1, s43
		s_add_i32 s38, s42, 0x14000
		s_add_i32 s38, s38, s12
		s_add_i32 s43, s42, 0x14010
		s_add_i32 s43, s43, s12
		s_add_i32 s58, s42, 0x14020
		s_add_i32 s58, s58, s12
		s_add_i32 s59, s42, 0x14030
		s_add_i32 s59, s59, s12
		s_add_i32 s60, s42, 0x14040
		s_add_i32 s60, s60, s12
		s_add_i32 s61, s42, 0x14050
		s_add_i32 s61, s61, s12
		s_add_i32 s62, s42, 0x14060
		s_add_i32 s62, s62, s12
		s_add_i32 s42, s42, 0x14070
		s_add_i32 s12, s42, s12
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt vmcnt(8) lgkmcnt(0)
		s_barrier
		s_and_b32 s42, s41, 1
		s_lshl_b32 s42, s42, 13
		s_add_i32 s63, s18, s42
		v_add3_u32 v240, s63, v115, v0
		v_add_u32_e32 v240, 16, v240
		ds_read_b64_tr_b8 v[242:243], v240
		s_add_i32 s63, s32, s42
		v_add3_u32 v241, s63, v115, v0
		v_add_u32_e32 v241, 16, v241
		ds_read_b64_tr_b8 v[244:245], v241 offset:2048
		ds_read_b64_tr_b8 v[246:247], v241 offset:2560
		ds_read_b64_tr_b8 v[248:249], v240 offset:4096
		ds_read_b64_tr_b8 v[250:251], v241 offset:6144
		ds_read_b64_tr_b8 v[252:253], v241 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v242, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v242, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v242, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v242, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v242, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v242, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v242, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v242, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v242, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v242, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v248, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v248, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v248, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v248, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v248, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v248, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v248, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v248, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v248, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v248, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s63, s37, s42
		s_lshl_b32 s64, s41, 15
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s63, 0x20010
		s_add_i32 s65, s2, s64
		buffer_load_dwordx4 v4, s[24:27], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s33, s64
		buffer_load_dwordx4 v4, s[24:27], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s35, s64
		buffer_load_dwordx4 v4, s[24:27], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s39, s64
		buffer_load_dwordx4 v4, s[24:27], s65 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s42, s36, s42
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s42, 0x20810
		s_add_i32 s65, s40, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s48, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s49, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s50, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s65, s51, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s52, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s53, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s65, s54, s64
		buffer_load_dwordx4 v4, s[20:23], s65 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[66:67]
		s_and_saveexec_b64 s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s63, 0x21010
		s_add_i32 s63, s55, s64
		buffer_load_dwordx4 v4, s[24:27], s63 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s63, s56, s64
		buffer_load_dwordx4 v4, s[24:27], s63 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s63, s57, s64
		buffer_load_dwordx4 v4, s[24:27], s63 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s63, s1, s64
		buffer_load_dwordx4 v4, s[24:27], s63 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[66:67], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[66:67]
		s_and_saveexec_b64 s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s42, 0x21810
		s_add_i32 s42, s38, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s43, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s58, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s59, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s42, s60, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s61, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s62, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s12, s64
		buffer_load_dwordx4 v4, s[20:23], s42 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[66:67], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[66:67]
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v242, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s15, 16
		s_add_i32 s15, s15, 0x10000
		buffer_load_dwordx4 v13, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v242, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[76:79], v[140:143], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[76:79], v[172:175], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v15, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v6, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v242, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v112, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v242, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v113, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v114, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[76:79], v[204:207], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[76:79], v[236:239], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[108:111], v[140:143], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[108:111], v[172:175], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[108:111], v[204:207], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[108:111], v[236:239], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_add_i32 s41, s41, 1
		s_and_b32 s42, s41, 1
		s_lshl_b32 s42, s42, 16
		s_add_i32 s63, s3, s42
		v_add3_u32 v16, s63, v3, v12
		v_add_u32_e32 v48, 16, v16
		ds_read_b128 v[16:19], v48
		ds_read_b128 v[20:23], v48 offset:1024
		ds_read_b128 v[24:27], v48 offset:2048
		ds_read_b128 v[28:31], v48 offset:3072
		ds_read_b128 v[32:35], v48 offset:16384
		ds_read_b128 v[36:39], v48 offset:17408
		ds_read_b128 v[40:43], v48 offset:18432
		ds_read_b128 v[44:47], v48 offset:19456
		s_add_i32 s42, s4, s42
		v_add3_u32 v48, s42, v3, v12
		v_add_u32_e32 v240, 16, v48
		ds_read_b128 v[48:51], v240 offset:32768
		ds_read_b128 v[52:55], v240 offset:33792
		ds_read_b128 v[56:59], v240 offset:34816
		ds_read_b128 v[60:63], v240 offset:35840
		ds_read_b128 v[64:67], v240 offset:36864
		ds_read_b128 v[68:71], v240 offset:37888
		ds_read_b128 v[72:75], v240 offset:38912
		ds_read_b128 v[76:79], v240 offset:39936
		ds_read_b128 v[80:83], v240 offset:49152
		ds_read_b128 v[84:87], v240 offset:50176
		ds_read_b128 v[88:91], v240 offset:51200
		ds_read_b128 v[92:95], v240 offset:52224
		ds_read_b128 v[96:99], v240 offset:53248
		ds_read_b128 v[100:103], v240 offset:54272
		ds_read_b128 v[104:107], v240 offset:55296
		ds_read_b128 v[108:111], v240 offset:56320
		s_and_b32 s15, s15, 0x1ffff
		s_add_u32 s8, s8, 0x80
		s_addc_u32 s9, s9, 0
		s_add_u32 s28, s28, 0x80
		s_addc_u32 s29, s29, 0
		s_cmp_lt_i32 s41, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add3_u32 v4, s18, v115, v0
		v_add3_u32 v0, s32, v115, v0
		v_add_u32_e32 v4, 16, v4
		ds_read_b64_tr_b8 v[14:15], v4
		v_add_u32_e32 v0, 16, v0
		ds_read_b64_tr_b8 v[112:113], v0 offset:2048
		ds_read_b64_tr_b8 v[114:115], v0 offset:2560
		ds_read_b64_tr_b8 v[240:241], v4 offset:4096
		ds_read_b64_tr_b8 v[242:243], v0 offset:6144
		ds_read_b64_tr_b8 v[244:245], v0 offset:6656
		v_mov_b32_e32 v5, 1
		s_and_saveexec_b64 s[8:9], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v6, v1, v5
		s_mov_b64 exec, s[8:9]
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v14, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v14, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v14, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v14, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v14, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[76:79], v[140:143], v14, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[76:79], v[172:175], v14, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v14, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v14, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v14, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v14, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v14, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v14, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v14, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v14, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v14, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[76:79], v[204:207], v14, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[76:79], v[236:239], v14, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v14, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v14, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v240, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v240, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[108:111], v[140:143], v240, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[108:111], v[172:175], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v240, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v240, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v240, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v240, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v240, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[108:111], v[204:207], v240, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[108:111], v[236:239], v240, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_and_b32 s1, s1, -8
		s_add_i32 s1, s1, 8
		s_and_saveexec_b64 s[8:9], s[16:17]
		ds_read_b32 v5, v1
		s_xor_b32 s1, s1, -1
		s_add_i32 s1, s1, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s2, v5
		s_add_i32 s2, s2, s1
		s_cmp_ge_u32 s2, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v5, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s2, v5
		s_add_i32 s2, s2, s1
		s_cmp_ge_u32 s2, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[8:9]
		s_add_i32 s1, s3, 0x10000
		v_add3_u32 v1, s1, v3, v12
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[16:19], v1
		ds_read_b128 v[20:23], v1 offset:1024
		ds_read_b128 v[24:27], v1 offset:2048
		ds_read_b128 v[28:31], v1 offset:3072
		ds_read_b128 v[32:35], v1 offset:16384
		ds_read_b128 v[36:39], v1 offset:17408
		ds_read_b128 v[40:43], v1 offset:18432
		ds_read_b128 v[44:47], v1 offset:19456
		s_add_i32 s1, s4, 0x10000
		v_add3_u32 v1, s1, v3, v12
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[12:15], v1 offset:32768
		ds_read_b128 v[48:51], v1 offset:33792
		ds_read_b128 v[52:55], v1 offset:34816
		ds_read_b128 v[56:59], v1 offset:35840
		ds_read_b128 v[60:63], v1 offset:36864
		ds_read_b128 v[64:67], v1 offset:37888
		ds_read_b128 v[68:71], v1 offset:38912
		ds_read_b128 v[72:75], v1 offset:39936
		ds_read_b128 v[76:79], v1 offset:49152
		ds_read_b128 v[80:83], v1 offset:50176
		ds_read_b128 v[84:87], v1 offset:51200
		ds_read_b128 v[88:91], v1 offset:52224
		ds_read_b128 v[92:95], v1 offset:53248
		ds_read_b128 v[96:99], v1 offset:54272
		ds_read_b128 v[100:103], v1 offset:55296
		ds_read_b128 v[104:107], v1 offset:56320
		v_and_b32_e32 v1, 15, v2
		v_lshlrev_b32_e32 v1, 13, v1
		v_lshl_add_u32 v1, v7, 3, v1
		s_lshl_b32 s0, s0, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[2:3], v4 offset:8192
		ds_read_b64_tr_b8 v[6:7], v0 offset:10240
		ds_read_b64_tr_b8 v[108:109], v0 offset:10752
		ds_read_b64_tr_b8 v[110:111], v4 offset:12288
		ds_read_b64_tr_b8 v[4:5], v0 offset:14336
		ds_read_b64_tr_b8 v[112:113], v0 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[12:15], v[8:11], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s13, 21
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s19, 11
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[48:51], v[116:119], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s2, s3
		s_lshl_b32 s4, s5, 20
		s_add_i32 s2, s2, s4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v2, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_lshl_b32 s5, s14, 9
		s_add_i32 s2, s2, s5
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[12:15], v[144:147], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[12:15], v[176:179], v2, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[12:15], v[208:211], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[76:79], v[8:11], v110, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[80:83], v[116:119], v110, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v110, v4 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v110, v4 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v110, v4 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[76:79], v[144:147], v110, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v110, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v110, v4 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v110, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v110, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v6, v8, v9
		v_cvt_pk_f16_f32 v7, v10, v11
		v_cvt_pk_f16_f32 v8, v116, v117
		v_cvt_pk_f16_f32 v9, v118, v119
		v_cvt_pk_f16_f32 v10, v120, v121
		v_cvt_pk_f16_f32 v11, v122, v123
		v_cvt_pk_f16_f32 v12, v124, v125
		v_cvt_pk_f16_f32 v13, v126, v127
		v_cvt_pk_f16_f32 v14, v144, v145
		v_cvt_pk_f16_f32 v15, v146, v147
		v_cvt_pk_f16_f32 v48, v148, v149
		v_cvt_pk_f16_f32 v49, v150, v151
		v_cvt_pk_f16_f32 v50, v152, v153
		v_cvt_pk_f16_f32 v51, v154, v155
		v_cvt_pk_f16_f32 v52, v156, v157
		v_cvt_pk_f16_f32 v53, v158, v159
		v_cvt_pk_f16_f32 v54, v184, v185
		v_cvt_pk_f16_f32 v55, v186, v187
		v_cvt_pk_f16_f32 v56, v216, v217
		v_cvt_pk_f16_f32 v57, v218, v219
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s35, s23
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[6:7], v1, s[32:35], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[76:79], v[176:179], v110, v4 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[76:79], v[208:211], v110, v4 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v110, v4 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v110, v4 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v110, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v110, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s6, s0, 0x20000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		v_cvt_pk_f16_f32 v4, v176, v177
		v_cvt_pk_f16_f32 v5, v178, v179
		v_cvt_pk_f16_f32 v6, v180, v181
		v_cvt_pk_f16_f32 v7, v182, v183
		v_cvt_pk_f16_f32 v58, v188, v189
		v_cvt_pk_f16_f32 v59, v190, v191
		v_cvt_pk_f16_f32 v76, v208, v209
		v_cvt_pk_f16_f32 v77, v210, v211
		v_cvt_pk_f16_f32 v78, v212, v213
		v_cvt_pk_f16_f32 v79, v214, v215
		v_cvt_pk_f16_f32 v80, v220, v221
		v_cvt_pk_f16_f32 v81, v222, v223
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		buffer_store_dwordx2 v[8:9], v1, s[32:35], s6 offen
		s_add_i32 s7, s0, 0x40000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		s_add_i32 s7, s7, s5
		buffer_store_dwordx2 v[10:11], v1, s[32:35], s7 offen
		s_add_i32 s8, s0, 0x60000
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s3
		s_add_i32 s8, s8, s4
		s_add_i32 s8, s8, s5
		buffer_store_dwordx2 v[12:13], v1, s[32:35], s8 offen
		buffer_store_dwordx2 v[14:15], v1, s[32:35], s2 offen offset:32
		buffer_store_dwordx2 v[48:49], v1, s[32:35], s6 offen offset:32
		buffer_store_dwordx2 v[50:51], v1, s[32:35], s7 offen offset:32
		buffer_store_dwordx2 v[52:53], v1, s[32:35], s8 offen offset:32
		buffer_store_dwordx2 v[4:5], v1, s[32:35], s2 offen offset:64
		buffer_store_dwordx2 v[6:7], v1, s[32:35], s6 offen offset:64
		buffer_store_dwordx2 v[54:55], v1, s[32:35], s7 offen offset:64
		buffer_store_dwordx2 v[58:59], v1, s[32:35], s8 offen offset:64
		buffer_store_dwordx2 v[76:77], v1, s[32:35], s2 offen offset:96
		buffer_store_dwordx2 v[78:79], v1, s[32:35], s6 offen offset:96
		buffer_store_dwordx2 v[56:57], v1, s[32:35], s7 offen offset:96
		buffer_store_dwordx2 v[80:81], v1, s[32:35], s8 offen offset:96
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v2, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s0, 0x80000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v2, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s5
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v2, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v2, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v2, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v2, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v2, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v2, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v2, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v2, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v2, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v2, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v2, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v2, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v2, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v2, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v110, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v110, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v110, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		v_cvt_pk_f16_f32 v4, v132, v133
		v_cvt_pk_f16_f32 v5, v134, v135
		v_cvt_pk_f16_f32 v6, v136, v137
		v_cvt_pk_f16_f32 v7, v138, v139
		v_cvt_pk_f16_f32 v8, v140, v141
		v_cvt_pk_f16_f32 v9, v142, v143
		v_cvt_pk_f16_f32 v10, v160, v161
		v_cvt_pk_f16_f32 v11, v162, v163
		v_cvt_pk_f16_f32 v12, v164, v165
		v_cvt_pk_f16_f32 v13, v166, v167
		v_cvt_pk_f16_f32 v14, v168, v169
		v_cvt_pk_f16_f32 v15, v170, v171
		v_cvt_pk_f16_f32 v16, v172, v173
		v_cvt_pk_f16_f32 v17, v174, v175
		v_cvt_pk_f16_f32 v18, v200, v201
		v_cvt_pk_f16_f32 v19, v202, v203
		v_cvt_pk_f16_f32 v20, v232, v233
		v_cvt_pk_f16_f32 v21, v234, v235
		buffer_store_dwordx2 v[2:3], v1, s[32:35], s2 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v110, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 s6, s0, 0xa0000
		s_add_i32 s6, s6, s1
		s_add_i32 s6, s6, s3
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		v_cvt_pk_f16_f32 v22, v196, v197
		v_cvt_pk_f16_f32 v23, v198, v199
		v_cvt_pk_f16_f32 v24, v204, v205
		v_cvt_pk_f16_f32 v25, v206, v207
		v_cvt_pk_f16_f32 v26, v224, v225
		v_cvt_pk_f16_f32 v27, v226, v227
		v_cvt_pk_f16_f32 v28, v228, v229
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		buffer_store_dwordx2 v[4:5], v1, s[32:35], s6 offen
		s_add_i32 s7, s0, 0xc0000
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s3
		s_add_i32 s7, s7, s4
		s_add_i32 s7, s7, s5
		buffer_store_dwordx2 v[6:7], v1, s[32:35], s7 offen
		s_add_i32 s0, s0, 0xe0000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		s_add_i32 s0, s0, s4
		v_cvt_pk_f16_f32 v29, v230, v231
		v_cvt_pk_f16_f32 v4, v236, v237
		v_cvt_pk_f16_f32 v5, v238, v239
		s_add_i32 s0, s0, s5
		buffer_store_dwordx2 v[8:9], v1, s[32:35], s0 offen
		buffer_store_dwordx2 v[10:11], v1, s[32:35], s2 offen offset:32
		buffer_store_dwordx2 v[12:13], v1, s[32:35], s6 offen offset:32
		buffer_store_dwordx2 v[14:15], v1, s[32:35], s7 offen offset:32
		buffer_store_dwordx2 v[16:17], v1, s[32:35], s0 offen offset:32
		buffer_store_dwordx2 v[2:3], v1, s[32:35], s2 offen offset:64
		buffer_store_dwordx2 v[22:23], v1, s[32:35], s6 offen offset:64
		buffer_store_dwordx2 v[18:19], v1, s[32:35], s7 offen offset:64
		buffer_store_dwordx2 v[24:25], v1, s[32:35], s0 offen offset:64
		buffer_store_dwordx2 v[26:27], v1, s[32:35], s2 offen offset:96
		buffer_store_dwordx2 v[28:29], v1, s[32:35], s6 offen offset:96
		buffer_store_dwordx2 v[20:21], v1, s[32:35], s7 offen offset:96
		buffer_store_dwordx2 v[4:5], v1, s[32:35], s0 offen offset:96
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
		.amdhsa_next_free_vgpr 254
		.amdhsa_next_free_sgpr 68
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 68
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
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     254
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 1
    wave.regalloc.agpr.dwords: 0
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
