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
		s_lshl_b32 s0, s14, 1
		s_lshr_b32 s1, s13, 3
		s_add_i32 s0, s0, s1
		s_and_b32 s1, s13, 7
		s_lshl_b32 s12, s1, 5
		s_add_i32 s0, s0, s12
		s_and_b32 s0, s0, 63
		s_lshr_b32 s12, s0, 2
		s_lshl_b32 s13, s12, 17
		s_lshr_b32 s1, s1, 1
		s_lshl_b32 s14, s1, 23
		s_add_i32 s13, s13, s14
		s_and_b32 s0, s0, 3
		s_lshl_b32 s14, s0, 21
		s_add_i32 s13, s13, s14
		s_add_u32 s32, s6, s13
		s_addc_u32 s33, s7, 0
		s_mov_b32 s34, 0x20000
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
		s_lshl_b32 s14, s1, 22
		s_lshl_b32 s15, s0, 20
		s_add_i32 s18, s14, s15
		buffer_load_dwordx4 v3, s[8:11], s18 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s19, s14, 0x80000
		s_add_i32 s19, s19, s15
		buffer_load_dwordx4 v3, s[8:11], s19 offen lds
		v_lshrrev_b32_e32 v5, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s19, s14, 64
		s_add_i32 s19, s19, s15
		buffer_load_dwordx4 v3, s[8:11], s19 offen lds
		s_lshl_b32 s1, s1, 10
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s19, s14, 0x80040
		s_add_i32 s19, s19, s15
		buffer_load_dwordx4 v3, s[8:11], s19 offen lds
		v_lshlrev_b32_e32 v4, 12, v4
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s19, s12, 20
		buffer_load_dwordx4 v3, s[28:31], s19 offen lds
		s_lshr_b32 s6, s6, 7
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s35, s19, 0x80000
		buffer_load_dwordx4 v3, s[28:31], s35 offen lds
		s_mov_b32 s35, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s19, 64
		buffer_load_dwordx4 v3, s[28:31], s36 offen lds
		v_and_b32_e32 v6, 39, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s36, s19, 0x80040
		s_lshl_b32 s37, s6, 9
		s_lshl_b32 s6, s6, 6
		s_add_i32 s38, s6, s1
		s_lshl_b32 s0, s0, 8
		s_add_i32 s39, s6, 16
		s_add_i32 s39, s39, s1
		s_add_i32 s40, s6, 32
		s_add_i32 s40, s40, s1
		s_add_i32 s41, s6, 48
		s_add_i32 s41, s41, s1
		v_and_or_b32 v7, 1, s7, v6
		buffer_load_dwordx4 v3, s[28:31], s36 offen lds
		v_cmp_eq_u32_e64 s[42:43], v7, s35
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s37, 0x20010
		s_add_i32 s36, s38, s0
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s39, s0
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s40, s0
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s41, s0
		buffer_load_dwordx4 v4, s[24:27], s36 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[58:59]
		v_lshrrev_b32_e32 v7, 1, v5
		v_or_b32_e32 v6, v6, v7
		s_and_b32 s36, s7, 1
		v_cmp_eq_u32_e64 s[38:39], v6, s35
		s_lshl_b32 s40, s36, 10
		s_lshl_b32 s12, s12, 8
		s_lshl_b32 s36, s36, 7
		s_add_i32 s41, s12, 16
		s_add_i32 s44, s12, 32
		s_add_i32 s45, s12, 48
		s_add_i32 s46, s12, 64
		s_add_i32 s47, s12, 0x50
		s_add_i32 s48, s12, 0x60
		s_add_i32 s49, s12, 0x70
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s40, 0x20810
		s_add_i32 s50, s12, s36
		buffer_load_dwordx4 v4, s[20:23], s50 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s41, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s41, s46, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s47, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s48, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s49, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s6, 0x4000
		s_add_i32 s41, s41, s1
		s_add_i32 s44, s6, 0x4010
		s_add_i32 s44, s44, s1
		s_add_i32 s45, s6, 0x4020
		s_add_i32 s45, s45, s1
		s_add_i32 s46, s6, 0x4030
		s_add_i32 s46, s46, s1
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s37, 0x21010
		s_add_i32 s41, s41, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s12, 0x4000
		s_add_i32 s44, s12, 0x4010
		s_add_i32 s45, s12, 0x4020
		s_add_i32 s46, s12, 0x4030
		s_add_i32 s47, s12, 0x4040
		s_add_i32 s48, s12, 0x4050
		s_add_i32 s49, s12, 0x4060
		s_add_i32 s50, s12, 0x4070
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s40, 0x21810
		s_add_i32 s41, s41, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s41, s47, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s48, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s49, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s50, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s6, 0x8000
		s_add_i32 s41, s41, s1
		s_add_i32 s44, s6, 0x8010
		s_add_i32 s44, s44, s1
		s_add_i32 s45, s6, 0x8020
		s_add_i32 s45, s45, s1
		s_add_i32 s46, s6, 0x8030
		s_add_i32 s46, s46, s1
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s37, 0x22010
		s_add_i32 s41, s41, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s12, 0x8000
		s_add_i32 s44, s12, 0x8010
		s_add_i32 s45, s12, 0x8020
		s_add_i32 s46, s12, 0x8030
		s_add_i32 s47, s12, 0x8040
		s_add_i32 s48, s12, 0x8050
		s_add_i32 s49, s12, 0x8060
		s_add_i32 s50, s12, 0x8070
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s40, 0x22810
		s_add_i32 s41, s41, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s41, s47, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s48, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s49, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s50, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s6, 0xc000
		s_add_i32 s41, s41, s1
		s_add_i32 s44, s6, 0xc010
		s_add_i32 s44, s44, s1
		s_add_i32 s45, s6, 0xc020
		s_add_i32 s45, s45, s1
		s_add_i32 s46, s6, 0xc030
		s_add_i32 s46, s46, s1
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s37, 0x23010
		s_add_i32 s41, s41, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s0
		buffer_load_dwordx4 v4, s[24:27], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s41, s12, 0xc000
		s_add_i32 s44, s12, 0xc010
		s_add_i32 s45, s12, 0xc020
		s_add_i32 s46, s12, 0xc030
		s_add_i32 s47, s12, 0xc040
		s_add_i32 s48, s12, 0xc050
		s_add_i32 s49, s12, 0xc060
		s_add_i32 s50, s12, 0xc070
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s40, 0x23810
		s_add_i32 s41, s41, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s44, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s45, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s46, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s41, s47, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s48, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s49, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s41, s50, s36
		buffer_load_dwordx4 v4, s[20:23], s41 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[58:59]
		s_add_i32 m0, s13, 0x10010
		s_add_i32 s41, s14, 0x80
		s_add_i32 s41, s41, s15
		buffer_load_dwordx4 v3, s[8:11], s41 offen lds
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s4, s14, 0x80080
		s_add_i32 s4, s4, s15
		buffer_load_dwordx4 v3, s[8:11], s4 offen lds
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s14, 0xc0
		s_add_i32 s2, s2, s15
		buffer_load_dwordx4 v3, s[8:11], s2 offen lds
		v_add_u32_e32 v6, s19, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s14, 0x800c0
		s_add_i32 s2, s2, s15
		buffer_load_dwordx4 v3, s[8:11], s2 offen lds
		v_add_u32_e32 v7, s18, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s19, 0x80
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		v_and_b32_e32 v5, 1, v5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s19, 0x80080
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		v_lshrrev_b32_e32 v12, 4, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s19, 0xc0
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		v_lshrrev_b32_e32 v13, 7, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s19, 0x800c0
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v2, 3, v2
		s_add_i32 s3, s6, 0x10000
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s0
		s_add_i32 s4, s6, 0x10010
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s0
		s_add_i32 s5, s6, 0x10020
		s_add_i32 s5, s5, s1
		s_add_i32 s5, s5, s0
		s_add_i32 s14, s6, 0x10030
		buffer_load_dwordx4 v3, s[28:31], s2 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v3, 12, v13
		v_lshlrev_b32_e32 v14, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v12, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v12, v3, v14, v0
		v_add_u32_e32 v12, 16, v12
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		ds_read_b128 v[32:35], v12 offset:16384
		ds_read_b128 v[36:39], v12 offset:17408
		ds_read_b128 v[40:43], v12 offset:18432
		ds_read_b128 v[44:47], v12 offset:19456
		v_lshlrev_b32_e32 v12, 13, v5
		v_add3_u32 v15, v14, v12, v0
		v_add_u32_e32 v15, 16, v15
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
		v_add_u32_e32 v15, 0x100, v7
		v_add_u32_e32 v112, 0x80100, v7
		v_add_u32_e32 v113, 0x140, v7
		v_add_u32_e32 v114, 0x80140, v7
		v_add_u32_e32 v7, 0x100, v6
		v_add_u32_e32 v115, 0x80100, v6
		v_add_u32_e32 v116, 0x140, v6
		v_add_u32_e32 v117, 0x80140, v6
		v_lshlrev_b32_e32 v6, 9, v13
		v_lshlrev_b32_e32 v13, 10, v5
		s_add_i32 s2, s14, s1
		s_add_i32 s2, s2, s0
		s_add_i32 s14, s12, 0x10000
		s_add_i32 s14, s14, s36
		s_add_i32 s15, s12, 0x10010
		s_add_i32 s15, s15, s36
		s_add_i32 s18, s12, 0x10020
		s_add_i32 s18, s18, s36
		s_add_i32 s19, s12, 0x10030
		s_add_i32 s19, s19, s36
		s_add_i32 s41, s12, 0x10040
		s_add_i32 s41, s41, s36
		s_add_i32 s44, s12, 0x10050
		s_add_i32 s44, s44, s36
		s_add_i32 s45, s12, 0x10060
		s_add_i32 s45, s45, s36
		s_add_i32 s46, s12, 0x10070
		s_add_i32 s46, s46, s36
		s_add_i32 s47, s6, 0x14000
		s_add_i32 s47, s47, s1
		s_add_i32 s47, s47, s0
		s_add_i32 s48, s6, 0x14010
		s_add_i32 s48, s48, s1
		s_add_i32 s48, s48, s0
		s_add_i32 s49, s6, 0x14020
		s_add_i32 s49, s49, s1
		s_add_i32 s49, s49, s0
		s_add_i32 s6, s6, 0x14030
		s_add_i32 s1, s6, s1
		s_add_i32 s0, s1, s0
		s_add_i32 s1, s12, 0x14000
		s_add_i32 s1, s1, s36
		s_add_i32 s6, s12, 0x14010
		s_add_i32 s6, s6, s36
		s_add_i32 s50, s12, 0x14020
		s_add_i32 s50, s50, s36
		s_add_i32 s51, s12, 0x14030
		s_add_i32 s51, s51, s36
		s_add_i32 s52, s12, 0x14040
		s_add_i32 s52, s52, s36
		s_add_i32 s53, s12, 0x14050
		s_add_i32 s53, s53, s36
		s_add_i32 s54, s12, 0x14060
		s_add_i32 s54, s54, s36
		s_add_i32 s12, s12, 0x14070
		s_add_i32 s12, s12, s36
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
		s_and_b32 s36, s35, 1
		s_lshl_b32 s36, s36, 13
		s_add_i32 s55, s36, 0x20000
		v_add3_u32 v118, s55, v6, v2
		v_add_u32_e32 v118, 16, v118
		ds_read_b64_tr_b8 v[244:245], v118
		v_add3_u32 v119, s55, v2, v13
		v_add_u32_e32 v119, 16, v119
		ds_read_b64_tr_b8 v[246:247], v119 offset:2048
		ds_read_b64_tr_b8 v[248:249], v119 offset:2560
		ds_read_b64_tr_b8 v[250:251], v118 offset:4096
		ds_read_b64_tr_b8 v[252:253], v119 offset:6144
		ds_read_b64_tr_b8 v[254:255], v119 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s55, s37, s36
		s_lshl_b32 s56, s35, 15
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s55, 0x20010
		s_add_i32 s57, s3, s56
		buffer_load_dwordx4 v4, s[24:27], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s4, s56
		buffer_load_dwordx4 v4, s[24:27], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s5, s56
		buffer_load_dwordx4 v4, s[24:27], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s2, s56
		buffer_load_dwordx4 v4, s[24:27], s57 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s36, s40, s36
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s36, 0x20810
		s_add_i32 s57, s14, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s15, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s18, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s19, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s57, s41, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s44, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s45, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s57, s46, s56
		buffer_load_dwordx4 v4, s[20:23], s57 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s55, 0x21010
		s_add_i32 s55, s47, s56
		buffer_load_dwordx4 v4, s[24:27], s55 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s55, s48, s56
		buffer_load_dwordx4 v4, s[24:27], s55 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s55, s49, s56
		buffer_load_dwordx4 v4, s[24:27], s55 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s55, s0, s56
		buffer_load_dwordx4 v4, s[24:27], s55 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s36, 0x21810
		s_add_i32 s36, s1, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s6, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s50, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s51, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s36, s52, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s53, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s54, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s36, s12, s56
		buffer_load_dwordx4 v4, s[20:23], s36 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[58:59], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[58:59]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s36, s13, 0x10000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s13, 16
		s_add_i32 s35, s35, 1
		buffer_load_dwordx4 v15, s[8:11], 0 offen lds
		s_and_b32 s13, s36, 0x1ffff
		s_add_i32 m0, m0, 0x2000
		s_and_b32 s36, s35, 1
		buffer_load_dwordx4 v112, s[8:11], 0 offen lds
		s_lshl_b32 s36, s36, 16
		s_add_i32 m0, m0, 0x2000
		v_add_u32_e32 v16, s36, v3
		buffer_load_dwordx4 v113, s[8:11], 0 offen lds
		v_add3_u32 v16, v16, v14, v0
		s_add_i32 m0, m0, 0x2000
		v_add_u32_e32 v17, s36, v14
		buffer_load_dwordx4 v114, s[8:11], 0 offen lds
		v_add3_u32 v17, v17, v12, v0
		s_add_i32 m0, m0, 0x2000
		s_add_u32 s8, s8, 0x80
		s_addc_u32 s9, s9, 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v115, s[28:31], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v116, s[28:31], 0 offen lds
		v_add_u32_e32 v118, 16, v17
		s_add_i32 m0, m0, 0x2000
		v_add_u32_e32 v48, 16, v16
		buffer_load_dwordx4 v117, s[28:31], 0 offen lds
		s_add_u32 s28, s28, 0x80
		s_addc_u32 s29, s29, 0
		s_cmp_lt_i32 s35, 30
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v48
		ds_read_b128 v[20:23], v48 offset:1024
		ds_read_b128 v[24:27], v48 offset:2048
		ds_read_b128 v[28:31], v48 offset:3072
		ds_read_b128 v[32:35], v48 offset:16384
		ds_read_b128 v[36:39], v48 offset:17408
		ds_read_b128 v[40:43], v48 offset:18432
		ds_read_b128 v[44:47], v48 offset:19456
		ds_read_b128 v[48:51], v118 offset:32768
		ds_read_b128 v[52:55], v118 offset:33792
		ds_read_b128 v[56:59], v118 offset:34816
		ds_read_b128 v[60:63], v118 offset:35840
		ds_read_b128 v[64:67], v118 offset:36864
		ds_read_b128 v[68:71], v118 offset:37888
		ds_read_b128 v[72:75], v118 offset:38912
		ds_read_b128 v[76:79], v118 offset:39936
		ds_read_b128 v[80:83], v118 offset:49152
		ds_read_b128 v[84:87], v118 offset:50176
		ds_read_b128 v[88:91], v118 offset:51200
		ds_read_b128 v[92:95], v118 offset:52224
		ds_read_b128 v[96:99], v118 offset:53248
		ds_read_b128 v[100:103], v118 offset:54272
		ds_read_b128 v[104:107], v118 offset:55296
		ds_read_b128 v[108:111], v118 offset:56320
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, 0x20000, v6
		v_add_u32_e32 v4, v4, v2
		v_add_u32_e32 v4, 16, v4
		ds_read_b64_tr_b8 v[6:7], v4
		v_add_u32_e32 v13, 0x20000, v2
		v_lshl_add_u32 v5, v5, 10, v13
		v_add_u32_e32 v5, 16, v5
		ds_read_b64_tr_b8 v[112:113], v5 offset:2048
		ds_read_b64_tr_b8 v[114:115], v5 offset:2560
		ds_read_b64_tr_b8 v[116:117], v4 offset:4096
		ds_read_b64_tr_b8 v[118:119], v5 offset:6144
		ds_read_b64_tr_b8 v[244:245], v5 offset:6656
		v_mov_b32_e32 v13, 1
		s_and_saveexec_b64 s[0:1], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v15, v1, v13
		s_mov_b64 exec, s[0:1]
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v6, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v6, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v6, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v6, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v6, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v6, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v6, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v6, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v6, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v6, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v6, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v6, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v6, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v6, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v6, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v6, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v6, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v6, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v6, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v6, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v6, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v6, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v6, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v6, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v6, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v6, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v6, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v6, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v6, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v6, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v6, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v6, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v116, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v116, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v116, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v116, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v116, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v116, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v116, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v116, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v116, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v116, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v116, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v116, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v116, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v116, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v116, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v116, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v116, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v116, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v116, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v116, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v116, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v116, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v116, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v116, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v116, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v116, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v116, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v116, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v116, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v116, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v116, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v116, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s0, v15
		s_and_b32 s0, s0, -8
		s_add_i32 s0, s0, 8
		s_and_saveexec_b64 s[2:3], s[16:17]
		ds_read_b32 v6, v1
		s_xor_b32 s0, s0, -1
		s_add_i32 s0, s0, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v6, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v1, 0x10000, v3
		v_add3_u32 v1, v1, v14, v0
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[16:19], v1
		ds_read_b128 v[20:23], v1 offset:1024
		ds_read_b128 v[24:27], v1 offset:2048
		ds_read_b128 v[28:31], v1 offset:3072
		ds_read_b128 v[32:35], v1 offset:16384
		ds_read_b128 v[36:39], v1 offset:17408
		ds_read_b128 v[40:43], v1 offset:18432
		ds_read_b128 v[44:47], v1 offset:19456
		v_add_u32_e32 v1, 0x10000, v14
		v_add3_u32 v0, v1, v12, v0
		v_add_u32_e32 v0, 16, v0
		ds_read_b128 v[12:15], v0 offset:32768
		ds_read_b128 v[48:51], v0 offset:33792
		ds_read_b128 v[52:55], v0 offset:34816
		ds_read_b128 v[56:59], v0 offset:35840
		ds_read_b128 v[60:63], v0 offset:36864
		ds_read_b128 v[64:67], v0 offset:37888
		ds_read_b128 v[68:71], v0 offset:38912
		ds_read_b128 v[72:75], v0 offset:39936
		ds_read_b128 v[76:79], v0 offset:49152
		ds_read_b128 v[80:83], v0 offset:50176
		ds_read_b128 v[84:87], v0 offset:51200
		ds_read_b128 v[88:91], v0 offset:52224
		ds_read_b128 v[92:95], v0 offset:53248
		ds_read_b128 v[96:99], v0 offset:54272
		ds_read_b128 v[100:103], v0 offset:55296
		ds_read_b128 v[104:107], v0 offset:56320
		v_lshl_add_u32 v0, s7, 14, v2
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s2, 0x3000
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[2:3], v4 offset:8192
		ds_read_b64_tr_b8 v[6:7], v5 offset:10240
		ds_read_b64_tr_b8 v[108:109], v5 offset:10752
		ds_read_b64_tr_b8 v[110:111], v4 offset:12288
		ds_read_b64_tr_b8 v[112:113], v5 offset:14336
		ds_read_b64_tr_b8 v[114:115], v5 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[12:15], v[8:11], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[48:51], v[120:123], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[52:55], v[124:127], v2, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[56:59], v[128:131], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[56:59], v[160:163], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[12:15], v[148:151], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[48:51], v[152:155], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[52:55], v[156:159], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[52:55], v[188:191], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[12:15], v[180:183], v2, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[48:51], v[184:187], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[56:59], v[192:195], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[56:59], v[224:227], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[12:15], v[212:215], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[48:51], v[216:219], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[52:55], v[220:223], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[76:79], v[8:11], v110, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[80:83], v[120:123], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[84:87], v[124:127], v110, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[88:91], v[128:131], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[88:91], v[160:163], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[76:79], v[148:151], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[80:83], v[152:155], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[84:87], v[156:159], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[84:87], v[188:191], v110, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v8, v9
		v_cvt_pk_f16_f32 v5, v10, v11
		s_mov_b32 s35, s23
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[4:5], v0, s[32:35], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[76:79], v[180:183], v110, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[80:83], v[184:187], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[88:91], v[192:195], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[88:91], v[224:227], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[76:79], v[212:215], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[80:83], v[216:219], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[84:87], v[220:223], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		buffer_store_dwordx2 v[4:5], v0, s[32:35], 0 offen offset:512
		v_cvt_pk_f16_f32 v4, v124, v125
		v_cvt_pk_f16_f32 v5, v126, v127
		buffer_store_dwordx2 v[4:5], v0, s[32:35], 0 offen offset:1024
		v_cvt_pk_f16_f32 v4, v128, v129
		v_cvt_pk_f16_f32 v5, v130, v131
		buffer_store_dwordx2 v[4:5], v0, s[32:35], 0 offen offset:1536
		v_cvt_pk_f16_f32 v4, v148, v149
		v_cvt_pk_f16_f32 v5, v150, v151
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen
		v_cvt_pk_f16_f32 v4, v152, v153
		v_cvt_pk_f16_f32 v5, v154, v155
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:512
		v_cvt_pk_f16_f32 v4, v156, v157
		v_cvt_pk_f16_f32 v5, v158, v159
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:1024
		v_cvt_pk_f16_f32 v4, v160, v161
		v_cvt_pk_f16_f32 v5, v162, v163
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s0 offen offset:1536
		v_cvt_pk_f16_f32 v4, v180, v181
		v_cvt_pk_f16_f32 v5, v182, v183
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen
		v_cvt_pk_f16_f32 v4, v184, v185
		v_cvt_pk_f16_f32 v5, v186, v187
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen offset:512
		v_cvt_pk_f16_f32 v4, v188, v189
		v_cvt_pk_f16_f32 v5, v190, v191
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen offset:1024
		v_cvt_pk_f16_f32 v4, v192, v193
		v_cvt_pk_f16_f32 v5, v194, v195
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen offset:1536
		v_cvt_pk_f16_f32 v4, v212, v213
		v_cvt_pk_f16_f32 v5, v214, v215
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen
		v_cvt_pk_f16_f32 v4, v216, v217
		v_cvt_pk_f16_f32 v5, v218, v219
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:512
		v_cvt_pk_f16_f32 v4, v220, v221
		v_cvt_pk_f16_f32 v5, v222, v223
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:1024
		v_cvt_pk_f16_f32 v4, v224, v225
		v_cvt_pk_f16_f32 v5, v226, v227
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[60:63], v[132:135], v2, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[64:67], v[136:139], v2, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[68:71], v[140:143], v2, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[72:75], v[144:147], v2, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[72:75], v[176:179], v2, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[60:63], v[164:167], v2, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[64:67], v[168:171], v2, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[68:71], v[172:175], v2, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[68:71], v[204:207], v2, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[60:63], v[196:199], v2, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[64:67], v[200:203], v2, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[72:75], v[208:211], v2, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[72:75], v[240:243], v2, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[60:63], v[228:231], v2, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[64:67], v[232:235], v2, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[68:71], v[236:239], v2, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[92:95], v[132:135], v110, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[96:99], v[136:139], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[100:103], v[140:143], v110, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[104:107], v[144:147], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[104:107], v[176:179], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[92:95], v[164:167], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[96:99], v[168:171], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[100:103], v[172:175], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[100:103], v[204:207], v110, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[32:35], 0 offen offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[92:95], v[196:199], v110, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[96:99], v[200:203], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[104:107], v[208:211], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[104:107], v[240:243], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[92:95], v[228:231], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[96:99], v[232:235], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[100:103], v[236:239], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[32:35], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[32:35], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[32:35], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s2 offen offset:3584
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 256
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
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
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
