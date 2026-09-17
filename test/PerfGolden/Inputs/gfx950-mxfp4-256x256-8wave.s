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
		s_mov_b32 m0, s15
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v4, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v4, 4, v4
		v_lshl_add_u32 v2, v2, 12, v4
		s_lshl_b32 s18, s0, 16
		s_and_b32 s19, s13, 7
		s_lshr_b32 s19, s19, 1
		s_lshl_b32 s32, s19, 22
		s_add_i32 s32, s18, s32
		s_lshl_b32 s33, s13, 5
		s_lshl_b32 s14, s14, 1
		s_add_i32 s14, s33, s14
		s_lshr_b32 s13, s13, 3
		s_add_i32 s13, s14, s13
		s_and_b32 s13, s13, 63
		s_and_b32 s14, s13, 3
		s_lshl_b32 s33, s14, 20
		s_add_i32 s32, s32, s33
		buffer_load_dwordx4 v2, s[8:11], s32 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s32, 0x80000
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		v_lshlrev_b32_e32 v3, 12, v3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s32, 64
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		s_lshr_b32 s1, s1, 7
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s33, s32, 0x80040
		buffer_load_dwordx4 v2, s[8:11], s33 offen lds
		s_lshr_b32 s13, s13, 2
		s_add_i32 m0, m0, 0xa000
		s_lshl_b32 s33, s13, 20
		s_add_i32 s18, s18, s33
		buffer_load_dwordx4 v2, s[28:31], s18 offen lds
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s35, s18, 0x80000
		buffer_load_dwordx4 v2, s[28:31], s35 offen lds
		v_and_b32_e32 v8, 39, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s35, s18, 64
		buffer_load_dwordx4 v2, s[28:31], s35 offen lds
		v_lshrrev_b32_e32 v9, 6, v0
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s35, s18, 0x80040
		s_lshl_b32 s36, s1, 9
		s_lshl_b32 s1, s1, 6
		s_lshl_b32 s37, s19, 10
		s_add_i32 s1, s1, s37
		s_lshl_b32 s37, s14, 8
		s_add_i32 s1, s1, s37
		v_and_or_b32 v10, 1, s0, v8
		buffer_load_dwordx4 v2, s[28:31], s35 offen lds
		v_cmp_eq_u32_e64 s[38:39], v10, s33
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s36, 0x20000
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], s1 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s35, s1, 16
		buffer_load_dwordx4 v3, s[24:27], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s35, s1, 32
		buffer_load_dwordx4 v3, s[24:27], s35 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s35, s1, 48
		buffer_load_dwordx4 v3, s[24:27], s35 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[44:45]
		v_lshrrev_b32_e32 v9, 1, v9
		v_or_b32_e32 v8, v8, v9
		s_and_b32 s12, s12, 1
		v_cmp_eq_u32_e64 s[40:41], v8, s33
		s_lshl_b32 s35, s12, 10
		s_lshl_b32 s37, s13, 8
		s_lshl_b32 s12, s12, 7
		s_add_i32 s12, s37, s12
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s35, 0x22000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], s12 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 16
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 32
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 48
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s37, s12, 64
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x50
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x60
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x70
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s36, 0x20800
		s_add_i32 s37, s1, 0x4000
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x4010
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x4020
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x4030
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s35, 0x22800
		s_add_i32 s37, s12, 0x4000
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4010
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4020
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4030
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s37, s12, 0x4040
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4050
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4060
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x4070
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s36, 0x21000
		s_add_i32 s37, s1, 0x8000
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x8010
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x8020
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0x8030
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s35, 0x23000
		s_add_i32 s37, s12, 0x8000
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8010
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8020
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8030
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s37, s12, 0x8040
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8050
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8060
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0x8070
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s36, 0x21800
		s_add_i32 s37, s1, 0xc000
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0xc010
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0xc020
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s1, 0xc030
		buffer_load_dwordx4 v3, s[24:27], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s35, 0x23800
		s_add_i32 s37, s12, 0xc000
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc010
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc020
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc030
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s37, s12, 0xc040
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc050
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc060
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s37, s12, 0xc070
		buffer_load_dwordx4 v3, s[20:23], s37 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[44:45]
		s_add_i32 m0, s15, 0x8000
		s_add_i32 s37, s32, 0x80
		buffer_load_dwordx4 v2, s[8:11], s37 offen lds
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s32, 0x80080
		buffer_load_dwordx4 v2, s[8:11], s2 offen lds
		v_add_u32_e32 v8, s18, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s32, 0xc0
		buffer_load_dwordx4 v2, s[8:11], s2 offen lds
		v_add_u32_e32 v9, s32, v2
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s2, s32, 0x800c0
		buffer_load_dwordx4 v2, s[8:11], s2 offen lds
		v_lshlrev_b32_e32 v10, 1, v0
		s_add_i32 m0, m0, 0xa000
		s_add_i32 s2, s18, 0x80
		buffer_load_dwordx4 v2, s[28:31], s2 offen lds
		s_and_b32 s2, s0, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s18, 0x80080
		buffer_load_dwordx4 v2, s[28:31], s3 offen lds
		v_lshrrev_b32_e32 v1, 4, v1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s18, 0xc0
		buffer_load_dwordx4 v2, s[28:31], s3 offen lds
		s_lshr_b32 s0, s0, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s3, s18, 0x800c0
		v_and_b32_e32 v11, 15, v0
		v_and_b32_e32 v10, 15, v10
		v_lshlrev_b32_e32 v10, 2, v10
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_lshl_b32 s4, s0, 12
		s_lshl_b32 s5, s2, 13
		s_add_i32 s18, s5, 0x10000
		s_lshl_b32 s32, s0, 9
		s_lshl_b32 s37, s2, 10
		s_add_i32 s42, s4, 0x8000
		s_add_i32 s5, s5, 0x8000
		v_lshlrev_b32_e32 v12, 6, v11
		v_lshrrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v11, v1, v11, 3 bitop3:0x78
		v_lshlrev_b32_e32 v11, 4, v11
		buffer_load_dwordx4 v2, s[28:31], s3 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_add3_u32 v2, s4, v12, v11
		v_add3_u32 v13, s18, v12, v11
		v_add3_u32 v14, s42, v12, v11
		v_add3_u32 v15, s5, v12, v11
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 v[32:35], v2 offset:16384
		ds_read_b128 v[36:39], v2 offset:17408
		ds_read_b128 v[40:43], v2 offset:18432
		ds_read_b128 v[44:47], v2 offset:19456
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
		v_lshlrev_b32_e32 v1, 7, v1
		v_add3_u32 v11, s32, v1, v10
		v_add3_u32 v12, s37, v1, v10
		v_add_u32_e32 v112, 0x100, v9
		v_add_u32_e32 v113, 0x80100, v9
		v_add_u32_e32 v114, 0x140, v9
		v_add_u32_e32 v9, 0x80140, v9
		v_add_u32_e32 v115, 0x100, v8
		v_add_u32_e32 v116, 0x80100, v8
		v_add_u32_e32 v117, 0x140, v8
		v_add_u32_e32 v8, 0x80140, v8
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
		v_add_u32_e32 v118, 0x20000, v11
		ds_read_b64_tr_b8 v[244:245], v118
		v_add_u32_e32 v119, 0x20000, v12
		ds_read_b64_tr_b8 v[246:247], v119 offset:8192
		ds_read_b64_tr_b8 v[248:249], v119 offset:8704
		ds_read_b64_tr_b8 v[250:251], v118 offset:2048
		ds_read_b64_tr_b8 v[252:253], v119 offset:10240
		ds_read_b64_tr_b8 v[254:255], v119 offset:10752
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s3, s33, 1
		s_lshl_b32 s3, s3, 12
		s_add_i32 s4, s36, s3
		s_lshl_b32 s5, s33, 15
		s_add_i32 s18, s1, s5
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s4, 0x20000
		s_add_i32 s42, s18, 0x10000
		buffer_load_dwordx4 v3, s[24:27], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s18, 0x10010
		buffer_load_dwordx4 v3, s[24:27], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s18, 0x10020
		buffer_load_dwordx4 v3, s[24:27], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s18, 0x10030
		buffer_load_dwordx4 v3, s[24:27], s42 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[44:45]
		s_add_i32 s3, s35, s3
		s_add_i32 s5, s12, s5
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s3, 0x22000
		s_add_i32 s42, s5, 0x10000
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10010
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10020
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10030
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s42, s5, 0x10040
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10050
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10060
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s42, s5, 0x10070
		buffer_load_dwordx4 v3, s[20:23], s42 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s4, 0x20800
		s_add_i32 s4, s18, 0x14000
		buffer_load_dwordx4 v3, s[24:27], s4 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s4, s18, 0x14010
		buffer_load_dwordx4 v3, s[24:27], s4 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s4, s18, 0x14020
		buffer_load_dwordx4 v3, s[24:27], s4 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s4, s18, 0x14030
		buffer_load_dwordx4 v3, s[24:27], s4 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[44:45], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[44:45]
		s_and_saveexec_b64 s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s3, 0x22800
		s_add_i32 s3, s5, 0x14000
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14010
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14020
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14030
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1d0
		s_add_i32 s3, s5, 0x14040
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14050
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14060
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
		s_nop 0
		s_add_i32 m0, m0, 16
		s_add_i32 s3, s5, 0x14070
		buffer_load_dwordx4 v3, s[20:23], s3 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[44:45], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[44:45]
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 m0, s15
		s_add_i32 s3, s15, 0x8000
		buffer_load_dwordx4 v112, s[8:11], 0 offen lds
		v_add_u32_e32 v11, 0x1000, v11
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v113, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v114, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0xa000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v115, s[28:31], 0 offen lds
		v_add_u32_e32 v118, 0x8000, v15
		v_add_u32_e32 v15, 0x10000, v15
		s_add_i32 m0, m0, 0x2000
		v_add_u32_e32 v12, 0x1000, v12
		buffer_load_dwordx4 v116, s[28:31], 0 offen lds
		v_add_u32_e32 v119, 0x8000, v14
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v117, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_and_b32 s15, s3, 0xffff
		s_add_u32 s8, s8, 0x80
		s_addc_u32 s9, s9, 0
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_u32 s28, s28, 0x80
		s_addc_u32 s29, s29, 0
		s_add_i32 s33, s33, 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
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
		v_and_b32_e32 v11, 0x1fff, v11
		v_and_b32_e32 v12, 0x1fff, v12
		v_and_b32_e32 v14, 0xffff, v119
		v_and_b32_e32 v15, 0xffff, v118
		s_cmp_lt_i32 s33, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s1, s32, 0x20000
		v_add3_u32 v3, s1, v1, v10
		ds_read_b64_tr_b8 v[8:9], v3
		s_add_i32 s1, s37, 0x20000
		v_add3_u32 v1, s1, v1, v10
		ds_read_b64_tr_b8 v[10:11], v1 offset:8192
		ds_read_b64_tr_b8 v[14:15], v1 offset:8704
		ds_read_b64_tr_b8 v[112:113], v3 offset:2048
		ds_read_b64_tr_b8 v[114:115], v1 offset:10240
		ds_read_b64_tr_b8 v[116:117], v1 offset:10752
		v_mov_b32_e32 v12, 1
		s_and_saveexec_b64 s[4:5], s[16:17]
		v_mov_b32_e32 v118, 0x24000
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v119, v118, v12
		s_mov_b64 exec, s[4:5]
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v8, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v8, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v8, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v8, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v8, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v8, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v8, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v8, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v8, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v8, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v8, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v8, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v8, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v8, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v112, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v112, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v112, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v112, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v112, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v112, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v112, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v112, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v112, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v112, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v112, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v112, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v112, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v112, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v112, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v112, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v112, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v112, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v112, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v112, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v119
		s_and_b32 s1, s1, -8
		s_add_i32 s1, s1, 8
		s_and_saveexec_b64 s[4:5], s[16:17]
		ds_read_b32 v8, v118
		s_xor_b32 s1, s1, -1
		s_add_i32 s1, s1, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v8
		s_add_i32 s3, s3, s1
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v8, v118
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v8
		s_add_i32 s3, s3, s1
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[4:5]
		ds_read_b128 v[8:11], v2 offset:32768
		ds_read_b128 v[16:19], v2 offset:33792
		ds_read_b128 v[20:23], v2 offset:34816
		ds_read_b128 v[24:27], v2 offset:35840
		ds_read_b128 v[28:31], v2 offset:49152
		ds_read_b128 v[32:35], v2 offset:50176
		ds_read_b128 v[36:39], v2 offset:51200
		ds_read_b128 v[40:43], v2 offset:52224
		ds_read_b128 v[44:47], v13 offset:32768
		ds_read_b128 v[48:51], v13 offset:33792
		ds_read_b128 v[52:55], v13 offset:34816
		ds_read_b128 v[56:59], v13 offset:35840
		ds_read_b128 v[60:63], v13 offset:36864
		ds_read_b128 v[64:67], v13 offset:37888
		ds_read_b128 v[68:71], v13 offset:38912
		ds_read_b128 v[72:75], v13 offset:39936
		ds_read_b128 v[76:79], v13 offset:49152
		ds_read_b128 v[80:83], v13 offset:50176
		ds_read_b128 v[84:87], v13 offset:51200
		ds_read_b128 v[88:91], v13 offset:52224
		ds_read_b128 v[92:95], v13 offset:53248
		ds_read_b128 v[96:99], v13 offset:54272
		ds_read_b128 v[100:103], v13 offset:55296
		ds_read_b128 v[104:107], v13 offset:56320
		v_and_b32_e32 v0, 63, v0
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v2, 13, v2
		v_lshrrev_b32_e32 v0, 4, v0
		v_lshl_add_u32 v0, v0, 3, v2
		s_lshl_b32 s0, s0, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[12:13], v3 offset:4096
		ds_read_b64_tr_b8 v[14:15], v1 offset:12288
		ds_read_b64_tr_b8 v[108:109], v1 offset:12800
		ds_read_b64_tr_b8 v[110:111], v3 offset:6144
		ds_read_b64_tr_b8 v[2:3], v1 offset:14336
		ds_read_b64_tr_b8 v[112:113], v1 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[8:11], v[44:47], v[4:7], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s13, 21
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s19, 11
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[48:51], v[120:123], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s2, 20
		s_add_i32 s0, s0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[8:11], v[52:55], v[124:127], v12, v14 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_lshl_b32 s1, s14, 9
		s_add_i32 s0, s0, s1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[56:59], v[128:131], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[56:59], v[160:163], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[44:47], v[148:151], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[48:51], v[152:155], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[52:55], v[156:159], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[52:55], v[188:191], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[52:55], v[220:223], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[44:47], v[180:183], v12, v14 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[44:47], v[212:215], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[48:51], v[184:187], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[48:51], v[216:219], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[56:59], v[192:195], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], v[56:59], v[224:227], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[28:31], v[76:79], v[4:7], v110, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[28:31], v[80:83], v[120:123], v110, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[28:31], v[84:87], v[124:127], v110, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], v[88:91], v[128:131], v110, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[32:35], v[88:91], v[160:163], v110, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], v[76:79], v[148:151], v110, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], v[80:83], v[152:155], v110, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], v[84:87], v[156:159], v110, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[36:39], v[84:87], v[188:191], v110, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], v[84:87], v[220:223], v110, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v14, v4, v5
		v_cvt_pk_f16_f32 v15, v6, v7
		v_cvt_pk_f16_f32 v4, v120, v121
		v_cvt_pk_f16_f32 v5, v122, v123
		v_cvt_pk_f16_f32 v6, v124, v125
		v_cvt_pk_f16_f32 v7, v126, v127
		v_cvt_pk_f16_f32 v44, v128, v129
		v_cvt_pk_f16_f32 v45, v130, v131
		v_cvt_pk_f16_f32 v46, v148, v149
		v_cvt_pk_f16_f32 v47, v150, v151
		v_cvt_pk_f16_f32 v48, v152, v153
		v_cvt_pk_f16_f32 v49, v154, v155
		v_cvt_pk_f16_f32 v50, v156, v157
		v_cvt_pk_f16_f32 v51, v158, v159
		v_cvt_pk_f16_f32 v52, v160, v161
		v_cvt_pk_f16_f32 v53, v162, v163
		v_cvt_pk_f16_f32 v54, v188, v189
		v_cvt_pk_f16_f32 v55, v190, v191
		v_cvt_pk_f16_f32 v56, v220, v221
		v_cvt_pk_f16_f32 v57, v222, v223
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s35, s23
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[14:15], v0, s[32:35], s0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], v[76:79], v[180:183], v110, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], v[76:79], v[212:215], v110, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], v[80:83], v[184:187], v110, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], v[80:83], v[216:219], v110, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[36:39], v[88:91], v[192:195], v110, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[88:91], v[224:227], v110, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s1, s0, 0x20000
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen
		s_add_i32 s2, s0, 0x40000
		buffer_store_dwordx2 v[6:7], v0, s[32:35], s2 offen
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		v_cvt_pk_f16_f32 v4, v184, v185
		v_cvt_pk_f16_f32 v5, v186, v187
		v_cvt_pk_f16_f32 v6, v192, v193
		v_cvt_pk_f16_f32 v7, v194, v195
		v_cvt_pk_f16_f32 v14, v212, v213
		v_cvt_pk_f16_f32 v15, v214, v215
		v_cvt_pk_f16_f32 v58, v216, v217
		v_cvt_pk_f16_f32 v59, v218, v219
		v_cvt_pk_f16_f32 v76, v224, v225
		v_cvt_pk_f16_f32 v77, v226, v227
		s_add_i32 s3, s0, 0x60000
		buffer_store_dwordx2 v[44:45], v0, s[32:35], s3 offen
		buffer_store_dwordx2 v[46:47], v0, s[32:35], s0 offen offset:32
		buffer_store_dwordx2 v[48:49], v0, s[32:35], s1 offen offset:32
		buffer_store_dwordx2 v[50:51], v0, s[32:35], s2 offen offset:32
		buffer_store_dwordx2 v[52:53], v0, s[32:35], s3 offen offset:32
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s0 offen offset:64
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s1 offen offset:64
		buffer_store_dwordx2 v[54:55], v0, s[32:35], s2 offen offset:64
		buffer_store_dwordx2 v[6:7], v0, s[32:35], s3 offen offset:64
		buffer_store_dwordx2 v[14:15], v0, s[32:35], s0 offen offset:96
		buffer_store_dwordx2 v[58:59], v0, s[32:35], s1 offen offset:96
		buffer_store_dwordx2 v[56:57], v0, s[32:35], s2 offen offset:96
		buffer_store_dwordx2 v[76:77], v0, s[32:35], s3 offen offset:96
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[60:63], v[132:135], v12, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s1, s0, 0x80000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[64:67], v[136:139], v12, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[68:71], v[140:143], v12, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[72:75], v[144:147], v12, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[72:75], v[176:179], v12, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[60:63], v[164:167], v12, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[64:67], v[168:171], v12, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[68:71], v[172:175], v12, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], v[68:71], v[204:207], v12, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[24:27], v[68:71], v[236:239], v12, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], v[60:63], v[196:199], v12, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], v[60:63], v[228:231], v12, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], v[64:67], v[200:203], v12, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], v[72:75], v[208:211], v12, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[24:27], v[72:75], v[240:243], v12, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[24:27], v[64:67], v[232:235], v12, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], v[92:95], v[132:135], v110, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[96:99], v[136:139], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[100:103], v[140:143], v110, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[104:107], v[144:147], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], v[104:107], v[176:179], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], v[92:95], v[164:167], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], v[96:99], v[168:171], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], v[100:103], v[172:175], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], v[100:103], v[204:207], v110, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], v[100:103], v[236:239], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		v_cvt_pk_f16_f32 v4, v136, v137
		v_cvt_pk_f16_f32 v5, v138, v139
		v_cvt_pk_f16_f32 v6, v140, v141
		v_cvt_pk_f16_f32 v7, v142, v143
		v_cvt_pk_f16_f32 v8, v144, v145
		v_cvt_pk_f16_f32 v9, v146, v147
		v_cvt_pk_f16_f32 v10, v164, v165
		v_cvt_pk_f16_f32 v11, v166, v167
		v_cvt_pk_f16_f32 v12, v168, v169
		v_cvt_pk_f16_f32 v13, v170, v171
		v_cvt_pk_f16_f32 v14, v172, v173
		v_cvt_pk_f16_f32 v15, v174, v175
		v_cvt_pk_f16_f32 v16, v176, v177
		v_cvt_pk_f16_f32 v17, v178, v179
		v_cvt_pk_f16_f32 v18, v204, v205
		v_cvt_pk_f16_f32 v19, v206, v207
		v_cvt_pk_f16_f32 v20, v236, v237
		v_cvt_pk_f16_f32 v21, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[92:95], v[196:199], v110, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[92:95], v[228:231], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[96:99], v[200:203], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], v[104:107], v[208:211], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], v[104:107], v[240:243], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[96:99], v[232:235], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_add_i32 s2, s0, 0xa0000
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen
		s_add_i32 s3, s0, 0xc0000
		buffer_store_dwordx2 v[6:7], v0, s[32:35], s3 offen
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		v_cvt_pk_f16_f32 v4, v200, v201
		v_cvt_pk_f16_f32 v5, v202, v203
		v_cvt_pk_f16_f32 v6, v208, v209
		v_cvt_pk_f16_f32 v7, v210, v211
		v_cvt_pk_f16_f32 v22, v228, v229
		v_cvt_pk_f16_f32 v23, v230, v231
		v_cvt_pk_f16_f32 v24, v232, v233
		v_cvt_pk_f16_f32 v25, v234, v235
		v_cvt_pk_f16_f32 v26, v240, v241
		v_cvt_pk_f16_f32 v27, v242, v243
		s_add_i32 s0, s0, 0xe0000
		buffer_store_dwordx2 v[8:9], v0, s[32:35], s0 offen
		buffer_store_dwordx2 v[10:11], v0, s[32:35], s1 offen offset:32
		buffer_store_dwordx2 v[12:13], v0, s[32:35], s2 offen offset:32
		buffer_store_dwordx2 v[14:15], v0, s[32:35], s3 offen offset:32
		buffer_store_dwordx2 v[16:17], v0, s[32:35], s0 offen offset:32
		buffer_store_dwordx2 v[2:3], v0, s[32:35], s1 offen offset:64
		buffer_store_dwordx2 v[4:5], v0, s[32:35], s2 offen offset:64
		buffer_store_dwordx2 v[18:19], v0, s[32:35], s3 offen offset:64
		buffer_store_dwordx2 v[6:7], v0, s[32:35], s0 offen offset:64
		buffer_store_dwordx2 v[22:23], v0, s[32:35], s1 offen offset:96
		buffer_store_dwordx2 v[24:25], v0, s[32:35], s2 offen offset:96
		buffer_store_dwordx2 v[20:21], v0, s[32:35], s3 offen offset:96
		buffer_store_dwordx2 v[26:27], v0, s[32:35], s0 offen offset:96
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 46
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 46
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
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 4
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 3
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
