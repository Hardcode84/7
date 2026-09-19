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
		v_mov_b32_e32 v2, 0x24000
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
		s_mov_b32 s30, 0x2000000
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s4, s4, 6
		v_readfirstlane_b32 s5, v0
		s_lshr_b32 s12, s5, 6
		s_lshl_b32 s15, s12, 10
		s_mov_b32 m0, s15
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v3, 2, v1
		v_lshrrev_b32_e32 v4, 3, v1
		v_bitop3_b32 v5, v4, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v5, 4, v5
		v_lshl_add_u32 v3, v3, 12, v5
		s_lshl_b32 s18, s4, 16
		s_and_b32 s19, s13, 7
		s_lshr_b32 s19, s19, 1
		s_lshl_b32 s28, s19, 22
		s_add_i32 s28, s18, s28
		s_lshl_b32 s29, s13, 5
		s_lshl_b32 s14, s14, 1
		s_add_i32 s14, s29, s14
		s_lshr_b32 s13, s13, 3
		s_add_i32 s13, s14, s13
		s_and_b32 s13, s13, 63
		s_and_b32 s14, s13, 3
		s_lshl_b32 s29, s14, 20
		s_add_i32 s28, s28, s29
		buffer_load_dwordx4 v3, s[8:11], s28 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s29, s28, 0x80000
		buffer_load_dwordx4 v3, s[8:11], s29 offen lds
		v_lshlrev_b32_e32 v4, 12, v4
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s29, s28, 64
		buffer_load_dwordx4 v3, s[8:11], s29 offen lds
		s_lshr_b32 s5, s5, 7
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s29, s28, 0x80040
		buffer_load_dwordx4 v3, s[8:11], s29 offen lds
		s_lshr_b32 s13, s13, 2
		s_add_i32 m0, m0, 0xa000
		s_lshl_b32 s29, s13, 20
		s_add_i32 s18, s18, s29
		buffer_load_dwordx4 v3, s[0:3], s18 offen lds
		s_mov_b32 s29, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s31, s18, 0x80000
		buffer_load_dwordx4 v3, s[0:3], s31 offen lds
		v_and_b32_e32 v5, 39, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s31, s18, 64
		buffer_load_dwordx4 v3, s[0:3], s31 offen lds
		v_lshrrev_b32_e32 v6, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s31, s18, 0x80040
		s_lshl_b32 s32, s5, 9
		s_lshl_b32 s5, s5, 6
		s_lshl_b32 s33, s19, 10
		s_add_i32 s5, s5, s33
		s_lshl_b32 s33, s14, 8
		s_add_i32 s5, s5, s33
		v_and_or_b32 v7, 1, s4, v5
		buffer_load_dwordx4 v3, s[0:3], s31 offen lds
		v_cmp_eq_u32_e64 s[34:35], v7, s29
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s32, 0x20000
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], s5 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s31, s5, 16
		buffer_load_dwordx4 v4, s[24:27], s31 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s31, s5, 32
		buffer_load_dwordx4 v4, s[24:27], s31 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s31, s5, 48
		buffer_load_dwordx4 v4, s[24:27], s31 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[46:47]
		v_lshrrev_b32_e32 v6, 1, v6
		v_or_b32_e32 v5, v5, v6
		s_and_b32 s12, s12, 1
		v_cmp_eq_u32_e64 s[36:37], v5, s29
		s_lshl_b32 s31, s12, 10
		s_lshl_b32 s33, s13, 8
		s_lshl_b32 s12, s12, 7
		s_add_i32 s12, s33, s12
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s31, 0x22000
		s_nop 0
		buffer_load_dwordx4 v4, s[20:23], s12 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 16
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 32
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 48
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s33, s12, 64
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x50
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x60
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x70
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s32, 0x20800
		s_add_i32 s33, s5, 0x4000
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x4010
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x4020
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x4030
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s31, 0x22800
		s_add_i32 s33, s12, 0x4000
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4010
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4020
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4030
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s33, s12, 0x4040
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4050
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4060
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x4070
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s32, 0x21000
		s_add_i32 s33, s5, 0x8000
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x8010
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x8020
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0x8030
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s31, 0x23000
		s_add_i32 s33, s12, 0x8000
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8010
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8020
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8030
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s33, s12, 0x8040
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8050
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8060
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0x8070
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s32, 0x21800
		s_add_i32 s33, s5, 0xc000
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0xc010
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0xc020
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s5, 0xc030
		buffer_load_dwordx4 v4, s[24:27], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s31, 0x23800
		s_add_i32 s33, s12, 0xc000
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc010
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc020
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc030
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s33, s12, 0xc040
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc050
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc060
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s33, s12, 0xc070
		buffer_load_dwordx4 v4, s[20:23], s33 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[46:47]
		s_add_i32 m0, s15, 0x8000
		s_add_i32 s33, s28, 0x80
		buffer_load_dwordx4 v3, s[8:11], s33 offen lds
		v_lshlrev_b32_e32 v5, 1, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s28, 0x80080
		buffer_load_dwordx4 v3, s[8:11], s33 offen lds
		v_and_b32_e32 v0, 15, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s28, 0xc0
		buffer_load_dwordx4 v3, s[8:11], s33 offen lds
		v_and_b32_e32 v5, 15, v5
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s28, 0x800c0
		buffer_load_dwordx4 v3, s[8:11], s33 offen lds
		v_lshlrev_b32_e32 v5, 2, v5
		s_add_i32 m0, m0, 0xa000
		s_add_i32 s33, s18, 0x80
		buffer_load_dwordx4 v3, s[0:3], s33 offen lds
		s_and_b32 s33, s4, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s38, s18, 0x80080
		buffer_load_dwordx4 v3, s[0:3], s38 offen lds
		v_lshrrev_b32_e32 v6, 4, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s38, s18, 0xc0
		buffer_load_dwordx4 v3, s[0:3], s38 offen lds
		s_lshr_b32 s4, s4, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s38, s18, 0x800c0
		s_lshl_b32 s39, s4, 12
		s_lshl_b32 s40, s33, 13
		s_add_i32 s41, s40, 0x10000
		s_lshl_b32 s42, s4, 9
		s_lshl_b32 s43, s33, 10
		s_add_i32 s44, s39, 0x8000
		s_add_i32 s40, s40, 0x8000
		v_lshlrev_b32_e32 v7, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v6, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v12, s39, v7, v0
		v_add3_u32 v13, s41, v7, v0
		v_add3_u32 v14, s44, v7, v0
		v_add3_u32 v15, s40, v7, v0
		v_lshlrev_b32_e32 v0, 7, v6
		v_add3_u32 v7, s42, v0, v5
		buffer_load_dwordx4 v3, s[0:3], s38 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		ds_read_b128 v[32:35], v12 offset:16384
		ds_read_b128 v[36:39], v12 offset:17408
		ds_read_b128 v[40:43], v12 offset:18432
		ds_read_b128 v[44:47], v12 offset:19456
		ds_read_b128 v[48:51], v13
		ds_read_b128 v[52:55], v13 offset:1024
		ds_read_b128 v[56:59], v13 offset:2048
		ds_read_b128 v[60:63], v13 offset:3072
		ds_read_b128 v[64:67], v13 offset:4096
		ds_read_b128 v[68:71], v13 offset:5120
		ds_read_b128 v[72:75], v13 offset:6144
		ds_read_b128 v[76:79], v13 offset:7168
		ds_read_b128 v[80:83], v13 offset:16384
		ds_read_b128 v[84:87], v13 offset:17408
		ds_read_b128 v[88:91], v13 offset:18432
		ds_read_b128 v[92:95], v13 offset:19456
		ds_read_b128 v[96:99], v13 offset:20480
		ds_read_b128 v[100:103], v13 offset:21504
		ds_read_b128 v[104:107], v13 offset:22528
		ds_read_b128 v[108:111], v13 offset:23552
		v_add3_u32 v112, s43, v0, v5
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
		s_add_i32 s38, s29, 2
		s_waitcnt vmcnt(8) lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v113, 0x20000, v7
		ds_read_b64_tr_b8 v[114:115], v113
		v_add_u32_e32 v240, 0x20000, v112
		ds_read_b64_tr_b8 v[242:243], v240 offset:8192
		ds_read_b64_tr_b8 v[244:245], v240 offset:8704
		ds_read_b64_tr_b8 v[246:247], v113 offset:2048
		ds_read_b64_tr_b8 v[248:249], v240 offset:10240
		ds_read_b64_tr_b8 v[250:251], v240 offset:10752
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v114, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v114, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v114, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v114, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v114, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v114, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v114, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v114, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v114, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v114, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v114, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v114, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v114, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v114, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v114, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v114, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v246, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v246, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s39, s29, 1
		s_lshl_b32 s39, s39, 12
		s_add_i32 s40, s32, s39
		s_lshl_b32 s41, s29, 15
		s_add_i32 s44, s5, s41
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s40, 0x20000
		s_add_i32 s45, s44, 0x10000
		buffer_load_dwordx4 v4, s[24:27], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s44, 0x10010
		buffer_load_dwordx4 v4, s[24:27], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s44, 0x10020
		buffer_load_dwordx4 v4, s[24:27], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s44, 0x10030
		buffer_load_dwordx4 v4, s[24:27], s45 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[46:47]
		s_add_i32 s39, s31, s39
		s_add_i32 s41, s12, s41
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s39, 0x22000
		s_add_i32 s45, s41, 0x10000
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10010
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10020
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10030
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s45, s41, 0x10040
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10050
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10060
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s45, s41, 0x10070
		buffer_load_dwordx4 v4, s[20:23], s45 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s40, 0x20800
		s_add_i32 s40, s44, 0x14000
		buffer_load_dwordx4 v4, s[24:27], s40 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s40, s44, 0x14010
		buffer_load_dwordx4 v4, s[24:27], s40 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s40, s44, 0x14020
		buffer_load_dwordx4 v4, s[24:27], s40 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s40, s44, 0x14030
		buffer_load_dwordx4 v4, s[24:27], s40 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[46:47], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[46:47]
		s_and_saveexec_b64 s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s39, 0x22800
		s_add_i32 s39, s41, 0x14000
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14010
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14020
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14030
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s39, s41, 0x14040
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14050
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14060
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s39, s41, 0x14070
		buffer_load_dwordx4 v4, s[20:23], s39 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[46:47], s[36:37]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[46:47]
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v112, 0x1000, v112
		s_mov_b32 m0, s15
		v_add_u32_e32 v7, 0x1000, v7
		s_mul_i32 s38, s38, 0x80
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v114, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s39, s28, s38
		buffer_load_dwordx4 v3, s[8:11], s39 offen lds
		s_add_i32 s40, s39, 0x80000
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s41, s39, 64
		buffer_load_dwordx4 v3, s[8:11], s40 offen lds
		v_add_u32_e32 v113, 0x8000, v15
		v_add_u32_e32 v15, 0x10000, v15
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s39, s39, 0x80040
		buffer_load_dwordx4 v3, s[8:11], s41 offen lds
		v_add_u32_e32 v115, 0x8000, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v114, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s15, s15, 0x8000
		buffer_load_dwordx4 v3, s[8:11], s39 offen lds
		s_add_i32 s38, s18, s38
		s_add_i32 m0, m0, 0xa000
		s_add_i32 s39, s38, 0x80000
		buffer_load_dwordx4 v3, s[0:3], s38 offen lds
		s_add_i32 s40, s38, 64
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s38, s38, 0x80040
		buffer_load_dwordx4 v3, s[0:3], s39 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v114, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[76:79], v[140:143], v114, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[76:79], v[172:175], v114, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[0:3], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v114, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v114, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v114, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v114, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v114, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v114, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v114, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v114, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[76:79], v[204:207], v114, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[76:79], v[236:239], v114, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v114, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v246, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v246, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[108:111], v[140:143], v246, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[108:111], v[172:175], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[0:3], s38 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s15, s15, 0xffff
		s_add_i32 s29, s29, 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v246, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v246, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v246, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v246, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v246, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[108:111], v[204:207], v246, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[108:111], v[236:239], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v246, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v14
		ds_read_b128 v[20:23], v14 offset:1024
		ds_read_b128 v[24:27], v14 offset:2048
		ds_read_b128 v[28:31], v14 offset:3072
		ds_read_b128 v[32:35], v14 offset:16384
		ds_read_b128 v[36:39], v14 offset:17408
		ds_read_b128 v[40:43], v14 offset:18432
		ds_read_b128 v[44:47], v14 offset:19456
		ds_read_b128 v[48:51], v15
		ds_read_b128 v[52:55], v15 offset:1024
		ds_read_b128 v[56:59], v15 offset:2048
		ds_read_b128 v[60:63], v15 offset:3072
		ds_read_b128 v[64:67], v15 offset:4096
		ds_read_b128 v[68:71], v15 offset:5120
		ds_read_b128 v[72:75], v15 offset:6144
		ds_read_b128 v[76:79], v15 offset:7168
		ds_read_b128 v[80:83], v15 offset:16384
		ds_read_b128 v[84:87], v15 offset:17408
		ds_read_b128 v[88:91], v15 offset:18432
		ds_read_b128 v[92:95], v15 offset:19456
		ds_read_b128 v[96:99], v15 offset:20480
		ds_read_b128 v[100:103], v15 offset:21504
		ds_read_b128 v[104:107], v15 offset:22528
		ds_read_b128 v[108:111], v15 offset:23552
		v_and_b32_e32 v7, 0x1fff, v7
		v_and_b32_e32 v112, 0x1fff, v112
		v_and_b32_e32 v14, 0xffff, v115
		v_and_b32_e32 v15, 0xffff, v113
		s_cmp_lt_i32 s29, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s0, s42, 0x20000
		v_add3_u32 v3, s0, v0, v5
		ds_read_b64_tr_b8 v[14:15], v3
		s_add_i32 s0, s43, 0x20000
		v_add3_u32 v0, s0, v0, v5
		ds_read_b64_tr_b8 v[4:5], v0 offset:8192
		ds_read_b64_tr_b8 v[112:113], v0 offset:8704
		ds_read_b64_tr_b8 v[114:115], v3 offset:2048
		ds_read_b64_tr_b8 v[240:241], v0 offset:10240
		ds_read_b64_tr_b8 v[242:243], v0 offset:10752
		v_mov_b32_e32 v7, 1
		s_and_saveexec_b64 s[0:1], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v244, v2, v7
		s_mov_b64 exec, s[0:1]
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v14, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v14, v4 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v14, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v14, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[76:79], v[140:143], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[76:79], v[172:175], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v14, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v14, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[76:79], v[204:207], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[76:79], v[236:239], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v14, v4 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v14, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v114, v240 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v114, v240 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v114, v240 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v114, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v114, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v114, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[108:111], v[140:143], v114, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[108:111], v[172:175], v114, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v114, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v114, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v114, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v114, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v114, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v114, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v114, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v114, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v114, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[108:111], v[204:207], v114, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[108:111], v[236:239], v114, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v114, v240 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v114, v240 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v114, v240 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v114, v240 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v114, v240 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v114, v240 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v114, v240 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s0, v244
		s_and_b32 s0, s0, -8
		s_add_i32 s0, s0, 8
		s_and_saveexec_b64 s[2:3], s[16:17]
		ds_read_b32 v4, v2
		s_xor_b32 s0, s0, -1
		s_add_i32 s0, s0, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v4, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v4
		s_add_i32 s1, s1, s0
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[2:3]
		ds_read_b128 v[16:19], v12 offset:32768
		ds_read_b128 v[20:23], v12 offset:33792
		ds_read_b128 v[24:27], v12 offset:34816
		ds_read_b128 v[28:31], v12 offset:35840
		ds_read_b128 v[32:35], v12 offset:49152
		ds_read_b128 v[36:39], v12 offset:50176
		ds_read_b128 v[40:43], v12 offset:51200
		ds_read_b128 v[44:47], v12 offset:52224
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
		v_and_b32_e32 v1, 15, v1
		v_lshlrev_b32_e32 v1, 13, v1
		v_lshl_add_u32 v1, v6, 3, v1
		s_lshl_b32 s0, s4, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v3 offset:4096
		ds_read_b64_tr_b8 v[6:7], v0 offset:12288
		ds_read_b64_tr_b8 v[12:13], v0 offset:12800
		ds_read_b64_tr_b8 v[14:15], v3 offset:6144
		ds_read_b64_tr_b8 v[2:3], v0 offset:14336
		ds_read_b64_tr_b8 v[112:113], v0 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[48:51], v[8:11], v4, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s13, 21
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s19, 11
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[52:55], v[116:119], v4, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s33, 20
		s_add_i32 s0, s0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v4, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s14, 9
		s_add_i32 s0, s0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[60:63], v[124:127], v4, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[60:63], v[156:159], v4, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[48:51], v[144:147], v4, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[52:55], v[148:151], v4, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[56:59], v[152:155], v4, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[56:59], v[184:187], v4, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[56:59], v[216:219], v4, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[48:51], v[176:179], v4, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[48:51], v[208:211], v4, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[52:55], v[180:183], v4, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[52:55], v[212:215], v4, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v4, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[60:63], v[220:223], v4, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[80:83], v[8:11], v14, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[84:87], v[116:119], v14, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[88:91], v[120:123], v14, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[92:95], v[124:127], v14, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[92:95], v[156:159], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[80:83], v[144:147], v14, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[84:87], v[148:151], v14, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[88:91], v[152:155], v14, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[88:91], v[184:187], v14, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[88:91], v[216:219], v14, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v6, v8, v9
		v_cvt_pk_f16_f32 v7, v10, v11
		v_cvt_pk_f16_f32 v8, v116, v117
		v_cvt_pk_f16_f32 v9, v118, v119
		v_cvt_pk_f16_f32 v10, v120, v121
		v_cvt_pk_f16_f32 v11, v122, v123
		v_cvt_pk_f16_f32 v48, v124, v125
		v_cvt_pk_f16_f32 v49, v126, v127
		v_cvt_pk_f16_f32 v50, v144, v145
		v_cvt_pk_f16_f32 v51, v146, v147
		v_cvt_pk_f16_f32 v52, v148, v149
		v_cvt_pk_f16_f32 v53, v150, v151
		v_cvt_pk_f16_f32 v54, v152, v153
		v_cvt_pk_f16_f32 v55, v154, v155
		v_cvt_pk_f16_f32 v56, v156, v157
		v_cvt_pk_f16_f32 v57, v158, v159
		v_cvt_pk_f16_f32 v58, v184, v185
		v_cvt_pk_f16_f32 v59, v186, v187
		v_cvt_pk_f16_f32 v60, v216, v217
		v_cvt_pk_f16_f32 v61, v218, v219
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s31, s23
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[6:7], v1, s[28:31], s0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[80:83], v[176:179], v14, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[80:83], v[208:211], v14, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[84:87], v[180:183], v14, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[84:87], v[212:215], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[92:95], v[188:191], v14, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[92:95], v[220:223], v14, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s1, s0, 0x20000
		buffer_store_dwordx2 v[8:9], v1, s[28:31], s1 offen
		s_add_i32 s2, s0, 0x40000
		buffer_store_dwordx2 v[10:11], v1, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		v_cvt_pk_f16_f32 v6, v180, v181
		v_cvt_pk_f16_f32 v7, v182, v183
		v_cvt_pk_f16_f32 v8, v188, v189
		v_cvt_pk_f16_f32 v9, v190, v191
		v_cvt_pk_f16_f32 v10, v208, v209
		v_cvt_pk_f16_f32 v11, v210, v211
		v_cvt_pk_f16_f32 v62, v212, v213
		v_cvt_pk_f16_f32 v63, v214, v215
		v_cvt_pk_f16_f32 v80, v220, v221
		v_cvt_pk_f16_f32 v81, v222, v223
		s_add_i32 s3, s0, 0x60000
		buffer_store_dwordx2 v[48:49], v1, s[28:31], s3 offen
		buffer_store_dwordx2 v[50:51], v1, s[28:31], s0 offen offset:32
		buffer_store_dwordx2 v[52:53], v1, s[28:31], s1 offen offset:32
		buffer_store_dwordx2 v[54:55], v1, s[28:31], s2 offen offset:32
		buffer_store_dwordx2 v[56:57], v1, s[28:31], s3 offen offset:32
		buffer_store_dwordx2 v[2:3], v1, s[28:31], s0 offen offset:64
		buffer_store_dwordx2 v[6:7], v1, s[28:31], s1 offen offset:64
		buffer_store_dwordx2 v[58:59], v1, s[28:31], s2 offen offset:64
		buffer_store_dwordx2 v[8:9], v1, s[28:31], s3 offen offset:64
		buffer_store_dwordx2 v[10:11], v1, s[28:31], s0 offen offset:96
		buffer_store_dwordx2 v[62:63], v1, s[28:31], s1 offen offset:96
		buffer_store_dwordx2 v[60:61], v1, s[28:31], s2 offen offset:96
		buffer_store_dwordx2 v[80:81], v1, s[28:31], s3 offen offset:96
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[64:67], v[128:131], v4, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s1, s0, 0x80000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[68:71], v[132:135], v4, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[72:75], v[136:139], v4, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[76:79], v[140:143], v4, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[76:79], v[172:175], v4, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[64:67], v[160:163], v4, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[68:71], v[164:167], v4, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[72:75], v[168:171], v4, v12 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[72:75], v[200:203], v4, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[72:75], v[232:235], v4, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[64:67], v[192:195], v4, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[64:67], v[224:227], v4, v12 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[68:71], v[196:199], v4, v12 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[76:79], v[204:207], v4, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[76:79], v[236:239], v4, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[68:71], v[228:231], v4, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[96:99], v[128:131], v14, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[100:103], v[132:135], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[104:107], v[136:139], v14, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[108:111], v[140:143], v14, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[108:111], v[172:175], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[96:99], v[160:163], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[100:103], v[164:167], v14, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[104:107], v[168:171], v14, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[104:107], v[200:203], v14, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[104:107], v[232:235], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v16, v168, v169
		v_cvt_pk_f16_f32 v17, v170, v171
		v_cvt_pk_f16_f32 v18, v172, v173
		v_cvt_pk_f16_f32 v19, v174, v175
		v_cvt_pk_f16_f32 v20, v200, v201
		v_cvt_pk_f16_f32 v21, v202, v203
		v_cvt_pk_f16_f32 v22, v232, v233
		v_cvt_pk_f16_f32 v23, v234, v235
		buffer_store_dwordx2 v[2:3], v1, s[28:31], s1 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[96:99], v[192:195], v14, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[96:99], v[224:227], v14, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[100:103], v[196:199], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[108:111], v[204:207], v14, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[108:111], v[236:239], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[100:103], v[228:231], v14, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s0, 0xa0000
		buffer_store_dwordx2 v[4:5], v1, s[28:31], s2 offen
		s_add_i32 s3, s0, 0xc0000
		buffer_store_dwordx2 v[6:7], v1, s[28:31], s3 offen
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		v_cvt_pk_f16_f32 v4, v196, v197
		v_cvt_pk_f16_f32 v5, v198, v199
		v_cvt_pk_f16_f32 v6, v204, v205
		v_cvt_pk_f16_f32 v7, v206, v207
		v_cvt_pk_f16_f32 v14, v224, v225
		v_cvt_pk_f16_f32 v15, v226, v227
		v_cvt_pk_f16_f32 v24, v228, v229
		v_cvt_pk_f16_f32 v25, v230, v231
		v_cvt_pk_f16_f32 v26, v236, v237
		v_cvt_pk_f16_f32 v27, v238, v239
		s_add_i32 s0, s0, 0xe0000
		buffer_store_dwordx2 v[8:9], v1, s[28:31], s0 offen
		buffer_store_dwordx2 v[10:11], v1, s[28:31], s1 offen offset:32
		buffer_store_dwordx2 v[12:13], v1, s[28:31], s2 offen offset:32
		buffer_store_dwordx2 v[16:17], v1, s[28:31], s3 offen offset:32
		buffer_store_dwordx2 v[18:19], v1, s[28:31], s0 offen offset:32
		buffer_store_dwordx2 v[2:3], v1, s[28:31], s1 offen offset:64
		buffer_store_dwordx2 v[4:5], v1, s[28:31], s2 offen offset:64
		buffer_store_dwordx2 v[20:21], v1, s[28:31], s3 offen offset:64
		buffer_store_dwordx2 v[6:7], v1, s[28:31], s0 offen offset:64
		buffer_store_dwordx2 v[14:15], v1, s[28:31], s1 offen offset:96
		buffer_store_dwordx2 v[24:25], v1, s[28:31], s2 offen offset:96
		buffer_store_dwordx2 v[22:23], v1, s[28:31], s3 offen offset:96
		buffer_store_dwordx2 v[26:27], v1, s[28:31], s0 offen offset:96
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 147472
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
		.amdhsa_next_free_vgpr 252
		.amdhsa_next_free_sgpr 48
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 252
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 48
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
    .group_segment_fixed_size: 147472
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     48
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     252
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
